-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- local variables for API functions. any changes to the line below will be lost on re-generation
local bit_band, client_camera_angles, client_current_threat, client_delay_call, client_eye_position, client_key_state, client_random_int, client_set_event_callback, client_trace_bullet, client_trace_line, client_userid_to_entindex, entity_get_all, entity_get_classname, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_enemy, entity_set_prop, globals_curtime, globals_tickinterval, json_parse, json_stringify, math_abs, math_atan, math_cos, math_floor, math_max, math_rad, math_random, math_sin, math_sqrt, renderer_indicator, string_char, table_insert, ui_get, ui_is_menu_open, ui_new_button, ui_new_checkbox, ui_new_combobox, ui_new_hotkey, ui_new_label, ui_new_multiselect, ui_new_slider, ui_reference, ui_set, ui_set_visible, tonumber, pairs, error, type, entity_get_player_name, math_min, client_fire_event, entity_is_dormant, globals_tickcount, setmetatable, client_create_interface, client_screen_size, renderer_text = bit.band, client.camera_angles, client.current_threat, client.delay_call, client.eye_position, client.key_state, client.random_int, client.set_event_callback, client.trace_bullet, client.trace_line, client.userid_to_entindex, entity.get_all, entity.get_classname, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_enemy, entity.set_prop, globals.curtime, globals.tickinterval, json.parse, json.stringify, math.abs, math.atan, math.cos, math.floor, math.max, math.rad, math.random, math.sin, math.sqrt, renderer.indicator, string.char, table.insert, ui.get, ui.is_menu_open, ui.new_button, ui.new_checkbox, ui.new_combobox, ui.new_hotkey, ui.new_label, ui.new_multiselect, ui.new_slider, ui.reference, ui.set, ui.set_visible, tonumber, pairs, error, type, entity.get_player_name, math.min, client.fire_event, entity.is_dormant, globals.tickcount, setmetatable, client.create_interface, client.screen_size, renderer.text
info_panel = function()
    screen = {client.screen_size()}
    x_offset, y_offset = screen[1], screen[2]
    x, y = x_offset/2, y_offset/2
    renderer.text(x + 780, y - 15, 255,255,255, 255, '', nil, ">/ ataraxia anti aim - [nightly] /<")
end

client.set_event_callback("paint", function()
    info_panel()
end)

local lua_name = 'Ataraxia'
local label_name = 'Ataraxia anti-aim system'
local ffi = require'ffi'
local vector = require'vector'
local Entity = require'gamesense/entity'
local csgo_weapons = require'gamesense/csgo_weapons'
local clipboard = require'gamesense/clipboard'
local base64 = require'gamesense/base64'
local antiaim_funcs = require'gamesense/antiaim_funcs'
local trace = require'gamesense/trace'
local ground_time = 0
local screen = vector(client_screen_size())
local m_uniqueSeed, has_been_fired, defensive_until, ground_ticks, end_time = 0, false, 0, 0, 0
local entity_addr = vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")

local tween = { }

local pow, sin, cos, pi, sqrt, abs, asin = math.pow, math.sin, math.cos, math.pi, math.sqrt, math.abs, math.asin

-- linear
local function linear(t, b, c, d) return c * t / d + b end

-- quad
local function inQuad(t, b, c, d) return c * pow(t / d, 2) + b end
local function outQuad(t, b, c, d)
  t = t / d
  return -c * t * (t - 2) + b
end
local function inOutQuad(t, b, c, d)
  t = t / d * 2
  if t < 1 then return c / 2 * pow(t, 2) + b end
  return -c / 2 * ((t - 1) * (t - 3) - 1) + b
end
local function outInQuad(t, b, c, d)
  if t < d / 2 then return outQuad(t * 2, b, c / 2, d) end
  return inQuad((t * 2) - d, b + c / 2, c / 2, d)
end

-- cubic
local function inCubic (t, b, c, d) return c * pow(t / d, 3) + b end
local function outCubic(t, b, c, d) return c * (pow(t / d - 1, 3) + 1) + b end
local function inOutCubic(t, b, c, d)
  t = t / d * 2
  if t < 1 then return c / 2 * t * t * t + b end
  t = t - 2
  return c / 2 * (t * t * t + 2) + b
end
local function outInCubic(t, b, c, d)
  if t < d / 2 then return outCubic(t * 2, b, c / 2, d) end
  return inCubic((t * 2) - d, b + c / 2, c / 2, d)
end

-- quart
local function inQuart(t, b, c, d) return c * pow(t / d, 4) + b end
local function outQuart(t, b, c, d) return -c * (pow(t / d - 1, 4) - 1) + b end
local function inOutQuart(t, b, c, d)
  t = t / d * 2
  if t < 1 then return c / 2 * pow(t, 4) + b end
  return -c / 2 * (pow(t - 2, 4) - 2) + b
end
local function outInQuart(t, b, c, d)
  if t < d / 2 then return outQuart(t * 2, b, c / 2, d) end
  return inQuart((t * 2) - d, b + c / 2, c / 2, d)
end

-- quint
local function inQuint(t, b, c, d) return c * pow(t / d, 5) + b end
local function outQuint(t, b, c, d) return c * (pow(t / d - 1, 5) + 1) + b end
local function inOutQuint(t, b, c, d)
  t = t / d * 2
  if t < 1 then return c / 2 * pow(t, 5) + b end
  return c / 2 * (pow(t - 2, 5) + 2) + b
end
local function outInQuint(t, b, c, d)
  if t < d / 2 then return outQuint(t * 2, b, c / 2, d) end
  return inQuint((t * 2) - d, b + c / 2, c / 2, d)
end

-- sine
local function inSine(t, b, c, d) return -c * cos(t / d * (pi / 2)) + c + b end
local function outSine(t, b, c, d) return c * sin(t / d * (pi / 2)) + b end
local function inOutSine(t, b, c, d) return -c / 2 * (cos(pi * t / d) - 1) + b end
local function outInSine(t, b, c, d)
  if t < d / 2 then return outSine(t * 2, b, c / 2, d) end
  return inSine((t * 2) -d, b + c / 2, c / 2, d)
end

-- expo
local function inExpo(t, b, c, d)
  if t == 0 then return b end
  return c * pow(2, 10 * (t / d - 1)) + b - c * 0.001
end
local function outExpo(t, b, c, d)
  if t == d then return b + c end
  return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b
end
local function inOutExpo(t, b, c, d)
  if t == 0 then return b end
  if t == d then return b + c end
  t = t / d * 2
  if t < 1 then return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005 end
  return c / 2 * 1.0005 * (-pow(2, -10 * (t - 1)) + 2) + b
end
local function outInExpo(t, b, c, d)
  if t < d / 2 then return outExpo(t * 2, b, c / 2, d) end
  return inExpo((t * 2) - d, b + c / 2, c / 2, d)
end

-- circ
local function inCirc(t, b, c, d) return(-c * (sqrt(1 - pow(t / d, 2)) - 1) + b) end
local function outCirc(t, b, c, d)  return(c * sqrt(1 - pow(t / d - 1, 2)) + b) end
local function inOutCirc(t, b, c, d)
  t = t / d * 2
  if t < 1 then return -c / 2 * (sqrt(1 - t * t) - 1) + b end
  t = t - 2
  return c / 2 * (sqrt(1 - t * t) + 1) + b
end
local function outInCirc(t, b, c, d)
  if t < d / 2 then return outCirc(t * 2, b, c / 2, d) end
  return inCirc((t * 2) - d, b + c / 2, c / 2, d)
end

-- elastic
local function calculatePAS(p,a,c,d)
  p, a = p or d * 0.3, a or 0
  if a < abs(c) then return p, c, p / 4 end -- p, a, s
  return p, a, p / (2 * pi) * asin(c/a) -- p,a,s
end
local function inElastic(t, b, c, d, a, p)
  local s
  if t == 0 then return b end
  t = t / d
  if t == 1  then return b + c end
  p,a,s = calculatePAS(p,a,c,d)
  t = t - 1
  return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
end
local function outElastic(t, b, c, d, a, p)
  local s
  if t == 0 then return b end
  t = t / d
  if t == 1 then return b + c end
  p,a,s = calculatePAS(p,a,c,d)
  return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) + c + b
end
local function inOutElastic(t, b, c, d, a, p)
  local s
  if t == 0 then return b end
  t = t / d * 2
  if t == 2 then return b + c end
  p,a,s = calculatePAS(p,a,c,d)
  t = t - 1
  if t < 0 then return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b end
  return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p ) * 0.5 + c + b
end
local function outInElastic(t, b, c, d, a, p)
  if t < d / 2 then return outElastic(t * 2, b, c / 2, d, a, p) end
  return inElastic((t * 2) - d, b + c / 2, c / 2, d, a, p)
end

-- back
local function inBack(t, b, c, d, s)
  s = s or 1.70158
  t = t / d
  return c * t * t * ((s + 1) * t - s) + b
end
local function outBack(t, b, c, d, s)
  s = s or 1.70158
  t = t / d - 1
  return c * (t * t * ((s + 1) * t + s) + 1) + b
end
local function inOutBack(t, b, c, d, s)
  s = (s or 1.70158) * 1.525
  t = t / d * 2
  if t < 1 then return c / 2 * (t * t * ((s + 1) * t - s)) + b end
  t = t - 2
  return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
end
local function outInBack(t, b, c, d, s)
  if t < d / 2 then return outBack(t * 2, b, c / 2, d, s) end
  return inBack((t * 2) - d, b + c / 2, c / 2, d, s)
end

-- bounce
local function outBounce(t, b, c, d)
  t = t / d
  if t < 1 / 2.75 then return c * (7.5625 * t * t) + b end
  if t < 2 / 2.75 then
    t = t - (1.5 / 2.75)
    return c * (7.5625 * t * t + 0.75) + b
  elseif t < 2.5 / 2.75 then
    t = t - (2.25 / 2.75)
    return c * (7.5625 * t * t + 0.9375) + b
  end
  t = t - (2.625 / 2.75)
  return c * (7.5625 * t * t + 0.984375) + b
end
local function inBounce(t, b, c, d) return c - outBounce(d - t, 0, c, d) + b end
local function inOutBounce(t, b, c, d)
  if t < d / 2 then return inBounce(t * 2, 0, c, d) * 0.5 + b end
  return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
end
local function outInBounce(t, b, c, d)
  if t < d / 2 then return outBounce(t * 2, b, c / 2, d) end
  return inBounce((t * 2) - d, b + c / 2, c / 2, d)
end

tween.easing = {
  linear    = linear,
  inQuad    = inQuad,    outQuad    = outQuad,    inOutQuad    = inOutQuad,    outInQuad    = outInQuad,
  inCubic   = inCubic,   outCubic   = outCubic,   inOutCubic   = inOutCubic,   outInCubic   = outInCubic,
  inQuart   = inQuart,   outQuart   = outQuart,   inOutQuart   = inOutQuart,   outInQuart   = outInQuart,
  inQuint   = inQuint,   outQuint   = outQuint,   inOutQuint   = inOutQuint,   outInQuint   = outInQuint,
  inSine    = inSine,    outSine    = outSine,    inOutSine    = inOutSine,    outInSine    = outInSine,
  inExpo    = inExpo,    outExpo    = outExpo,    inOutExpo    = inOutExpo,    outInExpo    = outInExpo,
  inCirc    = inCirc,    outCirc    = outCirc,    inOutCirc    = inOutCirc,    outInCirc    = outInCirc,
  inElastic = inElastic, outElastic = outElastic, inOutElastic = inOutElastic, outInElastic = outInElastic,
  inBack    = inBack,    outBack    = outBack,    inOutBack    = inOutBack,    outInBack    = outInBack,
  inBounce  = inBounce,  outBounce  = outBounce,  inOutBounce  = inOutBounce,  outInBounce  = outInBounce
}

-- private stuff

local function copyTables(destination, keysTable, valuesTable)
  valuesTable = valuesTable or keysTable
  local mt = getmetatable(keysTable)
  if mt and getmetatable(destination) == nil then
    setmetatable(destination, mt)
  end
  for k,v in pairs(keysTable) do
    if type(v) == 'table' then
      destination[k] = copyTables({}, v, valuesTable[k])
    else
      destination[k] = valuesTable[k]
    end
  end
  return destination
end

local function checkSubjectAndTargetRecursively(subject, target, path)
  path = path or {}
  local targetType, newPath
  for k,targetValue in pairs(target) do
    targetType, newPath = type(targetValue), copyTables({}, path)
    table_insert(newPath, tostring(k))
    if targetType == 'table' then
      checkSubjectAndTargetRecursively(subject[k], targetValue, newPath)
    end
  end
end

local function checkNewParams(duration, subject, target, easing)
  checkSubjectAndTargetRecursively(subject, target)
end

local function getEasingFunction(easing)
  easing = easing or "linear"
  if type(easing) == 'string' then
    local name = easing
    easing = tween.easing[name]
  end
  return easing
end

local function performEasingOnSubject(subject, target, initial, clock, duration, easing)
  local t,b,c,d
  for k,v in pairs(target) do
    if type(v) == 'table' then
      performEasingOnSubject(subject[k], v, initial[k], clock, duration, easing)
    else
      t,b,c,d = clock, initial[k], v - initial[k], duration
      subject[k] = easing(t,b,c,d)
    end
  end
end

-- Tween methods

local Tween = {}
local Tween_mt = {__index = Tween}

function Tween:set(clock)
  self.initial = self.initial or copyTables({}, self.target, self.subject)
  self.clock = clock

  if self.clock <= 0 then

    self.clock = 0
    copyTables(self.subject, self.initial)

  elseif self.clock >= self.duration then -- the tween has expired

    self.clock = self.duration
    copyTables(self.subject, self.target)

  else

    performEasingOnSubject(self.subject, self.target, self.initial, self.clock, self.duration, self.easing)

  end

  return self.clock >= self.duration
end

function Tween:reset()
  return self:set(0)
end

function Tween:update(dt)
  return self:set(self.clock + dt)
end
-- Public interface

function tween.new(duration, subject, target, easing)
  easing = getEasingFunction(easing)
  checkNewParams(duration, subject, target, easing)
  return setmetatable({
    duration  = duration,
    subject   = subject,
    target    = target,
    easing    = easing,
    clock     = 0
  }, Tween_mt)
end

local all_ui = {}
local function handle_ui(creator) 
    table_insert(all_ui, creator)
    return creator
end

local normalize = function(K)
    while K > 180 do
        K = K - 360
    end
    while K < -180 do
        K = K + 360
    end
    return K
end

local contains = function(table, value)
    for i = 0, #table do
       if table[i] == value then
          return true
       end
    end

    return false
end

local function clamp(H, I, J)
    return math_max(I, math_min(J, H))
end

local lag_record = function(player)
    local sim_time = ffi.cast(ffi.typeof "float*", ffi.cast(ffi.typeof "char*", entity_addr(player)) + 0x268)[0]
    local old_sim_time = ffi.cast(ffi.typeof "float*", ffi.cast(ffi.typeof "char*", entity_addr(player)) + 0x268 + 4)[0]

    local tickcount= globals.servertickcount()
    local sim_diff = sim_time - old_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math_abs(sim_diff) - toticks(client.latency())
    end

    return {shifting_no_entry = math_floor(tickcount - defensive_until + 0.5), shifting_ticks = antiaim_funcs.get_tickbase_shifting()}
end

local ComboBoxes = {
    amount = {'Dynamic', 'Maxmimum'},
    trigger = {'In Air', 'Ducking', 'Reset on bhop', 'On peek'},
    TABS = { 'AA', 'Anti-aimbot angles', 'Fake lag', 'Other', 'Rage', 'MISC', 'Settings' }
}

local ref_visible = {
    on_shot_aa = { ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[4], 'On shot anti-aim') },
    fake_duck = ui_reference(ComboBoxes.TABS[5], ComboBoxes.TABS[4], 'Duck peek assist'),
    doubletap = { ui_reference('RAGE', 'AIMBOT', 'Double tap') }
}

local ref_hidden = {
    fakelag = {
        amount = ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[3], 'Amount'),
        limit = ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[3], 'Limit'),
        variance = ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[3], 'Variance'),
        enabled = ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[3], 'Enabled'),
    },

    anti_aim = {
        enabled = ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Enabled'),
		pitch = { ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Pitch') },
		base = ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Yaw Base'),
		yaw = { ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Yaw') },
		yaw_jitter = { ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Yaw jitter') },
		body_yaw = { ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Body Yaw') },
		body_fr = ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Freestanding body yaw'),
		edge = ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Edge yaw'),
		roll = ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Roll'),
		freestand = { ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Freestanding') }
	},

    misc = {
		leg_movement = ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[4], 'Leg movement'),
		slow_mo = { ui_reference(ComboBoxes.TABS[1], ComboBoxes.TABS[4], 'Slow Motion') },
        auto_peek = { ui_reference(ComboBoxes.TABS[5], ComboBoxes.TABS[4], 'Quick peek assist') }
	},
}

local custom_condition = { 'Global', 'Standing', 'Moving', 'Slow Motion', 'Duck', 'In Air', 'Air Duck', 'Fakelag' }
local state_to_idx = { ['Global'] = 1, ['Standing'] = 2, ['Moving'] = 3, ['Slow Motion'] = 4, ['Duck'] = 5, ['In Air'] = 6, ['Air Duck'] = 7, ['Fakelag'] = 8 }
local nade = {'CHEGrenade', 'CSmokeGrenade', 'CMolotovGrenade', 'CSensorGrenade', 'CFlashbang', 'CDecoyGrenade', 'CIncendiaryGrenade'}

local cat_svg = [[<svg t="1650815150236" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1757" width="200" height="200"><path d="M750.688207 480.651786c-40.458342 65.59852-115.105654 102.817686-205.927943 117.362627 2.382361 26.853806 0.292571 62.00408 20.897903 102.232546 40.77181 79.621013 76.486328 166.28462 88.356337 229.897839 69.819896 30.824408 215.958937-42.339153 257.671154-134.540705 44.721514-98.847085 0-202.082729-74.103967-210.755359-74.083069-8.651732-117.655198 31.555835-109.902076 78.65971 7.732224 47.103875 51.868597 47.918893 96.485622 16.822812 44.617024-31.075183 85.869486 32.517138 37.992389 60.562125-47.897995 28.044987-124.133548 44.867799-168.228125-5.642434-44.094577-50.489335-40.458342-228.205109 143.65219-211.716662 184.110532 16.509344 176.127533 261.683551 118.804583 344.042189C894.465785 956.497054 823.600993 1024.519731 616.37738 1023.997283h-167.18323V814.600288 1023.997283h-168.269921c-83.424432 0-24.743118-174.267619 51.826801-323.750324 20.584435-40.228465 18.494645-75.378739 20.897904-102.232546C262.784849 583.469472 188.137536 546.250306 147.679195 480.651786H93.867093A20.814312 20.814312 0 0 1 73.031883 459.753882c0-11.535643 9.46675-20.897904 20.83521-20.897903H127.993369a236.480679 236.480679 0 0 1-10.093687-41.795808H52.071285A20.814312 20.814312 0 0 1 31.236075 376.162267c0-11.535643 9.46675-20.897904 20.83521-20.897903H114.82769v-0.877712c0-57.009481 15.171878-103.131155 41.795808-139.514406V28.379353c0-11.535643 8.630834-17.136281 19.267867-12.517844l208.979037 90.864085c20.793414-2.08979 42.318255-3.113788 64.323748-3.113787s43.530333 1.044895 64.344646 3.134685l208.979037-90.884983c10.616135-4.618437 19.246969 0.982201 19.246969 12.538742v186.471995c26.623929 36.38325 41.795807 82.504924 41.795808 139.514406V355.264364h62.756405c11.493847 0 20.83521 9.278669 20.83521 20.897903 0 11.535643-9.46675 20.897904-20.83521 20.897904h-65.828397a236.480679 236.480679 0 0 1-10.093688 41.795808h34.126277c11.493847 0 20.83521 9.278669 20.83521 20.897903 0 11.535643-9.46675 20.897904-20.83521 20.897904h-53.833z" p-id="1758" fill="#ffffff"></path></svg>           ]]
local cat_outline_png =
[[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]]

local Ataraxia_fade = '\af08080FFA\ae08090FFt\ad080a0FFa\ac080b0FFr\ab080c0FFa\aa080d0FFx\a9080e0FFi\a8080f0FFa\aFFFFFFFF - '
local master_switch = ui_new_checkbox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\aFFFFFFFF>> \af08080FFA\ae08090FFt\ad080a0FFa\ac080b0FFr\ab080c0FFa\aa080d0FFx\a9080e0FFi\a8080f0FFa \aFFFFFFFF<<')
local aa_opts = ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\nfunctions region ', {'Anti-Aim', 'Hotkeys', 'Visuals' })
local fl_opts = ui_new_checkbox(ComboBoxes.TABS[1], ComboBoxes.TABS[3], Ataraxia_fade .. ' Custom Fakelag')

--Visuals tab
local visual_tab = {
    enable = ui_new_checkbox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Enable Indicator'),
    background_clr_label = ui_new_label(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Main fade text color'),
    background_clr = ui.new_color_picker(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Main fade text clr', 255, 255, 255, 60),
    crosshair_clr_label = ui_new_label(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Sub fade text color'),
    crosshair_clr = ui.new_color_picker(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Sub fade text clr', 238, 180, 180, 255),

    rapid = ui.new_label(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'DT Color'),
    charged_color = ui.new_color_picker(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'charged_color', 238, 180, 180, 255),

    manual_ind = ui.new_label(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Manual Color'),
    manual = ui.new_color_picker(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'manual', 238, 180, 180, 255),

    logo_color_label = ui_new_label('AA', 'Anti-Aimbot angles', 'Logo Color'),
    logo_color = ui.new_color_picker('AA', 'Anti-Aimbot angles', 'Logo_color', 255, 255, 255, 255),
    logo_outline_color_label = ui_new_label('AA', 'Anti-Aimbot angles', 'Logo Outline Color'),
    logo_outline_color = ui.new_color_picker('AA', 'Anti-Aimbot angles', 'Logo_outline_color', 0, 0, 0, 255),

    client_anim = handle_ui(ui_new_multiselect(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Client animations overrider', { '0 pitch on land', 'Leg inverse', 'Static leg in air', 'Walking in air' }))
}
--end

--hotkey tabl
local bind_system = {
	freestand = { false, ui_new_hotkey(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Freestanding')},
	left = { false, ui_new_hotkey(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Manual left') },
	right = { false, ui_new_hotkey(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Manual right') },
	back = { false, ui_new_hotkey(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Reset manual state') },
	edge = { false, ui_new_hotkey(ComboBoxes.TABS[1], ComboBoxes.TABS[2], 'Edge yaw') },
	state = ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\nmanual_state', 0, 3, 0),
}
--end

--update bind_system
function bind_system:update_manual()
	ui_set(self.left[2], 'On hotkey')
	ui_set(self.right[2], 'On hotkey')
	ui_set(self.back[2], 'On hotkey')
	ui_set_visible(bind_system.state, false)

	local m_state = ui_get(self.state)
	local left_state, right_state, backward_state = ui_get(self.left[2]), ui_get(self.right[2]), ui_get(self.back[2])
	local edge_on_key = ui_get(self.edge[2])

	ui_set(ref_hidden.anti_aim.edge, edge_on_key and true or false)

	if ui_get(self.freestand[2]) then
		self.freestand[1] = true
        ui_set(ref_hidden.anti_aim.freestand[1], true)
        ui_set(ref_hidden.anti_aim.freestand[2], 'Always on')
		return
	else
        ui_set(ref_hidden.anti_aim.freestand[1], false)
		self.freestand[1] = false
	end

	if left_state == self.left[1] and right_state == self.right[1] and backward_state == self.back[1] then return end
	self.left[1], self.right[1], self.back[1] = left_state, right_state, backward_state

	if left_state and m_state == 1 or right_state and m_state == 2 or backward_state and m_state == 3 then
	  	ui_set(self.state, 0)
	  	return
	end

	if left_state and m_state ~= 1 then ui_set(self.state, 1) end
	if right_state and m_state ~= 2 then ui_set(self.state, 2) end
	if backward_state and m_state ~= 3 then ui_set(self.state, 3) end
end

--fakelag tab
local fakelag_tab = {
    amount = handle_ui(ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[3], 'Amount', ComboBoxes.amount)),
    trigger = handle_ui(ui_new_multiselect(ComboBoxes.TABS[1], ComboBoxes.TABS[3], 'Triggers', ComboBoxes.trigger)),
    normal_limit = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[3], 'Normal limit', 1, 15, 14, true, 't')),
    trigger_limit = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[3], 'Trigger limit', 1, 15, 14, true, 't'))
}
--end

local custom_aa = { '1', '2', '3', '4', '5', '6', '7', '8'}
local cond = ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], Ataraxia_fade .. 'Conditions', custom_condition)
for i = 1, #custom_condition do
    custom_aa[i] = {
        active = handle_ui(ui_new_checkbox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], ('Enable %s Condition'):format(custom_condition[i]:lower()))),
        yaw = handle_ui(ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFYaw Options\n' .. custom_condition[i], { 'Static', "Desync", 'Ataraxia' })),
        yaw_slider = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFYaw Offset\n' .. custom_condition[i], -180, 180, 0)),
        yaw_slider_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFYaw Left\n' .. custom_condition[i], -180, 180, 0)),
        yaw_slider_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFYaw Right\n' .. custom_condition[i], -180, 180, 0)),
        yaw_slider_tick = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFYaw Tick\n' .. custom_condition[i], 4, 20, 4, true, nil, 1, { [4] = 'Default'})),
        yaw_slider_min_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFLeft Yaw [Min]\n' .. custom_condition[i], -180, 180, 0)),
        yaw_slider_max_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFLeft Yaw [Max]\n' .. custom_condition[i], -180, 180, 0)),
        yaw_slider_step_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFLeft Yaw [Step]\n' .. custom_condition[i], 0, 5, 0, true, nil, 1, { [0] = 'None'})),
        yaw_slider_min_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFRight Yaw [Min]\n' .. custom_condition[i], -180, 180, 0)),
        yaw_slider_max_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFRight Yaw [Max]\n' .. custom_condition[i], -180, 180, 0)),
        yaw_slider_step_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFRight Yaw [Step]\n' .. custom_condition[i], 0, 5, 0, true, nil, 1, { [0] = 'None'})),
        yaw_jitter = handle_ui(ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFJitter\n' .. custom_condition[i], { 'Off', 'Offset', 'Center', 'Skitter' })),
        yaw_jitter_speed = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFJitter Tick\n' .. custom_condition[i], 0, 5, 0, true, nil, 1, { [0] = 'Default'})),
        yaw_jitter_val = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFJitter Offset\n' .. custom_condition[i], -180, 180, 0)),
        body_yaw = handle_ui(ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFBody Yaw\n' .. custom_condition[i], { 'Static', 'Jitter', 'Switch' })),
        body_yaw_opt = handle_ui(ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFBody Yaw Options\n' .. custom_condition[i], {'Static', 'Advanced', 'Ataraxia'})),
        body_yaw_tick = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFBody Yaw Tick\n' .. custom_condition[i], 4, 20, 4, true, nil, 1, { [4] = 'Default'})),
        body_yaw_val = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFBody Yaw Offset\n' .. custom_condition[i], -180, 180, 0)),
        body_yaw_val_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFBody Yaw Left\n' .. custom_condition[i], -180, 180, 0)),
        body_yaw_val_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFBody Yaw Right\n' .. custom_condition[i], -180, 180, 0)),
        body_yaw_min_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFLeft Body [Min]\n' .. custom_condition[i], -180, 180, 0)),
        body_yaw_max_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFLeft Body [Max]\n' .. custom_condition[i], -180, 180, 0)),
        body_yaw_step_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFLeft Body [Step]\n' .. custom_condition[i], 0, 5, 0, true, nil, 1, { [0] = 'None'})),
        body_yaw_min_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFRight Body [Min]\n' .. custom_condition[i], -180, 180, 0)),
        body_yaw_max_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFRight Body [Max]\n' .. custom_condition[i], -180, 180, 0)),
        body_yaw_step_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFRight Body [Step]\n' .. custom_condition[i], 0, 5, 0, true, nil, 1, { [0] = 'None'})),
        fake_opt = handle_ui(ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFFake Options\n' .. custom_condition[i], {'Static', 'Advanced', 'Ataraxia'})),
        fake_tick = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFFake Tick\n' .. custom_condition[i], 4, 20, 4, true, nil, 1, { [4] = 'Default'})),
        fake_limit = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFFake Limit\n' .. custom_condition[i], 0, 100, 100, true, '%', 1)),
        fake_limit_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFFake Left\n' .. custom_condition[i], 0, 100, 100, true, '%', 1)),
        fake_limit_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFFake Right\n' .. custom_condition[i], 0, 100, 100, true, '%', 1)),
        fake_min_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFLeft Fake [Min]\n' .. custom_condition[i], 0, 100, 100, true, '%', 1)),
        fake_max_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFLeft Fake [Max]\n' .. custom_condition[i], 0, 100, 100, true, '%', 1)),
        fake_step_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFLeft Fake [Step]\n' .. custom_condition[i], 0, 5, 0, true, nil, 1, { [0] = 'None'})),
        fake_min_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFRight Fake [Min]\n' .. custom_condition[i], 0, 100, 100, true, '%', 1)),
        fake_max_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFRight Fake [Max]\n' .. custom_condition[i], 0, 100, 100, true, '%', 1)),
        fake_step_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFRight Fake [Step]\n' .. custom_condition[i], 0, 5, 0, true, nil, 1, { [0] = 'None'})),
        defensive = handle_ui(ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFDef Exploit\n' .. custom_condition[i], { 'Off', "On"})),
        def_pitch = handle_ui(ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFDef Pitch\n' .. custom_condition[i], { 'Off', "On"})),
        pitch_opt = handle_ui(ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFDef Pitch Options\n' .. custom_condition[i], {'Zero', 'Up', 'Down', 'Random', 'Custom'})),
        pitch_val = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFDef Pitch Offset\n' .. custom_condition[i], -89, 89, 0)),
        def_yaw = handle_ui(ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFDef Yaw\n' .. custom_condition[i], { 'Off', "On"})),
        yaw_opt = handle_ui(ui_new_combobox(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFDef Yaw Options\n' .. custom_condition[i], {'Forward', 'Random', 'Custom', 'Advanced'})),
        yaw_val = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFDef Yaw Offset\n' .. custom_condition[i], -180, 180, 0)),
        yaw_val_tick = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFDef Yaw Tick\n' .. custom_condition[i], 4, 20, 4, true, nil, 1, { [4] = 'Default'})),
        yaw_val_l = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFDef Yaw Left\n' .. custom_condition[i], -180, 180, 0)),
        yaw_val_r = handle_ui(ui_new_slider(ComboBoxes.TABS[1], ComboBoxes.TABS[2], '\af08080FF[A] \aFFFFFFFFDef Yaw Right\n' .. custom_condition[i], -180, 180, 0)),
    }
end

local ref_list = {
    ref_hidden.anti_aim.enabled,
	ref_hidden.anti_aim.pitch[1],
    ref_hidden.anti_aim.pitch[2],
	ref_hidden.anti_aim.base,
	ref_hidden.anti_aim.yaw[1],
	ref_hidden.anti_aim.yaw[2],
	ref_hidden.anti_aim.yaw_jitter[1],
	ref_hidden.anti_aim.yaw_jitter[2],
	ref_hidden.anti_aim.body_yaw[1],
	ref_hidden.anti_aim.body_yaw[2],
	ref_hidden.anti_aim.body_fr,
	ref_hidden.anti_aim.edge,
	ref_hidden.anti_aim.roll,
	ref_hidden.anti_aim.freestand[1],
    ref_hidden.fakelag.amount,
    ref_hidden.fakelag.limit,
    ref_hidden.fakelag.variance,
    ref_hidden.fakelag.enabled
}

--handle ui
local handle_ui_visible = function()
    local active = ui_get(master_switch)
    local fakelag_active = ui_get(fl_opts)

    local menu_open = ui_is_menu_open()

    ui_set(ref_list[2], 'Default')
    ui_set(ref_list[1], true)
    ui_set(ref_list[5], '180')
    ui_set(ref_list[4], 'Local view')
    ui_set(ref_list[6], 0)
    ui_set(ref_list[9], 'Off')
    ui_set(ref_list[10], 0)
    ui_set(ref_list[11], false)

    if menu_open then
        ui_set_visible(aa_opts, active)
        
        for k, v in pairs(visual_tab) do
            ui_set_visible(v, ui_get(aa_opts) == 'Visuals' and active)
        end

        for k, v in pairs(ref_list) do
            if k == 15 or k == 16 or k == 17 or k == 18 then
                ui_set_visible(v, not (active and fakelag_active))
            else
                ui_set_visible(v, not active)
            end
        end
 --sep

        local active_cond = state_to_idx[ui_get(cond)]
        local show_aa = ui_get(aa_opts) == 'Anti-Aim' and active
        local show_global = ui_get(aa_opts) == 'Global' and active
        local show_hotkeys = ui_get(aa_opts) == 'Hotkeys' and active
        local show_fl = ui_get(fl_opts) and active

        for k, v in pairs(fakelag_tab) do
            ui_set_visible(v, show_fl)
        end

        for _, idx in pairs(bind_system) do
            if type(idx) == 'table' then
                ui_set_visible(idx[2], show_hotkeys)
            end
        end

        ui_set(custom_aa[1].active, true)
        ui_set_visible(cond, show_aa)
        ui_set_visible(bind_system.state, false)
        ui_set_visible(fl_opts, active)
        
        for i=1, #custom_condition do
            local should_show = ui_get(custom_aa[i].active) and show_aa
            ui_set_visible(custom_aa[i].active, active_cond == i and show_aa)
            ui_set_visible(custom_aa[i].yaw, active_cond == i and should_show)
            ui_set_visible(custom_aa[i].yaw_slider, active_cond == i and should_show and (ui.get(custom_aa[i].yaw) == "Static"))
            ui_set_visible(custom_aa[i].yaw_slider_l, active_cond == i and should_show and (ui.get(custom_aa[i].yaw) == "Desync"))
            ui_set_visible(custom_aa[i].yaw_slider_r, active_cond == i and should_show and (ui.get(custom_aa[i].yaw) == "Desync"))
            ui_set_visible(custom_aa[i].yaw_slider_tick, active_cond == i and should_show and (ui.get(custom_aa[i].yaw) == "Ataraxia"))
            ui_set_visible(custom_aa[i].yaw_slider_min_l, active_cond == i and should_show and (ui.get(custom_aa[i].yaw) == "Ataraxia"))
            ui_set_visible(custom_aa[i].yaw_slider_max_l, active_cond == i and should_show and (ui.get(custom_aa[i].yaw) == "Ataraxia"))
            ui_set_visible(custom_aa[i].yaw_slider_step_l, active_cond == i and should_show and (ui.get(custom_aa[i].yaw) == "Ataraxia"))
            ui_set_visible(custom_aa[i].yaw_slider_min_r, active_cond == i and should_show and (ui.get(custom_aa[i].yaw) == "Ataraxia"))
            ui_set_visible(custom_aa[i].yaw_slider_max_r, active_cond == i and should_show and (ui.get(custom_aa[i].yaw) == "Ataraxia"))
            ui_set_visible(custom_aa[i].yaw_slider_step_r, active_cond == i and should_show and (ui.get(custom_aa[i].yaw) == "Ataraxia"))
            ui_set_visible(custom_aa[i].yaw_jitter, active_cond == i and should_show)
            ui_set_visible(custom_aa[i].yaw_jitter_speed, active_cond == i and should_show and (ui_get(custom_aa[i].yaw_jitter) ~= 'Off' and ui_get(custom_aa[i].yaw_jitter) ~= 'Skitter'))
            ui_set_visible(custom_aa[i].yaw_jitter_val, active_cond == i and should_show and ui_get(custom_aa[i].yaw_jitter) ~= 'Off')
            ui_set_visible(custom_aa[i].body_yaw, active_cond == i and should_show)
            ui_set_visible(custom_aa[i].body_yaw_opt, active_cond == i and should_show)
            ui_set_visible(custom_aa[i].body_yaw_tick, active_cond == i and should_show and ui_get(custom_aa[i].body_yaw_opt) ~= 'Static')
            ui_set_visible(custom_aa[i].body_yaw_val, active_cond == i and should_show and ui_get(custom_aa[i].body_yaw_opt) == 'Static')
            ui_set_visible(custom_aa[i].body_yaw_val_r, active_cond == i and should_show and ui_get(custom_aa[i].body_yaw_opt) == 'Advanced')
            ui_set_visible(custom_aa[i].body_yaw_val_l, active_cond == i and should_show and ui_get(custom_aa[i].body_yaw_opt) == 'Advanced')
            ui_set_visible(custom_aa[i].body_yaw_min_l, active_cond == i and should_show and ui_get(custom_aa[i].body_yaw_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].body_yaw_max_l, active_cond == i and should_show and ui_get(custom_aa[i].body_yaw_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].body_yaw_step_l, active_cond == i and should_show and ui_get(custom_aa[i].body_yaw_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].body_yaw_min_r, active_cond == i and should_show and ui_get(custom_aa[i].body_yaw_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].body_yaw_max_r, active_cond == i and should_show and ui_get(custom_aa[i].body_yaw_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].body_yaw_step_r, active_cond == i and should_show and ui_get(custom_aa[i].body_yaw_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].fake_opt, active_cond == i and should_show)
            ui_set_visible(custom_aa[i].fake_limit, active_cond == i and should_show and ui_get(custom_aa[i].fake_opt) == 'Static')
            ui_set_visible(custom_aa[i].fake_tick, active_cond == i and should_show and ui_get(custom_aa[i].fake_opt) ~= 'Static')
            ui_set_visible(custom_aa[i].fake_limit_l, active_cond == i and should_show and ui_get(custom_aa[i].fake_opt) == 'Advanced')
            ui_set_visible(custom_aa[i].fake_limit_r, active_cond == i and should_show and ui_get(custom_aa[i].fake_opt) == 'Advanced')
            ui_set_visible(custom_aa[i].fake_min_l, active_cond == i and should_show and ui_get(custom_aa[i].fake_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].fake_max_l, active_cond == i and should_show and ui_get(custom_aa[i].fake_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].fake_step_l, active_cond == i and should_show and ui_get(custom_aa[i].fake_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].fake_min_r, active_cond == i and should_show and ui_get(custom_aa[i].fake_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].fake_max_r, active_cond == i and should_show and ui_get(custom_aa[i].fake_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].fake_step_r, active_cond == i and should_show and ui_get(custom_aa[i].fake_opt) == 'Ataraxia')
            ui_set_visible(custom_aa[i].defensive, active_cond == i and should_show and active_cond ~= 8)
            ui_set_visible(custom_aa[i].def_pitch, active_cond == i and should_show and ui_get(custom_aa[i].defensive) == 'On')
            ui_set_visible(custom_aa[i].pitch_opt, active_cond == i and should_show and ui_get(custom_aa[i].defensive) == 'On' and ui_get(custom_aa[i].def_pitch) == 'On')
            ui_set_visible(custom_aa[i].pitch_val, active_cond == i and should_show and ui_get(custom_aa[i].defensive) == 'On' and ui_get(custom_aa[i].def_pitch) == 'On' and ui_get(custom_aa[i].pitch_opt) == 'Custom')
            ui_set_visible(custom_aa[i].def_yaw, active_cond == i and should_show and ui_get(custom_aa[i].defensive) == 'On')
            ui_set_visible(custom_aa[i].yaw_opt, active_cond == i and should_show and ui_get(custom_aa[i].defensive) == 'On' and ui_get(custom_aa[i].def_yaw) == 'On')
            ui_set_visible(custom_aa[i].yaw_val, active_cond == i and should_show and ui_get(custom_aa[i].defensive) == 'On' and ui_get(custom_aa[i].def_yaw) == 'On' and ui_get(custom_aa[i].yaw_opt) == 'Custom')
            ui_set_visible(custom_aa[i].yaw_val_tick, active_cond == i and should_show and ui_get(custom_aa[i].defensive) == 'On' and ui_get(custom_aa[i].def_yaw) == 'On' and ui_get(custom_aa[i].yaw_opt) == 'Advanced')
            ui_set_visible(custom_aa[i].yaw_val_l, active_cond == i and should_show and ui_get(custom_aa[i].defensive) == 'On' and ui_get(custom_aa[i].def_yaw) == 'On' and ui_get(custom_aa[i].yaw_opt) == 'Advanced')
            ui_set_visible(custom_aa[i].yaw_val_r, active_cond == i and should_show and ui_get(custom_aa[i].defensive) == 'On' and ui_get(custom_aa[i].def_yaw) == 'On' and ui_get(custom_aa[i].yaw_opt) == 'Advanced')
            

        end

        ui_set_visible(custom_aa[1].active, false)
    end
end
--
local render = (function()
    local this = { }

    local function to_rate(r)
        return clamp((math.floor(r * 100)), 0, 100)
    end

    local rgba = function(tbl, name) 
        local r = string.format('%X',tbl[1])
        if #r == 1 then 
            r = '0' .. r
        end 
        local g = string.format('%X',tbl[2])
        if #g == 1 then 
            g = '0' .. g
        end 
        local b = string.format('%X',tbl[3])
        if #b == 1 then 
            b = '0' .. b
        end 
        local a = string.format('%X',tbl[4])
        if #a == 1 then 
            a = '0' .. a
        end 
        return string.format('\a%s%s%s%s%s',r, g, b, a, name)
    end

    local rgbaf = function(tbl, name) 
        return rgba(tbl, name) .. rgba({220, 220, 220, 255}, '')
    end
    
    local function override_fucking_alpha(text, alpha)
        local new_text = text
        local r = string.format('%X',alpha)
        if #r == 1 then 
            r = '0' .. r
        end 
    
        for i = 1, #text do 
            if string.sub(text, i, i) == '\a' then 
                new_text = string.sub(new_text, 1, i + 6) .. r .. string.sub(new_text, i + 9, #new_text)
            end
        end 
        
        return new_text
    end 

    local rgba_to_hex = function(b, c, d, e)
        return string.format('%02x%02x%02x%02x', b, c, d, e)
    end

    local function lerp(a, b, t)
        return a + (b - a) * t
    end

    local function text_fade_animation(speed, color1, color2, text)
        local final_text = ''
        local curtime = globals_curtime()
        for i = 0, #text do
            local wave = cos(2*speed*curtime/4+i*5/30)
            local color = rgba_to_hex(
                lerp(color1[1], color2[1], clamp(wave, 0, 1)),
                lerp(color1[2], color2[2], clamp(wave, 0, 1)),
                lerp(color1[3], color2[3], clamp(wave, 0, 1)),
                255 * clamp(wave, 0, 1)
            ) 
            final_text = final_text .. '\a' .. color .. text:sub(i, i) 
        end

        return final_text
    end

    local crosshair_cache = {
        hotkeys = {
    
        },
    
        y_add = 0,
        doubletap = 0,
        versus = false,
        arrow_alpha = 255,
        scope = false,
        main_scope = 0,
    
        top_alpha = 255,
        logo_alpha = 0,
        top_length = 0,
        top_x_add = 0,
        flick_state = false
    }
    
    local function new_hotkey(name, condition, flags, pos,clr, tool, sec_name)
        local paint_name = name
        if sec_name then 
            paint_name = sec_name
        end 
    
        if not crosshair_cache.hotkeys[name] then 
            crosshair_cache.hotkeys[name] = {
                x_add = 0,
                alpha = 0,
                y_add = 0,
                shadow_step = 0,
                old_name = paint_name,
                drifting_state = 0
            }
        end 
    
        local redirect = crosshair_cache.hotkeys[name]
    
        local pos_add, size = renderer.measure_text(flags, paint_name)
    
        tween.new(0.3, redirect, {alpha = condition and 255 or 0, y_add = condition and size - 0.5 or 0, x_add = crosshair_cache.scope and pos_add /2 + 15 or 0, shadow_step = condition and 1 or 0}, 'outInCubic'):update(globals.frametime())
    
        if paint_name ~= redirect.old_name and (name == 'MODE') then 
            if crosshair_cache.scope then
                redirect.x_add = pos_add /2 + 15
            end
            redirect.old_name = paint_name 
        end 
    
        renderer_text(pos.x + redirect.x_add , pos.y + crosshair_cache.y_add, clr[1], clr[2], clr[3], redirect.alpha, flags, 0, override_fucking_alpha(paint_name, redirect.alpha))
        crosshair_cache.y_add = crosshair_cache.y_add + redirect.y_add
    end

    cat_outline_png = renderer.load_png(base64.decode(cat_outline_png), 50, 50)
    cat_svg = renderer.load_svg(cat_svg, 50, 50)

    function this:draw_ind(me)    
        local clr = {ui_get(visual_tab.background_clr)}
        local clr1 = {ui_get(visual_tab.crosshair_clr)} 
        local cool_labels = text_fade_animation(-6, clr1, clr, label_name)


        if not ui_get(visual_tab.enable) then return end

        crosshair_cache.scope = entity.get_prop(me, "m_bIsScoped") == 1

        if crosshair_cache.scope then
            crosshair_cache.logo_alpha = crosshair_cache.logo_alpha - 3

            if crosshair_cache.logo_alpha <= 0 then
                crosshair_cache.logo_alpha = 0
            end
        else
            crosshair_cache.logo_alpha = crosshair_cache.logo_alpha + 3

            if crosshair_cache.logo_alpha >= 255 then
                crosshair_cache.logo_alpha = 255
            end
        end
    
        local position = vector(screen.x/2, screen.y/2 + 20)
        crosshair_cache.y_add = 0
        crosshair_cache.flick_state = 1
        
        local clr2 = {220, 220, 220, 255}
        local clr3 = {220, 111, 111, 255}
        local logo = { ui_get(visual_tab.logo_color) }
        local logo_outline = { ui_get(visual_tab.logo_outline_color) }
        local shifting_tick = lag_record(me).shifting_ticks

        local main_tps, tpcs = renderer.measure_text('bc-', "ataraxia")
        tween.new(0.3, crosshair_cache, {main_scope = crosshair_cache.scope and main_tps / 2 + 15 or 0}, 'outInCubic'):update(globals.frametime())
     
        local rendering_text = text_fade_animation(10, clr1, clr, "ataraxia")
    
        renderer_text(position.x + crosshair_cache.main_scope - 1, position.y, 220, 220, 220, 255, 'bc', 0,  rendering_text)
    
        tween.new(0.3, crosshair_cache, {doubletap = shifting_tick < 1 and 0 or 1.2}, 'outInCubic'):update(globals.frametime())
     --rapid
        crosshair_cache.y_add = crosshair_cache.y_add + tpcs -1
    
        local rapid_rate = to_rate(crosshair_cache.doubletap)
        local aiming_num = math.floor(5 * rapid_rate / 100)
        local painting = rgbaf({ui.get(visual_tab.charged_color)}, string.sub('Z tap', 1, aiming_num)) .. string.sub('Z tap', aiming_num + 1, #('Z tap'))
    
        new_hotkey('Z tap', ui.get(ref_visible.doubletap[2]), 'c', position, {255, 0, 0, 255}, true, painting)

        new_hotkey('manual', ui_get(bind_system.state) == 1 or ui_get(bind_system.state) == 2, 'c', position, clr3)
        new_hotkey('edge', ui_get(ref_hidden.anti_aim.edge), 'c', position, clr2)
        new_hotkey('freestand', bind_system.freestand[1], 'c', position, clr2)
        new_hotkey('hide', ui_get(ref_visible.on_shot_aa[2]), 'c', position, clr2)
        -- new_hotkey('BODY', ui.get(cvar.forcebaim), 'c', position, clr2)
        -- new_hotkey('SAFE', ui.get(cvar.safepoint), 'c', position, clr2)
        -- new_hotkey('FD', ui.get(cvar.fakeduck), 'c', position, clr2)
        -- new_hotkey('FS', var.usingfs, 'c', position, clr2)
    
        renderer.texture(cat_svg, position.x + crosshair_cache.main_scope + 23, position.y - 13, 25, 25, logo[1],
            logo[2],
            logo[3],
            crosshair_cache.logo_alpha, "f")
        renderer.texture(cat_outline_png, position.x + crosshair_cache.main_scope + 23, position.y - 13, 25, 25,
            logo_outline[1],
            logo_outline[2],
            logo_outline[3],
            logo_outline[4], "f")
        renderer.texture(cat_outline_png, position.x + crosshair_cache.main_scope + 23, position.y - 13,
            25, 25, logo_outline[1],
            logo_outline[2],
            logo_outline[3],
            logo_outline[4], "f")
    end

    return this
end)()


local can_hit = function(me, threat, eye_pos)
    if threat == nil then
        return false
    end

    local threat_pos_lowerbody = {entity_hitbox_position(threat, 2)}
    local threat_pos_plevis = {entity_hitbox_position(threat, 5)}

    local _, dmg2 = client_trace_bullet(me, eye_pos[1], eye_pos[2], eye_pos[3], threat_pos_plevis[1], threat_pos_plevis[2], threat_pos_plevis[3], true)
    local _, dmg1 = client_trace_bullet(me, eye_pos[1], eye_pos[2], eye_pos[3], threat_pos_lowerbody[1], threat_pos_lowerbody[2], threat_pos_lowerbody[3], true)

    if dmg2 > 1 or dmg1 > 1 then
        return true
    end

    return false
end

local on_peek = function(me, wpn, threat, fired, ext)
    local pos = {client_eye_position()}
    local vel = {entity_get_prop(me, 'm_vecVelocity')}
    local idx = entity_get_prop(wpn, 'm_iItemDefinitionIndex')

    if idx == nil or threat == nil then
        return false
    end

    local speed = csgo_weapons[idx].max_player_speed_alt
    
    local disable = can_hit(me, threat, pos) or fired

    local predicted_pos = {pos[1] + (vel[1] / speed) * ext, pos[2] + (vel[2] / speed) * ext, pos[3] + (vel[3] / speed) * ext}

    local pelvis = {entity_hitbox_position(threat, 5)}
    local _, pelvis_ent = client_trace_line(me, predicted_pos[1], predicted_pos[2], predicted_pos[3], pelvis[1], pelvis[2], pelvis[3])

    if pelvis_ent == threat and not disable then
        local _, pelvis_ent = client_trace_line(me, pos[1], pos[2], pos[3], pelvis[1], pelvis[2], pelvis[3])
        if pelvis_ent ~= threat then
            return true
        else
            return false
        end
    else
        return false
    end
end

local calc_angle = function(from, to)
	local vec = vector(to.x - from.x, to.y - from.y, to.z - from.z)
	local hyp = math.sqrt(vec.x*vec.x+vec.y*vec.y+vec.z*vec.z)
	
	local pitch = -math.asin(vec.z / hyp) * 57.29578
	if pitch > 89.0 then pitch = 89.0 end
	if pitch < -89.0 then pitch = -89.0 end
	
	local yaw = math.atan2(vec.y, vec.x) * 57.29578
	while yaw < -180.0 do angle = angle + 360.0 end
	while yaw > 180.0 do angle = angle - 360.0 end
	
	return vector(pitch, yaw, 0)
end

local antiaim_func = (function()
	local this = { }

    function this:enemy_on_peek(me, cur_threat, ext)
        if cur_threat == nil then
            return false
        end
    
        local pos = {entity_hitbox_position(cur_threat, 0)}
        local vel = {entity_get_prop(cur_threat, 'm_vecVelocity')}
        local wpn = entity_get_player_weapon(cur_threat)
        local idx = entity_get_prop(wpn, 'm_iItemDefinitionIndex')
    
        if idx == nil then return false end
    
        local speed = csgo_weapons[idx].max_player_speed_alt
    
        local predicted_pos = {pos[1] + (vel[1] / speed) * ext, pos[2] + (vel[2] / speed) * ext, pos[3] + (vel[3] / speed) * ext}
    
        local pelvis = {entity_hitbox_position(me, 5)}
        local _, pelvis_ent = client_trace_line(cur_threat, predicted_pos[1], predicted_pos[2], predicted_pos[3], pelvis[1], pelvis[2], pelvis[3])
    
        if pelvis_ent == me then
            local _, pelvis_ent = client_trace_line(me, pos[1], pos[2], pos[3], pelvis[1], pelvis[2], pelvis[3])
            if pelvis_ent ~= me then
                return true
            else
                return false
            end
        else
            return false
        end
    end

    function this:should_disable_cyaw(LocalPlayer, weapon, cmd)
        local isNade        = contains(nade, entity_get_classname(weapon))
        local movement      = entity_get_prop(LocalPlayer, 'm_MoveType') == 9 or entity_get_prop(LocalPlayer, 'm_MoveType') == 8
        local using         = cmd.in_attack == 1 or cmd.in_use == 1 or cmd.in_attack ~= 0 or cmd.in_grenade1 ~= 0 or cmd.in_grenade2 ~= 0
        local m_bPinPulled, m_fThrowTime = entity_get_prop(weapon, 'm_bPinPulled'), entity_get_prop(weapon, 'm_fThrowTime')
        local in_freeze = entity_get_prop(entity.get_game_rules(), 'm_bFreezePeriod') == 1

        if using or in_freeze then
            return true
        end

        if isNade then
            if m_bPinPulled then
                if m_fThrowTime > 0 and m_fThrowTime < globals_curtime() + client.latency() + 0.5 then
                    return true
                end
            end
        end
        
        if movement then
            return true
        end
        
        return false
    end

	function this:get_flag(me, cmd) -- { 'Global', 'Moving', 'Standing', 'Slow Motion', 'Duck', 'In Air' }
		local state = 'Global'
		local m_vec = { entity_get_prop(me, 'm_vecVelocity') }
		local speed = math_sqrt(m_vec[1]^2 + m_vec[2]^2)
		local in_air = m_vec[3]^2 > 0 or cmd.in_jump == 1
        local air = bit.band(entity.get_prop(me, 'm_fFlags'), 1) == 0
        local duck_amount = entity.get_prop(me, 'm_flDuckAmount')
        if air == false then
            ground_time = ground_time + 1
        else
            ground_time = 0
        end

        if not ui_get(ref_visible.on_shot_aa[2]) and not ui_get(ref_visible.doubletap[2]) and ui_get(custom_aa[8].active) then
            state = 'Fakelag'
        elseif ui_get(ref_hidden.misc.slow_mo[2]) and ui_get(custom_aa[4].active) then
			state = 'Slow Motion'
        elseif in_air and duck_amount > 0 and ui_get(custom_aa[7].active) then
			state = 'Air Duck'
		elseif in_air and ui_get(custom_aa[6].active) then
			state = 'In Air'
		elseif (duck_amount > 0 or ui_get(ref_visible.fake_duck)) and ui_get(custom_aa[5].active) then
			state = 'Duck'
		elseif speed < 2 and ui_get(custom_aa[2].active) then
			state = 'Standing'
		elseif speed >= 2 and ui_get(custom_aa[3].active) then
			state = 'Moving'
		else
			state = 'Global'
		end

		return state, { 
            choking = ui_get(ref_visible.on_shot_aa[2]) and not ui_get(ref_visible.doubletap[2]),
            slow_mo = ui_get(ref_hidden.misc.slow_mo[2]),
            in_air = in_air,
            air_duck = in_air and duck_amount > 0,
            duck = (duck_amount > 0 or ui_get(ref_visible.fake_duck)),
            standing = speed < 2,
            moving = speed >= 2
        }
  	end

    function this:body_yaw_jitter(seed, max_limit, val)
        local v23 = { }
    
        if val == -180 then
            v23[0] = -max_limit / 1.5
            v23[1] = max_limit / 1.5
        else
            if val ~= 0 then
                if val == 180 then
                    v23[0] = -max_limit / 2
                    v23[1] = max_limit / 2
                else
                    math.randomseed(val)
                    v23[0] = math.random(-max_limit, max_limit)
                    v23[1] = math.random(-max_limit, max_limit)
    
                    if math_abs(v23[0]) < 25 or math_abs(v23[1]) < 25 then
                        v23[0] = -max_limit
                        v23[1] = max_limit
                    end
                end
    
                return v23[seed % 2]
            end
    
            v23[1] = max_limit
        end
    
        v23[0] = -max_limit
    
        return v23[seed % 2]    
    end

	function this:entity_close(me, classname, net_prop) -- credits to phil
	   	local entities = entity_get_all(classname)
	   	local lp_vec3 = vector(entity_get_prop(me, 'm_vecOrigin'))
	   	for i = 1, #entities do
	      	if net_prop == nil or entity_get_prop(entities[i], net_prop) == 1 then
	         	local ent_vec = vector(entity_get_prop(entities[i], 'm_vecOrigin'))

	         	if 80 > ent_vec:dist(lp_vec3) then
	            	return true
	         	end
	      	end
	   	end
	end

    return this
end)()

local fakelag_func = (function()
    local this = { }

    local function weapon_is_ready(me, wpn, ticks_before_ready)
        if me == nil or wpn == nil then
            return false
        end
    
        ticks_before_ready = ticks_before_ready or 0
    
        local curtime = globals_curtime() - (ticks_before_ready * globals_tickinterval())
        local m_bPinPulled, m_fThrowTime = entity_get_prop(wpn, 'm_bPinPulled'), entity_get_prop(wpn, 'm_fThrowTime')
    
        if curtime < entity_get_prop(me, 'm_flNextAttack') then
            return false
        end
    
        if contains(nade, entity_get_classname(wpn)) then
            return not (m_bPinPulled ~= nil and m_bPinPulled == 0 and (m_fThrowTime > 0 and m_fThrowTime < globals_curtime()))
        elseif curtime < entity_get_prop(wpn, 'm_flNextPrimaryAttack') then
            return false
        end
    
        return true
    end
    
    function this:client_fire(me, wpn)
        local weapon_fired = false
        local cur_time = math_floor(globals_curtime() + 0.5)
        local fired_time = math_floor(entity_get_prop(wpn, 'm_fLastShotTime') + 0.5)
        local wpn_is_ready = weapon_is_ready(me, wpn, 0)
    
        if cur_time == fired_time and weapon_fired == false and entity_get_prop(wpn, 'm_flNextPrimaryAttack') - globals_curtime() > 0.16 and not wpn_is_ready then
            weapon_fired = true
        else
            weapon_fired = false
        end
    
        return weapon_fired
    end

    function this:trigger_found(me, wpn, threat, fired, cmd)
        local entity_obj_me = Entity.get_local_player()
        local anim_state = entity_obj_me:get_anim_state()
        local is_ducking = entity_get_prop(me, 'm_bDucking') == 1 or cmd.in_duck == 1 or ui_get(ref_visible.fake_duck)
        local m_vec = {entity_get_prop(me, 'm_vecVelocity')}
    
        -- get fakelag triggers
        local random_init = client_key_state(0x10) and cmd.command_number % client_random_int(2, 3) <= 1
        local on_accel = (((anim_state.stop_to_full_running_fraction > 0 and anim_state.stop_to_full_running_fraction < 0.37) or (anim_state.clamped_velocity > 0.09 and anim_state.clamped_velocity < 0.46)) and not client_key_state(0x10)) or random_init
        
        local duck = is_ducking and contains(ui_get(fakelag_tab.trigger), 'Ducking')
        local in_air = (m_vec[3] ^ 2 > 0 or cmd.in_jump == 1) and contains(ui_get(fakelag_tab.trigger), 'In Air')
        local hit_ground = anim_state.hit_in_ground_animation and contains(ui_get(fakelag_tab.trigger), 'Reset on bhop')
        local on_peek = on_peek(me, wpn, threat, fired, 80) and contains(ui_get(fakelag_tab.trigger), 'On peek')

        local trigger_inspired = (duck or in_air or on_accel or hit_ground or on_peek) and not fired
    
        return trigger_inspired
    end

    return this
end)()

local close_to_solid = function(me)  
    local vec_trace_start = vector(client_eye_position())
    local dist = 0.23

    for flYaw = 18, 360, 18 do
        flYaw = normalize(flYaw)

        local vecTraceEnd = vec_trace_start + vector():init_from_angles(0, flYaw, 0) * 0x60
        local traceInfo = trace.line(vec_trace_start, vecTraceEnd, { skip = me, mask = 'MASK_NPCSOLID' })

        if traceInfo.fraction < dist then
            return true
        end
    end
end
local defensive_ticks = 0
local body_yaw = 0
local inverted = 0
local aa_side = 0
local native_GetClientEntity = vtable_bind("client.dll", "VClientEntityList003", 3, "uintptr_t(__thiscall*)(void*, int)");

do_defensive = function ()
    local player = entity.get_local_player( )

    if player == nil then
        return
    end

    local ptr = native_GetClientEntity(player);

    local m_flSimulationTime = entity.get_prop(player, "m_flSimulationTime");
    local m_flOldSimulationTime = ffi.cast("float*", ptr + 0x26C)[0];

    if (m_flSimulationTime - m_flOldSimulationTime < 0) then
        defensive_ticks = globals.tickcount() + toticks(.200);
    end
end

client.set_event_callback( "net_update_start", function(  )
    do_defensive()
end)

local defensive = 0

local antiaim_bot = function(me, wpn, cmd)
    local manual_state = ui_get(bind_system.state)
    local manual_offset = ({ 
        [1] = -69, 
        [2] = 88, 
    })[manual_state]

	local idx, state = antiaim_func:get_flag(me, cmd)
	local state_to_idx = state_to_idx[idx]
    local m_vec = {entity_get_prop(me, 'm_vecVelocity')}
    local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local inverted = body_yaw > 0
    local aa_side = inverted and 1 or -1
    --local state_to_idx = { ['Global'] = 1, ['Standing'] = 2, ['Moving'] = 3, ['Slow Motion'] = 4, ['Duck'] = 5, ['In Air'] = 6, ['Fakelag'] = 7 }
    local val = {
        yaw_slider = (manual_state == 0 or manual_state == 3) and ui_get(custom_aa[state_to_idx].yaw_slider) or manual_offset,
        yaw_base = (manual_state == 0 or manual_state == 3) and 1 or 2,
        yaw = ui_get(custom_aa[state_to_idx].yaw),
        yaw_slider_l = (manual_state == 0 or manual_state == 3) and ui_get(custom_aa[state_to_idx].yaw_slider_l) or manual_offset,
        yaw_slider_r = (manual_state == 0 or manual_state == 3) and ui_get(custom_aa[state_to_idx].yaw_slider_r) or manual_offset,
        yaw_slider_tick = ui_get(custom_aa[state_to_idx].yaw_slider_tick),
        yaw_slider_min_l = (manual_state == 0 or manual_state == 3) and ui_get(custom_aa[state_to_idx].yaw_slider_min_l) or manual_offset,
        yaw_slider_max_l = (manual_state == 0 or manual_state == 3) and ui_get(custom_aa[state_to_idx].yaw_slider_max_l) or manual_offset,
        yaw_slider_step_l = ui_get(custom_aa[state_to_idx].yaw_slider_step_l),
        yaw_slider_min_r = (manual_state == 0 or manual_state == 3) and ui_get(custom_aa[state_to_idx].yaw_slider_min_r) or manual_offset,
        yaw_slider_max_r = (manual_state == 0 or manual_state == 3) and ui_get(custom_aa[state_to_idx].yaw_slider_max_r) or manual_offset,
        yaw_slider_step_r = ui_get(custom_aa[state_to_idx].yaw_slider_step_r), 
        yaw_jitter = ui_get(custom_aa[state_to_idx].yaw_jitter),
        yaw_jitter_speed = ui_get(custom_aa[state_to_idx].yaw_jitter_speed),
        yaw_jitter_val = (manual_state == 0 or manual_state == 3) and ui_get(custom_aa[state_to_idx].yaw_jitter_val) or 0,
        body_yaw = ui_get(custom_aa[state_to_idx].body_yaw),
        body_yaw_val = ui_get(custom_aa[state_to_idx].body_yaw_val),
        body_yaw_opt = ui_get(custom_aa[state_to_idx].body_yaw_opt),
        body_yaw_tick = ui_get(custom_aa[state_to_idx].body_yaw_tick),
        body_yaw_val_l = ui_get(custom_aa[state_to_idx].body_yaw_val_l),
        body_yaw_val_r = ui_get(custom_aa[state_to_idx].body_yaw_val_r),
        body_yaw_min_l = ui_get(custom_aa[state_to_idx].body_yaw_min_l),
        body_yaw_max_l = ui_get(custom_aa[state_to_idx].body_yaw_max_l),
        body_yaw_step_l = ui_get(custom_aa[state_to_idx].body_yaw_step_l),
        body_yaw_min_r = ui_get(custom_aa[state_to_idx].body_yaw_min_r),
        body_yaw_max_r = ui_get(custom_aa[state_to_idx].body_yaw_max_r),
        body_yaw_step_r = ui_get(custom_aa[state_to_idx].body_yaw_step_r),
        fake_limit = ui_get(custom_aa[state_to_idx].fake_limit),
        fake_opt = ui_get(custom_aa[state_to_idx].fake_opt),
        fake_tick = ui_get(custom_aa[state_to_idx].fake_tick),
        fake_limit_l = ui_get(custom_aa[state_to_idx].fake_limit_l),
        fake_limit_r = ui_get(custom_aa[state_to_idx].fake_limit_r),
        fake_min_l = ui_get(custom_aa[state_to_idx].fake_min_l),
        fake_max_l = ui_get(custom_aa[state_to_idx].fake_max_l),
        fake_step_l = ui_get(custom_aa[state_to_idx].fake_step_l),
        fake_min_r = ui_get(custom_aa[state_to_idx].fake_min_r),
        fake_max_r = ui_get(custom_aa[state_to_idx].fake_max_r),
        fake_step_r = ui_get(custom_aa[state_to_idx].fake_step_r),
        defensive = ui_get(custom_aa[state_to_idx].defensive),
        def_pitch = ui_get(custom_aa[state_to_idx].def_pitch),
        pitch_opt = ui_get(custom_aa[state_to_idx].pitch_opt),
        pitch_val = ui_get(custom_aa[state_to_idx].pitch_val),
        def_yaw = ui_get(custom_aa[state_to_idx].def_yaw),
        yaw_opt = ui_get(custom_aa[state_to_idx].yaw_opt),
        yaw_val = ui_get(custom_aa[state_to_idx].yaw_val),
        yaw_val_tick = ui_get(custom_aa[state_to_idx].yaw_val_tick),
        yaw_val_l = ui_get(custom_aa[state_to_idx].yaw_val_l),
        yaw_val_r = ui_get(custom_aa[state_to_idx].yaw_val_r),
    }

    local in_air = cmd.in_jump == 1 or m_vec[3] ^ 2 > 0
    local speed = math_sqrt(m_vec[1]^2 + m_vec[2]^2)

    local threat = client_current_threat()
    local ladder_check = (close_to_solid(me) and (speed > 2 or in_air)) and not ui_get(ref_hidden.misc.slow_mo[2])
    local cancel_cyaw = antiaim_func:should_disable_cyaw(me, wpn, cmd) or bind_system.freestand[1] or ui_get(bind_system.edge[2]) or ladder_check

    local c_yaw = vector(client_camera_angles()).y
    local viewangles = c_yaw
    local pitch = pitchnigga

    local nswitch = 1
    local no_entry = lag_record(me).shifting_no_entry
    local enemy_peeking = antiaim_func:enemy_on_peek(me, threat, 131)
    has_been_fired = fakelag_func:client_fire(me, wpn) and ui_get(fl_opts)
    local self_peeking = on_peek(me, wpn, threat, has_been_fired, 56)
    local defensive = defensive_ticks > globals.tickcount()

    if val.defensive == 'On' then
        cmd.force_defensive = 1 
    else 
        cmd.force_defensive = 0
    end 

    if val.defensive == 'On' and val.def_pitch == 'On' then
        if defensive then
            if val.pitch_opt == 'Zero' then
                pitchnigga = 0
            elseif val.pitch_opt == 'Up' then
                pitchnigga = -89
            elseif val.pitch_opt == 'Down' then
                pitchnigga = 89
            elseif val.pitch_opt == 'Random' then
                pitchnigga = math.random(-89,89)
            elseif val.pitch_opt == 'Custom' then
                pitchnigga = val.pitch_val
            end
        else 
            pitchnigga = 89
        end
    else 
        pitchnigga = 89
    end
     
    if val.defensive == 'On' and val.def_yaw == 'On' then
        if defensive then
            if val.yaw_opt == 'Forward' then
                def_yaw_nigga = 0 
            elseif val.yaw_opt == 'Random' then
                def_yaw_nigga = math.random(180,-180)
            elseif val.yaw_opt == 'Custom' then
                def_yaw_nigga = val.yaw_val 
            elseif val.yaw_opt == 'Advanced' then
                def_yaw_nigga = (val.yaw_val_tick / 2 <= (globals.tickcount() % val.yaw_val_tick)) and val.yaw_val_l or val.yaw_val_r
            end
        else 
            def_yaw_nigga = 0
        end
    else 
        def_yaw_nigga = 0
    end
    local pitch = pitchnigga
    if val.fake_opt == 'Static' then
        fakenigga = val.fake_limit
    elseif val.fake_opt == 'Advanced' then
        fakenigga = (val.fake_tick / 2 <= (globals.tickcount() % val.fake_tick)) and val.fake_limit_r or val.fake_limit_l
    elseif val.fake_opt == 'Ataraxia' then
        fakenigger1 = math.random(val.fake_min_l, val.fake_max_l) + math.random(0,val.fake_step_l*3) * 0.5
        fakenigger2 = math.random(val.fake_min_r, val.fake_max_r) + math.random(0,val.fake_step_r*3) * 0.5
        fakenigga = (val.fake_tick / 2 <= (globals.tickcount() % val.fake_tick)) and fakenigger1 or fakenigger2
    end
    if val.body_yaw_opt == 'Static' then
        bodynigga = val.body_yaw_val
    elseif val.body_yaw_opt == 'Advanced' then
        bodynigga = (val.body_yaw_tick / 2 <= (globals.tickcount() % val.body_yaw_tick)) and val.body_yaw_val_r or val.body_yaw_val_l
    elseif val.body_yaw_opt == 'Ataraxia' then
        bodynigger1 = math.random(val.body_yaw_min_l, val.body_yaw_max_l) + math.random(0,val.body_yaw_step_l*3) * 0.5
        bodynigger2 = math.random(val.body_yaw_min_r, val.body_yaw_max_r) + math.random(0,val.body_yaw_step_r*3) * 0.5
        bodynigga = (val.body_yaw_tick / 2 <= (globals.tickcount() % val.body_yaw_tick)) and bodynigger1 or bodynigger2
    end

    if val.yaw == 'Static' then
        nigga = val.yaw_slider
    elseif val.yaw == 'Desync' then
        nigga = (aa_side ~= 1 and val.yaw_slider_r or val.yaw_slider_l)
    elseif val.yaw == 'Ataraxia' then
        nigger1 = math.random(val.yaw_slider_min_l, val.yaw_slider_max_l) + math.random(0,val.yaw_slider_step_l*3) * 0.5
        nigger2 = math.random(val.yaw_slider_min_r, val.yaw_slider_max_r) + math.random(0,val.yaw_slider_step_r*3) * 0.5
        nigga = (val.yaw_slider_tick / 2 <= (globals.tickcount() % val.yaw_slider_tick)) and nigger1 or nigger2
    end

    local real_yaw = nigga + 180
    if val.yaw_jitter == 'Center' then
        local jitter_val = val.yaw_jitter_val * (m_uniqueSeed % (2 * val.yaw_jitter_speed + 2) <= 1 * val.yaw_jitter_speed and 0.5 or -0.5)
        real_yaw = real_yaw + jitter_val
        nswitch = jitter_val > 0 and 1 or -1
    elseif val.yaw_jitter == 'Offset' then
        local jitter_val = val.yaw_jitter_val * (m_uniqueSeed % (2 * val.yaw_jitter_speed + 2) <= 1 * val.yaw_jitter_speed and 0 or 1)
        real_yaw = real_yaw + jitter_val
    elseif val.yaw_jitter == 'Skitter' then
        ui_set(ref_list[9], 'Off')
        local jitter_val = 0
        if m_uniqueSeed % 3 < 1 then
            jitter_val = val.yaw_jitter_val
            real_yaw = real_yaw + jitter_val
        elseif m_uniqueSeed % 3 > 1 then
            jitter_val = -val.yaw_jitter_val
            real_yaw = real_yaw + jitter_val
        end
    end

    if val.body_yaw == 'Jitter' then
        bodynigga = antiaim_func:body_yaw_jitter(m_uniqueSeed, 180, bodynigga)
    end

    if val.body_yaw == 'Switch' then
        if no_entry % 4 <= 1 then
            nswitch = -1
        end
    end

    if threat ~= nil then
        local local_origin = vector(entity.get_origin(me))
		local enemy_origin = vector(entity.get_origin(threat))
		local distance = local_origin:dist(enemy_origin)
		local weapon = entity_get_player_weapon(threat)

		if entity_get_classname(weapon) == 'CKnife' and distance <= 187 then
            real_yaw = 0
            pitch = 0
		end
	end

    if not cancel_cyaw and (manual_state == 0 or manual_state == 3) then
        if threat and val.yaw_base == 1 then 
            local angles = calc_angle(vector(entity.get_origin(me)), vector(entity.get_origin(threat)))
            viewangles = angles.y
        end

        if val.defensive == 'On' and val.def_yaw == 'On' and defensive then 
            viewangles = viewangles + def_yaw_nigga
        else 
            viewangles = viewangles + real_yaw
        end
        if cmd.chokedcommands == 0 and not has_been_fired then
            viewangles = viewangles - bodynigga / 150 * fakenigga * nswitch 
            cmd.allow_send_packet = false
        end

        cmd.yaw = viewangles
        cmd.pitch = pitch
    else
        ui_set(ref_list[6], val.yaw_slider)
    end

    local is_charged = lag_record(me).shifting_ticks > 1
end

local setup_fakelag = function(me, wpn, cmd)
    if not ui_get(fl_opts) then return end

    if ui_get(ref_visible.fake_duck) then
        ui_set(ref_hidden.fakelag.limit, 15)
        return
    end

    local fakelag_limit = ui_get(fakelag_tab.normal_limit)
    local _bSendPacket = cmd.allow_send_packet
    local _fChokedCmds = cmd.chokedcommands

    local threat = client_current_threat()

    if threat == nil then return end

    local trigger_on = fakelag_func:trigger_found(me, wpn, threat, has_been_fired, cmd)

    local amount = (function()
        local mode = ui_get(fakelag_tab.amount)
        if mode == 'Dynamic' then
            local player_resource = entity_get_all('CCSPlayerResource')[1]
            local ping = entity_get_prop(player_resource, 'm_iPing', threat)
            if ping > 60 or trigger_on then
                return 'Maximum'
            else
                return 'Dynamic'
            end
        end
        return 'Maximum'
    end)()

    if trigger_on then
        fakelag_limit = ui_get(fakelag_tab.trigger_limit)
    end

    if not _bSendPacket and _fChokedCmds >= fakelag_limit then
        _bSendPacket = true
    end

    if ui_get(ref_visible.on_shot_aa[2]) then
        fakelag_limit = 1
    end

    ui_set(ref_hidden.fakelag.enabled, true)
    ui_set(ref_hidden.fakelag.limit, fakelag_limit)
    ui_set(ref_hidden.fakelag.amount, amount)
end

local set_client_anim = function()
    local me = entity_get_local_player()
    local wpn = entity_get_player_weapon(me)

    if wpn ~= nil then
        local in_air = bit_band(entity_get_prop(me, 'm_fFlags'), 1) == 1
        local ref_legs = ui.reference("AA", "other", "leg movement")
        if in_air then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals_curtime() + 0.83
        end

        if contains(ui_get(visual_tab.client_anim), '0 pitch on land') then
            if ground_ticks > 7 and end_time > globals_curtime() then
                entity_set_prop(me, 'm_flPoseParameter', 0.5, 12)
            end
        end

        if (client_key_state(0x20) or not in_air) or (ground_ticks > 0 and end_time > globals_curtime()) then
            if contains(ui_get(visual_tab.client_anim), 'Static leg in air') then
                entity_set_prop(me, 'm_flPoseParameter', 1, 6)
            end
        end


        if ground_ticks <= 2 and end_time > globals_curtime() and contains(ui_get(visual_tab.client_anim), 'Walking in air') then
            local anim_layer = Entity.new(me):get_anim_overlay(6)

            anim_layer.weight = 1
        end


        if contains(ui_get(visual_tab.client_anim), 'Leg inverse') then
            entity_set_prop(me, 'm_flPoseParameter', 1, 0)
            ui.set(ref_legs, "Always Slide")
        end
    end
end

local g_setup_command = function(cmd)
    local me = entity_get_local_player()
    local wpn = entity_get_player_weapon(me)
    if me == nil or wpn == nil or not ui_get(master_switch) then return end

    if cmd.chokedcommands == 0 then
        m_uniqueSeed = m_uniqueSeed + 1
    end

    bind_system:update_manual()
    antiaim_bot(me, wpn, cmd)
    setup_fakelag(me, wpn, cmd)
end

local destory = function()
    for k, v in pairs(ref_list) do
        ui_set_visible(v, true)
    end

    ui_set(ref_hidden.anti_aim.pitch[1], 'Off')
    ui_set(ref_hidden.anti_aim.pitch[2], 0)
    ui_set(ref_hidden.anti_aim.yaw[2], 0)
    ui_set(ref_hidden.anti_aim.body_yaw[2], 0)
    ui_set(ref_hidden.anti_aim.yaw_jitter[1], 'Off')
    ui_set(ref_hidden.anti_aim.yaw_jitter[2], 0)
    ui_set(ref_hidden.anti_aim.body_yaw[1], 'Off')
end

client_set_event_callback('shutdown', destory)

client_set_event_callback('pre_render', set_client_anim)
client_delay_call(0, client_set_event_callback, 'setup_command', g_setup_command)

client_set_event_callback('paint_ui', handle_ui_visible)

client_set_event_callback('paint', function()
    local me = entity_get_local_player()
    local active = ui_get(master_switch)
    if not entity_is_alive(me) or not active then 
        return 
    end

    render:draw_ind(me)
end)

client_set_event_callback('post_config_load', function()
    ui_set(bind_system.state, 0)
end)

ui_new_button('AA', 'Other', 'Export custom settings', function()
    local t_to_j = {}

    for i, o in pairs(all_ui) do 
        if ui_get(o) ~= nil then 
            t_to_j[i] = ui_get(o)
        end
    end

    local code = base64.encode(json_stringify(t_to_j))

    clipboard.set(code)
    client.color_log(166, 166, 252, 'Ataraxia config has been exported!')
end)

ui_new_button('AA', 'Other', 'Import custom settings', function()
    local j_to_t = json_parse(base64.decode(clipboard.get()))
    for i, o in pairs(all_ui) do 
        if ui_get(o) ~= nil then 
            ui_set(o, j_to_t[i])
        end 
    end
    client.color_log(166, 252, 199, 'config loaded!')
end)