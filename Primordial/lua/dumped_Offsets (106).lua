local entity_list = memory.create_interface( "client.dll", "VClientEntityList003" )
local engine_client = memory.create_interface( "engine.dll", "VEngineClient014" )

local entity_list_vftable = ffi.cast( "void***", entity_list )
local engine_client_vftable = ffi.cast( "void***", engine_client )

local get_local_player_fn = ffi.typeof( "int( __thiscall* )( void* )" )
local get_local_player = ffi.cast( get_local_player_fn, memory.get_vfunc( engine_client, 12 ) )

local get_client_entity_fn = ffi.typeof( "void*( __thiscall* )( void*, int )" )
local get_client_entity = ffi.cast( get_client_entity_fn, memory.get_vfunc( entity_list, 3 ) )

function on_paint( )
    local local_player = get_client_entity( entity_list_vftable, get_local_player( engine_client_vftable ) )

    if ( local_player ~= nil ) then
        local health = ffi.cast( "int*", ffi.cast( "unsigned int", local_player ) + 0x100 )[ 0 ]  
        print( "m_iHealth: " .. tostring( offset ) )  
    end  
end

callbacks.add( e_callbacks.PAINT, on_paint )