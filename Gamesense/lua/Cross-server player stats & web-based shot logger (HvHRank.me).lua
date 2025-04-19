local base64 = (function()local b={}local c=require'ffi'local d=require'bit'local e=d.rshift;local f=d.lshift;local g=d.bor;local h=d.band;local i=math.floor;local j=c.new("uint8_t[64]","ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")local k=c.new("uint8_t[256]")c.fill(k,256,0xFF)for l=0,63 do k[j[l]]=l end;local m=c.typeof'uint8_t[?]'local n=c.typeof'uint8_t*'function b.base64_decode(o,p)if type(o)=="string"and p==nil then p=#o end;local q,r;local s=c.new(m,i(d.rshift(p*3,2)))local t=c.cast(n,s)local u=c.cast(n,o)local l=0;while true do repeat if l>=p then goto v end;q=k[u[l]]l=l+1 until q~=0xFF;r=f(q,2)repeat if l>=p then goto v end;q=k[u[l]]l=l+1 until q~=0xFF;t[0]=g(r,e(q,4))t=t+1;r=f(q,4)repeat if l>=p then goto v end;q=k[u[l]]l=l+1 until q~=0xFF;t[0]=g(r,e(q,2))t=t+1;r=f(q,6)repeat if l>=p then goto v end;q=k[u[l]]l=l+1 until q~=0xFF;t[0]=g(r,q)t=t+1 end::v::return c.string(s,t-s)end;local w=c.new('uint16_t[4096]')for l=0,63 do for x=0,63 do local y;if c.abi("le")then y=j[x]*256+j[l]else y=j[l]*256+j[x]end;w[l*64+x]=y end end;local z=c.typeof"uint16_t[?]"local A=c.new("uint16_t[1]")if c.abi("le")then A[0]=0x0A*256+0x0D else A[0]=0x0D*256+0x0A end;local B=string.byte('=')function b.base64_encode(o,p,C)if type(o)=="string"and p==nil then p=#o end;local D=i(p*2/3)D=D+i(D/19)+3;local E=c.new(z,D)local F,G,y=0,0;local u=c.cast(n,o)local H=C and-1 or 38;local l,I=0,0::J::if l+3>p then goto K end;y=g(f(u[l],16),f(u[l+1],8),u[l+2])l=l+3::L::if H==I then E[I]=A[0]I=I+1;H=I+38 end;E[I]=w[e(y,12)]E[I+1]=w[h(y,4095)]I=I+2;goto J::K::if F>0 then if F==1 then E[I-1]=g(f(B,8),B)else c.cast(n,E)[f(I,1)-1]=B end else F=p-l;if F>0 then y=f(u[l],16)if F==2 then y=g(y,f(u[l+1],8))end;goto L end end;return c.string(E,f(I,1))end;return b end)()
base64.encode = base64.base64_encode
base64.decode = base64.base64_decode

local version = "1.1.1"
local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

local shots = {}
local impacts = {}
local shots_to_send = {}
local published_misses = {}
local published_hits = {}
local banned_server = false

local _panorama = panorama.open()
local cvars = {
	{ var = cvar.bot_stop, type = "int", validate = (function(v) return v == 0 end) },
	{ var = cvar.host_timescale, type = "float", validate = (function(v) return v == 1.0 end) },
	{ var = cvar.mp_respawn_on_death_ct, type = "int", validate = (function(v) return v == 0 end) },
	{ var = cvar.mp_respawn_on_death_t, type = "int", validate = (function(v) return v == 0 end) },
	{ var = cvar.sv_infinite_ammo, type = "int", validate = (function(v) return v == 0 end) }
}

local ffi = require("ffi")
local vector = require('vector')
local http = require("gamesense/http")
local weapons = require("gamesense/csgo_weapons")
local websockets = require("gamesense/websockets")

local d = "hvhrank.me"
local ep = "https://"..d
local ep_ws = "wss://"..d.."/agent"
local socket

local uid
local xuid = _panorama.MyPersonaAPI.GetXuid()

local command = "rme_set_token"
local db_token_key = "rme_account_token"
local token = false

-- thanks nicole, salvatore, jeffica and halflifefan for this awesomesauce below
ffi.cdef[[
	typedef void*(__thiscall* get_net_channel_info_t)(void*);
	typedef const char*(__thiscall* get_address_t)(void*);
	typedef const char*(__thiscall* get_name_t)(void*);
	typedef float(__thiscall* get_avg_loss_t)(void*, int);
	typedef float(__thiscall* get_avg_choke_t)(void*, int);
]]

local interface_ptr = ffi.typeof('void***')
local rawivengineclient = client.create_interface("engine.dll", "VEngineClient014") or error("VEngineClient014 wasnt found", 2)
local ivengineclient = ffi.cast(interface_ptr, rawivengineclient) or error("rawivengineclient is nil", 2)
local get_net_channel_info = ffi.cast("get_net_channel_info_t", ivengineclient[0][78]) or error("ivengineclient is nil")

local FLOW_OUTGOING = 0
local FLOW_INCOMING	= 1
local MAX_FLOWS = 2

local Popup = panorama.loadstring([[
	return [function(title, message) {
		UiToolkitAPI.ShowGenericPopupBgStyle(title, message, '', 'dim')
	}]
]], "CSGOPopups")()[0]

local function has(tab, val)
	for k,v in ipairs(tab) do
		if v == val then
			return true
		end
	end

	return false
end

-- thanks phil :)
local function xorstr(key, str)
	local strlen, keylen = #str, #key

	local strbuf = ffi.new("char[?]", strlen+1)
	local keybuf = ffi.new("char[?]", keylen+1)

	ffi.copy(strbuf, str)
	ffi.copy(keybuf, key)

	for i=0, strlen-1 do
		strbuf[i] = bit.bxor(strbuf[i], keybuf[i % keylen])
	end

	return ffi.string(strbuf, strlen)
end

local xor_key = "9c 84 6a e5 4f 05 65 67 38 ce 3c 64 87 00 b1 0e 9a c8"
local function EncapsulatePayload(payload)
	return base64.encode(xorstr(xor_key, json.stringify({ payload = payload })))
end

local function DecodePayload(payload)
	return xorstr(xor_key, base64.decode(payload))
end

-- UI stuff now

local send_modes = {
	"Bundled (Recommended)",
	"Singular"
}

local settings_options = {
	"Log shots to console",
	"Log links to console",
	"Visibility: Edit colors"
}

local send_modes_labels = {
	[send_modes[1]] = "Data will be sent to the service when performance isn't a concern.\n",
	[send_modes[2]] = "Data will be sent to the service in realtime during gameplay.\n"
}

local send_mode = ui.new_combobox("MISC", "Settings", "[HvHRank.me] Send Mode", send_modes)

local send_mode_label = ui.new_label("MISC", "Settings", send_modes_labels[send_modes[1]])
ui.set_visible(send_mode_label, false)

ui.set_callback(send_mode, function()
	local value = ui.get(send_mode)
	ui.set(send_mode_label, send_modes_labels[value])

	ui.set_visible(send_mode_label, true)
	client.delay_call(3, function()
		ui.set_visible(send_mode_label, false)
	end)

	if(socket ~= nil and #shots_to_send > 0) then
		socket:send(EncapsulatePayload({ shots = shots_to_send, time = globals.realtime() }))
		shots_to_send = {}
	end
end)

local settings = ui.new_multiselect("MISC", "Settings", "[HvHRank.me] Settings", settings_options)

local shot_hit_color_label = ui.new_label("MISC", "Settings", "Shot hit color (Console)")
local shot_hit_color = ui.new_color_picker("MISC", "Settings", "rme_shot_hit_color", 105, 255, 105, 255)

local shot_miss_color_label = ui.new_label("MISC", "Settings", "Shot miss color (Console)")
local shot_miss_color = ui.new_color_picker("MISC", "Settings", "rme_shot_miss_color", 255, 105, 105, 255)

local shot_link_color_label = ui.new_label("MISC", "Settings", "Shot link color (Console)")
local shot_link_color = ui.new_color_picker("MISC", "Settings", "rme_shot_link_color", 105, 255, 255, 255)

ui.set_visible(shot_hit_color_label, false)
ui.set_visible(shot_hit_color, false)

ui.set_visible(shot_miss_color_label, false)
ui.set_visible(shot_miss_color, false)

ui.set_visible(shot_link_color_label, false)
ui.set_visible(shot_link_color, false)

ui.set_callback(settings, function()
	local values = ui.get(settings)

	local log_shots = has(values, settings_options[1])
	local log_links = has(values, settings_options[2])
	local show_colors = has(values, settings_options[3])

	ui.set_visible(shot_hit_color_label, log_shots and show_colors)
	ui.set_visible(shot_hit_color, log_shots and show_colors)

	ui.set_visible(shot_miss_color_label, log_shots and show_colors)
	ui.set_visible(shot_miss_color, log_shots and show_colors)

	ui.set_visible(shot_link_color_label, log_links and show_colors)
	ui.set_visible(shot_link_color, log_links and show_colors)
end)


--

local references = {
	ragebot = ui.reference("RAGE", "Aimbot", "Enabled")
}

local function get_loss()
	local netchaninfo = ffi.cast('void***', get_net_channel_info(ivengineclient))
	local get_avg_loss = ffi.cast('get_avg_loss_t', netchaninfo[0][11])

	return math.floor(get_avg_loss(netchaninfo, FLOW_INCOMING) * 100)
end

local function get_choke()
	local netchaninfo = ffi.cast('void***', get_net_channel_info(ivengineclient))
	local get_avg_choke = ffi.cast('get_avg_choke_t', netchaninfo[0][12])

	return(math.floor(get_avg_choke(netchaninfo, FLOW_INCOMING) * 100))
end

local function get_server_address()
	local serverip = ""

	local netchaninfo = ffi.cast("void***", get_net_channel_info(ivengineclient))
	local get_server_address = ffi.cast("get_address_t", netchaninfo[0][1])
	serverip = ffi.string(get_server_address(netchaninfo))

	if (string.find(serverip, "A:")) then
		serverip = "valve"
	elseif serverip == "loopback" then
		serverip = "localhost"
	end

	return serverip
end

local function get_player_xuid(entindex)
	return _panorama.GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)
end

local function get_distance(x1, y1, z1, x2, y2, z2)
	local x, y, z = math.abs(x1 - x2), math.abs(y1 - y2), math.abs(z1 - z2)
	return math.sqrt(x * x + y * y + z * z)
end

local function color_print(...)
	local args = {...}
	local color, def = {255, 255, 255}
	local text, len = "No text", #args
	for k,v in pairs(args) do
		if type(v) == "table" then
			v[1] = v[1] or 255
			v[2] = v[2] or 255
			v[3] = v[3] or 255
			color = v
		else
			text = v
			client.color_log(color[1], color[2], color[3], text .. (k == len and "" or "\0"))
		end
	end
end

--

local function ShotToObject(event, missed)
	local shot = shots[event.id]
	local data = {}

	data.server = {
		address = get_server_address(),
		tick_rate = 1 / globals.tickinterval(),
		packet_loss = shot.loss,
		choked_packets = shot.choked
	}

	data.player = {
		velocity = shot.velocity,
		ping = shot.ping,

		weapon = shot.weapon
	}

	data.target = {
		xuid = get_player_xuid(event.target),
		distance = shot.target_distance,
		velocity = shot.target_velocity,
		ping = shot.target_ping,
		killed = not entity.is_alive(event.target),

		weapon = shot.target_weapon
	}

	data[missed and "miss" or "hit"] = {
		inaccuracy = event.inaccuracy,
		damage = event.damage,
		reason = event.reason,

		hitgroup = {
			id = event.hitgroup,
			name = hitgroup_names[event.hitgroup + 1]
		}
	}

	data.shot = {
		id = event.id,

		hitchance = shot.hit_chance,
		predicted_damage = shot.damage,
		predicted_hitgroup = {
			id = shot.hitgroup,
			name = hitgroup_names[shot.hitgroup + 1]
		},

		boosted = shot.boosted,
		high_priority = shot.high_priority,
		backtrack = shot.backtrack,
		extrapolated = shot.extrapolated,
		interpolated = shot.interpolated,
		teleported = shot.teleported,

		time = globals.realtime()
	}

	return data
end

local function LogShot(event, missed)
	if(shots[event.id]) then
		local mode = ui.get(send_mode)
		local shot = ShotToObject(event, missed)
		shots[event.id] = shot

		if(mode == send_modes[1]) then
			shots_to_send[#shots_to_send + 1] = json.parse(json.stringify(shot))
		elseif(socket ~= nil and mode == send_modes[2]) then
			client.delay_call(0.03, function()
				socket:send(EncapsulatePayload({ shot = shot, time = globals.realtime() }))
			end)
		end

		if(has(ui.get(settings), settings_options[1])) then
			if(missed) then
				color_print({ui.get(shot_miss_color)}, "missed ", shot.shot.predicted_hitgroup.name, ": "..shot.miss.reason, {255, 255, 255}, " » ", { 255, 105, 0 }, entity.get_player_name(event.target))
			else
				color_print({ui.get(shot_hit_color)}, "hit ", shot.hit.hitgroup.name, ": ", event.damage, " damage", {255, 255, 255}, " » ", { 255, 105, 0 }, entity.get_player_name(event.target))
			end
		end
	end
end

local function OnAimFire(e)

	if(banned_server == get_server_address()) then
		return
	end

	if(plist.get(e.target, "Force pitch")) then
		print("To ensure valid statistics, please disable any Lua scripts that interact with target pitches!")
		return
	end

	if(plist.get(e.target, "Force body yaw")) then
		print("To ensure valid statistics, please disable any Lua scripts that interact with target body yaws!")
		return
	end

	for _, var in ipairs(cvars) do
		local value = false

		if(var.type == "float") then
			value = var.var:get_float()
		elseif(var.type == "int") then
			value = var.var:get_int()
		end

		if(not var.validate(value)) then
			return
		end
	end

	shots[e.id] = e
	shots[e.id].location = vector(e.x, e.y, e.z)

	-- attach network information
	shots[e.id].ping = math.floor(client.latency() * 1000 + 0.5)
	shots[e.id].loss = get_loss()
	shots[e.id].choked = get_choke()

	-- attach current velocity
	local x, y, z = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
	shots[e.id].velocity = math.sqrt(x*x + y*y + z*z)

	-- attach weapon information
	local weapon = entity.get_player_weapon(entity.get_local_player())
	local weapon_idx = entity.get_prop(weapon, "m_iItemDefinitionIndex")
	shots[e.id].weapon = weapons[weapon_idx].console_name


	-- attach target ping
	shots[e.id].target_ping = entity.get_prop(entity.get_player_resource(), "m_iPing", e.target)

	-- attach target velocity
	local x, y, z = entity.get_prop(e.target, "m_vecVelocity")
	shots[e.id].target_velocity = math.sqrt(x*x + y*y + z*z)

	-- attach target distance
	local origin = {entity.get_origin(entity.get_local_player())}
	local target_origin = {entity.get_origin(e.target)}
	shots[e.id].target_distance = get_distance(origin[1], origin[2], origin[3], target_origin[1], target_origin[2], target_origin[3])

	-- attach target weapon information
	local target_weapon = entity.get_player_weapon(e.target)
	local target_weapon_idx = entity.get_prop(target_weapon, "m_iItemDefinitionIndex")
	shots[e.id].target_weapon = weapons[target_weapon_idx].console_name
end

local function OnAimMiss(e)
	if(shots[e.id]) then
		for k, impact in ipairs(impacts) do
			if(impact.tick == globals.tickcount()) then
				local aimed = (impact.origin - shots[e.id].location):angles()
				local landed = (impact.origin - impact.location):angles()

				e.inaccuracy = vector(aimed-landed):length2d()
				impacts[k] = nil
				break
			end
		end

		LogShot(e, true)
	end
end

local function OnAimHit(e)
	if(shots[e.id]) then
		LogShot(e, false)
	end
end

local function OnBulletImpact(e)
	local user = client.userid_to_entindex(e.userid)

	if user == entity.get_local_player() then

		-- reset impacts every 10
		if(#impacts > 10) then
			impacts = {}
		end

		impacts[#impacts + 1] = {
			tick = globals.tickcount(),
			origin = vector(client.eye_position()),
			location = vector(e.x, e.y, e.z)
		}
	end
end

local function OnPlayerDeath(e)
	if(client.userid_to_entindex(e.userid) == entity.get_local_player()) then
		if(socket ~= nil and ui.get(references.ragebot)) then
			socket:send(EncapsulatePayload({ death = { attacker = get_player_xuid(client.userid_to_entindex(e.attacker)), server = get_server_address() } }))

			-- this is necessary to ensure the shots that register after dying are sent
			client.delay_call(0.05, function()
				if(#shots_to_send > 0 and ui.get(send_mode) == send_modes[1]) then
					socket:send(EncapsulatePayload({ shots = shots_to_send, time = globals.realtime() }))
					shots_to_send = {}
				end
			end)
		end
	end
end

local function SendShots(e)
	if(ui.get(send_mode) == send_modes[1]) then
		if(socket ~= nil and #shots_to_send > 0) then
			socket:send(EncapsulatePayload({ shots = shots_to_send, time = globals.realtime() }))
			shots_to_send = {}
		end
	end
end

local function SetupCallbacks()
	client.set_event_callback("aim_fire", OnAimFire)
	client.set_event_callback("aim_hit", OnAimHit)
	client.set_event_callback("aim_miss", OnAimMiss)
	client.set_event_callback("bullet_impact", OnBulletImpact)
	client.set_event_callback("player_death", OnPlayerDeath)
	client.set_event_callback("round_end", SendShots)
	client.set_event_callback("begin_new_match", SendShots)
end

local function OnShotPublished(id, url, shot_id)
	local shot = shots[shot_id]

	if(shot.miss) then
		published_misses[#published_misses + 1] = { id = id, url = url, shot = shot }
	else
		published_hits[#published_hits + 1] = { id = id, url = url, shot = shot }
	end

	if(has(ui.get(settings), settings_options[2])) then
		if(not has(ui.get(settings), settings_options[1])) then
			color_print(missed and {ui.get(shot_miss_color)} or {ui.get(shot_hit_color)}, url)
		else
			color_print({ui.get(shot_link_color)}, url)
		end
	end
end

local retry_num = 4
local establishing = false

local established = false
local established_at = 0

local function SetupSocket(reset, bypass)
	if(socket ~= nil) then
		if(reset) then
			socket:close()
		else
			return
		end
	end

	if(not globals.mapname() and not bypass) then
		return
	end

	if(establishing) then
		return
	end

	establishing = true
	local _start = globals.realtime()
	local _end

	print("Connecting to HvHRank.me ...")
	websockets.connect(ep_ws, {
		open = function(ws)
			_end = globals.realtime()

			socket = ws
			establishing = false

			established = true
			established_at = globals.realtime()

			ws:send(EncapsulatePayload({
				kZ = database.read(db_token_key),
				pZ = "gs",
				vZ = version
			}))

			local now = globals.realtime()
			client.delay_call(5, function()
				if(established_at == now) then
					retry_num = 4
				end
			end)
		end,
		message = function(ws, data)
			data = DecodePayload(data)
			data = json.parse(data)

			if(globals.mapname() ~= nil) then
				if(data.server_banned and banned_server ~= get_server_address()) then
					Popup("Blacklisted server", string.format(
						"This server has been blacklisted by HvHRank.me.\n\n" ..
						"Reason:\n%s\n\n" ..
						"HvHRank.me will not process any data while you're playing on this server.\n"..
						"If this was a mistake and you own this server, contact us.",
						data.server_banned
					), "")

					banned_server = get_server_address()
				end
			end

			if(data.auth == "valid") then
				uid = data.uid
				SetupCallbacks()
				print(("Connected to HvHRank.me in %i ms! (%s-%i)"):format((_end - _start) * 1000, data.region, data.server))

				if(globals.mapname() ~= nil) then
					socket:send(EncapsulatePayload({ heartbeat = true, server = get_server_address() }))
				end
			else
				if(data.shot_inserted) then
					local id = data.shot_inserted[2]
					local shot_id = data.shot_inserted[1]
					local shot_url = ep.."/user/"..uid.."/gs/"..id

					OnShotPublished(id, shot_url, shot_id)
				end
			end
		end,
		close = function(ws, code, reason, was_clean)
			if(code == 1000 and was_clean and #reason > 0) then
				color_print({255, 0, 0}, "===========================================")
				color_print({255, 0, 0}, "= ", {255, 255, 255}, "You were disconnected from the ", {255, 255, 0}, "HvHRank.me", {255, 255, 255}, " servers:")
				color_print({255, 0, 0}, "= ", {255, 255, 255}, json.parse(DecodePayload(reason)))
				color_print({255, 0, 0}, "===========================================")
			else
				if(globals.mapname() ~= nil) then
					if(established) then
						print("Lost connection to HvHRank.me servers :( - WS#", code, " ", reason)
						established = false

						client.delay_call(0.05, function()
							local retry_in = retry_num
							client.delay_call(retry_in, SetupSocket)
							retry_num = retry_num * 2

							print("Retrying in ", retry_in, " seconds...")
						end)
					else
						print("Couldn't connect to HvHRank.me servers :( - WS#", code, " ", reason)
					end
				end
			end

			socket = nil
		end,
		error = function(ws, err)
			socket = nil

			client.delay_call(0.05, function()
				local retry_in = retry_num
				client.delay_call(retry_in, SetupSocket)
				retry_num = retry_num * 2

				print("Retrying in ", retry_in, " seconds...")
			end)
		end
	})
end

if(database.read(db_token_key) ~= nil) then
	SetupSocket()
else
	Popup("Setup your account", string.format(
		"Nice! You're running the HvHRank.me agent script :)\n\n"..
		"Now you need to link your account:\n"..
		"1. Go to https://%s/auth/login\n"..
		"2. Sign into your preferred Steam account (main is recommended)\n"..
		"3. Follow the steps on the setup page\n\n"..
		"You only need to do this once, even if you sign into another Steam account to play the game =)\n\n"..
		"Tip: You can copy the link by opening the console after pressing OK.",
		d
	))

	color_print({255, 0, 0}, "===========================================")
	color_print({255, 0, 0}, "= ", {255, 255, 255}, "GO TO THE FOLLOWING LINK TO SETUP ", {255, 255, 0}, "HVHRANK.ME")
	color_print({255, 0, 0}, "= ", {255, 255, 255}, "https://hvhrank.me/auth/login")
	color_print({255, 0, 0}, "===========================================")
end

client.set_event_callback("console_input", function(input)
	if(string.find(input, command)) then
		local token = string.gsub(input, command.." ", "")
		database.write(db_token_key, token)

		SetupSocket(true, true)
		return true
	end
end)

client.set_event_callback("shutdown", function()
	if(socket ~= nil) then
		socket:close()
	end
end)

local function DoHeartbeat()
	if(socket ~= nil and globals.mapname() ~= nil) then
		socket:send(EncapsulatePayload({ heartbeat = true, server = get_server_address() }))
	elseif(socket == nil and globals.mapname() ~= nil) then
		SetupSocket(false)
	elseif(socket ~= nil and globals.mapname() == nil) then
		socket:close()
	end

	client.delay_call(10, DoHeartbeat)
end

client.delay_call(10, DoHeartbeat)