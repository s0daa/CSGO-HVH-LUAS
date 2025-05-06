-- Reference
local fakeduck = ui.reference("RAGE", "Other", "Duck peek assist")
local doubleTap = ui.reference("RAGE", "Other", "Double Tap");

-- UI Crap
local disableOnFakeDuck = ui.new_checkbox("RAGE", "Other", "Disable Double Tap On Fake Duck")
local disableOnNades = ui.new_checkbox("RAGE", "Other", "Disable Double Tap On Grenades")
local disableOnRevolver = ui.new_checkbox("RAGE", "Other", "Disable Double Tap On Revolver")
local disableOnMiss = ui.new_checkbox("RAGE", "Other", "Disable Double Tap On Miss")
local missShots = ui.new_slider("RAGE", "Other", 'Missed Shots', 0, 10, 1, true);
local resetDelay = ui.new_slider("RAGE", "Other", 'Missed Shots Reset', 1, 60, 1, true, 's');

-- Cache
local missed = 0;
local nextReset = 0;
local prev_mode;

local hotkey_modes = {
    [0] = "always on",
    [1] = "on hotkey",
    [2] = "toggle",
    [3] = "off hotkey"
}

-- Disables double tap while restoring the state thanks @sapphyrus
local function disableDoubleTap()
    if ui.get(doubleTap) then
        local _, mode = ui.get(doubleTap)
        if prev_mode == nil then
            prev_mode = mode
        end
        ui.set(doubleTap, hotkey_modes[mode == 3 and 1 or 3])
    end
end

client.set_event_callback("paint", function()
    local entindex = entity.get_local_player()
    local active_weapon = entity.get_prop(entindex, "m_hActiveWeapon")
    if entindex == nil or not entity.is_alive(entindex) or active_weapon == nil then
        return
    end
    local item = bit.band((entity.get_prop(active_weapon, "m_iItemDefinitionIndex")), 0xFFFF);
    if ((ui.get(disableOnMiss) and missed >= ui.get(missShots)) or
            (ui.get(disableOnFakeDuck) and ui.get(fakeduck)) or
            (ui.get(disableOnNades) and (item > 42 and item < 49) or
            (ui.get(disableOnRevolver) and item == 64))
    ) then
        disableDoubleTap();
    elseif (prev_mode ~= nil) then
        ui.set(doubleTap, hotkey_modes[prev_mode]);
        prev_mode = nil;
    end
    if (nextReset < globals.realtime()) then
        missed = 0;
        nextReset = nextReset + ui.get(resetDelay);
    end
end)

client.set_event_callback("shutdown", function()
    -- reset on script reload
    prev_mode = nil;
end)

client.set_event_callback("aim_miss", function(_)
    missed = missed + 1;
end);