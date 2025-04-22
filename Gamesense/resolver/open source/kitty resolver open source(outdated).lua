local inspect = require 'gamesense/inspect'
local surface = require 'gamesense/surface'
local resolver_font = surface.create_font("Verdana", 12, 400, 0x200)
local indicatorCheckbox = ui.new_checkbox("MISC", "Miscellaneous", "Resolver debug indicator")
local label_color = ui.new_label("MISC", "Miscellaneous", "Resolver debug Color")
local actual_color = ui.new_color_picker("MISC", "Miscellaneous", "Resolver debug Color", 255, 151, 0, 255 )
local draw_color_resolver = {r = 0,g = 222,b = 255,a = 255}

local bit_band = bit.band
local math_pi = math.pi
local math_min = math.min
local math_max = math.max
local math_deg = math.deg
local math_rad = math.rad
local math_sqrt = math.sqrt
local math_sin = math.sin
local math_cos = math.cos
local math_atan = math.atan
local math_atan2 = math.atan2
local math_acos = math.acos
local math_fmod = math.fmod
local math_ceil = math.ceil
local math_pow = math.pow
local math_abs = math.abs
local math_floor = math.floor

-- region ffi
local ffi = require("ffi")

local line_goes_through_smoke

do
    local success, match = client.find_signature("client.dll",
        "\x55\x8B\xEC\x83\xEC\x08\x8B\x15\xCC\xCC\xCC\xCC\x0F\x57")

    if success and match ~= nil then
        local lgts_type = ffi.typeof("bool(__thiscall*)(float, float, float, float, float, float, short);")

        line_goes_through_smoke = ffi.cast(lgts_type, match)
    end
end
-- endregion

-- region math
function math.round(number, precision)
    local mult = 10 ^ (precision or 0)

    return math.floor(number * mult + 0.5) / mult
end
-- endregion

-- region angle
--- @class angle_c
--- @field public p number Angle pitch.
--- @field public y number Angle yaw.
--- @field public r number Angle roll.
local angle_c = {}
local angle_mt = {
    __index = angle_c
}

--- Overwrite the angle's angles. Nil values leave the angle unchanged.
--- @param angle angle_c
--- @param p_new number
--- @param y_new number
--- @param r_new number
--- @return void
angle_mt.__call = function(angle, p_new, y_new, r_new)
    p_new = p_new or angle.p
    y_new = y_new or angle.y
    r_new = r_new or angle.r

    angle.p = p_new
    angle.y = y_new
    angle.r = r_new
end

--- Create a new angle object.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
local function angle(p, y, r)
    return setmetatable({
        p = p or 0,
        y = y or 0,
        r = r or 0
    }, angle_mt)
end

--- Overwrite the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return void
function angle_c:set(p, y, r)
    p = p or self.p
    y = y or self.y
    r = r or self.r

    self.p = p
    self.y = y
    self.r = r
end

--- Offset the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return void
function angle_c:offset(p, y, r)
    p = self.p + p or 0
    y = self.y + y or 0
    r = self.r + r or 0

    self.p = self.p + p
    self.y = self.y + y
    self.r = self.r + r
end

--- Clone the angle object.
--- @return angle_c
function angle_c:clone()
    return setmetatable({
        p = self.p,
        y = self.y,
        r = self.r
    }, angle_mt)
end

--- Clone and offset the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
function angle_c:clone_offset(p, y, r)
    p = self.p + p or 0
    y = self.y + y or 0
    r = self.r + r or 0

    return angle(self.p + p, self.y + y, self.r + r)
end

--- Clone the angle and optionally override its coordinates.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
function angle_c:clone_set(p, y, r)
    p = p or self.p
    y = y or self.y
    r = r or self.r

    return angle(p, y, r)
end

--- Unpack the angle.
--- @return number, number, number
function angle_c:unpack()
    return self.p, self.y, self.r
end

--- Set the angle's euler angles to 0.
--- @return void
function angle_c:nullify()
    self.p = 0
    self.y = 0
    self.r = 0
end

--- Returns a string representation of the angle.
function angle_mt.__tostring(operand_a)
    return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Concatenates the angle in a string.
function angle_mt.__concat(operand_a)
    return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Adds the angle to another angle.
function angle_mt.__add(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(operand_a + operand_b.p, operand_a + operand_b.y, operand_a + operand_b.r)
    end

    if (type(operand_b) == "number") then
        return angle(operand_a.p + operand_b, operand_a.y + operand_b, operand_a.r + operand_b)
    end

    return angle(operand_a.p + operand_b.p, operand_a.y + operand_b.y, operand_a.r + operand_b.r)
end

--- Subtracts the angle from another angle.
function angle_mt.__sub(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(operand_a - operand_b.p, operand_a - operand_b.y, operand_a - operand_b.r)
    end

    if (type(operand_b) == "number") then
        return angle(operand_a.p - operand_b, operand_a.y - operand_b, operand_a.r - operand_b)
    end

    return angle(operand_a.p - operand_b.p, operand_a.y - operand_b.y, operand_a.r - operand_b.r)
end

--- Multiplies the angle with another angle.
function angle_mt.__mul(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(operand_a * operand_b.p, operand_a * operand_b.y, operand_a * operand_b.r)
    end

    if (type(operand_b) == "number") then
        return angle(operand_a.p * operand_b, operand_a.y * operand_b, operand_a.r * operand_b)
    end

    return angle(operand_a.p * operand_b.p, operand_a.y * operand_b.y, operand_a.r * operand_b.r)
end

--- Divides the angle by the another angle.
function angle_mt.__div(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(operand_a / operand_b.p, operand_a / operand_b.y, operand_a / operand_b.r)
    end

    if (type(operand_b) == "number") then
        return angle(operand_a.p / operand_b, operand_a.y / operand_b, operand_a.r / operand_b)
    end

    return angle(operand_a.p / operand_b.p, operand_a.y / operand_b.y, operand_a.r / operand_b.r)
end

--- Raises the angle to the power of an another angle.
function angle_mt.__pow(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(math.pow(operand_a, operand_b.p), math.pow(operand_a, operand_b.y),
            math.pow(operand_a, operand_b.r))
    end

    if (type(operand_b) == "number") then
        return angle(math.pow(operand_a.p, operand_b), math.pow(operand_a.y, operand_b),
            math.pow(operand_a.r, operand_b))
    end

    return angle(math.pow(operand_a.p, operand_b.p), math.pow(operand_a.y, operand_b.y),
        math.pow(operand_a.r, operand_b.r))
end

--- Performs modulo on the angle with another angle.
function angle_mt.__mod(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(operand_a % operand_b.p, operand_a % operand_b.y, operand_a % operand_b.r)
    end

    if (type(operand_b) == "number") then
        return angle(operand_a.p % operand_b, operand_a.y % operand_b, operand_a.r % operand_b)
    end

    return angle(operand_a.p % operand_b.p, operand_a.y % operand_b.y, operand_a.r % operand_b.r)
end

--- Perform a unary minus operation on the angle.
function angle_mt.__unm(operand_a)
    return angle(-operand_a.p, -operand_a.y, -operand_a.r)
end

--- Clamps the angles to whole numbers. Equivalent to "angle:round" with no precision.
--- @return void
function angle_c:round_zero()
    self.p = math.floor(self.p + 0.5)
    self.y = math.floor(self.y + 0.5)
    self.r = math.floor(self.r + 0.5)
end

--- Round the angles.
--- @param precision number
function angle_c:round(precision)
    self.p = math.round(self.p, precision)
    self.y = math.round(self.y, precision)
    self.r = math.round(self.r, precision)
end

--- Clamps the angles to the nearest base.
--- @param base number
function angle_c:round_base(base)
    self.p = base * math.round(self.p / base)
    self.y = base * math.round(self.y / base)
    self.r = base * math.round(self.r / base)
end

--- Clamps the angles to whole numbers. Equivalent to "angle:round" with no precision.
--- @return angle_c
function angle_c:rounded_zero()
    return angle(math.floor(self.p + 0.5), math.floor(self.y + 0.5), math.floor(self.r + 0.5))
end

--- Round the angles.
--- @param precision number
--- @return angle_c
function angle_c:rounded(precision)
    return angle(math.round(self.p, precision), math.round(self.y, precision), math.round(self.r, precision))
end

--- Clamps the angles to the nearest base.
--- @param base number
--- @return angle_c
function angle_c:rounded_base(base)
    return angle(base * math.round(self.p / base), base * math.round(self.y / base), base * math.round(self.r / base))
end
-- endregion

-- region vector
--- @class vector_c
--- @field public x number X coordinate.
--- @field public y number Y coordinate.
--- @field public z number Z coordinate.
local vector_c = {}
local vector_mt = {
    __index = vector_c
}

--- Overwrite the vector's coordinates. Nil will leave coordinates unchanged.
--- @param vector vector_c
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return void
vector_mt.__call = function(vector, x_new, y_new, z_new)
    x_new = x_new or vector.x
    y_new = y_new or vector.y
    z_new = z_new or vector.z

    vector.x = x_new
    vector.y = y_new
    vector.z = z_new
end

--- Create a new vector object.
--- @param x number
--- @param y number
--- @param z number
--- @return vector_c
local function vector(x, y, z)
    return setmetatable({
        x = x or 0,
        y = y or 0,
        z = z or 0
    }, vector_mt)
end

--- Overwrite the vector's coordinates. Nil will leave coordinates unchanged.
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return void
function vector_c:set(x_new, y_new, z_new)
    x_new = x_new or self.x
    y_new = y_new or self.y
    z_new = z_new or self.z

    self.x = x_new
    self.y = y_new
    self.z = z_new
end

--- Offset the vector's coordinates. Nil will leave the coordinates unchanged.
--- @param x_offset number
--- @param y_offset number
--- @param z_offset number
--- @return void
function vector_c:offset(x_offset, y_offset, z_offset)
    x_offset = x_offset or 0
    y_offset = y_offset or 0
    z_offset = z_offset or 0

    self.x = self.x + x_offset
    self.y = self.y + y_offset
    self.z = self.z + z_offset
end

--- Clone the vector object.
--- @return vector_c
function vector_c:clone()
    return setmetatable({
        x = self.x,
        y = self.y,
        z = self.z
    }, vector_mt)
end

--- Clone the vector object and offset its coordinates. Nil will leave the coordinates unchanged.
--- @param x_offset number
--- @param y_offset number
--- @param z_offset number
--- @return vector_c
function vector_c:clone_offset(x_offset, y_offset, z_offset)
    x_offset = x_offset or 0
    y_offset = y_offset or 0
    z_offset = z_offset or 0

    return setmetatable({
        x = self.x + x_offset,
        y = self.y + y_offset,
        z = self.z + z_offset
    }, vector_mt)
end

--- Clone the vector and optionally override its coordinates.
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return vector_c
function vector_c:clone_set(x_new, y_new, z_new)
    x_new = x_new or self.x
    y_new = y_new or self.y
    z_new = z_new or self.z

    return vector(x_new, y_new, z_new)
end

--- Unpack the vector.
--- @return number, number, number
function vector_c:unpack()
    return self.x, self.y, self.z
end

--- Set the vector's coordinates to 0.
--- @return void
function vector_c:nullify()
    self.x = 0
    self.y = 0
    self.z = 0
end

--- Returns a string representation of the vector.
function vector_mt.__tostring(operand_a)
    return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- Concatenates the vector in a string.
function vector_mt.__concat(operand_a)
    return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- Returns true if the vector's coordinates are equal to another vector.
function vector_mt.__eq(operand_a, operand_b)
    return (operand_a.x == operand_b.x) and (operand_a.y == operand_b.y) and (operand_a.z == operand_b.z)
end

--- Returns true if the vector is less than another vector.
function vector_mt.__lt(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return (operand_a < operand_b.x) or (operand_a < operand_b.y) or (operand_a < operand_b.z)
    end

    if (type(operand_b) == "number") then
        return (operand_a.x < operand_b) or (operand_a.y < operand_b) or (operand_a.z < operand_b)
    end

    return (operand_a.x < operand_b.x) or (operand_a.y < operand_b.y) or (operand_a.z < operand_b.z)
end

--- Returns true if the vector is less than or equal to another vector.
function vector_mt.__le(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return (operand_a <= operand_b.x) or (operand_a <= operand_b.y) or (operand_a <= operand_b.z)
    end

    if (type(operand_b) == "number") then
        return (operand_a.x <= operand_b) or (operand_a.y <= operand_b) or (operand_a.z <= operand_b)
    end

    return (operand_a.x <= operand_b.x) or (operand_a.y <= operand_b.y) or (operand_a.z <= operand_b.z)
end

--- Add a vector to another vector.
function vector_mt.__add(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(operand_a + operand_b.x, operand_a + operand_b.y, operand_a + operand_b.z)
    end

    if (type(operand_b) == "number") then
        return vector(operand_a.x + operand_b, operand_a.y + operand_b, operand_a.z + operand_b)
    end

    return vector(operand_a.x + operand_b.x, operand_a.y + operand_b.y, operand_a.z + operand_b.z)
end

--- Subtract a vector from another vector.
function vector_mt.__sub(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(operand_a - operand_b.x, operand_a - operand_b.y, operand_a - operand_b.z)
    end

    if (type(operand_b) == "number") then
        return vector(operand_a.x - operand_b, operand_a.y - operand_b, operand_a.z - operand_b)
    end

    return vector(operand_a.x - operand_b.x, operand_a.y - operand_b.y, operand_a.z - operand_b.z)
end

--- Multiply a vector with another vector.
function vector_mt.__mul(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(operand_a * operand_b.x, operand_a * operand_b.y, operand_a * operand_b.z)
    end

    if (type(operand_b) == "number") then
        return vector(operand_a.x * operand_b, operand_a.y * operand_b, operand_a.z * operand_b)
    end

    return vector(operand_a.x * operand_b.x, operand_a.y * operand_b.y, operand_a.z * operand_b.z)
end

--- Divide a vector by another vector.
function vector_mt.__div(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(operand_a / operand_b.x, operand_a / operand_b.y, operand_a / operand_b.z)
    end

    if (type(operand_b) == "number") then
        return vector(operand_a.x / operand_b, operand_a.y / operand_b, operand_a.z / operand_b)
    end

    return vector(operand_a.x / operand_b.x, operand_a.y / operand_b.y, operand_a.z / operand_b.z)
end

--- Raised a vector to the power of another vector.
function vector_mt.__pow(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(math.pow(operand_a, operand_b.x), math.pow(operand_a, operand_b.y),
            math.pow(operand_a, operand_b.z))
    end

    if (type(operand_b) == "number") then
        return vector(math.pow(operand_a.x, operand_b), math.pow(operand_a.y, operand_b),
            math.pow(operand_a.z, operand_b))
    end

    return vector(math.pow(operand_a.x, operand_b.x), math.pow(operand_a.y, operand_b.y),
        math.pow(operand_a.z, operand_b.z))
end

--- Performs a modulo operation on a vector with another vector.
function vector_mt.__mod(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(operand_a % operand_b.x, operand_a % operand_b.y, operand_a % operand_b.z)
    end

    if (type(operand_b) == "number") then
        return vector(operand_a.x % operand_b, operand_a.y % operand_b, operand_a.z % operand_b)
    end

    return vector(operand_a.x % operand_b.x, operand_a.y % operand_b.y, operand_a.z % operand_b.z)
end

--- Perform a unary minus operation on the vector.
function vector_mt.__unm(operand_a)
    return vector(-operand_a.x, -operand_a.y, -operand_a.z)
end

--- Returns the vector's 2 dimensional length squared.
--- @return number
function vector_c:length2_squared()
    return (self.x * self.x) + (self.y * self.y);
end

--- Return's the vector's 2 dimensional length.
--- @return number
function vector_c:length2()
    return math.sqrt(self:length2_squared())
end

--- Returns the vector's 3 dimensional length squared.
--- @return number
function vector_c:length_squared()
    return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
end

--- Return's the vector's 3 dimensional length.
--- @return number
function vector_c:length()
    return math.sqrt(self:length_squared())
end

--- Returns the vector's dot product.
--- @param b vector_c
--- @return number
function vector_c:dot_product(b)
    return (self.x * b.x) + (self.y * b.y) + (self.z * b.z)
end

--- Returns the vector's cross product.
--- @param b vector_c
--- @return vector_c
function vector_c:cross_product(b)
    return vector((self.y * b.z) - (self.z * b.y), (self.z * b.x) - (self.x * b.z), (self.x * b.y) - (self.y * b.x))
end

--- Returns the 2 dimensional distance between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance2(destination)
    return (destination - self):length2()
end

--- Returns the 3 dimensional distance between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance(destination)
    return (destination - self):length()
end

--- Returns the distance on the X axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_x(destination)
    return math.abs(self.x - destination.x)
end

--- Returns the distance on the Y axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_y(destination)
    return math.abs(self.y - destination.y)
end

--- Returns the distance on the Z axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_z(destination)
    return math.abs(self.z - destination.z)
end

--- Returns true if the vector is within the given distance to another vector.
--- @param destination vector_c
--- @param distance number
--- @return boolean
function vector_c:in_range(destination, distance)
    return self:distance(destination) <= distance
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
--- @return void
function vector_c:round_zero()
    self.x = math.floor(self.x + 0.5)
    self.y = math.floor(self.y + 0.5)
    self.z = math.floor(self.z + 0.5)
end

--- Round the vector's coordinates.
--- @param precision number
--- @return void
function vector_c:round(precision)
    self.x = math.round(self.x, precision)
    self.y = math.round(self.y, precision)
    self.z = math.round(self.z, precision)
end

--- Clamps the vector's coordinates to the nearest base.
--- @param base number
--- @return void
function vector_c:round_base(base)
    self.x = base * math.round(self.x / base)
    self.y = base * math.round(self.y / base)
    self.z = base * math.round(self.z / base)
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
--- @return vector_c
function vector_c:rounded_zero()
    return vector(math.floor(self.x + 0.5), math.floor(self.y + 0.5), math.floor(self.z + 0.5))
end

--- Round the vector's coordinates.
--- @param precision number
--- @return vector_c
function vector_c:rounded(precision)
    return vector(math.round(self.x, precision), math.round(self.y, precision), math.round(self.z, precision))
end

--- Clamps the vector's coordinates to the nearest base.
--- @param base number
--- @return vector_c
function vector_c:rounded_base(base)
    return vector(base * math.round(self.x / base), base * math.round(self.y / base), base * math.round(self.z / base))
end

--- Normalize the vector.
--- @return void
function vector_c:normalize()
    local length = self:length()

    -- Prevent possible divide-by-zero errors.
    if (length ~= 0) then
        self.x = self.x / length
        self.y = self.y / length
        self.z = self.z / length
    else
        self.x = 0
        self.y = 0
        self.z = 1
    end
end

--- Returns the normalized length of a vector.
--- @return number
function vector_c:normalized_length()
    return self:length()
end

--- Returns a copy of the vector, normalized.
--- @return vector_c
function vector_c:normalized()
    local length = self:length()

    if (length ~= 0) then
        return vector(self.x / length, self.y / length, self.z / length)
    else
        return vector(0, 0, 1)
    end
end

--- Returns a new 2 dimensional vector of the original vector when mapped to the screen, or nil if the vector is off-screen.
--- @return vector_c
function vector_c:to_screen(only_within_screen_boundary)
    local x, y = renderer.world_to_screen(self.x, self.y, self.z)

    if (x == nil or y == nil) then
        return nil
    end

    if (only_within_screen_boundary == true) then
        local screen_x, screen_y = client.screen_size()

        if (x < 0 or x > screen_x or y < 0 or y > screen_y) then
            return nil
        end
    end

    return vector(x, y)
end

--- Returns the magnitude of the vector, use this to determine the speed of the vector if it's a velocity vector.
--- @return number
function vector_c:magnitude()
    return math.sqrt(math.pow(self.x, 2) + math.pow(self.y, 2) + math.pow(self.z, 2))
end

--- Returns the angle of the vector in regards to another vector.
--- @param destination vector_c
--- @return angle_c
function vector_c:angle_to(destination)
    -- Calculate the delta of vectors.
    local delta_vector = vector(destination.x - self.x, destination.y - self.y, destination.z - self.z)

    -- Calculate the yaw.
    local yaw = math.deg(math.atan2(delta_vector.y, delta_vector.x))

    -- Calculate the pitch.
    local hyp = math.sqrt(delta_vector.x * delta_vector.x + delta_vector.y * delta_vector.y)
    local pitch = math.deg(math.atan2(-delta_vector.z, hyp))

    return angle(pitch, yaw)
end

--- Lerp to another vector.
--- @param destination vector_c
--- @param percentage number
--- @return vector_c
function vector_c:lerp(destination, percentage)
    return self + (destination - self) * percentage
end

--- Internally divide a ray.
--- @param source vector_c
--- @param destination vector_c
--- @param m number
--- @param n number
--- @return vector_c
local function vector_internal_division(source, destination, m, n)
    return vector((source.x * n + destination.x * m) / (m + n), (source.y * n + destination.y * m) / (m + n),
        (source.z * n + destination.z * m) / (m + n))
end

--- Returns the result of client.trace_line between two vectors.
--- @param destination vector_c
--- @param skip_entindex number
--- @return number, number|nil
function vector_c:trace_line_to(destination, skip_entindex)
    skip_entindex = skip_entindex or -1

    return client.trace_line(skip_entindex, self.x, self.y, self.z, destination.x, destination.y, destination.z)
end

--- Trace line to another vector and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param skip_entindex number
--- @return number, number, vector_c
function vector_c:trace_line_impact(destination, skip_entindex)
    skip_entindex = skip_entindex or -1

    local fraction, eid = client.trace_line(skip_entindex, self.x, self.y, self.z, destination.x, destination.y,
        destination.z)
    local impact = self:lerp(destination, fraction)

    return fraction, eid, impact
end

--- Trace line to another vector, skipping any entity indices returned by the callback and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param callback fun(eid: number): boolean
--- @param max_traces number
--- @return number, number, vector_c
function vector_c:trace_line_skip_indices(destination, max_traces, callback)
    max_traces = max_traces or 10

    local fraction, eid = 0, -1
    local impact = self
    local i = 0

    while (max_traces >= i and fraction < 1 and ((eid > -1 and callback(eid)) or impact == self)) do
        fraction, eid, impact = impact:trace_line_impact(destination, eid)
        i = i + 1
    end

    return self:distance(impact) / self:distance(destination), eid, impact
end

--- Traces a line from source to destination and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param skip_classes table
--- @param skip_distance number
--- @return number, number
function vector_c:trace_line_skip_class(destination, skip_classes, skip_distance)
    local should_skip = function(index, skip_entity)
        local class_name = entity.get_classname(index) or ""
        for i in 1, #skip_entity do
            if class_name == skip_entity[i] then
                return true
            end
        end

        return false
    end

    local angles = self:angle_to(destination)
    local direction = angles:to_forward_vector()

    local last_traced_position = self

    while true do -- Start tracing.
        local fraction, hit_entity = last_traced_position:trace_line_to(destination)

        if fraction == 1 and hit_entity == -1 then -- If we didn't hit anything.
            return 1, -1 -- return nothing.
        else -- BOIS WE HIT SOMETHING.
            if should_skip(hit_entity, skip_classes) then -- If entity should be skipped.
                -- Set last traced position according to fraction.
                last_traced_position = vector_internal_division(self, destination, fraction, 1 - fraction)

                -- Add a little gap per each trace to prevent inf loop caused by intersection.
                last_traced_position = last_traced_position + direction * skip_distance
            else -- That's the one I want.
                return fraction, hit_entity, self:lerp(destination, fraction)
            end
        end
    end
end

--- Returns the result of client.trace_bullet between two vectors.
--- @param eid number
--- @param destination vector_c
--- @return number|nil, number
function vector_c:trace_bullet_to(destination, eid)
    return client.trace_bullet(eid, self.x, self.y, self.z, destination.x, destination.y, destination.z)
end

--- Returns the vector of the closest point along a ray.
--- @param ray_start vector_c
--- @param ray_end vector_c
--- @return vector_c
function vector_c:closest_ray_point(ray_start, ray_end)
    local to = self - ray_start
    local direction = ray_end - ray_start
    local length = direction:length()

    direction:normalize()

    local ray_along = to:dot_product(direction)

    if (ray_along < 0) then
        return ray_start
    elseif (ray_along > length) then
        return ray_end
    end

    return ray_start + direction * ray_along
end

--- Returns a point along a ray after dividing it.
--- @param ray_end vector_c
--- @param ratio number
--- @return vector_c
function vector_c:ray_divided(ray_end, ratio)
    return (self * ratio + ray_end) / (1 + ratio)
end

--- Returns a ray divided into a number of segments.
--- @param ray_end vector_c
--- @param segments number
--- @return table<number, vector_c>
function vector_c:ray_segmented(ray_end, segments)
    local points = {}

    for i = 0, segments do
        points[i] = vector_internal_division(self, ray_end, i, segments - i)
    end

    return points
end

--- Returns the best source vector and destination vector to draw a line on-screen using world-to-screen.
--- @param ray_end vector_c
--- @param total_segments number
--- @return vector_c|nil, vector_c|nil
function vector_c:ray(ray_end, total_segments)
    total_segments = total_segments or 128

    local segments = {}
    local step = self:distance(ray_end) / total_segments
    local angle = self:angle_to(ray_end)
    local direction = angle:to_forward_vector()

    for i = 1, total_segments do
        table.insert(segments, self + (direction * (step * i)))
    end

    local src_screen_position = vector(0, 0, 0)
    local dst_screen_position = vector(0, 0, 0)
    local src_in_screen = false
    local dst_in_screen = false

    for i = 1, #segments do
        src_screen_position = segments[i]:to_screen()

        if src_screen_position ~= nil then
            src_in_screen = true

            break
        end
    end

    for i = #segments, 1, -1 do
        dst_screen_position = segments[i]:to_screen()

        if dst_screen_position ~= nil then
            dst_in_screen = true

            break
        end
    end

    if src_in_screen and dst_in_screen then
        return src_screen_position, dst_screen_position
    end

    return nil
end

--- Returns true if the ray goes through a smoke. False if not.
--- @param ray_end vector_c
--- @return boolean
function vector_c:ray_intersects_smoke(ray_end)
    if (line_goes_through_smoke == nil) then
        error("Unsafe scripts must be allowed in order to use vector_c:ray_intersects_smoke")
    end

    return line_goes_through_smoke(self.x, self.y, self.z, ray_end.x, ray_end.y, ray_end.z, 1)
end

--- Returns true if the vector lies within the boundaries of a given 2D polygon. The polygon is a table of vectors. The Z axis is ignored.
--- @param polygon table<any, vector_c>
--- @return boolean
function vector_c:inside_polygon2(polygon)
    local odd_nodes = false
    local polygon_vertices = #polygon
    local j = polygon_vertices

    for i = 1, polygon_vertices do
        if (polygon[i].y < self.y and polygon[j].y >= self.y or polygon[j].y < self.y and polygon[i].y >= self.y) then
            if (polygon[i].x + (self.y - polygon[i].y) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) <
                self.x) then
                odd_nodes = not odd_nodes
            end
        end

        j = i
    end

    return odd_nodes
end

--- Draws a world circle with an origin of the vector. Code credited to sapphyrus.
--- @param radius number
--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @param accuracy number
--- @param width number
--- @param outline number
--- @param start_degrees number
--- @param percentage number
--- @return void
function vector_c:draw_circle(radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage)
    local accuracy = accuracy ~= nil and accuracy or 3
    local width = width ~= nil and width or 1
    local outline = outline ~= nil and outline or false
    local start_degrees = start_degrees ~= nil and start_degrees or 0
    local percentage = percentage ~= nil and percentage or 1

    local screen_x_line_old, screen_y_line_old

    for rot = start_degrees, percentage * 360, accuracy do
        local rot_temp = math.rad(rot)
        local lineX, lineY, lineZ = radius * math.cos(rot_temp) + self.x, radius * math.sin(rot_temp) + self.y, self.z
        local screen_x_line, screen_y_line = renderer.world_to_screen(lineX, lineY, lineZ)
        if screen_x_line ~= nil and screen_x_line_old ~= nil then

            for i = 1, width do
                local i = i - 1

                renderer.line(screen_x_line, screen_y_line - i, screen_x_line_old, screen_y_line_old - i, r, g, b, a)
            end

            if outline then
                local outline_a = a / 255 * 160

                renderer.line(screen_x_line, screen_y_line - width, screen_x_line_old, screen_y_line_old - width, 16,
                    16, 16, outline_a)

                renderer.line(screen_x_line, screen_y_line + 1, screen_x_line_old, screen_y_line_old + 1, 16, 16, 16,
                    outline_a)
            end
        end

        screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
    end
end

--- Performs math.min on the vector.
--- @param value number
--- @return void
function vector_c:min(value)
    self.x = math.min(value, self.x)
    self.y = math.min(value, self.y)
    self.z = math.min(value, self.z)
end

--- Performs math.max on the vector.
--- @param value number
--- @return void
function vector_c:max(value)
    self.x = math.max(value, self.x)
    self.y = math.max(value, self.y)
    self.z = math.max(value, self.z)
end

--- Performs math.min on the vector and returns the result.
--- @param value number
--- @return void
function vector_c:minned(value)
    return vector(math.min(value, self.x), math.min(value, self.y), math.min(value, self.z))
end

--- Performs math.max on the vector and returns the result.
--- @param value number
--- @return void
function vector_c:maxed(value)
    return vector(math.max(value, self.x), math.max(value, self.y), math.max(value, self.z))
end
-- endregion

-- region angle_vector_methods
--- Returns a forward vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_forward_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))

    return vector(cp * cy, cp * sy, -sp)
end

--- Return an up vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_up_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))
    local sr = math.sin(degrees_to_radians(self.r))
    local cr = math.cos(degrees_to_radians(self.r))

    return vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

--- Return a right vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_right_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))
    local sr = math.sin(degrees_to_radians(self.r))
    local cr = math.cos(degrees_to_radians(self.r))

    return vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a backward vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_backward_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))

    return -vector(cp * cy, cp * sy, -sp)
end

--- Return a left vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_left_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))
    local sr = math.sin(degrees_to_radians(self.r))
    local cr = math.cos(degrees_to_radians(self.r))

    return -vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a down vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_down_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))
    local sr = math.sin(degrees_to_radians(self.r))
    local cr = math.cos(degrees_to_radians(self.r))

    return -vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

--- Calculate where a vector is in a given field of view.
--- @param source vector_c
--- @param destination vector_c
--- @return number
function angle_c:fov_to(source, destination)
    local fwd = self:to_forward_vector()
    local delta = (destination - source):normalized()
    local fov = math.acos(fwd:dot_product(delta) / delta:length())

    return math.max(0.0, math.deg(fov))
end

--- Returns the degrees bearing of the angle's yaw.
--- @param precision number
--- @return number
function angle_c:bearing(precision)
    local yaw = 180 - self.y + 90
    local degrees = (yaw % 360 + 360) % 360

    degrees = degrees > 180 and degrees - 360 or degrees

    return math.round(degrees + 180, precision)
end

--- Returns the yaw appropriate for renderer circle's start degrees.
--- @return number
function angle_c:start_degrees()
    local yaw = self.y
    local degrees = (yaw % 360 + 360) % 360

    degrees = degrees > 180 and degrees - 360 or degrees

    return degrees + 180
end

--- Returns a copy of the angles normalized and clamped.
--- @return number
function angle_c:normalize()
    local pitch = self.p

    if (pitch < -89) then
        pitch = -89
    elseif (pitch > 89) then
        pitch = 89
    end

    local yaw = self.y

    while yaw > 180 do
        yaw = yaw - 360
    end

    while yaw < -180 do
        yaw = yaw + 360
    end

    return angle(pitch, yaw, 0)
end

--- Normalizes and clamps the angles.
--- @return number
function angle_c:normalized()
    if (self.p < -89) then
        self.p = -89
    elseif (self.p > 89) then
        self.p = 89
    end

    local yaw = self.y

    while yaw > 180 do
        yaw = yaw - 360
    end

    while yaw < -180 do
        yaw = yaw + 360
    end

    self.y = yaw
    self.r = 0
end
-- endregion

-- region functions
--- Draws a polygon to the screen.
--- @param polygon table<number, vector_c>
--- @return void
function vector_c.draw_polygon(polygon, r, g, b, a, segments)
    for id, vertex in pairs(polygon) do
        local next_vertex = polygon[id + 1]

        if (next_vertex == nil) then
            next_vertex = polygon[1]
        end

        local ray_a, ray_b = vertex:ray(next_vertex, (segments or 64))

        if (ray_a ~= nil and ray_b ~= nil) then
            renderer.line(ray_a.x, ray_a.y, ray_b.x, ray_b.y, r, g, b, a)
        end
    end
end

--- Returns the eye position of a player.
--- @param eid number
--- @return vector_c
function vector_c.eye_position(eid)
    local origin = vector(entity.get_origin(eid))
    local duck_amount = entity.get_prop(eid, "m_flDuckAmount") or 0

    origin.z = origin.z + 46 + (1 - duck_amount) * 18

    return origin
end
-- endregion
-- endregion

local function in_air(player)
    local flags = entity.get_prop(player, "m_fFlags")

    if bit_band(flags, 1) == 0 then
        return true
    end

    return false
end

local targetAngle = {}
local pressing_e_timer = {}

local function calc_angle(x_src, y_src, z_src, x_dst, y_dst, z_dst)
    local x_delta = x_src - x_dst
    local y_delta = y_src - y_dst
    local z_delta = z_src - z_dst
    local hyp = math.sqrt(x_delta ^ 2 + y_delta ^ 2)
    local x = math.atan2(z_delta, hyp) * 57.295779513082
    local y = math.atan2(y_delta, x_delta) * 180 / 3.14159265358979323846

    if y > 180 then
        y = y - 180
    end
    if y < -180 then
        y = y + 180
    end
    return y
end

local function normalize_yaw(yaw)
    while yaw > 180 do
        yaw = yaw - 360
    end
    while yaw < -180 do
        yaw = yaw + 360
    end
    return yaw
end

local ffi = require 'ffi'
local crr_t = ffi.typeof('void*(__thiscall*)(void*)')
local cr_t = ffi.typeof('void*(__thiscall*)(void*)')
local gm_t = ffi.typeof('const void*(__thiscall*)(void*)')
local gsa_t = ffi.typeof('int(__fastcall*)(void*, void*, int)')
ffi.cdef [[
    struct animation_layer_t {
        char pad20[24];
        uint32_t m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        char pad20[8];
        float m_flCycle;
        void *m_pOwner;
        char pad_0038[ 4 ];
    };
    struct c_animstate { 
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    };
]]


local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or
                           error('VClientEntityList003 wasnt found', 2)

local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
local get_client_networkable = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][0]) or
                                   error('get_client_networkable_t is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or
                              error('get_client_entity is nil', 2)

local rawivmodelinfo = client.create_interface('engine.dll', 'VModelInfoClient004')
local ivmodelinfo = ffi.cast(classptr, rawivmodelinfo) or error('rawivmodelinfo is nil', 2)
local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', ivmodelinfo[0][32])

local seq_activity_sig = client.find_signature('client.dll', '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83')

local function get_model(b)
    if b then
        b = ffi.cast(classptr, b)
        local c = ffi.cast(crr_t, b[0][0])
        local d = c(b) or error('error getting client unknown', 2)
        if d then
            d = ffi.cast(classptr, d)
            local e = ffi.cast(cr_t, d[0][5])(d) or error('error getting client renderable', 2)
            if e then
                e = ffi.cast(classptr, e)
                return ffi.cast(gm_t, e[0][8])(e) or error('error getting model_t', 2)
            end
        end
    end
end
local function get_sequence_activity(b, c, d)
    b = ffi.cast(classptr, b)
    local e = get_studio_model(ivmodelinfo, get_model(c))
    if e == nil then
        return -1
    end
    local f = ffi.cast(gsa_t, seq_activity_sig)
    return f(b, e, d)
end
local function get_anim_layer(b, c)
    c = c or 1;
    b = ffi.cast(classptr, b)
    return ffi.cast('struct animation_layer_t**', ffi.cast('char*', b) + 0x2990)[0][c]
end

local player_list = ui.reference('PLAYERS', 'Players', 'Player list')
local pl_reset = ui.reference('PLAYERS', 'Players', 'Reset all')

local get_entities = function(enemy_only, alive_only)
    local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true

    local result = {}

    local me = entity.get_local_player()
    local player_resource = entity.get_player_resource()

    for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true

        if enemy_only and not entity.is_enemy(player) then
            is_enemy = false
        end
        if is_enemy then
            if alive_only and entity.get_prop(player_resource, 'm_bAlive', player) ~= 1 then
                is_alive = false
            end
            if is_alive then
                table.insert(result, player)
            end
        end
    end

    return result
end

local resolver_c = {}
local resolver_mt = {
    __index = resolver_c
}

local x = 0

function resolver_c.setup()
    return setmetatable({
        miss_reason = {},
        entity_data = {},
        animstate_data = {},
        animlayer_data = {},
        freestand_data = {},
        misses = 0,
        hit = 0,
        shots = 0
    }, resolver_mt)
end

function resolver_c:reset()

    self.miss_reason = {}
    self.entity_data = {}
    self.animstate_data = {}
    self.animlayer_data = {}
    self.freestand_data = {}

end

function resolver_c:GetAnimationState(_Entity)
    if not (_Entity) then
        return
    end
    local player_ptr = ffi.cast("void***", get_client_entity(ientitylist, _Entity))
    local animstate_ptr = ffi.cast("char*", player_ptr) + 0x9960
    local state = ffi.cast("struct c_animstate**", animstate_ptr)[0]

    return state
end

function GetAnimationState1(_Entity)
    if not (_Entity) then
        return
    end
    local player_ptr = ffi.cast("void***", get_client_entity(ientitylist, _Entity))
    local animstate_ptr = ffi.cast("char*", player_ptr) + 0x9960
    local state = ffi.cast("struct c_animstate**", animstate_ptr)[0]

    return state
end

function GetPlayerMaxFeetYaw1(_Entity)
    local S_animationState_t = GetAnimationState1(_Entity)
    local nDuckAmount = S_animationState_t.m_fDuckAmount
    local nFeetSpeedForwardsOrSideWays = math.max(0, math.min(1, S_animationState_t.m_flFeetSpeedForwardsOrSideWays))
    local nFeetSpeedUnknownForwardOrSideways = math.max(1, S_animationState_t.m_flFeetSpeedUnknownForwardOrSideways)
    local nValue = (S_animationState_t.m_flStopToFullRunningFraction * -0.30000001 - 0.19999999) *
                       nFeetSpeedForwardsOrSideWays + 1
    if nDuckAmount > 0 then
        nValue = nValue + nDuckAmount * nFeetSpeedUnknownForwardOrSideways * (0.5 - nValue)
    end
    local nDeltaYaw = S_animationState_t.m_flMaxYaw * nValue
    return nDeltaYaw < 60 and nDeltaYaw >= 0 and nDeltaYaw or 0
end

function resolver_c:GetPlayerMaxFeetYaw(_Entity)
    local S_animationState_t = self:GetAnimationState(_Entity)
    local nDuckAmount = S_animationState_t.m_fDuckAmount
    local nFeetSpeedForwardsOrSideWays = math.max(0, math.min(1, S_animationState_t.m_flFeetSpeedForwardsOrSideWays))
    local nFeetSpeedUnknownForwardOrSideways = math.max(1, S_animationState_t.m_flFeetSpeedUnknownForwardOrSideways)
    local nValue = (S_animationState_t.m_flStopToFullRunningFraction * -0.30000001 - 0.19999999) *
                       nFeetSpeedForwardsOrSideWays + 1
    if nDuckAmount > 0 then
        nValue = nValue + nDuckAmount * nFeetSpeedUnknownForwardOrSideways * (0.5 - nValue)
    end
    local nDeltaYaw = S_animationState_t.m_flMaxYaw * nValue
    return nDeltaYaw < 60 and nDeltaYaw >= 0 and nDeltaYaw or 0
end

function resolver_c:on_miss(handle)
    local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg",
                            "neck", "?", "gear"} -- hitgroup_names[e.hitgroup + 1] or "?"
    if handle.reason ~= "?" then
        return
    end

    self.misses = self.misses + 1

    if not self.entity_data[handle.target] then
        self.entity_data[handle.target] = {}
    end

    if not self.miss_reason[handle.target] then
        self.miss_reason[handle.target] = {}
    end

    local miss_count = self.entity_data[handle.target].miss or 0

    self.entity_data[handle.target].miss = miss_count + 1

    local miss_data = handle

    local ent_name = entity.get_player_name(handle.target)

    miss_data.name = ent_name

    local yaw = (entity.get_prop(handle.target, "m_flPoseParameter", 11) or 0) * 116 - 58

    local should_fix = self.entity_data[handle.target].miss > 2 and self.entity_data[handle.target].miss < 5

    self.miss_reason[handle.target].count = self.entity_data[handle.target].miss
    self.miss_reason[handle.target].reason = self.entity_data[handle.target].miss > 2 and
                                                 (string.format("lowdelta: %s", yaw) or "?") or "?"

    local fix_value = 20 * (self.entity_data[handle.target].miss % 2 == 0 and -1 or 1)
	self.freestand_data[handle.target].side_fix = fix_value > 0 and "right" or "left"
        plist.set(handle.target, "Force body yaw", true)
        plist.set(handle.target, "Force body yaw value", fix_value)
end

function resolver_c:on_hit(handle)
    self.hit = self.hit + 1
end

function resolver_c:on_fire(handle)
    self.shots = self.shots + 1
end

OverlayRect = function(x, y, w, h, resize_box_h, color_1)
    surface.draw_filled_gradient_rect(x - 1, y - 1, w + 2, h + 2, color_1[1], color_1[2], color_1[3], 255, 20,20,20,200, false)
    surface.draw_filled_gradient_rect(x, y, w, h, 20, 20, 20, 100, 20,20,20,200, false)
    if resize_box_h ~= nil and resize_box_h > 0 then
        resize_box_h = resize_box_h + 5
        surface.draw_filled_gradient_rect(x - 1, y + h + 1, w + 2, resize_box_h, 20,20,20,200, 20,20,20, 0, false)
        surface.draw_filled_gradient_rect(x - 1, y, 1, h + 1 + resize_box_h, color_1[1], color_1[2], color_1[3], 255, 20,20,20, 0, false)
        surface.draw_filled_gradient_rect(x + w, y, 1, h + 1 + resize_box_h, color_1[1], color_1[2], color_1[3], 255, 20,20,20, 0, false)
    end
end

local box_height_space = 0
local box_lenght = {
    s = 150,
    idx = 0
}
function resolver_c:render()

    local me = entity.get_local_player()

    if not me or not entity.is_alive(me) then
        return
    end

    local entities = get_entities(true, true)

    if #entities == 0 then
        self.animlayer_data = {}
        return
    end

    local indicator = {}
    indicator.fix_value = 0
    indicator.name = ""
	indicator.active = false
    indicator.username = ""
	
    for i = 1, #entities do
        local target = entities[i]
        local lpent = get_client_entity(ientitylist, target)
        local lpentnetworkable = get_client_networkable(ientitylist, target)

        local max_yaw = self:GetPlayerMaxFeetYaw(target)

        self.animstate_data[target] = {
            max_yaw = max_yaw
        }

        local act_table = {}

        for i = 1, 12 do
            local layer = get_anim_layer(lpent, i)

            if layer.m_pOwner ~= nil then
                local act = get_sequence_activity(lpent, lpentnetworkable, layer.m_nSequence)

                --[[ if act ~= -1 then
                    --print(string.format('act: %.5f weight: %.5f cycle: %.5f', act, layer.m_flWeight, layer.m_flCycle))
                end

                if act == 964 then
                    --print(string.format('act: %.5f weight: %.5f cycle: %.5f', act, layer.m_flWeight, layer.m_flCycle))
                end

                --renderer.text(10, 200 + 15*i, 255, 255, 255, 255, nil, 0, string.format('act: %.5f weight: %.5f cycle: %.5f', act, layer.m_flWeight, layer.m_flCycle))

                if i == 12 then 
                    renderer.text(10, 200 + 15*13, 255, 255, 255, 255, nil, 0, string.format("max_desync: %s", self:GetPlayerMaxFeetYaw(target)))
                end

                --renderer.indicator(255, 255, 255, 255, string.format('act: %.5f weight: %.5f cycle: %.5f', act, layer.m_flWeight, layer.m_flCycle)) --]]

                act_table[act] = {
                    ["m_nSequence"] = layer.m_nSequence,
                    ["m_flPrevCycle"] = layer.m_flPrevCycle,
                    ["m_flWeight"] = layer.m_flWeight,
                    ["m_flCycle"] = layer.m_flCycle
                }

            end
        end

        self.animlayer_data[target] = act_table

        local lp_origin = vector(entity.get_origin(me))
        local entity_eye_yaw = vector_c.eye_position(target) -- vector(self:GetAnimationState(target).m_flEyeYaw)
        local entity_angle = entity_eye_yaw:angle_to(lp_origin) -- vector(self:GetAnimationState(target).m_flEyeYaw)
        local entity_set_prop = entity.set_prop
        local entity_get_prop = entity.get_prop
        local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")

        local trace_data = {
            left = 0,
            right = 0
        }

        -- :trace_line_impact(destination, skip_entindex)
        for i = entity_angle.y - 90, entity_angle.y + 90, 25 do
            if i ~= entity_angle.y then
                local rad = math.rad(i)

                local point_start = vector(entity_eye_yaw.x + 50 * math.cos(rad), entity_eye_yaw.y + 50 * math.sin(rad),
                    entity_eye_yaw.z)
                local point_end = vector(entity_eye_yaw.x + 256 * math.cos(rad), entity_eye_yaw.y + 256 * math.sin(rad),
                    entity_eye_yaw.z)

                local fraction, eid, impact = point_start:trace_line_impact(point_end, me)

                local side = i < entity_angle.y and "left" or "right"

                trace_data[side] = trace_data[side] + fraction

            end
        end
        local side = trace_data.left < trace_data.right and 1 or 2
        if not self.freestand_data[target] then
            self.freestand_data[target] = {}
        end

        self.freestand_data[target] = {
            side = side,
            side_fix = ""
        }

        local hitbox_pos = {x, y, z}
        hitbox_pos.x, hitbox_pos.y, hitbox_pos.z = entity.hitbox_position(target, 0)
        local local_x, local_y, local_z = entity.get_prop(entity.get_local_player(), "m_vecOrigin")

        local dynamic = calc_angle(local_x, local_y, local_z, hitbox_pos.x, hitbox_pos.y, hitbox_pos.z)
        local Pitch = entity.get_prop(target, "m_angEyeAngles[0]")
        local FakeYaw = math.floor(normalize_yaw(entity.get_prop(target, "m_angEyeAngles[1]")))

        local BackAng = math.floor(normalize_yaw(dynamic + 180))
        local LeftAng = math.floor(normalize_yaw(dynamic - 90))
        local RightAng = math.floor(normalize_yaw(dynamic + 90))
        local ForwAng = math.floor(normalize_yaw(dynamic))
        local AreaDist = 35

        if (RightAng - FakeYaw <= AreaDist and RightAng - FakeYaw > -AreaDist) or
            (RightAng - FakeYaw >= -AreaDist and RightAng - FakeYaw < AreaDist) then
            targetAngle[target] = "right"
        elseif (LeftAng - FakeYaw <= AreaDist and LeftAng - FakeYaw > -AreaDist) or
            (LeftAng - FakeYaw >= -AreaDist and LeftAng - FakeYaw < AreaDist) then
            targetAngle[target] = "left"
        elseif (BackAng - FakeYaw <= AreaDist and BackAng - FakeYaw > -AreaDist) or
            (BackAng - FakeYaw >= -AreaDist and BackAng - FakeYaw < AreaDist) then
            targetAngle[target] = "backward"
        elseif (ForwAng - FakeYaw <= AreaDist and ForwAng - FakeYaw > -AreaDist) or
            (ForwAng - FakeYaw >= -AreaDist and ForwAng - FakeYaw < AreaDist) then
            targetAngle[target] = "forward"
        else
            targetAngle[target] = nil
        end

        -- velocity
        local vec_vel = vector(entity.get_prop(target, 'm_vecVelocity'))
        local velocity = math.floor(math.sqrt(vec_vel.x ^ 2 + vec_vel.y ^ 2) + 0.5)

        -- standing
        local standing = velocity < 1.1
        -- slowwalk
        local slowwalk = in_air(target) == false and velocity > 1.1 and self:GetPlayerMaxFeetYaw(target) >= 37
        -- moving
        local moving = in_air(target) == false and velocity > 1.1 and self:GetPlayerMaxFeetYaw(target) <= 36
        -- air
        local air = in_air(target)

        local pitch_e = Pitch >= -10 and Pitch <= 51
        local pitch_sideways = Pitch <= 90 and Pitch >= 70
        local e_check = targetAngle[target] == "forward" and pitch_e
        local sideways_forward = targetAngle[target] == "forward" and pitch_sideways
        local sideways_left_right = ((targetAngle[target] == "left") or (targetAngle[target] == "right")) and
                                        pitch_sideways

        if e_check then
            if pressing_e_timer[target] == nil then
                pressing_e_timer[target] = 0
            end
            pressing_e_timer[target] = pressing_e_timer[target] + 1
        else
            pressing_e_timer[target] = 0
        end

        local pressing_e = e_check and pressing_e_timer[target] > 5 and not in_air(target)
        local onshot = e_check and pressing_e_timer[target] < 5 and not in_air(target)

        local calculate_angles = side == 1 and -1 or 1
        local calculate_phase = self.entity_data[target] and (self.entity_data[target].miss % 4 < 2 and 1 or 2) or 1
        local calculate_phase_sw = self.entity_data[target] and
                                       (self.entity_data[target].miss % 5 < 1 and 1 or
                                           (self.entity_data[target].miss % 5 < 3 and 2 or 3)) or 1
        local calculate_invert = self.entity_data[target] and (self.entity_data[target].miss % 2 == 1 and 1 or -1) or -1

        bruteforce_phases = {
            -- Stanidng players
            standing = {
                [1] = -50,
                [2] = 50,
                [3] = 30,
                [4] = 0
            },
            moving = {
                [1] = -max_yaw,
                [2] = max_yaw,
                [3] = max_yaw,
                [4] = 0
            },
            air = {
                [1] = -max_yaw,
                [2] = max_yaw,
                [3] = max_yaw,
                [4] = 0
            },
            slowwalk = {
                [1] = 30,
                [2] = -max_yaw,
                [3] = max_yaw,
                [4] = max_yaw,
                [5] = 0
            },
            pressing_e = {
                [1] = 0,
                [2] = -58,
                [3] = 58,
                [4] = 58
            },
            onshot = {
                [1] = 60,
                [2] = -60,
                [3] = -60
            },
            other = {
                [1] = -max_yaw,
                [2] = max_yaw,
                [3] = max_yaw,
                [4] = 0
            }
        }

        -- suuuuuuuuuuuuuuuuuusssssssssssssssss

            table.insert(indicator, {
                name = "standing",
                fix_value = bruteforce_phases.standing[calculate_phase] * calculate_invert * calculate_angles,
                active = standing and not moving and not slowwalk and not air and not pressing_e and not onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "moving",
                fix_value = bruteforce_phases.moving[calculate_phase] * calculate_invert * calculate_angles,
                active = moving and not slowwalk and not air and not pressing_e and not onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "slowwalk",
                fix_value = bruteforce_phases.slowwalk[calculate_phase],
                active = slowwalk and not air and not pressing_e and not onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "in air",
                fix_value = bruteforce_phases.air[calculate_phase] * calculate_invert * calculate_angles,
                active = air and not pressing_e and not onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "e",
                fix_value = bruteforce_phases.pressing_e[calculate_phase] * calculate_invert * calculate_angles,
                active = pressing_e and not onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "fired",
                fix_value = bruteforce_phases.onshot[calculate_phase] * calculate_invert * calculate_angles,
                active = onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "forward",
                fix_value = (max_yaw / 2 + (max_yaw / 4)) * calculate_invert * calculate_angles * (-2),
                active = sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "left/right",
                fix_value = (max_yaw / 2 - 4) * calculate_invert * calculate_angles,
                active = sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
    end
    if ui.get(indicatorCheckbox) then
        local spacex = 0

        local draw_pos = {
            x = 400,
            y = 330,
            w = box_lenght.s,
            h = 20
        }
        local box_r, box_g, box_b = ui.get(actual_color)
        OverlayRect(draw_pos.x, draw_pos.y, draw_pos.w, draw_pos.h, box_height_space, {box_r, box_g, box_b})

        local text_title = "Kitty Resolver (EDITED)"

        local text_size_title = surface.get_text_size(resolver_font, text_title)
        surface.draw_text(draw_pos.x + draw_pos.w/2 - text_size_title/2, draw_pos.y + (draw_pos.h)/2 - 12/2, box_r, box_g, box_b, 255, resolver_font, text_title)
    
        for i = 1, #indicator, 1 do
            local active = indicator[i].active
            local name = indicator[i].name
            local fix_value = indicator[i].fix_value
            local username = indicator[i].username
            local max_yaw = indicator[i].get_max_yaw

            if active then
                local draw_text = username .. ": " .. name .. "{" .. max_yaw .. "}" .. "[" .. fix_value .. "]"
                local text_size = surface.get_text_size(resolver_font, draw_text)
                surface.draw_text(draw_pos.x + 5, draw_pos.y + (draw_pos.h) + spacex, box_r, box_g, box_b, draw_color_resolver.a, resolver_font, username)
                surface.draw_text(draw_pos.x + 5 + surface.get_text_size(resolver_font, username), draw_pos.y + (draw_pos.h) + spacex, 255,255,255,255, resolver_font, ": " .. name .. "{" .. max_yaw .. "}" .. "[" .. fix_value .. "]")
                if 5 + text_size > box_lenght.s then
                    box_lenght.s = 5 + text_size
                    box_lenght.idx = username
                end
                if 5 + text_size < box_lenght.s and box_lenght.idx == username then
                    box_lenght.s = 150
                end
                spacex = spacex + 18
            end
        end
        box_height_space = spacex
        
    end
    
end

local resolver = resolver_c.setup()

local miss_count_label = ui.new_label("PLAYERS", "Adjustments", "Miss count: 0")

local globals_realtime = globals.realtime

client.set_event_callback("paint", function()

    local ent = ui.get(player_list)

    ui.set(miss_count_label,
        string.format("Miss count: %s", resolver.entity_data[ent] and resolver.entity_data[ent].miss or 0))

    resolver:render()
end)

client.set_event_callback("aim_miss", function(handle)
    resolver:on_miss(handle)
end)

client.set_event_callback("aim_hit", function(handle)
    resolver:on_hit(handle)
end)

client.set_event_callback("aim_fire", function(handle)
    resolver:on_fire(handle)
    -- on_fire
end)

-- RESET values

client.set_event_callback("player_death", function(handle)
    local entity_id = client.userid_to_entindex(handle.userid)
    local attacker_id = client.userid_to_entindex(handle.attacker)
    local me = entity.get_local_player()

    if me == entity_id or me == attacker_id then
        resolver:reset()
    end
end)

client.set_event_callback('cs_game_disconnected', resolver.reset)
client.set_event_callback('game_newmap', resolver.reset)
client.set_event_callback('round_start', resolver.reset)
-- client.set_event_callback("aim_fire", aim_fire)
-- client.set_event_callback("aim_hit", aim_hit)
