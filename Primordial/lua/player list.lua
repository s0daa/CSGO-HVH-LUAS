local p_list_menu = menu.add_list("player list", "  ", {}, 20)
local p_list_friendly = menu.add_checkbox("player options", "friendly", false)
local p_list_safepoint = menu.add_checkbox("player options", "force safepoint", false)
local p_list_priority_enable = menu.add_checkbox("player options", "priority", false)
local p_list_priority_level = menu.add_slider("player options", "priority level", 0, 100, 1, 0.1)
local p_list_override_mindmg = menu.add_checkbox("player options", "override min damage")
local p_list_mindmg = menu.add_slider("player options", "min damage", 0, 101, 1)
local p_list_override_hitchance = menu.add_checkbox("player options", "override hitchance")
local p_list_hitchance = menu.add_slider("player options", "hitchance", 0, 100, 1, "%")
local p_list_override_damage_accuracy = menu.add_checkbox("player options", "override damage accuracy")
local p_list_damage_accuracy = menu.add_slider("player options", "damage accuracy", 0, 100, 1, "%")
local p_list_hitboxes_enable = menu.add_checkbox("player options", "force hitboxes")
local p_list_hitboxes_list = menu.add_multi_selection("player options", "hitboxes", {"head", "chest", "arms", "stomach", "legs", "feet"})
local p_list_multipoint_list = menu.add_multi_selection("player options", "multipoint", {"head", "chest", "arms", "stomach", "legs", "feet"})



--set sliders to be hidden unless used
callbacks.add(e_callbacks.PAINT, function()
    p_list_priority_level:set_visible(p_list_priority_enable:get())

    p_list_mindmg:set_visible(p_list_override_mindmg:get())

    p_list_hitchance:set_visible(p_list_override_hitchance:get())

    p_list_damage_accuracy:set_visible(p_list_override_damage_accuracy:get())

    p_list_hitboxes_list:set_visible(p_list_hitboxes_enable:get())
    p_list_multipoint_list:set_visible(p_list_hitboxes_enable:get())
end)

local convar_t = ffi.typeof([[
    struct {
        int pad1; //0x0000
        void* pNext; //0x0004 
        __int32 bRegistered; //0x0008 
        const char* pszName; //0x000C 
        const char* pszHelpString; //0x0010 
        int32_t nFlags; //0x0014 
        int pad2; //0x0018
        void* pParent; //0x001C 
        char* pszDefaultValue; //0x0020 
        char* strString; //0x0024 
        __int32 StringLength; //0x0028 
        float fValue; //0x002C 
        int32_t nValue; //0x0030 
        __int32 bHasMin; //0x0034 
        float fMinVal; //0x0038 
        __int32 bHasMax; //0x003C 
        float fMaxVal; //0x0040 
        void* fnChangeCallback; //0x0044 
        int pad3;
        int pad4;
        int iCallbackSize; //0x0050
    }]])

local cvar_interface = memory.create_interface("vstdlib.dll", "VEngineCvar007")
local cvar_interface_ptr = ffi.cast("void***",cvar_interface)
local find_cvar_vfunc = memory.get_vfunc(tonumber(ffi.cast("unsigned long", cvar_interface_ptr)), 15)
local find_cvar = ffi.cast(ffi.typeof("$*(__thiscall*)(void*,char*)", convar_t ), find_cvar_vfunc)
local name_cvar_struct = ffi.new(ffi.typeof("$[1]",convar_t))
local c_str = ffi.new("char[?]", #"name" + 1)
ffi.copy(c_str, "name")


local engine_client_interface = memory.create_interface("engine.dll","VEngineClient014")
local engine_client_ptr = ffi.cast("void***",engine_client_interface)
local get_player_from_id_vfunc = memory.get_vfunc(tonumber(ffi.cast("unsigned long",engine_client_ptr)),9)
local get_player_from_id = ffi.cast(ffi.typeof("int(__thiscall*)(void*,int)"),get_player_from_id_vfunc)

local p_selected = 0
local p_count = 0
local p_list = {}
local list_to_player = {}
local original_name = cvars.name:get_string()
local p_list_clansteal_index = 0
local p_list_clansteal_enabled = false

local function set_name(name)
    local name_cvar_struct = ffi.new(ffi.typeof("$[1]",convar_t))
    local c_str = ffi.new("char[?]", #"name" + 1)
    ffi.copy(c_str, "name")
    local name_cvar = find_cvar(cvar_interface_ptr, c_str)
    name_cvar[0].iCallbackSize = 0
    cvars.name:set_string(name)
end

local function silent_name(event)

    --[[
    if event.name == "server_spawn" then
        set_name("\n\xAD\xAD\xAD\xAD")
        local function delayed_set()
            set_name(original_name)
        end
        client.delay_call(delayed_set, 0.2)
    end]]
end

callbacks.add(e_callbacks.EVENT, silent_name)

local function kick_selected()
    --set_name("\n\xAD\xAD\xAD\xAD")
    --local function delayed_reset()
    --   set_name(original_name)
    --end
    --local function delayed_vote()
    --    engine.execute_cmd("callvote kick " .. tostring(p_list[list_to_player[p_list_menu:get()]].user_id))
    --    client.delay_call(delayed_reset, 0.2)
    --end
    --local function delayed_set()
    --    set_name(tostring(p_list[list_to_player[p_list_menu:get()]].name))
    --    client.delay_call(delayed_vote, 0.2)
    --end
    --client.delay_call(delayed_set, 0.2)]]


    --nested delays broken atm

    engine.execute_cmd("callvote kick " .. tostring(p_list[list_to_player[p_list_menu:get()]].user_id))

end

local ffi_set_clantag = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15"))
local function set_clantag(tag) 
    local c_str = ffi.new("char[?]", #tag + 1)
    ffi.copy(c_str, tag)
    ffi_set_clantag(c_str, c_str) 
end

local p_list_clansteal = menu.add_button("player functions", "steal selected clantag", function() 
    p_list_clansteal_index = list_to_player[p_list_menu:get()]
    p_list_clansteal_enabled = true
end)

local p_list_clansteal_disable = menu.add_button("player functions", "disable clantag stealer", function ()
    p_list_clansteal_enabled = false
    set_clantag("")
end)

local function steal_clantag()
    if p_list_clansteal_enabled and tostring(player_resource.get_prop("m_szClan", entity_list.get_local_player():get_index() )) ~= tostring(player_resource.get_prop("m_szClan", p_list_clansteal_index ))then
        set_clantag(tostring(player_resource.get_prop("m_szClan", p_list_clansteal_index)))
    end
end

callbacks.add(e_callbacks.NET_UPDATE, steal_clantag)

local p_list_kick = menu.add_button("player functions", "vote kick selected", kick_selected)

local p_list_namesteal = menu.add_button("player functions", "steal selected name", function () 
    set_name("\n\xAD\xAD\xAD\xAD")
    local function delayed_set()
        set_name(tostring(p_list[list_to_player[p_list_menu:get()]].name) .. "\n")
    end
    client.delay_call(delayed_set, 0.2)
end)

local p_list_name_box = menu.add_text_input("local functions", "name")
local p_list_name_set_button = menu.add_button("local functions", "set name", function ()
    set_name("\n\xAD\xAD\xAD\xAD")
    local function delayed_set()
        set_name(p_list_name_box:get())
    end
    client.delay_call(delayed_set, 0.2)
end)

local p_list_blankname = menu.add_button("local functions", "blank name", function () 
    set_name("\n\xAD\xAD\xAD\xAD")
    local function delayed_set()
        set_name("𝅷؜")
    end
    client.delay_call(delayed_set, 0.2)
end)

local p_list_blankname = menu.add_button("local functions", "newline name", function () 
    set_name("\n\xAD\xAD\xAD\xAD")
    local function delayed_set()
        set_name("")
    end
    client.delay_call(delayed_set, 0.2)
end)


local p_list_reset_name = menu.add_button("local functions", "reset name", function ()
    set_name(original_name)
end)

local p_list_clantag_box = menu.add_text_input("local functions", "clantag")
local p_list_clantag_set_button = menu.add_button("local functions", "set clantag", function ()
    set_clantag(p_list_clantag_box:get())
end)
local p_list_invert_clantag = menu.add_button("local functions", "set inverted clantag*", function ()
    set_clantag("‮" .. string.reverse(p_list_clantag_box:get()))
end)
local p_list_clear_clantag = menu.add_button("local functions", "clear clantag", function ()
    p_list_clansteal_enabled = false
    set_clantag("")
end)

local p_list_imitate_target = menu.add_checkbox("local functions", "set clan to aim target", false)

menu.add_text("local functions", "*bypasses text filtering")

local function p_list_callback(event)

    if not engine.is_in_game() then return end
    if event.name ~= "player_spawned" and event.name ~= "round_start" and event.name ~= "fuck_you" then return end
    local index = 1
    local user_id = 0
    local user_id_table = {}
    local i = 0
    while i < 1000 do
        user_id_table[get_player_from_id( engine_client_ptr, i)] = i
        i = i + 1
    end
    local names = {}
    for _, player in pairs(entity_list.get_players()) do
        local friendly = false
        local safepoint = false
        local priority_level = 0
        local priority_enabled = false
        local override_mindmg = false
        local mindmg = 0
        local override_hitchance = false
        local hitchance = 0
        local override_damage_accuracy = false
        local damage_accuracy = 0
        local force_hitboxes = false
        local force_head = false
        local force_chest = false
        local force_arms = false
        local force_stomach = false
        local force_legs = false
        local force_feet = false
        local multipoint_head = false
        local multipoint_chest = false
        local multipoint_arms = false
        local multipoint_stomach = false
        local multipoint_legs = false
        local multipoint_feet = false
        if p_list[player:get_index()] and p_list[player:get_index()].index == player:get_index() then
            friendly = p_list[player:get_index()].friendly
            safepoint = p_list[player:get_index()].safepoint
            priority_level = p_list[player:get_index()].priority_level
            priority_enabled = p_list[player:get_index()].priority_enabled
            override_mindmg = p_list[player:get_index()].override_mindmg
            mindmg = p_list[player:get_index()].mindmg
            override_hitchance = p_list[player:get_index()].override_hitchance
            hitchance = p_list[player:get_index()].hitchance
            override_damage_accuracy = p_list[player:get_index()].override_damage_accuracy
            damage_accuracy = p_list[player:get_index()].damage_accuracy
            force_hitboxes = p_list[player:get_index()].force_hitboxes
            force_head = p_list[player:get_index()].force_head
            force_chest = p_list[player:get_index()].force_chest
            force_arms = p_list[player:get_index()].force_arms
            force_stomach = p_list[player:get_index()].force_stomach
            force_legs = p_list[player:get_index()].force_legs
            force_feet = p_list[player:get_index()].force_feet
            multipoint_head = p_list[player:get_index()].multipoint_head
            multipoint_chest = p_list[player:get_index()].multipoint_chest
            multipoint_arms = p_list[player:get_index()].multipoint_arms
            multipoint_stomach = p_list[player:get_index()].multipoint_stomach
            multipoint_legs = p_list[player:get_index()].multipoint_legs
            multipoint_feet = p_list[player:get_index()].multipoint_feet
            if p_selected ~= p_list_menu:get() then
                p_list_friendly:set(p_list[list_to_player[p_list_menu:get()]].friendly)
                p_list_safepoint:set(p_list[list_to_player[p_list_menu:get()]].safepoint)
                p_list_priority_level:set(p_list[list_to_player[p_list_menu:get()]].priority_level)
                p_list_priority_enable:set(p_list[list_to_player[p_list_menu:get()]].priority_enabled)
                p_list_override_mindmg:set(p_list[list_to_player[p_list_menu:get()]].override_mindmg)
                p_list_mindmg:set(p_list[list_to_player[p_list_menu:get()]].mindmg)
                p_list_override_hitchance:set(p_list[list_to_player[p_list_menu:get()]].override_hitchance)
                p_list_hitchance:set(p_list[list_to_player[p_list_menu:get()]].hitchance)
                p_list_override_damage_accuracy:set(p_list[list_to_player[p_list_menu:get()]].override_damage_accuracy)
                p_list_damage_accuracy:set(p_list[list_to_player[p_list_menu:get()]].damage_accuracy)
                p_list_hitboxes_enable:set(p_list[list_to_player[p_list_menu:get()]].force_hitboxes)
                p_list_hitboxes_list:set("head", p_list[list_to_player[p_list_menu:get()]].force_head)
                p_list_hitboxes_list:set("chest", p_list[list_to_player[p_list_menu:get()]].force_chest)
                p_list_hitboxes_list:set("arms", p_list[list_to_player[p_list_menu:get()]].force_arms)
                p_list_hitboxes_list:set("stomach", p_list[list_to_player[p_list_menu:get()]].force_stomach)
                p_list_hitboxes_list:set("legs", p_list[list_to_player[p_list_menu:get()]].force_legs)
                p_list_hitboxes_list:set("feet", p_list[list_to_player[p_list_menu:get()]].force_feet)
                p_list_multipoint_list:set("head", p_list[list_to_player[p_list_menu:get()]].multipoint_head)
                p_list_multipoint_list:set("chest", p_list[list_to_player[p_list_menu:get()]].multipoint_chest)
                p_list_multipoint_list:set("arms", p_list[list_to_player[p_list_menu:get()]].multipoint_arms)
                p_list_multipoint_list:set("stomach", p_list[list_to_player[p_list_menu:get()]].multipoint_stomach)
                p_list_multipoint_list:set("legs", p_list[list_to_player[p_list_menu:get()]].multipoint_legs)
                p_list_multipoint_list:set("feet", p_list[list_to_player[p_list_menu:get()]].multipoint_feet)
            end
        end
        local p_list_item = {
            name = tostring(player:get_name()),
            index = player:get_index(),
            user_id = user_id_table[player:get_index()],
            bot = player:has_player_flag(e_player_flags.FAKE_CLIENT),
            friendly = friendly,
            safepoint = safepoint,
            priority_level = priority_level,
            priority_enabled = priority_enabled,
            override_mindmg = override_mindmg,
            mindmg = mindmg,
            override_hitchance = override_hitchance,
            hitchance = hitchance,
            override_damage_accuracy = override_damage_accuracy,
            damage_accuracy = damage_accuracy,
            force_hitboxes = force_hitboxes,
            force_head = force_head,
            force_chest = force_chest,
            force_arms = force_arms,
            force_stomach = force_stomach,
            force_legs = force_legs,
            force_feet = force_feet,
            multipoint_head = multipoint_head,
            multipoint_chest = multipoint_chest,
            multipoint_arms = multipoint_arms,
            multipoint_stomach = multipoint_stomach,
            multipoint_legs = multipoint_legs,
            multipoint_feet = multipoint_feet
        }
        p_list[player:get_index()] = p_list_item
        if player:has_player_flag(e_player_flags.FAKE_CLIENT) then
            names[index] = "BOT " .. p_list_item.name
        elseif player:get_name() == "GOTV" then
            names[index] = ""
        else
            names[index] = p_list_item.name
        end
        list_to_player[index] = player:get_index()
        index = index + 1
    end

    --p_list_kick:set_visible(not p_list[list_to_player[p_list_menu:get()]].bot and p_list[list_to_player[p_list_menu:get()]].name ~= "GOTV" and not entity_list.get_players()[list_to_player[p_list_menu:get()]]:is_enemy()  )

    p_list[list_to_player[p_list_menu:get()]].friendly = p_list_friendly:get()
    p_list[list_to_player[p_list_menu:get()]].safepoint = p_list_safepoint:get()
    p_list[list_to_player[p_list_menu:get()]].priority_level = p_list_priority_level:get()
    p_list[list_to_player[p_list_menu:get()]].priority_enabled = p_list_priority_enable:get()
    p_list[list_to_player[p_list_menu:get()]].override_mindmg = p_list_override_mindmg:get()
    p_list[list_to_player[p_list_menu:get()]].mindmg = p_list_mindmg:get()
    p_list[list_to_player[p_list_menu:get()]].override_hitchance = p_list_override_hitchance:get()
    p_list[list_to_player[p_list_menu:get()]].hitchance = p_list_hitchance:get()
    p_list[list_to_player[p_list_menu:get()]].override_damage_accuracy = p_list_override_damage_accuracy:get()
    p_list[list_to_player[p_list_menu:get()]].damage_accuracy = p_list_damage_accuracy:get()
    p_list[list_to_player[p_list_menu:get()]].force_hitboxes = p_list_hitboxes_enable:get()
    p_list[list_to_player[p_list_menu:get()]].force_head = p_list_hitboxes_list:get("head")
    p_list[list_to_player[p_list_menu:get()]].force_chest = p_list_hitboxes_list:get("chest")
    p_list[list_to_player[p_list_menu:get()]].force_arms = p_list_hitboxes_list:get("arms")
    p_list[list_to_player[p_list_menu:get()]].force_stomach = p_list_hitboxes_list:get("stomach")
    p_list[list_to_player[p_list_menu:get()]].force_legs = p_list_hitboxes_list:get("legs")
    p_list[list_to_player[p_list_menu:get()]].force_feet = p_list_hitboxes_list:get("feet")
    p_list[list_to_player[p_list_menu:get()]].multipoint_head = p_list_multipoint_list:get("head")
    p_list[list_to_player[p_list_menu:get()]].multipoint_chest = p_list_multipoint_list:get("chest")
    p_list[list_to_player[p_list_menu:get()]].multipoint_arms = p_list_multipoint_list:get("arms")
    p_list[list_to_player[p_list_menu:get()]].multipoint_stomach = p_list_multipoint_list:get("stomach")
    p_list[list_to_player[p_list_menu:get()]].multipoint_legs = p_list_multipoint_list:get("legs")
    p_list[list_to_player[p_list_menu:get()]].multipoint_feet = p_list_multipoint_list:get("feet")
    p_selected = p_list_menu:get()
    p_list_menu:set_items(names)
end

local p_list_refresh = menu.add_button("player list", "refresh list", function ()
     p_list_callback({name = "fuck_you"})
end)

p_list_callback({name = "fuck_you"})

local function apply_p(ctx, cmd, unpredicted_data)
    for _, player in pairs(p_list) do
        if player.friendly then 
            ctx:ignore_target(player.index)
        end

        if player.priority_enabled then
            ctx:prioritize_target(player.index, player.priority_level)
        end
    end


end

local current_tag = ""

local function on_hitscan(ctx, cmd, unpredicted_data)
    local player_settings = p_list[ctx.player:get_index()]
    if p_list_imitate_target:get() then
        p_list_clansteal_enabled = false
        if ctx.player:has_player_flag(e_player_flags.FAKE_CLIENT) and current_tag ~= "BOT " .. ctx.player:get_name() then
            set_clantag("BOT " .. ctx.player:get_name())
            current_tag = "BOT " .. ctx.player:get_name()
        elseif current_tag ~= ctx.player:get_name() then
            set_clantag(tostring(player_resource.get_prop("m_szClan", ctx.player:get_index())) .. " " .. ctx.player:get_name())
            current_tag = ctx.player:get_name()
        end
    end

    if player_settings.override_mindmg then
        ctx:set_min_dmg(player_settings.mindmg)
    end

    if player_settings.safepoint then
        ctx:set_safepoint_state(true)
    end

    if player_settings.override_hitchance then
        ctx:set_hitchance(player_settings.hitchance)
    end

    if player_settings.override_damage_accuracy then
        ctx:set_damage_accuracy(player_settings.damage_accuracy)
    end

    if player_settings.force_hitboxes then
        ctx:set_hitscan_group_state(e_hitscan_groups.HEAD, player_settings.force_head, player_settings.multipoint_head)
        ctx:set_hitscan_group_state(e_hitscan_groups.CHEST, player_settings.force_chest, player_settings.multipoint_chest)
        ctx:set_hitscan_group_state(e_hitscan_groups.ARMS, player_settings.force_arms, player_settings.multipoint_arms)
        ctx:set_hitscan_group_state(e_hitscan_groups.STOMACH, player_settings.force_stomach, player_settings.multipoint_stomach)
        ctx:set_hitscan_group_state(e_hitscan_groups.LEGS, player_settings.force_legs, player_settings.multipoint_legs)
        ctx:set_hitscan_group_state(e_hitscan_groups.FEET, player_settings.force_feet, player_settings.multipoint_feet)
    end

end

callbacks.add(e_callbacks.HITSCAN, on_hitscan)

callbacks.add(e_callbacks.TARGET_SELECTION, apply_p)

callbacks.add(e_callbacks.EVENT, p_list_callback)