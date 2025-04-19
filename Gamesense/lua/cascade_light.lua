-- ? libraries
local vector = require 'vector';

-- ? defines
local bit_band, bit_rshift = bit.band, bit.rshift;
local math_floor = math.floor;
local f = string.format;
local ui_set_callback, ui_new_checkbox, ui_new_slider, ui_new_label, ui_new_color_picker, ui_get, ui_set_visible, ui_set_callback = ui.set_callback, ui.new_checkbox, ui.new_slider, ui.new_label, ui.new_color_picker, ui.get, ui.set_visible, ui.set_callback;
local entity_get_all, entity_get_prop, entity_set_prop, entity_get_local_player = entity.get_all, entity.get_prop, entity.set_prop, entity.get_local_player;
local client_userid_to_entindex, client_set_event_callback = client.userid_to_entindex, client.set_event_callback;
local globals_tickinterval, globals_frametime = globals.tickinterval, globals.frametime;

local int32_to_rgb = function(int32)
  if not int32 then
    return
  end

  local limit = 0xff;

  local r = bit_band(bit_rshift(int32, 16), limit);
  local g = bit_band(bit_rshift(int32, 8), limit);
  local b = bit_band(int32, limit);

  return r, g, b
end

local rgb_to_int32 = function(r, g, b)
  return r * (256 * 256) + g * 256 + b;
end

local int = function(x)
  return math_floor(x + 0.5)
end

local math_clamp = function(x, min, max)
  if min > max then
    min, max = max, min;
  end

  if min > x then
    return min
  end

  if x > max then
    return max
  end

  return x
end

local math_lerp = function(a, b, percent)
  return a + (b - a) * percent
end

local menu = {};
local cascade = {};
local backup = nil;

cascade.get = function()
  return entity_get_all 'CCascadeLight' [ 1 ];
end

cascade.get_options = function(ent)
  if not ent then
    return {
      direction = {},
    }
  end

  return {
    direction = vector(entity_get_prop(ent, 'm_envLightShadowDirection')),
    distance = entity_get_prop(ent, 'm_flMaxShadowDist'),
    color = entity_get_prop(ent, 'm_LightColor')
  }
end

local available = cascade.get_options(cascade.get());
local shadow_color = {int32_to_rgb(available.color)} or {164, 211, 251};

menu.set_callback = function(item, callback, force)
  ui_set_callback(item, callback);

  if not force then
    return
  end
  
  callback(item);
end

menu.master = ui_new_checkbox('LUA', 'A', 'Cascade light');
menu.lerp = ui_new_checkbox('LUA', 'A', 'Allow linear-interpolation', true);
menu.x = ui_new_slider('LUA', 'A', 'X direction', -180, 180, available.direction.x or 2, true, '°');
menu.y = ui_new_slider('LUA', 'A', 'Y direction', -180, 180, available.direction.y or 0, true, '°');
menu.z = ui_new_slider('LUA', 'A', 'Z direction', -180, 180, available.direction.z or 0, true, '°');
menu.distance = ui_new_slider('LUA', 'A', 'Light distance', 0, 1200, available.distance or 400, true, 'ft');
menu.enable_color = ui_new_checkbox('LUA', 'A', 'Enable color modulation');
menu.color_picker = ui_new_color_picker('LUA', 'A', 'Color modulating', unpack(shadow_color));

cascade.set = function(list)
  local ent = cascade.get();

  if not ent then
    return
  end

  list = list or {};
  list.direction = list.direction or vector(ui_get(menu.x), ui_get(menu.y), ui_get(menu.z));
  list.distance = list.distance or ui_get(menu.distance);

  local options = cascade.get_options(ent);

  if list.lerp then
    local frametime = globals_frametime();
    local animtime = math_clamp(frametime * 175 * 0.095, 0, 1);

    list.direction = options.direction:lerp(list.direction, animtime)
    list.distance = math_lerp(options.distance, list.distance, animtime);
  end

  entity_set_prop(ent, 'm_envLightShadowDirection', list.direction.x, list.direction.y, list.direction.z);
  entity_set_prop(ent, 'm_flMaxShadowDist', list.distance);

  if not list.color then
    return
  end

  entity_set_prop(ent, 'm_LightColor', list.color);
end

cascade.backup = function()
  if backup ~= nil then
    return
  end

  local ent = cascade.get();
  
  if not ent then
    return
  end

  backup = cascade.get_options(ent);

  if not ui_get(menu.enable_color) then
    backup.color = nil;
  end
end

cascade.restore = function()
  if backup == nil then
    return
  end

  cascade.set(backup);
  backup = nil;
end

cascade.pre_render = function()
  if not ui_get(menu.master) then
    return
  end

  cascade.backup();
  cascade.set {
    lerp = ui_get(menu.lerp),
    color = ui_get(menu.enable_color) and rgb_to_int32(ui_get(menu.color_picker))
  };
end

cascade.player_connect_full = function(e)
  local lp = entity_get_local_player();

  if client_userid_to_entindex(e.userid) ~= lp then
    return
  end

  cascade.restore();
end

menu.set_callback(menu.master, function(self)
  local state = ui_get(self);

  for k, v in ipairs {'lerp', 'x', 'y', 'z', 'distance', 'enable_color', 'color_picker'} do
    ui_set_visible(menu[ v ], state);
  end

  if not state then
    cascade.restore();
  end
end, true);

menu.set_callback(menu.enable_color, function(self)
  if not backup then
    return
  end

  local state = ui_get(self);

  if state then
    return
  end

  cascade.set {
    color = backup.color
  };
end);

client_set_event_callback('pre_render', cascade.pre_render);
client_set_event_callback('shutdown', cascade.restore);
client_set_event_callback('player_connect_full', cascade.player_connect_full);
client_set_event_callback('level_init', cascade.restore);