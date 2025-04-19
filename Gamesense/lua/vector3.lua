-- credits: Valve Corporation, lua.org, "none"

--
-- todo; add asserts
--       add handling for div by 0
--       change vector normalize
--       add Vector2 and Angle files / implementation
--

-- localize vars
local type         = type;
local setmetatable = setmetatable;
local tostring     = tostring;

local math_pi   = math.pi;
local math_min  = math.min;
local math_max  = math.max;
local math_deg  = math.deg;
local math_rad  = math.rad;
local math_sqrt = math.sqrt;
local math_sin  = math.sin;
local math_cos  = math.cos;
local math_atan = math.atan;
local math_acos = math.acos;
local math_fmod = math.fmod;

-- set up vector3 metatable
local _V3_MT   = {};
_V3_MT.__index = _V3_MT;

--
-- create Vector3 object
--
function Vector3( x, y, z )
    -- check args
    if( type( x ) ~= "number" ) then
        x = 0.0;
    end

    if( type( y ) ~= "number" ) then
        y = 0.0;
    end

    if( type( z ) ~= "number" ) then
        z = 0.0;
    end

    x = x or 0.0;
    y = y or 0.0;
    z = z or 0.0;

    return setmetatable(
        {
            x = x,
            y = y,
            z = z
        },
        _V3_MT
    );
end

--
-- metatable operators
--
function _V3_MT.__eq( a, b ) -- equal to another vector
    return a.x == b.x and a.y == b.y and a.z == b.z;
end

function _V3_MT.__unm( a ) -- unary minus
    return Vector3(
        -a.x,
        -a.y,
        -a.z
    );
end

function _V3_MT.__add( a, b ) -- add another vector or number
    local a_type = type( a );
    local b_type = type( b );

    if( a_type == "table" and b_type == "table" ) then
        return Vector3(
            a.x + b.x,
            a.y + b.y,
            a.z + b.z
        );
    elseif( a_type == "table" and b_type == "number" ) then
        return Vector3(
            a.x + b,
            a.y + b,
            a.z + b
        );
    elseif( a_type == "number" and b_type == "table" ) then
        return Vector3(
            a + b.x,
            a + b.y,
            a + b.z
        );
    end
end

function _V3_MT.__sub( a, b ) -- subtract another vector or number
    local a_type = type( a );
    local b_type = type( b );

    if( a_type == "table" and b_type == "table" ) then
        return Vector3(
            a.x - b.x,
            a.y - b.y,
            a.z - b.z
        );
    elseif( a_type == "table" and b_type == "number" ) then
        return Vector3(
            a.x - b,
            a.y - b,
            a.z - b
        );
    elseif( a_type == "number" and b_type == "table" ) then
        return Vector3(
            a - b.x,
            a - b.y,
            a - b.z
        );
    end
end

function _V3_MT.__mul( a, b ) -- multiply by another vector or number
    local a_type = type( a );
    local b_type = type( b );

    if( a_type == "table" and b_type == "table" ) then
        return Vector3(
            a.x * b.x,
            a.y * b.y,
            a.z * b.z
        );
    elseif( a_type == "table" and b_type == "number" ) then
        return Vector3(
            a.x * b,
            a.y * b,
            a.z * b
        );
    elseif( a_type == "number" and b_type == "table" ) then
        return Vector3(
            a * b.x,
            a * b.y,
            a * b.z
        );
    end
end

function _V3_MT.__div( a, b ) -- divide by another vector or number
    local a_type = type( a );
    local b_type = type( b );

    if( a_type == "table" and b_type == "table" ) then
        return Vector3(
            a.x / b.x,
            a.y / b.y,
            a.z / b.z
        );
    elseif( a_type == "table" and b_type == "number" ) then
        return Vector3(
            a.x / b,
            a.y / b,
            a.z / b
        );
    elseif( a_type == "number" and b_type == "table" ) then
        return Vector3(
            a / b.x,
            a / b.y,
            a / b.z
        );
    end
end

function _V3_MT.__tostring( a ) -- used for 'tostring( vector3_object )'
    return "( " .. a.x .. ", " .. a.y .. ", " .. a.z .. " )";
end

--
-- metatable misc funcs
--
function _V3_MT:clear() -- zero all vector vars
    self.x = 0.0;
    self.y = 0.0;
    self.z = 0.0;
end

function _V3_MT:unpack() -- returns axes as 3 seperate arguments
    return self.x, self.y, self.z;
end

function _V3_MT:length_2d_sqr() -- squared 2D length
    return ( self.x * self.x ) + ( self.y * self.y );
end

function _V3_MT:length_sqr() -- squared 3D length
    return ( self.x * self.x ) + ( self.y * self.y ) + ( self.z * self.z );
end

function _V3_MT:length_2d() -- 2D length
    return math_sqrt( self:length_2d_sqr() );
end

function _V3_MT:length() -- 3D length
    return math_sqrt( self:length_sqr() );
end

function _V3_MT:dot( other ) -- dot product
    return ( self.x * other.x ) + ( self.y * other.y ) + ( self.z * other.z );
end

function _V3_MT:cross( other ) -- cross product
    return Vector3(
        ( self.y * other.z ) - ( self.z * other.y ),
        ( self.z * other.x ) - ( self.x * other.z ),
        ( self.x * other.y ) - ( self.y * other.x )
    );
end

function _V3_MT:dist_to( other ) -- 3D length to another vector
    return ( other - self ):length();
end

function _V3_MT:is_zero( tolerance ) -- is the vector zero (within tolerance value, can pass no arg if desired)?
    tolerance = tolerance or 0.001;

    if( self.x < tolerance and self.x > -tolerance and
        self.y < tolerance and self.y > -tolerance and
        self.z < tolerance and self.z > -tolerance ) then
        return true;
    end

    return false;
end

function _V3_MT:normalize() -- normalizes this vector and returns the length
    local l = self:length();
    if( l <= 0.0 ) then
        return 0.0;
    end

    self.x = self.x / l;
    self.y = self.y / l;
    self.z = self.z / l;

    return l;
end

function _V3_MT:normalize_no_len() -- normalizes this vector (no length returned)
    local l = self:length();
    if( l <= 0.0 ) then
        return;
    end

    self.x = self.x / l;
    self.y = self.y / l;
    self.z = self.z / l;
end

function _V3_MT:normalized() -- returns a normalized unit vector
    local l = self:length();
    if( l <= 0.0 ) then
        return Vector3();
    end

    return Vector3(
        self.x / l,
        self.y / l,
        self.z / l
    );
end

--
-- other math funcs
--
function clamp( cur_val, min_val, max_val ) -- clamp number within 'min_val' and 'max_val'
    if( cur_val < min_val ) then
        return min_val;

    elseif( cur_val > max_val ) then
        return max_val;
    end

    return cur_val;
end

function normalize_angle( angle ) -- ensures angle axis is within [-180, 180]
    local out;
    local str;

    -- bad number
    str = tostring( angle );
    if( str == "nan" or str == "inf" ) then
        return 0.0;
    end

    -- nothing to do, angle is in bounds
    if( angle >= -180.0 and angle <= 180.0 ) then
        return angle;
    end

    -- bring into range
    out = math_fmod( math_fmod( angle + 360.0, 360.0 ), 360.0 );
    if( out > 180.0 ) then
        out = out - 360.0;
    end

    return out;
end

function vector_to_angle( forward ) -- vector -> euler angle
    local l;
    local pitch;
    local yaw;

    l = forward:length();
    if( l > 0.0 ) then
        pitch = math_deg( math_atan( -forward.z, l ) );
        yaw   = math_deg( math_atan( forward.y, forward.x ) );
    else
        if( forward.x > 0.0 ) then
            pitch = 270.0;
        else
            pitch = 90.0;
        end

        yaw = 0.0;
    end

    return Vector3( pitch, yaw, 0.0 );
end

function angle_forward( angle ) -- angle -> direction vector (forward)
    local sin_pitch = math_sin( math_rad( angle.x ) );
    local cos_pitch = math_cos( math_rad( angle.x ) );
    local sin_yaw   = math_sin( math_rad( angle.y ) );
    local cos_yaw   = math_cos( math_rad( angle.y ) );

    return Vector3(
        cos_pitch * cos_yaw,
        cos_pitch * sin_yaw,
        -sin_pitch
    );
end

function angle_right( angle ) -- angle -> direction vector (right)
    local sin_pitch = math_sin( math_rad( angle.x ) );
    local cos_pitch = math_cos( math_rad( angle.x ) );
    local sin_yaw   = math_sin( math_rad( angle.y ) );
    local cos_yaw   = math_cos( math_rad( angle.y ) );
    local sin_roll  = math_sin( math_rad( angle.z ) );
    local cos_roll  = math_cos( math_rad( angle.z ) );

    return Vector3(
        -1.0 * sin_roll * sin_pitch * cos_yaw + -1.0 * cos_roll * -sin_yaw,
        -1.0 * sin_roll * sin_pitch * sin_yaw + -1.0 * cos_roll * cos_yaw,
        -1.0 * sin_roll * cos_pitch
    );
end

function angle_up( angle ) -- angle -> direction vector (up)
    local sin_pitch = math_sin( math_rad( angle.x ) );
    local cos_pitch = math_cos( math_rad( angle.x ) );
    local sin_yaw   = math_sin( math_rad( angle.y ) );
    local cos_yaw   = math_cos( math_rad( angle.y ) );
    local sin_roll  = math_sin( math_rad( angle.z ) );
    local cos_roll  = math_cos( math_rad( angle.z ) );

    return Vector3(
        cos_roll * sin_pitch * cos_yaw + -sin_roll * -sin_yaw,
        cos_roll * sin_pitch * sin_yaw + -sin_roll * cos_yaw,
        cos_roll * cos_pitch
    );
end

function get_FOV( view_angles, start_pos, end_pos ) -- get fov to a vector (needs client view angles, start position (or client eye position for example) and the end position)
    local type_str;
    local fwd;
    local delta;
    local fov;

    fwd   = angle_forward( view_angles );
    delta = ( end_pos - start_pos ):normalized();
    fov   = math_acos( fwd:dot( delta ) / delta:length() );

    return math_max( 0.0, math_deg( fov ) );
end