-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local pui = require("neverlose/pui");
local clipboard = require("neverlose/clipboard");
local gradient = require("neverlose/gradient");
local base64 = require("neverlose/base64");
local helpers = {}; do
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
   helpers.gradient = function(s, clock, clr1, clr2)
      local buffer = {}

      local len = #helpers.u8(s)
      local div = 1 / (len - 1)

      local add_r = clr2.r - clr1.r
      local add_g = clr2.g - clr1.g
      local add_b = clr2.b - clr1.b
      local add_a = clr2.a - clr1.a

      for char in string.gmatch(s, ".[\128-\191]*") do
         local t = helpers.breath(clock)

         local r = clr1.r + add_r * t
         local g = clr1.g + add_g * t
         local b = clr1.b + add_b * t
         local a = clr1.a + add_a * t

         buffer[#buffer + 1] = "\a"
         buffer[#buffer + 1] = helpers.to_hex(r, g, b, a)
         buffer[#buffer + 1] = char

         clock = clock - div
      end

      return table.concat(buffer)
   end
end

local anim = {}; do
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

      local animation = globals.frametime * (bool and 1 or -1) * (time or 4)
      self.data[name] = math.clamp(self.data[name] + animation, 0, 1)
      return self.data[name]
   end

   anim.flerp = function(self, start, end_, speed, delta)
      if (math.abs(start - end_) < (delta or 0.01)) then
         return end_
      end
      speed = speed or 0.095
      local time = globals.frametime * (175 * speed)
      return ((end_ - start) * time + start)
   end
end

local defensive = {}; do
   defensive.ticks = 0;
   defensive.max_tickbase = 0;
   defensive.current_cmd = 0;
   defensive.dif = 0;
   events.createmove:set(function(cmd)
      defensive.current_cmd = cmd.command_number
   end)
   events.createmove:set(function(cmd)
     local me = entity.get_local_player()
      if not me or not me:is_alive() then return 0 end
      local tickcount = globals.tickcount
      local tickbase = me.m_nTickBase or 0
      local exploit = tickcount > tickbase

      if math.abs(tickbase - defensive.max_tickbase) > 64 and exploit then
         defensive.max_tickbase = 0
      end

      if tickbase > defensive.max_tickbase then
         defensive.max_tickbase = tickbase
      elseif defensive.max_tickbase > tickbase then
         defensive.ticks = exploit and math.min(14, math.max(0, defensive.max_tickbase - tickbase - 1)) or 0
      end
       return tickbase and defensive.ticks or 0
   end)
end
local refs = {
   pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
   yawbase = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
   yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
   base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
   yawoffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
   avoidbackstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
   hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
   yawmodifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
   yawmodifieroffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
   bodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
   bodyyaw_invert = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
   bodyyaw_leftlimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
   bodyyaw_rightlimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
   bodyyaw_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
   bodyyaw_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
   freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
   antiuntrusted = ui.find("Miscellaneous", "Main", "Other", "Anti Untrusted"),
   lagoptions = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
   hideshotsoptions = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
   doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
   hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
   immediateteleport = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Immediate Teleport"),
   fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
   mindamage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
   fakeping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
   dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
   safepoint = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
   bodyaim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
   slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
   limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
   variability = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"),
   leg = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
};

local state = {}; do
   state.global = { "Global", "Standing", "Moving", "Air", "Air-crouch", "Crouch", "Crouch-moving", "Slowwalking",
      "Manuals" };
   state.menu = { " ", "  ", "   ", "    ", "     ", "      ", "       ", "        ", "         " }
end
local cfg = {}
local menu = {}; do
   local link = pui.get_style("Link Active");
   local bar = pui.get_style("Sidebar Text");
   events.render:set(function ()
      pui.sidebar(helpers.gradient("impulse", globals.realtime, link, bar), "✦");
   end)
   local gr = {}
   gr.welcome = pui.create("✦Global", "✦ Welcome");
   gr.other = pui.create("✦Global", "✦ Other");
   gr.antiaim = pui.create("✦Anti-Aim", "✦ Anti-aim");
   gr.builder = pui.create("✦Anti-Aim", "✦ Builder");
   gr.antiaim_other = pui.create("✦Anti-Aim", "✦ Other");
   gr.visuals = pui.create("✦ Other", "✦ Visuals");
   gr.miscellaneous = pui.create("✦ Other", "✦ Miscellaneous")
   menu.global = {}; do
      menu.global.icon = gr.welcome:texture(render.load_image(network.get("https://github.com/L3V1Y/impulse/blob/main/4258bfe560075a23da79ca49217973ec.jpg?raw=true", {}), vector(269,269)), nil, nil, nil, 6 );
      menu.global.hello = gr.welcome:label(string.format("Welcome back, %s!\nCurrent build: Stable", common.get_username()));
      menu.global.config = gr.welcome:button("My Neverlose Config", function ()
         panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/gPuDHUpd7J")
      end)

      menu.global.export = gr.other:button(ui.get_icon("file-export"), function ()
         local raw = pui.save()
         clipboard.set(base64.encode(json.stringify(raw)))
      end):tooltip("Export Config")
      menu.global.import = gr.other:button(ui.get_icon("file-import"), function ()
         local raw = clipboard.get()
         pui.load(base64.decode(json.parse(raw)))
      end):tooltip("Import Config")
      menu.global.default = gr.other:button(ui.get_icon("file")):tooltip("Default Config")
      menu.global.breakers = gr.miscellaneous:switch("Animation breakers", false, function(gear)
         return {
            ground = gear:combo("Ground", { "-", "Static", "Jitter", "Moonwalk", "Kangaroo" }),
            air = gear:combo("Air", { "-", "Static", "Jitter", "Walking", "Kangaroo" }),
            movelean = gear:slider("Movelean", 0, 100, 0)
         }
      end);
      menu.global.lag = gr.miscellaneous:switch("Adaptive fake-lag", false, function(gear)
         return {
            start = gear:slider("Start", 1, 14, 1),
            endd = gear:slider("End", 1, 14, 14),
            var = gear:slider("Variability", 0, 100, 0)
         }
      end)
   end

   menu.aa = {}; do
      menu.aa.state = gr.builder:combo("\n", state.global);

      menu.aa.selection = gr.antiaim:list("Buider mode", { "Default", "Defensive" });
      menu.aa.manuals = gr.antiaim_other:combo("Yaw base", { "At target", "Left", "Right", "Forward" });
      menu.aa.freestand = gr.antiaim_other:switch("Freestanding", false);
   end
   menu.aa.builder = { defensive = {} }; do
      for i = 1, #state.global do
         menu.aa.builder[i] = {
            enable = gr.builder:switch(string.format("Enable %s", state.menu[i])),
            pitch = gr.builder:combo(string.format("Pitch %s", state.menu[i]),
               { "Disabled", "Down", "Fake Down", "Fake Up" }),
            yaw = gr.builder:combo(string.format("Yaw %s", state.menu[i]), { "Disabled", "Backward", "Static" },
               function(gear)
                  return {
                     mode = gear:combo("Yaw mode", { "Static", "L/R", "Slowed", "X-Way" }),
                     static = gear:slider("Static", -180, 180, 0),
                     left = gear:slider("Left", -180, 180, 0),
                     right = gear:slider("Right", -180, 180, 0),
                     ticks = gear:slider("Ticks", 1, 12, 0),
                     ways = gear:slider("Way", 2, 6),
                     way1 = gear:slider("Way 1", -180, 180, 0),
                     way2 = gear:slider("Way 2", -180, 180, 0),
                     way3 = gear:slider("Way 3", -180, 180, 0),
                     way4 = gear:slider("Way 4", -180, 180, 0),
                     way5 = gear:slider("Way 5", -180, 180, 0),
                     way6 = gear:slider("Way 6", -180, 180, 0),
                  }
               end),
            yawmodifier = gr.builder:combo(string.format("Yaw Modifier %s", state.menu[i]),
               { "Off", "Center", "Offset", "Spin", "Skitter" }, function(gear)
                  return {
                     offset = gear:slider("Offset", -180, 180, 0),
                     randomisation = gear:slider("Randomisation", -180, 180, 0)
                  }
               end),
            fake = gr.builder:switch(string.format("Body Yaw %s", state.menu[i]), false, function(gear)
               return {
                  left = gear:slider("Left Limit", 0, 60),
                  right = gear:slider("Right Limit", 0, 60),
                  options = gear:selectable("Options", { "Jitter", "Randomize Jitter" }),
                  peek = gear:combo("Peek mode", {"Off", "Peek Fake", "Peek Real"}),
               }
            end)
         }
         menu.aa.builder.defensive[i] = {
            force = gr.builder:selectable(string.format("Force defensive %s", state.menu[i]),
               { "Double Tap", "Hide Shots" }),
            enable = gr.builder:switch(string.format("Enable %s", state.menu[i])),
            start = gr.builder:slider(string.format("Start tick %s", state.menu[i]), 0, 6, 0, 1, function(e)
               if e == 0 then return "Default" end
               if e == 3 then return "Breakable" end
               if e == 6 then return "Largest" end
            end),
            endd = gr.builder:slider(string.format("End tick %s", state.menu[i]), 7, 13, 0, 1, function(e)
               if e == 7 then return "Predict" end
               if e == 11 then return "Breakable" end
               if e == 13 then return "Largest" end
            end),
            pitch = gr.builder:combo(string.format("Pitch %s", state.menu[i]),
               { "Disabled", "Down", "Fake Down", "Fake Up", "Custom"}, function(gear)
                  return {
                     mode = gear:combo("Type", {"Static", "Random"});
                     base = gear:slider("Value", -89, 89, 0);
                  }
               end),
            yaw = gr.builder:combo(string.format("Yaw %s", state.menu[i]), { "Disabled", "Backward", "Static" },
               function(gear)
                  return {
                     mode = gear:combo("Yaw mode", { "Static", "L/R", "Slowed", "X-Way" }),
                     static = gear:slider("Static", -180, 180, 0),
                     left = gear:slider("Left", -180, 180, 0),
                     right = gear:slider("Right", -180, 180, 0),
                     ticks = gear:slider("Ticks", 1, 12, 0),
                     ways = gear:slider("Way", 2, 6),
                     way1 = gear:slider("Way 1", -180, 180, 0),
                     way2 = gear:slider("Way 2", -180, 180, 0),
                     way3 = gear:slider("Way 3", -180, 180, 0),
                     way4 = gear:slider("Way 4", -180, 180, 0),
                     way5 = gear:slider("Way 5", -180, 180, 0),
                     way6 = gear:slider("Way 6", -180, 180, 0),
                  }
               end),
            yawmodifier = gr.builder:combo(string.format("Yaw Modifier %s", state.menu[i]),
               { "Off", "Center", "Offset", "Spin", "Skitter" }, function(gear)
                  return {
                     offset = gear:slider("Offset", -180, 180, 0),
                     randomisation = gear:slider("Randomisation", -180, 180, 0)
                  }
               end),
            fake = gr.builder:switch(string.format("Body Yaw %s", state.menu[i]), false, function(gear)
               return {
                  left = gear:slider("Left Limit", 0, 60),
                  right = gear:slider("Right Limit", 0, 60),
                  options = gear:selectable("Options", { "Jitter", "Randomize Jitter" }),
                  peek = gear:combo("Peek mode", {"Off", "Peek Fake", "Peek Real"}),
               }
            end)
         }
      end
   end
   menu.misc = {}; do
      menu.misc.accent = gr.visuals:label("Accent color", color())
      menu.misc.indicators = gr.visuals:switch("Under crosshair indicators", false);
      menu.misc.indicators_cog = menu.misc.indicators:create();
      menu.misc.indicators_font = menu.misc.indicators_cog:combo("Indicators font", { "Pixel", "Default" })
      menu.misc.indicators_y = menu.misc.indicators_cog:slider("Y add", 0, 250);
   end
   menu.visibility = function()
      for i = 1, #state.global do
         local builder = menu.aa.builder[i]
         builder.enable:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 1 });
         builder.pitch:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 1 }, { builder.enable, true });
         builder.yaw:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 1 }, { builder.enable, true });
         builder.yaw.static:depend({ builder.yaw.mode, "Static" })
         builder.yaw.left:depend({ builder.yaw.mode, function()
            return builder.yaw.mode:get() == "L/R" or builder.yaw.mode:get() == "Slowed"
         end })
         builder.yaw.right:depend({ builder.yaw.mode, function()
            return builder.yaw.mode:get() == "L/R" or builder.yaw.mode:get() == "Slowed"
         end })
         builder.yaw.ticks:depend({ builder.yaw.mode, "Slowed" })
         builder.yaw.ways:depend({ builder.yaw.mode, "X-Way" })
         builder.yaw.way1:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 2
         end })
         builder.yaw.way2:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 2
         end })
         builder.yaw.way3:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 3
         end })
         builder.yaw.way4:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 4
         end })
         builder.yaw.way5:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 5
         end })
         builder.yaw.way6:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 6
         end })
         builder.yawmodifier:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 1 },
            { builder.enable, true });
         builder.fake:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 1 }, { builder.enable, true });

         local builder = menu.aa.builder.defensive[i]
         builder.enable:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 2 });
         builder.force:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 2 });
         builder.start:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 2 }, { builder.enable, true });
         builder.endd:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 2 }, { builder.enable, true });
         builder.pitch:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 2 }, { builder.enable, true });
         builder.yaw:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 2 }, { builder.enable, true });
         builder.yaw.static:depend({ builder.yaw.mode, "Static" })
         builder.yaw.left:depend({ builder.yaw.mode, function()
            return builder.yaw.mode:get() == "L/R" or builder.yaw.mode:get() == "Slowed"
         end })
         builder.yaw.right:depend({ builder.yaw.mode, function()
            return builder.yaw.mode:get() == "L/R" or builder.yaw.mode:get() == "Slowed"
         end })
         builder.yaw.ticks:depend({ builder.yaw.mode, "Slowed" })
         builder.yaw.ways:depend({ builder.yaw.mode, "X-Way" })
         builder.yaw.way1:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 2
         end })
         builder.yaw.way2:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 2
         end })
         builder.yaw.way3:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 3
         end })
         builder.yaw.way4:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 4
         end })
         builder.yaw.way5:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 5
         end })
         builder.yaw.way6:depend({ builder.yaw.mode, "X-Way" }, { builder.yaw.ways, function()
            return builder.yaw.ways:get() >= 6
         end })
         builder.yawmodifier:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 2 },
            { builder.enable, true });
         builder.fake:depend({ menu.aa.state, state.global[i] }, { menu.aa.selection, 2 }, { builder.enable, true });
      end
   end
   menu.visibility()
end

--[[ menu.global = {}; do

   end

   menu.aa = {}; do
      menu.aa.state = gr.builder:combo("\n", state.global);

      menu.aa.selection = menu.antiaim:list("Buider mode", { "Default", "Defensive" });
      menu.aa.manuals = menu.antiaim_other:combo("Yaw base", { "At target", "Left", "Right", "Forward" });
      menu.aa.freestand = menu.antiaim_other:switch("Freestanding", false);
   end
   menu.aa.builder = { defensive = {} }; do
      for i = 1, #state.global do
         menu.aa.builder[i] = {
         
         }
         menu.aa.builder.defensive[i] = {
          
         }
      end
   end
   menu.misc = {}; do

   end]]
pui.setup(menu)
--local to_save = {menu.global}
local antiaim = {
   spin = 0,
   command_number = 0,
   ticks = 0,
   inverted = false,
   in_air = false,
   air_tick = 0,
   state = 1,
   way = 0,
   skitter = 0,
}

local update = {}; do
   update.choke_bool = false;
   update.side = -1;
   update.packets = 0;
   update.defensive = 0;
   events.net_update_end:set(function()
      local chokedcommands = globals.choked_commands
      if chokedcommands == 0 then
         update.packets = update.packets + 1
         update.side = update.side * -1
         update.choke_bool = not update.choke_bool
      end
      --update.defensive = defensive.ticks > 2--menu.aa.builder.defensive[antiaim.state].start:get() and defensive.ticks < menu.aa.builder.defensive[antiaim.state].endd:get()
   end)
end

events.createmove_run:set(function ()
   update.defensive = defensive.ticks > menu.aa.builder.defensive[antiaim.state].start:get() and defensive.ticks < menu.aa.builder.defensive[antiaim.state].endd:get()
end)







local screen = render.screen_size() * 0.5;

events.render:set(function(ctx)
   if not menu.misc.indicators:get() then return end
   local me = entity.get_local_player()
   if not me or not me:is_alive() then return end
   local clr = menu.misc.accent.color.value
   local r1, g1, b1, a1 = anim.lerp({ 255, 90, 90, 55 }, { clr.r, clr.g, clr.b, 255 }, rage.exploit:get())
   local damage = false
   local hitchance = false
   for i in pairs(ui.get_binds()) do
      if ui.get_binds()[i].name == "Min. Damage" then
         damage = ui.get_binds()[i].active
      end
      if ui.get_binds()[i].name == "Hit Chance" then
         hitchance = ui.get_binds()[i].active
      end
   end
   local list = {
      {
         name = "DOUBLETAP",
         ref = refs.doubletap:get(),
         anim = 0,
         index = 0,
         r = clr.r,
         g = clr.g,
         b = clr.b,
         a = a1
      },
      {
         name = "HIDESHOT",
         ref = refs.hideshots:get(),
         anim = 0,
         index = 0,
         r = clr.r,
         g = clr.g,
         b = clr.b,
         a = 255
      },
      {
         name = "HITCHANCE",
         ref = hitchance,
         anim = 0,
         index = 0,
         r = clr.r,
         g = clr.g,
         b = clr.b,
         a = 255
      },
      {
         name = "DAMAGE",
         ref = damage,
         anim = 0,
         index = 0,
         r = clr.r,
         g = clr.g,
         b = clr.b,
         a = 255
      },
   };
   local scoped = me.m_bIsScoped;
   local scoped_anim = anim:process("Scoped indicators", scoped, 13);
   local add = 30 * scoped_anim;
   local ay = 0;
   local y_add = menu.misc.indicators_y:get()
   local font = menu.misc.indicators_font:get() == "Pixel" and 2 or 1
   local text = helpers.gradient("IMPULSE", globals.realtime, color(100, 100, 100, 255), clr);
   render.text(font, vector(screen.x + add, screen.y + 15 + y_add), color(255, 255, 255), "c",
      font == 1 and string.format("%s\a%s%s", text, clr:to_hex(), "SUN"):lower() or
      string.format("%s\a%s%s", text, clr:to_hex(), "SUN"))

   for k, v in ipairs(list) do
      v.alpha = anim:process(k, v.ref, 13);
      v.lenght = #v.name;
      v.index = v.lenght * v.alpha;
      v.anim = v.index % (v.lenght * 2);
      v.sub = font == 1 and string.sub(v.name, 1, v.index):lower() or string.sub(v.name, 1, v.index);
      v.scope = (render.measure_text(font, nil, v.sub).x / 2 - (font == 1 and 27 or 24)) *
          scoped_anim;

      render.text(font, vector(screen.x + add + v.scope, screen.y + y_add + (font == 1 and 25 or 24) + ay),
         color(v.r, v.g, v.b, v.a), "c",
         font == 1 and tostring(v.sub):lower() or tostring(v.sub))
      ay = ay + (font == 1 and 10 or 9) * v.alpha
   end
end)

events.render:set(function(ctx)
   local clr = menu.misc.accent.color.value
   local wm = helpers.gradient("✦ i m p u l s e", globals.realtime, color(100, 100, 100, 200), clr)
   render.text(4, vector(screen.x, render.screen_size().y - 15), color(), "c", wm)
end)



events.createmove:set(function(cmd)
   if not entity.get_local_player() then return end
   local velocity = (entity.get_local_player().m_vecVelocity):length();
   local flag = entity.get_local_player().m_fFlags;
   local duck = entity.get_local_player().m_bDucked;
   if flag == 256 or flag == 262 then
      antiaim.in_air = true
      antiaim.air_tick = globals.tickcount + 3
   else
      antiaim.in_air = (antiaim.air_tick > globals.tickcount) and true or false
   end

   if velocity < 5 then
      antiaim.state = 2
   else
      antiaim.state = 3
   end
   if refs.slowwalk:get() then
      antiaim.state = 8
   end
   if duck then
      antiaim.state = 6
      if velocity > 15 then
         antiaim.state = 7
      end
   end
   if antiaim.in_air then
      antiaim.state = 4
   end
   if antiaim.in_air then
      if duck then
         antiaim.state = 5
      end
   end
   if not menu.aa.builder[antiaim.state].enable:get() then antiaim.state = 1 end
   rage.antiaim:override_hidden_yaw_offset(0)
   local start, endd = menu.aa.builder.defensive[antiaim.state].start:get(),
       menu.aa.builder.defensive[antiaim.state].endd:get()
   local aa = (update.defensive and menu.aa.builder.defensive[antiaim.state].enable:get() and (refs.doubletap:get() or refs.hideshots:get())) and
   menu.aa.builder.defensive[antiaim.state] or menu.aa.builder[antiaim.state]
   if menu.aa.builder.defensive[antiaim.state].force:get(1) then
      refs.lagoptions:override("Always On")
      rage.exploit:allow_defensive(true)
   else
      refs.lagoptions:override()
   end
   if menu.aa.builder.defensive[antiaim.state].force:get(1) then
      rage.exploit:allow_defensive(true)
      refs.hideshotsoptions:override("Break LC")
   else
      refs.hideshotsoptions:override()
   end
   local yaw = 0;
   local jitter = 0;
   local flip = false;
   if globals.choked_commands == 0 then
      antiaim.way = antiaim.way + 1
      if antiaim.way > aa.yaw.ways:get() then antiaim.way = 1 end
      antiaim.skitter = antiaim.skitter + 1
      if antiaim.skitter > 3 then antiaim.skitter = 1 end
   end;
   if aa.yaw.mode:get() == "Static" then
      antiaim.inverted = update.choke_bool
      yaw = aa.yaw.static:get()
   end
   if aa.yaw.mode:get() == "L/R" then
      antiaim.inverted = update.choke_bool
      yaw = antiaim.inverted and aa.yaw.left:get() or aa.yaw.right:get()
   end
   if aa.yaw.mode:get() == "Slowed" then
      antiaim.inverted = (update.packets % (aa.yaw.ticks:get() * 2)) >= aa.yaw.ticks:get()
      yaw = antiaim.inverted and aa.yaw.left:get() or aa.yaw.right:get()
   end
   if aa.yaw.mode:get() == "X-Way" then
      antiaim.inverted = update.choke_bool
      yaw = antiaim.way == 1 and aa.yaw.way1:get() or antiaim.way == 2 and aa.yaw.way2:get() or
      antiaim.way == 3 and aa.yaw.way3:get() or antiaim.way == 4 and aa.yaw.way4:get() or
      antiaim.way == 5 and aa.yaw.way5:get() or antiaim.way == 6 and aa.yaw.way6:get()
   end

   if aa.yawmodifier:get() == "Center" then
      jitter = antiaim.inverted and -aa.yawmodifier.offset:get() / 2 or aa.yawmodifier.offset:get() / 2
   end
   if aa.yawmodifier:get() == "Offset" then
      jitter = antiaim.inverted and 0 or aa.yawmodifier.offset:get()
   end
   if aa.yawmodifier:get() == "Spin" then
      if globals.choked_commands == 0 then
         antiaim.spin = antiaim.spin + 25
         if antiaim.spin >= math.abs(aa.yawmodifier.offset:get()) then
            antiaim.spin = -math.abs(aa.yawmodifier.offset:get())
         end
      end;
      jitter = antiaim.spin
   end
   if aa.yawmodifier:get() == "Skitter" then
      jitter = antiaim.skitter == 1 and -aa.yawmodifier.offset:get() / 2 or antiaim.skitter == 2 and 0 or
      antiaim.skitter == 3 and aa.yawmodifier.offset:get() / 2
   end
   if aa.yawmodifier:get() ~= "Off" then
      jitter = jitter + utils.random_int(-aa.yawmodifier.randomisation:get(), aa.yawmodifier.randomisation:get())
   end
   if aa.fake.options:get(2) then
      antiaim.inverted = utils.random_int(0, 1) == 1
   end
   flip = aa.fake.options:get(1) and antiaim.inverted or false
   refs.pitch:override(aa.pitch:get())
   if menu.aa.builder.defensive[antiaim.state].pitch:get() == "Custom" and menu.aa.builder.defensive[antiaim.state].enable:get() then
      if menu.aa.builder.defensive[antiaim.state].pitch.mode:get() == "Static" then
      rage.antiaim:override_hidden_pitch(menu.aa.builder.defensive[antiaim.state].pitch.base:get())
      else
         rage.antiaim:override_hidden_pitch(utils.random_int(-menu.aa.builder.defensive[antiaim.state].pitch.base:get(), menu.aa.builder.defensive[antiaim.state].pitch.base:get()))
      end
   end
   local all = yaw + jitter

   if menu.aa.manuals:get() == "Left" then
      all = -90
      flip = false
   end
   if menu.aa.manuals:get() == "Right" then
      all = 90
      flip = false
   end
   if menu.aa.manuals:get() == "Forward" then
      all = -180
      flip = false
   end
   if menu.aa.freestand:get() then
      all = 0
      flip = false
   end
   refs.freestanding:override(menu.aa.freestand:get())
   refs.yawoffset:override(all)
   refs.yawbase:override(aa.yaw:get())
   refs.base:override(menu.aa.manuals:get() ~= "At target" and "Local View" or "At Target")
   refs.bodyyaw:override(aa.fake:get())
   refs.bodyyaw_leftlimit:override(aa.fake.left:get())
   refs.bodyyaw_rightlimit:override(aa.fake.right:get())
   rage.antiaim:inverter(flip)
   refs.bodyyaw_freestanding:override(aa.fake.peek:get())
end)
events.createmove:set(function(cmd)
   if not menu.global.lag:get() then
      refs.limit:override()
      refs.variability:override()
      return
   end
   refs.limit:override(utils.random_int(menu.global.lag.start:get(), menu.global.lag.endd:get()))
   refs.variability:override(utils.random_int(0, menu.global.lag.var:get()))
end)
ffi.cdef [[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef struct {
        char  pad_0000[20];
        int m_nOrder; //0x0014
        int m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030
        char  pad_0038[4]; //0x0034
    } c_animlayers;
]]

local function this_call(call_function, parameters) return function(...) return call_function(parameters, ...) end end
local entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface("client.dll", "VClientEntityList003"))
local get_entity_address = this_call(ffi.cast("get_client_entity_t", entity_list_003[0][3]), entity_list_003)
function entity.get_anim_layer(b, c)
   c = c or 1; b = ffi.cast(ffi.typeof('void***'), b)
   return ffi.cast('c_animlayers**', ffi.cast('char*', b) + 0x2990)[0][c]
end

events.post_update_clientside_animation:set(function()
   if not menu.global.breakers:get() then return end
   local velocity = (entity.get_local_player().m_vecVelocity):length()
   if menu.global.breakers.ground:get() == "Static" then
      entity.get_local_player().m_flPoseParameter[0] = 1
      refs.leg:override("Sliding")
   end
   if menu.global.breakers.ground:get() == "Jitter" then
      if globals.tickcount % 4 > 1 then
         entity.get_local_player().m_flPoseParameter[0] = 1
      end
      refs.leg:override("Sliding")
   end
   if menu.global.breakers.ground:get() == "Moonwalk" then
      entity.get_local_player().m_flPoseParameter[7] = 1
      refs.leg:override("Walking")
   end
   if menu.global.breakers.ground:get() == "Kangaroo" then
      entity.get_local_player().m_flPoseParameter[3] = math.random(0, 10) / 10
      entity.get_local_player().m_flPoseParameter[7] = math.random(0, 10) / 10
      refs.leg:override("Walking")
   end

   if menu.global.breakers.air:get() == "Static" then
      entity.get_local_player().m_flPoseParameter[6] = 1
   end
   if menu.global.breakers.air:get() == "Jitter" then
      if globals.tickcount % 4 > 1 then
         entity.get_local_player().m_flPoseParameter[6] = 1
      end
   end
   if menu.global.breakers.air:get() == "Walking" then
      if velocity > 5 then
      entity.get_anim_layer(get_entity_address(entity.get_local_player():get_index()), 6).m_flWeight = 1
      end
   end
   if menu.global.breakers.air:get() == "Kangaroo" then
         entity.get_local_player().m_flPoseParameter[6] = math.random(0, 10) / 10
   end
   if velocity >= 3 then
      entity.get_anim_layer(get_entity_address(entity.get_local_player():get_index()), 12).m_flWeight = menu.global.breakers.movelean:get() / 100
   end
end)
