---@diagnostic disable: undefined-global
local json = require("primordial/JSON Library.97")
local httpFactory = require("primordial/Lightweight HTTP Library.46")
local command = require("primordial/command callback.510")
local panorama = require('primordial/panorama-library.248')
local http = httpFactory.new({
    task_interval = 0.3, -- polling intervals
    enable_debug = false, -- print http requests to the console
    timeout = 10 -- request expiration time
})

local _UnhandledEvents = panorama.loadstring([[
    let RegisteredEvents = {};
    let EventQueue = [];
    function _registerEvent(event){
        if ( typeof RegisteredEvents[event] != 'undefined' ) return;
        RegisteredEvents[event] = $.RegisterForUnhandledEvent(event, (...data)=>{
            EventQueue.push([event, data]);
        })
    }
    function _UnRegisterEvent(event){
        if ( typeof RegisteredEvents[event] == 'undefined' ) return;
        $.UnregisterForUnhandledEvent(event, RegisteredEvents[event]);
        delete RegisteredEvents[event];
    }
    function _getEventQueue(){
        let Queue = EventQueue;
        EventQueue = [];
        return Queue;
    }
    function _shutdown(){
        for ( event in RegisteredEvents ) {
            _UnRegisterEvent(event);
        }
    }
    return  {
        register: _registerEvent,
        unRegister: _UnRegisterEvent,
        getQueue: _getEventQueue,
        shutdown: _shutdown
    }
]])()

local panorama_events = {callbacks={}}

function panorama_events.register_event(event, callback)
    _UnhandledEvents.register(event)
    panorama_events.callbacks[event] = panorama_events.callbacks[event] or {}
	table.insert(panorama_events.callbacks[event], callback)
	return callback
end

function panorama_events.unregister_event(event, callback)
    _UnhandledEvents.unRegister(event)
    panorama_events.callbacks[event] = panorama_events.callbacks[event] or {}
    for i, func in ipairs(panorama_events.callbacks[event]) do
        if ( func == callback ) then
            table.remove(panorama_events.callbacks[event], i)
        end
    end
end
local js_api = panorama.loadstring([[
	var _GetTimestamp = function() {
		return Date.now()/1000
	}

	var _FormatTimestamp = function(timestamp) {
		var date = new Date(timestamp * 1000)

		return `${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} ${date.getHours()}:${date.getMinutes()}`
	}

	return {
		get_timestamp: _GetTimestamp,
		format_timestamp: _FormatTimestamp
	}
]])()
local LastEventTick = js_api.get_timestamp()
callbacks.add(e_callbacks.PAINT, function()
    if ( js_api.get_timestamp() - LastEventTick > 10 ) then
        local EventQueue = _UnhandledEvents.getQueue()
        for index = 0, #EventQueue - 1 do
            local Event = EventQueue[index]
            if ( Event ) then
                local EventName = Event[0]
                local EventData = Event[1]
                -- filtering event data
                local FilteredEventData = {}
                for i=0, #EventData - 1 do
                    local Data = EventData[i]
                    FilteredEventData[i+1] = Data
                end
                panorama_events.callbacks[EventName] = panorama_events.callbacks[EventName] or {}
                for i, callback in ipairs(panorama_events.callbacks[EventName]) do
                    callback(unpack(FilteredEventData))
                end
            end
        end
        LastEventTick = js_api.get_timestamp()
    end
end)

callbacks.add(e_callbacks.SHUTDOWN, function() _UnhandledEvents.shutdown() end)

local menu_callbacks = {}

function menu.set_callback(item_type, name, item, func, cond)
	callbacks.add(e_callbacks.PAINT, function()
		if cond == nil then
			cond = function()
				return {
					first = true,
					second = true
				}
			end
		end

		if menu_callbacks[name] == nil then
			menu_callbacks[name] = {
				itmes = {}, data = {}, clicked_value = 0
			}
		end

		if item_type == "multi_selection" then
			if item ~= nil then
				local items = item:get_items()

				for key, value in ipairs(items) do
					if menu_callbacks[name].data[value] == nil then
						menu_callbacks[name].data[value] = 0
					end

					if item:get(value) and cond() then
						menu_callbacks[name].data[value] = math.min(#items, menu_callbacks[name].data[value] + 1)
					else
						menu_callbacks[name].data[value] = math.max(0, menu_callbacks[name].data[value] - 1)
					end

					if menu_callbacks[name].data[value] == 2 then
						func()
					end
				end
			end
		elseif item_type == "checkbox" then
			if item:get() and cond().first then
				menu_callbacks[name].clicked_value = math.min(3, menu_callbacks[name].clicked_value + 1)
			elseif not item:get() and cond().second then
				menu_callbacks[name].clicked_value = math.max(0, menu_callbacks[name].clicked_value - 1)
			end

			if menu_callbacks[name].clicked_value == 2 then
				func()
			end
		elseif item_type == "selection" or item_type == "list" or item_type == "slider" then
			local value = item:get()

			if menu_callbacks[name].clicked_value and menu_callbacks[name].clicked_value == value then
				goto skip
			end

			if cond().first then
				func()
			end

			menu_callbacks[name].clicked_value = value
			::skip::
		end
	end)
end

local version_spoof = menu.add_checkbox('Misc', 'Spoof latest client');

local version = ffi.cast("uint32_t**", ffi.cast("char*", memory.find_pattern("engine.dll", "FF 35 ? ? ? ? 8D 4C 24 10"))+2)[0][0]
local function update()
    if not version_spoof:get() then
      return
    end

    http:get("https://api.steampowered.com/ISteamApps/UpToDateCheck/v1/?appid=730&version=" .. version, function(response)
        if not response:success() or response.status ~= 200 then
            return
        end

        local data = json.parse(response.body)
        if data.response.required_version ~= nil then
            ffi.cast("uint32_t**", ffi.cast("char*", memory.find_pattern("engine.dll", "FF 35 ? ? ? ? 8D 4C 24 10"))+2)[0][0]=data.response.required_version
        end
    end)
end

update()
menu.set_callback("checkbox", "version_spoof", version_spoof, update)
callbacks.add(e_callbacks.EVENT, update, "cs_win_panel_match")
callbacks.add(e_callbacks.EVENT, update, "cs_game_disconnected")
panorama_events.register_event('CSGOShowMainMenu', update);