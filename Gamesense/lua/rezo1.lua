-- Если table.new недоступна, создаём fallback
local table_new = table.new or function(narr, nrec) return {} end
local ffi = require("ffi")
local bit = require("bit")

-----------------------[ Helper Functions ]-----------------------
local function clamp(x, min_val, max_val)
    return math.min(math.max(min_val, x), max_val)
end

local function average(t)
    local sum = 0
    for _, v in ipairs(t) do
        sum = sum + v
    end
    return (#t > 0) and (sum / #t) or 0
end

local function normalize(value, min_val, max_val)
    return (value - min_val) / (max_val - min_val)
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function calculate_angle(src, dst)
    local dx = dst[1] - src[1]
    local dy = dst[2] - src[2]
    local dz = dst[3] - src[3]
    local hyp = math.sqrt(dx * dx + dy * dy)
    local yaw = math.deg(math.atan2(dy, dx))
    local pitch = -math.deg(math.atan2(dz, hyp))
    return {pitch, yaw, 0}
end

-----------------------[ Data Retrieval Functions ]-----------------------
-- Определяем структуру анимационного слоя через FFI (используем многоточечный литерал для ясности)
-- Заменяем 0x18 на 24 (десятичное число)
local animation_layer_t = ffi.typeof([[
struct {
    char pad0[24];
    uint32_t m_nSequence;
    float m_flPrevCycle;
    float m_flWeight;
    float m_flWeightDeltaRate;
    float m_flPlaybackRate;
    float m_flCycle;
}
]])

local function get_animlayer_playback(ent, layer)
    if entity.get_client_entity then
        local ent_ptr = ffi.cast("void***", entity.get_client_entity(ent))
        local offsets = { animlayer = 0x2990 }
        local animlayer_ptr = ffi.cast("char*", ent_ptr) + offsets.animlayer
        local anim_layer = ffi.cast(animation_layer_t, animlayer_ptr)[0][layer]
        return anim_layer.m_flPlaybackRate
    elseif entity.get_animlayer then
        local anim_layer = entity.get_animlayer(ent, layer)
        if anim_layer and anim_layer.m_flPlaybackRate then
            return anim_layer.m_flPlaybackRate
        end
    end
    return 1  -- значение по умолчанию
end

local function get_velocity(ent)
    local vel = entity.get_prop(ent, "m_vecVelocity")
    if type(vel) == "table" then
        return math.sqrt((vel[1] or 0)^2 + (vel[2] or 0)^2)
    else
        return math.abs(vel)
    end
end

local function get_position(ent)
    local pos = entity.get_prop(ent, "m_vecOrigin")
    if type(pos) == "table" then
        return pos
    else
        return {0, 0, 0}
    end
end

-- Получаем текущий yaw (угол взгляда) из m_angEyeAngles; предполагается, что возвращается таблица {pitch, yaw, roll}
local function get_yaw(ent)
    local ang = entity.get_prop(ent, "m_angEyeAngles")
    if type(ang) == "table" then
        return ang[2] or 0
    else
        return 0
    end
end

-----------------------[ Smoothing / History ]-----------------------
local history_length = 5
local playback_history = {}  -- хранит последние значения playback rate для каждого игрока

local function update_playback_history(ent, value)
    playback_history[ent] = playback_history[ent] or {}
    local hist = playback_history[ent]
    if #hist >= history_length then table.remove(hist) end
    table.insert(hist, 1, value)
end

local alpha = 0.3  -- коэффициент экспоненциального сглаживания для playback rate
local playback_smooth = {}  -- сглаженное значение для каждого игрока

local function update_playback_smooth(ent, current)
    if not playback_smooth[ent] then
        playback_smooth[ent] = current
    else
        playback_smooth[ent] = alpha * current + (1 - alpha) * playback_smooth[ent]
    end
    return playback_smooth[ent]
end

local previous_angle = {}  -- хранит предыдущий вычисленный угол для каждого игрока
local angle_alpha = 0.4      -- коэффициент сглаживания для угла

local function smooth_angle(ent, newAngle)
    if not previous_angle[ent] then
        previous_angle[ent] = newAngle
    else
        previous_angle[ent] = angle_alpha * newAngle + (1 - angle_alpha) * previous_angle[ent]
    end
    return previous_angle[ent]
end

-- Отслеживаем изменения yaw для оценки динамики (например, если противник резко меняет угол)
local previous_yaw = {}

local function update_yaw_diff(ent)
    local curYaw = get_yaw(ent)
    local prevYaw = previous_yaw[ent] or curYaw
    local diff = math.abs(curYaw - prevYaw)
    previous_yaw[ent] = curYaw
    return clamp(diff / 180, 0, 1)  -- нормализуем разницу, предполагаем максимум 180 градусов
end

-----------------------[ Гибридный Адаптивный Ресольвер ]-----------------------
-- Весовые коэффициенты
local weightPlayback = 0.5
local weightVelocity = 0.3
local weightYawDiff = 0.2
local interp_exponent = 1.5
local default_max_velocity = 260

local function hybrid_resolver(ent)
    if not entity.is_alive(ent) then return end

    local currentPlayback = get_animlayer_playback(ent, 6) or 0
    local velocity = get_velocity(ent)
    local yawDiff = update_yaw_diff(ent)  -- нормализованная разница yaw

    update_playback_history(ent, currentPlayback)
    local avgPlayback = average(playback_history[ent])
    local smoothPlayback = update_playback_smooth(ent, avgPlayback)
    
    local normPlayback = clamp(normalize(smoothPlayback, 0, 1), 0, 1)
    local normVelocity = clamp(normalize(velocity, 0, default_max_velocity), 0, 1)
    
    -- Вычисляем взвешенное значение f:
    local totalWeight = weightPlayback + weightVelocity + weightYawDiff
    local f = (weightPlayback * normPlayback + weightVelocity * (1 - normVelocity) + weightYawDiff * yawDiff) / totalWeight
    local f_adjusted = math.pow(f, interp_exponent)
    
    -- Интерполяция между +60 (если f_adjusted=0) и -60 (если f_adjusted=1)
    local angle = lerp(60, -60, f_adjusted)
    local finalAngle = smooth_angle(ent, angle)
    
    plist.set(ent, 'Force body yaw', true)
    plist.set(ent, 'Force body yaw value', finalAngle)
    
    return { normPlayback = normPlayback, normVelocity = normVelocity, normYawDiff = yawDiff, rawAngle = angle, finalAngle = finalAngle }
end

-----------------------[ Aimbot для Прицеливания в Голову ]-----------------------
local function aim_at_head(ent)
    local localPlayer = entity.get_local_player()
    local src = get_position(localPlayer)
    local headPos = (entity.get_hitbox_position and entity.get_hitbox_position(ent, 0)) or get_position(ent)
    local angle = calculate_angle(src, headPos)
    -- Пример: установка угла через aimbot (замените на вашу функцию, если требуется)
    client.exec_command("setang " .. table.concat(angle, " "))
    print("[aim_fire] Aiming at head for Entity " .. tostring(ent) .. ": " .. table.concat(angle, ", "))
end

-----------------------[ Логирование Hit/Miss Событий ]-----------------------
local function onAimHit(e)
    if not e.target then return end
    local ent = e.target
    if not entity.is_alive(ent) then return end
    
    local data = hybrid_resolver(ent)
    print("[aim_hit] Entity " .. tostring(ent) ..
          ": normPlayback=" .. data.normPlayback ..
          ", normVelocity=" .. data.normVelocity ..
          ", normYawDiff=" .. data.normYawDiff ..
          ", rawAngle=" .. data.rawAngle ..
          ", finalAngle=" .. data.finalAngle)
    -- Если голова видна, при попадании можем прицелиться в голову:
    if entity.get_hitbox_position then
        aim_at_head(ent)
    end
end

local function onAimMiss(e)
    if not e.target then return end
    local ent = e.target
    if not entity.is_alive(ent) then return end
    
    local data = hybrid_resolver(ent)
    print("[aim_miss] Entity " .. tostring(ent) ..
          ": normPlayback=" .. data.normPlayback ..
          ", normVelocity=" .. data.normVelocity ..
          ", normYawDiff=" .. data.normYawDiff ..
          ", rawAngle=" .. data.rawAngle ..
          ", finalAngle=" .. data.finalAngle)
end

client.set_event_callback("aim_hit", onAimHit)
client.set_event_callback("aim_miss", onAimMiss)

-----------------------[ Основной Цикл ]-----------------------
local function run_resolver()
    local players = entity.get_players(true)
    for i = 1, #players do
        local ent = players[i]
        if entity.is_alive(ent) then
            hybrid_resolver(ent)
        end
    end
    client.delay_call(0.1, run_resolver)
end

run_resolver()
