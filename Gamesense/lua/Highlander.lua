local http = require("gamesense/http")
local vector = require("vector")
local clipboard = require("gamesense/clipboard")
local base64 = require("gamesense/base64")
local pui = require("gamesense/pui")
local ffi = require("ffi")
local msgpack = require("gamesense/msgpack")
local modules = {
  lib_json = false,
  search = false,
  fn = false
}
ffi.cdef([[
    typedef struct mask {
        char m_pDriverName[512];
        unsigned int m_VendorID;
        unsigned int m_DeviceID;
        unsigned int m_SubSysID;
        unsigned int m_Revision;
        int m_nDXSupportLevel;
        int m_nMinDXSupportLevel;
        int m_nMaxDXSupportLevel;
        unsigned int m_nDriverVersionHigh;
        unsigned int m_nDriverVersionLow;
        int64_t pad_0;
        union {
            int xuid;
            struct {
                int xuidlow;
                int xuidhigh;
            };
        };
        char name[128];
        int userid;
        char guid[33];
        unsigned int friendsid;
        char friendsname[128];
        bool fakeplayer;
        bool ishltv;
        unsigned int customfiles[4];
        unsigned char filesdownloaded;
    };
    typedef int(__thiscall* get_current_adapter_fn)(void*);
    typedef void(__thiscall* get_adapters_info_fn)(void*, int adapter, struct mask& info);
    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);
    typedef struct { uint8_t r; uint8_t g; uint8_t b; uint8_t a; } color_struct_t;
    typedef void (__cdecl* console_color_print)(void*,const color_struct_t&, const char*, ...);
]])
local last_sim_time = 0
local defensive_until = 0
local tmpx, tmpy = client.screen_size
local tools = {
  lerp = function(start, end_pos, time)
    if start == end_pos then
      return end_pos
    end
    local frametime = globals.frametime() * 170
    time = time * frametime
    local val = start + (end_pos - start) * time
    if math.abs(val - end_pos) < 0.01 then
      return end_pos
    end
    return val
  end,
  distance = function(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
  end,
  dump = function(self, o)
    if type(o) == "table" then
      local s = "{ "
      for k, v in pairs(o) do
        if type(k) ~= "number" then
          k = "\"" .. k .. "\""
        end
        s = s .. "[" .. k .. "] = " .. self.dump(v) .. ","
      end
      return s .. "} "
    else
      return tostring(o)
    end
  end,
  get_hwid = function()
    local material_system = client.create_interface("materialsystem.dll", "VMaterialSystem080")
    local material_interface = ffi.cast("void***", material_system)[0]
    local get_current_adapter = ffi.cast("get_current_adapter_fn", material_interface[25])
    local get_adapter_info = ffi.cast("get_adapters_info_fn", material_interface[26])
    local current_adapter = get_current_adapter(material_interface)
    local adapter_struct = ffi.new("struct mask")
    get_adapter_info(material_interface, current_adapter, adapter_struct)
    local driverName = tostring(ffi.string(adapter_struct.m_pDriverName))
    local vendorId = tostring(adapter_struct.m_VendorID)
    local deviceId = tostring(adapter_struct.m_DeviceID)
    local class_ptr = ffi.typeof("void***")
    local rawfilesystem = client.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
    local filesystem = ffi.cast(class_ptr, rawfilesystem)
    local file_exists = ffi.cast("file_exists_t", filesystem[0][10])
    local get_file_time = ffi.cast("get_file_time_t", filesystem[0][13])
    local function bruteforce_directory()
      for i = 65, 90 do
        local directory = string.char(i) .. ":\\Windows\\Setup\\State\\State.ini"
        if file_exists(filesystem, directory, "ROOT") then
          return directory
        end
      end
      return nil
    end
    local directory = bruteforce_directory()
    local install_time = get_file_time(filesystem, directory, "ROOT")
    local hardwareID = install_time * 2
    local hwid = vendorId * deviceId * 5 + hardwareID
    return hwid
  end,
  get_date_from_unix = function(unix_time)
    local day_count, year, days, month = function(yr)
      return yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0) and 366 or 365
    end, 1970, math.ceil(unix_time / 86400)
    while days >= day_count(year) do
      days = days - day_count(year)
      year = year + 1
    end
    local tab_overflow = function(seed, table)
      for i = 1, #table do
        if seed - table[i] <= 0 then
          return i, seed
        end
        seed = seed - table[i]
      end
    end
    month, days = tab_overflow(days, {
      31,
      day_count(year) == 366 and 29 or 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    })
    local hours, minutes, seconds = math.floor(unix_time / 3600 % 24), math.floor(unix_time / 60 % 60), math.floor(unix_time % 60)
    local period = 12 < hours and "pm" or "am"
    hours = 12 < hours and hours - 12 or hours == 0 and 12 or hours
    return string.format("%d/%d/%04d %02d:%02d:%02d %s", days, month, year, hours, minutes, seconds, period)
  end,
  color_print = function(r, g, b, a, text)
    if r == nil or g == nil or b == nil or a == nil then
      return
    end
    local col = ffi.new("color_struct_t")
    col.r = r
    col.g = g
    col.b = b
    col.a = a
    ffi.cast("console_color_print", ffi.cast(ffi.typeof("uintptr_t**"), client.create_interface("vstdlib.dll", "VEngineCvar007"))[0][25])(ffi.cast(ffi.typeof("uintptr_t**"), client.create_interface("vstdlib.dll", "VEngineCvar007")), col, text)
  end,
  is_defensive_active = function(local_player)
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(local_player, "m_flSimulationTime"))
    if last_sim_time == 0 then
      last_sim_time = sim_time
      return false
    end
    local sim_diff = sim_time - last_sim_time
    if sim_diff < 0 then
      defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
    end
    last_sim_time = sim_time
    return tickcount < defensive_until
  end,
  hitgroup_str = {
    [0] = "generic",
    "head",
    "chest",
    "stomach",
    "left arm",
    "right arm",
    "left leg",
    "right leg",
    "neck",
    "generic",
    "gear"
  },
  hitbox_str = {
    head = 0,
    neck = 1,
    pelvis = 2,
    body = 3,
    thorax = 4,
    chest = 5,
    ["upper chest"] = 6,
    ["right thigh"] = 7,
    ["left thigh"] = 8,
    ["right calf"] = 9,
    ["left calf"] = 10,
    ["right foot"] = 11,
    ["left foot"] = 12,
    ["right hand"] = 13,
    ["left hand"] = 14,
    ["right upper arm"] = 15,
    ["right forearm"] = 16,
    ["left upper arm"] = 17,
    ["left forearm"] = 18
  },
  E_POSE_PARAMETERS = {
    STRAFE_YAW = 0,
    STAND = 1,
    LEAN_YAW = 2,
    SPEED = 3,
    LADDER_YAW = 4,
    LADDER_SPEED = 5,
    JUMP_FALL = 6,
    MOVE_YAW = 7,
    MOVE_BLEND_CROUCH = 8,
    MOVE_BLEND_WALK = 9,
    MOVE_BLEND_RUN = 10,
    BODY_YAW = 11,
    BODY_PITCH = 12,
    AIM_BLEND_STAND_IDLE = 13,
    AIM_BLEND_STAND_WALK = 14,
    AIM_BLEND_STAND_RUN = 14,
    AIM_BLEND_CROUCH_IDLE = 16,
    AIM_BLEND_CROUCH_WALK = 17,
    DEATH_YAW = 18
  },
  screensize = {x = tmpx, y = tmpy},
  flash = 0,
  flashswitch = false,
  updateflash = function(self)
    if self.flashswitch == true then
      self.flash = self.flash + 2
    else
      self.flash = self.flash - 2
    end
    if self.flash > 255 then
      self.flashswitch = not self.flashswitch
    elseif self.flash < 0 then
      self.flashswitch = not self.flashswitch
    end
  end
}
local groups = {
  antiaim = pui.group("aa", "anti-aimbot angles"),
  fakelag = pui.group("aa", "fake lag"),
  lua = pui.group("lua", "b")
}
pui.accent = "9DA8D6FF"
local accentcolor = ui.new_color_picker("lua", "b", "accent color", 157, 168, 214, 255)
local function print(text)
  local tmpr, tmpg, tmpb = ui.get(accentcolor)
  tools.color_print(tmpr, tmpg, tmpb, 255, "[highlander] ")
  tools.color_print(198, 203, 209, 255, tostring(text))
  tools.color_print(198, 203, 209, 255, "\n")
end
local ref = {
  aa_enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
  pitch = {
    ui.reference("AA", "Anti-aimbot angles", "Pitch")
  },
  yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
  yaw = {
    ui.reference("AA", "Anti-aimbot angles", "Yaw")
  },
  yaw_jitter = {
    ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
  },
  body_yaw = {
    ui.reference("AA", "Anti-aimbot angles", "Body yaw")
  },
  freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
  edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
  freestanding = {
    ui.reference("AA", "Anti-aimbot angles", "Freestanding")
  },
  roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
  fakelag_enable = {
    ui.reference("AA", "Fake Lag", "Enabled")
  },
  fakelag_mode = ui.reference("AA", "Fake Lag", "Amount"),
  fakelag_variance = ui.reference("AA", "Fake Lag", "Variance"),
  fakelag_limit = ui.reference("AA", "Fake Lag", "Limit"),
  leg_movement = ui.reference("AA", "Other", "Leg movement"),
  double_tap = {
    ui.reference("RAGE", "Aimbot", "Double tap")
  },
  double_tap_fake_lag_limit = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit"),
  onshot_aa = {
    ui.reference("AA", "Other", "On shot anti-aim")
  },
  quick_peek_assist = {
    ui.reference("RAGE", "Other", "Quick peek assist")
  },
  duck_peek_assist = ui.reference("RAGE", "Other", "Duck peek assist"),
  slow_motion = {
    ui.reference("AA", "Other", "Slow motion")
  },
  mindamage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
  mindamage_override = {
    ui.reference("RAGE", "Aimbot", "Minimum damage override")
  },
  force_safe_point = {
    ui.reference("RAGE", "Aimbot", "Force safe point")
  },
  hitchance = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
  ui_color = ui.reference("MISC", "Settings", "Menu color"),
  ping_spike = {
    ui.reference("MISC", "Miscellaneous", "Ping spike")
  },
  indicators = ui.reference("VISUALS", "Other ESP", "Feature Indicators"),
  weapon = ui.reference("RAGE", "Weapon Type", "Weapon Type")
}
local function restorevis()
  ui.set(ref.aa_enabled, true)
  ui.set_visible(ref.aa_enabled, true)
  ui.set_visible(ref.pitch[1], true)
  ui.set_visible(ref.pitch[2], true)
  ui.set_visible(ref.yaw_base, true)
  ui.set_visible(ref.yaw[1], true)
  ui.set_visible(ref.yaw[2], true)
  ui.set_visible(ref.yaw_jitter[1], true)
  ui.set_visible(ref.yaw_jitter[2], true)
  ui.set_visible(ref.body_yaw[1], true)
  ui.set_visible(ref.body_yaw[2], true)
  ui.set_visible(ref.freestanding_body_yaw, true)
  ui.set_visible(ref.edge_yaw, true)
  ui.set_visible(ref.freestanding[1], true)
  ui.set_visible(ref.freestanding[2], true)
  ui.set_visible(ref.roll, true)
end
local loggedin = true
local executed = false
local localuser = "https://discord.gg/Ns5X56rBHF | Odyssey"
local function codechunk()
  executed = true
  print("Loading Lua...")
  local config = {cfg = nil}
  local states = {
    "Global",
    "Stand",
    "Slow Walk",
    "Move",
    "Crouch",
    "Crouch Move",
    "Air",
    "Air Crouch"
  }
  local hitgroup_names = {
    "generic",
    "head",
    "chest",
    "stomach",
    "left arm",
    "right arm",
    "left leg",
    "right leg",
    "neck",
    "?",
    "gear"
  }
  local function hidevis()
    ui.set(ref.aa_enabled, false)
    ui.set_visible(ref.aa_enabled, false)
    ui.set_visible(ref.pitch[1], false)
    ui.set_visible(ref.pitch[2], false)
    ui.set_visible(ref.yaw_base, false)
    ui.set_visible(ref.yaw[1], false)
    ui.set_visible(ref.yaw[2], false)
    ui.set_visible(ref.yaw_jitter[1], false)
    ui.set_visible(ref.yaw_jitter[2], false)
    ui.set_visible(ref.body_yaw[1], false)
    ui.set_visible(ref.body_yaw[2], false)
    ui.set_visible(ref.freestanding_body_yaw, false)
    ui.set_visible(ref.edge_yaw, false)
    ui.set_visible(ref.freestanding[1], false)
    ui.set_visible(ref.freestanding[2], false)
    ui.set_visible(ref.roll, false)
  end
  function entity.get_vector_prop(idx, prop, array)
    local v1, v2, v3 = entity.get_prop(idx, prop, array)
    return {
      x = v1,
      y = v2,
      z = v3
    }
  end
  function math.vec_length2d(vec)
    root = 0
    sqst = vec.x * vec.x + vec.y * vec.y
    root = math.sqrt(sqst)
    return root
  end
  local menu = {
    nav = {
      welcome = groups.antiaim:label("Welcom\bBEBEBEFF\b9DA8D6FF[e to Highlander]"),
      user = groups.antiaim:label(string.format("User: \v%s", localuser)),
      sep = groups.antiaim:label(" "),
      back = groups.antiaim:button("\vBack"),
      configs = groups.antiaim:button("Configs"),
      ragebot = groups.antiaim:button("Ragebot"),
      antiaim = groups.antiaim:button("Anti-aim"),
      visuals = groups.antiaim:button("Visuals"),
      misc = groups.antiaim:button("Misc"),
      menuslider = groups.antiaim:slider("menudebug", 0, 6),
      aaslider = groups.antiaim:slider("aadebug", 0, 8),
      separator = groups.antiaim:label(" ")
    },
    config = {
      export = groups.antiaim:button("Export"),
      import = groups.antiaim:button("Import")
    },
    antiaim = {
      tab = groups.antiaim:combobox([[

 ]], {
        "Builder",
        "Features",
        "Binds"
      }),
      builder = {
        enable = groups.antiaim:checkbox("Enable Builder"),
        state = groups.antiaim:combobox([[

 ]], states)
      },
      binds = {
        freestand = groups.antiaim:hotkey("Freestand")
      }
    },
    misc = {
      logs = groups.antiaim:checkbox("Aimbot Logs")
    }
  }
  for i = 1, #states do
    local prefix = states[i] .. " "
    menu.antiaim.builder[i] = {
      override = groups.antiaim:checkbox("Override " .. states[i]),
      pitch = groups.antiaim:combobox("Pitch", {
        "Off",
        "Default",
        "Up",
        "Down",
        "Minimal",
        "Random",
        "Custom"
      }),
      custom_pitch = groups.antiaim:slider([[

Custom pitch]], -89, 89, 0, true, "\194\176", 1),
      yaw_base = groups.antiaim:combobox("Yaw base", {"Local view", "At targets"}),
      yaw_type = groups.antiaim:combobox("Yaw", {
        "Static",
        "Left / Right",
        "Delayed"
      }),
      yaw_value = groups.antiaim:slider([[

Yaw value]], -180, 180, 0, true, "\194\176", 1),
      delay_type = groups.antiaim:combobox("Delay Type", {
        "Automatic",
        "Manual",
        "Randomized Manual"
      }),
      delay_value = groups.antiaim:slider("Jitter delay", 3, 32, 0, true, "t", 1),
      left_yaw = groups.antiaim:slider("Left yaw", -180, 180, 0, true, "\194\176", 1),
      right_yaw = groups.antiaim:slider("Right yaw", -180, 180, 0, true, "\194\176", 1),
      yaw_jitter = groups.antiaim:combobox("Yaw jitter", {
        "Off",
        "Offset",
        "Center",
        "Random",
        "Skitter"
      }),
      yaw_jitter_value = groups.antiaim:slider([[

Yaw jitter value]], -180, 180, 0, true, "\194\176", 1),
      body_yaw = groups.antiaim:combobox("Body yaw", {
        "Off",
        "Opposite",
        "Jitter",
        "Static"
      }),
      body_yaw_value = groups.antiaim:slider([[

Body yaw value]], -180, 180, 0, true, "\194\176", 1),
      defensive = groups.antiaim:combobox("Defensive", {
        "Off",
        "Force",
        "Anti-aim"
      }),
      defensive_pitch = groups.antiaim:combobox("Defensive Pitch", {
        "Inherit",
        "Up",
        "Half-Up",
        "Zero",
        "Half-Down",
        "Down",
        "Random",
        "Custom",
        "Switch",
        "Clock"
      }),
      defensive_pitch_value = groups.antiaim:slider([[

Pitch value]], -89, 89, 0, true, "\194\176", 1),
      defensive_pitch_value2 = groups.antiaim:slider([[

Pitch value]], -89, 89, 0, true, "\194\176", 1),
      defensive_yaw = groups.antiaim:combobox("Defensive Yaw", {
        "Inherited",
        "Static",
        "Sideways",
        "Switch",
        "Spin",
        "Random Spin",
        "Random",
        "Left",
        "Right",
        "Clock"
      }),
      defensive_yaw_value = groups.antiaim:slider([[

Yaw value]], -180, 180, 0, true, "\194\176", 1)
    }
  end
  local global = {
    current_state = "",
    current_state_number = 0,
    update = function(self)
      local local_player = entity.get_local_player()
      if not local_player then
        return
      end
      local m_vecVelocity = entity.get_vector_prop(local_player, "m_vecVelocity")
      local velocity = math.vec_length2d(m_vecVelocity)
      local flags = entity.get_prop(local_player, "m_fFlags")
      local ducking = bit.lshift(1, 1)
      local ground = bit.lshift(1, 0)
      local function state()
        if bit.band(flags, ground) == 1 and velocity < 3 and bit.band(flags, ducking) == 0 then
          self.current_state = "Stand"
          self.current_state_number = 2
        elseif bit.band(flags, ground) == 1 and 3 < velocity and bit.band(flags, ducking) == 0 and ui.get(ref.slow_motion[2]) then
          self.current_state = "Slow Walk"
          self.current_state_number = 3
        end
        if bit.band(flags, ground) == 1 and 3 < velocity and bit.band(flags, ducking) == 0 and not ui.get(ref.slow_motion[2]) then
          self.current_state = "Moving"
          self.current_state_number = 4
        end
        if bit.band(flags, ground) == 1 and bit.band(flags, ducking) > 0.9 and menu.antiaim.builder[6].override:get() and 10 < velocity then
          self.current_state = "Crouch Move"
          self.current_state_number = 6
        elseif bit.band(flags, ground) == 1 and bit.band(flags, ducking) > 0.9 then
          self.current_state = "Crouch"
          self.current_state_number = 5
        end
        if bit.band(flags, ground) == 0 and bit.band(flags, ducking) == 0 then
          self.current_state = "Air"
          self.current_state_number = 7
        end
        if bit.band(flags, ground) == 0 and bit.band(flags, ducking) > 0.9 then
          self.current_state = "Air+C"
          self.current_state_number = 8
        end
      end
      state()
    end
  }
  menu.antiaim.builder.disclaimer = groups.antiaim:label("\a9DA8D6FFDefaulting to Crouch State")
  local ground_ticks = 0
  local pitchswitch = false
  local pitchswitch2 = false
  local lastdefensive = false
  local currentpitch = -89
  local currentyaw = -60
  local goalpitch = 0
  local goalyaw = 0
  local speen = 0
  local function speeen(direction, speed)
    speen = speen + speed / 2 * direction
    if speen < -180 then
      speen = speen + 360
    elseif 180 < speen then
      speen = speen - 360
    end
    return speen
  end
  local function test()
    if currentpitch <= -88 then
      goalpitch = 89
    elseif 88 <= currentpitch then
      goalpitch = -89
    end
    currentpitch = tools.lerp(currentpitch, goalpitch, 0.1)
  end
  local function test2()
    if currentyaw <= -59 then
      goalyaw = 60
    elseif 59 <= currentyaw then
      goalyaw = -60
    end
    currentyaw = tools.lerp(currentyaw, goalyaw, 0.1)
  end
  local function freestanding()
    local temptable = ui.get(ref.indicators)
    if menu.antiaim.binds.freestand:get() then
      for k, v in pairs(temptable) do
        if v == "Freestanding" then
          table.remove(temptable, k)
        end
      end
      ui.set(ref.indicators, temptable)
      renderer.indicator(200, 199, 197, 255, "FS")
      ui.set(ref.freestanding[2], "Always on")
      ui.set(ref.freestanding[1], true)
    else
      temptable[#temptable + 1] = "Freestanding"
      ui.set(ref.indicators, temptable)
      ui.set(ref.freestanding[1], false)
    end
  end
  local function antiaimhandle(ctx)
    local lplr = entity.get_local_player()
    local pitch, yaw = client.camera_angles()
    local currentstate = menu.antiaim.builder[global.current_state_number].override:get() and global.current_state_number or 1
    local bodyyaw = entity.get_prop(lplr, "m_flPoseParameter", 11) * 120 - 60
    local side = 0 < bodyyaw and 1 or -1
    ui.set(ref.aa_enabled, menu.antiaim.builder.enable:get())
    ui.set(ref.pitch[1], menu.antiaim.builder[currentstate].pitch:get())
    ui.set(ref.pitch[2], menu.antiaim.builder[currentstate].custom_pitch:get())
    ui.set(ref.body_yaw[1], menu.antiaim.builder[currentstate].body_yaw:get())
    ui.set(ref.body_yaw[2], menu.antiaim.builder[currentstate].body_yaw_value:get())
    ui.set(ref.yaw_jitter[1], menu.antiaim.builder[currentstate].yaw_jitter:get())
    ui.set(ref.yaw_jitter[2], menu.antiaim.builder[currentstate].yaw_jitter_value:get())
    ui.set(ref.yaw_base, menu.antiaim.builder[currentstate].yaw_base:get())
    ui.set(ref.yaw[1], "180")
    if menu.antiaim.builder[currentstate].yaw_type:get() == "Static" then
      ui.set(ref.yaw[2], menu.antiaim.builder[currentstate].yaw_value:get())
    elseif menu.antiaim.builder[currentstate].yaw_type:get() == "Left / Right" then
      ui.set(ref.yaw[2], side == 1 and menu.antiaim.builder[currentstate].left_yaw:get() or menu.antiaim.builder[currentstate].right_yaw:get())
    end
    if menu.antiaim.builder[currentstate].defensive:get() ~= "Off" then
      ctx.force_defensive = true
    end
    if lastdefensive ~= tools.is_defensive_active(lplr) and tools.is_defensive_active(lplr) then
      pitchswitch = not pitchswitch
    end
    if tools.is_defensive_active(lplr) and menu.antiaim.builder[currentstate].defensive:get() == "Anti-aim" and (ui.get(ref.double_tap[2]) or ui.get(ref.onshot_aa[1])) then
      if menu.antiaim.builder[currentstate].defensive_pitch:get() == "Up" then
        ui.set(ref.pitch[1], "Custom")
        ui.set(ref.pitch[2], -89)
      elseif menu.antiaim.builder[currentstate].defensive_pitch:get() == "Half-Up" then
        ui.set(ref.pitch[1], "Custom")
        ui.set(ref.pitch[2], -45)
      elseif menu.antiaim.builder[currentstate].defensive_pitch:get() == "Zero" then
        ui.set(ref.pitch[1], "Custom")
        ui.set(ref.pitch[2], 0)
      elseif menu.antiaim.builder[currentstate].defensive_pitch:get() == "Half-Down" then
        ui.set(ref.pitch[1], "Custom")
        ui.set(ref.pitch[2], 45)
      elseif menu.antiaim.builder[currentstate].defensive_pitch:get() == "Down" then
        ui.set(ref.pitch[1], "Down")
        ui.set(ref.pitch[2], 45)
      elseif menu.antiaim.builder[currentstate].defensive_pitch:get() == "Custom" then
        ui.set(ref.pitch[1], "Custom")
        ui.set(ref.pitch[2], menu.antiaim.builder[currentstate].defensive_pitch_value:get())
      elseif menu.antiaim.builder[currentstate].defensive_pitch:get() == "Clock" then
        ui.set(ref.pitch[1], "Custom")
        ui.set(ref.pitch[2], currentpitch)
      elseif menu.antiaim.builder[currentstate].defensive_pitch:get() == "Random" then
        ui.set(ref.pitch[1], "Custom")
        ui.set(ref.pitch[2], math.random(-89, 89))
      elseif menu.antiaim.builder[currentstate].defensive_pitch:get() == "Switch" then
        ui.set(ref.pitch[1], "Custom")
        ui.set(ref.pitch[2], pitchswitch and menu.antiaim.builder[currentstate].defensive_pitch_value:get() or menu.antiaim.builder[currentstate].defensive_pitch_value2:get())
      end
      if menu.antiaim.builder[currentstate].defensive_yaw:get() ~= "Inherited" then
        ui.set(ref.body_yaw[1], "Static")
        ui.set(ref.yaw_jitter[1], "Off")
      end
      if menu.antiaim.builder[currentstate].defensive_yaw:get() == "Clock" then
        ui.set(ref.yaw[2], currentyaw)
      elseif menu.antiaim.builder[currentstate].defensive_yaw:get() == "Static" then
        ui.set(ref.yaw[2], menu.antiaim.builder[currentstate].defensive_yaw_value:get())
      elseif menu.antiaim.builder[currentstate].defensive_yaw:get() == "Sideways" then
        ui.set(ref.body_yaw[1], "Jitter")
        ui.set(ref.yaw[2], side == 1 and -90 or 90)
      elseif menu.antiaim.builder[currentstate].defensive_yaw:get() == "Switch" then
        ui.set(ref.yaw[2], 0)
      elseif menu.antiaim.builder[currentstate].defensive_yaw:get() == "Spin" then
        print(menu.antiaim.builder[currentstate].defensive_yaw_value:get())
        ui.set(ref.yaw[2], speeen(1, menu.antiaim.builder[currentstate].defensive_yaw_value:get()))
      elseif menu.antiaim.builder[currentstate].defensive_yaw:get() == "Random Spin" then
        ui.set(ref.yaw[2], 0)
      elseif menu.antiaim.builder[currentstate].defensive_yaw:get() == "Random" then
        ui.set(ref.yaw[2], math.random(-180, 180))
      elseif menu.antiaim.builder[currentstate].defensive_yaw:get() == "Left" then
        ui.set(ref.yaw[2], 90)
      elseif menu.antiaim.builder[currentstate].defensive_yaw:get() == "Right" then
        ui.set(ref.yaw[2], -90)
      end
    end
    lastdefensive = tools.is_defensive_active(lplr)
  end
  local aimpos = vector(0, 0, 0)
  local aimtick = 0
  local aimdmg = 0
  local aimhg = 0
  local flags = {}
  local function logs1(ctx)
    if not menu.misc.logs:get() then
      return
    end
    aimpos.x, aimpos.y, aimpos.z = entity.hitbox_position(ctx.target, 0)
    aimtick = ctx.tick
    aimdmg = ctx.damage
    aimhg = ctx.hitgroup
    flags = {
      ctx.teleported and "T" or "",
      ctx.interpolated and "I" or "",
      ctx.extrapolated and "E" or "",
      ctx.high_priority and "H" or ""
    }
  end
  local function logshit(ctx)
    if not menu.misc.logs:get() then
      return
    end
    local hitpos = vector(0, 0, 0)
    hitpos.x, hitpos.y, hitpos.z = entity.hitbox_position(ctx.target, 0)
    local distance = tools.distance(hitpos.x, hitpos.y, hitpos.z, aimpos.x, aimpos.y, aimpos.z)
    local backtrack = globals.tickcount() - aimtick - 1
    print(string.format("Hit: %s(%i%s) in %s(%s) for %i(%i) damage | history(\206\148): %i | flags(\194\164): %s", entity.get_player_name(ctx.target), math.floor(ctx.hit_chance + 0.5), "%%", tools.hitgroup_str[ctx.hitgroup], tools.hitgroup_str[aimhg], ctx.damage, aimdmg, backtrack, table.concat(flags) == "" and "-" or table.concat(flags)))
  end
  local function logsmiss(ctx)
    if not menu.misc.logs:get() then
      return
    end
    local hitpos = vector(0, 0, 0)
    hitpos.x, hitpos.y, hitpos.z = entity.hitbox_position(ctx.target, 0)
    local distance = tools.distance(hitpos.x, hitpos.y, hitpos.z, aimpos.x, aimpos.y, aimpos.z)
    local backtrack = globals.tickcount() - aimtick - 1
    local customreason = ctx.reason
    if customreason == "?" and 30 < distance then
      customreason = "lagcomp failure"
    end
    if customreason == "?" then
      customreason = "resolver"
    end
    print(string.format("Miss: %s in %s(%i%s) for %i damage due to %s | history(\206\148): %i | flags(\194\164): %s", entity.get_player_name(ctx.target), tools.hitgroup_str[aimhg], math.floor(ctx.hit_chance + 0.5), "%%", aimdmg, customreason, backtrack, table.concat(flags) or "-"))
  end
  menu.antiaim.tab:depend({
    menu.nav.menuslider,
    3
  })
  menu.antiaim.builder.enable:depend({
    menu.nav.menuslider,
    3
  }, {
    menu.antiaim.tab,
    "Builder"
  })
  menu.antiaim.builder.disclaimer:depend({
    menu.nav.menuslider,
    3
  }, {
    menu.antiaim.tab,
    "Builder"
  }, {
    menu.antiaim.builder.state,
    "Crouch Move"
  }, {
    menu.antiaim.builder[6].override,
    false
  })
  menu.antiaim.builder.state:depend({
    menu.nav.menuslider,
    3
  }, {
    menu.antiaim.tab,
    "Builder"
  }, {
    menu.antiaim.builder.enable,
    true
  })
  for i = 1, #states do
    if i == 1 then
      menu.antiaim.builder[i].override:set(true)
      menu.antiaim.builder[i].override:depend({
        menu.nav.menuslider,
        3
      }, {
        menu.nav.menuslider,
        0
      }, {
        menu.antiaim.builder.enable
      })
    end
    menu.antiaim.binds.freestand:depend({
      menu.antiaim.tab,
      "Binds"
    }, {
      menu.nav.menuslider,
      3
    })
    menu.antiaim.builder[i].override:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    })
    menu.antiaim.builder[i].pitch:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    })
    menu.antiaim.builder[i].custom_pitch:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].pitch,
      "Custom"
    })
    menu.antiaim.builder[i].yaw_base:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    })
    menu.antiaim.builder[i].yaw_type:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    })
    menu.antiaim.builder[i].yaw_value:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].yaw_type,
      "Static"
    })
    menu.antiaim.builder[i].delay_type:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].yaw_type,
      "Delayed"
    })
    menu.antiaim.builder[i].delay_value:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].yaw_type,
      "Delayed"
    }, {
      menu.antiaim.builder[i].delay_type,
      "Automatic",
      true
    })
    menu.antiaim.builder[i].left_yaw:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].yaw_type,
      "Static",
      true
    })
    menu.antiaim.builder[i].right_yaw:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].yaw_type,
      "Static",
      true
    })
    menu.antiaim.builder[i].yaw_jitter:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    })
    menu.antiaim.builder[i].yaw_jitter_value:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].yaw_jitter,
      "Off",
      true
    })
    menu.antiaim.builder[i].body_yaw:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    })
    menu.antiaim.builder[i].body_yaw_value:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].body_yaw,
      "Jitter",
      "Static"
    })
    menu.antiaim.builder[i].defensive:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    })
    menu.antiaim.builder[i].defensive_pitch:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].defensive,
      "Anti-aim"
    })
    menu.antiaim.builder[i].defensive_pitch_value:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].defensive_pitch,
      "Custom",
      "Switch"
    }, {
      menu.antiaim.builder[i].defensive,
      "Anti-aim"
    })
    menu.antiaim.builder[i].defensive_pitch_value2:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].defensive_pitch,
      "Switch"
    }, {
      menu.antiaim.builder[i].defensive,
      "Anti-aim"
    })
    menu.antiaim.builder[i].defensive_yaw:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].defensive,
      "Anti-aim"
    })
    menu.antiaim.builder[i].defensive_yaw_value:depend({
      menu.antiaim.tab,
      "Builder"
    }, {
      menu.nav.menuslider,
      3
    }, {
      menu.antiaim.builder.enable,
      true
    }, {
      menu.antiaim.builder[i].override,
      true
    }, {
      menu.antiaim.builder.state,
      states[i]
    }, {
      menu.antiaim.builder[i].defensive_yaw,
      "Static",
      "Spin"
    }, {
      menu.antiaim.builder[i].defensive_yaw,
      "Spin"
    }, {
      menu.antiaim.builder[i].defensive,
      "Anti-aim"
    })
  end
  menu.nav.antiaim:set_callback(function()
    menu.nav.menuslider:set(3)
  end)
  menu.nav.back:set_callback(function()
    menu.nav.menuslider:set(0)
  end)
  menu.nav.ragebot:set_callback(function()
    menu.nav.menuslider:set(2)
  end)
  menu.nav.configs:set_callback(function()
    menu.nav.menuslider:set(1)
  end)
  menu.nav.visuals:set_callback(function()
    menu.nav.menuslider:set(4)
  end)
  menu.nav.misc:set_callback(function()
    menu.nav.menuslider:set(5)
  end)
  local temp = ""
  local temptable = {}
  menu.config.export:set_callback(function()
    local data = config.cfg:save()
    local new_data = msgpack.pack(data)
    local encrypted = base64.encode(new_data)
    clipboard.set(encrypted)
  end)
  menu.config.import:set_callback(function()
    local cfg = clipboard.get()
    local decrypted = base64.decode(cfg)
    local new_data = msgpack.unpack(decrypted)
    config.cfg:load(new_data)
  end)
  menu.nav.welcome:depend({
    menu.nav.menuslider,
    0
  })
  menu.nav.user:depend({
    menu.nav.menuslider,
    0
  })
  menu.nav.sep:depend({
    menu.nav.menuslider,
    0
  })
  menu.nav.antiaim:depend({
    menu.nav.menuslider,
    0
  })
  menu.nav.back:depend({
    menu.nav.menuslider,
    1,
    6
  })
  menu.nav.ragebot:depend({
    menu.nav.menuslider,
    0
  })
  menu.nav.configs:depend({
    menu.nav.menuslider,
    0
  })
  menu.nav.visuals:depend({
    menu.nav.menuslider,
    0
  })
  menu.nav.misc:depend({
    menu.nav.menuslider,
    0
  })
  menu.misc.logs:depend({
    menu.nav.menuslider,
    5
  })
  menu.nav.menuslider:depend({
    menu.nav.menuslider,
    -1
  })
  menu.nav.aaslider:depend({
    menu.nav.menuslider,
    -1
  })
  menu.config.export:depend({
    menu.nav.menuslider,
    1
  })
  menu.config.import:depend({
    menu.nav.menuslider,
    1
  })
  client.set_event_callback("setup_command", function(ctx)
    global:update()
    antiaimhandle(ctx)
  end)
  client.set_event_callback("aim_fire", function(ctx)
    logs1(ctx)
  end)
  client.set_event_callback("aim_hit", function(ctx)
    logshit(ctx)
  end)
  client.set_event_callback("aim_miss", function(ctx)
    logsmiss(ctx)
  end)
  client.set_event_callback("paint_ui", function(ctx)
    hidevis()
    freestanding()
  end)
  client.set_event_callback("paint", function(ctx)
    test()
    test2()
  end)
  config.cfg = pui.setup(menu)
end
codechunk()
client.set_event_callback("shutdown", restorevis)
