-- filename: 
-- version: lua51
-- line: [0, 0] id: 0
local r0_0 = getfenv(0)
setfenv(0, r0_0)
if tostring(r0_0) ~= "table: NULL" then
  error("Redownload loader #1001")
end
local r1_0 = require("ffi") or error("toggle unsafe scripts")
local r2_0 = require("bit") or error("no bit lib")
local r3_0 = require("gamesense/base64")
local r4_0 = "Celestia"
local r5_0 = false
local r7_0 = {}
r7_0.zalupa = false
_G.cycek = r7_0
local r6_0 = {}
r6_0.username = ""
r6_0.password = ""
r6_0.discordid = ""
r7_0 = {}
r7_0.autoload = ""
function encode(r0_9, r1_9)
  -- line: [0, 0] id: 9
  local r2_9 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=_:"
  local r3_9 = #r2_9
  for r7_9 = 1, r3_9, 1 do
    if r0_9 == r2_9:sub(r7_9, r7_9) then
      local r8_9 = (r7_9 + r1_9 - 1) % r3_9 + 1
      return r2_9:sub(r8_9, r8_9)
    end
  end
end
function encode_string(r0_10, r1_10)
  -- line: [0, 0] id: 10
  local r2_10 = ""
  local r3_10 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=_:"
  for r7_10 = 1, #r0_10, 1 do
    local r8_10 = r0_10:sub(r7_10, r7_10)
    if r8_10 ~= " " then
      r2_10 = r2_10 .. encode(r8_10, r1_10)
    else
      r2_10 = r2_10 .. " "
    end
  end
  return r2_10
end
function decode(r0_11, r1_11)
  -- line: [0, 0] id: 11
  local r2_11 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=_:"
  local r3_11 = #r2_11
  for r7_11 = 1, r3_11, 1 do
    if r0_11 == r2_11:sub(r7_11, r7_11) then
      local r8_11 = (r7_11 - r1_11 - 1 + r3_11) % r3_11 + 1
      return r2_11:sub(r8_11, r8_11)
    end
  end
  return r0_11
end
function decode_string(r0_12, r1_12)
  -- line: [0, 0] id: 12
  local r2_12 = ""
  local r3_12 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=_:"
  for r7_12 = 1, #r0_12, 1 do
    local r8_12 = r0_12:sub(r7_12, r7_12)
    if r8_12 ~= " " then
      r2_12 = r2_12 .. decode(r8_12, r1_12)
    else
      r2_12 = r2_12 .. " "
    end
  end
  return r2_12
end
local r8_0 = {
  "bit",
  "client",
  "config",
  "cvar",
  "database",
  "entity",
  "globals",
  "json",
  "panorama",
  "materialsystem",
  "renderer",
  "plist",
  "ui",
  "loadstring",
  "tostring",
  "load",
  "setmetatable",
  "getmetatable",
  "getfenv",
  "pcall",
  "require",
  "xpcall",
  "print",
  "http",
  "hardwareid",
  "websocket",
  "base64",
  "drivername",
  "adapter",
  "hash",
  "encoder",
  "decoder",
  "hwid"
}
local r9_0 = r1_0.typeof("    struct {\n        char __m_pDriverName[512];\n        unsigned int __m_VendorID;\n        unsigned int __m_DeviceID;\n        unsigned int __m_SubSysID;\n        unsigned int __m_Revision;\n        int __m_nDXSupportLevel;\n        int __m_nMinDXSupportLevel;\n        int __m_nMaxDXSupportLevel;\n        unsigned int __m_nDriverVersionHigh;\n        unsigned int __m_nDriverVersionLow;\n        int64_t pad_0;\n    }\n")
local r10_0 = {}
r10_0.__index = {}
local r11_0 = vtable_bind("materialsystem.dll", "VMaterialSystem080", 25, "int(__thiscall*)(void*)")
local r12_0 = vtable_bind("materialsystem.dll", "VMaterialSystem080", 26, "void(__thiscall*)(void*, int, $*)", r9_0)
function get_current_adapter()
  -- line: [0, 0] id: 13
  return r11_0()
end
local r13_0 = {}
function r13_0.drivername(r0_14)
  -- line: [0, 0] id: 14
  return r1_0.string(r0_14.__m_pDriverName)
end
function r13_0.vendorid(r0_15)
  -- line: [0, 0] id: 15
  return string.format("%X", r0_15.__m_VendorID)
end
function r13_0.deviceid(r0_16)
  -- line: [0, 0] id: 16
  return string.format("%X", r0_16.__m_DeviceID)
end
function r13_0.subsysid(r0_17)
  -- line: [0, 0] id: 17
  return string.format("%X", r0_17.__m_SubSysID)
end
function r13_0.revision(r0_18)
  -- line: [0, 0] id: 18
  return string.format("%X", r0_18.__m_Revision)
end
function r13_0.dxsupportlevel(r0_19)
  -- line: [0, 0] id: 19
  return r0_19.__m_nDXSupportLevel
end
function r13_0.mindxsupportlevel(r0_20)
  -- line: [0, 0] id: 20
  return r0_20.__m_nMinDXSupportLevel
end
function r13_0.maxdxsupportlevel(r0_21)
  -- line: [0, 0] id: 21
  return r0_21.__m_nMaxDXSupportLevel
end
function r13_0.driverversionhigh(r0_22)
  -- line: [0, 0] id: 22
  return r0_22.__m_nDriverVersionHigh
end
function r13_0.driverversionlow(r0_23)
  -- line: [0, 0] id: 23
  return r0_23.__m_nDriverVersionLow
end
function r10_0.__index(r0_24, r1_24)
  -- line: [0, 0] id: 24
  if not r13_0[r1_24] then
    return nil
  end
  return r13_0[r1_24](r0_24)
end
r1_0.metatype(r9_0, r10_0)
function get_adapter_info(r0_25)
  -- line: [0, 0] id: 25
  local r1_25 = r9_0()
  r12_0(r0_25, r1_25)
  return r1_25
end
local r15_0 = get_adapter_info(get_current_adapter())
local r17_0 = r3_0.encode(encode_string(string.format("%s:%s:%s:%s", r15_0.vendorid, r15_0.deviceid, r15_0.subsysid, r15_0.drivername), 60))
local r18_0 = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 0, "int(__thiscall*)(void* _this, void* buf, int size, void* hFile)")
local r19_0 = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 2, "void*(__thiscall*)(void* _this, const char* path, const char* mode, const char* base)")
local r20_0 = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 3, "void(__thiscall*)(void* _this, void* hFile)")
local r21_0 = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 7, "unsigned int(__thiscall*)(void* _this, void* hFile)")
local function r22_0(r0_26)
  -- line: [0, 0] id: 26
  local r1_26 = r19_0(r0_26, "r", "GAME")
  local r2_26 = false
  if r1_26 and 0 < r21_0(r1_26) then
    r2_26 = true
  end
  return r2_26
end
local function r23_0(r0_27)
  -- line: [0, 0] id: 27
  local r1_27 = r19_0(r0_27, "r", "GAME")
  if r1_27 then
    local r2_27 = r21_0(r1_27)
    local r3_27 = r1_0.new("char[?]", r2_27 + 1)
    local r4_27 = {}
    function r4_27.get()
      -- line: [0, 0] id: 28
      local r0_28 = r18_0(r3_27, r2_27, r1_27) and r1_0.string(r3_27, r2_27)
      if not r0_28 then
        r0_28 = nil
      end
      return r0_28
    end
    function r4_27.free()
      -- line: [0, 0] id: 29
      r20_0(r1_27)
    end
    return r4_27
  end
end
if _NAME == nil then
  error("Redownload loader #1002")
end
local r24_0 = assert
local r25_0 = pcall
local r26_0 = xpcall
local r27_0 = error
local r28_0 = setmetatable
local r29_0 = tostring
local r30_0 = tonumber
local r31_0 = type
local r32_0 = pairs
local r33_0 = ipairs
local r34_0 = client.log
local r35_0 = client.delay_call
local r36_0 = ui.get
local r37_0 = string.format
local r38_0 = r1_0.typeof
local r39_0 = r1_0.sizeof
local r40_0 = r1_0.cast
local r41_0 = r1_0.cdef
local r42_0 = r1_0.string
local r43_0 = r1_0.gc
local r44_0 = string.lower
local r45_0 = string.len
local r46_0 = string.find
local r47_0 = {}
function r47_0.kurwachuj()
  -- line: [0, 0] id: 30
  if not r25_0(r1_0.sizeof, "SteamAPICall_t") then
    r41_0("    typedef uint64_t SteamAPICall_t;\n\n    struct SteamAPI_callback_base_vtbl {\n        void(__thiscall *run1)(struct SteamAPI_callback_base *, void *, bool, uint64_t);\n        void(__thiscall *run2)(struct SteamAPI_callback_base *, void *);\n        int(__thiscall *get_size)(struct SteamAPI_callback_base *);\n    };\n\n    struct SteamAPI_callback_base {\n        struct SteamAPI_callback_base_vtbl *vtbl;\n        uint8_t flags;\n        int id;\n        uint64_t api_call_handle;\n        struct SteamAPI_callback_base_vtbl vtbl_storage[1];\n    };\n")
  end
  local r3_30 = {}
  r3_30[-1] = "No failure"
  r3_30[0] = "Steam gone"
  r3_30[1] = "Network failure"
  r3_30[2] = "Invalid handle"
  r3_30[3] = "Mismatched callback"
  local r4_30 = nil
  local r5_30 = nil
  local r6_30 = nil
  local r7_30 = nil
  local r8_30 = nil
  local r9_30 = r38_0("struct SteamAPI_callback_base")
  local r10_30 = r39_0(r9_30)
  local r11_30 = r38_0("struct SteamAPI_callback_base[1]")
  local r12_30 = r38_0("struct SteamAPI_callback_base*")
  local r13_30 = r38_0("uintptr_t")
  local r14_30 = {}
  local r15_30 = {}
  local r16_30 = {}
  local function r17_30(r0_31)
    -- line: [0, 0] id: 31
    return r29_0(r30_0(r40_0(r13_30, r0_31)))
  end
  local function r18_30(r0_32, r1_32, r2_32)
    -- line: [0, 0] id: 32
    if r2_32 then
      r2_32 = r3_30[r8_30(r0_32.api_call_handle)] or "Unknown error"
    end
    r0_32.api_call_handle = 0
    r26_0(function()
      -- line: [0, 0] id: 33
      local r0_33 = r17_30(r0_32)
      local r1_33 = r14_30[r0_33]
      if r1_33 ~= nil then
        r26_0(r1_33, client.error_log, r1_32, r2_32)
      end
      if r15_30[r0_33] ~= nil then
        r14_30[r0_33] = nil
        r15_30[r0_33] = nil
      end
    end, client.error_log)
  end
  local function r19_30(r0_34, r1_34, r2_34, r3_34)
    -- line: [0, 0] id: 34
    if r3_34 == r0_34.api_call_handle then
      r18_30(r0_34, r1_34, r2_34)
    end
  end
  local function r20_30(r0_35, r1_35)
    -- line: [0, 0] id: 35
    r18_30(r0_35, r1_35, false)
  end
  local function r21_30(r0_36)
    -- line: [0, 0] id: 36
    return r10_30
  end
  local function r22_30(r0_37)
    -- line: [0, 0] id: 37
    if r0_37.api_call_handle ~= 0 then
      r5_30(r0_37, r0_37.api_call_handle)
      r0_37.api_call_handle = 0
      local r1_37 = r17_30(r0_37)
      r14_30[r1_37] = nil
      r15_30[r1_37] = nil
    end
  end
  local r26_30 = {}
  r26_30.__gc = r22_30
  local r27_30 = {}
  r27_30.cancel = r22_30
  r26_30.__index = r27_30
  r25_0(r1_0.metatype, r9_30, r26_30)
  local r23_30 = r40_0("void(__thiscall *)(struct SteamAPI_callback_base *, void *, bool, uint64_t)", r19_30)
  local r24_30 = r40_0("void(__thiscall *)(struct SteamAPI_callback_base *, void *)", r20_30)
  local r25_30 = r40_0("int(__thiscall *)(struct SteamAPI_callback_base *)", r21_30)
  local function r0_30(r0_38, r1_38, r2_38)
    -- line: [0, 0] id: 38
    r24_0(r0_38 ~= 0)
    local r3_38 = r11_30()
    local r4_38 = r40_0(r12_30, r3_38)
    r4_38.vtbl_storage[0].run1 = r23_30
    r4_38.vtbl_storage[0].run2 = r24_30
    r4_38.vtbl_storage[0].get_size = r25_30
    r4_38.vtbl = r4_38.vtbl_storage
    r4_38.api_call_handle = r0_38
    r4_38.id = r2_38
    local r5_38 = r17_30(r4_38)
    r14_30[r5_38] = r1_38
    r15_30[r5_38] = r3_38
    r4_30(r4_38, r0_38)
    return r4_38
  end
  local function r1_30(r0_39, r1_39)
    -- line: [0, 0] id: 39
    r24_0(r16_30[r0_39] == nil)
    local r2_39 = r11_30()
    local r3_39 = r40_0(r12_30, r2_39)
    r3_39.vtbl_storage[0].run1 = r23_30
    r3_39.vtbl_storage[0].run2 = r24_30
    r3_39.vtbl_storage[0].get_size = r25_30
    r3_39.vtbl = r3_39.vtbl_storage
    r3_39.api_call_handle = 0
    r3_39.id = r0_39
    r14_30[r17_30(r3_39)] = r1_39
    r16_30[r0_39] = r2_39
    r6_30(r3_39, r0_39)
  end
  function r26_30(r0_40, r1_40, r2_40, r3_40, r4_40)
    -- line: [0, 0] id: 40
    local r6_40 = r40_0("uintptr_t", client.find_signature(r0_40, r1_40) or r27_0("signature not found", 2))
    if r3_40 ~= nil and r3_40 ~= 0 then
      r6_40 = r6_40 + r3_40
    end
    if r4_40 ~= nil then
      for r10_40 = 1, r4_40, 1 do
        r6_40 = r40_0("uintptr_t*", r6_40)[0]
        if r6_40 == nil then
          return r27_0("signature not found")
        end
      end
    end
    return r40_0(r2_40, r6_40)
  end
  r4_30 = r26_30("steam_api.dll", "U\x8b\xec\x83=\xcc\xcc\xcc\xcc\xcc~\rh\xcc\xcc\xcc\xcc\xff\u{15}\xcc\xcc\xcc\xcc]\xc3\xffu\u{10}", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
  r5_30 = r26_30("steam_api.dll", "U\x8b\xec\xffu\u{10}\xffu\u{c}", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
  r6_30 = r26_30("steam_api.dll", "U\x8b\xec\x83=\xcc\xcc\xcc\xcc\xcc~\rh\xcc\xcc\xcc\xcc\xff\u{15}\xcc\xcc\xcc\xcc]\xc3\xc7\u{5}", "void(__cdecl*)(struct SteamAPI_callback_base *, int)")
  local r2_30 = r26_30("client_panorama.dll", "\xb9\xcc\xcc\xcc\xcc\xe8\xcc\xcc\xcc\u{303}=\xcc\xcc\xcc\xcc\xcc\u{f}\x84", "uintptr_t", 1, 1)
  local r28_30 = r40_0("uintptr_t*", r2_30)[3]
  local r29_30 = (function(r0_41, r1_41, r2_41)
    -- line: [0, 0] id: 41
    return r40_0(r2_41, r40_0("void***", r0_41)[0][r1_41])
  end)(r28_30, 12, "int(__thiscall*)(void*, SteamAPICall_t)")
  function r8_30(r0_42)
    -- line: [0, 0] id: 42
    return r29_30(r28_30, r0_42)
  end
  client.set_event_callback("shutdown", function()
    -- line: [0, 0] id: 43
    for r3_43, r4_43 in r32_0(r15_30) do
      r22_30(r40_0(r12_30, r4_43))
    end
    for r3_43, r4_43 in r32_0(r16_30) do
      local r5_43 = r40_0(r12_30, r4_43)
    end
  end)
  -- close: r3_30
  r3_30 = r25_0
  r4_30 = r39_0
  r5_30 = "http_HTTPRequestHandle"
  r3_30 = r3_30(r4_30, r5_30)
  if not r3_30 then
    r3_30 = r41_0
    r4_30 = "typedef uint32_t http_HTTPRequestHandle;\ntypedef uint32_t http_HTTPCookieContainerHandle;\n\nenum http_EHTTPMethod {\n    k_EHTTPMethodInvalid,\n    k_EHTTPMethodGET,\n    k_EHTTPMethodHEAD,\n    k_EHTTPMethodPOST,\n    k_EHTTPMethodPUT,\n    k_EHTTPMethodDELETE,\n    k_EHTTPMethodOPTIONS,\n    k_EHTTPMethodPATCH,\n};\n\nstruct http_ISteamHTTPVtbl {\n    http_HTTPRequestHandle(__thiscall *CreateHTTPRequest)(uintptr_t, enum http_EHTTPMethod, const char *);\n    bool(__thiscall *SetHTTPRequestContextValue)(uintptr_t, http_HTTPRequestHandle, uint64_t);\n    bool(__thiscall *SetHTTPRequestNetworkActivityTimeout)(uintptr_t, http_HTTPRequestHandle, uint32_t);\n    bool(__thiscall *SetHTTPRequestHeaderValue)(uintptr_t, http_HTTPRequestHandle, const char *, const char *);\n    bool(__thiscall *SetHTTPRequestGetOrPostParameter)(uintptr_t, http_HTTPRequestHandle, const char *, const char *);\n    bool(__thiscall *SendHTTPRequest)(uintptr_t, http_HTTPRequestHandle, SteamAPICall_t *);\n    bool(__thiscall *SendHTTPRequestAndStreamResponse)(uintptr_t, http_HTTPRequestHandle, SteamAPICall_t *);\n    bool(__thiscall *DeferHTTPRequest)(uintptr_t, http_HTTPRequestHandle);\n    bool(__thiscall *PrioritizeHTTPRequest)(uintptr_t, http_HTTPRequestHandle);\n    bool(__thiscall *GetHTTPResponseHeaderSize)(uintptr_t, http_HTTPRequestHandle, const char *, uint32_t *);\n    bool(__thiscall *GetHTTPResponseHeaderValue)(uintptr_t, http_HTTPRequestHandle, const char *, uint8_t *, uint32_t);\n    bool(__thiscall *GetHTTPResponseBodySize)(uintptr_t, http_HTTPRequestHandle, uint32_t *);\n    bool(__thiscall *GetHTTPResponseBodyData)(uintptr_t, http_HTTPRequestHandle, uint8_t *, uint32_t);\n    bool(__thiscall *GetHTTPStreamingResponseBodyData)(uintptr_t, http_HTTPRequestHandle, uint32_t, uint8_t *, uint32_t);\n    bool(__thiscall *ReleaseHTTPRequest)(uintptr_t, http_HTTPRequestHandle);\n    bool(__thiscall *GetHTTPDownloadProgressPct)(uintptr_t, http_HTTPRequestHandle, float *);\n    bool(__thiscall *SetHTTPRequestRawPostBody)(uintptr_t, http_HTTPRequestHandle, const char *, uint8_t *, uint32_t);\n    http_HTTPCookieContainerHandle(__thiscall *CreateCookieContainer)(uintptr_t, bool);\n    bool(__thiscall *ReleaseCookieContainer)(uintptr_t, http_HTTPCookieContainerHandle);\n    bool(__thiscall *SetCookie)(uintptr_t, http_HTTPCookieContainerHandle, const char *, const char *, const char *);\n    bool(__thiscall *SetHTTPRequestCookieContainer)(uintptr_t, http_HTTPRequestHandle, http_HTTPCookieContainerHandle);\n    bool(__thiscall *SetHTTPRequestUserAgentInfo)(uintptr_t, http_HTTPRequestHandle, const char *);\n    bool(__thiscall *SetHTTPRequestRequiresVerifiedCertificate)(uintptr_t, http_HTTPRequestHandle, bool);\n    bool(__thiscall *SetHTTPRequestAbsoluteTimeoutMS)(uintptr_t, http_HTTPRequestHandle, uint32_t);\n    bool(__thiscall *GetHTTPRequestWasTimedOut)(uintptr_t, http_HTTPRequestHandle, bool *pbWasTimedOut);\n};\n"
    r3_30(r4_30)
  end
  r3_30 = {}
  r4_30 = r1_0
  r4_30 = r4_30.C
  r4_30 = r4_30.k_EHTTPMethodGET
  r3_30.get = r4_30
  r4_30 = r1_0
  r4_30 = r4_30.C
  r4_30 = r4_30.k_EHTTPMethodHEAD
  r3_30.head = r4_30
  r4_30 = r1_0
  r4_30 = r4_30.C
  r4_30 = r4_30.k_EHTTPMethodPOST
  r3_30.post = r4_30
  r4_30 = r1_0
  r4_30 = r4_30.C
  r4_30 = r4_30.k_EHTTPMethodPUT
  r3_30.put = r4_30
  r4_30 = r1_0
  r4_30 = r4_30.C
  r4_30 = r4_30.k_EHTTPMethodDELETE
  r3_30.delete = r4_30
  r4_30 = r1_0
  r4_30 = r4_30.C
  r4_30 = r4_30.k_EHTTPMethodOPTIONS
  r3_30.options = r4_30
  r4_30 = r1_0
  r4_30 = r4_30.C
  r4_30 = r4_30.k_EHTTPMethodPATCH
  r3_30.patch = r4_30
  r4_30 = {}
  r4_30[100] = "Continue"
  r4_30[101] = "Switching Protocols"
  r4_30[102] = "Processing"
  r4_30[200] = "OK"
  r4_30[201] = "Created"
  r4_30[202] = "Accepted"
  r4_30[203] = "Non-Authoritative Information"
  r4_30[204] = "No Content"
  r4_30[205] = "Reset Content"
  r4_30[206] = "Partial Content"
  r4_30[207] = "Multi-Status"
  r4_30[208] = "Already Reported"
  r4_30[250] = "Low on Storage Space"
  r4_30[226] = "IM Used"
  r4_30[300] = "Multiple Choices"
  r4_30[301] = "Moved Permanently"
  r4_30[302] = "Found"
  r4_30[303] = "See Other"
  r4_30[304] = "Not Modified"
  r4_30[305] = "Use Proxy"
  r4_30[306] = "Switch Proxy"
  r4_30[307] = "Temporary Redirect"
  r4_30[308] = "Permanent Redirect"
  r4_30[400] = "Bad Request"
  r4_30[401] = "Unauthorized"
  r4_30[402] = "Payment Required"
  r4_30[403] = "Forbidden"
  r4_30[404] = "Not Found"
  r4_30[405] = "Method Not Allowed"
  r4_30[406] = "Not Acceptable"
  r4_30[407] = "Proxy Authentication Required"
  r4_30[408] = "Request Timeout"
  r4_30[409] = "Conflict"
  r4_30[410] = "Gone"
  r4_30[411] = "Length Required"
  r4_30[412] = "Precondition Failed"
  r4_30[413] = "Request Entity Too Large"
  r4_30[414] = "Request-URI Too Long"
  r4_30[415] = "Unsupported Media Type"
  r4_30[416] = "Requested Range Not Satisfiable"
  r4_30[417] = "Expectation Failed"
  r4_30[418] = "I\'m a teapot"
  r4_30[420] = "Enhance Your Calm"
  r4_30[422] = "Unprocessable Entity"
  r4_30[423] = "Locked"
  r4_30[424] = "Failed Dependency"
  r4_30[424] = "Method Failure"
  r4_30[425] = "Unordered Collection"
  r4_30[426] = "Upgrade Required"
  r4_30[428] = "Precondition Required"
  r4_30[429] = "Too Many Requests"
  r4_30[431] = "Request Header Fields Too Large"
  r4_30[444] = "No Response"
  r4_30[449] = "Retry With"
  r4_30[450] = "Blocked by Windows Parental Controls"
  r4_30[451] = "Parameter Not Understood"
  r4_30[451] = "Unavailable For Legal Reasons"
  r4_30[451] = "Redirect"
  r4_30[452] = "Conference Not Found"
  r4_30[453] = "Not Enough Bandwidth"
  r4_30[454] = "Session Not Found"
  r4_30[455] = "Method Not Valid in This State"
  r4_30[456] = "Header Field Not Valid for Resource"
  r4_30[457] = "Invalid Range"
  r4_30[458] = "Parameter Is Read-Only"
  r4_30[459] = "Aggregate Operation Not Allowed"
  r4_30[460] = "Only Aggregate Operation Allowed"
  r4_30[461] = "Unsupported Transport"
  r4_30[462] = "Destination Unreachable"
  r4_30[494] = "Request Header Too Large"
  r4_30[495] = "Cert Error"
  r4_30[496] = "No Cert"
  r4_30[497] = "HTTP to HTTPS"
  r4_30[499] = "Client Closed Request"
  r4_30[500] = "Internal Server Error"
  r4_30[501] = "Not Implemented"
  r4_30[502] = "Bad Gateway"
  r4_30[503] = "Service Unavailable"
  r4_30[504] = "Gateway Timeout"
  r4_30[505] = "HTTP Version Not Supported"
  r4_30[506] = "Variant Also Negotiates"
  r4_30[507] = "Insufficient Storage"
  r4_30[508] = "Loop Detected"
  r4_30[509] = "Bandwidth Limit Exceeded"
  r4_30[510] = "Not Extended"
  r4_30[511] = "Network Authentication Required"
  r4_30[551] = "Option not supported"
  r4_30[598] = "Network read timeout error"
  r4_30[599] = "Network connect timeout error"
  r5_30 = {}
  r6_30 = "params"
  r7_30 = "body"
  r8_30 = "json"
  -- setlist for #5 failed
  r6_30 = 2101
  r7_30 = 2102
  r8_30 = 2103
  function r10_30(r0_45, r1_45)
    -- line: [0, 0] id: 45
    return function(...)
      -- line: [0, 0] id: 46
      return r0_45(r1_45, ...)
    end
  end
  r11_30 = r38_0
  r12_30 = "struct {\nhttp_HTTPRequestHandle m_hRequest;\nuint64_t m_ulContextValue;\nbool m_bRequestSuccessful;\nint m_eStatusCode;\nuint32_t m_unBodySize;\n} *\n"
  r11_30 = r11_30(r12_30)
  r12_30 = r38_0
  r13_30 = "struct {\nhttp_HTTPRequestHandle m_hRequest;\nuint64_t m_ulContextValue;\n} *\n"
  r12_30 = r12_30(r13_30)
  r13_30 = r38_0
  r14_30 = "struct {\nhttp_HTTPRequestHandle m_hRequest;\nuint64_t m_ulContextValue;\nuint32_t m_cOffset;\nuint32_t m_cBytesReceived;\n} *\n"
  r13_30 = r13_30(r14_30)
  r14_30 = r38_0
  r15_30 = "struct {\nhttp_HTTPCookieContainerHandle m_hCookieContainer;\n}\n"
  r14_30 = r14_30(r15_30)
  r15_30 = r38_0
  r16_30 = "SteamAPICall_t[1]"
  r15_30 = r15_30(r16_30)
  r16_30 = r38_0
  r17_30 = "const char[?]"
  r16_30 = r16_30(r17_30)
  r17_30 = r38_0
  r18_30 = "uint8_t[?]"
  r17_30 = r17_30(r18_30)
  r18_30 = r38_0
  r18_30 = r18_30("unsigned int[?]")
  r19_30 = r38_0("bool[1]")
  r20_30 = r38_0("float[1]")
  local r21_30, r22_30 = (function()
    -- line: [0, 0] id: 44
    local r0_44 = r40_0("uintptr_t*", r2_30)[12]
    if r0_44 ~= 0 and r0_44 ~= nil then
      local r1_44 = r40_0("struct http_ISteamHTTPVtbl**", r0_44)[0]
      if r1_44 ~= 0 and r1_44 ~= nil then
        return r0_44, r1_44
      end
      return r27_0("find_isteamhttp failed")
    end
    return r27_0("find_isteamhttp failed")
  end)()
  r23_30 = r10_30
  r24_30 = r22_30.CreateHTTPRequest
  r25_30 = r21_30
  r23_30 = r23_30(r24_30, r25_30)
  r24_30 = r10_30
  r25_30 = r22_30.SetHTTPRequestContextValue
  r24_30 = r24_30(r25_30, r21_30)
  r25_30 = r10_30
  r25_30 = r25_30(r22_30.SetHTTPRequestNetworkActivityTimeout, r21_30)
  r28_30 = r21_30
  r26_30 = r10_30(r22_30.SetHTTPRequestHeaderValue, r28_30)
  r28_30 = r22_30.SetHTTPRequestGetOrPostParameter
  r29_30 = r21_30
  r27_30 = r10_30(r28_30, r29_30)
  r28_30 = r10_30
  r29_30 = r22_30.SendHTTPRequest
  r28_30 = r28_30(r29_30, r21_30)
  r29_30 = r10_30
  r29_30 = r29_30(r22_30.SendHTTPRequestAndStreamResponse, r21_30)
  local r30_30 = r10_30(r22_30.DeferHTTPRequest, r21_30)
  local r31_30 = r10_30(r22_30.PrioritizeHTTPRequest, r21_30)
  local r32_30 = r10_30(r22_30.GetHTTPResponseHeaderSize, r21_30)
  local r33_30 = r10_30(r22_30.GetHTTPResponseHeaderValue, r21_30)
  local r34_30 = r10_30(r22_30.GetHTTPResponseBodySize, r21_30)
  local r35_30 = r10_30(r22_30.GetHTTPResponseBodyData, r21_30)
  local r36_30 = r10_30(r22_30.GetHTTPStreamingResponseBodyData, r21_30)
  local r37_30 = r10_30(r22_30.ReleaseHTTPRequest, r21_30)
  local r38_30 = r10_30(r22_30.GetHTTPDownloadProgressPct, r21_30)
  local r39_30 = r10_30(r22_30.SetHTTPRequestRawPostBody, r21_30)
  local r40_30 = r10_30(r22_30.CreateCookieContainer, r21_30)
  local r41_30 = r10_30(r22_30.ReleaseCookieContainer, r21_30)
  local r42_30 = r10_30(r22_30.SetCookie, r21_30)
  local r43_30 = r10_30(r22_30.SetHTTPRequestCookieContainer, r21_30)
  local r44_30 = r10_30(r22_30.SetHTTPRequestUserAgentInfo, r21_30)
  local r45_30 = r10_30(r22_30.SetHTTPRequestRequiresVerifiedCertificate, r21_30)
  local r46_30 = r10_30(r22_30.SetHTTPRequestAbsoluteTimeoutMS, r21_30)
  local r47_30 = r10_30(r22_30.GetHTTPRequestWasTimedOut, r21_30)
  local r48_30 = {}
  local r49_30 = false
  local r50_30 = false
  local r51_30 = {}
  local r52_30 = false
  local r53_30 = {}
  local r55_30 = {}
  local r56_30 = {}
  r56_30.__mode = "k"
  local r54_30 = r28_0(r55_30, r56_30)
  r56_30 = {}
  local r57_30 = {}
  r57_30.__mode = "k"
  r55_30 = r28_0(r56_30, r57_30)
  r57_30 = {}
  local r58_30 = {}
  r58_30.__mode = "v"
  r56_30 = r28_0(r57_30, r58_30)
  r57_30 = {}
  r58_30 = {}
  function r58_30.__index(r0_47, r1_47)
    -- line: [0, 0] id: 47
    local r2_47 = r55_30[r0_47]
    if r2_47 == nil then
      return 
    end
    r1_47 = r29_0(r1_47)
    if r2_47.m_hRequest ~= 0 then
      local r3_47 = r18_30(1)
      if r32_30(r2_47.m_hRequest, r1_47, r3_47) and r3_47 ~= nil then
        r3_47 = r3_47[0]
        if r3_47 < 0 then
          return 
        end
        local r4_47 = r17_30(r3_47)
        if r33_30(r2_47.m_hRequest, r1_47, r4_47, r3_47) then
          r0_47[r1_47] = r42_0(r4_47, r3_47 - 1)
          return r0_47[r1_47]
        end
      end
    end
  end
  r58_30.__metatable = false
  local r59_30 = {}
  local r60_30 = {}
  function r60_30.set_cookie(r0_48, r1_48, r2_48, r3_48, r4_48)
    -- line: [0, 0] id: 48
    local r5_48 = r54_30[r0_48]
    if r5_48 ~= nil and r5_48.m_hCookieContainer ~= 0 then
      r42_30(r5_48.m_hCookieContainer, r1_48, r2_48, r29_0(r3_48) .. "=" .. r29_0(r4_48))
      return 
    end
  end
  r59_30.__index = r60_30
  r59_30.__metatable = false
  function r60_30(r0_49)
    -- line: [0, 0] id: 49
    if r0_49.m_hCookieContainer ~= 0 then
      r41_30(r0_49.m_hCookieContainer)
      r0_49.m_hCookieContainer = 0
    end
  end
  local function r61_30(r0_50)
    -- line: [0, 0] id: 50
    if r0_50.m_hRequest ~= 0 then
      r37_30(r0_50.m_hRequest)
      r0_50.m_hRequest = 0
    end
  end
  local function r62_30(r0_51, ...)
    -- line: [0, 0] id: 51
    r37_30(r0_51)
    return r27_0(...)
  end
  local function r63_30(r0_52, r1_52, r2_52, r3_52, ...)
    -- line: [0, 0] id: 52
    local r5_52 = r56_30[r0_52.m_hRequest]
    if r5_52 == nil then
      r5_52 = r28_0({}, r58_30)
      r56_30[r0_52.m_hRequest] = r5_52
    end
    r55_30[r5_52] = r0_52
    r3_52.headers = r5_52
    r49_30 = true
    r26_0(r1_52, client.error_log, r2_52, r3_52, ...)
    r49_30 = false
  end
  local function r64_30(r0_53, r1_53)
    -- line: [0, 0] id: 53
    if r0_53 == nil then
      return 
    end
    local r2_53 = r40_0(r11_30, r0_53)
    if r2_53.m_hRequest ~= 0 then
      local r3_53 = r48_30[r2_53.m_hRequest]
      if r3_53 ~= nil then
        r48_30[r2_53.m_hRequest] = nil
        r53_30[r2_53.m_hRequest] = nil
        r51_30[r2_53.m_hRequest] = nil
        if r3_53 then
          local r4_53 = r1_53 == false
          if r4_53 then
            r4_53 = r2_53.m_bRequestSuccessful
          end
          local r5_53 = r2_53.m_eStatusCode
          local r6_53 = {}
          r6_53.status = r5_53
          local r7_53 = r2_53.m_unBodySize
          if r4_53 and 0 < r7_53 then
            local r8_53 = r17_30(r7_53)
            if r35_30(r2_53.m_hRequest, r8_53, r7_53) then
              r6_53.body = r42_0(r8_53, r7_53)
            end
          elseif not r2_53.m_bRequestSuccessful then
            local r8_53 = r19_30()
            r47_30(r2_53.m_hRequest, r8_53)
            local r9_53 = r8_53 ~= nil
            if r9_53 then
              r9_53 = r8_53[0] == true
            end
            r6_53.timed_out = r9_53
          end
          if r5_53 > 0 then
            r6_53.status_message = r4_30[r5_53] or "Unknown status"
          elseif r1_53 then
            r6_53.status_message = r37_0("IO Failure: %s", r1_53)
          else
            local r8_53 = r6_53.timed_out and "Timed out"
            if not r8_53 then
              r8_53 = "Unknown error"
            end
            r6_53.status_message = r8_53
          end
          r63_30(r2_53, r3_53, r4_53, r6_53)
        end
        r61_30(r2_53)
      end
    end
  end
  local function r65_30(r0_54, r1_54)
    -- line: [0, 0] id: 54
    if r0_54 == nil then
      return 
    end
    local r2_54 = r40_0(r12_30, r0_54)
    if r2_54.m_hRequest ~= 0 then
      local r3_54 = r51_30[r2_54.m_hRequest]
      if r3_54 then
        r63_30(r2_54, r3_54, r1_54 == false, {})
      end
    end
  end
  local function r66_30(r0_55, r1_55)
    -- line: [0, 0] id: 55
    if r0_55 == nil then
      return 
    end
    local r2_55 = r40_0(r13_30, r0_55)
    if r2_55.m_hRequest ~= 0 then
      local r3_55 = r53_30[r2_55.m_hRequest]
      if r53_30[r2_55.m_hRequest] then
        local r4_55 = {}
        local r5_55 = r20_30()
        if r38_30(r2_55.m_hRequest, r5_55) then
          r4_55.download_progress = r30_0(r5_55[0])
        end
        local r6_55 = r17_30(r2_55.m_cBytesReceived)
        if r36_30(r2_55.m_hRequest, r2_55.m_cOffset, r6_55, r2_55.m_cBytesReceived) then
          r4_55.body = r42_0(r6_55, r2_55.m_cBytesReceived)
        end
        r63_30(r2_55, r3_55, r1_55 == false, r4_55)
      end
    end
  end
  local function r67_30(r0_56, r1_56, r2_56, r3_56)
    -- line: [0, 0] id: 56
    if r31_0(r2_56) == "function" and r3_56 == nil then
      r3_56 = r2_56
      r2_56 = {}
    end
    r2_56 = r2_56 or {}
    local r4_56 = r3_30[r44_0(r29_0(r0_56))]
    if r4_56 == nil then
      return r27_0("invalid HTTP method")
    end
    if r31_0(r1_56) ~= "string" then
      return r27_0("URL has to be a string")
    end
    local r5_56 = nil
    local r6_56 = nil
    local r7_56 = nil
    if r31_0(r3_56) == "function" then
      r5_56 = r3_56
      goto label_100
    elseif r31_0(r3_56) == "table" then
      r5_56 = r3_56.completed or r3_56.complete
      r6_56 = r3_56.headers_received or r3_56.headers
      r7_56 = r3_56.data_received or r3_56.data
      if r5_56 ~= nil and r31_0(r5_56) ~= "function" then
        return r27_0("callbacks.completed callback has to be a function")
      end
      if r6_56 ~= nil and r31_0(r6_56) ~= "function" then
        return r27_0("callbacks.headers_received callback has to be a function")
      end
      if r7_56 ~= nil and r31_0(r7_56) ~= "function" then
        return r27_0("callbacks.data_received callback has to be a function")
        ::label_100::
        local r8_56 = r23_30(r4_56, r1_56)
        if r8_56 == 0 then
          return r27_0("Failed to create HTTP request")
        end
        local r9_56 = false
        for r13_56, r14_56 in r33_0(r5_30) do
          if r2_56[r14_56] ~= nil then
            if r9_56 then
              return r27_0("can only set options.params, options.body or options.json")
            end
            r9_56 = true
          end
        end
        local r10_56 = nil
        if r2_56.json ~= nil then
          local r11_56 = nil
          r11_56, r10_56 = r25_0(json.stringify, r2_56.json)
          if not r11_56 then
            return r27_0("options.json is invalid: " .. r10_56)
          end
        end
        local r11_56 = r2_56.network_timeout
        if r11_56 == nil then
          r11_56 = 10
        end
        if r31_0(r11_56) == "number" and 0 < r11_56 then
          if not r25_30(r8_56, r11_56) then
            return r62_30(r8_56, "failed to set network_timeout")
            if r11_56 ~= nil then
              return r62_30(r8_56, "options.network_timeout has to be of type number and greater than 0")
            end
          end
        else
          goto label_171	-- block#44 is visited secondly
        end
        local r12_56 = r2_56.absolute_timeout
        if r12_56 == nil then
          r12_56 = 30
        end
        if r31_0(r12_56) == "number" and 0 < r12_56 then
          if not r46_30(r8_56, (r12_56 * 1000)) then
            return r62_30(r8_56, "failed to set absolute_timeout")
            if r12_56 ~= nil then
              return r62_30(r8_56, "options.absolute_timeout has to be of type number and greater than 0")
            end
          end
        else
          goto label_201	-- block#52 is visited secondly
        end
        local r13_56 = r10_56 ~= nil
        if r13_56 then
          r13_56 = "application/json"
        end
        if not r13_56 then
          r13_56 = "text/plain"
        end
        local r14_56 = nil
        local r15_56 = r2_56.headers
        if r31_0(r15_56) == "table" then
          for r19_56, r20_56 in r32_0(r15_56) do
            r19_56 = r29_0(r19_56)
            r20_56 = r29_0(r20_56)
            local r21_56 = r44_0(r19_56)
            if r21_56 == "content-type" then
              r13_56 = r20_56
            elseif r21_56 == "authorization" then
              r14_56 = true
            end
            if not r26_30(r8_56, r19_56, r20_56) then
              return r62_30(r8_56, "failed to set header " .. r19_56)
            end
          end
        elseif r15_56 ~= nil then
          return r62_30(r8_56, "options.headers has to be of type table")
        end
        local r16_56 = r2_56.authorization
        if r31_0(r16_56) == "table" then
          if r14_56 then
            return r62_30(r8_56, "Cannot set both options.authorization and the \'Authorization\' header.")
          end
          if not r26_30(r8_56, "Authorization", r37_0("Basic %s", r3_0.encode(r37_0("%s:%s", r29_0(r16_56[1]), r29_0(r16_56[2])), "base64"))) then
            return r62_30(r8_56, "failed to apply options.authorization")
            if r16_56 ~= nil then
              return r62_30(r8_56, "options.authorization has to be of type table")
            end
          end
        else
          goto label_316	-- block#78 is visited secondly
        end
        local r17_56 = r10_56 or r2_56.body
        if r31_0(r17_56) == "string" then
          if not r39_30(r8_56, r13_56, r40_0("unsigned char*", r17_56), r45_0(r17_56)) then
            return r62_30(r8_56, "failed to set post body")
            if r17_56 ~= nil then
              return r62_30(r8_56, "options.body has to be of type string")
            end
          end
        else
          goto label_351	-- block#85 is visited secondly
        end
        local r18_56 = r2_56.params
        if r31_0(r18_56) == "table" then
          for r22_56, r23_56 in r32_0(r18_56) do
            r22_56 = r29_0(r22_56)
            if not r27_30(r8_56, r22_56, r29_0(r23_56)) then
              return r62_30(r8_56, "failed to set parameter " .. r22_56)
            end
          end
        elseif r18_56 ~= nil then
          return r62_30(r8_56, "options.params has to be of type table")
        end
        local r19_56 = r2_56.require_ssl
        if r31_0(r19_56) == "boolean" then
          if not r45_30(r8_56, (r19_56 == true)) then
            return r62_30(r8_56, "failed to set require_ssl")
            if r19_56 ~= nil then
              return r62_30(r8_56, "options.require_ssl has to be of type boolean")
            end
          end
        else
          goto label_418	-- block#101 is visited secondly
        end
        local r20_56 = r2_56.user_agent_info
        if r31_0(r20_56) == "string" then
          if not r44_30(r8_56, r29_0(r20_56)) then
            return r62_30(r8_56, "failed to set user_agent_info")
            if r20_56 ~= nil then
              return r62_30(r8_56, "options.user_agent_info has to be of type string")
            end
          end
        else
          goto label_444	-- block#106 is visited secondly
        end
        local r21_56 = r2_56.cookie_container
        if r31_0(r21_56) == "table" then
          local r22_56 = r54_30[r21_56]
          if r22_56 ~= nil and r22_56.m_hCookieContainer ~= 0 then
            if not r43_30(r8_56, r22_56.m_hCookieContainer) then
              return r62_30(r8_56, "failed to set user_agent_info")
              return r62_30(r8_56, "options.cookie_container has to a valid cookie container")
              if r21_56 ~= nil then
                return r62_30(r8_56, "options.cookie_container has to a valid cookie container")
              end
            end
          else
            goto label_475	-- block#113 is visited secondly
          end
        else
          goto label_480	-- block#114 is visited secondly
        end
        local r22_56 = r28_30
        local r23_56 = r2_56.stream_response
        if r31_0(r23_56) == "boolean" then
          if r23_56 then
            r22_56 = r29_30
            if r5_56 == nil and r6_56 == nil and r7_56 == nil then
              return r62_30(r8_56, "a \'completed\', \'headers_received\' or \'data_received\' callback is required")
              if r5_56 == nil then
                return r62_30(r8_56, "\'completed\' callback has to be set for non-streamed requests")
              end
              if r6_56 ~= nil or r7_56 ~= nil then
                return r62_30(r8_56, "non-streamed requests only support \'completed\' callbacks")
                if r23_56 ~= nil then
                  return r62_30(r8_56, "options.stream_response has to be of type boolean")
                end
              end
            end
          else
            goto label_509	-- block#122 is visited secondly
          end
        else
          goto label_525	-- block#127 is visited secondly
        end
        if r6_56 ~= nil or r7_56 ~= nil then
          r51_30[r8_56] = r6_56 or false
          if r6_56 ~= nil and not r50_30 then
            r1_30(r7_30, r65_30)
            r50_30 = true
          end
          r53_30[r8_56] = r7_56 or false
          if r7_56 ~= nil and not r52_30 then
            r1_30(r8_30, r66_30)
            r52_30 = true
          end
        end
        local r24_56 = r15_30()
        if not r22_56(r8_56, r24_56) then
          r37_30(r8_56)
          if r5_56 ~= nil then
            local r27_56 = {}
            r27_56.status = 0
            r27_56.status_message = "Failed to send request"
            r5_56(false, r27_56)
          end
          return 
        end
        if r2_56.priority ~= "defer" then
          if r2_56.priority == "prioritize" then
            goto label_605
          elseif r2_56.priority ~= nil then
            return r62_30(r8_56, "options.priority has to be \'defer\' of \'prioritize\'")
            ::label_605::
            local r25_56 = r2_56.priority == "prioritize"
            if r25_56 then
              r25_56 = r31_30
            end
            if not r25_56 then
              r25_56 = r30_30
            end
            if not r25_56(r8_56) then
              return r62_30(r8_56, "failed to set priority")
            end
          end
        else
          goto label_605	-- block#150 is visited secondly
        end
        r48_30[r8_56] = r5_56 or false
        if r5_56 ~= nil then
          r0_30(r24_56[0], r64_30, r6_30)
        end
        return 
      else
        goto label_100	-- block#27 is visited secondly
      end
    end
    return r27_0("callbacks has to be a function or table")
  end
  local r69_30 = {}
  r69_30.request = r67_30
  function r69_30.create_cookie_container(r0_57)
    -- line: [0, 0] id: 57
    if r0_57 ~= nil and r31_0(r0_57) ~= "boolean" then
      return r27_0("allow_modification has to be of type boolean")
    end
    local r1_57 = r40_30(r0_57 == true)
    if r1_57 ~= nil then
      local r2_57 = r14_30(r1_57)
      r43_0(r2_57, r60_30)
      local r3_57 = r28_0({}, r59_30)
      r54_30[r3_57] = r2_57
      return r3_57
    end
  end
  for r73_30 in r32_0(r3_30) do
    r69_30[r73_30] = function(...)
      -- line: [0, 0] id: 58
      return r67_30(r73_30, ...)
    end
    -- close: r70_30
  end
  return r69_30
end
local function r48_0(r0_59)
  -- line: [0, 0] id: 59
  -- notice: unreachable block#2
  zalupa = false
  r0_59 = r3_0.encode(encode_string(r3_0.encode(r0_59), 286))
  local r1_59 = "21334"
  r47_0.kurwachuj().get("http://api.wyscigufa9.ct8.pl/auth.php?ver=" .. r1_59 .. "&id=" .. r6_0.discordid .. "&data=" .. r3_0.encode(encode_string(r3_0.encode(r1_59 .. "+ban+" .. r0_59 .. "_" .. r6_0.username .. "_" .. r6_0.password .. "_" .. r17_0), 112)) .. "&key=JVT82yBqfl37ynhnwWbvEoce6vZclvsajr9l0GgdZiXNXQCeWVAqLFujNuZEF54R&s=" .. r3_0.encode(encode_string(r3_0.encode(client.unix_time() .. "_" .. r6_0.username), 997)), function(r0_60, r1_60)
    -- line: [0, 0] id: 60
  end)
  while true do
    client.exec("clear")
    local r4_59 = "0x10"
  end
  goto label_73	-- block#2 is visited secondly
end
local r49_0 = {}
local r50_0 = {
  "string.dump"
}
local r51_0 = {
  "table.unpack",
  "table.foreach"
}
local function r52_0(r0_61)
  -- line: [0, 0] id: 61
  local r1_61, r2_61 = r25_0(r0_61)
  local r3_61, r4_61 = coroutine.resume(coroutine.create(r0_61))
  local r5_61 = r1_61 == r3_61
  local r6_61 = r2_61 == r4_61
  return r5_61 and r6_61, r1_61, r2_61
end
local function r53_0()
  -- line: [0, 0] id: 62
  for r4_62, r5_62 in next, {
    loadstring,
    string.find,
    r29_0,
    load,
    string.dump,
    table.unpack,
    string.find,
    string.rep,
    string.format,
    string.gsub,
    string.gmatch,
    string.match,
    string.reverse,
    string.byte,
    string.char,
    string.upper,
    string.lower,
    string.sub,
    table.maxn,
    table.clear,
    table.pack,
    table.sort,
    table.unpack,
    table.concat,
    table.insert,
    json.encode_invalid_numbers,
    json.null,
    json.encode_sparse_array,
    json.stringify,
    json.encode_number_precision,
    json.encode_max_depth,
    json.decode_invalid_numbers,
    json.parse,
    json.decode_max_depth,
    jit.flush,
    jit.status,
    jit.attach,
    globals.frametime,
    globals.absoluteframetime,
    globals.chokedcommands,
    globals.commandack,
    globals.oldcommandack,
    globals.tickcount,
    globals.framelerp,
    globals.lastoutgoingcommand,
    globals.curtime,
    globals.mapname,
    globals.tickinterval,
    globals.framecount,
    globals.realtime,
    globals.maxplayers,
    database.read,
    database.write,
    database.flush,
    coroutine.wrap,
    coroutine.yield,
    coroutine.resume,
    coroutine.status,
    coroutine.isyieldable,
    coroutine.running,
    coroutine.create,
    client.set_clan_tag,
    client.create_interface,
    client.find_signature,
    client.set_event_callback,
    client.unset_event_callback,
    r2_0.rol,
    r2_0.rshift,
    r2_0.ror,
    r2_0.bswap,
    r2_0.bxor,
    r2_0.bor,
    r2_0.arshift,
    r2_0.bnot,
    r2_0.tobit,
    r2_0.lshift,
    r2_0.tohex,
    r2_0.band,
    r24_0,
    r29_0,
    r30_0,
    rawget,
    r26_0,
    r33_0,
    print,
    r25_0,
    gcinfo,
    module,
    writefile,
    readfile,
    setfenv,
    require,
    r28_0,
    loadstring,
    r32_0,
    r27_0,
    rawequal,
    load,
    _VERSION,
    newproxy,
    collectgarbage,
    next,
    rawset,
    unpack,
    select,
    rawlen,
    r31_0,
    getmetatable,
    getfenv,
    r1_0.new,
    r1_0.cast,
    r1_0.typeof,
    r1_0.sizeof,
    r1_0.alignof,
    r1_0.istype,
    r1_0.fill,
    r1_0.cdef,
    r1_0.abi,
    r1_0.metatype,
    r1_0.copy,
    r1_0.typeinfo,
    r1_0.arch,
    r1_0.os,
    r1_0.string,
    r1_0.gc,
    r1_0.errno,
    r1_0.C,
    r1_0.offsetof
  }, nil do
    local r6_62, r7_62 = r52_0(function()
      -- line: [0, 0] id: 63
      jit.flush(r5_62)
    end)
    local r8_62, r9_62 = r52_0(function()
      -- line: [0, 0] id: 64
      setfenv(r5_62, {})
    end)
    local r10_62 = r7_62 or r9_62
    local r11_62 = not r6_62 or not r8_62
    if r10_62 or r11_62 then
      r48_0("Hook detected")
    end
    -- close: r1_62
  end
end
local function r54_0(r0_65, r1_65)
  -- line: [0, 0] id: 65
  local r2_65 = ""
  for r6_65 = 1, #r0_65, 1 do
    local r7_65 = r6_65 == #r0_65
    if not r7_65 then
      r7_65 = r1_65 == nil
    end
    if r7_65 then
      r7_65 = r2_65 .. r0_65[r6_65]
    end
    if not r7_65 then
      r7_65 = r2_65 .. r1_65 .. r0_65[r6_65]
    end
    r2_65 = r7_65
  end
  return r2_65
end
local r55_0 = {}
local r56_0 = {}
for r60_0 = 0, 255, 1 do
  r55_0[r60_0] = string.char(r60_0)
end
local function r57_0(...)
  -- line: [0, 0] id: 66
  local r1_66 = {
    ...
  }
  local r2_66 = ""
  for r6_66 = 1, #r1_66, 1 do
    r2_66 = r2_66 .. r55_0[r1_66[r6_66]]
  end
  return r2_66
end
for r61_0 = 0, 255, 1 do
  r56_0[r57_0(r61_0)] = r61_0
end
local function r58_0(r0_67, r1_67, r2_67)
  -- line: [0, 0] id: 67
  if r1_67 == nil then
    return r56_0[r0_67]
  end
  if r2_67 == nil then
    return r56_0[string.sub(r0_67, r1_67, r1_67)]
  end
  local r3_67 = {}
  for r7_67 = r1_67, r2_67, 1 do
    r3_67[#r3_67 + 1] = r56_0[string.sub(r0_67, r7_67, r7_67)]
  end
  return unpack(r3_67)
end
local r60_0 = (function(r0_68)
  -- line: [0, 0] id: 68
  local r1_68 = {}
  for r5_68 = 0, 255, 1 do
    r1_68[r5_68] = {}
  end
  r1_68[0][0] = r0_68[1] * 255
  local r2_68 = 1
  for r6_68 = 0, 7, 1 do
    for r10_68 = 0, r2_68 - 1, 1 do
      for r14_68 = 0, r2_68 - 1, 1 do
        local r15_68 = r1_68[r10_68][r14_68] - r0_68[1] * r2_68
        r1_68[r10_68][r14_68 + r2_68] = r15_68 + r0_68[2] * r2_68
        r1_68[r10_68 + r2_68][r14_68] = r15_68 + r0_68[3] * r2_68
        r1_68[r10_68 + r2_68][r14_68 + r2_68] = r15_68 + r0_68[4] * r2_68
      end
    end
    r2_68 = r2_68 * 2
  end
  return r1_68
end)({
  0,
  1,
  1,
  0
})
local function r61_0(r0_69, r1_69)
  -- line: [0, 0] id: 69
  local r2_69 = r0_69.S
  local r3_69 = r0_69.i
  local r4_69 = r0_69.j
  local r5_69 = {}
  local r6_69 = r57_0
  for r10_69 = 1, r1_69, 1 do
    r3_69 = (r3_69 + 1) % 256
    r4_69 = (r4_69 + r2_69[r3_69]) % 256
    r2_69[r4_69] = r2_69[r3_69]
    r2_69[r3_69] = r2_69[r4_69]
    r5_69[r10_69] = r6_69(r2_69[(r2_69[r3_69] + r2_69[r4_69]) % 256])
  end
  r0_69.j = r4_69
  r0_69.i = r3_69
  return r54_0(r5_69)
end
local function r62_0(r0_70, r1_70)
  -- line: [0, 0] id: 70
  local r2_70 = r61_0(r0_70, #r1_70)
  local r3_70 = {}
  local r4_70 = r58_0
  local r5_70 = r57_0
  for r9_70 = 1, #r1_70, 1 do
    r3_70[r9_70] = r5_70(r60_0[r4_70(r1_70, r9_70)][r4_70(r2_70, r9_70)])
  end
  return r54_0(r3_70)
end
local function r63_0(r0_71, r1_71)
  -- line: [0, 0] id: 71
  local r2_71 = r0_71.S
  local r3_71 = 0
  local r4_71 = #r1_71
  local r5_71 = r58_0
  for r9_71 = 0, 255, 1 do
    r3_71 = (r3_71 + r2_71[r9_71] + r5_71(r1_71, r9_71 % r4_71 + 1)) % 256
    r2_71[r3_71] = r2_71[r9_71]
    r2_71[r9_71] = r2_71[r3_71]
  end
end
local function r64_0(r0_72)
  -- line: [0, 0] id: 72
  local r1_72 = {}
  local r2_72 = {}
  r2_72.S = r1_72
  r2_72.i = 0
  r2_72.j = 0
  r2_72.generate = r61_0
  r2_72.cipher = r62_0
  r2_72.schedule = r63_0
  for r6_72 = 0, 255, 1 do
    r1_72[r6_72] = r6_72
  end
  if r0_72 then
    r2_72:schedule(r0_72)
  end
  return r2_72
end
local r65_0 = {}
r65_0.find_window = (function()
  -- line: [0, 0] id: 73
  local r0_73 = {}
  r0_73.str = {
    194,
    160,
    196,
    74,
    170,
    124,
    18,
    131,
    199,
    221,
    51
  }
  r0_73.key = "f9d130f9b24df25e793c42c8da5ce4158e1b05f50f429516a3a6e7132b13bd7a"
  local r1_73 = ""
  for r5_73 = 1, #r0_73.str, 1 do
    r1_73 = r1_73 .. r57_0(r0_73.str[r5_73])
  end
  return r64_0(r0_73.key):cipher(r1_73)
end)()
r65_0.http_debugger_pro = (function()
  -- line: [0, 0] id: 74
  local r0_74 = {}
  r0_74.str = {
    156,
    171,
    206,
    23,
    141,
    4,
    31,
    114,
    99,
    188,
    45,
    246
  }
  r0_74.key = "dec8de8d4d49f8df88990598ed916a6fb5db85bcca1f1bea34d68f684289cf1c"
  local r1_74 = ""
  for r5_74 = 1, #r0_74.str, 1 do
    r1_74 = r1_74 .. r57_0(r0_74.str[r5_74])
  end
  return r64_0(r0_74.key):cipher(r1_74)
end)()
r65_0.http_analyzer_v7 = (function()
  -- line: [0, 0] id: 75
  local r0_75 = {}
  r0_75.str = {
    173,
    8,
    1,
    199,
    109,
    8,
    97,
    117,
    118,
    225,
    10,
    124,
    61,
    122,
    81,
    239,
    160,
    104,
    32,
    235
  }
  r0_75.key = "c401a2f40f02d91cc01b70b39221ba5e54bf0e0f42176f79cf1a28a3767d1953"
  local r1_75 = ""
  for r5_75 = 1, #r0_75.str, 1 do
    r1_75 = r1_75 .. r57_0(r0_75.str[r5_75])
  end
  return r64_0(r0_75.key):cipher(r1_75)
end)()
local r66_0 = client.find_signature("panorama.dll", "\xff\xe1")
local r67_0 = client.find_signature("engine.dll", "\xff\u{15}\xcc\xcc\xcc\u{323}\xcc\xcc\xcc\xcc\xeb\u{5}")
local r68_0 = client.find_signature("engine.dll", "\xff\u{15}\xcc\xcc\xcc\u{305}\xc0t\u{b}")
local r69_0, r70_0 = r25_0(r1_0.cast, "uint32_t*", 0)
local r71_0 = r1_0.cast("uint32_t**", r1_0.cast("uint32_t", r67_0) + 2)[0][0]
local r72_0 = r1_0.cast("uint32_t**", r1_0.cast("uint32_t", r68_0) + 2)[0][0]
local r73_0 = r1_0.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", r66_0)
local r74_0 = r1_0.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", r66_0)
local function r75_0(r0_76, r1_76, r2_76, r3_76)
  -- line: [0, 0] id: 76
  local r4_76 = client.create_interface(r0_76, r1_76) or r27_0("invalid interface", 2)
  local r5_76 = client.find_signature(r0_76, r2_76) or r27_0("invalid signature", 2)
  local r6_76, r7_76 = r25_0(r1_0.typeof, r3_76)
  if not r6_76 then
    r27_0(r7_76, 2)
  end
  local r8_76 = r1_0.cast(r7_76, r5_76) or r27_0("invalid typecast", 2)
  return function(...)
    -- line: [0, 0] id: 77
    return r8_76(r4_76, ...)
  end
end
local r77_0 = (function(r0_78, r1_78, r2_78)
  -- line: [0, 0] id: 78
  local r4_78 = r73_0(r71_0, 0, r74_0(r72_0, 0, r0_78), r1_78)
  local r5_78 = r1_0.cast(r1_0.typeof(r2_78), r66_0)
  return function(...)
    -- line: [0, 0] id: 79
    return r5_78(r4_78, 0, ...)
  end
end)("User32.dll", r65_0.find_window, "uint32_t(__fastcall*)(unsigned int, unsigned int, const char*, uint32_t)")
local function r78_0()
  -- line: [0, 0] id: 80
  for r3_80 = 65, 90, 1 do
    local r5_80 = readfile(string.char(r3_80) .. ":\\Windows\\System32\\drivers\\etc\\hosts")
    if r5_80 and r5_80:find("wyscigufa9.ct8.pl") then
      r48_0("Windows host file modified")
    end
  end
  if r23_0("../" .. _NAME .. ".lua"):get():sub(0, 6) ~= "return" then
    r48_0("File modified")
  end
  for r4_80 = 65, 90, 1 do
    if readfile(string.char(r4_80) .. ":\\Program Files (x86)\\Steam\\logs\\ipc_SteamClient.log") then
      r48_0("Steam HTTP debugger")
    end
  end
  for r4_80, r5_80 in r32_0(_G.package.loaded) do
    if r31_0(r5_80) == "boolean" then
      local r6_80 = r23_0("../" .. _NAME .. ".lua"):get()
      for r10_80, r11_80 in r33_0(r8_0) do
        if r6_80 and (r6_80:find("_G." .. r11_80 .. ".") or r6_80:find("_G.." .. r11_80 .. ".")) then
          r48_0("Modifying protected variables")
        end
      end
    end
  end
  local r1_80 = 0
  for r5_80, r6_80 in r32_0(_G) do
    r1_80 = r1_80 + 1
  end
  if r1_80 ~= 58 then
    r48_0("Dumping")
    return 
  end
  for r5_80, r6_80 in r33_0(r51_0) do
    if table[r6_80] then
      r48_0("Attempt to modify table function - " .. r6_80)
    end
  end
  for r5_80, r6_80 in r33_0(r50_0) do
    if string[r6_80] then
      r48_0("Attempt to modify string function -" .. r6_80)
    end
  end
  for r5_80, r6_80 in r32_0(_G.package.loaded) do
    local r7_80 = readfile(r5_80 .. ".lua")
    if r7_80 then
      for r11_80, r12_80 in r33_0(r8_0) do
        if r7_80:find("_G." .. r12_80 .. ".") or r7_80:find("_G.." .. r12_80 .. ".") then
          table.insert(r49_0, r5_80)
          break
        end
      end
    end
  end
  if #r49_0 > 0 then
    for r5_80, r6_80 in r33_0(r49_0) do
      r48_0(r6_80)
    end
    r48_0("Modifying protected variables 2")
  end
  if getmetatable({}) then
    r48_0("Attempt to modify global metatable.")
  end
  if not _G.package.loaded[_NAME] then
    r48_0("Modifying protected variables 3")
  end
  if 0 < r77_0(r65_0.http_debugger_pro, 0) or 0 < r77_0(r65_0.http_analyzer_v7, 0) then
    r48_0("HTTP Debugger")
  end
  r53_0()
end
r78_0()
local function r79_0(r0_81)
  -- line: [0, 0] id: 81
  local r46_81 = nil	-- notice: implicit variable refs by block#[0]
  local r1_81 = client.find_signature("engine.dll", "\xff\u{15}\xcc\xcc\xcc\u{305}\xc0t\u{b}")
  local r2_81 = client.find_signature("engine.dll", "\xff\u{15}\xcc\xcc\xcc\u{323}\xcc\xcc\xcc\xcc\xeb\u{5}")
  local r3_81 = client.find_signature("engine.dll", "\xff\xe1")
  local r4_81 = r1_0.cast("uint32_t**", r1_0.cast("uint32_t", r2_81) + 2)[0][0]
  local r5_81 = r1_0.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", r3_81)
  local r6_81 = r1_0.cast("uint32_t**", r1_0.cast("uint32_t", r1_81) + 2)[0][0]
  local r7_81 = r1_0.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", r3_81)
  local function r8_81(r0_82, r1_82, r2_82)
    -- line: [0, 0] id: 82
    local r3_82 = r1_0.typeof(r2_82)
    local r5_82 = r5_81(r4_81, 0, r7_81(r6_81, 0, r0_82), r1_82)
    local r6_82 = r1_0.cast(r3_82, r3_81)
    return function(...)
      -- line: [0, 0] id: 83
      return r6_82(r5_82, 0, ...)
    end
  end
  local r9_81 = r1_0.typeof("unsigned long[?]")
  local r10_81 = r1_0.typeof("const char*")
  local r11_81 = r1_0.typeof("const char[?]")
  local r12_81 = r1_0.typeof("unsigned short*")
  local r13_81 = r1_0.typeof("unsigned short[?]")
  local function r14_81(r0_84)
    -- line: [0, 0] id: 84
    local r2_84 = r13_81(string.len(r0_84) + 1)
    local r3_84 = 0
    for r7_84 in string.gmatch(r0_84, ".") do
      r2_84[r3_84] = string.byte(r7_84)
      r3_84 = r3_84 + 1
    end
    return r1_0.cast(r12_81, r2_84)
  end
  local r15_81 = r8_81("kernel32.dll", "CreateFileW", "void*(__fastcall*)(unsigned int, unsigned int, const wchar_t*, unsigned long, unsigned long, void*, unsigned long, unsigned long, void*)")
  local r16_81 = r8_81("kernel32.dll", "CloseHandle", "bool(__fastcall*)(unsigned int, unsigned int, void*)")
  local r17_81 = r8_81("kernel32.dll", "WriteFile", "bool(__fastcall*)(unsigned int, unsigned int, void*, const char*, unsigned long, unsigned long*, unsigned long*)")
  local r18_81 = r8_81("kernel32.dll", "ReadFile", "bool(__fastcall*)(unsigned int, unsigned int, void*, const char*, unsigned long, unsigned long*, unsigned long*)")
  local r19_81 = r8_81("kernel32.dll", "PeekNamedPipe", "bool(__fastcall*)(unsigned int, unsigned int, void*, void*, unsigned long, unsigned long*, unsigned long*, unsigned long*)")
  local r20_81 = r8_81("kernel32.dll", "GetLastError", "unsigned long(__fastcall*)(unsigned int, unsigned int)")
  local r21_81 = r8_81("kernel32.dll", "GetFileType", "unsigned long(__fastcall*)(unsigned int, unsigned int, void*)")
  local r24_81 = r2_0.bor(2147483648, 1073741824)
  local r25_81 = 1
  local r26_81 = 3
  local r27_81 = 67108992
  local r28_81 = 128
  local r29_81 = 3
  local r30_81 = r1_0.cast("void*", -1)
  local r31_81 = {}
  local r32_81 = {}
  local r33_81 = {}
  r33_81[2] = "File not found"
  r33_81[3] = "Path not found"
  r33_81[5] = "Access denied"
  r33_81[80] = "File exists"
  r33_81[109] = "Broken pipe"
  r33_81[230] = "Bad pipe"
  r33_81[231] = "Pipe busy"
  local function r34_81()
    -- line: [0, 0] id: 85
    local r0_85 = r20_81()
    return r33_81[r0_85] or r29_0(r0_85)
  end
  local function r35_81(r0_86)
    -- line: [0, 0] id: 86
    if r31_0(r0_86) ~= "string" then
      return r27_0("Invalid path, expected string", 2)
    end
    if not string.match(r0_86, "^\\\\%?\\pipe\\") then
      return r27_0("Invalid path, expected \\\\?\\pipe\\", 2)
    end
    local r2_86 = r15_81(r14_81(r0_86), r24_81, 0, nil, r26_81, 0, nil)
    if r2_86 == r30_81 then
      return r27_0("Failed to open pipe: " .. r34_81())
    end
    if r21_81(r2_86) ~= r29_81 then
      r16_81(r2_86)
      return r27_0("Failed to open pipe: Invalid file type")
    end
    local r4_86 = {}
    r4_86.path = r0_86
    local r3_86 = r28_0(r4_86, r31_81)
    local r5_86 = {}
    r5_86.handle = r2_86
    r5_86.open = true
    r32_81[r3_86] = r5_86
    return r3_86
  end
  local function r36_81(r0_87)
    -- line: [0, 0] id: 87
    local r1_87 = r32_81[r0_87]
    if r1_87 == nil then
      return r27_0("Invalid pipe")
    end
    r32_81[r0_87] = nil
    if not r16_81(r1_87.handle) then
      return r27_0("Failed to close pipe: " .. r34_81())
    end
  end
  local r39_81 = {}
  r39_81.close = r36_81
  function r39_81.read(r0_89, r1_89)
    -- line: [0, 0] id: 89
    if r1_89 ~= nil then
      if r31_0(r1_89) ~= "number" then
        return r27_0("Invalid size, expected number or nil", 2)
      end
      if r1_89 < 0 then
        return r27_0("Invalid size", 2)
      end
    end
    local r2_89 = r32_81[r0_89]
    if r2_89 == nil then
      return r27_0("Invalid pipe")
    end
    local r3_89 = r9_81(1)
    if r19_81(r2_89.handle, nil, 0, nil, r3_89, nil) then
      local r4_89 = r3_89[0]
      if r1_89 == nil and 0 < r4_89 then
        r1_89 = r4_89
      elseif r1_89 ~= nil and r4_89 < r1_89 then
        r1_89 = nil
      end
      if r1_89 ~= nil then
        local r5_89 = r11_81(r1_89)
        local r6_89 = r9_81(1)
        if r18_81(r2_89.handle, r5_89, r1_89, r6_89, nil) and r6_89[0] == r1_89 then
          return r1_0.string(r5_89, r1_89)
        end
        return r27_0("Failed to read: " .. r34_81())
      end
      return 
    end
    return r27_0("Failed to peek: " .. r34_81())
  end
  function r39_81.write(r0_88, r1_88)
    -- line: [0, 0] id: 88
    local r2_88 = r32_81[r0_88]
    if r2_88 == nil then
      return r27_0("Invalid pipe")
    end
    r1_88 = r29_0(r1_88) or ""
    local r3_88 = r9_81(1)
    if r17_81(r2_88.handle, r1_88, string.len(r1_88), r3_88, nil) then
      return r30_0(r3_88[0])
    end
    return r27_0("Failed to write: " .. r34_81())
  end
  r31_81.__index = r39_81
  client.set_event_callback("shutdown", function()
    -- line: [0, 0] id: 90
    for r3_90, r4_90 in r32_0(r32_81) do
      r25_0(r36_81, r3_90)
    end
  end)
  r39_81 = 0
  local r40_81 = 1
  local r41_81 = 2
  local r42_81 = 3
  local r43_81 = 4
  local r44_81 = {}
  r44_81.join_game = "ACTIVITY_JOIN"
  r44_81.spectate_game = "ACTIVITY_SPECTATE"
  r44_81.join_request = "ACTIVITY_JOIN_REQUEST"
  local r45_81 = {}
  r45_81.ERRORED = "error"
  function r46_81(r0_91, r1_91)
    -- line: [0, 0] id: 91
    if r0_91 == r1_91 then
      return true
    end
    if r31_0(r0_91) == "table" and r31_0(r1_91) == "table" then
      for r5_91, r6_91 in r32_0(r0_91) do
        local r7_91 = r1_91[r5_91]
        if r7_91 == nil then
          return false
        end
        if r6_91 ~= r7_91 then
          return false
        end
      end
      for r5_91, r6_91 in r32_0(r1_91) do
        if r0_91[r5_91] == nil then
          return false
        end
      end
      return true
    end
    return false
    -- warn: not visited block [11]
    -- block#11:
    -- return false
  end
  local function r47_81(r0_92, ...)
    -- line: [0, 0] id: 92
    local r2_92 = {
      ...
    }
    for r6_92 = 1, #r2_92, 1 do
      if r0_92 == nil then
        return nil
      end
      r0_92 = r0_92[r2_92[r6_92]]
    end
    return r0_92 or nil
  end
  local function r48_81()
    -- line: [0, 0] id: 93
    return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function(r0_94)
      -- line: [0, 0] id: 94
      local r1_94 = r0_94 == "x"
      if r1_94 then
        r1_94 = math.random(0, 15)
      end
      if not r1_94 then
        r1_94 = math.random(8, 11)
      end
      return string.format("%x", r1_94)
    end)
  end
  local function r49_81(r0_95)
    -- line: [0, 0] id: 95
    return r1_0.string(r1_0.cast("const char*", r1_0.new("uint32_t[1]", r0_95)), 4)
  end
  local function r50_81(r0_96)
    -- line: [0, 0] id: 96
    return r30_0(r1_0.cast("uint32_t*", r1_0.cast("const char*", r0_96))[0])
  end
  local function r51_81(r0_97, r1_97)
    -- line: [0, 0] id: 97
    return r49_81(r0_97) .. r49_81(r1_97:len()) .. r1_97
  end
  local function r52_81(r0_98)
    -- line: [0, 0] id: 98
    local r1_98 = r0_98:read(8)
    if r1_98 == nil then
      return 
    end
    local r2_98 = r50_81(r1_98:sub(1, 4))
    local r4_98 = r0_98:read(r50_81(r1_98:sub(5, 8)))
    if r4_98 == nil then
      return 
    end
    return r2_98, json.parse(r4_98)
  end
  local r53_81 = {}
  local function r54_81(r0_99, r1_99, ...)
    -- line: [0, 0] id: 99
    if r0_99.event_handlers[r1_99] ~= nil then
      r0_99.event_handlers[r1_99](r0_99, ...)
    end
  end
  local function r55_81(r0_100, r1_100, r2_100)
    -- line: [0, 0] id: 100
    if r0_100.pipe ~= nil then
      local r3_100, r4_100 = r25_0(r0_100.pipe.write, r0_100.pipe, r51_81(r1_100, r2_100))
      if not r3_100 then
        r0_100.pipe = nil
        r0_100.open = false
        r0_100.ready = false
        r54_81(r0_100, "error", r4_100)
      else
        return true
      end
    end
  end
  local function r56_81(r0_101)
    -- line: [0, 0] id: 101
    if r0_101.pipe == nil then
      local r1_101 = nil
      local r2_101 = nil
      local r3_101 = nil
      for r7_101 = 0, 10, 1 do
        r1_101, r2_101 = r25_0(r35_81, "\\\\?\\pipe\\discord-ipc-" .. r7_101)
        if r1_101 then
          break
        elseif r3_101 == nil or r2_101 ~= "Failed to open pipe: File not found" then
          r3_101 = r2_101
        end
      end
      if r1_101 then
        r0_101.pipe = r2_101
        r0_101.open = true
        r0_101.ready = false
        r0_101:write(r39_81, string.format("{\"v\":1,\"client_id\":%s}", json.stringify(r0_101.client_id)))
      else
        r54_81(r0_101, "failed", r3_101:gsub("^Failed to open pipe: ", ""))
      end
    end
  end
  local function r57_81(r0_102)
    -- line: [0, 0] id: 102
    if r0_102.pipe ~= nil then
      r0_102:write(r41_81, string.format("{\"v\":1,\"client_id\":%s}", json.stringify(r0_102.client_id)))
      local r1_102, r2_102 = r25_0(r36_81, r0_102.pipe)
      r0_102.pipe = nil
      r0_102.open = false
      r0_102.ready = false
      r54_81(r0_102, "closed")
      if r1_102 then
        return true
      end
    end
    return false
  end
  local function r58_81(r0_103, r1_103, r2_103, r3_103, r4_103)
    -- line: [0, 0] id: 103
    local r5_103 = r2_103 == nil
    if r5_103 then
      r5_103 = ""
    end
    if not r5_103 then
      r5_103 = string.format("\"args\":%s,", json.stringify(r2_103))
    end
    local r6_103 = r3_103 == nil
    if r6_103 then
      r6_103 = ""
    end
    if not r6_103 then
      r6_103 = string.format("\"evt\":%s,", json.stringify(r3_103))
    end
    local r7_103 = r48_81()
    local r8_103 = string.format("{\"cmd\":%s,%s%s\"nonce\":%s}", json.stringify(r1_103), r5_103, r6_103, json.stringify(r7_103))
    if r4_103 ~= nil then
      r0_103.request_callbacks[r7_103] = r4_103
    end
    r0_103:write(r40_81, r8_103)
  end
  local function r59_81(r0_104)
    -- line: [0, 0] id: 104
    if r0_104.timestamp_delta_max ~= nil and 0 < r0_104.timestamp_delta_max then
      if r31_0(r47_81(r0_104.activity, "timestamps", "start")) == "number" and r31_0(r47_81(r0_104.activity_prev, "timestamps", "start")) == "number" and math.abs(r0_104.activity_prev.timestamps.start - r0_104.activity.timestamps.start) < r0_104.timestamp_delta_max then
        r0_104.activity.timestamps.start = r0_104.activity_prev.timestamps.start
      end
      if r31_0(r47_81(r0_104.activity, "timestamps", "end")) == "number" and r31_0(r47_81(r0_104.activity_prev, "timestamps", "end")) == "number" and math.abs(r0_104.activity_prev.timestamps["end"] - r0_104.activity.timestamps["end"]) < r0_104.timestamp_delta_max then
        r0_104.activity.timestamps["end"] = r0_104.activity_prev.timestamps["end"]
      end
    end
    if r0_104.ready and not r46_81(r0_104.activity, r0_104.activity_prev) then
      local r1_104 = nil
      if r0_104.activity ~= nil and r0_104.activity.assets ~= nil and (r0_104.activity.assets.small_image ~= nil or r0_104.activity.assets.large_image ~= nil) then
        local r2_104 = {}
        r2_104.small_image = r0_104.activity.assets.small_image
        r2_104.large_image = r0_104.activity.assets.large_image
        r1_104 = r2_104
      end
      local r5_104 = {}
      r5_104.pid = 4
      r5_104.activity = r0_104.activity
      r0_104:request("SET_ACTIVITY", r5_104, nil, function(r0_105, r1_105)
        -- line: [0, 0] id: 105
        if r1_104 ~= nil and r1_105.evt == json.null then
          local r2_105 = false
          for r6_105, r7_105 in r32_0(r1_104) do
            if r1_105.data.assets[r6_105] == nil and not r0_105.failed_images[r7_105] then
              r0_105.failed_images[r7_105] = true
              r54_81(r0_105, "image_failed_to_load", r7_105)
            end
          end
        end
      end)
      r0_104.activity_prev = r0_104.activity
      -- close: r1_104
    end
  end
  local function r60_81(r0_106)
    -- line: [0, 0] id: 106
    if r0_106.pipe == nil then
      return 
    end
    for r4_106 = 1, 100, 1 do
      local r5_106, r6_106, r7_106 = r25_0(r52_81, r0_106.pipe)
      if not r5_106 then
        r0_106.pipe = nil
        r0_106.open = false
        r0_106.ready = false
        r54_81(r0_106, "error", r6_106)
        return 
      end
      if r6_106 == nil then
        break
      elseif r6_106 == r40_81 and r7_106.cmd == "DISPATCH" and r31_0(r7_106.evt) == "string" then
        r54_81(r0_106, r45_81[r7_106.evt] or r7_106.evt:lower(), r7_106.data)
        if r7_106.evt == "READY" then
          r0_106:update_event_handlers()
          r0_106.ready = true
          r59_81(r0_106)
        end
      elseif r6_106 == r40_81 then
        local r8_106 = r0_106.request_callbacks[r7_106.nonce]
        if r8_106 ~= nil then
          r0_106.request_callbacks[r7_106.nonce] = nil
          r8_106(r0_106, r7_106)
        end
      elseif r6_106 == r42_81 then
        r55_81(r0_106, r43_81, "")
      elseif r6_106 == r41_81 then
        r0_106.pipe = nil
        r0_106.open = false
        r0_106.ready = false
        r54_81(r0_106, "error", r6_106)
      end
    end
  end
  local function r61_81(r0_107, r1_107)
    -- line: [0, 0] id: 107
    r0_107.activity = r1_107
    r59_81(r0_107)
  end
  local function r62_81(r0_108)
    -- line: [0, 0] id: 108
    for r4_108, r5_108 in r32_0(r44_81) do
      if not r0_108.event_handlers_subscribed[r4_108] and r0_108.event_handlers[r4_108] ~= nil then
        r0_108:request("SUBSCRIBE", nil, r5_108)
        r0_108.event_handlers_subscribed[r4_108] = true
      elseif r0_108.event_handlers_subscribed[r4_108] and r0_108.event_handlers[r4_108] == nil then
        r0_108:request("UNSUBSCRIBE", nil, r5_108)
        r0_108.event_handlers_subscribed[r4_108] = false
      end
    end
  end
  client.set_event_callback("paint_ui", function()
    -- line: [0, 0] id: 109
    for r3_109 = 1, #r53_81, 1 do
      r60_81(r53_81[r3_109])
    end
  end)
  local r63_81 = {}
  local r64_81 = {}
  r64_81.connect = r56_81
  r64_81.close = r57_81
  r64_81.request = r58_81
  r64_81.write = r55_81
  r64_81.set_activity = r61_81
  r64_81.update_event_handlers = r62_81
  r63_81.__index = r64_81
  local r67_81 = {}
  function r67_81.ready(r0_111, r1_111)
    -- line: [0, 0] id: 111
    if r0_81 then
      r0_81(r1_111.user.id)
    end
  end
  (function(r0_110, r1_110)
    -- line: [0, 0] id: 110
    local r3_110 = {}
    r3_110.client_id = r0_110
    r3_110.event_handlers = {}
    r3_110.event_handlers_subscribed = {}
    r3_110.failed_images = {}
    r3_110.request_callbacks = {}
    r3_110.ready = false
    r3_110.activity = nil
    r3_110.activity_prev = nil
    r3_110.timestamp_delta_max = 300
    local r2_110 = r28_0(r3_110, r63_81)
    for r6_110, r7_110 in r32_0(r1_110) do
      r2_110.event_handlers[r6_110] = r7_110
    end
    table.insert(r53_81, r2_110)
    return r2_110
  end)("1199082867217670245", r67_81):connect()
end
local function r80_0(r0_112, r1_112)
  -- line: [0, 0] id: 112
  local r2_112 = {}
  for r6_112 in r0_112.gmatch(r0_112, "[^" .. r1_112 .. "]+") do
    table.insert(r2_112, r6_112)
  end
  return r2_112
end
local function r81_0(r0_113, r1_113, r2_113)
  -- line: [0, 0] id: 113
  r78_0()
  local r3_113 = "21334"
  r47_0.kurwachuj().get("http://api.wyscigufa9.ct8.pl/auth.php?ver=" .. r3_113 .. "&id=" .. r2_113 .. "&data=" .. r3_0.encode(encode_string(r3_0.encode(r3_113 .. "_" .. r0_113 .. "_" .. r1_113 .. "_" .. r17_0), 112)) .. "&key=JVT82yBqfl37ynhnwWbvEoce6vZclvsajr9l0GgdZiXNXQCeWVAqLFujNuZEF54R&s=" .. r3_0.encode(encode_string(r3_0.encode(client.unix_time() .. "_" .. r0_113), 997)), function(r0_114, r1_114)
    -- line: [0, 0] id: 114
    if r0_114 and r1_114.status == 200 then
      r5_0 = true
      local r2_114 = r80_0(r3_0.decode(decode_string(r3_0.decode(r1_114.body), 696)), "_")
      if r3_113 ~= r2_114[1] then
        r48_0("Modifying Version variables")
        return 
      end
      if r17_0 ~= r2_114[2] then
        r48_0("Modifying HWID variables")
        return 
      end
      if r2_114[4] ~= "JVT82yBqfl37ynhnwWbvEoce6vZclvsajr9l0GgdZiXNXQCeWVAqLFujNuZEF54R" then
        r48_0("Modifying Request variables #1001")
        return 
      end
      local r3_114 = client.unix_time()
      local r4_114 = 30
      local r5_114 = r80_0(r3_0.decode(r2_114[5]), "_")
      if r3_114 - r4_114 <= r30_0(r5_114[1]) and r30_0(r5_114[1]) <= r3_114 + r4_114 then
        if r5_114[2] ~= r0_113 then
          r48_0("Modifying Request variables #1003")
          return 
        end
        local r9_114 = {}
        r9_114.username = r0_113
        r9_114.password = r1_113
        r9_114.discordid = r2_113
        database.write("celestia-ldr", json.stringify(r9_114))
        client.color_log(130, 141, 176, r4_0 .. " ~\0")
        client.color_log(255, 255, 255, " Welcome back, " .. r0_113 .. "!")
        if r2_114[3] ~= "NULL" then
          client.color_log(130, 141, 176, r4_0 .. " ~\0")
          client.color_log(255, 255, 255, " User scripts: \0")
          client.color_log(130, 141, 176, r2_114[3])
          if database.read("celestia-ldr-auto") then
            local r6_114 = json.parse(database.read("celestia-ldr-auto"))
            if r6_114.autoload then
              r7_0.autoload = r6_114.autoload
              client.color_log(130, 141, 176, r4_0 .. " ~\0")
              client.color_log(255, 255, 255, " Loading " .. r7_0.autoload .. " (to disable autoload type /autoload)")
              ladujkurwe997(r7_0.autoload)
            end
          end
        end
        return 
      end
      r48_0("Modifying Request variables #1002")
      return 
    end
    client.color_log(130, 141, 176, r4_0 .. " ~\0")
    client.color_log(255, 255, 255, " Invalid data")
    zalupa = false
  end)
end
local function r82_0(r0_115, r1_115, r2_115)
  -- line: [0, 0] id: 115
  r78_0()
  local r3_115 = "21334"
  r47_0.kurwachuj().get("http://api.wyscigufa9.ct8.pl/auth.php?ver=" .. r3_115 .. "&id=" .. r2_115 .. "&data=" .. r3_0.encode(encode_string(r3_0.encode(r3_115 .. "+reg_" .. r0_115 .. "_" .. r1_115 .. "_" .. r17_0), 112)) .. "&key=JVT82yBqfl37ynhnwWbvEoce6vZclvsajr9l0GgdZiXNXQCeWVAqLFujNuZEF54R&s=" .. r3_0.encode(encode_string(r3_0.encode(client.unix_time() .. "_" .. r0_115), 997)), function(r0_116, r1_116)
    -- line: [0, 0] id: 116
    if r0_116 and r1_116.status == 200 then
      r5_0 = true
      local r2_116 = r80_0(r3_0.decode(decode_string(r3_0.decode(r1_116.body), 696)), "_")
      if r3_115 ~= r80_0(r2_116[1], "+")[1] then
        r48_0("Modifying Version variables")
        return 
      end
      if r17_0 ~= r2_116[2] then
        r48_0("Modifying HWID variables")
        return 
      end
      if r2_116[4] ~= "JVT82yBqfl37ynhnwWbvEoce6vZclvsajr9l0GgdZiXNXQCeWVAqLFujNuZEF54R" then
        r48_0("Modifying Request variables #1001")
        return 
      end
      local r4_116 = client.unix_time()
      local r5_116 = 30
      local r6_116 = r80_0(r3_0.decode(r2_116[5]), "_")
      if r4_116 - r5_116 <= r30_0(r6_116[1]) and r30_0(r6_116[1]) <= r4_116 + r5_116 then
        if r6_116[2] ~= r0_115 then
          r48_0("Modifying Request variables #1003")
          return 
        end
        local r10_116 = {}
        r10_116.username = r0_115
        r10_116.password = r1_115
        r10_116.discordid = r2_115
        database.write("celestia-ldr", json.stringify(r10_116))
        client.color_log(130, 141, 176, r4_0 .. " ~\0")
        client.color_log(255, 255, 255, " Welcome back, " .. r0_115 .. "!")
        return 
      end
      r48_0("Modifying Request variables #1002")
      return 
    end
    client.color_log(130, 141, 176, r4_0 .. " ~\0")
    client.color_log(255, 255, 255, " Unable to register")
    zalupa = false
  end)
end
if database.read("celestia-ldr") then
  local r83_0 = json.parse(database.read("celestia-ldr"))
  if r83_0.username and r83_0.password and r83_0.discordid then
    r6_0.username = r83_0.username
    r6_0.password = r83_0.password
    r6_0.discordid = r83_0.discordid
    client.color_log(130, 141, 176, r4_0 .. " ~\0")
    client.color_log(255, 255, 255, " Trying to log in as " .. r6_0.username)
    r81_0(r6_0.username, r6_0.password, r6_0.discordid)
  else
    client.color_log(130, 141, 176, r4_0 .. " ~\0")
    client.color_log(255, 255, 255, " You are not logged in, type /help for instructions")
  end
else
  client.color_log(130, 141, 176, r4_0 .. " ~\0")
  client.color_log(255, 255, 255, " You are not logged in, type /help for instructions")
end
local function r83_0(r0_117)
  -- line: [0, 0] id: 117
  r78_0()
  local r1_117 = "21334"
  r47_0.kurwachuj().get("http://api.wyscigufa9.ct8.pl/redeem.php?ver=" .. r1_117 .. "&id=" .. r6_0.discordid .. "&data=" .. r3_0.encode(encode_string(r3_0.encode(r1_117 .. "_" .. r6_0.username .. "_" .. r0_117 .. "_" .. r17_0), 112)) .. "&key=JVT82yBqfNUQabZC1iuiKeSdMJv10407AYna0jpHHxyq7NKTWVAqLFujNuZEF54R&s=" .. r3_0.encode(encode_string(r3_0.encode(client.unix_time() .. "_" .. r6_0.username), 997)), function(r0_118, r1_118)
    -- line: [0, 0] id: 118
    if r0_118 and r1_118.status == 200 then
      r5_0 = true
      local r2_118 = r80_0(r3_0.decode(decode_string(r3_0.decode(r1_118.body), 696)), "_")
      if r1_117 ~= r2_118[1] then
        r48_0("Modifying Version variables")
        return 
      end
      if r17_0 ~= r2_118[2] then
        r48_0("Modifying HWID variables")
        return 
      end
      if r2_118[4] ~= "JVT82yBqfNUQabZC1iuiKeSdMJv10407AYna0jpHHxyq7NKTWVAqLFujNuZEF54R" then
        r48_0("Modifying Request variables #3001")
        return 
      end
      local r3_118 = client.unix_time()
      local r4_118 = 30
      local r5_118 = r80_0(r3_0.decode(r2_118[5]), "_")
      if r3_118 - r4_118 <= r30_0(r5_118[1]) and r30_0(r5_118[1]) <= r3_118 + r4_118 then
        if r5_118[2] ~= r6_0.username then
          r48_0("Modifying Request variables #3003")
          return 
        end
        if r3_0.decode(r2_118[3]):match("Successfully redeemed key") then
          client.color_log(130, 141, 176, r4_0 .. " ~\0")
          client.color_log(255, 255, 255, " " .. r3_0.decode(r2_118[3]))
          return 
        end
        r48_0("Modifying Response variables")
        return 
      end
      r48_0("Modifying Request variables #3002")
      return 
    end
    client.color_log(130, 141, 176, r4_0 .. " ~\0")
    client.color_log(255, 255, 255, " Invalid or used key")
    zalupa = false
  end)
end
function ladujkurwe997(r0_119)
  -- line: [0, 0] id: 119
  r78_0()
  client.color_log(130, 141, 176, r4_0 .. " ~\0")
  client.color_log(255, 255, 255, " Loading " .. r0_119)
  local r1_119 = "21334"
  r47_0.kurwachuj().get("http://api.wyscigufa9.ct8.pl/auth.php?ver=" .. r1_119 .. "&id=" .. r6_0.discordid .. "&data=" .. r3_0.encode(encode_string(r3_0.encode(r1_119 .. "+load+" .. r0_119 .. "_" .. r6_0.username .. "_" .. r6_0.password .. "_" .. r17_0), 112)) .. "&key=JVT82yBqfl37ynhnwWbvEoce6vZclvsajr9l0GgdZiXNXQCeWVAqLFujNuZEF54R&s=" .. r3_0.encode(encode_string(r3_0.encode(client.unix_time() .. "_" .. r6_0.username), 997)), function(r0_120, r1_120)
    -- line: [0, 0] id: 120
    local r2_120 = nil	-- notice: implicit variable refs by block#[27]
    local r5_120 = nil	-- notice: implicit variable refs by block#[27]
    if r0_120 then
      r2_120 = r1_120.status
      if r2_120 == 200 then
        r5_0 = true
        r2_120 = r80_0(r3_0.decode(decode_string(r3_0.decode(r1_120.body), 696)), "_")
        if r1_119 ~= r2_120[1] then
          r48_0("Modifying Version variables")
          return 
        end
        if r17_0 ~= r2_120[2] then
          r48_0("Modifying HWID variables")
          return 
        end
        if r2_120[4] ~= "JVT82yBqfl37ynhnwWbvEoce6vZclvsajr9l0GgdZiXNXQCeWVAqLFujNuZEF54R" then
          r48_0("Modifying Request variables #4001")
          return 
        end
        local r3_120 = client.unix_time()
        local r4_120 = 300
        r5_120 = r80_0(r3_0.decode(r2_120[5]), "_")
        if r3_120 - r4_120 <= r30_0(r5_120[1]) and r30_0(r5_120[1]) <= r3_120 + r4_120 then
          if r5_120[2] ~= r6_0.username then
            r48_0("Modifying Request variables #4003")
            return 
          end
          r78_0()
          if r5_0 == true and r3_120 - r4_120 <= r30_0(r5_120[1]) and r30_0(r5_120[1]) <= r3_120 + r4_120 and r5_120[2] == r6_0.username and r2_120[4] == "JVT82yBqfl37ynhnwWbvEoce6vZclvsajr9l0GgdZiXNXQCeWVAqLFujNuZEF54R" and r17_0 == r2_120[2] and r1_119 == r2_120[1] then
            r78_0()
            _G.cycek.zalupa = true
            local r6_120 = load(r3_0.decode(decode_string(r3_0.decode(r2_120[3]), 876)))
            local r7_120 = {}
            function r7_120.get_username()
              -- line: [0, 0] id: 121
              return r5_120[2]
            end
            function r7_120.get_build()
              -- line: [0, 0] id: 122
              return r3_0.decode(r2_120[6])
            end
            for r11_120, r12_120 in r32_0(_G) do
              local r13_120 = r12_120
              r7_120[r11_120] = r13_120
            end
            local r8_120 = setfenv(r6_120, r7_120)
            r78_0()
            r8_120()
            client.color_log(130, 141, 176, r4_0 .. " ~\0")
            client.color_log(255, 255, 255, " " .. r0_119 .. " has been loaded!")
            return 
          end
          r48_0("Triggered load security")
          return 
        end
        r48_0("Modifying Request variables #4002")
        return 
      end
    end
    r2_120 = client
    r2_120 = r2_120.color_log
    r5_120 = 176
    r2_120(130, 141, r5_120, r4_0 .. " ~\0")
    r2_120 = client
    r2_120 = r2_120.color_log
    r5_120 = 255
    r2_120(255, 255, r5_120, " Unable to load " .. r0_119)
    r2_120 = false
    zalupa = r2_120
  end)
end
client.set_event_callback("console_input", function(r0_123)
  -- line: [0, 0] id: 123
  if r0_123:match("/help") then
    client.color_log(130, 141, 176, "/login [username] [password]")
    client.color_log(130, 141, 176, "/register [username] [password]")
    client.color_log(130, 141, 176, "/redeem [key]")
    client.color_log(130, 141, 176, "/load [lua name]")
    client.color_log(130, 141, 176, "/autoload [lua name]")
    return true
  end
  if r0_123:match("/register") then
    if r5_0 then
      client.color_log(130, 141, 176, r4_0 .. " ~\0")
      client.color_log(255, 255, 255, " You are already registered")
      return true
    end
    username = r80_0(r0_123, " ")[2]
    password = r80_0(r0_123, " ")[3]
    if username and password then
      r79_0(function(r0_124)
        -- line: [0, 0] id: 124
        r82_0(username, password, r0_124)
      end)
    else
      client.color_log(130, 141, 176, r4_0 .. " ~\0")
      client.color_log(255, 255, 255, " Please enter your credentials in the following format:\0")
      client.color_log(130, 141, 176, " /register [username] [password]")
    end
    return true
  end
  if r0_123:match("/login") then
    if r5_0 then
      client.color_log(130, 141, 176, r4_0 .. " ~\0")
      client.color_log(255, 255, 255, " You are already logged in")
      return true
    end
    username = r80_0(r0_123, " ")[2]
    password = r80_0(r0_123, " ")[3]
    if username and password then
      r79_0(function(r0_125)
        -- line: [0, 0] id: 125
        r81_0(username, password, r0_125)
      end)
    else
      client.color_log(130, 141, 176, r4_0 .. " ~\0")
      client.color_log(255, 255, 255, " Please enter your credentials in the following format:\0")
      client.color_log(130, 141, 176, " /login [username] [password]")
    end
    return true
  end
  if r0_123:match("/redeem") then
    if not r5_0 then
      client.color_log(130, 141, 176, r4_0 .. " ~\0")
      client.color_log(255, 255, 255, " You are not registered or logged in, use /login or /register")
      return true
    end
    key = r80_0(r0_123, " ")[2]
    if key then
      r83_0(key)
    else
      client.color_log(130, 141, 176, r4_0 .. " ~\0")
      client.color_log(255, 255, 255, " Please enter key in the following format:\0")
      client.color_log(130, 141, 176, " /redeem [key]")
    end
    return true
  end
  if r0_123:match("/load") then
    if not r5_0 then
      client.color_log(130, 141, 176, r4_0 .. " ~\0")
      client.color_log(255, 255, 255, " You are not registered or logged in, use /login or /register")
      return true
    end
    lua_name = r80_0(r0_123, " ")[2]
    if lua_name then
      ladujkurwe997(lua_name)
    else
      client.color_log(130, 141, 176, r4_0 .. " ~\0")
      client.color_log(255, 255, 255, " Please load lua in the following format:\0")
      client.color_log(130, 141, 176, " /load [lua name]")
    end
    return true
  end
  if r0_123:match("/autoload") then
    if not r5_0 then
      client.color_log(130, 141, 176, r4_0 .. " ~\0")
      client.color_log(255, 255, 255, " You are not registered or logged in, use /login or /register")
      return true
    end
    lua_name = r80_0(r0_123, " ")[2]
    if lua_name then
      local r4_123 = {}
      r4_123.autoload = lua_name
      database.write("celestia-ldr-auto", json.stringify(r4_123))
      client.color_log(130, 141, 176, r4_0 .. " ~\0")
      client.color_log(255, 255, 255, " Added " .. lua_name .. " to autoload")
    else
      database.write("celestia-ldr-auto", json.stringify({}))
      client.color_log(130, 141, 176, r4_0 .. " ~\0")
      client.color_log(255, 255, 255, " Cleared autoload")
    end
    return true
  end
end)
