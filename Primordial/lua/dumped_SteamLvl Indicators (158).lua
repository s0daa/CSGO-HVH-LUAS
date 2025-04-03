local httpFactory = require("http")

local http = httpFactory.new({
    task_interval = 0.3, -- polling intervals
    enable_debug = false, -- print http requests to the console
    timeout = 10 -- request expiration time
})

local playerLvlTbl = {
    --["steamid64"] = "status"
    -- status can be "requesting" for entities with steam levels that are still unknown,
    -- "private" for ones that can't be accessed,
    -- "w1160" where 1160 is the time you can request again (using     math.floor(global_vars.real_time())    ),
    -- or "l10" where 10 is the number
    -- or "bot" for bots

    ["0"] = "bot" -- bots return steamid64 "0"
}

local timeoutS = 8 -- timeout for waiting after rate limits, i find that 8 works well enough

local function on_esp(ctx)
    local time = math.floor(global_vars.real_time())
	local steamid3, steamid64 = ctx.player:get_steamids() -- steamid3 is unused
    local status = playerLvlTbl[steamid64]
    local statusType
    local targetTxt = "error"
    if type(status) == "nil" then
        playerLvlTbl[steamid64] = "requesting"
        http:get("https://www.steamcommunity.com/profiles/" .. steamid64, function(data)
            if data:success() then
                local level = 0
                local rawhtml = data.body
                local private = false
                local lvlBeginning, lvlBeginningStr, lvlEnding, lvlFinal
                if type(rawhtml) ~= nil then -- see if the response wasnt nil
                    lvlBeginning = string.find(rawhtml, "friendPlayerLevelNum\">") -- go through the string until the level is found and store which character ir begins at (including the keyword we are looking for)
                    if type(lvlBeginning) ~= "nil" then -- see if anything was found
                        lvlBeginningStr = rawhtml:sub(lvlBeginning) -- store everything from the level (still including the keyword)
                        lvlEnding = string.find(lvlBeginningStr, "<") -- wait until we find the closing tag and store where it is
                        lvlFinal = lvlBeginningStr:sub(23,lvlEnding-1) -- remove the first keyword, the closing tag, and everything after
                        if type(tonumber(lvlFinal)) ~= "nil" then -- see if we did everything right
                            level = lvlFinal
                        else
                            print("a bruh moment just happened: " .. lvlFinal) -- this shouldnt happen
                        end
                    else
                        private = true -- if the level wasn't found, then the profile is private
                    end
                else
                    print("a gigantic bruh moment just happened") -- this also shouldnt happen
                end
                if not private then
                    playerLvlTbl[steamid64] = "l" .. level -- store the level
                else
                    playerLvlTbl[steamid64] = "p" -- the profile is private
                end
            end
            if not data:success() then
                playerLvlTbl[steamid64] = "w" .. time + timeoutS -- we got rate limited, try again in x seconds
            end
        end)
    else
        statusType = status:sub(1, 1)
        if statusType == "r" then
            targetTxt = "Requesting..."
        end
        if statusType == "p" then
            targetTxt = "Private"
        end
        if statusType == "w" then
            targetTxt = "On Cooldown: " .. time - tonumber(status:sub(2))
            if time - tonumber(status:sub(2)) < 0 then
                http:get("https://www.steamcommunity.com/profiles/" .. steamid64, function(data) -- yes i know i pasted the code from above, i didnt feel like rewriting the whole thing to go in a function...
                    if data:success() then
                        local level = 0
                        local rawhtml = data.body
                        local lvlBeginning, lvlBeginningStr, lvlEnding, lvlFinal
                        if type(rawhtml) ~= nil then
                            lvlBeginning = string.find(rawhtml, "friendPlayerLevelNum\">")
                            lvlBeginningStr = rawhtml:sub(lvlBeginning)
                            lvlEnding = string.find(lvlBeginningStr, "<")
                            lvlFinal = lvlBeginningStr:sub(23,lvlEnding-1)
                            if type(tonumber(lvlFinal)) ~= "nil" then
                                level = lvlFinal
                            else
                                print("a bruh moment just happened: " .. lvlFinal)
                            end
                        else
                            print("a gigantic bruh moment just happened")
                        end
                        playerLvlTbl[steamid64] = "l" .. level
                    end
                    if not data:success() then
                        playerLvlTbl[steamid64] = "w" .. time + timeoutS
                    end
                end)
            end
        end
        if statusType == "b" then
            targetTxt = "Bot"
        end
        if statusType == "l" then
            targetTxt = tostring(status):sub(2)
        end
    end
	ctx:add_flag("Lvl: " .. targetTxt, color_t(255,255,255))
end

callbacks.add(e_callbacks.PLAYER_ESP, on_esp)