local ffi = require('ffi')
local vector = require("vector")
local pui = require("gamesense/pui")
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard")
local weapons = require("gamesense/csgo_weapons")
local entity_lib = require("gamesense/entity")
local antiaim_funcs = require("gamesense/antiaim_funcs")
local trace = require('gamesense/trace')
local images = require 'gamesense/images'
local csgo_weapons = require("gamesense/csgo_weapons")
local http = require("gamesense/http")
local lua_color = {r = 176, g = 149, b = 255} --204, 135, 255 rgb(142, 153, 255) rgb(176, 183, 255)
local data = obex_fetch and obex_fetch() or {username = 'admin', build = 'private', discord=''}
local steamworks = require("gamesense/steamworks")

--pos_wtm

local valuwes = {
	paketa_pitch = 0,
}

local login = {
    username = data.username,
    version = "1.0.0",
    build = data.build,
}

if login.build == 'User' then
    login.build = 'Live'
end


local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)

local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)

local native_GetNetChannelInfo = vtable_bind("engine.dll", "VEngineClient014", 78, "void* (__thiscall*)(void* ecx)")
local native_GetLatency = vtable_thunk(9, "float(__thiscall*)(void*, int)")
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity is nil', 2)
local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI

json.encode_sparse_array(true)

local unpack = unpack
local next = next
local line = renderer.line
local world_to_screen = renderer.world_to_screen
local unpack_vec = vector().unpack
local resolver_flag = {}
local resolver_status = false
X,Y = client.screen_size()

local var_table = {};
    
local prev_simulation_time = 0

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end

local function lerp2(a, b, t)
    return a + (b - a) * t
end

local diff_sim = 0

function var_table:sim_diff() 
    local current_simulation_time = time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

local notify_lol = {}
local function lerp(a, b, t)
    return a + (b - a) * t
end

local rounding = 4
local o = 20
local rad = rounding + 2
local n = 45

local RoundedRect = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)renderer.rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25) end
local OutlineGlow = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+2,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+w-3,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+radius+rad,y+2,w-rad*2-radius*2,1,r,g,b,a)renderer.rectangle(x+radius+rad,y+h-3,w-rad*2-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius+rad,y+radius+rad,r,g,b,a,radius+rounding,180,0.25,1)renderer.circle_outline(x+w-radius-rad,y+radius+rad,r,g,b,a,radius+rounding,270,0.25,1)renderer.circle_outline(x+radius+rad,y+h-radius-rad,r,g,b,a,radius+rounding,90,0.25,1)renderer.circle_outline(x+w-radius-rad,y+h-radius-rad,r,g,b,a,radius+rounding,0,0.25,1) end
local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;renderer.rectangle(x+radius,y,w-radius*2,1,r,g,b,n)renderer.circle_outline(x+radius,y+radius,r,g,b,n,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,n,radius,270,0.25,1)renderer.rectangle(x,y+radius,1,h-radius*2,r,g,b,n)renderer.rectangle(x+w-1,y+radius,1,h-radius*2,r,g,b,n)renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n) for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end
local container_glow = function(x, y, w, h, r, g, b, a, alpha,r1, g1, b1, fn) if alpha*255>0 then renderer.blur(x,y,w,h)end;RoundedRect(x,y,w,h,rounding,17,17,17,a)FadedRoundedGlow(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end
 
-- @region FUNCS start
local func = {
    fclamp = function(x, min, max)
        return math.max(min, math.min(x, max));
    end,
    frgba = function(hex)
        hex = hex:gsub("#", "");
    
        local r = tonumber(hex:sub(1, 2), 16);
        local g = tonumber(hex:sub(3, 4), 16);
        local b = tonumber(hex:sub(5, 6), 16);
        local a = tonumber(hex:sub(7, 8), 16) or 255;
    
        return r, g, b, a;
    end,
    render_text = function(x, y, ...)
        local x_Offset = 0
        
        local args = {...}
    
        for i, line in pairs(args) do
            local r, g, b, a, text = unpack(line)
            local size = vector(renderer.measure_text("-d", text))
            renderer.text(x + x_Offset, y, r, g, b, a, "-d", 0, text)
            x_Offset = x_Offset + size.x
        end
    end,
    easeInOut = function(t)
        return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
    end,
    rec = function(x, y, w, h, radius, color)
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
    rec_outline = function(x, y, w, h, radius, thickness, color)
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
    clamp = function(x, min, max)
        return x < min and min or x > max and max or x
    end,
    includes = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
    end,
    setAATab = function(ref)
        ui.set_visible(refs.enabled, ref)
        ui.set_visible(refs.pitch[1], ref)
        ui.set_visible(refs.pitch[2], ref)
        ui.set_visible(refs.roll, ref)
        ui.set_visible(refs.yawBase, ref)
        ui.set_visible(refs.yaw[1], ref)
        ui.set_visible(refs.yaw[2], ref)
        ui.set_visible(refs.yawJitter[1], ref)
        ui.set_visible(refs.yawJitter[2], ref)
        ui.set_visible(refs.bodyYaw[1], ref)
        ui.set_visible(refs.bodyYaw[2], ref)
        ui.set_visible(refs.freeStand[1], ref)
        ui.set_visible(refs.freeStand[2], ref)
        ui.set_visible(refs.fsBodyYaw, ref)
        ui.set_visible(refs.edgeYaw, ref)
    end,
    findDist = function (x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end,
    resetAATab = function()
        ui.set(refs.enabled, false)
        ui.set(refs.pitch[1], "Off")
        ui.set(refs.pitch[2], 0)
        ui.set(refs.roll, 0)
        ui.set(refs.yawBase, "local view")
        ui.set(refs.yaw[1], "Off")
        ui.set(refs.yaw[2], 0)
        ui.set(refs.yawJitter[1], "Off")
        ui.set(refs.yawJitter[2], 0)
        ui.set(refs.bodyYaw[1], "Off")
        ui.set(refs.bodyYaw[2], 0)
        ui.set(refs.freeStand[1], false)
        ui.set(refs.freeStand[2], "On hotkey")
        ui.set(refs.fsBodyYaw, false)
        ui.set(refs.edgeYaw, false)
    end,
    type_from_string = function(input)
        if type(input) ~= "string" then return input end

        local value = input:lower()

        if value == "true" then
            return true
        elseif value == "false" then
            return false
        elseif tonumber(value) ~= nil then
            return tonumber(value)
        else
            return tostring(input)
        end
    end,
    lerp = function(start, vend, time)
        return start + (vend - start) * time
    end,
    vec_angles = function(angle_x, angle_y)
        local sy = math.sin(math.rad(angle_y))
        local cy = math.cos(math.rad(angle_y))
        local sp = math.sin(math.rad(angle_x))
        local cp = math.cos(math.rad(angle_x))
        return cp * cy, cp * sy, -sp
    end,
    hex = function(arg)
        local result = "\a"
        for key, value in next, arg do
            local output = ""
            while value > 0 do
                local index = math.fmod(value, 16) + 1
                value = math.floor(value / 16)
                output = string.sub("0123456789ABCDEF", index, index) .. output 
            end
            if #output == 0 then 
                output = "00" 
            elseif #output == 1 then 
                output = "0" .. output 
            end 
            result = result .. output
        end 
        return result .. "FF"
    end,
    split = function( inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
    end,
    RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
        return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
    end,
    create_color_array = function(r, g, b, string)
        local colors = {}
        for i = 0, #string do
            local color = {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
            table.insert(colors, color)
        end
        return colors
    end,
    textArray = function(string)
        local result = {}
        for i=1, #string do
            result[i] = string.sub(string, i, i)
        end
        return result
    end,
    gradient_text = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
        local output = ''
    
        local len = #text-1
    
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
    
        for i=1, len+1 do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
    
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
    
        return output
    end,    
    time_to_ticks = function(t)
        return math.floor(0.5 + (t / globals.tickinterval()))
    end,
    headVisible = function(enemy)
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        local ex, ey, ez = entity.hitbox_position(enemy, 1)
    
        local hx, hy, hz = entity.hitbox_position(local_player, 1)
        local head_fraction, head_entindex_hit = client.trace_line(enemy, ex, ey, ez, hx, hy, hz)
        if head_entindex_hit == local_player or head_fraction == 1 then return true else return false end
    end,
    defensive = {
        cmd = 0,
        check = 0,
        defensive = 0,
    },
    aa_clamp = function(x) if x == nil then return 0 end x = (x % 360 + 360) % 360 return x > 180 and x - 360 or x end,
}

local function construct_points(origin, min, max)
	local points = {
		-- construct initial 4 points, we can extrapolate vertically in a moment
		vector(origin.x + min.x, origin.y + min.y, origin.z + min.z),
		vector(origin.x + max.x, origin.y + min.y, origin.z + min.z),
		vector(origin.x + max.x, origin.y + max.y, origin.z + min.z),
		vector(origin.x + min.x, origin.y + max.y, origin.z + min.z),
	}

	-- create our top 4 points
	for i = 1, 4 do
		local point = points[i]
		points[#points + 1] = vector(point.x, point.y, point.z + min.z + max.z)
	end
	
	-- replace all of our points with w2s results
	for i = 1, 8 do
		points[i] = {world_to_screen(unpack_vec(points[i]))}
	end

	return points
end

local function draw_box(origin, min, max, r, g, b, a)
	local points = construct_points(origin, min, max)
	local connections = {
		[1] = { 2, 4, 5 },
		[2] = { 3, 6 },
		[3] = { 4, 7 },
		[4] = { 8 },
		[5] = { 6, 8 },
		[6] = { 7 },
		[7] = { 8 }
	}

	for idx, point_list in next, connections do
		local fx, fy = unpack(points[idx])
		for _, connecting_point in next, point_list do
			local tx, ty = unpack(points[connecting_point])
			line(fx, fy, tx, ty, r, g, b, a)
		end
	end
end

local flags = {
	['H'] = {0, 1},
	['K'] = {1, 2},
	['HK'] = {2, 4},
	['ZOOM'] = {3, 8},
	['BLIND'] = {4, 16},
	['RELOAD'] = {5, 32},
	['C4'] = {6, 64},
	['VIP'] = {7, 128},
	['DEFUSE'] = {8, 256},
	['FD'] = {9, 512},
	['PIN'] = {10, 1024},
	['HIT'] = {11, 2048},
	['O'] = {12, 4096},
	['X'] = {13, 8192},
	-- beta flag
	-- beta flag
	-- beta flag
	['DEF'] = {17, 131072}
}

local function entity_has_flag(entindex, flag_name)
	if not entindex or not flag_name then
		return false
	end

	local flag_data = flags[flag_name]

	if flag_data == nil then
		return false
	end

	local esp_data = entity.get_esp_data(entindex) or {}

	return bit.band(esp_data.flags or 0, bit.lshift(1, flag_data[1])) == flag_data[2]
end

local new_class = function()
	local mt, mt_data, this_mt = { }, { }, { }

	mt.__metatable = false
	mt_data.struct = function(self, name)
		assert(type(name) == 'string', 'invalid class name')
		assert(rawget(self, name) == nil, 'cannot overwrite subclass')

		return function(data)
			assert(type(data) == 'table', 'invalid class data')
			rawset(self, name, setmetatable(data, {
				__metatable = false,
				__index = function(self, key)
					return
						rawget(mt, key) or
						rawget(this_mt, key)
				end
			}))

			return this_mt
		end
	end

	this_mt = setmetatable(mt_data, mt)

	return this_mt
end

local function clamp(value, minValue, maxValue)
    if value < minValue then
        return minValue
    end

    if value > maxValue then
         return maxValue
    end

    return value
end

local rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end

function d_lerp(a, b, t)
    return a + (b - a) * t
end
function d_clamp(x, minval, maxval)
    if x < minval then
        return minval
    elseif x > maxval then
        return maxval
    else
        return x
    end
end


gradient_text = function(text, col, speed)
	local final_text = ''
	local curtime = globals.curtime()
	local r, g, b, a = col[1], col[2], col[3], col[4]
	local center = math.floor(#text / 2) + 1  -- calculate the center of the text
	for i=1, #text do
		-- calculate the distance from the center character
		local distance = math.abs(i - center)
		-- calculate the alpha based on the distance and the speed and time
		a = 255 - math.abs(255 * math.sin(speed * curtime / 4 - distance * 4 / 20))
		local col = rgba_to_hex(r,g,b,a)
		final_text = final_text .. '\a' .. col .. text:sub(i, i)
	end
	return final_text
end


function text_fade_animation_guwno(speed, r, g, b, a, text)
	local final_text = ''
	local curtime = globals.curtime()
	for i = 0, #text do
		local color = rgba_to_hex(r, g, b, a * math.abs(1 * math.cos(2 * speed * curtime / 4 - i * 5 / 30)))
		final_text = final_text .. '\a' .. color .. text:sub(i, i)
	end
	return final_text
end


local function animated_text(x, y, speed, color1, color2, flags, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10  
        local wave = math.cos(2 * speed * curtime / 4 + x / 60)

        local color = rgba_to_hex(
            math.max(0, d_lerp(color1.r, color2.r, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.g, color2.g, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.b, color2.b, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.a, color2.a, d_clamp(wave, 0, 1)))
        )
        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
    end
    
    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, flags, nil, final_text)
end


local function text_fade_animation(x, y, speed, color1, color2, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10  
        local wave = math.cos(2 * speed * curtime / 4 + x / 50)
        local color = rgba_to_hex(
            lerp(color1.r, color2.r, clamp(wave, 0, 1)),
            lerp(color1.g, color2.g, clamp(wave, 0, 1)),
            lerp(color1.b, color2.b, clamp(wave, 0, 1)),
            color1.a
        ) 
        final_text = final_text .. ' \a' .. color .. text:sub(i, i) 
    end
    
    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, "c", nil, final_text)
end

local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local script = {}

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


to_draw = "no"
to_up = "no"
to_draw_ticks = 0

function defensive_indicator()

    local diff_mmeme = var_table.sim_diff()

    if diff_mmeme <= -1 then
        to_draw = "yes"
        to_up = "yes"
    end
end 

client.set_event_callback("setup_command", function()
    defensive_indicator()
end)

local download
local function downloadFile()
	http.get(string.format("https://flagcdn.com/w160/%s.png", MyPersonaAPI.GetMyCountryCode():lower()), function(success, response)
		if not success or response.status ~= 200 then
			print("couldnt fetch the flag image")
            return
		end

		download = images.load(response.body)
	end)
end
downloadFile()

local logo
local function downloadFileLogo()
	http.get("https://media.discordapp.net/attachments/1062810573814910987/1170208467945009212/paradox.png?ex=65616f10&is=654efa10&hm=79ccc14c0b198e1d43b5a61b28a60ec6db5d55c16dbb6542bbc0af6f66f7ee01&=", function(success, response)
		if not success or response.status ~= 200 then
            return
		end

		logo = images.load(response.body)
	end)
end
downloadFileLogo()

local ctx = new_class()
	:struct 'globals' {
		states = {"Stand", "Slow Walk", "Move", "Crouch", "Crouch-move", "Aerial", "Aero + Crouch", "Fakelag"},
		extended_states = {"Global", "Stand", "Slow Walk", "Move", "Crouch", "Crouch-move", "Aerial", "Aero + Crouch", "Fakelag"},
		teams = {"T", "CT"},
		in_ladder = 0,
		nade = 0,
		resolver_data = {}
	}

	:struct 'ref' {
		Antiaim = {
			enabled = {ui.reference("aa", "anti-aimbot angles", "enabled")},
			pitch = {ui.reference("aa", "anti-aimbot angles", "pitch")},
			yaw_base = {ui.reference("aa", "anti-aimbot angles", "Yaw base")},
			yaw = {ui.reference("aa", "anti-aimbot angles", "Yaw")},
			yaw_jitter = {ui.reference("aa", "anti-aimbot angles", "Yaw Jitter")},
			body_yaw = {ui.reference("aa", "anti-aimbot angles", "Body yaw")},
			freestanding_body_yaw = {ui.reference("aa", "anti-aimbot angles", "Freestanding body yaw")},
			freestand = {ui.reference("aa", "anti-aimbot angles", "Freestanding")},
			roll = {ui.reference("aa", "anti-aimbot angles", "Roll")},
			edge_yaw = {ui.reference("aa", "anti-aimbot angles", "Edge yaw")}
		},
		fakelag = {
			enable = {ui.reference("aa", "fake lag", "enabled")},
			amount = {ui.reference("aa", "fake lag", "amount")},
			variance = {ui.reference("aa", "fake lag", "variance")},
			limit = {ui.reference("aa", "fake lag", "limit")},
		},
		rage = {
			dt = {ui.reference("rage", "aimbot", "Double tap")},
			dt_limit = {ui.reference("rage", "aimbot", "Double tap fake lag limit")},
			fd = {ui.reference("rage", "other", "Duck peek assist")},
			os = {ui.reference("aa", "other", "On shot anti-aim")},
			silent = {ui.reference("rage", "Other", "Silent aim")},
			quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
			quickpeek2 = {ui.reference("RAGE", "Other", "Quick peek assist mode")},
			mindmg = {ui.reference('rage', 'aimbot', 'minimum damage')},
			ovr = {ui.reference('rage', 'aimbot', 'minimum damage override')}
		},
		slow_motion = {ui.reference("aa", "other", "Slow motion")},
	}

	:struct 'ui' {
		menu = {
			global = {},
			Antiaim = {},
			Visuals = {},
			Misc = {},
			Config = {},
			debug = {}
		},

		execute = function(self)
			local group = pui.group("AA", "anti-aimbot angles")
            local group2 = pui.group("AA", "Other")
            local group3 = pui.group("AA", "Fake lag")
			local group3 = pui.group("AA", "Fake lag")

			self.menu.global.label = group:label(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. "\a414141FF<\ab5b5b5FFparadox\a414141FF>")
			self.menu.global.label1 = group:label(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. "  • Welcome back. \aCC87FFFF" .. func.hex({200,200,200}) .. login.username)
			self.menu.global.label2 = group:label(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. "  • Build loaded: \aCC87FFFF" .. func.hex({200,200,200}) .. login.build)
			self.menu.global.label3 = group:label(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. "\a414141FF<\ab5b5b5FFparadox\a414141FF>")

			self.menu.global.tab = group:combobox(" \ntab", {"Antiaim", "Visuals", "Misc", "Config"})

			self.menu.Antiaim.mode = group:combobox("\n Builder", {"Builder", "Keybinds"})


			self.menu.Antiaim.states = {}

            self.menu.Antiaim.state = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. "Anti-Aim State", self.globals.extended_states):depend({self.menu.Antiaim.mode, "Builder"})
            self.menu.Antiaim.team = group:combobox("\n Team", self.globals.teams):depend({self.menu.Antiaim.mode, "Builder"})

			for _, team in ipairs(self.globals.teams) do
				self.menu.Antiaim.states[team] = {}
				for _, state in ipairs(self.globals.extended_states) do
					self.menu.Antiaim.states[team][state] = {}
					local menu = self.menu.Antiaim.states[team][state]

					if state ~= "Global" then
						menu.enable = group:checkbox("Enable " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "\n" .. team)
					end

					menu.space323 = group:label("\n ".. state .. team)


					menu.pitchsetxd = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Pitch" .. "\n" .. state .. team, {"Off", "Default", "Minimal", "Up", "Custom"})
					menu.pitchSlider =  group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Custom" .. "\n" .. state .. team,  -89, 89, 0, true, "*", 1):depend({menu.pitchsetxd, "Custom", false})


					menu.yaw_base = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " View" .. "\n" .. state .. team, {"local view", "at targets"})
                    menu.yaw_jitter = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Yaw" .. "\n" .. state .. team, {"off", "offset", "center", "random", "skitter"})
					menu.options = group:multiselect(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Yaw Extra" .. "\n" .. state .. team, {'Delayed'}):depend({menu.yaw_jitter, "off", true})
					menu.jitter_delay = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. ' Delay' .. "\n" .. state .. team, 1, 4, 1, true, 'Â°', 1, {'1Â°'}):depend({menu.options, 'Delayed'})
					menu.yaw_add = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Yaw (left)" .. "\n" .. state .. team, -180, 180, 0, true, "Â°", 1):depend({menu.yaw_jitter, "off", true})
					menu.yaw_add_r = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Yaw (right)" .. "\n" .. state .. team, -180, 180, 0, true, "Â°", 1):depend({menu.yaw_jitter, "off", true})
                    menu.yaw_jitter_add = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Amount" .. "\n" .. state .. team, -180, 180, 0, true, "Â°", 1):depend({menu.yaw_jitter, "off", true})

                    menu.yawCondition = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Yaw mode" .. "\n" .. state .. team, {"off", "Automatic"})
                    menu.yawCondition2 = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Tick-Based" .. "\n" .. state .. team, {"off", "on", "Automatic"})
					menu.tickbaseslider = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Ticks" .. "\n" .. state .. team,  1, 4, 1, true, "-", 1):depend({menu.yawCondition2, "Automatic", true}, {menu.yawCondition2, "off", true})
                    menu.micromovements = group:checkbox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Micromovement Correction" .. "\n" .. state .. team):depend({menu.yawCondition, "off", true})
                    menu.micromovements2 = group:checkbox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Body Correction" .. "\n" .. state .. team):depend({menu.yawCondition, "off", true})

                   -- menu.yaw_add3 = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "Yaw (left)" .. "\n" .. state .. team, -180, 180, 0, true, "Â°", 1):depend({menu.yawCondition, "off", true})
					--menu.yaw_add_r3 = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "Yaw (right)" .. "\n" .. state .. team, -180, 180, 0, true, "Â°", 1):depend({menu.yawCondition, "off", true})
                   -- menu.yaw_jitter_add3 = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "Amount" .. "\n" .. state .. team, -180, 180, 0, true, "Â°", 1):depend({menu.yawCondition, "L & R" and "Tickbased", false})
                   -- menu.yaw_delay = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "Delay" .. "\n" .. state .. team, -180, 180, 0, true, "Â°", 1):depend({menu.yawCondition, "Delay", false})

                    menu.desync_mode = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Body yaw" .. '\n' .. state .. team, {'Default', 'Custom Desync'})
					menu.body_yaw = group:combobox("\n XD" .. "\n" .. state .. team, {"off", "static", "opposite", "jitter"})
					menu.body_yaw_side = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. ' Side' .. "\n" .. state .. team, {'left', 'right', 'freestanding'}):depend({menu.body_yaw, "static", false})
                    

                    menu.defensive_enable = group:checkbox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Enable Defensive" .. "\n" .. state .. team)
                    menu.defensive_statekurwa = group:multiselect("\ndefensive yaw mode" .. "\n" .. state .. team, {'Defensive Builder'}):depend({menu.defensive_enable, true})


					--"Stand", "Move", "Crouch", "Aerial", "Aero"
                    menu.defensive_conditions = group:multiselect(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "Triggers" .. "\n" .. state .. team, {'Always on', 'Weapon switch', 'Reload', 'Damage', 'On Freestanding'}):depend({menu.defensive_statekurwa, 'Defensive Builder'}, {menu.defensive_enable, true})
					menu.defensive_yaw = group:checkbox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "Defensive Yaw" .. "\n" .. state .. team):depend({menu.defensive_statekurwa, 'Defensive Builder'},{menu.defensive_enable, true})
					menu.defensive_yaw_mode = group:combobox("\ndefensive yaw mode" .. "\n" .. state .. team, {'Pitch Exploit', 'Spin', "Jitter", "Flick", "Fake Up", "Paradox"}):depend({menu.defensive_statekurwa, 'Defensive Builder'}, {menu.defensive_yaw, true}, {menu.defensive_enable, true})
					menu.defensive_freestand = group:checkbox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "Avoid Yaw" .. "\n" .. state .. team):depend({menu.defensive_statekurwa, 'Defensive Builder'}, {menu.defensive_enable, true})
					--"Stand", "Move", "Crouch", "Aerial", "Aero"
                    


					for _, v in pairs(menu) do
						local arr =  { {self.menu.Antiaim.state, state}, {self.menu.Antiaim.team, team}, {self.menu.Antiaim.mode, "Builder"} }
						if _ ~= "enable" and state ~= "Global" then
							arr =  { {self.menu.Antiaim.state, state}, {self.menu.Antiaim.team, team}, {self.menu.Antiaim.mode, "Builder"}, {menu.enable, true} }
						end

						v:depend(table.unpack(arr))
						end
					end
			end

			self.menu.Antiaim.export_from = group2:combobox("export:", {"Player State", "Selected Team"}):depend({self.menu.Antiaim.mode, "Builder"})
			self.menu.Antiaim.export_to = group2:combobox("to:", {"Enemy Team", "Clipboard"}):depend({self.menu.Antiaim.mode, "Builder"})
			self.menu.Antiaim.export = group2:button("export", function ()
				local type = "team"
				local team = self.menu.Antiaim.team:get() == "CT" and "T" or "CT"
				if self.menu.Antiaim.export_from:get() == "Player State" then
					type = "state"
				end

                

				data = self.config:export(type, self.menu.Antiaim.team:get(), self.menu.Antiaim.state:get())

				if self.menu.Antiaim.export_to:get() == "Clipboard" then
					clipboard.set(data)
				else
					self.config:import(data, type, team, self.menu.Antiaim.state:get())
				end
			end):depend({self.menu.Antiaim.mode, "Builder"})
            
			self.menu.Antiaim.import = group2:button("import", function ()
				local data = clipboard.get()
				local type = data:match("{Paradox:(.+)}")
						self.config:import(data, type, self.menu.Antiaim.team:get(), self.menu.Antiaim.state:get())
			end):depend({self.menu.Antiaim.mode, "Builder"})

			--Misc
			self.menu.Antiaim.freestanding = group:multiselect("freest\ac0abffffanding", {"disablers", "static freestand"}, 0x0):depend({self.menu.Antiaim.mode, "Keybinds"})
			self.menu.Antiaim.freestanding_disablers = group:multiselect("\nfreestanding disablers", self.globals.states):depend({self.menu.Antiaim.freestanding, "disablers"})
			self.menu.Antiaim.edge_yaw = group:label("Edge\ac0abffffYaw", 0x0):depend({self.menu.Antiaim.mode, "Keybinds"})
			self.menu.Antiaim.manual_left = group:hotkey("Manual " .. func.hex({200,200,200}) .. "\ac0abffffleft"):depend({self.menu.Antiaim.mode, "Keybinds"})
			self.menu.Antiaim.manual_right = group:hotkey("Manual " .. func.hex({200,200,200}) .. "\ac0abffffright"):depend({self.menu.Antiaim.mode, "Keybinds"})
			self.menu.Antiaim.manual_forward = group:hotkey("Manual " .. func.hex({200,200,200}) .. "\ac0abffffforward"):depend({self.menu.Antiaim.mode, "Keybinds"})
           -- self.menu.Antiaim.spacing = group:label(" ")

		    self.menu.Misc.otheraa = group:multiselect("Extra", {'Anti backstab', 'Safe head'})
			self.menu.Misc.resolver = group:checkbox("AI \ac0abffffResolver")
			self.menu.Misc.resikmode = group:combobox("Mo\ac0abffffde", {"Default", "New"}):depend({self.menu.Misc.resolver, true})
            self.menu.Misc.resolverselector = group:multiselect("Sel\ac0abffffect", {"Dangerous situations", "Delay", "Missmatch"}):depend({self.menu.Misc.resolver, true})

			self.menu.Misc.enablepeek = group2:checkbox("Enable \ac0abffffpeekbot")
			self.menu.Misc.aipeek = group2:hotkey("\ac0abffff[AI]\r peek", 0x0):depend({self.menu.Misc.enablepeek, true})
			self.menu.Misc.aisettings = group2:combobox("Mode", {"Smart", "Aggressive"}):depend({self.menu.Misc.enablepeek, true})

			self.menu.Misc.animations = group:checkbox("Local\ac0abffff Animations")
			self.menu.Misc.animations_selector = group:multiselect("Sel\ac0abffffect ", {"Break legs while in Aero", "Reversed legs", "Freeze", "Reset pitch on land", "Micheal Jackson"}):depend({self.menu.Misc.animations, true})
			
			self.menu.Misc.trashtalk = group:checkbox("Trashtalk")
			self.menu.Misc.trashtalkmode = group:combobox("Sel\ac0abffffect ", {"Paradox", "Spanish", "Romanian"}):depend({self.menu.Misc.trashtalk, true})
			self.menu.Misc.fastladder = group:multiselect("Fast\ac0abffffladder", {"180", "Ascending", "Descending"})
			--self.menu.Misc.clantag = group:checkbox("Clantag")



			self.menu.Misc.spacing14 = group:label("\n")

			self.menu.Visuals.indicators = group:checkbox("Enable \ac0abffffIndicators", {140, 125, 255})
            self.menu.Visuals.indicatorstyle = group:combobox("Indicator\ac0abffff Style", {"Default", "New", "Second"}):depend({self.menu.Visuals.indicators, true})
			self.menu.Visuals.indicatorfont = group:combobox("Font", {"small", "normal"}):depend({self.menu.Visuals.indicators, true}, {self.menu.Visuals.indicatorstyle, "Default"})

			self.menu.Visuals.screenlogs = group:checkbox("Enable\ac0abffff Screen Logs", {140, 125, 255})
			self.menu.Visuals.screenlogsstyle = group:combobox("Logs\ac0abffff Style", {"Default", "Normal"}):depend({self.menu.Visuals.screenlogs, true})

            self.menu.Visuals.xd = group:multiselect("Other\ac0abffff Indicators", {"Watermark", "Defensive Indicator", "Slowdown Indicator"})
			self.menu.Visuals.watermark = group:combobox("Style", {"Default", "Modern"}):depend({self.menu.Visuals.xd, "Watermark"})
			self.menu.Visuals.watermark_type = group:combobox("Style ", {"Flag", "Avatar"}):depend({self.menu.Visuals.watermark, "Modern"}, {self.menu.Visuals.xd, "Watermark"})
			self.menu.Visuals.watermarkpos = group:combobox("\n", {"left", "right", "bottom", "top"}):depend({self.menu.Visuals.watermark, "Default"}, {self.menu.Visuals.xd, "Watermark"})
			self.menu.Visuals.watermark_space = group:checkbox("Remove Spaces"):depend({self.menu.Visuals.watermark, "Default"}, {self.menu.Visuals.xd, "Watermark"})
			self.menu.Visuals.spacing144 = group:label(" ")
			self.menu.Visuals.debug_panel = group:combobox("Debug \ac0abffffPanel", {"Off", "#1", "#2", "#3"})


			self.menu.Config.list = group:listbox("configs", {})
			self.menu.Config.list:set_callback(function() self.config:update_name() end)
			self.menu.Config.name = group:textbox("config name")
			self.menu.Config.save = group:button("save", function() self.config:save() end)
			self.menu.Config.load = group:button("load", function() self.config:load() end)
			self.menu.Config.delete = group:button("delete", function() self.config:delete() end)
			self.menu.Config.export = group:button("export", function() clipboard.set(self.config:export("config")) end)
			self.menu.Config.import = group:button("import", function() self.config:import(clipboard.get(), "config") end)


			-- set item dependencies (visibility)
			for tab, arr in pairs(self.menu) do
				if type(arr) == "table" and tab ~= "global" then
					Loop = function (arr, tab)
						for _, v in pairs(arr) do
							if type(v) == "table" then
								if v.__type == "pui::element" then
									v:depend({self.menu.global.tab, tab})
								else
									Loop(v, tab)
								end
							end
						end
					end

					Loop(arr, tab)
				end
			end
			
		end,

		shutdown = function(self)
			self.helpers:menu_visibility(true)
		end
	}

	:struct 'helpers' {
    last_eye_yaw = 0,
		was_in_air = true,
		last_tick = globals.tickcount(),

		contains = function(self, tbl, val)
			for k, v in pairs(tbl) do
				if v == val then
					return true
				end
			end
			return false
		end,

		get_lerp_time = function(self)
			local ud_rate = cvar.cl_updaterate:get_int()
			
			local min_ud_rate = cvar.sv_minupdaterate:get_int()
			local max_ud_rate = cvar.sv_maxupdaterate:get_int()
			
			if (min_ud_rate and max_ud_rate) then
				ud_rate = max_ud_rate
			end

			local ratio = cvar.cl_interp_ratio:get_float()
			
			if (ratio == 0) then
				ratio = 1
			end

			local lerp = cvar.cl_interp:get_float()
			local c_min_ratio = cvar.sv_client_min_interp_ratio:get_float()
			local c_max_ratio = cvar.sv_client_max_interp_ratio:get_float()
			
			if (c_min_ratio and  c_max_ratio and  c_min_ratio ~= 1) then
				ratio = clamp(ratio, c_min_ratio, c_max_ratio)
			end

			return math.max(lerp, (ratio / ud_rate));
		end,

		rgba_to_hex = function(self, r, g, b, a)
			return bit.tohex(
			(math.floor(r + 0.5) * 16777216) + 
			(math.floor(g + 0.5) * 65536) + 
			(math.floor(b + 0.5) * 256) + 
			(math.floor(a + 0.5))
			)
		end,

		easeInOut = function(self, t)
			return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
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
				t_out[t_out_iter] = "\a" .. self:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )
	
				t_out[t_out_iter + 1] = string:sub( i, i )
	
				t_out_iter = t_out_iter + 2
			end
	
			return t_out
		end,

		clamp = function(self, val, lower, upper)
			assert(val and lower and upper, "not very useful error message here")
			if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
			return math.max(lower, math.min(upper, val))
		end,

		get_damage = function(self)
			local mindmg = ui.get(self.ref.rage.mindmg[1])
			if ui.get(self.ref.rage.ovr[1]) and ui.get(self.ref.rage.ovr[2]) then
				return ui.get(self.ref.rage.ovr[3])
			else
				return mindmg
			end
		end,

		normalize = function(self, angle)
			angle =  angle % 360 
			angle = (angle + 360) % 360
			if (angle > 180)  then
				angle = angle - 360
			end
			return angle
		end,

		fetch_data = function(self, ent)
			return {
				origin = vector(entity.get_origin(ent)), -- +
				vev_velocity = vector(entity.get_prop(ent, "m_vecVelocity")),
				view_offset = entity.get_prop(ent, "m_vecViewOffset[2]"), -- +
				eye_angles = vector(entity.get_prop(ent, "m_angEyeAngles")), -- +
				lowerbody_target = entity.get_prop(ent, "m_flLowerBodyYawTarget"),
				simulation_time = self.helpers:time_to_ticks(entity.get_prop(ent, "m_flSimulationTime")),
				tickcount = globals.tickcount(),
				curtime = globals.curtime(),
				tickbase = entity.get_prop(ent, "m_nTickBase"),
				origin = vector(entity.get_prop(ent, "m_vecOrigin")),
				flags = entity.get_prop(ent, "m_fFlags"),
			}
		end,

		time_to_ticks = function(self, t)
			return math.floor(0.5 + (t / globals.tickinterval()))
		end,

		menu_visibility = function(self, visible)
			for _, v in pairs(self.ref.Antiaim) do
				for _, item in ipairs(v) do
					ui.set_visible(item, visible)
				end
			end
		end,

		in_ladder = function(self)
			local me = entity.get_local_player()

			if entity.is_alive(me) then
				if entity.get_prop(me, "m_MoveType") == 9 then
					self.globals.in_ladder = globals.tickcount() + 8
				end
			else
				self.globals.in_ladder = 0
			end

		end,

		in_air = function(self, ent)
			local flags = entity.get_prop(ent, "m_fFlags")
			return bit.band(flags, 1) == 0
		end,

		in_duck = function(self, ent)
			local flags = entity.get_prop(ent, "m_fFlags")
			return bit.band(flags, 4) == 4
		end,

    get_eye_yaw = function (self, ent)
      if ent == nil then
        return
      end

      local player_ptr = get_client_entity(ientitylist, ent)
      if player_ptr == nil then
        return
      end

      if globals.chokedcommands() == 0 then
	      self.last_eye_yaw = ffi.cast("float*", ffi.cast("char*", ffi.cast("void**", ffi.cast("char*", player_ptr) + 0x9960)[0]) + 0x78)[0]
      end

      return self.last_eye_yaw
    end,

    get_closest_angle = function(self, max, min, dir, ang)
      -- Calculate the absolute angular difference between d and a, b, and c
      max = self.helpers:normalize(max)
      min = self.helpers:normalize(min)
      dir = self.helpers:normalize(dir)
      ang = self.helpers:normalize(ang)

      --check if ang is between max and min and also in the same side as dir
      local diff_maxang = math.abs((max - ang + 180) % 360 - 180)
      local diff_minang = math.abs((min - ang + 180) % 360 - 180)
      local diff_maxdir = math.abs((max - dir + 180) % 360 - 180)
      local diff_mindir = math.abs((min - dir + 180) % 360 - 180)
      local diff_minmax = math.abs((min - max + 180) % 360 - 180)

      local ang_side = diff_maxang > diff_minmax or diff_minang > diff_minmax

      local dir_side = diff_maxdir > diff_minmax or diff_mindir > diff_minmax

      if dir_side ~= ang_side then
        if diff_minang < diff_maxang then
          return 0
        else
          return 1
        end
        return
      end

      return 2
    end,

		get_freestanding_side = function(self, data)
			local me = entity.get_local_player()
			local target = client.current_threat()
			local _, yaw = client.camera_angles()
			local pos = vector(client.eye_position())

      if not target then
        return 2
      end
			
			_, yaw = (pos - vector(entity.get_origin(target))):angles()
			
			local yaw_offset = data.offset
			local yaw_jitter_type = string.lower(data.type)
			local yaw_jitter_amount = data.value
			
			local offset = math.abs(yaw_jitter_amount)
			
			if yaw_jitter_type == 'skitter' then
				offset = math.abs(yaw_jitter_amount) + 33
			elseif yaw_jitter_type == 'offset' then
				offset = math.max(0, yaw_jitter_amount)
			elseif yaw_jitter_type == 'center' then
				offset = math.abs(yaw_jitter_amount)/2
			end
			
			local max_yaw = self.helpers:normalize(yaw + yaw_offset + offset)
			
			local min_offset = offset
			if yaw_jitter_type == 'offset' then
				min_offset = math.abs(math.min(0, yaw_jitter_amount))
			end
			
			local min_yaw = self.helpers:normalize(yaw + yaw_offset - min_offset)
			
			local current_yaw = self:get_eye_yaw(me)

      local left_offset = max_yaw - current_yaw
      local right_offset = min_yaw - current_yaw

      local closest = self:get_closest_angle(min_yaw, max_yaw, yaw, current_yaw)
			
      return closest
		end,

		get_state = function(self)
			local me = entity.get_local_player()
			local velocity = vector(entity.get_prop(me, "m_vecVelocity")):length2d()
			local duck = self:in_duck(me) or ui.get(self.ref.rage.fd[1])

			local state = velocity > 1.5 and "Move" or "Stand"
			
			if self:in_air(me) or self.was_in_air then
				state = duck and "Aero + Crouch" or "Aerial"
			elseif velocity > 1.5 and duck then
				state = "Crouch-move"
			elseif ui.get(self.ref.slow_motion[1]) and ui.get(self.ref.slow_motion[2]) then
				state = "Slow Walk"
			elseif duck then
				state = "Crouch"
			end
			if globals.tickcount() ~= self.last_tick then
				self.was_in_air = self:in_air(me)
				self.last_tick = globals.tickcount()
			end
			return state
		end,

		get_team = function(self)
			local me = entity.get_local_player()
			local index = entity.get_prop(me, "m_iTeamNum")

			return index == 2 and "T" or "CT"
		end,

		loop = function (arr, func)
			if type(arr) == "table" and arr.__type == "pui::element" then
				func(arr)
			else
				for k, v in pairs(arr) do
					loop(v, func)
				end
			end
		end,

		get_charge = function ()
			local me = entity.get_local_player()
			local simulation_time = entity.get_prop(entity.get_local_player(), "m_flSimulationTime")
			return (globals.tickcount() - simulation_time/globals.tickinterval())
		end,
	}

	:struct 'config' {
		configs = {},

		write_file = function (self, path, data)
			if not data or type(path) ~= "string" then
				return
			end

			return writefile(path, json.stringify(data))
		end,

		update_name = function (self)
			local index = self.ui.menu.Config.list()
			local i = 1

			for k, v in pairs(self.configs) do
				if index == i or index == 0 then
					return self.ui.menu.Config.name(k)
				end
				i = i + 1
			end
		end,

		update_configs = function (self)
			local names = {}
			for k, v in pairs(self.configs) do
				table.insert(names, k)
			end
			
			if #names > 0 then
				self.ui.menu.Config.list:update(names)
			end
			self:write_file("Paradox_configs.txt", self.configs)
			self:update_name()
		end,

		setup = function (self)
			local data = readfile('Paradox_configs.txt')
			if data == nil then
				self.configs = {}
				return
			end

			self.configs = json.parse(data)

			self:update_configs()

			self:update_name()
		end,

		export_config = function(self, ...)
			local config = pui.setup({self.ui.menu.global, self.ui.menu.Antiaim, self.ui.menu.Misc, self.ui.menu.vis})

			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )

			return encrypted
		end,

		export_state = function (self, team, state)
			local config = pui.setup({self.ui.menu.Antiaim.states[team][state]})

			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )

			return encrypted
		end,

		export_team = function (self, team)
			local config = pui.setup({self.ui.menu.Antiaim.states[team]})

			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )

			return encrypted
		end,

		export = function (self, type, ...)
			local success, result = pcall(self['export_' .. type], self, ...)
			if not success then
				print(result)
				return
			end

			return "{Paradox:" .. type .. "}:" .. result
		end,

		import_config = function (self, encrypted)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.menu.global, self.ui.menu.Antiaim, self.ui.menu.Misc, self.ui.menu.vis})
			config:load(data)
		end,

		import_state = function (self, encrypted, team, state)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.menu.Antiaim.states[team][state]})
			config:load(data)
		end,

		import_team = function (self, encrypted, team)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.menu.Antiaim.states[team]})
			config:load(data)
		end,

		import = function (self, data, type, ...)
			local name = data:match("{Paradox:(.+)}")
			if not name or name ~= type then
				return error('This is not valid Paradox data. 1')
			end

			local success, err = pcall(self['import_'..name], self, data:gsub("{Paradox:" .. name .. "}:", ""), ...)
			if not success then
				print(err)
				return error('This is not valid Paradox data. 2')
			end
		end,

		save = function (self)
			local name = self.ui.menu.Config.name()
			if name:match("%w") == nil then
				return print("Invalid config name")
			end

			local data = self:export("config")

			self.configs[name] = data

			self:update_configs()
		end,

		load = function (self)
			local name = self.ui.menu.Config.name()
			local data = self.configs[name]
			if not data then
				return print("Invalid config name")
			end

			self:import(data, "config")
		end,

		delete = function(self)
			local name = self.ui.menu.Config.name()
			local data = self.configs[name]
			if not data then
				return print("Invalid config name")
			end

			self.configs[name] = nil

			self:update_configs()
		end,


	}

	
	
	:struct 'prediction' {
		run = function (self, ent, ticks)
			local origin = vector(entity.get_origin(ent))
			local velocity = vector(entity.get_prop(ent, 'm_vecVelocity'))
			velocity.z = 0
			local predicted = origin + velocity * globals.tickinterval() * ticks
			
			return {
				origin = predicted
			}
		end
	}

	:struct 'fakelag' {
		send_packet = true,

		get_limit = function (self)
			if not ui.get(self.ref.fakelag.enable[1]) then
				return 1
			end

			local limit = ui.get(self.ref.fakelag.limit[1])
			local charge = self.helpers:get_charge()

      local dt = ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2])
      local os = ui.get(self.ref.rage.os[1]) and ui.get(self.ref.rage.os[2])

			if (dt or os) and not ui.get(self.ref.rage.fd[1]) then
				if charge > 0 then
					limit = 1
				else
					limit = ui.get(self.ref.rage.dt_limit[1])
				end
			end
			
			return limit
		end,

		run = function (self, cmd)
			local limit = self:get_limit()

			if cmd.chokedcommands < limit and (not cmd.no_choke or (cmd.chokedcommands == 0 and limit == 1)) then
				self.send_packet = false
				cmd.no_choke = false
			else
				cmd.no_choke = true
				self.send_packet = true
			end

			cmd.allow_send_packet = self.send_packet

			return self.send_packet
		end
	}

	:struct 'desync' {
		switch_move = true,

		get_yaw_base = function (self, base)
			local threat = client.current_threat()
			local _, yaw = client.camera_angles()
			if base == "at targets" and threat then
				local pos = vector(entity.get_origin(entity.get_local_player()))
				local epos = vector(entity.get_origin(threat))
		
				_, yaw = pos:to(epos):angles()
			end
		
			return yaw
		end,

		do_micromovements = function(self, cmd, send_packet)
			local me = entity.get_local_player()
			local speed = 1.01
			local vel = vector(entity.get_prop(me, "m_vecVelocity")):length2d()

			if vel > 3 then
				return
			end

			if self.helpers:in_duck(me) or ui.get(self.ref.rage.fd[1]) then
				speed = speed * 2.94117647
			end

			self.switch_move = self.switch_move or false

			if self.switch_move then
				cmd.sidemove = cmd.sidemove + speed
			else
				cmd.sidemove = cmd.sidemove - speed
			end

			self.switch_move = not self.switch_move
		end,

		can_desync = function (self, cmd)
			local me = entity.get_local_player()

			if cmd.in_use == 1 then
				return false
			end
			local weapon_ent = entity.get_player_weapon(me)

			if cmd.in_attack == 1 then
				local weapon = entity.get_classname(weapon_ent)

				if weapon == nil then
					return false
				end
          if weapon:find("Grenade") or weapon:find('Flashbang') then
            self.globals.nade = globals.tickcount()
				  else
					if math.max(entity.get_prop(weapon_ent, "m_flNextPrimaryAttack"), entity.get_prop(me, "m_flNextAttack")) - globals.tickinterval() - globals.curtime() < 0 then
						return false
					end
				end
			end
			local throw = entity.get_prop(weapon_ent, "m_fThrowTime")

			if self.globals.nade + 15 == globals.tickcount() or (throw ~= nil and throw ~= 0) then 
        return false 
      end
			if entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1 then
				return false
			end
		
			if entity.get_prop(me, "m_MoveType") == 9 or self.globals.in_ladder > globals.tickcount() then
				return false
			end
			if entity.get_prop(me, "m_MoveType") == 10 then
				return false
			end
		
			return true
		end,

		run = function (self, cmd, send_packet, data)
			if not self:can_desync(cmd) then
				return
			end

			self:do_micromovements(cmd, send_packet)

			local yaw = self:get_yaw_base(data.base)

			if send_packet then
				cmd.pitch = data.pitchsetxd or 88.9
				cmd.yaw = yaw + 180 + data.offset
			else
				cmd.pitch = 88.9
				cmd.yaw = yaw + 180 + data.offset + (data.side == 2 and 0 or (data.side == 0 and 120 or -120))
			end
		end
	}

	:struct 'Antiaim' {
		side = 0,
		last_rand = 0,
		skitter_counter = 0,
		last_skitter = 0,
		last_count = 0,
		cycle = 0,

		manual_side = 0,
    freestanding_side = 0,

		fast_ladder = function(self, e)
			local info_test_xd = self.ui.menu.Misc.fastladder:get()

			local local_player = entity.get_local_player()
			local pitch, yaw = client.camera_angles()
			if entity.get_prop(local_player, "m_MoveType") == 9 then
				e.yaw = math.floor(e.yaw+0.5)
				e.roll = 0
				if self.helpers:contains(info_test_xd, "180") then
					if e.forwardmove == 0 then
						if e.sidemove ~= 0 then
							e.pitch = 89
							e.yaw = e.yaw + 180
							if e.sidemove < 0 then
								e.in_moveleft = 0
								e.in_moveright = 1
							end
							if e.sidemove > 0 then
								e.in_moveleft = 1
								e.in_moveright = 0
							end
						end
					end
				end

				if self.helpers:contains(info_test_xd, "Ascending") then
					if e.forwardmove > 0 then
						if pitch < 45 then
							e.pitch = 89
							e.in_moveright = 1
							e.in_moveleft = 0
							e.in_forward = 0
							e.in_back = 1
							if e.sidemove == 0 then
								e.yaw = e.yaw + 90
							end
							if e.sidemove < 0 then
								e.yaw = e.yaw + 150
							end
							if e.sidemove > 0 then
								e.yaw = e.yaw + 30
							end
						end 
					end
				end
		
				if self.helpers:contains(info_test_xd, "Descending") then
					if e.forwardmove < 0 then
						e.pitch = 89
						e.in_moveleft = 1
						e.in_moveright = 0
						e.in_forward = 1
						e.in_back = 0
						if e.sidemove == 0 then
							e.yaw = e.yaw + 90
						end
						if e.sidemove > 0 then
							e.yaw = e.yaw + 150
						end
						if e.sidemove < 0 then
							e.yaw = e.yaw + 30
						end
					end
				end
			end
		
		end,

		anti_backstab = function (self)
			local me = entity.get_local_player()
			local target = client.current_threat()
			if not target then
				return false
			end

			local weapon_ent = entity.get_player_weapon(target)

			if not weapon_ent then
				return false
			end

			local weapon_name = entity.get_classname(weapon_ent)

			if not weapon_name:find('Knife') then
				return false
			end

			local lpos = vector(entity.get_origin(me))
			local epos = vector(entity.get_origin(target))

			local predicted = self.prediction:run(target, 16)

			return epos:dist2d(lpos) < 128 or predicted.origin:dist2d(lpos) < 128
		end,

		calculate_additional_states = function (self, team, state)
			local dt = (ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2]))
			local os = (ui.get(self.ref.rage.os[1]) and ui.get(self.ref.rage.os[2]))
			local fd = ui.get(self.ref.rage.fd[1])

			if self.ui.menu.Antiaim.states[team]['Fakelag'].enable() and ((not dt and not os) or fd) then
				state = 'Fakelag'
			end

			-- if self.ui.menu.Antiaim.states[team]['hideshots'].enable() and os and not dt and not fd then
			-- 	state = 'hideshots'
			-- end

			return state
		end,

		get_best_side = function (self, opposite)
			local me = entity.get_local_player()
			local eye = vector(client.eye_position())
			local target = client.current_threat()
			local _, yaw = client.camera_angles()

			local epos
			if target then
				epos = vector(entity.get_origin(target)) + vector(0,0,64)
				_, yaw = (epos - eye):angles()
			end

			local angles = {60,45,30,-30,-45,-60}
			local data = {left = 0, right = 0}

			for _, angle in ipairs(angles) do
				local forward = vector():init_from_angles(0, yaw + 180 + angle, 0)

				if target then
					local vec = eye + forward:scaled(128)
					local _, dmg = client.trace_bullet(target, epos.x, epos.y, epos.z, vec.x, vec.y, vec.z, me)
					data[angle < 0 and 'left' or 'right'] = data[angle < 0 and 'left' or 'right'] + dmg
				else
					local vec = eye + forward:scaled(8192)
					local fraction = client.trace_line(me, eye.x, eye.y, eye.z, vec.x, vec.y, vec.z)
					data[angle < 0 and 'left' or 'right'] = data[angle < 0 and 'left' or 'right'] + fraction
				end
			end

			if data.left == data.right then
				return 2
			elseif data.left > data.right then
				return opposite and 1 or 0
			else
				return opposite and 0 or 1
			end
		end,

		get_manual = function (self)
			local me = entity.get_local_player()

			local left = self.ui.menu.Antiaim.manual_left:get()
			local right = self.ui.menu.Antiaim.manual_right:get()
			local forward = self.ui.menu.Antiaim.manual_forward:get()

			if self.last_forward == nil then
				self.last_forward, self.last_right, self.last_left = forward, right, left
			end

			if left ~= self.last_left then
				if self.manual_side == 1 then
					self.manual_side = nil
				else
					self.manual_side = 1
				end
			end

			if right ~= self.last_right then
				if self.manual_side == 2 then
					self.manual_side = nil
				else
					self.manual_side = 2
				end
			end

			if forward ~= self.last_forward then
				if self.manual_side == 3 then
					self.manual_side = nil
				else
					self.manual_side = 3
				end
			end

			self.last_forward, self.last_right, self.last_left = forward, right, left

			if not self.manual_side then
				return
			end

			return ({-90, 90, 180})[self.manual_side]
		end,

		run = function (self, cmd)
			local me = entity.get_local_player()

			if not entity.is_alive(me) then
				return
			end

			local state = self.helpers:get_state()
			local team = self.helpers:get_team()
			state = self:calculate_additional_states(team, state)

			if self.ui.menu.Antiaim.mode() == "Builder" or self.ui.menu.Antiaim.mode() == "Keybinds" or self.ui.menu.Antiaim.mode() == "Other" then
				self:set_builder(cmd, state, team)
			-- else
			-- 	self:set_preset(cmd, state, team)
			end

		end,

		set_builder = function (self, cmd, state, team)
			if not self.ui.menu.Antiaim.states[team][state].enable() then
				state = "Global"
			end
		
			local data = {}

			for k, v in pairs(self.ui.menu.Antiaim.states[team][state]) do
				data[k] = v()
			end
			
			self:set(cmd, data)
		end,

		-- set_preset = function (self, cmd, state, team)
		-- 	local preset = self.ui.menu.Antiaim.preset_list:get()

		-- 	local presets = {
		-- 		[0] = function ()
		-- 			local preset_data = json.parse(global_data_saved_somewhere)

		-- 			if not preset_data[team][state].enable then
		-- 				state = "global"
		-- 			end

		-- 			local data = {}

		-- 			for k, v in pairs(preset_data[team][state]) do
		-- 				data[k] = v
		-- 			end
				
		-- 			self:set(cmd, data)
		-- 		end,
		-- 		[1] = function ()
		-- 			local preset_data = json.parse(global_data_saved_somewhere2)

		-- 			if not preset_data[team][state].enable then
		-- 				state = "global"
		-- 			end

		-- 			local data = {}

		-- 			for k, v in pairs(preset_data[team][state]) do
		-- 				data[k] = v
		-- 			end
				
		-- 			self:set(cmd, data)
		-- 		end

		-- 	}

		-- 	return presets[preset](cmd)
		-- end,

		airtick = function(self, cmd)
			cmd.force_defensive = true
		end, 

		animations = function(self)
			local me = entity.get_local_player()

			if not entity.is_alive(me) then
				return
			end

			local self_index = entity_lib.new(me)
			local self_anim_overlay = self_index:get_anim_overlay(6)
			
			if not self_anim_overlay then
				return
			end

			local x_velocity = entity.get_prop(me, "m_flPoseParameter", 7)
			local state = self.helpers:get_state()

			if string.find(state, "Aerial") and self.helpers:contains(self.ui.menu.Misc.animations_selector:get(), "Freeze") then
				self_anim_overlay.weight = 99999
				self_anim_overlay.cycle = 99999
			end

			if self.helpers:contains(self.ui.menu.Misc.animations_selector:get(), "Micheal Jackson") then
				local ent = require("gamesense/entity")
                local me = ent.get_local_player()
                local m_fFlags = me:get_prop("m_fFlags")
                local is_onground = bit.band(m_fFlags, 1) ~= 0
                if not is_onground then
                    local my_animlayer = me:get_anim_overlay(6) 
                   
                    my_animlayer.weight = 1
                else
                    ui.set(ui.reference("AA", "Other", "Leg movement"),"Off")
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
                end
			end

			if self.helpers:contains(self.ui.menu.Misc.animations_selector:get(), "Break legs while in Aero") then
				entity.set_prop(me, "m_flPoseParameter", 1, 6) 
			end

			if self.helpers:contains(self.ui.menu.Misc.animations_selector:get(), "Reversed legs") then
                local math_randomized = math.random(1,2)
        
                ui.set(ui.reference("AA", "Other", "Leg movement"), math_randomized == 1 and "Always slide" or "Never slide")
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
			end

			if self.helpers:contains(self.ui.menu.Misc.animations_selector:get(), "Reset pitch on land") then
                local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
        
                if on_ground == 1 then
                    ground_ticks = ground_ticks + 1
                else
                    ground_ticks = 0
                    end_time = globals.curtime() + 1
                end
        
                if  ground_ticks > 5 and end_time + 0.5 > globals.curtime() then
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
                end
			end


		end,


		get_defensive = function (self, conditions, state)
			local target = client.current_threat()
			local me = entity.get_local_player()
			if self.helpers:contains(conditions, 'Always on') then
				return true
			end

			if self.helpers:contains(conditions, 'Weapon switch') then
				local next_attack = entity.get_prop(me, 'm_flNextAttack') - globals.curtime()
				if next_attack / globals.tickinterval() > self.defensive.defensive + 2 then
					return true
				end
			end

            if self.helpers:contains(conditions, 'Stand') then
                local me = entity.get_local_player()
                local velocity = vector(entity.get_prop(me, "m_vecVelocity")):length2d()

				if velocity == 0 then
					return true
				end
			end

            if self.helpers:contains(conditions, 'Move') then
                local me = entity.get_local_player()
                local velocity = vector(entity.get_prop(me, "m_vecVelocity")):length2d()

				if velocity > 0 then
					return true
				end
			end

            
            if self.helpers:contains(conditions, 'Crouch') then
                local me = entity.get_local_player()
                local velocity = vector(entity.get_prop(me, "m_vecVelocity")):length2d()


                local duck = self.helpers:in_duck(me) or ui.get(self.ref.rage.fd[1]) 

				if duck then
					return true
				end
			end

            if self.helpers:contains(conditions, 'Aerial') then
                local me = entity.get_local_player()
                local velocity = vector(entity.get_prop(me, "m_vecVelocity")):length2d()


                local inair = self.helpers:in_air(me)

				if inair then
					return true
				end
			end

            if self.helpers:contains(conditions, 'Aero') then
                local me = entity.get_local_player()
                local velocity = vector(entity.get_prop(me, "m_vecVelocity")):length2d()

                local duck = self.helpers:in_duck(me) or ui.get(self.ref.rage.fd[1]) 
                local inair = self.helpers:in_air(me)

				if inair and duck then
					return true
				end
			end

            -- get_state = function(self)
            --     local me = entity.get_local_player()
            --     local velocity = vector(entity.get_prop(me, "m_vecVelocity")):length2d()
            --     local duck = self:in_duck(me) or ui.get(self.ref.rage.fd[1])
    
            --     local state = velocity > 1.5 and "Move" or "Stand"
                
            --     if self:in_air(me) or self.was_in_air then
            --         state = duck and "Aero + Crouch" or "Aerial"
            --     elseif velocity > 1.5 and duck then
            --         state = "Crouch-move"
            --     elseif ui.get(self.ref.slow_motion[1]) and ui.get(self.ref.slow_motion[2]) then
            --         state = "Slow Walk"
            --     elseif duck then
            --         state = "Crouch"
            --     end
            --     if globals.tickcount() ~= self.last_tick then
            --         self.was_in_air = self:in_air(me)
            --         self.last_tick = globals.tickcount()
            --     end
            --     return state
            -- end,

			if self.helpers:contains(conditions, 'Reload') then
				local weapon = entity.get_player_weapon(me)
				if weapon then
					local next_attack = entity.get_prop(me, 'm_flNextAttack') - globals.curtime()
					local next_primary_attack = entity.get_prop(weapon, 'm_flNextPrimaryAttack') - globals.curtime()

					if next_attack > 0 and next_primary_attack > 0 and next_attack * globals.tickinterval() > self.defensive.defensive then
						return true
					end
				end
			end

			if self.helpers:contains(conditions, 'Damage') and entity_has_flag(target, 'HIT') then
				return true
			end

			if self.helpers:contains(conditions, 'Dormant') and target then
				local weapon_ent = entity.get_player_weapon(target)
				if entity.is_dormant(target) and weapon_ent then
					if entity_has_flag(me, 'HIT') then
						return true
					end

					local weapon = csgo_weapons(weapon_ent)

					local predicted = self.prediction:run(me, 14).origin
					local origin = vector(entity.get_origin(me))
					
					local offset = predicted - origin
					local biggest_damage = 0

					for i = 2, 8 do
						local to = vector(entity.hitbox_position(me, i)) + offset
						local from = vector(entity.get_origin(target)) + vector(0,0, 64)

						local _, dmg = client.trace_bullet(target, from.x, from.y, from.z, to.x, to.y, to.z, target)

						if dmg > biggest_damage then
							biggest_damage = dmg
						end
					end

					if biggest_damage > weapon.damage / 3 then
					--	print("DORMANT PEEK")
						return true
					end

					--print"-"
				end
			end

			if self.helpers:contains(conditions, 'On Freestanding') and self.ui.menu.Antiaim.freestanding:get_hotkey() and not (self.ui.menu.Antiaim.freestanding:get('disablers') and self.ui.menu.Antiaim.freestanding_disablers:get(state)) then
				return true
			end
		end,

		set = function (self, cmd, data)
      local state = self.helpers:get_state()
			local delay = {math.random(1, math.random(3, 4)), 2, 4, 5}
			local manual = self:get_manual()
			local delayed = true

			if not self.helpers:contains(data.options, 'Delayed') then
				delay[data.jitter_delay] = 1
			end

      if globals.chokedcommands() == 0 and self.cycle == delay[data.jitter_delay] then
        delayed = false
        self.side = self.side == 1 and 0 or 1
      end

			local best_side = self:get_best_side()
      local side = self.side
      local body_yaw = data.body_yaw
      local pitch = data.pitchsetxd

      if body_yaw == "jitter" then
        body_yaw = "static"
      else
        if data.body_yaw_side == "left" then
          side = 1
        elseif data.body_yaw_side == "right" then
          side = 0
        else
          side = best_side
        end
      end

			
			local yaw_offset = 0
      if data.yaw_jitter == 'offset' then
        if self.side == 1 and not data.micromovements then
        	yaw_offset = yaw_offset + data.yaw_jitter_add
		elseif self.side == 1 and data.micromovements then
			yaw_offset = yaw_offset + data.yaw_jitter_add + client.random_int(0,math.random(5,10)) * 1.2 
        end
      elseif data.yaw_jitter == 'center' then
		if not data.micromovements then 
        	yaw_offset = yaw_offset + (self.side == 1 and data.yaw_jitter_add/2 or -data.yaw_jitter_add/2)
		elseif data.micromovements then
        	yaw_offset = yaw_offset + (self.side == 1 and data.yaw_jitter_add/2 or -data.yaw_jitter_add/2) + client.random_int(0,math.random(5,10)) * 1.2 
		end
      elseif data.yaw_jitter == 'random' then
        local rand = (math.random(0, data.yaw_jitter_add) - data.yaw_jitter_add/2)
        if not delayed then
          yaw_offset = yaw_offset + rand

          self.last_rand = rand
        else
          yaw_offset = yaw_offset + self.last_rand
        end
      elseif data.yaw_jitter == 'skitter' then
        local sequence = {0, 2, 1, 0, 2, 1, 0, 1, 2, 0, 1, 2, 0, 1, 2}

        local next_side
        if self.skitter_counter == #sequence then
          self.skitter_counter = 1
      	elseif not delayed then
          self.skitter_counter = self.skitter_counter + 1
        end

        next_side = sequence[self.skitter_counter]

        self.last_skitter = next_side

        if data.body_yaw == "jitter" then
          side = next_side
        end

        if next_side == 0 then
          yaw_offset = yaw_offset - 16 - math.abs(data.yaw_jitter_add)/2
        elseif next_side == 1 then
          yaw_offset = yaw_offset + 16 + math.abs(data.yaw_jitter_add)/2
        end
      end

      yaw_offset = yaw_offset + (side == 0 and data.yaw_add_r or (side == 1 and data.yaw_add or 0))

			if data.defensive_enable and self.helpers:contains(data.defensive_statekurwa, 'Defensive Builder') and self:get_defensive(data.defensive_conditions, state) then
				cmd.force_defensive = true
			end 

			ui.set(self.ref.Antiaim.freestand[1], false)
			ui.set(self.ref.Antiaim.edge_yaw[1], self.ui.menu.Antiaim.edge_yaw:get_hotkey())
			ui.set(self.ref.Antiaim.freestand[2], 'Always on')

			if self.ui.menu.Misc.otheraa:get("Safe head") then
				local me = entity.get_local_player()
				local target = client.current_threat()
				if target then
					local weapon = entity.get_player_weapon(me)
					if weapon and (entity.get_classname(weapon):find('Knife') or entity.get_classname(weapon):find('Taser')) then
						yaw_offset = 0
						side = 2
					end
				end
			end

			if manual then
				yaw_offset = manual
			elseif self.ui.menu.Antiaim.freestanding:get_hotkey() and not (self.ui.menu.Antiaim.freestanding:get('disablers') and self.ui.menu.Antiaim.freestanding_disablers:get(state)) then
        data.desync_mode = 'Default'
        ui.set(self.ref.Antiaim.freestand[1], true)

			  if self.ui.menu.Antiaim.freestanding:get("static freestand") then
			  	yaw_offset = 0
			  	side = 0
			  end
      elseif self.ui.menu.Misc.otheraa:get("Anti backstab") and self:anti_backstab() then
				yaw_offset = yaw_offset + 180
			end

			local defensive = self.defensive.ticks * self.defensive.defensive > 0 and math.max(self.defensive.defensive, self.defensive.ticks) or 0

			if data.defensive_yaw and data.defensive_enable and self.helpers:contains(data.defensive_statekurwa, 'Defensive Builder') then
				local defensive_freestand = false

				if data.defensive_freestand and ui.get(self.ref.Antiaim.freestand[1]) then
					if defensive == 1 then
      		  self.freestanding_side = self.helpers:get_freestanding_side({
      		    offset = 0,
      		    type = data.yaw_jitter,
      		    value = data.yaw_jitter_add,
      		    base = data.yaw_base
      		  })
      		end

					if self.freestanding_side ~= 2 then
						defensive_freestand = true
					
        	  if defensive > 0 then
        	    yaw_offset = yaw_offset + (self.freestanding_side == 1 and 120 or -120)
        	    pitch = 0
        	    ui.set(self.ref.Antiaim.freestand[1], false)
        	  end
					end
				end
				
				if data.defensive_yaw_mode == 'Pitch Exploit' and defensive > 0 and not defensive_freestand then
					yaw_offset = (side == 1) and 120 or -120 + math.random(-20, 20)
					pitch = -87
				elseif data.defensive_yaw_mode == 'Spin' and defensive > 0 then
					yaw_offset = math.abs(yaw_offset) + defensive * (360 - math.abs(yaw_offset) * 2)/14
					pitch = 0
                elseif data.defensive_yaw_mode == 'Jitter' and defensive > 0 then
                    local tickcount = globals.tickcount()
					yaw_offset = tickcount % 3 == 0 and client.random_int(90, -90) or tickcount % 3 == 1 and 180 or tickcount % 3 == 2 and client.random_int(-90, 90) or 0
					pitch = 0
                elseif data.defensive_yaw_mode == 'Flick' and defensive > 0 then
                    local tickcount = globals.tickcount()
					yaw_offset = (globals.tickcount() % 6 > 3) and 111 or -111
					pitch = -89
                elseif data.defensive_yaw_mode == 'Fake Up' and defensive > 0 then
					yaw_offset = 5
					pitch = -87
				elseif data.defensive_yaw_mode == "Paradox" and defensive > 0 then
					local tickcount = globals.tickcount()
					yaw_offset = tickcount % 3 == 0 and client.random_int(90, -90) or tickcount % 3 == 1 and 180 or tickcount % 3 == 2 and client.random_int(-90, 90) or 0
					pitch = valuwes.paketa_pitch
				end
			end

      if data.desync_mode == 'Default' then
        ui.set(self.ref.Antiaim.enabled[1], true)
        ui.set(self.ref.Antiaim.pitch[1], pitch == data.pitchsetxd and pitch or 'custom')
        ui.set(self.ref.Antiaim.pitch[2], type(pitch) == "number" and data.pitchSlider or data.pitchSlider)
        ui.set(self.ref.Antiaim.yaw_base[1], data.yaw_base)
        ui.set(self.ref.Antiaim.yaw[1], 180)
        ui.set(self.ref.Antiaim.yaw[2], self.helpers:normalize(yaw_offset))
        ui.set(self.ref.Antiaim.yaw_jitter[1], 'off')
        ui.set(self.ref.Antiaim.yaw_jitter[2], 0)
        ui.set(self.ref.Antiaim.body_yaw[1], body_yaw)
        ui.set(self.ref.Antiaim.body_yaw[2], (side == 2) and 0 or (side == 1 and 90 or -90))
			elseif data.desync_mode == 'Custom Desync' then
        local send_packet = self.fakelag:run(cmd)

        if pitch == 'default' then
          pitch = nil
        end
        
        self.desync:run(cmd, send_packet, {
          pitch = pitch,
          base = data.yaw_base,
          side = side,
          offset = yaw_offset,
        })
      end

      self.last_count = globals.tickcount()

      if globals.chokedcommands() == 0 then
      	if self.cycle >= delay[data.jitter_delay] then
        self.cycle = 1
        else
        	self.cycle = self.cycle + 1
        end
      end
            
    end,
	}

	:struct 'resolver' {
		state = {},
		counter = {},
		jitterhelper = function(self)
			resikmodexd = self.ui.menu.Misc.resikmode:get()
			if self.ui.menu.Misc.resolver() and resikmodexd == "Default" then
				local players = entity.get_players(true)      
				if #players == 0 then
					return
				end
				--resolver_status = self.ui.menu.Misc.resolver_flag()
				for _, i in next, players do

					local target = i
					if self.globals.resolver_data[target] == nil then
						local data = self.helpers:fetch_data(target)
						self.globals.resolver_data[target] = {
							current = data,
							last_valid_record = data
						}
					else
						local simulation_time = self.helpers:time_to_ticks(entity.get_prop(target, "m_flSimulationTime"))
						if simulation_time ~= self.globals.resolver_data[target].current.simulation_time then
							table.insert(self.globals.resolver_data[target], 1, self.globals.resolver_data[target].current)
							local data = self.helpers:fetch_data(target)
							if simulation_time - self.globals.resolver_data[target].current.simulation_time >= 1 then
								self.globals.resolver_data[target].last_valid_record = data
							end
							self.globals.resolver_data[target].current = data
							for i = #self.globals.resolver_data[target], 1, -1 do
								if #self.globals.resolver_data[target] > 16 then 
									table.remove(self.globals.resolver_data[target], i)
								end
							end
						end
					end

					if self.globals.resolver_data[target][1] == nil or self.globals.resolver_data[target][2] == nil or self.globals.resolver_data[target][3] == nil or self.globals.resolver_data[target][6] == nil or self.globals.resolver_data[target][7] == nil then
						return
					end
					
					
					local yaw_delta = self.helpers:normalize(self.globals.resolver_data[target].current.eye_angles.y - self.globals.resolver_data[target][1].eye_angles.y)
					local yaw_delta2 = self.helpers:normalize(self.globals.resolver_data[target][2].eye_angles.y - self.globals.resolver_data[target][3].eye_angles.y)
					local yaw_delta3 = self.helpers:normalize(self.globals.resolver_data[target][6].eye_angles.y - self.globals.resolver_data[target][7].eye_angles.y)

					if math.abs(yaw_delta) >= 33 then
						self.globals.resolver_data[target].lastyawupdate = globals.tickcount() + 10
						self.globals.resolver_data[target].side = yaw_delta
					end

					if self.globals.resolver_data[target].lastyawupdate == nil then self.globals.resolver_data[target].lastyawupdate = 0 end
					if self.globals.resolver_data[target].lastplistupdate == nil then self.globals.resolver_data[target].lastplistupdate = 0 end
					if self.globals.resolver_data[target].skitterupdate == nil then self.globals.resolver_data[target].skitterupdate = 0 end

					if math.abs(yaw_delta2 - yaw_delta3) > 90 then
						self.globals.resolver_data[target].skitterupdate = globals.tickcount() + 10
					end
					if self.globals.resolver_data[target].skitterupdate - globals.tickcount() > 0 then
						self.state[target] = "SKITTER"
						resolver_flag[target] = "SKITTER"
						if math.abs(yaw_delta2 - yaw_delta3) == 0 then
							plist.set(target, "Force body yaw value", 0)
						else
							plist.set(target, "Force body yaw value", yaw_delta)
						end
					elseif self.globals.resolver_data[target].lastyawupdate > globals.tickcount() and yaw_delta == 0 and self.globals.resolver_data[target].skitterupdate - globals.tickcount() < 0 then
						plist.set(target, "Force body yaw", true)
						plist.set(target, "Force body yaw value", (self.globals.resolver_data[target].side) > 0 and 60 or -60)
						self.globals.resolver_data[target].lastplistupdate = globals.tickcount() + 10
						self.state[target] = "CENTER"
					elseif math.abs(yaw_delta) >= 33 then
						plist.set(target, "Force body yaw", true)
						plist.set(target, "Force body yaw value", yaw_delta)
						self.state[target] = "CENTER"
						self.globals.resolver_data[target].lastplistupdate = globals.tickcount() + 10
					elseif self.globals.resolver_data[target].lastplistupdate < globals.tickcount() then
						plist.set(target, "Force body yaw", false)
						self.state[target] = ""
					else
						plist.set(target, "Force body yaw", false)
						self.state[target] = ""
					end

				end
			elseif self.ui.menu.Misc.resolver() and resikmodexd == "New" then
				local players = entity.get_players(true)      
				if #players == 0 then
					return
				end
				for _, i in next, players do

					local target = i
					if self.globals.resolver_data[target] == nil then
						local data = self.helpers:fetch_data(target)
						self.globals.resolver_data[target] = {
							current = data,
							last_valid_record = data
						}
					else
						local simulation_time = self.helpers:time_to_ticks(entity.get_prop(target, "m_flSimulationTime"))
						if simulation_time ~= self.globals.resolver_data[target].current.simulation_time then
							table.insert(self.globals.resolver_data[target], 1, self.globals.resolver_data[target].current)
							local data = self.helpers:fetch_data(target)
							if simulation_time - self.globals.resolver_data[target].current.simulation_time >= 1 then
								self.globals.resolver_data[target].last_valid_record = data
							end
							self.globals.resolver_data[target].current = data
							for i = #self.globals.resolver_data[target], 1, -1 do
								if #self.globals.resolver_data[target] > 16 then 
									table.remove(self.globals.resolver_data[target], i)
								end
							end
						end
					end

					if self.globals.resolver_data[target][1] == nil or self.globals.resolver_data[target][2] == nil or self.globals.resolver_data[target][3] == nil or self.globals.resolver_data[target][6] == nil or self.globals.resolver_data[target][7] == nil then
						return
					end
					
					
					local yaw_delta = self.helpers:normalize(self.globals.resolver_data[target].current.eye_angles.y - self.globals.resolver_data[target][1].eye_angles.y)
					local yaw_delta2 = self.helpers:normalize(self.globals.resolver_data[target][2].eye_angles.y - self.globals.resolver_data[target][3].eye_angles.y)
					local yaw_delta3 = self.helpers:normalize(self.globals.resolver_data[target][6].eye_angles.y - self.globals.resolver_data[target][7].eye_angles.y)

					if math.abs(yaw_delta) >= 33 then
						self.globals.resolver_data[target].lastyawupdate = globals.tickcount() + 10
						self.globals.resolver_data[target].side = yaw_delta
					end

					if self.globals.resolver_data[target].lastyawupdate == nil then self.globals.resolver_data[target].lastyawupdate = 0 end
					if self.globals.resolver_data[target].lastplistupdate == nil then self.globals.resolver_data[target].lastplistupdate = 0 end
					if self.globals.resolver_data[target].skitterupdate == nil then self.globals.resolver_data[target].skitterupdate = 0 end

					if math.abs(yaw_delta2 - yaw_delta3) > 90 then
						self.globals.resolver_data[target].skitterupdate = globals.tickcount() + 10
					end
					if self.globals.resolver_data[target].skitterupdate - globals.tickcount() > 0 then
						self.state[target] = "SKITTER"
						resolver_flag[target] = "SKITTER"
						if math.abs(yaw_delta2 - yaw_delta3) == 0 then
							plist.set(target, "Force body yaw value", 0)
						else
							plist.set(target, "Force body yaw value", (60 or -60) > 0 and yaw_delta)
						end
					elseif self.globals.resolver_data[target].lastyawupdate > globals.tickcount() and yaw_delta == 0 and self.globals.resolver_data[target].skitterupdate - globals.tickcount() < 0 then
						plist.set(target, "Force body yaw", true)
						plist.set(target, "Force body yaw value", (self.globals.resolver_data[target].side) > 0 and 60 or -60)
						self.globals.resolver_data[target].lastplistupdate = globals.tickcount() + 10
						self.state[target] = "CENTER"
					elseif math.abs(yaw_delta) >= 33 then
						plist.set(target, "Force body yaw", true)
						plist.set(target, "Force body yaw value", (60 or -60) > 0 and yaw_delta)
						self.state[target] = "CENTER"
						self.globals.resolver_data[target].lastplistupdate = globals.tickcount() + 10
					elseif self.globals.resolver_data[target].lastplistupdate < globals.tickcount() then
						plist.set(target, "Force body yaw", false)
						self.state[target] = ""
					else
						plist.set(target, "Force body yaw", false)
						self.state[target] = ""
					end

				end
			end

		end,
	}

	:struct 'net_channel' {
		native_GetNetChannelInfo = vtable_bind("engine.dll", "VEngineClient014", 78, "void* (__thiscall*)(void* ecx)"),
		native_GetLatency = vtable_thunk(9, "float(__thiscall*)(void*, int)"),

		get_lerp_time = function ()
			local ud_rate = cvar.cl_updaterate:get_int()
		
			local min_ud_rate = cvar.sv_minupdaterate:get_int()
			local max_ud_rate = cvar.sv_maxupdaterate:get_int()
		
			if (min_ud_rate and max_ud_rate) then
				ud_rate = max_ud_rate
			end
			local ratio = cvar.cl_interp_ratio:get_float()
		
			if (ratio == 0) then
				ratio = 1
			end
			local lerp = cvar.cl_interp:get_float()
			local c_min_ratio = cvar.sv_client_min_interp_ratio:get_float()
			local c_max_ratio = cvar.sv_client_max_interp_ratio:get_float()
		
			if (c_min_ratio and  c_max_ratio and  c_min_ratio ~= 1) then
				ratio = clamp(ratio, c_min_ratio, c_max_ratio)
			end
			return math.max(lerp, (ratio / ud_rate));
		end
	}

	:struct 'defensive' {
		cmd = 0,
		check = 0,
		defensive = 0,
		player_data = {},
		sim_time = globals.tickcount(),
		active_until = 0,
		ticks = 0,
		active = false,

		defensive_active = function(self)
    	local me = entity.get_local_player()
		if me == nil then return end
    	local tickcount = globals.tickcount()
    	local sim_time = entity.get_prop(me, "m_flSimulationTime")
    	local sim_diff = toticks(sim_time - self.sim_time)

    	if sim_diff < 0 then
    	  self.active_until = tickcount + math.abs(sim_diff) -- - toticks(utils.net_channel().avg_latency[1])
    	end

			self.ticks = self.helpers:clamp(self.active_until - tickcount, 0, 16)
    	self.active = self.active_until > tickcount

			self.sim_time = sim_time
		end,

		predict = function(self)
			local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
			self.defensive = math.abs(tickbase - self.check)
			self.check = math.max(tickbase, self.check or 0)
			self.cmd = 0
		end,

		reset = function(self)
			self.check, self.defensive = 0, 0
		end,

		defensivestatus = function(self)
			local player = entity.get_local_player()
			if not entity.is_alive(player) then
				return
			end

			local origin = vector(entity.get_prop(entity.get_local_player(), "m_vecOrigin"))
			local simtime = entity.get_prop(player, "m_flSimulationTime")
			local sim_time = self.helpers:time_to_ticks(simtime)
			local player_data = self.player_data[player]
			if player_data == nil then
				self.player_data[player] = {
					last_sim_time = sim_time,
					defensive_active_until = 0,
					origin = origin
				}
			else
				local delta = sim_time - player_data.last_sim_time
				if delta < 0 then
					player_data.defensive_active_until = globals.tickcount() + math.abs(delta)
				elseif delta > 0 then
					player_data.breaking_lc = (player_data.origin - origin):length2dsqr() > 4096
					player_data.origin = origin
				end
				player_data.last_sim_time = sim_time    
			end
		end
	}

	:struct 'predict' {

		accelerate = function (self, forward, target_speed, velocity)
			local current_speed = velocity.x * forward.x + velocity.y * forward.y + velocity.z * forward.z

			local speed_delta = target_speed - current_speed

			if speed_delta > 0 then
				local acceleration_speed = cvar.sv_accelerate:get_float() * globals.tickinterval() * math.max(250, target_speed)
			
				if acceleration_speed > speed_delta then
					acceleration_speed = speed_delta
				end
			
				velocity = velocity + (acceleration_speed * forward)
			end
		
			return velocity
		end,

		calculate_velocity = function (self, forward, velocity)
			local me = entity.get_local_player()
			local target_speed = 450
			local max_speed = entity.get_prop(me, "m_flMaxspeed")
		
			--local target_velocity = forward:normalized() * math.min(max_speed, target_speed)
		
			velocity = self:accelerate(forward, target_speed, velocity)
		
			if velocity:lengthsqr() > max_speed^2 then
				velocity = (velocity / velocity:length()) * max_speed
			end
		
			return velocity
		end,

		run = function (self, origin, ticks, ent, forward)
			local velocity = vector(entity.get_prop(ent, 'm_vecVelocity'))

			local positions = {}
			for i = 1, ticks do
				velocity = self:calculate_velocity(forward, velocity)
				origin = origin + (velocity * globals.tickinterval())
				positions[i] = origin
			end

			return positions
		end
	}

	:struct 'peekbot' {
		last_target = nil,
		last_tick = 0,
		last_point = vector(),
		active = false,
		was_enabled = false,
		origin = vector(),
		renderpoints = vector(),

		get_target = function (self)
			local me = entity.get_local_player()
			local target = client.current_threat()
			if not target or entity.is_dormant(target) then
				return
			end

			local hitboxes = {}
			for i = 0, 17 do
				hitboxes[i] = vector(entity.hitbox_position(target, i))
			end

			local from = vector(entity.get_origin(me))
			local to = vector(entity.get_origin(target))
			local pitch, yaw, roll = (to - from):angles()

			return {
				ent = target,
				pos = to,
				hitboxes = hitboxes,
				angle = yaw
			}
		end,

		validate_weapon = function(self)
			local me = entity.get_local_player()

			local weapon_ent = entity.get_player_weapon(entity.get_local_player())
			if not weapon_ent then
				return
			end
		
			local weapon = weapons(weapon_ent)
			if not weapon then
				return
			end
		
			if weapon.type == "knife" or weapon.type == "grenade" or weapon.type == "c4" or weapon.type == "taser" then
				return
			end
		
			if math.max(entity.get_prop(weapon_ent, "m_flNextPrimaryAttack"), entity.get_prop(me, "m_flNextAttack")) - globals.tickinterval() - globals.curtime() >= 0 then
				return
			end
		
			if entity.get_prop(weapon_ent, "m_zoomLevel") ~= nil and entity.get_prop(weapon_ent, "m_zoomLevel") == 0 and (weapon.type == "sniper" or weapon.type == "sniperrifle") then
				return false
			end
		
			return true
		end,

		get_max_backtrack = function (self)
			local nci = self.net_channel.native_GetNetChannelInfo()

			if not nci then
				return 0
			end
		
			local sv_maxunlag = cvar.sv_maxunlag:get_float()
			--local is_dead = simtime < math.floor(entity.get_prop(entity.get_local_player(), "m_nTickBase")*globals.tickinterval() - sv_maxunlag)--flDeadTime
			local max_ticks = globals.curtime() - math.floor(entity.get_prop(entity.get_local_player(), "m_nTickBase")*globals.tickinterval() - sv_maxunlag)
		
			local outgoing, incoming = self.net_channel.native_GetLatency(nci, 0), self.net_channel.native_GetLatency(nci, 1)
			local correct = self.helpers:clamp( outgoing + incoming + self.net_channel:get_lerp_time(), 0, sv_maxunlag );
			return self.helpers:clamp(sv_maxunlag + correct*2, 0, max_ticks) / globals.tickinterval()
		end,

		generate_points = function (self, target, ticks, deadzone)
			local me = entity.get_local_player()

			local points = {}
			for _, angle in ipairs({90, -90}) do
				local forward = vector():init_from_angles(0, target.angle + angle, 0)
				local cur_points = self.predict:run(self.origin, ticks - deadzone, me, forward)

				for _,v in ipairs(cur_points) do
					table.insert(points, v)
				end
			end

			return points
		end,

		collide_point = function (self, point)
			local me = entity.get_local_player()
			local min = vector(entity.get_prop(me, 'm_vecMins'))
			local max = vector(entity.get_prop(me, 'm_vecMaxs'))

			local from = vector(entity.get_origin(me)) + vector((min.x + max.x)/2, (min.y + max.y)/2, (min.z + max.z)/2 + 10)
			local to = point + vector((min.x + max.x)/2, (min.y + max.y)/2, (min.z + max.z)/2 + 10)

			local tr = trace.hull(from, to, min, max, {
				skip = me,
				mask = 'MASK_SHOT',
				type = 'TRACE_EVERYTHING'
			})

			return tr.end_pos - vector((min.x + max.x)/2, (min.y + max.y)/2, (min.z + max.z)/2 + 10)
		end,

		get_best_point = function (self, target, points, amount)
			local me = entity.get_local_player()
			local pos = vector(entity.get_origin(me))
			local len = #points

			local best_point = {damage = 0, point = nil, ticks = 0}
			for i = 1, len, len/(amount*2) do
				local i = self.helpers:clamp(math.floor(i + 0.5), 1, len)
				points[i] = self:collide_point(points[i])
				self.renderpoints = points[i]
				local point = points[i] + vector(0, 0, entity.get_prop(me, 'm_vecViewOffset[2]'))

				local best_damage = 0
				local hitbox_pos
				for _, hitbox in ipairs(target.hitboxes) do
					local _, damage = client.trace_bullet(me, point.x, point.y, point.z, hitbox.x, hitbox.y, hitbox.z, me)

					if damage > best_damage then
						best_damage = damage
						hitbox_pos = hitbox
					end
				end

				if best_damage > best_point.damage or (best_point.point and best_damage == best_point.damage and pos:dist2d(best_point.point) > pos:dist2d(points[i]) ) then
					best_point.damage = best_damage
					best_point.point = points[i]
					best_point.hitbox = hitbox_pos
					best_point.ticks = i
				end
			end

			if best_point.ticks > len/2 then
				best_point.ticks = best_point.ticks - len/2
			end

			if not best_point.point then
				return
			end
			
			return best_point
		end,

		can_peek = function (self, target)
			if not target then
				return
			end

			if not self:validate_weapon() then
				return
			end
			
			local max_backtrack = self:get_max_backtrack()

			local deadzone = max_backtrack > 24 and 12 or 6
			local points = self:generate_points(target, max_backtrack, deadzone)

			self.available_points = points

			local point_amount = 6
			local best_point = self:get_best_point(target, points, point_amount)

			if not best_point then
				return
			end

			if best_point.damage < math.min(self.helpers:get_damage(), entity.get_prop(target.ent, 'm_iHealth')) then
				return
			end

			return {
				tick_time = best_point.ticks,
				tick = max_backtrack - deadzone,
				point = best_point.point,
				hitbox = best_point.hitbox,
				target = target.ent
			}
		end,

		check_safety = function (self, target, point, ticks, allowed_damage)
			if ticks < 14 then
				return
			else
				ticks = ticks - 14
			end

			local me = entity.get_local_player()

			local min = vector(entity.get_prop(target, 'm_vecMins'))
			local max = vector(entity.get_prop(target, 'm_vecMaxs'))

			local origin = vector(entity.get_origin(target)) + vector(0,0, entity.get_prop('m_vecViewOffset[2]'))
			local eye = origin + vector(entity.get_prop(target, 'm_vecVelocity')) * globals.tickinterval() * ticks

			--local tr = trace.hull(origin, eye, min, max, {
			--    skip = target,
			--    mask = 'MASK_SHOT',
			--    type = 'TRACE_EVERYTHING'
			--})

			local fraction = client.trace_line(target, origin.x, origin.y, origin.z, eye.x, eye.y, eye.z)

			eye = origin:lerp(eye, fraction)

			local offset = point - vector(entity.get_origin(me))
			local best_damage = 0
			for i = 2, 8 do
				local hitbox = vector(entity.hitbox_position(me, i)) + offset
				local _, damage = client.trace_bullet(target, eye.x, eye.y, eye.z, hitbox.x, hitbox.y, hitbox.z, target)

				if damage > best_damage then
					best_damage = damage
				end
			end

			return best_damage <= allowed_damage
		end,

		move_to = function (self, cmd, point)
			local me = entity.get_local_player()
			local origin = vector(entity.get_origin(me))
			local _, yaw = origin:to(point):angles()

			cmd.in_forward = 1
			cmd.in_back = 0
			cmd.in_moveleft = 0
			cmd.in_moveright = 0
			cmd.in_speed = 0

			cmd.forwardmove = 800
			cmd.sidemove = 0

			cmd.move_yaw = yaw
		end,


		run = function (self, cmd)
			if self.ui.menu.Misc.enablepeek() then
				local originalQuickpeek2 = self.ref.rage.quickpeek[2]
				--ui.set(self.ui.menu.Misc.aipeek, originalQuickpeek2)

				-- GÅ‚Ã³wna funkcja
				if not self.ui.menu.Misc.aipeek:get() then

					ui.set(self.ref.rage.quickpeek[1], true)
					
					ui.set(self.ref.rage.quickpeek[2], originalQuickpeek2)
					
					self.was_enabled = false

					return
				else
					
					ui.set(self.ref.rage.quickpeek[1], true)
				--	ui.set(self.ref.rage.quickpeek[2], self.ui.menu.Misc.aipeek:get())
					--ui.set(self.ref.rage.quickpeek[2], 'Always on')
					--ui.set(self.ref.rage.quickpeek2[1], 'Retreat on shot', 'Retreat on key release')

					local me = entity.get_local_player()
					if not self.was_enabled then
						self.origin = vector(entity.get_origin(me))
						self.was_enabled = true
					end

					local target = self:get_target()

					if not self.active then
						local data = self:can_peek(target)
						if data then
							self.tick_time = data.tick_time
							self.last_tick = data.tick + globals.tickcount()
							self.last_target = target.ent
							self.last_point = data.point
							self.last_hitbox = data.hitbox
							self.active = true
						end
					end

					--if self.active and not self:check_safety(self.last_target, self.last_point, self.tick_time, 25) and self.active then
					--	self.active = false
					--	--cmd.discharge_pending = true
					--	return
					--end

					if self.last_tick - globals.tickcount() < 0 or (target and self.last_target ~= target.ent) then
						self.active = false
					end

					local peeksetts = self.ui.menu.Misc.aisettings:get()

					if self.active then
						self:move_to(cmd, self.last_point)
						if peeksetts == "Aggressive" then 
						cmd.discharge_pending = true
						else
						return
						end
					elseif vector(entity.get_origin(me)):dist2d(self.origin) > 32 then
						self:move_to(cmd, self.origin)
						if peeksetts == "Aggressive" then 
						cmd.discharge_pending = true
						else
						return
						end
					end
				end
			end
		end
	}


	:struct 'visuals' {
		active_fraction2 = 0,
		enabled_fraction = 0,
		origin = vector(),
		point = vector(),
		hitbox = vector(),
		max_delta = 0,
		delta = 0,
		scoped = 0,
		active_fraction = 0,
		inactive_fraction = 0,
		hide_fraction = 0,
		scoped_fraction = 0,
		ap_fraction = 0,
		weapon_fraction = 0,
		fraction = 0,

    render_crosshair = function (self)
      
    end,
    
    
		render = function(self)
			local me = entity.get_local_player()

			if not me or not entity.is_alive(me) then
				return
			end
			local state = self.helpers:get_state()

			local ss = {client.screen_size()}
			self.ss = {
				x = ss[1],
				y = ss[2]
			}

            local scoped_frac

			if entity.get_prop(me, "m_bIsScoped") == 1 then
				self.scoped = self.helpers:clamp(self.scoped + globals.frametime()/0.2, 0, 1)
				scoped_frac = self.scoped ^ (1/2)
			else
				self.scoped = self.helpers:clamp(self.scoped - globals.frametime()/0.2, 0, 1)
				scoped_frac = self.scoped ^ 2
			end

			local r, g, b, a = self.ui.menu.Visuals.indicators:get_color()
            local size = "25"
            local mainClr = {}
            mainClr.r, mainClr.g, mainClr.b, mainClr.a = 176,149,255,255 

            local w,h = client.screen_size()
            local wm = { 255,255,255,255 }
            local float = math.sin(globals.realtime() * 2.3) * 15
            local func = string[size == "cb" and "upper" or "lower"]
            local strike_w, strike_h = renderer.measure_text(size, func"Paradox")
        

--		self.menu.Visuals.watermark = group:combobox("Style", {"Default", "Country-based"}):depend({self.menu.Visuals.xd, "Watermark"})

		local watermarkstylexd = self.ui.menu.Visuals.watermark:get() 
		local watermarkpozycja = self.ui.menu.Visuals.watermarkpos:get() 
		local watermark_type = self.ui.menu.Visuals.watermark_type:get()

		local steam_id = entity.get_steam64(me)
		local steam_avatar = images.get_steam_avatar(steam_id)
		local wtr_img = watermark_type == "Avatar" and steam_avatar or download

		--#region crosshair

			if self.ui.menu.Visuals.xd:get('Watermark') then
				if watermarkstylexd == "Modern" then
					local sizeX, sizeY = client.screen_size()
					if wtr_img ~= nil and download ~= nil then
						local mainY = 35
						local marginX, marginY = renderer.measure_text("-d","PARADOX.PUB")

						renderer.gradient(2.5, sizeY/2 + mainY - 2, marginX*2, marginY*2 - 1, mainClr.r, mainClr.g, mainClr.b, 155, mainClr.r, mainClr.g, mainClr.b, 0, true)

						if wtr_img ~= nil then
							wtr_img:draw(5, sizeY/2 + mainY, 25, marginY*1.4, 255, 255, 255, 255)
						end

						renderer.text(33, sizeY/2 - 2 + mainY, 255, 255, 255, 255, "-d", nil, "PARADOX" .. ".PUB")
						renderer.text(33, sizeY/2 - 4 + marginY + mainY, 255, 255, 255, 255, "-d", nil, "[PRIVATE]")
					else
						downloadFile()
					end
				elseif watermarkstylexd == "Default" then
					local r,g,b = self.ui.menu.Visuals.indicators:get_color()
					local text = "\a"..rgba_to_hex(r,g, b, 220).."P A R "..text_fade_animation_guwno(2,255,255,255,220,"A D O X") .."\a"..rgba_to_hex(r, g, b, 220).." ["..string.upper(login.build).. "]"
					local text_size = vector(renderer.measure_text("c", text))

					if self.ui.menu.Visuals.watermark_space:get() then
						text = text:gsub(" ", "")
					end
					if watermarkpozycja == "left" then
						renderer.text(text_size.x/2+10, h/2 - 10, 255 , 255, 255, 255, "c",  nil, text)
					elseif watermarkpozycja == "right" then
						renderer.text(w - text_size.x /2 - 10, h/2 - 10, 255 , 255, 255, 255, "c",  nil, text)
					elseif watermarkpozycja == "bottom" then  
						renderer.text(w / 2, h - 15, 255 , 255, 255, 255, "c",  nil, text)
					elseif watermarkpozycja == "top" then
						renderer.text(w / 2, 70, 255 , 255, 255, 255, "c",  nil, text)
					end
					 --renderer.text(text_size.x/2+10, h/2 - 10, 255 , 255, 255, 255, "c",  nil, text)
				end
			else
				          --renderer.text(w/2, h/2 + 500 + float, 255,150,150,255, "cb", 0,  self.helpers:rgba_to_hex( r, g, b, ((255-(150*self.weapon_fraction)) * math.abs(math.cos(globals.curtime()*2)))) .. "PARADOX")
						  if not self.ui.menu.Visuals.indicators:get() then
						  renderer.text(self.ss.x/2 + ((strike_w + 2)/2) * scoped_frac - 19, self.ss.y/2 + 500 + float, self.ss.y/2 + 20, 255, 255, 255, 255-(150*self.weapon_fraction), "cb" .. "cb", func"", func("\a" .. self.helpers:rgba_to_hex( r, g, b, ((255-(150*self.weapon_fraction)) * math.abs(math.cos(globals.curtime()*2)))) .. "PARADOX"))
						  end
			end

			if self.ui.menu.Visuals.debug_panel:get() ~= "Off" then
				local pos_wtm = {5, self.ss.y /2 - 150}
				if self.ui.menu.Visuals.debug_panel:get() == "#1" then
					local guwno_x, guwno_y = renderer.measure_text("-d",string.upper("paradox    ["..login.build.."]    |    "..login.username.."    |    "..round(client.latency()*1000, 0).."ms"))
					renderer.gradient(pos_wtm[1], pos_wtm[2] - 5, guwno_x / 2 -1, guwno_y + 8, 0,0,0,0,0,0,0,50, true)
					renderer.gradient(pos_wtm[1] + guwno_x / 2 -1, pos_wtm[2] - 5, guwno_x / 2 + 1, guwno_y + 8, 0,0,0,50,0,0,0,0, true)
					renderer.text(pos_wtm[1], pos_wtm[2], 255,255,255,255, "-d", nil, string.upper("paradox    ["..login.build.."]    |    "..login.username.."    |    "..round(client.latency()*1000, 0).."ms"))
					--140, 125, 255
					renderer.gradient(pos_wtm[1], pos_wtm[2] + 13, guwno_x / 2 -1, 1, 140, 125, 255,0,140, 125, 255,255, true)
					renderer.gradient(pos_wtm[1] + guwno_x / 2 -1, pos_wtm[2] + 13, guwno_x / 2 + 1, 1, 140, 125, 255,255,140, 125, 255,0, true)

					renderer.text(pos_wtm[1], pos_wtm[2] + 15, 255,255,255,255, "-d", nil, string.upper("-condition: "..state..""))
					renderer.text(pos_wtm[1], pos_wtm[2] + 25, 255,255,255,255, "-d", nil, string.upper("-target: "..entity.get_player_name(client.current_threat())..""))
					renderer.text(pos_wtm[1], pos_wtm[2] + 35, 255,255,255,255, "-d", nil, string.upper("-exploit  charge: "..antiaim_funcs.get_tickbase_shifting()..""))
					renderer.text(pos_wtm[1], pos_wtm[2] + 45, 255,255,255,255, "-d", nil, string.upper("-desync: "..math.floor(antiaim_funcs.get_desync(2))..""))
				end

				if self.ui.menu.Visuals.debug_panel:get() == "#2" then
					renderer.text(pos_wtm[1], pos_wtm[2] + 4, 255, 255, 255, 255, "", 0, "paradox.pub - " .. string.lower(login.username))
					renderer.text(pos_wtm[1], pos_wtm[2] + 14, 255, 255, 255, 255, "", 0, "version: \a" ..self.helpers:rgba_to_hex(255,255,255,255 * math.abs(math.cos(globals.curtime()*2))) .. string.lower(login.build))
					renderer.text(pos_wtm[1], pos_wtm[2] + 24, 255, 255, 255, 255, "", 0, "target: " .. string.lower(entity.get_player_name(client.current_threat())))
					renderer.text(pos_wtm[1], pos_wtm[2] + 34, 255, 255, 255, 255, "", 0, "body yaw: " .. math.floor(antiaim_funcs.get_body_yaw(2)))
					renderer.text(pos_wtm[1], pos_wtm[2] + 44, 255, 255, 255, 255, "", 0, "exploit charge: " .. antiaim_funcs.get_tickbase_shifting()) 
					renderer.text(pos_wtm[1], pos_wtm[2] + 54, 255, 255, 255, 255, "", 0, "choke: " .. globals.chokedcommands())
					renderer.text(pos_wtm[1], pos_wtm[2] + 64, 255, 255, 255, 255, "", 0, "overlap: " .. math.floor(antiaim_funcs.get_overlap() * 100))
				end

				if self.ui.menu.Visuals.debug_panel:get() == "#3" then
					local debug_pnl_x, debug_pnl_y = renderer.measure_text("","user: "..string.lower(login.username))
					--local debug_pnl_x_text, debug_pnl_y_text = renderer.measure_text("",gradient_text("paradox.pub", {255,30,90,255}, 10))
					--container_glow(x/200,  y/2 + 15, 165, 50, hotkeyc[1], hotkeyc[2], hotkeyc[3], hotkeyc[4], 1.2, hotkeyc[1], hotkeyc[2], hotkeyc[3])
					container_glow(pos_wtm[1], pos_wtm[2] + 70, debug_pnl_x + 105, 78, 30,30,30,255, 1.2, 255,255,255)
					renderer.text(pos_wtm[1] + 4, pos_wtm[2] + 70 + 3, 255, 255, 255, 255, "", 0, ">> paradox.pub")
					renderer.text(pos_wtm[1] + 4, pos_wtm[2] + 70 + 17, 255, 255, 255, 255, "", 0, ">> user: "..string.lower(login.username))
					renderer.text(pos_wtm[1] + 4, pos_wtm[2] + 70 + 31, 255, 255, 255, 255, "", 0, ">> build: \a"..self.helpers:rgba_to_hex(255,255,255,255 * math.abs(math.cos(globals.curtime()*2))) .. string.lower(login.build))
					renderer.text(pos_wtm[1] + 4, pos_wtm[2] + 70 + 45, 255, 255, 255, 255, "", 0, ">> target: " .. string.lower(entity.get_player_name(client.current_threat())))
					renderer.text(pos_wtm[1] + 4, pos_wtm[2] + 70 + 59, 255, 255, 255, 255, "", 0, ">> exploit charge: " .. antiaim_funcs.get_tickbase_shifting()) 
				end
			end

            if self.ui.menu.Visuals.xd:get('Defensive Indicator') then
             --   icon_size = 30
    
                local r,g,b,a = 176,149,255,255 
                local w,h = client.screen_size()
        
                if to_draw == "yes" then
            
                    draw_art = to_draw_ticks * 100 / 40
                
					--renderer.blur(w / 2 - 50, h / 2  * 0.5 - 9, 100, 900, 1, 1)
                    renderer.text(w / 2 , h / 2  * 0.5 - 10 , 255, 255, 255, 255, "c", 0, string.format("\aFFFFFFFF-defensive-", rgba_to_hex(255, 255, 255, 255)))
					script.renderer:glow_module(w / 2 - 50, h / 2  * 0.5,100,6, 14,0,{r,g,b,50}, {30,30,30,120})
                    renderer.rectangle(w / 2, h / 2  * 0.5 +1,draw_art / 2,4,r,g,b,255)
                    renderer.rectangle(w / 2, h / 2  * 0.5 + 1,-draw_art / 2,4,r,g,b,255)

                    if to_draw_ticks == 39 then
                        to_draw_ticks = 0
                        to_draw = "no"
                       -- lerp_alpha = lerp2(lerp_alpha,0, globals.frametime() * 30)
                    end
                    to_draw_ticks = to_draw_ticks + 1
                end
            end

			calculatePercentage = function(ticks, przez)
				local percentage = (ticks / przez) * 100
				return percentage
			end

			if self.ui.menu.Visuals.xd:get('Slowdown Indicator') then
				local is_defensive = to_draw == "yes" --and ui.get(refs.dt[2])
				local slowed_down_value = entity.get_prop(entity.get_local_player(),"m_flVelocityModifier") * 100
				local size_bar = slowed_down_value * 98 / 100
				--local r,g,b,a = lua_color.a, lua_color.g, lua_color.b --local lua_color = {r = 176, g = 149, b = 255} --204, 135, 255 rgb(142, 153, 255) rgb(176, 183, 255)
			    local r,g,b,a = 176,149,255,255 
                local w,h = client.screen_size()

		
				if slowed_down_value < 100 then
					renderer.text(w / 2 , is_defensive and h / 2 * 0.55 - 10 or h / 2  * 0.5 - 10 , 255, 255, 255, 255, "c", 0, string.format("\aFFFFFFFFslowed down \aFFFFFFFF(\a%s%s%%\aFFFFFFFF)", rgba_to_hex(255,255,255, 255), math.floor(calculatePercentage(size_bar, 100))))
					--==renderer.rectangle(w / 2 - 50, h / 2  * 0.5 + 0.3,100,4,50,50,50,255)
					--ctw.m_render:glow_module(w / 2 - 50, is_defensive and h / 2 * 0.55 or h / 2 * 0.5,100,3, 14,2,{r,g,b,50}, {30,30,30,255})
					script.renderer:glow_module(w / 2 - 50, is_defensive and h / 2 * 0.55 or h / 2 * 0.5,100,6, 14,0,{r,g,b,50}, {30,30,30,120})
					renderer.rectangle(w / 2, is_defensive and h / 2 * 0.55 + 1 or h / 2 * 0.5 + 1,size_bar / 2,4,r,g,b,255)
					renderer.rectangle(w / 2, is_defensive and h / 2 * 0.55 + 1 or h / 2 * 0.5 + 1,-size_bar / 2,4,r,g,b,255)
				end
			end



			
            

	  local anim_ind = {dt_alpha = 0, osaa_alpha = 0, dt_osaa_pos_mod = 0, fstand_alpha = 0, fstand_pos_mod = 0, dmg_alpha = 0, scope = 0}
      local style = self.ui.menu.Visuals.indicatorstyle:get() 

      --#region crosshair
      if style == "Default" then
        if not self.ui.menu.Visuals.indicators:get() then
			  	return
			  end

        local visual_size = self.ui.menu.Visuals.indicatorfont:get()
      
			  local size = ""
			  if visual_size == "small" then
			  	size = "-"
			  elseif visual_size == "normal" then
			  	size = "c"  
			  end

			  local func = string[size == "-" and "upper" or "lower"]

			  local strike_w, strike_h = renderer.measure_text(size, func"Paradox recode")

			  local weapon_ent = entity.get_player_weapon(me)
			  local weapon = entity.get_classname(weapon_ent)
			  if weapon ~= nil then
			  	if weapon:find("Grenade") then
			  		self.weapon_fraction = self.helpers:clamp(self.weapon_fraction + globals.frametime()/0.15, 0, 1)
			  	else
			  		self.weapon_fraction = self.helpers:clamp(self.weapon_fraction - globals.frametime()/0.15, 0, 1)
			  	end
			  end
			  	--ctx.m_render:glow_module(x/2 + ((strike_w + 2)/2) * scoped_frac - strike_w/2 + 4, y/2 + 20, strike_w - 3, 0, 10, 0, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))}, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))})
			  renderer.text(self.ss.x/2 + ((strike_w + 2)/2) * scoped_frac, self.ss.y/2 + 20, 255, 255, 255, 255-(150*self.weapon_fraction), size .. "c", 0, func"Paradox ", func("\a" .. self.helpers:rgba_to_hex( r, g, b, ((255-(150*self.weapon_fraction)) * math.abs(math.cos(globals.curtime()*2)))) .. "recode"))

			  local next_attack = entity.get_prop(me, "m_flNextAttack")
			  local next_primary_attack = entity.get_prop(entity.get_player_weapon(me), "m_flNextPrimaryAttack")

			  local dt_toggled = ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2])
			  local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime()) --or (ctx.helpers.defensive and ctx.helpers.defensive > ui.get(ctx.ref.dt_fl))

			  if dt_toggled and dt_active then
			  	self.active_fraction = self.helpers:clamp(self.active_fraction + globals.frametime()/0.15, 0, 1)
			  else
			  	self.active_fraction = self.helpers:clamp(self.active_fraction - globals.frametime()/0.15, 0, 1)
			  end

			  if self.ui.menu.Misc.aipeek:get() then
			  	self.ap_fraction = self.helpers:clamp(self.ap_fraction + globals.frametime()/0.15, 0, 1)
			  else
			  	self.ap_fraction = self.helpers:clamp(self.ap_fraction - globals.frametime()/0.15, 0, 1)
			  end

			  if dt_toggled and not dt_active then
			  	self.inactive_fraction = self.helpers:clamp(self.inactive_fraction + globals.frametime()/0.15, 0, 1)
			  else
			  	self.inactive_fraction = self.helpers:clamp(self.inactive_fraction - globals.frametime()/0.15, 0, 1)
			  end

			  if ui.get(self.ref.rage.os[1]) and ui.get(self.ref.rage.os[2]) and not dt_toggled then
			  	self.hide_fraction = self.helpers:clamp(self.hide_fraction + globals.frametime()/0.15, 0, 1)
			  else
			  	self.hide_fraction = self.helpers:clamp(self.hide_fraction - globals.frametime()/0.15, 0, 1)
			  end

			  if math.max(self.hide_fraction, self.inactive_fraction, self.active_fraction) > 0 then
			  	self.fraction = self.helpers:clamp(self.fraction + globals.frametime()/0.2, 0, 1)
			  else
			  	self.fraction = self.helpers:clamp(self.fraction - globals.frametime()/0.2, 0, 1)
			  end

			  local dt_size, dt_h = renderer.measure_text(size, func"DT ")
			  local ready_size = renderer.measure_text(size, func"READY")
			  renderer.text(self.ss.x/2 + ((dt_size + ready_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h, 255, 255, 255, self.active_fraction * (255 - (150*self.weapon_fraction)), size .. "c", dt_size + self.active_fraction * ready_size + 1, func"DT ", func("\a" .. self.helpers:rgba_to_hex(155, 255, 155, 255 * self.active_fraction - (150*self.weapon_fraction)) .. "READY"))

			  local charging_size = renderer.measure_text(size, func"CHARGING")
			  local ret = self.helpers:animate_text(globals.curtime(), func"CHARGING", 255, 100, 100, 255 - (150*self.weapon_fraction))
			  renderer.text(self.ss.x/2 + ((dt_size + charging_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h, 255, 255, 255, self.inactive_fraction * (255 - (150*self.weapon_fraction)), size .. "c", dt_size + self.inactive_fraction * charging_size + 1, func"DT ", unpack(ret))

			  local hide_size = renderer.measure_text(size, func"HIDE ")
			  local active_size = renderer.measure_text(size, func"READY")
			  renderer.text(self.ss.x/2 + ((hide_size + active_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h, 255, 255, 255, self.hide_fraction * (255 - (150*self.weapon_fraction)), size .. "c", hide_size + self.hide_fraction * active_size + 1, func"HIDE ", func("\a" .. self.helpers:rgba_to_hex(155, 255, 155, (255 - (150*self.weapon_fraction)) * self.hide_fraction) .. "READY"))
      
			  local ap_size, ap_h = renderer.measure_text(size, func'a-p ')
			  renderer.text(self.ss.x/2 + ((ap_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h + dt_h * self.helpers:easeInOut(self.fraction), 255, 255, 255, (255 - (150*self.weapon_fraction)) * self.ap_fraction, size .. "c", ap_size * self.ap_fraction, func('a-p'))
      
			  local state_size = renderer.measure_text(size, '- ' .. func(state) .. ' -')
			  renderer.text(self.ss.x/2 + ((state_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + (strike_h + dt_h * self.helpers:easeInOut(self.fraction)) + (ap_h * self.helpers:easeInOut(self.ap_fraction)), 255, 255, 255, 255 - (150*self.weapon_fraction), size .. "c", 0, func('- ' .. state .. ' -'))
	  elseif style == "New" then
		local r, g, b, a = self.ui.menu.Visuals.indicators:get_color()

		local freestand_toggled = ui.get(self.ref.Antiaim.freestand[2])
		local qp_toggled = ui.get(self.ref.rage.quickpeek[1]) and ui.get(self.ref.rage.quickpeek[2])
		local dt_toggled = ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2])
		local hs_toggled = ui.get(self.ref.rage.os[1]) and ui.get(self.ref.rage.os[2]) and not dt_toggled
        local binds = string.format("\a%sQP  \a%sFS  \a%sHS", qp_toggled and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190),freestand_toggled and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190),hs_toggled and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190))
        local exploit = string.format("\a%sDT", dt_toggled and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190)) --local lua_color = {r = 176, g = 149, b = 255}
    --
        renderer.text(self.ss.x/2 + 27 * scoped_frac, self.ss.y/2 + 15, 0, 0, 0, 50, "c-", 0, gradient_text("PARADOX.PUB", {r,g,b,255}, 10))
		renderer.text(self.ss.x/2 + 5 * scoped_frac, self.ss.y/2 + 15 + 24 - 8 * scoped_frac, 255, 255, 255, 255, "c-", 0, exploit)
        renderer.text(self.ss.x/2 + 17 * scoped_frac, self.ss.y/2 + 15 + 8, 255, 255, 255, 255, "c-", 0, binds)
	--
        renderer.text(self.ss.x/2 + 17 * scoped_frac, self.ss.y/2 + 15 + 16 + 2000 * scoped_frac, 255, 255, 255, 255, "c-", 0, string.upper(state))


	  elseif style == "Second" then
		local ref = {
			aa_enable = ui.reference("AA","anti-aimbot angles","enabled"),
			pitch = ui.reference("AA","anti-aimbot angles","pitch"),
			pitch_value = select(2, ui.reference("AA","anti-aimbot angles","pitch")),
			yaw_base = ui.reference("AA","anti-aimbot angles","yaw base"),
			yaw = ui.reference("AA","anti-aimbot angles","yaw"),
			yaw_value = select(2, ui.reference("AA","anti-aimbot angles","yaw")),
			yaw_jitter = ui.reference("AA","Anti-aimbot angles","Yaw Jitter"),
			yaw_jitter_value = select(2, ui.reference("AA","Anti-aimbot angles","Yaw Jitter")),
			body_yaw = ui.reference("AA","Anti-aimbot angles","Body yaw"),
			body_yaw_value = select(2, ui.reference("AA","Anti-aimbot angles","Body yaw")),
			freestand_body_yaw = ui.reference("AA","Anti-aimbot angles","freestanding body yaw"),
			edgeyaw = ui.reference("AA","anti-aimbot angles","edge yaw"),
			freestand = {ui.reference("AA","anti-aimbot angles","freestanding")},
			roll = ui.reference("AA","anti-aimbot angles","roll"),
			slide = {ui.reference("AA","other","slow motion")},
			fakeduck = ui.reference("rage","other","duck peek assist"),
			quick_peek = {ui.reference("rage", "other", "quick peek assist")},
			doubletap = {ui.reference("rage", "aimbot", "double tap")},
			damage = {ui.reference("rage", "aimbot", "minimum damage override")},
			osaa = {ui.reference("aa", "other", "on shot anti-aim")},
			safe = ui.reference("rage", "aimbot", "force safe point"),
			baim = ui.reference("rage", "aimbot", "force body aim"),
			fl = ui.reference("aa", "fake lag", "limit"),
			legs = ui.reference("AA", "Other", "Leg movement")
		}
		

		local x, y = client.screen_size()
		local clr_r, clr_g, clr_b = self.ui.menu.Visuals.indicators:get_color()
		local frametime = globals.frametime() * 15

		local next_attack = entity.get_prop(me, "m_flNextAttack")
		local next_primary_attack = entity.get_prop(entity.get_player_weapon(me), "m_flNextPrimaryAttack")

		local dt_toggled = ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2])
		local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime()) 
		local qp_toggled = ui.get(self.ref.rage.quickpeek[1]) and ui.get(self.ref.rage.quickpeek[2])
		local dt_toggled = ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2])
		local hs_toggled = ui.get(self.ref.rage.os[1]) and ui.get(self.ref.rage.os[2]) and not dt_toggled
        local binds = string.format("\a%sQP  \a%sFS  \a%sHS", qp_toggled and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190),freestand_toggled and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190),hs_toggled and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190))
        local exploit = string.format("\a%sDT", dt_toggled and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190)) --local lua_color = {r = 176, g = 149, b = 255}
	
		anim_ind.dt_alpha = d_lerp(anim_ind.dt_alpha, ui.get(ref.doubletap[2]) and 1 or 0, frametime)
	
		animated_text(self.ss.x/2 - renderer.measure_text("b", "paradox")/2 + 23* scoped_frac , y/2 + 15, 7, {r=clr_r, g=clr_g, b=clr_b, a=255}, {r=50, g=50, b=50, a=255}, "b", "paradox")
	
		-- fhw9ufh984hf89
		renderer.text(self.ss.x/2 - 1 + 5 * scoped_frac, self.ss.y/2 + 23 + 20 - 1 * scoped_frac, 255, 255, 255, 255, "c-", 0, exploit)
        renderer.text(self.ss.x/2 - 2 + 18 * scoped_frac, self.ss.y/2 + 25 + 8, 255, 255, 255, 255, "c-", 0, binds)
	end
	

  

		end
	}

	local color_text = function( string, r, g, b, a)
		local accent = "\a" .. func.RGBAtoHEX(r, g, b, a)
		local white = "\a" .. func.RGBAtoHEX(255, 255, 255, a)
	
		local str = ""
		for i, s in ipairs(func.split(string, "$")) do
			str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
		end
	
		return str
	end
	

	function render_ogskeet_border(x,y,w,h,a,text)
		renderer.rectangle(x - 10, y - 48 ,w + 20, h + 16,12,12,12,a)
		renderer.rectangle(x - 9, y - 47 ,w + 18, h + 14,60,60,60,a)
		renderer.rectangle(x - 8, y - 46 ,w + 16, h + 12,40,40,40,a)
		renderer.rectangle(x - 5, y - 43 ,w + 10, h + 6,60,60,60,a)
		renderer.rectangle(x - 4, y - 42 ,w + 8, h + 4,12,12,12,a)
		renderer.texture(tex_id, x - 4, y - 42, w + 8, h + 4, 255, 255, 255, a, "r")
		renderer.gradient(x - 4,y - 42, w /2, 1, 59, 175, 222, a, 202, 70, 205, a,true)               
		renderer.gradient(x - 4 + w / 2 ,y - 42, w /2 + 8.5, 1,202, 70, 205, a,204, 227, 53, a,true)
		renderer.text(x, y - 40, 255,255,255,a, "", nil, text)
	end
	

	local vars = {
		localPlayer = 0,
		hitgroup_names = { 'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', '?', 'Gear' },
		aaStates = {"Global", "Stand", "Move", "Slowwalk", "Crouch", "Aero", "Aero + Crouch", "Legit-AA"},
		pStates = {"G", "S", "M", "SW", "C", "A", "AC", "LA"},
		sToInt = {["Global"] = 1, ["Stand"] = 2, ["Move"] = 3, ["Slowwalk"] = 4, ["Crouch"] = 5, ["Aero"] = 6, ["Aero + Crouch"] = 7,["Legit-AA"] = 8},
		intToS = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Slowwalk", [5] = "Crouch", [6] = "Aero", [7] = "Aero+C", [8] = "Legit"},
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

	local anim_time = 0.3
	local max_notifs = 6
	local data = {}
	local notifications = {
	
		new = function(string, r, g, b)
			table.insert(data, {
				time = globals.curtime(),
				string = string,
				color = {r, g, b, 255},
				fraction = 0
			})
			local time = 5
			for i = #data, 1, -1 do
				local notif = data[i]
				if #data - i + 1 > max_notifs and notif.time + time - globals.curtime() > 0 then
					notif.time = globals.curtime() - time
				end
			end
		end,
	
		render = function()
			local x, y = client.screen_size()
			local to_remove = {}
			local Offset = 0
			for i = 1, #data do
				local notif = data[i]
	
				local data = {rounding = 3, size = 2, glow = 2, time = 2}
	
				if notif.time + data.time - globals.curtime() > 0 then
					notif.fraction = func.clamp(notif.fraction + globals.frametime() / anim_time, 0, 1)
				else
					notif.fraction = func.clamp(notif.fraction - globals.frametime() / anim_time, 0, 1)
				end
	
				if notif.fraction <= 0 and notif.time + data.time - globals.curtime() <= 0 then
					table.insert(to_remove, i)
				end
	
				if i > 7 then
					table.remove(notif, i)
				end
	
				local fraction = func.easeInOut(notif.fraction)
	
				local r, g, b, a = unpack(notif.color)
				local string = color_text(notif.string, r, g, b, a * fraction)
	
				local strw, strh = renderer.measure_text("", string)
				local strw2 = renderer.measure_text("b", "")

				local paddingx, paddingy = 7, data.size
				local offsetY = y /2 - 350 --ui.get(menu.visualsTab.logOffset)
				local icon_size = 35
				local watermarkClr = {}
				watermarkClr.r, watermarkClr.g, watermarkClr.b = ctx.ui.menu.Visuals.screenlogs:get_color()
				local width2 = vector(renderer.measure_text('', ("xo-yaw for gamesense | %s"):format(login.build)));
				local style3 = ctx.ui.menu.Visuals.screenlogsstyle:get() 

				--#region crosshair
	
	
				if style3 == "Default" and ctx.ui.menu.Visuals.screenlogs:get() then
					Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 9) 
					render_ogskeet_border(x/2 - (strw/2), y - offsetY - Offset * fraction - 10, strw, 13, 255 * fraction, string)
				elseif style3 == "Normal" and ctx.ui.menu.Visuals.screenlogs:get() then
					Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*8 + 5)
					--logo
					script.renderer:glow_module(x/2 - (strw/2) - 36, y - offsetY - Offset * fraction - 20,10+10,15, 10,2,{watermarkClr.r, watermarkClr.g, watermarkClr.b,50}, {30,30,30,120})
					if logo ~= nil then
						logo:draw(x/2 - (strw/2) - 37, y - offsetY - Offset * fraction - 24, 23, 23, 255,255,255,255)
					else
						downloadFileLogo()
					end
					renderer.blur(x/2 - (strw/2) - 36, y - offsetY - Offset * fraction - 20, 10+10, 20, 1, 1)
					--log
					script.renderer:glow_module(x/2 - (strw/2) - 5, y - offsetY - Offset * fraction - 20,strw + 10,15, 10,2,{watermarkClr.r, watermarkClr.g, watermarkClr.b,50}, {30,30,30,120})
					renderer.text(x/2, y - offsetY - Offset * fraction - 12, 255, 255, 255, 255 * fraction, "c", 0, string)
					renderer.blur(x/2 - (strw/2), y - offsetY - Offset * fraction - 20, strw, 20, 1, 1)
				end
			end
			
	
			for i = #to_remove, 1, -1 do
				table.remove(data, to_remove[i])
			end
		end,
	
		clear = function()
			data = {}
		end
	}
	
	
	
	local function onHit(e)
		local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
		local r, g, b, a = ctx.ui.menu.Visuals.screenlogs:get_color()
		notifications.new(string.format("Hit %s's $%s$ for $%d$ damage", entity.get_player_name(e.target), group:lower(), e.damage), r, g, b) 
		--	notifications.new(string.format("Hit %s's $%s$ for $%d$ damage ($%d$ health remaining)", entity.get_player_name(e.target), group:lower(), e.damage, entity.get_prop(e.target, 'm_iHealth')), r, g, b) 
	end

	client.set_event_callback("aim_hit", onHit)
	
	local function onMiss(e)
		local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
		e.reason = e.reason == "?" and "resolver" or e.reason
		notifications.new(string.format("Missed %s's $%s$ due to $%s$", entity.get_player_name(e.target), group:lower(), e.reason), 255, 120, 120)
		--	notifications.new(string.format("Hit %s's $%s$ for $%d$ damage ($%d$ health remaining)", entity.get_player_name(e.target), group:lower(), e.damage, entity.get_prop(e.target, 'm_iHealth')), r, g, b) 
	end

	client.set_event_callback("aim_miss", onMiss)

	local kill = {

		"get good get paradox.pub",
		"why so bad get good get paradox dog",
		"why you miss paradox?",
		"again missed paradox?",
		"killed by paradox so shit",
		"LOL ONE BY PARADOX HAHAHAH",
		"KILLED BY PARADOX AHHAAHAHAHHA",
		"WHY YOU ARE MISSING PARADOX.PUB HELLOOO?",
		"MAYBE GET THIS ANTI AIM https://paradoxstoregs.mysellix.io/shop",
		"FIX  UR ANTI AIM OR JUST USE PARADOX https://paradoxstoregs.mysellix.io/shop",
		"https://discord.gg/mAYKG7JzYv join here for better anti aim maybe?",
		"keep missing paradox.pub",
	
	}

	local Spanish = {
        "Estamos haciendo fotos en una fiesta, mis zapatos estÃ¡n relucientes",
        "Nikes frescas directamente de la tienda, Vans todas destrozadas",
        "Todas las zorras de aquÃ­ brillan",
        "He tenido un schtick desde la fase, algunas voces en mi cabeza estÃ¡n chirriando",
        "Tengo pan perra estÃºpida",
        "Dinero, dinero, estoy jodido",
        "En una mochila guadaÃ±a te veo por la noche",
        "Te darÃ© una patada en la polla y te tirarÃ© contra la pared",
        "TÃº conduces un Audi mi mamÃ¡ conduce un Fiat",
        "Mira perra, soy grande, tu compaÃ±ero de equipo un poco blando",
        "A la mierda sus opiniones, oh mi",
        "He cambiado mil cigarrillos por una barra de duende",
        "Mis pantalones siguen bajos porque tengo un tema, a la mierda la po-po",
        "Dices que eres un mal tipo...",
        "OÃ­ que vendÃ­as invitaciones, sigue con las inyecciones",
        "Tiro fallido debido a mi mortalidad",
        "JÃ³dete gilipollas hasta que te salgan los caramelos por el culo",
        "Â¿El cura sabe que andas desenterrado?",
        "Te animo sinceramente a que abortes tengas la edad que tengas...",
        "Cuando te follo por el pecho, tus brazos aplauden",
        "Cuando me saco la polla, todas las embarazadas sacan el feto",
        "PequeÃ±o maricÃ³n",
        "Que Dios te dÃ© brazos cortos para que te pique el culo",
        "Te follarÃ­a, pero mi polla es mÃ­a",
        "Â¿Ves un cargamento de turcos viniendo hacia mÃ­?",
        "Â¿CuÃ¡ntas pollas te han roto en la noche?",
        "mÃ¡tame, mi teclado se desconectÃ³",
        "Mi ratÃ³n se fue detrÃ¡s de mi escritorio, adelante, mÃ¡tame",
        "me iba a caer en tu estÃºpido coÃ±o",
        "MÃ©tete esas bolas pesadas en el coÃ±o",
        "Voy a meter mi pene en la cripta en la que te tengo",
        "PregÃºntame si aÃºn me duele la rodilla despuÃ©s de una noche con tu madre",
        "Si te pongo el pene en el hombro, dirÃ¡s que llevabas troncos a casa",
        "Oho, estaba configurando un negev",
        "No quieres la polla en la boca y sigues cogiÃ©ndola",
        "EstÃ¡s cagando piedras de ferrocarril",
        "Sabes que soy un negev, te hago pedazos y luego desaparezco",
        "Te meto la polla en la boca para aÃ±adir peso",
        "SerÃ¡ mejor que me veas escupir en tu sopa",
        "Me harÃ¡s una mamada hasta que te golpee los hombros con los talones",
        "Â¡Me la vas a chupar si me vuelves a matar!",
        "Â¡Ohooooo, me has matado! ChÃºpame el pajarito hasta que me corra!",
        "Tu madre tampoco te soporta, esclavo...",
        "no te preocupes por tu boca muerta",
        "tienes una media de esclava",
	}

	local Romanian = {
        "Nikes proaspeÈ›i, direct de la magazin, Vans toate rupte",
        "Toate tÃ¢rfele de aici de la sclipici strÄƒlucesc",
        "Am un schtick Ã®ncÄƒ din faza, niÈ™te voci din capul meu scÃ¢rÈ›Ã¢ie",
        "Am luat pÃ¢ine, tÃ¢rfÄƒ proastÄƒ",
        "Bani, bani, sunt terminat.",
        "ÃŽntr-un rucsac cu coasÄƒ te vÄƒd noaptea",
        "ÃŽÈ›i dau un È™ut Ã®n puÈ›Äƒ È™i te arunc la perete",
        "Tu conduci un Audi, mama mea conduce un Fiat",
        "Uite cÄƒÈ›ea, eu sunt mare, coechipierul tÄƒu e un pic mai moale",
        "DÄƒ-le dracului de pÄƒreri, o, Doamne",
        "Am schimbat o mie de È›igÄƒri pe un baton de elf",
        "Pantalonii mei sunt Ã®ncÄƒ jos pentru cÄƒ am o temÄƒ, la naiba cu poliÈ›ia",
        "Spui cÄƒ eÈ™ti un tip rÄƒu...",
        "Am auzit cÄƒ vinzi invitaÈ›ii, rÄƒmÃ¢i la injecÈ›ii",
        "Am ratat lovitura din cauza mortalitÄƒÈ›ii mele",
        "Du-te dracului pÃ¢nÄƒ Ã®È›i ies caramele pe fund",
        "Preotul È™tie cÄƒ te plimbi dezgropat?",
        "Te Ã®ncurajez sincer sÄƒ faci avort, indiferent de vÃ¢rsta pe care o ai...",
        "CÃ¢nd È›i-o trag Ã®n piept, braÈ›ele tale aplaudÄƒ",
        "CÃ¢nd Ã®mi scot pula, toate femeile Ã®nsÄƒrcinate scot fÄƒtul",
        "Poponarule",
        "SÄƒ-È›i dea Dumnezeu braÈ›e scurte ca sÄƒ te mÄƒnÃ¢nce curul",
        "Èši-aÈ™ trage-o, dar pula mea e a mea",
        "Vezi un transport de turci venind spre mine?",
        "CÃ¢te scule ai spart Ã®n noaptea asta?",
        "OmoarÄƒ-mÄƒ, mi s-a deconectat tastatura",
        "Mouse-ul meu s-a dus Ã®n spatele biroului, ucide-mÄƒ",
        "Am vrut sÄƒ cad Ã®n pÄƒsÄƒrica ta stupidÄƒ",
        "BagÄƒ-È›i boaÈ™ele alea grele Ã®n pÄƒsÄƒrica ta",
        "O sÄƒ-mi pun penisul Ã®n cripta Ã®n care te È›in",
        "ÃŽntreabÄƒ-mÄƒ dacÄƒ mÄƒ mai doare genunchiul dupÄƒ o noapte cu maicÄƒ-ta",
        "DacÄƒ Ã®mi pun penisul pe umÄƒrul tÄƒu, o sÄƒ spui cÄƒ ai cÄƒrat buÈ™teni acasÄƒ",
        "Oho, configuram un negev",
        "Nu vrei sÄƒ-È›i bagi pula Ã®n gurÄƒ È™i continui sÄƒ È›i-o iei",
        "Te caci pe pietre de cale feratÄƒ",
        "È˜tii cÄƒ sunt un negev, te rup Ã®n bucÄƒÈ›i È™i apoi dispar",
        "Mi-am pus scula Ã®n gura ta ca sÄƒ te Ã®ngraÈ™",
        "Mai bine te-ai uita cum Ã®È›i scuip Ã®n supÄƒ",
        "O sÄƒ-mi faci sex oral pÃ¢nÄƒ cÃ¢nd o sÄƒ-È›i lovesc umerii cu tocurile",
        "O sÄƒ-mi faci o muie dacÄƒ mÄƒ omori din nou!",
        "Ohooooo, m-ai omorÃ¢t! Suge-mi pasÄƒrea pÃ¢nÄƒ Ã®mi vine!",
        "Nici mama ta nu te suportÄƒ, sclavule...",
        "nu-È›i face griji pentru gura ta moartÄƒ",
        "ai o medie de sclav",
	}

	local germany_hs = {
        "hsnndog",
        "hsnndog",
	}

	local germany_baim = {
        "baimnndog",
        "baimnndog",
	}

	

	local trashtalk = function(e)

		local victim_userid, attacker_userid = e.userid, e.attacker
		if victim_userid == nil or attacker_userid == nil then
			return
		end
	
		
		local victim_entindex   = client.userid_to_entindex(victim_userid)
		local attacker_entindex = client.userid_to_entindex(attacker_userid)
		local trashmode = ctx.ui.menu.Misc.trashtalkmode:get()				
		if ctx.ui.menu.Misc.trashtalk:get() then
			if attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) and trashmode == "Paradox" then
				local phrase = kill[math.random(1, #kill)]
				local say = 'say ' .. phrase
				client.exec(say)
			elseif attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) and trashmode == "Spanish" then
				local phrase = Spanish[math.random(1, #Spanish)]
				local say = 'say ' .. phrase
				client.exec(say)

			elseif attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) and trashmode == "Romanian" then
				local phrase = Romanian[math.random(1, #Romanian)]
				local say = 'say ' .. phrase
				client.exec(say)
			-- elseif attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) and trashmode == "Germany" then
			-- 	if e.headshot then
			-- 		local phrase = germany_hs[math.random(1, #germany_hs)]
			-- 		local say = 'say ' .. phrase
			-- 		client.exec(say)
			-- 	else
			-- 		local phrase = germany_baim[math.random(1, #germany_baim)]
			-- 		local say = 'say ' .. phrase
			-- 		client.exec(say)
			-- 	end
			end
		end
	end

	client.set_event_callback("player_death", trashtalk)


	
-- 	local clantag_anim = function(text, indices)
-- 		local text_anim = "               " .. text ..                       "" 
-- 		local tickinterval = globals.tickinterval()
-- 		local tickcount = globals.tickcount() + func.time_to_ticks(client.latency())
-- 		local i = tickcount / func.time_to_ticks(0.3)
-- 		i = math.floor(i % #indices)
-- 		i = indices[i+1]+1
-- 		return string.sub(text_anim, i, i+15)
-- 	end


-- 	local clantag = {
-- 		steam = steamworks.ISteamFriends,
-- 		prev_ct = "",
-- 		orig_ct = "",
-- 		enb = false,
-- 	}
	
-- 	local function get_original_clantag()
-- 		local clan_id = cvar.cl_clanid.get_int()
-- 		if clan_id == 0 then return "\0" end
	
-- 		local clan_count = clantag.steam.GetClanCount()
-- 		for i = 0, clan_count do 
-- 			local group_id = clantag.steam.GetClanByIndex(i)
-- 			if group_id == clan_id then
-- 				return clantag.steam.GetClanTag(group_id)
-- 			end
-- 		end
-- 	end
	

-- 	local function clantag_set()
--     local lua_name = "paradox"
--     if ctx.ui.menu.Misc.clantag:get() then
--         if ui.get(ui.reference("Misc", "Miscellaneous", "Clan tag spammer")) then return end

-- 		local clan_tag = clantag_anim(lua_name, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25})

--         if entity.get_prop(entity.get_game_rules(), "m_gamePhase") == 5 then
--             clan_tag = clantag_anim('paradox', {13})
--             client.set_clan_tag(clan_tag)
--         elseif entity.get_prop(entity.get_game_rules(), "m_timeUntilNextPhaseStarts") ~= 0 then
--             clan_tag = clantag_anim('paradox', {13})
--             client.set_clan_tag(clan_tag)
--         elseif clan_tag ~= clantag.prev_ct  then
--             client.set_clan_tag(clan_tag)
--         end

--         clantag.prev_ct = clan_tag
--         clantag.enb = true
--     elseif clantag.enb == true then
--         client.set_clan_tag(get_original_clantag())
--         clantag.enb = false
--     end
-- end

-- clantag.paint = function()
--     if entity.get_local_player() ~= nil then
--         if globals.tickcount() % 2 == 0 then
--             clantag_set()
--         end
--     end
-- end

-- clantag.run_command = function(e)
--     if entity.get_local_player() ~= nil then 
--         if e.chokedcommands == 0 then
--             clantag_set()
--         end
--     end
-- end

-- clantag.player_connect_full = function(e)
--     if client.userid_to_entindex(e.userid) == entity.get_local_player() then 
--         clantag.orig_ct = get_original_clantag()
--     end
-- end

-- clantag.shutdown = function()
--     client.set_clan_tag(get_original_clantag())
-- end

-- client.set_event_callback("paint", clantag.paint)
-- client.set_event_callback("run_command", clantag.run_command)
-- client.set_event_callback("player_connect_full", clantag.player_connect_full)
-- client.set_event_callback("shutdown", clantag.shutdown)
	
	

for _, eid in ipairs({
	{
		"load", function()
			ctx.ui:execute()
			ctx.config:setup()
		end
	},
	{
		"setup_command", function(cmd)
			if valuwes.paketa_pitch >= 89 then
				valuwes.paketa_pitch = -89
			else
				valuwes.paketa_pitch = valuwes.paketa_pitch + 1
			end
			--cmd.force_defensive = 1
			ctx.Antiaim:run(cmd)
			ctx.peekbot:run(cmd)
			ctx.Antiaim:fast_ladder(cmd)


		end
	},
	{
		"shutdown", function()
			ctx.ui:shutdown()
		end
	},
	{
		"run_command", function()
			ctx.helpers:in_ladder()
		end
	},
	{
		"paint", function()
			ctx.visuals:render()
			notifications.render()
			local me = entity.get_local_player()

			if ctx.ui.menu.Misc.aipeek:get() and ctx.peekbot.active then
				ctx.visuals.enabled_fraction = ctx.visuals.helpers:clamp(ctx.visuals.enabled_fraction + globals.frametime()*10, 0, 1)
			else
				ctx.visuals.enabled_fraction = ctx.visuals.helpers:clamp(ctx.visuals.enabled_fraction - globals.frametime()*10, 0, 1)
				return
			end

			ctx.visuals.origin = ctx.visuals.origin:lerp(ctx.peekbot.origin, globals.frametime()*20)
			ctx.visuals.point = ctx.visuals.point:lerp(ctx.peekbot.last_point,  globals.frametime()*20)
			ctx.visuals.hitbox = ctx.visuals.hitbox:lerp(ctx.peekbot.last_hitbox,  globals.frametime()*20)

			local point = vector(renderer.world_to_screen(ctx.visuals.point.x, ctx.visuals.point.y, ctx.visuals.point.z))
			local origin = vector(renderer.world_to_screen(ctx.visuals.origin.x, ctx.visuals.origin.y, ctx.peekbot.origin.z))

			if point.x and point.y and origin.x and origin.y then
				renderer.line(point.x, point.y, origin.x, origin.y, 255, 255, 255, 200 * ctx.visuals.enabled_fraction)
			end

			local mins = vector(entity.get_prop(me, "m_vecMins"))
			local maxs = vector(entity.get_prop(me, "m_vecMaxs"))

		--	draw_box(ctx.visuals.point, mins, maxs, 255, 255, 255, 150 * ctx.visuals.enabled_fraction)

			local view_offset = entity.get_prop(me, 'm_vecViewOffset[2]')
			local eye = ctx.visuals.point + vector(0,0,view_offset) --vector((mins.x + maxs.x)/2, (mins.y + maxs.y)/2, mins.z + view_offset)
			
			local hitbox_ws = vector(renderer.world_to_screen(ctx.visuals.hitbox.x, ctx.visuals.hitbox.y, ctx.visuals.hitbox.z))
			local eye_ws = vector(renderer.world_to_screen(eye.x, eye.y, eye.z))
			if eye_ws.x and eye_ws.y and hitbox_ws.x and hitbox_ws.y then
				renderer.line(hitbox_ws.x, hitbox_ws.y, eye_ws.x, eye_ws.y, 255, 255, 255, 255 * ctx.visuals.enabled_fraction)
			end
		end
	},
	{
		"paint_ui", function()
			ctx.helpers:menu_visibility(false)
		end
	},
	{
		"pre_render", function()
			ctx.Antiaim:animations()
		end
	},
	{
		"predict_command", function()
			ctx.defensive:predict()
		end
	},
	{
		"level_init", function()
			ctx.defensive:reset()
			ctx.Antiaim.peeked = 0
			ctx.globals.in_ladder = 0
		end
	},
	{
		"net_update_start", function()
			ctx.resolver:jitterhelper()
		end
	},
	{
		"net_update_end", function()
			ctx.defensive:defensivestatus()
			ctx.defensive:defensive_active()
		end
	},
}) do
	if eid[1] == "load" then
		eid[2]()
	else
		client.set_event_callback(eid[1], eid[2])
	end
end
--client.register_esp_flag("", 255, 246, 210, function(arg) return resolver_status, resolver_flag[arg] end)


local lerp = function(a, b, t)
    return a + (b - a) * t
end

local y = 0
local sizing = 0
local alpha = 255
local renderguwno = "yes"
client.set_event_callback('paint_ui', function()
    local screen = vector(client.screen_size())
    local size = vector(screen.x, screen.y)

	if renderguwno == "yes" then
		sizing = lerp(sizing, 6, globals.frametime() * 2)
		local rotation = lerp(0, 360, globals.realtime() % 1)
		alpha = lerp(alpha, 0, globals.frametime() * 0.33)
		y = lerp(y, 70, globals.frametime() * 2)

		renderer.rectangle(0, 0, size.x, size.y, 20, 20, 20, alpha)
		if logo ~= nil then
			logo:draw(screen.x/2 - (12 * sizing), screen.y/2 - (15 * sizing), 25 * sizing, 25 * sizing, 255, 255, 255, alpha)
		else
			downloadFileLogo()
		end

		renderer.text(screen.x/2, screen.y/2 + 40, 184, 184, 184, alpha, 'c', 0, '       Loading Paradox\nWelcome - '..login.username..'['..login.build..']')
		renderer.text(screen.x/2, screen.y - y, 184, 184, 184, alpha, 'c', 0, 'https://paradoxstoregs.mysellix.io/')

		if alpha < 30 then
			renderguwno = "no"
		end
	end
end)