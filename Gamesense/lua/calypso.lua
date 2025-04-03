--- @global-region: prepare all libraries
--- @region: declare all script library-variables
local item = {}
local base64 = {}
local vtable = {}
local render = {}
local color_mt = {}
local angle_mt = {}
local vector_mt = {}
local references = {}
local gradient_mt = {}
local animation_mt = {}
local notifications = {}
--- @endregion

--- @region: require all libries
local ffi = require("ffi")
local http = require("gamesense/http")
local images = require("gamesense/images")
local entity = require("gamesense/entity")
local clipboard = require("gamesense/clipboard")
local anti_aim_funcs = require("gamesense/antiaim_funcs")
--- @endregion

--- @region: declare all script work-variables
local configs = {}
local misc_tab = {}
local visual_tab = {}
local anti_aim_tab = {}
local obex_data = obex_fetch and obex_fetch() or {username = "scriptleaks", build = "boosters"}
--- @endregion

--- @region: prepare math structure
math.round = function(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

math.clamp = function(src, min, max)
    return math.min(max, math.max(src, min))
end

math.random = function(min, max)
    if min % 1 ~= 0 or max % 1 ~= 0 then
        return client.random_float(min, max)
    else
        return client.random_int(math.min(min, max), math.max(min, max))
    end
end

math.normalize = function(value)
    while value > 180 do
        value = value - 360
    end

    while value < -180 do
        value = value + 360
    end

    return value
end
--- @endregion

--- @region: prepare table structure
table.string = function(self)
    local result = {}
    local counter = 0

    for id, element in pairs(self) do
        result[id] = tostring(element)
        repeat
            counter = counter + 1
        until counter == id
    end

    for id = 1, counter do
        if type(result[id]) == "nil" then
            result[id] = "nil"
        end
    end

    return result
end

table.collect = function(self, ...)
    local result = {}
    local arguments = {...}

    for id = 1, #arguments do
        result[arguments[id]] = self[id]
    end

    return result
end

table.switcher = function(target, self)
    local result = self[target]
    if not result and self.default ~= nil then
        result = self.default
    end

    return type(result) == "function" and result() or result
end
--- @endregion

--- @region: prepare print function
local print = function(...)
    local arguments = table.string({...})
    return client.log(arguments == "string" and arguments or table.concat(arguments, " | "))
end
--- @endregion

--- @region: prepare animation structure
animation_mt.list = {}
animation_mt.__index = animation_mt

animation_mt.is_arguments_valid = function(global_name, start_value, final_value)
    if not global_name or (type(global_name) ~= "string" and type(global_name) ~= "number") then
        print(string.format("[ERROR] [CALLBACK: ANIMATION_LIBRARY (CREATE)] The global name must be either a number or a string, but your global name - %s: %s!", global_name, type(global_name)))
        return false
    end

    if start_value ~= nil and type(start_value) ~= "number" then
        print(string.format("[ERROR] [CALLBACK: ANIMATION_LIBRARY (CREATE)] The start value must be number, but your start value - %s: %s!", start_value, type(start_value)))
        return false
    end

    return true
end

animation_mt.__tostring = function(self)
    return string.format("animation_structure: name - %s, type - %s, progress value - %s.", self.name, self.type or "undefined", self.progress)
end

function animation_mt:lerp(target, speed, delta, duration)
    if speed == 0 then
        return self
    end
    
    if math.abs(self.progress - target) <= delta then
        return target
    end

    local time = math.clamp(globals.frametime() * (speed * 0.01) * 175, 0.01, 1)
    return (target - self.progress) * (time / duration) + self.progress
end

function animation_mt:update(final_value, speed, minimum_delta, duration)
    self.progress = self:lerp(final_value or 0, speed or 50, minimum_delta or 0.000000001, duration or 1)
    return self
end

function animation_mt:get(need_to_floor)
    need_to_floor = need_to_floor == nil and true or need_to_floor
    return need_to_floor and math.floor(self.progress) or self.progress
end

local animation = function(global_name, start_value)
    if not animation_mt.is_arguments_valid(global_name, start_value) then
        return
    end

    if animation_mt.list[global_name] then
        return animation_mt.list[global_name]
    end

    local new_data = {
        name = global_name,
        progress = start_value or 0
    }

    animation_mt.list[global_name] = new_data
    return setmetatable(new_data, animation_mt)
end
--- @endregion

--- @region: prepare color structure
color_mt.__index = color_mt
color_mt.__tostring = function(self)
    return string.format("color(r: %s, g: %s, b: %s, a: %s)", self.r, self.g, self.b, self.a)
end

color_mt.from_hex_to_rgba = function(hex)
    hex = hex:gsub("\a", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6)), tonumber("0x" .. hex:sub(7, 8))
end

color_mt.__add = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return color_mt.new(i1 + i2.r, i1 + i2.g, i1 + i2.b, i1 + i2.a)
    elseif type(i1) == "table" and type(i2) == "number" then
        return color_mt.new(i1.r + i2, i1.g + i2, i1.b + i2, i1.a + i2)
    else
        return color_mt.new(i1.r + i2.r, i1.g + i2.g, i1.b + i2.b, i1.a + i2.a)
    end
end

color_mt.__sub = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return color_mt.new(i1 - i2.r, i1 - i2.g, i1 - i2.b, i1 - i2.a)
    elseif type(i1) == "table" and type(i2) == "number" then
        return color_mt.new(i1.r - i2, i1.g - i2, i1.b - i2, i1.a - i2)
    else
        return color_mt.new(i1.r - i2.r, i1.g - i2.g, i1.b - i2.b, i1.a - i2.a)
    end
end

color_mt.__mul = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return color_mt.new(i1 * i2.r, i1 * i2.g, i1 * i2.b, i1 * i2.a)
    elseif type(i1) == "table" and type(i2) == "number" then
        return color_mt.new(i1.r * i2, i1.g * i2, i1.b * i2, i1.a * i2)
    else
        return color_mt.new(i1.r * i2.r, i1.g * i2.g, i1.b * i2.b, i1.a * i2.a)
    end
end

color_mt.__div = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return color_mt.new(i1 / i2.r, i1 / i2.g, i1 / i2.b, i1 / i2.a)
    elseif type(i1) == "table" and type(i2) == "number" then
        return color_mt.new(i1.r / i2, i1.g / i2, i1.b / i2, i1.a / i2)
    else
        return color_mt.new(i1.r / i2.r, i1.g / i2.g, i1.b / i2.b, i1.a / i2.a)
    end
end

function color_mt:clamp()
    self.r = math.clamp(self.r, 0, 255)
    self.g = math.clamp(self.g, 0, 255)
    self.b = math.clamp(self.b, 0, 255)
    self.a = math.clamp(self.a, 0, 255)

    return self
end

function color_mt:clone(r, g, b, a)
    return color_mt.new(
        (r == nil or r == -1) and self.r or r,
        (g == nil or g == -1) and self.g or g,
        (b == nil or b == -1) and self.b or b,
        (a == nil or a == -1) and self.a or a
    ):clamp()
end

function color_mt:init(r, g, b, a)
    if type(r) == "string" then
        local r, g, b, a = self.from_hex_to_rgba(r)

        self.r = r or self.r
        self.g = g or self.g
        self.b = b or self.b
        self.a = a or self.a
    elseif type(r) == "table" then
        self.r = r.r
        self.g = r.g
        self.b = r.b
        self.a = r.a
    else
        self.r = r or self.r
        self.g = g or self.g
        self.b = b or self.b
        self.a = a or self.a
    end

    return self:clamp()
end

function color_mt:lerp(name, new_color, speed, minimum_delta, duration)
    local objects = {}
    local pointers = {"r", "g", "b", "a"}

    for id = 1, #pointers do
        objects[pointers[id]] = animation(name .. " " .. pointers[id], self[pointers[id]])
    end

    for id, object in pairs(objects) do
        self[id] = object:update(new_color[id], speed, minimum_delta, duration):get(true)
    end

    return self:clamp()
end

function color_mt:from_hex(hex)
    return self:init(hex)
end

function color_mt:to_hex()
    local start_hex = "\a"
    local old_color = self:clone()

	for id, point in pairs({"r", "g", "b", "a"}) do
        local hex = ""
        while old_color[point] > 0 do
            local index = old_color[point] % 16 + 1
			old_color[point] = math.floor(old_color[point] / 16)

			hex = string.sub("0123456789ABCDEF", index, index) .. hex
        end

        if #hex == 0 then
			hex = "00"
		elseif #hex == 1 then
			hex = "0" .. hex
		end

		start_hex = start_hex .. hex
	end

    return start_hex
end

function color_mt:alpha_modulate(a)
    self.a = (a == nil or a == -1) and 255 or a
    return self:clamp()
end

function color_mt:unpack()
    return self.a, self.g, self.b, self.a
end

color_mt.new = function(r, g, b, a)
    return setmetatable({
        r = r or 255,
        g = g or 255,
        b = b or 255,
        a = a or 255
    }, color_mt):clamp()
end

local color = color_mt.new
--- @endregion

--- @region: prepare gradient system
gradient_mt.__index = gradient_mt
gradient_mt.static_lerp = function(old_color, new_color, time)
    return old_color + (new_color - old_color) * time
end

function gradient_mt:create_data(text, first_color, second_color)
    local result = {}
    local length = #text - 1

    local colors = {
        r = (second_color.r - first_color.r) / length,
        g = (second_color.g - first_color.g) / length,
        b = (second_color.b - first_color.b) / length,
        a = (second_color.a - first_color.a) / length
    }

    for id = 1, length + 1 do
        table.insert(result, color(first_color.r, first_color.g, first_color.b, first_color.a))

        first_color.r = first_color.r + colors.r
        first_color.g = first_color.g + colors.g
        first_color.b = first_color.b + colors.b
        first_color.a = first_color.a + colors.a
    end

    return result
end

function gradient_mt:get()
    local result = ""
    for id = 1, #self.data.color do
        result = result .. self.data.color[id]:to_hex() .. self.data.text:sub(id, id)
    end
    return result
end

function gradient_mt:wrap()
    table.insert(self.data.color, 1, self.data.color[#self.data.color])
    table.remove(self.data.color, #self.data.color)
end

function gradient_mt:animate(name, delay)
    if globals.tickcount() % self.tick_count > (delay or 5) then
        self:wrap()
        self.tick_count = globals.tickcount()
    end
    return self
end

gradient_mt.list = {}
gradient_mt.new = function(text, first_color, second_color, global_name)
    if global_name and gradient_mt.list[global_name] then
        return gradient_mt.list[global_name]
    end

    local color_data = gradient_mt:create_data(text, first_color:clone(), second_color:clone())
    local gradient_data = {text = text, color = color_data}

    local data = {
        data = gradient_data,
        tick_count = globals.tickcount()
    }

    if global_name then
        gradient_mt.list[global_name] = data
    end

    return setmetatable(data, gradient_mt)
end

local create_gradient = gradient_mt.new
--- @endregion

--- @region: prepare vector structure
vector_mt.__index = vector_mt
vector_mt.__tostring = function(self)
    return string.format("vector(x: %s, y: %s, z: %s)", self.x, self.y, self.z)
end

vector_mt.__add = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return vector_mt.new(i1 + i2.x, i1 + i2.y, i1 + i2.z)
    elseif type(i1) == "table" and type(i2) == "number" then
        return vector_mt.new(i1.x + i2, i1.y + i2, i1.z + i2)
    else
        return vector_mt.new(i1.x + i2.x, i1.y + i2.y, i1.z + i2.z)
    end
end

vector_mt.__sub = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return vector_mt.new(i1 - i2.x, i1 - i2.y, i1 - i2.z)
    elseif type(i1) == "table" and type(i2) == "number" then
        return vector_mt.new(i1.x - i2, i1.y - i2, i1.z - i2)
    else
        return vector_mt.new(i1.x - i2.x, i1.y - i2.y, i1.z - i2.z)
    end
end

vector_mt.__mul = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return vector_mt.new(i1 * i2.x, i1 * i2.y, i1 * i2.z)
    elseif type(i1) == "table" and type(i2) == "number" then
        return vector_mt.new(i1.x * i2, i1.y * i2, i1.z * i2)
    else
        return vector_mt.new(i1.x * i2.x, i1.y * i2.y, i1.z * i2.z)
    end
end

vector_mt.__div = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return vector_mt.new(i1 / i2.x, i1 / i2.y, i1 / i2.z)
    elseif type(i1) == "table" and type(i2) == "number" then
        return vector_mt.new(i1.x / i2, i1.y / i2, i1.z / i2)
    else
        return vector_mt.new(i1.x / i2.x, i1.y / i2.y, i1.z / i2.z)
    end
end

function vector_mt:clone(x, y, z)
    return vector_mt.new(
        x or self.x,
        y or self.y,
        z or self.z
    )
end

function vector_mt:abs()
    self.x = math.abs(self.x)
    self.y = math.abs(self.y)
    self.z = math.abs(self.z)

    return self
end

function vector_mt:round()
    self.x = math.round(self.x)
    self.y = math.round(self.y)
    self.z = math.round(self.z)

    return self
end

function vector_mt:length()
    return math.sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
end

function vector_mt:length_2d()
    return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

function vector_mt:dist(target)
    return (target - self):length()
end

function vector_mt:dot(target)
    return self.x * target.x + self.y * target.y + self.z * target.z
end

function vector_mt:cross(target)
    return vector_mt.new(
        self.y * target.z - self.z * target.y,
        self.z * target.x - self.x * target.z,
        self.x * target.y - self.y * target.x
    )
end

function vector_mt:normalize()
    local length = self:length()
    if length == 0 then
        self.x = 0
        self.y = 0
        self.z = 1
    else
        self.x = self.x / length
        self.y = self.y / length
        self.z = self.z / length
    end

    return self
end

function vector_mt:get_lerp(final, time)
    return self + (final - self) * time
end

function vector_mt:clamp_lerp(final)
    if math.abs(self.x - final.x) > 0 then
        self.x = final.x
    end

    if math.abs(self.y - final.y) > 0 then
        self.y = final.y
    end

    if math.abs(self.z - final.z) > 0 then
        self.z = final.z
    end

    return self
end

function vector_mt:lerp(final, time)
    local lerp = self:get_lerp(final, time)
  
    self.x = lerp.x
    self.y = lerp.y
    self.z = lerp.z

    return self:clamp_lerp(final)
end

function vector_mt:get_closest_ray(start, final)
    local direction = final - start
    local direction_length = direction:length()

    direction:normalize()
    local direction_along = (self - start):dot(direction)

    if direction_along < 0 then
        return start
    elseif direction_along > direction_length then
        return final
    end

    return start + direction * direction_along
end

function vector_mt:to_screen()
    local x, y = renderer.world_to_screen(self.x, self.y, self.z)
    if not x or not y then
        return nil
    end

    return vector_mt.new(x, y)
end

function vector_mt:get_angle(v2)
    local v_delta = v2 - self
    local v_length = v_delta:length_2d()

    return angle_mt.new(
        math.deg(math.atan2(-v_delta.z, v_length)),
        math.deg(math.atan2(v_delta.y, v_delta.x)),
        0
    )
end

function vector_mt:unpack()
    return self.x, self.y, self.z
end

vector_mt.pack = function(table_target)
    return vector_mt.new(table_target.x, table_target.y)
end

vector_mt.new = function(x, y, z)
    return setmetatable({
        x = x or 0,
        y = y or 0,
        z = z or 0
    }, vector_mt)
end

local vector = vector_mt.new
--- @endregion

--- @region: prepare angle structure
angle_mt.__index = angle_mt
angle_mt.__tostring = function(self)
    return string.format("angle(pitch: %s, yaw: %s, roll: %s)", self.p, self.y, self.r)
end

angle_mt.__add = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return angle_mt.new(i1 + i2.p, i1 + i2.y, i1 + i2.r)
    elseif type(i1) == "table" and type(i2) == "number" then
        return angle_mt.new(i1.p + i2, i1.y + i2, i1.r + i2)
    else
        return angle_mt.new(i1.p + i2.p, i1.y + i2.y, i1.r + i2.r)
    end
end

angle_mt.__sub = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return angle_mt.new(i1 - i2.p, i1 - i2.y, i1 - i2.r)
    elseif type(i1) == "table" and type(i2) == "number" then
        return angle_mt.new(i1.p - i2, i1.y - i2, i1.r - i2)
    else
        return angle_mt.new(i1.p - i2.p, i1.y - i2.y, i1.r - i2.r)
    end
end

angle_mt.__mul = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return angle_mt.new(i1 * i2.p, i1 * i2.y, i1 * i2.r)
    elseif type(i1) == "table" and type(i2) == "number" then
        return angle_mt.new(i1.p * i2, i1.y * i2, i1.r * i2)
    else
        return angle_mt.new(i1.p * i2.p, i1.y * i2.y, i1.r * i2.r)
    end
end

angle_mt.__div = function(i1, i2)
    if type(i1) == "number" and type(i2) == "table" then
        return angle_mt.new(i1 / i2.p, i1 / i2.y, i1 / i2.r)
    elseif type(i1) == "table" and type(i2) == "number" then
        return angle_mt.new(i1.p / i2, i1.y / i2, i1.r / i2)
    else
        return angle_mt.new(i1.p / i2.p, i1.y / i2.y, i1.r / i2.r)
    end
end

function angle_mt:clone(p, y, r)
    return angle_mt.new(
        p or self.p,
        y or self.y,
        r or self.r
    )
end

function angle_mt:abs()
    self.p = math.abs(self.p)
    self.y = math.abs(self.y)
    self.r = math.abs(self.r)

    return self
end

function angle_mt:round()
    self.p = math.round(self.p)
    self.y = math.round(self.y)
    self.r = math.round(self.r)

    return self
end

function angle_mt:normalize(need_to_normalize_roll)
    self.y = math.normalize(self.y)
    self.p = math.clamp(self.p, -89, 89)
    self.r = need_to_normalize_roll and 0 or self.r

    return self
end

function angle_mt:get_forward()
    local cos_pitch = math.cos(math.rad(self.p))
    return vector(cos_pitch * math.cos(math.rad(self.y)), cos_pitch * math.sin(math.rad(self.y)), -math.sin(math.rad(self.p)))
end

function angle_mt:get_fov(v1, v2)
    local v_delta = (v2 - v1):normalize()
    local dot_product = self:get_forward():dot(v_delta)

    return math.max(0, math.deg(math.acos(dot_product / v_delta:length())))
end

angle_mt.new = function(p, y, r)
    return setmetatable({
        p = p or 0,
        y = y or 0,
        r = r or 0
    }, angle_mt)
end

--local angle = angle_mt.new
--- @endregion

--- @region: prepare vtable structure
vtable.entry = function(instance, index, type)
    return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

vtable.thunk = function(index, typestring)
    return function(instance, ...)
        if instance then
            return vtable.entry(instance, index, ffi.typeof(typestring))(instance, ...)
        end
    end
end

vtable.bind = function(module, interface, index, typestring)
    local instance = client.create_interface(module, interface)
    local this_call = vtable.entry(instance, index, ffi.typeof(typestring))

    return function(...)
        return this_call(instance, ...)
    end
end
--- @endregion

entity.state_list = {}
entity.flag_bitlist = {
    FL_ONGROUND = bit.lshift(1, 0),
    FL_DUCKING = bit.lshift(1, 1),
    FL_WATERJUMP = bit.lshift(1, 3),
    FL_ONTRAIN = bit.lshift(1, 4),
    FL_INRAIN = bit.lshift(1, 5),
    FL_FROZEN = bit.lshift(1, 6),
    FL_ATCONTROLS = bit.lshift(1, 7),
    FL_CLIENT = bit.lshift(1, 8),
    FL_FAKECLIENT = bit.lshift(1, 9),
    FL_INWATER = bit.lshift(1, 10),
    FL_HIDEHUD_SCOPE = bit.lshift(1, 11)
}

entity.flag_indexes = {
    FL_IN_AIR = 0,
    FL_ONGROUND = 1,
    FL_DUCKING = 2,
    FL_WATERJUMP = 4,
    FL_ONTRAIN = 5,
    FL_INRAIN = 6,
    FL_FROZEN = 7,
    FL_ATCONTROLS = 8,
    FL_CLIENT = 9,
    FL_FAKECLIENT = 10,
    FL_INWATER = 11,
    FL_HIDEHUD_SCOPE = 12,
}

entity.get_user_id = function(user_id)
    return entity.new(client.userid_to_entindex(user_id))
end

function entity:get_origin()
    return vector(self:get_prop("m_vecOrigin"))
end

function entity:get_eye_position()
    return self:get_origin() + vector(self:get_prop("m_vecViewOffset"))
end

function entity:get_velocity()
    return vector(self:get_prop("m_vecVelocity")):length_2d()
end

function entity:get_state()
    if not self.state_list[self:get_player_name()] then
        self.state_list[self:get_player_name()] = {
            jump_timer = 0,
            is_jumping = false
        }
    end

    local flags = self:get_prop("m_fFlags")
    local duck_amount = self:get_prop("m_flDuckAmount")

    local result = nil
    local self_velocity = self:get_velocity()

    local is_local = self == self.get_local_player()
    local self_pointer = self.state_list[self:get_player_name()]
   
    if bit.band(flags, self.flag_bitlist.FL_ONGROUND) == self.flag_indexes.FL_IN_AIR then
        self_pointer.is_jumping = true
        self_pointer.jump_timer = globals.curtime() + 0.02
    else
        self_pointer.is_jumping = self_pointer.jump_timer > globals.curtime()
    end

    if is_local then
        local isFD = ui.get(references.get("Fakeduck"))
        local isSW = ui.get(references.get("Slowwalk")[1]) and ui.get(references.get("Slowwalk")[2])

        if bit.band(flags, self.flag_bitlist.FL_ONGROUND) == self.flag_indexes.FL_ONGROUND then
            result = isSW and "SLOWWALK" or self_velocity > 2 and "MOVING" or "STANDING"
        end

        if isFD or bit.band(flags, self.flag_bitlist.FL_DUCKING) == self.flag_indexes.FL_DUCKING then
            result = self:get_prop("m_iTeamNum") == 2 and "CROUCH T" or "CROUCH CT"
        end
    else
        if bit.band(flags, self.flag_bitlist.FL_ONGROUND) == self.flag_indexes.FL_ONGROUND then
            result = (self_velocity > 5 and self_velocity < 90) and "SLOWWALK" or self_velocity > 2 and "MOVING" or "STANDING"
        end

        if bit.band(flags, self.flag_bitlist.FL_DUCKING) == self.flag_indexes.FL_DUCKING then
            result = "CROUCH"
        end
    end

    if self_pointer.is_jumping then
        result = duck_amount > 0 and "IN CROUCH AIR" or "IN AIR"
    end

    return result
end

entity.get_current_enemy = function()
    return entity.new(client.current_threat())
end
--- @endregion

--- @region: prepare base64 system
base64.extract = function(value, start_point, length)
    return bit.band(bit.rshift(value, start_point), bit.lshift(1, length) - 1)
end

base64.setup_encoder = function(alphabet)
    local encoder = {}
    local new_alphabet = {}

    for letter = 1, #alphabet do
        new_alphabet[letter - 1] = alphabet:sub(letter, letter)
    end

    for key, letter in pairs(new_alphabet) do
        encoder[key] = letter:byte()
    end

    return encoder
end

base64.setup_decoder = function(alphabet)
    local decoder = {}
    local setuped_encoder = base64.setup_encoder(alphabet)

    for key, letter in pairs(setuped_encoder) do
        decoder[letter] = key
    end

    return decoder
end

base64.alphabets = {
    default_encode_alphabet = base64.setup_encoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="),
    default_decode_alphabet = base64.setup_decoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="),

    own_encode_alphabet = base64.setup_encoder("9erxgLoEKvw2bOkXZlQ3nGRpIWSy0uJUdCai7YFsTz6BNHtD5AVjhcf814qmMP+/="),
    own_decode_alphabet = base64.setup_decoder("9erxgLoEKvw2bOkXZlQ3nGRpIWSy0uJUdCai7YFsTz6BNHtD5AVjhcf814qmMP+/=")
}

base64.encode_text = function(text, encode_alphabet)
    text = tostring(text)
    encode_alphabet = encode_alphabet or base64.alphabets.default_encode_alphabet

    local extract = base64.extract
    local text_data = {
        key = 1,
        table = {},
        length = #text
    }

    local cache_for_memoizing = {}
    local last_length = text_data.length % 3

    for letter = 1, text_data.length - last_length, 3 do
        local a, b, c = text:byte(letter, letter + 2)
        local a_value, b_value = 65536, 256

        local value = a * a_value + b * b_value + c
        local cached_text = cache_for_memoizing[value]

        if not cached_text then
            cached_text = string.char(encode_alphabet[extract(value, 18, 6)], encode_alphabet[extract(value, 12, 6)], encode_alphabet[extract(value, 6, 6)], encode_alphabet[extract(value, 0, 6)])
            cache_for_memoizing[value] = cached_text
        end

        text_data.table[text_data.key] = cached_text
        text_data.key = text_data.key + 1
    end

    if last_length == 2 then
        local a, b = text:byte(text_data.length - 1, text_data.length)
        local a_value, b_value = 65536, 256

        local value = a * a_value + b * b_value
        text_data.table[text_data.key] = string.char(encode_alphabet[extract(value, 18, 6)], encode_alphabet[extract(value, 12, 6)], encode_alphabet[extract(value, 6, 6)], encode_alphabet[64])
    end

    if last_length == 1 then
        local a = text:byte(text_data.length)
        local a_value = 65536

        local value = a * a_value
        text_data.table[text_data.key] = string.char(encode_alphabet[extract(value, 18, 6)], encode_alphabet[extract(value, 12, 6)], encode_alphabet[64], encode_alphabet[64])
    end

    local concated_table = table.concat(text_data.table)
    return concated_table
end

base64.decode_text = function(text, decode_alphabet)
    decode_alphabet = decode_alphabet or base64.alphabets.default_decode_alphabet

    local letter_62 = nil
    local letter_63 = nil

    for letter, text in pairs(decode_alphabet) do 
        if text == 62 then
            letter_62 = letter
        elseif text == 63 then
            letter_63 = letter
        end
    end

    local pattern = ("[^%%w%%%s%%%s%%=]"):format(string.char(letter_62), string.char(letter_63))
    text = text:gsub(pattern, "")

    local extract = base64.extract
    local text_data = {
        key = 1,
        table = {},
        length = #text
    }

    local cache_for_memoizing = {}
    local padding = text:sub(-2) == "==" and 2 or text:sub(-1) == "=" and 1 or 0
    
    for letter = 1, padding > 0 and text_data.length - 4 or text_data.length, 4 do
        local a, b, c, d = text:byte(letter, letter + 3)
        if not a or not b or not c or not d then
            return ""
        end

        local a_value, b_value, c_value = 16777216, 65536, 256
        local value_0 = a * a_value + b * b_value + c * c_value + d
        local cached_text = cache_for_memoizing[value_0]

        if not cached_text then
            local new_a_value, new_b_value, new_c_value = 262144, 4096, 64
            local value = decode_alphabet[a] * new_a_value + decode_alphabet[b] * new_b_value + decode_alphabet[c] * new_c_value + decode_alphabet[d]

            cached_text = string.char(extract(value, 16, 8), extract(value, 8, 8), extract(value, 0, 8))
            cache_for_memoizing[value_0] = cached_text
        end

        text_data.table[text_data.key] = cached_text
        text_data.key = text_data.key + 1
    end

    if padding == 1 then
        local a, b, c = text:byte(text_data.length - 3, text_data.length - 1)
        if not a or not b or not c then
            return ""
        end

        local a_value, b_value, c_value = 262144, 4096, 64
        local value = decode_alphabet[a] * a_value + decode_alphabet[b] * b_value + decode_alphabet[c] * c_value

        text_data.table[text_data.key] = string.char(extract(value, 16, 8), extract(value, 8, 8))
    end

    if padding == 2 then
        local a, b = text:byte(text_data.length - 3, text_data.length - 2)
        if not a or not b then
            return ""
        end

        local a_value, b_value = 262144, 4096
        local value = decode_alphabet[a] * a_value + decode_alphabet[b] * b_value

        text_data.table[text_data.key] = string.char(extract(value, 16, 8))
    end

    local concated_table = table.concat(text_data.table)
    return concated_table
end
--- @endregion

--- @region: prepare render structure
local screen_size = vector_mt.pack(table.collect({client.screen_size()}, "x", "y"))
local c_screen_size = screen_size / 2

render.text = function(x, y, color, flags, text)
    local coordinates, colors = type(x) == "table" and {x.x, x.y} or {x, y}, type(x) == "table" and y or color
    local flags, text = type(x) == "table" and (color == nil and "" or color) or flags, tostring(type(x) == "table" and flags or text)

    return renderer.text(coordinates[1], coordinates[2], colors.r, colors.g, colors.b, colors.a, flags, 0, text)
end

render.measure_text = function(text, flags)
    return vector(renderer.measure_text(flags, text))
end

render.circle_outline = function(x, y, color, radius, i_start_degree, percentage, thickness)
    local coordinates, colors = type(x) == "table" and {x.x, x.y} or {x, y}, type(x) == "table" and y or color
    local radius, start_degree = type(x) == "table" and color or radius, type(x) == "table" and radius or i_start_degree
    local percentage, thickness = type(x) == "table" and i_start_degree or percentage, type(x) == "table" and percentage or thickness
    
    return renderer.circle_outline(coordinates[1], coordinates[2], colors.r, colors.g, colors.b, colors.a, radius, start_degree, percentage, thickness)
end

render.gradient = function(x, y, w, h, i_color, i_s_color, direction)
    local coordinates, sizes = type(x) == "table" and {x.x, x.y} or {x, y}, type(x) == "table" and (type(y) == "table" and {y.x, y.y} or {y, w}) or (type(w) == "table" and {w.x, w.y} or {w, h})
    local color, s_color = type(x) == "table" and (type(y) == "table" and w or h) or (type(w) == "table" and h or i_color), type(x) == "table" and (type(y) == "table" and h or i_color) or (type(w) == "table" and i_color or i_s_color)
    local direction = type(x) == "table" and (type(y) == "table" and i_color or i_s_color) or (type(w) == "table" and i_s_color or direction)

    return renderer.gradient(coordinates[1], coordinates[2], sizes[1], sizes[2], color.r, color.g, color.b, color.a, s_color.r, s_color.g, s_color.b, s_color.a, direction)
end

render.indicator = function(color, text)
    return renderer.indicator(color.r, color.g, color.b, color.a, text)
end

render.line = function(x, y, x1, y1, color)
    local coordinates, sizes = type(x) == "table" and {x.x, x.y} or {x, y}, type(x) == "table" and (type(y) == "table" and {y.x, y.y} or {y, x1}) or (type(x1) == "table" and {x1.x, x1.y} or {x1, y1})
    local color = type(x) == "table" and (type(y) == "table" and x1 or y1) or (type(x1) == "table" and y1 or color)

    return renderer.line(coordinates[1], coordinates[2], sizes[1], sizes[2], color.r, color.g, color.b, color.a)
end

render.rectangle = function(x, y, w, h, color)
    local coordinates, sizes = type(x) == "table" and {x.x, x.y} or {x, y}, type(x) == "table" and (type(y) == "table" and {y.x, y.y} or {y, w}) or (type(w) == "table" and {w.x, w.y} or {w, h})
    local color = type(x) == "table" and (type(y) == "table" and w or h) or (type(w) == "table" and h or color)

    return renderer.rectangle(coordinates[1], coordinates[2], sizes[1], sizes[2], color.r, color.g, color.b, color.a)
end

render.triangle = function(x0, y0, x1, y1, x2, y2, color)
    local first, second = type(x0) == "table" and {x0.x, x0.y} or {x0, y0}, type(x0) == "table" and (type(y0) == "table" and {y0.x, y0.y} or {y0, x1}) or (type(x1) == "table" and {x1.x, x1.y} or {x1, y1})
    local third = type(x0) == "table" and (type(y0) == "table" and (type(x1) == "table" and {x1.x, x1.y} or {x1, y1}) 
                  or (type(y1) == "table" and {y1.x, y1.y} or {y1, x2})) or (type(x1) == "table" and (type(y1) == "table" and {y1.x, y1.y} or {y1, x2}) 
                  or (type(x2) == "table" and {x2.x, x2.y} or {x2, y2}))

    local color = type(x0) == "table" and (type(y0) == "table" and (type(x1) == "table" and y1 or x2) 
                  or (type(y1) == "table" and x2 or y2)) or (type(x1) == "table" and (type(y1) == "table" and x2 or y2) 
                  or (type(x2) == "table" and y2 or color))

    return renderer.triangle(first[1], first[2], second[1], second[2], third[1], third[2], color.r, color.g, color.b, color.a)
end

render.blur = function(x, y, w, h)
    local coordinates, sizes = type(x) == "table" and {x.x, x.y} or {x, y}, type(x) == "table" and (type(y) == "table" and {y.x, y.y} or {y, w}) or (type(w) == "table" and {w.x, w.y} or {w, h})
    return renderer.blur(coordinates[1], coordinates[2], sizes[1], sizes[2])
end

render.world_to_screen = function(x, y, z)
    local coordinates = type(x) == "table" and {x.x, x.y, x.z} or {x, y, z}
    return render.world_to_screen(coordinates[1], coordinates[2], coordinates[3])
end
--- @endregion

--- @region: prepare notification structure
notifications.list = {}
notifications.render = function()
    if #notifications.list == 0 then
        return
    end

    local add_y = 0
    local real_time = globals.realtime()
    
    for id, data in pairs(notifications.list) do
        if real_time == data.real_time then
            goto skip
        end

        local g_condition = globals.realtime() % data.real_time > data.time + 2.5
        local p_condition = globals.realtime() % data.real_time > data.time + 1

        if g_condition then
            table.remove(notifications.list, id)
        end

        if id > 10 then
            table.remove(notifications.list, 1)
        end

        --- @note: wtf is this numbers: (10 ^ -10)
        local text_color = color():alpha_modulate(animation(data.unique_name .. "white alpha", 0):update(p_condition and 0 or data.color.a, p_condition and (10 ^ -8) or 0.1):get())
        local main_color = data.color:clone():alpha_modulate(animation(data.unique_name .. "main alpha", 0):update(p_condition and 0 or data.color.a, p_condition and (10 ^ -10) or 0.1):get())

        local text_size = render.measure_text(data.text, "d")
        local vector_size = vector(c_screen_size.x - text_size.x * 0.5, screen_size.y - 100 + add_y)
        
        data.cache.bottom = animation(data.unique_name .. "bottom line", text_size.x + 30):update((p_condition and data.cache.left == 0) and 1 or -text_size.x - 15, 5, 0):get()
        data.cache.left = animation(data.unique_name .. "left line", 0):update((p_condition and data.cache.top == 0) and 1 or (data.cache.bottom <= -text_size.x - 15) and -text_size.y - 7 or 0, 5, 0):get()
        data.cache.top = animation(data.unique_name .. "top line", 0):update((p_condition and data.cache.right == 0) and 0 or data.cache.left <= -text_size.y - 7 and text_size.x + 17 or 0, 5, 0):get()
        data.cache.right = animation(data.unique_name .. "right line", 0):update(p_condition and 0 or (data.cache.top >= text_size.x + 16) and text_size.y + 8 or 0, 5, 0):get()
        data.cache.blur = animation(data.unique_name .. "full blur", 0):update(p_condition and 0 or text_size.x + 16, 0.65, 1):get()

        --- @note: full blur
        render.blur(vector_size.x - 8, vector_size.y - 3, data.cache.blur, text_size.y + 7)

        --- @note: bottom line
        render.rectangle(vector_size.x + text_size.x + 8, vector_size.y + 15, data.cache.bottom, 1, main_color)

        --- @note: left line
        render.rectangle(vector_size.x - 8, vector_size.y + 16, 1, data.cache.left, main_color)
        
        --- @note: top line
        render.rectangle(vector_size.x - 8, vector_size.y - 3, data.cache.top, 1, main_color)

        --- @note: right line
        render.rectangle(vector_size.x + text_size.x + 8, vector_size.y - 3, 1, data.cache.right, main_color)

        --- @note: main text
        render.text(vector_size.x + 1, vector_size.y, text_color, "d", data.text)

        add_y = add_y - 30
        ::skip::
    end
end

notifications.new = function(text, time, i_color)
    local data = {
        time = time or 4,
        real_time = globals.realtime(),

        cache = {},
        color = i_color or color(),

        text = text or "Undefined",
        unique_name = ("%s:%d:%d "):format(text, client.unix_time(), globals.tickcount())
    }

    table.insert(notifications.list, data)
    return data
end

local add_notify = notifications.new
client.set_event_callback("paint_ui", notifications.render)
--- @endregion

--- @region: prepare menu structure
item.list = {}
item.update_visible_data = function()
    for _, info in pairs(item.list) do
        if info.condition ~= nil then
            ui.set_visible(info.data, info.condition())
        end
    end
end

item.new = function(global_name, element, condition, skip, add_function)
    if item.list[global_name] then
        return
    end

    item.list[global_name] = {
        skip = skip,
        data = element,
        condition = condition
    }

    local on_event = function(event_data)
        item.list[global_name].value = event_data
        item.update_visible_data()
    end

    on_event(skip == nil and ui.get(element) or skip)
    ui.set_callback(element, function(pointer)
        if add_function then
            add_function()
        end

        on_event(skip == nil and ui.get(pointer) or false)
    end)

    return element
end

item.get = function(item_name, value)
    local pointer = item.list[item_name]
    if not pointer then
        return
    end

    return ui.get(pointer.data)
end

item.set = function(item_name, new_value)
    local pointer = item.list[item_name]
    if not pointer then
        return
    end
    
    pointer.value = new_value
    ui.set(pointer.data, new_value)

    item.update_visible_data()
end

item.destroy = function(item_name)
    if not item.list[item_name] then
        return
    end

    ui.set_visible(item.list[item_name].data, false)
    item.list[item_name] = nil

    item.update_visible_data()
end

item.find = function(item_name, target)
    local pointer = item.list[item_name]
    if not pointer then
        return
    end

    for id, name in pairs(item.get(item_name)) do
        if target == name then
            return true
        end
    end

    return false
end

item.get_pointer = function(item_name)
    local pointer = item.list[item_name]
    if not pointer then
        return
    end

    return pointer.data
end
--- @endregion

--- @region: prepare bind system
references.list = {
    ["Pitch"] = {ui.reference("AA", "Anti-aimbot angles", "Pitch"), true},
    ["Anti-aim"] = {ui.reference("AA", "Anti-aimbot angles", "Enabled"), true},
    ["Yaw base"] = {ui.reference("AA", "Anti-aimbot angles", "Yaw base"), true},

    ["Yaw"] = {table.collect({ui.reference("AA", "Anti-aimbot angles", "Yaw")}, "type", "value"), true},
    ["Body yaw"] = {table.collect({ui.reference("AA", "Anti-aimbot angles", "Body yaw")}, "type", "value"), true},
    ["Yaw jitter"] = {table.collect({ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")}, "type", "value"), true},

    ["Edge yaw"] = {ui.reference("AA", "Anti-aimbot angles", "Edge yaw"), true},
    ["Freestanding body yaw"] = {ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"), true},

    ["Roll"] = {ui.reference("AA", "Anti-aimbot angles", "Roll"), true},
    ["Freestanding"] = {{ui.reference("AA", "Anti-aimbot angles", "Freestanding")}, true},

    ["Slowwalk"] = {{ui.reference("AA", "Other", "Slow motion")}, false},
    ["Fakeduck"] = {ui.reference("RAGE", "Other", "Duck peek assist"), false},

    ["Doubletap"] = {{ui.reference("RAGE", "Aimbot", "Double tap")}, false},
    ["Hideshots"] = {{ui.reference("AA", "Other", "On shot anti-aim")}, false},

    ["Leg movement"] = {ui.reference("AA", "Other", "Leg movement"), false}
}

references.get = function(name)
    return references.list[name][1]
end
--- @endregion
--- @end global-region

--- @global-region: on script start
anti_aim_tab.manipulate_elements = function(state)
    for _, reference in pairs(references.list) do
        if reference[2] then
            if type(reference[1]) == "table" then
                for _, r_data in pairs(reference[1]) do
                    ui.set_visible(r_data, state)
                end
            else
                ui.set_visible(reference[1], state)
            end
        end
    end
end

client.set_event_callback("paint_ui", function()
    anti_aim_tab.manipulate_elements(false)
end)

client.set_event_callback("shutdown", function()
    anti_aim_tab.manipulate_elements(true)
end)

add_notify(("[Calypso: new notify] Have a good game, %s!"):format(obex_data.username), nil, color(191, 211, 249))
--- @end global-region

--- @global-region: prepare main menu elements
item.new("Enable calypso", ui.new_checkbox("AA", "Anti-aimbot angles", "Enable calypso.codes"))
item.new("Calypso tab", ui.new_combobox("AA", "Anti-aimbot angles", "Current tab:", {"Anti-aim ~ 1", "Anti-aim ~ 2", "Anti-aim ~ 3", "Visualization", "Miscellaneous"}), function()
    return item.get("Enable calypso")
end)
--- @end global-region

--- @global-region: prepare first anti-aim elements
anti_aim_tab.__index = anti_aim_tab

anti_aim_tab.suffixes = {"[S]", "[M]", "[CT]", "[CCT]", "[SW]", "[J]", "[CJ]", "[LAA]"}
anti_aim_tab.presets = {"Safe head", "Centered align", "Safe high jitter", "Aggressive high jitter"}
anti_aim_tab.conditions = {"Hidden", "Standing", "Moving", "Crouching T", "Crouching CT", "Slowwalking", "Jumping", "Crouch jumping"}

item.new("Anti-aim presets", ui.new_combobox("AA", "Anti-aimbot angles", "Current preset:", anti_aim_tab.presets), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 1"
end)

item.new("Anti-aim conditions", ui.new_combobox("AA", "Anti-aimbot angles", "Current condition:", anti_aim_tab.conditions), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 1"
end)

anti_aim_tab.objects = {
    {
        name = "Pitch structure",
        element = function(name)
            return ui.new_combobox("AA", "Anti-aimbot angles", name, {"Disabled", "Default", "Up", "Down", "Minimal", "Random"})
        end
    },
    {
        name = "Yaw build",
        element = function(name)
            return ui.new_combobox("AA", "Anti-aimbot angles", name, {"Static", "Inverter based jitter", "Random based jitter"})
        end
    },
    {
        name = "Yaw adding",
        element = function(name)
            return ui.new_slider("AA", "Anti-aimbot angles", name, -180, 180, 0, true, "°")
        end
    },
    {
        name = "Additional yaw adding",
        element = function(name)
            return ui.new_slider("AA", "Anti-aimbot angles", name, -180, 180, 0, true, "°")
        end
    },

    {
        name = "Modifier type",
        element = function(name)
            return ui.new_combobox("AA", "Anti-aimbot angles", name, {"Disabled", "Center", "Offset", "Random"})
        end
    },
    {
        name = "Modifier build",
        element = function(name)
            return ui.new_combobox("AA", "Anti-aimbot angles", name, {"Static", "Inverter based jitter", "Random based jitter"})
        end
    },
    {
        name = "Body degree",
        element = function(name)
            return ui.new_slider("AA", "Anti-aimbot angles", name, -180, 180, 0, true, "°")
        end
    },
    {
        name = "Additional body degree",
        element = function(name)
            return ui.new_slider("AA", "Anti-aimbot angles", name, -180, 180, 0, true, "°")
        end
    },

    {
        name = "Fake yaw build",
        element = function(name)
            return ui.new_combobox("AA", "Anti-aimbot angles", name, {"Static", "Random based jitter"})
        end
    },
    {
        name = "Fake yaw additional limit",
        element = function(name)
            return ui.new_slider("AA", "Anti-aimbot angles", name, 0, 60, 60, true, "°")
        end
    },

    {
        name = "Body yaw reaction",
        element = function(name)
            return ui.new_combobox("AA", "Anti-aimbot angles", name, {"Disabled", "Opposite", "Jitter", "Static"})
        end
    },
    {
        name = "Body yaw limit",
        element = function(name)
            return ui.new_slider("AA", "Anti-aimbot angles", name, -180, 180, 0, true, "°")
        end
    }
}

for id = 2, #anti_aim_tab.conditions do
    local condition = anti_aim_tab.conditions[id]
    local is_state_applied = "Override settings for "

    item.new(is_state_applied .. condition:lower(), ui.new_checkbox("AA", "Anti-aimbot angles", is_state_applied .. condition:lower() .. ":"), function()
        return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 1" and item.get("Anti-aim conditions") == condition
    end)

    for _, object in pairs(anti_aim_tab.objects) do
        local object_callback = ("%s %s"):format(condition, object.name:lower())
        local object_name = ("%s %s"):format(anti_aim_tab.suffixes[id - 1], object.name)

        item.new(object_callback, object.element(object_name), function()
            return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 1" and item.get("Anti-aim conditions") == condition and item.get(is_state_applied .. condition:lower()) and (function()
                if object_callback == condition .. " additional yaw adding" then
                    return item.get(condition .. " yaw build") ~= "Static"
                end

                if object_callback == condition .. " modifier build" or object_callback == condition .. " body degree" then
                    return item.get(condition .. " modifier type") ~= "Disabled"
                end

                if object_callback == condition .. " additional body degree" then
                    return item.get(condition .. " modifier type") ~= "Disabled" and item.get(condition .. " modifier build") ~= "Static"
                end

                if object_callback == condition .. " fake yaw additional limit" then
                    return item.get(condition .. " fake yaw build") ~= "Static"
                end

                if object_callback == condition .. " body yaw limit" then
                    return item.get(condition .. " body yaw reaction") ~= "Disabled"
                end

                return true
            end)()
        end)

        ::skip::
    end
end
--- @end global-region

--- @global-region: prepare second anti-aim elements
anti_aim_tab.ab_triggers = {"On self shot", "On enemy shot"}
anti_aim_tab.ab_phase_types = {"Hidden", "Yaw adding", "Body degree", "Angle modifier"}

item.new("Anti-bruteforce triggers", ui.new_multiselect("AA", "Anti-aimbot angles", "Select anti-bruteforce triggers:", anti_aim_tab.ab_triggers), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 2"
end)

item.new("Anti-bruteforce reset time", ui.new_slider("AA", "Anti-aimbot angles", "Select anti-bruteforce reset time:", 10, 50, 15, true, "s", 0.1), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 2" and #item.get("Anti-bruteforce triggers") > 0
end)

item.new("Anti-bruteforce phase type", ui.new_combobox("AA", "Anti-aimbot angles", "Select anti-bruteforce phase type:", anti_aim_tab.ab_phase_types), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 2" and #item.get("Anti-bruteforce triggers") > 0
end)

--- @note: ghetto a little bit
item.new("Anti-bruteforce phases yaw adding counter", ui.new_slider("AA", "Anti-aimbot angles", "Phases yaw counter", 0, 10, 0), function()
    return false
end)

item.new("Anti-bruteforce phases body degree counter", ui.new_slider("AA", "Anti-aimbot angles", "Phases body counter", 0, 10, 0), function()
    return false
end)

item.new("Anti-bruteforce phases angle modifier counter", ui.new_slider("AA", "Anti-aimbot angles", "Phases degree counter", 0, 10, 0), function()
    return false
end)

anti_aim_tab.ab_base = database.read("anti-bruteforce-data") or {}

anti_aim_tab.ab_base["Yaw adding"] = anti_aim_tab.ab_base["Yaw adding"] or {}
anti_aim_tab.ab_base["Body degree"] = anti_aim_tab.ab_base["Body degree"] or {}
anti_aim_tab.ab_base["Angle modifier"] = anti_aim_tab.ab_base["Angle modifier"] or {}

client.set_event_callback("shutdown", function()
    if item.get("Anti-bruteforce phases yaw adding counter") == 0 then
        anti_aim_tab.ab_base["Yaw adding"] = {}
    end

    if item.get("Anti-bruteforce phases body degree counter") == 0 then
        anti_aim_tab.ab_base["Body degree"] = {}
    end

    if item.get("Anti-bruteforce phases angle modifier counter") == 0 then
        anti_aim_tab.ab_base["Angle modifier"] = {}
    end

    database.write("anti-bruteforce-data", anti_aim_tab.ab_base)
end)

anti_aim_tab.add_new_phase = function(class, counter, value)
    local class = class or item.get("Anti-bruteforce phase type")
    local counter_class = counter or item.get(("Anti-bruteforce phases %s counter"):format(class:lower()))

    if counter_class >= 10 then
        add_notify("[Calypso: new notify] You can't create more than 10 phases!", nil, color(130, 255, 230))
        return
    end

    local phase_name = ("[%d] %s phase"):format(counter_class + 1, class)
    local arguments = class == "Angle modifier" and {0, 60, value or 60} or {-180, 180, value or 0}
    local phase_callback = ("Anti-bruteforce %s phase - #%d"):format(class:lower(), counter_class + 1)

    item.new(phase_callback, ui.new_slider("AA", "Anti-aimbot angles", phase_name, unpack(arguments)), function()
        return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 2" and #item.get("Anti-bruteforce triggers") > 0 and item.get("Anti-bruteforce phase type") == class
    end)

    anti_aim_tab.ab_base[class][counter_class] = item.get(phase_callback)
    item.set(("Anti-bruteforce phases %s counter"):format(class:lower()), counter_class + 1)
end

anti_aim_tab.remove_old_phase = function(class, counter)
    local class = class or item.get("Anti-bruteforce phase type")
    local counter_class = counter or item.get(("Anti-bruteforce phases %s counter"):format(class:lower()))

    if counter_class <= 0 then
        add_notify("[Calypso: new notify] You can't create lower than 0 phases!", nil, color(255, 130, 177))
        return
    end

    anti_aim_tab.ab_base[class][#anti_aim_tab.ab_base[class]] = nil

    item.destroy(("Anti-bruteforce %s phase - #%d"):format(class:lower(), counter_class))
    item.set(("Anti-bruteforce phases %s counter"):format(class:lower()), counter_class - 1)
end

item.new("Add new phase", ui.new_button("AA", "Anti-aimbot angles", "Add new phase", anti_aim_tab.add_new_phase), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 2" and #item.get("Anti-bruteforce triggers") > 0 and item.get("Anti-bruteforce phase type") ~= "Hidden"
end, true, anti_aim_tab.add_new_phase)

item.new("Remove old phase", ui.new_button("AA", "Anti-aimbot angles", "Remove old phase", anti_aim_tab.remove_old_phase), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 2" and #item.get("Anti-bruteforce triggers") > 0 and item.get("Anti-bruteforce phase type") ~= "Hidden"
end, true, anti_aim_tab.remove_old_phase)

for id, phase in pairs(anti_aim_tab.ab_base) do
    for p_id, p_data in pairs(phase) do
        anti_aim_tab.add_new_phase(id, p_id, p_data)
    end
end
--- @end global-region

--- @global-region: prepare third anti-aim elements
item.new("Anti-aim adjustments", ui.new_multiselect("AA", "Anti-aimbot angles", "Select additional adjustments:", {"Manual anti-aims", "Anti-backstabbing", "Legit anti-aim on E", "Freestanding helper", "Override anti-aim on events"}), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 3"
end)

for key, value in pairs({"left", "right", "forward", "backward"}) do
    local name = ("Override %s hotkey"):format(value)
    local callback = ("Anti-aim %s hotkey"):format(value)
    
    item.new(callback, ui.new_hotkey("AA", "Anti-aimbot angles", name), function()
        return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 3" and item.find("Anti-aim adjustments", "Manual anti-aims")
    end)
end

item.new("Freestanding hotkey", ui.new_hotkey("AA", "Anti-aimbot angles", "Override freestanding hotkey"), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 3" and item.find("Anti-aim adjustments", "Freestanding helper")
end)

item.new("Freestanding disablers", ui.new_multiselect("AA", "Anti-aimbot angles", "Disable freestanding on:", {"Standing", "Moving", "Crouching", "Slowwalking", "Jumping"}), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 3" and item.find("Anti-aim adjustments", "Freestanding helper")
end)

item.new("Anti-aim events", ui.new_multiselect("AA", "Anti-aimbot angles", "Scan reset events:", {"Static anti-aim on fakeduck", "Static anti-aim on warmup", "Safe anti-aim on freestanding"}), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Anti-aim ~ 3" and item.find("Anti-aim adjustments", "Override anti-aim on events")
end)
--- @end global-region

--- @global-region: prepare main anti-aim work
anti_aim_tab.data = {
    yaw_adding = 0,
    pitch = "Disabled",

    modifier_degree = 0,
    modifier_type = "Off",

    fake_limit = 60,
    is_fake_freestanding = false,

    body_yaw_limit = 0,
    body_yaw_type = "Off",

    is_manual_active = false,
    is_legit_aa_active = false,
    is_freestanding_active = false,
    is_anti_backstab_active = false,
    is_anti_bruteforce_active = false,

    condition = "Unknown"
}

anti_aim_tab.convert_conditions = {
    ["STANDING"] = 2,
    ["MOVING"] = 3,
    ["CROUCH T"] = 4,
    ["CROUCH CT"] = 5,
    ["SLOWWALK"] = 6,
    ["IN AIR"] = 7,
    ["IN CROUCH AIR"] = 8
}

anti_aim_tab.restruct_names = function(target)
    return table.switcher(target, {
        ["Disabled"] = "Off",
        default = target
    })
end

anti_aim_tab.choose_difference = function(target, first, second)
    return table.switcher(target, {
        ["Static"] = first,
        ["Random based jitter"] = math.random(first, second),
        ["Inverter based jitter"] = function()
            local self = entity.get_local_player()
            if not self or not self:is_alive() then
                return false
            end

            local body_yaw = self:get_prop("m_flPoseParameter", 11) * 120 - 60
            if globals.chokedcommands() == 0 then
                return body_yaw > 0 and first or second
            end
        end
    })
end

function anti_aim_tab:update_conditions(self_pointer)
    local self_state = self_pointer:get_state()
    local current_condition = self.conditions[self.convert_conditions[self_state]]

    self.data.condition = current_condition
end

anti_aim_tab.preset_library = {
    ["Standing"] = {
        ["Safe head"] = {"Static", 0, 0, "Offset", "Ticks based jitter", 5, 15, "Static", 60, 60, "Opposite", 0},
        ["Centered align"] = {"Inverter based jitter", -3, 3, "Center", "Static", 30, 0, "Static", 60, 60, "Jitter", 0},
        ["Safe high jitter"] = {"Inverter based jitter", -10, 10, "Center", "Static", 40, 0, "Static", 60, 60, "Jitter", 0},
        ["Aggressive high jitter"] = {"Inverter based jitter", -37, 37, "Center", "Static", 0, 0, "Static", 60, 60, "Jitter", 0}
    },

    ["Moving"] = {
        ["Safe head"] = {"Static", -1, 0, "Off", "Static", 0, 0, "Static", 60, 60, "Opposite", 0},
        ["Centered align"] = {"Inverter based jitter", -3, 3, "Center", "Static", 20, 0, "Static", 60, 60, "Jitter", 0},
        ["Safe high jitter"] = {"Inverter based jitter", -23, 20, "Center", "Static", 25, 0, "Static", 60, 60, "Jitter", 0},
        ["Aggressive high jitter"] = {"Inverter based jitter", -21, 28, "Center", "Static", 25, 0, "Static", 59, 59, "Jitter", 0}
    },

    ["Crouching T"] = {
        ["Safe head"] = {"Static", 7, 0, "Off", "Static", 0, 0, "Static", 60, 60, "Opposite", 0},
        ["Centered align"] = {"Inverter based jitter", -3, 3, "Center", "Static", 21, 0, "Static", 60, 60, "Jitter", 0},
        ["Safe high jitter"] = {"Inverter based jitter", -5, 14, "Center", "Static", 20, 0, "Static", 60, 60, "Jitter", 0},
        ["Aggressive high jitter"] = {"Inverter based jitter", -20, 35, "Center", "Static", 35, 0, "Static", 59, 59, "Jitter", 0}
    },

    ["Crouching CT"] = {
        ["Safe head"] = {"Static", 10, 0, "Off", "Static", 0, 0, "Static", 60, 60, "Opposite", 0},
        ["Centered align"] = {"Inverter based jitter", -3, 3, "Offset", "Static", 21, 0, "Static", 60, 60, "Jitter", 0},
        ["Safe high jitter"] = {"Inverter based jitter", -25, 5, "Center", "Static", 23, 0, "Static", 60, 60, "Jitter", 0},
        ["Aggressive high jitter"] = {"Inverter based jitter", -11, 23, "Center", "Static", 15, 0, "Static", 59, 59, "Jitter", 0}
    },

    ["Slowwalking"] = {
        ["Safe head"] = {"Static", 0, 0, "Off", "Static", 0, 0, "Inverter based jitter", 15, 20, 25, 25, "Opposite", 0},
        ["Centered align"] = {"Inverter based jitter", 2, 0, "Center", "Static", 32, 0, "Static", 60, 60, "Jitter", 0},
        ["Safe high jitter"] = {"Inverter based jitter", -14, 14, "Center", "Static", 20, 0, "Static", 60, 60, "Jitter", 0},
        ["Aggressive high jitter"] = {"Inverter based jitter", -6, 6, "Off", "Static", 0, 0, "Random based jitter", 24, 25, "Jitter", 0}
    },

    ["Jumping"] = {
        ["Safe head"] = {"Static", -7, 0, "Off", "Static", 0, 0, "Static", 60, 60, "Opposite", 0},
        ["Centered align"] = {"Inverter based jitter", -3, 3, "Center", "Static", 21, 0, "Static", 60, 60, "Jitter", 0},
        ["Safe high jitter"] = {"Inverter based jitter", -30, 30, "Center", "Static", 5, 0, "Static", 60, 60, "Jitter", 0},
        ["Aggressive high jitter"] = {"Inverter based jitter", -11, 23, "Center", "Static", 25, 0, "Static", 59, 59, "Jitter", 0}
    },

    ["Crouch jumping"] = {
        ["Safe head"] = {"Static", 4, 0, "Off", "Static", 0, 0, "Static", 60, 60, "Opposite", 0},
        ["Centered align"] = {"Inverter based jitter", -3, 3, "Offset", "Static", 21, 0, "Static", 60, 60, "Jitter", 0},
        ["Safe high jitter"] = {"Inverter based jitter", -25, 30, "Center", "Static", 15, 0, "Static", 60, 60, "Jitter", 0},
        ["Aggressive high jitter"] = {"Inverter based jitter", -25, 35, "Center", "Static", 15, 0, "Static", 59, 59, "Jitter", 0}
    }
}

function anti_aim_tab:parse_preset_data(cmd)
    local data = self.data
    if data.condition == "Unknown" or data.is_manual_active then
        return
    end

    local is_state_applied = item.get("Override settings for " .. data.condition:lower())
    if is_state_applied then
        local get_item = function(point)
            return item.get(("%s %s"):format(data.condition, point))
        end

        data.pitch = self.restruct_names(get_item("pitch structure"))
        data.yaw_adding = self.choose_difference(get_item("yaw build"), get_item("yaw adding"), get_item("additional yaw adding"))

        data.modifier_type = self.restruct_names(get_item("modifier type"))
        data.modifier_degree = data.modifier_type == "Off" and 0 or self.choose_difference(get_item("modifier build"), get_item("body degree"), get_item("additional body degree"))

        data.body_yaw_type = self.restruct_names(get_item("body yaw reaction"))
        data.body_yaw_limit = data.body_yaw_type == "Off" and 0 or get_item("body yaw limit")

        data.is_fake_freestanding = false
    else
        local preset = self.preset_library[data.condition][item.get("Anti-aim presets")]

        data.pitch = "Down"
        data.yaw_adding = self.choose_difference(preset[1], preset[2], preset[3])

        data.modifier_type = preset[4]
        data.modifier_degree = self.choose_difference(preset[5], preset[6], preset[7])

        data.body_yaw_type = preset[11]
        data.body_yaw_limit = preset[12]

        data.is_fake_freestanding = item.get("Anti-aim presets") == "Safe head"
        data.fake_limit = self.choose_difference(preset[8], preset[9], preset[10])
    end
end

anti_aim_tab.manual_value = 0
anti_aim_tab.manual_delay = 0

anti_aim_tab.restruct_freestand_condition = {
    ["Crouching T"] = "Crouching",
    ["Crouching CT"] = "Crouching",
    ["Crouch jumping"] = "Jumping"
}

function anti_aim_tab:apply_adjustments(cmd, self_pointer)
    self.data.is_manual_active = false
    self.data.is_legit_aa_active = false
    self.data.is_freestanding_active = false
    self.data.is_anti_backstab_active = false

    if item.find("Anti-aim adjustments", "Manual anti-aims") then
        if not self.is_legit_aa_active and not self.data.is_anti_backstab_active then
            local delay = self.manual_delay + 0.2 < globals.curtime()

            ui.set(item.get_pointer("Anti-aim left hotkey"), "On hotkey")
            ui.set(item.get_pointer("Anti-aim right hotkey"), "On hotkey")
            ui.set(item.get_pointer("Anti-aim forward hotkey"), "On hotkey")
            ui.set(item.get_pointer("Anti-aim backward hotkey"), "On hotkey")

            if item.get("Anti-aim left hotkey") and delay then
                self.manual_delay = globals.curtime()
                self.manual_value = self.manual_value == -90 and 0 or -90
            elseif item.get("Anti-aim right hotkey") and delay then
                self.manual_delay = globals.curtime()
                self.manual_value = self.manual_value == 90 and 0 or 90
            elseif item.get("Anti-aim forward hotkey") and delay then
                self.manual_delay = globals.curtime()
                self.manual_value = self.manual_value == -180 and 0 or -180
            elseif item.get("Anti-aim backward hotkey") and delay then
                self.manual_value = 0
                self.manual_delay = globals.curtime()
            elseif self.manual_delay > globals.curtime() then
                self.manual_delay = globals.curtime()
            end

            if self.manual_value ~= 0 then
                self.data.pitch = "Down"
                self.data.yaw_adding = self.manual_value

                self.data.modifier_type = "Off"
                self.data.modifier_degree = 0

                self.data.fake_limit = 60
                self.data.body_yaw_limit = 60
                self.data.body_yaw_type = "Opposite"

                self.data.is_manual_active = true
                self.data.is_fake_freestanding = true
            end
        end
    end

    if item.find("Anti-aim adjustments", "Anti-backstabbing") then
        if not self.data.is_legit_aa_active then
            local enemy = entity.get_current_enemy()
            if enemy then
                local enemy_weapon = enemy:get_player_weapon()
                if enemy_weapon then
                    if enemy_weapon:get_classname() == "CKnife" then
                        local e_origin = enemy:get_origin()
                        local self_origin = self_pointer:get_origin()

                        if e_origin:dist(self_origin) <= 200 then
                            self.data.yaw_adding = 180
                            self.data.is_anti_backstab_active = true
                        end
                    end
                end
            end
        end
    end

    if item.find("Anti-aim adjustments", "Legit anti-aim on E") then
        if client.key_state(0x45) then
            local self_active_weapon = self_pointer:get_player_weapon()
            if self_active_weapon then
                if self_pointer:get_prop("m_bIsDefusing") == 0 and self_pointer:get_prop("m_bInBombZone") == 0 then
                    if cmd.in_attack ~= 1 and cmd.chokedcommands == 0 then
                        cmd.in_use = 0
                    end

                    if cmd.in_use == 0 then
                        self.data.is_legit_aa_active = true
                    end
                end
            end
        end
    end

    if item.find("Anti-aim adjustments", "Freestanding helper") then
        if not self.is_legit_aa_active and not self.data.is_anti_backstab_active then
            if item.get("Freestanding hotkey") then
                if not item.find("Freestanding disablers", anti_aim_tab.restruct_freestand_condition[self.data.condition] or self.data.condition) then
                    self.data.is_freestanding_active = true
                end
            end
        end

        ui.set(references.list["Freestanding"][1][1], self.data.is_freestanding_active and "Default" or "-")
        ui.set(references.list["Freestanding"][1][2], self.data.is_freestanding_active and "Always on" or "Off hotkey")

        if self.data.is_freestanding_active and (item.find("Anti-aim adjustments", "Override anti-aim on events") and item.find("Anti-aim events", "Safe anti-aim on freestanding")) then
            self.data.pitch = "Down"
            self.data.yaw_adding = 0

            self.data.modifier_type = "Off"
            self.data.modifier_degree = 0

            self.data.fake_limit = 60
            self.data.body_yaw_limit = 60
            self.data.body_yaw_type = "Opposite"

            self.data.is_fake_freestanding = true
        end
    end

    if item.find("Anti-aim adjustments", "Override anti-aim on events") then
        local is_available = false
        local game_rules = entity.get_game_rules()

        if item.find("Anti-aim events", "Static anti-aim on fakeduck") and ui.get(references.get("Fakeduck")) then
            is_available = true
        end

        if item.find("Anti-aim events", "Static anti-aim on warmup") and game_rules and game_rules:get_prop("m_bWarmupPeriod") == 1 then
            is_available = true
        end

        if is_available and not self.data.is_manual_active then
            self.data.pitch = "Down"
            self.data.yaw_adding = 0

            self.data.modifier_type = "Off"
            self.data.modifier_degree = 0

            self.data.fake_limit = 60
            self.data.body_yaw_limit = 60
            self.data.body_yaw_type = "Opposite"

            self.data.is_fake_freestanding = true
        end
    end
end

anti_aim_tab.anti_bruteforce_data = {
    reset_time = 0,
    scanned_tick = 0,
    phase_data = {y_id = 0, m_id = 0, a_id = 0}
}

anti_aim_tab.check_shot_vector = function(event, self, attacker)
    local self_eye_position = self:get_eye_position()
    local attacker_eye_position = attacker:get_eye_position()

    local bullet_position = vector(event.x, event.y, event.z)
    local closest_point_on_ray = self_eye_position:get_closest_ray(bullet_position, attacker_eye_position)

    return closest_point_on_ray:dist(self_eye_position) <= 75
end

function anti_aim_tab:create_phase_data()
    local pointer = self.anti_bruteforce_data

    pointer.phase_data.yaw = (function()
        if pointer.phase_data.y_id < item.get("Anti-bruteforce phases yaw adding counter") then
            pointer.phase_data.y_id = pointer.phase_data.y_id + 1
        else
            pointer.phase_data.y_id = 1
        end

        local callback = item.get(("Anti-bruteforce yaw adding phase - #%d"):format(pointer.phase_data.y_id))
        return callback
    end)()

    pointer.phase_data.body = (function()
        if pointer.phase_data.m_id < item.get("Anti-bruteforce phases body degree counter") then
            pointer.phase_data.m_id = pointer.phase_data.m_id + 1
        else
            pointer.phase_data.m_id = 1
        end

        local callback = item.get(("Anti-bruteforce body degree phase - #%d"):format(pointer.phase_data.m_id))
        return callback
    end)()

    pointer.phase_data.angle = (function()
        if pointer.phase_data.a_id < item.get("Anti-bruteforce phases angle modifier counter") then
            pointer.phase_data.a_id = pointer.phase_data.a_id + 1
        else
            pointer.phase_data.a_id = 1
        end

        local callback = item.get(("Anti-bruteforce angle modifier phase - #%d"):format(pointer.phase_data.a_id))
        return callback
    end)()

    return pointer.phase_data
end

function anti_aim_tab:trigger_ab_events(event)
    if not item.get("Enable calypso") then
        return
    end
    
    if #item.get("Anti-bruteforce triggers") == 0 then
        return
    end

    local self_pointer = entity.get_local_player()
    if not self_pointer or not self_pointer:is_alive() then
        return
    end

    if self.data.is_freestanding_active and self.is_manual_active and self.is_legit_aa_active and self.data.is_anti_backstab_active then
        return
    end

    local attacker = entity.get_user_id(event.userid)
    if not attacker or attacker:is_dormant() or (attacker ~= self_pointer and not attacker:is_enemy()) then
        return
    end

    local is_shot_has_access = false
    local access_data = {
        s_shot = item.find("Anti-bruteforce triggers", "On self shot"),
        e_shot = item.find("Anti-bruteforce triggers", "On enemy shot")
    }

    if access_data.e_shot and access_data.s_shot then
        is_shot_has_access = true
    else
        is_shot_has_access = access_data.e_shot and attacker ~= self_pointer or access_data.s_shot and attacker == self_pointer
    end

    if not is_shot_has_access then
        return
    end

    local pointer = self.anti_bruteforce_data
    if pointer.scanned_tick == globals.tickcount() then
        return
    end

    local is_shot_close = self.check_shot_vector(event, self_pointer, attacker)
    if not is_shot_close then
        return
    end

    if item.get("Enable notifications") then
        local colors = {item.get("Notification color")}
        add_notify("[Calypso: new notify] Switched due to anti-bruteforce trigger!", nil, color(colors[1], colors[2], colors[3], colors[4]))
    end
    
    pointer.scanned_tick = globals.tickcount()
    pointer.phase_data = self:create_phase_data()
    pointer.reset_time = globals.realtime() + item.get("Anti-bruteforce reset time") / 10
end

client.set_event_callback("bullet_impact", function(...)
    return anti_aim_tab:trigger_ab_events(...)
end)

function anti_aim_tab:scan_anti_bruteforce(self_pointer)
    self.data.is_anti_bruteforce_active = false

    if #item.get("Anti-bruteforce triggers") == 0 then
        return
    end
    
    if globals.realtime() > self.anti_bruteforce_data.reset_time then
        return
    end

    if self.anti_bruteforce_data.phase_data.yaw then
        self.data.yaw_adding = self.anti_bruteforce_data.phase_data.yaw
    end

    if self.anti_bruteforce_data.phase_data.body then
        self.data.modifier_type = "Center"
        self.data.modifier_degree = self.anti_bruteforce_data.phase_data.body

        ui.set(references.get("Body yaw").value, 0) 
        ui.set(references.get("Body yaw").type, "Jitter")
    end

    if self.anti_bruteforce_data.phase_data.angle then
        self.data.fake_limit = self.anti_bruteforce_data.phase_data.angle
    end

    self.data.is_anti_bruteforce_active = true
end

function anti_aim_tab:override_settings(cmd)
    ui.set(references.get("Pitch"), self.data.pitch)
    ui.set(references.get("Yaw base"), "At targets")

    if type(self.data.yaw_adding) == "number" then
        ui.set(references.get("Yaw").type, 180)
        ui.set(references.get("Yaw").value, self.data.yaw_adding)
    end

    if type(self.data.modifier_degree) == "number" then
        ui.set(references.get("Yaw jitter").type, self.data.modifier_type)
        ui.set(references.get("Yaw jitter").value, self.data.modifier_degree)
    end

    ui.set(references.get("Body yaw").type, self.data.body_yaw_type)
    ui.set(references.get("Body yaw").value, self.data.body_yaw_limit)

    ui.set(references.get("Freestanding body yaw"), self.data.is_fake_freestanding)
end

function anti_aim_tab:setup_builder(cmd)
    if not item.get("Enable calypso") then
        return
    end

    local self_pointer = entity.get_local_player()
    if not self_pointer or not self_pointer:is_alive() then
        return
    end

    self:update_conditions(self_pointer)
    self:parse_preset_data(cmd)

    self:apply_adjustments(cmd, self_pointer)
    self:scan_anti_bruteforce(self_pointer)
    
    self:override_settings(cmd)
end

client.set_event_callback("setup_command", function(...)
    return anti_aim_tab:setup_builder(...)
end)
--- @end global-region

--- @global-region: prepare visual tab
item.new("Enable notifications", ui.new_checkbox("AA", "Anti-aimbot angles", "Enable notifications"), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Visualization"
end)

item.new("Notification color", ui.new_color_picker("AA", "Anti-aimbot angles", "Notification color", 255, 255, 255, 255), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Visualization" and item.get("Enable notifications")
end, nil, nil)

item.new("Arrows", ui.new_combobox("AA", "Anti-aimbot angles", "Select the arrows style:", {"Disabled", "Default", "Teamskeet"}), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Visualization"
end)

item.new("Arrows color", ui.new_color_picker("AA", "Anti-aimbot angles", "Arrow color", 255, 255, 255, 255), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Visualization" and item.get("Arrows") ~= "Disabled"
end, nil, nil)

item.new("Indicators", ui.new_combobox("AA", "Anti-aimbot angles", "Select the indicator style:", {"Disabled", "Style 1"}), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Visualization"
end)

visual_tab.adjust_arrows = function()
    local colors = {item.get("Arrows color")}
    local main_alpha = math.min(colors[4], animation("Arrows main alpha", 0):update((not item.get("Enable calypso") or item.get("Arrows") == "Disabled") and 0 or 255, 0.5):get())

    if main_alpha == 0 then
        return
    end

    local self = entity.get_local_player()
    if not self or not self:is_alive() then
        return
    end

    local default_color = color(35, 35, 35, main_alpha - 105)
    local selected_color = color(colors[1], colors[2], colors[3], main_alpha)

    local is_left = anti_aim_tab.manual_value == -90
    local is_right = anti_aim_tab.manual_value == 90
    local is_forward = anti_aim_tab.manual_value == -180

    table.switcher(item.get("Arrows"), {
        ["Default"] = function()
            if is_forward then
                render.text(c_screen_size.x, c_screen_size.y - 45, selected_color, "dcb+", "^") 
            elseif is_left or is_right then
                render.text(c_screen_size.x - 45, c_screen_size.y - 1, is_left and selected_color or color():alpha_modulate(105), "dcb+", "<")
                render.text(c_screen_size.x + 45, c_screen_size.y - 1, is_right and selected_color or color():alpha_modulate(105), "dcb+", ">")
            end
        end,

        ["Teamskeet"] = function()
            render.triangle(c_screen_size.x - 55, c_screen_size.y + 2, c_screen_size.x - 42, c_screen_size.y - 7, c_screen_size.x - 42, c_screen_size.y + 11, is_left and selected_color or default_color)
            render.triangle(c_screen_size.x + 55, c_screen_size.y + 2, c_screen_size.x + 42, c_screen_size.y - 7, c_screen_size.x + 42, c_screen_size.y + 11, is_right and selected_color or default_color)

            render.rectangle(c_screen_size.x - 40, c_screen_size.y - 7, 2, 18, anti_aim_funcs.get_desync() > 0 and selected_color or default_color)
            render.rectangle(c_screen_size.x + 38, c_screen_size.y - 7, 2, 18, anti_aim_funcs.get_desync() <= 0 and selected_color or default_color)
        end
    })
end

visual_tab.adjust_indicators = function()
    local main_alpha = animation("Indicators main alpha", 0):update((not item.get("Enable calypso") or item.get("Indicators") == "Disabled") and 0 or 255, 0.5):get()
    if main_alpha == 0 then
        return
    end

    local self = entity.get_local_player()
    if not self or not self:is_alive() then
        return
    end

    local add_y = 30
    local add_x = animation("Indicators add-x", 0):update(self:get_prop("m_bIsScoped") == 0 and 0 or 35, 10):get()

    local isHS = ui.get(references.get("Hideshots")[1]) and ui.get(references.get("Hideshots")[2])
    local isDT = ui.get(references.get("Doubletap")[1]) and ui.get(references.get("Doubletap")[2])

    local stuff = {
        {text = "DT", condition = isDT, color = (isDT and anti_aim_funcs.get_double_tap()) and color(0, 255, 0) or color(255, 0, 0)},
        {text = "HS", condition = isHS, color = isDT and color(232, 113, 113) or color(244, 255, 71)},
    }

    table.switcher(item.get("Indicators"), {
        ["Style 1"] = function()
            render.text(c_screen_size.x + add_x, c_screen_size.y + add_y, color(), "dc-", create_gradient("CALYPSO.CODES", color(), color(173, 179, 255, 255), "Indicator-style-1-gradient"):animate():get())
            add_y = add_y + 7

            local desync = math.abs(anti_aim_funcs.get_desync())
            local d_width = animation("Indicator-style-1-desync-width", desync):update(desync, 5):get()

            render.rectangle(c_screen_size.x - 31 + add_x, c_screen_size.y + add_y - 1, 64, 6, color(17, 17, 17, main_alpha))
            render.rectangle(c_screen_size.x - 29 + add_x, c_screen_size.y + add_y + 1, d_width + 3, 2, color(192 - ((d_width / 30) * 71), 32 + ((d_width / 30) * 146), 28, main_alpha))

            add_y = add_y + 10

            for id, data in pairs(stuff) do
                local ind_alpha = math.min(main_alpha, animation("Indicator-style-1-" .. data.text .. "-alpha", 0):update(data.condition and 255 or (data.condition == nil and 255 or 0), 5):get())
                if ind_alpha == 0 then
                    goto skip
                end

                render.text(c_screen_size.x + add_x, c_screen_size.y + add_y, data.color:clone():alpha_modulate(ind_alpha), "dc-", data.text)
                add_y = math.floor(add_y + 10 * (ind_alpha / 255))

                ::skip::
            end
        end
    })
end

client.set_event_callback("paint", visual_tab.adjust_arrows)
client.set_event_callback("paint", visual_tab.adjust_indicators)

visual_tab.get_self_country_code = panorama.loadstring([[
    return MyPersonaAPI.GetMyCountryCode();
]])()

visual_tab.country_image = nil
visual_tab.country_link = visual_tab.get_self_country_code == "BY" and "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Flag_of_Atlántico.svg/360px-Flag_of_Atlántico.svg.png" or "https://countryflagsapi.com/png/" .. visual_tab.get_self_country_code

http.get(visual_tab.country_link, function(success, response)
    if success and response.status == 200 then
        visual_tab.country_image = images.load(response.body)
    end
end)

visual_tab.render_country = function()
    if visual_tab.country_image then
        visual_tab.country_image:draw(0, c_screen_size.y - 50, 36, 24)
    end

    local position = visual_tab.country_image and 37 or 0

    render.text(position, c_screen_size.y - 45, color(), "d-", ">   BUILD:  " .. color(173, 179, 255):to_hex() .. obex_data.build:upper())
    render.text(position, c_screen_size.y - 35, color(), "d-", ">   USERNAME:  " .. color(173, 179, 255):to_hex() .. obex_data.username:upper())
end

client.set_event_callback("paint", visual_tab.render_country)
--- @end global-region

--- @global-region: prepare miscellaneous
item.new("Animation breakers", ui.new_multiselect("AA", "Anti-aimbot angles", "Animation breakers", {"Move body lean", "Static legs in air", "Reset pitch on land", "Dynamic leg jittering"}), function()
    return item.get("Enable calypso") and item.get("Calypso tab") == "Miscellaneous"
end)

misc_tab.on_ground = false
misc_tab.update_data = function(cmd)
    misc_tab.on_ground = cmd.in_jump == 0
end

misc_tab.adjust_breakers = function()
    if not item.get("Enable calypso") then
        return
    end

    if #item.get("Animation breakers") == 0 then
        return
    end

    local self = entity.get_local_player()
    if not self or not self:is_alive() then
        return
    end

    local self_anim_state = self:get_anim_state()
    if not self_anim_state then
        return
    end

    if item.find("Animation breakers", "Static legs in air") then
        self:set_prop("m_flPoseParameter", 1, 6)
    end

    if item.find("Animation breakers", "Dynamic leg jittering") then
        self:set_prop("m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 0 or 1)
        ui.set(references.get("Leg movement"), globals.tickcount() % 4 >= 2 and "Off" or "Always slide")
    end

    if item.find("Animation breakers", "Move body lean") then
        local self_anim_overlay = self:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end

        if self:get_velocity() >= 3 then
            self_anim_overlay.weight = 1
        end
    end 

    if item.find("Animation breakers", "Reset pitch on land") then
        if not self_anim_state.hit_in_ground_animation or not misc_tab.on_ground then
            return
        end

        self:set_prop("m_flPoseParameter", 0.5, 12)
    end
end

client.set_event_callback("setup_command", misc_tab.update_data)
client.set_event_callback("pre_render", misc_tab.adjust_breakers)
--- @end global-region

--- @global-region: prepare config structure
configs.get_all_values = function()
    local cache = {}
    for key, value in pairs(item.list) do
        local in_cache = {
            skip = value.skip, 
            value = value.skip == nil and ui.get(value.data) or false
        }

        if type(in_cache.value) == "userdata" then
            in_cache.value = nil
        end

        if not in_cache.value then
            goto skip
        end

        ::skip::
        cache[key] = in_cache
    end

    local json_based = json.stringify(cache)
    local base64_based = base64.encode_text(json_based, base64.alphabets.own_encode_alphabet)

    clipboard.set(base64_based)
    add_notify("[Calypso: new notify] Your config is successfully copied!", nil, color(173, 255, 203))
end

configs.parse_all_values = function(text)
    local text = text or clipboard.get()
    local decoded = base64.decode_text(text, base64.alphabets.own_decode_alphabet)

    local json_config = json.parse(decoded)
    if not json_config then
        add_notify("[Calypso: new notify] Your JSON-Config is wrong!", nil, color(255, 56, 56))
        return
    end

    local counters = {}
    local phase_data = {}

    for callback, element in pairs(json_config) do
        if element.skip then
            goto skip
        end

        if callback:find("phases") and callback:find("counter") then
            counters[callback] = element.value
        end

        if item.list[callback] then
            if element.value ~= nil then
                if callback:find("hotkey") then
                    goto skip
                end

                item.set(callback, element.value)
            end
        end

        ::skip::
    end

    for callback, counter in pairs(counters) do
        local class = callback:find("yaw") and "Yaw adding" or callback:find("angle") and "Angle modifier" or "Body degree"
        if not phase_data[class] then
            phase_data[class] = {}
        end

        for id = counter, 1, -1 do
            phase_data[class][id] = json_config[("Anti-bruteforce %s phase - #%d"):format(class:lower(), id)].value
            anti_aim_tab.remove_old_phase(class, id)
        end
    end

    for id, phase in pairs(phase_data) do
        for p_id, p_data in pairs(phase) do
            anti_aim_tab.add_new_phase(id, p_id - 1, p_data)
        end
    end

    item.update_visible_data()
    add_notify("[Calypso: new notify] Your config is successfully loaded!", nil, color(101, 255, 96))
end

item.new("Export config to clipboard", ui.new_button("AA", "Other", "Export config to clipboard", configs.get_all_values), nil, true, configs.get_all_values)
item.new("Import config from clipboard", ui.new_button("AA", "Other", "Import config from clipboard", configs.parse_all_values), nil, true, configs.parse_all_values)
--- @end global-region