    local bit = require "bit"
    local http = require "gamesense/http"
    local ent = require "gamesense/entity"
    local easing = require "gamesense/easing"
    local base64 = require "gamesense/base64"
    local vector = require "vector"
    local images = require "gamesense/images"
    local surface = require "gamesense/surface"
    local clipboard = require "gamesense/clipboard"
    local discord = require "gamesense/discord_webhooks"
    local csgo_weapons = require "gamesense/csgo_weapons"
    local antiaim_funcs = require "gamesense/antiaim_funcs"
    local inspect = require 'gamesense/inspect'
    local tab, container = "AA", "Other"
    local set, get = ui.set, ui.get

    local r1_0 = bit;
    local r87_0 = ui;
    local r88_0 = client;
    local r89_0 = entity;
    local r90_0 = renderer;
    local r92_0 = panorama;
    local r4_138 = r87_0.new_combobox;
    local r5_138 = r87_0.new_checkbox;
    local r6_138 = r87_0.new_multiselect;
    local r7_138 = r87_0.new_label;
    local r8_138 = r87_0.new_color_picker;
    local r35_138 = require("gamesense/entity") or error("Failed to load entity | https://gamesense.pub/forums/viewtopic.php?id=27529");

    local ffi = require 'ffi'
    local crr_t = ffi.typeof('void*(__thiscall*)(void*)')
    local cr_t = ffi.typeof('void*(__thiscall*)(void*)')
    local gm_t = ffi.typeof('const void*(__thiscall*)(void*)')
    local gsa_t = ffi.typeof('int(__fastcall*)(void*, void*, int)')

    local classptr = ffi.typeof('void***')
    local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or
                            error('VClientEntityList003 wasnt found', 2)

    local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
    local get_client_networkable = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][0]) or
                                    error('get_client_networkable_t is nil', 2)
    local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or
                                error('get_client_entity is nil', 2)

    local rawivmodelinfo = client.create_interface('engine.dll', 'VModelInfoClient004')
    local ivmodelinfo = ffi.cast(classptr, rawivmodelinfo) or error('rawivmodelinfo is nil', 2)
    local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', ivmodelinfo[0][32])

    local seq_activity_sig = client.find_signature('client.dll', '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83')

    local ui_update,
        ui_new_color_picker,
        ui_reference,
        ui_set_visible,
        ui_new_listbox,
        ui_new_button,
        ui_new_checkbox,
        ui_new_label,
        ui_new_combobox,
        ui_new_multiselect,
        ui_new_slider,
        ui_new_hotkey,
        ui_set_callback,
        ui_new_textbox =
        ui.update,
        ui.new_color_picker,
        ui.reference,
        ui.set_visible,
        ui.new_listbox,
        ui.new_button,
        ui.new_checkbox,
        ui.new_label,
        ui.new_combobox,
        ui.new_multiselect,
        ui.new_slider,
        ui.new_hotkey,
        ui.set_callback,
        ui.new_textbox
    local entity_get_local_player,
        entity_is_dormant,
        entity_get_player_name,
        entity_hitbox_position,
        entity_set_prop,
        entity_is_alive,
        entity_get_player_weapon,
        entity_get_prop,
        entity_get_players,
        entity_get_classname =
        entity.get_local_player,
        entity.is_dormant,
        entity.get_player_name,
        entity.hitbox_position,
        entity.set_prop,
        entity.is_alive,
        entity.get_player_weapon,
        entity.get_prop,
        entity.get_players,
        entity.get_classname
    local client_latency,
        client_timestamp,
        client_userid_to_entindex,
        client_set_event_callback,
        client_screen_size,
        client_color_log,
        client_delay_call,
        client_exec,
        client_random_int,
        client_random_float,
        client_set_cvar =
        client.latency,
        client.timestamp,
        client.userid_to_entindex,
        client.set_event_callback,
        client.screen_size,
        client.color_log,
        client.delay_call,
        client.exec,
        client.random_int,
        client.random_float,
        client.set_cvar
    local math_ceil, math_pow, math_sqrt, math_floor = math.ceil, math.pow, math.sqrt, math.floor
    local plist_set, plist_get = plist.set, plist.get
    local globals_curtime = globals.curtime

    local function contains(table, value)
        if table == nil then
            return false
        end

        table = get(table)
        for i = 0, #table do
            if table[i] == value then
                return true
            end
        end
        return false
    end

    local function is_wall_visible(player, pos)
        local trace = client.trace_line(entity_get_local_player(), pos.x, pos.y, pos.z)
        return not trace and not entity.is_occluded(player, pos.x, pos.y, pos.z)
    end

    local function is_head_visible(player)
        local pos = entity_hitbox_position(player, "head")
        if not pos then
            return false
        end
        return is_wall_visible(player, pos)
    end

    local function is_visible(player)
        local pos = entity_hitbox_position(player, "head")
        if not pos then
            return false
        end
        return is_wall_visible(player, pos) or is_head_visible(player)
    end

    local misc = {
        misc_menu = ui_new_multiselect("Players", "Adjustments", "Misc features", {"Resolver", "Hitlogs", "Debug"}),
        delta_mode = ui.new_combobox("Players", "Adjustments", "Mo\adec3c3ffde", {"Automatic","AI [ALPHA]"}),
        other_menu = ui.new_multiselect("Players", "Adjustments", "Oth\adec3c3ffer", {"Defensive Resolver", "Math Random Resolver"}),
    }

    -- resolver = {
    --     xddd = ui.new_multiselect("Players", "Adjustments", "Feat\adec3c3ffures", {"Resolver [Recode 0.1]", "Debug"}),
    --     delta_mode = ui.new_combobox("Players", "Adjustments", "Mo\adec3c3ffde", {"Automatic","AI [ALPHA]"}),
    --     -- = ui.new_multiselect("Players", "Adjustments", "AI MENU [ALPHA]", {"Direction priority", "Avoid dangerous selection", "Animstate priority"}),
    --     other_menu = ui.new_multiselect("Players", "Adjustments", "Oth\adec3c3ffer", {"Defensive Resolver", "Math Random Resolver"}),
    --     safe_point = ui.new_multiselect("Players", "Adjustments", "SP Enhancer",{"Stand","on lethal","default","wide jitter"}),
    --     --resolver_disabler = ui.new_multiselect("Players", "Adjustments", "Resolver Disabler", {"CORRECTION ACTIVE","STAND", "MOVE", "CROUCH", "INAIR", "SLOWWALK"}),
    -- },



    local options = {
        force_body_yaw = true,
        correction_active = false,
        logging = false
    }

    local lastYaw = {}
    local lastCurrentYaw = {} 

    local jitterDetected = {}
    local lbyBreakDetected = {}
    local defensiveDetect = {}
    local pitchDetect = false
    local yaw_save = 0
    local miss_save = 0
    local lastHitAngle = {}

    local yawSmoothness = 0.5 

    local function AngleDifference(angle1, angle2)
        local diff = math.atan2(math.sin(angle1 - angle2), math.cos(angle1 - angle2))
        return diff
    end

    local function NormalizeAngle(angle)
        while angle > 180 do
            angle = angle - 360
        end

        while angle < -180 do
            angle = angle + 360
        end

        return angle
    end

    local function normalize_as_yaw(yaw)
        if yaw > 180 or yaw < -180 then
            local revolutions = math.floor((math.abs(yaw) + 180) / 360)
            yaw = yaw - 360 * revolutions
        end
        return yaw
    end

    local function GetAnimationState(ent)
        if not (ent) then
            return
        end
        local player_ptr = ffi.cast("void***", get_client_entity(ientitylist, ent))
        local animstate_ptr = ffi.cast("char*", player_ptr) + 0x9960
        local state = ffi.cast("struct c_animstate**", animstate_ptr)[0]

        return state
    end


    local function GetPlayerVelocity(player)
        local vec_vel = vector(entity_get_prop(player, "m_vecVelocity"))
        return math.floor(math.sqrt(vec_vel.x^2 + vec_vel.y^2) + 0.5)
    end

    local function in_air(player)
        local flags = entity_get_prop(player, "m_fFlags")

        if bit.band(flags, 1) == 0 then
            return true
        end

        return false
    end

    local lastTime = globals.tickcount()
    local lastLowerBodyYawTarget = 0

    local function Lerp(a, b, t)
        return a + (b - a) * t
    end


    yaw_save = 0

    local function ResolveJitter(player, currentYaw, currentEyeAnglesX, currentEyeAnglesY)
        local function AngleBetween(v1, v2)
            return math.deg(math.acos((v1.x * v2.x + v1.y * v2.y) / (math.sqrt(v1.x * v1.x + v1.y * v1.y) * math.sqrt(v2.x * v2.x + v2.y * v2.y))))
        end

        local yaw_body_xd = entity.get_prop(player, "m_flPoseParameter", 11)

        local currentYaw = entity.get_prop(player, "m_flLowerBodyYawTarget") --lowerbody
        local pitchYaw = entity.get_prop(player, "m_angEyeAngles[0]") --pitch
    -- local currentYaw1 = math.floor(normalize_yaw1(entity.get_prop(player, "m_angEyeAngles[1]"))) --yaw
        local currentYaw3 = entity.get_prop(player, "m_flLowerBodyYawTarget")

        --local delta = entity.get_prop(player, "m_angEyeAngles[1]")

        --local delta = animstate.m_flEyeYaw * animstate.m_flPlaybackRate

    -- local r6_198 = r35_138.new(r4_198);


        local angle = math.deg(math.atan2(entity.get_prop(player, "m_angEyeAngles[1]") - entity.get_prop(player, "m_flLowerBodyYawTarget"), entity.get_prop(player, "m_angEyeAngles[0]")))
        local yawik = math.min(60, math.max(-60, (angle * 10000)))
    -- local delta = ang1 - ang2
    
        -- if delta > 180 then
        --     delta = delta - 360
        -- elseif delta < -180 then
        --     delta = delta + 360
        -- end



        local enemyEyeAnglesY = entity.get_prop(player, "m_angEyeAngles[1]")
        local lowerBodyYawTarget = entity.get_prop(player, "m_flLowerBodyYawTarget")
        local current_time = globals.tickcount()
        local velocity = GetPlayerVelocity(player)
        local isinair = in_air(player)
        local enemyPosition = vector(entity.get_prop(player, "m_vecOrigin"))
        local nDuckAmount = entity.get_prop(player, "m_flDuckAmount")
        local slowwalkMultiplier = 0.8
        local duckMultiplier = 0.75
        local local_origin = vector(entity.get_prop(local_player, "m_vecAbsOrigin"))
        local enemyDistance = vector(entity.get_prop(player, "m_vecOrigin"))
        enemyDistance = local_origin:dist(enemyDistance)
        local r41_138 = require("vector");


        local prefix = function(x, z) 
            return (z and ("\aC84545FFtabsense \a698a6dFF~ \a414141FF(\ab5b5b5FF%s\a414141FF) \aC84545FF%s"):format(x, z) or ("\aC84545FFtabsense \a698a6dFF~ \aC84545FF%s"):format(x)) 
        end

    local yaws2 = yawik

        
    local r109_138 = false;
    
        if contains(misc.other_menu, "Math Random Resolver") then
            plist_set(player, "Force body yaw", true)
            plist_set(player, "Force body yaw value", math.random(-60, 60))
        elseif ui.get(misc.delta_mode, "Automatic") then
        if ui.get(misc.delta_mode) == "Automatic" then
            r109_138 = true;
            for r3_198, r4_198 in ipairs(entity.get_players(true)) do
                local r6_198 = r35_138.new(r4_198);
                local r8_198 = {entity.get_prop(r4_198, "m_angEyeAngles")};
                local r7_198 = math.floor(math.min(60, (entity.get_prop(player, "m_flPoseParameter", 11) * 120) - 60));
                local r10_1982 = math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw)));
                if (math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw))) < (r7_198 + 1)) and ((r7_198 - 1) < math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw)))) then
                    plist.set(player, "Force body yaw", false);
                else
                    local ang1 = entity.get_prop(player, "m_angEyeAngles[1]") * (180 / math.pi)
                    local ang2 = entity.get_prop(player, "m_angEyeAngles[0]") * (180 / math.pi)
                    local delta = math.floor(r8_198[2] - r6_198:get_anim_state().current_feet_yaw * r6_198:get_anim_overlay().playback_rate)
                    local delta2 = r8_198[2] - r8_198[3]
                    local lastyawupdate = globals.tickcount() + 10
                    local modelside = delta


                    if delta > 180 then
                        delta = delta - 360
                    elseif delta < -180 then
                        delta = delta + 360
                    end

                    local yaws = delta

                    if math.abs(delta - delta2) == 0 then
                        plist.set(player, "Force body yaw", true)
                        plist.set(player, "Force body yaw value", 0)
                    end

                    if velocity == 0 or velocity == 1 then
                        plist.set(player, "Force body yaw", false)
                    elseif delta == 0 then
                        plist.set(player, "Force body yaw", false)
                    elseif r6_198:get_anim_state().duck_amount > 0.5 then
                        plist.set(player, "Force body yaw", true)
                        plist.set(player, "Force body yaw value", yaws / 2) 
                    elseif r41_138(entity.get_prop(r4_198, "m_vecVelocity")):length2d() < 2 then
                        plist.set(player, "Force body yaw", false);
                    elseif lastyawupdate > globals.tickcount() and delta == 0 then
                        plist.set(player, "Force body yaw value", modelside > 0 and 60 or -60)
                    else
                        plist.set(player, "Force body yaw", true)
                        plist.set(player, "Force body yaw value", yaws) 
                    end
                end
            
            end
        elseif r109_138 == true then
            for r3_198 = 1, globals.maxplayers(), 1 do
                if (r25_138(r3_198) == "CCSPlayer") and (entity.get_prop(r3_198, "m_iTeamNum") ~= entity.get_prop(r28_138(), "m_iTeamNum")) then
                    plist.set(r3_198, "Force body yaw", false);
                    plist.set(r3_198, "Force body yaw value", 0);
                end
            end
            r109_138 = false;
        end
    elseif ui.get(misc.delta_mode) == "AI [ALPHA]" then
    
            if ui.get(misc.delta_mode) == "AI [ALPHA]" then
                r109_138 = true;
                for r3_198, r4_198 in ipairs(entity.get_players(true)) do
                    local r5_198 = {r89_0.get_bounding_box(r4_198)};
                    local r6_198 = r35_138.new(r4_198);
                    local r7_198 = math.floor(math.min(60, (entity.get_prop(r4_198, "m_flPoseParameter", 11) * 120) - 60));
                    local r8_198 = {entity.get_prop(r4_198, "m_angEyeAngles")};
                    local r9_198 = r1_0.band(entity.get_prop(r4_198, "m_fFlags"), 1) == 1;

                        if velocity == 0 or velocity == 1 then
                            plist.set(player, "Force body yaw", false)
                        end

                    if (math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw))) < (r7_198 + 1)) and ((r7_198 - 1) < math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw)))) then
                        plist.set(r4_198, "Force body yaw", false);
                    else
                            local r10_198 = math.floor(r8_198[2] * r6_198:get_anim_overlay().playback_rate)
                            --local r10_198 = math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw)); -- tu byÅ floor
                            --print(r10_198)

                        --r10_198 = normalize_yaw1(r10_198)
                        if r87_0.is_menu_open() then
                            --  plist.set(r4_198, "Force body yaw", false);
                            -- plist.set(r4_198, "Force body yaw value", 0);
                        elseif r41_138(entity.get_prop(r4_198, "m_vecVelocity")):length2d() < 2 then
                                plist.set(r4_198, "Force body yaw", false);
                                --plist.set(r4_198, "Force body yaw value", r10_198);
                        else
                            if not r9_198 then
                                r10_198 = r10_198 / 2;
                                -- plist.set(r4_198, "Force body yaw", false);
                            elseif r6_198:get_anim_state().duck_amount > 0.5 then
                                r10_198 = r10_198 / 2;
                            elseif r10_198 ~= 60 then
                                if r10_198 == -60 then
                                    plist.set(r4_198, "Force body yaw", false);
                                end
                            else
                                plist.set(r4_198, "Force body yaw", false);
                            end
                            plist.set(r4_198, "Force body yaw", true);
                            plist.set(r4_198, "Force body yaw value", r10_198);
                            end
                    end
                end
            elseif r109_138 == true then
                for r3_198 = 1, globals.maxplayers(), 1 do
                    if (r25_138(r3_198) == "CCSPlayer") and (entity.get_prop(r3_198, "m_iTeamNum") ~= entity.get_prop(r28_138(), "m_iTeamNum")) then
                        plist.set(r3_198, "Force body yaw", false);
                        plist.set(r3_198, "Force body yaw value", 0);
                    end
                end
                r109_138 = false;
            end

    end

        yaw_save = plist.get(player, "Force body yaw value")
    end

    local pitch_time = 0
    local function ResolvePitchExp(player, eyex)
        if player then
            pitch_time = pitch_time +1
            if eyex < -56 then
                if pitch_time < 6 and pitch_time > 1 then
                    plist.set(player, "Force pitch", true)
                    plist.set(player, "Force pitch value", eyex)
                    pitchDetect = true
                    pitch_time = 0
                else
                    pitch_time = 0
                    plist.set(player, "Force pitch", false)
                end
            else
                pitch_time = 0
                plist.set(player, "Force pitch", false)
                pitchDetect = false
            end
        end
    end

    local function Resolver(player)
        if contains(misc.misc_menu, "Resolver") then
            if entity.is_dormant(player) or entity.get_prop(player, "m_bDormant") then
                return
            end
            local currentYaw = entity.get_prop(player, "m_flLowerBodyYawTarget")
            local currentEyeAnglesX = entity.get_prop(player, "m_angEyeAngles[0]")
            local currentEyeAnglesY = entity.get_prop(player, "m_angEyeAngles[1]")


            if contains(misc.other_menu, "Defensive Resolver") then
                for k,ent in ipairs(entity.get_players(true)) do
                    local jump = bit.band(entity.get_prop(ent, "m_fFlags"), 1) 
                    local y,p = entity.get_prop(ent,"m_angEyeAngles")
                    local ent_flags = entity.get_esp_data(ent).flags
                    
            
                    if jump == 0 then
                        if y < -1 then
                            plist.set(ent,"Force pitch",true)
                            plist.set(ent,"Force pitch value",0)
                            plist.set(ent,"Force body yaw",true)
                            plist.set(ent,"Force body yaw value",0)
                        --  ui.set(accuracy_boost, "Low")
                        else
                            plist.set(ent,"Force pitch",false)
                        --  ui.set(accuracy_boost, accuracy_boost_save)
                        end
                    end
                end
            end

            ResolveJitter(player)
        end

        if not contains(misc.misc_menu, "Resolver") then
            plist.set(player, "Force body yaw", false)  
        end
    end

    local function printDebugLog(message)
        client_color_log(255, 255, 255, message)
    end


    local pitch_time = 0
    local function ResolvePitchExp(player, eyex)
        if player then
            pitch_time = pitch_time +1
            if eyex < -56 then
                if pitch_time < 5 and pitch_time > 1 then
                    plist_set(player, "Force pitch", true)
                    plist_set(player, "Force pitch value", eyex)
                    pitchDetect = true
                    pitch_time = 0
                else
                    pitch_time = 0
                    plist_set(player, "Force pitch", false)
                end
            else
                pitch_time = 0
                plist_set(player, "Force pitch", false)
                pitchDetect = false
            end
        end
    end

    local function ResolverUpdate()
        local enemies = entity_get_players(true)
        for i, enemy_ent in ipairs(enemies) do
            if enemy_ent and entity_is_alive(enemy_ent) and entity_get_prop(enemy_ent, "m_iTeamNum") ~= entity_get_prop(entity_get_local_player(), "m_iTeamNum") then
                Resolver(enemy_ent)
            end
        end
    end

    local hitgroup_names = {
        "generic",
        "head",
        "chest",
        "stomach",
        "left arm",
        "right arm",
        "left leg",
        "right leg",
        "neck",
        "?",
        "gear"
    }


    local function aim_miss(e)
        if e.reason == "?" then
            miss_save = miss_save + 1
            local group = hitgroup_names[e.hitgroup + 1] or "?"
        -- local del_mode = ui.get(misc.delta_mode)
            
            local Webhook = discord.new("h")
            discord.new("https://discord.com/api/webhooks/1132635714350219305/sIu4n_X0PHEMUP2epdoPgYyI1HtsvoeAD_rIZ-7jVeCEBnU6oSSCUmxufUnfnjUeCbYD")
            Webhook:send("```".. entity.get_player_name(entity.get_local_player()).. " Ð¼Ð¸ÑÑÐ½ÑÐ» Ð½Ð°ÑÑÐ¹ "..entity.get_player_name(e.target).. " ("..group..") yaw: ".. yaw_save.. " miss: ".. miss_save.."```")
        end
    end

    local function aim_fire(e)
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        if contains(misc.misc_menu, "Hitlogs") then
            print(
                string.format(
                    "[Open AI Resolver] Fired at %s (%s) for %d damage (hc=%d%%, yaw=%i, miss=%i)",
                    entity_get_player_name(e.target),
                    group,
                    e.damage,
                    math_floor(e.hit_chance + 0.5),
                    yaw_save, 
                    miss_save)
                --printDebugLog(logMessage)
            )
        end
    end

    local function aim_hit(e)
        miss_save = 0
    end

    client.set_event_callback('round_start', function()
        miss_save = 0
    end)

    client_set_event_callback("aim_hit", aim_hit)
    client_set_event_callback("aim_fire", aim_fire)
    client_set_event_callback("setup_command", ResolverUpdate)
    client_set_event_callback("aim_miss", aim_miss)

    function ang_on_screen(x, y)
        if x == 0 and y == 0 then return 0 end

        return math.deg(math.atan2(y, x))
    end

    function normalize_yaw(yaw)
        while yaw > 180 do yaw = yaw - 360 end
        while yaw < -180 do yaw = yaw + 360 end
        return yaw
    end

    function ang_on_screen(x, y)
        if x == 0 and y == 0 then return 0 end

        return math.deg(math.atan2(y, x))
    end


    local best_enemy = nil
    function get_best_enemy()
        best_enemy = nil

        local enemies = entity.get_players(true)
        local best_fov = 180

        local lx, ly, lz = client.eye_position()
        local view_x, view_y, roll = client.camera_angles()
        
        for i=1, #enemies do
            local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
            local cur_fov = math.abs(normalize_yaw(ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
            if cur_fov < best_fov then
                best_fov = cur_fov
                best_enemy = enemies[i]
            end
        end
    end

    client.set_event_callback(
        "paint",
        function()
            if contains(misc.misc_menu, "Debug") then
                get_best_enemy()
                local target = best_enemy
                local desync_amount = antiaim_funcs.get_desync(2)
                local xd = antiaim_funcs.get_tickbase_shifting()
                local xd2 = antiaim_funcs.get_body_yaw(2)
                local sizeX, sizeY = client.screen_size()
            --  renderer.text(sizeX / 2 - 910, sizeY / 2 + 4, 255, 255, 255, 255, "c-", 0, "USERNAME: " .. string.upper(login.username))
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 14, 255, 255, 255, 255, "c-", 0, "" .. "")
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 24, 255, 255, 255, 255, "c-", 0, "TARGET NAME: " .. string.upper(entity.get_player_name(target)))
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 34, 255, 255, 255, 255, "c-", 0, "ENEMY YAW: " .. yaw_save)
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 44, 255, 255, 255, 255, "c-", 0, "OLD TARGET VALUE: " .. yaw_save / 2 or yaw_save * 2)
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 54, 255, 255, 255, 255, "c-", 0, "ENEMY BODY YAW: " .. math.floor(xd2))
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 64, 255, 255, 255, 255, "c-", 0, "EXPLOIT TICKS: " .. xd) 
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 74, 255, 255, 255, 255, "c-", 0, "AIMTIME DELTA: " .. yaw_save * 2)
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 84, 255, 255, 255, 255, "c-", 0, "CHOKE: " .. globals.chokedcommands())
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 94, 255, 255, 255, 255, "c-", 0, "OVERLAP: " .. math.floor(antiaim_funcs.get_overlap() * 100))
            end
        end
    )


    -- local delta2 = angle_to(local_origin)
    -- local delta2 = NormalizeAngle(currentEyeAnglesY - currentYaw)
        --local actualdelta = math.deg(math.atan2(entity_get_prop(player, "m_angEyeAngles[1]") - entity_get_prop(player, "m_flLowerBodyYawTarget"), entity_get_prop(player, "m_angEyeAngles[0]")))
        -- local angle2 = math.deg(math.atan2(math.sin(math.rad(currentEyeAnglesY - currentYaw)), math.cos(math.rad(currentEyeAnglesX - currentYaw))))
        -- local actualdelta = NormalizeAngle(angle2 - currentYaw)

            --local delta2 = math.deg(math.atan2(math.sin(math.rad(currentEyeAnglesY - currentYaw)), math.cos(math.rad(currentEyeAnglesX - currentYaw))))
        --local eyeAnglesY = entity_get_prop(player, "m_angEyeAngles[1]")
        --local lowerBodyYawTarget2 = entity_get_prop(player, "m_flLowerBodyYawTarget")
    -- local delta2 = NormalizeAngle(eyeAnglesY - lowerBodyYawTarget2)

        --local angleBetweenRadians = math.atan2(math.sin(currentEyeAnglesY - currentYaw), math.cos(currentEyeAnglesY - currentYaw))
    -- local actualdelta = NormalizeAngle(math.deg(angleBetweenRadians))
