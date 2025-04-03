local checkbox = menu.add_checkbox("Teleport", "Teleport on key", false)
local tpb = checkbox:add_keybind("Teleport");


local function on_paint()
    if tpb:get() then
        exploits.force_uncharge()
    end
end

callbacks.add(e_callbacks.RUN_COMMAND, on_paint)