---for any question pls contect BaKa
local ffi = require("ffi")
ffi.cdef[[
typedef void***(__thiscall* FindHudElement_t)(void*, const char*);
typedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...);
]]

local signature_gHud = "\xB9\xCC\xCC\xCC\xCC\x88\x46\x09"
local signature_FindElement = "\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28"

local match = client.find_signature("client_panorama.dll", signature_gHud) or error("sig1 not found")
local hud = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("hud is nil")

match = client.find_signature("client_panorama.dll", signature_FindElement) or error("FindHudElement not found")
local find_hud_element = ffi.cast("FindHudElement_t", match)
local hudchat = find_hud_element(hud, "CHudChat") or error("CHudChat not found")

local chudchat_vtbl = hudchat[0] or error("CHudChat instance vtable is nil")
local print_to_chat = ffi.cast("ChatPrintf_t", chudchat_vtbl[27])
local function print_chat(text)
	print_to_chat(hudchat, 0, 0, text)
end
local misses = ui.new_checkbox("Rage", "Other", "[Moon] Log misses")
local hits = ui.new_checkbox("Rage", "Other", "[Moon] Log hits")
local function on_aim_hit(e)
	if ui.get(hits) then

    local hitgroup_names = { "身体", "头", "胸", "肚子", "胳膊", "胳膊", "脚", "大腿", "脖子", "?", "Luna" }
        local group = hitgroup_names[e.hitgroup + 1] or "?"

        local target_name = entity.get_player_name(e.target)
       
		local entityHealth = entity.get_prop(e.target, "m_iHealth")
        print_chat(" \x01[\x03GameSense\x01] " .. "\x01命中\x04 " .. string.lower(target_name) .. "\x01 的 \x04" .. group .. "\x01 剩余HP: \x02" .. entityHealth .. "\x01 命中率: \x04" .. string.format("%d", e.hit_chance) .. "%")
        client.color_log(0,255,255,"[ Gamesense ]\0")
        client.color_log(255,255,255," 命中 \0")
        client.color_log(0,255,0,string.lower(target_name).."\0")
        client.color_log(255,255,255," 的 \0")
        client.color_log(0,255,0,group.."\0")
        client.color_log(255,255,255," 剩余HP：\0")
        client.color_log(255,0,0,entityHealth.."\0")
        client.color_log(255,255,255," 命中率：\0")
        client.color_log(0,255,0,e.hit_chance)
    end
end

local function on_aim_miss(e)
	if ui.get(misses) and e ~= nil then

    local hitgroup_names = { "身体", "头", "胸", "肚子", "胳膊", "胳膊", "脚", "大腿", "脖子", "?", "Luna" }
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local target_name = entity.get_player_name(e.target)
    local reason
	local entityHealth = entity.get_prop(e.target, "m_iHealth")
	if (entityHealth == nil) or (entityHealth <= 0) then
		client.log("The player was killed prior to your shot being able to land")
	return
	end

    if e.reason == "?" then
    reason = "解析错误"
    elseif e.reason == "spread" then
        reason = "回溯"
    elseif e.reason == "prediction error" then
        reason = "预判错误"
    elseif e.reason == "unregistered shot" then
        reason = "未注册"
    elseif e.reason == "death" then
        reason = "本地死亡"
    else
        reason = e.reason
    end
	
        print_chat("\x01[\x03GameSense\x01] " .. "\x01空了 \x02" .. string.lower(target_name) .. "\x01 的 " .. " \x02" .. group .. "\x01 原因： \x02" .. reason.."\x01 命中率: \x02" .. string.format("%d", e.hit_chance) .. "%")
        client.color_log(255,255,0,"[ Gamesense ]\0")
        client.color_log(255,255,255," 空了 \0")
        client.color_log(255,0,0,string.lower(target_name).."\0")
        client.color_log(255,255,255," 的 \0")
        client.color_log(255,0,0,group.."\0")
        client.color_log(255,255,255," 原因：\0")
        client.color_log(255,0,0,reason.."\0")
        client.color_log(255,255,255," 命中率：\0")
        client.color_log(255,0,0,e.hit_chance)
    end
end


client.set_event_callback('aim_hit', on_aim_hit)
client.set_event_callback('aim_miss', on_aim_miss)