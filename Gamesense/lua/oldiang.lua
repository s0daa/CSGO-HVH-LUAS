local fromdb = {username = 'discord.gg/og4leaks'} -- creds to electus

local _DEBUG = true

local assert, defer, error, getfenv, setfenv, getmetatable, setmetatable, ipairs,
pairs, next, pcall, rawequal, rawset, rawlen, readfile, require, select,
tonumber, tostring, type, unpack, xpcall =
assert, defer, error, getfenv, setfenv, getmetatable, setmetatable, ipairs,
pairs, next, pcall, rawequal, rawset, rawlen, readfile, require, select,
tonumber, tostring, type, unpack, xpcall

local function mcopy (o)
	if type(o) ~= "table" then return o end
	local res = {} for k, v in pairs(o) do res[mcopy(k)] = mcopy(v) end return res
end

local table, math, string = mcopy(table), mcopy(math), mcopy(string)
local ui, client = mcopy(ui), mcopy(client)

table.find = function (t, j)  for k, v in pairs(t) do if v == j then return k end end return false  end
table.ifind = function (t, j)  for i = 1, table.maxn(t) do if t[i] == j then return i end end  end
table.qfind = function (t, j)  for i = 1, #t do if t[i] == j then return i end end  end
table.ihas = function (t, ...) local arg = {...} for i = 1, table.maxn(t) do for j = 1, #arg do if t[i] == arg[j] then return true end end end return false end

table.minn = function (t) local s = 0 for i = 1, #t do if t[i] == nil then break end s = s + 1 end return s end
table.filter = function (t)  local res = {} for i = 1, table.maxn(t) do if t[i] ~= nil then res[#res+1] = t[i] end end return res  end
table.append = function (t, ...)  for i, v in ipairs{...} do table.insert(t, v) end  end
table.copy = mcopy

math.max_lerp_low_fps = (1 / 45) * 100
math.clamp = function (x, a, b) if a > x then return a elseif b < x then return b else return x end end
math.vector_lerp = function(start, end_pos, time) local frametime = globals.frametime()*100; time = time * math.min(frametime, math.max_lerp_low_fps); return start:lerp(end_pos, time) end
math.lerp = function(start, end_pos, time) if start == end_pos then return end_pos end local frametime = globals.frametime() * 170; time = time * frametime; local val = start + (end_pos - start) * time; if(math.abs(val - end_pos) < 0.01) then return end_pos end return val end
math.normalize_yaw = function(yaw) yaw = (yaw % 360 + 360) % 360 return yaw > 180 and yaw - 360 or yaw end
local try_require = function (module, msg) local success, result = pcall(require, module) if success then return result else return error(msg) end end
local ternary = function (c, a, b)  if c then return a else return b end  end
local contend = function (func, callback, ...)
	local t = { pcall(func, ...) }
	if not t[1] then return type(callback) == "function" and callback(t[2]) or error(t[2], callback or 2) end
	return unpack(t, 2)
end

local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

local vector = try_require('vector', 'Missing vector')
local images = try_require('gamesense/images', 'Download images library: https://gamesense.pub/forums/viewtopic.php?id=22917')
local ffi = try_require('ffi', 'Failed to require FFI, please make sure Allow unsafe scripts is enabled!')
local antiaim_funcs = try_require('gamesense/antiaim_funcs', 'Download anti-aim functions library: https://gamesense.pub/forums/viewtopic.php?id=29665')
local c_entity = try_require('gamesense/entity', 'Download entity library: https://gamesense.pub/forums/viewtopic.php?id=27529')
local http = try_require('gamesense/http', 'Download HTTP library: https://gamesense.pub/forums/viewtopic.php?id=21619')
local clipboard = try_require('gamesense/clipboard', 'Download clipboard library: https://gamesense.pub/forums/viewtopic.php?id=28678')
local base64 = try_require('gamesense/base64', 'Module base64 not found')

local dirs = {
	execute = function (t, path, func)
		local p, k for _, s in ipairs(path) do
			k, p, t = s, t, t[s]
			if t == nil then return end
		end
		if p[k] then func(p[k]) end
	end,
	replace = function (t, path, value)
		local p, k for _, s in ipairs(path) do
			k, p, t = s, t, t[s]
			if t == nil then return end
		end
		p[k] = value
	end,
	find = function (t, path)
		local p, k for _, s in ipairs(path) do
			k, p, t = s, t, t[s]
			if t == nil then return end
		end
		return p[k]
	end,
}

dirs.pave = function (t, place, path)
    local p = t for i, v in ipairs(path) do
        if type(p[v]) == "table" then p = p[v]
        else p[v] = (i < #path) and {} or place  p = p[v]  end
    end return t
end

dirs.extract = function (t, path)
	if not path or #path == 0 then return t end
    local j = dirs.find(t, path)
    return dirs.pave({}, j, path)
end

local ui_handler, ui_handler_mt, methods_mt = {}, {}, {
	element = {}, group = {}
}

local elements = {
	button		= { type = "function",	arg = 2, unsavable = true },
	checkbox	= { type = "boolean",	arg = 1, init = false	},
	color_picker= { type = "table",		arg = 5 },
	combobox	= { type = "string",	arg = 2, variable = true },
	hotkey		= { type = "table",		arg = 3, enum = {[0] = "Always on", "On hotkey", "Toggle", "Off hotkey"} },
	label		= { type = "string",	arg = 1, unsavable = true },
	listbox		= { type = "number",	arg = 2, init = 0, variable = true },
	multiselect	= { type = "table",		arg = 2, init = {}, variable = true },
	slider		= { type = "number",	arg = 8 },
	textbox		= { type = "string",	arg = 1, init = "" },
	string		= { type = "string",	arg = 2, init = "" },
	unknown		= { type = "string",	arg = 2, init = "" } -- new_string type
}

local weapons = { "Global", "G3SG1 / SCAR-20", "SSG 08", "AWP", "R8 Revolver", "Desert Eagle", "Pistol", "Zeus", "Rifle", "Shotgun", "SMG", "Machine gun" }

local registry, ragebot, players = {}, {}, {} do
	client.set_event_callback("shutdown", function ()
		for k, v in next, registry do
			if v.__ref and not v.__rage then
				if v.overridden then ui.set(k, v.original) end
				ui.set_enabled(k, true)
				ui.set_visible(k, not v.__hidden)
			end
		end
		ragebot.cycle(function (active)
			for k, v in pairs(ragebot.context[active]) do
				if v ~= nil and registry[k].overridden then
					ui.set(k, v)
				end
			end
		end, true)
	end)
	client.set_event_callback("pre_config_save", function ()
		for k, v in next, registry do
			if v.__ref and not v.__rage and v.overridden then v.ovr_restore = {ui.get(k)}; ui.set(k, v.original) end
		end
		ragebot.cycle(function (active)
			for k, v in pairs(ragebot.context[active]) do if registry[k].overridden then ragebot.cache[active][k] = ui.get(k); ui.set(k, v) end end
		end, true)
	end)
	client.set_event_callback("post_config_save", function ()
		for k, v in next, registry do
			if v.__ref and not v.__rage and v.overridden then ui.set(k, unpack(v.ovr_restore)); v.ovr_restore = nil end
		end
		ragebot.cycle(function (active)
			for k, v in pairs(ragebot.context[active]) do
				if registry[k].overridden then ui.set(k, ragebot.cache[active][k]); ragebot.cache[active][k] = nil end
			end
		end, true)
	end)
end

local elemence = {} do
	local callbacks = function (this, isref)
		if this.name == "Weapon type" and string.lower(registry[this.ref].tab) == "rage" then return ui.get(this.ref) end

		ui.set_callback(this.ref, function (self)
			if registry[self].__rage and ragebot.silent then return end
			for i = 0, #registry[self].callbacks, 1 do
				if type(registry[self].callbacks[i]) == "function" then registry[self].callbacks[i](this) end
			end
		end)

		if this.type == "button" then return
		elseif this.type == "color_picker" or this.type == "hotkey" then
			registry[this.ref].callbacks[0] = function (self) this.value = { ui.get(self.ref) } end
			return { ui.get(this.ref) }
		else
			registry[this.ref].callbacks[0] = function (self) this.value = ui.get(self.ref) end
			if this.type == "multiselect" then
				this.value = ui.get(this.ref)
				registry[this.ref].callbacks[1] = function (self)
					registry[this.ref].options = {}
					for i = 1, #self.value do registry[this.ref].options[ self.value[i] ] = true end
				end
				registry[this.ref].callbacks[1](this)
			end
			return ui.get(this.ref)
		end
	end

	elemence.new = function (ref, add)
		local self = {}; add = add or {}

		self.ref = ref
		self.name, self.type = ui.name(ref), ui.type(ref)

		--
		registry[ref] = registry[ref] or {
			type = self.type, ref = ref, tab = add.__tab, container = add.__container,
			__ref = add.__ref, __hidden = add.__hidden, __init = add.__init, __list = add.__list, __rage = add.__rage,
			__plist = add.__plist and not (self.type == "label" or self.type == "button" or self.type == "hotkey"),

			overridden = false, original = self.value, donotsave = add.__plist or false,
			callbacks = { [0] = add.__callback }, events = {}, depend = { [0] = {ref}, {}, {} },
		}

		registry[ref].self = setmetatable(self, methods_mt.element)
		self.value = callbacks(self, add.__ref)

		if add.__rage then
			methods_mt.element.set_callback(self, ragebot.memorize)
		end
		if registry[ref].__plist then
			players.elements[#players.elements+1] = self
			methods_mt.element.set_callback(self, players.slot_update, true)
		end

		return self
	end

	elemence.group = function (...)
		return setmetatable({ ... }, methods_mt.group)
	end

	elemence.string = function (name, default)
		local this = {}

		this.ref = ui.new_string(name, default or "")
		this.type = "string"
		this[0] = {savable = true}

		return setmetatable(this, methods_mt.element)
	end

	elemence.features = function (self, args)
		do
			local addition
			local v, kind = args[1], type(args[1])

			if not addition and (kind == "table" or kind == "cdata") and not v.r then
				addition = "color"
				local r, g, b, a = v[1] or 255, v[2] or 255, v[3] or 255, v[4] or 255
				self.color = elemence.new( ui.new_color_picker(registry[self.ref].tab, registry[self.ref].container, self.name, r, g, b, a), {
					__init = { r, g, b, a },
					__plist = registry[self.ref].__plist
				} )
			elseif not addition and (kind == "table" or kind == "cdata") and v.r then
				addition = "color"
				self.color = elemence.new( ui.new_color_picker(registry[self.ref].tab, registry[self.ref].container, self.name, v.r, v.g, v.b, v.a), {
					__init = { v.r, v.g, v.b, v.a },
					__plist = registry[self.ref].__plist
				} )
			elseif not addition and kind == "number" then
				addition = "hotkey"
				self.hotkey = elemence.new( ui.new_hotkey(registry[self.ref].tab, registry[self.ref].container, self.name, true, v, {
					__init = v
				}) )
			end
			registry[self.ref].depend[0][2] = addition and self[addition].ref
			registry[self.ref].__addon = addition
		end
		do
			registry[self.ref].donotsave = args[2] == false
		end
	end

	elemence.memorize = function (self, path, origin)
		if registry[self.ref].donotsave then return end

		if not elements[self.type].unsavable then
			dirs.pave(origin, self.ref, path)
		end

		if self.color then
			path[#path] = path[#path] .. "_c"
			dirs.pave(origin, self.color.ref, path)
		end
		if self.hotkey then
			path[#path] = path[#path] .. "_h"
			dirs.pave(origin, self.hotkey.ref, path)
		end
	end

	elemence.hidden_refs = {
		"Unlock hidden cVars", "Allow custom game events", "Faster grenade toss",
		"sv_maxunlag", "sv_maxusrcmdprocessticks", "sv_clockcorrection_msecs",
	}

	local cases = {
		combobox = function (v)
			if v[3] == true then
				return v[1].value ~= v[2]
			else
				for i = 2, #v do
					if v[1].value == v[i] then return true end
				end
			end
			return false
		end,
		listbox = function (v)
			if v[3] == true then
				return v[1].value ~= v[2]
			else
				for i = 2, #v do
					if v[1].value == v[i] then return true end
				end
			end
			return false
		end,
		multiselect = function (v)
			return table.ihas(v[1].value, unpack(v, 2))
		end,
		slider = function (v)
			return v[2] <= v[1].value and v[1].value <= (v[3] or v[2])
		end,
	}

	local depend = function (v)
		local condition = false

		if type(v[2]) == "function" then
			condition = v[2]( v[1] )
		else
			local f = cases[v[1].type]
			if f then condition = f(v)
			else condition = v[1].value == v[2] end
		end

		return condition and true or false
	end

	elemence.dependant = function (owner, dependant, dis)
		local count = 0

		for i = 1, #owner do
			if depend(owner[i]) then count = count + 1 else break end
		end

		local allow, action = count >= #owner, dis and "set_enabled" or "set_visible"

		for i, v in ipairs(dependant) do ui[action](v, allow) end
	end
end

local gamesense_aa = {
	enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
    pitch = { ui.reference('AA', 'Anti-aimbot angles', 'Pitch') },
    roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
    yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') },
    fakelag_limit = ui.reference('AA', 'Fake lag', 'Limit'),
    freestanding_body_yaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    yaw_jitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
    body_yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
    freestanding = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
	roll_aa = ui.reference('AA', 'Anti-aimbot angles', 'Roll')
}

local utils, rage = {}, {}

rage.antiaim = {
	override_hidden_pitch = function(self, value)
		ui.set(gamesense_aa['pitch'][1], 'Custom')
		ui.set(gamesense_aa['pitch'][2], value)
	end
}

do
	utils.hide_aa_tab = function (boolean)
		ui.set_visible(gamesense_aa.enabled, not boolean)
        ui.set_visible(gamesense_aa.pitch[1], not boolean)
        ui.set_visible(gamesense_aa.pitch[2], not boolean)
        ui.set_visible(gamesense_aa.roll, not boolean)
        ui.set_visible(gamesense_aa.yaw_base, not boolean)
        ui.set_visible(gamesense_aa.yaw[1], not boolean)
        ui.set_visible(gamesense_aa.yaw[2], not boolean)
        ui.set_visible(gamesense_aa.yaw_jitter[1], not boolean)
        ui.set_visible(gamesense_aa.yaw_jitter[2], not boolean)
        ui.set_visible(gamesense_aa.body_yaw[1], not boolean)
        ui.set_visible(gamesense_aa.body_yaw[2], not boolean)
        ui.set_visible(gamesense_aa.freestanding[1], not boolean)
        ui.set_visible(gamesense_aa.freestanding[2], not boolean)
        ui.set_visible(gamesense_aa.freestanding_body_yaw, not boolean)
        ui.set_visible(gamesense_aa.edge_yaw, not boolean)
	end

	utils.time_to_ticks = function(t)
		return math.floor(0.5 + (t / globals.tickinterval()))
	end

	utils.rgb_to_hex = function(color)
		return string.format("%02X%02X%02X%02X", color[1], color[2], color[3], color[4] or 255)
	end

	utils.animate_text = function(time, string, r, g, b, a, r1, g1, b1, a1)
		local t_out, t_out_iter = {}, 1
		local l = string:len() - 1
	
		local r_add = (r1 - r)
		local g_add = (g1 - g)
		local b_add = (b1 - b)
		local a_add = (a1 - a)
	
		for i = 1, #string do
			local iter = (i - 1)/(#string - 1) + time
			t_out[t_out_iter] = "\a" .. utils.rgb_to_hex({r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter ))})
	
			t_out[t_out_iter+1] = string:sub(i, i)
			t_out_iter = t_out_iter + 2
		end
	
		return table.concat(t_out)
	end

	utils.hex_to_rgb = function (hex)
		hex = hex:gsub("^#", "")
		return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16), tonumber(hex:sub(7, 8), 16) or 255
	end

	utils.gradient_text = function (text, colors, precision)
		local symbols, length = {}, #string.gsub(text, ".[\128-\191]*", "a")
		local s = 1 / (#colors - 1)
		precision = precision or 1

		local i = 0
		for letter in string.gmatch(text, ".[\128-\191]*") do
			i = i + 1

			local weight = i / length
			local cw = weight / s
			local j = math.ceil(cw)
			local w = (cw / j)
			local L, R = colors[j], colors[j+1]

			local r = L[1] + (R[1] - L[1]) * w
			local g = L[2] + (R[2] - L[2]) * w
			local b = L[3] + (R[3] - L[3]) * w
			local a = L[4] + (R[4] - L[4]) * w

			symbols[#symbols+1] = ((i-1) % precision == 0) and ("\a%02x%02x%02x%02x%s"):format(r, g, b, a, letter) or letter
		end

		symbols[#symbols+1] = "\aCDCDCDFF"

		return table.concat(symbols)
	end

	local gradients = function (col, text)
		local colors = {}; for w in string.gmatch(col, "\b%x+") do
			colors[#colors+1] = { utils.hex_to_rgb( string.sub(w, 2) ) }
		end
		if #colors > 0 then return utils.gradient_text(text, colors, #text > 8 and 2 or 1) end
	end

	utils.format = function (s)
		if type(s) == "string" then
			s = string.gsub(s, "\f<(.-)>", ui_handler.macros)
			s = string.gsub(s, "[\v\r\t]", {["\v"] = "\a".. ui_handler.accent, ["\r"] = "\aCDCDCDFF", ["\t"] = "    "})
			s = string.gsub(s, "([\b%x]-)%[(.-)%]", gradients)
		end return s
	end

	utils.unpack_color = function (...)
		local arg = {...}
		local kind = type(arg[1])

		if kind == "table" or kind == "cdata" or kind == "userdata" then
			if arg[1].r then
				return {arg[1].r, arg[1].g, arg[1].b, arg[1].a}
			elseif arg[1][1] then
				return {arg[1][1], arg[1][2], arg[1][3], arg[1][4]}
			end
		end

		return arg
	end

	local dispensers = {
		color_picker = function (args)
			args[1] = string.sub(utils.format(args[1]), 1, 117)

			if type(args[2]) ~= "number" then
				local col = args[2]
				args.n, args.req, args[2] = args.n + 3, args.req + 3, col.r
				table.insert(args, 3, col.g)
				table.insert(args, 4, col.b)
				table.insert(args, 5, col.a)
			end

			for i = args.req + 1, args.n do
				args.misc[i - args.req] = args[i]
			end

			args.data.__init = {args[2] or 255, args[3] or 255, args[4] or 255, args[5] or 255}
		end,
		listbox = function (args, variable)
			args[1] = string.sub(utils.format(args[1]), 1, 117)
			for i = args.req + 1, args.n do
				args.misc[i - args.req] = args[i]
			end

			args.data.__init, args.data.__list = 0, not variable and args[2] or {unpack(args, 2, args.n)}
		end,
		combobox = function (args, variable)
			args[1] = string.sub(utils.format(args[1]), 1, 117)
			for i = args.req + 1, args.n do
				args.misc[i - args.req] = args[i]
			end

			args.data.__init, args.data.__list = not variable and args[2][1] or args[2], not variable and args[2] or {unpack(args, 2, args.n)}
		end,
		multiselect = function (args, variable)
			args[1] = string.sub(utils.format(args[1]), 1, 117)
			for i = args.req + 1, args.n do
				args.misc[i - args.req] = args[i]
			end

			args.data.__init, args.data.__list = {}, not variable and args[2] or {unpack(args, 2, args.n)}
		end,
		slider = function (args)
			args[1] = string.sub(utils.format(args[1]), 1, 117)

			for i = args.req + 1, args.n do
				args.misc[i - args.req] = args[i]
			end

			args.data.__init = args[4] or args[2]
		end,
		button = function (args)
			args[2] = args[2] or function()end
			args[1] = string.sub(utils.format(args[1]), 1, 117)
			args.n, args.data.__callback = 2, args[2]
		end
	}

	utils.dispense = function (key, raw, ...)
		local args, group, ctx = {...}, {}, elements[key]

		if type(raw) == "table" then
			group[1], group[2] = raw[1], raw[2]
			group.__plist = raw.__plist
		else
			group[1], group[2] = raw, args[1]
			table.remove(args, 1)
		end

		args.n, args.data = table.maxn(args), {
			__tab = group[1], __container = group[2],
			__plist = group.__plist and true or nil
		}

		local variable = (ctx and ctx.variable) and type(args[2]) == "string"
		args.req, args.misc = not variable and ctx.arg or args.n, {}

		if dispensers[key] then
			dispensers[key](args, variable)
		else
			for i = 1, args.n do
				if type(args[i]) == "string" then
					args[i] = string.sub(utils.format(args[i]), 1, 117)
				end

				if i > args.req then args.misc[i - args.req] = args[i] end
			end
			args.data.__init = ctx.init
		end

		return args, group
	end
end

local render = renderer

do
	render.rec = function(x, y, w, h, radius, color)
        radius = math.min(x/2, y/2, radius)
        local r, g, b, a = unpack(color)
        renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
        renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
    end

	render.rec_outline = function(x, y, w, h, radius, thickness, color)
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
    end

	render.shadow = function(x, y, w, h, width, rounding, accent, accent_inner)
		local thickness = 1
		local Offset = 1
		local r, g, b, a = unpack(accent)
		if accent_inner then
			render.rec(x, y, w, h + 1, rounding, accent_inner)
		end
		for k = 0, width do
			if a * (k/width)^(1) > 5 then
				local accent = {r, g, b, a * (k/width)^(2)}
				render.rec_outline(x + (k - width - Offset)*thickness, y + (k - width - Offset) * thickness, w - (k - width - Offset)*thickness*2, h + 1 - (k - width - Offset)*thickness*2, rounding + thickness * (width - k + Offset), thickness, accent)
			end
		end
	end
end

ui_handler.macros = setmetatable({}, {
	__newindex = function (self, key, value) rawset(self, tostring(key), value) end,
	__index = function (self, key) return rawget(self, tostring(key)) end
})

ui_handler.accent, ui_handler.menu_open = nil, ui.is_menu_open()

do
	local reference = ui.reference("MISC", "Settings", "Menu color")
	ui_handler.accent = utils.rgb_to_hex{ ui.get(reference) }
	local previous = ui_handler.accent

	ui.set_callback(reference, function ()
		local color = { ui.get(reference) }
		ui_handler.accent = utils.rgb_to_hex(color)

		for idx, ref in next, registry do
			if ref.type == "label" and not ref.__ref then
				local new, count = string.gsub(ref.self.value, previous, ui_handler.accent)
				if count > 0 then
					ui.set(idx, new)
					ref.self.value = new
				end
			end
		end
		previous = ui_handler.accent
		client.fire_event("ui_handler::accent_color", color)
	end)
end

client.set_event_callback("paint_ui", function ()
	local state = ui.is_menu_open()
	if state ~= ui_handler.menu_open then
		client.fire_event("ui_handler::menu_state", state)
		ui_handler.menu_open = state
	end
end)

ui_handler.group = function (tab, container) return elemence.group(tab, container) end

ui_handler.format = utils.format

ui_handler.reference = function (tab, container, name)
	local found = { contend(ui.reference, 3, tab, container, name) }
	local total, hidden = #found, false

	-- done on purpose, don't blame me
	if string.lower(tab) == "misc" and string.lower(container) == "settings" then
		for i, v in ipairs(elemence.hidden_refs) do
			if string.find(name, "^" ..v) then hidden = true break end
		end
	end

	for i, v in ipairs(found) do
		found[i] = elemence.new(v, {
			__ref = true, __hidden = hidden or nil,
			__tab = tab, __container = container,
			__rage = container == "Aimbot" or nil,
		})
	end

	if total > 1 then local shift = 0
		for i = 1, total > 4 and total or 4, 2 do
			local m, j = i - shift, i + 1 - shift
			if found[j] and (found[j].type == "hotkey" or found[j].type == "color_picker") then
				local addition = found[j].type == "color_picker" and "color" or "hotkey"
				registry[ found[m].ref ].__addon, found[m][addition] = addition, found[j]

				table.remove(found, j) shift = shift + 1
			end
		end return unpack(found)
	else return found[1] end
end

ui_handler.traverse = function (t, f, p)
	p = p or {}

	if type(t) == "table" and t.__name ~= "ui_handler::element" and t[#t] ~= "~" then
		for k, v in next, t do
			local np = table.copy(p); np[#np+1] = k
			ui_handler.traverse(v, f, np)
		end
	else
		f(t, p)
	end
end

do
	local save = function (config, ...)
		local packed = {}

		ui_handler.traverse(dirs.extract(config, {...}), function (ref, path)
			local value
			local etype = registry[ref].type

			if etype == "color_picker" then
				value = "#".. utils.rgb_to_hex{ ui.get(ref) }
			elseif etype == "hotkey" then
				local _, mode, key = ui.get(ref)
				value = {mode, key or 0}
			else
				value = ui.get(ref)
			end

			if type(value) == "table" then value[#value+1] = "~" end
			dirs.pave(packed, value, path)
		end)
		
		return packed
	end

	local load = function (config, package, ...)
		if not package then return end

		local packed = dirs.extract(package, {...})
		ui_handler.traverse(dirs.extract(config, {...}), function (ref, path)
			pcall(function ()
				local value, proxy = dirs.find(packed, path), registry[ref]
				local vtype, etype = type(value), proxy.type
				local object = elements[etype]

				if vtype == "string" and value:sub(1, 1) == "#" then
					value, vtype = { utils.hex_to_rgb(value) }, "table"
				elseif vtype == "table" and value[#value] == "~" then
					value[#value] = nil
				end

				if etype == "hotkey" and value and type(value[1]) == "number" then
					value[1] = elements.hotkey.enum[ value[1] ]
				end

				if object and object.type == vtype then
					if vtype == "table" and etype ~= "multiselect" then
						ui.set(ref, unpack(value))
						if etype == "color_picker" then methods_mt.element.invoke(proxy.self) end
					else
						ui.set(ref, value)
					end
				else
					if proxy.__init then ui.set(ref, proxy.__init) end
				end
			end)
		end)
	end

	--
	local package_mt = {
		__type = "ui_handler::package", __metatable = false,
		__call = function (self, raw, ...)
			return (type(raw) == "table" and load or save)(self[0], raw, ...)
		end,
		save = function (self, ...) return save(self[0], ...) end,
		load = function (self, ...) load(self[0], ...) end,
	}	package_mt.__index = package_mt

	ui_handler.setup = function (t)
		local package = { [0] = {} }
		ui_handler.traverse(t, function (r, p) elemence.memorize(r, p, package[0]) end)
		return setmetatable(package, package_mt)
	end
end

methods_mt.element = {
	__type = "ui_handler::element", __name = "ui_handler::element", __metatable = false,
	__eq = function (this, that) return this.ref == that.ref end,
	__tostring = function (self) return string.format('ui_handler.%s[%d] "%s"', self.type, self.ref, self.name) end,
	__call = function (self, ...) if #{...} > 0 then ui.set(self.ref, ...) else return ui.get(self.ref) end end,

	depend = function (self, ...)
		local arg = {...}
		local disabler = arg[1] == true

		local depend = registry[self.ref].depend[disabler and 2 or 1]
		local this = registry[self.ref].depend[0]

		for i = (disabler and 2 or 1), table.maxn(arg) do
			local v = arg[i]
			if v then
				if v.__name == "ui_handler::element" then v = {v, true} end
				depend[#depend+1] = v

				local check = function () elemence.dependant(depend, this, disabler) end
				check()

				registry[v[1].ref].callbacks[#registry[v[1].ref].callbacks+1] = check
			end
		end

		return self
	end,

	override = function (self, value)
		local is_hk = self.type == "hotkey"
		local ctx, wctx = registry[self.ref], ragebot.context[ragebot.ref.value]

		if value ~= nil then
			if not ctx.overridden then
				if is_hk then self.value = { ui.get(self.ref) } end
				if ctx.__rage then wctx[self.ref] = self.value else ctx.original = self.value end
			end ctx.overridden = true
			if is_hk then ui.set(self.ref, value[1], value[2]) else ui.set(self.ref, value) end
			if ctx.__rage then ctx.__ovr_v = value end
		else
			if ctx.overridden then
				local original = ctx.original if ctx.__rage then original, ctx.__ovr_v = wctx[self.ref], nil end
				if is_hk then ui.set(self.ref, elements.hotkey.enum[original[2]], original[3] or 0)
				else ui.set(self.ref, original) end ctx.overridden = false
			end
		end
	end,
	get_original = function (self)
		if registry[self.ref].__rage then
			if registry[self.ref].overridden then return ragebot.context[ragebot.ref.value][self.ref] else return self.value end
		else
			if registry[self.ref].overridden then return registry[self.ref].original else return self.value end
		end
	end,

	set = function (self, ...)
		if self.type == "color_picker" then
			ui.set(self.ref, unpack(utils.unpack_color(...)) )
			methods_mt.element.invoke(self)
		elseif self.type == "label" then
			local t = utils.format(...)
			ui.set(self.ref, t)
			self.value = t
		else
			ui.set(self.ref, ...)
		end
	end,
	get = function (self, value)
		if value and self.type == "multiselect" then
			return registry[self.ref].options[value] or false
		end
		return ui.get(self.ref)
	end,

	reset = function (self) if registry[self.ref].__init then ui.set(self.ref, registry[self.ref].__init) end end,

	update = function (self, t)
		ui.update(self.ref, t)
		registry[self.ref].__list = t

		local cap = #t-1
		--if ui.get(self.ref) > cap then ui.set(self.ref, cap) end
	end,

	get_list = function (self) return registry[self.ref].__list end,

	get_color = function (self)
		if registry[self.ref].__addon then return ui.get(self.color.ref) end
	end,
	set_color = function (self, ...)
		if registry[self.ref].__addon then methods_mt.element.set(self.color, ...) end
	end,
	get_hotkey = function (self)
		if registry[self.ref].__addon then return ui.get(self.hotkey.ref) end
	end,
	set_hotkey = function (self, ...)
		if registry[self.ref].__addon then methods_mt.element.set(self.hotkey, ...) end
	end,

	is_reference = function (self) return registry[self.ref].__ref or false end,
	get_type = function (self) return self.type end,
	get_name = function (self) return self.name end,

	set_visible = function (self, visible)
		ui.set_visible(self.ref, visible)
		if registry[self.ref].__addon then ui.set_visible(self[registry[self.ref].__addon].ref, visible) end
	end,
	set_enabled = function (self, enabled)
		ui.set_enabled(self.ref, enabled)
		if registry[self.ref].__addon then ui.set_enabled(self[registry[self.ref].__addon].ref, enabled) end
	end,

	set_callback = function (self, func, once)
		if once == true then func(self) end
		registry[self.ref].callbacks[#registry[self.ref].callbacks+1] = func
	end,
	unset_callback = function (self, func)
		table.remove(registry[self.ref].callbacks, table.qfind(registry[self.ref].callbacks, func) or 0)
	end,
	invoke = function (self, ...)
		for i = 0, #registry[self.ref].callbacks do registry[self.ref].callbacks[i](self, ...) end
	end,

	set_event = function (self, event, func, condition)
		local slot = registry[self.ref]
		if condition == nil then condition = true end
		local is_cond_fn, latest = type(condition) == "function", nil
		slot.events[func] = function (this)
			local permission if is_cond_fn then permission = condition(this) else permission = this.value == condition end

			local action = permission and client.set_event_callback or client.unset_event_callback
			if latest ~= permission then action(event, func) latest = permission end
		end
		slot.events[func](self)
		slot.callbacks[#slot.callbacks+1] = slot.events[func]
	end,
	unset_event = function (self, event, func)
		client.unset_event_callback(event, func)
		methods_mt.element.unset_callback(self, registry[self.ref].events[func])
		registry[self.ref].events[func] = nil
	end,

	get_location = function (self) return registry[self.ref].tab, registry[self.ref].container end,
}	methods_mt.element.__index = methods_mt.element

methods_mt.group = {
	__name = "ui_handler::group",
	__metatable = false,
	__index = function (self, key) return rawget(methods_mt.group, key) or ui_handler_mt.__index(self, key) end,
	get_location = function (self) return self[1], self[2] end
}

do
	for k, v in next, elements do
		v.fn = function (origin, ...)
			local args, group = utils.dispense(k, origin, ...)
			local this = elemence.new( contend(ui["new_".. k], 3, group[1], group[2], unpack(args, 1, args.n < args.req and args.n or args.req)), args.data )
	
			elemence.features(this, args.misc)
			return this
		end
	end

	ui_handler_mt.__name, ui_handler_mt.__metatable = "ui_handler::basement", false
	ui_handler_mt.__index = function (self, key)
		if not elements[key] then return ui[key] end
		if key == "string" then return elemence.string end
	
		return elements[key].fn
	end
end

ragebot = {
	ref = ui_handler.reference("RAGE", "Weapon type", "Weapon type"),
	context = {}, cache = {},
	silent = false,
} do
	local previous, cycle_action = ragebot.ref.value, nil
	for i, v in ipairs(weapons) do ragebot.context[v], ragebot.cache[v] = {}, {} end

	local neutral = ui.reference("RAGE", "Aimbot", "Enabled")
	ui.set_callback(neutral, function ()
		if not ragebot.silent then client.delay_call(0, client.fire_event, "ui_handler::adaptive_weapon", ragebot.ref.value, previous) end
		if cycle_action then cycle_action(ragebot.ref.value) end
	end)

	ragebot.cycle = function (fn, mute)
		cycle_action = mute and fn or nil
		ragebot.silent = mute and true or false

		for i, v in ipairs(weapons) do
			ragebot.ref:override(v)
		end

		ragebot.ref:override()
		cycle_action, ragebot.silent = nil, false
	end

	ui.set_callback(ragebot.ref.ref, function (self)
		ragebot.ref.value = ui.get(self)

		if not ragebot.silent and previous ~= ragebot.ref.value then
			for i = 1, #registry[self].callbacks, 1 do registry[self].callbacks[i](ragebot.ref) end
		end

		previous = ragebot.ref.value
	end)

	ragebot.memorize = function (self)
		local ctx = ragebot.context[ragebot.ref.value]

		if registry[self.ref].overridden then
			if ctx[self.ref] == nil then
				ctx[self.ref] = self.value
				methods_mt.element.override(self, registry[self.ref].__ovr_v)
			end
		else
			if ctx[self.ref] then
				methods_mt.element.set(self, ctx[self.ref])
				ctx[self.ref] = nil
			end
		end
	end
end

players = {
	elements = {}, list = {},
} do

	ui_handler.plist = elemence.group("PLAYERS", "Adjustments")
	ui_handler.plist.__plist = true

	local selected = 0
	local refs, slot = {
		list = ui_handler.reference("PLAYERS", "Players", "Player list"),
		reset = ui_handler.reference("PLAYERS", "Players", "Reset all"),
		apply = ui_handler.reference("PLAYERS", "Adjustments", "Apply to all"),
	}, {}

	local slot_mt = {
		__type = "ui_handler::player_slot", __metatable = false,
		__tostring = function (self)
			return string.format("ui_handler::player_slot[%d] of %s", self.idx, methods_mt.element.__tostring(registry[self.ref].self))
		end,
		set = function (self, ...) -- don't mind
			local ctx, value = registry[self.ref], {...}

			local is_colorpicker = ctx.type == "color_picker"
			if is_colorpicker then
				value = utils.unpack_color(...)
			end

			if self.idx == selected then
				ui.set( self.ref, unpack(value) )
				if is_colorpicker then
					methods_mt.element.invoke(ctx.self)
				end
			else
				self.value = is_colorpicker and value or unpack(value)
			end
		end,
		get = function (self, find)
			if find and registry[self.ref].type == "multiselect" then
				return table.qfind(self.value, find) ~= nil
			end

			if registry[self.ref].type ~= "color_picker" then return self.value
			else return unpack(self.value) end
		end,
	}	slot_mt.__index = slot_mt

	players.traverse = function (fn) for i, v in ipairs(players.elements) do fn(v) end end

	slot = {
		select = function (idx)
			for i, v in ipairs(players.elements) do
				methods_mt.element.set(v, v[idx].value)
			end
		end,
		add = function (idx)
			for i, v in ipairs(players.elements) do
				local default = ternary(registry[v.ref].__init ~= nil, registry[v.ref].__init, v.value)
				v[idx], players.list[idx] = setmetatable({
					ref = v.ref, idx = idx, value = default
				}, slot_mt), true
			end
		end,
		remove = function (idx)
			for i, v in ipairs(players.elements) do
				v[idx], players.list[idx] = nil, nil
			end
		end,
	}

	players.slot_update = function (self)
		if self[selected] then self[selected].value = self.value
		else slot.add(selected) end
	end

	local silent = false
	local update = function (e)
		selected = ui.get(refs.list.ref)

		local new, old = entity.get_players(), players.list
		local me = entity.get_local_player()

		for idx, v in next, old do
			if entity.get_classname(idx) ~= "CCSPlayer" then
				slot.remove(idx)
			end
		end

		for i, idx in ipairs(new) do
			if idx ~= me and not players.list[idx] and entity.get_classname(idx) == "CCSPlayer" then
				slot.add(idx)
			end
		end

		if not silent and not e.value then
			for i = #new, 1, -1 do
				if new[i] ~= me then ui.set(refs.list.ref, new[i]) break end
			end
			client.update_player_list()
			silent = true
		else
			silent = false
		end

		slot.select(selected)
		client.fire_event("ui_handler::plist_update", selected)
	end

	do
		local function once ()
			update{}
			client.unset_event_callback("pre_render", once)
		end
		client.set_event_callback("pre_render", once)
	end
    
	methods_mt.element.set_callback(refs.list, update, true)
	client.set_event_callback("player_connect_full", update)
	client.set_event_callback("player_disconnect", update)
	client.set_event_callback("player_spawned", update)
	client.set_event_callback("player_spawn", update)
	client.set_event_callback("player_death", update)
	client.set_event_callback("player_team", update)

	methods_mt.element.set_callback(refs.apply, function ()
		players.traverse(function (v)
			for idx, _ in next, players.list do
				v[idx].value = v[selected].value
			end
		end)
	end)

	methods_mt.element.set_callback(refs.reset, function ()
		players.traverse(function (v)
			for idx, _ in next, players.list do
				if idx == selected then
					slot_mt.set(v[idx], registry[v.ref].__init)
				else
					v[idx].value = registry[v.ref].__init
				end
			end
		end)
	end)
end

local config, package, aa_config, aa_package
local 
	img,
	files,
	widgets,
	presets,
	protected,
	animations,
	shot_logger,
	fast_ladder,
	aero_lag_exp,
	chat_spammer,
	death_spammer,
	model_breaker,
	config_system,
	gamesense_refs,
	antiaim_on_use,
	anti_bruteforce,
	crosshair_logger,
	screen_indication,
	manual_indication,
	conditional_antiaims,
	expres = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}

ffi.cdef[[
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);  
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
]]

files.exist = function(path)
    if readfile(path) == nil then
        return false
    end
    return true
end

img.eva = {
    url = 'https://cdn.discordapp.com/attachments/1104685787414540329/1124655981465456650/eva_img.png',
    path = 'angelwings_eva_img.png'
}

if not files.exist(img.eva.path) then
	http.get(img.eva.url, function(success, response)
		if not success or response.status ~= 200 then
			print("Missing 'eva_img' link")
            return
		end

		writefile(img.eva.path, response.body)
	end)
end

protected.database = {
	configs = ':angelwings::configs:'
}

local information = { user = database.read('angelbase_wtf^^') ~= nil and database.read('angelbase_wtf^^').username or fromdb.username, version = _DEBUG and 'debug' or 'live' }
local group = ui_handler.group('AA', 'Anti-aimbot angles')


local tab = group:combobox('\vangelwings\r ~ ' .. information.version, {'Home', 'Misc', 'AA'})
group:label(' ')

conditional_antiaims.conditions_names = {'Shared', 'Standing', 'Moving', 'Slowwalk', 'Crouch', 'Moving & Crouch', 'Air', 'Air & Crouch', 'Freestand', 'Fakelag', 'On Use'}
local Vars = {
    Home = {
		group:label('[\vangelwings\r] Information'),
		group:label('User: \v' .. information.user),
		group:label('Version: \v0.1'),
		group:label(' '),
		group:label('[\vangelwings\r] Presets'),

		list = group:listbox('Configs', '', false),
		name = group:textbox('Config name', '', false),
		load = group:button('Load', function() end),
		save = group:button('Save', function() end),
		delete = group:button('Delete', function() end),
		import = group:button('Import from clipboard', function() end),
		export = group:button('Export to clipboard', function() end)
    },

    Misc = {
		group:label('[\vangelwings\r] Visuals'),
		screen_indicators = group:checkbox('•  Screen indicators', { 142, 165, 255 }),
		screen_indicators_settings = {
			glow = group:checkbox('Indicators  »  Glow behind')
		},
		screen_indicators_settings_dmg = _DEBUG and group:checkbox('•  Min. damage above crosshair') or nil,
		manual_arrows = group:checkbox('•  Manual arrows'),
		manual_arrows_settings = {
			settings = group:combobox('Arrows  »  Settings' , {'Default', 'Invictus', 'Teamskeet'}),
			adding = group:slider('Arrows  »  Adding\nDEF', 0, 100, 35),
			accent_color = group:label('Arrows  »  Accent color\nDEF', { 113, 138, 187 }),
			teamskeet_adding = group:slider('Arrows  »  Adding\nTS', 4, 100, 42),
			teamskeet_accent_color = group:label('Arrows  »  Accent color\nTS', { 175, 255, 0 }),
			teamskeet_desync_accent_color = group:label('Arrows  »  Desync color\nTS', { 0, 200, 255 }),

			invictus_dynamic = group:checkbox("Arrows  »  Dynamic mode"),

			getzeus_adding = group:slider('Arrows  »  Adding\nGT', 4, 100, 44),
			getzeus_accent_color = group:label('Arrows  »  Accent color\nGT', { 111, 111, 220 }),
			getzeus_second_accent_color = group:label('Arrows  »  Second color\nGT', { 255, 255, 255 })
		},

		branded_watermark = group:checkbox('•  Branded watermark', {142, 165, 229, 85}),

		alt_watermark = group:combobox('•  Alternative watermark', {'Simple', 'Modern'}),
		alt_watermark_settings = {
			color = group:color_picker('Alt  »  Position', 142, 165, 229, 85),
			pos = group:combobox('Alt  »  Position', {'Bottom', 'Left', 'Right'}),
			nosp = group:checkbox('Alt  »  Remove spaces'),
		},

		crosshair_hitlog = _DEBUG and group:checkbox('•  Crosshair logger') or nil,
		crosshair_settings = 
		_DEBUG and {
			move = group:checkbox('Crosshair  »  Move with scope'),
			hit_color = group:label('Crosshair  »  Hit color', { 142, 165, 255 }),
			miss_color = group:label('Crosshair  »  Miss color', { 255, 180, 0 }),	
		} or nil,

		hitlog_console = _DEBUG and group:checkbox('•  Console logger') or nil,
		hitlogger_settings = 
		_DEBUG and {
			prefix_color = group:label('Console  »  Prefix color', { 142, 165, 255 }),
			hit_color = group:label('Console  »  Hit color', { 159, 202, 43 }),
			miss_color = group:label('Console  »  Miss color', { 255, 180, 0 }),	
		} or nil,

		group:label(' '),
		group:label('[\vangelwings\r] Miscellaneous'),
		fast_ladder = group:checkbox('•  Fast ladder'),
		fast_ladder_settings = {
			group:multiselect('Fast ladder  »  Settings' , {'Ascending', 'Descending'})
		},
		chat_spammer = group:checkbox('•  Chat spammer'),
		deathsay = group:checkbox('•  On death spammer'),
		anim_breakers = group:checkbox('\aB6B665FF•  Animation breakers'),
		anim_breakers_settings = {
			breaked_legs = group:combobox('Animations  »  Breaked legs', {'Disabled', 'Static', 'Jitter', 'Allah', 'Blend'}),
			air = group:combobox('Animations  »  Air legs', {'Disabled', 'Static', 'Haram'}),
			pitch = group:checkbox('Animations  »  Pitch on land')
		},
		experimental_resolver = _DEBUG and group:checkbox('\aFF0000FF⚠  Experimental resolver') or nil
    },

    AA = {
		group:label('[\vangelwings\r] Settings'),
		enable = group:checkbox('•  Enable anti-aims'),
		edge_yaw = group:checkbox('•  Edge yaw', 0x00),
		freestanding = group:checkbox('•  Freestanding', 0x00),
		avoid_backstab = _DEBUG and group:checkbox('•  Avoid backstab') or nil,
		manuals = {
			enable = group:checkbox('•  Enable manuals'),
			left = group:label('Manuals  »  Left side', 0x00),
			right = group:label('Manuals  »  Right side', 0x00),
			reset = group:label('Manuals  »  Reset sides', 0x00),
			inverter = group:checkbox('Manuals  »  Inverter'),
			manuals_over_fs = group:checkbox('Manuals  »  Over FS'),
			lag_options = group:combobox('Manuals  »  Force defensive\nmanuals' , {'Default', 'Always on'}),
			defensive_aa = group:checkbox('Manuals  »  Defensive AA\nmanuals'),
			defensive_pitch = group:combobox('Manuals  »  Pitch\ndefensive_pitch\nmanuals', {'Disabled', 'Up', 'Zero', 'Random', 'Custom'}),
			pitch_slider = group:slider('\ncustom_defensive_pitch\nmanuals', -89, 89, 0),
			defensive_yaw = group:combobox('Manuals  »  Yaw\ndefensive_yaw\nmanuals', {'Disabled', 'Sideways', 'Opposite', 'Random', 'Spin', '3-Way', '5-Way', 'Custom'}),
			yaw_slider = group:slider('\ncustom_defensive_yaw\nmanuals', -180, 180, 0)
		
		},

		safe_functions = {
			enable = group:checkbox('•  Enable safe functions'),
			settings = group:multiselect('Safe  »  Functions', table.filter {_DEBUG and 'Head' or nil, 'Knife', 'Zeus'}),
			head_settings = group:multiselect('Safe  »  Head settings', {'Height', 'High Distance'}),
			lag_options = group:combobox('Safe  »  Force defensive\nsafe' , {'Default', 'Always on'}),
			defensive_aa = group:checkbox('Safe  »  Defensive AA\nsafe'),
			defensive_pitch = group:combobox('Safe  »  Pitch\ndefensive_pitch\nsafe', {'Disabled', 'Up', 'Zero', 'Random', 'Custom'}),
			pitch_slider = group:slider('\ncustom_defensive_pitch\nsafe', -89, 89, 0),
			defensive_yaw = group:combobox('Safe  »  Yaw\ndefensive_yaw\nsafe', {'Disabled', 'Sideways', 'Opposite', 'Random', 'Spin', '3-Way', '5-Way', 'Custom'}),
			yaw_slider = group:slider('\ncustom_defensive_yaw\nsafe', -180, 180, 0)
		},

		air_exploit = _DEBUG and {
			enable = group:checkbox('\aB6B665FF•  Enable aerobic exploit', 0x00),
			while_visible = group:checkbox('Exploit  »  While enemy visible'),
			exp_tick = group:slider('Exploit  »  Delay', 2, 30, 10, 1, 't')
		} or nil,

		empty_list = group:label(' '),
		Settings = {
			group:label('[\vangelwings\r] Builder'),
			condition_combo = group:combobox('State', conditional_antiaims.conditions_names)
		}
    }	
}

config_system.get = function(name)
    local database = database.read(protected.database.configs) or {}

    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
				config2 = v.config2,
                index = i
            }
        end
    end

    for i, v in pairs(presets) do
        if v.name == name then
            return {
                config = v.config,
				config2 = v.config2,
                index = i
            }
        end
    end

    return false
end

config_system.save = function(name)
    local db = database.read(protected.database.configs) or {}
    local config = {}

    if name:match('[^%w]') ~= nil then
        return
    end

	local config = base64.encode(json.stringify(package:save()))
	local config2 = base64.encode(json.stringify(aa_package:save()))

	local cfg = config_system.get(name)

    if not cfg then
        table.insert(db, { name = name, config = config, config2 = config2 })
    else
		db[cfg.index].config = config
        db[cfg.index].config2 = config2
    end

    database.write(protected.database.configs, db)
end

config_system.delete = function(name)
    local db = database.read(protected.database.configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            table.remove(db, i)
            break
        end
    end

    for i, v in pairs(presets) do
        if v.name == name then
            return false
        end
    end

    database.write(protected.database.configs, db)
end

config_system.config_list = function()
    local database = database.read(protected.database.configs) or {}
    local config = {}

    for i, v in pairs(presets) do
        table.insert(config, v.name)
    end

    for i, v in pairs(database) do
        table.insert(config, v.name)
    end

    return config
end

local function typeFromString(input)
    if type(input) ~= 'string' then return input end

    local value = input:lower()

    if value == 'true' then
        return true
    elseif value == 'false' then
        return false
    elseif tonumber(value) ~= nil then
        return tonumber(value)
    else
        return tostring(input)
    end
end

config_system.load_settings = function(e, e2)
	--package:load(json.parse(base64.decode(e)))
	--aa_package:load(json.parse(base64.decode(e2)))
	package:load(e)
	aa_package:load(e2)
end

config_system.import_settings = function()
    local frombuffer = clipboard.get()
	local config = json.parse(base64.decode(frombuffer))
    config_system.load_settings(config.config, config.config2)
end

config_system.export_settings = function(name)
    local config = { config = package:save(), config2 = aa_package:save() }
    local toExport = base64.encode(json.stringify(config))
    clipboard.set(toExport)
end

config_system.load = function(name)
    local fromDB = config_system.get(name)
    config_system.load_settings(json.parse(base64.decode(fromDB.config)), json.parse(base64.decode(fromDB.config2)))
end

Vars.Home.list:set_callback(function(value)
    if value == nil then 
		return 
	end
    local name = ''
    
    local configs = config_system.config_list()
    if configs == nil then 
		return 
	end

    name = configs[value:get() + 1] or ''
    Vars.Home.name:set(name)
end)

Vars.Home.load:set_callback(function()
	local name = Vars.Home.name:get()
    if name == '' then return end

    local s, p = pcall(config_system.load, name)

    if s then
        name = name:gsub('*', '')
        print('Successfully loaded ' .. name)
    else
        print('Failed to load ' .. name)
		print('Debug: ', p)
    end
	
end)

Vars.Home.save:set_callback(function()			
	local name = Vars.Home.name:get()
	if name == '' then return end

	for i, v in pairs(presets) do
		if v.name == name:gsub('*', '') then
			print("You can't save built-in preset")
			return
		end
	end

	if name:match('[^%w]') ~= nil then
		print('Failed to save ' .. name .. ' due to invalid characters')
		return
	end

	local protected = function()
		config_system.save(name)
		Vars.Home.list:update(config_system.config_list())
	end

	if pcall(protected) then
		print('Successfully saved ' .. name)
	else
		print('Failed to save ' .. name)
	end
end)

Vars.Home.delete:set_callback(function()
    local name = Vars.Home.name:get()
    if name == '' then return end

    if config_system.delete(name) == false then
        print('Failed to delete ' .. name)
        Vars.Home.list:update(config_system.config_list())
        return
    end

    for i, v in pairs(presets) do
        if v.name == name:gsub('*', '') then
            print('You can`t delete built-in preset ' .. name:gsub('*', ''))
            return
        end
    end

    config_system.delete(name)

    Vars.Home.list:update(config_system.config_list())
    Vars.Home.list:set((#presets) or '')
    Vars.Home.name:set(#database.read(protected.database.configs) == 0 and "" or config_system.config_list()[#presets])
    print('Successfully deleted ' .. name)
end)

Vars.Home.import:set_callback(function()
	local protected = function()
        config_system.import_settings()
    end

    if pcall(protected) then
        print('Successfully imported settings')
    else
        print('Failed to import settings')
    end
end)

Vars.Home.export:set_callback(function()
    local name = Vars.Home.name:get()
    if name == '' then return end

    local protected = function()
        config_system.export_settings(name)
    end

    if pcall(protected) then
        print('Successfully exported settings')
    else
        print('Failed to export settings')
    end
end)

local function initDatabase()
    if database.read(protected.database.configs) == nil then
        database.write(protected.database.configs, {})
    end

    local link = 'https://cdn.discordapp.com/attachments/1146862113223094292/1160979637061570690/message.txt'

    http.get(link, function(success, response)
        if not success then
            print('Failed to get presets')
            return
        end

		local decode = base64.decode(response.body, 'base64')
		local toTable = json.parse(decode)

        table.insert(presets, { name = '*Default', config = base64.encode(json.stringify(toTable.config)), config2 = base64.encode(json.stringify(toTable.config2))})
        Vars.Home.name:set('*Default')

        Vars.Home.list:update(config_system.config_list())
    end)

	Vars.Home.list:update(config_system.config_list())
end

initDatabase()

animations.base_speed = 0.095
animations._list = {}
animations.new = function(name, new_value, speed, init)
    speed = speed or animations.base_speed
    local is_color = type(new_value) == "userdata"
    local is_vector = type(new_value) == "vector"

    if animations._list[name] == nil then
        animations._list[name] = (init and init) or (is_color and colors.white or 0)
    end

    local interp_func

    if is_vector then
        interp_func = math.vector_lerp
    elseif is_color then
        interp_func = math.color_lerp
    else
        interp_func = math.lerp
    end

    animations._list[name] = interp_func(animations._list[name], new_value, speed)
    
    return animations._list[name]
end

gamesense_refs.dmgOverride = {ui.reference('RAGE', 'Aimbot', 'Minimum damage override')}
gamesense_refs.fakeDuck = ui.reference('RAGE', 'Other', 'Duck peek assist')
gamesense_refs.minDmg = ui.reference('RAGE', 'Aimbot', 'Minimum damage')
gamesense_refs.hitChance = ui.reference('RAGE', 'Aimbot', 'Minimum hit chance')
gamesense_refs.safePoint = ui.reference('RAGE', 'Aimbot', 'Force safe point')
gamesense_refs.forceBaim = ui.reference('RAGE', 'Aimbot', 'Force body aim')
gamesense_refs.dtLimit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
gamesense_refs.quickPeek = {ui.reference('RAGE', 'Other', 'Quick peek assist')}
gamesense_refs.dt = {ui.reference('RAGE', 'Aimbot', 'Double tap')}
gamesense_refs.flLimit = ui.reference('AA', 'Fake lag', 'Limit')
gamesense_refs.os = {ui.reference('AA', 'Other', 'On shot anti-aim')}
gamesense_refs.slow = {ui.reference('AA', 'Other', 'Slow motion')}
gamesense_refs.fakeLag = {ui.reference('AA', 'Fake lag', 'Limit')}
gamesense_refs.indicators = {ui.reference('VISUALS', 'Other ESP', 'Feature indicators')}
gamesense_refs.ping = {ui.reference('MISC', 'Miscellaneous', 'Ping spike')}
gamesense_refs.dt_fakelag = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')

gamesense_refs.leg_movement = ui_handler.reference('AA', 'Other', 'Leg movement')
gamesense_refs.pitch, gamesense_refs.pitch_value = ui_handler.reference('AA', 'Anti-aimbot angles', 'Pitch')
gamesense_refs.yaw_base = ui_handler.reference('AA', 'Anti-aimbot angles', 'Yaw base')
gamesense_refs.yaw_offset1, gamesense_refs.yaw_offset = ui_handler.reference('AA', 'Anti-aimbot angles', 'Yaw')
gamesense_refs.body_yaw, gamesense_refs.body_yaw_offset = ui_handler.reference('AA', 'Anti-aimbot angles', 'Body yaw')
gamesense_refs.doubletap, gamesense_refs.doubletap_config = ui_handler.reference('RAGE', 'Aimbot', 'Double tap')
gamesense_refs.yaw_modifier, gamesense_refs.yaw_modifier_offset = ui_handler.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')
gamesense_refs.edge_yaw = ui_handler.reference('AA', 'Anti-aimbot angles', 'Edge yaw')
gamesense_refs.freestanding = ui_handler.reference('AA', 'Anti-aimbot angles', 'Freestanding')
gamesense_refs.freestanding_key = { ui_handler.reference('AA', 'Anti-aimbot angles', 'Freestanding') }
gamesense_refs.roll_aa = ui_handler.reference('AA', 'Anti-aimbot angles', 'Roll')
gamesense_refs.prefer_safe_point = ui.reference('RAGE', 'Aimbot', 'Prefer safe point')
gamesense_refs.force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point')
gamesense_refs.rage_enable = ui_handler.reference('RAGE', 'Aimbot', 'Enabled')
gamesense_refs.duck_peek = ui_handler.reference('RAGE', 'Other', 'Duck peek assist')

gamesense_refs._vars = {}

for k, v in pairs(gamesense_refs) do
    if k ~= "_vars" then
        gamesense_refs._vars[k] = {
            tick = -1,
            var = v
        }
    end
end

gamesense_refs.override = function(name, value)
    local var = gamesense_refs._vars[name]

    if var == nil then
        return
    end

    if type(value) == "table" and value._len then
        value._len = nil
    end

    var.var:override(value)
    
    var.tick = globals.tickcount()

    return var.var
end

local safecall = function(name, report, f)
    return function(...)
        local s, ret = pcall(f, ...)

        if not s then
            local retmessage = "safe call failed [" .. name .. "] -> " .. ret

            if report then
                print(retmessage)
            end

            return false, retmessage
        else
            return ret, s
        end
    end
end

expres.get_prev_simtime = function(ent)
    local ent_ptr = native_GetClientEntity(ent)    
	if ent_ptr ~= nil then 
		return ffi.cast('float*', ffi.cast('uintptr_t', ent_ptr) + 0x26C)[0] 
	end
end

expres.restore = function ()
	for i = 1, 64 do plist.set(i, "Force body yaw", false) end
end

if Vars.Misc.experimental_resolver then
	defer(expres.restore)
	Vars.Misc.experimental_resolver:set_callback(function (this)
		if not this.value then expres.restore() end
	end)
end

expres.body_yaw, expres.eye_angles = {}, {}

expres.get_max_desync = function (animstate)
	local speedfactor = math.clamp(animstate.feet_speed_forwards_or_sideways, 0, 1)
	local avg_speedfactor = (animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1

	local duck_amount = animstate.duck_amount
	if duck_amount > 0 then
		avg_speedfactor = avg_speedfactor + (duck_amount * speedfactor * (0.5 - avg_speedfactor))
	end

	return math.clamp(avg_speedfactor, .5, 1)
end

expres.handle = safecall('experimental_resolver.handle', true, function()
	if not (Vars.Misc.experimental_resolver and Vars.Misc.experimental_resolver:get()) then 
		return
	end

	local current_threat = client.current_threat()

    if current_threat == nil or not entity.is_alive(current_threat) or entity.is_dormant(current_threat) then 
		return 
	end

    if expres.body_yaw[current_threat] == nil then 
		expres.body_yaw[current_threat], expres.eye_angles[current_threat] = {}, {}
	end

    local simtime = toticks(entity.get_prop(current_threat, 'm_flSimulationTime'))
	local prev_simtime = toticks(expres.get_prev_simtime(current_threat))
    expres.body_yaw[current_threat][simtime] = entity.get_prop(current_threat, 'm_flPoseParameter', 11) * 120 - 60
    expres.eye_angles[current_threat][simtime] = select(2, entity.get_prop(current_threat, "m_angEyeAngles"))

    if expres.body_yaw[current_threat][prev_simtime] ~= nil then
		local ent = c_entity.new(current_threat)
		local animstate = ent:get_anim_state()
		local max_desync = expres.get_max_desync(animstate)

        local should_correct = (simtime - prev_simtime >= 1) and math.abs(max_desync) < 45 and expres.body_yaw[current_threat][prev_simtime] ~= 0

		if should_correct then
			-- local side = math.clamp(math.normalize_yaw(animstate.goal_feet_yaw - expres.eye_angles[current_threat][simtime]), -1, 1)
			-- local value = expres.body_yaw[current_threat][prev_simtime] * side * max_desync
			local value = math.random(0, expres.body_yaw[current_threat][prev_simtime] * math.random(-1, 1)) * .25

			plist.set(current_threat, 'Force body yaw value', value) 
		end
		plist.set(current_threat, 'Force body yaw', should_correct)     
    end

    plist.set(current_threat, 'Correction active', true)
end)

model_breaker.handle = safecall('model_breaker.handle', true, function()
    local player = entity.get_local_player()

    if player == nil then
        return
    end

	local self_index = c_entity.new(player)
    local self_anim_state = self_index:get_anim_state()

    if not self_anim_state then
        return
    end

	if not Vars.Misc.anim_breakers:get() then
		return
	end

	if Vars.Misc.anim_breakers_settings.pitch:get() and (not (model_breaker.in_air) and self_anim_state.hit_in_ground_animation) then
		entity.set_prop(player, 'm_flPoseParameter', 0.5, 12)
	end

	if Vars.Misc.anim_breakers_settings.air:get() == 'Static' then
		entity.set_prop(player, 'm_flPoseParameter', 1, 6)
	end	

	if Vars.Misc.anim_breakers_settings.air:get() == 'Haram' then
		local self_anim_overlay = self_index:get_anim_overlay(6)

		local x_velocity = entity.get_prop(player, 'm_vecVelocity[0]')
        if math.abs(x_velocity) >= 3 then
            self_anim_overlay.weight = 1
        end
	end	

	if Vars.Misc.anim_breakers_settings.breaked_legs:get() == 'Static' then
		gamesense_refs.override('leg_movement', 'Always slide')
		entity.set_prop(player, 'm_flPoseParameter', 1, 0)
	elseif Vars.Misc.anim_breakers_settings.breaked_legs:get() == 'Allah' then
		gamesense_refs.override('leg_movement', 'Never slide')
		entity.set_prop(player, 'm_flPoseParameter', 0, 7)
	elseif Vars.Misc.anim_breakers_settings.breaked_legs:get() == 'Blend' then
		entity.set_prop(player, 'm_flPoseParameter', 0, 8)
		entity.set_prop(player, 'm_flPoseParameter', 0, 9)
	elseif Vars.Misc.anim_breakers_settings.breaked_legs:get() == 'Jitter' then
		entity.set_prop(player, 'm_flPoseParameter', 1, globals.tickcount() % 4 > 1 and 0.5 or 1)
	end
end)

model_breaker.handle_jitter = safecall('model_breaker.handle_jitter', true, function(cmd)
    local player = entity.get_local_player()

    if player == nil then
        return
    end

	if not Vars.Misc.anim_breakers:get() then
		return
	end

	if Vars.Misc.anim_breakers_settings.breaked_legs:get() == 'Jitter' then
		gamesense_refs.override('leg_movement', cmd.command_number % 3 == 0 and 'Off' or 'Always slide')
		--entity.set_prop(player, 'm_flPoseParameter', 1, 0)
	end	

end)

shot_logger.add = function(...)
    args = { ... }
    len = #args
    for i = 1, len do
        arg = args[i]
        r, g, b = unpack(arg)

        msg = {}

        if #arg == 3 then
            table.insert(msg, " ")
        else
            for i = 4, #arg do
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

shot_logger.bullet_impacts = {}
shot_logger.bullet_impact = function(e)
	local tick = globals.tickcount()
	local me = entity.get_local_player()
	local user = client.userid_to_entindex(e.userid)
	
	if user ~= me then
		return
	end

	if #shot_logger.bullet_impacts > 150 then
		shot_logger.bullet_impacts = { }
	end

	shot_logger.bullet_impacts[#shot_logger.bullet_impacts+1] = {
		tick = tick,
		eye = vector(client.eye_position()),
		shot = vector(e.x, e.y, e.z)
	}
end

shot_logger.get_inaccuracy_tick = function(pre_data, tick)
	local spread_angle = -1
	for k, impact in pairs(shot_logger.bullet_impacts) do
		if impact.tick == tick then
			local aim, shot = 
				(pre_data.eye-pre_data.shot_pos):angles(),
				(pre_data.eye-impact.shot):angles()

				spread_angle = vector(aim-shot):length2d()
			break
		end
	end

	return spread_angle
end

shot_logger.get_safety = function(aim_data, target)
	local has_been_boosted = aim_data.boosted
	local plist_safety = plist.get(target, 'Override safe point')
	local ui_safety = { ui.get(gamesense_refs.prefer_safe_point), ui.get(gamesense_refs.force_safe_point) or plist_safety == 'On' }

	if not has_been_boosted then
		return -1
	end

	if plist_safety == 'Off' or not (ui_safety[1] or ui_safety[2]) then
		return 0
	end

	return ui_safety[2] and 2 or (ui_safety[1] and 1 or 0)
end

shot_logger.generate_flags = function(pre_data)
	return {
		pre_data.self_choke > 1 and 1 or 0,
		pre_data.velocity_modifier < 1.00 and 1 or 0,
		pre_data.flags.boosted and 1 or 0
	}
end

shot_logger.hitboxes = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
shot_logger.on_aim_fire = function(e)
	local p_ent = e.target
	local me = entity.get_local_player()

	shot_logger[e.id] = {
		original = e,
		dropped_packets = { },

		handle_time = globals.realtime(),
		self_choke = globals.chokedcommands(),

		flags = {
			boosted = e.boosted
		},

		feet_yaw = entity.get_prop(p_ent, 'm_flPoseParameter', 11)*120-60,
		correction = plist.get(p_ent, 'Correction active'),

		safety = shot_logger.get_safety(e, p_ent),
		shot_pos = vector(e.x, e.y, e.z),
		eye = vector(client.eye_position()),
		view = vector(client.camera_angles()),

		velocity_modifier = entity.get_prop(me, 'm_flVelocityModifier'),
		total_hits = entity.get_prop(me, 'm_totalHitsOnServer'),

		history = globals.tickcount() - e.tick
	}
end
shot_logger.on_aim_hit = function(e)
	if not (Vars.Misc.hitlog_console and Vars.Misc.hitlog_console:get()) then
		return
	end

	if shot_logger[e.id] == nil then
		return 
	end

	local info = 
	{
		type = math.max(0, entity.get_prop(e.target, 'm_iHealth')) > 0,
		prefix = { Vars.Misc.hitlogger_settings.prefix_color.color:get() },
		hit = { Vars.Misc.hitlogger_settings.hit_color.color:get() },
		name = entity.get_player_name(e.target),
		hitgroup = shot_logger.hitboxes[e.hitgroup + 1] or '?',
		flags = string.format('%s', table.concat(shot_logger.generate_flags(shot_logger[e.id]))),
		aimed_hitgroup = shot_logger.hitboxes[shot_logger[e.id].original.hitgroup + 1] or '?',
		aimed_hitchance = string.format('%d%%', math.floor(shot_logger[e.id].original.hit_chance + 0.5)),
		hp = math.max(0, entity.get_prop(e.target, 'm_iHealth')),
		spread_angle = string.format('%.2f°', shot_logger.get_inaccuracy_tick(shot_logger[e.id], globals.tickcount())),
		correction = string.format('%d:%d°', shot_logger[e.id].correction and 1 or 0, (shot_logger[e.id].feet_yaw < 10 and shot_logger[e.id].feet_yaw > -10) and 0 or shot_logger[e.id].feet_yaw)
	}

	shot_logger.add({ info.prefix[1], info.prefix[2], info.prefix[3], '[angelwings]'}, 
					{ 134, 134, 134, ' » ' }, 
					{ 200, 200, 200, info.type and 'Damaged ' or 'Killed ' }, 
					{ info.hit[1], info.hit[2], info.hit[3],  info.name }, 
					{ 200, 200, 200, ' in the ' }, 
					{ info.hit[1], info.hit[2], info.hit[3], info.hitgroup }, 
					{ 200, 200, 200, info.type and info.hitgroup ~= info.aimed_hitgroup and ' (' or ''},
					{ info.hit[1], info.hit[2], info.hit[3], info.type and (info.hitgroup ~= info.aimed_hitgroup and info.aimed_hitgroup) or '' },
					{ 200, 200, 200, info.type and info.hitgroup ~= info.aimed_hitgroup and ')' or ''},
					{ 200, 200, 200, info.type and ' for ' or '' },
					{ info.hit[1], info.hit[2], info.hit[3], info.type and e.damage or '' },
					{ 200, 200, 200, info.type and e.damage ~= shot_logger[e.id].original.damage and ' (' or ''},
					{ info.hit[1], info.hit[2], info.hit[3], info.type and (e.damage ~= shot_logger[e.id].original.damage and shot_logger[e.id].original.damage) or '' },
					{ 200, 200, 200, info.type and e.damage ~= shot_logger[e.id].original.damage and ')' or ''},
					{ 200, 200, 200, info.type and ' damage' or '' },
					{ 200, 200, 200, info.type and ' (' or '' }, { info.hit[1], info.hit[2], info.hit[3], info.type and info.hp or '' }, { 200, 200, 200, info.type and ' hp remaning)' or '' },
					{ 200, 200, 200, ' ['}, { info.hit[1], info.hit[2], info.hit[3], info.spread_angle }, { 200, 200, 200, ' | ' }, { info.hit[1], info.hit[2], info.hit[3], info.correction}, { 200, 200, 200, ']' },
					{ 200, 200, 200, ' (hc: ' }, { info.hit[1], info.hit[2], info.hit[3], info.aimed_hitchance }, { 200, 200, 200, ' | safety: ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].safety },
					{ 200, 200, 200, ' | history(Δ): ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].history }, { 200, 200, 200, ' | flags: ' }, { info.hit[1], info.hit[2], info.hit[3], info.flags },
					{ 200, 200, 200, ')' })
end

shot_logger.on_aim_miss = function(e)
	if not (Vars.Misc.hitlog_console and Vars.Misc.hitlog_console:get()) then
		return
	end

	local me = entity.get_local_player()
	local info = 
	{
		prefix = {Vars.Misc.hitlogger_settings.prefix_color.color:get()},
		hit = {Vars.Misc.hitlogger_settings.miss_color.color:get()},
		name = entity.get_player_name(e.target),
		hitgroup = shot_logger.hitboxes[e.hitgroup + 1] or '?',
		flags = string.format('%s', table.concat(shot_logger.generate_flags(shot_logger[e.id]))),
		aimed_hitgroup = shot_logger.hitboxes[shot_logger[e.id].original.hitgroup + 1] or '?',
		aimed_hitchance = string.format('%d%%', math.floor(shot_logger[e.id].original.hit_chance + 0.5)),
		hp = math.max(0, entity.get_prop(e.target, 'm_iHealth')),
		reason = e.reason,
		spread_angle = string.format('%.2f°', shot_logger.get_inaccuracy_tick(shot_logger[e.id], globals.tickcount())),
		correction = string.format('%d:%d°', shot_logger[e.id].correction and 1 or 0, (shot_logger[e.id].feet_yaw < 10 and shot_logger[e.id].feet_yaw > -10) and 0 or shot_logger[e.id].feet_yaw)
	}

    if info.reason == '?' then
        info.reason = 'unknown';

        if shot_logger[e.id].total_hits ~= entity.get_prop(me, 'm_totalHitsOnServer') then
            info.reason = 'damage rejection';
        end
    end

	shot_logger.add({ info.prefix[1], info.prefix[2], info.prefix[3], '[angelwings]'}, 
					{ 134, 134, 134, ' » ' }, 
					{ 200, 200, 200, 'Missed shot at ' }, 
					{ info.hit[1], info.hit[2], info.hit[3],  info.name }, 
					{ 200, 200, 200, ' in the ' }, 
					{ info.hit[1], info.hit[2], info.hit[3], info.hitgroup }, 
					{ 200, 200, 200, ' due to '},
					{ info.hit[1], info.hit[2], info.hit[3], info.reason },
					{ 200, 200, 200, ' ['}, { info.hit[1], info.hit[2], info.hit[3], info.spread_angle }, { 200, 200, 200, ' | ' }, { info.hit[1], info.hit[2], info.hit[3], info.correction}, { 200, 200, 200, ']' },
					{ 200, 200, 200, ' (hc: ' }, { info.hit[1], info.hit[2], info.hit[3], info.aimed_hitchance }, { 200, 200, 200, ' | safety: ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].safety },
					{ 200, 200, 200, ' | history(Δ): ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].history }, { 200, 200, 200, ' | flags: ' }, { info.hit[1], info.hit[2], info.hit[3], info.flags },
					{ 200, 200, 200, ')' })
end

client.set_event_callback('aim_fire', shot_logger.on_aim_fire)
client.set_event_callback('aim_miss', shot_logger.on_aim_miss)
client.set_event_callback('aim_hit', shot_logger.on_aim_hit)
client.set_event_callback('bullet_impact', shot_logger.bullet_impact)

manual_indication.handle = function()
	local player = entity.get_local_player()

    if player == nil or not entity.is_alive(player) then
        return
    end
	
    local m_bIsScoped = entity.get_prop(player, 'm_bIsScoped') ~= 0
    local antiaim_manuals = conditional_antiaims.manual_dir
    local manual_indication_enable = Vars.Misc.manual_arrows:get()
    local manual_indication_type = Vars.Misc.manual_arrows_settings.settings:get()
    local manual_indication_anim = animations.new('manual_indication_anim', manual_indication_enable and 1 or 0)
	local x, y = client.screen_size()
    local pos = { x = x*0.5, y = y*0.5 }

    local anim = {}

    if manual_indication_type == 'Default' then

        local manual_indication_adding = Vars.Misc.manual_arrows_settings.adding:get()
        local manual_indication_accent_color = { Vars.Misc.manual_arrows_settings.accent_color.color:get() }

        anim.left = animations.new('manual_indication_left', manual_indication_enable and not m_bIsScoped and (antiaim_manuals == -90 and 255 or 100) or 0)
        anim.right = animations.new('manual_indication_right', manual_indication_enable and not m_bIsScoped and (antiaim_manuals == 90 and 255 or 100) or 0)

        if anim.left < 1 or anim.right < 1 then
            return
        end

		render.triangle(pos.x - (manual_indication_adding+9), 
			pos.y, 
			pos.x - manual_indication_adding, 
			pos.y - 5, pos.x - manual_indication_adding, 
			pos.y + 5, 
			antiaim_manuals == -90 and manual_indication_accent_color[1] or 0, 
			antiaim_manuals == -90 and manual_indication_accent_color[2] or 0, 
			antiaim_manuals == -90 and manual_indication_accent_color[3] or 0, 
			anim.left)

		render.triangle(pos.x + (manual_indication_adding+9), 
			pos.y, 
			pos.x + manual_indication_adding, 
			pos.y - 5, 
			pos.x + manual_indication_adding, 
			pos.y + 5, 
			antiaim_manuals == 90 and manual_indication_accent_color[1] or 0, 
			antiaim_manuals == 90 and manual_indication_accent_color[2] or 0, 
			antiaim_manuals == 90 and manual_indication_accent_color[3] or 0, 
			anim.right)
    end

    if manual_indication_type == 'Teamskeet' then

        local default = { Vars.Misc.manual_arrows_settings.teamskeet_accent_color.color:get() }
        local default2 = { Vars.Misc.manual_arrows_settings.teamskeet_desync_accent_color.color:get() }

        local ts_arrowsanim = Vars.Misc.manual_arrows_settings.teamskeet_adding:get()
        local ts_colleft = (antiaim_manuals == -90) and { default[1], default[2], default[3], 255*manual_indication_anim } or { 35, 35, 35, 150*manual_indication_anim }
        local ts_colright = (antiaim_manuals == 90) and { default[1], default[2], default[3], 255*manual_indication_anim } or { 35, 35, 35, 150*manual_indication_anim }

		render.triangle(pos.x + (ts_arrowsanim+13), pos.y, pos.x + ts_arrowsanim, pos.y - 9, pos.x + ts_arrowsanim, pos.y + 9, ts_colright[1], ts_colright[2], ts_colright[3], ts_colright[4])
		render.triangle(pos.x - (ts_arrowsanim+13), pos.y, pos.x - ts_arrowsanim, pos.y - 9, pos.x - ts_arrowsanim, pos.y + 9, ts_colleft[1], ts_colleft[2], ts_colleft[3], ts_colleft[4])
        
		local ts_lineanim = ts_arrowsanim
        local ts_sideleft = (not conditional_antiaims.current_side) and { default2[1], default2[2], default2[3], default2[4]*manual_indication_anim } or { 35, 35, 35, 150*manual_indication_anim }
        local ts_sideright = (conditional_antiaims.current_side) and { default2[1], default2[2], default2[3], default2[4]*manual_indication_anim } or { 35, 35, 35, 150*manual_indication_anim }
		
		render.rectangle(pos.x + (ts_lineanim-4), pos.y - 9, 2, 18, ts_sideleft[1], ts_sideleft[2], ts_sideleft[3], ts_sideleft[4])
		render.rectangle(pos.x - (ts_lineanim-2), pos.y - 9, 2, 18,	ts_sideright[1], ts_sideright[2], ts_sideright[3], ts_sideright[4])

    end

    if manual_indication_type == 'Invictus' then
        local selected = { Vars.Misc.manual_arrows_settings.getzeus_accent_color.color:get() }
        local unselected = { Vars.Misc.manual_arrows_settings.getzeus_second_accent_color.color:get() }
		local by = manual_indication.peeking_side
		local gt_arrowsanim = Vars.Misc.manual_arrows_settings.getzeus_adding:get()

		local act = { selected[1], selected[2], selected[3], selected[4]*manual_indication_anim }
		local off = { unselected[1], unselected[2], unselected[3], unselected[4]*manual_indication_anim }

		local gt_colright = antiaim_manuals == 90 and act or off
		local gt_colleft = antiaim_manuals == -90 and act or off

        if antiaim_manuals == 90 or antiaim_manuals == -90 then
			render.text(pos.x + gt_arrowsanim, pos.y - 16, gt_colright[1], gt_colright[2], gt_colright[3], gt_colright[4], '+', nil, '>')
			render.text(pos.x - (gt_arrowsanim+13), pos.y - 16, gt_colleft[1], gt_colleft[2], gt_colleft[3], gt_colleft[4], '+', nil, '<')
		elseif by ~= 0 and Vars.Misc.manual_arrows_settings.invictus_dynamic:get() then
			local r = by > 0 and act or off
			local l = by < 0 and act or off
			render.text(pos.x + gt_arrowsanim + 6, pos.y - 2, r[1], r[2], r[3], r[4], '+c', nil, by == 2 and '   >>' or '>')
			render.text(pos.x - (gt_arrowsanim+13) + 6, pos.y - 2, l[1], l[2], l[3], l[4], '+c', nil, by == -2 and '<<   ' or '<')
		end
    end
end

manual_indication.extend_vector = function(pos,length,angle)
    local rad = angle * math.pi / 180
    if rad == nil then return end
    if angle == nil or pos == nil or length == nil then return end
    return {pos[1] + (math.cos(rad) * length),pos[2] + (math.sin(rad) * length), pos[3]};
end

manual_indication.peeking_side = 0
manual_indication.peeking_whom = function (cmd)
	local manual_indication_enable = Vars.Misc.manual_arrows:get()
    local manual_indication_type = Vars.Misc.manual_arrows_settings.settings:get()

    manual_indication.peeking_side = 0
	if not manual_indication_enable or manual_indication_type ~= "Invictus" or not Vars.Misc.manual_arrows_settings.invictus_dynamic:get() then return end

    local me = entity.get_local_player()
	local enemy = client.current_threat()
	if not me or entity.is_dormant(enemy) then return end

    -- Getting my activation arc
    local pitch, yaw = client.camera_angles(me)
    local left1 = manual_indication.extend_vector({entity.get_origin(me)},50,yaw + 110)
    local left2 = manual_indication.extend_vector({entity.get_origin(me)},30,yaw + 60)
    local right1 = manual_indication.extend_vector({entity.get_origin(me)},50,yaw - 110)
    local right2 = manual_indication.extend_vector({entity.get_origin(me)},30,yaw - 60)

    -- Getting enemys activation arc
    local pitch, yaw_e = entity.get_prop(enemy, "m_angEyeAngles")
    local enemy_right1 = manual_indication.extend_vector({entity.get_origin(enemy)},40,yaw_e - 115)
    local enemy_right2 = manual_indication.extend_vector({entity.get_origin(enemy)},20,yaw_e - 35)
    local enemy_left1 = manual_indication.extend_vector({entity.get_origin(enemy)},40,yaw_e + 115)
    local enemy_left2 = manual_indication.extend_vector({entity.get_origin(enemy)},20,yaw_e + 35)

    -- Tracing bullets from enemies arc to mine
    local _, dmg_left1 =  client.trace_bullet(enemy, enemy_left1[1], enemy_left1[2], enemy_left1[3] + 70, left1[1], left1[2], left1[3] , true)
    local _, dmg_right1 = client.trace_bullet(enemy, enemy_right1[1], enemy_right1[2], enemy_right1[3] + 70, right1[1], right1[2], right1[3], true)
    local _, dmg_left2 =  client.trace_bullet(enemy, enemy_left2[1], enemy_left2[2], enemy_left2[3] + 30, left2[1], left2[2], left2[3], true)
    local _, dmg_right2 = client.trace_bullet(enemy, enemy_right2[1], enemy_right2[2], enemy_right2[3] + 30, right2[1], right2[2], right2[3], true)

    local by = nil
    if dmg_right2 > 0 then
        by = 2
    elseif dmg_left2 > 0 then
        by = -2
    elseif dmg_left1 > 0 then
        by = -1
    elseif dmg_right1 > 0 then
        by = 1
    elseif dmg_right1 > 0 and dmg_left1 > 0 then
        by = 0
    elseif dmg_right2 > 0 and dmg_left2 > 0 then
        by = 0
    else
        by = 0
    end
    manual_indication.peeking_side = by
end



crosshair_logger.indicators_height = 0

screen_indication.luasense = function (anim)
	local width, height = client.screen_size()
	local r2, g2, b2, a2 = 55,55,55,anim
	local highlight_fraction =  (globals.realtime() / 2 % 1.2 * 2) - 1.2
	local output = ""
	local text_to_draw = " W I N G S"
	for idx = 1, #text_to_draw do
		local character = text_to_draw:sub(idx, idx)
		local character_fraction = idx / #text_to_draw
		local r1, g1, b1, a1 = 255, 255, 255, 255
		local delta = (character_fraction - highlight_fraction)
		if delta >= 0 and delta <= 1.4 then
			if delta > 0.7 then delta = 1.4 - delta end
			local rf, gf, bf = r2 - r1, g2 - g1, b2 - b1
			r1 = r1 + rf * delta / 0.8
			g1 = g1 + gf * delta / 0.8
			b1 = b1 + bf * delta / 0.8
		end
		output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a2, text_to_draw:sub(idx, idx))
	end

	output = "A N G E L" .. output
	if Vars.Misc.alt_watermark_settings.nosp.value then
		output = string.gsub(output, " ", "")
	end
	if _DEBUG and Vars.Misc.alt_watermark_settings.pos.value ~= "Bottom" then
		output = output .. ("\a%x%x%x%x"):format(200, 69, 69, a2) .. " [DEBUG] "
	end

	local r,g,b = Vars.Misc.alt_watermark_settings.color:get()
	if Vars.Misc.alt_watermark_settings.pos.value == "Bottom" then
		if _DEBUG then
			renderer.text(width/2, height - 36, 200, 69, 69, a2, "c", 0, "[DEBUG]")
		end
		renderer.text(width/2, height - 20, r,g,b, a2, "c", 0, output)
	elseif Vars.Misc.alt_watermark_settings.pos.value == "Right" then
		renderer.text(width - 20, height/2, r,g,b, a2, "r", 0, output)
	elseif Vars.Misc.alt_watermark_settings.pos.value == "Left" then
		renderer.text(20, height/2, r,g,b, a2, "", 0, output)
	end
end

screen_indication.handle = function()
	
	local anim = {}
	local indication_enable     =    Vars.Misc.screen_indicators:get()
	local accent_color          =  { Vars.Misc.screen_indicators.color:get() }		

	anim.main = animations.new('screen_indication_main', indication_enable and 255 or 0)

	local x, y = client.screen_size()
	local center = { x*0.5, y*0.5+25 }

	if not (indication_enable or Vars.Misc.branded_watermark:get()) then
		if Vars.Misc.alt_watermark.value == "Modern" then
			screen_indication.luasense(255)
		else
			render.text(center[1], y - 15, 255, 255, 255, 200, 'cb', 0, 'angelwings')
		end
	end

	local plocal = entity.get_local_player()
    if plocal == nil or not entity.is_alive(plocal) then
        return
    end

	if (Vars.Misc.screen_indicators_settings_dmg and Vars.Misc.screen_indicators_settings_dmg:get()) then
		if ui.get(gamesense_refs.dmgOverride[1]) and ui.get(gamesense_refs.dmgOverride[2]) and ui.get(gamesense_refs.dmgOverride[3]) then
			render.text(x*0.5 + 2, y*0.5 - 14, 255, 255, 255, 255, nil, 0, tostring(ui.get(gamesense_refs.dmgOverride[3])))
		end
	end

	if anim.main < 0.1 then
		return
	end

	local binds = {
        {'dt', ui.get(gamesense_refs.dt[1]) and ui.get(gamesense_refs.dt[2])},
        {'hide', ui.get(gamesense_refs.os[1]) and ui.get(gamesense_refs.os[2])},
        {'safe', ui.get(gamesense_refs.safePoint)},
        {'body', ui.get(gamesense_refs.forceBaim)},
        {'dmg', ui.get(gamesense_refs.dmgOverride[1]) and ui.get(gamesense_refs.dmgOverride[2]) and ui.get(gamesense_refs.dmgOverride[3])},
        {'fs', ui.get(gamesense_aa.freestanding[1]) and ui.get(gamesense_aa.freestanding[2])}
    }
	
	local conds = {
        'shared',
        'standing',
        'running',
        'slowwalking',
        'ducking',
        'moving+duck',
        'air',
        'air+duck',
        'freestand',
        'fakelag',
        'on-use'
    }

	local scope_based = entity.get_prop(plocal, 'm_bIsScoped') ~= 0
	local add_y = 0

	anim.name = {}
	anim.name.alpha = animations.new('lua_name_alpha', indication_enable and 255 or 0)
	anim.name.move = animations.new('binds_move_name', indication_enable and not scope_based and -render.measure_text(nil, 'angelwings')*0.5 or 15)
    anim.name.glow = animations.new('glow_name_alpha', (indication_enable and Vars.Misc.screen_indicators_settings.glow:get()) and 50 or 0)
	if anim.name.alpha > 1 then
		if anim.name.glow > 1 then
			render.shadow(center[1]+1 + anim.name.move, center[2]+7, render.measure_text('b', 'angelwings')-1, 0, 10, 0, {accent_color[1], accent_color[2], accent_color[3], anim.name.glow}, {accent_color[1], accent_color[2], accent_color[3], anim.name.glow})
		end
		render.text(center[1] + string.format('%.0f', anim.name.move), center[2], 255, 255, 255, anim.main, 'b', 0, utils.animate_text(globals.curtime()*2, 'angelwings', accent_color[1], accent_color[2], accent_color[3], anim.main, accent_color[1], accent_color[2], accent_color[3], 150*(anim.main/255)))
		add_y = add_y + string.format('%.0f', anim.name.alpha / 255 * 12)
	end

    anim.state = {}
	anim.state.text = conds[conditional_antiaims.get_active_idx(conditional_antiaims.player_state)]
    anim.state.alpha = animations.new('state_alpha', indication_enable and 200 or 0)
	anim.state.scoped_check = animations.new('scoped_check', indication_enable and not scope_based and 1 or 0) ~= 1
	anim.state.move = anim.state.scoped_check and string.format('%.0f',animations.new('binds_move_state', indication_enable and not scope_based and -render.measure_text(nil, anim.state.text)*0.5 or 15)) or -render.measure_text(nil, anim.state.text)*0.5
	if anim.state.alpha > 1 then
		render.text(center[1] + anim.state.move, center[2] + add_y, 255, 255, 255, anim.state.alpha, nil, 0, anim.state.text)
        add_y = add_y + string.format('%.0f', anim.state.alpha / 255 * 15)
    end

    anim.binds = {}
    for k, v in pairs(binds) do

        anim.binds[v[1]] = {}
        anim.binds[v[1]].alpha = animations.new('binds_alpha_'..v[1], indication_enable and v[2] and 255 or 0)
        anim.binds[v[1]].move = animations.new('binds_move_'..v[1], indication_enable and not scope_based and -render.measure_text(nil, v[1])*0.5 or 15)

        if anim.binds[v[1]].alpha > 1 then 
            render.text(center[1] + string.format('%.0f', anim.binds[v[1]].move), center[2] + add_y, 255, 255, 255, anim.binds[v[1]].alpha, nil, 0, v[1])
			add_y = add_y + string.format('%.0f', anim.binds[v[1]].alpha / 255 * 12)
        end
    end
	crosshair_logger.indicators_height = 10 + add_y
end

crosshair_logger.hitgroups = { [0] = 'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', [10] = 'Gear'}
crosshair_logger.hit_types = { knife = ' Knifed', inferno = ' Burned', hegrenade = ' Naded' }
crosshair_logger.lerp = function(x, v, t)
    local delta = v - x;

    if math.abs(delta) < 0.005 then
        return v
    end

    return x + delta * t
end
crosshair_logger.handle = function()
	local screen = {client.screen_size()}
	local center = {screen[1] * 0.5, screen[2] * 0.5 + 31}

	local scope_based = entity.get_prop(entity.get_local_player(), 'm_bIsScoped') ~= 0
	crosshair_logger.move = animations.new('crosshair_logger.move', (Vars.Misc.crosshair_hitlog and Vars.Misc.crosshair_settings.move:get()) and scope_based and 1 or 0)
    local logs_size = #crosshair_logger
    for key = logs_size, 1, -1 do
        local value = crosshair_logger[key]

        if value.alpha == 1 then
            table.remove(crosshair_logger, key)
            goto skip
        end

        local fullstr = table.concat(value.args, '')
        local alpha = 1 - math.abs(value.alpha)
        local base_color = { value.color[1], value.color[2], value.color[3], value.color[4] * alpha }

        local base_hex = '\a' .. utils.rgb_to_hex(base_color)
        local alternative = '\a' .. utils.rgb_to_hex({255, 255, 255, 200 * alpha})
        local string = alternative

        for index, text in ipairs(value.args) do
            local temp = text
            if index % 2 == 0 then
                temp = base_hex .. temp .. alternative
            end
            string = string .. temp
        end

		local text_sz = { render.measure_text('cd', fullstr) }
        local x, y = center[1] + ((text_sz[1]*0.5+12)*crosshair_logger.move), center[2] + crosshair_logger.indicators_height
		render.text(x, y, 255, 255, 255, 200 * alpha, 'cd', 0, string)

        local height = text_sz[2] + 1
        height = height * alpha
        center[2] = center[2] + height
		
        if (globals.realtime() - value.time > 0) or (key > 4) then
            value.alpha = crosshair_logger.lerp(value.alpha, 1, globals.frametime() * 12)
        else
            value.alpha = crosshair_logger.lerp(value.alpha, 0, globals.frametime() * 12)
        end

        ::skip::
    end
end

crosshair_logger.player_hurt = function(e)
    if not (Vars.Misc.crosshair_hitlog and Vars.Misc.crosshair_hitlog:get()) then
        return
    end

    local localplayer = entity.get_local_player()
    if not localplayer then
        return
    end

    if e.health < 0 then
        return
    end

    local attacker = client.userid_to_entindex(e.attacker)
    local userid = client.userid_to_entindex(e.userid)

    if attacker ~= localplayer then
        return
    end

    if userid == localplayer then
        return
    end

    if e.weapon == 'molotov' then
        return
    end

    local args = {}
    local hit_type = crosshair_logger.hit_types[e.weapon] or ''
    table.insert(args, hit_type)
    table.insert(args, entity.get_player_name(userid))

    if e.hitgroup ~= 0 then
        local hitgroup = crosshair_logger.hitgroups[e.hitgroup] or '?'
        table.insert(args, hitgroup:lower())
    end

    table.insert(args, e.dmg_health)
    table.insert(args, '(\\not')
    table.insert(args, e.health .. '\\not')
    table.insert(args, ')')

    local length = #args
    for key, value in ipairs(args) do
        if key == length then
            goto skip
        end

        if type(value) == 'string' and value:find('\\not') then
            args[key] = value:gsub('\\not', '')
        else
            args[key] = value .. '\x20'
        end

        ::skip::
    end

	if Vars.Misc.crosshair_settings then
		crosshair_logger.add({Vars.Misc.crosshair_settings.hit_color.color:get()}, args)
	end
end

crosshair_logger.aimbot_data = {}
crosshair_logger.aim_fire = function(e)
    local localplayer = entity.get_local_player()
    if not localplayer then
        return
    end

    crosshair_logger.aimbot_data[e.id] = {
        original = e,
        total_hits = entity.get_prop(localplayer, 'm_totalHitsOnServer')
    }
end

crosshair_logger.aim_miss = function(e)
	if not (Vars.Misc.crosshair_hitlog and Vars.Misc.crosshair_hitlog:get()) then
        return
    end

    local localplayer = entity.get_local_player()
    if not localplayer then
        return
    end

    local args = {}
    local pre_data = crosshair_logger.aimbot_data[e.id]
    local reason = e.reason

    if reason == '?' then
        reason = 'unknown'

        if pre_data.total_hits ~= entity.get_prop(localplayer, 'm_totalHitsOnServer') then
            reason = 'damage rejection'
        end
    end

    table.insert(args, ' Missed in')
    local hitgroup = crosshair_logger.hitgroups[e.hitgroup] or '?'

    table.insert(args, hitgroup:lower())
    table.insert(args, 'due to')
    table.insert(args, reason)

    local length = #args;
    for key, value in ipairs(args) do
        if key == length then
            goto skip
        end

        if type(value) == 'string' and value:find('\\not') then
            args[ key ] = value:gsub('\\not', '')
        else
            args[ key ] = value .. '\x20'
        end

        ::skip::
    end

	if Vars.Misc.crosshair_settings then
		crosshair_logger.add({Vars.Misc.crosshair_settings.miss_color.color:get()}, args)
	end
end

crosshair_logger.add = function(color, args)
    local this = {
        color = color;
        args = args;
        alpha = -1;
        time = globals.realtime() + 5;
    };

    table.insert(crosshair_logger, 1, this);
    return this
end

death_spammer.phares = {
	"Ты как убил меня?", "?", "да каааааак", "БЛЯ КАК", "cerf t,fyfz", "ну везет же", "найс везет хуесос", "ХАХАХАХА ДАУН КАК ТЫ УБИВАЕШЬ МЕНЯ В ЛОУДЕЛЬТУ", "пидор дырявый", 
	"залупой зубы бы тебе выбил гандон", "ПИДОАРС БЛЯЯЯЯ", "ахах чел ты меня убиваешь онли по ногам и то когда я лоу хп", "LUCKBOOST.CFG <-- UR CFG RN ", "да почему за меня вечно дегенераты",
	"ASDJASDHUIASOGHDAIHaIHSDIOADHAIDHASDIHIuh--[oDAHSDOIasD", "ты такой конченый блять", "cerf", "нахера ты летишь на меня тупой фывфыгвпфнвфнгвпфыгнвпфыгшнвпфнгв", 
	"у меня же десинк 40 градусов каааааак", "как ты своим вейви мой скит убил", "тупой хуесос без скита", "почему тебе можно просто лететь на меня и делать хуйню а мне нельззщя",
	"ААААААААААААААААААААААААААААААААААААААААА", "что ты делаешь даун", "миндамаг не выбил", "найс с дамагом хуесос", "даблтап забыл отжать бля", "КАК В ХАЙДШОТСЫ СУКА", 
	"ну зачем с фейклагами то", "глянь что долбаёб с никсваром делает", "блять как этим автопиком пользоваться", "Я СКОРО КОМП НАХУЙ СЛОМАЮ СУКА", "мышка лагает пиздец", "клавиша отпала", "да как с этим говном играть", "что за чит у тебя?", 
	"ljk,ft, t,fysq cerf", "сука пробел залип", "[gamesense] miss to resolver", "[gamesense] miss to spread", "[gamesens e] missed to resolver", "cerf ghj,tk pfkbg", "блять у меня ошибка вылезла", "что за хуйня у меня просто монитор погас", "СУКА Я ЧАЙ ПРОЛИЛ НА КЛАВУ"
}

death_spammer.handle = function(e)
	if not Vars.Misc.deathsay:get() then
        return
    end

    local attacker_entindex = client.userid_to_entindex(e.attacker)
    local victim_entindex   = client.userid_to_entindex(e.userid)
    local localplayer       = entity.get_local_player
    local enemy             = entity.is_enemy

    if victim_entindex == localplayer() and attacker_entindex ~= localplayer() then
        client.delay_call(client.random_int(4, 8), function()
            client.exec("say ".. death_spammer.phares[client.random_int(1, #death_spammer.phares)])
        end)
    end
end

chat_spammer.phrases = {
"♛ＺＥＭＩＲＡＧＥ ＣＲＥＷ♛","Ｄｏ ｎｏｔ ｔｅｓｔ ｍｙ ＡＡ．","ϯвøю ʍαʍαωӄყ øϯъεbαԉ прøςϯøрӈø", "ℙ𝕆𝕊𝕋 𝕋ℍ𝕀𝕊 𝕆ℕ ℙℝ𝕆𝔽𝕀𝕃𝔼𝕊 𝕆ℕ 𝕋ℍ𝔼 ℙ𝔼𝕆ℙ𝕃𝔼 𝕐𝕆𝕌 𝔸ℝ𝔼 ℝ𝕀ℂ𝔼ℍ𝔼ℝ 𝕋ℍ𝔸ℕ, 𝕋𝕆 ℂ𝔸𝕃𝕃 𝕋ℍ𝔼𝕄 ℙ𝕆𝕆ℝ! 𝕀𝔽 𝕐𝕆𝕌 𝔾𝕆𝕋 𝕋ℍ𝕀𝕊 ℂ𝕆𝕄𝕄𝔼ℕ𝕋... 𝕎𝔼𝕃𝕃... 𝕐𝕆𝕌 𝕂ℕ𝕆𝕎 𝕎ℍ𝔸𝕋 𝕀𝕋 𝕄𝔼𝔸ℕ𝕊! ♛ (◣_◢) ♛", "Ｆｏｒｃｅ Ｓａｆｅｐｏｉｎｔ ＝ Ｉｎｓｔａ Ｋｉｌｌ","Wʜᴇɴ I ᴀᴜᴛᴏ ᴡᴀʟʟ, ᴀʟʟ ᴅᴏɢs ᴀʀᴇ sɪʟᴇɴᴛ","Ｏｎｅ ｓｈｏｔ， ｏｎｅ ｋｉｌｌ．","Ｎｏ ｌｕｃｋ， ａｌｌ ｓｋｉｌｌ．","𝟙", "ʜαсτσяɰαя ɓρατɞα - ϶τσ ϱ∂υʜυʯы, κστσρыϱ υсησ᧘ьʒƴюτ ANGELWINGS", "оωиҕки - это докᴀзᴀтᴇльство тоrо, что ты ссᴀныи пидоᴘᴀс", "϶ᴛᴏ angelwings, чᴛᴏ я дᴧя ᴛᴇбя уᴋᴩᴀᴧ", "я подᴀᴘил им всᴇм звᴇздʏ, вᴇдь подᴀᴘил им angelwings", "Обычно, девочки любят сонечку чу, а мальчики — ангелвингс. Но это только до 17 лет. А потом всё становится наоборот.", "Прощать не сложно, сложно заново поверить.", "Запомни братишка одну благодать, тебя ждет не телка, а ангелвингс", "【﻿Ибу тя в подвале】", "кумарнул ♕Ｐ Ｏ Ｄ１Ｋ♕", "не вижу предела / angelwings", "𝕊𝕆ℝℝ𝕐 𝔾𝕌𝕐𝕊 ｡.｡:+*", "MaJIeHkuu_Ho_OnacHekuu",  "ⒶaŴÞ ︻デ 一 PUTIN", 
"♛ｇｈｆｄｂｋｆ ♛", "ＳＯＳＩ ＭＯＹ ＣＨＯＰＰＡ ＣＨＵＰＳ",  "𝒰 𝒢О𝒯 ♡𝒲𝒩𝐸𝒟 𝑀𝒴 ангельские крылья", ":･ﾟ✧𝐅𝐔𝐂𝐊 𝐘𝐎𝐔","✧･ﾟ𝕂𝕐𝕊","♛ 𝕃𝕚𝕟𝕜 𝕞𝕒𝕚𝕟 𝕓𝕖𝕗𝕠𝕣𝕖 𝕤𝕡𝕖𝕒𝕜𝕚𝕟𝕘. ♛",  "♛ 𝕋𝕙𝔼 𝕘𝕃𝕠𝔹𝕒𝕃 𝕖𝕃𝕚𝕋𝕖 𝕄𝕒𝕊𝕥𝔼𝕣 𝕊𝕠𝕆𝕟 𝕋𝕄 ♛", "𝕚 𝕒𝕞 𝕙𝕧𝕙 𝕨𝕚𝕟𝕟𝕖𝕣 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝟙𝟙 𝕒𝕟𝕕 𝕤𝕙𝕒𝕕𝕠𝕨 𝕕𝕒𝕘𝕘𝕖𝕣𝕤 𝕣𝕦𝕤𝕥 𝕔𝕠𝕒𝕥 𝕔𝕠𝕞𝕚𝕟𝕘 𝕤𝕠𝕠𝕟", "˜”*°•.˜”*°• suck dick iqless doG •°*”˜.•°*”˜", "ₓ˚. ୭ ˚○◦˚𝒾𝓆𝓁𝑒𝓈𝓈 𝒹𝑜𝑔˚◦○˚ ୧ .˚ₓ",
"♛ ＳＵＳＳＹ ＢＡＬＬＳ ♛", "”*°•.★..Angel_Of_The_Night..★.•°*”˜ :", "𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕚𝕤 𝕙𝕠𝕨 𝕨𝕖 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖 ♛ 𝕞𝕒𝕜𝕖 𝕣𝕚𝕔𝕙 𝕞𝕒𝕚𝕟𝕤, 𝕟𝕠𝕥 𝕗𝕣𝕚𝕖𝕟𝕕𝕤", "ⒶaŴÞ ︻デ 一", 
"Draining rn // cant 𝑅𝑒𝓅𝓁𝓎", "Ｉ ＝ ＡＮＧＥＬＷＩＮＧＳ ， Ｕ － ＮＯ ＣＨＡＮＳ", "ｄｏ ｙｏｕ ｋｉｔｔｅｎ ｍｅ ｒｉｇｈｔ ｍｅｏｗ", "𝖜𝖎𝖘𝖊 𝖎𝖘 𝖓𝖔𝖙 𝖆𝖑𝖜𝖆𝖞𝖘 𝖜𝖎𝖘𝖊",
"Ищи себя в овердоузед дрейнерши","cya в подслушано мемесенс", "Ебать тебя козявит", "VAAAAAAAC в чат!!! (づ ◕‿◕ )", "3Jlou_ЗAdrOT", "ñüѫ¤Ƥ ñüƺѫå ϯÿƺ ɱ¤н¤ȹя", "♛Ａｌｌ Ｆａｍｉｌｙ ｉｎ ｎｏｖｏ♛", ";w;","=w=", "𝕪𝕠𝕦𝕣 𝕒𝕟𝕥𝕚𝕒𝕚𝕞 𝕤𝕠𝕝𝕧𝕖𝕕 𝕝𝕚𝕜𝕖 𝕒𝕝𝕘𝕖𝕓𝕣𝕒 𝕖𝕢𝕦𝕒𝕥𝕚𝕠𝕟", "ęβãł țýä √ řøţ", "AHHAHAHHAHAHH LIFEHACK ♥♥♥♥♥", "ПуЛи_От_БаБуЛи", "ПаРеНь БеЗ сТрАхА", "づ 从闩从长丫 仨五闩人", "1000-7 🅷🆅🅷", 
"ñƤüβ£ϯ ΨнӹƤь ϯ£ნя £ნ£ϯ j£§ɥ§","忍び 1 УПАЛ び忍", "THIS nigga is so retarded", "(◣◢) 𝕐𝕠𝕦 𝕒𝕨𝕒𝕝𝕝 𝕗𝕚𝕣𝕤𝕥? 𝕆𝕜 𝕝𝕖𝕥𝕤 𝕗𝕦𝕟 🙂", "𝕚 𝕒𝕞 𝕙𝕧𝕙 𝕨𝕚𝕟𝕟𝕖", "𝙢𝙖𝙠𝙚 𝙨𝙠𝙚𝙚𝙩 𝙣𝙤 𝙛𝙧𝙞𝙚𝙣𝙙𝙨", "ａｌｌ　ｆａｍｉｌｙ　ａｗａｌｌ　ロく河", "𝘄𝗵𝗲𝗻 𝗶 𝗽𝗹𝗮𝘆 𝗺𝗮𝗶𝗻 𝗶 𝗰𝗮𝗿𝗲 𝗳𝗼𝗿 𝘀𝗺𝗼𝗸𝗲", 
"ᴋᴏᴦдᴀ ᴛы ᴨᴩᴀʙ, ниᴋᴛᴏ ϶ᴛᴏᴦᴏ нᴇ ɜᴀᴨᴏʍинᴀᴇᴛ, ᴀ ᴋᴀᴋ ᴏɯибᴄя - ɜнᴀчиᴛ быᴧ бᴇɜ angelwings.pink",
'Эᴛᴏ ᴩᴇдᴋᴏᴄᴛь - чᴇᴧᴏʙᴇᴋ, хᴄᴀющий angelwings',
'ɜᴀ ᴋᴀждᴏй уᴄᴨᴇɯнᴏй жᴇнщинᴏй ᴄᴛᴏиᴛ ᴨᴩᴇдᴀᴛᴇᴧьᴄᴛʙᴏ ʍужчин, ɜᴀ ᴋᴀждыʍ уᴄᴨᴇɯныʍ ʍужчинᴏй ᴄᴛᴏиᴛ ᴄᴛᴀᴋ ᴄ angelwings.pink',
'ᴏ жиɜни и дᴇньᴦᴀх нᴀчинᴀюᴛ дуʍᴀᴛь, ᴋᴏᴦдᴀ ʙ их жиɜни ᴨᴏяʙᴧяᴇᴛᴄя angelwings.pink',
'ᴇᴄᴧи у ᴛᴇбя хᴏᴩᴏɯᴇᴇ нᴀᴄᴛᴩᴏᴇниᴇ, ᴛᴏ дᴧя ᴨᴏᴧнᴏᴦᴏ ᴄчᴀᴄᴛья ᴛᴏᴧьᴋᴏ angelwings.pink нᴇ хʙᴀᴛᴀᴇᴛ',
'ᴧюди ᴛᴏжᴇ ᴄᴛᴩᴀдᴀюᴛ, ᴏᴛᴛᴏᴦᴏ, чᴛᴏ у них нᴇᴛ angelwings.pink',
'быᴛь бᴏᴦᴀᴛыʍ и иʍᴇᴛь ʍнᴏᴦᴏ дᴇнᴇᴦ нᴇ ᴏднᴏ и ᴛᴏ жᴇ, ᴨᴏ нᴀᴄᴛᴏящᴇʍу бᴏᴦᴀᴛ, ᴛᴏᴛ ᴋᴛᴏ иʍᴇᴇᴛ angelwings.pink',
'ᴧюди нᴇ хᴏᴛяᴛ быᴛь бᴏᴦᴀᴛыʍи, ᴧюди хᴏᴛяᴛ angelwings.pink',
'бᴇднᴏʍу нужᴇн ʍиᴧᴧиᴏн, бᴏᴦᴀᴛᴏʍу нужᴇн angelwings.pink',
'ᴋᴛᴏ иʍᴇᴇᴛ angelwings.pink, ᴛᴏᴛ ʙᴄᴇᴦдᴀ дᴏᴄᴛᴀᴛᴏчнᴏ бᴏᴦᴀᴛ',
'нᴇ ᴄᴨᴏᴩь ᴄᴏ ʍнᴏй, angelwings.pink нᴇᴨᴏбᴇдиʍᴀ.',
'дᴇᴛᴄᴛʙᴏ ɜᴀᴋᴀнчиʙᴀᴇᴛᴄя ᴛᴏᴦдᴀ, ᴋᴏᴦдᴀ у ᴛᴇбя ᴨᴏяʙᴧяᴇᴛᴄя angelwings.pink',
'ʙ ʍᴏᴇʍ дᴇᴛᴄᴛʙᴇ нᴇ быᴧᴏ ʍᴏбиᴧьных ᴛᴇᴧᴇɸᴏнᴏʙ и инᴛᴇᴩнᴇᴛᴀ, нᴏ я ʙᴄᴇᴦдᴀ ɜнᴀᴧ, чᴛᴏ angelwings.pink будᴇᴛ ᴧучɯᴇй.' ,
'ниᴋᴏᴦдᴀ нᴇ ᴨᴏɜднᴏ уᴄᴛᴩᴏиᴛь ᴄᴇбᴇ ᴄчᴀᴄᴛᴧиʙую жиɜнь, и ᴨᴩиᴋуᴨиᴛь angelwings.pink',
'ᴄᴀʍᴀя бᴏᴧьɯᴀя ᴨᴏᴛᴇᴩя дᴧя чᴇᴧᴏʙᴇᴋᴀ, ϶ᴛᴏ ᴨᴏᴛᴇᴩя angelwings.pink',
'ʙ дᴇᴛᴄᴛʙᴇ дᴧя ᴄчᴀᴄᴛья быᴧᴏ дᴏᴄᴛᴀᴛᴏчнᴏ ᴏднᴏᴦᴏ ʍᴏᴩᴏжᴇнᴏᴦᴏ, ᴄᴇйчᴀᴄ жᴇ ʙᴄᴇʍ нᴀʍ нужᴇн angelwings.pink',
'ни у ᴋᴏᴦᴏ жиɜнь нᴇ быʙᴀᴇᴛ ᴛᴀᴋᴏй, ᴋᴀᴋ у ᴧюдᴇй ᴄ angelwings.pink',
'дᴏбᴩый чᴇᴧᴏʙᴇᴋ нᴇ ᴛᴏᴛ, ᴋᴛᴏ уʍᴇᴇᴛ дᴇᴧᴀᴛь дᴏбᴩᴏ, ᴀ ᴛᴏᴛ, у ᴋᴏᴦᴏ ᴇᴄᴛь angelwings.pink',
'ɜнᴀᴇɯь, чᴛᴏ ᴨуᴦᴀᴇᴛ бᴏᴧьɯᴇ ʙᴄᴇᴦᴏ, ᴋᴩᴏʍᴇ ᴄᴛᴩᴀхᴀ ᴏᴄᴛᴀᴛьᴄя ᴏднᴏʍу? ᴨᴩᴏʙᴇᴄᴛи ʙᴄю жиɜнь бᴇɜ angelwings.pink',
'я ʍнᴏᴦᴏ ᴄᴛᴩᴀдᴀᴧ, я ʙᴄᴇᴦдᴀ ᴏɯибᴀᴧᴄя, ʙᴇдь я быᴧ бᴇɜ angelwings.pink',
'ʍы ᴧᴇᴦᴋᴏ ɜᴀбыʙᴀᴇʍ ᴄʙᴏи ᴏɯибᴋи, ᴋᴏᴦдᴀ ᴨᴏᴋуᴨᴀᴇʍ angelwings.pink',
'ниᴋᴏᴦдᴀ нᴇ ᴄᴧᴇдуᴇᴛ ᴦᴏʙᴏᴩиᴛь ᴋᴏʍу-ᴧибᴏ, чᴛᴏ ᴏн нᴇ ᴨᴩᴀʙ, ᴀ чᴛᴏ ᴏн ᴧиɯь ᴄᴄᴀный хуᴇᴄᴏᴄ бᴇɜ angelwings.pink',
'ᴦᴧᴀʙнᴏᴇ дᴧя ʍужчины - иʍᴇᴛь angelwings.lua',
'ᴄᴀʍᴀя ʙᴩᴇднᴀя ᴏɯибᴋᴀ - ϶ᴛᴏ нᴇ ʙᴇᴩиᴛь чᴛᴏ angelwings.pink ᴧучɯᴇ ʙᴄᴇх',
"я ķ¤нɥåλ ϯβ¤£ü ɱåɱķ£ β Ƥ¤ϯ.",'•۩۞۩[̲̅П̲̅о̲̅Л̲̅Ю̲̅б̲̅А̲̅С(ٿ)̲̅Ч̲̅и̅Т̲̲̅АК̲̅]۩۞۩•','YбИuЦа_КрИпЕrОв','+Yeb@shu_v_k@shu+','Н.Е.С.О.К.Р.У.Ш.И.М.Ы.Й','KpyToI_4elOBeK',"𝖋𝖊𝖊𝖑 𝖙𝖍𝖊 𝖋𝖚𝖈𝖐𝖎𝖓𝖌 𝖌𝖆𝖒𝖊𝖘𝖊𝖓𝖘𝖊", "𝔱𝔥𝔢 𝔰𝔱𝔲𝔣𝔣 𝔶𝔬𝔲 𝔥𝔢𝔞𝔯𝔡 𝔞𝔟𝔬𝔲𝔱 𝔪𝔢 𝔦𝔰 𝔞 𝔩𝔦𝔢 ℑ 𝔞𝔪 𝔪𝔬𝔯𝔢 𝔴𝔬𝔯𝔰𝔢 𝔱𝔥𝔞𝔫 𝔶𝔬𝔲 𝔱𝔥𝔦𝔫𝔨", "𝔗𝔥𝔢 𝔬𝔫𝔩𝔶 𝔠𝔯𝔦𝔪𝔢 𝔦𝔫 𝔥𝔳𝔥 𝔦𝔰 𝔱𝔬 𝔩𝔬𝔰𝔢",  "☆꧁✬◦°˚°◦. ɮʏ ɮɛֆȶ ʟʊǟ .◦°˚°◦✬꧂☆", "vroom vroom! по ЕБУЧКЕ",'(◣◢)𝕚 𝕕𝕠𝕟𝕥 𝕔𝕒𝕣𝕖 𝕗𝕠𝕣 𝕤𝕞𝕠𝕜𝕖, 𝕚 𝕒𝕞 𝕟𝕠𝕥 𝕞𝕒𝕚𝕟. (◣◢)',"𝙒𝙝𝙚𝙣 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙈𝙈 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙛𝙤𝙧 𝙬𝙞𝙣, 𝙙𝙤𝙣'𝙩 𝙨𝙘𝙖𝙧𝙚 𝙛𝙤𝙧 𝙨𝙥𝙞𝙣, 𝙞 𝙞𝙣𝙟𝙚𝙘𝙩 𝙧𝙖𝙜𝙚 ♕", '𝕚𝕞 𝕨𝕚𝕟 𝕚𝕗 𝕚𝕞 𝕨𝕒𝕟𝕥. 𝕞𝕪 𝕤𝕡𝕚𝕟𝕓𝕠𝕥 𝕒𝕔𝕥𝕚𝕧𝕒𝕥𝕖𝕕 𝕟𝕠 𝕔𝕙𝕒𝕟𝕔𝕖 𝕗𝕠𝕣 𝕖𝕟𝕖𝕞𝕪', "𝙽𝚒𝚐𝚑𝚝𝚌𝚘𝚛𝚎𝚍", "BY ANGELWINGS 美國人 ? WACHINA ( TEXAS ) يورپ technologies","god wish i had ANGELWINGS $$$","𝕗𝕦𝕔𝕜 𝕪𝕠𝕦𝕣 𝕗𝕒𝕞𝕚𝕝𝕪 𝕒𝕟𝕕 𝕗𝕣𝕚𝕖𝕟𝕕𝕤, 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕦𝕡 ♚","𝐨𝐮𝐫 𝐥𝐢𝐟𝐞 𝐦𝐨𝐭𝐨 𝐢𝐬 𝐖𝐈𝐍 > 𝐀𝐂𝐂","꧁༺rJloTau mOu Pir()zh()]{ (c) SoSiS]{oY:XD ", "𝒪𝒱𝐸𝑅𝒟𝒪𝒮𝐸𝒟 𝐻𝒰𝐼𝒮𝒪𝒮", "＄＄＄ ｒｉｃｈ ｍｙ angelwings ＄＄＄","Чо папе чо маме?",'Сасеш как снеговик', '𝔂𝓸𝓾 𝓭𝓸𝓷𝓽 𝓷𝓮𝓮𝓭 𝓯𝓻𝓲𝓮𝓷𝓭𝓼 𝔀𝓱𝓮𝓷 𝔂𝓸𝓾 𝓱𝓪𝓿𝓮 𝓷𝓸𝓿𝓸𝓵𝓲𝓷𝓮𝓱𝓸𝓸𝓴','𝚜𝚎𝚖𝚒𝚛𝚊𝚐𝚎 𝚝𝚒𝚕𝚕 𝚢𝚘𝚞 𝚍𝚒𝚎, 𝚋𝚞𝚝 𝚠𝚎 𝚕𝚒𝚟𝚎 𝚏𝚘𝚛𝚎𝚟𝚎𝚛 (◣_◢)',"𝕝𝕚𝕗𝕖 𝕚𝕤 𝕒 𝕘𝕒𝕞𝕖, 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕚𝕤 𝕙𝕠𝕨 𝕨𝕖 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖 ♛ 𝕞𝕒𝕜𝕖 𝕣𝕚𝕔𝕙 𝕞𝕒𝕚𝕟𝕤, 𝕟𝕠𝕥 𝕗𝕣𝕚𝕖𝕟𝕕𝕤", 
"𝙒𝙝𝙚𝙣 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙈𝙈 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙛𝙤𝙧 𝙬𝙞𝙣, 𝙙𝙤𝙣'𝙩 𝙨𝙘𝙖𝙧𝙚 𝙛𝙤𝙧 𝙨𝙥𝙞𝙣, 𝙞 𝙞𝙣𝙟𝙚𝙘𝙩 𝙧𝙖𝙜𝙚 ♕", 
"𝒯𝒽𝑒 𝓅𝓇𝑜𝒷𝓁𝑒𝓂 𝒾𝓈 𝓉𝒽𝒶𝓉 𝒾 𝑜𝓃𝓁𝓎 𝒾𝓃𝒿𝑒𝒸𝓉 𝒸𝒽𝑒𝒶𝓉𝓈 𝑜𝓃 𝓂𝓎 𝓂𝒶𝒾𝓃 𝓉𝒽𝒶𝓉 𝒽𝒶𝓋𝑒 𝓃𝒶𝓂𝑒𝓈 𝓉𝒽𝒶𝓉 𝓈𝓉𝒶𝓇𝓉 𝓌𝒾𝓉𝒽 𝒩 𝒶𝓃𝒹 𝑒𝓃𝒹 𝓌𝒾𝓉𝒽 𝑜𝓋𝑜𝓁𝒾𝓃𝑒𝒽𝑜𝑜𝓀", 
"(◣◢) 𝕐𝕠𝕦 𝕒𝕨𝕒𝕝𝕝 𝕗𝕚𝕣𝕤𝕥? 𝕆𝕜 𝕝𝕖𝕥𝕤 𝕗𝕦𝕟 🙂 (◣◢)", 
"ｉ ｃａｎｔ ｌｏｓｅ ｏｎ ｏｆｆｉｃｅ ｉｔ ｍｙ ｈｏｍｅ", 
"𝕞𝕒𝕚𝕟 𝕟𝕖𝕨= 𝕔𝕒𝕟 𝕓𝕦𝕪.. 𝕙𝕧𝕙 𝕨𝕚𝕟? 𝕕𝕠𝕟𝕥 𝕥𝕙𝕚𝕟𝕜 𝕚𝕞 𝕔𝕒𝕟, 𝕚𝕞 𝕝𝕠𝕒𝕕 𝕣𝕒𝕘𝕖 ♕", 
"♛Ａｌｌ   Ｆａｍｉｌｙ   ｉｎ   ｎｏｖｏ♛", 
"u will 𝕣𝕖𝕘𝕣𝕖𝕥 rage vs me when i go on ｌｏｌｚ．ｇｕｒｕ acc.", 
"𝔻𝕠𝕟𝕥 𝕒𝕕𝕕 𝕞𝕖 𝕥𝕠 𝕨𝕒𝕣 𝕠𝕟 𝕞𝕪 𝕤𝕞𝕦𝕣𝕗 (◣◢) 𝕟𝕠𝕧𝕠𝕝𝕚𝕟𝕖 𝕒𝕝𝕨𝕒𝕪𝕤 𝕣𝕖𝕒𝕕𝕪 ♛", 
"♛ 𝓽𝓾𝓻𝓴𝓲𝓼𝓱 𝓽𝓻𝓾𝓼𝓽 𝓯𝓪𝓬𝓽𝓸𝓻 ♛", 
"𝕕𝕦𝕞𝕓 𝕕𝕠𝕘, 𝕪𝕠𝕦 𝕒𝕨𝕒𝕜𝕖 𝕥𝕙𝕖 ᴅʀᴀɢᴏɴ ʜᴠʜ ᴍᴀᴄʜɪɴᴇ, 𝕟𝕠𝕨 𝕪𝕠𝕦 𝕝𝕠𝕤𝕖 𝙖𝙘𝙘 𝕒𝕟𝕕 𝚐𝚊𝚖𝚎 ♕", 
"♛ 𝕞𝕪 𝕙𝕧𝕙 𝕥𝕖𝕒𝕞 𝕚𝕤 𝕣𝕖𝕒𝕕𝕪 𝕘𝕠 𝟙𝕩𝟙 𝟚𝕩𝟚 𝟛𝕩𝟛 𝟜𝕩𝟜 𝟝𝕩𝟝 (◣◢)", 
"ᴀɢᴀɪɴ ɴᴏɴᴀᴍᴇ ᴏɴ ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ. ɪ ꜱᴇᴇ ᴀɢᴀɪɴ ᴀᴄᴛɪᴠɪᴛʏ.", 
"ɴᴏɴᴀᴍᴇ ʟɪꜱᴛᴇɴ ᴛᴏ ᴍᴇ ! ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ ɪꜱ ɴᴏᴛ ʏᴏᴜʀ ᴘʀᴏᴘᴇʀᴛʏ.", 
"𝙋𝙤𝙤𝙧 𝙖𝙘𝙘 𝙙𝙤𝙣’𝙩 𝙘𝙤𝙢𝙢𝙚𝙣𝙩 𝙥𝙡𝙚𝙖𝙨𝙚 ♛", 
"𝕥𝕣𝕪 𝕥𝕠 𝕥𝕖𝕤𝕥 𝕞𝕖? (◣◢) 𝕞𝕪 𝕞𝕚𝕕𝕕𝕝𝕖 𝕟𝕒𝕞𝕖 𝕚𝕤 𝕘𝕖𝕟𝕦𝕚𝕟𝕖 𝕡𝕚𝕟 ♛", 
"𝓭𝓸𝓷𝓽 𝓝𝓝", 
"ℕ𝕠 𝕆𝔾 𝕀𝔻? 𝔻𝕠𝕟'𝕥 𝕒𝕕𝕕 𝕞𝕖 𝓷𝓲𝓰𝓰𝓪", 
"𝐻𝒱𝐻 𝐿𝑒𝑔𝑒𝓃𝒹𝑒𝓃 𝟤𝟢𝟤𝟤 𝑅𝐼𝒫 𝐿𝒾𝓁 𝒫𝑒𝑒𝓅 & 𝒳𝓍𝓍𝓉𝑒𝒶𝓃𝒸𝒾𝑜𝓃 & 𝒥𝓊𝒾𝒸𝑒 𝒲𝓇𝓁𝒹", 
"𝕚 𝕟𝕠𝕧𝕠 𝕦𝕤𝕖𝕣, 𝕟𝕠 𝕟𝕠𝕧𝕠 𝕟𝕠 𝕥𝕒𝕝𝕜", 
"𝐨𝐮𝐫 𝐥𝐢𝐟𝐞 𝐦𝐨𝐭𝐨 𝐢𝐬 𝐖𝐈𝐍 > 𝐀𝐂𝐂", 
"𝕗𝕦𝕔𝕜 𝕪𝕠𝕦𝕣 𝕗𝕒𝕞𝕚𝕝𝕪 𝕒𝕟𝕕 𝕗𝕣𝕚𝕖𝕟𝕕𝕤, 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕦𝕡 ♚", 
"𝚜𝚎𝚖𝚒𝚛𝚊𝚐𝚎 𝚝𝚒𝚕𝚕 𝚢𝚘𝚞 𝚍𝚒𝚎, 𝚋𝚞𝚝 𝚠𝚎 𝚕𝚒𝚟𝚎 𝚏𝚘𝚛𝚎𝚟𝚎𝚛 (◣◢)", 
"𝔂𝓸𝓾 𝓭𝓸𝓷𝓽 𝓷𝓮𝓮𝓭 𝓯𝓻𝓲𝓮𝓷𝓭𝓼 𝔀𝓱𝓮𝓷 𝔂𝓸𝓾 𝓱𝓪𝓿𝓮 𝓷𝓸𝓿𝓸𝓵𝓲𝓷𝓮𝓱𝓸𝓸𝓴", 
"-ᴀᴄᴄ? ᴡʜᴏ ᴄᴀʀꜱ ɪᴍ ʀɪᴄʜ ʜʜʜʜʜʜ", 
"𝕙𝕖𝕙𝕖𝕙𝕖, 𝕦 𝕘𝕣𝕒𝕓 𝕞𝕪 𝕗𝕒𝕝𝕝 𝕘𝕦𝕪𝕤 𝕔𝕙𝕒𝕣𝕒𝕔𝕥𝕖𝕣? 𝕚 𝕘𝕣𝕒𝕓 𝕦𝕣 𝕓𝕒𝕟𝕜 𝕕𝕖𝕥𝕒𝕚𝕝𝕤. ♛", 
"𝔾𝕖𝕥 𝕕𝕖𝕒𝕝𝕥 𝕨𝕚𝕥𝕙 𝕝𝕚𝕥𝕥𝕝𝕖 𝕓𝕠𝕪, 𝕤𝕠 𝕤𝕚𝕞𝕡𝕝𝕖, 𝕕𝕠𝕟'𝕥 𝕖𝕧𝕖𝕣 𝕒𝕡𝕡𝕣𝕠𝕒𝕔𝕙 𝕞𝕖𝕞𝕓𝕖𝕣𝕤 𝕠𝕗 𝕞𝕪 𝕥𝕖𝕒𝕞 𝕝𝕚𝕜𝕖 𝕥𝕙𝕒𝕥 𝕖𝕧𝕖𝕣 𝕒𝕘𝕒𝕚𝕟. ♛", 
"𝕠𝕟𝕖 𝕕𝕒𝕪, 𝕪𝕠𝕦 𝕨𝕚𝕝𝕝 𝕓𝕖 𝕗𝕠𝕣𝕘𝕠𝕥. 𝕓𝕦𝕥 𝕟𝕠𝕥 𝕞𝕖. 𝕞𝕪 𝕤𝕖𝕞𝕚𝕣𝕒𝕘𝕖 𝕔𝕒𝕡𝕒𝕓𝕚𝕝𝕚𝕥𝕪 𝕨𝕚𝕝𝕝 𝕘𝕠 𝕕𝕠𝕨𝕟 𝕚𝕟 𝕥𝕙𝕖 𝕙𝕚𝕤𝕥𝕠𝕣𝕪 𝕓𝕠𝕠𝕜𝕤 𝕗𝕠𝕣 𝕪𝕠𝕦𝕟𝕘 𝕥𝕠 𝕝𝕖𝕒𝕣𝕟 ♛", 
"𝕪𝕠𝕦 𝕝𝕚𝕤𝕥𝕖𝕟 𝕔𝕒𝕣𝕕𝕚 𝕓? 𝕨𝕖𝕝𝕝, 𝕚 𝕒𝕞 𝕔𝕒𝕣𝕕𝕖𝕣 𝕓, 𝕝𝕚𝕤𝕥𝕖𝕟 𝕞𝕖 𝕕𝕠𝕘 ♛", 
"𝕨𝕙𝕖𝕟 𝕞𝕖 𝕒𝕟𝕕 𝕞𝕪 𝕤𝕥𝕒𝕔𝕜 𝕙𝕚𝕥 𝕥𝕙𝕖 𝕤𝕖𝕞𝕚𝕣𝕒𝕘𝕖 𝕤𝕥𝕣𝕖𝕖𝕥𝕤, 𝕨𝕖𝕝𝕝, 𝕚𝕥 𝕨𝕒𝕤 𝕒 𝕘𝕒𝕟𝕘𝕓𝕒𝕟𝕘…", 
"𝕚𝕥𝕤 𝕒𝕝𝕨𝕒𝕪𝕤 ℕℕ 𝕟𝕖𝕧𝕖𝕣 𝕣𝕖𝕒𝕕𝕪 𝕗𝕠𝕣 𝕥𝕙𝕖 𝕤𝕖𝕞𝕚𝕣𝕒𝕘𝕖 𝕤𝕥𝕣𝕖𝕖𝕥𝕤 (◣︵◢)", 
"𝕄𝕪 𝕙𝕒𝕧𝕖 𝕔𝕙𝕖𝕒𝕥 𝕚𝕥𝕤 𝕟𝕠𝕧𝕠", 
"𝕟𝕠 𝕜𝕚𝕥𝕥𝕪 𝕝𝕦𝕒 𝕟𝕠 𝕥𝕒𝕝𝕜𝕚𝕟𝕘 (◣◢)", 
"𝕪𝕠𝕦 𝕡𝕒𝕪 𝕤𝕦𝕓 𝕗𝕠𝕣 𝟚𝟝$? 𝕞𝕪 𝕟𝕚𝕩𝕨𝕒𝕣𝕖 𝕔𝕠𝕤𝕥 𝟛$ 𝕒𝕟𝕕 𝕚 𝕠𝕣𝕕𝕖𝕣 𝟛 𝕡𝕚𝕫𝕫𝕒 𝕨𝕙𝕖𝕟 𝕚𝕞 𝕕𝕖𝕤𝕥𝕣𝕠𝕪 𝕪𝕠𝕦 𝕚𝕟 𝕞𝕞 (◣◢)", 
"𝟛 𝕕𝕒𝕪𝕤 𝕒𝕟𝕕 𝕟𝕠 𝕟𝕚𝕩𝕨𝕒𝕣𝕖 𝕔𝕗𝕘 𝕚𝕞 𝕥𝕙𝕚𝕟𝕜 𝕚𝕤 𝕪𝕠𝕦 𝕤𝕥𝕦𝕡𝕚𝕕?♛", 
"𝕚𝕗 𝕪𝕠𝕦 𝕘𝕣𝕖𝕨 𝕦𝕡 𝕚𝕟 𝕙𝕖𝕝𝕝, 𝕥𝕙𝕖𝕟 𝕠𝕗𝕔 𝕪𝕠𝕦 𝕒𝕣𝕖 𝕘𝕠𝕚𝕟𝕘 𝕥𝕠 𝕤𝕚𝕟 (◣◢)", 
"𝕨𝕙𝕖𝕟 𝕕𝕠𝕘𝕤 𝕕𝕠𝕟𝕥 𝕨𝕒𝕟𝕥 𝕙𝕖𝕒𝕕 𝕒𝕚𝕞𝕤 𝕠𝕟𝕝𝕪 𝕕𝕠 𝕓𝕠𝕕𝕪 𝕒𝕚𝕞𝕤 𝕟𝕠𝕥𝕙𝕚𝕟𝕘 𝕗𝕠𝕣 𝕥𝕖𝕒𝕞 𝕚𝕟 𝟝𝕧𝟝 𝕠𝕟𝕝𝕪 𝕘𝕠 𝕗𝕠𝕣 𝕓𝕒𝕚𝕞𝕤", 
"𝕞𝕒𝕪 𝕘𝕠𝕕 𝕗𝕠𝕣𝕘𝕚𝕧𝕖 𝕪𝕠𝕦 𝕓𝕦𝕥 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕨𝕠𝕟𝕥", 
"𝕦 𝕘𝕦𝕪𝕤 𝕞𝕒𝕜𝕖 𝕗𝕦𝕟 𝕨𝕙𝕚𝕝𝕖 𝕚 𝕞𝕒𝕜𝕖 𝕨𝕚𝕟𝕤 ♚", "THE demon inside of me is 𝙛𝙧𝙚𝙚𝙨𝙩𝙖𝙣𝙙𝙞𝙣𝙜", "Бесплатная голда и дешёвые аккаунты в стандофф? Тебе сюда! Чек описание тг: @keybinding", "Бесплатная голда и дешёвые аккаунты в стандофф? Тебе сюда! —————————> vk.com/vampire",
"最好的vk.com/vampire 中国的女孩", "ıllıllı 𝐒𝐇𝐀𝐌𝐀𝐍 - Я РУССКИЙ ıllıllı", "ищи сайт vk. com/fruit и Малышки из школы иwи у нас на сайте в названии канала sch", "Не позволю себе умерать бедным. 𝑪𝒚𝒂 2023 𝒅𝒐𝒈𝒔", "☞𝐘𝐞𝐧𝐬𝐝𝐞𝐲 𝐀𝐝𝐝𝐚𝐦𝐬☜ *твой_е6ырь*",
"─═ڿڰۣڿ☻ڿڰۣڿ═─͟х͟а͟б͟и͟п͟ ͟м͟а͟ц͟у͟к͟е͟в͟и͟ч͟ ꧂", "▄︻デ══━一 𝒅𝒂𝒓𝒌 𝒃𝒓𝒆𝒍𝒆𝒂𝒏𝒕 𝒌𝒐𝒓𝒔𝒆𝒔", "(っ◔◡◔)っ ♥ вижу фаната код10 -> хей броу скок см челочка❓ ♥", "ıllıllı 𝐂𝐀𝐏𝐈𝐓𝐀𝐋 𝐁𝐑𝐀 ஜ۩۞۩ஜ","ıllıllı ▄︻デ𝐂𝐀𝐏𝐈𝐓𝐀𝐋 𝐁𝐑𝐀══━一 ஜ۩۞۩ஜ", "наш publik+14 adminka-30грн наш сайт - http://vk.com/try2hard кто захочит капить адмику обращайтесь - https://vk.com/vampire ",
"█║►АХУЕННАЯ стрельба.", ".::НоВоСиБиРсК::.", "¸¸♬·¯·♩ ▄︻デ𝐑𝐀𝐅 𝐂𝐀𝐌𝐎𝐑𝐀══━一 ♫♪♩·.¸¸.·", "★·.·´¯`·.·★ 🅐🅚 🅐🅤🅢🅢🅔🅡🅚🅞🅝🅣🅡🅞🅛🅛🅔  ☆☆╮","Комбинированный маникюр с покрытием - 500 рублей. Телеграмм для связи t.me/keybinding", "Продаются щенки самоедкой лайки, рождённые 03.12.2022. Все вопросы по содержанию, уходу в личные сообщения! -> vk.com/vampire",
"не с кем пообщаться, в жизни нᴇт дᴘʏзᴇй? пиши - vk.com/vampire // всегда рада тебе ^_^", "—нᴇ ҕᴇдᴀ,ᴇсли нᴇт дᴘʏзᴇй, ҕᴇдᴀ,ᴇсли они фᴀльшивыᴇ и пᴘодᴀжныᴇ🫀  (C) vk.com/vampire", "главний админ pro.JOKER **DEN(vk.com/try2hard)*","⚡vk.com/vampire наглядно объяснил о важности angelwings в HvH",
"Tиктокершу заставили снять это, видео успели сохранить... Выложили по ссылке в комментах -> vk.com/vampire", "ｔ．ｍｅ／ｋｅｙｂｉｎｄｉｎｇ", "(っ◔◡◔)っ ♥ t.me/keybinding ♥", "【﻿ｔ．ｍｅ／ｋｅｙｂｉｎｄｉｎｇ】", "˜”*°•.˜”*°• t.me/keybinding •°*”˜.•°*”˜", "ＭＡＶＥＲＩＣＫ ｔｏｕｒｎａｍｅｎｔ ｈｉｇｈｌｉｇｈｔｓ ｆｔ ｇａｍｅｓｅｎｓｅ．ｐｕｂ ／ ｓｋｅｅｔ．ｃｃ",
"χợ੫℮ᗯѣ ∂℮τсķợ℮ ʙ ᥰ᧐ᥙᥴκu -> vk.com/try2hard", "χợ੫℮ᗯѣ ∂℮τсķợ℮ ʙ ᥰ᧐ᥙᥴκu -> vk.com/vampire", "по поводу настроек на кряк - vk.com/try2hard", "не с кем пообщаться, в жизни нᴇт дᴘʏзᴇй? пиши - vk.com/try2hard // всегда рада тебе ^_^","vk.com/vampire <- напиши ему привет",
"—Если ничита◣_◢ рядом —То враги падают градом 🧢", "Лучшие никсвар гифты -> vk.com/vampire","Даня Футин 23:30 я так хапнул пиздато","●▬▬▬▬▬▬▬▬▬▬▬▬ஜ۩۞۩ஜ▬▬▬▬▬▬▬▬▬▬▬▬● ░░░░░░░░░░░░░░ДОБРО ПОЖАЛОВАТЬ ░░░░░░░░░░░░░ ●▬▬▬▬▬▬▬▬▬▬▬▬ஜ۩۞۩ஜ▬▬▬▬▬▬▬▬▬▬▬▬●",
"✞я убью тебя и всех твоих родных (◣_◢)",
"STAY BLUHGANG $",
"st1vaha погиб на украине, он служил в ЧВК «Вагнер», теперь это призрак киева [◣_◢]",
"Do You Know Who is it? *rayzen,sanchezj,ptemt*",
"𝐈 𝐀𝐦 𝐋𝐞𝐠𝐞𝐧𝐝",
"Мировая личность и отбросы в фильме - Angelwings.",
"Я официально запретил *j* в нике SANCHEZ",
"OGkaneki♕ all mute 乡sad乡",
"χợ੫℮ᗯѣ ∂℮τсķợ℮ ʙ ᥰ᧐ᥙᥴκu -> vk.com/try2hard",
"１６３ ＦＮＡＹ ＯＮ ＭＹ ＮＥＣＫ",
"aBoJl_MeHeg}I{ep",
"𝔂𝓸𝓾 𝓭𝓸𝓷𝓽 𝓷𝓮𝓮𝓭 𝓯𝓻𝓲𝓮𝓷𝓭𝓼 𝔀𝓱𝓮𝓷 𝔂𝓸𝓾 𝓱𝓪𝓿𝓮 𝓷𝓸𝓿𝓸𝓵𝓲𝓷𝓮𝓱𝓸𝓸𝓴",
"M3M3C-3HCE +2 accepted only RICH MAINS",
"пророк мухаммад саллаллаху алейхи вассалам",
"♛ ｅ ｍ ｏ ｄ ｒ ａ ｉ ｎ ｓ ♛",
"6eWeHыЙ_KaHrAJl",
"fipp трогал меня ТАМ.... Мне было 13 и я очень испугался 😢",
"fipp трогал меня ТАМ... мне было 12 и он меня катал на Nissaki Almera",
"𝓐𝓛𝓗𝓐𝓜𝓓𝓤𝓛𝓘𝓛𝓛𝓐𝓗 𝓘𝓝𝓢𝓗𝓐𝓛𝓛𝓐𝓗",
"Тот самый бот, который раздевает девочек - vk.com/try2hard",
"школьный повор педофил (◣◢)",
"сегодня выпил бутылочку ягуара и ♥♥♥♥♥♥♥♥♥♥♥♥ ♥♥♥♥♥♥♥♥♥♥асов ёпраесете",
"♚ ＴＯＲＥＴＴＯＧＡＮＧ ♚ ",
"𝕠𝕨𝕟𝕖𝕕 𝕓𝕪 𝕣𝕦𝕤𝕤𝕚𝕒𝕟 𝕜𝕚𝕟𝕘𝕤 $",
"SANCHEZj,SHIBA,RIGZ vs storry,Razen,kitty,wavvy godless stack owned",
"ｒｉｃｈ ｍｙ ｍａｉｎ", 
"𝒍𝒂𝒎𝒃𝒐𝒓𝒈𝒊𝒈𝒏𝒊 𝒐𝒘𝒏𝒆𝒓", 
"𝕕𝕠 𝕪𝕠𝕦 𝕙𝕒𝕧𝕖 𝕙𝕒𝕝𝕗 𝕒𝕟𝕘𝕣𝕪 𝕔𝕠𝕟𝕗𝕚𝕘 𝕗𝕠𝕣 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖?", 
"𝙗𝙞𝙜 𝙣𝙖𝙢𝙚𝙧, 𝙞𝙢 𝙩𝙝𝙞𝙣𝙠 𝙮𝙤𝙪 𝙙𝙧𝙤𝙥 𝙮𝙤𝙪𝙧 𝙘𝙧𝙤𝙬𝙣 𝙨𝙤 𝙞𝙢 𝙬𝙚𝙣𝙩 𝙥𝙞𝙩𝙘𝙝𝙙𝙤𝙬𝙣 𝙞𝙣 𝙢𝙢 𝙖𝙣𝙙 𝙥𝙞𝙘𝙠𝙚𝙙 𝙞𝙩 𝙪𝙥, 𝙝𝙚𝙧𝙚 𝙮𝙤𝙪 𝙜𝙤 𝙠𝙞𝙣𝙜 ♛","𝕚𝕕𝕚𝕠𝕥 𝕒𝕝𝕨𝕒𝕪𝕤 𝕒𝕤𝕜 𝕞𝕖, 𝕦𝕚𝕕? 𝕒𝕟𝕕 𝕚𝕞 𝕕𝕠𝕟𝕥 𝕒𝕟𝕤𝕨𝕖𝕣, 𝕚 𝕝𝕖𝕥 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖𝕓𝕠𝕒𝕣𝕕 𝕥𝕒𝕝𝕜♛ (◣◢)","пастирал тебя хуем", "с4астлива сосешь мне", "  CFG by KuCJloTa  ", "Создатель LUA angelwings", "C͜͡n͜͡u͜͡ H͜͡a͜͡x͜͡y͜͡u͜͡", "с⃞п⃞и⃞ ш⃞л⃞ю⃞х⃞а⃞",
"✧:･ﾟ✧ 𝐅𝐔𝐂𝐊 𝐘𝐎𝐔 ✧:･ﾟ✧","манипулирую хуем над табой", "хуем па ребрам тебе", "4ота сасируеш потна", "1 спи долбаеб", "в ебыч хуйсос", "на хуе ща крутишься у мя)", "⛓𝐁𝐋𝐔𝐇𝐆𝐀𝐍𝐆 🖤 𝐕𝐒 𝐠𝐨𝐝𝐥𝐞𝐬𝐬 [𝟓𝐯𝟏𝟗] After this game they no longer believe in God rayzen,onej,vitma owned", "ебучий рекс ты сын шлюхи завали ебало",
"хахах просто легкий пидорас", "☂️Vac Enjoyer (HVH)☂️", "allah headshot", "angelwings Loading… █▒▒▒▒▒▒▒▒▒ 10% ███▒▒▒▒▒▒▒ 30% █████▒▒▒▒▒ 50% ███████▒▒▒ 100%", "на завод иди", "| Welcome to angelwings |", "▄ ▀▄ ▀▄ ▀▄ НА ТАКСИ ТЕБЯ СБИЛ ЕПТА ХАХА", "€6@L TBO|-O ᛖ@Ťѣ √ թΘТ", "▀▄▀▄▀▄▀▄▀▄▀▄", "пончик ебаный я твоей маме колени выбил битой", "глотни коки яки хуйсоска", "спи хуйсоска)", "спи нахуй пидораска", "АХХАХА МАТЬ ЕБАЛ ТВОЮ СЫН ШЛЮХИ", "ахуеnnø мамашу tvøю øbжøpиstyю ебал es ez хихи =D", "sasesh мøй хуй kpуta es ez =D", "old SANCHEZj is back but i never left [1v1] onej ПУСТЬ УМРУТ ТВОИ РОДИТЕЛИ... † OWNED MY DOG", "+rep 🅻 🅴 🅶 🅸 🆃 💥", "ALLAH DİYEN ŞOK POŞETİ | KEYDROP", "ты че пидорас в светлое будущее попрыгал что-ли?", "ХАХАХА ЧЕ ТЫ ТАМ ВРЕДИТЕЛЬ АХАХАХ СПОТИФАЙ ХАХА Х", "СПОТЛАЙТ СПОТЛАЙТ АХАХА СПИНОЙ ПИДОРАСА УБИВАЮ ХАХА", "АХХАХА ПИДОРАС ТЫ ЧЕ ТУПОЙ ТО ТАКОЙ", "пraдaлzхaйу пинaт' тvaййу мaмasху хихи es ez =D", "най чит чел..", "с хуйом маим работайш)", "SANCHEZj [1v1] ptemt Проиграл МАТЬ на 1x1, возможно навсегда. st1vaha,rayzen,vitma Owned..", "This dogs dont have chance against angelwings",
"спи нахуй пидорас ебанный куда пошёл сын шлюхи", "♛ Ｔａｄｚｈ３３ｋ ♛", "SANCHEZJ $ PTEMT BLUHGANG TEAM", "Ｌｉｎｋ ｍａｉｎ ｂｅｆｏｒｅ ｓｐｅａｋｉｎｇ ♛",": Your name - missed shot due to resolver.", "изи", "ммовский хуесос ты для чего на паблик зашел, заблудился чтоли?", "спи нахуй пидораска)", "▼- стрелочка вниз","-𝚛𝚎𝚙 0 𝚒𝚚", "$ angelwings $ LUA", "๑۩۞۩๑√ОТЛЕТАЙ НУБЯРА√๑۩۞۩๑", "ЗНẪЙ СВОЁ ḾḜḈТО НИЧТОЖḜСТВØ", "†ПоКоЙсЯ(ٿ)с(ٿ)Миром†", "я играю с конфигом от pytbylev (◣_◢)",
"₽вȁл гȫρтăнь Ŧвȫей ʍа₮еᎵน", "Аллах бабах чурки", "АХМАТ СИЛА Алла́ху А́кбар ЛЕТИ", "[̲̅Д̲̅о̲̅П̲̅р̲̅ы̲̅Г̲̅а̲̲л̲̅с̲̅я̲̅(ت)̲̅Д̲̅р̲̅У̲̅ж̲̅о̲̅Ч̲̅е̲̅К̲̅]", "я ᴇбᴀᴧ ᴛʙᴏю ʍᴀᴛь [◣_◢]", "𝐢 𝐬𝐦𝐨𝐤𝐞 𝐜𝐡𝐚𝐫𝐨𝐧 𝐚𝐧𝐝 𝐝𝐫𝐢𝐧𝐤 𝐜𝐨𝐥𝐚 𝐝𝐨𝐛𝐫𝐢𝐲", "—Если братишка рядом —То враги падают градом 🧢Z", "отсосал как 𝕥𝕖𝕕𝕪","ℳАℳКУ ЕБАЛ","𝙸<𝟹 𝙾𝙿𝙴𝚁𝙿𝙻𝚄𝙶 ☆","𝐟𝐮𝐤 𝟏𝟎𝟐","-𝒓𝒆𝒑 𝒄𝒉𝒆𝒂𝒕𝒔","CАСЁШ КАК 𝕆ℝ𝔻","𝕏עӥ☾𝕠⊂","Я бы после такого в игру не заходил *fipp,albenix,sheefu,borya,vitma,st1vaha,d4ssh*","AWpKINGNeededSmoke $ 𝐓𝐡𝐞𝐲 𝐰𝐚𝐧𝐭 𝐭𝐨 𝐛𝐞 𝐥𝐢𝐤𝐞 𝐦𝐞 𝐛𝐮𝐭 𝐈 𝐛𝐞𝐥𝐨𝐧𝐠 𝐭𝐨 𝐚 𝐟𝐚𝐦𝐢𝐥𝐲 𝐨𝐟 𝐊𝐈𝐍𝐆𝐒","⋆н⋆а⋆ ⋆к⋆о⋆л⋆е⋆н⋆и⋆","😱 В Башкирии женщина год спала с любовником и заразилась от него ВИЧ","vk.com/tryhard <-— лʏчωии свᴀдᴇҕныи фотоrᴘᴀф","vk.com/VAMPIRE <-— лʏчωии свᴀдᴇҕныи фотоrᴘᴀф","ᙐᗣᏦᑌᕼᎽᙁ ᙅᕼᚿθᙅᑌᏦᗣ","匚ㄖᗪ乇10 卂ㄥ山卂ㄚ丂 ㄖ几","я иrᴘᴀю с 𝔸𝔸ℝℕ𝔼.ℂ𝕃𝕌𝔹, ҕᴇrитᴇ","𝐬𝐥𝐨𝐰𝐞𝐝 + 𝐫𝐞𝐯𝐞𝐫𝐛","₴ⱠØ₩ɆĐ + ⱤɆVɆⱤ฿","丂ㄥㄖ山乇ᗪ + 尺乇ᐯ乇尺乃","(っ◔◡◔)っ ♥ slowed + reverb ♥","˜”°•.˜”°• slowed + reverb •°”˜.•°”˜","ｓｌｏｗｅｄ ＋ ｒｅｖｅｒｂ","”°•.˜vk.com/vampire”°•","♥vk.com/vampire♥","𝕧𝕜.𝕔𝕠𝕞/𝕧𝕒𝕞𝕡𝕚𝕣𝕖","ｖｋ．ｃｏｍ／ｖａｍｐｉｒｅ","ᴠᴋ.ᴄᴏᴍ/ᴠᴀᴍᴘɪʀᴇ","𝚟𝚔.𝚌𝚘𝚖/𝚟𝚊𝚖𝚙𝚒𝚛𝚎","ｖｋ．ｃｏｍ／ｖａｍｐｉｒｅ　リゃド","【﻿ｖｋ．ｃｏｍ／ｖａｍｐｉｒｅ】","▀▄▀▄▀▄   🎀  𝓋𝓀.𝒸☯𝓂/𝓋𝒶𝓂𝓅𝒾𝓇𝑒  🎀   ▄▀▄▀▄▀","𝕒𝕝𝕝 𝕗𝕒𝕞𝕚𝕝𝕪 𝕨𝕚𝕥𝕙 𝕦𝕤𝕖𝕣𝕟𝕒𝕞𝕖𝕤","ａｌｌ ｆａｍｉｌｙ ｗｉｔｈ ｕｓｅｒｎａｍｅｓ","FNAAAAAY В ЧАААТ (◣_◢)"
}

chat_spammer.handle = function(e)
    if not Vars.Misc.chat_spammer:get() then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local victim = client.userid_to_entindex(e.userid)

    if victim == nil or victim == player then
        return
    end

    local attacker = client.userid_to_entindex(e.attacker)

    if attacker ~= player then
        return
    end

    client.exec(('say %s'):format(chat_spammer.phrases[math.random(1, #chat_spammer.phrases)]))
end

conditional_antiaims.states = {
    unknown = -1,
    standing = 2,
    moving = 3,
    slowwalk = 4,
    crouching = 5,
    moving_crouch = 6,
    air = 7,
    air_crouch = 8,
    freestand = 9,
    fakelag = 10,
    on_use = 11
}

conditional_antiaims.conditions = {}
for k, name in pairs(conditional_antiaims.conditions_names) do
    local name_unique = '\aFFFFFF00' .. name .. k
    local itemname_start = 'conditions_' .. name .. '_'

    conditional_antiaims.conditions[k] = {}

    if name ~= 'Shared' then
        conditional_antiaims.conditions[k].switch = group:checkbox('Allow ' .. string.lower(name) .. ' condition')
	end

    conditional_antiaims.conditions[k].pitch = group:combobox('Pitch' .. name_unique, { 'Off', 'Up', 'Down', 'Random' })

	conditional_antiaims.conditions[k].yaw_base = group:combobox('Yaw base' .. name_unique, { 'At targets', 'Local view' })
	conditional_antiaims.conditions[k].left_yaw_offset = group:slider('Yaw base  »  Left side' .. name_unique, -180, 180, 0, 0, '°')
	conditional_antiaims.conditions[k].right_yaw_offset = group:slider('Yaw base  »  Right side' .. name_unique, -180, 180, 0, 0, '°')
	conditional_antiaims.conditions[k].yaw_randomize = group:slider('Yaw base  »  Кandomization' .. name_unique, 0, 100, 0, 0, '%', 1, {[0] = "Off"})

	conditional_antiaims.conditions[k].yaw_modifier = group:combobox('Yaw jitter' .. name_unique, { 'Off', 'Offset', 'Center', 'Random', 'Skitter', 'L&R Center', 'Custom way' })
	conditional_antiaims.conditions[k].yaw_modifier_offset = group:slider('\nbothsides' .. name_unique, -180, 180, 0, 0, '°')
	conditional_antiaims.conditions[k].yaw_modifier_offset979 = group:slider('Yaw jitter  »  Left side' .. name_unique, -180, 180, 0, 0, '°')
	conditional_antiaims.conditions[k].yaw_modifier_offset1337 = group:slider('Yaw jitter  »  Right side' .. name_unique, -180, 180, 0, 0, '°')
	conditional_antiaims.conditions[k].yaw_modifier_offset1 = group:slider('Offset [1]' .. name_unique, -180, 180, 0, 0, '°')
	conditional_antiaims.conditions[k].yaw_modifier_offset2 = group:slider('Offset [2]' .. name_unique, -180, 180, 0, 0, '°')
	conditional_antiaims.conditions[k].yaw_modifier_offset3 = group:slider('Offset [3]' .. name_unique, -180, 180, 0, 0, '°')

	conditional_antiaims.conditions[k].body_yaw = group:combobox('Body yaw' .. name_unique, { 'Off', 'Opposite', 'Jitter', 'Static', 'Advanced' })
	conditional_antiaims.conditions[k].body_yaw_offset = group:slider('\nbyawoffset' .. name_unique, -180, 180, 0, 0, '°')
	conditional_antiaims.conditions[k].delay_ticks = group:slider('\ndelayticks' .. name_unique, 1, 14, 1, 0, 't')
	conditional_antiaims.conditions[k].roll_aa = group:slider('Roll' .. name_unique, -45, 45, 1, 0, '°')

	if name ~= 'Fakelag' then
		conditional_antiaims.conditions[k].lag_options = group:combobox('Force defensive' .. name_unique, {'Default', 'Always on'})
		conditional_antiaims.conditions[k].defensive_aa = group:checkbox('Defensive AA' .. name_unique)
		conditional_antiaims.conditions[k].defensive_pitch = group:combobox('Pitch\ndefensive_pitch' .. name_unique, {'Disabled', 'Up', 'Zero', 'Random', 'Custom'})
		conditional_antiaims.conditions[k].pitch_slider = group:slider('\ncustom_defensive_pitch' .. name_unique, -89, 89, 0, 0, '°')
		conditional_antiaims.conditions[k].defensive_yaw = group:combobox('Yaw\ndefensive_yaw' .. name_unique, {'Disabled', 'Sideways', 'Opposite', 'Random', 'Spin', '3-Way', '5-Way', 'Custom'})
		conditional_antiaims.conditions[k].yaw_slider = group:slider('\ncustom_defensive_yaw' .. name_unique, -180, 180, 0, 0, '°')
	end
end

experimental_defensive111 = group:label(' ')
experimental_defensive = group:checkbox('\aFF0000FF⚠  Experimental defensive')

conditional_antiaims.desync_delta = 0
conditional_antiaims.get_desync_delta = function()
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    conditional_antiaims.desync_delta = math.normalize_yaw(entity.get_prop(player, 'm_flPoseParameter', 11) * 120 - 60) / 2
end

conditional_antiaims.current_side = false
conditional_antiaims.get_desync_side = function()
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    if globals.chokedcommands() ~= 0 then 
        return
    end

    local body_yaw = entity.get_prop(player, 'm_flPoseParameter', 11) * 120 - 60

    conditional_antiaims.current_side = body_yaw > 0
end

conditional_antiaims.randomization = 0
conditional_antiaims.current_choke = 0
conditional_antiaims.choked_ticks_prev = 0
conditional_antiaims.get_current_choke = function(cmd)
    local player = entity.get_local_player()

    if player == nil then
        return
    end

	local choked_ticks = cmd.chokedcommands
	if conditional_antiaims.choked_ticks_prev >= choked_ticks or choked_ticks == 0 then
		conditional_antiaims.current_choke = conditional_antiaims.choked_ticks_prev
	end
	
	conditional_antiaims.choked_ticks_prev = choked_ticks
end

conditional_antiaims.calc_randomization = function (new_config)
	local left, right = new_config.left_yaw_offset, new_config.right_yaw_offset
	local factor = new_config.yaw_randomize * 0.01

	return math.random(left * factor, right * factor)
end

conditional_antiaims.yaw_randomize = function(new_config)
    new_config.yaw_offset = (new_config.yaw_offset or 0) + math.random(-new_config.yaw_randomize, new_config.yaw_randomize)
end

conditional_antiaims.swap = false
conditional_antiaims.set_yaw_right_left = safecall('set_yaw_right_left', true, function(new_config)
	if (conditional_antiaims.manual_dir == -90 or conditional_antiaims.manual_dir == 90) then
		return
	end

	local weapon = entity.get_player_weapon(entity.get_local_player())
    local knife = weapon ~= nil and entity.get_classname(weapon) == 'CKnife'
    local zeus = weapon ~= nil and entity.get_classname(weapon) == 'CWeaponTaser' 
	
    local safe_knife = (Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.settings:get('Knife')) and knife
    local safe_zeus = (Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.settings:get('Zeus')) and zeus
	local required_states = (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
	local safe_active = conditional_antiaims.safe_active or ((safe_knife or safe_zeus) and required_states)

    if new_config.body_yaw ~= 'Advanced' and not safe_active then
		if conditional_antiaims.chokedcommands == 0 then
        	new_config.yaw_offset = (conditional_antiaims.current_side and new_config.left_yaw_offset or new_config.right_yaw_offset)
		end
    end
end)

conditional_antiaims.get_distance = function() 
    local result = math.huge;
    local heightDifference = 0;
    local localplayer = entity.get_local_player();
    local entities = entity.get_players(true);

    for i = 1, #entities do
      local ent = entities[i];
	  local ent_origin = { entity.get_origin(ent) }
	  local lp_origin = { entity.get_origin(localplayer) }
      if ent ~= localplayer and entity.is_alive(ent) then
        local distance = (vector(ent_origin[1], ent_origin[2], ent_origin[3]) - vector(lp_origin[1], lp_origin[2], lp_origin[3])):length2d();
        if distance < result then 
            result = distance; 
            heightDifference = ent_origin[3] - lp_origin[3];
        end
      end
    end
  
    return math.floor(result/10), math.floor(heightDifference);
end

conditional_antiaims.new_meta_defensive = safecall('new_meta_defensive', true, function(new_config, cmd)
    local plocal = entity.get_local_player()
    if (plocal == nil) or (not entity.is_alive(plocal)) then
        return end

    local is_grenade = entity.get_classname(entity.get_player_weapon(plocal)):find('Grenade') or false
    local distance_to_enemy = {conditional_antiaims.get_distance()}
    local is_manuals = (conditional_antiaims.manual_dir == -90 or conditional_antiaims.manual_dir == 90)
    local weapon = entity.get_player_weapon(plocal)
    local safe_knife = ((Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.settings:get('Knife')) and (weapon ~= nil and entity.get_classname(weapon) == 'CKnife')) and (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
    local safe_zeus = ((Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.settings:get('Zeus')) and (weapon ~= nil and entity.get_classname(weapon) == 'CWeaponTaser')) and (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
    local is_safe = ((Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.defensive_aa:get() and (not is_manuals)) and (((Vars.AA.safe_functions.head_settings:get('High Distance') and distance_to_enemy[1] > 119) and (conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)) or ((Vars.AA.safe_functions.head_settings:get('Height') and distance_to_enemy[2] < -50) and (conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.moving_crouch or conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag))))
	local safe_conds = (((Vars.AA.safe_functions.head_settings:get('High Distance') and distance_to_enemy[1] > 119) and (conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)) or ((Vars.AA.safe_functions.head_settings:get('Height') and distance_to_enemy[2] < -50) and (conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.moving_crouch or conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)))
	
	if is_manuals and Vars.AA.manuals.lag_options:get() == 'Always on' then
		cmd.force_defensive = true
	elseif (is_safe or safe_knife or safe_zeus) and Vars.AA.safe_functions.lag_options:get() == 'Always on' then
		cmd.force_defensive = true
	elseif safe_conds and not (Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.defensive_aa:get()) then
		cmd.force_defensive = false
	else
		cmd.force_defensive = new_config.lag_options == 'Always on'
	end
end)


conditional_antiaims.delay_latest_yaw = 0
conditional_antiaims.delay_switch = safecall('delay_switch', true, function(new_config)
   	if (conditional_antiaims.manual_dir == -90 or conditional_antiaims.manual_dir == 90) then 
        return 
    end
	if globals.tickcount() % (new_config.delay_ticks * 2) == 0 then
		conditional_antiaims.swap = not conditional_antiaims.swap
	end
	
    if new_config.body_yaw == 'Advanced' then
        new_config.body_yaw = 'Static'
		if conditional_antiaims.chokedcommands == 0 then
        	conditional_antiaims.delay_latest_yaw = (conditional_antiaims.swap and new_config.left_yaw_offset or new_config.right_yaw_offset)
        	new_config.body_yaw_offset = conditional_antiaims.swap and -1 or 1
		end
		new_config.yaw_offset = conditional_antiaims.delay_latest_yaw
    end
end)

conditional_antiaims.meta_latest_yaw = 0
conditional_antiaims.new_meta_antiaims = safecall('new_meta_antiaims', true, function(new_config)
	
    local yaw = conditional_antiaims.current_side and new_config.left_yaw_offset or new_config.right_yaw_offset
    local value = yaw

    if new_config.yaw_modifier == 'L&R Center' then
        new_config.yaw_modifier = 'Center'
        new_config.yaw_modifier_offset = conditional_antiaims.current_side and new_config.yaw_modifier_offset1337 or new_config.yaw_modifier_offset979
        new_config.yaw_offset = conditional_antiaims.current_side and new_config.left_yaw_offset or new_config.right_yaw_offset
    elseif new_config.yaw_modifier == 'Custom way' then
        if globals.tickcount() % 3 == 0 then
            value = new_config.yaw_modifier_offset1
        elseif globals.tickcount() % 3 == 1 then
            value = new_config.yaw_modifier_offset2
        elseif globals.tickcount() % 3 == 2 then
            value = new_config.yaw_modifier_offset3
        end
        new_config.yaw_modifier_offset = 0
        new_config.yaw_modifier = 'Center'
    end
    
    if new_config.advanced_body_yaw ~= 'Advanced' then
		if conditional_antiaims.chokedcommands == 0 then
			conditional_antiaims.meta_latest_yaw = value
		end
	else
		conditional_antiaims.meta_latest_yaw = 0
    end
end)

conditional_antiaims.get_active_idx = function(idx)
    local name = conditional_antiaims.conditions_names[idx]
    if name ~= nil then
        if idx ~= 1 and conditional_antiaims.conditions[idx].switch:get() then
            return idx
        end
    end

    return 1
end

conditional_antiaims.get_cond_values = function(idx)
    local cond_tbl = conditional_antiaims.conditions_names[idx]
    if cond_tbl == nil then
        return
    end

    local new_config = {}

    for k, v in pairs(conditional_antiaims.conditions[idx]) do
        new_config[k] = v:get()
    end

    return new_config
end

conditional_antiaims.set_ui = safecall('set_ui', true, function(new_config)
    for k, v in pairs(new_config) do
        if gamesense_refs._vars[k] ~= nil then
            gamesense_refs.override(k, v)
        end
    end
end)

conditional_antiaims.defensive1 = 0
conditional_antiaims.defensive_handle1 = function(cmd)
	local lp = entity.get_local_player()

    if lp == nil or not entity.is_alive(lp) then
        return
    end

    local Entity = native_GetClientEntity(lp)
    local m_flOldSimulationTime = ffi.cast('float*', ffi.cast('uintptr_t', Entity) + 0x26C)[0]
    local m_flSimulationTime = entity.get_prop(lp, 'm_flSimulationTime')

    local delta = m_flOldSimulationTime - m_flSimulationTime;

    if delta > 0 then
		conditional_antiaims.defensive1 = globals.tickcount() + toticks(delta - client.latency()) - 5;
        return;
    end
end

conditional_antiaims.defensive = 0
conditional_antiaims.defensive_handle = function(cmd)
	local lp = entity.get_local_player()

    if lp == nil or not entity.is_alive(lp) then
        return
    end

    local Entity = native_GetClientEntity(lp)
    local m_flOldSimulationTime = ffi.cast('float*', ffi.cast('uintptr_t', Entity) + 0x26C)[0]
    local m_flSimulationTime = entity.get_prop(lp, 'm_flSimulationTime')

    local delta = m_flOldSimulationTime - m_flSimulationTime;

    if delta > 0 then
		conditional_antiaims.defensive = globals.tickcount() + toticks(delta - client.latency());
		conditional_antiaims.defensive1 = globals.tickcount() + toticks(delta - client.latency()) - 5;
        return;
    end
end

conditional_antiaims.manual_cur = nil
conditional_antiaims.manual_dir = 0

conditional_antiaims.manual_keys = {
	{ "left", yaw = -90, item = Vars.AA.manuals.left.hotkey },
	{ "right", yaw = 90, item = Vars.AA.manuals.right.hotkey },
	{ "reset", yaw = nil, item = Vars.AA.manuals.reset.hotkey },
}

for i, v in ipairs(conditional_antiaims.manual_keys) do
	local active, mode, key = v.item:get()
	v.item:set("Toggle", key)
end

conditional_antiaims.get_manuals = function()
	if not (Vars.AA.enable:get() and Vars.AA.manuals.enable:get()) then return end

	for i, v in ipairs(conditional_antiaims.manual_keys) do
		local active, mode = v.item:get()

		if v.active == nil then v.active = active end
		if v.active == active then goto done end

		v.active = active

		if v.yaw == nil then conditional_antiaims.manual_cur = nil end

		if mode == 1 then conditional_antiaims.manual_cur = active and i or nil goto done
		elseif mode == 2 then conditional_antiaims.manual_cur = conditional_antiaims.manual_cur ~= i and i or nil goto done end

		::done::
	end

	conditional_antiaims.manual_dir = conditional_antiaims.manual_cur ~= nil and conditional_antiaims.manual_keys[conditional_antiaims.manual_cur].yaw or 0
end

conditional_antiaims.set_yaw_base = function(new_config)

    if not Vars.AA.enable:get() then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local manuals_over_fs = Vars.AA.manuals.manuals_over_fs:get()
    local is_manuals = (conditional_antiaims.manual_dir == -90 or conditional_antiaims.manual_dir == 90)

	local defensive = not (globals.tickcount() > (experimental_defensive:get() and conditional_antiaims.defensive1 or conditional_antiaims.defensive) and conditional_antiaims.states.fakelag)
    local weapon = entity.get_player_weapon(player)

    local knife = weapon ~= nil and entity.get_classname(weapon) == 'CKnife'
    local zeus = weapon ~= nil and entity.get_classname(weapon) == 'CWeaponTaser' 

    local safe_knife = (Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.settings:get('Knife')) and knife
    local safe_zeus = (Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.settings:get('Zeus')) and zeus
    local safe_head = (Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.settings:get('Head'))
    local distance_to_enemy = {conditional_antiaims.get_distance()}
    local is_predefined = conditional_antiaims.manual_dir

	if not antiaim_on_use.enabled and is_manuals then
        if Vars.AA.manuals.enable:get() then
            new_config.yaw_modifier = 'Off'
			new_config.body_yaw = 'Static'
			new_config.body_yaw_offset = Vars.AA.manuals.inverter:get() and 1 or -1
        end

        if is_predefined then
			new_config.yaw_base = 'Local view'
        	new_config.yaw_offset = (((Vars.AA.manuals.enable:get() and not (Vars.AA.manuals.defensive_aa:get() and defensive)) and is_predefined) or new_config.yaw_offset)
        end
	elseif (safe_knife or safe_zeus) and (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag) then
		conditional_antiaims.safe_active = true
		-- new_config.yaw_offset = 0
		-- new_config.yaw_modifier = 'Off'
		-- new_config.body_yaw = 'Off'
		-- new_config.body_yaw_offset = 0
    elseif (safe_head and not is_manuals) then
        if conditional_antiaims.safe_active then
			new_config.yaw_modifier = 'Off'
			-- new_config.yaw_offset = 0
			new_config.body_yaw = 'Static'
			new_config.body_yaw_offset = 0
        end
    end

	new_config.roll_aa = new_config.roll_aa
    new_config.freestanding = not (manuals_over_fs and (is_manuals)) and gamesense_refs.freestanding:get()
end

conditional_antiaims.player_state = 1
conditional_antiaims.update_player_state = function(cmd)

    local localplayer = entity.get_local_player()

    if localplayer == nil then
        return
    end

    local flags = entity.get_prop(localplayer, 'm_fFlags')
	local m_vecVelocity = { entity.get_prop(localplayer, 'm_vecVelocity') }
    local is_crouching = bit.band(flags, bit.lshift(1, 1)) ~= 0
    local on_ground = bit.band(flags, bit.lshift(1, 0)) ~= 0
    local is_not_moving = math.sqrt(m_vecVelocity[1] ^ 2 + m_vecVelocity[2] ^ 2) < 2
    local is_slowwalk = ui.get(gamesense_refs.slow[1]) and ui.get(gamesense_refs.slow[2])
    local is_jumping = cmd.in_jump ~= 0

	model_breaker.in_air = is_jumping or not on_ground

    if antiaim_on_use.enabled then
        conditional_antiaims.player_state = conditional_antiaims.states.on_use
        return
    end

    if (ui.get(gamesense_aa.freestanding[1]) and ui.get(gamesense_aa.freestanding[2])) and not antiaim_on_use.enabled then
        conditional_antiaims.player_state = conditional_antiaims.states.freestand
        return
    end

    if not (ui.get(gamesense_refs.dt[1]) and ui.get(gamesense_refs.dt[2])) and not (ui.get(gamesense_refs.os[1]) and ui.get(gamesense_refs.os[2]))
	and conditional_antiaims.conditions[conditional_antiaims.states.fakelag].switch.value then
        conditional_antiaims.player_state = conditional_antiaims.states.fakelag
        return
    end

    if is_crouching and (is_jumping or not on_ground) then
        conditional_antiaims.player_state = conditional_antiaims.states.air_crouch
        return
    end

    if is_jumping or not on_ground then
        conditional_antiaims.player_state = conditional_antiaims.states.air
        return
    end

    if is_slowwalk then
        conditional_antiaims.player_state = conditional_antiaims.states.slowwalk
        return
    end

    if not is_crouching and is_not_moving then
        conditional_antiaims.player_state = conditional_antiaims.states.standing
        return
    end

    if is_crouching and is_not_moving then
        conditional_antiaims.player_state = conditional_antiaims.states.crouching
        return
    end

    if is_crouching and not is_not_moving then
        conditional_antiaims.player_state = conditional_antiaims.states.moving_crouch
        return
    end

    if not is_crouching and not is_not_moving and not is_slowwalk then
        conditional_antiaims.player_state = conditional_antiaims.states.moving
        return
    end

    conditional_antiaims.player_state = conditional_antiaims.states.unknown
end

aero_lag_exp.get_dt_charge = function(ent)
    local m_nTickBase = entity.get_prop(ent, "m_nTickBase")
    local shift = math.floor(m_nTickBase - globals.tickcount() - toticks(client.latency()) * 0.4)
    local wanted = -15 + (ui.get(gamesense_refs.dt_fakelag) - 1) + 5

    return math.min(1, math.max(0, shift / wanted)) == 1
end

conditional_antiaims.handle = function(cmd)
	conditional_antiaims.chokedcommands = cmd.chokedcommands
    conditional_antiaims.update_player_state(cmd)
	conditional_antiaims.get_current_choke(cmd)
	conditional_antiaims.get_desync_delta()
    conditional_antiaims.get_desync_side()

	local backstab_allow = false
	local idx = conditional_antiaims.player_state
	local distance_to_enemy = {conditional_antiaims.get_distance()}   
    local current_condition = conditional_antiaims.get_active_idx(idx)
   	local new_config = conditional_antiaims.get_cond_values(current_condition)
	local defensive = not (globals.tickcount() > (experimental_defensive:get() and conditional_antiaims.defensive1 or conditional_antiaims.defensive) and conditional_antiaims.states.fakelag)
	local is_manuals = (conditional_antiaims.manual_dir == -90 or conditional_antiaims.manual_dir == 90)

	new_config.yaw_offset = conditional_antiaims.meta_latest_yaw
	
	local weapon = entity.get_player_weapon(entity.get_local_player())
    local knife = weapon ~= nil and entity.get_classname(weapon) == 'CKnife'
    local zeus = weapon ~= nil and entity.get_classname(weapon) == 'CWeaponTaser' 
	
    local safe_knife = (Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.settings:get('Knife')) and knife
    local safe_zeus = (Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.settings:get('Zeus')) and zeus
    local safe_head = (Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.settings:get('Head'))

	conditional_antiaims.safe_active = (
		(Vars.AA.safe_functions.enable:get() and (not is_manuals)) and 
		Vars.AA.safe_functions.settings:get("Head") and
		(
			(
				(Vars.AA.safe_functions.head_settings:get('High Distance') and distance_to_enemy[1] > 119) and 
				(conditional_antiaims.player_state == conditional_antiaims.states.crouching or 
				conditional_antiaims.player_state == conditional_antiaims.states.standing or 
				conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
			) 
			or 
			(
				(Vars.AA.safe_functions.head_settings:get('Height') and distance_to_enemy[2] < -50) and 
				(conditional_antiaims.player_state == conditional_antiaims.states.crouching or 
				conditional_antiaims.player_state == conditional_antiaims.states.moving_crouch or 
				conditional_antiaims.player_state == conditional_antiaims.states.standing or 
				conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or 
				conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
			)
		)
	)
	
	conditional_antiaims.new_meta_antiaims(new_config)
	conditional_antiaims.new_meta_defensive(new_config, cmd)
	conditional_antiaims.set_yaw_right_left(new_config)
	conditional_antiaims.get_manuals()

	conditional_antiaims.randomization = conditional_antiaims.calc_randomization(new_config)

	gamesense_refs.freestanding.hotkey:set('Always on')
	gamesense_refs.override('freestanding', (Vars.AA.freestanding:get() and Vars.AA.freestanding.hotkey:get()) and not antiaim_on_use.enabled)
	
	if Vars.AA.edge_yaw then
		gamesense_refs.override('edge_yaw', Vars.AA.edge_yaw:get() and Vars.AA.edge_yaw.hotkey:get())
	end

	local pitch_tbl = {
        ['Disabled'] = 89,
        ['Up'] = -89,
        ['Zero'] = 0,
        ['Random'] = math.random(-89, 89),
        ['Custom'] = new_config.pitch_slider
    }
	
	local yaw_tbl = {
        ['Disabled'] = 0,
        ['Opposite'] = is_manuals and conditional_antiaims.manual_dir*-1 or client.random_int(160, 180),
        ['Sideways'] = globals.tickcount() % 3 == 0 and client.random_int(-100, -90) or globals.tickcount() % 3 == 1 and 180 or globals.tickcount() % 3 == 2 and client.random_int(90, 100) or 0,
        ['Random'] = math.random(-180, 180),
        ['Spin'] = math.normalize_yaw(globals.curtime() * 1000),
        ['3-Way'] = globals.tickcount() % 3 == 0 and client.random_int(-110, -90) or globals.tickcount() % 3 == 1 and client.random_int(90, 120) or globals.tickcount() % 3 == 2 and client.random_int(-180, -150) or 0,
        ['5-Way'] = globals.tickcount() % 5 == 0 and client.random_int(-90, -75) or globals.tickcount() % 5 == 1 and client.random_int(-45, -30) or globals.tickcount() % 5 == 2 and client.random_int(-180, -160) or globals.tickcount() % 5 == 3 and client.random_int(45, 60) or globals.tickcount() % 5 == 3 and client.random_int(90, 110) or 0,
        ['Custom'] = new_config.yaw_slider
	}


	-- 
	new_config.yaw_offset1 = '180'
	conditional_antiaims.delay_switch(new_config)
	conditional_antiaims.set_yaw_base(new_config)

	if not is_manuals then
		if conditional_antiaims.safe_active then
			new_config.yaw_offset = 0
			new_config.yaw_modifier = 'Off'
			new_config.body_yaw = 'Off'
			new_config.body_yaw_offset = 0
		else
			new_config.yaw_offset = new_config.yaw_offset + conditional_antiaims.randomization
		end

		if Vars.AA.avoid_backstab ~= nil and (Vars.AA.avoid_backstab:get()) then
			local players = entity.get_players(true)
			for i=1, #players do
				local x, y, z = entity.get_prop(players[i], 'm_vecOrigin')
				local origin = vector(entity.get_prop(entity.get_local_player(), 'm_vecOrigin'))
				local distance = math.sqrt((x - origin.x)^2 + (y - origin.y)^2 + (z - origin.z)^2) 
				local weapon = entity.get_player_weapon(players[i])
				if entity.get_classname(weapon) == 'CKnife' and distance <= 200 then
					backstab_allow = true
					new_config.yaw_offset = 180
					new_config.pitch = 'Off'
				end
			end
		end

		if defensive then
			if new_config.defensive_aa and not (is_manuals or (conditional_antiaims.safe_active) or safe_knife or safe_zeus or backstab_allow) then
				new_config.pitch = 'Custom'
				new_config.pitch_value = pitch_tbl[new_config.defensive_pitch]
				new_config.yaw_offset = yaw_tbl[new_config.defensive_yaw]
			elseif (Vars.AA.safe_functions.defensive_aa:get() and (safe_head) and not is_manuals) then
				if ((Vars.AA.safe_functions.enable:get() and Vars.AA.safe_functions.defensive_aa:get() and (not is_manuals)) and (((Vars.AA.safe_functions.head_settings:get('High Distance') and distance_to_enemy[1] > 119) and (conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)) or ((Vars.AA.safe_functions.head_settings:get('Height') and distance_to_enemy[2] < -50) and (conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.moving_crouch or conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)))) then
					new_config.pitch = 'Custom'
					new_config.pitch_value = pitch_tbl[Vars.AA.safe_functions.defensive_pitch:get()]
					new_config.yaw_offset = yaw_tbl[Vars.AA.safe_functions.defensive_yaw:get()]
				elseif (safe_knife or safe_zeus) then
					new_config.pitch = 'Custom'
					new_config.pitch_value = pitch_tbl[Vars.AA.safe_functions.defensive_pitch:get()]
					new_config.yaw_offset = yaw_tbl[Vars.AA.safe_functions.defensive_yaw:get()]
				end
			end
		end
	else
		if defensive then
			if Vars.AA.manuals.defensive_aa:get() and is_manuals then
				new_config.pitch = 'Custom'
				new_config.pitch_value = pitch_tbl[Vars.AA.manuals.defensive_pitch:get()]
				new_config.yaw_offset = yaw_tbl[Vars.AA.manuals.defensive_yaw:get()]
			end
		end
	end
	new_config.yaw_offset = math.normalize_yaw(new_config.yaw_offset)

	conditional_antiaims.set_ui(new_config)
end

aero_lag_exp.switch_var = false
if Vars.AA.air_exploit then
	Vars.AA.air_exploit.enable:set_callback(function(self)
		if not self.value then
			gamesense_refs.rage_enable:set(true)
		end
		aero_lag_exp.duck, aero_lag_exp.duck_mode, aero_lag_exp.duck_key = gamesense_refs.duck_peek:get()
	end)
end
aero_lag_exp.handle = safecall('aero_lag_exp.handle', true, function()
    if not (Vars.AA.air_exploit and Vars.AA.air_exploit.enable:get()) then
        return
    end

	if not Vars.AA.air_exploit.enable.hotkey:get() then
        return
    end

	local distance_to_enemy = {conditional_antiaims.get_distance()}
	local dt_active = { gamesense_refs.duck_peek:get() }
	local in_air = not (bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), bit.lshift(1, 0)) ~= 0)
	gamesense_refs.rage_enable:override((not (elements.hotkey.enum[dt_active[2]] == 'Always on')) and aero_lag_exp.get_dt_charge(entity.get_local_player()) or (conditional_antiaims.player_state == conditional_antiaims.states.fakelag) or (not in_air))
	
	if (conditional_antiaims.player_state == conditional_antiaims.states.fakelag) then
		return
	end

    local players = entity.get_players(true)
    local threats = client.current_threat()

    local delay = Vars.AA.air_exploit.exp_tick:get()
    if globals.tickcount() % delay == 1 then 
        aero_lag_exp.switch_var = not aero_lag_exp.switch_var 
    end

	gamesense_refs.duck_peek:set(elements.hotkey.enum[aero_lag_exp.duck_mode])
    if Vars.AA.air_exploit.while_visible:get() then
        for i = 1, #players do
            if entity.is_dormant(players[i]) then
                return
            end

			if distance_to_enemy[1] > 119 then
				return
			end

            if players[i] == threats then
                if in_air and aero_lag_exp.switch_var then
					gamesense_refs.duck_peek:set('Always on')
                end
            end
        end
    else
        if in_air and aero_lag_exp.switch_var then
			gamesense_refs.duck_peek:set('Always on')
        end
    end
end)

antiaim_on_use.enabled = false
antiaim_on_use.start_time = globals.realtime()
antiaim_on_use.handle = function(cmd)

    antiaim_on_use.enabled = false

    if not Vars.AA.enable:get() then
        return
    end

    if not conditional_antiaims.conditions[11].switch:get() then
        return
    end

    if cmd.in_use == 0 then
        antiaim_on_use.start_time = globals.realtime()
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local player_origin = { entity.get_origin(player) }
	
    local CPlantedC4 = entity.get_all('CPlantedC4')
    local dist_to_bomb = 999

    if #CPlantedC4 > 0 then
        local bomb = CPlantedC4[1]
        local bomb_origin = { entity.get_origin(bomb) }

        dist_to_bomb = vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(bomb_origin[1], bomb_origin[2], bomb_origin[3]))
    end

    local CHostage = entity.get_all('CHostage')
    local dist_to_hostage = 999

    if CHostage ~= nil then
        if #CHostage > 0 then
            local hostage_origin = {entity.get_origin(CHostage[1])}

            dist_to_hostage = math.min(vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(hostage_origin[1], hostage_origin[2], hostage_origin[3])), vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(hostage_origin[1], hostage_origin[2], hostage_origin[3])))
        end
    end

    if dist_to_hostage < 65 and entity.get_prop(player, 'm_iTeamNum') ~= 2 then
        return
    end

    if dist_to_bomb < 65 and entity.get_prop(player, 'm_iTeamNum') ~= 2 then
        return
    end

    if cmd.in_use then
        if globals.realtime() - antiaim_on_use.start_time < 0.02 then
            return
        end
    end

    cmd.in_use = false
    antiaim_on_use.enabled = true

end

widgets.branded_watermark = {}

widgets.branded_watermark.handle = function()
    local anim = animations.new('widgets_branded_watermark', Vars.Misc.branded_watermark.value and 255 or 0)
	if anim < 1 then return end

	local accent = { Vars.Misc.branded_watermark.color:get() }
    local design_username = information.user

	local x, y = client.screen_size()
	local center = { x = x*0.5, y = y*0.5 }

	local white = { 255, 255, 255, anim }
	local design_accent_color = { accent[1], accent[2], accent[3], anim }

	if readfile(img.eva.path) then
		widgets.branded_watermark.img = images.load_png(readfile(img.eva.path))
		widgets.branded_watermark.img:draw(11, center.y - 16, 36, 36, 255, 255, 255, anim, true, 'f')
	end

	local text = { 
		[1] = string.format('ANGELWINGS\a%s.PINK', utils.rgb_to_hex(design_accent_color)),
		[2] = string.format('USER - %s [\a%s%s\a%s]', string.upper(design_username), utils.rgb_to_hex(design_accent_color), string.upper(information.version), utils.rgb_to_hex(white))
	}
	local measure = { render.measure_text('-', text[2]) }

	render.text(40, center.y + 5, 255, 255, 255, anim, '-', 0, text[1])
	render.text(40, center.y + (measure[2] + 2), 255, 255, 255, anim, '-', 0, text[2])
end

fast_ladder.handle = function(cmd)
    if not Vars.Misc.fast_ladder:get() then
        return
    end

	local plocal = entity.get_local_player()
	if plocal == nil then
		return end
	local pitch, yaw = client.camera_angles()
	if entity.get_prop(plocal, 'm_MoveType') == 9 then
		cmd.yaw = math.floor(cmd.yaw+0.5)
		cmd.roll = 0

		if Vars.Misc.fast_ladder_settings[1]:get('Ascending') then
			if cmd.forwardmove > 0 then
				if pitch < 45 then
					cmd.pitch = 89
					cmd.in_moveright = 1
					cmd.in_moveleft = 0
					cmd.in_forward = 0
					cmd.in_back = 1
					if cmd.sidemove == 0 then
						cmd.yaw = cmd.yaw + 90
					end
					if cmd.sidemove < 0 then
						cmd.yaw = cmd.yaw + 150
					end
					if cmd.sidemove > 0 then
						cmd.yaw = cmd.yaw + 30
					end
				end 
			end
		end

		if Vars.Misc.fast_ladder_settings[1]:get('Descending') then
			if cmd.forwardmove < 0 then
				cmd.pitch = 89
				cmd.in_moveleft = 1
				cmd.in_moveright = 0
				cmd.in_forward = 1
				cmd.in_back = 0
				if cmd.sidemove == 0 then
					cmd.yaw = cmd.yaw + 90
				end
				if cmd.sidemove > 0 then
					cmd.yaw = cmd.yaw + 150
				end
				if cmd.sidemove < 0 then
					cmd.yaw = cmd.yaw + 30
				end
			end
		end
	end
end

aa_package = ui_handler.setup(conditional_antiaims.conditions)
aa_config = aa_package:save()
package = ui_handler.setup(Vars)
config = package:save()

ui_handler.traverse(Vars, function (element, path)
    element:depend({tab, path[1]})
end)

ui_handler.traverse(conditional_antiaims.conditions, function (element, path)
    element:depend({tab, 'AA'})
	experimental_defensive111:depend({tab, 'AA'})
	experimental_defensive:depend({tab, 'AA'})
end)

for k, v in pairs(conditional_antiaims.conditions_names) do
	if v ~= 'Shared' then
		conditional_antiaims.conditions[k].switch:depend({Vars.AA.enable, true}, {Vars.AA.Settings.condition_combo, v})
	end

	for k2, v2 in pairs(conditional_antiaims.conditions[k]) do
		if k2 ~= "switch" then
			v2:depend({Vars.AA.enable, true}, {Vars.AA.Settings.condition_combo, v})
		end
	end
	conditional_antiaims.conditions[k].yaw_modifier_offset:depend({conditional_antiaims.conditions[k].yaw_modifier, 'Off', true}, {conditional_antiaims.conditions[k].yaw_modifier, 'L&R Center', true}, {conditional_antiaims.conditions[k].yaw_modifier, 'Custom way', true})
	conditional_antiaims.conditions[k].yaw_modifier_offset979:depend({conditional_antiaims.conditions[k].yaw_modifier, 'L&R Center'})
	conditional_antiaims.conditions[k].yaw_modifier_offset1337:depend({conditional_antiaims.conditions[k].yaw_modifier, 'L&R Center'})
	conditional_antiaims.conditions[k].yaw_modifier_offset1:depend({conditional_antiaims.conditions[k].yaw_modifier, 'Custom way'})
	conditional_antiaims.conditions[k].yaw_modifier_offset2:depend({conditional_antiaims.conditions[k].yaw_modifier, 'Custom way'})
	conditional_antiaims.conditions[k].yaw_modifier_offset3:depend({conditional_antiaims.conditions[k].yaw_modifier, 'Custom way'})
	conditional_antiaims.conditions[k].body_yaw_offset:depend({conditional_antiaims.conditions[k].body_yaw, 'Off', true}, {conditional_antiaims.conditions[k].body_yaw, 'Advanced', true})
	conditional_antiaims.conditions[k].delay_ticks:depend({conditional_antiaims.conditions[k].body_yaw, 'Advanced'})
	if v ~= 'Fakelag' then
		conditional_antiaims.conditions[k].defensive_pitch:depend({conditional_antiaims.conditions[k].defensive_aa, true})
		conditional_antiaims.conditions[k].pitch_slider:depend({conditional_antiaims.conditions[k].defensive_aa, true}, {conditional_antiaims.conditions[k].defensive_pitch, 'Custom'})
		conditional_antiaims.conditions[k].defensive_yaw:depend({conditional_antiaims.conditions[k].defensive_aa, true})
		conditional_antiaims.conditions[k].yaw_slider:depend({conditional_antiaims.conditions[k].defensive_aa, true}, {conditional_antiaims.conditions[k].defensive_yaw, 'Custom'})
	end
end

for k, v in pairs(Vars.Misc.screen_indicators_settings) do
    v:depend({Vars.Misc.screen_indicators, true})
end

for k, v in pairs(Vars.Misc.anim_breakers_settings) do
    v:depend({Vars.Misc.anim_breakers, true})
end

for k, v in pairs(Vars.Misc.fast_ladder_settings) do
    v:depend({Vars.Misc.fast_ladder, true})
end

for k, v in pairs(Vars.Misc.manual_arrows_settings) do
    Vars.Misc.manual_arrows_settings.settings:depend({Vars.Misc.manual_arrows, true})
	Vars.Misc.manual_arrows_settings.adding:depend({Vars.Misc.manual_arrows, true}, {Vars.Misc.manual_arrows_settings.settings, 'Default'})
	Vars.Misc.manual_arrows_settings.accent_color:depend({Vars.Misc.manual_arrows, true}, {Vars.Misc.manual_arrows_settings.settings, 'Default'})
	
	Vars.Misc.manual_arrows_settings.teamskeet_adding:depend({Vars.Misc.manual_arrows, true}, {Vars.Misc.manual_arrows_settings.settings, 'Teamskeet'})
	Vars.Misc.manual_arrows_settings.teamskeet_accent_color:depend({Vars.Misc.manual_arrows, true}, {Vars.Misc.manual_arrows_settings.settings, 'Teamskeet'})
	Vars.Misc.manual_arrows_settings.teamskeet_desync_accent_color:depend({Vars.Misc.manual_arrows, true}, {Vars.Misc.manual_arrows_settings.settings, 'Teamskeet'})

	Vars.Misc.manual_arrows_settings.invictus_dynamic:depend({Vars.Misc.manual_arrows, true}, {Vars.Misc.manual_arrows_settings.settings, 'Invictus'})
	Vars.Misc.manual_arrows_settings.getzeus_adding:depend({Vars.Misc.manual_arrows, true}, {Vars.Misc.manual_arrows_settings.settings, 'Invictus'})
	Vars.Misc.manual_arrows_settings.getzeus_accent_color:depend({Vars.Misc.manual_arrows, true}, {Vars.Misc.manual_arrows_settings.settings, 'Invictus'})
	Vars.Misc.manual_arrows_settings.getzeus_second_accent_color:depend({Vars.Misc.manual_arrows, true}, {Vars.Misc.manual_arrows_settings.settings, 'Invictus'})
end

Vars.Misc.alt_watermark:depend({Vars.Misc.branded_watermark, false})
Vars.Misc.alt_watermark_settings.pos:depend({Vars.Misc.branded_watermark, false}, {Vars.Misc.alt_watermark, 'Modern'})
Vars.Misc.alt_watermark_settings.color:depend({Vars.Misc.branded_watermark, false}, {Vars.Misc.alt_watermark, 'Modern'})
Vars.Misc.alt_watermark_settings.nosp:depend({Vars.Misc.branded_watermark, false}, {Vars.Misc.alt_watermark, 'Modern'})

if Vars.Misc.crosshair_settings then
	for k, v in pairs(Vars.Misc.crosshair_settings) do
		v:depend({Vars.Misc.crosshair_hitlog, true})
	end
end

if Vars.Misc.hitlog_console then
	for k, v in pairs(Vars.Misc.hitlogger_settings) do
		v:depend({Vars.Misc.hitlog_console, true})
	end
end

for k, v in pairs(Vars.AA.manuals) do
    Vars.AA.manuals.left:depend({Vars.AA.manuals.enable, true})
	Vars.AA.manuals.right:depend({Vars.AA.manuals.enable, true})
	Vars.AA.manuals.reset:depend({Vars.AA.manuals.enable, true})
	Vars.AA.manuals.inverter:depend({Vars.AA.manuals.enable, true})
	Vars.AA.manuals.manuals_over_fs:depend({Vars.AA.manuals.enable, true})
	Vars.AA.manuals.lag_options:depend({Vars.AA.manuals.enable, true})
	Vars.AA.manuals.defensive_aa:depend({Vars.AA.manuals.enable, true})
	Vars.AA.manuals.defensive_pitch:depend({Vars.AA.manuals.enable, true}, {Vars.AA.manuals.defensive_aa, true})
	Vars.AA.manuals.pitch_slider:depend({Vars.AA.manuals.enable, true}, {Vars.AA.manuals.defensive_aa, true}, {Vars.AA.manuals.defensive_pitch, 'Custom'})
	Vars.AA.manuals.defensive_yaw:depend({Vars.AA.manuals.enable, true}, {Vars.AA.manuals.defensive_aa, true})
	Vars.AA.manuals.yaw_slider:depend({Vars.AA.manuals.enable, true}, {Vars.AA.manuals.defensive_aa, true}, {Vars.AA.manuals.defensive_yaw, 'Custom'})
end

for k, v in pairs(Vars.AA.safe_functions) do
	Vars.AA.safe_functions.settings:depend({Vars.AA.safe_functions.enable, true})
	Vars.AA.safe_functions.head_settings:depend({Vars.AA.safe_functions.enable, true}, {Vars.AA.safe_functions.settings, 'Head'})
	Vars.AA.safe_functions.lag_options:depend({Vars.AA.safe_functions.enable, true})
	Vars.AA.safe_functions.defensive_aa:depend({Vars.AA.safe_functions.enable, true})
	Vars.AA.safe_functions.defensive_pitch:depend({Vars.AA.safe_functions.enable, true}, {Vars.AA.safe_functions.defensive_aa, true})
	Vars.AA.safe_functions.pitch_slider:depend({Vars.AA.safe_functions.enable, true}, {Vars.AA.safe_functions.defensive_aa, true}, {Vars.AA.safe_functions.defensive_pitch, 'Custom'})
	Vars.AA.safe_functions.defensive_yaw:depend({Vars.AA.safe_functions.enable, true}, {Vars.AA.safe_functions.defensive_aa, true})
	Vars.AA.safe_functions.yaw_slider:depend({Vars.AA.safe_functions.enable, true}, {Vars.AA.safe_functions.defensive_aa, true}, {Vars.AA.safe_functions.defensive_yaw, 'Custom'})
end

if Vars.AA.air_exploit then
	for k, v in pairs(Vars.AA.air_exploit) do
		Vars.AA.air_exploit.while_visible:depend({Vars.AA.air_exploit.enable, true})
		Vars.AA.air_exploit.exp_tick:depend({Vars.AA.air_exploit.enable, true})
	end
end

client.set_event_callback('shutdown', function()
	utils.hide_aa_tab(false)
end)

client.set_event_callback('pre_render', function()
	utils.hide_aa_tab(true)
end)
client.set_event_callback('setup_command', aero_lag_exp.handle)
client.set_event_callback('paint', crosshair_logger.handle)
client.set_event_callback('paint', screen_indication.handle)
client.set_event_callback('paint', manual_indication.handle)
client.set_event_callback('setup_command', manual_indication.peeking_whom)
client.set_event_callback('pre_render', model_breaker.handle)
client.set_event_callback('paint', widgets.branded_watermark.handle)
client.set_event_callback('player_hurt', crosshair_logger.player_hurt)
client.set_event_callback('aim_fire', crosshair_logger.aim_fire)
client.set_event_callback('aim_miss', crosshair_logger.aim_miss)
client.set_event_callback('setup_command', function(cmd)
	model_breaker.handle_jitter(cmd)
end)
client.set_event_callback('net_update_end', conditional_antiaims.defensive_handle)
client.set_event_callback('net_update_end', conditional_antiaims.defensive_handle1)
client.set_event_callback('net_update_end', expres.handle)
client.set_event_callback('player_death', death_spammer.handle)
client.set_event_callback('player_death', function(e)
	chat_spammer.handle(e)
end)
client.set_event_callback('round_start', function()
	conditional_antiaims.manual_dir = 0
	conditional_antiaims.last_press = globals.curtime()
end)
client.set_event_callback('setup_command', function(cmd)
	fast_ladder.handle(cmd)
	conditional_antiaims.handle(cmd)
	antiaim_on_use.handle(cmd)
end)