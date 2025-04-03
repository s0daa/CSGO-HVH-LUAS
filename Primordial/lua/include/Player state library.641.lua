local lib = require("primordial/Player state library.641")

local function test()
    local player_state = lib.get_state()

    if player_state == 1 then
        print("Standing")
    elseif player_state == 2 then
        print("Running")
    elseif player_state == 3 then
        print("Slowwalk")
    elseif player_state == 4 then
        print("Crouch")
    elseif player_state == 5 then
        print("Jump")
    elseif player_state == 6 then
        print("Jump-Crouch")
    end
end

callbacks.add(e_callbacks.PAINT, function()
    test()
end)