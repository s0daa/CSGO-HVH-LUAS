--region Setup
local errorMessage = {
	invalidInstantiationType = "Attempted to instantiate %s, but it's a type of %s and does not support instances.",
	invalidClass = "Attempted to reference an invalid class. Classes must be setup with their respective functions before being used.",
	invalidClassFormat = "Attempted to setup a class from a non-table input. Input must be a table.",
	classAlreadyExists = "Attempted to setup %s, but it has already been setup.",
	abstractContractViolated = "%s has the abstract method '%s' but does not implement it. Please override all abstract methods.",
	interfaceContractViolated = "%s has the interface method '%s' but does not implement it. Please implement all interface methods.",
	invalidAbstractParent = "%s has the parent %s of type %s, but abstracts may only have other abstracts or interfaces as parents.",
	invalidEnumParent = "%s has the parent %s of type %s, but enums may only have other enums or interfaces as parents.",
	invalidInterfaceParent = "%s has the parent %s of type %s, but interfaces may only inherit other interfaces.",
	invalidInterfaceMember = "%s has declared the non-function member '%s'. Interfaces may only declare empty functions.",
	calledAbstractMethod = "Attempted to call abstract method."
}

--- @vararg string
local function die(...)
	error(string.format(...), 2)
end

local classtype = {
	class = 1,
	abstract = 2,
	enum = 3,
	interface = 4,
	exception = 5
}

local classtypeName = {
	[1] = "class",
	[2] = "abstract",
	[3] = "enum",
	[4] = "interface",
	[5] = "exception"
}

local instantiable = {
	[classtype.class] = true,
	[classtype.exception] = true
}

--- @type Exception
local activeException
--endregion

--region Declarations
--- @generic T
--- @class Class
--- @field __classid number
--- @field __classtype number
--- @field __classname string
--- @field __parent Class|T
--- @field __instanceid number
--- @field __init fun(self: T): void
--- @field __setup fun(self: T): void
local Class = {
	__classid = classtype.class,
	__classtype = classtype.class,
	__classname = "Nyx/Class"
}

--- @generic T
--- @param fields T
--- @return T
function Class:__constructor(fields)
	return setmetatable(fields or {}, self)
end

--- @class Abstract : Class
local Abstract = {
	__classid = classtype.abstract,
	__classtype = classtype.abstract,
	__classname = "Nyx/Abstract",
	__parent = Class
}

--- @return void
function Abstract:__constructor()
	die(errorMessage.invalidInstantiationType, self.__classname, classtypeName[classtype.abstract])
end

--- @class Enum : Class
--- @field __map table<string, string>
local Enum = {
	__classid = classtype.enum,
	__classtype = classtype.enum,
	__classname = "Nyx/Enum",
	__parent = Class,
	__map = {}
}

--- @return void
function Enum:__constructor()
	die(errorMessage.invalidInstantiationType, self.__classname, classtypeName[classtype.enum])
end

--- @param value any
--- @return boolean
function Enum:valid(value)
	return self[value] ~= nil
end

--- @param lookup string
--- @param caseInsensitive
--- @return any
function Enum:value(lookup, caseInsensitive)
	if caseInsensitive ~= true then
		return self[lookup]
	end

	return self[string.upper(string.upper(lookup))]
end

--- @param lookup string
function Enum:name(lookup)
	for member, value in pairs(self) do
		if lookup == value then
			return member
		end
	end
end

--- @return table
function Enum:names()
	local result = {}

	for member, value in pairs(self) do repeat
		if string.sub(member, 1, 2) == "__" then
			break
		end

		if type(value) == "function" then
			break
		end

		table.insert(result, member)
	until true end

	return result
end

--- @return table
function Enum:values()
	local result = {}

	for member, value in pairs(self) do repeat
		if string.sub(member, 1, 2) == "__" then
			break
		end

		if type(value) == "function" then
			break
		end

		result[member] = value
	until true end

	return result
end

--- @class Interface : Class
local Interface = {
	__classid = classtype.interface,
	__classtype = classtype.interface,
	__classname = "Nyx/Interface",
	__parent = Class
}

--- @class Exception : Class
--- @field __errorMessageFormat string
--- @field code number
--- @field message string
local Exception = {
	__classid = classtype.exception,
	__classtype = classtype.exception,
	__classname = "Nyx/Exception",
	__parent = Class,
	__errorMessageFormat = "Uncaught %s [%s]: %s"
}

--- @param code number
--- @param message string
function Exception:throw(code, message)
	local e = setmetatable({
		code = code,
		message = message
	}, self)

	activeException = e

	error(string.format(
		self.__errorMessageFormat,
		self.__classname,
		code,
		message
	), 3)
end
--endregion

--region Main locals
--- @type Class[]
local inheritance = {
	[classtype.class] = {
		[classtype.class] = Class
	},
	[classtype.abstract] = {
		[classtype.class] = Class,
		[classtype.abstract] = Abstract
	},
	[classtype.enum] = {
		[classtype.class] = Class,
		[classtype.enum] = Enum
	},
	[classtype.interface] = {
		[classtype.class] = Class,
		[classtype.interface] = Interface
	},
	[classtype.exception] = {
		[classtype.class] = Class,
		[classtype.interface] = Exception
	}
}

--- @type Class[]
local directParents = {
	[classtype.abstract] = Class,
	[classtype.enum] = Class,
	[classtype.interface] = Class,
	[classtype.exception] = Class
}

local latestClassId = #inheritance + 1
local latestInstanceId = 1
--endregion

--region Functions
--- @param c Class
local function validateInstantiable(c)
	if instantiable[c.__classtype] == nil then
		die(errorMessage.invalidInstantiationType, c.__classname, classtypeName[c.__classtype])
	end
end

--- @param c Class
local function validateClassExists(c)
	if c.__classid == nil then
		error(errorMessage.invalidClass, 4)
	end
end

--- @param c table|Class
local function validateValidClassFormat(c)
	if type(c) ~= "table" then
		die(errorMessage.invalidClassFormat)
	end

	if c.__classid ~= nil then
		die(errorMessage.classAlreadyExists, c.__classname)
	end
end

--- @param c Class
local function assignInstanceId(c)
	c.__instanceid = latestInstanceId

	latestInstanceId = latestInstanceId + 1
end

---  @param identifier string
--- @param c Class
local function assignClassMetadata(identifier, c)
	c.__classname = identifier
	c.__classid = latestClassId

	latestClassId = latestClassId + 1
end

--- @param parent Class
--- @param fallback Class
--- @return Class
local function assignParent(parent, fallback)
	if parent ~= nil then
		validateClassExists(parent)
	else
		parent = fallback
	end

	return parent
end

--- @param class Class
--- @param parent Class
local function assignClassInheritance(class, parent)
	class.__parent = parent
	class.__index = class

	--- @type Class[]
	local linearTree = {
		[1] = class
	}

	local recurseParent = parent
	local i = 2

	while recurseParent ~= nil do
		linearTree[i] = recurseParent

		recurseParent = recurseParent.__parent
		i = i + 1
	end

	local inheritanceTree = {}

	for i = 1, #linearTree do
		local iterateClass = linearTree[i]

		for member, value in pairs(iterateClass) do repeat
			if class[member] ~= nil then
				break
			end

			class[member] = value
		until true end

		inheritanceTree[iterateClass.__classid] = iterateClass
	end

	inheritance[class.__classid] = inheritanceTree
end

--- @param c Class
local function validateAbstractContract(c)
	for member, value in pairs(c) do repeat
		if type(value) ~= "function" then
			break
		end

		local status, message = pcall(value)

		if status == false and string.find(message, errorMessage.calledAbstractMethod) ~= nil then
			die(errorMessage.abstractContractViolated, c.__classname, member)
		end
	until true end
end

--- @param c Class
local function validateInterfaceMembers(c)
	for member, value in pairs(c) do
		if type(value) ~= "function" then
			die(errorMessage.invalidInterfaceMember, c.__classname, member)
		end
	end
end

--- @param c Class
--- @param parent Class
local function validateInterfaceContract(c, parent, identifier)
	for member, _ in pairs(parent) do
		if c[member] == nil and string.sub(member, 1, 2) ~= "__" then
			die(errorMessage.interfaceContractViolated, identifier, member)
		end
	end
end
--endregion

--region Global functions
--- @generic T
--- @param identifier string
--- @param self T|Class
--- @param parent Class|nil
--- @return T
local function class(identifier, self, parent)
	validateValidClassFormat(self)

	if parent ~= nil and parent.__classtype == classtype.interface then
		validateInterfaceContract(self, parent, identifier)
	end

	parent = assignParent(parent, Class)

	assignClassMetadata(identifier, self)
	assignClassInheritance(self, parent)

	if parent.__classtype == classtype.abstract then
		-- todo validateAbstractContract(self)
	end

	if self.__setup ~= nil then
		self.__setup(self)
	end

	self.__classtype = classtype.class

	return self
end

--- @generic T
--- @param identifier string
--- @param self T|Abstract
--- @param parent Abstract|Interface|nil
--- @return T
local function abstract(identifier, self, parent)
	validateValidClassFormat(self)

	if parent ~= nil and parent.__classtype == classtype.interface then
		validateInterfaceContract(self, parent, identifier)
	end

	parent = assignParent(parent, Abstract)

	if parent.__classtype ~= classtype.abstract and parent.__classtype ~= classtype.interface then
		die(errorMessage.invalidAbstractParent, identifier, parent.__classname, classtypeName[parent.__classtype])
	end

	assignClassMetadata(identifier, self)
	assignClassInheritance(self, parent)

	if self.__setup ~= nil then
		self.__setup(self)
	end

	self.__classtype = classtype.abstract

	return self
end

--- @generic T
--- @param identifier string
--- @param self T|Enum
--- @param parent Interface|Enum|nil
--- @return T
local function enum(identifier, self, parent)
	validateValidClassFormat(self)

	if parent ~= nil and parent.__classtype == classtype.interface then
		validateInterfaceContract(self, parent, identifier)
	end

	parent = assignParent(parent, Enum)

	if parent.__classtype ~= classtype.enum and parent.__classtype ~= classtype.interface then
		die(errorMessage.invalidEnumParent, identifier, parent.__classname, classtypeName[parent.__classtype])
	end

	assignClassMetadata(identifier, self)
	assignClassInheritance(self, parent)

	if self.__setup ~= nil then
		self.__setup(self)
	end

	self.__classtype = classtype.enum

	return self
end

--- @generic T
--- @param identifier string
--- @param self T|Interface
--- @param parent Interface|nil
--- @return T
local function interface(identifier, self, parent)
	validateValidClassFormat(self)
	validateInterfaceMembers(self)

	parent = assignParent(parent, Interface)

	if parent.__classtype ~= classtype.interface then
		die(errorMessage.invalidInterfaceParent, identifier, parent.__classname, classtypeName[parent.__classtype])
	end

	assignClassMetadata(identifier, self)
	assignClassInheritance(self, parent)

	if self.__setup ~= nil then
		self.__setup(self)
	end

	self.__classtype = classtype.interface

	return self
end

--- @generic T
--- @param identifier string
--- @param self T|Exception
--- @param parent Class|nil
--- @return T
local function exception(identifier, self, parent)
	validateValidClassFormat(self)

	if parent ~= nil and parent.__classtype == classtype.interface then
		validateInterfaceContract(self, parent, identifier)
	end

	parent = assignParent(parent, Exception)

	assignClassMetadata(identifier, self)
	assignClassInheritance(self, parent)

	if parent.__classtype == classtype.abstract then
		-- todo validateAbstractContract(self)
	end

	if self.__setup ~= nil then
		self.__setup(self)
	end

	self.__classtype = classtype.exception

	return self
end

--- @generic T
--- @param self T|Class
--- @param fields T|Class|table|nil
--- @return T
local function new(self, fields)
	validateClassExists(self)

	local o = self:__constructor(fields)

	assignInstanceId(o)

	if o.__init ~= nil then
		o.__init(o)
	end

	return o
end

--- @generic T
--- @param c T|Class|nil
--- @return T|Class
local function clone(c)
	validateInstantiable(c)

	--- @type Class
	local o = setmetatable({}, c)

	for member, value in pairs(c) do
		o[member] = value
	end

	assignInstanceId(o)

	return o
end

local function void()
	error(errorMessage.calledAbstractMethod, 2)
end

--- @param a Class
--- @param b Class
--- @return boolean
local function is(a, b)
	return a.__instanceid ~= nil and b.__instanceid ~= nil and a.__instanceid == b.__instanceid
end

--- @param a any|Class
--- @return boolean
local function isclass(a)
	return type(a) == "table" and a.__classid ~= nil
end

--- @param a Class
--- @return boolean
local function isinstance(a)
	return type(a) == "table" and a.__instanceid ~= nil
end

--- @param a Class
--- @param b Class
--- @return boolean
local function instanceof(a, b)
	if type(a) ~= "table" and a.__classid == nil then
		return false
	end

	return inheritance[a.__classid][b.__classid] ~= nil
end

--- @param value any|Class
--- @return string
local function typeof(value)
	local valueType = type(value)

	if valueType == "table" and value.__classname ~= nil then
		return value.__classname
	end

	return valueType
end

--- @param try fun()
--- @param catch fun(e: Exception)
local function try(try, catch)
	local status, message = pcall(try)

	if catch ~= nil then
		if activeException ~= nil then
			catch(activeException)
		elseif status == false then
			activeException = setmetatable({}, Exception)
			activeException.code = 0
			activeException.message = message

			catch(activeException)
		end
	end

	activeException = nil
end

--- @param e Exception
--- @param code number|nil
local function caught(e, code)
	return instanceof(activeException, e) and code ~= nil and true or activeException.code == code
end

--- @param exception Exception|nil
--- @vararg string
local function throw(exception, ...)
	if exception == nil then
		exception = Exception
	end

	--- @type Exception
	local e = setmetatable({
		code = 0,
		message = string.format(...)
	}, exception)

	activeException = e

	error(string.format(
		e.__errorMessageFormat,
		e.__classname,
		e.code,
		e.message
	), 2)
end

--- @param a Class
--- @return Class[]
local function getinheritance(a)
	return inheritance[a.__classid]
end

--- @generic T
--- @param t T
--- @return T
local function copytable(t)
	local b = {}

	for k, v in pairs(t) do
		b[k] = v
	end

	return b
end

--- Sorted pairs iteration.
--- @generic K, V
--- @param t table<K, V>|V[]
--- @param order fun(a: V, b: V): boolean
--- @return fun(t: table<K, V>): K, V
local function spairs(t, order)
	-- Collect the keys.
	local keys = {}

	for k in pairs(t) do
		keys[#keys + 1] = k
	end

	-- If order function given, sort by it by passing the table and keys a, b.
	-- Otherwise just sort the keys.
	if order then
		table.sort(keys, function(a, b)
			return order(t[a], t[b])
		end)
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
--endregion

return {
	class = class,
	abstract = abstract,
	enum = enum,
	interface = interface,
	exception = exception,
	new = new,
	clone = clone,
	void = void,
	is = is,
	isclass = isclass,
	isinstance = isinstance,
	instanceof = instanceof,
	typeof = typeof,
	try = try,
	caught = caught,
	throw = throw,
	getinheritance = getinheritance,
	copytable = copytable,
	spairs = spairs,
}