-- creator: @qhouz
-- special for @LazyMind

-- TODO: Try smth with default cfg struct
local ffi    = require 'ffi' or error('Turn on unsecure scripts');
local vector = require 'vector';
local weapon = require 'gamesense/csgo_weapons';
local base64 = require 'gamesense/base64';

local SCRIPT_NAME = 'Senko-Adaptive';

local ffi_types = {};
local ffi_helpers = {};
local ffi_handles = {};
local ffi_classes = {};
local ffi_functions = {};
local ffi_ready_to_use = {};

local defines = (function()
  typeof = type;

  function die(text)
    error(text, 2);
  end

  function hex(r, g, b, a)
    return ('\a%02X%02X%02X%02X'):format(r, g, b, a or 255)
  end
end)();

local spacing = string.rep('\x20', 2);

local info = (function()
  _ui_prefix = string.format('%sSenko %s»%s', hex(169, 169, 95, 255), hex(128, 128, 128, 200), hex(255, 255, 255, 225));
  _general_prefix = string.format('%s%sGeneral %s»%s', spacing, hex(169, 169, 95, 255), hex(128, 128, 128, 200), hex(255, 255, 255, 225));
  _hitscan_prefix = string.format('%s%sHitscan %s»%s', spacing, hex(169, 169, 95, 255), hex(128, 128, 128, 200), hex(255, 255, 255, 225));
  _accuracy_prefix = string.format('%s%sAccuracy %s»%s', spacing, hex(169, 169, 95, 255), hex(128, 128, 128, 200), hex(255, 255, 255, 225));
end)();

local const = (function()
  WEAPON_TAB = {
    'Global',
    'Taser',
    'Auto',
    'Scout',
    'Awp',
    'Pistols',
    'Deagle',
    'R8 revolver',
    'Rifles',
    'Submachine gun',
    'Machine gun',
    'Shotgun',
  };

  TARGET_SELECTION = {
    'Highest damage',
    'Cycle',
    'Cycle (2x)',
    'Near crosshair',
    'Best hit chance',
  };

  HITBOX = {
    'Head',
    'Chest',
    'Stomach',
    'Arms',
    'Legs',
    'Feet',
  };

  PREFER_BODY_DISABLERS = {
    'Low inaccuracy',
    'Target shot fired',
    'Target resolved',
    'Safe point headshot',
  };

  ACCURACY_BOOST = {
    'Low',
    'Medium',
    'High',
    'Maximum',
  };

  BODY_AIM_IF_LETHAL = {
    'Off',
    'Prefer',
    'Force',
  };

  QUICK_STOP = {
    'Early',
    'Slow motion',
    'Duck',
    'Fake duck',
    'Move between shots',
    'Ignore molotov',
    'Taser',
  };

  DOUBLETAP_QUICK_STOP = {
    QUICK_STOP[ 2 ],
    QUICK_STOP[ 3 ],
    QUICK_STOP[ 5 ],
  };

  PEEK_ASSIST_QUICK_STOP = {
    QUICK_STOP[ 1 ]
  };
end)();

local cheatvars = {
  ragebot = {
    -- * Aimbot
    enabled = ui.reference('Rage', 'Aimbot', 'Enabled'),
    target_selection = ui.reference('Rage', 'Aimbot', 'Target selection'),
    target_hitbox = ui.reference('Rage', 'Aimbot', 'Target hitbox'),
    multi_point = {ui.reference('RAGE', 'Aimbot', 'Multi-point')},
    multi_point_scale = ui.reference('Rage', 'Aimbot', 'Multi-point scale'),

    prefer_safe_point = ui.reference('Rage', 'Aimbot', 'Prefer safe point'),
    force_safe_point = {ui.reference('Rage', 'Aimbot', 'Force safe point')},

    avoid_unsafe_hitboxes = ui.reference('Rage', 'Aimbot', 'Avoid unsafe hitboxes'),
    automatic_fire = ui.reference('Rage', 'Aimbot', 'Automatic fire'),
    automatic_penetration = ui.reference('Rage', 'Aimbot', 'Automatic penetration'),
    silent_aim = ui.reference('Rage', 'Aimbot', 'Silent aim'),

    minimum_hitchance = ui.reference('Rage', 'Aimbot', 'Minimum hit chance'),
    minimum_damage = ui.reference('Rage', 'Aimbot', 'Minimum damage'),

    automatic_scope = ui.reference('Rage', 'Aimbot', 'Automatic scope'),
    reduce_aim_step = ui.reference('Rage', 'Aimbot', 'Reduce aim step'),

    maximum_fov = ui.reference('Rage', 'Aimbot', 'Maximum FOV'),
    log_misses_due_to_spread = ui.reference('Rage', 'Aimbot', 'Log misses due to spread'),
    low_fps_mitigations = ui.reference('Rage', 'Aimbot', 'Low FPS mitigations'),

    -- * Other
    remove_recoil = ui.reference('Rage', 'Other', 'Remove recoil'),
    accuracy_boost = ui.reference('Rage', 'Other', 'Accuracy boost'),

    delay_shot = ui.reference('Rage', 'Other', 'Delay shot'),
    quick_stop = {ui.reference('Rage', 'Other', 'Quick stop')},
    quick_stop_options = ui.reference('Rage', 'Other', 'Quick stop options'),

    quick_peek_assist = {ui.reference('Rage', 'Other', 'Quick peek assist')},
    quick_peek_assist_mode = {ui.reference('Rage', 'Other', 'Quick peek assist mode')},
    quick_peek_assist_distance = ui.reference('Rage', 'Other', 'Quick peek assist distance'),

    anti_aim_correction = ui.reference('Rage', 'Other', 'Anti-aim correction'),
    anti_aim_correction_override = ui.reference('Rage', 'Other', 'Anti-aim correction override'),
    prefer_body_aim = ui.reference('Rage', 'Other', 'Prefer body aim'),
    prefer_body_aim_disablers = ui.reference('Rage', 'Other', 'Prefer body aim disablers'),
    force_body_aim = ui.reference('Rage', 'Other', 'Force body aim'),
    force_body_aim_on_peek = ui.reference("RAGE", "Other", "Force body aim on peek"),
    duck_peek_assist = ui.reference('Rage', 'Other', 'Duck peek assist'),

    double_tap = {ui.reference('Rage', 'Other', 'Double tap')},
    double_tap_mode = ui.reference('Rage', 'Other', 'Double tap mode'),
    double_tap_hitchance = ui.reference('Rage', 'Other', 'Double tap hit chance'),
    double_tap_fakelag_limit = ui.reference('Rage', 'Other', 'Double tap fake lag limit'),
    double_tap_quick_stop = ui.reference('Rage', 'Other', 'Double tap quick stop'),
  },

  misc = {
    menu_color = ui.reference('Misc', 'Settings', 'Menu color'),
  },
};

local ffi_typeof = function(ct)
  if ffi_types[ ct ] ~= nil then
    return ffi_types[ ct ]
  end

  local bSuccess, strMsg = pcall(ffi.typeof, ct);
  if not bSuccess then
    die(string.format('(!) ffi_typeof / pcall protected ffi_typeof / %s', strMsg));
  end

  ffi_types[ ct ] = strMsg;
  return ffi_types[ ct ]
end

ffi_types.interface = ffi_typeof 'void***';
ffi_types.char_x = ffi_typeof 'char[?]';

ffi_helpers.get_interface = function(void)
  return ffi.cast(ffi_types.interface, void)
end

ffi_helpers.entry = function(void, index, typeof)
  local ctype = ffi_typeof(typeof);

  local interface = ffi_helpers.get_interface(void)[ 0 ];
  local handle = interface[ index ];

  local fnPtr = ffi.cast(ctype, handle);
  return fnPtr
end

ffi_helpers.bind = function(void, index, typeof)
  local fnPtr = ffi_helpers.entry(void, index, typeof);

  return function(...)
    return fnPtr(void, ...)
  end
end

local mtFFIHandle = {};
mtFFIHandle.__index = mtFFIHandle;

function mtFFIHandle:get_vfunc(index, typeof)
  return ffi_helpers.bind(self.m_raw, index, typeof);
end

ffi_handles.get_class = function(void)
  local cVoid = {};
  cVoid.m_raw = void;

  setmetatable(cVoid, mtFFIHandle);
  return cVoid
end

ffi_handles.find_signature = function(...)
  local void = client.find_signature(...);

  return ffi_handles.get_class(void)
end
ffi_handles.create_interface = function(...)
  local void = client.create_interface(...);

  return ffi_handles.get_class(void)
end

ffi_classes.VGUI_System010 = ffi_handles.create_interface('vgui2.dll', 'VGUI_System010');
ffi_functions.get_clipboard_length = ffi_classes.VGUI_System010:get_vfunc(7, 'int(__thiscall*)(void*)');
ffi_functions.set_clipboard_text = ffi_classes.VGUI_System010:get_vfunc(9, 'void*(__thiscall*)(void*, const char*, int)');
ffi_functions.get_clipboard_text = ffi_classes.VGUI_System010:get_vfunc(11, 'int(__thiscall*)(void*, int, const char*, int)');

ffi_ready_to_use.get_clipboard = function()
  local nLength = ffi_functions.get_clipboard_length();
  if nLength == 0 then
    return ''
  end

  local szBuffer = ffi_types.char_x(nLength);
  ffi_functions.get_clipboard_text(0, szBuffer, nLength);

  return ffi.string(szBuffer, nLength - 1)
end
ffi_ready_to_use.set_clipboard = function(str)
  return ffi_functions.set_clipboard_text(str, #str);
end

local g_client = (function()
  local this = {};
  this.events = {};

  function this.get_event_callback(identify_name)
    return this.events[ identify_name ].data
  end

  function this.set_event_callback(identify_name, event_name, callback)
    if this.events[ identify_name ] ~= nil then
      die 'Can\'t use same name of previous callbacks.';
    end

    this.events[ identify_name ] = {};
    this.events[ identify_name ].handler = function(...)
      this.events[ identify_name ].data = callback(...);
    end

    client.set_event_callback(event_name, this.events[ identify_name ].handler);
    return this.events[ identify_name ]
  end

  return this
end)();

local g_entity = (function()
  function entity.get_health(player)
    return entity.get_prop(player, 'm_iHealth')
  end

  function entity.get_armor(player)
    return entity.get_prop(player, 'm_ArmorValue')
  end

  function entity.is_lethal(player)
    local localplayer = entity.get_local_player();
    if not localplayer then
      return false
    end

    if not entity.is_alive(localplayer) then
      return false
    end

    local m_local_origin = vector(entity.get_origin(localplayer));
    local m_target_origin = vector(entity.get_origin(player));

    local m_distance = m_local_origin:dist(m_target_origin);
    local m_health = entity.get_health(player);

    local m_weapon = entity.get_player_weapon(localplayer);
    if not m_weapon then
      return
    end

    local m_idx = entity.get_prop(m_weapon, 'm_iItemDefinitionIndex');
    if not m_idx then
      return
    end

    local m_weapon = weapon[m_idx];
    if not m_weapon then
      return
    end

    local m_armor = entity.get_armor(player);

    local m_dmg = m_weapon.damage * (m_weapon.range_modifier ^ (m_distance * 0.002)) * 1.25;
    local m_new_dmg = m_dmg * m_weapon.armor_ratio * 0.5;

    if m_dmg - m_new_dmg * 0.5 > m_armor then
      m_new_dmg = m_dmg - (m_armor * 2);
    end

    return m_new_dmg >= m_health
  end
end)();

local g_ui = (function()
  local this = {};

  this.events = {};
  this.elem = {};
  this.get = {};

  function this.update()
    for _, tab in pairs(this.elem) do
      for _, elem in pairs(tab) do
        ui.set_visible(elem.var, elem.fn());
      end
    end
  end

  function this.set_callback(item, callback)
    if this.events[ item ] == nil then
      this.events[ item ] = {};

      local function handle(item)
        for _, event in ipairs(this.events[ item ]) do
          event(item);
        end
      end

      ui.set_callback(item, handle);
    end

    table.insert(this.events[ item ], callback);
  end

  function this.new(tab, name, cheatvar, fn)
    if this.elem[ tab ] == nil then
      this.elem[ tab ] = {};
      this.get[ tab ] = {};
    end

    if this.elem[ tab ][ name ] ~= nil then
      die 'Can\'t use same name of previous elements.';
    end

    fn = fn or function()
      return true
    end

    this.elem[ tab ][ name ] = {
      var = cheatvar,
      fn = fn,
    };

    local function m_update(item)
      pcall(function()
        this.get[ tab ][ name ] = ui.get(item);
        this.update();
      end);
    end

    this.set_callback(cheatvar, m_update);
    m_update(cheatvar);

    return cheatvar
  end

  function this.include(value, string)
    for _, value in ipairs(value) do
      if value == string then
        return true
      end
    end

    return false
  end

  return this
end)();

local g_config = (function()
  local this = {};

  this.prefix = SCRIPT_NAME:lower() .. ' >> ';
  this.key = 'iLOVESenko8X9JQRywTaWmGv57gUBCDKFAxc12Mf40dhpHuPj3zlNY6bsqZrIt+/=';
  this.copy = function()
    local bSuccess, strMsg = pcall(function()
      local tItems = {};

      for strTabName, tTab in pairs(g_ui.elem) do
        local tSaved = {};

        for strItemName, tItem in pairs(tTab) do
          local fnGet = function()
            return {ui.get(tItem.var)}
          end

          local bSuccess, strMsg = pcall(fnGet);
          if not bSuccess then
            goto continue
          end

          tSaved[ strItemName ] = strMsg;
          ::continue::
        end

        tItems[ strTabName ] = tSaved;
        ::continue::
      end

      local tInfo = {
        m_items = tItems;
      };

      local stringified = json.stringify(tInfo);
      return base64.encode(stringified, this.key);
    end);

    if not bSuccess then
      die(string.format('(!) config::copy / %s', strMsg));
    end

    return this.prefix .. strMsg, strMsg
  end
  this.load = function(str)
    local bSuccess, strMsg = pcall(function()
      local str = str or ffi_ready_to_use.get_clipboard();

      local prefix_place = str:sub(1, #this.prefix);
      if prefix_place ~= this.prefix then
        client.color_log(255, 200, 80, string.format('[%s]\x20\0', SCRIPT_NAME));
        client.color_log(128, 128, 128, '»\x20\0');
        client.color_log(255, 80, 80, 'oh.. seems like this not for this script...\0');
        client.color_log(255, 255, 255, '\x20');

        return
      end

      str = str:sub(1 + #prefix_place);

      local decoded = base64.decode(str, this.key);
      local parsed = json.parse(decoded);

      for strTabName, tTab in pairs(parsed.m_items) do

        for strItemName, value in pairs(tTab) do
          local fnSet = function()
            local rVar = g_ui.elem[ strTabName ][ strItemName ].var;
            ui.set(rVar, unpack(value));

            g_ui.get[ strTabName ][ strItemName ] = value;

            if #g_ui.get[ strTabName ][ strItemName ] == 1 then
              g_ui.get[ strTabName ][ strItemName ] = g_ui.get[ strTabName ][ strItemName ][ 1 ];
            end
          end

          local bSuccess, strMsg = pcall(fnSet);
          if not bSuccess then
            goto continue
          end

          ::continue::
        end

        ::continue::
      end

      return parsed
    end);

    if not bSuccess then
      die(string.format('(!) this::load / %s', strMsg));
    end

    return strMsg
  end
  this.export = function()
    local encoded = this.copy();
    if not encoded then
      return
    end

    ffi_ready_to_use.set_clipboard(encoded);
  end
  this.import = function()
    local decoded = this.load();
    if not decoded then
      return
    end

    client.color_log(255, 200, 80, string.format('[%s]\x20\0', SCRIPT_NAME));
    client.color_log(128, 128, 128, '»\x20\0');
    client.color_log(255, 255, 255, 'Loaded config');
  end

  return this
end)();

local m_lua_elements = (function()
  local this = {};

  g_ui.new('B', 'bMasterSwitch', ui.new_checkbox('Lua', 'B', _ui_prefix .. ' Master switch'));
  g_ui.new('B', 'cFeatures', ui.new_multiselect('Lua', 'B', _general_prefix .. ' Features', 'Show damage override', 'Show hit chance override', 'Show air hit chance', 'Show noscope hit chance', 'Force baim if lethal'), function()
    return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
  end);
  g_ui.new('B', 'cWeapon', ui.new_combobox('Lua', 'B', _general_prefix .. ' Weapon', unpack(WEAPON_TAB)), function()
    return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
  end);
  for index, weapon in ipairs(WEAPON_TAB) do
    local _prefix = string.format('%s%s %s»%s', hex(255, 255, 255, 200), weapon, hex(128, 128, 128, 200), hex(255, 255, 255, 225));

    if weapon ~= WEAPON_TAB[ 1 ] then
      g_ui.new(weapon, 'bOverride', ui.new_checkbox('Lua', 'B', _prefix .. ' Override'), function()
        return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
        and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      end);
    end

    g_ui.new(weapon, 'bAutomaticFire', ui.new_checkbox('Lua', 'B', _prefix .. ' Automatic fire'), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'bAutomaticPenetration', ui.new_checkbox('Lua', 'B', _prefix .. ' Automatic penetration'), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'bSilentAim', ui.new_checkbox('Lua', 'B', _prefix .. ' Silent aim'), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'bAutomaticScope', ui.new_checkbox('Lua', 'B', _prefix .. ' Automatic scope'), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'bDelayShot', ui.new_checkbox('Lua', 'B', _prefix .. ' Delay shot'), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'bHitscanLabel', ui.new_label('Lua', 'B', _hitscan_prefix .. ' ' .. weapon), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'cTargetSelection', ui.new_combobox('Lua', 'B', _prefix .. ' Target selection', unpack(TARGET_SELECTION)), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    this.last_hitbox = 'Head';
    g_ui.new(weapon, 'cTargetHitbox', ui.new_multiselect('Lua', 'B', _prefix .. ' Target hitbox', unpack(HITBOX)), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    local m_update_hitbox = function(item)
      local m_value = ui.get(item);

      if #m_value == 0 then
        ui.set(item, this.last_hitbox);
        g_ui.get[ weapon ][ 'cTargetHitbox' ] = this.last_hitbox;
        return true
      end

      this.last_hitbox = m_value;
      g_ui.get[ weapon ][ 'cTargetHitbox' ] = this.last_hitbox;
      return false
    end

    g_ui.set_callback(g_ui.elem[ weapon ][ 'cTargetHitbox' ].var, m_update_hitbox);
    m_update_hitbox(g_ui.elem[ weapon ][ 'cTargetHitbox' ].var);

    g_ui.new(weapon, 'cAvoidUnsafeHitbox', ui.new_multiselect('Lua', 'B', _prefix .. ' Avoid unsafe hitbox', unpack(HITBOX)), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'cMultipoint', ui.new_multiselect('Lua', 'B', _prefix .. ' Multi-point', unpack(HITBOX)), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'iMultipointScale', ui.new_slider('Lua', 'B', _prefix .. ' Multi-point scale', 24, 100, 60, true, '%', 1, {[ 24 ] = 'Auto'}), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      and #g_ui.get[ weapon ][ 'cMultipoint' ] > 0
    end);

    local bPreferBodyaim = false;

    local m_update_prefer_body_aim = function(item)
      local m_value = ui.get(item);

      bPreferBodyaim = false;
      if g_ui.include(m_value, HITBOX[ 1 ]) then
        if g_ui.include(m_value, HITBOX[ 2 ])
        or g_ui.include(m_value, HITBOX[ 3 ]) then
          bPreferBodyaim = true;
        end
      end

      if not bPreferBodyaim and g_ui.elem[ weapon ][ 'bPreferBodyaim' ] ~= nil then
        ui.set(g_ui.elem[ weapon ][ 'bPreferBodyaim' ].var, false);
      end

      g_ui.update();
    end

    g_ui.set_callback(g_ui.elem[ weapon ][ 'cTargetHitbox' ].var, m_update_prefer_body_aim);
    m_update_prefer_body_aim(g_ui.elem[ weapon ][ 'cTargetHitbox' ].var);

    g_ui.new(weapon, 'bPreferSafepoint', ui.new_checkbox('Lua', 'B', _prefix .. ' Prefer safe point'), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'bForceBodyAimOnPeek', ui.new_checkbox('Lua', 'B', _prefix .. ' Force Body Aim On Peek'), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'bPreferBodyaim', ui.new_checkbox('Lua', 'B', _prefix .. ' Prefer body aim'), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      and bPreferBodyaim
    end);

    g_ui.new(weapon, 'cPreferBodyaimDisablers', ui.new_multiselect('Lua', 'B', _prefix .. ' Prefer body aim disablers', unpack(PREFER_BODY_DISABLERS)), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      and bPreferBodyaim
      and g_ui.get[ weapon ][ 'bPreferBodyaim' ]
    end);

    g_ui.new(weapon, 'cBodyAimIfLethal', ui.new_combobox('Lua', 'B', _prefix .. ' Body aim if lethal', unpack(BODY_AIM_IF_LETHAL)), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      and g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Force baim if lethal')
    end);

    local damage_showtips = (function()
      local this = {
        [ 0 ] = 'Auto',
      };

      for index = 1, 26 do
        this[ 100 + index ] = ('HP + %.f'):format(index);
      end

      return this
    end)();

    g_ui.new(weapon, 'iMinimumDamage', ui.new_slider('Lua', 'B', _prefix .. ' Minimum damage', 0, 126, 20, true, nil, 1, damage_showtips), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'iMinimumDamageOverride', ui.new_slider('Lua', 'B', _prefix .. ' Minimum damage override', 0, 126, 5, true, nil, 1, damage_showtips), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      and g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show damage override')
    end);
  end

  g_ui.new('B', 'bMinimumDamageBinding', ui.new_hotkey('Lua', 'B', 'Minimum damage override bind', true), function()
    return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
    and g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show damage override')
  end);

  g_ui.new('B', 'clrDamage', ui.new_color_picker('Lua', 'B', _general_prefix .. ' Damage color', 200, 200, 200, 255), function()
    return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
    and g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show damage override')
  end);

  for index, weapon in ipairs(WEAPON_TAB) do
    local _prefix = string.format('%s%s %s»%s', hex(255, 255, 255, 200), weapon, hex(128, 128, 128, 200), hex(255, 255, 255, 225));

    g_ui.new(weapon, 'bAccuracyLabel', ui.new_label('Lua', 'B', _accuracy_prefix .. ' ' .. weapon), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'iHitchance', ui.new_slider('Lua', 'B', _prefix .. ' Hit chance', 0, 100, 50, true, '%', 1, {[0] = 'Off'}), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'iHitchanceOverride', ui.new_slider('Lua', 'B', _prefix .. ' Hit chance override', 0, 100, 50, true, '%', 1), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      and g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show hit chance override')
    end);
  end

  g_ui.new('B', 'bHitchanceBinding', ui.new_hotkey('Lua', 'B', 'Hit chance override bind', true), function()
    return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
    and g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show hit chance override')
  end);

  g_ui.new('B', 'clrHitchance', ui.new_color_picker('Lua', 'B', _general_prefix .. ' Hit chance color', 200, 200, 200, 255), function()
    return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
    and g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show hit chance override')
  end);

  for index, weapon in ipairs(WEAPON_TAB) do
    local _prefix = string.format('%s%s %s»%s', hex(255, 255, 255, 200), weapon, hex(128, 128, 128, 200), hex(255, 255, 255, 225));

    g_ui.new(weapon, 'iAirHitchance', ui.new_slider('Lua', 'B', _prefix .. ' Air hit chance', 0, 100, 0, true, '%', 1, {[0] = 'Off'}), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      and g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show air hit chance')
    end);

    if weapon == 'Auto'
    or weapon == 'Awp'
    or weapon == 'Scout' then
      g_ui.new(weapon, 'iNoscopeHitchance', ui.new_slider('Lua', 'B', _prefix .. ' Noscope hit chance', 0, 100, 0, true, '%', 1, {[0] = 'Off'}), function()
        return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
        and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
        and g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show noscope hit chance')
      end);
    end

    g_ui.new(weapon, 'iDoubletapHitchance', ui.new_slider('Lua', 'B', _prefix .. ' Double tap hit chance', 0, 100, 0, true, '%', 1), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      and ui.get(cheatvars.ragebot.double_tap[1])
    end);

    g_ui.new(weapon, 'cAccuracyBoost', ui.new_combobox('Lua', 'B', _prefix .. ' Accuracy boost', unpack(ACCURACY_BOOST)), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'bQuickStop', ui.new_checkbox('Lua', 'B', _prefix .. ' Quick stop'), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
    end);

    g_ui.new(weapon, 'cQuickStopOptions', ui.new_multiselect('Lua', 'B', _prefix .. ' Quick stop options', unpack(QUICK_STOP)), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      and g_ui.get[ weapon ][ 'bQuickStop' ]
    end);

    g_ui.new(weapon, 'cDoubletapQuickStop', ui.new_multiselect('Lua', 'B', _prefix .. ' Double tap quick stop', unpack(DOUBLETAP_QUICK_STOP)), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      and g_ui.get[ weapon ][ 'bQuickStop' ]
      and ui.get(cheatvars.ragebot.double_tap[1])
    end);

    g_ui.new(weapon, 'cPeekAssistQuickStop', ui.new_multiselect('Lua', 'B', _prefix .. ' Peek assist quick stop', unpack(PEEK_ASSIST_QUICK_STOP)), function()
      return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
      and g_ui.get[ 'B' ][ 'cWeapon' ] == weapon
      and g_ui.get[ weapon ][ 'bQuickStop' ]
    end);
  end

  local empty = function()
    return
  end

  g_ui.new('B', 'btnExport', ui.new_button('Lua', 'B', 'Export', empty), function()
    return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
  end);

  g_ui.new('B', 'btnImport', ui.new_button('Lua', 'B', 'Import', empty), function()
    return g_ui.get[ 'B' ][ 'bMasterSwitch' ]
  end);

  g_ui.set_callback(g_ui.elem[ 'B' ][ 'btnExport' ].var, g_config.export);
  g_ui.set_callback(g_ui.elem[ 'B' ][ 'btnImport' ].var, g_config.import);

  ui.set_callback(cheatvars.ragebot.double_tap[1], g_ui.update);
  g_ui.update();

  return this
end)();

local g_menu_manipulations = (function()
  local this = {};
  this.events = {};

  function this.new(cheatvar, ...)
    local arguments = {...};
    if #arguments == 0 then
      return
    end

    if this.events[ cheatvar ] == nil then
      this.events[ cheatvar ] = {};
    end

    this.events[ cheatvar ].value = arguments;
  end

  function this.shutdown()
    for cheatvar, event in pairs(this.events) do
      if event.backup == nil then
        goto skip
      end

      ui.set(cheatvar, unpack(event.backup));
      this.events[ cheatvar ] = nil;

      ::skip::
    end
  end

  function this.pre_paint_ui()
    for _, event in pairs(this.events) do
      event.value = nil;
    end
  end

  function this.post_paint_ui()
    for cheatvar, event in pairs(this.events) do
      if event.value == nil then
        if event.backup ~= nil then
          ui.set(cheatvar, unpack(event.backup));
          this.events[ cheatvar ] = nil;
        end

        goto skip
      end

      local m_value = {ui.get(cheatvar)};
      if m_value == event.value then
        goto skip
      end

      if event.backup == nil then
        event.backup = m_value;
      end

      ui.set(cheatvar, unpack(event.value));

      ::skip::
    end
  end

  return this
end)();

local main = (function()
  local this = {};
  this.last_weapon = nil;

  this.weapon_name_to_tab = {
    [ 'CWeaponTaser' ]     = WEAPON_TAB[ 2 ],

    [ 'CWeaponSCAR20' ]    = WEAPON_TAB[ 3 ],
    [ 'CWeaponG3SG1' ]     = WEAPON_TAB[ 3 ],

    [ 'CWeaponSSG08' ]     = WEAPON_TAB[ 4 ],

    [ 'CWeaponAWP' ]       = WEAPON_TAB[ 5 ],

    [ 'CWeaponGlock' ]     = WEAPON_TAB[ 6 ],
    [ 'CWeaponHKP2000' ]   = WEAPON_TAB[ 6 ],
    [ 'CWeaponP250' ]      = WEAPON_TAB[ 6 ],
    [ 'CWeaponElite' ]     = WEAPON_TAB[ 6 ],
    [ 'CWeaponTec9' ]      = WEAPON_TAB[ 6 ],
    [ 'CWeaponFiveSeven' ] = WEAPON_TAB[ 6 ],

    [ 'CDEagle' ]          = WEAPON_TAB[ 7 ],

    [ 'CAK47' ]            = WEAPON_TAB[ 9 ],
    [ 'CWeaponM4A1' ]      = WEAPON_TAB[ 9 ],
    [ 'CWeaponSG556' ]     = WEAPON_TAB[ 9 ],
    [ 'CWeaponAug' ]       = WEAPON_TAB[ 9 ],
    [ 'CWeaponGalilAR' ]   = WEAPON_TAB[ 9 ],
    [ 'CWeaponFamas' ]     = WEAPON_TAB[ 9 ],

    [ 'CWeaponMAC10' ]     = WEAPON_TAB[ 10 ],
    [ 'CWeaponUMP45' ]     = WEAPON_TAB[ 10 ],
    [ 'CWeaponMP7' ]       = WEAPON_TAB[ 10 ],
    [ 'CWeaponMP9' ]       = WEAPON_TAB[ 10 ],
    [ 'CWeaponP90' ]       = WEAPON_TAB[ 10 ],
    [ 'CWeaponBizon' ]     = WEAPON_TAB[ 10 ],

    [ 'CWeaponM249' ]      = WEAPON_TAB[ 11 ],
    [ 'CWeaponNegev' ]     = WEAPON_TAB[ 11 ],

    [ 'CWeaponNOVA' ]      = WEAPON_TAB[ 12 ],
    [ 'CWeaponXM1014' ]    = WEAPON_TAB[ 12 ],
    [ 'CWeaponSawedoff' ]  = WEAPON_TAB[ 12 ],
    [ 'CWeaponMag7' ]      = WEAPON_TAB[ 12 ],
  };

  function this.get_weapon_ui(weapon)
    local weapon_name = entity.get_classname(weapon);
    local weapon_id = entity.get_prop(weapon, 'm_iItemDefinitionIndex');

    local weapon_ui = this.weapon_name_to_tab[ weapon_name ];

    -- * Revolver check
    if weapon_ui == WEAPON_TAB[ 7 ]
    and weapon_id == 64 then
      weapon_ui = WEAPON_TAB[ 8 ];
    end

    if not weapon_ui then
      return WEAPON_TAB[ 1 ]
    end

    return weapon_ui
  end

  function this.paint_ui()
    if not g_ui.get[ 'B' ][ 'bMasterSwitch' ] then
      return
    end

    local localplayer = entity.get_local_player();
    if not localplayer then
      return
    end

    local weapon = entity.get_player_weapon(localplayer);
    if not weapon then
      return
    end

    local weapon_ui = this.get_weapon_ui(weapon);
    if not weapon_ui then
      return
    end

    if not g_ui.get[ weapon_ui ][ 'bOverride' ] then
      weapon_ui = WEAPON_TAB[ 1 ];
    end

    this.last_weapon = weapon_ui;

    if not ui.is_menu_open() then
      ui.set(g_ui.elem[ 'B' ][ 'cWeapon' ].var, weapon_ui);
    end

    -- Weapon switches
    g_menu_manipulations.new(cheatvars.ragebot.automatic_fire, g_ui.get[ weapon_ui ][ 'bAutomaticFire' ]);
    g_menu_manipulations.new(cheatvars.ragebot.automatic_penetration, g_ui.get[ weapon_ui ][ 'bAutomaticPenetration' ]);
    g_menu_manipulations.new(cheatvars.ragebot.silent_aim, g_ui.get[ weapon_ui ][ 'bSilentAim' ]);
    g_menu_manipulations.new(cheatvars.ragebot.automatic_scope, g_ui.get[ weapon_ui ][ 'bAutomaticScope' ]);
    g_menu_manipulations.new(cheatvars.ragebot.delay_shot, g_ui.get[ weapon_ui ][ 'bDelayShot' ]);

    -- Hitscan
    g_menu_manipulations.new(cheatvars.ragebot.target_selection, g_ui.get[ weapon_ui ][ 'cTargetSelection' ]);
    g_menu_manipulations.new(cheatvars.ragebot.target_hitbox, g_ui.get[ weapon_ui ][ 'cTargetHitbox' ]);
    g_menu_manipulations.new(cheatvars.ragebot.avoid_unsafe_hitboxes, g_ui.get[ weapon_ui ][ 'cAvoidUnsafeHitbox' ]);

    g_menu_manipulations.new(cheatvars.ragebot.multi_point[ 1 ], g_ui.get[ weapon_ui ][ 'cMultipoint' ]);
    g_menu_manipulations.new(cheatvars.ragebot.multi_point_scale, g_ui.get[ weapon_ui ][ 'iMultipointScale' ]);
    g_menu_manipulations.new(cheatvars.ragebot.prefer_safe_point, g_ui.get[ weapon_ui ][ 'bPreferSafepoint' ]);
    g_menu_manipulations.new(cheatvars.ragebot.force_body_aim_on_peek, g_ui.get[ weapon_ui ][ 'bForceBodyAimOnPeek' ]);
    g_menu_manipulations.new(cheatvars.ragebot.prefer_body_aim, g_ui.get[ weapon_ui ][ 'bPreferBodyaim' ]);
    g_menu_manipulations.new(cheatvars.ragebot.prefer_body_aim_disablers, g_ui.get[ weapon_ui ][ 'cPreferBodyaimDisablers' ]);
    g_menu_manipulations.new(cheatvars.ragebot.accuracy_boost, g_ui.get[ weapon_ui ][ 'cAccuracyBoost' ]);

    local iMinimumDamage = g_ui.get[ weapon_ui ][ 'iMinimumDamage' ];
    local iHitchance = g_ui.get[ weapon_ui ][ 'iHitchance' ];

    this.damage_override = nil;
    this.hitchance_override = nil;

    local localplayer = entity.get_local_player();
    if localplayer then
      if not entity.is_alive(localplayer) then
        goto skip
      end

      local m_fFlags = entity.get_prop(localplayer, 'm_fFlags');


      if g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show air hit chance')
      and bit.band(m_fFlags, bit.lshift(1, 0)) == 0 then
        if g_ui.get[ weapon_ui ][ 'iAirHitchance' ] ~= 0 then
          iHitchance = g_ui.get[ weapon_ui ][ 'iAirHitchance' ];
        end

        goto skip
      end

      if g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show noscope hit chance')
      and entity.get_prop(localplayer, 'm_bIsScoped') == 0 then
        if g_ui.get[ weapon_ui ][ 'iNoscopeHitchance' ] == nil then
          goto skip
        end

        if g_ui.get[ weapon_ui ][ 'iNoscopeHitchance' ] ~= 0 then
          iHitchance = g_ui.get[ weapon_ui ][ 'iNoscopeHitchance' ];
        end

        goto skip
      end

      ::skip::
    end

    if g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show damage override') then
      if ui.get(g_ui.elem[ 'B' ][ 'bMinimumDamageBinding' ].var) then
        iMinimumDamage = g_ui.get[ this.last_weapon ][ 'iMinimumDamageOverride' ];
        this.damage_override = iMinimumDamage;
      end
    end

    if g_ui.include(g_ui.get[ 'B' ][ 'cFeatures' ], 'Show hit chance override') then
      if ui.get(g_ui.elem[ 'B' ][ 'bHitchanceBinding' ].var) then
        iHitchance = g_ui.get[ this.last_weapon ][ 'iHitchanceOverride' ];
        this.hitchance_override = iHitchance;
      end
    end

    g_menu_manipulations.new(cheatvars.ragebot.minimum_damage, iMinimumDamage);
    g_menu_manipulations.new(cheatvars.ragebot.minimum_hitchance, iHitchance);
    g_menu_manipulations.new(cheatvars.ragebot.double_tap_hitchance, g_ui.get[ weapon_ui ][ 'iDoubletapHitchance' ]);

    g_menu_manipulations.new(cheatvars.ragebot.quick_stop[ 1 ], g_ui.get[ weapon_ui ][ 'bQuickStop' ]);

    local quick_stop = {unpack(g_ui.get[ weapon_ui ][ 'cQuickStopOptions' ])};
    local peek_assist_quick_stop =  g_ui.get[ weapon_ui ][ 'cPeekAssistQuickStop' ];

    if ui.get(cheatvars.ragebot.quick_peek_assist[ 1 ]) and ui.get(cheatvars.ragebot.quick_peek_assist[ 2 ]) then
      for i = 1, #peek_assist_quick_stop do
        table.insert(quick_stop, peek_assist_quick_stop[i]);
      end
    end

    g_menu_manipulations.new(cheatvars.ragebot.quick_stop_options, quick_stop);
    g_menu_manipulations.new(cheatvars.ragebot.double_tap_quick_stop, g_ui.get[ weapon_ui ][ 'cDoubletapQuickStop' ]);
  end

  function this.paint()
    local localplayer = entity.get_local_player();

    if not localplayer then
      return
    end

    if not entity.is_alive(localplayer) then
      return
    end

    if this.damage_override ~= nil then
      local arguments = {ui.get(g_ui.elem[ 'B' ][ 'clrDamage' ].var)};
      table.insert(arguments, 'Damage: ' .. this.damage_override);

      renderer.indicator(unpack(arguments));
    end

    if this.hitchance_override ~= nil then
      local arguments = {ui.get(g_ui.elem[ 'B' ][ 'clrHitchance' ].var)};
      table.insert(arguments, 'Hitchance: ' .. this.hitchance_override);

      renderer.indicator(unpack(arguments));
    end
  end

  this.restore = {};
  function this.shutdown()
    for player, value in pairs(this.restore) do
      plist.set(player, 'Override prefer body aim', value);
      this.restore[ player ] = nil;
    end
  end

  function this.run_command()
    if this.last_weapon == nil then
      this.shutdown();
      return
    end

    local m_enemies = entity.get_players(true);
    if #m_enemies == 0 then
      return
    end

    for index, player in pairs(m_enemies) do
      if not player then
        goto skip
      end

      local m_lethal = g_ui.get[ this.last_weapon ][ 'cBodyAimIfLethal' ];
      local m_mode = m_lethal == 'Prefer' and 'On' or 'Force';

      if m_lethal == 'Off' or not entity.is_lethal(player) then
        if this.restore[ player ] == nil then
          goto skip
        end

        plist.set(player, 'Override prefer body aim', this.restore[ player ]);
        this.restore[ player ] = nil;
      else
        if this.restore[ player ] == nil then
          this.restore[ player ] = plist.get(player, 'Override prefer body aim');
        end

        plist.set(player, 'Override prefer body aim', m_mode);
      end

      ::skip::
    end
  end

  return this
end)();

g_client.set_event_callback('menu_manipulations.shutdown', 'shutdown', g_menu_manipulations.shutdown);
g_client.set_event_callback('main.shutdown', 'shutdown', main.shutdown);

g_client.set_event_callback('menu_manipulations.pre', 'paint_ui', g_menu_manipulations.pre_paint_ui);
g_client.set_event_callback('main.paint_ui', 'paint_ui', main.paint_ui);
g_client.set_event_callback('menu_manipulations.post', 'paint_ui', g_menu_manipulations.post_paint_ui);

g_client.set_event_callback('main.paint', 'paint', main.paint);

g_client.set_event_callback('main.run_command', 'run_command', main.run_command);

client.register_esp_flag('BAIM', 255, 20, 20, function(player)
  local localplayer = entity.get_local_player();

  if not localplayer then
    return
  end

  if not entity.is_alive(localplayer) then
    return
  end

  local body_aim = plist.get(player, 'Override prefer body aim')

  return (body_aim == 'On' or body_aim == 'Force')
end)