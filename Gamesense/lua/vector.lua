local type = type;
local setmetatable = setmetatable;
local tostring = tostring;

local math_pi = math.pi;
local math_min = math.min;
local math_max = math.max;
local math_deg = math.deg;
local math_rad = math.rad;
local math_sqrt = math.sqrt;
local math_sin = math.sin;
local math_cos = math.cos;
local math_atan = math.atan;
local math_acos = math.acos;
local math_fmod = math.fmod;

if type(Vector) == "function" then return end

local _V3_MT = {};
_V3_MT.__index = _V3_MT;

function Vector(x, y, z)

	if (type(x) ~= "number") then
		x = 0.0;
	end

	if (type(y) ~= "number") then
		y = 0.0;
	end

	if (type(z) ~= "number") then
		z = 0.0;
	end

	x = x or 0.0;
	y = y or 0.0;
	z = z or 0.0;

	return setmetatable({x = x, y = y, z = z}, _V3_MT);
end

function _V3_MT.__eq(a, b) -- equal to another vector
	return a.x == b.x and a.y == b.y and a.z == b.z;
end

function _V3_MT.__unm(a) -- unary minus
	return Vector(-a.x, -a.y, -a.z);
end

function _V3_MT.__add(a, b) -- add another vector or number
	local a_type = type(a);
	local b_type = type(b);

	if (a_type == "table" and b_type == "table") then
		return Vector(a.x + b.x, a.y + b.y, a.z + b.z);
	elseif (a_type == "table" and b_type == "number") then
		return Vector(a.x + b, a.y + b, a.z + b);
	elseif (a_type == "number" and b_type == "table") then
		return Vector(a + b.x, a + b.y, a + b.z);
	end
end

function _V3_MT.__sub(a, b) -- subtract another vector or number
	local a_type = type(a);
	local b_type = type(b);

	if (a_type == "table" and b_type == "table") then
		return Vector(a.x - b.x, a.y - b.y, a.z - b.z);
	elseif (a_type == "table" and b_type == "number") then
		return Vector(a.x - b, a.y - b, a.z - b);
	elseif (a_type == "number" and b_type == "table") then
		return Vector(a - b.x, a - b.y, a - b.z);
	end
end

function _V3_MT.__mul(a, b) -- multiply by another vector or number
	local a_type = type(a);
	local b_type = type(b);

	if (a_type == "table" and b_type == "table") then
		return Vector(a.x * b.x, a.y * b.y, a.z * b.z);
	elseif (a_type == "table" and b_type == "number") then
		return Vector(a.x * b, a.y * b, a.z * b);
	elseif (a_type == "number" and b_type == "table") then
		return Vector(a * b.x, a * b.y, a * b.z);
	end
end

function _V3_MT.__div(a, b) -- divide by another vector or number
	local a_type = type(a);
	local b_type = type(b);

	if (a_type == "table" and b_type == "table") then
		return Vector(a.x / b.x, a.y / b.y, a.z / b.z);
	elseif (a_type == "table" and b_type == "number") then
		return Vector(a.x / b, a.y / b, a.z / b);
	elseif (a_type == "number" and b_type == "table") then
		return Vector(a / b.x, a / b.y, a / b.z);
	end
end

function _V3_MT.__tostring(a) -- used for 'tostring( Vector_object )'
	return "( " .. a.x .. ", " .. a.y .. ", " .. a.z .. " )";
end

function _V3_MT:clear() -- zero all vector vars
	self.x = 0.0;
	self.y = 0.0;
	self.z = 0.0;
end

function _V3_MT:clone()
	return Vector(self.x,self.y,self.z);
end

function _V3_MT:unpack() -- returns axes as 3 seperate arguments
	return self.x, self.y, self.z;
end

function _V3_MT:length2dsqr() -- squared 2D length
	return (self.x * self.x) + (self.y * self.y);
end

function _V3_MT:lengthsqr() -- squared 3D length
	return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
end

function _V3_MT:length2d() -- 2D length
	return math_sqrt(self:length2dsqr());
end

function _V3_MT:length() -- 3D length
	return math_sqrt(self:lengthsqr());
end

function _V3_MT:dot(other) -- dot product
	return (self.x * other.x) + (self.y * other.y) + (self.z * other.z);
end

function _V3_MT:cross(other) -- cross product
	return Vector((self.y * other.z) - (self.z * other.y), (self.z * other.x) - (self.x * other.z), (self.x * other.y) - (self.y * other.x));
end

function _V3_MT:dist_to(other) -- 3D length to another vector
	return (other - self):length();
end

function _V3_MT:is_zero(tolerance) -- is the vector zero (within tolerance value, can pass no arg if desired)?
	tolerance = tolerance or 0.001;

	if (self.x < tolerance and self.x > -tolerance and self.y < tolerance and self.y > -tolerance and self.z < tolerance and self.z > -tolerance) then
		return true;
	end

	return false;
end

function _V3_MT:normalize() -- normalizes this vector and returns the length
	local l = self:length();
	if (l <= 0.0) then
		return 0.0;
	end

	self.x = self.x / l;
	self.y = self.y / l;
	self.z = self.z / l;

	return l;
end

function _V3_MT:normalize_no_len() -- normalizes this vector (no length returned)
	local l = self:length();
	if (l <= 0.0) then
		return;
	end

	self.x = self.x / l;
	self.y = self.y / l;
	self.z = self.z / l;
end

function _V3_MT:normalized() -- returns a normalized unit vector
	local l = self:length();
	if (l <= 0.0) then
		return Vector();
	end

	return Vector(self.x / l, self.y / l, self.z / l);
end

function _V3_MT:vec3() -- returns a ev0lve vec3
	return math.vec3(self.x, self.y, self.z);
end


ffi.cdef[[
	  typedef struct {
	    float x;
	    float y;
	    float z;
	  } Vector;
]]
ffi.metatype("Vector",_V3_MT)