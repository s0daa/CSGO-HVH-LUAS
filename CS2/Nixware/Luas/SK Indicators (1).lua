local font = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 16, 12)
local whiteColor = color_t(1, 1, 1, 1)
local accent = color_t(0.8, 1, 0.2588235294117647, 1) 
local redAccent = color_t(1, 0, 0, 1) 
local m_sSanitizedPlayerName = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName")
local logs = {}
local frameCount = 0
local lastTime = os.clock()
local currentFPS = 0
local notificationDuration = 4
local fadeDuration = 1
local maxLogs = 10

local function GetHitgroupName(nHitgroup)
    if nHitgroup == 1 then
        return "head"
    elseif nHitgroup == 2 then
        return "chest"
    elseif nHitgroup == 0 then
        return "generic"
    elseif nHitgroup == 4 or nHitgroup == 5 then
        return "arms"
    elseif nHitgroup == 8 then
        return "neck"
    elseif nHitgroup == 6 or nHitgroup == 7 then
        return "legs"
    elseif nHitgroup == 3 then
        return "stomach"
    else
        return "unknown"
    end
end

local function fnOnPlayerHurt(event)
    local pLocalPawn = entitylist.get_local_player_pawn()
    local pAttackerPawn = event:get_pawn("attacker")

    if pAttackerPawn == pLocalPawn then
        local pTargetController = event:get_controller("userid")
        if not pTargetController then return end

        local szName = ffi.string(ffi.cast("char**", pTargetController[m_sSanitizedPlayerName])[0])

        local nHealth = event:get_int("health")
        local nDamage = event:get_int("dmg_health")
        local nHitgroup = event:get_int("hitgroup")
        local szHitgroup = GetHitgroupName(nHitgroup)
        local Text = string.format("Hit %s in the %s for %d damage (%d health remaining)", szName, szHitgroup, nDamage, nHealth)
        print(Text)
        if #logs < maxLogs then
            table.insert(logs, {text = Text, alpha = 1.0, startTime = os.clock(), isFading = false, isPlayerHit = false})
        end
    end

   
    if event:get_controller("userid") == entitylist.get_local_player_controller() then
        local pAttackerController = event:get_controller("attacker")
        if not pAttackerController then return end

        local szAttackerName = ffi.string(ffi.cast("char**", pAttackerController[m_sSanitizedPlayerName])[0])
        local nDamage = event:get_int("dmg_health")
        local nHitgroup = event:get_int("hitgroup")
        local szHitgroup = GetHitgroupName(nHitgroup)
        local Text = string.format("Harmed by %s in the %s for %d damage", szAttackerName, szHitgroup, nDamage)
        print(Text)
        if #logs < maxLogs then
            table.insert(logs, {text = Text, alpha = 1.0, startTime = os.clock(), isFading = false, isPlayerHit = true})
        end
    end
end

local function fnOnPaint()
    frameCount = frameCount + 1
    local currentTime = os.clock()
    if currentTime - lastTime >= 1 then
        currentFPS = frameCount
        lastTime = currentTime
        frameCount = 0
    end
    local screenWidth = 1920
    local screenHeight = 1080
    local fpsPos = vec2_t(screenWidth / 2, screenHeight - 20)
    render.text(string.format("FPS: %d", currentFPS), font, fpsPos - vec2_t(30, 0), whiteColor)
    local offset = 10

    for i = 1, #logs do
        local log = logs[i]

        if not log.isFading and currentTime - log.startTime > notificationDuration then
            log.isFading = true
            log.fadeStartTime = currentTime
        end
        if log.isFading then
            local fadeProgress = currentTime - log.fadeStartTime
            if fadeProgress < fadeDuration then
                log.alpha = 1 - (fadeProgress / fadeDuration)
            else
                log.alpha = 0
            end
        end
        if log.alpha > 0 then
            local logPos = vec2_t(10 - (1 - log.alpha) * 100, offset)

            if log.isPlayerHit then
               
                render.text("Harmed by", font, logPos, color_t(1, 0, 0, log.alpha))

                local namePos = logPos + vec2_t(render.calc_text_size("Harmed by ", font).x, 0)
                render.text(log.text:match("^Harmed by (.-) in"), font, namePos, color_t(1, 1, 1, log.alpha))

                local hitPos = namePos + vec2_t(render.calc_text_size(log.text:match("^Harmed by (.-) "), font).x, 0)
                render.text(" in the " .. log.text:match("in the (.-) for") .. " for " .. log.text:match("for (%d+) damage"), font, hitPos, color_t(1, 0, 0, log.alpha))

            else
               
                render.text("Hit", font, logPos, color_t(0.8, 1, 0.2588235294117647, log.alpha))

                local namePos = logPos + vec2_t(render.calc_text_size("Hit ", font).x, 0)
                render.text(log.text:match("^Hit (.-) in"), font, namePos, color_t(1, 1, 1, log.alpha))

                local hitPos = namePos + vec2_t(render.calc_text_size(log.text:match("^Hit (.-) "), font).x, 0)
                render.text(" in the " .. log.text:match(" in the (.-) for") .. " for " .. log.text:match("for (%d+) damage"), font, hitPos, color_t(0.8, 1, 0.2588235294117647, log.alpha))
            end

            offset = offset + 25
        end
    end
    for i = #logs, 1, -1 do
        if logs[i].alpha <= 0 then
            table.remove(logs, i)
        end
    end
end

register_callback("paint", fnOnPaint)
register_callback("player_hurt", fnOnPlayerHurt)
