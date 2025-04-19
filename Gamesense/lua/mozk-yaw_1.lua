ffi.cdef[[
    typedef struct {
        unsigned short wYear;
        unsigned short wMonth;
        unsigned short wDayOfWeek;
        unsigned short wDay;
        unsigned short wHour;
        unsigned short wMinute;
        unsigned short wSecond;
        unsigned short wMilliseconds;
    } SYSTEMTIME, *LPSYSTEMTIME;
    void GetSystemTime(LPSYSTEMTIME lpSystemTime);
    void GetLocalTime(LPSYSTEMTIME lpSystemTime);

    typedef struct {
        float x;
        float y;
        float z;
    } vec3_struct;

    typedef void*(__thiscall* c_entity_list_get_client_entity_t)(void*, int);
    typedef void*(__thiscall* c_entity_list_get_client_entity_from_handle_t)(void*, uintptr_t);

    typedef int(__thiscall* c_weapon_get_muzzle_attachment_index_first_person_t)(void*, void*);
    typedef int(__thiscall* c_weapon_get_muzzle_attachment_index_third_person_t)(void*);
    typedef bool(__thiscall* c_entity_get_attachment_t)(void*, int, vec3_struct*);
    
    bool CreateDirectoryA(const char* lpPathName, void* lpSecurityAttributes);
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK); 
    void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);

    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
]]

local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet'
local gdi = ffi.load 'Gdi32'

Download = function(from, to)
    wininet.DeleteUrlCacheEntryA(from)
    urlmon.URLDownloadToFileA(nil, from, to, 0,0)
    print('Successfully!')
end

CreateDir = function(path)
    ffi.C.CreateDirectoryA(path, NULL)
end

local engineClient = Utils.CreateInterface("engine.dll", "VEngineClient014")
local engineClientClass = ffi.cast(ffi.typeof("void***"), engineClient)
local isConsoleVisible = ffi.cast("bool(__thiscall*)(void*)", engineClientClass[0][11])

local consoleMaterials = {"vgui_white", "vgui/hud/800corner1", "vgui/hud/800corner2", "vgui/hud/800corner3", "vgui/hud/800corner4"}
local materialList = {}

local oldColor = Color.new(1.0, 1.0, 1.0, 1.0)
local oldConsoleIsVisible = false

local materials = {
    "particle/fire_burning_character/fire_env_fire_depthblend_oriented",
    "particle/fire_burning_character/fire_burning_character",
    "particle/fire_explosion_1/fire_explosion_1_oriented",
    "particle/fire_explosion_1/fire_explosion_1_bright",
    "particle/fire_burning_character/fire_burning_character_depthblend",
    "particle/fire_burning_character/fire_env_fire_depthblend",
}

local ffi_handler = {}
local muzzle = {}

ffi_handler.bind_argument = function(fn, arg)
    return function(...)
        return fn(arg, ...)
    end
end

ffi_handler.interface_type = ffi.typeof("uintptr_t**")

ffi_handler.i_client_entity_list = ffi.cast(ffi_handler.interface_type, Utils.CreateInterface("client.dll", "VClientEntityList003"))
ffi_handler.get_client_entity = ffi_handler.bind_argument(ffi.cast("c_entity_list_get_client_entity_t", ffi_handler.i_client_entity_list[0][3]), ffi_handler.i_client_entity_list)

muzzle.attachment_index = 84
muzzle.muzzle_attachment_index_1st = 468
muzzle.muzzle_attachment_index_3rd = 469

muzzle.pos = Vector.new(0, 0, 0)

muzzle.get = function()

    if not EngineClient.IsInGame() then return end

    local me = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
    if not me or EntityList.GetLocalPlayer():GetProp("DT_BasePlayer", "m_iHealth") < 1 then return end

    local my_weapon = EntityList.GetClientEntityFromHandle(me:GetProp("DT_BaseCombatCharacter", "m_hActiveWeapon"))
    if not my_weapon then return end

    local my_address = ffi_handler.get_client_entity(me:EntIndex())
    if not my_address then return end

    local my_weapon_address = ffi_handler.get_client_entity(my_weapon:EntIndex())
    if not my_weapon_address then return end

    local viewmodel = EntityList.GetClientEntityFromHandle(me:GetProp("DT_BasePlayer", "m_hViewModel[0]"))
    if not viewmodel then return end

    local viewmodel_ent = ffi_handler.get_client_entity(viewmodel:EntIndex())
    if not viewmodel_ent then return end

    local weaponworldmodel = EntityList.GetClientEntityFromHandle(my_weapon:GetProp("DT_BaseCombatWeapon", "m_hWeaponWorldModel"))
    if not weaponworldmodel then return end

    local weaponworldmodel_ent = ffi_handler.get_client_entity(weaponworldmodel:EntIndex())
    if not weaponworldmodel_ent then return end

    local viewmodel_vtbl = ffi.cast(ffi_handler.interface_type, viewmodel_ent)[0]
    local weaponworldmodel_vtbl = ffi.cast(ffi_handler.interface_type, weaponworldmodel_ent)[0]
    local weapon_vtbl = ffi.cast(ffi_handler.interface_type, my_weapon_address)[0]

    local get_viewmodel_attachment_fn = ffi.cast("c_entity_get_attachment_t", viewmodel_vtbl[muzzle.attachment_index])
    local get_weaponworldmodel_attachment_fn = ffi.cast("c_entity_get_attachment_t", weaponworldmodel_vtbl[muzzle.attachment_index])
    local get_muzzle_attachment_index_1st_fn = ffi.cast("c_weapon_get_muzzle_attachment_index_first_person_t", weapon_vtbl[muzzle.muzzle_attachment_index_1st])
    local get_muzzle_attachment_index_3rd_fn = ffi.cast("c_weapon_get_muzzle_attachment_index_third_person_t", weapon_vtbl[muzzle.muzzle_attachment_index_3rd])

    local muzzle_attachment_index_1st = get_muzzle_attachment_index_1st_fn(my_weapon_address, viewmodel_ent)
    local muzzle_attachment_index_3rd = get_muzzle_attachment_index_3rd_fn(my_weapon_address)

    local ret = ffi.new("vec3_struct[1]")
    local is_thirdperson = Menu.FindVar("Visuals", "View", "Thirdperson", "Enable Thirdperson")

    if is_thirdperson:Get() then
        state = get_weaponworldmodel_attachment_fn(weaponworldmodel_ent, muzzle_attachment_index_3rd, ret)
    else
        state = get_viewmodel_attachment_fn(viewmodel_ent, muzzle_attachment_index_1st, ret)
    end

    return {state = state, pos = Vector.new(ret[0].x, ret[0].y, ret[0].z)}
end

local x = EngineClient.GetScreenSize().x
local y = EngineClient.GetScreenSize().y
local sc = EngineClient.GetScreenSize()
local aa = {}
local state = {"Global", "Stand", "Move", "Air", "Duck", "Slow walk"}
local hitboxes = {"generic","head","chest","stomach","left arm","right arm","left leg","right leg","neck"};
local logs = {}
logs[#logs+1] = {("[Mozk-Yaw] Welcome back, "..Cheat.GetCheatUserName().."!"), GlobalVars.tickcount + 300, 0}
logs[#logs+1] = {("[Mozk-Yaw] Download font in Global Tab!"), GlobalVars.tickcount + 300, 0}
local ui =
{
    --rage
    antidefensive = Menu.Switch("Global","Rage", "Anti-Defensive", false),
    autopeek = Menu.Switch("Global","Rage", "Quick Peek", false),
    disable_os = Menu.Switch("Global","Rage", "Disable FL on Hide Shots", false),
    idealtick = Menu.Switch("Global","Rage", "Idealtick", false, "Works when autopeek"),
    add_idealtick = Menu.MultiCombo("Global","Rage", "Idealtick Options", {"Freestand", "Override Damage", "Safe Head"}, 0),
    idealtick_damage = Menu.SliderInt("Global","Rage","Idealtick Damage", 10, 0, 130),
    air_hitchance = Menu.Switch("Global","Rage", "In-Air Hitchance", false),
    air_hitchance_value = Menu.SliderInt("Global","Rage","Air Hitchance Value", 50, 1, 100),
    ns_hitchance = Menu.Switch("Global","Rage", "Noscope Hitchance", false),
    ns_hitchance_value = Menu.SliderInt("Global","Rage","NS Hitchance Value", 50, 1, 100),

    --visuals
    state_panel = Menu.Switch("Visuals","Main","State Panel", false),
    circle = Menu.SwitchColor("Visuals","Main", "Anti-Aim Crosshair Indicator", false, Color.new(0.57, 0.57, 1, 1)),
    circle_style = Menu.Combo("Visuals","Main", "Style", {"Circle", "Arrows"}, 0),
    glowpeek = Menu.SwitchColor("Visuals","Main", "Glow Autopeek", false, Color.new(0.47, 0.47, 1, 0.5)),
    viewmodel = Menu.Switch("Visuals","Main", "Viewmodel in Scope", false),
    scope = Menu.SwitchColor("Visuals","Main", "Custom Scope", false, Color.new(1, 1, 1, 1)),
    offset = Menu.SliderInt("Visuals","Main", "Offset", 5, -500, 500),
    length = Menu.SliderInt("Visuals","Main", "Length", 25, 0, 1000),
    color = Menu.ColorEdit("Visuals","Main", "Accent Color", Color.new(0.57, 0.57, 1, 1)),

    --indicators
    indicators = Menu.MultiCombo("Visuals","Indicators","Indicators", {"Mozk-Yaw #1", "Mozk-Yaw #2", "Mozk-Yaw #3", "Ideal Yaw", "Skeet"}, 0),
    add_indicators = Menu.MultiCombo("Visuals","Indicators","Additional Indicators", {"Freestand", "Exploit", "Damage", "Others"}, 0),
    damage_indicator = Menu.Switch("Visuals","Indicators", "Damage Indicator", false),
    manual_arrows = Menu.Switch("Visuals","Indicators","Manual Arrows", false),
    arrows_style = Menu.Combo("Visuals","Indicators","Arrows Style", {"Default", "TeamSkeet"}, 0),
    color1 = Menu.ColorEdit("Visuals","Indicators", "First Color", Color.RGBA(175, 255, 0, 255)),
    color2 = Menu.ColorEdit("Visuals","Indicators", "Second Color", Color.RGBA(0, 200, 255, 255)),

    --solus ui
    windows = Menu.MultiCombo("Visuals","UI","Windows", {"Watermark", "Spectators", "Keybinds", "FAKE & DT", "Holo Panel"}, 0),
    alpha = Menu.SliderInt("Visuals","UI", "Box Alpha", 75, 0, 255),
    holo_on_tp = Menu.Switch("Visuals","UI","Disable in Thirdperson", false),
    binds_x = Menu.SliderInt("Visuals","UI", "X", 300, 0, x),
    binds_y = Menu.SliderInt("Visuals","UI", "Y", 300, 0, y),
    specs_x = Menu.SliderInt("Visuals","UI", "X ", 300, 0, x),
    specs_y = Menu.SliderInt("Visuals","UI", "Y ", 500, 0, y),

    --misc
    hitlogs = Menu.Switch("Misc","Misc","Hitlogs", false),
    hitlogs_type = Menu.MultiCombo("Misc","Misc", "Hitlogs Type", {"Custom", "Console", "Event"}, 0),
    console = Menu.SwitchColor("Misc", "Misc", "Console Color Changer", false, Color.new(1.0, 1.0, 1.0)),
    hitsound = Menu.Combo("Misc","Misc","Hitsound", {"Disable","Skeet", "Alternative", "Custom"}, 0),
    custom_hitsound = Menu.TextBox("Misc","Misc","Filepath", 64, "Mozk-Yaw/hitsound/hitsound.wav"),
    wireframe = Menu.Switch("Misc","Misc","Molotov Wireframe", false),
    ignorez = Menu.Switch("Misc","Misc","Ignore-Z", false),
    blur = Menu.Switch("Misc","Misc","Menu Blur", false),
    trashtalk = Menu.Switch("Misc","Misc","Trashtalk", false),
    tpanim = Menu.Switch("Misc","Misc","Disable Thirdperson Animation", false),
}

--anti-aims
aa[0] =
{
    antiaims = Menu.Switch("Anti-Aim","Main","Enable Anti Aim's", false),
    tp_in_air = Menu.Switch("Anti-Aim","Main","Teleport In Air", false),
    fake_flick = Menu.Switch("Anti-Aim","Main","Fake Flick", false),
    on_key = Menu.Switch("Anti-Aim","Main","Legit AA", false),
    antibackstab = Menu.Switch("Anti-Aim","Main","Anti Backstab", false),
    manual = Menu.Combo("Anti-Aim","Main", "Override Yaw Base", {"Disable", "Forward", "Backward", "Right", "Left", "At Target", "Freestanding"}, 0, "Bind it"),
    antiaim = Menu.Combo("Anti-Aim","Main", "Conditions", state, 0),
}
for i = 1, 6 do
    aa[i] = {
        custom_enable = Menu.Switch("Anti-Aim",state[i], string.format("Enable %s Anti Aim", state[i]), false,string.format("Override %s settings", state[i])),
        custom_yaw_base = Menu.Combo("Anti-Aim",state[i], "Yaw Base", {"Forward", "Backward", "Right", "Left", "At Target", "Freestanding"}, 1),
        custom_yaw_add_left = Menu.SliderInt("Anti-Aim",state[i], "Yaw Add Left", 0, -180, 180),
        custom_yaw_add_right = Menu.SliderInt("Anti-Aim",state[i], "Yaw Add Right", 0, -180, 180),
        custom_yaw_modifier = Menu.Combo("Anti-Aim",state[i], "Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin"}, 0),
        custom_modifier_degree = Menu.SliderInt("Anti-Aim",state[i], "Modifier Degree", 0, -180, 180),
        custom_fake_type = Menu.Combo("Anti-Aim",state[i],"Fake Type", {"Static","Jitter","Random"}, 0),
        custom_left_limit = Menu.SliderInt("Anti-Aim",state[i], "Left Limit", 60, 0, 60),
        custom_right_limit = Menu.SliderInt("Anti-Aim",state[i], "Right Limit", 60, 0, 60),
        custom_left_limit2 = Menu.SliderInt("Anti-Aim",state[i], "Left Limit [2]", 60, 0, 60),
        custom_right_limit2 = Menu.SliderInt("Anti-Aim",state[i], "Right Limit [2]", 60, 0, 60),
        custom_options = Menu.MultiCombo("Anti-Aim",state[i],"Fake Options", {"Avoid Overlap","Jitter","Randomize Jitter", "Anti Bruteforce"}, 0),
        custom_lby = Menu.Combo("Anti-Aim",state[i],"LBY Mode", {"Disabled","Opposite","Sway"}, 1),
        custom_fs = Menu.Combo("Anti-Aim",state[i],"Freestanding Desync", {"Off","Peek Fake","Peek Real"}, 0),
        custom_onshot = Menu.Combo("Anti-Aim",state[i],"Desync On Shot", {"Disabled","Opposite","Freestanding","Switch"}, 0),
    }
end
local preset = Menu.Button("Anti-Aim","Main", "Load Default Preset", "Load Default Preset", function()
    aa[1].custom_yaw_base:SetInt(4)
    aa[1].custom_yaw_add_left:SetInt(0)
    aa[1].custom_yaw_add_right:SetInt(0)
    aa[1].custom_yaw_modifier:SetInt(2)
    aa[1].custom_modifier_degree:SetInt(20)
    aa[1].custom_fake_type:SetInt(0)
    aa[1].custom_left_limit:SetInt(42)
    aa[1].custom_right_limit:SetInt(42)
    aa[1].custom_lby:SetInt(0)
    aa[1].custom_fs:SetInt(0)
    aa[1].custom_onshot:SetInt(1)
end)

CreateDir("nl\\Mozk-Yaw\\")
--info
Menu.Text("Global","Info","Welcome to Mozk-Yaw, "..Cheat.GetCheatUserName().."!")

local get_discord = Menu.Button("Global","Info","Discord", "Discord", function()
    Panorama.Open().SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/Szn9eUg6xj")
end)

local get_font = Menu.Button("Global","Info","Font Download", "Font Download", function()
    CreateDir("nl\\Mozk-Yaw\\fonts\\")
    Download('https://fontsforyou.com/downloads/99851-smallestpixel7', 'nl\\Mozk-Yaw\\fonts\\pixel.ttf')
    logs[#logs+1] = {("[Mozk-Yaw] Font installed, restart script!"), GlobalVars.tickcount + 300, 0}
end)

CreateDir("csgo\\sound\\Mozk-Yaw\\")
CreateDir("csgo\\sound\\Mozk-Yaw\\hitsound\\")
Download('https://cdn.discordapp.com/attachments/856592298132242432/931265632861818930/skeet.wav', 'csgo\\sound\\Mozk-Yaw\\hitsound\\hitsound.wav')

Menu.Text("Global","Info","Hitsound Filepath: csgo/sounds | File type .wav")
Menu.Text("Global","Info","Thanks for buy! ")
Menu.Text("Global","Info","Version 1.0")
Menu.Text("Global","Info","Mozk-Yaw")

--fonts
local font =
{
    pixel = Render.InitFont("nl\\Mozk-Yaw\\fonts\\pixel.ttf", 10),
    verdana = Render.InitFont("Verdana", 11, {'r'}),
    verdanabd = Render.InitFont("Verdana Bold", 11, {'r'}),
    verdanabd12 = Render.InitFont("Verdana Bold", 12),
    calibrib = Render.InitFont("Calibri Bold", 30),
    tahoma = Render.InitFont("Tahoma", 12),
}

--menu reference
local MD = Menu.FindVar("Aimbot","Ragebot","Accuracy","Minimum Damage")
local BA = Menu.FindVar("Aimbot","Ragebot","Misc","Body Aim")
local SP = Menu.FindVar("Aimbot","Ragebot","Misc","Safe Points")
local DT = Menu.FindVar("Aimbot","Ragebot","Exploits","Double Tap")
local AP = Menu.FindVar("Miscellaneous","Main","Movement","Auto Peek")
local SW = Menu.FindVar("Aimbot","Anti Aim","Misc","Slow Walk")
local HS = Menu.FindVar("Aimbot","Ragebot","Exploits","Hide Shots")
local PING = Menu.FindVar("Miscellaneous", "Main", "Other", "Fake Ping")
local FL = Menu.FindVar("Aimbot","Anti Aim","Fake Lag","Limit")
local FLR = Menu.FindVar("Aimbot","Anti Aim","Fake Lag","Randomization")
local FD = Menu.FindVar("Aimbot","Anti Aim","Misc","Fake Duck")
local TP = Menu.FindVar("Visuals", "View", "Thirdperson", "Enable Thirdperson")
local removals = Menu.FindVar("Visuals", "World", "Main", "Removals")

--menu reference for aa
local left_limit = Menu.FindVar("Aimbot","Anti Aim","Fake Angle","Left Limit")
local right_limit = Menu.FindVar("Aimbot","Anti Aim","Fake Angle","Right Limit")
local options = Menu.FindVar("Aimbot","Anti Aim","Fake Angle","Fake Options")
local lby_mode = Menu.FindVar("Aimbot","Anti Aim","Fake Angle","LBY Mode")
local freestand = Menu.FindVar("Aimbot","Anti Aim","Fake Angle","Freestanding Desync")
local onshot = Menu.FindVar("Aimbot","Anti Aim","Fake Angle","Desync On Shot")
local yaw_base = Menu.FindVar("Aimbot","Anti Aim","Main","Yaw Base")
local pitch = Menu.FindVar("Aimbot","Anti Aim","Main","Pitch")
local yaw_add = Menu.FindVar("Aimbot","Anti Aim","Main","Yaw Add")
local yaw_modifier = Menu.FindVar("Aimbot","Anti Aim","Main","Yaw Modifier")
local modifier_degree = Menu.FindVar("Aimbot","Anti Aim","Main","Modifier Degree")
local legmovement = Menu.FindVar("Aimbot", "Anti Aim", "Misc", "Leg Movement")

local normalize_yaw = function(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end

function C_BasePlayer:IsLocalPlayer()
    return self == EntityList.GetLocalPlayer()
end

function C_BasePlayer:IsEnemy()
    return EntityList.GetLocalPlayer() and self:IsTeamMate() == false
end

function GetEnemiesWithKnife()
    local ret = {}

    local players = EntityList.GetPlayers()
    if #players < 0 then return {} end

    for i, player in pairs(players) do
        local player_active_weapon = player:GetActiveWeapon()

        if not player_active_weapon then return end

        if player:IsEnemy() and player:IsAlive() and player_active_weapon:IsKnife() then
            table.insert(ret, player)
        end
    end

    return ret
end

--jitter
local jitter = function(c, q)
    local f = math.random(0, 1)
    local b = 0
    if f == 0 then
        b = c
    elseif f == 1 then
        b = q
    end
    return b
end

--set movement
function setmovement(xz,yz,cmd)
    local local_player = EntityList.GetLocalPlayer()
    local_player = local_player:GetPlayer()
    local current_pos = local_player:GetProp("m_vecOrigin")
    local yaw = EngineClient:GetViewAngles().yaw
    local vector_forward = {
        x = current_pos.x - xz,
        y = current_pos.y - yz,
    }   
    local velocity = {
        x = -(vector_forward.x * math.cos(yaw / 180 * math.pi) + vector_forward.y * math.sin(yaw / 180 * math.pi)),
        y = vector_forward.y * math.cos(yaw / 180 * math.pi) - vector_forward.x * math.sin(yaw / 180 * math.pi),
    }
    cmd.forwardmove = velocity.x * 15
    cmd.sidemove = velocity.y * 15
end

--yaw
local yaw = function(h, l, y)
    local invert = AntiAim.GetInverterState()
    if invert == true then
        h:SetInt(l)
    elseif invert == false then
        h:SetInt(y)
    end
end

--lerp
local lerp = function (a, b, percentage) return math.floor(a + (b - a) * percentage) end

local function isColorEquals(clr1, clr2)
    return (clr1.r == clr2.r and clr1.g == clr2.g and clr1.b == clr2.b and clr1.a == clr2.a)
end

local function copyColor(src, dest)
    dest.r, dest.g, dest.b, dest.a = src.r, src.g, src.b, src.a
end

local function findConsoleMaterials()
    if materialList[1] then return end

    local material = MatSystem.FirstMaterial()
    local foundCount = 0

    while(foundCount < 5)
    do
        local mat = MatSystem.GetMaterial(material)
        local name = mat:GetName()

        for i = 1, #consoleMaterials do
            if name == consoleMaterials[i] then
                materialList[i] = mat
                foundCount = foundCount + 1
                break
            end
        end

        material = MatSystem.NextMaterial(material)
    end
end

local function updateConsoleColor(r, g, b, a)
    for i = 1, #materialList do
        local mat = materialList[i]
        mat:ColorModulate(r, g, b)
        mat:AlphaModulate(a)
    end
end

local function cfgConsoleCallback()
    local color = ui.console:Get()

    if not ui.console:Get() then
        updateConsoleColor(1, 1, 1, 1)
    elseif isConsoleVisible(engineClientClass) then
        updateConsoleColor(color.r, color.g, color.b, color.a)
        copyColor(color, oldColor)
    end
end

--angle
local adjust_angle = function(angle)
    if(angle < 0) then
        angle = (90 + angle * (-1))
    elseif(angle > 0) then
        angle = (90 - angle)
    end
    return angle
end

local OldChoke, toDraw0, toDraw1, toDraw2, toDraw3, toDraw4, on_plant_time, fill, text, planting_site, planting, autopeek_origin = 0, 0, 0, 0, 0, 0, 0, 0, "", "", false, nil

--hitgroups
Cheat.RegisterCallback("registered_shot", function(shot)
    local reason_list = {
        "resolver",
        "spread",
        "occlusion",
        "prediction error"
    }
    local reason = shot.reason
    local entity = EntityList.GetClientEntity(shot.target_index)
    local Name = entity:GetPlayer():GetName()
    if ui.hitlogs:Get() then
        if reason == 0 then
            if ui.hitlogs_type:Get(1) then
                logs[#logs+1] = {("[Mozk-Yaw] Hit "..Name.."'s in "..hitboxes[shot.hitgroup+1].." for ".. shot.damage .." dmg (aimed: "..hitboxes[shot.wanted_hitgroup+1]..", hc: "..shot.hitchance..", bt: "..shot.backtrack..", spread: "..string.format("%.1f", shot.spread_degree).."°)"), GlobalVars.tickcount + 300, 0}
            end
            if ui.hitlogs_type:Get(2) then
                print("[Mozk-Yaw] Hit "..Name.."'s in "..hitboxes[shot.hitgroup+1].." for ".. shot.damage .." dmg (aimed: "..hitboxes[shot.wanted_hitgroup+1]..", hc: "..shot.hitchance..", bt: "..shot.backtrack..", spread: "..string.format("%.1f", shot.spread_degree).."°)")
            end
            if ui.hitlogs_type:Get(3) then
                Cheat.AddEvent("[Mozk-Yaw] Hit "..Name.."'s in "..hitboxes[shot.hitgroup+1].." for ".. shot.damage .." dmg (aimed: "..hitboxes[shot.wanted_hitgroup+1]..", hc: "..shot.hitchance..", bt: "..shot.backtrack..", spread: "..string.format("%.1f", shot.spread_degree).."°)")
            end
        else
            if ui.hitlogs_type:Get(1) then
                logs[#logs+1] = {("[Mozk-Yaw] Missed ".. Name .. "'s in " .. hitboxes[shot.wanted_hitgroup+1] .. " due to "..reason_list[reason].." (aimed: "..hitboxes[shot.wanted_hitgroup+1]..", hc: "..shot.hitchance..", bt: "..shot.backtrack..", spread: "..string.format("%.1f", shot.spread_degree).."°)"), GlobalVars.tickcount + 300, 0}
            end
            if ui.hitlogs_type:Get(2) then
                print("[Mozk-Yaw] Missed ".. Name .. "'s in " .. hitboxes[shot.wanted_hitgroup+1] .. " due to "..reason_list[reason].." (aimed: "..hitboxes[shot.wanted_hitgroup+1]..", hc: "..shot.hitchance..", bt: "..shot.backtrack..", spread: "..string.format("%.1f", shot.spread_degree).."°)")
            end
            if ui.hitlogs_type:Get(3) then
                Cheat.AddEvent("[Mozk-Yaw] Missed ".. Name .. "'s in " .. hitboxes[shot.wanted_hitgroup+1] .. " due to "..reason_list[reason].." (aimed: "..hitboxes[shot.wanted_hitgroup+1]..", hc: "..shot.hitchance..", bt: "..shot.backtrack..", spread: "..string.format("%.1f", shot.spread_degree).."°)")
            end
        end
    end
end)

--velocity
local velocity = function(ent)
    local speed = Vector.new(ent:GetProp("DT_BasePlayer", "m_vecVelocity[0]"), ent:GetProp("DT_BasePlayer", "m_vecVelocity[1]"), ent:GetProp("DT_BasePlayer", "m_vecVelocity[2]")):Length2D()
    return speed
end

local drag = {false, false}
local toDraw = {0, 0, 0, 0, 0, 0,}
local keysAnim = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,}

local Visuals_HoloX, Visuals_HoloY, fake, curtime, ts, ts2, aastate, legit_aa, in_use, call_once = 0, 0, GlobalVars.curtime, 0, 0, 0, "DEFAULT", false, false, true


local anim = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,}

local legitaa = function(cmd)
    local lp = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
    if lp == nil then return end
    in_use = false
    if aa[0].on_key:Get() == false then legit_aa = false return else legit_aa = true end
    if(bit.band(cmd.buttons, 32) == 32 and call_once == true) then
        call_once = false
    end

    if(bit.band(cmd.buttons, 32) == 0 and call_once == false) then
        call_once = true
    end

    if bit.band(cmd.buttons, 32) == 32 then
        in_use = true
        cmd.buttons = bit.band(cmd.buttons, bit.bnot(32))
    end
end

local use = function(cmd)
    if in_use == true then
        cmd.buttons = bit.bor(cmd.buttons, 32)
        in_use = false
    end
end

local Render_Indicator = function(text, ay2, color, size, font, outline)
    ts = Render.CalcTextSize(text, size, font)
    Render.Text(text, Vector2.new(x/2-ts.x/2, y/2+ay2), color, size, font, outline)
end

local Render_Indicator2 = function(text, ay2, color, size, font, outline, ts2)
    ts = Render.CalcTextSize(text, size, font)
    Render.Text(text, Vector2.new(x/2-ts.x/2-ts2, y/2+ay2), color, size, font, outline)
end
      
local Render_Indicator3 = function(text, ay3, color, size, font)
    ts = Render.CalcTextSize(text, size, font)
    Render.Text(text, Vector2.new(x/2+1, y/2+1+ay3), Color.RGBA(0,0,0,255), size, font)
    Render.Text(text, Vector2.new(x/2, y/2+ay3), color, size, font)
end

local Render_Skeet = function(text, ay, color, size, fonts)
    ts = Render.CalcTextSize(text, size, fonts)
    Render.GradientBoxFilled(Vector2.new(13, sc.y/1.48 - 5 + ay), Vector2.new(13 + (ts.x) / 2, sc.y/1.48 - 5 + ay + 28), Color.RGBA(0, 0, 0, 0), Color.RGBA(0, 0, 0, 65), Color.RGBA(0, 0, 0, 0), Color.RGBA(0, 0, 0, 65))
    Render.GradientBoxFilled(Vector2.new(13 + (ts.x) / 2, sc.y/1.48 - 5 + ay), Vector2.new(13 + (ts.x), sc.y/1.48 - 5 + ay + 28), Color.RGBA(0, 0, 0, 65), Color.RGBA(0, 0, 0, 0), Color.RGBA(0, 0, 0, 65), Color.RGBA(0, 0, 0, 0))
    Render.Text(text, Vector2.new(sc.x/100 + 2, sc.y/1.48 - 5 + 5 + ay), Color.new(0, 0, 0, 1), size, fonts)
    Render.Text(text, Vector2.new(sc.x/100 + 2, sc.y/1.48 - 5 + 4 + ay), color, size, fonts)
end

Cheat.RegisterCallback("prediction", function(cmd)
    local lp = EntityList.GetLocalPlayer()
    local forw = bit.band(cmd.buttons, 8) == 8
    local back = bit.band(cmd.buttons, 16) == 16
    local righ = bit.band(cmd.buttons, 512) == 512
    local left = bit.band(cmd.buttons, 1024) == 1024

    local originalpos = lp:GetProp("m_vecOrigin")
    local OnGround = bit.band(lp:GetProp("m_hGroundEntity"), 1);
  
    if OnGround == 1 then
        air = true
    else
        air = false
    end
    if AP:Get() == false then
        curpos = lp:GetProp("m_vecOrigin");
    end
    if ui.autopeek:Get() then
        if AP:Get() then
            if forw == false and back == false and left == false and righ == false and curpos.x ~= originalpos.x and curpos.y ~= originalpos.y and air == false then
                setmovement(curpos.x,curpos.y, cmd);
            end
        end
    end

    if GlobalVars.tickcount%64<2 and aa[0].fake_flick:Get() and aa[0].antiaims:Get() then
        AntiAim.OverrideYawOffset(90*(AntiAim.GetInverterState()and-1 or 1))
    end
end)

local zxc = 0
local draw = function()
    add_y = 0

    --colors
    local r = math.floor(ui.color:Get().r*255)
    local g = math.floor(ui.color:Get().g*255)
    local b = math.floor(ui.color:Get().b*255)
    local a = ui.alpha:Get()
    
    local dmg = false
    local binds = Cheat.GetBinds()
    for i = 1, #binds do
        if binds[i]:GetName() == "Minimum Damage" and binds[i]:IsActive() then
            dmg = true
        end
    end

    local manuals = yaw_base:Get() == 2 or yaw_base:Get() == 3

    --menu blur
    if ui.blur:Get() then
        if Cheat.IsMenuVisible() then
            if anim[1] < 255 then anim[1] = anim[1] + 10 end
        else
            if anim[1] > 0 then anim[1] = anim[1] - 10 end
        end
        Render.Blur(Vector2.new(0, 0), Vector2.new(x, y), Color.RGBA(255,255,255, anim[1]))
    end

    if ui.disable_os:GetBool() then
        if HS:GetBool() then
            FL:SetInt(1)
        else
            FL:SetInt(14)
        end
    end

    --molotov wireframe
    for _, v in pairs(materials) do
        local material = MatSystem.FindMaterial(v, "")

        if material ~= nil then
            material:SetMaterialVarFlag(bit.lshift(1, 28), ui.wireframe:Get())
            material:SetMaterialVarFlag(bit.lshift(1, 15), ui.ignorez:Get())
        end
    end

    --console color changer
    if ui.console:Get() then
        findConsoleMaterials()

        local color = ui.console:GetColor()
        local consoleVisible = isConsoleVisible(engineClientClass)

        if consoleVisible and not isColorEquals(oldColor, color) then
            updateConsoleColor(color.r, color.g, color.b, color.a)
            copyColor(color, oldColor)
        end

        if consoleVisible ~= oldConsoleIsVisible then
            if not consoleVisible then
                updateConsoleColor(1, 1, 1, 1)
            else
                updateConsoleColor(color.r, color.g, color.b, color.a)
            end

            oldConsoleIsVisible = consoleVisible
        end
    end

    --anti defensive
    local lc = CVar.FindVar("cl_lagcompensation")
    if ui.antidefensive:Get() then
        if lc:GetInt() == 1 then
            EngineClient.ExecuteClientCmd("jointeam 1")
            lc:SetInt(0)
        end
    else
        if lc:GetInt() == 0 then
            EngineClient.ExecuteClientCmd("jointeam 1")
            lc:SetInt(1)
        end
    end

    local lp = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
    if lp == nil then
        logs = {}
        return
    end
    
    if AP:Get() and ui.glowpeek:Get() then
        if autopeek_origin == nil then
            autopeek_origin = lp:GetProp('m_vecOrigin')
        end
        for i = 1, 60 do
            local autopeek_value = 1/i
            if i <= 60 then
                autopeek_value = autopeek_value + 1.5
            end
            local autopeek_color = ui.glowpeek:GetColor()
            if AP:Get() then
                Render.Circle3DFilled(autopeek_origin, 28, i / -2.5, Color.new(autopeek_color.r, autopeek_color.g, autopeek_color.b, autopeek_value / 50 * autopeek_color.a))
                Render.Circle3DFilled(autopeek_origin, 18, i / -2.6, Color.new(autopeek_color.r, autopeek_color.g, autopeek_color.b, autopeek_value / 50 * autopeek_color.a))
            end
        end
    else
        autopeek_origin = nil
    end

    --hitlogs
    if #logs > 0 then
        if GlobalVars.tickcount >= logs[1][2] then
            if logs[1][3] > 0 then
                logs[1][3] = logs[1][3] - 2
            elseif logs[1][3] <= 0 then
                table.remove(logs, 1)
            end
        end
        if #logs > 5 then
            table.remove(logs, 1)
        end
        for i = 1, #logs do
            ts = Render.CalcTextSize(logs[i][1], 11, font.verdana)
            if logs[i][3] < 255 then logs[i][3] = logs[i][3] + 1 end
            Render.Blur(Vector2.new(math.min(50, logs[i][3]*2)-60 + x/2-ts.x/2, y-256+34*i), Vector2.new(math.min(50, logs[i][3]*2)-40 + x/2+ts.x/2, y-242+34*i+ts.y), Color.RGBA(0,0,0, math.min(255, logs[i][3]*5)), 100)
            Render.BoxFilled(Vector2.new(math.min(50, logs[i][3]*2)-50 + x/2-ts.x/2, y-256+34*i), Vector2.new(math.min(50, logs[i][3]*2)-50 + x/2-ts.x/2+math.min(ts.x, logs[i][3]*7), y-254+34*i), Color.RGBA(r,g,b,math.min(255, logs[i][3]*5)))
            Render.BoxFilled(Vector2.new(math.min(50, logs[i][3]*2)-50 + x/2+ts.x/2-math.min(ts.x, logs[i][3]*7), y-241+ts.y+34*i), Vector2.new(math.min(50, logs[i][3]*2)-50 + x/2+ts.x/2, y-243+ts.y+34*i), Color.RGBA(r,g,b,math.min(255, logs[i][3]*5)))
            Render.Circle(Vector2.new(math.min(50, logs[i][3]*2)-50 + x/2-ts.x/2, y-243+34*i), 12, 32, Color.RGBA(r,g,b,math.min(255, logs[i][3]*5)), 2, 270-math.min(180, logs[i][3]*3), 270)
            Render.Circle(Vector2.new(math.min(50, logs[i][3]*2)-50 + x/2+ts.x/2, y-243+34*i), 12, 32, Color.RGBA(r,g,b,math.min(255, logs[i][3]*5)), 2.5, 90, 90-math.min(180, logs[i][3]*3))
            Render.Text(logs[i][1], Vector2.new(math.min(50, logs[i][3]*2)-49 + x/2-ts.x/2, y-249+34*i), Color.RGBA(0,0,0, math.min(255, logs[i][3]*5)), 11, font.verdana)
            Render.Text(logs[i][1], Vector2.new(math.min(50, logs[i][3]*2)-50 + x/2-ts.x/2, y-250+34*i), Color.RGBA(255,255,255, math.min(255, logs[i][3]*5)), 11, font.verdana)
            Render.Text("[Mozk-Yaw] ", Vector2.new(math.min(50, logs[i][3]*2)-49 + x/2-ts.x/2, y-249+34*i), Color.RGBA(0,0,0, math.min(255, logs[i][3]*5)), 11, font.verdana)
            Render.Text("[Mozk-Yaw] ", Vector2.new(math.min(50, logs[i][3]*2)-50 + x/2-ts.x/2, y-250+34*i), Color.RGBA(r,g,b, math.min(255, logs[i][3]*5)), 11, font.verdana)
        end
    end
    local delta_to_draw = math.abs(normalize_yaw(AntiAim.GetCurrentRealRotation()%360 - AntiAim.GetFakeRotation()%360))/2
    
    local chocking = ClientState.m_choked_commands
    if chocking < OldChoke then
        toDraw0 = toDraw1
        toDraw1 = toDraw2
        toDraw2 = toDraw3
        toDraw3 = toDraw4
        toDraw4 = OldChoke
    end
    OldChoke = chocking

    --skeet indicators
    if ui.indicators:Get(5) then
        add_y = 0

        if ui.add_indicators:Get(1) then
            Render_Skeet(string.format('%i-%i-%i-%i-%i',toDraw4,toDraw3,toDraw2,toDraw1,toDraw0), add_y, Color.RGBA(235 ,235, 235, 255), 22, font.calibrib)
            add_y = add_y - 35
        end

        if ui.add_indicators:Get(2) and lp:GetPlayer():IsAlive() then
            Render_Skeet("EX", add_y, DT:Get() and bit.band(lp:GetPlayer():GetProp("m_fFlags"), bit.lshift(1,0)) == 0 and Color.RGBA(132, 195, 16, 255) or Color.RGBA(208, 208, 20, 255), 22, font.calibrib)
            add_y = add_y - 35
        end

        if ui.add_indicators:Get(3) and dmg == true then
            Render_Skeet("DMG:"..MD:Get(), add_y, Color.RGBA(255, 255, 255, 150), 22, font.calibrib)
            add_y = add_y - 35
        end

        if ui.add_indicators:Get(4) and yaw_base:Get() == 5 then
            Render_Skeet("FS", add_y, Color.RGBA(235 ,235, 235, 255), 22, font.calibrib)
            add_y = add_y - 35
        end

        if PING:Get() > 0 then
            Render_Skeet("PING", add_y, Color.RGBA(math.floor(255 - ((PING:Get() / 189 * 60) * 2.29824561404)), math.floor((PING:Get() / 189 * 60) * 3.42105263158), math.floor((PING:Get() / 189 * 60) * 0.22807017543), 255), 22, font.calibrib)
            add_y = add_y - 35
           end
        
        if FD:Get() then
            Render_Skeet("DUCK", add_y, Color.RGBA(235 ,235, 235, 255), 22, font.calibrib)
            add_y = add_y - 35
        end

        local c4 = EntityList.GetEntitiesByClassID(129)[1];
        if c4 ~= nil then
            local time = ((c4:GetProp("m_flC4Blow") - GlobalVars.curtime)*10) / 10
            local timer = string.format("%.1f", time)
            local defused = c4:GetProp("m_bBombDefused")
            if math.floor(timer) > 0 and not defused then
                local defusestart = c4:GetProp("m_hBombDefuser") ~= 4294967295
                local defuselength = c4:GetProp("m_flDefuseLength")
                local defusetimer = defusestart and math.floor((c4:GetProp("m_flDefuseCountDown") - GlobalVars.curtime)*10) / 10 or -1
                if defusetimer > 0 then
                    local color = math.floor(timer) > defusetimer and Color.RGBA(58, 191, 54, 160) or Color.RGBA(252, 18, 19, 125)
                    
                    local barlength = (((sc.y - 50) / defuselength) * (defusetimer))
                    Render.BoxFilled(Vector2.new(0.0, 0.0), Vector2.new(16, sc.y), Color.RGBA(25, 25, 25, 160))
                    Render.Box(Vector2.new(0.0, 0.0), Vector2.new(16, sc.y), Color.RGBA(25, 25, 25, 160))
                    
                    Render.BoxFilled(Vector2.new(0, sc.y - barlength), Vector2.new(16, sc.y), color)
                end
                
                local bombsite = c4:GetProp("m_nBombSite") == 0 and "A" or "B"
                local health = lp:GetProp("m_iHealth")
                local armor = lp:GetProp("m_ArmorValue")
                local willKill = false
                local eLoc = c4:GetRenderOrigin()
                local lLoc = lp:GetRenderOrigin()
                local distance = eLoc:DistTo(lLoc)
                local a = 450.7
                local b = 75.68
                local c = 789.2
                local d = (distance - b) / c;

                local damage = a * math.exp(-d * d)
                if armor > 0 then
                    local newDmg = damage * 0.5;
    
                    local armorDmg = (damage - newDmg) * 0.5
                    if armorDmg > armor then
                        armor = armor * (1 / .5)
                        newDmg = damage - armorDmg
                    end
                    damage = newDmg;
                end
                local dmg = math.ceil(damage)
                    if dmg >= health then
                    willKill = true
                else
                    willKill = false
                end
                Render_Skeet(bombsite.." - "..string.format("%.1f", timer).."s", add_y, Color.RGBA(235 ,235, 235, 255), 22, font.calibrib)
                add_y = add_y - 35
                if lp then
                    if willKill == true then
                        Render_Skeet("FATAL", add_y, Color.RGBA(255, 0, 0, 255), 22, font.calibrib)
                        add_y = add_y - 35
                    elseif damage > 0.5 then
                        Render_Skeet("-"..dmg.." HP", add_y, Color.RGBA(210, 216, 112, 255), 22, font.calibrib)
                        add_y = add_y - 35
                    end
                end
            end
        end
        if planting then
            Render_Skeet(planting_site, add_y, Color.RGBA(210, 216, 112, 255), 22, font.calibrib)
            fill = 3.125 - (3.125 + on_plant_time - GlobalVars.curtime)
            if(fill > 3.125) then
                fill = 3.125
            end
            ts = Render.CalcTextSize(planting_site, 22, font.calibrib)
            Render.Circle(Vector2.new(sc.x/100 + 2 + ts.x+18, sc.y/1.48 - 5+add_y+ts.y/2+3), 8, 32, Color.RGBA(0, 0, 0, 255), 4, 0, 360)
            Render.Circle(Vector2.new(sc.x/100 + 2 + ts.x+18, sc.y/1.48 - 5+add_y+ts.y/2+3), 8, 32, Color.RGBA(235 ,235, 235, 255), 3, 0, (fill/3.3)*360)
            add_y = add_y - 35
        end       
        
        if DT:Get() then
            Render_Skeet("DT", add_y, Exploits.GetCharge() == 1 and Color.RGBA(235 ,235, 235, 255) or Color.RGBA(255, 0, 0, 255), 22, font.calibrib)
            add_y = add_y - 35
        end
    end
    
    if ui.windows:Get(1) then
        local ping = math.floor(EngineClient.GetNetChannelInfo():GetLatency(0)*1000)
        local local_time = ffi.new("SYSTEMTIME")
        ffi.C.GetLocalTime(local_time)

        text_wm = "Mozk-Yaw | "..Cheat.GetCheatUserName().." | delay: "..ping.." | "..string.format("%02d:%02d:%02d", local_time.wHour, local_time.wMinute, local_time.wSecond)
        ts_wm = Render.CalcTextSize(text_wm, 11, font.verdana) + 16

        Render.Blur(Vector2.new(x-ts_wm.x-6, 10), Vector2.new(x-10, 28), Color.RGBA(100, 100, 100, a))
        Render.BoxFilled(Vector2.new(x-ts_wm.x-6, 8), Vector2.new(x-10, 10), Color.RGBA(r, g, b, 255))

        Render.Text(text_wm, Vector2.new(x-ts_wm.x+1, 13), Color.RGBA(0, 0, 0, 255), 11, font.verdana)
        Render.Text(text_wm, Vector2.new(x-ts_wm.x, 12), Color.RGBA(255, 255, 255, 255), 11, font.verdana)
    end

    if ui.windows:Get(2) then
        local players = EntityList.GetPlayers()
        local specs = {}
        local local_player = EntityList.GetLocalPlayer()
        for table_index, player_pointer in pairs(players) do
            if player_pointer and player_pointer:GetProp("m_iHealth") <= 0 then
                local local_player = EntityList.GetLocalPlayer()
                if local_player:IsAlive() then
                    local player = player_pointer
                    local spec_handle = player:GetProp("m_hObserverTarget")
                    local spec_player = EntityList.GetClientEntityFromHandle(spec_handle)
                    if spec_player ~= nil then
                        if spec_player:GetPlayer() == local_player:GetPlayer() then
                            specs[#specs+1] = player_pointer:GetName()
                        end
                    end
                else
                    local observer = player_pointer:GetProp('m_hObserverTarget')
                    local player = EntityList.GetLocalPlayer()
                    local localtarget = player:GetProp('m_hObserverTarget')
                    if observer == localtarget then
                        specs[#specs+1] = player_pointer:GetName()
                    end
                end
            end
        end
        xxx = ui.specs_x:Get()
        yyy = ui.specs_y:Get()
        if #specs > 0 or Cheat.IsMenuVisible() then
            Render.Blur(Vector2.new(xxx - 80, yyy - 4), Vector2.new(xxx + 80, yyy + 14), Color.RGBA(100, 100, 100, a))
            Render.BoxFilled(Vector2.new(xxx - 80, yyy - 6), Vector2.new(xxx + 80, yyy - 4), Color.RGBA(r, g, b, 255))
            ts = Render.CalcTextSize("spectators", 11, font.verdana)
            Render.Text("spectators", Vector2.new(xxx - ts.x/2+1, yyy - 1), Color.RGBA(0, 0, 0, 255), 11, font.verdana)
            Render.Text("spectators", Vector2.new(xxx - ts.x/2, yyy - 2), Color.RGBA(255, 255, 255, 255), 11, font.verdana)
            for i = 1, #specs do
                Render.Text(specs[i], Vector2.new(xxx - 76, yyy + 1 + i * 17), Color.RGBA(0, 0, 0, 255), 11, font.verdana)
                Render.Text(specs[i], Vector2.new(xxx - 77, yyy + i * 17), Color.RGBA(255, 255, 255, 255), 11, font.verdana)
            end
        end
        if Cheat.IsKeyDown(0x1) then
            local mouse = Cheat.GetMousePos()
            local ts = Render.CalcTextSize("spectators", 12)
            if drag[2] == true then
                ui.specs_x:SetInt(mouse.x)
                ui.specs_y:SetInt(mouse.y)
            end
            if mouse.x >= xxx - 70 and mouse.y >= yyy and mouse.x <= xxx + 70 and mouse.y <= yyy + ts.y then
                if drag[1] == false then drag[2] = true end
            end
        else
            drag[2] = false
        end
    end

    if ui.windows:Get(3) then
        local binds = Cheat.GetBinds()
        xx = ui.binds_x:Get()
        yy = ui.binds_y:Get()
        if #binds > 0 or Cheat.IsMenuVisible() then
            for i = 1, #binds do
                if binds[i]:IsActive() then
                    if keysAnim[i] < 255 then keysAnim[i] = keysAnim[i] + 30 else keysAnim[i] = 255 end
                else
                    if keysAnim[i] > 0 then keysAnim[i] = keysAnim[i] - 30 else keysAnim[i] = 0 end
                end
                mode = binds[i]:GetMode() == 0 and "[toggled]" or binds[i]:GetMode() == 1 and "[holding]"
                ts = Render.CalcTextSize(mode, 11, font.verdana)
                Render.Text(binds[i]:GetName(), Vector2.new(xx - 76, yy + 1 + i * 17), Color.RGBA(0, 0, 0, keysAnim[i]), 11, font.verdana)
                Render.Text(binds[i]:GetName(), Vector2.new(xx - 77, yy + i * 17), Color.RGBA(255, 255, 255, keysAnim[i]), 11, font.verdana)

                Render.Text(mode, Vector2.new(xx + 78-ts.x, yy + 1 + i * 17), Color.RGBA(0, 0, 0, keysAnim[i]), 11, font.verdana)
                Render.Text(mode, Vector2.new(xx + 77-ts.x, yy + i * 17), Color.RGBA(255, 255, 255, keysAnim[i]), 11, font.verdana)
            end
            Render.Blur(Vector2.new(xx - 80, yy - 4), Vector2.new(xx + 80, yy + 14), Color.RGBA(100, 100, 100, a))
            Render.BoxFilled(Vector2.new(xx - 80, yy - 6), Vector2.new(xx + 80, yy - 4), Color.RGBA(r, g, b, 255))
            ts = Render.CalcTextSize("keybinds", 11, font.verdana)
            Render.Text("keybinds", Vector2.new(xx - ts.x/2+1, yy - 1), Color.RGBA(0, 0, 0, 255), 11, font.verdana)
            Render.Text("keybinds", Vector2.new(xx - ts.x/2, yy - 2), Color.RGBA(255, 255, 255, 255), 11, font.verdana)
        end
        if Cheat.IsKeyDown(0x1) then
            local mouse = Cheat.GetMousePos()
            local ts = Render.CalcTextSize("keybinds", 12)
            if drag[1] == true then
                ui.binds_x:SetInt(mouse.x)
                ui.binds_y:SetInt(mouse.y)
            end
            if mouse.x >= xx - 70 and mouse.y >= yy and mouse.x <= xx + 70 and mouse.y <= yy + ts.y then
                if drag[2] == false then drag[1] = true end
            end
        else
            drag[1] = false
        end
    end

    if ui.windows:Get(4) then
        --fl
        text_fl = DT:Get() and "FL: "..chocking.." | SHIFTING" or "FL: "..chocking
        ts_fl = Render.CalcTextSize(text_fl, 11, font.verdana) + 16
        fl_clr = Color.RGBA(math.floor(255 - (chocking * 8.57142857142)), math.floor(chocking * 14.28105263158), math.floor(chocking * 0.84807017543), 255)
        fl_clr1 = Color.RGBA(math.floor(255 - (chocking * 8.57142857142)), math.floor(chocking * 14.28105263158), math.floor(chocking * 0.84807017543), 0)
        Render.Blur(Vector2.new(x-ts_fl.x-6, 35), Vector2.new(x-10, 53), Color.RGBA(100, 100, 100, a))
        Render.GradientBoxFilled(Vector2.new(x-ts_fl.x/2-6, 53), Vector2.new(x-10, 54), fl_clr, fl_clr1, fl_clr, fl_clr1)
        Render.GradientBoxFilled(Vector2.new(x-ts_fl.x-6, 53), Vector2.new(x-ts_fl.x/2-6, 54), fl_clr1, fl_clr, fl_clr1, fl_clr)
        Render.Text(text_fl, Vector2.new(x-ts_fl.x+1, 38), Color.RGBA(0, 0, 0, 255), 11, font.verdana)
        Render.Text(text_fl, Vector2.new(x-ts_fl.x, 37), Color.RGBA(255, 255, 255, 255), 11, font.verdana)

        --fake
        text_fake = string.format("FAKE (%.1f°)",delta_to_draw)
        ts_fake = Render.CalcTextSize(text_fake, 11, font.verdana) + 16
        local fake_clr = Color.RGBA(math.floor(255 - (delta_to_draw * 2.29824561404)), math.floor(delta_to_draw * 3.42105263158), math.floor(delta_to_draw * 0.22807017543), 255)
        local fake_clr1 = Color.RGBA(math.floor(255 - (delta_to_draw * 2.29824561404)), math.floor(delta_to_draw * 3.42105263158), math.floor(delta_to_draw * 0.22807017543), 0)
        Render.GradientBoxFilled(Vector2.new(x-(ts_fl.x+ts_fake.x/2)-6, 35), Vector2.new(x-ts_fl.x-10, 53), Color.RGBA(0, 0, 0, a), Color.new(0, 0, 0, 0), Color.RGBA(0, 0, 0, a), Color.new(0, 0, 0, 0))
        Render.GradientBoxFilled(Vector2.new(x-(ts_fl.x+ts_fake.x)-6, 35), Vector2.new(x-(ts_fl.x+ts_fake.x/2)-6, 53), Color.new(0, 0, 0, 0), Color.RGBA(0, 0, 0, a), Color.new(0, 0, 0, 0), Color.RGBA(0, 0, 0, a))

        Render.GradientBoxFilled(Vector2.new(x-(ts_fl.x+ts_fake.x)-4, 34), Vector2.new(x-(ts_fl.x+ts_fake.x)-6, 44), fake_clr1, fake_clr1, fake_clr, fake_clr)
        Render.GradientBoxFilled(Vector2.new(x-(ts_fl.x+ts_fake.x)-4, 44), Vector2.new(x-(ts_fl.x+ts_fake.x)-6, 54), fake_clr, fake_clr, fake_clr1, fake_clr1)
        Render.Text(text_fake, Vector2.new(x-(ts_fl.x+ts_fake.x)+1, 38), Color.RGBA(0, 0, 0, 255), 11, font.verdana)
        Render.Text(text_fake, Vector2.new(x-(ts_fl.x+ts_fake.x), 37), Color.RGBA(255, 255, 255, 255), 11, font.verdana)
    end

    local calcs = {
        deg2rad = function(self, x)
            return x * (math.pi / 180.0)
        end,
    
        rotated_position = function(self, start, rotation, distance)
            local rad = self:deg2rad(rotation)
            local new_start = Vector.new(start.x, start.y, start.z)
            new_start.x = new_start.x + math.cos(rad) * distance
            new_start.y = new_start.y + math.sin(rad) * distance
    
            return new_start
        end
    }

    if lp:GetPlayer():IsAlive() then
        local view_angles = EngineClient.GetViewAngles()
        local real_yaw = AntiAim.GetCurrentRealRotation()
        local view_yaw = view_angles.yaw - 180;
        local fake = adjust_angle(real_yaw - view_yaw);
        local fake_clr = Color.RGBA(math.floor(255 - (delta_to_draw * 2.29824561404)), math.floor(delta_to_draw * 3.42105263158), math.floor(delta_to_draw * 0.22807017543), 255)
        local clr = Color.new(ui.circle:GetColor().r, ui.circle:GetColor().g, ui.circle:GetColor().b, 1)
        if ui.circle:GetBool() then
            if ui.circle_style:GetInt() == 0 then
                Render.Circle(Vector2.new(x/2, y/2), 7, 32, Color.new(0, 0, 0, 1), 4, 0, 360)
                Render.Circle(Vector2.new(x/2, y/2), 7, 32, fake_clr, 4, 90, AntiAim.GetInverterState() == false and -90 or 270)
                Render.Circle(Vector2.new(x/2, y/2), 15, 32, fake_clr, 4, fake+30, fake-30)
            else
                local real_rotation = calcs:deg2rad(view_angles.yaw - AntiAim.GetCurrentRealRotation() - 90);
                Render.PolyFilled(AntiAim.GetInverterState() and Color.new(1, 1, 1, 1) or clr,
                    Vector2.new(x/2 + math.cos(real_rotation) * 45,
                                y/2 + math.sin(real_rotation) * 45),
                    Vector2.new(x/2 + math.cos(real_rotation - calcs:deg2rad(20)) * (45 - 15),
                                y/2 + math.sin(real_rotation - calcs:deg2rad(20)) * (45 - 15)),
                    Vector2.new(x/2 + math.cos(real_rotation) * (45 - 13),
                                y/2 + math.sin(real_rotation) * (45 - 13))
                )
                Render.PolyFilled(AntiAim.GetInverterState() and clr or Color.new(1, 1, 1, 1),
                Vector2.new(x/2 + math.cos(real_rotation) * 45,
                            y/2 + math.sin(real_rotation) * 45),
                Vector2.new(x/2 + math.cos(real_rotation + calcs:deg2rad(20)) * (45 - 15),
                            y/2 + math.sin(real_rotation + calcs:deg2rad(20)) * (45 - 15)),
                Vector2.new(x/2 + math.cos(real_rotation) * (45 - 13),
                            y/2 + math.sin(real_rotation) * (45 - 13))
            )
            end
        end

        if ui.idealtick:Get() and AP:Get() then
            if ui.add_idealtick:Get(1) then
                aa[0].manual:SetInt(6)
            end
            zxc = 1
        elseif zxc == 1 then
            aa[0].manual:SetInt(0)
            zxc = 0
        end

        --hitchance and dmg
        local active_weapon = lp:GetPlayer():GetActiveWeapon()
        if active_weapon == nil then return end
        local weapon_id = active_weapon:GetWeaponID()
        local players = EntityList.GetPlayers()
        for _, player in ipairs(players) do
            if not player:IsTeamMate() then
                local user_index = player:EntIndex()
                if ui.air_hitchance:Get() and weapon_id == 40 and bit.band(lp:GetProp("m_fFlags"), bit.lshift(1,0)) == 0 then
                    RageBot.OverrideHitchance(user_index, ui.air_hitchance_value:Get())
                end
                if ui.ns_hitchance:Get() and weapon_id == 11 or weapon_id == 38 and not lp:GetPlayer():GetProp("m_bIsScoped") then
                    RageBot.OverrideHitchance(user_index, ui.ns_hitchance_value:Get())
                end
                if ui.idealtick:Get() and AP:Get() then
                    if ui.add_idealtick:Get(2) then
                        RageBot.OverrideMinDamage(user_index, ui.idealtick_damage:Get())
                    end
                    if ui.add_idealtick:Get(3) then
                        RageBot.ForceHitboxSafety(user_index, 0)
                    end
                end
            end
        end
        
        --state
        local ax = 0
        if ui.state_panel:Get() then
            arrows = AntiAim.GetInverterState() and "<" or ">"
            Render.Text("Mozk-Yaw - V1.2.1 | "..Cheat.GetCheatUserName(), Vector2.new(x/20, y/2.4+30), Color.RGBA(255,255,255,255), 10, font.pixel, true)
            Render.Text("+ INVERTER: "..arrows.." | STATE: "..aastate, Vector2.new(x/20, y/2.4+42), Color.RGBA(125, 125, 125, 255), 10, font.pixel, true)
            Render.Text("+ FAKELAG COUNTER: "..string.format("%i-%i-%i-%i-%i",toDraw4,toDraw3,toDraw2,toDraw1,toDraw0), Vector2.new(x/20, y/2.4+54), Color.RGBA(125, 125, 125, 255), 10, font.pixel, true)
            Render.Text("+ DOUBLE-TAP: ", Vector2.new(x/20, y/2.4+66), Color.RGBA(125, 125, 125, 255), 10, font.pixel, true)
            ax = ax + Render.CalcTextSize("+ DOUBLE-TAP: ", 10, font.pixel).x
            Render.Text(DT:Get() and "ON" or "OFF", Vector2.new(x/20+ax, y/2.4+66), DT:Get() and Color.RGBA(80, 255, 80, 255) or Color.RGBA(255, 80, 80, 255), 10, font.pixel, true)
            ax = ax + Render.CalcTextSize(DT:Get() and "ON " or "OFF ", 10, font.pixel).x
            Render.Text("| OS-AA: ", Vector2.new(x/20+ax, y/2.4+66), Color.RGBA(125, 125, 125, 255),10, font.pixel, true)
            ax = ax + Render.CalcTextSize("| OS-AA: ", 10, font.pixel).x
            Render.Text(HS:Get() and "ON" or "OFF", Vector2.new(x/20+ax, y/2.4+66), HS:Get() and Color.RGBA(80, 255, 80, 255) or Color.RGBA(255, 80, 80, 255), 10, font.pixel, true)
        end

        --holo panel
        ay = 0
        if ui.windows:Get(5) and ui.viewmodel:Get() or ui.windows:Get(5) and not lp:GetPlayer():GetProp("m_bIsScoped") then
            if ui.holo_on_tp:Get() and not TP:Get() or ui.holo_on_tp:Get() == false and TP:Get() or TP:Get() == false then
                local muzzle_temp = muzzle.get()

                if muzzle_temp then
                    muzzle.pos = muzzle_temp.pos
                end
                
                local hitbox = lp:GetPlayer():GetHitboxCenter(3)
                local world_stand =  Render.WorldToScreen(hitbox)
                local pos2d = Render.WorldToScreen(muzzle.pos)
                if DT:Get() then
                    ay = 13
                else
                    ay = 0
                end
                if TP:Get() then
                    if world_stand.x ~= nil and world_stand.y ~= nil then
                        Render.Line(Vector2.new(Visuals_HoloX, Visuals_HoloY+ay+65), Vector2.new(x/2, world_stand.y), Color.RGBA(100,100,100,220))
                        local lerpx = lerp(Visuals_HoloX, world_stand.x + 10, GlobalVars.frametime * 8)
                        local lerpy = lerp(Visuals_HoloY, world_stand.y - 90, GlobalVars.frametime * 8)
                        if lerpx >= 0 and lerpx <= 2000 and lerpy >= 0 and lerpy <= 1500 then
                            Visuals_HoloX = lerp(Visuals_HoloX, world_stand.x + 10, GlobalVars.frametime * 8)
                            Visuals_HoloY = lerp(Visuals_HoloY, world_stand.y - 90, GlobalVars.frametime * 8)
                        else
                            Visuals_HoloX = world_stand.x + 10
                            Visuals_HoloY = world_stand.y - 90
                        end
                    end
                else
                    if pos2d.x ~= nil and pos2d.y ~= nil then
                        local lerpx = lerp(Visuals_HoloX, pos2d.x - 20, GlobalVars.frametime * 8)
                        local lerpy = lerp(Visuals_HoloY, pos2d.y - 125, GlobalVars.frametime * 8)
                        Render.Line(Vector2.new(Visuals_HoloX, Visuals_HoloY+ay+65), Vector2.new(pos2d.x, pos2d.y), Color.RGBA(100,100,100,220))
                        if lerpx >= 0 and lerpx <= 3000 and lerpy >= 0 and lerpy <= 2000 then
                            Visuals_HoloX = lerp(Visuals_HoloX, pos2d.x - 20, GlobalVars.frametime * 8)
                            Visuals_HoloY = lerp(Visuals_HoloY, pos2d.y - 125, GlobalVars.frametime * 8)
                        else
                            Visuals_HoloX = pos2d.x - 20
                            Visuals_HoloY = pos2d.y - 125
                        end
                    end
                end   

                Render.Blur(Vector2.new(Visuals_HoloX, Visuals_HoloY), Vector2.new(170 + Visuals_HoloX, (65 + ay) + Visuals_HoloY))
                
                Render.BoxFilled(Vector2.new(Visuals_HoloX, Visuals_HoloY), Vector2.new(170 + Visuals_HoloX, 2 + Visuals_HoloY), Color.RGBA(r, g, b, 255))
                

                Render.Text("ANTI-AIMBOT DEBUG", Vector2.new(Visuals_HoloX + 7, Visuals_HoloY + 5 ), Color.new(1.0, 1.0, 1.0, 1.0), 10, font.pixel, true)

                local fake_clr = Color.RGBA(math.floor(255 - (delta_to_draw * 2.29824561404)), math.floor(delta_to_draw * 3.42105263158), math.floor(delta_to_draw * 0.22807017543), 255)
                local fake_clr1 = Color.RGBA(math.floor(255 - (delta_to_draw * 2.29824561404)), math.floor(delta_to_draw * 3.42105263158), math.floor(delta_to_draw * 0.22807017543), 0)

                Render.GradientBoxFilled(Vector2.new(Visuals_HoloX + 8, Visuals_HoloY+36), Vector2.new(Visuals_HoloX + 10, Visuals_HoloY+46), fake_clr, fake_clr, fake_clr1, fake_clr1)
                Render.GradientBoxFilled(Vector2.new(Visuals_HoloX + 8, Visuals_HoloY+26), Vector2.new(Visuals_HoloX + 10, Visuals_HoloY+36), fake_clr1, fake_clr1, fake_clr, fake_clr)

                local view_angles = EngineClient.GetViewAngles()
                local fake_yaw = AntiAim.GetFakeRotation()
                local real_yaw = AntiAim.GetCurrentRealRotation()
                local view_yaw = view_angles.yaw - 180;
                local fake = adjust_angle(fake_yaw - view_yaw);
                local real = adjust_angle(real_yaw - view_yaw);

                Render.Circle(Vector2.new(Visuals_HoloX + 150, Visuals_HoloY+22), 9, 32, Color.RGBA(25,25,25,200), 2, 0, 360)
                Render.Circle(Vector2.new(Visuals_HoloX + 150, Visuals_HoloY+22), 9, 32, Color.RGBA(r, g, b, 255), 2, fake+20, fake-20)
                Render.Circle(Vector2.new(Visuals_HoloX + 150, Visuals_HoloY+22), 9, 32, Color.RGBA(200, 200, 200, 255), 2, real+10, real-10)

                Render.Text(string.format("FAKE (%.1f°)", delta_to_draw), Vector2.new(Visuals_HoloX + 14, Visuals_HoloY + 30), Color.RGBA(0, 0, 0, 255), 11, font.verdana)
                Render.Text(string.format("FAKE (%.1f°)", delta_to_draw), Vector2.new(Visuals_HoloX + 13, Visuals_HoloY + 30), Color.RGBA(255, 255, 255, 255), 11, font.verdana)

                Render.Text("SP:", Vector2.new(Visuals_HoloX + 13, Visuals_HoloY + 48), Color.new(1.0, 1.0, 1.0, 1.0), 10, font.pixel, true)

                Render.BoxFilled(Vector2.new(Visuals_HoloX + 27, Visuals_HoloY + 59), Vector2.new(53 + Visuals_HoloX, 51 + Visuals_HoloY), Color.new(0, 0, 0, 1))
                Render.BoxFilled(Vector2.new(Visuals_HoloX+ 61, Visuals_HoloY + 59), Vector2.new(87 + Visuals_HoloX, 51 + Visuals_HoloY), Color.new(0, 0, 0, 1))
                
                if ((AntiAim.GetCurrentRealRotation() - AntiAim.GetFakeRotation()) ~= nil) then
                    Render.BoxFilled(Vector2.new(Visuals_HoloX + 28, Visuals_HoloY + 58), Vector2.new(30 + Visuals_HoloX + (delta_to_draw / 2.7), 52 + Visuals_HoloY), Color.RGBA(r, g, b, 255))
                else if ((AntiAim.GetCurrentRealRotation() - AntiAim.GetFakeRotation()) < 0 and (AntiAim.GetCurrentRealRotation() - AntiAim.GetFakeRotation()) ~= nil) then
                    Render.BoxFilled(Vector2.new(Visuals_HoloX + 61, Visuals_HoloY + 59), Vector2.new(87 + Visuals_HoloX, 51 + Visuals_HoloY), Color.RGBA(r, g, b, 255))
                end
                end

                local alpha = math.min(math.floor(math.sin((GlobalVars.realtime%3) * 4) * 175 + 50), 255)
                if DT:Get() then
                    Render.Text("SHIFTING TICKBASE", Vector2.new(Visuals_HoloX + 12, Visuals_HoloY + 62), Color.RGBA(255, 255, 255, alpha), 10, font.pixel, true)
                end
                Render.Text("OSAA:", Vector2.new(Visuals_HoloX + 110, Visuals_HoloY + 49 + ay), Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
                Render.Text(HS:Get() and "ON" or "OFF", Vector2.new(Visuals_HoloX + 140, Visuals_HoloY + 49 + ay), HS:Get() and Color.RGBA(80, 255, 80, 255) or Color.RGBA(255, 80, 80, 255), 10, font.pixel, true)       
            end
        end
        --indicators
        ay = 0
        if ui.indicators:Get(1) then
            add_y = 0
            add_y = add_y + 40
            ts = Render.CalcTextSize("Mozk", 10, font.pixel)
            Render.Text("Mozk", Vector2.new(x/2 - ts.x, y/2 + add_y + 2), AntiAim.GetInverterState() and Color.RGBA(r, g, b, 255) or Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
            Render.Text("-Yaw", Vector2.new(x/2, y/2 + add_y + 2), AntiAim.GetInverterState() and Color.RGBA(255, 255, 255, 255) or Color.RGBA(r, g, b, 255), 10, font.pixel, true)
            add_y = add_y + 14
            Render.GradientBoxFilled(Vector2.new(x/2-math.floor(delta_to_draw)-7, y/2+add_y), Vector2.new(x/2, y/2+add_y+2), Color.RGBA(r, g, b, 0), Color.RGBA(r, g, b, 255), Color.RGBA(r, g, b, 0), Color.RGBA(r, g, b, 255))
            Render.GradientBoxFilled(Vector2.new(x/2+math.floor(delta_to_draw)+7, y/2+add_y), Vector2.new(x/2, y/2+add_y+2), Color.RGBA(r, g, b, 0), Color.RGBA(r, g, b, 255), Color.RGBA(r, g, b, 0), Color.RGBA(r, g, b, 255))
            add_y = add_y + 3
            if DT:Get() then
                Render_Indicator(Exploits.GetCharge() == 1 and "DOUBLETAP" or "CHARGING", add_y, Exploits.GetCharge() == 1 and Color.RGBA(255, 255, 255, 255) or Color.RGBA(255, 80, 80, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if HS:Get() then
                Render_Indicator("ON-SHOT", add_y, Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if dmg == true then
                Render_Indicator("DAMAGE", add_y, Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if FD:Get() then
                Render_Indicator("DUCK", add_y, Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if BA:Get() == 2 then
                Render_Indicator("BAIM", add_y, Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if SP:Get() == 2 then
                Render_Indicator("SP", add_y, Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
        end
        if ui.indicators:Get(2) then
            add_y = 0
            add_y = add_y + 40
            Render_Indicator("Mozk-Yaw", add_y, Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
            add_y = add_y + 9
            Render_Indicator(aastate, add_y, Color.RGBA(125, 125, 125, 255), 10, font.pixel, true)
            add_y = add_y + 9
            Render_Indicator(string.format("%i-%i-%i-%i-%i",toDraw4,toDraw3,toDraw2,toDraw1,toDraw0), add_y, Color.RGBA(125, 125, 125, 255), 10, font.pixel, true)
            add_y = add_y + 9
            if DT:Get() then
                Render_Indicator("DOUBLETAP", add_y, Exploits.GetCharge() == 1 and Color.RGBA(255, 255, 255, 255) or Color.RGBA(255, 80, 80, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if HS:Get() then
                Render_Indicator("OSAA", add_y, Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if SP:Get() == 2 then
                Render_Indicator("SAFE", add_y, Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if BA:Get() == 2 then
                Render_Indicator("BODY", add_y, Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
        end
        if ui.indicators:Get(3) then
            add_y = 0
            add_y = add_y + 40
            ts = Render.CalcTextSize("*nova", 11, font.verdanabd)
            Render.Text("*Mozk", Vector2.new(x/2 - ts.x, y/2 + add_y + 2), AntiAim.GetInverterState() and Color.RGBA(r, g, b, 255) or Color.RGBA(255, 255, 255, 255), 11, font.verdanabd, true)
            Render.Text("-Yaw*", Vector2.new(x/2, y/2 + add_y + 2), AntiAim.GetInverterState() and Color.RGBA(255, 255, 255, 255) or Color.RGBA(r, g, b, 255), 11, font.verdanabd, true)
            add_y = add_y + 13
            if HS:Get() then
                Render_Indicator("ON-SHOT", add_y, Color.RGBA(r, g, b, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if dmg == true then
                Render_Indicator("DMG", add_y, Color.RGBA(r, g, b, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if DT:Get() then
                Render_Indicator("DT", add_y, Exploits.GetCharge() == 1 and Color.RGBA(r, g, b, 255) or Color.RGBA(255, 80, 80, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if SP:Get() == 2 then
                Render_Indicator("SP", add_y, Color.RGBA(r, g, b, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
            if BA:Get() == 2 then
                Render_Indicator("BA", add_y, Color.RGBA(r, g, b, 255), 10, font.pixel, true)
                add_y = add_y + 9
            end
        end
        if ui.indicators:Get(4) then
            add_y = 0
            add_y = add_y + 40
            Render_Indicator3(manuals and "FAKE YAW" or "IDEAL YAW", add_y, manuals and Color.RGBA(159, 159, 230, 255) or Color.RGBA(220, 135, 49, 255), 12, font.tahoma)
            add_y = add_y + 10
            Render_Indicator3(yaw_base:Get() == 5 and "FREESTAND" or "DYNAMIC", add_y, Color.RGBA(209, 159, 230, 255), 12, font.tahoma)
            add_y = add_y + 10
            if DT:Get() then
                Render_Indicator3(FD:Get() and "DT (fakeduck)" or "DT", add_y, Exploits.GetCharge() == 1 and Color.RGBA(0, 255, 0, 255) or Color.RGBA(255, 0, 0, 255), 12, font.tahoma)
                add_y = add_y + 10
            end
            if HS:Get() then
                Render_Indicator3("AA", add_y, Color.RGBA(120, 128, 200, 255), 12, font.tahoma)
                add_y = add_y + 10
            end
            if dmg == true then
                Render_Indicator3("DMG", add_y, Color.RGBA(200, 185, 255, 255), 12, font.tahoma)
                add_y = add_y + 10
            end
        end

        --viewmodel in scope
        local cheats = CVar.FindVar("sv_cheats")
        local scope = CVar.FindVar("fov_cs_debug")
        if ui.viewmodel:Get() then
            cheats:SetInt(1)
            scope:SetInt(90)
        else
            scope:SetInt(0)
        end

        --custom scope
        if ui.scope:GetColor() and lp:GetPlayer():GetProp("m_bIsScoped") then
            local offset = ui.offset:Get()
            local length = ui.length:Get()
            local col = Color.new(ui.scope:GetColor().r, ui.scope:GetColor().g, ui.scope:GetColor().b, 1)
            local col1 = Color.new(ui.scope:GetColor().r, ui.scope:GetColor().g, ui.scope:GetColor().b, 0)
            Render.GradientBoxFilled(Vector2.new(x/2 - offset, y/2), Vector2.new(x/2 - offset - length, y/2 + 1), col, col1, col, col1)
            Render.GradientBoxFilled(Vector2.new(x/2 + offset, y/2), Vector2.new(x/2 + offset + length, y/2 + 1), col, col1, col, col1)
            Render.GradientBoxFilled(Vector2.new(x/2, y/2 + offset), Vector2.new(x/2 + 1, y/2 + offset + length), col, col, col1, col1)
            Render.GradientBoxFilled(Vector2.new(x/2, y/2 - offset), Vector2.new(x/2 + 1, y/2 - offset - length), col, col, col1, col1)
        end

        --manual arrows
        if ui.manual_arrows:Get() then
            local r1 = math.floor(ui.color1:Get().r*255)
            local g1 = math.floor(ui.color1:Get().g*255)
            local b1 = math.floor(ui.color1:Get().b*255)

            local r2 = math.floor(ui.color2:Get().r*255)
            local g2 = math.floor(ui.color2:Get().g*255)
            local b2 = math.floor(ui.color2:Get().b*255)

            if ui.arrows_style:Get() == 0 then
                if velocity(lp) > 44 then
                    if anim[3] < 150 then anim[3] = anim[4] + 10 end
                else
                    if anim[3] > 0 then anim[3] = anim[4] - 10 end
                end
                Render.Text(">", Vector2.new(x/2 + 45, y/2 - Render.CalcTextSize(">", 22).y/2), yaw_base:Get() == 2 and Color.RGBA(r1, g1, b1, 255) or Color.RGBA(255, 255, 255, 255 - anim[3]), 22, true)
                Render.Text("<", Vector2.new(x/2 - 45 - Render.CalcTextSize("<", 22).x, y/2 - Render.CalcTextSize("<", 22).y/2), yaw_base:Get() == 3 and Color.RGBA(r1, g1, b1, 255) or Color.RGBA(255, 255, 255, 255 - anim[3]), 22, true)
                Render.Text("v", Vector2.new(x/2 - Render.CalcTextSize("v", 19).x/2+1, y/2 + 25), yaw_base:Get() == 1 and Color.RGBA(r1, g1, b1, 255) or Color.RGBA(255, 255, 255, 255 - anim[3]), 19, true)
            elseif ui.arrows_style:Get() == 1 then
                Render.PolyFilled(yaw_base:Get() == 2 and Color.RGBA(r1, g1, b1, 255) or Color.RGBA(25, 25, 25, 150), Vector2.new(x/2 + 43, y/2 + 9), Vector2.new(x/2 + 56, y/2), Vector2.new(x/2 + 43, y/2 - 9))
                Render.PolyFilled(yaw_base:Get() == 3 and Color.RGBA(r1, g1, b1, 255) or Color.RGBA(25, 25, 25, 150), Vector2.new(x/2 - 43, y/2 + 9), Vector2.new(x/2 - 56, y/2), Vector2.new(x/2 - 43, y/2 - 9))
                Render.BoxFilled(Vector2.new(x/2 - 40, y/2 - 9),  Vector2.new(x/2 - 42, y/2 + 10), AntiAim.GetInverterState() == false and Color.RGBA(25, 25, 25, 150) or Color.RGBA(r2, g2, b2, 255))
                Render.BoxFilled(Vector2.new(x/2 + 40, y/2 - 9),  Vector2.new(x/2 + 42, y/2 + 10), AntiAim.GetInverterState() == false and Color.RGBA(r2, g2, b2, 255) or Color.RGBA(25, 25, 25, 150))
            end
        end

        --render
        if ui.damage_indicator:Get() then
            local ts = Render.CalcTextSize(tostring(MD:Get()), 10, font.pixel)
            Render.Text(dmg and "1" or "0", Vector2.new(x/2-35, y/2-50), Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
            Render.Text(tostring(MD:Get()), Vector2.new(x/2-ts.x/2+0.5, y/2-50), Color.RGBA(255, 255, 255, 255), 10, font.pixel, true)
        end

        --disable thirdperson anim
        if ui.tpanim:Get() then s = false else s = true end
        Cheat.SetThirdPersonAnim(s)
    end
end

local anti_aim = function()
        local lp = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
        if lp == nil then return end

        local active_weapon = lp:GetPlayer():GetActiveWeapon()
        if active_weapon == nil then return end
        local weapon_id = active_weapon:GetWeaponID()

        --anti aims
        if aa[0].antiaims:Get() then
            
            --tp in air
            local players = EntityList.GetPlayers()
            
            if aa[0].tp_in_air:Get() and bit.band(lp:GetPlayer():GetProp("m_fFlags"), bit.lshift(1,0)) == 0 then
                for i = 1, #players do
                    local origin = lp:GetPlayer():GetRenderOrigin()
                    local origin_players = players[i]:GetRenderOrigin()
                    local is_visible = players[i]:IsVisible(origin_players)
                    if players[i]:IsAlive() and not players[i]:IsTeamMate() and players[i]:IsAlive() and not players[i]:IsDormant() and is_visible and not active_weapon:IsKnife() then
                        Exploits.ForceTeleport()
                    end
                end
            end

            if SW:Get() and aa[6].custom_enable:Get() then
                --slow walk
                stateid = 6
                aastate = "SLOWWALKING"
            elseif bit.band(lp:GetPlayer():GetProp("m_fFlags"), bit.lshift(1,0)) == 0 and aa[4].custom_enable:Get() then
                --air
                stateid = 4
                aastate = "IN AIR"
            elseif lp:GetProp("m_flDuckAmount") > 0.8 and aa[5].custom_enable:Get() or FD:Get() and aa[5].custom_enable:Get() then
                --duck
                stateid = 5
                aastate = "CROUCHING"
            elseif velocity(lp) > 2 and aa[3].custom_enable:Get() then
                --move
                stateid = 3
                aastate = "MOVING"
            elseif velocity(lp) < 2 and aa[2].custom_enable:Get() then
                --stand
                stateid = 2
                aastate = "STANDING"
            else
                --global
                stateid = 1
                aastate = "DYNAMIC"
            end

            if legit_aa == false then
                pitch:SetInt(1)
                if aa[0].manual:Get() == 0 then
                    yaw_base:SetInt(aa[stateid].custom_yaw_base:Get())
                else
                    yaw_base:SetInt(aa[0].manual:Get()-1)
                end
                yaw(yaw_add, aa[stateid].custom_yaw_add_right:Get(), aa[stateid].custom_yaw_add_left:Get())
                yaw_modifier:SetInt(aa[stateid].custom_yaw_modifier:Get())
                modifier_degree:SetInt(aa[stateid].custom_modifier_degree:Get())
                if aa[stateid].custom_fake_type:Get() == 0 then
                    left_limit:SetInt(aa[stateid].custom_left_limit:Get())
                    right_limit:SetInt(aa[stateid].custom_right_limit:Get())
                elseif aa[stateid].custom_fake_type:Get() == 1 then
                    left_limit:SetInt(jitter(aa[stateid].custom_left_limit:Get(), aa[stateid].custom_left_limit2:Get()))
                    right_limit:SetInt(jitter(aa[stateid].custom_right_limit:Get(), aa[stateid].custom_right_limit2:Get()))
                elseif aa[stateid].custom_fake_type:Get() == 2 then
                    left_limit:SetInt(math.random(aa[stateid].custom_left_limit:Get(), aa[stateid].custom_left_limit2:Get()))
                    right_limit:SetInt(math.random(aa[stateid].custom_right_limit:Get(), aa[stateid].custom_right_limit2:Get()))
                end
                options:SetInt(aa[stateid].custom_options:Get())
                lby_mode:SetInt(aa[stateid].custom_lby:Get())
                freestand:SetInt(aa[stateid].custom_fs:Get())
                onshot:SetInt(aa[stateid].custom_onshot:Get())

                --anti backstab
                if aa[0].antibackstab:Get() then
                    local enemies = GetEnemiesWithKnife()
                    if enemies ~= nil then
                        if #enemies > 0 then
                            for i, enemy in pairs(enemies) do
                                local enemy_origin = enemy:GetRenderOrigin()
                                local local_player_origin = lp:GetRenderOrigin()
                                local distance_from_local_to_enemy = enemy_origin:DistTo(local_player_origin)               
                                if 200 >= distance_from_local_to_enemy and not players[i]:IsDormant() then
                                    AntiAim.OverrideYawOffset(180)
                                    AntiAim.OverridePitch(0)
                                end
                            end
                        end
                    end
                end
            else
                pitch:SetInt(0)
                yaw_base:SetInt(0)
                yaw(yaw_add, 0, 0)
                yaw_modifier:SetInt(1)
                modifier_degree:SetInt(0)
                left_limit:SetInt(60)
                right_limit:SetInt(60)
                options:SetInt(0)
                lby_mode:SetInt(1)
                freestand:SetInt(1)
                onshot:SetInt(1)
            end
        end
end

local phrases = {
    "1",
    "1 bot",
    "lp2 bot",
    "iq?",
    "Newfag",
    "new commer",
    "covid joiner",
    "ez bot",
    "?",
    "owned",
    "obliterated bot",
    "get good get neverlose",
    "nn",
}
local get_phrase = function()
    return phrases[Utils.RandomInt(1, #phrases)]:gsub('"', '')
end
            
Cheat.RegisterCallback("events", function(e)
    local player_resource = EntityList.GetPlayerResource()
    if e:GetName() == "bomb_abortplant" then
        planting = false
        fill = 0
        on_plant_time = 0
        planting_site = ""
    end
    if e:GetName() == "bomb_defused" then
        planting = false
        fill = 0
        on_plant_time = 0
        planting_site = ""
    end
    if e:GetName() == "bomb_planted" then
        planting = false
        fill = 0
        on_plant_time = 0
        planting_site = ""
    end
    if e:GetName() == "round_prestart" then
        planting = false
        fill = 0
        on_plant_time = 0
        planting_site = ""
    end
    
    if e:GetName() == "bomb_beginplant" then
        on_plant_time = GlobalVars.curtime
        planting = true
        local m_bombsiteCenterA = player_resource:GetProp("DT_CSPlayerResource", "m_bombsiteCenterA")
        local m_bombsiteCenterB = player_resource:GetProp("DT_CSPlayerResource", "m_bombsiteCenterB")
        
        local player = EntityList.GetPlayerForUserID(e:GetInt("userid", 0))
        local localPos = player:GetRenderOrigin()
        local dist_to_a = localPos:DistTo(m_bombsiteCenterA)
        local dist_to_b = localPos:DistTo(m_bombsiteCenterB)
        
        planting_site = dist_to_a < dist_to_b and "Bombsite A" or "Bombsite B"
    end
    if ui.hitsound:Get() == 0 then
        Menu.FindVar("Visuals","World", "Hit", "Hit Sound"):SetBool(true)
    else
        Menu.FindVar("Visuals","World", "Hit", "Hit Sound"):SetBool(false)
    end
    if e:GetName() == "player_hurt" then
        if e:GetInt("attacker", 0) ==  EntityList.GetLocalPlayer():GetPlayerInfo().userId then
            if ui.hitsound:Get() == 1 then
                EngineClient.ExecuteClientCmd("playvol buttons/arena_switch_press_02 0.75")
            elseif ui.hitsound:Get() == 2 then
                EngineClient.ExecuteClientCmd("playvol Mozk-Yaw/hitsound/hitsound.wav 0.75")
            elseif ui.hitsound:Get() == 3 then
                EngineClient.ExecuteClientCmd(string.format("playvol %s 0.75", ui.custom_hitsound:Get()))
            end
        end
    end
    if ui.trashtalk:Get() then
        if e:GetName() == "player_death" then
            local me = EntityList.GetLocalPlayer()
            local victim = EntityList.GetPlayerForUserID(e:GetInt("userid"))
            local attacker = EntityList.GetPlayerForUserID(e:GetInt("attacker"))
            if victim == attacker or attacker ~= me then return end
            EngineClient.ExecuteClientCmd('say "' .. get_phrase() .. '"')
        end
    end
end)

local setvis = function()
    local vis = function(s, d)
        s:SetVisible(d)
    end

    ui.binds_x:SetVisible(false)
    ui.binds_y:SetVisible(false)
    ui.specs_x:SetVisible(false)
    ui.specs_y:SetVisible(false)

    ui.add_idealtick:SetVisible(ui.idealtick:Get())
    ui.idealtick_damage:SetVisible(ui.add_idealtick:GetBool(2))
    ui.ns_hitchance_value:SetVisible(ui.ns_hitchance:Get())
    ui.air_hitchance_value:SetVisible(ui.air_hitchance:Get())
    ui.hitlogs_type:SetVisible(ui.hitlogs:Get())
    ui.custom_hitsound:SetVisible(ui.hitsound:Get() == 3)
    ui.holo_on_tp:SetVisible(ui.windows:Get(5))
    ui.circle_style:SetVisible(ui.circle:Get())
    ui.add_indicators:SetVisible(ui.indicators:Get(5))
    ui.offset:SetVisible(ui.scope:Get())
    ui.length:SetVisible(ui.scope:Get())

    ui.arrows_style:SetVisible(ui.manual_arrows:Get())
    ui.color1:SetVisible(ui.manual_arrows:Get())
    ui.color2:SetVisible(ui.manual_arrows:Get() and ui.arrows_style:Get() == 1)

    vis(preset, aa[0].antiaims:Get())
    vis(aa[0].manual, aa[0].antiaims:Get())
    vis(aa[0].fake_flick, aa[0].antiaims:Get())
    vis(aa[0].tp_in_air, aa[0].antiaims:Get())
    vis(aa[0].on_key, aa[0].antiaims:Get())
    vis(aa[0].antibackstab, aa[0].antiaims:Get())
    vis(aa[0].antiaim, aa[0].antiaims:Get())
    
    currentid = aa[0].antiaim:Get()+1
    vis(aa[1].custom_enable, false)
    aa[1].custom_enable:SetBool(true)
    vis(aa[2].custom_enable, aa[0].antiaims:Get() and currentid == 2)
    vis(aa[3].custom_enable, aa[0].antiaims:Get() and currentid == 3)
    vis(aa[4].custom_enable, aa[0].antiaims:Get() and currentid == 4)
    vis(aa[5].custom_enable, aa[0].antiaims:Get() and currentid == 5)
    vis(aa[6].custom_enable, aa[0].antiaims:Get() and currentid == 6)
    
    for i = 1, 6 do
        local isAA = aa[0].antiaims:Get() and aa[i].custom_enable:Get()
        local isAAF = aa[i].custom_fake_type:Get() == 1 and isAA or aa[i].custom_fake_type:Get() == 2 and isAA
        vis(aa[i].custom_yaw_base, isAA and currentid == i)
        vis(aa[i].custom_yaw_add_left, isAA and currentid == i)
        vis(aa[i].custom_yaw_add_right, isAA and currentid == i)
        vis(aa[i].custom_yaw_modifier, isAA and currentid == i)
        vis(aa[i].custom_modifier_degree, isAA and currentid == i)
        vis(aa[i].custom_left_limit, isAA and currentid == i)
        vis(aa[i].custom_right_limit, isAA and currentid == i)
        vis(aa[i].custom_left_limit2, isAAF and currentid == i)
        vis(aa[i].custom_right_limit2, isAAF and currentid == i)
        vis(aa[i].custom_options, isAA and currentid == i)
        vis(aa[i].custom_lby, isAA and currentid == i)
        vis(aa[i].custom_fs, isAA and currentid == i)
        vis(aa[i].custom_onshot, isAA and currentid == i)
        vis(aa[i].custom_fake_type, isAA and currentid == i)
    end
end

local hook_draw = function()
    draw()
    anti_aim()
    setvis()
end
Cheat.RegisterCallback("draw", hook_draw)
Cheat.RegisterCallback("pre_prediction", legitaa)
Cheat.RegisterCallback("createmove", use)
Cheat.RegisterCallback("destroy", function()
    updateConsoleColor(1, 1, 1, 1)
    for _, v in pairs(materials) do
        local material = MatSystem.FindMaterial(v, "")

        if material ~= nil then
            material:SetMaterialVarFlag(bit.lshift(1, 28), false)
            material:SetMaterialVarFlag(bit.lshift(1, 15), false)
        end
    end
end)
ui.console:RegisterCallback(cfgConsoleCallback)
EngineClient.ExecuteClientCmd("clear")
print("Welcome to Mozk-Yaw,"..Cheat.GetCheatUserName().."!")
print("Version: 1.0")
print("State: Release")
print("Thanks For Buy!")
print("Have good game!")
