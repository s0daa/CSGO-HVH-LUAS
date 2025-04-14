-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server




-- hysteria • gamesense
----- enQ. 2023




----<  Header  >----------------------------------------------------------------

--------------------------------------------------------------------------------
-- #region: < Header >


--
-- #region : Definitions

-- #region - Dependencies and localization

local pui = true and require "lib.pui" or require "gamesense/pui"

local adata = require "gamesense/antiaim_funcs"
local weapondata = require "gamesense/csgo_weapons"
local http = require "gamesense/http"

--

local assert, collectgarbage, defer, error, getfenv, setfenv, getmetatable, setmetatable,
ipairs, pairs, load, next, printf, rawequal, rawset, rawlen, readfile, require, select,
tonumber, tostring, toticks, totime, type, unpack, pcall, xpcall =
assert, collectgarbage, defer, error, getfenv, setfenv, getmetatable, setmetatable,
ipairs, pairs, load, next, printf, rawequal, rawset, rawlen, readfile, require, select,
tonumber, tostring, toticks, totime, type, unpack, pcall, xpcall

local function C (o)
	if type(o) ~= "table" then return o end
	local res = {} for k, v in pairs(o) do res[C(k)] = C(v) end return res
end

local table, math, string = C(table), C(math), C(string)
local ui, client, config, database, entity, ffi, globals, panorama, plist, renderer, vector
= C(ui), C(client), C(config), C(database), C(entity), C(require "ffi"), C(globals), C(panorama), C(plist), C(renderer), C(require "vector")

-- #endregion

-- #region - Misc

table.find = function (t, j)  for k, v in pairs(t) do if v == j then return k end end return false  end
table.ifind = function (t, j)  for i = 1, #t do if t[i] == j then return i end end  end
table.mfind = function (t, j)  for i = 1, table.maxn(t) do if t[i] == j then return i end end  end

table.ihas = function (t, ...) local arg = {...} for i = 1, table.maxn(t) do for j = 1, #arg do if t[i] == arg[j] then return true end end end return false end

table.distribute = function (t, r, k)  local result = {} for i, v in ipairs(t) do local n = k and v[k] or i result[n] = r == nil and i or v[r] end return result  end

table.copy = C
table.filter = function (t)  local res = {} for i = 1, table.maxn(t) do if t[i] ~= nil then res[#res+1] = t[i] end end return res  end
table.append = function (t, ...)  for i, v in ipairs{...} do table.insert(t, v) end  end
table.place = function (t, path, place)  local p = t for i, v in ipairs(path) do if type(p[v]) == "table" then p = p[v] else p[v] = (i < #path) and {} or place  p = p[v]  end end return t  end

math.e = 2.71828
math.gratio = 1.6180339887
math.round = function (v)  return math.floor(v + 0.5)  end
math.roundb = function (v, d)  return math.floor(v + 0.5) / (d or 0) ^ 1  end
math.clamp = function (a, mn, mx)  return math.min (mx, math.max(a, mn))  end
math.lerp = function (a, b, w)  return a + (b - a) * w  end
math.normalize = {
	yaw = function (yaw) return (yaw + 180) % -360 + 180 end,
	pitch = function (pitch) return math.clamp(pitch, -89, 89) end,
}

string.insert = function (a, b, pos)
    return a:sub(1, pos) .. b .. a:sub(pos + 1)
end

do
	local index = getmetatable"".__index
	index.insert = insert
end


--

local NILFN = function()end
local ternary = function (c, a, b)  if c then return a else return b end  end

local contend = function (func, callback, ...)
	local t = { pcall(func, ...) }
	if not t[1] then return type(callback) == "function" and callback(t[2]) or error(t[2], callback or 2) end
	return unpack(t, 2)
end

--

local enums = {}

-- #endregion

-- #region - hysteria

local obex_t = obex_fetch and obex_fetch() or { username = "enQ", build = "debug", discord = "enQ#1349" }

local hysteria = {
	name = "hysteria",
	version = "1.0",
	build = obex_t.build == "User" and "stable" or string.lower(obex_t.build),
	user = {
		name = obex_t.username,
		avatar = nil
	}
}

local _DEBUG = hysteria.build == "debug"

-- #endregion

-- #region - FFI

ffi.cdef [[
	typedef struct { uint8_t r; uint8_t g; uint8_t b; uint8_t a; } color_t;
]]

-- #endregion

-- #endregion
--

--
-- #region : Helpers

-- #region - Callbacks

local callbacks = {} do
	local event_mt = {
		__call = function (self, bool, fn)
			client[bool and "set_event_callback" or "unset_event_callback"](self[1], fn)
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
		register = function (self, ...)
			for i, v in ipairs{...} do
				client.set_event_callback(self[1], v)
			end
		end,
		deregister = function (self, ...)
			for i, v in ipairs{...} do
				client.unset_event_callback(self[1], v)
			end
		end,
	}	event_mt.__index = event_mt

	setmetatable(callbacks, {
		__index = function (self, key)
			self[key] = setmetatable({key}, event_mt)
			return self[key]
		end,
	})
end

-- #endregion

-- #region - Renderer

local DPI = 1
local sw, sh = client.screen_size()
local sc = {x = sw * 0.5, y = sh * 0.5}

--#region: custom colors

local color = {} do
	local helpers = {
		RGBtoHEX = function (col, short)
			return string.format(short and "%02X%02X%02X" or "%02X%02X%02X%02X", col.r, col.g, col.b, col.a)
		end,
		HEXtoRGB = function (hex)
			hex = hex:gsub("^#", "")
			return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16), tonumber(hex:sub(7, 8), 16) or 255
		end
	}

	local create

	--
	local mt = {
		__eq = function (a, b)
			return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
		end,
		lerp = function (f, t, w)
			return create(f.r + (t.r - f.r) * w, f.g + (t.g - f.g) * w, f.b + (t.b - f.b) * w, f.a + (t.a - f.a) * w)
		end,
		to_hex = helpers.RGBtoHEX,
		alphen = function (self, a)
			return create(self.r, self.g, self.b, a)
		end,
	}	mt.__index = mt

	create = ffi.metatype("color_t", mt)

	--
	color = setmetatable({
		rgb = function (r,g,b,a)
			return create(math.min(r or 255, 255), math.min(g or r or 255, 255), math.min(b or r or 255, 255), math.min(a or 255, 255))
		end,
		hex = function (hex)
			local r,g,b,a = helpers.HEXtoRGB(hex)
			return create(r,g,b,a)
		end
	}, {
		__call = function (self, ...)
			return type(({...})[1]) == "string" and self.hex(...) or self.rgb(...)
		end,
	})
end

--#endregion

--#region: custom renderer

local render = {
	cheap = false
} do
	local alpha = 1
	local astack = {}

	local measurements = setmetatable({}, { __mode = "kv" })

	-- local dpi_ref = ui.reference("MISC", "Settings", "DPI scale")
	-- local dpi_check = function (this)
	-- 	DPI = tonumber(ui.get(this):sub(1, -2)) * 0.01

	-- 	sw, sh = client.screen_size()
	-- 	sw, sh = sw / DPI, sh / DPI
	-- 	sc.x, sc.y = sw * 0.5, sh * 0.5
	-- end; dpi_check(dpi_ref)
	-- ui.set_callback(dpi_ref, dpi_check)

	local blurs = setmetatable({}, {__mode = "kv"})

	client.set_event_callback("paint", function ()
		for i, v in ipairs(blurs) do
			renderer.blur(v[1], v[2], v[3], v[4])
		end
		blurs = {}
	end)
	client.set_event_callback("paint_ui", function ()
		blurs = {}
	end)

	--
	render = setmetatable({
		push_alpha = function (v)
			astack[#astack+1] = v
			alpha = astack[#astack] * (astack[#astack-1] or 1)
		end,
		pop_alpha = function ()
			astack[#astack] = nil
			alpha = #astack == 0 and 1 or astack[#astack] * (astack[#astack-1] or 1)
		end,
		get_alpha = function ()  return alpha  end,

		blur = function (x, y, w, h, a, s)
			if not render.cheap and (a or 1) * alpha > 0.25 then
				blurs[#blurs+1] = {x * DPI, y * DPI, w * DPI, h * DPI}
			end
		end,
		gradient = function (x, y, w, h, c1, c2, dir)
			renderer.gradient(x * DPI, y * DPI, w * DPI, h * DPI, c1.r, c1.g, c1.b, c1.a * alpha, c2.r, c2.g, c2.b, c2.a * alpha, dir or false)
		end,

		line = function (xa, ya, xb, yb, c)
			renderer.line(xa * DPI, ya * DPI, xb * DPI, yb * DPI, c.r, c.g, c.b, c.a * alpha)
		end,
		rectangle = function (x, y, w, h, c, n)
			x, y, w, h, n = x * DPI, y * DPI, w * DPI, h * DPI, (n or 0) * DPI
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
		end,
		rect_outline = function (x, y, w, h, c, n, t)
			x, y, w, h, n, t = x * DPI, y * DPI, w * DPI, h * DPI, (n or 0) * DPI, (t or 1) * DPI
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
		end,

		circle = function (x, y, c, radius, start, percentage)
			renderer.circle(x * DPI, y * DPI, c.r, c.g, c.b, c.a * alpha, radius * DPI, start or 0, percentage or 1)
		end,
		circle_outline = function (x, y, c, radius, start, percentage, thickness)
			renderer.circle(x * DPI, y * DPI, c.r, c.g, c.b, c.a * alpha, radius * DPI, start or 0, percentage or 1, thickness * DPI)
		end,

		load_rgba = function (c, w, h) return renderer.load_rgba(c, w, h) end,
		load_jpg = function (c, w, h) return renderer.load_jpg(c, w, h) end,
		load_png = function (c, w, h) return renderer.load_png(c, w, h) end,
		load_svg = function (c, w, h) return renderer.load_svg(c, w, h) end,
		texture = function (id, x, y, w, h, c, mode)
			if not id then return end
			renderer.texture(id, x * DPI, y * DPI, w * DPI, h * DPI, c.r, c.g, c.b, c.a * alpha, mode or "f")
		end,

		text = function (x, y, c, flags, width, ...)
			renderer.text(x * DPI, y * DPI, c.r, c.g, c.b, c.a * alpha, (flags or ""), width or 0, ...)
		end,
		measure_text = function (flags, text)
			if not text or text == "" then return 0, 0 end
			text = text:gsub("\a%x%x%x%x%x%x%x%x", "")

			flags = (flags or "")

			local key = string.format("<%s>%s", flags, text)
			if not measurements[key] or measurements[key][1] == 0 then
				measurements[key] = { renderer.measure_text(flags, text) }
			end
			return measurements[key][1], measurements[key][2]
			-- return renderer.measure_text(flags, text)
		end,
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

		lerp = function (a, b, speed)
			local c = a + (b - a) * frametime * (speed or 8) * g_speed
			return math.abs(b - c) < 0.005 and b or c
		end,

		condition = function (id, c, s, f)
			local ctx = id[1] and id or animators[id]
			if not ctx then animators[id] = { c and 1 or 0, c }; ctx = animators[id] end

			s = s or 4

			if f then ctx[1] = f end

			ctx[1] = math.clamp(ctx[1] + ( frametime * math.abs(s) * g_speed * (c and 1 or -1) ), 0, 1)

			return (ctx[1] % 1 == 0 or s < 0) and ctx[1] or anima.easings.pow[c and 1 or 3](ctx[1], 3)
		end
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

--#region: base64 (to be improved)

local base64 = {} do
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
			if type(key) == 'string' and key:len() == 64 or key:len() == 65 then
				-- if key is a valid looking base64 alphabet, try to make an encoder/decoder pair from it
				encoders[key], decoders[key] = makeencoder(key)
				return tbl[key]
			end
		end
	}

	setmetatable(encoders, alphabet_mt)
	setmetatable(decoders, alphabet_mt)

	base64.encode = function (str, encoder)
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
	end

	base64.decode = function (b64, decoder)
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
end



--#endregion

--#region: clipboard

local clipboard = {} do
	local char_array = ffi.typeof "char[?]"

	local native = {
		GetClipboardTextCount = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)"),
		SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)"),
		GetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")
	}

	clipboard.get = function ()
		local length = native.GetClipboardTextCount()
		if length == 0 then return end

		local array = char_array(length)

		native.GetClipboardText(0, array, length)
		return ffi.string(array, length - 1)
	end

	clipboard.set = function (text)
		text = tostring(text)
		native.SetClipboardText(text, #text)
	end
end

--#endregion

--#region: print / debug

local printc do
	local native_print = vtable_bind("vstdlib.dll", "VEngineCvar007", 25, "void(__cdecl*)(void*, const color_t&, const char*, ...)")

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

--

hysteria.print = function (...)
	printc("  \vhysteria\r  ", ...)
end

--

local debug = setmetatable({
	warning = function (...)
		printc("  \vhysteria\r  ", ...)
	end,
	error = function (...)
		printc("  \vhysteria\r  ", ...)
		error()
	end
}, {
	__call = function (self, ...)
		if not _DEBUG then return end
		printc("  \vhysteria\r  ", ...)
	end
})

--#endregion

--#region: chat

--[[ local chat = {} do
	local find_hud_element = function(name)
		local p_this = ffi.cast(ffi.typeof('DWORD**'), utils.find_pattern('client.dll', 'B9 ? ? ? ? 68 ? ? ? ? E8 ? ? ? ? 89 46 24') + 1)[0]
		local find_hud = ffi.cast(ffi.typeof('DWORD(__thiscall*)(void*, const char*)'), utils.find_pattern('client.dll', '55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28'))
		return find_hud(p_this, name)
	end

	local chat_element = find_hud_element("CHudChat")
	local chat_vtable = ffi.cast(ffi.typeof('void***'), chat_element)

	chat_print = function (text)
		return ffi.cast('chat_printf', chat_vtable[0][27])(chat_vtable, 0, 0, text)
	end
end ]]

--#endregion

--#region: network

local panorama_api = panorama.open()

local network = {
	open_link = panorama_api.SteamOverlayAPI.OpenExternalBrowserURL,
}

--#endregion

--#region: input

local mouse = { x = 0, y = 0 } do
	local unlock_cursor = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 66, "void(__thiscall*)(void*)")
	local lock_cursor = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 67, "void(__thiscall*)(void*)")

	mouse.lock = function (bool)
		if bool then lock_cursor()
		else unlock_cursor() end
	end

	mouse.in_bounds = function (xa, ya, xb, yb)
		return (mouse.x >= xa and mouse.y >= ya) and (mouse.x <= xb and mouse.y <= yb)
	end

	mouse.pressed = function (key)
		return client.key_state(key or 1)
	end

	callbacks.pre_render:set(function ()
		mouse.x, mouse.y = ui.mouse_position()
	end)
end

--#endregion

-- #endregion

-- #endregion
--

--
-- #region : Features introduction

-- #region - anti-aim

local antiaim = {
	states = {
		{"default", "Default", "D"},
		{"stand", "Standing", "S"},
		{"run", "Running", "R"},
		{"walk", "Walking", "W"},
		{"air", "In-air", "A"},
		{"crouch", "Crouching", "C"},
		{"sneak", "Sneak", "3"},
	},
	presets = {
		-- [1] = antibrute
		custom = {
			[1] = {},
		},
	}
}

enums.states = table.distribute(antiaim.states, nil, 1)

-- #endregion

-- #region - rage, misc, visuals

local rage, misc, visuals = {}, {}, {}

-- #endregion

-- #endregion
--

--
-- #region : Miscellaneous

-- #region - database

local db = {
	key = "hysteria",
	version = 1,
} do
	local data = database.read(db.key)

	if not data then
		data = {
			version = db.version,
			configs = {},
			stats = {},
		}

		database.write(db.key, data)
	end

	--
	do
		local function automemo ()
			debug("autosave")
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

local e_hitgroups = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

-- #endregion

-- #region - cvars

local cvars = setmetatable({}, {
	__index = function (self, key)
		rawset(self, key, cvar[key])
		return rawget(self, key)
	end
})

-- #endregion

-- #endregion
--


-- #endregion ------------------------------------------------------------------
--



--------------------------------------------------------------------------------
-- #region: < Menu >


--
-- #region : GS References

local refs = {
	rage = {
		aimbot = {
			force_baim = pui.reference("RAGE", "Aimbot", "Force body aim"),
			force_sp = pui.reference("RAGE", "Aimbot", "Force safe point"),
			hit_chance = pui.reference("RAGE", "Aimbot", "Minimum hit chance"),
			damage = pui.reference("RAGE", "Aimbot", "Minimum damage"),
			damage_ovr = { pui.reference("RAGE", "Aimbot", "Minimum damage override") },
			double_tap = { pui.reference("RAGE", "Aimbot", "Double tap") },
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
			accent = pui.reference("MISC", "Settings", "Menu color"),
			maxshift = pui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks2")
		}
	}
}

defer(function ()
	pui.traverse(refs,function (ref)
		ref:override()
		ref:set_enabled(true)
		if ref.hotkey then
			ref.hotkey:set_enabled(true)
		end
	end)
end)

-- #endregion
--

--
-- #region : Script menu

-- #region - Base

local P = "\aCDCDCD40•\r  "
-- pui.accent = "74A6A9FF"

local vars = {}

local menu, groups = {
	x = 0, y = 0, w = 0, h = 0,
	set_visible = function (bool, aa)
		pui.traverse(refs.aa, function (r, path)
			if aa and vars.antiaim.global.value and path[1] == "angles" then
				r:set_visible(false)
			else
				r:set_visible(bool == nil and true or bool)
			end
		end)
	end,
	tabs = {
		{"general", "General"},
		{"antiaim", "Anti-aim"},
		{"settings", "Settings"},
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
	space = function (group) return group:label("\n") end
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
	global = groups.fakelag:checkbox( ("\b%s\b%s[hysteria]"):format( pui.accent, pui.accent:sub(1, 6) .. "50" )  ),
	bar = groups.fakelag:label("\aCDCDCD40‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
	tab = groups.fakelag:combobox("\n", table.distribute(menu.tabs, 2)),
	-- menu.space(groups.fakelag),
}

menu.misc = {
	overridden = groups.angles:label("Overridden by \vhysteria")
}

menu.info = {
	user = groups.fakelag:label(" \aCDCDCD40User   \v".. hysteria.user.name),
	version = groups.fakelag:label( (hysteria.build == "stable" and " \aCDCDCD40Version   \v%s" or " \aCDCDCD40Version   \v%s • %s"):format(hysteria.version, hysteria.build) ),
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
		load = groups.angles:button("\vLoad", NILFN),
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
		groups.other:button("Copy authcode", NILFN),
	},
}

-- #endregion

-- #region - Vars

--#region: settings

vars.rage = {
	menu.header(groups.angles, "Ragebot"),
	teleport = menu.feature({groups.angles:checkbox("Auto teleport")}, function (parent)
		return {
			land = groups.angles:checkbox(P .."Ensure landing"),
			button = groups.angles:checkbox(P .."While jump button released"),
			pistol = groups.angles:checkbox(P .."Allow pistols"),
		}, true
	end),
	shiftext = groups.angles:checkbox("Extend shifting", 0x00),
	menu.space(groups.angles)
}

vars.visuals = {
	menu.header(groups.angles, "Visuals"),
	groups.angles:label("Accent color"),
	accent = groups.angles:color_picker("Accent color", colors.accent.r, colors.accent.g, colors.accent.b, 255),
	crosshair = menu.feature(groups.angles:checkbox("Crosshair indicators"), function (parent)
		return {
			style = groups.angles:combobox("\nch_style", {"Classic", "Mini"}),
			logo = groups.angles:checkbox(P .."Butterfly"),
			more = groups.angles:checkbox(P .."Show all features")
		}, true
	end),
	damage = groups.angles:checkbox("Damage indicator"),
	watermark = groups.angles:checkbox("Watermark"),
	menu.space(groups.angles)
}

vars.misc = {
	menu.header(groups.angles, "Miscellaneous"),
	ladder = groups.angles:checkbox("Fast ladder"),
	clantag = groups.angles:checkbox("Clantag"),
	logs = menu.feature(groups.angles:checkbox("Eventlogger"), function (parent)
		return {
			events = groups.angles:multiselect(P .."Events", {"Ragebot shots", "Harming enemies", "Getting harmed", "Anti-aim info"}),
			output = groups.angles:multiselect(P .."Output", {"Console", "Screen"}),
		}, true
	end),
}

--#endregion

--#region: anti-aim

vars.antiaim = {
	global = groups.fakelag:checkbox("Enable"),
	tab = groups.fakelag:combobox("\n", {"General", "Builder", "Anti-bruteforce"}, nil, false),

	general = {
		menu.header(groups.angles, "General"),
		inverter = groups.angles:hotkey("Inverter", false),
		yaw = groups.angles:combobox("Yaw base", {"At targets", "Local view"}),
		manual = menu.feature(groups.angles:checkbox("Manual yaw"), function ()
			return {
				left = groups.angles:hotkey(P .."Left", false, 0),
				right = groups.angles:hotkey(P .."Right", false, 0),
			}, true
		end),
		stab = groups.angles:checkbox("Anti-backstab"),
		use = groups.angles:checkbox("On use AA"),
		warmup = groups.angles:checkbox("Warmup AA"),
		menu.space(groups.angles)
	},
	exploits = {
		menu.header(groups.angles, "Exploits"),
		snap = menu.feature(groups.angles:checkbox("Defensive snap"), function ()
			return {
				yaw = groups.angles:combobox(P .."Yaw", {"None", "180z", "Random", "Wave"}),
				pitch = groups.angles:combobox(P .."Pitch", {"None", "89z", "Random", "Flick"}),
			}, true
		end),
		menu.space(groups.angles)
	},
	lag = {
		menu.header(groups.other, "Lag settings"),
		fakelag = menu.feature(groups.other:checkbox("Fake lag"), function ()
			return {
				mode = groups.other:combobox("\nflmode", {"Dynamic", "Maximum", "Fluctuate"}),
				limit = groups.other:slider(P .."Limit", 1, 15, 14, true, "t")
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

	brute = {}
} do
	local translate = {
		y_off = {"yaw", "offset"},

		mod = {"mod", "type"},
		m_r = {"mod", "range"},
		m_a = {"mod", "add"},
		m_d = {"mod", "degree"},
		m_min = {"mod", "min"},
		m_max = {"mod", "max"},
		m_al = {"mod", "left"},
		m_ar = {"mod", "right"},

		ways = {"ways", "list"},
		w_num = {"ways", "total"},
		w_m = {"ways", "manual"},

		d_on = {"body", "on"},
		d_sw = {"body", "jitter"},
		d_rw = {"body", "relative"},
		d_mode = {"body", "mode"},
		d_d = {"body", "degree"},
		d_l = {"body", "left"},
		d_r = {"body", "right"},
		d_dbase = {"body", "dnm_base"},
		d_dpow = {"body", "dnm_power"},

		r_ir = {"adv", "irreg"},
		r_rs = {"adv", "restrict"},
	}

	for i, v in ipairs(antiaim.states) do
		local id, name, short = v[1], v[2], v[3]
		local p_, _p = "\v"..short.."\r  ", "\n"..short
		vars.antiaim.states[id] = {}
		local ctx = vars.antiaim.states[id]
		--

		if id ~= "default" then
			ctx.override = groups.angles:checkbox("Override \v".. name:lower())
		end

		ctx[#ctx+1] = menu.space(groups.angles)
		ctx[#ctx+1] = menu.header(groups.angles, "Yaw")

		--
		ctx.y_off	= groups.angles:slider("Offset".. _p, -60, 60, 0, true, "°")

		ctx[#ctx+1] = menu.space(groups.angles)
		ctx.mod		= groups.angles:combobox("Modifier".. _p, {"None", "Jitter", "X-way", "Rotate", "Random"})
		ctx.w_m		= groups.angles:checkbox(P .."Manual ways".. _p)
		ctx.m_r		= groups.angles:checkbox(P .."Range".. _p)
		ctx.m_a		= groups.angles:checkbox(P .."Add yaw".. _p)

		--
		ctx.w_num	= groups.angles:slider("\nwnum".. id, 3, 7, 3, true, "-w")
		ctx.w_label = groups.angles:label("Each way" .. _p); ctx.w_label:depend({ctx.mod, "X-way"}, ctx.w_m)
		ctx.w_num:set_callback(function (this) ctx.w_label:set("Each way \aCDCDCD60" .. this.value) end, true)

		ctx.ways = {} for w = 1, 7 do
			ctx.ways[w] = groups.angles:slider("\n"..w..id, -60, 60, 0, true, "°", 1, {[0] = "R"})
			ctx.ways[w]:depend({ctx.mod, "X-way"}, ctx.w_m, {ctx.w_num, w, 7})
		end

		--
		ctx.m_d		= groups.angles:slider("Degree".. _p, -60, 60, 0, true, "°")
		ctx.m_min	= groups.angles:slider("Range \aCDCDCD60min/max".. _p, -60, 60, 0, true, "°")
		ctx.m_max	= groups.angles:slider("\nmodmax".. _p, -60, 60, 0, true, "°")
		ctx.m_al	= groups.angles:slider("Add \aCDCDCD60left/right".. _p, -60, 60, 0, true, "°")
		ctx.m_ar	= groups.angles:slider("\nmodmax".. _p, -60, 60, 0, true, "°")


		--
		ctx[#ctx+1]	= menu.space(groups.angles)
		ctx[#ctx+1]	= menu.header(groups.angles, "Desync")
		ctx.d_on	= groups.angles:checkbox("Body yaw".. _p)
		ctx.d_sw	= groups.angles:checkbox(P .."Jitter".. _p)
		ctx.d_rw	= groups.angles:checkbox(P .."Relative X-way".. _p)
		ctx.d_mode	= groups.angles:combobox("Body yaw mode".. _p, {"Auto", "Default", "Side-based", "Dynamic"})
		ctx.d_d		= groups.angles:slider("\nfootdegree".. id, -180, 180, 0, true, "°")
		ctx.d_l		= groups.angles:slider("Range \aCDCDCD60left/right\nbodyl".. _p, -180, 180, 0, true, "°")
		ctx.d_r		= groups.angles:slider("\nbodyr".. id, -180, 180, 0, true, "°")
		ctx.d_dbase	= groups.angles:slider("Foot base".. _p, -180, 180, 0, true, "°")
		ctx.d_dpow	= groups.angles:slider("Overdrive".. _p, 0, 50, 0, true, "ω", 0.1)

		--
		ctx[#ctx+1]	= menu.header(groups.other, "Advanced")
		ctx.r_ir	= groups.other:slider("Irregularity".. _p, 0, 100, 0, true, "%")
		ctx.r_rs	= groups.other:combobox("Restrict switching".. _p, {"Off", "Silent", "Constant", "Extreme"})

		--
		do
			ctx.d_sw:depend(ctx.d_on)
			ctx.d_mode:depend(ctx.d_on)
			ctx.d_d:depend(ctx.d_on, {ctx.d_mode, "Default"})
			ctx.d_l:depend(ctx.d_on, {ctx.d_mode, "Side-based"})
			ctx.d_r:depend(ctx.d_on, {ctx.d_mode, "Side-based"})
			ctx.d_dbase:depend(ctx.d_on, {ctx.d_mode, "Dynamic"})
			ctx.d_dpow:depend(ctx.d_on, {ctx.d_mode, "Dynamic"})
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

		--
		antiaim.presets.custom[id] = {}
		pui.traverse(ctx, function (ref, path)
			ref:depend({vars.antiaim.builder.state, name}, path[#path] ~= "override" and ctx.override or nil)

			ref:set_callback(function ()
				table.place(antiaim.presets.custom[id], translate[ path[#path] ] or path, ref.value)
			end, true)
		end)
	end

	-- vars.antiaim.builder.state:set_callback(function (this)
	-- 	vars.antiaim.builder[1][1]:set(pui.format "\v•\r  Actions with \v" .. this.value)
	-- end, true)
end

--#endregion

-- #endregion

-- #region - Handle

do
	defer(menu.set_visible)

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
		ref:depend(menu.main.global, {menu.main.tab, "General"})
	end)
	pui.traverse({vars.rage, vars.visuals, vars.misc}, function (ref, path)
		ref:depend(menu.main.global, {menu.main.tab, "Settings"})
	end)
	pui.traverse(vars.antiaim, function (ref, path)
		ref:depend(menu.main.global, {menu.main.tab, "Anti-aim"}, (path[#path] ~= "global") and vars.antiaim.global or nil)

		if path[1] == "global" or path[1] == "tab" then return end

		if path[1] == "builder" or path[1] == "states" then
			ref:depend({vars.antiaim.tab, "Builder"})
		elseif path[1] == "brute" then
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

	vars.visuals.accent:set_callback(function (this)
		local r, g, b = unpack(this.value)
		colors.accent = color.rgb(r, g, b, 255)
		colors.hex = "\a".. colors.accent:to_hex()
	end, true)
end

-- #endregion

-- #endregion
--

--
-- #region : Config system

local configs = {
	system = pui.setup(vars),
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

		local cheat, contents, pad = raw:match "hysteria<(%a+)>([%w%+%/]+)(_*)"

		if cheat ~= "GS" then return "\fNot for gamesense" end

		pad = pad and pad:gsub("_", "=") or ""
		contents = contents:gsub("113PLUS113", "+") or ""
		contents = contents:gsub("143SLASH143", "/") or ""
		contents = base64.decode(contents..pad)

		local name, author, settings = contents:match("%((.*)%)%[(.*)%](%{.+%})")
		return name, author, (noparse ~= true and settings ~= nil) and json.parse(settings) or {}
	end

	actions.save = function (name, new)
		if name == "Default" then return "\fCan't overwrite Default" end
		name = tostring(name)

		local o_name, o_author = new == true and actions.eval(db.configs[name], true) or nil

		local cfg = --[[ new and {} or ]] configs.system:save()
		local contents = ("(%s)[%s]%s"):format(name, o_author or hysteria.user.name, json.stringify( cfg ))
		local encoded = base64.encode(contents):gsub("=", "_"):gsub("+", "113PLUS113"):gsub("/", "143SLASH143")

		local ready = ("hysteria<GS>%s"):format(encoded)
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

		local cfg = copied:match("hysteria<%a+>[%w%+%/]+_*")
		db.configs[name] = cfg
		return "\a".. name .." by ".. author .." added"
	end

	actions.load = function (name, ...)
		if not name or name == "" then return "ERR: can't load: not selected" end
		local cfg = name == "Default" and configs.default or db.configs[name]

		local cname, cauthor, settings = actions.eval(cfg)
		if not cauthor then return cname end

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
-- #region: < Base >


--
-- #region : Me

local my = {
	entity = entity.get_local_player(),
	origin = vector(),
	valid = false,
	threat = client.current_threat(),
	velocity = 0,
} do
	--#region: funcs

	local latest_st, latest_act = 0, 0

	my.get_simtime = function ()
		if not my.valid then return 0, 0 end

		local current = entity.get_prop(my.entity, "m_flSimulationTime")
		local latest = latest_st

		latest_st = current

		return current or 0, latest or 0
	end

	my.get_defensive = function ()
		if not my.valid then return false, false end
		local tickcount = globals.tickcount()

		local current, old = my.get_simtime()
		local difference = toticks(current - old)

		if difference < 0 then
			latest_act = tickcount + math.abs(difference) - toticks(client.latency())
		end

		return latest_act > tickcount, difference < 0
	end

	local get_state = function (cmd)
		if my.on_ground then
			if my.crouching then return enums.states.crouch end
			if my.velocity > 5 then return my.walking and enums.states.walk or enums.states.run
			else return enums.states.stand end
		else
			-- return my.crouching and enums.states.aircrouch or enums.states.air
			return enums.states.air
		end
	end


	--#endregion

	callbacks.run_command:set(function ()
		my.entity = entity.get_local_player()
		my.valid = (my.entity and entity.is_alive(my.entity)) and true or false

		my.threat = my.valid and client.current_threat() or nil
		my.weapon = my.valid and entity.get_player_weapon(my.entity) or nil

		if not my.valid then return end

		my.defensive, my.lagpeek = my.get_defensive()
		local velocity = vector(entity.get_prop(my.entity, "m_vecVelocity"))
		my.velocity = velocity:length2d()

		my.origin = vector(entity.get_prop(my.entity, "m_vecOrigin"))
	end)

	callbacks.pre_render:set(function ()
		my.valid = my.valid and globals.mapname() ~= nil
	end)

	callbacks.net_update_end:set(function ()
		my.entity = entity.get_local_player()
		my.valid = (my.entity and entity.is_alive(my.entity)) and true or false
		my.game_rules = entity.get_game_rules()
	end)

	callbacks.setup_command:set(function (cmd)
		local flags = entity.get_prop(my.entity, "m_fFlags")
		if not flags then return end

		my.side = (cmd.in_moveright == 1) and -1 or (cmd.in_moveleft == 1) and 1 or 0

		my.using = cmd.in_use == 1
		my.on_ground = bit.band(flags, bit.lshift(1, 0)) == 1
		my.jumping = not my.on_ground or (cmd.in_jump == 1)
		my.crouching = cmd.in_duck == 1
		my.walking = my.velocity > 5 and (cmd.in_speed == 1)

		my.state = get_state(cmd)
	end)
end

-- #endregion
--

--
-- #region : Players

local players = {}

callbacks.run_command:set(function ()
	players = entity.get_players()
end)

client.extrapolate = function (x, y, z, velocity, ticks)
	local time = globals.tickinterval() * ticks

	local ex = x + (velocity.x * time)
	local ey = y + (velocity.y * time)
	local ez = z + ((weaken_z and velocity.z - velocity.z * 0.5 or velocity.z) * time)

	return ex, ey, ez
end

-- #endregion
--


-- #endregion ------------------------------------------------------------------
--



--------------------------------------------------------------------------------
-- #region: < Anti-aim >


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

antiaim.data = {
	way = 1, lifetime = 0, using = false,
}

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

			if self.current then return self.buttons[self.current].yaw end
		end
	},
	stab = {
		work = function (self)
			if vars.antiaim.general.stab.value and my.threat and my.entity then
				local threat_hitbox = entity.hitbox_position(my.threat, 3)
				if not threat_hitbox then return end

				local fraction, ent = client.trace_line(my.entity, my.origin.x, my.origin.y + 40, my.origin.z, entity.hitbox_position(my.threat, 3))

				local distance = my.origin:dist( vector(entity.get_prop(my.threat, "m_vecOrigin")) )
				local weapon_t = weapondata(entity.get_player_weapon(my.threat))

				if distance < 300 and ent == my.threat and weapon_t and weapon_t.type == "knife" then return {180, -89} end
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

			return (not block and using) and {180, 0} or nil
		end
	},
	snap = {
		overridden = false,
		work = function (self, cmd, ctx)
			if not vars.antiaim.exploits.snap.on.value or not my.jumping then return end

			if not my.defensive and not my.lagpeek and not cmd.force_defensive then return end

			--
			local time = globals.curtime() * 2
			local settings = vars.antiaim.exploits.snap

			local muls = {
				["180z"] = (time * 5) % 2 - 1,
				["89z"] = (time * 7) % 2 - 1,
				Random = math.random() * 2 - 1,
				Wave = math.sin( math.abs(time * 2 % 2) - 1 ),
			}


			local yaw, pitch = settings.yaw.value, settings.pitch.value

			--
			if muls[yaw] then
				ctx.offset = math.normalize.yaw( muls[yaw] * 90 )
			end
			if muls[pitch] then
				ctx.pitch = math.clamp( muls[pitch] * 89, -89, 89 )
			end
		end
	},
	restrict = {
		work = function (self, cmd, scene)
			if scene.adv.restrict == "Off" then return true end

			local divider = (scene.adv.restrict == "Extreme" and client.random_int(1, 4)) or (scene.adv.restrict == "Constant" and 2) or 1
			local modulus = antiaim.data.lifetime % divider

			if modulus == 2 then cmd.force_defensive = true end

			local long, short = my.get_defensive()

			if modulus == 0 and not (scene.adv.restrict == "Silent" and short) then
				return true
			end

			return false
		end
	},
	fakelag = {
		overridden = false,
		work = function (self, cmd)
			local rctx, hctx = refs.aa.fakelag, vars.antiaim.lag.fakelag

			if hctx.on.value then
				self.overridden = true
			end

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
		end
	}
}

-- #endregion

-- #region - Anti-bruteforce

antiaim.antibrute = {}

-- #endregion

-- #region - Builder

antiaim.builder = {
	yaw = function (self, cmd, scene)
		local use = antiaim.features.on_use:work(cmd) if use then return use[1], use[2], "Local view" end
		local manual = antiaim.features.manual:work() if manual then return manual, nil, "Local view", 1 end
		local stab = antiaim.features.stab:work() if stab then return stab[1], stab[2] end

		return scene.yaw.offset, 89
	end,
	modifier = function (self, scene)
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
		elseif modifier == "X-way" then
			-- if antiaim.my.side ~= 0 and not scene.mod.ws and scene.body.jitter and (antiaim.data.way % 2 == 0) ~= (antiaim.my.side == 1) then
			-- 	antiaim.data.way = antiaim.data.way - 1
			-- end

			antiaim.data.way = antiaim.data.way < (scene.ways.total - 1) and (antiaim.data.way + 1) or 0

			if eachway then
				value = scene.ways[antiaim.data.way+1]
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
		-- local desync = math.normalize.yaw(adata.get_abs_yaw() - adata.get_body_yaw(1))

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

			local cur, old = my.get_simtime()
			local fl = (cur and old) and toticks(cur - old) - 1 or 1

			local max = overlap * (fl < 2 and 70 or 90)

			left, right = modifier * math.gratio - max, modifier * math.gratio + max
		end

		::processed::

		--
		if should_relate then
			side = math.clamp(modifier, -1, 1)
		else
			side = ternary(scene.body.jitter, antiaim.my.switch, vars.antiaim.general.inverter.value) and 1 or -1
		end

		--
		local result = (side == 0 and 0) or (side > 0 and left) or (side < 0 and right)
		antiaim.my.side = (result == 0 and (antiaim.my.switch and 1 or -1)) or (result > 0 and 1) or (result < 0 and -1)

		return result ~= 0 and result + scene.adv.irreg or result
	end,
	work = function (self, cmd, scene, ctx)
		local yaw, pitch, base, flag = self:yaw(cmd, scene)
		local modifier = flag == 1 and 0 or self:modifier(scene)
		local body = self:body(scene, modifier)

		--
		ctx.pitch_mode = "Custom"
		ctx.pitch = pitch or 89

		ctx.base = base or ctx.base
		ctx.offset = math.normalize.yaw(yaw + modifier)

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

antiaim.arrange = function ()
	local state = my.state
	local preset

	if true then
		preset = antiaim.presets.custom
	end

	state = preset[ antiaim.states[ state ][1] ].override and state or enums.states.default

	if state == enums.states.crouch and my.on_ground and my.velocity > 5 and preset.sneak.override then
		state = enums.states.sneak
	end

	antiaim.my.state = antiaim.states[ state ][1]
	preset = preset[antiaim.my.state]

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

	return preset, ctx
end

antiaim.dispatch = function (data)
	for k, v in next, antiaim.refs do
		v:override(data[k])
	end
end

antiaim.manage = function (cmd)
	if cmd.chokedcommands > 0 then return end
	antiaim.data.lifetime = antiaim.data.lifetime + 1

	local scene, ctx = antiaim.arrange()

	--
	antiaim.builder:work(cmd, scene, ctx)

	--
	antiaim.features.snap:work(cmd, ctx)
	antiaim.features.fakelag:work(cmd)

	--
	antiaim.dispatch(ctx)
	if antiaim.features.restrict:work(cmd, scene) then
		antiaim.my.switch = not antiaim.my.switch
	end
end

-- #endregion

-- #region - Finish

antiaim.run = function ()
	vars.antiaim.global:set_callback(function (this)
		callbacks.setup_command(this.value, antiaim.manage)
		refs.aa.angles.enable:override(this.value or nil)

		if not this.value then
			antiaim.revert()
		end
	end, true)

	defer(antiaim.revert)
end

antiaim.revert = function ()
	for k, v in pairs(antiaim.refs) do v:override() end
end

-- #endregion

antiaim.run()

-- #endregion
--


-- #endregion ------------------------------------------------------------------
--



--------------------------------------------------------------------------------
-- #region: < Features >


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
	work = function ()
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
	end,
	run = function (self)
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
	end
}

misc.ladder = {
	work = function (cmd)
		if entity.get_prop(my.entity, "m_MoveType") ~= 9 or cmd.forwardmove == 0 then return end

		local camera_pitch, camera_yaw = client.camera_angles()
		local descending = cmd.forwardmove < 0 or camera_pitch > 45

		cmd.in_moveleft, cmd.in_moveright = descending and 1 or 0, not descending and 1 or 0
		cmd.in_forward, cmd.in_back = descending and 1 or 0, not descending and 1 or 0

		cmd.pitch, cmd.yaw = 89, math.normalize.yaw(cmd.yaw + 90)
	end,
	run = function (self)
		vars.misc.ladder:set_callback(function (this)
			callbacks.setup_command(this.value, self.work)
		end, true)
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
	stack = setmetatable({}, {__mode = "kv"}),
	generic_weapons = {"knife", "c4", "decoy", "flashbang", "hegrenade", "incgrenade", "molotov", "inferno", "smokegrenade"},
	colors = {
		["fear"]		= {"\a000000", "\a000000\x01", "\x01", color.hex("000000")},
		["mismatch"]	= {"\aD59A4D", "\aD59A4D\x01", "\x07", color.hex("D59A4D")},
		["hit"]			= {"\a97AC5A", "\a97AC5A\x01", "\x06", color.hex("97AC5A")},
		["miss"]		= {"\aA67CCF", "\aA67CCF\x01", "\x03", color.hex("A67CCF")},
		["harm"]		= {"\aC65858", "\aC65858\x01", "\x07", color.hex("C65858")},
		["brute"]		= {"\aBFBFBF", "\aBFBFBF\x01", "\x01", color.hex("BFBFBF")},
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

	--
	receive = function (event, target, attacker)
		local self_harm, is_fatal = target == attacker or attacker == 0, event.health == 0
		local weapon, damage, hitbox = event.weapon, event.dmg_health, e_hitgroups[event.hitgroup + 1] or "generic"
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

		if target == my.entity and table.ifind(vars.misc.logs.events.value, "Getting harmed") then
			logger.events.receive(event, target, attacker)
		end
		if attacker == my.entity and target ~= my.entity and table.ifind(vars.misc.logs.events.value, "Harming enemies") then
			logger.events.harm(event, target, attacker)
		end
	end,

	--
	miss = function (shot)
		if not table.ifind(vars.misc.logs.events.value, "Ragebot shots") then return end
		local pre = logger.stack[shot.id] or {}
		--

		local result = "Missed"
		local target = entity.get_player_name(shot.target)

		local reason = shot.reason
		if reason == "prediction error" and pre.difference and pre.difference > 2 then
			reason = "unpredicted occasion"
		end

		local hitgroup = e_hitgroups[shot.hitgroup + 1]

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
		if not table.ifind(vars.misc.logs.events.value, "Ragebot shots") then return end
		local pre = logger.stack[shot.id]
		--

		local result = "Hit"
		if not entity.is_alive(shot.target) then
			result = "Killed"
		end

		local target = entity.get_player_name(shot.target)
		local hitgroup, exp_hitgroup = e_hitgroups[shot.hitgroup + 1], e_hitgroups[pre.hitgroup + 1]

		local dmg_mismatch, hg_mismatch = result == "Hit" and shot.hitgroup ~= pre.hitgroup, result == "Hit" and pre.damage - shot.damage > 10

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
		if not table.ifind(vars.misc.logs.events.value, "Ragebot shots") then return end

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
	if console and table.ifind(vars.misc.logs.output.value, "Console") then
		hysteria.print(console)
	end
	if screen and table.ifind(vars.misc.logs.output.value, "Screen") then
		table.insert(logger.list, 1, {
			event = event,
			text = screen,
			time = globals.realtime(),
			progress = {0},
		})
	end
	if chat then

	end
end

logger.run = function (self)
	vars.misc.logs.on:set_callback(function (this)
		callbacks.aim_fire(this.value, self.events.aim)
		callbacks.aim_hit(this.value, self.events.hit)
		callbacks.aim_miss(this.value, self.events.miss)
		callbacks.player_hurt(this.value, self.events.damage)

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

-- #endregion
--

--
-- #region : Rage

rage.teleport = {
	last = 0, overridden = false,
	last_pos = vector(),
	work = function (cmd, ctx)
		if vars.rage.teleport.button.value and cmd.in_jump == 1 then return end

		local should = false
		local self, settings = rage.teleport, vars.rage.teleport

		if self.overridden then
			refs.rage.aimbot.double_tap[1]:override()
			self.overridden = false
		end

		local charge = adata.get_tickbase_shifting()

		if charge < 8 or self.last == cmd.command_number or my.velocity < 100 or not my.jumping then return end

		--
		local weapon_idx = entity.get_player_weapon(my.entity)
		if not weapon_idx then return end

		local weapon_t = weapondata(weapon_idx)
		local weapon_type = weapon_t.weapon_type_int

		if weapon_t.is_full_auto or (weapon_type == 9 or weapon_type == 0) or (not settings.pistol.value and weapon_type == 1) then return end

		local min_damage = (refs.rage.aimbot.damage_ovr[1].value and refs.rage.aimbot.damage_ovr[1]:get_hotkey()) and refs.rage.aimbot.damage_ovr[2].value or refs.rage.aimbot.damage.value

		--
		local velocity = vector( entity.get_prop(my.entity, "m_vecVelocity") )

		local origin = vector(entity.get_prop(my.entity, "m_vecOrigin"))
		local eye = vector(client.eye_position())
		local peye = vector(client.extrapolate(eye.x, eye.y, eye.z, velocity, charge, true))

		--
		local target = client.current_threat()

		for i, enemy in ipairs(players) do
			if not enemy or not entity.is_enemy(enemy) or not entity.is_alive(enemy) then goto next end

			local distance = origin:dist(vector(entity.get_prop(enemy, "m_vecOrigin")))

			if distance < 400 or enemy == target then
				-- local required_dmg = math.min(min_damage, entity.get_prop(enemy, "m_iHealth"))
				local head = vector(entity.hitbox_position(enemy, 1))

				if client.visible(head.x, head.y, head.z) then should = true break end

				local predicted = { client.trace_bullet(my.entity, peye.x, peye.y, peye.z, head.x, head.y, head.z) }
				local damage = predicted[2] or 0

				if predicted[1] and damage > 0 then
					local opposite = { client.trace_bullet(my.entity, head.x, head.y, head.z, peye.x, peye.y, peye.z) }
					if opposite[2] > 0 then should = true break end
				end
			end

			::next::
		end

		if should then
			if settings.land.value then
				local p_origin = vector( client.extrapolate(origin.x, origin.y, origin.z, velocity, charge) )
				local fraction = client.trace_line(my.entity, p_origin.x, p_origin.y, p_origin.z, p_origin.x, p_origin.y, p_origin.z - 256)

				if not(fraction < (0.15 - weapon_t.inaccuracy_jump) or fraction == 1) then return end
			end
			self.last, self.overridden = cmd.command_number, true

			refs.rage.aimbot.double_tap[1]:override(false)
		end
	end,
	debug = function ()
		local velocity = vector( entity.get_prop(my.entity, "m_vecVelocity") )

		local origin = vector(entity.get_prop(my.entity, "m_vecOrigin"))
		local p_origin = vector(client.extrapolate(origin.x, origin.y, origin.z, velocity, adata.get_tickbase_shifting()))
		local eye = vector(client.eye_position())
		local peye = vector(client.extrapolate(eye.x, eye.y, eye.z, velocity, adata.get_tickbase_shifting(), true))

		local target = client.current_threat()
		if not target then return end

		local head = vector(entity.hitbox_position(target, 0))

		local ex, ey = renderer.world_to_screen(eye:unpack())
		local pex, pey = renderer.world_to_screen(peye:unpack())
		local hx, hy = renderer.world_to_screen(origin:unpack())
		local pox, poy = renderer.world_to_screen(p_origin:unpack())

		-- render.circle(ex, ey, colors.accent, 3)
		-- render.circle(pex, pey, colors.white, 3)
		render.circle(hx, hy, colors.accent, 3)
		render.circle(pox, poy, colors.white, 3)

		-- render.line(pex, pey, hx, hy, rage.teleport.overridden and colors.accent or colors.white)
	end,
	run = function (self)
		vars.rage.teleport.on:set_callback(function (this)
			callbacks.setup_command(this.value, self.work)
			-- callbacks.paint(this.value, self.debug)
		end, true)
	end
}

rage.minor = {
	shift_extend = function (cmd)
		local allowed = vars.rage.shiftext.hotkey:get()
		refs.misc.settings.maxshift:override(allowed and 17 or nil)
	end,
	run = function (self)
		vars.rage.shiftext:set_callback(function (this)
			callbacks.setup_command(this.value, self.shift_extend)
			if not this.value then
				refs.misc.settings.maxshift:override()
			end
		end, true)
	end
}

--

for k, v in pairs(rage) do if v.run then v:run() end end

-- #endregion
--


-- #endregion ------------------------------------------------------------------
--



--------------------------------------------------------------------------------
-- #region: < Screen >


--
-- #region : Utilities

-- #region - Figures

local textures = {
	butterfly = nil,
	corner_h = render.load_svg('<svg width="8" height="8" viewBox="0 0 8 8"><path d="M 8 5.992 L 8 5.992 C 7.99559 3.78599 6.20602 2 4 2 L 0 2 L 0 0 L 4 0 C 5.06087 0 6.07828 0.421427 6.82843 1.17157 C 7.57857 1.92172 8 2.93913 8 4 Z" fill="#fff"/></svg>', 16, 16),
	corner_v = render.load_svg('<svg width="6" height="6" viewBox="0 0 6 6"><path d="m5.872 4h-1.872c-1.0609 0-2.0783-0.42143-2.8284-1.1716-0.75014-0.75015-1.1716-1.7676-1.1716-2.8284l1.2246e-16 -2h2v2c-0.01114 2.1642 1.7086 3.9408 3.872 4z" fill="#fff"/></svg>', 12, 12),
	mini_bfly = render.load_png('\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x09\x00\x00\x00\x09\x08\x06\x00\x00\x00\xE0\x91\x06\x10\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x00\xFD\x49\x44\x41\x54\x18\x57\x63\xE4\xE7\xE7\xEF\xF8\xF8\xF1\x63\x39\x1F\x1F\xDF\xAE\x4F\x9F\x3E\xA5\x33\x30\x30\x3C\x00\x62\x05\x2E\x2E\xAE\xE5\xDF\xBE\x7D\xB3\x00\xCA\x77\x32\x02\x05\xFE\xBF\x7F\xFF\x9E\x61\xC1\x82\x05\x0C\xE5\xE5\xE5\xDF\x7F\xFD\xFA\x95\xC5\xC6\xC6\x36\xB5\xB3\xB3\x93\x2B\x21\x21\x81\x41\x50\x50\x90\x01\xAC\x08\x08\x80\x14\x03\x58\x61\x62\x62\x22\xC3\xFC\xF9\xF3\x19\x40\x0A\x40\x80\x91\x91\x91\x81\x91\x97\x97\xF7\xCD\xA1\x43\x87\x84\x0D\x0C\x0C\xE0\x0A\x61\x0A\x0E\x1C\x38\xC0\x10\x1A\x1A\x7A\x91\x11\xE4\x26\x49\x49\xC9\xBC\xF6\xF6\x76\xCE\x80\x80\x00\xB0\x42\x10\xD8\xB0\x61\x03\x43\x56\x56\xD6\x8F\xE7\xCF\x9F\x67\x82\xAC\x73\x50\x53\x53\xDB\x72\xF3\xE6\x4D\x6E\x90\xE4\x83\x07\x0F\x18\x14\x14\x14\xC0\x0A\x55\x54\x54\x3E\xDD\xBD\x7B\xD7\x1F\xA4\x48\x00\xE8\xB8\x07\xFB\xF6\xED\xE3\x07\x49\xF8\xFA\xFA\xFE\xD9\xBC\x79\x33\x0B\x88\x6D\x6E\x6E\x0E\xF2\x08\x17\x48\x11\x08\x24\xB0\xB3\xB3\x4F\x07\x31\x7E\xFE\xFC\xB9\x12\xC8\x0E\x07\xF9\x06\xA8\xC0\x0A\x28\x74\x01\xA6\x08\xEE\x16\x6C\x0C\x00\x24\xDF\x61\x69\x5D\x69\xDB\x79\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82', 9, 9),
	logo_l = render.load_png("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x1A\x00\x00\x00\x0F\x08\x06\x00\x00\x00\xFA\x51\xDF\xE6\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x02\x69\x49\x44\x41\x54\x38\x4F\xBD\x54\x3D\x88\x92\x71\x18\xFF\xBF\x57\x04\xC7\x09\xBA\x58\xE1\xE2\x3B\x35\xE5\x17\x58\x4E\x0D\xA1\x34\x54\xD0\x20\x09\x22\x4D\x3A\x98\xA3\xC3\xA9\xE0\x39\x34\x08\x1A\x77\x43\x21\x2E\x0A\x92\x25\x74\x20\x74\x58\x8B\xF8\xD2\xE2\x90\x60\x29\x4E\x77\x3A\xA4\x83\x11\xB6\xA8\xDC\x71\x9B\xF6\x7B\x5E\xFF\x7F\xBB\x24\x32\xE2\xB8\x07\x1E\x7C\xBE\xDE\xDF\xEF\xF9\x78\x5F\x25\x76\x41\x22\x5D\x10\x0F\x53\x89\x46\xA3\xD1\x7B\xBD\x5E\xFF\x80\xEC\x7A\xBD\x7E\x74\x07\x02\xF3\xC7\x79\x36\x41\x44\x5B\x7E\xBF\xFF\xD8\xEB\xF5\x32\xA7\xD3\xC9\x02\x81\x00\xCB\xE7\xF3\xE7\x31\xA9\x6F\x3C\x1E\xBF\x6E\x36\x9B\xCC\xE5\x72\x99\x08\xD0\x01\xFD\xD4\xEF\xF7\x99\xD1\x68\x64\x92\x24\xED\xC3\x7F\x46\x83\xAE\x4C\xA5\x87\x7F\x15\x7A\x02\xED\xAF\x4C\x7B\x13\xFE\x9C\xC7\x29\x2F\x0F\x87\xC3\x23\x83\xC1\x70\x25\x9D\x4E\xB3\x48\x24\x22\x11\x11\x01\xEC\xCE\xE7\xF3\x27\x83\xC1\x80\xE9\x74\x3A\xA6\xD5\x6A\x55\x1C\xF8\x4A\xB9\x5C\x3E\x0D\x87\xC3\x0F\x05\x30\x1A\x61\xAD\x56\x8B\x59\xAD\x56\x16\x8F\xC7\xBF\x44\xA3\x51\x8B\x46\xA3\xB9\x24\xF2\x9D\x4E\xE7\x9B\xD9\x6C\x36\x9C\x6D\xA4\xDD\x6E\x2F\x6E\x94\xCD\x66\xBF\x07\x83\xC1\x6B\x64\x53\x07\xDD\x6E\x97\xE5\x72\x39\xBA\xD7\x69\xA1\x50\xD8\xA4\x38\xF9\x8A\xA2\xD0\x1A\x5A\xD3\xE9\xD4\x32\x9B\xCD\x36\x6A\xB5\xDA\x89\xDB\xED\xDE\x2A\x95\x4A\xCC\xE7\xF3\x2D\xB1\x71\x0A\xB5\x9E\x08\x6C\x36\x9B\x1A\x27\x22\x19\x0F\x7C\xA5\xFB\x70\xA0\x65\xC7\xE8\xFE\x10\xF9\x0E\xF2\x1E\x71\x3F\xBB\xDD\x4E\x4D\x5D\x17\xB5\xB8\xC3\x72\x03\x93\xC9\x84\x36\xD2\x46\xBD\x95\xEA\xF9\xDA\xB6\x13\x89\x84\x9B\x88\x9C\xB8\x4F\x8D\xDF\x87\x25\x93\x49\x25\x16\x8B\x39\x39\xD0\x2B\xE4\xCB\x00\x3B\x20\x40\x59\x96\x99\x00\x6E\x34\x1A\xCC\xE1\x70\x30\x31\x0D\xC0\xD5\x97\x29\x95\x4A\x55\xD1\xC8\x3D\x9A\x82\xCE\xD0\xEB\xF5\xA6\xC5\x62\xF1\x50\xCA\x64\x32\xFB\xA1\x50\xE8\x31\x1F\xF3\x25\xF2\x9B\xB8\x57\x40\xEC\x61\x67\x67\xE7\xB3\xC7\xE3\xB1\x98\x4C\xA6\xCB\x14\xA3\xAE\xE9\x86\x98\xF6\x18\x0D\x6A\xA8\x41\x21\xBC\xB9\x32\x48\xDD\x44\x4A\x42\xB8\xD5\x6A\x55\x5D\xDD\x5B\xA8\x87\x17\x3F\xC2\xEF\x2D\x68\x5C\x3C\x8C\x7B\xCC\x2A\x95\xCA\x06\xDD\x40\xEC\x9E\x03\x7E\x44\xCD\xDD\x25\xCB\x2F\xE3\x29\xCC\xEC\x4A\xFC\x0D\x11\xBD\x38\x13\xDC\x83\x4D\x1F\x6A\x14\x4A\xAD\x1A\x30\xDD\xA2\x35\x2E\xE2\x36\x70\x6F\x43\x6F\x40\xE9\xF3\x10\x72\x00\x43\xE1\x31\xF1\x76\x34\xE0\xAB\x44\x7F\x93\x0F\x48\xDE\xFF\x43\xC1\x36\x62\xCF\xD7\x3C\xFB\x5B\x7A\x1D\x11\x4D\x43\x80\x8B\x77\x94\xB1\x16\x74\x17\xFA\x0E\x4A\x1F\xE6\x3F\xCB\x3A\x22\x01\x24\x73\xE0\xFF\xFE\xFF\xFB\x09\x1C\xFB\x05\x79\x31\x12\xE3\x6C\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", 26, 15),
	logo_r = render.load_png("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x18\x00\x00\x00\x0F\x08\x06\x00\x00\x00\xFE\xA4\x0F\xDB\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x02\x08\x49\x44\x41\x54\x38\x4F\xD5\x53\x3D\x68\x5A\x51\x14\x3E\xCF\x60\x97\x24\x28\x11\x87\xB8\xF8\x08\xB5\x60\x92\x16\x25\x85\xBA\x89\x3F\x25\x63\xA1\xA3\xC6\x80\xE8\x50\x02\x5D\x32\xE8\x54\x34\xA3\x42\x3B\xB4\x0E\x19\xD4\x4D\x09\x41\x68\x93\xA9\x50\x95\x62\x07\xC9\x20\x15\x92\x41\x9C\x74\x90\x52\x84\x60\x0B\xA5\x58\x68\x5F\xBF\x73\x73\x1F\x3C\x29\xA4\x20\x64\xC8\x85\x8F\x73\xEE\x79\xE7\x9C\xEF\xBB\x1F\x3C\x85\x6E\xF8\x28\x37\xBC\x9F\xE6\x21\x58\x9C\x4E\xA7\x63\x93\xC9\xF4\xC7\x6C\x36\x2F\xFD\x4F\xE0\x3C\x04\xAF\x35\x4D\x7B\x3E\x1C\x0E\x49\x55\xD5\x27\x20\x38\xBD\x8E\xC4\x48\xB0\x88\x46\x15\xF8\x01\x0C\x0C\x43\x9B\xC8\x35\x79\xE7\xFA\x27\xC0\x2B\xEF\x3B\x88\x15\x99\xDB\x11\x79\x87\x71\x56\x58\xF4\xB4\xDD\x6E\x1F\xF8\x7C\x3E\x5E\x24\x4E\xAD\x56\xEB\x04\x02\x81\x7B\x36\x9B\x6D\xD9\xA8\x6E\x3C\x1E\xFF\xB6\xDB\xED\x0B\x5C\x93\x2F\x08\x23\xFD\x3A\x1A\x8D\x3A\x0E\x87\xE3\x0E\xD7\xBB\xDD\x2E\x79\x3C\x1E\xAA\x56\xAB\x14\x8D\x46\x15\xA5\xDF\xEF\x7F\x77\xB9\x5C\xCB\xF9\x7C\x9E\x90\x53\xB1\x58\x14\x4D\x5E\xAF\x97\x26\x93\x09\x59\x2C\x16\x52\x94\xAB\x87\x26\x12\x09\x0A\x06\x83\x14\x89\x44\x88\xFB\xD3\xE9\xF4\x16\x7A\x3A\xDC\x93\x4C\x26\xA9\x54\x2A\xD1\x60\x30\x20\xAB\xD5\xCA\x78\xCB\xE2\x15\xF8\xA9\x3F\x5F\x2C\xD1\x97\xF3\x32\x26\x93\x4A\x3E\x4B\x5B\xBE\x60\xE1\x2A\xF7\x61\x41\xAB\x52\xA9\xD8\x40\xB6\xD1\x68\x34\x28\x1C\x0E\x1F\x97\xCB\xE5\x87\xF1\x78\x7C\x4D\xDE\x85\x7D\x82\x40\x5F\x6A\xB0\xE3\x55\xBD\x5E\xDF\x0F\x85\x42\xBA\xB2\xFB\xF8\x76\xD1\x6C\x36\xDF\xC3\xBA\xED\x56\xAB\xF5\xCB\xEF\xF7\x1F\xE5\x72\xB9\xDD\x54\x2A\xA5\x8B\x78\x06\xF2\x43\xC3\x8B\x7D\x98\x39\x53\xA0\x42\xE3\x27\x1B\x4F\xA1\x50\xB8\x8C\xC5\x62\x2B\x52\xE9\x39\xE2\x03\xCE\x33\x99\x4C\x3B\x9B\xCD\xF2\xA0\x38\x6C\x1D\x5B\xE2\x74\x3A\xC5\x9D\x95\xB3\x28\x3E\xBD\x5E\xEF\xA7\xDB\xED\x5E\x67\x73\x67\x2C\x92\xB3\x1F\x10\x1F\x03\xDF\x80\x37\xC0\x0B\x59\x7F\x89\xB8\x6F\x10\xD3\x41\xBE\x35\xA3\x6E\xF6\xB2\xC3\x04\x8F\x80\xA8\xAC\xF3\xC2\x8F\xC0\x5D\x60\x43\xD6\x4E\x58\x9C\xCC\x55\xC4\x04\x60\x01\xCE\x80\x77\xC0\x1E\xC0\x16\x0E\x59\x38\xB0\x0D\x4C\x00\x31\x37\xCF\x8F\x76\x8D\xE0\x7F\x3F\xDD\x7E\x82\xBF\x29\x2E\xBB\x8B\x1E\xD2\x13\xD3\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", 24, 15),
}

do
	local load_textures = function (data)
		textures.butterfly = render.load_png(data, 1024, 1024)
		textures.butterfly_s = render.load_png(data, 64, 64)
	end
	local file_texture = readfile("butterfly.png")

	if not file_texture then
		http.get("https://backend.hysteria.one/getfile/butterfly.png", function (success, raw)
			if success and string.sub(raw.body, 2, 4) == "PNG" then
				load_textures(raw.body)
				writefile("butterfly.png", raw.body)
			end
		end)
	else
		load_textures(file_texture)
	end
end

render.logo = function (x, y)
	render.texture(textures.logo_l, x, y, 26, 15, colors.accent)
	render.texture(textures.logo_r, x + 26, y, 24, 15, colors.text)
end

render.edge_v = function (x, y, length, col)
	col = col or colors.accent
	render.texture(textures.corner_v, x, y + 4, 6, -6, col, "f")
	render.rectangle(x, y + 4, 2, length - 8, col)
	render.texture(textures.corner_v, x, y + length - 4, 6, 6, col, "f")
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

-- #region - Drag

local drag do
	local current = nil
	--

	local process = function (self, w, h)
		local menu_open = ui.is_menu_open()

		self.hovered = menu_open and mouse.in_bounds(self.x, self.y, self.x + w, self.y + h) and not mouse.in_bounds(menu.x, menu.y, menu.x + menu.w, menu.y + menu.h)
		local pressed = mouse.pressed()

		if menu_open then
			local alpha = anima.condition("drag::" .. self.id .. ".a", self.hovered or current == self.id, -6)
			render.rectangle(self.x - 2, self.y - 2, w + 4, h + 4, colors.white:alphen( math.lerp(24, 96, alpha) ), 2)
			render.rect_outline(self.x - 2, self.y - 2, w + 4, h + 4, colors.white:alphen( math.lerp(0, 96, alpha) ), 2)
		end

		if current ~= nil and current ~= self.id then return end

		if self.hovered and pressed then
			if current == nil then
				self.dx, self.dy = self.x - mouse.x, self.y - mouse.y
				self.held, current = true, self.id
			end
		end
		if not pressed then
			self.held, current = false, nil
		end

		if self.held then
			local x, y = math.clamp(self.dx + mouse.x, 0, sw - w), math.clamp(self.dy + mouse.y, 0, sh - h)
			ui.set(self.data.x, x); ui.set(self.data.y, y)
		end
	end

	--
	local mt = {
		draw = function (self, fn)
			local w, h = fn(self.x, self.y)
			process(self, w, h)
			return self.x, self.y
		end,
		set_position = function (self, x, y)
			if x then ui.set(self.data.x, x) end
			if y then ui.set(self.data.y, y) end
		end,
	}	mt.__index = mt

	drag = {
		new = function (id, x, y)
			local self = {
				id = id, x = x or 0, y = y or 0,
				hovered = false, held = false, locked = false,
				dx = 0, dy = 0
			}

			self.data = {
				x = ui.new_slider("MISC", "Settings", self.id .."::x", 0, sw, self.x),
				y = ui.new_slider("MISC", "Settings", self.id .."::y", 0, sh, self.y),
			}	ui.set_visible(self.data.x, false); ui.set_visible(self.data.y, false)

			ui.set_callback(self.data.x, function (this) self.x = ui.get(this) end)
			ui.set_callback(self.data.y, function (this) self.y = ui.get(this) end)
			self.x, self.y = ui.get(self.data.x), ui.get(self.data.y)

			return setmetatable(self, mt)
		end
	}

	callbacks.setup_command:set(function (cmd)
		if current then cmd.in_attack = 0 end
	end)
end

-- #endregion

-- #region - Widgets

local widget do
	local mt = {
		lock = function (self, bool) self.lock = bool end,

		update = function (self) return 1 end,
		paint = function (self, x, y, w, h) end,
		draw = function (self)
			self.alpha = self:update()
			render.push_alpha(self.alpha)

			if self.alpha > 0 then
				if self.drag and not self.locked then
					self.x, self.y = self.drag:draw(function () return self.w, self.h end)
				end
				self:paint(self.x, self.y, self.w, self.h)
			end

			render.pop_alpha()
		end,
	}	mt.__index = mt


	widget = {
		new = function (id, x, y, w, h, draggable)
			local self = {
				id = id,
				x = x or 0, y = y or 0, w = w or 0, h = h or 0,
				alpha = 0,
			}

			if draggable then
				self.drag = drag.new(self.id, self.x, self.y)
				self.locked = false
			end

			return setmetatable(self, mt)
		end,
	}
end

-- #endregion

-- #endregion
--

--
-- #region : Crosshair

local crosshair = {
	alpha = 0,
	data = {
		scope = {
			side = 0,
			target = 0,
			reserved = false,
		}
	},
	items = {}
}

-- #region - Indicators

crosshair.enumerate = function (self)
	local x, y = sc.x, sc.y + 24

	local side = crosshair.data.scope.side
	local offset = side * 0.5 + 0.5

	for i, v in ipairs(self.items) do
		v[0] = v[0] or {0}
		render.push_alpha(v[1])
		local s, w, h = v[2](v, x + v.x, y)
		render.pop_alpha()

		v[1] = anima.condition(v[0], s, -8)

		v.x = w * -offset - (side * 16)
		y = y + h * v[1]
	end
end

crosshair.items = {
	{
		0, x = 0, function (self, x, y)
			if self[1] > 0 then
				if vars.visuals.crosshair.logo.value then
					render.texture(textures.butterfly_s, x - 3, y - 10, 32, 32, colors.accent, "f")
				end
				render.rectangle(x, y + 11, 49, 4, colors.black, 2)
				render.gradient(x + 1, y + 12, 47, 2, colors.accent:alphen(64), colors.accent, true)
				render.logo(x, y)
			end

			return vars.visuals.crosshair.style.value == "Classic", 48, 17
		end,
	}, {
		0, x = 0, function (self, x, y)
			local tw, th = render.measure_text("-", "HYSTERIA")
			if vars.visuals.crosshair.logo.value then tw = tw + 7 end

			if self[1] > 0 then
				-- render.rectangle(x + 1, y + 7, tw + 1, 4, colors.black)
				-- render.gradient(x + 2, y + 8, tw - 1, 2, colors.accent:alphen(64), colors.accent, true)
				render.text(x, y, colors.text, "-", nil, "HYSTERIA")
				if vars.visuals.crosshair.logo.value then
					render.texture(textures.mini_bfly, x + tw - 6, y + 1, 9, 9, colors.accent)
				end
			end

			return vars.visuals.crosshair.style.value == "Mini", tw, th + 3
		end,
	}, {
		0, x = 0, function (self, x, y)
			local condition = refs.rage.aimbot.double_tap[1].value and refs.rage.aimbot.double_tap[1]:get_hotkey()
			local extended = vars.rage.shiftext.value and vars.rage.shiftext.hotkey:get()
			local modifier = extended and "DT+ " or "DT "

			if self[1] > 0 then
				local charge, dt = adata.get_tickbase_shifting(), adata.get_double_tap()
				local active = anima.condition(self.fd, not refs.rage.other.duck:get(), -8)

				local progress = colors.hex:sub(1, -3) .. ("%02x"):format(render.get_alpha() * 255) .. string.insert("||||||", ("\aFFFFFF%02x"):format((dt and 96 or 64) * render.get_alpha()), math.min(charge / 12 * 6, 6))
				local text = modifier .. progress

				render.text(x, y, colors.text:alphen(math.lerp(96, 255, active)), "-", nil, text)
			end

			return condition, render.measure_text("-", modifier .. "||||||")
		end, fd = {0},
	}, {
		0, x = 0, function (self, x, y)
			local condition = refs.rage.other.peek.value and refs.rage.other.peek:get_hotkey()
			local dt = adata.get_double_tap()

			local t = "PA"..(dt and "+" or "")

			if self[1] > 0 then
				local ideal = anima.condition(self.ideal, dt, -8)
				render.text(x, y, colors.text:lerp(colors.accent, ideal), "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end, ideal = {0}
	}, {
		0, x = 0, function (self, x, y)
			local is_dt = refs.rage.aimbot.double_tap[1].value and refs.rage.aimbot.double_tap[1]:get_hotkey()
			local condition = refs.aa.other.onshot.value and refs.aa.other.onshot:get_hotkey()
			local inactive = anima.condition(self.a1, not is_dt, 8)

			local t = "OS"

			if self[1] > 0 then
				render.text(x, y, colors.text:alphen(math.lerp(96, 255, inactive)), "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end, a1 = {0},
	}, {
		0, x = 0, function (self, x, y)
			local condition = refs.rage.aimbot.force_baim:get()

			local t = "BA"

			if self[1] > 0 then
				render.text(x, y, colors.text, "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end,
	}, {
		0, x = 0, function (self, x, y)
			local condition = refs.rage.aimbot.force_sp:get()

			local t = "SP"

			if self[1] > 0 then
				render.text(x, y, colors.text, "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end,
	}, {
		0, x = 0, function (self, x, y)
			local condition = vars.visuals.crosshair.more.value and refs.aa.angles.freestand.value and refs.aa.angles.freestand:get_hotkey()

			local t = "FS"

			if self[1] > 0 then
				render.text(x, y, colors.text, "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end,
	}, {
		0, x = 0, function (self, x, y)
			local condition = vars.visuals.crosshair.more.value and refs.misc.ping_spike.value and refs.misc.ping_spike:get_hotkey()

			local t = "PS"

			if self[1] > 0 then
				render.text(x, y, colors.text, "-", nil, t)
			end

			return condition, render.measure_text("-", t)
		end,
	}, {
		0, x = 0, function (self, x, y)
			local condition = vars.visuals.crosshair.more.value and refs.rage.other.duck:get()

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

crosshair.compose = function ()
	crosshair.alpha = anima.condition("crosshair::alpha", my.valid and globals.mapname())

	if my.valid and entity.get_prop(my.entity, "m_bIsScoped") == 1 then
		if not crosshair.data.scope.reserved and my.side ~= 0 then
			crosshair.data.scope.target, crosshair.data.scope.reserved = -my.side, true
		end
	else
		crosshair.data.scope.target, crosshair.data.scope.reserved = 0, false
	end

	crosshair.data.scope.side = anima.lerp(crosshair.data.scope.side, crosshair.data.scope.target, 12)
	-- crosshair.data.scope.side = anima.condition("crosshair::scope", crosshair.data.scope.reserved) * (crosshair.data.scope.reserved and crosshair.data.scope.target or 1)

	--
	render.push_alpha(crosshair.alpha)
	if crosshair.alpha > 0 then
		crosshair:enumerate()
	end
	render.pop_alpha()
end

crosshair.run = function (self)
	vars.visuals.crosshair.on:set_callback(function (this)
		callbacks.paint_ui(this.value, self.compose)

		if not this.value then anima.condition("crosshair::alpha", false, nil, 0) end
	end, true)
end

crosshair:run()

-- #endregion

-- #endregion
--

--
-- #region : HUD

local hud = {}

-- #region - Watermark

hud.watermark = widget.new("watermark", sw - 180, 24, 160, 24)

hud.watermark.items = {
	{
		0, function (self, x, y)
			local t = hysteria.user.name .. (hysteria.build ~= "stable" and (colors.hex .. " — "..hysteria.build) or "")
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
			local text = ("%02d:%02d"):format(hours, minutes)
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
			local text = ("%dms"):format(ping)
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
	local total = 68
	for i, v in ipairs(self.items) do
		render.push_alpha(v[1])
		local state, length = v[2](v, self.x + total, self.y)
		render.pop_alpha()

		v[1] = anima.condition(v[3], state)

		total = total + (length + 2) * v[1]
	end
	self.w = anima.lerp(self.w, total)
end

hud.watermark.update = function (self)
	self.x = sw - (self.w + 24) * self.alpha
	return anima.condition("hud::watermark.alpha", vars.visuals.watermark.value, 3)
end

hud.watermark.paint = function (self, x, y, w, h)
	render.blur(x, y, 64, h, 1, 8)
	render.rounded_side_v(x, y, 64, h, colors.panel.g1, 4)
	render.rectangle(x + 64, y, 2, h, colors.panel.g1)

	render.logo(x + 8, y + 5)
	render.edge_v(x + 64, y, 24)
	self:enumerate()
end

-- #endregion

-- #region - Damage indicator

hud.damage = widget.new("damage", sc.x + 4, sc.y + 4, 6, 4, true)
hud.damage.dmg = refs.rage.aimbot.damage.value
hud.damage.ovr_alpha = 0

hud.damage.update = function (self)
	if not vars.visuals.damage.value then
		return anima.condition("hud::damage.alpha", false, -4)
	end

	local overridden = (refs.rage.aimbot.damage_ovr[1].value and refs.rage.aimbot.damage_ovr[1]:get_hotkey())
	local minimum_damage = overridden and refs.rage.aimbot.damage_ovr[2].value or refs.rage.aimbot.damage.value

	self.dmg = anima.lerp(self.dmg, minimum_damage, 16)
	self.ovr_alpha = anima.condition("hud::damage.ovr_alpha", overridden, -8)

	local weapon_t = my.weapon and weapondata(my.weapon)
	local weapon_valid = weapon_t and weapon_t.weapon_type_int ~= 9 and weapon_t.weapon_type_int ~= 0

	return anima.condition("hud::damage.alpha", my.valid and weapon_valid and globals.mapname(), -8)
end

hud.damage.paint = function (self, x, y, w, h)
	local dmg = math.round(self.dmg)
	dmg = dmg == 0 and "A" or dmg > 100 and ("+" .. (dmg - 100)) or tostring(dmg)

	self.w, self.h = render.measure_text("-", dmg)
	self.h, self.w = self.h - 3, self.w + 1

	render.text(x - 1, y - 2, colors.text:alphen( math.lerp(96, 255, self.ovr_alpha) ), "-", nil, dmg)
end

-- #endregion

-- #region - Logs

hud.logs = {
	dissolve = false,
	part = function (log, offset, progress, condition, i)
		local text = string.gsub(log.text, "[\x01\x02]", {
			["\x01"] = string.format("%02x", progress * render.get_alpha() * 255),
			["\x02"] = string.format("%02x", progress * render.get_alpha() * 128),
		})

		local tw, th = render.measure_text("", text)

		local x, y = sc.x - tw * 0.5 - 18, sc.y + offset
		if not condition then
			x = x + (1 - progress) * (tw * 0.5) * (i % 2 == 0 and -1 or 1)
		end

		render.blur(x, y, 22, 22)
		render.rounded_side_v(x, y, 22, 22, colors.panel.g1, 4)
		render.rectangle(x + 22, y, 2, 22, colors.panel.g1)
		render.edge_v(x + 22, y, 24)

		render.blur(x + 26, y + 1, tw + 14, 22)
		render.rectangle(x + 26, y + 1, tw + 14, 22, colors.panel.l1, 4)

		render.texture(textures.mini_bfly, x + 7, y + 7, 9, 9, colors.accent)
		render.text(x + 33, y + 5, colors.text:alphen(128), nil, nil, text)
	end,
	draw = function (self)
		local y, continue = 160, nil

		for i = 1, #logger.list do
			local v = logger.list[i]
			local ascend = (globals.realtime() - v.time) < 4 and i < 10

			local progress = anima.condition(v.progress, ascend)
			if progress == 0 then continue = i end

			render.push_alpha(progress)
			self.part(v, y, progress, ascend, i)
			render.pop_alpha()

			y = y + 28 * (ascend and progress or 1)
		end

		if continue then
			table.remove(logger.list, continue)
			-- self.dissolve = not self.dissolve
		end
	end
}

-- #endregion

callbacks.paint_ui:set(function ()
	hud.watermark:draw()
	hud.damage:draw()
	hud.logs:draw()
end)

-- #region - Butterfly

if hysteria.build ~= "debug" and not _DEBUG then
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




------------------------------------------------------------------<  2023  >----