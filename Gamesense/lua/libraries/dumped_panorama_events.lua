slot0 = panorama.loadstring([[
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
slot2 = client.timestamp()

client.set_event_callback("post_render", function ()
	if client.timestamp() - uv0 > 10 then
		for slot4 = 0, uv1.getQueue().length - 1 do
			if slot0[slot4] then
				slot6 = slot5[0]
				slot8 = {
					[slot12 + 1] = slot7[slot12]
				}

				for slot12 = 0, slot5[1].length - 1 do
				end

				uv2.callbacks[slot6] = uv2.callbacks[slot6] or {}

				for slot12, slot13 in ipairs(uv2.callbacks[slot6]) do
					slot13(unpack(slot8))
				end
			end
		end

		uv0 = client.timestamp()
	end
end)
client.set_event_callback("shutdown", function ()
	uv0.shutdown()
end)

return {
	callbacks = {},
	register_event = function (slot0, slot1)
		uv0.register(slot0)

		uv1.callbacks[slot0] = uv1.callbacks[slot0] or {}

		table.insert(uv1.callbacks[slot0], slot1)

		return slot1
	end,
	unregister_event = function (slot0, slot1)
		uv0.unRegister(slot0)

		uv1.callbacks[slot0] = uv1.callbacks[slot0] or {}

		for slot5, slot6 in ipairs(uv1.callbacks[slot0]) do
			if slot6 == slot1 then
				table.remove(uv1.callbacks[slot0], slot5)
			end
		end
	end
}
