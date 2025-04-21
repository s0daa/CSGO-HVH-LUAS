--> FFI
ffi.cdef[[
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
	typedef int(__fastcall* clantag_t)(const char*, const char*);

    typedef struct {
        char  pad_0000[20];
        int m_nOrder; //0x0014
        int m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030
        char  pad_0038[4]; //0x0034
    } CAnimationLayer;

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

    bool CreateDirectoryA(const char* lpPathName, void* lpSecurityAttributes);
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);  

    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
]]

local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet'

Download = function (from, to)
    wininet.DeleteUrlCacheEntryA(from)
    urlmon.URLDownloadToFileA(nil, from, to, 0,0)
end

CreateDir = function(path)
    ffi.C.CreateDirectoryA(path, NULL)
end

CreateDir("nl\\Hydra\\") -- folder name
Download('https://cdn.discordapp.com/attachments/1059210364786577438/1089933612301955122/Acta_Symbols_W95_Arrows.ttf', 'nl\\Hydra\\arrows.ttf')
local font_font = render.load_font("Verdana", 10, "bad")
local font_arrows = render.load_font("nl\\Hydra\\arrows.ttf", 16, "")

lerp = function(a, b, t)
    return a + (b - a) * t
end
local fnay = render.load_image(network.get("https://cdn.discordapp.com/attachments/1088961082346975294/1090257622101413948/image.png"), vector(18,18))
function notify(x, y, r, g, b, a, height, font, text)
    local stringsize = render.measure_text(font, "f", text)
    render.shadow(vector(x - (stringsize.x/1.8), y - (height/2)), vector(x + (stringsize.x/1.8) + 9, y + (height/2) + 3), color(r,g,b,a), 25, 0, 2)
    render.rect(vector(x - (stringsize.x/1.8), y - (height/2)), vector(x + (stringsize.x/1.8) + 10, y + (height/2) + 3), color(30,30,30,255), 2, false)
    render.text(font, vector(x - (stringsize.x/2) + 10, y - (height/2.9) + 1), color(), "f", "» "..text)
    render.texture(fnay, vector(x - (stringsize.x/1.8) + 5, y - (height/2.9) - 1), vector(18,18), color(r,g,b,a), f, 0)
end
local hitlog = {}
hitlog[#hitlog+1] = {("  Welcome to hydra.tech  "), globals.tickcount + 250, 0}

--> Info
info = {
    name = "Hydra",
    build = "nightly",
    version = "1.0",
    username = common.get_username(),
    online_users = "soon",
}


--> Requires
local base64 = require("neverlose/base64") or error("can't find base64 library")
local clipboard = require("neverlose/clipboard") or error("can't find clipboard library")
local gradient = require("neverlose/gradient") or error("can't find gradient library")
local MTools = require("neverlose/mtools") or error("can't find mtools library")
local vmt_hook = require("neverlose/vmt_hook") or error("can't find vmt_hook library")
local drag_system = require("neverlose/drag_system") or error("can't find drag_system library")
local csgo_weapons = require("neverlose/csgo_weapons") or error("can't find csgo_weapons library")
local indicator = require("neverlose/indicators")
x, y = render.screen_size().x, render.screen_size().y
local_player = entity.get_local_player()
local style_color = ui.get_style("Switch Active")
local hex = style_color:to_hex()
local refs = {
    tp = ui.find("Visuals", "World", "Main", "Force Thirdperson"),
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    dt_opt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    dt_fl = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"),
    hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    pa = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
    dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    sw = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    fl = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
    fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    fs2 = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    fs3 = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    avoidbackstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    Pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    Yawbase = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    Yawoffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    Yawmodifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    YawmodifierOffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    DesyncLeft = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    DesyncRight = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    Options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    Options2 = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    Freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    fp = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
    doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    mindamage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    fakeping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
    safepoint = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    bodyaim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    hitchance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
}

--> Functions
get_style_color = function()
    string = "\a"..hex..""
    return string
end

colored_icon_text = function(icon,text)
    string = ""..get_style_color()..""..ui.get_icon(icon).."\aDEFAULT"..text
    return string
end

discord_button = function()
	panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")
end

config_button = function()
	panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")
end

generate_token = function()
    print_raw("\aB7FF00[hydra] "..network.get("91.227.40.124:4201/?username="..common.get_username()))
    utils.console_exec("play survival/tablet_upgradesuccess_02.wav") 
end

trace = function(l)
    local max_radias = math.pi * 2
    local step = max_radias / 8
    local x, y, z = entity.get_local_player()["m_vecOrigin"].x, entity.get_local_player()["m_vecOrigin"].y, entity.get_local_player()["m_vecOrigin"].z

    for a = 0, max_radias, step do
        local ptX, ptY = ((10 * math.cos( a ) ) + x), ((10 * math.sin( a ) ) + y)
        local trace = utils.trace_line(vector(ptX, ptY, z), vector(ptX, ptY, z-l), entity.get_local_player())
        local fraction, entity = trace.fraction, trace.entity

        if fraction~=1 then 
            return true
        end
    end
    return false
end

--> Locals
local hydra = {
    groups = {
        [1] = ui.create(colored_icon_text("house",""),colored_icon_text("d-and-d","  Hydra"),1),
        [2] = ui.create(colored_icon_text("house",""),colored_icon_text("info","  Information"),2),
        [3] = ui.create(colored_icon_text("house",""),colored_icon_text("server","  Buttons"),2),
        [4] = ui.create(colored_icon_text("medrt",""),colored_icon_text(""," Anti-Aim"),1),
        [6] = ui.create(colored_icon_text("medrt",""),colored_icon_text(""," Anti-Aim Modes"),2),
        [5] = ui.create(colored_icon_text("medrt",""),colored_icon_text(""," Builder"),2),
        [7] = ui.create(colored_icon_text("medrt",""),colored_icon_text(""," Configs"),1),
        [8] = ui.create(colored_icon_text("flower-tulip",""),colored_icon_text(""," Ragebot"),2),
        [9] = ui.create(colored_icon_text("flower-tulip",""),colored_icon_text(""," Indicators"),2),
        [10] = ui.create(colored_icon_text("flower-tulip",""),colored_icon_text(""," Modifications"),1),
    },
    cogs = {},
    texts = {
        username = gradient.text(info.username, false, {
            color(style_color.r, style_color.g, style_color.b),
            color(style_color.r + 100, style_color.g + 100, style_color.b + 100),
        }),
        build = gradient.text(string.upper(info.build), false, {
            color(style_color.r, style_color.g, style_color.b),
            color(style_color.r + 100, style_color.g + 100, style_color.b + 100),
        }),
        version = gradient.text(info.version, false, {
            color(style_color.r, style_color.g, style_color.b),
            color(style_color.r + 100, style_color.g + 100, style_color.b + 100),
        }),
    },
}

local var = {
    player_states = {"Standing", "Moving", "Jumping", "Jumping-Duck", "Crouching", "Slowwalk", "Fake-Lag"},
	player_states_idx = {["Standing"] = 1, ["Moving"] = 2, ["Jumping"] = 3, ["Jumping-Duck"] = 4, ["Crouching"] = 5, ["Slowwalk"] = 6, ["Fake-Lag"] = 7},
    p_state = 0
}

get_conditions = function()
    if not Antiaim[0].enable_antiaim:get() then return end
    local local_player = entity.get_local_player()
    if not local_player then return end
    local player_inverter = local_player.m_flPoseParameter[11] * 120 - 60 <= 0 and true or false
    local on_ground = local_player.m_fFlags == bit.bor(local_player.m_fFlags, bit.lshift(1, 0))
    local on_crouch = local_player.m_fFlags == bit.bor(local_player.m_fFlags, bit.lshift(1, 2))
    local velocity = local_player.m_vecVelocity
    local speed = velocity:length()
    if speed <= 2 then
        var.p_state = 1
    end
    if speed >= 3 and refs.sw:get() == false then
        var.p_state = 2
    end
    if on_ground == false and on_crouch == false then
        var.p_state = 3
    end
    if on_ground == false and on_crouch == true then
        var.p_state = 4
    end
    if on_crouch == true and on_ground == true then
        var.p_state = 5
    end
    if refs.sw:get() == true then
        var.p_state = 6
    end
    if not refs.dt:get() and not refs.hs:get() and not refs.fd:get() then
        var.p_state = 7
    end
end


Antiaim = {}
Defensive_AA = {}

Antiaim[0] = {
    enable_antiaim = hydra.groups[4]:switch("Enable Anti-Aim"),
    antiaim_mode = hydra.groups[6]:list("Mode", {"Admin","Condictional"}),
    antiaim_tab = hydra.groups[4]:combo("Condition:", var.player_states),
    tweaks = hydra.groups[4]:selectable("Additional Tweaks", "Force Break LC in Air", "Disable On Warmup", "Avoid Backstab", "Safe Head"),
    fl_disablers = hydra.groups[4]:selectable("Fake Lag Disablers", "Standing", "Hide Shots", "Double Tap"),
    manual_aa = hydra.groups[4]:combo("Manual Yaw", "Off", "Forward","Left", "Right","Backward"),
    anim_breakers = hydra.groups[4]:selectable("\aC8BE94FF"..ui.get_icon("triangle-exclamation").."  Anim. Breakers", "Hydra walk", "Static legs in air","Body lean"),

    text_admin = hydra.groups[5]:label("You are using Admin mode.\nEverything is already set up. Enjoy!")
}


for i = 1, 7 do
    Antiaim[i] = {
        antiaim_mode = hydra.groups[5]:combo("Anti-Aim mode", "L&R", "Tick-Switcher","Sway","3-Way","5-Way","Slow Yaw","100-Way"),
        Yaw_Base = hydra.groups[5]:combo("Yaw Base", "At Target", "Local View"),
        Yaw_Left = hydra.groups[5]:slider("Yaw Left", -180, 180, 0),
        Yaw_Right = hydra.groups[5]:slider("Yaw Right", -180, 180, 0),
        Jitter_Mode = hydra.groups[5]:combo("Yaw modiffier", "Disabled", "Center", "Offset"),
        Jitter_Value = hydra.groups[5]:slider("Yaw modiffier offset", -180, 180, 0),
        f_offset = hydra.groups[5]:slider("5-Way Offset", -180, 180, 0),
        t_offset = hydra.groups[5]:slider("3-Way Offset", -180, 180, 0),
        Options = hydra.groups[5]:selectable("Options", "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"),
        Freestanding = hydra.groups[5]:combo("Freestanding", "Off", "Peek Fake", "Peek Real"),
        Desync_Left = hydra.groups[5]:slider("Desync Left Value", 0, 60, 58),
        Desync_Right = hydra.groups[5]:slider("Desync Right Value", 0, 60, 58),
        Defensive_AA = hydra.groups[5]:switch("Defensive AA"),
    }
end

for i = 1,7 do 
	defensive_aa_group = Antiaim[i].Defensive_AA:create()

	Defensive_AA[i] ={
        defensive_pitch = defensive_aa_group:combo("Pitch", {"Disabled","Down","Fake Down","Fake Up"}),
        defensive_tick = defensive_aa_group:slider("Tick To Switch",0, 13, 5),
        defensive_spin = defensive_aa_group:switch("Spin"),

	}
end

local gowno = network.get("https://cdn.discordapp.com/attachments/1089243352899272855/1089260926244503623/Nowy_projekt_7.png")
local logo = render.load_image(gowno, vector(500,500))
local gowno2 = network.get("https://cdn.discordapp.com/attachments/1088961082346975294/1089572478126399498/Nowy_projekt_8.png")
local logo2 = render.load_image(gowno2, vector(500,500))
local gowno3 = network.get("https://cdn.discordapp.com/attachments/1059210364786577438/1089979048974876813/Nowy_projekt_8.png")
local logo3 = render.load_image(gowno3,vector(15,15))

events.render:set(function()
    sidebar_text = gradient.text_animate("Hydra", -2, {
        color(130, 157, 255,255),
        color(style_color.r,style_color.g,style_color.b,style_color.a),
    })
    ui.sidebar(sidebar_text:get_animated_text(),"d-and-d")
    sidebar_text:animate()
end)


--> Menu
local home = {
    --> Image only
    image = hydra.groups[1]:texture(logo,vector(270,270),color(style_color.r,style_color.g,style_color.b,style_color.a)),
    --> Labels
    username = hydra.groups[2]:label("Welcome back, "..hydra.texts.username),
    build = hydra.groups[2]:label("Build: "..hydra.texts.build),
    version = hydra.groups[2]:label("Version: "..hydra.texts.version),
    --online_users = hydra.groups[2]:label("Online Users: "..get_style_color()..""..info.online_users),
    --> Buttons
    bugs = hydra.groups[3]:label("If you find a bug, please let us know via ticket/discord."),
    discord = hydra.groups[3]:button(colored_icon_text("discord"," Discord Server"), discord_button, true),
    config = hydra.groups[3]:button(colored_icon_text("gear"," Neverlose Config"), config_button, true),
    generate = hydra.groups[3]:button(colored_icon_text("badge-check","                 Generate Verify Token                   "), generate_token, true),
}

local globals_ui = {
    aimbot_logs = hydra.groups[8]:switch("Aimbot logs"),
    defensive = hydra.groups[8]:switch("Defensive In Air"),
    forward_fix = hydra.groups[8]:switch("Forward Fix"),
    grenade_throw = hydra.groups[8]:switch("Grenade Fix"),
    custom_hc = hydra.groups[8]:switch("Custom Hitchance"),

    indicators = hydra.groups[9]:switch("Crosshair Indicators"),
    manual_arrows = hydra.groups[9]:switch("Manual Arrows"),
    dmg_indicator = hydra.groups[9]:switch("Damage indicator"),
    skeet_indicators = hydra.groups[9]:switch("\aCDCDCDFFGame\aBFFF00FFSense \aFFFFFFFFIndicators"),


    widgets = hydra.groups[10]:switch("Widgets"),
    killsay = hydra.groups[10]:switch("Killsay"),
    aspect_ratio = hydra.groups[10]:switch("Aspect Ratio"),
    viewmodel_changer = hydra.groups[10]:switch("Viewmodel"),
    target_line = hydra.groups[10]:switch("Target Line"), 
    fast_ladder = hydra.groups[10]:switch("Fast Ladder"),
    custom_scope = hydra.groups[10]:switch("Custom scope"),
    no_fall_damage = hydra.groups[10]:switch("No Fall Damage"),
    flash_icon = hydra.groups[10]:switch("Taskbar notify on round start"),
    unmute_silenced = hydra.groups[10]:switch("Unmute Silenced Players"),

}


hydra.cogs.killsay = globals_ui.killsay:create()
hydra.cogs.fast_ladder = globals_ui.fast_ladder:create()
hydra.cogs.aspect_ratio = globals_ui.aspect_ratio:create()
hydra.cogs.manual_arrows = globals_ui.manual_arrows:create()
hydra.cogs.indicators = globals_ui.indicators:create()
hydra.cogs.target_line = globals_ui.target_line:create()
hydra.cogs.aimbot_logs = globals_ui.aimbot_logs:create()
hydra.cogs.custom_scope = globals_ui.custom_scope:create()
hydra.cogs.widgets = globals_ui.widgets:create()
hydra.cogs.viewmodel_changer = globals_ui.viewmodel_changer:create()
hydra.cogs.custom_hc = globals_ui.custom_hc:create()
local globals_cogs = {

    fast_ladder_select = hydra.cogs.fast_ladder:listable("", {"Ascending","Descending"}),

    killsay_language = hydra.cogs.killsay:list("Language", "English", "Russian", "Polish", "Romanian","Czech","All in One"),

    aimbot_logs = hydra.cogs.aimbot_logs:selectable("Logs", "Console", "Corner", "Under crosshair"),
    aimbot_logs_color = hydra.cogs.aimbot_logs:color_picker("Hit color", color(132,157,214,255)),
    aimbot_logs_color2 = hydra.cogs.aimbot_logs:color_picker("Mis color", color(227,156,156,255)),

    manual_color = hydra.cogs.manual_arrows:color_picker("Color"),
    manual_gap = hydra.cogs.manual_arrows:slider("Arrows gap", 0, 100, 0),

    widgets_items = hydra.cogs.widgets:selectable("Items", "Keybinds", "Spectators", "Watermark"),
    watermark_style = hydra.cogs.widgets:combo("Watermark Style", {"Default","Country Flag"}), 
    widgets_color = hydra.cogs.widgets:color_picker("First color", color(186,204,229,255)),
    widgets_color2 = hydra.cogs.widgets:color_picker("Second color"),

    logo = hydra.cogs.indicators:switch("Logo"),
    glow = hydra.cogs.indicators:switch("Glow"),
    indicators_mode = hydra.cogs.indicators:combo("Mode", "Modern", "Default"),
    indicators_color = hydra.cogs.indicators:color_picker("First color", color(132,157,214,255)),
    second_indicators_color = hydra.cogs.indicators:color_picker("Second color", color(255,255,255,255)),
    logo_color = hydra.cogs.indicators:color_picker("Logo color", color(132,157,214,255)),
    glow_color = hydra.cogs.indicators:color_picker("Glow color", color(132,157,214,255)),
    box_color = hydra.cogs.indicators:color_picker("Body Yaw color", color(255,255,255)),

	customscope_color = hydra.cogs.custom_scope:color_picker("Color", color(210,210,210,255)),
	scopeGap = hydra.cogs.custom_scope:slider("Scope Gap", 0, 300, 5),
	scopeLength = hydra.cogs.custom_scope:slider("Scope Length", 0, 300, 120),

    aspect_ratio = hydra.cogs.aspect_ratio:slider("", 0, 200,142, 0.01),
    x_watermark = hydra.cogs.widgets:slider("posx", 0, render.screen_size().x, 1859),
    y_watermark = hydra.cogs.widgets:slider("posy", 0, render.screen_size().y, 5),

    line_color = hydra.cogs.target_line:color_picker("Line Color", color(255,255,255,255)),

    viewmodel_fov = hydra.cogs.viewmodel_changer:slider("FOV", 0, 100, 68),
    viewmodel_x = hydra.cogs.viewmodel_changer:slider("X", -10, 10, 2.5),
    viewmodel_y = hydra.cogs.viewmodel_changer:slider("Y", -10, 10, 0),
    viewmodel_z = hydra.cogs.viewmodel_changer:slider("Z", -10, 10, -1.5),

    hc_select = hydra.cogs.custom_hc:listable("»   Override:","In Air","No Scope"),
    hc_inair = hydra.cogs.custom_hc:slider("In Air", 0,100),
    hc_noscope = hydra.cogs.custom_hc:slider("No Scope", 0,100),
}


local function Antiaimvisibler()
	active_tab = var.player_states_idx[Antiaim[0].antiaim_tab:get()]
    Antiaim[0].antiaim_tab:visibility(Antiaim[0].enable_antiaim:get())
    Antiaim[0].antiaim_mode:visibility(Antiaim[0].enable_antiaim:get())
    Antiaim[0].tweaks:visibility(Antiaim[0].enable_antiaim:get())
    Antiaim[0].manual_aa:visibility(Antiaim[0].enable_antiaim:get())
    Antiaim[0].fl_disablers:visibility(Antiaim[0].enable_antiaim:get())
    Antiaim[0].anim_breakers:visibility(Antiaim[0].enable_antiaim:get())
    Antiaim[0].text_admin:visibility(Antiaim[0].enable_antiaim:get() and Antiaim[0].antiaim_mode:get() == 1)

    --if Antiaim[0].antiaim_mode:get() == 1 then
        
    --end

	for i = 1,7 do 
        Antiaim[i].antiaim_mode:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].Yaw_Base:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].Yaw_Left:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and (Antiaim[i].antiaim_mode:get() == "L&R" or Antiaim[i].antiaim_mode:get() == "Sway" or Antiaim[i].antiaim_mode:get() == "Tick-Switcher" or Antiaim[i].antiaim_mode:get() == "Slow Yaw" or Antiaim[i].antiaim_mode:get() == "100-Way")  and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].Yaw_Right:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and (Antiaim[i].antiaim_mode:get() == "L&R" or Antiaim[i].antiaim_mode:get() == "Sway" or Antiaim[i].antiaim_mode:get() == "Tick-Switcher" or Antiaim[i].antiaim_mode:get() == "Slow Yaw" or Antiaim[i].antiaim_mode:get() == "100-Way")  and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].Jitter_Mode:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and (Antiaim[i].antiaim_mode:get() == "L&R")  and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].Jitter_Value:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and (Antiaim[i].antiaim_mode:get() == "L&R" or Antiaim[i].antiaim_mode:get() == "100-Way")  and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].Options:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and (Antiaim[i].antiaim_mode:get() == "L&R" or Antiaim[i].antiaim_mode:get() == "100-Way" or Antiaim[i].antiaim_mode:get() == "3-Way" or Antiaim[i].antiaim_mode:get() == "5-Way")  and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].t_offset:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and Antiaim[i].antiaim_mode:get() == "3-Way"  and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].f_offset:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and Antiaim[i].antiaim_mode:get() == "5-Way"  and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].Freestanding:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].Desync_Left:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].Desync_Right:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and Antiaim[0].antiaim_mode:get() == 2)
        Antiaim[i].Defensive_AA:visibility(active_tab == i and Antiaim[0].enable_antiaim:get() and Antiaim[0].antiaim_mode:get() == 2)
	end
end

local function choking(cmd)
    local Choke = false

    if cmd.send_packet == false or globals.choked_commands > 1 then
        Choke = true
    else
        Choke = false
    end

    return Choke
end
local tbl = {}
tbl.defensive = 0
tbl.checker = 0
ticks = function(t)
    return math.floor(0.5 + (t / globals.tickinterval))
end
tbl_checker = function()
    local local_player = entity.get_local_player()
    if not local_player or not local_player:is_alive() then return end
    local tickbase = ticks(local_player["m_flSimulationTime"])
    tbl.checker = math.max(tickbase, tbl.checker)
    tbl.defensive = math.abs(tickbase - tbl.checker)
end
local spin_ticks = -180
local current_stage = 1
breakelc = 0
local function Antiaim_worker(cmd)
    if not Antiaim[0].enable_antiaim:get() then return end
    if refs.fs:get() then 
        refs.Yawoffset:override(0)
        refs.YawmodifierOffset:override(0)
        refs.Yawmodifier:override("Disabled")
        refs.Options:override("")
        refs.Pitch:set("Down")
        return
    end
    local local_player = entity.get_local_player()
    if not local_player then return end
    local game_rules = entity.get_game_rules()
    if game_rules["m_bWarmupPeriod"] == true and Antiaim[0].tweaks:get(2) then return end
    if Antiaim[0].tweaks:get(1) and (var.p_state == 3 or var.p_state == 4) then
        local enemy = entity.get_players(true)
        for i = 1, #enemy do
            if enemy[i]:is_alive() == true and enemy[i]:is_visible() == true and enemy[i]:is_dormant() == false then
                breakelc = breakelc + 1
                if breakelc == 2 then
                    rage.exploit:force_teleport()
                end
            else
                breakelc = 0
            end
        end
    else
        rage.exploit:allow_charge(true)
    end
    local player_inverter = local_player.m_flPoseParameter[11] * 120 - 60 <= 0 and true or false
    local invert
    get_conditions()
    if Antiaim[var.p_state].antiaim_mode:get() == "Tick-Switcher" and not refs.fs:get() then
        if cmd.command_number % 6 > 3 then
            refs.Yawoffset:override(Antiaim[var.p_state].Yaw_Right:get())
        else
            refs.Yawoffset:override(Antiaim[var.p_state].Yaw_Left:get())
        end
        refs.YawmodifierOffset:override(0)
        refs.Yawmodifier:override("Disabled")
        refs.Options:override("")
    elseif Antiaim[var.p_state].antiaim_mode:get() == "L&R" and not refs.fs:get() then
        if player_inverter then
            refs.Yawoffset:override(Antiaim[var.p_state].Yaw_Right:get())
        else
            refs.Yawoffset:override(Antiaim[var.p_state].Yaw_Left:get())
        end
        refs.YawmodifierOffset:override(Antiaim[var.p_state].Jitter_Value:get())
        refs.Yawmodifier:override(Antiaim[var.p_state].Jitter_Mode:get())
        refs.Options:override(Antiaim[var.p_state].Options:get())
    elseif Antiaim[var.p_state].antiaim_mode:get() == "Sway" and not refs.fs:get() then
        local x_ways = {Antiaim[var.p_state].Yaw_Left:get(),Antiaim[var.p_state].Yaw_Left:get()/2,Antiaim[var.p_state].Yaw_Left:get()/3,Antiaim[var.p_state].Yaw_Left:get()/4,0,Antiaim[var.p_state].Yaw_Right:get()/4,Antiaim[var.p_state].Yaw_Right:get()/3,Antiaim[var.p_state].Yaw_Right:get()/2,Antiaim[var.p_state].Yaw_Right:get()}
		if cmd.command_number % 1024 > 1 and choking(cmd) == false then
			current_stage = current_stage + 1
		end
		if current_stage >= 10 and Antiaim[var.p_state].antiaim_mode:get() == "Sway" then
			current_stage = 1
		end
        refs.Yawoffset:set(Antiaim[var.p_state].antiaim_mode:get() == "Sway" and x_ways[current_stage])
        refs.YawmodifierOffset:override(0)
        refs.Yawmodifier:override("Disabled")
        refs.Options:override("")
    elseif Antiaim[var.p_state].antiaim_mode:get() == "100-Way" and not refs.fs:get() then
        local x_ways = {Antiaim[var.p_state].Yaw_Left:get()*1.6,Antiaim[var.p_state].Yaw_Left:get()/2,Antiaim[var.p_state].Yaw_Left:get()/3.5,Antiaim[var.p_state].Yaw_Left:get()/3,Antiaim[var.p_state].Yaw_Left:get()/2.5,Antiaim[var.p_state].Yaw_Left:get()/2.3,Antiaim[var.p_state].Yaw_Left:get()/2,Antiaim[var.p_state].Yaw_Left:get()/1.7,Antiaim[var.p_state].Yaw_Left:get()/1.5,Antiaim[var.p_state].Yaw_Left:get()/1.3,Antiaim[var.p_state].Yaw_Left:get()*1.2,Antiaim[var.p_state].Yaw_Left:get()*1.5,0,Antiaim[var.p_state].Yaw_Right:get()*1.5,Antiaim[var.p_state].Yaw_Right:get()*1.2,Antiaim[var.p_state].Yaw_Right:get()/1.3,Antiaim[var.p_state].Yaw_Right:get()/1.5,Antiaim[var.p_state].Yaw_Right:get()/1.7,Antiaim[var.p_state].Yaw_Right:get()/2,Antiaim[var.p_state].Yaw_Right:get()/2.3,Antiaim[var.p_state].Yaw_Right:get()/2.5,Antiaim[var.p_state].Yaw_Right:get()/3,Antiaim[var.p_state].Yaw_Right:get()/3.5,Antiaim[var.p_state].Yaw_Right:get()/2,Antiaim[var.p_state].Yaw_Right:get()*1.6}
		if cmd.command_number % 1024 > 1 and choking(cmd) == false then
			current_stage = current_stage + 1
		end
		if current_stage >= 10 and Antiaim[var.p_state].antiaim_mode:get() == "100-Way" then
			current_stage = 1
		end
        refs.Yawoffset:set(Antiaim[var.p_state].antiaim_mode:get() == "100-Way" and x_ways[current_stage])
        refs.YawmodifierOffset:override(Antiaim[var.p_state].Jitter_Value:get())
        refs.Yawmodifier:override(Antiaim[var.p_state].Jitter_Mode:get())
        refs.Options:override(Antiaim[var.p_state].Options:get())
    elseif Antiaim[var.p_state].antiaim_mode:get() == "Slow Yaw" and not refs.fs:get() then
        local invert = ((cmd.command_number % 10 > 5)) and Antiaim[var.p_state].Yaw_Right:get() or Antiaim[var.p_state].Yaw_Left:get()
        refs.Yawoffset:override(invert)
        refs.YawmodifierOffset:override(0)
        refs.Yawmodifier:override("Disabled")
        refs.Options:override("")
    elseif Antiaim[var.p_state].antiaim_mode:get() == "5-Way" and not refs.fs:get() then
        refs.Yawoffset:override(0)
        refs.Yawmodifier:override("5-Way")
        refs.YawmodifierOffset:override(Antiaim[var.p_state].f_offset:get())
        refs.Options:override(Antiaim[var.p_state].Options:get())
    elseif Antiaim[var.p_state].antiaim_mode:get() == "3-Way" and not refs.fs:get() then
        refs.Yawoffset:override(0)
        refs.Yawmodifier:override("3-Way")
        refs.YawmodifierOffset:override(Antiaim[var.p_state].t_offset:get())
        refs.Options:override(Antiaim[var.p_state].Options:get())
    end
    refs.Freestanding:override(Antiaim[var.p_state].Freestanding:get())
    refs.DesyncLeft:override(Antiaim[var.p_state].Desync_Left:get())
    refs.DesyncRight:override(Antiaim[var.p_state].Desync_Right:get())
    if Antiaim[0].tweaks:get(3) then
        refs.avoidbackstab:override(true)
    else
        refs.avoidbackstab:override(refs.avoidbackstab:get())
    end
    if local_player:get_player_weapon(false):get_classname() == "CKnife" and Antiaim[0].tweaks:get(4) then
        refs.Yawoffset:override(0)
        refs.YawmodifierOffset:override(0)
        refs.Yawmodifier:override("Disabled")
        refs.Options:override("")
    end
    if spin_ticks <= 180 then
		spin_ticks = spin_ticks + (2*20)
	end
	if spin_ticks == 180 then
		spin_ticks = -180
	end 
    if (tbl.defensive > Defensive_AA[var.p_state].defensive_tick:get() and tbl.defensive < 14) and Antiaim[var.p_state].Defensive_AA:get() then
        refs.Pitch:set(Defensive_AA[var.p_state].defensive_pitch:get())
    else
		refs.Pitch:set("Down")
    end
    if (tbl.defensive > Defensive_AA[var.p_state].defensive_tick:get() and tbl.defensive < 14) and Antiaim[var.p_state].Defensive_AA:get() then
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"):override(Defensive_AA[var.p_state].defensive_spin:get())
    end
    if Antiaim[0].fl_disablers:get(1) then
        if var.p_state == 1 or var.p_state == 7 then
            refs.fl:override(false)
        else
            refs.fl:override(refs.fl:get())
        end
    else
        refs.fl:override(refs.fl:get())
    end
    if Antiaim[0].fl_disablers:get(2) then
        if refs.hs:get() then
            refs.fl:override(false)
        else
            refs.fl:override(refs.fl:get())
        end
    else
        refs.fl:override(refs.fl:get())
    end
    if Antiaim[0].fl_disablers:get(3) then
        if refs.dt:get() then
            refs.fl:override(false)
        else
            refs.fl:override(refs.fl:get())
        end
    else
        refs.fl:override(refs.fl:get())
    end
    if Antiaim[0].manual_aa:get() == "Left" then
        refs.Yawoffset:override(-90)
        refs.Yawbase:override("Local View")
    elseif Antiaim[0].manual_aa:get() == "Right" then
        refs.Yawoffset:override(90)
        refs.Yawbase:override("Local View")
    elseif Antiaim[0].manual_aa:get() == "Forward" then
        refs.Yawoffset:override(180)
        refs.Yawbase:override("Local View")
    elseif Antiaim[0].manual_aa:get() == "Backward" then
        refs.Yawoffset:override(0)
        refs.Yawbase:override("Local View")
    elseif Antiaim[0].manual_aa:get() == "Off" then
        refs.Yawbase:override(Antiaim[var.p_state].Yaw_Base:get())
    end
    local prev = rage.exploit:get()
    local cur = rage.exploit:get()
    if prev ~= cur and cur == 0.5 and globals_ui.forward_fix:get() then
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"):override(false)
    end
    prev = cur
end

-- pitch up
-- O.G L.E.A.K.S

local uintptr_t = ffi.typeof("uintptr_t**")
local this_call = function(call_function, parameters)
    return function(...)
        return call_function(parameters, ...)
    end
end

local entity_list_003 = ffi.cast(uintptr_t, utils.create_interface("client.dll", "VClientEntityList003"))
local get_entity_address = this_call(ffi.cast("get_client_entity_t", entity_list_003[0][3]), entity_list_003)
local hooked_function = nil
local inside_updateCSA = function(thisptr, edx)
    hooked_function(thisptr, edx)
    local lp = entity.get_local_player()
    local lp_ptr = get_entity_address(entity.get_local_player():get_index())
    if not lp or not lp:is_alive() then return end
    if not Antiaim[0].enable_antiaim:get() then return end
    if Antiaim[0].anim_breakers:get(1) and var.p_state == 2 then
        lp.m_flPoseParameter[7] = 0
        refs.leg_movement:set('Walking')
    end
    if Antiaim[0].anim_breakers:get(2) and (var.p_state == 3 or var.p_state == 4) then
        lp.m_flPoseParameter[6] = 1
    end
    if Antiaim[0].anim_breakers:get(3) then
        ffi.cast('CAnimationLayer**', ffi.cast('uintptr_t', lp_ptr) + 10640)[0][12].m_flWeight = 1 -- move lean
    end
end


local update_hook = function()
    local self = entity.get_local_player()
    if not self or not self:is_alive() then
        return
    end

    local self_index = self:get_index()
    local self_address = get_entity_address(self_index)

    if not self_address or hooked_function then
        return
    end

    local new_point = vmt_hook.new(self_address)
    hooked_function = new_point.hook("void(__fastcall*)(void*, void*)", inside_updateCSA, 224)
end

events.createmove:set(function (e)
    e.animate_move_lean = true --if false - move lean disabled, true - enabled
end) 
events.pre_render:set(update_hook) 
events.shutdown:set(function()
    for _, reset_function in ipairs(vmt_hook.list) do
        reset_function()
    end
end)

--> Visuals

--> Target Line

local snapline_x, snapline_y = 0, 0
function enemy_line()
    if globals.is_connected == false or entity.get_local_player() == nil or entity.get_local_player():is_alive() == false then return end
    if not refs.tp:get() then return end
    if not globals_ui.target_line:get() then return end
    local screen_size = render.screen_size()
    local players = entity.get_players()
    local enemy = entity.get_threat()
    if not enemy then return end
    if enemy:is_dormant() then return end
    local position = render.world_to_screen(enemy:get_hitbox_position(3))
    if not position then return end
    local self_body = render.world_to_screen(entity.get_local_player():get_hitbox_position(3))
    if not self_body then return end
    local _lerp_ = lerp(snapline_x, self_body.x + 100, globals.frametime * 50)
    local lerpy = lerp(snapline_y, self_body.y - 90, globals.frametime * 8)
    if _lerp_ >= 0 and _lerp_ <= 2000 and lerpy >= 0 and lerpy <= 1500 then
        snapline_x = lerp(snapline_x, self_body.x + 100, globals.frametime * 50)
        snapline_y = lerp(snapline_y, self_body.y - 100, globals.frametime * 8)
    else
        snapline_x = self_body.x + 10
        snapline_y = self_body.y - 90
    end
    render.line(vector(_lerp_ - 100, lerpy + 100), vector(position.x, position.y), globals_cogs.line_color:get())
end

--> Indicators
indicators_maintext = 0
indicators_version = 0
DTind = 0
DT_lerp = 0
OSind = 0
DMGind = 0
FSind = 0
OS_lerp = 0
DMG_lerp = 0
FS_lerp = 0
DT_Ind_lerp = 0
indicators = function()
    local local_player = entity.get_local_player()
    if globals.is_connected == false or local_player == nil or local_player:is_alive() == false then return end
    if not globals_ui.indicators:get() then return end
    indicator_spacing = 0
    local is_scoped = local_player.m_bIsScoped
    local player_inverter = local_player.m_flPoseParameter[11] * 120 - 60 <= 0 and true or false
    local alpha = math.min(math.floor(math.sin((globals.curtime%3) * 5) * 140 + 200), 255)

    if globals_cogs.indicators_mode:get() == "Modern" then
        if is_scoped == true then
            indicators_maintext = lerp(indicators_maintext, 35, globals.frametime * 10)
            if info.build == "nightly" then
                indicators_version = lerp(indicators_version, 26, globals.frametime * 10)
            elseif info.build == "beta" then
                indicators_version = lerp(indicators_version, 20, globals.frametime * 10)
            elseif info.build == "live" then
                indicators_version = lerp(indicators_version, 17, globals.frametime * 10)
            end
            DT_lerp = lerp(DT_lerp, 22, globals.frametime * 10)
            OS_lerp = lerp(OS_lerp, 24, globals.frametime * 10)
            FS_lerp = lerp(FS_lerp, 32, globals.frametime * 10)
            DMG_lerp = lerp(DMG_lerp, 20, globals.frametime * 10)
        else
            indicators_maintext = lerp(indicators_maintext, 0, globals.frametime * 10)
            if info.build == "nightly" then
                indicators_version = lerp(indicators_version, 0, globals.frametime * 10)
            elseif info.build == "beta" then
                indicators_version = lerp(indicators_version, -1, globals.frametime * 10)
            elseif info.build == "live" then
                indicators_version = lerp(indicators_version, -2, globals.frametime * 10)
            end
            DT_lerp = lerp(DT_lerp, 0, globals.frametime * 10)
            OS_lerp = lerp(OS_lerp, 0, globals.frametime * 10)
            FS_lerp = lerp(FS_lerp, 0, globals.frametime * 10)
            DMG_lerp = lerp(DMG_lerp, 0, globals.frametime * 10)
        end

        render.text(1, vector(x/2 + indicators_maintext - 11,y/1.95 + 5), color(),"c", "hydra")
        render.text(1, vector(x/2 + indicators_maintext + 16,y/1.95 + 5), globals_cogs.indicators_color:get(),"c", "tech")
        render.text(1, vector(x/2 + indicators_version + 1,y/1.95 + 15), color(globals_cogs.indicators_color:get().r, globals_cogs.indicators_color:get().g, globals_cogs.indicators_color:get().b, alpha),"c", info.build)

        local DTcharge = rage.exploit:get()
        if refs.fs:get() then
            FSind = lerp(FSind,indicator_spacing,globals.frametime * 15)
            render.text(1, vector(x/2 + FS_lerp,y/1.95 + FSind + 25), color(),"c", "direction")
            indicator_spacing = indicator_spacing + 10
        else
            FSind = lerp(FSind,indicator_spacing - 10,globals.frametime * 15)
        end

        if refs.dt:get() then
            DTind = lerp(DTind,indicator_spacing,globals.frametime * 15)
            render.text(1, vector(x/2 + DT_lerp,y/1.95 + DTind + 25), color(255,255*DTcharge,255*DTcharge,255),"c", "rapid")
            indicator_spacing = indicator_spacing + 10
        else
            DTind = lerp(DTind,indicator_spacing - 10,globals.frametime * 15)
        end

        if refs.hs:get() then
            OSind = lerp(OSind,indicator_spacing,globals.frametime * 15)
            render.text(1, vector(x/2 + OS_lerp,y/1.95 + OSind + 25), color(),"c", "os-aa")
            indicator_spacing = indicator_spacing + 10
        else
            OSind = lerp(OSind,indicator_spacing - 10,globals.frametime * 15)
        end

        local active_binds = ui.get_binds()
        for i in pairs(active_binds) do
            if active_binds[i].name == "Min. Damage" then
                if active_binds[i].active then
                    DMGind = lerp(DMGind,indicator_spacing,globals.frametime * 15)
                    render.text(1, vector(x/2 + DMG_lerp + 1,y/1.95 + DMGind + 25), color(),"c", "dmg")
                    indicator_spacing = indicator_spacing + 10
                else
                    DMGind = lerp(DMGind,indicator_spacing - 10,globals.frametime * 15)
                end
            end
        end
    end

    if globals_cogs.indicators_mode:get() == "Default" then
        MTools.Animation:Register("Indicators");
        MTools.Animation:Update("Indicators", 6);
        scoping_logo = MTools.Animation:Lerp("Indicators", "LOGO", (is_scoped), vector(0, 0), vector(10, 0), 15);
        scoping_main = MTools.Animation:Lerp("Indicators", "HYDRA", (is_scoped), vector(0, 0), vector(16, 0), 15);
        scoping_box = MTools.Animation:Lerp("Indicators", "BOX", (is_scoped), vector(0, 0), vector(26, 0), 15);
        scoping_dt = MTools.Animation:Lerp("Indicators", "DT", (is_scoped), vector(0, 0), vector(21, 0), 15);

        indicators_text = gradient.text_animate("HYDRA", -2, {
            globals_cogs.second_indicators_color:get(),
            globals_cogs.indicators_color:get(),
        })
    
        local eternal_ts = render.measure_text(2, nil, "HYDRA")
        local eternal_ts_dt = render.measure_text(2, nil, "OS")
    
        if globals_cogs.glow:get() then
            render.shadow(vector(x/2 + scoping_main.x - eternal_ts.x/2,y/1.912 ), vector(x/2 + scoping_main.x + eternal_ts.x/2,y/1.912), globals_cogs.glow_color:get(), 30, 0, 4)
        end
        render.text(2, vector(x/2 + scoping_main.x,y/1.912 ), color(),"c", indicators_text:get_animated_text())
        if globals_cogs.logo:get() then
            render.texture(logo3, vector(x/2 - eternal_ts.x/2 + scoping_logo.x + 6,y/1.98), vector(15,15), globals_cogs.logo_color:get())
        end
    

        local body_yaw = math.min(math.abs((rage.antiaim:get_max_desync() - rage.antiaim:get_rotation()/2) or (rage.antiaim:get_max_desync() - rage.antiaim:get_rotation())), 58)
        local body_yaw2 = body_yaw/3

    
        render.rect(vector(x/2 - eternal_ts.x/2 + scoping_box.x - 10 , y/1.895 ), vector(x/2 + scoping_box.x + eternal_ts.x/2 + 10   , y/1.895 + 5), color(5,5,5,255), 1.5)
        render.gradient(vector(x/2 - eternal_ts.x/2 + scoping_box.x - 9, y/1.895 + 1), vector(x/2  - eternal_ts.x/2 + 15 + scoping_box.x + body_yaw2 , y/1.895 + 4), color(globals_cogs.box_color:get().r,globals_cogs.box_color:get().g,globals_cogs.box_color:get().b, 220), color(globals_cogs.box_color:get().r,globals_cogs.box_color:get().g,globals_cogs.box_color:get().b, 0), color(globals_cogs.box_color:get().r,globals_cogs.box_color:get().g,globals_cogs.box_color:get().b, 220), color(globals_cogs.box_color:get().r,globals_cogs.box_color:get().g,globals_cogs.box_color:get().b, 0), 1.2)
        render.shadow(vector(x/2 - eternal_ts.x/2 + scoping_box.x - 10, y/1.895), vector(x/2 - eternal_ts.x/2 + scoping_box.x + 23, y/1.895 + 5), color(0, 0, 0, 200), 20, 0, 1.5)
    
        if not refs.dt:get() then
            render.text(2, vector(x/2 - eternal_ts_dt.x + scoping_dt.x,y/1.865), color(200,200,200,200),"c", "DT")
        elseif refs.dt:get() then
            render.text(2, vector(x/2 - eternal_ts_dt.x + scoping_dt.x,y/1.865), color(255,255,255,255),"c", "DT")
        end
    
        if not refs.hs:get() then
            render.text(2, vector(x/2  + scoping_dt.x,y/1.865), color(200,200,200,200),"c", "OS")
        elseif refs.hs:get() then
            render.text(2, vector(x/2  + scoping_dt.x,y/1.865), color(255,255,255,255),"c", "OS")
        end
    
        if not refs.fs:get() then
            render.text(2, vector(x/2 + eternal_ts_dt.x + 1 + scoping_dt.x,y/1.865), color(200,200,200,200),"c", "FS")
        elseif refs.fs:get() then
            render.text(2, vector(x/2 + eternal_ts_dt.x + 1 + scoping_dt.x,y/1.865), color(255,255,255,255),"c", "FS")
        end

        indicators_text:animate()
    end


end

local watermark = drag_system.register({globals_cogs.x_watermark, globals_cogs.y_watermark}, vector(60, 60), "Test", function(self)
    globals_cogs.x_watermark:visibility(false)
    globals_cogs.y_watermark:visibility(false)
    local local_player = entity.get_local_player()
    if globals.is_connected == false or local_player == nil or local_player:is_alive() == false then return end
    if not globals_ui.widgets:get() then return end
    if not globals_cogs.widgets_items:get(3) then return end

    local username = common.get_username()

    watermark_text = gradient.text_animate("HYDRA | "..username.." | "..common.get_date("%H:%M"), -1, {
        color(globals_cogs.widgets_color:get().r ,globals_cogs.widgets_color:get().g, globals_cogs.widgets_color:get().b, globals_cogs.widgets_color:get().a),
        color(globals_cogs.widgets_color2:get().r, globals_cogs.widgets_color2:get().g, globals_cogs.widgets_color2:get().b, globals_cogs.widgets_color2:get().a)
    })

    local eternal_ts = render.measure_text(font_font,"bad", watermark_text:get_animated_text())
    if globals_cogs.watermark_style:get() == "Default" then
    render.circle(vector(self.position.x + 32,self.position.y + 26), color(20,20,20,255), 24, 0, 1)
    render.rect(vector(self.position.x - eternal_ts.x,self.position.y + 12), vector(self.position.x + 20,self.position.y + 41), color(20,20,20,255), 5)
    render.text(font_font, vector(self.position.x - eternal_ts.x + 8, self.position.y + 20), color(255,255,255), "", watermark_text:get_animated_text())
    render.shadow(vector(self.position.x + 30, self.position.y + 25), vector(self.position.x + 30, self.position.y + 25), globals_cogs.widgets_color:get(), 125, 0, 0)
    render.texture(logo2, vector(self.position.x + 10,self.position.y + 3), vector(45,45), globals_cogs.widgets_color:get())
    end
    watermark_text:animate()
end)

flag_watermark = function()
    local local_player = entity.get_local_player()
    if globals.is_connected == false or local_player == nil or local_player:is_alive() == false then return end
    if not globals_ui.widgets:get() then return end
    if not globals_cogs.widgets_items:get(3) then return end

    local screensize = render.screen_size()
    local x = screensize.x /2
    local y = screensize.y /2
    local eternal_ts = render.measure_text(2, nil, "HYDRA.TECH")

    local r, g, b = globals_cogs.widgets_color:get().r, globals_cogs.widgets_color:get().g, globals_cogs.widgets_color:get().b
    
    if globals_cogs.watermark_style:get() == "Country Flag" then
        render.gradient(vector(x - eternal_ts.x*20.83, y - 20), vector(x - eternal_ts.x*18.5, y - 46), color(r,g,b,255), color(r,g,b,0), color(r,g,b,255), color(r,g,b,0))
        render.texture(menu_img_loaded2, vector(x - 958, y - 50), vector(34, 34), color())
        render.text(2,vector(x - eternal_ts.x*20,y - 46),color(255,255,255),nil,"HYDRA.TECH")
        render.text(2,vector(x - eternal_ts.x*20,y - 35),color(255,255,255),nil,"["..info.build:upper().."]")
    end
end

--> TaskBar O.G L.E.A.K.S
local raw_hwnd 			= utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B") or error("Invalid signature #1")
local raw_FlashWindow 	= utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7") or error("Invalid signature #2")
local raw_insn_jmp_ecx 	= utils.opcode_scan("gameoverlayrenderer.dll", "FF E1") or error("Invalid signature #3")
local raw_GetForegroundWindow = utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74") or error("Invalid signature #4")
local hwnd_ptr 		= ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", raw_hwnd) + 2)[0])[0] + 2)
local FlashWindow 	= ffi.cast("int(__stdcall*)(uintptr_t, int)", raw_FlashWindow)
local insn_jmp_ecx 	= ffi.cast("int(__thiscall*)(uintptr_t)", raw_insn_jmp_ecx)
local GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", raw_GetForegroundWindow) + 2)[0])[0]

local function get_csgo_hwnd()
	return hwnd_ptr[0]
end

local function get_foreground_hwnd()
	return insn_jmp_ecx(GetForegroundWindow)
end

flash_icon = function()
    if not globals_ui.flash_icon:get() then return end
	local csgo_hwnd = get_csgo_hwnd()
	if get_foreground_hwnd() ~= csgo_hwnd then
		FlashWindow(csgo_hwnd, 1)
		return true
	end
	return false
end

--> Unmute  Silenced
unmute_silenced_players = function()
    if not globals_ui.unmute_silenced:get() then return end
    local toggle_mute = panorama.FriendsListAPI.ToggleMute
    local is_muted = panorama.FriendsListAPI.IsSelectedPlayerMuted
    local players = entity.get_players(false, true, function(player)
        local info = player:get_player_info()
        local steamid64 = panorama.MyPersonaAPI.GetXuid()
        local is_muted = is_muted(steamid64)
        toggle_mute(steamid64)
    end)
end

--> Ragebot

defensive_inair = function()
    if globals_ui.defensive:get() and (var.p_state == 3 or var.p_state == 4) then 
        refs.dt_opt:set("Always On")
        refs.dt_fl:set(1)
    else
        refs.dt_opt:set("On Peek")
        refs.dt_fl:set(1)
    end
end

--> Grenade Fix
local function get_weapon(player)
    local weapon = player:get_player_weapon()
    if not weapon then return end
    local index = weapon:get_weapon_index()
    if not index then return end
    
    return csgo_weapons[index]
end

grenade_fix = function()
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    local weapon = get_weapon(lp)
    if not weapon then return end

    if weapon.type == "grenade" and globals_ui.grenade_throw:get() then
        refs.dt:override(false)
    else
        refs.dt:override()
    end
end

cst_hitchances = function()
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    -- globals_cogs.hc_inair:visibility(globals_cogs.hc_select:get("In Air"))
    -- globals_cogs.hc_noscope:visibility(globals_cogs.hc_select:get("No Scope"))

    if globals_cogs.hc_select:get("In Air") then
        local lp = entity.get_local_player()
        if not lp then return end
        if not lp:is_alive() then return end
        if lp["m_fFlags"] == 256 and lp:get_player_weapon():get_name() == "SSG 08" then
        refs.hitchance:override(globals_cogs.hc_inair:get())
        elseif lp["m_fFlags"] ~= 256 and lp:get_player_weapon():get_name() == "SSG 08" then
        refs.hitchance:override()
        end
    elseif globals_cogs.hc_select:get("No Scope") then
        local lp = entity.get_local_player()
        if not lp then return end
        local is_scoped = lp["m_bIsScoped"]
        if not lp:is_alive() then return end
        if not is_scoped then
            if lp:get_player_weapon():get_name() == "SSG 08" or lp:get_player_weapon():get_name() == "SCAR-20" or lp:get_player_weapon():get_name() == "G3SG1" then
                refs.hitchance:override(globals_cogs.hc_noscope:get())
            end
        else
            refs.hitchance:override()
        end
    end
end


--> Modifications

fastladder_init = function(cmd)
    if not globals_ui.fast_ladder:get() then return end
    local local_player = entity.get_local_player()
    if local_player == nil then return end

    local pitch = render.camera_angles()
    --up
    if local_player.m_MoveType == 9 and common.is_button_down(0x57) and globals_cogs.fast_ladder_select:get('ascending') then
        cmd.view_angles.y = math.floor(cmd.view_angles.y+0.5)
        cmd.roll = 0

        if cmd.view_angles.x < 45 then
            cmd.view_angles.x = 89
            cmd.in_moveright = 1
            cmd.in_moveleft = 0
            cmd.in_forward = 0
            cmd.in_back = 1
            if cmd.sidemove == 0 then
                cmd.view_angles.y = cmd.view_angles.y + 90
            end
            if cmd.sidemove < 0 then
                cmd.view_angles.y = cmd.view_angles.y + 150
            end
            if cmd.sidemove > 0 then
                cmd.view_angles.y = cmd.view_angles.y + 30
            end
        end
    end
    --down
    if local_player.m_MoveType == 9 and common.is_button_down(0x53) and globals_cogs.fast_ladder_select:get('descending') then
        cmd.view_angles.y = math.floor(cmd.view_angles.y-0.5)
        cmd.roll = 0

        if cmd.view_angles.x < 45 then
            cmd.view_angles.x = 89
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
            cmd.in_forward = 1
            cmd.in_back = 0
            if cmd.sidemove == 0 then
                cmd.view_angles.y = cmd.view_angles.y + 90
            end
            if cmd.sidemove > 0 then
                cmd.view_angles.y = cmd.view_angles.y + 150
            end
            if cmd.sidemove < 0 then
                cmd.view_angles.y = cmd.view_angles.y + 30
            end
        end
    end
end

--> No Fall Damage


no_fall_dmg = function(cmd)
    if not globals_ui.no_fall_damage:get() then return end

    self = entity.get_local_player()

    if self == nil then return end

    if self.m_vecVelocity.z >= -500 then
        no_fall_damage = false
    else
        if trace(15) then
            no_fall_damage = false
        elseif trace(75) then
            no_fall_damage = true
        end
    end

    if globals_ui.no_fall_damage:get() and self.m_vecVelocity.z < -500 then
        if no_fall_damage then
            cmd.in_duck = 1
        else
            cmd.in_duck = 0
        end
    end
end

local phrases = {
	eng_phrases = {
		'1v1? 2v2?',
		'fix ur cfg niger',
		'0.001839490  𝔟𝔱𝔠 𝔯𝔦𝔠𝔥𝖍',
		'hydra $ prediction',
		'You are the best at being dead',
		'fix ur stats random',
		'Я использую gamesense',
		'I hate pasted luas thats why I use hydra.lua', 
		'go kys furry dog',
		'不使用 skeet beta，我使用的是 hydra.lua',  
	},
	ru_phrases = {
		"я щас так посрал что просто пиздец, я нахуй такую гороховую банку высрал у меня чуть ушные перепонки не взорвались нахуй",
		"ты раб кадырова",
		"7 радужных чеченцев идут в Москву",
		"ыыыыыыыыыы ыыыыыы",
		"ъ",
		"а ты сувал себе банан в жопу?",
		"бляа пизда седня слышу што-то жужит смотрю а у меня из штанов хуй как пчела улетает",
		"тест влад луа",
		"кто здесь",
		"паймааааал пиупиу!!!! пиупиу ахххахаххаахахахахаааа!!!! пиупиу ихххихиххиии!!!!! ахахахаха!!!!",
		"КАКААААШКИИИ!!!!! КАКАААААШКИИИИИ!!!!!!!!!!",
		"с наступающим Новым Годом!"
	},
	ro_phrases = { 
		'stai jos dog',
		'sugi pula',
		'Ai cumva cheat-ul ala de la Llama?',
		'efortless',
		'foaie verde castravete ti-am dat 1 prin perete',
		'cand pun ochiu in luneta o vad pe ma-ta pe mocheta',
		'Juan ',
		'foaie verde si-o spatula ti-am dat cap cu ma-ta-n pula',
		'mama coaie am dat click manual zici ca sunt alien cosminel',
		'1 by esoterik bro',
		'1 by pleata lui darth',
		'foaie verde be the heda ti-ai luat tap de la wanheda',
		'fie viata cat de grea iti dau tap ce pula mea',
		'foaie verde butelie intra glontu in chelie',
		'hacker de sentimente sparg capuri si apartamente',
		'skeet in buzunare sa-i dau tap lui fleeekkk',
		'Priveste partea buna, macar ai dat 100 damage la peretele din spatele meu !',
		'ESC --> volunteering & Options --> How to Play',
		'1 1 1 VeRy NeRvOs hEaDsHoT 1 1 1',
		'Pt fetele gravide recomand skeet cu vitamine.',
		'1 tie 1 lui ma-ta',
		'Asa a dat si ma-ta ochii peste cum ai dat tu cu capul',
		'futu-ti mortii ma-tii sa-ti fut de taran',
		'Tragem pula in mamele voastre!!!',
		'Te-ai speriat? Eu da!',
		'ai capul ala zici ca e made in china',
		'da-te ca-mi bag pula',
		'ai gresit 1way-ul',
		'alo baiatu, te-ai pierdut ? iti bag waze-u ?',
		'Ai corpul ala zici ca e halba de bere.',
		'ai corpul ala zici ca e lumanare de botez.',
		'VeRy NeRvoS BaIm',
		'stai jos caine',
		'Tu si Oana Roman ce mai stati cu burta pe afara.',
		'apas f pt tine <3',
		'scz eram cu legitbotu on',
		'rostogoli-mi-as pula-n ma-ta cum se rostogoleste crocodilu-n apa',
		'coaie ce corp ai zici ca esti desenat cu stanga',
		'foaie verde de cucuta hai la tata sa te futa',
		'aleluia ai luat muia .!.',
		'nice desync, esti cu eternity ?',
		'lol aveam resolver-ul off.',
		'Cel mai nervos baim din viata mea',
		'asta ajunge la war montage ms ms',
		'BaIm bAiM BaIm',
		'ceapa verde foaie iute uite baimu cum se duce',
		'Foaie verde praf de ciori iti iei baim pana mori',
		'Foaie verde si-o lamaie iti dau baim si iei muie',
		'foaie verde acadea ia cu baim in pula mea',
		'sunt haiduc cunoscut, iti dau pula la pascut',
		'sunt tac-tu, hai sa-ti dau lape',
		'ba..nu stiu cum sa-ti spun, dar...isi mai da ma-ta filme ca-i pompier de cand i-am pus pula peste umar?',
		'sa-ti pun pula pe piept ',
		'hai back to canal boschetare',
		'hai la gratar sa-ti frig o muie',
		"smecherii fut",
		"fraierii isi iau cap"
	},
	pl_phrases = {
		"Będę walił Baima, aż zginiesz",
		"Włożę ci penisa w gardło",
		"źle trafiłeś HAHAHAHAH",
		"Dobry desync, to ethernity?",
		"Dostajesz Baima i uciekasz XD",
		"Jebana suka ze wsi",
		"Strzelałeś lewą ręką? XD",
		"Nice miss frajerze HAAHAH",
		"Patrzyłeś w złą stronę",
		"co to było xd",
		"Idź się umyj i zrób mi loda",
		"Jesteś suką ze wsi szukającą kruków z woreczkiem",
		"Jestem znanym pasterzem, daję Ci kutasa do wypasania",
		"Cześć chłopcze, zgubiłeś się?",
		"Jesteś tak gruby, że było cie widać przez trzy ściany",
		"VeRy NeRvoS BaIm",
		"pięknie",
		"siadaj psie",
		"Tobie i twojemu staremu ciągle wystaje brzuch... Baim!",
		"uff... Król Baim'a! $$",
		"Alleluja, obciągnąłęś mi.!.",
		"lol, wyłączyłem resolver xDD",
		"Najbardziej nerwowa kolacja w moim życiu",
		"BaIm bAiM BaIm",
		"Dobra milczę, daję ci spokój",
		"Nie no, żartowałem xD",
		"Hmm… Nie wiem, jak ci to powiedzieć, ale… czy postrzegałeś mnie jako strażaka, gdy położyłem ci penisa na ramieniu?",
		"kładę Ci fiuta na piersi",
		"Podeślesz cfg do osirisa?",
		'˜" ° • .˜ "° • 1 • °" ˜. • ° "˜',
		"łatwo xD",
		"Zajebałem Ci liścia przez ścianę",
		"uderzyłem Ci w głowę kutasem",
		"1 wchodzi w łysinę",
		"Spójrz na to dobrą stroną, przynajmniej ściane obiłeś xD",
		"ESC -> Pomoc i opcje -> Jak grać",
		"Dziewczynom w ciąży polecam skeeta z witaminami",
		"Hakuna matataaaa, jak 1 wchodzi tuuu...",
		"Tak na mnie patrzyłeś, jakbyś skinął głową",
		"pieprz się, pieprz mnie jak wieśniak",
		"Boisz się? Taaak!",
		"grilluj zimnego loda",
	},
    cz_phrases = {
        "1 cucaj mi pero mrdko",
        "tvoje matka ráda šuká v autě",
        "jsi malý robot a kokot",
        "líbí se ti to v zadku",
        "1, tlustá děvka leží",
        "so keres sardives, tvoje matka je děvka",
        "proč jsem tě šukal do úst přes zeď",
        "studený led gril",
        "Šukám tvou matku kundo",
        "kurva svou matku děvko",
    },
}
Allphrases = {phrases.cz_phrases, phrases.pl_phrases, phrases.ro_phrases, phrases.ru_phrases, phrases.eng_phrases}
get_phrases = function()
	if not globals_ui.killsay:get() then return end
    if globals_cogs.killsay_language:get() == 2 then
        return phrases.ru_phrases[utils.random_int(1, #phrases.ru_phrases)]:gsub('"', '')
    end
    if globals_cogs.killsay_language:get() == 1 then
        return phrases.eng_phrases[utils.random_int(1, #phrases.eng_phrases)]:gsub('"', '')
    end
    if globals_cogs.killsay_language:get() == 4 then
        return phrases.ro_phrases[utils.random_int(1, #phrases.ro_phrases)]:gsub('"', '')
    end
    if globals_cogs.killsay_language:get() == 3 then
        return phrases.pl_phrases[utils.random_int(1, #phrases.pl_phrases)]:gsub('"', '')
    end
    if globals_cogs.killsay_language:get() == 5 then
        return phrases.cz_phrases[utils.random_int(1, #phrases.cz_phrases)]:gsub('"', '')
    end
    if globals_cogs.killsay_language:get() == 6 then
        return Allphrases[math.random(1,5)][utils.random_int(1, #Allphrases[math.random(1,5)])]:gsub('"', '')
    end
end


events.player_death:set(function(e)
    local me = entity.get_local_player()
    local attacker = entity.get(e.attacker, true)

    if me == attacker then
        if globals_ui.killsay:get() then
            utils.console_exec('say "' .. get_phrases() .. '"')
        end
    end
end)

-- O.G L.E.A.K.S

local gs_font = render.load_font("Calibri Bold", vector(24,22), "ad")
local c4_icon = render.load_image(network.get("https://cdn.discordapp.com/attachments/1018902888447217735/1094254633247055982/image.png"), vector(32,28))
function draw_500_(gap, text, icon, time, r, g, b)
    local x, y = render.screen_size().x, render.screen_size().y
    local measure_text = render.measure_text(gs_font, "c", text) 
    if icon == nil and time == nil then
        render.gradient(vector(x/40, y/1.43 - 4 - gap), vector(x/40 + measure_text.x, y/1.43 + 30 - gap), color(0,0,0,45), color(0,0,0,0), color(0,0,0,45), color(0,0,0,0), 0)
        render.gradient(vector(x/40 - 40, y/1.43 - 4 - gap), vector(x/40, y/1.43 + 30 - gap), color(0,0,0,0), color(0,0,0,45), color(0,0,0,0), color(0,0,0,45), 0)
        render.text(gs_font, vector(x/62, y/1.43 + 4 - gap), color(r, g, b, 255), nil, text)
    elseif icon ~= nil and time ~= nil then
        render.gradient(vector(x/40, y/1.43 - 4 - gap), vector(x/40 + measure_text.x, y/1.43 + 30 - gap), color(0,0,0,45), color(0,0,0,0), color(0,0,0,45), color(0,0,0,0), 0)
        render.gradient(vector(x/40 - 40, y/1.43 - 4 - gap), vector(x/40, y/1.43 + 30 - gap), color(0,0,0,0), color(0,0,0,45), color(0,0,0,0), color(0,0,0,45), 0)
        render.text(gs_font, vector(x/62 + 38, y/1.43 + 4 - gap), color(r, g, b, 255), nil, text)
        render.texture(icon, vector(x/62, y/1.43 - gap), vector(32, 28), color(r, g, b, 255), f, 0)
        render.circle_outline(vector(x/62 + 70, y/1.43 + 14 - gap), color(10,10,10,255), 10, 0, 1, 5)
        render.circle_outline(vector(x/62 + 70, y/1.43 + 14 - gap), color(205,205,205), 9, 0, time, 3)
    elseif icon ~= nil and time == nil then
        render.gradient(vector(x/40, y/1.43 - 4 - gap), vector(x/40 + measure_text.x, y/1.43 + 30 - gap), color(0,0,0,45), color(0,0,0,0), color(0,0,0,45), color(0,0,0,0), 0)
        render.gradient(vector(x/40 - 40, y/1.43 - 4 - gap), vector(x/40, y/1.43 + 30 - gap), color(0,0,0,0), color(0,0,0,45), color(0,0,0,0), color(0,0,0,45), 0)
        render.text(gs_font, vector(x/62 + 38, y/1.43 + 4 - gap), color(r, g, b, 255), nil, text)
        render.texture(icon, vector(x/62, y/1.43 - gap), vector(32, 28), color(r, g, b, 255), f, 0)
    end
end
gs_ind = function()
    if not globals_ui.skeet_indicators:get() then return end
    local local_player = entity.get_local_player()
    if globals.is_connected == false or local_player == nil or local_player:is_alive() == false then return end
    local bomb = require("neverlose/bomb") or error("can't find bomb library")
    local gs_gap = 0
    local x, y = render.screen_size().x, render.screen_size().y
    if refs.fakeping:get() > 0 then
        draw_500_(gs_gap, "PING", nil, nil, 123,155,36)
        gs_gap = gs_gap + 42
    end
    if refs.hideshots:get() then
        draw_500_(gs_gap, "OSAA", nil, nil, 205,205,205)
        gs_gap = gs_gap + 42
    end
    if refs.doubletap:get() then
        local DTcharge = rage.exploit:get()
        if DTcharge == 1 then
            draw_500_(gs_gap, "DT", nil, nil, 205,205,205)
            gs_gap = gs_gap + 42
        else
            draw_500_(gs_gap, "DT", nil, nil, 229,26,55)
            gs_gap = gs_gap + 42
        end 
    end
    local all_players = entity.get_players(true, true)
    if not all_players then return end
    if refs.dormant:get() then
        for _, player in ipairs(all_players) do
            if player:is_dormant() then
                draw_500_(gs_gap, "DA", nil, nil, 205,205,205)
                gs_gap = gs_gap + 42
                break
            else
                draw_500_(gs_gap, "DA", nil, nil, 229,26,55)
                gs_gap = gs_gap + 42
                break
            end
        end
    end
    if refs.safepoint:get() == "Force" then
        draw_500_(gs_gap, "SAFE", nil, nil, 205,205,205)
        gs_gap = gs_gap + 42
    end
    if refs.bodyaim:get() == "Force" then
        draw_500_(gs_gap, "BODY", nil, nil, 205,205,205)
        gs_gap = gs_gap + 42
    end
    if refs.fakeduck:get() then
        draw_500_(gs_gap, "DUCK", nil, nil, 205,205,205)
        gs_gap = gs_gap + 42
    end
    for i in pairs(ui.get_binds()) do
        if ui.get_binds()[i].name == "Min. Damage" then
            if ui.get_binds()[i].active then
                draw_500_(gs_gap, "MD", nil, nil, 205,205,205)
                gs_gap = gs_gap + 42
            end
        end
    end
    if refs.freestanding:get() then
        draw_500_(gs_gap, "FS", nil, nil, 205,205,205)
        gs_gap = gs_gap + 42
    end
    if bomb.state == false then
        if bomb.plant_time > 0 then
            draw_500_(gs_gap, bomb.site.."              ", c4_icon, bomb.plant_percentage, 251, 240, 138)
            gs_gap = gs_gap + 42
        end
    end
    if bomb.state == true and bomb.c4time > 0.0199 then
        draw_500_(gs_gap, string.format(bomb.site.." - %.2fs              ", bomb.c4time), c4_icon, nil, 205,205,205)
        gs_gap = gs_gap + 42
    end
    if bomb.state == true then
        if bomb.dmg == "FATAL" then
            draw_500_(gs_gap, bomb.dmg, nil, nil, 229,26,55)
            gs_gap = gs_gap + 42
        elseif bomb.dmg ~= "-0 HP" and bomb.dmg ~= "FATAL" then
            draw_500_(gs_gap, bomb.dmg, nil, nil, 251, 240, 138)
            gs_gap = gs_gap + 42
        end
    end
end

manual_lerp = 0
manual_arrows = function()
    if not globals_ui.manual_arrows:get() then return end
    local local_player = entity.get_local_player()
    if not local_player then return end
    if not local_player:is_alive() then return end
    local is_scoped = local_player.m_bIsScoped

    if is_scoped == true then
        manual_lerp = lerp(manual_lerp, 15, globals.frametime * 10)
    else
        manual_lerp = lerp(manual_lerp, 0, globals.frametime * 10)
    end
    if Antiaim[0].manual_aa:get() == "Left" then
        render.text(font_arrows, vector(x/2 + 20 + globals_cogs.manual_gap:get(), y/2 - 6 - manual_lerp), color(0,0,0,150), "", ">")
        render.text(font_arrows, vector(x/2 - 30 - globals_cogs.manual_gap:get(), y/2 - 6 - manual_lerp), globals_cogs.manual_color:get(), "", "<")
    elseif Antiaim[0].manual_aa:get() == "Right" then
        render.text(font_arrows, vector(x/2 - 30 - globals_cogs.manual_gap:get(), y/2 - 6 - manual_lerp), color(0,0,0,150), "", "<")
        render.text(font_arrows, vector(x/2 + 20 + globals_cogs.manual_gap:get(), y/2 - 6 - manual_lerp), globals_cogs.manual_color:get(), "", ">")
    elseif Antiaim[0].manual_aa:get() == "Off" or Antiaim[0].manual_aa:get() == "Forward" or Antiaim[0].manual_aa:get() == "Backward" then
        render.text(font_arrows, vector(x/2 - 30 - globals_cogs.manual_gap:get(), y/2 - 6 - manual_lerp), color(0,0,0,150), "", "<")
        render.text(font_arrows, vector(x/2 + 20 + globals_cogs.manual_gap:get(), y/2 - 6 - manual_lerp), color(0,0,0,150), "", ">")
    end
end

lerp_scope = function(time,a,b)
    return a * (1-time) + b * time
end
length = 0
gap = 0
custom_scope = function()
    if globals_ui.custom_scope:get() then
		if globals.is_connected == false or entity.get_local_player() == nil or entity.get_local_player():is_alive() == false then return end
		if not entity.get_local_player().m_bIsScoped then return end
		ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove All")
		length = lerp_scope(0.2, length, entity.get_local_player().m_bIsScoped and globals_cogs.scopeLength:get() or 0) 
		gap = lerp_scope(0.2, gap, entity.get_local_player().m_bIsScoped and globals_cogs.scopeGap:get() or 0) 
		local scopeColor_x = color(globals_cogs.customscope_color:get().r, globals_cogs.customscope_color:get().g, globals_cogs.customscope_color:get().b, globals_cogs.customscope_color:get().a)
		local scopeColor_y = color(globals_cogs.customscope_color:get().r, globals_cogs.customscope_color:get().g, globals_cogs.customscope_color:get().b, 0)
		render.gradient(vector(x / 2 - gap, y / 2), vector(x / 2 - gap - length, y / 2 + 1), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
		render.gradient(vector(x / 2 + gap, y / 2), vector(x / 2 + gap + length, y / 2 + 1), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
		render.gradient(vector(x / 2, y / 2 + gap), vector(x / 2 + 1, y / 2 + gap + length), scopeColor_x, scopeColor_x, scopeColor_y, scopeColor_y)
		render.gradient(vector(x / 2, y / 2 - gap), vector(x / 2 + 1, y / 2 - gap - length), scopeColor_x, scopeColor_x, scopeColor_y, scopeColor_y)
	else
		ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove Overlay")
	end
end




local hitgroup_str = {[0] = 'generic','head', 'chest', 'stomach','left arm', 'right arm','left leg', 'right leg','neck', 'generic', 'gear'}
events.aim_ack:set(function(event)
	local result = event.state
	local target = entity.get(event.target)
	local text = "%"
	if target == nil then return end
    local health = target["m_iHealth"]
    local state_1 = ""
	target = entity.get(event.target)
	if target == nil then return end

    if globals_ui.aimbot_logs:get() then
		if event.state == "spread" then state_1 = "spread" end
	    if event.state == "prediction error" then state_1 = "prediction error" end
        if event.state == "correction" then state_1 = "resolver" end
        if event.state == "misprediction" then state_1 = "misprediction" end
	    if event.state == "jitter correction" then state_1 = "jitter correction" end
	    if event.state == "correction" then state_1 = "resolver" end
	    if event.state == "lagcomp failure" then state_1 = "fake lag correction" end
		if event.state == "unregistered shot" then state_1 = "unregistered shot" end
        if event.state == "damage rejection" then state_1 = "config issue" end
		if event.state == "player death" then state_1 = "player death" end
        if event.state == "death" then state_1 = "death" end
		if result == nil then
            if globals_cogs.aimbot_logs:get(3) then
			    hitlog[#hitlog+1] = {("Hit %s in %s for %s damage (health remaining: %s)"):format(event.target:get_name(), hitgroup_str[event.hitgroup], event.damage, health), globals.tickcount + 250, 0}
            end
            if globals_cogs.aimbot_logs:get(2) then
                print_dev(("»\a%s hydra \aDEFAULT~ Hit \a%s%s \aDEFAULTin \a%s%s \aDEFAULTfor \a%s%s \aDEFAULTdamage (health remaining \a%s%s \aDEFAULT| bt: \a%s%s \aDEFAULT| wanted hitbox: \a%s%s\aDEFAULT)"):format(string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),event.target:get_name(), string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),hitgroup_str[event.hitgroup], string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),event.damage, string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),health, string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),event.backtrack, string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),hitgroup_str[event.wanted_hitgroup]))
            end
            if globals_cogs.aimbot_logs:get(1) then
                print_raw(("»\a%s hydra \aDEFAULT~ Hit \a%s%s \aDEFAULTin \a%s%s \aDEFAULTfor \a%s%s \aDEFAULTdamage (health remaining \a%s%s \aDEFAULT| bt: \a%s%s \aDEFAULT| wanted hitbox: \a%s%s\aDEFAULT)"):format(string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),event.target:get_name(), string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),hitgroup_str[event.hitgroup], string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),event.damage, string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),health, string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),event.backtrack, string.sub(globals_cogs.aimbot_logs_color:get():to_hex(),1, -3),hitgroup_str[event.wanted_hitgroup]))
            end
        else
            if globals_cogs.aimbot_logs:get(3) then
                hitlog[#hitlog+1] = {("Missed %s in the %s due to %s (wanted backtrack: %s)"):format(event.target:get_name(),hitgroup_str[event.wanted_hitgroup],state_1, event.backtrack), globals.tickcount + 250, 0}
            end
            if globals_cogs.aimbot_logs:get(2) then
                print_dev(("»\a%s hydra \aDEFAULT~ Missed \a%s%s\aDEFAULT's \a%s%s\aDEFAULT due to \a%s%s \aDEFAULT(hitchance: \a%s%s  \aDEFAULT| bt: \a%s%s  \aDEFAULT| wanted damage: \a%s%s\aDEFAULT)"):format(string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),event.target:get_name(), string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),hitgroup_str[event.wanted_hitgroup],string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),event.state,string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),event.hitchance,string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),event.backtrack,string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),event.wanted_damage))
            end
            if globals_cogs.aimbot_logs:get(1) then
                print_raw(("»\a%s hydra \aDEFAULT~ Missed \a%s%s\aDEFAULT's \a%s%s\aDEFAULT due to \a%s%s \aDEFAULT(hitchance: \a%s%s  \aDEFAULT| bt: \a%s%s  \aDEFAULT| wanted damage: \a%s%s\aDEFAULT)"):format(string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),event.target:get_name(), string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),hitgroup_str[event.wanted_hitgroup],string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),event.state,string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),event.hitchance,string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),event.backtrack,string.sub(globals_cogs.aimbot_logs_color2:get():to_hex(),1, -3),event.wanted_damage))
            end
        end
	end
end)


aimbotlogs = function()
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
            if hitlog[i][3] < 255 then 
                hitlog[i][3] = hitlog[i][3] + 10 
            end
            if globals_ui.aimbot_logs:get() then
                if string.sub(hitlog[i][1], 1, 1) == "H" then
                    notify(x/2, y - (hitlog[i][3]/5) - 32 * i, globals_cogs.aimbot_logs_color:get().r, globals_cogs.aimbot_logs_color:get().g, globals_cogs.aimbot_logs_color:get().b, globals_cogs.aimbot_logs_color:get().a, 20, 1, hitlog[i][1])
                elseif string.sub(hitlog[i][1], 1, 1) == "M" then
                    notify(x/2, y - (hitlog[i][3]/5) - 32 * i, globals_cogs.aimbot_logs_color2:get().r, globals_cogs.aimbot_logs_color2:get().g, globals_cogs.aimbot_logs_color2:get().b, globals_cogs.aimbot_logs_color2:get().a, 20, 1, hitlog[i][1])
                end
            end
        end
    end
end


-- Widgets UI
function lerpx(time,a,b) return a * (1-time) + b * time end
local usericon = render.load_image(network.get("https://cdn.discordapp.com/attachments/528267799756275732/1092523773686718574/image.png"), vector(15,15))
function widgets_window(x, y, w, h, name, alpha) 
    if not globals_ui.widgets:get() then return end
	local name_size = render.measure_text(1, "", name) 
	local r, g, b = globals_cogs.widgets_color:get().r, globals_cogs.widgets_color:get().g, globals_cogs.widgets_color:get().b
    local r2, g2, b2 = globals_cogs.widgets_color:get().r, globals_cogs.widgets_color:get().g, globals_cogs.widgets_color:get().b
    render.shadow(vector(x, y - 7), vector(x + w + 3, y + 18), color(r,g,b,alpha), 13, 0, 5)
    render.rect(vector(x, y - 7), vector(x + w + 3, y + 17), color(20,20,20, alpha), 5)
    render.rect(vector(x + w, y), vector(x + 3 + w, y + 19), color(20,20,20, alpha), 0)
    render.rect(vector(x, y), vector(x + 3, y + 19), color(20,20,20, alpha), 0)
    render.rect(vector(x, y + 16), vector(x + w + 3, y + 19), color(r,g,b, alpha), 0)
    render.text(font_font, vector(x+3 + w / 2 + 1 - name_size.x / 2,	y - 4 + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
    render.texture(usericon, vector(x+10 / 2 + 1 / 2,	y - 5 + h / 2 -  name_size.y/2), vector(15,15), color(r,g,b,alpha), f, 0)
end
local keyboardicon = render.load_image(network.get("https://cdn.discordapp.com/attachments/528267799756275732/1092507172497260555/image.png"), vector(18,18))
function keybinds_window(x, y, w, h, name, alpha) 
    if not globals_ui.widgets:get() then return end
	local name_size = render.measure_text(1, "", name) 
	local r, g, b = globals_cogs.widgets_color:get().r, globals_cogs.widgets_color:get().g, globals_cogs.widgets_color:get().b
    local r2, g2, b2 = globals_cogs.widgets_color:get().r, globals_cogs.widgets_color:get().g, globals_cogs.widgets_color:get().b
    render.shadow(vector(x, y - 7), vector(x + w + 3, y + 18), color(r,g,b,alpha), 13, 0, 5)
    render.rect(vector(x, y - 7), vector(x + w + 3, y + 17), color(20,20,20, alpha), 5)
    render.rect(vector(x + w, y), vector(x + 3 + w, y + 19), color(20,20,20, alpha), 0)
    render.rect(vector(x, y), vector(x + 3, y + 19), color(20,20,20, alpha), 0)
    render.rect(vector(x, y + 16), vector(x + w + 3, y + 19), color(r,g,b, alpha), 0)
    render.text(font_font, vector(x+3 + w / 2 + 1 - name_size.x / 2,	y - 4 + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
    render.texture(keyboardicon, vector(x+10 / 2 + 1 / 2,	y - 7 + h / 2 -  name_size.y/2), vector(18,18), color(r,g,b,alpha), f, 0)
end

local alphabinds, alpha_k, width_k, width_ka, data_k, width_spec = 0, 1, 0, 0, { [''] = {alpha_k = 0}}, 1

local pos_x2 = hydra.cogs.widgets:slider("posx", 0, x, 280)
local pos_y2 = hydra.cogs.widgets:slider("posy", 0, y, 280)
local pos_x1 = hydra.cogs.widgets:slider("posx1", 0, x, 250)
local pos_y1 = hydra.cogs.widgets:slider("posy1", 0, y, 250)

local widgets_drag_object = drag_system.register({pos_x2, pos_y2}, vector(122, 20), "Test", function(self)
    if not globals_ui.widgets:get() then return end
    if not globals_cogs.widgets_items:get(1) then return end
    local max_width = 0
    local frametime = globals.frametime * 16
    local add_y = 0
    local total_width = 66
    local active_binds = {}

    local binds = ui.get_binds()
    for i = 1, #binds do
            local bind = binds[i]
            local get_mode = binds[i].mode == 1 and 'holding' or (binds[i].mode == 2 and 'toggled') or '[?]'
            local get_value = binds[i].value

            local c_name = binds[i].name
            if c_name == 'Peek Assist' then c_name = 'Quick peek assist' end
            if c_name == 'Edge Jump' then c_name = 'Jump at edge' end
            if c_name == 'Hide Shots' then c_name = 'On shot anti-aim' end
            if c_name == 'Minimum Damage' then c_name = 'Minimum damage' end
            if c_name == 'Fake Latency' then c_name = 'Ping spike' end
            if c_name == 'Fake Duck' then c_name = 'Duck peek assist' end
            if c_name == 'Safe Points' then c_name = 'Safe point' end
            if c_name == 'Body Aim' then c_name = 'Body aim' end
            if c_name == 'Double Tap' then c_name = 'Double tap' end
            if c_name == 'Yaw Base' then c_name = 'Manual override' end
            if c_name == 'Slow Walk' then c_name = 'Slow motion' end


            local bind_state_size = render.measure_text(1, "", get_mode)
            local bind_name_size = render.measure_text(1, "", c_name)
            if data_k[bind.name] == nil then data_k[bind.name] = {alpha_k = 0} end
            data_k[bind.name].alpha_k = lerpx(frametime, data_k[bind.name].alpha_k, (bind.active and 255 or 0))

                render.text(1, vector(self.position.x+3, self.position.y + 19 + add_y), color(255, data_k[bind.name].alpha_k), '', c_name)

                if c_name == 'Minimum damage' or c_name == 'Ping spike' then
                    render.text(1, vector(self.position.x + (width_ka - bind_state_size.x) - render.measure_text(1, nil, get_value).x + 28, self.position.y + 19 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_value..']')
                else
                    render.text(1, vector(self.position.x + (width_ka - bind_state_size.x - 8), self.position.y + 19 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_mode..']')
                end
                render.text(1, vector(self.position.x+3, self.position.y + 19 + add_y), color(255, data_k[bind.name].alpha_k), '', c_name)
                
            add_y = add_y + 16 * data_k[bind.name].alpha_k/255

            --drag O.G L.E.A.K.S
            local width_k = bind_state_size.x + bind_name_size.x + 18
            if width_k > 130-11 then
                if width_k > max_width then
                    max_width = width_k
                end
            end

            if binds.active then
                    table.insert(active_binds, binds)
                end
            end

            alpha_k = lerpx(frametime, alpha_k, (ui.get_alpha() > 0 or add_y > 0) and 1 or 0)
            width_ka = lerpx(frametime,width_ka, math.max(max_width, 130-11))
            if ui.get_alpha()>0 or add_y > 6 then alphabinds = lerpx(frametime, alphabinds, math.max(ui.get_alpha()*255, (add_y > 1 and 255 or 0)))
            elseif add_y < 15.99 and ui.get_alpha() == 0 then alphabinds = lerpx(frametime, alphabinds, 0) end
            if ui.get_alpha() or #active_binds > 0 then
                keybind_text = gradient.text_animate("Keybinds", -1, {
                    color(globals_cogs.widgets_color:get().r ,globals_cogs.widgets_color:get().g, globals_cogs.widgets_color:get().b, globals_cogs.widgets_color:get().a),
                    color(globals_cogs.widgets_color2:get().r, globals_cogs.widgets_color2:get().g, globals_cogs.widgets_color2:get().b, globals_cogs.widgets_color2:get().a)
                })
                keybinds_window(self.position.x, self.position.y - 2, width_ka, 16, keybind_text:get_animated_text(), alphabinds)
                keybind_text:animate()
            end
end)


local widgets_drag_object1 = drag_system.register({pos_x1, pos_y1}, vector(122, 20), "Test2", function(self)
    if not globals_ui.widgets:get() then return end
    if not globals_cogs.widgets_items:get(2) then return end
    --drag
    local width_spec = 120
    if width_spec > 160-11 then
        if width_spec > max_width then
            max_width = width_spec
        end
    end

    if ui.get_alpha() > 0.3 or (ui.get_alpha() > 0.3 and not globals.is_in_game) then widgets_window(self.position.x, self.position.y, width_spec, 16, 'spectators', 255) end

    local me = entity.get_local_player()
    if me == nil then return end

    local speclist = me:get_spectators()

    if me.m_hObserverTarget and (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
        me = me.m_hObserverTarget
    end

    local speclist = me:get_spectators()
    if speclist == nil then return end
    for idx,player_ptr in pairs(speclist) do
        local name = player_ptr:get_name()
        local tx = render.measure_text(1, '', name).x
        name_sub = string.len(name) > 17 and string.sub(name, 0, 17) .. "..." or name;
        local avatar = player_ptr:get_steam_avatar()
        if (avatar == nil or avatar.width <= 5) then avatar = fnay end

        if player_ptr:is_bot() and not player_ptr:is_player() then goto skip end
        render.text(1, vector(self.position.x + 17, self.position.y + 7 + (idx*15)), color(), 'u', name_sub)
        render.texture(avatar, vector(self.position.x + 1, self.position.y + 7 + (idx*15)), vector(12, 12), color(), 'f', 0)
        ::skip::
    end

   
    if #me:get_spectators() > 0 or (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
        spectators_text = gradient.text_animate("Spectators", -1, {
            color(globals_cogs.widgets_color:get().r ,globals_cogs.widgets_color:get().g, globals_cogs.widgets_color:get().b, globals_cogs.widgets_color:get().a),
            color(globals_cogs.widgets_color2:get().r, globals_cogs.widgets_color2:get().g, globals_cogs.widgets_color2:get().b, globals_cogs.widgets_color2:get().a)
        })
        widgets_window(self.position.x, self.position.y, width_spec, 16, spectators_text:get_animated_text(), 255)
        spectators_text:animate()
    end
    
end)
local pos_x3 = hydra.cogs.widgets:slider("posx3", 0, x, (x/2) + 10)
local pos_y3 = hydra.cogs.widgets:slider("posy3", 0, y, (y/2) - 20)
local dmg_indicator_fnc = drag_system.register({pos_x3, pos_y3}, vector(24,20), "Test", function(self)
    pos_x3:visibility(false)
    pos_y3:visibility(false)
    if not globals_ui.dmg_indicator:get() then return end
    local local_player = entity.get_local_player()
    if globals.is_connected == false or local_player == nil or local_player:is_alive() == false then return end
    local text = tostring(refs.dmg:get())
    if ui.get_alpha() > 0.1 then
        render.text(1, vector(self.position.x + 3, self.position.y + 3), color(), '', "dmg")
        render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + 24, self.position.y + 20), color(255,255,255,150), 1, 2, false)
    else
        render.text(1, vector(self.position.x + 3, self.position.y + 3), color(), '', text)
    end
end)

--> Viewmodel Changer
viewmodel_changer = function()
    if globals_ui.viewmodel_changer:get() then
        cvar.viewmodel_fov:int(globals_cogs.viewmodel_fov:get(), true)
		cvar.viewmodel_offset_x:float(globals_cogs.viewmodel_x:get(), true)
		cvar.viewmodel_offset_y:float(globals_cogs.viewmodel_y:get(), true)
		cvar.viewmodel_offset_z:float(globals_cogs.viewmodel_z:get(), true)
    else
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
    end
end

--> Visiblity

visiblity = function()
    globals_cogs.logo:visibility(globals_cogs.indicators_mode:get() == "Default")
    globals_cogs.logo_color:visibility(globals_cogs.indicators_mode:get() == "Default" and globals_cogs.logo:get())
    globals_cogs.box_color:visibility(globals_cogs.indicators_mode:get() == "Default")
    globals_cogs.second_indicators_color:visibility(globals_cogs.indicators_mode:get() == "Default")
    globals_cogs.glow:visibility(globals_cogs.indicators_mode:get() == "Default")
    globals_cogs.glow_color:visibility(globals_cogs.indicators_mode:get() == "Default" and globals_cogs.glow:get())

    globals_cogs.hc_inair:visibility(globals_cogs.hc_select:get("In Air"))
    globals_cogs.hc_noscope:visibility(globals_cogs.hc_select:get("No Scope"))


    globals_cogs.watermark_style:visibility(globals_cogs.widgets_items:get(3))

    pos_x2:visibility(false)
    pos_y2:visibility(false)
    pos_x1:visibility(false)
    pos_y1:visibility(false)
end

--> Callbacks

events.render:set(function()
    cst_hitchances()
    viewmodel_changer()
    Antiaimvisibler()
    visiblity()
    indicators()
    defensive_inair()
    gs_ind()
    aimbotlogs()
    manual_arrows()
    enemy_line()
    custom_scope()
    flag_watermark()
    watermark:update()
    widgets_drag_object:update()
    widgets_drag_object1:update()
    dmg_indicator_fnc:update()
    if globals_ui.aspect_ratio:get() then
    cvar.r_aspectratio:float(globals_cogs.aspect_ratio:get()/100)
    else
    cvar.r_aspectratio:float(1)
    end
end)
events.createmove:set(function(cmd)
    Antiaim_worker(cmd)
    fastladder_init(cmd)
    no_fall_dmg(cmd)
    tbl_checker()
    grenade_fix()
end)

events.round_start:set(function()
    flash_icon()
end)

-- cfg sys

local data = {
	bools = {},
	tables = {},
	ints = {},
	numbers = {},
}

function sorting(t)  
	local a = {}  
	for n in pairs(t) do a[#a+1] = n  
	end  
	table.sort(a)  
	local i = 0  
	return 
    function()  
		i = i + 1 return a[i], t[a[i]]  
	end  
end 

for i, v in sorting(var.player_states) do
	for _, v in sorting(Antiaim[i]) do
		if type(v:get()) == "boolean" then
			table.insert(data.bools,v)
		elseif type(v:get()) == "table" then
			table.insert(data.tables,v)
		elseif type(v:get()) == "string" then
			table.insert(data.ints,v)
		else
			table.insert(data.numbers,v)
		end
	end
end
for i, v in sorting(var.player_states) do
	for _, v in sorting(Defensive_AA[i]) do
		if type(v:get()) == "boolean" then
			table.insert(data.bools,v)
		elseif type(v:get()) == "table" then
			table.insert(data.tables,v)
		elseif type(v:get()) == "string" then
			table.insert(data.ints,v)
		else
			table.insert(data.numbers,v)
		end
	end
end
for _, v in sorting(Antiaim[0]) do
	if type(v:get()) == "boolean" then
		table.insert(data.bools,v)
	elseif type(v:get()) == "table" then
		table.insert(data.tables,v)
	elseif type(v:get()) == "string" then
		table.insert(data.ints,v)
	else
		table.insert(data.numbers,v)
	end
end
configs_export = function()
	local configs = {{},{},{},{},{},{}}
		for _, bools in pairs(data.bools) do
			table.insert(configs[1], bools:get())
		end
		
		for _, tables in pairs(data.tables) do
			table.insert(configs[2], tables:get())
		end
		
		for _, ints in pairs(data.ints) do
			table.insert(configs[3], ints:get())
		end
		
		for _, numbers in pairs(data.numbers) do
			table.insert(configs[4], numbers:get())
		end
		clipboard.set(base64.encode(json.stringify(configs)))
        utils.console_exec("playvol buttons/bell1.wav 1")  
		
end
configs_import = function()
    utils.console_exec("playvol buttons/bell1.wav 1")  
	local config = clipboard.get()
	for k, v in pairs(json.parse(base64.decode(config))) do
		k = ({[1] = "bools", [2] = "tables",[3] = "ints",[4] = "numbers"})[k]
		for k2, v2 in pairs(v) do
			if (k == "bools") then
				data[k][k2]:set(v2)
			end
	
			if (k == "tables") then
				data[k][k2]:set(v2)
			end
	
			if (k == "ints") then
				data[k][k2]:set(v2)
			end
				
			if (k == "numbers") then
				data[k][k2]:set(v2)
			end

		end
	end
end
configs_default = function()
    utils.console_exec("playvol buttons/bell1.wav 1")  
	local config = "W1t0cnVlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLGZhbHNlLHRydWVdLFtbIkppdHRlciJdLFsiSml0dGVyIl0sW10sW10sWyJKaXR0ZXIiXSxbIkppdHRlciJdLFsiSml0dGVyIl0sWyJIeWRyYSB3YWxrIiwiU3RhdGljIGxlZ3MgaW4gYWlyIiwiQm9keSBsZWFuIl0sWyJTdGFuZGluZyIsIkhpZGUgU2hvdHMiXSxbIkF2b2lkIEJhY2tzdGFiIl1dLFsiT2ZmIiwiQ2VudGVyIiwiQXQgVGFyZ2V0IiwiVGljay1Td2l0Y2hlciIsIk9mZiIsIkNlbnRlciIsIkF0IFRhcmdldCIsIlNsb3cgWWF3IiwiT2ZmIiwiRGlzYWJsZWQiLCJBdCBUYXJnZXQiLCJUaWNrLVN3aXRjaGVyIiwiT2ZmIiwiRGlzYWJsZWQiLCJBdCBUYXJnZXQiLCJTd2F5IiwiT2ZmIiwiQ2VudGVyIiwiQXQgVGFyZ2V0IiwiTCZSIiwiT2ZmIiwiQ2VudGVyIiwiQXQgVGFyZ2V0IiwiVGljay1Td2l0Y2hlciIsIk9mZiIsIkNlbnRlciIsIkF0IFRhcmdldCIsIkwmUiIsIkRpc2FibGVkIiwiRGlzYWJsZWQiLCJEaXNhYmxlZCIsIkRpc2FibGVkIiwiRGlzYWJsZWQiLCJEaXNhYmxlZCIsIkRpc2FibGVkIiwiU2xvd3dhbGsiLCJPZmYiXSxbNjAuMCw2MC4wLC0yNi4wLC0yNS4wLDI1LjAsNjAuMCw2MC4wLC03OS4wLC01LjAsMzUuMCw2MC4wLDYwLjAsMC4wLDMxLjAsLTEyLjAsNjAuMCw2MC4wLDAuMCwtMjYuMCw0Ni4wLDYwLjAsNjAuMCwtMzEuMCwtMTcuMCwxNy4wLDYwLjAsNjAuMCwtNjAuMCwxMi4wLDUwLjAsNjAuMCw2MC4wLC01NS4wLC03LjAsNy4wLDUuMCw1LjAsNS4wLDUuMCw1LjAsNS4wLDUuMF0sW10sW11d"
	for k, v in pairs(json.parse(base64.decode(config))) do
		k = ({[1] = "bools", [2] = "tables",[3] = "ints",[4] = "numbers"})[k]
		for k2, v2 in pairs(v) do
			if (k == "bools") then
				data[k][k2]:set(v2)
			end
	
			if (k == "tables") then
				data[k][k2]:set(v2)
			end
	
			if (k == "ints") then
				data[k][k2]:set(v2)
			end
				
			if (k == "numbers") then
				data[k][k2]:set(v2)
			end

		end
	end
end
configs_export2 = hydra.groups[7]:button(ui.get_icon("file-export").."     Export config   ", configs_export, true)
configs_import2 = hydra.groups[7]:button(ui.get_icon("file-import").."     Import config   ", configs_import, true)
configs_default2 = hydra.groups[7]:button(ui.get_icon("user").."                         Default config                             ", configs_default, true)