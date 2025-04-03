local fake_duck = menu.find( "antiaim", "main", "general", "fake duck" )
local fake_duck_hitchance = menu.add_slider( "fake duck hitchance", "hitchance", 0, 100 )

local function on_hitscan( ctx, cmd, unpredicted_data )
    if fake_duck[ 2 ]:get( ) then
        ctx:set_hitchance( fake_duck_hitchance:get( ) )
    end
end

callbacks.add( e_callbacks.HITSCAN, on_hitscan )