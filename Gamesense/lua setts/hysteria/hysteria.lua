



-- hysteria • gamesense
----- enQ. 2023



----<  Header  >----------------------------------------------------------------

if not LPH_OBFUSCATED then
	LPH_NO_VIRTUALIZE = function (...) return ... end
end

LPH_NO_VIRTUALIZE(function ()


local a = function (...) return ... end


--------------------------------------------------------------------------------
-- #region :: Definitions


--
-- #region : Definitions

local info_t = obex_fetch and obex_fetch() or { username = "enQ", build = "Debug", discord = 0 }

local _VERSION = "1.6"
local _LOCALLIB = info_t.username == "enQ"

-- #region - hysteria

local _BUILD, _LEVEL, _BLISS, _BETA, _DEBUG, _AZAZI = "stable", 1, false, false, false, false do
	local builds = {
		["Private"] = {1, "stable"},
		["User"] = {2, "bliss"},
		["Beta"] = {3, "beta"},
		["Debug"] = {4, "debug"},
	}

	local ctx = builds[info_t.build] or builds["User"]
	_BUILD, _LEVEL = ctx[2], ctx[1]

	if _LEVEL >= 2 then _BLISS = true end
	if _LEVEL >= 3 then _BETA = true end
	if _LEVEL >= 4 then _DEBUG = true end

	do
		local customs = {
			["sisar"] = function () _BUILD = "theos" end,
			["ruzh"] = function () _BUILD = "private" end,
			["qingshang"] = function () _LOCALLIB = true end,
			["justice"] = function () _AZAZI, _BUILD = true, "мезозои" end,
			["0000"] = function () _AZAZI, _BUILD = true, "смысл пездеть" end,
		}

		local name = string.lower(info_t.username)
		local custom = customs[name]
		if custom then custom() end
	end
end

local hysteria = {
	name = "hysteria",
	version = _VERSION, build = _BUILD, level = _LEVEL,
	user = {
		name = info_t.username,
		avatar = nil
	}
}

-- #endregion

-- #region - Dependencies and localization

local defer, error, getfenv, setfenv, getmetatable, setmetatable,
ipairs, pairs, next, printf, rawequal, rawset, rawlen, readfile, writefile, require, select,
tonumber, tostring, toticks, totime, type, unpack, pcall, xpcall =
defer, error, getfenv, setfenv, getmetatable, setmetatable,
ipairs, pairs, next, printf, rawequal, rawset, rawlen, readfile, writefile, require, select,
tonumber, tostring, toticks, totime, type, unpack, pcall, xpcall

local C = function (t) local c = {} if type(t) ~= "table" then return t end for k, v in next, t do c[k] = v end return c end

local table, math, string = C(table), C(math), C(string)
local ui, client, database, entity, ffi, globals, panorama, renderer
= C(ui), C(client), C(database), C(entity), C(require "ffi"), C(globals), C(panorama), C(renderer)

--

local requireb = function (name, link)
    local s, lib = pcall(require, name)
    if not s then error( ("You are not subscribed to %s.\nHere is the link to this library: gamesense.pub/forums/viewtopic.php?id=%s"):format(name, link), 3 ) end
    return lib
end

local pui = require "gamesense/pui"
local http = require "gamesense/http"
local adata = require "gamesense/antiaim_funcs"
local vector = require "vector"
local msgpack = require "gamesense/msgpack"
local weapondata = require "gamesense/csgo_weapons"

-- #endregion

-- #region - Misc

table.clear = require "table.clear"
table.ifind = function (t, j)  for i = 1, #t do if t[i] == j then return i end end  end
table.append = function (t, ...)  for i, v in ipairs{...} do table.insert(t, v) end  end
table.mfind = function (t, j)  for i = 1, table.maxn(t) do if t[i] == j then return i end end  end
table.find = function (t, j)  for k, v in pairs(t) do if v == j then return k end end return false  end
table.filter = function (t)  local res = {} for i = 1, table.maxn(t) do if t[i] ~= nil then res[#res+1] = t[i] end end return res  end
table.copy = function (o) if type(o) ~= "table" then return o end local res = {} for k, v in pairs(o) do res[table.copy(k)] = table.copy(v) end return res end
table.ihas = function (t, ...) local arg = {...} for i = 1, table.maxn(t) do for j = 1, #arg do if t[i] == arg[j] then return true end end end return false end
table.distribute = function (t, r, k)  local result = {} for i, v in ipairs(t) do local n = k and v[k] or i result[n] = r == nil and i or v[r] end return result  end
table.place = function (t, path, place)  local p = t for i, v in ipairs(path) do if type(p[v]) == "table" then p = p[v] else p[v] = (i < #path) and {} or place  p = p[v]  end end return t  end

math.e = 2.71828
math.gratio = 1.6180339887
math.randomseed( client.timestamp() - 143 )
math.round = function (v)  return math.floor(v + 0.5)  end
math.roundb = function (v, d)  return math.floor(v + 0.5) / (d or 0) ^ 1  end
math.clamp = function (x, a, b) if a > x then return a elseif b < x then return b else return x end end
math.lerp = function (a, b, w)  return a + (b - a) * w  end
math.normalize_yaw = function (yaw) return (yaw + 180) % -360 + 180 end
math.normalize_pitch = function (pitch) return math.clamp(pitch, -89, 89) end
math.closest_ray_point = function (p, s, e)
	local t, d = p - s, e - s
	local l = d:length()
	d = d / l
	local r = d:dot(t)
	if r < 0 then return s elseif r > l then return e end
	return s + d * r
end

string.insert = function (a, b, pos) return string.sub(a, 1, pos) .. b .. string.sub(a, pos + 1) end
string.limit = function (s, l, c) local r, i = {}, 1 for w in string.gmatch(s, ".[\128-\191]*") do i, r[i] = i + 1, w if i > l then if c then r[i] = c == true and "..." or c end break end end return table.concat(r) end


--

local NILFN = function()end
local ternary = function (c, a, b)  if c then return a else return b end  end

local my

-- #endregion

-- #endregion
--


--
-- #region : Helpers

-- #region - Callbacks

local callbacks do
	local event_mt = {
		__call = function (self, bool, fn)
			local action = bool and client.set_event_callback or client.unset_event_callback
			action(self[1], fn)
		end,
		set = function (self, fn)
			client.set_event_callback(self[1], fn)
		end,
		unset = function (self, fn)
			client.unset_event_callback(self[1], fn)
		end,
		fire = function (self, ...)
			client.fire_event(self[1], ...)
		end,
	}	event_mt.__index = event_mt

	callbacks = setmetatable({}, {
		__index = function (self, key)
			self[key] = setmetatable({key}, event_mt)
			return self[key]
		end,
	})
end

-- #endregion

-- #region - Renderer

local DPI, _DPI = 1, {}
local sw, sh = client.screen_size()
local asw, ash = sw, sh
local sc = {x = sw * .5, y = sh * .5}
local asc = {x = asw * .5, y = ash * .5}

--#region: custom colors

local color do
	local helpers = {
		RGBtoHEX = a(function (col, short)
			return string.format(short and "%02X%02X%02X" or "%02X%02X%02X%02X", col.r, col.g, col.b, col.a)
		end),
		HEXtoRGB = a(function (hex)
			hex = string.gsub(hex, "^#", "")
			return tonumber(string.sub(hex, 1, 2), 16), tonumber(string.sub(hex, 3, 4), 16), tonumber(string.sub(hex, 5, 6), 16), tonumber(string.sub(hex, 7, 8), 16) or 255
		end)
	}

	local create

	--
	local mt = {
		__eq = a(function (a, b)
			return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
		end),
		lerp = a(function (f, t, w)
			return create(f.r + (t.r - f.r) * w, f.g + (t.g - f.g) * w, f.b + (t.b - f.b) * w, f.a + (t.a - f.a) * w)
		end),
		to_hex = helpers.RGBtoHEX,
		alphen = a(function (self, a, r)
			return create(self.r, self.g, self.b, r and a * self.a or a)
		end),
	}	mt.__index = mt

	create = ffi.metatype(ffi.typeof("struct { uint8_t r; uint8_t g; uint8_t b; uint8_t a; }"), mt)

	--
	color = setmetatable({
		rgb = a(function (r,g,b,a)
			r = math.min(r or 255, 255)
			return create(r, g and math.min(g, 255) or r, b and math.min(b, 255) or r, a and math.min(a, 255) or 255)
		end),
		hex = a(function (hex)
			local r,g,b,a = helpers.HEXtoRGB(hex)
			return create(r,g,b,a)
		end)
	}, {
		__call = a(function (self, r, g, b, a)
			return type(r) == "string" and self.hex(r) or self.rgb(r, g, b, a)
		end),
	})
end

--#endregion

--#region: custom renderer

local render do
	local alpha = 1
	local astack = {}

	local measurements = setmetatable({}, { __mode = "kv" })

	-- #region - dpi

	local dpi_flag = ""
	local dpi_ref = ui.reference("MISC", "Settings", "DPI scale")

	_DPI.scalable = false
	_DPI.callback = function ()
		local old = DPI
		DPI = _DPI.scalable and tonumber(ui.get(dpi_ref):sub(1, -2)) * .01 or 1

		sw, sh = client.screen_size()
		sw, sh = sw / DPI, sh / DPI
		sc.x, sc.y = sw * .5, sh * .5
		dpi_flag = DPI ~= 1 and "d" or ""

		if old ~= DPI then
			callbacks["hysteria::render_dpi"]:fire(DPI)
			old = DPI
		end
	end

	_DPI.callback()
	ui.set_callback(dpi_ref, _DPI.callback)

	-- #endregion

	-- #region - blur

	local blurs = setmetatable({}, {__mode = "kv"})

	do
		local function check_screen ()
			if sw == 0 or sh == 0 then
				_DPI.callback()
				asw, ash = client.screen_size()
				sw, sh = render.screen_size()
			else
				callbacks.paint_ui:unset(check_screen)
			end
		end
		callbacks.paint_ui:set(check_screen)
	end

	callbacks.paint:set(function ()
		for i = 1, #blurs do
			local v = blurs[i]
			if v then renderer.blur(v[1], v[2], v[3], v[4]) end
		end
		table.clear(blurs)
	end)
	callbacks.paint_ui:set(function ()
		table.clear(blurs)
	end)

	-- #endregion

	local F, C, R = math.floor, math.ceil, math.round

	--
	render = setmetatable({
		cheap = false,

		push_alpha = a(function (v)
			local len = #astack
			astack[len+1] = v
			alpha = alpha * astack[len+1] * (astack[len] or 1)
			if len > 255 then error "alpha stack exceeded 255 objects, report to developers" end
		end),
		pop_alpha = a(function ()
			local len = #astack
			astack[len], len = nil, len-1
			alpha = len == 0 and 1 or astack[len] * (astack[len-1] or 1)
		end),
		get_alpha = a(function ()  return alpha  end),

		blur = a(function (x, y, w, h, a, s)
			if not render.cheap and my.valid and (a or 1) * alpha > .25 then
				blurs[#blurs+1] = {F(x * DPI), F(y * DPI), F(w * DPI), F(h * DPI)}
			end
		end),
		gradient = a(function (x, y, w, h, c1, c2, dir)
			renderer.gradient(F(x * DPI), F(y * DPI), F(w * DPI), F(h * DPI), c1.r, c1.g, c1.b, c1.a * alpha, c2.r, c2.g, c2.b, c2.a * alpha, dir or false)
		end),

		line = a(function (xa, ya, xb, yb, c)
			renderer.line(F(xa * DPI), F(ya * DPI), F(xb * DPI), F(yb * DPI), c.r, c.g, c.b, c.a * alpha)
		end),
		rectangle = a(function (x, y, w, h, c, n)
			x, y, w, h, n = F(x * DPI), F(y * DPI), F(w * DPI), F(h * DPI), n and F(n * DPI) or 0
			local r, g, b, a = c.r, c.g, c.b, c.a * alpha

			if n == 0 then
				renderer.rectangle(x, y, w, h, r, g, b, a)
			else
				renderer.circle(x + n, y + n, r, g, b, a, n, 180, 0.25)
				renderer.rectangle(x + n, y, w - n - n, n, r, g, b, a)
				renderer.circle(x + w - n, y + n, r, g, b, a, n, 90, 0.25)
				renderer.rectangle(x, y + n, w, h - n - n, r, g, b, a)
				renderer.circle(x + n, y + h - n, r, g, b, a, n, 270, 0.25)
				renderer.rectangle(x + n, y + h - n, w - n - n, n, r, g, b, a)
				renderer.circle(x + w - n, y + h - n, r, g, b, a, n, 0, 0.25)
			end
		end),
		rect_outline = a(function (x, y, w, h, c, n, t)
			x, y, w, h, n, t = F(x * DPI), F(y * DPI), F(w * DPI), F(h * DPI), n and F(n * DPI) or 0, t and F(t * DPI) or 1
			local r, g, b, a = c.r, c.g, c.b, c.a * alpha

			if n == 0 then
				renderer.rectangle(x, y, w - t, t, r, g, b, a)
				renderer.rectangle(x, y + t, t, h - t, r, g, b, a)
				renderer.rectangle(x + w - t, y, t, h - t, r, g, b, a)
				renderer.rectangle(x + t, y + h - t, w - t, t, r, g, b, a)
			else
				renderer.circle_outline(x + n, y + n, r, g, b, a, n, 180, 0.25, t)
				renderer.rectangle(x + n, y, w - n - n, t, r, g, b, a)
				renderer.circle_outline(x + w - n, y + n, r, g, b, a, n, 270, 0.25, t)
				renderer.rectangle(x, y + n, t, h - n - n, r, g, b, a)
				renderer.circle_outline(x + n, y + h - n, r, g, b, a, n, 90, 0.25, t)
				renderer.rectangle(x + n, y + h - t, w - n - n, t, r, g, b, a)
				renderer.circle_outline(x + w - n, y + h - n, r, g, b, a, n, 0, 0.25, t)
				renderer.rectangle(x + w - t, y + n, t, h - n - n, r, g, b, a)
			end
		end),
		triangle = a(function (x1, y1, x2, y2, x3, y3, c)
			x1, y1, x2, y2, x3, y3 = x1 * DPI, y1 * DPI, x2 * DPI, y2 * DPI, x3 * DPI, y3 * DPI
			renderer.triangle(x1, y1, x2, y2, x3, y3, c.r, c.g, c.b, c.a * alpha)
		end),

		circle = a(function (x, y, c, radius, start, percentage)
			renderer.circle(x * DPI, y * DPI, c.r, c.g, c.b, c.a * alpha, radius * DPI, start or 0, percentage or 1)
		end),
		circle_outline = a(function (x, y, c, radius, start, percentage, thickness)
			renderer.circle(x * DPI, y * DPI, c.r, c.g, c.b, c.a * alpha, radius * DPI, start or 0, percentage or 1, thickness * DPI)
		end),

		screen_size = a(function (raw)
			local w, h = client.screen_size()
			if raw then return w, h else return w / DPI, h / DPI end
		end),

		load_rgba = a(function (c, w, h) return renderer.load_rgba(c, w, h) end),
		load_jpg = a(function (c, w, h) return renderer.load_jpg(c, w, h) end),
		load_png = a(function (c, w, h) return renderer.load_png(c, w, h) end),
		load_svg = a(function (c, w, h) return renderer.load_svg(c, w, h) end),
		texture = a(function (id, x, y, w, h, c, mode)
			if not id then return end
			renderer.texture(id, F(x * DPI), F(y * DPI), F(w * DPI), F(h * DPI), c.r, c.g, c.b, c.a * alpha, mode or "f")
		end),

		text = a(function (x, y, c, flags, width, ...)
			renderer.text(x * DPI, y * DPI, c.r, c.g, c.b, c.a * alpha, (flags or "") .. dpi_flag, width or 0, ...)
		end),
		measure_text = a(function (flags, text)
			if not text or text == "" then return 0, 0 end
			text = text:gsub("\a%x%x%x%x%x%x%x%x", "")

			flags = (flags or "")

			local key = string.format("<%s>%s", flags, text)
			if not measurements[key] or measurements[key][1] == 0 then
				measurements[key] = { renderer.measure_text(flags, text) }
			end
			return measurements[key][1], measurements[key][2]
			-- return renderer.measure_text(flags, text)
		end),
	}, {__index = renderer})
end

--#endregion

--#region: anima

local anima do
	local mt, animators = {}, setmetatable({}, {__mode = "kv"})
	local frametime, g_speed = globals.absoluteframetime(), 1

	--


	anima = {
		pulse = 0,

		easings = {
			pow = {
				function (x, p) return 1 - ((1 - x) ^ (p or 3)) end,
				function (x, p) return x ^ (p or 3) end,
				function (x, p) return x < 0.5 and 4 * math.pow(x, p or 3) or 1 - math.pow(-2 * x + 2, p or 3) * 0.5 end,
			}
		},

		lerp = a(function (a, b, s, t)
			local c = a + (b - a) * frametime * (s or 8) * g_speed
			return math.abs(b - c) < (t or .005) and b or c
		end),

		condition = a(function (id, c, s, e)
			local ctx = id[1] and id or animators[id]
			if not ctx then animators[id] = { c and 1 or 0, c }; ctx = animators[id] end

			s = s or 4
			local cur_s = s
			if type(s) == "table" then cur_s = c and s[1] or s[2] end

			ctx[1] = math.clamp(ctx[1] + ( frametime * math.abs(cur_s) * g_speed * (c and 1 or -1) ), 0, 1)

			return (ctx[1] % 1 == 0 or cur_s < 0) and ctx[1] or
			anima.easings.pow[e and (c and e[1][1] or e[2][1]) or (c and 1 or 3)](ctx[1], e and (c and e[1][2] or e[2][2]) or 3)
		end)
	}

	--

	mt = {
		__call = anima.condition
	}

	--
	callbacks.paint_ui:set(function ()
		anima.pulse = math.abs(globals.realtime() * 1 % 2 - 1)
		frametime = globals.absoluteframetime()
	end)
end

--#endregion

local colors = {
	hex		= "\a74A6A9FF",
	accent	= color.hex("74A6A9"),
	back	= color.rgb(23, 26, 28),
	dark	= color.rgb(5, 6, 8),
	white	= color.rgb(255),
	black	= color.rgb(0),
	null	= color.rgb(0, 0, 0, 0),
	text	= color.rgb(230),
	panel = {
		l1 = color.rgb(5, 6, 8, 96),
		g1 = color.rgb(5, 6, 8, 140),
		l2 = color.rgb(23, 26, 28, 96),
		g2 = color.rgb(23, 26, 28, 140),
	}
}

-- #endregion

-- #region - Utilites

--#region: filesystem

local filesystem = {} do
	local m, i = "filesystem_stdio.dll", "VFileSystem017"
	local add_search_path		= vtable_bind(m, i, 11, "void (__thiscall*)(void*, const char*, const char*, int)")
	local remove_search_path	= vtable_bind(m, i, 12, "bool (__thiscall*)(void*, const char*, const char*)")

	local get_game_directory = vtable_bind("engine.dll", "VEngineClient014", 36, "const char*(__thiscall*)(void*)")
	filesystem.game_directory = string.sub(ffi.string(get_game_directory()), 1, -5)

	add_search_path(filesystem.game_directory, "ROOT_PATH", 0)
	defer(function () remove_search_path(filesystem.game_directory, "ROOT_PATH") end)

	filesystem.create_directory	= vtable_bind(m, i, 22, "void (__thiscall*)(void*, const char*, const char*)")
end

filesystem.create_directory("hysteria", "ROOT_PATH")

--#endregion

--#region: base64 (to be improved)

local base64 do
	local extract = function(v, from, width)
		return bit.band(bit.rshift(v, from), bit.lshift(1, width) - 1)
	end

	local function makeencoder(alphabet)
		local encoder, decoder = {}, {}
		for i = 1, 65 do
			local char = string.byte(string.sub(alphabet, i, i)) or 32 -- or ' '
			if decoder[char] ~= nil then
				error('invalid alphabet: duplicate character ' .. char, 3)
			end
			encoder[i - 1] = char
			decoder[char] = i - 1
		end
		return encoder, decoder
	end

	local encoders, decoders = {}, {}

	encoders['base64'], decoders['base64'] = makeencoder('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')
	encoders['base64url'], decoders['base64url'] = makeencoder('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_')

	local alphabet_mt = {
		__index = function(tbl, key)
			if type(key) == 'string' and #key == 64 or #key == 65 then
				encoders[key], decoders[key] = makeencoder(key)
				return tbl[key]
			end
		end
	}

	setmetatable(encoders, alphabet_mt)
	setmetatable(decoders, alphabet_mt)

	base64 = {
		encode = function (str, encoder)
			encoder = encoders[encoder or 'base64'] or error('invalid alphabet specified', 2)

			str = tostring(str)

			local t, k, n = {}, 1, #str
			local lastn = n % 3
			local cache = {}

			for i = 1, n-lastn, 3 do
				local a, b, c = string.byte(str, i, i+2)
				local v = a*0x10000 + b*0x100 + c
				local s = cache[v]

				if not s then
					s = string.char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
					cache[v] = s
				end

				t[k] = s
				k = k + 1
			end

			if lastn == 2 then
				local a, b = string.byte(str, n-1, n)
				local v = a*0x10000 + b*0x100
				t[k] = string.char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[64])
			elseif lastn == 1 then
				local v = string.byte(str, n)*0x10000
				t[k] = string.char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[64], encoder[64])
			end

			return table.concat(t)
		end,
		decode = function (b64, decoder)
			decoder = decoders[decoder or 'base64'] or error('invalid alphabet specified', 2)

			local pattern = '[^%w%+%/%=]'
			if decoder then
				local s62, s63
				for charcode, b64code in pairs(decoder) do
					if b64code == 62 then s62 = charcode
					elseif b64code == 63 then s63 = charcode
					end
				end
				pattern = string.format('[^%%w%%%s%%%s%%=]', string.char(s62), string.char(s63))
			end

			b64 = string.gsub(tostring(b64), pattern, '')

			local cache = {}
			local t, k = {}, 1
			local n = #b64
			local padding = string.sub(b64, -2) == '==' and 2 or string.sub(b64, -1) == '=' and 1 or 0

			for i = 1, padding > 0 and n-4 or n, 4 do
				local a, b, c, d = string.byte(b64, i, i+3)

				local v0 = a*0x1000000 + b*0x10000 + c*0x100 + d
				local s = cache[v0]
				if not s then
					local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
					s = string.char(extract(v,16,8), extract(v,8,8), extract(v,0,8))
					cache[v0] = s
				end

				t[k] = s
				k = k + 1
			end

			if padding == 1 then
				local a, b, c = string.byte(b64, n-3, n-1)
				local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40
				t[k] = string.char(extract(v,16,8), extract(v,8,8))
			elseif padding == 2 then
				local a, b = string.byte(b64, n-3, n-2)
				local v = decoder[a]*0x40000 + decoder[b]*0x1000
				t[k] = string.char(extract(v,16,8))
			end
			return table.concat(t)
		end
	}
end

--#endregion

--#region: clipboard

local clipboard do
	local char_array = ffi.typeof "char[?]"

	local native = {
		GetClipboardTextCount = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)"),
		SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)"),
		GetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")
	}

	clipboard = {
		get = function ()
			local length = native.GetClipboardTextCount()
			if length == 0 then return end

			local array = char_array(length)

			native.GetClipboardText(0, array, length)
			return ffi.string(array, length - 1)
		end,
		set = function (text)
			text = tostring(text)
			native.SetClipboardText(text, #text)
		end
	}
end

--#endregion

--#region: print / debug

local printc do
	local native_print = vtable_bind("vstdlib.dll", "VEngineCvar007", 25, "void(__cdecl*)(void*, const void*, const char*, ...)")

	printc = function (...)
		for i, v in ipairs{...} do
			local r = "\aD9D9D9" .. string.gsub(tostring(v), "[\r\v]", {["\r"] = "\aD9D9D9", ["\v"] = "\a".. (colors.hex:sub(1, 7))})
			for col, text in r:gmatch("\a(%x%x%x%x%x%x)([^\a]*)") do
				native_print(color.hex(col), text)
			end
		end
		native_print(color.rgb(217, 217, 217), "\n")
	end
end

hysteria.print = function (...)
	printc(_AZAZI and "  \vazazeria\r  " or "  \vhysteria\r  ", ...)
end

--

local debug = function (...)
	if _DEBUG then printc("  \vhysteria\r  ", ...) end
end

--#endregion

--#region: misc

local panorama_api = panorama.open()

local network = {
	open_link = panorama_api.SteamOverlayAPI.OpenExternalBrowserURL,
}

local mouse = { x = 0, y = 0 } do
	local unlock_cursor = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 66, "void(__thiscall*)(void*)")
	local lock_cursor = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 67, "void(__thiscall*)(void*)")

	mouse.lock = function (bool)
		if bool then lock_cursor() else unlock_cursor() end
	end

	mouse.in_bounds = function (x, y, w, h)
		return (mouse.x >= x and mouse.y >= y) and (mouse.x <= (x + w) and mouse.y <= (y + h))
	end

	mouse.pressed = function (key)
		return client.key_state(key or 1)
	end

	callbacks.pre_render:set(function ()
		mouse.x, mouse.y = ui.mouse_position()
		mouse.x, mouse.y = mouse.x / DPI, mouse.y / DPI
	end)
end

client.extrapolate = function (x, y, z, velocity, ticks)
	local time = globals.tickinterval() * ticks
	return x + (velocity.x * time), y + (velocity.y * time), z + (velocity.z * time)
end

do
	local native_get_client_entity = vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
	local animstate_t = ffi.typeof 'struct { char pad0[0x18]; float anim_update_timer; char pad1[0xC]; float started_moving_time; float last_move_time; char pad2[0x10]; float last_lby_time; char pad3[0x8]; float run_amount; char pad4[0x10]; void* entity; void* active_weapon; void* last_active_weapon; float last_client_side_animation_update_time; int	 last_client_side_animation_update_framecount; float eye_timer; float eye_angles_y; float eye_angles_x; float goal_feet_yaw; float current_feet_yaw; float torso_yaw; float last_move_yaw; float lean_amount; char pad5[0x4]; float feet_cycle; float feet_yaw_rate; char pad6[0x4]; float duck_amount; float landing_duck_amount; char pad7[0x4]; float current_origin[3]; float last_origin[3]; float velocity_x; float velocity_y; char pad8[0x4]; float unknown_float1; char pad9[0x8]; float unknown_float2; float unknown_float3; float unknown; float m_velocity; float jump_fall_velocity; float clamped_velocity; float feet_speed_forwards_or_sideways; float feet_speed_unknown_forwards_or_sideways; float last_time_started_moving; float last_time_stopped_moving; bool on_ground; bool hit_in_ground_animation; char pad10[0x4]; float time_since_in_air; float last_origin_z; float head_from_ground_distance_standing; float stop_to_full_running_fraction; char pad11[0x4]; float magic_fraction; char pad12[0x3C]; float world_force; char pad13[0x1CA]; float min_yaw; float max_yaw; } **'
	local animlayer_t = ffi.typeof 'struct { char pad_0x0000[0x18]; uint32_t sequence; float prev_cycle; float weight; float weight_delta_rate; float playback_rate; float cycle;void *entity;char pad_0x0038[0x4]; } **'

	entity.get_pointer = function (ent)
		return native_get_client_entity(ent)
	end

	entity.get_animstate = function (ent)
		local pointer = native_get_client_entity(ent)
		if pointer then return ffi.cast(animstate_t, ffi.cast("char*", ffi.cast("void***", pointer)) + 0x9960)[0] end
	end

	entity.get_animlayer = function (ent, layer)
		local pointer = native_get_client_entity(ent)
		if pointer then return ffi.cast(animlayer_t, ffi.cast('char*', ffi.cast("void***", pointer)) + 0x3914)[0][layer or 0] end
	end

	entity.get_simtime = function (ent)
		local pointer = native_get_client_entity(ent)
		if pointer then return entity.get_prop(ent, "m_flSimulationTime"), ffi.cast("float*", ffi.cast("uintptr_t", pointer) + 0x26C)[0] else return 0 end
	end

	entity.get_max_desync = function (animstate)
		local speedfactor = math.clamp(animstate.feet_speed_forwards_or_sideways, 0, 1)
		local avg_speedfactor = (animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1

		local duck_amount = animstate.duck_amount
		if duck_amount > 0 then
			local duck_speed = duck_amount * speedfactor

			avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
		end

		return math.clamp(avg_speedfactor, .5, 1)
	end
end

--#endregion

-- #endregion

-- #endregion
--

--
-- #region : Features introduction

local antiaim = {
	states = {
		{"default", "Default", "D"},
		{"stand", "Standing", "S"},
		{"run", "Running", "R"},
		{"walk", "Walking", "W"},
		{"air", "In-air", "A"},
		{"airduck", "Air-crouching", "AC"},
		{"crouch", "Crouching", "C"},
		{"sneak", "Sneaking", "3"},
	},
	presets = {
		-- [1] = antibrute
		custom = {
			[1] = {},
		},
	}
}

local rage, misc, visuals = {}, {}, {}
local vars, refs, textures = {}, {}, {}

-- #endregion
--

--
-- #region : Miscellaneous

-- #region - database

local db = {
	key = "hysteria",
	version = 2,
} do
	local data = database.read(db.key)

	if not data then
		data = {
			version = db.version,
			configs = {},
			stats = {
				killed = 0, evaded = 0, playtime = 0, loaded = 1
			},
		}

		database.write(db.key, data)
	end

	if data.version ~= db.version then
		data.stats.candies = nil
		data.version = db.version
	end

	if not data.stats.killed then data.stats.killed = 0 end
	if not data.stats.evaded then data.stats.evaded = 0 end
	if not data.stats.playtime then data.stats.playtime = 0 end
	if not data.stats.loaded then data.stats.loaded = 1 end

	data.stats.loaded = data.stats.loaded + 1

	--
	do
		local function automemo ()
			debug("autosave")
			client.fire_event("hysteria::database_write")
			database.write(db.key, data)
			client.delay_call(300, automemo)
		end client.delay_call(300, automemo)
	end

	defer(function ()
		database.write(db.key, data)
		database.flush()
	end)

	--
	setmetatable(db, {
		__index = data,
		__call = function (self, flush)
			database.write(db.key, data)
			if flush == true then database.flush() end
		end
 	})
end

-- #endregion

-- #region - enums

local enums = {
	hitgroups = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'},
	states = table.distribute(antiaim.states, nil, 1),
	build = {
		["stable"] = {"", ""},
		["beta"] = {"β", ""},
		["debug"] = {"♪", ""},
	},
	aspect_ratios = {
		{125, "5:4"},
		{133, "4:3"},
		{150, "3:2"},
		{160, "16:10"},
		{178, "16:9"},
		{200, "2:1"},
	},
}

local cvars = setmetatable({}, {
	__index = function (self, k)
		local v = cvar[k]
		rawset(self, k, v)
		return v
	end
})

-- #endregion

-- #region - me

local players = {}

my = {
	entity = entity.get_local_player(),
	origin = vector(),
	valid = false,
	threat = client.current_threat(),
	velocity = 0,
	exploit = {
		active = nil,
		defensive = false,
		lagpeek = false,
		shifted = false,
		ready = false,
		diff = 0,
	},
	side = 0,
} do
	local get_state = a(function (cmd)
		if my.on_ground then
			if my.crouching then return enums.states.crouch end
			if my.velocity > 5 then return my.walking and enums.states.walk or enums.states.run
			else return enums.states.stand end
		else
			-- return my.crouching and enums.states.aircrouch or enums.states.air
			return enums.states.air
		end
	end)

	local tickbase_max = 0
	local last_commandnumber

	callbacks.predict_command:set(function (cmd)
		if not my.valid or last_commandnumber ~= cmd.command_number then return end

		local tickbase = entity.get_prop(my.entity, "m_nTickBase") or 0

		if tickbase_max ~= nil then
            my.exploit.diff = tickbase - tickbase_max
			my.exploit.defensive = my.exploit.diff < -3

			if math.abs(tickbase - tickbase_max) > 64 then tickbase_max = 0 end
        end

		tickbase_max = math.max(tickbase, tickbase_max or 0)
	end)

	callbacks.finish_command:set(function (cmd)
		if my.valid then
			last_commandnumber = cmd.command_number
		end
	end)

	callbacks.run_command:set(function (cmd)
		my.entity = entity.get_local_player()
		my.valid = (my.entity and entity.is_alive(my.entity)) and true or false

		my.threat = my.valid and client.current_threat() or nil
		my.weapon = my.valid and entity.get_player_weapon(my.entity) or nil

		my.in_game = globals.mapname() ~= nil
		players = entity.get_players()

		if my.valid then
			local velocity = vector(entity.get_prop(my.entity, "m_vecVelocity"))
			my.velocity = velocity:length2d()

			my.origin = vector(entity.get_prop(my.entity, "m_vecOrigin"))
		end
	end)

	callbacks.pre_render:set(function ()
		my.valid = my.valid and globals.mapname() ~= nil
	end)

	local counter = 0

	callbacks.net_update_end:set(function ()
		my.entity = entity.get_local_player()
		my.valid = (my.entity and entity.is_alive(my.entity)) and true or false
		my.game_rules = entity.get_game_rules()

		if my.valid then
			local st_cur, st_old = entity.get_simtime(my.entity)

			my.exploit.lagpeek = st_cur < st_old

			-- counter = is_tb and counter + 1 or 0
			-- debug(is_st and "+" or "-", " ST / TB ", is_tb and "+" or "-")
			-- debug(counter, ": ", is_st and "ST " or "", is_tb and "TB " or "")
		end
	end)

	callbacks.setup_command:set(function (cmd)
		my.entity = entity.get_local_player()
		my.valid = (my.entity and entity.is_alive(my.entity)) and true or false

		my.threat = my.valid and client.current_threat() or nil
		my.weapon = my.valid and entity.get_player_weapon(my.entity) or nil

		players = entity.get_players()

		if my.valid then
			my.exploit.active =
			(refs.rage.aimbot.double_tap[1].value and refs.rage.aimbot.double_tap[1].hotkey:get()) and 0 or
			(refs.aa.other.onshot.value and refs.aa.other.onshot.hotkey:get()) and 1 or nil
			if refs.rage.other.duck:get() then my.exploit.active = nil end

			my.exploit.shifted = my.exploit.diff <= 0 or adata.get_double_tap()


			local flags = entity.get_prop(my.entity, "m_fFlags")

			my.using, my.in_score = cmd.in_use == 1, cmd.in_score == 1
			my.jumping = not my.on_ground or (cmd.in_jump == 1)
			my.walking = my.velocity > 5 and (cmd.in_speed == 1)
			my.on_ground = bit.band(flags, bit.lshift(1, 0)) == 1
			my.crouching = cmd.in_duck == 1

			my.side = (cmd.in_moveright == 1) and -1 or (cmd.in_moveleft == 1) and 1 or 0
			my.state = get_state(cmd)
		end
	end)
end

-- #endregion

-- #endregion
--


-- #endregion ------------------------------------------------------------------
--




--------------------------------------------------------------------------------
-- #region :: Menu


--
-- #region : GS References

refs = {
	rage = {
		aimbot = {
			force_baim = pui.reference("RAGE", "Aimbot", "Force body aim"),
			force_sp = pui.reference("RAGE", "Aimbot", "Force safe point"),
			hit_chance = pui.reference("RAGE", "Aimbot", "Minimum hit chance"),
			damage = pui.reference("RAGE", "Aimbot", "Minimum damage"),
			damage_ovr = { pui.reference("RAGE", "Aimbot", "Minimum damage override") },
			double_tap = { pui.reference("RAGE", "Aimbot", "Double tap") },
			dt_fl = { pui.reference("RAGE", "Aimbot", "Double tap fake lag limit") },
		},
		other = {
			peek = pui.reference("RAGE", "Other", "Quick peek assist"),
			duck = pui.reference("RAGE", "Other", "Duck peek assist"),
			log_misses = pui.reference("RAGE", "Other", "Log misses due to spread"),
		}
	},
	aa = {
		angles = {
			enable = pui.reference("AA", "Anti-Aimbot angles", "Enabled"),
			pitch = { pui.reference("AA", "Anti-Aimbot angles", "Pitch") },
			yaw = { pui.reference("AA", "Anti-Aimbot angles", "Yaw") },
			base = pui.reference("AA", "Anti-Aimbot angles", "Yaw base"),
			jitter = { pui.reference("AA", "Anti-Aimbot angles", "Yaw jitter") },
			body = { pui.reference("AA", "Anti-Aimbot angles", "Body yaw") },
			edge = pui.reference("AA", "Anti-Aimbot angles", "Edge yaw"),
			fs_body = pui.reference("AA", "Anti-Aimbot angles", "Freestanding body yaw"),
			freestand = pui.reference("AA", "Anti-Aimbot angles", "Freestanding"),
			roll = pui.reference("AA", "Anti-Aimbot angles", "Roll"),
		},
		fakelag = {
			enable = pui.reference("AA", "Fake lag", "Enabled"),
			amount = pui.reference("AA", "Fake lag", "Amount"),
			variance = pui.reference("AA", "Fake lag", "Variance"),
			limit = pui.reference("AA", "Fake lag", "Limit"),
		},
		other = {
			slowmo = pui.reference("AA", "Other", "Slow motion"),
			legs = pui.reference("AA", "Other", "Leg movement"),
			onshot = pui.reference("AA", "Other", "On shot anti-aim"),
			fp = pui.reference("AA", "Other", "Fake peek"),
		}
	},
	misc = {
		clantag = pui.reference("MISC", "Miscellaneous", "Clan tag spammer"),
		log_damage = pui.reference("MISC", "Miscellaneous", "Log damage dealt"),
		ping_spike = pui.reference("MISC", "Miscellaneous", "Ping spike"),
		settings = {
			dpi = pui.reference("MISC", "Settings", "DPI scale"),
			accent = pui.reference("MISC", "Settings", "Menu color"),
			maxshift = pui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks2")
		}
	}
}

defer(function ()
	pui.traverse(refs, function (ref)
		ref:override()
		ref:set_enabled(true)
		if ref.hotkey then ref.hotkey:set_enabled(true) end
	end)
	refs.misc.settings.maxshift:set_visible(false)
end)

-- #endregion
--

--
-- #region : Script menu

-- #region - Base

pui.macros.silent = "\aCDCDCD40"
pui.macros.p = "\aCDCDCD40•\r  "
pui.macros.hysteria = colors.hex
pui.macros.hysteriab = string.sub(colors.hex, 2, 7)

-- pui.accent = "74A6A9FF"

local menu, groups = {
	x = 0, y = 0, w = 0, h = 0,
	set_visible = function (bool, aa)
		pui.traverse(refs.aa, function (r, path)
			if aa and hysteria.build == "stable" and vars.antiaim.global.value and path[1] == "angles" then
				r:set_visible(false)
			else
				r:set_visible(bool == nil and true or bool)
			end
		end)
	end,
	tabs = {
		{"general", "Home"},
		{"settings", "Settings"},
		{"antiaim", "Anti-aim"},
	},
	header = function (group, text)
		local r = {}
		if text then r[#r+1] = group:label("\v•\r  ".. text) end
		r[#r+1] = group:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾")
		return r
	end,
	feature = function (main, settings)
		main = main.__type == "pui::element" and {main} or main
		local feature, g_depend = settings(main[1])

		for k, v in pairs(feature) do
			v:depend({main[1], g_depend})
		end
		feature[main.key or "on"] = main[1]

		return feature
	end,
	space = function (group) return group:label "\n" end,
	lock = function (id, item, to, min)
		if _LEVEL < (min or 2) then
			local cb = function (this) client.delay_call(.1, function() this:set(to or false) end) end
			item:set_callback(cb, true)
			item:set_enabled(false)
		end

		return item
	end
}, {
	angles = pui.group("AA", "Anti-aimbot angles"),
	fakelag = pui.group("AA", "Fake lag"),
	other = pui.group("AA", "Other"),
}

do -- auto-hide
	refs.aa.angles.yaw[2]:depend({refs.aa.angles.yaw[1], 1})
	refs.aa.angles.pitch[2]:depend({refs.aa.angles.pitch[1], 1})
	refs.aa.angles.jitter[1]:depend({refs.aa.angles.yaw[1], 1})
	refs.aa.angles.jitter[2]:depend({refs.aa.angles.jitter[1], 1})
	refs.aa.angles.body[2]:depend({refs.aa.angles.body[1], 1})
	refs.aa.angles.fs_body:depend({refs.aa.angles.body[1], 1})
end

callbacks.paint_ui:set(function ()
	menu.x, menu.y = ui.menu_position()
	menu.w, menu.h = ui.menu_size()
end)

-- #endregion

-- #region - Unsavable

menu.main = {
	menu.space(groups.fakelag),
	global = groups.fakelag:checkbox(_AZAZI and "\f<silent>-----------  \vазази\rазаза  \f<silent>-----------" or "\f<silent>-------------  \vhyst\reria  \f<silent>-------------"),
	bar = groups.fakelag:label("\f<silent>‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
	tab = groups.fakelag:combobox("\n", table.distribute(menu.tabs, 2)),
	-- menu.space(groups.fakelag),
}

menu.misc = {
	overridden = groups.angles:label("Overridden by \vhysteria")
}

menu.info = {
	user = groups.fakelag:label(" \f<silent>User   \v".. hysteria.user.name),
	version = groups.fakelag:label( (hysteria.build == "stable" and " \f<silent>Version   \v%s" or " \f<silent>Version   \v%s • %s"):format(hysteria.version, hysteria.build) ),
	menu.header(groups.fakelag)
}

menu.general = {
	config = {
		menu.header(groups.other, "New config"),
		name = groups.other:textbox("Name"),
		create = groups.other:button("Create", NILFN),
		import = groups.other:button("Import", NILFN),

		menu.header(groups.angles, "Your configs"),
		list = groups.angles:listbox("Configs", {"Default"}),
		selected = groups.angles:label("Selected: \vDefault"),
		list_report = groups.angles:label("REPORT"),
		load = groups.angles:button("\f<hysteria>Load", NILFN),
		loadaa = groups.angles:button("Load AA only", NILFN),
		save = groups.angles:button("Save", NILFN),
		export = groups.angles:button("Export", NILFN),
		delete = groups.angles:button("\aD95148FFDelete", NILFN),
		deleteb = groups.angles:button("\aD9514840Delete", NILFN),
	},
	verify = {
		menu.space(groups.other),
		menu.header(groups.other, "Discord"),
		groups.other:button("Join us", function () network.open_link("https://discord.gg/eC82SmcF9E") end),
		auth = groups.other:button("Copy authcode", NILFN),
	},
}

menu.stats = {
	menu.header(groups.other, "Statistics"),
	loaded = groups.other:label("\f<silent>Times loaded\t\v" .. db.stats.loaded),
	playtime = groups.other:label("\f<silent>Hours played\t\v" .. math.floor(db.stats.playtime), ":", math.floor(db.stats.playtime % 1 * 60)),
	killed = groups.other:label("\f<silent>Enemies eliminated\t\v" .. db.stats.killed),
	evaded = groups.other:label("\f<silent>Evaded shots\t\v" .. db.stats.evaded),
	candies = groups.other:label("\f<silent>Candies gathered\t\v" .. (database.read("hysteria::candies") or 0)),
}

menu.candyshop = {}

-- #endregion

-- #region - Vars

vars.rage = {
	menu.header(groups.angles, "Ragebot"),
	teleport = menu.feature({groups.angles:checkbox("Auto teleport", 0x00)}, function (parent)
		return {
			land = groups.angles:checkbox("\f<p>Ensure landing"),
			pistol = groups.angles:checkbox("\f<p>Allow pistols"),
		}, true
	end),
	exswitch = menu.feature({groups.angles:checkbox("Auto exploit switch")}, function (parent)
		return {
			allow = groups.angles:multiselect("\f<p>Additional weapons", {"Pistols", "Desert Eagle"}),
		}, true
	end),
	resolver = groups.angles:checkbox("Jitter resolver"),
	menu.space(groups.angles)
}

vars.visuals = {
	menu.header(groups.angles, "Visuals"),
	groups.angles:label("Accent color"),
	accent = groups.angles:color_picker("Accent color", colors.accent.r, colors.accent.g, colors.accent.b, 255),
	crosshair = menu.feature(groups.angles:checkbox("Crosshair indicators"), function (parent)
		return {
			style = groups.angles:combobox("\nch_style", {"Classic", "Mini"}),
			logo = groups.angles:checkbox("\f<p>Butterfly"),
		}, true
	end),
	damage = groups.angles:checkbox("Damage indicator"),
	arrows = groups.angles:checkbox("Anti-aim arrows"),
	water = menu.feature(groups.angles:checkbox("Watermark"), function ()
		return {
			name = groups.angles:textbox("\f<p>Custom name"),
			hide = groups.angles:checkbox("\f<p>Hide logo"),
		}, true
	end),
	keylist = groups.angles:checkbox("Keylist"),
	speclist = groups.angles:checkbox("Speclist"),
	marker = groups.angles:checkbox("Hitmarker"),
	slowdown = groups.angles:checkbox("Slowdown warning"),
	cheap = groups.angles:checkbox("Performance mode"),
	dpi = groups.angles:checkbox("DPI scaling"),
	menu.space(groups.angles),
}

vars.misc = {
	menu.header(groups.angles, "Miscellaneous"),
	aspect = menu.feature(groups.angles:checkbox("Aspect ratio"), function ()
		return {
			ratio = groups.angles:slider("\naratio", 80, 200, 133, true, nil, .01, table.distribute(enums.aspect_ratios, 2, 1))
		}, true
	end),
	ladder = groups.angles:checkbox("Fast ladder"),
	clantag = groups.angles:checkbox("Clantag"),
	filter = groups.angles:checkbox("Console filter"),
	logs = menu.feature(groups.angles:checkbox("Eventlogger"), function (parent)
		return {
			events = groups.angles:multiselect("\f<p>Events", {"Ragebot shots", "Harming enemies", "Getting harmed", "Anti-aim info"}),
			output = groups.angles:multiselect("\f<p>Output", {"Console", "Screen"}),
		}, true
	end),
	breaker = menu.feature(groups.angles:checkbox("Animation breaker"), function (parent)
		return {
			pitch = groups.angles:checkbox("\f<p>Pitch 0 on land"),
			slia = groups.angles:checkbox("\f<p>Static legs in air"),
			legs = groups.angles:combobox("\f<p>Legs", {"None", "Static", "Jitter", "No step back"}),
		}, true
	end)
}

vars.drag = {}


-- #endregion

-- #region - Anti-aim

vars.antiaim = {
	global = groups.fakelag:checkbox("Enable"),
	tab = groups.fakelag:combobox("\n", {"General", "Builder"}, nil, false),

	general = {
		menu.header(groups.angles, "General"),
		inverter = groups.angles:hotkey("Inverter", false),
		yaw = groups.angles:combobox("Yaw base", {"At targets", "Local view"}),
		head = groups.angles:multiselect("Safe head", {"Air melee", "Height difference"}),
		manual = menu.feature(groups.angles:checkbox("Manual yaw"), function ()
			return {
				st = groups.angles:checkbox("\f<p>Static manual yaw"),
				left = groups.angles:hotkey("\f<p>Left", false, 0),
				right = groups.angles:hotkey("\f<p>Right", false, 0),
				reset = groups.angles:hotkey("\f<p>Reset", false, 0),
				edge = groups.angles:hotkey("\f<p>Edge yaw", false, 0),
				fs = groups.angles:hotkey("\f<p>Freestanding", false, 0),
			}, true
		end),
		stab = groups.angles:checkbox("Anti-backstab"),
		use = groups.angles:checkbox("On use AA"),
		warmup = groups.angles:checkbox("Warmup AA"),
		menu.space(groups.angles)
	},
	exploits = {
		menu.header(groups.angles, "Exploits"),
		vulnlc = groups.angles:multiselect("\aB6B665FFLC breaker", {"Can't shoot", "Jumping", "Crouching"}),
		snap = menu.feature(groups.angles:checkbox("\aB6B665FFDefensive snap", 0x00), function ()
			return {
				lp = groups.angles:checkbox("\f<p>Ping-safe"),
				os = groups.angles:checkbox("\f<p>Allow with On shot AA"),
				groups.angles:label("\f<p>See \vBuilder\r for more settings.")
			}, true
		end),
		menu.space(groups.angles)
	},
	lag = {
		menu.header(groups.other, "Lag settings"),
		fakelag = menu.feature(groups.other:checkbox("Fake lag"), function ()
			return {
				mode = groups.other:combobox("\nflmode", {"Dynamic", "Maximum", "Fluctuate"}),
				limit = groups.other:slider("\f<p>Limit", 1, 15, 14, true, "t")
			}, true
		end),
	},

	builder = {
		state = groups.angles:combobox("\v•\r  State  \a373737FF----------------------------", table.distribute(antiaim.states, 2), nil, false),
		-- menu.header(groups.other, "Actions with this state"),
		-- import = groups.other:button("Import", function () end),
		-- export = groups.other:button("Export", function () end),
	},
	states = {},
	venture = {
		long = {
			menu.header(groups.other, "Long-term"),
			gaslight = groups.other:checkbox("Gaslighting")
		},
		short = {
			menu.header(groups.angles, "In-time"),
		}
	}
}

do -- states
	local new = function (path, ref)
		ref:set_callback(function (self) table.place(antiaim.presets.custom, path, self.value) end, true)
		return ref
	end

	local tooltips = {
		delay = { [1] = "Off", [15] = "RS", [16] = "RL", [17] = "AB" }
	}

	for i, v in ipairs(antiaim.states) do
		local id, name, short = v[1], v[2], v[3]

		vars.antiaim.states[id], pui.macros._p = {}, "\n"..short
		local ctx = vars.antiaim.states[id]
		--

		if id ~= "default" then
			ctx.override = new({id, "override"}, groups.angles:checkbox("Override \v".. name:lower()))
		end

		ctx[#ctx+1] = menu.space(groups.angles)
		ctx[#ctx+1] = menu.header(groups.angles, "Yaw")

		--
		ctx.y_off	= new({id, "yaw", "offset"}, groups.angles:slider("Offset\f<_p>", -60, 60, 0, true, "°"))

		ctx[#ctx+1] = menu.space(groups.angles)
		ctx.mod		= new({id, "mod", "type"}, groups.angles:combobox("Modifier\f<_p>", {"None", "Jitter", "X-way", "Rotate", "Random", _AZAZI and "пердельта" or nil}))
		ctx.w_m		= new({id, "ways", "manual"}, groups.angles:checkbox("\f<p>Manual ways\f<_p>"))
		ctx.m_r		= new({id, "mod", "range"}, groups.angles:checkbox("\f<p>Range\f<_p>"))
		ctx.m_a		= new({id, "mod", "add"}, groups.angles:checkbox("\f<p>Add yaw\f<_p>"))

		--
		ctx.w_num	= new({id, "ways", "total"}, groups.angles:slider("\nwnum".. id, 3, 7, 3, true, "-w"))
		ctx.w_label = groups.angles:label("Each way\f<_p>") ctx.w_label:depend({ctx.mod, "X-way"}, ctx.w_m)
		ctx.w_num:set_callback(function (this) ctx.w_label:set("Each way \aCDCDCD60" .. this.value) end, true)

		ctx.ways = {} for w = 1, 7 do
			ctx.ways[w] = new({id, "way", w}, groups.angles:slider("\n"..w..id, -60, 60, 0, true, "°", 1, {[0] = "R"}))
			ctx.ways[w]:depend({ctx.mod, "X-way"}, ctx.w_m, {ctx.w_num, w, 7})
		end

		--
		ctx.m_d		= new({id, "mod", "degree"}, groups.angles:slider("Degree\f<_p>", -60, 60, 0, true, "°"))
		ctx.m_min	= new({id, "mod", "min"}, groups.angles:slider("Range \aCDCDCD60min/max\f<_p>", -60, 60, 0, true, "°"))
		ctx.m_max	= new({id, "mod", "max"}, groups.angles:slider("\nmodmax\f<_p>", -60, 60, 0, true, "°"))
		ctx.m_al	= new({id, "mod", "left"}, groups.angles:slider("Add \aCDCDCD60left/right\f<_p>", -60, 60, 0, true, "°"))
		ctx.m_ar	= new({id, "mod", "right"}, groups.angles:slider("\nar\f<_p>", -60, 60, 0, true, "°"))


		--
		ctx[#ctx+1]	= menu.space(groups.angles)
		ctx[#ctx+1]	= menu.header(groups.angles, "Desync")
		ctx.d_on	= new({id, "body", "on"}, groups.angles:checkbox("Body yaw\f<_p>"))
		ctx.d_sw	= new({id, "body", "jitter"}, groups.angles:checkbox("\f<p>Jitter\f<_p>"))
		ctx.d_rw	= new({id, "body", "relative"}, groups.angles:checkbox("\f<p>Relative X-way\f<_p>"))
		ctx.d_mode	= new({id, "body", "mode"}, groups.angles:combobox("Body yaw mode\f<_p>", {"Auto", "Default", "Side-based"}))
		ctx.d_d		= new({id, "body", "degree"}, groups.angles:slider("\nfdeg\f<_p>", -180, 180, 0, true, "°"))
		ctx.d_l		= new({id, "body", "left"}, groups.angles:slider("Range \aCDCDCD60left/right\nbodyl\f<_p>", -180, 180, 0, true, "°"))
		ctx.d_r		= new({id, "body", "right"}, groups.angles:slider("\nbodyr\f<_p>", -180, 180, 0, true, "°"))
		-- ctx.d_dbase	= groups.angles:slider("Foot base\f<_p>", -180, 180, 0, true, "°")
		-- ctx.d_dpow	= groups.angles:slider("Overdrive\f<_p>", 0, 50, 0, true, "ω", 0.1)

		--
		ctx[#ctx+1]	= menu.header(groups.other, "Advanced")
		ctx.r_ir	= new({id, "adv", "irreg"}, groups.other:slider("Irregularity\f<_p>", 0, 100, 0, true, "%"))
		ctx.r_dt	= new({id, "adv", "delay"}, groups.other:slider("Delay tick\f<_p>", 1, 17, 0, true, "t", 1, tooltips.delay))
		ctx.ds		= new({id, "snap", "on"}, groups.other:combobox("Defensive snap\f<_p>", id == "default" and {"Off", "Custom"} or {"Default", "Off", "Custom"}))
		ctx.dsp 	= new({id, "snap", "pitch"}, groups.other:combobox("\f<p>Pitch\f<_p>", {"None", "Switch", "Random", "Spin"}))
		ctx.dsp1	= new({id, "snap", "pitch_min"}, groups.other:slider("\f<_p>pmin", -89, 89, -45, true, "°"))
		ctx.dsp2	= new({id, "snap", "pitch_max"}, groups.other:slider("\f<_p>pmax", -89, 89, -45, true, "°"))
		ctx.dsy		= new({id, "snap", "yaw"}, groups.other:combobox("\f<p>Yaw\f<_p>", {"None", "Switch", "Random", "Spin", _AZAZI and "азазой" or nil}))
		ctx.dsy1	= new({id, "snap", "yaw_min"}, groups.other:slider("\f<_p>ymin", 0, 360, 180, true, "°"))
		-- ctx.dsy2	= new({id, "snap", "yaw_max"}, groups.other:slider("\f<_p>ymax", -180, 180, 90, true, "°"))

		--
		do
			ctx.d_sw:depend(ctx.d_on)
			ctx.d_mode:depend(ctx.d_on)
			ctx.d_d:depend(ctx.d_on, {ctx.d_mode, "Default"})
			ctx.d_l:depend(ctx.d_on, {ctx.d_mode, "Side-based"})
			ctx.d_r:depend(ctx.d_on, {ctx.d_mode, "Side-based"})
			-- ctx.d_dbase:depend(ctx.d_on, {ctx.d_mode, "Dynamic"})
			-- ctx.d_dpow:depend(ctx.d_on, {ctx.d_mode, "Dynamic"})
			ctx.d_rw:depend(ctx.d_on, {ctx.mod, "X-way"})
		end
		do
			local ways_check = function () return not (ctx.mod.value == "X-way" and ctx.w_m.value) end

			ctx.w_m:depend({ctx.mod, "X-way"})
			ctx.m_r:depend({ctx.mod, "None", true}, {ctx.w_m, ways_check})
			ctx.m_a:depend({ctx.mod, "None", true})

			ctx.m_d:depend({ctx.m_r, false}, {ctx.mod, "None", true}, {ctx.w_m, ways_check})
			ctx.m_min:depend({ctx.m_r, true}, {ctx.mod, "None", true}, {ctx.w_m, ways_check})
			ctx.m_max:depend({ctx.m_r, true}, {ctx.mod, "None", true}, {ctx.w_m, ways_check})
			ctx.m_al:depend({ctx.m_a, true}, {ctx.mod, "None", true})
			ctx.m_ar:depend({ctx.m_a, true}, {ctx.mod, "None", true})

			ctx.w_num:depend({ctx.mod, "X-way"})
		end
		do
			ctx.ds:depend({vars.antiaim.exploits.snap.on, true})
			ctx.dsp:depend({vars.antiaim.exploits.snap.on, true}, {ctx.ds, "Custom"})
			ctx.dsy:depend({vars.antiaim.exploits.snap.on, true}, {ctx.ds, "Custom"})
			ctx.dsp1:depend({vars.antiaim.exploits.snap.on, true}, {ctx.ds, "Custom"}, {ctx.dsp, "None", true})
			ctx.dsp2:depend({vars.antiaim.exploits.snap.on, true}, {ctx.ds, "Custom"}, {ctx.dsp, "None", true})
			ctx.dsy1:depend({vars.antiaim.exploits.snap.on, true}, {ctx.ds, "Custom"}, {ctx.dsy, "None", true})
			-- ctx.dsy2:depend({vars.antiaim.exploits.snap.on, true}, {ctx.ds, "Custom"}, {ctx.dsy, "None", true})
		end

		--
		pui.traverse(ctx, function (ref, path)
			ref:depend({vars.antiaim.builder.state, name}, path[#path] ~= "override" and ctx.override or nil)
		end)
	end

	pui.macros._p = nil

	-- vars.antiaim.builder.state:set_callback(function (this)
	-- 	vars.antiaim.builder[1][1]:set(pui.format "\v•\r  Actions with \v" .. this.value)
	-- end, true)
end

do -- brute

end

-- #endregion

-- #region - Handle

if not _BLISS then
	menu.lock("jr", vars.rage.resolver)
	menu.lock("es", vars.rage.exswitch.on, nil, 3)
	menu.lock("kl", vars.visuals.keylist)
	menu.lock("sl", vars.visuals.speclist)
	menu.lock("hm", vars.visuals.marker)
	menu.lock("ab", vars.misc.breaker.on)
	menu.lock("fl", vars.misc.ladder)
	menu.lock("sh", vars.antiaim.general.head, {})
end

do
	defer(menu.set_visible)

	vars.visuals.dpi:set_callback(function (this)
		_DPI.scalable = this.value
		_DPI.callback()
	end, true)

	menu.main.global:set_callback(function (this) menu.set_visible(not this.value, true) end, true)
	menu.main[1]:depend({menu.main.global, false})
	menu.main.tab:depend(menu.main.global)
	menu.main.bar:depend(menu.main.global)

	--

	menu.misc.overridden:depend({menu.main.global, false}, vars.antiaim.global)
	pui.traverse(menu.info, function (ref, path)
		ref:depend(menu.main.global)
	end)
	pui.traverse(menu.general, function (ref, path)
		ref:depend(menu.main.global, {menu.main.tab, "Home"})
	end)
	pui.traverse(menu.stats, function (ref, path)
		ref:depend(menu.main.global, {menu.main.tab, "Settings"})
	end)
	pui.traverse({vars.rage, vars.visuals, vars.misc}, function (ref, path)
		ref:depend(menu.main.global, {menu.main.tab, "Settings"})
	end)
	pui.traverse(vars.antiaim, function (ref, path)
		ref:depend(menu.main.global, {menu.main.tab, "Anti-aim"}, (path[#path] ~= "global") and vars.antiaim.global or nil)

		if path[1] == "global" or path[1] == "tab" then return end

		if path[1] == "builder" or path[1] == "states" then
			ref:depend({vars.antiaim.tab, "Builder"})
		elseif path[1] == "venture" then
			ref:depend({vars.antiaim.tab, "Anti-bruteforce"})
		else
			ref:depend({vars.antiaim.tab, "General"})
		end
	end)

	--

	local gray, accent = color.rgb(69), color.hex(pui.accent)
	callbacks.paint_ui:set(function ()
		if not ui.is_menu_open() then return end

		local pulse = math.abs(globals.realtime() * 0.5 % 2 - 1)
		local col = gray:lerp(accent, anima.easings.pow[1](pulse, 4))

		menu.main.bar:set("\a".. col:to_hex() .. "‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾")
	end)
	client.set_event_callback("pui::accent_color", function (new)
		accent = color.rgb(new[1], new[2], new[3], 255)
	end)

	vars.visuals.accent:set_callback(function (this)
		local r, g, b = unpack(this.value)
		colors.accent = color.rgb(r, g, b, 255)
		colors.hex = "\a".. colors.accent:to_hex()
		colors.hexs = string.sub(colors.hex, 1, -3)
	end, true)

	vars.visuals.cheap:set_callback(function (this)
		render.cheap = this.value
	end, true)
end

-- #endregion

-- #endregion
--

--
-- #region : Config system

local configs = {
	system = nil,
	default = "hysteria::GS::KGRlZmF1bHQpW2VuUV17haRkcmFniKhzcGVjbGlzdIKhec0TiKF4zQtkpmFycm93c4Khec0TYqF4zRKYqWNyb3NzaGFpcoKhec0UlKF4zRMLqHNsb3dkb3dugqF5zQlLoXjNEkz113Zna2V5bGlzdIKhec0TiKF4zQtkpmRhbWFnZYKhec0TraF4zROcqXdhdGVybWFya4Ohecy5oXjNJp2hYQKkbG9nc4Khec0azaF4zRB6p3Zpc3VhbHOLo2RwacKlY2hlYXDCpm1hcmtlcsOoc3BlY2xpc3TCpmFycm93c8Kna2V5bGlzdMKoc2xvd2Rvd27DpmRhbWFnZcOmYWNjZW50qSM3NEE2QTlGRqV3YXRlcoOkaGlkZcKkbmFtZaCib27DqWNyb3NzaGFpcoOkbG9nb8Olc3R5bGWnQ2xhc3NpY6JvbsOkbWlzY4amZmlsdGVyw6ZsYWRkZXLDp2NsYW50YWfCp2JyZWFrZXKEpHNsaWHDpXBpdGNowqJvbsKkbGVnc6ROb25lpmFzcGVjdIKlcmF0aWz143ZMhaJvbsOkbG9nc4OmZXZlbnRzla1SYWdlYm90IHNob3Rzr0hhcm1pbmcgZW5lbWllc65HZXR0aW5nIGhhcm1lZK1BbnRpLWFpbSBpbmZvoX6mb3V0cHV0k6dDb25zb2xlplNjcmVlbqFz113Zom9uw6dhbnRpYWlthqd2ZW50dXJlgaRsb25ngahnYXNsaWdodMKmZ2xvYmFsw6NsYWeBp2Zha2VsYWeDpWxpbWl0D6Rtb2Rlp0R5bmFtaWOib27Dp2dlbmVyYWyHpHN0YWLDpGhlYWSRoX6jdXNlw6ZtYW51YWyHpXJpZ2h0kwIAoX6kbGVmdJMCAKFz113ZpGVkZ2WTAgChfqJzdMKiZnOTAgChfqJvbsOlcmVzZXSTAgChfqhpbnZlcnRlcpMBAKFz113Zo3lhd6pBdCB0YXJnZXRzpndhcm11cMKoZXhwbG9pdHOCpnZ1bG5sY5SrQ2FuJ3Qgc2hvb3SnSnVtcGluZ6lDcm91Y2hpbmehfqRzbmFwhKJvc8OibHDDom9uw6Rvbl9okwAAoX6mc3RhdGVziKR3YWxr3gAco2RfZAClbV9taW7lpG1fYXIApG1fYWwApHJfZHQFo21vZKZKaXR0ZXKkcl9pcgqjbV9hwqVtX21heCOjZHN5pE5vbmWob3ZlcnJpZGXDomRzp0RlZmF1bHSkZF9yd8KkZF9zd8OkZF9vbsOjZHNwpE5vbmWkZHNwMtDTo2RfcgCjZF9sAKNtX2QApXdfbnVtA6V5X29mZgCmZF9tb2RlpEF1dGz113ZjbV9yw6Rkc3Ax0NOkd2F5c5cAAAAAAAAApGRzeTHMtKN3X23Cp2FpcmR1Y2veAByjZF9kAKVtX21pbuqkbV9hcgCkbV9hbACkcl9kdAOjbW9kpkppdHRlcqRyX2lyBqNtX2HCpW1fbWF4JKNkc3mmU3dpdGNoqG92ZXJyaWRlw6Jkc6ZDdXN0b22kZF9yd8KkZF9zd8OkZF9vbsOjZHNwplN3aXRjaKRkc3AyAKNkX3IAo2RfbACjbV9kAKV3X251bQOleV9vZmYDpmRfbW9kZaRBdXRvo21fcsOkZHNwMdCnpHdheXOXAAAAAAAAAKRkc3kxzPCjd19twqNhaXLeAByjZF9kAKVtX21pbgCkbV9hcgCkbV9hbACkcl9kdBGjbW9kpkppdHRlcqRyX2lyAKNtX2HCpW1fbWF4AKNkc3mmU3dpdGNoqG92ZXJyaWRlw6Jkc6ZDdXN0b22kZF9yd8KkZF9zd8OkZF9vbsOjZHNwplN3aXRjaKRkc3AyAKNkX3IAo2RfbACjbV9kHKV3X251bQOleV9vZmYDpmRfbW9kZaRBdXRvo21fcsKkZHNwMQCkd2F5c5cAAAAAAAAApGRzeTHMtKN3X23CpXNuZWFr3gAco2RfZAClbV9taW7rpG1fYXIApG1fYWwApHJfZHQRo21vZKZKaXR0ZXKkcl9pcgajbV9hwqVtX21heCSjZHN5pE5vbmWob3ZlcnJpZGXDomRzp0RlZmF1bHSkZF9yd8KkZF9zd8OkZF9vbsOjZHNwpE5vbmWkZHNwMtDTo2RfcgCjZF9sAKNtX2QApXdfbnVtA6V5X29mZgCmZF9tb2RlpEF1dGz113ZjbV9yw6Rkc3Ax0NOkd2F5c5cAAAAAAAAApGRzeTHMtKN3X23CpXN0YW5k3gAco2RfZAilbV9taW4ApG1fYXIApG1fYWwApHJfZHQBo21vZKZKaXR0ZXKkcl9pcgCjbV9hwqVtX21heACjZHN5pE5vbmWob3ZlcnJpZGXDomRzp0RlZmF1bHSkZF9yd8KkZF9zd8KkZF9vbsOjZHNwpE5vbmWkZHNwMtDTo2RfcgCjZF9sAKNtX2QgpXdfbnVtA6V5X29mZgCmZF9tb2RlpEF1dGz113ZjbV9ywqRkc3Ax0NOkd2F5c5cAAAAAAAAApGRzeTHMtKN3X23CpmNyb3VjaN4AHKNkX2QApW1fbWluAKRtX2FyAKRtX2FsAKRyX2R0EaNtb2SmSml0dGVypHJfaXIAo21fYcKlbV9tYXgAo2RzeaROb25lqG92ZXJyaWRlw6Jkc6dEZWZhdWx0pGRfcnfCpGRfc3fDpGRfb27Do2RzcKROb25lpGRzcDLQ06NkX3IAo2RfbACjbV9kHqV3X251bQOleV9vZmYCpmRfbW9kZaRBdXRvo21fcsKkZHNwMdDTpHdheXOXAAAAAAAAAKRkc3kxzLSjd19twqNydW7eAByjZF9kAKVtX21pbuKkbV9hcgCkbV9hbACkcl9kdAOjbW9kpkppdHRlcqRyX2lyAKNtX2HCpW1fbWF4I6Nkc3mkTm9uZahvdmVycmlkZcOiZHOnRGVmYXVsdKRkX3J3wqRkX3N3w6RkX29uw6Nkc3CkTm9uZaRkc3Ay0NOjZF9yAKNkX2wAo21fZACld19udW0DpXlfb2ZmAKZkX21vZGWkQXV0b6NtX3LDpGRzcDHQ06R3YXlzlwAAAAAAAACkZHN5Mcy0o3dfbcKnZGVmYXVsdN4AG6NkX2QApW1fbWlu46RtX2FyAKRtX2FsAKRyX2R0AaNtX2HCpHJfaXIApW1fbWF4HaRkX3N3w6RkX29uw6Jkc6ZDdXN0b22kZF9yd8KkZHN5Mcy0o2RzeaZTd2l0Y2ijZF9sAKNkc3CmU3dpdGNopGRzcDLQp6NkX3IAo21fZB2ld19udW0DpXlfb2ZmAKZkX21vZGWkQXV0b6NtX3LCpGRzcDHQp6R3YXlzlwAAAAAAAACjbW9kpkppdHRlcqN3X23CpHJhZ2WDqHRlbGVwb3J0hKRvbl9okwEAoX6mcGlzdG9swqJvbsKkbGFuZMKoZXhzd2l0Y2iCpWFsbG93kaFz113Zom9uwqhyZXNvbHZlcsJ9",
	badge = pui.format("\v•\r "),
	selected = 0, name = "",
	loaded = nil,
	list = {}
} do
	local context = menu.general.config

	context.save:depend(true, {context.list, 0, true})
	context.export:depend(true, {context.list, 0, true})
	context.delete:depend({context.list, 0, true})
	context.deleteb:depend({context.list, 0})
	context.deleteb:depend(true, {context.list, 0, true})

	--#region: actions

	local actions = {}

	actions.eval = function (raw, noparse)
		if not raw then return "\fConfig not found." end

		local cheat, contents, pad = string.match(raw, "^hysteria::(%a+)::([%w%+%/]+)(_*)")
		if cheat ~= "GS" then return "\fNot for gamesense" end

		pad = pad and string.rep("=", #pad) or ""
		contents = string.gsub(contents, "z%d%d%dZ", { ["z113Z"] = "+", ["z143Z"] = "/", })
		contents = base64.decode(contents..pad)

		local name, author, settings = string.match(contents, "^%((.*)%)%[(.*)%]%{(.+)%}")
		return name, author, (noparse ~= true and settings ~= nil) and msgpack.unpack(settings) or {}
	end

	actions.save = function (name, new)
		if name == "Default" then return "\fCan't overwrite Default" end
		name = tostring(name)

		local o_name, o_author if new == true then
			o_name, o_author = actions.eval(db.configs[name], true)
		end

		local cfg = --[[ new and {} or ]] configs.system:save()
		local contents = string.format("(%s)[%s]{%s}", name, o_author or hysteria.user.name, msgpack.pack(cfg))
		local encoded = string.gsub(base64.encode(contents), "[%+%/%=]", { ["+"] = "z113Z", ["/"] = "z143Z", ["="] = "_" })

		local ready = ("hysteria::GS::%s"):format(encoded)
		db.configs[name] = ready

		return "\a".. name .." saved"
	end

	actions.create = function (name)
		if name == "" then  return "\fEnter the name"
		elseif name == "Default" then  return "\fCan't overwrite Default"
		elseif #name > 24 then  return "\fThis name is too long"
		elseif db.configs[name] then  return "\f" .. name .. " is in the list"  end

		return actions.save(name, true)
	end

	actions.delete = function (name)
		db.configs[name] = nil
	end

	actions.export = function (name)
		if not name or name == "" then return "\fNot selected" end

		clipboard.set(db.configs[name])
		return "\aCopied to clipboard."
	end

	actions.import = function ()
		local copied = clipboard.get()
		if not copied then return "\fEmpty clipboard" end

		local name, author, settings = actions.eval(copied, true)
		if not author then return name end


		local cfg = copied:match("^hysteria::%a+::[%w%+%/]+_*")
		if name == "Default" then return "\fCan't import default config" end
		db.configs[name] = cfg
		return "\a".. name .." by ".. author .." added"
	end

	actions.load = function (name, ...)
		if not name or name == "" then return "ERR: can't load: not selected" end
		local cfg = name == "Default" and configs.default or db.configs[name]

		local cname, cauthor, settings = actions.eval(cfg)
		if not cauthor then return cname end

		if ({...})[1] == "antiaim" then
			settings.antiaim.general.manual = nil
		end

		configs.system:load(settings, ...)
		if ... then return end
		configs.loaded = name
	end

	--#endregion

	local report do
		context.list_report:depend({context.list_report, 0})

		local reportend, active = 0, false
		local function wait ()
			if reportend < globals.realtime() then
				context.list_report:set_visible(false)
				context.selected:set_visible(true)

				callbacks.paint_ui:unset(wait)
				active = false
			end
		end

		report = function (code)
			if not code then return end
			reportend = globals.realtime() + 1

			local text = code:gsub("[\f\a]", {
				["\f"] = "\aFF4040FF",
				["\a"] = "\aB6DE47FF",
			})
			context.list_report:set(text)
			if not active then
				context.list_report:set_visible(true)
				context.selected:set_visible(false)

				callbacks.paint_ui:set(wait)
				active = true
			end
		end
	end

	local update = function (no_reval)
		if no_reval ~= true then
			configs.list = {}
			for k in next, db.configs do configs.list[#configs.list+1] = k end

			table.sort(configs.list)
			table.insert(configs.list, 1, "Default")

			local loaded = table.ifind(configs.list, configs.loaded)
			if loaded then  configs.list[loaded] = configs.badge .. configs.list[loaded]
			else  configs.loaded = 0  end

			context.list:update(configs.list)
		end

		configs.selected = context.list.value + 1
		configs.name = configs.list[configs.selected]:gsub("^\a%x%x%x%x%x%x%x%x•\a%x%x%x%x%x%x%x%x ", "")

		context.selected:set( pui.format("Selected: \v") .. configs.name)
		context.list:set(configs.selected - 1)
	end

	local act = function (action, ...)
		local success, result, code, obj = pcall(actions[action], ...)

		debug(action, ": ", success, ", ", result, ", ", code, ", ", obj)
		report(code or result)
		update()
	end
	update()

	context.list:set_callback(function ()  update(true)  end)
	context.create:set_callback(function ()  act("create", context.name:get())  end)
	context.import:set_callback(function ()  act("import", context.name:get())  end)
	context.load:set_callback(function ()  act("load", configs.name)  end)
	context.loadaa:set_callback(function ()  act("load", configs.name, "antiaim")  end)
	context.save:set_callback(function ()  act("save", configs.name)  end)
	context.delete:set_callback(function ()  act("delete", configs.name)  end)
	context.export:set_callback(function ()  act("export", configs.name)  end)
end

-- #endregion
--


-- #endregion ------------------------------------------------------------------
--








----<  Features  >--------------------------------------------------------------

--------------------------------------------------------------------------------
-- #region :: Anti-aim


--
-- #region : Definitions

antiaim.my = {
	switch = false, side = 0,
	state = "default",
}

antiaim.refs = {
	pitch = refs.aa.angles.pitch[2],
	base = refs.aa.angles.base,
	offset = refs.aa.angles.yaw[2],
	body = refs.aa.angles.body[2],
	pitch_mode = refs.aa.angles.pitch[1],
	yaw = refs.aa.angles.yaw[1],
	jitter = refs.aa.angles.jitter[1],
	jitter_deg = refs.aa.angles.jitter[2],
	body_yaw = refs.aa.angles.body[1],
}

antiaim.data, antiaim.latest = {
	way = 1, lifetime = 0, using = false,
	manual = nil,
}, {}

-- #endregion
--

--
-- #region : System

-- #region - Features

antiaim.features = {
	manual = {
		current = nil,
		buttons = {
			{ "left", yaw = -90, item = vars.antiaim.general.manual.left },
			{ "right", yaw = 90, item = vars.antiaim.general.manual.right },
			{ "reset", yaw = nil, item = vars.antiaim.general.manual.reset },
			-- { "edge", yaw = 0, item = vars.antiaim.general.manual.edge },
			-- { "fs", yaw = 0, item = vars.antiaim.general.manual.fs },
		},
		work = function (self)
			if not vars.antiaim.general.manual.on.value then return end

			for i, v in ipairs(self.buttons) do
				local active, mode = v.item:get()

				if v.active == nil then v.active = active end
				if v.active == active then goto done end

				v.active = active

				if v.yaw == nil then self.current = nil end

				if mode == 1 then self.current = active and i or nil goto done
				elseif mode == 2 then self.current = self.current ~= i and i or nil goto done end

				::done::
			end

			local result = self.current ~= nil and self.buttons[self.current].yaw or nil
			antiaim.data.manual = result

			local is_fs, is_edge = vars.antiaim.general.manual.fs:get(), vars.antiaim.general.manual.edge:get()

			refs.aa.angles.edge:override(is_edge)
			refs.aa.angles.freestand:override(is_fs and not is_edge and not result)

			return type(result) == "number" and result or nil
		end
	},
	stab = {
		work = function (self)
			antiaim.data.backstab = false
			if vars.antiaim.general.stab.value and my.threat and my.entity then
				local threat_hitbox = entity.hitbox_position(my.threat, 3)
				if not threat_hitbox then return end

				local distance = my.origin:dist( vector(entity.get_prop(my.threat, "m_vecOrigin")) )
				local weapon_t = weapondata(entity.get_player_weapon(my.threat))

				if distance < 256 and (weapon_t and weapon_t.type == "knife") then antiaim.data.backstab = true return {180, -89} end
			end
		end
	},
	on_use = {
		defuse = false,
		overridden = false,
		next = 0,
		work = function (self, cmd)
			if not vars.antiaim.general.use.value or not my.weapon then return end
			local using = cmd.in_use == 1

			local in_bombzone, is_ct = entity.get_prop(my.entity, "m_bInBombZone") == 1, entity.get_prop(my.entity, "m_iTeamNum") == 3

			if in_bombzone or is_ct then
				local bombs = entity.get_all("CPlantedC4")
				if #bombs > 0 then
					local c4 = bombs[#bombs]

					local c4_origin = vector(entity.get_prop(c4, "m_vecOrigin"))
					local dist = my.origin:dist(c4_origin)

					if dist < 61 then self.defuse = true end
				end
			end

			if entity.get_prop(my.entity, "m_bIsDefusing") == 1 or entity.get_prop(my.entity, "m_bIsGrabbingHostage") == 1 then
				self.defuse = true
			end
			local block = self.defuse or (entity.get_prop(my.weapon, "m_iItemDefinitionIndex") == 49 and in_bombzone)

			if using then
				if not self.overridden then
					self.next, self.overridden = globals.tickcount() + 1, true
				end

				if globals.tickcount() >= self.next and not block then
					cmd.in_use = 0
				end
			else
				self.overridden, self.defuse = false, false
			end

			local cam_y = client.camera_angles()
			return (not block and using) and {180, cam_y} or nil
		end
	},
	snap = {
		dechoke = false,
		check = function (cmd, settings, props)
			if props and props.on == "Default" then
				props = antiaim.data.scenery.default.snap
			end

			if not (settings.on.value and settings.on.hotkey:get()) or props.on == "Off" or antiaim.data.useaa or antiaim.data.backstab or adata.get_double_tap() then return false end
			if not my.exploit.active or not (my.exploit.defensive or my.exploit.lagpeek) or (my.exploit.active == 1 and not settings.os.value) then return false end


			if settings.lp.value and my.threat then
				local resource = entity.get_player_resource(my.threat)
				if not resource then return false end

				local ping = entity.get_prop(resource, "m_iPing", my.threat)
				if not ping or (ping < 15 or ping > 90) then return false end
			end

			return true, props
		end,
		yaw = {
			["None"] = function () return 0, true end,
			["Switch"] = function (props)
				return .5 * (antiaim.my.switch and props.yaw_min or -props.yaw_min)
			end,
			["Static"] = function (props)
				return props.yaw_min
			end,
			["Random"] = function (props)
				return .5 * math.random(-props.yaw_min, props.yaw_min)
			end,
			["Spin"] = function (props)
				return .5 * math.lerp(-props.yaw_min, props.yaw_min, globals.curtime() * 3 % 2 - 1)
			end,
			["азазой"] = function (props)
				return .5 * math.lerp(-props.yaw_min, props.yaw_min, math.sin(globals.curtime() * 3 % 1))
			end,
		},
		pitch = {
			["None"] = function () return 89 end,
			["Switch"] = function (props)
				return antiaim.data.lifetime % 2 == 0 and props.pitch_max or props.pitch_min
			end,
			["Random"] = function (props)
				return math.random(props.pitch_min, props.pitch_max)
			end,
			["Spin"] = function (props)
				return math.lerp(props.pitch_min, props.pitch_max, globals.curtime() * 6 % 2 - 1)
			end,
		},
		work = function (self, cmd, ctx)
			local settings, props = vars.antiaim.exploits.snap or {}, nil
			antiaim.latest.snapping, props = self.check(cmd, settings, antiaim.data.preset.snap)

			if not antiaim.latest.snapping then return end

			--
			local yaw, dmf = self.yaw[props.yaw](props)
			local pitch = self.pitch[props.pitch](props)

			antiaim.latest.force_send = true
			ctx.offset = math.normalize_yaw(yaw + (dmf and ctx.offset or 0))
			ctx.pitch = math.normalize_pitch(pitch)
			if not dmf then
				-- ctx.body = 0
			end
			-- cmd.yaw = math.normalize_yaw(yaw + (dmf and ctx.offset or 0))
			-- cmd.pitch = math.normalize_pitch(pitch)
		end
	},
	restrict = {
		ventured = 1,
		modes = {
			[15] = function ()
				return antiaim.data.lifetime % client.random_int(1, 4) == 0
			end,
			[16] = function ()
				return antiaim.data.lifetime % client.random_int(2, 6) == 0
			end,
			[17] = function ()
				return antiaim.data.lifetime % antiaim.features.restrict.ventured == 0
			end,
		},
		work = a(function (self, cmd, scene)
			if scene.adv.delay == 1 or not my.exploit.active then return true end

			if self.modes[scene.adv.delay] then
				return self.modes[scene.adv.delay]()
			else
				return antiaim.data.lifetime % scene.adv.delay == 0
			end
		end)
	},
	fakelag = {
		overridden = false,
		work = a(function (self, cmd)
			local rctx, hctx = refs.aa.fakelag, vars.antiaim.lag.fakelag

			if antiaim.features.snap.dechoke then
				self.overridden = true
				rctx.enable:override(false)
				cmd.no_choke = true
				antiaim.latest.force_send = true
				antiaim.features.snap.dechoke = false
				debug "dechoke"
			return end

			if hctx.on.value then self.overridden = true end

			if not self.overridden then return end

			if hctx.on.value then
				rctx.enable:override(true)
				rctx.amount:override(hctx.mode.value)
				rctx.limit:override(hctx.limit.value)
			else
				rctx.enable:override()
				rctx.amount:override()
				rctx.limit:override()
				self.overridden = false
			end
		end)
	},
	head = {
		work = a(function (self, ctx)
			if antiaim.data.manual or antiaim.data.useaa or not my.threat or entity.is_dormant(my.threat) then return end

			--
			local weapon_t = weapondata(my.weapon)
			local threat_origin = vector(entity.get_origin(my.threat))
			local distance = my.origin:dist(threat_origin)
			local height_diff = my.origin.z - threat_origin.z

			local ex, ey, ez = client.eye_position()
			local trace_fr, trace_ent = client.trace_line(my.entity, ex, ey, ez, threat_origin.x, threat_origin.y, threat_origin.z + 56)
			local is_visible = trace_ent == my.threat
			local is_melee = weapon_t and weapon_t.weapon_type_int == 0

			--
			local triggers = vars.antiaim.general.head
			if (triggers:get "Air melee" and my.jumping and is_melee and height_diff > -32)
			or (triggers:get "Height difference" and height_diff > 64 and (is_visible or distance < 1024)) then
				ctx.offset, ctx.body, ctx.pitch = 20, 1, 89
			end
		end)
	},
	vulnlc = {
		check = a(function (self, cmd)
			if not my.exploit.active then return end

			local settings = vars.antiaim.exploits.vulnlc
			if not (#settings.value > 0 and my.weapon ~= nil) then return false end

			if settings:get("Can't shoot") then
				local next_attack = entity.get_prop(my.entity, "m_flNextAttack") or 0
				local next_shot = entity.get_prop(my.weapon, "m_flNextPrimaryAttack") or 0
				local simtime = entity.get_prop(my.entity, "m_flSimulationTime")

				local attack_diff, shot_diff = toticks(next_attack - simtime - 1), toticks(next_shot - simtime - 1)

				local weapon_t = weapondata(my.weapon)
				local condition = (weapon_t and weapon_t.weapon_type_int ~= 9) and (cmd.quick_stop or attack_diff > 0 or shot_diff > 0)

				if condition then return true end
			end

			local state_perm =
			(my.jumping and settings:get("Jumping")) or
			((my.crouching and my.on_ground) and settings:get("Crouching"))
			-- (my.walking and settings:get("Walking"))

			if not state_perm then return false end

			return true
		end),
		work = a(function (self, cmd)
			if self:check(cmd) then
				cmd.force_defensive = true
			end
		end)
	},
	rubber = {
		work = function ()

		end
	}
}

-- #endregion

-- #region - Venture

antiaim.venture = {
	latest = 0, damaged = 0,
	trigger = function (event)
		if not my.valid or antiaim.venture.latest == globals.tickcount() then return end

		local attacker = client.userid_to_entindex(event.userid)
		if not attacker or not entity.is_enemy(attacker) or entity.is_dormant(attacker) then return end

		--
		local impact = vector(event.x, event.y, event.z)
		local enemy_view = vector(entity.get_origin(attacker))
		enemy_view.z = enemy_view.z + 64

		local dists = {}
		for i = 1, #players do
			local v = players[i]

			if not entity.is_enemy(v) then
				local head = vector(entity.hitbox_position(v, 0))
				local point = math.closest_ray_point(head, enemy_view, impact)
				dists[#dists+1] = head:dist(point)
				if v == my.entity then dists.mine = dists[#dists] end
			end
		end

		local closest = math.min( unpack(dists) )

		--
		if (dists.mine and closest) and dists.mine < 40 or (closest == dists.mine and dists.mine < 128) then
			client.delay_call(totime(1), function ()
				client.fire_event("hysteria::enemy_shot", {
					damaged = antiaim.venture.latest == antiaim.venture.damaged,
					dist = dists.mine,
					attacker = attacker,
					userid = event.userid
				})
			end)

			antiaim.venture.latest = globals.tickcount()
			antiaim.features.restrict.ventured = math.random(1, 4)
		end
	end,
	run = function (self)
		callbacks.bullet_impact:set(self.trigger)
		callbacks.player_hurt:set(function (event)
			if client.userid_to_entindex(event.userid) == my.entity then self.damaged = globals.tickcount() end
		end)
	end
}

antiaim.venture:run()

-- #endregion

-- #region - Builder

antiaim.builder = {
	yaw = function (self, cmd, scene)
		local use = antiaim.data.useaa					if use then return use[1], use[2], "Local view", {} end
		local stab = antiaim.features.stab:work()		if stab then return stab[1], stab[2], nil, {} end
		local manual = antiaim.features.manual:work()	if manual then return manual, nil, "Local view", {s = true} end

		return scene.yaw.offset, 89, nil, {}
	end,
	modifier = function (self, scene)
		if antiaim.data.static then return 0 end
		local side, value = 1, 0

		--
		local modifier, degree, range, eachway = scene.mod.type, scene.mod.degree, scene.mod.range, scene.ways.manual
		local random = client.random_int(-scene.adv.irreg * 0.5, scene.adv.irreg * 0.5)

		local min, max = (range and scene.mod.min or -degree), (range and scene.mod.max or degree)
		local addition = scene.mod.add and ((antiaim.my.side == 1 and scene.mod.right) or (antiaim.my.side == -1 and scene.mod.left)) or 0

		--
		if 	   modifier == "Jitter" then	value = (antiaim.my.switch and min or max) * side
		elseif modifier == "Random" then	value = math.random(min, max)
		elseif modifier == "Rotate" then	value = math.lerp(max, min, (globals.tickcount() * side) % 5 / 5)
		elseif modifier == "пердельта" then
			value = math.lerp(max, min, math.sin(globals.curtime() * 5 % 1))
		elseif modifier == "X-way" then
			-- if antiaim.my.side ~= 0 and not scene.mod.ws and scene.body.jitter and (antiaim.data.way % 2 == 0) ~= (antiaim.my.side == 1) then
			-- 	antiaim.data.way = antiaim.data.way - 1
			-- end

			antiaim.data.way = antiaim.data.way < (scene.ways.total - 1) and (antiaim.data.way + 1) or 0

			if eachway then
				value = scene.way[antiaim.data.way+1]
			else
				local step = (antiaim.data.way) / (scene.ways.total - 1)
				value = math.lerp(min, max, step)
			end
		end


		--
		return value + addition + random
	end,
	body = function (self, scene, modifier)
		if not scene.body.on then return end
		if vars.antiaim.general.warmup.value and entity.get_prop(my.game_rules, "m_bWarmupPeriod") == 1 then return end

		local side, left, right = 0, 0, 0
		local should_relate = scene.mod.type == "X-way" and scene.body.relative
		-- local desync = math.normalize_yaw(adata.get_abs_yaw() - adata.get_body_yaw(1))

		if scene.body.mode == "Default" then
			left, right = scene.body.degree, scene.body.degree
		elseif scene.body.mode == "Side-based" then
			left, right = scene.body.left, scene.body.right
		elseif scene.body.mode == "Auto" then
			if should_relate then
				left, right = 0, 0
				goto processed
			end
			local overlap = adata.get_overlap(true)

			local cur, old = entity.get_simtime(my.entity)
			local fl = (cur and old) and toticks(cur - old) - 1 or 1

			local max = overlap * (fl < 2 and 30 or 60)

			left, right = modifier * math.gratio - max, modifier * math.gratio + max
		end

		::processed::

		--
		if should_relate then
			side = math.clamp(modifier, -1, 1)
		else
			side = ternary(scene.body.jitter, antiaim.my.switch, vars.antiaim.general.inverter:get()) and 1 or -1
		end

		if antiaim.data.static then side = 1 end

		--
		local result = (side == 0 and 0) or (side > 0 and left) or (side < 0 and right)
		antiaim.my.side = (result == 0 and (antiaim.my.switch and 1 or -1)) or (result > 0 and 1) or (result < 0 and -1)

		return result
	end,
	work = function (self, cmd, scene, ctx)
		local yaw, pitch, base, flags = self:yaw(cmd, scene)
		antiaim.data.static = flags.s and vars.antiaim.general.manual.st.value
		local modifier = self:modifier(scene)
		local body = self:body(scene, modifier)

		--
		ctx.pitch_mode = "Custom"
		ctx.pitch = pitch or 89

		ctx.base = base or ctx.base
		ctx.offset = math.normalize_yaw(yaw + modifier)

		ctx.body_yaw = body and "Static" or "Off"
		if body then
			ctx.body = math.clamp(body, -180, 180)
		end
	end
}

-- #endregion

-- #endregion
--

--
-- #region : Setup

-- #region - Main

antiaim.arrange = a(function ()
	local state = my.state
	local preset

	local is_custom = true

	if is_custom then
		preset = antiaim.presets.custom
	end

	state = preset[ antiaim.states[ state ][1] ].override and state or enums.states.default

	if (my.crouching and my.on_ground and my.velocity > 5) and preset.sneak.override then
		state = enums.states.sneak
	elseif (my.jumping and my.crouching) and preset.airduck.override then
		state = enums.states.airduck
	end


	antiaim.my.state = antiaim.states[ state ][1]
	antiaim.data.scenery = preset
	antiaim.data.preset = preset[antiaim.my.state]

	if is_custom and not pui.menu_open then
		local selected = vars.antiaim.builder.state.value
		local current = antiaim.states[state][2]
		if selected ~= current then
			-- vars.antiaim.builder.state:set(current)
		end
	end

	local ctx = {
		pitch = -89,
		base = vars.antiaim.general.yaw.value,
		pitch_mode = nil,
		yaw = "180",
		offset = nil,
		jitter = "Off",
		jitter_deg = nil,
		body_yaw = nil,
		body = nil,
	}

	return antiaim.data.preset, ctx
end)

antiaim.dispatch = a(function (data)
	for k, v in next, antiaim.refs do
		v:override(data[k])
	end
end)

antiaim.manage = a(function (cmd)
	table.clear(antiaim.latest)
	local scene, ctx = antiaim.arrange()

	--
	antiaim.builder:work(cmd, scene, ctx)

	--
	antiaim.data.useaa = antiaim.features.on_use:work(cmd)
	antiaim.features.vulnlc:work(cmd)
	antiaim.features.fakelag:work(cmd)
	if not (antiaim.data.manual or antiaim.data.useaa) then
		antiaim.features.snap:work(cmd, ctx)
		antiaim.features.head:work(ctx)
	end

	--
	if cmd.chokedcommands == 0 or antiaim.latest.force_send then
		antiaim.dispatch(ctx)
		if cmd.chokedcommands == 0 then
			antiaim.data.lifetime = antiaim.data.lifetime + 1
			if antiaim.features.restrict:work(cmd, scene) then
				antiaim.my.switch = not antiaim.my.switch
			end
		end
	end

	--
	antiaim.data.defensive = cmd.force_defensive
end)

-- #endregion

-- #region - Finish

antiaim.run = a(function ()
	local dechoke = function ()
		local fd, dt, os = refs.rage.other.duck:get(), refs.rage.aimbot.double_tap[1].value and refs.rage.aimbot.double_tap[1].hotkey:get(), refs.aa.other.onshot.value and refs.aa.other.onshot.hotkey:get()
		if antiaim.latest.snapping and (fd or not (dt or os)) and not antiaim.features.snap.dechoke then
			antiaim.features.snap.dechoke = true
			refs.aa.fakelag.enable:override(false)
		end
	end

	vars.antiaim.global:set_callback(function (this)
		callbacks.setup_command(this.value, antiaim.manage)
		callbacks.pre_render(this.value, dechoke)

		refs.aa.angles.enable:override(this.value or nil)
		refs.aa.angles.freestand:override(ternary(this.value, false, nil))
		refs.aa.angles.fs_body:override(ternary(this.value, false, nil))
		refs.aa.angles.freestand.hotkey:override(this.value and {"Always on", 0} or nil)

		if not this.value then
			antiaim.revert()
		end
	end, true)

	defer(antiaim.revert)
end)

antiaim.revert = function ()
	for k, v in pairs(antiaim.refs) do v:override() end
	antiaim.data.manual = nil
	refs.aa.angles.enable:override()
	refs.aa.angles.freestand:override()
	refs.aa.angles.freestand.hotkey:override()
end

do
	vars.antiaim.general.manual.on:set_callback(function (this)
		if not this.value then
			antiaim.data.manual = nil
			refs.aa.angles.edge:override()
			refs.aa.angles.freestand:override()
		end
	end)
end

-- #endregion

antiaim.run()

-- #endregion
--


-- #endregion ------------------------------------------------------------------
--



--------------------------------------------------------------------------------
-- #region :: Features


--
-- #region : Misc

-- #region - Features

misc.clantag = {
	enabled = false,
	last = 0,
	list = {
		"_⠀⠀ ⠀ ⠀",
		"8_⠀⠀⠀ ⠀ ",
		"h4_⠀ ⠀ ⠀ ",
		"hy2_ ⠀⠀⠀",
		"hys7_ ⠀⠀ ",
		"hyst3_⠀⠀",
		"hyste9_⠀ ",
		"hyster1_⠀",
		"hysteri4_ ",

		"hysteria⠀",
		"hysteria_ ",
		"hysteria⠀",
		"hysteria_ ",
		"hysteria⠀",
		"hysteria_ ",
		"hysteria⠀",
		"hysteria_ ",
		"hysteria⠀",
		"hysteria_ ",
		"hysteria⠀",

		"⠀_4steria ",
		"⠀⠀_2teria",
		"⠀⠀ _7eria",
		"⠀⠀⠀_3ria",
		"⠀⠀ ⠀ _9ia",
		"⠀⠀⠀⠀_1a",
		"⠀ ⠀ ⠀ _4",
		"⠀ ⠀ ⠀ ⠀ ",
	},
	work = a(function ()
		if misc.clantag.enabled and not vars.misc.clantag.value then
			misc.clantag.enabled = false
			callbacks.net_update_end:unset(misc.clantag.work)
			client.set_clan_tag()
		end

		local time = math.floor( globals.curtime() * 4 + 0.5 )
		local i = time % #misc.clantag.list + 1

		if i == misc.clantag.last then return end
		misc.clantag.last = i

		client.set_clan_tag(misc.clantag.list[i])
	end),
	run = a(function (self)
		vars.misc.clantag:set_callback(function (this)
			refs.misc.clantag:set_enabled(not this.value)

			if this.value then
				self.enabled = true
				callbacks.net_update_end:set(self.work)
				refs.misc.clantag:override(false)
			else
				refs.misc.clantag:override()
				client.set_clan_tag()
			end
		end, true)
		defer(function ()
			refs.misc.clantag:set_enabled(true)
			refs.misc.clantag:override()
			client.set_clan_tag()
		end)
	end)
}

misc.ladder = {
	work = a(function (cmd)
		if entity.get_prop(my.entity, "m_MoveType") ~= 9 or cmd.forwardmove == 0 then return end

		local camera_pitch, camera_yaw = client.camera_angles()
		local descending = cmd.forwardmove < 0 or camera_pitch > 45

		cmd.in_moveleft, cmd.in_moveright = descending and 1 or 0, not descending and 1 or 0
		cmd.in_forward, cmd.in_back = descending and 1 or 0, not descending and 1 or 0

		cmd.pitch, cmd.yaw = 89, math.normalize_yaw(cmd.yaw + 90)
	end),
	run = a(function (self)
		vars.misc.ladder:set_callback(function (this)
			callbacks.setup_command(this.value, self.work)
		end, true)
	end)
}

misc.marker = {
	duration = 2,
	list = {},

	marker = a(function (shot, progress, ascend)
		local x, y = renderer.world_to_screen(shot.x, shot.y, shot.z)
		if x and y then
			x, y = x / DPI, y / DPI

			if ascend then
				local phantom = 32 * progress
				render.circle(x, y, colors.accent:alphen(1 - progress, true), phantom)
			end
			render.texture(textures.mini_bfly, x - 5, y - 5, 9, 9, colors.accent)
		end
	end),
	work = a(function ()
		local self = misc.marker
		for i, v in ipairs(self.list) do
			local ascend = v.time > globals.realtime()
			local progress = anima.condition(v.progress, ascend, {3, -4}, { {1, 4}, {3, 4} })

			render.push_alpha(progress)
			self.marker(v, progress, ascend)
			render.pop_alpha()

			if not ascend and progress == 0 then
				table.remove(self.list, i)
			end
		end
	end),
	append = {
		temp = {},
		a(function (shot)
			local self = misc.marker
			self.append.temp[shot.id] = {
				x = shot.x, y = shot.y, z = shot.z
			}
		end),
		a(function (shot)
			local self = misc.marker
			local temp = self.append.temp[shot.id]

			table.insert(self.list, 1, {
				x = temp.x, y = temp.y, z = temp.z,
				time = globals.realtime() + self.duration,
				progress = {0},
			})

			self.append.temp[shot.id] = nil
		end),
		a(function (shot)
			misc.marker.append.temp[shot.id] = nil
		end),
	},
	run = a(function (self)
		local ctx = vars.visuals.marker
		ctx:set_event("aim_fire", self.append[1])
		ctx:set_event("aim_hit", self.append[2])
		ctx:set_event("aim_miss", self.append[3])
		ctx:set_event("paint", self.work)
	end)
}

misc.breaker = {
	work = a(function ()
		if not my.valid then return end
		local animstate = entity.get_animstate(my.entity)
		if not animstate then return end


		local ctx = vars.misc.breaker

		if ctx.pitch.value and (not my.jumping and animstate.hit_in_ground_animation) then
			entity.set_prop(my.entity, "m_flPoseParameter", .5, 12)
		end

		if ctx.slia.value and my.jumping then
			entity.set_prop(my.entity, "m_flPoseParameter", 1, 6)
		end

		if ctx.legs.value == "Static" then
			refs.aa.other.legs:override("Always slide")
			entity.set_prop(my.entity, "m_flPoseParameter", 0, 0)
		elseif ctx.legs.value == "Jitter" then
			refs.aa.other.legs:override("Always slide")
			if globals.tickcount() % 4 > 1 then
				entity.set_prop(my.entity, "m_flPoseParameter", 0, 0)
			end
		elseif ctx.legs.value == "No step back" then
			refs.aa.other.legs:override("Never slide")
			entity.set_prop(my.entity, "m_flPoseParameter", 0.5, 7)
		else refs.aa.other.legs:override() end
	end),
	run = a(function (self)
		vars.misc.breaker.on:set_callback(function (this)
			callbacks.pre_render(this.value, self.work)
			if not this.value then refs.aa.other.legs:override() end
		end, true)
	end)
}

misc.aspect = {
	active = false,
	value = sw / sh,
	init = sw / sh,
	activate = function ()
		misc.aspect.active = true
	end,
	work = function ()
		local self, ctx = misc.aspect, vars.misc.aspect
		if not self.active then return end

		if ctx.on.value then
			local target = ctx.ratio.value * .01
			self.value = anima.lerp(self.value, target, 8, .001)
			self.active = target ~= self.value
			cvar.r_aspectratio:set_float(self.value)
		else
			self.value = anima.lerp(self.value, self.init)
			cvar.r_aspectratio:set_float(self.value)

			if self.value == self.init then
				callbacks.paint_ui:unset(self.work)
				cvar.r_aspectratio:set_float(0)
				self.active = false
			end
		end
	end,
	run = function (self)
		local ctx = vars.misc.aspect

		ctx.on:set_callback(function (this)
			self.active = true
			if this.value then callbacks.paint_ui:set(self.work) end
		end, true)
		ctx.ratio:set_callback(self.activate, true)

		defer(function () cvar.r_aspectratio:set_float(0) end)
	end
}

misc.filter = {
	callback = function (this)
		cvar.con_filter_enable:set_int(this.value and 1 or 0)
		cvar.con_filter_text:set_string(this.value and "hysteria" or "")
	end,
	run = function (self)
		vars.misc.filter:set_callback(self.callback, true)
	end
}

for k, v in pairs(misc) do v:run() end

-- #endregion

-- #region - Logger

local logger = {
	data = {
		fear = 0,
	},
	list = {},
	stack = {},
	generic_weapons = {"knife", "c4", "decoy", "flashbang", "hegrenade", "incgrenade", "molotov", "inferno", "smokegrenade"},
	colors = {
		["fear"]		= {"\a000000", "\a000000\x01", "\x01", color.hex("000000")},
		["mismatch"]	= {"\aD59A4D", "\aD59A4D\x01", "\x07", color.hex("D59A4D")},
		["hit"]			= {"\aA3D350", "\aA3D350\x01", "\x06", color.hex("A3D350")},
		["miss"]		= {"\aA67CCF", "\aA67CCF\x01", "\x03", color.hex("A67CCF")},
		["harm"]		= {"\ad35050", "\ad35050\x01", "\x07", color.hex("d35050")},
		["brute"]		= {"\aBFBFBF", "\aBFBFBF\x01", "\x01", color.hex("BFBFBF")},
		["evaded"]		= {"\aB0C6FF", "\aB0C6FF\x01", "\x01", color.hex("AB0C6F")},
	},
}

--#region: events

logger.events = {
	fear = function (chance, delay)
		if math.random() < chance and globals.realtime() - logger.data.fear > 240 then
			client.delay_call(delay or 7, function ()
				logger.invent("fear", {
					{"You are ", {"afraid"}},
				})
			end)
			logger.data.fear = globals.realtime()
		end
	end,
	evade = function (event)
		if event.damaged or not vars.misc.logs.events:get("Anti-aim info") then return end

		logger.invent("evaded", {
			{"Evaded ", {entity.get_player_name(event.attacker)}, "'s shot"}
		}, {
			{"d: ", {math.round(event.dist)}}
		})
	end,

	--
	receive = function (event, target, attacker)
		local self_harm, is_fatal = target == attacker or attacker == 0, event.health == 0
		local weapon, damage, hitbox = event.weapon, event.dmg_health, enums.hitgroups[(event.hitgroup or 0) + 1] or "generic"
		local result = is_fatal and "Killed by" or "Harmed by"

		attacker = attacker ~= 0 and entity.get_player_name(attacker) or "world"

		local main = {
			self_harm and {{"You"}, is_fatal and " killed " or " harmed "} or {result, " "},
			{true, self_harm and {"yourself"} or {attacker}},
			{false, self_harm and {"yourself"} or {attacker}},

			(not self_harm and hitbox ~= "generic") and {" in ", {hitbox}} or nil,
			-- #weapon > 0 and {" with ", {weapon}} or nil,
			not is_fatal and {" for ", {damage, " hp"}} or nil
		}

		logger.invent("harm", main)
		if not is_fatal then
			logger.events.fear(0.03, 9)
		end
	end,
	harm = function (event, target, attacker)
		if not table.ifind(logger.generic_weapons, event.weapon) and event.weapon ~= "knife" then return end
		local is_fatal = event.health == 0

		local weapon = "a ".. event.weapon
		if event.weapon == "hegrenade" then  weapon = "an HE grenade"  end

		local name = entity.get_player_name(target)

		local result = is_fatal and "Killed" or "Harmed"
		if is_fatal and event.weapon == "hegrenade" then  result = "Exploded"
		elseif is_fatal and event.weapon == "knife" then  result = "Stabbed"
		elseif event.weapon == "inferno" then  result = "Burnt"  end

		local main = {
			{result, " "},
			{true, {name}},
			{false, {name}},
			not is_fatal and {" for ", {event.dmg_health, " hp"}} or nil,
			is_fatal and result == "Burnt" and {" to ", {"death"}} or nil,
			(result == "Killed" or result == "Harmed") and {true, " with ", {weapon}} or nil
		}

		logger.invent("hit", main)
	end,
	damage = function (event)
		local target, attacker = client.userid_to_entindex(event.userid), event.attacker ~= 0 and client.userid_to_entindex(event.attacker) or 0

		if target == my.entity and vars.misc.logs.events:get("Getting harmed") then
			logger.events.receive(event, target, attacker)
		elseif attacker == my.entity and target ~= my.entity and vars.misc.logs.events:get("Harming enemies") then
			logger.events.harm(event, target, attacker)
		end
	end,

	--
	miss = function (shot)
		if not vars.misc.logs.events:get("Ragebot shots") then return end
		local pre = logger.stack[shot.id] or {}
		--

		local result = "Missed"
		local target = entity.get_player_name(shot.target)

		local reason = shot.reason
		if reason == "prediction error" and pre.difference and pre.difference > 2 then
			reason = "unpredicted occasion"
		end

		local hitgroup = enums.hitgroups[shot.hitgroup + 1]

		--
		local main, add = {
			{result, " "},
			{true, {target}},
			{false, {target}},
			hitgroup and {"'s ", {hitgroup}},
			reason ~= "?" and {" due to ", {reason}} or nil
		}, {
			pre.damage and {"dmg: ", {pre.damage}},
			{"hc: ", {math.round(shot.hit_chance), "%%"}, (refs.rage.aimbot.hit_chance.value - shot.hit_chance > 3) and "⮟" or ""} or nil,
			pre.difference and pre.difference ~= 0 and {"Δ: ", {pre.difference, "t"}, pre.difference < 0 and "⮟" or ""} or nil,
			pre.teleport and { {"LC"} } or nil,
			(pre.interpolated or pre.extrapolated) and { {pre.interpolated and "IN" or "", pre.extrapolated and "EP" or ""} } or nil,
		}

		logger.invent("miss", main, add)
		logger.stack[shot.id] = nil
	end,
	hit = function (shot)
		if not vars.misc.logs.events:get("Ragebot shots") then return end
		local pre = logger.stack[shot.id] or {}
		--

		local result = "Hit"
		if not entity.is_alive(shot.target) then
			result = "Killed"
		end

		local target = entity.get_player_name(shot.target)
		local hitgroup, exp_hitgroup = enums.hitgroups[shot.hitgroup + 1], enums.hitgroups[(pre.hitgroup or 0) + 1]

		local dmg_mismatch, hg_mismatch = result == "Hit" and shot.hitgroup ~= pre.hitgroup, result == "Hit" and (pre.damage or 0) - (shot.damage or 0) > 10
		-- dmg_mismatch, hg_mismatch = true, true

		local expected if dmg_mismatch and hg_mismatch and exp_hitgroup then
			expected = {exp_hitgroup, "-", pre.damage}
		elseif dmg_mismatch then expected = {pre.damage, " hp"} end

		--
		local main, add = {
			{result, " ", {target}},
			(hitgroup and hitgroup ~= "generic") and { result == "Hit" and "'s " or " in ", {hitgroup}, hg_mismatch and "\aD59A4D!\r" or "" } or nil,
			result == "Hit" and {" for ", {shot.damage, " hp"}, dmg_mismatch and "\aD59A4D!\r" or "" } or nil
		}, {
			expected and {"exp: ", expected},
			pre.difference ~= 0 and {"Δ: ", {pre.difference, "t"}} or nil,
			(refs.rage.aimbot.hit_chance.value - shot.hit_chance > 5) and {"hc: ", {math.floor(shot.hit_chance), "%%"}, "⮟"} or nil,
		}

		--
		logger.invent("hit", main, add)
		logger.stack[shot.id] = nil
	end,
	aim = function (shot)
		if not vars.misc.logs.events:get("Ragebot shots") then return end

		shot.difference = globals.tickcount() - shot.tick
		logger.stack[shot.id] = shot
	end,
}

--#endregion

--#region: main

logger.invent = function (event, main, add)
	local log = { console = {}, screen = {}, chat = {} }

	if event then
		local lc, ls = 0, 0
		local col = logger.colors[event]
		log.console[lc+1], log.console[lc+2] = col and col[1] or "", "•\r "
		log.screen[ls+1], log.screen[ls+2] = col and col[2] or "", "•\aE6E6E6\x02 "
	end

	for i = 1, table.maxn(main) do
		local item = main[i]
		if not item then goto continue end

		if type(item) == "table" then
			local exclude = (main[i][1] == true and 1) or (main[i][1] == false and 2) or 0;
			for j, v in ipairs(item) do
				local kind = type(v)

				if not ( kind == "boolean" and j == 1 ) then
					if exclude ~= 2 then
						if kind == "table" then
							table.move(v, 1, #v, #log.console + 1, log.console)
							table.move(v, 1, #v, #log.chat + 1, log.chat)
						else
							local lc, lh = #log.console, #log.chat
							log.console[lc+1], log.console[lc+2], log.console[lc+3] = "\a909090", kind == "string" and v or tostring(v), "\r"
							log.chat[lh+1], log.chat[lh+2], log.chat[lh+3] = "\x08", kind == "string" and string.gsub(v, "\a%x%x%x%x%x%x", "") or tostring(v), "\x01"
						end
					end
					if exclude ~= 1 then
						if kind == "table" then
							local ls = #log.screen
							for ii = 1, #v, 3 do
								log.screen[ls+ii], log.screen[ls+ii+1], log.screen[ls+ii+2] = "\aE6E6E6\x01", v[ii], "\aE6E6E6\x02"
							end
						else
							local ls = #log.screen
							log.screen[ls+1], log.screen[ls+2] = kind == "string" and string.gsub(v, "\a%x%x%x%x%x%x", function (raw)
								return raw .. "\x01"
							end) or tostring(v), "\aE6E6E6\x02"
						end
					end
				end
			end
		else
			local lc = #log.console
			log.console[lc+1], log.console[lc+2], log.console[lc+3] = "\a808080", tostring(item), "\r"

			log.screen[#log.screen+1] = type(item) == "string" and string.gsub(item, "\a%x%x%x%x%x%x", function (raw)
				return raw .. "\x02"
			end) or tostring(item)
		end

		::continue::
	end

	add = type(add) == "table" and table.filter(add) or nil
	if add and #add > 0 then
		log.console[#log.console+1] = "  \v~\r  "

		for i = 1, #add do
			if type(add[i]) == "table" then
				for _, v in ipairs(add[i]) do
					local kind = type(v)
					if kind == "table" then
						log.console[#log.console+1] = "\aAAAAAA"
						table.move(v, 1, #v, #log.console + 1, log.console)
					else
						local l = #log.console
						log.console[l+1], log.console[l+2] = "\a707070", kind == "string" and v or tostring(v)
					end
					log.console[#log.console+1] = "\r"
				end
			else
				local lc = #log.console
				log.console[lc+1], log.console[lc+2], log.console[lc+3] = "\a707070", tostring(main[i]), "\r"
			end
			if i < #add then  log.console[#log.console+1] = "\a707070, \r"  end
		end
	end

	logger.push(event, table.concat(log.console), table.concat(log.screen), table.concat(log.chat))
end

logger.push = function (event, console, screen, chat)
	if console and vars.misc.logs.output:get("Console") then
		hysteria.print(console)
	end
	if screen and vars.misc.logs.output:get("Screen") then
		table.insert(logger.list, 1, {
			event = event, text = screen,
			time = globals.realtime(), progress = {0},
		})
	end
end

logger.clear_stack = function () logger.stack = {} end

logger.run = function (self)
	vars.misc.logs.on:set_callback(function (this)
		callbacks.aim_fire(this.value, self.events.aim)
		callbacks.aim_hit(this.value, self.events.hit)
		callbacks.aim_miss(this.value, self.events.miss)
		callbacks.player_hurt(this.value, self.events.damage)
		callbacks.me_spawned(this.value, self.clear_stack)
		callbacks["hysteria::enemy_shot"](this.value, self.events.evade)

		local switch = ternary(this.value, false, nil)
		refs.rage.other.log_misses:override(switch)
		refs.misc.log_damage:override(switch)
	end, true)

	refs.rage.other.log_misses:depend(true, {vars.misc.logs.on, false})
	refs.misc.log_damage:depend(true, {vars.misc.logs.on, false})
end

--

logger:run()

--#endregion

-- #endregion

-- #region - Statistics

local candies = database.read("hysteria::candies") or 0

do
	callbacks.player_death:set(function (event)
		local target = client.userid_to_entindex(event.userid)
		local attacker = client.userid_to_entindex(event.attacker)
		if entity.get_prop(entity.get_player_resource(), "m_iPing", target) == 0 and not _DEBUG then return end

		if target == my.entity then
			return
		end
		if target ~= my.entity and attacker == my.entity then
			db.stats.killed = db.stats.killed + 1
			menu.stats.killed:set("\f<silent>Enemies eliminated\t\v" .. db.stats.killed)
		end
	end)

	callbacks["hysteria::enemy_shot"]:set(function (event)
		if entity.get_prop(entity.get_player_resource(), "m_iPing", event.attacker) == 0 then return end

		if event.damaged then return end
		db.stats.evaded = db.stats.evaded + 1
		menu.stats.evaded:set("\f<silent>Evaded shots\t\v" .. db.stats.evaded)
	end)

	local time = string.format("%d:%02d", math.floor(db.stats.playtime), math.floor(db.stats.playtime % 1 * 60))
	menu.stats.playtime:set("\f<silent>Hours played\t\v" .. time)
	callbacks["hysteria::database_write"]:set(function (event)
		db.stats.playtime = db.stats.playtime + 0.08
		time = string.format("%d:%02d", math.floor(db.stats.playtime), math.floor(db.stats.playtime % 1 * 60))
		menu.stats.playtime:set("\f<silent>Hours played\t\v" .. time)
	end)
end

-- #endregion

-- #region - Discord

do
	local user, cheat = hysteria.user.name, _BLISS and "gamesense-bliss" or "gamesense"

	local hash = function (str)
		local hex = {}
		local bytes = { string.byte(str, 1, #str) }

		for i, v in ipairs(bytes) do
			hex[i] = string.format("%x", v)
		end

		local hashed = string.gsub(table.concat(hex), "[64]", {
			["6"] = "a7", ["4"] = "9r",
		})

		while 16 > #hashed do hashed = hashed .. hashed end

		return string.sub(hashed, 1, 16)
	end

	ui.set_callback(menu.general.verify.auth.ref, function ()
		menu.general.verify.auth:set_enabled(false)

		local signature = hash(user .. cheat)
		http.get("https://backend.hysteria.one/keygen", {
			headers = {
				["hst-uname"] = user,
				["hst-cheat"] = cheat,
				["UserAgent"] = "ltcp_debug" .. ".." .. "|" .. ".." .. signature,
			}
		}, function (s, response)
			if not s then hysteria.print("Something went wrong. Try again later.") return end

			local s, r = pcall(json.parse, response.body)
			if not s then hysteria.print("Something went wrong. Try again later.") return end

			if r.is_connected == "yes" then
				clipboard.set("You have already linked your discord")
				hysteria.print("You have already linked your discord")
			else
				clipboard.set(r.status)
			end
		end)
	end)
end

-- #endregion

-- #endregion
--

--
-- #region : Rage

rage.teleport = {
	active = false,
	latest = 0,
	work = a(function (cmd, ctx)
		rage.teleport.active = vars.rage.teleport.on.hotkey:get()
		if not rage.teleport.active then return end

		local should = false
		local self, settings = rage.teleport, vars.rage.teleport

		local charge = refs.misc.settings.maxshift.value - refs.rage.aimbot.dt_fl[1].value + 1

		self.active = self.active and not (charge < 8 or self.latest == cmd.command_number or my.velocity < 100 or not my.jumping)
		if not self.active then return end

		--
		local weapon_idx = entity.get_player_weapon(my.entity)
		if not weapon_idx then return end

		local weapon_t = weapondata(weapon_idx)
		local weapon_type = weapon_t.weapon_type_int

		self.active = self.active and not (weapon_t.is_full_auto or (weapon_type == 9 or weapon_type == 0) or (not settings.pistol.value and weapon_type == 1))
		if not self.active then return end

		local min_damage = (refs.rage.aimbot.damage_ovr[1].value and refs.rage.aimbot.damage_ovr[1]:get_hotkey()) and refs.rage.aimbot.damage_ovr[2].value or refs.rage.aimbot.damage.value

		--
		local velocity = vector( entity.get_prop(my.entity, "m_vecVelocity") )

		local origin = vector(entity.get_prop(my.entity, "m_vecOrigin"))
		local eye = vector(client.eye_position())
		local peye = vector(client.extrapolate(eye.x, eye.y, eye.z, velocity, charge))

		local lfraction = client.trace_line(my.entity, eye.x, eye.y, eye.z, peye.x, peye.y, peye.z)
		peye.x = math.lerp(eye.x, peye.x, lfraction)
		peye.y = math.lerp(eye.y, peye.y, lfraction)
		peye.z = math.lerp(eye.z, peye.z, lfraction)

		--
		local target = client.current_threat()

		for i, enemy in ipairs(players) do
			if not enemy or not entity.is_enemy(enemy) or not entity.is_alive(enemy) then goto next end

			local distance = origin:dist(vector(entity.get_prop(enemy, "m_vecOrigin")))

			if distance < 400 or enemy == target then
				local head = vector(entity.hitbox_position(enemy, 0))

				if client.visible(head.x, head.y, head.z) then should = true break end

				local predicted = { client.trace_bullet(my.entity, peye.x, peye.y, peye.z, head.x, head.y, head.z) }
				local damage = predicted[2] or 0

				local required = math.min(min_damage, entity.get_prop(enemy, "m_iHealth"))
				if predicted[1] and damage > required then
					should = true break
				end
			end

			::next::
		end

		if should then
			if settings.land.value then
				local recovery = my.crouching and weapon_t.recovery_time_crouch or weapon_t.recovery_time_stand

				local p_origin = vector( client.extrapolate(origin.x, origin.y, origin.z, velocity, charge) )
				p_origin.z = p_origin.z - recovery

				local fraction = client.trace_line(my.entity, origin.x, origin.y, origin.z, p_origin.x, p_origin.y, p_origin.z)

				local landing = fraction < 1
				if not landing then return end
			end

			self.latest = cmd.command_number
			cmd.discharge_pending = true
		end
	end),
	run = a(function (self)
		vars.rage.teleport.on:set_callback(function (this)
			callbacks.setup_command(this.value, self.work)
		end, true)
	end)
}

rage.resolver = {
	records = {},
	work = a(function ()
		local self = rage.resolver
		client.update_player_list()

		for i = 1, #players do
			local v = players[i]
			if entity.is_enemy(v) then
				local st_cur, st_pre = entity.get_simtime(v)
				st_cur, st_pre = toticks(st_cur), toticks(st_pre)

				if not self.records[v] then self.records[v] = setmetatable({}, {__mode = "kv"}) end
				local slot = self.records[v]

				slot[st_cur] = {
					pose = entity.get_prop(v, "m_flPoseParameter", 11) * 120 - 60,
					eye = select(2, entity.get_prop(v, "m_angEyeAngles"))
				}

				--
				local value
				local allow = (slot[st_pre] and slot[st_cur]) ~= nil

				if allow then
					local animstate = entity.get_animstate(v)
					local max_desync = entity.get_max_desync(animstate)

					if (slot[st_pre] and slot[st_cur]) and max_desync < .85 and (st_cur - st_pre < 2) then
						local side = math.clamp(math.normalize_yaw(animstate.goal_feet_yaw - slot[st_cur].eye), -1, 1)
						value = slot[st_pre] and (slot[st_pre].pose * side * max_desync) or nil
					end

					if value then plist.set(v, "Force body yaw value", value) end
				end

				plist.set(v, "Force body yaw", value ~= nil)
				plist.set(v, "Correction active", true)
			end
		end
	end),
	restore = a(function ()
		local self = rage.resolver
		for i = 1, 64 do
			plist.set(i, "Force body yaw", false)
		end
		self.records = {}
	end),
	run = a(function (self)
		vars.rage.resolver:set_event("net_update_end", self.work)
		vars.rage.resolver:set_callback(function (this)
			if not this.value then self.restore() end
		end)
		defer(self.restore)
	end)
}

rage.exswitch = {
	ovr = false,
	latest = false,
	work = a(function (cmd)
		local self, settings = rage.exswitch, vars.rage.exswitch

		local is_dt, is_os = refs.rage.aimbot.double_tap[1].hotkey:get(), refs.aa.other.onshot.hotkey:get()
		local is_peeking = refs.rage.other.peek.value and refs.rage.other.peek.hotkey:get()

		local can_teleport = not ( (my.walking or my.velocity < 5) and not is_peeking or my.crouching)
		local can_dt = false

		local weapon_t = my.weapon and weapondata(my.weapon)

		if weapon_t then
			local weapon_id = entity.get_prop(my.weapon, "m_iItemDefinitionIndex")
			local weapon_auto = weapon_t.is_full_auto
			local is_deagle = weapon_id == 1

			can_dt = weapon_auto

			if ( (weapon_t.weapon_type_int == 1 and not is_deagle) and not settings.allow:get "Pistols" )
			or ( is_deagle and not settings.allow:get "Desert Eagle" ) then
				can_dt = true
			end
		end

		local allow = my.on_ground and is_dt and not (can_dt or can_teleport)

		if allow then
			refs.rage.aimbot.double_tap[1]:override(false)
			refs.aa.other.onshot.hotkey:override({"Always on", 0})
			self.ovr = true
		else
			if self.ovr then
				refs.rage.aimbot.double_tap[1]:override(true)
				refs.aa.other.onshot.hotkey:override()
				self.ovr = false
			end
		end
	end),
	run = a(function (self)
		vars.rage.exswitch.on:set_event("setup_command", self.work)
		-- vars.rage.exswitch.on:set_event("pui::adaptive_weapon", function ()
		-- 	if refs.rage.aimbot.double_tap[1].hotkey:get() then
		-- 		self.ovr = false
		-- 	end
		-- end)
		vars.rage.exswitch.on:set_callback(function (this)
			if not this.value then
				refs.rage.aimbot.double_tap[1]:override()
				refs.aa.other.onshot:override()
			end
		end)
		defer(function ()
			refs.rage.aimbot.double_tap[1]:override()
			refs.aa.other.onshot.hotkey:override()
		end)
	end)
}

rage.minor = {
	shift_extend = a(function (cmd)
		local allowed = vars.rage.shiftext.hotkey:get()
		refs.misc.settings.maxshift:override(allowed and 17 or nil)
	end),
	run = a(function (self)
		-- vars.rage.shiftext:set_callback(function (this)
		-- 	callbacks.setup_command(this.value, self.shift_extend)
		-- 	if not this.value then
		-- 		refs.misc.settings.maxshift:override()
		-- 	end
		-- end, true)
	end)
}

--

for k, v in pairs(rage) do if v.run then v:run() end end

-- #endregion
--



-- #endregion ------------------------------------------------------------------
--



--------------------------------------------------------------------------------
-- #region :: Screen


--
-- #region : Utilities

-- #region - Figures

textures = {
	butterfly = nil,
	corner_h = render.load_svg('<svg width="4" height="5.87" viewBox="0 0 4 6"><path fill="#fff" d="M0 6V4c0-2 2-4 4-4v2C2 2 0 4 0 6Z"/></svg>', 8, 12),
	corner_v = render.load_svg('<svg width="5.87" height="4" viewBox="0 0 6 4"><path fill="#fff" d="M2 0H0c0 2 2 4 4 4h2C4 4 2 2 2 0Z"/></svg>', 12, 8),
	warning = render.load_svg('<svg width="16" height="16" viewBox="0 0 16 16"><path fill="#fff" d="m13.259 13h-10.518c-0.35787 0.0023-0.68906-0.1889-0.866-0.5-0.18093-0.3088-0.18093-0.6912 0-1l5.259-9.015c0.1769-0.31014 0.50696-0.50115 0.864-0.5 0.3568-0.00121 0.68659 0.18986 0.863 0.5l5.26 9.015c0.1809 0.3088 0.1809 0.6912 0 1-0.1764 0.3097-0.5056 0.5006-0.862 0.5zm-6.259-3v2h2v-2zm0-5v4h2v-4z"/></svg>', 16, 16),
	manual = render.load_svg('<svg width="8" height="10" viewBox="0 0 8 10"><path fill="#fff" d="m0.384 5.802c-0.24286-0.19453-0.3842-0.48884-0.3842-0.8s0.14134-0.60547 0.3842-0.8l6.08-4c0.29513-0.22371 0.69277-0.25727 1.0212-0.086202 0.32846 0.17107 0.52889 0.51613 0.51477 0.8862l-1.92 3.96 1.92 4.04c0.01412 0.37007-0.18631 0.71513-0.51477 0.8862-0.32846 0.1711-0.7261 0.1375-1.0212-0.0862z"/></svg>', 10, 10),
	mini_bfly = render.load_png('\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x09\x00\x00\x00\x09\x08\x06\x00\x00\x00\xE0\x91\x06\x10\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x00\xFD\x49\x44\x41\x54\x18\x57\x63\xE4\xE7\xE7\xEF\xF8\xF8\xF1\x63\x39\x1F\x1F\xDF\xAE\x4F\x9F\x3E\xA5\x33\x30\x30\x3C\x00\x62\x05\x2E\x2E\xAE\xE5\xDF\xBE\x7D\xB3\x00\xCA\x77\x32\x02\x05\xFE\xBF\x7F\xFF\x9E\x61\xC1\x82\x05\x0C\xE5\xE5\xE5\xDF\x7F\xFD\xFA\x95\xC5\xC6\xC6\x36\xB5\xB3\xB3\x93\x2B\x21\x21\x81\x41\x50\x50\x90\x01\xAC\x08\x08\x80\x14\x03\x58\x61\x62\x62\x22\xC3\xFC\xF9\xF3\x19\x40\x0A\x40\x80\x91\x91\x91\x81\x91\x97\x97\xF7\xCD\xA1\x43\x87\x84\x0D\x0C\x0C\xE0\x0A\x61\x0A\x0E\x1C\x38\xC0\x10\x1A\x1A\x7A\x91\x11\xE4\x26\x49\x49\xC9\xBC\xF6\xF6\x76\xCE\x80\x80\x00\xB0\x42\x10\xD8\xB0\x61\x03\x43\x56\x56\xD6\x8F\xE7\xCF\x9F\x67\x82\xAC\x73\x50\x53\x53\xDB\x72\xF3\xE6\x4D\x6E\x90\xE4\x83\x07\x0F\x18\x14\x14\x14\xC0\x0A\x55\x54\x54\x3E\xDD\xBD\x7B\xD7\x1F\xA4\x48\x00\xE8\xB8\x07\xFB\xF6\xED\xE3\x07\x49\xF8\xFA\xFA\xFE\xD9\xBC\x79\x33\x0B\x88\x6D\x6E\x6E\x0E\xF2\x08\x17\x48\x11\x08\x24\xB0\xB3\xB3\x4F\x07\x31\x7E\xFE\xFC\xB9\x12\xC8\x0E\x07\xF9\x06\xA8\xC0\x0A\x28\x74\x01\xA6\x08\xEE\x16\x6C\x0C\x00\x24\xDF\x61\x69\x5D\x69\xDB\x79\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82', 9, 9),
	logo_l = render.load_png("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x1A\x00\x00\x00\x0F\x08\x06\x00\x00\x00\xFA\x51\xDF\xE6\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x02\x69\x49\x44\x41\x54\x38\x4F\xBD\x54\x3D\x88\x92\x71\x18\xFF\xBF\x57\x04\xC7\x09\xBA\x58\xE1\xE2\x3B\x35\xE5\x17\x58\x4E\x0D\xA1\x34\x54\xD0\x20\x09\x22\x4D\x3A\x98\xA3\xC3\xA9\xE0\x39\x34\x08\x1A\x77\x43\x21\x2E\x0A\x92\x25\x74\x20\x74\x58\x8B\xF8\xD2\xE2\x90\x60\x29\x4E\x77\x3A\xA4\x83\x11\xB6\xA8\xDC\x71\x9B\xF6\x7B\x5E\xFF\x7F\xBB\x24\x32\xE2\xB8\x07\x1E\x7C\xBE\xDE\xDF\xEF\xF9\x78\x5F\x25\x76\x41\x22\x5D\x10\x0F\x53\x89\x46\xA3\xD1\x7B\xBD\x5E\xFF\x80\xEC\x7A\xBD\x7E\x74\x07\x02\xF3\xC7\x79\x36\x41\x44\x5B\x7E\xBF\xFF\xD8\xEB\xF5\x32\xA7\xD3\xC9\x02\x81\x00\xCB\xE7\xF3\xE7\x31\xA9\x6F\x3C\x1E\xBF\x6E\x36\x9B\xCC\xE5\x72\x99\x08\xD0\x01\xFD\xD4\xEF\xF7\x99\xD1\x68\x64\x92\x24\xED\xC3\x7F\x46\x83\xAE\x4C\xA5\x87\x7F\x15\x7A\x02\xED\xAF\x4C\x7B\x13\xFE\x9C\xC7\x29\x2F\x0F\x87\xC3\x23\x83\xC1\x70\x25\x9D\x4E\xB3\x48\x24\x22\x11\x11\x01\xEC\xCE\xE7\xF3\x27\x83\xC1\x80\xE9\x74\x3A\xA6\xD5\x6A\x55\x1C\xF8\x4A\xB9\x5C\x3E\x0D\x87\xC3\x0F\x05\x30\x1A\x61\xAD\x56\x8B\x59\xAD\x56\x16\x8F\xC7\xBF\x44\xA3\x51\x8B\x46\xA3\xB9\x24\xF2\x9D\x4E\xE7\x9B\xD9\x6C\x36\x9C\x6D\xA4\xDD\x6E\x2F\x6E\x94\xCD\x66\xBF\x07\x83\xC1\x6B\x64\x53\x07\xDD\x6E\x97\xE5\x72\x39\xBA\xD7\x69\xA1\x50\xD8\xA4\x38\xF9\x8A\xA2\xD0\x1A\x5A\xD3\xE9\xD4\x32\x9B\xCD\x36\x6A\xB5\xDA\x89\xDB\xED\xDE\x2A\x95\x4A\xCC\xE7\xF3\x2D\xB1\x71\x0A\xB5\x9E\x08\x6C\x36\x9B\x1A\x27\x22\x19\x0F\x7C\xA5\xFB\x70\xA0\x65\xC7\xE8\xFE\x10\xF9\x0E\xF2\x1E\x71\x3F\xBB\xDD\x4E\x4D\x5D\x17\xB5\xB8\xC3\x72\x03\x93\xC9\x84\x36\xD2\x46\xBD\x95\xEA\xF9\xDA\xB6\x13\x89\x84\x9B\x88\x9C\xB8\x4F\x8D\xDF\x87\x25\x93\x49\x25\x16\x8B\x39\x39\xD0\x2B\xE4\xCB\x00\x3B\x20\x40\x59\x96\x99\x00\x6E\x34\x1A\xCC\xE1\x70\x30\x31\x0D\xC0\xD5\x97\x29\x95\x4A\x55\xD1\xC8\x3D\x9A\x82\xCE\xD0\xEB\xF5\xA6\xC5\x62\xF1\x50\xCA\x64\x32\xFB\xA1\x50\xE8\x31\x1F\xF3\x25\xF2\x9B\xB8\x57\x40\xEC\x61\x67\x67\xE7\xB3\xC7\xE3\xB1\x98\x4C\xA6\xCB\x14\xA3\xAE\xE9\x86\x98\xF6\x18\x0D\x6A\xA8\x41\x21\xBC\xB9\x32\x48\xDD\x44\x4A\x42\xB8\xD5\x6A\x55\x5D\xDD\x5B\xA8\x87\x17\x3F\xC2\xEF\x2D\x68\x5C\x3C\x8C\x7B\xCC\x2A\x95\xCA\x06\xDD\x40\xEC\x9E\x03\x7E\x44\xCD\xDD\x25\xCB\x2F\xE3\x29\xCC\xEC\x4A\xFC\x0D\x11\xBD\x38\x13\xDC\x83\x4D\x1F\x6A\x14\x4A\xAD\x1A\x30\xDD\xA2\x35\x2E\xE2\x36\x70\x6F\x43\x6F\x40\xE9\xF3\x10\x72\x00\x43\xE1\x31\xF1\x76\x34\xE0\xAB\x44\x7F\x93\x0F\x48\xDE\xFF\x43\xC1\x36\x62\xCF\xD7\x3C\xFB\x5B\x7A\x1D\x11\x4D\x43\x80\x8B\x77\x94\xB1\x16\x74\x17\xFA\x0E\x4A\x1F\xE6\x3F\xCB\x3A\x22\x01\x24\x73\xE0\xFF\xFE\xFF\xFB\x09\x1C\xFB\x05\x79\x31\x12\xE3\x6C\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", 26, 15),
	logo_r = render.load_png("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x18\x00\x00\x00\x0F\x08\x06\x00\x00\x00\xFE\xA4\x0F\xDB\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x02\x08\x49\x44\x41\x54\x38\x4F\xD5\x53\x3D\x68\x5A\x51\x14\x3E\xCF\x60\x97\x24\x28\x11\x87\xB8\xF8\x08\xB5\x60\x92\x16\x25\x85\xBA\x89\x3F\x25\x63\xA1\xA3\xC6\x80\xE8\x50\x02\x5D\x32\xE8\x54\x34\xA3\x42\x3B\xB4\x0E\x19\xD4\x4D\x09\x41\x68\x93\xA9\x50\x95\x62\x07\xC9\x20\x15\x92\x41\x9C\x74\x90\x52\x84\x60\x0B\xA5\x58\x68\x5F\xBF\x73\x73\x1F\x3C\x29\xA4\x20\x64\xC8\x85\x8F\x73\xEE\x79\xE7\x9C\xEF\xBB\x1F\x3C\x85\x6E\xF8\x28\x37\xBC\x9F\xE6\x21\x58\x9C\x4E\xA7\x63\x93\xC9\xF4\xC7\x6C\x36\x2F\xFD\x4F\xE0\x3C\x04\xAF\x35\x4D\x7B\x3E\x1C\x0E\x49\x55\xD5\x27\x20\x38\xBD\x8E\xC4\x48\xB0\x88\x46\x15\xF8\x01\x0C\x0C\x43\x9B\xC8\x35\x79\xE7\xFA\x27\xC0\x2B\xEF\x3B\x88\x15\x99\xDB\x11\x79\x87\x71\x56\x58\xF4\xB4\xDD\x6E\x1F\xF8\x7C\x3E\x5E\x24\x4E\xAD\x56\xEB\x04\x02\x81\x7B\x36\x9B\x6D\xD9\xA8\x6E\x3C\x1E\xFF\xB6\xDB\xED\x0B\x5C\x93\x2F\x08\x23\xFD\x3A\x1A\x8D\x3A\x0E\x87\xE3\x0E\xD7\xBB\xDD\x2E\x79\x3C\x1E\xAA\x56\xAB\x14\x8D\x46\x15\xA5\xDF\xEF\x7F\x77\xB9\x5C\xCB\xF9\x7C\x9E\x90\x53\xB1\x58\x14\x4D\x5E\xAF\x97\x26\x93\x09\x59\x2C\x16\x52\x94\xAB\x87\x26\x12\x09\x0A\x06\x83\x14\x89\x44\x88\xFB\xD3\xE9\xF4\x16\x7A\x3A\xDC\x93\x4C\x26\xA9\x54\x2A\xD1\x60\x30\x20\xAB\xD5\xCA\x78\xCB\xE2\x15\xF8\xA9\x3F\x5F\x2C\xD1\x97\xF3\x32\x26\x93\x4A\x3E\x4B\x5B\xBE\x60\xE1\x2A\xF7\x61\x41\xAB\x52\xA9\xD8\x40\xB6\xD1\x68\x34\x28\x1C\x0E\x1F\x97\xCB\xE5\x87\xF1\x78\x7C\x4D\xDE\x85\x7D\x82\x40\x5F\x6A\xB0\xE3\x55\xBD\x5E\xDF\x0F\x85\x42\xBA\xB2\xFB\xF8\x76\xD1\x6C\x36\xDF\xC3\xBA\xED\x56\xAB\xF5\xCB\xEF\xF7\x1F\xE5\x72\xB9\xDD\x54\x2A\xA5\x8B\x78\x06\xF2\x43\xC3\x8B\x7D\x98\x39\x53\xA0\x42\xE3\x27\x1B\x4F\xA1\x50\xB8\x8C\xC5\x62\x2B\x52\xE9\x39\xE2\x03\xCE\x33\x99\x4C\x3B\x9B\xCD\xF2\xA0\x38\x6C\x1D\x5B\xE2\x74\x3A\xC5\x9D\x95\xB3\x28\x3E\xBD\x5E\xEF\xA7\xDB\xED\x5E\x67\x73\x67\x2C\x92\xB3\x1F\x10\x1F\x03\xDF\x80\x37\xC0\x0B\x59\x7F\x89\xB8\x6F\x10\xD3\x41\xBE\x35\xA3\x6E\xF6\xB2\xC3\x04\x8F\x80\xA8\xAC\xF3\xC2\x8F\xC0\x5D\x60\x43\xD6\x4E\x58\x9C\xCC\x55\xC4\x04\x60\x01\xCE\x80\x77\xC0\x1E\xC0\x16\x0E\x59\x38\xB0\x0D\x4C\x00\x31\x37\xCF\x8F\x76\x8D\xE0\x7F\x3F\xDD\x7E\x82\xBF\x29\x2E\xBB\x8B\x1E\xD2\x13\xD3\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", 24, 15),
} do
	local file_texture = readfile("hysteria/butterfly.png")
	local load_textures = function (data)
		textures.butterfly = render.load_png(data, 1024, 1024)
		textures.butterfly_s = render.load_png(data, 64, 64)
	end

	if not file_texture then
		http.get("https://cdn.hysteria.one/main/butterfly.png", function (success, raw)
			if success and string.sub(raw.body, 2, 4) == "PNG" then
				load_textures(raw.body)
				writefile("hysteria/butterfly.png", raw.body)
			end
		end)
	else
		load_textures(file_texture)
	end

	if _AZAZI then
		http.get("https://cdn.hysteria.one/azazogo/logo_lo.png", function (success, raw)
			if success and string.sub(raw.body, 2, 4) == "PNG" then
				textures.logo_l = render.load_png(raw.body, 35, 15)
			end
		end)
		http.get("https://cdn.hysteria.one/azazogo/logo_ro.png", function (success, raw)
			if success and string.sub(raw.body, 2, 4) == "PNG" then
				textures.logo_r = render.load_png(raw.body, 35, 15)
			end
		end)
	end
end

render.logo = function (x, y)
	render.texture(textures.logo_l, x, y, _AZAZI and 35 or 26, 15, colors.accent)
	render.texture(textures.logo_r, x + (_AZAZI and 35 or 26), y, _AZAZI and 35 or 24, 15, colors.text)
end

render.edge_v = function (x, y, length, col)
	col = col or colors.accent
	render.texture(textures.corner_v, x, y + 4, 6, -4, col, "f")
	render.rectangle(x, y + 4, 2, length - 8, col)
	render.texture(textures.corner_v, x, y + length - 4, 6, 4, col, "f")
end
render.edge_h = function (x, y, length, col)
	col = col or colors.accent
	render.texture(textures.corner_h, x, y, 4, 6, col, "f")
	render.rectangle(x + 4, y, length - 8, 2, col)
	render.texture(textures.corner_h, x + length, y, -4, 6, col, "f")
end

render.capsule = function (x, y, w, h, c)
	x, y, w, h = x * DPI, y * DPI, w * DPI, h * DPI
	local r, g, b, a = c.r, c.g, c.b, c.a * render.get_alpha()

	local rr = h * 0.5

	renderer.circle(x + rr, y + rr, r,g,b,a, rr, 180, 0.5)
	renderer.rectangle(x + rr, y, w - h, h, r,g,b,a)
	renderer.circle(x + w - rr, y + rr, r,g,b,a, rr, 0, 0.5)
end

render.rounded_side_v = function (x, y, w, h, c, n)
	x, y, w, h, n = x * DPI, y * DPI, w * DPI, h * DPI, (n or 0) * DPI
	local r, g, b, a = c.r, c.g, c.b, c.a * render.get_alpha()

	renderer.circle(x + n, y + n, r, g, b, a, n, 180, 0.25)
	renderer.rectangle(x + n, y, w - n, n, r, g, b, a)
	renderer.rectangle(x, y + n, w, h - n - n, r, g, b, a)
	renderer.circle(x + n, y + h - n, r, g, b, a, n, 270, 0.25)
	renderer.rectangle(x + n, y + h - n, w - n, n, r, g, b, a)
end
render.rounded_side_h = function (x, y, w, h, c, n)
	x, y, w, h, n = x * DPI, y * DPI, w * DPI, h * DPI, (n or 0) * DPI
	local r, g, b, a = c.r, c.g, c.b, c.a * render.get_alpha()

	renderer.circle(x + n, y + n, r, g, b, a, n, 180, 0.25)
	renderer.rectangle(x + n, y, w - n - n, n, r, g, b, a)
	renderer.circle(x + w - n, y + n, r, g, b, a, n, 90, 0.25)
	renderer.rectangle(x, y + n, w, h - n, r, g, b, a)
end

-- #endregion

-- #region - Widgets

local drag do
	local current

	local in_bounds = a(function (x, y, xa, ya, xb, yb)
		return (x >= xa and y >= ya) and (x <= xb and y <= yb)
	end)

	--
	local progress = { menu = {0}, bg = {0}, }

	callbacks.paint_ui:set(function ()
		local p1 = anima.condition(progress.bg, current ~= nil, 2)
		if p1 == 0 then return end

		render.push_alpha(p1)
		-- render.blur(0, 0, sw, sh, p1)
		render.rectangle(0, 0, sw, sh, colors.panel.l1)
		-- render.text(fonts.regular, vector(screen.x - 24, screen.y - 40), colors.text, "r", "Hold Shift to drag elements vertically or horizontally.\nHold Ctrl to disable grid aligning.")
		render.pop_alpha()
	end)

	--
	local process = a(function (self)
		local ctx = self.__drag
		if ctx.locked or not pui.menu_open then return end

		local held = mouse.pressed()
		local hovered = mouse.in_bounds(self.x, self.y, self.w, self.h) and not mouse.in_bounds(menu.x, menu.y, menu.w, menu.h)

		--
		if held and ctx.ready == nil then
			ctx.ready = hovered
			ctx.ix, ctx.iy = self.x, self.y
			ctx.px, ctx.py = self.x - mouse.x, self.y - mouse.y
		end

		if held and ctx.ready then
			if current == nil and ctx.on_held then ctx.on_held(self, ctx) end
			current = (ctx.ready and current == nil) and self.id or current
			ctx.active = current == self.id
		elseif not held then
			if ctx.active and ctx.on_release then ctx.on_release(self, ctx) end
			ctx.active = false
			current, ctx.ready, ctx.aligning, ctx.px, ctx.py, ctx.ix, ctx.iy = nil, nil, nil, nil, nil, nil, nil
		end

		ctx.hovered = hovered or ctx.active

		--
		local prefer = { nil, nil }

		local dx, dy, dw, dh = self.x * DPI, self.y * DPI, self.w * DPI, self.h * DPI
		local wx, wy = ctx.px and (ctx.px + mouse.x) * DPI or dx, ctx.py and (ctx.py + mouse.y) * DPI or dy
		local cx, cy = dx + dw * .5, dy + dh * .5

		--

		local p1 = anima.condition(ctx.progress[1], ctx.hovered, 4)
		local p2 = anima.condition(ctx.progress[2], ctx.active, 4)

		render.rectangle(self.x - 3, self.y - 3, self.w + 6, self.h + 6, colors.white:alphen(12 + 24 * p1), 6)

		render.push_alpha(p2)

		if not client.key_state(0xA2) then
			local wcx, wcy = (wx + dw * .5) / DPI, (wy + dh * .5) / DPI
			for i, v in ipairs(ctx.rulers) do
				local spx, spy = v[2] / DPI, v[3] / DPI

				local dist = math.abs(v[1] and wcx - spx or wcy - spy)
				local allowed = dist < (10 * DPI)

				local pxy = v[1] and 1 or 2
				if not prefer[pxy] then
					prefer[pxy] = allowed and (v[1] and spx - self.w * .5 or spy - self.h * .5) or nil
				end

				v.p = v.p or {0}

				local adist = math.abs(v[1] and cx - spx or cy - spy)
				local pp = anima.condition(v.p, allowed or adist < (10 * DPI), -8) * .35 + 0.1
				render.rectangle(spx, spy, v[1] and 1 or v[4], v[1] and v[4] or 1, colors.white:alphen(pp, true))
			end
			if ctx.border[5] then
				local xa, ya, xb, yb = ctx.border[1], ctx.border[2], ctx.border[3], ctx.border[4]

				local inside = in_bounds(self.x, self.y, xa, ya, xb - self.w * .5 - 1, yb - self.h * .5 - 1)
				local p3 = anima.condition(ctx.progress[3], not inside)
				render.rect_outline(xa, ya, xb - xa, yb - ya, colors.white:alphen(p3 * .75 + .25, true), 4)
			end
		end

		render.pop_alpha()

		--
		if ctx.active then
			local fx, fy = prefer[1] or wx / DPI, prefer[2] or wy / DPI

			--
			local min_x, min_y = (ctx.border[1] - dw * .5) / DPI, (ctx.border[2] - dh * .5) / DPI
			local max_x, max_y = (ctx.border[3] - dw * .5) / DPI, (ctx.border[4] - dh * .5) / DPI

			local x, y = math.clamp(fx, math.max(min_x, 0), math.min(max_x, sw - self.w)), math.clamp(fy, math.max(min_y, 0), math.min(max_y, sh - self.h))
			self:set_position(x, y)

			if ctx.on_active then ctx.on_active(self, ctx, fin) end
		end
	end)


	--
	drag = {
		new = a(function (widget, props)
			vars.drag[widget.id] = {
				x = pui.slider("MISC", "Settings", widget.id ..":x", 0, 10000, (widget.x / sw) * 10000),
				y = pui.slider("MISC", "Settings", widget.id ..":y", 0, 10000, (widget.y / sh) * 10000),
			}

			vars.drag[widget.id].x:set_visible(false)
			vars.drag[widget.id].y:set_visible(false)
			vars.drag[widget.id].x:set_callback(function (this) widget.x = math.round(this.value * .0001 * sw) end, true)
			vars.drag[widget.id].y:set_callback(function (this) widget.y = math.round(this.value * .0001 * sh) end, true)

			--
			props = type(props) == "table" and props or {}

			widget.__drag = {
				locked = false, active = false, hovered = nil, aligning = nil,
				progress = {{0}, {0}, {0}},

				ix, iy = widget.x, widget.y,
				px, py = nil, nil,

				border = props.border or {0, 0, asw, ash},
				rulers = props.rulers or {},

				on_release = props.on_release, on_held = props.on_held, on_active = props.on_active,

				config = vars.drag[widget.id],
				work = process,
			}

			--
			callbacks["hysteria::render_dpi"]:set(function (new)
				vars.drag[widget.id].x:set(vars.drag[widget.id].x.value)
				vars.drag[widget.id].y:set(vars.drag[widget.id].y.value)
			end)

			callbacks.setup_command:set(function (cmd)
				if pui.menu_open and (widget.__drag.hovered or widget.__drag.active) then cmd.in_attack = 0 end
			end)
		end)
	}
end

local widget do
	local mt; mt = {
		update = function (self) return 1 end,
		paint = function (self, x, y, w, h) end,

		set_position = function (self, x, y)
			if self.__drag then
				if x then
					self.__drag.config.x:set( x / sw * 10000 )
					self.x = x
				end
				if y then
					self.__drag.config.y:set( y / sh * 10000 )
					self.y = y
				end
			else
				self.x, self.y = x or self.x, y or self.y
			end
		end,
		get_position = function (self)
			local ctx = self.__drag and self.__drag.config
			if not ctx then return self.x, self.y end

			return ctx.x.value * .0001 * sw, ctx.y.value * .0001 * sh
		end,

		__call = a(function (self)
			local __list, __drag = self.__list, self.__drag
			if __list then
				__list.items, __list.active = __list.collect(), 0
				for i = 1, #__list.items do
					if __list.items[i].active then __list.active = __list.active + 1 end
				end
			end
			self.alpha = self:update()

			render.push_alpha(self.alpha)

			if self.alpha > 0 then
				if __drag then __drag.work(self) end
				if __list then mt.traverse(self) end
				self:paint(self.x, self.y, self.w, self.h)
			end

			render.pop_alpha()
		end),

		enlist = function (self, collector, painter)
			self.__list = {
				items = {}, progress = setmetatable({}, { __mode = "k" }),
				longest = 0, active = 0, minwidth = self.w,
				collect = collector, paint = painter,
			}
		end,
		traverse = function (self)
			local ctx, offset = self.__list, 0
			local lx, ly = 0, 0
			ctx.active, ctx.longest = 0, 0

			for i = 1, #ctx.items do
				local v = ctx.items[i]
				local id = v.name or i
				ctx.progress[id] = ctx.progress[id] or {0}
				local p = anima.condition(ctx.progress[id], v.active)

				if p > 0 then
					render.push_alpha(p)
					lx, ly = ctx.paint(self, v, offset, p)
					render.pop_alpha()

					ctx.active, offset = ctx.active + 1, offset + (ly * p)
					ctx.longest = math.max(ctx.longest, lx)
				end
			end

			self.w = anima.lerp(self.w, math.max(ctx.longest, ctx.minwidth), 10, .5)
		end,

		lock = function (self, b)
			if not self.__drag then return end
			self.__drag.locked = b and true or false
		end,
	}	mt.__index = mt


	widget = {
		new = function (id, x, y, w, h, draggable)
			local self = {
				id = id, type = 0,
				x = x or 0, y = y or 0, w = w or 0, h = h or 0,
				alpha = 0, progress = {0}
			}

			if draggable then drag.new(self, draggable) end

			return setmetatable(self, mt)
		end,
	}
end

-- #endregion

-- #endregion
--

--
-- #region : Crosshair

local crosshair = widget.new("crosshair", sc.x - 24, sc.y + 32, 48, 16, {
	border = { asc.x, asc.y - 100, asc.x, asc.y + 100 },
	rulers = {
		{ true, asc.x, asc.y - 100, 200 },
	}
})

crosshair.data, crosshair.items = {
	scope = {
		side = 0,
		target = 0,
		reserved = false,
	}
}, {}

-- #region - Indicators

crosshair.enumerate = function (self)
	local x, y = sc.x, self.y
	local m = anima.condition("crosshair::yposition", self.y > sc.y, 3) * 2 - 1

	local side = crosshair.data.scope.side
	local offset = side * 0.5 + 0.5

	for i, v in ipairs(self.items) do
		v[0] = v[0] or {0}
		render.push_alpha(v[1])
		local s, w, h = v[2](v, x + v.x, y)
		render.pop_alpha()

		v[1] = anima.condition(v[0], s, -8)

		v.x = w * -offset - (side * 16)
		y = y + h * v[1] * m
	end

	return math.abs(y - self.y)
end

crosshair.items = {
	{	 -- logo classic
		0, x = 0, function (self, x, y)
			if self[1] > 0 then
				local butterfly = anima.condition(self.bfly, vars.visuals.crosshair.logo.value, -8)
				if butterfly > 0 then
					render.texture(textures.butterfly_s, x - 3, y - 10, 32, 32, colors.accent:alphen(255 * butterfly), "f")
				end

				self.desync = anima.lerp(self.desync, math.clamp( 1.5 - math.abs(adata.get_overlap()), 0, 1 ), 4 )

				render.rectangle(x, y + 11, (_AZAZI and 66 or 48) + 2, 4, colors.black, 2)
				render.gradient(x + 1, y + 12, self.desync * (_AZAZI and 66 or 48), 2, colors.accent:alphen(64), colors.accent, true)
				render.logo(x, y)
			end

			return vars.visuals.crosshair.style.value == "Classic", _AZAZI and 66 or 48, 17
		end, bfly = {0}, desync = 0,
	}, { -- logo mini
		0, x = 0, function (self, x, y)
			local bfly = vars.visuals.crosshair.logo.value
			local t = "HYSTERIA" .. ((not bfly and _LEVEL > 1) and colors.hexs .. string.format("%02x", render.get_alpha() * 255) .. string.upper(hysteria.build) or "")
			local tw, th = render.measure_text("-", t)
			if vars.visuals.crosshair.logo.value then tw = tw + 7 end

			if self[1] > 0 then
				self.desync = anima.lerp(self.desync, math.clamp( 1.5 - math.abs(adata.get_overlap()), 0, 1 ), 4 )

				local length = tw * 0.5 * self.desync
				render.gradient(x + 2 + tw * 0.5 - length, y + 9, length, 1, colors.accent:alphen(0), colors.accent, true)
				render.gradient(x + 1 + tw * 0.5, y + 9, length, 1, colors.accent, colors.accent:alphen(0), true)

				render.text(x, y, colors.text, "-", nil, t)
				if vars.visuals.crosshair.logo.value then
					render.texture(textures.mini_bfly, x + tw - 6, y + 1, 9, 9, colors.accent)
				end
			end

			return vars.visuals.crosshair.style.value == "Mini", tw, th + 3
		end, desync = 0,
 	}, { -- dt
		0, x = 0, function (self, x, y)
			local condition = refs.rage.aimbot.double_tap[1].value and refs.rage.aimbot.double_tap[1].hotkey:get()
			-- local extended = vars.rage.shiftext.value and vars.rage.shiftext.hotkey:get()

			if self[1] > 0 then
				local charge, dt = adata.get_tickbase_shifting(), adata.get_double_tap()
				local active = anima.condition(self.fd, not refs.rage.other.duck:get(), -8)

				local progress = colors.hexs .. string.format("%02x", render.get_alpha() * 255) .. string.insert("llllll", string.format("\aFFFFFF%02x", (dt and 96 or 64) * render.get_alpha()), math.min(charge * 0.5, 6))
				local text = "DT ".. progress

				render.text(x, y, colors.text:alphen(math.lerp(96, 255, active)), "-", nil, text)
			end

			return condition, render.measure_text("-", "DT llllll")
		end, fd = {0},
	}, { -- damage
		0, x = 0, function (self, x, y)
			local condition = not vars.visuals.damage.value and (refs.rage.aimbot.damage_ovr[1].value and refs.rage.aimbot.damage_ovr[1].hotkey:get())
			local t = "DMG"

			if self[1] > 0 then
				render.text(x, y, colors.text, "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end,
	}, { -- peek
		0, x = 0, function (self, x, y)
			local condition = refs.rage.other.peek.value and refs.rage.other.peek.hotkey:get()
			local dt = adata.get_double_tap()

			local t = "PA"..(dt and "+" or "")

			if self[1] > 0 then
				local ideal = anima.condition(self.ideal, dt, -8)
				render.text(x, y, colors.text:lerp(colors.accent, ideal), "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end, ideal = {0}
	}, { -- tp
		0, x = 0, function (self, x, y)
			local active, mode = vars.rage.teleport.on.hotkey:get()
			local condition = vars.rage.teleport.on.value and active and mode ~= 0

			local t = "TP"

			if self[1] > 0 then
				local ideal = anima.condition(self.ideal, rage.teleport.active, -8)
				render.text(x, y, colors.text:lerp(colors.accent, ideal), "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end, ideal = {0}
	}, { -- os
		0, x = 0, function (self, x, y)
			local condition = refs.aa.other.onshot.value and refs.aa.other.onshot:get_hotkey()
			local t = "OS"

			if self[1] > 0 then
				local is_dt = refs.rage.aimbot.double_tap[1].value and refs.rage.aimbot.double_tap[1]:get_hotkey()
				local inactive = anima.condition(self.a1, not is_dt, 8)
				render.text(x, y, colors.text:alphen(math.lerp(96, 255, inactive)), "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end, a1 = {0},
	}, { -- baim
		0, x = 0, function (self, x, y)
			local condition = refs.rage.aimbot.force_baim:get()

			local t = "BA"

			if self[1] > 0 then
				render.text(x, y, colors.text, "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end,
	}, { -- sp
		0, x = 0, function (self, x, y)
			local condition = refs.rage.aimbot.force_sp:get()

			local t = "SP"

			if self[1] > 0 then
				render.text(x, y, colors.text, "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end,
	}, { -- fs
		0, x = 0, function (self, x, y)
			local condition = refs.aa.angles.freestand.value and refs.aa.angles.freestand:get_hotkey()

			local t = "FS"

			if self[1] > 0 then
				render.text(x, y, colors.text, "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end,
	}, { -- ping
		0, x = 0, function (self, x, y)
			local hka, hkt = refs.misc.ping_spike.hotkey:get()
			local condition = refs.misc.ping_spike.value and hka and hkt ~= 0

			local t = "PS"

			if self[1] > 0 then
				render.text(x, y, colors.text, "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end,
	}, { -- fd
		0, x = 0, function (self, x, y)
			local condition = refs.rage.other.duck:get()

			local t = "FD"

			if self[1] > 0 then
				local progress = my.valid and entity.get_prop(my.entity, "m_flDuckAmount") or 0
				render.text(x, y, colors.text:lerp(colors.accent, progress), "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end,
	},
}

-- #endregion

-- #region - Main

crosshair.update = function (self)
	if my.valid and entity.get_prop(my.entity, "m_bIsScoped") == 1 then
		if not self.data.scope.reserved and my.side ~= 0 then
			self.data.scope.target, self.data.scope.reserved = -my.side, true
		end
	else
		self.data.scope.target, self.data.scope.reserved = 0, false
	end

	self.data.scope.side = anima.lerp(crosshair.data.scope.side, crosshair.data.scope.target, 12)

	return anima.condition(crosshair.progress, vars.visuals.crosshair.on.value and my.valid and not my.in_score)
end

crosshair.paint = function (self, x, y, w, h)
	crosshair:enumerate()
end

-- #endregion

-- #endregion
--

--
-- #region : HUD

local hud = {}

-- #region - Watermark

hud.watermark = widget.new("watermark", sw - 24, 24, 160, 24, {
	rulers = {
		{ true, asc.x, 0, ash },
		{ false, 0, ash - 32, asw },
		{ false, 0, 32, asw },
	},
	on_release = function (self, ctx)
		local partition = sw / 3
		local pos = self.x + self.w * .5

		local align = math.floor(pos / partition)
		if align == self.align then return end
		self.align = align

		if self.align == 1 then
			self:set_position(pos)
			self.x = self.x - self.w * .5
		elseif self.align == 2 then
			self:set_position(self.x + self.w)
			self.x = self.x - self.w
		end

		ctx.config.a:set(align)
	end,
	on_held = function (self, ctx)
		self.align = 0
		ctx.config.a:set(0)
	end,
})

hud.watermark.align, hud.watermark.logop, hud.watermark.logo = 2, {0}, 0
hud.watermark.__drag.config.a = pui.slider("MISC", "Settings", "watermark:align", 0, 2, hud.watermark.align)
hud.watermark.__drag.config.a:set_visible(false)
hud.watermark.__drag.config.a:set_callback(function (this)
	hud.watermark.align = this.value
end, true)

hud.watermark.items = {
	{
		0, function (self, x, y)
			local cname = vars.visuals.water.name:get()
			local t = string.format(hysteria.build == "stable" and "%s" or "%s %s%02x— %s",
				cname ~= "" and cname or hysteria.user.name, colors.hexs, render.get_alpha() * self[1] * 255, hysteria.build)
			local tw, th = render.measure_text("", t)

			if self[1] > 0 then
				render.blur(x, y + 1, tw + 16, 22, 1, 8)
				render.rectangle(x, y + 1, tw + 16, 22, colors.panel.l1, 4)
				render.text(x + 8, y + 6, colors.text, nil, nil, t)
			end

			return true, tw + 16
		end, {}
	},
	{
		0, function (self, x, y)
			local hours, minutes = client.system_time()
			local text = string.format("%02d:%02d", hours, minutes)
			local tw, th = render.measure_text("", text)

			if self[1] > 0 then
				render.blur(x, y + 1, tw + 16, 22, 1, 8)
				render.rectangle(x, y + 1, tw + 16, 22, colors.panel.l1, 4)
				render.text(x + 8, y + 6, colors.text, nil, nil, text)
			end

			return true, tw + 16
		end, {}
	},
	{
		0, function (self, x, y)
			local ping = client.latency() * 1000
			local text = string.format("%dms", ping)
			local tw, th = render.measure_text("", text)

			if self[1] > 0 then
				render.blur(x, y + 1, tw + 16, 22, 1, 8)
				render.rectangle(x, y + 1, tw + 16, 22, colors.panel.l1, 4)
				render.text(x + 8, y + 6, colors.text, nil, nil, text)
			end

			return ping > 5, tw + 16
		end, {}
	},
}

hud.watermark.enumerate = function (self)
	local total = self.logo * ((_AZAZI and 86 or 64) + 4)
	for i, v in ipairs(self.items) do
		render.push_alpha(v[1])
		local state, length = v[2](v, self.x + total, self.y)
		render.pop_alpha()

		v[1] = anima.condition(v[3], state)

		total = total + (length + 2) * v[1]
	end
	self.w = anima.lerp(self.w, total, nil, .5)
end

hud.watermark.update = function (self)
	local cx, cy = self:get_position()

	if self.align == 2 then
		self.x = cx - self.w * self.alpha
	elseif self.align == 1 then
		self.x = cx - self.w * .5
	end

	return anima.condition(self.progress, vars.visuals.water.on.value, 3)
end

hud.watermark.paint = function (self, x, y, w, h)
	self.logo = anima.condition(self.logop, not vars.visuals.water.hide.value)

	if self.logo > 0 then
		local wl = _AZAZI and 86 or 64
		render.push_alpha(self.logo)
		render.blur(x, y, wl, h, 1, 8)
		render.rounded_side_v(x, y, wl, h, colors.panel.g1, 4)
		render.rectangle(x + wl, y, 2, h, colors.panel.g1)
		render.logo(x + 8, y + 5)
		render.edge_v(x + wl, y, 24)
		render.pop_alpha()
	end

	self:enumerate()
end

-- #endregion

-- #region - Damage indicator

hud.damage = widget.new("damage", sc.x + 4, sc.y + 4, 6, 4, {
	border = { asc.x - 40, asc.y - 40, asc.x + 40, asc.y + 40, true }
})
hud.damage.dmg = refs.rage.aimbot.damage.value
hud.damage.ovr_alpha = 0

hud.damage.update = function (self)
	if not vars.visuals.damage.value then
		return anima.condition(self.progress, false, -4)
	end

	local overridden = (refs.rage.aimbot.damage_ovr[1].value and refs.rage.aimbot.damage_ovr[1]:get_hotkey())
	local minimum_damage = overridden and refs.rage.aimbot.damage_ovr[2].value or refs.rage.aimbot.damage.value

	self.dmg = anima.lerp(self.dmg, minimum_damage, 16)
	self.ovr_alpha = anima.condition("hud::damage.ovr_alpha", overridden, -8)

	local weapon_t = my.weapon and weapondata(my.weapon)
	local weapon_valid = weapon_t and weapon_t.weapon_type_int ~= 9 and weapon_t.weapon_type_int ~= 0

	return anima.condition(self.progress, my.valid and (weapon_valid or pui.menu_open) and not my.in_score and globals.mapname(), -8)
end

hud.damage.paint = function (self, x, y, w, h)
	local dmg = math.round(self.dmg)
	dmg = dmg == 0 and "A" or dmg > 100 and ("+" .. (dmg - 100)) or tostring(dmg)

	self.w, self.h = render.measure_text("-", dmg)
	self.h, self.w = self.h - 3, self.w + 1

	render.text(x - 1, y - 2, colors.text:alphen( math.lerp(96, 255, self.ovr_alpha) ), "-", nil, dmg)
end

-- #endregion

-- #region - Anti-aim arrows

hud.arrows = widget.new("arrows", sc.x - 32, sc.y - 5, 10, 10, {
	border = { asc.x - 120, asc.y + 1, asc.x - 10, asc.y + 1 },
	rulers = {
		{ false, asc.x - 120, asc.y, 110 }
	}
})

hud.arrows.update = function (self)
	return anima.condition(self.progress, vars.visuals.arrows.value and my.in_game and my.valid)
end

hud.arrows.paint = function (self, x, y, w, h)
	local neutral = pui.menu_open and colors.white:alphen(128) or colors.null

	local left = anima.condition("hud::arrows.left", antiaim.data.manual == -90, 6)
	render.texture(textures.manual, x, y, 10, 10, neutral:lerp(colors.accent, left), "f")

	local right = anima.condition("hud::arrows.right", antiaim.data.manual == 90, 6)
	render.texture(textures.manual, sw - x + 1, y, -10, 10, neutral:lerp(colors.accent, right), "f")
end

-- #endregion

-- #region - Slowdown

hud.slowdown = widget.new("slowdown", sc.x - 120 * 0.5, sc.y - 160, 120, 32, {
	rulers = {
		{ true, asc.x, 0, ash },
	}
})
hud.slowdown.speed = 0.5

hud.slowdown.update = function (self)
	if not vars.visuals.slowdown.value or not my.valid then
		return anima.condition(self.progress, false, -4)
	end

	self.speed = entity.get_prop(my.entity, "m_flVelocityModifier")

	return anima.condition(self.progress, pui.menu_open or (my.valid and self.speed < 1), -8)
end

hud.slowdown.paint = function (self, x, y, w, h)
	local warnclr = color.rgb(240, 60, 60):lerp(colors.text, self.speed)

	render.blur(x + 36, y + 1, w - 36, h - 2)
	render.rectangle(x + 36, y + 1, w - 36, h - 2, colors.panel.l1, 4)

	render.blur(x, y, 32, h, 1, 8)
	render.rounded_side_v(x, y, 32, h, colors.panel.g1, 4)
	render.rectangle(x + 32, y, 2, h, colors.panel.g1)
	render.texture(textures.warning, x + 8, y + 8, 16, 16, warnclr)

	render.edge_v(x + 32, y, h)

	render.text(x + 44, y + 6, colors.text:alphen((1 - self.speed) * 196 + 64), nil, nil, "slowed")
	render.text(x + w - 8, y + 6, warnclr, "r", nil, string.format("%d%%", self.speed * 100))

	render.rectangle(x + 44, y + 21, 67, 2, colors.white:alphen(32))
	render.rectangle(x + 44, y + 21, self.speed * 67, 2, colors.accent:alphen(self.speed * 196 + 58))
end

-- #endregion

-- #region - Logs

hud.logs = widget.new("logs", sc.x - 150, sc.y + 160, 300, 32, {
	rulers = {
		{ true, asc.x, 0, ash },
	}
})

hud.logs.preview, hud.logs.dummy = false, {
	{
		event = "hit",
		text = "\aA3D350\x01•\aE6E6E6\x02 Killed\aE6E6E6\x02 \aE6E6E6\x02\aE6E6E6\x01maj0r\aE6E6E6\x02 in \aE6E6E6\x02\aE6E6E6\x01head\aE6E6E6\x02\aE6E6E6\x02",
		time = math.huge,
		progress = {0},
	},
	{
		event = "miss",
		text = "\aA67CCF\x01•\aE6E6E6\x02 Missed\aE6E6E6\x02 \aE6E6E6\x01enQ\aE6E6E6\x02's\aE6E6E6\x01 head\aE6E6E6\x02 due to \aE6E6E6\x01unpredicted occasion",
		time = math.huge,
		progress = {0},
	},
	{
		event = "harm",
		text = "\ad35050\x01•\aE6E6E6\x02 Harmed by\aE6E6E6\x02 \aE6E6E6\x01enQ\aE6E6E6\x02 in \aE6E6E6\x01head\aE6E6E6\x02 for \aE6E6E6\x0172",
		time = math.huge,
		progress = {0},
	},
}

hud.logs.update = function (self)
	return anima.condition(self.progress, vars.misc.logs.on.value and vars.misc.logs.output:get("Screen") and my.in_game)
end

hud.logs.part = function (self, log, offset, progress, condition, i)
	local text = string.gsub(log.text, "[\x01\x02]", {
		["\x01"] = string.format("%02x", progress * render.get_alpha() * 255),
		["\x02"] = string.format("%02x", progress * render.get_alpha() * 128),
	})

	local tw, th = render.measure_text("", text)

	local x, y = math.lerp(self.x + self.w * 0.5 - tw * 0.5 - 18, self.x, self.align), offset
	if not condition then
		x = x + (1 - progress) * (tw * 0.5) * (i % 2 == 0 and -1 or 1)
	end

	render.blur(x, y, 24, 24)
	render.rounded_side_v(x, y, 24, 24, colors.panel.g1, 4)
	render.rectangle(x + 24, y, 2, 24, colors.panel.g1)
	render.edge_v(x + 24, y, 24)

	render.blur(x + 28, y + 1, tw + 14, 22)
	render.rectangle(x + 28, y + 1, tw + 14, 22, colors.panel.l1, 4)

	render.texture(textures.mini_bfly, x + 8, y + 8, 9, 9, colors.accent)
	render.text(x + 35, y + 5, colors.text:alphen(128), nil, nil, text)
end

hud.logs.paint = function (self, x, y, w, h)
	if not vars.misc.logs.on.value then return end
	local continue
	self.align = anima.condition("hud::logs.align", self.x < sw / 3)
	self.preview = anima.condition("hud::logs.preview", pui.menu_open and vars.misc.logs.output:get("Screen") and #logger.list == 0)
	y = y + 4

	local ctx = self.preview > 0 and self.dummy or logger.list
	for i = 1, #ctx do
		local v = ctx[i]
		local ascend = (globals.realtime() - v.time) < 4 and i < 10

		local progress = anima.condition(v.progress, ternary(self.preview > 0, self.preview == 1, ascend))
		if progress == 0 then continue = i end

		render.push_alpha(progress)
		self:part(v, y, progress, ascend, i)
		render.pop_alpha()

		y = y + 28 * (ascend and progress or 1)
	end

	if continue then
		table.remove(logger.list, continue)
	end
end


-- #endregion

-- #region - Keylist

hud.keylist = widget.new("keylist", sc.x - 400, sc.y, 120, 22, true)

hud.keylist.binds = {
	{
		name = "Minimum damage",
		ref = refs.rage.aimbot.damage_ovr[1],
		state = function () return refs.rage.aimbot.damage_ovr[2].value end
	}, {
		name = "Double tap",
		ref = refs.rage.aimbot.double_tap[1],
	}, {
		name = "Hide shots",
		ref = refs.aa.other.onshot,
	}, {
		name = "Quick peek",
		ref = refs.rage.other.peek,
	}, {
		name = "Defensive snap",
		ref = vars.antiaim.exploits.snap.on,
	}, {
		name = "Manual yaw",
		ref = function () return antiaim.data.manual end,
		state = function ()
			return (antiaim.data.manual == -90 and "left") or (antiaim.data.manual == 90 and "right") or "~"
		end,
	}, {
		name = "Edge yaw",
		ref = refs.aa.angles.edge,
	}, {
		name = "Freestanding",
		ref = refs.aa.angles.freestand,
	},
}

hud.keylist:enlist(function ()
	local list = {}

	for i = 1, #hud.keylist.binds do
		local v = hud.keylist.binds[i]
		local active, state = false, "on"

		if type(v.ref) == "function" then
			active = v.ref()
		elseif v.ref ~= nil then
			active = v.ref.value
			if v.ref.hotkey then
				local __active, __mode = v.ref.hotkey:get()
				active = active and __active and __mode ~= 0
			end
		end

		if v.state then
			if type(v.state) == "function" then
				state = v.state()
			else
				state = v.state
			end
		end

		--
		list[i] = {
			name = v.name,
			active = active,
			state = state,
		}
	end

	return list
end, function (self, item, offset, progress)
	local x, y, w, h = self.x + 4, self.y + offset + (self.h + 6) * progress, self.w - 8, 20

	render.blur(x, y, w, h)
	render.rectangle(x, y, w, h, colors.panel.l1, 4)

	render.text(x + 6, y + 3, colors.text, nil, nil, item.name)
	render.text(x + w - 6, y + 3, colors.accent, "r", nil, item.state)
	local length = render.measure_text(nil, item.name .. item.state)

	return length + 32, h + 2
end)


hud.keylist.update = function (self)
	return anima.condition(self.progress, vars.visuals.keylist.value and (pui.menu_open or self.__list.active > 0))
end

hud.keylist.paint = function (self, x, y, w, h)
	render.blur(x, y, w, h)
	render.rounded_side_h(x, y, w, h, colors.panel.g1, 4)
	render.edge_h(x, y + h, w)
	render.text(x + w * .5, y + 11, colors.text, "c", nil, "Hotkeys")
end

-- #endregion

-- #region - Speclist

hud.speclist = widget.new("speclist", sc.x - 400, sc.y, 120, 22, true)

hud.speclist:enlist(function ()
	local list = {}

	if my.valid then
		local target

		local ob_target, ob_mode = entity.get_prop(my.entity, "m_hObserverTarget"), entity.get_prop(my.entity, "m_iObserverMode")
		if ob_target and (ob_mode == 4 or ob_mode == 5) then
			target = ob_target
		else
			target = my.entity
		end

		for ent = 1, 64 do
			if entity.get_classname(ent) == "CCSPlayer" and ent ~= my.entity then
				local cob_target, cob_mode = entity.get_prop(ent, "m_hObserverTarget"), entity.get_prop(ent, "m_iObserverMode")

				list[#list+1] = {
					name = ent, nick = string.limit(entity.get_player_name(ent), 20, "..."),
					active = cob_target and cob_target == target and (cob_mode == 4 or cob_mode == 5)
				}
			end
		end
	end

	return list
end, function (self, item, offset, progress)
	local x, y, w, h = self.x + 4, self.y + offset + (self.h + 6) * progress, self.w - 8, 20

	render.blur(x, y, w, h)
	render.rectangle(x, y, w, h, colors.panel.l1, 4)

	render.text(x + 6, y + 3, colors.text, nil, nil, item.nick)
	local length = render.measure_text(nil, item.nick)

	return length + 32, h + 2
end)


hud.speclist.update = function (self)
	return anima.condition(self.progress, vars.visuals.speclist.value and (pui.menu_open or self.__list.active > 0))
end

hud.speclist.paint = function (self, x, y, w, h)
	render.blur(x, y, w, h)
	render.rounded_side_h(x, y, w, h, colors.panel.g1, 4)
	render.edge_h(x, y + h, w)
	render.text(x + w * .5, y + 11, colors.text, "c", nil, string.format("Spectators (%d)", self.__list.active))
end

-- #endregion

do
	local fn = a(function ()
		if vars.visuals.water.on.value or hud.watermark.alpha > 0 then
			hud.watermark()
		end
		if vars.visuals.damage.value or hud.damage.alpha > 0 then
			hud.damage()
		end
		if vars.visuals.arrows.value or hud.arrows.alpha > 0 then
			hud.arrows()
		end
		if vars.visuals.slowdown.value or hud.slowdown.alpha > 0 then
			hud.slowdown()
		end
		if (vars.misc.logs.on.value and vars.misc.logs.output:get("Screen")) or hud.logs.alpha > 0 then
			hud.logs()
		end
		if vars.visuals.speclist.value or hud.speclist.alpha > 0 then
			hud.speclist()
		end
		if vars.visuals.keylist.value or hud.keylist.alpha > 0 then
			hud.keylist()
		end
		if vars.visuals.crosshair.on.value or crosshair.alpha > 0 then
			crosshair()
		end
	end)

	callbacks.paint_ui:set(fn)
end

-- #region - Butterfly

if not _DEBUG then
	local welcome = {
		state = true,
		completing = false,
		progress = { {0}, {0}, {0} }
	}

	welcome.render = function ()
		local P1 = anima.condition(welcome.progress[1], welcome.state, 2)
		local P2 = anima.condition(welcome.progress[2], P1 == 1, 2)

		render.rectangle(0, 0, sw, sh, colors.back:alphen(P1 * 180))

		local size = 400
		render.texture(textures.butterfly, sc.x - size * 0.5, sc.y - size * 0.5, size, size, colors.accent:alphen(P2 * 255))

		if not welcome.completing then
			client.delay_call(3, function () if welcome then welcome.state = false end end)
			welcome.completing = true
		end
	end

	client.delay_call(1, function () callbacks.paint_ui:set(welcome.render) end)
	client.delay_call(6, function ()
		callbacks.paint_ui:unset(welcome.render)
		welcome = nil
	end)
end

-- #endregion

-- #endregion
--


-- #endregion ------------------------------------------------------------------
--

	
configs.system = pui.setup(vars)

end)()