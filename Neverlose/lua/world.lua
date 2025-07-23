-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

_DEBUG = false;
files.create_folder("csgo\\models\\remaper");
local v0 = {
    ["csgo\\models\\remaper"] = {
        [1] = "lantern_bugs.mdl", 
        [2] = "lantern_bugs.vvd", 
        [3] = "lantern_bugs.dx90.vtx", 
        [4] = "palacelightbugs.mdl", 
        [5] = "palacelightbugs.vvd", 
        [6] = "palacelightbugs.dx90.vtx", 
        [7] = "polelightbugs.mdl", 
        [8] = "polelightbugs.vvd", 
        [9] = "polelightbugs.dx90.vtx"
    }, 
    ["csgo\\materials\\remaper"] = {
        [1] = "irlflare.vtf", 
        [2] = "light_glowirl.vmt"
    }, 
    ["csgo\\materials\\models\\remaper"] = {
        [1] = "bugs_noise.vtf", 
        [2] = "lanternbugs.vmt", 
        [3] = "lanternbugs_chill.vmt"
    }
};
for v1, v2 in pairs(v0) do
    files.create_folder(v1);
    for _, v4 in ipairs(v2) do
        local v5 = v1 .. "\\" .. v4;
        if files.read(v5) == nil then
            local v6 = string.find(v4, ".vmt") ~= nil;
            local v7 = network.get("https://northon.dev/neverlose/remaper/" .. v4);
            if v7 == nil then
                print("Failed to download file");
            end;
            files.write(v5, v7, not v6);
        end;
    end;
end;
v0 = function()
    local l_cast_0 = ffi.cast;
    local l_new_0 = ffi.new;
    local l_string_0 = ffi.string;
    local l_typeof_0 = ffi.typeof;
    local l_C_0 = ffi.C;
    local l_sub_0 = string.sub;
    local l_gsub_0 = string.gsub;
    local l_format_0 = string.format;
    local l_find_0 = string.find;
    local l_match_0 = string.match;
    local _ = string.gmatch;
    local l_tostring_0 = tostring;
    local l_tonumber_0 = tonumber;
    local l_pairs_0 = pairs;
    local l_ipairs_0 = ipairs;
    local l_type_0 = type;
    local l_next_0 = next;
    local l_setmetatable_0 = setmetatable;
    local l_getmetatable_0 = getmetatable;
    local l_remove_0 = table.remove;
    local l_sort_0 = table.sort;
    local l_get_0 = entity.get;
    local l_get_local_player_0 = entity.get_local_player;
    local l_camera_angles_0 = render.camera_angles;
    local l_world_to_screen_0 = render.world_to_screen;
    local l_circle_0 = render.circle;
    local l_trace_line_0 = utils.trace_line;
    local l_execute_after_0 = utils.execute_after;
    local _ = materials.create;
    local l_get_materials_0 = materials.get_materials;
    local l_get_1 = materials.get;
    local l_base64_0 = require("neverlose/base64");
    local l_memory_0 = require("neverlose/memory");
    local _ = require("neverlose/clipboard");
    local v42 = nil;
    local v43 = l_typeof_0("            struct {\n                uint32_t signature;\n                uint32_t version;\n                uint32_t tree_size;\n                uint32_t file_data_section_size;\n                uint32_t archive_md5_section_size;\n                uint32_t other_md5_section_size;\n                uint32_t signature_section_size;\n            } *\n        ");
    local v44 = l_typeof_0("            struct {\n                uint32_t crc;\n                uint16_t preload_bytes;\n                uint16_t archive_index;\n                uint32_t entry_offset;\n                uint32_t entry_length;\n                uint16_t terminator;\n            } *\n        ");
    local function v47(v45)
        -- upvalues: l_string_0 (ref), l_tonumber_0 (ref)
        local l_v45_0 = v45;
        while v45[0] ~= 0 do
            v45 = v45 + 1;
        end;
        return l_string_0(l_v45_0, l_tonumber_0(v45 - l_v45_0)), v45 + 1;
    end;
    do
        local l_v43_0, l_v44_0, l_v47_0 = v43, v44, v47;
        v42 = function(v51)
            -- upvalues: l_cast_0 (ref), l_v43_0 (ref), l_v47_0 (ref), l_format_0 (ref), l_v44_0 (ref)
            local v52 = files.read(v51, true);
            if v52 == nil then
                return print("Failed to read VPK");
            else
                local v53 = {};
                local v54 = l_cast_0("uint8_t*", v52);
                local v55 = l_cast_0(l_v43_0, v54);
                local v56 = 28;
                if v55.signature ~= 1437209140 then
                    return print("Invalid VPK signature");
                else
                    local v57 = v54 + v56;
                    while true do
                        local v58, v59 = l_v47_0(v57);
                        v57 = v59;
                        if v58 ~= "" then
                            local v60 = v53[v58];
                            if v60 == nil then
                                v60 = {};
                                v53[v58] = v60;
                            end;
                            while true do
                                local v61, v62 = l_v47_0(v57);
                                v57 = v62;
                                if v61 ~= "" then
                                    while true do
                                        local v63, v64 = l_v47_0(v57);
                                        v57 = v64;
                                        if v63 ~= "" then
                                            local v65 = l_format_0("%s/%s.%s", v61, v63, v58);
                                            local l_preload_bytes_0 = l_cast_0(l_v44_0, v57).preload_bytes;
                                            v57 = v57 + 18 + l_preload_bytes_0;
                                            v60[#v60 + 1] = v65;
                                        else
                                            break;
                                        end;
                                    end;
                                else
                                    break;
                                end;
                            end;
                        else
                            break;
                        end;
                    end;
                    return v53;
                end;
            end;
        end;
    end;
    v43 = nil;
    v44 = nil;
    v47 = nil;
    local v67 = {
        [1] = "ads/", 
        [2] = "cable/", 
        [3] = "carpet/", 
        [4] = "ceiling/", 
        [5] = "christmas/", 
        [6] = "composite/", 
        [7] = "console/", 
        [8] = "coop_cementplant", 
        [9] = "cstrike/", 
        [10] = "cubemaps/", 
        [11] = "de_cache/", 
        [12] = "de_shacks/", 
        [13] = "de_tides/", 
        [14] = "debug/", 
        [15] = "decals/", 
        [16] = "dev/", 
        [17] = "dust2_legacy/", 
        [18] = "editor/", 
        [19] = "effects/", 
        [20] = "engine/", 
        [21] = "environment maps/", 
        [22] = "halflife/", 
        [23] = "heatmap/", 
        [24] = "hlmv/", 
        [25] = "hud/", 
        [26] = "icons/", 
        [27] = "lights/", 
        [28] = "liquids/", 
        [29] = "lobby_mapveto/", 
        [30] = "models/", 
        [31] = "newde_cache/", 
        [32] = "overlays/", 
        [33] = "panorama/", 
        [34] = "particle/", 
        [35] = "props/", 
        [36] = "road_markings/", 
        [37] = "rubber/", 
        [38] = "sewage", 
        [39] = "signs/", 
        [40] = "sixense_controller_manager/", 
        [41] = "skybox/", 
        [42] = "sprites/", 
        [43] = "storefront_template", 
        [44] = "sun/", 
        [45] = "tarps/", 
        [46] = "tech/", 
        [47] = "tools/", 
        [48] = "training/", 
        [49] = "vehicle/", 
        [50] = "vgui/", 
        [51] = "voice/", 
        [52] = "graffiti", 
        [53] = "_normal", 
        [54] = "_nrm", 
        [55] = "ssbump"
    };
    v43 = v42("csgo\\pak01_dir.vpk").vtf;
    for v68 = #v43, 1, -1 do
        local v69 = l_gsub_0(v43[v68], "materials/", "");
        v43[v68] = v69;
        for _, v71 in l_ipairs_0(v67) do
            if l_find_0(v69, v71) ~= nil then
                l_remove_0(v43, v68);
                break;
            end;
        end;
    end;
    l_sort_0(v43);
    local v72 = {};
    v47 = {};
    v44 = v72;
    for v73 = 1, #v43 do
        local v74 = v43[v73];
        local v75 = l_sub_0(v74, 1, l_find_0(v74, "/") - 1);
        local v76 = v44[v75];
        if v76 == nil then
            v76 = {};
            v44[v75] = v76;
            v47[#v47 + 1] = v75;
        end;
        v76[#v76 + 1] = v74;
    end;
    v67 = l_typeof_0("        struct {\n            float x;\n            float y;\n            float z;\n        }\n    ");
    ffi.cdef("        void* VirtualProtect(void* address, unsigned long size, unsigned long new_protect, unsigned long* old_protect);\n\n        void* GetProcAddress(void*, const char*);\n        void* GetModuleHandleA(const char*);\n    ");
    local v77 = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)");
    v72 = nil;
    local v78 = nil;
    local v79 = nil;
    local v80 = nil;
    v72 = {
        [1] = "molotov_child_flame01b", 
        [2] = "molotov_child_flame02b", 
        [3] = "molotov_child_flame03b", 
        [4] = "molotov_child_glow01b", 
        [5] = "molotov_child_glow02b", 
        [6] = "burning_gib_01", 
        [7] = "env_fire_large", 
        [8] = "env_fire_large_smoke", 
        [9] = "env_fire_medium", 
        [10] = "env_fire_medium_smoke", 
        [11] = "env_fire_small", 
        [12] = "env_fire_small_coverage", 
        [13] = "env_fire_small_smoke", 
        [14] = "env_fire_tiny", 
        [15] = "env_fire_tiny_smoke", 
        [16] = "monastery_candle_flame", 
        [17] = "smoke_gib_01", 
        [18] = "copter_land_loop_1", 
        [19] = "copter_land_loop_1_dust_low", 
        [20] = "copter_takeoff_1", 
        [21] = "dust_devil", 
        [22] = "dust_embers", 
        [23] = "inferno_fountain_bot_rings", 
        [24] = "inferno_fountain_bot_ringsplashes", 
        [25] = "inferno_fountain_low_rings", 
        [26] = "inferno_fountain_low_ringsplashes", 
        [27] = "inferno_fountain_master", 
        [28] = "inferno_fountain_top_spout", 
        [29] = "light_gaslamp_glow", 
        [30] = "nuke_steam_rising", 
        [31] = "office_child_embers01a", 
        [32] = "office_child_flame01b", 
        [33] = "office_fire", 
        [34] = "shacks_exhaust", 
        [35] = "shacks_policelight_blue", 
        [36] = "shacks_policelight_blue_core", 
        [37] = "shacks_policelight_blue_fallback", 
        [38] = "shacks_policelight_red", 
        [39] = "shacks_policelight_red_core", 
        [40] = "shacks_steam_child_base", 
        [41] = "shacks_steam_short", 
        [42] = "shacks_steam_short_child_cloud", 
        [43] = "shacks_steam_short_child_mist"
    };
    v78 = {
        [1] = "remaper/light_glowirl.vmt", 
        [2] = "sprites/light_glow02.vmt", 
        [3] = "sprites/light_glow03.vmt", 
        [4] = "sprites/glow.vmt", 
        [5] = "sprites/glow01.vmt", 
        [6] = "sprites/glow03.vmt", 
        [7] = "sprites/glow04.vmt", 
        [8] = "sprites/glow04_noz.vmt", 
        [9] = "sprites/glow06.vmt", 
        [10] = "sprites/glow07.vmt", 
        [11] = "sprites/glow_test01.vmt", 
        [12] = "sprites/glow_test01b.vmt", 
        [13] = "sprites/glow_test02.vmt", 
        [14] = "sprites/glow_test02_nofog.vmt", 
        [15] = "sprites/halo.vmt", 
        [16] = "sprites/ledglow.vmt", 
        [17] = "sprites/nuke_sunflare_001.vmt", 
        [18] = "sprites/purplelaser1.vmt", 
        [19] = "sprites/bubble.vmt", 
        [20] = "sprites/glow01.spr"
    };
    v79 = {
        [1] = "models/remaper/lantern_bugs.mdl", 
        [2] = "models/remaper/polelightbugs.mdl", 
        [3] = "models/remaper/palacelightbugs.mdl", 
        [4] = "models/props/gg_tibet/candlestickwideshortonplate.mdl", 
        [5] = "models/props/de_vertigo/construction_safety_lamp.mdl", 
        [6] = "models/props/de_aztec/hr_aztec/aztec_lighting/aztec_lighting_lantern_01_unlit.mdl", 
        [7] = "models/props/de_aztec/hr_aztec/aztec_lighting/aztec_lighting_lantern_01_lit.mdl", 
        [8] = "models/props/de_aztec/hr_aztec/aztec_lighting/aztec_lighting_lantern_01_hanger.mdl", 
        [9] = "models/props/de_dust/hr_dust/dust_lights/dust_street_lantern_03_small.mdl", 
        [10] = "models/props/de_dust/hr_dust/dust_lights/dust_street_lantern_03.mdl", 
        [11] = "models/props/de_dust/hr_dust/dust_lights/dust_street_lantern_02_small.mdl", 
        [12] = "models/props/de_dust/hr_dust/dust_lights/dust_street_lantern_02.mdl", 
        [13] = "models/props/de_dust/hr_dust/dust_lights/dust_street_lantern_01_small.mdl", 
        [14] = "models/props/de_dust/hr_dust/dust_lights/dust_street_lantern_01.mdl", 
        [15] = "models/props/de_dust/hr_dust/dust_lights/dust_ornate_lantern_chain_48.mdl", 
        [16] = "models/props/de_dust/hr_dust/dust_lights/dust_ornate_lantern_chain_32.mdl", 
        [17] = "models/props/de_dust/hr_dust/dust_lights/dust_ornate_lantern_chain_16.mdl", 
        [18] = "models/props/de_dust/hr_dust/dust_lights/dust_ornate_lantern_chain_08.mdl", 
        [19] = "models/props/de_dust/hr_dust/dust_lights/dust_ornate_lantern_bracket_01.mdl", 
        [20] = "models/props/de_dust/hr_dust/dust_lights/dust_ornate_lantern_06.mdl", 
        [21] = "models/props/de_dust/hr_dust/dust_lights/dust_ornate_lantern_05.mdl", 
        [22] = "models/props/de_dust/hr_dust/dust_lights/dust_ornate_lantern_04.mdl", 
        [23] = "models/props/de_dust/hr_dust/dust_lights/dust_ornate_lantern_03.mdl", 
        [24] = "models/props/de_dust/hr_dust/dust_lights/dust_ornate_lantern_02.mdl", 
        [25] = "models/props/de_dust/hr_dust/dust_lights/dust_ornate_lantern_01.mdl", 
        [26] = "models/props/de_dust/hr_dust/dust_lights/dust_hanging_lantern_01_small.mdl", 
        [27] = "models/props/gg_vietnam/street_lanterns02.mdl", 
        [28] = "models/props/gg_vietnam/street_lanterns01.mdl", 
        [29] = "models/props/cs_italy/it_lantern2.mdl", 
        [30] = "models/props/cs_italy/it_lantern1_off.mdl", 
        [31] = "models/props/cs_italy/it_lantern1.mdl", 
        [32] = "models/props/coop_kashbah/floor_lamp/floor_lamp.mdl", 
        [33] = "models/props/coop_kashbah/sick_bed/surgical_lamp.mdl", 
        [34] = "models/props/hr_massive/survival_telephone_poles/telephone_pole_lamp.mdl", 
        [35] = "models/props/hr_massive/survival_lighting/survival_ceiling_lamp.mdl", 
        [36] = "models/props/de_inferno/hr_i/ornate_lamp/ornate_lamp.mdl", 
        [37] = "models/props_interiors/lamp_table02_gib2.mdl", 
        [38] = "models/props_interiors/lamp_table02_gib1.mdl", 
        [39] = "models/props_interiors/lamp_table02.mdl", 
        [40] = "models/props_interiors/lamp_floor_gib2.mdl", 
        [41] = "models/props_interiors/lamp_floor_gib1.mdl", 
        [42] = "models/props_interiors/lamp_floor.mdl", 
        [43] = "models/props_interiors/furniture_lamp01a_static.mdl", 
        [44] = "models/props_c17/lamppost03a_off.mdl", 
        [45] = "models/props/de_mirage/lamp_ver5.mdl", 
        [46] = "models/props/de_mirage/lamp_ver4.mdl", 
        [47] = "models/props/de_mirage/lamp_ver3.mdl", 
        [48] = "models/props/de_mirage/lamp_ver2.mdl", 
        [49] = "models/props/de_mirage/lamp_ver1.mdl", 
        [50] = "models/props/de_inferno/wall_lamp3.mdl", 
        [51] = "models/props/de_inferno/wall_lamp2.mdl", 
        [52] = "models/props/de_inferno/wall_lamp.mdl", 
        [53] = "models/props/de_cbble/lamp_a/lamp_a.mdl", 
        [54] = "models/props/cs_italy/it_streetlampleg.mdl", 
        [55] = "models/props/cs_italy/it_lampholder2.mdl", 
        [56] = "models/props/cs_italy/it_lampholder1.mdl", 
        [57] = "models/props_urban/telephone_streetlight001.mdl", 
        [58] = "models/props_urban/streetlight001.mdl", 
        [59] = "models/props_urban/porch_light003.mdl", 
        [60] = "models/props_urban/porch_light002_02.mdl", 
        [61] = "models/props_urban/porch_light001.mdl", 
        [62] = "models/props/de_inferno/ceiling_light.mdl", 
        [63] = "models/props_equipment/light_floodlight.mdl"
    };
    v80 = {
        [1] = "sprites/glow_test01.vmt", 
        [2] = "sprites/glow_test01b.vmt", 
        [3] = "sprites/glow_test02.vmt", 
        [4] = "sprites/glow_test02_nofog.vmt"
    };
    local v81 = nil;
    v81 = {};
    ui.sidebar("\a{Link Active}World Editor", "\239\158\162");
    v81.is_editing = false;
    v81.is_point_custom_position = false;
    local v82 = false;
    local v83 = ui.create("Main", "\n Map Name", 1);
    local v84 = ui.create("Main", "Presets", 1);
    local v85 = ui.create("Main", "Point: Position", 2);
    local v86 = ui.create("Main", "Point: Settings", 2);
    local v87 = ui.create("Main", "Ambient per map", 2);
    local v88 = ui.create("Main", "Weather per map", 2);
    v81.current_map_name = v83:label("Settings for: ");
    v81.presets = v84:list("\n Presets", "+ Create New");
    v81.enabled = v84:switch("Enabled");
    v81.name = v84:input("\n Name");
    v81.create = v84:button("Create");
    v81.edit = v84:button("Edit");
    v81.delete = v84:button("Delete");
    v81.points_list = v84:list("Points", "+ Create New");
    v81.back = v84:button("Back");
    do
        local l_v85_0, l_v86_0, l_v87_0, l_v88_0 = v85, v86, v87, v88;
        v81.presets:set_callback(function(v93)
            -- upvalues: v81 (ref), l_v85_0 (ref), l_v86_0 (ref)
            local v94 = v93:get();
            local v95 = #v93:list();
            local v96 = v94 == 1;
            local v97 = v94 == v95;
            local v98 = not v97;
            v81.name:visibility(v97 and not v96);
            v81.create:visibility(v97 and not v96);
            v81.enabled:visibility(not v97);
            v81.edit:visibility(v98 and not v96);
            v81.back:visibility(false);
            v81.delete:visibility(v98 and not v96);
            v81.points_list:visibility(false);
            l_v85_0:visibility(false);
            l_v86_0:visibility(false);
            local l_point_delete_0 = v81.point_delete;
            if l_point_delete_0 ~= nil then
                l_point_delete_0:visibility(false);
            end;
        end, true);
        v81.edit:set_callback(function(_)
            -- upvalues: v81 (ref), l_v85_0 (ref), l_v86_0 (ref), l_v87_0 (ref), l_v88_0 (ref)
            v81.is_editing = true;
            v81.presets:visibility(false);
            v81.enabled:visibility(false);
            v81.name:visibility(false);
            v81.create:visibility(false);
            v81.edit:visibility(false);
            v81.delete:visibility(false);
            v81.back:visibility(true);
            v81.points_list:visibility(true);
            l_v85_0:visibility(true);
            l_v86_0:visibility(false);
            local l_point_delete_1 = v81.point_delete;
            if l_point_delete_1 ~= nil then
                l_point_delete_1:visibility(false);
            end;
            l_v87_0:visibility(false);
            l_v88_0:visibility(false);
        end);
        v81.back:set_callback(function(_)
            -- upvalues: v81 (ref), l_v87_0 (ref), l_v88_0 (ref)
            v81.is_editing = false;
            v81.presets:visibility(true);
            v81.presets:set(1);
            v81.points_list:visibility(false);
            l_v87_0:visibility(true);
            l_v88_0:visibility(true);
        end);
        v81.points_list:set_callback(function(v103)
            -- upvalues: v81 (ref), l_v85_0 (ref), l_v86_0 (ref)
            local v104 = v103:get() == #v103:list();
            local l_is_editing_0 = v81.is_editing;
            l_v85_0:visibility(v104 and l_is_editing_0);
            l_v86_0:visibility(not v104 and l_is_editing_0);
            local l_point_delete_2 = v81.point_delete;
            if l_point_delete_2 ~= nil then
                l_point_delete_2:visibility(not v104);
            end;
        end);
        v81.point_delete = v84:button("Delete \n Point");
        v81.static_props = l_v85_0:list("Static Props (Sorted by Crosshair)", "");
        v81.set_position = l_v85_0:button("Set");
        v81.set_position:set_callback(function()
            -- upvalues: l_v85_0 (ref), l_v86_0 (ref)
            l_v85_0:visibility(false);
            l_v86_0:visibility(true);
        end);
        v81.position_label = l_v86_0:label("Position");
        v81.point_name = l_v86_0:input("Name");
        v81.point_position_x = l_v86_0:slider("Position X", -20000, 20000, 0, 1);
        v81.point_position_y = l_v86_0:slider("Position Y", -20000, 20000, 0, 1);
        v81.point_position_z = l_v86_0:slider("Position Z", -20000, 20000, 0, 1);
        v81.point_type = l_v86_0:combo("Type", "Particle", "Model", "Sprite", "Beam");
        v81.point_model = l_v86_0:combo("\n Model", "");
        v81.point_angles_offset = l_v86_0:slider("Angles Offset", -300, 300, 0, 1, function(v107)
            if v107 == 0 then
                return "Off";
            else
                return v107;
            end;
        end);
        v81.point_custom_yaw_offset = v81.point_angles_offset:create():slider("Custom Yaw Offset", -180, 180, 0, 1, function(v108)
            if v108 == 0 then
                return "Off";
            else
                return v108;
            end;
        end);
        v81.point_position_z_offset = l_v86_0:slider("Position Z Offset", -300, 300, 0, 1, function(v109)
            if v109 == 0 then
                return "Off";
            else
                return v109;
            end;
        end);
        v81.point_end_position_offset = l_v86_0:slider("End Position Offset", -300, 300, 0, 1, function(v110)
            if v110 == 0 then
                return "Off";
            else
                return v110;
            end;
        end);
        v81.point_start_width = l_v86_0:slider("Start Width", 1, 150, 20);
        v81.point_end_width = l_v86_0:slider("End Width", 1, 150, 20);
        v81.point_scale = l_v86_0:slider("Scale", 10, 500, 100, 0.01);
        v81.point_set_angles = l_v86_0:switch("Set Angles");
        local v111 = v81.point_set_angles:create();
        v81.point_set_angles_x_offset = v111:slider("Angles X Offset", -180, 180, 0);
        v81.point_set_angles_y_offset = v111:slider("Angles Y Offset", -180, 180, 0);
        v81.point_set_angles_z_offset = v111:slider("Angles Z Offset", -180, 180, 0);
        v81.point_hdr_color_scale = l_v86_0:slider("HDR Color Scale", 1, 30, 10, 0.1);
        v81.point_color = l_v86_0:color_picker("Color");
        v81.point_render_mode = l_v86_0:combo("Render Mode", "Normal", "Transparent Color Blend", "Transparent Texture Blend", "Glow Ignore Z", "Alpha Based Transparency", "Additive Glow", "Additive With Frame Blending", "Alpha Additive", "World Glow");
        v81.point_save = l_v86_0:button("Save");
        local v112 = {
            Particle = v72, 
            Model = v79, 
            Sprite = v78, 
            Beam = v80
        };
        do
            local l_v112_0 = v112;
            v81.point_type:set_callback(function(v114)
                -- upvalues: l_v112_0 (ref), l_ipairs_0 (ref), v81 (ref)
                local v115 = v114:get();
                local v116 = l_v112_0[v115];
                local v117 = {};
                for _, v119 in l_ipairs_0(v116) do
                    v117[#v117 + 1] = v119;
                end;
                v81.point_model:update(v117);
                local l_is_point_custom_position_0 = v81.is_point_custom_position;
                local v121 = v115 == "Particle";
                local v122 = v115 == "Model";
                local v123 = v115 == "Sprite";
                local v124 = v115 == "Beam";
                v81.point_angles_offset:visibility(not l_is_point_custom_position_0);
                v81.point_set_angles:visibility(v122);
                v81.point_scale:visibility(not v121 and not v124);
                v81.point_color:visibility(not v121);
                v81.point_hdr_color_scale:visibility(v123);
                v81.point_render_mode:visibility(v123);
                v81.point_end_position_offset:visibility(v124);
                v81.point_start_width:visibility(v124);
                v81.point_end_width:visibility(v124);
                v81.point_position_z_offset:visibility(not l_is_point_custom_position_0);
                v81.point_position_x:visibility(l_is_point_custom_position_0);
                v81.point_position_y:visibility(l_is_point_custom_position_0);
                v81.point_position_z:visibility(l_is_point_custom_position_0);
            end, true);
        end;
        v81.override_night_mode = l_v87_0:switch("Night Mode");
        v81.override_night_mode_color = v81.override_night_mode:color_picker();
        v81.override_static_props = l_v87_0:switch("Static Props");
        v81.override_static_props_color = v81.override_static_props:color_picker();
        v81.override_post_processing = l_v87_0:switch("Post Processing");
        v81.override_post_processing_color = v81.override_post_processing:color_picker();
        v81.override_fog_changer = l_v87_0:combo("Fog Changer", "Off", "Clean", "Override");
        local v125 = v81.override_fog_changer:create();
        v81.override_fog_changer_color = v125:color_picker("Color");
        v81.override_fog_changer_start = v125:slider("Start", -50, 150, 0, 1);
        v81.override_fog_changer_distance = v125:slider("Distance", -50, 150, 0, 1);
        v81.override_illumination = l_v87_0:combo("Illumination", "Off", "Bright", "Sunlight");
        v125 = v81.override_illumination:create();
        v81.override_illumination_pitch = v125:slider("Pitch", 0, 89, 0, 1);
        v81.override_illumination_yaw = v125:slider("Yaw", -179, 179, 0, 1);
        v81.override_illumination_distance = v125:slider("Distance", 50, 1500, 50, 1);
        v81.override_illumination_enabled_color = v125:switch("Color");
        v81.override_illumination_color = v81.override_illumination_enabled_color:color_picker();
        v81.weather_enabled = l_v88_0:switch("Enabled");
        v125 = v81.weather_enabled:create();
        v81.weather_type = v125:combo("Type", "Rain", "Rain 2", "Particle Rain", "Particle Ash", "Particle Snow");
        v81.weather_radius = v125:slider("Radius", 0, 1500, 1000);
        v81.weather_width = v125:slider("Width", 0, 100, 50, 0.01);
        v81.weather_density = v125:slider("Density", 10, 200, 65, 0.01);
        v125 = nil;
        v125 = {
            is_editing = false
        };
        v111 = ui.create("Textures", "Presets", 1);
        v112 = ui.create("Textures", "Preset Editing", 1);
        local v126 = ui.create("Textures", "Texture", 2);
        local v127 = ui.create("Textures", "Textures", 2);
        v125.presets = v111:list("\n Presets", "+ Create New");
        v125.preset_enabled = v111:switch("Enabled");
        v125.preset_edit = v111:button("Edit");
        v125.preset_delete = v111:button("Delete");
        v125.preset_name = v111:input("\n Name");
        v125.preset_create = v111:button("Create");
        v125.is_editing_create_new = false;
        v125.preset_editing_list = v112:list("\n Preset Editing List", "+ Create New");
        v125.preset_editing_delete = v112:button("Delete \n");
        v125.back = v112:button("Back");
        do
            local l_v111_0, l_v112_1, l_v126_0, l_v127_0 = v111, v112, v126, v127;
            v125.preset_editing_list:set_callback(function(v132)
                -- upvalues: v125 (ref), l_v127_0 (ref)
                local v133 = v132:get() == #v132:list();
                v125.is_editing_create_new = v133;
                v125.preset_editing_delete:visibility(not v133);
                local l_selected_material_0 = v125.selected_material;
                if l_selected_material_0 ~= nil then
                    v125.material_by_crosshair:visibility(v133);
                    v125.select_material_by_crosshair:visibility(v133);
                    l_selected_material_0:visibility(not v133);
                    v125.is_material_selected = not v133;
                    v125.color:visibility(not v133);
                    v125.selected_texture:visibility(not v133);
                    v125.selected_texture:name("Selected Texture: None");
                    v125.select_texture:visibility(not v133);
                    v125.texture_save:visibility(not v133);
                    v125.texture_teleport:visibility(not v133);
                end;
                l_v127_0:visibility(false);
            end, true);
            v125.is_material_selected = false;
            v125.material_by_crosshair = l_v126_0:label("Material By Crosshair: ");
            v125.select_material_by_crosshair = l_v126_0:button("Select Material");
            v125.selected_material = l_v126_0:label("Selected Material: ");
            v125.selected_texture = l_v126_0:label("Selected Texture: None");
            v125.select_texture = l_v126_0:button("Select");
            v125.color = l_v126_0:color_picker("Color");
            v125.texture_teleport = l_v126_0:button("Teleport");
            v125.texture_save = l_v126_0:button("Save \n");
            v125.select_material_by_crosshair:set_callback(function()
                -- upvalues: v125 (ref)
                v125.is_material_selected = true;
                v125.material_by_crosshair:visibility(false);
                v125.select_material_by_crosshair:visibility(false);
                v125.selected_material:visibility(true);
                v125.color:visibility(true);
                v125.selected_texture:visibility(true);
                v125.selected_texture:name("Selected Texture: None");
                v125.select_texture:visibility(true);
                v125.texture_save:visibility(true);
                v125.texture_teleport:visibility(false);
            end);
            v125.select_texture:set_callback(function()
                -- upvalues: l_v126_0 (ref), l_v127_0 (ref)
                l_v126_0:visibility(false);
                l_v127_0:visibility(true);
            end);
            v125.textures_group = l_v127_0:combo("\n Groups", v47);
            local v135 = nil;
            v135 = {};
            for _, v137 in l_ipairs_0(v47) do
                local v138 = v44[v137];
                local v139 = {};
                for _, v141 in l_ipairs_0(v138) do
                    v141 = l_gsub_0(l_gsub_0(v141, v137 .. "/", ""), ".vtf", "");
                    v139[#v139 + 1] = v141;
                end;
                v135[v137] = l_v127_0:list("\n Textures " .. v137, v139);
            end;
            do
                local l_v135_0 = v135;
                v125.textures_group:set_callback(function(v143)
                    -- upvalues: l_pairs_0 (ref), l_v135_0 (ref)
                    local v144 = v143:get();
                    for v145, v146 in l_pairs_0(l_v135_0) do
                        v146:visibility(v144 == v145);
                    end;
                end, true);
                v125.textures_group_lists = l_v135_0;
                v125.texture_select = l_v127_0:button("Select Texture");
                v125.texture_select:set_callback(function()
                    -- upvalues: l_v126_0 (ref), l_v127_0 (ref)
                    l_v126_0:visibility(true);
                    l_v127_0:visibility(false);
                end);
            end;
            v125.presets:set_callback(function(v147)
                -- upvalues: v125 (ref)
                local v148 = v147:get();
                local v149 = #v147:list();
                local v150 = v148 == 1;
                local v151 = v148 == v149;
                local v152 = not v151;
                v125.preset_enabled:visibility(not v151);
                v125.preset_edit:visibility(v152 and not v150);
                v125.preset_delete:visibility(v152 and not v150);
                v125.preset_name:visibility(v151 and not v150);
                v125.preset_create:visibility(v151 and not v150);
            end, true);
            v125.preset_edit:set_callback(function()
                -- upvalues: v125 (ref), l_v111_0 (ref), l_v112_1 (ref), l_v126_0 (ref)
                v125.is_editing = true;
                l_v111_0:visibility(false);
                l_v112_1:visibility(true);
                l_v126_0:visibility(true);
                v125.is_editing_create_new = false;
                v125.selected_material:visibility(false);
                v125.material_by_crosshair:visibility(true);
                v125.select_material_by_crosshair:visibility(true);
                v125.is_material_selected = false;
                v125.color:visibility(false);
                v125.selected_texture:visibility(false);
                v125.selected_texture:name("Selected Texture: None");
                v125.select_texture:visibility(false);
                v125.texture_save:visibility(false);
            end);
            v125.back:set_callback(function()
                -- upvalues: v125 (ref), l_v111_0 (ref), l_v112_1 (ref), l_v126_0 (ref), l_v127_0 (ref)
                v125.is_editing = false;
                l_v111_0:visibility(true);
                l_v112_1:visibility(false);
                l_v126_0:visibility(false);
                l_v127_0:visibility(false);
                v125.is_editing_create_new = false;
                v125.selected_material:visibility(false);
                v125.material_by_crosshair:visibility(true);
                v125.select_material_by_crosshair:visibility(true);
                v125.is_material_selected = false;
                v125.color:visibility(false);
                v125.selected_texture:visibility(false);
                v125.selected_texture:name("Selected Texture: None");
                v125.select_texture:visibility(false);
                v125.texture_save:visibility(false);
            end, true);
            v81.textures = v125;
        end;
        l_execute_after_0(0.05, v81.presets.set, v81.presets, 1);
    end;
    v82 = nil;
    v82 = function(v153, v154)
        -- upvalues: l_new_0 (ref), l_C_0 (ref), l_cast_0 (ref)
        local v155 = l_new_0("unsigned long[1]");
        l_C_0.VirtualProtect(l_cast_0("void*", v153), 1, 64, v155);
        l_cast_0("uint8_t*", v153)[0] = v154;
        l_C_0.VirtualProtect(l_cast_0("void*", v153), 1, v155[0], v155);
    end;
    v83 = nil;
    v84 = utils.opcode_scan("client.dll", "55 8B EC 83 E4 F8 83 EC 30 C6");
    v85 = l_cast_0("void(__thiscall*)(void*)", v84);
    v86 = {};
    do
        local l_v86_1 = v86;
        v83 = function(v157)
            -- upvalues: l_v86_1 (ref)
            l_v86_1[#l_v86_1 + 1] = v157;
        end;
        l_memory_0.hook_func(v85, function(v158, v159)
            -- upvalues: l_v86_1 (ref)
            for v160 = 1, #l_v86_1 do
                l_v86_1[v160]();
            end;
            v158:get_original(v159);
        end);
    end;
    v84 = nil;
    v85 = nil;
    v86 = l_typeof_0("            struct {\n                $ m_vOrigin;\n                $ m_vStart;\n                $ m_vNormal;\n                $ m_vAngles;\n\n                int m_fFlags;\n                void* m_hEntity;\n                void* pad_0x34;\n\n                float m_flScale;\n                float m_flMagnitude;\n                float m_flRadius;\n\n                int m_nAttachmentIndex;\n                int m_nSurfaceProp;\n                int m_nMaterial;\n                int m_nDamageType;\n                int m_nHitBox;\n                int m_nOtherEntIndex;\n                int m_nColor;\n                bool m_bPositionsAreRelativeToEntity;\n                char pad2[3];\n                int m_iEffectName;\n            }\n        ", v67, v67, v67, v67);
    v87 = utils.opcode_scan("client.dll", "55 8B EC 83 EC 18 A1 ?? ?? ?? ?? 89 55");
    v88 = l_cast_0(l_typeof_0("int(__fastcall*)(const char*, $&)", v86), v87);
    local v161 = utils.opcode_scan("client.dll", "56 8B F1 85 F6 74 22");
    local v162 = l_cast_0("int (__thiscall*)(const char*)", v161);
    local v163 = utils.opcode_scan("client.dll", "56 57 8B F9 8B 0D ?? ?? ?? ?? 6A 00 6A FF");
    local v164 = l_cast_0("int (__thiscall*)(const char*)", v163);
    local v165 = utils.opcode_scan("client.dll", "7E 42 8B 57 08");
    local v166 = utils.opcode_scan("client.dll", "7E 42 5F 5E 5D");
    local v167 = {};
    do
        local l_v86_2, l_v88_1, l_v162_0, l_v164_0, l_v165_0, l_v166_0, l_v167_0 = v86, v88, v162, v164, v165, v166, v167;
        v84 = function(v175, v176)
            -- upvalues: l_v162_0 (ref), l_v164_0 (ref), l_v167_0 (ref), l_v86_2 (ref), v67 (ref), l_cast_0 (ref), v77 (ref), l_v88_1 (ref)
            local v177 = l_v162_0(v175);
            if v177 == 0 then
                v177 = l_v164_0(v175);
            end;
            if v177 == 0 then
                return print("failed to create: " .. v175);
            else
                l_v167_0[v177] = true;
                local v178 = l_v86_2();
                v178.m_vOrigin = v67(v176.x, v176.y, v176.z);
                local v179 = l_cast_0("uintptr_t", v77(0));
                local v180 = l_cast_0("uintptr_t*", v179 + 652)[0];
                v178.m_hEntity = l_cast_0("void*", v180);
                v178.m_nHitBox = v177;
                l_v88_1("ParticleEffect", v178);
                return;
            end;
        end;
        local function v185()
            -- upvalues: l_cast_0 (ref), v77 (ref), l_pairs_0 (ref), l_v167_0 (ref), v82 (ref), l_v165_0 (ref), l_v166_0 (ref), l_v86_2 (ref), l_v88_1 (ref)
            local v181 = l_cast_0("uintptr_t", v77(0));
            if v181 == 0 then
                return;
            else
                local v182 = l_cast_0("uintptr_t*", v181 + 652)[0];
                for v183 in l_pairs_0(l_v167_0) do
                    if v183 < 0 then
                        v82(l_v165_0, 127);
                        v82(l_v166_0, 127);
                    end;
                    local v184 = l_v86_2();
                    v184.m_hEntity = l_cast_0("void*", v182);
                    v184.m_nHitBox = v183;
                    l_v88_1("ParticleEffectStop", v184);
                    if v183 < 0 then
                        v82(l_v165_0, 126);
                        v82(l_v166_0, 126);
                    end;
                end;
                l_v167_0 = {};
                return;
            end;
        end;
        v85 = v185;
        events.shutdown(v185);
    end;
    v86 = nil;
    v87 = nil;
    v88 = nil;
    v161 = nil;
    v162 = l_cast_0("void*", 0);
    v163 = l_typeof_0("            struct {\n                int type;\n                void* start_entity;\n                int start_attachment;\n                void* end_entity;\n                int end_attachment;\n                $ start_position;\n                $ end_position;\n                int model_index;\n                const char* model_name;\n                int halo_index;\n                const char* halo_name;\n                float halo_scale;\n                float life;\n                float start_width;\n                float end_width;\n                float fade_length;\n                float amplitude;\n                float brightness;\n                float speed;\n                int start_frame;\n                float frame_rate;\n                float red;\n                float green;\n                float blue;\n                bool renderable;\n                int segments;\n                int flags;\n\n                $ center_position;\n                float start_radius;\n                float end_radius;\n            }\n        ", v67, v67, v67);
    v164 = utils.opcode_scan("client.dll", "A1 ?? ?? ?? ?? 56 57 8B F9 8B 08 8D");
    v165 = l_cast_0("void*(__fastcall*)(size_t)", v164);
    v166 = utils.opcode_scan("client.dll", "55 8B EC 83 EC 0C 53 56 57 8B F1 E8 ?? ?? ?? ?? C7");
    v167 = l_cast_0("void*(__fastcall*)(void*)", v166);
    local v186 = utils.opcode_scan("client.dll", "55 8B EC 8B 55 08 56 57 8B F9 85 D2 74 1B");
    local v187 = l_cast_0("bool(__thiscall*)(void*, const char*, bool)", v186);
    local v188 = utils.opcode_scan("client.dll", "55 8B EC 83 E4 F8 51 53 56 57 8B F1 E8 ?? ?? ?? ?? 8B 7D");
    local v189 = l_cast_0(l_typeof_0("void(__thiscall*)(void*, $*)", v67), v188);
    local v190 = utils.opcode_scan("client.dll", "55 8B EC 83 E4 F8 83 EC 64 53 56 57 8B F1");
    local v191 = l_cast_0(l_typeof_0("void(__thiscall*)(void*, $*)", v67), v190);
    local v192 = utils.opcode_scan("client.dll", "56 8B F1 6A 3C");
    v192 = l_cast_0("uintptr_t", v192) - 32;
    local v193 = l_cast_0("void(__thiscall*)(void*)", v192);
    local v194 = 10640;
    local v195 = utils.opcode_scan("client.dll", "55 8B EC 83 EC 08 56 8B F1 E8 ?? ?? ?? ?? C7 86");
    local v196 = l_cast_0("void*(__fastcall*)(void*)", v195);
    local v197 = utils.opcode_scan("client.dll", "55 8B EC 83 E4 F8 83 EC 08 BA");
    local v198 = l_cast_0("bool(__thiscall*)(void*, const char*, const char*)", v197);
    local v199 = utils.opcode_scan("client.dll", "55 8B EC 83 EC 1C 56 8B F1 6A");
    local v200 = l_cast_0("bool(__thiscall*)(void*)", v199);
    local v201 = utils.opcode_scan("client.dll", "83 3D ?? ?? ?? ?? ?? 7E 20 0F 1F 80 00 00 00 00 A1 ?? ?? ?? ?? 8B 08 8B 41 08 83 C1 08 FF 50 ?? 83 3D ?? ?? ?? ?? ?? 7F E7 C3");
    local v202 = l_cast_0("void (__fastcall*)()", v201);
    local v203 = 2643;
    local v204 = utils.opcode_scan("client.dll", "A1 ?? ?? ?? ?? FF 50 ?? 5F 5E 33 C0");
    v204 = l_cast_0("uintptr_t", v204) + 1;
    v204 = l_cast_0("uintptr_t*", v204)[0];
    v204 = l_cast_0("void*", v204);
    local v205 = utils.opcode_scan("client.dll", "55 8B EC 83 E4 F8 83 EC 28 89");
    local v206 = l_cast_0("void (__thiscall*)(void*, void*)", v205);
    local v207 = utils.opcode_scan("client.dll", "55 8B EC 56 8B 75 08 0F 57 C9 57 8B F9 F3 0F 10 46 40 0F 2E C1 9F F6 C4 44 7B 17");
    local v208 = l_cast_0(l_typeof_0("void*(__thiscall*)(void*, $*)", v163), v207);
    local v209 = utils.opcode_scan("client.dll", "55 8B EC 56 8B 75 08 57 8B F9 8D 86");
    local _ = l_cast_0("void (__thiscall*)(void*, void*)", v209);
    local v211 = utils.get_vfunc("engine.dll", "VModelInfoClient004", 2, "int(__thiscall*)(void*, const char*)");
    local v212 = utils.get_vfunc("engine.dll", "VModelInfoClient004", 39, "void*(__thiscall*)(void*, const char*)");
    local v213 = utils.get_vfunc("engine.dll", "VEngineClientStringTable001", 3, "void*(__thiscall*)(void*, const char*)");
    do
        local l_v162_1, l_v163_0, l_v165_1, l_v167_1, l_v187_0, l_v189_0, l_v191_0, l_v193_0, l_v194_0, l_v196_0, l_v198_0, l_v200_0, l_v202_0, l_v203_0, l_v204_0, l_v206_0, l_v208_0, l_v211_0, l_v212_0, l_v213_0 = v162, v163, v165, v167, v187, v189, v191, v193, v194, v196, v198, v200, v202, v203, v204, v206, v208, v211, v212, v213;
        local function v237(v234)
            -- upvalues: l_v213_0 (ref), l_cast_0 (ref), l_v212_0 (ref)
            local v235 = l_v213_0("modelprecache");
            if v235 == nil then
                return false;
            else
                local v236 = l_cast_0("void***", v235);
                if v236 == nil then
                    return false;
                else
                    l_v212_0(v234);
                    if l_cast_0("int(__thiscall*)(void*, bool, const char*, int, const void*)", v236[0][8])(v236, false, v234, -1, nil) > 0 then
                        return true;
                    else
                        return false;
                    end;
                end;
            end;
        end;
        local function v240(v238)
            -- upvalues: l_cast_0 (ref), l_v193_0 (ref)
            local v239 = l_cast_0("uintptr_t", v238) + 8;
            v238 = l_cast_0("void*", v239);
            l_v193_0(v238);
        end;
        local v241 = {};
        v86 = function(v242)
            -- upvalues: l_v211_0 (ref), v237 (ref), l_format_0 (ref), l_v165_1 (ref), l_v194_0 (ref), l_v167_1 (ref), l_v187_0 (ref), v240 (ref), v67 (ref), l_v189_0 (ref), l_v191_0 (ref), v241 (ref), l_cast_0 (ref), l_tonumber_0 (ref)
            local l_model_name_0 = v242.model_name;
            if l_v211_0(l_model_name_0) == -1 and not v237(l_model_name_0) then
                return print(l_format_0("[Draw Model] Failed to precache: %s", l_model_name_0));
            else
                local v244 = l_v165_1(l_v194_0);
                local v245 = l_v167_1(v244);
                if not l_v187_0(v245, l_model_name_0, false) then
                    print(l_format_0("[Draw Model] Failed to initialize: %s", l_model_name_0));
                    return v240(v245);
                else
                    local l_position_0 = v242.position;
                    if l_position_0 ~= nil then
                        l_position_0 = v67(l_position_0.x, l_position_0.y, l_position_0.z);
                        l_v189_0(v245, l_position_0);
                    end;
                    local l_abs_angles_0 = v242.abs_angles;
                    if l_abs_angles_0 ~= nil then
                        l_abs_angles_0 = v67(l_abs_angles_0.x, l_abs_angles_0.y, l_abs_angles_0.z);
                        l_v191_0(v245, l_abs_angles_0);
                    end;
                    v241[#v241 + 1] = v245;
                    local l_color_0 = v242.color;
                    if l_color_0 ~= nil then
                        l_cast_0("char*", l_cast_0("uintptr_t", v245) + 112)[0] = l_color_0[1];
                        l_cast_0("char*", l_cast_0("uintptr_t", v245) + 112 + 1)[0] = l_color_0[2];
                        l_cast_0("char*", l_cast_0("uintptr_t", v245) + 112 + 2)[0] = l_color_0[3];
                    end;
                    local l_model_scale_0 = v242.model_scale;
                    if l_model_scale_0 ~= nil then
                        l_cast_0("float*", l_cast_0("uintptr_t", v245) + 10060)[0] = l_model_scale_0;
                    end;
                    if _DEBUG then
                        print(l_format_0("[Draw Model] created entity: 0x%X", l_tonumber_0(l_cast_0("uintptr_t", v245))));
                    end;
                    return;
                end;
            end;
        end;
        local v250 = 1.75 * 0.01;
        local v251 = 0;
        local v252 = 2580;
        events.render(function()
            -- upvalues: v251 (ref), v250 (ref), v241 (ref), l_cast_0 (ref), v252 (ref)
            v251 = v251 + globals.frametime * v250;
            for v253 = 1, #v241 do
                local v254 = v241[v253];
                v254 = l_cast_0("uintptr_t", v254);
                l_cast_0("float*", v254 + v252)[0] = v251;
            end;
        end);
        v87 = function(v255)
            -- upvalues: l_v211_0 (ref), v237 (ref), l_format_0 (ref), l_v165_1 (ref), l_v203_0 (ref), l_v196_0 (ref), l_pairs_0 (ref), l_v198_0 (ref), l_tostring_0 (ref), l_v200_0 (ref), l_tonumber_0 (ref), l_cast_0 (ref), v240 (ref)
            local l_model_0 = v255.model;
            if l_v211_0(l_model_0) == -1 and not v237(l_model_0) then
                return print(l_format_0("Failed to precache: %s", l_model_0));
            else
                local v257 = l_v165_1(l_v203_0);
                local v258 = l_v196_0(v257);
                for v259, v260 in l_pairs_0(v255) do
                    if v259 ~= "position" then
                        l_v198_0(v258, v259, l_tostring_0(v260));
                    end;
                end;
                local l_position_1 = v255.position;
                l_v198_0(v258, "origin", l_format_0("%s %s %s", l_position_1.x, l_position_1.y, l_position_1.z));
                if l_v200_0(v258) then
                    if _DEBUG then
                        print(l_format_0("[Sprite] created entity: 0x%X", l_tonumber_0(l_cast_0("uintptr_t", v258))));
                    end;
                    return;
                else
                    print(l_format_0("[Sprite] Failed to initialize: %s", l_model_0));
                    v240(v258);
                    return;
                end;
            end;
        end;
        local v262 = {};
        v88 = function(v263)
            -- upvalues: l_v211_0 (ref), v237 (ref), l_format_0 (ref), l_new_0 (ref), l_v163_0 (ref), l_pairs_0 (ref), v67 (ref), l_v208_0 (ref), l_v204_0 (ref), l_v162_1 (ref), l_v206_0 (ref), v262 (ref), l_tonumber_0 (ref), l_cast_0 (ref)
            local l_model_name_1 = v263.model_name;
            if l_v211_0(l_model_name_1) == -1 and not v237(l_model_name_1) then
                return print(l_format_0("[Beam] Failed to precache: %s", l_model_name_1));
            else
                local v265 = l_new_0(l_v163_0);
                for v266, v267 in l_pairs_0(v263) do
                    if v266 == "start_position" or v266 == "end_position" then
                        v267 = v67(v267.x, v267.y, v267.z);
                    end;
                    v265[v266] = v267;
                end;
                v265.renderable = true;
                local v268 = l_v208_0(l_v204_0, v265);
                if v268 == l_v162_1 then
                    return print(l_format_0("[Beam] Failed to create: %s", l_model_name_1));
                else
                    l_v206_0(l_v204_0, v268);
                    v262[#v262 + 1] = v268;
                    if _DEBUG then
                        print(l_format_0("[Beam] created: 0x%X", l_tonumber_0(l_cast_0("uintptr_t", v268))));
                    end;
                    return;
                end;
            end;
        end;
        events.level_init(function()
            -- upvalues: v241 (ref), v262 (ref)
            v241 = {};
            v262 = {};
        end);
        v83(function()
            -- upvalues: v241 (ref), v262 (ref)
            v241 = {};
            v262 = {};
        end);
        local function v273()
            -- upvalues: v241 (ref), v240 (ref), l_v202_0 (ref), v262 (ref), l_cast_0 (ref)
            for v269 = #v241, 1, -1 do
                local v270 = v241[v269];
                v240(v270);
            end;
            v241 = {};
            l_v202_0();
            for v271 = 1, #v262 do
                local v272 = v262[v271];
                l_cast_0("float*", l_cast_0("uintptr_t", v272) + 52)[0] = 0;
                l_cast_0("float*", l_cast_0("uintptr_t", v272) + 200)[0] = 0;
            end;
            v262 = {};
        end;
        v161 = v273;
        events.shutdown(v273);
    end;
    v162 = nil;
    v162 = function(v274)
        -- upvalues: l_type_0 (ref), l_next_0 (ref), v162 (ref), l_setmetatable_0 (ref), l_getmetatable_0 (ref)
        local v275, v276 = l_type_0(v274);
        if v275 == "table" then
            v276 = {};
            for v277, v278 in l_next_0, v274 do
                v276[v162(v277)] = v162(v278);
            end;
            l_setmetatable_0(v276, v162(l_getmetatable_0(v274)));
        else
            v276 = v274;
        end;
        return v276;
    end;
    v163 = nil;
    v163 = {};
    v164 = utils.opcode_scan("engine.dll", "A1 ?? ?? ?? ?? B9 ?? ?? ?? ?? 56 8B 40 30");
    v164 = l_cast_0("uintptr_t", v164) + 1;
    do
        local l_v164_1 = v164;
        parse_static_props = function()
            -- upvalues: v163 (ref), l_cast_0 (ref), l_v164_1 (ref), l_string_0 (ref)
            v163 = {};
            if not globals.is_in_game then
                return;
            else
                local v280 = l_cast_0("uintptr_t*", l_v164_1)[0];
                local v281 = l_cast_0("uintptr_t*", v280 + 32)[0];
                local v282 = l_cast_0("int*", v280 + 36)[0];
                local v283 = 256;
                for v284 = 0, v282 - 1 do
                    local v285 = l_cast_0("uintptr_t", v281 + v283 * v284);
                    local v286 = l_cast_0("float*", v285 + 16)[0];
                    local v287 = l_cast_0("float*", v285 + 16 + 4)[0];
                    local v288 = l_cast_0("float*", v285 + 16 + 8)[0];
                    local v289 = l_cast_0("float*", v285 + 28)[0];
                    local v290 = l_cast_0("float*", v285 + 28 + 4)[0];
                    local v291 = l_cast_0("float*", v285 + 28 + 8)[0];
                    local v292 = l_cast_0("uintptr_t*", v285 + 44)[0];
                    local v293 = l_cast_0("const char*", v292 + 4);
                    v293 = l_string_0(v293);
                    v163[#v163 + 1] = {
                        position = vector(v286, v287, v288), 
                        angles = vector(v289, v290, v291), 
                        model = l_cast_0("void*", v292), 
                        model_name = v293
                    };
                end;
                return;
            end;
        end;
        parse_static_props();
        events.level_init(parse_static_props);
        v83(function()
            -- upvalues: v163 (ref)
            v163 = {};
        end);
    end;
    v164 = nil;
    v165 = function()
        -- upvalues: v164 (ref)
        v164 = nil;
        local v294 = common.get_map_data();
        if v294 == nil then
            return;
        else
            v164 = v294.shortname;
            return;
        end;
    end;
    events.level_init(v165);
    v83(v165);
    v165();
    v165 = db["World Editor"] or {};
    v166 = 1;
    v167 = {
        de_mirage = "3gAVAYuzZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSlc2NhbGXLP9MzMzMzMzSocG9zaXRpb27ZKW1vZGVscy9wcm9wcy9jc19pdGFseS9pdF9sYW50ZXJuMV9vZmYubWRsqm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDMudm10r2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUJpG5hbWWsbGFudGVybiBnbG93pWNvbG9ylMywzNXM/8z/pHR5cGWmU3ByaXRlAouzZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSlc2NhbGXLP/MzMzMzMzSocG9zaXRpb27ZKW1vZGVscy9wcm9wcy9jc19pdGFseS9pdF9sYW50ZXJuMV9vZmYubWRsqm1vZGVsX25hbWW/bW9kZWxzL3JlbWFwZXIvbGFudGVybl9idWdzLm1kbK9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlCaRuYW1lrWxhbnRlcm4gbW9kZWylY29sb3KUzLDM1cz/zP+kdHlwZaVNb2RlbAOLs2VuZF9wb3NpdGlvbl9vZmZzZXQAq3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUpXNjYWxlyz/MKPXCj1wpqHBvc2l0aW9u2Sltb2RlbHMvcHJvcHMvY3NfaXRhbHkvaXRfbGFudGVybjFfb2ZmLm1kbKptb2RlbF9uYW1luXJlbWFwZXIvbGlnaHRfZ2xvd2lybC52bXSvaGRyX2NvbG9yX3NjYWxlyz/TMzMzMzM0q3JlbmRlcl9tb2RlA6RuYW1lrmxhbnRlcm4gZ2xvdyAypWNvbG9ylMywzNXM/8z/pHR5cGWmU3ByaXRlBIyzZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSlc2NhbGXKPoAAAKhwb3NpdGlvbtkkbW9kZWxzL3Byb3BzL2RlX21pcmFnZS9sYW1wX3ZlcjIubWRspHR5cGWmU3ByaXRlqm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10r2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUJpG5hbWWwcGFsYWNlIGxhbXAgZ2xvd6Vjb2xvcpTM6cy2zIPM/7Fwb3NpdGlvbl96X29mZnNldPsFjLNlbmRfcG9zaXRpb25fb2Zmc2V0AKtzdGFydF93aWR0aBSpZW5kX3dpZHRoFKVzY2FsZco+gAAAqHBvc2l0aW9u2SRtb2RlbHMvcHJvcHMvZGVfbWlyYWdlL2xhbXBfdmVyMi5tZGykdHlwZaZTcHJpdGWqbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSvaGRyX2NvbG9yX3NjYWxlAatyZW5kZXJfbW9kZQmkbmFtZbJwYWxhY2UgbGFtcCBnbG93IDKlY29sb3KUzOnMtsyDzP+xcG9zaXRpb25fel9vZmZzZXQcBo2zZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSkdHlwZahQYXJ0aWNsZaVzY2FsZco+gAAArWFuZ2xlc19vZmZzZXQeqHBvc2l0aW9u2SRtb2RlbHMvcHJvcHMvZGVfbWlyYWdlL2xhbXBfdmVyMS5tZGyqbW9kZWxfbmFtZbZtb2xvdG92X2NoaWxkX2ZsYW1lMDNir2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUJpG5hbWWtZmlyZSBwYXJ0aWNsZaVjb2xvcpTM6cy2zIPM/7Fwb3NpdGlvbl96X29mZnNldAcHjbNlbmRfcG9zaXRpb25fb2Zmc2V0AKtzdGFydF93aWR0aBSpZW5kX3dpZHRoFKR0eXBlqFBhcnRpY2xlpXNjYWxlyj6AAACtYW5nbGVzX29mZnNldB6ocG9zaXRpb27ZJG1vZGVscy9wcm9wcy9kZV9taXJhZ2UvbGFtcF92ZXIxLm1kbKptb2RlbF9uYW1lrHNtb2tlX2dpYl8wMa9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlCaRuYW1ls2ZpcmUgc21va2UgcGFydGljbGWlY29sb3KUzOnMtsyDzP+xcG9zaXRpb25fel9vZmZzZXQHCI2zZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSkdHlwZaZTcHJpdGWlc2NhbGXKPwAAAK1hbmdsZXNfb2Zmc2V0Hqhwb3NpdGlvbtkkbW9kZWxzL3Byb3BzL2RlX21pcmFnZS9sYW1wX3ZlcjEubWRsqm1vZGVsX25hbWW5cmVtYXBlci9saWdodF9nbG93aXJsLnZtdK9oZHJfY29sb3Jfc2NhbGXLP/mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWrZmlyZSBzcHJpdGWlY29sb3KUzP95AMz/sXBvc2l0aW9uX3pfb2Zmc2V0BwmMqnNldF9hbmdsZXPDs2VuZF9wb3NpdGlvbl9vZmZzZXQAq3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUpXNjYWxlyz/zMzMzMzMzqHBvc2l0aW9u2SRtb2RlbHMvcHJvcHMvZGVfbWlyYWdlL2xhbXBfdmVyMi5tZGyqbW9kZWxfbmFtZdkibW9kZWxzL3JlbWFwZXIvcGFsYWNlbGlnaHRidWdzLm1kbK9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlCaRuYW1lsXBhbGFjZSBsYW1wIG1vZGVspWNvbG9ylMz/zP/M/8z/pHR5cGWlTW9kZWwKjLNlbmRfcG9zaXRpb25fb2Zmc2V0AKtzdGFydF93aWR0aBSpZW5kX3dpZHRoFKVzY2FsZco/wAAAqHBvc2l0aW9u2SRtb2RlbHMvcHJvcHMvZGVfbWlyYWdlL2xhbXBfdmVyNS5tZGykdHlwZaVNb2RlbKptb2RlbF9uYW1lv21vZGVscy9yZW1hcGVyL2xhbnRlcm5fYnVncy5tZGyvaGRyX2NvbG9yX3NjYWxlAatyZW5kZXJfbW9kZQmkbmFtZbljZWlsaW5nIHBhbGFjZSBsYW1wIG1vZGVspWNvbG9ylMz/zP/M/8z/sXBvc2l0aW9uX3pfb2Zmc2V05wuMs2VuZF9wb3NpdGlvbl9vZmZzZXQAq3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUpXNjYWxlyz/ZmZmZmZmaqHBvc2l0aW9u2SRtb2RlbHMvcHJvcHMvZGVfbWlyYWdlL2xhbXBfdmVyNS5tZGykdHlwZaZTcHJpdGWqbW9kZWxfbmFtZblyZW1hcGVyL2xpZ2h0X2dsb3dpcmwudm10r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZbpjZWlsaW5nIHBhbGFjZSBsYW1wIHNwcml0ZaVjb2xvcpTM/8y6dcz/sXBvc2l0aW9uX3pfb2Zmc2V05wyNqnNldF9hbmdsZXPDs2VuZF9wb3NpdGlvbl9vZmZzZXQAq3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUpXNjYWxlyj/AAACocG9zaXRpb27ZL21vZGVscy9wcm9wc191cmJhbi90ZWxlcGhvbmVfc3RyZWV0bGlnaHQwMDEubWRspHR5cGWlTW9kZWyqbW9kZWxfbmFtZdkgbW9kZWxzL3JlbWFwZXIvcG9sZWxpZ2h0YnVncy5tZGyvaGRyX2NvbG9yX3NjYWxlAatyZW5kZXJfbW9kZQmkbmFtZbFzdHJlZXRsaWdodCBtb2RlbKVjb2xvcpTM/8y4TMz/sXBvc2l0aW9uX3pfb2Zmc2V00N0NjbNlbmRfcG9zaXRpb25fb2Zmc2V00f9qq3N0YXJ0X3dpZHRoNqllbmRfd2lkdGg3pHR5cGWkQmVhbaVzY2FsZco+gAAArWFuZ2xlc19vZmZzZXTQ06hwb3NpdGlvbtkvbW9kZWxzL3Byb3BzX3VyYmFuL3RlbGVwaG9uZV9zdHJlZXRsaWdodDAwMS5tZGyqbW9kZWxfbmFtZbdzcHJpdGVzL2dsb3dfdGVzdDAyLnZtdK9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlCaRuYW1lsHBhbGFjZSBsYW1wIGJlYW2lY29sb3KUzOnMtsyDzMixcG9zaXRpb25fel9vZmZzZXQZDo2zZW5kX3Bvc2l0aW9uX29mZnNldNH/VqtzdGFydF93aWR0aDapZW5kX3dpZHRoN6R0eXBlplNwcml0ZaVzY2FsZQGtYW5nbGVzX29mZnNldNDTqHBvc2l0aW9u2S9tb2RlbHMvcHJvcHNfdXJiYW4vdGVsZXBob25lX3N0cmVldGxpZ2h0MDAxLm1kbKptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAzLnZtdK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWW0cGFsYWNlIGxhbXAgc3ByaXRlIDGlY29sb3KUzOnMtsyDzP+xcG9zaXRpb25fel9vZmZzZXQZD42zZW5kX3Bvc2l0aW9uX29mZnNldNH/VqtzdGFydF93aWR0aDapZW5kX3dpZHRoN6R0eXBlplNwcml0ZaVzY2FsZcs/6ZmZmZmZmq1hbmdsZXNfb2Zmc2V00NOocG9zaXRpb27ZL21vZGVscy9wcm9wc191cmJhbi90ZWxlcGhvbmVfc3RyZWV0bGlnaHQwMDEubWRsqm1vZGVsX25hbWW5cmVtYXBlci9saWdodF9nbG93aXJsLnZtdK9oZHJfY29sb3Jfc2NhbGXKPwAAAKtyZW5kZXJfbW9kZQmkbmFtZbRwYWxhY2UgbGFtcCBzcHJpdGUgMqVjb2xvcpTM6cy2zIPM/7Fwb3NpdGlvbl96X29mZnNldBkQjqpzZXRfYW5nbGVzw7NlbmRfcG9zaXRpb25fb2Zmc2V0AKtzdGFydF93aWR0aBSpZW5kX3dpZHRoFKhwb3NpdGlvbtklbW9kZWxzL3Byb3BzX3VyYmFuL3BvcmNoX2xpZ2h0MDAzLm1kbKVzY2FsZco/wAAAq3JlbmRlcl9tb2RlCaR0eXBlpU1vZGVsqm1vZGVsX25hbWW/bW9kZWxzL3JlbWFwZXIvbGFudGVybl9idWdzLm1kbK9oZHJfY29sb3Jfc2NhbGUBrWFuZ2xlc19vZmZzZXTspG5hbWWxcG9yY2ggbGlnaHQgbW9kZWylY29sb3KUzP/M/8z/zP+xcG9zaXRpb25fel9vZmZzZXTiEY6qc2V0X2FuZ2xlc8OzZW5kX3Bvc2l0aW9uX29mZnNldNH/VqtzdGFydF93aWR0aDWpZW5kX3dpZHRoNqhwb3NpdGlvbtklbW9kZWxzL3Byb3BzX3VyYmFuL3BvcmNoX2xpZ2h0MDAzLm1kbKVzY2FsZco/wAAAq3JlbmRlcl9tb2RlCaR0eXBlpEJlYW2qbW9kZWxfbmFtZbdzcHJpdGVzL2dsb3dfdGVzdDAyLnZtdK9oZHJfY29sb3Jfc2NhbGUBrWFuZ2xlc19vZmZzZXTspG5hbWWwcG9yY2ggbGlnaHQgYmVhbaVjb2xvcpTM/8zmzN5QsXBvc2l0aW9uX3pfb2Zmc2V0BRKOqnNldF9hbmdsZXPDs2VuZF9wb3NpdGlvbl9vZmZzZXTR/1arc3RhcnRfd2lkdGg1qWVuZF93aWR0aDaocG9zaXRpb27ZJW1vZGVscy9wcm9wc191cmJhbi9wb3JjaF9saWdodDAwMy5tZGylc2NhbGXLP/MzMzMzMzOrcmVuZGVyX21vZGUJpHR5cGWmU3ByaXRlqm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDMudm10r2hkcl9jb2xvcl9zY2FsZQGtYW5nbGVzX29mZnNldOykbmFtZbJwb3JjaCBsaWdodCBzcHJpdGWlY29sb3KUzP/M5szezMixcG9zaXRpb25fel9vZmZzZXQFE4yzZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSlc2NhbGXKP8AAAKhwb3NpdGlvbtkpbW9kZWxzL3Byb3BzL2RlX2luZmVybm8vY2VpbGluZ19saWdodC5tZGykdHlwZaVNb2RlbKptb2RlbF9uYW1lv21vZGVscy9yZW1hcGVyL2xhbnRlcm5fYnVncy5tZGyvaGRyX2NvbG9yX3NjYWxlAatyZW5kZXJfbW9kZQmkbmFtZbNjZWlsaW5nIGxpZ2h0IG1vZGVspWNvbG9ylMz/zP/M/8z/sXBvc2l0aW9uX3pfb2Zmc2V0+hSMs2VuZF9wb3NpdGlvbl9vZmZzZXQAq3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUpXNjYWxlyz/TMzMzMzMzqHBvc2l0aW9u2Sltb2RlbHMvcHJvcHMvZGVfaW5mZXJuby9jZWlsaW5nX2xpZ2h0Lm1kbKR0eXBlplNwcml0Zaptb2RlbF9uYW1luXJlbWFwZXIvbGlnaHRfZ2xvd2lybC52bXSvaGRyX2NvbG9yX3NjYWxlyz/jMzMzMzM0q3JlbmRlcl9tb2RlCaRuYW1ltGNlaWxpbmcgbGlnaHQgc3ByaXRlpWNvbG9ylMybzMzM/8z/sXBvc2l0aW9uX3pfb2Zmc2V0+qRkYXRhkA==", 
        de_vertigo = "3AAbjKVzY2FsZQGvaGRyX2NvbG9yX3NjYWxlAatyZW5kZXJfbW9kZQCkbmFtZbVnYXJiYWdlIGZpcmUgcGFydGljbGWocG9zaXRpb27ZSm1vZGVscy9wcm9wcy9kZV9kdXN0L2hyX2R1c3QvZHVzdF9nYXJiYWdlX2NvbnRhaW5lci9kdXN0X3RyYXNoX3BpbGVfMDIubWRsqm1vZGVsX25hbWWuZW52X2ZpcmVfbGFyZ2WlY29sb3KUzP/M/8z/zP+zZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSkdHlwZahQYXJ0aWNsZbFwb3NpdGlvbl96X29mZnNldC2MpXNjYWxly0ABCj1wo9cKr2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUDpG5hbWWzZ2FyYmFnZSBmaXJlIHNwcml0Zahwb3NpdGlvbtlWbW9kZWxzL3Byb3BzL2RlX2R1c3QvaHJfZHVzdC9kdXN0X2dhcmJhZ2VfY29udGFpbmVyL2R1c3RfZ2FyYmFnZV9jb250YWluZXJfb3Blbl8wMi5tZGyqbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSlY29sb3KUzP/MjEfM/7NlbmRfcG9zaXRpb25fb2Zmc2V0AKtzdGFydF93aWR0aBSpZW5kX3dpZHRoFKR0eXBlplNwcml0ZbFwb3NpdGlvbl96X29mZnNldCyLpXNjYWxlAa9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlAKRuYW1lsFsxXSBjYW5kbGUgbW9kZWyqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGylY29sb3KUzP/M/8z/zP+zZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSkdHlwZaVNb2RlbKhwb3NpdGlvbpPR+qgFzS4Ai6VzY2FsZQGvaGRyX2NvbG9yX3NjYWxlAatyZW5kZXJfbW9kZQCkbmFtZa9bMV0gY2FuZGxlIGZpcmWqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpWNvbG9ylMz/zP/M/8z/s2VuZF9wb3NpdGlvbl9vZmZzZXQAq3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUpHR5cGWoUGFydGljbGWocG9zaXRpb26T0fqoBc0uCoulc2NhbGXLP9mZmZmZmZqvaGRyX2NvbG9yX3NjYWxlAatyZW5kZXJfbW9kZQmkbmFtZbFbMV0gY2FuZGxlIHNwcml0Zaptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAzLnZtdKVjb2xvcpTM/8ybZ8z/s2VuZF9wb3NpdGlvbl9vZmZzZXQAq3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUpHR5cGWmU3ByaXRlqHBvc2l0aW9uk9H6qQXNLgaLpXNjYWxlyz/ZmZmZmZmar2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUJpG5hbWWrc2FmZXR5IGxhbXCqbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMy52bXSlY29sb3KUzP/Mm2fM/7NlbmRfcG9zaXRpb25fb2Zmc2V0AKtzdGFydF93aWR0aBSpZW5kX3dpZHRoFKR0eXBlplNwcml0Zahwb3NpdGlvbtk0bW9kZWxzL3Byb3BzL2RlX3ZlcnRpZ28vY29uc3RydWN0aW9uX3NhZmV0eV9sYW1wLm1kbIulc2NhbGUBr2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUApG5hbWW1WzFdIHBvcmNoIGxpZ2h0IG1vZGVsqm1vZGVsX25hbWXZJW1vZGVscy9wcm9wc191cmJhbi9wb3JjaF9saWdodDAwMS5tZGylY29sb3KUzP/M/8z/zP+zZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSkdHlwZaVNb2RlbKhwb3NpdGlvbpPR+YAMzS65i6VzY2FsZcs/164UeuFHrq9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlCaRuYW1ltlsxXSBwb3JjaCBsaWdodCBzcHJpdGWqbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMy52bXSlY29sb3KUzP/MrMyCzP+zZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSkdHlwZaZTcHJpdGWocG9zaXRpb26T0fl7DM0uvd4AEKVzY2FsZQGzc2V0X2FuZ2xlc196X29mZnNldMy0r2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUArWFuZ2xlc19vZmZzZXQBpHR5cGWlTW9kZWykbmFtZa1wbGF0Zm9ybSBsYW1wqHBvc2l0aW9u2VBtb2RlbHMvcHJvcHMvaHJfdmVydGlnby92ZXJ0aWdvX3BsYXRmb3JtX3JhaWxpbmcvdmVydGlnb19wbGF0Zm9ybV9yYWlsaW5nXzAyLm1kbLFjdXN0b21feWF3X29mZnNldACqbW9kZWxfbmFtZdk0bW9kZWxzL3Byb3BzL2RlX3ZlcnRpZ28vY29uc3RydWN0aW9uX3NhZmV0eV9sYW1wLm1kbKVjb2xvcpTM/8z/zP/M/7NlbmRfcG9zaXRpb25fb2Zmc2V0AKtzdGFydF93aWR0aBSpZW5kX3dpZHRoFKpzZXRfYW5nbGVzw7Fwb3NpdGlvbl96X29mZnNldB6LpXNjYWxlAa9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlAKRuYW1lsFsyXSBjYW5kbGUgbW9kZWyqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGylY29sb3KUzP/M/8z/zP+zZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSkdHlwZaVNb2RlbKhwb3NpdGlvbpPR+ErR/w7NLgCLpXNjYWxlAa9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlAKRuYW1lr1syXSBjYW5kbGUgZmlyZaptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWlY29sb3KUzP/M/8z/zP+zZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSkdHlwZahQYXJ0aWNsZahwb3NpdGlvbpPR+ErR/w7NLguLpXNjYWxlyz/ZmZmZmZmar2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUJpG5hbWWxWzJdIGNhbmRsZSBzcHJpdGWqbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMy52bXSlY29sb3KUzP/Mm2fM/7NlbmRfcG9zaXRpb25fb2Zmc2V0AKtzdGFydF93aWR0aBSpZW5kX3dpZHRoFKR0eXBlplNwcml0Zahwb3NpdGlvbpPR+ErR/w7NLgeOpXNjYWxlyz/ZmZmZmZmar2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUJqm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDMudm10pG5hbWW0cGxhdGZvcm0gbGFtcCBzcHJpdGWtYW5nbGVzX29mZnNldAGxY3VzdG9tX3lhd19vZmZzZXQApHR5cGWmU3ByaXRlpWNvbG9ylMz/zJtnzP+zZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSocG9zaXRpb27ZUG1vZGVscy9wcm9wcy9ocl92ZXJ0aWdvL3ZlcnRpZ29fcGxhdGZvcm1fcmFpbGluZy92ZXJ0aWdvX3BsYXRmb3JtX3JhaWxpbmdfMDIubWRssXBvc2l0aW9uX3pfb2Zmc2V0Houlc2NhbGXLP9MzMzMzMzOvaGRyX2NvbG9yX3NjYWxlAatyZW5kZXJfbW9kZQmkbmFtZa1saWdodCBjZWlsaW5nqm1vZGVsX25hbWW5cmVtYXBlci9saWdodF9nbG93aXJsLnZtdKVjb2xvcpTM/8z/zP/M/7NlbmRfcG9zaXRpb25fb2Zmc2V0AKtzdGFydF93aWR0aBSpZW5kX3dpZHRoFKR0eXBlplNwcml0Zahwb3NpdGlvbtkobW9kZWxzL3Byb3BzL2NzX29mZmljZS9MaWdodF9jZWlsaW5nLm1kbIulc2NhbGUBr2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUApG5hbWWwWzNdIGNhbmRsZSBtb2RlbKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKVjb2xvcpTM/8z/zP/M/6hwb3NpdGlvbpPR9/3lzS5cq3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUs2VuZF9wb3NpdGlvbl9vZmZzZXQApHR5cGWlTW9kZWyLpXNjYWxlAa9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlAKRuYW1lr1szXSBjYW5kbGUgZmlyZaR0eXBlqFBhcnRpY2xlpWNvbG9ylMz/zP/M/8z/qHBvc2l0aW9uk9H3/eXNLmerc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSzZW5kX3Bvc2l0aW9uX29mZnNldACqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1li6VzY2FsZcs/2ZmZmZmZmq9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlCaRuYW1lsVszXSBjYW5kbGUgc3ByaXRlpHR5cGWmU3ByaXRlpWNvbG9ylMz/zJtnzP+ocG9zaXRpb26T0ff95c0uYatzdGFydF93aWR0aBSpZW5kX3dpZHRoFKptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAzLnZtdLNlbmRfcG9zaXRpb25fb2Zmc2V0AI+lc2NhbGUBs3NldF9hbmdsZXNfel9vZmZzZXQAr2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUAs3NldF9hbmdsZXNfeV9vZmZzZXRapG5hbWW1WzJdIHBvcmNoIGxpZ2h0IG1vZGVspHR5cGWlTW9kZWyocG9zaXRpb26T0fjSzQHJzS69qm1vZGVsX25hbWXZJW1vZGVscy9wcm9wc191cmJhbi9wb3JjaF9saWdodDAwMS5tZGylY29sb3KUzP/M/8z/zP+zZW5kX3Bvc2l0aW9uX29mZnNldACrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSqc2V0X2FuZ2xlc8Ozc2V0X2FuZ2xlc194X29mZnNldACLpXNjYWxlyz/ZmZmZmZmar2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUJpG5hbWW2WzJdIHBvcmNoIGxpZ2h0IHNwcml0Zaptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAzLnZtdKVjb2xvcpTM/8ybZ8z/s2VuZF9wb3NpdGlvbl9vZmZzZXQAq3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUqHBvc2l0aW9uk9H40s0BxM0uwqR0eXBlplNwcml0ZYulc2NhbGXLP9zMzMzMzM2vaGRyX2NvbG9yX3NjYWxlAatyZW5kZXJfbW9kZQmkbmFtZbhbMl0gcG9yY2ggbGlnaHQgc3ByaXRlIDKkdHlwZaZTcHJpdGWlY29sb3KUzP/Mm2fM/6hwb3NpdGlvbpPR+NLNAcTNLsKrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSzZW5kX3Bvc2l0aW9uX29mZnNldACqbW9kZWxfbmFtZblyZW1hcGVyL2xpZ2h0X2dsb3dpcmwudm10i6VzY2FsZcs/3MzMzMzMza9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlCaRuYW1luFsxXSBwb3JjaCBsaWdodCBzcHJpdGUgMqptb2RlbF9uYW1luXJlbWFwZXIvbGlnaHRfZ2xvd2lybC52bXSlY29sb3KUzP/Mm2fM/6hwb3NpdGlvbpPR+XsMzS69q3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUs2VuZF9wb3NpdGlvbl9vZmZzZXQApHR5cGWmU3ByaXRli6VzY2FsZQGvaGRyX2NvbG9yX3NjYWxlAatyZW5kZXJfbW9kZQCkbmFtZbRjZWxpbmcgbGFudGVybiBtb2RlbKptb2RlbF9uYW1l2UNtb2RlbHMvcHJvcHMvZGVfZHVzdC9ocl9kdXN0L2R1c3RfbGlnaHRzL2R1c3Rfb3JuYXRlX2xhbnRlcm5fMDMubWRspWNvbG9ylMz/bm7M/6hwb3NpdGlvbpPR+bzNAQPNLwOrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSkdHlwZaVNb2RlbLNlbmRfcG9zaXRpb25fb2Zmc2V0AIulc2NhbGXKPwAAAK9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlCaRuYW1ltWNlbGluZyBsYW50ZXJuIHNwcml0ZaR0eXBlplNwcml0ZaVjb2xvcpTM/8ybZ8z/s2VuZF9wb3NpdGlvbl9vZmZzZXQAq3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUqHBvc2l0aW9uk9H5vM0BA80u4qptb2RlbF9uYW1luXJlbWFwZXIvbGlnaHRfZ2xvd2lybC52bXSLpXNjYWxlyz/mZmZmZmZnr2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUJpG5hbWW3Y2VsaW5nIGxhbnRlcm4gc3ByaXRlIDKkdHlwZaZTcHJpdGWlY29sb3KUzP/Mm2fM/6hwb3NpdGlvbpPR+bzNAQPNLuCrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSzZW5kX3Bvc2l0aW9uX29mZnNldACqbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMy52bXSPpXNjYWxlAbNzZXRfYW5nbGVzX3pfb2Zmc2V0AK9oZHJfY29sb3Jfc2NhbGUBq3JlbmRlcl9tb2RlALNzZXRfYW5nbGVzX3lfb2Zmc2V00KakbmFtZbBmbG9vZGxpZ2h0IG1vZGVspHR5cGWlTW9kZWyzZW5kX3Bvc2l0aW9uX29mZnNldACqbW9kZWxfbmFtZdkrbW9kZWxzL3Byb3BzX2VxdWlwbWVudC9saWdodF9mbG9vZGxpZ2h0Lm1kbKVjb2xvcpTM/8z/zP/M/6hwb3NpdGlvbpPR+LbNAajNLgCrc3RhcnRfd2lkdGgUqWVuZF93aWR0aBSqc2V0X2FuZ2xlc8Ozc2V0X2FuZ2xlc194X29mZnNldACLpXNjYWxlyz/DMzMzMzMzr2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUJpG5hbWW3Zmxvb2RsaWdodCBtb2RlbCBzcHJpdGWkdHlwZaZTcHJpdGWlY29sb3KUzP/M/8z/zP+ocG9zaXRpb26T0fjCzQGmzS5Rq3N0YXJ0X3dpZHRoFKllbmRfd2lkdGgUs2VuZF9wb3NpdGlvbl9vZmZzZXQAqm1vZGVsX25hbWW9c3ByaXRlcy9udWtlX3N1bmZsYXJlXzAwMS52bXSLpXNjYWxlyz/DMzMzMzMzr2hkcl9jb2xvcl9zY2FsZQGrcmVuZGVyX21vZGUJpG5hbWW5Zmxvb2RsaWdodCBtb2RlbCBzcHJpdGUgMqptb2RlbF9uYW1lvXNwcml0ZXMvbnVrZV9zdW5mbGFyZV8wMDEudm10pWNvbG9ylMz/zP/M/8z/qHBvc2l0aW9uk9H4q80Bps0uUKtzdGFydF93aWR0aBSpZW5kX3dpZHRoFLNlbmRfcG9zaXRpb25fb2Zmc2V0AKR0eXBlplNwcml0ZQ==", 
        de_cbble = "3AK/hKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpVsxXSAxqHBvc2l0aW9uk8rEVzj2ykUYdcPR/06kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWlWzFdIDKocG9zaXRpb26TysRXOPbKRRh1w9H/WKR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEVzj2ykUYdcPR/1OvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpVsxXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWlWzJdIDGocG9zaXRpb26TysRRzyvKRRitmtH/TqR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaVbMl0gMqhwb3NpdGlvbpPKxFHPK8pFGK2a0f9YpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysRRzyvKRRitmtH/U69oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWlWzJdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaVbM10gMahwb3NpdGlvbpPKxE/2qMpFF3Y90f9OpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpVszXSAyqHBvc2l0aW9uk8rET/aoykUXdj3R/1ikdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxE/2qMpFF3Y90f9Tr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaVbM10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpVs0XSAxqHBvc2l0aW9uk8rET5WRykUIpmbR/06kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWlWzRdIDKocG9zaXRpb26TysRPlZHKRQimZtH/WKR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rET5WRykUIpmbR/1OvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpVs0XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWlWzVdIDGocG9zaXRpb26TysRRWwLKRQdaPdH/TqR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaVbNV0gMqhwb3NpdGlvbpPKxFFbAspFB1o90f9YpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysRRWwLKRQdaPdH/U69oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWlWzVdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaVbNl0gMahwb3NpdGlvbpPKxFaEOcpFB4QA0f9OpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpVs2XSAyqHBvc2l0aW9uk8rEVoQ5ykUHhADR/1ikdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxFaEOcpFB4QA0f9Tr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaVbNl0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpVs3XSAxqHBvc2l0aW9uk8rEzTcKykSU6Uj/pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpVs3XSAyqHBvc2l0aW9uk8rEzTcKykSU6UgJpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTNNwrKRJTpSASvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpVs3XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWlWzhdIDGocG9zaXRpb26TysTKq4XKRJPkKf+kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWlWzhdIDKocG9zaXRpb26TysTKq4XKRJPkKQmkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxMqrhcpEk+QpBK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWlWzhdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaVbOV0gMahwb3NpdGlvbpPKxMshmspEkVTN/6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaVbOV0gMqhwb3NpdGlvbpPKxMshmspEkVTNCaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEyyGaykSRVM0Er2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaVbOV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lplsxMF0gMahwb3NpdGlvbpPR+bXNA+M/pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lplsxMF0gMqhwb3NpdGlvbpPR+bXNA+NJpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26T0fm1zQPjRK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzEwXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzExXSAxqHBvc2l0aW9uk9H4YtH8+9DapHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lplsxMV0gMqhwb3NpdGlvbpPR+GLR/PvkpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26T0fhi0fz70N+vaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lplsxMV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lplsxMl0gMahwb3NpdGlvbpPR+DXR/ajQkqR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbMTJdIDKocG9zaXRpb26T0fg10f2o0JykdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPR+DXR/ajQl69oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzEyXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzEzXSAxqHBvc2l0aW9uk9H3h8rDn5N10f8bpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lplsxM10gMqhwb3NpdGlvbpPR94fKw5+TddH/JaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk9H3h8rDn5N10f8gr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbMTNdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbMTRdIDGocG9zaXRpb26TysUAWM3Kw8PwANH/SaR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbMTRdIDKocG9zaXRpb26TysUAWM3Kw8PwANH/U6R0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFAFjNysPD8ADR/06vaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lplsxNF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lplsxNV0gMahwb3NpdGlvbpPKxP7fXMrDzCGJ0f9JpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lplsxNV0gMqhwb3NpdGlvbpPKxP7fXMrDzCGJ0f9TpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysT+31zKw8whidH/Tq9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzE1XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzE2XSAxqHBvc2l0aW9uk8rFADa4ysPUeJPR/0mkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzE2XSAyqHBvc2l0aW9uk8rFADa4ysPUeJPR/1OkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxQA2uMrD1HiT0f9Or2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbMTZdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbMTddIDGocG9zaXRpb26TysT2azPKxC2SsNDCpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lplsxN10gMqhwb3NpdGlvbpPKxPZrM8rELZKw0MykdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxPZrM8rELZKw0MevaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lplsxN10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lplsxOF0gMahwb3NpdGlvbpPKxPVGZsrEMo5m0MKkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzE4XSAyqHBvc2l0aW9uk8rE9UZmysQyjmbQzKR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE9UZmysQyjmbQx69oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzE4XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzE5XSAxqHBvc2l0aW9uk8rE918KysQ1on/QwqR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbMTldIDKocG9zaXRpb26TysT3XwrKxDWif9DMpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysT3XwrKxDWif9DHr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbMTldIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbMjBdIDGocG9zaXRpb26TysUiU9fKRRleuA+kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzIwXSAyqHBvc2l0aW9uk8rFIlPXykUZXrgZpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUiU9fKRRleuBSvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lplsyMF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lplsyMV0gMahwb3NpdGlvbpPKxSOPrspFGfeuD6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbMjFdIDKocG9zaXRpb26TysUjj67KRRn3rhmkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxSOPrspFGfeuFK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzIxXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzIyXSAxqHBvc2l0aW9uk8rFIz3sykUbOmYPpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lplsyMl0gMqhwb3NpdGlvbpPKxSM97MpFGzpmGaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFIz3sykUbOmYUr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbMjJdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbMjNdIDGocG9zaXRpb26TysVTAPbKw7BKwf+kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzIzXSAyqHBvc2l0aW9uk8rFUwD2ysOwSsEJpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysVTAPbKw7BKwQSvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lplsyM10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lplsyNF0gMahwb3NpdGlvbpPKxVLRH8rDpW3T/6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbMjRdIDKocG9zaXRpb26TysVS0R/Kw6Vt0wmkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxVLRH8rDpW3TBK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzI0XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzI1XSAxqHBvc2l0aW9uk8rFUYT2ysOkvhT/pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lplsyNV0gMqhwb3NpdGlvbpPKxVGE9srDpL4UCaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFUYT2ysOkvhQEr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbMjVdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbMjZdIDGocG9zaXRpb26TykQcMKTKw9MKHQCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzI2XSAyqHBvc2l0aW9uk8pEHDCkysPTCh0KpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TykQcMKTKw9MKHQWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lplsyNl0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lplsyN10gMahwb3NpdGlvbpPKRBdBecrDzkItAKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbMjddIDKocG9zaXRpb26TykQXQXnKw85CLQqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKRBdBecrDzkItBa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzI3XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzI4XSAxqHBvc2l0aW9uk8pEGIiDysPELEoApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lplsyOF0gMqhwb3NpdGlvbpPKRBiIg8rDxCxKCqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8pEGIiDysPELEoFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbMjhdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbMjldIDGocG9zaXRpb26T0fX90f4T0J6kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzI5XSAyqHBvc2l0aW9uk9H1/dH+E9CopHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26T0fX90f4T0KOvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lplsyOV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lplszMF0gMahwb3NpdGlvbpPR9hXR/mjR/3KkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzMwXSAyqHBvc2l0aW9uk9H2FdH+aNH/fKR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk9H2FdH+aNH/d69oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzMwXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzMxXSAxqHBvc2l0aW9uk8rE/xmaysTd+ADypHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lplszMV0gMqhwb3NpdGlvbpPKxP8ZmsrE3fgA/KR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE/xmaysTd+AD3r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbMzFdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbMzJdIDGocG9zaXRpb26TysT9vCnKxNuXXPKkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzMyXSAyqHBvc2l0aW9uk8rE/bwpysTbl1z8pHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysT9vCnKxNuXXPevaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lplszMl0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lplszM10gMahwb3NpdGlvbpPKxPtDhcrE3Gdc8qR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbMzNdIDKocG9zaXRpb26TysT7Q4XKxNxnXPykdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxPtDhcrE3Gdc969oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzMzXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzM0XSAxqHBvc2l0aW9uk8pELBsCysSAdM3Qk6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbMzRdIDKocG9zaXRpb26TykQsGwLKxIB0zdCdpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TykQsGwLKxIB0zdCYr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbMzRdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbMzVdIDGocG9zaXRpb26TykQqFQ7KxHvRSNCTpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lplszNV0gMqhwb3NpdGlvbpPKRCoVDsrEe9FI0J2kdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKRCoVDsrEe9FI0JivaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lplszNV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lplszNl0gMahwb3NpdGlvbpPKRC5uZsrEePYl0JOkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzM2XSAyqHBvc2l0aW9uk8pELm5mysR49iXQnaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8pELm5mysR49iXQmK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzM2XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzM3XSAxqHBvc2l0aW9uk80By9H7E+CkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzM3XSAyqHBvc2l0aW9uk80By9H7E+qkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPNAcvR+xPlr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbMzddIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbMzhdIDGocG9zaXRpb26TykMFR/DKw8vnz9DApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lplszOF0gMqhwb3NpdGlvbpPKQwVH8MrDy+fP0MqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKQwVH8MrDy+fP0MWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lplszOF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lplszOV0gMahwb3NpdGlvbpPKQxj3jcrDxxKP0MCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzM5XSAyqHBvc2l0aW9uk8pDGPeNysPHEo/QyqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8pDGPeNysPHEo/Qxa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzM5XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzQwXSAxqHBvc2l0aW9uk8pDJbdMysPPS6bQwKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNDBdIDKocG9zaXRpb26TykMlt0zKw89LptDKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TykMlt0zKw89LptDFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNDBdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNDFdIDGocG9zaXRpb26TysLrY9fKxAdPruCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzQxXSAyqHBvc2l0aW9uk8rC62PXysQHT67qpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysLrY9fKxAdPruWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls0MV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls0Ml0gMahwb3NpdGlvbpPKwtmn8MrEAkvn4KR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNDJdIDKocG9zaXRpb26TysLZp/DKxAJL5+qkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKwtmn8MrEAkvn5a9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzQyXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzQzXSAxqHBvc2l0aW9uk8rCsPsjysQDZbLgpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls0M10gMqhwb3NpdGlvbpPKwrD7I8rEA2Wy6qR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rCsPsjysQDZbLlr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNDNdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNDRdIDGocG9zaXRpb26T0fbT0fxk/aR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNDRdIDKocG9zaXRpb26T0fbT0fxkB6R0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk9H209H8ZAKvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls0NF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls0NV0gMahwb3NpdGlvbpPR9uvR+6UDpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls0NV0gMqhwb3NpdGlvbpPR9uvR+6UNpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26T0fbr0fulCK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzQ1XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzQ2XSAxqHBvc2l0aW9uk9H3h9H8IQKkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzQ2XSAyqHBvc2l0aW9uk9H3h9H8IQykdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPR94fR/CEHr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNDZdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNDddIDGocG9zaXRpb26T0fXMzQS80f96pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls0N10gMqhwb3NpdGlvbpPR9czNBLzQhKR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk9H1zM0EvNH/f69oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzQ3XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzQ4XSAxqHBvc2l0aW9uk9H1880FDNC2pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls0OF0gMqhwb3NpdGlvbpPR9fPNBQzQwKR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk9H1880FDNC7r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNDhdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNDldIDGocG9zaXRpb26TysU2fADKxD9M7gmkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzQ5XSAyqHBvc2l0aW9uk8rFNnwAysQ/TO4TpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysU2fADKxD9M7g6vaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls0OV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls1MF0gMahwb3NpdGlvbpPKxTdge8rEOyQICaR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNTBdIDKocG9zaXRpb26TysU3YHvKxDskCBOkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxTdge8rEOyQIDq9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzUwXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzUxXSAxqHBvc2l0aW9uk8rFNpTNysQ3BocJpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls1MV0gMqhwb3NpdGlvbpPKxTaUzcrENwaHE6R0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFNpTNysQ3BocOr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNTFdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNTJdIDGocG9zaXRpb26TysUSXwrKwqjU5NH/B6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNTJdIDKocG9zaXRpb26TysUSXwrKwqjU5NH/EaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFEl8KysKo1OTR/wyvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls1Ml0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls1M10gMahwb3NpdGlvbpPKxRKO4crC1Ei00f8HpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls1M10gMqhwb3NpdGlvbpPKxRKO4crC1Ei00f8RpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUSjuHKwtRItNH/DK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzUzXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzU0XSAxqHBvc2l0aW9uk8rFE9sKysLXB67R/wekdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzU0XSAyqHBvc2l0aW9uk8rFE9sKysLXB67R/xGkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxRPbCsrC1weu0f8Mr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNTRdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNTVdIDGocG9zaXRpb26T0fdpzQR70f9ppHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls1NV0gMqhwb3NpdGlvbpPR92nNBHvR/3OkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPR92nNBHvR/26vaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls1NV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls1Nl0gMahwb3NpdGlvbpPR9mvNBQ7Q26R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNTZdIDKocG9zaXRpb26T0fZrzQUO5aR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk9H2a80FDuCvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls1Nl0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls1N10gMahwb3NpdGlvbpPR9ajNBH7R/0mkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzU3XSAyqHBvc2l0aW9uk9H1qM0EftH/U6R0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk9H1qM0EftH/Tq9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzU3XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzU4XSAxqHBvc2l0aW9uk8pDcfqgysLDUarspHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls1OF0gMqhwb3NpdGlvbpPKQ3H6oMrCw1Gq9qR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8pDcfqgysLDUarxr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNThdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNTldIDGocG9zaXRpb26TykNcDVDKwsQzguykdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzU5XSAyqHBvc2l0aW9uk8pDXA1QysLEM4L2pHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TykNcDVDKwsQzgvGvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls1OV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls2MF0gMahwb3NpdGlvbpPKQ1dysMrCm51+7KR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNjBdIDKocG9zaXRpb26TykNXcrDKwpudfvakdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKQ1dysMrCm51+8a9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzYwXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzYxXSAxqHBvc2l0aW9uk8rDHAJOysJ9gifQ36R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNjFdIDKocG9zaXRpb26TysMcAk7Kwn2CJ+mkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKwxwCTsrCfYIn5K9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzYxXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzYyXSAxqHBvc2l0aW9uk8rDCMxKysKT6ujQ36R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNjJdIDKocG9zaXRpb26TysMIzErKwpPq6OmkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKwwjMSsrCk+ro5K9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzYyXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzYzXSAxqHBvc2l0aW9uk8rDDvU/ysK7q3jQ36R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNjNdIDKocG9zaXRpb26TysMO9T/KwrureOmkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKww71P8rCu6t45K9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzYzXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzY0XSAxqHBvc2l0aW9uk8pD+MFIysSu9R/Qr6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNjRdIDKocG9zaXRpb26TykP4wUjKxK71H9C5pHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TykP4wUjKxK71H9C0r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNjRdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNjVdIDGocG9zaXRpb26TykPzACHKxKyfrtCvpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls2NV0gMqhwb3NpdGlvbpPKQ/MAIcrErJ+u0LmkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKQ/MAIcrErJ+u0LSvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls2NV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls2Nl0gMahwb3NpdGlvbpPKQ/qTM8rEqtcK0K+kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzY2XSAyqHBvc2l0aW9uk8pD+pMzysSq1wrQuaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8pD+pMzysSq1wrQtK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzY2XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzY3XSAxqHBvc2l0aW9uk8pDqiVgysSw6zPQr6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNjddIDKocG9zaXRpb26TykOqJWDKxLDrM9C5pHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TykOqJWDKxLDrM9C0r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNjddIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNjhdIDGocG9zaXRpb26TykO0HM3KxK/GZtCvpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls2OF0gMqhwb3NpdGlvbpPKQ7QczcrEr8Zm0LmkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKQ7QczcrEr8Zm0LSvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls2OF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls2OV0gMahwb3NpdGlvbpPKQ7pE/srEsd8K0K+kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzY5XSAyqHBvc2l0aW9uk8pDukT+ysSx3wrQuaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8pDukT+ysSx3wrQtK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzY5XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzcwXSAxqHBvc2l0aW9uk8pEFYeNysSyRM3Qr6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNzBdIDKocG9zaXRpb26TykQVh43KxLJEzdC5pHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TykQVh43KxLJEzdC0r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNzBdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNzFdIDGocG9zaXRpb26TykQW+wLR+oPQr6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNzFdIDKocG9zaXRpb26TykQW+wLR+oPQuaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8pEFvsC0fqD0LSvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls3MV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls3Ml0gMahwb3NpdGlvbpPKRBwr+MrEr8sz0K+kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzcyXSAyqHBvc2l0aW9uk8pEHCv4ysSvyzPQuaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8pEHCv4ysSvyzPQtK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzcyXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzczXSAxqHBvc2l0aW9uk8rFIJQAysQ7cuEEpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls3M10gMqhwb3NpdGlvbpPKxSCUAMrEO3LhDqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFIJQAysQ7cuEJr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNzNdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNzRdIDGocG9zaXRpb26TysUhxFLKxDi4UgSkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzc0XSAyqHBvc2l0aW9uk8rFIcRSysQ4uFIOpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUhxFLKxDi4UgmvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls3NF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls3NV0gMahwb3NpdGlvbpPKxSFcUsrEM8dMBKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNzVdIDKocG9zaXRpb26TysUhXFLKxDPHTA6kdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxSFcUsrEM8dMCa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzc1XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzc2XSAxqHBvc2l0aW9uk8rEbVOmykQ3zKw5pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls3Nl0gMqhwb3NpdGlvbpPKxG1TpspEN8ysQ6R0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEbVOmykQ3zKw+r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNzZdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbNzddIDGocG9zaXRpb26TysRpEzPKRDtC4TmkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzc3XSAyqHBvc2l0aW9uk8rEaRMzykQ7QuFDpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysRpEzPKRDtC4T6vaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls3N10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls3OF0gMahwb3NpdGlvbpPKxGULZMpEN/jlOaR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbNzhdIDKocG9zaXRpb26TysRlC2TKRDf45UOkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxGULZMpEN/jlPq9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzc4XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzc5XSAxqHBvc2l0aW9uk8rFR849ykQSmGIwpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls3OV0gMqhwb3NpdGlvbpPKxUfOPcpEEphiOqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFR849ykQSmGI1r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbNzldIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbODBdIDGocG9zaXRpb26TysVISezKRBe5yzCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzgwXSAyqHBvc2l0aW9uk8rFSEnsykQXucs6pHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysVISezKRBe5yzWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls4MF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls4MV0gMahwb3NpdGlvbpPKxUcwe8pEGoEXMKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbODFdIDKocG9zaXRpb26TysVHMHvKRBqBFzqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxUcwe8pEGoEXNa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzgxXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzgyXSAxqHBvc2l0aW9uk8rE1i1xykOy964ApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls4Ml0gMqhwb3NpdGlvbpPKxNYtccpDsveuCqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE1i1xykOy964Fr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbODJdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbODNdIDGocG9zaXRpb26TysTY5HvKQ7R3CgCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzgzXSAyqHBvc2l0aW9uk8rE2OR7ykO0dwoKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTY5HvKQ7R3CgWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls4M10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls4NF0gMahwb3NpdGlvbpPKxNkQUspDvti0AKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbODRdIDKocG9zaXRpb26TysTZEFLKQ77YtAqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxNkQUspDvti0Ba9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzg0XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzg1XSAxqHBvc2l0aW9uk8rEzz5mykRCHrjQwKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbODVdIDKocG9zaXRpb26TysTPPmbKREIeuNDKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTPPmbKREIeuNDFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbODVdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbODZdIDGocG9zaXRpb26TysTR/CnKREH2RtDApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls4Nl0gMqhwb3NpdGlvbpPKxNH8KcpEQfZG0MqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxNH8KcpEQfZG0MWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls4Nl0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls4N10gMahwb3NpdGlvbpPKxNKVH8pERwZm0MCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzg3XSAyqHBvc2l0aW9uk8rE0pUfykRHBmbQyqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE0pUfykRHBmbQxa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzg3XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzg4XSAxqHBvc2l0aW9uk8rE543DykQ541TQwKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbODhdIDKocG9zaXRpb26TysTnjcPKRDnjVNDKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTnjcPKRDnjVNDFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbODhdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbODldIDGocG9zaXRpb26TysTl/rjKRDVgtNDApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls4OV0gMqhwb3NpdGlvbpPKxOX+uMpENWC00MqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxOX+uMpENWC00MWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls4OV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls5MF0gMahwb3NpdGlvbpPKxOfK4cpEMZ4l0MCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzkwXSAyqHBvc2l0aW9uk8rE58rhykQxniXQyqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE58rhykQxniXQxa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzkwXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzkxXSAxqHBvc2l0aW9uk8rE3UYUykPcYQbR/1CkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzkxXSAyqHBvc2l0aW9uk8rE3UYUykPcYQbR/1qkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxN1GFMpD3GEG0f9Vr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbOTFdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbOTJdIDGocG9zaXRpb26TysTdmezKQ9F9stH/UKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbOTJdIDKocG9zaXRpb26TysTdmezKQ9F9stH/WqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE3ZnsykPRfbLR/1WvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls5Ml0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls5M10gMahwb3NpdGlvbpPKxOAxSMpD0J+e0f9QpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls5M10gMqhwb3NpdGlvbpPKxOAxSMpD0J+e0f9apHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTgMUjKQ9CfntH/Va9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzkzXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzk0XSAxqHBvc2l0aW9uk8rE75j2ykQxdR/R/1CkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzk0XSAyqHBvc2l0aW9uk8rE75j2ykQxdR/R/1qkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxO+Y9spEMXUf0f9Vr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbOTRdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbOTVdIDGocG9zaXRpb26TysTyRCnKRDA1w9H/UKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbOTVdIDKocG9zaXRpb26TysTyRCnKRDA1w9H/WqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE8kQpykQwNcPR/1WvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls5NV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls5Nl0gMahwb3NpdGlvbpPKxPNbhcpENO7Z0f9QpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls5Nl0gMqhwb3NpdGlvbpPKxPNbhcpENO7Z0f9apHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTzW4XKRDTu2dH/Va9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzk2XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWmWzk3XSAxqHBvc2l0aW9uk8rE8sgAykPXaTfR/1CkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWmWzk3XSAyqHBvc2l0aW9uk8rE8sgAykPXaTfR/1qkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxPLIAMpD12k30f9Vr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZaZbOTddIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZaZbOThdIDGocG9zaXRpb26TysT1dXHKQ9nBidH/UKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZaZbOThdIDKocG9zaXRpb26TysT1dXHKQ9nBidH/WqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE9XVxykPZwYnR/1WvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lpls5OF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lpls5OV0gMahwb3NpdGlvbpPKxPVtH8pD5CjV0f9QpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lpls5OV0gMqhwb3NpdGlvbpPKxPVtH8pD5CjV0f9apHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysT1bR/KQ+Qo1dH/Va9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWmWzk5XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzEwMF0gMahwb3NpdGlvbpPKxTMDXMpEJZMSAKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTAwXSAyqHBvc2l0aW9uk8rFMwNcykQlkxIKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUzA1zKRCWTEgWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMDBdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTAxXSAxqHBvc2l0aW9uk8rFMv49ykQrDocApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMDFdIDKocG9zaXRpb26TysUy/j3KRCsOhwqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxTL+PcpEKw6HBa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzEwMV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMDJdIDGocG9zaXRpb26TysUxtzPKRCwHrgCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzEwMl0gMqhwb3NpdGlvbpPKxTG3M8pELAeuCqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFMbczykQsB64Fr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTAyXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzEwM10gMahwb3NpdGlvbpPKxFg0GcrCxBMmzICkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzEwM10gMqhwb3NpdGlvbpPKxFg0GcrCxBMmzIqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxFg0GcrCxBMmzIWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMDNdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTA0XSAxqHBvc2l0aW9uk8rEVyv4ysKY/sXMgKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTA0XSAyqHBvc2l0aW9uk8rEVyv4ysKY/sXMiqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEVyv4ysKY/sXMha9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzEwNF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMDVdIDGocG9zaXRpb26TysRR+FLKwphtUMyApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMDVdIDKocG9zaXRpb26TysRR+FLKwphtUMyKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysRR+FLKwphtUMyFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTA1XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzEwNl0gMahwb3NpdGlvbpPKxDzEGcrDnAdMzICkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzEwNl0gMqhwb3NpdGlvbpPKxDzEGcrDnAdMzIqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxDzEGcrDnAdMzIWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMDZdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTA3XSAxqHBvc2l0aW9uk8rEPdhCysOmx67MgKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTA3XSAyqHBvc2l0aW9uk8rEPdhCysOmx67MiqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEPdhCysOmx67Mha9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzEwN10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMDhdIDGocG9zaXRpb26TysRDC/jKw6bU3cyApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMDhdIDKocG9zaXRpb26TysRDC/jKw6bU3cyKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysRDC/jKw6bU3cyFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTA4XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzEwOV0gMahwb3NpdGlvbpPKxEV03crETE9M4KR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTA5XSAyqHBvc2l0aW9uk8rERXTdysRMT0zqpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysRFdN3KxExPTOWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMDldIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTEwXSAxqHBvc2l0aW9uk8rESu76ysRMkDHgpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMTBdIDKocG9zaXRpb26TysRK7vrKxEyQMeqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxEru+srETJAx5a9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzExMF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMTFdIDGocG9zaXRpb26TysRMN43KxEeFouCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzExMV0gMqhwb3NpdGlvbpPKxEw3jcrER4Wi6qR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rETDeNysRHhaLlr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTExXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzExMl0gMahwb3NpdGlvbpPKxTSZccrEi4o9IKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTEyXSAyqHBvc2l0aW9uk8rFNJlxysSLij0qpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysU0mXHKxIuKPSWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMTJdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTEzXSAxqHBvc2l0aW9uk8rFNfQpysSLHhQgpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMTNdIDKocG9zaXRpb26TysU19CnKxIseFCqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxTX0KcrEix4UJa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzExM10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMTRdIDGocG9zaXRpb26TysU2BFLKxIiFHyCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzExNF0gMqhwb3NpdGlvbpPKxTYEUsrEiIUfKqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFNgRSysSIhR8lr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTE0XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzExNV0gMahwb3NpdGlvbpPKxQUbCspDjHsj0f8QpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMTVdIDKocG9zaXRpb26TysUFGwrKQ4x7I9H/GqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFBRsKykOMeyPR/xWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMTVdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTE2XSAxqHBvc2l0aW9uk8rFA9maykOQ4UjR/xCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzExNl0gMqhwb3NpdGlvbpPKxQPZmspDkOFI0f8apHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUD2ZrKQ5DhSNH/Fa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzExNl0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMTddIDGocG9zaXRpb26TysUDGXHKQ4hjEtH/EKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTE3XSAyqHBvc2l0aW9uk8rFAxlxykOIYxLR/xqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxQMZccpDiGMS0f8Vr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTE3XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzExOF0gMahwb3NpdGlvbpPKxOrgUsrElVKPAKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTE4XSAyqHBvc2l0aW9uk8rE6uBSysSVUo8KpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTq4FLKxJVSjwWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMThdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTE5XSAxqHBvc2l0aW9uk8rE6CVxysSVk9cApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMTldIDKocG9zaXRpb26TysToJXHKxJWT1wqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxOglccrElZPXBa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzExOV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMjBdIDGocG9zaXRpb26TysTn3M3KxJgp7ACkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzEyMF0gMqhwb3NpdGlvbpPKxOfczcrEmCnsCqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE59zNysSYKewFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTIwXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzEyMV0gMahwb3NpdGlvbpPKxOQB7MrEqyCkAKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTIxXSAyqHBvc2l0aW9uk8rE5AHsysSrIKQKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTkAezKxKsgpAWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMjFdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTIyXSAxqHBvc2l0aW9uk8rE4XAAysSsFHsApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMjJdIDKocG9zaXRpb26TysThcADKxKwUewqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxOFwAMrErBR7Ba9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzEyMl0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMjNdIDGocG9zaXRpb26TysTh1M3KxK6muACkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzEyM10gMqhwb3NpdGlvbpPKxOHUzcrErqa4CqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE4dTNysSuprgFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTIzXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzEyNF0gMahwb3NpdGlvbpPKxO9uFMrErRZmAKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTI0XSAyqHBvc2l0aW9uk8rE724UysStFmYKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTvbhTKxK0WZgWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMjRdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTI1XSAxqHBvc2l0aW9uk8rE7ecKysSqz1wApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMjVdIDKocG9zaXRpb26TysTt5wrKxKrPXAqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxO3nCsrEqs9cBa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzEyNV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMjZdIDGocG9zaXRpb26TysTrfrjKxKvLMwCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzEyNl0gMqhwb3NpdGlvbpPKxOt+uMrEq8szCqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE6364ysSryzMFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTI2XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzEyN10gMahwb3NpdGlvbpPKxPmI9srEnOlIAKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTI3XSAyqHBvc2l0aW9uk8rE+Yj2ysSc6UgKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysT5iPbKxJzpSAWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMjddIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTI4XSAxqHBvc2l0aW9uk8rE/BR7ysSb5CkApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMjhdIDKocG9zaXRpb26TysT8FHvKxJvkKQqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxPwUe8rEm+QpBa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzEyOF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMjldIDGocG9zaXRpb26TysT7nmbKxJlUzQCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzEyOV0gMqhwb3NpdGlvbpPKxPueZsrEmVTNCqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE+55mysSZVM0Fr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTI5XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzEzMF0gMahwb3NpdGlvbpPKxOTHCsrEyS3DYKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTMwXSAyqHBvc2l0aW9uk8rE5McKysTJLcNqpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTkxwrKxMktw2WvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMzBdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTMxXSAxqHBvc2l0aW9uk8rE4hPXysTJpcNgpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMzFdIDKocG9zaXRpb26TysTiE9fKxMmlw2qkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxOIT18rEyaXDZa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzEzMV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMzJdIDGocG9zaXRpb26TysTh/wrKxMw/XGCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzEzMl0gMqhwb3NpdGlvbpPKxOH/CsrEzD9caqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rE4f8KysTMP1xlr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTMyXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzEzM10gMahwb3NpdGlvbpPKQ9IsrMrEX2o90LikdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzEzM10gMqhwb3NpdGlvbpPKQ9IsrMrEX2o90MKkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKQ9IsrMrEX2o90L2vaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMzNdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTM0XSAxqHBvc2l0aW9uk8pD2QYlysRjsm/QuKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTM0XSAyqHBvc2l0aW9uk8pD2QYlysRjsm/QwqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8pD2QYlysRjsm/Qva9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzEzNF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMzVdIDGocG9zaXRpb26TykPSYCHKxGey0dC4pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMzVdIDKocG9zaXRpb26TykPSYCHKxGey0dDCpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TykPSYCHKxGey0dC9r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTM1XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzEzNl0gMahwb3NpdGlvbpPKQ1Hc7srEjVHs0LikdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzEzNl0gMqhwb3NpdGlvbpPKQ1Hc7srEjVHs0MKkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKQ1Hc7srEjVHs0L2vaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMzZdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTM3XSAxqHBvc2l0aW9uk8pDQkLRysSPPwrQuKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTM3XSAyqHBvc2l0aW9uk8pDQkLRysSPPwrQwqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8pDQkLRysSPPwrQva9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzEzN10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxMzhdIDGocG9zaXRpb26TykMw8/jKxI3NcdC4pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxMzhdIDKocG9zaXRpb26TykMw8/jKxI3NcdDCpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TykMw8/jKxI3NcdC9r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTM4XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzEzOV0gMahwb3NpdGlvbpPKweOS18rEZ8gA0LikdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzEzOV0gMqhwb3NpdGlvbpPKweOS18rEZ8gA0MKkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKweOS18rEZ8gA0L2vaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxMzldIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTQwXSAxqHBvc2l0aW9uk8rCLBdZysRjrzvQuKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTQwXSAyqHBvc2l0aW9uk8rCLBdZysRjrzvQwqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rCLBdZysRjrzvQva9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE0MF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNDFdIDGocG9zaXRpb26TysH0p7vKxF+DttC4pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNDFdIDKocG9zaXRpb26TysH0p7vKxF+DttDCpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysH0p7vKxF+DttC9r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTQxXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE0Ml0gMahwb3NpdGlvbpPKxTGaZspDtsn8AKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTQyXSAyqHBvc2l0aW9uk8rFMZpmykO2yfwKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUxmmbKQ7bJ/AWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNDJdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTQzXSAxqHBvc2l0aW9uk8rFMFRSykO61eMApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNDNdIDKocG9zaXRpb26TysUwVFLKQ7rV4wqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxTBUUspDutXjBa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE0M10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNDRdIDGocG9zaXRpb26TysUvnZrKQ7IjMwCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE0NF0gMqhwb3NpdGlvbpPKxS+dmspDsiMzCqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFL52aykOyIzMFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTQ0XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE0NV0gMahwb3NpdGlvbpPKxErSHcrD26vn9aR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTQ1XSAyqHBvc2l0aW9uk8rEStIdysPbq+f/pHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysRK0h3Kw9ur5/qvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNDVdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTQ2XSAxqHBvc2l0aW9uk8rET8NkysPga0T1pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNDZdIDKocG9zaXRpb26TysRPw2TKw+BrRP+kdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxE/DZMrD4GtE+q9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE0Nl0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNDddIDGocG9zaXRpb26TysRS6h3Kw9gj+PWkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE0N10gMqhwb3NpdGlvbpPKxFLqHcrD2CP4/6R0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEUuodysPYI/j6r2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTQ3XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE0OF0gMahwb3NpdGlvbpPKxCcZ/MpD0OCk/6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTQ4XSAyqHBvc2l0aW9uk8rEJxn8ykPQ4KQJpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysQnGfzKQ9DgpASvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNDhdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTQ5XSAxqHBvc2l0aW9uk8rEIaAQykPQVT//pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNDldIDKocG9zaXRpb26TysQhoBDKQ9BVPwmkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxCGgEMpD0FU/BK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE0OV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNTBdIDGocG9zaXRpb26TysQg1LzKQ8YM7v+kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE1MF0gMqhwb3NpdGlvbpPKxCDUvMpDxgzuCaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEINS8ykPGDO4Er2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTUwXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE1MV0gMahwb3NpdGlvbpPKxCigAMpEN92iEKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTUxXSAyqHBvc2l0aW9uk8rEKKAAykQ33aIapHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysQooADKRDfdohWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNTFdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTUyXSAxqHBvc2l0aW9uk8rELEhzykQzyAAQpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNTJdIDKocG9zaXRpb26TysQsSHPKRDPIABqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxCxIc8pEM8gAFa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE1Ml0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNTNdIDGocG9zaXRpb26TysQwxzvKRDZmRhCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE1M10gMqhwb3NpdGlvbpPKxDDHO8pENmZGGqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEMMc7ykQ2ZkYVr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTUzXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE1NF0gMahwb3NpdGlvbpPKxAgfvspEOMxKEKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTU0XSAyqHBvc2l0aW9uk8rECB++ykQ4zEoapHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysQIH77KRDjMShWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNTRdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTU1XSAxqHBvc2l0aW9uk8rEArLyykQ4AIMQpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNTVdIDKocG9zaXRpb26TysQCsvLKRDgAgxqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxAKy8spEOACDFa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE1NV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNTZdIDGocG9zaXRpb26TysQCZrjKRDLO6RCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE1Nl0gMqhwb3NpdGlvbpPKxAJmuMpEMs7pGqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEAma4ykQyzukVr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTU2XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE1N10gMahwb3NpdGlvbpPKxDTC4cpCbhRGAKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTU3XSAyqHBvc2l0aW9uk8rENMLhykJuFEYKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysQ0wuHKQm4URgWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNTddIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTU4XSAxqHBvc2l0aW9uk8rEL0ffykJwm9oApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNThdIDKocG9zaXRpb26TysQvR9/KQnCb2gqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxC9H38pCcJvaBa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE1OF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNTldIDGocG9zaXRpb26TysQuFePKQh+ZzgCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE1OV0gMqhwb3NpdGlvbpPKxC4V48pCH5nOCqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rELhXjykIfmc4Fr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTU5XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE2MF0gMahwb3NpdGlvbpPKxAX19MpDnFcK/6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTYwXSAyqHBvc2l0aW9uk8rEBfX0ykOcVwoJpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysQF9fTKQ5xXCgSvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNjBdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTYxXSAxqHBvc2l0aW9uk8rEAILhykObIKT/pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNjFdIDKocG9zaXRpb26TysQAguHKQ5sgpAmkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxACC4cpDmyCkBK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE2MV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNjJdIDGocG9zaXRpb26TysQACFLKQ5DEe/+kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE2Ml0gMqhwb3NpdGlvbpPKxAAIUspDkMR7CaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEAAhSykOQxHsEr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTYyXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE2M10gMahwb3NpdGlvbpPKxGwaoMq/iE39zICkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE2M10gMqhwb3NpdGlvbpPKxGwaoMq/iE39zIqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxGwaoMq/iE39zIWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNjNdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTY0XSAxqHBvc2l0aW9uk8rEcYkXyj/2/sXMgKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTY0XSAyqHBvc2l0aW9uk8rEcYkXyj/2/sXMiqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEcYkXyj/2/sXMha9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE2NF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNjVdIDGocG9zaXRpb26TysRx4PbKQbWLRMyApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNjVdIDKocG9zaXRpb26TysRx4PbKQbWLRMyKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysRx4PbKQbWLRMyFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTY1XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE2Nl0gMahwb3NpdGlvbpPKxE+jdcpC3IYlzICkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE2Nl0gMqhwb3NpdGlvbpPKxE+jdcpC3IYlzIqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxE+jdcpC3IYlzIWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNjZdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTY3XSAxqHBvc2l0aW9uk8rEUjMjykK1vaXMgKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTY3XSAyqHBvc2l0aW9uk8rEUjMjykK1vaXMiqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEUjMjykK1vaXMha9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE2N10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNjhdIDGocG9zaXRpb26TysRXMdvKQsFdIsyApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNjhdIDKocG9zaXRpb26TysRXMdvKQsFdIsyKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysRXMdvKQsFdIsyFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTY4XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE2OV0gMahwb3NpdGlvbpPKxIAQAMpD1piTAKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTY5XSAyqHBvc2l0aW9uk8rEgBAAykPWmJMKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysSAEADKQ9aYkwWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNjldIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTcwXSAxqHBvc2l0aW9uk8rEerMzykPVAQYApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNzBdIDKocG9zaXRpb26TysR6szPKQ9UBBgqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxHqzM8pD1QEGBa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE3MF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNzFdIDGocG9zaXRpb26TysR6ZmbKQ8qd0wCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE3MV0gMqhwb3NpdGlvbpPKxHpmZspDyp3TCqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEemZmykPKndMFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTcxXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE3Ml0gMahwb3NpdGlvbpPKxIhwpMrD7wXD4KR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTcyXSAyqHBvc2l0aW9uk8rEiHCkysPvBcPqpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysSIcKTKw+8Fw+WvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNzJdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTczXSAxqHBvc2l0aW9uk8rEiITNysPkD77gpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNzNdIDKocG9zaXRpb26TysSIhM3Kw+QPvuqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxIiEzcrD5A++5a9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE3M10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNzRdIDGocG9zaXRpb26TysSF/M3Kw+Grx+CkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE3NF0gMqhwb3NpdGlvbpPKxIX8zcrD4avH6qR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEhfzNysPhq8flr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTc0XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE3NV0gMahwb3NpdGlvbpPKxIEWFMrEEoNk4KR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTc1XSAyqHBvc2l0aW9uk8rEgRYUysQSg2TqpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysSBFhTKxBKDZOWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNzVdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTc2XSAxqHBvc2l0aW9uk8rEfLuFysQR1JzgpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNzZdIDKocG9zaXRpb26TysR8u4XKxBHUnOqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxHy7hcrEEdSc5a9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE3Nl0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxNzddIDGocG9zaXRpb26TysR7DrjKxBbBeeCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE3N10gMqhwb3NpdGlvbpPKxHsOuMrEFsF56qR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEew64ysQWwXnlr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTc3XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE3OF0gMahwb3NpdGlvbpPKxCWYYsrEPPkn4KR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTc4XSAyqHBvc2l0aW9uk8rEJZhiysQ8+SfqpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysQlmGLKxDz5J+WvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxNzhdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTc5XSAxqHBvc2l0aW9uk8rEJHzdysRCV8/gpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxNzldIDKocG9zaXRpb26TysQkfN3KxEJXz+qkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxCR83crEQlfP5a9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE3OV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxODBdIDGocG9zaXRpb26TysQpRCnKxERmNeCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE4MF0gMqhwb3NpdGlvbpPKxClEKcrERGY16qR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEKUQpysREZjXlr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTgwXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE4MV0gMahwb3NpdGlvbpPKxCHbpsrEGBys4KR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTgxXSAyqHBvc2l0aW9uk8rEIdumysQYHKzqpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysQh26bKxBgcrOWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxODFdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTgyXSAxqHBvc2l0aW9uk8rEHr2RysQcn0zgpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxODJdIDKocG9zaXRpb26TysQevZHKxByfTOqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxB69kcrEHJ9M5a9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE4Ml0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxODNdIDGocG9zaXRpb26TysQiVfTKxCBh2+CkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE4M10gMqhwb3NpdGlvbpPKxCJV9MrEIGHb6qR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEIlX0ysQgYdvlr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTgzXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE4NF0gMahwb3NpdGlvbpPKxRfpSMpDxcao0f8QpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxODRdIDKocG9zaXRpb26TysUX6UjKQ8XGqNH/GqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFF+lIykPFxqjR/xWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxODRdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTg1XSAxqHBvc2l0aW9uk8rFGDpmykO7G0TR/xCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE4NV0gMqhwb3NpdGlvbpPKxRg6ZspDuxtE0f8apHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUYOmbKQ7sbRNH/Fa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE4NV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxODZdIDGocG9zaXRpb26TysUZhzPKQ7trI9H/EKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTg2XSAyqHBvc2l0aW9uk8rFGYczykO7ayPR/xqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxRmHM8pDu2sj0f8Vr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTg2XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE4N10gMahwb3NpdGlvbpPKxQKIzcpCmv0I0f8QpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxODddIDKocG9zaXRpb26TysUCiM3KQpr9CNH/GqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFAojNykKa/QjR/xWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxODddIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTg4XSAxqHBvc2l0aW9uk8rFAhpmykLEnzvR/xCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE4OF0gMqhwb3NpdGlvbpPKxQIaZspCxJ870f8apHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUCGmbKQsSfO9H/Fa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE4OF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxODldIDGocG9zaXRpb26TysUAz67KQr/A+dH/EKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTg5XSAyqHBvc2l0aW9uk8rFAM+uykK/wPnR/xqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxQDPrspCv8D50f8Vr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTg5XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE5MF0gMahwb3NpdGlvbpPKxQ4UKcpD3xl50f8QpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxOTBdIDKocG9zaXRpb26TysUOFCnKQ98ZedH/GqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFDhQpykPfGXnR/xWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxOTBdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTkxXSAxqHBvc2l0aW9uk8rFD2/XykPdo5bR/xCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE5MV0gMqhwb3NpdGlvbpPKxQ9v18pD3aOW0f8apHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUPb9fKQ92jltH/Fa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE5MV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxOTJdIDGocG9zaXRpb26TysUP3cPKQ+d1otH/EKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTkyXSAyqHBvc2l0aW9uk8rFD93DykPndaLR/xqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxQ/dw8pD53Wi0f8Vr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTkyXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE5M10gMahwb3NpdGlvbpPKxRpHCspCJYpY0f8QpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxOTNdIDKocG9zaXRpb26TysUaRwrKQiWKWNH/GqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFGkcKykIliljR/xWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxOTNdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTk0XSAxqHBvc2l0aW9uk8rFGduFykJ5C6zR/xCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzE5NF0gMqhwb3NpdGlvbpPKxRnbhcpCeQus0f8apHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUZ24XKQnkLrNH/Fa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE5NF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxOTVdIDGocG9zaXRpb26TysUYkKTKQnAH49H/EKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTk1XSAyqHBvc2l0aW9uk8rFGJCkykJwB+PR/xqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxRiQpMpCcAfj0f8Vr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTk1XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE5Nl0gMahwb3NpdGlvbpPKxRWyZspCh8PK0f8QpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxOTZdIDKocG9zaXRpb26TysUVsmbKQofDytH/GqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFFbJmykKHw8rR/xWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxOTZdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMTk3XSAxqHBvc2l0aW9uk9H2uspCeE920f8QpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1sxOTddIDKocG9zaXRpb26T0fa6ykJ4T3bR/xqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPR9rrKQnhPdtH/Fa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzE5N10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1sxOThdIDGocG9zaXRpb26TysUUdZrKQiVAT9H/EKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTk4XSAyqHBvc2l0aW9uk8rFFHWaykIlQE/R/xqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxRR1mspCJUBP0f8Vr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMTk4XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzE5OV0gMahwb3NpdGlvbpPKxKX8zcpD9R5WAKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMTk5XSAyqHBvc2l0aW9uk8rEpfzNykP1HlYKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysSl/M3KQ/UeVgWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1sxOTldIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjAwXSAxqHBvc2l0aW9uk8rEpdZmykPqK0QApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMDBdIDKocG9zaXRpb26TysSl1mbKQ+orRAqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxKXWZspD6itEBa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIwMF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMDFdIDGocG9zaXRpb26TysSoWj3KQ+eDtgCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIwMV0gMqhwb3NpdGlvbpPKxKhaPcpD54O2CqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEqFo9ykPng7YFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjAxXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzIwMl0gMahwb3NpdGlvbpPKxJd2uMpED2R7K6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMjAyXSAyqHBvc2l0aW9uk8rEl3a4ykQPZHs1pHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysSXdrjKRA9kezCvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1syMDJdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjAzXSAxqHBvc2l0aW9uk8rElQwpykQR+sErpHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMDNdIDKocG9zaXRpb26TysSVDCnKRBH6wTWkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxJUMKcpEEfrBMK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIwM10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMDRdIDGocG9zaXRpb26TysSTYezKRA37VCukdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIwNF0gMqhwb3NpdGlvbpPKxJNh7MpEDftUNaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEk2HsykQN+1Qwr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjA0XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzIwNV0gMahwb3NpdGlvbpPKxJBnrspDrmm6/6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMjA1XSAyqHBvc2l0aW9uk8rEkGeuykOuaboJpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysSQZ67KQ65pugSvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1syMDVdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjA2XSAxqHBvc2l0aW9uk8rEkIgAykO5XfT/pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMDZdIDKocG9zaXRpb26TysSQiADKQ7ld9AmkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxJCIAMpDuV30BK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIwNl0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMDddIDGocG9zaXRpb26TysSOAuHKQ7vvG/+kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIwN10gMqhwb3NpdGlvbpPKxI4C4cpDu+8bCaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEjgLhykO77xsEr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjA3XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzIwOF0gMahwb3NpdGlvbpPKxKK6j8pFJBY9zQFApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMDhdIDKocG9zaXRpb26TysSiuo/KRSQWPc0BSqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEorqPykUkFj3NAUWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1syMDhdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjA5XSAxqHBvc2l0aW9uk8rEpL0fykUlBM3NAUCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIwOV0gMqhwb3NpdGlvbpPKxKS9H8pFJQTNzQFKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysSkvR/KRSUEzc0BRa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIwOV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMTBdIDGocG9zaXRpb26TysSjY9fKRSYhms0BQKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMjEwXSAyqHBvc2l0aW9uk8rEo2PXykUmIZrNAUqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxKNj18pFJiGazQFFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjEwXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzIxMV0gMahwb3NpdGlvbpPKxJKpmspFGfykzQFApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMTFdIDKocG9zaXRpb26TysSSqZrKRRn8pM0BSqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEkqmaykUZ/KTNAUWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1syMTFdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjEyXSAxqHBvc2l0aW9uk8rElWdcykUaAcPNAUCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIxMl0gMqhwb3NpdGlvbpPKxJVnXMpFGgHDzQFKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysSVZ1zKRRoBw80BRa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIxMl0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMTNdIDGocG9zaXRpb26TysSV49fKRRtIzc0BQKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMjEzXSAyqHBvc2l0aW9uk8rElePXykUbSM3NAUqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxJXj18pFG0jNzQFFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjEzXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzIxNF0gMahwb3NpdGlvbpPKxIsy4cpFKvrhzQFApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMTRdIDKocG9zaXRpb26TysSLMuHKRSr64c0BSqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEizLhykUq+uHNAUWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1syMTRdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjE1XSAxqHBvc2l0aW9uk8rEjehSykUrMPbNAUCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIxNV0gMqhwb3NpdGlvbpPKxI3oUspFKzD2zQFKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysSN6FLKRSsw9s0BRa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIxNV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMTZdIDGocG9zaXRpb26TysSOCKTKRSx9cc0BQKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMjE2XSAyqHBvc2l0aW9uk8rEjgikykUsfXHNAUqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxI4IpMpFLH1xzQFFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjE2XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzIxN10gMahwb3NpdGlvbpPKxMX3CspDvqWi/6R0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMjE3XSAyqHBvc2l0aW9uk8rExfcKykO+paIJpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTF9wrKQ76logSvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1syMTddIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjE4XSAxqHBvc2l0aW9uk8rEw2uFykO6kOX/pHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMThdIDKocG9zaXRpb26TysTDa4XKQ7qQ5QmkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxMNrhcpDupDlBK9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIxOF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMTldIDGocG9zaXRpb26TysTD4ZrKQ7BTtv+kdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIxOV0gMqhwb3NpdGlvbpPKxMPhmspDsFO2CaR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rEw+GaykOwU7YEr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjE5XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzIyMF0gMahwb3NpdGlvbpPKxTAYKcpEAWOWAKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMjIwXSAyqHBvc2l0aW9uk8rFMBgpykQBY5YKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUwGCnKRAFjlgWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1syMjBdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjIxXSAxqHBvc2l0aW9uk8rFMCOFykP30WgApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMjFdIDKocG9zaXRpb26TysUwI4XKQ/fRaAqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxTAjhcpD99FoBa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIyMV0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMjJdIDGocG9zaXRpb26TysUxa67KQ/YMzQCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIyMl0gMqhwb3NpdGlvbpPKxTFrrspD9gzNCqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFMWuuykP2DM0Fr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjIyXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzIyM10gMahwb3NpdGlvbpPKxSbPXMpELIAxAKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMjIzXSAyqHBvc2l0aW9uk8rFJs9cykQsgDEKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysUmz1zKRCyAMQWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1syMjNdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjI0XSAxqHBvc2l0aW9uk8rFKCD2ykQt/30ApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMjRdIDKocG9zaXRpb26TysUoIPbKRC3/fQqkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxSgg9spELf99Ba9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIyNF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMjVdIDGocG9zaXRpb26TysUoCHvKRDMvrgCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIyNV0gMqhwb3NpdGlvbpPKxSgIe8pEMy+uCqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rFKAh7ykQzL64Fr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjI1XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzIyNl0gMahwb3NpdGlvbpPKxK53CspESlLRQKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMjI2XSAyqHBvc2l0aW9uk8rErncKykRKUtFKpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysSudwrKREpS0UWvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1syMjZdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjI3XSAxqHBvc2l0aW9uk8rEq+uFykRISINApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMjddIDKocG9zaXRpb26TysSr64XKREhIg0qkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxKvrhcpESEiDRa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIyN10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMjhdIDGocG9zaXRpb26TysSsYZrKREMp20CkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIyOF0gMqhwb3NpdGlvbpPKxKxhmspEQynbSqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rErGGaykRDKdtFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjI4XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzIyOV0gMahwb3NpdGlvbpPKxMG49spESrUfQKR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMjI5XSAyqHBvc2l0aW9uk8rEwbj2ykRKtR9KpHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26TysTBuPbKREq1H0WvaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1syMjldIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjMwXSAxqHBvc2l0aW9uk8rEwoQpykRFdcNApHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMzBdIDKocG9zaXRpb26TysTChCnKREV1w0qkdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPKxMKEKcpERXXDRa9oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIzMF0gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMzFdIDGocG9zaXRpb26TysTFG4XKREXu2UCkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIzMV0gMqhwb3NpdGlvbpPKxMUbhcpERe7ZSqR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk8rExRuFykRF7tlFr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjMxXSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWEqm1vZGVsX25hbWXZNW1vZGVscy9wcm9wcy9nZ190aWJldC9jYW5kbGVzdGlja3dpZGVzaG9ydG9ucGxhdGUubWRspG5hbWWnWzIzMl0gMahwb3NpdGlvbpPR/UHR/sripHR5cGWlTW9kZWyEqm1vZGVsX25hbWW2bW9uYXN0ZXJ5X2NhbmRsZV9mbGFtZaRuYW1lp1syMzJdIDKocG9zaXRpb26T0f1B0f7K7KR0eXBlqFBhcnRpY2xliKVjb2xvcpTM/8yCAMz/qm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDIudm10qHBvc2l0aW9uk9H9QdH+yuevaGRyX2NvbG9yX3NjYWxlyz/pmZmZmZmaq3JlbmRlcl9tb2RlCaRuYW1lp1syMzJdIDOlc2NhbGXKPwAAAKR0eXBlplNwcml0ZYSqbW9kZWxfbmFtZdk1bW9kZWxzL3Byb3BzL2dnX3RpYmV0L2NhbmRsZXN0aWNrd2lkZXNob3J0b25wbGF0ZS5tZGykbmFtZadbMjMzXSAxqHBvc2l0aW9uk9H9UNH+u+KkdHlwZaVNb2RlbISqbW9kZWxfbmFtZbZtb25hc3RlcnlfY2FuZGxlX2ZsYW1lpG5hbWWnWzIzM10gMqhwb3NpdGlvbpPR/VDR/rvspHR5cGWoUGFydGljbGWIpWNvbG9ylMz/zIIAzP+qbW9kZWxfbmFtZbhzcHJpdGVzL2xpZ2h0X2dsb3cwMi52bXSocG9zaXRpb26T0f1Q0f67569oZHJfY29sb3Jfc2NhbGXLP+mZmZmZmZqrcmVuZGVyX21vZGUJpG5hbWWnWzIzM10gM6VzY2FsZco/AAAApHR5cGWmU3ByaXRlhKptb2RlbF9uYW1l2TVtb2RlbHMvcHJvcHMvZ2dfdGliZXQvY2FuZGxlc3RpY2t3aWRlc2hvcnRvbnBsYXRlLm1kbKRuYW1lp1syMzRdIDGocG9zaXRpb26T0f1T0f7s4qR0eXBlpU1vZGVshKptb2RlbF9uYW1ltm1vbmFzdGVyeV9jYW5kbGVfZmxhbWWkbmFtZadbMjM0XSAyqHBvc2l0aW9uk9H9U9H+7OykdHlwZahQYXJ0aWNsZYilY29sb3KUzP/MggDM/6ptb2RlbF9uYW1luHNwcml0ZXMvbGlnaHRfZ2xvdzAyLnZtdKhwb3NpdGlvbpPR/VPR/uznr2hkcl9jb2xvcl9zY2FsZcs/6ZmZmZmZmqtyZW5kZXJfbW9kZQmkbmFtZadbMjM0XSAzpXNjYWxlyj8AAACkdHlwZaZTcHJpdGWKqm1vZGVsX25hbWW4c3ByaXRlcy9saWdodF9nbG93MDMudm10qHBvc2l0aW9u2Thtb2RlbHMvcHJvcHMvZGVfaW5mZXJuby9ocl9pL29ybmF0ZV9sYW1wL29ybmF0ZV9sYW1wLm1kbKtyZW5kZXJfbW9kZQmvaGRyX2NvbG9yX3NjYWxlyz/szMzMzMzNpXNjYWxlyz/pmZmZmZmarWFuZ2xlc19vZmZzZXQKsWN1c3RvbV95YXdfb2Zmc2V0WqRuYW1lpGdsb3elY29sb3KUzP/M4czSzP+kdHlwZaZTcHJpdGU="
    };
    for v295, v296 in l_pairs_0(v167) do
        v191 = v165[v295];
        if v191 == nil then
            v191 = {};
            v165[v295] = v191;
        end;
        v192 = l_base64_0.decode(v296);
        v192 = msgpack.unpack(v192);
        v193 = v191[v166];
        v194 = true;
        if v193 ~= nil then
            v194 = v193.enabled;
        end;
        v191[v166] = {
            name = "Default", 
            points = v192, 
            enabled = v194
        };
    end;
    v166 = nil;
    v167 = nil;
    v186 = nil;
    v187 = false;
    v188 = nil;
    do
        local l_v165_2, l_v166_1, l_v167_2, l_v186_0, l_v187_1, l_v188_0, l_v189_1, l_v190_0, l_v191_1, l_v192_0, l_v193_1, l_v194_1 = v165, v166, v167, v186, v187, v188, v189, v190, v191, v192, v193, v194;
        l_v188_0 = function()
            -- upvalues: v164 (ref), l_v165_2 (ref), l_ipairs_0 (ref), l_v167_2 (ref), l_v186_0 (ref)
            if v164 == nil then
                return {};
            else
                local v309 = l_v165_2[v164];
                if v309 == nil then
                    return {};
                else
                    local v310 = {};
                    for v311, v312 in l_ipairs_0(v309) do
                        local l_enabled_0 = v312.enabled;
                        if l_enabled_0 == nil then
                            l_enabled_0 = true;
                        end;
                        if l_enabled_0 then
                            local l_points_0 = v312.points;
                            for v315, v316 in l_ipairs_0(l_points_0) do
                                if v311 == l_v167_2 then
                                    if v315 ~= l_v186_0 then
                                        v310[#v310 + 1] = v316;
                                    end;
                                else
                                    v310[#v310 + 1] = v316;
                                end;
                            end;
                        end;
                    end;
                    return v310;
                end;
            end;
        end;
        l_v189_1 = nil;
        l_v190_0 = function(v317)
            -- upvalues: l_ipairs_0 (ref), l_type_0 (ref)
            local v318 = {};
            local v319 = {};
            for _, v321 in l_ipairs_0(v317) do
                local l_position_2 = v321.position;
                if l_type_0(l_position_2) == "string" then
                    local v323 = v318[l_position_2];
                    if v323 == nil then
                        v323 = {};
                        v318[l_position_2] = v323;
                    end;
                    v323[#v323 + 1] = v321;
                else
                    v319[#v319 + 1] = v321;
                end;
            end;
            return v318, v319;
        end;
        do
            local l_l_v190_0_0 = l_v190_0;
            l_v189_1 = function()
                -- upvalues: v85 (ref), v161 (ref), l_v188_0 (ref), l_v166_1 (ref), l_l_v190_0_0 (ref), l_ipairs_0 (ref), v163 (ref), v84 (ref), v86 (ref), l_format_0 (ref), v87 (ref), v88 (ref)
                v85();
                v161();
                local v325 = l_v188_0();
                if l_v166_1 ~= nil then
                    v325[#v325 + 1] = l_v166_1;
                end;
                local v326, v327 = l_l_v190_0_0(v325);
                for _, v329 in l_ipairs_0(v163) do
                    local v330 = v326[v329.model_name];
                    if v330 ~= nil then
                        local l_position_3 = v329.position;
                        local l_angles_0 = v329.angles;
                        for _, v334 in l_ipairs_0(v330) do
                            local l_type_1 = v334.type;
                            local l_model_name_2 = v334.model_name;
                            local l_l_position_3_0 = l_position_3;
                            local l_angles_offset_0 = v334.angles_offset;
                            if l_angles_offset_0 ~= nil then
                                local v339 = v334.custom_yaw_offset or 0;
                                local v340 = math.rad(math.abs(l_angles_0.y + v339));
                                local v341 = math.cos(v340);
                                local v342 = math.sin(v340);
                                l_l_position_3_0 = l_l_position_3_0 + vector(v341 * l_angles_offset_0, v342 * l_angles_offset_0, 0);
                            end;
                            local l_position_z_offset_0 = v334.position_z_offset;
                            if l_position_z_offset_0 ~= nil then
                                l_l_position_3_0 = l_l_position_3_0 + vector(0, 0, l_position_z_offset_0);
                            end;
                            if l_type_1 == "Particle" then
                                v84(l_model_name_2, l_l_position_3_0);
                            end;
                            if l_type_1 == "Model" then
                                local l_scale_0 = v334.scale;
                                local v345 = {
                                    position = l_l_position_3_0, 
                                    model_name = l_model_name_2, 
                                    model_scale = l_scale_0
                                };
                                if v334.set_angles then
                                    local v346 = v334.set_angles_x_offset or 0;
                                    local v347 = v334.set_angles_y_offset or 0;
                                    local v348 = v334.set_angles_z_offset or 0;
                                    l_angles_0 = l_angles_0 + vector(v346, v347, v348);
                                    v345.abs_angles = l_angles_0;
                                end;
                                v345.color = v334.color;
                                v86(v345);
                            end;
                            if l_type_1 == "Sprite" then
                                local l_scale_1 = v334.scale;
                                local l_hdr_color_scale_0 = v334.hdr_color_scale;
                                local l_render_mode_0 = v334.render_mode;
                                local l_color_1 = v334.color;
                                local v353 = {
                                    GlowProxySize = 10, 
                                    framerate = 10, 
                                    position = l_l_position_3_0, 
                                    model = l_model_name_2, 
                                    scale = l_scale_1, 
                                    HDRColorScale = l_hdr_color_scale_0, 
                                    rendermode = l_render_mode_0, 
                                    rendercolor = l_format_0("%s %s %s %s", l_color_1[1], l_color_1[2], l_color_1[3], l_color_1[4])
                                };
                                v87(v353);
                            end;
                            if l_type_1 == "Beam" then
                                local l_end_position_offset_0 = v334.end_position_offset;
                                local l_start_width_0 = v334.start_width;
                                local l_end_width_0 = v334.end_width;
                                local l_color_2 = v334.color;
                                local v358 = {
                                    segments = 2, 
                                    life = 0, 
                                    model_index = -1, 
                                    start_position = l_l_position_3_0, 
                                    end_position = l_l_position_3_0 + vector(0, 0, l_end_position_offset_0), 
                                    model_name = l_model_name_2, 
                                    start_width = l_start_width_0, 
                                    end_width = l_end_width_0, 
                                    red = l_color_2[1], 
                                    green = l_color_2[2], 
                                    blue = l_color_2[3], 
                                    brightness = l_color_2[4], 
                                    flags = bit.bor(128, 256, 512)
                                };
                                v88(v358);
                            end;
                        end;
                    end;
                end;
                for _, v360 in l_ipairs_0(v327) do
                    local l_type_2 = v360.type;
                    local l_model_name_3 = v360.model_name;
                    local l_position_4 = v360.position;
                    l_position_4 = vector(l_position_4[1], l_position_4[2], l_position_4[3]);
                    local l_position_z_offset_1 = v360.position_z_offset;
                    if l_position_z_offset_1 ~= nil then
                        l_position_4 = l_position_4 + vector(0, 0, l_position_z_offset_1);
                    end;
                    if l_type_2 == "Particle" then
                        v84(l_model_name_3, l_position_4);
                    end;
                    if l_type_2 == "Model" then
                        local l_scale_2 = v360.scale;
                        local v366 = {
                            position = l_position_4, 
                            model_name = l_model_name_3, 
                            model_scale = l_scale_2
                        };
                        if v360.set_angles then
                            local v367 = v360.set_angles_x_offset or 0;
                            local v368 = v360.set_angles_y_offset or 0;
                            local v369 = v360.set_angles_z_offset or 0;
                            v366.abs_angles = vector(v367, v368, v369);
                        end;
                        v366.color = v360.color;
                        v86(v366);
                    end;
                    if l_type_2 == "Sprite" then
                        local l_scale_3 = v360.scale;
                        local l_hdr_color_scale_1 = v360.hdr_color_scale;
                        local l_render_mode_1 = v360.render_mode;
                        local l_color_3 = v360.color;
                        local v374 = {
                            GlowProxySize = 10, 
                            framerate = 10, 
                            position = l_position_4, 
                            model = l_model_name_3, 
                            scale = l_scale_3, 
                            HDRColorScale = l_hdr_color_scale_1, 
                            rendermode = l_render_mode_1, 
                            rendercolor = l_format_0("%s %s %s %s", l_color_3[1], l_color_3[2], l_color_3[3], l_color_3[4])
                        };
                        v87(v374);
                    end;
                    if l_type_2 == "Beam" then
                        local l_end_position_offset_1 = v360.end_position_offset;
                        local l_start_width_1 = v360.start_width;
                        local l_end_width_1 = v360.end_width;
                        local l_color_4 = v360.color;
                        local v379 = {
                            segments = 2, 
                            life = 0, 
                            model_index = -1, 
                            start_position = l_position_4, 
                            end_position = l_position_4 + vector(0, 0, l_end_position_offset_1), 
                            model_name = l_model_name_3, 
                            start_width = l_start_width_1, 
                            end_width = l_end_width_1, 
                            red = l_color_4[1], 
                            green = l_color_4[2], 
                            blue = l_color_4[3], 
                            brightness = l_color_4[4], 
                            flags = bit.bor(128, 256, 512)
                        };
                        v88(v379);
                    end;
                end;
            end;
            l_v189_1();
            events.round_start(l_v189_1);
            events.level_init(l_v189_1);
        end;
        l_v190_0 = nil;
        l_v191_1 = "\a{Link Active}\239\131\190\aDEFAULT   ";
        l_v192_0 = "\a{Link Active}\239\133\134\aDEFAULT   ";
        do
            local l_l_v191_1_0, l_l_v192_0_0 = l_v191_1, l_v192_0;
            l_v190_0 = function(v382)
                -- upvalues: l_ipairs_0 (ref), l_l_v191_1_0 (ref), l_l_v192_0_0 (ref), v81 (ref), l_execute_after_0 (ref)
                local v383 = {};
                for _, v385 in l_ipairs_0(v382) do
                    local l_enabled_1 = v385.enabled;
                    if l_enabled_1 == nil then
                        l_enabled_1 = true;
                    end;
                    v383[#v383 + 1] = (l_enabled_1 and l_l_v191_1_0 or l_l_v192_0_0) .. v385.name;
                end;
                v383[#v383 + 1] = "+ Create New";
                v81.presets:update(v383);
                l_execute_after_0(0.01, v81.presets.set, v81.presets, 1);
            end;
        end;
        l_v191_1 = nil;
        l_v191_1 = function()
            -- upvalues: v164 (ref), l_v165_2 (ref), l_v190_0 (ref), v81 (ref)
            if v164 == nil then
                return;
            else
                local v387 = l_v165_2[v164];
                if v387 == nil then
                    v387 = {
                        [1] = {
                            name = "Default ~ Soon", 
                            enabled = true, 
                            points = {}
                        }
                    };
                    l_v165_2[v164] = v387;
                end;
                l_v190_0(v387);
                v81.current_map_name:name("Settings for: " .. v164);
                return;
            end;
        end;
        l_v191_1();
        v83(l_v191_1);
        events.level_init(l_v191_1);
        v81.enabled:set_callback(function(v388)
            -- upvalues: v164 (ref), v81 (ref), l_v165_2 (ref), l_v191_1 (ref), l_v189_1 (ref)
            if v164 == nil then
                return;
            else
                local v389 = v81.presets:get();
                local v390 = l_v165_2[v164][v389];
                local v391 = v388:get();
                if v390.enabled == v391 then
                    return;
                else
                    v390.enabled = v391;
                    l_v191_1();
                    l_v189_1();
                    return;
                end;
            end;
        end);
        v81.presets:set_callback(function(v392)
            -- upvalues: v164 (ref), l_v165_2 (ref), v81 (ref)
            if v164 == nil then
                return;
            else
                local v393 = l_v165_2[v164][v392:get()];
                if v393 == nil then
                    return;
                else
                    local l_enabled_2 = v393.enabled;
                    v81.enabled:set(l_enabled_2);
                    return;
                end;
            end;
        end, true);
        v81.create:set_callback(function()
            -- upvalues: v164 (ref), l_v165_2 (ref), v81 (ref), l_v190_0 (ref)
            if v164 == nil then
                return;
            else
                local v395 = l_v165_2[v164];
                if v395 == nil then
                    v395 = {};
                    l_v165_2[v164] = v395;
                end;
                local v396 = v81.name:get();
                v395[#v395 + 1] = {
                    enabled = true, 
                    name = v396, 
                    points = {}
                };
                l_v190_0(v395);
                return;
            end;
        end);
        v81.delete:set_callback(function()
            -- upvalues: v164 (ref), v81 (ref), l_v165_2 (ref), l_remove_0 (ref), l_v191_1 (ref)
            if v164 == nil then
                return;
            else
                local v397 = v81.presets:get();
                local v398 = l_v165_2[v164];
                l_remove_0(v398, v397);
                l_v191_1(v398);
                return;
            end;
        end);
        l_v192_0 = nil;
        l_v192_0 = function()
            -- upvalues: l_v167_2 (ref), v164 (ref), l_v165_2 (ref), l_ipairs_0 (ref), v81 (ref), l_v186_0 (ref)
            if l_v167_2 == nil then
                return;
            elseif v164 == nil then
                return;
            else
                local l_points_1 = l_v165_2[v164][l_v167_2].points;
                local v400 = {};
                for _, v402 in l_ipairs_0(l_points_1) do
                    v400[#v400 + 1] = v402.name;
                end;
                v400[#v400 + 1] = "+ Create New";
                v81.points_list:update(v400);
                v81.points_list:set(l_v186_0 or 1);
                return;
            end;
        end;
        v81.points_list:set_callback(function(v403)
            -- upvalues: l_v186_0 (ref)
            l_v186_0 = v403:get();
        end);
        v81.edit:set_callback(function()
            -- upvalues: l_v167_2 (ref), v81 (ref), l_v192_0 (ref)
            l_v167_2 = v81.presets:get();
            l_v192_0();
        end);
        v81.back:set_callback(function()
            -- upvalues: l_v167_2 (ref), l_v166_1 (ref), l_v187_1 (ref), l_v189_1 (ref)
            l_v167_2 = nil;
            l_v166_1 = nil;
            l_v187_1 = false;
            l_v189_1();
        end);
        v83(function()
            -- upvalues: v81 (ref)
            v81.back:set(1);
        end);
        l_v193_1 = nil;
        l_v193_1 = {};
        l_v194_1 = function(v404, v405)
            return v404.distance < v405.distance;
        end;
        do
            local l_l_v194_1_0 = l_v194_1;
            events.createmove(function()
                -- upvalues: l_v193_1 (ref), v81 (ref), l_get_local_player_0 (ref), l_camera_angles_0 (ref), l_trace_line_0 (ref), l_ipairs_0 (ref), v163 (ref), l_sort_0 (ref), l_l_v194_1_0 (ref), l_match_0 (ref)
                l_v193_1 = {
                    [1] = {}
                };
                if ui.get_alpha() == 0 then
                    return;
                elseif not v81.is_editing then
                    return;
                else
                    local v407 = l_get_local_player_0();
                    if v407 == nil or not v407:is_alive() then
                        return;
                    else
                        local v408 = v407:get_eye_position();
                        local v409 = l_camera_angles_0();
                        local v410 = v408 + vector():angles(v409) * 4096;
                        local l_end_pos_0 = l_trace_line_0(v408, v410, nil, 4294967295).end_pos;
                        local v412 = {
                            [1] = "By Crosshair"
                        };
                        for _, v414 in l_ipairs_0(v163) do
                            v414.distance = l_end_pos_0:dist(v414.position);
                        end;
                        l_sort_0(v163, l_l_v194_1_0);
                        local v415 = {};
                        for _, v417 in l_ipairs_0(v163) do
                            local l_model_name_4 = v417.model_name;
                            if v415[l_model_name_4] == nil then
                                v415[l_model_name_4] = true;
                                l_model_name_4 = l_match_0(l_model_name_4, "([^/]+)%.mdl$");
                                v412[#v412 + 1] = l_model_name_4;
                                l_v193_1[#l_v193_1 + 1] = v417;
                            end;
                        end;
                        v81.static_props:update(v412);
                        return;
                    end;
                end;
            end);
        end;
        l_v194_1 = nil;
        v195 = {
            ["World Glow"] = 9, 
            ["Alpha Additive"] = 8, 
            ["Additive With Frame Blending"] = 7, 
            ["Additive Glow"] = 5, 
            ["Alpha Based Transparency"] = 4, 
            ["Glow Ignore Z"] = 3, 
            ["Transparent Texture Blend"] = 2, 
            ["Transparent Color Blend"] = 1, 
            Normal = 0
        };
        do
            local l_v195_0 = v195;
            l_v194_1 = function(v420)
                -- upvalues: l_v187_1 (ref), l_v166_1 (ref), v81 (ref), l_v195_0 (ref), l_v189_1 (ref)
                l_v187_1 = false;
                if l_v166_1 == nil then
                    return;
                else
                    l_v166_1.name = v81.point_name:get();
                    if v81.is_point_custom_position then
                        local l_position_5 = l_v166_1.position;
                        l_position_5[1] = v81.point_position_x:get();
                        l_position_5[2] = v81.point_position_y:get();
                        l_position_5[3] = v81.point_position_z:get();
                    end;
                    l_v166_1.type = v81.point_type:get();
                    model_name = v81.point_model:get();
                    l_v166_1.model_name = model_name;
                    local v422 = v81.point_angles_offset:get();
                    if v422 ~= 0 then
                        l_v166_1.angles_offset = v422;
                        l_v166_1.custom_yaw_offset = v81.point_custom_yaw_offset:get();
                    else
                        l_v166_1.angles_offset = nil;
                        l_v166_1.custom_yaw_offset = nil;
                    end;
                    local v423 = v81.point_position_z_offset:get();
                    if v423 ~= 0 then
                        l_v166_1.position_z_offset = v423;
                    else
                        l_v166_1.position_z_offset = nil;
                    end;
                    l_v166_1.scale = v81.point_scale:get() * 0.01;
                    if v81.point_set_angles:get() then
                        l_v166_1.set_angles = true;
                        l_v166_1.set_angles_x_offset = v81.point_set_angles_x_offset:get();
                        l_v166_1.set_angles_y_offset = v81.point_set_angles_y_offset:get();
                        l_v166_1.set_angles_z_offset = v81.point_set_angles_z_offset:get();
                    else
                        l_v166_1.set_angles = nil;
                        l_v166_1.set_angles_x_offset = nil;
                        l_v166_1.set_angles_y_offset = nil;
                        l_v166_1.set_angles_z_offset = nil;
                    end;
                    local v424 = v81.point_color:get();
                    l_v166_1.color = {
                        [1] = v424.r, 
                        [2] = v424.g, 
                        [3] = v424.b, 
                        [4] = v424.a
                    };
                    l_v166_1.hdr_color_scale = v81.point_hdr_color_scale:get() * 0.1;
                    l_v166_1.render_mode = l_v195_0[v81.point_render_mode:get()];
                    l_v166_1.end_position_offset = v81.point_end_position_offset:get();
                    l_v166_1.start_width = v81.point_start_width:get();
                    l_v166_1.end_width = v81.point_end_width:get();
                    if v420 == nil or v420:name() ~= "Name" then
                        l_v189_1();
                    end;
                    return;
                end;
            end;
            v81.point_name:set_callback(l_v194_1);
            v81.point_position_x:set_callback(l_v194_1);
            v81.point_position_y:set_callback(l_v194_1);
            v81.point_position_z:set_callback(l_v194_1);
            v81.point_type:set_callback(l_v194_1);
            v81.point_model:set_callback(l_v194_1);
            v81.point_angles_offset:set_callback(l_v194_1);
            v81.point_custom_yaw_offset:set_callback(l_v194_1);
            v81.point_position_z_offset:set_callback(l_v194_1);
            v81.point_scale:set_callback(l_v194_1);
            v81.point_set_angles:set_callback(l_v194_1);
            v81.point_set_angles_x_offset:set_callback(l_v194_1);
            v81.point_set_angles_y_offset:set_callback(l_v194_1);
            v81.point_set_angles_z_offset:set_callback(l_v194_1);
            v81.point_color:set_callback(l_v194_1);
            v81.point_hdr_color_scale:set_callback(l_v194_1);
            v81.point_render_mode:set_callback(l_v194_1);
            v81.point_end_position_offset:set_callback(l_v194_1);
            v81.point_start_width:set_callback(l_v194_1);
            v81.point_end_width:set_callback(l_v194_1);
        end;
        v195 = {
            [0] = "Normal", 
            [1] = "Transparent Color Blend", 
            [2] = "Transparent Texture Blend", 
            [3] = "Glow Ignore Z", 
            [4] = "Alpha Based Transparency", 
            [5] = "Additive Glow", 
            [6] = nil, 
            [7] = "Additive With Frame Blending", 
            [8] = "Alpha Additive", 
            [9] = "World Glow"
        };
        do
            local l_v195_1 = v195;
            v81.points_list:set_callback(function(v426)
                -- upvalues: l_v167_2 (ref), v164 (ref), l_v165_2 (ref), l_v187_1 (ref), l_v166_1 (ref), v162 (ref), v81 (ref), l_type_0 (ref), l_match_0 (ref), l_execute_after_0 (ref), l_v195_1 (ref)
                if l_v167_2 == nil then
                    return;
                elseif v164 == nil then
                    return;
                else
                    local l_points_2 = l_v165_2[v164][l_v167_2].points;
                    local v428 = #v426:list();
                    local v429 = v426:get();
                    l_v187_1 = v429 == v428;
                    local v430 = l_points_2[v429];
                    if v430 == nil then
                        return;
                    else
                        l_v166_1 = v162(v430);
                        v81.point_name:set(l_v166_1.name);
                        local l_position_6 = l_v166_1.position;
                        if l_type_0(l_position_6) ~= "string" then
                            v81.point_position_x:set(l_position_6[1]);
                            v81.point_position_y:set(l_position_6[2]);
                            v81.point_position_z:set(l_position_6[3]);
                            v81.position_label:name("Position: Custom");
                            v81.is_point_custom_position = true;
                        else
                            v81.point_position_x:reset();
                            v81.point_position_y:reset();
                            v81.point_position_z:reset();
                            local l_position_7 = l_v166_1.position;
                            l_position_7 = l_match_0(l_position_7, "([^/]+)%.mdl$");
                            v81.position_label:name("Position: " .. l_position_7);
                            v81.is_point_custom_position = false;
                        end;
                        v81.point_type:set(l_v166_1.type);
                        l_execute_after_0(0.01, v81.point_model.set, v81.point_model, l_v166_1.model_name);
                        v81.point_angles_offset:set(l_v166_1.angles_offset or 0);
                        v81.point_custom_yaw_offset:set(l_v166_1.custom_yaw_offset or 0);
                        v81.point_position_z_offset:set(l_v166_1.position_z_offset or 0);
                        v81.point_scale:set(l_v166_1.scale * 100);
                        v81.point_set_angles:set(l_v166_1.set_angles or false);
                        v81.point_set_angles_x_offset:set(l_v166_1.set_angles_x_offset or 0);
                        v81.point_set_angles_y_offset:set(l_v166_1.set_angles_y_offset or 0);
                        v81.point_set_angles_z_offset:set(l_v166_1.set_angles_z_offset or 0);
                        v81.point_color:set(color(unpack(l_v166_1.color)));
                        v81.point_hdr_color_scale:set(l_v166_1.hdr_color_scale * 10);
                        v81.point_render_mode:set(l_v195_1[l_v166_1.render_mode]);
                        v81.point_end_position_offset:set(l_v166_1.end_position_offset);
                        v81.point_start_width:set(l_v166_1.start_width);
                        v81.point_end_width:set(l_v166_1.end_width);
                        return;
                    end;
                end;
            end);
            v81.set_position:set_callback(function()
                -- upvalues: l_v166_1 (ref), v81 (ref), l_get_local_player_0 (ref), l_camera_angles_0 (ref), l_trace_line_0 (ref), l_v187_1 (ref), l_v193_1 (ref), l_match_0 (ref), l_v194_1 (ref)
                l_v166_1 = {};
                local v433 = v81.static_props:get();
                if v433 == 1 then
                    local v434 = l_get_local_player_0();
                    if v434 == nil or not v434:is_alive() then
                        l_v166_1 = nil;
                        return;
                    else
                        local v435 = v434:get_eye_position();
                        local v436 = l_camera_angles_0();
                        local v437 = v435 + vector():angles(v436) * 4096;
                        local l_end_pos_1 = l_trace_line_0(v435, v437, nil, 4294967295).end_pos;
                        l_v187_1 = false;
                        l_v166_1.position = {
                            [1] = l_end_pos_1.x, 
                            [2] = l_end_pos_1.y, 
                            [3] = l_end_pos_1.z
                        };
                        v81.position_label:name("Position: Custom");
                        v81.point_position_x:set(l_end_pos_1.x);
                        v81.point_position_y:set(l_end_pos_1.y);
                        v81.point_position_z:set(l_end_pos_1.z);
                        v81.is_point_custom_position = true;
                    end;
                else
                    v433 = l_v193_1[v433];
                    if v433 == nil then
                        l_v166_1 = nil;
                        return;
                    else
                        local l_model_name_5 = v433.model_name;
                        l_v187_1 = false;
                        l_v166_1.position = l_model_name_5;
                        l_model_name_5 = l_match_0(l_model_name_5, "([^/]+)%.mdl$");
                        v81.position_label:name("Position: " .. l_model_name_5);
                        v81.point_position_x:reset();
                        v81.point_position_y:reset();
                        v81.point_position_z:reset();
                        v81.is_point_custom_position = false;
                    end;
                end;
                v81.point_name:reset();
                v81.point_type:reset();
                v81.point_model:reset();
                v81.point_angles_offset:reset();
                v81.point_custom_yaw_offset:reset();
                v81.point_position_z_offset:reset();
                v81.point_scale:reset();
                v81.point_set_angles:reset();
                v81.point_set_angles_x_offset:reset();
                v81.point_set_angles_y_offset:reset();
                v81.point_set_angles_z_offset:reset();
                v81.point_color:reset();
                v81.point_hdr_color_scale:reset();
                v81.point_render_mode:reset();
                v81.point_end_position_offset:reset();
                v81.point_start_width:reset();
                v81.point_end_width:reset();
                l_v194_1();
            end);
        end;
        v81.point_save:set_callback(function()
            -- upvalues: l_v167_2 (ref), l_v186_0 (ref), v164 (ref), l_v165_2 (ref), v162 (ref), l_v166_1 (ref), l_v192_0 (ref)
            if l_v167_2 == nil or l_v186_0 == nil then
                return;
            elseif v164 == nil then
                return;
            else
                l_v165_2[v164][l_v167_2].points[l_v186_0] = v162(l_v166_1);
                l_v192_0();
                db["World Editor"] = l_v165_2;
                return;
            end;
        end);
        v81.point_delete:set_callback(function()
            -- upvalues: l_v167_2 (ref), l_v186_0 (ref), v164 (ref), l_v165_2 (ref), l_remove_0 (ref), l_v192_0 (ref)
            if l_v167_2 == nil or l_v186_0 == nil then
                return;
            elseif v164 == nil then
                return;
            else
                local l_points_3 = l_v165_2[v164][l_v167_2].points;
                l_remove_0(l_points_3, l_v186_0);
                l_v192_0();
                db["World Editor"] = l_v165_2;
                return;
            end;
        end);
        events.render(function()
            -- upvalues: l_v187_1 (ref), v81 (ref), l_v193_1 (ref), l_ipairs_0 (ref), v163 (ref), l_world_to_screen_0 (ref), l_circle_0 (ref)
            if not l_v187_1 then
                return;
            else
                local v441 = l_v193_1[v81.static_props:get()];
                if v441 == nil then
                    return;
                else
                    local l_model_name_6 = v441.model_name;
                    for _, v444 in l_ipairs_0(v163) do
                        if v444.model_name == l_model_name_6 then
                            local l_position_8 = v444.position;
                            local v446 = l_world_to_screen_0(l_position_8);
                            if v446 ~= nil then
                                l_circle_0(v446, color(255, 255, 255, 255), 5, 0, 1);
                            end;
                        end;
                    end;
                    return;
                end;
            end;
        end);
        events.shutdown(function()
            -- upvalues: l_v165_2 (ref)
            db["World Editor"] = l_v165_2;
        end);
    end;
    v165 = db["World Editor::Ambients"] or {};
    v166 = {
        de_mirage = "3gARq2ZvZ19jaGFuZ2VyqE92ZXJyaWRlsWZvZ19jaGFuZ2VyX2NvbG9ylFBQWmSxZm9nX2NoYW5nZXJfc3RhcnQCtGZvZ19jaGFuZ2VyX2Rpc3RhbmNlI7Vmb2dfY2hhbmdlcl9vbl9za3lib3jCrGlsbHVtaW5hdGlvbqhTdW5saWdodLJpbGx1bWluYXRpb25fcGl0Y2gZsGlsbHVtaW5hdGlvbl95YXfQybVpbGx1bWluYXRpb25fZGlzdGFuY2XNBdyyaWxsdW1pbmF0aW9uX2NvbG9ylFU4JMz/sG5pZ2h0X21vZGVfY29sb3KUBgcNzP+ybmlnaHRfbW9kZV9lbmFibGVkw7JzdGF0aWNfcHJvcHNfY29sb3KUUFFXzP+0c3RhdGljX3Byb3BzX2VuYWJsZWTDtXBvc3RfcHJvY2Vzc2luZ19jb2xvcpQCAgLM/7dwb3N0X3Byb2Nlc3NpbmdfZW5hYmxlZMO6aWxsdW1pbmF0aW9uX2NvbG9yX2VuYWJsZWTC", 
        de_cbble = "3gARq2ZvZ19jaGFuZ2VyqE92ZXJyaWRlsWZvZ19jaGFuZ2VyX2NvbG9ylFBQWkGxZm9nX2NoYW5nZXJfc3RhcnT7tGZvZ19jaGFuZ2VyX2Rpc3RhbmNlI7Vmb2dfY2hhbmdlcl9vbl9za3lib3jCrGlsbHVtaW5hdGlvbqhTdW5saWdodLJpbGx1bWluYXRpb25fcGl0Y2gAsGlsbHVtaW5hdGlvbl95YXfMs7VpbGx1bWluYXRpb25fZGlzdGFuY2XNBdyyaWxsdW1pbmF0aW9uX2NvbG9ylFU4JMz/sG5pZ2h0X21vZGVfY29sb3KUISEkzP+ybmlnaHRfbW9kZV9lbmFibGVkw7JzdGF0aWNfcHJvcHNfY29sb3KUUVRbzP+0c3RhdGljX3Byb3BzX2VuYWJsZWTDtXBvc3RfcHJvY2Vzc2luZ19jb2xvcpTM/8z/zP/M/7dwb3N0X3Byb2Nlc3NpbmdfZW5hYmxlZMK6aWxsdW1pbmF0aW9uX2NvbG9yX2VuYWJsZWTC"
    };
    for v447, v448 in l_pairs_0(v166) do
        if v165[v447] == nil then
            v448 = l_base64_0.decode(v448);
            v165[v447] = msgpack.unpack(v448);
        end;
    end;
    v166 = {
        ui.find("Visuals", "World", "Ambient", "Night Mode")
    };
    v167 = {
        ui.find("Visuals", "World", "Ambient", "Static Props")
    };
    v186 = {
        ui.find("Visuals", "World", "Ambient", "Post Processing")
    };
    v187 = ui.find("Visuals", "World", "Ambient", "Fog Changer");
    v188 = ui.find("Visuals", "World", "Ambient", "Fog Changer", "Color");
    v189 = ui.find("Visuals", "World", "Ambient", "Fog Changer", "Start");
    v190 = ui.find("Visuals", "World", "Ambient", "Fog Changer", "Distance");
    v191 = ui.find("Visuals", "World", "Ambient", "Illumination");
    v192 = ui.find("Visuals", "World", "Ambient", "Illumination", "Pitch");
    v193 = ui.find("Visuals", "World", "Ambient", "Illumination", "Yaw");
    v194 = ui.find("Visuals", "World", "Ambient", "Illumination", "Distance");
    v195 = {
        ui.find("Visuals", "World", "Ambient", "Illumination", "Color")
    };
    do
        local l_v165_3, l_v166_2, l_v167_3, l_v186_1, l_v187_2, l_v188_1, l_v189_2, l_v190_1, l_v191_2, l_v192_1, l_v193_2, l_v194_2, l_v195_2, l_v196_1, l_v197_0 = v165, v166, v167, v186, v187, v188, v189, v190, v191, v192, v193, v194, v195, v196, v197;
        l_v196_1 = function()
            -- upvalues: v81 (ref), l_v166_2 (ref), l_v167_3 (ref), l_v186_1 (ref), l_v187_2 (ref), l_v188_1 (ref), l_v189_2 (ref), l_v190_1 (ref), l_v191_2 (ref), l_v192_1 (ref), l_v193_2 (ref), l_v194_2 (ref), l_v195_2 (ref)
            v81.override_night_mode:reset();
            v81.override_night_mode_color:reset();
            v81.override_static_props:reset();
            v81.override_static_props_color:reset();
            v81.override_post_processing:reset();
            v81.override_post_processing_color:reset();
            v81.override_fog_changer:reset();
            v81.override_fog_changer_color:reset();
            v81.override_fog_changer_start:reset();
            v81.override_fog_changer_distance:reset();
            v81.override_illumination:reset();
            v81.override_illumination_pitch:reset();
            v81.override_illumination_yaw:reset();
            v81.override_illumination_distance:reset();
            v81.override_illumination_enabled_color:reset();
            v81.override_illumination_color:reset();
            l_v166_2[1]:override();
            l_v166_2[2]:override();
            l_v167_3[1]:override();
            l_v167_3[2]:override();
            l_v186_1[1]:override();
            l_v186_1[2]:override();
            l_v187_2:override();
            l_v188_1:override();
            l_v189_2:override();
            l_v190_1:override();
            l_v191_2:override();
            l_v192_1:override();
            l_v193_2:override();
            l_v194_2:override();
            l_v195_2[1]:override();
            l_v195_2[2]:override();
        end;
        l_v197_0 = function()
            -- upvalues: v164 (ref), l_v196_1 (ref), l_v165_3 (ref), v81 (ref), l_v166_2 (ref), l_v167_3 (ref), l_v186_1 (ref), l_v187_2 (ref), l_v188_1 (ref), l_v189_2 (ref), l_v190_1 (ref), l_v191_2 (ref), l_v192_1 (ref), l_v193_2 (ref), l_v194_2 (ref), l_v195_2 (ref)
            if v164 == nil then
                return l_v196_1();
            else
                local v464 = l_v165_3[v164];
                if v464 == nil then
                    return l_v196_1();
                else
                    local v465 = v81.override_night_mode:get();
                    local v466 = v81.override_night_mode_color:get();
                    v464.night_mode_enabled = v465;
                    v464.night_mode_color = {
                        [1] = v466.r, 
                        [2] = v466.g, 
                        [3] = v466.b, 
                        [4] = v466.a
                    };
                    l_v166_2[1]:override(v465);
                    l_v166_2[2]:override(v466);
                    local v467 = v81.override_static_props:get();
                    local v468 = v81.override_static_props_color:get();
                    v464.static_props_enabled = v467;
                    v464.static_props_color = {
                        [1] = v468.r, 
                        [2] = v468.g, 
                        [3] = v468.b, 
                        [4] = v468.a
                    };
                    l_v167_3[1]:override(v467);
                    l_v167_3[2]:override(v468);
                    local v469 = v81.override_post_processing:get();
                    local v470 = v81.override_post_processing_color:get();
                    v464.post_processing_enabled = v469;
                    v464.post_processing_color = {
                        [1] = v470.r, 
                        [2] = v470.g, 
                        [3] = v470.b, 
                        [4] = v470.a
                    };
                    l_v186_1[1]:override(v469);
                    l_v186_1[2]:override(v470);
                    local v471 = v81.override_fog_changer:get();
                    local v472 = v81.override_fog_changer_color:get();
                    local v473 = v81.override_fog_changer_start:get();
                    local v474 = v81.override_fog_changer_distance:get();
                    v464.fog_changer = v471;
                    v464.fog_changer_color = {
                        [1] = v472.r, 
                        [2] = v472.g, 
                        [3] = v472.b, 
                        [4] = v472.a
                    };
                    v464.fog_changer_start = v473;
                    v464.fog_changer_distance = v474;
                    l_v187_2:override(v471);
                    l_v188_1:override(v472);
                    l_v189_2:override(v473);
                    l_v190_1:override(v474);
                    local v475 = v81.override_illumination:get();
                    local v476 = v81.override_illumination_pitch:get();
                    local v477 = v81.override_illumination_yaw:get();
                    local v478 = v81.override_illumination_distance:get();
                    local v479 = v81.override_illumination_enabled_color:get();
                    local v480 = v81.override_illumination_color:get();
                    v464.illumination = v475;
                    v464.illumination_pitch = v476;
                    v464.illumination_yaw = v477;
                    v464.illumination_distance = v478;
                    v464.illumination_color_enabled = v479;
                    v464.illumination_color = {
                        [1] = v480.r, 
                        [2] = v480.g, 
                        [3] = v480.b, 
                        [4] = v480.a
                    };
                    l_v191_2:override(v475);
                    l_v192_1:override(v476);
                    l_v193_2:override(v477);
                    l_v194_2:override(v478);
                    l_v195_2[1]:override(v479);
                    l_v195_2[2]:override(v480);
                    return;
                end;
            end;
        end;
        v198 = function()
            -- upvalues: v164 (ref), l_v196_1 (ref), l_v165_3 (ref), l_v166_2 (ref), l_v167_3 (ref), l_v186_1 (ref), l_v188_1 (ref), l_v195_2 (ref), l_v187_2 (ref), l_v189_2 (ref), l_v190_1 (ref), l_v191_2 (ref), l_v192_1 (ref), l_v193_2 (ref), l_v194_2 (ref), v81 (ref), l_v197_0 (ref)
            if v164 == nil then
                return l_v196_1();
            else
                local v481 = l_v165_3[v164];
                if v481 == nil then
                    local v482 = l_v166_2[2]:get();
                    local v483 = l_v167_3[2]:get();
                    local v484 = l_v186_1[2]:get();
                    local v485 = l_v188_1:get();
                    local v486 = l_v195_2[2]:get();
                    v481 = {
                        night_mode_enabled = l_v166_2[1]:get(), 
                        night_mode_color = {
                            [1] = v482.r, 
                            [2] = v482.g, 
                            [3] = v482.b, 
                            [4] = v482.a
                        }, 
                        static_props_enabled = l_v167_3[1]:get(), 
                        static_props_color = {
                            [1] = v483.r, 
                            [2] = v483.g, 
                            [3] = v483.b, 
                            [4] = v483.a
                        }, 
                        post_processing_enabled = l_v186_1[1]:get(), 
                        post_processing_color = {
                            [1] = v484.r, 
                            [2] = v484.g, 
                            [3] = v484.b, 
                            [4] = v484.a
                        }, 
                        fog_changer = l_v187_2:get(), 
                        fog_changer_color = {
                            [1] = v485.r, 
                            [2] = v485.g, 
                            [3] = v485.b, 
                            [4] = v485.a
                        }, 
                        fog_changer_start = l_v189_2:get(), 
                        fog_changer_distance = l_v190_1:get(), 
                        illumination = l_v191_2:get(), 
                        illumination_pitch = l_v192_1:get(), 
                        illumination_yaw = l_v193_2:get(), 
                        illumination_distance = l_v194_2:get(), 
                        illumination_color_enabled = l_v195_2[1]:get(), 
                        illumination_color = {
                            [1] = v486.r, 
                            [2] = v486.g, 
                            [3] = v486.b, 
                            [4] = v486.a
                        }
                    };
                    l_v165_3[v164] = v481;
                end;
                local l_night_mode_color_0 = v481.night_mode_color;
                v81.override_night_mode:set(v481.night_mode_enabled);
                v81.override_night_mode_color:set(color(l_night_mode_color_0[1], l_night_mode_color_0[2], l_night_mode_color_0[3], l_night_mode_color_0[4]));
                local l_static_props_color_0 = v481.static_props_color;
                v81.override_static_props:set(v481.static_props_enabled);
                v81.override_static_props_color:set(color(l_static_props_color_0[1], l_static_props_color_0[2], l_static_props_color_0[3], l_static_props_color_0[4]));
                local l_post_processing_color_0 = v481.post_processing_color;
                v81.override_post_processing:set(v481.post_processing_enabled);
                v81.override_post_processing_color:set(color(l_post_processing_color_0[1], l_post_processing_color_0[2], l_post_processing_color_0[3], l_post_processing_color_0[4]));
                local l_fog_changer_color_0 = v481.fog_changer_color;
                v81.override_fog_changer:set(v481.fog_changer);
                v81.override_fog_changer_color:set(color(l_fog_changer_color_0[1], l_fog_changer_color_0[2], l_fog_changer_color_0[3], l_fog_changer_color_0[4]));
                v81.override_fog_changer_start:set(v481.fog_changer_start);
                v81.override_fog_changer_distance:set(v481.fog_changer_distance);
                local l_illumination_color_0 = v481.illumination_color;
                v81.override_illumination:set(v481.illumination);
                v81.override_illumination_pitch:set(v481.illumination_pitch);
                v81.override_illumination_yaw:set(v481.illumination_yaw);
                v81.override_illumination_distance:set(v481.illumination_distance);
                v81.override_illumination_enabled_color:set(v481.illumination_color_enabled);
                v81.override_illumination_color:set(color(l_illumination_color_0[1], l_illumination_color_0[2], l_illumination_color_0[3], l_illumination_color_0[4]));
                l_v197_0();
                return;
            end;
        end;
        l_execute_after_0(0.01, v198);
        events.level_init(v198);
        v83(l_v197_0);
        events.shutdown(l_v196_1);
        v81.override_night_mode:set_callback(l_v197_0);
        v81.override_night_mode_color:set_callback(l_v197_0);
        v81.override_static_props:set_callback(l_v197_0);
        v81.override_static_props_color:set_callback(l_v197_0);
        v81.override_post_processing:set_callback(l_v197_0);
        v81.override_post_processing_color:set_callback(l_v197_0);
        v81.override_fog_changer:set_callback(l_v197_0);
        v81.override_fog_changer_color:set_callback(l_v197_0);
        v81.override_fog_changer_start:set_callback(l_v197_0);
        v81.override_fog_changer_distance:set_callback(l_v197_0);
        v81.override_illumination:set_callback(l_v197_0);
        v81.override_illumination_pitch:set_callback(l_v197_0);
        v81.override_illumination_yaw:set_callback(l_v197_0);
        v81.override_illumination_distance:set_callback(l_v197_0);
        v81.override_illumination_enabled_color:set_callback(l_v197_0);
        v81.override_illumination_color:set_callback(l_v197_0);
        events.shutdown(function()
            -- upvalues: l_v165_3 (ref)
            db["World Editor::Ambients"] = l_v165_3;
        end);
    end;
    v165 = db["World Editor::Weather"] or {};
    v166 = cvar.r_rainradius;
    v167 = cvar.r_rainwidth;
    v186 = cvar.r_RainParticleDensity;
    v187 = 2048;
    v188 = 138;
    ffi.cdef("            typedef void*(* create_class_t)(int, int);\n        ");
    v189 = l_typeof_0("            struct {\n                create_class_t create_class;\n                void* create_event;\n                char* network_name;\n                void* recv_table;\n                void* next;\n                int class_id;\n            }\n        ");
    v190 = utils.get_vfunc("client.dll", "VClient018", 8, l_typeof_0("$*(__thiscall*)(void*)", v189));
    v191 = nil;
    v192 = nil;
    v193 = nil;
    do
        local l_v165_4, l_v166_3, l_v167_4, l_v186_2, l_v187_3, l_v188_2, l_v189_3, l_v190_2, l_v191_3, l_v192_2, l_v193_3, l_v194_3, l_v195_3, l_v196_2, l_v197_1 = v165, v166, v167, v186, v187, v188, v189, v190, v191, v192, v193, v194, v195, v196, v197;
        l_v194_3 = function()
            -- upvalues: l_v192_2 (ref), l_v193_3 (ref), l_v191_3 (ref), l_v190_2 (ref), l_v188_2 (ref), l_cast_0 (ref), l_typeof_0 (ref), l_v189_3 (ref), l_v187_3 (ref)
            if l_v192_2 ~= nil or l_v193_3 ~= nil then
                return;
            else
                if l_v191_3 == nil then
                    local v507 = l_v190_2();
                    while v507 ~= nil do
                        if v507.class_id == l_v188_2 then
                            l_v191_3 = v507;
                            break;
                        else
                            v507 = l_cast_0(l_typeof_0("$*", l_v189_3), v507.next);
                        end;
                    end;
                end;
                l_v192_2 = l_v191_3.create_class(l_v187_3 - 1, 0);
                l_v193_3 = l_cast_0("uintptr_t", l_v192_2) - 8;
                return;
            end;
        end;
        l_v195_3 = nil;
        l_v195_3 = function()
            -- upvalues: l_v192_2 (ref), l_v193_3 (ref), l_cast_0 (ref)
            if l_v192_2 == nil or l_v193_3 == nil then
                return;
            else
                local v508 = l_cast_0("void***", l_v192_2)[0];
                l_cast_0("void(__thiscall*)(void*)", v508[1])(l_v192_2);
                l_v192_2 = nil;
                l_v193_3 = nil;
                return;
            end;
        end;
        events.shutdown(l_v195_3);
        v83(l_v195_3);
        l_v196_2 = {
            ["Particle Snow"] = 7, 
            ["Particle Ash"] = 5, 
            ["Particle Rain"] = 6, 
            ["Rain 2"] = 1, 
            Rain = 0
        };
        l_v197_1 = function()
            -- upvalues: l_v192_2 (ref), l_v193_3 (ref), l_v165_4 (ref), v164 (ref), l_v196_2 (ref), l_get_0 (ref), l_cast_0 (ref), l_typeof_0 (ref), v67 (ref)
            if l_v192_2 == nil or l_v193_3 == nil then
                return;
            else
                local v509 = l_v165_4[v164];
                if v509 == nil then
                    return;
                else
                    local v510 = l_v196_2[v509.type];
                    if v510 == nil then
                        v510 = 0;
                    end;
                    local v511 = l_get_0(0);
                    local l_m_WorldMins_0 = v511.m_WorldMins;
                    local l_m_WorldMaxs_0 = v511.m_WorldMaxs;
                    local v514 = l_cast_0("void***", l_v192_2)[0];
                    local v515 = l_cast_0("void(__thiscall*)(void*, int)", v514[4]);
                    local v516 = l_cast_0("void(__thiscall*)(void*, int)", v514[5]);
                    local v517 = l_cast_0("void(__thiscall*)(void*, int)", v514[6]);
                    local v518 = l_cast_0("void(__thiscall*)(void*, int)", v514[7]);
                    v517(l_v192_2, 0);
                    v515(l_v192_2, 0);
                    l_cast_0("int*", l_v193_3 + 600)[0] = 1;
                    l_cast_0("int*", l_v193_3 + 2560)[0] = v510;
                    local v519 = l_v193_3 + 800;
                    l_cast_0(l_typeof_0("$*", v67), v519 + 8)[0] = v67(l_m_WorldMins_0.x, l_m_WorldMins_0.y, l_m_WorldMins_0.z);
                    l_cast_0(l_typeof_0("$*", v67), v519 + 20)[0] = v67(l_m_WorldMaxs_0.x, l_m_WorldMaxs_0.y, l_m_WorldMaxs_0.z);
                    v516(l_v192_2, 0);
                    v518(l_v192_2, 0);
                    return;
                end;
            end;
        end;
        v198 = function()
            -- upvalues: v81 (ref)
            v81.weather_enabled:reset();
            v81.weather_type:reset();
            v81.weather_radius:reset();
            v81.weather_width:reset();
            v81.weather_density:reset();
        end;
        do
            local l_v198_1 = v198;
            v199 = function()
                -- upvalues: v164 (ref), l_v165_4 (ref), l_v198_1 (ref), v81 (ref), l_v166_3 (ref), l_v167_4 (ref), l_v186_2 (ref)
                if v164 == nil then
                    return;
                else
                    local v521 = l_v165_4[v164];
                    if v521 == nil then
                        l_v198_1();
                        local v522 = {
                            enabled = v81.weather_enabled:get(), 
                            type = v81.weather_type:get(), 
                            radius = v81.weather_radius:get(), 
                            width = v81.weather_width:get(), 
                            density = v81.weather_density:get()
                        };
                        l_v165_4[v164] = v522;
                        return;
                    else
                        v81.weather_enabled:set(v521.enabled);
                        v81.weather_type:set(v521.type);
                        l_v166_3:int(v521.radius);
                        l_v167_4:float(v521.width * 0.01);
                        local l_density_0 = v521.density;
                        if l_density_0 == nil then
                            l_density_0 = v81.weather_density:get();
                            v521.density = l_density_0;
                        end;
                        l_v186_2:float(l_density_0 * 0.01);
                        return;
                    end;
                end;
            end;
            v200 = function(v524)
                -- upvalues: l_v165_4 (ref), v164 (ref), v81 (ref), l_v195_3 (ref), l_v194_3 (ref), l_v197_1 (ref), l_v166_3 (ref), l_v167_4 (ref), l_v186_2 (ref)
                local v525 = l_v165_4[v164];
                if v525 == nil then
                    return;
                else
                    local v526 = v81.weather_enabled:get();
                    v525.enabled = v526;
                    v525.type = v81.weather_type:get();
                    v525.radius = v81.weather_radius:get();
                    v525.width = v81.weather_width:get();
                    v525.density = v81.weather_density:get();
                    local v527 = v524:name();
                    local v528 = v527 == v81.weather_enabled:name() or v527 == v81.weather_type:name();
                    if v526 then
                        if v528 then
                            l_v195_3();
                            l_v194_3();
                            l_v197_1();
                        end;
                    else
                        l_v195_3();
                    end;
                    l_v166_3:int(v525.radius);
                    l_v167_4:float(v525.width * 0.01);
                    l_v186_2:float(v525.density * 0.01);
                    return;
                end;
            end;
            v81.weather_enabled:set_callback(v200);
            v81.weather_type:set_callback(v200);
            v81.weather_radius:set_callback(v200);
            v81.weather_width:set_callback(v200);
            v81.weather_density:set_callback(v200);
            l_execute_after_0(0.01, v199);
            events.level_init(v199);
        end;
        events.round_start(function()
            -- upvalues: l_v165_4 (ref), v164 (ref), l_v194_3 (ref), l_v197_1 (ref), l_v195_3 (ref)
            local v529 = l_v165_4[v164];
            if v529 == nil then
                return;
            else
                if v529.enabled then
                    l_v194_3();
                    l_v197_1();
                else
                    l_v195_3();
                end;
                return;
            end;
        end);
        v198 = utils.opcode_scan("client.dll", "55 8B EC 83 E4 F8 83 EC 54 53 8B D9");
        v199 = l_cast_0("int(__thiscall*)(void*, uintptr_t, void*)", v198);
        l_memory_0.hook_func(v199, function(v530, v531, v532, v533)
            -- upvalues: l_cast_0 (ref)
            local v534 = l_cast_0("uint32_t*", v531);
            local v535 = false;
            if v534[239] == 2047 then
                v534[239] = -1;
                v535 = true;
            end;
            local v536 = v530:get_original(v531, v532, v533);
            if v535 then
                v534[239] = 2047;
            end;
            return v536;
        end);
        v198 = utils.opcode_scan("client.dll", "55 8B EC 51 8B 0D ?? ?? ?? ?? 56 8B 75 08 6A");
        v199 = l_cast_0("bool(__thiscall*)(void*, int)", v198);
        l_memory_0.hook_func(v199, function(v537, v538, v539)
            -- upvalues: v164 (ref), l_cast_0 (ref)
            local v540 = v537:get_original(v538, v539);
            if v540 and v164 == "de_vertigo" and l_cast_0("float*", v539 + 8)[0] < 11500 then
                return false;
            else
                return v540;
            end;
        end);
        events.shutdown(function()
            -- upvalues: l_v165_4 (ref)
            db["World Editor::Weather"] = l_v165_4;
        end);
    end;
    v165 = v81.textures;
    v166 = nil;
    v167 = nil;
    v186 = utils.create_interface("materialsystem.dll", "VMaterialSystem080");
    v186 = ffi.cast("void*", v186);
    v187 = ffi.cast("void***", v186)[0];
    v188 = nil;
    v189 = nil;
    v190 = ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("vstdlib.dll"), "KeyValuesSystem");
    v191 = ffi.cast("void*(__thiscall*)()", v190)();
    v192 = ffi.cast("void***", v191)[0];
    v193 = ffi.cast("void*(__thiscall*)(void*, size_t)", v192[2]);
    v194 = ffi.cast("void(__thiscall*)(void*, void*)", v192[3]);
    v195 = utils.opcode_scan("client.dll", "55 8B EC 56 8B F1 33 C0 8B 4D 0C 81");
    v196 = ffi.cast("void*(__thiscall*)(void*, const char*, int, int)", v195);
    v197 = utils.opcode_scan("client.dll", "55 8B EC 83 EC 1C 53 8B D9 85");
    v198 = ffi.cast("void*(__thiscall*)(void*, const char*, int)", v197);
    v199 = utils.opcode_scan("client.dll", "55 8B EC A1 ?? ?? ?? ?? 53 56 57 8B F9 8B 08 8B");
    v200 = ffi.cast("void(__thiscall*)(void*, const char*)", v199);
    do
        local l_v191_4, l_v193_4, l_v194_4, l_v196_3, l_v198_2, l_v200_1 = v191, v193, v194, v196, v198, v200;
        v188 = function(v547, v548)
            -- upvalues: l_v193_4 (ref), l_v191_4 (ref), l_v196_3 (ref), l_pairs_0 (ref), l_v198_2 (ref), l_v200_1 (ref)
            local v549 = l_v193_4(l_v191_4, 44);
            l_v196_3(v549, v547, 0, 0);
            for v550, v551 in l_pairs_0(v548) do
                local v552 = l_v198_2(v549, v550, 1);
                l_v200_1(v552, v551);
            end;
            return v549;
        end;
        v189 = function(v553)
            -- upvalues: l_v194_4 (ref), l_v191_4 (ref)
            l_v194_4(l_v191_4, v553);
        end;
    end;
    v190 = ffi.cast("void*(__thiscall*)(void*, const char*, const char*, bool, int)", v187[84]);
    v191 = nil;
    do
        local l_v186_3, l_v188_3, l_v189_4 = v186, v188, v189;
        do
            local l_v190_3, l_v191_5 = v190, v191;
            v166 = function(v559, v560)
                -- upvalues: l_v190_3 (ref), l_v186_3 (ref), l_v191_5 (ref)
                local v561 = l_v190_3(l_v186_3, v559, v560, false, 0);
                if l_v191_5 == nil then
                    local v562 = ffi.cast("void***", v561)[0];
                    l_v191_5 = ffi.cast("bool(__thiscall*)(void*)", v562[42]);
                end;
                if l_v191_5(v561) then
                    return;
                else
                    return v561;
                end;
            end;
        end;
        v190 = ffi.cast("void*", 0);
        v191 = nil;
        do
            local l_v190_4, l_v191_6 = v190, v191;
            v167 = function(v565, v566, v567)
                -- upvalues: l_v191_6 (ref), l_v190_4 (ref), l_v188_3 (ref), l_v189_4 (ref)
                if l_v191_6 == nil then
                    local v568 = ffi.cast("void***", v565)[0];
                    l_v191_6 = ffi.cast("void*(__thiscall*)(void*, void*)", v568[48]);
                end;
                if v566 == nil and v567 == nil then
                    return l_v191_6(v565, l_v190_4);
                else
                    local v569 = l_v188_3(v566, v567);
                    l_v191_6(v565, v569);
                    l_v189_4(v569);
                    return;
                end;
            end;
        end;
    end;
    v186 = nil;
    v187 = utils.opcode_scan("engine.dll", "55 8B EC 83 EC 18 F3 0F 10 0D ?? ?? ?? ?? 8D 45 E8 F3 0F 10 05 ?? ?? ?? ?? 8D 55 F4 F3 0F 59 C1 83");
    v188 = l_cast_0("void*(__thiscall*)()", v187);
    v189 = utils.opcode_scan("engine.dll", "55 8B EC 51 53 8B D9 56 57 8B FA 33");
    v190 = l_cast_0("int(__fastcall*)(void*, int, void*)", v189);
    v191 = l_typeof_0("void* [128]");
    v192 = nil;
    do
        local l_v188_4, l_v190_5, l_v191_7, l_v192_3 = v188, v190, v191, v192;
        v186 = function()
            -- upvalues: l_get_local_player_0 (ref), l_camera_angles_0 (ref), l_trace_line_0 (ref), v163 (ref), l_v191_7 (ref), l_v190_5 (ref), l_v192_3 (ref), l_cast_0 (ref), l_string_0 (ref), l_v188_4 (ref)
            local v574 = l_get_local_player_0();
            if v574 == nil or not v574:is_alive() then
                return;
            else
                local v575 = v574:get_eye_position();
                local v576 = l_camera_angles_0();
                local v577 = v575 + vector():angles(v576) * 4096;
                local l_hitbox_0 = l_trace_line_0(v575, v577, nil, 33570827).hitbox;
                if l_hitbox_0 ~= 0 then
                    local v579 = v163[l_hitbox_0];
                    if v579 ~= nil then
                        local l_material_name_0 = v579.material_name;
                        if l_material_name_0 ~= nil then
                            return l_material_name_0;
                        else
                            local v581 = l_v191_7();
                            if l_v190_5(v579.model, 128, v581) > 0 then
                                local v582 = v581[0];
                                if l_v192_3 == nil then
                                    local v583 = l_cast_0("void***", v582)[0];
                                    l_v192_3 = l_cast_0("const char*(__thiscall*)(void*)", v583[0]);
                                end;
                                local v584 = l_v192_3(v582);
                                v584 = l_string_0(v584);
                                v579.material_name = v584;
                                return v584;
                            end;
                        end;
                    end;
                end;
                local v585 = l_v188_4();
                if l_v192_3 == nil then
                    local v586 = l_cast_0("void***", v585)[0];
                    l_v192_3 = l_cast_0("const char*(__thiscall*)(void*)", v586[0]);
                end;
                local v587 = l_v192_3(v585);
                return (l_string_0(v587));
            end;
        end;
    end;
    v187 = {
        ui.find("Visuals", "World", "Ambient", "Night Mode")
    };
    v188 = v187[1];
    v189 = v187[2];
    v190 = nil;
    v191 = nil;
    do
        local l_v165_5, l_v166_4, l_v167_5, l_v186_4, l_v189_5, l_v190_6, l_v191_8, l_v192_4, l_v193_5, l_v194_5, l_v195_4, l_v196_4, l_v197_2, l_v198_3, l_v199_0, l_v200_2, l_v201_0 = v165, v166, v167, v186, v189, v190, v191, v192, v193, v194, v195, v196, v197, v198, v199, v200, v201;
        v188:set_callback(function(v605)
            -- upvalues: l_v190_6 (ref)
            l_v190_6 = v605:get();
        end, true);
        l_v189_5:set_callback(function(v606)
            -- upvalues: l_v191_8 (ref)
            current_nightmode_color = v606:get();
            l_v191_8 = {
                [1] = current_nightmode_color.r, 
                [2] = current_nightmode_color.g, 
                [3] = current_nightmode_color.b, 
                [4] = current_nightmode_color.a
            };
        end, true);
        l_v192_4 = db["World Editor::Textures"] or {};
        l_v193_5 = 1;
        l_v194_5 = {
            de_mirage = "3ABNhax0ZXh0dXJlX3BhdGixZ3JvdW5kL3Nub3cwMS52dGaqdmlld2FuZ2xlc5LKQQSAdcpCs5EMqHBvc2l0aW9uk8rEyRWeysUNmwnKw3t8wKVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1l2TZkZV9taXJhZ2UvZ3JvdW5kL2RlX21pcmFnZV9ncm91bmRfdGlsZWhfYmxlbmRfZGlmZnVzZSCFrHRleHR1cmVfcGF0aLFncm91bmQvc25vdzAxLnZ0Zqp2aWV3YW5nbGVzkspBBIB1ykKzkQyocG9zaXRpb26TysTFGpPKxLEaC8rDhD0ipWNvbG9ylMz/zP/M/8z/rW1hdGVyaWFsX25hbWXZNmRlX21pcmFnZS9ncm91bmQvZGVfbWlyYWdlX2dyb3VuZF90aWxlaF9ibGVuZDJfZGlmZnVzZYWsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykGgf6XKQspiAKhwb3NpdGlvbpPKxBS95MrE4tNyysMgtFilY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdk5bWFwcy9kZV9taXJhZ2UvZGVfbWlyYWdlL21hcmJsZS9tYXJibGVfMDFfLTcxMV8tMTQzOF8tMTIzhax0ZXh0dXJlX3BhdGixZ3JvdW5kL3Nub3cwMS52dGaqdmlld2FuZ2xlc5LKQSsnycrBGynaqHBvc2l0aW9uk8rEwyj5ysUOqwHKw3hZYKVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1l2SpkZV9taXJhZ2UvdGlsZS9kZV9taXJhZ2VfdGlsZV92ZXI0X2RpZmZ1c2WFrHRleHR1cmVfcGF0aLFncm91bmQvc25vdzAxLnZ0Zqp2aWV3YW5nbGVzkspAzsqOykKy4T2ocG9zaXRpb26TysTHnJTKxJ7j1crDgsFhpWNvbG9ylMz/zP/M/8z/rW1hdGVyaWFsX25hbWXZNmRlX21pcmFnZS9ncm91bmQvZGVfbWlyYWdlX2dyb3VuZF90aWxlaF9ibGVuZDJfZGlmZnVzZYWsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykGdV4PKQr8zHKhwb3NpdGlvbpPKxQ1GJcrCuEUqysMV2rOlY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdkoZGVfbWlyYWdlL3RpbGUvZGVfbWlyYWdlX3RpbGVfdmVyNF9ibGVuZIWsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykFxYSrKwkLyeqhwb3NpdGlvbpPKxMk2eMpEC81YysMn+oalY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdk2ZGVfbWlyYWdlL2dyb3VuZC9kZV9taXJhZ2VfZ3JvdW5kX3RpbGVjX2JsZW5kX2RpZmZ1c2Ughax0ZXh0dXJlX3BhdGixZ3JvdW5kL3Nub3cwMS52dGaqdmlld2FuZ2xlc5LKQXFhKsrCQvJ6qHBvc2l0aW9uk8rEzYcjykQNooDKwyf6hqVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1ls2RlX2R1c3QvdGlsZWZsb29yMDGFrHRleHR1cmVfcGF0aLFncm91bmQvc25vdzAxLnZ0Zqp2aWV3YW5nbGVzkspBqZWyyr/hU7+ocG9zaXRpb26TykSg7kvKwyWte8rDJ/gApWNvbG9ylMz/zP/M/8z/rW1hdGVyaWFsX25hbWWzZGVfZHVzdC9zdG9uZXN0ZXAwM4WsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykH1qRzKQgAEjahwb3NpdGlvbpPKw4KSfcrEFf2jysNggk+lY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdkoZGVfbWlyYWdlL2dyb3VuZC9kZV9taXJhZ2VfdGlsZWZfZGlmZnVzZYWsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykD5mnzKQzKc1Khwb3NpdGlvbpPKRHxRRcpEGzDXysNknFulY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZbNkZV9kdXN0L3N0b25lc3RlcDAyhax0ZXh0dXJlX3BhdGixZ3JvdW5kL3Nub3cwMS52dGaqdmlld2FuZ2xlc5LKQSNVO8rCr0bRqHBvc2l0aW9uk8rEGVJGysQeeyHKw3EqHqVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1l2TJtYXBzL2RlX21pcmFnZS9kZV9kdXN0L3RpbGVmbG9vcjAyXy02NjJfLTEwMTVfLTE2N4WsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrA3v3yysL2RTaocG9zaXRpb26TysQ/dT/KxLWlZsrDJ/gApWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWXZLGRlX21pcmFnZS9icmljay9kZV9taXJhZ2VfYnJpY2tfdmVyMV9kaWZmdXNlhax0ZXh0dXJlX3BhdGjZI2JyaWNrL2hyX2JyaWNrL2luZmVybm8vYnJpY2tfZjEudnRmqnZpZXdhbmdsZXOSykAdsjTKwxKU3Khwb3NpdGlvbpPKxB7tbsrEzZK8ysMqBy2lY29sb3KUHBwczP+tbWF0ZXJpYWxfbmFtZdkxZGVfbWlyYWdlL2JyaWNrL2RlX21pcmFnZV9icmlja192ZXIyX2JsZW5kX3VwZGF0ZYWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrBfcrAyr9INZCocG9zaXRpb26TysPVnXjKxOFZlcrDLaAfpWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWXZKmRlX21pcmFnZS9ocl9taXJhZ2UvbWlyYWdlX3BsYXN0ZXJfYmxlbmRfM4WsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrBR5VxysKsHnWocG9zaXRpb26TysO+1q3KxONbh8rDKkoJpWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWXZJGRlX21pcmFnZS9ocl9taXJhZ2UvbWlyYWdlX3BsYXN0ZXJfMoWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrAzb5aysKwCy2ocG9zaXRpb26TysP+dIHKxBS/M8rDilzopWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWXZJ2RlX21pcmFnZS9iYXNlL2RlX21pcmFnZV90b3BfdmVyMV9ibGVuZIWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzkspAtlYeysKvCvuocG9zaXRpb26TysNzHM7KxBeN08rDeiBLpWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWXZNGRlX21pcmFnZS9icmljay9kZV9taXJhZ2VfYnJpY2tfdmVyMXBsX2JsZW5kX2RpZmZ1c2WFrHRleHR1cmVfcGF0aNkjYnJpY2svaHJfYnJpY2svaW5mZXJuby9icmlja19mMS52dGaqdmlld2FuZ2xlc5LKwUvlTcrCyzl8qHBvc2l0aW9uk8rD8yIUysPq4c7KwyeW16Vjb2xvcpQcHBzM/61tYXRlcmlhbF9uYW1l2SlkZV9taXJhZ2UvYmFzZS9kZV9taXJhZ2VfdG9wX3ZlcjFfZGlmZnVzZYWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrADHJ3ysK4XD+ocG9zaXRpb26TykLrBi/KxDz1AcrDJ/gApWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWW4Y29uY3JldGUvY29uY3JldGVfZXh0XzA3hax0ZXh0dXJlX3BhdGjZI2JyaWNrL2hyX2JyaWNrL2luZmVybm8vYnJpY2tfZjEudnRmqnZpZXdhbmdsZXOSysF8j7zKwydLIahwb3NpdGlvbpPKxDkyqMrEK0BgysOGUkKlY29sb3KUHBwczP+tbWF0ZXJpYWxfbmFtZbJicmljay9icmlja19leHRfMDSFrHRleHR1cmVfcGF0aNkjYnJpY2svaHJfYnJpY2svaW5mZXJuby9icmlja19mMS52dGaqdmlld2FuZ2xlc5LKwT26T8rDFp4gqHBvc2l0aW9uk8rEJrmDysSM8GvKwyg1d6Vjb2xvcpQ8PDzM/61tYXRlcmlhbF9uYW1ltGRlX2R1c3Qvc2l0ZWJ3YWxsMDdhhax0ZXh0dXJlX3BhdGjZI2JyaWNrL2hyX2JyaWNrL2luZmVybm8vYnJpY2tfZjEudnRmqnZpZXdhbmdsZXOSykEvGRTKwoj5sKhwb3NpdGlvbpPKxSNI5spDheRIysMmyn6lY29sb3KUPDw8zP+tbWF0ZXJpYWxfbmFtZbRkZV9kdXN0L3NpdGVid2FsbDEzYYWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrAmuyKykLIZlyocG9zaXRpb26TykLN8QvKxAMTTcrDKx8upWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWXZL2RlX21pcmFnZS9wbGFzdGVyL2RlX21pcmFnZV9wbGFzdGVyX2JsdWUxX2JsZW5khax0ZXh0dXJlX3BhdGjZI2JyaWNrL2hyX2JyaWNrL2luZmVybm8vYnJpY2tfZjEudnRmqnZpZXdhbmdsZXOSysGKNv/KQrbEyahwb3NpdGlvbpPKxAuuocrD8xNHysMn14SlY29sb3KUPDw8zP+tbWF0ZXJpYWxfbmFtZdkxZGVfbWlyYWdlL3BsYXN0ZXIvZGVfbWlyYWdlX3BsYXN0ZXJfYmx1ZTFfZGlmZnVzZYWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrBeo62ysMFQAKocG9zaXRpb26TysP7eeHKw9RsbMrDKPijpWNvbG9ylDw8PMz/rW1hdGVyaWFsX25hbWXZM2RlX21pcmFnZS9wbGFzdGVyL2RlX21pcmFnZV9wbGFzdGVyX3NhbG1vbjFfZGlmZnVzZYWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrBeo62ysMFQAKocG9zaXRpb26TysPZCjzKw8UqDcrDJ/gApWNvbG9ylDw8PMz/rW1hdGVyaWFsX25hbWXZMWRlX21pcmFnZS9wbGFzdGVyL2RlX21pcmFnZV9wbGFzdGVyX3NhbG1vbjFfYmxlbmSFrHRleHR1cmVfcGF0aNkjYnJpY2svaHJfYnJpY2svaW5mZXJuby9icmlja19mMS52dGaqdmlld2FuZ2xlc5LKwO1hZMrBgi+BqHBvc2l0aW9uk8pDnpKzykOG+MHKw4N4hqVjb2xvcpQ8PDzM/61tYXRlcmlhbF9uYW1l2ShkZV9taXJhZ2UvYmFzZS9kZV9taXJhZ2VfYmFzZV92ZXIxX2JsZW5khax0ZXh0dXJlX3BhdGixZ3JvdW5kL3Nub3cwMS52dGaqdmlld2FuZ2xlc5LKQZ0t68pC2wM2qHBvc2l0aW9uk8rFBGL+ykQB++3KwyX+3qVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1lvmNvbmNyZXRlL2JsZW5kX2JsYWNrdG9wc2FuZF8wMYWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrB9dAtysKNvRyocG9zaXRpb26TysRDHy7KxQrRGsrDM/gApWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWXZN2RlX21pcmFnZS9wbGFzdGVyX3dvcm4vZGVfbWlyYWdlX3BsYXN0ZXJfYnJpY2s0X2RpZmZ1c2WFrHRleHR1cmVfcGF0aNkiYnJpY2svaHJfYnJpY2svaW5mZXJuby9icmlja19mLnZ0Zqp2aWV3YW5nbGVzksrAIQJ8ykJVjuCocG9zaXRpb26TysPFFUPKxCs0xsrDiHV1pWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWW0ZGVfZHVzdC9tYXJrZXR3YWxsMDKFrHRleHR1cmVfcGF0aNkjYnJpY2svaHJfYnJpY2svaW5mZXJuby9icmlja19mMS52dGaqdmlld2FuZ2xlc5LKvyx44spCgaxNqHBvc2l0aW9uk8rC4xA1ysTd8hLKwyf4AKVjb2xvcpQcHBzM/61tYXRlcmlhbF9uYW1l2TNkZV9taXJhZ2UvYnJpY2svZGVfbWlyYWdlX2JyaWNrX3ZlcjJfYmxlbmQyX2RpZmZ1c2WFrHRleHR1cmVfcGF0aNkjYnJpY2svaHJfYnJpY2svaW5mZXJuby9icmlja19mMS52dGaqdmlld2FuZ2xlc5LKPoAggMpDFh0wqHBvc2l0aW9uk8rEgj5pysSuoDvKwygzoqVjb2xvcpQcHBzM/61tYXRlcmlhbF9uYW1l2SlkZV9taXJhZ2UvYmFzZS9kZV9taXJhZ2VfbWlkX3ZlcjFfZGlmZnVzZYWsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykH2PvbKQrv2VKhwb3NpdGlvbpPKQiCrEcrFBXQfysIP4AClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZa53b29kL3BseXdvb2QwMoWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzkspAkf3sykMuLWmocG9zaXRpb26TykR26jLKxQlvP8rCH+AApWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWW9Y3NfaXRhbHkvaHBlX3BsYXN0ZXJfdGFuX3dhbGyFrHRleHR1cmVfcGF0aLxhbnViaXMvaHJfc3RvbmVfZ3JvdW5kMDMudnRmqnZpZXdhbmdsZXOSykA1GpPKwxHvz6hwb3NpdGlvbpPKRHHX8srFBn7jysIf4AClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdkxbWFwcy9kZV9taXJhZ2UvdGlsZS90aWxlX21hbGxfZmxvb3IwMF81NTFfLTIyODFfOYWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrCBKHsysMyv4qocG9zaXRpb26TykQ+jwbKxQ4iyMrCH+AApWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWWwd29vZC93b29kX2ludF8wMoWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrCBKHsysMyv4qocG9zaXRpb26TykQ9axTKxQ4kYcrCH+AApWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWWyd29vZC93b29kZmxvb3IwMDVhhax0ZXh0dXJlX3BhdGjZI2JyaWNrL2hyX2JyaWNrL2luZmVybm8vYnJpY2tfZjEudnRmqnZpZXdhbmdsZXOSyr9z7+jKwyzldahwb3NpdGlvbpPKQ2yOd8rFEazsysIf4AClY29sb3KUHBwczP+tbWF0ZXJpYWxfbmFtZb9jc19pdGFseS9ocGVfcGxhc3Rlcl90cmltX2xpZ2h0hax0ZXh0dXJlX3BhdGjZI2JyaWNrL2hyX2JyaWNrL2luZmVybm8vYnJpY2tfZjEudnRmqnZpZXdhbmdsZXOSysBJbqzKwo55iahwb3NpdGlvbpPKw9rE2srEw6cOysIf4AClY29sb3KUHBwczP+tbWF0ZXJpYWxfbmFtZdkvbW9kZWxzL3Byb3BzL2RlX21pcmFnZS93YWxsX2FyY2hfYS93YWxsX2FyY2hfYTGFrHRleHR1cmVfcGF0aNkjYnJpY2svaHJfYnJpY2svaW5mZXJuby9icmlja19mMS52dGaqdmlld2FuZ2xlc5LKPsUc4MrCspf5qHBvc2l0aW9uk8rEAAHkysTC+QbKwh/gAKVjb2xvcpQcHBzM/61tYXRlcmlhbF9uYW1l2TBtb2RlbHMvcHJvcHMvZGVfbWlyYWdlL2xhcmdlX2Rvb3JfYi9sYXJnZV9kb29yX2KFrHRleHR1cmVfcGF0aLFncm91bmQvc25vdzAxLnZ0Zqp2aWV3YW5nbGVzkso+RHA+ykIx1eCocG9zaXRpb26TysRAuXHKxRTkDsrDL4XDpWNvbG9ylMz/zP/M/8z/rW1hdGVyaWFsX25hbWXZJW1vZGVscy9wcm9wcy9kZV9pbmZlcm5vL2FtbW9fcGFsbGV0MDGFrHRleHR1cmVfcGF0aLFncm91bmQvc25vdzAxLnZ0Zqp2aWV3YW5nbGVzkspCP0PJykMzvzyocG9zaXRpb26TysP9TC7KxP6MO8rCzqMzpWNvbG9ylMz/zP/M/8z/rW1hdGVyaWFsX25hbWWwd29vZC9taWxiZWFtczAwM4WsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykASjdXKwySHdqhwb3NpdGlvbpPKww3PqsrE/utvysMn+AClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdkibW9kZWxzL3Byb3BzL2RlX2luZmVybm8vYm9tYl90YW5rc4WsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykJLgg7KwjXLT6hwb3NpdGlvbpPKw5A4PsrE/YscysIT4AClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZbF3b29kL3dvb2RiZWFtMDAxYYWsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykCqnCzKQy7E1Khwb3NpdGlvbpPKQ0zDLcrEwqA/ysMUTWKlY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdkkbW9kZWxzL2RlX2R1c3Qvb2JqZWN0cy9zdG9uZWJsb2NrczAxhax0ZXh0dXJlX3BhdGixZ3JvdW5kL3Nub3cwMS52dGaqdmlld2FuZ2xlc5LKQSQnJMrDM3ltqHBvc2l0aW9uk8pDA42vysS7nMPKwy/4AKVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1l2Uptb2RlbHMvcHJvcHMvZGVfZHVzdC9ocl9kdXN0L2R1c3RfY3JhdGVzL2R1c3Rfc2hpcHBpbmdfY3JhdGVfMDJfd29vZF9jb2xvcoWsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykEUIxTKwprSfahwb3NpdGlvbpPKQR4Hb8rExhh4ysMqkZKlY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdktbW9kZWxzL3Byb3BzL2dnX3ZpZXRuYW0vdmlldG5hbV9odXRfd29vZF9nYW5nhax0ZXh0dXJlX3BhdGixZ3JvdW5kL3Nub3cwMS52dGaqdmlld2FuZ2xlc5LKQUkdFsrDBHmyqHBvc2l0aW9uk8rEAXJUysS6GETKwh//gKVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1l2SZtb2RlbHMvcHJvcHMvZGVfbWlyYWdlL2JlbmNoX2EvYmVuY2hfYYWsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykDGU6HKQy1FT6hwb3NpdGlvbpPKQ+E97crEPrD2ysMf+AClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdklbW9kZWxzL3Byb3BzL2RlX2R1c3QvZHVzdF9mb29kX2NyYXRlc4WsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykA4v+HKQzPQ4Khwb3NpdGlvbpPKQ+ODPMrEKsQfysMf+AClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdklbW9kZWxzL3Byb3BzL2RlX2luZmVybm8vZmxvd2VyX2JhcnJlbIWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrBOlm/ysLgdiWocG9zaXRpb26TysSw0bHKRADnVMrDJUwZpWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWXZJG1vZGVscy9wcm9wcy9kZV9kdXN0L2R1c3RfYXJjaF9zbWFsbIWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzkspA8hE/ysEKp6+ocG9zaXRpb26TysUa16PKQ8cT0srDJ/gApWNvbG9ylMz/zP/M/8z/rW1hdGVyaWFsX25hbWXZMm1vZGVscy9wcm9wcy9kZV9taXJhZ2UvYnJva2VuX3dhbGxfMS9icm9rZW5fd2FsbF8xhax0ZXh0dXJlX3BhdGjZImJyaWNrL2hyX2JyaWNrL2luZmVybm8vYnJpY2tfZi52dGaqdmlld2FuZ2xlc5LKQSdVu8pDGRvqqHBvc2l0aW9uk8rEcFXOysQOXr3Kw4mz+KVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1ltWRlX2R1c3QvbWFya2V0d2FsbDA1YYWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzkspAJtD2ykK1sLmocG9zaXRpb26TysRr40HKxBQ55crDg/wApWNvbG9ylMz/zP/M/8z/rW1hdGVyaWFsX25hbWXZIm1vZGVscy9wcm9wcy9jc19pdGFseS9icmlja19hcmNoMDGFrHRleHR1cmVfcGF0aNkhYW51YmlzL2hyX3N0b25lX2Zsb29yMDFfYmxlbmQudnRmqnZpZXdhbmdsZXOSyj+CxCbKQzPJSKhwb3NpdGlvbpPKRAqCPMpESQwIysMH+AClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdkgY3NfaXRhbHkvaHBlX3BsYXN0ZXJfeWVsbG93X3dhbGyFrHRleHR1cmVfcGF0aNkhYW51YmlzL2hyX3N0b25lX2Zsb29yMDFfYmxlbmQudnRmqnZpZXdhbmdsZXOSyr/p53jKwuURO6hwb3NpdGlvbpPKxPZMEsrD9/wxysMn+AClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZbZwbGFzdGVyL3BsYXN0ZXJfaW50XzAyhax0ZXh0dXJlX3BhdGi8YW51YmlzL2hyX3N0b25lX2dyb3VuZDAzLnZ0Zqp2aWV3YW5nbGVzkspAWxjPykJLlpGocG9zaXRpb26TysUJPR/KxAX49srDJ/gApWNvbG9ylMz/zP/M/8z/rW1hdGVyaWFsX25hbWXZLW1hcHMvZGVfbWlyYWdlL3RpbGUvbWlsZmxyMDAyXy0xOTk5Xy01MjhfLTE0OIWsdGV4dHVyZV9wYXRovGFudWJpcy9ocl9zdG9uZV9ncm91bmQwMy52dGaqdmlld2FuZ2xlc5LKQZFto8pCtp/5qHBvc2l0aW9uk8rEmm+iysR8FA3Kwyf4AKVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1lsHRpbGUvdGlsZV9pbnRfMDKFrHRleHR1cmVfcGF0aNkhYW51YmlzL2hyX3N0b25lX2Zsb29yMDFfYmxlbmQudnRmqnZpZXdhbmdsZXOSyr2QQrDKQptdw6hwb3NpdGlvbpPKxJngCsrEqQ4BysMr4KSlY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZb1jc19pdGFseS9ocGVfcGxhc3Rlcl90aW50X3RhboWsdGV4dHVyZV9wYXRo2SFhbnViaXMvaHJfc3RvbmVfZmxvb3IwMV9ibGVuZC52dGaqdmlld2FuZ2xlc5LKPm754cpB/vwgqHBvc2l0aW9uk8rEkxajysQWwarKwyf4AKVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1lrWJyaWNrL2luZndsbGeFrHRleHR1cmVfcGF0aL1tZXRhbC9iYWdnYWdlX3RyYWNrX3JhaWxzLnZ0Zqp2aWV3YW5nbGVzkspAkq7pykKIj6uocG9zaXRpb26TysSRCIjKxDMJacrDJ/gApWNvbG9ylMz/zP/M/8z/rW1hdGVyaWFsX25hbWXZMm1hcHMvZGVfbWlyYWdlL21ldGFsL21ldGFsZG9vcjAzNGFfLTExODFfLTYzOV8tMTE5hax0ZXh0dXJlX3BhdGi+YXJfZGl6enkvZGl6enlfZmFjYWRlX21hc2sudnRmqnZpZXdhbmdsZXOSysCDctHKwQphgKhwb3NpdGlvbpPKxOQ40MrE5/ZbysOEjcClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZa9kZV9kdXN0L2Rvb3IwMTGFrHRleHR1cmVfcGF0aL5hcl9kaXp6eS9kaXp6eV9mYWNhZGVfbWFzay52dGaqdmlld2FuZ2xlc5LKQGD5jspAwKFXqHBvc2l0aW9uk8rE9F51ysTvucjKw424I6Vjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1lrmRlX2R1c3QvZG9vcjA0hax0ZXh0dXJlX3BhdGi9bWV0YWwvYmFnZ2FnZV90cmFja19yYWlscy52dGaqdmlld2FuZ2xlc5LKwKctNMrBR1zqqHBvc2l0aW9uk8rExSN5ysRhtJPKwzIzxKVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1l2S5tb2RlbHMvcHJvcHMvZGVfYXp0ZWMvYXp0ZWNfc2NhZmZvbGRpbmdfc3lzdGVthax0ZXh0dXJlX3BhdGjZI2JyaWNrL2hyX2JyaWNrL2luZmVybm8vYnJpY2tfZjEudnRmqnZpZXdhbmdsZXOSykDdwqzKQymXkKhwb3NpdGlvbpPKQ8zDtcrEy9m4ysNKVnOlY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZbNkZV9kdXN0L3N0b25lc3RlcDAxhax0ZXh0dXJlX3BhdGjZI2JyaWNrL2hyX2JyaWNrL2luZmVybm8vYnJpY2tfZjEudnRmqnZpZXdhbmdsZXOSykDdwsfKwkkvqKhwb3NpdGlvbpPKxI1st8rC2IJaysJXYAClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZbZjc19pdGFseS9wbGFzdGVyd2FsbDA0hax0ZXh0dXJlX3BhdGixZ3JvdW5kL3Nub3cwMS52dGaqdmlld2FuZ2xlc5LKv6eJ5srCEypWqHBvc2l0aW9uk8rE0XpRysRZPYbKwyiHI6Vjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1l2SZtb2RlbHMvcHJvcHMvZGVfdmVydGlnby93b29kX3BhbGxldF8wMYWsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzksrCB6qxysKfa1OocG9zaXRpb26TysP4k+vKxMcY/8rCH+AApWNvbG9ylMz/zP/M/8z/rW1hdGVyaWFsX25hbWXZJGRlX21pcmFnZS9ocl9taXJhZ2UvbWlyYWdlX3BsYXN0ZXJfMYWsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykHSyHbKwzN0c6hwb3NpdGlvbpPKRDZKccpEG4F2ysMH+AClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZbpjb25jcmV0ZS9jb25jcmV0ZV9mbG9vcl8wNIWsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSykEfxBbKwwq456hwb3NpdGlvbpPKw28//MpEHBDjysKf8AClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdkqZGVfbWlyYWdlL3dvb2QvZGVfbWlyYWdlX3dvb2RfdmVyM19kaWZmdXNlhax0ZXh0dXJlX3BhdGjZI2JyaWNrL2hyX2JyaWNrL2luZmVybm8vYnJpY2tfZjEudnRmqnZpZXdhbmdsZXOSysIj9FvKwyCNM6hwb3NpdGlvbpPKw4Vnt8pEIcNpysKf8AClY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZdksbW9kZWxzL3Byb3BzL2RlX21pcmFnZS90b3dlcnRvcF9lL3Rvd2VydG9wX2WFrHRleHR1cmVfcGF0aLFncm91bmQvc25vdzAxLnZ0Zqp2aWV3YW5nbGVzkspB+pdYykMw+aSocG9zaXRpb26TysUOEsnKRBGzK8rDGdZPpWNvbG9ylMz/zP/M/8z/rW1hdGVyaWFsX25hbWXZN21hcHMvZGVfbWlyYWdlL2NvbmNyZXRlL2JsZW5kX2JsYWNrdG9wc2FuZF8wMV93dnRfcGF0Y2iFrHRleHR1cmVfcGF0aL5hcl9kaXp6eS9kaXp6eV9mYWNhZGVfbWFzay52dGaqdmlld2FuZ2xlc5LKQJ4i+MpCr9ZPqHBvc2l0aW9uk8rD+MamysTIHgzKwh/gAKVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1ltmRlX21pcmFnZS9kb29ycy9kb29yX2OFrHRleHR1cmVfcGF0aL5hcl9kaXp6eS9kaXp6eV9mYWNhZGVfbWFzay52dGaqdmlld2FuZ2xlc5LKv4+dP8pCug/iqHBvc2l0aW9uk8rCju8eysP1w/TKwyX4AKVjb2xvcpTM/8z/zP/M/61tYXRlcmlhbF9uYW1ltW1vZGVscy9jc19pdGFseS9kb29yYYWsdGV4dHVyZV9wYXRosWdyb3VuZC9zbm93MDEudnRmqnZpZXdhbmdsZXOSysHBY8LKwho2kKhwb3NpdGlvbpPKxGjAW8pDNvjuysMt/EilY29sb3KUzP/M/8z/zP+tbWF0ZXJpYWxfbmFtZbptb2RlbHMvcHJvcHMvZGVfZHVzdC9ydWcwM4WsdGV4dHVyZV9wYXRo2SNicmljay9ocl9icmljay9pbmZlcm5vL2JyaWNrX2YxLnZ0Zqp2aWV3YW5nbGVzkspAShDPysMjCJSocG9zaXRpb26TykSYJA3KxJVSCcrDTIMwpWNvbG9ylBwcHMz/rW1hdGVyaWFsX25hbWXZSm1hcHMvZGVfbWlyYWdlL2RlX21pcmFnZS9icmljay9kZV9taXJhZ2VfYnJpY2tfdmVyMl9ibGVuZF91cGRhdGVfd3Z0X3BhdGNo"
        };
        for v607, v608 in l_pairs_0(l_v194_5) do
            l_v200_2 = l_v192_4[v607];
            if l_v200_2 == nil then
                l_v200_2 = {};
                l_v192_4[v607] = l_v200_2;
            end;
            if l_v200_2.enabled == nil then
                l_v200_2.enabled = 1;
            end;
            v202 = l_base64_0.decode(v608);
            v202 = msgpack.unpack(v202);
            l_v200_2[l_v193_5] = {
                name = "Default", 
                textures = v202
            };
        end;
        l_v193_5 = nil;
        l_v194_5 = nil;
        l_v195_4 = {};
        l_v196_4 = {};
        l_v197_2 = function()
            -- upvalues: l_v192_4 (ref), v164 (ref), l_ipairs_0 (ref)
            local v609 = {};
            local v610 = l_v192_4[v164];
            if v610 == nil then
                return v609;
            else
                local v611 = v610[v610.enabled];
                if v611 == nil then
                    return v609;
                else
                    local l_textures_0 = v611.textures;
                    for _, v614 in l_ipairs_0(l_textures_0) do
                        local l_material_name_1 = v614.material_name;
                        local l_texture_path_0 = v614.texture_path;
                        local l_color_5 = v614.color;
                        if l_material_name_1 ~= nil and l_texture_path_0 ~= nil and l_color_5 ~= nil then
                            v609[#v609 + 1] = v614;
                        end;
                    end;
                    return v609;
                end;
            end;
        end;
        do
            local l_l_v196_4_0, l_l_v197_2_0, l_l_v198_3_0 = l_v196_4, l_v197_2, l_v198_3;
            l_l_v198_3_0 = function()
                -- upvalues: l_l_v197_2_0 (ref), l_v193_5 (ref), l_ipairs_0 (ref), l_remove_0 (ref), l_find_0 (ref), l_match_0 (ref), l_v190_6 (ref), l_v191_8 (ref), l_sub_0 (ref), l_format_0 (ref), l_get_materials_0 (ref), l_l_v196_4_0 (ref), l_v166_4 (ref), l_execute_after_0 (ref), l_v167_5 (ref), l_get_1 (ref)
                local v621 = {};
                local v622 = l_l_v197_2_0();
                if l_v193_5 ~= nil then
                    local l_material_name_2 = l_v193_5.material_name;
                    if l_material_name_2 ~= nil and l_v193_5.texture_path ~= nil and l_v193_5.color ~= nil then
                        for v624, v625 in l_ipairs_0(v622) do
                            if l_material_name_2 == v625.material_name then
                                l_remove_0(v622, v624);
                            end;
                        end;
                        v622[#v622 + 1] = l_v193_5;
                    end;
                end;
                local v626 = 0;
                for _, v628 in l_ipairs_0(v622) do
                    local l_material_name_3 = v628.material_name;
                    local v630 = l_find_0(l_material_name_3, "(_%-?%d+_%-?%d+_%-?%d+)$") ~= nil;
                    if v630 then
                        l_material_name_3 = l_match_0(l_material_name_3, "^(.-)_%-?%d+_%-?%d+_%-?%d+$");
                    end;
                    local l_texture_path_1 = v628.texture_path;
                    local l_color_6 = v628.color;
                    if l_v190_6 then
                        l_color_6 = l_v191_8;
                    end;
                    local v633 = l_sub_0(l_material_name_3, 1, 7) == "models/" and "VertexLitGeneric" or "LightmappedGeneric";
                    local v634 = {
                        ["$basetexture"] = l_texture_path_1, 
                        ["$color"] = l_format_0("{ %s %s %s }", l_color_6[1], l_color_6[2], l_color_6[3])
                    };
                    if v630 then
                        local v635 = l_get_materials_0(l_material_name_3);
                        for _, v637 in l_ipairs_0(v635) do
                            local v638 = v637:get_name();
                            local v639 = l_l_v196_4_0[v638];
                            local v640 = v639 == nil;
                            if not v640 then
                                if v639.texture_path ~= l_texture_path_1 then
                                    v640 = true;
                                end;
                                if v639.texture_color ~= l_color_6 then
                                    v640 = true;
                                end;
                            end;
                            if v640 then
                                local v641 = v637:get_texture_group_name();
                                local v642 = l_v166_4(v638, v641);
                                if v642 ~= nil then
                                    l_execute_after_0(0.01 * v626, l_v167_5, v642, v633, v634);
                                    v626 = v626 + 1;
                                end;
                            end;
                            l_l_v196_4_0[v638] = {
                                texture_group_name = texture_group_name, 
                                texture_path = l_texture_path_1, 
                                texture_color = l_color_6
                            };
                            v621[v638] = true;
                        end;
                    else
                        local v643 = l_get_1(l_material_name_3);
                        local v644 = v643:get_name();
                        local v645 = l_l_v196_4_0[v644];
                        local v646 = v645 == nil;
                        if not v646 then
                            if v645.texture_path ~= l_texture_path_1 then
                                v646 = true;
                            end;
                            if v645.texture_color ~= l_color_6 then
                                v646 = true;
                            end;
                        end;
                        if v646 then
                            local v647 = v643:get_texture_group_name();
                            local v648 = l_v166_4(v644, v647);
                            if v648 ~= nil then
                                l_execute_after_0(0.01 * v626, l_v167_5, v648, v633, v634);
                                v626 = v626 + 1;
                            end;
                        end;
                        l_l_v196_4_0[v644] = {
                            texture_group_name = texture_group_name, 
                            texture_path = l_texture_path_1, 
                            texture_color = l_color_6
                        };
                        v621[v644] = true;
                    end;
                end;
                return v621;
            end;
            l_v194_5 = function()
                -- upvalues: v164 (ref), l_l_v198_3_0 (ref), l_pairs_0 (ref), l_l_v196_4_0 (ref), l_v166_4 (ref), l_execute_after_0 (ref), l_v167_5 (ref), l_v189_5 (ref)
                if v164 == nil then
                    return;
                elseif not globals.is_in_game then
                    return;
                else
                    local v649 = l_l_v198_3_0();
                    local v650 = 0;
                    local v651 = 0;
                    for v652, v653 in l_pairs_0(l_l_v196_4_0) do
                        if v649[v652] == nil then
                            local v654 = l_v166_4(v652, v653.texture_group_name);
                            do
                                local l_v654_0 = v654;
                                if l_v654_0 ~= nil then
                                    l_execute_after_0(0.01 * v650, function()
                                        -- upvalues: v651 (ref), l_v167_5 (ref), l_v654_0 (ref), v650 (ref), l_v189_5 (ref), l_execute_after_0 (ref)
                                        v651 = v651 + 1;
                                        l_v167_5(l_v654_0);
                                        if v650 == v651 then
                                            cvar.mat_reloadallmaterials:call();
                                            l_v189_5:override(color());
                                            l_execute_after_0(0.01, l_v189_5.override, l_v189_5);
                                        end;
                                    end);
                                    v650 = v650 + 1;
                                end;
                                l_l_v196_4_0[v652] = nil;
                            end;
                        end;
                    end;
                    return;
                end;
            end;
        end;
        l_v195_4 = nil;
        l_v196_4 = "\a{Link Active}\239\131\190\aDEFAULT   ";
        l_v197_2 = "\a{Link Active}\239\133\134\aDEFAULT   ";
        do
            local l_l_v196_4_1, l_l_v197_2_1 = l_v196_4, l_v197_2;
            l_v195_4 = function(v658)
                -- upvalues: l_ipairs_0 (ref), l_l_v196_4_1 (ref), l_l_v197_2_1 (ref), l_v165_5 (ref), l_execute_after_0 (ref), l_v194_5 (ref)
                local v659 = {};
                local l_enabled_3 = v658.enabled;
                for v661, v662 in l_ipairs_0(v658) do
                    local v663 = v661 == l_enabled_3;
                    v659[#v659 + 1] = (v663 and l_l_v196_4_1 or l_l_v197_2_1) .. v662.name;
                end;
                v659[#v659 + 1] = "+ Create New";
                l_v165_5.presets:update(v659);
                l_execute_after_0(0.01, l_v165_5.presets.set, l_v165_5.presets, 1);
                l_v194_5();
            end;
        end;
        l_v196_4 = nil;
        l_v196_4 = function()
            -- upvalues: v164 (ref), l_v192_4 (ref), l_v195_4 (ref)
            if v164 == nil then
                return;
            else
                local v664 = l_v192_4[v164];
                if v664 == nil then
                    v664 = {
                        enabled = 1, 
                        [1] = {
                            name = "Default ~ Soon", 
                            textures = {}
                        }
                    };
                    l_v192_4[v164] = v664;
                end;
                l_v195_4(v664);
                return;
            end;
        end;
        l_v196_4();
        v83(l_v196_4);
        events.level_init(l_v196_4);
        l_v165_5.preset_enabled:set_callback(function(v665)
            -- upvalues: v164 (ref), l_v165_5 (ref), l_v192_4 (ref), l_v196_4 (ref)
            if v164 == nil then
                return;
            else
                local v666 = l_v165_5.presets:get();
                local v667 = l_v192_4[v164];
                local v668 = v665:get();
                local v669 = v666 == v667.enabled;
                if v669 == v668 then
                    return;
                else
                    v667.enabled = v666;
                    if v669 and not v668 then
                        v667.enabled = 0;
                    end;
                    l_v196_4();
                    return;
                end;
            end;
        end);
        l_v165_5.presets:set_callback(function(v670)
            -- upvalues: v164 (ref), l_v192_4 (ref), l_v165_5 (ref)
            if v164 == nil then
                return;
            else
                local v671 = l_v192_4[v164];
                local v672 = v670:get() == v671.enabled;
                l_v165_5.preset_enabled:set(v672);
                return;
            end;
        end, true);
        l_v165_5.preset_create:set_callback(function()
            -- upvalues: v164 (ref), l_v192_4 (ref), l_v165_5 (ref), l_gsub_0 (ref), l_v195_4 (ref)
            if v164 == nil then
                return;
            else
                local v673 = l_v192_4[v164];
                if v673 == nil then
                    v673 = {
                        enabled = 1, 
                        [1] = {
                            name = "Default ~ Soon", 
                            textures = {}
                        }
                    };
                    l_v192_4[v164] = v673;
                end;
                local v674 = l_v165_5.preset_name:get();
                if l_gsub_0(v674, " ", "") == "" then
                    v674 = "Unnamed";
                end;
                v673[#v673 + 1] = {
                    enabled = true, 
                    name = v674, 
                    textures = {}
                };
                l_v195_4(v673);
                db["World Editor::Textures"] = l_v192_4;
                return;
            end;
        end);
        l_v165_5.preset_delete:set_callback(function()
            -- upvalues: v164 (ref), l_v165_5 (ref), l_v192_4 (ref), l_remove_0 (ref), l_v196_4 (ref), l_v194_5 (ref)
            if v164 == nil then
                return;
            else
                local v675 = l_v165_5.presets:get();
                local v676 = l_v192_4[v164];
                l_remove_0(v676, v675);
                l_v196_4(v676);
                l_v194_5();
                db["World Editor::Textures"] = l_v192_4;
                return;
            end;
        end);
        l_v197_2 = nil;
        l_v198_3 = nil;
        l_v199_0 = nil;
        l_v199_0 = function()
            -- upvalues: l_v197_2 (ref), v164 (ref), l_v192_4 (ref), l_ipairs_0 (ref), l_v165_5 (ref), l_v198_3 (ref)
            if l_v197_2 == nil then
                return;
            elseif v164 == nil then
                return;
            else
                local l_textures_1 = l_v192_4[v164][l_v197_2].textures;
                local v678 = {};
                for _, v680 in l_ipairs_0(l_textures_1) do
                    v678[#v678 + 1] = v680.material_name;
                end;
                v678[#v678 + 1] = "+ Create New";
                l_v165_5.preset_editing_list:update(v678);
                l_v165_5.preset_editing_list:set(l_v198_3 or 1);
                return;
            end;
        end;
        l_v165_5.preset_editing_list:set_callback(function(v681)
            -- upvalues: l_v198_3 (ref)
            l_v198_3 = v681:get();
        end);
        l_v165_5.preset_edit:set_callback(function()
            -- upvalues: v164 (ref), l_v192_4 (ref), l_v197_2 (ref), l_v165_5 (ref), l_v199_0 (ref)
            if v164 == nil then
                return;
            else
                local l_enabled_4 = l_v192_4[v164].enabled;
                l_v197_2 = l_v165_5.presets:get();
                if l_v197_2 ~= l_enabled_4 then
                    l_v165_5.back:set(1);
                    l_v197_2 = nil;
                    return;
                else
                    l_v199_0();
                    return;
                end;
            end;
        end);
        l_v165_5.back:set_callback(function()
            -- upvalues: l_v197_2 (ref), l_v193_5 (ref), l_v194_5 (ref)
            l_v197_2 = nil;
            l_v193_5 = nil;
            debug_props = false;
            l_v194_5();
        end);
        v83(function()
            -- upvalues: l_v165_5 (ref)
            l_v165_5.back:set(1);
        end);
        l_v200_2 = nil;
        l_v201_0 = function()
            -- upvalues: l_v165_5 (ref), l_get_local_player_0 (ref), l_v200_2 (ref), l_v186_4 (ref)
            if not l_v165_5.is_editing then
                return;
            elseif not l_v165_5.is_editing_create_new then
                return;
            elseif l_v165_5.is_material_selected then
                return;
            else
                local v683 = l_get_local_player_0();
                if v683 == nil or not v683:is_alive() then
                    return;
                else
                    l_v200_2 = l_v186_4();
                    l_v165_5.material_by_crosshair:name("Material By Crosshair: " .. l_v200_2);
                    return;
                end;
            end;
        end;
        events.createmove(l_v201_0);
        l_v201_0 = l_v165_5.textures_group_lists;
        l_v165_5.select_material_by_crosshair:set_callback(function()
            -- upvalues: l_v200_2 (ref), l_v192_4 (ref), v164 (ref), l_ipairs_0 (ref), l_v165_5 (ref), l_v193_5 (ref)
            if l_v200_2 == nil then
                return;
            else
                local v684 = l_v192_4[v164];
                if v684 == nil then
                    return loaded_textures;
                else
                    local v685 = v684[v684.enabled];
                    if v685 == nil then
                        return loaded_textures;
                    else
                        local l_textures_2 = v685.textures;
                        for v687, v688 in l_ipairs_0(l_textures_2) do
                            if v688.material_name == l_v200_2 then
                                l_v165_5.preset_editing_list:set(v687);
                                return;
                            end;
                        end;
                        l_v193_5 = {
                            material_name = l_v200_2
                        };
                        l_v165_5.selected_material:name("Selected Material: " .. l_v200_2);
                        return;
                    end;
                end;
            end;
        end);
        l_v165_5.texture_select:set_callback(function()
            -- upvalues: l_v193_5 (ref), l_get_local_player_0 (ref), l_camera_angles_0 (ref), l_v165_5 (ref), l_v201_0 (ref), v44 (ref), l_gsub_0 (ref), l_v194_5 (ref)
            if l_v193_5 == nil then
                return;
            else
                local v689 = l_get_local_player_0();
                if v689 == nil or not v689:is_alive() then
                    return;
                else
                    local v690 = v689:get_origin();
                    local v691 = l_camera_angles_0();
                    l_v193_5.position = {
                        [1] = v690.x, 
                        [2] = v690.y, 
                        [3] = v690.z
                    };
                    l_v193_5.viewangles = {
                        [1] = v691.x, 
                        [2] = v691.y
                    };
                    local v692 = l_v165_5.textures_group:get();
                    local v693 = l_v201_0[v692]:get();
                    v693 = v44[v692][v693];
                    l_v193_5.texture_path = v693;
                    v693 = l_gsub_0(v693, ".vtf", "");
                    l_v165_5.selected_texture:name("Selected Texture: " .. v693);
                    l_v194_5();
                    return;
                end;
            end;
        end);
        v202 = function()
            -- upvalues: l_v193_5 (ref), l_v165_5 (ref), l_v201_0 (ref), v44 (ref), l_v194_5 (ref)
            if l_v193_5 == nil then
                return;
            else
                local v694 = l_v165_5.textures_group:get();
                local v695 = l_v201_0[v694]:get();
                l_v193_5.texture_path = v44[v694][v695];
                l_v194_5();
                return;
            end;
        end;
        l_v165_5.select_texture:set_callback(function()
            -- upvalues: l_v165_5 (ref)
            l_v165_5.textures_group:reset();
            l_v165_5.color:reset();
        end);
        l_v165_5.textures_group:set_callback(v202);
        for _, v697 in l_pairs_0(l_v201_0) do
            v697:set_callback(v202);
        end;
        l_v165_5.color:set_callback(function(v698)
            -- upvalues: l_v193_5 (ref), l_v194_5 (ref)
            if l_v193_5 == nil then
                return;
            else
                local v699 = v698:get();
                l_v193_5.color = {
                    [1] = v699.r, 
                    [2] = v699.g, 
                    [3] = v699.b, 
                    [4] = v699.a
                };
                l_v194_5();
                return;
            end;
        end);
        l_v165_5.preset_editing_list:set_callback(function(_)
            -- upvalues: l_v197_2 (ref), l_v198_3 (ref), v164 (ref), l_v192_4 (ref), l_v193_5 (ref), v162 (ref), l_v165_5 (ref), l_gsub_0 (ref)
            if l_v197_2 == nil or l_v198_3 == nil then
                return;
            elseif v164 == nil then
                return;
            else
                local v701 = l_v192_4[v164][l_v197_2].textures[l_v198_3];
                if v701 == nil then
                    return;
                else
                    l_v193_5 = v162(v701);
                    l_v165_5.selected_material:name("Selected Material: " .. l_v193_5.material_name);
                    local l_texture_path_2 = l_v193_5.texture_path;
                    l_texture_path_2 = l_gsub_0(l_texture_path_2, ".vtf", "");
                    l_v165_5.selected_texture:name("Selected Texture: " .. l_texture_path_2);
                    local l_color_7 = l_v193_5.color;
                    l_v165_5.color:set(color(l_color_7[1], l_color_7[2], l_color_7[3], l_color_7[4]));
                    return;
                end;
            end;
        end);
        l_v165_5.texture_teleport:set_callback(function()
            -- upvalues: l_v197_2 (ref), l_v198_3 (ref), l_v193_5 (ref), v164 (ref), l_v192_4 (ref), l_format_0 (ref)
            if l_v197_2 == nil or l_v198_3 == nil then
                return;
            elseif l_v193_5 == nil then
                return;
            elseif l_v193_5.material_name == nil or l_v193_5.texture_path == nil or l_v193_5.color == nil then
                return;
            elseif v164 == nil then
                return;
            else
                local v704 = l_v192_4[v164][l_v197_2].textures[l_v198_3];
                local l_position_9 = v704.position;
                local l_viewangles_0 = v704.viewangles;
                utils.console_exec(l_format_0("noclip off; setpos_exact %s %s %s; setang %s %s", l_position_9[1], l_position_9[2], l_position_9[3], l_viewangles_0[1], l_viewangles_0[2]));
                return;
            end;
        end);
        l_v165_5.texture_save:set_callback(function()
            -- upvalues: l_v197_2 (ref), l_v198_3 (ref), l_v193_5 (ref), v164 (ref), l_v192_4 (ref), v162 (ref), l_v199_0 (ref), l_v194_5 (ref)
            if l_v197_2 == nil or l_v198_3 == nil then
                return;
            elseif l_v193_5 == nil then
                return;
            elseif l_v193_5.material_name == nil or l_v193_5.texture_path == nil or l_v193_5.color == nil then
                return;
            elseif v164 == nil then
                return;
            else
                l_v192_4[v164][l_v197_2].textures[l_v198_3] = v162(l_v193_5);
                l_v193_5 = nil;
                l_v199_0();
                l_v194_5();
                db["World Editor::Textures"] = l_v192_4;
                return;
            end;
        end);
        l_v165_5.preset_editing_delete:set_callback(function()
            -- upvalues: l_v197_2 (ref), l_v198_3 (ref), v164 (ref), l_v192_4 (ref), l_remove_0 (ref), l_v193_5 (ref), l_v199_0 (ref), l_v194_5 (ref)
            if l_v197_2 == nil or l_v198_3 == nil then
                return;
            elseif v164 == nil then
                return;
            else
                local l_textures_3 = l_v192_4[v164][l_v197_2].textures;
                l_remove_0(l_textures_3, l_v198_3);
                l_v193_5 = nil;
                l_v199_0();
                l_v194_5();
                db["World Editor::Textures"] = l_v192_4;
                return;
            end;
        end);
        events.shutdown(function()
            -- upvalues: l_v192_4 (ref)
            db["World Editor::Textures"] = l_v192_4;
        end);
    end;
end;
utils.execute_after(0.05, function()
    -- upvalues: v0 (ref)
    local l_status_0, l_result_0 = pcall(v0);
    if not l_status_0 then
        print_error(l_result_0);
    end;
end);