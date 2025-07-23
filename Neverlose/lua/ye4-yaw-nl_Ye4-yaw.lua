-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

_DEBUG = false


local ffi = require("ffi")
local clipboard = require("neverlose/clipboard")
local anti_aim = require("neverlose/anti_aim")

ffi.cdef[[
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
]]

local js = panorama.loadstring([[
    return {
        OpenExternalBrowserURL: function(url){
            void SteamOverlayAPI.OpenExternalBrowserURL(url)
        }
    }
]])()

local ffi_stuff = {}

ffi_stuff.urlmon = ffi.load 'UrlMon'
ffi_stuff.wininet = ffi.load 'WinInet'


local helpers = {}

helpers.round = function(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end
helpers.in_air = function(player)
    if player == nil then return end
    local flags = player.m_fFlags
    if bit.band(flags, 1) == 0 then
        return true
    end
    return false
end
helpers.on_ground = function(player)
    if player == nil then return end
    local flags = player.m_fFlags
    if bit.band(flags, 1) == 1 then
        return true
    end
    return false
end
helpers.is_crouching = function(player)
    if player == nil then return end
    local flags = player.m_fFlags
    if bit.band(flags, 4) == 4 then
        return true
    end
    return false
end
helpers.get_velocity = function(player)
    if player == nil then return end
    local velocity_ref = player.m_vecVelocity
    local velocity = velocity_ref:length()
    return velocity
end
helpers.normalize_yaw = function(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end
helpers.calc_shit = function(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then
        return 0
    end

    return math.deg(math.atan2(ydelta, xdelta))
end
helpers.get_nearest_enemy = function(plocal, enemies)
    local local_player = entity.get_local_player()
    if not local_player or not local_player:is_alive() then return end

    local camera_position = render.camera_position()

    local camera_angles = render.camera_angles()

    local direction = vector():angles(camera_angles)

    local closest_distance, closest_enemy = math.huge
    for i = 1, #enemies do
        local enemy = entity.get(enemies[i])
        local head_position = enemy:get_hitbox_position(1)

        local ray_distance = head_position:dist_to_ray(
            camera_position, direction
        )
      
        if ray_distance < closest_distance then
            closest_distance = ray_distance
            closest_enemy = enemy
        end
    end

    if not closest_enemy then
        return
    end
    return closest_enemy
end
helpers.calc_angle = function(local_x, local_y, enemy_x, enemy_y)
    local ydelta = local_y - enemy_y
    local xdelta = local_x - enemy_x
    local relativeyaw = math.atan( ydelta / xdelta )
    relativeyaw = helpers.normalize_yaw( relativeyaw * 180 / math.pi )
    if xdelta >= 0 then
        relativeyaw = helpers.normalize_yaw(relativeyaw + 180)
    end
    return relativeyaw
end
helpers.angle_vector = function(angle_x, angle_y)
    local sy = math.sin(math.rad(angle_y))
    local cy = math.cos(math.rad(angle_y))
    local sp = math.sin(math.rad(angle_x))
    local cp = math.cos(math.rad(angle_x))
    return cp * cy, cp * sy, -sp
end
helpers.get_damage = function(plocal, enemy, x, y, z)
    local ex = { }
    local ey = { }
    local ez = { }
    ex[0], ey[0], ez[0] = enemy:get_hitbox_position(1).x, enemy:get_hitbox_position(1).y, enemy:get_hitbox_position(1).z
    ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
    ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
    ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
    ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
    ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
    ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
    local trace = {damage = 0, trace = nil}
    --local dmg = 0
    for i=0, 6 do
        if trace.damage == 0 or trace.damage == nil then
            trace.damage, trace.trace = utils.trace_bullet(enemy, vector(ex[i], ey[i], ez[i]), vector(x, y, z))
        end
    end
    return trace.damage--trace.trace == nil and client.scale_damage(plocal, 1, dmg) or dmg
end
helpers.lerp = function(a, b, percentage) return a + (b - a) * percentage end
helpers.gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
helpers.Download = function(from, to)
    ffi_stuff.wininet.DeleteUrlCacheEntryA(from)
    ffi_stuff.urlmon.URLDownloadToFileA(nil, from, to, 0,0)
end
helpers.gradient_text = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
    local output = ''

    local len = #text-1

    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len

    for i=1, len+1 do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))

        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end

    return output
end

helpers.colored_single_text = function(r1, g1, b1, a1, text, r2, g2, b2, a2)
    local output = ''

    output = ('\a%02x%02x%02x%02x%s\a%02x%02x%02x%02x'):format(r1, g1, b1, a1, text, r2, g2, b2, a2)

    return output
end
helpers.vectordistance = function(x1,y1,z1,x2,y2,z2)
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow( y1 - y2, 2) + math.pow( z1 - z2 , 2) )
end
helpers.colored_text = function(r, g, b, a, text)
    local output = ''

    output = ('\a%02x%02x%02x%02x%s'):format(r, g, b, a, text)

    return output
end
helpers.screen_size = render.screen_size()

files.create_folder("nl\\yeayaw\\")
files.create_folder("nl\\yeayaw\\fonts")

-- network.get(url: string[, headers: table, callback: function])
-- files.write(path: string, contents: string[, is_binary: boolean])

-- network.get('https://cdn.discordapp.com/attachments/1081638606659133620/1081638646484050041/easing.lua', {}, function(s)
--     -- if s and r.status == 200 then
--         -- files.write("nl\\yeayaw\\easing.lua", r.body)
--         print(s)
--     -- end
-- end)

local to_download = {
    { link = 'https://cdn.discordapp.com/attachments/1081638606659133620/1081638646484050041/easing.lua', dir = "nl\\yeayaw\\easing.lua" },
    { link = 'https://cdn.discordapp.com/attachments/953060406182678628/953060859020709910/smallest_pixel-7.ttf', dir = "nl\\yeayaw\\fonts\\pixel.ttf" },
    { link = 'https://cdn.discordapp.com/attachments/953060406182678628/957747508602359818/Acta_Symbols_W95_Arrows.ttf', dir = "nl\\yeayaw\\fonts\\ActaSymbolsW95Arrows.ttf" },
    { link = 'https://cdn.discordapp.com/attachments/614973363215138817/1015456850914840656/lucida-console.ttf', dir = "nl\\yeayaw\\fonts\\lucida_console.ttf" },
}

for i, value in pairs(to_download) do
    if not files.read(value.dir) then
        helpers.Download(value.link, value.dir)
    end
end


-- helpers.CreateDir("nl\\yeayaw\\fonts\\")

-- helpers.Download('https://cdn.discordapp.com/attachments/953060406182678628/953060859020709910/smallest_pixel-7.ttf', 'nl\\yeayaw\\fonts\\pixel.ttf')
-- helpers.Download('https://cdn.discordapp.com/attachments/953060406182678628/957747508602359818/Acta_Symbols_W95_Arrows.ttf', 'nl\\yeayaw\\fonts\\ActaSymbolsW95Arrows.ttf')
-- helpers.Download('https://cdn.discordapp.com/attachments/614973363215138817/997160940871094292/small_fonts.ttf', 'nl\\yeayaw\\fonts\\small_fonts.ttf')

-- print(files.read("nl\\yeayaw\\easing.lua"))

local easing = require 'yeayaw/easing'

local Unpack = unpack or table.unpack;

local script_db = {}

script_db.username = common.get_username()
script_db.lua_name = 'Ye4-Yaw'
script_db.lua_version = 'RELEASED'

local UI = {
    list = { },
}

UI.push = function( args )
    assert( args.element, 'Element is nil' )
    assert( args.index, 'Index is nil' )
    assert( type( args.index ) == 'string', 'Invalid type of index' )

    UI.list[ args.index ] = { }

    UI.list[ args.index ].element = args.element

    UI.list[ args.index ].flags = args.flags or ''

    UI.list[ args.index ].visible_state = function()
        if not args.conditions then
            return true
        end

        for k, v in pairs( args.conditions ) do
            if not v() then
                return false
            end
        end

        return true
    end

    UI.list[ args.index ].element:set_callback( UI.visibility_handle )

    UI.visibility_handle()
end

UI.get = function( index )
    return UI.list[ index ] and UI.list[ index ].element:get()
end

-- UI.get_color = function( index )
--     return UI.list[ index ] and UI.list[ index ].element:GetColor()
-- end

UI.get_element = function( index )
    return UI.list[ index ] and UI.list[ index ].element
end

UI.delete = function( index )
    UI.get( index ):destroy()

    UI.list[ index ] = nil
end

UI.contains = function( index, value )
    index = UI.get( index )

    if type( index ) ~= "table" then
        return false
    end

    for i = 1, #index do
        if index[ i ] == value then
            return true
        end
    end

    return false
end

UI.visibility_handle = function()
    if ui.get_alpha() == 0 then return end

    for k, v in pairs( UI.list ) do
        v.element:set_visible( v.visible_state() )
    end
end

local configs = {}

configs.code = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

configs.encode = function(data)
    return ( ( data:gsub( '.', function( x )
        local r, b='', x:byte(  )
        for i = 8, 1, -1 do r = r .. ( b%2 ^ i - b%2 ^ ( i - 1 ) > 0 and '1' or '0' ) end
        return r;
    end ) .. '0000' ):gsub( '%d%d%d?%d?%d?%d?', function( x )
        if ( #x < 6 ) then return '' end
        local c = 0
        for i = 1, 6 do c = c + ( x:sub( i, i ) == '1' and 2 ^ ( 6 - i ) or 0 ) end
        return configs.code:sub( c + 1, c + 1 )
    end) .. ( { '', '==', '=' } )[ #data%3 + 1 ] )
end

configs.decode = function(data)
    data = string.gsub( data, '[^' .. configs.code .. '=]', '' )
    return ( data:gsub( '.', function( x )
        if ( x == '=' ) then return '' end
        local r, f = '', ( configs.code:find( x ) - 1 )
        for i = 6, 1, -1 do r = r .. ( f%2 ^ i - f%2 ^ ( i - 1 ) > 0 and '1' or '0' ) end
        return r;
    end ):gsub( '%d%d%d?%d?%d?%d?%d?%d?', function( x )
        if ( #x ~= 8 ) then return '' end
        local c = 0
        for i = 1, 8 do c = c + ( x:sub( i, i ) == '1' and 2 ^ ( 8 - i ) or 0 ) end
        return string.char( c )
    end) )
end

configs.export = function()
    local table = {}
    for k, v in pairs( UI.list ) do
        if v.flags == 'c' then
            table[k] = { UI.list[ k ].element:get().r, UI.list[ k ].element:get().g, UI.list[ k ].element:get().b, UI.list[ k ].element:get().a }
        elseif v.flags == '-' then
            goto skip
        else
            table[k] = UI.list[ k ].element:get()
        end
        ::skip::
    end

    clipboard.set(configs.encode(json.stringify(table)))
end


configs.import = function(config)
    local data = json.parse(configs.decode(config))

    for item, value in pairs(data) do
        if UI.list[ item ].flags == 'c' then
            UI.get_element(item):set(color(value[1], value[2], value[3], value[4]))
        else
            UI.get_element(item):set(value)
        end
    end

    UI.visibility_handle()
end

local global_vars = {
    plr_conditions = { 'Global', 'Standing', 'Moving', 'Crouching T', 'Crouching CT', 'Slowwalk', 'Air duck', 'Air', 'Legit aa' },
    plr_conditions_to_int = {
        [ 'Global' ] = 1,
        [ 'Standing' ] = 2,
        [ 'Moving' ] = 3,
        [ 'Crouching T' ] = 4,
        [ 'Crouching CT' ] = 5,
        [ 'Slowwalk' ] = 6,
        [ 'Air duck' ] = 7,
        [ 'Air' ] = 8,
        [ 'Legit aa' ] = 9
    }
}

local ref = {
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = {
        mode = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
        base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
        offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
        avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab")
    },
    yaw_modifier = {
        mode = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
        offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")
    },
    body_yaw = {
        switch = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
        inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
        left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
        right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
        fake_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
        desync_freestand = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
        on_shot_desync = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "On Shot"),
        lby_mode = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "LBY Mode"),
    },
    freestanding = {
        switch = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
        disable_yaw_modifiers = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
        body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers")
    },
    leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    fakelag = {
        switch = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
        limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
        variability = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")
    },
    auto_peek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
    hide_shots = {
        switch = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
        options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options")
    },
    doubletap = {
        switch = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
        lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
        fakelag_limit = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit")
    },
    autoscope = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Scope"),
    hitchance = {
        value = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
        strict_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance", "Strict Hit Chance")
    },
    minimum_damage = {
        value = ui.find("Aimbot", "Ragebot", "Selection", "Minimum Damage"),
        delay_show = ui.find("Aimbot", "Ragebot", "Selection", "Minimum Damage", "Delay Shot")
    },
    body_aim = {
        mode = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
        disablers = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers")
    },
    safe_point = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    hitbox_safety = ui.find("Aimbot", "Ragebot", "Safety", "Ensure Hitbox Safety"),
    thirdperson = ui.find("Visuals", "World", "Main", "Force Thirdperson"),
    override_zoom = {
        force_viewmodel = ui.find("Visuals", "World", "Main", "Override Zoom", "Force Viewmodel"),
        scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
    }
}

local menu = {}

menu.update_log = {
"Just Released!",
"More changes coming soon!"


}

menu.handle_updatelog = function(table)
    local text = ''
    for i = 1, #table do
        text = text .. ' - ' .. table[i] .. (i ~= #table and '\n' or '')
    end
    return text
end

local groups = {
    main = {
        info = ui.create("Global", "Information"),
        config_system = ui.create('Global', 'Config system'),
        nothing = ui.create('Global', ' '),
        image = ui.create('Global', '')
    },
    anti_aim = {
        main = ui.create("Anti-aim", "Main"),
        builder = ui.create("Anti-aim", "Preset changer"),
        binds = ui.create("Anti-aim", "Binds"),
    },
    aimbot = {
        main = ui.create("Aimbot", "Main"),
        hitchances = ui.create("Aimbot", "Hitchances"),
        other = ui.create("Aimbot", "Other"),
    },
    visuals = {
        main = ui.create("Visuals", "Main"),
        ui = ui.create("Visuals", "Ui"),
        crosshair = ui.create("Visuals", "Indicators"),
        custom_scope = ui.create("Visuals", "Custom scope"),
        logs = ui.create("Visuals", "Skeet"),
        other = ui.create("Visuals", "Other"),
    },
    misc = {
        main = ui.create("Misc", "Main"),
        binds = ui.create("Misc", "Binds")
    }
}


menu.side_bar = {}

menu.side_bar.animation = {
    "Y",
    "Ye",
    "Ye4",
    "Ye4-",
    "Ye4-Y",
    "Ye4-YA",
    "Ye4-YAW",
    "Ye4-YAW",
    "Ye4-YAW",
    "Ye4-YA",
    "Ye4-Y",
    "Ye4-",
    "Ye4",
    "Ye",
    "Y",
    "",
    ""
}

menu.side_bar.values = {
    timer = 0
}

menu.side_bar.run = function()
    local curtime = math.floor(globals.curtime * 2)

    if menu.side_bar.values.timer ~= curtime then
        ui.sidebar(helpers.gradient_text(150, 171, 255, 255, 119, 124, 145, 255, menu.side_bar.animation[curtime % #menu.side_bar.animation + 1]), 'user-shield')
        menu.side_bar.values.timer = curtime
    end
end

ui.sidebar(helpers.gradient_text(150, 171, 255, 255, 119, 124, 145, 255, script_db.lua_name), 'user-shield')
--"\aFFFFFFFF [Ye4-Yaw] Build -> \aFCCDFFFF  Dev")
common.add_notify("Hello, " .. common.get_username() .. "!","\aFFFFFFFFWelcome back to YE4-YAW!")
groups.main.info:label("\a858585FF[\aFCCDFFFFYe4-Yaw\a858585FF]\aFCCDFFFF \aFFFFFFFFWelcome back \aFCCDFFFF" .. common.get_username() .. "!")
groups.main.info:label("\aFFFFFFFFBuild \a858585FF» \aFCCDFFFF" ..script_db.lua_version)
groups.main.info:label("\aFFFFFFFFUpdate\a858585FF » \aFCCDFFFF09.09.2022" )
groups.main.info:label("\aFFFFFFFF\n" .. menu.handle_updatelog(menu.update_log))

local default_config = string.format("eyJhaW1ib3RfZWxlbWVudHMiOlsiSGl0Y2hhbmNlcyIsIk90aGVyIl0sImFudGlhaW1fcHJlc2V0cyI6IkN1c3RvbSIsImFudGlhaW1fc2V0dGluZ3MiOnRydWUsImFycm93c19jb2xvciI6WzE0Mi4wLDE2NS4wLDIyOS4wLDI1NS4wXSwiYXJyb3dzX3N0eWxlIjoiRGlzYWJsZWQiLCJhdmF0YXJfc2lkZSI6IkxlZnQiLCJjbGFudGFnIjpmYWxzZSwiY3Jvc3NoYWlyX3N0eWxlIjoiQWNhdGVsIiwiY3VzdG9tX3Njb3BlX2NvbG9yIjpbMTQyLjAsMTY1LjAsMjI5LjAsMjU1LjBdLCJjdXN0b21fc2NvcGVfaW5hY2N1cmFjeSI6ZmFsc2UsImN1c3RvbV9zY29wZV9sZW5naHQiOjEwLjAsImN1c3RvbV9zY29wZV9vZmZzZXQiOjcwLjAsImRlYnVnX2luZm8iOnRydWUsImRvdWJsZXRhcF9vcHRpb25zIjpbIlByZWRpY3QgZHQgZGFtYWdlIl0sImV4cGVyaW1lbnRhbF9hbnRpYnJ1dGVmb3JjZSI6dHJ1ZSwiZmFrZV9saW1pdF9qaXR0ZXJfQWlyIjo2MC4wLCJmYWtlX2xpbWl0X2ppdHRlcl9BaXIgZHVjayI6NjAuMCwiZmFrZV9saW1pdF9qaXR0ZXJfQ3JvdWNoaW5nIENUIjo2MC4wLCJmYWtlX2xpbWl0X2ppdHRlcl9Dcm91Y2hpbmcgVCI6NjAuMCwiZmFrZV9saW1pdF9qaXR0ZXJfR2xvYmFsIjo2MC4wLCJmYWtlX2xpbWl0X2ppdHRlcl9MZWdpdCBhYSI6NjAuMCwiZmFrZV9saW1pdF9qaXR0ZXJfTW92aW5nIjo2MC4wLCJmYWtlX2xpbWl0X2ppdHRlcl9TbG93d2FsayI6NjAuMCwiZmFrZV9saW1pdF9qaXR0ZXJfU3RhbmRpbmciOjYwLjAsImZha2VfbGltaXRfbGVmdF9BaXIiOjYwLjAsImZha2VfbGltaXRfbGVmdF9BaXIgZHVjayI6NjAuMCwiZmFrZV9saW1pdF9sZWZ0X0Nyb3VjaGluZyBDVCI6NjAuMCwiZmFrZV9saW1pdF9sZWZ0X0Nyb3VjaGluZyBUIjo2MC4wLCJmYWtlX2xpbWl0X2xlZnRfR2xvYmFsIjoxLjAsImZha2VfbGltaXRfbGVmdF9MZWdpdCBhYSI6NjAuMCwiZmFrZV9saW1pdF9sZWZ0X01vdmluZyI6NjAuMCwiZmFrZV9saW1pdF9sZWZ0X1Nsb3d3YWxrIjo2MC4wLCJmYWtlX2xpbWl0X2xlZnRfU3RhbmRpbmciOjYwLjAsImZha2VfbGltaXRfcmFuZG9tX0FpciI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21fQWlyIGR1Y2siOjYwLjAsImZha2VfbGltaXRfcmFuZG9tX0Nyb3VjaGluZyBDVCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21fQ3JvdWNoaW5nIFQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9tX0dsb2JhbCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21fTGVnaXQgYWEiOjYwLjAsImZha2VfbGltaXRfcmFuZG9tX01vdmluZyI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21fU2xvd3dhbGsiOjYwLjAsImZha2VfbGltaXRfcmFuZG9tX1N0YW5kaW5nIjo2MC4wLCJmYWtlX2xpbWl0X3JpZ2h0X0FpciI6NjAuMCwiZmFrZV9saW1pdF9yaWdodF9BaXIgZHVjayI6NjAuMCwiZmFrZV9saW1pdF9yaWdodF9Dcm91Y2hpbmcgQ1QiOjYwLjAsImZha2VfbGltaXRfcmlnaHRfQ3JvdWNoaW5nIFQiOjYwLjAsImZha2VfbGltaXRfcmlnaHRfR2xvYmFsIjoxLjAsImZha2VfbGltaXRfcmlnaHRfTGVnaXQgYWEiOjYwLjAsImZha2VfbGltaXRfcmlnaHRfTW92aW5nIjo2MC4wLCJmYWtlX2xpbWl0X3JpZ2h0X1Nsb3d3YWxrIjo2MC4wLCJmYWtlX2xpbWl0X3JpZ2h0X1N0YW5kaW5nIjo2MC4wLCJmYWtlX2xpbWl0X3R5cGVfQWlyIjoiU3RhdGljIiwiZmFrZV9saW1pdF90eXBlX0FpciBkdWNrIjoiU3RhdGljIiwiZmFrZV9saW1pdF90eXBlX0Nyb3VjaGluZyBDVCI6IlN0YXRpYyIsImZha2VfbGltaXRfdHlwZV9Dcm91Y2hpbmcgVCI6IlN0YXRpYyIsImZha2VfbGltaXRfdHlwZV9HbG9iYWwiOiJTdGF0aWMiLCJmYWtlX2xpbWl0X3R5cGVfTGVnaXQgYWEiOiJTdGF0aWMiLCJmYWtlX2xpbWl0X3R5cGVfTW92aW5nIjoiU3RhdGljIiwiZmFrZV9saW1pdF90eXBlX1Nsb3d3YWxrIjoiU3RhdGljIiwiZmFrZV9saW1pdF90eXBlX1N0YW5kaW5nIjoiU3RhdGljIiwiZmFrZV9vcHRpb25zX0FpciI6W10sImZha2Vfb3B0aW9uc19BaXIgZHVjayI6W10sImZha2Vfb3B0aW9uc19Dcm91Y2hpbmcgQ1QiOltdLCJmYWtlX29wdGlvbnNfQ3JvdWNoaW5nIFQiOltdLCJmYWtlX29wdGlvbnNfR2xvYmFsIjpbIkF2b2lkIG92ZXJsYXAiLCJKaXR0ZXIiLCJBbnRpIEJydXRlZm9yY2UiXSwiZmFrZV9vcHRpb25zX0xlZ2l0IGFhIjpbXSwiZmFrZV9vcHRpb25zX01vdmluZyI6W10sImZha2Vfb3B0aW9uc19TbG93d2FsayI6W10sImZha2Vfb3B0aW9uc19TdGFuZGluZyI6W10sImZyZWVzdGFuZGluZ19rZXkiOmZhbHNlLCJmcmVlc3RhbmRpbmdfbW9kZV9BaXIiOiJPZmYiLCJmcmVlc3RhbmRpbmdfbW9kZV9BaXIgZHVjayI6Ik9mZiIsImZyZWVzdGFuZGluZ19tb2RlX0Nyb3VjaGluZyBDVCI6Ik9mZiIsImZyZWVzdGFuZGluZ19tb2RlX0Nyb3VjaGluZyBUIjoiT2ZmIiwiZnJlZXN0YW5kaW5nX21vZGVfR2xvYmFsIjoiT2ZmIiwiZnJlZXN0YW5kaW5nX21vZGVfTGVnaXQgYWEiOiJPZmYiLCJmcmVlc3RhbmRpbmdfbW9kZV9Nb3ZpbmciOiJPZmYiLCJmcmVlc3RhbmRpbmdfbW9kZV9TbG93d2FsayI6Ik9mZiIsImZyZWVzdGFuZGluZ19tb2RlX1N0YW5kaW5nIjoiT2ZmIiwiaGl0Y2hhbmNlX2FpciI6NTAuMCwiaGl0Y2hhbmNlX2Fpcl9lbmFibGUiOmZhbHNlLCJoaXRjaGFuY2VfYWlyX3dlYXBvbnMiOltdLCJoaXRjaGFuY2Vfbm9zY29wZSI6NTAuMCwiaGl0Y2hhbmNlX25vc2NvcGVfZW5hYmxlIjpmYWxzZSwiaGl0Y2hhbmNlX25vc2NvcGVfd2VhcG9ucyI6W10sImhpdG1hcmtlciI6dHJ1ZSwiaGl0bWFya2VyX2RhbWFnZV9jb2xvciI6WzI1NS4wLDI1NS4wLDI1NS4wLDI1NS4wXSwiaGl0bWFya2VyX3BsdXNfY29sb3IiOlsyNTUuMCwyNTUuMCwyNTUuMCwyNTUuMF0sImhpdG1hcmtlcl90eXBlIjpbIisiXSwiaWRlYWx0aWNrIjpmYWxzZSwiaWRlYWx0aWNrX29wdGlvbnMiOltdLCJpbmRpY2F0b3JzX2NvbG9yIjpbMTQyLjAsMTY1LjAsMjI5LjAsMjU1LjBdLCJraWxsc2F5IjpmYWxzZSwibGJ5X21vZGVfQWlyIjoiRGlzYWJsZWQiLCJsYnlfbW9kZV9BaXIgZHVjayI6IkRpc2FibGVkIiwibGJ5X21vZGVfQ3JvdWNoaW5nIENUIjoiRGlzYWJsZWQiLCJsYnlfbW9kZV9Dcm91Y2hpbmcgVCI6IkRpc2FibGVkIiwibGJ5X21vZGVfR2xvYmFsIjoiU3dheSIsImxieV9tb2RlX0xlZ2l0IGFhIjoiRGlzYWJsZWQiLCJsYnlfbW9kZV9Nb3ZpbmciOiJEaXNhYmxlZCIsImxieV9tb2RlX1Nsb3d3YWxrIjoiRGlzYWJsZWQiLCJsYnlfbW9kZV9TdGFuZGluZyI6IkRpc2FibGVkIiwibGVnaXRhYV9hdF90YXJnZXRzIjp0cnVlLCJsZWdpdGFhX2tleSI6ZmFsc2UsImxvZ3MiOnRydWUsIm1hc3NpdmVfZmFrZV9rZXkiOmZhbHNlLCJvbnNob3RfbW9kZV9BaXIiOiJEaXNhYmxlZCIsIm9uc2hvdF9tb2RlX0FpciBkdWNrIjoiRGlzYWJsZWQiLCJvbnNob3RfbW9kZV9Dcm91Y2hpbmcgQ1QiOiJEaXNhYmxlZCIsIm9uc2hvdF9tb2RlX0Nyb3VjaGluZyBUIjoiRGlzYWJsZWQiLCJvbnNob3RfbW9kZV9HbG9iYWwiOiJTd2l0Y2giLCJvbnNob3RfbW9kZV9MZWdpdCBhYSI6IkRpc2FibGVkIiwib25zaG90X21vZGVfTW92aW5nIjoiRGlzYWJsZWQiLCJvbnNob3RfbW9kZV9TbG93d2FsayI6IkRpc2FibGVkIiwib25zaG90X21vZGVfU3RhbmRpbmciOiJEaXNhYmxlZCIsInByZXNldF9lbmFibGVfQWlyIjpmYWxzZSwicHJlc2V0X2VuYWJsZV9BaXIgZHVjayI6ZmFsc2UsInByZXNldF9lbmFibGVfQ3JvdWNoaW5nIENUIjpmYWxzZSwicHJlc2V0X2VuYWJsZV9Dcm91Y2hpbmcgVCI6ZmFsc2UsInByZXNldF9lbmFibGVfR2xvYmFsIjpmYWxzZSwicHJlc2V0X2VuYWJsZV9MZWdpdCBhYSI6ZmFsc2UsInByZXNldF9lbmFibGVfTW92aW5nIjpmYWxzZSwicHJlc2V0X2VuYWJsZV9TbG93d2FsayI6ZmFsc2UsInByZXNldF9lbmFibGVfU3RhbmRpbmciOmZhbHNlLCJyYWluYm93Ijp0cnVlLCJzbG93d2Fsa190eXBlIjoiT2xkIiwic3BlY3RhdG9ycyI6dHJ1ZSwic3RhdGljX3JhZ2RvbGxzIjp0cnVlLCJ0ZWxlcG9ydF9pbmFpciI6ZmFsc2UsInRyYXNoIjpmYWxzZSwidWlfY29sb3IiOlsxNDIuMCwxNjUuMCwyMjkuMCwyNTUuMF0sInVpX2VsZW1lbnRzIjpbIldhdGVybWFyayJdLCJ1aV9zdHlsZSI6IkRlZmF1bHQiLCJ2aWV3bW9kZWxfc2NvcGUiOmZhbHNlLCJ2aXN1YWxfZWxlbWVudHMiOlsiSW5kaWNhdG9ycyIsIlVpIiwiU2tlZXQiLCJPdGhlciJdLCJ3YXJtdXBfYWEiOmZhbHNlLCJ3YXRlcm1hcmtfbmFtZSI6IkNoZWF0Iiwid2F0ZXJtYXJrX25hbWVfcmVmIjoiIiwieWF3X2FkZF9sZWZ0X0FpciI6MC4wLCJ5YXdfYWRkX2xlZnRfQWlyIGR1Y2siOjAuMCwieWF3X2FkZF9sZWZ0X0Nyb3VjaGluZyBDVCI6MC4wLCJ5YXdfYWRkX2xlZnRfQ3JvdWNoaW5nIFQiOjAuMCwieWF3X2FkZF9sZWZ0X0dsb2JhbCI6LTE4LjAsInlhd19hZGRfbGVmdF9MZWdpdCBhYSI6LTE4MC4wLCJ5YXdfYWRkX2xlZnRfTW92aW5nIjowLjAsInlhd19hZGRfbGVmdF9TbG93d2FsayI6MC4wLCJ5YXdfYWRkX2xlZnRfU3RhbmRpbmciOjAuMCwieWF3X2FkZF9yaWdodF9BaXIiOjAuMCwieWF3X2FkZF9yaWdodF9BaXIgZHVjayI6MC4wLCJ5YXdfYWRkX3JpZ2h0X0Nyb3VjaGluZyBDVCI6MC4wLCJ5YXdfYWRkX3JpZ2h0X0Nyb3VjaGluZyBUIjowLjAsInlhd19hZGRfcmlnaHRfR2xvYmFsIjotMjMuMCwieWF3X2FkZF9yaWdodF9MZWdpdCBhYSI6LTE4MC4wLCJ5YXdfYWRkX3JpZ2h0X01vdmluZyI6MC4wLCJ5YXdfYWRkX3JpZ2h0X1Nsb3d3YWxrIjowLjAsInlhd19hZGRfcmlnaHRfU3RhbmRpbmciOjAuMCwieWF3X2FkZF90eXBlX0FpciI6IlN0YXRpYyIsInlhd19hZGRfdHlwZV9BaXIgZHVjayI6IlN0YXRpYyIsInlhd19hZGRfdHlwZV9Dcm91Y2hpbmcgQ1QiOiJTdGF0aWMiLCJ5YXdfYWRkX3R5cGVfQ3JvdWNoaW5nIFQiOiJTdGF0aWMiLCJ5YXdfYWRkX3R5cGVfR2xvYmFsIjoiU3RhdGljIiwieWF3X2FkZF90eXBlX0xlZ2l0IGFhIjoiU3RhdGljIiwieWF3X2FkZF90eXBlX01vdmluZyI6IlN0YXRpYyIsInlhd19hZGRfdHlwZV9TbG93d2FsayI6IlN0YXRpYyIsInlhd19hZGRfdHlwZV9TdGFuZGluZyI6IlN0YXRpYyIsInlhd19tb2RpZmllcl9BaXIiOiJEaXNhYmxlZCIsInlhd19tb2RpZmllcl9BaXIgZHVjayI6IkRpc2FibGVkIiwieWF3X21vZGlmaWVyX0Nyb3VjaGluZyBDVCI6IkRpc2FibGVkIiwieWF3X21vZGlmaWVyX0Nyb3VjaGluZyBUIjoiRGlzYWJsZWQiLCJ5YXdfbW9kaWZpZXJfR2xvYmFsIjoiQ2VudGVyIiwieWF3X21vZGlmaWVyX0xlZ2l0IGFhIjoiRGlzYWJsZWQiLCJ5YXdfbW9kaWZpZXJfTW92aW5nIjoiRGlzYWJsZWQiLCJ5YXdfbW9kaWZpZXJfU2xvd3dhbGsiOiJEaXNhYmxlZCIsInlhd19tb2RpZmllcl9TdGFuZGluZyI6IkRpc2FibGVkIiwieWF3X21vZGlmaWVyX3ZhbHVlX0FpciI6MC4wLCJ5YXdfbW9kaWZpZXJfdmFsdWVfQWlyIGR1Y2siOjAuMCwieWF3X21vZGlmaWVyX3ZhbHVlX0Nyb3VjaGluZyBDVCI6MC4wLCJ5YXdfbW9kaWZpZXJfdmFsdWVfQ3JvdWNoaW5nIFQiOjAuMCwieWF3X21vZGlmaWVyX3ZhbHVlX0dsb2JhbCI6MzAuMCwieWF3X21vZGlmaWVyX3ZhbHVlX0xlZ2l0IGFhIjowLjAsInlhd19tb2RpZmllcl92YWx1ZV9Nb3ZpbmciOjAuMCwieWF3X21vZGlmaWVyX3ZhbHVlX1Nsb3d3YWxrIjowLjAsInlhd19tb2RpZmllcl92YWx1ZV9TdGFuZGluZyI6MC4wfQ==")

groups.main.config_system:button("                      Load default config                       ", function()
    local status, error = pcall(configs.import, default_config)
    if status then
        common.add_notify(script_db.lua_name, "Succesfully loaded default config")
    else
        common.add_notify(script_db.lua_name, "Error while loading default config (" .. error .. ")")
    end
end)



groups.main.config_system:button("                Export config to clipboard                ", function()
    local status, error = pcall(configs.export)
    if status then
        common.add_notify(script_db.lua_name, "Succesfully exported settings to clipboard")
    else
        common.add_notify(script_db.lua_name, "Error while exporting settings to clipboard (" .. error .. ")")
    end
end)

groups.main.config_system:button("             Import config from clipboard             ", function()
    local data = clipboard.get()

    local status, error = pcall(configs.import, data)
    if status then
        common.add_notify(script_db.lua_name, "Succesfully imported settings from clipboard")
    else
        common.add_notify(script_db.lua_name, "Error while importing config (" .. error .. ")")
    end
end)

groups.main.config_system:button("                             Join discord                              ", function() -- button is clicked copy discord link
    js.OpenExternalBrowserURL("https://discord.gg/7XYTUJSfxJ")
end)
groups.main.config_system:button("                               Ye4 Config                              ", function() -- button is clicked copy discord link
    js.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=pW1jSR&edit=1")
end)

menu.gears = {}

UI.push( { element = groups.aimbot.main:selectable("Aimbot elements", { 'Hitchances', "Other" }), index = 'aimbot_elements', flags = '' } )

UI.push( { element = groups.aimbot.hitchances:switch("Air"), index = 'hitchance_air_enable', flags = '', conditions = {
    function() return UI.contains('aimbot_elements', 'Hitchances') end
} } )

menu.gears.air_hc = UI.get_element('hitchance_air_enable'):create()

UI.push( { element = menu.gears.air_hc:slider("Hitchance\nair", 0, 100, 50), index = 'hitchance_air', flags = '', conditions = {
    function() return UI.contains('aimbot_elements', 'Hitchances') end,
    function() return UI.get('hitchance_air_enable') end
} } )

UI.push( { element = menu.gears.air_hc:selectable("Weapons\nair", { 'Scout', 'Revolver', 'Other' }), index = 'hitchance_air_weapons', flags = '', conditions = {
    function() return UI.contains('aimbot_elements', 'Hitchances') end,
    function() return UI.get('hitchance_air_enable') end
} } )

UI.push( { element = groups.aimbot.hitchances:switch("No scope"), index = 'hitchance_noscope_enable', flags = '', conditions = {
    function() return UI.contains('aimbot_elements', 'Hitchances') end
} } )

menu.gears.noscope_hc = UI.get_element('hitchance_noscope_enable'):create()

UI.push( { element = menu.gears.noscope_hc:slider("Hitchance\nnoscope", 0, 100, 50), index = 'hitchance_noscope', flags = '', conditions = {
    function() return UI.contains('aimbot_elements', 'Hitchances') end,
    function() return UI.get('hitchance_noscope_enable') end
} } )

UI.push( { element = menu.gears.noscope_hc:selectable("Weapons\nnoscope", { 'Auto', 'Scout', 'Other' }), index = 'hitchance_noscope_weapons', flags = '', conditions = {
    function() return UI.contains('aimbot_elements', 'Hitchances') end,
    function() return UI.get('hitchance_noscope_enable') end
} } )

UI.push( { element = groups.aimbot.other:selectable("Doubletap options", { "Faster doubletap", "Adaptive recharge", "Predict dt damage" }), index = 'doubletap_options', flags = '', conditions = {
    function() return UI.contains('aimbot_elements', "Other") end
} } )
UI.push( { element = groups.aimbot.other:switch("Ideal tick"), index = 'idealtick', flags = '', conditions = {
} } )

UI.get_element('idealtick'):set_tooltip("it Enables your doubletap, autopeek, freestand, safepoint head and instant recharge using one bind")

UI.push( { element = groups.aimbot.other:selectable("Ideal tick options", {
   "freestand", "doubletap", "safepoint head", "instant recharge" }), index = 'idealtick_options', flags = '', conditions = {
} } )

UI.push( { element = groups.anti_aim.main:switch("Enable antiaim settings"), index = 'antiaim_settings', flags = '', conditions = {
} } )

UI.get_element('antiaim_settings'):set_tooltip("Enables aimbot settings")

UI.push( { element = groups.anti_aim.main:combo("Body yaw type", { "Smart", "Jitter", "Avoidance", "Custom" }), index = 'antiaim_presets', flags = '', conditions = {
    function() return UI.get('antiaim_settings') end
} } )

-- UI.push( { element = groups.anti_aim.main:combo("Yaw base", { "Forward", "Backward", "Right", "Left", "At target", "Freestanding" }), index = 'yaw_base', flags = '', conditions = {
--     function() return UI.get('antiaim_settings') end
-- } } )

UI.push( { element = groups.anti_aim.main:combo("Active condition", global_vars.plr_conditions), index = 'condition_selector', flags = '-', conditions = {
    function() return UI.get('antiaim_settings') end,
    function() return UI.get('antiaim_presets') == "Custom" end
} } )

UI.push( { element = groups.anti_aim.main:combo("Slow walk type", { "Old", "New", "Hybrid" }), index = 'slowwalk_type', flags = '', conditions = {
    function() return UI.get('antiaim_settings') end,
    function() return UI.get('antiaim_presets') == "Smart" end
} } )

UI.push( { element = groups.anti_aim.main:switch("Freestanding"), index = 'freestanding_key', flags = '', conditions = {
    function() return UI.get('antiaim_settings') end
} } )

UI.push( { element = groups.anti_aim.main:switch("Disable Freestanding In Air"), index = 'freestanding_air', flags = '', conditions = {
    function() return UI.get('antiaim_settings') end
} } )

UI.push( { element = groups.anti_aim.main:switch("Massive Fake Exploit"), index = 'massive_fake_key', flags = '', conditions = {
    function() return UI.get('antiaim_settings') end
} } )

-- UI.push( { element = groups.anti_aim.main:switch("Antibackstab"), index = 'antibackstab', flags = '', conditions = {
--     function() return UI.get('antiaim_settings') end
-- } } )

UI.push( { element = groups.anti_aim.main:switch("Teleport in air"), index = 'teleport_inair', flags = '', conditions = {
    function() return UI.get('antiaim_settings') end
} } )

-- UI.push( { element = groups.anti_aim.main:switch("Break extrapolation"), index = 'break_extrapolation', flags = '', conditions = {
--     function() return UI.get('antiaim_settings') end
-- } } )

-- UI.get_element('break_extrapolation'):set_tooltip("Attempts to break enemies extrapolation/dt prediction")

UI.push( { element = groups.anti_aim.main:switch("Experimental anti bruteforce"), index = 'experimental_antibruteforce', flags = '', conditions = {
    function() return UI.get('antiaim_settings') end
} } )

UI.push( { element = groups.anti_aim.main:switch("Warmup anti-aim"), index = 'warmup_aa', flags = '', conditions = {
    function() return UI.get('antiaim_settings') end
} } )

UI.push( { element = groups.anti_aim.main:switch("Legit desync (bind)"), index = 'legitaa_key', flags = '', conditions = {
    function() return UI.get('antiaim_settings') end
} } )

UI.push( { element = groups.anti_aim.main:switch("Legit desync at-targets"), index = 'legitaa_at_targets', flags = '', conditions = {
    function() return UI.get('antiaim_settings') end
} } )

--UI.push( { element = groups.anti_aim.main:combo("Manual Side", { "None", "Left", "Right" }), index = 'manual_side', flags = '', conditions = {
--   function() return UI.get('antiaim_settings') end
--} } )

for i = 1, #global_vars.plr_conditions do
    local condition = global_vars.plr_conditions[i]

    local base_argument = function() return ( UI.get('antiaim_presets') == "Custom" and condition == UI.get('condition_selector') ) and UI.get('antiaim_settings') end
  
    UI.push( { element = groups.anti_aim.builder:switch("Enable condition"), index = 'preset_enable_' .. condition, flags = '', conditions = {
        base_argument,
        function() return i ~= 1 end
    } } )

    base_argument = function() return ( UI.get('antiaim_presets') == "Custom" and condition == UI.get('condition_selector') ) and UI.get('antiaim_settings') and (i == 1 and true or UI.get('preset_enable_' .. condition)) end

    UI.push( { element = groups.anti_aim.builder:combo("Yaw Add Type", { "Static", "Jitter", "Random" }), index = 'yaw_add_type_' .. condition, flags = '', conditions = {
        base_argument
    } } )

    UI.push( { element = groups.anti_aim.builder:slider("Yaw Add Left", -180, 180, 0), index = 'yaw_add_left_' .. condition, flags = '', conditions = {
        base_argument
    } } )

    UI.push( { element = groups.anti_aim.builder:slider("Yaw Add Right", -180, 180, 0), index = 'yaw_add_right_' .. condition, flags = '', conditions = {
        base_argument
    } } )

    UI.push( { element = groups.anti_aim.builder:combo("Yaw Modifier", { "Disabled", "Center", "Offset", "Random", "Spin" }), index = 'yaw_modifier_' .. condition, flags = '', conditions = {
        base_argument
    } } )

    UI.push( { element = groups.anti_aim.builder:slider("Modifier Degree", -180, 180, 0), index = 'yaw_modifier_value_' .. condition, flags = '', conditions = {
        base_argument,
        function() return UI.get('yaw_modifier_' .. condition) ~= 'Disabled' end
    } } )

    UI.push( { element = groups.anti_aim.builder:combo("Fake Limit Type", { "Static", "Jitter", "Random" }), index = 'fake_limit_type_' .. condition, flags = '', conditions = {
        base_argument
    } } )

    UI.push( { element = groups.anti_aim.builder:slider("Fake Limit Left", 0, 60, 60), index = 'fake_limit_left_' .. condition, flags = '', conditions = {
        base_argument
    } } )

    UI.push( { element = groups.anti_aim.builder:slider("Fake Limit Right", 0, 60, 60), index = 'fake_limit_right_' .. condition, flags = '', conditions = {
        base_argument
    } } )

    UI.push( { element = groups.anti_aim.builder:slider("Jitter Value", 0, 60, 60), index = 'fake_limit_jitter_' .. condition, flags = '', conditions = {
        base_argument,
        function() return UI.get('fake_limit_type_' .. condition) == 'Jitter' end
    } } )

    UI.push( { element = groups.anti_aim.builder:slider("Random Min Value", 0, 60, 60), index = 'fake_limit_random_' .. condition, flags = '', conditions = {
        base_argument,
        function() return UI.get('fake_limit_type_' .. condition) == "Random" end
    } } )

    UI.push( { element = groups.anti_aim.builder:selectable("Fake Options", { "Avoid overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce" }), index = 'fake_options_' .. condition, flags = '', conditions = {
        base_argument
    } } )

    UI.push( { element = groups.anti_aim.builder:combo("LBY Mode", { "Disabled", "Opposite", "Sway" }), index = 'lby_mode_' .. condition, flags = '', conditions = {
        base_argument
    } } )

    UI.push( { element = groups.anti_aim.builder:combo("Freestanding Desync", { "Off", "Peek Fake", "Peek Real" }), index = 'freestanding_mode_' .. condition, flags = '', conditions = {
        base_argument
    } } )

    UI.push( { element = groups.anti_aim.builder:combo("Desync On Shot", { "Disabled", "Opposite", "Freestanding", "Switch" }), index = 'onshot_mode_' .. condition, flags = '', conditions = {
        base_argument
    } } )
end

do
    UI.get_element('yaw_add_right_Legit aa'):set(-180)
    UI.get_element('yaw_add_left_Legit aa'):set(-180)
end

local guwwno = render.load_image(network.get('https://media.discordapp.net/attachments/1072598798209138709/1072928603198730250/YE4-YAW.gif'), vector(150, 50))
groups.main.image:texture(guwwno, vector(255, 248))
groups.main.nothing:label("")

UI.push( { element = groups.visuals.main:selectable("Visual elements", {
    "Indicators", 'Ui', 'Custom scope', 'Skeet', 'Other' }), index = 'visual_elements', flags = ''
} )

UI.push( { element = groups.visuals.crosshair:combo("Indicators", {
    'Disabled', "Idealyaw (soon)", "Ye4-Yaw v3 (soon)", "Ye4-Yaw v2", "Axis", "Prediction v2 (soon)", "Acatel","bluhgang", "Ye4-Yaw v4 (soon)", "Drainyaw (soon)"}), index = 'crosshair_style', flags = '', conditions = {
    function() return UI.contains('visual_elements', "Indicators") end
} } )

UI.push( { element = groups.visuals.crosshair:color_picker("Indicators color", color(142, 165, 229,255)), index = 'indicators_color', flags = 'c', conditions = {
    function() return UI.contains('visual_elements', 'Indicators') end
} } )

UI.push( { element = groups.visuals.crosshair:combo("Arrows", { "Disabled", "Team skeet", "Ye4-Yaw"}), index = 'arrows_style', flags = '', conditions = {
    function() return UI.contains('visual_elements', "Indicators") end
} } )

UI.push( { element = groups.visuals.crosshair:color_picker("Arrows color", color(142, 165, 229,255)), index = 'arrows_color', flags = 'c', conditions = {
    function() return UI.contains('visual_elements', 'Indicators') end
} } )

UI.push( { element = groups.visuals.ui:selectable("Ui elements", { 'Watermark', 'Keybinds', 'Spectators' }), index = 'ui_elements', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Ui') end
} } )

UI.push( { element = groups.visuals.ui:combo("Ui style", { "Default", "Glow (soon)" }), index = 'ui_style', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Ui') end
} } )

UI.push( { element = groups.visuals.ui:combo("Watermark name", { "Cheat", "Custom" }), index = 'watermark_name', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Ui') end,
    function() return UI.contains('ui_elements', 'Watermark') end
} } )

UI.push( { element = groups.visuals.ui:input('name'), index = 'watermark_name_ref', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Ui') end,
    function() return UI.contains('ui_elements', 'Watermark') end,
    function() return UI.get('watermark_name') == 'Custom' end
} } )

UI.push( { element = groups.visuals.ui:combo("Avatars side", { 'Left', 'Right' }), index = 'avatar_side', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Ui') end,
    function() return UI.contains('ui_elements', 'Spectators') end
} } )

UI.push( { element = groups.visuals.ui:color_picker("Ui color", color(142, 165, 229,255)), index = 'ui_color', flags = 'c', conditions = {
    function() return UI.contains('visual_elements', 'Ui') end
} } )

UI.push( { element = groups.visuals.custom_scope:slider("Scope line length", 0, 500, 10), index = 'custom_scope_lenght', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Custom scope') end
} } )

UI.push( { element = groups.visuals.custom_scope:slider("Scope line offset", 0, 500, 70), index = 'custom_scope_offset', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Custom scope') end
} } )

UI.push( { element = groups.visuals.custom_scope:color_picker("Color", color(142, 165, 229,255)), index = 'custom_scope_color', flags = 'c', conditions = {
    function() return UI.contains('visual_elements', 'Custom scope') end
} } )

UI.push( { element = groups.visuals.custom_scope:switch("Scope inaccuracy"), index = 'custom_scope_inaccuracy', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Custom scope') end
} } )

UI.push( { element = groups.visuals.custom_scope:switch("Viewmodel in scope"), index = 'viewmodel_scope', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Custom scope') end
} } )

UI.push( { element = groups.visuals.other:switch("Static ragdolls"), index = 'static_ragdolls', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Other') end
} } )

UI.get_element('static_ragdolls'):set_tooltip("Makes it, so ragdolls stay static after players die")

UI.push( { element = groups.visuals.other:switch("Hit markers"), index = 'hitmarker', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Other') end
} } )

UI.push( { element = groups.visuals.other:selectable("Hitmarkers type",  { "+", "damage" }), index = 'hitmarker_type', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Other') end,
    function() return UI.get('hitmarker') end
} } )

UI.push( { element = groups.visuals.other:color_picker("Hitmarker color", color(255, 255, 255, 255) ), index = 'hitmarker_plus_color', flags = 'c', conditions = {
    function() return UI.contains('visual_elements', 'Other') end,
    function() return UI.get('hitmarker') end
} } )

UI.push( { element = groups.visuals.other:color_picker("Damage hitmarker color", color(255, 255, 255, 255) ), index = 'hitmarker_damage_color', flags = 'c', conditions = {
    function() return UI.contains('visual_elements', 'Other') end
} } )

UI.push( { element = groups.visuals.logs:switch("Event logs"), index = 'logs', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Skeet') end
} } )

UI.push( { element = groups.visuals.logs:switch("Rainbow Bar"), index = 'rainbow', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Skeet') end
} } )

UI.push( { element = groups.visuals.logs:switch("Trash Talk"), index = 'trash', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Skeet') end
} } )

UI.push( { element = groups.visuals.logs:switch("Spectators"), index = 'spectators', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Skeet') end
} } )

UI.push( { element = groups.visuals.logs:switch("Debug Info"), index = 'debug_info', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Skeet') end
} } )

UI.push( { element = groups.visuals.logs:switch("Left Hand Knife"), index = 'left_hand', flags = '', conditions = {
    function() return UI.contains('visual_elements', 'Skeet') end
} } )

-- UI.push( { element = groups.visuals.logs:selectable("Animation Breaker",{ 'Ground', 'Air', 'Zero Pitch on Land' }), index = 'anim_break', flags = '', conditions = {
--     function() return UI.contains('visual_elements', 'Skeet') end
-- } } )

UI.push( { element = groups.visuals.main:switch("Clantag"), index = 'clantag', flags = '', conditions = {
} } )

UI.get_element('clantag'):set_tooltip("synced clantag used to represent the strongest lua script on neverlose forums!")

UI.push( { element = groups.visuals.main:switch("Kill say"), index = 'killsay', flags = '', conditions = {
} } )

helpers.dragging_fn = function(name, base_x, base_y)
    return (function()
        local a = {}
        local b, c, f, g, h, i, k, l, m, n, o
        local d, j = {}, {}
        local p = {__index = {drag = function(self, ...)
                    local q, r = self:get()
                    local s, t = a.drag(q, r, ...)
                    if q ~= s or r ~= t then
                        self:set(s, t)
                    end
                    return s, t
                end, set = function(self, q, r)
                    local j = render.screen_size()
                    self.x_reference:set(q / j.x * self.res)
                    self.y_reference:set(r / j.y * self.res)
                end, get = function(self)
                    local j = render.screen_size()
                    return self.x_reference:get() / self.res * j.x, self.y_reference:get() / self.res * j.y
                end}}
        function a.new(u, v, w, x)
            x = x or 10000
            local j = render.screen_size()
            local y = groups.main.info:slider(u .. ' window position', 0, x, v / j.x * x)
            local z = groups.main.info:slider(u .. ' window position y', 0, x, w / j.y * x)
            y:set_visible(false)
            z:set_visible(false)
            return setmetatable({name = u, x_reference = y, y_reference = z, res = x}, p)
        end
        function a.drag(q, r, A, B, C, D, E)
            if globals.framecount ~= b then
                c = ui.get_alpha() > 0
                f, g = d.x, d.y
                d = ui.get_mouse_position()
                i = h
                h = common.is_button_down(0x1) == true
                m = l
                l = {}
                o = n
                n = false
                j = render.screen_size()
            end
            if c and i ~= nil then
                if (not i or o) and h and f > q and g > r and f < q + A and g < r + B then
                    n = true
                    q, r = q + d.x - f, r + d.y - g
                    if not D then
                        q = math.max(0, math.min(j.x - A, q))
                        r = math.max(0, math.min(j.y - B, r))
                    end
                end
            end
            table.insert(l, {q, r, A, B})
            return q, r, A, B
        end
        return a
    end)().new(name, base_x, base_y)
end

local handle_aa = {}

handle_aa.vars = {
    player_state = 1,
    player_condition = 'global',
    second_condition = 'Normal',
    antiaim_state = { 'global', 'Normal' },
    bestenemy = 0,
    best_value = false,
    desync_value = 0
}

handle_aa.player_state = function()
    local localplayer = entity.get_local_player()
    if localplayer == nil then return end
    local team = localplayer.m_iTeamNum
    local onground = helpers.on_ground( localplayer ) and not common.is_button_down(0x20)
    local legit_aa = UI.get('legitaa_key')
    local velocity = helpers.get_velocity( localplayer )
    local crouched = helpers.is_crouching( localplayer ) and onground
    local flags = localplayer.m_fFlags --263 crouch, 257 on ground, 256 in air
    local slowwalking = ref.slowwalk:get() and onground and velocity > 2 and not crouched
    local inair_crouch = helpers.in_air( localplayer ) and not onground and flags == 262
    local inair = helpers.in_air( localplayer ) and not onground
    local fakeducking = ref.fakeduck:get() and onground

    if inair_crouch then
        handle_aa.vars.player_state = 7
    elseif inair then
        handle_aa.vars.player_state = 8
    end
    if onground and velocity > 2 and flags ~= 256 and flags ~= 263 and not fakeducking then
        handle_aa.vars.player_state = 3
    end
    if onground and velocity < 2 and flags ~= 256 and flags ~= 263 and not fakeducking then
        handle_aa.vars.player_state = 2
    end
    if ( team == 3 and crouched ) or ( team == 3 and fakeducking ) then
        handle_aa.vars.player_state = 5
    end
    if ( team == 2 and crouched ) or ( team == 2 and fakeducking ) then
        handle_aa.vars.player_state = 4
    end
    if slowwalking and not fakeducking then
        handle_aa.vars.player_state = 6
    end
    if legit_aa then
        handle_aa.vars.player_state = 9
    end

    handle_aa.vars.player_condition = global_vars.plr_conditions[handle_aa.vars.player_state]

    handle_aa.vars.antiaim_state = { handle_aa.vars.player_condition, handle_aa.vars.second_condition }
end

handle_aa.get_best_side = function( fsmode )
    local localplayer = entity.get_local_player()
    if not localplayer then return end

    local eye_pos = localplayer:get_eye_position()

    local enemies = entity.get_players(true)

    handle_aa.vars.bestenemy = helpers.get_nearest_enemy(localplayer, enemies)

    local enemy = handle_aa.vars.bestenemy ~= nil and entity.get(handle_aa.vars.bestenemy) or nil

    if handle_aa.vars.bestenemy ~= nil and handle_aa.vars.bestenemy ~= 0 and enemy:is_alive() and fsmode ~= nil then
        local e_x, e_y, e_z = enemy:get_hitbox_position(0).x, enemy:get_hitbox_position(0).y, enemy:get_hitbox_position(0).z

        local yaw = helpers.calc_angle(eye_pos.x, eye_pos.y, e_x, e_y)
        local rdir_x, rdir_y, rdir_z = helpers.angle_vector(0, (yaw + 90))
        local rend_x = eye_pos.x + rdir_x * 10
        local rend_y = eye_pos.y + rdir_y * 10
  
        local ldir_x, ldir_y, ldir_z = helpers.angle_vector(0, (yaw - 90))
        local lend_x = eye_pos.x + ldir_x * 10
        local lend_y = eye_pos.y + ldir_y * 10
  
        local r2dir_x, r2dir_y, r2dir_z = helpers.angle_vector(0, (yaw + 90))
        local r2end_x = eye_pos.x + r2dir_x * 100
        local r2end_y = eye_pos.y + r2dir_y * 100

        local l2dir_x, l2dir_y, l2dir_z = helpers.angle_vector(0, (yaw - 90))
        local l2end_x = eye_pos.x + l2dir_x * 100
        local l2end_y = eye_pos.y + l2dir_y * 100
  
        local ldamage = helpers.get_damage(localplayer, enemy, rend_x, rend_y, eye_pos.z)
        local rdamage = helpers.get_damage(localplayer, enemy, lend_x, lend_y, eye_pos.z)

        local l2damage = helpers.get_damage(localplayer, enemy, r2end_x, r2end_y, eye_pos.z)
        local r2damage = helpers.get_damage(localplayer, enemy, l2end_x, l2end_y, eye_pos.z)

        if ( fsmode == 'Freestanding' ) or ( fsmode == 'Reversed Freestanding' ) then
            if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
                handle_aa.vars.best_value = fsmode == 'Freestanding' and false or true
            elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
                handle_aa.vars.best_value = fsmode == 'Freestanding' and true or false
            end
        end
    else
        handle_aa.vars.best_value = true
    end

    return handle_aa.vars.best_value
end

handle_aa.legitaa = {}

handle_aa.legitaa.vars = {
    classnames = {
        'CWorld',
        'CCSPlayer',
        'CFuncBrush'
    },
    on_bombsite = false
}

handle_aa.legitaa.check_bombsite = function(e, event_name)
    local localplayer = entity.get_local_player()
    if not localplayer then return end

    local user_id = entity.get(e.userid, true)

    if user_id == localplayer then
        if event_name == "enter_bombzone" then
            handle_aa.legitaa.vars.on_bombsite = true
        end

        if event_name == "exit_bombzone" then
            handle_aa.legitaa.vars.on_bombsite = false
        end
    end
end

helpers.entity_has_c4 = function(ent)
    local bomb = entity.get_entities('CC4')[1]
    return bomb ~= nil and bomb.m_hOwnerEntity == ent
end
handle_aa.legitaa.handle = function(e)
    local plocal = entity.get_local_player()
    if not plocal then return end
    local distance = 100
    local bomb = entity.get_entities("CPlantedC4")[1]

    local bomb_pos = bomb ~= nil and bomb.m_vecOrigin or { x = nil }

    if bomb_pos.x ~= nil then
        local player_pos = plocal.m_vecOrigin
        distance = player_pos:dist(bomb_pos)
    end
  
    local team_num = plocal.m_iTeamNum
    local defusing = team_num == 3 and distance < 70

    local on_bombsite = plocal.m_bInBombZone
  
    local has_bomb = helpers.entity_has_c4(plocal) == 49
  
    local eye_pos = plocal:get_eye_position()
    local viewangles = render.camera_angles()

    local sin_pitch = math.sin(math.rad(viewangles.x))
    local cos_pitch = math.cos(math.rad(viewangles.x))
    local sin_yaw = math.sin(math.rad(viewangles.y))
    local cos_yaw = math.cos(math.rad(viewangles.y))

    local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

    local traced = utils.trace_line(eye_pos, vector(eye_pos.x + (dir_vec[1] * 8192), eye_pos.y + (dir_vec[2] * 8192), eye_pos.z + (dir_vec[3] * 8192)), plocal, 0xFFFFFFFF)

    local using = true

    if traced ~= nil then
        for i=0, #handle_aa.legitaa.vars.classnames do
            if traced.entity ~= nil and traced.entity:get_classname() == handle_aa.legitaa.vars.classnames[i] then
                using = false
            end
        end
    end

    local near_door = false

    -- if plocal:is_alive() then
    --     for yaw = 18, 360, 18 do
    --         yaw = helpers.normalize_yaw(yaw)

    --         local my_eye_position = plocal:get_eye_position()
    --         local final_angle = vector(0, yaw, 0)

    --         local final_point = my_eye_position + Cheat.AngleToForward(final_angle) * 0x60
    --         local trace_info = utils.trace_line(my_eye_position, final_point, plocal, 0x200400B)
    --         local hit_entity = trace_info.entity

    --         if hit_entity ~= nil then
    --             if hit_entity:get_classname() == "CPropDoorRotating" then
    --                 near_door = true
    --             end
    --         end
    --     end
    -- end

    if ((on_bombsite and not defusing) or (not using and not defusing)) and not near_door then
        e.in_use = 0
    end
end

handle_aa.set_antiaim = function(e)
    local localplayer = entity.get_local_player()
    if not localplayer then return end
    local onGround = helpers.on_ground(localplayer)
    local ticks = cvar.sv_maxusrcmdprocessticks;
    -- local flags = localplayer.m_fFlags
    -- local inverter_state = rage.antiaim:get_rotation(true) < 0
    -- local lp_bodyyaw = localplayer.m_flPoseParameter[11] * 120 - 60

    local lp_bodyyaw = localplayer.m_flPoseParameter[11] * 120 - 60

    local handle_value_offset = function(left_value, right_value)
        if e.choked_commands == 0 then
            handle_aa.vars.desync_value = lp_bodyyaw
        end
        return handle_aa.vars.desync_value > 0 and left_value or right_value
    end

    local set_values = function(args)
        local mode = args.mode
        local table = args.settings
        if mode == 'hidden' then
            ref.yaw.offset:override(table[1])
            ref.yaw_modifier.mode:override(table[2])
            ref.yaw_modifier.offset:override(table[3])
            ref.body_yaw.left_limit:override(table[4])
            ref.body_yaw.right_limit:override(table[5])
            ref.body_yaw.fake_options:override(table[6])
            ref.body_yaw.desync_freestand:override(table[7])
            ref.body_yaw.inverter:override(table[8])
            ref.body_yaw.lby_mode:override(table[9])
        else
            ref.yaw.offset:set(table[1])
            ref.yaw_modifier.mode:set(table[2])
            ref.yaw_modifier.offset:set(table[3])
            ref.body_yaw.left_limit:set(table[4])
            ref.body_yaw.right_limit:set(table[5])
            ref.body_yaw.fake_options:set(table[6])
            ref.body_yaw.desync_freestand:set(table[7])
            ref.body_yaw.inverter:set(table[8])
            ref.body_yaw.lby_mode:set(table[9])
        end
    end

    local legitaa_on = handle_aa.vars.antiaim_state[1] == 'Legit aa'

    if legitaa_on then
        handle_aa.legitaa.handle(e)
    end

    local yaw_value = 'Backward'
    local yaw_base = 'At Target'
    local pitch = 'Down'

    if legitaa_on then
        if not UI.get('legitaa_at_targets') then
            yaw_base = 'Local View'
        end
        pitch = 'Disabled'
    end

    if (UI.get('freestanding_key') or (UI.get('idealtick') and UI.contains('idealtick_options', 0))) and not legitaa_on then
        if (UI.get("freestanding_air")) then
        ref.freestanding.switch:set(not helpers.in_air( localplayer ))
        else
        ref.freestanding.switch:set(true)
        end
    else
        ref.freestanding.switch:set(false)
    end

    ref.yaw.base:set(yaw_base)
    ref.pitch:set(pitch)
    ref.yaw.mode:set(yaw_value)

    if UI.get('massive_fake_key') and not (ref.doubletap.switch:get() or ref.hide_shots.switch:get()) and not legitaa_on then
        handle_aa.vars.second_condition = 'Massive fake'
        local side = handle_aa.get_best_side("Freestanding")
        ref.body_yaw.switch:set(false)
        ref.fakelag.switch:set(false)
        e.send_packet = false;
      
        ticks:int(17)

        ref.yaw.offset:override(nil)

        if e.choked_commands > 1 and e.choked_commands < ticks:int() then
            ref.yaw.offset:override(side and 90 or -90)
        end

        set_values({ settings = {
            side and -15 or 15, 'Disabled', 0, 59, 59, {}, 'Off', false, 'Disabled'
        }})
    elseif UI.get('warmup_aa') and entity.get_game_rules().m_bWarmupPeriod and not legitaa_on then
        set_values({ settings = {
            0, 'Disabled', 0, 59, 59, {}, 'Off', false, 'Disabled'
        }})
    else
        handle_aa.vars.second_condition = 'Normal'
        ticks:int(16)
        if UI.get('antiaim_presets') == 'Custom' then
            ref.body_yaw.inverter:set(false)
            local condition = UI.get('preset_enable_' .. handle_aa.vars.antiaim_state[1]) and global_vars.plr_conditions[handle_aa.vars.player_state] or global_vars.plr_conditions[1]

            local yaw = handle_value_offset(UI.get('yaw_add_left_' .. condition), UI.get('yaw_add_right_' .. condition))
            local fakelimit_right = UI.get('fake_limit_right_' .. condition)
            local fakelimit_left = UI.get('fake_limit_left_' .. condition)

            if UI.get('yaw_add_type_' .. condition) == 'Jitter' then
                yaw = utils.random_int(0, 1) == 1 and UI.get('yaw_add_right_' .. condition) or UI.get('yaw_add_left_' .. condition)
            elseif UI.get('yaw_add_type_' .. condition) == 'Random' then
                yaw = utils.random_int(UI.get('yaw_add_right_' .. condition), UI.get('yaw_add_left_' .. condition))
            end

            if UI.get('fake_limit_type_' .. condition) == 'Jitter' then
                if utils.random_int(0, 1) == 1 then
                    fakelimit_right = UI.get('fake_limit_right_' .. condition)
                    fakelimit_left = UI.get('fake_limit_left_' .. condition)
                else
                    fakelimit_right = UI.get('fake_limit_jitter_' .. condition)
                    fakelimit_left = UI.get('fake_limit_jitter_' .. condition)
                end
            elseif UI.get('fake_limit_type_' .. condition) == 'Random' then
                fakelimit_right = utils.random_int(UI.get('fake_limit_random_' .. condition), UI.get('fake_limit_right_' .. condition))
                fakelimit_left = utils.random_int(UI.get('fake_limit_random_' .. condition), UI.get('fake_limit_left_' .. condition))
            end

            ref.body_yaw.on_shot_desync:set(UI.get('onshot_mode_' .. condition))

            set_values({ settings = {
                yaw,
                UI.get('yaw_modifier_' .. condition),
                UI.get('yaw_modifier_value_' .. condition),
                fakelimit_left, fakelimit_right,
                UI.get('fake_options_' .. condition),
                UI.get('freestanding_mode_' .. condition),
                false,
                UI.get('lby_mode_' .. condition)
            }})
        else
            local anti_aim_values = {
                [ 'Standing' ] = {
                    0, 'Disabled', 0, 0, 0, {}, 'Off', false, 'Disabled'
                },
                [ 'Moving' ] = {
                    0, 'Disabled', 0, 0, 0, {}, 'Off', false, 'Disabled'
                },
                [ 'Crouching T' ] = {
                    0, 'Disabled', 0, 0, 0, {}, 'Off', false, 'Disabled'
                },
                [ 'Crouching CT' ] = {
                    0, 'Disabled', 0, 0, 0, {}, 'Off', false, 'Disabled'
                },
                [ 'Slowwalk' ] = {
                    0, 'Disabled', 0, 0, 0, {}, 'Off', false, 'Disabled'
                },
                [ 'Air duck' ] = {
                    0, 'Disabled', 0, 0, 0, {}, 'Off', false, 'Disabled'
                },
                [ 'Air' ] = {
                    0, 'Disabled', 0, 0, 0, {}, 'Off', false, 'Disabled'
                },
                [ 'Legit aa' ] = {
                    0, 'Disabled', 0, 0, 0, {}, 'Off', false, 'Disabled'
                },
                [ 'Global' ] = {
                    0, 'Disabled', 0, 0, 0, {}, 'Off', false, 'Disabled'
                }
            }
            if not legitaa_on then
                local exp_antibruteforce = UI.get('experimental_antibruteforce')
                if UI.get('antiaim_presets') == 'Smart' then
                    local random = utils.random_int(0, 1)
                    if UI.get('slowwalk_type') == 0 then
                        anti_aim_values[ 'Slowwalk' ] = {
                            handle_value_offset(-10, 10), 'Disabled', 0, 18, 18, exp_antibruteforce and { 'Jitter', 'Anti Bruteforce' } or 'Jitter', 'Peek Fake', false, 'Disabled'
                        }
                    elseif UI.get('slowwalk_type') == 1 then
                        local random2 = utils.random_int(3, 33)
                        anti_aim_values[ 'Slowwalk' ] = {
                            handle_value_offset(-10, 10), 'Disabled', 0, random2, random2, exp_antibruteforce and { 'Jitter', 'Anti Bruteforce' } or 'Jitter', 'Peek Fake', false, 'Disabled'
                        }
                    elseif UI.get('slowwalk_type') == 2 then
                        anti_aim_values[ 'Slowwalk' ] = {
                            handle_value_offset(-33, 33), 'Center', 6, 58, 58, 'Randomize Jitter', 'Off', false, 'Disabled'
                        }
                    end
                    anti_aim_values[ 'Standing' ] = {
                        handle_value_offset(-7, 7), 'Disabled', 0, random == 1 and 48 or 18, random == 1 and 48 or 18, { 'Jitter', 'Anti Bruteforce' }, 'Peek Fake', false, 'Disabled'
                    }
                    anti_aim_values[ 'Moving' ] = {
                        handle_value_offset(-7, 7), 'Disabled', 0, random == 1 and 48 or 18, random == 1 and 48 or 18, { 'Jitter', 'Anti Bruteforce' }, 'Peek Fake', false, 'Disabled'
                    }
                    anti_aim_values[ 'Crouching T' ] = {
                        0, 'Disabled', 0, 59, 59, exp_antibruteforce and { 'Jitter', 'Anti Bruteforce' } or 'Jitter', 'Off', true, 'Disabled'
                    }
                    anti_aim_values[ 'Crouching CT' ] = {
                        0, 'Disabled', 0, 59, 59, exp_antibruteforce and { 'Jitter', 'Anti Bruteforce' } or 'Jitter', 'Off', true, 'Disabled'
                    }
                    anti_aim_values[ 'Air duck' ] = {
                        handle_value_offset(-12, 7), 'Disabled', 0, random == 1 and 60 or 18, random == 1 and 60 or 18, 'Anti Bruteforce', 'Off', false, 'Disabled'
                    }
                    anti_aim_values[ 'Air' ] = {
                        handle_value_offset(-12, 7), 'Disabled', 0, random == 1 and 60 or 18, random == 1 and 60 or 18, 'Anti Bruteforce', 'Off', false, 'Disabled'
                    }
                elseif UI.get('antiaim_presets') == 'Jitter' then -- moving  JITTERNOWYw
                    anti_aim_values[ 'Standing' ] = {
                        0, 'Center', math.random(-68, -78), 59, 59, 'Jitter', 'Off', false, 'Disabled'
                    }
                    anti_aim_values[ 'Moving' ] = {
                        0, 'Center', math.random(-68, -78), 59, 59, 'Jitter', 'Off', false, 'Disabled'
                    }
                    anti_aim_values[ 'Crouching T' ] = {
                        0, 'Center', math.random(-68, -78), 59, 59, 'Jitter', 'Off', false, 'Disabled'
                    }
                    anti_aim_values[ 'Crouching CT' ] = {
                        0, 'Center', math.random(-68, -78), 59, 59, 'Jitter', 'Off', false, 'Disabled'
                    }
                    anti_aim_values[ 'Slowwalk' ] = {
                        0, 'Center', math.random(-68, -78), 59, 59, 'Jitter', 'Off', false, 'Disabled'
                    }
                    anti_aim_values[ 'Air duck' ] = {
                        0, 'Center', math.random(-68, -78), 59, 59, 'Jitter', 'Off', false, 'Disabled'
                    }
                    anti_aim_values[ 'Air' ] = {
                        0, 'Center', math.random(-68, -78), 59, 59, 'Jitter', 'Off', false, 'Disabled'
                    }
                elseif UI.get('antiaim_presets') == 'Avoidance' then -- jitter
                    anti_aim_values[ 'Standing' ] = {
                        handle_value_offset(-6, 7), 'Center', -88, 60, 60, 'Jitter', desync_freestand, false, 'Disabled'
                    }
                    anti_aim_values[ 'Moving' ] = {
                        handle_value_offset(-6, 7), 'Center', -88, 60, 60, 'Jitter', desync_freestand, false, 'Opposite'
                    }
                    anti_aim_values[ 'Crouching T' ] = {
                        handle_value_offset(-20, 20), 'Center', -38, 59, 59, 'Jitter', desync_freestand, false, 'Opposite'
                    }
                    anti_aim_values[ 'Crouching CT' ] = {
                        handle_value_offset(-20, 20), 'Center', -30, 59, 59, 'Jitter', desync_freestand, false, 'Opposite'
                    }
                    anti_aim_values[ 'Slowwalk' ] = {
                        handle_value_offset(-33, 33), 'Center', -8, 59, 59, 'Jitter', desync_freestand, false, 'Opposite'
                    }
                    anti_aim_values[ 'Air duck' ] = {
                        handle_value_offset(-6, 7), 'Center', -88, 60, 60, 'Jitter', desync_freestand, false, 'Opposite'
                    }
                    anti_aim_values[ 'Air' ] = {
                        handle_value_offset(-6, 7), 'Center', -88, 60, 60, 'Jitter', desync_freestand, false, 'Opposite'
                    }
                end
            else
                anti_aim_values[ 'Legit aa' ] = {
                    -180, 'Disabled', 0, 60, 60, "Off", 'Peek Fake', false, 'Opposite'
                }
            end
            set_values( { settings = anti_aim_values[handle_aa.vars.antiaim_state[1]], mode = 'hidden' } )
        end
    end

    if handle_aa.vars.antiaim_state[2] ~= 'Massive fake' then
        ref.body_yaw.switch:set(true)
        if UI.get('idealtick') then
            ref.fakelag.switch:set(false)
        else
            ref.fakelag.switch:set(true)
        end
    end
end

local visuals = {}

visuals.indicators = {}

visuals.indicators.vars = {
    dt_color = 0,
    dt_color2 = 0,
    scope_adder = 0,
    values = helpers.gram_create(0, 15),
    -- other = {
    --     Colors = {
    --         Transperent = color(255, 255, 255, 0.25*255),
    --         Black = color(0.05*255, 0.05*255, 0.05*255, 0.5*255),
    --         White = color(255, 255, 255, 255),
    --         Orange = color(255, 0.53*255, 0.26*255, 255)
    --     },
    --     Stuff = {
    --         Indicators = {
    --             Animations = {DT = {Value = 0.0}},
    --             State = {
    --                 {Preset = "/STANDING/", Colored = false},
    --                 {Preset = "/RUNNING/", Colored = false},
    --                 {Preset = "/CROUCH/", Colored = false},
    --                 {Preset = "/CROUCH/", Colored = false},
    --                 {Preset = "+TANKAA+", Colored = true},
    --                 {Preset = "/AEROBIC/", Colored = false},
    --                 {Preset = "/AEROBIC/", Colored = false},
    --                 {Preset = "/E-PEEK/", Colored = false},
    --                 {Preset = "/DORMANT/", Colored = false},
    --             }
    --         }
    --     },
    --     AntiBruteforce = {Players = {}, Time = nil},
  
  
    --     CanFire = function()
          
    --         local GetCurtime = function(a8)
    --             return globals.curtime - a8 * globals.tickinterval
    --         end
    --         local a9 = entity.get_local_player()
    --         local aa = a9:GetActiveWeapon()
    --         if not a9 or not aa then
    --             return false
    --         end
    --         if GetCurtime(-16) < a9:GetProp("m_flNextAttack") then
    --             return false
    --         end
    --         if GetCurtime(0) < aa:GetProp("m_flNextPrimaryAttack") then
    --             return false
    --         end
    --         return true
    --     end,
  
    --     Helpers = {ColorCopy = function(self, Color)
    --             return color(Color.r, Color.g, Color.b, Color.a)
    --         end, CalcMultiTextSize = function(self, ae, ...)
    --             local ao = vector(0.0, 0.0)
    --             local q = {...}
    --             local ap = {}
    --             if q[1] then
    --                 table.insert(ap, q[1])
    --             end
    --             if q[2] then
    --                 table.insert(ap, q[2])
    --             end
    --             for ac, aq in pairs(ae) do
    --                 local ar = render.measure_text(aq.Text, unpack(ap))
    --                 render.measure_text(aq.Text, unpack(ap))
    --                 ao.x = ao.x + ar.x
    --                 if ar.y > ao.y then
    --                     ao.y = ar.y
    --                 end
    --             end
    --             return ao
    --         end, MultiText = function(self, ae, ao, ...)
    --             local q = {...}
    --             local ap = {}
    --             if q[1] then
    --                 table.insert(ap, q[1])
    --             end
    --             if q[2] and type(q[2]) ~= "boolean" then
    --                 table.insert(ap, q[2])
    --             end
    --             for ac, aq in pairs(ae) do
    --                 render.text(aq.Text, ao, aq.Color, ...)
    --                 ao.x = ao.x + render.measure_text(aq.Text, unpack(ap)).x
    --             end
    --         end
    --     },
    --     v = {normalize_yaw = function(self, w)
    --         while w > 180.0 do
    --             w = w - 360.0
    --         end
    --         while w < -180.0 do
    --             w = w + 360.0
    --         end
    --         return w
    --     end, linear_interpolation = function(self, x, y, z)
    --         return x + (y - x) * z
    --     end, closest_point = function(self, A, B, C)
    --         local D = A - B
    --         local E = C - B
    --         local F = #E
    --         E = E / F
    --         local G = E:Dot(D)
    --         if G < 0.0 then
    --             return B
    --         end
    --         if G > F then
    --             return C
    --         end
    --         return B + E * Vector.new(G, G, G)
    --     end, breathe = function(self, H)
    --         H = H or 2.0
    --         local I = GlobalVars.realtime * H
    --         local J = I % (math.pi * 2.0)
    --         J = math.abs(-math.pi + J)
    --         return math.sin(J)
    --     end}
    -- }
}

local fonts = {
    font = { font = render.load_font("Verdana Bold", 11), size = 11 },
    font1 = { font = render.load_font("Verdana Bold", 10), size = 10 },
    font2 = { font = render.load_font("Arial", 11), size = 11 },
    font5 = { font = render.load_font("Arial Bold", 11), size = 11 },
    font55 = { font = render.load_font("Arial Bold", 26), size = 26 },
    font7 = { font = render.load_font("Arial", 13,"a"), size = 13 },
    fontpred = { font = render.load_font("Arial Bold", 12), size = 12 },
    fontideal = { font = render.load_font("Verdana", 12), size = 12 },
    verdana_skt = { font = render.load_font("Verdana", 13), size = 13 },
    verdana_bolde = { font = render.load_font("Verdana", 11, 'b'), size = 11 },
    blockfont = { font = render.load_font("nl\\yeayaw\\fonts\\small_fonts.ttf", 10), size = 10 },
    verdanar11 = { font =  render.load_font('Verdana', 11, 'a'), size = 11 },
    fontxd = { font = render.load_font("Verdana Bold", 23), size = 23 },
    fontxd2 = { font = render.load_font("Verdana", 12), size = 12 },
    fontdx = { font = render.load_font("nl\\yeayaw\\fonts\\pixel.ttf", 10,"o")},
    fontarrow = { font = render.load_font("nl\\yeayaw\\fonts\\ActaSymbolsW95Arrows.ttf", 21, 'a'), size = 21 },
    console = { font = render.load_font("nl\\yeayaw\\fonts\\lucida_console.ttf", 10, 'd'), size = 10 }
}

visuals.indicators.draw = function()

    local w = 25;
    local bgGap = 4;
    local screen_size = render.screen_size()
    local x = screen_size.x / 2;
    local y = screen_size.y / 2; 
    local ping_spike = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
    local is_key_pressed = common.is_button_down(0x20)
    local player = entity.get_local_player()
    if not player then
        return
    end
    local scoped = player.m_bIsScoped;
    local alpha = math.sin(math.abs(-math.pi + (globals.curtime * (1 / 0.7)) % (math.pi * 2))) * 255
    local flags = player.m_fFlags
    local localplayer = entity.get_local_player()
    local onGround = helpers.on_ground(localplayer)
    local add_y = 0;
    local numer = 0
    local is_dt = ref.doubletap.switch:get()
    local is_hs = ref.hide_shots.switch:get()
    local is_baim = ref.body_aim.mode:get()
    local is_safe = ref.safe_point:get()
    local delta = localplayer.m_flPoseParameter[11] * 120 - 60
    local chrg = rage.exploit:get()
    local inverter_state = (localplayer.m_flPoseParameter[11] * 120 - 60) > 0
    local desync_delta = localplayer.m_flPoseParameter[11] * 120 - 60

    local idealyaw_color = "";
    local idealyaw_text = "";

    if desync_delta > 55 then
        idealyaw_color = color(155, 11, 32, 255);
    else
        idealyaw_color = color(220, 135, 49, 255);
    end

     local textSize = render.measure_text(fonts.font7.font,nil,"Ye4- YAW");
     local textSize1 = render.measure_text(fonts.font7.font,nil,"Ye4- YAW");
    -- render.measure_text(1, "Ye4- YAW")

    local lp_alive = player:is_alive()

    if not lp_alive then return end

   --#endregion if UI.get('crosshair_style') == 1 then
        --local textSize = render.measure_text("REVOLUTION", 12);
      -- = render.text(fonts.fontdx.font, vector(x + 3 + baimcalc.x + 2 + safecalc.x + 2, y + 41 + numer), color(1, 1, 1, 100 / 255), "fs")

  
    --     local a = render.measure_text(">", fonts.font5.size, fonts.font5.font)
    --     local b = render.measure_text("<", fonts.font5.size, fonts.font5.font)
  
    --     if ref.base:GetInt() == 2 then
    --         render.text(">", vector(x + 40, y - a.y/2), color(220 / 255, 135 / 255, 49 / 255, 255), fonts.font55.size, fonts.font55.font)
    --         render.text("<", vector(x - 54, y - a.y/2), Color.RGBA(255,255,255,255), fonts.font55.size, fonts.font55.font)
    --     elseif ref.base:GetInt() == 3 then
    --         render.text(">", vector(x + 40, y - a.y/2), Color.RGBA(255,255,255,255), fonts.font55.size, fonts.font55.font)
    --         render.text("<", vector(x - 54, y - a.y/2),color(220 / 255, 135 / 255, 49 / 255, 255), fonts.font55.size, fonts.font55.font)
    --     end

    --     if ref.base:GetInt() == 4 then
    --         render.text("IDEAL YAW", vector((x + 25 + (w / 2)) - (textSize.x / 2), y + 28 + bgGap), color(0,0,0,1), fonts.fontideal.size, fonts.fontideal.font, false);
    --         render.text("IDEAL YAW", vector((x + 24 + (w / 2)) - (textSize.x / 2), y + 27 + bgGap), color(220 / 255, 135 / 255, 49 / 255, 255), fonts.fontideal.size, fonts.fontideal.font, false);
    --         add_y = add_y + 10;
    --     elseif ref.base:GetInt() == 5 then
    --         render.text("IDEAL YAW", vector((x + 25 + (w / 2)) - (textSize.x / 2), y + 28 + bgGap), color(0,0,0,1), fonts.fontideal.size, fonts.fontideal.font, false);
    --         render.text("IDEAL YAW", vector((x + 24 + (w / 2)) - (textSize.x / 2), y + 27 + bgGap), color(220 / 255, 135 / 255, 49 / 255, 255), fonts.fontideal.size, fonts.fontideal.font, false);
    --         add_y = add_y + 10;
    --     end

    --     if ref.base:GetInt() == 1 then
    --         render.text("FAKEYAW", vector((x + 25 + (w / 2)) - (textSize.x / 2), y + 28 + bgGap), color(0,0,0,1), fonts.fontideal.size, fonts.fontideal.font, false);
    --         render.text("FAKEYAW", vector((x + 24 + (w / 2)) - (textSize.x / 2), y + 27 + bgGap), color(207 / 255, 177 / 255, 255 / 255, 255), fonts.fontideal.size, fonts.fontideal.font, false);
    --         add_y = add_y + 10;
    --     elseif ref.base:GetInt() == 2 then
    --         render.text("FAKEYAW", vector((x + 25 + (w / 2)) - (textSize.x / 2), y + 28 + bgGap), color(0,0,0,1), fonts.fontideal.size, fonts.fontideal.font, false);
    --         render.text("FAKEYAW", vector((x + 24 + (w / 2)) - (textSize.x / 2), y + 27 + bgGap), color(207 / 255, 177 / 255, 255 / 255, 255), fonts.fontideal.size, fonts.fontideal.font, false);
    --         add_y = add_y + 10;
    --     elseif ref.base:GetInt() == 3 then
    --         render.text("FAKEYAW", vector((x + 25 + (w / 2)) - (textSize.x / 2), y + 28 + bgGap), color(0,0,0,1), fonts.fontideal.size, fonts.fontideal.font, false);
    --         render.text("FAKEYAW", vector((x + 24 + (w / 2)) - (textSize.x / 2), y + 27 + bgGap), color(207 / 255, 177 / 255, 255 / 255, 255), fonts.fontideal.size, fonts.fontideal.font, false);
    --         add_y = add_y + 10;
    --     end
    --     if ref.base:GetInt() == 5 then
    --         render.text("FREESTAND", vector((x + 25 + (w / 2)) - (textSize.x / 2), y + 28 + add_y + bgGap), color(0,0,0,1), fonts.fontideal.size, fonts.fontideal.font, false);
    --         render.text("FREESTAND", vector((x + 24 + (w / 2)) - (textSize.x / 2), y + 27 + add_y + bgGap), color(209 / 255, 139 / 255, 230 / 255, 255), fonts.fontideal.size, fonts.fontideal.font, false);
    --         add_y = add_y + 10;
    --     else
    --         render.text("DYNAMIC", vector((x + 25 + (w / 2)) - (textSize.x / 2), y + 28 + add_y + bgGap), color(0,0,0,1), fonts.fontideal.size, fonts.fontideal.font, false);
    --         render.text("DYNAMIC", vector((x + 24 + (w / 2)) - (textSize.x / 2), y + 27 + add_y + bgGap), color(209 / 255, 139 / 255, 230 / 255, 255), fonts.fontideal.size, fonts.fontideal.font, false);
    --         add_y = add_y + 10;
    --     end
  
    --     if ref.doubletap:GetBool() then
    --         if chrg < 1 then
    --             render.text("DT", vector((x + 25 + (w / 2)) - (textSize.x / 2), y + 28 + add_y + bgGap), color(0,0,0,1), fonts.fontideal.size, fonts.fontideal.font, false);
    --             render.text("DT", vector((x + 24 + (w / 2)) - (textSize.x / 2), y + 27 + add_y + bgGap), color(200 / 255, 15 / 255, 15 / 255, 255), fonts.fontideal.size, fonts.fontideal.font, false);
    --             add_y = add_y + 10;
    --         else
    --             render.text("DT", vector((x + 25 + (w / 2)) - (textSize.x / 2), y + 28 + add_y + bgGap), color(0,0,0,1), fonts.fontideal.size, fonts.fontideal.font, false);
    --             render.text("DT", vector((x + 24 + (w / 2)) - (textSize.x / 2), y + 27 + add_y + bgGap), color(15 / 255, 255 / 255, 15 / 255, 255), fonts.fontideal.size, fonts.fontideal.font, false);
    --             add_y = add_y + 10;
    --         end
    --     end
  
    --     if ref.onshotaa:GetBool() then
    --         render.text("AA", vector((x + 25 + (w / 2)) - (textSize.x / 2), y + 28 + add_y + bgGap), color(0,0,0,1), fonts.fontideal.size, fonts.fontideal.font, false);
    --         render.text("AA", vector((x + 24 + (w / 2)) - (textSize.x / 2), y + 27 + add_y + bgGap), color(209 / 255, 139 / 255, 230 / 255, 255), fonts.fontideal.size, fonts.fontideal.font, false);
    --         add_y = add_y + 10;
    --     end
  
    --     if inverter_state then
    --         render.text("B", vector((x + 25 + (w / 2)) - (textSize.x / 2), y + 28 + add_y + bgGap), color(0,0,0,1), fonts.fontideal.size, fonts.fontideal.font, false);
    --         render.text("B", vector((x + 24 + (w / 2)) - (textSize.x / 2), y + 27 + add_y + bgGap), color(15 / 255, 115 / 255, 15 / 255, 135 / 255), fonts.fontideal.size, fonts.fontideal.font, false);
    --         add_y = add_y + 10;
    --     end
    -- elseif UI.get('crosshair_style') == 2 then
    --     render.text("Ye4-YAW", vector(x - 1, y + 23 + bgGap), color(177 / 255, 171 / 255, 255 / 255, 255), fonts.font1.size, fonts.font1.font, true, true);
    --     add_y = add_y + 9; 
    --     if ref.base:GetInt() == 5 then
    --         render.text("FREESTAND", vector(x,  y + 23 + add_y + bgGap), color(209 / 255, 139 / 255, 230 / 255, 255), fonts.font1.size, fonts.font1.font, true, true);
    --         add_y = add_y + 9;
    --     else
    --         render.text("DYNAMIC",  vector(x, y + 23 + add_y + bgGap), color(209 / 255, 139 / 255, 230 / 255, 255), fonts.font1.size, fonts.font1.font, true, true);
    --         add_y = add_y + 9;
    --     end
    --     if ref.onshotaa:GetBool() then
    --         render.text("ONSHOT", vector(x, y + 23 + add_y + bgGap), color(132 / 255, 255 / 255, 16 / 255, 255), fonts.font1.size, fonts.font1.font, true, true);
    --         add_y = add_y + 9;
    --     end
    --     if ref.fakeduck:GetBool() then
    --         render.text("DUCK", vector(x, y + 23 + add_y + bgGap), color(255 / 255, 255 / 255, 255 / 255, 255), fonts.font1.size, fonts.font1.font, true, true);
    --         add_y = add_y + 9;
    --     end
    --     if is_dt then
    --         if chrg < 1 then
    --             render.text("DT", vector(x, y + 23 + add_y + bgGap), color(200 / 255, 15 / 255, 15 / 255, 255), fonts.font1.size, fonts.font1.font, true, true);
    --             add_y = add_y + 9;
    --         else
    --             render.text("DT", vector(x, y + 23 + add_y + bgGap), color(132 / 255, 255 / 255, 16 / 255, 255), fonts.font1.size, fonts.font1.font, true, true);
    --             add_y = add_y + 9;
    --         end
    --     end
  
    if UI.get('crosshair_style') == "Ye4-Yaw v2" then
     --  render.text(fonts.fontdx.font, vector(x + 3 + baimcalc.x + 2 + safecalc.x + 2, y + 41 + numer), color(1, 1, 1, 100 / 255), "fs")

       local color_ref = UI.get('indicators_color')

       render.text(fonts.font7.font, vector((x + 12 + (w / 2)) - (textSize1.x / 2) + 1, y + 20 + bgGap + 1), color(0, 0, 0, 255), nil, tostring(math.abs(math.floor(desync_delta)) .. "°"))
       render.text(fonts.font7.font, vector((x + 12 + (w / 2)) - (textSize1.x / 2), y + 20 + bgGap), color(color_ref.r, color_ref.g, color_ref.b, 255), nil, tostring(math.abs(math.floor(desync_delta)) .. "°"))
        render.gradient(vector(screen_size.x / 2, screen_size.y / 2 + 39), vector(screen_size.x / 2 + (math.abs(desync_delta * 110 / 100)), screen_size.y / 2 + 40), color_ref,color(color_ref.r, color_ref.g, color_ref.b, 0), color_ref, color(color_ref.r, color_ref.g, color_ref.b, 0))
        render.gradient(vector(screen_size.x / 2, screen_size.y / 2 + 39), vector(screen_size.x / 2 + (-math.abs(desync_delta * 110 / 100)), screen_size.y / 2 + 40), color_ref, color(color_ref.r, color_ref.g, color_ref.b, 0), color_ref, color(color_ref.r, color_ref.g, color_ref.b, 0))

        local calcv1 = render.measure_text(fonts.font7.font,nil,"Ye4-WALK")
        local calcv2 = render.measure_text(fonts.font7.font,nil,"LEGIT AA")
        local calcv3 = render.measure_text(fonts.font7.font,nil,"AUTO-DIR")
        local calcv4 = render.measure_text(fonts.font7.font,nil,"Ye4-YAW")
        local calcv5 = render.measure_text(fonts.font7.font,nil,"DMG")

        if ref.slowwalk:get() then
            render.text(fonts.font7.font, vector(x + 1 - calcv1.x/2, y + 39 + bgGap + 1), color(0, 0, 0, 255),nil,"Ye4-WALK");
            render.text(fonts.font7.font, vector(x - calcv1.x/2, y + 39 + bgGap), color(color_ref.r, color_ref.g, color_ref.b, 255),nil,"Ye4-WALK");
        elseif handle_aa.vars.antiaim_state[1] == 'Legit aa' then
            render.text(fonts.font7.font, vector(x + 1 - calcv2.x/2, y + 39 + bgGap + 1), color(0, 0, 0, 255),nil,"LEGIT AA");
            render.text(fonts.font7.font, vector(x - calcv2.x/2, y + 39 + bgGap), color(color_ref.r, color_ref.g, color_ref.b, 255),nil,"LEGIT AA");
        elseif ref.yaw.base:get() == 5 then
            render.text(fonts.font7.font, vector(x - 6 + calcv3.x/2, y + 39 + bgGap + 1), color(0, 0, 0, 255),nil,"FREESTAND");
            render.text(fonts.font7.font, vector(x - 7 + calcv3.x/2, y + 39 + bgGap), color(color_ref.r, color_ref.g, color_ref.b, 255),nil,"FREESTAND");
        else
            render.text(fonts.font7.font, vector(x + 1 - calcv4.x / 2, y + 40 + bgGap), color(0, 0, 0, 255), nil,"YE4-YAW");
            render.text(fonts.font7.font, vector(x - calcv4.x / 2, y + 39 + bgGap), color(color_ref.r, color_ref.g, color_ref.b, 255), nil,"YE4-YAW");
        end
else if UI.get('crosshair_style') == 'Axis' then
        local screen_size = render.screen_size()
        local ind_offset = 0
        local scoped = localplayer.m_bIsScoped
  
        local height = 20--ui.get(UI.get('vis_indicators_height'))
        local pos = { screen_size.x / 2, screen_size.y / 2 + height }
  
        local color_ref = UI.get('indicators_color')
  
        local name = 'Ye4'

        local main_txt = ''
  
        for i = 1, #name do
            local adder = i ~= #name and '  ' or ''
            local text = name:sub(i, i) .. adder
            main_txt = main_txt .. text
        end
  
        local maintxt_size = render.measure_text(2, 'o', main_txt)

        local desync = desync_delta
  
        local clr1 = desync > 0 and { color_ref.r, color_ref.g, color_ref.b } or { 255, 255, 255 }
        local clr2 = desync < 0 and { color_ref.r, color_ref.g, color_ref.b } or { 255, 255, 255 }

        local text = helpers.gradient_text(clr1[1], clr1[2], clr1[3], 255, clr2[1], clr2[2], clr2[3], 255, main_txt)
  
        local dtclreased = easing.quad_in_out(visuals.indicators.vars.dt_color, 0, 1, 1)
        local dtclr2eased = easing.quad_in_out(visuals.indicators.vars.dt_color2, 0, 1, 1)
        local dt_color = {255 - 255 * dtclreased * (1-dtclr2eased), 255 * dtclreased - (100 * dtclr2eased), 0 + 60 * dtclr2eased}
  
        local dtclrFT = globals.frametime * 4
        local doubletap = rage.exploit:get() == 1
        visuals.indicators.vars.dt_color = math.clamp(visuals.indicators.vars.dt_color + (doubletap and dtclrFT or -dtclrFT), 0, 1)
        visuals.indicators.vars.dt_color2 = math.clamp(visuals.indicators.vars.dt_color2 + ((ref.hide_shots.switch:get() and ref.doubletap.switch:get() and doubletap) and dtclrFT or -dtclrFT), 0, 1)
  
        local FT = globals.frametime * 3
        local scope_value = easing.quad_in_out(visuals.indicators.vars.scope_adder, 0, 1, 1)
  
        visuals.indicators.vars.scope_adder = math.clamp(visuals.indicators.vars.scope_adder + (scoped and FT or -FT), 0, 1)
  
        local adder_ = scope_value
        local bar_add, bar_add2 = 20 - 20 * adder_, 20 + 10 * adder_
        local text_ = tostring(math.floor(math.abs(desync)))
        local text_size_ = render.measure_text(2, 'o', text_)
  
        render.text(2, vector(pos[1] - 3 + (text_size_.x / 2 * adder_ + 4 - 4 * adder_) + adder_ * 6, pos[2] - 8), color(240, 240, 240, 230), 'c', text_)
  
        render.gradient(vector(pos[1] + adder_ * 3, pos[2] - 3), vector(pos[1] + adder_ * 3 + bar_add2 * (math.abs(desync) / 60), pos[2] - 3 + 1), color(color_ref.r, color_ref.g, color_ref.b, color_ref.a), color(color_ref.r, color_ref.g, color_ref.b, 0), color(color_ref.r, color_ref.g, color_ref.b, color_ref.a), color(color_ref.r, color_ref.g, color_ref.b, 0))
        render.gradient(vector(pos[1] + adder_ * 4, pos[2] - 3), vector(pos[1] + adder_ * 4 + -(bar_add * (math.abs(desync) / 60)), pos[2] - 3 + 1), color(color_ref.r, color_ref.g, color_ref.b, color_ref.a), color(color_ref.r, color_ref.g, color_ref.b, 0), color(color_ref.r, color_ref.g, color_ref.b, color_ref.a), color(color_ref.r, color_ref.g, color_ref.b, 0))
  
        ind_offset = ind_offset + 2
  
        local items = {
            [1] = { true, text, { 255, 255, 255, 255 } },
            [2] = { handle_aa.vars.antiaim_state[2] == 'Sideways Roll' or handle_aa.vars.antiaim_state[2] == 'Roll', 'ROLL', { 160, 160, 160, 255 } },
            [3] = { ref.doubletap.switch:get(), 'DT', { dt_color[1], dt_color[2], dt_color[3], 255 } },
            [4] = { ref.hide_shots.switch:get(), 'OS', { 225 - 70 * dtclr2eased, 170 - 70 * dtclr2eased, 160 - 70 * dtclr2eased, 255 } },
            [5] = { ref.freestanding.switch:get(), 'FS', { 255, 255, 255, 255 } },
            [6] = { ref.safe_point:get() == 'Force', 'SP', { 120, 200, 120, 255 } },
            [7] = { ref.body_aim.mode:get() == 'Force', 'FB', { 170, 50, 255, 255 } }
        }
  
        for i, bind in ipairs(items) do
            local text_size = render.measure_text(2, 'o', bind[2])
      
            local speed = globals.frametime * 5
            local alpha = easing.quad_in_out(visuals.indicators.vars.values[i], 0, 1, 1)
      
            local adaptive_pos = (text_size.x / 2 * scope_value) + 2 * scope_value
      
            if i == 2 then
                ind_offset = ind_offset + 1
            end
      
            adaptive_pos = math.ceil(adaptive_pos)

            visuals.indicators.vars.values[i] = math.clamp(visuals.indicators.vars.values[i] + (bind[1] and speed or -speed), 0, 1)
            render.text(2, vector(pos[1] + 1 + adaptive_pos, pos[2] + ind_offset), color(bind[3][1], bind[3][2], bind[3][3], bind[3][4] * alpha), 'c', bind[2])
      
            ind_offset = ind_offset + 8 * alpha
        end
    else if UI.get('crosshair_style') == 'bluhgang' then
        local w = render.measure_text(2, 'o', "Ye4-Yaw")
        local w2 = render.measure_text(2, 'o', "DT MUSLIM CRY")
        local w3 = render.measure_text(2, 'o', "HS DOGS CANT HIT")
        local w4 = render.measure_text(2, 'o', "DMG IQ TEST")
        local color_ref = UI.get('indicators_color')
        local binds = ui.get_binds()
        local alpha = math.sin(math.abs(-3.14 + (globals.curtime * (1 / 0.3)) % (3.14 * 2))) * 255

        render.gradient(vector(screen_size.x / 2, screen_size.y / 2 + 23), vector(screen_size.x / 2 + (math.abs(desync_delta * 50 / 100)), screen_size.y / 2 + 25), color(255, 255, 255,255),color(255, 255, 255, 0), color(255, 255, 255,255), color(255, 255, 255, 0))
      
        render.gradient(vector(screen_size.x / 2, screen_size.y / 2 + 23), vector(screen_size.x / 2 + (-math.abs(desync_delta * 50 / 100)), screen_size.y / 2 + 25), color(255, 255, 255,255), color(255,255, 255, 0), color(255, 255, 255,255), color(255, 255, 255, 0))
    
        render.text(fonts.fontdx.font, vector(x - (w.x/2)-3, y + 25), color(), nil, "Ye4-Yaw")
    
        if (is_dt) then
    
            render.text(fonts.fontdx.font, vector(x - (w2.x/2)-3, y + 35), rage.exploit:get() == 0 and color(255,178,113) or color(150,178,113), nil, "DT MUSLIM CRY")
    
        end
    
        if (not is_dt and is_hs) then
    
            render.text(fonts.fontdx.font, vector(x - (w3.x/2)-3, y + 35), color(157,165,230), nil, "HS DOGS CANT HIT")
    
        end
    
        for i = 1, #binds do
    
            if binds[i].active and binds[i].name == "Minimum Damage" then
    
                if (is_dt or is_hs) then
                render.text(fonts.fontdx.font, vector(x - (w4.x/2)-3, y + 45), color(157,209,201), nil, "DMG IQ TEST")
                else
                render.text(fonts.fontdx.font, vector(x - (w4.x/2)-3, y + 35), color(157,209,201), nil, "DMG IQ TEST")
                end
            end
    
        end

    else if UI.get('crosshair_style') == 'Acatel' then
        local w = render.measure_text(2, nil, "Ye4-YAW")
        local color_ref = UI.get('indicators_color')
        local alpha = math.sin(math.abs(-3.14 + (globals.curtime * (1 / 0.3)) % (3.14 * 2))) * 255
        render.text(fonts.fontdx.font, vector(x + 3, y + 15), color(), nil, "Ye4-YAW ")
        render.text(fonts.fontdx.font, vector(x + 40, y + 15), color(), nil, helpers.colored_text(color_ref.r,color_ref.g,color_ref.b,alpha,script_db.lua_version:upper()))

        local data = entity.get_players(true)

        if #data == 0 then
            render.text(fonts.fontdx.font, vector(x + 3, y + 23), color(244, 208, 63, 255), nil, "DORMANCY:"..helpers.colored_text(255, 255, 255, 255,"0"))
        else
            render.text(fonts.fontdx.font, vector(x + 3, y + 23), color(136, 134, 255, 255), nil, "SMART:")
            render.text(fonts.fontdx.font, vector(x + 27, y + 23), color(165, 177, 217, 255), nil, ""..helpers.colored_text(255, 95, 91, 255,inverter_state and ' RIGHT' or " LEFT"))

        end

        if is_dt and not ref.fakeduck:get() and ref.auto_peek:get() then
            local chrg = rage.exploit:get()
            local text = math.floor((chrg * 1000) / 10) .. "x"
            local color_ = {255,0,0}
            if chrg == 1 then
                text = "100x"
                color_ = {84,255,40}
            end
            render.text(fonts.fontdx.font, vector(x + 3, y + 31), color(255, 255, 255, 255), nil, "IDEALTICK "..helpers.colored_text(color_[1], color_[2], color_[3], 255,text))
          
            numer = numer + 8
        elseif is_dt then
            local chrg = rage.exploit:get()
            local text = "DT"
            local color_ = {255,0,0}
            if chrg == 1 then
                color_ = {84,255,40}
            end
            if ref.fakeduck:get() then
                text = "DT (FAKE DUCK)"
            end
            render.text(fonts.fontdx.font, vector(x + 3, y + 31), color(color_[1], color_[2], color_[3], 255), nil, text)
            numer = numer + 8
        elseif ref.hide_shots.switch:get() then
            render.text(fonts.fontdx.font, vector(x + 3, y + 31), color(227, 167, 176, 255), nil, "ONSHOT")
            numer = numer + 8
        elseif ref.fakeduck:get() then
            render.text(fonts.fontdx.font, vector(x + 3, y + 31), color(255, 255, 255, 255), nil, "FAKE DUCK")
            numer = numer + 8
        end

        local baimcalc = render.measure_text(2, nil, "BAIM")
        render.text(fonts.fontdx.font, vector(x + 3, y + 31 + numer), color(255, 255, 255, is_baim == "Force" and 255 or 100), nil, "BAIM")
        local safecalc = render.measure_text(2, nil, "SP")
        render.text(fonts.fontdx.font, vector(x + 5 + baimcalc.x, y + 31 + numer), color(255, 255, 255, is_safe == "Force" and 255 or 100), nil, "SP")
        render.text(fonts.fontdx.font, vector(x + 5 + baimcalc.x + safecalc.x, y + 31 + numer), color(255, 255, 255, ref.freestanding.switch:get() and 255 or 100), nil, "FS")
      
--[[     elseif UI.get('crosshair_style') == 8 then
        if not EngineClient.IsInGame() then
            return
        end
        local localplayer = EntityList.GetLocalPlayer()
        if not localplayer then
            return
        end
        if not localplayer:IsAlive() then
            return
        end
        local foncik = fonts.verdana_bolde.font
        local screannn = vector(helpers.screen_size.x / 2.0, helpers.screen_size.y / 2.0 + 2.0)
        local aG = AntiAim.GetInverterState()
        local aE = handle_aa.vars.player_state
        aE = visuals.indicators.vars.other.Stuff.Indicators.State[aE-1] or visuals.indicators.vars.other.Stuff.Indicators.State[3]
        local bc = color(1.0, 0.53, 0.26)
        local bd = color(1.0, 1.0, 1.0)
        local a6 = aG and bd or bc
        local a7 = aG and bc or bd
        local a4 = {{Color = a6, Text = "Ye4"}, {Color = a7, Text = "yaw°"}}
        local bm = visuals.indicators.vars.other.Helpers:CalcMultiTextSize(a4, fonts.verdana_bolde.size, fonts.verdana_bolde.font)
        local bn = vector(screannn.x - bm.x / 2.0 + 2.0, screannn.y + 14.0)
        local bo = bc.a
        bc.a = visuals.indicators.vars.other.v:breathe(1) * bo
        render.text(
            "",
            vector(screannn.x + 1.0, screannn.y - 2.0),
            bc,
            fonts.verdana_bolde.size,
            fonts.verdana_bolde.font,
            true,
            true
        )
        bc.a = bo
        render.text("Ye4-Yaw°", bn + 1.0, visuals.indicators.vars.other.Colors.Black, fonts.verdana_bolde.size, fonts.verdana_bolde.font)
        visuals.indicators.vars.other.Helpers:MultiText(a4, bn, fonts.verdana_bolde.size, fonts.verdana_bolde.font)
        screannn.y = screannn.y + bm.y + 14.0
        if visuals.indicators.vars.other.AntiBruteforce.Time ~= nil then
            local bp = 5.0
            local bq = bp + visuals.indicators.vars.other.AntiBruteforce.Time
            local br = 1.0
            if bq > GlobalVars.realtime then
                br = (bq - GlobalVars.realtime) / bp
            else
                visuals.indicators.vars.other.AntiBruteforce.Time = nil
            end
            screannn.y = screannn.y + 2.0
            local bs = vector(29.0, 3.0)
            Render.BoxFilled(
                vector(screannn.x - bs.x, screannn.y),
                vector(screannn.x + bs.x, screannn.y + bs.y),
                visuals.indicators.vars.other.Colors.Black
            )
            Render.BoxFilled(
                vector(screannn.x - bs.x + 1.0, screannn.y + 1.0),
                vector(screannn.x - bs.x + 1.0 + (bs.x - 1.0) * 2.0 * br, screannn.y + bs.y - 1.0),
                bc
            )
            screannn.y = screannn.y + bs.y
        end
        screannn.y = screannn.y + 3.0
        local bs = vector(28.0, 1.0)
        local bt = 8.0
        Render.BoxFilled(vector(screannn.x - bs.x, screannn.y), vector(screannn.x, screannn.y + bs.y), a6)
        Render.BoxFilled(vector(screannn.x + bs.x, screannn.y), vector(screannn.x, screannn.y + bs.y), a7)
        local bu = visuals.indicators.vars.other.Helpers:ColorCopy(a6)
        bu.a = 0.0
        Render.GradientBoxFilled(
            vector(screannn.x - bs.x, screannn.y),
            vector(screannn.x - bs.x + bs.y, screannn.y + bt),
            a6,
            a6,
            bu,
            bu
        )
        local bu = visuals.indicators.vars.other.Helpers:ColorCopy(a7)
        bu.a = 0.0
        Render.GradientBoxFilled(
            vector(screannn.x + bs.x, screannn.y),
            vector(screannn.x + bs.x - bs.y, screannn.y + bt),
            a7,
            a7,
            bu,
            bu
        )
        screannn.y = screannn.y + 2.0
        local bm = render.measure_text(aE.Preset, fonts.fontdx.size, fonts.fontdx.font)
        local bn = vector(screannn.x - bm.x / 2.0, screannn.y)
        render.text(aE.Preset, bn, aE.Colored and bc or bd, fonts.fontdx.size, fonts.fontdx.font, true, false)
        screannn.y = screannn.y + 9.0
        local bx = GlobalVars.frametime * 4.0
        if visuals.indicators.vars.other.CanFire() then
            visuals.indicators.vars.other.Stuff.Indicators.Animations.DT.Value =
                math.min(visuals.indicators.vars.other.Stuff.Indicators.Animations.DT.Value + bx, 1.0)
        else
            visuals.indicators.vars.other.Stuff.Indicators.Animations.DT.Value =
                math.max(visuals.indicators.vars.other.Stuff.Indicators.Animations.DT.Value - bx, 0.0)
        end
        local by = {
            [1] = {Text = "ROLL", Active = handle_aa.vars.antiaim_state[2] == 'Sideways Roll' or handle_aa.vars.antiaim_state[2] == 'Roll' },
            [2] = {Text = "FAKE", Active = handle_aa.vars.antiaim_state[2] == 'Massive fake'},
            [3] = {
                Text = "DT",
                Active = is_dt,
                Circle = visuals.indicators.vars.other.Stuff.Indicators.Animations.DT.Value
            },
            [4] = {Text = "OS", Active = is_hs},
            [5] = {Text = "SP", Active = is_safe == 2.0},
            [6] = {Text = "FB", Active = is_baim == 2.0},
            [7] = {Text = "FS", Active = ref.base:Get() == 5.0},
        }
        for bz, z in ipairs(by) do
            if not z.Active then goto aV end
            if z.Active == nil then
                goto aV
            end
            local bm = render.measure_text(z.Text, fonts.fontdx.size, fonts.fontdx.font)
            local bn = vector(screannn.x, screannn.y)
            if z.Active and z.Circle ~= nil then
                local ar = 3.3
                local bk = ar * 0.75
                Render.Circle(
                    vector(bn.x + bm.x / 2.0 + bk + 2, bn.y + bm.y / 2.0),
                    ar,
                    58.0,
                    bd,
                    1.8,
                    -180,
                    -180 + 360 * z.Circle
                )
            end
            bn.x = bn.x - bm.x / 2.0
            render.text(z.Text, bn, z.Active and bc or visuals.indicators.vars.other.Colors.Transperent, fonts.fontdx.size, fonts.fontdx.font, true, false)
            screannn.y = screannn.y + 9.0
            ::aV::
        end ]]
    end
    end
end
end
end

visuals.arrows = function()
    local localplayer = entity.get_local_player()
    if not localplayer then
        return
    end
    local inverter_state = (localplayer.m_flPoseParameter[11] * 120 - 60) > 0
  
    local w = 25
    local bgGap = 4
    local screen_size = render.screen_size()
    local x = screen_size.x / 2
    local y = screen_size.y / 2

    local arrows_color = UI.get('arrows_color')
    if UI.get('arrows_style') == "Team skeet" then
            local color1 = not inverter_state and arrows_color or color(0,0,0,75)
            local color2 = inverter_state and arrows_color or color(0,0,0,75)

            render.rect(vector(x - 48, y - 10), vector(x - 46, y + 9), color1)
            render.rect(vector(x + 47, y - 10), vector(x + 49, y + 9), color2)
        -- if ref.base:GetInt() == 2 or UI.get('roll_manual') == 2 then
        --     Render.PolyFilled(color(0, 0, 0, 0.3), vector(x - 50, y - 10), vector(x - 50, y + 9), vector(x - 66, y))
        --     Render.PolyFilled(arrows_color, vector(x + 52, y - 10), vector(x + 52, y + 9), vector(x + 66, y))
        -- elseif ref.base:GetInt() == 3 or UI.get('roll_manual') == 1 then         
        --     Render.PolyFilled(arrows_color, vector(x - 50, y - 10), vector(x - 50, y + 9), vector(x - 66, y))
        --     Render.PolyFilled(color(0, 0, 0, 0.3), vector(x + 52, y - 10), vector(x + 52, y + 9), vector(x + 66, y))
        -- else
        --     Render.PolyFilled(color(0, 0, 0, 0.3), vector(x - 50, y - 10), vector(x - 50, y + 9), vector(x - 66, y))
        --     Render.PolyFilled(color(0, 0, 0, 0.3), vector(x + 52, y - 10), vector(x + 52, y + 9), vector(x + 66, y))
            render.poly(color(0, 0, 0, 75), vector(x - 50, y - 10), vector(x - 50, y + 9), vector(x - 66, y))
            render.poly(color(0, 0, 0, 75), vector(x + 52, y - 10), vector(x + 52, y + 9), vector(x + 66, y))
        -- end
  
    elseif UI.get('arrows_style') == 'Ye4-Yaw' then
        local color1 = not inverter_state and arrows_color or color(0,0,0,75)
        local color2 = inverter_state and arrows_color or color(0,0,0,75)
        render.text(fonts.fontarrow.font, vector((x - 55), y - 18 + bgGap), color1, 'c', "w")
        render.text(fonts.fontarrow.font, vector((x + 55), y - 18 + bgGap), color2, 'c', "x")
    end
end

visuals.base_render = {
    box = function(x,y,w,h,color,rounding)
        render.rect_outline(vector(x,y), vector(x+w,y+h), color, 1, rounding == nil and 0 or rounding, false)
    end,
    box_filled = function(x,y,w,h,color,rounding)
        render.rect(vector(x,y), vector(x+w,y+h), color, rounding == nil and 0 or rounding, false)
    end,
    gradient_box_filled = function(x,y,w,h,horizontal,color,color2)
        render.gradient(vector(x,y), vector(x+w,y+h), color, color, horizontal and color2 or color, horizontal and color or color2, 0)
    end,
    string = function(x,y,cen,string,color,TYPE,font,fontsize)
        if TYPE == 0 then
            render.text(font, vector(x,y), color, cen and 'c' or '', string)
        elseif TYPE == 1 then
            render.text(font, vector(x,y), color, cen and 'c' or '', string)
        elseif TYPE == 2 then
            render.text(font, vector(x,y), color, cen and 'c' or '', string)
        end
    end,
    circle = function(x,y,rad,start,endd,color,seg,th)
        render.circle_outline(vector(x,y), color, rad, start, endd, th)
    end,
    text_size = function(string,font,fontsize)
        return render.measure_text(font, '', string)
    end
}

visuals.global_render = {
    box = function(x, y, w, colorref)
        visuals.base_render.box_filled(x,y+2,w,18,color(17,17,17,120*(colorref.a)/255),4)
        visuals.base_render.box_filled(x+3,y+1,w-6,1,color(colorref.r,colorref.g,colorref.b,colorref.a))
        visuals.base_render.circle(x+3,y+4,3,180,0.25,color(colorref.r,colorref.g,colorref.b,colorref.a),75,1)
        visuals.base_render.circle(x+w-3,y+4,3,-90,0.25,color(colorref.r,colorref.g,colorref.b,colorref.a),75,1)
        visuals.base_render.gradient_box_filled(x,y+4,1,12,false,color(colorref.r,colorref.g,colorref.b,colorref.a),color(colorref.r,colorref.g,colorref.b,0))
        visuals.base_render.gradient_box_filled(x+w-1,y+4,1,12,false,color(colorref.r,colorref.g,colorref.b,colorref.a),color(colorref.r,colorref.g,colorref.b,0))
    end
}

-- visuals.Render_engine = (function()
--     local self = {}

--     local renderer_fade = function(x, y, w, h, color, length, round)
--         local r, g, b, a = color.r, color.g, color.b, color.a

--         for i = 1, 10 do
--             Render.Box(vector(x - i, y - i), vector(w + i, h + i), color(r, g, b, (60 - (60 / length) * i) * (a / 255)), round)
--         end
--     end

--     local renderer_window = function(x, y, w, h, color, shadow_color, outline_color, left, outline)
--         local r, g, b, a = color.r, color.g, color.b, color.a
--         local r1, g1, b1, a1 = shadow_color.r, shadow_color.g, shadow_color.b, shadow_color.a
--         local r2, g2, b2, a2 = outline_color.r, outline_color.g, outline_color.b, outline_color.a

--         Render.Blur(vector(x, y), vector(w, h), color(1,1,1, a), 5)
      
--         if outline then
--             Render.Circle(vector(x + 4, y + 4), 4, 4, color(r, g, b, a), 1, -175, -90)

--             Render.BoxFilled(vector(x + 4, y), vector(w - 5, y+1), color(r, g, b, a))
--             Render.Circle(vector(w - 4, y + 4), 4, 4, color(r, g, b, a), 1, 260, 370)

--             Render.GradientBoxFilled(vector(x, y + 4), vector(x + 1, h - 6), color(r, g, b, a), color(r, g, b, a), color(r, g, b, 0), color(r, g, b, 0))
--             Render.GradientBoxFilled(vector(w - 1, y + 4), vector(w, h - 6), color(r, g, b, a), color(r, g, b, a), color(r, g, b, 0), color(r, g, b, 0))
--         end

--         Render.Box(vector(x, y), vector(w, h), color(r2, g2, b2, (80 / 255) * a2), 5)
      
--         if left then
--             Render.BoxFilled(vector(x, y + 4), vector(x+1, h - 5), color(r, g, b, a))

--             Render.Circle(vector(x + 5, y + 5), 5, 12, color(r, g, b, a), 1, -90, -165)

--             Render.Circle(vector(x + 5, h - 5), 5, 12, color(r, g, b, a), 1, -185, -255)

--             Render.GradientBoxFilled(vector(x + 4, y), vector(x+20, y+1), color(r, g, b, a), color(r, g, b, 0), color(r, g, b, a), color(r, g, b, 0))
--             Render.GradientBoxFilled(vector(x + 4, h - 1), vector(x+20, h), color(r, g, b, a), color(r, g, b, 0), color(r, g, b, a), color(r, g, b, 0))
--         end

--         Render.BoxFilled(vector(x+1, y+1), vector(w-1, h-1), color(0, 0, 0, a), 5)

--         renderer_fade(x, y, w, h, color(r1, g1, b1, (120 / 255) * a1), 10, 10)
--     end

--     self.container = function(x, y, w, h, color, name, font_size, font)
--         local name_size = render.measure_text(name, font_size, font)
--         -- Render.Blur(vector(x, y), vector(x + w + 3, y + h + 2), color(1, 1, 1, color.a), 6)
--         renderer_window(x, y, x + w + 3, y + h + 2, color(color.r, color.g, color.b, color.a), color(color.r, color.g, color.b, color.a), color(color.r, color.g, color.b, color.a), false, true)
--         render.text(name, vector(x + 1 + 1 + w / 2 + 1 - name_size.x / 2, y + 2 + 1), color(0, 0, 0, color.a), font_size, font)
--         render.text(name, vector(x + 1 + w / 2 + 1 - name_size.x / 2, y + 2), color(1, 1, 1, color.a), font_size, font)
--     end

--     return self
-- end)()

visuals.watermark = {}

visuals.watermark.draw = function()
    local speed = globals.frametime * 5
    local color_ref = UI.get('ui_color')
    local pos = { x = 0, y = 0, w = 0, h = 0 }
    pos.x, pos.y = render.screen_size().x, 0

    local offset = { x = 10, y = 10 }

    pos.x = pos.x - offset.x
    pos.y = pos.y + offset.y

    local text = ''

    local username = script_db.username

    if UI.get('watermark_name') == 'Custom' then
        username = UI.get('watermark_name_ref')
    end

    text = text .. script_db.lua_name .. ' [' .. script_db.lua_version .. '] | ' .. username .. ' | '

    local local_time = common.get_system_time()

    local time = string.format("%02d:%02d:%02d", local_time.hours, local_time.minutes, local_time.seconds)

    local ping = globals.is_in_game and math.floor(utils.net_channel().avg_latency[1] * 1000) or 0

    text = text .. 'delay: ' .. ping .. 'ms | ' .. time

    local text_size = render.measure_text(1, '', text)

    pos.x = pos.x - text_size.x
    pos.w = text_size.x
    pos.h = 16

    -- if UI.get('ui_style') == 0 then
        visuals.global_render.box(pos.x - 10, pos.y, pos.w + 10, { r = color_ref.r, g = color_ref.g, b = color_ref.b, a = 255 })

        visuals.base_render.string(pos.x - 10 + 6, pos.y + text_size.y / 2 - 1, false, text, color(255, 255, 255, 255), 1, 1)
    -- elseif UI.get('ui_style') == 1 then
    --     visuals.Render_engine.container(pos.x - 9, pos.y, pos.w + 9, pos.h, { r = color.r, g = color.g, b = color.b, a = 1 }, text, fonts.verdanar11.size, fonts.verdanar11.font)
    -- end
end

visuals.keybinds = {}

visuals.keybinds.get_keys = function()
    local binds = {}
    local cheatbinds = ui.get_binds()
  
    for i = 1, #cheatbinds do
        table.insert(binds, 1, cheatbinds[i])
    end
    return binds
end

visuals.keybinds.names = {
    ['Double Tap'] = 'Double tap',
    ['Hide Shots'] = 'On shot anti-aim',
    ['Slow Walk'] = 'Slow motion',
    ['Edge Jump'] = 'Jump at edge',
    ['Fake Ping'] = 'Ping spike',
    ['Override Resolver'] = 'Resolver override',
    ['Fake Duck'] = 'Duck peek assist',
    ['Minimum Damage'] = 'Damage override',
    ['Auto Peek'] = 'Quick peek assist',
    ['Body Aim'] = 'Force body aim',
    ['Safe Points'] = 'Safe points',
    ['Yaw Base'] = 'Yaw base',
    ['Enable Thirdperson'] = 'Thirdperson',
    ['Manual Yaw Base'] = 'Yaw base',
}

visuals.keybinds.upper_to_lower = function(str)
    local str1 = string.sub(str, 2, #str)
    local str2 = string.sub(str, 1, 1)
    return str2:upper()..str1:lower()
end

visuals.keybinds.vars = {
    alpha = {
        [ '' ] = 0
    },
    window = {
        alpha = 0,
        width = 0
    }
}

visuals.keybinds.dragging = helpers.dragging_fn('Ye4-Yaw_keybinds', helpers.screen_size.x / 1.3, helpers.screen_size.y / 2.5)

visuals.keybinds.draw = function()
    local speed = globals.frametime * 5
    local color_ref = UI.get('ui_color')
    local pos = { x = 0, y = 0, w = 0, h = 0 }
    pos.x, pos.y = visuals.keybinds.dragging:get()
    pos.x = math.ceil(pos.x)
    pos.y = math.ceil(pos.y)
    local offset = 0
    local maximum_offset = 80

    local binds = visuals.keybinds.get_keys()
    for i = 1, #binds do
        local bind = binds[i]
        local bind_name = visuals.keybinds.names[bind.name] == nil and visuals.keybinds.upper_to_lower(bind.name) or visuals.keybinds.names[bind.name]

        local bind_state = ''
        if bind.value == true then
            local bind_mode = bind.mode
            if bind_mode == 2 then
                bind_state = 'toggled'
            elseif bind_mode == 1 then
                bind_state = 'holding'
            end
        else
            bind_state = bind.value
        end
      
        if visuals.keybinds.vars.alpha[bind_name] == nil then
            visuals.keybinds.vars.alpha[bind_name] = 0
        end
      
        local alpha = easing.quad_in_out(visuals.keybinds.vars.alpha[bind_name], 0, 1, 1)
        visuals.keybinds.vars.alpha[bind_name] = math.clamp(visuals.keybinds.vars.alpha[bind_name] + (bind.active and speed or -speed), 0, 1)
      
        local bind_state_size = render.measure_text(1, nil, bind_state)
        local bind_name_size = render.measure_text(1, nil, bind_name)

        -- if UI.get('ui_style') == 0 then
            visuals.base_render.string(pos.x + 4, pos.y + 21 + offset, false, bind_name, color(255, 255, 255, alpha*255), 1, 1)
            visuals.base_render.string(pos.x + (visuals.keybinds.vars.window.width - bind_state_size.x - 10), pos.y + 20 + offset, false, '[' .. bind_state .. ']', color(255, 255, 255, alpha*255), 1, 1)
        -- elseif UI.get('ui_style') == 1 then
        --     render.text(bind_name, vector(pos.x + 4 + 1, pos.y + 21 + 1 + offset), color(0, 0, 0, alpha), fonts.verdanar11.size, fonts.verdanar11.font)
        --     render.text(bind_name, vector(pos.x + 4, pos.y + 21 + offset), color(1, 1, 1, alpha), fonts.verdanar11.size, fonts.verdanar11.font)
          
        --     render.text('[' .. bind_state .. ']', vector(pos.x + 1 + (visuals.keybinds.vars.window.width - bind_state_size.x - 10), pos.y + 20 + 1 + offset), color(0, 0, 0, alpha), fonts.verdanar11.size, fonts.verdanar11.font)
        --     render.text('[' .. bind_state .. ']', vector(pos.x + (visuals.keybinds.vars.window.width - bind_state_size.x - 10), pos.y + 20 + offset), color(1, 1, 1, alpha), fonts.verdanar11.size, fonts.verdanar11.font)
        -- end

        offset = offset + 16 * alpha

        if maximum_offset < (bind_name_size.x + bind_state_size.x) + 30 then
            maximum_offset = bind_name_size.x + bind_state_size.x + 30
        end
    end

    pos.w = math.ceil(visuals.keybinds.vars.window.width)
    pos.h = 16

    local window_alpha = easing.quad_in_out(visuals.keybinds.vars.window.alpha, 0, 1, 1)
    visuals.keybinds.vars.window.alpha = math.clamp(visuals.keybinds.vars.window.alpha + ((ui.get_alpha() > 0 or #binds > 0) and speed or -speed), 0, 1)

    visuals.keybinds.vars.window.width = helpers.lerp(visuals.keybinds.vars.window.width, maximum_offset, speed * 2)

    -- if UI.get('ui_style') == 0 then
        visuals.global_render.box(pos.x, pos.y - 2, pos.w + 2, { r = color_ref.r, g = color_ref.g, b = color_ref.b, a = window_alpha * 255 })

        local main_text = render.measure_text(1, nil, 'keybinds')
  
        visuals.base_render.string(pos.x + 1 + pos.w / 2, pos.y + main_text.y - 3, true, 'keybinds', color(255, 255, 255, window_alpha * 255), 1, 1)
    -- elseif UI.get('ui_style') == 1 then
        -- visuals.Render_engine.container(pos.x, pos.y, pos.w, pos.h, { r = color.r, g = color.g, b = color.b, a = window_alpha }, 'keybinds', fonts.verdanar11.size, fonts.verdanar11.font)
    -- end

    visuals.keybinds.dragging:drag(pos.w, (10 + (8 * #binds)) * 2)
end

visuals.spectators = {}

visuals.spectators.vars = {
    players = {},
    alpha = {
        [ '' ] = 0
    },
    window = {
        alpha = 0,
        width = 0
    },
    specs = {
        m_alpha = 0,
        m_active = {},
        m_contents = {},
        unsorted = {}
    },
}

visuals.spectators.get_spectators = function(player)
    if not globals.is_connected or not globals.is_in_game then
        return
    end
  
    local me = entity.get_local_player()
    if not me then return end

    local observing = nil

    if me:is_alive() then
        observing = me:get_spectators()
    else
        local local_target = me.m_hObserverTarget
        if not local_target then return end
        observing = local_target:get_spectators()
    end

    return observing
end

visuals.spectators.dragging = helpers.dragging_fn('Ye4-Yaw_spectators', helpers.screen_size.x / 1.5, helpers.screen_size.y / 2.5)

visuals.spectators.draw = function()
    local me = entity.get_local_player()
    local spectators = visuals.spectators.get_spectators()

    if not globals.is_connected or spectators == nil or me == nil then return end

    for i=1, 64 do
        visuals.spectators.vars.specs.unsorted[i] = {
            idx = i,
            active = false
        }
    end

    for i, spectator in pairs(spectators) do
        local idx = spectator:get_index()
        visuals.spectators.vars.specs.unsorted[idx] = {
            idx = idx,

            active = (function()
                if spectator == me then
                    return false
                end

                return true
            end)(),

            avatar = (function()
                local avatar = spectator:get_steam_avatar()

                if avatar == nil then
                    return nil
                end

                if visuals.spectators.vars.specs.m_contents[idx] == nil or visuals.spectators.vars.specs.m_contents[idx].conts ~= avatar then
                    visuals.spectators.vars.specs.m_contents[idx] = {
                        conts = avatar,
                        texture = avatar
                    }
                end

                return visuals.spectators.vars.specs.m_contents[idx].texture
            end)()
        }
    end

    local is_menu_open = ui.get_alpha() > 0
    local latest_item = false
  
    local speed = globals.frametime * 5
    local color_ref = UI.get('ui_color')
    local pos = { x = 0, y = 0, w = 0, h = 0 }
    pos.x, pos.y = visuals.spectators.dragging:get()
    pos.x = math.ceil(pos.x)
    pos.y = math.ceil(pos.y)
    local offset = 0
    local maximum_offset = 80

    for _, c_ref in pairs(visuals.spectators.vars.specs.unsorted) do
        local c_id = c_ref.idx
        local c_nickname = ''

        local c_entity = entity.get(c_id)

        if c_entity then
            c_nickname = string.sub(c_entity:get_name(), 1, 25)
        end

        if not visuals.spectators.vars.alpha[c_id] then
            visuals.spectators.vars.alpha[c_id] = 0
        end

        local ease = easing.quad_in_out(visuals.spectators.vars.alpha[c_id], 0, 1, 1)
        visuals.spectators.vars.alpha[c_id] = math.clamp(visuals.spectators.vars.alpha[c_id] + (c_ref.active and speed or -speed), 0, 1)

        if c_ref.active then
            latest_item = true

            if visuals.spectators.vars.specs.m_active[c_id] == nil then
                visuals.spectators.vars.specs.m_active[c_id] = {
                    alpha = 0, offset = 0, active = true
                }
            end

            local text_width = render.measure_text(1, nil, c_nickname)

            visuals.spectators.vars.specs.m_active[c_id].active = true
            visuals.spectators.vars.specs.m_active[c_id].offset = text_width.x + 30
            visuals.spectators.vars.specs.m_active[c_id].alpha = ease
            visuals.spectators.vars.specs.m_active[c_id].avatar = c_ref.avatar
            visuals.spectators.vars.specs.m_active[c_id].name = c_nickname

        elseif visuals.spectators.vars.specs.m_active[c_id] ~= nil then
            visuals.spectators.vars.specs.m_active[c_id].active = false
            visuals.spectators.vars.specs.m_active[c_id].alpha = ease

            if visuals.spectators.vars.specs.m_active[c_id].alpha <= 0 then
                visuals.spectators.vars.specs.m_active[c_id] = nil
            end
        end

        if visuals.spectators.vars.specs.m_active[c_id] ~= nil and visuals.spectators.vars.specs.m_active[c_id].offset > maximum_offset then
            maximum_offset = visuals.spectators.vars.specs.m_active[c_id].offset
        end
    end

    if is_menu_open and not latest_item then
        local case_name = ' '
        local text_width = 0 --renderer.measure_text(nil, case_name)

        latest_item = true
        maximum_offset = maximum_offset < text_width and text_width or maximum_offset

        visuals.spectators.vars.specs.m_active[case_name] = {
            name = ' ',
            active = true,
            offset = text_width,
            alpha = 0
        }
    end

    for c_name, c_ref in pairs(visuals.spectators.vars.specs.m_active) do
        local text_size = render.measure_text(1, nil, c_ref.name)

        -- print(c_ref.alpha)

        local adder = { text = 5 + 12 + 3, avatar = 5 }

        if UI.get('avatar_side') == 'Right' then
            adder = { text = 5, avatar = math.ceil(visuals.spectators.vars.window.width) - 5 - 12 }
        end

        visuals.base_render.string(pos.x + adder.text, pos.y + 21 + offset, false, c_ref.name, color(255, 255, 255, c_ref.alpha*255), 1, 1)
        -- renderer.text(x + 5 + ((c_ref.avatar and not right_offset) and text_size[2] + 5 or 0) + 1, y + height_offset - 5 + 5 * c_ref.alpha, 255, 255, 255, 255 * c_ref.alpha, font, w - (text_size[2] + 15), c_ref.name)
  
        if c_ref.avatar ~= nil then
            -- renderer.texture(c_ref.avatar, x + 1 + (right_offset and w - 15 or 5), y + height_offset - 5 + 5 * c_ref.alpha, text_size[2], text_size[2], 255, 255, 255, 255 * c_ref.alpha, 'f')
            render.texture(c_ref.avatar, vector(pos.x + adder.avatar, pos.y + 21 + offset), vector(12, 12), color(255, 255, 255,  c_ref.alpha*255))
        end
  
        offset = offset + (text_size.y + 3) * c_ref.alpha
    end

    pos.w = math.ceil(visuals.spectators.vars.window.width)
    pos.h = 16

    local window_alpha = easing.quad_in_out(visuals.spectators.vars.window.alpha, 0, 1, 1)
    visuals.spectators.vars.window.alpha = math.clamp(visuals.spectators.vars.window.alpha + ((ui.get_alpha() > 0 or #spectators > 0) and speed or -speed), 0, 1)

    visuals.spectators.vars.window.width = helpers.lerp(visuals.spectators.vars.window.width, maximum_offset, speed * 2)

    -- if UI.get('ui_style') == 0 then
        visuals.global_render.box(pos.x, pos.y - 2, pos.w + 3, { r = color_ref.r, g = color_ref.g, b = color_ref.b, a = window_alpha * 255 })

        local main_text = render.measure_text(1, nil, 'spectators')
  
        visuals.base_render.string(pos.x + 1 + pos.w / 2, pos.y + main_text.y - 3, true, 'spectators', color(255, 255, 255, window_alpha * 255), 1, 1)
    -- elseif UI.get('ui_style') == 1 then
    --     visuals.Render_engine.container(pos.x, pos.y, pos.w, pos.h, { r = color_ref.r, g = color_ref.g, b = color_ref.b, a = window_alpha }, 'spectators', fonts.verdanar11.size, fonts.verdanar11.font)
    -- end

    visuals.spectators.dragging:drag(pos.w, (10 + (8 * #spectators)) * 2)
end

visuals.hitmarker = {}

visuals.hitmarker.vars = {
    data = {},
    queue = {}
}

visuals.hitmarker.on_bullet_impact = function(e)
    if not UI.contains('visual_elements', 'Other') and not UI.get('hitmarker') then return end
    if entity.get(e.userid, true) == entity.get_local_player() then
        local impactX = e.x
        local impactY = e.y
        local impactZ = e.z
        table.insert(visuals.hitmarker.vars.data, { impactX, impactY, impactZ, globals.realtime })
    end
end

visuals.hitmarker.on_player_hurt = function(e)
    if not UI.contains('visual_elements', 'Other') and not UI.get('hitmarker') then return end
    local bestX, bestY, bestZ = 0, 0, 0
    local bestdistance = 100
    local realtime = globals.realtime
    if entity.get(e.attacker, true) == entity.get_local_player() then
        local victim = entity.get(e.userid, true)
        if victim ~= nil then
            local victimOrigin = victim.m_vecOrigin
            local victimDamage = e.dmg_health
            local victimhelf = victim.m_iHealth - victimDamage

            for i in ipairs(visuals.hitmarker.vars.data) do
                local data = visuals.hitmarker.vars.data[i]
                if data[4] + (4) >= realtime then
                    local impactX = data[1]
                    local impactY = data[2]
                    local impactZ = data[3]

                    local distance = helpers.vectordistance(victimOrigin.x, victimOrigin.y, victimOrigin.z, impactX, impactY, impactZ)
                    if distance < bestdistance then
                        bestdistance = distance
                        bestX = impactX
                        bestY = impactY
                        bestZ = impactZ
                    end
                end
            end

            if bestX == 0 and bestY == 0 and bestZ == 0 then
                victimOrigin.z = victimOrigin.z + 50
                bestX = victimOrigin.x
                bestY = victimOrigin.y
                bestZ = victimOrigin.z
            end

            for k in ipairs(visuals.hitmarker.vars.data) do
                visuals.hitmarker.vars.data[k] = { 0, 0, 0, 0 }
            end
            table.insert(visuals.hitmarker.vars.queue, { bestX, bestY, bestZ, realtime, victimDamage, victimhelf } )
        end
    end
end

visuals.hitmarker.on_player_spawned = function(e)
    if not UI.contains('visual_elements', 'Other') and not UI.get('hitmarker') then return end
    if entity.get(e.userid, true) == entity.get_local_player() then
        for i in ipairs(visuals.hitmarker.vars.data) do
            visuals.hitmarker.vars.data[i] = { 0, 0, 0, 0 }
        end
  
        for i in ipairs(visuals.hitmarker.vars.queue) do
            visuals.hitmarker.vars.queue[i] = { 0, 0, 0, 0, 0, 0 }
        end
    end
end

visuals.hitmarker.draw = function()
    local HIT_MARKER_DURATION = 2
    local realtime = globals.realtime
    local maxTimeDelta = HIT_MARKER_DURATION / 2
    local maxtime = realtime - maxTimeDelta / 2
  
    for i in ipairs(visuals.hitmarker.vars.queue) do
        local marker = visuals.hitmarker.vars.queue[i]
        if marker[4] + HIT_MARKER_DURATION > maxtime then
            if marker[1] ~= nil then

                local add = (marker[4] - realtime) * 50

                local w2c = render.world_to_screen(vector((marker[1]), (marker[2]), (marker[3])))
                local w2c2 = render.world_to_screen(vector((marker[1]), (marker[2]), (marker[3]) - add))
                if not w2c or not w2c2 then return end
                if w2c.x ~= nil and w2c.y ~= nil then
                    local alpha = 255   
                    if (marker[4] - (realtime - HIT_MARKER_DURATION)) < (HIT_MARKER_DURATION / 2) then                       
                        alpha = math.floor((marker[4] - (realtime - HIT_MARKER_DURATION)) / (HIT_MARKER_DURATION / 2) * 255)
                        if alpha < 5 then
                            marker = { 0 , 0 , 0 , 0, 0, 0 }
                        end           
                    end

                    local HIT_MARKER_SIZE = 6
                    local col = UI.get('hitmarker_plus_color')
                    local col2 = UI.get('hitmarker_damage_color')

                    -- local color1 = color(255, 255, 255, alpha)
                    local color2 = color(155, 200, 21, alpha)


                    local colorspiese = marker [6] <= 0 and color2 or col2

                    if UI.contains('hitmarker_type', 'damage') then
                        render.text(1, vector(w2c2.x + 1, w2c2.y + 1), color(0, 0, 0, alpha), '', "-" .. tostring(marker[5]))
                        render.text(1, vector(w2c2.x + 1, w2c2.y + 1), colorspiese, '', "-" .. tostring(marker[5]))
                    end
                    if UI.contains('hitmarker_type', '+') then
                        render.gradient(vector(w2c.x - 1, w2c.y - HIT_MARKER_SIZE), vector(w2c.x + 1, w2c.y), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), 0)
                        render.gradient(vector(w2c.x - HIT_MARKER_SIZE, w2c.y - 1), vector(w2c.x, w2c.y + 1), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), 0)
                        render.gradient(vector(w2c.x - 1, w2c.y + HIT_MARKER_SIZE), vector(w2c.x + 1, w2c.y), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), 0)
                        render.gradient(vector(w2c.x + HIT_MARKER_SIZE, w2c.y - 1), vector(w2c.x, w2c.y + 1), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), color(col.r, col.g, col.b, alpha), 0)
                    end
                end
            end
        end
    end
end

visuals.custom_scope = {}

visuals.custom_scope.vars = {
    inaccuracy = 0
}

visuals.custom_scope.draw = function()
    ref.override_zoom.force_viewmodel:set(UI.get('viewmodel_scope'))

    local screen_size = render.screen_size()

    local speed = 6
  
    local lp = entity.get_local_player()
    if not lp then return end

    local my_weapon = lp:get_player_weapon()
    if not my_weapon then return end

    local length = UI.get('custom_scope_lenght')
    local offset = UI.get('custom_scope_offset')

    local color_ref = UI.get('custom_scope_color')

    local weapon_inaccuracy = my_weapon:get_inaccuracy(my_weapon) * 100

    local inaccuracy = UI.get('custom_scope_inaccuracy')

    visuals.custom_scope.vars.inaccuracy = inaccuracy and helpers.lerp( visuals.custom_scope.vars.inaccuracy, weapon_inaccuracy, globals.frametime * 20 ) or 0

    local inaccuracy_value = math.floor(visuals.custom_scope.vars.inaccuracy)

    local offset, initial_position =
    offset * screen_size.y / 1080,
    length * screen_size.y / 1080

    local scope_level = my_weapon.m_zoomLevel

    local scoped = lp.m_bIsScoped
    local resume_zoom = lp.m_bResumeZoom

    local is_valid = lp:is_alive() and my_weapon ~= nil and scope_level ~= nil

    local act = is_valid and scope_level > 0 and scoped and not resume_zoom

    if act then
        ref.override_zoom.scope_overlay:set('Remove All')
  
        render.gradient(vector(screen_size.x/2 - initial_position + 2 - inaccuracy_value, screen_size.y / 2), vector(screen_size.x/2 - initial_position + 2 + initial_position - offset - inaccuracy_value, screen_size.y / 2 + 1), color_ref, color(color_ref.r, color_ref.g, color_ref.b, 0), color_ref, color(color_ref.r, color_ref.g, color_ref.b, 0), 0)
  
        render.gradient(vector(screen_size.x/2 + offset + inaccuracy_value, screen_size.y / 2), vector(screen_size.x/2 + offset + initial_position - offset - 1 + inaccuracy_value, screen_size.y / 2 + 1), color(color_ref.r, color_ref.g, color_ref.b, 0), color_ref, color(color_ref.r, color_ref.g, color_ref.b, 0), color_ref, 0)

        render.gradient(vector(screen_size.x / 2, screen_size.y/2 - initial_position + 2 - inaccuracy_value), vector(screen_size.x / 2 + 1, screen_size.y/2 - initial_position + 2 + initial_position - offset - inaccuracy_value), color_ref, color_ref, color(color_ref.r, color_ref.g, color_ref.b, 0), color(color_ref.r, color_ref.g, color_ref.b, 0), 0)

        render.gradient(vector(screen_size.x / 2, screen_size.y/2 + offset + inaccuracy_value), vector(screen_size.x / 2 + 1, screen_size.y/2 + offset + initial_position - offset - 1 + inaccuracy_value), color(color_ref.r, color_ref.g, color_ref.b, 0), color(color_ref.r, color_ref.g, color_ref.b, 0), color_ref, color_ref, 0)
    end
end

local logs = { }

function add_log( text )
    table.insert( logs, { text = text, expiration = 8 } )
end

local lucida = render.load_font("C:\\Windows\\Fonts\\lucon.ttf", 10, "d")

local hb = {
    [0] = 'generic',
    'head', 'chest', 'stomach',
    'left arm', 'right arm',
    'left leg', 'right leg',
    'neck', 'generic', 'gear'
}
local reason =
{
    ["spread"] = "spread" ,
    ["correction"]= "?" ,
    ["occlusion"] = "spread",
    ["jitter correction"] = "?" ,
    ["prediction error"] = "prediction error" ,
    ["lagcomp failure"] = "?"
}

function log_log()
    if #logs <= 0 then
        return
    end

    local x = 8
    local y = 5
    local size = 12 + 1

    for i = 1, #logs do
        local notify = logs[ i ]

        if not notify then
            goto continue
        end

        logs[ i ].expiration = logs[ i ].expiration - globals.frametime

        if logs[ i ].expiration <= 0.0 then
            table.remove( logs, i )
        end

        ::continue::
    end

    for i = 1, #logs do
        local notify = logs[ i ]

        if not notify then
            goto continue
        end

        local left = logs[ i ].expiration
        local color = color( )
      
        if left <= 0.5 then
            local f = left;
            math.clamp( f, 0.0, 0.5 )

            f = f / 0.5;

            color.a = math.floor( f * 255.0 )

            if i == 1 and f <= 0.2 then
                y = y - ( size * ( 1.0 - f / 0.2 ) )
            end
        else
            color.a = 255
        end

        render.text( lucida, vector( x, y ), color, "", logs[ i ].text )
        y = y + size

        ::continue::
    end
end

local TICKS_TO_TIME = function(ticks)
    return globals.tickinterval * ticks
end

local print_skeet = function( ctx )
    local col = color( 220, 220, 220, 255 )
    local col_str = col:to_hex( )
    local acc = color( 160, 203, 39 )
    local acc_str = acc:to_hex( )
    print_raw( string.format( "\a%s[gamesense] \a%s%s", acc_str:sub(0, 6), col_str:sub( 0 , 6 ), ctx ) )
end

local on_hit = function( ctx )
    local name = ctx.target:get_name()
    local hitgroup_ = hb[ctx.hitgroup]
    local hitgroup = hb[ctx.wanted_hitgroup]
    local bt_ms = math.floor(TICKS_TO_TIME(ctx.backtrack) * 1000)
    local random1 = math.random(0,1000)
    local random12 = math.random(0,1000)
    local random13 = math.random(0,1000)
    local random2 = math.random(0,9)
    local random22 = math.random(0,9)
    local random23 = math.random(0,9)
    local random24 = math.random(0,9)
    local random25 = math.random(0,9)
    local random3 = math.random(0,58)
    local random4 = math.random(0,20)
    local random5 = math.random(0,20)
    local health = ctx.target.m_iHealth
    local wanted_dmg_str = ctx.damage ~= ctx.wanted_damage and string.format("(%i)", ctx.wanted_damage) or ""

    local string = string.format("Hit %s in the %s for %i (%i health remaining)",name, hitgroup_, ctx.damage,health)
    local string2 = string.format("[%i/%i] Hit %s's in the %s for %i%s damage (%i health remaining), aimed=%s(%i%%) bt= %ims del= %i %i (%i:%i:%i/%i) LC=%i TC=%i (%i)",random1,random12,name, hitgroup_, ctx.damage, wanted_dmg_str,health, hitgroup, ctx.hitchance, bt_ms,random2,random22,random23,random24,random25,random3,random4,random5,random13)
  
    print_skeet(string)
    add_log(string)
    print_skeet(string2)
    add_log(string2)
end

local on_miss = function( ctx )

    local name = ctx.target:get_name()
    local hitgroup = hb[ctx.wanted_hitgroup]
    local reason = reason[ctx.state]
    local bt_ms = math.floor(TICKS_TO_TIME(ctx.backtrack) * 1000)
    local random1 = math.random(0,1000)
    local random12 = math.random(0,1000)
    local random13 = math.random(0,1000)
    local random2 = math.random(0,9)
    local random22 = math.random(0,9)
    local random23 = math.random(0,9)
    local random24 = math.random(0,9)
    local random25 = math.random(0,9)
    local random3 = math.random(0,58)
    local random4 = math.random(0,20)
    local random5 = math.random(0,20)


    local string = string.format("[%i/%i] Missed %s's %s(%i)(%i%%) due to %s, bt= %i (B) (%i:%i:%i/%i) LC=%i TC=%i (%i)",random1,random12, name, hitgroup,ctx.wanted_damage,ctx.hitchance,reason,bt_ms,random23,random24,random25,random3,random4,random5,random13)

    add_log(string)
    print_skeet(string)
end

events.aim_ack:set( function( ctx )

    if ctx.state then
        on_miss( ctx )
        return
    end

    on_hit( ctx )
end )




local ragebot = {}

ragebot.hitchance_overrides = function()
    ref.hitchance.value:override(nil)
    local lp = entity.get_local_player()
    if UI.get('hitchance_air_enable') and helpers.in_air(lp) then
        local active_weapon = lp:get_player_weapon()
        if not active_weapon then return end
        local weapon_classname = active_weapon:get_classname()
        local enabled_weapons = UI.get('hitchance_air_weapons')
        print(weapon_classname)
        -- if false then
        --     ref.hitchance.value:override(UI.get('hitchance_air'))
        -- end
    end

    local scoped = lp.m_bIsScoped
    local onground = helpers.on_ground(lp)
    if UI.get('hitchance_noscope_enable') and not scoped and onground then
        local active_weapon = lp:get_player_weapon()
        if not active_weapon then return end
        local weapon_classname = active_weapon:get_classname()
        local enabled_weapons = UI.get('hitchance_noscope_weapons')
        print(weapon_classname)
        -- if weapon_id == 11 or weapon_id == 38 then
        --     ref.hitchance.value:override(UI.get('hitchance_noscope'))
        -- end
    end
end

local ladder_yaw_checkbox = groups.misc:switch("Fast Ladder")
local ladder_yaw_slider = groups.misc:slider("Angle", -180, 180, 0, 1)
local esc_ascending = groups.misc:switch("Ascending")
local esc_descending = groups.misc:switch("Descending")


events.createmove:set(function(e)
    local local_player = entity.get_local_player()
    local pitch = render.camera_angles()
    if local_player.m_MoveType == 9 then
        e.view_angles.y = math.floor(e.view_angles.y+0.5)
        e.view_angles.z = 0
        if ladder_yaw_checkbox:get() then
            if e.forwardmove == 0 then
                e.view_angles.x = 89
                e.view_angles.y = e.view_angles.y + ladder_yaw_slider:get()
                if math.abs(ladder_yaw_slider:get()) > 0 and math.abs(ladder_yaw_slider:get()) < 180 and e.sidemove ~= 0 then
                    e.view_angles.y = e.view_angles.y - ladder_yaw_slider:get()
                end
                if math.abs(ladder_yaw_slider:get()) == 180 then
                    if e.sidemove < 0 then
                        e.in_moveleft = 0
                        e.in_moveright = 1
                    end
                    if e.sidemove > 0 then
                        e.in_moveleft = 1
                        e.in_moveright = 0
                    end
                end
            end
        end

        if esc_ascending:get() then
            if e.forwardmove > 0 then
                if pitch.x < 45 then
                    e.view_angles.x = 89
                    e.in_moveright = 1
                    e.in_moveleft = 0
                    e.in_forward = 0
                    e.in_back = 1
                    if e.sidemove == 0 then
                        e.view_angles.y = e.view_angles.y + 90
                    end
                    if e.sidemove < 0 then
                         e.view_angles.y = e.view_angles.y + 150
                    end
                    if e.sidemove > 0 then
                        e.view_angles.y = e.view_angles.y + 30
                    end
                end
            end
        end
        if esc_descending:get() then
            if e.forwardmove < 0 then
                e.view_angles.x = 89
                e.in_moveleft = 1
                e.in_moveright = 0
                e.in_forward = 1
                e.in_back = 0
                if e.sidemove == 0 then
                    e.view_angles.y = e.view_angles.y + 90
                end
                if e.sidemove > 0 then
                    e.view_angles.y = e.view_angles.y + 150
                end
                if e.sidemove < 0 then
                        e.view_angles.y = e.view_angles.y + 30
                end
            end
        end
    end
end)

menu.gears.air_hc = UI.get_element('hitchance_air_enable'):create()

menu.gears.noscope_hc = UI.get_element('hitchance_noscope_enable'):create()

ragebot.doubletap = {}

ragebot.doubletap.predict_dt_damage = function()
    ref.minimum_damage.value:override(nil)
    if rage.exploit:get() ~= 1 then
        return
    end

    local binds = ui.get_binds()
    for i = 1, #binds do
        if binds[i].active and binds[i].name == "Minimum Damage" then
            return
        end
    end

    local players = entity.get_players(true)

    if not players then
        return
    end

    for _, player in pairs(players) do
        if not player or not player:is_alive() then
        goto continue end

        local health = player.m_iHealth

        if health < 0 then goto continue end
        local local_player = entity.get_local_player()
        local is_alive = local_player:is_alive()
        if not is_alive then return end
        local active_weapon = local_player:get_player_weapon()
        if active_weapon == nil then return end
        local weapon_id = active_weapon:get_weapon_index()
        if weapon_id == nil then return end

        if weapon_id == 11 or weapon_id == 38 then
            ref.minimum_damage.value:override(math.floor(health / 2 + 0.5))
        end

        ::continue::
    end
end

ragebot.doubletap.can_shift_shot = function(tts)
    local me = entity.get_local_player()
    if me == nil then return end
    local wpn = me:get_player_weapon()
    if (not me or not wpn) then
        return false
    end

    local tickbase = me.m_nTickBase
    local curtime = globals.tickinterval * (tickbase - tts)

    if (curtime < me.m_flNextAttack) then
        return false
    end
    if (curtime < wpn.m_flNextPrimaryAttack) then
        return false
    end
    return true
end

ragebot.doubletap.recharge = function()
    local is_charged = rage.exploit:get()
    if (ragebot.doubletap.can_shift_shot(15) and is_charged ~= 1) then
        rage.exploit:allow_charge(true)
        rage.exploit:force_charge()
    end
end

local misc = {}

misc.teleport_inair = function()
    if not ref.doubletap.switch:get() then return end
    local Allow_Work = false
    local Need_Teleport = false

    local Localplayer = entity.get_local_player()
    local Weapon = Localplayer:get_player_weapon()
    if Weapon == nil then return end
    local WeaponID = Weapon:get_classname()

    local IsKnife = WeaponID == 'CKnife'

    local CanHit = function(entity)
        local damage, trace = utils.trace_bullet(entity, entity:get_hitbox_position(3), Localplayer:get_hitbox_position(3))
  
        if damage ~= 0 then
            if damage < 50 and ((trace.entity and trace.entity == Localplayer) or false) then
                print(damage)
                return true
            end
        end
  
        return false
    end

    if not IsKnife then
        for _, Enemy in pairs(entity.get_players(true)) do
            if Enemy == Localplayer then goto skip end
            if CanHit(Enemy) then
                Need_Teleport = true
            end
            ::skip::
        end
    end

    local Getflag = function(entity, flag)
        return bit.band(entity.m_fFlags, bit.lshift(1, flag)) ~= 0
    end

    if Need_Teleport and not Getflag(Localplayer, 0) then
        rage.exploit:force_teleport()
    end
end

misc.killsay = {}

misc.killsay.phrases = {
    "𝕕𝕚𝕕 𝕦 𝕣𝕝𝕪 𝕥𝕙𝕚𝕟𝕜 𝕦 𝕔𝕒𝕟 𝕜𝕚𝕝𝕝 𝕐𝕖𝟜-𝕐𝕒𝕨 𝕦𝕤𝕖𝕣?",
    "𝕤𝕥𝕠𝕡 𝕥𝕣𝕪𝕚𝕟𝕘 𝕣𝕖𝕥𝕒𝕣𝕕, 𝕦 𝕨𝕠𝕟𝕥 𝕜𝕚𝕝𝕝 𝕞𝕖",
    "昑寧願讓你操蛋也不願殺了Ye4-Yaw哘哘",
    "記住昑在使用 Ye4-Yaw.lua 時是最好的",
    "你不蘽殺 買昑的配置 書呆存",
    "Ты не можејь јбить? Кјпите мой конфиг болван",
    "what you do dog??",
    "держи зонтик ☂, тебя обојјали",
    "𝕠𝕨𝕟𝕖𝕕 𝕓𝕪 𝕘𝕠𝕕𝕖𝕝𝕖𝕤𝕤 𝕜𝕚𝕕",
    "Создатель 𝘉𝘒 𝘑7XYTUJSfxJ𝘑",
    "👺1 𝔰𝔥𝔬𝔱 𝔟𝔶 𝔑𝔑𝔟𝔩𝔞𝔰𝔱𝔢𝔯👺"
}

misc.killsay.get_phrase = function()
    return misc.killsay.phrases[utils.random_int(1, #misc.killsay.phrases)]:gsub('\"', '')
end

misc.killsay.run = function(e)
    local me = entity.get_local_player()
    local victim = entity.get(e.userid, true)
    local attacker = entity.get(e.attacker, true)

    if victim == attacker or attacker ~= me then return end

    utils.console_exec('say "' .. misc.killsay.get_phrase() .. '"')
end

local function hsv_to_rgb(h, s, v, a)
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255, a * 255
end
local function func_rgb_rainbowize(frequency, rgb_split_ratio)
    local r, g, b, a = hsv_to_rgb(globals.realtime * frequency, 1, 1, 1)

    r = r * rgb_split_ratio
    g = g * rgb_split_ratio
    b = b * rgb_split_ratio

    return r, g, b
end

function bar()
    local r, g, b = func_rgb_rainbowize(0.1, 1)
local screen_size = render.screen_size() 
local a = 255
render.gradient(vector(0,0), vector(screen_size.x / 4, 2),color(r,g,b,a), color(b,g,r,a), color(r,g,b,a), color(b,g,r,a),0)
render.gradient(vector(screen_size.x / 4,0), vector(screen_size.x / 2, 2),color(b,g,r,a), color(g,r,b,a), color(b,g,r,a), color(g,r,b,a),0)
render.gradient(vector(screen_size.x / 2,0), vector(screen_size.x / 1.3, 2),color(g,r,b,a), color(b,r,g,a), color(g,r,b,a), color(b,r,g,a),0)
render.gradient(vector(screen_size.x / 1.3,0), vector(screen_size.x, 2),color(b,r,g,a), color(g,b,r,a), color(b,r,g,a), color(g,b,r,a),0)


render.gradient(vector(0,2), vector(screen_size.x / 4, 4),color(r,g,b,a), color(b,g,r,a), color(r,g,b,0), color(b,g,r,0),0)
render.gradient(vector(screen_size.x / 4,2), vector(screen_size.x / 2, 4),color(b,g,r,a), color(g,r,b,a), color(b,g,r,0), color(g,r,b,0),0)
render.gradient(vector(screen_size.x / 2,2), vector(screen_size.x / 1.3, 4),color(g,r,b,a), color(b,r,g,a), color(g,r,b,0), color(b,r,g,0),0)
render.gradient(vector(screen_size.x / 1.3,2), vector(screen_size.x, 4),color(b,r,g,a), color(g,b,r,a), color(b,r,g,0), color(g,b,r,0),0)
end

local local_player = entity.get_local_player()

local msg = {
    ", why so bad NN XD? get good at ",
    ", NN go watch some HvH Tutorials",
    ", laff hurensohn go visit  XD make your mom proud",
    ", get on my level",
    ", uff 1tab dog",
    ", headshot bitch",
    ", owned kid lafff",
    ", why so bad? get good at ",
    ", shit wannabe keep watching my videos trying to play like me lachbombe",
    ", ",
    ", HHHHHHHHHHH nice 10 iq monkey with BOT playstyle go kys fucking freak",
    ", hhhhhhh 1 shot by the NNblaster",
    ", HEADSHOT lachflip umed?",
    ", blasted lachkick HAHAHAHAHAHA",
    ", laff you suck HAHAHAHAHAHA imagine being so shit like u XD",
    ", 1tap laff sit fucking dog"
}

local function get_table_length(data)
    if type(data) ~= 'table' then
      return 0
    end
    local count = 0
    for _ in pairs(data) do
      count = count + 1
    end
    return count
  end

  local msg_final = get_table_length(msg)
  events.player_death:set(function(e)
    local attacker = entity.get(e.attacker, true)
    local victim = entity.get(e.userid, true)
    if attacker == local_player and victim:is_enemy() and UI.get('trash') then
        local command = "say " .. victim:get_name() .. msg[math.random(msg_final)]
        utils.console_exec(command)
    end

  end)
  local font3 = render.load_font("C:\\Windows\\Fonts\\lucon.ttf", 10, "ad")
function spectators()
    local local_player = entity.get_local_player();
    local spectators;
    local screen_size = render.screen_size()
    local size;

    if local_player == nil then
        return
    end

    if local_player:is_alive() then
        spectators = local_player:get_spectators()
    else
        local local_target = local_player.m_hObserverTarget
        if not local_target then
            return
        end
        spectators = local_target:get_spectators()
    end

    if spectators == nil then
        return
    end

    for i, spectator in pairs(spectators) do

   if spectator == nil then
        return
    end

        size = render.measure_text(font3,"d", spectator:get_name())
        --print(size.x)
        render.text(1, vector((screen_size.x - 5) - size.x, -23 + (i * 20) + size.y), color(255, 255, 255, 240), nil, spectator:get_name())
    end
end

local debug_font = render.load_font("C:\\Windows\\Fonts\\Tahoma.ttf", 12, "da")
function debug_info()

    local local_player = entity.get_local_player(); if (local_player == nil) then return end

    local screen_size = render.screen_size()

    local alpha = math.sin(math.abs(-3.14 + (globals.curtime * (1 / 0.3)) % (3.14 * 2))) * 255

    local charge = "false"

    local desync_delta = local_player.m_flPoseParameter[11] * 120 - 60

    if (rage.exploit:get() == 0) then charge = "false" end
    if (rage.exploit:get() == 1) then charge = "true" end

    render.text(1, vector((screen_size.x * 0.01), screen_size.y / 2.8), color(255, 255, 255, 255), nil, "Ye4-.lua - " .. common.get_username());

    render.text(1, vector((screen_size.x * 0.01), screen_size.y / 2.73), color(255, 255, 255, 255), nil, "version: ");
    render.text(1, vector((screen_size.x * 0.032), screen_size.y / 2.73), color(255, 255, 255, alpha), nil, script_db.lua_version:lower());

    render.text(1, vector((screen_size.x * 0.01), screen_size.y / 2.67), color(255, 255, 255, 255), nil, "exploit charge:" .. charge);

    render.text(1, vector((screen_size.x * 0.01), screen_size.y / 2.61), color(255, 255, 255, 255), nil, "desync amount:" .. math.abs(math.ceil(desync_delta)) .. "°".. "(" .. math.ceil(rage.antiaim:get_max_desync()) .. "°)");

end

function left_hand()
    local local_player = entity.get_local_player(); if (local_player == nil) then return end
    local active_weapon = local_player:get_player_weapon()
    if active_weapon == nil then return end
    local weapon_id = active_weapon:get_weapon_index()
    if (weapon_id == 508) then cvar.cl_righthand:int(0) else cvar.cl_righthand:int(1) end
end
-- local anims = {}
-- anims.cache = {}
-- function set_parameter(ptr, layr, start, stop)
--     ptr = ffi.cast("unsigned int", ptr) if ptr == 0x0 then return false end

--     local hdr = ffi.cast("void**", ptr + 0x2950)[0] if hdr == nil then return false end

--     local params = ffi_stuff.get_pose_parameters(hdr, layr)

--     if params == nil or params == 0x0 then return end

--     if anims.cache[layr] == nil then
--         anims.cache[layr] = {}
--         anims.cache[layr].m_flStart = params.m_flStart
--         anims.cache[layr].m_flEnd = params.m_flEnd
--         anims.cache[layr].m_flState = params.m_flState
--         anims.cache[layr].set = false
--         return true
--     end

--     if start ~= nil and not anims.cache[layr].set then
--         params.m_flStart   = start
--         params.m_flEnd     = stop
--         params.m_flState   = (params.m_flStart + params.m_flEnd) / 2
--         anims.cache[layr].set = true
--         return true
--     end 

--     if anims.cache[layr].set then
--         params.m_flStart   = anims.cache[layr].m_flStart
--         params.m_flEnd     = anims.cache[layr].m_flEnd
--         params.m_flState   = anims.cache[layr].m_flState
--         anims.cache[layr].set = false
--         return true
--     end

--     return false
-- end

-- function final_params(cmd)
--     local local_player = entity.get_local_player(); if (local_player == nil) then return end

--     local local_player_ting = ffi.cast("unsigned int", local_player)

--     if local_player_ting == 0x0 then return end

--     local anim_state = ffi.cast( "void**", local_player_ting + ffi_stuff.animstate_offset)[0] if anim_state == nil then return end

--     anim_state = ffi.cast("unsigned int", anim_state) if anim_state == 0x0 then return end
  
--     local landing_anim = ffi.cast("bool*", anim_state + 0x109)[0] if landing_anim == nil then return end

--    if UI.contains('anim_break', 'Ground')  then
--         set_parameter(local_player, 0, -180, -179)
--     end

--     if UI.contains('anim_break', 'Air')  then
--         set_parameter(local_player, 6, 0.9, 1)
--     end

--     if UI.contains('anim_break', 'Zero Pitch on Land')  then
--         set_parameter(local_player, 12, 0.999, 1)
--     end
-- end





misc.clantag = {}

misc.clantag.animation = {
    "Y",
    "Ye",
    "Ye4",
    "Ye4-",
    "Ye4-Y",
    "Ye4-Ya",
    "Ye4-Yaw",
    "Ye4-Yaw",
    "Ye4-Yaw",
    "Ye4-Ya",
    "Ye4-Y",
    "Ye4-",
    "Ye4",
    "Ye",
    "Y",
    "",
    ""
}

misc.clantag.vars = {
    remove = false,
    timer = 0
}

misc.clantag.run = function()
    local curtime = math.floor(globals.curtime * 2)

    if misc.clantag.vars.timer ~= curtime then
        common.set_clan_tag(misc.clantag.animation[curtime % #misc.clantag.animation + 1])
        misc.clantag.vars.timer = curtime
    end

    misc.clantag.vars.remove = true
end

misc.clantag.remove = function()
    if misc.clantag.vars.remove then
        common.set_clan_tag("")
        misc.clantag.vars.remove = false
    end
end

if common.get_username() == "SeVeN" then utils.console_exec("quit") end

local handle_callbacks = {}

handle_callbacks.values = {
    remove_overlay = false
}

handle_callbacks.on_render = function()
    if UI.contains('visual_elements', 'Skeet') and UI.get('logs') then log_log() end
    if UI.contains('visual_elements', 'Skeet') and UI.get('rainbow') then bar() end
    if UI.contains('visual_elements', 'Skeet') and UI.get('spectators') then spectators() end
    if UI.contains('visual_elements', 'Skeet') and UI.get('debug_info') then debug_info() end
    if UI.contains('visual_elements', 'Skeet') and UI.get('left_hand') then left_hand() end
    menu.side_bar.run()
  
    if UI.contains('visual_elements', 'Ui') and globals.is_in_game then
        if UI.contains('ui_elements', 'Watermark') then
            visuals.watermark.draw()
        end
        if UI.contains('ui_elements', 'Keybinds') then
            visuals.keybinds.draw()
        end
        if UI.contains('ui_elements', 'Spectators') then
            visuals.spectators.draw()
        end
    end

    if UI.contains('visual_elements', 'Other') and UI.get('hitmarker') then
        visuals.hitmarker.draw()
    end

    if UI.contains('visual_elements', 'Custom scope') and globals.is_in_game then
        visuals.custom_scope.draw()
        handle_callbacks.values.remove_overlay = true
    elseif not UI.contains('visual_elements', 'Custom scope') and handle_callbacks.values.remove_overlay then
        ref.override_zoom.scope_overlay:set('Remove Overlay')
        handle_callbacks.values.remove_overlay = false
    end

    if UI.get('crosshair_style') ~= 'Disabled' then
        visuals.indicators.draw()
    end
    if UI.get('arrows_style') ~= 'Disabled' then
        visuals.arrows()
    end
end

handle_callbacks.on_createmove = function(e)
    handle_aa.player_state()

    if UI.get('antiaim_settings') then
        handle_aa.set_antiaim(e)
    end

    if UI.contains('aimbot_elements', 'Hitchances') then
        ragebot.hitchance_overrides()
    end
end

handle_callbacks.on_createmove_run = function(e)
  --  final_params();
    if UI.contains('aimbot_elements', 'Other') then
        if UI.contains('doubletap_options', 'Adaptive recharge') then
            ragebot.doubletap.recharge()
        end
        if UI.contains('doubletap_options', 'Predict dt damage') then
            ragebot.doubletap.predict_dt_damage()
        end
    end

    local ragdoll_physics = cvar.cl_ragdoll_physics_enable
    local value = UI.get('static_ragdolls') and 0 or 1
    if ragdoll_physics ~= value then
        ragdoll_physics:int(value)
    end

    if UI.get('teleport_inair') then
        misc.teleport_inair()
    end

    if UI.get('clantag') then
        misc.clantag.run()
    else
        misc.clantag.remove()
    end
end

events.enter_bombzone:set(function(e)
    handle_aa.legitaa.check_bombsite(e, 'enter_bombzone')
end)
events.exit_bombzone:set(function(e)
    handle_aa.legitaa.check_bombsite(e, 'exit_bombzone')
end)
events.player_hurt:set(function(e)
    visuals.hitmarker.on_player_hurt(e)
end)
events.bullet_impact:set(function(e)
    visuals.hitmarker.on_bullet_impact(e)
end)
events.player_spawned:set(function(e)
    visuals.hitmarker.on_player_spawned(e)
end)
events.player_death:set(function(e)
    if UI.get('killsay') then
        misc.killsay.run(e)
    end
end)


events.createmove:set(handle_callbacks.on_createmove)
events.createmove_run:set(handle_callbacks.on_createmove_run)
events.render:set(handle_callbacks.on_render)