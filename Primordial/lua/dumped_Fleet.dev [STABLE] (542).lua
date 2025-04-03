--[[
    #section: info
    CodeStyle: doublesexual case[sName = string, iName = int, bName = boolean and etc...]
    Author: @gamesense_agent/hoodrich
    Build: DEBUG
    Log: Fixed AB errors, Reworked AB, Added Trash warmup preset, fixed bugs
    Ver: 1.1
]]


--[[
    #section: huita
]]

local function VTableBind(mod, face, n, type)
	local iface = memory.create_interface(mod, face) or error(face .. ": invalid interface")
	local instance = memory.get_vfunc(iface, n) or error(index .. ": invalid index")
	local success, typeof = pcall(ffi.typeof, type)
	if not success then
		error(typeof, 2)
	end
	local fnptr = ffi.cast(typeof, instance) or error(type .. ": invalid typecast")
	return function(...)
		return fnptr(tonumber(ffi.cast("void***", iface)), ...)
	end
end

local data, cfg, misc, rage, ui, callback, _DEBUG, fleet, console, api, httpFactory, ffi, clip_system, base64, json, helpers, panorama = { }, { }, { }, { }, { }, { }, true, { }, { }, require( 'primordial/Extended API.493' ), require( 'primordial/Lightweight HTTP Library.46' ), require( 'ffi' ), { }, { }, require("primordial/JSON Library.97"), { }, require( 'primordial/panorama-library.248' )
local http = httpFactory.new({task_interval = 0.3, enable_debug = false, timeout = 10})

--[[
    #section: anims
]]

local animations = {data = {}}

animations.lerp = function(start, end_pos, time)
    if type(start) == 'userdata' then
        local color_data = {0, 0, 0, 0}

        for i, color_key in ipairs({'r', 'g', 'b', 'a'}) do
            color_data[i] = animations.lerp(start[color_key], end_pos[color_key], time)
        end

        return color(unpack(color_data))
    end

    return (end_pos - start) * (globals.frame_time() * time * 175) + start
end

animations.new = function(name, value, time)
    if animations.data[name] == nil then
        animations.data[name] = value
    end

    animations.data[name] = animations.lerp(animations.data[name], value, time)

    return animations.data[name]
end


--[[
    #section: clipboard
]]

clip_system.vgui_sys = 'VGUI_System010'
clip_system.vgui2 = 'vgui2.dll'
clip_system.native_GetClipboardTextCount = VTableBind(clip_system.vgui2,clip_system.vgui_sys, 7, "int(__thiscall*)(void*)")
clip_system.native_SetClipboardText = VTableBind(clip_system.vgui2,clip_system.vgui_sys, 9, "void(__thiscall*)(void*, const char*, int)")
clip_system.native_GetClipboardText = VTableBind(clip_system.vgui2,clip_system.vgui_sys, 11, "int(__thiscall*)(void*, int, const char*, int)")

clip_system.get = function( )
    local len = clip_system.native_GetClipboardTextCount( )
    if ( len > 0 ) then
        local char_arr = ffi.typeof("char[?]")( len )
        clip_system.native_GetClipboardText( 0, char_arr, len )
        return ffi.string( char_arr, len - 1 )
    end
end
clip_system.set = function( text )
    text = tostring( text )
    clip_system.native_SetClipboardText( text, string.len( text ) )
end

--[[
    #section: base64
]]

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

base64.encode = function(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

base64.decode = function(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end

--[[
    #section: ffi
]]


--[[
    #section shit 
]]

helpers = {
    set_visible = function( sGroup, bCondition )
        if type(sGroup) ~= 'string' then return end
        if sGroup == nil or bCondition == nil then return end
        menu.set_group_visibility( string.format( '[ %s ]', sGroup ), bCondition )
    end,

    state_to_text = function(state)
        if state == 1 then
            return "Stand"
        elseif state == 2 then
            return "Move"
        elseif state == 3 then
            return "SlowWalk"
        elseif state == 4 then
            return "Crouch"
        elseif state == 5 then
            return "Air"
        else
            return "UNKNOWN"
        end
        return "Air"
    end,
}

user_data = {
    user = user.name,
    uid = user.uid,
    build = "STABLE",
    version = "1.1",
    default_cfg = nil,
    author = nil,
    x = render.get_screen_size().x * 0.5,
    y = render.get_screen_size().y * 0.5,
    main_font = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE),
}


refs = {
    side_stand = menu.find("antiaim","main", "desync","side#stand"),
    llimit_stand = menu.find("antiaim","main", "desync","left amount#stand"),
    rlimit_stand = menu.find("antiaim","main", "desync","right amount#stand"),
    side_move = menu.find("antiaim","main", "desync","side#move"),
    llimit_move = menu.find("antiaim","main", "desync","left amount#move"),
    rlimit_move = menu.find("antiaim","main", "desync","right amount#move"),
    side_sw = menu.find("antiaim","main", "desync","side#slow walk"),
    llimit_sw = menu.find("antiaim","main", "desync","left amount#slow walk"),
    rlimit_sw = menu.find("antiaim","main", "desync","right amount#slow walk"),
    fl_ticks = menu.find("antiaim", "main", "fakelag", "amount"),
    sw_key = unpack(menu.find("misc", "main", "movement", "slow walk")),
    yaw_base = menu.find("antiaim", "main", "angles", "yaw base"),
    yaw_add = menu.find("antiaim", "main", "angles", "yaw add"),
    jitter_mode = menu.find("antiaim", "main", "angles", "jitter mode"),
    jitter_type = menu.find("antiaim", "main", "angles", "jitter type"),
    jitter_add = menu.find("antiaim", "main", "angles", "jitter add"),
    pitch = menu.find("antiaim", "main", "angles", "pitch"),
    dt = menu.find("aimbot","general","exploits","doubletap","enable"),
    hs = menu.find("aimbot","general","exploits","hideshots","enable"),
    hitbox_override = menu.find("aimbot", "auto", "target overrides", "force hitbox"),
    safepoint_ovride = menu.find("aimbot", "auto", "target overrides", "force safepoint")
}



--[[
    #section: UI
]]

ui.handler = {
    init = function()
        ui.selector = menu.add_list( '[ MENU ]', '[ fleet ] menu selector', { '[ GLOBALS ]', '[ RAGE ]', '[ ANTI-AIM ]', '[ MISC ]', "[ CFG PANEL ]" })
        menu.set_group_column(                          '[ MENU ]', 1 )
        --[[GLOBALS]]
        ui.globals_text = menu.add_text( '[ GLOBALS ]', string.format( 'Welcome %s [%s]!', user_data.user, user_data.uid ) )
        ui.globals_text2 = menu.add_text( '[ GLOBALS ]', string.format( 'Build: %s', user_data.build ) )
        ui.globals_text3 = menu.add_text( '[ GLOBALS ]', string.format( 'Version: %s', user_data.version ) )
        ui.admin_name = menu.add_text_input( '[ GLOBALS - ADMIN ]', "input user name" )
        menu.set_group_column(             '[ GLOBALS ]', 2)
        menu.add_button( '[ GLOBALS ]', "DISCORD", function( ) clip_system.set( 'https://discord.gg/65xaP4T6B3' ) fleet.print( true, "link copied", 255, 255, 255 ) end)
        menu.add_button( '[ GLOBALS ]', "SCRIPT PAGE", function( ) clip_system.set( 'https://community.primordial.dev/resources/542/' ) fleet.print( true, "link copied", 255, 255, 255 ) end)
        menu.add_button( '[ GLOBALS - ADMIN ]', "DECODE USER", function() fleet.print( true, base64.decode(clip_system.get()), 255, 255, 255 ) end)
        menu.add_button( '[ GLOBALS - ADMIN ]', "ENCODE USER", function() clip_system.set(base64.encode(ui.admin_name:get())) fleet.print( true, base64.encode(ui.admin_name:get()), 255, 255, 255 ) end)
        --[[RAGE]]
        ui.rage_fast_weapon_switch = menu.add_checkbox( '[ RAGE ]', 'Fast Weapon Switch', false )
        menu.set_group_column(                          '[ RAGE ]', 2 )
        menu.set_group_column(                          '[ CFG PANEL ]', 2 )
        --[[AA]]
        --[[STAND]]
        ui.aa_selector = menu.add_selection(          '[ ANTI-AIM ]', 'State', {"STAND", "RUN", "SLOWWALK", "CROUCH", "AIR"} ) menu.set_group_column( '[ ANTI-AIM ]', 1 )
        ui.aa_anti_brute = menu.add_checkbox(         '[ ANTI-AIM ]', "Enable smart anti-brute", false)
        ui.trash_aa = menu.add_checkbox(              '[ ANTI-AIM ]', 'Trash AA preset on warmup', false)
        ui.aa_stand_yaw_add_left = menu.add_slider(   '[ ANTI-AIM - STAND ]', "[ S ] yaw add left", -180, 180)
        ui.aa_stand_yaw_add_right = menu.add_slider(  '[ ANTI-AIM - STAND ]', "[ S ] yaw add right", -180, 180)
        ui.aa_stand_jitter_mode = menu.add_selection( '[ ANTI-AIM - STAND ]', "[ S ] jitter mode", {"none", "static", 'random'} )
        ui.aa_stand_jitter_type = menu.add_selection( '[ ANTI-AIM - STAND ]', "[ S ] jitter type", {'offset', 'center'} )
        ui.aa_stand_jitter_add = menu.add_slider(     '[ ANTI-AIM - STAND ]', '[ S ] jitter add', -180, 180 )
        menu.add_separator(                           '[ ANTI-AIM - STAND ]' )
        ui.aa_stand_desync_side = menu.add_selection( '[ ANTI-AIM - STAND ]', '[ S ] side', {'none', 'left', 'right', 'jitter', 'peek fake', 'peek real', 'body sway'} )
        ui.aa_stand_left_amount = menu.add_slider(    '[ ANTI-AIM - STAND ]', '[ S ] left amount', 0, 100)
        ui.aa_stand_right_amount = menu.add_slider(   '[ ANTI-AIM - STAND ]', '[ S ] right amount', 0, 100)
        menu.set_group_column(                        '[ ANTI-AIM - STAND ]', 2 )
        --[[RUN]]
        ui.aa_run_yaw_add_left = menu.add_slider(   '[ ANTI-AIM - RUN ]', "[ R ] yaw add left", -180, 180)
        ui.aa_run_yaw_add_right = menu.add_slider(  '[ ANTI-AIM - RUN ]', "[ R ] yaw add right", -180, 180)
        ui.aa_run_jitter_mode = menu.add_selection( '[ ANTI-AIM - RUN ]', "[ R ] jitter mode", {"none", "static", 'random'} )
        ui.aa_run_jitter_type = menu.add_selection( '[ ANTI-AIM - RUN ]', "[ R ] jitter type", {'offset', 'center'} )
        ui.aa_run_jitter_add = menu.add_slider(     '[ ANTI-AIM - RUN ]', '[ R ] jitter add', -180, 180 )
        menu.add_separator(                         '[ ANTI-AIM - RUN ]' )
        ui.aa_run_desync_side = menu.add_selection( '[ ANTI-AIM - RUN ]', '[ R ] side', {'none', 'left', 'right', 'jitter', 'peek fake', 'peek real', 'body sway'} )
        ui.aa_run_left_amount = menu.add_slider(    '[ ANTI-AIM - RUN ]', '[ R ] left amount', 0, 100)
        ui.aa_run_right_amount = menu.add_slider(   '[ ANTI-AIM - RUN ]', '[ R ] right amount', 0, 100)
        menu.set_group_column(                      '[ ANTI-AIM - RUN ]', 2 )
        --[[SW]]
        ui.aa_sw_yaw_add_left = menu.add_slider(   '[ ANTI-AIM - SW ]', "[ SW ] yaw add left", -180, 180)
        ui.aa_sw_yaw_add_right = menu.add_slider(  '[ ANTI-AIM - SW ]', "[ SW ] yaw add right", -180, 180)
        ui.aa_sw_jitter_mode = menu.add_selection( '[ ANTI-AIM - SW ]', "[ SW ] jitter mode", {"none", "static", 'random'} )
        ui.aa_sw_jitter_type = menu.add_selection( '[ ANTI-AIM - SW ]', "[ SW ] jitter type", {'offset', 'center'} )
        ui.aa_sw_jitter_add = menu.add_slider(     '[ ANTI-AIM - SW ]', '[ SW ] jitter add', -180, 180 )
        menu.add_separator(                        '[ ANTI-AIM - SW ]' )
        ui.aa_sw_desync_side = menu.add_selection( '[ ANTI-AIM - SW ]', '[ SW ] side', {'none', 'left', 'right', 'jitter', 'peek fake', 'peek real', 'body sway'} )
        ui.aa_sw_left_amount = menu.add_slider(    '[ ANTI-AIM - SW ]', '[ SW ] left amount', 0, 100)
        ui.aa_sw_right_amount = menu.add_slider(   '[ ANTI-AIM - SW ]', '[ SW ] right amount', 0, 100)
        menu.set_group_column(                     '[ ANTI-AIM - SW ]', 2 )
        --[[CROUCH]]
        ui.aa_crouch_yaw_add_left = menu.add_slider(   '[ ANTI-AIM - CROUCH ]', "[ C ] yaw add left", -180, 180)
        ui.aa_crouch_yaw_add_right = menu.add_slider(  '[ ANTI-AIM - CROUCH ]', "[ C ] yaw add right", -180, 180)
        ui.aa_crouch_jitter_mode = menu.add_selection( '[ ANTI-AIM - CROUCH ]', "[ C ] jitter mode", {"none", "static", 'random'} )
        ui.aa_crouch_jitter_type = menu.add_selection( '[ ANTI-AIM - CROUCH ]', "[ C ] jitter type", {'offset', 'center'} )
        ui.aa_crouch_jitter_add = menu.add_slider(     '[ ANTI-AIM - CROUCH ]', '[ C ] jitter add', -180, 180 )
        menu.add_separator(                            '[ ANTI-AIM - CROUCH ]' )
        ui.aa_crouch_desync_side = menu.add_selection( '[ ANTI-AIM - CROUCH ]', '[ C ] side', {'none', 'left', 'right', 'jitter', 'peek fake', 'peek real', 'body sway'} )
        ui.aa_crouch_left_amount = menu.add_slider(    '[ ANTI-AIM - CROUCH ]', '[ C ] left amount', 0, 100)
        ui.aa_crouch_right_amount = menu.add_slider(   '[ ANTI-AIM - CROUCH ]', '[ C ] right amount', 0, 100)
        menu.set_group_column(                         '[ ANTI-AIM - CROUCH ]', 2 )
        --[[AIR]]
        ui.aa_air_yaw_add_left = menu.add_slider(   '[ ANTI-AIM - AIR ]', "[ A ] yaw add left", -180, 180)
        ui.aa_air_yaw_add_right = menu.add_slider(  '[ ANTI-AIM - AIR ]', "[ A ] yaw add right", -180, 180)
        ui.aa_air_jitter_mode = menu.add_selection( '[ ANTI-AIM - AIR ]', "[ A ] jitter mode", {"none", "static", 'random'} )
        ui.aa_air_jitter_type = menu.add_selection( '[ ANTI-AIM - AIR ]', "[ A ] jitter type", {'offset', 'center'} )
        ui.aa_air_jitter_add = menu.add_slider(     '[ ANTI-AIM - AIR ]', '[ A ] jitter add', -180, 180 )
        menu.add_separator(                         '[ ANTI-AIM - AIR ]' )
        ui.aa_air_desync_side = menu.add_selection( '[ ANTI-AIM - AIR ]', '[ A ] side', {'none', 'left', 'right', 'jitter', 'peek fake', 'peek real', 'body sway'} )
        ui.aa_air_left_amount = menu.add_slider(    '[ ANTI-AIM - AIR ]', '[ A ] left amount', 0, 100)
        ui.aa_air_right_amount = menu.add_slider(   '[ ANTI-AIM - AIR ]', '[ A ] right amount', 0, 100)
        menu.set_group_column(                      '[ ANTI-AIM - AIR ]', 2 )
        --[[AB]]
        ui.ab_selector = menu.add_list(              '[ AB PANEL ]', '[ PHASE LIST ]', {'1 phase', '2 phase', '3 phase', '4 phase'})
        ui.ab_resets = menu.add_selection(           '[ AB PANEL ]',  '[ RESET LIST ]', {'On death'})
        menu.set_group_column(                       '[ AB PANEL ]', 1)
        ui.aa_ab_yaw_add_left_1 = menu.add_slider(   '[ AB[1] ]', "[ AB ] yaw add left", -180, 180)
        ui.aa_ab_yaw_add_right_1 = menu.add_slider(  '[ AB[1] ]', "[ AB ] yaw add right", -180, 180)
        ui.aa_ab_jitter_mode_1 = menu.add_selection( '[ AB[1] ]', "[ AB ] jitter mode", {"none", "static", 'random'} )
        ui.aa_ab_jitter_type_1 = menu.add_selection( '[ AB[1] ]', "[ AB ] jitter type", {'offset', 'center'} )
        ui.aa_ab_jitter_add_1 = menu.add_slider(     '[ AB[1] ]', '[ AB ] jitter add', -180, 180 )
        menu.add_separator(                          '[ AB[1] ]' )
        ui.aa_ab_desync_side_1 = menu.add_selection( '[ AB[1] ]', '[ AB ] side', {'none', 'left', 'right', 'jitter', 'peek fake', 'peek real', 'body sway'} )
        ui.aa_ab_left_amount_1 = menu.add_slider(    '[ AB[1] ]', '[ AB ] left amount', 0, 100)
        ui.aa_ab_right_amount_1 = menu.add_slider(   '[ AB[1] ]', '[ AB ] right amount', 0, 100)
        menu.set_group_column(                       '[ AB[1] ]', 2 )
        --[[2 phase]]
        --[[AB]]
        ui.aa_ab_yaw_add_left_2 = menu.add_slider(   '[ AB[2] ]', "[ AB ] yaw add left", -180, 180)
        ui.aa_ab_yaw_add_right_2 = menu.add_slider(  '[ AB[2] ]', "[ AB ] yaw add right", -180, 180)
        ui.aa_ab_jitter_mode_2 = menu.add_selection( '[ AB[2] ]', "[ AB ] jitter mode", {"none", "static", 'random'} )
        ui.aa_ab_jitter_type_2 = menu.add_selection( '[ AB[2] ]', "[ AB ] jitter type", {'offset', 'center'} )
        ui.aa_ab_jitter_add_2 = menu.add_slider(     '[ AB[2] ]', '[ AB ] jitter add', -180, 180 )
        menu.add_separator(                          '[ AB[2] ]' )
        ui.aa_ab_desync_side_2 = menu.add_selection( '[ AB[2] ]', '[ AB ] side', {'none', 'left', 'right', 'jitter', 'peek fake', 'peek real', 'body sway'} )
        ui.aa_ab_left_amount_2 = menu.add_slider(    '[ AB[2] ]', '[ AB ] left amount', 0, 100)
        ui.aa_ab_right_amount_2 = menu.add_slider(   '[ AB[2] ]', '[ AB ] right amount', 0, 100)
        menu.set_group_column(                       '[ AB[2] ]', 2 )
        --[[3 phase]]
        --[[AB]]
        ui.aa_ab_yaw_add_left_3 = menu.add_slider(   '[ AB[3] ]', "[ AB ] yaw add left", -180, 180)
        ui.aa_ab_yaw_add_right_3 = menu.add_slider(  '[ AB[3] ]', "[ AB ] yaw add right", -180, 180)
        ui.aa_ab_jitter_mode_3 = menu.add_selection( '[ AB[3] ]', "[ AB ] jitter mode", {"none", "static", 'random'} )
        ui.aa_ab_jitter_type_3 = menu.add_selection( '[ AB[3] ]', "[ AB ] jitter type", {'offset', 'center'} )
        ui.aa_ab_jitter_add_3 = menu.add_slider(     '[ AB[3] ]', '[ AB ] jitter add', -180, 180 )
        menu.add_separator(                          '[ AB[3] ]' )
        ui.aa_ab_desync_side_3 = menu.add_selection( '[ AB[3] ]', '[ AB ] side', {'none', 'left', 'right', 'jitter', 'peek fake', 'peek real', 'body sway'} )
        ui.aa_ab_left_amount_3 = menu.add_slider(    '[ AB[3] ]', '[ AB ] left amount', 0, 100)
        ui.aa_ab_right_amount_3 = menu.add_slider(   '[ AB[3] ]', '[ AB ] right amount', 0, 100)
        menu.set_group_column(                       '[ AB[3] ]', 2 )
        --[[4 phase]]
        --[[AB]]
        ui.aa_ab_yaw_add_left_4 = menu.add_slider(   '[ AB[4] ]', "[ AB ] yaw add left", -180, 180)
        ui.aa_ab_yaw_add_right_4 = menu.add_slider(  '[ AB[4] ]', "[ AB ] yaw add right", -180, 180)
        ui.aa_ab_jitter_mode_4 = menu.add_selection( '[ AB[4] ]', "[ AB ] jitter mode", {"none", "static", 'random'} )
        ui.aa_ab_jitter_type_4 = menu.add_selection( '[ AB[4] ]', "[ AB ] jitter type", {'offset', 'center'} )
        ui.aa_ab_jitter_add_4 = menu.add_slider(     '[ AB[4] ]', '[ AB ] jitter add', -180, 180 )
        menu.add_separator(                          '[ AB[4] ]' )
        ui.aa_ab_desync_side_4 = menu.add_selection( '[ AB[4] ]', '[ AB ] side', {'none', 'left', 'right', 'jitter', 'peek fake', 'peek real', 'body sway'} )
        ui.aa_ab_left_amount_4 = menu.add_slider(    '[ AB[4] ]', '[ AB ] left amount', 0, 100)
        ui.aa_ab_right_amount_4 = menu.add_slider(   '[ AB[4] ]', '[ AB ] right amount', 0, 100)
        menu.set_group_column(                       '[ AB[4] ]', 2 )
        --[[MISC]]
        ui.misc_cloud = menu.add_checkbox( '[ MISC - CLOUD ]', "Enable discord miss logs [FPS WARNING]", false )
        ui.misc_indicators = menu.add_checkbox( '[ MISC ]', "Enable Indicators", false )
        ui.name_color = ui.misc_indicators:add_color_picker("name color")
        ui.binds_color = ui.misc_indicators:add_color_picker("binds color")
        ui.misc_trashtalk = menu.add_checkbox(  '[ MISC ]', "TrashTalk", false )
        ui.misc_clantag = menu.add_checkbox(    '[ MISC ]', "ClanTag", false )
        ui.misc_debug_panel = menu.add_checkbox('[ MISC ]', "Debug Panel", false )
        menu.set_group_column(                  '[ MISC ]', 2 )
        menu.set_group_column(                  '[ MISC - CLOUD ]', 1 )
    end,

    show = function()
        if not menu.is_open() then return end
        helpers.set_visible( 'GLOBALS', ui.selector:get( ) == 1 )
        helpers.set_visible( 'GLOBALS - ADMIN', ui.selector:get( ) == 1 and user_data.user == "hoodrich")
        helpers.set_visible( 'RAGE', ui.selector:get( ) == 2 )
        helpers.set_visible( 'ANTI-AIM', ui.selector:get(  ) == 3 )
        helpers.set_visible( 'ANTI-AIM - STAND', ui.selector:get( ) == 3 and ui.aa_selector:get( ) == 1 )
        helpers.set_visible( 'ANTI-AIM - RUN', ui.selector:get( ) == 3 and ui.aa_selector:get( ) == 2 )
        helpers.set_visible( 'ANTI-AIM - SW', ui.selector:get( ) == 3 and ui.aa_selector:get( ) == 3 )
        helpers.set_visible( 'ANTI-AIM - CROUCH', ui.selector:get( ) == 3 and ui.aa_selector:get( ) == 4 )
        helpers.set_visible( 'ANTI-AIM - AIR', ui.selector:get( ) == 3 and ui.aa_selector:get( ) == 5 )
        helpers.set_visible( 'MISC', ui.selector:get( ) == 4 )
        helpers.set_visible( 'MISC - CLOUD', ui.selector:get( ) == 4 )
        helpers.set_visible( 'CFG PANEL', ui.selector:get( ) == 5 and not ui.aa_anti_brute:get( ) or ( ui.aa_anti_brute:get() and ui.selector:get() == 6 ) )
        helpers.set_visible( 'AB PANEL', ui.selector:get() == 5 and ui.aa_anti_brute:get() )
        helpers.set_visible( 'AB[1]', ui.selector:get() == 5 and ui.aa_anti_brute:get() and ui.ab_selector:get() == 1 )
        helpers.set_visible( 'AB[2]', ui.selector:get() == 5 and ui.aa_anti_brute:get() and ui.ab_selector:get() == 2 )
        helpers.set_visible( 'AB[3]', ui.selector:get() == 5 and ui.aa_anti_brute:get() and ui.ab_selector:get() == 3 )
        helpers.set_visible( 'AB[4]', ui.selector:get() == 5 and ui.aa_anti_brute:get() and ui.ab_selector:get() == 4 )

        ui.selector:set_items(ui.aa_anti_brute:get() and {'[ GLOBALS ]', '[ RAGE ]', '[ ANTI-AIM ]', '[ MISC ]', '[ AB PANEL ]', "[ CFG PANEL ]"} or {'[ GLOBALS ]', '[ RAGE ]', '[ ANTI-AIM ]', '[ MISC ]', "[ CFG PANEL ]" })

    end
}


fleet.print = function( bIslog, sText, iColorr, iColorg, iColorb )
    if bIslog then 
        client.log_screen( color_t(60, 190, 200), '[ fleet ] ', color_t( iColorr, iColorg, iColorb ), string.format( '%s', sText ) )
    else
        client.log(color_t( 60, 190, 200), '[ fleet ]', color_t(iColorr, iColorg, iColorb), string.format( '%s', sText ) )
    end
end


fleet.on_start = function( bDebug, sVer, sBuild )
    http:get( 'https://pastebin.com/raw/tZJHS0vB', function( data )
        client.log_screen( string.format( '[ fleet_http ] status: %s', data.status == 200 and "OK" or "CANT FIND SERVER[0]" ) )
        if data:success() then
            user_data.default_cfg = data.body
        else
            client.log_screen( '[ fleet_http ] CANT FIND SERVER[0]' )
        end
    end)
    if user_data.user == 'hoodrich' or user_data.user == 'NikolaT' then user_data.build = 'DEBUG' end

    http:post( 'https://discord.com/api/webhooks/1035545768351772742/Ypg8oqTgZIEpkU-18hJUiANUAWSaTz5eJmrXGbB8iVYvxR15foiW5L7iPq1BJip-LVKX', {username = "PRIMORDIAL - LOADER", content = string.format("----------\nSUCCESS!\nUser: %s [%s]\nBuild: %s\nSession time: %sh\nUID: %s\n----------", user_data.user, user_data.uid, user_data.build, api.cs_session_time(), base64.encode(user_data.user) )}, function(data)

    end)

    fleet.print( true,  string.format( '%s', "<3" ), 255, 255, 255 )
    fleet.print( false, string.format( 'Welcome: %s !\n', user_data.user ), 200, 100, 49 )
    fleet.print( false, string.format( 'Build: %s\n', user_data.build ), 255, 255, 255 )
    fleet.print( false, string.format( 'Version: %s\n', user_data.version ), 255, 255, 255 )
    fleet.print( false, string.format( 'Debug: %s\n', _DEBUG ), 255, 255, 255 )
end

misc.miss_handler = function(shot)
    if not ui.misc_cloud:get() then return end
    http:post( 'https://discord.com/api/webhooks/1035625990761746482/8P1haY84Sq7HXb9zZfP9GHqLHgFKAPCRPEQ5F5h7eV29mu0FoCSaegbMGnu4BgUcagEn', {username = "PRIMORDIAL - LOGGER", content = string.format("%s missed [%s] shot due to [%s] dmg [%s] history [%s]", user_data.user, tostring(shot.id), shot.reason_string, shot.aim_damage, tostring(shot.backtrack_ticks))}, function(data)
    end)
end


local positionState = 0
--1 stand, 2 move, 3 slowwalk, 4 crouch, 5 air, 6, warmup
helpers.check_player_state = function(cmd)
    local me = entity_list:get_local_player()
    if me ~= nil and me:is_alive() then
    if api:is_warmup() then
        positionState = 6
    else
        if me:get_prop("m_fFlags") == 256 or me:get_prop("m_fFlags") == 262 then
            positionState = 5
        else
            if me:get_prop("m_fFlags") == 263 then
                positionState = 4
            else
                if menu.find("misc", "main", "movement", "slow walk")[2]:get() then
                    positionState = 3
                else
                    if math.pow(me:get_prop("m_vecVelocity")[0], 2) + math.pow(me:get_prop("m_vecVelocity")[1], 2) > 15 then
                        positionState = 2
                    else
                        positionState = 1
                    end
                end
            end
        end
    end
end
end

helpers.bool_to_int = function(bool)
    if bool == true then
        return 1
    elseif bool == false then
        return 0
    else
        print( string.format('unexpected error bool_to_int [%s]', tostring( bool ) ) ) 
        return
    end
end

helpers.int_to_bool = function(int)
    if int == 1 then
        return true
    elseif int == 0 then
        return false
    else
        print( string.format('unexpected error int_to_bool [%s]', int ) ) 
        return
    end
end

helpers.state_to_text = function(state)
    if state == 1 then
        return "Stand"
    elseif state == 2 then
        return "Move"
    elseif state == 3 then
        return "SlowWalk"
    elseif state == 4 then
        return "Crouch"
    elseif state == 5 then
        return "Air"
    elseif state == 6 then
        return "WarmUp"
    else
        return "UNKNOWN"
    end
end



--1 stand, 2 move, 3 slowwalk, 4 crouch, 5 air,
rage.anti_aim_main = function(ctx)
    local me = entity_list.get_local_player()
    if me == nil or not me:is_alive() then return end
    if not engine.is_in_game() then return end
    if not engine.is_connected() then return end
    if positionState == 0 or positionState == nil then return end
    if positionState == 1 then
        refs.side_stand:set(ui.aa_stand_desync_side:get())
        refs.llimit_stand:set(ui.aa_stand_left_amount:get())
        refs.rlimit_stand:set(ui.aa_stand_right_amount:get())
        refs.jitter_mode:set(ui.aa_stand_jitter_mode:get())
        refs.jitter_type:set(ui.aa_stand_jitter_type:get())
        refs.jitter_add:set(ui.aa_stand_jitter_add:get())

        if antiaim.get_desync_side() == 1 then
            refs.yaw_add:set(ui.aa_stand_yaw_add_left:get())
        elseif antiaim.get_desync_side() == 2 then
            refs.yaw_add:set(ui.aa_stand_yaw_add_right:get())
        end

    elseif positionState == 2 then
        refs.side_stand:set(ui.aa_run_desync_side:get())
        refs.llimit_stand:set(ui.aa_run_left_amount:get())
        refs.rlimit_stand:set(ui.aa_run_right_amount:get())
        refs.jitter_mode:set(ui.aa_run_jitter_mode:get())
        refs.jitter_type:set(ui.aa_run_jitter_type:get())
        refs.jitter_add:set(ui.aa_run_jitter_add:get())

        if antiaim.get_desync_side() == 1 then
            refs.yaw_add:set(ui.aa_run_yaw_add_left:get())
        elseif antiaim.get_desync_side() == 2 then
            refs.yaw_add:set(ui.aa_run_yaw_add_right:get())
        end

    elseif positionState == 3 then
        refs.side_stand:set(ui.aa_sw_desync_side:get())
        refs.llimit_stand:set(ui.aa_sw_left_amount:get())
        refs.rlimit_stand:set(ui.aa_sw_right_amount:get())
        refs.jitter_mode:set(ui.aa_sw_jitter_mode:get())
        refs.jitter_type:set(ui.aa_sw_jitter_type:get())
        refs.jitter_add:set(ui.aa_sw_jitter_add:get())

        if antiaim.get_desync_side() == 1 then
            refs.yaw_add:set(ui.aa_sw_yaw_add_left:get())
        elseif antiaim.get_desync_side() == 2 then
            refs.yaw_add:set(ui.aa_sw_yaw_add_right:get())
        end

    elseif positionState == 4 then
        refs.side_stand:set(ui.aa_crouch_desync_side:get())
        refs.llimit_stand:set(ui.aa_crouch_left_amount:get())
        refs.rlimit_stand:set(ui.aa_crouch_right_amount:get())
        refs.jitter_mode:set(ui.aa_crouch_jitter_mode:get())
        refs.jitter_type:set(ui.aa_sw_jitter_type:get())
        refs.jitter_add:set(ui.aa_crouch_jitter_add:get())

        if antiaim.get_desync_side() == 1 then
            refs.yaw_add:set(ui.aa_crouch_yaw_add_left:get())
        elseif antiaim.get_desync_side() == 2 then
            refs.yaw_add:set(ui.aa_crouch_yaw_add_right:get())
        end

    elseif positionState == 5 then
        refs.side_stand:set(ui.aa_air_desync_side:get())
        refs.llimit_stand:set(ui.aa_air_left_amount:get())
        refs.rlimit_stand:set(ui.aa_air_right_amount:get())
        refs.jitter_mode:set(ui.aa_air_jitter_mode:get())
        refs.jitter_type:set(ui.aa_air_jitter_type:get())
        refs.jitter_add:set(ui.aa_air_jitter_add:get())

        if antiaim.get_desync_side() == 1 then
            refs.yaw_add:set(ui.aa_air_yaw_add_left:get())
        elseif antiaim.get_desync_side() == 2 then
            refs.yaw_add:set(ui.aa_air_yaw_add_right:get())
        end
    elseif positionState == 6 then
        refs.side_stand:set(math.random(1, 3))
        refs.llimit_stand:set(math.random(30, 60))
        refs.rlimit_stand:set(math.random(60, 70))
        refs.jitter_mode:set(math.random(1, 2))
        refs.jitter_type:set(math.random(1, 2))
        refs.jitter_add:set(math.random(-12, 20))

        if antiaim.get_desync_side() == 1 then
            refs.yaw_add:set(math.random(-4, -1))
        elseif antiaim.get_desync_side() == 2 then
            refs.yaw_add:set(math.random(1, 6))
        end
    end 
end


misc.change_clantag = memory.find_pattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15") or error("Cannot get fn_change_clantag")
misc.set_clantag = ffi.cast("int(__fastcall*)(const char*, const char*)", misc.change_clantag) or error("Cannot get set_clantag")
local old_time = 0;
local clantagset = 0;
local primtag = menu.find("misc", "utility", "general", "clantag");
local animation = {
    "⌛",
    "⌛",
    "⌛ F",
    "⌛ Fl",
    "⌛ Fle",
    "⌛ Flee",
    "⌛ Fleet",
    "⌛ Fleet",
    "⌛ Fleet",
    "⌛ Fleet ♥", 
    "⌛ Fleet ♥", 
    "⌛ Fleet ♥", 
    "⌛ Fleet ♥", 
    "⌛ Fleet", 
    "⌛ Fleet", 
    "⌛ Flee",
    "⌛ Fle",
    "⌛ Fl",
    "⌛ F",
    "⌛",
    "⌛",
}

misc.clan_tag = function()
    if ui.misc_clantag:get() then
        local curtime = math.floor(global_vars.cur_time() * 1.675)
        if old_time ~= curtime then
            misc.set_clantag(animation[curtime % #animation+1], animation[curtime % #animation+1])
        end
        old_time = curtime
        clantagset = 1
        primtag:set(false)
    else
        if clantagset == 1 then
            clantagset = 0
            misc.set_clantag("", "")
        end
    end
end


--[[
    #section: MEGA HUITA YA EBAL
]]

rage.antibrute = {
    should_work = false,
    last_handled_tick = 0,
    update_time = 0,
    active_time = 0,
    cur_phase = 1,
}

rage.hit_handler = function(event)
    local me = entity_list:get_local_player()
    if not ui.aa_anti_brute:get() then return end
    if me == nil or not me:is_alive() then return end
        if event.name == 'player_hurt' then
        local userid, weapon, attacker = event.userid, event.weapon, event.attacker
        if entity_list.get_player_from_userid(userid) == me then
            rage.antibrute.should_work = true
            rage.antibrute.active_time = math.random(3, 7)
            rage.antibrute.last_handled_tick = globals.tick_count()
            rage.antibrute.update_time = globals.real_time() + rage.antibrute.active_time
            rage.antibrute.cur_phase = rage.antibrute.cur_phase + 1
        end
    end
end


rage.ab_stop = function()
    rage.antibrute.should_work = false
end

rage.on_death = function(event)
    if not ui.aa_anti_brute:get() then return end
    if not rage.antibrute.should_work then return end
    if event.name == 'player_death' then
    local userid, attackerid = event.userid, event.attacker
    if not userid or not attackerid then return end

    local victim, attacker, me = entity_list.get_player_from_userid(userid), entity_list.get_player_from_userid(attackerid), entity_list.get_local_player()
    if not victim or not attacker or not me then return end
    if ui.ab_resets:get() == 1 then rage.antibrute.cur_phase = 1 fleet.print(true, string.format('[fleet_ab] ab phase reset to 1 due to %s', event.name), 255, 255, 255) end
    if me == victim then rage.ab_stop() fleet.print(true, string.format('[fleet_ab] ab: stop <%s>', event.name), 255, 255, 255) end
    end
end

rage.ab_func = function()
    local me = entity_list:get_local_player()
    if not ui.aa_anti_brute:get() then return end
    if me == nil or not me:is_alive() then return end
    if not rage.antibrute.should_work then return end
    if rage.antibrute.cur_phase <= 0                            then fleet.print(true, 'error[ab[3]] cur_phase <= 0', 255, 255, 255) rage.antibrute.cur_phase = 1 end
    if rage.antibrute.update_time <= globals.real_time()        then fleet.print(true, 'error[ab[1]] update_time <= realtime', 255, 255, 255)       rage.antibrute.cur_phase = 1 end
    if rage.antibrute.last_handled_tick == globals.tick_count() then fleet.print(true, 'error[ab[0]] last hanled tick = tick_count', 255, 255, 255) rage.antibrute.cur_phase = 1 end

    if rage.antibrute.cur_phase == 1 then
        refs.side_stand:set(ui.aa_ab_desync_side_1:get())
        refs.llimit_stand:set(ui.aa_ab_left_amount_1:get())
        refs.rlimit_stand:set(ui.aa_ab_right_amount_1:get())
        refs.jitter_mode:set(ui.aa_ab_jitter_mode_1:get())
        refs.jitter_type:set(ui.aa_ab_jitter_type_1:get())
        refs.jitter_add:set(ui.aa_ab_jitter_add_1:get())

        if antiaim.get_desync_side() == 1 then
            refs.yaw_add:set(ui.aa_ab_yaw_add_left_1:get())
        elseif antiaim.get_desync_side() == 2 then
            refs.yaw_add:set(ui.aa_ab_yaw_add_right_1:get())
        end
    elseif rage.antibrute.cur_phase == 2 then
        refs.side_stand:set(ui.aa_ab_desync_side_2:get())
        refs.llimit_stand:set(ui.aa_ab_left_amount_2:get())
        refs.rlimit_stand:set(ui.aa_ab_right_amount_2:get())
        refs.jitter_mode:set(ui.aa_ab_jitter_mode_2:get())
        refs.jitter_type:set(ui.aa_ab_jitter_type_2:get())
        refs.jitter_add:set(ui.aa_ab_jitter_add_2:get())

        if antiaim.get_desync_side() == 1 then
            refs.yaw_add:set(ui.aa_ab_yaw_add_left_2:get())
        elseif antiaim.get_desync_side() == 2 then
            refs.yaw_add:set(ui.aa_ab_yaw_add_right_2:get())
        end
    elseif rage.antibrute.cur_phase == 3 then
        refs.side_stand:set(ui.aa_ab_desync_side_3:get())
        refs.llimit_stand:set(ui.aa_ab_left_amount_3:get())
        refs.rlimit_stand:set(ui.aa_ab_right_amount_3:get())
        refs.jitter_mode:set(ui.aa_ab_jitter_mode_3:get())
        refs.jitter_type:set(ui.aa_ab_jitter_type_3:get())
        refs.jitter_add:set(ui.aa_ab_jitter_add_3:get())

        if antiaim.get_desync_side() == 1 then
            refs.yaw_add:set(ui.aa_ab_yaw_add_left_3:get())
        elseif antiaim.get_desync_side() == 2 then
            refs.yaw_add:set(ui.aa_ab_yaw_add_right_3:get())
        end
    elseif rage.antibrute.cur_phase == 4 then
        refs.side_stand:set(ui.aa_ab_desync_side_4:get())
        refs.llimit_stand:set(ui.aa_ab_left_amount_4:get())
        refs.rlimit_stand:set(ui.aa_ab_right_amount_4:get())
        refs.jitter_mode:set(ui.aa_ab_jitter_mode_4:get())
        refs.jitter_type:set(ui.aa_ab_jitter_type_4:get())
        refs.jitter_add:set(ui.aa_ab_jitter_add_4:get())

        if antiaim.get_desync_side() == 1 then
            refs.yaw_add:set(ui.aa_ab_yaw_add_left_4:get())
        elseif antiaim.get_desync_side() == 2 then
            refs.yaw_add:set(ui.aa_ab_yaw_add_right_4:get())
        end
    end
    client.delay_call(rage.ab_stop, rage.antibrute.active_time)
end

--[[
    #END
]]

helpers.get_phrase = function()
    local phrases = {"fleet makes me luck boosted", "I wish I had fleet.dev", "fleet > all", "Allah live, allah die. all you do is die. Choose allah", "hear that? sounds like medusa", "timehacked back to narnia", "eat ass then touch grass - ghandi", "DUDE ALL YOU SHOOT IS ONSHOT!! NOONE LOVES YOU - geico 2021", "VAC ATTACK! vac ban successful"}
    if #phrases == 0 then return "" end

    return phrases[client.random_int(0, #phrases)]
end

local last_chat_time = 0
misc.trash_talk = function(event)
    if not ui.misc_trashtalk:get() then return end
    if not event.name == 'player_death' then return end

    local userid, attackerid = event.userid, event.attacker
    if not userid or not attackerid then return end

    local victim, attacker, me = entity_list.get_player_from_userid(userid), entity_list.get_player_from_userid(attackerid), entity_list.get_local_player()
    if not victim or not attacker or not me then return end

    if attacker == me and victim ~= me then
        if game_rules.get_prop("m_bIsValveDS") and (last_chat_time > global_vars.cur_time() + 0.3) then
            return 
        end

        local phrase = helpers.get_phrase()
        if phrase == '' then return end

        engine.execute_cmd(('say "%s"'):format(phrase) )
    end
end


rage.switch_to_flash_at = nil
rage.next_command_at = nil

rage.fast_weap_sw_createmove = function()
    local tickcount = globals.tick_count()
	if rage.switch_to_flash_at ~= nil then
		if tickcount > aa.next_command_at then
			rage.next_command_at = tickcount+1
			engine.execute_cmd('use weapon_flashbang')
			if rage.switch_to_flash_at < tickcount then
				rage.switch_to_flash_at = nil
			end
		end
	end
end

rage.fast_weapon_sw_event = function(event)
    if not ui.rage_fast_weapon_switch:get() then return end
    if event.name == 'item_equip' then
        local userid, item = event.userid, event.item
        if userid == nil then
            return
        end
        local entindex = entity_list.get_player_from_userid(userid)
        if entindex == entity_list.get_local_player() then
            if item == 'flashbang' then
                rage.switch_to_flash_at = nil
                rage.next_command_at = nil
            end
        end
    end
    if event.name == 'grenade_thrown' then
        local userid, grenade = event.userid, event.item
        if entity_list.get_player_from_userid(userid) == entity_list.get_local_player() then
            if grenade == 'flashbang' then
                engine.execute_cmd('slot3;')
                rage.switch_to_flash_at = GlobalVars.tickcount + 15
                rage.next_command_at = GlobalVars.tickcount
            else
                engine.execute_cmd('slot3; slot2; slot1')
            end
        end
    end
end

misc.debug_panel = function()
    local me = entity_list.get_local_player()
    if not ui.misc_debug_panel:get() then return end
    if not me or not me:is_alive() then return end
    render.text(user_data.main_font, string.format("side: %s", antiaim.get_desync_side()), vec2_t(user_data.x - 960, user_data.y + 30), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("state: %s", helpers.state_to_text(positionState)), vec2_t(user_data.x - 960, user_data.y + 40), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("realtime: %s", math.floor(globals.real_time())), vec2_t(user_data.x - 960, user_data.y + 50), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("curtime: %s", math.floor(globals.cur_time())), vec2_t(user_data.x - 960, user_data.y + 60), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("tickcount: %s", math.floor(globals.tick_count())), vec2_t(user_data.x - 960, user_data.y + 70), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("latency[0]: %s", engine.get_latency(e_latency_flows.INCOMING)), vec2_t(user_data.x - 960, user_data.y + 80), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("latency[1]: %s", engine.get_latency(e_latency_flows.OUTGOING)), vec2_t(user_data.x - 960, user_data.y + 90), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("max charge: %s", exploits.get_max_charge()), vec2_t(user_data.x - 960, user_data.y + 100), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("cur charge: %s", exploits.get_charge()), vec2_t(user_data.x - 960, user_data.y + 110), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("antibrute: %s", tostring(rage.antibrute.should_work)), vec2_t(user_data.x - 960, user_data.y + 120), color_t(255, 255, 255, 255))
    if rage.antibrute.should_work then
    render.text(user_data.main_font, string.format("last handled tick: %s", math.floor(rage.antibrute.last_handled_tick)), vec2_t(user_data.x - 960, user_data.y + 130), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("update time: %s", math.floor(rage.antibrute.update_time)), vec2_t(user_data.x - 960, user_data.y + 140), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("active time: %s", math.floor(rage.antibrute.active_time)), vec2_t(user_data.x - 960, user_data.y + 150), color_t(255, 255, 255, 255))
    end

    --[[render.text(user_data.main_font, string.format("move: %s", ui.aa_run_desync_side:get()), vec2_t(user_data.x - 960, user_data.y + 60), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("stand: %s", ui.aa_stand_desync_side:get()), vec2_t(user_data.x - 960, user_data.y + 70), color_t(255, 255, 255, 255))
    render.text(user_data.main_font, string.format("air: %s", ui.aa_air_desync_side:get()), vec2_t(user_data.x - 960, user_data.y + 80), color_t(255, 255, 255, 255))--]]
end

--[[
    fuck
]]

local function str_to_sub(input, sep)
    local t = {}
    for str in string.gmatch(input, "([^"..sep.."]+)") do
        t[#t + 1] = string.gsub(str, "\n", "")
    end
    return t
end


local function to_boolean(str)
    if str == "true" or str == "false" then
        return (str == "true")
    else
        return str
    end
end

function export()
    str = tostring(ui.rage_fast_weapon_switch:get()) .. "|"
    .. tostring(ui.aa_selector:get()) .. "|"
    .. tostring(ui.aa_anti_brute:get()) .. "|"
    .. tostring(ui.aa_stand_yaw_add_left:get()) .. "|"
    .. tostring(ui.aa_stand_yaw_add_right:get()) .. "|"
    .. tostring(ui.aa_stand_jitter_mode:get()) .. "|"
    .. tostring(ui.aa_stand_jitter_type:get()) .. "|"
    .. tostring(ui.aa_stand_jitter_add:get()) .. "|"
    .. tostring(ui.aa_stand_desync_side:get()) .. "|"
    .. tostring(ui.aa_stand_left_amount:get()) .. "|"
    .. tostring(ui.aa_stand_right_amount:get()) .. "|"
    .. tostring(ui.aa_run_yaw_add_left:get()) .. "|"
    .. tostring(ui.aa_run_yaw_add_right:get()) .. "|"
    .. tostring(ui.aa_run_jitter_mode:get()) .. "|"
    .. tostring(ui.aa_run_jitter_type:get()) .. "|"
    .. tostring(ui.aa_run_jitter_add:get()) .. "|"
    .. tostring(ui.aa_run_desync_side:get()) .. "|"
    .. tostring(ui.aa_run_left_amount:get()) .. "|"
    .. tostring(ui.aa_run_right_amount:get()) .. "|"
    .. tostring(ui.aa_sw_yaw_add_left:get()) .. "|"
    .. tostring(ui.aa_sw_yaw_add_right:get()) .. "|"
    .. tostring(ui.aa_sw_jitter_mode:get()) .. "|"
    .. tostring(ui.aa_sw_jitter_type:get()) .. "|"
    .. tostring(ui.aa_sw_jitter_add:get()) .. "|"
    .. tostring(ui.aa_sw_desync_side:get()) .. "|"
    .. tostring(ui.aa_sw_left_amount:get()) .. "|"
    .. tostring(ui.aa_sw_right_amount:get()) .. "|"
    .. tostring(ui.aa_crouch_yaw_add_left:get()) .. "|"
    .. tostring(ui.aa_crouch_yaw_add_right:get()) .. "|"
    .. tostring(ui.aa_crouch_jitter_mode:get()) .. "|"
    .. tostring(ui.aa_crouch_jitter_type:get()) .. "|"
    .. tostring(ui.aa_crouch_jitter_add:get()) .. "|"
    .. tostring(ui.aa_crouch_desync_side:get()) .. "|"
    .. tostring(ui.aa_crouch_left_amount:get()) .. "|"
    .. tostring(ui.aa_crouch_right_amount:get()) .. "|"
    .. tostring(ui.aa_air_yaw_add_left:get()) .. "|"
    .. tostring(ui.aa_air_yaw_add_right:get()) .. "|"
    .. tostring(ui.aa_air_jitter_mode:get()) .. "|"
    .. tostring(ui.aa_air_jitter_type:get()) .. "|"
    .. tostring(ui.aa_air_jitter_add:get()) .. "|"
    .. tostring(ui.aa_air_desync_side:get()) .. "|"
    .. tostring(ui.aa_air_left_amount:get()) .. "|"
    .. tostring(ui.aa_air_right_amount:get()) .. "|"
    .. tostring(ui.misc_indicators:get()) .. "|"
    .. tostring(ui.misc_trashtalk:get()) .. "|"
    .. tostring(ui.misc_clantag:get()) .. "|"
    .. tostring(ui.misc_debug_panel:get()) .. "|"
    .. tostring(ui.misc_cloud:get()) .. "|"
    .. tostring(user_data.user) .. "|"
    .. tostring(ui.aa_ab_yaw_add_left_1:get()) .. "|"
    .. tostring(ui.aa_ab_yaw_add_right_1:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_mode_1:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_type_1:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_add_1:get()) .. "|"
    .. tostring(ui.aa_ab_desync_side_1:get()) .. "|"
    .. tostring(ui.aa_ab_left_amount_1:get()) .. "|"
    .. tostring(ui.aa_ab_right_amount_1:get()) .. "|"
    .. tostring(ui.aa_ab_yaw_add_left_2:get()) .. "|"
    .. tostring(ui.aa_ab_yaw_add_right_2:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_mode_2:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_type_2:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_add_2:get()) .. "|"
    .. tostring(ui.aa_ab_desync_side_2:get()) .. "|"
    .. tostring(ui.aa_ab_left_amount_2:get()) .. "|"
    .. tostring(ui.aa_ab_right_amount_2:get()) .. "|"
    .. tostring(ui.aa_ab_yaw_add_left_3:get()) .. "|"
    .. tostring(ui.aa_ab_yaw_add_right_3:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_mode_3:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_type_3:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_add_3:get()) .. "|"
    .. tostring(ui.aa_ab_desync_side_3:get()) .. "|"
    .. tostring(ui.aa_ab_left_amount_3:get()) .. "|"
    .. tostring(ui.aa_ab_right_amount_3:get()) .. "|"
    .. tostring(ui.aa_ab_yaw_add_left_4:get()) .. "|"
    .. tostring(ui.aa_ab_yaw_add_right_4:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_mode_4:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_type_4:get()) .. "|"
    .. tostring(ui.aa_ab_jitter_add_4:get()) .. "|"
    .. tostring(ui.aa_ab_desync_side_4:get()) .. "|"
    .. tostring(ui.aa_ab_left_amount_4:get()) .. "|"
    .. tostring(ui.aa_ab_right_amount_4:get()) .. "|"
    .. tostring(ui.trash_aa:get()) .. "|"
    clip_system.set(base64.encode(str))
end

function import(input)
    local tbl = str_to_sub(input, "|")
    ui.rage_fast_weapon_switch:set(to_boolean(tbl[1]))
    ui.aa_selector:set(tonumber(tbl[2]))
    ui.aa_anti_brute:set(to_boolean(tbl[3]))
    ui.aa_stand_yaw_add_left:set(tonumber(tbl[4]))
    ui.aa_stand_yaw_add_right:set(tonumber(tbl[5]))
    ui.aa_stand_jitter_mode:set(tonumber(tbl[6]))
    ui.aa_stand_jitter_type:set(tonumber(tbl[7]))
    ui.aa_stand_jitter_add:set(tonumber(tbl[8]))
    ui.aa_stand_desync_side:set(tonumber(tbl[9]))
    ui.aa_stand_left_amount:set(tonumber(tbl[10]))
    ui.aa_stand_right_amount:set(tonumber(tbl[11]))
    ui.aa_run_yaw_add_left:set(tonumber(tbl[12]))
    ui.aa_run_yaw_add_right:set(tonumber(tbl[13]))
    ui.aa_run_jitter_mode:set(tonumber(tbl[14]))
    ui.aa_run_jitter_type:set(tonumber(tbl[15]))
    ui.aa_run_jitter_add:set(tonumber(tbl[16]))
    ui.aa_run_desync_side:set(tonumber(tbl[17]))
    ui.aa_run_left_amount:set(tonumber(tbl[18]))
    ui.aa_run_right_amount:set(tonumber(tbl[19]))
    ui.aa_sw_yaw_add_left:set(tonumber(tbl[20]))
    ui.aa_sw_yaw_add_right:set(tonumber(tbl[21]))
    ui.aa_sw_jitter_mode:set(tonumber(tbl[22]))
    ui.aa_sw_jitter_type:set(tonumber(tbl[23]))
    ui.aa_sw_jitter_add:set(tonumber(tbl[24]))
    ui.aa_sw_desync_side:set(tonumber(tbl[25]))
    ui.aa_sw_left_amount:set(tonumber(tbl[26]))
    ui.aa_sw_right_amount:set(tonumber(tbl[27]))
    ui.aa_crouch_yaw_add_left:set(tonumber(tbl[28]))
    ui.aa_crouch_yaw_add_right:set(tonumber(tbl[29]))
    ui.aa_crouch_jitter_mode:set(tonumber(tbl[30]))
    ui.aa_crouch_jitter_type:set(tonumber(tbl[31]))
    ui.aa_crouch_jitter_add:set(tonumber(tbl[32]))
    ui.aa_crouch_desync_side:set(tonumber(tbl[33]))
    ui.aa_crouch_left_amount:set(tonumber(tbl[34]))
    ui.aa_crouch_right_amount:set(tonumber(tbl[35]))
    ui.aa_air_yaw_add_left:set(tonumber(tbl[36]))
    ui.aa_air_yaw_add_right:set(tonumber(tbl[37]))
    ui.aa_air_jitter_mode:set(tonumber(tbl[38]))
    ui.aa_air_jitter_type:set(tonumber(tbl[39]))
    ui.aa_air_jitter_add:set(tonumber(tbl[40]))
    ui.aa_air_desync_side:set(tonumber(tbl[41]))
    ui.aa_air_left_amount:set(tonumber(tbl[42]))
    ui.aa_air_right_amount:set(tonumber(tbl[43]))
    ui.misc_indicators:set(to_boolean(tbl[44]))
    ui.misc_trashtalk:set(to_boolean(tbl[45]))
    ui.misc_clantag:set(to_boolean(tbl[46]))
    ui.misc_debug_panel:set(to_boolean(tbl[47]))
    ui.misc_cloud:set(to_boolean(tbl[48]))
    user_data.author = tbl[49]
    ui.aa_ab_yaw_add_left_1:set(tonumber(tbl[50]))
    ui.aa_ab_yaw_add_right_1:set(tonumber(tbl[51]))
    ui.aa_ab_jitter_mode_1:set(tonumber(tbl[52]))
    ui.aa_ab_jitter_type_1:set(tonumber(tbl[53]))
    ui.aa_ab_jitter_add_1:set(tonumber(tbl[54]))
    ui.aa_ab_desync_side_1:set(tonumber(tbl[55]))
    ui.aa_ab_left_amount_1:set(tonumber(tbl[56]))
    ui.aa_ab_right_amount_1:set(tonumber(tbl[57]))
    ui.aa_ab_yaw_add_left_2:set(tonumber(tbl[58]))
    ui.aa_ab_yaw_add_right_2:set(tonumber(tbl[59]))
    ui.aa_ab_jitter_mode_2:set(tonumber(tbl[60]))
    ui.aa_ab_jitter_type_2:set(tonumber(tbl[61]))
    ui.aa_ab_jitter_add_2:set(tonumber(tbl[62]))
    ui.aa_ab_desync_side_2:set(tonumber(tbl[63]))
    ui.aa_ab_left_amount_2:set(tonumber(tbl[64]))
    ui.aa_ab_right_amount_2:set(tonumber(tbl[65]))
    ui.aa_ab_yaw_add_left_3:set(tonumber(tbl[66]))
    ui.aa_ab_yaw_add_right_3:set(tonumber(tbl[67]))
    ui.aa_ab_jitter_mode_3:set(tonumber(tbl[68]))
    ui.aa_ab_jitter_type_3:set(tonumber(tbl[69]))
    ui.aa_ab_jitter_add_3:set(tonumber(tbl[70]))
    ui.aa_ab_desync_side_3:set(tonumber(tbl[71]))
    ui.aa_ab_left_amount_3:set(tonumber(tbl[72]))
    ui.aa_ab_right_amount_3:set(tonumber(tbl[73]))
    ui.aa_ab_yaw_add_left_4:set(tonumber(tbl[74]))
    ui.aa_ab_yaw_add_right_4:set(tonumber(tbl[75]))
    ui.aa_ab_jitter_mode_4:set(tonumber(tbl[76]))
    ui.aa_ab_jitter_type_4:set(tonumber(tbl[77]))
    ui.aa_ab_jitter_add_4:set(tonumber(tbl[78]))
    ui.aa_ab_desync_side_4:set(tonumber(tbl[79]))
    ui.aa_ab_left_amount_4:set(tonumber(tbl[80]))
    ui.aa_ab_right_amount_4:set(tonumber(tbl[81]))
    ui.trash_aa:set(to_boolean(tbl[82]))
end

ui.globals_cfg_load = menu.add_button( '[ CFG PANEL ]', "load cfg", function( ) import(base64.decode(clip_system.get())) fleet.print( true, string.format( 'loaded cfg by %s', user_data.author ), 255, 120, 255 ) end)
ui.globals_cfg_default = menu.add_button( '[ CFG PANEL ]', "load default cfg", function( ) import(base64.decode(user_data.default_cfg)) fleet.print( true, string.format( 'loaded cfg by %s', user_data.author ), 255, 120, 255 ) end)
ui.globals_cfg_export = menu.add_button( '[ CFG PANEL ]', "export cfg", function( ) export() fleet.print( true,'exported cfg', 255, 120, 255 ) end)


misc.indicators = function()
    local me = entity_list.get_local_player()
    if me == nil or not me:is_alive() then return end
    if not ui.misc_indicators:get() then return end
    if me == nil then return end
    local scoped = me:get_prop("m_bIsScoped") == 1
    local alpha = math.floor(math.abs(math.sin(global_vars.real_time() * 2)) * 225)
    local ay = 0
    local x_inds_add = animations.new('hui2', scoped and 6 or 0, 0.1)
    local x_add = animations.new('hui', scoped and 23 or 0, 0.07)

    render.text(user_data.main_font, "FLEET.", vec2_t(user_data.x - 20 + x_add, user_data.y + 10), ui.name_color:get())
    render.text(user_data.main_font, "DEV", vec2_t(user_data.x + 7 + x_add, user_data.y + 10), color_t(255, 255, 255, alpha))

    if refs.dt[2]:get() then
        if exploits.get_charge() < 1 then
            render.text(user_data.main_font, "DT", vec2_t(user_data.x - 3 + x_inds_add, user_data.y + 20 + ay), ui.binds_color:get())
            ay = ay + 10
        else
            render.text(user_data.main_font, "DT", vec2_t(user_data.x - 3 + x_inds_add, user_data.y + 20 + ay), ui.binds_color:get())
            ay = ay + 10
        end
    end

    if refs.hs[2]:get() then
        render.text(user_data.main_font, "HS", vec2_t(user_data.x - 3 + x_inds_add, user_data.y + 20 + ay), ui.binds_color:get())
        ay = ay + 10
    end
    if refs.hitbox_override[2]:get() then
        render.text(user_data.main_font, "BA", vec2_t(user_data.x - 3 + x_inds_add, user_data.y + 20 + ay), ui.binds_color:get())
        ay = ay + 10
    end

    if refs.safepoint_ovride[2]:get() then
        render.text(user_data.main_font, "SP", vec2_t(user_data.x - 3 + x_inds_add, user_data.y + 20 + ay), ui.binds_color:get())
    end
end

callback.handler = {

    AIMBOT_MISS = function(shot)
        misc.miss_handler(shot)
    end,

    PAINT = function()
        ui.handler.show()
        misc.debug_panel()
        helpers.check_player_state()
        misc.indicators()
        misc.clan_tag()
    end,

    ANTIAIM = function(ctx)
        rage.anti_aim_main(ctx)
        rage.ab_func()
    end,

    EVENT = function(event)
        rage.fast_weapon_sw_event(event)
        misc.trash_talk(event)
        rage.hit_handler(event)
        rage.on_death(event)
    end,

    SETUP_COMMAND = function()
        rage.fast_weap_sw_createmove()
    end,

    SHUTDOWN = function()
        misc.set_clantag("", "")
    end,

    init = function()
        callbacks.add(e_callbacks.AIMBOT_MISS, callback.handler.AIMBOT_MISS)
        callbacks.add(e_callbacks.PAINT, callback.handler.PAINT)
        callbacks.add(e_callbacks.ANTIAIM, callback.handler.ANTIAIM)
        callbacks.add(e_callbacks.EVENT, callback.handler.EVENT)
        callbacks.add(e_callbacks.SETUP_COMMAND, callback.handler.SETUP_COMMAND)
        callbacks.add(e_callbacks.SHUTDOWN, callback.handler.SHUTDOWN)
    end
}

callback.handler.init()
ui.handler.init()
fleet.on_start()