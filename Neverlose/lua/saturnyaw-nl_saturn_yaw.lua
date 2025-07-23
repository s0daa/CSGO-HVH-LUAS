-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

--fixed by l0ny#8533


base64 = require("neverlose/base64")
clipboard = require("neverlose/clipboard")

_DEBUG = true

aa_states = {"Global", "Standing", "Running", "Slowwalk", "Crouch", "Jump", "Jump+Crouch"}
aa_states2 = {"G", "S", "R", "SW", "C", "J", "J+C"}

aa_refs = {
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    desync_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
}

group_antiaim = ui.create("AntiAim")
group_builder = ui.create("AntiAim")
enable_antiaim = group_antiaim:switch("Enable AntiAim", false)
enable_builder = group_builder:switch("Enable Builder", false)
manual_yaw_base = group_antiaim:combo("Manual Yaw Base", {"Disabled", "Forward", "Left", "Right"})
condition = group_builder:combo("Condition", aa_states)

local group_misc = ui.create("Misc")
local group_visuals = ui.create("Visuals", "Visuals")

local enebler_killsay     = group_misc:switch("Saturn Killsay", false)
local enebler_tag     = group_misc:switch("Saturn Clantag", false)

local m_color     = group_visuals:color_picker("Global color", color(125, 125, 225, 255))
local enebler     = group_visuals:switch("Saturn Hitlogs", false)
local switch = group_visuals:switch("Saturn Indicators", false)
local killeffect = group_visuals:switch("Kill Effect", true)
local state_panel = group_visuals:switch("State Panel", true)
local manual_arrow = group_visuals:switch("Manual Arrow", true)
local velwarning = group_visuals:switch("Velocity Warning", true)

group_view = ui.create("Visuals","View")
aspect_ratio_switch = group_view:switch("Aspect ratio", false)
viewmodel_switch = group_view:switch("Viewmodel", false)

viewmodel_ref = viewmodel_switch:create()
viewmodel_fov = viewmodel_ref:slider("FOV", -100, 100, 68)
viewmodel_x = viewmodel_ref:slider("X", -10, 10, 2.5)
viewmodel_y = viewmodel_ref:slider("Y", -10, 10, 0)
viewmodel_z = viewmodel_ref:slider("Z", -10, 10, -1.5)

aspectratio_ref = aspect_ratio_switch:create()
aspect_ratio_slider = aspectratio_ref:slider("Value", 0, 20, 0, 0.1)

local screen = render.screen_size()
local verdana = render.load_font("Verdana", 12)

local killeffect = function(e)
    if not globals.is_connected then return end
    local me = entity.get_local_player()
    local attacker = entity.get(e.attacker, true)
    if me == attacker then
        if killeffect:get() then
            me.m_flHealthShotBoostExpirationTime = globals.curtime + 20 / 10
        end
    end
end

local hitgroup_str = {[0] = 'generic','head', 'chest', 'stomach','left arm', 'right arm','left leg', 'right leg','neck', 'generic', 'gear'}

local hitlog = {}
local id = 1

function hit_event(event)
    local me = entity.get_local_player()
    local attacker = entity.get(event.attacker, true)
    local weapon = event.weapon
    local hit_type = ""
    if enebler:get() then
        if weapon == 'hegrenade' then
            hit_type = 'Exploded'
        end

        if weapon == 'inferno' then
            hit_type = 'Burned'
        end

        if weapon == 'knife' then
            hit_type = 'Hit from Knife'
        end

        if weapon == 'hegrenade' or weapon == 'inferno' or weapon == 'knife' then
            if me == attacker then
                local user = entity.get(event.userid, true)
                hitlog[#hitlog+1] = {(hit_type..' %s for %d damage (%d health remaining)'):format(user:get_name(), event.dmg_health, event.health), globals.tickcount + 250, 0}
                print_raw(('\a4562FF[neverlose] \aD5D5D5[%s] '..hit_type..' %s for %d damage (%d health remaining)'):format(id, user:get_name(), event.dmg_health, event.health))
                print_dev(("[%s] " .. hit_type..' %s for %d damage (%d health remaining)'):format(id, user:get_name(), event.dmg_health, event.health))
            end
            id = id == 999 and 1 or id + 1
        end
    end
end

events.render:set(function()
    if #hitlog > 0 then
        if globals.tickcount >= hitlog[1][2] then
            if hitlog[1][3] > 0 then
                hitlog[1][3] = hitlog[1][3] - 20
            elseif hitlog[1][3] <= 0 then
                table.remove(hitlog, 1)
            end
        end
        if #hitlog > 6 then
            table.remove(hitlog, 1)
        end
        if globals.is_connected == false then
            table.remove(hitlog, #hitlog)
        end
        for i = 1, #hitlog do
            text_size = render.measure_text(1, nil, hitlog[i][1]).x
            text_size_2 = render.measure_text(1, nil, "[saturn] ").x
            if hitlog[i][3] < 255 then
                hitlog[i][3] = hitlog[i][3] + 10
            end
                render.text(1, vector(screen.x/2 - text_size/2 + text_size_2, screen.y/1.5 + 15 * i), color(255, 255, 255, hitlog[i][3]), nil, hitlog[i][1])
                render.text(1, vector(screen.x/2 - text_size/2, screen.y/1.5 + 15 * i), color(m_color:get().r, m_color:get().g, m_color:get().b, hitlog[i][3]), nil, "[saturn]")
        end
    end
end)

--IDEAL YAW
local ideal_ind = function()

    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    if not switch:get() then return end

    if switch:get() then
        local ay = 0
        local x = render.screen_size().x/2
        local y = render.screen_size().y/2 + 20
        
        render.text(verdana, vector(x + 1, y), color(0, 0, 0, 255), nil, "SATURN YAW")
        render.text(verdana, vector(x, y), color(220, 135, 49, 255), nil, "SATURN YAW")
        ay = ay + 10
        if ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):get() then
            render.text(verdana, vector(x + 1, y + ay), color(0, 0, 0, 255), nil, "FREESTAND")
            render.text(verdana, vector(x, y + ay), color(209, 159, 230, 255), nil, "FREESTAND")
            ay = ay + 10
        else
            render.text(verdana, vector(x + 1, y + ay), color(0, 0, 0, 255), nil, "DYNAMIC")
            render.text(verdana, vector(x, y + ay), color(209, 159, 230, 255), nil, "DYNAMIC")
            ay = ay + 10
        end
        if ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get() then
            local chrg = rage.exploit:get()
            render.text(verdana, vector(x + 1, y + ay), color(0, 0, 0, 255), nil, "DT")
            if chrg == 1 then
                render.text(verdana, vector(x, y + ay), color(0, 255, 0, 255), nil, "DT")
            else
                render.text(verdana, vector(x, y + ay), color(255, 0, 0, 255), nil, "DT")
            end
            ay = ay + 10
        end
        if ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"):get() then
            render.text(verdana, vector(x + 1, y + ay), color(0, 0, 0, 255), nil, "AA")
            render.text(verdana, vector(x, y + ay), color(120, 128, 200, 255), nil, "AA")
            ay = ay + 10
        end
    end
end

local killsayha = function(e)
    if enebler_killsay:get() then
        local me = entity.get_local_player()
        local victim = entity.get(e.userid, true)
        local attacker = entity.get(e.attacker, true)

        if victim == attacker or attacker ~= me then return end
        
        utils.console_exec("say GET GOOD GET SATURN LUA")
    end
end

local function rgbToHex(r, g, b)
r = tostring(r);g = tostring(g);b = tostring(b)
r = (r:len() == 1) and '0'..r or r;g = (g:len() == 1) and '0'..g or g;b = (b:len() == 1) and '0'..b or b

local rgb = (r * 0x10000) + (g * 0x100) + b
return (r == '00' and g == '00' and b == '00') and '000000' or string.format('%x', rgb)
end

local ffi = require("ffi")
ffi.cdef[[
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
    typedef int(__fastcall* clantag_t)(const char*, const char*);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
    bool CreateDirectoryA(const char* lpPathName, void* lpSecurityAttributes);
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK); 
    typedef struct {
        unsigned short wYear;
        unsigned short wMonth;
        unsigned short wDayOfWeek;
        unsigned short wDay;
        unsigned short wHour;
        unsigned short wMinute;
        unsigned short wMilliseconds;
    } SYSTEMTIME, *LPSYSTEMTIME;
    void GetSystemTime(LPSYSTEMTIME lpSystemTime);
    void GetLocalTime(LPSYSTEMTIME lpSystemTime);
]]

local set_clantag = ffi.cast('int(__fastcall*)(const char*, const char*)', utils.opcode_scan('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))

gamesense_anim = function(text, indices)
    local local_player = entity.get_local_player()
    if not globals.is_connected then
        return
    end
    local text_anim = '               ' .. text .. '                      '
    local tickinterval = globals.tickinterval
    local tickcount = globals.tickcount + math.floor(utils.net_channel().latency[0]+0.22 / tickinterval + 0.5)
    local i = tickcount / math.floor(0.3 / tickinterval + 0.5)
    i = math.floor(i % #indices)
    i = indices[i+1]+1

    return string.sub(text_anim, i, i+15)
end

enabled_prev = true

set_clantag('\0', '\0')

dh_DrawClanTag = function()
if enebler_tag:get() then
local local_player = entity.get_local_player()
if local_player ~= nil and globals.is_connected and globals.choked_commands == 0 then
local bebraliu = entity.get_game_rules()
clan_tag = gamesense_anim('saturn [debug]', {0, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 14, 14, 14, 14, 14, 14, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 25})
if bebraliu.m_gamePhase == 5 then
clan_tag = gamesense_anim('saturn [debug]', {14})
set_clantag(clan_tag, clan_tag)
elseif bebraliu.m_timeUntilNextPhaseStarts ~= 0 then
clan_tag = gamesense_anim('saturn [debug]', {14})
set_clantag(clan_tag, clan_tag)
elseif clan_tag ~= clan_tag_prev then
set_clantag(clan_tag, clan_tag)
end
clan_tag_prev = clan_tag
end
enabled_prev = false
elseif not enebler_tag:get() and enabled_prev == false then
set_clantag('\0', '\0')
enabled_prev = true
end
end

local manualarrowel = function()
    if manual_arrow:get() then
        render.poly(color(35, 35, 35, 150), vector(screen.x / 2 + 55, screen.y / 2 - 2 + 2), vector(screen.x / 2 + 42, screen.y / 2 - 2 - 7), vector(screen.x / 2 + 42, screen.y / 2 - 2 + 11))
        render.poly(color(35, 35, 35, 150), vector(screen.x / 2 - 55, screen.y / 2 - 2 + 2), vector(screen.x / 2 - 42, screen.y / 2 - 2 - 7), vector(screen.x / 2 - 42, screen.y / 2 - 2 + 11))
        if not invert_state then
            render.rect_outline(vector(screen.x / 2 + 38, screen.y / 2 - 2 - 7), vector(screen.x / 2 + 38 + 2, screen.y / 2 - 2 - 7 + 18),  m_color:get())
            render.rect_outline(vector(screen.x / 2 - 40, screen.y / 2 - 2 - 7), vector(screen.x / 2 - 38, screen.y / 2 - 2 - 7 + 18), color(35, 35, 35, 150))
        else
            render.rect_outline(vector(screen.x / 2 + 38, screen.y / 2 - 2 - 7), vector(screen.x / 2 + 38 + 2, screen.y / 2 - 2 - 7 + 18), color(35, 35, 35, 150))
            render.rect_outline(vector(screen.x / 2 - 40, screen.y / 2 - 2 - 7), vector(screen.x / 2 - 38, screen.y / 2 - 2 - 7 + 18),  m_color:get())
        end
    end
end

function leerp(start, vend, time)
    return start + (vend - start) * time
end

local is_in_bounds = function(bound_a, bound_b, position)
    return position.x >= bound_a.x and position.y >= bound_a.y and position.x <= bound_b.x and position.y <= bound_b.y
end

local vdragging = false
local vdrag_offset = vector(0, 0)
local dragging = false
local drag_offset = vector(0, 0)
local Verdana_bold = render.load_font("Verdana", 10, 'ab')
local anim1 = 0
local a_width = 0
local size2 = vector(30, 50)
local url2 = 'https://i.ibb.co/TPY5GG2/IMG-2347.png'
local velocity_icon = render.load_image(network.get(url2), size2)

local vpos_x = group_visuals:slider("vdrag_offset", 0, screen.x, screen.x / 2 - 82):visibility(false)
local vpos_y = group_visuals:slider("vdragging", 0, screen.y, screen.y / 2 - 200):visibility(false)

local velocitywarningel = function()
    if not velwarning:get() then return end
    local local_player = entity.get_local_player()
    if local_player == nil then return end
    local modifier_vel = local_player.m_flVelocityModifier + 0.01
    if ui.get_alpha() == 1 then
        modifier_vel = local_player.m_flVelocityModifier
    end
    if modifier_vel == 1.01 then return end

    local text_vel = string.format('Slowed down %.0f%%', math.floor(modifier_vel*100))
    local text_width_vel = 95

    a_width = leerp(a_width, math.floor((text_width_vel - 2) * modifier_vel), globals.frametime * 8)

    local xv, yv = vpos_x:get(), vpos_y:get()
    
    render.texture(velocity_icon, vector(xv+47, yv-31), vector(30, 50), m_color:get()  )
    render.text(1, vector(xv+56+21, yv+1+4), color(0, 0, 0, 255), nil, text_vel)
    render.text(1, vector(xv+55+21, yv+4), m_color:get(), nil, text_vel)

    render.rect(vector(xv+55, yv+17+4), vector(xv+165+20, yv+31), color(25, 25, 25, 200))
    render.rect(vector(xv+56, yv+18+4), vector(xv+65+(a_width*1.2 + 7), yv+30), m_color:get())
    
    render.rect_outline(vector(xv+55, yv+17+4), vector(xv+165+20, yv+31), color(55, 55, 55, 200))
    
    if common.is_button_down(0x01) and ui.get_alpha() == 1 then
        local mouse_position = ui.get_mouse_position()
        if dragging == false and vdragging == false and is_in_bounds(vector(vpos_x:get(), vpos_y:get()-10), vector(vpos_x:get()+185, vpos_y:get()+31), mouse_position) == true then
            vdrag_offset.x = mouse_position.x - vpos_x:get()
            vdrag_offset.y = mouse_position.y - vpos_y:get()
            vdragging = true
        end
        if vdragging == true then
            vpos_x:set(mouse_position.x - vdrag_offset.x)
            vpos_y:set(mouse_position.y - vdrag_offset.y)
        end
    else
        vdragging = false
    end
end

local statepanelel = function()
    if not state_panel:get() then
        return
    end
 
    if not entity.get_local_player() then return end
    local bodyyaw = entity.get_local_player().m_flPoseParameter[11] * 120 - 60
    if entity.get_threat() == nil then
        target_name = "none"
    else
        target_name = entity.get_threat():get_name()
    end
    render.rect_outline(vector(10-10, screen.y/2-50-10), vector(10+160, screen.y/2-50+65), color(255, 255, 255, 255))
    render.text(1, vector(10, screen.y/2-50), color(255, 255, 255, 255), nil, "> Saturn - antiaim script")
    render.text(1, vector(10, screen.y/2-50+10), color(255, 255, 255, 255), nil, "> user: ", common.get_username())
    render.text(1, vector(10, screen.y/2-50+20), color(255, 255, 255, 255), nil, "> build ver. - alpha")
    render.text(1, vector(10, screen.y/2-50+30), color(255, 255, 255, 255), nil, "> current enemy: ", target_name)
    render.text(1, vector(10, screen.y/2-50+40), color(255, 255, 255, 255), nil, "> angle of desync: ", math.floor(bodyyaw).."°")
end
                                                                                                                                                                                                                                                         
menu_condition = {}
for a, b in pairs(aa_states2) do
    menu_condition[a] = {
        enable = group_builder:switch("Enable " .. aa_states[a]),
        left_yaw_add = group_builder:slider("["..b.."] Left Yaw Add", -180, 180, 0),
        right_yaw_add = group_builder:slider("["..b.."] Right Yaw Add", -180, 180, 0),
        yaw_modifier = group_builder:combo("["..b.."] Yaw Modifier", aa_refs.yaw_modifier:list()),
        modifier_offset = group_builder:slider("["..b.."] Modifier Offset", -180, 180, 0),
        options = group_builder:selectable("["..b.."] Options", aa_refs.options:list()),
        desync_freestanding = group_builder:combo("["..b.."] Freestanding", aa_refs.desync_freestanding:list()),
        left_limit = group_builder:slider("["..b.."] Left Limit", 0, 60, 60),
        right_limit = group_builder:slider("["..b.."] Right Limit", 0, 60, 60),
    }
end

exporting = {
    ["number"] = {},
    ["boolean"] = {},
    ["table"] = {},
    ["string"] = {}
}

export_process = function()     
    for a, b in pairs(aa_states2) do
        for c, d in pairs(menu_condition[a]) do
            table.insert(exporting[type(d:get())], d)
        end
    end

    arr_to_string = function(arr)
        arr = arr:get()
        str = ""
        for i=1, #arr do
            str = str .. arr[i] .. (i == #arr and "" or ",")
        end
    
        if str == "" then
            str = "-"
        end
    
        return str
    end

    str = ""
    for i,o in pairs(exporting["number"]) do
        str = str .. tostring(o:get()) .. "|"
    end
    for i,o in pairs(exporting["string"]) do
        str = str .. (o:get()) .. "|"
    end
    for i,o in pairs(exporting["boolean"]) do
        str = str .. tostring(o:get()) .. "|"
    end
    for i,o in pairs(exporting["table"]) do
        str = str .. arr_to_string(o) .. "|"
    end

    clipboard.set(base64.encode(str))
end

load_process = function()
    protected_ = function()
        clipboards = clipboard.get()

        str_to_sub = function(input, sep)
            t = {}
            for str in string.gmatch(input, "([^"..sep.."]+)") do
                t[#t + 1] = string.gsub(str, "\n", "")
            end
            return t
        end

        to_boolean = function(str)
            if str == "true" or str == "false" then
                return (str == "true")
            else
                return str
            end
        end

        tbl = str_to_sub(base64.decode(clipboards), "|")

        p = 1
        for i,o in pairs(exporting["number"]) do
            o:set(tonumber(tbl[p]))
            p = p + 1
        end
        for i,o in pairs(exporting["string"]) do
            o:set(tbl[p])
            p = p + 1
        end
        for i,o in pairs(exporting["boolean"]) do
            o:set(to_boolean(tbl[p]))
            p = p + 1
        end
        for i,o in pairs(exporting["table"]) do
            o:set(str_to_sub(tbl[p],","))
            p = p + 1
        end
    end

    status, message = pcall(protected_)
    
    if not status then
        -- print("Error reason: "..message)
        return end
end

export_config = group_antiaim:button("Export Preset Data", export_process())
load_config = group_antiaim:button("Import Preset Data", load_process())

get_player_state = function()
    local_player = entity.get_local_player()
    if not local_player then return "Not connected" end
    
    on_ground = bit.band(local_player.m_fFlags, 1) == 1
    jump = bit.band(local_player.m_fFlags, 1) == 0
    crouch = local_player.m_flDuckAmount > 0.7 or aa_refs.fakeduck:get()
    vx, vy, vz = local_player.m_vecVelocity.x, local_player.m_vecVelocity.y, local_player.m_vecVelocity.z
    math_velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    move = math_velocity > 5

    if jump and crouch then return "Jump+Crouch" end
    if jump then return "Jump" end
    if crouch then return "Crouch" end
    if on_ground and aa_refs.slowwalk:get() and move then return "Slowwalk" end
    if on_ground and not move then return "Standing" end
    if on_ground and move then return "Running" end
end

antiaim = function()
    local_player = entity.get_local_player()
    if not local_player then return end
    if enable_antiaim:get() == false then return end
    if enable_builder:get() == false then return end

    invert_state = (math.normalize_yaw(local_player:get_anim_state().eye_yaw - local_player:get_anim_state().abs_yaw) <= 0)

    if menu_condition[2].enable:get() and get_player_state() == "Standing" then aaid = 2
    elseif menu_condition[3].enable:get() and get_player_state() == "Running" then aaid = 3
    elseif menu_condition[4].enable:get() and get_player_state() == "Slowwalk" then aaid = 4
    elseif menu_condition[5].enable:get() and get_player_state() == "Crouch" then aaid = 5
    elseif menu_condition[6].enable:get() and get_player_state() == "Jump" then aaid = 6
    elseif menu_condition[7].enable:get() and get_player_state() == "Jump+Crouch" then aaid = 7
    else
        aaid = 1
    end

    left_yaw_add = menu_condition[aaid].left_yaw_add:get()
    right_yaw_add = menu_condition[aaid].right_yaw_add:get()
    yaw_modifier = menu_condition[aaid].yaw_modifier:get()
    modifier_offset = menu_condition[aaid].modifier_offset:get()
    options = menu_condition[aaid].options:get()
    desync_freestanding = menu_condition[aaid].desync_freestanding:get()
    left_limit = menu_condition[aaid].left_limit:get()
    right_limit = menu_condition[aaid].right_limit:get()
    
    aa_refs.offset:override(invert_state and right_yaw_add or left_yaw_add)
    aa_refs.yaw_modifier:override(yaw_modifier)
    aa_refs.modifier_offset:override(modifier_offset)
    aa_refs.options:override(options)
    aa_refs.desync_freestanding:override(desync_freestanding)
    aa_refs.left_limit:override(left_limit)
    aa_refs.right_limit:override(right_limit)
    aa_refs.base:override(aa_refs.base:get())

    if manual_yaw_base:get() == "Left" then
        aa_refs.offset:override(-85)
        aa_refs.base:override("Local View")
    elseif manual_yaw_base:get() == "Right" then
        aa_refs.offset:override(85)
        aa_refs.base:override("Local View")
    elseif manual_yaw_base:get() == "Forward" then
        aa_refs.offset:override(180)
        aa_refs.base:override("Local View")
    end
end

menu_ui = function()
    menu_condition[1].enable:set(true)
    aa_work = enable_antiaim:get()
    builder_work = enable_builder:get()
    cond_select = condition:get()
    all_work = aa_work and builder_work
    condition:visibility(all_work)
    enable_builder:visibility(aa_work)
    manual_yaw_base:visibility(aa_work)
    export_config:visibility(aa_work)
    load_config:visibility(aa_work)
    
    for a, b in pairs(aa_states2) do
        need_select = cond_select == aa_states[a]
        all_work2 = all_work and menu_condition[a].enable:get() and cond_select == aa_states[a]
        menu_condition[a].enable:visibility(all_work and need_select)
        menu_condition[1].enable:visibility(false)
        menu_condition[a].left_yaw_add:visibility(all_work2)
        menu_condition[a].right_yaw_add:visibility(all_work2)
        menu_condition[a].yaw_modifier:visibility(all_work2)
        menu_condition[a].modifier_offset:visibility(all_work2 and menu_condition[a].yaw_modifier:get() ~= "Disabled")
        menu_condition[a].options:visibility(all_work2)
        menu_condition[a].desync_freestanding:visibility(all_work2)
        menu_condition[a].left_limit:visibility(all_work2)
        menu_condition[a].right_limit:visibility(all_work2)
    end
end

export_config:set_callback(export_process)
load_config:set_callback(load_process)

events.aim_ack:set(function(event)
    local me = entity.get_local_player()
    local result = event.state
    local target = entity.get(event.target)
    local text = "%"
    if target == nil then return end
    local health = target["m_iHealth"]
    local state_1 = ""
    if enebler:get() then
        if event.state == "spread" then state_1 = "spread" end
        if event.state == "prediction error" then state_1 = "prediction error" end
        if event.state == "jitter correction" then state_1 = "jitter correction" end
        if event.state == "correction" then state_1 = "resolver" end
        if event.state == "lagcomp failure" then state_1 = "fake lag correction" end
        if result == nil then
            hitlog[#hitlog+1] = {("Registered shot at %s's %s(%s%s) for %s (aimed: %s for %s, health remain: %s) backtrack: %s"):format(event.target:get_name(), hitgroup_str[event.hitgroup], event.hitchance, text, event.damage, hitgroup_str[event.wanted_hitgroup], event.wanted_damage, health, event.backtrack), globals.tickcount + 250, 0}
            print_raw(("\a4562FF[neverlose] \aD5D5D5[%s] Registered shot at %s's %s(%s%s) for %s (aimed: %s for %s, health remain: %s) backtrack: %s"):format(id, event.target:get_name(), hitgroup_str[event.hitgroup], event.hitchance, text, event.damage, hitgroup_str[event.wanted_hitgroup], event.wanted_damage, health, event.backtrack))
        else
            hitlog[#hitlog+1] = {("Missed %s`s %s (dmg:%s, %s%s) due to %s | backtrack: %s"):format(event.target:get_name(), hitgroup_str[event.wanted_hitgroup], event.wanted_damage, event.hitchance, text, state_1, event.backtrack), globals.tickcount + 250, 0}
            print_raw(("\a4562FF[neverlose] \aD5D5D5[%s] Missed %s`s %s (dmg:%s, %s%s) due to %s\aD5D5D5 | backtrack: %s"):format(id, event.target:get_name(), hitgroup_str[event.wanted_hitgroup], event.wanted_damage, event.hitchance, text, state_1, event.backtrack))
        end
        id = id == 999 and 1 or id + 1
    end
end)
events.player_death:set(function(e)
    killsayha(e)
    killeffect(e)
end)
events.player_hurt:set(function(event)
    hit_event(event)
end)
events.render:set(function()
    ideal_ind()
    antiaim()
    menu_ui()
    statepanelel()
    manualarrowel()
    velocitywarningel()
    dh_DrawClanTag()
end)
events.createmove:set(function()
    if aspect_ratio_switch:get() then
        cvar.r_aspectratio:float(aspect_ratio_slider:get()/10)
    else
        cvar.r_aspectratio:float(0)
    end
    if viewmodel_switch:get() then
        cvar.viewmodel_fov:int(viewmodel_fov:get(), true)
        cvar.viewmodel_offset_x:float(viewmodel_x:get(), true)
        cvar.viewmodel_offset_y:float(viewmodel_y:get(), true)
        cvar.viewmodel_offset_z:float(viewmodel_z:get(), true)
    else
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
    end
end)
events.shutdown:set(function()
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
end)