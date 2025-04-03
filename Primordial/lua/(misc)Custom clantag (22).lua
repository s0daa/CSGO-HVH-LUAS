local clan_tag = menu.add_text_input( "clan", "clantag" )
local clan_tag_delay = menu.add_slider( "clan", "delay", 1, 100 )

local send_clan_tag_addr = memory.find_pattern( "engine.dll", "53 56 57 8B DA 8B F9 FF 15" )
local send_clan_tag = ffi.cast( "void( __fastcall* )( const char*, const char* )", send_clan_tag_addr )

stored_cur_time = 0
stored_index = -1
index = 1
cur_tag = ""
prev_tag = ""
stored_clan_tag = ""
table = { }

function get_table_length( table )
    local length = 0

    for i in pairs( table ) do 
        length = length + 1 
    end

    return length
end

function split_str_into_chars( str )
    local table = { }

    for i = 1, #str do
        table[ i ] = str:sub( i, i ) 
    end

    return table
end

function on_paint(  )
    local local_plyr = entity_list.get_local_player( )

    if not local_plyr then
        stored_cur_time = -1
        return
    end

    -- we changed, reset
    if stored_clan_tag ~= clan_tag:get( ) and clan_tag:get( ) ~= "" then
        index = 0
        cur_tag = ""
        table = split_str_into_chars( clan_tag:get( ) )
        stored_clan_tag = clan_tag:get( )
    end

    -- update
    if global_vars.cur_time( ) - stored_cur_time > clan_tag_delay:get( ) * 0.01 then
        index = index + 1
        stored_cur_time = global_vars.cur_time( )
    end

    -- we're at the end, start over
    if index > get_table_length( table ) then
        cur_tag = ""
        index = 1
    end
    
    -- add the next char to our str
    if stored_index ~= index then
        cur_tag = cur_tag .. ( table[ index ] or "" )
        stored_index = index
    end

    -- send our clantag if it's different
    if prev_tag ~= cur_tag then
        send_clan_tag( cur_tag, cur_tag )
        prev_tag = cur_tag
    end
end

callbacks.add( e_callbacks.PAINT, on_paint )