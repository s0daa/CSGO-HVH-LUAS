local r0_0 = require("ffi")
local r1_0 = require("gamesense/base64")
local r2_0 = require("gamesense/pui")
local r3_0 = require("vector")
local r4_0 = require("gamesense/inspect")
local r5_0 = require("gamesense/antiaim_funcs") or error("Missing antiaim funcs library")
local r6_0 = {}
local r7_0 = {}
local r8_0 = 0
local r9_0 = false
local r10_0 = 0
local r11_0 = 0
local r12_0 = false
local r13_0 = 0
local r14_0 = 0
local r15_0 = 0
local r16_0 = 0
local function r17_0(r0_1, r1_1)
  -- line: [0, 0] id: 1
  if r0_1 == nil then
    return false
  end
  r0_1 = ui.get(r0_1)
  for r5_1 = 0, #r0_1, 1 do
    if r0_1[r5_1] == r1_1 then
      return true
    end
  end
  return false
end
local r18_0 = 0
local r19_0 = false
local r20_0 = 0
r6_0.validation_key = "3805ca8ff0dc26a4a236a8f26d6bd51a"
local r21_0 = false
local r22_0 = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)
local r23_0 = require("gamesense/http")
local r24_0 = require("gamesense/base64")
r22_0.cdef("    typedef long(__thiscall* GetRegistryString)(void* this, const char* pFileName, const char* pPathID);\n    typedef bool(__thiscall* Wrapper)(void* this, const char* pFileName, const char* pPathID);\n")
local r25_0 = r22_0.typeof("void***")
local r26_0 = client.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
if not r26_0 then
  r26_0 = error
  local r27_0 = r21_0 and "Error... contact me on discord! ID: 76462272424066060244"
  if not r27_0 then
    r27_0 = "error"
  end
  r26_0 = r26_0(r27_0, 2)
end
local r27_0 = r22_0.cast(r25_0, r26_0)
if not r27_0 then
  r27_0 = error
  local r28_0 = r21_0 and "Error... contact me on discord! ID: 57421437426460963574"
  if not r28_0 then
    r28_0 = "error"
  end
  r27_0 = r27_0(r28_0, 2)
end
local r28_0 = r22_0.cast("Wrapper", r27_0[0][10])
if not r28_0 then
  r28_0 = error
  local r29_0 = r21_0 and "Error... contact me on discord! ID: 76143089620434347004"
  if not r29_0 then
    r29_0 = "error"
  end
  r28_0 = r28_0(r29_0, 2)
end
local r29_0 = r22_0.cast("GetRegistryString", r27_0[0][13])
if not r29_0 then
  r29_0 = error
  local r30_0 = r21_0 and "Error... contact me on discord! ID: 59542338057818634362"
  if not r30_0 then
    r30_0 = "error"
  end
  r29_0 = r29_0(r30_0, 2)
end
local r31_0 = (function()
  -- line: [0, 0] id: 2
  for r3_2 = 65, 90, 1 do
    local r4_2 = string.char(r3_2) .. ":\\Windows\\Setup\\State\\State.ini"
    if r28_0(r27_0, r4_2, "olympia") then
      return r4_2
    end
  end
  return nil
end)()
if not r31_0 then
  r31_0 = error
  local r32_0 = r21_0 and "Error... contact me on discord! ID: 12628676518493195720"
  if not r32_0 then
    r32_0 = "error"
  end
  r31_0 = r31_0(r32_0, 2)
end
local r32_0 = r29_0(r27_0, r31_0, "olympia")
local r33_0 = r32_0 * 2.1
r23_0.get("https://pastebin.com/raw/MEddAsAZ", function(r0_3, r1_3)
    r9_0 = false
end)
local r34_0 = {}
r34_0.left = false
r34_0.right = false
r34_0.mode = nil
r22_0.cdef("\ttypedef int(__thiscall* get_clipboard_text_count)(void*);\n\ttypedef void(__thiscall* set_clipboard_text)(void*, const char*, int);\n\ttypedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);\n")
function r7_0.bind_argument(r0_4, r1_4)
  -- line: [0, 0] id: 4
  return function(...)
    -- line: [0, 0] id: 5
    local r0_5 = nil	-- notice: implicit variable refs by block#[0]
    return r0_4(r0_5, ...)
  end
end
local r35_0 = 0
local r36_0 = false
function get_delta()
  -- line: [0, 0] id: 6
  local r0_6 = entity.get_local_player()
  if not r0_6 then
    return ""
  end
  return r5_0.normalize_angle(entity.get_prop(r0_6, "m_flPoseParameter", 11) * 120 - 60)
end
function get_desync_side()
  -- line: [0, 0] id: 7
  r36_0 = r35_0 < 0
end
r7_0.animstate_offset = 39264
r7_0.interface_type = r22_0.typeof("uintptr_t**")
r7_0.vgui_system = r22_0.cast(r7_0.interface_type, client.create_interface("vgui2.dll", "VGUI_System010"))
r7_0.get_clipboard_text_count = r7_0.bind_argument(r22_0.cast("int(__thiscall*)(void*)", r7_0.vgui_system[0][7]), r7_0.vgui_system)
r7_0.set_clipboard_text = r7_0.bind_argument(r22_0.cast("void(__thiscall*)(void*, const char*, int)", r7_0.vgui_system[0][9]), r7_0.vgui_system)
r7_0.get_clipboard_text_fn = r7_0.bind_argument(r22_0.cast("void(__thiscall*)(void*, int, const char*, int)", r7_0.vgui_system[0][11]), r7_0.vgui_system)
local r38_0 = r22_0.cast(r22_0.typeof("void***"), client.create_interface("vgui2.dll", "VGUI_System010") or print("Error finding VGUI_System010"))
if not r22_0.cast("get_clipboard_text_count", r38_0[0][7]) then
  local r39_0 = print("get_clipboard_text_count Invalid")
end
local r40_0 = r22_0.cast("set_clipboard_text", r38_0[0][9]) or print("set_clipboard_text Invalid")
if not r22_0.cast("get_clipboard_text", r38_0[0][11]) then
  local r41_0 = print("get_clipboard_text Invalid")
end
function r7_0.get_clipboard_text()
  -- line: [0, 0] id: 8
  local r0_8 = r7_0.get_clipboard_text_count()
  if r0_8 > 0 then
    local r1_8 = r22_0.new("char[?]", r0_8)
    r7_0.get_clipboard_text_fn(0, r1_8, r0_8 * r22_0.sizeof("char[?]", r0_8))
    return r22_0.string(r1_8, r0_8 - 1)
  end
  return ""
end
function animka(r0_9, r1_9, r2_9, r3_9)
  -- line: [0, 0] id: 9
  if r0_9 then
    return math.max(r1_9 + (r2_9 - r1_9) * globals.frametime() * r3_9, 0)
  end
  return math.max(r1_9 - (r2_9 + r1_9) * globals.frametime() * r3_9 / 2, 0)
end
local function r42_0(r0_10, r1_10, r2_10)
  -- line: [0, 0] id: 10
  if r2_10 < r0_10 then
    return r2_10
  end
  if r0_10 < r1_10 then
    return r1_10
  end
  return r0_10
end
function calculate_color(r0_11, r1_11, r2_11)
  -- line: [0, 0] id: 11
  r2_11 = math.min(1, r2_11)
  s_a = r1_11[4]
  s_b = r1_11[3]
  s_g = r1_11[2]
  s_r = r1_11[1]
  s2_a = r0_11[4]
  s2_b = r0_11[3]
  s2_g = r0_11[2]
  s2_r = r0_11[1]
  local r3_11 = 0
  local r4_11 = 0
  local r5_11 = 0
  local r6_11 = 0
  if s2_r < s_r then
    r3_11 = r42_0(s_r - (s_r - s2_r) * r2_11, s2_r, s_r)
  else
    r3_11 = r42_0(s_r + (s2_r - s_r) * r2_11, s_r, s2_r)
  end
  if s2_g < s_g then
    r4_11 = r42_0(s_g - (s_g - s2_g) * r2_11, s2_g, s_g)
  else
    r4_11 = r42_0(s_g + (s2_g - s_g) * r2_11, s_g, s2_g)
  end
  if s2_b < s_b then
    r5_11 = r42_0(s_b - (s_b - s2_b) * r2_11, s2_b, s_b)
  else
    r5_11 = r42_0(s_b + (s2_b - s_b) * r2_11, s_b, s2_b)
  end
  if s2_a < s_a then
    r6_11 = r42_0(s_a - (s_a - s2_a) * r2_11, s2_a, s_a)
  else
    r6_11 = r42_0(s_a + (s2_a - s_a) * r2_11, s_a, s2_a)
  end
  return {
    r3_11,
    r4_11,
    r5_11,
    r6_11
  }
end
if not require("gamesense/http") then
  local r43_0 = error("Missing HTTP library")
end
local r44_0 = client.screen_size
local r45_0 = client.draw_text
local r46_0 = client.draw_indicator
local r47_0 = client.set_event_callback
local r48_0 = {}
r48_0.enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled")
r48_0.pitch = {
  ui.reference("AA", "Anti-aimbot angles", "Pitch")
}
r48_0.yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
r48_0.yaw = {
  ui.reference("AA", "Anti-aimbot angles", "Yaw")
}
r48_0.yaw_jitter = {
  ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
}
r48_0.body_yaw = {
  ui.reference("AA", "Anti-aimbot angles", "Body yaw")
}
r48_0.freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
r48_0.edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
r48_0.freestand = {
  ui.reference("AA", "Anti-aimbot angles", "Freestanding")
}
r48_0.roll = ui.reference("AA", "Anti-aimbot angles", "Roll")
r48_0.legmovement = ui.reference("AA", "OTHER", "leg movement")
r48_0.slowmotion = {
  ui.reference("AA", "Other", "Slow motion")
}
r48_0.onshot = {
  ui.reference("AA", "Other", "On shot anti-aim")
}
r48_0.doubletap = {
  ui.reference("RAGE", "Aimbot", "Double tap")
}
r48_0.doubletap_fl = {
  ui.reference("RAGE", "Aimbot", "Double tap fake lag limit")
}
r48_0.fakeduck = ui.reference("RAGE", "Other", "Duck peek assist")
r48_0.auto_peek = {
  ui.reference("Rage", "Other", "Quick peek assist")
}
r48_0.pingspike = {
  ui.reference("MISC", "Miscellaneous", "Ping Spike")
}
r48_0.fakelag = ui.reference("AA", "Fake lag", "Enabled")
r48_0.fakelag_limit = ui.reference("AA", "Fake lag", "Limit")
r48_0.force_body = ui.reference("RAGE", "Aimbot", "Force body aim")
r48_0.force_safe = ui.reference("RAGE", "Aimbot", "Force safe point")
r48_0.menu_color = {
  ui.reference("MISC", "Settings", "Menu color")
}
r48_0.clantag = ui.reference("MISC", "Miscellaneous", "Clan tag spammer")
r48_0.damage_bind = {
  ui.reference("RAGE", "Aimbot", "Minimum damage override")
}
local r49_0 = {}
r49_0.ui_tables = {}
function r49_0.update_all()
  -- line: [0, 0] id: 12
  for r3_12, r4_12 in pairs(r49_0.ui_tables) do
    for r8_12, r9_12 in pairs(r4_12) do
      r9_12.update()
    end
  end
end
function r49_0.new_element(r0_13, r1_13, r2_13, r3_13)
  -- line: [0, 0] id: 13
  if not r49_0.ui_tables[r0_13] then
    r49_0.ui_tables[r0_13] = {}
  end
  r49_0.ui_tables[r0_13][r1_13] = {}
  r49_0.ui_tables[r0_13][r1_13].ref = r2_13
  r49_0.ui_tables[r0_13][r1_13].value = ui.get(r2_13)
  local r4_13 = r49_0.ui_tables[r0_13][r1_13]
  local r5_13 = not r3_13 and function()
    -- line: [0, 0] id: 14
    return true
  end
  if not r5_13 then
    r5_13 = r3_13
  end
  r4_13.visible_func = r5_13
  r49_0.ui_tables[r0_13][r1_13].update = function(r0_15)
    -- line: [0, 0] id: 15
    r49_0.ui_tables[r0_13][r1_13].value = ui.get(r2_13)
    ui.set_visible(r2_13, r49_0.ui_tables[r0_13][r1_13].visible_func())
    if r0_15 then
      r49_0.update_all()
    end
  end
  ui.set_callback(r2_13, r49_0.ui_tables[r0_13][r1_13].update)
end
local r50_0 = {
  "Standing",
  "Moving",
  "Crouching",
  "Crouching - move",
  "Air",
  "Air - Crouch",
  "Low Velocity"
}
local r51_0 = {
  "Anti Aim",
  "Visuals",
  "Misc"
}
local r52_0 = {}
local r53_0 = true
r49_0.new_element("Anti aim", "Tabs", ui.new_combobox("AA", "Anti-aimbot angles", "Navigation", r51_0))
r49_0.new_element("Anti aim", "aa", ui.new_combobox("AA", "Anti-aimbot angles", "Conditions", r50_0), function()
  -- line: [0, 0] id: 16
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
end)
r49_0.new_element("Anti aim", "freestand condition", ui.new_multiselect("AA", "Anti-aimbot angles", "Off freestand on", r50_0), function()
  -- line: [0, 0] id: 17
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Misc"
end)
r49_0.new_element("Anti aim", "abi", ui.new_checkbox("AA", "Anti-aimbot angles", "Anti Backstab"), function()
  -- line: [0, 0] id: 18
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Misc"
end)
r49_0.new_element("Anti aim", "defik", ui.new_checkbox("AA", "Anti-aimbot angles", "Defensive improvements"), function()
  -- line: [0, 0] id: 19
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Misc"
end)
local r54_0 = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual Left", false, 5)
local r55_0 = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual Right", false, 5)
r49_0.new_element("Visuals", "Indicator", ui.new_checkbox("AA", "Anti-aimbot angles", "Indicator"), function()
  -- line: [0, 0] id: 20
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
end)
r49_0.new_element("Visuals", "World hitmarker", ui.new_checkbox("AA", "Anti-aimbot angles", "World crosshair hitmarker"), function()
  -- line: [0, 0] id: 21
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
end)
r49_0.new_element("Visuals", "World hitmarker slider", ui.new_slider("AA", "Anti-aimbot angles", "Thickness", 1, 3, 1), function()
  -- line: [0, 0] id: 22
  local r0_22 = r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
  if r0_22 then
    r0_22 = r49_0.ui_tables.Visuals["World hitmarker"].value
  end
  return r0_22
end)
r49_0.new_element("Visuals", "Dmg", ui.new_checkbox("AA", "Anti-aimbot angles", "Damage indicator"), function()
  -- line: [0, 0] id: 23
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
end)
r49_0.new_element("Visuals", "Viewmodel checkbox", ui.new_checkbox("AA", "Anti-aimbot angles", "Viewmodel"), function()
  -- line: [0, 0] id: 24
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
end)
r49_0.new_element("Visuals", "Viewmodel x", ui.new_slider("AA", "Anti-aimbot angles", "X", -50, 50, 0), function()
  -- line: [0, 0] id: 25
  local r0_25 = r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
  if r0_25 then
    r0_25 = r49_0.ui_tables.Visuals["Viewmodel checkbox"].value
  end
  return r0_25
end)
r49_0.new_element("Visuals", "Viewmodel y", ui.new_slider("AA", "Anti-aimbot angles", "Y", -50, 50, 0), function()
  -- line: [0, 0] id: 26
  local r0_26 = r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
  if r0_26 then
    r0_26 = r49_0.ui_tables.Visuals["Viewmodel checkbox"].value
  end
  return r0_26
end)
r49_0.new_element("Visuals", "Viewmodel z", ui.new_slider("AA", "Anti-aimbot angles", "Z", -50, 50, 0), function()
  -- line: [0, 0] id: 27
  local r0_27 = r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
  if r0_27 then
    r0_27 = r49_0.ui_tables.Visuals["Viewmodel checkbox"].value
  end
  return r0_27
end)
r49_0.new_element("Visuals", "Viewmodel Fov", ui.new_slider("AA", "Anti-aimbot angles", "Fov", -100, 100, 0), function()
  -- line: [0, 0] id: 28
  local r0_28 = r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
  if r0_28 then
    r0_28 = r49_0.ui_tables.Visuals["Viewmodel checkbox"].value
  end
  return r0_28
end)
r49_0.new_element("Visuals", "Custom Scop", ui.new_checkbox("AA", "Anti-aimbot angles", "Custom Scope"), function()
  -- line: [0, 0] id: 29
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
end)
r49_0.new_element("Visuals", "Offset", ui.new_slider("AA", "Anti-aimbot angles", "Offset", 0, 400, 200), function()
  -- line: [0, 0] id: 30
  local r0_30 = r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
  if r0_30 then
    r0_30 = r49_0.ui_tables.Visuals["Custom Scop"].value
  end
  return r0_30
end)
r49_0.new_element("Visuals", "Delta", ui.new_slider("AA", "Anti-aimbot angles", "Delta", 0, 400, 20), function()
  -- line: [0, 0] id: 31
  local r0_31 = r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
  if r0_31 then
    r0_31 = r49_0.ui_tables.Visuals["Custom Scop"].value
  end
  return r0_31
end)
r49_0.new_element("Visuals", "Transperancy checkbox", ui.new_checkbox("AA", "Anti-aimbot angles", "Custom Transperancy"), function()
  -- line: [0, 0] id: 32
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
end)
r49_0.new_element("Visuals", "Transperancy", ui.new_slider("AA", "Anti-aimbot angles", "Transpernacy", 0, 100, 20), function()
  -- line: [0, 0] id: 33
  local r0_33 = r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
  if r0_33 then
    r0_33 = r49_0.ui_tables.Visuals["Transperancy checkbox"].value
  end
  return r0_33
end)
r49_0.new_element("Visuals", "Aspect checkbox", ui.new_checkbox("AA", "Anti-aimbot angles", "Aspect Ratio"), function()
  -- line: [0, 0] id: 34
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
end)
r49_0.new_element("Visuals", "Aspect", ui.new_slider("AA", "Anti-aimbot angles", "Aspect Ratio", 0, 200, 130), function()
  -- line: [0, 0] id: 35
  local r0_35 = r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
  if r0_35 then
    r0_35 = r49_0.ui_tables.Visuals["Aspect checkbox"].value
  end
  return r0_35
end)
r49_0.new_element("Visuals", "TP Checkbox", ui.new_checkbox("AA", "Anti-aimbot angles", "Thirdperson"), function()
  -- line: [0, 0] id: 36
  return r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
end)
r49_0.new_element("Visuals", "TP", ui.new_slider("AA", "Anti-aimbot angles", "Thirdperson distance", 30, 200, 150), function()
  -- line: [0, 0] id: 37
  local r0_37 = r49_0.ui_tables["Anti aim"].Tabs.value == "Visuals"
  if r0_37 then
    r0_37 = r49_0.ui_tables.Visuals["TP Checkbox"].value
  end
  return r0_37
end)
for r59_0 = 1, #r50_0, 1 do
  r49_0.new_element("Anti aim", "yaw left" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Yaw Left", -180, 180, 0), function()
    -- line: [0, 0] id: 38
    local r0_38 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_38 then
      r0_38 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    return r0_38
  end)
  r49_0.new_element("Anti aim", "yaw right" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Yaw Right", -180, 180, 0), function()
    -- line: [0, 0] id: 39
    local r0_39 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_39 then
      r0_39 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    return r0_39
  end)
  r49_0.new_element("Anti aim", "delay work" .. r59_0, ui.new_checkbox("AA", "Anti-aimbot angles", "Yaw with delay"), function()
    -- line: [0, 0] id: 40
    local r0_40 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_40 then
      r0_40 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    return r0_40
  end)
  r49_0.new_element("Anti aim", "delat" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Delay", 0, 100, 25), function()
    -- line: [0, 0] id: 41
    local r0_41 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_41 then
      r0_41 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    if r0_41 then
      r0_41 = r49_0.ui_tables["Anti aim"]["delay work" .. r59_0].value
    end
    return r0_41
  end)
  r49_0.new_element("Anti aim", "delat3" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Delay Speed", 0, 50, 10), function()
    -- line: [0, 0] id: 42
    local r0_42 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_42 then
      r0_42 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    if r0_42 then
      r0_42 = r49_0.ui_tables["Anti aim"]["delay work" .. r59_0].value
    end
    return r0_42
  end)
  r49_0.new_element("Anti aim", "delat2" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Body yaw", 0, 60, 25), function()
    -- line: [0, 0] id: 43
    local r0_43 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_43 then
      r0_43 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    if r0_43 then
      r0_43 = r49_0.ui_tables["Anti aim"]["delay work" .. r59_0].value
    end
    return r0_43
  end)
  r49_0.new_element("Anti aim", "yaw sway" .. r59_0, ui.new_checkbox("AA", "Anti-aimbot angles", "Sway Yaws"), function()
    -- line: [0, 0] id: 44
    local r0_44 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_44 then
      r0_44 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    return r0_44
  end)
  r49_0.new_element("Anti aim", "Sway Start" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Sway start", -180, 180, 0), function()
    -- line: [0, 0] id: 45
    local r0_45 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_45 then
      r0_45 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    return r0_45
  end)
  r49_0.new_element("Anti aim", "Sway End" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Sway End", -180, 180, 0), function()
    -- line: [0, 0] id: 46
    local r0_46 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_46 then
      r0_46 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    return r0_46
  end)
  r49_0.new_element("Anti aim", "Sway Speed" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Speed", 1, 10, 1), function()
    -- line: [0, 0] id: 47
    local r0_47 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_47 then
      r0_47 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    if r0_47 then
      r0_47 = r49_0.ui_tables["Anti aim"]["yaw sway" .. r59_0].value
    end
    return r0_47
  end)
  r49_0.new_element("Anti aim", "Body yaw combo" .. r59_0, ui.new_combobox("AA", "Anti-aimbot angles", "Body Yaw", "Off", "Opposite", "Jitter", "Static"), function()
    -- line: [0, 0] id: 48
    local r0_48 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_48 then
      r0_48 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    if r0_48 then
      r0_48 = not r49_0.ui_tables["Anti aim"][("delay work" .. r59_0)].value
    end
    return r0_48
  end)
  r49_0.new_element("Anti aim", "Body yaw slider" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Body yaw start", -180, 180, 0), function()
    -- line: [0, 0] id: 49
    local r0_49 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_49 then
      r0_49 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    if r0_49 then
      r0_49 = r49_0.ui_tables["Anti aim"]["Body yaw combo" .. r59_0].value == "Jitter"
    end
    if r0_49 then
      r0_49 = not r49_0.ui_tables["Anti aim"][("delay work" .. r59_0)].value
    end
    return r0_49
  end)
  r49_0.new_element("Anti aim", "Body yaw slider2" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Body yaw end", -180, 180, 0), function()
    -- line: [0, 0] id: 50
    local r0_50 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_50 then
      r0_50 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    if r0_50 then
      r0_50 = r49_0.ui_tables["Anti aim"]["Body yaw combo" .. r59_0].value == "Jitter"
    end
    if r0_50 then
      r0_50 = not r49_0.ui_tables["Anti aim"][("delay work" .. r59_0)].value
    end
    return r0_50
  end)
  r49_0.new_element("Anti aim", "Checking" .. r59_0, ui.new_checkbox("AA", "Anti-aimbot angles", "Calculate body yaw"), function()
    -- line: [0, 0] id: 51
    local r0_51 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_51 then
      r0_51 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    if r0_51 then
      r0_51 = not r49_0.ui_tables["Anti aim"][("Body yaw combo" .. r59_0)].value ~= "Opposite"
    end
    if r0_51 then
      r0_51 = r49_0.ui_tables["Anti aim"]["Body yaw combo" .. r59_0].value ~= "Static"
    end
    return r0_51
  end)
  r49_0.new_element("Anti aim", "Yaw Jitter" .. r59_0, ui.new_combobox("AA", "Anti-aimbot angles", "Yaw Jitter", "Off", "Offset", "Center"), function()
    -- line: [0, 0] id: 52
    local r0_52 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_52 then
      r0_52 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    if r0_52 then
      r0_52 = not r49_0.ui_tables["Anti aim"][("delay work" .. r59_0)].value
    end
    return r0_52
  end)
  r49_0.new_element("Anti aim", "Yaw Jitter Value" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Yaw jitter left", -180, 180, 0), function()
    -- line: [0, 0] id: 53
    local r0_53 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_53 then
      r0_53 = r49_0.ui_tables["Anti aim"]["Yaw Jitter" .. r59_0].value ~= "Off"
    end
    if r0_53 then
      r0_53 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    return r0_53
  end)
  r49_0.new_element("Anti aim", "Yaw Jitter Value2" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Yaw jitter right", -180, 180, 0), function()
    -- line: [0, 0] id: 54
    local r0_54 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_54 then
      r0_54 = r49_0.ui_tables["Anti aim"]["Yaw Jitter" .. r59_0].value ~= "Off"
    end
    if r0_54 then
      r0_54 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    return r0_54
  end)
  r49_0.new_element("Anti Aim", "defensive aa" .. r59_0, ui.new_checkbox("AA", "Anti-aimbot angles", "Force Defensive"), function()
    -- line: [0, 0] id: 55
    local r0_55 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    if r0_55 then
      r0_55 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    end
    return r0_55
  end)
  r49_0.new_element("Anti Aim", "defensive check" .. r59_0, ui.new_checkbox("AA", "Anti-aimbot angles", "Defensive with calculate body"), function()
    -- line: [0, 0] id: 56
    local r0_56 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    if r0_56 then
      r0_56 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    end
    if r0_56 then
      r0_56 = r49_0.ui_tables["Anti Aim"]["defensive aa" .. r59_0].value
    end
    if r0_56 then
      r0_56 = not r49_0.ui_tables["Anti aim"][("delay work" .. r59_0)].value
    end
    return r0_56
  end)
  r49_0.new_element("Anti Aim", "defensive check aes" .. r59_0, ui.new_checkbox("AA", "Anti-aimbot angles", "Defensive Custom"), function()
    -- line: [0, 0] id: 57
    local r0_57 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    if r0_57 then
      r0_57 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    end
    if r0_57 then
      r0_57 = r49_0.ui_tables["Anti Aim"]["defensive aa" .. r59_0].value
    end
    return r0_57
  end)
  r49_0.new_element("Anti aim", "return" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Cycle", 0, 10, 0), function()
    -- line: [0, 0] id: 58
    local r0_58 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_58 then
      r0_58 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    return r0_58
  end)
  r49_0.new_element("Anti aim", "return2" .. r59_0, ui.new_slider("AA", "Anti-aimbot angles", "Speed", 0, 10, 0), function()
    -- line: [0, 0] id: 59
    local r0_59 = r49_0.ui_tables["Anti aim"].aa.value == r50_0[r59_0]
    if r0_59 then
      r0_59 = r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim"
    end
    return r0_59
  end)
  -- close: r56_0
end
local r59_0 = "Export Cfg Setting"
ui.new_button("AA", "Anti-aimbot angles", r59_0, function()
  -- line: [0, 0] id: 60
  r18_0 = 0
  r13_0 = 0
  r6_0.parse()
end)
r59_0 = "Import Cfg Setting"
ui.new_button("AA", "Anti-aimbot angles", r59_0, function()
  -- line: [0, 0] id: 61
  r18_0 = 0
  r13_0 = 0
  r6_0.load()
end)
function r6_0.parse()
  -- line: [0, 0] id: 62
  local r0_62 = {}
  for r4_62, r5_62 in pairs(r49_0.ui_tables) do
    local r6_62 = {}
    for r10_62, r11_62 in pairs(r5_62) do
      local r12_62 = {}
      r12_62.value = ui.get(r11_62.ref)
      if type(r12_62.value) == "userdata" then
        r12_62.color = r6_0.convert_color(r12_62.value)
        r12_62.value = nil
      end
      if r12_62.color or r12_62.value ~= nil then
        r6_62[r10_62] = r12_62
      end
    end
    r0_62[r4_62] = r6_62
  end
  r0_62[r6_0.validation_key] = true
  local r1_62 = r24_0.encode(json.stringify(r0_62), CUSTOM_ENCODER)
  r7_0.set_clipboard_text(r1_62, #r1_62)
end
function r6_0.load(r0_63)
  -- line: [0, 0] id: 63
  local r2_63, r3_63 = pcall(function()
    -- line: [0, 0] id: 64
    local r0_64 = r0_63 == nil
    if r0_64 then
      r0_64 = r7_0.get_clipboard_text()
    end
    if not r0_64 then
      r0_64 = r0_63
    end
    local r1_64 = r24_0.decode(r0_64, CUSTOM_DECODER)
    if r1_64:match(r6_0.validation_key) == nil then
      error("cannot_find_validation_key")
      return 
    end
    r1_64 = json.parse(r1_64)
    if r1_64 == nil then
      error("wrong_json")
      return 
    end
    for r5_64, r6_64 in pairs(r1_64) do
      if r5_64 ~= r6_0.validation_key then
        for r10_64, r11_64 in pairs(r6_64) do
          if r49_0.ui_tables[r5_64][r10_64] and r11_64.value ~= nil then
            ui.set(r49_0.ui_tables[r5_64][r10_64].ref, r11_64.value)
            r49_0.ui_tables[r5_64][r10_64].value = r11_64.value
          end
        end
      end
    end
    r49_0.update_all()
  end)
  if not r2_63 then
    print("Failed to load config:", r3_63)
    return 
  end
end
r49_0.update_all()
local r56_0 = ui.get
local r57_0 = ui.set
local r58_0 = ui.reference
r59_0 = ui
r59_0 = r59_0.new_hotkey
local r60_0 = ui.new_slider
local r61_0 = 0
local r62_0 = 0
local r63_0 = 0
local r64_0 = 0
local r65_0 = entity.get_local_player
local r66_0 = entity.get_prop
local r67_0 = 0
local r68_0 = 0
local r69_0 = 0
local r70_0 = 0
local r71_0 = false
local r72_0 = 0
local r73_0 = 0
local r74_0 = 0
local r75_0 = 0
local r76_0 = 0
local r77_0 = 0
local r78_0 = 0
r47_0("paint", function(r0_65)
  -- line: [0, 0] id: 65
  if not r49_0.ui_tables.Visuals.Indicator.value == true then
    return 
  end
  local r1_65 = entity.get_prop(entity.get_local_player(), "m_flNextAttack")
  local r2_65 = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_flNextPrimaryAttack")
  local r3_65 = false
  if r2_65 ~= nil then
    r3_65 = not (math.max(r2_65, r1_65) > globals.curtime())
  end
  r73_0 = animka(ui.get(r48_0.doubletap[2]), r73_0, 10, 10) or 0
  r74_0 = animka(ui.get(r48_0.damage_bind[2]), r74_0, 10, 10) or 0
  r75_0 = animka(ui.get(r48_0.fakeduck), r75_0, 10, 10) or 0
  r76_0 = animka(ui.get(r48_0.force_body), r76_0, 10, 10) or 0
  r77_0 = animka(ui.get(r48_0.force_safe), r77_0, 10, 10) or 0
  r78_0 = animka(ui.get(r48_0.onshot[2]), r78_0, 10, 10) or 0
  r69_0 = 0
  r61_0 = 0
  r64_0 = 0
  if r66_0(r65_0(), "m_lifeState") ~= 0 then
    return 
  end
  if ui.get(r48_0.force_body) or ui.get(r48_0.force_safe) or r56_0(r48_0.damage_bind[2]) then
    r69_0 = 10
  end
  local r4_65 = math.abs(1 * math.cos(2 * math.pi * (globals.curtime() + 3) / 5)) * 255
  local r5_65, r6_65 = r44_0()
  local r7_65 = r5_65 / 2
  local r8_65 = r6_65 - 200
  renderer.text(r5_65 / 2 + 7, r6_65 / 2 + 15, 143, 194, 21, r4_65, "-", 0, "   DEBUG")
  local r9_65 = "AESTHETIC"
  local r10_65 = globals.curtime() * 8 % 30 - 5
  local r11_65 = {}
  local r12_65 = r5_65 / 2 - 10 - renderer.measure_text("c-", r9_65) / 2
  for r16_65 = 1, #r9_65, 1 do
    local r17_65 = math.abs(r16_65 - r10_65)
    r11_65[r16_65] = 255 * r42_0(r17_65 / 5, 0, 1)
    local r18_65 = calculate_color({
      165,
      184,
      214,
      255
    }, {
      66,
      135,
      245,
      255
    }, r42_0(r17_65 / 5, 0, 1))
    renderer.text(r12_65, r6_65 / 2 + 20, r18_65[1], r18_65[2], r18_65[3], r18_65[4], "c-", 0, r9_65:sub(r16_65, r16_65))
    r12_65 = r12_65 + renderer.measure_text("c-", r9_65:sub(r16_65, r16_65))
  end
  if ui.get(r48_0.doubletap[2]) and ui.get(r48_0.doubletap[1]) then
    r61_0 = r61_0 + 10
    renderer.text(r5_65 / 2 - 29, r6_65 / 2 + r61_0 + r73_0 + 5, 255, 255, 255, 255, "-", 0, "DT")
    if not r3_65 then
      renderer.text(r5_65 / 2 - 18, r6_65 / 2 + 5 + r61_0 + r73_0, 245, 23, 7, 255, "-", 0, "READY")
    elseif r3_65 then
      renderer.text(r5_65 / 2 - 18, r6_65 / 2 + 5 + r61_0 + r73_0, 7, 245, 23, 255, "-", 0, "READY")
    end
  elseif ui.get(r48_0.onshot[2]) then
    r61_0 = 10
    renderer.text(r5_65 / 2 - 29, r6_65 / 2 + 5 + r61_0 + r78_0, 255, 255, 255, 255, "-", 0, "HS")
  end
  if ui.get(r48_0.damage_bind[2]) then
    r64_0 = r64_0 + 20
    renderer.text(r5_65 / 2 - 29 + r64_0 - 20, r6_65 / 2 + 5 + r61_0 + r69_0 + r74_0, 255, 255, 255, 255, "-", 0, "DMG")
  end
  if ui.get(r48_0.force_body) then
    r64_0 = r64_0 + 20
    renderer.text(r5_65 / 2 - 29 + r64_0 - 20, r6_65 / 2 + 5 + r61_0 + r69_0 + r76_0, 255, 255, 255, 255, "-", 0, "BA")
  end
  if ui.get(r48_0.force_safe) then
    r64_0 = r64_0 + 15
    renderer.text(r5_65 / 2 - 20 + r64_0 - 20, r6_65 / 2 + 5 + r61_0 + r69_0 + r77_0, 255, 255, 255, 255, "-", 0, "SF")
  end
  if ui.get(r48_0.fakeduck) then
    r61_0 = r61_0 + 10
    renderer.text(r5_65 / 2 - 29, r6_65 / 2 + 5 + r61_0 + r69_0 + r75_0, 255, 255, 255, 255, "-", 0, "FD")
  end
end)
r47_0("run_command", function(r0_66)
  -- line: [0, 0] id: 66
  if r0_66.chokedcommands == 0 then
    r19_0 = not r19_0
  end
end)
last_button = nil
local r80_0 = 0
local r81_0 = 0
local r82_0 = 0
cmd = 0
r67_0 = 0
r16_0 = 0
function run(r0_67)
  -- line: [0, 0] id: 67
  cmd = r0_67.command_number
end
function predict(r0_68)
  -- line: [0, 0] id: 68
  if not r49_0.ui_tables["Anti aim"].defik.value then
    return 
  end
  if r0_68.command_number == cmd then
    local r1_68 = entity.get_prop(entity.get_local_player(), "m_nTickBase")
    local r4_68 = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))
    r16_0 = math.abs(r1_68 - r67_0)
    r67_0 = math.max(r1_68, r67_0 or 0)
    cmd = 0
    if not r3_68 then
      return false
    end
    if r4_68 ~= "CDEagle" and r49_0.ui_tables["Anti aim"].defik.value and r5_0.get_double_tap() then
      if ui.get(r48_0.auto_peek[2]) then
        if r16_0 > 1 then
          ui.set(r48_0.yaw[2], 0)
          ui.set(r48_0.body_yaw[2], 0)
          ui.set(r48_0.doubletap_fl[1], 2)
        else
          ui.set(r48_0.doubletap_fl[1], 1)
        end
      end
    else
      ui.set(r48_0.doubletap_fl[1], 1)
    end
  end
end
client.set_event_callback("level_init", function()
  -- line: [0, 0] id: 69
  r16_0 = 0
  r67_0 = 0
end)
client.set_event_callback("run_command", run)
client.set_event_callback("predict_command", predict)
local r83_0 = {}
r83_0.ThisSwitch = false
r83_0.ThisDelay = globals.realtime()
r83_0.WaySwitch = 1
r83_0.WayDelay = 0
r83_0.JitterDsy = "l"
r83_0.JitterDelay = globals.realtime()
Yaw = r83_0
r83_0 = ui.reference
local r83_0, r84_0, r85_0 = r83_0("AA", "Anti-aimbot angles", "Yaw")
local function r86_0(r0_70)
  -- line: [0, 0] id: 70
  if r9_0 then
    return 
  end
  if 3 <= r16_0 and ui.get(r48_0.auto_peek[2]) and r49_0.ui_tables["Anti aim"].defik.value then
    return 
  end
  ui.set(r83_0, "180")
  if ui.get(r48_0.doubletap_fl[1]) == 6 or ui.get(r48_0.doubletap_fl[1]) == 4 then
    r0_70.quick_stop = 1
  end
  if r12_0 then
    ui.set(r48_0.yaw[2], 180)
  elseif r34_0.mode ~= nil then
    local r1_70 = ui.set
    local r2_70 = r48_0.yaw[2]
    local r3_70 = r34_0.mode == "left"
    if r3_70 then
      r3_70 = -90
    end
    if not r3_70 then
      r3_70 = 90
    end
    r1_70(r2_70, r3_70)
    ui.set(ui.reference("AA", "Anti-aimbot angles", "Body yaw"), "Static")
    ui.set(r48_0.body_yaw[2], 141)
    ui.set(r48_0.yaw_base, "Local view")
    ui.set(ui.reference("AA", "Anti-aimbot angles", "Yaw Jitter"), "Off")
    ui.set(r48_0.yaw[2], 0)
    ui.set(r48_0.freestand[1], false)
  else
    ui.set(r48_0.yaw_base, "At targets")
    delta = get_delta()
    ui.set(ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"), false)
    ui.set(r48_0.edge_yaw, false)
    local r1_70 = entity.get_prop(entity.get_local_player(), "m_flNextAttack")
    local r2_70 = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_flNextPrimaryAttack")
    local r3_70 = false
    if r2_70 ~= nil then
      r3_70 = not (math.max(r2_70, r1_70) > globals.curtime())
    end
    if r0_70.chokedcommands == 0 then
      r82_0 = delta
    end
    local r4_70 = r65_0()
    local r5_70 = entity.get_prop(r4_70, "m_fFlags")
    local r6_70 = r5_70 == bit.bor(r5_70, bit.lshift(1, 0))
    local r7_70 = r5_70 == bit.bor(r5_70, bit.lshift(2, 0))
    local r8_70, r9_70, r10_70 = entity.get_prop(r4_70, "m_vecVelocity")
    local r11_70 = math.sqrt(r8_70 * r8_70 + r9_70 * r9_70)
    local r12_70 = r6_70 and r42_0(r81_0 + 1, 0, 2)
    if not r12_70 then
      r12_70 = 0
    end
    r81_0 = r12_70
    local r12_70, r13_70 = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
    local r14_70, r15_70 = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
    local r16_70 = 1
    if 150 < r11_70 and 1 < r81_0 and not r7_70 then
      r16_70 = 2
    elseif r7_70 and 1 < r81_0 and r11_70 < 5 then
      r16_70 = 3
    elseif r81_0 <= 1 and r7_70 and 150 < r11_70 then
      r16_70 = 6
    elseif r81_0 <= 1 and not r7_70 and 150 < r11_70 then
      r16_70 = 5
    elseif r11_70 < 5 and 1 < r81_0 and not r7_70 then
      r16_70 = 1
    elseif 5 < r11_70 and 1 < r81_0 and r7_70 then
      r16_70 = 4
    elseif r11_70 < 150 and (1 < r81_0 and not r7_70 or r81_0 <= 1) then
      r16_70 = 7
    end
    local function r17_70(r0_71, r1_71)
      -- line: [0, 0] id: 71
      if r82_0 > 0 then
        return r0_71
      end
      if r82_0 < 0 then
        return r1_71
      end
    end
    local r18_70 = r49_0.ui_tables["Anti aim"]["delat" .. r16_70].value
    if r0_70.chokedcommands == 0 then
      Yaw.ThisDelay = Yaw.ThisDelay + 1
      ui.set(r48_0.doubletap_fl[1], 2)
      ui.set(ui.reference("AA", "Anti-aimbot angles", "Body yaw"), "Off")
      if r18_70 > 0 then
        r18_70 = 0.05 * r18_70
      end
      if r18_70 < Yaw.ThisDelay + 0.05 * r15_0 then
        ui.set(r48_0.doubletap_fl[1], 1)
        ui.set(ui.reference("AA", "Anti-aimbot angles", "Body yaw"), "Static")
        inve = not inve
        r14_0 = r14_0 + 1
        Yaw.ThisDelay = 0
      end
      if r14_0 > 4 then
        r15_0 = r15_0 + 2
        ui.set(r48_0.doubletap_fl[1], math.random(1, 3))
        ui.set(ui.reference("AA", "Anti-aimbot angles", "Body yaw"), "Static")
        r14_0 = 0
      end
      if r49_0.ui_tables["Anti aim"]["delat3" .. r16_70].value < r15_0 then
        ui.set(ui.reference("AA", "Anti-aimbot angles", "Body yaw"), "Off")
        ui.set(r48_0.doubletap_fl[1], 1)
        r15_0 = 0
      end
    end
    if not r49_0.ui_tables["Anti aim"][("yaw sway" .. r16_70)].value then
      r10_0 = 0
    end
    if r0_70.chokedcommands == 0 and r49_0.ui_tables["Anti aim"]["Sway Start" .. r16_70].value < r49_0.ui_tables["Anti aim"]["Sway End" .. r16_70].value then
      r10_0 = r10_0 + r49_0.ui_tables["Anti aim"][("Sway Speed" .. r16_70)].value
    end
    if r49_0.ui_tables["Anti aim"]["Sway End" .. r16_70].value <= r10_0 then
      r10_0 = r49_0.ui_tables["Anti aim"]["Sway Start" .. r16_70].value
    end
    if r49_0.ui_tables["Anti aim"]["delay work" .. r16_70].value then
      ui.set(r48_0.yaw_jitter[2], 0)
      if not r49_0.ui_tables["Anti aim"][("Checking" .. r16_70)].value then
        local r19_70 = ui.set
        local r20_70 = r48_0.body_yaw[2]
        local r21_70 = inve and -r49_0.ui_tables["Anti aim"][("delat2" .. r16_70)].value
        if not r21_70 then
          r21_70 = r49_0.ui_tables["Anti aim"]["delat2" .. r16_70].value
        end
        r19_70(r20_70, r21_70)
      else
        if r49_0.ui_tables["Anti aim"]["Checking" .. r16_70].value then
          r20_0 = r20_0 + 1
        end
        if r20_0 == 1 then
          ui.set(ui.reference("AA", "Anti-aimbot angles", "Body yaw"), "Off")
        elseif r20_0 == 2 then
          ui.set(ui.reference("AA", "Anti-aimbot angles", "Body yaw"), "Static")
          local r19_70 = ui.set
          local r20_70 = r48_0.body_yaw[2]
          local r21_70 = inve and -r49_0.ui_tables["Anti aim"][("delat2" .. r16_70)].value
          if not r21_70 then
            r21_70 = r49_0.ui_tables["Anti aim"]["delat2" .. r16_70].value
          end
          r19_70(r20_70, r21_70)
        elseif r20_0 == 3 then
          ui.set(ui.reference("AA", "Anti-aimbot angles", "Body yaw"), "Off")
        end
      end
      local r19_70 = ui.set
      local r20_70 = r48_0.yaw[2]
      local r21_70 = inve and r49_0.ui_tables["Anti aim"][("yaw left" .. r16_70)].value - r10_0
      if not r21_70 then
        r21_70 = r49_0.ui_tables["Anti aim"][("yaw right" .. r16_70)].value + r10_0
      end
      r19_70(r20_70, r21_70)
    else
      ui.set(r48_0.yaw[2], r17_70(r49_0.ui_tables["Anti aim"][("yaw left" .. r16_70)].value - r10_0, r49_0.ui_tables["Anti aim"][("yaw right" .. r16_70)].value + r10_0))
    end
    if not r49_0.ui_tables["Anti aim"][("delay work" .. r16_70)].value then
      ui.set(ui.reference("AA", "Anti-aimbot angles", "Body yaw"), r49_0.ui_tables["Anti aim"]["Body yaw combo" .. r16_70].value)
    end
    ui.set(r48_0.yaw_jitter[2], r17_70(r49_0.ui_tables["Anti aim"]["Yaw Jitter Value" .. r16_70].value, r49_0.ui_tables["Anti aim"]["Yaw Jitter Value2" .. r16_70].value))
    ui.set(ui.reference("AA", "Anti-aimbot angles", "Yaw jitter"), r49_0.ui_tables["Anti aim"]["Yaw Jitter" .. r16_70].value)
    if r49_0.ui_tables["Anti aim"]["Checking" .. r16_70].value and r49_0.ui_tables["Anti aim"]["Body yaw combo" .. r16_70].value == "Jitter" and not r49_0.ui_tables["Anti aim"][("delay work" .. r16_70)].value then
      if r0_70.chokedcommands == 0 and r49_0.ui_tables["Anti aim"]["Checking" .. r16_70].value then
        r20_0 = r20_0 + 1
      end
      if r20_0 == 1 and r49_0.ui_tables["Anti aim"]["Checking" .. r16_70].value then
        if r49_0.ui_tables["Anti Aim"]["defensive aa" .. r16_70].value and not ui.get(r48_0.auto_peek[2]) and r49_0.ui_tables["Anti Aim"]["defensive check" .. r16_70].value then
          r0_70.force_defensive = true
        end
        ui.set(r48_0.body_yaw[2], r49_0.ui_tables["Anti aim"]["Body yaw slider" .. r16_70].value)
      end
      if r20_0 == 2 and r49_0.ui_tables["Anti aim"]["Checking" .. r16_70].value then
        ui.set(r48_0.body_yaw[1], "Off")
      end
      if r20_0 == 3 and r49_0.ui_tables["Anti aim"]["Checking" .. r16_70].value then
        if r49_0.ui_tables["Anti Aim"]["defensive aa" .. r16_70].value and not ui.get(r48_0.auto_peek[2]) and r49_0.ui_tables["Anti Aim"]["defensive check" .. r16_70].value then
          r0_70.force_defensive = true
        end
        ui.set(r48_0.body_yaw[2], r49_0.ui_tables["Anti aim"]["Body yaw slider2" .. r16_70].value)
      end
      if r20_0 >= 4 then
        r20_0 = 0
      end
    end
    if not r49_0.ui_tables["Anti aim"][("Checking" .. r16_70)].value then
      r20_0 = 0
    end
    if r5_0.get_double_tap() and r49_0.ui_tables["Anti Aim"]["defensive aa" .. r16_70].value and not r49_0.ui_tables["Anti Aim"][("defensive check" .. r16_70)].value and not r49_0.ui_tables["Anti Aim"][("defensive check aes" .. r16_70)].value then
      r0_70.force_defensive = globals.tickcount() % 5 == 4
    end
    if r49_0.ui_tables["Anti Aim"]["defensive check aes" .. r16_70].value and r49_0.ui_tables["Anti Aim"]["defensive aa" .. r16_70].value and r5_0.get_double_tap() then
      r0_70.force_defensive = globals.tickcount() % r49_0.ui_tables["Anti aim"][("return" .. r16_70)].value >= r49_0.ui_tables["Anti aim"]["return2" .. r16_70].value
    end
    if r17_0(r49_0.ui_tables["Anti aim"]["freestand condition"].ref, r50_0[r16_70]) then
      ui.set(r48_0.freestand[1], false)
    else
      ui.set(r48_0.freestand[1], true)
    end
  end
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        do local rawlen,_ENV do local print=math.floor local pairs=math.random local pcall=table.remove local unpack=string.char local package=0 local setfenv=2 local select={}local tostring={}local error=0 local rawget={}for print=1,256,1 do rawget[print]=print end repeat local print=pairs(1,#rawget)local package=pcall(rawget,print)tostring[package]=unpack(package-1)until#rawget==0 local next={}local function require(...)if#next==0 then package=(package*53+22034908687427)%35184372088832 repeat setfenv=(setfenv*156)%257 until setfenv~=1 local pairs=setfenv%32 local pcall=(print(package/2^(13-(setfenv-pairs)/32))%4294967296)/2^pairs local unpack=print((pcall%1)*4294967296)+print(pcall)local _ENV=unpack%65536 local table=(unpack-_ENV)/65536 local rawlen=_ENV%256 local math=(_ENV-rawlen)/256 local select=table%256 local tostring=(table-select)/256 next={rawlen,math,select;tostring}end return table.remove(next)end local _G={}rawlen=setmetatable({},{__index=_G,__metatable=nil})function _ENV(print,pairs,...)local pcall=_G if pcall[pairs]then else next={}local unpack=tostring package=pairs%35184372088832 setfenv=pairs%255+2 local _ENV=string.len(print)pcall[pairs]=""local table=5 for package=1,_ENV,1 do table=((string.byte(print,package)+require())+table)%256 pcall[pairs]=pcall[pairs]..unpack[table+1]end end return pairs end end local setfenv=function(print,...)local pairs,pcall=print[#print],rawlen[_ENV("",3139885575681)]for unpack=1,#pairs,1 do pcall=pcall..pairs[print[unpack]]end return pcall end local package=function(print,...)local pairs,pcall=print[#print],rawlen[_ENV("",30790128045926)]for unpack=1,#pairs,1 do pcall=pcall..pairs[print[unpack]]end return pcall end local pairs={setfenv({4;2,1,3,{rawlen[_ENV("\232\053\141\189\026\118\000\178\233\128\019\060\057\018\173\120\124\199\235\127\198\046\030\043\206\228\065\221\051",429932931167)];rawlen[_ENV("\149\059\102\211\064\101\174\031\237\141\148\118\247\211\003\116\086\043\162\205",19399608336930)],rawlen[_ENV("\101\121\240\071",13181961458374)],rawlen[_ENV("\091\138\189\018\143\117\127\078\047\165\060",34325127721427)]}}),rawlen[_ENV("\024\098\219\203\t\054\113\225",32030644584340)];rawlen[_ENV("\241\212\000\253",30595407531944)]}for print,pcall in ipairs({{79351+-79350;(924030+-658547)+-265480},{-622641-(-622642),-717904+717905},{(-41408+395148)+-353738;146778+-146775}})do while pcall[-11411-(-11412)]<pcall[98075-98073]do pairs[pcall[-229349-(-229350)]],pairs[pcall[780234+-780232]],pcall[-218494+218495],pcall[823901-823899]=pairs[pcall[760000-759998]],pairs[pcall[213834-213833]],pcall[724883+-724882]+(-172551+172552),pcall[332500+-332498]-(856615-856614)end end local function pcall(print,...)return pairs[print-((787919+-988766)+201548)]end do local print=string[rawlen[_ENV("\097\187\035",11911905411597)]]local pcall=type local unpack=string[rawlen[_ENV("\246\226\043",26771474496242)]]local select=table[package({1;2;{rawlen[_ENV("\079\156\085\197\092",15012432101356)];rawlen[_ENV("\231",29341341780074)]}})]local tostring=math[rawlen[_ENV("\081\012\159\074\242",27563938385847)]]local error=table[rawlen[_ENV("\133\146\081\105\136\141",15813517759915)]]local rawget=pairs local next={[rawlen[_ENV("\003",19376363883194)]]=410462-410418;[rawlen[_ENV("\085",6963518773875)]]=-694532+694567,[rawlen[_ENV("\021",7124999826302)]]=844064-844043,[rawlen[_ENV("\233",6263236686303)]]=559699-(-257671+817315);[rawlen[_ENV("\151",17543601530912)]]=-600964-(-1108987-(-508001));[rawlen[_ENV("\092",25298899683896)]]=847905+-847862,[rawlen[_ENV("\213",21733998824505)]]=(1027578-602837)+-424689;[rawlen[_ENV("\148",27899643354311)]]=985503+(-887914+-97529);[rawlen[_ENV("\138",25203403800350)]]=-229740-(-229745);[rawlen[_ENV("\191",1324013294030)]]=361762-361749,[rawlen[_ENV("\235",25495015556693)]]=725108-725083,[rawlen[_ENV("\235",15965486105137)]]=-97993+98054,[rawlen[_ENV("\193",32557695848521)]]=385265-385216;[rawlen[_ENV("\166",6943518251360)]]=-201270+201277;[rawlen[_ENV("\106",31363070269025)]]=(816343+-1262305)+446016,[rawlen[_ENV("\064",25833820988487)]]=-427961-(-428014);[rawlen[_ENV("\070",489781045964)]]=905006+-904977;[rawlen[_ENV("\097",11195935609069)]]=-774057-(-774098);[rawlen[_ENV("\073",5855054452839)]]=-797732+797735;[rawlen[_ENV("\184",6832745401613)]]=341807-341767;[rawlen[_ENV("\105",13636519918363)]]=-525408-(-525420);[rawlen[_ENV("\140",17019281635189)]]=334108+-334072,[rawlen[_ENV("\b",15336301573015)]]=325332+-325290;[rawlen[_ENV("\171",31997252363231)]]=19355-19293,[rawlen[_ENV("-",6088210046201)]]=-543872-(-255853-(104326-(-183730)));[rawlen[_ENV("\029",6341182064103)]]=613871-613826;[rawlen[_ENV("\207",6544406248699)]]=-198498+198529,[rawlen[_ENV("\215",27080356047652)]]=-322771+322785;[rawlen[_ENV("\037",26528502782241)]]=-385930+385963;[rawlen[_ENV("\243",17611883927805)]]=-525789+525813,[rawlen[_ENV("\231",18257969972883)]]=-172746-(-172765),[rawlen[_ENV("\182",20587018750269)]]=410580-410553;[rawlen[_ENV("\132",16802417497311)]]=569620-569582,[rawlen[_ENV("\092",4404048478395)]]=32523-32477;[rawlen[_ENV("\026",21351859341483)]]=-921156-(-921166);[rawlen[_ENV("\178",2819437674227)]]=-66697+66712,[rawlen[_ENV("\201",11032053664446)]]=589241-589239,[rawlen[_ENV("\029",12175704812739)]]=487037-487021,[rawlen[_ENV("\209",9750779273264)]]=202511-202507;[rawlen[_ENV("\028",13661552537980)]]=(-388141+642885)+-254693,[rawlen[_ENV("\192",22567499743668)]]=64022-64013,[rawlen[_ENV("\108",32782794033164)]]=(70082+-181770)-(-111727),[rawlen[_ENV("\012",4307193190938)]]=-880936-(-880970);[rawlen[_ENV("\021",16041713698865)]]=-741190+741198,[rawlen[_ENV("\102",6271331517411)]]=644302+(120106+-764407),[rawlen[_ENV("\219",5191028822721)]]=510598+-510535,[rawlen[_ENV("\216",16748405720218)]]=25769+((539107+-1190725)+625899);[rawlen[_ENV("\132",32762632279850)]]=-853563-(-547869+-305711);[rawlen[_ENV("\136",15234526511794)]]=313839-313839,[rawlen[_ENV("\175",23116990036050)]]=-765587-(-765615);[rawlen[_ENV("\214",5029471095056)]]=-131020+131050;[rawlen[_ENV("\023",16138976139405)]]=(-271154+1309498)-(-306844+1345170);[rawlen[_ENV("\135",15138696737213)]]=648726+-648700,[rawlen[_ENV("\204",12428341150168)]]=(-704571+1612760)+-908166,[rawlen[_ENV("\"",7574883079028)]]=354098+-354039,[rawlen[_ENV("\107",17160870108740)]]=-68639+(1004696+(423345+-1359370));[rawlen[_ENV("\187",23433938651335)]]=753588+(-881443+127903),[rawlen[_ENV("\122",17899685672417)]]=-379327+379384;[rawlen[_ENV("\130",33860331853936)]]=-898787+898845;[rawlen[_ENV("\203",10974214820028)]]=868053+-868006;[rawlen[_ENV("\108",5240979150852)]]=915638-915627;[rawlen[_ENV("\048",23764156681296)]]=-532276+532332;[rawlen[_ENV("\014",24983624853414)]]=300200-300194;[rawlen[_ENV("\246",2746300740415)]]=-161410-(-221152-(974215-1033937))}local setmetatable=string[rawlen[_ENV("\035\208\103\225",1764479021378)]]for pairs=107766-107765,#rawget,1032107-1032106 do local package=rawget[pairs]if pcall(package)==rawlen[_ENV("\201\014\129\216\173\019",11455197895250)]then local pcall=print(package)local setfenv={}local table=76138+-76137 local math=-5936-(-5936)local require=448218-448218 while table<=pcall do local print=unpack(package,table,table)local pairs=next[print]if pairs then math=math+pairs*(-354781-(-354845))^((-756908-(-756911))-require)require=require+(-1021426+1021427)if require==1038629-1038625 then require=-700856+700856 local print=tostring(math/(702810-637274))local pairs=tostring((math%(-43608-(-109144)))/(-155232+155488))local pcall=math%(((7567+(-178613+-28939))+613116)+-412875)select(setfenv,setmetatable(print,pairs,pcall))math=-319536+319536 end elseif print==rawlen[_ENV("\186",7197333733438)]then select(setfenv,setmetatable(tostring(math/(-985579+1051115))))if table>=pcall or unpack(package,table+(-258583+258584),table+(1026490-1026489))~=rawlen[_ENV("\251",22267084044954)]then select(setfenv,setmetatable(tostring((math%(1004895-939359))/(659274+-659018))))end break end table=table+(-259319-(-259320))end rawget[pairs]=error(setfenv)end end end local unpack={[setfenv({2,1,{rawlen[_ENV("\086\235\251",17183683479555)];rawlen[_ENV("\044\090\132\t\115\216\194\233\138\213\031\255\165",23912845229962)]}})]=function(print,pairs,unpack,setfenv,table,math,select,tostring,error,rawget,...)return pcall(setfenv-(1029268+-1024330))end,[package({1;2;{rawlen[_ENV("\038\203\212\144\113\207\023\224\030",17383256271780)];rawlen[_ENV("\109\143",25650280054895)]}})]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(error+(-410533-(-414109)))end;[rawlen[_ENV("\103\217\066\065\060\216\222\147\095\057\024\245\095",26057237838119)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(unpack-(875257+-874067))end;[rawlen[_ENV("\220\181\002\161\104\038\012\206\059\240\030",3676755554717)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(package+(422002+-415571))end;[rawlen[_ENV("\139\107\130\052\070\017\'\197\211\070\180",5029305078033)]]=function(print,pairs,unpack,setfenv,table,math,select,tostring,error,rawget,...)return pcall(setfenv+(634360-631650))end,[package({2,1,{rawlen[_ENV("\063\097\070\211",34162070858595)];rawlen[_ENV("\224\v\175\001\081\253\252\082",17556496029639)]}})]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(math+(384652+-378782))end;[rawlen[_ENV("\203\099\140\101\150\194\150\052",29339981227588)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(print+((-909199-(-350464))-(-563465)))end;[rawlen[_ENV("\246\156\v\064\001\004\217\145\158\078\067",19545076044424)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(setfenv+(430342-428298))end;[rawlen[_ENV("\207\082\"\042\012\246\b\212\182\166\012\094\151\186\022\085",19523863714994)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(pairs-(-931957-(-937068)))end,[rawlen[_ENV("\144\092\242\206\033\021\212\251\243\086\217\216",29448550526932)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(select+(-753903-(-758352)))end,[rawlen[_ENV("\083\215\106\114\153\016\012\217\141\080\024",14658386655280)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(tostring-(-27921+29769))end,[rawlen[_ENV("\239\151\198\058\143\027\060\129\015\052\117\042\195",21495236463730)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(setfenv+(-113793+117994))end,[rawlen[_ENV("\115\136\005\208\067\225\085\003\081\197\135\038\066",19904475554420)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(package+(894494+-891180))end;[rawlen[_ENV("\254\230\180\145\a\190\042\035\004\053\232\000\185\005\058\040",4290890688580)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(package-(-597335-(-598672)))end,[rawlen[_ENV("\130\116\055\196\151",20216607348869)]]=function(print,pairs,unpack,package,table,math,select,tostring,error,rawget,...)return pcall(package+(-606235-(-607325)))end;[setfenv({1,2;{rawlen[_ENV("\227\076\005\145\116\228\217\196\201\108\020\015\224\001\234\189\209\140",21668045184883)];rawlen[_ENV("\192",34369200573188)]}})]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(setfenv+(-630817-(-635094)))end,[rawlen[_ENV("\111\118\179\'\218",18698291896523)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(pairs+(945846+-939695))end;[rawlen[_ENV("\144\167\037\060\084\205\254\055",31637409027353)]]=function(print,pairs,unpack,setfenv,table,math,select,tostring,error,rawget,...)return pcall(math-(292719+(207753+-498046)))end;[package({1,2,{rawlen[_ENV("\230\136\201\238\137\156\158\153\194\123\165\162",1652491659837)],rawlen[_ENV("\248\102\165 \n\202\133\246\082",32087698064369)]}})]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(package+(-551169+(1179392-625933)))end;[rawlen[_ENV("\178\046\000\239\181\021\125\153\210\'\164\193\083",12737118004385)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(setfenv-(-619206-(-621853)))end,[rawlen[_ENV("\230\233\248\253\047\101\189\102\184\025\054\209\131\113\103",19914965059154)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(pairs-(-721807-(-728126)))end,[rawlen[_ENV("\077\101\238\060\240\142\188",10874751230320)]]=function(print,pairs,unpack,setfenv,table,math,select,tostring,error,rawget,...)return pcall(print+(((911230-((-425817-(-993613))+-454745))-1016849)-(-219999)))end,[package({2,1,{rawlen[_ENV("\096\071\058",34851535639534)];rawlen[_ENV("\224\014\043\196\128\237\075\t\212\200",12201852672270)]}})]=function(print,pairs,unpack,package,table,math,select,tostring,error,rawget,...)return pcall(table+(24231-23283))end;[setfenv({2,1;{rawlen[_ENV("\131\006\136\'\061\159\179\023~",10238151735881)];rawlen[_ENV("\098\193\132\084\122",26149244298666)]}})]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(select-(-791152-(-797123)))end,[rawlen[_ENV("\140\169\023\237\084\115\015\171\052\138\164\155\125",28055664826487)]]=function(print,pairs,unpack,package,setfenv,table,math,select,tostring,error,...)return pcall(package-(-389419-(-394528)))end}local print=_G[unpack[rawlen[_ENV("\044\v\168\214\108",26408229117954)]](-531290+526084,157816-(-168807+332072),68823+-75174,172525-178108,588579-593082,1040617+-1046475,(1019614+-1061176)-(-35629),(-99282-(148903+-381557))-138018,-183831-(-179008),655107+-659714)][unpack[rawlen[_ENV("\242\249\105\063\141\002\020\114\143\051\208",32530145043814)]](-71889-(-1017118+942268),383548+-380135,-721638-(-725168),(-150737+(567487+-297213))+-116807,(-749831-(-198511))+(-346815+900707),-339899+342175,-67536-(-69179),-247177+249509,398938+-396388,(144069+(-1193465-(-703420)))+348183)][unpack[rawlen[_ENV("\123\134\140\093\082",18716250323433)]](-62255-(-56530),677105+-682554,-769101+763504,628177+-633002,-423892-(-417578),735806+-740273,-464698-(-459323),119694-125468,-387174+382368,-367563+361268)][unpack[rawlen[_ENV("\002\148\134\064\131\215\097\234\253\a\205",24904439229181)]](-442977+444557,324435-(-343837-(-664739)),-800778+802671,(-277266-85050)-(-365063),172726-170646,(975638+-1298289)+325546,640264+-637223,-414445-(-415996),466699-464149,-716643-(-719412))][unpack[rawlen[_ENV("\134\210\160\234\220\134\142\216\193\168\228",27367349042403)]](-448182+442397,-94302+88955,769566-((73644-(-844237-(-71941)))-71645),191654+-197381,212067-216793,729062-735544,585737-592410,((-827495-611479)-(-469796))-(-963834),280217+-286662,-793646+787018)]print(unpack[rawlen[_ENV("\182\080\043\003\221\161\111\018\071\120\022\006\064\015\001\056",4602349141305)]](-523158+528929,370873-365327,-782487-(-787541),37894-32253,-917220+921885,-243890-(-249563),575829-570421,-702715+(1293915-584630),-351889-(-357577),423624-418177))end

function GetClosestEnemyWithKnife() 
  -- line: [0, 0] id: 72
  local r1_72 = r3_0(entity.get_origin(entity.get_local_player()))
  local r2_72 = entity.get_players(true)
  local r3_72 = {}
  for r7_72, r8_72 in pairs(r2_72) do
    if entity.is_alive(r8_72) and not entity.is_dormant(r8_72) then
      local r9_72 = entity.get_player_weapon(r8_72)
      if r9_72 ~= nullptr and entity.get_classname(r9_72):match("CKnife") then
        table.insert(r3_72, {
          r8_72,
          r1_72:dist(r3_0(entity.get_origin(r8_72)))
        })
      end
    end
  end
  if #r3_72 == 0 then
    return 0, math.huge
  end
  table.sort(r3_72, function(r0_73, r1_73)
    -- line: [0, 0] id: 73
    return r0_73[2] < r1_73[2]
  end)
  return unpack(r3_72[1])
end
local function r87_0()
  -- line: [0, 0] id: 74
  local r0_74, r1_74 = GetClosestEnemyWithKnife()
  if r49_0.ui_tables["Anti aim"].abi.value then
    local r2_74 = r1_74 < 210
  else
    r12_0 = false
  end
end
r47_0("setup_command", function(r0_75)
  -- line: [0, 0] id: 75
  r86_0(r0_75)
  r87_0()
  get_desync_side()
end)
r47_0("paint_ui", function()
  -- line: [0, 0] id: 76
  local r1_76 = globals.curtime() % 15 - 5
  local r2_76 = {}
  for r6_76 = 1, #"test", 1 do
    r2_76[r6_76] = 255 * r42_0(math.abs((r6_76 - r1_76)) / 5, 0, 1)
  end
end)
r47_0("paint_ui", function()
  -- line: [0, 0] id: 77
  if r9_0 then
    return 
  end
  ui.set_visible(r54_0, r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim")
  ui.set_visible(r55_0, r49_0.ui_tables["Anti aim"].Tabs.value == "Anti Aim")
  ui.set_visible(ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"), false)
  ui.set_visible(r48_0.yaw[1], false)
  ui.set_visible(r48_0.yaw[2], false)
  ui.set_visible(r48_0.yaw_jitter[1], false)
  ui.set_visible(r48_0.yaw_jitter[2], false)
  ui.set_visible(r48_0.body_yaw[1], false)
  ui.set_visible(r48_0.body_yaw[2], false)
  ui.set_visible(ui.reference("AA", "Anti-aimbot angles", "Edge yaw"), false)
  ui.set_visible(ui.reference("AA", "Anti-aimbot angles", "Roll"), false)
end)
local function r88_0(r0_78)
  -- line: [0, 0] id: 78
  if r9_0 then
    return 
  end
  if r0_78 then
    r40_0(r38_0, r0_78, r0_78:len())
  end
end
client.set_event_callback("paint", function()
  -- line: [0, 0] id: 79
  if r9_0 then
    return 
  end
  local r0_79, r1_79 = r44_0()
  local r2_79 = r0_79 / 2
  local r3_79 = r1_79 - 200
  local r4_79 = {}
  local r5_79 = "--> AESTHETIC.LUA <--"
  local r6_79 = globals.curtime() * 8 % 30 - 5
  local r7_79 = r0_79 / 2 - 10 - renderer.measure_text("-", r5_79) / 2
  for r11_79 = 1, #r5_79, 1 do
    local r12_79 = math.abs(r11_79 - r6_79)
    r4_79[r11_79] = 255 * r42_0(r12_79 / 5, 0, 1)
    local r13_79 = calculate_color({
      165,
      184,
      214,
      255
    }, {
      0,
      0,
      0,
      255
    }, r42_0(r12_79 / 2, 0, 1))
    renderer.text(r7_79 - 25, r1_79 - 20, r13_79[1], r13_79[2], r13_79[3], r13_79[4], "c", 8, r5_79:sub(r11_79, r11_79))
    r7_79 = r7_79 + renderer.measure_text("c", r5_79) / 12
  end
end)
local r89_0 = {}
local function r91_0(r0_81)
  -- line: [0, 0] id: 81
  if r9_0 then
    return 
  end
  if not r49_0.ui_tables.Visuals["World hitmarker"].value then
    return 
  end
  for r4_81, r5_81 in pairs(r89_0) do
    if globals.curtime() <= r5_81[4] then
      local r6_81, r7_81 = renderer.world_to_screen(r5_81[1], r5_81[2], r5_81[3])
      if r6_81 ~= nil and r7_81 ~= nil then
        renderer.rectangle(r6_81, r7_81 - 5, ui.get(r49_0.ui_tables.Visuals["World hitmarker slider"].ref), 11, 255, 255, 255, 255)
        renderer.rectangle(r6_81 - 5, r7_81, 11, ui.get(r49_0.ui_tables.Visuals["World hitmarker slider"].ref), 255, 255, 255, 255)
      end
    end
  end
end
client.set_event_callback("aim_fire", function(r0_80)
  -- line: [0, 0] id: 80
  if r9_0 then
    return 
  end
  r89_0[globals.tickcount()] = {
    r0_80.x,
    r0_80.y,
    r0_80.z,
    globals.curtime() + 2
  }
end)
client.set_event_callback("paint", r91_0)
client.set_event_callback("round_prestart", function()
  -- line: [0, 0] id: 82
  if r9_0 then
    return 
  end
  r18_0 = 0
  r13_0 = 0
  r89_0 = {}
end)
local r92_0 = ui.get
local r93_0 = ui.set
local r94_0 = ui.reference
local r95_0 = ui.new_hotkey
local r96_0 = ui.new_slider
local r97_0 = entity.get_local_player
local r98_0 = entity.get_prop
local r99_0, r100_0, r101_0 = ui.reference("RAGE", "Aimbot", "Minimum damage override")
local r102_0 = 0
local r103_0 = false
local r104_0 = ui.reference("RAGE", "Aimbot", "Minimum damage")
r47_0("paint", function(r0_83)
  -- line: [0, 0] id: 83
  if r9_0 then
    return 
  end
  if not r49_0.ui_tables.Visuals.Dmg.value then
    return 
  end
  if r102_0 ~= r92_0(r104_0) and not r103_0 then
    r102_0 = r92_0(r104_0)
  end
  if r98_0(r97_0(), "m_lifeState") ~= 0 then
    r103_0 = false
    r93_0(r104_0, r102_0)
    return 
  end
  local r1_83, r2_83 = r44_0()
  local r3_83 = r1_83 / 2
  local r4_83 = r2_83 - 200
  if ui.get(r99_0) and ui.get(r100_0) then
    client.draw_text(ctx, r1_83 / 2 + 8, r2_83 / 2 - 5, 255, 255, 255, 255, "c-", 0, r92_0(r101_0))
  else
    client.draw_text(ctx, r1_83 / 2 + 8, r2_83 / 2 - 5, 255, 255, 255, 255, "c-", 0, r92_0(r104_0))
  end
end)
client.set_event_callback("setup_command", function()
  -- line: [0, 0] id: 84
  if r9_0 then
    return 
  end
  if ui.get(r54_0) and r34_0.left then
    if r34_0.mode == "left" then
      r34_0.mode = nil
    else
      r34_0.mode = "left"
    end
    r34_0.left = false
  end
  if ui.get(r55_0) and r34_0.right then
    if r34_0.mode == "right" then
      r34_0.mode = nil
    else
      r34_0.mode = "right"
    end
    r34_0.right = false
  end
  if ui.get(r54_0) == false then
    r34_0.left = true
  end
  if ui.get(r55_0) == false then
    r34_0.right = true
  end
  if r34_0.mode ~= nil then
    if r34_0.mode == "right" then
      ui.set(r48_0.yaw[2], 90)
    end
    if r34_0.mode == "left" then
      ui.set(r48_0.yaw[2], -90)
    end
  end
end)
local function r107_0()
  -- line: [0, 0] id: 85
  if r9_0 then
    return 
  end
  if not r49_0.ui_tables.Visuals["TP Checkbox"].value then
    return 
  end
  client.exec("cam_idealdist ", ui.get(r49_0.ui_tables.Visuals.TP.ref))
end
client.set_event_callback("round_prestart", r107_0)
ui.set_callback(r49_0.ui_tables.Visuals.TP.ref, r107_0)
local function r108_0()
  -- line: [0, 0] id: 86
  if r9_0 then
    return 
  end
  if not r49_0.ui_tables.Visuals["Aspect checkbox"].value then
    return 
  end
  client.set_cvar("r_aspectratio", ui.get(r49_0.ui_tables.Visuals.Aspect.ref) / 100)
end
client.set_event_callback("round_prestart", r108_0)
ui.set_callback(r49_0.ui_tables.Visuals.Aspect.ref, r108_0)
-- (function()
--   -- line: [0, 0] id: 87
--   if r9_0 then
--     return 
--   end
--   xO = client.get_cvar("viewmodel_offset_x")
--   yO = client.get_cvar("viewmodel_offset_y")
--   zO = client.get_cvar("viewmodel_offset_z")
--   fO = client.get_cvar("viewmodel_fov")
-- end)()
client.set_event_callback("paint_ui", function(r0_88)
  -- line: [0, 0] id: 88
  if r9_0 then
    return 
  end
  if not r49_0.ui_tables.Visuals["Viewmodel checkbox"].value then
    return 
  end
  local r1_88 = 20 + r49_0.ui_tables.Visuals["Viewmodel Fov"].value
  local r3_88 = r49_0.ui_tables.Visuals["Viewmodel y"].value
  local r4_88 = r49_0.ui_tables.Visuals["Viewmodel z"].value
  client.set_cvar("viewmodel_offset_x", r49_0.ui_tables.Visuals["Viewmodel x"].value)
  client.set_cvar("viewmodel_offset_y", r3_88)
  client.set_cvar("viewmodel_offset_z", r4_88)
  client.set_cvar("viewmodel_fov", r1_88)
end)
local r111_0 = client.screen_size
local r112_0 = entity.get_local_player
local r113_0 = entity.get_player_weapon
local r114_0 = entity.get_prop
local r115_0 = entity.is_alive
local r116_0 = globals.frametime
local r117_0 = renderer.gradient
local r118_0 = ui.get
local r119_0 = ui.new_checkbox
local r120_0 = ui.new_color_picker
local r121_0 = ui.new_slider
local r123_0 = ui.set
local r124_0 = ui.set_callback
local r125_0 = ui.set_visible
local function r126_0(r0_89, r1_89, r2_89)
  -- line: [0, 0] id: 89
  local r3_89 = r0_89
  local r4_89 = r3_89 < r1_89
  if r4_89 then
    r4_89 = r1_89
  end
  if not r4_89 then
    r4_89 = r3_89
  end
  r3_89 = r4_89
  r4_89 = r3_89 > r2_89
  if r4_89 then
    r4_89 = r2_89
  end
  if not r4_89 then
    r4_89 = r3_89
  end
  return r4_89
end
local r127_0 = require("gamesense/easing")
local r128_0 = 0
local r129_0 = ui.reference("VISUALS", "Effects", "Remove scope overlay")
local r130_0 = r49_0.ui_tables.Visuals["Custom Scop"].ref
local function r131_0()
  -- line: [0, 0] id: 90
  if not r49_0.ui_tables.Visuals["Custom Scop"].value then
    return 
  end
  r123_0(r129_0, true)
end
client.set_event_callback("paint", function()
  -- line: [0, 0] id: 91
  if not r49_0.ui_tables.Visuals["Custom Scop"].value then
    return 
  end
  r123_0(r129_0, false)
  local r0_91, r1_91 = r111_0()
  local r2_91 = r49_0.ui_tables.Visuals.Offset.value * r1_91 / r1_91
  local r3_91 = r49_0.ui_tables.Visuals.Delta.value * r1_91 / r1_91
  local r4_91 = 5
  local r5_91 = {
    255,
    255,
    255,
    255
  }
  local r6_91 = r112_0()
  local r7_91 = r113_0(r6_91)
  local r8_91 = r114_0(r7_91, "m_zoomLevel")
  local r9_91 = r114_0(r6_91, "m_bIsScoped") == 1
  local r10_91 = r114_0(r6_91, "m_bResumeZoom") == 1
  local r11_91 = r115_0(r6_91) and r7_91 ~= nil
  if r11_91 then
    r11_91 = r8_91 ~= nil
  end
  local r12_91 = r11_91 and r8_91 > 0
  if r12_91 then
    r12_91 = r9_91
  end
  if r12_91 then
    r12_91 = not r10_91
  end
  local r13_91 = r4_91 > 3
  if r13_91 then
    r13_91 = r116_0() * r4_91
  end
  if not r13_91 then
    r13_91 = 1
  end
  local r14_91 = r127_0.linear(r128_0, 0, 1, 1)
  r117_0(r0_91 / 2 - r3_91, r1_91 / 2, r3_91 - r2_91, 1, r5_91[1], r5_91[2], r5_91[3], 0, r5_91[1], r5_91[2], r5_91[3], r14_91 * r5_91[4], true)
  r117_0(r0_91 / 2 + r2_91, r1_91 / 2, r3_91 - r2_91, 1, r5_91[1], r5_91[2], r5_91[3], r14_91 * r5_91[4], r5_91[1], r5_91[2], r5_91[3], 0, true)
  r117_0(r0_91 / 2, r1_91 / 2 - r3_91, 1, r3_91 - r2_91, r5_91[1], r5_91[2], r5_91[3], 0, r5_91[1], r5_91[2], r5_91[3], r14_91 * r5_91[4], false)
  r117_0(r0_91 / 2, r1_91 / 2 + r2_91, 1, r3_91 - r2_91, r5_91[1], r5_91[2], r5_91[3], r14_91 * r5_91[4], r5_91[1], r5_91[2], r5_91[3], 0, false)
  local r15_91 = r126_0
  local r16_91 = r128_0
  local r17_91 = r12_91 and r13_91
  if not r17_91 then
    r17_91 = -r13_91
  end
  r128_0 = r15_91(r16_91 + r17_91, 0, 1)
end)
client.set_event_callback("paint_ui", r131_0)
local r133_0, r134_0, r135_0, r136_0 = ui.reference("VISUALS", "Colored models", "Local player")
local r137_0 = ui.reference("VISUALS", "Colored models", "Local player transparency")
local function r138_0()
  -- line: [0, 0] id: 92
  checkbox_player_value = ui.get(r133_0)
  box_player_value = ui.get(r135_0)
  color_player_value = ui.get(r135_0)
  ui.get(r134_0)
  if not checkbox_player_value or box_player_value ~= "Original" then
    ui.set(r133_0, false)
  end
end
r138_0()
client.set_event_callback("paint_ui", function()
  -- line: [0, 0] id: 93
  if r9_0 then
    return 
  end
  if checkbox_player_value then
    return 
  end
  local r0_93 = entity.get_local_player()
  local r2_93 = entity.get_classname(entity.get_player_weapon(r0_93))
  if not checkbox_player_value or box_player_value ~= "Original" then
    ui.set(r133_0, false)
  end
  if not r49_0.ui_tables.Visuals["Transperancy checkbox"].value then
    r138_0()
    return 
  end
  if not r0_93 then
    return 
  end
  if entity.get_prop(entity.get_local_player(), "m_bIsScoped") ~= 1 and r2_93 ~= "CIncendiaryGrenade" and r2_93 ~= "CMolotovGrenade" and r2_93 ~= "CHEGrenade" and r2_93 ~= "CSmokeGrenade" and r2_93 ~= "CFlashbang" then
    if r2_93 == "CDecoyGrenade" then
        ui.set(r133_0, true)
        ui.set(r135_0, "Original")
        ui.set(r134_0, 255, 255, 255, math.floor(255 - r49_0.ui_tables.Visuals.Transperancy.value * 2.5))
    else
      ui.set(r133_0, false)
    end
  else
    ui.set(r133_0, true)
    ui.set(r135_0, "Original")
    ui.set(r134_0, 255, 255, 255, math.floor(255 - r49_0.ui_tables.Visuals.Transperancy.value * 2.5))
  end
end)
