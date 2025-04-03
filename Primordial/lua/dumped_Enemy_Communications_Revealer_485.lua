local replacements = {
    ["{white}"] = "\x01",
    ["{darkred}"] = "\x02",
    ["{team}"] = "\x03",
    ["{green}"] = "\x04",
    ["{lightgreen}"] = "\x05",
    ["{lime}"] = "\x06",
    ["{red}"] = "\x07",
    ["{grey}"] = "\x08",
    ["{yellow}"] = "\x09",
    ["{bluegrey}"] = "\x0A",
    ["{blue}"] = "\x0B",
    ["{darkblue}"] = "\x0C",
    ["{purple}"] = "\x0D",
    ["{violet}"] = "\x0E",
    ["{lightred}"] = "\x0F",
    ["{orange}"] = "\x10"
}

local function FindSig(mod, pat, type, offset, deref_count)
    local raw_match = memory.find_pattern(mod, pat) or error("signature not found", 2)
    local match = ffi.cast("uintptr_t", raw_match)

    if offset ~= nil and offset ~= 0 then
        match = match + offset
    end

    if deref_count ~= nil then
        for i = 1, deref_count do
            match = ffi.cast("uintptr_t*", match)[0]
            if match == nil then
                return error("signature not found", 2)
            end
        end
    end

    return ffi.cast(type, match)
end

local function tbl_concat_string(tbl, sep)
    local result = ""
    for i=1, #tbl do
        result = result .. tostring(tbl[i]) .. (i == #tbl and "" or sep)
    end
    return result
end

local FindHudElement = FindSig("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28", "void***(__thiscall*)(void*, const char*)")
local hud = FindSig("client.dll", "B9 ?? ?? ?? ?? 88 46 09", "void*", 1, 1)
local hud_chat = FindHudElement(hud, "CHudChat")
local class_ptr = ffi.cast("void***",hud_chat)
local ChatPrintf = ffi.cast("void(__cdecl*)(void*, int, int, const char*, ...)", memory.get_vfunc(tonumber(ffi.cast("unsigned long", class_ptr)), 27))

local function print_player(entindex, ...)
    local text = tbl_concat_string(entindex == 0 and {" ", ...} or {...}, "")

    for res, rep in pairs(replacements) do
        text = string.gsub(text, res, rep)
    end

    ChatPrintf(class_ptr, entindex, 0, text)
end

function chat_print(...)
    return print_player(0, ...)
end

local teamchat = menu.add_checkbox("A", "Team chat revealer", true)
local voterevealer = menu.add_checkbox("A", "Vote revealer", true)
local function on_event(event)
    if event.name == "player_say" and teamchat:get() then
        local entity = entity_list.get_player_from_userid(event.userid)

        if not entity:is_enemy() then return end

        local text = event.text
        local team_name = "(Spectator) "
        local team = entity:get_prop("m_iTeamNum")
        local color = "{white}"
        if team == 2 then team_name = "(Terrorist) "; color = "{yellow}" end
        if team == 3 then team_name = "(Counter-Terrorist) "; color = "{blue}" end
        local col = entity:get_prop("DT_CSPlayerResource", "m_iCompTeammateColor")
        local location = entity:get_prop("m_szLastPlaceName")
        local name = entity:get_name() .. " : "
        local state = entity:is_alive() and "" or "*DEATH* "
        if team_name == "(Spectator) " then state = "" end

        chat_print(color .. state .. team_name .. name .. "{white}" .. text)
    end

    if event.name == "vote_cast" and voterevealer:get() then
        local entity = entity_list.get_player_from_userid(event.userid)
        if entity == nil then return end
        local vote_type = "???"
        if event.vote_option == 0 then vote_type = "{lightgreen}Yes" elseif event.vote_option == 1 then vote_type = "{red}No" end
        local name = entity:get_name()
        local color = "{white}"
        local team_name = "(Spectator) "
        local team = entity:get_prop("m_iTeamNum")
        if team == 2 then team_name = "(Terrorist) "; color = "{yellow}" end
        if team == 3 then team_name = "(Counter-Terrorist) "; color = "{blue}" end

        chat_print(color .. team_name .. name .. "voted " .. vote_type)
    end
end
callbacks.add(e_callbacks.EVENT, on_event)

--("{white}white {darkred}darkred {team}team {green}green {lightgreen}lightgreen {lime}lime {red}red {grey}grey {yellow}yellow {bluegrey}bluegrey {blue}blue {darkblue}darkblue {purple}purple {violet}violet {lightred}lightred {orange}orange")