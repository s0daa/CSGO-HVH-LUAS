local file = require "File System"
local json = require "JSON"

local M = {}

local function readfile(name)
	local file_p = file.open(name, "r", "GAME")

	if (file.exists(name, "GAME")) then
		return file_p:read()
	end

	file_p:close()
end

local function writefile(name, data)
	local file_p = file.open(name, "wb", "GAME")
	file_p:write(data)
	file_p:close()
end

local dir = "Helper"
if not file.exists(dir, "GAME") then
	file.create_directory(dir, "GAME")
end

local path = dir .. "\\" .. "database.json"
local db = json.parse(readfile(path) or "[]") or {}

function M.read(key)
	return db[key]
end

function M.write(key, value)
	db[key] = value
	writefile(path, json.encode(db))
end

function M.flush()
	for key in pairs(db) do
		db[key] = nil
	end
end

return M