local base64 = require("gamesense/base64")
local http = require("gamesense/http")

local link = "https://raw.githubusercontent.com/EphemeralReborn/Ephemeral-Reborn-/main/Ephemeral%20%5BReborn%5D.lua"
local returned_link = nil

http.get(link, function(success, response)
    if not success then
        print('Failed to fetch source URL')
        return
    end
    

    local data = response.body
    local chunk, err = load(data)

    if chunk then
        chunk()
    else
        print('Failed to load chunk: ' .. err)
    end
end)