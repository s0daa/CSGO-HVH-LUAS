-- Snou Resolver Beta (Optimized Version)

local playerDataList = {}

local resolverEnabled = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Snou Resolver")
local clantagEnabled = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Snou Clantag")

local clantagState = false

function SetClantag(tag)
    if entity.get_local_player() then
        client.set_clan_tag(tag)
    end
end

function UpdateClantag()
    clantagState = ui.get(clantagEnabled)
    if clantagState then
        SetClantag("Snou Resolver")
    else
        SetClantag("")
    end
end

client.set_event_callback("paint", function()
    if clantagState and entity.get_local_player() then
        SetClantag("Snou Resolver")
    end
end)

ui.set_callback(clantagEnabled, UpdateClantag)

function NormalizeYaw(yaw)
    return ((yaw + 180) % 360 - 180)
end

function CalculateVelocity(entityID)
    local entityVelocity = entity.get_prop(entityID, "m_vecVelocity")
    if entityVelocity then
        return math.sqrt(entityVelocity[1]^2 + entityVelocity[2]^2)
    end
    return 0.0
end

function GetOptimalYaw(entityID, eyeAngles)
    local optimalYaw = eyeAngles.y
    local minDelta = math.huge

    for i = -60, 60, 15 do
        local testYaw = NormalizeYaw(eyeAngles.y + i)
        local delta = math.abs(testYaw - eyeAngles.y)
        if delta < minDelta then
            minDelta = delta
            optimalYaw = testYaw
        end
    end

    return optimalYaw
end

function DetectAntiAim(entityID, eyeAngles)
    if not ui.get(resolverEnabled) then return eyeAngles.y end
    
    for _, player in ipairs(playerDataList) do
        if player.entityID == entityID and #player.backtrackRecords >= 2 then
            local lastYaw = player.backtrackRecords[#player.backtrackRecords - 1] and player.backtrackRecords[#player.backtrackRecords - 1].y or eyeAngles.y
            local currentYaw = player.backtrackRecords[#player.backtrackRecords] and player.backtrackRecords[#player.backtrackRecords].y or eyeAngles.y
            local deltaYaw = NormalizeYaw(currentYaw - lastYaw)

            if math.abs(deltaYaw) > 35.0 then
                return NormalizeYaw(eyeAngles.y + (deltaYaw > 0 and -35 or 35))
            elseif math.abs(deltaYaw) < 5.0 then
                return GetOptimalYaw(entityID, eyeAngles)
            end
        end
    end
    return eyeAngles.y
end

function AdaptiveYaw(entityID, eyeAngles)
    if not ui.get(resolverEnabled) then return eyeAngles.y end
    
    for _, player in ipairs(playerDataList) do
        if player.entityID == entityID and #player.hitboxRecords > 0 then
            local lastHitbox = player.hitboxRecords[#player.hitboxRecords]
            local deltaYaw = NormalizeYaw(eyeAngles.y - lastHitbox.y)
            return NormalizeYaw(eyeAngles.y + (deltaYaw > 0 and -12 or 12))
        end
    end
    return eyeAngles.y
end

function FreestandYaw(entityID, eyeAngles)
    if not ui.get(resolverEnabled) then return 0.0 end

    local leftYaw = NormalizeYaw(eyeAngles.y - 90)
    local rightYaw = NormalizeYaw(eyeAngles.y + 90)

    local leftClear = RaycastClear(entityID, leftYaw)
    local rightClear = RaycastClear(entityID, rightYaw)

    if leftClear and not rightClear then return leftYaw
    elseif rightClear and not leftClear then return rightYaw
    end

    return 0.0
end

function RaycastClear(entityID, yaw)
    return math.random(0, 1) == 1
end

function ResolveYaw(player, eyeAngles)
    if not ui.get(resolverEnabled) then return end

    local resolvedYaw = AdaptiveYaw(player.entityID, eyeAngles)

    if resolvedYaw == eyeAngles.y then
        resolvedYaw = DetectAntiAim(player.entityID, eyeAngles)
        if resolvedYaw == eyeAngles.y then
            resolvedYaw = FreestandYaw(player.entityID, eyeAngles)
            if resolvedYaw == 0.0 then
                resolvedYaw = NormalizeYaw(eyeAngles.y + 180.0)
            end
        end
    end

    if CalculateVelocity(player.entityID) > 50.0 then
        resolvedYaw = resolvedYaw + (math.random(0, 1) == 0 and 25 or -25)
    end

    eyeAngles.y = resolvedYaw
end

function ResolverMain(entityID, simTime, eyeAngles, hitboxPos)
    if not ui.get(resolverEnabled) then return end
    
    if not entity.is_alive(entityID) then return end

    for _, player in ipairs(playerDataList) do
        if player.entityID == entityID then
            if math.abs(simTime - player.lastSimTime) > 0.5 then
                ResolveYaw(player, eyeAngles)
            else
                table.insert(player.backtrackRecords, eyeAngles)
            end
            table.insert(player.hitboxRecords, hitboxPos)
            if #player.hitboxRecords > 20 then
                table.remove(player.hitboxRecords, 1)
            end
            return
        end
    end

    table.insert(playerDataList, {
        entityID = entityID,
        lastEyeYaw = eyeAngles.y,
        lastSimTime = simTime,
        backtrackRecords = {eyeAngles},
        hitboxRecords = { hitboxPos },
        velocity = 0.0
    })
end
