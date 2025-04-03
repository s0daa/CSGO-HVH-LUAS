--> CHANGE ME
local notification_library_name = "notifications" -- ../scripts/include/(notification name)
local chat_library_name = "chat" -- ../scripts/include/(chat print name)

--> Libraries
local nstat, notifications = pcall(function () return require(notification_library_name) end)
local cstat, chat = pcall(function () return require(chat_library_name) end)

--> ffi funcs.
local set_clipboard = function (text) ffi.cast("void(__thiscall*)(void*, const char*, int)", memory.get_vfunc(memory.create_interface("vgui2.dll", "VGUI_System010"), 9))(ffi.cast("void*",0), text, #text) end

--> UI
local ui = {

    logsEnable = menu.add_checkbox("Global", "Enable", true),
    menu.add_text("Global", " "),
    menu.add_text("Global", "Logs"),
    menu.add_separator("Global"),
    logsAimbot = menu.add_multi_selection("Global", "aimbot", {"hurt", "fired", "spread", "resolver", "prediction", "unregister", "death", "occlusion", "extrapolation", "other"}),
    logsTo = menu.add_multi_selection("Global", "location", {"Event", "Notification", "Chat (local)", "Chat (all)"}),
    logsNotifyMiss = menu.add_text("Global", "Library ".. notification_library_name .. " is missing."),
    logsChatMiss = menu.add_text("Global", "Library '" .. chat_library_name .. "' is missing."),
    menu.add_text("Global", " "),
    menu.add_text("Global", "Settings"),
    menu.add_separator("Global"),
    logsTag = menu.add_checkbox("Global", "Add tag before message"),
    logsCopy = menu.add_checkbox("Global", "Auto copy last message"),
    logsNotifySpeed = menu.add_slider("Global", "Notification speed", 0, 10, 1, 0, "s"),
    logsChatColor = menu.add_selection("Global", "Chat color", {"Default", "white", "green", "red", "yellow", "blue", "purple", "lightred", "orange"}),

    menu.add_text("Changelog", "[26.4.2022]"),
    menu.add_text("Changelog", " - Added \"unregistered shot\" to \"aimbot\" logs"),
    menu.add_text("Changelog", " - Added tags before message"),
    menu.add_text("Changelog", " - Completely reworked messages"),
    menu.add_text("Changelog", " - Completely reworked miss log"),
    menu.add_text("Changelog", " - Changed menu little bit"),
    menu.add_text("Changelog", " - Changed \"Log\" selection (now \"aimbot\")"),
    menu.add_text("Changelog", " - \"Chat (all)\" now works for every message type"),
    menu.add_text("Changelog", " - \"death\" in selection is for local & target death"),
}

ui.logsNotifyMiss:set_visible(false)
ui.logsChatMiss:set_visible(false)

--> Func. for checking lists
function Set (list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

--> Variables
local data = {

    hitgroupName = {"Generic", "Head", "Chest", "Stomach", "Left arm", "Right arm", "Left leg", "Right leg", "Neck", "Gear"},
    missReason = Set {"spread", "spread (missed safe)", "resolver", "prediction error", "server rejection", "ping (local death)", "ping (target death)", "occlusion", "extrapolation"}
}

function aikoLogs_Init()

    if not nstat and string.find(notifications, "module '".. notification_library_name .. "' not found: unknown module, make sure the file is in primordial/scripts/include") then

        ui.logsTo:set_items({ui.logsTo:get_item_name(1), "Notifications - missing library", ui.logsTo:get_item_name(3), ui.logsTo:get_item_name(4)})
        ui.logsNotifyMiss:set_visible(true)
    end
        
    if not cstat and string.find(chat, "module '".. chat_library_name .. "' not found: unknown module, make sure the file is in primordial/scripts/include") then
        
        ui.logsTo:set_items({ui.logsTo:get_item_name(1), ui.logsTo:get_item_name(2), "Chat (local) - missing library", ui.logsTo:get_item_name(4)})
        ui.logsChatMiss:set_visible(true)
    end
end

--> Paint Callback
local function on_paint()

    if(ui.logsTo:get("Notification")) then ui.logsNotifySpeed:set_visible(true)
    else ui.logsNotifySpeed:set_visible(false)  end

    if(ui.logsTo:get("Chat (local)")) then ui.logsChatColor:set_visible(true)
    else ui.logsChatColor:set_visible(false) end

    if(ui.logsNotifySpeed:get() == 0) then ui.logsNotifySpeed:set(4) end 
    if(ui.logsChatColor:get() == 1) then ui.logsChatColor:set(8) end
end

function BuildMessage(bColored, sType, pNick, hGroup, hChance, aDamage, tBacktrack, isSafe, reason)

    local message = "error"
    local safechat, safe = isSafe
    local color = ui.logsChatColor:get_item_name(ui.logsChatColor:get())
    if(safechat) then safechat = " [{"..color.."}safe{white}]" safe = " [safe]" else safechat = "" safe = "" end

    local prefix = { chat = "", console = "" }
    local sufix = { chat = "", console = "" }

    if(ui.logsTag:get()) then
        if(sType == "Missed") then 
            prefix["chat"] = "* {"..color.."} Miss {white}[{"..color.."}".. reason .."{white}] "
            sufix["chat"] = " due to [{"..color.."}".. reason .. "{white}]"
            prefix["console"] = "Miss [".. reason .."] "
            sufix["console"] = " due to [".. reason .. "]"
        end

        if(sType == "Fired at") then 
            prefix["chat"] = "* {"..color.."} Fired {white}[{"..color.."}".. aDamage .."dmg{white}] "
            prefix["console"] = "Fired [".. aDamage .."dmg] "
        end

        if(sType == "Hit") then 
            prefix["chat"] = "* {"..color.."} Hurt {white}[{"..color.."}".. aDamage .."dmg{white}] "
            prefix["console"] = "Hurt [".. aDamage .."dmg] "
        end
    end

    if(bColored) then message = prefix["chat"] .. ">{"..color.."}> {white} ".. sType .." {"..color.."}" .. pNick .. "{white}'s {"..color.."}" .. hGroup .. " {white}[hc:{"..color.."}".. hChance .."{white}] [dmg:{"..color.."}" .. aDamage .. "{white}] [bt:{"..color.."}" .. tBacktrack .. "{white}]".. safechat .. sufix["chat"]
    else message = prefix["console"] .. ">> ".. sType .. " " .. pNick .. "'s " .. hGroup .. " [hc:".. hChance .."] [dmg:" .. aDamage .. "] [bt:" .. tBacktrack .. "]".. safe .. sufix["console"] end
    return message
end

function SendMessage(NotifyHead, Chat, Console)

    if(ui.logsTo:get("Event")) then client.log_screen(">> " .. Console) end
    if(ui.logsTo:get("Notification")) then notifications:add_notification(NotifyHead, Console, ui.logsNotifySpeed:get()) end
    if(ui.logsTo:get("Chat (local)")) then chat.print(Chat) end
    if(ui.logsTo:get("Chat (all)")) then engine.execute_cmd("say " .. Console) end
    if(ui.logsCopy:get()) then set_clipboard(Console) end
end

--> Aimbot Hit Callback
local function on_aimbot_hit(hit)

    if not ui.logsEnable:get() then return end
    if(ui.logsAimbot:get("hurt")) then

        local message = BuildMessage(false, "Hit", hit.player:get_name(), data.hitgroupName[hit.aim_hitgroup + 1], hit.aim_hitchance, hit.aim_damage, hit.backtrack_ticks, hit.safepoint, " ")
        local chatmsg = BuildMessage(true, "Hit", hit.player:get_name(), data.hitgroupName[hit.aim_hitgroup + 1], hit.aim_hitchance, hit.aim_damage, hit.backtrack_ticks, hit.safepoint, " ")
        SendMessage(">> Hit " .. hit.player:get_name() .. " in " .. data.hitgroupName[hit.aim_hitgroup + 1], chatmsg, message)
    end
end

--> Aimbot Shot Callback
local function on_aimbot_shoot(shot)
    if not ui.logsEnable:get() then return end
    if(ui.logsAimbot:get("fired")) then

        local message = BuildMessage(false, "Fired at", shot.player:get_name(), data.hitgroupName[shot.hitgroup + 1], shot.hitchance, shot.damage, shot.backtrack_ticks, shot.safepoint, " ")
        local chatmsg = BuildMessage(true, "Fired at", shot.player:get_name(), data.hitgroupName[shot.hitgroup + 1], shot.hitchance, shot.damage, shot.backtrack_ticks, shot.safepoint, " ")
        SendMessage(">> Fired at " .. shot.player:get_name() .. "'s " .. data.hitgroupName[shot.hitgroup + 1], chatmsg, message)
    end
end

--> Aimbot Miss Callback
local function on_aimbot_miss(miss)

    if not ui.logsEnable:get() then return end

    local reason = miss.reason_string
    if(reason == "spread (missed safe)") then reason = "spread" end
    if(reason == "prediction error") then reason = "prediction" end
    if(reason == "server rejection") then reason = "unregistered shot" end
    if(reason == "ping (local death)") then reason = "death" end
    if(reason == "ping (target death)") then reason = "target death" end

    local message = BuildMessage(false, "Missed", miss.player:get_name(), data.hitgroupName[miss.aim_hitgroup + 1], miss.aim_hitchance, miss.aim_damage, miss.backtrack_ticks, miss.aim_safepoint, reason)
    local chatmsg = BuildMessage(true, "Missed", miss.player:get_name(), data.hitgroupName[miss.aim_hitgroup + 1], miss.aim_hitchance, miss.aim_damage, miss.backtrack_ticks, miss.aim_safepoint, reason)
    
    if(ui.logsAimbot:get("spread") and miss.reason_string == "spread" or 
       ui.logsAimbot:get("spread") and miss.reason_string == "spread (missed safe)" or
       ui.logsAimbot:get("resolver") and miss.reason_string == "resolver" or
       ui.logsAimbot:get("prediction") and miss.reason_string == "prediction error" or
       ui.logsAimbot:get("unregister") and miss.reason_string == "server rejection" or
       ui.logsAimbot:get("death") and miss.reason_string == "ping (local death)" or 
       ui.logsAimbot:get("death") and miss.reason_string == "ping (target death)" or
       ui.logsAimbot:get("occlusion") and miss.reason_string == "occlusion" or
       ui.logsAimbot:get("extrapolation") and miss.reason_string == "extrapolation" or
       ui.logsAimbot:get("other") and not data.missReason[miss.reason_string]) then 

        SendMessage(">> Missed shot due to " .. reason, chatmsg, message)
    end
end

--> Functions for callbacks
callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.AIMBOT_HIT, on_aimbot_hit)
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)
callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)

aikoLogs_Init()