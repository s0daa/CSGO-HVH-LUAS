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

-- #region - Vars
local rage, misc, visuals = {}, {}, {}
local vars, refs, textures = {}, {}, {}

--#region Resolver
local resolver = ui.new_checkbox("RAGE", "Other", "Jitter resolver")

rage.resolver = {
	records = {},
	work = (function ()
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
	restore = (function ()
		local self = rage.resolver
		for i = 1, 64 do
			plist.set(i, "Force body yaw", false)
		end
		self.records = {}
	end),
	run = (function (self)
		vars.rage.resolver:set_event("net_update_end", self.work)
		vars.rage.resolver:set_callback(function (this)
			if not this.value then self.restore() end
		end)
		defer(self.restore)
	end)
}