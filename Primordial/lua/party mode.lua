local function on_paint()
    cvars.sv_party_mode:set_int(1)
end
local function on_unload()
    cvars.sv_party_mode:set_int(0)
end

callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.SHUTDOWN, on_unload)