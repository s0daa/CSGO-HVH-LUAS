local named_pipes = require("primordial/named pipes library.659")
local panorama = require("primordial/Panorama Library.248")
local cast = ffi.cast

ffi.cdef [[
    typedef void*(__thiscall* shell_execute_t)(void*, const char*, const char*); 
]] 

cp = ffi.typeof('void***')
vgui = memory.create_interface('vgui2.dll', 'VGUI_System010')
ivgui = cast(cp,vgui)
ShellExecuteA = cast("shell_execute_t", ivgui[0][3])

local function requireJSON()
    local json = {}

	local function kind_of(obj)
		if type(obj) ~= 'table' then return type(obj) end
		local i = 1
		for _ in pairs(obj) do
		  if obj[i] ~= nil then i = i + 1 else return 'table' end
		end
		if i == 1 then return 'table' else return 'array' end
	  end
	  
	  local function escape_str(s)
		local in_char  = {'\\', '"', '/', '\b', '\f', '\n', '\r', '\t'}
		local out_char = {'\\', '"', '/',  'b',  'f',  'n',  'r',  't'}
		for i, c in ipairs(in_char) do
		  s = s:gsub(c, '\\' .. out_char[i])
		end
		return s
	  end
	  
	  local function skip_delim(str, pos, delim, err_if_missing)
		pos = pos + #str:match('^%s*', pos)
		if str:sub(pos, pos) ~= delim then
		  if err_if_missing then
			error('Expected ' .. delim .. ' near position ' .. pos)
		  end
		  return pos, false
		end
		return pos + 1, true
	  end
	  
	  local function parse_str_val(str, pos, val)
		val = val or ''
		local early_end_error = 'End of input found while parsing string.'
		if pos > #str then error(early_end_error) end
		local c = str:sub(pos, pos)
		if c == '"'  then return val, pos + 1 end
		if c ~= '\\' then return parse_str_val(str, pos + 1, val .. c) end
		local esc_map = {b = '\b', f = '\f', n = '\n', r = '\r', t = '\t'}
		local nextc = str:sub(pos + 1, pos + 1)
		if not nextc then error(early_end_error) end
		return parse_str_val(str, pos + 2, val .. (esc_map[nextc] or nextc))
	  end
	  
	  local function parse_num_val(str, pos)
		local num_str = str:match('^-?%d+%.?%d*[eE]?[+-]?%d*', pos)
		local val = tonumber(num_str)
		if not val then error('Error parsing number at position ' .. pos .. '.') end
		return val, pos + #num_str
	  end
	  
	  function json.stringify(obj, as_key)
		local s = {}
		local kind = kind_of(obj)
		if kind == 'array' then
		  if as_key then error('Can\'t encode array as key.') end
		  s[#s + 1] = '['
		  for i, val in ipairs(obj) do
			if i > 1 then s[#s + 1] = ', ' end
			s[#s + 1] = json.stringify(val)
		  end
		  s[#s + 1] = ']'
		elseif kind == 'table' then
		  if as_key then error('Can\'t encode table as key.') end
		  s[#s + 1] = '{'
		  for k, v in pairs(obj) do
			if #s > 1 then s[#s + 1] = ', ' end
			s[#s + 1] = json.stringify(k, true)
			s[#s + 1] = ':'
			s[#s + 1] = json.stringify(v)
		  end
		  s[#s + 1] = '}'
		elseif kind == 'string' then
		  return '"' .. escape_str(obj) .. '"'
		elseif kind == 'number' then
		  if as_key then return '"' .. tostring(obj) .. '"' end
		  return tostring(obj)
		elseif kind == 'boolean' then
		  return tostring(obj)
		elseif kind == 'nil' then
		  return 'null'
		else
		  error('Unjsonifiable type: ' .. kind .. '.')
		end
		return table.concat(s)
	  end
	  
	  json.null = {}
	  
	  function json.parse(str, pos, end_delim)
		pos = pos or 1
		if pos > #str then error('Reached unexpected end of input.') end
		local pos = pos + #str:match('^%s*', pos)
		local first = str:sub(pos, pos)
		if first == '{' then
		  local obj, key, delim_found = {}, true, true
		  pos = pos + 1
		  while true do
			key, pos = json.parse(str, pos, '}')
			if key == nil then return obj, pos end
			if not delim_found then error('Comma missing between object items.') end
			pos = skip_delim(str, pos, ':', true)
			obj[key], pos = json.parse(str, pos)
			pos, delim_found = skip_delim(str, pos, ',')
		  end
		elseif first == '[' then
		  local arr, val, delim_found = {}, true, true
		  pos = pos + 1
		  while true do
			val, pos = json.parse(str, pos, ']')
			if val == nil then return arr, pos end
			if not delim_found then error('Comma missing between array items.') end
			arr[#arr + 1] = val
			pos, delim_found = skip_delim(str, pos, ',')
		  end
		elseif first == '"' then
		  return parse_str_val(str, pos + 1)
		elseif first == '-' or first:match('%d') then
		  return parse_num_val(str, pos)
		elseif first == end_delim then
		  return nil, pos + 1
		else
		  local literals = {['true'] = true, ['false'] = false, ['null'] = json.null}
		  for lit_str, lit_val in pairs(literals) do
			local lit_end = pos + #lit_str - 1
			if str:sub(pos, lit_end) == lit_str then return lit_val, lit_end + 1 end
		  end
		  local pos_info_str = 'position ' .. pos .. ': ' .. str:sub(pos, pos + 10)
		  error('Invalid json syntax starting at ' .. pos_info_str)
		end
	  end
	  
	  return json;
end

local json = requireJSON();

local __thiscall = function(func, this)
    return function(...) return func(this, ...) end
end

vtable_bind = function(module, interface, index, typedef)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or error(interface .. " was not found")
    return __thiscall(ffi.cast(typedef, addr[0][index]), addr)
end

local native_IsInGame = vtable_bind("engine.dll", "VEngineClient014", 26, "bool(__thiscall*)(void*)")
local native_IsConnected = vtable_bind("engine.dll", "VEngineClient014", 27, "bool(__thiscall*)(void*)")
local native_IsConnecting = vtable_bind("engine.dll", "VEngineClient014", 28, "bool(__thiscall*)(void*)")

local OPCODE_HANDSHAKE = 0
local OPCODE_FRAME = 1
local OPCODE_CLOSE = 2
local OPCODE_PING = 3
local OPCODE_PONG = 4

local EVENT_KEYS = {
	join_game = "ACTIVITY_JOIN",
	spectate_game = "ACTIVITY_SPECTATE",
	join_request = "ACTIVITY_JOIN_REQUEST"
}

local EVENT_LOOKUP = {
	ERRORED = "error"
}

--
-- utility funcs
--

local function deep_compare(tbl1, tbl2)
	if tbl1 == tbl2 then
		return true
	elseif type(tbl1) == "table" and type(tbl2) == "table" then
		for key1, value1 in pairs(tbl1) do
			local value2 = tbl2[key1]

			if value2 == nil then
				-- avoid the type call for missing keys in tbl2 by directly comparing with nil
				return false
			elseif value1 ~= value2 then
				if type(value1) == "table" and type(value2) == "table" then
					if not deep_compare(value1, value2) then
						return false
					end
				else
					return false
				end
			end
		end

		-- check for missing keys in tbl1
		for key2, _ in pairs(tbl2) do
			if tbl1[key2] == nil then
				return false
			end
		end

		return true
	end

	return false
end

local function table_dig(tbl, ...)
	local keys = {...}

	for i=1, #keys do
		if tbl == nil then
			return nil
		end

		tbl = tbl[keys[i]]
	end

	return tbl or nil
end

local function generate_nonce()
	local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	return (string.gsub(template, '[xy]', function (c)
		local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format('%x', v)
	end))
end

local function pack_int32le(int)
	return ffi.string(ffi.cast("const char*", ffi.new("uint32_t[1]", int)), 4)
end

local function unpack_int32le(str)
	return tonumber(ffi.cast("uint32_t*", ffi.cast("const char*", str))[0])
end

local function encode_str(opcode, str)
	local len = str:len()
    --print(pack_int32le(opcode) .. pack_int32le(len) .. str)
	return pack_int32le(opcode) .. pack_int32le(len) .. str
end

local function read_data(pipe)
	local header = pipe:read(8)
	if header == nil then
		return
	end

	local opcode = unpack_int32le(header:sub(1, 4))
	local len = unpack_int32le(header:sub(5, 8))

	local raw = pipe:read(len)

	if raw == nil then
		return
	end

	local data = json.parse(raw)

	return opcode, data
end

local OPEN_RPCS = {}

--
-- rpc object
--

local function rpc_dispatch_event(self, evt, ...)
	 --print("dispatching event ", evt, ", has handler: ", self.event_handlers[evt] ~= nil) -- debug
	if self.event_handlers[evt] ~= nil then
		self.event_handlers[evt](self, ...)
	end
end

local function rpc_write(self, opcode, str)
	if self.pipe ~= nil then
		local success, res = pcall(self.pipe.write, self.pipe, encode_str(opcode, str))

		if not success then
			self.pipe = nil
			self.open = false
			self.ready = false

			rpc_dispatch_event(self, "error", res)
		else
			return true
		end
	end
end

local function rpc_connect(self)
	if self.pipe == nil then
		-- try to connect
		local success, pipe, err
		for i=0, 10 do
			success, pipe = pcall(named_pipes.open_pipe, "\\\\?\\pipe\\discord-ipc-" .. i)

			if success then
				break
			end

			-- this is so we still get the proper error message if, say, pipe 1 failed to open due to permission denied and 2-9 dont exist
			if err == nil or pipe ~= "Failed to open pipe: File not found" then
				err = pipe
			end
		end

		if success then
			-- named pipe opened, send handshake frame
			self.pipe = pipe
			self.open = true
			self.ready = false

			local json_str = string.format('{"v":1,"client_id":%s}', json.stringify(self.client_id))
			--print("pipe opened ".. json.stringify(pipe)) -- debug
			self:write(OPCODE_HANDSHAKE, json_str)
		else
			rpc_dispatch_event(self, "failed", err:gsub("^Failed to open pipe: ", ""))
		end
	end
end

local function rpc_close(self)
	if self.pipe ~= nil then
		self:write(OPCODE_CLOSE, string.format('{"v":1,"client_id":%s}', json.stringify(self.client_id)))

		local success, err = pcall(named_pipes.close_pipe, self.pipe)

		self.pipe = nil
		self.open = false
		self.ready = false

		rpc_dispatch_event(self, "closed")

		if success then
			return true
		end
	end

	return false
end

local function rpc_request(self, cmd, args, evt, callback)
	local args_text = args == nil and "" or string.format('"args":%s,', json.stringify(args))
	local evt_text = evt == nil and "" or string.format('"evt":%s,', json.stringify(evt))

	local nonce = generate_nonce()

	local json_str = string.format('{"cmd":%s,%s%s"nonce":%s}', json.stringify(cmd), args_text, evt_text, json.stringify(nonce))

	if callback ~= nil then
		self.request_callbacks[nonce] = callback
	end

	self:write(OPCODE_FRAME, json_str)
end

local function rpc_process_activity(self)
	if self.timestamp_delta_max ~= nil and self.timestamp_delta_max > 0 then
		if type(table_dig(self.activity, "timestamps", "start")) == "number" and type(table_dig(self.activity_prev, "timestamps", "start")) == "number" then
			local delta = math.abs(self.activity_prev.timestamps["start"] - self.activity.timestamps["start"])

			if delta < self.timestamp_delta_max then
				self.activity.timestamps["start"] = self.activity_prev.timestamps["start"]
			end
		end

		if type(table_dig(self.activity, "timestamps", "end")) == "number" and type(table_dig(self.activity_prev, "timestamps", "end")) == "number" then
			local delta = math.abs(self.activity_prev.timestamps["end"] - self.activity.timestamps["end"])

			if delta < self.timestamp_delta_max then
				self.activity.timestamps["end"] = self.activity_prev.timestamps["end"]
			end
		end
	end

	if self.ready and not deep_compare(self.activity, self.activity_prev) then
		--print("setting activity") -- debug

		--print("old: ", inspect(self.activity_prev))
		--print("new: ", inspect(self.activity))

		local images

		if self.activity ~= nil and self.activity.assets ~= nil and (self.activity.assets.small_image ~= nil or self.activity.assets.large_image ~= nil) then
			images = {
				small_image = self.activity.assets.small_image,
				large_image = self.activity.assets.large_image
			}
		end

		self:request("SET_ACTIVITY", {
			pid = 4,
			activity = self.activity
		}, nil, function(self, response)
			if images ~= nil and response.evt == json.null then
				 --print("got response to SET_ACTIVITY: ", inspect(response))
				local new_fail = false

				for key, value in pairs(images) do
					if response.data.assets[key] == nil and not self.failed_images[value] then
						self.failed_images[value] = true
						rpc_dispatch_event(self, "image_failed_to_load", value)
					end
				end
			end
		end)
		self.activity_prev = self.activity
	end
end

local function rpc_process_messages(self)
	if self.pipe == nil then
		return
	end

	for i=1, 100 do
		local success, opcode, data = pcall(read_data, self.pipe)

		if not success then
			self.pipe = nil
			self.open = false
			self.ready = false

			rpc_dispatch_event(self, "error", opcode)
			return
		elseif opcode == nil then
			break
		else
			--print("Got opcode ", opcode, ": ") -- debug
			--print(inspect(data))

			 if opcode == OPCODE_FRAME and data.cmd == "DISPATCH" then
				if type(data.evt) == "string" then
					local evt = EVENT_LOOKUP[data.evt] or data.evt:lower()
					rpc_dispatch_event(self, evt, data.data)

					if data.evt == "READY" then
						self:update_event_handlers()
						self.ready = true
						rpc_process_activity(self)
					end
				end
			elseif opcode == OPCODE_FRAME then
				local callback = self.request_callbacks[data.nonce]
				if callback ~= nil then
					self.request_callbacks[data.nonce] = nil

					callback(self, data)
				end
			elseif opcode == OPCODE_PING then
				rpc_write(self, OPCODE_PONG, "")
			elseif opcode == OPCODE_CLOSE then
				self.pipe = nil
				self.open = false
				self.ready = false
				--print("pipe closed") -- debug
				rpc_dispatch_event(self, "error", opcode)
			end
		end
	end
end

local function rpc_set_activity(self, activity)
	self.activity = activity
	rpc_process_activity(self)
end

local function rpc_update_event_handlers(self)
	for event_key, event_name in pairs(EVENT_KEYS) do
		if not self.event_handlers_subscribed[event_key] and self.event_handlers[event_key] ~= nil then
			self:request("SUBSCRIBE", nil, event_name)
			self.event_handlers_subscribed[event_key] = true
		elseif self.event_handlers_subscribed[event_key] and self.event_handlers[event_key] == nil then
			self:request("UNSUBSCRIBE", nil, event_name)
			self.event_handlers_subscribed[event_key] = false
		end
	end
end

callbacks.add(e_callbacks.PAINT, function()
	for i=1, #OPEN_RPCS do
		rpc_process_messages(OPEN_RPCS[i])
	end
end)

local rpc_mt = {
	__index = {
		connect = rpc_connect,
		close = rpc_close,
		request = rpc_request,
		write = rpc_write,
		set_activity = rpc_set_activity,
		update_event_handlers = rpc_update_event_handlers
	}
}

local function new_rpc(client_id, event_handlers)
	local tbl = setmetatable({
		client_id = client_id,
		event_handlers = {},
		event_handlers_subscribed = {},
		failed_images = {},
		request_callbacks = {},
		ready = false,
		activity = nil,
		activity_prev = nil,
		timestamp_delta_max = 300
	}, rpc_mt)

	for key, value in pairs(event_handlers) do
		tbl.event_handlers[key] = value
	end

	table.insert(OPEN_RPCS, tbl)

	return tbl
end

--
-- rich presence implementation
--

local native_GetNetChannelInfo = vtable_bind("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
local native_GetAddress = ""--memory.get_vfunc("const char*(__thiscall*)(void*)", 1)
local native_IsLoopback = ""--memory.get_vfunc("bool(__thiscall*)(void*)", 6)

-- panorama api
local js = panorama.open()
local LobbyAPI, PartyListAPI, GameStateAPI, FriendsListAPI = js.LobbyAPI, js.PartyListAPI, js.GameStateAPI, js.FriendsListAPI

local GAMEPHASE_WARMUP = 0
local GAMEPHASE_MATCH = 1
local GAMEPHASE_FIRST_HALF = 2
local GAMEPHASE_SECOND_HALF = 3
local GAMEPHASE_HALFTIME = 4
local GAMEPHASE_END_OF_MATCH = 5

--
-- localization stuff
--

local localize_impl = panorama.loadstring([[
	return {
		localize: (str, params) => {
			if(params == null)
				return $.Localize(str)

			var panel = $.CreatePanel("Panel", $.GetContextPanel(), "")

			for(key in params) {
				panel.SetDialogVariable(key, params[key])
			}

			var result = $.Localize(str, panel)

			panel.DeleteAsync(0.0)

			return result
		}
	}
]])().localize

local localize_cache = {}
local function localize(str, params)
	if str == nil then return "" end

	if localize_cache[str] == nil then
		localize_cache[str] = {}
	end

	local params_key = params ~= nil and json.stringify(params) or true
	if localize_cache[str][params_key] == nil then
		localize_cache[str][params_key] = localize_impl(str, params)
	end

	return localize_cache[str][params_key]
end

-- do some replacements here
local localize_lookup = setmetatable({
	["Practice With Bots"] = "Local Server",
	["Offline"] = "Local Server",
	["Main Menu"] = "In Main Menu",
	["HauptmenÜ"] = "Im Hauptmenü",
	["Playing CS:GO"] = "In Game"
}, {
	__index = function(tbl, key)
		tbl[key] = key
		return key
	end
})

--
-- other utility funcs
--

local ts_offset = panorama.loadstring("return Date.now()/1000")()-globals.real_time()
local function get_unix_timestamp_float()
	return math.floor(ts_offset+globals.real_time()+0.5)
end

local function table_elements(tbl)
	local out = {}
	for i=1, #tbl do
		out[tbl[i]] = true
	end
	return out
end

local function localize_mapname(mapname)
	local token = GameStateAPI.GetMapDisplayNameToken(mapname)

	if mapname == token then
		return mapname
	end

	return localize(token)
end

local function clean_mapname(mapname)
    if mapname:find("ag_texture") then
		return "aim_ag_texture2"
	elseif mapname:find("dust2") then
		return "de_dust2"
	elseif mapname:find("dust") then
		return "de_dust"
	elseif mapname:find("mirage") then
		return "de_mirage"
	elseif mapname:find("inferno") then
		return "de_inferno"
	elseif mapname:find("cache") then
		return "de_cache"
	elseif mapname:find("overpass") then
		return "de_overpass"
	elseif mapname:find("train") then
		return "de_train"
	elseif mapname:find("nuke") then
		return "de_nuke"
	elseif mapname:find("cobblestone") or mapname:find("cbble") then
		return "de_cbble"
	elseif mapname:find("shortdust") then
		return "de_shortdust"
	elseif mapname:find("shortnuke") then
		return "de_shortnuke"
	elseif mapname:find("office") then
		return "cs_office"
	elseif mapname:find("italy") then
		return "cs_italy"
	elseif mapname:find("militia") then
		return "cs_militia"
	elseif mapname:find("assault") then
		return "cs_assault"
	elseif mapname:find("agency") then
		return "cs_agency"
	elseif mapname:find("vertigo") then
		return "de_vertigo"
	elseif mapname:find("ancient") then
		return "de_ancient"
	elseif mapname:find("anubis") then
		return "de_anubis"
	elseif mapname:find("bazaar") then
		return "de_bazaar"
	elseif mapname:find("biome") then
		return "de_biome"
	elseif mapname:find("blackgold") then
		return "de_blackgold"
	elseif mapname:find("breach") then
		return "de_breach"
	elseif mapname:find("calavera") then
		return "de_calavera"
	elseif mapname:find("canals") then
		return "de_canals"
	elseif mapname:find("castle") then
		return "de_castle"
	elseif mapname:find("chlorine") then
		return "de_chlorine"
	elseif mapname:find("coast") then
		return "de_coast"
	elseif mapname:find("elysion") then
		return "de_elysion"
	elseif mapname:find("empire") then
		return "de_empire"
	elseif mapname:find("engage") then
		return "de_engage"
	elseif mapname:find("facade") then
		return "de_facade"
	elseif mapname:find("favela") then
		return "de_favela"
	elseif mapname:find("guard") then
		return "de_guard"
	elseif mapname:find("lake") then
		return "de_lake"
	elseif mapname:find("library") then
		return "de_library"
	elseif mapname:find("lite") then
		return "de_lite"
	elseif mapname:find("marquis") then
		return "de_marquis"
	elseif mapname:find("mikla") then
		return "de_mikla"
	elseif mapname:find("mist") then
		return "de_mist"
    end

	return mapname:gsub("_scrimmagemap$", "")
end

local function title_case_gsub_cb(str)
	return str:sub(1, 1) .. str:sub(2, -1):lower()
end

local function title_case(str)
	return str:gsub("%u%u+", title_case_gsub_cb)
end

--
-- ui items
--
local lua_version = "v1.2"
local options_reference = menu.add_selection("Discord Rich Presence "..lua_version, "Rich Presence Options", {"primordial", "Hide cheat logo", "Fake skeet", "Fake neverlose"})
local rpc_status_reference = menu.add_text("Discord Rich Presence "..lua_version, "Status: Not connected")

local info1 = menu.add_text("Info", "Discord Rich Presence | Dawio89⋕9849")
local info2 = menu.add_text("Info", "")
local info3 = menu.add_text("Info", string.format("Hello %s dm me if you have any issues/questions", user.name))
local info4 = menu.add_text("Info", "Visit my Discord for giveaway's and new lua releases!")

local open = menu.add_button("Info", "AUTISTIC Discord", function()
    ShellExecuteA(ivgui, 'open', "https://discord.com/invite/tjjEuCc4Uf")
end)

local custom_text_storage = "placeholder"

local function set_status(status)
	if status ~= nil then
		-- print(status)
        rpc_status_reference:set("> " .. status)
	else
		rpc_status_reference:set("> ")
	end
end
set_status(nil)

--
-- some variables we need
--

local rpc, last_rich_presence_update, next_connection_attempt = nil, 0, globals.real_time()+5
local SERVER_MATCH = "^" .. localize("SFUI_Scoreboard_ServerName", {s1 = "(.*)"}) .. "$"
local MATCHMAKING_MATCH = localize("SFUI_PlayMenu_Online"):gsub(".", function(c) return string.format("[%s%s]", c:lower(), c:upper()) end)
local round_not_nil, round_start_time = 0, 0

--
-- func that creates the rich presence object (stateless)
--

local function update_rich_presence()
	local options = "" --options_reference:get()

	local activity = {
		assets = {
			large_image = "csgo-logo2",
			large_text = "Counter-Strike: Global Offensive"
		},
		instance = true
	}

	if options_reference:get() == 4 then
		activity.assets.small_image = "neverlose"
		activity.assets.small_text = "neverlose.cc"
    elseif options_reference:get() == 1 then
		activity.assets.small_image = "primordial"
		activity.assets.small_text = "primordial.dev"
    elseif options_reference:get() == 3 then
		activity.assets.small_image = "gamesense"
		activity.assets.small_text = "gamesense.pub"
	end

	local mapname = engine.get_level_name()
	if mapname ~= "" then
		--local nci = native_GetNetChannelInfo()
		-- local gamerules = entity.get_game_rules()

		if placeholder then
			local text = "test"--custom_text_storage

			if text:gsub(" ", "") ~= "" then
				activity.state = text
			end
		else
			activity.state = localize_lookup[localize("SFUI_Lobby_StatusPlayingCSGO")]

			--if nci ~= nil then
			--	if native_IsLoopback(nci) then
				--	activity.state = localize_lookup[localize("play_setting_offline")]
				if GameStateAPI.IsDemoOrHltv() then
					activity.state = localize("SFUI_Lobby_StatusWatchingCSGO")
				elseif game_rules.get_prop("m_bIsValveDS") == 1 then
					activity.state = localize_lookup[localize("play_setting_online"):gsub(MATCHMAKING_MATCH, localize("Panorama_Vote_Server"))]
				elseif GameStateAPI.GetServerName() ~= "" then
					activity.state = GameStateAPI.GetServerName():match(SERVER_MATCH)
				end
			end
		--end
		--print(type(GameStateAPI.GetTimeDataJSO())) -- ok prim didnt expect you to do thaaaat
		local time_data = GameStateAPI.GetTimeDataJSO()
		local curtime = globals.cur_time()
		local time_start, time_end = 0, 0

		local gamemode_name = GameStateAPI.GetGameModeName(true)
			if time_data == nil then return end
		if engine.is_connected() == true and time_data.gamephase == GAMEPHASE_WARMUP or time_data.gamephase == GAMEPHASE_HALFTIME then
			activity.details = string.format("%s [%s]", gamemode_name, localize("gamephase_" .. time_data.gamephase))

			if time_data.gamephase == GAMEPHASE_WARMUP and time_data.time ~= nil then
				time_start = curtime-cvars.mp_warmuptime:get_float()+time_data.time
				time_end = time_start+cvars.mp_warmuptime:get_float()
			end
		elseif engine.is_connected() == true and time_data ~= nil and time_data.gamephase == GAMEPHASE_END_OF_MATCH then
			local local_player = entity_list.get_local_player()

			local own_team, enemy_team
			if local_player ~= nil and local_player:get_prop("m_iTeamNum") == 2 then
				if local_player:get_prop("m_iTeamNum") == 2 then
					own_team, enemy_team = "TERRORIST", "CT"
				elseif local_player:get_prop("m_iTeamNum") == 3 then
					own_team, enemy_team = "CT", "TERRORIST"
				end
			end

			local score_data = GameStateAPI.GetScoreDataJSO()
			if own_team ~= nil then
				local own_score, enemy_score = score_data.teamdata[own_team].score, score_data.teamdata[enemy_team].score

				if own_score == 0 and enemy_score == 0 then
						local kills = player_resource.get_prop("m_iKills", 1) or 0
						local assists = player_resource.get_prop("m_iAssists", 1) or 0
						local deaths = player_resource.get_prop("m_iDeaths", 1) or 0
						activity.details = string.format("%s [ %d | %d | %d ]", gamemode_name, kills, assists, deaths)
				elseif own_score ~= nil and enemy_score ~= nil then
					activity.details = string.format("%s [%d:%d %s]", gamemode_name, own_score, enemy_score, localize((own_score == enemy_score) and "eom-result-tie2" or (own_score > enemy_score and "eom-result-win2" or "eom-result-loss2")))
				end
			end

			if activity.details == nil then
				activity.details = string.format("%s [%s]", gamemode_name, localize("gamephase_5"))
			end
		elseif time_data.gamephase == GAMEPHASE_MATCH or time_data.gamephase == GAMEPHASE_FIRST_HALF or time_data.gamephase == GAMEPHASE_SECOND_HALF then
			if time_data.roundtime_remaining >= time_data.roundtime then
				time_end = game_rules.get_prop("m_fRoundStartTime")

				if time_end ~= nil then
					time_start = time_end-cvars.mp_freezetime:get_float()
				end

			elseif time_data.roundtime > time_data.roundtime_remaining then
				-- print("time elapsed: ", time_data.roundtime-time_data.roundtime_remaining)
				-- local time_elapsed = time_data.roundtime-time_data.roundtime_remaining
				if game_rules.get_prop("m_fRoundStartTime") == nil then
					time_start = 0+0.5
				else
				time_start = game_rules.get_prop("m_fRoundStartTime")+0.5
				end
			end

			local score_text
			local internal_name = GameStateAPI.GetGameModeInternalName(true)

			local local_player = entity_list.get_local_player()
			if internal_name == "casual" or internal_name == "competitive" or internal_name == "scrimcomp2v2" or internal_name == "demolition" then
				local score_data = GameStateAPI.GetScoreDataJSO()
				
				local primary_team, secondary_team = "CT", "TERRORIST"
				if local_player ~= nil and local_player:get_prop("m_iTeamNum") == 2 then
					primary_team, secondary_team = "TERRORIST", "CT"
				end

				if score_data.teamdata[primary_team] ~= nil and score_data.teamdata[secondary_team] ~= nil then
					score_text = string.format("%d : %d", score_data.teamdata[primary_team].score, score_data.teamdata[secondary_team].score)
				end
			else
                    local kills = player_resource.get_prop("m_iKills", 1) or 0
                    local assists = player_resource.get_prop("m_iAssists", 1) or 0
                    local deaths = player_resource.get_prop("m_iDeaths", 1) or 0
					score_text = string.format("%d | %d | %d", kills, assists, deaths)
			end
			activity.details = gamemode_name .. (score_text and " [ " .. score_text .. " ]" or "")
		end
		-- map images
        if options_reference:get() == 4 then
            activity.assets = {
                large_image = "map_" .. clean_mapname(mapname),
                large_text = GameStateAPI.IsDemoOrHltv() and localize("SFUI_Lobby_StatusWatchingCSGO") or(localize("matchdraft_final_map", {mapname = GameStateAPI.GetMapName()})),
                small_image = options_reference:get() == 2 and "csgo-logo2" or "neverlose",
                small_text = options_reference:get() == 2 and "Counter-Strike: Global Offensive" or "Using neverlose.cc"
            }
        elseif options_reference:get() == 1 then
            activity.assets = {
                large_image = "map_" .. clean_mapname(mapname),
                large_text = GameStateAPI.IsDemoOrHltv() and localize("SFUI_Lobby_StatusWatchingCSGO") or(localize("matchdraft_final_map", {mapname = GameStateAPI.GetMapName()})),
                small_image = options_reference:get() == 2 and "csgo-logo2" or "primordial",
                small_text = options_reference:get() == 2 and "Counter-Strike: Global Offensive" or "Using primordial.dev"
            }
        elseif options_reference:get() == 3 then
            activity.assets = {
                large_image = "map_" .. clean_mapname(mapname),
                large_text = GameStateAPI.IsDemoOrHltv() and localize("SFUI_Lobby_StatusWatchingCSGO") or(localize("matchdraft_final_map", {mapname = GameStateAPI.GetMapName()})),
                small_image = options_reference:get() == 2 and "csgo-logo2" or "gamesense",
                small_text = options_reference:get() == 2 and "Counter-Strike: Global Offensive" or "Using gamesense.pub"
            }
        end

		if rpc.failed_images[activity.assets.large_image] then
			activity.assets.large_image = "bg_default"
		end

		if time_start ~= nil then
			local ts = get_unix_timestamp_float()
			local ts_curtime_start = ts-globals.cur_time()

			activity.timestamps = {
				start = math.floor((ts_curtime_start+time_start)*1000)
			}

			if time_end ~= nil and time_end > time_start then
				activity.timestamps["end"] = math.floor((ts_curtime_start+time_end)*1000)
			end
		end
	elseif native_IsConnecting() == true then
		activity.state = localize("LoadingProgress_Connecting")
	else
		-- in main menu
		activity.details = localize_lookup[title_case(localize("SFUI_MAINMENU"))]

		if LobbyAPI.IsSessionActive() then
			local session_settings = LobbyAPI.GetSessionSettings()

			if session_settings.system.network == "LIVE" and session_settings.system ~= nil then
				activity.details = localize_lookup[localize("SFUI_Lobby_StatusInLobby")]
			end

			local mm_status_string = LobbyAPI.GetMatchmakingStatusString()
			if session_settings.system.network == "LIVE" or (mm_status_string ~= nil and mm_status_string ~= "") then
				local game_mode_name = session_settings.game.mode ~= nil and localize("SFUI_GameMode" .. session_settings.game.mode) or localize_lookup[title_case(localize("SFUI_MAINMENU"))]

				if mm_status_string ~= nil and mm_status_string ~= "" then
					-- we are searching
					local status_localized = mm_status_string ~= nil and localize(mm_status_string) or nil
					if (status_localized == nil or status_localized == "") and session_settings.game ~= nil and session_settings.game.mmqueue ~= nil then
						status_localized = title_case(session_settings.game.mmqueue)
					end
					activity.state = string.format("%s - %s", game_mode_name, status_localized or "")

					activity.timestamps = {
						start = (get_unix_timestamp_float() - LobbyAPI.GetTimeSpentMatchmaking()) * 1000
					}

					local mm_state = PartyListAPI.GetPartySessionSetting("game/mmqueue")
					if mm_state == "reserved" or mm_state == "connect" then
						local mapname = PartyListAPI.GetPartySessionSetting("game/map")
						activity.assets.large_image = (mapname ~= nil and mapname ~= "" and not mapname:find(",")) and ("map_" .. mapname) or "bg_blurry"
						activity.assets.large_text = localize_mapname(mapname)

						if rpc.failed_images[activity.assets.large_image] then
							activity.assets.large_image = "bg_blurry"
						end
					end
				else
					-- just sitting in lobby
					activity.state = game_mode_name
				end

				-- _GetMaxLobbySlotsForGameMode in sessionutil.js
				local max_slots = 5
				if session_settings.game.mode == "scrimcomp2v2" or session_settings.game.mode == "cooperative" or session_settings.game.mode == "coopmission" then
					max_slots = 2
				elseif session_settings.game.mode == "survival" then
					max_slots = 2
				end

				if session_settings.system.network == "LIVE" then
					activity.party = {
						size = {PartyListAPI.GetCount(), max_slots}
					}

					-- if LobbyAPI.GetHostSteamID():len() > 10 then
					-- 	activity.party.id = LobbyAPI.GetHostSteamID()
					-- end
				end

				-- activity.secrets = {
				-- 	join = "",
				-- 	spectate = ""
				-- }
			end
		end
	end

	rpc:set_activity(activity)
end

--
-- update every second or on certain events
--

local function force_update()
	last_rich_presence_update = 0
end

rpc = new_rpc("1080964395816992919", {
	ready = function(self, data)
		update_rich_presence()

		local text = "Connected to " .. data.user.username .. "#" .. data.user.discriminator
		set_status(text)
		local function delayed_call()
			if rpc_status_reference:get() == "> " .. text then
				set_status(nil)
			end
		end
        client.delay_call(delayed_call, 10)
	end,
	failed = function(self, err)
		-- print("failed to open: ", err) --debug

		if err == "File not found" then
			-- discord isnt open, delay next attempt
			set_status("Connection failed: Discord not found.")
		else
			set_status("Connection failed: " .. tostring(err))
		end

		next_connection_attempt = globals.real_time()+5
	end,
	error = function(self, err)
		-- print("rpc error: ", err) --debug
		next_connection_attempt = globals.real_time()+5
		set_status("Error: " .. err)
	end,
	join_game = function(self)
	end,
	join_request = function(self)
	end,
	spectate_game = function(self)
	end,
	image_failed_to_load = update_rich_presence
})

local event_handlers = {
	callbacks.add(e_callbacks.PAINT, function()
		local realtime = globals.real_time()
		if not rpc.open and next_connection_attempt ~= nil and realtime > next_connection_attempt then
			set_status("Connecting...")
			-- print("connecting") --debug

			next_connection_attempt = realtime

			rpc:connect()
		elseif rpc.open and not rpc.ready and realtime > next_connection_attempt+150 then
			set_status("Connection timed out.")
			-- print("timed out") --debgug

			next_connection_attempt = next_connection_attempt+150+30

			rpc:close()
		elseif rpc.open and rpc.ready then
			if realtime-last_rich_presence_update > 1 then
				--custom_text_storage:set(custom_text_reference:get())
				last_rich_presence_update = realtime
				update_rich_presence()
			end
		end
	end),
	player_death = force_update,
	bomb_planted = force_update,
	round_start = force_update,
	round_end = force_update,
	buytime_ended = force_update,
	cs_game_disconnected = force_update,
	cs_win_panel_match = force_update,
	cs_match_end_restart = force_update
}

	for event, callback in pairs(event_handlers) do
			local function on_event(event, callback) end
            callbacks.add(e_callbacks.EVENT, on_event)

			if rpc.open and rpc.ready then
				rpc:set_activity(nil)
			end
	end

	-- delayed disconnect because reconnecting is heavily punished
		local _next_connection_attempt = next_connection_attempt
		local function delayed_call()
			if rpc.open and _next_connection_attempt == next_connection_attempt then
				next_connection_attempt = globals.real_time()+10
				rpc:close()
			end
		end
        client.delay_call(delayed_call, 60)

callbacks.add(e_callbacks.SHUTDOWN, function()
	if rpc.open then
		set_status(nil)
		rpc:close()
	end
end)