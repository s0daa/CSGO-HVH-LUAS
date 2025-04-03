ffi.cdef[[
    struct vec3_t {
        float x;
        float y;
        float z;   
    };

    typedef void( __thiscall* energy_splash_fn )( void*, const struct vec3_t& position, const struct vec3_t& direction, bool explosive );
]]

local native = { }

native.bind_argument = function( fn, arg )
    return function( ... )
        return fn( arg, ... );
    end
end

native.effects_interface = ffi.cast( ffi.typeof( "uintptr_t**" ), memory.create_interface( "client.dll", "IEffects001" ) );

native.energy_splash = native.bind_argument( ffi.cast( "energy_splash_fn", native.effects_interface[ 0 ][ 7 ] ), native.effects_interface );


local material_name = "effects/spark"

local enable = menu.add_checkbox("AutoPeek", "Primordial Spark Autopeek", true)
local color = enable:add_color_picker('color___')
local radius = menu.add_slider('AutoPeek', 'Radius (0 = Default)', 0, 50)
local rotation_step = menu.add_slider('AutoPeek', 'Rotation Speed (0 = Default)', 0, 50)

local auto_peek_cog = menu.find('aimbot', 'general', 'misc', 'autopeek')

local constants = {
    PI = 3.14159265358979323846,
    RADIUS = 25.0,
    ROTATION_STEP = 0.06,
    SPARKS_MATERIAL = materials.find(material_name),
    FL_ONGROUND = bit.lshift( 1, 0 )
}

constants.MAX_ROTATION = constants.PI * 2.0;
constants.DIRECTION_VECTOR = ffi.new( "struct vec3_t" );
constants.DIRECTION_VECTOR.x = 0;
constants.DIRECTION_VECTOR.y = 0;
constants.DIRECTION_VECTOR.z = 0;

local variables = {
    current_rotation = 0.0,
    current_peek_position = vec3_t( 0, 0, 0 ),
    has_valid_peek_position = false,
    last_particle_color = color:get(),
    needs_to_modulate = true
}

callbacks.add(e_callbacks.PAINT, function()
    if not enable:get() then return end
    if not engine.is_in_game() then
        variables.needs_to_modulate = true
    end

    local clr = color:get()

    if variables.last_particle_color ~= color or variables.needs_to_modulate then
        constants.SPARKS_MATERIAL:color_modulate(clr.r / 255.0, clr.g / 255.0, clr.b / 255)
        constants.SPARKS_MATERIAL:alpha_modulate(clr.a / 255.0)

        variables.last_particle_color = clr

        if variables.needs_to_modulate then
            variables.needs_to_modulate = false
        end
    end
end)

variables.latest_ground_h = 0

callbacks.add(e_callbacks.RUN_COMMAND, function()
    if not enable:get() then return end
    if not auto_peek_cog[2]:get() then
        return
    end

    local lp = entity_list.get_local_player()

    local origin = lp:get_render_origin()

    local flags = lp:get_prop('m_fFlags')

    if bit.band( flags, constants.FL_ONGROUND ) == 1 then
        variables.latest_ground_h = origin.z
    end

    variables.current_peek_position = ragebot.get_autopeek_pos()

    if not variables.current_peek_position then return end

    constants.RADIUS = radius:get() == 0 and 25 or radius:get()
    constants.ROTATION_STEP = rotation_step:get() == 0 and 0.06 or rotation_step:get()/100

    variables.current_rotation = variables.current_rotation + constants.ROTATION_STEP

    local spark_position = ffi.new( "struct vec3_t" )
    spark_position.x = constants.RADIUS * math.cos( variables.current_rotation ) + variables.current_peek_position.x
    spark_position.y = constants.RADIUS * math.sin( variables.current_rotation ) + variables.current_peek_position.y
    spark_position.z = variables.latest_ground_h

    native.energy_splash( spark_position, constants.DIRECTION_VECTOR, false )

    if variables.current_rotation > constants.MAX_ROTATION then
        variables.current_rotation = 0.0;
    end
end)