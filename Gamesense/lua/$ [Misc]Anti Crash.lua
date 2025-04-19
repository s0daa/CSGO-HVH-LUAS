local ffi = require("ffi")
local AntiCrash = {
    arrHooks = {},
	szAuthor = "SYR",
    pVClient = client.create_interface("client.dll", "VClient018")
}

AntiCrash.__index = setmetatable(AntiCrash, {})
AntiCrash.__index.CallModuleProxy = (function()
	local pStdCallProxy = client.find_signature("client.dll", "\x51\xC3")
	local fnGetModuleHandleProxy = ffi.cast("void*(__thiscall*)(void*, const char*)", pStdCallProxy)
	local fnGetModuleProcProxy = ffi.cast("void*(__thiscall*)(void*, void*, const char*)", pStdCallProxy)
	local pGetModuleHandleStack = ffi.cast("void***", ffi.cast("char*", client.find_signature("client.dll", "\xC6\x06\x00\xFF\x15\xCC\xCC\xCC\xCC\x50")) + 5)[0][0]
	local pGetModuleProcStack = ffi.cast("void***", ffi.cast("char*", client.find_signature("client.dll", "\x50\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x0F\x84\xCC\xCC\xCC\xCC\x6A\x00")) + 3)[0][0]
	return function(self, szModule, szProc, szType, ...)
		local hModule = fnGetModuleHandleProxy(pGetModuleHandleStack, szModule)
		if not hModule or hModule == ffi.NULL then
			return nil
		end

		local pModuleProc = fnGetModuleProcProxy(pGetModuleProcStack, hModule, szProc)
		if not pModuleProc or pModuleProc == ffi.NULL then
			return nil
		end

		local fnStdCallProxy = ffi.cast(szType, pStdCallProxy)
		return fnStdCallProxy(pModuleProc, ...)
	end
end)()

AntiCrash.__index.VtableHook = function(self, pInstance, nIndex, szType, pDetour)
    local pVtable = ffi.cast("void***", pInstance)[0]
    local __Object = {
        bHooked = false,
		bAvailable = true,
        pProtect = ffi.new("uint32_t[1]"),
        pOriginalFn = ffi.cast(szType, pVtable[nIndex])
    }

    __Object.pDetourFn = ffi.cast(szType, function(...)
        local bSuccessfully, pResult = pcall(pDetour, __Object, ...)
        if not bSuccessfully then
            client.error_log(("vtable hook throw runtime error: %s"):format(pResult))
            return __Object(...)
        end

        return pResult
    end)

    __Object.__index = setmetatable(__Object, {
        __call = function(this, ...)
			if not this.bAvailable then
				return nil
			end

            return this.pOriginalFn(...)
        end,

        __index = {
            Hook = function(this)
                if this.bAvailable and not this.bHooked then
                    this.bHooked = true
                    self:CallModuleProxy("Kernel32.dll", "VirtualProtect", "int(__thiscall*)(void*, void*, uint32_t, uint32_t, uint32_t*)", pVtable + nIndex, 0x4, 0x4, this.pProtect)
                    pVtable[nIndex] = ffi.cast("void*", this.pDetourFn)
                    self:CallModuleProxy("Kernel32.dll", "VirtualProtect", "int(__thiscall*)(void*, void*, uint32_t, uint32_t, uint32_t*)", pVtable + nIndex, 0x4, this.pProtect[0], this.pProtect)
                end
            end,

            UnHook = function(this)
                if this.bAvailable and this.bHooked then
                    this.bHooked = false
                    self:CallModuleProxy("Kernel32.dll", "VirtualProtect", "int(__thiscall*)(void*, void*, uint32_t, uint32_t, uint32_t*)", pVtable + nIndex, 0x4, 0x4, this.pProtect)
                    pVtable[nIndex] = ffi.cast("void*", this.pOriginalFn)
                    self:CallModuleProxy("Kernel32.dll", "VirtualProtect", "int(__thiscall*)(void*, void*, uint32_t, uint32_t, uint32_t*)", pVtable + nIndex, 0x4, this.pProtect[0], this.pProtect)
                end
            end,

			Remove = function(this)
				if this.bAvailable then
					this:UnHook()
					this.bAvailable = false
				end
			end
        }
    })

    __Object:Hook()
    table.insert(self.arrHooks, __Object)
    return __Object
end

AntiCrash.__index.Work = function(self)
    self:VtableHook(self.pVClient, 38, "bool(__thiscall*)(void*, int, int, int, const void*)", function(pHookObject, pVClient, nType, nFlags, nSize, pMessage)
        if nType == 63 then
            return false
        end

        return pHookObject(pVClient, nType, nFlags, nSize, pMessage)
    end)

    client.set_event_callback("shutdown", function()
        for _, pHookObject in pairs(self.arrHooks) do
            pHookObject:UnHook()
        end
    end)
end

AntiCrash:Work()