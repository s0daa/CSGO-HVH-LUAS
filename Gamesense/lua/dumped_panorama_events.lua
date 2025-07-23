-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = panorama.loadstring("    let RegisteredEvents = {};\n    let EventQueue = [];\n\n    function _registerEvent(event){\n        if ( typeof RegisteredEvents[event] != 'undefined' ) return;\n        RegisteredEvents[event] = $.RegisterForUnhandledEvent(event, (...data)=>{\n            EventQueue.push([event, data]);\n        })\n    }\n\n    function _UnRegisterEvent(event){\n        if ( typeof RegisteredEvents[event] == 'undefined' ) return;\n        $.UnregisterForUnhandledEvent(event, RegisteredEvents[event]);\n        delete RegisteredEvents[event];\n    }\n\n    function _getEventQueue(){\n        let Queue = EventQueue;\n        EventQueue = [];\n        return Queue;\n    }\n\n    function _shutdown(){\n        for ( event in RegisteredEvents ) {\n            _UnRegisterEvent(event);\n        }\n    }\n\n    return  {\n        register: _registerEvent,\n        unRegister: _UnRegisterEvent,\n        getQueue: _getEventQueue,\n        shutdown: _shutdown\n    }\n")()
local var_0_1 = {
	callbacks = {}
}

function var_0_1.register_event(arg_1_0, arg_1_1)
	var_0_0.register(arg_1_0)

	var_0_1.callbacks[arg_1_0] = var_0_1.callbacks[arg_1_0] or {}

	table.insert(var_0_1.callbacks[arg_1_0], arg_1_1)

	return arg_1_1
end

function var_0_1.unregister_event(arg_2_0, arg_2_1)
	var_0_0.unRegister(arg_2_0)

	var_0_1.callbacks[arg_2_0] = var_0_1.callbacks[arg_2_0] or {}

	for iter_2_0, iter_2_1 in ipairs(var_0_1.callbacks[arg_2_0]) do
		if iter_2_1 == arg_2_1 then
			table.remove(var_0_1.callbacks[arg_2_0], iter_2_0)
		end
	end
end

local var_0_2 = client.timestamp()

client.set_event_callback("post_render", function()
	if client.timestamp() - var_0_2 > 10 then
		local var_3_0 = var_0_0.getQueue()

		for iter_3_0 = 0, var_3_0.length - 1 do
			local var_3_1 = var_3_0[iter_3_0]

			if var_3_1 then
				local var_3_2 = var_3_1[0]
				local var_3_3 = var_3_1[1]
				local var_3_4 = {}

				for iter_3_1 = 0, var_3_3.length - 1 do
					local var_3_5 = var_3_3[iter_3_1]

					var_3_4[iter_3_1 + 1] = var_3_5
				end

				var_0_1.callbacks[var_3_2] = var_0_1.callbacks[var_3_2] or {}

				for iter_3_2, iter_3_3 in ipairs(var_0_1.callbacks[var_3_2]) do
					iter_3_3(unpack(var_3_4))
				end
			end
		end

		var_0_2 = client.timestamp()
	end
end)
client.set_event_callback("shutdown", function()
	var_0_0.shutdown()
end)

return var_0_1
