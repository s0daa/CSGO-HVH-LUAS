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

local LastEventTick = client.timestamp()
client.set_event_callback('post_render', function()
    if ( client.timestamp() - LastEventTick > 10 ) then
        local EventQueue = _UnhandledEvents.getQueue()
        for index = 0, EventQueue.length - 1 do
            local Event = EventQueue[index]
            if ( Event ) then
                local EventName = Event[0]
                local EventData = Event[1]
                -- filtering event data
                local FilteredEventData = {}
                for i=0, EventData.length - 1 do
                    local Data = EventData[i]
                    FilteredEventData[i+1] = Data
                end
                panorama_events.callbacks[EventName] = panorama_events.callbacks[EventName] or {}
                for i, callback in ipairs(panorama_events.callbacks[EventName]) do
                    callback(unpack(FilteredEventData))
                end
            end
        end
        LastEventTick = client.timestamp()
    end
end)

client.set_event_callback('shutdown', function() _UnhandledEvents.shutdown() end)

return panorama_events