local hook=require("hooking library")

local function vtable_bind(module, interface, index, type)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or error(interface .. " is nil.")
    return ffi.cast(ffi.typeof(type), addr[0][index]), addr
end

local function __thiscall(func, this) -- bind wrapper for __thiscall functions
    return function(...)
        return func(this, ...)
    end
end

local function vtable_thunk(index, typestring)
    local t = ffi.typeof(typestring)
    return function(instance, ...)
        assert(instance ~= nil)
        if instance then
            local addr=ffi.cast("void***", instance)
            return __thiscall(ffi.cast(t, (addr[0])[index]),addr)
        end
    end
end

local pGetModuleHandle_sig =
    memory.find_pattern("engine.dll", " FF 15 ? ? ? ? 85 C0 74 0B") or error("Couldn't find signature #1")
local pGetProcAddress_sig =
    memory.find_pattern("engine.dll", " FF 15 ? ? ? ? A3 ? ? ? ? EB 05") or error("Couldn't find signature #2")

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

local auto_accept_ref = menu.add_checkbox("auto accept", "yes!", false)

ffi.cdef[[
typedef struct {
    void* pSteamClient;
    void* pSteamUser;
    void* pSteamFriends;
    void* pSteamUtils;
} SteamAPIContext;
]]

local nullptr = ffi.new('void*')

--local Beep=proc_bind("kernel32.dll","Beep","bool(__stdcall*)(int,int)")
--client.delay_call(function() Beep(500,100) end,1)

local nativeSetLocalPlayerReady = ffi.cast("void(__stdcall*)(const char*)",memory.find_pattern("client.dll","55 8B EC 83 E4 F8 8B 4D 08 BA ? ? ? ? E8 ? ? ? ? 85 C0 75 12") or error("Couldn't find signature #3"))

assert(nativeSetLocalPlayerReady~=nullptr)

local nativeGetSteamAPIContext = __thiscall(vtable_bind("engine.dll", "VEngineClient014", 185, "SteamAPIContext*(__thiscall*)(void*)"))

assert(nativeGetSteamAPIContext~=nullptr)

local ISteamAPIContext=nativeGetSteamAPIContext()

assert(ISteamAPIContext~=nullptr)

local ISteamClient=ISteamAPIContext.pSteamClient

assert(ISteamClient~=nullptr)

local ISteamUser=ISteamAPIContext.pSteamUser

assert(ISteamUser~=nullptr)

local HSteamUser=proc_bind("steam_api.dll","SteamAPI_GetHSteamUser","int32_t(__stdcall*)()")()

assert(HSteamUser~=nullptr)

local HSteamPipe=proc_bind("steam_api.dll","SteamAPI_GetHSteamPipe","int32_t(__stdcall*)()")()

assert(HSteamPipe~=nullptr)

local ISteamClientAddr=ffi.cast("void***",ISteamClient)
local nativeGetISteamGenericInterface = __thiscall(ffi.cast(ffi.typeof("void*(__thiscall*)(void*,int32_t,int32_t,const char*)"), ISteamClientAddr[0][12]), ISteamClientAddr)

local ISteamGameCoordinator=nativeGetISteamGenericInterface(HSteamUser,HSteamPipe,"SteamGameCoordinator001")

assert(ISteamGameCoordinator~=nullptr)

local function RetrieveMessageHook(originalFunction)
	local originalFunction=originalFunction
	return function(this, puMsgType, pDest, uDest, puMsgSize)
		local iStatus=originalFunction(this, puMsgType, pDest, uDest, puMsgSize)
		if iStatus~=0 then return iStatus end
		local uMessageType=bit.band(puMsgType[0],0x7FFFFFFF)
		if auto_accept_ref:get() and uMessageType==9177 then
			engine.execute_cmd("play ambient\\animal\\bird"..tostring(client.random_int(1, 20)))
			client.delay_call(function() nativeSetLocalPlayerReady("") end, 0.5)
		end
		return iStatus
	end
end

local ISteamGameCoordinatorHook=hook.vmt.new(ISteamGameCoordinator)

ISteamGameCoordinatorHook.hookMethod("int(__thiscall*)(void*, uint32_t*, void*, uint32_t, uint32_t*)",RetrieveMessageHook,2)

function on_shutdown()
    ISteamGameCoordinatorHook.unHookAll()
end

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)