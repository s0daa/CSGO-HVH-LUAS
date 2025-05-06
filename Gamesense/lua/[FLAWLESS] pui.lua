

-- perfect user interface • gamesense
----- enQ#1349


print "pui debug"

-------------------------------------------------------------------------
-- #region :: Header


--
-- #region : Definitions

--#region: localization

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

--#endregion

--#region: globals

table.find = function (t, j)  for k, v in pairs(t) do if v == j then return k end end return false  end
table.ifind = function (t, j)  for i = 1, table.maxn(t) do if t[i] == j then return i end end  end
table.qfind = function (t, j)  for i = 1, #t do if t[i] == j then return i end end  end
table.ihas = function (t, ...) local arg = {...} for i = 1, table.maxn(t) do for j = 1, #arg do if t[i] == arg[j] then return true end end end return false end

table.minn = function (t) local s = 0 for i = 1, #t do if t[i] == nil then break end s = s + 1 end return s end
table.filter = function (t)  local res = {} for i = 1, table.maxn(t) do if t[i] ~= nil then res[#res+1] = t[i] end end return res  end
table.append = function (t, ...)  for i, v in ipairs{...} do table.insert(t, v) end  end
table.copy = mcopy

local ternary = function (c, a, b)  if c then return a else return b end  end
local contend = function (func, callback, ...)
	local t = { pcall(func, ...) }
	if not t[1] then return type(callback) == "function" and callback(t[2]) or error(t[2], callback or 2) end
	return unpack(t, 2)
end

--#endregion

--#region: directory tools

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

--#endregion

local pui, pui_mt, methods_mt = {}, {}, {
	element = {}, group = {}
}

-- #endregion
--

--
-- #region : Elements

--#region: arguments

local registry, ragebot, players = {}, {}, {}

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

--#endregion

--#region: registry

local ui_mset = function (k, v)
	if registry[k].type == "hotkey" then
		ui.set(k, elements.hotkey.enum[ v[2] ], v[3])
	else
		ui.set(k, v)
	end
end

local ui_mget = function (k)
	if registry[k].type == "hotkey" then return { ui.get(k) } else return ui.get(k) end
end

do
	client.set_event_callback("shutdown", function ()
		for k, v in next, registry do
			if v.__ref and not v.__rage then
				if v.overridden then ui_mset(k, v.original) end
				ui.set_enabled(k, true)
				ui.set_visible(k, not v.__hidden)
			end
		end
		ragebot.cycle(function (active)
			for k, v in pairs(ragebot.context[active]) do
				if v ~= nil and registry[k].overridden then
					ui_mset(k, v)
				end
			end
		end, true)
	end)
	client.set_event_callback("pre_config_save", function ()
		for k, v in next, registry do
			if v.__ref and not v.__rage and v.overridden then
				v.ovr_restore = { ui_mget(k) }
				ui_mset(k, v.original)
			end
		end
		ragebot.cycle(function (active)
			for k, v in pairs(ragebot.context[active]) do
				if registry[k].overridden then
					ragebot.cache[active][k] = { ui_mget(k) }
					ui_mset(k, v)
				end
			end
		end, true)
	end)
	client.set_event_callback("post_config_save", function ()
		for k, v in next, registry do
			if v.__ref and not v.__rage and v.overridden then
				ui_mset(k, unpack(v.ovr_restore))
				v.ovr_restore = nil
			end
		end
		ragebot.cycle(function (active)
			for k, v in pairs(ragebot.context[active]) do
				if registry[k].overridden and ragebot.cache[active][k] ~= nil then
					ui_mset(k, unpack(ragebot.cache[active][k]))
					ragebot.cache[active][k] = nil
				end
			end
		end, true)
	end)
end

--#endregion

--#region: elemence

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
		"Unlock hidden cvars", "Allow custom game events", "Faster grenade toss",
		"sv_maxunlag", "sv_maxusrcmdprocessticks", "sv_clockcorrection_msecs", -- m4kb12jk
	}

	--#region: depend

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

	--#endregion
end

--#endregion

--#region: utils

local utils = {}

do
	utils.rgb_to_hex = function (color)
		return string.format("%02X%02X%02X%02X", color[1], color[2], color[3], color[4] or 255)
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
			s = string.gsub(s, "\f<(.-)>", pui.macros)
			s = string.gsub(s, "[\v\r\t]", {["\v"] = "\a".. pui.accent, ["\r"] = "\aCDCDCDFF", ["\t"] = "    "})
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

	--#region: dispense

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

	--#endregion
end

--#endregion

-- #endregion
--


-- #endregion -----------------------------------------------------------
--


-------------------------------------------------------------------------
-- #region :: pui


--
-- #region : pui

--#region: variables

pui.macros = setmetatable({}, {
	__newindex = function (self, key, value) rawset(self, tostring(key), value) end,
	__index = function (self, key) return rawget(self, tostring(key)) end
})

pui.accent, pui.menu_open = nil, ui.is_menu_open()

do
	local reference = ui.reference("MISC", "Settings", "Menu color")
	pui.accent = utils.rgb_to_hex{ ui.get(reference) }
	local previous = pui.accent

	ui.set_callback(reference, function ()
		local color = { ui.get(reference) }
		pui.accent = utils.rgb_to_hex(color)

		for idx, ref in next, registry do
			if ref.type == "label" and not ref.__ref then
				local new, count = string.gsub(ref.self.value, previous, pui.accent)
				if count > 0 then
					ui.set(idx, new)
					ref.self.value = new
				end
			end
		end
		previous = pui.accent
		client.fire_event("pui::accent_color", color)
	end)
end

client.set_event_callback("paint_ui", function ()
	local state = ui.is_menu_open()
	if state ~= pui.menu_open then
		client.fire_event("pui::menu_state", state)
		pui.menu_open = state
	end
end)

--#endregion

--#region: features

pui.group = function (tab, container) return elemence.group(tab, container) end

pui.format = utils.format

pui.reference = function (tab, container, name)
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
			__rage = string.lower(container) == "aimbot" or nil,
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

pui.traverse = function (t, f, p)
	p = p or {}

	if type(t) == "table" and t.__name ~= "pui::element" and t[#t] ~= "~" then
		for k, v in next, t do
			local np = table.copy(p); np[#np+1] = k
			pui.traverse(v, f, np)
		end
	else
		f(t, p)
	end
end

--#endregion

--#region: config system

do
	local save = function (config, ...)
		local packed = {}

		pui.traverse(dirs.extract(config, {...}), function (ref, path)
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
		pui.traverse(dirs.extract(config, {...}), function (ref, path)
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
		__type = "pui::package", __metatable = false,
		__call = function (self, raw, ...)
			return (type(raw) == "table" and load or save)(self[0], raw, ...)
		end,
		save = function (self, ...) return save(self[0], ...) end,
		load = function (self, ...) load(self[0], ...) end,
	}	package_mt.__index = package_mt

	pui.setup = function (t)
		local package = { [0] = {} }
		pui.traverse(t, function (r, p) elemence.memorize(r, p, package[0]) end)
		return setmetatable(package, package_mt)
	end
end

--#endregion

-- #endregion
--

--
-- #region : methods

methods_mt.element = {
	__type = "pui::element", __name = "pui::element", __metatable = false,
	__eq = function (this, that) return this.ref == that.ref end,
	__tostring = function (self) return string.format('pui.%s[%d] "%s"', self.type, self.ref, self.name) end,
	__call = function (self, ...) if #{...} > 0 then ui.set(self.ref, ...) else return ui.get(self.ref) end end,

	--

	depend = function (self, ...)
		local arg = {...}
		local disabler = arg[1] == true

		local depend = registry[self.ref].depend[disabler and 2 or 1]
		local this = registry[self.ref].depend[0]

		for i = (disabler and 2 or 1), table.maxn(arg) do
			local v = arg[i]
			if v then
				if v.__name == "pui::element" then v = {v, true} end
				depend[#depend+1] = v

				local check = function () elemence.dependant(depend, this, disabler) end
				check()

				registry[v[1].ref].callbacks[#registry[v[1].ref].callbacks+1] = check
			end
		end

		return self
	end,

	override = function (self, value)
		local ctx, wctx = registry[self.ref], ragebot.context[ragebot.ref.value]

		if value ~= nil then
			if not ctx.overridden then
				if self.type == "hotkey" then self.value = { ui.get(self.ref) } end
				if ctx.__rage then wctx[self.ref] = self.value else ctx.original = self.value end
			end ctx.overridden = true
			if ctx.__rage then ctx.__ovr_v = value end
			ui_mset(self.ref, value)
		else
			if ctx.overridden then
				local original = ctx.original if ctx.__rage then original, ctx.__ovr_v = wctx[self.ref], nil end
				ui_mset(self.ref, original)
				ctx.overridden = false
			end
		end
	end,
	get_original = function (self)
		if registry[self.ref].overridden then
			if registry[self.ref].__rage then
				return ragebot.context[ragebot.ref.value][self.ref]
			else
				return registry[self.ref].original
			end
		else return self.value end
	end,

	--

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
		if ui.get(self.ref) > cap then ui.set(self.ref, cap) end
	end,
	get_list = function (self) return registry[self.ref].__list end,

	is_active = function (self)
		return self.value and ui.get(self.hotkey.ref)
	end,
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
	__name = "pui::group",
	__metatable = false,
	__index = function (self, key) return rawget(methods_mt.group, key) or pui_mt.__index(self, key) end,
	get_location = function (self) return self[1], self[2] end
}

-- #endregion
--

--
-- #region : pui_mt, ragebot and plist handler

do
	local cached = {}
	for k, v in next, elements do
		cached[k] = function (origin, ...)
			local args, group = utils.dispense(k, origin, ...)
			local this = elemence.new( contend(ui["new_".. k], 3, group[1], group[2], unpack(args, 1, args.n < args.req and args.n or args.req)), args.data )

			elemence.features(this, args.misc)
			return this
		end
	end

	pui_mt.__name, pui_mt.__metatable = "pui::basement", false
	pui_mt.__index = function (self, key)
		if not elements[key] then return ui[key] end
		if key == "string" then return elemence.string end

		return cached[key]
	end
end


--#region: ragebot handler

ragebot = {
	ref = pui.reference("RAGE", "Weapon type", "Weapon type"),
	context = {}, cache = {},
	silent = false,
} do
	local previous, cycle_action = ragebot.ref.value, nil
	for i, v in ipairs(weapons) do ragebot.context[v], ragebot.cache[v] = {}, {} end

	local neutral = ui.reference("RAGE", "Aimbot", "Enabled")
	ui.set_callback(neutral, function ()
		if not ragebot.silent then client.delay_call(0, client.fire_event, "pui::adaptive_weapon", ragebot.ref.value, previous) end
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

	local memorize = function (self)
		local ctx = ragebot.context[ragebot.ref.value]
		if registry[self.ref].overridden then
			if ctx[self.ref] == nil then
				ctx[self.ref] = self.value
				ui_mset(self.ref, registry[self.ref].__ovr_v)
			end
		else
			if ctx[self.ref] then
				ui_mset(self.ref, ctx[self.ref])
				ctx[self.ref] = nil
			end
		end
	end

	client.set_event_callback("pui::adaptive_weapon", function (cur, prev)
		for k, v in next, registry do
			if v.__rage then memorize(v.self) end
		end
	end)

	ragebot.memorize = function (self) end
end

--#endregion

--#region: plist handler

players = {
	elements = {}, list = {},
} do
	--#region: stuff

	pui.plist = elemence.group("PLAYERS", "Adjustments")
	pui.plist.__plist = true

	local selected = 0
	local refs, slot = {
		list = pui.reference("PLAYERS", "Players", "Player list"),
		reset = pui.reference("PLAYERS", "Players", "Reset all"),
		apply = pui.reference("PLAYERS", "Adjustments", "Apply to all"),
	}, {}

	--#endregion

	--#region: slot metatable

	local slot_mt = {
		__type = "pui::player_slot", __metatable = false,
		__tostring = function (self)
			return string.format("pui::player_slot[%d] of %s", self.idx, methods_mt.element.__tostring(registry[self.ref].self))
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

	--#endregion

	--#region: slots handling stuff

	players.traverse = function (fn) for i, v in ipairs(players.elements) do fn(v) end end

	slot = {
		select = function (idx)
			if not idx then return end
			for i, v in ipairs(players.elements) do
				methods_mt.element.set(v, v[idx].value)
			end
		end,
		add = function (idx)
			if not idx then return end
			for i, v in ipairs(players.elements) do
				local default = ternary(registry[v.ref].__init ~= nil, registry[v.ref].__init, v.value)
				v[idx], players.list[idx] = setmetatable({
					ref = v.ref, idx = idx, value = default
				}, slot_mt), true
			end
		end,
		remove = function (idx)
			if not idx then return end
			for i, v in ipairs(players.elements) do
				v[idx], players.list[idx] = nil, nil
			end
		end,
	}

	players.slot_update = function (self)
		if self[selected] then self[selected].value = self.value
		else slot.add(selected) end
	end

	--#endregion

	--#region: callbacks

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
		client.fire_event("pui::plist_update", selected)
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

	--

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

	--#endregion
end

--#endregion

-- #endregion
--


-- #endregion -----------------------------------------------------------
--


return setmetatable(pui, pui_mt)