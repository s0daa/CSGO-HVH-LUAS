local pui = require "gamesense/pui"
local ffi = require "ffi"
local vector = require "vector"
local inspect = require 'gamesense/inspect'
local base64 = require "gamesense/base64"
local clipboard = require("gamesense/clipboard")
local c_entity = require "gamesense/entity"
local json = require("json")
local OH = require("gamesense/http")
local script = {
   name = "impulse",
   build = "sun",
   debug = false
}
local function vec_3(_x, _y, _z)
   return { x = _x or 0, y = _y or 0, z = _z or 0 }
end

local function ticks_to_time()
   return globals.tickinterval() * 16
end
local function player_will_peek()
   local enemies = entity.get_players(true)
   if not enemies then
      return false
   end

   local eye_position = vec_3(client.eye_position())
   local velocity_prop_local = vec_3(entity.get_prop(entity.get_local_player(), "m_vecVelocity"))
   local predicted_eye_position = vec_3(eye_position.x + velocity_prop_local.x * ticks_to_time(predicted),
      eye_position.y + velocity_prop_local.y * ticks_to_time(predicted),
      eye_position.z + velocity_prop_local.z * ticks_to_time(predicted))

   for i = 1, #enemies do
      local player = enemies[i]

      local velocity_prop = vec_3(entity.get_prop(player, "m_vecVelocity"))

      -- Store and predict player origin
      local origin = vec_3(entity.get_prop(player, "m_vecOrigin"))
      local predicted_origin = vec_3(origin.x + velocity_prop.x * ticks_to_time(),
         origin.y + velocity_prop.y * ticks_to_time(), origin.z + velocity_prop.z * ticks_to_time())

      -- Set their origin to their predicted origin so we can run calculations on it
      entity.get_prop(player, "m_vecOrigin", predicted_origin)

      -- Predict their head position and fire an autowall trace to see if any damage can be dealt
      local head_origin = vec_3(entity.hitbox_position(player, 0))
      local predicted_head_origin = vec_3(head_origin.x + velocity_prop.x * ticks_to_time(),
         head_origin.y + velocity_prop.y * ticks_to_time(), head_origin.z + velocity_prop.z * ticks_to_time())
      local trace_entity, damage = client.trace_bullet(entity.get_local_player(), predicted_eye_position.x,
         predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y,
         predicted_head_origin.z)

      -- Restore their origin to their networked origin
      entity.get_prop(player, "m_vecOrigin", origin)

      -- Check if damage can be dealt to their predicted head
      if damage > 0 then
         return true
      end
   end

   return false
end
local E_POSE_PARAMETERS = {
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
}
local notify            = { logs = {} }
notify.add              = function(text)
   table.insert(notify.logs, 1, { text = text, time = globals.curtime() + 4, alpha = 0 })
end
local enums             = {}; do
   enums.visual = {
      screen = vector(client.screen_size()),
      x = vector(client.screen_size()).x / 2,
      y = vector(client.screen_size()).y / 2
   }
   enums.aa = {
      state = 1,
      def_state = 1,
      side = 0,
      inverted = -1,
      air_tick = 0,
      in_air = false,
      tick = 0,
      way = 1,
      way2 = 1,
      skitter = -1,
      last_right = false,
      last_left = false,
      manual = 0,
      should_scout = false
   }
end


math.number_fix    = function(number, value)
   return string.format("%g", string.format("%." .. value .. "f", number))
end
math.time_to_ticks = function(t)
   return math.floor(0.5 + (t / globals.tickinterval()))
end
math.round         = function(value, decimals)
   local multiplier = 10.0 ^ (decimals or 0.0)
   return math.floor(value * multiplier + 0.5) / multiplier
end
math.clamp         = function(x, min, max)
   if x < min then return min end
   if x > max then return max end
   if x == nil then return min end
   return x
end
math.normalize_yaw = function(angle)
   if angle < -180 then
      angle = angle + 360
   end
   if angle > 180 then
      angle = angle - 360
   end
   return angle
end
math.lerp          = function(a, b, t)
   if a == b then return a end
   return a * (1 - t) + b * t
end
math.flerp         = function(a, b, t)
   return a + t * (b - a)
end
math.elerp         = function(self, start, end_, speed, delta)
   if (math.abs(start - end_) < (delta or 0.01)) then
      return end_
   end
   speed = speed or 0.095
   local time = global_vars.frametime * (175 * speed)
   return ((end_ - start) * time + start)
end

local anim         = {}; do
   anim.data = {};
   anim.lerp = function(x, v, t)
      if type(x) == 'table' then
         return anim.lerp(x[1], v[1], t), anim.lerp(x[2], v[2], t), anim.lerp(x[3], v[3], t), anim.lerp(x[4], v[4], t)
      end

      local delta = v - x

      if type(delta) == 'number' then
         if math.abs(delta) < 0.005 then
            return v
         end
      end

      return delta * t + x
   end
   anim.process = function(self, name, bool, time)
      if not self.data[name] then
         self.data[name] = 0
      end

      local animation = globals.frametime() * (bool and 1 or -1) * (time or 4)
      self.data[name] = math.clamp(self.data[name] + animation, 0, 1)
      return self.data[name]
   end

   anim.flerp = function(self, start, end_, speed, delta)
      if (math.abs(start - end_) < (delta or 0.01)) then
         return end_
      end
      speed = speed or 0.095
      local time = globals.frametime() * (175 * speed)
      return ((end_ - start) * time + start)
   end
end



---@region: ui
local config = {}
local menu = {}; do
   menu.states = {
      global = { "Global", "Standing", "Moving", "Air", "Air-crouch", "Crouch", "Slowwalking" },
      menu = { " ", "  ", "   ", "    ", "     ", "      ", "       " },
      defensive = { "        ", "         ", "          ", "           ", "            ", "             ", "              " }
   }
   menu.refs = {
      global = {
         os = { ui.reference('AA', 'Other', 'On shot anti-aim') },
         dt = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
         dmg = { ui.reference('RAGE', 'Aimbot', 'Minimum damage override') },
         slow = { ui.reference('AA', 'Other', 'Slow motion') },
         autostrafe = pui.reference("MISC", "Movement", "Air strafe"),
         legs = pui.reference("AA", "Other", "Leg movement")
      },
      aa = {
         enabled = pui.reference("AA", "Anti-aimbot angles", "Enabled"),
         pitch = { pui.reference("AA", "Anti-aimbot angles", "Pitch") },
         yawbase = pui.reference("AA", "Anti-aimbot angles", "Yaw base"),
         yaw = { pui.reference("AA", "Anti-aimbot angles", "Yaw") },
         jitter = { pui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
         body = { pui.reference("AA", "Anti-aimbot angles", "Body yaw") },
         freestandbody = pui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
         edge = pui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
         freestand = { pui.reference("AA", "Anti-aimbot angles", "Freestanding") },
         roll = pui.reference("AA", "Anti-aimbot angles", "Roll"),

      },
   }
   menu.elements = function(self)
      self.path = pui.group("AA", "Anti-aimbot angles");
      self.other = pui.group("AA", "Other");
      self.global = {
         mark = self.path:label("✦ impulse"),
         selection = self.path:combobox("\n", { "Global", "Anti-aim", "Visuals" }),
         import = self.other:button("Import config", function()
            config.import(clipboard.get())
         end),
         export = self.other:button("Export config", function()
            config.export()
         end)
      };
      self.aa = {
         builder = { defensive = {} },
         state = self.path:combobox("State", menu.states.global),
         mode = self.other:combobox("Mode", { "Builder", "Other" }),
         selection = self.other:combobox("Builder selection", { "Default", "Defensive" }),
         defensive_state = self.other:multiselect("Defensive on", { "Doubletap", "Hideshots" }),

         ---@helpers
         helpers = self.path:multiselect("Anti-aim helpers",
            { "Safe head", "Fast ladder", "No enemies alive AA", "Anti backstab" }),
         left = self.path:hotkey("Manual \vleft"),
         right = self.path:hotkey("Manual \vright"),
         freestand = self.path:hotkey("Freestand")

      };
      for i = 1, #menu.states.global do
         self.aa.builder[i] = {
            enable = self.path:checkbox("Enable state" .. menu.states.menu[i]),
            pitch = self.path:combobox("Pitch" .. menu.states.menu[i],
               { "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom" }),
            custom_pitch = self.path:slider("Pitch" .. menu.states.menu[i], -89, 89, 0, true, "°"),
            yawbase = self.path:combobox("Yaw base" .. menu.states.menu[i], { "Local view", "At targets" }),
            yaw = self.path:combobox("Yaw" .. menu.states.menu[i],
               { "Off", "180", "Spin", "Static", "180Z", "Crosshair" }),
            yawadd = self.path:combobox("Yaw add" .. menu.states.menu[i], { "Static", "L/R", "Slowed", "X-Way" }),
            static = self.path:slider("Static" .. menu.states.menu[i], -180, 180, 0, true, "°"),
            left = self.path:slider("Left" .. menu.states.menu[i], -180, 180, 0, true, "°"),
            right = self.path:slider("Right" .. menu.states.menu[i], -180, 180, 0, true, "°"),
            slow = self.path:slider("Delay" .. menu.states.menu[i], 2, 8, 0, true, "t"),
            way = self.path:slider("Way" .. menu.states.menu[i], 2, 5, 2, true, "w"),
            way1 = self.path:slider("Way 1" .. menu.states.menu[i], -180, 180, 0, true, "°"),
            way2 = self.path:slider("Way 2" .. menu.states.menu[i], -180, 180, 0, true, "°"),
            way3 = self.path:slider("Way 3" .. menu.states.menu[i], -180, 180, 0, true, "°"),
            way4 = self.path:slider("Way 4" .. menu.states.menu[i], -180, 180, 0, true, "°"),
            way5 = self.path:slider("Way 5" .. menu.states.menu[i], -180, 180, 0, true, "°"),
            yawjitter = self.path:combobox("Yaw jitter" .. menu.states.menu[i],
               { "Off", "Offset", "Center", "Random", "Skitter" }),
            jiiter = self.path:slider("Range" .. menu.states.menu[i], -180, 180, 0, true, "°"),
            body = self.path:combobox("Body yaw" .. menu.states.menu[i], { "Off", "Opposite", "Jitter", "Static" }),
            bodyyaw = self.path:slider("Body yaw limit" .. menu.states.menu[i], -180, 180, 0, true, "°"),
            freestandingbody = self.path:checkbox("Body yaw freestanding") --[[]]
         }
         self.aa.builder.defensive[i] = {
            force = self.path:checkbox("Force defensive" .. menu.states.defensive[i]),
            enable = self.path:checkbox("Enable state" .. menu.states.defensive[i]),
            pitch = self.path:combobox("Pitch" .. menu.states.defensive[i],
               { "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom" }),
            custom_pitch = self.path:slider("Pitch" .. menu.states.defensive[i], -89, 89, 0, true, "°"),
            yawbase = self.path:combobox("Yaw base" .. menu.states.defensive[i], { "Local view", "At targets" }),
            yaw = self.path:combobox("Yaw" .. menu.states.defensive[i],
               { "Off", "180", "Spin", "Static", "180Z", "Crosshair" }),
            yawadd = self.path:combobox("Yaw add" .. menu.states.defensive[i], { "Static", "L/R", "Slowed", "X-Way" }),
            static = self.path:slider("Static" .. menu.states.defensive[i], -180, 180, 0, true, "°"),
            left = self.path:slider("Left" .. menu.states.defensive[i], -180, 180, 0, true, "°"),
            right = self.path:slider("Right" .. menu.states.defensive[i], -180, 180, 0, true, "°"),
            slow = self.path:slider("Delay" .. menu.states.defensive[i], 2, 8, 0, true, "t"),
            way = self.path:slider("Way" .. menu.states.defensive[i], 2, 5, 2, true, "w"),
            way1 = self.path:slider("Way 1" .. menu.states.defensive[i], -180, 180, 0, true, "°"),
            way2 = self.path:slider("Way 2" .. menu.states.defensive[i], -180, 180, 0, true, "°"),
            way3 = self.path:slider("Way 3" .. menu.states.defensive[i], -180, 180, 0, true, "°"),
            way4 = self.path:slider("Way 4" .. menu.states.defensive[i], -180, 180, 0, true, "°"),
            way5 = self.path:slider("Way 5" .. menu.states.defensive[i], -180, 180, 0, true, "°"),
            yawjitter = self.path:combobox("Yaw jitter" .. menu.states.defensive[i],
               { "Off", "Offset", "Center", "Random", "Skitter" }),
            jiiter = self.path:slider("Range" .. menu.states.defensive[i], -180, 180, 0, true, "°"),
            body = self.path:combobox("Body yaw" .. menu.states.defensive[i], { "Off", "Opposite", "Jitter", "Static" }),
            bodyyaw = self.path:slider("Body yaw limit" .. menu.states.defensive[i], -180, 180, 0, true, "°"),
            freestandingbody = self.path:checkbox("Body yaw freestanding")
         }
      end
      self.vis = {
         ind = self.path:checkbox("Under crosshair indicators", { 255, 255, 255 }),
         notification = self.path:checkbox("Notifications")
      };
      self.misc = {
         animbreakers = self.path:checkbox("Animbreakers"),
         state = self.path:multiselect("Animbreakers state", { "Ground", "Air", "Misc" }),
         ground = self.path:combobox("Ground", { "Static", "Jitter", "Moonwalk" }),
         air = self.path:combobox("Air", { "Static", "Jitter", "Walking" }),
         misc = self.path:multiselect("Misc", { "Body lean", "Eatherquake" }),
         lean = self.path:slider("Bodylean", 0, 100, 0),
         helpers = self.path:multiselect("Helpers", { "Force defensive on peek", "Jumpscout fix" })
      };
   end
   menu.visibility = function(self)
      self.aa.mode:depend({ self.global.selection, "Anti-aim" })
      self.aa.selection:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" })
      self.aa.state:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" })
      self.aa.defensive_state:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
         { self.aa.selection, "Defensive" })

      self.aa.left:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Other" })
      self.aa.right:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Other" })
      self.aa.helpers:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Other" })
      self.aa.freestand:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Other" })
      self.global.import:depend({ self.global.selection, "Global" })
      self.global.export:depend({ self.global.selection, "Global" })
      self.misc.animbreakers:depend({ self.global.selection, "Global" })

      self.misc.helpers:depend({ self.global.selection, "Global" })

      self.misc.state:depend({ self.global.selection, "Global" }, { self.misc.animbreakers, true })
      self.misc.ground:depend({ self.global.selection, "Global" }, { self.misc.animbreakers, true },
         { self.misc.state, "Ground" })
      self.misc.air:depend({ self.global.selection, "Global" }, { self.misc.animbreakers, true },
         { self.misc.state, "Air" })
      self.misc.misc:depend({ self.global.selection, "Global" }, { self.misc.animbreakers, true },
         { self.misc.state, "Misc" })
      self.misc.lean:depend({ self.global.selection, "Global" }, { self.misc.animbreakers, true },
         { self.misc.state, "Misc" })


      for i = 1, #menu.states.global do
         self.aa.builder[i].enable:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] })
         self.aa.builder[i].pitch:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true })
         self.aa.builder[i].custom_pitch:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].pitch, "Custom" })


         self.aa.builder[i].yawbase:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true })

         self.aa.builder[i].yaw:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true })

         self.aa.builder[i].yawadd:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yaw, function()
               return self.aa.builder[i].yaw.value ~= "Off"
            end })


         self.aa.builder[i].static:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yaw, function()
               return self.aa.builder[i].yaw.value ~= "Off"
            end }, { self.aa.builder[i].yawadd, "Static" })

         self.aa.builder[i].left:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yaw, function()
               return self.aa.builder[i].yaw.value ~= "Off"
            end }, { self.aa.builder[i].yawadd, function()
               return self.aa.builder[i].yawadd.value == "L/R" or self.aa.builder[i].yawadd.value == "Slowed"
            end })

         self.aa.builder[i].right:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yaw, function()
               return self.aa.builder[i].yaw.value ~= "Off"
            end }, { self.aa.builder[i].yawadd, function()
               return self.aa.builder[i].yawadd.value == "L/R" or self.aa.builder[i].yawadd.value == "Slowed"
            end })

         self.aa.builder[i].slow:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yaw, function()
               return self.aa.builder[i].yaw.value ~= "Off"
            end }, { self.aa.builder[i].yawadd, "Slowed" })

         self.aa.builder[i].way:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yaw, function()
               return self.aa.builder[i].yaw.value ~= "Off"
            end },
            { self.aa.builder[i].yawadd, "X-Way" })

         self.aa.builder[i].way1:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yaw, function()
               return self.aa.builder[i].yaw.value ~= "Off"
            end },
            { self.aa.builder[i].yawadd, "X-Way" })

         self.aa.builder[i].way2:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yaw, function()
               return self.aa.builder[i].yaw.value ~= "Off"
            end },
            { self.aa.builder[i].yawadd, "X-Way" })
         self.aa.builder[i].way3:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yaw, function()
               return self.aa.builder[i].yaw.value ~= "Off"
            end },
            { self.aa.builder[i].yawadd, "X-Way" })
         self.aa.builder[i].way4:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yaw, function()
               return self.aa.builder[i].yaw.value ~= "Off"
            end },
            { self.aa.builder[i].yawadd, "X-Way" })
         self.aa.builder[i].way5:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yaw, function()
               return self.aa.builder[i].yaw.value ~= "Off"
            end },
            { self.aa.builder[i].yawadd, "X-Way" })


         self.aa.builder[i].yawjitter:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true })

         self.aa.builder[i].jiiter:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].yawjitter, function()
               return self.aa.builder[i].yawjitter.value ~= "Off"
            end })

         self.aa.builder[i].body:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true })

         self.aa.builder[i].bodyyaw:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].body, function()
               return self.aa.builder[i].body.value ~= "Off"
            end })

         self.aa.builder[i].freestandingbody:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Default" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder[i].enable, true }, { self.aa.builder[i].body, function()
               return self.aa.builder[i].body.value ~= "Off"
            end }) --[[]]

         self.aa.builder.defensive[i].force:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] })

         self.aa.builder.defensive[i].enable:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] })
         self.aa.builder.defensive[i].pitch:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true })
         self.aa.builder.defensive[i].custom_pitch:depend({ self.global.selection, "Anti-aim" },
            { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].pitch, "Custom" })


         self.aa.builder.defensive[i].yawbase:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true })

         self.aa.builder.defensive[i].yaw:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true })
         self.aa.builder.defensive[i].yawadd:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yaw, function()
               return self.aa.builder.defensive[i].yaw.value ~= "Off"
            end })


         self.aa.builder.defensive[i].static:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yaw, function()
               return self.aa.builder.defensive[i].yaw.value ~= "Off"
            end }, { self.aa.builder.defensive[i].yawadd, "Static" })

         self.aa.builder.defensive[i].left:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yaw, function()
               return self.aa.builder.defensive[i].yaw.value ~= "Off"
            end }, { self.aa.builder.defensive[i].yawadd, function()
               return self.aa.builder.defensive[i].yawadd.value == "L/R" or
                   self.aa.builder.defensive[i].yawadd.value == "Slowed"
            end })

         self.aa.builder.defensive[i].right:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yaw, function()
               return self.aa.builder.defensive[i].yaw.value ~= "Off"
            end }, { self.aa.builder.defensive[i].yawadd, function()
               return self.aa.builder.defensive[i].yawadd.value == "L/R" or
                   self.aa.builder.defensive[i].yawadd.value == "Slowed"
            end })

         self.aa.builder.defensive[i].slow:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yaw, function()
               return self.aa.builder.defensive[i].yaw.value ~= "Off"
            end }, { self.aa.builder.defensive[i].yawadd, "Slowed" })

         self.aa.builder.defensive[i].way:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yaw, function()
               return self.aa.builder.defensive[i].yaw.value ~= "Off"
            end },
            { self.aa.builder.defensive[i].yawadd, "X-Way" })

         self.aa.builder.defensive[i].way1:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yaw, function()
               return self.aa.builder.defensive[i].yaw.value ~= "Off"
            end },
            { self.aa.builder.defensive[i].yawadd, "X-Way" })

         self.aa.builder.defensive[i].way2:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yaw, function()
               return self.aa.builder.defensive[i].yaw.value ~= "Off"
            end },
            { self.aa.builder.defensive[i].yawadd, "X-Way" })
         self.aa.builder.defensive[i].way3:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yaw, function()
               return self.aa.builder.defensive[i].yaw.value ~= "Off"
            end },
            { self.aa.builder.defensive[i].yawadd, "X-Way" })
         self.aa.builder.defensive[i].way4:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yaw, function()
               return self.aa.builder.defensive[i].yaw.value ~= "Off"
            end },
            { self.aa.builder.defensive[i].yawadd, "X-Way" })
         self.aa.builder.defensive[i].way5:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yaw, function()
               return self.aa.builder.defensive[i].yaw.value ~= "Off"
            end },
            { self.aa.builder.defensive[i].yawadd, "X-Way" })


         self.aa.builder.defensive[i].yawjitter:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true })

         self.aa.builder.defensive[i].jiiter:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].yawjitter, function()
               return self.aa.builder.defensive[i].yawjitter.value ~= "Off"
            end })

         self.aa.builder.defensive[i].body:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true })

         self.aa.builder.defensive[i].bodyyaw:depend({ self.global.selection, "Anti-aim" }, { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].body, function()
               return self.aa.builder.defensive[i].body.value ~= "Off"
            end })

         self.aa.builder.defensive[i].freestandingbody:depend({ self.global.selection, "Anti-aim" },
            { self.aa.mode, "Builder" },
            { self.aa.selection, "Defensive" }, { self.aa.state, self.states.global[i] },
            { self.aa.builder.defensive[i].enable, true }, { self.aa.builder.defensive[i].body, function()
               return self.aa.builder.defensive[i].body.value ~= "Off"
            end }) --[[]]
      end

      self.vis.notification:depend({ self.global.selection, "Visuals" }, { self.refs.aa.enabled, true })
      self.vis.ind:depend({ self.global.selection, "Visuals" }, { self.refs.aa.enabled, true })
   end
   menu.setup = function(self)
      self:elements()
      self:visibility()
      self.aa.left:set("Toggle")
      self.aa.right:set("Toggle")
      self.refs.aa.freestand[1]:set(false)
   end
end
--menu:setup()
local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
local helpers                = { last_sim_time = 0, defensive_until = 0, cheked_ticks = 0, alive }; do
   helpers.is_defensive = function(self, bool)
      if not entity.get_local_player() then
         return false
      end
      if not bool then return false end
      local tickcount = globals.tickcount();
      local local_player = entity.get_local_player();
      local sim_time = math.time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"));
      if bool then
         local sim_diff = sim_time - self.last_sim_time;

         if sim_diff < 0 then
            self.defensive_until = tickcount + math.abs(sim_diff) -
                math.time_to_ticks(client.real_latency());
         end
         self.last_sim_time = sim_time;
      end
      return self.defensive_until > tickcount + 2;
   end
   helpers.to_hex = function(r, g, b, a)
      return string.format("%02x%02x%02x%02x", r, g, b, a)
   end
   helpers.breath = function(x)
      x = x % 2.0

      if x > 1.0 then
         x = 2.0 - x
      end

      return x
   end
   helpers.u8 = function(s)
      return string.gsub(s, "[\128-\191]", "")
   end
   helpers.gradient = function(s, clock, r1, g1, b1, a1, r2, g2, b2, a2)
      local buffer = {}

      local len = #helpers.u8(s)
      local div = 1 / (len - 1)

      local add_r = r2 - r1
      local add_g = g2 - g1
      local add_b = b2 - b1
      local add_a = a2 - a1

      for char in string.gmatch(s, ".[\128-\191]*") do
         local t = helpers.breath(clock)

         local r = r1 + add_r * t
         local g = g1 + add_g * t
         local b = b1 + add_b * t
         local a = a1 + add_a * t

         buffer[#buffer + 1] = "\a"
         buffer[#buffer + 1] = helpers.to_hex(r, g, b, a)
         buffer[#buffer + 1] = char

         clock = clock - div
      end

      return table.concat(buffer)
   end
   helpers.get_curtime = function(offset)
      return globals.curtime() - (offset * globals.tickinterval())
   end
   helpers.get_charge = function()
      local target = entity.get_local_player()
      if not target then
         return
      end

      local weapon = entity.get_player_weapon(target)

      if target == nil or weapon == nil then
         return false
      end

      if helpers.get_curtime(16) < entity.get_prop(target, 'm_flNextAttack') then
         return false
      end

      if helpers.get_curtime(0) < entity.get_prop(weapon, 'm_flNextPrimaryAttack') then
         return false
      end

      return true
   end
   helpers.get_weapon_class = function()
      local target = entity.get_local_player()
      if not target then
         return
      end
      local weapon = entity.get_player_weapon(target)
      if target == nil or weapon == nil then
         return "?"
      end
      local classname = entity.get_classname(weapon)
      return classname
   end
   helpers.get_alive_enemies = function()
      local alive = 0
      for i = 1, globals.maxplayers() do
         if entity.get_classname(i) ~= 'CCSPlayer' then
            goto skip
         end

         if not entity.is_alive(i) or not entity.is_enemy(i) then
            goto skip
         end

         alive = alive + 1
         ::skip::
      end

      return alive
   end
end

local updates = {}; do
   updates.choke = -1;
   updates.choke_bool = false;
   updates.packets = 0;
   updates.defensive = false;

   updates.net = function()
      local chokedcommands = globals.chokedcommands()
      if chokedcommands <= 1 then
         updates.packets = updates.packets + 1
         updates.choke = updates.choke * -1
         updates.choke_bool = not updates.choke_bool
      end
   end
end


local callbacks = {}; do
   callbacks.paint = {
      indicators = function()
         local r, g, b, a = menu.vis.ind:get_color()
         if entity.get_local_player() == nil then enums.aa.cheked_ticks = 0 end
         if not ui.get(menu.refs.global.dt[2]) then enums.aa.cheked_ticks = 0 end

         local wm = helpers.gradient("✦ i m p u l s e", globals.realtime(), 100, 100, 100, 255, r, g, b, 200)
         renderer.text(enums.visual.x, enums.visual.screen.y - 15, r, g, b, a, "cb", 0, wm)
         if not menu.vis.ind:get() then return end
         local lp = entity.get_local_player()
         if not entity.is_alive(lp) or not lp then return end
         a = 255
         local charged = anim:process("charge", helpers.get_charge(), 13)
         local ch_r, ch_g, ch_b = anim.lerp({ 255, 90, 90, 255 }, { r, g, b, a }, charged)
         local list = {
            {
               name = "doubletap",
               bool = ui.get(menu.refs.global.dt[1]) and ui.get(menu.refs.global.dt[2]),
               anim = 0,
               r = ch_r,
               g = ch_g,
               b = ch_b,
               a = a
            },
            {
               name = "onshot",
               bool = ui.get(menu.refs.global.os[1]) and ui.get(menu.refs.global.os[2]) and
                   not (ui.get(menu.refs.global.dt[1]) and ui.get(menu.refs.global.dt[2])),
               anim = 0,
               r = r,
               g = g,
               b = b,
               a = a
            },
            {
               name = "damage",
               bool = ui.get(menu.refs.global.dmg[1]) and ui.get(menu.refs.global.dmg[2]),
               anim = 0,
               r = r,
               g = g,
               b = b,
               a = a
            },
         }
         local ay = 0
         local scope = entity.get_prop(lp, "m_bIsScoped")
         local scope_anim = anim:process("scoped", scope == 1, 13)
         local scope_add = 30 * scope_anim
         local text = helpers.gradient("IMPULSE", globals.realtime(), 100, 100, 100, a, r, g, b, a)
         renderer.text(enums.visual.x + scope_add, enums.visual.y + 35, r, g, b, a, "c-", 0,
            string.format("%s\a%s%s", text, helpers.to_hex(r, g, b, a), script.build:upper()))
         for k, v in pairs(list) do
            v.alpha = anim:process(k, v.bool, 13)
            v.lenght = #v.name
            v.index = v.lenght * v.alpha
            v.anim = v.index % (v.lenght * 2)
            v.sub = string.sub(v.name, 1, v.index)
            v.scope = (renderer.measure_text("c-", v.sub:upper()) / 2 - 23) *
                scope_anim
            renderer.text(enums.visual.x + scope_add + v.scope, enums.visual.y + 44 + ay, v.r, v.g, v.b, v.a * v.alpha,
               "c-", 0,
               v.sub:upper())
            ay = ay + 9 * v.alpha
         end
      end,
      notify = function()
         if not menu.vis.notification:get() then return end
         if not entity.get_local_player() then notify.logs = {} end
         local offset = 0
         for i, v in pairs(notify.logs) do
            if v.time > globals.curtime() and i <= 6 then
               v.alpha = anim.lerp(v.alpha, 255, 0.1)
            else
               v.alpha = anim.lerp(v.alpha, 0, 0.1)
               if v.alpha < 1 then
                  table.remove(notify.logs, i)
               end
            end
            renderer.text(enums.visual.x, enums.visual.y + 155 + offset, 255, 255, 255, v.alpha,
               "c", 0, v.text)
            offset = offset + 15 * (v.alpha / 255)
         end
      end
   }
   callbacks.menu = {
      set = function()
         local accent = pui.reference('Misc', 'Settings', 'Menu color')
         accent = { accent:get() }
         local text = helpers.gradient("✦ impulse", globals.realtime(), 155, 155, 155, 200, accent[1], accent[2],
            accent[3], 255)
         menu.global.mark:set(text)

         menu.refs.aa.enabled:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.pitch[1]:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.pitch[2]:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.yawbase:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.yaw[1]:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.yaw[2]:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.jitter[1]:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.jitter[2]:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.body[1]:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.body[2]:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.freestandbody:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.edge:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.freestand[1]:set_visible(menu.refs.aa.enabled:get() == false)
         menu.refs.aa.roll:set_visible(menu.refs.aa.enabled:get() == false)
      end
   }
   callbacks.createmove = {
      get_state = function()
         local local_player = entity.get_local_player()
         if not local_player then return end
         local flag = entity.get_prop(local_player, "m_fFlags")
         local vel = vector(entity.get_prop(local_player, 'm_vecVelocity')):length2d()
         if vel < 5 or ui.get(menu.refs.global.slow[2]) then
            enums.aa.should_scout = true
         else
            enums.aa.should_scout = false
         end
         local ducked = entity.get_prop(local_player, 'm_bDucked') == 1
         if flag == 256 or flag == 262 then
            enums.aa.in_air = true
            enums.aa.air_tick = globals.tickcount() + 3
         else
            enums.aa.in_air = (enums.aa.air_tick > globals.tickcount()) and true or false
         end
         for i = 1, #menu.states.global do
            if not menu.aa.builder[i].enable:get() then
               enums.aa.state = 1
            end
         end
         if enums.aa.in_air and ducked then
            if menu.aa.builder[5].enable:get() then
               enums.aa.state = 5
            end
            enums.aa.def_state = 5
         else
            if enums.aa.in_air then
               if menu.aa.builder[4].enable:get() then
                  enums.aa.state = 4
               end
               enums.aa.def_state = 4
            else
               if ducked then
                  if menu.aa.builder[6].enable:get() then
                     enums.aa.state = 6
                  end
                  enums.aa.def_state = 6
               else
                  if ui.get(menu.refs.global.slow[2]) then
                     if menu.aa.builder[7].enable:get() then
                        enums.aa.state = 7
                     end
                     enums.aa.def_state = 7
                  else
                     if vel < 5 then
                        if menu.aa.builder[2].enable:get() then
                           enums.aa.state = 2
                        end
                        enums.aa.def_state = 2
                     else
                        if menu.aa.builder[3].enable:get() then
                           enums.aa.state = 3
                        end
                        enums.aa.def_state = 3
                     end
                  end
               end
            end
         end
         if menu.aa.builder.defensive[1].enable:get() then
            enums.aa.def_state = 1
         end
      end,
      builder = function(e)
         local local_player = entity.get_local_player()
         if not local_player then return end
         local body_yaw = entity.get_prop(local_player, 'm_flPoseParameter', 11)
         body_yaw = math.round(body_yaw * 120 - 60)
         local def_builder = menu.aa.builder.defensive[enums.aa.def_state]
         local def_check = helpers:is_defensive((ui.get(menu.refs.global.dt[2])) or (ui.get(menu.refs.global.os[2]))) and
             menu.aa.builder.defensive[enums.aa.def_state].enable:get()

         local tick = menu.aa.builder[enums.aa.state].slow:get()
         local target = tick * 2
         if globals.chokedcommands() == 0 or globals.chokedcommands() == 1 then
            enums.aa.way = enums.aa.way + 1
         end
         if updates.choke_bool then
            enums.aa.tick = enums.aa.tick + 1
            if menu.aa.builder[enums.aa.state].yawadd:get() == "Slowed" then
               enums.aa.side = (updates.packets % target) >= tick and 1 or 0
               --  enums.aa.side = updates.packets % tick + 1 >tick - 1 and 1 or 0
            end
         end
         if enums.aa.way > menu.aa.builder[enums.aa.state].way:get() then enums.aa.way = 1 end
         local dsy = 0
         do
            if menu.aa.builder[enums.aa.state].body:get() == "Jitter" and menu.aa.builder[enums.aa.state].yawadd:get() == "Slowed" then
               dsy = enums.aa.side == 0 and -menu.aa.builder[enums.aa.state].bodyyaw:get() or
                   menu.aa.builder[enums.aa.state].bodyyaw:get()
            else
               dsy = menu.aa.builder[enums.aa.state].bodyyaw:get()
            end
         end
         local rotation = 0

         local yaw = 0
         do
            if menu.aa.builder[enums.aa.state].yawadd:get() == "Static" then
               yaw = menu.aa.builder[enums.aa.state].static:get()
            end
            if menu.aa.builder[enums.aa.state].yawadd:get() == "L/R" or menu.aa.builder[enums.aa.state].yawadd:get() == "Slowed" then
               yaw = body_yaw <= 0 and menu.aa.builder[enums.aa.state].left:get() or
                   menu.aa.builder[enums.aa.state].right:get()
            end
            if menu.aa.builder[enums.aa.state].yawadd:get() == "X-Way" then
               if enums.aa.way ~= nil then
                  if enums.aa.way == 1 then
                     yaw = menu.aa.builder[enums.aa.state].way1:get()
                  end
                  if enums.aa.way == 2 then
                     yaw = menu.aa.builder[enums.aa.state].way2:get()
                  end
                  if enums.aa.way == 3 then
                     yaw = menu.aa.builder[enums.aa.state].way3:get()
                  end
                  if enums.aa.way == 4 then
                     yaw = menu.aa.builder[enums.aa.state].way4:get()
                  end
                  if enums.aa.way == 5 then
                     yaw = menu.aa.builder[enums.aa.state].way5:get()
                  end
               end
            end
         end
         menu.refs.aa.pitch[1]:set(menu.aa.builder[enums.aa.state].pitch:get())
         menu.refs.aa.pitch[2]:set(menu.aa.builder[enums.aa.state].custom_pitch:get())
         menu.refs.aa.yaw[1]:set(menu.aa.builder[enums.aa.state].yaw:get())
         menu.refs.aa.yawbase:set(menu.aa.builder[enums.aa.def_state].yawbase:get())
         menu.refs.aa.yaw[2]:set(yaw)
         menu.refs.aa.jitter[1]:set(menu.aa.builder[enums.aa.state].yawjitter:get())
         menu.refs.aa.jitter[2]:set(menu.aa.builder[enums.aa.state].jiiter:get())
         menu.refs.aa.freestandbody:set(menu.aa.builder[enums.aa.state].freestandingbody:get())

         if (menu.aa.builder[enums.aa.state].body:get() == "Jitter" and menu.aa.builder[enums.aa.state].yawadd:get() == "Slowed") then
            menu.refs.aa.body[1]:set("Static")
         else
            menu.refs.aa.body[1]:set(menu.aa.builder[enums.aa.state].body:get())
         end
         menu.refs.aa.body[2]:set(dsy)

         if (menu.aa.builder.defensive[1].force:get() or menu.aa.builder.defensive[enums.aa.def_state].force:get()) or (menu.misc.helpers:get("Force defensive on peek") and ui.get(menu.refs.global.dt[2]) and player_will_peek()) then
            e.force_defensive = true
         end
         if menu.aa.builder.defensive[enums.aa.def_state].enable:get() then
            if updates.defensive then
               local tick = menu.aa.builder.defensive[enums.aa.def_state].slow:get()
               local target = tick * 2
               if globals.chokedcommands() == 0 or globals.chokedcommands() == 1 then
                  enums.aa.way2 = enums.aa.way2 + 1
               end
               if updates.choke_bool then
                  enums.aa.tick = enums.aa.tick + 1
                  if menu.aa.builder.defensive[enums.aa.def_state].yawadd:get() == "Slowed" then
                     --enums.aa.side = (updates.packets % target) >= tick and 1 or 0
                     enums.aa.side = e.command_number % tick + 1 + 1 == 1 and 1 or 0
                  end
               end
               if enums.aa.way2 > menu.aa.builder.defensive[enums.aa.def_state].way:get() then enums.aa.way2 = 1 end
               local dsy = 0
               do
                  if menu.aa.builder.defensive[enums.aa.def_state].body:get() == "Jitter" and menu.aa.builder.defensive[enums.aa.def_state].yawadd:get() == "Slowed" then
                     dsy = enums.aa.side == 0 and -menu.aa.builder.defensive[enums.aa.def_state].bodyyaw:get() or
                         menu.aa.builder.defensive[enums.aa.def_state].bodyyaw:get()
                  else
                     dsy = menu.aa.builder.defensive[enums.aa.def_state].bodyyaw:get()
                  end
               end
               local yaw = 0
               do
                  if menu.aa.builder.defensive[enums.aa.state].yawadd:get() == "Static" then
                     yaw = menu.aa.builder.defensive[enums.aa.state].static:get()
                  end
                  if menu.aa.builder.defensive[enums.aa.def_state].yawadd:get() == "L/R" or menu.aa.builder.defensive[enums.aa.def_state].yawadd:get() == "Slowed" then
                     yaw = body_yaw <= 0 and menu.aa.builder.defensive[enums.aa.def_state].left:get() or
                         menu.aa.builder.defensive[enums.aa.def_state].right:get()
                  end
                  if menu.aa.builder.defensive[enums.aa.def_state].yawadd:get() == "X-Way" then
                     if enums.aa.way2 ~= nil then
                        if enums.aa.way2 == 1 then
                           yaw = menu.aa.builder.defensive[enums.aa.def_state].way1:get()
                        end
                        if enums.aa.way2 == 2 then
                           yaw = menu.aa.builder.defensive[enums.aa.def_state].way2:get()
                        end
                        if enums.aa.way2 == 3 then
                           yaw = menu.aa.builder.defensive[enums.aa.def_state].way3:get()
                        end
                        if enums.aa.way2 == 4 then
                           yaw = menu.aa.builder.defensive[enums.aa.def_state].way4:get()
                        end
                        if enums.aa.way2 == 5 then
                           yaw = menu.aa.builder.defensive[enums.aa.def_state].way5:get()
                        end
                     end
                  end
               end
               menu.refs.aa.pitch[1]:set(menu.aa.builder.defensive[enums.aa.def_state].pitch:get())
               menu.refs.aa.pitch[2]:set(menu.aa.builder.defensive[enums.aa.def_state].custom_pitch:get())
               menu.refs.aa.yawbase:set(menu.aa.builder.defensive[enums.aa.def_state].yawbase:get())
               menu.refs.aa.yaw[1]:set(menu.aa.builder.defensive[enums.aa.def_state].yaw:get())
               menu.refs.aa.yaw[2]:set(yaw)
               menu.refs.aa.jitter[1]:set(menu.aa.builder.defensive[enums.aa.def_state].yawjitter:get())
               menu.refs.aa.jitter[2]:set(menu.aa.builder.defensive[enums.aa.def_state].jiiter:get())
               menu.refs.aa.freestandbody:set(menu.aa.builder.defensive[enums.aa.def_state].freestandingbody:get())

               if (menu.aa.builder.defensive[enums.aa.def_state].body:get() == "Jitter" and menu.aa.builder.defensive[enums.aa.def_state].yawadd:get() == "Slowed") then
                  menu.refs.aa.body[1]:set("Static")
               else
                  menu.refs.aa.body[1]:set(menu.aa.builder.defensive[enums.aa.def_state].body:get())
               end
               menu.refs.aa.body[2]:set(dsy)
            end
         end
         do
            if menu.aa.helpers:get("No enemies alive AA") and helpers.get_alive_enemies() == 0 then
               menu.refs.aa.pitch[1]:set("Custom")
               menu.refs.aa.pitch[2]:set(0)
               menu.refs.aa.yawbase:set("At targets")
               menu.refs.aa.yaw[1]:set("Spin")
               menu.refs.aa.yaw[2]:set(-60)
               menu.refs.aa.jitter[1]:set("Off")
               menu.refs.aa.body[1]:set("Off")
               e.force_defensive = false
            end
            if menu.aa.helpers:get("Safe head") then
               if (helpers.get_weapon_class() == "CKnife" or helpers.get_weapon_class() == "CWeaponTaser") and enums.aa.in_air then
                  menu.refs.aa.pitch[1]:set("Default")
                  menu.refs.aa.yawbase:set("At targets")
                  menu.refs.aa.yaw[1]:set("180")
                  menu.refs.aa.yaw[2]:set(0)
                  menu.refs.aa.jitter[1]:set("Off")
                  menu.refs.aa.body[1]:set("Static")
                  menu.refs.aa.body[2]:set(0)
               end
            end
            if menu.aa.helpers:get("Anti backstab") then
               local anti_knife_dist = function(x1, y1, z1, x2, y2, z2)
                  return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
               end
               local players = entity.get_players(true)
               local lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
               for i = 1, #players do
                  if players == nil then return end
                  local enemy_orig_x, enemy_orig_y, enemy_orig_z = entity.get_prop(players[i], "m_vecOrigin")
                  local distance_to = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, enemy_orig_x, enemy_orig_y,
                     enemy_orig_z)
                  local weapon = entity.get_player_weapon(players[i])
                  if weapon == nil then return end
                  if entity.get_classname(weapon) == "CKnife" and distance_to <= 200 then
                     menu.refs.aa.yawbase:set("At targets")
                     menu.refs.aa.yaw[1]:set("180")
                     menu.refs.aa.yaw[2]:set(180)
                  end
               end
            end
            if menu.aa.helpers:get("Fast ladder") then
               local pitch, yaw = client.camera_angles()
               if entity.get_prop(entity.get_local_player(), "m_MoveType") == 9 then
                  e.yaw = math.floor(e.yaw + 0.5)
                  e.roll = 0
                  if e.forwardmove == 0 then
                     if e.sidemove ~= 0 then
                        e.pitch = 89
                        e.yaw = e.yaw + 180
                        if e.sidemove < 0 then
                           e.in_moveleft = 0
                           e.in_moveright = 1
                        end
                        if e.sidemove > 0 then
                           e.in_moveleft = 1
                           e.in_moveright = 0
                        end
                     end
                  end
                  if e.forwardmove > 0 then
                     if pitch < 45 then
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

                  if e.forwardmove < 0 then
                     e.pitch = 89
                     e.in_moveleft = 1
                     e.in_moveright = 0
                     e.in_forward = 1
                     e.in_back = 0
                     if e.sidemove == 0 then
                        e.yaw = e.yaw + 90
                     end
                     if e.sidemove > 0 then
                        e.yaw = e.yaw + 150
                     end
                     if e.sidemove < 0 then
                        e.yaw = e.yaw + 30
                     end
                  end
               end
            end
         end
         do
            local left = menu.aa.left:get()
            local right = menu.aa.right:get()
            if left ~= enums.aa.last_left then
               menu.aa.right:set(false)
               if enums.aa.manual == 1 then
                  enums.aa.manual = 0
               else
                  enums.aa.manual = 1
               end
            end
            if right ~= enums.aa.last_right then
               menu.aa.left:set(false)
               if enums.aa.manual == 2 then
                  enums.aa.manual = 0
               else
                  enums.aa.manual = 2
               end
            end
            enums.aa.last_right, enums.aa.last_left = right, left

            if enums.aa.manual == 1 then
               menu.refs.aa.yaw[1]:set("180")
               menu.refs.aa.yaw[2]:set(-90)
               menu.refs.aa.yawbase:set("Local view")
               menu.refs.aa.jitter[1]:set("Off")
               menu.refs.aa.body[1]:set("Opposite")
            end
            if enums.aa.manual == 2 then
               menu.refs.aa.yaw[1]:set("180")
               menu.refs.aa.yaw[2]:set(90)
               menu.refs.aa.yawbase:set("Local view")
               menu.refs.aa.jitter[1]:set("Off")
               menu.refs.aa.body[1]:set("Opposite")
            end

            if menu.aa.freestand:get() and enums.aa.manual == 0 then
               menu.refs.aa.freestand[1]:set(true)
               menu.refs.aa.yaw[1]:set("180")
               menu.refs.aa.yaw[2]:set(90)
               menu.refs.aa.yawbase:set("Local view")
               menu.refs.aa.jitter[1]:set("Off")
               menu.refs.aa.body[1]:set("Static")
               menu.refs.aa.body[2]:set(-180)
            end
         end
      end,
      jumpscout_hande = function(cmd)
         if menu.misc.animbreakers:get() then
            if menu.misc.state:get("Ground") then
               if menu.misc.ground:get() == "Jitter" then
                  menu.refs.global.legs:set(cmd.command_number % 3 == 0 and "Never slide" or "Always slide")
               end
            end
         end
         if not menu.misc.helpers:get("Jumpscout fix") then return end
         menu.refs.global.autostrafe:override(not enums.aa.should_scout)
      end
   }
   callbacks.pre_render = {
      breakers = function()
         local self = entity.get_local_player()
         if not self or not entity.is_alive(self) then
            return
         end
         local self_index = c_entity.new(self)
         local self_anim_state = self_index:get_anim_state()
         local x_velocity = entity.get_prop(self, "m_vecVelocity[0]")
         if not menu.misc.animbreakers:get() then return end
         if menu.misc.state:get("Ground") then
            if menu.misc.ground:get() == "Static" then
               entity.set_prop(self, "m_flPoseParameter", E_POSE_PARAMETERS.STAND, 0)
               menu.refs.global.legs:set("Always slide")
            end
            if menu.misc.ground:get() == "Jitter" then
               entity.set_prop(self, "m_flPoseParameter", E_POSE_PARAMETERS.STAND,
                  globals.tickcount() % 3 == 0 and 0 or 1)
               --  menu.refs.global.legs:set("Always slide")
            end
            if menu.misc.ground:get() == "Moonwalk" then
               entity.set_prop(self, "m_flPoseParameter", 0.5, 7)
               menu.refs.global.legs:set("Never slide")
            end
         end
         if menu.misc.state:get("Air") then
            if menu.misc.air:get() == "Static" then
               entity.set_prop(self, "m_flPoseParameter", 1, E_POSE_PARAMETERS.JUMP_FALL)
            end
            if menu.misc.air:get() == "Jitter" then
               entity.set_prop(self, "m_flPoseParameter", globals.tickcount() % 3 == 0 and 1 or 0,
                  E_POSE_PARAMETERS.JUMP_FALL)
            end
            local layer6 = self_index:get_anim_overlay(6)
            if not layer6 then
               return
            end
            if menu.misc.air:get() == "Walking" then
               if (enums.aa.def_state == 4) or (enums.aa.def_state == 5) then
                  layer6.weight = 1
               end
            end
         end
         if menu.misc.state:get("Misc") then
            local layer12 = self_index:get_anim_overlay(12)
            if not layer12 then return end
            if menu.misc.misc:get("Body lean") then
               if math.abs(x_velocity) > 3 and not menu.misc.misc:get("Eatherquake") then
                  layer12.weight = menu.misc.lean:get() / 100
               end
            end
            if menu.misc.misc:get("Eatherquake") then
               layer12.weight = math.random(0, menu.misc.lean:get())  / 100
            end
         end
      end
   };
   callbacks.shot = {
      hit = {
         fa = function(e)
            local hitgroup_names = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg",
               "right leg", "neck", "?", "gear" };
            local clr = helpers.to_hex(150, 200, 60, 255)
            local text = string.format("Hit \a%s%s\aFFFFFFFF for \a%s%s\aFFFFFFFF in \a%s%s \aFFFFFFFF(%s remaining)",
               clr, entity.get_player_name(e.target), clr, e.damage, clr, hitgroup_names[e.hitgroup + 1] or "?",
               entity.get_prop(e.target, "m_iHealth"))
            notify.add(text)
         end
      },
      miss = {
         fa = function(e)
            local hitgroup_names = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg",
               "right leg", "neck", "?", "gear" }
            local clr = helpers.to_hex(255, 90, 90, 255)
            local text = string.format("Missed \a%s%s \aFFFFFFFFin \a%s%s\aFFFFFFFF due to \a%s%s", clr,
               entity.get_player_name(e.target), clr, hitgroup_names[e.hitgroup + 1], clr, e.reason)
            notify.add(text)
         end
      },
      shoot = {
         fa = function(e)
            local hitgroup_names = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg",
               "right leg", "neck", "?", "gear" }
         end
      },
   }
end
callbacks.setup = function(self)
   for _, f in pairs(self.menu) do
      client.set_event_callback("paint_ui", f)
   end
   for _, f in pairs(self.pre_render) do
      client.set_event_callback("pre_render", f)
   end
   for _, f in pairs(self.paint) do
      client.set_event_callback("paint", f)
   end
   for _, f in pairs(self.createmove) do
      client.set_event_callback("setup_command", f)
   end
   for _, f in pairs(self.shot.hit) do
      client.set_event_callback("aim_hit", f)
   end
   for _, f in pairs(self.shot.miss) do
      client.set_event_callback("aim_miss", f)
   end
   client.set_event_callback("net_update_end", updates.net)
end
--callbacks:setup()
--local to_save = {menu.misc, menu.aa, menu.global, menu.vis}

ffi.cdef [[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);

    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct
    {
        char pad20[24];
        uint32_t m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        char pad20[8];
        float m_flCycle;
        void *m_pOwner;
        char pad_0038[ 4 ];
    } animation_layer_t;

    typedef struct
    {
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    } anim_state_t;
    typedef struct
    {
        char   pad0[0x14];             //0x0000
        bool        bProcessingMessages;    //0x0014
        bool        bShouldDelete;          //0x0015
        char   pad1[0x2];              //0x0016
        int         iOutSequenceNr;         //0x0018 last send outgoing sequence number
        int         iInSequenceNr;          //0x001C last received incoming sequence number
        int         iOutSequenceNrAck;      //0x0020 last received acknowledge outgoing sequence number
        int         iOutReliableState;      //0x0024 state of outgoing reliable data (0/1) flip flop used for loss detection
        int         iInReliableState;       //0x0028 state of incoming reliable data
        int         iChokedPackets;         //0x002C number of choked packets
    } INetChannel; // Size: 0x0444

    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef int BOOL;
    typedef long LONG;
    typedef unsigned long HWND;
    typedef struct{
        LONG x, y;
    }POINT, *LPPOINT;
    typedef unsigned long DWORD, *PDWORD, *LPDWORD;

    typedef struct {
        DWORD  nLength;
        void* lpSecurityDescriptor;
        BOOL   bInheritHandle;
    } SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;

    short GetAsyncKeyState(int vKey);
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
]]

menu:setup()
callbacks:setup()
notify.add("impulse loaded. have fun!")
local to_save = { menu.misc, menu.aa, menu.global, menu.vis, menu.aa.builder[1], menu.aa.builder[2], menu
    .aa.builder[3], menu.aa.builder[4], menu.aa.builder[5], menu.aa.builder[6], menu.aa.builder[7], menu
    .aa.builder.defensive[1], menu.aa.builder.defensive[2], menu.aa.builder.defensive[3], menu.aa.builder
    .defensive[4], menu.aa.builder.defensive[5], menu.aa.builder.defensive[6], menu.aa.builder.defensive
    [7] }
config.import = function(imp)
   local cfg = pui.setup(to_save)
   local decrypted = json.parse(base64.decode(imp))
   cfg:load(decrypted)
end

config.export = function()
   local cfg = pui.setup(to_save)
   local data = cfg:save()
   print(json.stringify(data))
   local encrypted = base64.encode(json.stringify(data))
   clipboard.set(encrypted)
end