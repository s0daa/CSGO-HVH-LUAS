--[[ @region: script information
    * @ Necron.
    * @ Created by Klient#1690.
    * @ Version: 1.0.0
-- @endregion ]]

--- @region: dependencies
local json = require "JSON"
local base64 = require "Base64"
--- @endregion

--- @region: defines
local SCRIPT_NAME = "necron"

local SCRIPT_COLOR = color_t(255, 192, 118, 255)
--- @endregion

--- @region: enumerations section
local e_conditions = {
    SHARED = 1,
    STANDING = 2,
    RUNNING = 3,
    WALKING = 4,
    AIR = 5,
    CROUCH = 6
}

local e_jiter_mode = {
    NONE = 1,
    STATIC = 2,
    RANDOM = 3
}

local e_jitter_type = {
    OFFSET = 1,
    CENTER = 2
}

local e_menu = {
    PITCH = menu.find("antiaim", "main", "angles", "pitch"),
    YAW_BASE = menu.find("antiaim", "main", "angles", "yaw base"),
    YAW_ADD = menu.find("antiaim", "main", "angles", "yaw add"),

    ROTATE = menu.find("antiaim", "main", "angles", "rotate"),
    ROTATE_RANGE = menu.find("antiaim", "main", "angles", "rotate range"),
    ROTATE_SPEED = menu.find("antiaim", "main", "angles", "rotate speed"),

    JITTER_MODE = menu.find("antiaim", "main", "angles", "jitter mode"),
    JITTER_TYPE = menu.find("antiaim", "main", "angles", "jitter type"),
    JITTER_ADD = menu.find("antiaim", "main", "angles", "jitter add"),

    BODY_LEAN = menu.find("antiaim", "main", "angles", "body lean"),
    BODY_LEAN_VALUE = menu.find("antiaim", "main", "angles", "body lean value"),

    SIDE_STAND = menu.find("antiaim","main", "desync","side#stand"),
    LEFT_AMOUNT_STAND = menu.find("antiaim","main", "desync","left amount#stand"),
    RIGHT_AMOUNT_STAND = menu.find("antiaim","main", "desync","right amount#stand"),

    SIDE_MOVE = menu.find("antiaim","main", "desync","side#move"),
    LEFT_AMOUNT_MOVE = menu.find("antiaim","main", "desync","left amount#move"),
    RIGHT_AMOUNT_MOVE = menu.find("antiaim","main", "desync","right amount#move"),

    SIDE_SLOW = menu.find("antiaim","main", "desync","side#slow walk"),
    LEFT_AMOUNT_SLOW = menu.find("antiaim","main", "desync","left amount#slow walk"),
    RIGHT_AMOUNT_SLOW = menu.find("antiaim","main", "desync","right amount#slow walk"),
}

local e_binds = {
    DOUBLE_TAP = menu.find("aimbot", "general", "exploits", "doubletap", "enable"),
    HIDE_SHOTS = menu.find("aimbot", "general", "exploits", "hideshots", "enable"),
    MIN_DMG = menu.find("aimbot", "scout", "target overrides", "force min. damage")
}
--- @endregion

--- @region: other operations
--- @info: Sorted pairs iteration
local function spairs(t, order)
    -- Collect the keys
    local keys = {}

    for k in pairs(t) do keys[#keys+1] = k end
    -- If order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0

    -- Return the iterator function.
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end
--- @endregion

--- @region: virtual table
local virtual_table = {}

virtual_table.bind = function( module, interface, index, typestring )
    local iface = memory.create_interface(module, interface) or error(interface .. ": invalid interface")
    local instance = memory.get_vfunc(iface, index) or error(index .. ": invalid index")
    local success, typeof = pcall(ffi.typeof, typestring)

    if not success then
        error(typeof, 2)
    end

    local fnptr = ffi.cast(typeof, instance) or error(typestring .. ": invalid typecast")

    return function(...)
        return fnptr(tonumber(ffi.cast("void***", iface)), ...)
    end
end
--- @endregion

--- @region: ffi section
local ffi_functions = {}

ffi_functions.get_clipboard_text_count = virtual_table.bind( "vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)" )
ffi_functions.set_clipboard_text = virtual_table.bind( "vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)" )
ffi_functions.get_clipboard_text = virtual_table.bind( "vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)" )
--- @endregion

--- @region: clipboard helpers
local clipboard = {}

clipboard.get = function( )
    local len = ffi_functions.get_clipboard_text_count( )

    if len > 0 then
        local char_arr = ffi.typeof( "char[?]" )( len )
        ffi_functions.get_clipboard_text( 0, char_arr, len )

        return ffi.string( char_arr, len - 1 )
    end
end

clipboard.set = function( text )
    text = tostring( text )

    ffi_functions.set_clipboard_text( text, text:len() )
end
--- @endregion

--- @region: engine helpers
function engine.get_condition( )
    local Player = entity_list.get_local_player()

    if not Player or not Player:is_alive() then
        return e_conditions.SHARED
    end

    local Velocity = math.sqrt(math.pow(Player:get_prop("m_vecVelocity[0]"), 2) + math.pow(Player:get_prop("m_vecVelocity[1]"), 2))
    local SlowWalkKey = menu.find("misc", "main", "movement", "slow walk")

    if not Player:has_player_flag(e_player_flags.ON_GROUND) then
        return e_conditions.AIR
    end

    if Player:has_player_flag(e_player_flags.DUCKING) then
        return e_conditions.CROUCH
    end

    if Velocity > 5 then
        if SlowWalkKey[2]:get() then
            return e_conditions.WALKING
        end

        return e_conditions.RUNNING
    end

    return e_conditions.STANDING
end
--- @endregion

--- @region: render helpers
render.get_multitext_size = function( Table )
    if not Table then
        error( "Table is not defined" )
        return
    end

    local Width = 0

    for key, value in pairs(Table) do
        if not value.font then
            return
        end

        Width = Width + render.get_text_size(value.font, value.text).x
    end

    return Width
end

render.multitext = function( Vector, Table )
    if not Table then
        error( "Table is not defined" )
        return
    end

    for key, value in pairs(Table) do
        if not value.font then
            return
        end

        value.centered = value.centered or false
        value.color = value.color or color_t(255, 255, 255, 255)

        render.text(value.font, value.text, Vector, value.color)

        Vector.x = Vector.x + render.get_text_size(value.font, value.text).x
    end
end

render.container = function( x, y, Width, Height, Color, Alpha )
    local r, g, b, a = Color.r, Color.g, Color.b, Color.a

    local Rounding = 3

    local HalfModifier = 30
    local HalfAlpha = a / 255 * HalfModifier

    render.rect_filled(vec2_t(x, y), vec2_t(Width, Height), color_t(0, 0, 0, 80 * (255 / a)), Rounding)

    render.rect_filled(vec2_t(x + Rounding, y), vec2_t(Width - Rounding * 2, 1), color_t(r, g, b, a))

    render.push_clip(vec2_t(x, y), vec2_t(Rounding, Rounding + 2))
    render.progress_circle(vec2_t(x + Rounding, y + Rounding), Rounding, color_t(r, g, b, a), 1, 88)
    render.pop_clip()

    render.push_clip(vec2_t(x + Width - Rounding, y), vec2_t(Rounding + 1, Rounding + 2))
    render.progress_circle(vec2_t(x + Width - Rounding, y + Rounding), Rounding, color_t(r, g, b, a), 1, 90)
    render.pop_clip()

    render.rect_fade(vec2_t(x, y + Rounding), vec2_t(1, Height - Rounding * 2), color_t(r, g, b, a), color_t(r, g, b, 0), false)
    render.rect_fade(vec2_t(x + Width, y + Rounding), vec2_t(1, Height - Rounding * 2), color_t(r, g, b, a), color_t(r, g, b, 0), false)

    render.rect(vec2_t(x, y), vec2_t(Width, Height), color_t(r, g, b, HalfAlpha), Rounding)
end
--- @endregion

--- @region: notes section
local notes = { }
notes.__index = notes

notes.create = function( name )
    if package.NecronNotes == nil then 
        package.NecronNotes = { }
    end

    return setmetatable({name = name}, notes)
end

notes.sort = function( Packages, SortFunction )
    local Table = { }

    for Value in pairs(Packages) do 
        table.insert(Table, Value)
    end

    table.sort(Table, SortFunction)

    local Index = 0
    local UpdateTable = function( )
        Index = Index + 1

        if Table[Index] == nil then 
            return nil 
        else 
            return Table[Index], Packages[Table[Index]]
        end 
    end
    
    return UpdateTable 
end

function notes:get( Function )
    local Id = 0
    local Table = { }

    for key, value in notes.sort(package.NecronNotes) do
        if value == true then
            Id = Id + 1

            table.insert(Table, {key, Id})
        end
    end

    for key, value in ipairs(Table) do
        if value[1] == self.name then
            return Function( value[2] - 1 )
        end
    end
end

function notes:set_state( Value )
    package.NecronNotes[self.name] = Value

    table.sort(package.NecronNotes)
end

function notes:unload( )
    if package.NecronNotes[self.name] ~= nil then 
        package.NecronNotes[self.name] = nil 
    end
end

setmetatable(notes, {
    __call = function( Table, ... ) 
        return notes.create( ... ) 
    end
})
--- @endregion

--- @region: custom animations
local animation = { }
animation.data = { }

animation.lerp = function( start, end_pos, time )
    if type(start) == "userdata" then
        local color_data = {0, 0, 0, 0}

        for key, value in ipairs({"r", "g", "b", "a"}) do
            color_data[key] = animation.lerp(start[value], end_pos[value], time)
        end

        return color_t(unpack(color_data))
    end

    return (end_pos - start) * (global_vars.frame_time() * time) + start
end

animation.new = function( name, value, time )
    if not animation.data[name] then
        animation.data[name] = value
    end

    animation.data[name] = animation.lerp(animation.data[name], value, time)

    return animation.data[name]
end
--- @endregion

--- @region: fonts section
local fonts = { }

fonts.verdana = { }
fonts.small = { }

fonts.verdana.ANTIALIAS = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS)
fonts.verdana.ANTIALIAS_DROPSHADOW =  render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

fonts.small.ANTIALIAS_OUTLINE = render.create_font("Small Fonts", 8, 400, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE)
--- @endregion

--- @region: gui section
local gui = { }

gui.current_tab = menu.add_selection( "Main", "Current Tab:", { "none" } )

gui.tabs = { }
gui.items = { }

function gui.add_item( Tab, Name, Element, ToSave, Condition )
    if ToSave == nil then
        ToSave = true
    end

    if Condition == nil then
        Condition = function( )
            return true
        end
    end

    if gui.items[Tab] == nil then
        gui.items[Tab] = { }

        table.insert( gui.tabs, Tab )
        gui.current_tab:set_items( gui.tabs )
    end

    gui.items[Tab][Name] = { 
        Reference = Element,

        ToSave = ToSave,

        Condition = function()
            return Condition()
        end
    }

    return Element
end
--- @endregion

--- @region: gui functions
function gui.find( Tab, Name )
    return gui.items[Tab][Name].Reference 
end

function gui.update_visible( )
    for tab_name, tab_value in pairs(gui.items) do
        for element_name, element_value in pairs(tab_value) do
            local TabList = gui.current_tab:get_items()

            local CONDITION = ((TabList[ gui.current_tab:get() ] == tab_name) and element_value.Condition()) and true or false

            element_value.Reference:set_visible(
                CONDITION
            )
        end
    end
end
--- @endregion

--- @region: main information
gui.add_item( "Global", "Script Name", menu.add_text( "Main", SCRIPT_NAME ), false )
gui.add_item( "Global", "Discord Link", menu.add_button( "Main", "Copy Discord Link", function( )
    clipboard.set( "https://discord.gg/tPfYp4WeXq" )
end), false )
--- @endregion

--- @region: all anti-aim functions
gui.add_item( "Anti-Aim", "Enable Anti-Aim", menu.add_checkbox( "Anti-Aim", "Enable Anti-Aim" ) )
gui.add_item( "Anti-Aim", "Mode", menu.add_selection( "Anti-Aim", "Mode", { "None", "Conditional" } ) )

--- @element: Conditional anti-aims
local conditional_anti_aims = {}

conditional_anti_aims.current_condition = gui.add_item( "Anti-Aim", "Current Condition", menu.add_selection( "Anti-Aim", "Current Condition", { "none" } ) )

conditional_anti_aims.items = {}

conditional_anti_aims.update_items = function( )
    local Table = { }

    for key, value in spairs(e_conditions, function( t, a, b )
        return t[b] > t[a]
    end) do
        local NewName = key:lower()
        NewName = NewName:gsub("(%l)(%w*)", function( a, b )
            return a:upper( ) .. b
        end)

        table.insert( Table, NewName )
    end

    conditional_anti_aims.current_condition:set_items( Table )
end; conditional_anti_aims.update_items()

for key, value in ipairs(conditional_anti_aims.current_condition:get_items()) do
    local function SETUP_NAME( name )
        return ( "[%s] %s" ):format( value, name )
    end
 
    if conditional_anti_aims.items[key] == nil then
        conditional_anti_aims.items[key] = { }
    end

    local setup = conditional_anti_aims.items[key]

    local function CONDITION( )
        return conditional_anti_aims.current_condition:get() == key and gui.find( "Anti-Aim", "Mode" ):get() == 2
    end

    setup.enable = gui.add_item( "Anti-Aim", ( "Override %s" ):format( value ), menu.add_checkbox( "Anti-Aim", ( "Override %s" ):format( value ) ), true, CONDITION )

    --- @group: angles
    setup.pitch = gui.add_item( "Anti-Aim", SETUP_NAME("Pitch"), menu.add_selection( "Anti-Aim", SETUP_NAME("Pitch"), {"None", "Down", "Up", "Zero", "Jitter"} ), true, CONDITION )
    setup.yaw_base = gui.add_item( "Anti-Aim", SETUP_NAME("Yaw Base"), menu.add_selection( "Anti-Aim", SETUP_NAME("Yaw Base"), {"None", "Viewangle", "At target (crosshair)", "At target (distance)", "Velocity"} ), true, CONDITION )
    setup.yaw_add = gui.add_item( "Anti-Aim", SETUP_NAME("Yaw Add"), menu.add_slider( "Anti-Aim", SETUP_NAME("Yaw Add"), -180, 180 ), true, CONDITION )

    setup.rotate = gui.add_item( "Anti-Aim", SETUP_NAME("Rotate"), menu.add_checkbox( "Anti-Aim", SETUP_NAME("Rotate") ), true, CONDITION )
    setup.rotate_range = gui.add_item( "Anti-Aim", SETUP_NAME("Rotate Range"), menu.add_slider( "Anti-Aim", SETUP_NAME("Rotate Range"), 0, 360 ), true, function() return CONDITION() and setup.rotate:get() end )
    setup.rotate_speed = gui.add_item( "Anti-Aim", SETUP_NAME("Rotate Speed"), menu.add_slider( "Anti-Aim", SETUP_NAME("Rotate Speed"), 0, 100 ), true, function() return CONDITION() and setup.rotate:get() end )

    setup.jitter_mode = gui.add_item( "Anti-Aim", SETUP_NAME("Jitter Mode"), menu.add_selection( "Anti-Aim", SETUP_NAME("Jitter Mode"), {"None", "Static", "Random"} ), true, CONDITION )
    setup.jitter_type = gui.add_item( "Anti-Aim", SETUP_NAME("Jitter Type"), menu.add_selection( "Anti-Aim", SETUP_NAME("Jitter Type"), {"Offset", "Center"} ), true, function() return CONDITION() and setup.jitter_mode:get() ~= 1 end )
    setup.jitter_add = gui.add_item( "Anti-Aim", SETUP_NAME("Jitter Add"), menu.add_slider( "Anti-Aim", SETUP_NAME("Jitter Add"), -180, 180 ), true, function() return CONDITION() and setup.jitter_mode:get() ~= 1 end )

    setup.body_lean = gui.add_item( "Anti-Aim", SETUP_NAME("Body Lean"), menu.add_selection( "Anti-Aim", SETUP_NAME("Body Lean"), {"None", "Static", "Static Jitter", "Random Jitter", "Sway"} ), true, CONDITION )
    setup.body_lean_value = gui.add_item( "Anti-Aim", SETUP_NAME("Body Lean Value"), menu.add_slider( "Anti-Aim", SETUP_NAME("Body Lean Value"), -50, 50 ), true, function() return CONDITION() and setup.body_lean:get() ~= 1 end )

    --- @group: desync
    setup.desync_side = gui.add_item( "Anti-Aim", SETUP_NAME("Desync Side"), menu.add_selection( "Anti-Aim", SETUP_NAME("Desync Side"), {"Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"} ), true, CONDITION )
    setup.left_amount = gui.add_item( "Anti-Aim", SETUP_NAME("Desync Left Amount"), menu.add_slider( "Anti-Aim", SETUP_NAME("Desync Left Amount"), 0, 100 ), true, CONDITION )
    setup.right_amount = gui.add_item( "Anti-Aim", SETUP_NAME("Desync Right Amount"), menu.add_slider( "Anti-Aim", SETUP_NAME("Desync Right Amount"), 0, 100 ), true, CONDITION )
end

conditional_anti_aims.handle = function( ctx )
    local ModeVar = gui.find( "Anti-Aim", "Mode" )

    if ModeVar:get() ~= 2 then
        return
    end

    local Player = entity_list.get_local_player()

    if not Player or not Player:is_alive() then
        return
    end

    local CurrentCondition = engine.get_condition( )

    local MenuElement = conditional_anti_aims.items[CurrentCondition]

    if not MenuElement.enable:get() then
        return
    end

    --- @group: angles
    e_menu.PITCH:set(MenuElement.pitch:get())
    e_menu.YAW_BASE:set(MenuElement.yaw_base:get())
    e_menu.YAW_ADD:set(MenuElement.yaw_add:get())

    e_menu.ROTATE:set(MenuElement.rotate:get())
    e_menu.ROTATE_RANGE:set(MenuElement.rotate_range:get())
    e_menu.ROTATE_SPEED:set(MenuElement.rotate_speed:get())

    e_menu.JITTER_MODE:set(MenuElement.jitter_mode:get())
    e_menu.JITTER_TYPE:set(MenuElement.jitter_type:get())
    e_menu.JITTER_ADD:set(MenuElement.jitter_add:get())

    e_menu.BODY_LEAN:set(MenuElement.body_lean:get())
    e_menu.BODY_LEAN_VALUE:set(MenuElement.body_lean_value:get())

    --- @group: desync
    e_menu.SIDE_STAND:set(MenuElement.desync_side:get())
    e_menu.SIDE_MOVE:set(MenuElement.desync_side:get())
    e_menu.SIDE_SLOW:set(MenuElement.desync_side:get())

    e_menu.LEFT_AMOUNT_MOVE:set(MenuElement.left_amount:get())
    e_menu.RIGHT_AMOUNT_MOVE:set(MenuElement.right_amount:get())
    e_menu.LEFT_AMOUNT_SLOW:set(MenuElement.left_amount:get())
    e_menu.RIGHT_AMOUNT_SLOW:set(MenuElement.right_amount:get())
    e_menu.LEFT_AMOUNT_STAND:set(MenuElement.left_amount:get())
    e_menu.RIGHT_AMOUNT_STAND:set(MenuElement.right_amount:get())
end
--- @endregion

--- @region: all visual functions
gui.add_item( "Visuals", "Enable Widgets", menu.add_checkbox( "Widgets", "Enable Widgets" ) )

gui.add_item( "Visuals", "Accent text", menu.add_text( "Widgets", "Accent" ), false, function() return gui.find( "Visuals", "Enable Widgets" ):get() end )
gui.add_item( "Visuals", "Accent", gui.find( "Visuals", "Accent text" ):add_color_picker( "Widgets Color", SCRIPT_COLOR, true ), true, function() return gui.find( "Visuals", "Enable Widgets" ):get()end )

--- @element: widgets - watermark
local w_watermark = { }

w_watermark.note = notes.create( "a_watermark" )

w_watermark.enable = gui.add_item( "Visuals", "Watermark", menu.add_checkbox( "Widgets", "Watermark" ), true, function()
    return gui.find( "Visuals", "Enable Widgets" ):get()
end )

w_watermark.handle = function( )
    local AccentVar = gui.find( "Visuals", "Accent" ):get()

    w_watermark.note:set_state( w_watermark.enable:get() )
    w_watermark.note:get( function( id )
        local Color = color_t( AccentVar.r, AccentVar.g, AccentVar.b, 255 )

        local Hours, Minutes, Seconds = client.get_local_time( )
        local ActualTime = ( "%02d:%02d:%02d" ):format( Hours, Minutes, Seconds )

        local Nickname = user.name

        local Prefix = {
            First = SCRIPT_NAME:sub( 1, #SCRIPT_NAME / 2 ),
            Second = SCRIPT_NAME:sub( ( #SCRIPT_NAME / 2 ) + 1, #SCRIPT_NAME ),
        }

        local Text = {
            { font = fonts.verdana.ANTIALIAS_DROPSHADOW, text = Prefix.First },
            { font = fonts.verdana.ANTIALIAS_DROPSHADOW, text = Prefix.Second, color = Color },
            { font = fonts.verdana.ANTIALIAS_DROPSHADOW, text = ( " | %s" ):format( Nickname ) },
        }

        if engine.is_in_game() then
            local Latency = math.floor( engine.get_latency( e_latency_flows.INCOMING ) )

            if Latency > 5 then
                local LatencyText = ( " | delay: %dms" ):format( Latency )

                table.insert( Text, { font = fonts.verdana.ANTIALIAS_DROPSHADOW, text = LatencyText } )
            end
        end

        table.insert( Text, { font = fonts.verdana.ANTIALIAS_DROPSHADOW, text = ( " | %s" ):format( ActualTime ) } )

        local TextWidth, TextHeight = render.get_multitext_size( Text ), 12

        local Screen = render.get_screen_size( )

        local Width, Height = animation.new( "watermark::width", TextWidth + 10, 8 ), 22

        local x, y = Screen.x, 8 + ( 25 * id )

        x = x - Width - 10

        render.container( x, y, Width, Height, Color )

        render.multitext( vec2_t(x + (Width / 2) - (TextWidth / 2), y + (Height / 2) - (TextHeight / 2)), Text )
    end )
end
--- @endregion

--- @region: config system
local config_system = { }

config_system.export = function( )
    local MenuElements = { }

    for tabs, elements in pairs(gui.items) do
        local CacheTab = { }

        for name, value in pairs(elements) do
            local CacheElement = { }

            if not value.ToSave then
                goto skip
            end

            CacheElement.value = value.Reference:get()

            if type(CacheElement.value) == "userdata" then
                CacheElement.value = {CacheElement.value.r, CacheElement.value.g, CacheElement.value.b, CacheElement.value.a}
            end

            if CacheElement.value == nil then
                goto skip
            end

            CacheTab[name] = CacheElement

            ::skip::
        end

        MenuElements[tabs] = CacheTab
    end

    local JsonConfig = json.encode( MenuElements )
    local EncodedConfig = base64.encode( JsonConfig )

    clipboard.set(EncodedConfig)
end

config_system.import = function( )
    local protected = function( )
        local Text = clipboard.get( )

        local DecodedConfig = base64.decode( Text )
        local JsonConfig = json.parse( DecodedConfig )

        if not JsonConfig then
            print( "Config error" )

            return
        end

        for tabs, elements in pairs(JsonConfig) do
            for name, config in pairs(elements) do
                if gui.items[tabs][name] then
                    if config.value ~= nil then
                        gui.items[tabs][name].Reference:set(type(config.value) == "table" and color_t(unpack(config.value)) or config.value)
                    end
                end
            end
        end
    end

    local status, message = pcall( protected )

    if not status then
        print( "Failed to load config:", message )

        return
    end
end

gui.add_item( "Global", "Export config to clipboard", menu.add_button( "Main", "Export config to clipboard", function( )
    config_system.export( )
end), false )

gui.add_item( "Global", "Import config from clipboard", menu.add_button( "Main", "Import config from clipboard", function( )
    config_system.import( )
end), false )
--- @endregion

--- @region: callback section
callbacks.add(e_callbacks.PAINT, function( )
    --- @tab: visuals
    --- @group: widgets
    local MasterSwitchWidgets = gui.find( "Visuals", "Enable Widgets" )
    if MasterSwitchWidgets:get( ) then
        w_watermark.handle( )
    end

    --- @tab: none
    --- @group: none
    --- @info: update gui functions
    gui.update_visible( )
end)

callbacks.add(e_callbacks.ANTIAIM, function( ctx )
    --- @tab: anti-aim
    --- @group: anti-aim
    local MasterSwitchAntiAim = gui.find( "Anti-Aim", "Enable Anti-Aim" )

    if MasterSwitchAntiAim:get( ) then
        conditional_anti_aims.handle( ctx )
    end
end)
--- @endregion