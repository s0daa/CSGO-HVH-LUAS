local ffi = require("ffi")
local pGetModuleHandle_sig =
    memory.find_pattern("engine.dll", " FF 15 ? ? ? ? 85 C0 74 0B") or error("Couldn't find signature #1")
local pGetProcAddress_sig =
    memory.find_pattern("engine.dll", " FF 15 ? ? ? ? A3 ? ? ? ? EB 05") or error("Couldn't find signature #2")

local jmp_ecx = memory.find_pattern("engine.dll", " FF E1")

local pGetProcAddress = ffi.cast("uint32_t**", ffi.cast("uint32_t", pGetProcAddress_sig) + 2)[0][0]
local fnGetProcAddress = ffi.cast("uint32_t(__stdcall*)(uint32_t, const char*)", pGetProcAddress)

local pGetModuleHandle = ffi.cast("uint32_t**", ffi.cast("uint32_t", pGetModuleHandle_sig) + 2)[0][0]
local fnGetModuleHandle = ffi.cast("uint32_t(__stdcall*)(const char*)", pGetModuleHandle)

local function proc_bind(module_name, function_name, typedef)
    local ctype = ffi.typeof(typedef)
    local module_handle = fnGetModuleHandle(module_name)
    local proc_address = fnGetProcAddress(module_handle, function_name)
    local call_fn = ffi.cast(ctype, proc_address)

    return call_fn
end

local nativeVirtualProtect =
    proc_bind(
    "kernel32.dll",
    "VirtualProtect",
    "int(__stdcall*)(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect)"
)
local nativeVirtualAlloc =
    proc_bind(
    "kernel32.dll",
    "VirtualAlloc",
    "void*(__stdcall*)(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect)"
)
local nativeVirtualFree =
    proc_bind(
    "kernel32.dll",
    "VirtualFree",
    "int(__stdcall*)(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType)"
)

local function copy(dst, src, len)
    --if 1==1 then print(dst,src,len) return  end
    return ffi.copy(ffi.cast("void*", dst), ffi.cast("const void*", src), len)
end

local buff = {free = {}}

local function VirtualProtect(lpAddress, dwSize, flNewProtect, lpflOldProtect)
    return nativeVirtualProtect(ffi.cast("void*", lpAddress), dwSize, flNewProtect, lpflOldProtect)
end

local function VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect, blFree)
    local alloc = nativeVirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect)
    if blFree then
        table.insert(buff.free, alloc)
    end
    return ffi.cast("intptr_t", alloc)
end

--local buffer = VirtualAlloc(nil, 10, 0x3000, 0x40, true)

--Directly change a function at an address in a VMT
local direct_hook = {}
function direct_hook.new(vt)
    local new_hook = {}
    local org_func = {}
    local old_prot = ffi.new("unsigned long[1]")
    local old_func = ffi.cast("intptr_t*", vt)[0]
    local address = vt
    new_hook.hookMethod = function(cast, func)
        VirtualProtect(address, 4, 0x4, old_prot)
        ffi.cast("intptr_t*",address)[0] = ffi.cast("intptr_t", ffi.cast(cast, func(ffi.cast(cast, old_func))))
        VirtualProtect(address, 4, old_prot[0], old_prot)
        return
    end
    new_hook.unHook = function()
        VirtualProtect(address, 4, 0x4, old_prot)
        ffi.cast("intptr_t*",address)[0] = old_func
        VirtualProtect(address, 4, old_prot[0], old_prot)
    end
    return new_hook
end
--VMT HOOKS
local vmt_hook = {hooks = {}}
function vmt_hook.new(vt)
    local new_hook = {}
    local org_func = {}
    local old_prot = ffi.new("unsigned long[1]")
    local virtual_table = ffi.cast("intptr_t**", vt)[0]
    new_hook.this = virtual_table
    new_hook.hookMethod = function(cast, func, method)
        org_func[method] = virtual_table[method]
        VirtualProtect(virtual_table + method, 4, 0x4, old_prot)
        virtual_table[method] = ffi.cast("intptr_t", ffi.cast(cast, func(ffi.cast(cast, org_func[method]))))
        VirtualProtect(virtual_table + method, 4, old_prot[0], old_prot)
        return
    end
	new_hook.GetOriginal = function(method)
		return org_func[method]
	end
    new_hook.unHookMethod = function(method)
        VirtualProtect(virtual_table + method, 4, 0x4, old_prot)
        virtual_table[method] = org_func[method]
        VirtualProtect(virtual_table + method, 4, old_prot[0], old_prot)
        org_func[method] = nil
    end
    new_hook.unHookAll = function()
        for method, func in pairs(org_func) do
            new_hook.unHookMethod(method)
        end
    end
    table.insert(vmt_hook.hooks, new_hook.unHookAll)
    return new_hook
end
--VMT HOOKS
--JMP HOOKS
local jmp_hook = {hooks = {}}
function jmp_hook.new(cast, callback, hook_addr, size, trampoline, org_bytes_tramp)
    local size = size or 5
    local trampoline = trampoline or false
    local new_hook, mt = {}, {}
    local detour_addr
    local old_prot = ffi.new("unsigned long[1]")
    local org_bytes = ffi.new("uint8_t[?]", size)
    copy(org_bytes, hook_addr, size)
    if trampoline then                                                                                                   --  stolen bytes needs to be copied to not corrupt the stack.
        local alloc_addr = VirtualAlloc(nil, size + 5, 0x3000, 0x40, true) -- allocate with additional 5 bytes for stolen bytes + jmp instruction + relative address
        detour_addr = tonumber(ffi.cast("intptr_t", ffi.cast(cast, callback(ffi.cast(cast,alloc_addr)))))
        print("Alloc address",tonumber(ffi.cast("intptr_t",alloc_addr)))
        print("Detour address",detour_addr)
        local trampoline_bytes = ffi.new("uint8_t[?]", size + 5, 0x90) -- Sets all instruction to NOPs
        -- if we provide custom instructions to place instead of the stolen bytes
        if org_bytes_tramp then
            local i = 0
            for byte in string.gmatch(org_bytes_tramp,"(%x%x)") do
                trampoline_bytes[i] = tonumber(byte, 16)
                i = i + 1
            end
        else
            -- else,just copy the stolen bytes.
            copy(trampoline_bytes, org_bytes, size)
        end
        -- jmp instruction
        trampoline_bytes[size] = 0xE9
        -- Calculate relative address from our allocated address to jump
        ffi.cast("int32_t*", trampoline_bytes + size + 1)[0] = hook_addr - tonumber(alloc_addr) - size + (size - 5)

        --copy the stolen bytes + jmp instructions to the allocated space in the binary
        copy(alloc_addr, trampoline_bytes, size + 5)
        new_hook.call = ffi.cast(cast, alloc_addr)
        mt = {
            __call = function(self, ...)
                return self.call(...)
            end
        }
    else
        detour_addr = tonumber(ffi.cast("intptr_t", ffi.cast(cast, callback(ffi.cast(cast,hook_addr)))))
        new_hook.call = ffi.cast(cast, hook_addr)
        mt = {
            __call = function(self, ...)
                self.stop()
                local res = self.call(...)
                self.start()
                return res
            end
        }
    end
    local hook_bytes = ffi.new("uint8_t[?]", size, 0x90)
    hook_bytes[0] = 0xE9
    ffi.cast("int32_t*", hook_bytes + 1)[0] = (detour_addr-hook_addr - 5)
    new_hook.status = false
    local function set_status(bool)
        new_hook.status = bool
        VirtualProtect(hook_addr, size, 0x40, old_prot)
        copy(hook_addr, bool and hook_bytes or org_bytes, size)
        VirtualProtect(hook_addr, size, old_prot[0], old_prot)
    end
    new_hook.stop = function()
        set_status(false)
    end
    new_hook.start = function()
        set_status(true)
    end
    if org_bytes[0] == 0xE9 or org_bytes[0] == 0xE8 then
        print("[WARNING] A primordial trampoline hook has been detected (uint8: " .. org_bytes[0] .. "), therefore you are not allowed to hook this address")
        for i=0,size do
            print("0x",string.upper(string.format("%x",tonumber(ffi.cast("uintptr_t",hook_addr))+i))," = 0x",string.upper(string.format("%x", org_bytes[i])))
        end
        print("[WARNING] You may still hook this address with vmt hook if it belongs to a vtable, however you will risk vac detection and low trust factor.")
        assert("hooking"=="gay")
    else
        new_hook.start()
    end
    table.insert(jmp_hook.hooks, new_hook)
    return setmetatable(new_hook, mt)
end
--JMP HOOKS
local hook = { vmt = vmt_hook , jmp = jmp_hook , direct = direct_hook }

local Vector = {
    x,y,z
}
Vector.__index = Vector

function Vector:new()
    local Object = {}
    setmetatable(Object,self)
    self.x = 0.00
    self.y = 0.00
    self.z = 0.00
    return Object
end

--- Makes a copy of itself
function Vector:Copy()
    local CopyVector = Vector:new()
    CopyVector.x = self.x
    CopyVector.y = self.y
    CopyVector.z = self.z
    return CopyVector
end

--- Copies another Vector's members
function Vector:CopyOther(v)
    self.x = v.x
    self.y = v.y
    self.z = v.z
end

function Vector:SetMembers(x,y,z)
  self.x = x
  self.y = y
  self.z = z
end

function Vector:SetX(x)
  self.x = x
end

function Vector:SetY(y)
    self.y = y
end

function Vector:SetZ(z)
    self.z = z
end

function Vector:GetX()
    return self.x
end

function Vector:GetY()
    return self.y
end

function Vector:GetZ()
    return self.z
end

function Vector:Zero()
    self.x = 0
    self.y = 0
    self.z = 0
end

function Vector:__add(v)
    local SolvedVector = Vector:new()
    SolvedVector.x = self.x + v.x
    SolvedVector.y = self.y + v.y
    SolvedVector.z = self.z + v.z
    return SolvedVector
end

function Vector:__sub(v)
    local SolvedVector = Vector:new()
    SolvedVector.x = self.x - v.x
    SolvedVector.y = self.y - v.y
    SolvedVector.z = self.z - v.z
    return SolvedVector
end

function Vector:__mul(v)
    local SolvedVector = Vector:new()
    SolvedVector.x = self.x * v.x
    SolvedVector.y = self.y * v.y
    SolvedVector.z = self.z * v.z
    return SolvedVector
end

function Vector:__div(v)
    local SolvedVector = Vector:new()
    SolvedVector.x = self.x / v.x
    SolvedVector.y = self.y / v.y
    SolvedVector.z = self.z / v.z
    return SolvedVector
end

function Vector:__mod(v)
    local SolvedVector = Vector:new()
    SolvedVector.x = self.x % v.x
    SolvedVector.y = self.y % v.y
    SolvedVector.z = self.z % v.z
    return SolvedVector
end

function Vector:__pow(v)
    local SolvedVector = Vector:new()
    SolvedVector.x = self.x ^ v.x
    SolvedVector.y = self.y ^ v.y
    SolvedVector.z = self.z ^ v.z
    return SolvedVector
end

function Vector:__eq(v)
    if self.x ~= v.x then return false end
    if self.y ~= v.y then return false end
    if self.z ~= v.z then return false end
    return true
end

function Vector:__lt(v) -- <
    if self.x >= v.x then return false end
    if self.y >= v.y then return false end
    if self.z >= v.z then return false end
    return true
end

function Vector:__le(v)  -- <=
    if self.x > v.x then return false end
    if self.y > v.y then return false end
    if self.z > v.z then return false end
    return true
end

function Vector:Length()
    return math.sqrt( self.x*self.x + self.y*self.y + self.z*self.z )
end

function Vector:LengthSqr()
    return ( self.x*self.x + self.y*self.y + self.z*self.z )
end

function Vector:Length2D()
    return math.sqrt(self.x*self.x + self.y*self.y)
end

function Vector:Dot(v)
    return ( self.x * v.x + self.y * v.y + self.z * v.z )
end

--- Adds with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function Vector:AddSingle(fl)
    local SolvedVector = Vector:new()
    SolvedVector.x = self.x + fl
    SolvedVector.y = self.y + fl
    SolvedVector.z = self.z + fl
    return self
end

--- Subtracts with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function Vector:SubtractSingle(fl)
    local SolvedVector = Vector:new()
    SolvedVector.x = self.x - fl
    SolvedVector.y = self.y - fl
    SolvedVector.z = self.z - fl
    return SolvedVector
end

--- Multiplies with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function Vector:MultiplySingle(fl)
    local SolvedVector = Vector:new()
    SolvedVector.x = self.x * fl
    SolvedVector.y = self.y * fl
    SolvedVector.z = self.z * fl
    return SolvedVector
end

--- Divides with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function Vector:DivideSingle(fl)
    local SolvedVector = Vector:new()
    SolvedVector.x = self.x / fl
    SolvedVector.y = self.y / fl
    SolvedVector.z = self.z / fl
    return SolvedVector
end

function Vector:Normalized()

    local res = self:Copy()
    local l = res:Length()
    if ( l ~= 0.0 ) then
        res = res:DivideSingle(fl)
    else
        res.x = 0
        res.y = 0
        res.z = 0
    end
    return res
end

function Vector:DistTo(vOther)

    local delta = Vector:new()

    delta.x = self.x - vOther.x
    delta.y = self.y - vOther.y
    delta.z = self.z - vOther.z

    return delta:Length()
end

function Vector:DistToSqr(vOther)

    local delta = Vector:new()

    delta.x = self.x - vOther.x
    delta.y = self.y - vOther.y
    delta.z = self.z - vOther.z

    return delta:LengthSqr()
end

local Vector2D = {
    x,y
}
Vector2D.__index = Vector2D

function Vector2D:new()
    local Object = {}
    setmetatable(Object,self)
    self.x = 0.00
    self.y = 0.00
    return Object
end

--- Makes a copy of itself
function Vector2D:Copy()
    local CopyVector = Vector2D:new()
    CopyVector.x = self.x
    CopyVector.y = self.y
    return CopyVector
end

--- Copies another Vector's members
function Vector2D:CopyOther(v)
    self.x = v.x
    self.y = v.y
end

function Vector2D:SetMembers(x, y)
    self.x = x
    self.y = y
end

function Vector2D:SetX(x)
    self.x = x
end

function Vector2D:SetY(y)
    self.y = y
end

function Vector2D:GetX()
    return self.x
end

function Vector2D:GetY()
    return self.y
end


function Vector2D:Zero()
    self.x = 0
    self.y = 0
end

function Vector2D:__add(v)
    local SolvedVector = Vector2D:new()
    SolvedVector.x = self.x + v.x
    SolvedVector.y = self.y + v.y
    return SolvedVector
end

function Vector2D:__sub(v)
    local SolvedVector = Vector2D:new()
    SolvedVector.x = self.x - v.x
    SolvedVector.y = self.y - v.y
    return SolvedVector
end

function Vector2D:__mul(v)
    local SolvedVector = Vector2D:new()
    SolvedVector.x = self.x * v.x
    SolvedVector.y = self.y * v.y
    return SolvedVector
end

function Vector2D:__div(v)
    local SolvedVector = Vector2D:new()
    SolvedVector.x = self.x / v.x
    SolvedVector.y = self.y / v.y
    return SolvedVector
end

function Vector2D:__mod(v)
    local SolvedVector = Vector2D:new()
    SolvedVector.x = self.x % v.x
    SolvedVector.y = self.y % v.y
    return SolvedVector
end

function Vector2D:__pow(v)
    local SolvedVector = Vector2D:new()
    SolvedVector.x = self.x ^ v.x
    SolvedVector.y = self.y ^ v.y
    return SolvedVector
end

function Vector2D:__eq(v)
    if self.x ~= v.x then return false end
    if self.y ~= v.y then return false end
    return true
end

function Vector2D:__lt(v) -- <
    if self.x >= v.x then return false end
    if self.y >= v.y then return false end
    return true
end

function Vector2D:__le(v)  -- <=
    if self.x > v.x then return false end
    if self.y > v.y then return false end
    return true
end

function Vector2D:Length()
    return math.sqrt( self.x*self.x + self.y*self.y )
end

function Vector2D:LengthSqr()
    return ( self.x*self.x + self.y*self.y )
end

--function Vector2D:Length2D()
--    return math.sqrt(self.x*self.x + self.y*self.y)
--end

function Vector2D:Dot(v)
    return ( self.x * v.x + self.y * v.y )
end

--- Adds with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function Vector2D:AddSingle(fl)
    self.x = self.x + fl
    self.y = self.y + fl
    return self
end

--- Subtracts with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function Vector2D:SubtractSingle(fl)
    self.x = self.x - fl
    self.y = self.y - fl
    return self
end

--- Multiplies with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function Vector2D:MultiplySingle(fl)
    self.x = self.x * fl
    self.y = self.y * fl
    return self
end

--- Divides with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function Vector2D:DivideSingle(fl)
    self.x = self.x / fl
    self.y = self.y / fl
    return self
end

function Vector2D:Normalized()

    local res = self:Copy()
    local l = res:Length()
    if ( l ~= 0.0 ) then
        res = res:DivideSingle(fl)
    else
        res.x = 0
        res.y = 0
    end
    return res
end

function Vector2D:DistTo(vOther)

    local delta = Vector2D:new()

    delta.x = self.x - vOther.x
    delta.y = self.y - vOther.y

    return delta:Length()
end

function Vector2D:DistToSqr(vOther)

    local delta = Vector2D:new()

    delta.x = self.x - vOther.x
    delta.y = self.y - vOther.y

    return delta:LengthSqr()
end

local QAngle = {
    x,y,z
}
QAngle.__index = QAngle

function QAngle:new()
    local Object = {}
    setmetatable(Object,self)
    self.x = 0.00
    self.y = 0.00
    self.z = 0.00
    return Object
end

--- Makes a copy of itself
function QAngle:Copy()
    local CopyVector = QAngle:new()
    CopyVector.x = self.x
    CopyVector.y = self.y
    CopyVector.z = self.z
    return CopyVector
end

--- Copies another Vector's members
function QAngle:CopyOther(v)
    self.x = v.x
    self.y = v.y
    self.z = v.z
end

function QAngle:SetMembers(x, y, z)
    self.x = x
    self.y = y
    self.z = z
end

function QAngle:SetX(x)
    self.x = x
end

function QAngle:SetY(y)
    self.y = y
end

function QAngle:SetZ(z)
    self.z = z
end

function QAngle:GetX(x)
    return self.x
end

function QAngle:GetY(y)
    return self.y
end

function QAngle:GetZ(z)
    return self.z
end

function QAngle:Zero()
    self.x = 0.00
    self.y = 0.00
    self.z = 0.00
end

function QAngle:__add(v)
    local SolvedVector = QAngle:new()
    SolvedVector.x = self.x + v.x
    SolvedVector.y = self.y + v.y
    SolvedVector.z = self.z + v.z
    return SolvedVector
end

function QAngle:__sub(v)
    local SolvedVector = QAngle:new()
    SolvedVector.x = self.x - v.x
    SolvedVector.y = self.y - v.y
    SolvedVector.z = self.z - v.z
    return SolvedVector
end

function QAngle:__mul(v)
    local SolvedVector = QAngle:new()
    SolvedVector.x = self.x * v.x
    SolvedVector.y = self.y * v.y
    SolvedVector.z = self.z * v.z
    return SolvedVector
end

function QAngle:__div(v)
    local SolvedVector = QAngle:new()
    SolvedVector.x = self.x / v.x
    SolvedVector.y = self.y / v.y
    SolvedVector.z = self.z / v.z
    return SolvedVector
end

function QAngle:__mod(v)
    local SolvedVector = QAngle:new()
    SolvedVector.x = self.x % v.x
    SolvedVector.y = self.y % v.y
    SolvedVector.z = self.z % v.z
    return SolvedVector
end

function QAngle:__pow(v)
    local SolvedVector = QAngle:new()
    SolvedVector.x = self.x ^ v.x
    SolvedVector.y = self.y ^ v.y
    SolvedVector.z = self.z ^ v.z
    return SolvedVector
end

function QAngle:__eq(v)
    if self.x ~= v.x then return false end
    if self.y ~= v.y then return false end
    if self.z ~= v.z then return false end
    return true
end

function QAngle:__lt(v) -- <
    if self.x >= v.x then return false end
    if self.y >= v.y then return false end
    if self.z >= v.z then return false end
    return true
end

function QAngle:__le(v)  -- <=
    if self.x > v.x then return false end
    if self.y > v.y then return false end
    if self.z > v.z then return false end
    return true
end

function QAngle:Length()
    return math.sqrt( self.x*self.x + self.y*self.y + self.z*self.z )
end

function QAngle:LengthSqr()
    return ( self.x*self.x + self.y*self.y + self.z*self.z )
end

--function QAngle:Length2D()
--    return math.sqrt(self.x*self.x + self.y*self.y)
--end

--function QAngle:Dot(v)
--    return ( self.x * v.x + self.y * v.y + self.z * v.z )
--end

--- Adds with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function QAngle:AddSingle(fl)
    self.x = self.x + fl
    self.y = self.y + fl
    self.z = self.z + fl
    return self
end

--- Subtracts with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function QAngle:SubtractSingle(fl)
    self.x = self.x - fl
    self.y = self.y - fl
    self.z = self.z - fl
    return self
end

--- Multiplies with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function QAngle:MultiplySingle(fl)
    self.x = self.x * fl
    self.y = self.y * fl
    self.z = self.z * fl
    return self
end

--- Divides with a single float number instead of another Vector
--- @param fl number
--- @return userdata
function QAngle:DivideSingle(fl)
    self.x = self.x / fl
    self.y = self.y / fl
    self.z = self.z / fl
    return self
end

function QAngle:Normalized()

    local res = self:Copy()
    local l = res:Length()
    if ( l ~= 0.0 ) then
        res = res:DivideSingle(fl)
    else
        res.x = 0.00
        res.y = 0.00
        res.z = 0.00
    end
    return res
end

local IMaterialSystem = {
    address = 0
    -- Functions = {
    --     GetRenderContext = ffi.cast("uint32_t(__thiscall*)(uint32_t)",memory.find_pattern("materialsystem.dll","56 57 8B F9 B9 ? ? ? ? FF 15 ? ? ? ? 8B F0 85 F6 75 12"))
    -- }
}

ffi.cdef[[
    typedef uint32_t    (__thiscall* GetBackBufferFormat_FN)                (uint32_t);
    typedef void        (__thiscall* BeginRenderTargetAllocation_FN)        (uint32_t);
    typedef void        (__thiscall* EndRenderTargetAllocation_FN)          (uint32_t);
    typedef uint32_t    (__thiscall* GetRenderContext_FN)                   (uint32_t);
    typedef uint32_t    (__thiscall* CreateNamedRenderTargetTextureEx_FN)   (uint32_t, const char* , int , int , int ,int , int ,uint8_t , int);
]]

function IMaterialSystem:new (address)
    local Object = {}
    setmetatable(Object,self)
    self.__index = self
    self.address = address
    return Object
end

function IMaterialSystem:GetBackBufferFormat ()
    -- print("GetBackBufferFormat: ",memory.get_vfunc(self.address,36))
    return ffi.cast("GetBackBufferFormat_FN",memory.get_vfunc(self.address,36))(self.address)
end

function IMaterialSystem:BeginRenderTargetAllocation ()
    -- print("BeginRenderTargetAllocation: ",memory.get_vfunc(self.address,94))
    ffi.cast("BeginRenderTargetAllocation_FN",memory.get_vfunc(self.address,94))(self.address)
end

function IMaterialSystem:EndRenderTargetAllocation ()
    -- print("EndRenderTargetAllocation: ",memory.get_vfunc(self.address,95))
    ffi.cast("EndRenderTargetAllocation_FN",memory.get_vfunc(self.address,95))(self.address)
end

function IMaterialSystem:GetRenderContext ()
    --print("GetRenderContext: ",memory.get_vfunc(self.address,115))
    return ffi.cast("GetRenderContext_FN",memory.get_vfunc(self.address,115))(self.address)
    -- return self.Functions.GetRenderContext(self.address)
end

function IMaterialSystem:CreateNamedRenderTargetTextureEx (name, w, h, sizeMode, format, depth, textureFlags, renderTargetFlags)
    -- print("CreateNamedRenderTargetTextureEx",memory.get_vfunc(self.address,97))
    return ffi.cast("CreateNamedRenderTargetTextureEx_FN",memory.get_vfunc(self.address,97))(
            self.address,
            name,
            w, h,
            sizeMode,
            format,
            depth,
            textureFlags,
            renderTargetFlags
    )
end

function IMaterialSystem:ForceBeginRenderTargetAllocation ()
    local m_bGameStarted = ffi.cast("bool*",ffi.cast("uint32_t",self.address) + 0x2C18)
    local oldState = m_bGameStarted[0]
    m_bGameStarted[0] = false
    self:BeginRenderTargetAllocation()
    m_bGameStarted[0] = oldState
end

function IMaterialSystem:ForceEndRenderTargetAllocation ()
    local m_bGameStarted = ffi.cast("bool*",ffi.cast("uint32_t",self.address) + 0x2C18)
    local oldState = m_bGameStarted[0]
    m_bGameStarted[0] = false
    self:EndRenderTargetAllocation()
    m_bGameStarted[0] = oldState
end

function IMaterialSystem:CreateFullFrameRenderTarget (name)
    return self:CreateNamedRenderTargetTextureEx(name,1,1,4,self:GetBackBufferFormat(),0,12,1)
end

local IMatRenderContext = {
    address = 0
    --Functions =
    --{
    --    Release = ffi.cast("int(__thiscall*)(uint32_t)",memory.find_pattern("materialsystem.dll","56 8D 71 04 83 C8 FF F0 0F C1 46 ? 48 75 17 8B 06 8B CE 8B 40 04 FF D0")),
    --    SetRenderTarget = ffi.cast("void(__thiscall*)(uint32_t,uint32_t)",memory.find_pattern("materialsystem.dll","55 8B EC FF 75 08 8B 01 6A 00 FF 90 ? ? ? ? 5D C2 04 00")),
    --    PushRenderTargetAndViewport = ffi.cast("void(__thiscall*)(uint32_t)",memory.find_pattern("materialsystem.dll","56 8B F1 E8 ? ? ? ? 68 ? ? ? ? FF B6 ? ? ? ? 8D 8E ? ? ? ? E8 ? ? ? ? 5E C3")),
    --    PopRenderTargetAndViewport = ffi.cast("void(__thiscall*)(uint32_t)",memory.find_pattern("materialsystem.dll","56 8B F1 83 7E 4C 00 74 14 8B 06 6A 00 FF 50 10 FF 4E 4C 8B CE 8B 06 FF 90 ? ? ? ? 68 ? ? ? ? FF B6 ? ? ? ? 8D 8E ? ? ? ? E8 ? ? ? ? 5E C3")),
    --    DrawScreenSpaceRectangle = ffi.cast("void(__thiscall*)(uint32_t, uint32_t, int, int, int, int, float, float, float, float, int, int, uint32_t, int, int )",memory.find_pattern("materialsystem.dll","55 8B EC 51 53 56 57 8B F9 8B 4D 08 8B 01 FF 90 ? ? ? ? 8D 97 ? ? ? ?"))
    --}

}

ffi.cdef[[
    typedef int         (__thiscall* Release_FN)                        (uint32_t);
    typedef void        (__thiscall* SetRenderTarget_FN)                (uint32_t,uint32_t);
    typedef uint32_t    (__thiscall* GetRenderTarget_FN)                (uint32_t);
    typedef void        (__thiscall* DrawScreenSpaceRectangle_FN)       (uint32_t, uint32_t, int, int, int, int, float, float, float, float, int, int, uint32_t, int, int );
    typedef void        (__thiscall* PushRenderTargetAndViewport_FN)    (uint32_t);
    typedef void        (__thiscall* PopRenderTargetAndViewport_FN)     (uint32_t);
]]

function IMatRenderContext:new(address)
    local Object = {}
    setmetatable(Object,self)
    self.__index = self
    self.address = address
    return Object
end

function IMatRenderContext:Release ()
    --print("Release",memory.get_vfunc(self.address,1))
    --return self.Functions.Release(self.address)
    return ffi.cast("Release_FN",memory.get_vfunc(self.address,1))(self.address)
end

function IMatRenderContext:SetRenderTarget (texture)
    --print("SetRenderTarget: ",memory.get_vfunc(self.address, 6))
    --self.Functions.SetRenderTarget(self.address,texture)
    ffi.cast("SetRenderTarget_FN",memory.get_vfunc(self.address, 6))(self.address,texture)
end

function IMatRenderContext:GetRenderTarget ()
    --print("GetRenderTarget: ",memory.get_vfunc(self.address, 7))
    return ffi.cast("GetRenderTarget_FN",memory.get_vfunc(self.address, 7))(self.address)
end

function IMatRenderContext:PushRenderTargetAndViewport ()
    --print("PushRenderTargetAndViewport: ",memory.get_vfunc(self.address, 119))
    ffi.cast("PushRenderTargetAndViewport_FN",memory.get_vfunc(self.address, 119))(self.address)
    -- self.Functions.PushRenderTargetAndViewport(self.address)
end

function IMatRenderContext:PopRenderTargetAndViewport ()
    --print("PopRenderTargetAndViewport: ",memory.get_vfunc(self.address, 120))
    ffi.cast("PopRenderTargetAndViewport_FN",memory.get_vfunc(self.address, 120))(self.address)
    -- self.Functions.PopRenderTargetAndViewport(self.address)
end

function IMatRenderContext:DrawScreenSpaceRectangle(pMaterial,
                                                    destX, destY, width, height,
                                                    srcTextureX0, srcTextureY0, srcTextureX1, srcTextureY1,
                                                    srcTextureWidth, srcTextureHeight,
                                                    pClientRenderable, nXDice, nYDice)

    --print("DrawScreenSpaceRectangle",memory.get_vfunc(self.address,114))
    ffi.cast("DrawScreenSpaceRectangle_FN",memory.get_vfunc(self.address,114))(
            self.address, pMaterial,
            destX, destY,
            width, height,
            srcTextureX0, srcTextureY0,
            srcTextureX1, srcTextureY1,
            srcTextureWidth, srcTextureHeight,
            pClientRenderable,
            nXDice, nYDice)
    --self.Functions.DrawScreenSpaceRectangle(
    --        self.address, pMaterial,
    --        destX, destY,
    --        width, height,
    --        srcTextureX0, srcTextureY0,
    --        srcTextureX1, srcTextureY1,
    --        srcTextureWidth, srcTextureHeight,
    --        pClientRenderable,
    --        nXDice, nYDice)
end

local ITexture = {
    address = 0
    -- Functions = {
    --     GetActualWidth = ffi.cast("int(__thiscall*)(uint32_t)",memory.find_pattern("materialsystem.dll","0F B7 41 36 C3")),
    --     GetActualHeight = ffi.cast("int(__thiscall*)(uint32_t)",memory.find_pattern("materialsystem.dll","0F B7 41 38 C3"))
    -- }
}

ffi.cdef [[
    typedef int (__thiscall* GetActualWidth_FN)     (uint32_t);
    typedef int (__thiscall* GetActualHeight_FN)    (uint32_t);
]]

function ITexture:new(address)
    local Object = {}
    setmetatable(Object,self)
    self.__index = self
    self.address = address
    return Object
end

function ITexture:GetActualWidth()
    --print("GetActualWidth",memory.get_vfunc(self.address,3))
    return ffi.cast("GetActualWidth_FN",memory.get_vfunc(self.address,3))(self.address)
    -- return self.Functions.GetActualWidth(self.address)
end

function ITexture:GetActualHeight()
    --print("GetActualHeight",memory.get_vfunc(self.address,4))
    return ffi.cast("GetActualHeight_FN",memory.get_vfunc(self.address,4))(self.address)
    -- return self.Functions.GetActualHeight(self.address)
end

local Math = { }
Math.__index = Math

function Math:VectorDistance(v1,v2)
    local x = v1.x - v2.x
    local y = v1.y - v2.y
    local z = v1.z - v2.z
    return math.sqrt(x*x + y*y + z*z)
end

function Math:CalcAngle(src,dst)
    local vAngle = QAngle:new()
    local delta = Vector:new()
    delta:SetMembers(src.x - dst.x ,src.y - dst.y,src.z - dst.z)

    local hyp = math.sqrt(delta.x * delta.x + delta.y * delta.y)

    vAngle.x = math.atan(delta.z / hyp) * 57.295779513082
    vAngle.y = math.atan(delta.y / delta.x) * 57.295779513082
    vAngle.z = 0.0

    if (delta.x >= 0.0) then
        vAngle.y = vAngle.y + 180.0
    end

    return vAngle
end

function Math:GetFOV(viewAngle,aimAngle)
    local ang = Vector:new()
    local aim = Vector:new()

    self:AngleVectors(viewAngle,aim)
    self:AngleVectors(aimAngle,ang)

    local res = math.deg(math.acos(aim:Dot(ang) / aim:LengthSqr()))
    if res ~= res then
        res = 0.0
    end
    return res
end

function Math:ClampAngles(angles)
    if (angles.x > 89.0) then
        angles.x = 89.0
    elseif (angles.x < -89.0) then
        angles.x = -89.0
    end

    if (angles.y > 180.0) then
        angles.y = 180.0
    elseif (angles.y < -180.0) then
        angles.y = -180.0
    end

    angles.z = 0
end

--- Returns Sine and Cosine of Value.
--- Sine and Cosine needs to be passed as reference / table.
function Math:XMScalarSinCos(pSin,pCos,Value)
    pSin[1] = math.sin(Value)
    pCos[1] = math.cos(Value)
end

function Math:AngleVectors(angles,forward)

    local sp = {}
    local sy = {}
    local cp = {}
    local cy = {}

    self:XMScalarSinCos(sp,cp,math.rad(angles.x))
    self:XMScalarSinCos(sy,cy,math.rad(angles.y))

    forward.x = cp[1] * cy[1]
    forward.y = cp[1] * sy[1]
    forward.z = -(sp[1])
end

function Math:AngleVectorsExtra(angles,forward,right,up)

    local sr = {}
    local sp = {}
    local sy = {}

    local cr = {}
    local cp = {}
    local cy = {}

    self:XMScalarSinCos(sp,cp,math.rad(angles.x))
    self:XMScalarSinCos(sy,cy,math.rad(angles.y))
    self:XMScalarSinCos(sr,cr,math.rad(angles.z))


    forward.x = cp[1] * cy[1]
    forward.y = cp[1] * sy[1]
    forward.z = -(sp[1])

    right.x = (-1 * sr[1] * sp[1] * cy[1] + -1 * cr[1] * -(sy[1]))
    right.y = (-1 * sr[1] * sp[1] * sy[1] + -1 * cr[1] *  cy[1])
    right.z = (-1 * sr[1] * cp[1])

    up.x = (cr[1] * sp[1] * cy[1] + -(sr[1]) * -sy[1])
    up.y = (cr[1] * sp[1] * sy[1] + -(sr[1]) * cy[1])
    up.z = (cr[1] * cp[1])
end

function Math:VectorAngles(forward,angles)
    local tmp,yaw,pitch

    if(forward.y == 0.0 and forward.x == 0.0) then
        yaw = 0.0
        if(forward.z > 0.0) then
            pitch = 270.0
        else
            pitch = 90.0
        end
    else
        yaw = math.atan(forward.y,forward.x) * 180.0 / 3.141592654
        if(yaw < 0.0) then
            yaw = yaw + 360.0
        end

        tmp = math.sqrt(forward.x * forward.x + forward.y * forward.y)
        pitch = math.atan(-forward.z,tmp) * 180.0 / 3.141592654
        if(pitch < 0.0)then
            pitch = pitch + 360.0
        end
    end

    angles.x = pitch
    angles.y = yaw
    angles.z = 0.0
end

function Math:Clamp(val, min, max)
    if val < min then
        val = min
    elseif max < val then
        val = max
    end
    return val
end

function Math:IsInBounds(mouse_pos,first_point,second_point)
    if((mouse_pos.x >= first_point.x and mouse_pos.x <= second_point.x) and (mouse_pos.y >= first_point.y and mouse_pos.y <= second_point.y)) then
        return true
    end
    return false
end

ffi.cdef[[

typedef struct {
    float x,y,z;
} Vector;

typedef struct {
    float x,y;
} Vector2D;

typedef struct {
    float pitch,yaw,roll;
} QAngle;

typedef struct {
    int				x,y,width,height;
	struct vrect_t *pNext;
} vrect_t;

typedef struct
{
	int			iX;
	int			iUnscaledX;
	int			iY;
	int			iUnscaledY;
	int			iWidth;
	int			iUnscaledWidth;
	int			iHeight;
	int			iUnscaledHeight;
	bool		bOrtho;
	float		flOrthoLeft;
	float		flOrthoTop;
	float		flOrthoRight;
	float		flOrthoBottom;
	char	    pad0[0x7C];
	float		flFOV;
	float		flViewModelFOV;
	Vector		vecOrigin;
	QAngle		angView;
	float		flNearZ;
	float		flFarZ;
	float		flNearViewmodelZ;
	float		flFarViewmodelZ;
	float		flAspectRatio;
	float		flNearBlurDepth;
	float		flNearFocusDepth;
	float		flFarFocusDepth;
	float		flFarBlurDepth;
	float		flNearBlurRadius;
	float		flFarBlurRadius;
	float		flDoFQuality;
	int			nMotionBlurMode;
	float		flShutterTime;
	Vector		vecShutterOpenPosition;
	QAngle		vecShutterOpenAngles;
	Vector		vecShutterClosePosition;
	QAngle		vecShutterCloseAngles;
	float		flOffCenterTop;
	float		flOffCenterBottom;
	float		flOffCenterLeft;
	float		flOffCenterRight;
	bool		bOffCenter;
	bool		bRenderToSubrectOfLargerScreen;
	bool		bDoBloomAndToneMapping;
	bool		bDoDepthOfField;
	bool		bHDRTarget;
	bool		bDrawWorldNormal;
	bool		bCullFontFaces;
	bool		bCacheFullSceneState;
	bool		bCSMView;
} CViewSetup;

]]

local function MakeCopyOfViewSetup(viewSetup)
    local newSetup = ffi.new("CViewSetup")
    --newSetup.vTable = viewSetup.vTable
    newSetup.iX = viewSetup.iX
    newSetup.iUnscaledX = viewSetup.iUnscaledX
    newSetup.iY = viewSetup.iY
    newSetup.iUnscaledY = viewSetup.iUnscaledY
    newSetup.iWidth = viewSetup.iWidth
    newSetup.iUnscaledWidth = viewSetup.iUnscaledWidth
    newSetup.iHeight = viewSetup.iHeight
    newSetup.iUnscaledHeight = viewSetup.iUnscaledHeight
    newSetup.bOrtho = viewSetup.bOrtho
    newSetup.flOrthoLeft = viewSetup.flOrthoLeft
    newSetup.flOrthoTop = viewSetup.flOrthoTop
    newSetup.flOrthoRight = viewSetup.flOrthoRight
    newSetup.flOrthoBottom = viewSetup.flOrthoBottom
    newSetup.pad0 = viewSetup.pad0
    newSetup.flFOV = viewSetup.flFOV
    newSetup.flViewModelFOV = viewSetup.flViewModelFOV
    newSetup.vecOrigin = viewSetup.vecOrigin
    newSetup.angView = viewSetup.angView
    newSetup.flNearZ = viewSetup.flNearZ
    newSetup.flFarZ = viewSetup.flFarZ
    newSetup.flNearViewmodelZ = viewSetup.flNearViewmodelZ
    newSetup.flFarViewmodelZ = viewSetup.flFarViewmodelZ
    newSetup.flAspectRatio = viewSetup.flAspectRatio
    newSetup.flNearBlurDepth = viewSetup.flNearBlurDepth
    newSetup.flNearFocusDepth = viewSetup.flNearFocusDepth
    newSetup.flFarFocusDepth = viewSetup.flFarFocusDepth
    newSetup.flFarBlurDepth = viewSetup.flFarBlurDepth
    newSetup.flNearBlurRadius = viewSetup.flNearBlurRadius
    newSetup.flFarBlurRadius = viewSetup.flFarBlurRadius
    newSetup.flDoFQuality = viewSetup.flDoFQuality
    newSetup.nMotionBlurMode = viewSetup.nMotionBlurMode
    newSetup.flShutterTime = viewSetup.flShutterTime
    newSetup.vecShutterOpenPosition = viewSetup.vecShutterOpenPosition
    newSetup.vecShutterOpenAngles = viewSetup.vecShutterOpenAngles
    newSetup.vecShutterClosePosition = viewSetup.vecShutterClosePosition
    newSetup.vecShutterCloseAngles = viewSetup.vecShutterCloseAngles
    newSetup.flOffCenterTop = viewSetup.flOffCenterTop
    newSetup.flOffCenterBottom = viewSetup.flOffCenterBottom
    newSetup.flOffCenterLeft = viewSetup.flOffCenterLeft
    newSetup.flOffCenterRight = viewSetup.flOffCenterRight
    newSetup.bOffCenter = viewSetup.bOffCenter
    newSetup.bRenderToSubrectOfLargerScreen = viewSetup.bRenderToSubrectOfLargerScreen
    newSetup.bDoBloomAndToneMapping = viewSetup.bDoBloomAndToneMapping
    newSetup.bDoDepthOfField = viewSetup.bDoDepthOfField
    newSetup.bHDRTarget = viewSetup.bHDRTarget
    newSetup.bDrawWorldNormal = viewSetup.bDrawWorldNormal
    newSetup.bCullFontFaces = viewSetup.bCullFontFaces
    newSetup.bCacheFullSceneState = viewSetup.bCacheFullSceneState
    newSetup.bCSMView = viewSetup.bCSMView
    return newSetup
end

local CSpyCam =
{
	m_SpyTexture,
	m_SpyMaterial,
    m_nTargetEntity,
    m_vecPosition,
	m_vecSize

}

local main_font = render.create_font("Tahoma", 15, 700)
--local bShouldHighlight = menu.add_checkbox("SpyCam", "Highlight target player", true)
--local bShouldHighlight_ThruWalls = menu.add_checkbox("SpyCam", "Highlight through walls", true)
--local Chams_Color = menu.add_text("SpyCam","Chams Color"):add_color_picker("Chams Color")
local UIValues =
{
    m_iWindowPos = vec2_t(0,0),
    m_iWindowSize = vec2_t(400,300),
    m_iHeaderSize = vec2_t(400,20),
    m_szHeaderText = "SpyCam",
    m_iColor = menu.add_text("SpyCam", "Window Color"):add_color_picker("Window Color"),
    m_iPressed = -1
}

local Globals = {
    g_CHLClient = memory.create_interface("client.dll","VClient018"),
    g_ViewRender = ffi.cast("uint32_t**",memory.find_pattern("client.dll","A1 ? ? ? ? B9 ? ? ? ? C7 05 ? ? ? ? ? ? ? ? FF 10") + 1)[0],
    g_pMaterialSystem = IMaterialSystem:new(memory.create_interface("materialsystem.dll","VMaterialSystem080")),
    g_fnKeyValueFromString = ffi.cast("uint32_t (*)(const char*, const char*, uint32_t)",memory.find_pattern("client.dll","55 8B EC 81 EC ? ? ? ? 85 D2 53")),
	g_Input = ffi.cast("uint32_t",ffi.cast("uint32_t**",memory.find_pattern("client.dll","B9 ? ? ? ? F3 0F 11 04 24 FF 50 10") + 1)[0]),
    g_fnRemoveEffects = ffi.cast("int (__thiscall*) (int, int)",memory.find_pattern("client.dll","55 8B EC 53 8B 5D 08 8B C3 56 8B"))
}
Globals.g_ClientMode = ffi.cast("uint32_t",ffi.cast("uint32_t***",((ffi.cast("uint32_t**",Globals.g_CHLClient)[0])[10] + 0x5))[0][0])
function CSpyCam:Init()

    Globals.g_pMaterialSystem:ForceBeginRenderTargetAllocation()
    self.m_SpyTexture = Globals.g_pMaterialSystem:CreateFullFrameRenderTarget("spycam_texture")
    Globals.g_pMaterialSystem:ForceEndRenderTargetAllocation()

	local material = materials.create("spycam_material",
	[[
       "UnlitGeneric" {
          "$basetexture" "spycam_texture"
       }
    ]]
	)
    self.m_SpyMaterial = material:get_address()
    --local KeyValue = Globals.g_fnKeyValueFromString("UnlitGeneric",[[$basetexture spycam_texture]],0)
    --print("KeyValue",KeyValue)
    --self.m_SpyMaterial = Globals.g_pMaterialSystem:CreateMaterial("spycam_material",KeyValue)
    --(function()
    --    if (Globals.g_pMaterialSystem:FindMaterial("spycam_material")) then
    --        print("[SpyCam] Found material")
    --        return Globals.g_pMaterialSystem:FindMaterial("spycam_material")
    --    else
    --        print("[SpyCam] Material not found,creating..")
    --        return Globals.g_pMaterialSystem:CreateMaterial("spycam_material",Globals.g_fnKeyValueFromString("UnlitGeneric","$basetexture spycam_texture",0))
    --    end
    --end)()
    --print("[SpyCam] Material :",self.m_SpyMaterial)
    --materials.for_each(function(mat)
    --    print(mat:get_name())
    --end)

    self.m_nTargetEntity = -1

    self.m_vecPosition = Vector2D:new()
    self.m_vecPosition:SetMembers(UIValues.m_iWindowPos.x,UIValues.m_iWindowPos.y + UIValues.m_iHeaderSize.y)

    self.m_vecSize = Vector2D:new()
    self.m_vecSize:SetMembers(UIValues.m_iWindowSize.x,UIValues.m_iWindowSize.y)


end

function CSpyCam:UpdateEntities()
    local local_player = entity_list.get_local_player()
    local enemies_only = entity_list.get_players(true)
    local local_eye_pos = local_player:get_eye_position()



    local entity_index = -1
    local latestFOV = 180.0
    for _,player in pairs(enemies_only) do
        if player:is_player() and player:is_alive() and not player:is_dormant() then
            local enemy_eye_pos = player:get_eye_position()
            local enemy_angle = Math:CalcAngle(local_eye_pos,enemy_eye_pos)

            local fov_to_enemy = Math:GetFOV(engine.get_view_angles(), enemy_angle)

            if(fov_to_enemy <= latestFOV) then
                latestFOV = fov_to_enemy
                entity_index = player:get_index()
            end
        end
    end
    self.m_nTargetEntity = entity_index
end

function CSpyCam:RenderUI()

    local header_loc = vec2_t(UIValues.m_iWindowPos.x + UIValues.m_iHeaderSize.x,UIValues.m_iWindowPos.y + UIValues.m_iHeaderSize.y)
    render.rect_filled(UIValues.m_iWindowPos,UIValues.m_iHeaderSize,UIValues.m_iColor:get() )

    local text_size = render.get_text_size(main_font,UIValues.m_szHeaderText)

    render.text(main_font, UIValues.m_szHeaderText, vec2_t(UIValues.m_iWindowPos.x + UIValues.m_iHeaderSize.x/2 - text_size.x/2 , UIValues.m_iWindowPos.y + UIValues.m_iHeaderSize.y/2 - text_size.y/2), color_t(0, 0, 0, 255))

    local spy_cam_loc = vec2_t(UIValues.m_iWindowPos.x,UIValues.m_iWindowPos.y + UIValues.m_iHeaderSize.y)
    render.rect(spy_cam_loc, UIValues.m_iWindowSize, UIValues.m_iColor:get())

    CSpyCam.m_vecPosition:SetMembers(spy_cam_loc.x,spy_cam_loc.y)
    CSpyCam.m_vecSize:SetMembers(UIValues.m_iWindowSize.x,UIValues.m_iWindowSize.y)
end

function CSpyCam:Input()

    local start_bound = UIValues.m_iWindowPos
    local end_bound = vec2_t(UIValues.m_iWindowPos.x + UIValues.m_iWindowSize.x ,UIValues.m_iWindowPos.y + UIValues.m_iHeaderSize.y + UIValues.m_iWindowSize.y)

    --render.rect(start_bound, vec2_t(5, 5), color_t(255,0,0))

    local mouse_pos = input.get_mouse_pos()

    local menu_size = menu.get_size()
    local menu_pos = menu.get_pos()

    local menu_end_bound = vec2_t(menu_pos.x + menu_size.x,menu_pos.y + menu_size.y)

    local resize_bounds = vec2_t(15,15)
    local end_bound_resize = vec2_t(end_bound.x + resize_bounds.x,end_bound.y + resize_bounds.y)

    local poly_table = {vec2_t(end_bound.x, end_bound.y + resize_bounds.y),vec2_t( end_bound.x + resize_bounds.x, end_bound.y ),vec2_t(end_bound.x + resize_bounds.x, end_bound.y + resize_bounds.y)}
    render.polygon(poly_table, color_t(255,255,255))

    if input.is_key_released(e_keys.MOUSE_LEFT) then
        UIValues.m_iPressed = -1
    end

    if menu.is_open() and Math:IsInBounds(mouse_pos,menu_pos,menu_end_bound) and input.is_key_held(e_keys.MOUSE_LEFT) then -- menu takes priority
        return
    end

    --- How it works (future self reference) :
    --- Use the normal bounding checking ( Math:IsInBounds(mouse_pos,start_bound,end_bound) and input.is_key_held(e_keys.MOUSE_LEFT) )
    --- AND Make sure we're not dragging anything else ( UIValues.m_iPressed == -1 )
    --- If the above conditions are met,execute the operations.
    --- Then inside,set the context number.
    --- Next frame,the context number is set and we only need the second expression (input.is_key_held(e_keys.MOUSE_LEFT) and UIValues.m_iPressed == ContextNum)
    --- Only reset the context number if the mouse key is released,making us able to drag any item smoothly even if it's not in bound.(Fixes resizing too fast)

    if (Math:IsInBounds(mouse_pos,start_bound,end_bound) and input.is_key_held(e_keys.MOUSE_LEFT) and UIValues.m_iPressed == -1) or (input.is_key_held(e_keys.MOUSE_LEFT) and UIValues.m_iPressed == 1)  then
        UIValues.m_iPressed = 1
        UIValues.m_iWindowPos.x = mouse_pos.x - UIValues.m_iWindowSize.x/2
        UIValues.m_iWindowPos.y = mouse_pos.y - UIValues.m_iWindowSize.y/2

        local screen_size = render.get_screen_size()
        UIValues.m_iWindowPos.x = Math:Clamp(UIValues.m_iWindowPos.x,0,screen_size.x - UIValues.m_iWindowSize.x)
        UIValues.m_iWindowPos.y = Math:Clamp(UIValues.m_iWindowPos.y,0,screen_size.y - UIValues.m_iWindowSize.y)
        return
    end


    if (Math:IsInBounds(mouse_pos,end_bound,end_bound_resize) and input.is_key_held(e_keys.MOUSE_LEFT) and UIValues.m_iPressed == -1) or (input.is_key_held(e_keys.MOUSE_LEFT) and UIValues.m_iPressed == 2) then
        UIValues.m_iPressed = 2

        UIValues.m_iWindowSize.x = math.abs(mouse_pos.x - UIValues.m_iWindowPos.x) - resize_bounds.x/2
        UIValues.m_iWindowSize.y = math.abs(mouse_pos.y - (UIValues.m_iWindowPos.y + UIValues.m_iHeaderSize.y)) - resize_bounds.y/2

        UIValues.m_iHeaderSize.x = UIValues.m_iWindowSize.x

        render.polygon(poly_table, color_t(0,255,0))

        --print("Resize bounded")
        return
    end

end

function CSpyCam:Render()

    if(self.m_nTargetEntity == -1)then
        return
    end
    local entity = entity_list.get_entity(self.m_nTargetEntity)

    if(not entity or not entity:is_alive() or entity:is_dormant()) then
        return
    end

    local ctx = IMatRenderContext:new(Globals.g_pMaterialSystem:GetRenderContext())

    local texture = ITexture:new(self.m_SpyTexture)

    ctx:DrawScreenSpaceRectangle(self.m_SpyMaterial,
    self.m_vecPosition.x,self.m_vecPosition.y,self.m_vecSize.x,self.m_vecSize.y,0,0,
    self.m_vecSize.x,self.m_vecSize.y,texture:GetActualWidth(),texture:GetActualHeight(),0,1,1)

    ctx:Release()
end

function CSpyCam:CalcView(view,entity)
    local local_player = entity_list.get_local_player()

    local local_eye_pos = local_player:get_eye_position()
    local origin = entity:get_eye_position() -- to pass to trace.line
    local custom_origin = Vector:new() -- to calculate with
    custom_origin:SetMembers(origin.x,origin.y,origin.z)

    local angle = Math:CalcAngle(custom_origin,local_eye_pos)
    local angle_inverse = angle:Copy()

    angle_inverse.x = angle_inverse.x * -1.0
    angle_inverse.y = angle_inverse.y + 180.0

    local inverse_vector = Vector:new()
    Math:AngleVectors(angle_inverse,inverse_vector)

    local ray_end = (custom_origin + (inverse_vector:MultiplySingle(130.0)))
    local trace_result = trace.line(origin,vec3_t(ray_end.x, ray_end.y, ray_end.z),entity,0x1400B)
    local ray_casted = (custom_origin + (inverse_vector:MultiplySingle(130.0 * trace_result.fraction)))

    --debug_overlay.add_sphere(origin, 15, 20, 5, color_t(255, 255, 255), 10.0)
    --debug_overlay.add_sphere(vec3_t(ray_end.x,ray_end.y,ray_end.z), 15, 20, 5, color_t(255, 0, 0), 10.0)
    --debug_overlay.add_sphere(vec3_t(ray_casted.x,ray_casted.y,ray_casted.z), 15, 20, 5, color_t(0, 255, 00), 10.0)

    local new_angle = Math:CalcAngle(ray_casted,local_eye_pos)

    view.vecOrigin = ffi.new("Vector",{ray_casted.x,ray_casted.y,ray_casted.z + 10.0})
    view.angView = ffi.new("QAngle",{ new_angle.x,new_angle.y,new_angle.z })
end

function CSpyCam:OnViewRender(ecx,view,original)

    local spyView = MakeCopyOfViewSetup(view)

    if(self.m_nTargetEntity == -1)then
        return
    end
    local entity = entity_list.get_entity(self.m_nTargetEntity)

    if(not entity or not entity:is_alive() or entity:is_dormant()) then
        return
    end
	
    spyView.iX = 0
    spyView.iUnscaledX = 0
    spyView.iY = 0
    spyView.iUnscaledY = 0
    spyView.iWidth = self.m_vecSize.x
    spyView.iUnscaledWidth = self.m_vecSize.x
    spyView.iHeight = self.m_vecSize.y
    spyView.iUnscaledHeight = self.m_vecSize.y
    spyView.flAspectRatio = spyView.iWidth / spyView.iHeight

    -- spyView.flNearBlurDepth = 20.0
    -- spyView.flNearFocusDepth = 50.0
    -- spyView.flFarBlurDepth = 0.0
    -- spyView.flFarFocusDepth = 50.0
    -- spyView.flNearBlurRadius = 0.0
    -- spyView.flFarBlurRadius = 0.0
    -- spyView.nMotionBlurMode = 1

    -- spyView.flNearZ = 7.0
    -- spyView.flNearViewmodelZ = 7.0
    -- spyView.flFarZ = 28377.9199
    -- spyView.flFarViewmodelZ = 28377.9199

    -- spyView.flFOV = 14.0
    self:CalcView(spyView,entity)
	
    local renderCtx = IMatRenderContext:new(Globals.g_pMaterialSystem:GetRenderContext())

    renderCtx:PushRenderTargetAndViewport()
    renderCtx:SetRenderTarget(self.m_SpyTexture)

    original(ecx,spyView,spyView,35,0)

    renderCtx:PopRenderTargetAndViewport()
    renderCtx:Release()
end

function OnPaint()
    local local_player = entity_list.get_local_player()
    CSpyCam:RenderUI()
    CSpyCam:Input()
    if not(not engine.is_connected() or not engine.is_in_game() or not local_player or not local_player:is_alive()) then
        CSpyCam:UpdateEntities()
        CSpyCam:Render()
    end
end

function myerrorhandler( err )
    print( "ERROR:", err )
end

function hkRenderView(original) -- 6
    function RenderView(ecx, viewSetup, viewHUD, nClearFlags, nWhatToDraw)

        --local view = ffi.cast("CViewSetup*",ffi.cast("uint32_t**",memory.find_pattern("client.dll","8B 0D 6C ?? ?? ?? D9 1D ?? ?? ?? ??") + 2)[0][0])
        local local_player = entity_list.get_local_player()
        if not(not viewSetup or not engine.is_connected() or not engine.is_in_game() or not local_player or not local_player:is_alive()) then
            xpcall(CSpyCam.OnViewRender,myerrorhandler,CSpyCam,ecx,viewSetup,original)
            --CSpyCam:OnViewRender(ecx,viewSetup,original)
        end

        return original(ecx, viewSetup, viewHUD, nClearFlags, nWhatToDraw)

    end
    return RenderView
end

--function PaintTraverseHook(originalFunction)
--    local originalFunction=originalFunction
--    local topPanel=nil
--    function PaintTraverse(this,panel,forceRepaint,allowForce)
--        if topPanel==nil then
--            local name=ffi.string(nativeIPanelGetName(panel))
--            if name=="FocusOverlayPanel" then
--                topPanel=panel
--            end
--        end
--        if panel==topPanel then
--            --CSpyCam:Render()
--            --print("hooked PaintTraverse")
--        end
--        return originalFunction(this,panel,forceRepaint,allowForce)
--    end
--    return PaintTraverse
--end

CSpyCam:Init()

local ViewRender_Hook = hook.vmt.new(Globals.g_ViewRender)
ViewRender_Hook.hookMethod("void(__thiscall*)(uint32_t,CViewSetup&,CViewSetup&,int,int)", hkRenderView,6)



--local IPanel = hook.vmt.new(memory.create_interface("vgui2.dll", "VGUI_Panel009"))
--IPanel.hookMethod("void(__thiscall*)(void*,int,bool,bool)",PaintTraverseHook,41)
--ffi.cdef [[
--
--    typedef bool(__thiscall* oShouldDraw) (void*);
--
--]]
--local function ShouldDrawHook(original_function)
--    local original_function = original_function
--    function hk(ecx,edx)
--       return original_function(ecx,edx)
--    end
--    return hk
--end
--
--local ShouldDrawJmpHook = hook.jmp.new("bool(__fastcall*)(void*,void*)",ShouldDrawHook,memory.find_pattern("client.dll","56 8B F1 80 ? ? ? ? ? ? 75 04 32"),10,true)

--function hkShouldDraw(original_function)
--    local original_function = original_function
--    function hk(ecx,edx)
--        print(ecx)
--       return original_function(ecx,edx)
--    end
--    return hk
--end
--
--local ShouldDrawHook = hook.direct.new(fnGetModuleHandle("client.dll") + 0xBC7E60)
--ShouldDrawHook.hookMethod("char(__fastcall*)(void*,void*)",hkShouldDraw)

local function on_shutdown()
    ViewRender_Hook.unHookAll()
    --ShouldDrawHook.unHook()
    --IClientRenderable_Hook.unHookAll()
    --if(ShouldDrawJmpHook ~= nil) then
    --    ShouldDrawJmpHook.stop()
    --end
    --IPanel.unHookAll()
end

--local glow_material = materials.create("glow_material",
--    [[
--          "VertexLitGeneric"
--          {
--            "$additive"         "1"
--            "$envmap"           "models/effects/cube_white"
--            "$envmapfresnel"    "1"
--            "$alpha"            "0.8"
--          }
--    ]])

--function on_draw_model(ctx)
--    if not bShouldHighlight:get() or ctx.model_name:find("models/player") == nil --[[or ctx.entity:get_index() ~= CSpyCam.m_nTargetEntity ]]then
--        return
--    end
--    ctx.override_original = false
--
--    glow_material:set_flag(e_material_flags.IGNOREZ, bShouldHighlight_ThruWalls:get())
--    glow_material:alpha_modulate(0.5)
--    --ctx:draw_original()
--    ctx:draw_material(glow_material)
--
--end
--
--callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)

callbacks.add(e_callbacks.PAINT, OnPaint)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)