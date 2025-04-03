local json = require('json')

ffi.cdef[[
    typedef struct mask {
        char m_pDriverName[512];
        unsigned int m_VendorID;
        unsigned int m_DeviceID;
        unsigned int m_SubSysID;
        unsigned int m_Revision;
        int m_nDXSupportLevel;
        int m_nMinDXSupportLevel;
        int m_nMaxDXSupportLevel;
        unsigned int m_nDriverVersionHigh;
        unsigned int m_nDriverVersionLow;
        int64_t pad_0;
        union {
            int xuid;
            struct {
                int xuidlow;
                int xuidhigh;
            };
        };
        char name[128];
        int userid;
        char guid[33];
        unsigned int friendsid;
        char friendsname[128];
        bool fakeplayer;
        bool ishltv;
        unsigned int customfiles[4];
        unsigned char filesdownloaded;
    };
    typedef int(__thiscall* get_current_adapter_fn)(void*);
    typedef void(__thiscall* get_adapters_info_fn)(void*, int adapter, struct mask& info);
    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);
]]

local prim_version = 1 --Alpha
local current = {
    username = "y" .. "u" .. "." .. "k" .. "i" .. "h" .. "v" .. "h",
    build = "PDebug",
    sbuild = "Pasta",
}

local version_check = {
    name = {[0] = "live", [1] = "Beta"},
    yaw_type = {[0] = {"Static"}, [1] = {"Static", "Slow", "Skitter"}},
    def_yaw = {[0] = {"Off", "Default"}, [1] = {"Off", "Default", "SideWay", "Forward"}},
    def_pitch = {[0] = {"Off", "Custom"}, [1] = {"Off", "Custom", "Switch", "Random"}},
    access = {[0] = " [Beta]", [1] = ""}
}

math.lerp = function(name, value, speed)
    return name + (value - name) * globals.frame_time() * speed
end

local function active_weapon()
    if ragebot.get_active_cfg() == 0 then
        return "Auto"
    elseif ragebot.get_active_cfg() == 1 then
        return "Scout"
    elseif ragebot.get_active_cfg() == 2 then
        return "Awp"
    elseif ragebot.get_active_cfg() == 3 then 
        return "Deagle"
    elseif ragebot.get_active_cfg() == 4 then 
        return "Revolver"
    elseif ragebot.get_active_cfg() == 5 then 
        return "Pistols"
    else
        return "Other"
    end
end
local text1 = menu.add_text("Info", "Welcome Back\n")
local text2 = menu.add_text("Info","Pidrsense ["..version_check.name[prim_version].."]")
local text3 = menu.add_text("Info", "Yukihvh")

local tab = menu.add_selection("Tab", "Tab", {"Home", "Anti-Aim", "Other"})


local find = {
    yawadd = menu.find("antiaim","main","angles","yaw add"),
    yawbase = menu.find("antiaim","main","angles","yaw base"),
    
    overmove = menu.find("antiaim","main", "desync","Override Stand#move"),
    oversw = menu.find("antiaim","main", "desync","Override Stand#Slow Walk"),

    side_stand = menu.find("antiaim","main", "desync","side#stand"),
    llimit_stand = menu.find("antiaim","main", "desync","left amount#stand"),
    rlimit_stand = menu.find("antiaim","main", "desync","right amount#stand"),
    ab_stand = menu.find("antiaim","main", "desync","anti bruteforce"),
    side_move = menu.find("antiaim","main", "desync","side#move"),
    llimit_move = menu.find("antiaim","main", "desync","left amount#move"),
    rlimit_move = menu.find("antiaim","main", "desync","right amount#move"),
    side_slowm = menu.find("antiaim","main", "desync","side#slow walk"),
    llimit_slowm = menu.find("antiaim","main", "desync","left amount#slow walk"),
    rlimit_slowm = menu.find("antiaim","main", "desync","right amount#slow walk"),
    type_jit = menu.find("antiaim","main", "angles","jitter type"),
    mode_jit = menu.find("antiaim","main", "angles","jitter mode"),
    val_jit = menu.find("antiaim","main", "angles","jitter add"),
}

local enable_aa = menu.add_checkbox("Anti-Aim", "Enable Anti-Aim")
local aa_cond = {"Share", "Standing", "Running", "Air", "Air+C", "Walking", "Ducking", "Fakelag"}
local aa_cond2 = {"S+", "S", "R", "A", "A+C", "W", "D", "F"}
local aa_condishion = menu.add_selection("Builder", "Condition", aa_cond)
local yaw_base = menu.add_selection("Anti-Aim", "Yaw Base", {"None", "Viewangle", "At Target (Crosshair)", "At Target(Distance)", "Velocity"})
local enable_safe = menu.add_checkbox("Anti-Aim", "Enable Safe Head")
local safe_head = menu.add_multi_selection("Anti-Aim", "Safe Head In Air+C", {"Knife", "Zeus", "Scout", "AWP"})
local enable_ab = menu.add_checkbox("Anti-Aim", "Anti~Bruteforce")
local ab_notify = menu.add_checkbox("Anti-Aim", "Anti~Bruteforce Notify")


local anims_break = menu.add_checkbox("Animation Breaker", "Animation Breaker", true)
local ground_anims = menu.add_selection("Animation Breaker", "Ground", {"Off", "Static", "Jitter", "MoonWalk"})
local multi_selection = menu.add_selection("Animation Breaker", "Air", {"Off", "Static", "MoonWalk"})
local amount = menu.add_slider("Animation Breaker", "Jitter Legs Amount", 0, 10, 0.1)
local lean = menu.add_slider("Animation Breaker", "Lean Amount", 0, 1, 0.1)

local enable_logs = menu.add_checkbox("Misc", "Notify Logs")
local enable_srs_lg = menu.add_checkbox("Misc", "Console Logs")
local dmg_switch = menu.add_checkbox("Misc", "Damage Indicator")
local enabled_tp = menu.add_checkbox("Misc", "AirLag Exploit"..version_check.access[prim_version])

local state_panel = menu.add_checkbox("Visuals", "InfoPanel")
local war_switch = menu.add_checkbox("Visuals", "Velocity Window"..version_check.access[prim_version])
local war_main = war_switch:add_color_picker("Main")
local def_switch = menu.add_checkbox("Visuals", "Defensive Window"..version_check.access[prim_version])
local def_main = def_switch:add_color_picker("Main")
local cross_ind = menu.add_checkbox("Visuals", "Crosshair Indicator")
local ind_col3 = cross_ind:add_color_picker("Indicators Color", color_t(169, 114, 114))
local ind_col2 = cross_ind:add_color_picker("Indicator Color", color_t(150, 150, 150))

aa_condition = {}
for i=1, #aa_cond do
    aa_condition[i] = {
        override = menu.add_checkbox("Builder", "["..aa_cond2[i].."] Override"),
        yaw_type_mode = menu.add_selection("Builder", "["..aa_cond2[i].."] Yaw Type", version_check.yaw_type[prim_version]),
        yaw_add = menu.add_slider("Builder", "["..aa_cond2[i].."] Yaw", -180, 180),
        l_yaw_add = menu.add_slider("Builder", "["..aa_cond2[i].."] Yaw Right", -180, 180),
        r_yaw_add = menu.add_slider("Builder", "["..aa_cond2[i].."] Yaw Left", -180, 180),
        jitter_mode = menu.add_selection("Builder", "["..aa_cond2[i].."] Jitter Mode", {"Off", "Static", "Random"}),
        jitter_type = menu.add_selection("Builder", "["..aa_cond2[i].."] Jitter Type", {"Offset", "Center", "3-Way", "5-Way"}),
        jitter = menu.add_slider("Builder", "["..aa_cond2[i].."] Jitter", -180, 180),
        exp_type = menu.add_selection("Builder", "["..aa_cond2[i].."] Defensive Mode", {"On Peek", "Always On"}),
        side = menu.add_selection("Builder", "["..aa_cond2[i].."] Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real"}),
        left_lby = menu.add_slider("Builder", "["..aa_cond2[i].."] Desync Left", 0, 100),
        right_lby = menu.add_slider("Builder", "["..aa_cond2[i].."] Desync Right", 0, 100),
        pitch_exp = menu.add_checkbox("Builder", "["..aa_cond2[i].."] Defensive AA"),
        yaw_type = menu.add_selection("Builder", "["..aa_cond2[i].."] Defensive Yaw", version_check.def_yaw[prim_version]),
        pitch_type = menu.add_selection("Builder", "["..aa_cond2[i].."] Defensive Pitch", version_check.def_pitch[prim_version]),
        exp_amount = menu.add_slider("Builder", "["..aa_cond2[i].."] Pitch", -89, 89),
        menu.set_group_column("Builder", 3),
    }
end

local jump = false
local ducked = false

local positionState = 1
function positionInTheWorld()
    local localPlayer = entity_list:get_local_player()
    if localPlayer == nil then return end
    ducked = localPlayer:get_prop("m_flDuckAmount") > 0.7
    velx, vely = localPlayer:get_prop("m_vecVelocity")[0], localPlayer:get_prop("m_vecVelocity")[1]
    math_vel = math.sqrt(velx ^ 2 + vely ^ 2)
    moved = math_vel > 5
    ground = bit.band(localPlayer:get_prop("m_fFlags"), 1) == 1
    jump = bit.band(localPlayer:get_prop("m_fFlags"), 1) == 0
    check_fl = aa_condition[8].override:get() and exploits.get_charge() < 0.9

    if jump and ducked and not check_fl and aa_condition[5].override:get() then positionState = 5
    elseif jump and not ducked and not check_fl and aa_condition[4].override:get() then positionState = 4
    elseif ground and ducked and not check_fl and aa_condition[7].override:get()  then positionState = 7
    elseif menu.find("misc", "main", "movement", "slow walk")[2]:get() and ground and not check_fl and aa_condition[6].override:get() then positionState = 6
    elseif ground and not moved and not check_fl and aa_condition[2].override:get() then positionState = 2
    elseif ground and moved and not check_fl and aa_condition[3].override:get() then positionState = 3
    elseif check_fl then positionState = 8
    else positionState = 1 end
end

function menu_set_visible()
    main_tab = tab:get() == 1
    antiaim_tab = tab:get() == 2
    ragebot_tab = tab:get() == 3
    text1:set_visible(main_tab)
    text2:set_visible(main_tab)
    aa_condishion:set_visible(enable_aa:get() and antiaim_tab)
    yaw_base:set_visible(enable_aa:get() and antiaim_tab)
    menu.set_group_column("Tab", 1)
    menu.set_group_column("Info", 2)
    menu.set_group_visibility("Info", main_tab)
    menu.set_group_visibility("Anti-Aim", antiaim_tab)
    menu.set_group_visibility("Animation Breaker", antiaim_tab)
    menu.set_group_visibility("Misc", ragebot_tab)
    menu.set_group_visibility("Visuals", ragebot_tab)
    menu.set_group_column("Misc", 2)
    menu.set_group_column("Anti-Aim", 1)
    menu.set_group_column("Animation Breaker", 2)
    menu.set_group_column("Visuals", 3)
    enable_safe:set_visible(enable_aa:get() and antiaim_tab)
    anims_break:set_visible(enable_aa:get() and antiaim_tab)
    safe_head:set_visible(enable_aa:get() and antiaim_tab and enable_safe:get())
    enable_ab:set_visible(enable_aa:get() and antiaim_tab)
    ab_notify:set_visible(enable_aa:get() and antiaim_tab and enable_ab:get())

    ground_anims:set_visible(enable_aa:get() and anims_break:get())
    multi_selection:set_visible(enable_aa:get() and anims_break:get())
    amount:set_visible(ground_anims:get() == 3 and enable_aa:get() and anims_break:get())
    lean:set_visible(enable_aa:get() and anims_break:get())

    if prim_version == 0 then
        enabled_tp:set(false)
        def_switch:set(false)
        war_switch:set(false)
    end

    for i=1, #aa_cond do
        local visible_conditions=i==aa_condishion:get() and enable_aa:get() and aa_condition[i].override:get()
        aa_condition[1].override:set_visible(false)
        aa_condition[1].override:set(true)
        aa_condition[i].override:set_visible(i==aa_condishion:get() and enable_aa:get() and antiaim_tab)
        aa_condition[i].yaw_type_mode:set_visible(visible_conditions and antiaim_tab)
        aa_condition[i].yaw_add:set_visible(visible_conditions and aa_condition[i].yaw_type_mode:get() == 1 and antiaim_tab)
        aa_condition[i].r_yaw_add:set_visible(visible_conditions and aa_condition[i].yaw_type_mode:get() ~= 1 and antiaim_tab)
        aa_condition[i].l_yaw_add:set_visible(visible_conditions and aa_condition[i].yaw_type_mode:get() ~= 1 and antiaim_tab)
        aa_condition[i].jitter_mode:set_visible(visible_conditions and antiaim_tab)
        aa_condition[i].jitter_type:set_visible(visible_conditions and antiaim_tab and aa_condition[i].jitter_mode:get() ~= 1)
        aa_condition[i].jitter:set_visible(visible_conditions and antiaim_tab and aa_condition[i].jitter_mode:get() ~= 1)
        aa_condition[i].exp_type:set_visible(visible_conditions and antiaim_tab)
        aa_condition[i].side:set_visible(visible_conditions and antiaim_tab)
        aa_condition[i].left_lby:set_visible(visible_conditions and antiaim_tab and aa_condition[i].side:get() ~= 1)
        aa_condition[i].right_lby:set_visible(visible_conditions and antiaim_tab and aa_condition[i].side:get() ~= 1)
        aa_condition[i].pitch_exp:set_visible(visible_conditions and antiaim_tab)
        aa_condition[i].yaw_type:set_visible(visible_conditions and antiaim_tab and aa_condition[i].pitch_exp:get())
        aa_condition[i].pitch_type:set_visible(visible_conditions and antiaim_tab and aa_condition[i].pitch_exp:get())
        aa_condition[i].exp_amount:set_visible(visible_conditions and antiaim_tab and aa_condition[i].pitch_exp:get() and aa_condition[i].pitch_type:get() == 2)
    end
end


local font = render.create_font("Smallest Pixel-7", 10, 1000, e_font_flags.OUTLINE)
local logs = {}

function logs_sw()
    local offset, x, y = 0, render.get_screen_size().x / 2, render.get_screen_size().y / 1.4
    for idx, data in ipairs(logs) do
        if global_vars.cur_time() - data[3] < 3.0 and not (#logs > 5 and idx < #logs - 5) then
            data[2] = math.lerp(data[2], 255, 8)
        else
            data[2] = math.lerp(data[2], 0, 8)
        end
        offset = offset - 30 * (data[2] / 255)
        text_size = render.get_text_size(font, data[1])

        render.rect(vec2_t(x - 4 - text_size.x / 2, y - offset-3), vec2_t(text_size.x+24, text_size.y+7), color_t(255, 255, 255, math.floor(data[2]/1.5)), 4)
        render.rect_filled(vec2_t(x - 4 - text_size.x / 2, y - offset-3), vec2_t(text_size.x+24, text_size.y+7), color_t(0,0,0, math.floor(data[2]/5)), 4)
        render.text(font, data[1], vec2_t(x + 9 - text_size.x / 2, y - offset), color_t(255, 255, 255, math.floor(data[2])))
        if data[2] < 0.1 or not engine.is_connected() then table.remove(logs, idx) end
    end
end

render.log = function(text, size)
    table.insert(logs, { text, 0, global_vars.cur_time(), size })
end

render.log("Welcome Back!")
render.log("PIDRSENSE ["..version_check.name[prim_version].."]")
render.log("y" .. "u" .. "." .. "k" .. "i" .. "h" .. "v" .. "h")

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

function onHit(e)
    if e.player:get_name() == nil then return end 
    local hitString = string.format("Hit %s in the %s [%s] for %s [%s] (hc: %s bt: %s)", e.player:get_name(), hitgroup_names[e.hitgroup + 1] or '?', hitgroup_names[e.aim_hitgroup + 1], e.damage, e.aim_damage, math.floor(e.aim_hitchance).."%", e.backtrack_ticks)
    if enable_logs:get() then
        render.log(hitString)
    end
    if enable_srs_lg:get() then
        client.log_screen(hitString)
    end
end

function onMiss(e)
    if e.player:get_name() == nil then return end 
    local missString = string.format("Missed %s %s due to %s [%s] (hc: %s bt: %s)", e.player:get_name().."'s", hitgroup_names[e.aim_hitgroup + 1] or '?', e.reason_string, e.aim_damage, math.floor(e.aim_hitchance).."%", e.backtrack_ticks)
    if enable_srs_lg:get() then
        client.log_screen(missString)
    end
    if enable_logs:get() then
        render.log(missString)
    end
end
callbacks.add(e_callbacks.AIMBOT_MISS, onMiss)
callbacks.add(e_callbacks.AIMBOT_HIT, onHit)


current_stage = 0
curtime = 0

---Defensive CHECK!
local function __thiscall(func, this)
    return function(...)
        return func(this, ...)
    end
end
local vtable_bind = function(module, interface, index, typedef)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or safe_error(interface .. " is nil.")
    return __thiscall(ffi.cast(typedef, addr[0][index]), addr)
end

local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

defensive = 0
local function defensive_check()
    local lp = entity_list:get_local_player()
    if lp == nil then return end
    if not lp:is_alive() then return end
    local lp_ind = lp:get_index()
    if lp_ind == nil then return end
    local Entity = native_GetClientEntity(lp_ind)
    local m_flOldSimulationTime = ffi.cast("float*", ffi.cast("uintptr_t", Entity) + 0x26C)[0]
    local m_flSimulationTime = lp:get_prop("m_flSimulationTime")

    local delta = m_flOldSimulationTime - m_flSimulationTime;
    if delta > 0 then
        defensive = globals.tick_count() + client.time_to_ticks(delta - e_latency_flows.OUTGOING);
        return;
    end
end
---------------------------------


local yaw_adds = 0
local jit_yaw = 0
local curr_switch = 0
local check_zalupa = true
local side_jt = 0
local jit_yaw = 0
local jit_val = 0
local safe_checker = false

function on_antiaim(ctx)
    local lp = entity_list.get_local_player()
    if lp == nil then return end
    if not enable_aa:get() then return end
    positionInTheWorld()

	local pose = lp:get_prop("m_flPoseParameter", 11)
	local jit_side = pose * 120 - 60

    find.overmove:set(false)
    find.oversw:set(false)
    find.ab_stand:set(false)

    find.yawbase:set(yaw_base:get())
    find.rlimit_stand:set(aa_condition[positionState].right_lby:get())
    find.llimit_stand:set(aa_condition[positionState].left_lby:get())

    if check_zalupa == true then
        side_jt = aa_condition[positionState].side:get()
    end
    if aa_condition[positionState].yaw_type_mode:get() == 2 then
        check_zalupa = false
        if engine.get_choked_commands() == 0 then
            curr_switch = curr_switch + 1
        end
        if curr_switch == 2 then
            side_jt = 2
            jit_yaw = aa_condition[positionState].l_yaw_add:get()
        end
        if curr_switch == 4 then
            side_jt = 3
            jit_yaw = aa_condition[positionState].r_yaw_add:get()
            curr_switch = 0
        end
    elseif aa_condition[positionState].yaw_type_mode:get() == 1 then
        check_zalupa = true
        jit_yaw = aa_condition[positionState].yaw_add:get()
    else
        check_zalupa = false
        if globals.tick_count() % 3 == 0 then
            jit_yaw = -(aa_condition[positionState].l_yaw_add:get())
            side_jt = 2
        elseif globals.tick_count() % 3 == 1 then
            jit_yaw = 0
            find.rlimit_stand:set(0)
            find.llimit_stand:set(0)
        elseif globals.tick_count() % 3 == 2 then
            jit_yaw = aa_condition[positionState].r_yaw_add:get()
            side_jt = 3
            current_stage = 0
        end
    end

    jit_val = aa_condition[positionState].jitter:get()
    jit_mode = aa_condition[positionState].jitter_mode:get()
    type_jt = aa_condition[positionState].jitter_type:get()
    find.yawadd:set(jit_yaw)

    if aa_condition[positionState].exp_type:get() == 2 then
        exploits.force_anti_exploit_shift()
    end
    if aa_condition[positionState].pitch_exp:get() then
        if exploits.get_charge() < 14 then return end
        if globals.tick_count() < defensive and safe_checker == false then
            if yaw_adds <= 179 then
                yaw_adds = yaw_adds + 25
            else
                yaw_adds = -yaw_adds + 25
            end
    
            if aa_condition[positionState].pitch_type:get() == 2 then
                ctx:set_pitch(aa_condition[positionState].exp_amount:get())
            elseif aa_condition[positionState].pitch_type:get() == 3 then
                if globals.tick_count() % 5 == 0 then
                    ctx:set_pitch(-89)
                elseif globals.tick_count() % 5 == 1 then
                    ctx:set_pitch(-44)
                elseif globals.tick_count() % 5 == 2 then
                    ctx:set_pitch(0)
                elseif globals.tick_count() % 5 == 3 then
                    ctx:set_pitch(44)
                elseif globals.tick_count() % 5 == 4 then
                    ctx:set_pitch(89)
                end
            elseif aa_condition[positionState].pitch_type:get() == 4 then
                ctx:set_pitch(math.random(-89, 89))
            end

            if aa_condition[positionState].yaw_type:get() == 2 then
                find.yawadd:set(yaw_adds)
            elseif aa_condition[positionState].yaw_type:get() == 3 then
                find.yawadd:set(antiaim.get_desync_side() == 1 and -90 or 90)
            elseif aa_condition[positionState].yaw_type:get() == 4 then
                find.yawadd:set(180)
            end
        end
    end

    --safe head
    safe_checker = false
    if lp:get_active_weapon() ~= nil then
        if lp:get_active_weapon():get_class_name() == "CKnife" and safe_head:get(1) and jump and ducked then safe_checker = true end
        if lp:get_active_weapon():get_class_name() == "CWeaponTaser" and safe_head:get(2) and jump and ducked then safe_checker = true end
        if lp:get_active_weapon():get_class_name() == "CWeaponSSG08" and safe_head:get(3) and jump and ducked then safe_checker = true end
        if lp:get_active_weapon():get_class_name() == "CWeaponAWP" and safe_head:get(4) and jump and ducked then safe_checker = true end
    end

    if safe_checker == true then
        jit_mode = 1
        side_jt = 2
        find.yawadd:set(6)
    end

    find.val_jit:set(jit_val)
    find.mode_jit:set(jit_mode)
    find.type_jit:set(type_jt)
    find.side_stand:set(side_jt)
    ctx:set_invert_desync(true) 
    if anims_break:get() then
        local sexgod = lp:get_prop("m_vecVelocity[1]") ~= 0  
        if ground_anims:get() == 2 then
            ctx:set_render_pose(e_poses.RUN, 1)
            menu.find("antiaim","main","General","Leg slide"):set(3)
        elseif ground_anims:get() == 3 then
            ctx:set_render_pose(e_poses.RUN, global_vars.tick_count() % 4 > 1 and amount:get()/10 or 1)
            menu.find("antiaim","main","General","Leg slide"):set(3)
        elseif ground_anims:get() == 4 then
            ctx:set_render_pose(e_poses.MOVE_YAW, 1)
            menu.find("antiaim","main","General","Leg slide"):set(2)
        end
        if sexgod then
            ctx:set_render_animlayer(e_animlayers.LEAN, lean:get())
        end
        if multi_selection:get() == 2 then
            ctx:set_render_pose(e_poses.JUMP_FALL, 1)  
        elseif multi_selection:get() == 3 then
            if sexgod then
                ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1)
            end
        end
    end
end

callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
callbacks.add(e_callbacks.NET_UPDATE,defensive_check)

local antibrute_time_last = globals.real_time()
abtime = 0

local function bullet_impact(e)
    if not enable_ab:get() then return end
    playerb = entity_list.get_local_player()
    if playerb == nil then return end
    if not playerb:is_alive() then return end
    local player = entity_list.get_player_from_userid(e.userid)
    if player == nil then return end
    enemy_team = player:get_prop("m_iTeamNum")
    if enemy_team == nil then return end
    frind_team = playerb:get_prop("m_iTeamNum")
    if frind_team == nil then return end
    if frind_team == enemy_team then return end
    lp_orig = playerb:get_render_origin()
    if lp_orig == nil then return end
    enemy_orig = player:get_render_origin()
    if enemy_orig == nil then return end
    if lp_orig:dist(enemy_orig) > 1000 then return end
    local s_pos = vec3_t(e.x, e.y, e.z)
    local enemy_angles = (s_pos - player:get_hitbox_pos(e_hitboxes.HEAD)):to_angle()
    local angles = ((playerb:get_hitbox_pos(e_hitboxes.PELVIS) - player:get_hitbox_pos(e_hitboxes.HEAD)):to_angle() - enemy_angles)
    local fov = math.sqrt(angles.y*angles.y + angles.x*angles.x)
    if fov < 10 and antibrute_time_last < globals.real_time() then
        abtime = globals.real_time()
        antibrute_time_last = globals.real_time() + 0.1

        if ab_notify:get() then
            render.log(player:get_name().." Shot at you. Generated New Angle")
        end
    end
end

callbacks.add(e_callbacks.EVENT, bullet_impact, "bullet_impact")


local function strangerdranger(cmd)
    if not enabled_tp:get() then return end
    local localPlayer = entity_list:get_local_player()
    if localPlayer == nil then return end
    if not localPlayer:is_alive() then return end
    jump = bit.band(localPlayer:get_prop("m_fFlags"), 1) == 0
    exploits.force_anti_exploit_shift()
    exploits.allow_recharge()
    if global_vars.tick_count() % 7 > 1 and jump then
        exploits.force_uncharge()
    end
end
callbacks.add(e_callbacks.SETUP_COMMAND, strangerdranger)

lerp = function(a, b, t)
    return a + (b - a) * t
end

clamp = function(x, minval, maxval)
    if x < minval then
        return minval
    elseif x > maxval then
        return maxval
    else
        return x
    end
end

text_fade_animation = function(font, text, x, y, color1, color2, speed)
    local curtime = globals.cur_time()
    for i = 1, #text do
        local x_offset = i*5  
        local wave = math.cos(8 * speed * curtime + x_offset / 30)
        local lerped_color = {
            r = lerp(color1.r, color2.r, clamp(wave, 0, 1)),
            g = lerp(color1.g, color2.g, clamp(wave, 0, 1)),
            b = lerp(color1.b, color2.b, clamp(wave, 0, 1)),
            a = color1.a
        }
        render.text(font, text:sub(i, i), vec2_t(x + x_offset, y),color_t(math.floor(lerped_color.r), math.floor(lerped_color.g), math.floor(lerped_color.b), math.floor(lerped_color.a)))
        
    end
end

local default_font = render.get_default_font()
local font = render.create_font("Smallest Pixel-7", 10, 300, e_font_flags.OUTLINE)
local verdana = render.create_font("Verdana", 12, 0, e_font_flags.DROPSHADOW)
local screen_size = render.get_screen_size()

local function allah()
    local text_sizenigma = render.get_text_size(verdana, "P I D R S E N S E")
    local text_sizeligma = render.get_text_size(verdana, "["..string.upper(version_check.name[prim_version]).."]")
    --render.text(verdana, "Y U K I E T O P O S X A L K A", vec2_t(25, screen_size.y/2), color_t(170, 170, 170, 255))
    render.text(verdana, " ["..string.upper(version_check.name[prim_version]).."]", vec2_t(25 + text_sizenigma.x, screen_size.y/2), color_t(183, 78, 78, 255))
    text_fade_animation(verdana, "P I D R S E N S E", 25, screen_size.y/2, {r = 150, g = 150, b = 150, a = 255}, {r = 200, g = 200, b = 200, a = 255}, -1)
end

local ind_refs = {
    dt_ref = menu.find("aimbot","general","exploits","doubletap","enable"),
    hs_ref = menu.find("aimbot","general","exploits","hideshots","enable"),
    dmg = menu.find("aimbot", "scout", "target overrides", "min. damage", "enable"),
    hc = menu.find("aimbot", "scout", "target overrides", "Hitchance", "enable"),
}

local crosshair = {
    offset = 0,
    scope = 0
}


local function cross_inds()
    local player = entity_list.get_local_player()
    if player == nil then return end
    if not player:is_alive() then return end

    crosshair.scope = math.lerp(crosshair.scope, player:get_prop("m_bIsScoped") > 0 and 1 or 0, 20)

    local indspace = 0
    local size1 = render.get_text_size(font, version_check.name[prim_version])
    local size3 = render.get_text_size(font, "PIDRSENSE")

    render.text(font, version_check.name[prim_version], vec2_t(screen_size.x/2+2 - size1.x/2 + math.floor(crosshair.scope * 30),screen_size.y/2+21), ind_col2:get())
    render.rect_filled(vec2_t(screen_size.x/2+1 - size3.x/2 + crosshair.scope * 40, screen_size.y/2 + 21 + size3.y), vec2_t(46, 5), color_t(0,0,0))
    render.rect_fade(vec2_t(screen_size.x/2+2 - size3.x/2 + crosshair.scope * 40, screen_size.y/2 + 22 + size3.y), vec2_t(antiaim.get_max_desync_range()/1.3, 3), color_t(ind_col3:get().r, ind_col3:get().g, ind_col3:get().b, 255), color_t(ind_col3:get().r, ind_col3:get().g, ind_col3:get().b, 55), true)

    text_fade_animation(font, "PIDRSENSE", screen_size.x/2 - 3 - size3.x/2 + crosshair.scope * 40, screen_size.y/2+25+size1.y, {r = ind_col3:get().r, g = ind_col3:get().g, b = ind_col3:get().b, a = 255}, {r = ind_col2:get().r, g = ind_col2:get().g, b = ind_col2:get().b, a = 255}, -1)

    --render.text(font,"PIDRSENSE",vec2_t(screen_size.x/2+2 - size3.x/2 + crosshair.scope * 40, screen_size.y/2+25+size1.y), color_t(ind_col3:get().r, ind_col3:get().g, ind_col3:get().b, 255))
    if ind_refs.dt_ref[2]:get() then
        render.text(font,"DT",vec2_t(screen_size.x/2-3 + math.floor(crosshair.scope * 23),screen_size.y/2 + 24 + size3.y + size1.y),color_t(255, 255*math.floor(exploits.get_charge()/14), 255*math.floor(exploits.get_charge()/14)))
        indspace = indspace + 9
    end
    if ind_refs.hs_ref[2]:get() then
        render.text(font,"HS",vec2_t(screen_size.x/2-3 + math.floor(crosshair.scope * 23),screen_size.y/2 + indspace + 24 + size3.y + size1.y),color_t(255,255,255))
        indspace = indspace + 9
    end
    if menu.find("aimbot", tostring(active_weapon()), "target overrides", "Hitchance")[2]:get() then
        render.text(font,"HC",vec2_t(screen_size.x/2-3 + math.floor(crosshair.scope * 23),screen_size.y/2 + indspace + 24 + size3.y + size1.y),color_t(255,255,255))
        indspace = indspace + 9
    end
    if menu.find("aimbot", tostring(active_weapon()), "target overrides", "min. damage")[2]:get() then
        render.text(font,"MD",vec2_t(screen_size.x/2-3 + math.floor(crosshair.scope * 23),screen_size.y/2 + indspace + 24 + size3.y + size1.y),color_t(255,255,255))
        indspace = indspace + 9
    end
end

local desync_enemy = "0°"
local enemy_st = "None"

local function state_pan()
    local lp = entity_list.get_local_player()
    render.rect(vec2_t(25, screen_size.y/2+35), vec2_t(125, 50),color_t(255, 255, 255, 155), 5)
    render.rect_filled(vec2_t(25, screen_size.y/2+35), vec2_t(125, 50),color_t(0, 0, 0, 55), 5)

    render.text(font,"> PIDRSENSE ["..version_check.name[prim_version].."]",vec2_t(30,screen_size.y/2+40),color_t(255, 255, 255, 255))
    render.text(font, "> User: " .. "y" .. "u" .. "k" .. "i" .. "." .. "h" .. "v" .. "h", vec2_t(30, screen_size.y / 2 + 50), color_t(255, 200, 255, 255))
    render.text(font,"> Desync: "..math.floor(lp:get_prop("m_flPoseParameter", 11) * 120 - 60),vec2_t(30,screen_size.y/2+70),color_t(200, 200, 255, 255))

    local enemies_only = entity_list.get_players(true)
    for _, player in pairs(enemies_only) do
        if player:get_name() ~= nil then
            enemy_st = string.sub(player:get_name(), 1, 10)
        end
        desync_enemy = " ("..math.floor(player:get_prop("m_flPoseParameter", 11) * 120 - 60).."°)"
    end
    render.text(font,"> Enemy: "..enemy_st..desync_enemy,vec2_t(30,screen_size.y/2+60),color_t(206, 255, 157, 255))
end

local function damn()
    local dmg_ovr = menu.find("aimbot", tostring(active_weapon()), "target overrides", "min. damage")[1]
    local dmg_ovr_key = menu.find("aimbot", tostring(active_weapon()), "target overrides", "min. damage")[2]
    local norm_dmg = menu.find("aimbot", tostring(active_weapon()), "targeting", "min. damage")
    if dmg_ovr_key:get() then
        render.text(default_font, tostring(dmg_ovr:get()), vec2_t(render.get_screen_size().x/2 + 5, render.get_screen_size().y/2 - 15), color_t(255, 255, 255, 255))
    else
        render.text(default_font, tostring(norm_dmg:get()), vec2_t(render.get_screen_size().x/2 + 5, render.get_screen_size().y/2 - 15), color_t(255, 255, 255, 255))
    end
end

local alpha_def = 0
local screensize = render.get_screen_size()
local def_man = function()
    local exploit = math.floor(exploits.get_charge()*7.143)
    if exploit < 100 and menu.find("aimbot","general","exploits","doubletap","enable")[2]:get() or menu.is_open() then
        alpha_def = math.lerp(alpha_def, 1, 10)
    else
        alpha_def = math.lerp(alpha_def, 0, 10)
    end
    if exploit > 95 then
        render.text(default_font,"Defensive Ready: "..exploit,vec2_t(screensize.x/2-53,screensize.y/4-20),color_t(255,255, 255, math.floor(255*alpha_def)))
    else
        render.text(default_font,"Defensive Charging: "..exploit,vec2_t(screensize.x/2-53,screensize.y/4-20),color_t(255, 255, 255, math.floor(255*alpha_def)))
    end
    render.rect(vec2_t(screensize.x/2-60,screensize.y/4), vec2_t(120, 6), color_t(def_main:get().r,def_main:get().g,def_main:get().b, math.floor(255*alpha_def)), 6)
    render.rect_filled(vec2_t(screensize.x/2-60,screensize.y/4), vec2_t(exploit*1.2, 6), color_t(def_main:get().r,def_main:get().g,def_main:get().b, math.floor(155*alpha_def)), 6)
end

local alpha_war = 0
local vel_war = function()
    local lp = entity_list.get_local_player()
    if not lp then return end
    if lp:get_prop("m_lifeState") ~= 0 then return end
	local mod_prop = lp:get_prop("m_flVelocityModifier")
    local modifier = math.floor(mod_prop*100)
    if modifier < 100 or  menu.is_open() then
        alpha_war = math.lerp(alpha_war, 1, 10)
    else
        alpha_war = math.lerp(alpha_war, 0, 10)
    end
    render.text(default_font,"Slowed Down: "..modifier,vec2_t(screensize.x/2-40,screensize.y/5-20),color_t(255,255, 255, math.floor(255*alpha_war)))
    render.rect(vec2_t(screensize.x/2-60,screensize.y/5), vec2_t(120, 6), color_t(war_main:get().r, war_main:get().g, war_main:get().b, math.floor(255*alpha_war)), 6)
    render.rect_filled(vec2_t(screensize.x/2-60,screensize.y/5), vec2_t(modifier*1.2, 6), color_t(war_main:get().r, war_main:get().g, war_main:get().b, math.floor(155*alpha_war)), 6)
end

callbacks.add(e_callbacks.PAINT, function()
    if menu.is_open() then
        menu_set_visible()
    end
    allah()
    logs_sw() 
    player = entity_list.get_local_player()
    if player == nil then return end
    if not player:is_alive() then return end
    if def_switch:get() then
        def_man()
    end
    if war_switch:get() then
        vel_war()
    end
    if dmg_switch:get() then
        damn()
    end
    if cross_ind:get() then
        cross_inds()
    end
    if state_panel:get() then
        state_pan()
    end
end)

--@config: system
local configs = {}

ffi.cdef [[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

    VGUI_System010 =  memory.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
    VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
    get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
    set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
    get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")
    
    clipboard_import = function()
        local clipboard_text_length = get_clipboard_text_count(VGUI_System)
        
        if clipboard_text_length > 0 then
            local buffer = ffi.new("char[?]", clipboard_text_length)
            local size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
        
            get_clipboard_text(VGUI_System, 0, buffer, size )
        
            return ffi.string( buffer, clipboard_text_length-1)
        end
    
        return ""
    end
    
    local function clipboard_export(string)
        if string then
            set_clipboard_text(VGUI_System, string, string:len())
        end
    end
    
    local function str_to_sub(text, sep)
        local t = {}
        for str in string.gmatch(text, "([^"..sep.."]+)") do
            t[#t + 1] = string.gsub(str, "\n", " ")
        end
        return t
    end
    
    local function to_boolean(str)
        if str == "true" or str == "false" then
            return (str == "true")
        else
            return str
        end
    end
    
    configs.export = function()
        local str = ""
        str=str..tostring(enable_aa:get()).."|"
        ..tostring(yaw_base:get()).."|" 
        ..tostring(enable_ab:get()).."|" 
        ..tostring(ground_anims:get()).."|"
        ..tostring(enable_logs:get()).."|"
        ..tostring(amount:get()).."|"
        ..tostring(lean:get()).."|"
        for i=1, #aa_cond do
                str=str..tostring(aa_condition[i].override:get()).."|"
                ..tostring(aa_condition[i].yaw_type_mode:get()) .. "|"
                ..tostring(aa_condition[i].yaw_add:get()) .. "|"
                ..tostring(aa_condition[i].r_yaw_add:get()) .. "|"
                ..tostring(aa_condition[i].l_yaw_add:get()) .. "|"
                ..tostring(aa_condition[i].jitter_mode:get()) .. "|"
                ..tostring(aa_condition[i].jitter_type:get()) .. "|"
                ..tostring(aa_condition[i].jitter:get()) .. "|"
                ..tostring(aa_condition[i].side:get()) .. "|"
                ..tostring(aa_condition[i].left_lby:get()) .. "|"
                ..tostring(aa_condition[i].right_lby:get()) .. "|"
                ..tostring(aa_condition[i].pitch_exp:get()) .. "|"
                ..tostring(aa_condition[i].yaw_type:get()) .. "|"
                ..tostring(aa_condition[i].pitch_type:get()) .. "|"
                ..tostring(aa_condition[i].exp_amount:get()) .. "|"
                ..tostring(aa_condition[i].exp_type:get()) .. "|"
        end
        clipboard_export(str)
        render.log("Config Exported")
    end

    configs.import = function(input)
        local protected = function()
            local clipboard = input == nil and clipboard_import() or input
            local tbl = str_to_sub(clipboard, "|")
            enable_aa:set(to_boolean(tbl[1]))
            yaw_base:set(tonumber(tbl[2]))
            enable_ab:set(to_boolean(tbl[3]))
            ground_anims:set(tonumber(tbl[4]))
            enable_logs:set(to_boolean(tbl[5]))
            amount:set(tonumber(tbl[6]))
            lean:set(tonumber(tbl[7]))
            for i = 1, #aa_cond do
                aa_condition[i].override:set(to_boolean(tbl[8 + (16 * (i - 1))]))
                aa_condition[i].yaw_type_mode:set(tonumber(tbl[9 + (16 * (i - 1))]))
                aa_condition[i].yaw_add:set(tonumber(tbl[10 + (16 * (i - 1))]))
                aa_condition[i].r_yaw_add:set(tonumber(tbl[11 + (16 * (i - 1))]))
                aa_condition[i].l_yaw_add:set(tonumber(tbl[12 + (16 * (i - 1))]))
                aa_condition[i].jitter_mode:set(tonumber(tbl[13 + (16 * (i - 1))]))
                aa_condition[i].jitter_type:set(tonumber(tbl[14 + (16 * (i - 1))]))
                aa_condition[i].jitter:set(tonumber(tbl[15 + (16 * (i - 1))]))
                aa_condition[i].side:set(tonumber(tbl[16 + (16 * (i - 1))]))
                aa_condition[i].left_lby:set(tonumber(tbl[17 + (16 * (i - 1))]))
                aa_condition[i].right_lby:set(tonumber(tbl[18 + (16 * (i - 1))]))
                aa_condition[i].pitch_exp:set(to_boolean(tbl[19 + (16 * (i - 1))]))
                aa_condition[i].yaw_type:set(tonumber(tbl[20 + (16 * (i - 1))]))
                aa_condition[i].pitch_type:set(tonumber(tbl[21 + (16 * (i - 1))]))
                aa_condition[i].exp_amount:set(tonumber(tbl[22 + (16 * (i - 1))]))
                aa_condition[i].exp_type:set(tonumber(tbl[23 + (16 * (i - 1))]))
            end
           
            render.log("Config Loaded")
        end
        local status, message = pcall(protected)
        if not status then
            render.log("Config Not Loaded")
            return
        end
    end

    configs.default = function(input)
        local protected = function()
            local clipboard = "true|3|true|1|true|0|1|true|2|0|-27|31|1|1|0|2|100|100|false|2|1|-49|1|false|1|0|0|0|1|1|0|1|0|0|false|1|1|0|1|true|2|0|-38|34|1|1|0|2|100|100|true|2|4|0|1|true|2|0|-32|34|1|1|0|2|100|100|false|1|1|0|2|true|2|0|-27|38|1|1|0|2|100|100|false|1|1|0|2|false|1|0|0|0|1|1|0|1|0|0|false|1|1|0|1|false|1|0|0|0|1|1|0|1|0|0|false|1|1|0|1|true|1|0|0|0|1|1|0|4|100|100|false|1|1|0|1|"
            local tbl = str_to_sub(clipboard, "|")
            enable_aa:set(to_boolean(tbl[1]))
            yaw_base:set(tonumber(tbl[2]))
            enable_ab:set(to_boolean(tbl[3]))
            ground_anims:set(tonumber(tbl[4]))
            enable_logs:set(to_boolean(tbl[5]))
            amount:set(tonumber(tbl[6]))
            lean:set(tonumber(tbl[7]))
            for i = 1, #aa_cond do
                aa_condition[i].override:set(to_boolean(tbl[8 + (16 * (i - 1))]))
                aa_condition[i].yaw_type_mode:set(tonumber(tbl[9 + (16 * (i - 1))]))
                aa_condition[i].yaw_add:set(tonumber(tbl[10 + (16 * (i - 1))]))
                aa_condition[i].r_yaw_add:set(tonumber(tbl[11 + (16 * (i - 1))]))
                aa_condition[i].l_yaw_add:set(tonumber(tbl[12 + (16 * (i - 1))]))
                aa_condition[i].jitter_mode:set(tonumber(tbl[13 + (16 * (i - 1))]))
                aa_condition[i].jitter_type:set(tonumber(tbl[14 + (16 * (i - 1))]))
                aa_condition[i].jitter:set(tonumber(tbl[15 + (16 * (i - 1))]))
                aa_condition[i].side:set(tonumber(tbl[16 + (16 * (i - 1))]))
                aa_condition[i].left_lby:set(tonumber(tbl[17 + (16 * (i - 1))]))
                aa_condition[i].right_lby:set(tonumber(tbl[18 + (16 * (i - 1))]))
                aa_condition[i].pitch_exp:set(to_boolean(tbl[19 + (16 * (i - 1))]))
                aa_condition[i].yaw_type:set(tonumber(tbl[20 + (16 * (i - 1))]))
                aa_condition[i].pitch_type:set(tonumber(tbl[21 + (16 * (i - 1))]))
                aa_condition[i].exp_amount:set(tonumber(tbl[22 + (16 * (i - 1))]))
                aa_condition[i].exp_type:set(tonumber(tbl[23 + (16 * (i - 1))]))
            end
            
            render.log("Config Loaded")
        end
        local status, message = pcall(protected)
        if not status then
            render.log("Config Not Loaded")
            return
        end
    end

local button3 = menu.add_button("Config system", "Default Config", function()
    configs.default()
end)

menu.add_button("Config system", "Import Config", function()
    configs.import()
end)

menu.add_button("Config system", "Export Config", function()
    configs.export()
end)