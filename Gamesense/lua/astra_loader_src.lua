local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1
L1_1 = require
L2_1 = "ffi"
L1_1 = L1_1(L2_1)
if not L1_1 then
  L1_1 = error
  L2_1 = "toggle unsafe scripts"
  L1_1 = L1_1(L2_1)
end
L2_1 = require
L3_1 = "bit"
L2_1 = L2_1(L3_1)
if not L2_1 then
  L2_1 = error
  L3_1 = "no bit lib"
  L2_1 = L2_1(L3_1)
end
L3_1 = L1_1.typeof
L4_1 = [[
    struct {
        char __m_pDriverName[512];
        unsigned int __m_VendorID;
        unsigned int __m_DeviceID;
        unsigned int __m_SubSysID;
        unsigned int __m_Revision;
        int __m_nDXSupportLevel;
        int __m_nMinDXSupportLevel;
        int __m_nMaxDXSupportLevel;
        unsigned int __m_nDriverVersionHigh;
        unsigned int __m_nDriverVersionLow;
        int64_t pad_0;
    }
]]
L3_1 = L3_1(L4_1)
L4_1 = {}
L5_1 = {}
L4_1.__index = L5_1
L5_1 = vtable_bind
L6_1 = "materialsystem.dll"
L7_1 = "VMaterialSystem080"
L8_1 = 25
L9_1 = "int(__thiscall*)(void*)"
L5_1 = L5_1(L6_1, L7_1, L8_1, L9_1)
L6_1 = vtable_bind
L7_1 = "materialsystem.dll"
L8_1 = "VMaterialSystem080"
L9_1 = 26
L10_1 = "void(__thiscall*)(void*, int, $*)"
L11_1 = L3_1
L6_1 = L6_1(L7_1, L8_1, L9_1, L10_1, L11_1)
function L7_1()
  local L0_2, L1_2
  L0_2 = L5_1
  return L0_2()
end
get_current_adapter = L7_1
L7_1 = {}
function L8_1(A0_2)
  local L1_2, L2_2
  L1_2 = L1_1
  L1_2 = L1_2.string
  L2_2 = A0_2.__m_pDriverName
  return L1_2(L2_2)
end
L7_1.drivername = L8_1
function L8_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = string
  L1_2 = L1_2.match
  L2_2 = tostring
  L3_2 = A0_2.__m_VendorID
  L2_2 = L2_2(L3_2)
  L3_2 = "%d+"
  return L1_2(L2_2, L3_2)
end
L7_1.vendorid = L8_1
function L8_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = string
  L1_2 = L1_2.match
  L2_2 = tostring
  L3_2 = A0_2.__m_DeviceID
  L2_2 = L2_2(L3_2)
  L3_2 = "%d+"
  return L1_2(L2_2, L3_2)
end
L7_1.deviceid = L8_1
function L8_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = string
  L1_2 = L1_2.match
  L2_2 = tostring
  L3_2 = A0_2.__m_SubSysID
  L2_2 = L2_2(L3_2)
  L3_2 = "%d+"
  return L1_2(L2_2, L3_2)
end
L7_1.subsysid = L8_1
function L8_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = string
  L1_2 = L1_2.match
  L2_2 = tostring
  L3_2 = A0_2.__m_Revision
  L2_2 = L2_2(L3_2)
  L3_2 = "%d+"
  return L1_2(L2_2, L3_2)
end
L7_1.revision = L8_1
L8_1 = "__index"
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L7_1
  L2_2 = L2_2[A1_2]
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L7_1
  L3_2 = L3_2[A1_2]
  L4_2 = A0_2
  return L3_2(L4_2)
end
L4_1[L8_1] = L9_1
L8_1 = L1_1.metatype
L9_1 = L3_1
L10_1 = L4_1
L8_1(L9_1, L10_1)
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L1_2 = L1_2()
  L2_2 = L6_1
  L3_2 = A0_2
  L4_2 = L1_2
  L2_2(L3_2, L4_2)
  L2_2 = L1_2
  return L2_2
end
get_adapter_info = L8_1
L8_1 = get_current_adapter
L8_1 = L8_1()
L9_1 = get_adapter_info
L10_1 = L8_1
L9_1 = L9_1(L10_1)
L10_1 = string
L10_1 = L10_1.format
L11_1 = "%s:%s:%s:%s"
L12_1 = L9_1.vendorid
L13_1 = L9_1.deviceid
L14_1 = L9_1.subsysid
L15_1 = L9_1.drivername
L10_1 = L10_1(L11_1, L12_1, L13_1, L14_1, L15_1)
function L11_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2, L44_2, L45_2, L46_2, L47_2, L48_2, L49_2, L50_2, L51_2, L52_2, L53_2, L54_2, L55_2, L56_2, L57_2, L58_2, L59_2, L60_2, L61_2, L62_2, L63_2, L64_2, L65_2, L66_2, L67_2, L68_2, L69_2, L70_2
  L0_2 = require
  L1_2 = "bit"
  L0_2 = L0_2(L1_2)
  L1_2 = {}
  L2_2 = L0_2.lshift
  L3_2 = L0_2.rshift
  L4_2 = L0_2.band
  L5_2 = string
  L5_2 = L5_2.char
  L6_2 = string
  L6_2 = L6_2.byte
  L7_2 = string
  L7_2 = L7_2.gsub
  L8_2 = string
  L8_2 = L8_2.sub
  L9_2 = string
  L9_2 = L9_2.format
  L10_2 = table
  L10_2 = L10_2.concat
  L11_2 = tostring
  L12_2 = error
  L13_2 = pairs
  function L14_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3
    L3_3 = L4_2
    L4_3 = L3_2
    L5_3 = A0_3
    L6_3 = A1_3
    L4_3 = L4_3(L5_3, L6_3)
    L5_3 = L2_2
    L6_3 = 1
    L7_3 = A2_3
    L5_3 = L5_3(L6_3, L7_3)
    L5_3 = L5_3 - 1
    return L3_3(L4_3, L5_3)
  end
  function L15_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L1_3 = {}
    L2_3 = {}
    L3_3 = 1
    L4_3 = 65
    L5_3 = 1
    for L6_3 = L3_3, L4_3, L5_3 do
      L7_3 = L6_2
      L8_3 = L8_2
      L9_3 = A0_3
      L10_3 = L6_3
      L11_3 = L6_3
      L7_3 = L7_3(L8_3(L9_3, L10_3, L11_3))
      if not L7_3 then
        L7_3 = 32
      end
      L8_3 = L2_3[L7_3]
      if L8_3 ~= nil then
        L8_3 = L12_2
        L9_3 = "invalid alphabet: duplicate character "
        L10_3 = L11_2
        L11_3 = L7_3
        L10_3 = L10_3(L11_3)
        L9_3 = L9_3 .. L10_3
        L10_3 = 3
        L8_3(L9_3, L10_3)
      end
      L8_3 = L6_3 - 1
      L9_3 = L7_3
      L1_3[L8_3] = L9_3
      L8_3 = L6_3 - 1
      L2_3[L7_3] = L8_3
    end
    L3_3 = L1_3
    L4_3 = L2_3
    return L3_3, L4_3
  end
  L16_2 = {}
  L17_2 = {}
  L18_2 = L15_2
  L19_2 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
  L18_2, L19_2 = L18_2(L19_2)
  L17_2.base64 = L19_2
  L16_2.base64 = L18_2
  L18_2 = L15_2
  L19_2 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
  L18_2, L19_2 = L18_2(L19_2)
  L17_2.base64url = L19_2
  L16_2.base64url = L18_2
  L18_2 = {}
  function L19_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3
    L2_3 = type
    L3_3 = A1_3
    L2_3 = L2_3(L3_3)
    if L2_3 == "string" then
      L4_3 = A1_3
      L3_3 = A1_3.len
      L3_3 = L3_3(L4_3)
      if L3_3 == 64 then
        goto lbl_14
      end
    end
    L5_3 = A1_3
    L4_3 = A1_3.len
    L4_3 = L4_3(L5_3)
    ::lbl_14::
    if L4_3 == 65 then
      L2_3 = L16_2
      L3_3 = L17_2
      L4_3 = L15_2
      L5_3 = A1_3
      L4_3, L5_3 = L4_3(L5_3)
      L3_3[A1_3] = L5_3
      L2_3[A1_3] = L4_3
      L2_3 = A0_3[A1_3]
      return L2_3
    end
  end
  L18_2.__index = L19_2
  L19_2 = setmetatable
  L20_2 = L16_2
  L21_2 = L18_2
  L19_2(L20_2, L21_2)
  L19_2 = setmetatable
  L20_2 = L17_2
  L21_2 = L18_2
  L19_2(L20_2, L21_2)
  L19_2 = "encode"
  function L20_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3
    L2_3 = L16_2
    L3_3 = A1_3
    if not L3_3 then
      L3_3 = "base64"
    end
    L2_3 = L2_3[L3_3]
    if not L2_3 then
      L2_3 = L12_2
      L3_3 = "invalid alphabet specified"
      L4_3 = 2
      L2_3 = L2_3(L3_3, L4_3)
    end
    A1_3 = L2_3
    L2_3 = L11_2
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    A0_3 = L2_3
    L2_3 = {}
    L3_3 = 1
    L4_3 = #A0_3
    L5_3 = L4_3 % 3
    L6_3 = {}
    L7_3 = 1
    L8_3 = L4_3 - L5_3
    L9_3 = 3
    for L10_3 = L7_3, L8_3, L9_3 do
      L11_3 = L6_2
      L12_3 = A0_3
      L13_3 = L10_3
      L14_3 = L10_3 + 2
      L11_3, L12_3, L13_3 = L11_3(L12_3, L13_3, L14_3)
      L14_3 = L11_3 * 65536
      L15_3 = L12_3 * 256
      L14_3 = L14_3 + L15_3
      L14_3 = L14_3 + L13_3
      L15_3 = L6_3[L14_3]
      if not L15_3 then
        L16_3 = L5_2
        L17_3 = L14_2
        L18_3 = L14_3
        L19_3 = 18
        L20_3 = 6
        L17_3 = L17_3(L18_3, L19_3, L20_3)
        L17_3 = A1_3[L17_3]
        L18_3 = L14_2
        L19_3 = L14_3
        L20_3 = 12
        L21_3 = 6
        L18_3 = L18_3(L19_3, L20_3, L21_3)
        L18_3 = A1_3[L18_3]
        L19_3 = L14_2
        L20_3 = L14_3
        L21_3 = 6
        L22_3 = 6
        L19_3 = L19_3(L20_3, L21_3, L22_3)
        L19_3 = A1_3[L19_3]
        L20_3 = L14_2
        L21_3 = L14_3
        L22_3 = 0
        L23_3 = 6
        L20_3 = L20_3(L21_3, L22_3, L23_3)
        L20_3 = A1_3[L20_3]
        L16_3 = L16_3(L17_3, L18_3, L19_3, L20_3)
        L15_3 = L16_3
        L16_3 = L15_3
        L6_3[L14_3] = L16_3
      end
      L16_3 = L15_3
      L2_3[L3_3] = L16_3
      L16_3 = L3_3 + 1
      L3_3 = L16_3
    end
    if L5_3 == 2 then
      L7_3 = L6_2
      L8_3 = A0_3
      L9_3 = L4_3 - 1
      L10_3 = L4_3
      L7_3, L8_3 = L7_3(L8_3, L9_3, L10_3)
      L9_3 = L7_3 * 65536
      L10_3 = L8_3 * 256
      L9_3 = L9_3 + L10_3
      L10_3 = L5_2
      L11_3 = L14_2
      L12_3 = L9_3
      L13_3 = 18
      L14_3 = 6
      L11_3 = L11_3(L12_3, L13_3, L14_3)
      L11_3 = A1_3[L11_3]
      L12_3 = L14_2
      L13_3 = L9_3
      L14_3 = 12
      L15_3 = 6
      L12_3 = L12_3(L13_3, L14_3, L15_3)
      L12_3 = A1_3[L12_3]
      L13_3 = L14_2
      L14_3 = L9_3
      L15_3 = 6
      L16_3 = 6
      L13_3 = L13_3(L14_3, L15_3, L16_3)
      L13_3 = A1_3[L13_3]
      L14_3 = A1_3[64]
      L10_3 = L10_3(L11_3, L12_3, L13_3, L14_3)
      L2_3[L3_3] = L10_3
    elseif L5_3 == 1 then
      L7_3 = L6_2
      L8_3 = A0_3
      L9_3 = L4_3
      L7_3 = L7_3(L8_3, L9_3)
      L7_3 = L7_3 * 65536
      L8_3 = L5_2
      L9_3 = L14_2
      L10_3 = L7_3
      L11_3 = 18
      L12_3 = 6
      L9_3 = L9_3(L10_3, L11_3, L12_3)
      L9_3 = A1_3[L9_3]
      L10_3 = L14_2
      L11_3 = L7_3
      L12_3 = 12
      L13_3 = 6
      L10_3 = L10_3(L11_3, L12_3, L13_3)
      L10_3 = A1_3[L10_3]
      L11_3 = A1_3[64]
      L12_3 = A1_3[64]
      L8_3 = L8_3(L9_3, L10_3, L11_3, L12_3)
      L2_3[L3_3] = L8_3
    end
    L7_3 = L10_2
    L8_3 = L2_3
    return L7_3(L8_3)
  end
  L1_2[L19_2] = L20_2
  L19_2 = "decode"
  function L20_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3
    L2_3 = L17_2
    L3_3 = A1_3
    if not L3_3 then
      L3_3 = "base64"
    end
    L2_3 = L2_3[L3_3]
    if not L2_3 then
      L2_3 = L12_2
      L3_3 = "invalid alphabet specified"
      L4_3 = 2
      L2_3 = L2_3(L3_3, L4_3)
    end
    A1_3 = L2_3
    L2_3 = "[^%w%+%/%=]"
    if A1_3 then
      L3_3 = nil
      L4_3 = nil
      L5_3 = L13_2
      L6_3 = A1_3
      L5_3, L6_3, L7_3 = L5_3(L6_3)
      for L8_3, L9_3 in L5_3, L6_3, L7_3 do
        if L9_3 == 62 then
          L10_3 = L8_3
          L3_3 = L10_3
        elseif L9_3 == 63 then
          L10_3 = L8_3
          L4_3 = L10_3
        end
      end
      L5_3 = L9_2
      L6_3 = "[^%%w%%%s%%%s%%=]"
      L7_3 = L5_2
      L8_3 = L3_3
      L7_3 = L7_3(L8_3)
      L8_3 = L5_2
      L9_3 = L4_3
      L5_3 = L5_3(L6_3, L7_3, L8_3(L9_3))
      L2_3 = L5_3
    end
    L3_3 = L7_2
    L4_3 = L11_2
    L5_3 = A0_3
    L4_3 = L4_3(L5_3)
    L5_3 = L2_3
    L6_3 = ""
    L3_3 = L3_3(L4_3, L5_3, L6_3)
    A0_3 = L3_3
    L3_3 = {}
    L4_3 = {}
    L5_3 = 1
    L6_3 = #A0_3
    L7_3 = L8_2
    L8_3 = A0_3
    L9_3 = -2
    L7_3 = L7_3(L8_3, L9_3)
    L7_3 = L7_3 == "=="
    if L7_3 then
      L7_3 = 2
    end
    if not L7_3 then
      L7_3 = L8_2
      L8_3 = A0_3
      L9_3 = -1
      L7_3 = L7_3(L8_3, L9_3)
      L7_3 = L7_3 == "="
      if L7_3 then
        L7_3 = 1
      end
    end
    if not L7_3 then
      L7_3 = 0
    end
    L8_3 = 1
    L9_3 = not (L7_3 <= 0)
    if L9_3 then
      L9_3 = L6_3 - 4
    end
    if not L9_3 then
      L9_3 = L6_3
    end
    L10_3 = 4
    for L11_3 = L8_3, L9_3, L10_3 do
      L12_3 = L6_2
      L13_3 = A0_3
      L14_3 = L11_3
      L15_3 = L11_3 + 3
      L12_3, L13_3, L14_3, L15_3 = L12_3(L13_3, L14_3, L15_3)
      L16_3 = L12_3 * 16777216
      L17_3 = L13_3 * 65536
      L16_3 = L16_3 + L17_3
      L17_3 = L14_3 * 256
      L16_3 = L16_3 + L17_3
      L16_3 = L16_3 + L15_3
      L17_3 = L3_3[L16_3]
      if not L17_3 then
        L18_3 = A1_3[L12_3]
        L18_3 = L18_3 * 262144
        L19_3 = A1_3[L13_3]
        L19_3 = L19_3 * 4096
        L18_3 = L18_3 + L19_3
        L19_3 = A1_3[L14_3]
        L19_3 = L19_3 * 64
        L18_3 = L18_3 + L19_3
        L19_3 = A1_3[L15_3]
        L18_3 = L18_3 + L19_3
        L19_3 = L5_2
        L20_3 = L14_2
        L21_3 = L18_3
        L22_3 = 16
        L23_3 = 8
        L20_3 = L20_3(L21_3, L22_3, L23_3)
        L21_3 = L14_2
        L22_3 = L18_3
        L23_3 = 8
        L24_3 = 8
        L21_3 = L21_3(L22_3, L23_3, L24_3)
        L22_3 = L14_2
        L23_3 = L18_3
        L24_3 = 0
        L25_3 = 8
        L19_3 = L19_3(L20_3, L21_3, L22_3(L23_3, L24_3, L25_3))
        L17_3 = L19_3
        L19_3 = L17_3
        L3_3[L16_3] = L19_3
      end
      L18_3 = L17_3
      L4_3[L5_3] = L18_3
      L18_3 = L5_3 + 1
      L5_3 = L18_3
    end
    if L7_3 == 1 then
      L8_3 = L6_2
      L9_3 = A0_3
      L10_3 = L6_3 - 3
      L11_3 = L6_3 - 1
      L8_3, L9_3, L10_3 = L8_3(L9_3, L10_3, L11_3)
      L11_3 = A1_3[L8_3]
      L11_3 = L11_3 * 262144
      L12_3 = A1_3[L9_3]
      L12_3 = L12_3 * 4096
      L11_3 = L11_3 + L12_3
      L12_3 = A1_3[L10_3]
      L12_3 = L12_3 * 64
      L11_3 = L11_3 + L12_3
      L12_3 = L5_2
      L13_3 = L14_2
      L14_3 = L11_3
      L15_3 = 16
      L16_3 = 8
      L13_3 = L13_3(L14_3, L15_3, L16_3)
      L14_3 = L14_2
      L15_3 = L11_3
      L16_3 = 8
      L17_3 = 8
      L12_3 = L12_3(L13_3, L14_3(L15_3, L16_3, L17_3))
      L4_3[L5_3] = L12_3
    elseif L7_3 == 2 then
      L8_3 = L6_2
      L9_3 = A0_3
      L10_3 = L6_3 - 3
      L11_3 = L6_3 - 2
      L8_3, L9_3 = L8_3(L9_3, L10_3, L11_3)
      L10_3 = A1_3[L8_3]
      L10_3 = L10_3 * 262144
      L11_3 = A1_3[L9_3]
      L11_3 = L11_3 * 4096
      L10_3 = L10_3 + L11_3
      L11_3 = L5_2
      L12_3 = L14_2
      L13_3 = L10_3
      L14_3 = 16
      L15_3 = 8
      L11_3 = L11_3(L12_3(L13_3, L14_3, L15_3))
      L4_3[L5_3] = L11_3
    end
    L8_3 = L10_2
    L9_3 = L4_3
    return L8_3(L9_3)
  end
  L1_2[L19_2] = L20_2
  L19_2 = {}
  L20_2 = "A"
  L21_2 = "B"
  L22_2 = "C"
  L23_2 = "D"
  L24_2 = "E"
  L25_2 = "F"
  L26_2 = "G"
  L27_2 = "H"
  L28_2 = "I"
  L29_2 = "J"
  L30_2 = "K"
  L31_2 = "L"
  L32_2 = "M"
  L33_2 = "N"
  L34_2 = "O"
  L35_2 = "P"
  L36_2 = "Q"
  L37_2 = "R"
  L38_2 = "S"
  L39_2 = "T"
  L40_2 = "U"
  L41_2 = "V"
  L42_2 = "W"
  L43_2 = "X"
  L44_2 = "Y"
  L45_2 = "Z"
  L46_2 = "a"
  L47_2 = "b"
  L48_2 = "c"
  L49_2 = "d"
  L50_2 = "e"
  L51_2 = "f"
  L52_2 = "g"
  L53_2 = "h"
  L54_2 = "i"
  L55_2 = "j"
  L56_2 = "k"
  L57_2 = "l"
  L58_2 = "m"
  L59_2 = "n"
  L60_2 = "o"
  L61_2 = "p"
  L62_2 = "q"
  L63_2 = "r"
  L64_2 = "s"
  L65_2 = "t"
  L66_2 = "u"
  L67_2 = "v"
  L68_2 = "w"
  L69_2 = "x"
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L19_2[4] = L23_2
  L19_2[5] = L24_2
  L19_2[6] = L25_2
  L19_2[7] = L26_2
  L19_2[8] = L27_2
  L19_2[9] = L28_2
  L19_2[10] = L29_2
  L19_2[11] = L30_2
  L19_2[12] = L31_2
  L19_2[13] = L32_2
  L19_2[14] = L33_2
  L19_2[15] = L34_2
  L19_2[16] = L35_2
  L19_2[17] = L36_2
  L19_2[18] = L37_2
  L19_2[19] = L38_2
  L19_2[20] = L39_2
  L19_2[21] = L40_2
  L19_2[22] = L41_2
  L19_2[23] = L42_2
  L19_2[24] = L43_2
  L19_2[25] = L44_2
  L19_2[26] = L45_2
  L19_2[27] = L46_2
  L19_2[28] = L47_2
  L19_2[29] = L48_2
  L19_2[30] = L49_2
  L19_2[31] = L50_2
  L19_2[32] = L51_2
  L19_2[33] = L52_2
  L19_2[34] = L53_2
  L19_2[35] = L54_2
  L19_2[36] = L55_2
  L19_2[37] = L56_2
  L19_2[38] = L57_2
  L19_2[39] = L58_2
  L19_2[40] = L59_2
  L19_2[41] = L60_2
  L19_2[42] = L61_2
  L19_2[43] = L62_2
  L19_2[44] = L63_2
  L19_2[45] = L64_2
  L19_2[46] = L65_2
  L19_2[47] = L66_2
  L19_2[48] = L67_2
  L19_2[49] = L68_2
  L19_2[50] = L69_2
  L20_2 = "y"
  L21_2 = "z"
  L22_2 = "0"
  L23_2 = "1"
  L24_2 = "2"
  L25_2 = "3"
  L26_2 = "4"
  L27_2 = "5"
  L28_2 = "6"
  L29_2 = "7"
  L30_2 = "8"
  L31_2 = "9"
  L32_2 = "+"
  L33_2 = "/"
  L34_2 = "="
  L19_2[51] = L20_2
  L19_2[52] = L21_2
  L19_2[53] = L22_2
  L19_2[54] = L23_2
  L19_2[55] = L24_2
  L19_2[56] = L25_2
  L19_2[57] = L26_2
  L19_2[58] = L27_2
  L19_2[59] = L28_2
  L19_2[60] = L29_2
  L19_2[61] = L30_2
  L19_2[62] = L31_2
  L19_2[63] = L32_2
  L19_2[64] = L33_2
  L19_2[65] = L34_2
  L20_2 = {}
  L21_2 = "v"
  L22_2 = "u"
  L23_2 = "m"
  L24_2 = "d"
  L25_2 = "2"
  L26_2 = "1"
  L27_2 = "4"
  L28_2 = "p"
  L29_2 = "t"
  L30_2 = "x"
  L31_2 = "c"
  L32_2 = "G"
  L33_2 = "f"
  L34_2 = "6"
  L35_2 = "7"
  L36_2 = "L"
  L37_2 = "Y"
  L38_2 = "C"
  L39_2 = "T"
  L40_2 = "j"
  L41_2 = "O"
  L42_2 = "y"
  L43_2 = "W"
  L44_2 = "F"
  L45_2 = "+"
  L46_2 = "R"
  L47_2 = "w"
  L48_2 = "V"
  L49_2 = "="
  L50_2 = "9"
  L51_2 = "E"
  L52_2 = "a"
  L53_2 = "U"
  L54_2 = "r"
  L55_2 = "N"
  L56_2 = "P"
  L57_2 = "k"
  L58_2 = "0"
  L59_2 = "o"
  L60_2 = "g"
  L61_2 = "l"
  L62_2 = "M"
  L63_2 = "X"
  L64_2 = "D"
  L65_2 = "e"
  L66_2 = "Q"
  L67_2 = "I"
  L68_2 = "8"
  L69_2 = "q"
  L70_2 = "B"
  L20_2[1] = L21_2
  L20_2[2] = L22_2
  L20_2[3] = L23_2
  L20_2[4] = L24_2
  L20_2[5] = L25_2
  L20_2[6] = L26_2
  L20_2[7] = L27_2
  L20_2[8] = L28_2
  L20_2[9] = L29_2
  L20_2[10] = L30_2
  L20_2[11] = L31_2
  L20_2[12] = L32_2
  L20_2[13] = L33_2
  L20_2[14] = L34_2
  L20_2[15] = L35_2
  L20_2[16] = L36_2
  L20_2[17] = L37_2
  L20_2[18] = L38_2
  L20_2[19] = L39_2
  L20_2[20] = L40_2
  L20_2[21] = L41_2
  L20_2[22] = L42_2
  L20_2[23] = L43_2
  L20_2[24] = L44_2
  L20_2[25] = L45_2
  L20_2[26] = L46_2
  L20_2[27] = L47_2
  L20_2[28] = L48_2
  L20_2[29] = L49_2
  L20_2[30] = L50_2
  L20_2[31] = L51_2
  L20_2[32] = L52_2
  L20_2[33] = L53_2
  L20_2[34] = L54_2
  L20_2[35] = L55_2
  L20_2[36] = L56_2
  L20_2[37] = L57_2
  L20_2[38] = L58_2
  L20_2[39] = L59_2
  L20_2[40] = L60_2
  L20_2[41] = L61_2
  L20_2[42] = L62_2
  L20_2[43] = L63_2
  L20_2[44] = L64_2
  L20_2[45] = L65_2
  L20_2[46] = L66_2
  L20_2[47] = L67_2
  L20_2[48] = L68_2
  L20_2[49] = L69_2
  L20_2[50] = L70_2
  L21_2 = "/"
  L22_2 = "i"
  L23_2 = "b"
  L24_2 = "H"
  L25_2 = "A"
  L26_2 = "n"
  L27_2 = "3"
  L28_2 = "J"
  L29_2 = "S"
  L30_2 = "s"
  L31_2 = "K"
  L32_2 = "z"
  L33_2 = "Z"
  L34_2 = "5"
  L35_2 = "h"
  L20_2[51] = L21_2
  L20_2[52] = L22_2
  L20_2[53] = L23_2
  L20_2[54] = L24_2
  L20_2[55] = L25_2
  L20_2[56] = L26_2
  L20_2[57] = L27_2
  L20_2[58] = L28_2
  L20_2[59] = L29_2
  L20_2[60] = L30_2
  L20_2[61] = L31_2
  L20_2[62] = L32_2
  L20_2[63] = L33_2
  L20_2[64] = L34_2
  L20_2[65] = L35_2
  L21_2 = {}
  L22_2 = {}
  L23_2 = 1
  L24_2 = #L19_2
  L25_2 = 1
  for L26_2 = L23_2, L24_2, L25_2 do
    L27_2 = L19_2[L26_2]
    L28_2 = L20_2[L26_2]
    L21_2[L27_2] = L28_2
    L27_2 = L20_2[L26_2]
    L28_2 = L19_2[L26_2]
    L22_2[L27_2] = L28_2
  end
  L23_2 = "encrypt"
  function L24_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L1_3 = ""
    L2_3 = L1_2
    L2_3 = L2_3.encode
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    L3_3 = 1
    L5_3 = L2_3
    L4_3 = L2_3.len
    L4_3 = L4_3(L5_3)
    L5_3 = 1
    for L6_3 = L3_3, L4_3, L5_3 do
      L7_3 = L1_3
      L8_3 = L21_2
      L10_3 = L2_3
      L9_3 = L2_3.sub
      L11_3 = L6_3
      L12_3 = L6_3
      L9_3 = L9_3(L10_3, L11_3, L12_3)
      L8_3 = L8_3[L9_3]
      L7_3 = L7_3 .. L8_3
      L1_3 = L7_3
    end
    L3_3 = L1_3
    return L3_3
  end
  L1_2[L23_2] = L24_2
  L23_2 = "decrypt"
  function L24_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L1_3 = ""
    L2_3 = 1
    L4_3 = A0_3
    L3_3 = A0_3.len
    L3_3 = L3_3(L4_3)
    L4_3 = 1
    for L5_3 = L2_3, L3_3, L4_3 do
      L6_3 = L1_3
      L7_3 = L22_2
      L9_3 = A0_3
      L8_3 = A0_3.sub
      L10_3 = L5_3
      L11_3 = L5_3
      L8_3 = L8_3(L9_3, L10_3, L11_3)
      L7_3 = L7_3[L8_3]
      L6_3 = L6_3 .. L7_3
      L1_3 = L6_3
    end
    L2_3 = L1_2
    L2_3 = L2_3.decode
    L3_3 = L1_3
    return L2_3(L3_3)
  end
  L1_2[L23_2] = L24_2
  L23_2 = L1_2
  return L23_2
end
L11_1 = L11_1()
L12_1 = 6713813961572992
L13_1 = 1488
function L14_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = {}
  L1_2 = 0
  L2_2 = 127
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = -1
    repeat
      L6_2 = L5_2 + 2
      L5_2 = L6_2
      L6_2 = 2 * L4_2
      L6_2 = L6_2 + 1
      L6_2 = L5_2 * L6_2
      L6_2 = L6_2 % 256
    until L6_2 == 1
    L6_2 = L5_2
    L0_2[L4_2] = L6_2
  end
  L1_2 = L0_2
  return L1_2
end
L15_1 = "Astra"
L16_1 = "loader-Astra"
L17_1 = false
L18_1 = false
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L14_1
  L1_2 = L1_2()
  L2_2 = L12_1
  L3_2 = L13_1
  L3_2 = 16384 + L3_2
  L5_2 = A0_2
  L4_2 = A0_2.gsub
  L6_2 = "."
  function L7_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L1_3 = L2_2
    L1_3 = L1_3 % 274877906944
    L2_3 = L2_2
    L2_3 = L2_3 - L1_3
    L2_3 = L2_3 / 274877906944
    L3_3 = L2_3 % 128
    L5_3 = A0_3
    L4_3 = A0_3.byte
    L4_3 = L4_3(L5_3)
    L5_3 = L1_2
    L5_3 = L5_3[L3_3]
    L5_3 = L4_3 * L5_3
    L6_3 = L2_3 - L3_3
    L6_3 = L6_3 / 128
    L5_3 = L5_3 - L6_3
    L5_3 = L5_3 % 256
    L6_3 = L3_2
    L6_3 = L1_3 * L6_3
    L6_3 = L6_3 + L2_3
    L6_3 = L6_3 + L5_3
    L6_3 = L6_3 + L4_3
    L2_2 = L6_3
    L6_3 = "%02x"
    L7_3 = L6_3
    L6_3 = L6_3.format
    L8_3 = L5_3
    return L6_3(L7_3, L8_3)
  end
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  return L4_2
end
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L12_1
  L2_2 = L13_1
  L2_2 = 16384 + L2_2
  L4_2 = A0_2
  L3_2 = A0_2.gsub
  L5_2 = "%x%x"
  function L6_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L1_3 = L1_2
    L1_3 = L1_3 % 274877906944
    L2_3 = L1_2
    L2_3 = L2_3 - L1_3
    L2_3 = L2_3 / 274877906944
    L3_3 = L2_3 % 128
    L4_3 = tonumber
    L5_3 = A0_3
    L6_3 = 16
    L4_3 = L4_3(L5_3, L6_3)
    L5_3 = L2_3 - L3_3
    L5_3 = L5_3 / 128
    L5_3 = L4_3 + L5_3
    L6_3 = 2 * L3_3
    L6_3 = L6_3 + 1
    L5_3 = L5_3 * L6_3
    L5_3 = L5_3 % 256
    L6_3 = L2_2
    L6_3 = L1_3 * L6_3
    L6_3 = L6_3 + L2_3
    L6_3 = L6_3 + L4_3
    L6_3 = L6_3 + L5_3
    L1_2 = L6_3
    L6_3 = string
    L6_3 = L6_3.char
    L7_3 = L5_3
    return L6_3(L7_3)
  end
  return L3_2(L4_2, L5_2, L6_2)
end
L21_1 = vtable_bind
L22_1 = "filesystem_stdio.dll"
L23_1 = "VBaseFileSystem011"
L24_1 = 0
L25_1 = "int(__thiscall*)(void* _this, void* buf, int size, void* hFile)"
L21_1 = L21_1(L22_1, L23_1, L24_1, L25_1)
L22_1 = vtable_bind
L23_1 = "filesystem_stdio.dll"
L24_1 = "VBaseFileSystem011"
L25_1 = 2
L26_1 = "void*(__thiscall*)(void* _this, const char* path, const char* mode, const char* base)"
L22_1 = L22_1(L23_1, L24_1, L25_1, L26_1)
L23_1 = vtable_bind
L24_1 = "filesystem_stdio.dll"
L25_1 = "VBaseFileSystem011"
L26_1 = 3
L27_1 = "void(__thiscall*)(void* _this, void* hFile)"
L23_1 = L23_1(L24_1, L25_1, L26_1, L27_1)
L24_1 = vtable_bind
L25_1 = "filesystem_stdio.dll"
L26_1 = "VBaseFileSystem011"
L27_1 = 7
L28_1 = "unsigned int(__thiscall*)(void* _this, void* hFile)"
L24_1 = L24_1(L25_1, L26_1, L27_1, L28_1)
function L25_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L22_1
  L2_2 = A0_2
  L3_2 = "r"
  L4_2 = "GAME"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = false
  if L1_2 then
    L3_2 = L24_1
    L4_2 = L1_2
    L3_2 = L3_2(L4_2)
    if 0 < L3_2 then
      L4_2 = true
      L2_2 = L4_2
    end
  end
  L3_2 = L2_2
  return L3_2
end
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L22_1
  L2_2 = A0_2
  L3_2 = "r"
  L4_2 = "GAME"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    L2_2 = L24_1
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    L3_2 = L1_1
    L3_2 = L3_2.new
    L4_2 = "char[?]"
    L5_2 = L2_2 + 1
    L3_2 = L3_2(L4_2, L5_2)
    L4_2 = {}
    function L5_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = L21_1
      L1_3 = L3_2
      L2_3 = L2_2
      L3_3 = L1_2
      L0_3 = L0_3(L1_3, L2_3, L3_3)
      if L0_3 then
        L0_3 = L1_1
        L0_3 = L0_3.string
        L1_3 = L3_2
        L2_3 = L2_2
        L0_3 = L0_3(L1_3, L2_3)
      end
      if not L0_3 then
        L0_3 = nil
      end
      return L0_3
    end
    L4_2.get = L5_2
    function L5_2()
      local L0_3, L1_3
      L0_3 = L23_1
      L1_3 = L1_2
      L0_3(L1_3)
    end
    L4_2.free = L5_2
    return L4_2
  end
end
L27_1 = L26_1
L28_1 = "../"
L29_1 = _NAME
L30_1 = ".lua"
L28_1 = L28_1 .. L29_1 .. L30_1
L27_1 = L27_1(L28_1)
L28_1 = L27_1
L27_1 = L27_1.get
L27_1 = L27_1(L28_1)
L29_1 = L27_1
L28_1 = L27_1.sub
L30_1 = 0
L31_1 = 6
L28_1 = L28_1(L29_1, L30_1, L31_1)
-- if L28_1 ~= "return" then
--   L28_1 = error
--   L29_1 = "redownload loader (13)"
--   L28_1(L29_1)
-- end
L27_1 = L25_1
L28_1 = "../gamesense/websockets.lua"
L27_1 = L27_1(L28_1)
-- if L27_1 then
--   L27_1 = error
--   L28_1 = "remove or rename websockets.lua in gamesense directory, subscribe to workshop library"
--   L27_1(L28_1)
-- end
L27_1 = require
L28_1 = "gamesense/websockets"
L27_1 = L27_1(L28_1)
if not L27_1 then
  L27_1 = error
  L28_1 = "failed to load library: gamesense/websockets - make sure ur subscribed to: https://gamesense.pub/forums/viewtopic.php?id=23653"
  L27_1 = L27_1(L28_1)
end
L28_1 = {}
L29_1 = "bit"
L30_1 = "client"
L31_1 = "config"
L32_1 = "cvar"
L33_1 = "database"
L34_1 = "entity"
L35_1 = "globals"
L36_1 = "json"
L37_1 = "panorama"
L38_1 = "materialsystem"
L39_1 = "renderer"
L40_1 = "plist"
L41_1 = "ui"
L42_1 = "loadstring"
L43_1 = "tostring"
L44_1 = "load"
L45_1 = "setmetatable"
L46_1 = "getmetatable"
L47_1 = "getfenv"
L48_1 = "pcall"
L49_1 = "require"
L50_1 = "hwid"
L51_1 = "hardwareid"
L52_1 = "adapter"
L53_1 = "ws"
L54_1 = "websocket"
L28_1[1] = L29_1
L28_1[2] = L30_1
L28_1[3] = L31_1
L28_1[4] = L32_1
L28_1[5] = L33_1
L28_1[6] = L34_1
L28_1[7] = L35_1
L28_1[8] = L36_1
L28_1[9] = L37_1
L28_1[10] = L38_1
L28_1[11] = L39_1
L28_1[12] = L40_1
L28_1[13] = L41_1
L28_1[14] = L42_1
L28_1[15] = L43_1
L28_1[16] = L44_1
L28_1[17] = L45_1
L28_1[18] = L46_1
L28_1[19] = L47_1
L28_1[20] = L48_1
L28_1[21] = L49_1
L28_1[22] = L50_1
L28_1[23] = L51_1
L28_1[24] = L52_1
L28_1[25] = L53_1
L28_1[26] = L54_1
L29_1 = "ws://85.209.176.35:1487"
storing_table_websocket_server = L29_1
L29_1 = "session_not_logged_in"
storing_table_session_id = L29_1
L29_1 = "user_not_logged_in"
storing_table_username = L29_1
L29_1 = "user_not_logged_in"
storing_table_password = L29_1
L29_1 = L11_1.encode
L30_1 = L10_1
L29_1 = L29_1(L30_1)
storing_table_hwid = L29_1
L29_1 = "build_not_logged_in"
storing_table_user_build = L29_1
L29_1 = "script_version_not_ready"
storing_table_script_version = L29_1
L29_1 = "1.8"
storing_table_loader_version = L29_1
L29_1 = nil
storing_table_websocket_connection = L29_1
L29_1 = _G
L30_1 = {}
L30_1.zalupa = false
L30_1.tidolbaeb = true
L30_1.mamuebal = true
L30_1.poshelnahuy = true
L30_1.slavarossii = "pizdahohlam"
L30_1.ZV = true
L30_1.get_trolled_shithead = true
L29_1.astra = L30_1
function L29_1(A0_2)
  error("don't ban me")
  -- local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  -- L1_2 = storing_table_websocket_connection
  -- if L1_2 == nil then
  --   return
  -- end
  -- L1_2 = storing_table_websocket_connection
  -- L2_2 = L1_2
  -- L1_2 = L1_2.send
  -- L3_2 = json
  -- L3_2 = L3_2.stringify
  -- L4_2 = {}
  -- L5_2 = L19_1
  -- L6_2 = "security"
  -- L5_2 = L5_2(L6_2)
  -- L4_2.msg_type = L5_2
  -- L5_2 = storing_table_session_id
  -- L4_2.msg_data = L5_2
  -- L5_2 = storing_table_username
  -- L4_2.msg_username = L5_2
  -- L5_2 = storing_table_password
  -- L4_2.msg_password = L5_2
  -- L5_2 = L19_1
  -- L6_2 = A0_2
  -- L5_2 = L5_2(L6_2)
  -- L4_2.msg_violation = L5_2
  -- L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  -- L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
  -- while true do
  --   L1_2 = client
  --   L1_2 = L1_2.exec
  --   L2_2 = "clear"
  --   L1_2(L2_2)
  --   L1_2 = "0x10"
  -- end
end
L30_1 = {}
L30_1.username = ""
L30_1.password = ""
function L31_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = "(%d+%.%d+%.%d+%.%d+)"
  L1_2 = storing_table_websocket_server
  L2_2 = L1_2
  L1_2 = L1_2.match
  L3_2 = L0_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = 65
  L3_2 = 90
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = string
    L6_2 = L6_2.char
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    L7_2 = ":\\Windows\\System32\\drivers\\etc\\hosts"
    L6_2 = L6_2 .. L7_2
    L7_2 = readfile
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      L9_2 = L7_2
      L8_2 = L7_2.find
      L10_2 = L1_2
      L8_2 = L8_2(L9_2, L10_2)
      if L8_2 then
        L8_2 = L29_1
        L9_2 = "Windows host file modified"
        L8_2(L9_2)
      end
    end
    L8_2 = readfile
    L9_2 = string
    L9_2 = L9_2.char
    L10_2 = L5_2
    L9_2 = L9_2(L10_2)
    L10_2 = ":\\Program Files (x86)\\Steam\\logs\\ipc_SteamClient.log"
    L9_2 = L9_2 .. L10_2
    L8_2 = L8_2(L9_2)
    if L8_2 then
      L9_2 = L29_1
      L10_2 = "Steam HTTP debugger"
      L9_2(L10_2)
    end
  end
end
function L32_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L0_2 = 0
  L1_2 = pairs
  L2_2 = _G
  L1_2, L2_2, L3_2 = L1_2(L2_2)
  for L4_2, L5_2 in L1_2, L2_2, L3_2 do
    L6_2 = L0_2 + 1
    L0_2 = L6_2
  end
  if L0_2 ~= 58 then
    L1_2 = L29_1
    L2_2 = "Dumping"
    L1_2(L2_2)
    return
  end
  L1_2 = pairs
  L2_2 = _G
  L2_2 = L2_2.package
  L2_2 = L2_2.loaded
  L1_2, L2_2, L3_2 = L1_2(L2_2)
  for L4_2, L5_2 in L1_2, L2_2, L3_2 do
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if L6_2 == "boolean" then
      L6_2 = L26_1
      L7_2 = "../"
      L8_2 = _NAME
      L9_2 = ".lua"
      L7_2 = L7_2 .. L8_2 .. L9_2
      L6_2 = L6_2(L7_2)
      L7_2 = L6_2
      L6_2 = L6_2.get
      L6_2 = L6_2(L7_2)
      L7_2 = ipairs
      L8_2 = L28_1
      L7_2, L8_2, L9_2 = L7_2(L8_2)
      for L10_2, L11_2 in L7_2, L8_2, L9_2 do
        if L6_2 then
          L13_2 = L6_2
          L12_2 = L6_2.find
          L14_2 = "_G."
          L15_2 = L11_2
          L16_2 = "."
          L14_2 = L14_2 .. L15_2 .. L16_2
          L12_2 = L12_2(L13_2, L14_2)
          if not L12_2 then
            L13_2 = L6_2
            L12_2 = L6_2.find
            L14_2 = "_G.."
            L15_2 = L11_2
            L16_2 = "."
            L14_2 = L14_2 .. L15_2 .. L16_2
            L12_2 = L12_2(L13_2, L14_2)
            if not L12_2 then
              goto lbl_60
            end
          end
          L12_2 = L29_1
          L13_2 = "Modifying protected variables"
          L12_2(L13_2)
        end
        ::lbl_60::
      end
    end
  end
  L1_2 = _G
  L1_2 = L1_2.package
  L1_2 = L1_2.loaded
  L2_2 = _NAME
  L1_2 = L1_2[L2_2]
  if not L1_2 then
    L1_2 = L29_1
    L2_2 = "Modifying protected variables [2]"
    L1_2(L2_2)
  end
end
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = pcall
  L2_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2)
  L3_2 = coroutine
  L3_2 = L3_2.resume
  L4_2 = coroutine
  L4_2 = L4_2.create
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L4_2(L5_2)
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  L5_2 = L1_2 == L3_2
  L6_2 = L2_2 == L4_2
  L7_2 = L5_2
  if L7_2 then
    L7_2 = L6_2
  end
  L8_2 = L1_2
  L9_2 = L2_2
  return L7_2, L8_2, L9_2
end
function L34_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L0_2 = {}
  L1_2 = loadstring
  L2_2 = string
  L2_2 = L2_2.find
  L3_2 = tostring
  L4_2 = load
  L0_2[1] = L1_2
  L0_2[2] = L2_2
  L0_2[3] = L3_2
  L0_2[4] = L4_2
  L1_2 = next
  L2_2 = L0_2
  L3_2 = nil
  for L4_2, L5_2 in L1_2, L2_2, L3_2 do
    L6_2 = L33_1
    function L7_2()
      local L0_3, L1_3
      L0_3 = jit
      L0_3 = L0_3.flush
      L1_3 = L5_2
      L0_3(L1_3)
    end
    L6_2, L7_2 = L6_2(L7_2)
    L8_2 = L33_1
    function L9_2()
      local L0_3, L1_3, L2_3
      L0_3 = setfenv
      L1_3 = L5_2
      L2_3 = {}
      L0_3(L1_3, L2_3)
    end
    L8_2, L9_2 = L8_2(L9_2)
    L10_2 = L7_2
    if not L10_2 then
      L10_2 = L9_2
    end
    L11_2 = not L6_2
    if not L11_2 then
      L11_2 = not L8_2
    end
    if L10_2 or L11_2 then
      L12_2 = L29_1
      L13_2 = "Hook detected"
      L12_2(L13_2)
    end
  end
end
-- L35_1 = L31_1
-- L35_1()
-- L35_1 = L32_1
-- L35_1()
-- L35_1 = L34_1
-- L35_1()
-- function L35_1()
--   local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
--   L0_2 = pcall
--   function L1_2()
--     local L0_3, L1_3
--     L0_3 = _G
--     L0_3()
--   end
--   L0_2, L1_2 = L0_2(L1_2)
--   L2_2 = L0_2
--   if not L2_2 then
--     L3_2 = L1_2
--     L2_2 = L1_2.match
--     L4_2 = "\\(.*):[0-9]"
--     L2_2 = L2_2(L3_2, L4_2)
--     L3_2 = L2_2
--     L2_2 = L2_2.gsub
--     L4_2 = "\\"
--     L5_2 = "/"
--     L2_2 = L2_2(L3_2, L4_2, L5_2)
--   end
--   return L2_2
-- end
L36_1 = {}
function L37_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = A0_2
  storing_table_websocket_connection = L1_2
  L1_2 = L31_1
  L1_2()
  L1_2 = L32_1
  L1_2()
  L1_2 = database
  L1_2 = L1_2.read
  L2_2 = L16_1
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L1_2 = json
    L1_2 = L1_2.parse
    L2_2 = database
    L2_2 = L2_2.read
    L3_2 = L16_1
    L1_2 = L1_2(L2_2(L3_2))
    L2_2 = L1_2.username
    if L2_2 then
      L2_2 = L1_2.password
      if L2_2 then
        L2_2 = client
        L2_2 = L2_2.color_log
        L3_2 = 151
        L4_2 = 201
        L5_2 = 57
        L6_2 = string
        L6_2 = L6_2.lower
        L7_2 = L15_1
        L6_2 = L6_2(L7_2)
        L7_2 = " \226\128\162\000"
        L6_2 = L6_2 .. L7_2
        L2_2(L3_2, L4_2, L5_2, L6_2)
        L2_2 = client
        L2_2 = L2_2.color_log
        L3_2 = 255
        L4_2 = 255
        L5_2 = 255
        L6_2 = " Trying to log in as "
        L7_2 = L1_2.username
        L6_2 = L6_2 .. L7_2
        L2_2(L3_2, L4_2, L5_2, L6_2)
        L2_2 = L30_1
        L3_2 = L1_2.username
        L2_2.username = L3_2
        L2_2 = L30_1
        L3_2 = L1_2.password
        L2_2.password = L3_2
        L3_2 = A0_2
        L2_2 = A0_2.send
        L4_2 = json
        L4_2 = L4_2.stringify
        L5_2 = {}
        L6_2 = L19_1
        L7_2 = "login"
        L6_2 = L6_2(L7_2)
        L5_2.msg_type = L6_2
        L6_2 = L19_1
        L7_2 = L30_1
        L7_2 = L7_2.username
        L6_2 = L6_2(L7_2)
        L5_2.msg_username = L6_2
        L6_2 = L19_1
        L7_2 = L30_1
        L7_2 = L7_2.password
        L6_2 = L6_2(L7_2)
        L5_2.msg_password = L6_2
        L6_2 = storing_table_hwid
        L5_2.msg_hwid = L6_2
        L2_2(L3_2, L4_2(L5_2))
    end
    else
      L2_2 = client
      L2_2 = L2_2.color_log
      L3_2 = 151
      L4_2 = 201
      L5_2 = 57
      L6_2 = string
      L6_2 = L6_2.lower
      L7_2 = L15_1
      L6_2 = L6_2(L7_2)
      L7_2 = " \226\128\162\000"
      L6_2 = L6_2 .. L7_2
      L2_2(L3_2, L4_2, L5_2, L6_2)
      L2_2 = client
      L2_2 = L2_2.color_log
      L3_2 = 255
      L4_2 = 255
      L5_2 = 255
      L6_2 = " You are not logged in, type /help for instructions"
      L2_2(L3_2, L4_2, L5_2, L6_2)
    end
  else
    L1_2 = client
    L1_2 = L1_2.color_log
    L2_2 = 151
    L3_2 = 201
    L4_2 = 57
    L5_2 = string
    L5_2 = L5_2.lower
    L6_2 = L15_1
    L5_2 = L5_2(L6_2)
    L6_2 = " \226\128\162\000"
    L5_2 = L5_2 .. L6_2
    L1_2(L2_2, L3_2, L4_2, L5_2)
    L1_2 = client
    L1_2 = L1_2.color_log
    L2_2 = 255
    L3_2 = 255
    L4_2 = 255
    L5_2 = " You are not logged in, type /help for instructions"
    L1_2(L2_2, L3_2, L4_2, L5_2)
  end
  L2_2 = A0_2
  L1_2 = A0_2.send
  L3_2 = json
  L3_2 = L3_2.stringify
  L4_2 = {}
  L5_2 = L19_1
  L6_2 = "check_update_loader"
  L5_2 = L5_2(L6_2)
  L4_2.msg_type = L5_2
  L5_2 = L19_1
  L6_2 = storing_table_loader_version
  L5_2 = L5_2(L6_2)
  L4_2.msg_data = L5_2
  L1_2(L2_2, L3_2(L4_2))
end
L36_1.open = L37_1

local inspect = require("inspect")

function L37_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = json
  L2_2 = L2_2.parse
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = L20_1

  print(inspect(L2_2))

  print(L20_1(storing_table_username))
  print(L20_1(storing_table_user_build))

  L4_2 = L2_2.msg_type
  L3_2 = L3_2(L4_2)
  L4_2 = L2_2.msg_data
  L4_2 = L4_2 == nil
  if L4_2 then
    L4_2 = ""
  end
  if not L4_2 then
    L4_2 = L20_1
    L5_2 = L2_2.msg_data
    L4_2 = L4_2(L5_2)
  end
  if L3_2 == "msg" then
    L5_2 = client
    L5_2 = L5_2.color_log
    L6_2 = 151
    L7_2 = 201
    L8_2 = 57
    L9_2 = string
    L9_2 = L9_2.lower
    L10_2 = L15_1
    L9_2 = L9_2(L10_2)
    L10_2 = " \226\128\162\000"
    L9_2 = L9_2 .. L10_2
    L5_2(L6_2, L7_2, L8_2, L9_2)
    L5_2 = client
    L5_2 = L5_2.color_log
    L6_2 = 255
    L7_2 = 255
    L8_2 = 255
    L9_2 = " "
    L10_2 = L4_2
    L9_2 = L9_2 .. L10_2
    L5_2(L6_2, L7_2, L8_2, L9_2)
  end
  if L3_2 == "user_build" then
    L5_2 = L4_2
    storing_table_user_build = L5_2
  end
  if L3_2 == "loader_update" then
  end
  if L3_2 == "logged_in" then
    L5_2 = true
    L17_1 = L5_2
    L5_2 = L19_1
    L6_2 = L30_1
    L6_2 = L6_2.username
    L5_2 = L5_2(L6_2)
    storing_table_username = L5_2
    L5_2 = L19_1
    L6_2 = L30_1
    L6_2 = L6_2.password
    L5_2 = L5_2(L6_2)
    storing_table_password = L5_2
    L5_2 = database
    L5_2 = L5_2.write
    L6_2 = L16_1
    L7_2 = json
    L7_2 = L7_2.stringify
    L8_2 = L30_1
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L7_2(L8_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L5_2 = client
    L5_2 = L5_2.color_log
    L6_2 = 151
    L7_2 = 201
    L8_2 = 57
    L9_2 = string
    L9_2 = L9_2.lower
    L10_2 = L15_1
    L9_2 = L9_2(L10_2)
    L10_2 = " \226\128\162\000"
    L9_2 = L9_2 .. L10_2
    L5_2(L6_2, L7_2, L8_2, L9_2)
    L5_2 = client
    L5_2 = L5_2.color_log
    L6_2 = 255
    L7_2 = 255
    L8_2 = 255
    L9_2 = " "
    L10_2 = L4_2
    L9_2 = L9_2 .. L10_2
    L5_2(L6_2, L7_2, L8_2, L9_2)
  end
  if L3_2 == "check_update_loader" and L4_2 == "wrong" then
    L5_2 = client
    L5_2 = L5_2.color_log
    L6_2 = 151
    L7_2 = 201
    L8_2 = 57
    L9_2 = string
    L9_2 = L9_2.lower
    L10_2 = L15_1
    L9_2 = L9_2(L10_2)
    L10_2 = " \226\128\162\000"
    L9_2 = L9_2 .. L10_2
    L5_2(L6_2, L7_2, L8_2, L9_2)
    L5_2 = client
    L5_2 = L5_2.color_log
    L6_2 = 255
    L7_2 = 255
    L8_2 = 255
    L9_2 = " Wrong loader version, download new update from our discord"
    L5_2(L6_2, L7_2, L8_2, L9_2)
  end
  if L3_2 == "session_id" then
    L5_2 = L4_2
    storing_table_session_id = L5_2
  end
  if L3_2 == "load" then
    L5_2 = L31_1
    L5_2()
    L5_2 = L32_1
    L5_2()
    L5_2 = true
    L18_1 = L5_2
    L5_2 = tostring
    L6_2 = load
    L5_2 = L5_2(L6_2)
    L7_2 = L5_2
    L6_2 = L5_2.match
    L8_2 = "builtin"
    L6_2 = L6_2(L7_2, L8_2)
    L6_2 = L6_2 == nil
    if true then
      L7_2 = _G
      L7_2 = L7_2.astra
      L7_2.zalupa = true
      -- L7_2 = load
      writefile("astra_out_gg.lua", L11_1.decode(L2_2.msg_src))
      error("yeah")
      L8_2 = {}
      function L9_2(A0_3)
        local L1_3, L2_3
        L1_3 = L19_1
        L2_3 = A0_3
        return L1_3(L2_3)
      end
      L8_2.loader_encode_string = L9_2
      function L9_2(A0_3)
        local L1_3, L2_3
        L1_3 = L20_1
        L2_3 = A0_3
        return L1_3(L2_3)
      end
      L8_2.loader_decode_string = L9_2
      function L9_2()
        local L0_3, L1_3
        L0_3 = storing_table_username
        return L0_3
      end
      L8_2.loader_get_username = L9_2
      function L9_2()
        local L0_3, L1_3
        L0_3 = storing_table_password
        return L0_3
      end
      L8_2.loader_get_password = L9_2
      function L9_2()
        local L0_3, L1_3
        L0_3 = storing_table_session_id
        return L0_3
      end
      L8_2.loader_get_session_id = L9_2
      function L9_2()
        local L0_3, L1_3
        L0_3 = storing_table_hwid
        return L0_3
      end
      L8_2.loader_get_hwid = L9_2
      function L9_2()
        local L0_3, L1_3
        L0_3 = storing_table_user_build
        return L0_3
      end
      L8_2.loader_get_user_build = L9_2
      function L9_2()
        local L0_3, L1_3
        L0_3 = storing_table_loader_version
        return L0_3
      end
      L8_2.loader_get_loader_version = L9_2
      function L9_2()
        local L0_3, L1_3
        L0_3 = storing_table_script_version
        return L0_3
      end
      L8_2.loader_get_script_version = L9_2
      function L9_2()
        local L0_3, L1_3
        L0_3 = storing_table_websocket_server
        return L0_3
      end
      L8_2.loader_get_websocket_server = L9_2
      L9_2 = pairs
      L10_2 = _G
      L9_2, L10_2, L11_2 = L9_2(L10_2)
      for L12_2, L13_2 in L9_2, L10_2, L11_2 do
        L14_2 = L13_2
        L8_2[L12_2] = L14_2
      end
      L9_2 = setfenv
      L10_2 = L7_2
      L11_2 = L8_2
      L9_2 = L9_2(L10_2, L11_2)
      L10_2 = L9_2
      L10_2()
    end
  end
end
L36_1.message = L37_1
function L37_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = client
  L4_2 = L4_2.color_log
  L5_2 = 151
  L6_2 = 201
  L7_2 = 57
  L8_2 = string
  L8_2 = L8_2.lower
  L9_2 = L15_1
  L8_2 = L8_2(L9_2)
  L9_2 = " \226\128\162\000"
  L8_2 = L8_2 .. L9_2
  L4_2(L5_2, L6_2, L7_2, L8_2)
  L4_2 = client
  L4_2 = L4_2.color_log
  L5_2 = 255
  L6_2 = 255
  L7_2 = 255
  L8_2 = " Connection to server closed, try again later"
  L4_2(L5_2, L6_2, L7_2, L8_2)
  L4_2 = client
  L4_2 = L4_2.reload_active_scripts
  L4_2()
  L4_2 = nil
  storing_table_websocket_connection = L4_2
end
L36_1.close = L37_1
function L37_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = client
  L2_2 = L2_2.color_log
  L3_2 = 151
  L4_2 = 201
  L5_2 = 57
  L6_2 = string
  L6_2 = L6_2.lower
  L7_2 = L15_1
  L6_2 = L6_2(L7_2)
  L7_2 = " \226\128\162\000"
  L6_2 = L6_2 .. L7_2
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = client
  L2_2 = L2_2.color_log
  L3_2 = 255
  L4_2 = 255
  L5_2 = 255
  L6_2 = " Connection to server closed, try again later"
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = client
  L2_2 = L2_2.reload_active_scripts
  L2_2()
  L2_2 = nil
  storing_table_websocket_connection = L2_2
end
L36_1.error = L37_1
L37_1 = L27_1.connect
L38_1 = storing_table_websocket_server
L39_1 = L36_1
L37_1(L38_1, L39_1)
function L37_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = {}
  L3_2 = A0_2.gmatch
  L4_2 = A0_2
  L5_2 = "[^"
  L6_2 = A1_2
  L7_2 = "]+"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  for L6_2 in L3_2, L4_2, L5_2 do
    L7_2 = table
    L7_2 = L7_2.insert
    L8_2 = L2_2
    L9_2 = L6_2
    L7_2(L8_2, L9_2)
  end
  L3_2 = L2_2
  return L3_2
end
function L38_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = storing_table_websocket_connection
  if L1_2 ~= nil then
    L2_2 = storing_table_session_id
    if L2_2 == "session_not_logged_in" then
    else
      L2_2 = A0_2
      L1_2 = A0_2.sub
      L3_2 = 0
      L4_2 = 5
      L1_2 = L1_2(L2_2, L3_2, L4_2)
      if L1_2 == "/help" then
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 151
        L3_2 = 201
        L4_2 = 57
        L5_2 = "["
        L6_2 = L15_1
        L7_2 = "]"
        L5_2 = L5_2 .. L6_2 .. L7_2
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 151
        L3_2 = 201
        L4_2 = 57
        L5_2 = "/login username password\000"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 255
        L3_2 = 255
        L4_2 = 255
        L5_2 = " - logging in"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 151
        L3_2 = 201
        L4_2 = 57
        L5_2 = "/register username password\000"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 255
        L3_2 = 255
        L4_2 = 255
        L5_2 = " - registering"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 151
        L3_2 = 201
        L4_2 = 57
        L5_2 = "/logout\000"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 255
        L3_2 = 255
        L4_2 = 255
        L5_2 = " - logs out"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 151
        L3_2 = 201
        L4_2 = 57
        L5_2 = "/delete\000"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 255
        L3_2 = 255
        L4_2 = 255
        L5_2 = " - deletes your account from database"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 151
        L3_2 = 201
        L4_2 = 57
        L5_2 = "/redeem key\000"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 255
        L3_2 = 255
        L4_2 = 255
        L5_2 = " - redeeming access key"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 151
        L3_2 = 201
        L4_2 = 57
        L5_2 = "/load\000"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 255
        L3_2 = 255
        L4_2 = 255
        L5_2 = " - loading script (useful after redeeming without need to restart script)"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 151
        L3_2 = 201
        L4_2 = 57
        L5_2 = "/autoload\000"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 255
        L3_2 = 255
        L4_2 = 255
        L5_2 = " - toggling auto load of script"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = true
        return L1_2
      end
      L2_2 = A0_2
      L1_2 = A0_2.sub
      L3_2 = 0
      L4_2 = 10
      L1_2 = L1_2(L2_2, L3_2, L4_2)
      if L1_2 == "/autoload" then
        L1_2 = L17_1
        if not L1_2 then
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 151
          L3_2 = 201
          L4_2 = 57
          L5_2 = string
          L5_2 = L5_2.lower
          L6_2 = L15_1
          L5_2 = L5_2(L6_2)
          L6_2 = " \226\128\162\000"
          L5_2 = L5_2 .. L6_2
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 255
          L3_2 = 255
          L4_2 = 255
          L5_2 = " You are not logged in"
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = true
          return L1_2
        end
        L1_2 = storing_table_websocket_connection
        L2_2 = L1_2
        L1_2 = L1_2.send
        L3_2 = json
        L3_2 = L3_2.stringify
        L4_2 = {}
        L5_2 = L19_1
        L6_2 = "auto_load_change"
        L5_2 = L5_2(L6_2)
        L4_2.msg_type = L5_2
        L5_2 = storing_table_session_id
        L4_2.msg_data = L5_2
        L5_2 = L19_1
        L6_2 = L30_1
        L6_2 = L6_2.username
        L5_2 = L5_2(L6_2)
        L4_2.msg_username = L5_2
        L5_2 = L19_1
        L6_2 = L30_1
        L6_2 = L6_2.password
        L5_2 = L5_2(L6_2)
        L4_2.msg_password = L5_2
        L1_2(L2_2, L3_2(L4_2))
        L1_2 = true
        return L1_2
      end
      L2_2 = A0_2
      L1_2 = A0_2.sub
      L3_2 = 0
      L4_2 = 5
      L1_2 = L1_2(L2_2, L3_2, L4_2)
      if L1_2 == "/load" then
        L1_2 = L18_1
        if L1_2 then
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 151
          L3_2 = 201
          L4_2 = 57
          L5_2 = string
          L5_2 = L5_2.lower
          L6_2 = L15_1
          L5_2 = L5_2(L6_2)
          L6_2 = " \226\128\162\000"
          L5_2 = L5_2 .. L6_2
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 255
          L3_2 = 255
          L4_2 = 255
          L5_2 = " You already loaded lua"
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = true
          return L1_2
        end
        L1_2 = L17_1
        if not L1_2 then
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 151
          L3_2 = 201
          L4_2 = 57
          L5_2 = string
          L5_2 = L5_2.lower
          L6_2 = L15_1
          L5_2 = L5_2(L6_2)
          L6_2 = " \226\128\162\000"
          L5_2 = L5_2 .. L6_2
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 255
          L3_2 = 255
          L4_2 = 255
          L5_2 = " You are not logged in"
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = true
          return L1_2
        end
        L1_2 = storing_table_websocket_connection
        L2_2 = L1_2
        L1_2 = L1_2.send
        L3_2 = json
        L3_2 = L3_2.stringify
        L4_2 = {}
        L5_2 = L19_1
        L6_2 = "request_load"
        L5_2 = L5_2(L6_2)
        L4_2.msg_type = L5_2
        L5_2 = storing_table_session_id
        L4_2.msg_data = L5_2
        L5_2 = L19_1
        L6_2 = L30_1
        L6_2 = L6_2.username
        L5_2 = L5_2(L6_2)
        L4_2.msg_username = L5_2
        L5_2 = L19_1
        L6_2 = L30_1
        L6_2 = L6_2.password
        L5_2 = L5_2(L6_2)
        L4_2.msg_password = L5_2
        L5_2 = storing_table_hwid
        L4_2.msg_hwid = L5_2
        L1_2(L2_2, L3_2(L4_2))
        L1_2 = true
        return L1_2
      end
      L2_2 = A0_2
      L1_2 = A0_2.sub
      L3_2 = 0
      L4_2 = 9
      L1_2 = L1_2(L2_2, L3_2, L4_2)
      if L1_2 == "/register" then
        L1_2 = L17_1
        if L1_2 then
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 151
          L3_2 = 201
          L4_2 = 57
          L5_2 = string
          L5_2 = L5_2.lower
          L6_2 = L15_1
          L5_2 = L5_2(L6_2)
          L6_2 = " \226\128\162\000"
          L5_2 = L5_2 .. L6_2
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 255
          L3_2 = 255
          L4_2 = 255
          L5_2 = " You are already registered"
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = true
          return L1_2
        end
        L1_2 = L37_1
        L2_2 = A0_2
        L3_2 = " "
        L1_2 = L1_2(L2_2, L3_2)
        L1_2 = L1_2[2]
        username = L1_2
        L1_2 = L37_1
        L2_2 = A0_2
        L3_2 = " "
        L1_2 = L1_2(L2_2, L3_2)
        L1_2 = L1_2[3]
        password = L1_2
        L1_2 = username
        if L1_2 then
          L1_2 = password
          if L1_2 then
            L1_2 = L30_1
            L2_2 = username
            L1_2.username = L2_2
            L1_2 = L30_1
            L2_2 = password
            L1_2.password = L2_2
            L1_2 = storing_table_websocket_connection
            L2_2 = L1_2
            L1_2 = L1_2.send
            L3_2 = json
            L3_2 = L3_2.stringify
            L4_2 = {}
            L5_2 = L19_1
            L6_2 = "register"
            L5_2 = L5_2(L6_2)
            L4_2.msg_type = L5_2
            L5_2 = storing_table_session_id
            L4_2.msg_data = L5_2
            L5_2 = L19_1
            L6_2 = username
            L5_2 = L5_2(L6_2)
            L4_2.msg_username = L5_2
            L5_2 = L19_1
            L6_2 = password
            L5_2 = L5_2(L6_2)
            L4_2.msg_password = L5_2
            L5_2 = storing_table_hwid
            L4_2.msg_hwid = L5_2
            L1_2(L2_2, L3_2(L4_2))
        end
        else
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 151
          L3_2 = 201
          L4_2 = 57
          L5_2 = string
          L5_2 = L5_2.lower
          L6_2 = L15_1
          L5_2 = L5_2(L6_2)
          L6_2 = " \226\128\162\000"
          L5_2 = L5_2 .. L6_2
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 255
          L3_2 = 255
          L4_2 = 255
          L5_2 = " Provide login and password"
          L1_2(L2_2, L3_2, L4_2, L5_2)
        end
        L1_2 = true
        return L1_2
      end
      L2_2 = A0_2
      L1_2 = A0_2.sub
      L3_2 = 0
      L4_2 = 6
      L1_2 = L1_2(L2_2, L3_2, L4_2)
      if L1_2 == "/login" then
        L1_2 = L17_1
        if L1_2 then
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 151
          L3_2 = 201
          L4_2 = 57
          L5_2 = string
          L5_2 = L5_2.lower
          L6_2 = L15_1
          L5_2 = L5_2(L6_2)
          L6_2 = " \226\128\162\000"
          L5_2 = L5_2 .. L6_2
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 255
          L3_2 = 255
          L4_2 = 255
          L5_2 = " You are already logged in"
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = true
          return L1_2
        end
        L1_2 = L37_1
        L2_2 = A0_2
        L3_2 = " "
        L1_2 = L1_2(L2_2, L3_2)
        L1_2 = L1_2[2]
        username = L1_2
        L1_2 = L37_1
        L2_2 = A0_2
        L3_2 = " "
        L1_2 = L1_2(L2_2, L3_2)
        L1_2 = L1_2[3]
        password = L1_2
        L1_2 = username
        if L1_2 then
          L1_2 = password
          if L1_2 then
            L1_2 = L30_1
            L2_2 = username
            L1_2.username = L2_2
            L1_2 = L30_1
            L2_2 = password
            L1_2.password = L2_2
            L1_2 = storing_table_websocket_connection
            L2_2 = L1_2
            L1_2 = L1_2.send
            L3_2 = json
            L3_2 = L3_2.stringify
            L4_2 = {}
            L5_2 = L19_1
            L6_2 = "login"
            L5_2 = L5_2(L6_2)
            L4_2.msg_type = L5_2
            L5_2 = storing_table_session_id
            L4_2.msg_data = L5_2
            L5_2 = L19_1
            L6_2 = username
            L5_2 = L5_2(L6_2)
            L4_2.msg_username = L5_2
            L5_2 = L19_1
            L6_2 = password
            L5_2 = L5_2(L6_2)
            L4_2.msg_password = L5_2
            L5_2 = storing_table_hwid
            L4_2.msg_hwid = L5_2
            L1_2(L2_2, L3_2(L4_2))
        end
        else
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 151
          L3_2 = 201
          L4_2 = 57
          L5_2 = string
          L5_2 = L5_2.lower
          L6_2 = L15_1
          L5_2 = L5_2(L6_2)
          L6_2 = " \226\128\162\000"
          L5_2 = L5_2 .. L6_2
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 255
          L3_2 = 255
          L4_2 = 255
          L5_2 = " Provide login and password"
          L1_2(L2_2, L3_2, L4_2, L5_2)
        end
        L1_2 = true
        return L1_2
      end
      L2_2 = A0_2
      L1_2 = A0_2.match
      L3_2 = "/redeem"
      L1_2 = L1_2(L2_2, L3_2)
      if L1_2 then
        L1_2 = L17_1
        if not L1_2 then
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 151
          L3_2 = 201
          L4_2 = 57
          L5_2 = string
          L5_2 = L5_2.lower
          L6_2 = L15_1
          L5_2 = L5_2(L6_2)
          L6_2 = " \226\128\162\000"
          L5_2 = L5_2 .. L6_2
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 255
          L3_2 = 255
          L4_2 = 255
          L5_2 = " You are not registered or logged in, use /login or /register"
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = true
          return L1_2
        end
        L1_2 = L37_1
        L2_2 = A0_2
        L3_2 = " "
        L1_2 = L1_2(L2_2, L3_2)
        L1_2 = L1_2[2]
        key = L1_2
        L1_2 = key
        if L1_2 then
          L1_2 = key
          L1_2 = #L1_2
          if L1_2 < 32 then
            L1_2 = client
            L1_2 = L1_2.color_log
            L2_2 = 151
            L3_2 = 201
            L4_2 = 57
            L5_2 = string
            L5_2 = L5_2.lower
            L6_2 = L15_1
            L5_2 = L5_2(L6_2)
            L6_2 = " \226\128\162\000"
            L5_2 = L5_2 .. L6_2
            L1_2(L2_2, L3_2, L4_2, L5_2)
            L1_2 = client
            L1_2 = L1_2.color_log
            L2_2 = 255
            L3_2 = 255
            L4_2 = 255
            L5_2 = " Key is too short"
            L1_2(L2_2, L3_2, L4_2, L5_2)
          else
            L1_2 = storing_table_websocket_connection
            L2_2 = L1_2
            L1_2 = L1_2.send
            L3_2 = json
            L3_2 = L3_2.stringify
            L4_2 = {}
            L5_2 = L19_1
            L6_2 = "redeem"
            L5_2 = L5_2(L6_2)
            L4_2.msg_type = L5_2
            L5_2 = L19_1
            L6_2 = L30_1
            L6_2 = L6_2.username
            L5_2 = L5_2(L6_2)
            L4_2.msg_username = L5_2
            L5_2 = L19_1
            L6_2 = key
            L5_2 = L5_2(L6_2)
            L4_2.msg_key = L5_2
            L1_2(L2_2, L3_2(L4_2))
          end
        else
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 151
          L3_2 = 201
          L4_2 = 57
          L5_2 = string
          L5_2 = L5_2.lower
          L6_2 = L15_1
          L5_2 = L5_2(L6_2)
          L6_2 = " \226\128\162\000"
          L5_2 = L5_2 .. L6_2
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 255
          L3_2 = 255
          L4_2 = 255
          L5_2 = " Provide key"
          L1_2(L2_2, L3_2, L4_2, L5_2)
        end
        L1_2 = true
        return L1_2
      end
      L2_2 = A0_2
      L1_2 = A0_2.match
      L3_2 = "/logout"
      L1_2 = L1_2(L2_2, L3_2)
      if L1_2 then
        L1_2 = L17_1
        if not L1_2 then
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 151
          L3_2 = 201
          L4_2 = 57
          L5_2 = string
          L5_2 = L5_2.lower
          L6_2 = L15_1
          L5_2 = L5_2(L6_2)
          L6_2 = " \226\128\162\000"
          L5_2 = L5_2 .. L6_2
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 255
          L3_2 = 255
          L4_2 = 255
          L5_2 = " You are not registered or logged in, use /login or /register"
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = true
          return L1_2
        end
        L1_2 = database
        L1_2 = L1_2.write
        L2_2 = L16_1
        L3_2 = nil
        L1_2(L2_2, L3_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 151
        L3_2 = 201
        L4_2 = 57
        L5_2 = string
        L5_2 = L5_2.lower
        L6_2 = L15_1
        L5_2 = L5_2(L6_2)
        L6_2 = " \226\128\162\000"
        L5_2 = L5_2 .. L6_2
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 255
        L3_2 = 255
        L4_2 = 255
        L5_2 = " Successfully logged out"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.reload_active_scripts
        L1_2()
        L1_2 = true
        return L1_2
      end
      L2_2 = A0_2
      L1_2 = A0_2.match
      L3_2 = "/delete"
      L1_2 = L1_2(L2_2, L3_2)
      if L1_2 then
        L1_2 = L17_1
        if not L1_2 then
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 151
          L3_2 = 201
          L4_2 = 57
          L5_2 = string
          L5_2 = L5_2.lower
          L6_2 = L15_1
          L5_2 = L5_2(L6_2)
          L6_2 = " \226\128\162\000"
          L5_2 = L5_2 .. L6_2
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = client
          L1_2 = L1_2.color_log
          L2_2 = 255
          L3_2 = 255
          L4_2 = 255
          L5_2 = " You are not registered or logged in, use /login or /register"
          L1_2(L2_2, L3_2, L4_2, L5_2)
          L1_2 = true
          return L1_2
        end
        L1_2 = storing_table_websocket_connection
        L2_2 = L1_2
        L1_2 = L1_2.send
        L3_2 = json
        L3_2 = L3_2.stringify
        L4_2 = {}
        L5_2 = L19_1
        L6_2 = "delete"
        L5_2 = L5_2(L6_2)
        L4_2.msg_type = L5_2
        L5_2 = storing_table_session_id
        L4_2.msg_data = L5_2
        L5_2 = L19_1
        L6_2 = L30_1
        L6_2 = L6_2.username
        L5_2 = L5_2(L6_2)
        L4_2.msg_username = L5_2
        L5_2 = L19_1
        L6_2 = L30_1
        L6_2 = L6_2.password
        L5_2 = L5_2(L6_2)
        L4_2.msg_password = L5_2
        L1_2(L2_2, L3_2(L4_2))
        L1_2 = database
        L1_2 = L1_2.write
        L2_2 = L16_1
        L3_2 = nil
        L1_2(L2_2, L3_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 151
        L3_2 = 201
        L4_2 = 57
        L5_2 = string
        L5_2 = L5_2.lower
        L6_2 = L15_1
        L5_2 = L5_2(L6_2)
        L6_2 = " \226\128\162\000"
        L5_2 = L5_2 .. L6_2
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.color_log
        L2_2 = 255
        L3_2 = 255
        L4_2 = 255
        L5_2 = " Successfully logged out"
        L1_2(L2_2, L3_2, L4_2, L5_2)
        L1_2 = client
        L1_2 = L1_2.reload_active_scripts
        L1_2()
        L1_2 = true
        return L1_2
      end
      return
    end
  end
end
L39_1 = client
L39_1 = L39_1.set_event_callback
L40_1 = "console_input"
L41_1 = L38_1
L39_1(L40_1, L41_1)
