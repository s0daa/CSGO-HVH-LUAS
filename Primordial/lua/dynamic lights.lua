local ffi = require("ffi")

local function vtable_bind(module, interface, index, type)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or error(interface .. " is nil.")
    return ffi.cast(ffi.typeof(type), addr[0][index]), addr
end

local function __thiscall(func, this)
    return function(...)
        return func(this,...)
    end
end

ffi.cdef[[
    struct vec3_t {
		float x;
		float y;
		float z;	
    };
        
    struct ColorRGBExp32{
        unsigned char r, g, b;
        signed char exponent;
    };
    
    struct dlight_t {
        int flags;
        struct vec3_t origin;
        float radius;
        struct ColorRGBExp32 color;
        float die;
        float decay;
        float minlight;
        int key;
        int style;
        struct vec3_t direction;
        float innerAngle;
        float outerAngle;
    };
]]

local alloc_dlight = __thiscall(vtable_bind('engine.dll', 'VEngineEffects001', 4, 'struct dlight_t*(__thiscall*)(void*, int)'))

local enabled_ref = menu.add_checkbox("[Dynamic light]", "[Dynamic light] Enable")
local color_ref   = enabled_ref:add_color_picker("[Dynamic light] Color")
local offset_ref  = menu.add_slider("[Dynamic light]", "[Dynamic light] Offset", 0, 64)
local radius_ref  = menu.add_slider("[Dynamic light]", "[Dynamic light] Radius", 1, 200)
local style_ref   = menu.add_slider("[Dynamic light]", "[Dynamic light] Style", 0, 11)

local function draw_dlight(data)
    local dlight = alloc_dlight(data.index)

    dlight.key = data.index

    dlight.color.r = data.color.r
    dlight.color.g = data.color.g
    dlight.color.b = data.color.b
    dlight.color.exponent = data.color.a / 8.5

    dlight.flags = data.flags
    dlight.style = data.style
    dlight.direction = data.origin
    dlight.origin = data.origin
    dlight.radius = data.radius
    dlight.decay = data.radius / 5
    dlight.die = data.time
end

function on_paint() 
    if not enabled_ref:get() or not engine.is_in_game() then return end

    local player = entity_list.get_local_player()

    local pos = ffi.new("struct vec3_t")

    local lporigin = player:get_prop("m_vecOrigin")
    local lpz = player:get_prop("m_vecOrigin[2]")

    pos.x = lporigin.x 
    pos.y = lporigin.y 
    pos.z = lpz + offset_ref:get()


    draw_dlight({
        index  = 6666,
        origin = pos,
        radius = radius_ref:get(),
        flags  = 0x2,
        style = style_ref:get(),
        color = color_ref:get(),
        time  = global_vars.cur_time()+1
    })
end

callbacks.add(e_callbacks.PAINT, on_paint)