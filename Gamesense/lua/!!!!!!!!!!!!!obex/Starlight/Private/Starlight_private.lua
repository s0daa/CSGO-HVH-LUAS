-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- |======================== Developer: mr.alyn ========================| --





--[[
    |==================================================================|
    |                                                                  |
    |============================ DATABASE ============================|
    |                                                                  |
    |==================================================================|
--]]

local obex_data = obex_fetch and obex_fetch() or {
    username = "alyn";
    build = "private";
    discord = "";
}

local lua_name = "starlight";
local username = obex_data.username;
local build = string.lower(obex_data.build);
local version = "0.2";

--[[
    |==================================================================|
    |                                                                  |
    |============================== FUNCS =============================|
    |                                                                  |
    |==================================================================|
--]]

local color_print = function(...)
    for i, data in ipairs({...}) do
        local r, g, b, text = 255, 255, 255, data
        if type(data) == "table" then r, g, b, text = unpack(data) end
        text = text or "text is nil"
        client.color_log(r, g, b, i == #{...} and text or (text .. "\0"))
    end
end

local check_libraries = function()
    color_print({255, 255, 255, "["}, {149, 162, 255, lua_name }, {255, 255, 255, "]"}, " Checking libraries...")

    local libs = {
        ["gamesense/http"] = "https://gamesense.pub/forums/viewtopic.php?id=19253";
        ["gamesense/base64"] = "https://gamesense.pub/forums/viewtopic.php?id=21619";
        ["gamesense/images"] = "https://gamesense.pub/forums/viewtopic.php?id=22917";
        ["gamesense/entity"] = "https://gamesense.pub/forums/viewtopic.php?id=27529";
        ["gamesense/clipboard"] = "https://gamesense.pub/forums/viewtopic.php?id=28678";
    };

    for i, v in pairs(libs) do
        if not pcall(require, i) then
            error("You aren't subscribed to library: " .. i .. " link: " .. v)
        else
            local str = string.format(" Library: %s is ok", i)
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name }, {255, 255, 255, "]"}, str)
        end
    end
end

local rgba_to_hex = function(r, g, b, a)
    return string.format("%02x%02x%02x%02x", r, g, b, a)
end

local hex_color_to_rgba = function(hex)
    hex = hex:gsub("\a", "")
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    local a = tonumber(hex:sub(7, 8), 16)
    return { r, g, b, a }
end

local fade_text = function(speed, rgba, text)
    local final_text = ""
    local curtime = globals.curtime()
    local r, g, b, a = unpack(rgba)

    for i = 1, #text do
        local color = rgba_to_hex(r, g, b, a * math.abs(1 * math.cos(2 * speed * curtime / 4 + i * 5 / 30)))
        final_text = final_text .. "\a" .. color .. text:sub(i, i)
    end

    return final_text
end

local clamp = function(x) 
    if x == nil then 
        return 0 
    end 
    x = (x % 360 + 360) % 360 
    return x > 180 and x - 360 or x 
end;

local string_to_sub = function(input, sep)
    local t = {}
    for str in string.gmatch(input, "([^"..sep.."]+)") do
        t[#t + 1] = string.gsub(str, "\n", "")
    end
    return t
end

local array_to_string = function(arr)
    arr = ui.get(arr)
    local str = ""
    for i=1, #arr do
        str = str .. arr[i] .. (i == #arr and "" or ",")
    end

    if str == "" then
        str = "-"
    end

    return str
end

local lerp = function(start, vend, time)
    return start + (vend - start) * time
end

local table_size = function(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

local table_contains = function(source, target)
    local source_element = ui.get(source)
    for id, name in pairs(source_element) do
        if name == target then
            return true
        end
    end

    return false
end

--[[
    |==================================================================|
    |                                                                  |
    |============================== REFS ==============================|
    |                                                                  |
    |==================================================================|
--]]

local library = {
    ["http"] = require("gamesense/http");
    ["base64"] = require("gamesense/base64");
    ["images"] = require("gamesense/images");
    ["entity"] = require("gamesense/entity");
    ["clipboard"] = require("gamesense/clipboard");
    ["vector"] = require("vector");
    ["bit"] = require("bit");
}

local cache = {
    skeet_menu = {
        anti_aim = {
            enable = ui.reference("AA", "Anti-aimbot angles", "Enabled");
            yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base");
            pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")};
            yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")};
            yaw_jitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw Jitter")};
            body_yaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")};
            freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw");
            edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw");
            freestanding = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")};
            roll = ui.reference("AA", "Anti-aimbot angles", "Roll");
        };
        other = {
            double_tap = {ui.reference("Rage", "Aimbot", "Double tap")};
            hide_shots = {ui.reference("AA", "Other", "On shot anti-aim")};
            fakeducking = ui.reference("Rage", "Other", "Duck peek assist");
            legs = ui.reference("AA", "Other", "Leg movement");
            slow_motion = {ui.reference("AA", "Other", "Slow motion")};
            bunny_hop = ui.reference("Misc", "Movement", "Bunny hop");
            auto_peek = {ui.reference("Rage", "other", "quick peek assist")};
            gs_clantag = ui.reference("Misc", "Miscellaneous", "Clan tag spammer");
            min_dmg = ui.reference("Rage", "Aimbot", "Minimum damage");
            min_dmg_override = {ui.reference("Rage", "Aimbot", "Minimum damage override")};
        };
    };

    menu = {
        selected_tab = 1;
        skeet_selected_tab = 0;
        hovered = false;
        size = { default = { w = 75, h = 64, }, w = 75, h = 64, x = 6, y = 20 };
        m1_down = false;
        bg_texture = renderer.load_rgba("\x14\x14\x14\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x14\x14\x14\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF", 4, 4);
        icons = {};
    };

    anti_aim = {
        builder_state = {
            "Global";
            "Standing";
            "Moving";
            "Slowmotion";
            "In Air";
            "In Air-Duck";
            "Duck-Moving";
            "Duck";
            "Fakelag";
            "Freestanding";
        };

        state_to_num = { 
            ["Global"] = 1; 
            ["Standing"] = 2; 
            ["Moving"] = 3; 
            ["Slowmotion"] = 4;
            ["In Air"] = 5;
            ["In Air-Duck"] = 6;
            ["Duck-Moving"] = 7;
            ["Duck"] = 8;
            ["Fakelag"] = 9;
            ["Freestanding"] = 10;
        };

        state_aa = "Standing";
        to_jitter = false;
        current_tickcount = 0;
        inverter = false;
        manual_input = 0;
        manual_aa = 0;
        ignore_aa_manual = false;
        ignore_aa_anti_knife = false;
        ignore_aa_safe_knife_taser = false;

        defensive = {
            defensive_cmd = 0;
            defensive_check = 0;
            defensive = 0;
        };

        pitch = 0;
        pitch_value = 0;

        yaw_base = 0;
        yaw = 0;
        yaw_value = 0;

        yaw_jitter = 0;
        yaw_jitter_value = 0;

        body_yaw = 0;
        body_yaw_value = 0;

        freestanding_body_yaw = 0;
        roll = 0;

        funcs = {
            old_weapon = 0;
            actual_weapon = 0;
            actual_tick = 0;
            can_defensive = false;
            to_start = false;
            old_def_state = "Standing";
            prev_simulation_time = 0;
            def_ticks = 0;
        };
    };

    visuals = {};
    misc = {};

    ui = {
        info = {};
        anti_aim = {
            elements = {};
        };
        misc = {};
        visuals = {};
        config = {};

        ui_color = "\a95A2FFFF"; -- rgb 149, 162, 255
        white_color = "\aFFFFFFFF";
    };

    animations = {
        is_on_ground = false;
        E_POSE_PARAMETERS = {
            STRAFE_YAW = 0,
            STAND = 1,
            LEAN_YAW = 2,
            SPEED = 3,
            LADDER_YAW = 4,
            LADDER_SPEED = 5,
            JUMP_FALL = 6,
            MOVE_YAW = 7,
            MOVE_BLEND_CROUCH = 8,
            MOVE_BLEND_WALK = 9,
            MOVE_BLEND_RUN = 10,
            BODY_YAW = 11,
            BODY_PITCH = 12,
            AIM_BLEND_STAND_IDLE = 13,
            AIM_BLEND_STAND_WALK = 14,
            AIM_BLEND_STAND_RUN = 14,
            AIM_BLEND_CROUCH_IDLE = 16,
            AIM_BLEND_CROUCH_WALK = 17,
            DEATH_YAW = 18
        };
    };

    config = {
        cfg_ui = {};
        presets = {};

        database = {
            configs = ":" .. lua_name .. "::configs:";
        };
    };

    clan_tag = {
        tags = {};
        prev = nil;

        initialize = function(self, tag)
            table.insert(self.tags, " ")

            local len = #tag
            for i = 1, len do
                table.insert(self.tags, string.sub(tag, 1, i))
            end

            for i = len - 1, 1, -1 do
                table.insert(self.tags, string.sub(tag, 1, i))
            end
        end
    };

    kill_say_messages = {
        "✧:･ﾟ✧ 𝔹𝕌𝕐 𝕄𝕐 ℂ𝕆ℕ𝔽𝕀𝔾 ✧:･ﾟ✧";
        "𝕒𝕕𝕕 𝕞𝕖 = 𝕓𝕝𝕠𝕔𝕜 ♕ ONLY ACCEPT LVL 200+";
        "never vac and you know";
        "𝕒𝕕𝕕𝕖𝕕 𝕓𝕖𝕔𝕦𝕒𝕤𝕖 𝕚 𝕨𝕒𝕟𝕥𝕖𝕕 𝕤𝕠𝕞𝕖 𝕥𝕠 𝕒𝕕𝕕 𝕝𝕖𝕧𝕖𝕝 𝕙𝕚𝕘𝕙 𝕝𝕖𝕧𝕖𝕝 𝕡𝕖𝕠𝕡𝕝𝕖𝕤 ♛ (◣◢) ♛";
        "𝓨𝓸𝓾𝓻 𝓹𝓻𝓸𝓯𝓲𝓵𝓮 𝓲𝓼 𝓫𝓮𝓲𝓷𝓰 𝓯𝓸𝓻𝓬𝓮𝓭 𝓹𝓻𝓲𝓿𝓪𝓽𝓮 𝓭𝓾𝓮 𝓽𝓸 𝓪𝓷 𝓪𝓬𝓽𝓲𝓿𝓮 𝓒𝓸𝓶𝓶𝓾𝓷𝓲𝓽𝔂 𝓑𝓪𝓷 𝓸𝓷 𝔂𝓸𝓾𝓻 𝓪𝓬𝓬𝓸𝓾𝓷𝓽.";
        "ＥＳＯＴＥＲＩＫ Ｉ ＷＩＬＬ ＳＥＥ ＹＯＵ ＩＮ ＨＥＬＬ (◣◢)";
        "how im can cheating? i is lvl 130 own all bronze medal? u is dumb dog)))";
        "dont wake the beast inside me, you dont want to see my 4.1 avg kd hunter";
        "𝕡𝕦𝕥𝕚𝕟 𝕙𝕚𝕣𝕖 𝕞𝕖 𝕗𝕠𝕣 𝕨𝕒𝕣, 𝕨𝕙𝕖𝕟 𝕟𝕒𝕥𝕠 𝕤𝕖𝕖𝕤 𝕞𝕪 𝕔𝕗𝕘, 𝕥𝕙𝕖𝕪 𝕒𝕣𝕖 𝕣𝕢𝕚𝕟𝕘.";
        "next time its win (◣◢)";
        "me try harding for nova 1 (◣◢)";
        "cooldowns are not on my side (◣◢)";
        "can't escape (◣◢)";
        "sorry i dont speak to nns im busy @ hvhacadamy majoring in 1 ways";
        "whats your networth? why dont you spend $2k on steam levels NN? xaxaxaxa";
        "yo this vaccine got me feelin kinda differen上帝保佑中国共产党、习近平和武汉P4病毒学实验室";
        "ɴᴏɴᴀᴍᴇ ʟɪꜱᴛᴇɴ ᴛᴏ ᴍᴇ ! ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ ɪꜱ ɴᴏᴛ ʏᴏᴜʀ ᴘʀᴏᴘᴇʀᴛʏ. ᴅᴏɴ'ᴛ ꜰᴏʟʟᴏᴡɪɴɢ ᴍᴇ ᴏɴ ᴍʏ ꜱᴄʀᴇᴇɴꜱʜᴏᴛꜱ ! ɪ ᴅᴏɴ'ᴛ ʟɪᴋᴇ ꜱᴘʏɪɴɢ..";
        "playing csgo takes me p a i n a w a y (◣◢)";
        "欢迎使用 Gboard 剪贴板，您复制的所有文本都会保存到这里。";
        "is your uid above 1k on? (◣◢)(◣◢)(◣◢)(◣◢)(◣◢)(◣◢)(◣◢) = blocked!!!";
        "𝕖𝕧𝕖𝕣𝕪 𝕥𝕚𝕞𝕖 𝕚𝕕𝕚𝕠𝕥 𝕒𝕤𝕜 𝕞𝕖, 𝕦𝕚𝕕? 𝕒𝕟𝕕 𝕚𝕞 𝕕𝕠𝕟𝕥 𝕒𝕟𝕤𝕨𝕖𝕣, 𝕚 𝕝𝕖𝕥 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖𝕓𝕠𝕒𝕣𝕕 𝕤𝕡𝕖𝕒𝕜♛";
        "no care (◣◢)";
        "u dont talk anyways";
        "go fix";
        "new main? can buy, hvh win? dont think im can (◣◢)";
        "low iq player dont big";
        "𝕓𝕚𝕘 𝕟𝕒𝕞𝕖𝕣, 𝕚𝕞 𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦 𝕕𝕣𝕠𝕡 𝕪𝕠𝕦𝕣 𝕔𝕣𝕠𝕨𝕟, 𝕤𝕠 𝕚𝕞 𝕨𝕖𝕟𝕥 𝕡𝕚𝕥𝕔𝕙𝕕𝕠𝕨𝕟 𝕚𝕟 𝕞𝕞 𝕒𝕟𝕕 𝕡𝕚𝕔𝕜 𝕚𝕥 𝕦𝕡 𝕗𝕠𝕣 𝕪𝕠𝕦, 𝕙𝕖𝕣𝕖 𝕪𝕠𝕦 𝕘𝕠 𝕜𝕚𝕟𝕘 ♕";
        "ᴀɢᴀɪɴ ɴᴏɴᴀᴍᴇ ᴏɴ ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ. ɪ ꜱᴇᴇ ᴀɢᴀɪɴ ᴀᴄᴛɪᴠɪᴛʏ.";
        "𝕨𝕖𝕝𝕔𝕠𝕞𝕖 𝕥𝕠 𝕔𝕝𝕒𝕤𝕤, 𝕦'𝕣𝕖 𝕣𝕖𝕒𝕕𝕪 𝕗𝕠𝕣 𝕝𝕖𝕤𝕤𝕠𝕟?";
        "dont think im can lose hvh to nn (◣◢)";
        "im donr cheat (◣◢)";
        "i dont antiaim i look coin on ground(◣◢)";
        "start destroy (◣◢)";
    };
}

cache.clan_tag:initialize(lua_name);

--[[
    |==================================================================|
    |                                                                  |
    |============================== MENU ==============================|
    |                                                                  |
    |==================================================================|
--]]

local set_element = function(types, element, value, type_of)
    if types == "vis" then
        for table, values in pairs(cache.skeet_menu.anti_aim) do
            if type(values) == "table" then
                for table_, values_ in pairs(values) do
                    if type_of == "load" then
                        ui.set_visible(values_, false)
                    else
                        ui.set_visible(values_, true)
                    end
                end
            else
                if type_of == "load" then
                    ui.set_visible(values, false)
                else
                    ui.set_visible(values, true)
                end
            end
        end
    elseif types == "vis_elem" then
        ui.set_visible(element, value)
    elseif types == "elem" then
        ui.set(element, value)
    end
end

local create_menu_elements = function()
    -- tab labels
    cache.ui.tab_label = ui.new_label("AA", "Anti-aimbot angles", " ");
    cache.ui.tab_label2 = ui.new_label("AA", "Anti-aimbot angles", " ");

    -- info tab
    cache.ui.info.welcome_label = ui.new_label("AA", "Anti-aimbot angles", "Welcome to " .. cache.ui.ui_color .. lua_name);
    cache.ui.info.user_label = ui.new_label("AA", "Anti-aimbot angles", cache.ui.ui_color .. "User: " .. cache.ui.white_color .. username);
    cache.ui.info.build_label = ui.new_label("AA", "Anti-aimbot angles", cache.ui.ui_color .. "Build: " .. cache.ui.white_color .. build);
    cache.ui.info.version_label = ui.new_label("AA", "Anti-aimbot angles", cache.ui.ui_color .. "Version: " .. cache.ui.white_color .. version);

    -- antiaim tab
    cache.ui.anti_aim.builder_state = ui.new_combobox("AA", "Anti-aimbot angles", "State:", cache.anti_aim.builder_state)

    for k in pairs(cache.anti_aim.builder_state) do
        cache.ui.anti_aim.elements[k] = {
            -- enable
            enable = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable: " .. cache.ui.ui_color .. cache.anti_aim.builder_state[k]);

            -- pitch
            pitch = ui.new_combobox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Pitch", {"Off", "Zero", "Up", "Down", "Minimal", "Custom"});
            pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nPitch" .. cache.anti_aim.builder_state[k], -89, 89, 0, true);

            -- yaw
            yaw_base = ui.new_combobox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Yaw Base", {"Local View", "At Targets"});
            yaw = ui.new_combobox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"});
            yaw_mode = ui.new_combobox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Yaw Mode", {"Static", "L & R", "Delayed", "Flick", "Random L & R"});
            yaw_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nYaw" , -180, 180, 0, true);
            yaw_left_slider = ui.new_slider("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Yaw Left", -180, 180, 0, true);
            yaw_right_slider = ui.new_slider("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Yaw Right", -180, 180, 0, true);
            yaw_delay_slider = ui.new_slider("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Yaw Delay", 2, 10, 0, true);

            -- yaw jitter
            yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Yaw Jitter", {"Off", "Offset", "Center", "Random", "Skitter"});
            yaw_jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Yaw Jitter Mode",  {"Static", "L & R", "Random L & R"});
            yaw_jitter_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nYaw Jitter" , -180, 180, 0, true);
            yaw_jitter_left_slider = ui.new_slider("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Yaw Jitter Left", -180, 180, 0, true);
            yaw_jitter_right_slider = ui.new_slider("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Yaw Jitter Right", -180, 180, 0, true);

            -- body yaw
            body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Body Yaw", {"Off", "Opposite", "Jitter", "Static"});
            body_yaw_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nBody Yaw" .. cache.anti_aim.builder_state[k], -180, 180, 0, true);
            body_yaw_sync = ui.new_checkbox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Sync Body Yaw");

            -- freestanding body yaw & roll
            freestanding_body_yaw = ui.new_checkbox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Freestanding Body Yaw");
            roll = ui.new_slider("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Roll", -45, 45, 0, true);

            -- defensive
            defensive = ui.new_checkbox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Defensive");
            defensive_force = ui.new_checkbox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Force Defensive");

            -- defensive pitch
            defensive_pitch = ui.new_combobox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Defensive Pitch", {"Off", "Zero", "Up", "Random", "Custom"});
            defensive_pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nDefensive Pitch" .. cache.anti_aim.builder_state[k], -89, 89, 0, true);

            -- defensive yaw
            defensive_yaw = ui.new_combobox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Defensive Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"});
            defensive_yaw_mode = ui.new_combobox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Defensive Yaw Mode",  {"Static", "Jitter", "Delayed", "Flick", "Random"});
            defensive_yaw_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nDefensive Yaw" .. cache.anti_aim.builder_state[k], -180, 180, 0, true);
            defensive_yaw_first_slider = ui.new_slider("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Defensive Yaw First Value", -180, 180, 0, true);
            defensive_yaw_second_slider = ui.new_slider("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Defensive Yaw Second Value", -180, 180, 0, true);
            defensive_yaw_delay_slider = ui.new_slider("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Defensive Yaw Delay", 2, 10, 0, true);

            -- defensive yaw jitter
            defensive_yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", cache.ui.ui_color .. cache.anti_aim.builder_state[k] .. cache.ui.white_color .. " ~ Defensive Yaw Jitter", {"Off", "Offset", "Center", "Random", "Skitter"});
            defensive_yaw_jitter_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nDefensive Yaw Jitter" .. cache.anti_aim.builder_state[k], -180, 180, 0, true);
        }
    end

    -- misc tab
    cache.ui.misc.clantag = ui.new_checkbox("AA", "Anti-aimbot angles", "Synced Clantag");
    cache.ui.misc.killsay = ui.new_checkbox("AA", "Anti-aimbot angles", "Kill Say");
    cache.ui.misc.anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti Knife");
    cache.ui.misc.safe_knife_taser = ui.new_checkbox("AA", "Anti-aimbot angles", "Safe Knife/Taser");
    cache.ui.misc.animations = ui.new_multiselect("AA", "Anti-aimbot angles", "Animations", {"Zero Pitch On Land", "Static Legs In Air", "Legs Breaker", "Body Lean"});
    cache.ui.misc.freestanding_disablers = ui.new_multiselect("AA", "Anti-aimbot angles", "Freestanding Disablers", {
        "Standing";
        "Moving";
        "Slowmotion";
        "In Air";
        "In Air-Duck";
        "Duck-Moving";
        "Duck";
        "Fakelag";
    });
    cache.ui.misc.keys = ui.new_checkbox("AA", "Anti-aimbot angles", "Keys");
    cache.ui.misc.freestanding = ui.new_hotkey("AA", "Anti-aimbot angles", "Freestanding Key");
    cache.ui.misc.legit_aa_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Legit Key");
    cache.ui.misc.manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual Left Key");
    cache.ui.misc.manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual Right Key");
    cache.ui.misc.manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual Forward Key");
    cache.ui.misc.edgeyaw = ui.new_hotkey("AA", "Anti-aimbot angles", "Edge Yaw Key");

    -- visuals tab
    cache.ui.visuals.indicator = ui.new_combobox("AA", "Anti-aimbot angles", "Indicators", {"Disabled", "Default", "Fade"});
    cache.ui.visuals.indicator_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Indicators Color", unpack(hex_color_to_rgba(cache.ui.ui_color)));
    cache.ui.visuals.min_dmg_indicator = ui.new_checkbox("AA", "Anti-aimbot angles", "Minimum Damage Indicator");
    cache.ui.visuals.manual_indicator = ui.new_checkbox("AA", "Anti-aimbot angles", "Manual Indcators");

    -- config tab
    cache.ui.config.list = ui.new_listbox("AA", "Anti-aimbot angles", "Configs", "")
    cache.ui.config.name = ui.new_textbox("AA", "Anti-aimbot angles", "Config name", "")
    cache.ui.config.import = ui.new_button("AA", "Anti-aimbot angles", "\a989898FF Import Config", function() end)
    cache.ui.config.export = ui.new_button("AA", "Anti-aimbot angles", "\a989898FF Export Config", function() end)
    cache.ui.config.load = ui.new_button("AA", "Anti-aimbot angles", "\a989898FF Load Config", function() end)
    cache.ui.config.save = ui.new_button("AA", "Anti-aimbot angles", "\a989898FF Save Config", function() end)
    cache.ui.config.delete = ui.new_button("AA", "Anti-aimbot angles", "\a989898FF Delete Config", function() end)
    cache.config.cfg_ui = {
        anti_aim = {};
        misc = {};
        misc_tables = {};
        visuals = {};
    }
end

create_menu_elements();

--[[
    |==================================================================|
    |                                                                  |
    |=========================== CFG SYSTEM ===========================|
    |                                                                  |
    |==================================================================|
--]]

local export_config = function() 
    local code = {{}, {}, {}, {}};

    for index, value in pairs(cache.config.cfg_ui.anti_aim) do
        if ui.get(value) ~= nil then
            table.insert(code[1], tostring(ui.get(value)))
        end
    end

    for index, value in pairs(cache.config.cfg_ui.misc) do
        if ui.get(value) ~= nil then
            table.insert(code[2], tostring(ui.get(value)))
        end
    end

    for index, value in pairs(cache.config.cfg_ui.misc_tables) do
        if ui.get(value) ~= nil then
            table.insert(code[3], tostring(array_to_string(value)))
        end
    end

    for index, value in pairs(cache.config.cfg_ui.visuals) do
        if ui.get(value) ~= nil then
            table.insert(code[4], tostring(ui.get(value)))
        end
    end

    return json.stringify(code)
end

local load_config = function(string)
    for k, v in pairs(json.parse(string)) do
        k = ({[1] = "anti_aim", [2] = "misc", [3] = "misc_tables", [4] = "visuals"})[k]

        for k2, v2 in pairs(v) do
            if (k == "anti_aim") then
                if v2 == "true" then
                    ui.set(cache.config.cfg_ui[k][k2], true)
                elseif v2 == "false" then
                    ui.set(cache.config.cfg_ui[k][k2], false)
                else
                    ui.set(cache.config.cfg_ui[k][k2], v2)
                end
            end

            if (k == "misc") then
                if v2 == "true" then
                    ui.set(cache.config.cfg_ui[k][k2], true)
                elseif v2 == "false" then
                    ui.set(cache.config.cfg_ui[k][k2], false)
                else
                    ui.set(cache.config.cfg_ui[k][k2], v2)
                end
            end

            if (k == "misc_tables") then
                ui.set(cache.config.cfg_ui[k][k2], string_to_sub(v2, ","))
            end

            if (k == "visuals") then
                if v2 == "true" then
                    ui.set(cache.config.cfg_ui[k][k2], true)
                elseif v2 == "false" then
                    ui.set(cache.config.cfg_ui[k][k2], false)
                else
                    ui.set(cache.config.cfg_ui[k][k2], v2)
                end
            end
        end
    end     
end

local get_config = function(name)
    local database = database.read(cache.config.database.configs) or {}
    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end    

    for i, v in pairs(cache.config.presets) do
        if v.name == name then
            return {
                config = library.base64.decode(v.config),
                index = i
            }
        end
    end

    return false
end

local save_config = function(name)
    local db = database.read(cache.config.database.configs) or {}
    local config = {}

    if name:match("[^%w]") ~= nil then
        return
    end

    table.insert(config, export_config())

    local cfg = get_config(name)

    if not cfg then
        table.insert(db, { name = name, config = table.concat(config, ":") })
    else
        db[cfg.index].config = table.concat(config, ":")
    end

    database.write(cache.config.database.configs, db)
end

local delete_config = function(name)
    local db = database.read(cache.config.database.configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            table.remove(db, i)
            break
        end
    end

    for i, v in pairs(cache.config.presets) do
        if v.name == name then
            return false
        end
    end

    database.write(cache.config.database.configs, db)
end

local get_config_list = function()
    local database = database.read(cache.config.database.configs) or {}
    local config = {}
    local presets = cache.config.presets

    for i, v in pairs(presets) do
        table.insert(config, v.name)
    end

    for i, v in pairs(database) do
        table.insert(config, v.name)
    end

    return config
end

--[[
    |==================================================================|
    |                                                                  |
    |========================= DEFENSIVE FUNCS ========================|
    |                                                                  |
    |==================================================================|
--]]

local defensive_run = function(args)
    cache.anti_aim.defensive.defensive_cmd = args.command_number
end

local defensive_setup = function(args)
    if args.command_number == cache.anti_aim.defensive.defensive_cmd then
        local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
        cache.anti_aim.defensive.defensive = math.abs(tickbase -  cache.anti_aim.defensive.defensive_check)
        cache.anti_aim.defensive.defensive_check = math.max(tickbase, cache.anti_aim.defensive.defensive_check or 0)
        cache.anti_aim.defensive.defensive_cmd = 0
    end
end

local sim_diff = function() 
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return 0
    end
    local current_simulation_time = math.floor(0.5 + (entity.get_prop(entity.get_local_player(), "m_flSimulationTime") / globals.tickinterval())) 
    local diff = current_simulation_time - cache.anti_aim.funcs.prev_simulation_time
    cache.anti_aim.funcs.prev_simulation_time = current_simulation_time
    return diff
end

local defensive_aa = function(args)
    cache.anti_aim.funcs.old_weapon =cache.anti_aim.funcs.actual_weapon
    cache.anti_aim.funcs.actual_weapon = entity.get_player_weapon(entity.get_local_player())

    if cache.anti_aim.funcs.old_weapon ~= cache.anti_aim.funcs.actual_weapon then
        cache.anti_aim.funcs.to_start = true
    end

    if entity.get_player_weapon(entity.get_local_player()) ~=cache.anti_aim.funcs.old_weapon then
        cache.anti_aim.funcs.actual_tick = 0
        cache.anti_aim.funcs.to_start = true
    end
    
    if cache.anti_aim.funcs.to_start == true and cache.anti_aim.funcs.actual_tick < 100 then
        cache.anti_aim.funcs.actual_tick = cache.anti_aim.funcs.actual_tick + 1
    elseif cache.anti_aim.funcs.actual_tick >= 100 then
        cache.anti_aim.funcs.actual_tick = 0
        cache.anti_aim.funcs.to_start = false
    end

    cache.anti_aim.funcs.old_weapon = entity.get_player_weapon(entity.get_local_player())

    if cache.anti_aim.funcs.can_defensive then
        if ui.get(cache.ui.anti_aim.elements[cache.anti_aim.state_to_num[cache.anti_aim.funcs.old_def_state]].defensive) ~= ui.get(cache.ui.anti_aim.elements[cache.anti_aim.state_to_num[cache.anti_aim.state_aa]].defensive) then
            cache.anti_aim.funcs.can_defensive = false
        end
    end

    cache.anti_aim.funcs.old_def_state =cache.anti_aim.state_aa

    if cache.anti_aim.funcs.can_defensive then
        cache.anti_aim.funcs.def_ticks = 27
        cache.anti_aim.funcs.can_defensive = false
    end

    if cache.anti_aim.funcs.def_ticks > 0 then
        cache.anti_aim.funcs.def_ticks =cache.anti_aim.funcs.def_ticks - 1
    else
        cache.anti_aim.funcs.can_defensive = false
    end

    if cache.anti_aim.funcs.to_start == true then 
        return false
    end

    if (ui.get(cache.skeet_menu.other.double_tap[2]) or ui.get(cache.skeet_menu.other.hide_shots[2])) then
        if cache.anti_aim.funcs.def_ticks > 0 or args.force_defensive == true then 
            return true
        end
    else
        return false
    end
end

local get_aa_state = function(args)
    local lp = entity.get_local_player()
    local flags = entity.get_prop(lp, "m_fFlags")
    local vel1, vel2, vel3 = entity.get_prop(lp, "m_vecVelocity")
    local velocity = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))
    local in_air = bit.band(entity.get_prop(lp, "m_fFlags"), 1) == 0 or client.key_state(0x20)
    local not_moving = velocity < 2
    local slow = ui.get(cache.skeet_menu.other.slow_motion[2])

    local state = ""

    if ui.get(cache.skeet_menu.other.double_tap[2]) == false and ui.get(cache.skeet_menu.other.hide_shots[2]) == false then
        state = "Fakelag"
    elseif ui.get(cache.skeet_menu.other.fakeducking) then
        state = "Duck"
    elseif in_air then
        state = bit.band(flags, 4) == 4 and "In Air-Duck" or "In Air"
    else
        if bit.band(flags, 4) == 4 and velocity <= 2 then
            state = "Duck"
        elseif bit.band(flags, 4) == 4 and velocity >= 2 then
            state = "Duck-Moving"                
        elseif not_moving then   
            state = "Standing"
        elseif not not_moving then
            if slow then
                state = "Slowmotion"
            else
                state = "Moving"
            end
        end
    end

    cache.anti_aim.state_aa = state;
    return state
end

local anti_knife_dist = function(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end


local manipulation_flick = function(left, right, delay)
    if globals.tickcount() % delay == 0 then
        return left
    else
        return right
    end
end

local run_antiaim = function(args)
    local local_player = entity.get_local_player()
    if not local_player then
        return
    end

    local state_id = ui.get(cache.ui.anti_aim.elements[cache.anti_aim.state_to_num[get_aa_state(args)]].enable) and cache.anti_aim.state_to_num[get_aa_state(args)] or cache.anti_aim.state_to_num["Global"]
    
    if ui.get(cache.ui.misc.keys) and ui.get(cache.ui.misc.freestanding) and not table_contains(cache.ui.misc.freestanding_disablers, cache.anti_aim.state_aa) then
        if ui.get(cache.ui.anti_aim.elements[10].enable) then
            state_id = 10
        end
        ui.set(cache.skeet_menu.anti_aim.freestanding[1], true)
    else
        ui.set(cache.skeet_menu.anti_aim.freestanding[1], false)
    end

    -- pitch
    if (ui.get(cache.ui.anti_aim.elements[state_id].pitch) == "Zero") then
        cache.anti_aim.pitch = "Custom"
        cache.anti_aim.pitch_value = 0
    else
        cache.anti_aim.pitch = ui.get(cache.ui.anti_aim.elements[state_id].pitch)
        cache.anti_aim.pitch_value = ui.get(cache.ui.anti_aim.elements[state_id].pitch_slider)
    end

    -- yaw
    cache.anti_aim.yaw_base = ui.get(cache.ui.anti_aim.elements[state_id].yaw_base)
    cache.anti_aim.yaw = ui.get(cache.ui.anti_aim.elements[state_id].yaw)

    if ui.get(cache.ui.anti_aim.elements[state_id].yaw_mode) == "Delayed" then
        if globals.tickcount() > cache.anti_aim.current_tickcount + (ui.get(cache.ui.anti_aim.elements[state_id].yaw_delay_slider)) then
            if args.chokedcommands == 0 then
                cache.anti_aim.to_jitter = not cache.anti_aim.to_jitter
                cache.anti_aim.inverter = cache.anti_aim.to_jitter
                cache.anti_aim.current_tickcount = globals.tickcount()
            end
        elseif globals.tickcount() < cache.anti_aim.current_tickcount then
            cache.anti_aim.current_tickcount = globals.tickcount()
        end
    elseif ui.get(cache.ui.anti_aim.elements[state_id].yaw_mode) == "Flick" then
        cache.anti_aim.inverter = manipulation_flick(-1, 1, ui.get(cache.ui.anti_aim.elements[state_id].yaw_delay_slider))
    else
        cache.anti_aim.fake_body = math.max(-60, math.min(60, math.floor((entity.get_prop(local_player, "m_flPoseParameter",11) or 0) * 120 - 60.5)))
        cache.anti_aim.inverter = cache.anti_aim.fake_body > 0 and -1 or 1
    end
    
    if ui.get(cache.ui.anti_aim.elements[state_id].yaw_mode) == "Static" then
        cache.anti_aim.yaw_value = ui.get(cache.ui.anti_aim.elements[state_id].yaw_slider)
    elseif ui.get(cache.ui.anti_aim.elements[state_id].yaw_mode) == "L & R" then
        cache.anti_aim.yaw_value = cache.anti_aim.inverter == -1 and ui.get(cache.ui.anti_aim.elements[state_id].yaw_left_slider) or ui.get(cache.ui.anti_aim.elements[state_id].yaw_right_slider)
    elseif ui.get(cache.ui.anti_aim.elements[state_id].yaw_mode) == "Delayed" then
        cache.anti_aim.yaw_value = cache.anti_aim.inverter and ui.get(cache.ui.anti_aim.elements[state_id].yaw_left_slider) or ui.get(cache.ui.anti_aim.elements[state_id].yaw_right_slider)
    elseif ui.get(cache.ui.anti_aim.elements[state_id].yaw_mode) == "Flick" then
        cache.anti_aim.yaw_value = cache.anti_aim.inverter == -1 and ui.get(cache.ui.anti_aim.elements[state_id].yaw_left_slider) or ui.get(cache.ui.anti_aim.elements[state_id].yaw_right_slider)
    elseif ui.get(cache.ui.anti_aim.elements[state_id].yaw_mode) == "Random L & R" then
        cache.anti_aim.yaw_value = client.random_int(ui.get(cache.ui.anti_aim.elements[state_id].yaw_left_slider), ui.get(cache.ui.anti_aim.elements[state_id].yaw_right_slider))
    end

    -- yaw jitter
    cache.anti_aim.yaw_jitter = ui.get(cache.ui.anti_aim.elements[state_id].yaw_jitter)

    if ui.get(cache.ui.anti_aim.elements[state_id].yaw_jitter_mode) == "Static" then
        cache.anti_aim.yaw_jitter_value = ui.get(cache.ui.anti_aim.elements[state_id].yaw_jitter_slider)
    elseif ui.get(cache.ui.anti_aim.elements[state_id].yaw_jitter_mode) == "L & R" then
        cache.anti_aim.yaw_jitter_value = cache.anti_aim.inverter == -1 and ui.get(cache.ui.anti_aim.elements[state_id].yaw_jitter_left_slider) or ui.get(cache.ui.anti_aim.elements[state_id].yaw_jitter_right_slider)
    elseif ui.get(cache.ui.anti_aim.elements[state_id].yaw_jitter_mode) == "Random L & R" then
        cache.anti_aim.yaw_jitter_value = client.random_int(ui.get(cache.ui.anti_aim.elements[state_id].yaw_jitter_left_slider), ui.get(cache.ui.anti_aim.elements[state_id].yaw_jitter_right_slider))
    end

    -- body yaw
    cache.anti_aim.body_yaw = ui.get(cache.ui.anti_aim.elements[state_id].body_yaw)

    if ui.get(cache.ui.anti_aim.elements[state_id].yaw_mode) == "Delayed" then
        cache.anti_aim.body_yaw_value = cache.anti_aim.inverter and -115 or 115
        cache.anti_aim.body_yaw = "Static"
    else
        if ui.get(cache.ui.anti_aim.elements[state_id].body_yaw_sync) and ui.get(cache.ui.anti_aim.elements[state_id].yaw_mode) == "L & R" then
            cache.anti_aim.body_yaw_value = cache.anti_aim.inverter == -1 and -1 or 1
        elseif ui.get(cache.ui.anti_aim.elements[state_id].body_yaw_sync) and ui.get(cache.ui.anti_aim.elements[state_id].yaw_mode) == "Flick" then
            cache.anti_aim.body_yaw_value = cache.anti_aim.inverter == -1 and -180 or 180
        else
            cache.anti_aim.body_yaw_value = ui.get(cache.ui.anti_aim.elements[state_id].body_yaw_slider)
        end
    end

    -- freestanding body yaw & roll (useless)
    cache.anti_aim.freestanding_body_yaw = false -- ui.get(cache.ui.anti_aim.elements[state_id].freestanding_body_yaw);
    cache.anti_aim.roll = 0 -- ui.get(cache.ui.anti_aim.elements[state_id].roll);

    -- defensive
    if ui.get(cache.ui.anti_aim.elements[state_id].defensive) and ui.get(cache.ui.anti_aim.elements[state_id].defensive_force) then
        if ui.get(cache.skeet_menu.other.double_tap[2]) or ui.get(cache.skeet_menu.other.hide_shots[2]) then
            args.force_defensive = true
            if args.force_defensive then
                if globals.tickcount() % 10 <= 2 then
                    args.force_defensive = false
                end
            end
        end
    end
    
    if ui.get(cache.ui.anti_aim.elements[state_id].defensive) and defensive_aa(args) and cache.anti_aim.ignore_aa_manual == false and cache.anti_aim.ignore_aa_safe_knife_taser == false and cache.anti_aim.ignore_aa_anti_knife == false then
        args.no_choke = 1;
        args.quick_stop = 1;
        ui.set(cache.skeet_menu.anti_aim.freestanding[1], false)
        if ui.get(cache.ui.anti_aim.elements[state_id].defensive_pitch) ~= "Off" then
            if ui.get(cache.ui.anti_aim.elements[state_id].defensive_pitch) == "Zero" then
                cache.anti_aim.pitch = "Custom"
                cache.anti_aim.pitch_value = 0
            elseif ui.get(cache.ui.anti_aim.elements[state_id].defensive_pitch) == "Random" then
                local rand = math.random(1, 3)
                if rand == 1 then
                    cache.anti_aim.pitch = "Custom"
                    cache.anti_aim.pitch_value = 0
                else
                    cache.anti_aim.pitch = ({ "Zero", "Up", "Minimal" })[rand]
                end
            else
                cache.anti_aim.pitch = ui.get(cache.ui.anti_aim.elements[state_id].defensive_pitch)
                cache.anti_aim.pitch_value = ui.get(cache.ui.anti_aim.elements[state_id].defensive_pitch_slider)
            end
        end
        if ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw) ~= "Off" then
            cache.anti_aim.yaw = ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw)
            if ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_mode) == "Static" then
                cache.anti_aim.yaw_value = ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_slider)
            elseif ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_mode) == "Jitter" then
                cache.anti_aim.yaw_value = globals.tickcount() % 6 > 3 and ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_first_slider) or ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_second_slider)
            elseif ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_mode) == "Delayed" then
                cache.anti_aim.yaw_value = cache.anti_aim.to_jitter and ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_first_slider) or ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_second_slider)
            elseif ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_mode) == "Flick" then
                cache.anti_aim.yaw_value = manipulation_flick(ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_first_slider), ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_second_slider), ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_delay_slider))
            elseif ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_mode) == "Random" then
                local mathing_def_yaw = client.random_int(ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_first_slider), ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_second_slider))
                cache.anti_aim.yaw_value = globals.tickcount() % 6 < 3 and mathing_def_yaw or -mathing_def_yaw
            end
        end

        if ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_jitter) ~= "Off" then
            cache.anti_aim.yaw_jitter = ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_jitter)
            cache.anti_aim.yaw_jitter_value = ui.get(cache.ui.anti_aim.elements[state_id].defensive_yaw_jitter_slider)
        end
    end

    if ui.get(cache.ui.misc.keys) then
        -- legit aa
        if ui.get(cache.ui.misc.legit_aa_key) then
            if entity.get_player_weapon(entity.get_local_player()) ~= nil and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CC4" then
                if args.in_attack == 1 then
                    args.in_attack = 0 
                    args.in_use = 1
                end
            else
                if args.chokedcommands == 0 then
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[1], "Off");
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[2], 0);
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[1], "Static");
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[2], 180);
                    ui.set(cache.skeet_menu.anti_aim.yaw_base, "At Targets");
                    ui.set(cache.skeet_menu.anti_aim.yaw[1], "180");
                    ui.set(cache.skeet_menu.anti_aim.yaw[2], 180);
                    args.in_use = 0
                end
            end
        end

        -- freestanding
        if ui.get(cache.ui.misc.freestanding) and cache.anti_aim.ignore_aa_manual == false and cache.anti_aim.ignore_aa_safe_knife_taser == false and cache.anti_aim.ignore_aa_anti_knife == false then
            ui.set(cache.skeet_menu.anti_aim.freestanding[2], "Always on")
        else
            ui.set(cache.skeet_menu.anti_aim.freestanding[2], "On hotkey")
        end

        -- edge yaw
        if ui.get(cache.ui.misc.edgeyaw) and cache.anti_aim.ignore_aa_manual == false and cache.anti_aim.ignore_aa_safe_knife_taser == false and cache.anti_aim.ignore_aa_anti_knife == false then
            ui.set(cache.skeet_menu.anti_aim.edge_yaw, true)
        else
            ui.set(cache.skeet_menu.anti_aim.edge_yaw, false)
        end

        -- anti knife
        if ui.get(cache.ui.misc.anti_knife) then
            local players = entity.get_players(true)
            local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
            for i=1, #players do
                local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
                local distance = anti_knife_dist(lx, ly, lz, x, y, z)
                local weapon = entity.get_player_weapon(players[i])
                if entity.get_classname(weapon) == "CKnife" and distance <= 150 then
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[1], "Off");
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[2], 60);
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[1], "Jitter");
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[2], 0);
                    ui.set(cache.skeet_menu.anti_aim.yaw_base, "At Targets");
                    ui.set(cache.skeet_menu.anti_aim.yaw[1], "180");
                    ui.set(cache.skeet_menu.anti_aim.yaw[2], 180);
                    ui.set(cache.skeet_menu.anti_aim.pitch[1], "Default")
                    cache.anti_aim.ignore_aa_anti_knife = true;
                else
                    cache.anti_aim.ignore_aa_anti_knife = false;
                end
            end
        else
            cache.anti_aim.ignore_aa_anti_knife = false;
        end
        
        -- safe knife/taser
        if cache.anti_aim.ignore_aa_anti_knife == false then
            if ui.get(cache.ui.misc.safe_knife_taser) then
                local weapon_name = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))
                if weapon_name == "CWeaponTaser" or weapon_name == "CKnife" then
                    cache.anti_aim.ignore_aa_safe_knife_taser = true;
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[1], "Off");
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[2], 0);
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[1], "Static");
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[2], 180);
                    ui.set(cache.skeet_menu.anti_aim.yaw_base, "At Targets");
                    ui.set(cache.skeet_menu.anti_aim.yaw[1], "180");
                    ui.set(cache.skeet_menu.anti_aim.yaw[2], 0);
                    ui.set(cache.skeet_menu.anti_aim.pitch[1], "Minimal")
                else
                    cache.anti_aim.ignore_aa_safe_knife_taser = false;
                end
            else
                cache.anti_aim.ignore_aa_safe_knife_taser = false;
            end
        else
            cache.anti_aim.manual_input = 0;
            cache.anti_aim.ignore_aa_manual = false;
        end

        -- manual
        if cache.anti_aim.ignore_aa_safe_knife_taser == false and cache.anti_aim.ignore_aa_anti_knife == false then
            if cache.anti_aim.manual_input + 0.22 < globals.curtime() then
                if cache.anti_aim.manual_aa == 0 then
                    if ui.get(cache.ui.misc.manual_left) then
                        cache.anti_aim.manual_aa = 1
                        cache.anti_aim.manual_input = globals.curtime()
                    elseif ui.get(cache.ui.misc.manual_right) then
                        cache.anti_aim.manual_aa = 2
                        cache.anti_aim.manual_input = globals.curtime()
                    elseif ui.get(cache.ui.misc.manual_forward) then
                        cache.anti_aim.manual_aa = 3
                        cache.anti_aim.manual_input = globals.curtime()
                    end
                elseif cache.anti_aim.manual_aa == 1 then
                    if ui.get(cache.ui.misc.manual_right) then
                        cache.anti_aim.manual_aa = 2
                        cache.anti_aim.manual_input = globals.curtime()
                    elseif ui.get(cache.ui.misc.manual_forward) then
                        cache.anti_aim.manual_aa = 3
                        cache.anti_aim.manual_input = globals.curtime()
                    elseif ui.get(cache.ui.misc.manual_left) then
                        cache.anti_aim.manual_aa = 0
                        cache.anti_aim.manual_input = globals.curtime()
                    end
                elseif cache.anti_aim.manual_aa == 2 then
                    if ui.get(cache.ui.misc.manual_left) then
                        cache.anti_aim.manual_aa = 1
                        cache.anti_aim.manual_input = globals.curtime()
                    elseif ui.get(cache.ui.misc.manual_forward) then
                        cache.anti_aim.manual_aa = 3
                        cache.anti_aim.manual_input = globals.curtime()
                    elseif ui.get(cache.ui.misc.manual_right) then
                        cache.anti_aim.manual_aa = 0
                        cache.anti_aim.manual_input = globals.curtime()
                    end
                elseif cache.anti_aim.manual_aa == 3 then
                    if ui.get(cache.ui.misc.manual_forward) then
                        cache.anti_aim.manual_aa = 0
                        cache.anti_aim.manual_input = globals.curtime()
                    elseif ui.get(cache.ui.misc.manual_left) then
                        cache.anti_aim.manual_aa = 1
                        cache.anti_aim.manual_input = globals.curtime()
                    elseif ui.get(cache.ui.misc.manual_right) then
                        cache.anti_aim.manual_aa = 2
                        cache.anti_aim.manual_input = globals.curtime()
                    end
                end
            end
            if cache.anti_aim.manual_aa == 1 or cache.anti_aim.manual_aa == 2 or cache.anti_aim.manual_aa == 3 then
                cache.anti_aim.ignore_aa_manual = true;
                if cache.anti_aim.manual_aa == 1 then
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[1], "Off");
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[2], 0);
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[1], "Static");
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[2], -180);
                    ui.set(cache.skeet_menu.anti_aim.yaw_base, "Local View");
                    ui.set(cache.skeet_menu.anti_aim.yaw[1], "180");
                    ui.set(cache.skeet_menu.anti_aim.yaw[2], -90);
                    ui.set(cache.skeet_menu.anti_aim.pitch[1], "Minimal")
                elseif cache.anti_aim.manual_aa == 2 then
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[1], "Off");
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[2], 0);
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[1], "Static");
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[2], -180);
                    ui.set(cache.skeet_menu.anti_aim.yaw_base, "Local View");
                    ui.set(cache.skeet_menu.anti_aim.yaw[1], "180");
                    ui.set(cache.skeet_menu.anti_aim.yaw[2], 90);
                    ui.set(cache.skeet_menu.anti_aim.pitch[1], "Minimal")
                elseif cache.anti_aim.manual_aa == 3 then
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[1], "Off");
                    ui.set(cache.skeet_menu.anti_aim.yaw_jitter[2], 0);
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[1], "Static");
                    ui.set(cache.skeet_menu.anti_aim.body_yaw[2], -180);
                    ui.set(cache.skeet_menu.anti_aim.yaw_base, "At Targets");
                    ui.set(cache.skeet_menu.anti_aim.yaw[1], "180");
                    ui.set(cache.skeet_menu.anti_aim.yaw[2], 180);
                    ui.set(cache.skeet_menu.anti_aim.pitch[1], "Minimal")
                end
            else
                cache.anti_aim.ignore_aa_manual = false;
            end
        else
            cache.anti_aim.manual_input = 0;
            cache.anti_aim.ignore_aa_manual = false;
        end

    else
        cache.anti_aim.manual_input = 0;
        cache.anti_aim.ignore_aa_manual = false;
        cache.anti_aim.ignore_aa_anti_knife = false;
        cache.anti_aim.ignore_aa_safe_knife_taser = false;
    end

    -- set skeet aa
    if cache.anti_aim.ignore_aa_manual == false and cache.anti_aim.ignore_aa_safe_knife_taser == false and cache.anti_aim.ignore_aa_anti_knife == false then
        if args.chokedcommands == 0 then
            ui.set(cache.skeet_menu.anti_aim.pitch[1], cache.anti_aim.pitch)
            ui.set(cache.skeet_menu.anti_aim.pitch[2], cache.anti_aim.pitch_value)
            ui.set(cache.skeet_menu.anti_aim.yaw_base, cache.anti_aim.yaw_base)
            ui.set(cache.skeet_menu.anti_aim.yaw[1], cache.anti_aim.yaw)
            ui.set(cache.skeet_menu.anti_aim.yaw[2], cache.anti_aim.yaw_value)
            ui.set(cache.skeet_menu.anti_aim.yaw_jitter[1], cache.anti_aim.yaw_jitter)
            ui.set(cache.skeet_menu.anti_aim.yaw_jitter[2], cache.anti_aim.yaw_jitter_value)
            ui.set(cache.skeet_menu.anti_aim.body_yaw[1], cache.anti_aim.body_yaw)
            ui.set(cache.skeet_menu.anti_aim.body_yaw[2], cache.anti_aim.body_yaw_value)
            ui.set(cache.skeet_menu.anti_aim.freestanding_body_yaw, cache.anti_aim.freestanding_body_yaw)    
            ui.set(cache.skeet_menu.anti_aim.roll, cache.anti_aim.roll)
        end
    end
end

local anim_legs = function(args)
    cache.animations.is_on_ground = args.in_jump == 0

    if table_contains(cache.ui.misc.animations, "Legs Breaker") then
        ui.set(cache.skeet_menu.other.legs, args.command_number % 3 == 0 and "Off" or "Always slide")
    end
end

--[[
    |==================================================================|
    |                                                                  |
    |=============================== MENU =============================|
    |                                                                  |
    |==================================================================|
--]]

local rect_outline = function(x, y, w, h, r, g, b, a, t)
    renderer.rectangle(x, y, w - t, t, r, g, b, a)
    renderer.rectangle(x, y + t, t, h - t, r, g, b, a)
    renderer.rectangle(x + w - t, y, t, h - t, r, g, b, a)
    renderer.rectangle(x + t, y + h - t, w - t, t, r, g, b, a)
end

local gs_window = function(x, y, w, h, alpha, grad)
    local inbounds = { x = x + 6, y = y + (grad and 10 or 6), w = w - 12, h = h - (grad and 16 or 12) }

    renderer.texture(cache.menu.bg_texture, inbounds.x, inbounds.y, inbounds.w, inbounds.h, 255,255,255,255 * alpha, "r")

    rect_outline(x, y, w, h, 12, 12, 12, 255 * alpha, 1)
    rect_outline(x + 1, y + 1, w - 2, h - 2, 60, 60, 60, 255 * alpha, 1)
    rect_outline(x + 2, y + 2, w - 4, h - 4, 40, 40, 40, 255 * alpha, 3)
    rect_outline(x + 5, y + 5, w - 10, h - 10, 60, 60, 60, 255 * alpha, 1)

    if grad then
        rect_outline(x + 6, y + 6, w - 12, 4, 12, 12, 12, 255 * alpha, 1)
        renderer.rectangle(x + 7, y + 8, w - 14, 1, 3, 2, 13, 255 * alpha)

        local alphas = { 255, 128 }
        local width = math.floor(w / 2) - 12
        local width2 = x + w - (x + width) - 12
    
        for i = 1, 2 do
            local a = alphas[i] * alpha
            renderer.gradient(x + 6, y + i + 5, width, 1, 55, 177, 218, a, 201, 84, 192, a, true)
            renderer.gradient(x + width + 6, y + i + 5, width2, 1, 201, 84, 192, a, 204, 227, 54, a, true)
        end
    end

    return inbounds
end

local check_skeet_menu_tab = function()
    local pos = { ui.menu_position() }
    local m_pos = { ui.mouse_position() }
    for i = 1, 9 do
        local Offset = { cache.menu.size.x, cache.menu.size.y + cache.menu.size.h * (i - 1) }
        if m_pos[1] >= pos[1] + Offset[1] and m_pos[1] <= pos[1] + cache.menu.size.w + Offset[1] and m_pos[2] >= pos[2] + Offset[2] and m_pos[2] <= pos[2] + cache.menu.size.h + Offset[2] then
            return i
        end
    end
    return cache.menu.skeet_selected_tab
end

local check_menu_tab = function(cont, box_widths, mouse_pos)
    local prev_end_pos = cont.x

    cache.menu.hovered = false

    for i = 1, 5 do
        local x = prev_end_pos
        local y = cont.y
        local width = box_widths[i]
        local height = cont.h

        if mouse_pos.x >= x and mouse_pos.x < x + width and mouse_pos.y >= y and mouse_pos.y <= y + height then
            if ui.is_menu_open() then
                cache.menu.hovered = true
            end

            return i
        else
            cache.menu.hovered = false
        end

        prev_end_pos = prev_end_pos + box_widths[i]
    end

    return cache.menu.selected_tab
end

local setup_menu_icons = function()
    local icon_links = {
        "https://cdn.discordapp.com/attachments/1113023220673679411/1157733937775394908/iconmonstr-warning-2-240.png"; -- info
        "https://cdn.discordapp.com/attachments/1113023220673679411/1157724273843114005/iconmonstr-accessibility-1-2401.png"; -- anti_aim
        "https://cdn.discordapp.com/attachments/1113023220673679411/1157724273398521897/iconmonstr-gear-11-2401.png"; -- misc
        "https://cdn.discordapp.com/attachments/1113023220673679411/1157724273616629910/iconmonstr-weather-114-2401.png"; -- visuals
        "https://cdn.discordapp.com/attachments/1113023220673679411/1157724273176219771/iconmonstr-save-3-2401.png"; -- cfg
    };

    for i, link in pairs(icon_links) do
        local db_read = database.read(link) 
        if db_read then
            cache.menu.icons[i] = library.images.load_png(db_read)
        else
            library.http.get(link, function(success, response)
                if not success or response.status ~= 200 then
                    client.delay_call(5, image_recursive)
                else
                    cache.menu.icons[i] = library.images.load_png(response.body)
                    database.write(link, response.body)
                end
            end)
        end
    end
end

local render_menu_icons = function()
    if not cache.menu.m1_down and client.key_state(0x01) then
        cache.menu.m1_down = true
        cache.menu.skeet_selected_tab = check_skeet_menu_tab()
    end

    if not client.key_state(0x01) then
        cache.menu.m1_down = false
    end

    if cache.menu.skeet_selected_tab ~= 2 then
        cache.menu.hovered = false
        return
    end

    local menu_pos_x, menu_pos_y = ui.menu_position()
    local menu_siz_x, menu_siz_y = ui.menu_size()
    local gs_window = gs_window(menu_pos_x, menu_pos_y - 70, menu_siz_x, 70, 1, true)
    local box_widths = {}
    local prev_end_pos = gs_window.x
    local base_width = math.floor(gs_window.w / 5)
    local total_gap = gs_window.w - base_width * 5
    
    local icon_size = 35

    for i = 1, 5 do
        if total_gap > 0 then
            box_widths[i] = base_width + 1
            total_gap = total_gap - 1
        else
            box_widths[i] = base_width
        end

        if i == cache.menu.selected_tab then
            renderer.rectangle(prev_end_pos, gs_window.y, box_widths[i], gs_window.h, 255, 255, 255, 255 * 0.026)
        end

        local iconX = prev_end_pos + (box_widths[i] - icon_size) / 2
        local iconY = gs_window.y + (gs_window.h - icon_size) / 2

        cache.menu.icons[i]:draw(iconX, iconY, icon_size, icon_size, 255, 255, 255, 255, false, "f")
        prev_end_pos = prev_end_pos + box_widths[i]
    end

    if client.key_state(0x01) then
        cache.menu.selected_tab = check_menu_tab(gs_window, box_widths, library.vector(ui.mouse_position()))
    end

    if cache.menu.selected_tab == 1 then
        cache.ui.tab_selector = "info"
    elseif cache.menu.selected_tab == 2 then
        cache.ui.tab_selector = "antiaim"
    elseif cache.menu.selected_tab == 3 then
        cache.ui.tab_selector = "misc"
    elseif cache.menu.selected_tab == 4 then
        cache.ui.tab_selector = "visuals"
    elseif cache.menu.selected_tab == 5 then
        cache.ui.tab_selector = "config"
    end
end

local render_watermark = function()
    -- if not entity.is_alive(entity.get_local_player()) then return end

    local indicator_color = { ui.get(cache.ui.visuals.indicator_color) }
    local indicator_color_hex = "\a" .. rgba_to_hex(indicator_color[1], indicator_color[2], indicator_color[3], indicator_color[4])
    local text = fade_text(10, { indicator_color[1], indicator_color[2], indicator_color[3], indicator_color[4] }, lua_name) .. cache.ui.white_color .. " | " .. cache.ui.white_color .. build .. " | " .. indicator_color_hex .. username

    local h, w = 18, renderer.measure_text(nil, text)
    local x, y = client.screen_size()

    renderer.text(x / 2, y - 29, 255, 255, 255, 255, "cd", 0, text)
end

local dt_charged = function()
    if not ui.get(cache.skeet_menu.other.double_tap[1]) or not ui.get(cache.skeet_menu.other.double_tap[2]) then
        return false
    end

    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then
        return
    end

    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if weapon == nil then
        return false
    end

    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
    local next_ready = entity.get_prop(weapon, "m_flNextPrimaryAttack")
    if next_ready == nil then
        return
    end

    local next_primary_attack = next_ready + 0.5
    if next_attack == nil or next_primary_attack == nil then
        return false
    end
    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end

local indicators = {
    text_anim = { 0, 0, 0, 0 };
    add_y = { 0, 0 };
    addition = 0;
}
  
local render_indicators = function()
    if not entity.is_alive(entity.get_local_player()) then return end

    local w, h = client.screen_size()

    -- centered indicators
    if ui.get(cache.ui.visuals.indicator) == "Fade"  then
        local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1 and true or false
        local indicator_color = { ui.get(cache.ui.visuals.indicator_color) }
        
        -- logo
        renderer.text(w / 2 + math.ceil(indicators.text_anim[1]), h / 2 + 25, 255, 255, 255, 255, "cdb", 0,
            fade_text(5, { indicator_color[1], indicator_color[2], indicator_color[3], indicator_color[4] }, lua_name) .. cache.ui.white_color .. " " .. build)

        -- dt
        if ui.get(cache.skeet_menu.other.double_tap[1]) and ui.get(cache.skeet_menu.other.double_tap[2]) then
            if dt_charged() then
                renderer.text(w / 2 + math.ceil(indicators.text_anim[2]), h / 2 + 25 + math.ceil(indicators.add_y[1]), 0, 255, 0, 255, "cd", 0, "dt")
            else
                renderer.text(w / 2 + math.ceil(indicators.text_anim[2]), h / 2 + 25 + math.ceil(indicators.add_y[1]), 255, 0, 0, 255, "cd", 0, "dt")
            end
        end

        -- hs
        if ui.get(cache.skeet_menu.other.hide_shots[1]) and ui.get(cache.skeet_menu.other.hide_shots[2]) and not ui.get(cache.skeet_menu.other.double_tap[2]) then
            renderer.text(w / 2 + math.ceil(indicators.text_anim[3]), h / 2 + 25 + math.ceil(indicators.add_y[2]), 255, 255, 255, 255, "cd", 0, "hs")
        end

        if ui.get(cache.skeet_menu.other.double_tap[1]) and ui.get(cache.skeet_menu.other.double_tap[2]) then
            indicators.addition = indicators.add_y[1]
        elseif ui.get(cache.skeet_menu.other.hide_shots[1]) and ui.get(cache.skeet_menu.other.hide_shots[2]) and not ui.get(cache.skeet_menu.other.double_tap[2]) then
            indicators.addition = indicators.add_y[2]
        else
            indicators.addition = lerp(indicators.addition, 0, globals.frametime() * 15)
        end

        -- state
        renderer.text(w / 2 + math.ceil(indicators.text_anim[4]), h / 2 + 35 + math.ceil(indicators.addition), 255, 255, 255, 255, "cd", 0, "'" .. string.lower(cache.anti_aim.state_aa) .. "'")

        local text = { lua_name .. " " .. build, "dt", "hs", "'" .. string.lower(cache.anti_aim.state_aa) .. "'" }
        for i = 1, #text do
            local measure = {
                library.vector(renderer.measure_text("cdb", text[i]));
                library.vector(renderer.measure_text("cd", text[i]));
                library.vector(renderer.measure_text("cd", text[i]));
                library.vector(renderer.measure_text("cd", text[i]));
            }

            indicators.text_anim[i] = lerp(indicators.text_anim[i], scoped and measure[i].x / 2 + 3 or 0, globals.frametime() * 15)

            if i < 3 then
                if i == 1 then
                    indicators.add_y[i] = lerp(indicators.add_y[i], (ui.get(cache.skeet_menu.other.double_tap[1]) and ui.get(cache.skeet_menu.other.double_tap[2])) and 10 or 0, globals.frametime() * 15)
                else
                    local can = ui.get(cache.skeet_menu.other.hide_shots[1]) and ui.get(cache.skeet_menu.other.hide_shots[2]) and not ui.get(cache.skeet_menu.other.double_tap[2])
                    indicators.add_y[i] = lerp(indicators.add_y[i], can and 10 or 0, globals.frametime() * 15)
                end
            end
        end
    elseif ui.get(cache.ui.visuals.indicator) == "Default"  then
        local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1 and true or false
        local indicator_color = { ui.get(cache.ui.visuals.indicator_color) }
        
        -- logo
        renderer.text(w / 2 + math.ceil(indicators.text_anim[1]), h / 2 + 25, indicator_color[1], indicator_color[2], indicator_color[3], indicator_color[4], "cd-", 0, string.upper(lua_name))

        -- dt
        if ui.get(cache.skeet_menu.other.double_tap[1]) and ui.get(cache.skeet_menu.other.double_tap[2]) then
            if dt_charged() then
                renderer.text(w / 2 + math.ceil(indicators.text_anim[2]), h / 2 + 25 + math.ceil(indicators.add_y[1]), 0, 255, 0, 255, "cd-", 0, "DT")
            else
                renderer.text(w / 2 + math.ceil(indicators.text_anim[2]), h / 2 + 25 + math.ceil(indicators.add_y[1]), 255, 0, 0, 255, "cd-", 0, "DT")
            end
        end

        -- hs
        if ui.get(cache.skeet_menu.other.hide_shots[1]) and ui.get(cache.skeet_menu.other.hide_shots[2]) and not ui.get(cache.skeet_menu.other.double_tap[2]) then
            renderer.text(w / 2 + math.ceil(indicators.text_anim[3]), h / 2 + 25 + math.ceil(indicators.add_y[2]), 255, 255, 255, 255, "cd-", 0, "HS")
        end

        if ui.get(cache.skeet_menu.other.double_tap[1]) and ui.get(cache.skeet_menu.other.double_tap[2]) then
            indicators.addition = indicators.add_y[1]
        elseif ui.get(cache.skeet_menu.other.hide_shots[1]) and ui.get(cache.skeet_menu.other.hide_shots[2]) and not ui.get(cache.skeet_menu.other.double_tap[2]) then
            indicators.addition = indicators.add_y[2]
        else
            indicators.addition = lerp(indicators.addition, 0, globals.frametime() * 15)
        end

        -- state
        renderer.text(w / 2 + math.ceil(indicators.text_anim[4]), h / 2 + 35 + math.ceil(indicators.addition), 255, 255, 255, 255, "cd-", 0, "'" .. string.upper(cache.anti_aim.state_aa) .. "'")

        local text = { string.upper(lua_name), "DT", "HS", "'" .. string.upper(cache.anti_aim.state_aa) .. "'" }
        for i = 1, #text do
            local measure = {
                library.vector(renderer.measure_text("cd-", text[i]));
                library.vector(renderer.measure_text("cd-", text[i]));
                library.vector(renderer.measure_text("cd-", text[i]));
                library.vector(renderer.measure_text("cd-", text[i]));
            }

            indicators.text_anim[i] = lerp(indicators.text_anim[i], scoped and measure[i].x / 2 + 3 or 0, globals.frametime() * 15)

            if i < 3 then
                if i == 1 then
                    indicators.add_y[i] = lerp(indicators.add_y[i], (ui.get(cache.skeet_menu.other.double_tap[1]) and ui.get(cache.skeet_menu.other.double_tap[2])) and 10 or 0, globals.frametime() * 15)
                else
                    local can = ui.get(cache.skeet_menu.other.hide_shots[1]) and ui.get(cache.skeet_menu.other.hide_shots[2]) and not ui.get(cache.skeet_menu.other.double_tap[2])
                    indicators.add_y[i] = lerp(indicators.add_y[i], can and 10 or 0, globals.frametime() * 15)
                end
            end
        end
    end

    -- minimum damage indicator
    if ui.get(cache.ui.visuals.min_dmg_indicator) then
        if ui.get(cache.skeet_menu.other.min_dmg_override[2]) then
            renderer.text(w / 2 + 12, h / 2 - 12, 255, 255, 255, 225, "cd", 0, ui.get(cache.skeet_menu.other.min_dmg_override[3]))
        else
            renderer.text(w / 2 + 12, h / 2 - 12, 255, 255, 255, 225, "cd", 0, ui.get(cache.skeet_menu.other.min_dmg))
        end
    end

    -- manual indicators
    if ui.get(cache.ui.visuals.manual_indicator) then
        renderer.text(w / 2 - 35, h / 2, 255, 255, 255, cache.anti_aim.manual_aa == 1 and 255 or 100, "cb", 0, "⮜")
        renderer.text(w / 2 + 35, h / 2, 255, 255, 255, cache.anti_aim.manual_aa == 2 and 255 or 100, "cb", 0, "⮞")
    end
end

--[[
    |==================================================================|
    |                                                                  |
    |============================== EVENTS ============================|
    |                                                                  |
    |==================================================================|
--]]

client.set_event_callback("paint_ui", function()
    if ui.is_menu_open() then
        render_menu_icons()

        if cache.menu.selected_tab == 1 then
            ui.set(cache.ui.tab_label, fade_text(3, hex_color_to_rgba(cache.ui.ui_color), "~ Information ~"))
        elseif cache.menu.selected_tab == 2 then
            ui.set(cache.ui.tab_label, fade_text(3, hex_color_to_rgba(cache.ui.ui_color), "~ Anti Aim ~"))
        elseif cache.menu.selected_tab == 3 then
            ui.set(cache.ui.tab_label, fade_text(3, hex_color_to_rgba(cache.ui.ui_color), "~ Miscellaneous ~"))
        elseif cache.menu.selected_tab == 4 then
            ui.set(cache.ui.tab_label, fade_text(3, hex_color_to_rgba(cache.ui.ui_color), "~ Visuals ~"))
        elseif cache.menu.selected_tab == 5 then
            ui.set(cache.ui.tab_label, fade_text(3, hex_color_to_rgba(cache.ui.ui_color), "~ Config ~"))
        end
        
        -- antiaim tab
        set_element("vis_elem", cache.ui.anti_aim.builder_state, cache.ui.tab_selector == "antiaim", nil)
        set_element("elem", cache.skeet_menu.anti_aim.enable, true, nil)

        for i = 1, #cache.anti_aim.builder_state do
            local selecte = ui.get(cache.ui.anti_aim.builder_state)
            local is_antiaim_tab = cache.ui.tab_selector == "antiaim"
            local conditions_enabled = ui.get(cache.ui.anti_aim.elements[i].enable)
            local show_ = is_antiaim_tab and selecte == cache.anti_aim.builder_state[i] and conditions_enabled

            -- enable
            ui.set_visible(cache.ui.anti_aim.elements[i].enable, is_antiaim_tab and selecte == cache.anti_aim.builder_state[i])

            -- pitch
            ui.set_visible(cache.ui.anti_aim.elements[i].pitch, show_)
            ui.set_visible(cache.ui.anti_aim.elements[i].pitch_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].pitch) == "Custom")

            -- yaw
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw_base, show_)
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw, show_)
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw_mode, show_ and ui.get(cache.ui.anti_aim.elements[i].yaw) ~= "Off")
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].yaw) ~= "Off" and ui.get(cache.ui.anti_aim.elements[i].yaw_mode) == "Static")
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw_left_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].yaw) ~= "Off" and (ui.get(cache.ui.anti_aim.elements[i].yaw_mode) == "L & R" or ui.get(cache.ui.anti_aim.elements[i].yaw_mode) == "Delayed" or ui.get(cache.ui.anti_aim.elements[i].yaw_mode) == "Flick" or ui.get(cache.ui.anti_aim.elements[i].yaw_mode) == "Random L & R"))
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw_right_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].yaw) ~= "Off" and (ui.get(cache.ui.anti_aim.elements[i].yaw_mode) == "L & R" or ui.get(cache.ui.anti_aim.elements[i].yaw_mode) == "Delayed" or ui.get(cache.ui.anti_aim.elements[i].yaw_mode) == "Flick" or ui.get(cache.ui.anti_aim.elements[i].yaw_mode) == "Random L & R"))
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw_delay_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].yaw) ~= "Off" and (ui.get(cache.ui.anti_aim.elements[i].yaw_mode) == "Delayed" or ui.get(cache.ui.anti_aim.elements[i].yaw_mode) == "Flick"))

            -- yaw jitter
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw_jitter, show_)
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw_jitter_mode, show_ and ui.get(cache.ui.anti_aim.elements[i].yaw_jitter) ~= "Off")
            ui.set_visible(cache.ui.anti_aim.elements[i].body_yaw_sync, show_ and ui.get(cache.ui.anti_aim.elements[i].yaw) ~= "Off" and ui.get(cache.ui.anti_aim.elements[i].yaw_mode) ~= "Delayed")
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw_jitter_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].yaw_jitter) ~= "Off" and ui.get(cache.ui.anti_aim.elements[i].yaw_jitter_mode) == "Static")
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw_jitter_left_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].yaw_jitter) ~= "Off" and (ui.get(cache.ui.anti_aim.elements[i].yaw_jitter_mode) == "L & R" or ui.get(cache.ui.anti_aim.elements[i].yaw_jitter_mode) == "Random L & R"))
            ui.set_visible(cache.ui.anti_aim.elements[i].yaw_jitter_right_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].yaw_jitter) ~= "Off" and (ui.get(cache.ui.anti_aim.elements[i].yaw_jitter_mode) == "L & R" or ui.get(cache.ui.anti_aim.elements[i].yaw_jitter_mode) == "Random L & R"))

            -- body yaw
            ui.set_visible(cache.ui.anti_aim.elements[i].body_yaw, show_ and ui.get(cache.ui.anti_aim.elements[i].yaw_mode) ~= "Delayed")
            ui.set_visible(cache.ui.anti_aim.elements[i].body_yaw_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].body_yaw) ~= "Off" and ui.get(cache.ui.anti_aim.elements[i].body_yaw_sync) == false and ui.get(cache.ui.anti_aim.elements[i].yaw_mode) ~= "Delayed")
            
            -- roll & freestanding body yaw (useless)
            ui.set_visible(cache.ui.anti_aim.elements[i].roll, false)
            ui.set_visible(cache.ui.anti_aim.elements[i].freestanding_body_yaw, false)

            -- defensive
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive, show_)
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive_force, show_ and ui.get(cache.ui.anti_aim.elements[i].defensive))

            -- defensive pitch
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive_pitch, show_ and ui.get(cache.ui.anti_aim.elements[i].defensive))
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive_pitch_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].defensive_pitch) == "Custom" and ui.get(cache.ui.anti_aim.elements[i].defensive))

            -- defensive yaw
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive_yaw, show_ and ui.get(cache.ui.anti_aim.elements[i].defensive))
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive_yaw_mode, show_ and ui.get(cache.ui.anti_aim.elements[i].defensive) and ui.get(cache.ui.anti_aim.elements[i].defensive_yaw) ~= "Off") 
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive_yaw_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].defensive_yaw) ~= "Off" and ui.get(cache.ui.anti_aim.elements[i].defensive) and (ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_mode) == "Static"))
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive_yaw_first_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].defensive_yaw) ~= "Off" and ui.get(cache.ui.anti_aim.elements[i].defensive) and (ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_mode) == "Jitter" or ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_mode) == "Delayed" or ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_mode) == "Flick" or ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_mode) == "Random"))
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive_yaw_second_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].defensive_yaw) ~= "Off" and ui.get(cache.ui.anti_aim.elements[i].defensive) and (ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_mode) == "Jitter" or ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_mode) == "Delayed" or ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_mode) == "Flick" or ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_mode) == "Random"))
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive_yaw_delay_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].defensive_yaw) ~= "Off" and ui.get(cache.ui.anti_aim.elements[i].defensive) and (ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_mode) == "Delayed" or ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_mode) == "Flick"))

            -- defensive yaw jitter
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive_yaw_jitter, show_ and ui.get(cache.ui.anti_aim.elements[i].defensive))
            ui.set_visible(cache.ui.anti_aim.elements[i].defensive_yaw_jitter_slider, show_ and ui.get(cache.ui.anti_aim.elements[i].defensive) and ui.get(cache.ui.anti_aim.elements[i].defensive_yaw_jitter) ~= "Off")
        end

        -- info tab
        set_element("vis_elem", cache.ui.info.welcome_label, cache.ui.tab_selector == "info", nil)
        set_element("vis_elem", cache.ui.info.user_label, cache.ui.tab_selector == "info", nil)
        set_element("vis_elem", cache.ui.info.build_label, cache.ui.tab_selector == "info", nil)
        set_element("vis_elem", cache.ui.info.version_label, cache.ui.tab_selector == "info", nil)
        
        -- misc tab
        set_element("vis_elem", cache.ui.misc.clantag, cache.ui.tab_selector == "misc", nil)
        set_element("vis_elem", cache.ui.misc.killsay, cache.ui.tab_selector == "misc", nil)
        set_element("vis_elem", cache.ui.misc.animations, cache.ui.tab_selector == "misc", nil)
        set_element("vis_elem", cache.ui.misc.freestanding_disablers, cache.ui.tab_selector == "misc", nil)
        set_element("vis_elem", cache.ui.misc.anti_knife, cache.ui.tab_selector == "misc", nil)
        set_element("vis_elem", cache.ui.misc.safe_knife_taser, cache.ui.tab_selector == "misc", nil)
        set_element("vis_elem", cache.ui.misc.keys, cache.ui.tab_selector == "misc", nil)
        set_element("vis_elem", cache.ui.misc.freestanding, cache.ui.tab_selector == "misc" and ui.get(cache.ui.misc.keys), nil)
        set_element("vis_elem", cache.ui.misc.legit_aa_key, cache.ui.tab_selector == "misc" and ui.get(cache.ui.misc.keys), nil)
        set_element("vis_elem", cache.ui.misc.manual_left, cache.ui.tab_selector == "misc" and ui.get(cache.ui.misc.keys), nil)
        set_element("vis_elem", cache.ui.misc.manual_right, cache.ui.tab_selector == "misc" and ui.get(cache.ui.misc.keys), nil)
        set_element("vis_elem", cache.ui.misc.manual_forward, cache.ui.tab_selector == "misc" and ui.get(cache.ui.misc.keys), nil)
        set_element("vis_elem", cache.ui.misc.edgeyaw, cache.ui.tab_selector == "misc" and ui.get(cache.ui.misc.keys), nil)

        set_element("elem", cache.ui.misc.manual_left, "On hotkey", nil)
        set_element("elem", cache.ui.misc.manual_right, "On hotkey", nil)
        set_element("elem", cache.ui.misc.manual_forward, "On hotkey", nil)

        -- visuals tab
        set_element("vis_elem", cache.ui.visuals.indicator, cache.ui.tab_selector == "visuals", nil)
        set_element("vis_elem", cache.ui.visuals.indicator_color, cache.ui.tab_selector == "visuals" and ui.get(cache.ui.visuals.indicator) ~= "Disabled", nil)
        set_element("vis_elem", cache.ui.visuals.min_dmg_indicator, cache.ui.tab_selector == "visuals", nil)
        set_element("vis_elem", cache.ui.visuals.manual_indicator, cache.ui.tab_selector == "visuals", nil)

        -- config tab
        set_element("vis_elem", cache.ui.config.list, cache.ui.tab_selector == "config", nil)
        set_element("vis_elem", cache.ui.config.name, cache.ui.tab_selector == "config", nil)
        set_element("vis_elem", cache.ui.config.load, cache.ui.tab_selector == "config", nil)
        set_element("vis_elem", cache.ui.config.save, cache.ui.tab_selector == "config", nil)
        set_element("vis_elem", cache.ui.config.delete, cache.ui.tab_selector == "config", nil)
        set_element("vis_elem", cache.ui.config.import, cache.ui.tab_selector == "config", nil)
        set_element("vis_elem", cache.ui.config.export, cache.ui.tab_selector == "config", nil)

        set_element("vis", nil, nil, "load")
    else -- menu not opened
        cache.menu.hovered = false
    end

    render_watermark()
    render_indicators()

    if sim_diff() <= -1 and cache.anti_aim.funcs.to_start == false then
        cache.anti_aim.funcs.can_defensive = true
    end
end)

client.set_event_callback("pre_render", function()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return
    end

    local index = library.entity.new(local_player)
    local anim_state = index:get_anim_state()

    if not anim_state then
        return
    end

    if table_contains(cache.ui.misc.animations, "Static Legs In Air") then
        entity.set_prop(local_player, "m_flPoseParameter", 0.75, cache.animations.E_POSE_PARAMETERS.JUMP_FALL)
    end

    if table_contains(cache.ui.misc.animations, "Legs Breaker") then
        entity.set_prop(local_player, "m_flPoseParameter", cache.animations.E_POSE_PARAMETERS.STAND, globals.tickcount() % 4 > 1 and 0.01 or 1)
    end

    if table_contains(cache.ui.misc.animations, "Body Lean") then
        local anim_overlay = index:get_anim_overlay(12)
        if not anim_overlay then
            return
        end

        local x_velocity = entity.get_prop(local_player, "m_vecVelocity[0]")
        if math.abs(x_velocity) >= 3 then
            anim_overlay.weight = 0.75
        end
    end

    if table_contains(cache.ui.misc.animations, "Zero Pitch On Land") then
        if not anim_state.hit_in_ground_animation or not cache.animations.is_on_ground then
            return
        end

        entity.set_prop(local_player, "m_flPoseParameter", 0.5, cache.animations.E_POSE_PARAMETERS.BODY_PITCH)
    end 
end)

client.set_event_callback("net_update_end", function()
    if ui.get(cache.skeet_menu.other.gs_clantag) then
        return 
    end

    local cur = math.floor(globals.tickcount() / table_size(cache.clan_tag.tags)) % #cache.clan_tag.tags
    local clantag = cache.clan_tag.tags[cur + 1]

    if ui.get(cache.ui.misc.clantag) then
        if clantag ~= cache.clan_tag.prev then
            cache.clan_tag.prev = clantag
            client.set_clan_tag(clantag)
        end
    end
end)

ui.set_callback(cache.ui.misc.clantag, function()
    client.set_clan_tag("\0")
end)

client.set_event_callback("player_death", function(e)
    if not ui.get(cache.ui.misc.killsay) then return end
    if client.userid_to_entindex(e.target) == entity.get_local_player() then return end
    if client.userid_to_entindex(e.attacker) == entity.get_local_player() then
        local random_number = math.random(1, #cache.kill_say_messages)
        client.exec("say " .. cache.kill_say_messages[random_number])
    end
end)

client.set_event_callback("setup_command", function(args)
    if cache.menu.hovered then
        args.in_attack = false
    end

    if args.chokedcommands > 1 then
        cache.anti_aim.funcs.def_ticks = 0
        args.force_defensive = false
        cache.anti_aim.defensive.defensive = 0
    end

    run_antiaim(args)
    anim_legs(args)
end)

client.set_event_callback("run_command", function(args)
    defensive_run(args)
end)

client.set_event_callback("predict_command", function(args)
    defensive_setup(args)
end)

client.set_event_callback("round_start", function()
    cache.anti_aim.manual_input = 0;
    cache.anti_aim.manual_aa = 0;
    cache.anti_aim.ignore_aa_manual = false;
    cache.anti_aim.ignore_aa_anti_knife = false;
    cache.anti_aim.ignore_aa_safe_knife_taser = false;

    ui.set(cache.ui.misc.manual_left, false)
    ui.set(cache.ui.misc.manual_right, false)
    ui.set(cache.ui.misc.manual_forward, false)
end)

client.set_event_callback("level_init", function()
    cache.anti_aim.defensive.defensive = 0
    cache.anti_aim.defensive.defensive_check = 0
    cache.anti_aim.manual_input = 0;
    cache.anti_aim.manual_aa = 0;
    cache.anti_aim.ignore_aa_manual = false;
    cache.anti_aim.ignore_aa_anti_knife = false;
    cache.anti_aim.ignore_aa_safe_knife_taser = false;

    ui.set(cache.ui.misc.manual_left, false)
    ui.set(cache.ui.misc.manual_right, false)
    ui.set(cache.ui.misc.manual_forward, false)
end)

client.set_event_callback("shutdown", function()
    set_element("vis", nil, nil, "unload")
end)

--[[
    |==================================================================|
    |                                                                  |
    |============================ INITIALIZE ==========================|
    |                                                                  |
    |==================================================================|
--]]

local initialize = function()
    client.exec("clear")
    color_print({255, 255, 255, "["}, {149, 162, 255, lua_name }, {255, 255, 255, "]"}, " Initializing...")

    check_libraries();

    set_element("vis", nil, nil, "load");
    setup_menu_icons();

    ui.set_callback(ui.reference("MISC", "Settings", "DPI scale"), function(args)
        dpi = tonumber(ui.get(args):sub(1, 3)) * 0.01
        cache.menu.size.w = cache.menu.size.default.w * dpi
        cache.menu.size.h = cache.menu.size.default.h * dpi
    end, true)

    color_print({255, 255, 255, "["}, {149, 162, 255, lua_name }, {255, 255, 255, "]"}, " Initialized")

    table.insert(cache.config.presets, {
        name = "Default Config",
        config = "W1siZmFsc2UiLCIwIiwiT2ZmIiwiMCIsIk9mZiIsIk9mZiIsIjAiLCJPZmYiLCIwIiwiMiIsIjAiLCIwIiwiT2ZmIiwiZmFsc2UiLCJmYWxzZSIsIjAiLCJTdGF0aWMiLCJMb2NhbCBWaWV3IiwiMCIsIk9mZiIsIjAiLCIyIiwiT2ZmIiwiMCIsImZhbHNlIiwiMCIsIlN0YXRpYyIsIjAiLCIwIiwiMSIsImZhbHNlIiwiU3RhdGljIiwidHJ1ZSIsIjAiLCJEb3duIiwiMCIsIk9mZiIsIk9mZiIsIjAiLCJSYW5kb20iLCIwIiwiMiIsIjAiLCIwIiwiT2ZmIiwidHJ1ZSIsImZhbHNlIiwiMCIsIkRlbGF5ZWQiLCJBdCBUYXJnZXRzIiwiMCIsIk9mZiIsIi0zNiIsIjYiLCIxODAiLCIwIiwiZmFsc2UiLCIwIiwiU3RhdGljIiwiMCIsIjUyIiwiLTEiLCJmYWxzZSIsIlN0YXRpYyIsInRydWUiLCIwIiwiRG93biIsIjAiLCJPZmYiLCJPZmYiLCIwIiwiUmFuZG9tIiwiMCIsIjIiLCIwIiwiLTEzNSIsIk9mZiIsInRydWUiLCJmYWxzZSIsIjAiLCJEZWxheWVkIiwiQXQgVGFyZ2V0cyIsIjAiLCJTcGluIiwiLTQyIiwiNSIsIjE4MCIsIjAiLCJmYWxzZSIsIjAiLCJTdGF0aWMiLCIwIiwiMzgiLCItMSIsImZhbHNlIiwiU3RhdGljIiwidHJ1ZSIsIi0yNiIsIkRvd24iLCIwIiwiT2ZmIiwiT2ZmIiwiMCIsIk9mZiIsIjAiLCIyIiwiMCIsIjAiLCJPZmYiLCJmYWxzZSIsImZhbHNlIiwiMCIsIkRlbGF5ZWQiLCJBdCBUYXJnZXRzIiwiMCIsIk9mZiIsIjUiLCI4IiwiMTgwIiwiMjYiLCJmYWxzZSIsIjAiLCJTdGF0aWMiLCIwIiwiLTEiLCItMSIsImZhbHNlIiwiU3RhdGljIiwidHJ1ZSIsIjAiLCJEb3duIiwiMCIsIk9mZiIsIk9mZiIsIjAiLCJPZmYiLCIwIiwiMiIsIjAiLCIwIiwiT2ZmIiwiZmFsc2UiLCJmYWxzZSIsIjAiLCJEZWxheWVkIiwiQXQgVGFyZ2V0cyIsIjAiLCJPZmYiLCItMzMiLCI4IiwiMTgwIiwiMCIsImZhbHNlIiwiMCIsIlN0YXRpYyIsIjAiLCI1MiIsIi0xIiwiZmFsc2UiLCJTdGF0aWMiLCJ0cnVlIiwiMCIsIkRvd24iLCIwIiwiT2ZmIiwiT2ZmIiwiMCIsIlJhbmRvbSIsIjAiLCIyIiwiMCIsIi0xMTQiLCJPZmYiLCJ0cnVlIiwiZmFsc2UiLCIwIiwiRGVsYXllZCIsIkF0IFRhcmdldHMiLCIwIiwiU3BpbiIsIi0yNyIsIjYiLCIxODAiLCIwIiwiZmFsc2UiLCIwIiwiU3RhdGljIiwiMCIsIjMyIiwiLTEiLCJmYWxzZSIsIlN0YXRpYyIsInRydWUiLCIwIiwiRG93biIsIjE2MyIsIk9mZiIsIkNlbnRlciIsIjAiLCJSYW5kb20iLCIwIiwiMiIsIjAiLCIwIiwiT2ZmIiwidHJ1ZSIsImZhbHNlIiwiMCIsIkRlbGF5ZWQiLCJBdCBUYXJnZXRzIiwiMCIsIk9mZiIsIi00OSIsIjUiLCIxODAiLCIwIiwiZmFsc2UiLCIwIiwiU3RhdGljIiwiMCIsIjMzIiwiLTEiLCJmYWxzZSIsIlN0YXRpYyIsInRydWUiLCIwIiwiRG93biIsIjAiLCJPZmYiLCJPZmYiLCIwIiwiT2ZmIiwiMCIsIjIiLCIwIiwiMCIsIk9mZiIsImZhbHNlIiwiZmFsc2UiLCIwIiwiRGVsYXllZCIsIkF0IFRhcmdldHMiLCIwIiwiT2ZmIiwiLTI2IiwiNiIsIjE4MCIsIjAiLCJmYWxzZSIsIjAiLCJTdGF0aWMiLCIwIiwiMzgiLCItMSIsImZhbHNlIiwiU3RhdGljIiwidHJ1ZSIsIjAiLCJEb3duIiwiMCIsIk9mZiIsIk9mZiIsIjAiLCJPZmYiLCIwIiwiMiIsIjAiLCIwIiwiT2ZmIiwiZmFsc2UiLCJmYWxzZSIsIjAiLCJEZWxheWVkIiwiQXQgVGFyZ2V0cyIsIjAiLCJPZmYiLCIzIiwiOCIsIjE4MCIsIjAiLCJmYWxzZSIsIjAiLCJTdGF0aWMiLCIwIiwiLTgiLCItMTE0IiwiZmFsc2UiLCJTdGF0aWMiLCJ0cnVlIiwiMCIsIkRvd24iLCItMTA4IiwiT2ZmIiwiU2tpdHRlciIsIjAiLCJVcCIsIjAiLCIyIiwiMCIsIjAiLCJPZmYiLCJ0cnVlIiwiZmFsc2UiLCIwIiwiU3RhdGljIiwiQXQgVGFyZ2V0cyIsIjAiLCIxODAiLCIwIiwiMiIsIjE4MCIsIjAiLCJmYWxzZSIsIjAiLCJTdGF0aWMiLCIwIiwiMCIsIi0xIiwiZmFsc2UiLCJTdGF0aWMiXSxbInRydWUiLCJ0cnVlIiwidHJ1ZSIsInRydWUiLCJ0cnVlIiwiZmFsc2UiLCJmYWxzZSIsImZhbHNlIiwiZmFsc2UiLCJmYWxzZSIsImZhbHNlIl0sWyJaZXJvIFBpdGNoIE9uIExhbmQsU3RhdGljIExlZ3MgSW4gQWlyLExlZ3MgQnJlYWtlcixCb2R5IExlYW4iLCItIl0sWyJGYWRlIiwiMTQ5IiwidHJ1ZSIsImZhbHNlIl1d"
    })

    if database.read(cache.config.database.configs) == nil then
        database.write(cache.config.database.configs, {})
    end

    ui.update(cache.ui.config.list, get_config_list())
    ui.set(cache.ui.config.name, #database.read(cache.config.database.configs) == 0 and "" or database.read(cache.config.database.configs)[ui.get(cache.ui.config.list) + 1].name)

    ui.set_callback(cache.ui.config.list, function(value)
        local name = ""
        local configs = get_config_list()
        name = configs[ui.get(value) + 1] or ""
        ui.set(cache.ui.config.name, name)
    end)

    ui.set_callback(cache.ui.config.load, function()
        local name = ui.get(cache.ui.config.name)
        if name == "" then return end

        local protected = function()
            load_config(get_config(name).config)
        end

        if pcall(protected) then
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Config successfully loaded")
        else
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Failed to load the config")
        end
    end)

    ui.set_callback(cache.ui.config.save, function()
        local name = ui.get(cache.ui.config.name)
        if name == "" then return end
    
        if name:match("[^%w]") ~= nil then
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Failed to get config char")
            return
        end
    
        local protected = function()
            save_config(name)
        end
    
        if pcall(protected) then
            ui.update(cache.ui.config.list, get_config_list())
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Config successfully saved")
        else
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Failed to save the config")
        end
    end)

    ui.set_callback(cache.ui.config.delete, function()
        local name = ui.get(cache.ui.config.name)
        if name == "" then return end

        if delete_config(name) == false then
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Failed to delete config")
            ui.update(cache.ui.config.list, get_config_list())
            return
        end
        
        local protected = function()
            delete_config(name)
        end
    
        if pcall(protected) then
            ui.update(cache.ui.config.list, get_config_list())
            ui.set(cache.ui.config.list, #database.read(cache.config.database.configs) - #database.read(cache.config.database.configs))
            ui.set(cache.ui.config.name, #database.read(cache.config.database.configs) == 0 and "" or get_config_list()[#database.read(cache.config.database.configs) - #database.read(cache.config.database.configs) + 1])
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Config successfully deleted")
        else
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Failed to delete config")
        end
    end)

    ui.set_callback(cache.ui.config.import, function()
        local protected = function()
            load_config(library.base64.decode(library.clipboard.get()))
        end
    
        if pcall(protected) then
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Config successfully imported")
        else
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Failed to import config")
        end
    end)

    ui.set_callback(cache.ui.config.export, function()
        local protected = function()
            library.clipboard.set(library.base64.encode(export_config()))
        end
    
        if pcall(protected) then
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Config successfully exported")
        else
            color_print({255, 255, 255, "["}, {149, 162, 255, lua_name}, {255, 255, 255, "]"}, " Failed to export config")
        end
    end)
    
    -- antiaim
    for index, value in pairs(cache.ui.anti_aim.elements) do
        if type(value) == "table" then
            for i, v in pairs(value) do
                if ui.type(v) ~= "button" and ui.type(v) ~= "multiselect" then
                    table.insert(cache.config.cfg_ui.anti_aim, v)
                end
            end
        end
    end

    -- misc
    table.insert(cache.config.cfg_ui.misc, cache.ui.misc.clantag)
    table.insert(cache.config.cfg_ui.misc, cache.ui.misc.killsay)
    table.insert(cache.config.cfg_ui.misc, cache.ui.misc.anti_knife)
    table.insert(cache.config.cfg_ui.misc, cache.ui.misc.safe_knife_taser)
    table.insert(cache.config.cfg_ui.misc, cache.ui.misc.keys)
    table.insert(cache.config.cfg_ui.misc, cache.ui.misc.freestanding)
    table.insert(cache.config.cfg_ui.misc, cache.ui.misc.legit_aa_key)
    table.insert(cache.config.cfg_ui.misc, cache.ui.misc.manual_left)
    table.insert(cache.config.cfg_ui.misc, cache.ui.misc.manual_right)
    table.insert(cache.config.cfg_ui.misc, cache.ui.misc.manual_forward)
    table.insert(cache.config.cfg_ui.misc, cache.ui.misc.edgeyaw)

    -- misc tables
    table.insert(cache.config.cfg_ui.misc_tables, cache.ui.misc.animations)
    table.insert(cache.config.cfg_ui.misc_tables, cache.ui.misc.freestanding_disablers)

    -- visuals
    table.insert(cache.config.cfg_ui.visuals, cache.ui.visuals.indicator)
    table.insert(cache.config.cfg_ui.visuals, cache.ui.visuals.indicator_color)
    table.insert(cache.config.cfg_ui.visuals, cache.ui.visuals.min_dmg_indicator)
    table.insert(cache.config.cfg_ui.visuals, cache.ui.visuals.manual_indicator)
end

initialize()
