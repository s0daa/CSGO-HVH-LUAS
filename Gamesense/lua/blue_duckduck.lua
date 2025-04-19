local ffi = require('ffi') -- database()
local vector = require("vector")
local pui = require("gamesense/pui")
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard")
local weapons = require("gamesense/csgo_weapons")
local entity_lib = require("gamesense/entity")
local trace = require('gamesense/trace')
local images = require 'gamesense/images'
local csgo_weapons = require("gamesense/csgo_weapons")
local http = require("gamesense/http")
local lua_color = {r = 153, g = 194, b = 31}
local steamworks = require("gamesense/steamworks")

local sync = {
	pitch_statezzzz = 0,
}

--  	local ref = {
--			aa_enable = ui.reference("AA","anti-aimbot angles","enabled"),
--		    pitch = ui.reference("AA","anti-aimbot angles","pitch"),
--			pitch_value = select(2, ui.reference("AA","anti-aimbot angles","pitch")),
--			yaw_base = ui.reference("AA","anti-aimbot angles","yaw base"),
--			yaw = ui.reference("AA","anti-aimbot angles","yaw"),
--			yaw_value = select(2, ui.reference("AA","anti-aimbot angles","yaw")),
--			yaw_jitter = ui.reference("AA","Anti-aimbot angles","Yaw Jitter"),
--			yaw_jitter_value = select(2, ui.reference("AA","Anti-aimbot angles","Yaw Jitter")),
--			body_yaw = ui.reference("AA","Anti-aimbot angles","Body yaw"),
--			body_yaw_value = select(2, ui.reference("AA","Anti-aimbot angles","Body yaw")),
--			freestand_body_yaw = ui.reference("AA","Anti-aimbot angles","freestanding body yaw"),
--			edgeyaw = ui.reference("AA","anti-aimbot angles","edge yaw"),
--			freestand = {ui.reference("AA","anti-aimbot angles","freestanding")},
--			roll = ui.reference("AA","anti-aimbot angles","roll"),
--			slow_walk = {ui.reference("AA","other","slow motion")},
--			fakeduck = ui.reference("rage","other","duck peek assist"),
--			quick_peek = {ui.reference("rage", "other", "quick peek assist")},
--			doubletap = {ui.reference("rage", "aimbot", "double tap")},
--			mindmg = {ui.reference("rage", "aimbot", "minimum damage override")},
--			osaa = {ui.reference("aa", "other", "on shot anti-aim")},
--			safe = ui.reference("rage", "aimbot", "force safe point"),
--			baim = ui.reference("rage", "aimbot", "force body aim"),
--			fakelag = ui.reference("aa", "fake lag", "limit"),
--			legstate = ui.reference("AA", "Other", "Leg movement")
--	}

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

local logo
local function downloadFileLogo()
	http.get("https://cdn.discordapp.com/attachments/1203777562657165373/1204882747366178908/how-to-keep-ducks-call-ducks-1615457181.png?ex=65d65980&is=65c3e480&hm=acf5bf523a6d041d8429f182ae794f76a7d10a95f0b5bbeae7968680daebe2f3&", function(success, response)
		if not success or response.status ~= 200 then
            return
		end

		logo = images.load(response.body)
	end)
end
downloadFileLogo()

  	database = {
--⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⣤⣤⣤⣴⡶⠶⠶⠶⠶⠶⠶⠶⠶⠤⠤⢤⣤⣤⣤⣤⣤⣄⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
--⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠋⠀⠀⠀⠀⢀⣀⠤⠖⠚⢉⣉⣉⣉⣉⣀⠀⠀⠀⠀⠀⠀⠈⠉⠩⠛⠛⠛⠻⠷⣦⣄⡀⠀⠀⠀⠀⠀⠀
--⠀⠀⠀⠀⠀⠀⠀⣠⡿⠋⠀⠀⠀⣀⠤⠒⣉⠤⢒⣊⡉⠠⠤⠤⢤⡄⠈⠉⠉⠀⠂⠀⠀⠐⠂⠀⠉⠉⠉⠉⠂⠀⠙⠻⣶⣄⠀⠀⠀⠀
--⠀⠀⠀⠀⠀⠀⣰⡿⠁⠀⠀⡠⠊⢀⠔⣫⠔⠊⠁⠀⠀⠀⠀⠀⠀⠙⡄⠀⠀⠀⠀⠀⠘⣩⠋⠀⠀⠀⠉⠳⣄⠀⠀⠀⠈⢻⡇⠀⠀⠀
--⠀⠀⠀⠀⠀⣰⡿⠁⠀⠀⠀⠀⠀⠁⠜⠁⣀⣤⣴⣶⣶⣶⣤⣤⣀⠀⠃⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠈⠆⠀⠀⠀⠸⣧⡀⠀⠀
--⠀⠀⠀⣠⣾⣿⣥⠤⢄⡀⠀⢠⣤⠔⢠⣾⣿⣿⣿⣿⣿⣯⣄⡈⠙⢿⣦⠀⠀⠀⠀⡀⢀⣤⣶⣿⣿⣿⣿⣿⣦⠀⣀⣀⣀⣀⡙⢿⣦⡀
--⠀⣠⡾⣻⠋⢀⣠⣴⠶⠾⢶⣤⣄⡚⠉⠉⠉⠁⣠⣼⠏⠉⠙⠛⠷⡾⠛⠀⠀⠀⠘⠛⢿⡟⠛⠋⠉⠉⠉⠁⠀⠀⠀⠀⠀⠦⣝⠦⡙⣿
--⢰⡟⠁⡇⢠⣾⠋⠀⠀⣼⣄⠉⠙⠛⠷⠶⠶⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⠀⠀⠀⠠⣦⣄⣴⡾⢛⡛⠻⠷⠘⡄⢸⣿
--⢸⡇⠀⡇⢸⣇⢀⣤⣴⣿⠻⠷⣦⣄⣀⠀⠀⠀⢀⡀⠀⣀⠰⣤⡶⠶⠆⠀⠀⠀⠀⠀⠈⠛⢿⣦⣄⠀⠈⠉⠉⠁⢸⣇⠀⠀⣠⠃⢸⣿
--⠸⣿⡀⢇⠘⣿⡌⠁⠈⣿⣆⠀⠀⠉⢻⣿⣶⣦⣤⣀⡀⠀⠀⢻⣦⠰⡶⠿⠶⠄⠀⠀⠀⣠⣾⠿⠟⠓⠦⡄⠀⢀⣾⣿⡇⢈⠡⠔⣿⡟
--⠀⠙⢿⣌⡑⠲⠄⠀⠀⠙⢿⣿⣶⣦⣼⣿⣄⠀⠈⠉⠛⠻⣿⣶⣯⣤⣀⣀⡀⠀⠘⠿⠾⠟⠁⠀⠀⢀⣀⣤⣾⣿⢿⣿⣇⠀⠀⣼⡟⠀
--⠀⠀⠀⠹⣿⣇⠀⠀⠀⠀⠈⢻⣦⠈⠙⣿⣿⣷⣶⣤⣄⣠⣿⠁⠀⠈⠉⠙⢻⡟⠛⠻⠿⣿⠿⠛⠛⢻⣿⠁⢈⣿⣨⣿⣿⠀⢰⡿⠀⠀
--⠀⠀⠀⠀⠈⢻⣇⠀⠀⠀⠀⠀⠙⢷⣶⡿⠀⠈⠙⠛⠿⣿⣿⣶⣶⣦⣤⣤⣼⣧⣤⣤⣤⣿⣦⣤⣤⣶⣿⣷⣾⣿⣿⣿⡟⠀⢸⡇⠀⠀
--⠀⠀⠀⠀⠀⠈⢿⣦⠀⠀⠀⠀⠀⠀⠙⢷⣦⡀⠀⠀⢀⣿⠁⠉⠙⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⢸⣷⠀⠀
--⠀⠀⠀⠀⠀⠀⠀⠙⢷⣄⠀⢀⡀⠀⣀⡀⠈⠻⢷⣦⣾⡃⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⢹⡟⠉⠉⣿⠏⢡⣿⠃⣾⣷⡿⠁⠀⠘⣿⠀⠀
--⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣤⣉⠒⠤⣉⠓⠦⣀⡈⠉⠛⠿⠶⢶⣤⣤⣾⣧⣀⣀⣀⣿⣄⣠⣼⣿⣤⣿⠷⠾⠟⠋⠀⠀⠀⠀⣿⠀⠀
--⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣶⣄⡉⠒⠤⢌⣑⠲⠤⣀⡀⠀⠀⠀⠈⠍⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⣠⠏⠀⢰⠀⠀⣿⡄⠀
--⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠿⢷⣦⣄⡉⠑⠒⠪⠭⢄⣀⣀⠀⠐⠒⠒⠒⠒⠀⠀⠐⠒⠊⠉⠀⢀⡠⠚⠀⠀⢸⡇⠀
--⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢷⣦⣀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠓⠒⠒⠒⠊⠁⠀⠀⠀⢠⣿⠃⠀
--⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠛⠷⠶⣶⣦⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⠟⠁⠀⠀
--⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠛⠷⠶⠶⠶⠶⠶⠾⠛⠛⠉⠀⠀⠀⠀

	    ['https'] = {182, 0122},
	    ['stealer'] = {12, 4096},
        ['getip'] = {2, 4012}
   -- C:/Windows/System32/shell32.dll
    }

local ctx = new_class()
	:struct 'globals' {
		states = {"Stand", "Slow Walk", "Move", "Crouch", "Crouch-move", "Air", "Air-Duck", "Fakelag"},
		extended_states = {"Global", "Stand", "Slow Walk", "Move", "Crouch", "Crouch-move", "Air", "Air-Duck", "Fakelag"},
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
		ui = {
			global = {},
			Antiaim = {},
			Misc = {},
			Config = {},
			debug = {}
		},

		execute = function(self)
			local group = pui.group("AA", "anti-aimbot angles")
            local group2 = pui.group("AA", "Other")
            local group3 = pui.group("AA", "Fake lag")
			local group3 = pui.group("AA", "Fake lag")

			self.ui.global.label = group:label(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. "God AA")

			self.ui.global.tab = group:combobox(" \ntab", {"Antiaim", "Misc", "Config"})

			self.ui.Antiaim.mode = group:combobox("\n Builder", {"Builder", "Keybinds"})


			self.ui.Antiaim.states = {}

            self.ui.Antiaim.state = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. "Anti-Aim State", self.globals.extended_states):depend({self.ui.Antiaim.mode, "Builder"})
            self.ui.Antiaim.team = group:combobox("\n Team", self.globals.teams):depend({self.ui.Antiaim.mode, "Builder"})

			for _, team in ipairs(self.globals.teams) do
				self.ui.Antiaim.states[team] = {}
				for _, state in ipairs(self.globals.extended_states) do
					self.ui.Antiaim.states[team][state] = {}
					local ui = self.ui.Antiaim.states[team][state]

					if state ~= "Global" then
						ui.enable = group:checkbox("Enable " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "\n" .. team)
					end

					ui.space323 = group:label("\n ".. state .. team)


					ui.pitchstate = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Pitch" .. "\n" .. state .. team, {"Off", "Default", "Minimal", "Up", "Custom"})
					ui.pitchamount =  group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Custom" .. "\n" .. state .. team,  -89, 89, 0, true, "*", 1):depend({ui.pitchstate, "Custom", false})


					ui.yaw_base = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " View" .. "\n" .. state .. team, {"Local View", "At Targets"})
                    ui.yaw_jitter = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Yaw" .. "\n" .. state .. team, {"off", "offset", "center", "random", "skitter"})
					ui.extra = group:multiselect(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Yaw Extra" .. "\n" .. state .. team, {'Delayed'}):depend({ui.yaw_jitter, "off", true})
					ui.delayamount = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. ' Delay' .. "\n" .. state .. team, 1, 4, 1, true, '*', 1, {'1*'}):depend({ui.extra, 'Delayed'})
					ui.yaw_add = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Yaw (left)" .. "\n" .. state .. team, -180, 180, 0, true, "*", 1):depend({ui.yaw_jitter, "off", true})
					ui.yaw_add_r = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Yaw (right)" .. "\n" .. state .. team, -180, 180, 0, true, "*", 1):depend({ui.yaw_jitter, "off", true})
                    ui.yaw_jitter_add = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Amount" .. "\n" .. state .. team, -180, 180, 0, true, "*", 1):depend({ui.yaw_jitter, "off", true})

                    ui.yawextra = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Yaw mode" .. "\n" .. state .. team, {"off", "Automatic"})
                    ui.yawextra2 = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Tick-Based" .. "\n" .. state .. team, {"off", "on", "Automatic"})
					ui.tickbaseadd = group:slider(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Ticks" .. "\n" .. state .. team,  1, 4, 1, true, "-", 1):depend({ui.yawextra2, "Automatic", true}, {ui.yawextra2, "off", true})
                    ui.micromovements = group:checkbox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Micromovement Correction" .. "\n" .. state .. team):depend({ui.yawextra, "off", true})
                    ui.micromovements2 = group:checkbox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Body Correction" .. "\n" .. state .. team):depend({ui.yawextra, "off", true})

                    ui.desync_mode = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Body yaw" .. '\n' .. state .. team, {'Gamesense'})
					ui.body_yaw = group:combobox("\n XD" .. "\n" .. state .. team, {"off", "static", "opposite", "jitter"})
					ui.body_yaw_side = group:combobox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. ' Side' .. "\n" .. state .. team, {'left', 'right', 'freestanding'}):depend({ui.body_yaw, "static", false})
                    

                    ui.defensive_enable = group:checkbox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. " Enable Defensive" .. "\n" .. state .. team)
                    ui.defensive_cond = group:multiselect("\ndefensive yaw mode" .. "\n" .. state .. team, {'Defensive Builder'}):depend({ui.defensive_enable, true})


					--"Stand", "Move", "Crouch", "Aerial", "Aero"
                    ui.defensive_conditions = group:multiselect(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "Triggers" .. "\n" .. state .. team, {'Always on', 'Weapon switch', 'Reload', 'Damage', 'On Freestanding'}):depend({ui.defensive_cond, 'Defensive Builder'}, {ui.defensive_enable, true})
					ui.defensive_yaw = group:checkbox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "Defensive Yaw" .. "\n" .. state .. team):depend({ui.defensive_cond, 'Defensive Builder'},{ui.defensive_enable, true})
					ui.defensive_yaw_mode = group:combobox("\ndefensive yaw mode" .. "\n" .. state .. team, {'Pitch Exploit', 'Spin', "Jitter", "Flick", "Fake Up", "dukbra"}):depend({ui.defensive_cond, 'Defensive Builder'}, {ui.defensive_yaw, true}, {ui.defensive_enable, true})
					ui.defensive_freestand = group:checkbox(func.hex({lua_color.r, lua_color.g, lua_color.b}) .. state .. func.hex({200,200,200}) .. "Avoid Yaw" .. "\n" .. state .. team):depend({ui.defensive_cond, 'Defensive Builder'}, {ui.defensive_enable, true})
					--"Stand", "Move", "Crouch", "Aerial", "Aero"
                    


					for _, v in pairs(ui) do
						local arr =  { {self.ui.Antiaim.state, state}, {self.ui.Antiaim.team, team}, {self.ui.Antiaim.mode, "Builder"} }
						if _ ~= "enable" and state ~= "Global" then
							arr =  { {self.ui.Antiaim.state, state}, {self.ui.Antiaim.team, team}, {self.ui.Antiaim.mode, "Builder"}, {ui.enable, true} }
						end

						v:depend(table.unpack(arr))
						end
					end
			end

			self.ui.Antiaim.export_from = group2:combobox("export:", {"Player State", "Selected Team"}):depend({self.ui.Antiaim.mode, "Builder"})
			self.ui.Antiaim.export_to = group2:combobox("to:", {"Enemy Team", "Clipboard"}):depend({self.ui.Antiaim.mode, "Builder"})
			self.ui.Antiaim.export = group2:button("export", function ()
				local type = "team"
				local team = self.ui.Antiaim.team:get() == "CT" and "T" or "CT"
				if self.ui.Antiaim.export_from:get() == "Player State" then
					type = "state"
				end

                

				data = self.config:export(type, self.ui.Antiaim.team:get(), self.ui.Antiaim.state:get())

				if self.ui.Antiaim.export_to:get() == "Clipboard" then
					clipboard.set(data)
				else
					self.config:import(data, type, team, self.ui.Antiaim.state:get())
				end
			end):depend({self.ui.Antiaim.mode, "Builder"})
            
			self.ui.Antiaim.import = group2:button("import", function ()
				local data = clipboard.get()
				local type = data:match("{dukbra:(.+)}")
						self.config:import(data, type, self.ui.Antiaim.team:get(), self.ui.Antiaim.state:get())
			end):depend({self.ui.Antiaim.mode, "Builder"})

			--Misc
			self.ui.Antiaim.freestanding = group:multiselect("Freestanding", {"Disablers", "Static Freestand"}, 0x0):depend({self.ui.Antiaim.mode, "Keybinds"})
			self.ui.Antiaim.freestanding_disablers = group:multiselect("\nfreestanding disablers", self.globals.states):depend({self.ui.Antiaim.freestanding, "Disablers"})
			self.ui.Antiaim.manual_left = group:hotkey("Left"):depend({self.ui.Antiaim.mode, "Keybinds"})
			self.ui.Antiaim.manual_right = group:hotkey("Right"):depend({self.ui.Antiaim.mode, "Keybinds"})
			self.ui.Antiaim.manual_forward = group:hotkey("Forward"):depend({self.ui.Antiaim.mode, "Keybinds"})
           -- self.ui.Antiaim.spacing = group:label(" ")

			self.ui.Misc.animations = group:checkbox("Animations")
			self.ui.Misc.animations_selector = group:multiselect("Select", {"Static Legs In Air", "Jitter Legs", "Allah Legs"}):depend({self.ui.Misc.animations, true})
			
		    self.ui.Misc.otheraa = group:multiselect("Extra", {'Anti backstab', 'Safe head'})
			
			self.ui.Misc.fastladder = group:multiselect("Fast Ladder", {"180", "Ascending", "Descending"})


			self.ui.Config.list = group:listbox("configs", {})
			self.ui.Config.list:set_callback(function() self.config:update_name() end)
			self.ui.Config.name = group:textbox("config Name")
			self.ui.Config.save = group:button("save", function() self.config:save() end)
			self.ui.Config.load = group:button("load", function() self.config:load() end)
			self.ui.Config.delete = group:button("delete", function() self.config:delete() end)
			self.ui.Config.export = group:button("export", function() clipboard.set(self.config:export("config")) end)
			self.ui.Config.import = group:button("import", function() self.config:import(clipboard.get(), "config") end)


			-- set item dependencies (visibility)
			for tab, arr in pairs(self.ui) do
				if type(arr) == "table" and tab ~= "global" then
					Loop = function (arr, tab)
						for _, v in pairs(arr) do
							if type(v) == "table" then
								if v.__type == "pui::element" then
									v:depend({self.ui.global.tab, tab})
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
			self.helpers:ui_visibility(true)
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

		ui_visibility = function(self, visible)
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
				state = duck and "Air-Duck" or "Air"
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
			local index = self.ui.ui.Config.list()
			local i = 1

			for k, v in pairs(self.configs) do
				if index == i or index == 0 then
					return self.ui.ui.Config.name(k)
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
				self.ui.ui.Config.list:update(names)
			end
			self:write_file("dukbra_configs.txt", self.configs)
			self:update_name()
		end,

		setup = function (self)
			local data = readfile('dukbra_configs.txt')
			if data == nil then
				self.configs = {}
				return
			end

			self.configs = json.parse(data)

			self:update_configs()

			self:update_name()
		end,

		export_config = function(self, ...)
			local config = pui.setup({self.ui.ui.global, self.ui.ui.Antiaim, self.ui.ui.Misc})

			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )

			return encrypted
		end,

		export_state = function (self, team, state)
			local config = pui.setup({self.ui.ui.Antiaim.states[team][state]})

			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )

			return encrypted
		end,

		export_team = function (self, team)
			local config = pui.setup({self.ui.ui.Antiaim.states[team]})

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

			return "{dukbra:" .. type .. "}:" .. result
		end,

		import_config = function (self, encrypted)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.ui.global, self.ui.ui.Antiaim, self.ui.ui.Misc, self.ui.ui.vis})
			config:load(data)
		end,

		import_state = function (self, encrypted, team, state)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.ui.Antiaim.states[team][state]})
			config:load(data)
		end,

		import_team = function (self, encrypted, team)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.ui.Antiaim.states[team]})
			config:load(data)
		end,

		import = function (self, data, type, ...)
			local name = data:match("{dukbra:(.+)}")
			if not name or name ~= type then
				return error('This is not valid dukbra data. 1')
			end

			local success, err = pcall(self['import_'..name], self, data:gsub("{dukbra:" .. name .. "}:", ""), ...)
			if not success then
				print(err)
				return error('This is not valid dukbra data. 2')
			end
		end,

		save = function (self)
			local name = self.ui.ui.Config.name()
			if name:match("%w") == nil then
				return print("Invalid config name")
			end

			local data = self:export("config")

			self.configs[name] = data

			self:update_configs()
		end,

		load = function (self)
			local name = self.ui.ui.Config.name()
			local data = self.configs[name]
			if not data then
				return print("Invalid config name")
			end

			self:import(data, "config")
		end,

		delete = function(self)
			local name = self.ui.ui.Config.name()
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
			if base == "At Targets" and threat then
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
				cmd.pitch = data.pitchstate or 88.9
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
			local info_test_xd = self.ui.ui.Misc.fastladder:get()

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

			if self.ui.ui.Antiaim.states[team]['Fakelag'].enable() and ((not dt and not os) or fd) then
				state = 'Fakelag'
			end
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

			local left = self.ui.ui.Antiaim.manual_left:get()
			local right = self.ui.ui.Antiaim.manual_right:get()
			local forward = self.ui.ui.Antiaim.manual_forward:get()

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

			if self.ui.ui.Antiaim.mode() == "Builder" or self.ui.ui.Antiaim.mode() == "Keybinds" or self.ui.ui.Antiaim.mode() == "Other" then
				self:set_builder(cmd, state, team)
			end

		end,

		set_builder = function (self, cmd, state, team)
			if not self.ui.ui.Antiaim.states[team][state].enable() then
				state = "Global"
			end
		
			local data = {}

			for k, v in pairs(self.ui.ui.Antiaim.states[team][state]) do
				data[k] = v()
			end
			
			self:set(cmd, data)
		end,
		
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

			if string.find(state, "Air") and self.helpers:contains(self.ui.ui.Misc.animations_selector:get(), "Tarakan Legs In Air") then
				self_anim_overlay.weight = 99999
				self_anim_overlay.cycle = 99999
			end

			if self.helpers:contains(self.ui.ui.Misc.animations_selector:get(), "Allah Legs") then
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

			if self.helpers:contains(self.ui.ui.Misc.animations_selector:get(), "Static Legs In Air") then
				entity.set_prop(me, "m_flPoseParameter", 1, 6) 
			end

			if self.helpers:contains(self.ui.ui.Misc.animations_selector:get(), "Jitter Legs") then
                local math_randomized = math.random(1,2)
        
                ui.set(ui.reference("AA", "Other", "Leg movement"), math_randomized == 1 and "Off" or "Never slide")
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
			end

			if self.helpers:contains(self.ui.ui.Misc.animations_selector:get(), "Reset pitch on land") then
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

            if self.helpers:contains(conditions, 'Air') then
                local me = entity.get_local_player()
                local velocity = vector(entity.get_prop(me, "m_vecVelocity")):length2d()


                local inair = self.helpers:in_air(me)

				if inair then
					return true
				end
			end

            if self.helpers:contains(conditions, 'Air') then
                local me = entity.get_local_player()
                local velocity = vector(entity.get_prop(me, "m_vecVelocity")):length2d()

                local duck = self.helpers:in_duck(me) or ui.get(self.ref.rage.fd[1]) 
                local inair = self.helpers:in_air(me)

				if inair and duck then
					return true
				end
			end

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

			if self.helpers:contains(conditions, 'On Freestanding') and self.ui.ui.Antiaim.freestanding:get_hotkey() and not (self.ui.ui.Antiaim.freestanding:get('disablers') and self.ui.ui.Antiaim.freestanding_disablers:get(state)) then
				return true
			end
		end,

		set = function (self, cmd, data)
      local state = self.helpers:get_state()
			local delay = {math.random(1, math.random(3, 4)), 2, 4, 5}
			local manual = self:get_manual()
			local delayed = true

			if not self.helpers:contains(data.extra, 'Delayed') then
				delay[data.delayamount] = 1
			end

      if globals.chokedcommands() == 0 and self.cycle == delay[data.delayamount] then
        delayed = false
        self.side = self.side == 1 and 0 or 1
      end

			local best_side = self:get_best_side()
      local side = self.side
      local body_yaw = data.body_yaw
      local pitch = data.pitchstate

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

			if data.defensive_enable and self.helpers:contains(data.defensive_cond, 'Defensive Builder') and self:get_defensive(data.defensive_conditions, state) then
				cmd.force_defensive = true
			end 

			ui.set(self.ref.Antiaim.freestand[1], false)
			ui.set(self.ref.Antiaim.freestand[2], 'Always on')

			if self.ui.ui.Misc.otheraa:get("Safe head") then
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
			elseif self.ui.ui.Antiaim.freestanding:get_hotkey() and not (self.ui.ui.Antiaim.freestanding:get('Disablers') and self.ui.ui.Antiaim.freestanding_disablers:get(state)) then
        data.desync_mode = 'Gamesense'
        ui.set(self.ref.Antiaim.freestand[1], true)

			  if self.ui.ui.Antiaim.freestanding:get("Static Freestand") then
						yaw_offset = 0
						side = 2
			  end
      elseif self.ui.ui.Misc.otheraa:get("Anti backstab") and self:anti_backstab() then
				yaw_offset = yaw_offset + 180
			end

			local defensive = self.defensive.ticks * self.defensive.defensive > 0 and math.max(self.defensive.defensive, self.defensive.ticks) or 0

			if data.defensive_yaw and data.defensive_enable and self.helpers:contains(data.defensive_cond, 'Defensive Builder') then
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
				elseif data.defensive_yaw_mode == "dukbra" and defensive > 0 then
					local tickcount = globals.tickcount()
					yaw_offset = tickcount % 3 == 0 and client.random_int(90, -90) or tickcount % 3 == 1 and 180 or tickcount % 3 == 2 and client.random_int(-90, 90) or 0
					pitch = sync.pitch_statezzzz
				end
			end

      if data.desync_mode == 'Gamesense' then
        ui.set(self.ref.Antiaim.enabled[1], true)
        ui.set(self.ref.Antiaim.pitch[1], pitch == data.pitchstate and pitch or 'custom')
        ui.set(self.ref.Antiaim.pitch[2], type(pitch) == "number" and data.pitchamount or data.pitchamount)
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
      	if self.cycle >= delay[data.delayamount] then
        self.cycle = 1
        else
        	self.cycle = self.cycle + 1
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

	local vars = {
		localPlayer = 0,
		aaStates = {"Global", "Stand", "Move", "Slowwalk", "Crouch", "Air", "Air-Duck", "Legit-AA"},
		pStates = {"G", "S", "M", "SW", "C", "A", "AD", "LA"},
		sToInt = {["Global"] = 1, ["Stand"] = 2, ["Move"] = 3, ["Slowwalk"] = 4, ["Crouch"] = 5, ["Air"] = 6, ["Air-Duck"] = 7,["Legit-AA"] = 8},
		intToS = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Slowwalk", [5] = "Crouch", [6] = "Air", [7] = "Air-Duck", [8] = "Legit"},
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
-- database()
		switch = false,
	}

for _, eid in ipairs({
	{
		"load", function()
		-- database()
			ctx.ui:execute()
			ctx.config:setup()
		end
	},
	{
		"setup_command", function(cmd)
			if sync.pitch_statezzzz >= 89 then
				sync.pitch_statezzzz = -89
			else
				sync.pitch_statezzzz = sync.pitch_statezzzz + 1
			end
			--cmd.force_defensive = 1
			ctx.Antiaim:run(cmd)
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
		"paint_ui", function()
			ctx.helpers:ui_visibility(false)
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
	
	renderer.text(screen.x/17, screen.y/2.6, 184, 184, 184, 255, 'c', 0, '- They Wanna See Me Dead (nova chance)')

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

		renderer.text(screen.x/2, screen.y - y, 184, 184, 184, alpha, 'c', 0, 'Memory leak...')

		if alpha < 30 then
			renderguwno = "no"
		end
	end
end)