-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
LUA_BUILD = "Live"
LUA_TYPE = "Rage"

local bit = require "bit"
local ffi = require "ffi"

Discord = require("gamesense/discord_webhooks") or error("Missing discord_webhooks library")
clipboard = require('gamesense/clipboard') or error("Missing clipboard library")
base64 = require("gamesense/base64") or error("Missing base64 library")
AntiAimFunctionsLib = require("gamesense/antiaim_funcs") or error("Missing antiaim_funcs library")
easing = require("gamesense/easing") or error("Missing easing library")
EntityLib = require("gamesense/entity") or error("Missing entity library")
vector = require('vector') or error("Missing vector library")
http = require("gamesense/http") or error("Missing http library")
images = require ("gamesense/images") or error("Missing images library")
color = require("gamesense/color")

---override menu
override_system = {}
ui_ = {}

override_system.thread = 'main'
override_system.history = {}

override_system.get = function(key, result_only)
    local this = override_system.history[key]
    if not this then
        return
    end

    if result_only then
        return unpack(this.m_result)
    end

    return this
end
override_system.new = function(key, event_name, func)
  local this = {}
  this.m_key = key
  this.m_event_name = event_name
  this.m_func = func
  this.m_result = {}

  local handler = function(ST)
      override_system.thread = event_name
      this.m_result = { func(ST) }
  end

  local protect = function(ST)
      local success, result = pcall(handler, ST)

      if success then
          return
      end

      if isDebug then
          result = f('%s, debug info: key = %s, event_name = %s', result, key, event_name)
      end


  end

  client.set_event_callback(event_name, protect)
  this.m_protect = protect

  override_system.history[key] = this
  return this
end



override_system.thread = 'main'
override_system.history = {}



ui_.history = {}
ui_.override = function(id, ST)
      if ui_.history[override_system.thread] == nil then
          ui_.history[override_system.thread] = {}

          local handler = function()
              local dir = ui_.history[override_system.thread]

              for k, v in pairs(dir) do
                  if v.active then
                      v.active = false;
                      goto skip;
                  end

                  ui.set(k, unpack(v.value));
                  dir[k] = nil;

                  ::skip::
              end
          end

          override_system.new('menu::override::' .. override_system.thread, override_system.thread, handler)
      end

      local args = { ST }

      if #args == 0 then
          return
      end

      if ui_.history[override_system.thread][id] == nil then
          local item = { };
          local value = { ui.get(id) };

          if ui.type(id) == "hotkey" then
              value = {enum.ui.hotkey_states[value[2]]};
          end

          item.value = value;
          ui_.history[override_system.thread][id] = item;
      end

      ui_.history[override_system.thread][id].active = true;
      ui.set(id, ST);
end

ui_.shutdown = function()
    for k, v in pairs(ui_.history) do
        for x, y in pairs(v) do
            if y.backup == nil then
                goto skip
            end

            ui.set(x, unpack(y.backup))
            y.backup = nil
            ::skip::
        end
    end
end

override_system.new('menu::restore', 'pre_config_save', ui_.shutdown)
override_system.new('menu::shutdown_vis', 'shutdown', ui_.visibility_shutdown)
override_system.new('menu::color_label', 'paint_ui', ui_.handle_colorushka)

--entitys
entitys = {
  velocity = function(e)
    vx, vy = entity.get_prop(e, "m_vecVelocity")
    velocity = math.sqrt(vx * vx + vy * vy)
    return velocity
  end,
  vector = function(angle_x, angle_y)
    local sy = math.sin(math.rad(angle_y))
    local cy = math.cos(math.rad(angle_y))
    local sp = math.sin(math.rad(angle_x))
    local cp = math.cos(math.rad(angle_x))
    return cp * cy, cp * sy, -sp
  end,
  Contains = function(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
  end,
  
  RGBtoHEX = function(redArg, greenArg, blueArg)
    return string.format("%.2x%.2x%.2xFF", redArg, greenArg, blueArg)
  end,

  RGBtoDecimal = function(red_arg, green_arg, blue_arg)
    return red_arg * 65536 + green_arg * 256 + blue_arg
  end,
  DistanceCal = function(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
  end,

  rectangle_outline = function(x, y, w, h, r, g, b, a, s)
    s = s or 1
    renderer.rectangle(x, y, w, s, r, g, b, a) -- top
    renderer.rectangle(x, y+h-s, w, s, r, g, b, a) -- bottom
    renderer.rectangle(x, y+s, s, h-s*2, r, g, b, a) -- left
    renderer.rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a) -- right
  end,

  Clamp = function(KB_B,c,d)
    return math.min(d,math.max(c,KB_B))
  end,

  get_hotkey_index = function(refs)
    local to_return = {true, -1}
    for i = 1, #refs do
        if i == 1 and #refs > 1 then
            if not ui.get(refs[i]) then
                to_return[1] = false
            end
        end
        if #{ui.get(refs[i])} > to_return[2] then
            to_return[2] = i
        end
    end
    return to_return
  end,

  NL_Rect = function(x, y, w, h, r, g, b, a, radius)
    renderer.rectangle(x, y + radius, w, h - radius * 2, r, g, b, a) -- middle part
    renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a) -- top part
    renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, r, g, b, a) -- bottom part

    renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 270) -- top-left
    renderer.circle(x + w - radius, y + radius, r, g, b, a, radius, 270, 360) -- top-right
    renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, 90, 180) -- bottom-left
    renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 90) -- bottom-right
    
  end,

  NL_Rect_Outline = function(x, y, w, h, r, g, b, a, radius)

    local corner_radius = radius

    -- Draw the top part with rounded corners
    if corner_radius > 0 and radius > 0 then
    renderer.circle_outline(x + radius, y + radius, r, g, b, a, corner_radius, 180, 0.25, 1) -- top-left
    renderer.circle_outline(x + w - radius + 1, y + radius, r, g, b, a, corner_radius, 270, 0.25, 1) -- top-right
    else
      renderer.rectangle(x, y, 1, h, r, g, b, a)
    end
    renderer.rectangle(x + corner_radius, y, w - corner_radius * 2 + 1, 1, r, g, b, a) -- top

    
    -- Draw the bottom part with rounded corners
    if corner_radius > 0 and radius > 0 then
      renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, corner_radius, 90, 0.25, 1) -- bottom-left
      renderer.circle_outline(x + w - radius + 1, y + h - radius, r, g, b, a, corner_radius, 0, 0.25, 1) -- bottom-right
    else
      renderer.rectangle(x + w, y, 1, h, r, g, b, a)
    end
    renderer.rectangle(x + corner_radius, y + h - 1, w - corner_radius * 2 + 1, 1, r, g, b, a) -- bottom

  end,



  renderer_circle_3d_gradient = function(circle_vec, color1, color2, radius, start_degrees, percentage)
    local x, y = circle_vec[1], circle_vec[2]
    
    local r1, g1, b1, a1 = color1[1], color1[2], color1[3], color1[4]
    local r2, g2, b2, a2 = color2[1], color2[2], color2[3], color2[4]
    
    local angle_range = percentage * 360
    local num_segments = 36  -- Number of segments to approximate the circle
    
    local angle_step = angle_range / num_segments
    
    for angle = start_degrees, start_degrees + angle_range, angle_step do
        local progress = (angle - start_degrees) / angle_range
        local r = r1 + (r2 - r1) * progress
        local g = g1 + (g2 - g1) * progress
        local b = b1 + (b2 - b1) * progress
        local a = a1 + (a2 - a1) * progress
        
        local radian = math.rad(angle)
        local cos_angle = math.cos(radian)
        local sin_angle = math.sin(radian)
        
        local segment_x = x + radius * cos_angle
        local segment_y = y + radius * sin_angle
        
        renderer.circle(segment_x, segment_y, r, g, b, a, radius, angle, angle_step)
    end
  end



}

Custom_error = function(r, g, b, ST)
  client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, 'Voltaflame\0')
  client.color_log(r, g, b, string.format(ST))
end
Custom_Error_U = function(ST)
  Custom_error(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, ST)
  error()
end

local Create_Drag = (function()
  local a = {}
  local b, c, d, e, f, g, h, i, j, k, l, m, n, o, w, v
  local p = {
      __index = {
          drag = function(self, ...)
              local q, r = self:get()
              local s, t = a.drag(q, r, ...)
              if q ~= s or r ~= t then
                  self:set(s, t)
              end
              return s, t
          end,
          set = function(self, q, r)
              local j, k = client.screen_size()
              ui.set(self.x_reference, q / j * self.res)
              ui.set(self.y_reference, r / k * self.res)
          end,
          get = function(self)
              local j, k = client.screen_size()
              return ui.get(self.x_reference) / self.res * j, ui.get(self.y_reference) / self.res * k
          end
      }
  }

  function a.new(u, v, w, x)
      x = x or 10000
      local j, k = client.screen_size()
      local y = ui.new_slider('LUA', 'A', u .. ' window position', 0, x, v / j * x)
      local z = ui.new_slider('LUA', 'A', u .. ' window position y', 0, x, w / k * x)
      ui.set_visible(y, false)
      ui.set_visible(z, false)
      return setmetatable({ name = u, x_reference = y, y_reference = z, res = x }, p)
  end

  function a.new2(u, v, w, x)
    x = x or 10000
    local j, k = client.screen_size()
    local y = ui.new_slider('LUA', 'A', u .. ' window position 2', 0, x, v / j * x)
    local z = ui.new_slider('LUA', 'A', u .. ' window position 2 y', 0, x, w / k * x)
    ui.set_visible(y, false)
    ui.set_visible(z, false)
    return setmetatable({ name = u, x_reference = y, y_reference = z, res = x }, p)
  end

  function a.drag(q, r, A, B, C, D, E)
      if globals.framecount() ~= b then
          c = ui.is_menu_open()
          f, g = d, e
          d, e = ui.mouse_position()
          i = h
          h = client.key_state(0x01) == true
          m = l
          l = {}
          o = n
          n = false
          j, k = client.screen_size()
      end

      if c and i ~= nil then
          if (not i or o) and h and f > q and g > r and f < q + A and g < r + B then
              n = true
              q, r = q + d - f, r + e - g
              if not D then
                  q = math.max(0, math.min(j - A, q))
                  r = math.max(0, math.min(k - B, r))
              end
          end
      end

      table.insert(l, { q, r, A, B })
      return q, r, A, B
  end

  return a
end)()



--refs
FAKEDUCK = ui.reference("RAGE", "Other", "Duck peek assist")
MINHTC = ui.reference("RAGE", "Aimbot", "Minimum hit chance")
MINDMG = ui.reference("RAGE","Aimbot","Minimum damage")
MINDMGOVR = {ui.reference("RAGE","Aimbot","Minimum damage override")}
FORCESAFE = ui.reference("RAGE", "Aimbot", "Force safe point")
FORCEBODY = ui.reference("RAGE", "Aimbot", "Force body aim")
DOUBLETAPFAKELAGLIMIT = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit")
AUTOPEEK = {ui.reference("RAGE", "Other", "Quick peek assist")}
DOUBLETAP = {ui.reference("RAGE", "Aimbot", "Double tap")}




SLOWMOTION = {ui.reference("AA", "Other", "Slow motion")}
LEGMOVEMENT = ui.reference("AA", "Other", "Leg movement")
HIDESHOT = {ui.reference("AA", "Other", "On shot anti-aim")}
FAKEPEEK = ui.reference("AA", "Other", "Fake peek")

FAKELAGENABLE = ui.reference("AA", "Fake lag", "Enabled")
FAKELAGAMOUNT = ui.reference("AA", "Fake lag", "Amount")
FAKELAGVARIANCE = ui.reference("AA", "Fake lag", "Variance")
FAKELAGLIMIT = ui.reference("AA", "Fake lag", "Limit")

ENABLE = ui.reference("AA", "Anti-aimbot angles", "Enabled")
PITCH =  {ui.reference("AA", "Anti-aimbot angles", "pitch")}
YAWBASE = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
YAW = {ui.reference("AA", "Anti-aimbot angles", "Yaw")}
YAWJITTER = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")}
BODYYAW = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")}
BODYYAWFREESTAND = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")

FREESTANDING = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
EDGEYAW = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
EXTENDEDROLL = ui.reference("AA", "Anti-aimbot angles", "roll")

AMMO = ui.reference("VISUALS","Player ESP","Ammo")
WEAPONTEXT = ui.reference("VISUALS","Player ESP","Weapon text")
WEAPONICON = ui.reference("VISUALS","Player ESP","Weapon icon")

PINGSPIKE = {ui.reference("MISC","Miscellaneous","Ping spike")}
CLANTAGSPAMMER = ui.reference("MISC","Miscellaneous","Clan tag spammer")
NAMESTEAL = ui.reference("Misc", "Miscellaneous", "Steal player name")
PROCESSTICK = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks2")
MAXUNLAG = ui.reference("MISC", "Settings", "sv_maxunlag2")

MENUCOLOR = {ui.reference("MISC", "Settings", "Menu color")}
MENUKEY = ui.reference("MISC","Settings","Menu key")
DPISCALE = ui.reference("MISC","Settings","DPI scale")




MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B = ui.get(MENUCOLOR[1])
Hex_MENUCOLOR = entitys.RGBtoHEX(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B)


--intro
ui.new_label("AA", "Anti-aimbot angles", " ")
WelcomeToVoltalfame_Text = "Welcome To Voltaflame!"
Gradient_Start_Color_Volta = color.hex("0000FFFF")
Gradient_End_Color = color.hex("FF0000FF")

Main_Menu_Volta = ui.new_label("AA", "Anti-aimbot angles", WelcomeToVoltalfame_Text)

Start_Time_Volta = globals.curtime()
MainLabel = function()
    Current_Time_Volta = globals.curtime() - Start_Time_Volta
    Gradient_Ratio_Volta = (math.sin(Current_Time_Volta) + 1) / 2 -- Value between 0 and 1

    r = Gradient_Start_Color_Volta.r + (Gradient_End_Color.r - Gradient_Start_Color_Volta.r) * Gradient_Ratio_Volta
    g = Gradient_Start_Color_Volta.g + (Gradient_End_Color.g - Gradient_Start_Color_Volta.g) * Gradient_Ratio_Volta
    b = Gradient_Start_Color_Volta.b + (Gradient_End_Color.b - Gradient_Start_Color_Volta.b) * Gradient_Ratio_Volta
    a = Gradient_Start_Color_Volta.a + (Gradient_End_Color.a - Gradient_Start_Color_Volta.a) * Gradient_Ratio_Volta

    Current_Color_Volta = color(r, g, b, a)

    Gradient_Volta = ""
    labelLength = #WelcomeToVoltalfame_Text

    for i = 1, labelLength do
        Gradient_Volta = Gradient_Volta .. "\a" .. Current_Color_Volta:to_hex() .. WelcomeToVoltalfame_Text:sub(i, i)
    end

    Gradient_Volta = Gradient_Volta .. "\a" .. Current_Color_Volta:to_hex() .. " "  -- Add an extra space to create a horizontal effect
    ui.set(Main_Menu_Volta, Gradient_Volta)
end
ui.new_label("AA", "Anti-aimbot angles", " ")
CFGContainerName = ui.new_label("AA", "Anti-aimbot angles", "     Info/CFG")
RageContainerName = ui.new_label("AA", "Anti-aimbot angles", "     Ragebot")
AntiAimContainerName = ui.new_label("AA", "Anti-aimbot angles", "     Anti-Aim")
VisualContainerName = ui.new_label("AA", "Anti-aimbot angles", "     Visuals")
MiscContainerName = ui.new_label("AA", "Anti-aimbot angles", "     Miscellaneous")
MenucontainerName = ui.new_label("AA", "Anti-aimbot angles", "     Main Menu")
client.exec("clear")
client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255,"Loading The Script...")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255,"Loading The Script..")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255,"Loading The Script.")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255,"The Script Has Been loaded!")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255,"Hope You Will Enjoy Using Our Product!")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255,"Contact Us On Discord If You Are Having Any Issues!")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255," ")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255," ")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255,"discord.gg/voltaflame")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255," ")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255," ")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255,"Peace!")



--tabs/container
container = "empty"


CFGContainer = ui.new_button("AA", "Anti-aimbot angles", "Info/CFG",function()
  container = "CFGContainer"
end)
RageContainer = ui.new_button("AA", "Anti-aimbot angles", "Ragebot",function()
  container = "RageContainer"
end)
AntiAimContainer = ui.new_button("AA", "Anti-aimbot angles", "Anti-Aim",function()
  container = "AntiAimContainer"
end)
VisualContainer = ui.new_button("AA", "Anti-aimbot angles", "Visuals",function()
  container = "VisualContainer"
end)
MiscContainer = ui.new_button("AA", "Anti-aimbot angles", "Miscellaneous",function()
  container = "MiscContainer"
end)
BackContainer = ui.new_button("AA", "Anti-aimbot angles", "Back",function()
  container = "empty"
end)



client.set_event_callback("paint_ui", function()
  ui.set_visible(CFGContainer, container == "empty")
  ui.set_visible(CFGContainerName, container == "CFGContainer")
  ui.set_visible(RageContainer, container == "empty")
  ui.set_visible(RageContainerName, container == "RageContainer")
  ui.set_visible(AntiAimContainer, container == "empty")
  ui.set_visible(AntiAimContainerName, container == "AntiAimContainer")
  ui.set_visible(VisualContainer, container == "empty")
  ui.set_visible(VisualContainerName, container == "VisualContainer")
  ui.set_visible(MiscContainer, container == "empty")
  ui.set_visible(MiscContainerName, container == "MiscContainer")
  ui.set_visible(MenucontainerName, container == "empty")
  ui.set_visible(BackContainer, container == "CFGContainer" or container == "RageContainer" or container == "AntiAimContainer" or container == "VisualContainer" or container == "MiscContainer")

end)


--animation
Animation_Rainbow = ui.new_checkbox("AA", "Anti-aimbot angles", "Rainbow Colors")
Rainbow_Color_Selection = ui.new_multiselect("AA", "Anti-aimbot angles", "Rainbow Colors", {"Indicators", "Watermark", "Keybinds", "Hitlogs"})
Animation_Speed_Rainbow = ui.new_slider("AA", "Anti-aimbot angles", "Rainbow Speed", 0, 10, 1)
Animation_Speed_1 = ui.new_slider("AA", "Anti-aimbot angles", "[1] Animation Speed", 0, 10, 1)
Animation_Speed_2 = ui.new_slider("AA", "Anti-aimbot angles", "[2] Animation Speed", 0, 10, 1)
DragSelection = ui.new_combobox("AA", "Anti-aimbot angles", "Drag Selection", {"Keybinds", "MinDMG"})
emtpylabel = ui.new_label("AA", "Anti-aimbot angles", "    ")
Animation_System_Renderer = function()
  ui.set_visible(Animation_Rainbow, false)
  ui.set_visible(Animation_Speed_Rainbow, false)
  ui.set_visible(Rainbow_Color_Selection, false)
  ui.set_visible(Animation_Speed_1, container == "VisualContainer")
  ui.set_visible(Animation_Speed_2, container == "VisualContainer")
  ui.set_visible(emtpylabel, container == "VisualContainer")
  ui.set_visible(DragSelection, container == "VisualContainer" and (ui.get(Keybinds_VF) or ui.get(MinDmg_indicator)))
end

Start_Time = globals.curtime()

Animation_System = function()
  local currentTime = globals.curtime()
  local speedMalpha_Duration = ui.get(Animation_Speed_1) + 1.0
  local speedMalpha2_Duration = ui.get(Animation_Speed_2) + 0.5
  local progressMalpha = (currentTime * speedMalpha_Duration / 2) % 1
  local progressMalpha2 = (currentTime * speedMalpha2_Duration / 2) % 1


  Malpha = math.abs((progressMalpha * 2) % 2 - 1)
  alpha = 255 * Malpha


  Malpha2 = math.abs((progressMalpha2 * 2) % 2 - 1)
  alpha2 = 255 * Malpha2


end


--Rage options


Hitchance_Customization = ui.new_checkbox("AA", "Anti-aimbot angles", "Hitchance Customization")
NoScope_Customization_Weapons = ui.new_multiselect("AA", "Anti-aimbot angles", "[H] No-Scope Weapons:", {"SSG-08", "AWP", "Auto-Snipers"})
InAir_Customization_Weapons = ui.new_multiselect("AA", "Anti-aimbot angles", "[H] In-Air Weapons:", {"SSG-08", "AWP", "Auto-Snipers", "R8"})

Scout_NoScopeHitchance_Value = ui.new_slider("AA", "Anti-aimbot angles", "[SSG-08] No-Scope Hitchance Value", 0, 100, 50)
AWP_NoScopeHitchance_Value = ui.new_slider("AA", "Anti-aimbot angles", "[AWP] No-Scope Hitchance Value", 0, 100, 50)
Auto_NoScopeHitchance_Value = ui.new_slider("AA", "Anti-aimbot angles", "[Auto-Snipers] No-Scope Hitchance Value", 0, 100, 50)

Scout_InAirHitchance_Value = ui.new_slider("AA", "Anti-aimbot angles", "[SSG-08] In-Air Hitchance Value", 0, 100, 50)
AWP_InAirHitchance_Value = ui.new_slider("AA", "Anti-aimbot angles", "[AWP] In-Air Hitchance Value", 0, 100, 50)
Auto_InAirHitchance_Value = ui.new_slider("AA", "Anti-aimbot angles", "[Auto-Snipers] In-Air Hitchance Value", 0, 100, 50)
R8_InAirHitchance_Value = ui.new_slider("AA", "Anti-aimbot angles", "[R8] In-Air Hitchance Value", 0, 100, 50)




--tickcontrol
CustomTickControl = ui.new_checkbox("AA", "Anti-aimbot angles", "Custom DT Tick Control")
CustomTickControl_Value = ui.new_slider("AA", "Anti-aimbot angles", "Tick Value", 4, 25, 16)
--Resolver
VFR_Resolver_B = ui.new_checkbox("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."VoltaFlame Resolver")
RS_logs = ui.new_checkbox("AA", "Anti-aimbot angles", "Resolver Logs. (In Screen Hitlogs)")
Force_BY_Resolver = ui.new_checkbox("AA", "Anti-aimbot angles", "Force Resolve Body Yaw")
CorrectionActive_Resolver = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Correction Active")

Auto_TeleprtPlayer = ui.new_checkbox("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."Auto Teleport")
Auto_TeleprtPlayer_Weapon = ui.new_multiselect("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."Auto Teleport Weapons:", {"All Weapons", "SSG-08", "AWP", "Auto-Snipers", "Deagle", "R8", "Knife", "Taser"})
Auto_Teleprt_InAirOnly = ui.new_checkbox("AA", "Anti-aimbot angles", "In-Air Only")

Maual_Teleport = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual Exploit Discharge [BIND]")

--extended backtrack
Extendedbacktrack = ui.new_checkbox("AA", "Anti-aimbot angles", "Extended Backtrack")
--BreakLc Inair
BreakLagComp = ui.new_checkbox("AA", "Anti-aimbot angles", "BreakLC/Force Defensive In-Air")
BreakLagComp_Selection = ui.new_multiselect("AA", "Anti-aimbot angles", "BreakLC/Force Defensive On:", {"[S] Stand", "[M] Move", "[J] Jump", "[C] Crouch", "[C+A] Crouch+Air", "[SW] Slow Walk"})

--Animation Breaker
Anim_Breaker = ui.new_checkbox("AA", "Anti-aimbot angles", "Animation Breaker")
Anim_Breaker_Selection = ui.new_multiselect("AA", "Anti-aimbot angles", " ", { "Static Legs In Air", "Follow Direction", "Zero pitch on land", "Leg Freezer", "Michael Jackson OwO"})


--oTher aa Clantag_options
Lua_BetterFakeLag = ui.new_checkbox("AA", "Fake lag", "FakeLag Booster")
Lua_BetterFakeLagValue = ui.new_slider("AA", "Fake lag", "Boost", 1, 5, 0, true, '+', 1)
DisableFkOnSituauins = ui.new_checkbox("AA", "Fake lag",  "Disable Fakelag On Situations")
SituationsOfDisbaleFL = ui.new_multiselect("AA", "Fake lag", " ", "Doubletap", "Hideshot", "Standing", "Doubletap Knife", "Doubletap Deagle/R8", "Doubletap High Fire-Rate")
--roll
ExtendedRollAA = ui.new_checkbox("AA", "Fake lag", "Extended Roll AA")
ExtendedRollAAValue = ui.new_slider("AA", "Fake lag", "[ERA]", -45, 45, 0)




Lua_EdgeYaw = ui.new_hotkey("AA", "Other", "Edge Yaw")
Lua_Freestand = ui.new_hotkey("AA", "Other", "FreeStand")
CustomSlowWalk = ui.new_checkbox("AA", "Other","Custom Slow-Walk Speed")
CustomSlowWalk_Delay = ui.new_slider("AA", "Other"," Delay:", 1, 10, 0, 1)
CustomSlowWalk_Value_1 = ui.new_slider("AA", "Other","[1] Speed:", 1, 100, 0, 1)
CustomSlowWalk_Value_2 = ui.new_slider("AA", "Other","[2] Speed:", 1, 100, 0, 1)
CustomSlowWalk_Value_Real = ui.new_slider("AA", "Other","Speed:", 1, 100, 0, 1)
ManualYaw = ui.new_checkbox("AA", "Other","Manual Yaw")
ManualYawLeft = ui.new_hotkey("AA", "Other", "Manual Yaw [Left]")
ManualYawRight = ui.new_hotkey("AA", "Other", "Manual Yaw [Right]")
ManualYawLeanYaw = ui.new_checkbox("AA", "Other", "[Manual Yaw] Disable Body Yaw")

Anti_knife = ui.new_checkbox("AA", "Other", "Anti-BackStab")

StatisAAOnZeus = ui.new_checkbox("AA", "Other", "Static AA On Zeus/Knife")

DisableOnWarmup = ui.new_checkbox("AA", "Other", "Disable AA on Warmup")





RageSystemRenderer = function()
  ui.set_visible(Hitchance_Customization, container == "RageContainer")
  ui.set_visible(NoScope_Customization_Weapons, container == "RageContainer" and ui.get(Hitchance_Customization))
  ui.set_visible(InAir_Customization_Weapons, container == "RageContainer" and ui.get(Hitchance_Customization))
  ui.set_visible(Scout_InAirHitchance_Value, container == "RageContainer" and ui.get(Hitchance_Customization) and entitys.Contains(ui.get(InAir_Customization_Weapons), "SSG-08"))
  ui.set_visible(Scout_NoScopeHitchance_Value, container == "RageContainer" and ui.get(Hitchance_Customization) and entitys.Contains(ui.get(NoScope_Customization_Weapons), "SSG-08"))
  ui.set_visible(AWP_InAirHitchance_Value, container == "RageContainer" and ui.get(Hitchance_Customization) and entitys.Contains(ui.get(InAir_Customization_Weapons), "AWP"))
  ui.set_visible(AWP_NoScopeHitchance_Value, container == "RageContainer" and ui.get(Hitchance_Customization) and entitys.Contains(ui.get(NoScope_Customization_Weapons), "AWP"))
  ui.set_visible(Auto_InAirHitchance_Value, container == "RageContainer" and ui.get(Hitchance_Customization) and entitys.Contains(ui.get(InAir_Customization_Weapons), "Auto-Snipers"))
  ui.set_visible(Auto_NoScopeHitchance_Value, container == "RageContainer" and ui.get(Hitchance_Customization) and entitys.Contains(ui.get(NoScope_Customization_Weapons), "Auto-Snipers"))
  ui.set_visible(R8_InAirHitchance_Value, container == "RageContainer" and ui.get(Hitchance_Customization) and entitys.Contains(ui.get(InAir_Customization_Weapons), "R8"))
  ui.set_visible(VFR_Resolver_B, false) 
  ui.set_visible(RS_logs, false) 
  ui.set_visible(Force_BY_Resolver, false)
  ui.set_visible(CorrectionActive_Resolver, false)
  ui.set_visible(CustomTickControl, container == "RageContainer")
  ui.set_visible(CustomTickControl_Value, container == "RageContainer" and ui.get(CustomTickControl))
  ui.set_visible(Auto_TeleprtPlayer, container == "RageContainer")
  ui.set_visible(Auto_TeleprtPlayer_Weapon, container == "RageContainer" and ui.get(Auto_TeleprtPlayer))
  ui.set_visible(Auto_Teleprt_InAirOnly, container == "RageContainer" and ui.get(Auto_TeleprtPlayer))
  ui.set_visible(Maual_Teleport, container == "RageContainer")
  ui.set_visible(BreakLagComp, container == "RageContainer")
  ui.set_visible(BreakLagComp_Selection, container == "RageContainer" and ui.get(BreakLagComp))
  ui.set_visible(Anim_Breaker, container == "RageContainer")
  ui.set_visible(Anim_Breaker_Selection, container == "RageContainer" and ui.get(Anim_Breaker))
  ui.set_visible(Extendedbacktrack, false)
end

OtherAASystemRenderer = function()
  ui.set_visible(Lua_Freestand, container == "AntiAimContainer")
  ui.set_visible(Lua_EdgeYaw, container == "AntiAimContainer")
  ui.set_visible(SLOWMOTION[1], container == "AntiAimContainer")
  ui.set_visible(SLOWMOTION[2], container == "AntiAimContainer")
  ui.set_visible(HIDESHOT[1], container == "AntiAimContainer")
  ui.set_visible(HIDESHOT[2], container == "AntiAimContainer")
  ui.set_visible(FAKEPEEK, container == "AntiAimContainer")
  ui.set_visible(FAKELAGENABLE, container == "AntiAimContainer")
  ui.set_visible(Lua_BetterFakeLag, container == "AntiAimContainer" and ui.get(FAKELAGENABLE))
  ui.set_visible(Lua_BetterFakeLagValue, container == "AntiAimContainer" and ui.get(Lua_BetterFakeLag) and ui.get(FAKELAGENABLE))
  ui.set_visible(FAKELAGAMOUNT, container == "AntiAimContainer" and ui.get(FAKELAGENABLE))
  ui.set_visible(FAKELAGVARIANCE, container == "AntiAimContainer" and ui.get(FAKELAGENABLE))
  ui.set_visible(FAKELAGLIMIT, container == "AntiAimContainer" and ui.get(FAKELAGENABLE))
  ui.set_visible(DisableFkOnSituauins, container == "AntiAimContainer")
  ui.set_visible(SituationsOfDisbaleFL, container == "AntiAimContainer" and ui.get(DisableFkOnSituauins))
  ui.set_visible(CustomSlowWalk, container == "AntiAimContainer")
  ui.set_visible(CustomSlowWalk_Delay, false)
  ui.set_visible(CustomSlowWalk_Value_1, false)
  ui.set_visible(CustomSlowWalk_Value_2, container == "AntiAimContainer" and ui.get(CustomSlowWalk))
  ui.set_visible(CustomSlowWalk_Value_Real, false) 
  ui.set_visible(ManualYaw, container == "AntiAimContainer")
  ui.set_visible(ManualYawLeft, container == "AntiAimContainer" and ui.get(ManualYaw))
  ui.set_visible(ManualYawRight, container == "AntiAimContainer" and ui.get(ManualYaw))
  ui.set_visible(ManualYawLeanYaw, container == "AntiAimContainer" and ui.get(ManualYaw))
  ui.set_visible(Anti_knife, container == "AntiAimContainer")
  ui.set_visible(DisableOnWarmup, container == "AntiAimContainer")
  ui.set_visible(StatisAAOnZeus, false)
  ui.set_visible(ExtendedRollAA, container == "AntiAimContainer")
  ui.set_visible(ExtendedRollAAValue, container == "AntiAimContainer"and ui.get(ExtendedRollAA))
end





RageSystem = function(e)
  
  lp = entity.get_local_player()

  Get_Players_Entity = entity.get_players(true)
  Autoteleport = false
  weapon = entity.get_player_weapon(lp)
  weaponclass = entity.get_classname(weapon)
  AutoClass = weaponclass == "CWeaponSCAR20" or weaponclass == "CWeaponG3SG1"
  ScoutClass = weaponclass == "CWeaponSSG08"
  AwpClass = weaponclass == "CWeaponAWP"
  DeagleClass = weaponclass == "CWeaponDesertEagle" 
  R8Class = weaponclass == "CWeaponRevolver"
  KnifeClass = weaponclass == "CKnife"
  TaserClass = weaponclass == "CWeaponTaser"
  scoped = entity.get_prop(lp, "m_bIsScoped") == 1 and true or false



  --auto teleport  




    if ui.get(Auto_TeleprtPlayer) then
      for i = 1, #Get_Players_Entity do
        Get_Players_Entity_Index = Get_Players_Entity[i]
        Get_Players_Entity_Index_X, Get_Players_Entity_Index_Y, Get_Players_Entity_Index_Z = entity.hitbox_position(Get_Players_Entity_Index, 1)
        if client.visible(Get_Players_Entity_Index_X, Get_Players_Entity_Index_Y, Get_Players_Entity_Index_Z + 20) then
          if Auto_Teleprt_InAirOnly and bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 0 then
            Autoteleport = true
          end
          if not ui.get(Auto_Teleprt_InAirOnly) then
            Autoteleport = true
          end
        end
      end

      if Autoteleport then
        if entitys.Contains(ui.get(Auto_TeleprtPlayer_Weapon), "SSG-08") and ScoutClass then
          ui.set(DOUBLETAP[1], false)
        elseif entitys.Contains(ui.get(Auto_TeleprtPlayer_Weapon), "AWP") and AwpClass then
          ui.set(DOUBLETAP[1], false)
        elseif entitys.Contains(ui.get(Auto_TeleprtPlayer_Weapon), "Auto-Snipers") and AutoClass then
          ui.set(DOUBLETAP[1], false)
        elseif entitys.Contains(ui.get(Auto_TeleprtPlayer_Weapon), "Deagle") and DeagleClass then
          ui.set(DOUBLETAP[1], false)
        elseif entitys.Contains(ui.get(Auto_TeleprtPlayer_Weapon), "R8") and R8Class then
          ui.set(DOUBLETAP[1], false)
        elseif entitys.Contains(ui.get(Auto_TeleprtPlayer_Weapon), "Knife") and KnifeClass then
          ui.set(DOUBLETAP[1], false)
        elseif entitys.Contains(ui.get(Auto_TeleprtPlayer_Weapon), "Taser") and TaserClass then
            ui.set(DOUBLETAP[1], false)
        elseif entitys.Contains(ui.get(Auto_TeleprtPlayer_Weapon), "All Weapons")then
            ui.set(DOUBLETAP[1], false)
        else
          ui.set(DOUBLETAP[1], false)
        end
      end
    end
      
    if ui.get(Maual_Teleport) then
      ui.set(DOUBLETAP[1], false)
    else
      if not Autoteleport then
        ui.set(DOUBLETAP[1], true)
      end
    end

  
  
    if ui.get(DisableFkOnSituauins) then
      if entitys.Contains(ui.get(SituationsOfDisbaleFL), "Doubletap") and AntiAimFunctionsLib.get_double_tap() then
        if not ui.is_menu_open() then
          ui.set(FAKELAGENABLE, false)
        end
      elseif entitys.Contains(ui.get(SituationsOfDisbaleFL), "Hideshot") and (ui.get(HIDESHOT[1]) and ui.get(HIDESHOT[2])) then
        if not ui.is_menu_open() then
          ui.set(FAKELAGENABLE, false)
        end
      elseif entitys.Contains(ui.get(SituationsOfDisbaleFL), "Doubletap Knife") and AntiAimFunctionsLib.get_double_tap() and KnifeClass then
        if not ui.is_menu_open() then
          ui.set(FAKELAGENABLE, false)
        end
      elseif entitys.Contains(ui.get(SituationsOfDisbaleFL), "Standing") and State_Standing then
        if not ui.is_menu_open() then
          ui.set(FAKELAGENABLE, false)
        end
      elseif entitys.Contains(ui.get(SituationsOfDisbaleFL), "Doubletap Deagle/R8") and R8Class and DeagleClass then
        if not ui.is_menu_open() then
          ui.set(FAKELAGENABLE, false)
        end
      elseif entitys.Contains(ui.get(SituationsOfDisbaleFL), "Doubletap High Fire-Rate") and not R8Class and not DeagleClass and not AwpClass and not ScoutClass then
        if not ui.is_menu_open() then
          ui.set(FAKELAGENABLE, false)
        end
      else
        ui.set(FAKELAGENABLE, true)
      end
    end
  



end

ground_ticks, end_time = 0, 0
AnimSystem = function()
  lp = entity.get_local_player()
  if not entity.is_alive(lp) then
    return
  end
  if ui.get(Anim_Breaker) then

    if entitys.Contains(ui.get(Anim_Breaker_Selection), "Follow Direction") then
      math_randomized = math.random(1,2)
      ui.set(LEGMOVEMENT, math_randomized == 1 and "Always slide" or "Never slide")
      entity.set_prop(lp, "m_flPoseParameter", 8, 0)
    end

    if entitys.Contains(ui.get(Anim_Breaker_Selection), "Leg Freezer") then
      entity.set_prop(lp, "m_flPoseParameter", 1, 6) 
    end

    if entitys.Contains(ui.get(Anim_Breaker_Selection), "Zero pitch on land") then
      if bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1 then
          ground_ticks = ground_ticks + 1
      else
          ground_ticks = 0
          end_time = globals.curtime() + 1
      end

      if  ground_ticks > 5 and end_time + 0.5 > globals.curtime() then
          entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
      end
    end

    if entitys.Contains(ui.get(Anim_Breaker_Selection), "Static Legs In Air") and bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 0 then
      entity.set_prop(lp, "m_flPoseParameter", 1, 6) 
    end

    if entitys.Contains(ui.get(Anim_Breaker_Selection), "Michael Jackson OwO") then
			ui.set(LEGMOVEMENT, "Never slide")
			entity.set_prop(localplayer, "m_flPoseParameter", 1, 7)
			if not bit.band(EntityLib.get_local_player():get_prop("m_fFlags"), 1) ~= 0 then
				EntityLib.get_local_player():get_anim_overlay(6).weight = 1
				entity.set_prop(EntityLib.get_local_player(), "m_flPoseParameter", 1, 6)
			end
		end
  end
end


OtherAASystem = function()
  KnifeClass = weaponclass == "CKnife"
  TaserClass = weaponclass == "CWeaponTaser"

  if ui.get(CustomTickControl) and ((ui.get(DOUBLETAP[1]) and ui.get(DOUBLETAP[2])) or AntiAimFunctionsLib.get_double_tap()) then
    ui.set(PROCESSTICK, ui.get(CustomTickControl_Value))
  elseif ui.get(Lua_BetterFakeLag) and not ((ui.get(DOUBLETAP[1]) and ui.get(DOUBLETAP[2])) or AntiAimFunctionsLib.get_double_tap()) then
    ui.set(PROCESSTICK, 16+ui.get(Lua_BetterFakeLagValue))
    ui.set(FAKELAGLIMIT, 15+ui.get(Lua_BetterFakeLagValue))
  else
    ui.set(PROCESSTICK,16)
  end


  if ui.get(Anti_knife) then
    APlayers = entity.get_players(true)
    LPOrigin_X, LPOrigin_Y, LPOrigin_Z = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
    for i = 1, #APlayers do
        Origin_X, Origin_Y, Origin_Z = entity.get_prop(APlayers[i], "m_vecOrigin")
        weapon = entity.get_player_weapon(APlayers[i])
        if entity.get_classname(weapon) == "CKnife" and entitys.DistanceCal(LPOrigin_X, LPOrigin_Y, LPOrigin_Z, Origin_X, Origin_Y, Origin_Z) <= 500 then
            ui.set(PITCH[1], "Off")
            ui.set(YAW[1], 180)
            ui.set(YAW[2], 180)
            ui.set(YAWBASE, "At targets")
        end
    end
  end

  if ui.get(Lua_EdgeYaw) then
    ui.set(EDGEYAW, true)
  else
    ui.set(EDGEYAW, false)
  end

  if ui.get(Lua_Freestand) then
    ui.set(FREESTANDING, true)
  else
    ui.set(FREESTANDING, false)
  end

  if ui.get(ExtendedRollAA) then
    ui.set(EXTENDEDROLL, ui.get(ExtendedRollAAValue))
  end

  if ui.get(ManualYaw) then
    if ui.get(ManualYawLeft) and ui.get(ManualYawLeanYaw) then
      ui.set(YAWBASE, "Local View")
      ui.set(YAW[1], "180")
      ui.set(YAW[2], "-90")
      ui.set(YAWJITTER[1], "Off")
      ui.set(BODYYAW[1], "Off")
    elseif ui.get(ManualYawLeft) then
        ui.set(YAWBASE, "Local View")
        ui.set(YAW[1], "180")
        ui.set(YAW[2], "-90")
    end
  

    if ui.get(ManualYawRight) and ui.get(ManualYawLeanYaw) then
      ui.set(YAWBASE, "Local View")
      ui.set(YAW[1], "180")
      ui.set(YAW[2], "90")
      ui.set(YAWJITTER[1], "Off")
      ui.set(BODYYAW[1], "Off")
    elseif ui.get(ManualYawRight) then
        ui.set(YAWBASE, "Local View")
        ui.set(YAW[1], "180")
        ui.set(YAW[2], "90")
    end
  end
  


end  

warmup = nil
onWarmupStart = function()
  warmup = true
end

onWarmupEnd = function()
  warmup = false
end

client.set_event_callback("round_start", function(e)
  if e.round_phase == 1 then
      onWarmupStart()
  elseif e.round_phase == 2 then
      onWarmupEnd()
  end
end)

SlowWalk_loop = 1
client.set_event_callback("setup_command", function(e)
  CustomSlowWalk_Values = {ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_1), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2), ui.get(CustomSlowWalk_Value_2)}
  ui.set(CustomSlowWalk_Value_Real, CustomSlowWalk_Values[SlowWalk_loop])
  SlowWalk_loop = SlowWalk_loop + 1
  if SlowWalk_loop > ui.get(CustomSlowWalk_Delay)*10 then
    SlowWalk_loop = 1 
  end

  if ui.get(CustomSlowWalk) and ui.get(SLOWMOTION[2]) then
    if e.forwardmove >= ui.get(CustomSlowWalk_Value_Real) then
        e.forwardmove = ui.get(CustomSlowWalk_Value_Real)
    end 
    if e.sidemove >= ui.get(CustomSlowWalk_Value_Real) then
      e.sidemove = ui.get(CustomSlowWalk_Value_Real)
    end 
    if e.forwardmove < 0 and -e.forwardmove >=ui.get(CustomSlowWalk_Value_Real) then
      e.forwardmove = -ui.get(CustomSlowWalk_Value_Real)
    end
    if e.sidemove < 0 and -e.sidemove >=ui.get(CustomSlowWalk_Value_Real) then
      e.sidemove = -ui.get(CustomSlowWalk_Value_Real)
    end
  end
end)

client.set_event_callback("setup_command", function(e)


  if ui.get(BreakLagComp) then
    if entitys.Contains(ui.get(BreakLagComp_Selection), "[S] Stand") and State_Standing then
      e.force_defensive = 1
    elseif entitys.Contains(ui.get(BreakLagComp_Selection), "[M] Move") and State_Moving then
      e.force_defensive = 1
    elseif  entitys.Contains(ui.get(BreakLagComp_Selection), "[J] Jump") and State_Jumping then
      e.force_defensive = 1
    elseif  entitys.Contains(ui.get(BreakLagComp_Selection), "[C] Crouch") and State_Crouch then 
      e.force_defensive = 1
    elseif  entitys.Contains(ui.get(BreakLagComp_Selection), "[SW] Slow Walk") and State_SlowWalk then
      e.force_defensive = 1
    elseif  entitys.Contains(ui.get(BreakLagComp_Selection), "[C+A] Crouch+Air") and State_CrouchAir then
      e.force_defensive = 1
    end
  end

  --inair hitchance
  if ui.get(Hitchance_Customization) then
    if entitys.Contains(ui.get(NoScope_Customization_Weapons), "SSG-08") then
      if ScoutClass then
        if not scoped then
          ui_.override(MINHTC, ui.get(Scout_NoScopeHitchance_Value))
        end
      end
    end

    if entitys.Contains(ui.get(InAir_Customization_Weapons), "SSG-08") then
      if ScoutClass  then
        if e.in_jump == 1 then
          ui_.override(MINHTC, ui.get(Scout_InAirHitchance_Value))
        end
      end
    end

    if entitys.Contains(ui.get(NoScope_Customization_Weapons), "AWP") then
      if AwpClass then
        if not scoped then
          ui_.override(MINHTC, ui.get(AWP_NoScopeHitchance_Value))
        end
      end
    end

    if entitys.Contains(ui.get(InAir_Customization_Weapons), "AWP") then
      if AwpClass  then
        if e.in_jump == 1 then
          ui_.override(MINHTC, ui.get(AWP_InAirHitchance_Value))
        end
      end
    end

    if entitys.Contains(ui.get(NoScope_Customization_Weapons), "Auto-Snipers") then
       if AutoClass then
         if not scoped then
            ui_.override(MINHTC, ui.get(Auto_NoScopeHitchance_Value))
         end
        end
    end

    if entitys.Contains(ui.get(InAir_Customization_Weapons), "Auto-Snipers")  then 
      if AutoClass  then 
        if e.in_jump == 1 then
          ui_.override(MINHTC, ui.get(Auto_InAirHitchance_Value))
        end
      end
    end

    if entitys.Contains(ui.get(InAir_Customization_Weapons), "R8")  then
      if R8Class  then
        if e.in_jump == 1 then
          ui_.override(MINHTC, ui.get(Auto_InAirHitchance_Value))
        end
      end
    end
  end
end)

--antiaim
AAmode = ui.new_combobox("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."Anti-Aim Modes:", {"None", "Defensive", "Aggressive", "Dynamic", "Custom"})


--Custom AA
SelectionTabForCustom = ui.new_combobox("AA", "Anti-aimbot angles", "Condition Tab:", {"[S] Stand", "[M] Move", "[J] Jump", "[C] Crouch", "[C+A] Crouch+Air", "[SW] Slow Walk"})


S_Override = ui.new_checkbox("AA", "Anti-aimbot angles", "Override These Settings:")
S_Pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[S] Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom", "Defensive"})
S_DefensiveAA_Pitch = ui.new_slider("AA", "Anti-aimbot angles", "[S][D] Defensive AA Pitch", -89, 89, 0)
S_PitchLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[S][L] Pitch Value:", -89, 89, 0)
S_PitchRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[S][R] Pitch Value:", -89, 89, 0)
S_YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "[S] Yaw Base", {"At Targets", "Local View"})
S_Yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[S] Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "Defensive"})
S_DefensiveAA_Yaw = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[S][D] Defensive AA Yaw", -180, 180, 0)
S_SwitchDelay = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[S] Yaw Switch Delay:", 1, 10, 5)
S_YawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[S][L] Yaw Value:", -180, 180, 0)
S_YawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[S][R] Yaw Value:", -180, 180, 0)
S_YawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "[S] Yaw Jitter", {"Off", "Offset", "Center", "Random", "Skitter"})
S_YawJitterDelaySlider = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[S] Yaw Jitter Delay:", 1, 10, 5)
S_YawJitterLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[S][L] Yaw Jitter Value:", -89, 89, 0)
S_YawJitterRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[S][R] Yaw Jitter Value:", -89, 89, 0)
S_BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "[S] Body Yaw", {"Off", "Opposite", "Jitter", "Anti-Bruteforce"})
S_BodyYawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[S][L] Body Yaw Value:", -180, 180, 0)
S_BodyYawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[S][R] Body Yaw Value:", -180, 180, 0)
S_BodyYawFreestanding = ui.new_checkbox("AA", "Anti-aimbot angles", "[S] Body Yaw Freestanding")



M_Override = ui.new_checkbox("AA", "Anti-aimbot angles", "Override These Settings:")
M_Pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[M] Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom", "Defensive"})
M_DefensiveAA_Pitch = ui.new_slider("AA", "Anti-aimbot angles", "[M][D] Defensive AA Pitch", -89, 89, 0)
M_PitchLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[M][L] Pitch Value:", -89, 89, 0)
M_PitchRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[M][R] Pitch Value:", -89, 89, 0)
M_YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "[M] Yaw Base", {"At Targets", "Local View"})
M_Yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[M] Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "Defensive"})
M_DefensiveAA_Yaw = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[M][D] Defensive AA Yaw", -180, 180, 0)
M_SwitchDelay = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[M] Yaw Switch Delay:", 1, 10, 5)
M_YawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[M][L] Yaw Value:", -180, 180, 0)
M_YawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[M][R] Yaw Value:", -180, 180, 0)
M_YawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "[M] Yaw Jitter", {"Off", "Offset", "Center", "Random", "Skitter"})
M_YawJitterDelaySlider = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[M] Yaw Jitter Delay:", 1, 10, 5)
M_YawJitterLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[M][L] Yaw Jitter Value:", -89, 89, 0)
M_YawJitterRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[M][R] Yaw Jitter Value:", -89, 89, 0)
M_BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "[M] Body Yaw", {"Off", "Opposite", "Jitter", "Anti-Bruteforce"})
M_BodyYawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[M][L] Body Yaw Value:", -180, 180, 0)
M_BodyYawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[M][R] Body Yaw Value:", -180, 180, 0)
M_BodyYawFreestanding = ui.new_checkbox("AA", "Anti-aimbot angles", "[M] Body Yaw Freestanding")





J_Override = ui.new_checkbox("AA", "Anti-aimbot angles", "Override These Settings:")
J_Pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[J] Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom", "Defensive"})
J_DefensiveAA_Pitch = ui.new_slider("AA", "Anti-aimbot angles", "[J][D] Defensive AA Pitch", -89, 89, 0)
J_PitchLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[J][L] Pitch Value:", -89, 89, 0)
J_PitchRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[J][R] Pitch Value:", -89, 89, 0)
J_YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "[J] Yaw Base", {"At Targets", "Local View"})
J_Yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[J] Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "Defensive"})
J_DefensiveAA_Yaw = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[J][D] Defensive AA Yaw", -180, 180, 0)
J_SwitchDelay = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[J] Yaw Switch Delay:", 1, 10, 5)
J_YawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[J][L] Yaw Value:", -180, 180, 0)
J_YawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[J][R] Yaw Value:", -180, 180, 0)
J_YawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "[J] Yaw Jitter", {"Off", "Offset", "Center", "Random", "Skitter"})
J_YawJitterDelaySlider = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[J] Yaw Jitter Delay:", 1, 10, 5)
J_YawJitterLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[J][L] Yaw Jitter Value:", -89, 89, 0)
J_YawJitterRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[J][R] Yaw Jitter Value:", -89, 89, 0)
J_BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "[J] Body Yaw", {"Off", "Opposite", "Jitter", "Anti-Bruteforce"})
J_BodyYawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[J][L] Body Yaw Value:", -180, 180, 0)
J_BodyYawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[J][R] Body Yaw Value:", -180, 180, 0)
J_BodyYawFreestanding = ui.new_checkbox("AA", "Anti-aimbot angles", "[J] Body Yaw Freestanding")





C_Override = ui.new_checkbox("AA", "Anti-aimbot angles", "Override These Settings:")
C_Pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[C] Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom", "Defensive"})
C_DefensiveAA_Pitch = ui.new_slider("AA", "Anti-aimbot angles", "[C][D] Defensive AA Pitch", -89, 89, 0)
C_PitchLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C][L] Pitch Value:", -89, 89, 0)
C_PitchRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C][R] Pitch Value:", -89, 89, 0)
C_YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "[C] Yaw Base", {"At Targets", "Local View"})
C_Yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[C] Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "Defensive"})
C_DefensiveAA_Yaw = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[C][D] Defensive AA Yaw", -180, 180, 0)
C_SwitchDelay = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[C] Yaw Switch Delay:", 1, 10, 5)
C_YawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C][L] Yaw Value:", -180, 180, 0)
C_YawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C][R] Yaw Value:", -180, 180, 0)
C_YawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "[C] Yaw Jitter", {"Off", "Offset", "Center", "Random", "Skitter"})
C_YawJitterDelaySlider = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[C] Yaw Jitter Delay:", 1, 10, 5)
C_YawJitterLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C][L] Yaw Jitter Value:", -89, 89, 0)
C_YawJitterRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C][R] Yaw Jitter Value:", -89, 89, 0)
C_BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "[C] Body Yaw", {"Off", "Opposite", "Jitter", "Anti-Bruteforce"})
C_BodyYawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C][L] Body Yaw Value:", -180, 180, 0)
C_BodyYawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C][R] Body Yaw Value:", -180, 180, 0)
C_BodyYawFreestanding = ui.new_checkbox("AA", "Anti-aimbot angles", "[C] Body Yaw Freestanding")






CA_Override = ui.new_checkbox("AA", "Anti-aimbot angles", "Override These Settings:")
CA_Pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[C+A] Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom", "Defensive"})
CA_DefensiveAA_Pitch = ui.new_slider("AA", "Anti-aimbot angles", "[C+A][D] Defensive AA Pitch", -89, 89, 0)
CA_PitchLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C+A][L] Pitch Value:", -89, 89, 0)
CA_PitchRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C+A][R] Pitch Value:", -89, 89, 0)
CA_YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "[C+A] Yaw Base", {"At Targets", "Local View"})
CA_Yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[C+A] Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "Defensive"})
CA_DefensiveAA_Yaw = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[C+A][D] Defensive AA Yaw", -180, 180, 0)
CA_SwitchDelay = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[C+A] Yaw Switch Delay:", 1, 10, 5)
CA_YawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C+A][L] Yaw Value:", -180, 180, 0)
CA_YawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C+A][R] Yaw Value:", -180, 180, 0)
CA_YawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "[C+A] Yaw Jitter", {"Off", "Offset", "Center", "Random", "Skitter"})
CA_YawJitterDelaySlider = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[C+A] Yaw Jitter Delay:", 1, 10, 5)
CA_YawJitterLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C+A][L] Yaw Jitter Value:", -89, 89, 0)
CA_YawJitterRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C+A][R] Yaw Jitter Value:", -89, 89, 0)
CA_BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "[C+A] Body Yaw", {"Off", "Opposite", "Jitter", "Anti-Bruteforce"})
CA_BodyYawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C+A][L] Body Yaw Value:", -180, 180, 0)
CA_BodyYawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[C+A][R] Body Yaw Value:", -180, 180, 0)
CA_BodyYawFreestanding = ui.new_checkbox("AA", "Anti-aimbot angles", "[C+A] Body Yaw Freestanding")




SW_Override = ui.new_checkbox("AA", "Anti-aimbot angles", "Override These Settings:")
SW_Pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[SW] Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom", "Defensive"})
SW_DefensiveAA_Pitch = ui.new_slider("AA", "Anti-aimbot angles", "[SW][D] Defensive AA Pitch", -89, 89, 0)
SW_PitchLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[SW][L] Pitch Value:", -89, 89, 0)
SW_PitchRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[SW][R] Pitch Value:", -89, 89, 0)
SW_YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "[SW] Yaw Base", {"At Targets", "Local View"})
SW_Yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[SW] Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "Defensive"})
SW_DefensiveAA_Yaw = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[SW][D] Defensive AA Yaw", -180, 180, 0)
SW_SwitchDelay = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[SW] Yaw Switch Delay:", 1, 10, 5)
SW_YawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[SW][L] Yaw Value:", -180, 180, 0)
SW_YawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[SW][R] Yaw Value:", -180, 180, 0)
SW_YawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "[SW] Yaw Jitter", {"Off", "Offset", "Center", "Random", "Skitter"})
SW_YawJitterDelaySlider = ui.new_slider("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."[CA] Yaw Jitter Delay:", 1, 10, 5)
SW_YawJitterLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[SW][L] Yaw Jitter Value:", -89, 89, 0)
SW_YawJitterRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[SW][R] Yaw Jitter Value:", -89, 89, 0)
SW_BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "[SW] Body Yaw", {"Off", "Opposite", "Jitter", "Anti-Bruteforce"})
SW_BodyYawLeftSlider = ui.new_slider("AA", "Anti-aimbot angles", "[SW][L] Body Yaw Value:", -180, 180, 0)
SW_BodyYawRightSlider = ui.new_slider("AA", "Anti-aimbot angles", "[SW][R] Body Yaw Value:", -180, 180, 0)
SW_BodyYawFreestanding = ui.new_checkbox("AA", "Anti-aimbot angles", "[SW] Body Yaw Freestanding")








AATabsRenderer = function()
  ui.set_visible(AAmode, container == "AntiAimContainer")
  ui.set_visible(SelectionTabForCustom, container == "AntiAimContainer" and ui.get(AAmode) == "Custom")


  ui.set_visible(S_Override, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand")
  ui.set_visible(S_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override))
  ui.set_visible(S_DefensiveAA_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override) and ui.get(S_Pitch) == "Defensive")
  ui.set_visible(S_PitchLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override) and (ui.get(S_Pitch) == "Custom" or ui.get(S_Pitch) == "Defensive"))
  ui.set_visible(S_PitchRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override) and (ui.get(S_Pitch) == "Custom" or ui.get(S_Pitch) == "Defensive"))
  ui.set_visible(S_YawBase, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override))
  ui.set_visible(S_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override))
  ui.set_visible(S_DefensiveAA_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override) and ui.get(S_Yaw) == "Defensive")
  ui.set_visible(S_SwitchDelay, false) 
  ui.set_visible(S_YawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override) and (ui.get(S_Yaw) == "Defensive" or ui.get(S_Yaw) == "180" or ui.get(S_Yaw) == "Spin" or ui.get(S_Yaw) == "Static" or ui.get(S_Yaw) == "180 Z" or ui.get(S_Yaw) == "Crosshair"))
  ui.set_visible(S_YawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override) and (ui.get(S_Yaw) == "Defensive" or ui.get(S_Yaw) == "180" or ui.get(S_Yaw) == "Spin" or ui.get(S_Yaw) == "Static" or ui.get(S_Yaw) == "180 Z" or ui.get(S_Yaw) == "Crosshair"))
  ui.set_visible(S_YawJitter, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override) and (ui.get(S_Yaw) == "Defensive" or ui.get(S_Yaw) == "180" or ui.get(S_Yaw) == "Spin" or ui.get(S_Yaw) == "Static" or ui.get(S_Yaw) == "180 Z" or ui.get(S_Yaw) == "Crosshair"))
  ui.set_visible(S_YawJitterLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override) and (ui.get(S_Yaw) == "Defensive" or ui.get(S_Yaw) == "180" or ui.get(S_Yaw) == "Spin" or ui.get(S_Yaw) == "Static" or ui.get(S_Yaw) == "180 Z" or ui.get(S_Yaw) == "Crosshair") and (ui.get(S_YawJitter) == "Offset" or ui.get(S_YawJitter) == "Center" or ui.get(S_YawJitter) == "Random" or ui.get(S_YawJitter) == "Skitter"))
  ui.set_visible(S_YawJitterRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and (ui.get(S_Yaw) == "Defensive" or ui.get(S_Yaw) == "180" or ui.get(S_Yaw) == "Spin" or ui.get(S_Yaw) == "Static" or ui.get(S_Yaw) == "180 Z" or ui.get(S_Yaw) == "Crosshair") and ui.get(S_Override) and (ui.get(S_YawJitter) == "Offset" or ui.get(S_YawJitter) == "Center" or ui.get(S_YawJitter) == "Random" or ui.get(S_YawJitter) == "Skitter"))
  ui.set_visible(S_YawJitterDelaySlider, false) 
  ui.set_visible(S_BodyYaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override))
  ui.set_visible(S_BodyYawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override) and (ui.get(S_BodyYaw) == "Opposite" or ui.get(S_BodyYaw) == "Jitter" or ui.get(S_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(S_BodyYawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override) and (ui.get(S_BodyYaw) == "Opposite" or ui.get(S_BodyYaw) == "Jitter" or ui.get(S_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(S_BodyYawFreestanding, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[S] Stand" and ui.get(S_Override) and (ui.get(S_BodyYaw) == "Opposite" or ui.get(S_BodyYaw) == "Jitter" or ui.get(S_BodyYaw) == "Anti-Bruteforce"))


  



  ui.set_visible(M_Override, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move")
  ui.set_visible(M_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override))
  ui.set_visible(M_DefensiveAA_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override) and ui.get(M_Pitch) == "Defensive")
  ui.set_visible(M_PitchLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override) and (ui.get(M_Pitch) == "Custom" or ui.get(M_Pitch) == "Defensive"))
  ui.set_visible(M_PitchRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override) and (ui.get(M_Pitch) == "Custom" or ui.get(M_Pitch) == "Defensive"))
  ui.set_visible(M_YawBase, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override))
  ui.set_visible(M_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override))
  ui.set_visible(M_DefensiveAA_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override) and ui.get(M_Yaw) == "Defensive")
  ui.set_visible(M_SwitchDelay, false) 
  ui.set_visible(M_YawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override) and (ui.get(M_Yaw) == "Defensive" or ui.get(M_Yaw) == "180" or ui.get(M_Yaw) == "Spin" or ui.get(M_Yaw) == "Static" or ui.get(M_Yaw) == "180 Z" or ui.get(M_Yaw) == "Crosshair"))
  ui.set_visible(M_YawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override) and (ui.get(M_Yaw) == "Defensive" or ui.get(M_Yaw) == "180" or ui.get(M_Yaw) == "Spin" or ui.get(M_Yaw) == "Static" or ui.get(M_Yaw) == "180 Z" or ui.get(M_Yaw) == "Crosshair"))
  ui.set_visible(M_YawJitter, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override) and (ui.get(M_Yaw) == "Defensive" or ui.get(M_Yaw) == "180" or ui.get(M_Yaw) == "Spin" or ui.get(M_Yaw) == "Static" or ui.get(M_Yaw) == "180 Z" or ui.get(M_Yaw) == "Crosshair"))
  ui.set_visible(M_YawJitterLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override) and (ui.get(M_Yaw) == "Defensive" or ui.get(M_Yaw) == "180" or ui.get(M_Yaw) == "Spin" or ui.get(M_Yaw) == "Static" or ui.get(M_Yaw) == "180 Z" or ui.get(M_Yaw) == "Crosshair") and (ui.get(M_YawJitter) == "Offset" or ui.get(M_YawJitter) == "Center" or ui.get(M_YawJitter) == "Random" or ui.get(M_YawJitter) == "Skitter"))
  ui.set_visible(M_YawJitterRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and (ui.get(M_Yaw) == "Defensive" or ui.get(M_Yaw) == "180" or ui.get(M_Yaw) == "Spin" or ui.get(M_Yaw) == "Static" or ui.get(M_Yaw) == "180 Z" or ui.get(M_Yaw) == "Crosshair") and ui.get(M_Override) and (ui.get(M_YawJitter) == "Offset" or ui.get(M_YawJitter) == "Center" or ui.get(M_YawJitter) == "Random" or ui.get(M_YawJitter) == "Skitter"))
  ui.set_visible(M_YawJitterDelaySlider, false) 
  ui.set_visible(M_BodyYaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override))
  ui.set_visible(M_BodyYawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override) and (ui.get(M_BodyYaw) == "Opposite" or ui.get(M_BodyYaw) == "Jitter" or ui.get(M_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(M_BodyYawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override) and (ui.get(M_BodyYaw) == "Opposite" or ui.get(M_BodyYaw) == "Jitter" or ui.get(M_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(M_BodyYawFreestanding, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[M] Move" and ui.get(M_Override) and (ui.get(M_BodyYaw) == "Opposite" or ui.get(M_BodyYaw) == "Jitter" or ui.get(M_BodyYaw) == "Anti-Bruteforce"))



  ui.set_visible(J_Override, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump")
  ui.set_visible(J_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override))
  ui.set_visible(J_DefensiveAA_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override) and ui.get(J_Pitch) == "Defensive")
  ui.set_visible(J_PitchLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override) and (ui.get(J_Pitch) == "Custom" or ui.get(J_Pitch) == "Defensive"))
  ui.set_visible(J_PitchRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override) and (ui.get(J_Pitch) == "Custom" or ui.get(J_Pitch) == "Defensive"))
  ui.set_visible(J_YawBase, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override))
  ui.set_visible(J_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override))
  ui.set_visible(J_DefensiveAA_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override) and ui.get(J_Yaw) == "Defensive")
  ui.set_visible(J_SwitchDelay, false) 
  ui.set_visible(J_YawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override) and (ui.get(J_Yaw) == "Defensive" or ui.get(J_Yaw) == "180" or ui.get(J_Yaw) == "Spin" or ui.get(J_Yaw) == "Static" or ui.get(J_Yaw) == "180 Z" or ui.get(J_Yaw) == "Crosshair"))
  ui.set_visible(J_YawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override) and (ui.get(J_Yaw) == "Defensive" or ui.get(J_Yaw) == "180" or ui.get(J_Yaw) == "Spin" or ui.get(J_Yaw) == "Static" or ui.get(J_Yaw) == "180 Z" or ui.get(J_Yaw) == "Crosshair"))
  ui.set_visible(J_YawJitter, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override) and (ui.get(J_Yaw) == "Defensive" or ui.get(J_Yaw) == "180" or ui.get(J_Yaw) == "Spin" or ui.get(J_Yaw) == "Static" or ui.get(J_Yaw) == "180 Z" or ui.get(J_Yaw) == "Crosshair"))
  ui.set_visible(J_YawJitterLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override) and (ui.get(J_Yaw) == "Defensive" or ui.get(J_Yaw) == "180" or ui.get(J_Yaw) == "Spin" or ui.get(J_Yaw) == "Static" or ui.get(J_Yaw) == "180 Z" or ui.get(J_Yaw) == "Crosshair") and (ui.get(J_YawJitter) == "Offset" or ui.get(J_YawJitter) == "Center" or ui.get(J_YawJitter) == "Random" or ui.get(J_YawJitter) == "Skitter"))
  ui.set_visible(J_YawJitterRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and (ui.get(J_Yaw) == "Defensive" or ui.get(J_Yaw) == "180" or ui.get(J_Yaw) == "Spin" or ui.get(J_Yaw) == "Static" or ui.get(J_Yaw) == "180 Z" or ui.get(J_Yaw) == "Crosshair") and ui.get(J_Override) and (ui.get(J_YawJitter) == "Offset" or ui.get(J_YawJitter) == "Center" or ui.get(J_YawJitter) == "Random" or ui.get(J_YawJitter) == "Skitter"))
  ui.set_visible(J_YawJitterDelaySlider, false) 
  ui.set_visible(J_BodyYaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override))
  ui.set_visible(J_BodyYawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override) and (ui.get(J_BodyYaw) == "Opposite" or ui.get(J_BodyYaw) == "Jitter" or ui.get(J_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(J_BodyYawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override) and (ui.get(J_BodyYaw) == "Opposite" or ui.get(J_BodyYaw) == "Jitter" or ui.get(J_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(J_BodyYawFreestanding, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[J] Jump" and ui.get(J_Override) and (ui.get(J_BodyYaw) == "Opposite" or ui.get(J_BodyYaw) == "Jitter" or ui.get(J_BodyYaw) == "Anti-Bruteforce"))


  ui.set_visible(C_Override, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch")
  ui.set_visible(C_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override))
  ui.set_visible(C_DefensiveAA_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override) and ui.get(C_Pitch) == "Defensive")
  ui.set_visible(C_PitchLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override) and (ui.get(C_Pitch) == "Custom" or ui.get(C_Pitch) == "Defensive"))
  ui.set_visible(C_PitchRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override) and (ui.get(C_Pitch) == "Custom" or ui.get(C_Pitch) == "Defensive"))
  ui.set_visible(C_YawBase, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override))
  ui.set_visible(C_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override))
  ui.set_visible(C_DefensiveAA_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override) and ui.get(C_Yaw) == "Defensive")
  ui.set_visible(C_SwitchDelay, false) 
  ui.set_visible(C_YawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override) and (ui.get(C_Yaw) == "Defensive" or ui.get(C_Yaw) == "180" or ui.get(C_Yaw) == "Spin" or ui.get(C_Yaw) == "Static" or ui.get(C_Yaw) == "180 Z" or ui.get(C_Yaw) == "Crosshair"))
  ui.set_visible(C_YawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override) and (ui.get(C_Yaw) == "Defensive" or ui.get(C_Yaw) == "180" or ui.get(C_Yaw) == "Spin" or ui.get(C_Yaw) == "Static" or ui.get(C_Yaw) == "180 Z" or ui.get(C_Yaw) == "Crosshair"))
  ui.set_visible(C_YawJitter, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override) and (ui.get(C_Yaw) == "Defensive" or ui.get(C_Yaw) == "180" or ui.get(C_Yaw) == "Spin" or ui.get(C_Yaw) == "Static" or ui.get(C_Yaw) == "180 Z" or ui.get(C_Yaw) == "Crosshair"))
  ui.set_visible(C_YawJitterLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override) and (ui.get(C_Yaw) == "Defensive" or ui.get(C_Yaw) == "180" or ui.get(C_Yaw) == "Spin" or ui.get(C_Yaw) == "Static" or ui.get(C_Yaw) == "180 Z" or ui.get(C_Yaw) == "Crosshair") and (ui.get(C_YawJitter) == "Offset" or ui.get(C_YawJitter) == "Center" or ui.get(C_YawJitter) == "Random" or ui.get(C_YawJitter) == "Skitter"))
  ui.set_visible(C_YawJitterRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and (ui.get(C_Yaw) == "Defensive" or ui.get(C_Yaw) == "180" or ui.get(C_Yaw) == "Spin" or ui.get(C_Yaw) == "Static" or ui.get(C_Yaw) == "180 Z" or ui.get(C_Yaw) == "Crosshair") and ui.get(C_Override) and (ui.get(C_YawJitter) == "Offset" or ui.get(C_YawJitter) == "Center" or ui.get(C_YawJitter) == "Random" or ui.get(C_YawJitter) == "Skitter"))
  ui.set_visible(C_YawJitterDelaySlider, false) 
  ui.set_visible(C_BodyYaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override))
  ui.set_visible(C_BodyYawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override) and (ui.get(C_BodyYaw) == "Opposite" or ui.get(C_BodyYaw) == "Jitter" or ui.get(C_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(C_BodyYawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override) and (ui.get(C_BodyYaw) == "Opposite" or ui.get(C_BodyYaw) == "Jitter" or ui.get(C_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(C_BodyYawFreestanding, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C] Crouch" and ui.get(C_Override) and (ui.get(C_BodyYaw) == "Opposite" or ui.get(C_BodyYaw) == "Jitter" or ui.get(C_BodyYaw) == "Anti-Bruteforce"))



  ui.set_visible(CA_Override, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air")
  ui.set_visible(CA_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override))
  ui.set_visible(CA_DefensiveAA_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override) and ui.get(CA_Pitch) == "Defensive")
  ui.set_visible(CA_PitchLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override) and (ui.get(CA_Pitch) == "Custom" or ui.get(CA_Pitch) == "Defensive"))
  ui.set_visible(CA_PitchRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override) and (ui.get(CA_Pitch) == "Custom" or ui.get(CA_Pitch) == "Defensive"))
  ui.set_visible(CA_YawBase, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override))
  ui.set_visible(CA_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override))
  ui.set_visible(CA_DefensiveAA_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override) and ui.get(CA_Yaw) == "Defensive")
  ui.set_visible(CA_SwitchDelay, false) 
  ui.set_visible(CA_YawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override) and (ui.get(CA_Yaw) == "Defensive" or ui.get(CA_Yaw) == "180" or ui.get(CA_Yaw) == "Spin" or ui.get(CA_Yaw) == "Static" or ui.get(CA_Yaw) == "180 Z" or ui.get(CA_Yaw) == "Crosshair"))
  ui.set_visible(CA_YawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override) and (ui.get(CA_Yaw) == "Defensive" or ui.get(CA_Yaw) == "180" or ui.get(CA_Yaw) == "Spin" or ui.get(CA_Yaw) == "Static" or ui.get(CA_Yaw) == "180 Z" or ui.get(CA_Yaw) == "Crosshair"))
  ui.set_visible(CA_YawJitter, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override) and (ui.get(CA_Yaw) == "Defensive" or ui.get(CA_Yaw) == "180" or ui.get(CA_Yaw) == "Spin" or ui.get(CA_Yaw) == "Static" or ui.get(CA_Yaw) == "180 Z" or ui.get(CA_Yaw) == "Crosshair"))
  ui.set_visible(CA_YawJitterLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override) and (ui.get(CA_Yaw) == "Defensive" or ui.get(CA_Yaw) == "180" or ui.get(CA_Yaw) == "Spin" or ui.get(CA_Yaw) == "Static" or ui.get(CA_Yaw) == "180 Z" or ui.get(CA_Yaw) == "Crosshair") and (ui.get(CA_YawJitter) == "Offset" or ui.get(CA_YawJitter) == "Center" or ui.get(CA_YawJitter) == "Random" or ui.get(CA_YawJitter) == "Skitter"))
  ui.set_visible(CA_YawJitterRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and (ui.get(CA_Yaw) == "Defensive" or ui.get(CA_Yaw) == "180" or ui.get(CA_Yaw) == "Spin" or ui.get(CA_Yaw) == "Static" or ui.get(CA_Yaw) == "180 Z" or ui.get(CA_Yaw) == "Crosshair") and ui.get(CA_Override) and (ui.get(CA_YawJitter) == "Offset" or ui.get(CA_YawJitter) == "Center" or ui.get(CA_YawJitter) == "Random" or ui.get(CA_YawJitter) == "Skitter"))
  ui.set_visible(CA_YawJitterDelaySlider, false) 
  ui.set_visible(CA_BodyYaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override))
  ui.set_visible(CA_BodyYawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override) and (ui.get(CA_BodyYaw) == "Opposite" or ui.get(CA_BodyYaw) == "Jitter" or ui.get(CA_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(CA_BodyYawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override) and (ui.get(CA_BodyYaw) == "Opposite" or ui.get(CA_BodyYaw) == "Jitter" or ui.get(CA_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(CA_BodyYawFreestanding, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[C+A] Crouch+Air" and ui.get(CA_Override) and (ui.get(CA_BodyYaw) == "Opposite" or ui.get(CA_BodyYaw) == "Jitter" or ui.get(CA_BodyYaw) == "Anti-Bruteforce"))

    


  ui.set_visible(SW_Override, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk")
  ui.set_visible(SW_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override))
  ui.set_visible(SW_DefensiveAA_Pitch, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override) and ui.get(SW_Pitch) == "Defensive")
  ui.set_visible(SW_PitchLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override) and (ui.get(SW_Pitch) == "Custom" or ui.get(SW_Pitch) == "Defensive"))
  ui.set_visible(SW_PitchRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override) and (ui.get(SW_Pitch) == "Custom" or ui.get(SW_Pitch) == "Defensive"))
  ui.set_visible(SW_YawBase, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override))
  ui.set_visible(SW_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override))
  ui.set_visible(SW_DefensiveAA_Yaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override) and ui.get(SW_Yaw) == "Defensive")
  ui.set_visible(SW_SwitchDelay, false) 
  ui.set_visible(SW_YawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override) and (ui.get(SW_Yaw) == "Defensive" or ui.get(SW_Yaw) == "180" or ui.get(SW_Yaw) == "Spin" or ui.get(SW_Yaw) == "Static" or ui.get(SW_Yaw) == "180 Z" or ui.get(SW_Yaw) == "Crosshair"))
  ui.set_visible(SW_YawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override) and (ui.get(SW_Yaw) == "Defensive" or ui.get(SW_Yaw) == "180" or ui.get(SW_Yaw) == "Spin" or ui.get(SW_Yaw) == "Static" or ui.get(SW_Yaw) == "180 Z" or ui.get(SW_Yaw) == "Crosshair"))
  ui.set_visible(SW_YawJitter, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override) and (ui.get(SW_Yaw) == "Defensive" or ui.get(SW_Yaw) == "180" or ui.get(SW_Yaw) == "Spin" or ui.get(SW_Yaw) == "Static" or ui.get(SW_Yaw) == "180 Z" or ui.get(SW_Yaw) == "Crosshair"))
  ui.set_visible(SW_YawJitterLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override) and (ui.get(SW_Yaw) == "Defensive" or ui.get(SW_Yaw) == "180" or ui.get(SW_Yaw) == "Spin" or ui.get(SW_Yaw) == "Static" or ui.get(SW_Yaw) == "180 Z" or ui.get(SW_Yaw) == "Crosshair") and (ui.get(SW_YawJitter) == "Offset" or ui.get(SW_YawJitter) == "Center" or ui.get(SW_YawJitter) == "Random" or ui.get(SW_YawJitter) == "Skitter"))
  ui.set_visible(SW_YawJitterRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and (ui.get(SW_Yaw) == "Defensive" or ui.get(SW_Yaw) == "180" or ui.get(SW_Yaw) == "Spin" or ui.get(SW_Yaw) == "Static" or ui.get(SW_Yaw) == "180 Z" or ui.get(SW_Yaw) == "Crosshair") and ui.get(SW_Override) and (ui.get(SW_YawJitter) == "Offset" or ui.get(SW_YawJitter) == "Center" or ui.get(SW_YawJitter) == "Random" or ui.get(SW_YawJitter) == "Skitter"))
  ui.set_visible(SW_YawJitterDelaySlider, false) 
  ui.set_visible(SW_BodyYaw, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override))
  ui.set_visible(SW_BodyYawLeftSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override) and (ui.get(SW_BodyYaw) == "Opposite" or ui.get(SW_BodyYaw) == "Jitter" or ui.get(SW_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(SW_BodyYawRightSlider, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override) and (ui.get(SW_BodyYaw) == "Opposite" or ui.get(SW_BodyYaw) == "Jitter" or ui.get(SW_BodyYaw) == "Anti-Bruteforce"))
  ui.set_visible(SW_BodyYawFreestanding, container == "AntiAimContainer" and ui.get(AAmode) == "Custom" and ui.get(SelectionTabForCustom) == "[SW] Slow Walk" and ui.get(SW_Override) and (ui.get(SW_BodyYaw) == "Opposite" or ui.get(SW_BodyYaw) == "Jitter" or ui.get(SW_BodyYaw) == "Anti-Bruteforce"))


end

RV = 1
RV2 = 1
RV3 = 1
RV4 = 1
RV5 = 1
RV6 = 1
PRV = 1
PRV2 = 1
PRV3 = 1
PRV4 = 1
PRV5 = 1
PRV6 = 1
PRV7 = 1
PRV8 = 1
PRV9 = 1
PRV10 = 1
AASystem = function()
  lp = entity.get_local_player()
  if not entity.is_alive(lp) then
    return
  end

  if warmup and ui.get(DisableOnWarmup) then
    ui.set(ENABLE, false)
  else
    ui.set(ENABLE, true)
  end
  vx, vy, vz = entity.get_prop(lp, 'm_vecVelocity')
  State_Moving = (math.sqrt(vx * vx + vy * vy + vz * vz) >= 2 and bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 1)
  State_Jumping = (entity.get_prop(lp, "m_flDuckAmount") < 1 and bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 0)
  State_SlowWalk = ui.get(SLOWMOTION[2])
  State_FakeDuck = ui.get(FAKEDUCK)
  State_Crouch = (entity.get_prop(lp, "m_flDuckAmount") > 0 and bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 1)
  State_CrouchAir = (entity.get_prop(lp, "m_flDuckAmount") > 0 and bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 0)
  State_Standing = not State_SlowWalk and not State_Crouch and not State_CrouchAir and not State_FakeDuck and not State_Jumping and not State_Moving


  State_Defensive = false
  if globals.tickcount() % 5 == 4 then 
    if (ui.get(HIDESHOT[1]) and ui.get(HIDESHOT[2])) or (ui.get(DOUBLETAP[1]) and ui.get(DOUBLETAP[2])) then
      State_Defensive = true
    end
  end

  --Values
  S_PitchValues = {ui.get(S_PitchLeftSlider), ui.get(S_PitchLeftSlider), ui.get(S_PitchLeftSlider), ui.get(S_PitchRightSlider), ui.get(S_PitchRightSlider), ui.get(S_PitchRightSlider)}
  S_YawValues = {ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawLeftSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider), ui.get(S_YawRightSlider)}
  S_YawJitterValues = {ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterLeftSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider), ui.get(S_YawJitterRightSlider)}
  S_BodyYawValues = {ui.get(S_BodyYawRightSlider), ui.get(S_BodyYawRightSlider), ui.get(S_BodyYawRightSlider), ui.get(S_BodyYawLeftSlider), ui.get(S_BodyYawLeftSlider), ui.get(S_BodyYawLeftSlider)}
  M_PitchValues = {ui.get(M_PitchLeftSlider), ui.get(M_PitchLeftSlider), ui.get(M_PitchLeftSlider), ui.get(M_PitchRightSlider), ui.get(M_PitchRightSlider), ui.get(M_PitchRightSlider)}
  M_YawValues = {ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawLeftSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider), ui.get(M_YawRightSlider)}
  M_YawJitterValues = {ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterLeftSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider), ui.get(M_YawJitterRightSlider)}
  M_BodyYawValues = {ui.get(M_BodyYawLeftSlider), ui.get(M_BodyYawLeftSlider), ui.get(M_BodyYawLeftSlider), ui.get(M_BodyYawRightSlider), ui.get(M_BodyYawRightSlider), ui.get(M_BodyYawRightSlider)}
  C_PitchValues = {ui.get(C_PitchLeftSlider), ui.get(C_PitchLeftSlider), ui.get(C_PitchLeftSlider), ui.get(C_PitchRightSlider), ui.get(C_PitchRightSlider), ui.get(C_PitchRightSlider)}
  C_YawValues = {ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawLeftSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider), ui.get(C_YawRightSlider)}
  C_YawJitterValues = {ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterLeftSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider), ui.get(C_YawJitterRightSlider)}
  C_BodyYawValues = {ui.get(C_BodyYawLeftSlider), ui.get(C_BodyYawLeftSlider), ui.get(C_BodyYawLeftSlider), ui.get(C_BodyYawRightSlider), ui.get(C_BodyYawRightSlider), ui.get(C_BodyYawRightSlider)}
  CA_PitchValues = {ui.get(CA_PitchLeftSlider), ui.get(CA_PitchLeftSlider), ui.get(CA_PitchLeftSlider), ui.get(CA_PitchRightSlider), ui.get(CA_PitchRightSlider), ui.get(CA_PitchRightSlider)}
  CA_YawValues = {ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawLeftSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider), ui.get(CA_YawRightSlider)}
  CA_YawJitterValues = {ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterLeftSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider), ui.get(CA_YawJitterRightSlider)}
  CA_BodyYawValues = {ui.get(CA_BodyYawLeftSlider), ui.get(CA_BodyYawLeftSlider), ui.get(CA_BodyYawLeftSlider), ui.get(CA_BodyYawRightSlider), ui.get(CA_BodyYawRightSlider), ui.get(CA_BodyYawRightSlider)}
  J_PitchValues = {ui.get(J_PitchLeftSlider), ui.get(J_PitchLeftSlider), ui.get(J_PitchLeftSlider), ui.get(J_PitchRightSlider), ui.get(J_PitchRightSlider), ui.get(J_PitchRightSlider)}
  J_YawValues = {ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawLeftSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider), ui.get(J_YawRightSlider)}
  J_YawJitterValues = {ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterLeftSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider), ui.get(J_YawJitterRightSlider)}
  J_BodyYawValues = {ui.get(J_BodyYawLeftSlider), ui.get(J_BodyYawLeftSlider), ui.get(J_BodyYawLeftSlider), ui.get(J_BodyYawRightSlider), ui.get(J_BodyYawRightSlider), ui.get(J_BodyYawRightSlider)}
  SW_PitchValues = {ui.get(SW_PitchLeftSlider), ui.get(SW_PitchLeftSlider), ui.get(SW_PitchLeftSlider), ui.get(SW_PitchRightSlider), ui.get(SW_PitchRightSlider), ui.get(SW_PitchRightSlider)}
  SW_YawValues = {ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawLeftSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider), ui.get(SW_YawRightSlider)}
  SW_YawJitterValues = {ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterLeftSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider), ui.get(SW_YawJitterRightSlider)}
  SW_BodyYawValues = {ui.get(SW_BodyYawLeftSlider), ui.get(SW_BodyYawLeftSlider), ui.get(SW_BodyYawLeftSlider), ui.get(SW_BodyYawRightSlider), ui.get(SW_BodyYawRightSlider), ui.get(SW_BodyYawRightSlider)}
  DynamicJitValues = {50, 50, 50, -45, -45, -45}
  ExtendedRollAAValuesP = {45, 45, 45, -45, -45, -45}
  DefensivePitchValues = {-50, -50, -50, 89, 89, 89}
  DefensiveJitValues = {150, 150, 150, 0, 0, 0, 0, 0, 0, -150, -150, -150}
  AggressivePitchValues = {85, 85, 85, 89, 89, 89}
  AggressiveYAWWValues = {-4, -4, -4, 6, 6, 6}
  AggressiveYJValues = {-47, -47, -47, -57, -57, -57}
  AggressiveawValues = {-180, -180, -180, 180, 180, 180}

  if ui.get(AAmode) == "Dynamic" then
    ui.set(PITCH[1], "Down")
    ui.set(PITCH[2], 0)

    ui.set(YAWBASE, "At Targets")
  
    ui.set(YAW[1], "180")
    
    ui.set(YAW[2], DynamicJitValues[PRV])
    PRV = PRV + 1
    if PRV > 6 then
      PRV = 1 
    end
  
    ui.set(YAWJITTER[1], "Off")
    ui.set(YAWJITTER[2], 0)
 
  
    ui.set(BODYYAW[1], "Opposite")
    ui.set(BODYYAW[2], 0)
    ui.set(BODYYAWFREESTAND, true)

    ui.set(EXTENDEDROLL, ExtendedRollAAValuesP[PRV2])
    PRV2 = PRV2 + 1
    if PRV2 > 6 then
      PRV2 = 1 
    end
  
  elseif ui.get(AAmode) == "Defensive" then
    if State_Defensive then
      ui.set(PITCH[1], "Custom")

      ui.set(PITCH[2], DefensivePitchValues[PRV3])
      PRV3 = PRV3 + 1
      if PRV3 > 6 then
        PRV3 = 1 
      end
    else
      ui.set(PITCH[1], "Down")
    end

    ui.set(YAWBASE, "At Targets")

    if State_Defensive then
  
      ui.set(YAW[1], "180")

      ui.set(YAW[2], DefensiveJitValues[PRV4])
      PRV4 = PRV4 + 1
      if PRV4 > 12 then
        PRV4 = 1 
      end
    else
      ui.set(YAW[1], "180")
      ui.set(YAW[2], "0")
    end
  
    ui.set(YAWJITTER[1], "Off")
    ui.set(YAWJITTER[2], 0)
 
  
    ui.set(BODYYAW[1], "Opposite")
    ui.set(BODYYAW[2], 0)
    ui.set(BODYYAWFREESTAND, true)


    ui.set(EXTENDEDROLL, ExtendedRollAAValuesP[PRV5])
    PRV5 = PRV5 + 1
    if PRV5 > 6 then
      PRV5 = 1 
    end
  elseif ui.get(AAmode) == "Aggressive" then
      ui.set(PITCH[1], "Custom")
      ui.set(PITCH[2], AggressivePitchValues[PRV6])
      PRV6 = PRV6 + 1
      if PRV6 > 6 then
        PRV6 = 1 
      end
  
      ui.set(YAWBASE, "At Targets")
  
      ui.set(YAW[1], "180")

      ui.set(YAW[2], AggressiveYAWWValues[PRV7])
      PRV7 = PRV7 + 1
      if PRV7 > 6 then
        PRV7 = 1 
      end
  
      ui.set(YAWJITTER[1], "Center")

      ui.set(YAWJITTER[2], AggressiveYJValues[PRV8])
      PRV8 = PRV8 + 1
      if PRV8 > 6 then
        PRV8 = 1 
      end
  
      ui.set(BODYYAW[1], "Jitter")

      ui.set(BODYYAW[2], AggressiveawValues[PRV9])
      PRV9 = PRV9 + 1
      if PRV9 > 6 then
        PRV9 = 1 
      end
  
      ui.set(BODYYAWFREESTAND, true)

      ui.set(EXTENDEDROLL, ExtendedRollAAValuesP[PRV10])
      PRV10 = PRV10 + 1
      if PRV10 > 6 then
        PRV10 = 1 
      end

  elseif ui.get(AAmode) == "Custom" then
    if State_Standing then
      if ui.get(S_Override) then

        if ui.get(S_Pitch) == "Defensive" then
          if State_Defensive then
            S_DefensiveAA_Pitch_Value = {ui.get(S_DefensiveAA_Pitch),ui.get(S_DefensiveAA_Pitch),ui.get(S_DefensiveAA_Pitch), ui.get(S_PitchLeftSlider),ui.get(S_PitchRightSlider),ui.get(S_PitchLeftSlider), -ui.get(S_DefensiveAA_Pitch),-ui.get(S_DefensiveAA_Pitch),-ui.get(S_DefensiveAA_Pitch)}
            ui.set(PITCH[1], "Custom")
            ui.set(PITCH[2], S_DefensiveAA_Pitch_Value[RV])
            RV = RV + 1
            if RV > 9 then
              RV = 1 
            end
          else
            ui.set(PITCH[1], "Down")
          end
        else
          ui.set(PITCH[1], ui.get(S_Pitch))
          ui.set(PITCH[2], S_PitchValues[RV2])
          RV2 = RV2 + 1
          if RV2 > 6 then
            RV2 = 1 
          end
  
        end
  
    
        
        ui.set(YAWBASE, ui.get(S_YawBase))
    
        if ui.get(S_Yaw) == "Defensive" then
          if State_Defensive then
            S_DefensiveAA_Yaw_Value = {ui.get(S_DefensiveAA_Yaw),ui.get(S_DefensiveAA_Yaw),ui.get(S_DefensiveAA_Yaw), ui.get(S_YawLeftSlider),ui.get(S_YawRightSlider),ui.get(S_YawLeftSlider), -ui.get(S_DefensiveAA_Yaw),-ui.get(S_DefensiveAA_Yaw),-ui.get(S_DefensiveAA_Yaw)}
            ui.set(YAW[1], "180")
            ui.set(YAW[2], S_DefensiveAA_Yaw_Value[RV3])
            RV3 = RV3 + 1
            if RV3 > 9 then
              RV3 = 1 
            end
          else
            ui.set(YAW[1], "180")
            ui.set(YAW[2], "0")
          end
        else
          ui.set(YAW[1], ui.get(S_Yaw))
          ui.set(YAW[2], S_YawValues[RV4])
          RV4 = RV4 + 1
          if RV4 > 6 then
            RV4 = 1 
          end
  
        end
    
        ui.set(YAWJITTER[1], ui.get(S_YawJitter))
        ui.set(YAWJITTER[2], S_YawJitterValues[RV5])
        RV5 = RV5 + 1
        if RV5 > 6 then
          RV5 = 1 
        end
        
        if ui.get(S_BodyYaw) == "Anti-Bruteforce" then
          ui.set(BODYYAW[1], "Static")
        else
          ui.set(BODYYAW[1], ui.get(S_BodyYaw))
        end
  
        ui.set(BODYYAW[2], S_BodyYawValues[RV6])
        RV6 = RV6 + 1
        if RV6 > 6 then
          RV6 = 1 
        end
    
        ui.set(BODYYAWFREESTAND, ui.get(S_BodyYawFreestanding))
      end
      
  
    elseif State_Jumping then
      if ui.get(J_Override) then
        if ui.get(J_Pitch) == "Defensive" then
          if State_Defensive then
            J_DefensiveAA_Pitch_Value = {ui.get(J_DefensiveAA_Pitch),ui.get(J_DefensiveAA_Pitch),ui.get(J_DefensiveAA_Pitch), ui.get(J_PitchLeftSlider),ui.get(J_PitchRightSlider),ui.get(J_PitchLeftSlider), -ui.get(J_DefensiveAA_Pitch),-ui.get(J_DefensiveAA_Pitch),-ui.get(J_DefensiveAA_Pitch)}
            ui.set(PITCH[1], "Custom")
            ui.set(PITCH[2], J_DefensiveAA_Pitch_Value[RV])
            RV = RV + 1
            if RV > 9 then
              RV = 1 
            end
          else
            ui.set(PITCH[1], "Down")
          end
        else
          ui.set(PITCH[1], ui.get(J_Pitch))
          ui.set(PITCH[2], J_PitchValues[RV2])
          RV2 = RV2 + 1
          if RV2 > 6 then
            RV2 = 1 
          end
  
        end
  
    
        
        ui.set(YAWBASE, ui.get(J_YawBase))
    
        if ui.get(J_Yaw) == "Defensive" then
          if State_Defensive then
            J_DefensiveAA_Yaw_Value = {ui.get(J_DefensiveAA_Yaw),ui.get(J_DefensiveAA_Yaw),ui.get(J_DefensiveAA_Yaw), ui.get(J_YawLeftSlider),ui.get(J_YawRightSlider),ui.get(J_YawLeftSlider), -ui.get(J_DefensiveAA_Yaw),-ui.get(J_DefensiveAA_Yaw),-ui.get(J_DefensiveAA_Yaw)}
            ui.set(YAW[1], "180")
            ui.set(YAW[2], J_DefensiveAA_Yaw_Value[RV3])
            RV3 = RV3 + 1
            if RV3 > 9 then
              RV3 = 1 
            end
          else
            ui.set(YAW[1], "180")
            ui.set(YAW[2], "0")
          end
        else
          ui.set(YAW[1], ui.get(J_Yaw))
          ui.set(YAW[2], J_YawValues[RV4])
          RV4 = RV4 + 1
          if RV4 > 6 then
            RV4 = 1 
          end
  
        end
    
        ui.set(YAWJITTER[1], ui.get(J_YawJitter))
        ui.set(YAWJITTER[2], J_YawJitterValues[RV5])
        RV5 = RV5 + 1
        if RV5 > 6 then
          RV5 = 1 
        end
        
        if ui.get(J_BodyYaw) == "Anti-Bruteforce" then
          ui.set(BODYYAW[1], "Static")
        else
          ui.set(BODYYAW[1], ui.get(J_BodyYaw))
        end
  
        ui.set(BODYYAW[2], J_BodyYawValues[RV6])
        RV6 = RV6 + 1
        if RV6 > 6 then
          RV6 = 1 
        end
    
        ui.set(BODYYAWFREESTAND, ui.get(J_BodyYawFreestanding))
      end
   
      
    elseif  State_FakeDuck then
      if ui.get(C_Override) then
        if ui.get(C_Pitch) == "Defensive" then
          if State_Defensive then
            C_DefensiveAA_Pitch_Value = {ui.get(C_DefensiveAA_Pitch),ui.get(C_DefensiveAA_Pitch),ui.get(C_DefensiveAA_Pitch), ui.get(C_PitchLeftSlider),ui.get(C_PitchRightSlider),ui.get(C_PitchLeftSlider), -ui.get(C_DefensiveAA_Pitch),-ui.get(C_DefensiveAA_Pitch),-ui.get(C_DefensiveAA_Pitch)}
            ui.set(PITCH[1], "Custom")
            ui.set(PITCH[2], C_DefensiveAA_Pitch_Value[RV])
            RV = RV + 1
            if RV > 9 then
              RV = 1 
            end
          else
            ui.set(PITCH[1], "Down")
          end
        else
          ui.set(PITCH[1], ui.get(C_Pitch))
          ui.set(PITCH[2], C_PitchValues[RV2])
          RV2 = RV2 + 1
          if RV2 > 6 then
            RV2 = 1 
          end
  
        end
  
    
        
        ui.set(YAWBASE, ui.get(C_YawBase))
    
        if ui.get(C_Yaw) == "Defensive" then
          if State_Defensive then
            C_DefensiveAA_Yaw_Value = {ui.get(C_DefensiveAA_Yaw),ui.get(C_DefensiveAA_Yaw),ui.get(C_DefensiveAA_Yaw), ui.get(C_YawLeftSlider),ui.get(C_YawRightSlider),ui.get(C_YawLeftSlider), -ui.get(C_DefensiveAA_Yaw),-ui.get(C_DefensiveAA_Yaw),-ui.get(C_DefensiveAA_Yaw)}
            ui.set(YAW[1], "180")
            ui.set(YAW[2], C_DefensiveAA_Yaw_Value[RV3])
            RV3 = RV3 + 1
            if RV3 > 9 then
              RV3 = 1 
            end
          else
            ui.set(YAW[1], "180")
            ui.set(YAW[2], "0")
          end
        else
          ui.set(YAW[1], ui.get(C_Yaw))
          ui.set(YAW[2], C_YawValues[RV4])
          RV4 = RV4 + 1
          if RV4 > 6 then
            RV4 = 1 
          end
  
        end
    
        ui.set(YAWJITTER[1], ui.get(C_YawJitter))
        ui.set(YAWJITTER[2], C_YawJitterValues[RV5])
        RV5 = RV5 + 1
        if RV5 > 6 then
          RV5 = 1 
        end
        
        if ui.get(C_BodyYaw) == "Anti-Bruteforce" then
          ui.set(BODYYAW[1], "Static")
        else
          ui.set(BODYYAW[1], ui.get(C_BodyYaw))
        end
  
        ui.set(BODYYAW[2], C_BodyYawValues[RV6])
        RV6 = RV6 + 1
        if RV6 > 6 then
          RV6 = 1 
        end
    
        ui.set(BODYYAWFREESTAND, ui.get(C_BodyYawFreestanding))
      end
  
      
    elseif  State_Crouch then
      if ui.get(C_Override) then
        if ui.get(C_Pitch) == "Defensive" then
          if State_Defensive then
            C_DefensiveAA_Pitch_Value = {ui.get(C_DefensiveAA_Pitch),ui.get(C_DefensiveAA_Pitch),ui.get(C_DefensiveAA_Pitch), ui.get(C_PitchLeftSlider),ui.get(C_PitchRightSlider),ui.get(C_PitchLeftSlider), -ui.get(C_DefensiveAA_Pitch),-ui.get(C_DefensiveAA_Pitch),-ui.get(C_DefensiveAA_Pitch)}
            ui.set(PITCH[1], "Custom")
            ui.set(PITCH[2], C_DefensiveAA_Pitch_Value[RV])
            RV = RV + 1
            if RV > 9 then
              RV = 1 
            end
          else
            ui.set(PITCH[1], "Down")
          end
        else
          ui.set(PITCH[1], ui.get(C_Pitch))
          ui.set(PITCH[2], C_PitchValues[RV2])
          RV2 = RV2 + 1
          if RV2 > 6 then
            RV2 = 1 
          end
  
        end
  
    
        
        ui.set(YAWBASE, ui.get(C_YawBase))
    
        if ui.get(C_Yaw) == "Defensive" then
          if State_Defensive then
            C_DefensiveAA_Yaw_Value = {ui.get(C_DefensiveAA_Yaw),ui.get(C_DefensiveAA_Yaw),ui.get(C_DefensiveAA_Yaw), ui.get(C_YawLeftSlider),ui.get(C_YawRightSlider),ui.get(C_YawLeftSlider), -ui.get(C_DefensiveAA_Yaw),-ui.get(C_DefensiveAA_Yaw),-ui.get(C_DefensiveAA_Yaw)}
            ui.set(YAW[1], "180")
            ui.set(YAW[2], C_DefensiveAA_Yaw_Value[RV3])
            RV3 = RV3 + 1
            if RV3 > 9 then
              RV3 = 1 
            end
          else
            ui.set(YAW[1], "180")
            ui.set(YAW[2], "0")
          end
        else
          ui.set(YAW[1], ui.get(C_Yaw))
          ui.set(YAW[2], C_YawValues[RV4])
          RV4 = RV4 + 1
          if RV4 > 6 then
            RV4 = 1 
          end
  
        end
    
        ui.set(YAWJITTER[1], ui.get(C_YawJitter))
        ui.set(YAWJITTER[2], C_YawJitterValues[RV5])
        RV5 = RV5 + 1
        if RV5 > 6 then
          RV5 = 1 
        end
        
        if ui.get(C_BodyYaw) == "Anti-Bruteforce" then
          ui.set(BODYYAW[1], "Static")
        else
          ui.set(BODYYAW[1], ui.get(C_BodyYaw))
        end
  
        ui.set(BODYYAW[2], C_BodyYawValues[RV6])
        RV6 = RV6 + 1
        if RV6 > 6 then
          RV6 = 1 
        end
    
        ui.set(BODYYAWFREESTAND, ui.get(C_BodyYawFreestanding))
      end
  
      
      
    elseif  State_CrouchAir then
      if ui.get(CA_Override) then
        if ui.get(CA_Pitch) == "Defensive" then
          if State_Defensive then
            CA_DefensiveAA_Pitch_Value = {ui.get(CA_DefensiveAA_Pitch),ui.get(CA_DefensiveAA_Pitch),ui.get(CA_DefensiveAA_Pitch), ui.get(CA_PitchLeftSlider),ui.get(CA_PitchRightSlider),ui.get(CA_PitchLeftSlider), -ui.get(CA_DefensiveAA_Pitch),-ui.get(CA_DefensiveAA_Pitch),-ui.get(CA_DefensiveAA_Pitch)}
            ui.set(PITCH[1], "Custom")
            ui.set(PITCH[2], CA_DefensiveAA_Pitch_Value[RV])
            RV = RV + 1
             if RV > 9 then
              RV = 1 
            end
          else
            ui.set(PITCH[1], "Down")
          end
          
        else
          ui.set(PITCH[1], ui.get(CA_Pitch))
          ui.set(PITCH[2], CA_PitchValues[RV2])
          RV2 = RV2 + 1
          if RV2 > 6 then
            RV2 = 1 
          end
  
        end
  
    
        
        ui.set(YAWBASE, ui.get(CA_YawBase))
    
        if ui.get(CA_Yaw) == "Defensive" then
          if State_Defensive then
            CA_DefensiveAA_Yaw_Value = {ui.get(CA_DefensiveAA_Yaw),ui.get(CA_DefensiveAA_Yaw),ui.get(CA_DefensiveAA_Yaw), ui.get(CA_YawLeftSlider),ui.get(CA_YawRightSlider),ui.get(CA_YawLeftSlider), -ui.get(CA_DefensiveAA_Yaw),-ui.get(CA_DefensiveAA_Yaw),-ui.get(CA_DefensiveAA_Yaw)}
            ui.set(YAW[1], "180")
            ui.set(YAW[2], CA_DefensiveAA_Yaw_Value[RV3])
            RV3 = RV3 + 1
            if RV3 > 9 then
              RV3 = 1 
            end
          else
            ui.set(YAW[1], "180")
            ui.set(YAW[2], "0")
          end
        else
          ui.set(YAW[1], ui.get(CA_Yaw))
          ui.set(YAW[2], CA_YawValues[RV4])
          RV4 = RV4 + 1
          if RV4 > 6 then
            RV4 = 1 
          end
  
        end
    
        ui.set(YAWJITTER[1], ui.get(CA_YawJitter))
        ui.set(YAWJITTER[2], CA_YawJitterValues[RV5])
        RV5 = RV5 + 1
        if RV5 > 6 then
          RV5 = 1 
        end
        
        if ui.get(CA_BodyYaw) == "Anti-Bruteforce" then
          ui.set(BODYYAW[1], "Static")
        else
          ui.set(BODYYAW[1], ui.get(CA_BodyYaw))
        end
  
        ui.set(BODYYAW[2], CA_BodyYawValues[RV6])
        RV6 = RV6 + 1
        if RV6 > 6 then
          RV6 = 1 
        end
    
        ui.set(BODYYAWFREESTAND, ui.get(CA_BodyYawFreestanding))
      end
  
      
      
    elseif State_SlowWalk then
      if ui.get(SW_Override) then
        if ui.get(SW_Pitch) == "Defensive" then
          if State_Defensive then
            SW_DefensiveAA_Pitch_Value = {ui.get(SW_DefensiveAA_Pitch),ui.get(SW_DefensiveAA_Pitch),ui.get(SW_DefensiveAA_Pitch), ui.get(SW_PitchLeftSlider),ui.get(SW_PitchRightSlider),ui.get(SW_PitchLeftSlider), -ui.get(SW_DefensiveAA_Pitch),-ui.get(SW_DefensiveAA_Pitch),-ui.get(SW_DefensiveAA_Pitch)}
            ui.set(PITCH[1], "Custom")
            ui.set(PITCH[2], SW_DefensiveAA_Pitch_Value[RV])
            RV = RV + 1
            if RV > 9 then
              RV = 1 
            end
          else
            ui.set(PITCH[1], "Down")
          end
        else
          ui.set(PITCH[1], ui.get(SW_Pitch))
          ui.set(PITCH[2], SW_PitchValues[RV2])
          RV2 = RV2 + 1
          if RV2 > 6 then
            RV2 = 1 
          end
  
        end
  
    
        
        ui.set(YAWBASE, ui.get(SW_YawBase))
    
        if ui.get(SW_Yaw) == "Defensive" then
          if State_Defensive then
            SW_DefensiveAA_Yaw_Value = {ui.get(SW_DefensiveAA_Yaw),ui.get(SW_DefensiveAA_Yaw),ui.get(SW_DefensiveAA_Yaw), ui.get(SW_YawLeftSlider),ui.get(SW_YawRightSlider),ui.get(SW_YawLeftSlider), -ui.get(SW_DefensiveAA_Yaw),-ui.get(SW_DefensiveAA_Yaw),-ui.get(SW_DefensiveAA_Yaw)}
            ui.set(YAW[1], "180")
            ui.set(YAW[2], SW_DefensiveAA_Yaw_Value[RV3])
            RV3 = RV3 + 1
            if RV3 > 9 then
              RV3 = 1 
            end
          else
            ui.set(YAW[1], "180")
            ui.set(YAW[2], "0")
          end
        else
          ui.set(YAW[1], ui.get(SW_Yaw))
          ui.set(YAW[2], SW_YawValues[RV4])
          RV4 = RV4 + 1
          if RV4 > 6 then
            RV4 = 1 
          end
  
        end
    
        ui.set(YAWJITTER[1], ui.get(SW_YawJitter))
        ui.set(YAWJITTER[2], SW_YawJitterValues[RV5])
        RV5 = RV5 + 1
        if RV5 > 6 then
          RV5 = 1 
        end
        
        if ui.get(SW_BodyYaw) == "Anti-Bruteforce" then
          ui.set(BODYYAW[1], "Static")
        else
          ui.set(BODYYAW[1], ui.get(SW_BodyYaw))
        end
  
        ui.set(BODYYAW[2], SW_BodyYawValues[RV6])
        RV6 = RV6 + 1
        if RV6 > 6 then
          RV6 = 1 
        end
    
        ui.set(BODYYAWFREESTAND, ui.get(SW_BodyYawFreestanding))
      end
  
      
     
    elseif State_Moving then
      if ui.get(M_Override) then
        if ui.get(M_Pitch) == "Defensive" then
          if State_Defensive then
            M_DefensiveAA_Pitch_Value = {ui.get(M_DefensiveAA_Pitch),ui.get(M_DefensiveAA_Pitch),ui.get(M_DefensiveAA_Pitch), ui.get(M_PitchLeftSlider),ui.get(M_PitchRightSlider),ui.get(M_PitchLeftSlider), -ui.get(M_DefensiveAA_Pitch),-ui.get(M_DefensiveAA_Pitch),-ui.get(M_DefensiveAA_Pitch)}
            ui.set(PITCH[1], "Custom")
            ui.set(PITCH[2], M_DefensiveAA_Pitch_Value[RV])
            RV = RV + 1
            if RV > 9 then
              RV = 1 
            end
          else
            ui.set(PITCH[1], "Down")
          end
        else
          ui.set(PITCH[1], ui.get(M_Pitch))
          ui.set(PITCH[2], M_PitchValues[RV2])
          RV2 = RV2 + 1
          if RV2 > 6 then
            RV2 = 1 
          end
  
        end
  
    
        
        ui.set(YAWBASE, ui.get(M_YawBase))
    
        if ui.get(M_Yaw) == "Defensive" then
          if State_Defensive then
            M_DefensiveAA_Yaw_Value = {ui.get(M_DefensiveAA_Yaw),ui.get(M_DefensiveAA_Yaw),ui.get(M_DefensiveAA_Yaw), ui.get(M_YawLeftSlider),ui.get(M_YawRightSlider),ui.get(M_YawLeftSlider), -ui.get(M_DefensiveAA_Yaw),-ui.get(M_DefensiveAA_Yaw),-ui.get(M_DefensiveAA_Yaw)}
            ui.set(YAW[1], "180")
            ui.set(YAW[2], M_DefensiveAA_Yaw_Value[RV3])
            RV3 = RV3 + 1
            if RV3 > 9 then
              RV3 = 1 
            end
          else
            ui.set(YAW[1], "180")
            ui.set(YAW[2], "0")
          end
        else
          ui.set(YAW[1], ui.get(M_Yaw))
          ui.set(YAW[2], M_YawValues[RV4])
          RV4 = RV4 + 1
          if RV4 > 6 then
            RV4 = 1 
          end
  
        end
    
        ui.set(YAWJITTER[1], ui.get(M_YawJitter))
        ui.set(YAWJITTER[2], M_YawJitterValues[RV5])
        RV5 = RV5 + 1
        if RV5 > 6 then
          RV5 = 1 
        end
        
        if ui.get(M_BodyYaw) == "Anti-Bruteforce" then
          ui.set(BODYYAW[1], "Static")
        else
          ui.set(BODYYAW[1], ui.get(M_BodyYaw))
        end
  
        ui.set(BODYYAW[2], M_BodyYawValues[RV6])
        RV6 = RV6 + 1
        if RV6 > 6 then
          RV6 = 1 
        end
    
        ui.set(BODYYAWFREESTAND, ui.get(M_BodyYawFreestanding))
      end
  
    end
  end

  




  
end




--visuals
CSSX, CSSY = client.screen_size()
IndicX = CSSX / 2
IndicY = CSSY / 2

lerp = function(a, b, percentage)
    return math.floor(a + (b - a) * percentage)
end

anim = {0, 0, 0, 0, 0, 0}


--indicators
indic_switch = ui.new_checkbox("AA", "Anti-aimbot angles", "\a"..Hex_MENUCOLOR.."Indicators")
Indicators_Selection = ui.new_multiselect("AA", "Anti-aimbot angles", "[I] Options", {"DMG", "HC"})
Indic_Color1L = ui.new_label("AA", "Anti-aimbot angles", "[1] Colour")
Indic_Color1 = ui.new_color_picker("AA", "Anti-aimbot angles", "[1] Colour")
Indic_Color2L = ui.new_label("AA", "Anti-aimbot angles", "[2] Colour")
Indic_Color2 = ui.new_color_picker("AA", "Anti-aimbot angles", "[2] Colour")
IND_DMG_ColorL = ui.new_label("AA", "Anti-aimbot angles", "[DMG] Colour")
IND_DMG_Color = ui.new_color_picker("AA", "Anti-aimbot angles", "[DMG] Colour")
IND_HC_ColorL = ui.new_label("AA", "Anti-aimbot angles", "[HC] Colour")
IND_HC_Color = ui.new_color_picker("AA", "Anti-aimbot angles", "[HC] Colour")

--MinDmg_indicator
MinDmg_indicator = ui.new_checkbox("AA", "Anti-aimbot angles", "Mindmg Indicator")





--Viewmodel
ViewmodelChanger = ui.new_checkbox("AA", "Anti-aimbot angles", "Viewmodel")
Viewmodel_fov = ui.new_slider("AA", "Anti-aimbot angles", "[FOV] Value", 0, 100, 68)
Viewmodel_x = ui.new_slider("AA", "Anti-aimbot angles", "[X] Value", -10, 10, 2)
Viewmodel_y = ui.new_slider("AA", "Anti-aimbot angles", "[Y] Value", -10, 10, 0)
Viewmodel_z = ui.new_slider("AA", "Anti-aimbot angles", "[Z] Value", -10, 10, -2)

--rainbow hud 
RainbowHud = ui.new_checkbox("AA", "Anti-aimbot angles", "Rainbow Hud")
rb = 1
hudcolors = {1,1,1,1,1,1, 2,2,2,2,2,2, 3,3,3,3,3,3, 4,4,4,4,4,4, 5,5,5,5,5,5, 6,6,6,6,6,6, 7,7,7,7,7,7, 8,8,8,8,8,8, 9,9,9,9,9,9, 10,10,10,10,10,10}

--watermark
Water_Mark_VF = ui.new_checkbox("AA", "Anti-aimbot angles", "WaterMark")
Water_Mark_VF_Color = ui.new_color_picker("AA", "Anti-aimbot angles", "WaterMark Colour")
Water_Mark_VF_Disable_Anim = ui.new_checkbox("AA", "Anti-aimbot angles", "[W] Disable Animation")
Water_Mark_VF_Trans = ui.new_checkbox("AA", "Anti-aimbot angles", "[W] Transparent Background")
Water_Mark_VF_Corner = ui.new_checkbox("AA", "Anti-aimbot angles", "[W] Rounded Corners")
Water_Mark_VF_Corner_Slider = ui.new_slider("AA", "Anti-aimbot angles", "[W]  Corners", 0, 10)

--keybinds
Keybinds_VF = ui.new_checkbox("AA", "Anti-aimbot angles", "Keybinds")
Keybinds_VF_Color = ui.new_color_picker("AA", "Anti-aimbot angles", "[K] Keybinds Colour")
Keybinds_VF_Disable_Anim = ui.new_checkbox("AA", "Anti-aimbot angles", "[K] Disable Animation")
Keybinds_VF_Trans = ui.new_checkbox("AA", "Anti-aimbot angles", "[K] Transparent Background")
Keybinds_VF_Corner = ui.new_checkbox("AA", "Anti-aimbot angles", "[K] Rounded Corners")
Keybinds_VF_Corner_Slider = ui.new_slider("AA", "Anti-aimbot angles", "[W]  Corners", 0, 10)


--hitlogs
Hitlog = ui.new_checkbox("AA", "Anti-aimbot angles", "HitLogs")
HitLogs = ui.new_multiselect("AA", "Anti-aimbot angles", "[HL]", {"Under Crosshair", "Console"})
Log_Color = ui.new_color_picker("AA", "Anti-aimbot angles", "Log Colour")
Log_Color_Box = ui.new_color_picker("AA", "Anti-aimbot angles", "Box Colour")
Hitlog_Gaps = ui.new_slider("AA", "Anti-aimbot angles", " [HL] Gap Value", 0, 10, 6)
Hitlog_Disable_Anim = ui.new_checkbox("AA", "Anti-aimbot angles", "[HL] Disable Animation")
Hitlog_Trans = ui.new_checkbox("AA", "Anti-aimbot angles", "[HL] Transparent Background")
Hitlog_Corner = ui.new_checkbox("AA", "Anti-aimbot angles", "[HL] Rounded Corners")
Hitlog_Corner_Slider = ui.new_slider("AA", "Anti-aimbot angles", "[W]  Corners", 0, 10)


VisualsSystemRenderer = function()
  ui.set_visible(indic_switch, container == "VisualContainer")
  ui.set_visible(Indicators_Selection, container == "VisualContainer" and ui.get(indic_switch))
  ui.set_visible(Indic_Color1L, container == "VisualContainer" and ui.get(indic_switch))
  ui.set_visible(Indic_Color1, container == "VisualContainer" and ui.get(indic_switch))
  ui.set_visible(Indic_Color2L, container == "VisualContainer" and ui.get(indic_switch))
  ui.set_visible(Indic_Color2, container == "VisualContainer" and ui.get(indic_switch))
  ui.set_visible(IND_DMG_ColorL, container == "VisualContainer" and ui.get(indic_switch))
  ui.set_visible(IND_DMG_Color, container == "VisualContainer" and ui.get(indic_switch))
  ui.set_visible(IND_HC_ColorL, container == "VisualContainer" and ui.get(indic_switch))
  ui.set_visible(IND_HC_Color, container == "VisualContainer" and ui.get(indic_switch))
  ui.set_visible(ViewmodelChanger, container == "VisualContainer")
  ui.set_visible(Viewmodel_fov, container == "VisualContainer" and ui.get(ViewmodelChanger))
  ui.set_visible(Viewmodel_x, container == "VisualContainer" and ui.get(ViewmodelChanger))
  ui.set_visible(Viewmodel_y, container == "VisualContainer" and ui.get(ViewmodelChanger))
  ui.set_visible(Viewmodel_z, container == "VisualContainer" and ui.get(ViewmodelChanger))
  ui.set_visible(RainbowHud, container == "VisualContainer")
  ui.set_visible(MinDmg_indicator, container == "VisualContainer")
  ui.set_visible(Water_Mark_VF, container == "VisualContainer")
  ui.set_visible(Water_Mark_VF_Color, container == "VisualContainer" and ui.get(Water_Mark_VF))
  ui.set_visible(Water_Mark_VF_Disable_Anim, container == "VisualContainer" and ui.get(Water_Mark_VF) and not ui.get(Water_Mark_VF_Corner))
  ui.set_visible(Water_Mark_VF_Trans, container == "VisualContainer" and ui.get(Water_Mark_VF))
  ui.set_visible(Water_Mark_VF_Corner, container == "VisualContainer" and ui.get(Water_Mark_VF))
  ui.set_visible(Keybinds_VF, container == "VisualContainer")
  ui.set_visible(Keybinds_VF_Color, container == "VisualContainer" and ui.get(Keybinds_VF))
  ui.set_visible(Keybinds_VF_Disable_Anim, container == "VisualContainer" and ui.get(Keybinds_VF) and not ui.get(Keybinds_VF_Corner))
  ui.set_visible(Keybinds_VF_Trans, container == "VisualContainer" and ui.get(Keybinds_VF))
  ui.set_visible(Keybinds_VF_Corner, container == "VisualContainer" and ui.get(Keybinds_VF))
  ui.set_visible(Hitlog, container == "VisualContainer")
  ui.set_visible(HitLogs, container == "VisualContainer" and ui.get(Hitlog))
  ui.set_visible(Hitlog_Disable_Anim, container == "VisualContainer" and ui.get(Hitlog) and entitys.Contains(ui.get(HitLogs), "Under Crosshair") and not ui.get(Hitlog_Corner))
  ui.set_visible(Hitlog_Trans, container == "VisualContainer" and ui.get(Hitlog) and entitys.Contains(ui.get(HitLogs), "Under Crosshair"))
  ui.set_visible(Hitlog_Corner, container == "VisualContainer" and ui.get(Hitlog) and entitys.Contains(ui.get(HitLogs), "Under Crosshair"))
  ui.set_visible(Log_Color, container == "VisualContainer" and ui.get(Hitlog) and entitys.Contains(ui.get(HitLogs), "Under Crosshair"))
  ui.set_visible(Log_Color_Box, container == "VisualContainer" and ui.get(Hitlog) and entitys.Contains(ui.get(HitLogs), "Under Crosshair"))
  ui.set_visible(Hitlog_Gaps, container == "VisualContainer" and ui.get(Hitlog) and entitys.Contains(ui.get(HitLogs), "Under Crosshair"))
  ui.set_visible(bind_multi, false)
  ui.set_visible(Hitlog_Corner_Slider, false)
  ui.set_visible(Water_Mark_VF_Corner_Slider, false)
  ui.set_visible(Keybinds_VF_Corner_Slider, false)
end


keybind_options = { 
'Double tap', 'On shot anti-aim', 'Safe point', 'Force body aim', 'Quick peek assist', 'Duck peek assist', 'Slow motion', 'Freestanding', 'Ping spike', 'Fake peek', 'Blockbot', 'Last second defuse', 'Min Damage override'
}
bind_multi = ui.new_multiselect("AA", "Anti-aimbot angles", "Keybind options", keybind_options)

KB_Bind_State = {'Always', 'Hold', 'Toggled', 'Off-Hold'}
KB_Bind_Easing = {}
active_binds = {}


Kebind_Data = database.read('KeyBinds') or {
  x = CSSX * 0.01, 
  y = CSSY / 2,
    alpha = ui.get(Keybinds_VF) and 255 or 0,
}

MinDMG_Data = database.read('MinDMG') or {
  x = CSSX * 0.01, 
  y = CSSY / 2,
    alpha = ui.get(MinDmg_indicator) and 255 or 0,
}

KB_Binds = Create_Drag.new('KeyBinds', Kebind_Data.x, Kebind_Data.y)
MinDmg_indicator_drag = Create_Drag.new("MinDmg_indicator", MinDMG_Data.x, MinDMG_Data.y)
KB_Ease_Length = 0.125
KB_Current_Width = 15
Ref_KB = nil

HotkeyLists = {
  {Ref_KB = {ui.reference('rage','aimbot','Double tap')}, use_name = 'Double tap'},
  {Ref_KB = {ui.reference('aa','other','On shot anti-aim')}, use_name = 'On shot anti-aim'},
  {Ref_KB = {ui.reference('rage','aimbot','Force safe point')}, use_name = 'Safe point'},
  {Ref_KB = {ui.reference('rage','aimbot','Force body aim')}, use_name = 'Force body aim'},
  {Ref_KB = {ui.reference('rage','other','Quick peek assist')}, use_name = 'Quick peek assist'},
  {Ref_KB = {ui.reference('rage','other','Duck peek assist')}, use_name = 'Duck peek assist'},
  {Ref_KB = {ui.reference('aa','other','Slow motion')}, use_name = 'Slow motion'},
  {Ref_KB = {ui.reference('aa', 'Anti-aimbot angles', 'Freestanding')}, use_name = 'Freestanding'},
  {Ref_KB = {ui.reference('misc','miscellaneous','Ping spike')}, use_name = 'Ping spike'},
  {Ref_KB = {ui.reference('aa','other','Fake peek')}, use_name = 'Fake peek'},
  {Ref_KB = {ui.reference('misc','movement','Blockbot')}, use_name = 'Blockbot'},
  {Ref_KB = {ui.reference('misc','miscellaneous','Last second defuse')}, use_name = 'Last second defuse'},
  {Ref_KB = {ui.reference('rage', 'aimbot', 'Minimum damage override') }, use_name = 'Min Damage override'},
}




-- Initialization
local counter = 0

-- Animation Configuration
local gradientDuration = 2.0  -- Duration for one full color cycle
local charSpacing = 8  -- Spacing between characters



VisualsSystem = function()
    add_y = 25
    lp = entity.get_local_player()

    scoped = entity.get_prop(lp, "m_bIsScoped") == 1 and true or false
    if scoped then
        anim[4] = lerp(anim[4], -50, globals.frametime() * 50)
    else
        anim[4] = lerp(anim[4], 0, globals.frametime() * 50)
    end

    CP1R, CP1G, CP1B, CP1A = ui.get(Indic_Color1)
    CP2R, CP2G, CP2B, CP2A = ui.get(Indic_Color2)


    if ui.get(indic_switch) then

    -- Increment the animation counter
    counter = counter + 0.01

    local text = "VoltaFlame"
    local textLength = #text
    local totalWidth = textLength * charSpacing

    -- Calculate the base gradient ratio for the entire string based on time passed
    local baseGradientRatio = (math.sin(counter * math.pi / gradientDuration) + 1) / 2

    for i = 1, textLength do
        -- Adjust the gradient ratio for each character
        local charGradientRatio = baseGradientRatio + (i / textLength) * 0.05 
        charGradientRatio = charGradientRatio % 1 

        local r = CP1R + (CP2R - CP1R) * charGradientRatio
        local g = CP1G + (CP2G - CP1G) * charGradientRatio
        local b = CP1B + (CP2B - CP1B) * charGradientRatio

        -- Calculate horizontal position for each character, ensuring text is centered
        local offsetX = (i-1) * charSpacing - totalWidth / 2

        -- Render each character with its gradient
        renderer.text(IndicX - anim[4] + offsetX+2, IndicY + add_y, r, g, b, CP1A, 'cb', 0, text:sub(i, i))
    end


    add_y = add_y + 12




      DMG_Color_r, DMG_Color_g, DMG_Color_b ,DMG_Color_a = ui.get(IND_DMG_Color)
      HC_Color_r, HC_Color_g, HC_Color_b, HC_Color_a = ui.get(IND_HC_Color)




      
      desyncValue = AntiAimFunctionsLib:get_desync(2)

      if desyncValue < 0 then
        desyncValue = desyncValue + 30
      else
          desyncValue = desyncValue - 30
      end
      
      
      -- Call the renderer.gradient function
      renderer.rectangle(IndicX - anim[4] - 30, IndicY + add_y, 60, 4, 0, 0, 0, 50)
      renderer.gradient(IndicX - anim[4], IndicY + add_y, desyncValue, 4, CP2R, CP2G, CP2B, CP2A, CP1R, CP1G, CP1B, alpha, true)
      entitys.rectangle_outline(IndicX - anim[4] - 30, IndicY + add_y, 60, 4, CP1R, CP1G, CP1B, CP1A, 1)

            
      if entitys.Contains(ui.get(Indicators_Selection), "DMG") then
        add_y = add_y + 12
        if ui.get(MINDMGOVR[2]) then
          if ui.get(MINDMGOVR[3]) == 0 then
            renderer.text(IndicX -  anim[4], IndicY + add_y, DMG_Color_r, DMG_Color_g, DMG_Color_b ,DMG_Color_a , '-c', 0, "AUTO")
          else
            renderer.text(IndicX -  anim[4], IndicY + add_y, DMG_Color_r, DMG_Color_g, DMG_Color_b ,DMG_Color_a , '-c', 0, string.format("DMG:%s", ui.get(MINDMGOVR[3])))
          end
        else
      
          if ui.get(MINDMG) == 0 then
            renderer.text(IndicX -  anim[4], IndicY + add_y, DMG_Color_r, DMG_Color_g, DMG_Color_b ,DMG_Color_a , '-c', 0, "AUTO")
          else
            renderer.text(IndicX -  anim[4], IndicY + add_y, DMG_Color_r, DMG_Color_g, DMG_Color_b ,DMG_Color_a , '-c', 0, string.format("DMG:%s", ui.get(MINDMG)))
          end
        end
      end
  
      if entitys.Contains(ui.get(Indicators_Selection), "HC") then
        add_y = add_y + 12
        renderer.text(IndicX -  anim[4], IndicY + add_y, HC_Color_r, HC_Color_g, HC_Color_b, HC_Color_a, '-c', 0, string.format("HC:%s", ui.get(MINHTC)))
      end

      if ui.get(DOUBLETAP[2]) then
        add_y = add_y + 12
        if AntiAimFunctionsLib.get_double_tap() then
          renderer.text(IndicX - anim[4], IndicY + add_y, 0, 255, 0, 255,  '-c', 0,"DT")
        else
          renderer.text(IndicX - anim[4], IndicY + add_y, 255, 0, 50, 255,  '-c', 0,"DT")
        end
        
      end

      if (ui.get(HIDESHOT[1]) and ui.get(HIDESHOT[2])) then
        add_y = add_y + 12
        renderer.text(IndicX - anim[4], IndicY + add_y, 137, 174, 255, 255, '-c', 0,"HS")
      end

      if ui.get(FAKEDUCK) then
        add_y = add_y + 12
        renderer.text(IndicX - anim[4], IndicY + add_y, 227, 139, 25, 255, '-c', 0,"FD")
      end
    end


  if ui.get(ViewmodelChanger) then
    client.set_cvar("viewmodel_fov", ui.get(Viewmodel_fov))
    client.set_cvar("viewmodel_offset_x", ui.get(Viewmodel_x))
    client.set_cvar("viewmodel_offset_y", ui.get(Viewmodel_y))
    client.set_cvar("viewmodel_offset_z", ui.get(Viewmodel_z))
  end

  if ui.get(RainbowHud) then
    cvar.cl_hud_color:set_int(hudcolors[rb])
    rb = rb + 1
    if rb > 60 then
      rb = 1 
    end
  end
  


  fading = KB_Ease_Length * 255 * 50 * globals.absoluteframetime()
  MinDmgalpha = entitys.Clamp((ui.is_menu_open() and fading or -fading), 0, 255)
  if ui.get(MinDmg_indicator) then
    local pos2 = {MinDmg_indicator_drag:get()}
    local MINDRAG_X, MINDRAG_Y = pos2[1], pos2[2]
  
  
    database.write('MinDMG', {
      x = pos2[1],
      y = pos2[2],
      alpha = MinDMG_Data.alpha,
    })

    if ui.get(MINDMGOVR[2]) then
      if ui.get(MINDMGOVR[3]) == 0 then
        renderer.text(MINDRAG_X, MINDRAG_Y, 255, 255, 255, 255, "", 0, "AUTO")
      else
        renderer.text(MINDRAG_X, MINDRAG_Y, 255, 255, 255, 255, "", 0, string.format("%.0f", ui.get(MINDMGOVR[3])))
      end
    else
  
      if ui.get(MINDMG) == 0 then
        renderer.text(MINDRAG_X, MINDRAG_Y, 255, 255, 255, 255, "", 0, "AUTO")
      else
        renderer.text(MINDRAG_X, MINDRAG_Y, 255, 255, 255, 255, "", 0, string.format("%.0f", ui.get(MINDMG)))
      end
    end
    entitys.rectangle_outline(MINDRAG_X, MINDRAG_Y, 25, 25, 255, 255, 255, MinDMG_Data.alpha, 1)
  end

  if ui.get(Hitlog) then
    if entitys.Contains(ui.get(HitLogs), "Under Crosshair") then
      if #hitlog > 0 then
          if globals.tickcount() >= hitlog[1][2] then
              if hitlog[1][3] > 0 then
                  hitlog[1][3] = hitlog[1][3] - 20
              elseif hitlog[1][3] <= 0 then
                  table.remove(hitlog, 1)
              end
          end
  
          if #hitlog > 6 then
              table.remove(hitlog, 1)
          end
          Log_Color_Box_R, Log_Color_Box_G, Log_Color_Box_B, Log_Color_Box_A = ui.get(Log_Color_Box)
          local HITLOG_GAB = ui.get(Hitlog_Gaps)  -- Adjust the HITLOG_GAB between boxes
  
          for i = 1, #hitlog do
              text_size_1_x, text_size_1_y = renderer.measure_text(nil, hitlog[i][1])
              if hitlog[i][3] < 255 then 
                  hitlog[i][3] = hitlog[i][3] + 10 
              end
              
              box_width = text_size_1_x + 20
              box_height = text_size_1_y + 10
              box_x = CSSX / 2 - box_width / 2
              box_y = CSSY / 1.5 + (box_height + HITLOG_GAB) * (i - 1) - box_height / 2
  
              if ui.get(Hitlog_Corner) then
                ui.set(Hitlog_Corner_Slider, 10)
              else
                ui.set(Hitlog_Corner_Slider, 0)
              end

              
              if not ui.get(Hitlog_Trans) then
                entitys.NL_Rect(box_x, box_y, box_width, box_height, 0, 0, 0, 255, ui.get(Hitlog_Corner_Slider))
              end
              if not ui.get(Hitlog_Disable_Anim) then
                if not ui.get(Hitlog_Corner) then
                  renderer.gradient(box_x, box_y, box_width, box_height, Log_Color_Box_R, Log_Color_Box_G, Log_Color_Box_B, alpha2, Log_Color_Box_R, Log_Color_Box_G, Log_Color_Box_B, alpha, true)
                end
              end 

              entitys.NL_Rect_Outline(box_x, box_y, box_width, box_height, Log_Color_Box_R, Log_Color_Box_G, Log_Color_Box_B, Log_Color_Box_A, ui.get(Hitlog_Corner_Slider))
  
              local text_x = box_x + box_width / 2
              local text_y = box_y + box_height / 2


              renderer.text(text_x, text_y, 255, 255, 255, hitlog[i][3], "c", 0, hitlog[i][1])
          end
       end
    end
  end
  


  WM_R, WM_G, WM_B, WM_A = ui.get(Water_Mark_VF_Color)

  if ui.get(Water_Mark_VF) then
    local latency = math.floor(client.latency()*1000+0.5)
    local tickrate = 1/globals.tickinterval()
    local hours, minutes, seconds = client.system_time()
  
  
    local text = "VoltaFlame".." | ".. LUA_TYPE .. " | " ..LUA_BUILD.. " | " .. string.format("%sms", latency) ..  " | " .. string.format("%02s:%02s", hours, minutes)
   
    -- modify these to change how the text appears. margin is the distance from the top right corner, padding is the size the background rectangle is larger than the text
    local margin, padding, flags = 18, 4, "b"
  
    -- uncomment this for a "small and capital" style
    -- flags, text = "-", (text:upper():gsub(" ", "   "))
  
    -- measure text size to properly offset the text from the top right corner
    local text_width, text_height = renderer.measure_text(flags, text)
  
    -- draw background and text(x, y, w, h, r, g, b, a, s)
    if ui.get(Water_Mark_VF_Corner) then
      ui.set(Water_Mark_VF_Corner_Slider, 10)
    else
      ui.set(Water_Mark_VF_Corner_Slider, 0)
    end

      if not ui.get(Water_Mark_VF_Trans) then
        entitys.NL_Rect(CSSX-text_width-margin-padding, margin-padding, text_width+padding*2, text_height+padding*2, 0, 0, 0, 255, ui.get(Water_Mark_VF_Corner_Slider))
      end
      if not ui.get(Water_Mark_VF_Disable_Anim) then
        if not ui.get(Water_Mark_VF_Corner) then
          renderer.gradient(CSSX-text_width-margin-padding, margin-padding, text_width+padding*2, text_height+padding*2, WM_R, WM_G, WM_B, alpha2, WM_R, WM_G, WM_B, alpha, true)
        end
      end 
      entitys.NL_Rect_Outline(CSSX-text_width-margin-padding, margin-padding, text_width+padding*2, text_height+padding*2, WM_R, WM_G, WM_B, WM_A, ui.get(Water_Mark_VF_Corner_Slider))
      renderer.text(CSSX-text_width-margin, margin, 255, 255, 255, 255, flags, 0, text)
      --renderer.rectangle(CSSX-text_width-margin-padding, margin-padding, text_width+padding*2, text_height+padding*2, 0, 0, 0, 255)
      --renderer.gradient(CSSX-text_width-margin-padding, margin-padding, text_width+padding*2, text_height+padding*2, WM_R, WM_G, WM_B, alpha2, WM_R, WM_G, WM_B, alpha, true)
      --entitys.rectangle_outline(CSSX-text_width-margin-padding, margin-padding, text_width+padding*2, text_height+padding*2, WM_R, WM_G, WM_B, WM_A, 1)
      --renderer.text(CSSX-text_width-margin, margin, 255, 255, 255, 255, flags, 0, text)

  end


  --keybinds
  ui.set(bind_multi, keybind_options)

    local pos = {KB_Binds:get()}
    local bx, by = pos[1], pos[2]
    local bw, bh = 210, 25
    local pad = 5
  
    database.write('KeyBinds', {
      x = pos[1],
      y = pos[2],
        alpha = Kebind_Data.alpha,
    })
  
    for i, bind in ipairs(HotkeyLists) do
        local hotkey_ind = entitys.get_hotkey_index(bind.Ref_KB)
        local bind_hk = {ui.get(bind.Ref_KB[hotkey_ind[2]])}
        active_binds[bind.use_name] = {bind.use_name, KB_Bind_State[bind_hk[2] + 1], bind_hk[1] and hotkey_ind[1], -1}
        if (bind_hk[1] and hotkey_ind[1]) and not KB_Bind_Easing[bind.use_name] then
            KB_Bind_Easing[bind.use_name] = {0, 0}
        end
    end
  
  
    local total_active = 0
    for j = 1, #keybind_options do
        local bind = active_binds[keybind_options[j]]
        local bind_name = bind[1]
        if entitys.Contains(ui.get(bind_multi), bind_name) and (bind[3] or (KB_Bind_Easing[bind_name] and KB_Bind_Easing[bind_name][1] > 0)) then
            total_active = total_active + 1
        end
    end
  
  if ui.get(Keybinds_VF) then
    Kebind_Data.alpha = entitys.Clamp(Kebind_Data.alpha + ((ui.is_menu_open() or (entity.is_alive(entity.get_local_player()) and total_active > 0)) and fading or -fading), 0, 255)
  
    local base_sizex, base_sizey = renderer.measure_text(nil, "Keybinds")
    if Kebind_Data.alpha > 1 then
        local KB_R, KB_G, KB_B = ui.get(Keybinds_VF_Color)
  
        local i, y_offset, desire_w = 1, 0, base_sizex * 1.5
        for j = 1, #keybind_options do
            local bind = active_binds[keybind_options[j]]
            local bind_name = bind[1]
            if entitys.Contains(ui.get(bind_multi), bind_name) and (bind[3] or (KB_Bind_Easing[bind_name] and KB_Bind_Easing[bind_name][1] > 0)) then
                local line_y = by + bh + y_offset
                local base_x = bx
                local b_alpha = KB_Bind_Easing[bind_name][1] * 255
  
                local partial = ("\a%02x%02x%02x%02x"):format(KB_R, KB_G, KB_B, b_alpha)
                renderer.text(base_x + (KB_Current_Width * 0.5), line_y, 215, 215, 215, b_alpha, "c", 0, bind_name .. " - ".. partial .. bind[2])
  
                local m_w, m_h = renderer.measure_text(nil, bind_name .. " - " .. bind[2])
                y_offset = y_offset + m_h
                desire_w = math.max(desire_w, m_w)
  
                KB_Bind_Easing[bind_name][1] = bind[3] and easing.quad_out(KB_Bind_Easing[bind_name][2], 0, 1, KB_Ease_Length) or easing.quad_out(KB_Ease_Length - KB_Bind_Easing[bind_name][2], 1, -1, KB_Ease_Length)
                KB_Bind_Easing[bind_name][1] = entitys.Clamp(KB_Bind_Easing[bind_name][1], 0, 1)
  
                KB_Bind_Easing[bind_name][2] = bind[3] and KB_Bind_Easing[bind_name][2] + globals.absoluteframetime() or KB_Bind_Easing[bind_name][2] - globals.absoluteframetime()
                KB_Bind_Easing[bind_name][2] = entitys.Clamp(KB_Bind_Easing[bind_name][2], 0, KB_Ease_Length)
                i = i + 1
            end
        end
  
        if desire_w - KB_Current_Width > 0 then
            KB_Current_Width =  entitys.Clamp(KB_Current_Width + (globals.absoluteframetime() * 200), base_sizex * 1.5, desire_w)
        else
            KB_Current_Width =  entitys.Clamp(KB_Current_Width - (globals.absoluteframetime() * 200), desire_w, math.huge)
        end
        if ui.get(Keybinds_VF_Corner) then
          ui.set(Keybinds_VF_Corner_Slider, 10)
        else
          ui.set(Keybinds_VF_Corner_Slider, 0)
        end

        if not ui.get(Keybinds_VF_Trans) then
          entitys.NL_Rect(bx, by, math.floor(KB_Current_Width), base_sizey * 1.5, 0, 0, 0, 255, ui.get(Keybinds_VF_Corner_Slider))
        end
        if not ui.get(Keybinds_VF_Disable_Anim) then
          if not ui.get(Keybinds_VF_Corner) then
            renderer.gradient(bx, by, math.floor(KB_Current_Width), base_sizey * 1.5, KB_R, KB_G, KB_B, alpha2, KB_R, KB_G, KB_B, alpha, true)
          end
        end 

        entitys.NL_Rect_Outline(bx, by, math.floor(KB_Current_Width), base_sizey * 1.5, KB_R, KB_G, KB_B, Kebind_Data.alpha, ui.get(Keybinds_VF_Corner_Slider))
        renderer.text(bx + (KB_Current_Width * 0.5), by + (base_sizey * 0.68), 255, 255, 255, Kebind_Data.alpha, "c", 0, "Keybinds")
    end
    if ui.get(DragSelection) == "Keybinds" then
      KB_Binds:drag(KB_Current_Width * 1.5, base_sizey * 2)
    elseif ui.get(DragSelection) == "MinDMG" then
      MinDmg_indicator_drag:drag(25 , 25)
    end
  end
end

hitlog = {}
id = 1
hitgroup_names = {'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', '?', 'Gear'}
client.set_event_callback("aim_hit", function(e)
  Log_Color_R, Log_Color_G, Log_Color_B = ui.get(Log_Color)
  Hex_Log_Color = entitys.RGBtoHEX(Log_Color_R, Log_Color_G, Log_Color_B)
  

 Hl_HitGroup = hitgroup_names[e.hitgroup + 1] or "?"
 Hl_Name = string.lower(entity.get_player_name(e.target))
 Hl_Target = e.target
 HI_DMG = e.damage
 Hl_Reason = e.reason

  if ui.get(Hitlog) then
      if entitys.Contains(ui.get(HitLogs), "Under Crosshair") then 
          hitlog[#hitlog+1] = {("\aFFFFFFFFShot At ".."\a"..Hex_Log_Color.."%s \aFFFFFFFFOn His ".."\a"..Hex_Log_Color.."%s \aFFFFFFFFfor ".."\a"..Hex_Log_Color.."%s \aFFFFFFFFHP!"):format(Hl_Name, Hl_HitGroup, HI_DMG), globals.tickcount() + 250, 0}
          id = id == 999 and 1 or id + 1 
    end
    if entitys.Contains(ui.get(HitLogs), "Console") then
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, "Shot At "..string.lower(entity.get_player_name(e.target)).." On His "..hitgroup_names[e.hitgroup + 1] .." For "..e.damage.." HP!")
    end
  end


end)

client.set_event_callback("aim_miss", function(e)

  Log_Color_R, Log_Color_G, Log_Color_B = ui.get(Log_Color)
  Hex_Log_Color = entitys.RGBtoHEX(Log_Color_R, Log_Color_G, Log_Color_B)

 Hl_HitGroup = hitgroup_names[e.hitgroup + 1] or "?"
 Hl_Name = string.lower(entity.get_player_name(e.target))
 Hl_Target = e.target
 HI_DMG = e.damage
 Hl_Reason = e.reason

     if e.reason ~= "?" then
      return
    end

    if ui.get(Hitlog) then
      if entitys.Contains(ui.get(HitLogs), "Under Crosshair") then 

          hitlog[#hitlog+1] = {("\aFFFFFFFFMiss Shot At ".."\a"..Hex_Log_Color.."%s \aFFFFFFFFOn His ".."\a"..Hex_Log_Color.."%s \aFFFFFFFFFor ".."\a"..Hex_Log_Color.."%s \aFFFFFFFFHP Due To ".."\a"..Hex_Log_Color.."%s \aFFFFFFFF!"):format(Hl_Name, Hl_HitGroup, HI_DMG, Hl_Reason), globals.tickcount() + 250, 0}
        id = id == 999 and 1 or id + 1 
      end
      if entitys.Contains(ui.get(HitLogs), "Console") then

          client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
          client.color_log(255, 255, 255, "Miss Shot At "..string.lower(entity.get_player_name(e.target)).." On His "..hitgroup_names[e.hitgroup + 1].." HP Due To "..e.reason.." !")

      end
    end

    
end)



--misc
--fast ladder
FastLadder = ui.new_checkbox("AA", "Anti-aimbot angles","Fast Ladder")
--fps booster
FpsBoost = ui.new_checkbox("AA", "Anti-aimbot angles", "FPS Boost (Disabling It Will Requires Restart)")

--buybot
Buybot = ui.new_checkbox("AA", "Anti-aimbot angles", "Buybot")
PrimaryWeapon = ui.new_combobox("AA", "Anti-aimbot angles", "Primary Weapon",{"-", "AWP", "SCAR20/G3SG1", "SSG-08"})
SecondaryWeapon = ui.new_combobox("AA", "Anti-aimbot angles", "Secondary Weapon",{"-", "CZ75/Tec9/FiveSeven", "P250", "Deagle/Revolver", "Dualies"})
Grenades = ui.new_multiselect("AA", "Anti-aimbot angles", "Grenades",{"HE Grenade", "Molotov", "Smoke", "Flash", "Decoy"})
Utilities = ui.new_multiselect("AA", "Anti-aimbot angles", "Utilities",{"Armor", "Helmet", "Zeus", "Defuser"})



MiscSystemRenderer = function()
  ui.set_visible(FpsBoost, container == "MiscContainer")
  ui.set_visible(Buybot, container == "MiscContainer")
  ui.set_visible(FastLadder, container == "MiscContainer")
  ui.set_visible(PrimaryWeapon, container == "MiscContainer" and ui.get(Buybot))
  ui.set_visible(SecondaryWeapon, container == "MiscContainer" and ui.get(Buybot))
  ui.set_visible(Grenades, container == "MiscContainer" and ui.get(Buybot))
  ui.set_visible(Utilities, container == "MiscContainer" and ui.get(Buybot))
  menu_ui()
  ui.set_visible(NameSpammer, container == "MiscContainer")
  ui.set_visible(NameSpammer_InputText, container == "MiscContainer" and ui.get(NameSpammer))
  ui.set_visible(NameSpammer_Input, container == "MiscContainer" and ui.get(NameSpammer))
  ui.set_visible(NameSpammer_Button, container == "MiscContainer" and ui.get(NameSpammer))

end
pitch, yaw = client.camera_angles()


client.set_event_callback("setup_command", function(e)
  lp = entity.get_local_player()
  wpn = entity.get_player_weapon(lp)
  ThrowT = entity.get_prop(wpn, 'm_fThrowTime')
  pitch, yaw = client.camera_angles()
  if ui.get(FastLadder) then
    if lp == nil or entity.get_prop(lp, 'm_MoveType') ~= 9 then
        return
    end
    if wpn == nil then
        return
    end
    if ThrowT ~= nil and ThrowT ~= 0 then
        return
    end

    e.yaw = math.floor(e.yaw+0.5)
    e.roll = 0

    if e.pitch < 45 then
      e.pitch = 89
      e.in_moveright = 1
      e.in_moveleft = 0 
      e.in_forward = 0
      e.in_back = 1
      if e.sidemove == 0 then
        e.yaw = e.yaw + 90
      end
      if e.sidemove < 0 then
        e.yaw = e.yaw + 150
      end
      if e.sidemove > 0 then
        e.yaw = e.yaw + 30
      end
    end
  end
end)














FpsBoostSystem = function()
  if ui.get(FpsBoost) then
    cvar.cl_disablefreezecam:set_float(1)
    cvar.cl_disablehtmlmotd:set_float(1)
    cvar.r_dynamic:set_float(0)
    cvar.r_3dsky:set_float(0)
    cvar.r_shadows:set_float(0)
    cvar.cl_csm_static_prop_shadows:set_float(0)
    cvar.cl_csm_world_shadows:set_float(0)
    cvar.cl_foot_contact_shadows:set_float(0)
    cvar.cl_csm_viewmodel_shadows:set_float(0)
    cvar.cl_csm_rope_shadows:set_float(0)
    cvar.cl_csm_sprite_shadows:set_float(0)
    cvar.cl_freezecampanel_position_dynamic:set_float(0)
    cvar.cl_freezecameffects_showholiday:set_float(0)
    cvar.cl_showhelp:set_float(0)
    cvar.cl_autohelp:set_float(0)
    cvar.mat_postprocess_enable:set_float(0)
    cvar.fog_enable_water_fog:set_float(0)
    cvar.gameinstructor_enable:set_float(0)
    cvar.cl_csm_world_shadows_in_viewmodelcascade:set_float(0)
    cvar.cl_disable_ragdolls:set_float(0)
  end
end

MiscSystem = function()
  FpsBoostSystem()
end



-- Clantag Changer

local CT_Tag = {}
local function DoAnimation(CT_Tag, CT_Animation)
    local CT_Old = nil
    local CT_Anim = {}

    if CT_Animation == 2 then
        return {CT_Tag}
    elseif CT_Animation == 1 then
        for i in CT_Tag:gmatch(".") do
            if CT_Old == nil then
                table.insert(CT_Anim, i)
                CT_Old = i
            else
                table.insert(CT_Anim, CT_Old .. i)
                CT_Old = CT_Old .. i
            end
        end

        for i in CT_Tag:gmatch(".") do
            table.insert(CT_Anim, CT_Old)
            CT_Old = string.gsub(CT_Old, i, "", 1)
        end

        table.insert(CT_Anim, "")
        return CT_Anim
    elseif CT_Animation == 4 then
        if CT_Old == nil then
            table.insert(CT_Anim, CT_Tag)
            CT_Old = CT_Tag .. " "
        end

        for i in CT_Tag:gmatch(".") do
            table.insert(CT_Anim, CT_Old:gsub(i, "", 1) .. i)
            CT_Old = CT_Old:gsub(i, "", 1) .. i
        end
        return CT_Anim
    else
        local TG = CT_Tag:reverse()
        for i in TG:gmatch(".") do
            if CT_Old == nil then
                table.insert(CT_Anim, i)
                CT_Old = i
            else
                table.insert(CT_Anim, i .. CT_Old)
                CT_Old = i .. CT_Old
            end
        end

        for i in CT_Tag:gmatch(".") do
            table.insert(CT_Anim, CT_Old)
            CT_Old = string.gsub(CT_Old, i, "", 1)
        end

        table.insert(CT_Anim, "")
        return CT_Anim
    end
end
--clantag
CustomClantag = ui.new_checkbox("AA", "Anti-aimbot angles","Custom Clantag")
Clantag_Type = ui.new_combobox("AA", "Anti-aimbot angles", "Clantag Type", {"Voltaflame"})
Clantag_InputText = ui.new_label("AA", "Anti-aimbot angles", "Clantag Input: ")
Clantag_input = ui.new_textbox("AA", "Anti-aimbot angles", "Clantag Input")
Clantag_AnimationType_Combo = ui.new_combobox("AA", "Anti-aimbot angles", "Clantag Type", {"Normal", "Static", "Roll", "Reverse"})
Clantag_AnimationType = ui.new_slider("AA", "Anti-aimbot angles", "ClanTag Modes", 1, 4, 1)
Clantag_AnimationSpeed = ui.new_slider("AA", "Anti-aimbot angles", "ClanTag Speed", 1, 100, 50)

Clantag_Options = ui.new_multiselect("AA", "Anti-aimbot angles", "Other Clantag_Options", {"Invisible Name", "Prefix", "Suffix"})
Clantag_PrefixText = ui.new_label("AA", "Anti-aimbot angles", "Clantag Prefix: ")
Clantag_PrefixInput = ui.new_textbox("AA", "Anti-aimbot angles", "Prefix")
Clantag_SuffixText = ui.new_label("AA", "Anti-aimbot angles", "Clantag Suffix: ")
Clantag_SuffixInput = ui.new_textbox("AA", "Anti-aimbot angles", "Suffix")

Clantag_AnimationConsole = ui.new_button("AA", "Anti-aimbot angles", "View ClanTag Animation In Console", function()
  if ui.get(Clantag_Type) == "Custom" then
    CreatedAnimation = DoAnimation(ui.get(Clantag_input), ui.get(Clantag_AnimationType))
  else
    CreatedAnimation = DoAnimation("VoltaFlame", ui.get(Clantag_AnimationType))
  end
  client.log("\aEKD1FF[VoltaFlame]", "ClanTag ANIMATION:")
  for k, v in ipairs(CreatedAnimation) do
      client.log("[" .. k .. "] " .. v)
  end
end)




function menu_ui()
  ui.set_visible(CustomClantag, container == "MiscContainer")
  ui.set_visible(Clantag_Type, container == "MiscContainer" and ui.get(CustomClantag))
  ui.set_visible(Clantag_InputText, container == "MiscContainer" and ui.get(CustomClantag) and ui.get(Clantag_Type) == "Custom")
  ui.set_visible(Clantag_AnimationType, false)
  ui.set_visible(Clantag_AnimationType_Combo, container == "MiscContainer" and ui.get(CustomClantag))
  ui.set_visible(Clantag_input, container == "MiscContainer" and ui.get(CustomClantag) and ui.get(Clantag_Type) == "Custom")
  ui.set_visible(Clantag_AnimationSpeed, container == "MiscContainer" and ui.get(CustomClantag) and ui.get(Clantag_AnimationType) ~= 2)
  ui.set_visible(Clantag_AnimationConsole, container == "MiscContainer" and ui.get(CustomClantag) and ui.get(Clantag_AnimationType) ~= 2 and ui.get(Clantag_Type) == "Custom")
  ui.set_visible(Clantag_Options, container == "MiscContainer" and ui.get(CustomClantag) and ui.get(Clantag_Type) == "Custom")
  ui.set_visible(Clantag_SuffixText, container == "MiscContainer" and ui.get(CustomClantag) and entitys.Contains(ui.get(Clantag_Options), "Suffix") and ui.get(Clantag_Type) == "Custom")
  ui.set_visible(Clantag_SuffixInput, container == "MiscContainer" and ui.get(CustomClantag) and entitys.Contains(ui.get(Clantag_Options), "Suffix") and ui.get(Clantag_Type) == "Custom")
  ui.set_visible(Clantag_PrefixText, container == "MiscContainer" and ui.get(CustomClantag) and entitys.Contains(ui.get(Clantag_Options), "Prefix") and ui.get(Clantag_Type) == "Custom")
  ui.set_visible(Clantag_PrefixInput, container == "MiscContainer" and ui.get(CustomClantag) and entitys.Contains(ui.get(Clantag_Options), "Prefix") and ui.get(Clantag_Type) == "Custom")

  if ui.get(Clantag_AnimationType_Combo) == "Normal" then 
    ui.set(Clantag_AnimationType, 1)
  elseif ui.get(Clantag_AnimationType_Combo) == "Static" then 
    ui.set(Clantag_AnimationType, 2)
  elseif ui.get(Clantag_AnimationType_Combo) == "Roll" then 
    ui.set(Clantag_AnimationType, 3)
  elseif ui.get(Clantag_AnimationType_Combo) == "Reverse" then 
    ui.set(Clantag_AnimationType, 4)
  end

  if not ui.get(CustomClantag) then
    client.set_clan_tag("")

  end
end


CT_OldTime = nil
client.set_event_callback("paint", function()

    if ui.get(CustomClantag) then
      if ui.get(Clantag_AnimationType) == 2 then
        local Clantag_HideName = ""
        local Clantag_Suffix = ""
        local Clantag_Prefix = ""
        if entitys.Contains(ui.get(Clantag_Options), "Invisible Name") then
            Clantag_HideName = "\n"
        end
        if entitys.Contains(ui.get(Clantag_Options), "Suffix") then
            Clantag_Suffix = ui.get(Clantag_SuffixInput)
        end
        if entitys.Contains(ui.get(Clantag_Options), "Prefix") then
            Clantag_Prefix = ui.get(Clantag_PrefixInput)
        end
        if ui.get(Clantag_Type) == "Custom" then
          client.set_clan_tag(Clantag_Prefix .. "VoltaFlame" .. Clantag_Suffix .. Clantag_HideName)
        else
          client.set_clan_tag(Clantag_Prefix .. "VoltaFlame" .. Clantag_Suffix .. Clantag_HideName)
        end
        
        return
      end
      if ui.get(Clantag_Type) == "Custom" then
        CT_Tag = DoAnimation(ui.get(Clantag_input), ui.get(Clantag_AnimationType))
      else
        CT_Tag = DoAnimation("VoltaFlame", ui.get(Clantag_AnimationType))
      end

        if ui.get(Clantag_AnimationType) == 2 then
            return
        end


        local curtime = math.floor(globals.curtime())
        local speed = ui.get(Clantag_AnimationSpeed)
        local latency = client.latency() / globals.tickinterval()
        local tickcount_ = globals.tickcount() + latency

        local Clantag_HideName = ""
        local Clantag_Suffix = ""
        local Clantag_Prefix = ""
        if entitys.Contains(ui.get(Clantag_Options), "Invisible Name") then
            Clantag_HideName = "\n"
        end
        if entitys.Contains(ui.get(Clantag_Options), "Suffix") then
            Clantag_Suffix = ui.get(Clantag_SuffixInput)
        end
        if entitys.Contains(ui.get(Clantag_Options), "Prefix") then
            Clantag_Prefix = ui.get(Clantag_PrefixInput)
        end

        CT_iter = #CT_Tag > 1 and math.floor(math.fmod(tickcount_ / speed, #CT_Tag)) + 1 or #CT_Tag

        if CT_OldTime ~= curtime then
            client.set_clan_tag(Clantag_Prefix .. CT_Tag[CT_iter] .. Clantag_Suffix .. Clantag_HideName)
        end
        CT_OldTime = curtime
    end
end)

--name spammer
function DoNameSpam(N_Delay, N_Name)
  client.delay_call(N_Delay, function()
    client.set_cvar("name", N_Name)
  end)
end

NameSpammer = ui.new_checkbox("AA", "Anti-aimbot angles", "Name Spammer")
NameSpammer_InputText = ui.new_label("AA", "Anti-aimbot angles", "Name:")
NameSpammer_Input = ui.new_textbox("AA", "Anti-aimbot angles", "Name")
NameSpammer_Button = ui.new_button("AA", "Anti-aimbot angles", "Name Spam!", function()
  if ui.get(NameSpammer) then
      NameSpammer_Input_1 = nil
      NameSpammer_Input_2 = nil
      ui.set(NAMESTEAL, true)
      NameSpammer_Input_1 = ui.get(NameSpammer_Input)
      NameSpammer_Input_2 = NameSpammer_Input_1.."​"
      client.set_cvar("name", NameSpammer_Input_1)
      DoNameSpam(0.1, NameSpammer_Input_2)
      DoNameSpam(0.2, NameSpammer_Input_1)
      DoNameSpam(0.3, NameSpammer_Input_2)
      DoNameSpam(0.4, NameSpammer_Input_1)
  end
end)





BuyBotSystem = function(e)

  --Primary
  if ui.get(Buybot) then
    if ui.get(PrimaryWeapon) == "AWP" then
      client.exec("buy awp;")
    end
    if ui.get(PrimaryWeapon) == "SCAR20/G3SG1" then
      client.exec("buy scar20;")
    end
    if ui.get(PrimaryWeapon) == "SSG-08" then
      client.exec("buy ssg08;")
    end
    --Secondary
    if ui.get(SecondaryWeapon) == "CZ75/Tec9/FiveSeven" then
      client.exec("buy tec9;")
    end
    if ui.get(SecondaryWeapon) == "P250" then
      client.exec("buy p250;")
    end
    if ui.get(SecondaryWeapon) == "Deagle/Revolver" then
      client.exec("buy deagle;")
    end
    if ui.get(SecondaryWeapon) == "Dualies" then
      client.exec("buy elite;")
    end
    --Grenades
    if entitys.Contains(ui.get(Grenades), "HE Grenade") then
      client.exec("buy hegrenade;")
    end
    if entitys.Contains(ui.get(Grenades), "Molotov")  then
      client.exec("buy molotov;")
    end
    if entitys.Contains(ui.get(Grenades), "Smoke") then
      client.exec("buy smokegrenade;")
    end
    if entitys.Contains(ui.get(Grenades), "Flash") then
      client.exec("buy flashbang;")
    end
    if entitys.Contains(ui.get(Grenades), "Decoy") then
      client.exec("buy decoy;")
    end
    --Utilities
    if entitys.Contains(ui.get(Utilities), "Armor") then
      client.exec("buy vest;")
    end
    if entitys.Contains(ui.get(Utilities), "Helmet") then
      client.exec("buy vesthelm;")
    end
    if entitys.Contains(ui.get(Utilities), "Zeus") then
      client.exec("buy taser 34;")
    end
    if entitys.Contains(ui.get(Utilities), "Defuser") then
      client.exec("buy defuser;")
    end
  end
  
end

config_data = {
  booleans = { 
    S_Override,
    S_Pitch, 
    S_PitchLeftSlider, 
    S_PitchRightSlider, 
    S_YawBase,
    S_Yaw, 
    S_YawLeftSlider, 
    S_YawRightSlider,
    S_YawJitter, 
    S_YawJitterDelaySlider, 
    S_YawJitterLeftSlider, 
    S_YawJitterRightSlider, 
    S_BodyYaw,
    S_BodyYawLeftSlider,
    S_BodyYawRightSlider, 
    S_BodyYawFreestanding,
    M_Override,
    M_Pitch, 
    M_PitchLeftSlider, 
    M_PitchRightSlider, 
    M_YawBase,
    M_Yaw, 
    M_YawLeftSlider, 
    M_YawRightSlider,
    M_YawJitter, 
    M_YawJitterDelaySlider, 
    M_YawJitterLeftSlider, 
    M_YawJitterRightSlider, 
    M_BodyYaw,
    M_BodyYawLeftSlider,
    M_BodyYawRightSlider, 
    M_BodyYawFreestanding,
    J_Override,
    J_Pitch, 
    J_PitchLeftSlider, 
    J_PitchRightSlider, 
    J_YawBase,
    J_Yaw, 
    J_YawLeftSlider, 
    J_YawRightSlider,
    J_YawJitter, 
    J_YawJitterDelaySlider, 
    J_YawJitterLeftSlider, 
    J_YawJitterRightSlider, 
    J_BodyYaw,
    J_BodyYawLeftSlider,
    J_BodyYawRightSlider, 
    J_BodyYawFreestanding,
    C_Override,
    C_Pitch, 
    C_PitchLeftSlider, 
    C_PitchRightSlider, 
    C_YawBase,
    C_Yaw, 
    C_YawLeftSlider, 
    C_YawRightSlider,
    C_YawJitter, 
    C_YawJitterDelaySlider, 
    C_YawJitterLeftSlider, 
    C_YawJitterRightSlider, 
    C_BodyYaw,
    C_BodyYawLeftSlider,
    C_BodyYawRightSlider, 
    C_BodyYawFreestanding,
    CA_Override,
    CA_Pitch, 
    CA_PitchLeftSlider, 
    CA_PitchRightSlider, 
    CA_YawBase,
    CA_Yaw, 
    CA_YawLeftSlider, 
    CA_YawRightSlider,
    CA_YawJitter, 
    CA_YawJitterDelaySlider, 
    CA_YawJitterLeftSlider, 
    CA_YawJitterRightSlider, 
    CA_BodyYaw,
    CA_BodyYawLeftSlider,
    CA_BodyYawRightSlider, 
    CA_BodyYawFreestanding,
    SW_Override,
    SW_Pitch, 
    SW_PitchLeftSlider, 
    SW_PitchRightSlider, 
    SW_YawBase,
    SW_Yaw, 
    SW_YawLeftSlider, 
    SW_YawRightSlider,
    SW_YawJitter, 
    SW_YawJitterDelaySlider, 
    SW_YawJitterLeftSlider, 
    SW_YawJitterRightSlider, 
    SW_BodyYaw,
    SW_BodyYawLeftSlider,
    SW_BodyYawRightSlider, 
    SW_BodyYawFreestanding,
    SW_DefensiveAA_Yaw,
    SW_DefensiveAA_Pitch,
    CA_DefensiveAA_Yaw,
    CA_DefensiveAA_Pitch,
    C_DefensiveAA_Yaw,
    C_DefensiveAA_Pitch,
    J_DefensiveAA_Yaw,
    J_DefensiveAA_Pitch,
    M_DefensiveAA_Yaw,
    M_DefensiveAA_Pitch,
    S_DefensiveAA_Pitch,
    S_DefensiveAA_Yaw,
    SW_SwitchDelay,
    CA_SwitchDelay,
    C_SwitchDelay,
    J_SwitchDelay,
    M_SwitchDelay,
    S_SwitchDelay,
    Hitchance_Customization,
    NoScope_Customization_Weapons ,
    InAir_Customization_Weapons ,
    Scout_InAirHitchance_Value ,
    Scout_NoScopeHitchance_Value,
    AWP_InAirHitchance_Value,
    AWP_NoScopeHitchance_Value,
    Auto_InAirHitchance_Value,
    Auto_NoScopeHitchance_Value,
    R8_InAirHitchance_Value,
    CustomTickControl,
    CustomTickControl_Value,
    VFR_Resolver_B,
    RS_logs,
    Force_BY_Resolver,
    CorrectionActive_Resolver,
    Extendedbacktrack,
    Auto_Teleprt_InAirOnly,
    BreakLagComp, 
    Anim_Breaker, 
    Anim_Breaker_Selection, 
    Lua_BetterFakeLag,
    Lua_BetterFakeLagValue, 
    DisableFkOnSituauins,
    SituationsOfDisbaleFL, 
    CustomSlowWalk, 
    CustomSlowWalk_Delay,
    CustomSlowWalk_Value_1,
    CustomSlowWalk_Value_2,
    CustomSlowWalk_Value_Real, 
    ManualYaw, 
    ManualYawLeanYaw,
    Anti_knife,
    StatisAAOnZeus, 
    DisableOnWarmup,
    AAmode, 
    SelectionTabForCustom,
    indic_switch,
    Hitlog_Disable_Anim,
    Hitlog_Trans,
    Hitlog_Corner,
    Keybinds_VF_Disable_Anim,
    Keybinds_VF_Trans,
    Keybinds_VF_Corner,
    Water_Mark_VF_Disable_Anim,
    Water_Mark_VF_Trans,
    Water_Mark_VF_Corner,
    MinDmg_indicator,
    ViewmodelChanger, 
    Viewmodel_fov,
    Viewmodel_x,
    Viewmodel_y,
    Viewmodel_z,
    RainbowHud,
    Water_Mark_VF,
    Keybinds_VF,
    HitLogs,
    Hitlog_Gaps, 
    FastLadder, 
    FpsBoost,
    Buybot,
    PrimaryWeapon,
    SecondaryWeapon, 
    Grenades,
    Utilities,
    CustomClantag, 
    Clantag_Type,
    Clantag_input,
    Clantag_AnimationType_Combo, 
    Clantag_AnimationSpeed, 
    Clantag_Options,
    Animation_Rainbow,
    Rainbow_Color_Selection,
    Animation_Speed_Rainbow,
    Animation_Speed_1,
    Animation_Speed_2,
    BreakLagComp_Selection,
  },

  colorscodes = {
    Indic_Color1,
    Indic_Color2, 
    Log_Color, 
    Log_Color_Box, 
    Water_Mark_VF_Color, 
    Keybinds_VF_Color, 
    
  }
}


function import(cfg)
  status, config = pcall(function() return json.parse(base64.decode(cfg)) end)

  if not status or status == nil then
    client.color_log(255, 0, 0, "[Voltaflame] \0")
    client.color_log(255, 255, 255,"The Code Is Invalid Or Outdated!")
  return end

  for k, v in pairs(config) do

          k = ({[1] = "booleans", [2] = "colorscodes"})[k]

          for k2, v2 in pairs(v) do
              if (k == "booleans") then
                  ui.set(config_data[k][k2], (v2))
              end

              if (k == "colorscodes") then
                col_r, col_g, col_b, col_a = tonumber('0x'..v2:sub(1,2)), tonumber('0x'..v2:sub(3,4)), tonumber('0x'..v2:sub(5, 6)), tonumber('0x'..v2:sub(7,8))
                ui.set(config_data[k][k2], col_r, col_g, col_b, col_a)
              end
        end
  end
  client.color_log(0, 255, 0, "[Voltaflame] \0")
      client.color_log(255, 255, 255,"Config Imported!")
end

Default_CFG = ui.new_button("AA", "Anti-aimbot angles", "Load Default Preset", function()
   import("W1t0cnVlLCJEb3duIiwwLDAsIkF0IFRhcmdldHMiLCJEZWZlbnNpdmUiLC0yMSwxOSwiU2tpdHRlciIsNSw3LC0xMiwiQW50aS1CcnV0ZWZvcmNlIiwyOCwtMjQsdHJ1ZSx0cnVlLCJEb3duIiwwLDAsIkF0IFRhcmdldHMiLCIxODAgWiIsLTcsNywiU2tpdHRlciIsMiwxNiwtMTQsIkppdHRlciIsMywtNSx0cnVlLHRydWUsIkRlZmVuc2l2ZSIsODksLTg5LCJBdCBUYXJnZXRzIiwiRGVmZW5zaXZlIiw0MCwtMzUsIlJhbmRvbSIsMiwtMTQsMTQsIkppdHRlciIsMzAsLTE5LHRydWUsdHJ1ZSwiTWluaW1hbCIsMCwwLCJBdCBUYXJnZXRzIiwiRGVmZW5zaXZlIiw3LC03LCJPZmZzZXQiLDIsNywtMywiQW50aS1CcnV0ZWZvcmNlIiwtOCw3LHRydWUsdHJ1ZSwiRG93biIsMCwwLCJBdCBUYXJnZXRzIiwiU3BpbiIsMjEsLTM1LCJSYW5kb20iLDMsLTIyLDI0LCJPcHBvc2l0ZSIsMCwwLGZhbHNlLHRydWUsIkRvd24iLDAsMCwiQXQgVGFyZ2V0cyIsIkRlZmVuc2l2ZSIsLTE2LDIzLCJDZW50ZXIiLDMsMTAsLTEwLCJKaXR0ZXIiLDI0LC0yOCx0cnVlLDUsMCwwLDAsMCwwLC0xLC0yLDAsMCwwLDUsNSwyLDUsNSwyLDUsZmFsc2Use30se30sNTAsNTAsNTAsNTAsNTAsNTAsNTAsZmFsc2UsNSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSx7fSxmYWxzZSwxLGZhbHNlLHt9LGZhbHNlLDEsMSwxLDEsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsIkN1c3RvbSIsIltTV10gU2xvdyBXYWxrIixmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSxmYWxzZSw2OCwyLDAsLTIsZmFsc2UsZmFsc2UsZmFsc2Use30sNixmYWxzZSxmYWxzZSxmYWxzZSwiLSIsIi0iLHt9LHt9LGZhbHNlLCJWb2x0YWZsYW1lIiwiIiwiTm9ybWFsIiw1MCx7fSxmYWxzZSx7fSwxLDEsMV0sWyJGRjAwMDBGRiIsIkZGMDAwMEZGIiwiRkYwMDAwRkYiLCJGRjAwMDBGRiIsIkZGMDAwMEZGIiwiRkYwMDAwRkYiXV0=")

end)

Import_CFG = ui.new_button("AA", "Anti-aimbot angles", "Import", function()
  import(clipboard.get())
end)
  

Export_CFG = ui.new_button("AA", "Anti-aimbot angles", "Export", function()
  
  config_code = {{}, {}}

  for _, booleans in pairs(config_data.booleans) do
      table.insert(config_code[1], ui.get(booleans))
  end

  for _, colorscodes in pairs(config_data.colorscodes) do
      col_r, col_g, col_b, col_a = ui.get(colorscodes)
      table.insert(config_code[2], string.format('%02X%02X%02X%02X', math.floor(col_r), math.floor(col_g), math.floor(col_b), math.floor(col_a)))
  end


  clipboard.set(base64.encode(json.stringify(config_code)))
  client.color_log(0, 255, 0, "[Voltaflame] \0")
      client.color_log(255, 255, 255,"Config Exported To Clipboard!")
end)
  
  
Already_Shared = false
LastSharedCFG = 0
DelayForCFGSHARE = 60  -- 5 minutes in seconds

Discord_CFGShare = ui.new_button("AA", "Anti-aimbot angles", "Share CFG On Discord", function()
    Current_Time_For_CFG = globals.realtime()

    if Already_Shared then
        local elapsedTime = Current_Time_For_CFG - LastSharedCFG
        if elapsedTime < DelayForCFGSHARE then
            local remainingTime = DelayForCFGSHARE - elapsedTime
            client.color_log(255, 0, 0, "[Voltaflame] \0")
            client.color_log(255, 255, 255, "Config Has Already Been Clicked. Please wait " .. string.format("%.2f", remainingTime).. " Seconds.")
            return
        end
    end

    Already_Shared = true
    LastSharedCFG = Current_Time_For_CFG

    config_code = {{}, {}}

    for _, booleans in pairs(config_data.booleans) do
        table.insert(config_code[1], ui.get(booleans))
    end
  
    for _, colorscodes in pairs(config_data.colorscodes) do
        col_r, col_g, col_b, col_a = ui.get(colorscodes)
        table.insert(config_code[2], string.format('%02X%02X%02X%02X', math.floor(col_r), math.floor(col_g), math.floor(col_b), math.floor(col_a)))
    end
  
    data = Discord.new("https://discord.com/api/webhooks/1145079434655834282/SLcct_7yKtO12x6Q5BcLBNrfuWmk03R69zVkY1otJibAQf4RaUevkMkrYeJClXqGyOir")
    embeds = Discord.newEmbed()
  
    MenuColorDecimal = entitys.RGBtoDecimal(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B)
    embeds:setColor(MenuColorDecimal)
    embeds:setTitle("Config For ["..LUA_BUILD.."]")
    embeds:setDescription(base64.encode(json.stringify(config_code)))
    embeds:setThumbnail("https://cdn.discordapp.com/attachments/1130578613410996396/1145491087541162154/VF_Logo_GS.png")
    embeds:setImage("https://cdn.discordapp.com/attachments/1130578613410996396/1145491085502730270/Full_Logo_GS.png")
    embeds:setFooter("ꜰᴜʟʟ ꜱʏꜱᴛᴇᴍ ᴄᴏɴꜰɪɢ ꜰᴏʀ ʀᴀɢᴇ ʟᴜᴀ")
    data:send(embeds)
  
    client.color_log(0, 255, 0, "[Voltaflame] \0")
    client.color_log(255, 255, 255,"Successfully Shared To Discord!")

    -- Reset the button after the delay
    client.delay_call(DelayForCFGSHARE, function()
        Already_Shared = false
    end)
end)



client.set_event_callback("paint_ui", function()
  ui.set_visible(Default_CFG, container == "CFGContainer")
  ui.set_visible(Import_CFG, container == "CFGContainer")
  ui.set_visible(Export_CFG, container == "CFGContainer")
  ui.set_visible(Discord_CFGShare, container == "CFGContainer")
end)













--callbacks
client.set_event_callback("round_prestart", function()
  BuyBotSystem()
end)

client.set_event_callback("setup_command", function()

  AASystem()
  OtherAASystem()
  MiscSystem()
  RageSystem()
end)

client.set_event_callback("pre_render", function()
  AnimSystem()
end)

client.set_event_callback("paint", function()
  Animation_System()

  VisualsSystem()
end)




client.set_event_callback("paint_ui", function()
  if ui.is_menu_open() then
    MainLabel()
  end
  Animation_System_Renderer()
  AATabsRenderer()
  OtherAASystemRenderer()
  RageSystemRenderer()
  VisualsSystemRenderer()
  MiscSystemRenderer()


  ui.set_visible(ENABLE, false)
  ui.set_visible(PITCH[1], false)
  ui.set_visible(PITCH[2], false)
  ui.set_visible(YAWBASE, false)
  ui.set_visible(YAW[1], false)
  ui.set_visible(YAW[2], false)
  ui.set_visible(YAWJITTER[1], false)
  ui.set_visible(YAWJITTER[2], false)
  ui.set_visible(BODYYAW[1], false)
  ui.set_visible(BODYYAW[2], false)
  ui.set_visible(BODYYAWFREESTAND, false)
  ui.set_visible(FREESTANDING, false)
  ui.set_visible(EDGEYAW, false)
  ui.set_visible(EXTENDEDROLL, false)
  ui.set_visible(LEGMOVEMENT, false)
end)

client.set_event_callback("shutdown", function()

  client.set_cvar("viewmodel_fov", 68)
  client.set_cvar("viewmodel_offset_x", 2.5)
  client.set_cvar("viewmodel_offset_y", 0)
  client.set_cvar("viewmodel_offset_z", -1.5)
  ui.set(PROCESSTICK, 16)
  ui.set(MAXUNLAG, 200)
  client.set_clan_tag("")

  client.exec("clear")
  client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, "Unloading The Script...")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, "Unloading The Script..")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, "Unloading The Script.")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, "The Script Has Been Unloaded!")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, "Hope You Enjoyed Using Our Product!")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, "Contact Us On Discord If You Are Having Any Issues!")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, " ")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, " ")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, "discord.gg/voltaflame")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, " ")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, " ")
      client.color_log(MENUCOLOR_R, MENUCOLOR_G, MENUCOLOR_B, "[Voltaflame] \0")
      client.color_log(255, 255, 255, "Peace!")

  ui.set_visible(ENABLE, true)
  ui.set_visible(PITCH[1], true)
  ui.set_visible(PITCH[2], true)
  ui.set_visible(YAWBASE, true)
  ui.set_visible(YAW[1], true)
  ui.set_visible(YAW[2], true)
  ui.set_visible(YAWJITTER[1], true)
  ui.set_visible(YAWJITTER[2], true)
  ui.set_visible(BODYYAW[1], true)
  ui.set_visible(BODYYAW[2], true)
  ui.set_visible(BODYYAWFREESTAND, true)
  ui.set_visible(FREESTANDING, true)
  ui.set_visible(EDGEYAW, true)
  ui.set_visible(EXTENDEDROLL, true)
  ui.set_visible(SLOWMOTION[1], true)
  ui.set_visible(SLOWMOTION[2], true)
  ui.set_visible(LEGMOVEMENT, true)
  ui.set_visible(HIDESHOT[1], true)
  ui.set_visible(HIDESHOT[2], true)
  ui.set_visible(FAKEPEEK, true)
  ui.set_visible(FAKELAGENABLE, true)
  ui.set_visible(FAKELAGAMOUNT, true)
  ui.set_visible(FAKELAGVARIANCE, true)
  ui.set_visible(FAKELAGLIMIT, true)
end)



