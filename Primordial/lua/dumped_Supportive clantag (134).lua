local ffi_set_clantag = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15"))
local function set_clantag(tag) ffi_set_clantag(tag, tag) end

--just drop your own in these tables and it will work :3
local neutral_table = {
    ":|",
    ":\\",
    ":/",
}

local happy_table = {
    ":D",
    ":)",
    ":3",
    ":P"
}

local wink_table = {
    ";D",
    ";)",
    ";3",
    ";P"
}

local enable_clantag = menu.add_checkbox("supportive clantag", "enable")
local neutral_selection = menu.add_selection("supportive clantag", "neutral", neutral_table)
local happy_selection = menu.add_selection("supportive clantag", "happy", happy_table)
local wink_selection = menu.add_selection("supportive clantag", "wink", wink_table)

local function get_correct_tag(mood)
    if mood == "neutral" then
        return neutral_selection:get_item_name(neutral_selection:get())
    elseif mood == "happy" then
        return happy_selection:get_item_name(happy_selection:get())
    elseif mood == "wink" then
        return wink_selection:get_item_name(wink_selection:get())
    end
end

local function on_supportive_rectangle(screen_pos, size, mood, phrase)
    local tag_set = false
    local correct_tag = get_correct_tag(mood)
    if enable_clantag:get() and tostring(player_resource.get_prop("m_szClan", entity_list.get_local_player():get_index())) ~= correct_tag then
        tag_set = true
        set_clantag(correct_tag)
        return false
    elseif tag_set then
        set_clantag("")
        tag_set = false
    end
end

callbacks.add(e_callbacks.SUPPORTIVE_RECTANGLE, on_supportive_rectangle)