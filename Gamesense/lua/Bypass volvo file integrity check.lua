--- Description
--- What actually this code do
--- In the VFileSystem017 we have a function which return bool and alowing us to pass on Valve DS with index 128 that function returning this[56]
--- We just set this var to 1 each frame


local ffi = require"ffi"
local client_delay_call, ui_get = client.delay_call, ui.get

local enabled = ui.new_checkbox("MISC", "Miscellaneous", "Load files bypass")
local sv_pure_bypass = ui.reference("MISC", "Miscellaneous", "Disable sv_pure")

local file_system = ffi.cast("int*", client.create_interface("filesystem_stdio.dll", "VFileSystem017") or error("VFileSystem017 not found"))

ui.set_callback(enabled, function()
	if ui.get(enabled) then
		ui.set(sv_pure_bypass, true)
		set_files_is_checked_porperly()
	end
end)

function set_files_is_checked_porperly()
	if ui_get(enabled) then
		file_system[56] = 1
		client_delay_call(0.02, set_files_is_checked_porperly )
	end
end

-- prevents kick on cfg switching if in another one hasn't got enabled bypass
local enabled_cached = false

client.set_event_callback("pre_config_load", function(e)
	enabled_cached = ui_get(enabled)
end)

client.set_event_callback("post_config_load", function(e)
	if enabled_cached then
		ui.set(sv_pure_bypass, true)
		ui.set(enabled, true)
	end
end)