--- @region: vector
local vector_c = {}
local vector_mt = { __index = vector_c }

--- @info: Create a new vector object.
--- @param: x: number
--- @param: y: number
--- @param: z: number
--- @return: vector_c
function vector_c.new(x, y, z)
	return setmetatable({
		x = x ~= nil and x or 0,
		y = y ~= nil and y or 0,
		z = z ~= nil and z or 0
	},vector_mt)
end

--- @info: Offset the vector's coordinates. Nil will leave the coordinates unchanged.
--- @param: x_offset: number
--- @param: y_offset: number
--- @param: z_offset: number
--- @return: void
function vector_c:offset(x_offset, y_offset, z_offset)
	x_offset = x_offset or 0
	y_offset = y_offset or 0
	z_offset = z_offset or 0

	self.x = self.x + x_offset
	self.y = self.y + y_offset
	self.z = self.z + z_offset
end

--- @info: Unpack the vector.
--- @return: number, number, number
function vector_c:unpack()
	return self.x, self.y, self.z
end

--- @info: Set the vector's coordinates to 0.
--- @return: void
function vector_c:nullify()
	self.x = 0
	self.y = 0
	self.z = 0
end

--- @info: Returns a string representation of the vector.
function vector_mt.__tostring(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- @info: Concatenates the vector in a string.
function vector_mt.__concat(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- @info: Returns true if the vector's coordinates are equal to another vector.
function vector_mt.__eq(operand_a, operand_b)
	return (operand_a.x == operand_b.x) and (operand_a.y == operand_b.y) and (operand_a.z == operand_b.z)
end

--- @info: Returns true if the vector is less than another vector.
function vector_mt.__lt(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a < operand_b.x) or (operand_a < operand_b.y) or (operand_a < operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x < operand_b) or (operand_a.y < operand_b) or (operand_a.z < operand_b)
	end

	return (operand_a.x < operand_b.x) or (operand_a.y < operand_b.y) or (operand_a.z < operand_b.z)
end

--- @info: Returns true if the vector is less than or equal to another vector.
function vector_mt.__le(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a <= operand_b.x) or (operand_a <= operand_b.y) or (operand_a <= operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x <= operand_b) or (operand_a.y <= operand_b) or (operand_a.z <= operand_b)
	end

	return (operand_a.x <= operand_b.x) or (operand_a.y <= operand_b.y) or (operand_a.z <= operand_b.z)
end


--- @info: Add a vector to another vector.
function vector_mt.__add(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector_c.new(
			operand_a + operand_b.x,
			operand_a + operand_b.y,
			operand_a + operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector_c.new(
			operand_a.x + operand_b,
			operand_a.y + operand_b,
			operand_a.z + operand_b
		)
	end

	return vector_c.new(
		operand_a.x + operand_b.x,
		operand_a.y + operand_b.y,
		operand_a.z + operand_b.z
	)
end

--- @info: Subtract a vector from another vector.
function vector_mt.__sub(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector_c.new(
			operand_a - operand_b.x,
			operand_a - operand_b.y,
			operand_a - operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector_c.new(
			operand_a.x - operand_b,
			operand_a.y - operand_b,
			operand_a.z - operand_b
		)
	end

	return vector_c.new(
		operand_a.x - operand_b.x,
		operand_a.y - operand_b.y,
		operand_a.z - operand_b.z
	)
end

--- @info: Multiply a vector with another vector.
function vector_mt.__mul(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector_c.new(
			operand_a * operand_b.x,
			operand_a * operand_b.y,
			operand_a * operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector_c.new(
			operand_a.x * operand_b,
			operand_a.y * operand_b,
			operand_a.z * operand_b
		)
	end

	return vector_c.new(
		operand_a.x * operand_b.x,
		operand_a.y * operand_b.y,
		operand_a.z * operand_b.z
	)
end

--- @info: Divide a vector by another vector.
function vector_mt.__div(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector_c.new(
			operand_a / operand_b.x,
			operand_a / operand_b.y,
			operand_a / operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector_c.new(
			operand_a.x / operand_b,
			operand_a.y / operand_b,
			operand_a.z / operand_b
		)
	end

	return vector_c.new(
		operand_a.x / operand_b.x,
		operand_a.y / operand_b.y,
		operand_a.z / operand_b.z
	)
end

--- @info: Raised a vector to the power of another vector.
function vector_mt.__pow(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector_c.new(
			math.pow(operand_a, operand_b.x),
			math.pow(operand_a, operand_b.y),
			math.pow(operand_a, operand_b.z)
		)
	end

	if (type(operand_b) == "number") then
		return vector_c.new(
			math.pow(operand_a.x, operand_b),
			math.pow(operand_a.y, operand_b),
			math.pow(operand_a.z, operand_b)
		)
	end

	return vector_c.new(
		math.pow(operand_a.x, operand_b.x),
		math.pow(operand_a.y, operand_b.y),
		math.pow(operand_a.z, operand_b.z)
	)
end

--- @info: Performs a modulo operation on a vector with another vector.
function vector_mt.__mod(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector_c.new(
			operand_a % operand_b.x,
			operand_a % operand_b.y,
			operand_a % operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector_c.new(
			operand_a.x % operand_b,
			operand_a.y % operand_b,
			operand_a.z % operand_b
		)
	end

	return vector_c.new(
		operand_a.x % operand_b.x,
		operand_a.y % operand_b.y,
		operand_a.z % operand_b.z
	)
end

--- @info: Perform a unary minus operation on the vector.
function vector_mt.__unm(operand_a)
	return vector_c.new(
		-operand_a.x,
		-operand_a.y,
		-operand_a.z
	)
end

--- @info: Returns the vector's 2 dimensional length squared.
--- @return: number
function vector_c:length2_squared()
	return (self.x * self.x) + (self.y * self.y);
end

--- @info: Return's the vector's 2 dimensional length.
--- @return: number
function vector_c:length2()
	return math.sqrt(self:length2_squared())
end

--- @info: Returns the vector's 3 dimensional length squared.
--- @return: number
function vector_c:length_squared()
	return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
end

--- @info: Return's the vector's 3 dimensional length.
--- @return: number
function vector_c:length()
	return math.sqrt(self:length_squared())
end

--- @info: Returns the vector's dot product.
--- @param: other_vector vector_c
--- @return: number
function vector_c:dot_product(other_vector)
	return (self.x * other_vector.x) + (self.y * other_vector.y) + (self.z * other_vector.z)
end

--- @info: Returns the vector's cross product.
--- @param: other_vector vector_c
--- @return: vector_c
function vector_c:cross_product(other_vector)
	return vector_c.new(
		(self.y * other_vector.z) - (self.z * other_vector.y),
		(self.z * other_vector.x) - (self.x * other_vector.z),
		(self.x * other_vector.y) - (self.y * other_vector.x)
	)
end

--- @info: Returns the 2 dimensional distance between the vector and another vector.
--- @param: other_vector: vector_c
--- @return: number
function vector_c:dist_to_2d(other_vector)
	return (other_vector - self):length2()
end

--- @info: Returns the 3 dimensional distance between the vector and another vector.
--- @param: other_vector: vector_c
--- @return: number
function vector_c:dist_to(other_vector)
	return (other_vector - self):length()
end

--- @param: other_vector: vector_c
--- @return: number
function vector_c:dist_to_2d_sqr(other_vector)
	return (other_vector - self):length2_squared()
end

--- @param: other_vector: vector_c
--- @return: number
function vector_c:dist_to_sqr(other_vector)
	return (other_vector - self):length_squared()
end

--- @info: Lerp to another vector.
--- @param: target: vector_c
--- @param: percentage: number
--- @return vector_c
function vector_c:lerp(target, percentage)
	return self + (target - self) * percentage
end

--- @info: Converts the vector to an angle and returns the pitch, yaw and roll.
--- @return: number, number
function vector_c:angles()
    local temp, pitch, yaw = 0, 0, 0

    if self.y == 0 and self.x == 0 then
        yaw = 0

        if self.z > 0 then 
            pitch = 270
        else 
            pitch = 90
        end
    else 
        yaw = math.atan2(self.y, self.x) * 180 / math.pi

        if yaw < 0 then 
            yaw = yaw + 360
        end

        temp = math.sqrt(self.x * self.x + self.y * self.y)
        pitch = math.atan2(-self.z, temp) * 180 / math.pi

        if pitch < 0 then 
            pitch = pitch + 360
        end
    end

    return pitch, yaw
end

--- @info: Converts the pitch, yaw and roll passed to a forward vector and overwrites the X, Y and Z coordinates with that. Returns itself.
--- @param: pitch: number
--- @param: yaw: number
--- @return: vector_c
function vector_c:init_from_angles(pitch, yaw, roll)
	pitch = pitch or 0
	yaw = yaw or 0
	roll = roll or 0

	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local cp, sp = math.cos(degrees_to_radians(pitch)), math.sin(degrees_to_radians(pitch))
	local cy, sy = math.cos(degrees_to_radians(yaw)), math.sin(degrees_to_radians(yaw))
	local cr, sr = math.cos(degrees_to_radians(roll)), math.sin(degrees_to_radians(roll))

	local forward = vector_c.new(0, 0, 0)

	forward.x = cp * cy
	forward.y = cp * sy
	forward.z = -sp

	return forward
end

--- @info: Returns a copy of the vector, normalized.
--- @return: vector_c
function vector_c:normalized()
	local length = self:length()

	if (length ~= 0) then
		return vector_c.new(
			self.x / length,
			self.y / length,
			self.z / length
		)
	else
		return vector_c.new(0, 0, 1)
	end
end

--- @return: vec3_t
function vector_c:to_vec()
	return vec3_t(self:unpack())
end

--- @param: vec_start: vec3_t
--- @return: vector_c
function vector_c.from_vec(vec_start)
	return vector_c.new(vec_start.x, vec_start.y, vec_start.z)
end
--- @endregion

return vector_c