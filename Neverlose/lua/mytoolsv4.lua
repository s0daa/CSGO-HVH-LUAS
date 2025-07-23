-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local l_world_to_screen_0 = render.world_to_screen;
local _ = rage.exploit;
local l_get_binds_0 = ui.get_binds;
local l_get_alpha_0 = ui.get_alpha;
local _ = entity.get_players;
local _ = entity.get;
local _ = entity.get_entities;
local _ = entity.get_game_rules;
local _ = common.set_clan_tag;
local _ = common.is_button_down;
local l_get_username_0 = common.get_username;
local _ = common.get_date;
local l_cast_0 = ffi.cast;
local _ = ffi.typeof;
local _ = render.gradient;
local l_text_0 = render.text;
local l_texture_0 = render.texture;
local l_rect_outline_0 = render.rect_outline;
local _ = render.rect;
local l_get_local_player_0 = entity.get_local_player;
local l_create_0 = ui.create;
local l_get_style_0 = ui.get_style;
local _ = math.floor;
local _ = math.abs;
local _ = math.max;
local _ = math.ceil;
local _ = math.min;
local l_random_0 = math.random;
local _ = utils.trace_bullet;
local l_screen_size_0 = render.screen_size;
local _ = render.load_font;
local _ = render.load_image_from_file;
local l_measure_text_0 = render.measure_text;
local _ = render.poly;
local _ = render.poly_blur;
local l_add_notify_0 = common.add_notify;
local _ = common.add_event;
local _ = utils.console_exec;
local _ = utils.execute_after;
local l_create_interface_0 = utils.create_interface;
local l_trace_line_0 = utils.trace_line;
local l_find_0 = ui.find;
local _ = entity.get_threat;
local l_format_0 = string.format;
local _ = nil;
local l_get_player_resource_0 = entity.get_player_resource;
local l_get_unixtime_0 = common.get_unixtime;
local l_insert_0 = table.insert;
local l_clipboard_0 = require("neverlose/clipboard");
local l_base64_0 = require("neverlose/base64");
local l_system_0 = require("neverlose/drag_system");
local l_smoothy_0 = require("neverlose/smoothy");
local l_defensive_0 = require("neverlose/get_defensive");
local l_md5_0 = require("neverlose/md5");
local _ = require("neverlose/inspect");
local l_events_0 = require("neverlose/events");
local _ = require("table.clear");
local _ = nil;
local _ = require("neverlose/websockets");
local v59 = require("neverlose/sec-base64");
local l_md5_1 = require("neverlose/md5");
local v61 = {};
local v62 = "fnaymemishauwu";
local function v67(v63, v64)
    for v65, v66 in pairs(v64) do
        v63[v65] = v66;
    end;
    return v63;
end;
local function v75(v68)
    local v69 = {};
    for v70 in pairs(v68) do
        v69[#v69 + 1] = v70;
    end;
    table.sort(v69);
    local v71 = "";
    for _, v73 in ipairs(v69) do
        local v74 = tostring(v73);
        v71 = v71 .. v74 .. tostring(v68[v74]);
    end;
    return v71;
end;
do
    local l_v59_0, l_l_md5_1_0, l_v62_0, l_v75_0 = v59, l_md5_1, v62, v75;
    local function _(v80)
        -- upvalues: l_v75_0 (ref), l_v62_0 (ref), l_l_md5_1_0 (ref)
        local v81 = l_v75_0(v80) .. l_v62_0;
        if not v80.signature then
            v80.signature = l_l_md5_1_0.sumhexa(v81);
        end;
        return json.stringify(v80);
    end;
    local v83 = nil;
    local v84 = nil;
    local function v94(v85)
        local v86 = "6a 75 73 74 73 69 6d 70 6c 65 74 65 78 74";
        local v87 = #v85;
        local v88 = #v86;
        local v89 = ffi.new("char[?]", v87 + 1);
        local v90 = ffi.new("char[?]", v88 + 1);
        local l_status_0, _ = pcall(function()
            return string.dump(ffi.copy);
        end);
        if l_status_0 then
            print_error("You are not allowed to edit FFI Struct.");
            return;
        else
            ffi.copy(v89, v85);
            ffi.copy(v90, v86);
            for v93 = 0, v87 - 1 do
                v89[v93] = bit.bxor(v89[v93], v90[v93 % v88]);
            end;
            return ffi.string(v89, v87);
        end;
    end;
    do
        local l_v94_0 = v94;
        v83 = function(v96)
            -- upvalues: l_v59_0 (ref), l_v94_0 (ref)
            return tostring(l_v59_0.encode(l_v94_0(v96)));
        end;
        v84 = function(v97)
            -- upvalues: l_v94_0 (ref), l_v59_0 (ref)
            return tostring(l_v94_0(l_v59_0.decode(v97)));
        end;
    end;
end;
(function()
    -- upvalues: l_get_style_0 (ref)
    cvar.clear:call();
    print_raw("\a" .. l_get_style_0("Link Active"):to_hex() .. "mytools \a85858DFF\194\183 \aDEFAULTWelcome, " .. common.get_username() .. "!");
end)();
ffi.cdef("    typedef void*(__thiscall* get_client_entity_t)(void*, int);\n\n    typedef struct {\n        char  pad_0000[20];\n        int m_nOrder; //0x0014\n        int m_nSequence; //0x0018\n        float m_flPrevCycle; //0x001C\n        float m_flWeight; //0x0020\n        float m_flWeightDeltaRate; //0x0024\n        float m_flPlaybackRate; //0x0028\n        float m_flCycle; //0x002C\n        void *m_pOwner; //0x0030\n        char  pad_0038[4]; //0x0034\n    } c_animlayers;\n");
v59 = function(v98, v99)
    return function(...)
        -- upvalues: v98 (ref), v99 (ref)
        return v98(v99, ...);
    end;
end;
l_md5_1 = function(v100, v101, v102, v103, v104, v105, v106, v107, v108)
    local v109 = "";
    local v110 = #v108 - 1;
    local v111 = (v104 - v100) / v110;
    local v112 = (v105 - v101) / v110;
    local v113 = (v106 - v102) / v110;
    local v114 = (v107 - v103) / v110;
    for v115 = 1, v110 + 1 do
        v109 = v109 .. ("\a%02x%02x%02x%02x%s"):format(v100, v101, v102, v103, v108:sub(v115, v115));
        v100 = v100 + v111;
        v101 = v101 + v112;
        v102 = v102 + v113;
        v103 = v103 + v114;
    end;
    return v109;
end;
v61 = function(v116, v117, v118)
    local l_v116_0 = v116;
    if l_v116_0 < v117 and v117 then
        l_v116_0 = v117;
    end;
    if v118 < l_v116_0 and v118 then
        l_v116_0 = v118;
    end;
    return l_v116_0;
end;
lerp = function(v120, v121, v122)
    return v121 * (1 - v120) + v122 * v120;
end;
contains = function(v123, v124)
    for v125 = 1, #v123 do
        if v123[v125] == v124 then
            return true;
        end;
    end;
end;
v62 = function(v126, v127)
    for _, v129 in pairs(v126) do
        if v127 == v129 then
            return true;
        end;
    end;
    return false;
end;
files.create_folder("nl/scripts/mytools");
v67 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface("client.dll", "VClientEntityList003"));
v75 = v59(ffi.cast("get_client_entity_t", v67[0][3]), v67);
local v130 = ffi.cast(ffi.typeof("void***"), utils.create_interface("engine.dll", "VEngineClient014"));
local v131 = ffi.cast(ffi.typeof("bool(__thiscall*)(void*)"), v130[0][11]);
local v132 = render.load_font("Calibri Bold", vector(25, 22, -1), "a, d");
local v133 = render.load_font("Verdana", 20, "a");
local _ = render.load_font("Verdana", 13, "a, d, b");
ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set("Quick Switch", "Auto Pistols");
local v135 = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):get();
local v136 = l_get_style_0("Link Active"):to_hex();
local _ = l_get_style_0("Link"):to_hex();
local v138 = {};
local v139 = l_smoothy_0.new(anim_tbl);
local _ = {};
local v141 = {};
local v142 = {};
local v143 = {};
check_windows = function()
    -- upvalues: v143 (ref), v142 (ref)
    v143 = {};
    for v144 = 1, 4 do
        if ui.find("Miscellaneous", "Main", "Other", "Windows"):get()[v144] ~= nil and not contains(v142, ui.find("Miscellaneous", "Main", "Other", "Windows"):get()[v144]) then
            table.insert(v143, ui.find("Miscellaneous", "Main", "Other", "Windows"):get()[v144]);
        end;
    end;
    ui.find("Miscellaneous", "Main", "Other", "Windows"):set(v143);
end;
v141.math_breathe = function(v145, v146)
    return math.abs(math.sin(globals.realtime * (v146 or 1) % math.pi + (v145 or 0)));
end;
v141.typing_text = function(v147, v148)
    -- upvalues: l_format_0 (ref)
    local v149 = 0;
    length = #v147:gsub("[\128-\191]", "");
    num = v149;
    result = "";
    for v150 in v147:gmatch(".[\128-\191]*") do
        num = num + 1;
        factor = num / length;
        result = l_format_0("%s\a%s%s", result, v148(num, length, v150, factor):to_hex(), v150);
    end;
    return result;
end;
v141.gradient_text = function(v151, v152, v153)
    -- upvalues: v141 (ref)
    return v141.typing_text(v151, function(_, _, _, v157)
        -- upvalues: v152 (ref), v153 (ref)
        return v152:lerp(v153, v157);
    end);
end;
v141.gradient = function(v158, v159, v160, v161)
    -- upvalues: v141 (ref)
    return v141.typing_text(v158, function(_, _, _, v165)
        -- upvalues: v141 (ref), v161 (ref), v159 (ref), v160 (ref)
        interpolation = v141.math_breathe(v165, v161);
        return v159:lerp(v160, interpolation);
    end);
end;
v141.static_gradient = function(v166, v167, v168)
    -- upvalues: v141 (ref)
    return v141.gradient_text(v166, v167, v168);
end;
local function v177(v169, v170, v171, v172, v173, ...)
    -- upvalues: v138 (ref), v139 (ref), l_smoothy_0 (ref)
    local _ = table.concat({
        ...
    });
    if v138[v169] == nil then
        v138[v169] = 0;
        v139 = l_smoothy_0.new(v138);
    end;
    local v175 = v139(0.1, {
        [v169] = render.measure_text(v171, nil, ...)
    })[v169];
    local v176 = render.measure_text(v171, nil, ...);
    render.push_clip_rect(vector(v170.x - v176.x, v170.y - v175.y / 2), vector(v170.x + v175.x / 2, v170.y + v175.y / 2), true);
    render.text(v171, vector(v170.x - v175.x / 2, v170.y - v175.y / 2), v172, v173, ...);
    render.pop_clip_rect();
end;
local function v179(v178)
    if type(getmetatable(v178)) == "table" and v178.__type then
        return v178.__type.name:lower();
    else
        if type(v178) == "boolean" then
            v178 = v178 and 1 or 0;
        end;
        return type(v178);
    end;
end;
local v317 = new_class():struct("cheat")({
    version = "Stable", 
    screen_size = l_screen_size_0(), 
    username = l_get_username_0()
}):struct("impt")({
    play_sound = function(v180, v181)
        -- upvalues: l_cast_0 (ref), l_create_interface_0 (ref)
        local v182 = l_cast_0("void***", l_create_interface_0("engine.dll", "IEngineSoundClient003")) or error("Failed to find IEngineSoundClient003!");
        return l_cast_0("void(__thiscall*)(void*, const char*, float, int, int, float)", v182[0][12])(v182, v180, v181, 100, 0, 0);
    end
}):struct("menu")({
    var_update = {}, 
    init = function(v183)
        -- upvalues: l_create_0 (ref), l_events_0 (ref), l_get_style_0 (ref), l_add_notify_0 (ref), l_get_alpha_0 (ref), v141 (ref), l_screen_size_0 (ref)
        local v184 = l_create_0("General", "Tabs");
        local v185 = l_create_0("General", "Info", 2);
        local v186 = l_create_0("General", "Settings", 1);
        local v187 = l_create_0("General", "Links", 2);
        local v188 = l_create_0("General", "Local Presets", 1);
        local v189 = l_create_0("General", "Local Configs", 1);
        local v190 = l_create_0("General", "Cloud Configs", 2);
        local v191 = l_create_0("General", "Cheat Additionals", 2);
        local v192 = l_create_0("General", "AA Misc", 1);
        local v193 = l_create_0("General", "Anti Aim Settings", 2);
        local v194 = l_create_0("General", "Conditions", 2);
        local v195 = l_create_0("General", "Misc", 2);
        local v196 = l_create_0("General", "Rage Bot", 1);
        local v197 = l_create_0("General", "Indicators", 2);
        local v198 = l_create_0("General", "Other", 1);
        v185:label("\a{Link Active}\239\128\135   \aDEFAULTWelcome, \a{Link Active}" .. common.get_username() .. "!");
        v185:label("\a{Link Active}\239\132\166   \aDEFAULTScript Build: \a{Link Active}" .. v183.cheat.version .. "");
        v185:label("\a{Link Active}\239\132\161   \aDEFAULTLast Update: \a{Link Active}01.05.2025 11:23 GMT+3");
        onlineUsers = v185:label("\a{Link Active}\239\131\128   \aDEFAULTOnline Users: \a{Link Active}Connecting...");
        l_events_0.pre_render:set(function()
            -- upvalues: l_get_style_0 (ref), v183 (ref), l_events_0 (ref)
            local v199 = {
                active_color = l_get_style_0()["Link Active"], 
                link = l_get_style_0().Link
            };
            if v199.link ~= v183.var_update.link or v199.active_color ~= v183.var_update.active_color then
                l_events_0.on_style_change:call();
            end;
            v183.var_update = v199;
        end);
        local v200 = nil;
        v200 = {};
        local v201 = files.read("nl/scripts/mytools/mytools.config");
        do
            local l_v201_0 = v201;
            local l_status_1, l_result_1 = pcall(function()
                -- upvalues: l_v201_0 (ref)
                return json.parse(l_v201_0);
            end);
            if not l_status_1 or #l_result_1 == 0 then
                l_result_1 = {
                    [1] = "\a{Link Active}Mytools. \aCBC9C9FFCreate preset."
                };
            else
                local v205 = {};
                for v206 = 1, #l_result_1 do
                    table.insert(v205, l_result_1[v206].name);
                end;
                l_result_1 = v205;
            end;
            v184:list("", {
                [1] = "\239\134\146   Information", 
                [2] = "\239\134\146   Configurations", 
                [3] = "\239\148\133   Anti-Aims", 
                [4] = "\239\148\191   Visuals", 
                [5] = "\239\148\191     \aDEFAULTMiscellaneous"
            }):set_callback(function(v207)
                -- upvalues: v191 (ref), v189 (ref), v188 (ref), v185 (ref), v187 (ref), v192 (ref), v193 (ref), v194 (ref), v195 (ref), v196 (ref), v197 (ref), v198 (ref), v190 (ref), v186 (ref)
                if v207:get() == 1 then
                    v207:update({
                        [1] = "\a{Link Active}\239\131\171      \aDEFAULTInformation", 
                        [2] = "\239\129\187     Configurations", 
                        [3] = "\239\148\133    Anti-Aims", 
                        [4] = "\239\148\191     Visuals", 
                        [5] = "\239\130\133    \aDEFAULTMiscellaneous"
                    });
                    v191:visibility(false);
                    v189:visibility(false);
                    v188:visibility(false);
                    v185:visibility(true);
                    v187:visibility(true);
                    v192:visibility(false);
                    v193:visibility(false);
                    v194:visibility(false);
                    v195:visibility(false);
                    v196:visibility(false);
                    v197:visibility(false);
                    v198:visibility(false);
                    v190:visibility(false);
                    v186:visibility(true);
                elseif v207:get() == 2 then
                    v207:update({
                        [1] = "\239\131\171      Information", 
                        [2] = "\a{Link Active}\239\129\187     \aDEFAULTConfigurations", 
                        [3] = "\239\148\133    Anti-Aims", 
                        [4] = "\239\148\191     Visuals", 
                        [5] = "\239\130\133    \aDEFAULTMiscellaneous"
                    });
                    v191:visibility(true);
                    v189:visibility(true);
                    v188:visibility(true);
                    v185:visibility(false);
                    v187:visibility(false);
                    v192:visibility(false);
                    v193:visibility(false);
                    v194:visibility(false);
                    v195:visibility(false);
                    v196:visibility(false);
                    v197:visibility(false);
                    v198:visibility(false);
                    v190:visibility(true);
                    v186:visibility(false);
                elseif v207:get() == 3 then
                    v207:update({
                        [1] = "\239\131\171      Information", 
                        [2] = "\239\129\187     Configurations", 
                        [3] = "\a{Link Active}\239\148\133    \aDEFAULTAnti-Aims", 
                        [4] = "\239\148\191     Visuals", 
                        [5] = "\239\130\133    \aDEFAULTMiscellaneous"
                    });
                    v191:visibility(false);
                    v189:visibility(false);
                    v188:visibility(false);
                    v185:visibility(false);
                    v187:visibility(false);
                    v192:visibility(true);
                    v193:visibility(true);
                    v194:visibility(true);
                    v195:visibility(false);
                    v196:visibility(false);
                    v197:visibility(false);
                    v198:visibility(false);
                    v190:visibility(false);
                    v186:visibility(false);
                elseif v207:get() == 4 then
                    v207:update({
                        [1] = "\239\131\171      Information", 
                        [2] = "\239\129\187     Configurations", 
                        [3] = "\239\148\133    Anti-Aims", 
                        [4] = "\a{Link Active}\239\148\191     \aDEFAULTVisuals", 
                        [5] = "\239\130\133    \aDEFAULTMiscellaneous"
                    });
                    v191:visibility(false);
                    v189:visibility(false);
                    v188:visibility(false);
                    v185:visibility(false);
                    v187:visibility(false);
                    v192:visibility(false);
                    v193:visibility(false);
                    v194:visibility(false);
                    v195:visibility(false);
                    v196:visibility(false);
                    v197:visibility(true);
                    v198:visibility(true);
                    v190:visibility(false);
                    v186:visibility(false);
                elseif v207:get() == 5 then
                    v207:update({
                        [1] = "\239\131\171      Information", 
                        [2] = "\239\129\187     Configurations", 
                        [3] = "\239\148\133    Anti-Aims", 
                        [4] = "\239\148\191     \aDEFAULTVisuals", 
                        [5] = "\a{Link Active}\239\130\133    \aDEFAULTMiscellaneous"
                    });
                    v191:visibility(false);
                    v189:visibility(false);
                    v188:visibility(false);
                    v185:visibility(false);
                    v187:visibility(false);
                    v192:visibility(false);
                    v193:visibility(false);
                    v194:visibility(false);
                    v195:visibility(true);
                    v196:visibility(true);
                    v197:visibility(false);
                    v198:visibility(false);
                    v190:visibility(false);
                    v186:visibility(false);
                end;
            end, true);
            local _ = {};
            v200.preset_list = v188:list("", l_result_1);
            v200.preset_name = v188:input("Name: ");
            v200.save_preset = v188:button("\a{Link Active}\239\131\135", function()
                -- upvalues: v183 (ref)
                v183.config_system:save();
            end, true);
            v200.delete_preset = v188:button("\a{Link Active}\239\139\173", function()
                -- upvalues: v183 (ref)
                v183.config_system:delete();
            end, true);
            v200.load_preset = v188:button("            Load            ", function()
                -- upvalues: v183 (ref)
                v183.config_system:load();
            end);
            v200.import_preset = v188:button("\a{Link Active}\239\149\175", function()
                -- upvalues: v183 (ref)
                v183.config_system:import();
            end, true);
            v200.export_preset = v188:button("\a{Link Active}\239\149\174", function()
                -- upvalues: l_add_notify_0 (ref), v183 (ref)
                l_add_notify_0("mytools", "\a89F2CAFF\226\156\148\239\184\143 Successfully Exported Your Config");
                v183.impt.play_sound("physics/wood/wood_plank_impact_hard4.wav", 0.12);
                v183.config_system:export();
            end, true);
            skip_data = v189:selectable("Skip import data:", {
                [1] = "Anti-Aims", 
                [2] = "Ragebot", 
                [3] = "Misc/Vis"
            });
            skip_data:tooltip("Does not import the tabs that are selected.");
            v200.import_preset1 = v189:button("\a{Link Active}\239\149\175  \aDEFAULTImport", function()
                -- upvalues: v183 (ref)
                v183.config_system:import();
            end, true);
            v200.export_preset1 = v189:button("\a{Link Active}\239\149\174  \aDEFAULTExport", function()
                -- upvalues: l_add_notify_0 (ref), v183 (ref)
                l_add_notify_0("mytools", "\a89F2CAFF\226\156\148\239\184\143 Successfully Exported Your Config");
                v183.impt.play_sound("physics/wood/wood_plank_impact_hard4.wav", 0.12);
                v183.config_system:export();
            end, true);
            v200.load_defauls = v189:button("\240\159\170\144 \aFFFFFFFFDefault", function()
                -- upvalues: v183 (ref)
                v183.config_system:import("W3sibmFtZSI6IlNsaWRpbmcgT24gU2xvdy1XYWxrIiwidGFiIjoiYW50aWFpbXMiLCJ2YXIiOnRydWV9LHsibmFtZSI6Ik1vdmUgTGVhbiIsInRhYiI6ImFudGlhaW1zIiwidmFyIjpmYWxzZX0seyJuYW1lIjoiXHUwMDA3e0xpbmsgQWN0aXZlfe6SviAgIFx1MDAwN0RFRkFVTFRNYW51YWwgQUEiLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6IkRpc2FibGVkIn0seyJuYW1lIjoiTW92ZSBMZWFuIEZvcmNlIiwidGFiIjoiYW50aWFpbXMiLCJ2YXIiOjAuMH0seyJuYW1lIjoiQ3VzdG9tIFBpdGNoIiwidGFiIjoiYW50aWFpbXMiLCJ2YXIiOjAuMH0seyJuYW1lIjoiW0F1dG9UUF0gRGVsYXkiLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6MS4wfSx7Im5hbWUiOiJDdXN0b20gWWF3IiwidGFiIjoiYW50aWFpbXMiLCJ2YXIiOjAuMH0seyJuYW1lIjoiQ3VycmVudCBDb25kaXRpb24iLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6IkFpciBDcm91Y2gifSx7Im5hbWUiOiJEaXNhYmxlcnMiLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6WyJNYW51YWxzIiwiR3JlbmFkZXMiXX0seyJuYW1lIjoiSW4gQWlyIiwidGFiIjoiYW50aWFpbXMiLCJ2YXIiOiJTdGF0aWMifSx7Im5hbWUiOiJPbiBHcm91bmQiLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6IkZvbGxvdyBEaXJlY3Rpb24ifSx7Im5hbWUiOiJFLVNwYW0gd2hpbGUgU2FmZSBIZWFkIiwidGFiIjoiYW50aWFpbXMiLCJ2YXIiOnRydWV9LHsibmFtZSI6Ilx1MDAwN3tMaW5rIEFjdGl2ZX3vh54gICBcdTAwMDdERUZBVUxURm9yY2UgQnJlYWsgTEMiLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6dHJ1ZX0seyJuYW1lIjoiXHUwMDA3e0xpbmsgQWN0aXZlfe+BhyAgIFx1MDAwN0RFRkFVTFRGcmVlc3RhbmRpbmciLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6ZmFsc2V9LHsibmFtZSI6IkNvbmRpdGlvbnMiLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6WyJJbiBBaXIiLCJTdGFuZGluZyIsIkNyb3VjaGluZyIsIkNyb3VjaCBNb3ZlIl19LHsibmFtZSI6IkJvZHkgRnJlZXN0YW5kaW5nIiwidGFiIjoiYW50aWFpbXMiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJZb3UgYXJlIHVzaW5nIGFuIGF1dG9tYXRpYyBwcmVzZXQsIHlvdSBkb24ndCBuZWVkIHRvIGFkanVzdCBpdC4gSnVzdCBwcmVzcyBpdCBhbmQgZ28gcGxheS4iLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6MjE3Mzk4NTE1Mi4wfSx7Im5hbWUiOiJcdTAwMDd7TGluayBBY3RpdmV97pK7ICAgXHUwMDA3REVGQVVMVERlZmVuc2l2ZSBBQSIsInRhYiI6ImFudGlhaW1zIiwidmFyIjp0cnVlfSx7Im5hbWUiOiJcdTAwMDd7TGluayBBY3RpdmV974SuICAgXHUwMDA3REVGQVVMVFR3ZWFrcyIsInRhYiI6ImFudGlhaW1zIiwidmFyIjpbIkJvbWJzaXRlIEUgRml4IiwiTGVnaXQgQUEiLCJEaXMuIEFBIG9uIFdhcm11cCIsIk5vIEZhbGwgRGFtYWdlIl19LHsibmFtZSI6IlR5cGUiLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6IlByZXNldHMifSx7Im5hbWUiOiJEaXNhYmxlIFlhdyBNb2QuIiwidGFiIjoiYW50aWFpbXMiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJcdTAwMDd7TGluayBBY3RpdmV974qaICAgXHUwMDA3REVGQVVMVEFuaW0uIEJyZWFrZXJzIiwidGFiIjoiYW50aWFpbXMiLCJ2YXIiOnRydWV9LHsibmFtZSI6IkRpc2FibGUgb24gTWFudWFscyIsInRhYiI6ImFudGlhaW1zIiwidmFyIjp0cnVlfSx7Im5hbWUiOiJQaXRjaCIsInRhYiI6ImFudGlhaW1zIiwidmFyIjoiU2VtaSBVcCJ9LHsibmFtZSI6IltBdXRvVFBdIFdlYXBvbnMiLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6W119LHsibmFtZSI6Ilx1MDAwN3tMaW5rIEFjdGl2ZX3vlIQgICBcdTAwMDdERUZBVUxUU2FmZSBIZWFkIiwidGFiIjoiYW50aWFpbXMiLCJ2YXIiOlsiQm9tYiIsIktuaWZlIC8gVGFzZXIiLCJGYWtlLUxhZyJdfSx7Im5hbWUiOiJEaXNhYmxlIFlhdyBNb2RpZmllcnMiLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6ZmFsc2V9LHsibmFtZSI6Ilx1MDAwN3tMaW5rIEFjdGl2ZX3vk78gICBcdTAwMDdERUZBVUxUTW9kZSIsInRhYiI6ImFudGlhaW1zIiwidmFyIjoiQ29uZGl0aW9uYWwifSx7Im5hbWUiOiJZYXciLCJ0YWIiOiJhbnRpYWltcyIsInZhciI6IlNwaW4ifSx7Im5hbWUiOiJBaXIiLCJ0YWIiOiJyYWdlYm90IiwidmFyIjo1NS4wfSx7Im5hbWUiOiJEaXNhYmxlIEdsb3ciLCJ0YWIiOiJyYWdlYm90IiwidmFyIjpmYWxzZX0seyJuYW1lIjoiVW5sb2NrIEZha2UgTGF0ZW5jeSIsInRhYiI6InJhZ2Vib3QiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJTY3JlZW4gTG9ncyBDb2xvciIsInRhYiI6InJhZ2Vib3QiLCJ2YXIiOiI5MDk3RkZGRiJ9LHsibmFtZSI6IlJldm9sdmVyIEhlbHBlciIsInRhYiI6InJhZ2Vib3QiLCJ2YXIiOnRydWV9LHsibmFtZSI6IkN1c3RvbSBFdmVudCBMb2dzIiwidGFiIjoicmFnZWJvdCIsInZhciI6dHJ1ZX0seyJuYW1lIjoiU2VsZWN0IExvZyIsInRhYiI6InJhZ2Vib3QiLCJ2YXIiOlsiQ29uc29sZSJdfSx7Im5hbWUiOiJObyBzY29wZSIsInRhYiI6InJhZ2Vib3QiLCJ2YXIiOjU1LjB9LHsibmFtZSI6IkNvbmRpdGlvbiIsInRhYiI6InJhZ2Vib3QiLCJ2YXIiOltdfSx7Im5hbWUiOiJIaXRjaGFuY2UgQWRkaXRpb25hbHMiLCJ0YWIiOiJyYWdlYm90IiwidmFyIjpmYWxzZX0seyJuYW1lIjoiUHVyY2hhc2UgTG9ncyIsInRhYiI6InJhZ2Vib3QiLCJ2YXIiOnRydWV9LHsibmFtZSI6IkFzcGVjdCBSYXRpbyIsInRhYiI6InZpc3VhbHMiLCJ2YXIiOjE1MC4wfSx7Im5hbWUiOiJTY29wZSBPdmVybGF5IiwidGFiIjoidmlzdWFscyIsInZhciI6ZmFsc2V9LHsibmFtZSI6IlNlbGVjdCBTdHlsZSIsInRhYiI6InZpc3VhbHMiLCJ2YXIiOiJEZWZhdWx0In0seyJuYW1lIjoiT24tU2NyZWVuIEluZGljYXRvcnMiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjpmYWxzZX0seyJuYW1lIjoiRXhjbHVkZSBMaW5lIiwidGFiIjoidmlzdWFscyIsInZhciI6W119LHsibmFtZSI6IkFpbWJvdCBNYXJrZXJzIiwidGFiIjoidmlzdWFscyIsInZhciI6dHJ1ZX0seyJuYW1lIjoiS2liaXQgSGl0IE1hcmtlciIsInRhYiI6InZpc3VhbHMiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJGb250IiwidGFiIjoidmlzdWFscyIsInZhciI6IkRlZmF1bHQifSx7Im5hbWUiOiJTY29wZSBHYXAiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjo3LjB9LHsibmFtZSI6Ik9UIERhbWFnZSBNYXJrZXIiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjp0cnVlfSx7Im5hbWUiOiJJbmRpY2F0b3IgQ29sb3IiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjoiRkZGRkZGRkYifSx7Im5hbWUiOiJDb25zb2xlIENvbG9yIENoYW5nZXIiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjpmYWxzZX0seyJuYW1lIjoiQnVpbGQgQ29sb3IiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjoiRDdBMzZGRkYifSx7Im5hbWUiOiJDb25zb2xlIENvbG9yIiwidGFiIjoidmlzdWFscyIsInZhciI6IkZGRkZGRkZGIn0seyJuYW1lIjoiR2xvdyBPZmZzZXQiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjo0MC4wfSx7Im5hbWUiOiJwb3N4ZG1nIiwidGFiIjoidmlzdWFscyIsInZhciI6OTY1LjB9LHsibmFtZSI6InBvc3lkbWciLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjo1MjUuMH0seyJuYW1lIjoiRGFtYWdlIEluZGljYXRvciIsInRhYiI6InZpc3VhbHMiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJEYW1hZ2UgRm9udCIsInRhYiI6InZpc3VhbHMiLCJ2YXIiOiJTbWFsbCJ9LHsibmFtZSI6IlNlbGVjdCIsInRhYiI6InZpc3VhbHMiLCJ2YXIiOiJEZWZhdWx0In0seyJuYW1lIjoiRGlzYWJsZSBEYW1hZ2UgQW5pbWF0aW9uIiwidGFiIjoidmlzdWFscyIsInZhciI6ZmFsc2V9LHsibmFtZSI6IlZlbG9jaXR5IEluZGljYXRvciIsInRhYiI6InZpc3VhbHMiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJTY29wZSBTaXplIiwidGFiIjoidmlzdWFscyIsInZhciI6MTA1LjB9LHsibmFtZSI6IlZlbG9jaXR5IENvbG9yIiwidGFiIjoidmlzdWFscyIsInZhciI6IjkxQjJFRkZGIn0seyJuYW1lIjoiU2NvcGUgQ29sb3IiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjoiRkZGRkZGRkYifSx7Im5hbWUiOiJwb3N4dmVsb2NpdHkiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjo5MDAuMH0seyJuYW1lIjoiV2lkZ2V0cyIsInRhYiI6InZpc3VhbHMiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJwb3N5dmVsb2NpdHkiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjoyNTAuMH0seyJuYW1lIjoiV2luZG93cyIsInRhYiI6InZpc3VhbHMiLCJ2YXIiOltdfSx7Im5hbWUiOiI1MDAkIEluZGljYXRvcnMiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjpbIkRvdWJsZSB0YXAiLCJEb3JtYW50IGFpbWJvdCIsIk1pbmltdW0gZGFtYWdlIiwiUGluZyBzcGlrZSIsIkZha2UgZHVjayIsIkZyZWVzdGFuZGluZyIsIkhpdCBQZXJjZW50YWdlIiwiQm9tYiBpbmZvIiwiQm9keSBhaW0iLCJIaWRlIHNob3RzIl19LHsibmFtZSI6IldpZGdldHMgQ29sb3IiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjoiOTY5NkZGRkYifSx7Im5hbWUiOiJwb3N4IiwidGFiIjoidmlzdWFscyIsInZhciI6MTUwLjB9LHsibmFtZSI6InBvc3kiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjoxNTAuMH0seyJuYW1lIjoicG9zeDEiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjoyNTAuMH0seyJuYW1lIjoicG9zeTEiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjoyNTAuMH0seyJuYW1lIjoiVmlld21vZGVsIENoYW5nZXIiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjpmYWxzZX0seyJuYW1lIjoiRk9WIiwidGFiIjoidmlzdWFscyIsInZhciI6NjguMH0seyJuYW1lIjoiT2Zmc2V0IFgiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjoyNS4wfSx7Im5hbWUiOiJPZmZzZXQgWSIsInRhYiI6InZpc3VhbHMiLCJ2YXIiOjAuMH0seyJuYW1lIjoiM0QgTWlzcyBNYXJrZXIiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjpmYWxzZX0seyJuYW1lIjoiT2Zmc2V0IFoiLCJ0YWIiOiJ2aXN1YWxzIiwidmFyIjotMTUuMH0seyJuYW1lIjoiVHJhc2ggVGFsayIsInRhYiI6Im1pc2MiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJVbm11dGUgU2lsZW5jZWQgUGxheWVycyIsInRhYiI6Im1pc2MiLCJ2YXIiOnRydWV9LHsibmFtZSI6IkdyZW5hZGUgUmVsZWFzZSIsInRhYiI6Im1pc2MiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJDbGFuIFRhZyIsInRhYiI6Im1pc2MiLCJ2YXIiOnRydWV9LHsibmFtZSI6Ik1pbi4gRGFtYWdlIiwidGFiIjoibWlzYyIsInZhciI6NTAuMH0seyJuYW1lIjoiTmFkZSBUaHJvdyBGaXgiLCJ0YWIiOiJtaXNjIiwidmFyIjp0cnVlfSx7Im5hbWUiOiJcdTAwMDd7TGluayBBY3RpdmV976CCICAgXHUwMDA3REVGQVVMVEVuYWJsZSBDaGVhdCBDb25maWcgU3RlYWxlciIsInRhYiI6Im1pc2MiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJEaXNhYmxlIG9uIFdhcm11cCIsInRhYiI6Im1pc2MiLCJ2YXIiOnRydWV9LHsibmFtZSI6Ilx1MDAwN0NDQ0M2RkZGRmxhc2ggSWNvbiBPbiBSb3VuZCBTdGFydCIsInRhYiI6Im1pc2MiLCJ2YXIiOnRydWV9LHsibmFtZSI6IkJvZHkgWWF3ICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJMZWZ0IExpbWl0ICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjYwLjB9LHsibmFtZSI6IlBpdGNoICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJEaXNhYmxlZCJ9LHsibmFtZSI6IkJhc2UgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkxvY2FsIFZpZXcifSx7Im5hbWUiOiJPZmZzZXQgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiJGYWtlIE9wdGlvbnMgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6W119LHsibmFtZSI6Ik9mZnNldCBSICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiRGVsYXkgdGlja3MgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MTIuMH0seyJuYW1lIjoiRnJlZXN0YW5kIERTICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJPZmYifSx7Im5hbWUiOiJZYXcgTW9kaWZpZXIgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkRpc2FibGVkIn0seyJuYW1lIjoiTW9kZSAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiU3RhdGljIn0seyJuYW1lIjoiSW52ZXJ0ZXIgQUEgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6ZmFsc2V9LHsibmFtZSI6IlNldHRpbmdzICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJEZWZhdWx0In0seyJuYW1lIjoiT2Zmc2V0ICMxICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiWWF3IE1vZGUgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkRlZmF1bHQifSx7Im5hbWUiOiJPZmZzZXQgIzIgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiIxIFdheSAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IkVuYWJsZSBDb25kaXRpb24gIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6dHJ1ZX0seyJuYW1lIjoiMiBXYXkgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiIzIFdheSAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IllhdyAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiRGlzYWJsZWQifSx7Im5hbWUiOiI0IFdheSAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IlJpZ2h0IExpbWl0ICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjYwLjB9LHsibmFtZSI6IjUgV2F5ICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiU3dhcCBjb21wYXRpYmxlIHdpdGggaW52ZXJ0ZXIgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6ZmFsc2V9LHsibmFtZSI6IkJvZHkgWWF3ICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjp0cnVlfSx7Im5hbWUiOiJMZWZ0IExpbWl0ICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjo2MC4wfSx7Im5hbWUiOiJQaXRjaCAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkRvd24ifSx7Im5hbWUiOiJCYXNlICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiQXQgVGFyZ2V0In0seyJuYW1lIjoiT2Zmc2V0ICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjotMjAuMH0seyJuYW1lIjoiRmFrZSBPcHRpb25zICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjpbXX0seyJuYW1lIjoiT2Zmc2V0IFIgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjI3LjB9LHsibmFtZSI6IkRlbGF5IHRpY2tzICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjo2LjB9LHsibmFtZSI6IkZyZWVzdGFuZCBEUyAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6Ik9mZiJ9LHsibmFtZSI6IllhdyBNb2RpZmllciAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkRpc2FibGVkIn0seyJuYW1lIjoiTW9kZSAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IlN0YXRpYyJ9LHsibmFtZSI6IkludmVydGVyIEFBICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjpmYWxzZX0seyJuYW1lIjoiU2V0dGluZ3MgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJEZWZhdWx0In0seyJuYW1lIjoiT2Zmc2V0ICMxICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IllhdyBNb2RlICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiRGVsYXllZCJ9LHsibmFtZSI6Ik9mZnNldCAjMiAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiIxIFdheSAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiJFbmFibGUgQ29uZGl0aW9uICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjp0cnVlfSx7Im5hbWUiOiIyIFdheSAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiIzIFdheSAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiJZYXcgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJCYWNrd2FyZCJ9LHsibmFtZSI6IjQgV2F5ICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IlJpZ2h0IExpbWl0ICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjo2MC4wfSx7Im5hbWUiOiI1IFdheSAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiJTd2FwIGNvbXBhdGlibGUgd2l0aCBpbnZlcnRlciAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6ZmFsc2V9LHsibmFtZSI6IkJvZHkgWWF3ICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6dHJ1ZX0seyJuYW1lIjoiTGVmdCBMaW1pdCAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjM2LjB9LHsibmFtZSI6IlBpdGNoICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkRvd24ifSx7Im5hbWUiOiJCYXNlICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkF0IFRhcmdldCJ9LHsibmFtZSI6Ik9mZnNldCAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOi02LjB9LHsibmFtZSI6IkZha2UgT3B0aW9ucyAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOlsiSml0dGVyIl19LHsibmFtZSI6Ik9mZnNldCBSICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MTAuMH0seyJuYW1lIjoiRGVsYXkgdGlja3MgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoxMi4wfSx7Im5hbWUiOiJGcmVlc3RhbmQgRFMgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiT2ZmIn0seyJuYW1lIjoiWWF3IE1vZGlmaWVyICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkNlbnRlciJ9LHsibmFtZSI6Ik1vZGUgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiU3RhdGljIn0seyJuYW1lIjoiSW52ZXJ0ZXIgQUEgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjpmYWxzZX0seyJuYW1lIjoiU2V0dGluZ3MgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiRGVmYXVsdCJ9LHsibmFtZSI6Ik9mZnNldCAjMSAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOi01OC4wfSx7Im5hbWUiOiJZYXcgTW9kZSAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJMZWZ0L1JpZ2h0In0seyJuYW1lIjoiT2Zmc2V0ICMyICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiIxIFdheSAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiRW5hYmxlIENvbmRpdGlvbiAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOnRydWV9LHsibmFtZSI6IjIgV2F5ICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiIzIFdheSAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiWWF3ICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkJhY2t3YXJkIn0seyJuYW1lIjoiNCBXYXkgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IlJpZ2h0IExpbWl0ICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MzYuMH0seyJuYW1lIjoiNSBXYXkgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IlN3YXAgY29tcGF0aWJsZSB3aXRoIGludmVydGVyICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6ZmFsc2V9LHsibmFtZSI6IkJvZHkgWWF3ICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOnRydWV9LHsibmFtZSI6IkxlZnQgTGltaXQgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6NTQuMH0seyJuYW1lIjoiUGl0Y2ggICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkRvd24ifSx7Im5hbWUiOiJCYXNlICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJBdCBUYXJnZXQifSx7Im5hbWUiOiJPZmZzZXQgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6LTMxLjB9LHsibmFtZSI6IkZha2UgT3B0aW9ucyAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjpbIkppdHRlciJdfSx7Im5hbWUiOiJPZmZzZXQgUiAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjo0NS4wfSx7Im5hbWUiOiJEZWxheSB0aWNrcyAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoxMi4wfSx7Im5hbWUiOiJGcmVlc3RhbmQgRFMgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6Ik9mZiJ9LHsibmFtZSI6IllhdyBNb2RpZmllciAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiQ2VudGVyIn0seyJuYW1lIjoiTW9kZSAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiU3RhdGljIn0seyJuYW1lIjoiSW52ZXJ0ZXIgQUEgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6ZmFsc2V9LHsibmFtZSI6IlNldHRpbmdzICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJEZWZhdWx0In0seyJuYW1lIjoiT2Zmc2V0ICMxICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiWWF3IE1vZGUgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkxlZnQvUmlnaHQifSx7Im5hbWUiOiJPZmZzZXQgIzIgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiIxIFdheSAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IkVuYWJsZSBDb25kaXRpb24gICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6dHJ1ZX0seyJuYW1lIjoiMiBXYXkgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiIzIFdheSAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IllhdyAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiQmFja3dhcmQifSx7Im5hbWUiOiI0IFdheSAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IlJpZ2h0IExpbWl0ICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjU0LjB9LHsibmFtZSI6IjUgV2F5ICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiU3dhcCBjb21wYXRpYmxlIHdpdGggaW52ZXJ0ZXIgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6ZmFsc2V9LHsibmFtZSI6IkJvZHkgWWF3ICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjp0cnVlfSx7Im5hbWUiOiJMZWZ0IExpbWl0ICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjo2MC4wfSx7Im5hbWUiOiJQaXRjaCAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkRvd24ifSx7Im5hbWUiOiJCYXNlICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiQXQgVGFyZ2V0In0seyJuYW1lIjoiT2Zmc2V0ICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjotNy4wfSx7Im5hbWUiOiJGYWtlIE9wdGlvbnMgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOlsiSml0dGVyIl19LHsibmFtZSI6Ik9mZnNldCBSICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IkRlbGF5IHRpY2tzICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoxMi4wfSx7Im5hbWUiOiJGcmVlc3RhbmQgRFMgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJPZmYifSx7Im5hbWUiOiJZYXcgTW9kaWZpZXIgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJDZW50ZXIifSx7Im5hbWUiOiJNb2RlICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiU3RhdGljIn0seyJuYW1lIjoiSW52ZXJ0ZXIgQUEgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJTZXR0aW5ncyAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkRlZmF1bHQifSx7Im5hbWUiOiJPZmZzZXQgIzEgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOi00OS4wfSx7Im5hbWUiOiJZYXcgTW9kZSAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkRlZmF1bHQifSx7Im5hbWUiOiJPZmZzZXQgIzIgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiMSBXYXkgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiRW5hYmxlIENvbmRpdGlvbiAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6dHJ1ZX0seyJuYW1lIjoiMiBXYXkgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiMyBXYXkgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiWWF3ICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiQmFja3dhcmQifSx7Im5hbWUiOiI0IFdheSAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiJSaWdodCBMaW1pdCAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6NjAuMH0seyJuYW1lIjoiNSBXYXkgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiU3dhcCBjb21wYXRpYmxlIHdpdGggaW52ZXJ0ZXIgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJCb2R5IFlhdyAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOnRydWV9LHsibmFtZSI6IkxlZnQgTGltaXQgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjo2MC4wfSx7Im5hbWUiOiJQaXRjaCAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJEb3duIn0seyJuYW1lIjoiQmFzZSAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJBdCBUYXJnZXQifSx7Im5hbWUiOiJPZmZzZXQgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjotNy4wfSx7Im5hbWUiOiJGYWtlIE9wdGlvbnMgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjpbIkppdHRlciJdfSx7Im5hbWUiOiJPZmZzZXQgUiAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiRGVsYXkgdGlja3MgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoxMi4wfSx7Im5hbWUiOiJGcmVlc3RhbmQgRFMgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiT2ZmIn0seyJuYW1lIjoiWWF3IE1vZGlmaWVyICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkNlbnRlciJ9LHsibmFtZSI6Ik1vZGUgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiU3RhdGljIn0seyJuYW1lIjoiSW52ZXJ0ZXIgQUEgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjpmYWxzZX0seyJuYW1lIjoiU2V0dGluZ3MgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiRGVmYXVsdCJ9LHsibmFtZSI6Ik9mZnNldCAjMSAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOi00OS4wfSx7Im5hbWUiOiJZYXcgTW9kZSAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJEZWZhdWx0In0seyJuYW1lIjoiT2Zmc2V0ICMyICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiIxIFdheSAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiRW5hYmxlIENvbmRpdGlvbiAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOnRydWV9LHsibmFtZSI6IjIgV2F5ICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiIzIFdheSAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiWWF3ICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkJhY2t3YXJkIn0seyJuYW1lIjoiNCBXYXkgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IlJpZ2h0IExpbWl0ICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6NjAuMH0seyJuYW1lIjoiNSBXYXkgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IlN3YXAgY29tcGF0aWJsZSB3aXRoIGludmVydGVyICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6ZmFsc2V9LHsibmFtZSI6IkJvZHkgWWF3ICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOnRydWV9LHsibmFtZSI6IkxlZnQgTGltaXQgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6NjAuMH0seyJuYW1lIjoiUGl0Y2ggICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkRvd24ifSx7Im5hbWUiOiJCYXNlICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJBdCBUYXJnZXQifSx7Im5hbWUiOiJPZmZzZXQgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6LTM2LjB9LHsibmFtZSI6IkZha2UgT3B0aW9ucyAgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjpbIkppdHRlciJdfSx7Im5hbWUiOiJPZmZzZXQgUiAgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoyOS4wfSx7Im5hbWUiOiJEZWxheSB0aWNrcyAgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoxMi4wfSx7Im5hbWUiOiJGcmVlc3RhbmQgRFMgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6Ik9mZiJ9LHsibmFtZSI6IllhdyBNb2RpZmllciAgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiRGlzYWJsZWQifSx7Im5hbWUiOiJNb2RlICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJTdGF0aWMifSx7Im5hbWUiOiJJbnZlcnRlciBBQSAgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjpmYWxzZX0seyJuYW1lIjoiU2V0dGluZ3MgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkRlZmF1bHQifSx7Im5hbWUiOiJPZmZzZXQgIzEgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6LTYwLjB9LHsibmFtZSI6IllhdyBNb2RlICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJMZWZ0L1JpZ2h0In0seyJuYW1lIjoiT2Zmc2V0ICMyICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiMSBXYXkgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiJFbmFibGUgQ29uZGl0aW9uICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOnRydWV9LHsibmFtZSI6IjIgV2F5ICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiMyBXYXkgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiJZYXcgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkJhY2t3YXJkIn0seyJuYW1lIjoiNCBXYXkgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiJSaWdodCBMaW1pdCAgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjo2MC4wfSx7Im5hbWUiOiI1IFdheSAgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjowLjB9LHsibmFtZSI6IlN3YXAgY29tcGF0aWJsZSB3aXRoIGludmVydGVyICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOmZhbHNlfSx7Im5hbWUiOiJCb2R5IFlhdyAgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6dHJ1ZX0seyJuYW1lIjoiTGVmdCBMaW1pdCAgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6NjAuMH0seyJuYW1lIjoiUGl0Y2ggICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJEb3duIn0seyJuYW1lIjoiQmFzZSAgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkF0IFRhcmdldCJ9LHsibmFtZSI6Ik9mZnNldCAgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6LTM2LjB9LHsibmFtZSI6IkZha2UgT3B0aW9ucyAgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6WyJKaXR0ZXIiXX0seyJuYW1lIjoiT2Zmc2V0IFIgICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjI5LjB9LHsibmFtZSI6IkRlbGF5IHRpY2tzICAgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoxMi4wfSx7Im5hbWUiOiJGcmVlc3RhbmQgRFMgICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJPZmYifSx7Im5hbWUiOiJZYXcgTW9kaWZpZXIgICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJEaXNhYmxlZCJ9LHsibmFtZSI6Ik1vZGUgICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOiJTdGF0aWMifSx7Im5hbWUiOiJJbnZlcnRlciBBQSAgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6ZmFsc2V9LHsibmFtZSI6IlNldHRpbmdzICAgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiRGVmYXVsdCJ9LHsibmFtZSI6Ik9mZnNldCAjMSAgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiJZYXcgTW9kZSAgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6IkxlZnQvUmlnaHQifSx7Im5hbWUiOiJPZmZzZXQgIzIgICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiMSBXYXkgICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiRW5hYmxlIENvbmRpdGlvbiAgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6dHJ1ZX0seyJuYW1lIjoiMiBXYXkgICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiMyBXYXkgICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiWWF3ICAgICAgICAiLCJ0YWIiOiJhbnRpYWltc19idWlsZGVyIiwidmFyIjoiQmFja3dhcmQifSx7Im5hbWUiOiI0IFdheSAgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6MC4wfSx7Im5hbWUiOiJSaWdodCBMaW1pdCAgICAgICAgIiwidGFiIjoiYW50aWFpbXNfYnVpbGRlciIsInZhciI6NjAuMH0seyJuYW1lIjoiNSBXYXkgICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOjAuMH0seyJuYW1lIjoiU3dhcCBjb21wYXRpYmxlIHdpdGggaW52ZXJ0ZXIgICAgICAgICIsInRhYiI6ImFudGlhaW1zX2J1aWxkZXIiLCJ2YXIiOmZhbHNlfV0=");
            end, true);
            v200.save_preset:tooltip("Save / Create Preset");
            v200.delete_preset:tooltip("Delete Preset");
            v200.import_preset:tooltip("Import");
            v200.export_preset:tooltip("Export");
            v200.neverlose_config = v187:button("\a{Link Active}\239\131\150  \aDEFAULTNeverlose CFG ", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://market.neverlose.cc/bEb3IN");
            end, true);
            v200.youtube = v187:button("\a{Link Active}\239\133\167  \aDEFAULTYoutube ", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://youtube.com/@PikazHvH");
            end, true);
            v200.projects = v187:button("\a{Link Active}\239\130\174  \aDEFAULTOur Projects ", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/?page=0&search=author:pikachu&sort=drec0&type=2&filter=0");
            end, true);
        end;
        l_events_0.render:set(function()
            -- upvalues: l_get_alpha_0 (ref), l_get_style_0 (ref), v141 (ref), v183 (ref)
            if l_get_alpha_0() < 0.3 then
                return;
            else
                link_color = l_get_style_0()["Link Active"];
                text = v141.gradient("mytools", color(173, 173, 173), color(link_color.r, link_color.g, link_color.b), 1.5);
                ui.sidebar(text .. "\aADADADFF \226\128\162 \a{Link Active}" .. v183.cheat.version .. "", "\239\150\190");
                return;
            end;
        end);
        v201 = nil;
        v201 = {
            antiaims = {}, 
            ragebot = {}, 
            visuals = {}, 
            misc = {}, 
            antiaims_builder = {}
        };
        local v209 = l_get_style_0("Link Active"):to_hex();
        v201.misc.config_stealer = v191:switch("\a{Link Active}\239\160\130   \aDEFAULTEnable Cheat Config Stealer");
        v201.misc.muteunmute = v195:switch("Unmute Silenced Players");
        v201.misc.muteunmute:tooltip("Removes mute from all players who are muted for abuse, updating on round start.");
        v201.visuals.on_screen = v197:switch("On-Screen Indicators");
        local v210 = v201.visuals.on_screen:create();
        v201.visuals.select = v210:combo("Select", {
            [1] = "Disable", 
            [2] = "Default"
        }, 0);
        v201.visuals.fonts = v210:combo("Font", {
            [1] = "Small", 
            [2] = "Default"
        });
        v201.visuals.indicator_color = v210:color_picker("Indicator Color", color(255, 255, 255));
        v201.visuals.build_color = v210:color_picker("Build Color", color(215, 163, 111));
        v201.visuals.glow_px = v210:slider("Glow Offset", 0, 100, 40, nil, "px");
        v201.visuals.dmg_indx = v210:slider("posxdmg", 0, l_screen_size_0().x, 965);
        v201.visuals.dmg_indy = v210:slider("posydmg", 0, l_screen_size_0().y, 525);
        v201.visuals.dmg_indx:visibility(false);
        v201.visuals.dmg_indy:visibility(false);
        v201.visuals.select:set_callback(function(v211)
            -- upvalues: v201 (ref)
            v201.visuals.indicator_color:visibility(v211:get() == "Default");
            v201.visuals.build_color:visibility(v211:get() == "Default");
            v201.visuals.glow_px:visibility(v211:get() == "Default");
            v201.visuals.fonts:visibility(v211:get() == "Default");
        end, true);
        v201.visuals.damage_indicator = v197:switch("Damage Indicator");
        v210 = v201.visuals.damage_indicator:create();
        v201.visuals.damage_font = v210:combo("Damage Font", "Small", "Default");
        v201.visuals.dis_animation = v210:switch("Disable Damage Animation", false);
        v201.visuals.damage_indicator:set_callback(function(v212)
            -- upvalues: v201 (ref)
            v201.visuals.damage_font:visibility(v212:get());
            v201.visuals.dis_animation:visibility(v212:get());
        end, true);
        v201.visuals.velocity_warning = v197:switch("Velocity Indicator");
        v210 = v201.visuals.velocity_warning:create();
        v201.visuals.velocity_color = v210:color_picker("Velocity Color", color(145, 178, 239));
        v201.visuals.velocity_x = v210:slider("posxvelocity", 0, l_screen_size_0().x, 900);
        v201.visuals.velocity_y = v210:slider("posyvelocity", 0, l_screen_size_0().y, 250);
        v201.visuals.velocity_x:visibility(false);
        v201.visuals.velocity_y:visibility(false);
        v201.visuals.sindicators = v197:selectable("500$ Indicators", {
            [1] = "Double tap", 
            [2] = "Dormant aimbot", 
            [3] = "Minimum damage", 
            [4] = "Ping spike", 
            [5] = "Fake duck", 
            [6] = "Freestanding", 
            [7] = "Spectator list", 
            [8] = "Hit Percentage", 
            [9] = "Bomb info", 
            [10] = "Body aim", 
            [11] = "Hide shots", 
            [12] = "Choked commands"
        }, 0);
        v201.ragebot.aimbot_logging = v196:switch("Custom Event Logs");
        v210 = v201.ragebot.aimbot_logging:create();
        v201.ragebot.select_log = v210:selectable("Select Log", {
            [1] = "Console", 
            [2] = "Screen"
        });
        v201.ragebot.purchases = v210:switch("Purchase Logs", true);
        v201.ragebot.dis_glow = v210:switch("Disable Glow");
        v201.ragebot.accent_color = v210:color_picker("Screen Logs Color", color(144, 151, 255));
        v201.ragebot.select_log:set_callback(function(v213)
            -- upvalues: v201 (ref)
            v201.ragebot.accent_color:visibility(v213:get("Screen"));
            v201.ragebot.dis_glow:visibility(v213:get("Screen"));
        end, true);
        v201.visuals.custom_scope = v198:switch("Scope Overlay");
        v210 = v201.visuals.custom_scope:create();
        v201.visuals.scope_style = v210:combo("Select Style", {
            [1] = "Default", 
            [2] = "Reversed"
        });
        v201.visuals.remove_line = v210:selectable("Exclude Line", {
            [1] = "Left", 
            [2] = "Right", 
            [3] = "Up", 
            [4] = "Down"
        });
        v201.visuals.scope_gap = v210:slider("Scope Gap", 0, 500, 7);
        v201.visuals.scope_size = v210:slider("Scope Size", 0, 1000, 105);
        v201.visuals.scope_color = v210:color_picker("Scope Color", color(255, 255, 255));
        v201.visuals.solus_widgets = v198:switch("Widgets");
        v210 = v201.visuals.solus_widgets:create();
        v201.visuals.solus_widgets_s = v210:selectable("Windows", {
            [1] = "Hotkeys", 
            [2] = "Spectators"
        });
        v201.visuals.accent_col = v210:color_picker("Widgets Color", color(150, 150, 255));
        v201.visuals.pos_x_s = v210:slider("posx", 0, l_screen_size_0().x, 150);
        v201.visuals.pos_y_s = v210:slider("posy", 0, l_screen_size_0().y, 150);
        v201.visuals.pos_x1_s = v210:slider("posx1", 0, l_screen_size_0().x, 250);
        v201.visuals.pos_y1_s = v210:slider("posy1", 0, l_screen_size_0().y, 250);
        v201.visuals.pos_x_s:visibility(false);
        v201.visuals.pos_y_s:visibility(false);
        v201.visuals.pos_x1_s:visibility(false);
        v201.visuals.pos_y1_s:visibility(false);
        v201.visuals.viewmodel_changer = v195:switch("Viewmodel Changer");
        v210 = v201.visuals.viewmodel_changer:create();
        v201.visuals.viewmodel_fov = v210:slider("FOV", -100, 100, 68);
        v201.visuals.viewmodel_x = v210:slider("Offset X", -150, 150, 25, 0.1);
        v201.visuals.viewmodel_y = v210:slider("Offset Y", -150, 150, 0, 0.1);
        v201.visuals.viewmodel_z = v210:slider("Offset Z", -150, 150, -15, 0.1);
        v210:button("Reset values to default", function()
            -- upvalues: v201 (ref)
            v201.visuals.viewmodel_fov:set(68);
            v201.visuals.viewmodel_x:set(25);
            v201.visuals.viewmodel_y:set(0);
            v201.visuals.viewmodel_z:set(-15);
        end);
        v201.visuals.viewmodel_aspectratio = v195:slider("Aspect Ratio", 0, 200, 0, 0.01, function(v214)
            if v214 == 0 then
                return "Off";
            else
                return;
            end;
        end);
        v201.misc.killsay = v195:switch("Trash Talk");
        v210 = v201.misc.killsay:create();
        v201.misc.killsay_disablers = v210:switch("Disable on Warmup", false);
        v201.misc.clantag_changer = v195:switch("Clan Tag");
        v201.visuals.markers = v198:switch("Aimbot Markers", false);
        v210 = v201.visuals.markers:create();
        v201.visuals.kibit_marker = v210:switch("Kibit Hit Marker");
        v201.visuals.miss_marker = v210:switch("3D Miss Marker");
        v201.visuals.ot_marker = v210:switch("OT Damage Marker");
        v201.visuals.console_changer = v198:switch("Console Color Changer");
        v210 = v201.visuals.console_changer:create();
        v201.visuals.console_color = v210:color_picker("Console Color", color(255, 255, 255, 255));
        v201.misc.grenade_release = v195:switch("Grenade Release");
        v210 = v201.misc.grenade_release:create();
        v201.misc.min_dmg = v210:slider("Min. Damage", 0, 50, 50);
        v201.misc.grenade_release:tooltip("Throws a grenade when it is possible to inflict minimum damage specified in script settings, in case of a molotov if molotov will hit the enemy. Works with grenade prediction enabled.");
        v201.misc.grenade_fix = v195:switch("Nade Throw Fix");
        v201.misc.grenade_fix:tooltip("Fix the moment when you try to throw a grenade and it is not thrown.");
        v201.misc.taskbar = v195:switch("\aCCCC6FFFFlash Icon On Round Start");
        v201.antiaims.antiaim_mode = v193:combo("\a{Link Active}\239\147\191   \aDEFAULTMode", {
            [1] = "Disabled", 
            [2] = "Classic Jitter", 
            [3] = "Defensive Preset", 
            [4] = "Conditional"
        });
        v201.antiaims.manual_aa = v193:combo("\a{Link Active}\238\146\190   \aDEFAULTManual AA", {
            [1] = "Disabled", 
            [2] = "Left", 
            [3] = "Right", 
            [4] = "Forward"
        });
        v210 = v201.antiaims.manual_aa:create();
        v201.antiaims.disablermanual = v210:switch("Disable Yaw Modifiers");
        v201.antiaims.condition = v194:combo("Current Condition", {
            [1] = "Global", 
            [2] = "Standing", 
            [3] = "Moving", 
            [4] = "Slow motion", 
            [5] = "Air", 
            [6] = "Air Crouch", 
            [7] = "Crouch", 
            [8] = "Crouch Move"
        }, 0);
        v201.antiaims.tp = v193:label("You are using an automatic preset, you don't need to adjust it. Just press it and go play.");
        v201.antiaims.antiaims_tweaks = v192:selectable("\a{Link Active}\239\132\174   \aDEFAULTTweaks", {
            [1] = "Bombsite E Fix", 
            [2] = "Legit AA", 
            [3] = "Dis. AA on Warmup", 
            [4] = "Avoid Backstab", 
            [5] = "Fluctuate Fake Lag", 
            [6] = "Auto Teleport", 
            [7] = "Fast Ladder", 
            [8] = "No Fall Damage"
        });
        v210 = v201.antiaims.antiaims_tweaks:create();
        v201.antiaims.weapons = v210:selectable("[AutoTP] Weapons", "Pistols", "Auto Snipers", "AWP", "SSG-08", "Heavy Pistols", "Knife/Taser");
        v201.antiaims.delayticks = v210:slider("[AutoTP] Delay", 1, 16, 1, nil, "t");
        v201.antiaims.antiaims_tweaks:set_callback(function(v215)
            -- upvalues: v201 (ref)
            v201.antiaims.weapons:visibility(v215:get("Auto Teleport"));
            v201.antiaims.delayticks:visibility(v215:get("Auto Teleport"));
        end, true);
        v201.antiaims.safehead = v192:selectable("\a{Link Active}\239\148\132   \aDEFAULTSafe Head", {
            [1] = "Bomb", 
            [2] = "Knife / Taser", 
            [3] = "Fake-Lag", 
            [4] = "Crouching"
        });
        v201.antiaims.force_lag = v192:switch("\a{Link Active}\239\135\158   \aDEFAULTForce Break LC");
        v210 = v201.antiaims.force_lag:create();
        v201.antiaims.lag_conditions = v210:selectable("Conditions", {
            [1] = "In Air", 
            [2] = "Standing", 
            [3] = "Moving", 
            [4] = "Slow Walking", 
            [5] = "Crouching", 
            [6] = "Crouch Move"
        });
        v201.antiaims.defensive_aa = v192:switch("\a{Link Active}\238\146\187   \aDEFAULTDefensive AA", false);
        v210 = v201.antiaims.defensive_aa:create();
        v201.antiaims.defensive_type = v210:combo("Type", {
            [1] = "Presets", 
            [2] = "Custom"
        });
        v201.antiaims.defensive_pitch = v210:combo("Pitch", {
            [1] = "Disabled", 
            [2] = "Up", 
            [3] = "Down", 
            [4] = "Semi Up", 
            [5] = "Semi Down", 
            [6] = "Random"
        });
        v201.antiaims.defensive_yaw = v210:combo("Yaw", {
            [1] = "Disabled", 
            [2] = "Sideways", 
            [3] = "Opposite", 
            [4] = "Spin", 
            [5] = "Random", 
            [6] = "3-Way", 
            [7] = "5-Way"
        });
        v201.antiaims.custom_pitch = v210:slider("Custom Pitch", -89, 89, 0);
        v201.antiaims.custom_yaw = v210:slider("Custom Yaw", -180, 180, 0);
        v201.antiaims.defensive_disablers = v210:selectable("Disablers", {
            [1] = "Manuals", 
            [2] = "Grenades"
        });
        v201.antiaims.espam = v210:switch("E-Spam while Safe Head");
        v201.antiaims.defensive_type:set_callback(function(v216)
            -- upvalues: v201 (ref)
            v201.antiaims.defensive_pitch:visibility(v216:get() == "Presets");
            v201.antiaims.defensive_yaw:visibility(v216:get() == "Presets");
            v201.antiaims.custom_pitch:visibility(v216:get() == "Custom");
            v201.antiaims.custom_yaw:visibility(v216:get() == "Custom");
        end, true);
        v201.antiaims.freestanding = v192:switch("\a{Link Active}\239\129\135   \aDEFAULTFreestanding");
        v210 = v201.antiaims.freestanding:create();
        v201.antiaims.body_freestanding = v210:switch("Body Freestanding");
        v201.antiaims.disable_manual = v210:switch("Disable on Manuals");
        v201.antiaims.yawmodif = v210:switch("Disable Yaw Mod.");
        v201.antiaims.anim_breakers = v192:switch("\a{Link Active}\239\138\154   \aDEFAULTAnim. Breakers");
        v210 = v201.antiaims.anim_breakers:create();
        v201.antiaims.type_legs_ground = v210:combo("On Ground", {
            [1] = "Disable", 
            [2] = "Follow Direction", 
            [3] = "Moon Walk", 
            [4] = "Jitter"
        });
        v201.antiaims.type_legs_air = v210:combo("In Air", {
            [1] = "Disable", 
            [2] = "Static", 
            [3] = "Moon Walk"
        });
        v201.antiaims.static_slow = v210:switch("Sliding On Slow-Walk");
        v201.antiaims.custom_move = v210:switch("Move Lean");
        v201.antiaims.move_lean = v210:slider("Move Lean Force", 0, 100, 0, nil, "%");
        v201.antiaims.custom_move:set_callback(function(v217)
            -- upvalues: v201 (ref)
            v201.antiaims.move_lean:visibility(v217:get());
        end, true);
        v201.ragebot.rev_help = v196:switch("Revolver Helper");
        v201.ragebot.rev_help:tooltip("Shows \"DMG+\" indicator next to opponent if you can give 100 damage an opponent with a revolver.\nYou can edit indicator position in esp settings.");
        v201.ragebot.hc_enable = v196:switch("Hitchance Additionals");
        v210 = v201.ragebot.hc_enable:create();
        v201.ragebot.hc_cond = v210:selectable("Condition", {
            [1] = "Air", 
            [2] = "No scope"
        });
        v201.ragebot.hc_air = v210:slider("Air", 0, 100, 55);
        v201.ragebot.hc_ns = v210:slider("No scope", 0, 100, 55);
        v201.ragebot.hc_cond:set_callback(function(v218)
            -- upvalues: v201 (ref)
            v201.ragebot.hc_air:visibility(v218:get("Air"));
            v201.ragebot.hc_ns:visibility(v218:get("No scope"));
        end, true);
        v201.ragebot.fakelatency = v196:switch("Unlock Fake Latency");
        v201.ragebot.fakelatency:tooltip("Removes 100ms limit in ping spike");
        v209 = nil;
        v209 = {};
        for v219 = 1, 8 do
            local v220 = string.rep(" ", v219);
            v201.antiaims_builder[v219] = {};
            v201.antiaims_builder[v219].enabled = v194:switch("Enable Condition" .. v220, false);
            v201.antiaims_builder[v219].pitch = v194:combo("Pitch" .. v220, {
                [1] = "Disabled", 
                [2] = "Down", 
                [3] = "Fake Down", 
                [4] = "Fake Up"
            });
            v201.antiaims_builder[v219].yaw = v194:combo("Yaw" .. v220, {
                [1] = "Disabled", 
                [2] = "Backward", 
                [3] = "Static"
            });
            local v221 = v201.antiaims_builder[v219].yaw:create();
            v201.antiaims_builder[v219].base = v221:combo("Base" .. v220, {
                [1] = "Local View", 
                [2] = "At Target"
            });
            v201.antiaims_builder[v219].type = v221:combo("Yaw Mode" .. v220, {
                [1] = "Default", 
                [2] = "Left/Right", 
                [3] = "Delayed"
            });
            v201.antiaims_builder[v219].delay = v221:switch("Swap compatible with inverter" .. v220);
            v201.antiaims_builder[v219].offset_l = v221:slider("Offset" .. v220, -180, 180, 0, nil, "\194\176");
            v201.antiaims_builder[v219].offset_r = v221:slider("Offset R" .. v220, -180, 180, 0, nil, "\194\176");
            v201.antiaims_builder[v219].per_tick = v221:slider("Delay ticks" .. v220, 3, 24, 12, nil, "t");
            v201.antiaims_builder[v219].jyaw = v194:combo("Yaw Modifier" .. v220, {
                [1] = "Disabled", 
                [2] = "Center", 
                [3] = "Offset", 
                [4] = "Random", 
                [5] = "Spin", 
                [6] = "3-Way", 
                [7] = "5-Way"
            });
            v221 = v201.antiaims_builder[v219].jyaw:create();
            v201.antiaims_builder[v219].mode = v221:combo("Mode" .. v220, {
                [1] = "Static", 
                [2] = "Random (From/To)", 
                [3] = "Left/Right"
            });
            v201.antiaims_builder[v219].type_mod = v221:combo("Settings" .. v220, {
                [1] = "Default", 
                [2] = "Custom"
            });
            v201.antiaims_builder[v219].offset_one = v221:slider("Offset #1" .. v220, -180, 180, 0, nil, "\194\176");
            v201.antiaims_builder[v219].offset_two = v221:slider("Offset #2" .. v220, -180, 180, 0, nil, "\194\176");
            v201.antiaims_builder[v219].way1 = v221:slider("1 Way" .. v220, -180, 180, 0, nil, "\194\176");
            v201.antiaims_builder[v219].way2 = v221:slider("2 Way" .. v220, -180, 180, 0, nil, "\194\176");
            v201.antiaims_builder[v219].way3 = v221:slider("3 Way" .. v220, -180, 180, 0, nil, "\194\176");
            v201.antiaims_builder[v219].way4 = v221:slider("4 Way" .. v220, -180, 180, 0, nil, "\194\176");
            v201.antiaims_builder[v219].way5 = v221:slider("5 Way" .. v220, -180, 180, 0, nil, "\194\176");
            v201.antiaims_builder[v219].body_yaw = v194:switch("Body Yaw" .. v220, false);
            v221 = v201.antiaims_builder[v219].body_yaw:create();
            v201.antiaims_builder[v219].fake_slider_main = v221:slider("Left Limit" .. v220, 0, 60, 60, nil, "\194\176");
            v201.antiaims_builder[v219].fake_slider_next = v221:slider("Right Limit" .. v220, 0, 60, 60, nil, "\194\176");
            v201.antiaims_builder[v219].fake_op = v221:selectable("Fake Options" .. v220, {
                [1] = "Avoid Overlap", 
                [2] = "Jitter", 
                [3] = "Randomize Jitter", 
                [4] = "Anti Bruteforce"
            }, 0);
            v201.antiaims_builder[v219].freestand = v221:combo("Freestand DS" .. v220, {
                [1] = "Off", 
                [2] = "Peek Fake", 
                [3] = "Peek Real"
            }, 0);
            v201.antiaims_builder[v219].inverter = v221:switch("Inverter AA" .. v220, false);
        end;
        v210 = v201.antiaims_builder;
        do
            local l_v210_0 = v210;
            v209.hide_all_custom = function()
                -- upvalues: l_v210_0 (ref)
                for v223 = 1, 8 do
                    for _, v225 in pairs(l_v210_0[v223]) do
                        if v225:visibility() then
                            v225:visibility(false);
                        end;
                    end;
                end;
            end;
            v209.unhide_cur_custom = function(_, v227)
                -- upvalues: l_v210_0 (ref)
                if l_v210_0[v227].enabled:get() then
                    for _, v229 in pairs(l_v210_0[v227]) do
                        if not v229:visibility() then
                            v229:visibility(true);
                        end;
                    end;
                else
                    for _, v231 in pairs(l_v210_0[v227]) do
                        if v231:visibility() then
                            v231:visibility(false);
                        end;
                    end;
                end;
                l_v210_0[v227].enabled:visibility(true);
            end;
            v209.unhide_cur_enable_state = function(_, v233)
                -- upvalues: l_v210_0 (ref)
                l_v210_0[v233].enabled:visibility(true);
            end;
            v209.strange = function(_, v235)
                if v235 == "Global" then
                    return 0;
                elseif v235 == "Standing" then
                    return 1;
                elseif v235 == "Moving" then
                    return 2;
                elseif v235 == "Slow motion" then
                    return 3;
                elseif v235 == "Air" then
                    return 4;
                elseif v235 == "Air Crouch" then
                    return 5;
                elseif v235 == "Crouch" then
                    return 6;
                elseif v235 == "Crouch Move" then
                    return 7;
                elseif v235 == "Dormant" then
                    return 8;
                else
                    return;
                end;
            end;
            v209.init_handle = function(_)
                -- upvalues: l_events_0 (ref), l_get_alpha_0 (ref), v201 (ref), v209 (ref), l_v210_0 (ref)
                l_events_0.pre_render:set(function()
                    -- upvalues: l_get_alpha_0 (ref), v201 (ref), v209 (ref), l_v210_0 (ref)
                    if l_get_alpha_0() ~= 1 then
                        return;
                    else
                        local v237 = v201.antiaims.antiaim_mode:get();
                        v209:hide_all_custom();
                        v201.antiaims.condition:visibility(v237 == "Conditional");
                        if v237 == "Conditional" then
                            v209:unhide_cur_custom(v209:strange(v201.antiaims.condition:get()) + 1);
                            v209:unhide_cur_enable_state(v209:strange(v201.antiaims.condition:get()) + 1);
                            for v238 = 1, 8 do
                                if l_v210_0[v238].jyaw:get() == "5-Way" or l_v210_0[v238].jyaw:get() == "3-Way" then
                                    l_v210_0[v238].mode:visibility(false);
                                end;
                                if l_v210_0[v238].jyaw:get() == "3-Way" and l_v210_0[v238].type_mod:get() == "Custom" then
                                    l_v210_0[v238].offset_one:visibility(false);
                                    l_v210_0[v238].offset_two:visibility(false);
                                    l_v210_0[v238].way1:visibility(true);
                                    l_v210_0[v238].way2:visibility(true);
                                    l_v210_0[v238].way3:visibility(true);
                                    l_v210_0[v238].way4:visibility(false);
                                    l_v210_0[v238].way5:visibility(false);
                                end;
                                if l_v210_0[v238].jyaw:get() == "5-Way" and l_v210_0[v238].type_mod:get() == "Custom" then
                                    l_v210_0[v238].offset_one:visibility(false);
                                    l_v210_0[v238].offset_two:visibility(false);
                                    l_v210_0[v238].way1:visibility(true);
                                    l_v210_0[v238].way2:visibility(true);
                                    l_v210_0[v238].way3:visibility(true);
                                    l_v210_0[v238].way4:visibility(true);
                                    l_v210_0[v238].way5:visibility(true);
                                end;
                                if l_v210_0[v238].jyaw:get() == "5-Way" and l_v210_0[v238].type_mod:get() == "Default" then
                                    l_v210_0[v238].offset_two:visibility(false);
                                    l_v210_0[v238].way1:visibility(false);
                                    l_v210_0[v238].way2:visibility(false);
                                    l_v210_0[v238].way3:visibility(false);
                                    l_v210_0[v238].way4:visibility(false);
                                    l_v210_0[v238].way5:visibility(false);
                                end;
                                if l_v210_0[v238].jyaw:get() == "3-Way" and l_v210_0[v238].type_mod:get() == "Default" then
                                    l_v210_0[v238].offset_two:visibility(false);
                                    l_v210_0[v238].way1:visibility(false);
                                    l_v210_0[v238].way2:visibility(false);
                                    l_v210_0[v238].way3:visibility(false);
                                    l_v210_0[v238].way4:visibility(false);
                                    l_v210_0[v238].way5:visibility(false);
                                end;
                                if l_v210_0[v238].jyaw:get() ~= "5-Way" and l_v210_0[v238].jyaw:get() ~= "3-Way" then
                                    l_v210_0[v238].type_mod:visibility(false);
                                    l_v210_0[v238].way1:visibility(false);
                                    l_v210_0[v238].way2:visibility(false);
                                    l_v210_0[v238].way3:visibility(false);
                                    l_v210_0[v238].way4:visibility(false);
                                    l_v210_0[v238].way5:visibility(false);
                                end;
                                if l_v210_0[v238].type:get() ~= "Delayed" then
                                    l_v210_0[v238].per_tick:visibility(false);
                                    l_v210_0[v238].delay:visibility(false);
                                end;
                                if l_v210_0[v238].type:get() == "Default" then
                                    l_v210_0[v238].offset_r:visibility(false);
                                end;
                                if l_v210_0[v238].mode:get() == "Static" then
                                    l_v210_0[v238].offset_two:visibility(false);
                                end;
                            end;
                            l_v210_0[1].enabled:visibility(false);
                            l_v210_0[1].enabled:set(true);
                            v201.antiaims.condition:visibility(true);
                        end;
                        return;
                    end;
                end);
            end;
        end;
        v183.global = v200;
        v183.info_group = v185;
        v183.elements = v201;
        v183.antiaim_builder = v209;
        v209:init_handle();
    end
}):struct("refs")({
    enable_desync = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
    yaw_base = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw"), 
    pitch = l_find_0("Aimbot", "Anti Aim", "Angles", "Pitch"), 
    yaw = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
    fake_op = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
    base_yaw = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
    freestand = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
    hidden = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
    slowwalk = l_find_0("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
    jyaw = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
    jyaw_slider = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
    fake_duck = l_find_0("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
    freestanding_def = l_find_0("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
    left_limit = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
    right_limit = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
    dt = l_find_0("Aimbot", "Ragebot", "Main", "Double Tap"), 
    hs = l_find_0("Aimbot", "Ragebot", "Main", "Hide shots"), 
    body_aim = l_find_0("Aimbot", "Ragebot", "Safety", "Body Aim"), 
    safe_point = l_find_0("Aimbot", "Ragebot", "Safety", "Safe Points"), 
    auto_peek = l_find_0("Aimbot", "Ragebot", "Main", "Peek Assist"), 
    freestanding_yaw = l_find_0("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
    hitchance = l_find_0("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
    min_dmg = l_find_0("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
    base = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
    dormantaim = l_find_0("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
    pingspike = l_find_0("Miscellaneous", "Main", "Other", "Fake Latency"), 
    legmovement = l_find_0("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
    logs = l_find_0("Miscellaneous", "Main", "Other", "Log Events"), 
    inverter1 = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
    disablers = l_find_0("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers")
}):struct("config_system")({
    init = function(v239)
        -- upvalues: l_base64_0 (ref), l_clipboard_0 (ref), l_add_notify_0 (ref), v179 (ref)
        local v240 = nil;
        local v241 = "nl/scripts/mytools/mytools.config";
        v240 = {};
        local _ = function(v242)
            local v243 = "6a 75 73 74 73 69 6d 70 6c 65 74 65 78 74";
            local v244 = #v242;
            local v245 = #v243;
            local v246 = ffi.new("char[?]", v244 + 1);
            local v247 = ffi.new("char[?]", v245 + 1);
            local l_status_2, _ = pcall(function()
                return string.dump(ffi.copy);
            end);
            if l_status_2 then
                print_error("You are not allowed to edit FFI Struct.");
                return;
            else
                ffi.copy(v246, v242);
                ffi.copy(v247, v243);
                for v250 = 0, v244 - 1 do
                    v246[v250] = bit.bxor(v246[v250], v247[v250 % v245]);
                end;
                return ffi.string(v246, v244);
            end;
        end;
        Cipher = {
            encode = function(v252, _)
                -- upvalues: l_base64_0 (ref)
                return "[mytools]" .. tostring(l_base64_0.encode(v252)) .. "[/mytools]";
            end, 
            decode = function(v254, _)
                -- upvalues: l_base64_0 (ref)
                local v256 = "[mytools]";
                local v257 = "[/mytools]";
                local _, v259 = v254:find(v256, 1, true);
                local v260, _ = v254:find(v257, 1, true);
                v254 = v254:sub(v259 + 1, v260 - 1):gsub(" ", "");
                return tostring(l_base64_0.decode(v254));
            end
        };
        v240.import = function(v262, v263, _)
            -- upvalues: l_base64_0 (ref), l_clipboard_0 (ref), v239 (ref), l_add_notify_0 (ref), v179 (ref)
            local l_status_3, l_result_3 = pcall(function()
                -- upvalues: l_base64_0 (ref), v262 (ref), l_clipboard_0 (ref)
                return json.parse(l_base64_0.decode(type(v262) == "table" and l_clipboard_0.get() or v262));
            end);
            if v263 ~= nil then
                local l_status_4, l_result_4 = pcall(function()
                    -- upvalues: v263 (ref)
                    return json.parse(v263);
                end);
                l_result_3 = l_result_4;
                l_status_3 = l_status_4;
            end;
            if not l_status_3 then
                v239.impt.play_sound("error.wav", 0.12);
                l_add_notify_0("mytools", "\aFF8B7AFF\226\157\140 There was an Error while Loading Your Config!");
                return;
            else
                for _, v270 in pairs(l_result_3) do
                    local _ = v270;
                    for v272, v273 in pairs(v239.menu.elements) do
                        if (not skip_data:get("Anti-Aims") or string.find(v272, "antiaims") ~= nil and string.find(v272, "antiaims_builder") ~= nil) and (not skip_data:get("Ragebot") or string.find(v272, "ragebot") ~= nil) and (not skip_data:get("Misc/Vis") or string.find(v272, "misc") ~= nil and string.find(v272, "visuals") ~= nil) and v272 == v270.tab then
                            for _, v275 in pairs(v273) do
                                if v179(v275) == "table" then
                                    for _, v277 in pairs(v275) do
                                        if v270.name == v277:name() then
                                            v277:set(v270.var);
                                        end;
                                    end;
                                elseif v270.name == v275:name() then
                                    v275:set(v270.var);
                                end;
                            end;
                        end;
                    end;
                end;
                l_add_notify_0("mytools", "\a89F2CAFF\226\156\148\239\184\143 Successfully Loaded Your Config");
                v239.impt.play_sound("physics/wood/wood_plank_impact_hard4.wav", 0.12);
                return;
            end;
        end;
        do
            local l_v241_0 = v241;
            v240.save = function()
                -- upvalues: v239 (ref), l_v241_0 (ref), l_add_notify_0 (ref)
                local v279 = v239.menu.global.preset_name:get();
                local _, _ = pcall(function()
                    -- upvalues: l_v241_0 (ref), v239 (ref), v279 (ref), l_add_notify_0 (ref)
                    local v280 = files.read(l_v241_0);
                    local l_status_5, l_result_5 = pcall(function()
                        -- upvalues: v280 (ref)
                        return json.parse(v280);
                    end);
                    if not l_status_5 or #l_result_5 == 0 then
                        l_result_5 = {};
                    end;
                    local v283 = v239.menu.global.preset_list:get();
                    local v284 = v239.menu.global.preset_list:list();
                    local v285 = 0;
                    if v279:gsub(" ", "") == "" or v279 == "" then
                        v285 = 1;
                        for v286 = 1, #l_result_5 do
                            if l_result_5[v286].name == v284[v283] then
                                v285 = -1;
                                l_result_5[v286].code = v239.config_system:export();
                                files.write(l_v241_0, json.stringify(l_result_5));
                            end;
                        end;
                    end;
                    for v287 = 1, #l_result_5 do
                        if l_result_5[v287].name == v279 then
                            v285 = 2;
                            l_result_5[v287].code = v239.config_system:export();
                            files.write(l_v241_0, json.stringify(l_result_5));
                            v239.menu.global.preset_name:set("");
                            v285 = -2;
                            break;
                        end;
                    end;
                    if v279:gsub(" ", "") ~= "" then
                        local v288 = true;
                        for v289 = 1, #l_result_5 do
                            if l_result_5[v289].name == v279 then
                                v288 = false;
                            end;
                        end;
                        if v288 then
                            v285 = 3;
                            table.insert(l_result_5, {
                                code = v239.config_system:export(), 
                                name = v279
                            });
                            local v290 = {};
                            for v291 = 1, #l_result_5 do
                                table.insert(v290, l_result_5[v291].name);
                            end;
                            files.write(l_v241_0, json.stringify(l_result_5));
                            v239.menu.global.preset_list:update(v290);
                            v239.menu.global.preset_name:set("");
                            v285 = -3;
                        end;
                    end;
                    if v285 == 1 then
                        v239.impt.play_sound("error.wav", 0.12);
                        l_add_notify_0("mytools", "\aFF8B7AFF\226\154\160\239\184\143 Enter Valid Config Name!");
                        return;
                    else
                        if v285 ~= 0 then
                            l_add_notify_0("mytools", "\a89F2CAFF\226\156\148\239\184\143 Successfully Saved Your Config");
                            v239.impt.play_sound("physics/wood/wood_plank_impact_hard4.wav", 0.12);
                        else
                            v239.impt.play_sound("error.wav", 0.12);
                            l_add_notify_0("mytools", "\aFF8B7AFF\226\157\140 There was an Error while Loading Your Config!");
                        end;
                        return;
                    end;
                end);
            end;
            v240.delete = function()
                -- upvalues: v239 (ref), l_v241_0 (ref)
                local v294 = v239.menu.global.preset_list:get();
                local v295 = files.read(l_v241_0);
                local l_status_7, l_result_7 = pcall(function()
                    -- upvalues: v295 (ref)
                    return json.parse(v295);
                end);
                if not l_status_7 or #l_result_7 == 0 then
                    l_result_7 = {};
                end;
                table.remove(l_result_7, v294);
                files.write(l_v241_0, json.stringify(l_result_7));
                local v298 = {};
                for v299 = 1, #l_result_7 do
                    table.insert(v298, l_result_7[v299].name);
                end;
                v239.menu.global.preset_list:update(#v298 == 0 and {
                    [1] = "\a{Link Active}Mytools. \aCBC9C9FFCreate preset."
                } or v298);
                v239.impt.play_sound("physics/wood/wood_plank_impact_hard4.wav", 0.12);
            end;
        end;
        v240.export = function()
            -- upvalues: v239 (ref), v179 (ref), l_base64_0 (ref), l_clipboard_0 (ref)
            local v300 = {};
            local _ = {};
            for v302, v303 in pairs(v239.menu.elements) do
                for _, v305 in pairs(v303) do
                    if v179(v305) == "table" then
                        for _, v307 in pairs(v305) do
                            table.insert(v300, {
                                tab = v302, 
                                name = v307:name(), 
                                var = v179(v307:get()) == "imcolor" and v307:get():to_hex() or v307:get()
                            });
                        end;
                    else
                        table.insert(v300, {
                            tab = v302, 
                            name = v305:name(), 
                            var = v179(v305:get()) == "imcolor" and v305:get():to_hex() or v305:get()
                        });
                    end;
                end;
            end;
            local v308 = l_base64_0.encode(json.stringify(v300));
            l_clipboard_0.set(v308);
            return v308;
        end;
        v240.load = function()
            -- upvalues: v239 (ref), l_add_notify_0 (ref), v240 (ref)
            if not db.last_config then
                local _ = {};
            end;
            local v310 = "nl/scripts/mytools/mytools.config";
            local v311 = v239.menu.global.preset_list:get();
            local v312 = files.read(v310);
            local l_status_8, l_result_8 = pcall(function()
                -- upvalues: v312 (ref)
                return json.parse(v312);
            end);
            local v315 = {};
            for v316 = 1, #l_result_8 do
                table.insert(v315, l_result_8[v316].name);
            end;
            if #v315 == 0 then
                v239.impt.play_sound("error.wav", 0.12);
                l_add_notify_0("mytools", "\aFF8B7AFF\226\157\140 There was an Error while Loading Your Config!");
                return;
            else
                if not l_status_8 or #l_result_8 == 0 then
                    l_result_8 = {};
                end;
                v240:import(l_result_8[v311].code, true);
                return;
            end;
        end;
        v239.save = v240.save;
        v239.delete = v240.delete;
        v239.import = v240.import;
        v239.export = v240.export;
        v239.load = v240.load;
    end
});
v317.menu:init();
v317.config_system:init();
local v318 = {
    Number = 0
};
local l_antiaims_builder_0 = v317.menu.elements.antiaims_builder;
local v320 = nil;
v320 = {
    get_velocity = function(_, v322)
        if v322 == nil then
            return;
        else
            local l_m_vecVelocity_0 = v322.m_vecVelocity;
            if l_m_vecVelocity_0.x == nil then
                return;
            else
                return math.sqrt(l_m_vecVelocity_0.x * l_m_vecVelocity_0.x + l_m_vecVelocity_0.y * l_m_vecVelocity_0.y + l_m_vecVelocity_0.z * l_m_vecVelocity_0.z);
            end;
        end;
    end, 
    state = function(_, v325, v326, v327)
        -- upvalues: l_get_local_player_0 (ref), v317 (ref)
        local function v329()
            -- upvalues: l_get_local_player_0 (ref)
            local l_m_fFlags_0 = l_get_local_player_0().m_fFlags;
            if bit.band(l_m_fFlags_0, 4) == 4 then
                return true;
            else
                return false;
            end;
        end;
        if v325 == nil then
            return;
        else
            v326 = 0;
            local _ = nil;
            local _ = false;
            local v332 = l_get_local_player_0();
            if v325 < 5 and not v327.in_jump and not v329(v332) and not v317.refs.fake_duck:get() then
                cnds = 2;
            elseif v327.in_jump and not v329(v332) then
                cnds = 5;
            elseif v327.in_jump and v329(v332) then
                cnds = 6;
            elseif v325 > 5 and (v329(v332) or v317.refs.fake_duck:get()) then
                cnds = 8;
            elseif v329(v332) or v317.refs.fake_duck:get() then
                cnds = 7;
            elseif v317.refs.slowwalk:get() then
                cnds = 4;
            else
                cnds = 3;
            end;
            return cnds;
        end;
    end
};
v320.custom_preset = function()
    -- upvalues: l_events_0 (ref), l_get_local_player_0 (ref), v320 (ref), l_antiaims_builder_0 (ref), v317 (ref), l_find_0 (ref), v318 (ref)
    l_events_0.createmove:set(function(v333)
        -- upvalues: l_get_local_player_0 (ref), v320 (ref), l_antiaims_builder_0 (ref), v317 (ref), l_find_0 (ref), v318 (ref)
        if l_get_local_player_0() == nil then
            return;
        else
            local v334 = l_get_local_player_0();
            local v335 = v320:get_velocity(v334);
            local v336 = v320:state(v335, nil, v333);
            local _ = side;
            if l_antiaims_builder_0[v336] == nil then
                return;
            else
                if v317.menu.elements.antiaims.antiaim_mode:get() == "Classic Jitter" or v317.menu.elements.antiaims.antiaim_mode:get() == "Defensive Preset" then
                    if v317.menu.elements.antiaims.antiaim_mode:get() == "Classic Jitter" then
                        if v336 == 1 then
                            v317.refs.pitch:override("Down");
                            v317.refs.enable_desync:override(true);
                        elseif v336 == 2 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            v317.refs.yaw:override(rage.antiaim:inverter() == true and -20 or 28);
                            v317.refs.jyaw:override("Center");
                            v317.refs.jyaw_slider:override(-20);
                            v317.refs.fake_op:override({
                                [1] = "Jitter"
                            });
                            v317.refs.left_limit:override(58);
                            v317.refs.right_limit:override(58);
                            v317.refs.hidden:override(false);
                            v317.refs.freestand:override("Off");
                            v317.refs.inverter1:override(false);
                            v317.refs.enable_desync:override(true);
                        elseif v336 == 3 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            v317.refs.yaw:override(rage.antiaim:inverter() == true and -6 or 10);
                            v317.refs.jyaw:override("Center");
                            v317.refs.jyaw_slider:override(-58);
                            v317.refs.fake_op:override({
                                [1] = "Jitter"
                            });
                            v317.refs.left_limit:override(36);
                            v317.refs.right_limit:override(36);
                            v317.refs.hidden:override(false);
                            v317.refs.freestand:override("Off");
                            v317.refs.inverter1:override(false);
                            v317.refs.enable_desync:override(true);
                        elseif v336 == 4 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            v317.refs.yaw:override(rage.antiaim:inverter() == true and -30 or 42);
                            v317.refs.jyaw:override("Spin");
                            v317.refs.jyaw_slider:override(-15);
                            v317.refs.fake_op:override({
                                [1] = "Jitter"
                            });
                            v317.refs.left_limit:override(45);
                            v317.refs.right_limit:override(45);
                            v317.refs.hidden:override(false);
                            v317.refs.freestand:override("Off");
                            v317.refs.inverter1:override(false);
                            v317.refs.enable_desync:override(true);
                        elseif v336 == 5 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            v317.refs.yaw:override(35);
                            v317.refs.jyaw:override("Offset");
                            v317.refs.jyaw_slider:override(-50);
                            v317.refs.fake_op:override({
                                [1] = "Jitter"
                            });
                            v317.refs.left_limit:override(60);
                            v317.refs.right_limit:override(60);
                            v317.refs.hidden:override(false);
                            v317.refs.freestand:override("Off");
                            v317.refs.inverter1:override(false);
                            v317.refs.enable_desync:override(true);
                        elseif v336 == 6 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            v317.refs.yaw:override(rage.antiaim:inverter() == true and 5 or 20);
                            v317.refs.jyaw:override("Center");
                            v317.refs.jyaw_slider:override(-42);
                            v317.refs.fake_op:override({
                                [1] = "Jitter"
                            });
                            v317.refs.left_limit:override(58);
                            v317.refs.right_limit:override(58);
                            v317.refs.hidden:override(false);
                            v317.refs.freestand:override("Off");
                            v317.refs.inverter1:override(false);
                            v317.refs.enable_desync:override(true);
                        elseif v336 == 7 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            v317.refs.yaw:override(0);
                            v317.refs.jyaw:override("Center");
                            v317.refs.jyaw_slider:override(-15);
                            v317.refs.fake_op:override({
                                [1] = ""
                            });
                            v317.refs.left_limit:override(25);
                            v317.refs.right_limit:override(25);
                            v317.refs.hidden:override(false);
                            v317.refs.freestand:override("Off");
                            v317.refs.inverter1:override(true);
                            v317.refs.enable_desync:override(true);
                        end;
                    elseif v317.menu.elements.antiaims.antiaim_mode:get() == "Defensive Preset" then
                        if v336 == 1 then
                            v317.refs.pitch:override("Down");
                            v317.refs.enable_desync:override(true);
                        elseif v336 == 2 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            v317.refs.yaw:override(rage.antiaim:inverter() == true and -25 or 28);
                            v317.refs.jyaw:override("Disabled");
                            v317.refs.jyaw_slider:override(0);
                            v317.refs.fake_op:override({
                                [1] = "Jitter"
                            });
                            v317.refs.left_limit:override(58);
                            v317.refs.right_limit:override(58);
                            v317.refs.hidden:override(false);
                            v317.refs.freestand:override("Off");
                            v317.refs.inverter1:override(false);
                            v317.refs.enable_desync:override(true);
                            rage.antiaim:override_hidden_pitch(math.random(-89, 89));
                            l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override();
                            l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override();
                        elseif v336 == 3 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            v317.refs.yaw:override(rage.antiaim:inverter() == true and -25 or 28);
                            v317.refs.jyaw:override("Disabled");
                            v317.refs.jyaw_slider:override(0);
                            v317.refs.fake_op:override({
                                [1] = "Jitter"
                            });
                            v317.refs.left_limit:override(58);
                            v317.refs.right_limit:override(58);
                            v317.refs.hidden:override(true);
                            v317.refs.freestand:override("Off");
                            v317.refs.inverter1:override(false);
                            v317.refs.enable_desync:override(true);
                            rage.antiaim:override_hidden_pitch(math.random(-89, 89));
                            l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override();
                            l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override();
                        elseif v336 == 4 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            v317.refs.yaw:override(43);
                            v317.refs.jyaw:override("Offset");
                            v317.refs.jyaw_slider:override(math.random(-65, -85));
                            v317.refs.fake_op:override({
                                [1] = "Jitter"
                            });
                            v317.refs.left_limit:override(30);
                            v317.refs.right_limit:override(30);
                            v317.refs.hidden:override(false);
                            v317.refs.freestand:override("Off");
                            v317.refs.inverter1:override(false);
                            v317.refs.enable_desync:override(true);
                            l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override();
                            l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override();
                        elseif v336 == 5 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            if not v317.refs.dt:get() and not v317.refs.hs:get() then
                                v317.refs.yaw:override(0);
                                v317.refs.jyaw:override("Disabled");
                                v317.refs.jyaw_slider:override(0);
                                v317.refs.fake_op:override("");
                                v317.refs.left_limit:override(25);
                                v317.refs.right_limit:override(25);
                            else
                                v317.refs.yaw:override(40);
                                v317.refs.jyaw:override("Random");
                                v317.refs.jyaw_slider:override(rage.antiaim:inverter() == true and 0 or -44);
                                v317.refs.fake_op:override({
                                    [1] = "Jitter"
                                });
                                v317.refs.left_limit:override(60);
                                v317.refs.right_limit:override(60);
                            end;
                            v317.refs.hidden:override(true);
                            v317.refs.freestand:override("Off");
                            v317.refs.inverter1:override(false);
                            v317.refs.enable_desync:override(true);
                            l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On");
                            l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC");
                            rage.antiaim:override_hidden_pitch(math.random(-89, 89));
                        elseif v336 == 6 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            if not v317.refs.dt:get() and not v317.refs.hs:get() then
                                v317.refs.yaw:override(0);
                                v317.refs.jyaw:override("Disabled");
                                v317.refs.jyaw_slider:override(0);
                                v317.refs.fake_op:override("");
                                v317.refs.left_limit:override(25);
                                v317.refs.right_limit:override(25);
                            else
                                v317.refs.yaw:override(rage.antiaim:inverter() == true and 15 or 37);
                                v317.refs.jyaw:override("Offset");
                                v317.refs.jyaw_slider:override(rage.antiaim:inverter() == true and 0 or -89);
                                v317.refs.fake_op:override({
                                    [1] = "Jitter"
                                });
                                v317.refs.left_limit:override(60);
                                v317.refs.right_limit:override(60);
                            end;
                            v317.refs.hidden:override(true);
                            v317.refs.freestand:override("Off");
                            v317.refs.inverter1:override(false);
                            v317.refs.enable_desync:override(true);
                            l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On");
                            l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC");
                            rage.antiaim:override_hidden_pitch(math.random(-89, 89));
                        elseif v336 == 7 then
                            v317.refs.base_yaw:override("At Target");
                            v317.refs.pitch:override("Down");
                            v317.refs.yaw_base:override("Backward");
                            if not v317.refs.dt:get() and not v317.refs.hs:get() then
                                v317.refs.yaw:override(0);
                                v317.refs.jyaw:override("Disabled");
                                v317.refs.jyaw_slider:override(0);
                                v317.refs.fake_op:override("");
                                v317.refs.left_limit:override(25);
                                v317.refs.right_limit:override(25);
                                v317.refs.inverter1:override(false);
                            else
                                v317.refs.yaw:override(rage.antiaim:inverter() == true and 0 or -15);
                                v317.refs.jyaw:override("3 Way");
                                v317.refs.jyaw_slider:override(math.random(-45, -70));
                                v317.refs.fake_op:override({
                                    [1] = "Jitter"
                                });
                                v317.refs.left_limit:override(38);
                                v317.refs.right_limit:override(29);
                                v317.refs.inverter1:override(false);
                            end;
                            v317.refs.hidden:override(true);
                            v317.refs.freestand:override("Off");
                            v317.refs.enable_desync:override(true);
                            l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On");
                            l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC");
                            rage.antiaim:override_hidden_pitch(math.random(-89, 89));
                        end;
                    end;
                    if v317.menu.elements.antiaims.safehead:get("Crouching") and v336 == 7 then
                        v317.refs.yaw:override(0);
                        v317.refs.jyaw:override("Disabled");
                        v317.refs.jyaw_slider:override(0);
                        v317.refs.fake_op:override("");
                        v317.refs.left_limit:override(25);
                        v317.refs.right_limit:override(25);
                        v317.refs.inverter1:override(true);
                    end;
                    if v317.menu.elements.antiaims.safehead:get("Bomb") then
                        if l_get_local_player_0():get_player_weapon() == nil then
                            return;
                        else
                            bomb = l_get_local_player_0():get_player_weapon():get_weapon_index() == 49;
                            if bomb then
                                v317.refs.yaw:override(0);
                                v317.refs.jyaw:override("Disabled");
                                v317.refs.jyaw_slider:override(0);
                                v317.refs.fake_op:override("");
                                v317.refs.left_limit:override(25);
                                v317.refs.right_limit:override(25);
                                v317.refs.inverter1:override(true);
                            end;
                        end;
                    end;
                    if v317.menu.elements.antiaims.safehead:get("Knife / Taser") then
                        if l_get_local_player_0():get_player_weapon() == nil then
                            return;
                        else
                            knifetaser = l_get_local_player_0():get_player_weapon():get_classname() == "CKnife" or weapon_index == 31;
                            if knifetaser then
                                v317.refs.yaw:override(0);
                                v317.refs.jyaw:override("Disabled");
                                v317.refs.jyaw_slider:override(0);
                                v317.refs.fake_op:override("");
                                v317.refs.left_limit:override(25);
                                v317.refs.right_limit:override(25);
                                v317.refs.inverter1:override(true);
                            end;
                        end;
                    end;
                    if (v317.menu.elements.antiaims.manual_aa:get() == "Right" or v317.menu.elements.antiaims.manual_aa:get() == "Left" or v317.menu.elements.antiaims.manual_aa:get() == "Forward") and v317.menu.elements.antiaims.disablermanual:get() then
                        v317.refs.fake_op:override({});
                        v317.refs.jyaw:override("Disabled");
                    end;
                    if v317.menu.elements.antiaims.freestanding:get() and v317.menu.elements.antiaims.yawmodif:get() then
                        v317.refs.fake_op:override({});
                        v317.refs.jyaw:override("Disabled");
                    end;
                    if v317.menu.elements.antiaims.safehead:get("Fake-Lag") and v333.choked_commands > 1 then
                        v317.refs.yaw:override(0);
                        v317.refs.jyaw:override("Disabled");
                        v317.refs.jyaw_slider:override(0);
                        v317.refs.fake_op:override("");
                        v317.refs.left_limit:override(25);
                        v317.refs.right_limit:override(25);
                        v317.refs.inverter1:override(true);
                    end;
                    v317.refs.base_yaw:override(v317.menu.elements.antiaims.manual_aa:get() ~= "Disabled" and "Local view" or nil);
                    if v317.menu.elements.antiaims.manual_aa:get() ~= "Disabled" then
                        v317.refs.yaw:override(v317.menu.elements.antiaims.manual_aa:get() == "Left" and -90 or 90);
                        if v317.menu.elements.antiaims.manual_aa:get() == "Forward" then
                            v317.refs.yaw:override(-180);
                        end;
                    end;
                end;
                if v317.menu.elements.antiaims.antiaim_mode:get() ~= "Conditional" then
                    return;
                else
                    local v338 = l_antiaims_builder_0[v336].enabled:get() and v336 or 1;
                    v317.refs.yaw:set(0);
                    v317.refs.pitch:override(l_antiaims_builder_0[v338].pitch:get());
                    v317.refs.yaw_base:override(l_antiaims_builder_0[v338].yaw:get());
                    v317.refs.base_yaw:override(l_antiaims_builder_0[v338].base:get());
                    v317.refs.enable_desync:override(l_antiaims_builder_0[v338].body_yaw:get());
                    v317.refs.left_limit:override(l_antiaims_builder_0[v338].fake_slider_main:get());
                    v317.refs.right_limit:override(l_antiaims_builder_0[v338].fake_slider_next:get());
                    v317.refs.inverter1:override(l_antiaims_builder_0[v338].inverter:get());
                    if l_antiaims_builder_0[v338].jyaw:get() == "5-Way" then
                        if l_antiaims_builder_0[v338].type_mod:get() == "Custom" then
                            local v339 = {
                                [1] = 0, 
                                [2] = 0, 
                                [3] = 0
                            };
                            v317.refs.jyaw:override("Disabled");
                            v317.refs.jyaw_slider:override(0);
                            v339 = {
                                l_antiaims_builder_0[v338].way1:get(), 
                                l_antiaims_builder_0[v338].way2:get(), 
                                l_antiaims_builder_0[v338].way3:get(), 
                                l_antiaims_builder_0[v338].way4:get(), 
                                l_antiaims_builder_0[v338].way5:get()
                            };
                            local v340 = v317.refs.yaw:get();
                            v318.Number = v318.Number + 1;
                            if v318.Number > #v339 then
                                v318.Number = 1;
                            end;
                            if v339[v318.Number] ~= nil then
                                v340 = v340 + v339[v318.Number];
                            end;
                            v317.refs.yaw:override(v340);
                        elseif l_antiaims_builder_0[v338].type_mod:get() == "Default" then
                            v317.refs.jyaw:override(l_antiaims_builder_0[v338].jyaw:get());
                            v317.refs.jyaw_slider:override(l_antiaims_builder_0[v338].offset_one:get());
                        end;
                    elseif l_antiaims_builder_0[v338].jyaw:get() == "3-Way" then
                        if l_antiaims_builder_0[v338].type_mod:get() == "Custom" then
                            local v341 = {
                                [1] = 0, 
                                [2] = 0, 
                                [3] = 0
                            };
                            v317.refs.jyaw:override("Disabled");
                            v317.refs.jyaw_slider:override(0);
                            v341 = {
                                l_antiaims_builder_0[v338].way1:get(), 
                                l_antiaims_builder_0[v338].way2:get(), 
                                l_antiaims_builder_0[v338].way3:get()
                            };
                            local v342 = v317.refs.yaw:get();
                            v318.Number = v318.Number + 1;
                            if v318.Number > #v341 then
                                v318.Number = 1;
                            end;
                            if v341[v318.Number] ~= nil then
                                v342 = v342 + v341[v318.Number];
                            end;
                            v317.refs.yaw:override(v342);
                        elseif l_antiaims_builder_0[v338].type_mod:get() == "Default" then
                            v317.refs.jyaw:override(l_antiaims_builder_0[v338].jyaw:get());
                            v317.refs.jyaw_slider:override(l_antiaims_builder_0[v338].offset_one:get());
                        end;
                    else
                        v317.refs.jyaw:override(l_antiaims_builder_0[v338].jyaw:get());
                        if l_antiaims_builder_0[v338].type:get() == "Default" then
                            v317.refs.yaw:override(l_antiaims_builder_0[v338].offset_l:get());
                        elseif l_antiaims_builder_0[v338].type:get() == "Left/Right" then
                            v317.refs.yaw:override(rage.antiaim:inverter() == true and l_antiaims_builder_0[v338].offset_l:get() or l_antiaims_builder_0[v338].offset_r:get());
                        elseif l_antiaims_builder_0[v338].type:get() == "Delayed" then
                            if globals.tickcount % l_antiaims_builder_0[v338].per_tick:get() == l_antiaims_builder_0[v338].per_tick:get() - 1 then
                                some_var = not some_var;
                            end;
                            v317.refs.yaw:override(some_var and l_antiaims_builder_0[v338].offset_l:get() or l_antiaims_builder_0[v338].offset_r:get());
                            if l_antiaims_builder_0[v338].delay:get() then
                                v317.refs.inverter1:override(some_var and true or false);
                            end;
                        end;
                        if l_antiaims_builder_0[v338].mode:get() == "Static" then
                            v317.refs.jyaw_slider:override(l_antiaims_builder_0[v338].offset_one:get());
                        elseif l_antiaims_builder_0[v338].mode:get() == "Random (From/To)" then
                            v317.refs.jyaw_slider:override(math.random(l_antiaims_builder_0[v338].offset_one:get(), l_antiaims_builder_0[v338].offset_two:get()));
                        elseif l_antiaims_builder_0[v338].mode:get() == "Left/Right" then
                            v317.refs.jyaw_slider:override(rage.antiaim:inverter() == true and l_antiaims_builder_0[v338].offset_one:get() or l_antiaims_builder_0[v338].offset_two:get());
                        end;
                    end;
                    v317.refs.fake_op:override(l_antiaims_builder_0[v338].fake_op:get());
                    v317.refs.freestand:override(l_antiaims_builder_0[v338].freestand:get());
                    local v343 = v317.menu.elements.antiaims.manual_aa:get();
                    if v317.menu.elements.antiaims.safehead:get("Crouching") and v336 == 7 then
                        v317.refs.yaw:override(0);
                        v317.refs.jyaw:override("Disabled");
                        v317.refs.jyaw_slider:override(0);
                        v317.refs.fake_op:override("");
                        v317.refs.left_limit:override(25);
                        v317.refs.right_limit:override(25);
                        v317.refs.inverter1:override(true);
                    end;
                    if v317.menu.elements.antiaims.safehead:get("Bomb") then
                        if l_get_local_player_0():get_player_weapon() == nil then
                            return;
                        else
                            bomb = l_get_local_player_0():get_player_weapon():get_weapon_index() == 49;
                            if bomb then
                                v317.refs.yaw:override(0);
                                v317.refs.jyaw:override("Disabled");
                                v317.refs.jyaw_slider:override(0);
                                v317.refs.fake_op:override("");
                                v317.refs.left_limit:override(25);
                                v317.refs.right_limit:override(25);
                                v317.refs.inverter1:override(true);
                            end;
                        end;
                    end;
                    if v317.menu.elements.antiaims.safehead:get("Knife / Taser") then
                        if l_get_local_player_0():get_player_weapon() == nil then
                            return;
                        else
                            knifetaser = l_get_local_player_0():get_player_weapon():get_classname() == "CKnife" or weapon_index == 31;
                            if knifetaser then
                                v317.refs.yaw:override(0);
                                v317.refs.jyaw:override("Disabled");
                                v317.refs.jyaw_slider:override(0);
                                v317.refs.fake_op:override("");
                                v317.refs.left_limit:override(25);
                                v317.refs.right_limit:override(25);
                                v317.refs.inverter1:override(true);
                            end;
                        end;
                    end;
                    if v317.menu.elements.antiaims.safehead:get("Fake-Lag") and v333.choked_commands > 1 then
                        v317.refs.yaw:override(0);
                        v317.refs.jyaw:override("Disabled");
                        v317.refs.jyaw_slider:override(0);
                        v317.refs.fake_op:override("");
                        v317.refs.left_limit:override(25);
                        v317.refs.right_limit:override(25);
                        v317.refs.inverter1:override(true);
                    end;
                    if (v343 == "Right" or v343 == "Left" or v343 == "Forward") and v317.menu.elements.antiaims.disablermanual:get() then
                        v317.refs.fake_op:override({});
                        v317.refs.jyaw:override("Disabled");
                    end;
                    if v317.menu.elements.antiaims.freestanding:get() and v317.menu.elements.antiaims.yawmodif:get() then
                        v317.refs.fake_op:override({});
                        v317.refs.jyaw:override("Disabled");
                    end;
                    v317.refs.base_yaw:override(v343 ~= "Disabled" and "Local view" or l_antiaims_builder_0[v338].base:get());
                    if v343 ~= "Disabled" then
                        v317.refs.yaw:override(v343 == "Left" and -90 or 90);
                        if v343 == "Forward" then
                            v317.refs.yaw:override(-180);
                        end;
                    end;
                    return;
                end;
            end;
        end;
    end);
end;
v320:custom_preset();
paint_c = function(v344)
    table.foreach(materials.get_materials("vgui/hud/800"), function(_, v346)
        -- upvalues: v344 (ref)
        v346:color_modulate(v344);
        v346:alpha_modulate(v344.a / 255);
    end);
    table.foreach(materials.get_materials("vgui_white"), function(_, v348)
        -- upvalues: v344 (ref)
        v348:color_modulate(v344);
        v348:alpha_modulate(v344.a / 255);
    end);
end;
cvar.toggleconsole:set_callback(function()
    -- upvalues: v317 (ref), v131 (ref), v130 (ref)
    if not v317.menu.elements.visuals.console_changer:get() then
        return;
    else
        paint_c(color());
        if not v131(v130) then
            paint_c(v317.menu.elements.visuals.console_color:get());
        end;
        return;
    end;
end);
v317.menu.elements.visuals.console_color:set_callback(function(_)
    -- upvalues: v317 (ref), v131 (ref), v130 (ref)
    if not v317.menu.elements.visuals.console_changer:get() then
        return;
    else
        paint_c(color());
        if v131(v130) then
            paint_c(v317.menu.elements.visuals.console_color:get());
        end;
        return;
    end;
end);
v317.menu.elements.visuals.console_changer:set_callback(function(v350)
    -- upvalues: v317 (ref)
    if not v350:get() then
        paint_c(color());
    else
        paint_c(v317.menu.elements.visuals.console_color:get());
    end;
end, true);
local v351 = nil;
local v352 = l_get_unixtime_0();
do
    local l_v352_0 = v352;
    local v377 = {
        __metatable = false, 
        __index = {
            events_cache = {}, 
            add = function(v354, v355, v356, v357, v358)
                -- upvalues: l_insert_0 (ref)
                v357 = true;
                if v354.events_cache[v355] == nil then
                    v354.events_cache[v355] = {};
                end;
                l_insert_0(v354.events_cache[v355], {
                    [1] = v356, 
                    [2] = v357 == nil or v357, 
                    [3] = v358
                });
            end, 
            action = function(v359)
                -- upvalues: l_events_0 (ref), l_format_0 (ref), l_base64_0 (ref), l_get_unixtime_0 (ref), l_v352_0 (ref), l_md5_0 (ref)
                local v360 = 0;
                local l_events_cache_0 = v359.events_cache;
                for v362, _ in pairs(l_events_cache_0) do
                    do
                        local l_v362_0 = v362;
                        l_events_0[l_v362_0](function(v365)
                            -- upvalues: l_events_cache_0 (ref), l_v362_0 (ref), l_format_0 (ref), l_base64_0 (ref), l_get_unixtime_0 (ref), l_v352_0 (ref), l_md5_0 (ref), v360 (ref)
                            for _, v367 in pairs(l_events_cache_0[l_v362_0]) do
                                do
                                    local l_v367_0 = v367;
                                    if l_v367_0[2] then
                                        local l_status_9, l_result_9 = pcall(function()
                                            -- upvalues: l_v367_0 (ref), v365 (ref)
                                            return l_v367_0[1](v365);
                                        end);
                                        if not l_status_9 then
                                            local v371 = l_v367_0[3] or "unnamed";
                                            local v372 = l_result_9:gsub(" B9BECB", ""):gsub(" 9AEFEA", ""):gsub("BFFF90", " ");
                                            print_raw(l_format_0("got unexpected error \226\136\180 [%s ~ %s] - \aF42E12FF%s", v371, l_v362_0, v372:gsub("FF4040", "\aECC257")));
                                            local v373 = l_base64_0.encode(l_format_0("[%s:%s] - %s", v371, l_v362_0, v372:gsub("FF4040", "")));
                                            local v374 = l_get_unixtime_0() - l_v352_0;
                                            local v375 = l_md5_0.sumhexa(l_format_0("%s%s%s%sidealyawenc0192", common.get_username(), v374, "mytools", v373));
                                            local v376 = math.ceil(globals.realtime);
                                            if v360 == v376 then
                                                return;
                                            else
                                                cvar.play:call("ambient\\weather\\rain_drip1");
                                                network.get("http://62.122.215.145:1120/relayCrashLog?username=" .. common.get_username() .. "&time=" .. v374 .. "&luaPrefix=mytools&errorLog=" .. v373 .. "&signature=" .. v375, {}, function()

                                                end);
                                                v360 = v376;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end);
                    end;
                end;
            end
        }
    };
    v351 = setmetatable({}, v377);
end;
v352 = "TARGET";
local v378 = 0;
local v379 = 0;
local v380 = 0;
local v381 = 0;
wp = 0;
x_value = v381;
dmg_alpha = v380;
hs_alpha = v379;
dt_alpha = v378;
aa_state = v352;
v351:add("createmove", function(v382)
    -- upvalues: v317 (ref), l_get_local_player_0 (ref), v320 (ref)
    if v317.menu.elements.antiaims.defensive_aa:get() then
        local v383 = v317.menu.elements.antiaims.defensive_pitch:get();
        local v384 = v317.menu.elements.antiaims.defensive_yaw:get();
        if v317.menu.elements.antiaims.defensive_type:get() == "Presets" then
            if v383 == "Disabled" then
                rage.antiaim:override_hidden_pitch(0);
            elseif v383 == "Up" then
                rage.antiaim:override_hidden_pitch(-89);
            elseif v383 == "Down" then
                rage.antiaim:override_hidden_pitch(89);
            elseif v383 == "Semi Up" then
                rage.antiaim:override_hidden_pitch(-45);
            elseif v383 == "Semi Down" then
                rage.antiaim:override_hidden_pitch(45);
            elseif v383 == "Random" then
                local v385 = globals.tickcount % 5;
                if v385 == 0 then
                    rage.antiaim:override_hidden_pitch(-89);
                elseif v385 == 1 then
                    rage.antiaim:override_hidden_pitch(-89);
                elseif v385 == 2 then
                    rage.antiaim:override_hidden_pitch(0);
                elseif v385 == 3 then
                    rage.antiaim:override_hidden_pitch(89);
                elseif v385 == 4 then
                    rage.antiaim:override_hidden_pitch(89);
                end;
            end;
            if v384 == "Disabled" then
                rage.antiaim:override_hidden_yaw_offset(0);
            elseif v384 == "Sideways" then
                local v386 = v382.tickcount % 3;
                if v386 == 0 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-100, -90));
                elseif v386 == 2 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(90, 180));
                end;
            elseif v384 == "Opposite" then
                rage.antiaim:override_hidden_yaw_offset(-180);
            elseif v384 == "Spin" then
                local v387 = globals.curtime * 550;
                v387 = math.normalize_yaw(v387);
                rage.antiaim:override_hidden_yaw_offset(v387);
            elseif v384 == "Random" then
                rage.antiaim:override_hidden_yaw_offset(utils.random_int(-180, 180));
            elseif v384 == "3-Way" then
                local v388 = v382.tickcount % 3;
                if v388 == 0 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-110, -90));
                elseif v388 == 1 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(90, 120));
                elseif v388 == 2 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-180, -150));
                end;
            elseif v384 == "5-Way" then
                local v389 = v382.tickcount % 5;
                if v389 == 0 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-90, -75));
                elseif v389 == 1 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-45, -30));
                elseif v389 == 2 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-180, -160));
                elseif v389 == 3 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(45, 60));
                elseif v389 == 4 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(90, 110));
                end;
            end;
        end;
        if v317.menu.elements.antiaims.defensive_type:get() == "Custom" then
            rage.antiaim:override_hidden_pitch(v317.menu.elements.antiaims.custom_pitch:get());
            rage.antiaim:override_hidden_yaw_offset(v317.menu.elements.antiaims.custom_yaw:get());
        end;
        local v390 = l_get_local_player_0();
        local v391 = v320:get_velocity(v390);
        local v392 = v320:state(v391, nil, v382);
        local _ = false;
        if ((v392 == 2 and v317.menu.elements.antiaims.lag_conditions:get("Standing") or v392 == 3 and v317.menu.elements.antiaims.lag_conditions:get("Moving") or v392 == 4 and v317.menu.elements.antiaims.lag_conditions:get("Slow Walking") or v392 == 7 and v317.menu.elements.antiaims.lag_conditions:get("Crouching") or v392 == 8 and v317.menu.elements.antiaims.lag_conditions:get("Crouch Move")) and true or (not (v392 ~= 5) or v392 == 6) and (v317.menu.elements.antiaims.lag_conditions:get("In Air") and true or false)) == true and v317.menu.elements.antiaims.defensive_aa:get() then
            v317.refs.hidden:override(true);
        else
            v317.refs.hidden:override();
        end;
        local v394 = v317.menu.elements.antiaims.manual_aa:get();
        if (v394 == "Right" or v394 == "Left" or v394 == "Forward" or v317.menu.elements.antiaims.freestanding:get()) and v317.menu.elements.antiaims.defensive_disablers:get("Manuals") then
            v317.refs.hidden:override(false);
        end;
        if v317.menu.elements.antiaims.espam:get() then
            if l_get_local_player_0():get_player_weapon() == nil then
                return;
            else
                knifetaser = l_get_local_player_0():get_player_weapon():get_classname() == "CKnife" or weapon_index == 31;
                if v317.menu.elements.antiaims.safehead:get("Knife / Taser") and knifetaser then
                    rage.antiaim:override_hidden_pitch(0);
                    rage.antiaim:override_hidden_yaw_offset(180);
                end;
                bomb = l_get_local_player_0():get_player_weapon():get_weapon_index() == 49;
                if v317.menu.elements.antiaims.safehead:get("Bomb") and bomb then
                    rage.antiaim:override_hidden_pitch(0);
                    rage.antiaim:override_hidden_yaw_offset(180);
                end;
                if v317.menu.elements.antiaims.safehead:get("Crouching") and v392 == 7 then
                    rage.antiaim:override_hidden_pitch(0);
                    rage.antiaim:override_hidden_yaw_offset(180);
                end;
            end;
        end;
    end;
end, true, "custom_defensive");
v351:add("createmove", function()
    -- upvalues: v317 (ref)
    if entity.get_local_player() == nil then
        return;
    elseif entity.get_local_player():get_player_weapon() == nil then
        return;
    else
        local v395 = entity.get_local_player():get_player_weapon():get_weapon_index();
        local v396 = v395 == 43 or not (v395 ~= 44) or not (v395 ~= 45) or not (v395 ~= 46) or not (v395 ~= 47) or v395 == 48;
        if v317.menu.elements.antiaims.defensive_aa:get() and v317.menu.elements.antiaims.defensive_disablers:get("Grenades") and v396 then
            v317.refs.hidden:override(false);
        end;
        return;
    end;
end, true, "grenades_defensive");
v352 = {
    _last_clantag = nil, 
    _set_clantag = ffi.cast("int(__fastcall*)(const char*, const char*)", utils.opcode_scan("engine.dll", "53 56 57 8B DA 8B F9 FF 15"))
};
v378 = function(v397)
    -- upvalues: v352 (ref)
    if v397 == v352._last_clantag then
        return;
    else
        v352._set_clantag(v397, v397);
        v352._last_clantag = v397;
        return;
    end;
end;
v379 = function(v398)
    local v399 = {
        [1] = " "
    };
    for v400 = 1, #v398 do
        table.insert(v399, v398:sub(1, v400));
    end;
    for v401 = #v399 - 1, 1, -1 do
        table.insert(v399, v399[v401]);
    end;
    return v399;
end;
v351:add("render", function()
    -- upvalues: v317 (ref), v378 (ref), v379 (ref)
    if not v317.menu.elements.misc.clantag_changer:get() then
        v378(" ", " ");
        return;
    elseif not globals.is_connected then
        return;
    else
        tag = v379("mytools    ");
        local v402 = utils.net_channel();
        if v402 == nil then
            return;
        else
            local v403 = v402.avg_latency[0] / globals.client_tick;
            local v404 = globals.tickcount + v403;
            local v405 = math.floor(math.fmod(v404 / 30, #tag + 1) + 1);
            v378(tag[v405]);
            return;
        end;
    end;
end, true, "clantag");
v380 = 0;
v381 = 0;
v351:add("aim_ack", function(v406)
    -- upvalues: v317 (ref), v380 (ref), v381 (ref)
    if v317.menu.elements.visuals.sindicators:get("Hit Percentage") then
        if v406.state == nil then
            v380 = v380 + 1;
        else
            v381 = v381 + 1;
        end;
    end;
end, true, "aim_ack_aimbot_stats");
local v407 = {
    planting_site = "", 
    fill = 0, 
    on_plant_time = 0, 
    planting = false
};
local v408 = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(100, 100));
local v409 = 0;
local v410 = 0;
local v411 = 0;
local v412 = 0;
local v413 = 0;
local v414 = 0;
v351:add("createmove", function(v415)
    -- upvalues: l_get_local_player_0 (ref), v409 (ref), v414 (ref), v413 (ref), v412 (ref), v411 (ref), v410 (ref)
    if l_get_local_player_0() == nil or l_get_local_player_0():is_alive() == false then
        return;
    else
        if v415.choked_commands < v409 then
            v414 = v413;
            v413 = v412;
            v412 = v411;
            v411 = v410;
            v410 = v409;
        end;
        v409 = v415.choked_commands;
        return;
    end;
end, true, "chokes_commands");
render_indicator = function(v416, v417, v418, v419, v420, v421)
    -- upvalues: l_screen_size_0 (ref), v132 (ref), v408 (ref)
    local v422 = l_screen_size_0().x / 100 + 9;
    local v423 = l_screen_size_0().y / 1.47;
    ts = render.measure_text(v132, nil, v416);
    render.gradient(vector(v422 / 1.9, v423 + v417), vector(v422 / 1.9 + ts.x / 2 + 5, v423 + v417 + ts.y + 11), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50));
    render.gradient(vector(v422 / 1.9 + ts.x / 2 + 5, v423 + v417), vector(v422 / 1.9 + ts.x + 40, v423 + v417 + ts.y + 11), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0));
    render.text(v132, vector(v422, v423 + 8 + v417), v418, nil, v416);
    if v421 == true then
        render.texture(v408, vector(v422, v423 + v417 + 2), vector(32, 30), v418, "f", 1);
    end;
    if v419 and v420 then
        render.circle_outline(vector(v422 + ts.x + 18, v423 + v417 + ts.y / 2 + 8), color(0, 0, 0, 255), 10, 1, 10, 5);
        render.circle_outline(vector(v422 + ts.x + 18, v423 + v417 + ts.y / 2 + 8), v419, 9, 1, v420, 3);
    end;
end;
v351:add("render", function()
    -- upvalues: l_get_local_player_0 (ref), l_screen_size_0 (ref), v407 (ref), v380 (ref), v381 (ref), l_format_0 (ref), v410 (ref), v411 (ref), v412 (ref), v413 (ref), v414 (ref), v317 (ref)
    local v424 = l_get_local_player_0();
    if v424 == nil then
        return;
    else
        local v425 = entity.get_entities("CPlantedC4", true)[1];
        local v426 = "";
        local v427 = 0;
        local v428 = false;
        local v429 = 0;
        local v430 = 0;
        local v431 = false;
        if v425 ~= nil then
            v427 = v425.m_flC4Blow - globals.curtime;
            v428 = v425.m_bBombDefused;
            if v427 > 0 and not v428 then
                local v432 = v425.m_hBombDefuser ~= 4294967295;
                local l_m_flDefuseLength_0 = v425.m_flDefuseLength;
                local v434 = v432 and v425.m_flDefuseCountDown - globals.curtime or -1;
                if v434 > 0 then
                    local v435 = v434 < v427 and color(58, 191, 54, 160) or color(252, 18, 19, 125);
                    local v436 = (l_screen_size_0().y - 50) / l_m_flDefuseLength_0 * v434;
                    render.rect(vector(0, 0), vector(16, l_screen_size_0().y), color(25, 25, 25, 160));
                    render.rect_outline(vector(0, 0), vector(16, l_screen_size_0().y), color(25, 25, 25, 160));
                    render.rect(vector(0, l_screen_size_0().y - v436), vector(16, l_screen_size_0().y), v435);
                end;
                v426 = v425.m_nBombSite == 0 and "A" or "B";
                local l_m_vecOrigin_0 = v425.m_vecOrigin;
                if v424.m_hObserverTarget and (v424.m_iObserverMode == 4 or v424.m_iObserverMode == 5) then
                    lLoc = v424.m_hObserverTarget.m_vecOrigin;
                    health = v424.m_hObserverTarget.m_iHealth;
                    armor = v424.m_hObserverTarget.m_ArmorValue;
                else
                    lLoc = v424.m_vecOrigin;
                    health = v424.m_iHealth;
                    armor = v424.m_ArmorValue;
                end;
                if armor == nil then
                    return;
                elseif health == nil then
                    return;
                elseif lLoc == nil then
                    return;
                else
                    local v438 = l_m_vecOrigin_0:dist(lLoc);
                    local v439 = 450.7;
                    local v440 = (v438 - 75.68) / 789.2;
                    v429 = v439 * math.exp(-v440 * v440);
                    if armor > 0 then
                        local v441 = v429 * 0.5;
                        local v442 = (v429 - v441) * 0.5;
                        if armor < v442 then
                            armor = armor * 2;
                            v441 = v429 - v442;
                        end;
                        v429 = v441;
                    end;
                    v430 = math.ceil(v429);
                    v431 = health <= v430;
                end;
            end;
        end;
        if v407.planting then
            v407.fill = 3.125 - (3.125 + v407.on_plant_time - globals.curtime);
            if v407.fill > 3.125 then
                v407.fill = 3.125;
            end;
        end;
        local v443 = 40;
        local v444 = 0;
        for _, v446 in ipairs(entity.get_players(true)) do
            if v446 == nil then
                fnayf = false;
            end;
            if v446 ~= nil and v446:is_enemy() and v446:is_dormant() then
                fnayf = true;
            else
                fnayf = false;
            end;
        end;
        local v447 = false;
        fnaychance = 0;
        smdmg = v447;
        chance = v380 / (v381 + v380) * 100;
        if v380 == 0 and v381 == 0 then
            fnaychance = 0;
        else
            fnaychance = chance;
        end;
        v447 = ui.get_binds();
        for _, v449 in pairs(v447) do
            if v449.active and v449.name == "Min. Damage" then
                smdmg = true;
            end;
        end;
        local v450 = {
            [1] = {
                l_format_0("%i-%i-%i-%i-%i", v410, v411, v412, v413, v414), 
                v317.menu.elements.visuals.sindicators:get("Choked commands") and v424:is_alive(), 
                color(200, 199, 197)
            }, 
            [2] = {
                l_format_0("%s", math.floor(fnaychance)) .. "%", 
                v317.menu.elements.visuals.sindicators:get("Hit Percentage") and v424:is_alive(), 
                color(200, 199, 197)
            }, 
            [3] = {
                "PING", 
                v317.menu.elements.visuals.sindicators:get("Ping spike") and v424:is_alive() and ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):get() > 0 and v424:is_alive(), 
                color(163, 194, 43)
            }, 
            [4] = {
                "BODY", 
                v317.menu.elements.visuals.sindicators:get("Body Aim") and v424:is_alive() and v317.refs.body_aim:get() == "Force", 
                color(200, 199, 197)
            }, 
            [5] = {
                [1] = "DT", 
                [2] = v317.menu.elements.visuals.sindicators:get("Double tap") and v424:is_alive() and ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get() and not ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(), 
                [3] = rage.exploit:get() == 1 and color(200, 199, 197) or color(255, 0, 50)
            }, 
            [6] = {
                [1] = "DA", 
                [2] = v317.menu.elements.visuals.sindicators:get("Dormant aimbot") and v424:is_alive() and ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"):get(), 
                [3] = fnayf == true and color(200, 199, 197) or color(255, 0, 50)
            }, 
            [7] = {
                "DUCK", 
                v317.menu.elements.visuals.sindicators:get("Fake duck") and v424:is_alive() and ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(), 
                color(200, 199, 197)
            }, 
            [8] = {
                "MD", 
                v317.menu.elements.visuals.sindicators:get("Minimum damage") and v424:is_alive() and smdmg == true, 
                color(200, 199, 197)
            }, 
            [9] = {
                "FS", 
                v317.menu.elements.visuals.sindicators:get("Freestanding") and v424:is_alive() and ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):get(), 
                color(200, 199, 197)
            }, 
            [10] = {
                [1] = nil, 
                [2] = nil, 
                [3] = nil, 
                [4] = nil, 
                [5] = nil, 
                [6] = true, 
                [1] = "        " .. v426 .. " - " .. l_format_0("%.1f", v427) .. "s", 
                [2] = v317.menu.elements.visuals.sindicators:get("Bomb info") and v427 > 0 and not v428, 
                [3] = color(200, 199, 197)
            }, 
            [11] = {
                "FATAL", 
                v317.menu.elements.visuals.sindicators:get("Bomb info") and v431, 
                color(255, 0, 50, 255)
            }, 
            [12] = {
                "-" .. v430 .. " HP", 
                v317.menu.elements.visuals.sindicators:get("Bomb info") and not v431 and v429 > 0.5, 
                color(210, 216, 112, 255)
            }, 
            [13] = {
                [1] = nil, 
                [2] = nil, 
                [3] = nil, 
                [4] = nil, 
                [5] = nil, 
                [6] = true, 
                [1] = "        " .. v407.planting_site, 
                [2] = v317.menu.elements.visuals.sindicators:get("Bomb info") and v407.planting, 
                [3] = color(210, 216, 112, 255), 
                [4] = color(255, 255), 
                [5] = v407.fill / 3.2
            }, 
            [14] = {
                "OSAA", 
                v317.menu.elements.visuals.sindicators:get("Hide shots") and v424:is_alive() and ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"):get() and not ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get() and not ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(), 
                color(200, 199, 197)
            }
        };
        for _, v452 in pairs(v450) do
            if v452[2] then
                render_indicator(v452[1], v444, v452[3], v452[4], v452[5], v452[6]);
                v444 = v444 - v443;
            end;
        end;
        return;
    end;
end, true, "sindicators");
v407.reset = function()
    -- upvalues: v317 (ref), v407 (ref)
    if not v317.menu.elements.visuals.sindicators:get("Bomb info") then
        return;
    else
        v407.planting = false;
        v407.fill = 0;
        v407.on_plant_time = 0;
        v407.planting_site = "";
        return;
    end;
end;
v407.bomb_beginplant = function(v453)
    -- upvalues: v317 (ref), l_get_player_resource_0 (ref), v407 (ref)
    if not v317.menu.elements.visuals.sindicators:get("Bomb info") then
        return;
    else
        local v454 = l_get_player_resource_0();
        if v454 == nil then
            return;
        else
            v407.on_plant_time = globals.curtime;
            v407.planting = true;
            if v407.on_plant_time == nil then
                return;
            else
                local l_m_bombsiteCenterA_0 = v454.m_bombsiteCenterA;
                local l_m_bombsiteCenterB_0 = v454.m_bombsiteCenterB;
                local v457 = entity.get(v453.userid, true);
                if v457 == nil then
                    return;
                else
                    local v458 = v457:get_origin();
                    if v458 == nil then
                        return;
                    elseif l_m_bombsiteCenterA_0 == nil or l_m_bombsiteCenterB_0 == nil then
                        return;
                    else
                        v407.planting_site = v458:dist(l_m_bombsiteCenterA_0) < v458:dist(l_m_bombsiteCenterB_0) and "A" or "B";
                        return;
                    end;
                end;
            end;
        end;
    end;
end;
v351:add("bomb_beginplant", function(v459)
    -- upvalues: v407 (ref)
    v407.bomb_beginplant(v459);
end, true, "bombbegin");
v351:add("bomb_abortplant", function()
    -- upvalues: v407 (ref)
    v407.reset();
end, true, "bombabort");
v351:add("bomb_planted", function()
    -- upvalues: v407 (ref)
    v407.reset();
end, true, "bombplanted");
v351:add("bomb_defused", function()
    -- upvalues: v407 (ref)
    v407.reset();
end, true, "bombdefused");
v351:add("bomb_pickup", function()
    -- upvalues: v407 (ref)
    v407.reset();
end, true, "bombpickup");
v351:add("round_start", function()
    -- upvalues: v407 (ref)
    v407.reset();
end, true, "roundstart");
v351:add("render", function()
    -- upvalues: l_screen_size_0 (ref), v317 (ref), l_get_local_player_0 (ref), l_get_binds_0 (ref), v61 (ref), v141 (ref), l_text_0 (ref), v177 (ref), l_find_0 (ref), l_defensive_0 (ref), l_measure_text_0 (ref)
    local l_x_0 = l_screen_size_0().x;
    local l_y_0 = l_screen_size_0().y;
    if v317.menu.elements.visuals.on_screen:get() and v317.menu.elements.visuals.select:get() == "Default" then
        if l_get_local_player_0() == nil then
            return;
        elseif l_get_local_player_0():is_alive() == false then
            return;
        else
            local v465 = (function(v462)
                local v463 = v462["m_vecVelocity[0]"];
                local v464 = v462["m_vecVelocity[1]"];
                return (math.sqrt(v463 * v463 + v464 * v464));
            end)(l_get_local_player_0());
            local v466 = bit.band(l_get_local_player_0().m_fFlags, bit.lshift(1, 0)) == 0 or common.is_button_down(32);
            local v467 = l_get_local_player_0().m_flDuckAmount > 0.8 or common.is_button_down(162);
            local v468 = false;
            if v466 and not v467 or v466 and v467 then
                aa_state = v317.menu.elements.visuals.fonts:get() == "Small" and "- JUMPING -" or "jumping";
            elseif not v466 and not common.is_button_down(32) and v467 or v317.refs.fake_duck:get() then
                aa_state = v317.menu.elements.visuals.fonts:get() == "Small" and "- CROUCH -" or "crouch";
            elseif (not v467 or v317.refs.fake_duck) and not v466 and not v317.refs.slowwalk:get() and v465 > 4 then
                aa_state = v317.menu.elements.visuals.fonts:get() == "Small" and "- MOVING -" or "moving";
            elseif v317.refs.slowwalk:get() then
                aa_state = v317.menu.elements.visuals.fonts:get() == "Small" and "- SLOWWALK -" or "slowwalk";
            elseif v465 < 5 and (not v467 or v317.refs.fake_duck) and not v466 then
                aa_state = v317.menu.elements.visuals.fonts:get() == "Small" and "- STANDING -" or "standing";
            end;
            local v469 = l_get_binds_0();
            for _, v471 in pairs(v469) do
                if v471.active and v471.name == "Min. Damage" then
                    v468 = true;
                end;
            end;
            if entity.get_local_player():get_player_weapon() == nil then
                return;
            else
                local v472 = entity.get_local_player():get_player_weapon():get_weapon_index();
                local v473 = v472 == 43 or not (v472 ~= 44) or not (v472 ~= 45) or not (v472 ~= 46) or not (v472 ~= 47) or v472 == 48;
                x_value = lerp(globals.frametime * 16, x_value, l_get_local_player_0().m_bIsScoped and l_x_0 / 2 + 43 or l_x_0 / 2);
                local l_lerp_0 = lerp;
                local v475 = globals.frametime * 8;
                local l_dt_alpha_0 = dt_alpha;
                local v477;
                if v317.refs.dt:get() then
                    v477 = v473 and 100 or 255;
                else
                    v477 = 0;
                end;
                dt_alpha = l_lerp_0(v475, l_dt_alpha_0, v477);
                l_lerp_0 = lerp;
                v475 = globals.frametime * 8;
                l_dt_alpha_0 = hs_alpha;
                if v317.refs.hs:get() then
                    v477 = v473 and 100 or 255;
                else
                    v477 = 0;
                end;
                hs_alpha = l_lerp_0(v475, l_dt_alpha_0, v477);
                l_lerp_0 = lerp;
                v475 = globals.frametime * 8;
                l_dt_alpha_0 = dmg_alpha;
                if v468 == true then
                    v477 = v473 and 100 or 255;
                else
                    v477 = 0;
                end;
                dmg_alpha = l_lerp_0(v475, l_dt_alpha_0, v477);
                wp = lerp(globals.frametime * 8, wp, v473 and 100 or 255);
                alpha_cl = v61(math.floor(math.sin(globals.realtime * 5) * 126.5 + 127.5) or 255, 35, 255);
                render.shadow(v317.menu.elements.visuals.fonts:get() == "Small" and vector(x_value - 20, l_y_0 / 2 + 20) or vector(x_value - 35, l_y_0 / 2 + 20), v317.menu.elements.visuals.fonts:get() == "Small" and vector(x_value + 20, l_y_0 / 2 + 20) or vector(x_value + 30, l_y_0 / 2 + 20), v317.menu.elements.visuals.indicator_color:get(), v317.menu.elements.visuals.glow_px:get(), 0, 0);
                l_lerp_0 = v141.gradient;
                if v317.menu.elements.visuals.fonts:get() == "Small" then
                    v475 = v317.cheat.version == "Nightly" and "NIGHTLY" or v317.cheat.version == "Alpha" and "ALPHA" or "LUA";
                else
                    v475 = v317.cheat.version == "Nightly" and "nightly" or v317.cheat.version == "Alpha" and "alpha" or "lua";
                end;
                indicator_text = l_lerp_0(v475, color(v317.menu.elements.visuals.build_color:get().r, v317.menu.elements.visuals.build_color:get().g, v317.menu.elements.visuals.build_color:get().b, alpha_cl), color(v317.menu.elements.visuals.build_color:get().r, v317.menu.elements.visuals.build_color:get().g, v317.menu.elements.visuals.build_color:get().b, alpha_cl));
                l_text_0(v317.menu.elements.visuals.fonts:get() == "Small" and 2 or 1, vector(x_value, l_y_0 / 2 + 20), color(v317.menu.elements.visuals.indicator_color:get().r, v317.menu.elements.visuals.indicator_color:get().g, v317.menu.elements.visuals.indicator_color:get().b, wp), "c", v317.menu.elements.visuals.fonts:get() == "Small" and "MYTOOLS  " .. indicator_text or "mytools " .. indicator_text);
                v177("aa_ind", vector(x_value, l_y_0 / 2 + 30), v317.menu.elements.visuals.fonts:get() == "Small" and 2 or 1, color(255, wp), nil, aa_state);
                if v317.refs.dt:get() and not l_find_0("Aimbot", "Ragebot", "Main", "Peek Assist"):get() then
                    l_lerp_0 = v177;
                    v475 = "dt_ind";
                    l_dt_alpha_0 = vector(x_value, l_y_0 / 2 + 40);
                    v477 = v317.menu.elements.visuals.fonts:get() == "Small" and 2 or 1;
                    local v478 = color(255, 255, 255, dt_alpha);
                    local v479 = nil;
                    local v480;
                    if rage.exploit:get() == 1 then
                        v480 = v317.menu.elements.visuals.fonts:get() == "Small" and "DT  " or "dt ";
                        local v481;
                        if l_defensive_0(l_get_local_player_0(), true) > 2 then
                            v481 = v317.menu.elements.visuals.fonts:get() == "Small" and "\a7FFFFFFFACTIVE" or "\a7FFFFFFFactive";
                        else
                            v481 = v317.menu.elements.visuals.fonts:get() == "Small" and "\aC0FF91FFREADY" or "\aC0FF91FFready";
                        end;
                        v480 = v480 .. v481;
                        if v480 then
                            goto label0;
                        end;
                    end;
                    v480 = (v317.menu.elements.visuals.fonts:get() == "Small" and "DT  " or "dt ") .. (v317.menu.elements.visuals.fonts:get() == "Small" and "\aFF9494FFWAITING" or "\aFF9494FFwaiting");
                    ::label0::;
                    l_lerp_0(v475, l_dt_alpha_0, v477, v478, v479, v480);
                elseif v317.refs.dt:get() and l_find_0("Aimbot", "Ragebot", "Main", "Peek Assist"):get() then
                    l_lerp_0 = v177;
                    v475 = "dt_ind";
                    l_dt_alpha_0 = vector(x_value, l_y_0 / 2 + 40);
                    v477 = v317.menu.elements.visuals.fonts:get() == "Small" and 2 or 1;
                    local v482 = color(255, 255, 255, dt_alpha);
                    local v483 = nil;
                    local v484;
                    if rage.exploit:get() == 1 then
                        v484 = v317.menu.elements.visuals.fonts:get() == "Small" and "IDEALTICK  " or "idealtick ";
                        local v485;
                        if l_defensive_0(l_get_local_player_0(), true) > 2 then
                            v485 = v317.menu.elements.visuals.fonts:get() == "Small" and "\a7FFFFFFFACTIVE" or "\a7FFFFFFFactive";
                        else
                            v485 = v317.menu.elements.visuals.fonts:get() == "Small" and "\aC0FF91FFREADY" or "\aC0FF91FFready";
                        end;
                        v484 = v484 .. v485;
                        if v484 then
                            goto label1;
                        end;
                    end;
                    v484 = (v317.menu.elements.visuals.fonts:get() == "Small" and "IDEALTICK  " or "idealtick ") .. (v317.menu.elements.visuals.fonts:get() == "Small" and "\aFF9494FFWAITING" or "\aFF9494FFwaiting");
                    ::label1::;
                    l_lerp_0(v475, l_dt_alpha_0, v477, v482, v483, v484);
                elseif v317.refs.hs:get() and not v317.refs.dt:get() then
                    l_lerp_0 = v177;
                    v475 = "dt_ind";
                    l_dt_alpha_0 = vector(x_value, l_y_0 / 2 + 40);
                    v477 = v317.menu.elements.visuals.fonts:get() == "Small" and 2 or 1;
                    local v486 = color(255, 255, 255, hs_alpha);
                    local v487 = nil;
                    local v488;
                    if rage.exploit:get() == 1 then
                        v488 = v317.menu.elements.visuals.fonts:get() == "Small" and "HIDE  " or "hide ";
                        local v489;
                        if l_defensive_0(l_get_local_player_0(), true) > 2 then
                            v489 = v317.menu.elements.visuals.fonts:get() == "Small" and "\a7FFFFFFFACTIVE" or "\a7FFFFFFFactive";
                        else
                            v489 = v317.menu.elements.visuals.fonts:get() == "Small" and "\aC0FF91FFREADY" or "\aC0FF91FFready";
                        end;
                        v488 = v488 .. v489;
                        if v488 then
                            goto label2;
                        end;
                    end;
                    v488 = (v317.menu.elements.visuals.fonts:get() == "Small" and "HIDE  " or "hide ") .. (v317.menu.elements.visuals.fonts:get() == "Small" and "\aFF9494FFWAITING" or "\aFF9494FFwaiting");
                    ::label2::;
                    l_lerp_0(v475, l_dt_alpha_0, v477, v486, v487, v488);
                end;
                l_lerp_0 = v177;
                v475 = "dmg_ind";
                l_dt_alpha_0 = vector(x_value, (not not v317.refs.dt:get() or v317.refs.hs:get()) and l_y_0 / 2 + 50 or l_y_0 / 2 + 40);
                v477 = v317.menu.elements.visuals.fonts:get() == "Small" and 2 or 1;
                local v490 = color(255, 255, 255, v468 == true and 255 or 0);
                local v491 = nil;
                local v492;
                if v317.menu.elements.visuals.fonts:get() == "Small" then
                    v492 = v468 == true and "DMG" or "   ";
                else
                    v492 = v468 == true and "dmg" or "   ";
                end;
                l_lerp_0(v475, l_dt_alpha_0, v477, v490, v491, v492);
            end;
        end;
    end;
    if v317.menu.elements.visuals.sindicators:get("Spectator list") then
        local v493 = l_get_local_player_0();
        if v493 == nil then
            return;
        else
            if v493.m_hObserverTarget and (v493.m_iObserverMode == 4 or v493.m_iObserverMode == 5) then
                v493 = v493.m_hObserverTarget;
            end;
            local v494 = v493.get_spectators(v493);
            if v494 == nil then
                return;
            else
                for v495, v496 in ipairs(v494) do
                    local l_x_1 = l_screen_size_0().x;
                    local _ = l_screen_size_0().y;
                    local v499 = v496:get_name();
                    local l_x_2 = l_measure_text_0(1, "", v499).x;
                    if not v496:is_bot() or v496:is_player() then
                        l_text_0(1, vector(l_x_1 - l_x_2 - 7, -10 + v495 * 20), color(), "u", v499);
                    end;
                end;
            end;
        end;
    end;
end, true, "indicators");
local v501 = false;
local l_curtime_0 = globals.curtime;
v351:add("createmove", function(v503)
    -- upvalues: l_get_local_player_0 (ref), v317 (ref), l_curtime_0 (ref), v501 (ref)
    local v504 = l_get_local_player_0();
    if v504 == nil then
        return;
    else
        local l_m_iTeamNum_0 = v504.m_iTeamNum;
        local v506 = bit.rshift(bit.lshift(v503.buttons, 26), 31);
        if v504:get_player_weapon() == nil then
            return;
        else
            local v507 = true;
            for _, v509 in pairs({
                entity.get_entities("CPlantedC4"), 
                entity.get_entities("CHostage")
            }) do
                for _, v511 in pairs(v509) do
                    if v504:get_origin():dist(v511:get_origin()) < 65 and v504:get_origin():dist(v511:get_origin()) > 1 and l_m_iTeamNum_0 == 3 then
                        v507 = false;
                    end;
                end;
            end;
            if l_m_iTeamNum_0 == 2 and v504.m_bInBombZone and v504:get_player_weapon():get_weapon_index() == 49 then
                v507 = false;
            end;
            if v317.menu.elements.antiaims.antiaims_tweaks:get("Legit AA") and v317.menu.elements.antiaims.manual_aa:get() == "Left" or v317.menu.elements.antiaims.manual_aa:get() == "Right" or v317.menu.elements.antiaims.manual_aa:get() == "Forward" or v317.refs.freestanding_def:get() and v506 ~= 0 and v507 then
                return;
            else
                if v317.menu.elements.antiaims.antiaims_tweaks:get("Legit AA") and v506 ~= 0 and v507 then
                    if globals.curtime - l_curtime_0 > 0.02 then
                        v503.buttons = bit.band(v503.buttons, bit.bnot(32));
                        v501 = true;
                        v317.refs.left_limit:override(60);
                        v317.refs.right_limit:override(60);
                        v317.refs.pitch:override("Disabled");
                        v317.refs.yaw:override(180);
                        v317.refs.jyaw_slider:override(5);
                        v317.refs.base:override("Local View");
                    end;
                else
                    l_curtime_0 = globals.curtime;
                    v501 = false;
                end;
                return;
            end;
        end;
    end;
end, true, "legit_antiaim");
v351:add("createmove", function(v512)
    -- upvalues: v317 (ref), l_get_local_player_0 (ref)
    if v317.menu.elements.antiaims.antiaims_tweaks:get("Bombsite E Fix") then
        local v513 = l_get_local_player_0();
        if l_get_local_player_0() == nil then
            return;
        elseif v513:get_player_weapon() == nil then
            return;
        else
            local l_m_iTeamNum_1 = v513.m_iTeamNum;
            local l_m_bInBombZone_0 = v513.m_bInBombZone;
            local v516 = team_num == 3;
            local v517 = l_m_iTeamNum_1 == 2 and has_bomb;
            local v518 = l_m_bInBombZone_0 ~= false;
            local v519 = common.is_button_down(69);
            if not v518 and v317.menu.elements.antiaims.antiaims_tweaks:get("Legit AA") then
                return;
            else
                if v518 and not v517 and not v516 and v519 then
                    v317.refs.jyaw_slider:override(0);
                    v317.refs.left_limit:override(0);
                    v317.refs.right_limit:override(0);
                    v317.refs.pitch:override("Disabled");
                    v317.refs.yaw_base:override("Disabled");
                    v317.refs.base:override("Local View");
                end;
                if v518 and not v517 and not v516 then
                    v512.in_use = 0;
                end;
            end;
        end;
    end;
end, true, "bombsitefix");
local v520 = utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B") or error("Invalid signature #1");
local v521 = utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7") or error("Invalid signature #2");
local v522 = utils.opcode_scan("gameoverlayrenderer.dll", "FF E1") or error("Invalid signature #3");
local v523 = utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74") or error("Invalid signature #4");
local v524 = ffi.cast("uintptr_t***", ffi.cast("uintptr_t", v520) + 2)[0][0] + 2;
local v525 = ffi.cast("int(__stdcall*)(uintptr_t, int)", v521);
local v526 = ffi.cast("int(__thiscall*)(uintptr_t)", v522);
local v527 = ffi.cast("uintptr_t**", ffi.cast("uintptr_t", v523) + 2)[0][0];
local function v528()
    -- upvalues: v524 (ref)
    return v524[0];
end;
local function v529()
    -- upvalues: v526 (ref), v527 (ref)
    return v526(v527);
end;
local function v531()
    -- upvalues: v528 (ref), v529 (ref), v525 (ref)
    local v530 = v528();
    if v529() ~= v530 then
        v525(v530, 1);
        return true;
    else
        return false;
    end;
end;
v351:add("round_start", function()
    -- upvalues: v317 (ref), v531 (ref)
    if v317.menu.elements.misc.taskbar:get() then
        v531();
    end;
end, true, "taskbarnotify");
v351:add("round_start", function()
    -- upvalues: v317 (ref)
    if not v317.menu.elements.misc.muteunmute:get() then
        return;
    else
        entity.get_players(false, true, function(v532)
            local v533 = panorama.MatchStatsAPI.GetPlayerXuid(v532:get_index());
            if panorama.GameStateAPI.HasCommunicationAbuseMute(v533) and panorama.GameStateAPI.IsSelectedPlayerMuted(v533) then
                panorama.GameStateAPI.ToggleMute(v533);
            end;
        end);
        return;
    end;
end, true, "autounmute");
v351:add("createmove", function(v534)
    -- upvalues: v317 (ref)
    if v317.menu.elements.antiaims.anim_breakers:get() and v317.menu.elements.antiaims.type_legs_ground:get() == "Jitter" then
        v317.refs.legmovement:override(v534.command_number % 3 == 0 and "Default" or "Sliding");
    end;
end, true, "slider_legs");
local function v537(v535, v536)
    if not v536 then
        v536 = 1;
    end;
    v535 = ffi.cast(ffi.typeof("void***"), v535);
    return ffi.cast("c_animlayers**", ffi.cast("char*", v535) + 10640)[0][v536];
end;
v351:add("post_update_client_side_animation", function()
    -- upvalues: l_get_local_player_0 (ref), v317 (ref), v537 (ref), v75 (ref)
    if l_get_local_player_0() == nil then
        return;
    elseif not l_get_local_player_0():is_alive() then
        return;
    elseif not v317.menu.elements.antiaims.anim_breakers:get() then
        return;
    else
        if v317.menu.elements.antiaims.type_legs_air:get() == "Static" then
            l_get_local_player_0().m_flPoseParameter[6] = 1;
        end;
        if v317.menu.elements.antiaims.type_legs_ground:get() == "Follow Direction" then
            l_get_local_player_0().m_flPoseParameter[0] = 1;
            v317.refs.legmovement:set("Sliding");
        end;
        if v317.menu.elements.antiaims.type_legs_ground:get() == "Jitter" then
            l_get_local_player_0().m_flPoseParameter[0] = globals.tickcount % 4 > 1 and 0.5 or 1;
            v317.refs.legmovement:set("Sliding");
        end;
        if v317.menu.elements.antiaims.type_legs_ground:get() == "Moon Walk" then
            l_get_local_player_0().m_flPoseParameter[7] = 0;
            v317.refs.legmovement:set("Walking");
        end;
        if v317.menu.elements.antiaims.static_slow:get() and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
            l_get_local_player_0().m_flPoseParameter[9] = 0;
        end;
        if v317.menu.elements.antiaims.custom_move:get() then
            v537(v75(l_get_local_player_0():get_index()), 12).m_flWeight = v317.menu.elements.antiaims.move_lean:get() / 100;
        end;
        if v317.menu.elements.antiaims.type_legs_air:get() == "Moon Walk" then
            local function v541(v538)
                local v539 = v538["m_vecVelocity[0]"];
                local v540 = v538["m_vecVelocity[1]"];
                return (math.sqrt(v539 * v539 + v540 * v540));
            end;
            if bit.band(l_get_local_player_0().m_fFlags, bit.lshift(1, 0)) == 0 and v541(l_get_local_player_0()) > 2 then
                v537(v75(l_get_local_player_0():get_index()), 6).m_flWeight = 1;
            end;
        end;
        return;
    end;
end, true, "anim_breakers");
v351:add("createmove", function(v542)
    -- upvalues: v317 (ref), l_get_local_player_0 (ref)
    if not v317.menu.elements.antiaims.antiaims_tweaks:get("Fast Ladder") then
        return;
    else
        self = l_get_local_player_0();
        if self == nil then
            return;
        else
            if self.m_MoveType == 9 then
                v542.view_angles.y = math.floor(v542.view_angles.y + 0.5);
                if v542.forwardmove > 0 then
                    if v542.view_angles.x < 45 then
                        v542.view_angles.x = 89;
                        v542.in_moveright = 1;
                        v542.in_moveleft = 0;
                        v542.in_forward = 0;
                        v542.in_back = 1;
                        if v542.sidemove == 0 then
                            v542.view_angles.y = v542.view_angles.y + 90;
                        end;
                        if v542.sidemove < 0 then
                            v542.view_angles.y = v542.view_angles.y + 150;
                        end;
                        if v542.sidemove > 0 then
                            v542.view_angles.y = v542.view_angles.y + 30;
                        end;
                    end;
                elseif v542.forwardmove < 0 then
                    v542.view_angles.x = 89;
                    v542.in_moveleft = 1;
                    v542.in_moveright = 0;
                    v542.in_forward = 1;
                    v542.in_back = 0;
                    if v542.sidemove == 0 then
                        v542.view_angles.y = v542.view_angles.y + 90;
                    end;
                    if v542.sidemove > 0 then
                        v542.view_angles.y = v542.view_angles.y + 150;
                    end;
                    if v542.sidemove < 0 then
                        v542.view_angles.y = v542.view_angles.y + 30;
                    end;
                end;
            end;
            return;
        end;
    end;
end, true, "fastladder");
v351:add("shutdown", function()
    -- upvalues: v378 (ref), v317 (ref), v135 (ref)
    v378(" ", " ");
    cvar.viewmodel_fov:int(68);
    cvar.viewmodel_offset_x:float(2.5);
    cvar.viewmodel_offset_y:float(0);
    cvar.viewmodel_offset_z:float(-1.5);
    cvar.r_aspectratio:float(0);
    v317.refs.logs:override();
    v317.refs.pitch:override();
    v317.refs.yaw_base:override();
    v317.refs.enable_desync:override();
    v317.refs.left_limit:override();
    v317.refs.right_limit:override();
    v317.refs.jyaw:override();
    v317.refs.jyaw_slider:override();
    v317.refs.fake_op:override();
    v317.refs.freestand:override();
    v317.refs.yaw:override();
    v317.refs.inverter1:override();
    v317.refs.body_aim:override();
    v317.refs.disablers:override();
    cvar.sv_maxunlag:float(0.2);
    if not entity.get_local_player() == nil then
        entity.get_local_player():set_icon();
    end;
    ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):override();
    ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override();
    ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override();
    ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override();
    ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set(v135);
    paint_c(color(255, 255, 255, 255));
end, true, "disable_lua");
v351:action();
local v543 = l_smoothy_0.new(v317.refs.min_dmg:get());
local v544 = 0;
local v549 = l_system_0.register({
    [1] = v317.menu.elements.visuals.dmg_indx, 
    [2] = v317.menu.elements.visuals.dmg_indy
}, vector(20, 15), "Test", function(v545)
    -- upvalues: l_get_local_player_0 (ref), v317 (ref), l_get_alpha_0 (ref), l_rect_outline_0 (ref), v543 (ref), v544 (ref), l_text_0 (ref)
    if l_get_local_player_0() == nil then
        return;
    elseif l_get_local_player_0():is_alive() == false then
        return;
    else
        if v317.menu.elements.visuals.damage_indicator:get() and l_get_alpha_0() > 0.3 then
            l_rect_outline_0(vector(v545.position.x, v545.position.y), vector(v545.position.x + v545.size.x, v545.position.y + v545.size.y), color(255, 255, 255, 100), 0, 5);
        end;
        local _ = v543(0.05, v317.refs.min_dmg:get(), easing_fn);
        if entity.get_local_player():get_player_weapon() == nil then
            return;
        else
            local v547 = entity.get_local_player():get_player_weapon():get_weapon_index();
            local v548 = v547 == 43 or not (v547 ~= 44) or not (v547 ~= 45) or not (v547 ~= 46) or not (v547 ~= 47) or v547 == 48;
            v544 = lerp(globals.frametime * 8, v544, v548 and 100 or 255);
            if v317.menu.elements.visuals.damage_indicator:get() and {
                [1] = l_get_alpha_0() > 0.3 or l_get_local_player_0():is_alive()
            } then
                l_text_0(v317.menu.elements.visuals.damage_font:get() == "Small" and 2 or 1, vector(v545.position.x + 11, v545.position.y + 7), color(255, v544), "c", not v317.menu.elements.visuals.dis_animation:get() and (v543.value / v317.refs.min_dmg:get() < 1 and math.ceil(v543.value) or math.floor(v543.value)) or v317.refs.min_dmg:get());
            end;
            return;
        end;
    end;
end);
l_events_0.mouse_input:set(function()
    -- upvalues: l_get_alpha_0 (ref)
    if l_get_alpha_0() > 0.3 then
        return false;
    else
        return;
    end;
end);
l_events_0.render:set(function()
    -- upvalues: v549 (ref)
    v549:update();
end);
onetap_data = {};
local v574 = new_class():struct("hit_mark")({
    hitlogger = (function()
        -- upvalues: l_events_0 (ref), l_world_to_screen_0 (ref), l_text_0 (ref), v133 (ref)
        return {
            [1] = nil, 
            [2] = 8, 
            callback_registered = false, 
            [1] = maximum_count, 
            data = {}, 
            register_callback = function(v550)
                -- upvalues: l_events_0 (ref), l_world_to_screen_0 (ref), l_text_0 (ref), v133 (ref)
                if v550.callback_registered then
                    return;
                else
                    l_events_0.render:set(function()
                        -- upvalues: v550 (ref), l_world_to_screen_0 (ref), l_text_0 (ref), v133 (ref)
                        local _ = {
                            [1] = 56, 
                            [2] = 56, 
                            [3] = 57
                        };
                        local v552 = 10;
                        local l_data_0 = v550.data;
                        for v554 = #l_data_0, 1, -1 do
                            v550.data[v554].time = v550.data[v554].time - globals.frametime;
                            local v555 = 255;
                            local v556 = 0;
                            local v557 = l_data_0[v554];
                            if v557.time < 0 then
                                table.remove(v550.data, v554);
                            else
                                local v558 = v557.def_time - v557.time;
                                local v559 = v558 > 1 and 1 or v558;
                                local v560 = 0.2;
                                local v561 = 0;
                                if v557.time < 0.2 then
                                    v561 = (v559 < 1 and v559 or v557.time) / 0.2;
                                end;
                                if v559 < v560 then
                                    v561 = (v559 < 1 and v559 or v557.time) / 0.2;
                                end;
                                if v557.time < 0.2 then
                                    v556 = (v559 < 1 and v559 or v557.time) / 0.2;
                                    v555 = v556 * 255;
                                    if v556 < 0.2 then
                                        v552 = v552 - 15 * (1 - v556 / 0.2);
                                    end;
                                end;
                                local v562 = v557.time < 0.2 and -1 or 1;
                                v557.draw = tostring(v557.draw):upper();
                                if v557.draw ~= "" then
                                    if v557.shot_pos == nil or l_world_to_screen_0(v557.shot_pos) == nil then
                                        return;
                                    else
                                        local l_x_3 = l_world_to_screen_0(v557.shot_pos).x;
                                        local l_y_2 = l_world_to_screen_0(v557.shot_pos).y;
                                        local _ = 55 * (v555 * v562) / 255 * v562;
                                        l_text_0(v133, vector(l_x_3, l_y_2 - 20), color(255, 255, 255, v555 / 4), "c", v557.draw);
                                        l_text_0(v133, vector(l_x_3, l_y_2 - 20), color(255, 0, 0, v555 / 1.2), "c", v557.draw);
                                        v552 = v552 + 25;
                                    end;
                                end;
                            end;
                        end;
                        v550.callback_registered = true;
                    end);
                    return;
                end;
            end, 
            paint = function(v566, v567, v568, v569)
                local v570 = tonumber(v567) + 1;
                for v571 = 2, 2, -1 do
                    v566.data[v571] = v566.data[v571 - 1];
                end;
                v566.data[1] = {
                    time = v570, 
                    def_time = v570, 
                    draw = v568, 
                    shot_pos = v569
                };
                v566:register_callback();
            end
        };
    end)()
}):struct("aim_hit")({
    init = function(v572)
        -- upvalues: l_events_0 (ref), v317 (ref)
        l_events_0.aim_ack:set(function(v573)
            -- upvalues: v317 (ref), v572 (ref)
            if v317.menu.elements.visuals.markers:get() and v317.menu.elements.visuals.ot_marker:get() then
                if v573.hitgroup == 1 then
                    clr = color(255, 0, 0):to_hex();
                else
                    clr = color(255, 255, 255):to_hex();
                end;
                if v573.state == nil then
                    v572.hit_mark.hitlogger:paint(2, "\a" .. clr .. "" .. v573.damage, v573.aim);
                end;
            end;
        end);
    end
});
v574.aim_hit:init();
local function v576(v575)
    -- upvalues: v317 (ref), l_get_local_player_0 (ref)
    if v317.menu.elements.visuals.markers:get() and v317.menu.elements.visuals.ot_marker:get() and l_get_local_player_0() ~= nil and l_get_local_player_0():is_alive() and v575.state == nil then
        table.insert(onetap_data, {
            [1] = v575.aim, 
            [2] = globals.realtime + 3
        });
    end;
end;
local function v579()
    -- upvalues: v317 (ref), l_get_local_player_0 (ref)
    if v317.menu.elements.visuals.markers:get() and v317.menu.elements.visuals.ot_marker:get() and l_get_local_player_0() ~= nil and l_get_local_player_0():is_alive() then
        for _, v578 in pairs(onetap_data) do
            if globals.realtime > v578[2] then
                table.remove(onetap_data, 1);
            end;
            if v578[1]:to_screen() ~= nil then
                render.line(vector(v578[1]:to_screen().x + 4, v578[1]:to_screen().y + 4), vector(v578[1]:to_screen().x + 8, v578[1]:to_screen().y + 8), color(255, 255, 255, 255));
                render.line(vector(v578[1]:to_screen().x - 4, v578[1]:to_screen().y + 4), vector(v578[1]:to_screen().x - 8, v578[1]:to_screen().y + 8), color(255, 255, 255, 255));
                render.line(vector(v578[1]:to_screen().x + 4, v578[1]:to_screen().y - 4), vector(v578[1]:to_screen().x + 8, v578[1]:to_screen().y - 8), color(255, 255, 255, 255));
                render.line(vector(v578[1]:to_screen().x - 4, v578[1]:to_screen().y - 4), vector(v578[1]:to_screen().x - 8, v578[1]:to_screen().y - 8), color(255, 255, 255, 255));
            end;
        end;
    end;
end;
l_events_0.aim_ack:set(v576);
l_events_0.render:set(v579);
l_events_0.round_prestart:set(function()
    onetap_data = {};
end);
kibit_data = {};
local function v581(v580)
    -- upvalues: v317 (ref), l_get_local_player_0 (ref)
    if v317.menu.elements.visuals.markers:get() and v317.menu.elements.visuals.kibit_marker:get() and l_get_local_player_0() ~= nil and l_get_local_player_0():is_alive() and v580.state == nil then
        table.insert(kibit_data, {
            [1] = v580.aim, 
            [2] = globals.realtime + 3
        });
    end;
end;
local function v584()
    -- upvalues: v317 (ref), l_get_local_player_0 (ref)
    if v317.menu.elements.visuals.markers:get() and v317.menu.elements.visuals.kibit_marker:get() and l_get_local_player_0() ~= nil and l_get_local_player_0():is_alive() then
        for _, v583 in pairs(kibit_data) do
            if globals.realtime > v583[2] then
                table.remove(kibit_data, 1);
            end;
            if v583[1]:to_screen() ~= nil then
                render.rect(vector(v583[1]:to_screen().x - 1, v583[1]:to_screen().y - 6), vector(v583[1]:to_screen().x + 1, v583[1]:to_screen().y + 6), color(34, 214, 132, 255));
                render.rect(vector(v583[1]:to_screen().x - 6, v583[1]:to_screen().y - 1), vector(v583[1]:to_screen().x + 6, v583[1]:to_screen().y + 1), color(108, 182, 203, 255));
            end;
        end;
    end;
end;
l_events_0.aim_ack:set(v581);
l_events_0.render:set(v584);
l_events_0.round_prestart:set(function()
    kibit_data = {};
end);
local v585 = {
    [0] = "generic", 
    [1] = "head", 
    [2] = "chest", 
    [3] = "stomach", 
    [4] = "left arm", 
    [5] = "right arm", 
    [6] = "left leg", 
    [7] = "right leg", 
    [8] = "neck", 
    [9] = "generic", 
    [10] = "gear"
};
l_events_0.item_purchase:set(function(v586)
    -- upvalues: v317 (ref)
    if v317.menu.elements.ragebot.aimbot_logging:get() and v317.menu.elements.ragebot.purchases:get() then
        local v587 = entity.get(v586.userid, true);
        local l_weapon_0 = v586.weapon;
        if v587 == nil then
            return;
        elseif l_weapon_0 == "weapon_unknown" then
            return;
        elseif not v587:is_enemy() then
            return;
        else
            print_raw(("\a{Link Active}mytools \a85858DFF\194\183\aD5D5D5FF %s bought \aACFF86FF%s"):format(string.lower(v587:get_name()), l_weapon_0));
            print_dev(("%s bought \aACFF86FF%s\aDEFAULT"):format(v587:get_name(), l_weapon_0));
        end;
    end;
end);
l_events_0.aim_ack:set(function(v589)
    -- upvalues: v317 (ref), l_get_local_player_0 (ref), v136 (ref), v585 (ref), l_format_0 (ref)
    if v317.menu.elements.ragebot.aimbot_logging:get() and v317.menu.elements.ragebot.select_log:get("Console") then
        local _ = l_get_local_player_0();
        local v591 = entity.get(v589.target);
        local l_state_0 = v589.state;
        local l_state_1 = v589.state;
        if not v591 then
            return;
        elseif v591 == nil then
            return;
        else
            local l_m_iHealth_0 = v591.m_iHealth;
            if l_get_local_player_0() == nil then
                return;
            else
                if l_state_1 == "spread" then
                    l_state_1 = "\aFEEA7DFFspread";
                end;
                if l_state_1 == "prediction error" then
                    l_state_1 = "\aFEEA7DFFpred. error";
                end;
                if l_state_1 == "correction" then
                    l_state_1 = "\aFF5959FFresolver";
                end;
                if l_state_1 == "damage rejection" then
                    l_state_1 = "\aFF5959FFdamage rejection";
                end;
                if l_state_1 == "misprediction" then
                    l_state_1 = "\aFEEA7DFFmisprediction";
                end;
                if l_state_1 == "lagcomp failure" then
                    l_state_1 = "\aFF5959FFlagcomp failure";
                end;
                if l_state_1 == "backtrack failure" then
                    l_state_1 = "\aFF5959FFbacktrack failure";
                end;
                if l_state_0 == "correction" then
                    l_state_0 = "resolver";
                end;
                if l_state_0 == nil then
                    print_dev(("Hit \a" .. v136 .. "" .. v591:get_name() .. " \aDEFAULTin the \a" .. v136 .. "%s \aDEFAULTfor \a" .. v136 .. "%d \aDEFAULTdamage (\a" .. v136 .. "" .. l_m_iHealth_0 .. " \aDEFAULThealth remaining) \206\148: \a" .. v136 .. "%s\aDEFAULT"):format(v585[v589.hitgroup], v589.damage, v589.backtrack));
                    print_raw(("\a{Link Active}mytools \a85858DFF\194\183 \aD5D5D5FFHit \a" .. v136 .. "" .. string.lower(v591:get_name()) .. " \aDEFAULTin the \a" .. v136 .. "%s \aDEFAULTfor \a" .. v136 .. "%d\aDEFAULT(\a" .. v136 .. "" .. l_format_0("%.f", v589.wanted_damage) .. "\aDEFAULT) damage (\a" .. v136 .. "" .. l_m_iHealth_0 .. " \aDEFAULThealth remaining) (aim: " .. v585[v589.wanted_hitgroup] .. " | bt(\206\148): %s)"):format(v585[v589.hitgroup], v589.damage, v589.backtrack));
                else
                    print_dev(("Missed shot in \a{Link Active}" .. v591:get_name() .. "\aDEFAULT's \aDEFAULT%s \aDEFAULTdue to \a{Link Active}" .. l_state_0 .. " \aDEFAULT\206\148: \a{Link Active}%s\aDEFAULT"):format(v585[v589.wanted_hitgroup], v589.backtrack));
                    print_raw(("\a{Link Active}mytools \a85858DFF\194\183 \aD5D5D5FFMissed shot in \a{Link Active}%s\aDEFAULT's \a{Link Active}%s \aDEFAULTdue to " .. l_state_1 .. "\aD5D5D5FF (hc: " .. l_format_0("%.f", v589.hitchance) .. " | dmg: " .. l_format_0("%.f", v589.wanted_damage) .. " | bt(\206\148): %s)"):format(string.lower(v591:get_name()), v585[v589.wanted_hitgroup], v589.backtrack));
                end;
            end;
        end;
    end;
end);
l_events_0.player_hurt:set(function(v595)
    -- upvalues: v317 (ref), l_get_local_player_0 (ref)
    if v317.menu.elements.ragebot.aimbot_logging:get() and v317.menu.elements.ragebot.select_log:get("Console") then
        local v596 = l_get_local_player_0();
        local v597 = entity.get(v595.attacker, true);
        local l_weapon_1 = v595.weapon;
        local v599 = "hit";
        if l_weapon_1 == "hegrenade" then
            v599 = "Naded";
        end;
        if l_weapon_1 == "inferno" then
            v599 = "Burned";
        end;
        if l_weapon_1 == "knife" then
            v599 = "Knifed";
        end;
        if (l_weapon_1 == "hegrenade" or l_weapon_1 == "inferno" or l_weapon_1 == "knife") and v596 == v597 then
            local v600 = entity.get(v595.userid, true);
            print_raw(("\a{Link Active}mytools \a85858DFF\194\183 \aD5D5D5FF" .. v599 .. " \a{Link Active}%s \aDEFAULTfor \a{Link Active}%d\aDEFAULT damage (\a{Link Active}%d \aDEFAULThealth remaining)"):format(string.lower(v600:get_name()), v595.dmg_health, v595.health));
            print_dev(("" .. v599 .. " \a{Link Active}" .. v600:get_name() .. " \aDEFAULTfor \a{Link Active}%d \aDEFAULTdamage (\a{Link Active}%d \aDEFAULThealth remaining)"):format(v595.dmg_health, v595.health));
        end;
    end;
end);
local v601 = l_smoothy_0.new({
    vel_mod = 0, 
    alpha = 0
});
local v611 = l_system_0.register({
    [1] = v317.menu.elements.visuals.velocity_x, 
    [2] = v317.menu.elements.visuals.velocity_y
}, vector(185, 50), "Test1", function(v602)
    -- upvalues: v601 (ref), v317 (ref), l_get_alpha_0 (ref)
    local v603 = entity.get_local_player();
    local l_vel_mod_0 = v601.value.vel_mod;
    local v605 = math.floor((1 - l_vel_mod_0) * 100);
    local l_alpha_0 = v601.value.alpha;
    v601(0.05, {
        vel_mod = not v603 and 0.34 or v603.m_flVelocityModifier, 
        alpha = v317.menu.elements.visuals.velocity_warning:get() and (v605 ~= 0 and v603 or l_get_alpha_0() > 0.3) and 255 or 0
    });
    local l_status_10, l_result_10 = pcall(function()
        -- upvalues: v603 (ref), l_get_alpha_0 (ref)
        return not v603:is_alive() and l_get_alpha_0() ~= 1;
    end);
    if l_status_10 and l_result_10 then
        return;
    else
        local v609 = color("EA6868FF"):lerp(color(v317.menu.elements.visuals.velocity_color:get():to_hex()), l_vel_mod_0);
        local v610 = string.format("\226\155\148 Max velocity reduced by %i%%", v605);
        render.text(1, vector(v602.position.x + 94, v602.position.y + v602.size.y - 21), color(255, l_alpha_0), "c", v610);
        render.shadow(vector(v602.position.x + 7, v602.position.y + v602.size.y - 10), vector(v602.position.x + v602.size.x - 7, v602.position.y + v602.size.y - 7), v609:alpha_modulate(l_alpha_0), 14, 0, 3);
        render.rect(vector(v602.position.x + 7, v602.position.y + v602.size.y - 10), vector(v602.position.x + v602.size.x - 7, v602.position.y + v602.size.y - 7), color(0, l_alpha_0), 3);
        render.rect(vector(v602.position.x + 7, v602.position.y + v602.size.y - 10), vector(v602.position.x + v602.size.x * l_vel_mod_0 - 7, v602.position.y - 7 + v602.size.y), v609:alpha_modulate(l_alpha_0), 3);
        return;
    end;
end);
l_events_0.render:set(function()
    -- upvalues: v317 (ref), v611 (ref)
    if v317.menu.elements.visuals.velocity_warning:get() then
        v611:update();
    end;
end);
l_events_0.createmove:set(function()
    -- upvalues: v317 (ref), v135 (ref)
    if v317.menu.elements.misc.grenade_fix:get() then
        if entity.get_local_player() == nil then
            return;
        elseif entity.get_local_player():get_player_weapon() == nil then
            return;
        else
            local v612 = entity.get_local_player():get_player_weapon():get_weapon_index();
            if v612 == 43 or not (v612 ~= 44) or not (v612 ~= 45) or not (v612 ~= 46) or not (v612 ~= 47) or v612 == 48 then
                ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set({
                    [1] = ""
                });
            else
                ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set(v135);
            end;
        end;
    end;
end);
local v613 = 1;
l_events_0.player_hurt:set(function(v614)
    -- upvalues: v317 (ref), l_get_local_player_0 (ref), v585 (ref), v574 (ref), v613 (ref)
    if v317.menu.elements.ragebot.aimbot_logging:get() and v317.menu.elements.ragebot.select_log:get("Screen") and l_get_local_player_0() == entity.get(v614.attacker, true) then
        local v615 = entity.get(v614.userid, true);
        local v616 = v585[v614.hitgroup];
        local l_weapon_2 = v614.weapon;
        if l_weapon_2 == "hegrenade" or l_weapon_2 == "inferno" or l_weapon_2 == "knife" then
            return;
        else
            if v317.menu.elements.ragebot.aimbot_logging:get() and v317.menu.elements.ragebot.select_log:get("Screen") and not v317.menu.elements.ragebot.select_log:get("Console") then
                print_raw(("\a{Link Active}mytools \a85858DFF\194\183 \aD5D5D5FFHit %s in the " .. v616 .. " for %d damage (%d hp remaining)"):format(v615:get_name(), v614.dmg_health, v614.health));
            end;
            if v614.health < 1 then
                v574[#v574 + 1] = {
                    [1] = nil, 
                    [2] = nil, 
                    [3] = 0, 
                    [1] = "\aFFFFFFC8Hit \a" .. v317.menu.elements.ragebot.accent_color:get():to_hex() .. "" .. v615:get_name() .. " \aFFFFFFC8in the \a" .. v317.menu.elements.ragebot.accent_color:get():to_hex() .. "" .. v616 .. " \aFFFFFFC8for \a" .. v317.menu.elements.ragebot.accent_color:get():to_hex() .. "" .. v614.dmg_health .. " \aFFFFFFC8damage (\a" .. v317.menu.elements.ragebot.accent_color:get():to_hex() .. "dead\aFFFFFFC8)", 
                    [2] = globals.tickcount + 300
                };
            else
                v574[#v574 + 1] = {
                    [1] = nil, 
                    [2] = nil, 
                    [3] = 0, 
                    [1] = "\aFFFFFFC8Hit \a" .. v317.menu.elements.ragebot.accent_color:get():to_hex() .. "" .. v615:get_name() .. " \aFFFFFFC8in the \a" .. v317.menu.elements.ragebot.accent_color:get():to_hex() .. "" .. v616 .. " \aFFFFFFC8for \a" .. v317.menu.elements.ragebot.accent_color:get():to_hex() .. "" .. v614.dmg_health .. " \aFFFFFFC8damage (\a" .. v317.menu.elements.ragebot.accent_color:get():to_hex() .. "" .. v614.health .. " \aFFFFFFC8hp remaining)", 
                    [2] = globals.tickcount + 300
                };
            end;
            v613 = v613 == 999 and 1 or v613 + 1;
        end;
    end;
end);
l_events_0.grenade_prediction:set(function(v618)
    -- upvalues: v317 (ref)
    if v317.menu.elements.misc.grenade_release:get() then
        if entity.get_local_player() == nil then
            return;
        elseif entity.get_local_player():get_player_weapon() == nil then
            return;
        else
            local v619 = entity.get_local_player():get_player_weapon():get_weapon_index();
            if not v619 == 44 or not v619 == 46 then
                return;
            elseif v618.damage >= v317.menu.elements.misc.min_dmg:get() then
                utils.console_exec("+attack");
                utils.execute_after(0.1, function()
                    utils.console_exec("-attack");
                end);
            end;
        end;
    end;
end);
l_events_0.aim_ack:set(function(v620)
    -- upvalues: v317 (ref), v585 (ref), v136 (ref), v574 (ref), v613 (ref)
    if v317.menu.elements.ragebot.aimbot_logging:get() and v317.menu.elements.ragebot.select_log:get("Screen") then
        player_name = v620.target:get_name();
        hitgroup = v585[v620.hitgroup];
        wanted_hitgroup = v585[v620.wanted_hitgroup];
        local l_state_2 = v620.state;
        if l_state_2 == "correction" then
            l_state_2 = "resolver";
        end;
        if l_state_2 == "prediction error" then
            l_state_2 = "pred. error";
        end;
        if l_state_2 ~= nil and v317.menu.elements.ragebot.aimbot_logging:get() and v317.menu.elements.ragebot.select_log:get("Screen") and not v317.menu.elements.ragebot.select_log:get("Console") then
            print_raw(("\a" .. v136 .. "mytools \a85858DFF\194\183 \aD5D5D5FFMissed shot in %s in the %s due to %s"):format(string.lower(player_name), wanted_hitgroup, l_state_2));
        end;
        if l_state_2 ~= nil then
            v574[#v574 + 1] = {
                [1] = nil, 
                [2] = nil, 
                [3] = 0, 
                [1] = "\aFFFFFFC8Missed shot in \a" .. v317.menu.elements.ragebot.accent_color:get():to_hex() .. "" .. player_name .. "'s \aFFFFFFC8" .. wanted_hitgroup .. " \aFFFFFFC8due to \a" .. v317.menu.elements.ragebot.accent_color:get():to_hex() .. "" .. l_state_2 .. " ", 
                [2] = globals.tickcount + 300
            };
        end;
        v613 = v613 == 999 and 1 or v613 + 1;
    end;
end);
l_events_0.render:set(function()
    -- upvalues: v574 (ref), v317 (ref), l_screen_size_0 (ref), l_text_0 (ref)
    if #v574 > 0 then
        if globals.tickcount >= v574[1][2] then
            if v574[1][3] > 0 then
                v574[1][3] = v574[1][3] - 20;
            elseif v574[1][3] <= 0 then
                table.remove(v574, 1);
            end;
        end;
        if #v574 > 6 then
            table.remove(v574, 1);
        end;
        if globals.is_connected == false then
            table.remove(v574, #v574);
        end;
        for v622 = 1, #v574 do
            text_size = render.measure_text(1, nil, v574[v622][1]).x;
            if v574[v622][3] < 255 then
                v574[v622][3] = v574[v622][3] + 10;
            end;
            if v317.menu.elements.ragebot.aimbot_logging:get() and v317.menu.elements.ragebot.select_log:get("Screen") then
                if not v317.menu.elements.ragebot.dis_glow:get() then
                    render.shadow(vector(l_screen_size_0().x / 2 - text_size / 2 + 40, l_screen_size_0().y / 1.29 - v574[v622][3] / 45 + 15 * v622 + 10), vector(l_screen_size_0().x / 2 - text_size / 2 + text_size + 25, l_screen_size_0().y / 1.29 - v574[v622][3] / 45 + 15 * v622 + 10), color(v317.menu.elements.ragebot.accent_color:get().r, v317.menu.elements.ragebot.accent_color:get().g, v317.menu.elements.ragebot.accent_color:get().b, 255), 30, 0, 0);
                end;
                l_text_0(1, vector(l_screen_size_0().x / 2 - text_size / 2 + 35, l_screen_size_0().y / 1.3 - v574[v622][3] / 45 + 15 * v622 + 10), color(255, 255, 255, v574[v622][3]), nil, v574[v622][1]);
            end;
        end;
    end;
end);
l_events_0.render:set(function()
    -- upvalues: v317 (ref)
    if v317.menu.elements.visuals.viewmodel_changer:get() then
        cvar.viewmodel_fov:int(v317.menu.elements.visuals.viewmodel_fov:get(), true);
        cvar.viewmodel_offset_x:float(v317.menu.elements.visuals.viewmodel_x:get() / 10, true);
        cvar.viewmodel_offset_y:float(v317.menu.elements.visuals.viewmodel_y:get() / 10, true);
        cvar.viewmodel_offset_z:float(v317.menu.elements.visuals.viewmodel_z:get() / 10, true);
    end;
    cvar.r_aspectratio:float(v317.menu.elements.visuals.viewmodel_aspectratio:get() / 100);
end);
v317.menu.elements.visuals.viewmodel_changer:set_callback(function()
    -- upvalues: v317 (ref)
    if not v317.menu.elements.visuals.viewmodel_changer:get() then
        cvar.viewmodel_fov:int(68);
        cvar.viewmodel_offset_x:float(2.5);
        cvar.viewmodel_offset_y:float(0);
        cvar.viewmodel_offset_z:float(-1.5);
    end;
end);
v317.menu.elements.ragebot.fakelatency:set_callback(function()
    -- upvalues: v317 (ref)
    if v317.menu.elements.ragebot.fakelatency:get() then
        cvar.sv_maxunlag:float(0.4);
    else
        cvar.sv_maxunlag:float(0.2);
    end;
end, true);
local v626 = {
    screen = l_screen_size_0(), 
    var = l_find_0("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"), 
    anim_num = 0, 
    lerp = function(v623, v624, v625)
        return v623 + (v624 - v623) * v625;
    end
};
v626.on_draw = function()
    -- upvalues: v317 (ref), l_get_local_player_0 (ref), v626 (ref)
    if v317.menu.elements.visuals.custom_scope:get() then
        local_player = l_get_local_player_0();
        if not local_player or not local_player:is_alive() or not local_player.m_bIsScoped then
            v626.anim_num = v626.lerp(v626.anim_num, 0, 15 * globals.frametime);
        else
            v626.anim_num = v626.lerp(v626.anim_num, 1, 15 * globals.frametime);
        end;
        v626.var:override("Remove All");
        v626.offset = v317.menu.elements.visuals.scope_gap:get() * v626.anim_num;
        v626.length = v317.menu.elements.visuals.scope_size:get() * v626.anim_num;
        v626.col_1 = v317.menu.elements.visuals.scope_color:get();
        v626.width = 1;
        v626.col_1.a = v626.col_1.a * v626.anim_num;
        v626.start_x = v626.screen.x / 2;
        v626.start_y = v626.screen.y / 2;
        if v317.menu.elements.visuals.scope_style:get() == "Default" then
            render.gradient(vector(v626.start_x - v626.offset, v626.start_y), vector(v626.start_x - v626.offset - v626.length, v626.start_y + v626.width), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Left") and 0 or v626.col_1.a), color(255, 255, 255, 0), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Left") and 0 or v626.col_1.a), color(255, 255, 255, 0));
            render.gradient(vector(v626.start_x + v626.offset, v626.start_y), vector(v626.start_x + v626.offset + v626.length, v626.start_y + v626.width), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Right") and 0 or v626.col_1.a), color(255, 255, 255, 0), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Right") and 0 or v626.col_1.a), color(255, 255, 255, 0));
            render.gradient(vector(v626.start_x, v626.start_y + v626.offset), vector(v626.start_x + v626.width, v626.start_y + v626.offset + v626.length), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Down") and 0 or v626.col_1.a), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Down") and 0 or v626.col_1.a), color(255, 255, 255, 0), color(255, 255, 255, 0));
            render.gradient(vector(v626.start_x, v626.start_y - v626.offset), vector(v626.start_x + v626.width, v626.start_y - v626.offset - v626.length), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Up") and 0 or v626.col_1.a), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Up") and 0 or v626.col_1.a), color(255, 255, 255, 0), color(255, 255, 255, 0));
        else
            render.gradient(vector(v626.start_x - v626.offset, v626.start_y), vector(v626.start_x - v626.offset - v626.length, v626.start_y + v626.width), color(255, 255, 255, 0), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Left") and 0 or v626.col_1.a), color(255, 255, 255, 0), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Left") and 0 or v626.col_1.a));
            render.gradient(vector(v626.start_x + v626.offset, v626.start_y), vector(v626.start_x + v626.offset + v626.length, v626.start_y + v626.width), color(255, 255, 255, 0), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Right") and 0 or v626.col_1.a), color(255, 255, 255, 0), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Right") and 0 or v626.col_1.a));
            render.gradient(vector(v626.start_x, v626.start_y + v626.offset), vector(v626.start_x + v626.width, v626.start_y + v626.offset + v626.length), color(255, 255, 255, 0), color(255, 255, 255, 0), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Down") and 0 or v626.col_1.a), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Down") and 0 or v626.col_1.a));
            render.gradient(vector(v626.start_x, v626.start_y - v626.offset), vector(v626.start_x + v626.width, v626.start_y - v626.offset - v626.length), color(255, 255, 255, 0), color(255, 255, 255, 0), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Up") and 0 or v626.col_1.a), color(v626.col_1.r, v626.col_1.g, v626.col_1.b, v317.menu.elements.visuals.remove_line:get("Up") and 0 or v626.col_1.a));
        end;
    end;
end;
l_events_0.render:set(v626.on_draw);
v317.menu.elements.visuals.custom_scope:set_callback(function()
    -- upvalues: v317 (ref), v626 (ref)
    if not v317.menu.elements.visuals.custom_scope:get() then
        v626.var:override();
    end;
end);
l_events_0.createmove:set(function()
    -- upvalues: v317 (ref)
    if v317.menu.elements.antiaims.antiaims_tweaks:get("Fluctuate Fake Lag") then
        ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"):override(globals.tickcount % 9 == 8 and 1 or ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"):get());
    else
        ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"):override();
    end;
end);
l_events_0.createmove:set(function()
    -- upvalues: l_get_local_player_0 (ref), v317 (ref)
    local v627 = l_get_local_player_0();
    if v627 == nil then
        return;
    elseif v627:get_player_weapon() == nil then
        return;
    elseif v317.refs.hs:get() then
        return;
    else
        local v628 = v627:get_player_weapon():get_weapon_index();
        local v629 = v628 == 2 or not (v628 ~= 3) or not (v628 ~= 4) or not (v628 ~= 30) or not (v628 ~= 32) or not (v628 ~= 36) or not (v628 ~= 61) or v628 == 63;
        local v630 = v628 == 11 or v628 == 38;
        local v631 = v628 == 9;
        local v632 = v628 == 40;
        local v633 = v628 == 1 or v628 == 64;
        local v634 = v627:get_player_weapon():get_classname() == "CKnife" or v628 == 31;
        local v635 = entity.get_players(true, false);
        for v636, v637 in pairs({
            [1] = v629, 
            [2] = v630, 
            [3] = v631, 
            [4] = v632, 
            [5] = v633, 
            [6] = v634, 
            [7] = not v629 and not v630 and not v631 and not v632 and not v633 and not v634
        }) do
            if v317.menu.elements.antiaims.antiaims_tweaks:get("Auto Teleport") and v317.menu.elements.antiaims.weapons:get(v636) and v637 and bit.band(v627.m_fFlags, bit.lshift(1, 0)) == 0 then
                for v638 = 1, #v635 do
                    if v635[v638]:is_alive() and v635[v638]:is_visible(v635[v638]:get_origin()) and globals.tickcount % v317.menu.elements.antiaims.delayticks:get() == v317.menu.elements.antiaims.delayticks:get() - 1 then
                        rage.exploit:force_teleport();
                    end;
                end;
            end;
        end;
        return;
    end;
end);
new_class():struct("killsay")({
    killsay_pharases = {
        [1] = {
            [1] = "\226\160\1281", 
            [2] = "nice iq"
        }, 
        [2] = {
            [1] = "cgb gblfhfc", 
            [2] = "\209\129\208\191\208\184 \208\191\208\184\208\180\208\190\209\128\208\176\209\129"
        }, 
        [3] = {
            [1] = "\208\191\208\183\208\180\209\134", 
            [2] = "\208\184\208\179\209\128\208\190\208\186"
        }
    }, 
    death_say = {
        [1] = {
            [1] = "\209\132\209\131 \209\130\209\139 \208\183\208\176\208\181\208\177\208\176\208\187 \208\186\208\190\208\189\209\135"
        }, 
        [2] = {
            [1] = ")", 
            [2] = "\209\133\208\190\209\128\208\190\209\136)"
        }, 
        [3] = {
            [1] = "\208\189\208\190\209\128\208\188 \209\130\209\128\208\181\208\186\208\176\208\181\209\136\209\140", 
            [2] = "\209\131\208\177\208\187\209\142\208\180\208\184\208\189\208\176"
        }, 
        [4] = {
            [1] = "\208\176 \209\135\208\181", 
            [2] = "\209\133\208\176\208\185\208\180\209\136\208\190\209\130\209\139 \208\189\208\176 \209\132\208\180 \209\131\208\182\208\181 \208\189\208\181 \209\128\208\176\208\177\208\190\209\130\208\176\209\142\209\130?"
        }
    }, 
    init = function(v639)
        -- upvalues: l_events_0 (ref), l_get_local_player_0 (ref), v317 (ref), l_random_0 (ref)
        l_events_0.player_death:set(function(v640)
            -- upvalues: l_get_local_player_0 (ref), v317 (ref), v639 (ref), l_random_0 (ref)
            delayed_msg = function(v641, v642)
                return utils.execute_after(v641, function()
                    -- upvalues: v642 (ref)
                    utils.console_exec("say " .. v642);
                end);
            end;
            local v643 = 2.3;
            local v644 = l_get_local_player_0();
            local v645 = entity.get(v640.userid, true);
            local v646 = entity.get(v640.attacker, true);
            local v647 = 0;
            local v648 = 0;
            if l_get_local_player_0() == nil then
                return;
            else
                local l_m_bWarmupPeriod_0 = entity.get_game_rules().m_bWarmupPeriod;
                if v317.menu.elements.misc.killsay_disablers:get() and l_m_bWarmupPeriod_0 == true then
                    return;
                elseif not v317.menu.elements.misc.killsay:get() then
                    return;
                else
                    if v645 ~= v646 and v646 == v644 then
                        local v650 = v639.killsay.killsay_pharases[l_random_0(1, #v639.killsay.killsay_pharases)];
                        for v651 = 1, #v650 do
                            local v652 = v650[v651];
                            v647 = v647 + #v650[v651] / 24 * v643;
                            delayed_msg(v647, v652);
                        end;
                    end;
                    if v645 == v644 and v646 ~= v644 then
                        local v653 = v639.killsay.death_say[l_random_0(1, #v639.killsay.death_say)];
                        for v654 = 1, #v653 do
                            local v655 = v653[v654];
                            v648 = v648 + #v653[v654] / 20 * v643;
                            delayed_msg(v648, v655);
                        end;
                    end;
                    return;
                end;
            end;
        end);
    end
}).killsay:init();
local v659 = esp.enemy:new_text("R8 Helper", "\a2FD500FFDMG+", function(v656)
    -- upvalues: l_get_local_player_0 (ref)
    local v657 = l_get_local_player_0();
    local v658 = v657:get_origin():dist((v656:get_origin()));
    if not v657 then
        return;
    elseif v657:is_alive() and v657:get_player_weapon():get_weapon_index() == 64 and v656.m_ArmorValue == 0 then
        if v658 < 585 then
            return "\a2FD500FFDMG+";
        else
            return " ";
        end;
    else
        return;
    end;
end);
v317.menu.elements.ragebot.rev_help:set_callback(function()
    -- upvalues: v317 (ref), v659 (ref)
    if v317.menu.elements.ragebot.rev_help:get() then
        v659:set(true);
    end;
    if not v317.menu.elements.ragebot.rev_help:get() then
        v659:set(false);
    end;
end);
l_events_0.createmove:set(function(v660)
    -- upvalues: v317 (ref), l_get_local_player_0 (ref), v320 (ref), l_find_0 (ref)
    if v317.menu.elements.antiaims.antiaim_mode:get() == "Defensive Preset" then
        return;
    else
        local function _()
            -- upvalues: l_get_local_player_0 (ref)
            local l_m_fFlags_1 = l_get_local_player_0().m_fFlags;
            if bit.band(l_m_fFlags_1, 4) == 4 then
                return true;
            else
                return false;
            end;
        end;
        local _ = false;
        local v664 = l_get_local_player_0();
        local v665 = v320:get_velocity(v664);
        local v666 = v320:state(v665, nil, v660);
        local _ = l_get_local_player_0();
        if v317.menu.elements.antiaims.force_lag:get() then
            if ((v666 == 2 and v317.menu.elements.antiaims.lag_conditions:get("Standing") or v666 == 3 and v317.menu.elements.antiaims.lag_conditions:get("Moving") or v666 == 4 and v317.menu.elements.antiaims.lag_conditions:get("Slow Walking") or v666 == 7 and v317.menu.elements.antiaims.lag_conditions:get("Crouching") or v666 == 8 and v317.menu.elements.antiaims.lag_conditions:get("Crouch Move")) and true or (not (v666 ~= 5) or v666 == 6) and (v317.menu.elements.antiaims.lag_conditions:get("In Air") and true or false)) == true then
                l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On");
                l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC");
            else
                l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override();
                l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override();
            end;
        end;
        return;
    end;
end);
v317.menu.elements.antiaims.force_lag:set_callback(function(v668)
    -- upvalues: l_find_0 (ref)
    if not v668:get() then
        l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override();
        l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override();
    end;
end);
hitchanceoverride = function(v669)
    -- upvalues: l_find_0 (ref), v317 (ref), l_get_local_player_0 (ref)
    local v670 = l_find_0("Aimbot", "Ragebot", "Selection", "Hit Chance");
    if not v317.menu.elements.ragebot.hc_enable:get() then
        return;
    else
        local v671 = l_get_local_player_0();
        if not v671 then
            return;
        else
            local v672 = v671:get_player_weapon();
            if v672 == nil then
                return;
            else
                local v673 = v672:get_weapon_index() == 38 or not (v672:get_weapon_index() ~= 11) or not (v672:get_weapon_index() ~= 9) or v672:get_weapon_index() == 40;
                if v317.menu.elements.ragebot.hc_cond:get("No scope") and not v671.m_bIsScoped and v673 then
                    v670:override(v317.menu.elements.ragebot.hc_ns:get());
                end;
                if v317.menu.elements.ragebot.hc_cond:get("Air") and v669.in_jump and v673 then
                    v670:override(v317.menu.elements.ragebot.hc_air:get());
                end;
                if (not v317.menu.elements.ragebot.hc_cond:get("No scope") or v669.in_jump or v671.m_bIsScoped or not v673) and (not v317.menu.elements.ragebot.hc_cond:get("Air") or not v669.in_jump or not v673) then
                    v670:override();
                end;
                return;
            end;
        end;
    end;
end;
l_events_0.createmove:set(hitchanceoverride);
new_class():struct("custom_miss_logger")({
    hitlogger = (function()
        -- upvalues: l_events_0 (ref), l_world_to_screen_0 (ref), l_text_0 (ref)
        return {
            [1] = nil, 
            [2] = 8, 
            callback_registered = false, 
            [1] = maximum_count, 
            data = {}, 
            register_callback = function(v674)
                -- upvalues: l_events_0 (ref), l_world_to_screen_0 (ref), l_text_0 (ref)
                if v674.callback_registered then
                    return;
                else
                    l_events_0.render:set(function()
                        -- upvalues: v674 (ref), l_world_to_screen_0 (ref), l_text_0 (ref)
                        local _ = {
                            [1] = 56, 
                            [2] = 56, 
                            [3] = 57
                        };
                        local v676 = 10;
                        local l_data_1 = v674.data;
                        for v678 = #l_data_1, 1, -1 do
                            v674.data[v678].time = v674.data[v678].time - globals.frametime;
                            local v679 = 255;
                            local v680 = 0;
                            local v681 = l_data_1[v678];
                            if v681.time < 0 then
                                table.remove(v674.data, v678);
                            else
                                local v682 = v681.def_time - v681.time;
                                local v683 = v682 > 1 and 1 or v682;
                                local v684 = 0.48;
                                local v685 = 0;
                                if v681.time < 0.48 then
                                    v685 = (v683 < 1 and v683 or v681.time) / 0.48;
                                end;
                                if v683 < v684 then
                                    v685 = (v683 < 1 and v683 or v681.time) / 0.48;
                                end;
                                if v681.time < 0.48 then
                                    v680 = (v683 < 1 and v683 or v681.time) / 0.48;
                                    v679 = v680 * 255;
                                    if v680 < 0.2 then
                                        v676 = v676 - 15 * (1 - v680 / 0.2);
                                    end;
                                end;
                                local v686 = v681.time < 0.48 and -1 or 1;
                                v681.draw = tostring(v681.draw):upper();
                                if v681.draw ~= "" then
                                    if v681.shot_pos == nil or l_world_to_screen_0(v681.shot_pos) == nil then
                                        return;
                                    else
                                        local l_x_4 = l_world_to_screen_0(v681.shot_pos).x;
                                        local l_y_3 = l_world_to_screen_0(v681.shot_pos).y;
                                        local _ = 55 * (v679 * v686) / 255 * v686;
                                        l_text_0(2, vector(l_x_4, l_y_3), color(255, 145, 145, v679), "", "\aFFFFFFFFx   \aDEFAULT" .. v681.draw);
                                        v676 = v676 + 25;
                                    end;
                                end;
                            end;
                        end;
                        v674.callback_registered = true;
                    end);
                    return;
                end;
            end, 
            paint = function(v690, v691, v692, v693)
                local v694 = tonumber(v691) + 1;
                for v695 = 1, 2, -1 do
                    v690.data[v695] = v690.data[v695 - 1];
                end;
                v690.data[1] = {
                    time = v694, 
                    def_time = v694, 
                    draw = v692, 
                    shot_pos = v693
                };
                v690:register_callback();
            end
        };
    end)()
}):struct("aim_hit")({
    init = function(v696)
        -- upvalues: l_events_0 (ref), v317 (ref)
        l_events_0.aim_ack:set(function(v697)
            -- upvalues: v317 (ref), v696 (ref)
            if v697.state == "correction" then
                v697.state = "resolver";
            end;
            if v697.state == "lagcomp failure" then
                v697.state = "lagcomp";
            end;
            if v317.menu.elements.visuals.markers:get() and v317.menu.elements.visuals.miss_marker:get() and v697.state ~= nil then
                v696.custom_miss_logger.hitlogger:paint(2, v697.state, v697.aim);
            end;
        end);
    end
}).aim_hit:init();
l_events_0.createmove:set(function(_)
    -- upvalues: v317 (ref), l_get_alpha_0 (ref)
    if (v317.menu.elements.antiaims.antiaim_mode:get() == "Classic Jitter" or v317.menu.elements.antiaims.antiaim_mode:get() == "Defensive Preset") and l_get_alpha_0() > 0.3 then
        v317.refs.pitch:override();
        v317.refs.yaw:override();
        v317.refs.jyaw:override();
        v317.refs.jyaw_slider:override();
        v317.refs.base:override();
        v317.refs.fake_op:override();
        v317.refs.left_limit:override();
        v317.refs.right_limit:override();
        v317.refs.hidden:override();
    end;
end);
local _ = l_screen_size_0().x;
local _ = l_screen_size_0().y;
local _ = 0;
local _ = 1;
local _ = 0;
local _ = 0;
local _ = {
    [""] = {
        alpha_k = 0
    }
};
local _ = 1;
local _ = 0;
l_events_0.render:set(function()
    -- upvalues: v317 (ref), v141 (ref), l_text_0 (ref), l_screen_size_0 (ref)
    if not v317.menu.elements.visuals.on_screen:get() or v317.menu.elements.visuals.select:get() == "Disable" then
        if not globals.is_in_game then
            return;
        else
            idc = v141.gradient("M Y T O O L S", color(), color(61, 115, 235, 255));
            l_text_0(1, vector(25, l_screen_size_0().y / 2), color(), nil, idc .. (v317.cheat.version == "Nightly" and " \aFF7777FF[DEV]" or " "));
        end;
    end;
end);
window = function(v708, v709, v710, v711, v712, v713)
    -- upvalues: v317 (ref), l_text_0 (ref)
    local v714 = render.measure_text(1, "", v712);
    local l_r_0 = v317.menu.elements.visuals.accent_col:get().r;
    local l_g_0 = v317.menu.elements.visuals.accent_col:get().g;
    local l_b_0 = v317.menu.elements.visuals.accent_col:get().b;
    if v317.menu.elements.visuals.solus_widgets:get() then
        render.rect(vector(v708 - 3, v709), vector(v708 + v710 + 6, v709 + 3 + v711), color(0, 0, 0, v713 / 3), 0);
        render.shadow(vector(v708 - 3, v709), vector(v708 + v710 + 6, v709 + 3 + v711), color(l_r_0, l_g_0, l_b_0, v713 / 1.1), 15, nil, 0);
        l_text_0(1, vector(v708 + 1 + v710 / 2 + 1 - v714.x / 2, v709 + 1 + v711 / 2 - v714.y / 2), color(255, 255, 255, v713), "", v712);
    end;
end;
local _, _ = pcall(function()
    return render.load_image(network.get("https://cdn.discordapp.com/attachments/766390146479685662/1092052169814986843/star-solid.png"));
end);
local _ = l_screen_size_0().x;
local _ = l_screen_size_0().y;
local v722 = 0;
local v723 = 1;
local _ = 0;
local v725 = 0;
local v726 = {
    [""] = {
        alpha_k = 0
    }
};
local _ = 1;
local v728 = 0;
local v744 = l_system_0.register({
    [1] = v317.menu.elements.visuals.pos_x_s, 
    [2] = v317.menu.elements.visuals.pos_y_s
}, vector(120, 60), "Test", function(v729)
    -- upvalues: v317 (ref), v142 (ref), l_get_binds_0 (ref), v726 (ref), l_text_0 (ref), v725 (ref), v723 (ref), l_get_alpha_0 (ref), v722 (ref)
    if v317.menu.elements.visuals.solus_widgets:get() and v317.menu.elements.visuals.solus_widgets_s:get("Hotkeys") then
        if not contains(v142, "Hotkeys") then
            table.insert(v142, "Hotkeys");
            check_windows();
        end;
        local v730 = 0;
        local v731 = globals.frametime * 16;
        local v732 = 0;
        local _ = 66;
        local v734 = {};
        local v735 = l_get_binds_0();
        for v736 = 1, #v735 do
            local v737 = v735[v736];
            local v738 = v735[v736].mode == 1 and "holding" or v735[v736].mode == 2 and "toggled" or "[?]";
            local l_value_0 = v735[v736].value;
            local l_name_0 = v735[v736].name;
            if l_name_0 == "Peek Assist" then
                l_name_0 = "Quick peek";
            end;
            if l_name_0 == "Edge Jump" then
                l_name_0 = "Jump at edge";
            end;
            if l_name_0 == "Hide Shots" then
                l_name_0 = "Hide shots";
            end;
            if l_name_0 == "Min. Damage" then
                l_name_0 = "Minimum damage";
            end;
            if l_name_0 == "Fake Latency" then
                l_name_0 = "Ping spike";
            end;
            if l_name_0 == "Fake Duck" then
                l_name_0 = "Fake duck";
            end;
            if l_name_0 == "Safe Points" then
                l_name_0 = "Safe point";
            end;
            if l_name_0 == "Body Aim" then
                l_name_0 = "Body aim";
            end;
            if l_name_0 == "Double Tap" then
                l_name_0 = "Double tap";
            end;
            if l_name_0 == "Yaw Base" then
                l_name_0 = "Manual override";
            end;
            if l_name_0 == "Slow Walk" then
                l_name_0 = "Slow motion";
            end;
            if l_name_0 == "Dormant Aimbot" then
                l_name_0 = "Dormant aimbot";
            end;
            local v741 = render.measure_text(1, "", v738);
            local v742 = render.measure_text(1, "", l_name_0);
            if v726[v737.name] == nil then
                v726[v737.name] = {
                    alpha_k = 0
                };
            end;
            v726[v737.name].alpha_k = lerp(v731, v726[v737.name].alpha_k, v737.active and 255 or 0);
            l_text_0(1, vector(v729.position.x + 3, v729.position.y + 23 + v732), color(255, v726[v737.name].alpha_k), "", l_name_0);
            if l_name_0 == "Minimum damage" or l_name_0 == "Ping spike" then
                l_text_0(1, vector(v729.position.x + (v725 - v741.x) - render.measure_text(1, nil, l_value_0).x + 28, v729.position.y + 23 + v732), color(255, v726[v737.name].alpha_k), "", "[" .. l_value_0 .. "]");
            else
                l_text_0(1, vector(v729.position.x + (v725 - v741.x - 8), v729.position.y + 23 + v732), color(255, v726[v737.name].alpha_k), "", "[" .. v738 .. "]");
            end;
            v732 = v732 + 16 * v726[v737.name].alpha_k / 255;
            local v743 = v741.x + v742.x + 18;
            if v743 > 119 and v730 < v743 then
                v730 = v743;
            end;
            if v735.active then
                table.insert(v734, v735);
            end;
        end;
        v723 = lerp(v731, v723, (not (l_get_alpha_0() <= 0) or v732 > 0) and 1 or 0);
        v725 = lerp(v731, v725, math.max(v730, 119));
        if l_get_alpha_0() > 0 or v732 > 6 then
            v722 = lerp(v731, v722, math.max(l_get_alpha_0() * 255, v732 > 1 and 255 or 0));
        elseif v732 < 15.99 and ui.get_alpha() == 0 then
            v722 = lerp(v731, v722, 0);
        end;
        if l_get_alpha_0() or #v734 > 0 then
            window(v729.position.x, v729.position.y, v725, 16, "keybinds", v722);
        end;
    end;
end);
local l_status_12, l_result_12 = pcall(function()
    return render.load_image(network.get("https://avatars.cloudflare.steamstatic.com/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_medium.jpg"));
end);
local v756 = l_system_0.register({
    [1] = v317.menu.elements.visuals.pos_x1_s, 
    [2] = v317.menu.elements.visuals.pos_y1_s
}, vector(120, 60), "Test2", function(v747)
    -- upvalues: v317 (ref), v142 (ref), l_get_alpha_0 (ref), v728 (ref), l_get_local_player_0 (ref), l_status_12 (ref), l_result_12 (ref), l_text_0 (ref), l_texture_0 (ref)
    if v317.menu.elements.visuals.solus_widgets:get() and v317.menu.elements.visuals.solus_widgets_s:get("Spectators") then
        if not contains(v142, "Spectators") then
            table.insert(v142, "Spectators");
            check_windows();
        end;
        local v748 = globals.frametime * 16;
        if l_get_alpha_0() > 0 then
            v728 = lerp(v748, v728, math.max(l_get_alpha_0() * 255, 0 > 1 and 255 or 0));
        elseif l_get_alpha_0() == 0 then
            v728 = lerp(v748, v728, 0);
        end;
        window(v747.position.x, v747.position.y, 120, 16, "spectators", v728);
        local v749 = l_get_local_player_0();
        if v749 == nil then
            return;
        else
            if v749.m_hObserverTarget and (v749.m_iObserverMode == 4 or v749.m_iObserverMode == 5) then
                v749 = v749.m_hObserverTarget;
            end;
            local v750 = v749.get_spectators(v749);
            if v750 == nil then
                return;
            else
                for v751, v752 in ipairs(v750) do
                    local v753 = v752:get_name();
                    local _ = render.measure_text(1, "", v753).x;
                    name_sub = string.len(v753) > 17 and string.sub(v753, 0, 17) .. "..." or v753;
                    local v755 = v752:get_steam_avatar();
                    if v755 == nil or v755.width <= 5 then
                        v755 = l_status_12 and l_result_12 or "";
                    end;
                    if not v752:is_bot() or v752:is_player() then
                        l_text_0(1, vector(v747.position.x + 17, v747.position.y + 8 + v751 * 16), color(), "u", name_sub);
                        l_texture_0(v755, vector(v747.position.x + 1, v747.position.y + 8 + v751 * 16), vector(12, 12), color(), "f", 0);
                    end;
                end;
                if #v749.get_spectators(v749) > 0 or v749.m_iObserverMode == 4 or v749.m_iObserverMode == 5 then
                    window(v747.position.x, v747.position.y, 120, 16, "spectators", 255);
                end;
            end;
        end;
    end;
end);
l_events_0.render:set(function()
    -- upvalues: v744 (ref), v756 (ref)
    v744:update();
    v756:update();
end);
local function v768(v757)
    -- upvalues: l_get_local_player_0 (ref), l_trace_line_0 (ref)
    local l_x_8 = l_get_local_player_0().m_vecOrigin.x;
    local l_y_6 = l_get_local_player_0().m_vecOrigin.y;
    local l_z_0 = l_get_local_player_0().m_vecOrigin.z;
    local v761 = math.pi * 2;
    for v762 = 0, v761, v761 / 8 do
        local v763 = 10 * math.cos(v762) + l_x_8;
        local v764 = 10 * math.sin(v762) + l_y_6;
        local v765 = l_trace_line_0(vector(v763, v764, l_z_0), vector(v763, v764, l_z_0 - v757), l_get_local_player_0());
        local l_fraction_0 = v765.fraction;
        local _ = v765.entity;
        if l_fraction_0 ~= 1 then
            return true;
        end;
    end;
    return false;
end;
l_events_0.createmove:set(function(v769)
    -- upvalues: v317 (ref), l_get_local_player_0 (ref), v768 (ref)
    if not v317.menu.elements.antiaims.antiaims_tweaks:get("No Fall Damage") then
        return;
    else
        me = l_get_local_player_0();
        if me == nil then
            return;
        else
            if me.m_vecVelocity.z >= -500 then
                no_fall_damage = false;
            elseif v768(15) then
                no_fall_damage = false;
            elseif v768(75) then
                no_fall_damage = true;
            end;
            if me.m_vecVelocity.z < -500 then
                if no_fall_damage then
                    v769.in_duck = 1;
                else
                    v769.in_duck = 0;
                end;
            end;
            return;
        end;
    end;
end);
v317.menu.elements.antiaims.antiaims_tweaks:set_callback(function(v770)
    if v770:get("Avoid Backstab") then
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"):override(true);
    else
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"):override();
    end;
end, true);
l_events_0.createmove:set(function()
    -- upvalues: v317 (ref)
    if v317.menu.elements.antiaims.freestanding:get() then
        v317.refs.freestanding_yaw:set(true);
    else
        v317.refs.freestanding_yaw:set(false);
    end;
    local v771 = v317.menu.elements.antiaims.manual_aa:get();
    if v317.menu.elements.antiaims.freestanding:get() and v317.menu.elements.antiaims.body_freestanding:get() then
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"):override(true);
    else
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"):override();
    end;
    if v317.menu.elements.antiaims.freestanding:get() and v317.menu.elements.antiaims.disable_manual:get() and v317.refs.freestanding_yaw:get() and (v771 == "Right" or v771 == "Left" or v771 == "Forward") then
        v317.refs.freestanding_yaw:set(false);
    end;
end);
l_events_0.createmove:set(function()
    -- upvalues: l_get_local_player_0 (ref), v317 (ref)
    if l_get_local_player_0() == nil then
        return;
    else
        local l_m_bWarmupPeriod_1 = entity.get_game_rules().m_bWarmupPeriod;
        if v317.menu.elements.antiaims.antiaims_tweaks:get("Dis. AA on Warmup") and l_m_bWarmupPeriod_1 then
            v317.refs.enable_desync:override(false);
            v317.refs.yaw:override(math.random(-180, 180));
            v317.refs.yaw_base:override("Static");
            v317.refs.pitch:override("Disabled");
        end;
        return;
    end;
end);
local v773 = db.tab_mover or {};
local v774 = {
    Aimbot = {
        [1] = "Ragebot", 
        [2] = "Anti Aim"
    }, 
    Visuals = {
        [1] = "Players", 
        [2] = "World", 
        [3] = "Inventory"
    }, 
    Miscellaneous = {
        [1] = "Main"
    }
};
local function v779(v775, v776)
    for v777, v778 in pairs(v776) do
        if v777 == v775 or v778 == v775 then
            return true;
        end;
    end;
    return false;
end;
local v780 = nil;
v780 = {
    parse_remote = function(_, v782)
        -- upvalues: v773 (ref)
        network.get(v782, {}, function(v783)
            -- upvalues: v773 (ref)
            local l_status_13, _ = pcall(function()
                -- upvalues: v783 (ref)
                return json.parse(v783);
            end);
            if not l_status_13 then
                print_error("url parser error");
                return;
            else
                for v786, v787 in pairs(v773) do
                    v773[v786] = v787;
                end;
                return true;
            end;
        end);
    end, 
    export = function(_, v789)
        -- upvalues: v774 (ref), v773 (ref)
        local v790 = v789 or "Last Config";
        local v791 = {};
        for v792, v793 in pairs(v774) do
            v791[v792] = {};
            for _, v795 in ipairs(v793) do
                local v796 = ui.find(v792, v795);
                v791[v792][v795] = v796:export();
            end;
        end;
        v791 = json.stringify({
            config = v791
        });
        v773[v790] = v791;
        return v791;
    end, 
    import = function(_, v798, v799)
        -- upvalues: v774 (ref), v779 (ref)
        local l_status_14, l_result_14 = pcall(function()
            -- upvalues: v798 (ref)
            return json.parse(v798);
        end);
        if not l_status_14 then
            print_error("An error occured: provided config data is outdated");
            return;
        else
            for v802, v803 in pairs(v774) do
                local v804 = l_result_14.config[v802];
                do
                    local l_v802_0 = v802;
                    if v804 ~= nil then
                        for _, v807 in pairs(v803) do
                            do
                                local l_v807_0 = v807;
                                if v779(l_v807_0, v804) and v779(l_v807_0, v799) then
                                    local l_status_15, l_result_15 = pcall(function()
                                        -- upvalues: l_v802_0 (ref), l_v807_0 (ref)
                                        return ui.find(l_v802_0, l_v807_0);
                                    end);
                                    if not l_status_15 then
                                        print_error("An error occured: skipped [%s=>%s] - outdated");
                                    else
                                        l_result_15:import(l_result_14.config[l_v802_0][l_v807_0]);
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            return;
        end;
    end
};
v780 = setmetatable({}, {
    __metatable = false, 
    __index = v780
});
local v811 = nil;
v811 = {};
(function(v812, v813, v814)
    -- upvalues: v811 (ref)
    local v815 = ui.create(v812, v813);
    v814(v811, v815);
end)("General", "Cheat Additionals", function(v816, v817)
    -- upvalues: v774 (ref), v780 (ref), l_clipboard_0 (ref), v317 (ref)
    local v818 = {};
    for _, v820 in pairs(v774) do
        for _, v822 in pairs(v820) do
            table.insert(v818, v822);
        end;
    end;
    v816.mover_tabs = v817:listable("", v818);
    v816.export_btn = v817:button("\a{Link Active}\239\130\147   \aDEFAULTExport Cheat Config", function()
        -- upvalues: v780 (ref), l_clipboard_0 (ref)
        local v823 = v780:export();
        l_clipboard_0.set(v823);
    end, true);
    v816.import_btn = v817:button("\a{Link Active}\239\128\153   \aDEFAULTImport Cheat Config", function()
        -- upvalues: l_clipboard_0 (ref), v816 (ref), v780 (ref)
        local v824 = l_clipboard_0.get();
        local v825 = {};
        for _, v827 in pairs(v816.mover_tabs:list()) do
            if v816.mover_tabs:get(v827) then
                table.insert(v825, v827);
            end;
        end;
        v780:import(v824, v825);
    end, true);
    v317.menu.elements.misc.config_stealer:set_callback(function(v828)
        -- upvalues: v816 (ref)
        v816.mover_tabs:visibility(v828:get());
        v816.export_btn:visibility(v828:get());
        v816.import_btn:visibility(v828:get());
    end, true);
end);
l_events_0.shutdown:set(function()
    -- upvalues: v773 (ref)
    db.tab_mover = v773;
end);
v317.menu.elements.ragebot.aimbot_logging:set_callback(function(v829)
    -- upvalues: v317 (ref)
    if v829:get() then
        v317.refs.logs:override("");
    else
        v317.refs.logs:override();
    end;
end, true);
v317.menu.elements.antiaims.antiaim_mode:set_callback(function(v830)
    -- upvalues: v317 (ref), l_find_0 (ref)
    if v830:get() == "Disabled" then
        v317.menu.elements.antiaims.force_lag:visibility(true);
    elseif v830:get() == "Classic Jitter" then
        v317.menu.elements.antiaims.force_lag:visibility(true);
    elseif v830:get() == "Defensive Preset" then
        v317.menu.elements.antiaims.force_lag:visibility(false);
    elseif v830:get() == "Conditional" then
        v317.menu.elements.antiaims.force_lag:visibility(true);
    end;
    v317.menu.elements.antiaims.tp:visibility(v830:get() == "Classic Jitter" or v830:get() == "Defensive Preset");
    if v830:get() ~= "Defensive Preset" then
        l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override();
        l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override();
    end;
end, true);