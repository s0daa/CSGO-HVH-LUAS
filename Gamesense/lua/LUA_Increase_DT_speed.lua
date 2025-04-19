local ticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
local dt_key = ui.new_checkbox("AA", "Other", "dangerous dt")
local function run_dt()
    if ui.get(dt_key) then
        ui.set(ticks, 18)
    else
        ui.set(ticks, 16)
    end
end

client.set_event_callback("paint", run_dt)