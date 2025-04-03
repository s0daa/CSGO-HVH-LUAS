---@diagnostic disable: undefined-global
--
-- dependencies
--
local _INFO, cast, typeof, new, find_pattern, create_interface, api, safe_mode, _error, exception, rawgetImpl, rawsetImpl, __thiscall, table_copy, vtable_bind, interface_ptr, vtable_entry, vtable_thunk, proc_bind, follow_call, v8js_args, is_array, nullptr, intbuf, panorama, vtable, DllImport, UIEngine, nativeIsValidPanelPointer, nativeGetLastDispatchedEventTargetPanel, nativeCompileRunScript, nativeRunScript, nativeGetV8GlobalContext, nativeGetIsolate, nativeGetParent, nativeGetID, nativeFindChildTraverse, nativeGetJavaScriptContextParent, nativeGetPanelContext, jsContexts, getJavaScriptContextParent, v8_dll, persistentTbl, Local, MaybeLocal, PersistentProxy_mt, Persistent, Value, Object, Array, Function, ObjectTemplate, FunctionTemplate, Primitive, Null, Boolean, Number, Integer, String, Isolate, Context, HandleScope, TryCatch, Script, PanelInfo_t, CUtlVector_Constructor_t, panelList, panelArrayOffset, panelArray
_INFO = {
  _VERSION = 1.1
}
setmetatable(_INFO, {
  __call = function(self)
    return self._VERSION
  end,
  __tostring = function(self)
    return self._VERSION
  end
})
if _G and not ffi then
  ffi = require("ffi")
end
do
  local _obj_0 = ffi
  cast, typeof, new = _obj_0.cast, _obj_0.typeof, _obj_0.new
end
find_pattern = function()
  return error("Unknown provider")
end
create_interface = function()
  return error("Unknown provider")
end
api = (_G == nil) and "ev0lve" or (file == nil and (GameEventManager == nil and "primordial" or "memesense") or "legendware")
local _exp_0 = api
if "ev0lve" == _exp_0 then
  find_pattern = utils.find_pattern
  create_interface = utils.find_interface
elseif "primordial" == _exp_0 then
  find_pattern = memory.find_pattern
  create_interface = memory.create_interface
elseif "memesense" == _exp_0 then
  find_pattern = Utils.PatternScan
  create_interface = Utils.CreateInterface
elseif "legendware" == _exp_0 then
  find_pattern = utils.find_signature
  create_interface = utils.create_interface
end
safe_mode = xpcall and true or false
print(("\nluv8 panorama library;\napi: %s;\nenabled features: safe_mode: %s; rawops: %s; ffi.C: %s"):format(api, tostring(safe_mode), tostring(rawget ~= nil), tostring(ffi.C ~= nil)))
_error = error
if 1 + 2 == 3 then
  error = function(msg)
    for _, v in pairs(persistentTbl) do
      Persistent(v):disposeGlobal()
    end
    return _error(msg)
  end
end
exception = function(msg)
  return print("Caught exception in HandleScope: ", tostring(msg))
end
rawgetImpl = function(tbl, key)
  local mtb = getmetatable(tbl)
  setmetatable(tbl, nil)
  local res = tbl[key]
  setmetatable(tbl, mtb)
  return res
end
rawsetImpl = function(tbl, key, value)
  local mtb = getmetatable(tbl)
  setmetatable(tbl, nil)
  tbl[key] = value
  return setmetatable(tbl, mtb)
end
if not rawget then
  rawget = rawgetImpl
end
if not rawset then
  rawset = rawsetImpl
end
__thiscall = function(func, this)
  return function(...)
    return func(this, ...)
  end
end
table_copy = function(t)
  local _tbl_0 = { }
  for k, v in pairs(t) do
    _tbl_0[k] = v
  end
  return _tbl_0
end
vtable_bind = function(module, interface, index, typedef)
  local addr = cast("void***", create_interface(module, interface)) or error(interface .. " is nil.")
  return __thiscall(cast(typedef, addr[0][index]), addr)
end
interface_ptr = typeof("void***")
vtable_entry = function(instance, i, ct)
  return cast(ct, cast(interface_ptr, instance)[0][i])
end
vtable_thunk = function(i, ct)
  local t = typeof(ct)
  return function(instance, ...)
    return vtable_entry(instance, i, t)(instance, ...)
  end
end
proc_bind = (function()
  local fnGetProcAddress
  fnGetProcAddress = function()
    return error("Failed to load GetProcAddress")
  end
  local fnGetModuleHandle
  fnGetModuleHandle = function()
    return error("Failed to load GetModuleHandleA")
  end
  if ffi.C then
    ffi.cdef([[            uint32_t GetProcAddress(uint32_t, const char*);
            uint32_t GetModuleHandleA(const char*);
        ]])
    fnGetProcAddress = ffi.C.GetProcAddress
    fnGetModuleHandle = ffi.C.GetModuleHandleA
  else
    fnGetProcAddress = cast("uint32_t(__stdcall*)(uint32_t, const char*)", cast("uint32_t**", cast("uint32_t", find_pattern("engine.dll", "FF 15 ? ? ? ? A3 ? ? ? ? EB 05")) + 2)[0][0])
    fnGetModuleHandle = cast("uint32_t(__stdcall*)(const char*)", cast("uint32_t**", cast("uint32_t", find_pattern("engine.dll", "FF 15 ? ? ? ? 85 C0 74 0B")) + 2)[0][0])
  end
  return function(module_name, function_name, typedef)
    return cast(typeof(typedef), fnGetProcAddress(fnGetModuleHandle(module_name), function_name))
  end
end)()
follow_call = function(ptr)
  local insn = cast("uint8_t*", ptr)
  local _exp_1 = insn[0]
  if (0xE8 or 0xE9) == _exp_1 then
    return cast("uint32_t", insn + cast("int32_t*", insn + 1)[0] + 5)
  elseif 0xFF == _exp_1 then
    if insn[1] == 0x15 then
      return cast("uint32_t**", cast("const char*", ptr) + 2)[0][0]
    end
  else
    return ptr
  end
end
v8js_args = function(...)
  local argTbl = {
    ...
  }
  local iArgc = #argTbl
  local pArgv = new(("void*[%.f]"):format(iArgc))
  for i = 1, iArgc do
    pArgv[i - 1] = Value:fromLua(argTbl[i]):getInternal()
  end
  return iArgc, pArgv
end
is_array = function(val)
  local i = 1
  for _ in pairs(val) do
    if val[i] ~= nil then
      i = i + 1
    else
      return false
    end
  end
  return i ~= 1
end
nullptr = new("void*")
intbuf = new("int[1]")
panorama = {
  panelIDs = { }
}
do
  local _class_0
  local _base_0 = {
    get = function(self, index, t)
      return __thiscall(cast(t, self.this[0][index]), self.this)
    end,
    getInstance = function(self)
      return self.this
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, ptr)
      self.this = cast("void***", ptr)
    end,
    __base = _base_0,
    __name = "vtable"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  vtable = _class_0
end
do
  local _class_0
  local _base_0 = {
    cache = { },
    get = function(self, method, typedef)
      if not (self.cache[method]) then
        self.cache[method] = proc_bind(self.file, method, typedef)
      end
      return self.cache[method]
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, filename)
      self.file = filename
    end,
    __base = _base_0,
    __name = "DllImport"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DllImport = _class_0
end
UIEngine = vtable(vtable_bind("panorama.dll", "PanoramaUIEngine001", 11, "void*(__thiscall*)(void*)")())
nativeIsValidPanelPointer = UIEngine:get(36, "bool(__thiscall*)(void*,void const*)")
nativeGetLastDispatchedEventTargetPanel = UIEngine:get(56, "void*(__thiscall*)(void*)")
nativeCompileRunScript = UIEngine:get(113, "void****(__thiscall*)(void*,void*,char const*,char const*,int,int,bool)")
nativeRunScript = __thiscall(cast(typeof("void*(__thiscall*)(void*,void*,void*,void*,int,bool)"), follow_call(find_pattern("panorama.dll", api == "legendware" and "E8 ? ? ? ? 8B 4C 24 10 FF 15 ?" or "E8 ? ? ? ? 8B 4C 24 10 FF 15 ? ? ? ?"))), UIEngine:getInstance())
nativeGetV8GlobalContext = UIEngine:get(123, "void*(__thiscall*)(void*)")
nativeGetIsolate = UIEngine:get(129, "void*(__thiscall*)(void*)")
nativeGetParent = vtable_thunk(25, "void*(__thiscall*)(void*)")
nativeGetID = vtable_thunk(9, "const char*(__thiscall*)(void*)")
nativeFindChildTraverse = vtable_thunk(40, "void*(__thiscall*)(void*,const char*)")
nativeGetJavaScriptContextParent = vtable_thunk(218, "void*(__thiscall*)(void*)")
nativeGetPanelContext = __thiscall(cast("void***(__thiscall*)(void*,void*)", follow_call(find_pattern("panorama.dll", "E8 ? ? ? ? 8B 00 85 C0 75 1B"))), UIEngine:getInstance())
jsContexts = { }
getJavaScriptContextParent = function(panel)
  if jsContexts[panel] ~= nil then
    return jsContexts[panel]
  end
  jsContexts[panel] = nativeGetJavaScriptContextParent(panel)
  return jsContexts[panel]
end
v8_dll = DllImport("v8.dll")
persistentTbl = { }
do
  local _class_0
  local _base_0 = {
    getInternal = function(self)
      return self.this
    end,
    globalize = function(self)
      local pPersistent = v8_dll:get("?GlobalizeReference@V8@v8@@CAPAPAVObject@internal@2@PAVIsolate@42@PAPAV342@@Z", "void*(__cdecl*)(void*,void*)")(nativeGetIsolate(), self.this[0])
      local persistent = Persistent(pPersistent)
      persistentTbl[persistent:getIdentityHash()] = pPersistent
      return persistent
    end,
    __call = function(self)
      return Value(self.this[0])
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, val)
      self.this = cast("void**", val)
    end,
    __base = _base_0,
    __name = "Local"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Local = _class_0
end
do
  local _class_0
  local _base_0 = {
    getInternal = function(self)
      return self.this
    end,
    toLocalChecked = function(self)
      if not (self.this[0] == nullptr) then
        return Local(self.this)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, val)
      self.this = cast("void**", val)
    end,
    __base = _base_0,
    __name = "MaybeLocal"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MaybeLocal = _class_0
end
PersistentProxy_mt = {
  __index = function(self, key)
    local this = rawget(self, "this")
    local ret = HandleScope()(function()
      return this:get():toLocalChecked()():toObject():get(Value:fromLua(key):getInternal()):toLocalChecked()():toLua()
    end)
    if type(ret) == "table" then
      rawset(ret, "parent", this)
    end
    return ret
  end,
  __newindex = function(self, key, value)
    local this = rawget(self, "this")
    return HandleScope()(function()
      return this:get():toLocalChecked()():toObject():set(Value:fromLua(key):getInternal(), Value:fromLua(value):getInternal()):toLocalChecked()():toLua()
    end)
  end,
  __len = function(self)
    local this = rawget(self, "this")
    local ret = 0
    if this.baseType == "Array" then
      ret = HandleScope()(function()
        return this:get():toLocalChecked()():toArray():length()
      end)
    elseif this.baseType == "Object" then
      ret = HandleScope()(function()
        return this:get():toLocalChecked()():toObject():getPropertyNames():toLocalChecked()():toArray():length()
      end)
    end
    return ret
  end,
  __pairs = function(self)
    local this = rawget(self, "this")
    local ret
    ret = function()
      return nil
    end
    if this.baseType == "Object" then
      HandleScope()(function()
        local keys = Array(this:get():toLocalChecked()():toObject():getPropertyNames():toLocalChecked()())
        local current, size = 0, keys:length()
        ret = function()
          current = current + 1
          local key = keys[current - 1]
          if current <= size then
            return key, self[key]
          end
        end
      end)
    end
    return ret
  end,
  __ipairs = function(self)
    local this = rawget(self, "this")
    local ret
    ret = function()
      return nil
    end
    if this.baseType == "Array" then
      HandleScope()(function()
        local current, size = 0, this:get():toLocalChecked()():toArray():length()
        ret = function()
          current = current + 1
          if current <= size then
            return current, self[current - 1]
          end
        end
      end)
    end
    return ret
  end,
  __call = function(self, ...)
    local this = rawget(self, "this")
    local args = {
      ...
    }
    if this.baseType ~= "Function" then
      error("Attempted to call a non-function value: " .. this.baseType)
    end
    return HandleScope()(function()
      local rawReturn = this:get():toLocalChecked()():toFunction():setParent(rawget(self, "parent"))(unpack(args)):toLocalChecked()
      if rawReturn == nil then
        return nil
      else
        return rawReturn():toLua()
      end
    end)
  end,
  __tostring = function(self)
    local this = rawget(self, "this")
    return HandleScope()(function()
      return this:get():toLocalChecked()():stringValue()
    end)
  end,
  __gc = function(self)
    local this = rawget(self, "this")
    return this:disposeGlobal()
  end
}
do
  local _class_0
  local _base_0 = {
    setType = function(self, val)
      self.baseType = val
      return self
    end,
    getInternal = function(self)
      return self.this
    end,
    disposeGlobal = function(self)
      return v8_dll:get("?DisposeGlobal@V8@v8@@CAXPAPAVObject@internal@2@@Z", "void(__cdecl*)(void*)")(self.this)
    end,
    get = function(self)
      return MaybeLocal(HandleScope:createHandle(self.this))
    end,
    toLua = function(self)
      return self:get():toLocalChecked()():toLua()
    end,
    getIdentityHash = function(self)
      return v8_dll:get("?GetIdentityHash@Object@v8@@QAEHXZ", "int(__thiscall*)(void*)")(self.this)
    end,
    __call = function(self)
      return setmetatable({
        this = self,
        parent = nil
      }, PersistentProxy_mt)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, val, baseType)
      if baseType == nil then
        baseType = "Value"
      end
      self.this = val
      self.baseType = baseType
    end,
    __base = _base_0,
    __name = "Persistent"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Persistent = _class_0
end
do
  local _class_0
  local _base_0 = {
    fromLua = function(self, val)
      if val == nil then
        return Null(nativeGetIsolate()):getValue()
      end
      if type(val) == "boolean" then
        return Boolean(nativeGetIsolate(), val):getValue()
      end
      if type(val) == "number" then
        return Number(nativeGetIsolate(), val):getInstance()
      end
      if type(val) == "string" then
        return String(nativeGetIsolate(), val):getInstance()
      end
      if type(val) == "table" and is_array(val) then
        return Array:fromLua(nativeGetIsolate(), val)
      end
      if type(val) == "table" then
        return Object:fromLua(nativeGetIsolate(), val)
      end
      return error("Failed to convert from lua to v8js: Unknown type")
    end,
    isUndefined = function(self)
      return v8_dll:get("?IsUndefined@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    isNull = function(self)
      return v8_dll:get("?IsNull@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    isBoolean = function(self)
      return v8_dll:get("?IsBoolean@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    isBooleanObject = function(self)
      return v8_dll:get("?IsBooleanObject@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    isNumber = function(self)
      return v8_dll:get("?IsNumber@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    isNumberObject = function(self)
      return v8_dll:get("?IsNumberObject@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    isString = function(self)
      return v8_dll:get("?IsString@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    isStringObject = function(self)
      return v8_dll:get("?IsStringObject@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    isObject = function(self)
      return v8_dll:get("?IsObject@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    isArray = function(self)
      return v8_dll:get("?IsArray@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    isFunction = function(self)
      return v8_dll:get("?IsFunction@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    booleanValue = function(self)
      return v8_dll:get("?BooleanValue@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    numberValue = function(self)
      return v8_dll:get("?NumberValue@Value@v8@@QBENXZ", "double(__thiscall*)(void*)")(self.this)
    end,
    stringValue = function(self)
      local strBuf = new('char*[2]')
      local val = v8_dll:get("??0Utf8Value@String@v8@@QAE@V?$Local@VValue@v8@@@2@@Z", "struct{char* str; int length;}*(__thiscall*)(void*,void*)")(strBuf, self.this)
      local s = ffi.string(val.str, val.length)
      v8_dll:get("??1Utf8Value@String@v8@@QAE@XZ", "void(__thiscall*)(void*)")(strBuf)
      return s
    end,
    toObject = function(self)
      return Object(MaybeLocal(v8_dll:get("?ToObject@Value@v8@@QBE?AV?$Local@VObject@v8@@@2@XZ", "void*(__thiscall*)(void*,void*)")(self.this, intbuf)):toLocalChecked()():getInternal())
    end,
    toArray = function(self)
      return Array(MaybeLocal(v8_dll:get("?ToObject@Value@v8@@QBE?AV?$Local@VObject@v8@@@2@XZ", "void*(__thiscall*)(void*,void*)")(self.this, intbuf)):toLocalChecked()():getInternal())
    end,
    toFunction = function(self)
      return Function(MaybeLocal(v8_dll:get("?ToObject@Value@v8@@QBE?AV?$Local@VObject@v8@@@2@XZ", "void*(__thiscall*)(void*,void*)")(self.this, intbuf)):toLocalChecked()():getInternal())
    end,
    toLocal = function(self)
      return Local(new("void*[1]", self.this))
    end,
    toLua = function(self)
      if self:isUndefined() or self:isNull() then
        return nil
      end
      if self:isBoolean() or self:isBooleanObject() then
        return self:booleanValue()
      end
      if self:isNumber() or self:isNumberObject() then
        return self:numberValue()
      end
      if self:isString() or self:isStringObject() then
        return self:stringValue()
      end
      if self:isObject() then
        if self:isArray() then
          return self:toArray():toLocal():globalize():setType("Array")()
        end
        if self:isFunction() then
          return self:toFunction():toLocal():globalize():setType("Function")()
        end
        return self:toObject():toLocal():globalize():setType("Object")()
      end
      return error("Failed to convert from v8js to lua: Unknown type")
    end,
    getInternal = function(self)
      return self.this
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, val)
      self.this = cast("void*", val)
    end,
    __base = _base_0,
    __name = "Value"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Value = _class_0
end
do
  local _class_0
  local _parent_0 = Value
  local _base_0 = {
    fromLua = function(self, isolate, val)
      local obj = Object(MaybeLocal(v8_dll:get("?New@Object@v8@@SA?AV?$Local@VObject@v8@@@2@PAVIsolate@2@@Z", "void*(__cdecl*)(void*,void*)")(intbuf, isolate)):toLocalChecked()():getInternal())
      for i, v in pairs(val) do
        obj:set(Value:fromLua(i):getInternal(), Value:fromLua(v):getInternal())
      end
      return obj
    end,
    get = function(self, key)
      return MaybeLocal(v8_dll:get("?Get@Object@v8@@QAE?AV?$Local@VValue@v8@@@2@V32@@Z", "void*(__thiscall*)(void*,void*,void*)")(self.this, intbuf, key))
    end,
    set = function(self, key, value)
      return v8_dll:get("?Set@Object@v8@@QAE_NV?$Local@VValue@v8@@@2@0@Z", "bool(__thiscall*)(void*,void*,void*)")(self.this, key, value)
    end,
    getPropertyNames = function(self)
      return MaybeLocal(v8_dll:get("?GetPropertyNames@Object@v8@@QAE?AV?$Local@VArray@v8@@@2@XZ", "void*(__thiscall*)(void*,void*)")(self.this, intbuf))
    end,
    callAsFunction = function(self, recv, argc, argv)
      return MaybeLocal(v8_dll:get("?CallAsFunction@Object@v8@@QAE?AV?$Local@VValue@v8@@@2@V32@HQAV32@@Z", "void*(__thiscall*)(void*,void*,void*,int,void*)")(self.this, intbuf, recv, argc, argv))
    end,
    getIdentityHash = function(self)
      return v8_dll:get("?GetIdentityHash@Object@v8@@QAEHXZ", "int(__thiscall*)(void*)")(self.this)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, val)
      self.this = val
    end,
    __base = _base_0,
    __name = "Object",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Object = _class_0
end
do
  local _class_0
  local _parent_0 = Object
  local _base_0 = {
    fromLua = function(self, isolate, val)
      local arr = Array(MaybeLocal(v8_dll:get("?New@Array@v8@@SA?AV?$Local@VArray@v8@@@2@PAVIsolate@2@H@Z", "void*(__cdecl*)(void*,void*,int)")(intbuf, isolate, #val)):toLocalChecked()():getInternal())
      for i = 1, #val do
        arr:set(i - 1, Value:fromLua(val[i]):getInternal())
      end
      return arr
    end,
    get = function(self, key)
      return MaybeLocal(v8_dll:get("?Get@Object@v8@@QAE?AV?$Local@VValue@v8@@@2@I@Z", "void*(__thiscall*)(void*,void*,unsigned int)")(self.this, intbuf, key))
    end,
    set = function(self, key, value)
      return v8_dll:get("?Set@Object@v8@@QAE_NIV?$Local@VValue@v8@@@2@@Z", "bool(__thiscall*)(void*,unsigned int,void*)")(self.this, key, value)
    end,
    length = function(self)
      return v8_dll:get("?Length@Array@v8@@QBEIXZ", "uint32_t(__thiscall*)(void*)")(self.this)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, val)
      self.this = val
    end,
    __base = _base_0,
    __name = "Array",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Array = _class_0
end
do
  local _class_0
  local _parent_0 = Object
  local _base_0 = {
    setParent = function(self, val)
      self.parent = val
      return self
    end,
    __call = function(self, ...)
      if self.parent == nil then
        return self:callAsFunction(Context(Isolate(nativeGetIsolate()):getCurrentContext()):global():toLocalChecked()():getInternal(), v8js_args(...))
      else
        return self:callAsFunction(self.parent:get():toLocalChecked()():getInternal(), v8js_args(...))
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, val, parent)
      self.this = val
      self.parent = parent
    end,
    __base = _base_0,
    __name = "Function",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Function = _class_0
end
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.this = MaybeLocal(v8_dll:get("?New@ObjectTemplate@v8@@SA?AV?$Local@VObjectTemplate@v8@@@2@XZ", "void*(__cdecl*)(void*)")(intbuf)):toLocalChecked()
    end,
    __base = _base_0,
    __name = "ObjectTemplate"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ObjectTemplate = _class_0
end
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, callback)
      self.this = MaybeLocal(v8_dll:get("?New@FunctionTemplate@v8@@SA?AV?$Local@VFunctionTemplate@v8@@@2@PAVIsolate@2@P6AXABV?$FunctionCallbackInfo@VValue@v8@@@2@@ZV?$Local@VValue@v8@@@2@V?$Local@VSignature@v8@@@2@HW4ConstructorBehavior@2@@Z", "void*(__cdecl*)(void*,void*,void*,void*,void*,int,int)")(intbuf, nativeGetIsolate(), callback, new("int[1]"), new("int[1]"), 0, 0)):toLocalChecked()
    end,
    __base = _base_0,
    __name = "FunctionTemplate"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  FunctionTemplate = _class_0
end
do
  local _class_0
  local _parent_0 = Value
  local _base_0 = {
    getValue = function(self)
      return self.this
    end,
    toString = function(self)
      return self.this:getValue():stringValue()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, val)
      self.this = val
    end,
    __base = _base_0,
    __name = "Primitive",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Primitive = _class_0
end
do
  local _class_0
  local _parent_0 = Primitive
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, isolate)
      self.this = Value(cast("uintptr_t", isolate) + 0x48)
    end,
    __base = _base_0,
    __name = "Null",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Null = _class_0
end
do
  local _class_0
  local _parent_0 = Primitive
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, isolate, bool)
      self.this = Value(cast("uintptr_t", isolate) + ((function()
        if bool then
          return 0x4C
        else
          return 0x50
        end
      end)()))
    end,
    __base = _base_0,
    __name = "Boolean",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Boolean = _class_0
end
do
  local _class_0
  local _parent_0 = Value
  local _base_0 = {
    getLocal = function(self)
      return self.this
    end,
    getValue = function(self)
      return self:getInstance():numberValue()
    end,
    getInstance = function(self)
      return self:this()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, isolate, val)
      self.this = MaybeLocal(v8_dll:get("?New@Number@v8@@SA?AV?$Local@VNumber@v8@@@2@PAVIsolate@2@N@Z", "void*(__cdecl*)(void*,void*,double)")(intbuf, isolate, tonumber(val))):toLocalChecked()
    end,
    __base = _base_0,
    __name = "Number",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Number = _class_0
end
do
  local _class_0
  local _parent_0 = Number
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, isolate, val)
      self.this = MaybeLocal(v8_dll:get("?NewFromUnsigned@Integer@v8@@SA?AV?$Local@VInteger@v8@@@2@PAVIsolate@2@I@Z", "void*(__cdecl*)(void*,void*,uint32_t)")(intbuf, isolate, tonumber(val))):toLocalChecked()
    end,
    __base = _base_0,
    __name = "Integer",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Integer = _class_0
end
do
  local _class_0
  local _parent_0 = Value
  local _base_0 = {
    getLocal = function(self)
      return self.this
    end,
    getValue = function(self)
      return self:getInstance():stringValue()
    end,
    getInstance = function(self)
      return self:this()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, isolate, val)
      self.this = MaybeLocal(v8_dll:get("?NewFromUtf8@String@v8@@SA?AV?$MaybeLocal@VString@v8@@@2@PAVIsolate@2@PBDW4NewStringType@2@H@Z", "void*(__cdecl*)(void*,void*,const char*,int,int)")(intbuf, isolate, val, 0, #val)):toLocalChecked()
    end,
    __base = _base_0,
    __name = "String",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  String = _class_0
end
do
  local _class_0
  local _base_0 = {
    enter = function(self)
      return v8_dll:get("?Enter@Isolate@v8@@QAEXXZ", "void(__thiscall*)(void*)")(self.this)
    end,
    exit = function(self)
      return v8_dll:get("?Exit@Isolate@v8@@QAEXXZ", "void(__thiscall*)(void*)")(self.this)
    end,
    getCurrentContext = function(self)
      return MaybeLocal(v8_dll:get("?GetCurrentContext@Isolate@v8@@QAE?AV?$Local@VContext@v8@@@2@XZ", "void**(__thiscall*)(void*,void*)")(self.this, intbuf)):toLocalChecked()():getInternal()
    end,
    getInternal = function(self)
      return self.this
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, val)
      if val == nil then
        val = nativeGetIsolate()
      end
      self.this = val
    end,
    __base = _base_0,
    __name = "Isolate"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Isolate = _class_0
end
do
  local _class_0
  local _base_0 = {
    enter = function(self)
      return v8_dll:get("?Enter@Context@v8@@QAEXXZ", "void(__thiscall*)(void*)")(self.this)
    end,
    exit = function(self)
      return v8_dll:get("?Exit@Context@v8@@QAEXXZ", "void(__thiscall*)(void*)")(self.this)
    end,
    global = function(self)
      return MaybeLocal(v8_dll:get("?Global@Context@v8@@QAE?AV?$Local@VObject@v8@@@2@XZ", "void*(__thiscall*)(void*,void*)")(self.this, intbuf))
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, val)
      self.this = val
    end,
    __base = _base_0,
    __name = "Context"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Context = _class_0
end
do
  local _class_0
  local _base_0 = {
    enter = function(self)
      return v8_dll:get("??0HandleScope@v8@@QAE@PAVIsolate@1@@Z", "void(__thiscall*)(void*,void*)")(self.this, nativeGetIsolate())
    end,
    exit = function(self)
      return v8_dll:get("??1HandleScope@v8@@QAE@XZ", "void(__thiscall*)(void*)")(self.this)
    end,
    createHandle = function(self, val)
      return v8_dll:get("?CreateHandle@HandleScope@v8@@KAPAPAVObject@internal@2@PAVIsolate@42@PAV342@@Z", "void**(__cdecl*)(void*,void*)")(nativeGetIsolate(), val)
    end,
    __call = function(self, func, panel)
      if panel == nil then
        panel = panorama.GetPanel("CSGOJsRegistration")
      end
      local isolate = Isolate()
      isolate:enter()
      self:enter()
      local ctx
      if panel then
        ctx = nativeGetPanelContext(getJavaScriptContextParent(panel))[0]
      else
        ctx = Context(isolate:getCurrentContext()):global():getInternal()
      end
      ctx = Context((function()
        if ctx ~= nullptr then
          return self:createHandle(ctx[0])
        else
          return 0
        end
      end)())
      ctx:enter()
      local val = nil
      if safe_mode then
        local status, ret = xpcall(func, exception)
        if status then
          val = ret
        end
      else
        val = func()
      end
      ctx:exit()
      self:exit()
      isolate:exit()
      return val
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.this = new("char[0xC]")
    end,
    __base = _base_0,
    __name = "HandleScope"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  HandleScope = _class_0
end
do
  local _class_0
  local _base_0 = {
    enter = function(self)
      return v8_dll:get("??0TryCatch@v8@@QAE@PAVIsolate@1@@Z", "void(__thiscall*)(void*,void*)")(self.this, nativeGetIsolate())
    end,
    exit = function(self)
      return v8_dll:get("??1TryCatch@v8@@QAE@XZ", "void(__thiscall*)(void*)")(self.this)
    end,
    canContinue = function(self)
      return v8_dll:get("?CanContinue@TryCatch@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    hasTerminated = function(self)
      return v8_dll:get("?HasTerminated@TryCatch@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end,
    hasCaught = function(self)
      return v8_dll:get("?HasCaught@TryCatch@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(self.this)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.this = new("char[0x19]")
    end,
    __base = _base_0,
    __name = "TryCatch"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  TryCatch = _class_0
end
do
  local _class_0
  local _base_0 = {
    compile = function(self, panel, source, layout)
      if layout == nil then
        layout = ""
      end
      return __thiscall(cast("void**(__thiscall*)(void*,void*,const char*,const char*)", api == "memesense" and find_pattern("panorama.dll", "E8 ? ? ? ? 8B 4C 24 10 FF 15 ? ? ? ?") - 2816 or find_pattern("panorama.dll", "55 8B EC 83 E4 F8 83 EC 64 53 8B D9")), UIEngine:getInstance())(panel, source, layout)
    end,
    loadstring = function(self, str, panel)
      local isolate = Isolate(nativeGetIsolate())
      local handleScope = HandleScope()
      local tryCatch = TryCatch()
      isolate:enter()
      handleScope:enter()
      local ctx
      if panel then
        ctx = nativeGetPanelContext(getJavaScriptContextParent(panel))[0]
      else
        ctx = Context(isolate:getCurrentContext()):global():getInternal()
      end
      ctx = Context((function()
        if ctx ~= nullptr then
          return handleScope:createHandle(ctx[0])
        else
          return 0
        end
      end)())
      ctx:enter()
      tryCatch:enter()
      local compiled = MaybeLocal(self:compile(panel, str)):toLocalChecked()
      tryCatch:exit()
      local ret
      if not (compiled == nil) then
        ret = MaybeLocal(nativeRunScript(intbuf, panel, compiled():getInternal(), 0, false)):toLocalChecked()():toLua()
      end
      if not (((not safe_mode) or ret)) then
        ret = (function()
          return print("WARNING: Attempted to call nullptr")
        end)
      end
      ctx:exit()
      handleScope:exit()
      isolate:exit()
      return ret
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Script"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Script = _class_0
end
PanelInfo_t = typeof([[    struct {
        char* pad1[0x4];
        void*         m_pPanel;
        void* unk1;
    }
]])
CUtlVector_Constructor_t = typeof([[    struct {
        struct {
            $ *m_pMemory;
            int m_nAllocationCount;
            int m_nGrowSize;
        } m_Memory;
        int m_Size;
        $ *m_pElements;
    }
]], PanelInfo_t, PanelInfo_t)
ffi.metatype(CUtlVector_Constructor_t, {
  __index = {
    Count = function(self)
      return self.m_Memory.m_nAllocationCount
    end,
    Element = function(self, i)
      return cast(typeof("$&", PanelInfo_t), self.m_Memory.m_pMemory[i])
    end,
    RemoveAll = function(self)
      self = nil
      self = typeof("$[?]", CUtlVector_Constructor_t)(1)[0]
      self.m_Size = 0
    end
  },
  __ipairs = function(self)
    local current, size = 0, self:Count()
    return function()
      current = current + 1
      local pPanel = self:Element(current - 1).m_pPanel
      if current <= size and nativeIsValidPanelPointer(pPanel) then
        return current, pPanel
      end
    end
  end
})
panelList = typeof("$[?]", CUtlVector_Constructor_t)(1)[0]
panelArrayOffset = cast("unsigned int*", cast("uintptr_t**", UIEngine:getInstance())[0][36] + 21)[0]
panelArray = cast(panelList, cast("uintptr_t", UIEngine:getInstance()) + panelArrayOffset)
panorama.GetPanel = function(panelName, fallback)
  local cachedPanel = panorama.panelIDs[panelName]
  if cachedPanel ~= nil and nativeIsValidPanelPointer(cachedPanel) and ffi.string(nativeGetID(cachedPanel)) == panelName then
    return cachedPanel
  end
  panorama.panelIDs = { }
  local pPanel = nullptr
  for i, v in ipairs(panelArray) do
    local curPanelName = ffi.string(nativeGetID(v))
    if curPanelName ~= "" then
      panorama.panelIDs[curPanelName] = v
      if curPanelName == panelName then
        pPanel = v
        break
      end
    end
  end
  if pPanel == nullptr then
    if fallback ~= nil then
      pPanel = panorama.GetPanel(fallback)
    else
      error(("Failed to get target panel %s (EAX == 0)"):format(tostring(panelName)))
    end
  end
  return pPanel
end
panorama.RunScript = function(jsCode, panel, pathToXMLContext)
  if panel == nil then
    panel = panorama.GetPanel("CSGOJsRegistration")
  end
  if pathToXMLContext == nil then
    pathToXMLContext = "panorama/layout/base.xml"
  end
  if not nativeIsValidPanelPointer(panel) then
    error("Invalid panel pointer (EAX == 0)")
  end
  return nativeCompileRunScript(panel, jsCode, pathToXMLContext, 8, 10, false)
end
panorama.loadstring = function(jsCode, panel)
  if panel == nil then
    panel = "CSGOJsRegistration"
  end
  local fallback = "CSGOJsRegistration"
  if panel == "CSGOMainMenu" then
    fallback = "CSGOHub"
  end
  if panel == "CSGOHub" then
    fallback = "CSGOMainMenu"
  end
  
  return Script:loadstring(("(()=>{%s})"):format(jsCode), panorama.GetPanel(panel, fallback))
end
panorama.open = function(panel)
  if panel == nil then
    panel = "CSGOJsRegistration"
  end
  local fallback = "CSGOJsRegistration"
  if panel == "CSGOMainMenu" then
    fallback = "CSGOHub"
  end
  if panel == "CSGOHub" then
    fallback = "CSGOMainMenu"
  end
  return HandleScope()(function()
    return Context(Isolate():getCurrentContext()):global():toLocalChecked()():toLua(), panorama.GetPanel(panel, fallback)
  end)
end
panorama.info = _INFO
setmetatable(panorama, {
  __tostring = function(self)
    return ("luv8 panorama library v%.1f"):format(_INFO._VERSION)
  end
})
cast, typeof, _string = ffi.cast, ffi.typeof, ffi.string

local CCSWeaponInfo_t = typeof([[
struct {
    char         __pad_0x0000[4];                       // 0x0000
    char*        console_name;                          // 0x0004
    char         __pad_0x0008[12];                      // 0x0008
    int          primary_clip_size;                     // 0x0014
    int          secondary_clip_size;                   // 0x0018
    int          primary_default_clip_size;             // 0x001c
    int          secondary_default_clip_size;           // 0x0020
    int          primary_reserve_ammo_max;              // 0x0024
    int          secondary_reserve_ammo_max;            // 0x0028
    char*        model_world;                           // 0x002c
    char*        model_player;                          // 0x0030
    char*        model_dropped;                         // 0x0034!
    char*        sound_empty;                           // 0x0038
    char*        sound_single_shot;                     // 0x003c
    char*        sound_single_shot_accurate;            // 0x0040
    char         __pad_0x0044[12];                      // 0x0044
    char*        sound_burst;                           // 0x0050
    char*        sound_reload;                          // 0x0054
    char         __pad_0x0058[16];                      // 0x0058
    char*        sound_special1;                        // 0x0068
    char*        sound_special2;                        // 0x006c
    char*        sound_special3;                        // 0x0070
    char         __pad_0x0074[4];                       // 0x0074
    char*        sound_nearlyempty;                     // 0x0078
    char         __pad_0x007c[4];                       // 0x007c
    char*        primary_ammo;                          // 0x0080
    char*        secondary_ammo;                        // 0x0084
    char*        item_name;                             // 0x0088
    char*        item_class;                            // 0x008c
    bool         itemflag_exhaustible;                  // 0x0090
    bool         model_right_handed;                    // 0x0091
    bool         is_melee_weapon;                       // 0x0092
    char         __pad_0x0093[9];                       // 0x0093
    int          weapon_weight;                         // 0x009c
    char         __pad_0x00a0[8];                       // 0x00a0
    int          item_gear_slot_position;               // 0x00a8
    char         __pad_0x00ac[28];                      // 0x00ac
    int          weapon_type_int;                       // 0x00c8
    char         __pad_0x00cc[4];                       // 0x00cc
    int          in_game_price;                         // 0x00d0
    int          kill_award;                            // 0x00d4
    char*        player_animation_extension;            // 0x00d8
    float        cycletime;                             // 0x00dc
    float        cycletime_alt;                         // 0x00e0
    float        time_to_idle;                          // 0x00e4
    float        idle_interval;                         // 0x00e8
    bool         is_full_auto;                          // 0x00ec
    char         __pad_0x00ed[3];                       // 0x00ed
    int          damage;                                // 0x00f0
    float        headshot_multiplier;                   // 0x00f4
    float        armor_ratio;                           // 0x00f4
    int          bullets;                               // 0x00f8
    float        penetration;                           // 0x00fc
    float        flinch_velocity_modifier_large;        // 0x0100
    float        flinch_velocity_modifier_small;        // 0x0104
    float        range;                                 // 0x0108
    float        range_modifier;                        // 0x010c
    float        throw_velocity;                        // 0x0110
    char         __pad_0x0114[12];                      // 0x0114
    int          has_silencer;                          // 0x0120
    char         __pad_0x0124[4];                       // 0x0124
    int          crosshair_min_distance;                // 0x0128
    int          crosshair_delta_distance;              // 0x012c
    float        max_player_speed;                      // 0x0130
    float        max_player_speed_alt;                  // 0x0134
    float        attack_movespeed_factor;               // 0x0138
    float        spread;                                // 0x013c
    float        spread_alt;                            // 0x0140
    float        inaccuracy_crouch;                     // 0x0144
    float        inaccuracy_crouch_alt;                 // 0x0148
    float        inaccuracy_stand;                      // 0x014c
    float        inaccuracy_stand_alt;                  // 0x0150
    float        inaccuracy_jump_initial;               // 0x0154
    float        inaccuracy_jump_apex;                  // 0x0158
    float        inaccuracy_jump;                       // 0x015c
    float        inaccuracy_jump_alt;                   // 0x0160
    float        inaccuracy_land;                       // 0x0164
    float        inaccuracy_land_alt;                   // 0x0168
    float        inaccuracy_ladder;                     // 0x016c
    float        inaccuracy_ladder_alt;                 // 0x0170
    float        inaccuracy_fire;                       // 0x0174
    float        inaccuracy_fire_alt;                   // 0x0178
    float        inaccuracy_move;                       // 0x017c
    float        inaccuracy_move_alt;                   // 0x0180
    float        inaccuracy_reload;                     // 0x0184
    int          recoil_seed;                           // 0x0188
    float        recoil_angle;                          // 0x018c
    float        recoil_angle_alt;                      // 0x0190
    float        recoil_angle_variance;                 // 0x0194
    float        recoil_angle_variance_alt;             // 0x0198
    float        recoil_magnitude;                      // 0x019c
    float        recoil_magnitude_alt;                  // 0x01a0
    float        recoil_magnitude_variance;             // 0x01a4
    float        recoil_magnitude_variance_alt;         // 0x01a8
    int          spread_seed;                           // 0x01ac
    float        recovery_time_crouch;                  // 0x01b0
    float        recovery_time_stand;                   // 0x01b4
    float        recovery_time_crouch_final;            // 0x01b8
    float        recovery_time_stand_final;             // 0x01bc
    int          recovery_transition_start_bullet;      // 0x01c0
    int          recovery_transition_end_bullet;        // 0x01c4
    bool         unzoom_after_shot;                     // 0x01c8
    bool         hide_view_model_zoomed;                // 0x01c9
    char         __pad_0x01ca[2];                       // 0x01ca
    int          zoom_levels;                           // 0x01cc
    int          zoom_fov_1;                            // 0x01d0
    int          zoom_fov_2;                            // 0x01d4
    int          zoom_time_0;                           // 0x01d8
    int          zoom_time_1;                           // 0x01dc
    int          zoom_time_2;                           // 0x01e0
    char*        addon_location;                        // 0x01e4
    char         __pad_0x01e8[4];                       // 0x01e8
    float        addon_scale;                           // 0x01ec
    char*        eject_brass_effect;                    // 0x01f0
    char*        tracer_effect;                         // 0x01f4
    int          tracer_frequency;                      // 0x01f8
    int          tracer_frequency_alt;                  // 0x01fc
    char*        muzzle_flash_effect_1st_person;        // 0x0200
    char*        muzzle_flash_effect_1st_person_alt;    // 0x0204
    char*        muzzle_flash_effect_3rd_person;        // 0x0208
    char*        muzzle_flash_effect_3rd_person_alt;    // 0x020c
    char*        heat_effect;                           // 0x0210
    float        heat_per_shot;                         // 0x0214
    char*        zoom_in_sound;                         // 0x0218
    char*        zoom_out_sound;                        // 0x021c
    char         __pad_0x0220[4];                       // 0x0220
    float        inaccuracy_alt_sound_threshold;        // 0x0224
    float        bot_audible_range;                     // 0x0228
    char         __pad_0x022c[12];                      // 0x022c
    bool         has_burst_mode;                        // 0x0238
    bool         is_revolver;                           // 0x0239
    char         __pad_0x023a[2];                       // 0x023a
}
]])
local struct_keys = {"console_name", "primary_clip_size", "secondary_clip_size", "primary_default_clip_size", "secondary_default_clip_size", "primary_reserve_ammo_max", "secondary_reserve_ammo_max", "model_world", "model_player", "model_dropped", "sound_empty", "sound_single_shot", "sound_single_shot_accurate", "sound_burst", "sound_reload", "sound_special1", "sound_special2", "sound_special3", "sound_nearlyempty", "primary_ammo", "secondary_ammo", "item_name", "item_class", "itemflag_exhaustible", "model_right_handed", "is_melee_weapon", "weapon_weight", "item_gear_slot_position", "weapon_type_int", "in_game_price", "kill_award", "player_animation_extension", "cycletime", "cycletime_alt", "time_to_idle", "idle_interval", "is_full_auto", "damage", "armor_ratio", "bullets", "penetration", "flinch_velocity_modifier_large", "flinch_velocity_modifier_small", "range", "range_modifier", "throw_velocity", "has_silencer", "crosshair_min_distance", "crosshair_delta_distance", "max_player_speed", "max_player_speed_alt", "attack_movespeed_factor", "spread", "spread_alt", "inaccuracy_crouch", "inaccuracy_crouch_alt", "inaccuracy_stand", "inaccuracy_stand_alt", "inaccuracy_jump_initial", "inaccuracy_jump_apex", "inaccuracy_jump", "inaccuracy_jump_alt", "inaccuracy_land", "inaccuracy_land_alt", "inaccuracy_ladder", "inaccuracy_ladder_alt", "inaccuracy_fire", "inaccuracy_fire_alt", "inaccuracy_move", "inaccuracy_move_alt", "inaccuracy_reload", "recoil_seed", "recoil_angle", "recoil_angle_alt", "recoil_angle_variance", "recoil_angle_variance_alt", "recoil_magnitude", "recoil_magnitude_alt", "recoil_magnitude_variance", "recoil_magnitude_variance_alt", "spread_seed", "recovery_time_crouch", "recovery_time_stand", "recovery_time_crouch_final", "recovery_time_stand_final", "recovery_transition_start_bullet", "recovery_transition_end_bullet", "unzoom_after_shot", "hide_view_model_zoomed", "zoom_levels", "zoom_fov_1", "zoom_fov_2", "zoom_time_0", "zoom_time_1", "zoom_time_2", "addon_location", "addon_scale", "eject_brass_effect", "tracer_effect", "tracer_frequency", "tracer_frequency_alt", "muzzle_flash_effect_1st_person", "muzzle_flash_effect_1st_person_alt", "muzzle_flash_effect_3rd_person", "muzzle_flash_effect_3rd_person_alt", "heat_effect", "heat_per_shot", "zoom_in_sound", "zoom_out_sound", "inaccuracy_alt_sound_threshold", "bot_audible_range", "has_burst_mode", "is_revolver"}

local weapon_types = {
    [0] = "knife",
    [1] = "pistol",
    [2] = "smg",
    [3] = "rifle",
    [4] = "shotgun",
    [5] = "sniperrifle",
    [6] = "machinegun",
    [7] = "c4",
    [9] = "grenade",
    [11] = "stackableitem",
    [12] = "fists",
    [13] = "breachcharge",
    [14] = "bumpmine",
    [15] = "tablet",
    [16] = "melee",
    [19] = "equipment"
}

local weapon_types_lookup = {
    [31] = "taser"
}

local function __thiscall(func, this)
    return function(...)
        return func(this, ...)
    end
end

local function vtable_thunk(index, typestring)
    local t = typeof(typestring)
    return function(instance, ...)
        assert(instance ~= nil)
        if instance then
            local addr = cast("void***", instance)
            return __thiscall(cast(t, (addr[0])[index]), addr)(...)
        end
    end
end

-- IWeaponSystem
local match = memory.find_pattern("client.dll", "8B 35 ? ? ? ? FF 10 0F B7 C0") or error("IWeaponSystem signature invalid")
local IWeaponSystem_raw = cast("void****", cast("char*", match) + 0x2)[0]

local native_GetCSWeaponInfo = vtable_thunk(2, typeof("$*(__thiscall*)(void*, unsigned int)",CCSWeaponInfo_t)) or error("invalid GetCSWeaponInfo index")
local ctype_char = typeof("char*")
local nullptr = ffi.new('void*')

-- Panorama InventoryAPI
local js = panorama.loadstring([[
return {
    parse: JSON.parse,
    get_weapon_info: (idx) => {
        let itemid = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(idx)

        if(itemid && itemid > 0) {
            return InventoryAPI.BuildItemSchemaDefJSON(itemid)
        } else {
            return "null"
        }
    },
    localize: $.Localize
}
]], "CSGOJsRegistration")()

-- generate weapon s table
local csgo_weapons, weapons_index = {}, {}

for idx=1, 1000 do
    local res = native_GetCSWeaponInfo(IWeaponSystem_raw, idx)

    if res ~= nil then
        local weapon = {}

        -- add all struct values to table
        for i=1, #struct_keys do
            local key = struct_keys[i]
            local val = res[key]

            if type(val)=="cdata" and typeof(val) == ctype_char then
                weapon[key] = _string(val)
            else
                weapon[key] = val
            end
        end

        weapon.idx = idx
        weapon.type = weapon_types_lookup[idx] or weapon_types[res.weapon_type_int]
        weapon.name = js.localize(weapon.item_name)
        weapon.raw = res

        weapon.schema = js.parse(js.get_weapon_info(idx))

        -- add to table
        csgo_weapons[idx] = weapon
        weapons_index[weapon.console_name] = weapon
    end
end

local function weapons_get_by_entity(tbl, entindex)
    if tbl ~= csgo_weapons or type(entindex) ~= "number" or entindex < 0 or entindex > 8191 then
        return
    end

    local idx = bit.band(entindex:get_prop("m_iItemDefinitionIndex"), 0xFFFF)
    return csgo_weapons[idx]
end

setmetatable(csgo_weapons, {
    __index = weapons_index,
    __metatable = false,
    __call = weapons_get_by_entity
})

--local table_clear = require "table.clear"
local function table_clear(t)
    for k in pairs(t) do
        t[k] = nil
    end
end

--
-- constants
--

local EVENT_IDX_TO_WEAPON = setmetatable({}, {
	__index = function(tbl, idx)
		tbl[idx] = csgo_weapons[tonumber(idx)] or false
		return tbl[idx]
	end
})

local ITEM_KEVLAR = csgo_weapons["item_kevlar"]
local ITEM_ASSAULTSUIT = csgo_weapons["item_assaultsuit"]
local ITEM_HEAVYASSAULTSUIT = csgo_weapons["item_heavyassaultsuit"]
local ITEM_CUTTERS = csgo_weapons["item_cutters"]
local ITEM_DEFUSER = csgo_weapons["item_defuser"]
local WEAPON_TASER = csgo_weapons["weapon_taser"]
local WEAPON_C4 = csgo_weapons["weapon_c4"]

local TEAM_T = 2
local TEAM_CT = 3

--
-- utility functions
--
local function get_player_weapon(player)
	if not player:is_valid() then return nil end

    local active_weapon = player:get_prop("m_hActiveWeapon")
    if not active_weapon then return nil end
    local weapon_ent = entity_list.get_entity(active_weapon)
    if not weapon_ent then return nil end
	return weapon_ent
end

local function deep_compare(tbl1, tbl2)
	for key1, value1 in pairs(tbl1) do
		local value2 = tbl2[key1]

		if value2 == nil then
			-- avoid the type call for missing keys in tbl2 by directly comparing with nil
			return false
		elseif value1 ~= value2 then
			if type(value1) == "table" and type(value2) == "table" then
				if not deep_compare(value1, value2) then
					return false
				end
			else
				return false
			end
		end
	end

	-- check for missing keys in tbl1
	for key2, _ in pairs(tbl2) do
		if tbl1[key2] == nil then
			return false
		end
	end

	return true
end

local function table_map_filter(tbl, callback)
	local new, j = {}, 1

	for i=1, #tbl do
		local value = callback(tbl[i])
		if value ~= nil then
			new[j] = value
			j = j + 1
		end
	end

	return new
end

local function table_map_assoc(tbl, callback)
	local new = {}
	for key, value in pairs(tbl) do
		local new_key, new_value = callback(key, value)
		new[new_key] = new_value
	end
	return new
end

local function table_contains(tbl, val)
	for i=1,#tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function table_remove_item(tbl, item)
	for i=#tbl, 1, -1 do
		if tbl[i] == item then
			table.remove(tbl, i)
		end
	end
end

--
-- since events are unordered, we sort them here
--

local event_sort_pos = {
	item_remove = 0,
	player_disconnect = 0,
	player_death = 0,
	player_spawn = 1,
	item_pickup = 2,
	item_equip = 2,
}

local function sort_events_cb(a, b)
	local a_i = event_sort_pos[a[1]] or a[1]:byte()
	local b_i = event_sort_pos[b[1]] or b[1]:byte()

	return a_i < b_i
end

--
-- js context / code block
--

local jsc = panorama.open("CSGOHud")
local FriendsListAPI, MyPersonaAPI, GameStateAPI = jsc.FriendsListAPI, jsc.MyPersonaAPI, jsc.GameStateAPI

local js = panorama.loadstring([[
	let entity_panels = {}
	let entity_flair_panels = {}
	let entity_data = {}
	let event_callbacks = {}

	let TEAM_COLORS = {
		CT: "#B5D4EE40",
		TERRORIST: "#EAD18A61"
	}

	let SHADOW_COLORS = {
		CT: "#393C40",
		TERRORIST: "#4C4844"
	}

	let HIDDEN_IDS = ["id-sb-name__commendations__leader", "id-sb-name__commendations__teacher", "id-sb-name__commendations__friendly", "id-sb-name__musickit"]

	let SLOT_LAYOUT = `
		<root>
			<Panel style="min-width: 3px; padding-top: 2px; padding-left: 2px; overflow: noclip;">
				<Image id="smaller" textureheight="15" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;"  />
				<Image id="small" textureheight="17" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;" />
				<Image id="medium" textureheight="18" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px; margin-top: -4px;" />
				<Image id="large" textureheight="21" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px; margin-top: -5px;" />
			</Panel>
		</root>
	`

	let MIN_WIDTHS = {}
	let MAX_WIDTHS = {}
	let SLOT_OVERRIDE = {}

	let GameStateAPI_IsLocalPlayerPlayingMatch_prev
	let my_xuid = MyPersonaAPI.GetXuid()

	let _SetMinMaxWidth = function(weapon, min_width, max_width, slot_override) {
		if(min_width)
			MIN_WIDTHS[weapon] = min_width

		if(max_width)
			MAX_WIDTHS[weapon] = max_width

		if(slot_override)
			SLOT_OVERRIDE[weapon] = slot_override
	}

	let _DestroyEntityPanels = function() {
		for(key in entity_panels){
			let panel = entity_panels[key]

			if(panel != null && panel.IsValid()) {
				var parent = panel.GetParent()

				HIDDEN_IDS.forEach(id => {
					let panel = parent.FindChildTraverse(id)

					if(panel != null) {
						panel.style.maxWidth = "28px"
						panel.style.margin = "0px 5px 0px 5px"
					}
				})

				if(parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
					parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 0px"
				}

				panel.DeleteAsync(0.0)
			}

			delete entity_panels[key]
		}
	}

	let _GetOrCreateCustomPanel = function(xuid) {
		if(entity_panels[xuid] == null || !entity_panels[xuid].IsValid()){
			entity_panels[xuid] = null

			// $.Msg("creating panel for ", xuid)
			let scoreboard_context_panel = $.GetContextPanel().FindChildTraverse("ScoreboardContainer").FindChildTraverse("Scoreboard") || $.GetContextPanel().FindChildTraverse("id-eom-scoreboard-container").FindChildTraverse("Scoreboard")

			if(scoreboard_context_panel == null){
				// usually happens if end of match scoreboard is open. clean up everything?

				_Clear()
				_DestroyEntityPanels()

				return
			}

			scoreboard_context_panel.FindChildrenWithClassTraverse("sb-row").forEach(function(el){
				let scoreboard_el

				if(el.m_xuid == xuid) {
					el.Children().forEach(function(child_frame){
						let stat = child_frame.GetAttributeString("data-stat", "")
						if(stat == "name") {
							scoreboard_el = child_frame.GetChild(0)
						} else if(stat == "flair") {
							entity_flair_panels[xuid] = child_frame.GetChild(0)
						}
					})

					if(scoreboard_el) {
						let scoreboard_el_parent = scoreboard_el.GetParent()

						// fix some style. this is not restored
						// scoreboard_el_parent.style.overflow = "clip clip;"

						// create panel
						let custom_weapons = $.CreatePanel("Panel", scoreboard_el_parent, "custom-weapons", {
							style: "overflow: noclip; width: fit-children; margin: 0px 0px 0px 0px; padding: 1px 0px 0px 0px; height: 100%; flow-children: left; min-width: 30px;"
						})

						HIDDEN_IDS.forEach(id => {
							let panel = scoreboard_el_parent.FindChildTraverse(id)

							if(panel != null) {
								panel.style.maxWidth = "0px"
								panel.style.margin = "0px"
							}
						})

						if(scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
							scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 5px"
						}

						scoreboard_el_parent.MoveChildBefore(custom_weapons, scoreboard_el_parent.GetChild(1))

						// create child panels
						let panel_armor = $.CreatePanel("Image", custom_weapons, "armor", {
							textureheight: "17",
							style: "padding-left: 2px; padding-top: 3px; opacity: 0.2; padding-left: 5px;"
						})
						panel_armor.visible = false

						let panel_helmet = $.CreatePanel("Image", custom_weapons, "helmet", {
							textureheight: "22",
							style: "padding-left: 2px; padding-top: 0px; opacity: 0.2; padding-left: 0px; margin-left: 3px; margin-right: -3px;"
						})
						panel_helmet.visible = false
						panel_helmet.SetImage("file://{images}/icons/equipment/helmet.svg")

						for(i=24; i >= 0; i--) {
							let panel_slot_parent = $.CreatePanel("Panel", custom_weapons, `weapon-${i}`)

							panel_slot_parent.visible = false
							panel_slot_parent.BLoadLayoutFromString(SLOT_LAYOUT, false, false)
						}

						// custom_weapons.style.border = "1px solid red;"
						entity_panels[xuid] = custom_weapons

						return custom_weapons
					}
				}
			})
		}

		return entity_panels[xuid]
	}

	let _UpdatePlayer = function(entindex, weapons, selected_weapon, armor) {
		if(entindex == null || entindex == 0)
			return

		entity_data[entindex] = arguments
	}

	let _ApplyPlayer = function(entindex, weapons, selected_weapon, armor) {
		let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)

		// $.Msg("applying for ", entindex, ": ", weapons)
		let panel = _GetOrCreateCustomPanel(xuid)

		if(panel == null)
			return

		let team = GameStateAPI.GetPlayerTeamName(xuid)
		let wash_color = TEAM_COLORS[team] || "#ffffffff"

		// panel.style.marginRight = entity_flair_panels[entindex].actuallayoutwidth < 4 ? "-25px" : "0px"

		for(i=0; i < 24; i++) {
			let panel_slot_parent = panel.FindChild(`weapon-${i}`)

			if(weapons && weapons[i]) {
				let weapon = weapons[i]
				let selected = weapon == selected_weapon
				panel_slot_parent.visible = true

				let slot_override = SLOT_OVERRIDE[weapon] || "small"

				let panel_slot
				panel_slot_parent.Children().forEach(function(el){
					if(el.id == slot_override){
						el.visible = true
						panel_slot = el
					} else {
						el.visible = false
					}
				})

				panel_slot.style.opacity = selected ? "0.85" : "0.35"

				let shadow_color = SHADOW_COLORS[team] || "#58534D"
				// shadow_color = "rgba(64, 64, 64, 0.1)"
				panel_slot.style.imgShadow = selected ? (shadow_color + " 0px 0px 3px 3.75") : "none"

				panel_slot.style.washColorFast = wash_color
				panel_slot.SetImage("file://{images}/icons/equipment/" + weapon + ".svg")
				// panel_slot.style.border = "1px solid red;"

				panel_slot.style.marginLeft = "-5px"
				panel_slot.style.marginRight = "-5px"

				if(weapon == "knife_ursus") {
					panel_slot.style.marginLeft = "-2px"
				} else if(weapon == "knife_widowmaker") {
					panel_slot.style.marginLeft = "-3px"
				} else if(weapon == "hkp2000") {
					panel_slot.style.marginRight = "-4px"
				} else if(weapon == "incgrenade") {
					panel_slot.style.marginLeft = "-6px"
				} else if(weapon == "flashbang") {
					panel_slot.style.marginLeft = "-5px"
				}

				panel_slot_parent.style.minWidth = MIN_WIDTHS[weapon] || "0px"
				panel_slot_parent.style.maxWidth = MAX_WIDTHS[weapon] || "1000px"
			} else if(panel_slot_parent.visible) {
				// $.Msg("removed!")
				panel_slot_parent.visible = false
				let panel_slot = panel_slot_parent.GetChild(0)
				panel_slot.style.opacity = "0.01"
			}
		}

		let panel_armor = panel.FindChild("armor")
		let panel_helmet = panel.FindChild("helmet")

		if(armor != null){
			panel_armor.visible = true
			panel_armor.style.washColorFast = wash_color

			if(armor == "helmet") {
				panel_armor.SetImage("file://{images}/icons/equipment/kevlar.svg")

				panel_helmet.visible = true
				panel_helmet.style.washColorFast = wash_color
			} else {
				panel_armor.SetImage("file://{images}/icons/equipment/" + armor + ".svg")
			}
		} else {
			panel_armor.visible = false
			panel_helmet.visible = false
		}

		return true
	}

	let _ApplyData = function() {
		for(entindex in entity_data) {
			entindex = parseInt(entindex)
			let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)

			if(!entity_data[entindex].applied || entity_panels[xuid] == null || !entity_panels[xuid].IsValid()) {
				if(_ApplyPlayer.apply(null, entity_data[entindex])) {
					// $.Msg("successfully appied for ", entindex)
					entity_data[entindex].applied = true
				}
			}
		}
	}

	let _EnablePlayingMatchHook = function() {
		if(GameStateAPI_IsLocalPlayerPlayingMatch_prev == null) {
			GameStateAPI_IsLocalPlayerPlayingMatch_prev = GameStateAPI.IsLocalPlayerPlayingMatch

			GameStateAPI.IsLocalPlayerPlayingMatch = function() {
				if(GameStateAPI.IsDemoOrHltv()) {
					return true
				}

				return GameStateAPI_IsLocalPlayerPlayingMatch_prev.call(GameStateAPI)
			}
		}
	}

	let _DisablePlayingMatchHook = function() {
		if(GameStateAPI_IsLocalPlayerPlayingMatch_prev != null) {
			GameStateAPI.IsLocalPlayerPlayingMatch = GameStateAPI_IsLocalPlayerPlayingMatch_prev
			GameStateAPI_IsLocalPlayerPlayingMatch_prev = null
		}
	}

	let _GetAllPlayers = function() {
		let result = []

		for(entindex=1; entindex <= 64; entindex++) {
			let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)

			if(xuid && xuid != "0") {
				result.push(xuid)
			}
		}

		return result
	}

	let _Create = function() {
		event_callbacks["OnOpenScoreboard"] = $.RegisterForUnhandledEvent("OnOpenScoreboard", _ApplyData)
		event_callbacks["Scoreboard_UpdateEverything"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateEverything", function(){
			// $.Msg("cleared applied data")
			for(entindex in entity_data) {
				// entity_data[entindex].applied = false
			}
			_ApplyData()
		})
		event_callbacks["Scoreboard_UpdateJob"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateJob", _ApplyData)
	}

	let _Clear = function() {
		entity_data = {}
	}

	let _Destroy = function() {
		// clear entity data
		_Clear()
		_DestroyEntityPanels()

		for(event in event_callbacks){
			$.UnregisterForUnhandledEvent(event, event_callbacks[event])

			delete event_callbacks[event]
		}

		// $.GetContextPanel().FindChildTraverse("TeamSmallContainerCT").style.width = "400px"
		// $.GetContextPanel().FindChildTraverse("TeamSmallContainerT").style.width = "400px"
	}

	return {
		create: _Create,
		set_min_max_width: _SetMinMaxWidth,
		destroy: _Destroy,
		clear: _Clear,
		update_player: _UpdatePlayer,
		enable_playing_match_hook: _EnablePlayingMatchHook,
		disable_playing_match_hook: _DisablePlayingMatchHook,
		get_all_players: _GetAllPlayers
	}
]], "CSGOHud")()

--
-- logic for sorting weapons
--

local sort_pos = {
	[csgo_weapons["weapon_hegrenade"]] = 10,
	[csgo_weapons["weapon_decoy"]] = csgo_weapons["weapon_molotov"].idx-1,
	[csgo_weapons["weapon_smokegrenade"]] = csgo_weapons["weapon_smokegrenade"].idx-1,
	[csgo_weapons["weapon_taser"]] = 3,
}

local name_add_weapon, name_add_max = {}, 0
for idx, weapon in pairs(csgo_weapons) do
	local name_add = string.byte(weapon.name)

	name_add_weapon[weapon] = name_add

	name_add_max = math.max(name_add, name_add_max)

	local name_panorama = weapon.console_name:gsub("^item_", ""):gsub("^weapon_", "")

	-- align pistols
	if weapon.type == "pistol" then
		js.set_min_max_width(name_panorama, "31px") -- 29px
	elseif weapon.type == "knife" and weapon ~= WEAPON_TASER then
		js.set_min_max_width(name_panorama, "45px", "45px",  "smaller")
	end
end

local js_update_player = js.update_player

-- fix knife icons
js.set_min_max_width("knife", nil, nil, "small")
js.set_min_max_width("knife_t", nil, nil, "small")
js.set_min_max_width("knife_widowmaker", nil, nil, "small")
js.set_min_max_width("knife_butterfly", nil, nil, "small")
js.set_min_max_width("knife_survival_bowie", nil, nil, "large")
js.set_min_max_width("knife_gut", nil, nil, "medium")
js.set_min_max_width("knife_karambit", nil, nil, "medium")
js.set_min_max_width("knife_ursus", nil, nil, "small")

js.set_min_max_width("hkp2000", nil, nil, "medium")

-- grenades
js.set_min_max_width("incgrenade", "12px")
js.set_min_max_width("smokegrenade", "9px")
js.set_min_max_width("flashbang", "9px", "12px")

for idx, weapon in pairs(csgo_weapons) do
	if sort_pos[weapon] == nil then
		local name_add = name_add_weapon[weapon] / name_add_max

		if weapon.type == "rifle" or weapon.type == "machinegun" or weapon.type == "sniperrifle" or weapon.type == "smg" or weapon.type == "shotgun" then
			sort_pos[weapon] = 0+name_add
		elseif weapon.type == "pistol" then
			sort_pos[weapon] = 1+name_add
		elseif weapon.type == "knife" or weapon.type == "fists" or weapon.type == "melee" then
			sort_pos[weapon] = 2+name_add
		else
			-- print(weapon.console_name, " ", weapon.type)
			sort_pos[weapon] = weapon.idx
		end
	end
end

local function sort_weapons_cb(a, b)
	local a_i = sort_pos[a] or a.idx
	local b_i = sort_pos[b] or b.idx

	return a_i < b_i
end

--
-- actual script logic
--

local enabled_prev = false
local safe_callbacks = {}

safe_callbacks.add = function(name, callback, r_function)
    name = callback.."|"..name or callback.."|".."unknown"
    local execute_callbacks = function(...)
        local succesfull, error_message = pcall(r_function, ...)
        
        if not succesfull then
            local all_error_messages = {
                ("Function name: %s!"):format(name),
                ("Error message - %s"):format(error_message)
            }
            --print(all_error_messages[2], all_error_messages[1])
			if enabled_prev then
				js.destroy()
			end
            engine.execute_cmd("play resource/warning.wav")

            error(all_error_messages[2] .. ' '..all_error_messages[1])
        end
    end

    callbacks.add(callback, execute_callbacks)
end

local menu_callbacks = {}

function menu.set_callback(item_type, name, item, func, cond)
	safe_callbacks.add("set_callback", e_callbacks.PAINT, function()
		if cond == nil then
			cond = function()
				return {
					first = true,
					second = true
				}
			end
		end

		if menu_callbacks[name] == nil then
			menu_callbacks[name] = {
				itmes = {}, data = {}, clicked_value = 0
			}
		end

		if item_type == "multi_selection" then
			if item ~= nil then
				local items = item:get_items()

				for key, value in ipairs(items) do
					if menu_callbacks[name].data[value] == nil then
						menu_callbacks[name].data[value] = 0
					end

					if item:get(value) and cond() then
						menu_callbacks[name].data[value] = math.min(#items, menu_callbacks[name].data[value] + 1)
					else
						menu_callbacks[name].data[value] = math.max(0, menu_callbacks[name].data[value] - 1)
					end

					if menu_callbacks[name].data[value] == 2 then
						func()
					end
				end
			end
		elseif item_type == "checkbox" then
			if item:get() and cond().first then
				menu_callbacks[name].clicked_value = math.min(3, menu_callbacks[name].clicked_value + 1)
			elseif not item:get() and cond().second then
				menu_callbacks[name].clicked_value = math.max(0, menu_callbacks[name].clicked_value - 1)
			end

			if menu_callbacks[name].clicked_value == 2 then
				func()
			end
		elseif item_type == "selection" or item_type == "list" or item_type == "slider" then
			local value = item:get()

			if menu_callbacks[name].clicked_value and menu_callbacks[name].clicked_value == value then
				goto skip
			end

			if cond().first then
				func()
			end

			menu_callbacks[name].clicked_value = value
			::skip::	
		end
	end)
end

local enabled_reference = menu.add_checkbox("Other ESP", "Display equipment on scoreboard")
local filter_reference = menu.add_multi_selection("Other ESP", "Scoreboard equipment filter", {"Primary", "Secondary", "Knife", "Taser", "Grenades", "Bomb", "Defuse Kit", "Armor", "Other"})
local enemy_only_reference = menu.add_checkbox("Other ESP", "Enemies only")

filter_reference:set("Primary", true) filter_reference:set("Secondary", true) filter_reference:set("Grenades", true) filter_reference:set("Bomb", true)

local player_data = {}
local filter_weapon_name = {}
local filter_armor_enabled = false
local enabled = false

local function filter_cb(weapon)
	return filter_weapon_name[weapon]
end

local function update_player_data(player)
	--print("update_player_data(", player:get_name(), ")")
	local current_player_data = player_data[player:get_index()]

	local ignore_teammate = enemy_only_reference:get() and not player:is_dormant() and not player:is_enemy()

	local player_scoreboard = player:get_index()
	--local player_resource = 
	if player_resource.get_prop("m_bControllingBot", player:get_index()) == 1 then
		player_scoreboard = player_resource.get_prop("m_iControlledPlayer", player:get_index())
		js_update_player(player:get_index(), nil, nil, nil)

		--print(player, " is controlling ", player_scoreboard)
	end

	if current_player_data == nil or ignore_teammate then
		js_update_player(player_scoreboard, nil, nil, nil)
	else
		js_update_player(
			player_scoreboard,
			current_player_data.weapons and table_map_filter(current_player_data.weapons, filter_cb) or nil,
			current_player_data.active_weapon and filter_weapon_name[current_player_data.active_weapon] or nil,
			filter_armor_enabled and current_player_data.armor or nil
		)
	end
end

local function update_filters()
	table_clear(filter_weapon_name)

	if not engine.is_in_game() then
        return
    end

	if enabled_reference:get() then
		--local filters_enabled = table_map_assoc({filter_reference:get_value()}, function(i, typ) return typ, true end)
		
		filter_armor_enabled = filter_reference:get("Armor")

		local team
		local local_player = entity_list.get_local_player()
		if local_player:is_valid() then
			team = local_player:get_prop("m_iTeamNum")
		end
		
		for idx, weapon in pairs(csgo_weapons) do
			local include = false

			-- print(weapon.console_name, ": ", weapon.type)

			if weapon.type == "rifle" or weapon.type == "machinegun" or weapon.type == "sniperrifle" or weapon.type == "smg" or weapon.type == "shotgun" then
				include = filter_reference:get("Primary")
			elseif weapon.type == "pistol" then
				include = filter_reference:get("Secondary")
			elseif weapon == WEAPON_TASER then
				include = filter_reference:get("Taser")
			elseif weapon.type == "c4" then
				include = team ~= TEAM_T and filter_reference:get("Bomb")
			elseif weapon == ITEM_CUTTERS or weapon == ITEM_DEFUSER then
				include = team ~= TEAM_CT and filter_reference:get("Defuse Kit")
			elseif weapon.type == "knife" or weapon.type == "fists" or weapon.type == "melee" then
				include = filter_reference:get("Knife")
			elseif weapon.type == "grenade" or weapon.type == "breachcharge" then
				include = filter_reference:get("Grenades")
			elseif weapon ~= ITEM_ASSAULTSUIT and weapon ~= ITEM_KEVLAR and weapon ~= ITEM_HEAVYASSAULTSUIT then
				include = filter_reference:get("Other")
			end

			if include then
				filter_weapon_name[weapon] = weapon.console_name:gsub("^item_", ""):gsub("^weapon_", "")
			end
		end

		for player, data in pairs(player_data) do
			update_player_data(entity_list.get_entity(player))
		end
	end
end

--
-- event callbacks
--

local function on_paint()
	if not engine.is_in_game() then return end
	if not enabled then return end

	--local player_resource = get_player_resource()
	local free_kevlar = cvars.mp_free_armor:get_int() > 0
	local free_helmet = cvars.mp_free_armor:get_int() > 1
	local free_defuser = cvars.mp_defuser_allocation:get_int() >= 2

	local players = entity_list.get_entities_by_name("CCSPlayer")
    if players == nil then return end
    for i=1, #players do
        local player = players[i]
		if player:is_player() then
			local current_player_data
			if not player:is_dormant() then
				if player:is_valid() then
					current_player_data = {
						weapons = {}
					}

					local active_weapon = get_player_weapon(player)

					if active_weapon ~= nil then
						if not free_defuser and player:get_prop("m_bHasDefuser") == 1 then
							table.insert(current_player_data.weapons, ITEM_DEFUSER)
						end
						
						for slot=0, 63 do
							local weapon_ent = player:get_prop("m_hMyWeapons", slot)

							if weapon_ent == -1 then goto skip end
							weapon_ent = entity_list.get_entity(weapon_ent)
							if weapon_ent == nil then goto skip end
							local weapon = csgo_weapons[bit.band(weapon_ent:get_prop("m_iItemDefinitionIndex"), 0xFFFF)]

							table.insert(current_player_data.weapons, weapon)

							if weapon_ent:get_index() == active_weapon:get_index() then
								current_player_data.active_weapon = weapon
							end
						end
						::skip::
						table.sort(current_player_data.weapons, sort_weapons_cb)
					end
				else
					current_player_data = nil
				end
			else
				current_player_data = player_data[player:get_index()]
			end
			
			if current_player_data ~= nil then
				if player_resource.get_prop("m_iArmor", player:get_index()) > 0 then
					if player_resource.get_prop("m_bHasHelmet", player:get_index()) == 1 then
						if not free_helmet then
							current_player_data.armor = "helmet"
						end
					elseif not free_kevlar then
						current_player_data.armor = "kevlar"
					end
				else
					current_player_data.armor = nil
				end
			end
			
			if (player_data[player:get_index()] == nil and current_player_data ~= nil) or (current_player_data == nil and player_data[player:get_index()] ~= nil) or (current_player_data ~= nil and player_data[player:get_index()] ~= nil and not deep_compare(current_player_data, player_data[player:get_index()])) then
				player_data[player:get_index()] = current_player_data

				update_player_data(player)
			end
		end
	end
end
safe_callbacks.add("on_paint", e_callbacks.PAINT, on_paint)

local function on_shutdown()
	if enabled_prev then
		js.destroy()
	end
end

safe_callbacks.add("on_shutdown", e_callbacks.SHUTDOWN, on_shutdown)

local function on_level_init(e)
	if e.name ~= 'switch_team' then return end
	table_clear(player_data)
	js.clear()
end
safe_callbacks.add("on_level_init", e_callbacks.EVENT, on_level_init)
local function on_player_team(e)
	if e.name ~= 'player_team' then return end
	local player = entity_list.get_player_from_userid(e.userid)
	if player == nil or entity_list.get_local_player() == nil then return end
	if player == entity_list.get_local_player() then
		client.delay_call(update_filters, 0.1)
	elseif e.userid > 0 then
		-- update_filters will already call update_player_data for everyone
		update_player_data(player)
	end
end
safe_callbacks.add("on_player_team", e_callbacks.EVENT, on_player_team)
--
-- game event callbacks for dormant data
--

local function on_player_disconnect(e)
	if e.name ~= 'player_disconnect' then return end
	local userid = entity_list.get_player_from_userid(e.userid)
	if userid == nil then return end
	client.delay_call(function()
		local player = userid
	
		player_data[player:get_index()] = nil
	
		update_player_data(player)
	end, 0.1)
end
safe_callbacks.add("on_player_disconnect", e_callbacks.EVENT, on_player_disconnect)
local function on_player_death(e)
	if e.name ~= 'player_death' then return end
	local userid = entity_list.get_player_from_userid(e.userid)
	if userid == nil then return end
	client.delay_call(function()
		local player = userid

		if player_data[player:get_index()] ~= nil and player:is_dormant() then
			player_data[player:get_index()] = nil

			update_player_data(player)
		end
	end, 0.1)
end
safe_callbacks.add("on_player_death", e_callbacks.EVENT, on_player_death)
local function on_player_spawn(e)
	if e.name ~= 'player_spawn' then return end
	local userid = entity_list.get_player_from_userid(e.userid)
	if userid == nil then return end
	client.delay_call(function()
		local player = userid

		if player_data[player:get_index()] == nil then
			player_data[player:get_index()] = {
				weapons = {}
			}
		elseif player_data[player:get_index()].weapons ~= nil then
			table_remove_item(player_data[player:get_index()].weapons, WEAPON_C4)
		end

		update_player_data(player)
	end, 0.1)
end
safe_callbacks.add("on_player_spawn", e_callbacks.EVENT, on_player_spawn)
local function on_item_remove(e)
	if e.name ~= 'item_remove' then return end
	local userid = entity_list.get_player_from_userid(e.userid)
	if userid == nil then return end
	local defindex = e.defindex
	client.delay_call(function()
		local player = userid
		local weapon = EVENT_IDX_TO_WEAPON[defindex]

		if player_data[player:get_index()] ~= nil and player:is_dormant() and weapon then
			if weapon ~= ITEM_KEVLAR and weapon ~= ITEM_ASSAULTSUIT then
				table_remove_item(player_data[player:get_index()].weapons, weapon)

				update_player_data(player)
			end
		end
	end, 0.1)
end
safe_callbacks.add("on_item_remove", e_callbacks.EVENT, on_item_remove)
local function on_item_pickup(e)
	if e.name ~= 'item_pickup' then return end
	local userid = entity_list.get_player_from_userid(e.userid)
	if userid == nil then return end
	local defindex = e.defindex
	client.delay_call(function()
		local player = userid
		local weapon = EVENT_IDX_TO_WEAPON[defindex]

		if player_data[player:get_index()] ~= nil and player:is_dormant() and weapon then
			if weapon == ITEM_KEVLAR or weapon == ITEM_ASSAULTSUIT then
				local free_kevlar = cvars.mp_free_armor:get_int() > 0
				local free_helmet = cvars.mp_free_armor:get_int() > 1

				if weapon == ITEM_KEVLAR then
					if not free_helmet and player_data[player:get_index()].armor == nil then
						player_data[player:get_index()].armor = "kevlar"
					end
				elseif not free_kevlar then
					player_data[player:get_index()].armor = "helmet"
				end
			elseif (weapon == ITEM_CUTTERS or weapon == ITEM_DEFUSER) and cvars.mp_defuser_allocation:get_int() >= 2 then
				return
			elseif not table_contains(player_data[player:get_index()].weapons, weapon) then
				table.insert(player_data[player:get_index()].weapons, weapon)
				table.sort(player_data[player:get_index()].weapons, sort_weapons_cb)

				update_player_data(player)
			end
		end
	end, 0.1)
end
safe_callbacks.add("on_item_pickup", e_callbacks.EVENT, on_item_pickup)
local function on_item_equip(e)
	if e.name ~= 'item_equip' then return end
	local userid = entity_list.get_player_from_userid(e.userid)
	if userid == nil then return end
	local defindex = e.defindex
	client.delay_call(function()
		local player = userid
		local weapon = EVENT_IDX_TO_WEAPON[defindex]

		if player_data[player:get_index()] ~= nil and player:is_dormant() and weapon then
			player_data[player:get_index()].active_weapon = weapon

			update_player_data(player)
		end
	end, 0.1)
end
safe_callbacks.add("on_item_equip", e_callbacks.EVENT, on_item_equip)
local function on_bot_takeover(e)
	if e.name ~= 'bot_takeover' then return end
	local userid = entity_list.get_player_from_userid(e.userid)
	if userid == nil then return end
	local botid = e.botid
	
	client.delay_call(function()
		local player = userid
		local bot = entity_list.get_player_from_userid(botid)
		if bot == nil then return end
		--local player_resource = get_player_resource()
		player_resource.set_prop("m_bControllingBot", 1, player)
		player_resource.set_prop("m_iControlledPlayer", bot, player)

		-- print("takeover -> update_player_data")

		update_player_data(bot)
		update_player_data(player)
	end, 0.1)
end
safe_callbacks.add("on_bot_takeover", e_callbacks.EVENT, on_bot_takeover)
local function on_enabled_changed()
	enabled = enabled_reference:get()

	filter_reference:set_visible(enabled)
	enemy_only_reference:set_visible(enabled)

	if enabled and not enabled_prev then
		update_filters()
		js.create()
	elseif not enabled and enabled_prev then
		table_clear(player_data)
		table_clear(filter_weapon_name)
		js.destroy()
	end

	enabled_prev = enabled
end
menu.set_callback("checkbox", "enemy_only_reference", enemy_only_reference, function()
	for player, value in pairs(player_data) do
		if not entity_list.get_entity(player):is_dormant() and not entity_list.get_entity(player):is_enemy() then
			player_data[entity_list.get_entity(player):get_index()] = nil
		end
	end
end)

menu.set_callback("multi_selection", "filter_reference", filter_reference, update_filters)
menu.set_callback("checkbox", "enabled_reference", enabled_reference, on_enabled_changed)
on_enabled_changed()