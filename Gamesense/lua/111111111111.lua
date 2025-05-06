------------------------------------------------------------------------------
--  SIMPLE MATH RESOLVER + HEAD-ONLY EXAMPLE
------------------------------------------------------------------------------

local resolver = {}

ui.new_label("Lua", "B", "Math Resolver + HeadShots")
local enable_resolver = ui.new_checkbox("Lua", "B", "Enable Math Resolver + HeadShots")

-------------------------------------------------------------------------------
--  Globale Miss-Variable (falls du einen Counter anzeigen willst)
-------------------------------------------------------------------------------
local total_misses = 0

-------------------------------------------------------------------------------
--  Gegner-Daten (pro Entindex)
-------------------------------------------------------------------------------
local resolver_data = {}
-- Jede Tabelle:
-- {
--   misses = 0,
--   shot_time = 0,
--   last_eye_angle = 0,
--   last_lby = 0,
--   -- etc.
-- }

-------------------------------------------------------------------------------
--  Einstellungen / Parameter
-------------------------------------------------------------------------------
local DESYNC_DELTA_THRESH = 35  -- Ab welchem Winkelunterschied (EyeYaw - LBY) starker Desync
local SPEED_THRESHOLD     = 5   -- Unterhalb davon gilt der Gegner als „stehend“
local ONSHOT_TIME_WINDOW  = 0.25

-------------------------------------------------------------------------------
--  Hilfsfunktionen
-------------------------------------------------------------------------------
local function get_velocity(ent)
    local vx = entity.get_prop(ent, "m_vecVelocity[0]") or 0
    local vy = entity.get_prop(ent, "m_vecVelocity[1]") or 0
    return math.sqrt(vx*vx + vy*vy)
end

-------------------------------------------------------------------------------
--  Einfache Mathe-Heuristik für den RealAngle
-------------------------------------------------------------------------------
local function calculate_real_yaw(ent, data)
    local eye_yaw = entity.get_prop(ent, "m_angEyeAngles[1]") or 0
    local lby     = entity.get_prop(ent, "m_flLowerBodyYawTarget") or 0
    local speed   = get_velocity(ent)

    -- Zeit seit dem letzten Schuss (falls wir On-Shot verarbeiten wollen)
    local time_since_shot = globals.curtime() - (data.shot_time or 0)

    -- Normalisiere den Delta
    local delta = math.abs(eye_yaw - lby)
    if delta > 180 then
        delta = 360 - delta
    end

    -- Wenn kurz nach dem Schuss => On-Shot-Winkel
    if time_since_shot < ONSHOT_TIME_WINDOW and data.on_shot_angle ~= nil then
        return data.on_shot_angle
    end

    -- Ansonsten einfache Mathe-Logik
    if speed < SPEED_THRESHOLD then
        -- Gegner steht -> LBY oft nahe Real
        return lby
    else
        -- Gegner bewegt sich -> kann Jitter/Desync haben
        if delta > DESYNC_DELTA_THRESH then
            -- Starker Desync => Mittelwert
            return (lby + eye_yaw) * 0.5
        else
            -- Schwacher Desync => leichte Korrektur
            local half_diff = delta * 0.5
            if eye_yaw > lby then
                return (lby + half_diff) % 360
            else
                return (lby - half_diff) % 360
            end
        end
    end
end

-------------------------------------------------------------------------------
--  EVENTS
-------------------------------------------------------------------------------

--  weapon_fire: Gegner schießt -> wir merken uns den On-Shot-Angle
client.set_event_callback("weapon_fire", function(e)
    if not ui.get(enable_resolver) then return end

    local shooter_id = client.userid_to_entindex(e.userid)
    if not shooter_id or shooter_id == 0 then return end
    if not entity.is_enemy(shooter_id) then return end

    if not resolver_data[shooter_id] then
        resolver_data[shooter_id] = {
            misses = 0
        }
    end
    local data = resolver_data[shooter_id]

    data.on_shot_angle = entity.get_prop(shooter_id, "m_angEyeAngles[1]") or 0
    data.shot_time     = globals.curtime()
end)

--  aim_miss: Du verfehlst -> Miss-Counter hoch
client.set_event_callback("aim_miss", function(e)
    if not ui.get(enable_resolver) then return end

    local target = e.target
    if not target or target == 0 then return end

    local entindex = client.userid_to_entindex(target)
    if not entindex or entindex == 0 then return end

    if not resolver_data[entindex] then
        resolver_data[entindex] = {
            misses = 0
        }
    end
    local data = resolver_data[entindex]

    data.misses = (data.misses or 0) + 1
    total_misses = total_misses + 1
end)

--  aim_target: Hier erzwingen wir Head-Only, indem wir die Hitbox auf 0 setzen
--  (Manche Skeet-Versionen nutzen "ragebot_target" oder ähnliches)
client.set_event_callback("aim_target", function(e)
    -- Falls dein Cheat hier "e.hitboxes = {0}" verlangt, ändere es entsprechend
    e.hitbox = 0  -- 0 = Kopf
end)

-------------------------------------------------------------------------------
--  SETUP_COMMAND: Winkel überschreiben (Resolver)
-------------------------------------------------------------------------------
client.set_event_callback("setup_command", function(cmd)
    if not ui.get(enable_resolver) then return end

    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    -- Gehe alle Gegner durch
    local enemies = entity.get_players(true)
    for i = 1, #enemies do
        local enemy = enemies[i]
        if not resolver_data[enemy] then
            resolver_data[enemy] = { misses = 0 }
        end
        local data = resolver_data[enemy]

        local new_yaw = calculate_real_yaw(enemy, data)
        entity.set_prop(enemy, "m_angEyeAngles[1]", new_yaw)

        -- optional: aktualisiere lby / last_eye_angle
        data.last_eye_angle = new_yaw
        data.last_lby = entity.get_prop(enemy, "m_flLowerBodyYawTarget") or 0
    end
end)

-------------------------------------------------------------------------------
--  PAINT: Anzeigen, ob Resolver aktiv ist + Miss-Counter
-------------------------------------------------------------------------------
client.set_event_callback("paint", function()
    if ui.get(enable_resolver) then
        renderer.rectangle(10, 10, 220, 60, 0, 0, 0, 150)
        renderer.text(20, 20, 255, 255, 255, 255, "", 0, "Math Resolver + Headshots: ON")

        renderer.text(20, 40, 255, 255, 255, 255, "", 0, "Total Misses: " .. total_misses)
    else
        renderer.rectangle(10, 10, 220, 40, 0, 0, 0, 150)
        renderer.text(20, 20, 255, 0, 0, 255, "", 0, "Math Resolver: OFF")
    end
end)

return resolver
