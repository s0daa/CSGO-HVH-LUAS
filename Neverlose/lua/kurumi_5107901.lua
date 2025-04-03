_DEBUG = true
--start ffi region#--
--ui.get_style("Button")

local gradient = require("neverlose/gradient")
local clipboard = require("neverlose/clipboard")
local base64 = require("neverlose/base64")
local color_p = require("neverlose/color_print")
local drag_system = require("neverlose/drag_system")
local timer = require("neverlose/timer")
local aa_library = require("neverlose/anti_aim")
local tbl = {}
local texts = render.measure_text
local kurumifunc = {}
local kurumi = {}
local x, y = render.screen_size().x, render.screen_size().y
local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet'
width_ka5 = 0
drag2 = false
drag3 = false


local lerp = function(time,a,b)
    return a * (1-time) + b * time
end


local function render_gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
    local output = ''
    local len = #text-1
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len
    for i=1, len+1 do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end

    return output
end

ffi_handlers = {

    bind_argument = function(fn, arg)
        return function(...)
            return fn(arg, ...)
        end
    end,
    

    open_link = function (link)
        local steam_overlay_API = panorama.SteamOverlayAPI
        local open_external_browser_url = steam_overlay_API.OpenExternalBrowserURL
        open_external_browser_url(link)
    end,


}

ffi.cdef[[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);
    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);


    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_t;

    
    typedef struct
    {
        char    pad0[0x60]; // 0x00
        void* pEntity; // 0x60
        void* pActiveWeapon; // 0x64
        void* pLastActiveWeapon; // 0x68
        float        flLastUpdateTime; // 0x6C
        int            iLastUpdateFrame; // 0x70
        float        flLastUpdateIncrement; // 0x74
        float        flEyeYaw; // 0x78
        float        flEyePitch; // 0x7C
        float        flGoalFeetYaw; // 0x80
        float        flLastFeetYaw; // 0x84
        float        flMoveYaw; // 0x88
        float        flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float        flLeanAmount; // 0x90
        char    pad1[0x4]; // 0x94
        float        flFeetCycle; // 0x98 0 to 1
        float        flMoveWeight; // 0x9C 0 to 1
        float        flMoveWeightSmoothed; // 0xA0
        float        flDuckAmount; // 0xA4
        float        flHitGroundCycle; // 0xA8
        float        flRecrouchWeight; // 0xAC
        Vector_t        vecOrigin; // 0xB0
        Vector_t        vecLastOrigin;// 0xBC
        Vector_t        vecVelocity; // 0xC8
        Vector_t        vecVelocityNormalized; // 0xD4
        Vector_t        vecVelocityNormalizedNonZero; // 0xE0
        float        flVelocityLenght2D; // 0xEC
        float        flJumpFallVelocity; // 0xF0
        float        flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
        float        flRunningSpeed; // 0xF8
        float        flDuckingSpeed; // 0xFC
        float        flDurationMoving; // 0x100
        float        flDurationStill; // 0x104
        bool        bOnGround; // 0x108
        bool        bHitGroundAnimation; // 0x109
        char    pad2[0x2]; // 0x10A
        float        flNextLowerBodyYawUpdateTime; // 0x10C
        float        flDurationInAir; // 0x110
        float        flLeftGroundHeight; // 0x114
        float        flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float        flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char    pad3[0x4]; // 0x120
        float        flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char    pad4[0x208]; // 0x128
        float        flMinBodyYaw; // 0x330
        float        flMaxBodyYaw; // 0x334
        float        flMinPitch; //0x338
        float        flMaxPitch; // 0x33C
        int            iAnimsetVersion; // 0x340
    } CCSGOPlayerAnimationState_534535_t;
    
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);

    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
]]

entity_list_pointer = ffi.cast('void***', utils.create_interface('client.dll', 'VClientEntityList003'))
get_client_entity_fn = ffi.cast('GetClientEntity_4242425_t', entity_list_pointer[0][3])
function get_entity_address(ent_index)
    local addr = get_client_entity_fn(entity_list_pointer, ent_index)
    return addr
end

function kurumifunc:contains(list, x)
	for _, v in pairs(list) do
		if v == x then return true end
	end
	return false
end
function kurumifunc:get_neverlose_path()
    return common.get_game_directory():sub(1, -5) .. "nl\\"
end

function kurumifunc:Download(from, to)
    wininet.DeleteUrlCacheEntryA(from)
    urlmon.URLDownloadToFileA(nil, from, to, 0,0)
end
function kurumifunc:file_exists(file, path_id)
    local func_file_exists = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", ffi.cast(ffi.typeof("void***"), utils.create_interface("filesystem_stdio.dll", "VBaseFileSystem011"))[0][10])
    return func_file_exists(ffi.cast(ffi.typeof("void***"), utils.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")), file, path_id)
end

files.create_folder(kurumifunc:get_neverlose_path().."kurumi\\")

if not kurumifunc:file_exists(kurumifunc:get_neverlose_path().."kurumi\\smallest_pixel-7.tff", "GAME") then
	kurumifunc:Download('https://github.com/fakeangle/neverlose_bettervisuals/blob/main/smallest_pixel-7.ttf?raw=true', kurumifunc:get_neverlose_path().."kurumi\\smallest_pixel-7.tff")
end

if not kurumifunc:file_exists(kurumifunc:get_neverlose_path().."kurumi\\kurumiloading.gif", "GAME") then
	kurumifunc:Download('https://media.tenor.com/MGBfTT4mszcAAAAd/momiibladei-06.gif', kurumifunc:get_neverlose_path().."kurumi\\kurumiloading.gif")
end


--end ffi region#--
kurumi.sidebar_selection = ui.get_style("Switch Active") 
local sidebar_color = kurumi.sidebar_selection:to_hex()
local colorek = kurumi.sidebar_selection



--start menu region#--
local kurumi = {
        menu = {
            icon = {
                export = ui.get_icon("file-export"),
                import = ui.get_icon("file-import"),
                default = ui.get_icon("cloud"),
                sidemenu = ui.get_icon("cannabis"),
                discordserver = ui.get_icon("location-arrow"),                      
            },
            color = {
            },
            ui = {
                global_main = ui.create("\a".. sidebar_color .."".. ui.get_icon("globe") .."\aFFFFFFFF  Global", "\a".. sidebar_color .."".. ui.get_icon("info") .."\aFFFFFFFF  Information"),
                global_lang = ui.create("\a".. sidebar_color .."".. ui.get_icon("globe") .."\aFFFFFFFF  Global", "\a".. sidebar_color .."".. ui.get_icon("language") .."\aFFFFFFFF  Language"),
                global_stats = ui.create("\a".. sidebar_color .."".. ui.get_icon("globe") .."\aFFFFFFFF  Global", "\a".. sidebar_color .."".. ui.get_icon("signal") .."\aFFFFFFFF  Statistics"),
                antiaim_menu = ui.create("\a".. sidebar_color .."".. ui.get_icon("running") .."\aFFFFFFFF  Anti Aim", "\a".. sidebar_color ..""..ui.get_icon("street-view").. "\aFFFFFFFF  Main"),
                antiaim_builder = ui.create("\a".. sidebar_color .."".. ui.get_icon("running") .."\aFFFFFFFF  Anti Aim", "\a".. sidebar_color ..""..ui.get_icon("street-view")..  "\aFFFFFFFF  Anti-Aim Builder"),
                antiaim_configs = ui.create("\a".. sidebar_color .."".. ui.get_icon("running") .."\aFFFFFFFF  Anti Aim",  "\a".. sidebar_color ..""..ui.get_icon("file").. "\aFFFFFFFF  Configs"),
                visuals_main = ui.create("\a".. sidebar_color .."".. ui.get_icon("eye") .. "\aFFFFFFFF  Visuals ",  "\a".. sidebar_color ..""..ui.get_icon("paint-brush").. "\aFFFFFFFF  Visuals"),
                visuals_settings = ui.create("\a".. sidebar_color .."".. ui.get_icon("eye") .. "\aFFFFFFFF  Visuals ",  "\a".. sidebar_color ..""..ui.get_icon("cog").. "\aFFFFFFFF  Misc"),
            },
            create = { 
                sidebar_text = render_gradient_text(255,255,255,221,kurumi.sidebar_selection.r,kurumi.sidebar_selection.g,kurumi.sidebar_selection.b,255,'Kurumi AntiAim'),
                nickname = render_gradient_text(255,255,255,221,kurumi.sidebar_selection.r,kurumi.sidebar_selection.g,kurumi.sidebar_selection.b,255, common.get_username()),
                anims = render_gradient_text(255,255,255,221,kurumi.sidebar_selection.r,kurumi.sidebar_selection.g,kurumi.sidebar_selection.b,255, "Anim. Breakers"),
                script = render_gradient_text(255,255,255,221,kurumi.sidebar_selection.r,kurumi.sidebar_selection.g,kurumi.sidebar_selection.b,255,'2.0'),
                version = render_gradient_text(255,255,255,221,kurumi.sidebar_selection.r,kurumi.sidebar_selection.g,kurumi.sidebar_selection.b,255,'Stable'),
                language = render_gradient_text(255,255,255,221,kurumi.sidebar_selection.r,kurumi.sidebar_selection.g,kurumi.sidebar_selection.b,255,'Language'),
                --onlineusers = render_gradient_text(255,255,255,221,kurumi.sidebar_selection.r,kurumi.sidebar_selection.g,kurumi.sidebar_selection.b,255, online),
                ovr_aa = render_gradient_text(255,255,255,221,kurumi.sidebar_selection.r,kurumi.sidebar_selection.g,kurumi.sidebar_selection.b,255,'Override Anti-Aim'),
                ovr_vis = render_gradient_text(255,255,255,221,kurumi.sidebar_selection.r,kurumi.sidebar_selection.g,kurumi.sidebar_selection.b,255,'Override Visuals'),
                ovr_misc = render_gradient_text(255,255,255,221,kurumi.sidebar_selection.r,kurumi.sidebar_selection.g,kurumi.sidebar_selection.b,255,'Override Miscellaneous'),
                beta = render_gradient_text(255,255,255,221,kurumi.sidebar_selection.r,kurumi.sidebar_selection.g,kurumi.sidebar_selection.b,255,'[BETA]'),
            },

            globals = {
                tab = {

                },
                rage = {

                },
                antiaim = {

                },
                visuals = {
                    
                },
            },
        },
        entitys = {},
        config = {},
        functions = {},
        js = {},
        globals = {},
        working_functions = {},

        antiaim = {
            aa_states = {
                "Global", 
                "Stand", 
                "Move", 
                "Slowwalk", 
                "Crouch", 
                "Jump", 
                "Jump+Crouch",
                "Fakeduck",
            },
            aa_states2 = {
                "G", 
                "S", 
                "M", 
                "SW",
                "C", 
                "J", 
                "J+C",
                "FD",
                --"FL",
            },
        },


        visuals = {
            font = {
                pixel9 = render.load_font(kurumifunc:get_neverlose_path().."kurumi\\smallest_pixel-7.tff", 10, "o"),
                verdanabold = render.load_font("Verdana", 21, "bd"),  
            },
            indicators = {
                states = {
                    [1] = "standing",
                    [2] = "moving",
                    [3] = "walking",
                    [4] = "crouching",
                    [5] = "air",
                    [6] = "air+crouch",
                },
            },
        },

        globals = {
            info = {
                username = common.get_username(),
            }
        },
        



}

--[[kurumi.working_functions.get_colorek = function()
    local colordojebania = ui.get_style("Switch Active")
        common.reload_script()
    end 
end--]]


ui.sidebar(kurumi.menu.create.sidebar_text, kurumi.menu.icon.sidemenu)

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

kurumi.ref = {
    fakeduck = ui.find('Aimbot','Anti Aim',"Misc","Fake Duck"),
    slowwalk = ui.find('Aimbot','Anti Aim',"Misc","Slow Walk"),
    pitch = ui.find('Aimbot','Anti Aim',"Angles","Pitch"),
    yaw = ui.find('Aimbot','Anti Aim',"Angles","Yaw"),
    yawbase = ui.find('Aimbot','Anti Aim',"Angles","Yaw",'Base'),
    yawadd = ui.find('Aimbot','Anti Aim',"Angles","Yaw",'Offset'),
    fake_lag_limit = ui.find('Aimbot','Anti Aim',"Fake Lag","Limit"),
    yawjitter = ui.find('Aimbot','Anti Aim',"Angles","Yaw Modifier"),
    yawjitter_offset = ui.find('Aimbot','Anti Aim',"Angles","Yaw Modifier",'Offset'),
    fakeangle = ui.find('Aimbot','Anti Aim',"Angles","Body Yaw"),
    inverter = ui.find('Aimbot','Anti Aim',"Angles","Body Yaw","Inverter"),
    left_limit = ui.find('Aimbot','Anti Aim',"Angles","Body Yaw","Left Limit"),
    right_limit = ui.find('Aimbot','Anti Aim',"Angles","Body Yaw","Right Limit"),
    fakeoption = ui.find('Aimbot','Anti Aim',"Angles","Body Yaw","Options"),
    fsbodyyaw = ui.find('Aimbot','Anti Aim',"Angles","Body Yaw","Freestanding"),
    freestanding = ui.find('Aimbot','Anti Aim',"Angles","Freestanding"),
    dsyawfs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    bodyfreestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    body_freestanding = ui.find('Aimbot','Anti Aim',"Angles","Freestanding","Body Freestanding"),
    roll = ui.find('Aimbot','Anti Aim',"Angles","Extended Angles"),
    roll_pitch = ui.find('Aimbot','Anti Aim',"Angles","Extended Angles","Extended Pitch"),
    roll_roll = ui.find('Aimbot','Anti Aim',"Angles","Extended Angles","Extended Roll"),
    leg_movement = ui.find('Aimbot','Anti Aim',"Misc","Leg Movement"),
    hitchance = ui.find('Aimbot','Ragebot',"Selection","Hit Chance"),
    air_strafe = ui.find('Miscellaneous',"Main","Movement",'Air Strafe'),
    antibackstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    minimum_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    dt_opt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    dt_fl = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"),
    os_type = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
}
local hooked_function, is_jumping = nil, false
local hitgroup_str = {
    [0] = 'generic',
    'head', 'chest', 'stomach',
    'left arm', 'right arm',
    'left leg', 'right leg',
    'neck', 'generic', 'gear'
}
--start ui region#--




kurumi.menu.globals.tab.gif = render.load_image_from_file(kurumifunc:get_neverlose_path().."kurumi\\kurumiloading.gif", vector(800, 400))


kurumi.menu.globals.tab.global_label2 = kurumi.menu.ui.global_lang:label("Pick your language which u prefer : ")
kurumi.menu.globals.tab.language = kurumi.menu.ui.global_lang:combo(kurumi.menu.create.language, {'English', 'Russian'})


kurumi.menu.globals.tab.global_label = kurumi.menu.ui.global_main:label("Welcome "..kurumi.menu.create.nickname.."")
kurumi.menu.globals.tab.global_label = kurumi.menu.ui.global_main:label("Build : ".. kurumi.menu.create.version.."")
kurumi.menu.globals.tab.global_label1 = kurumi.menu.ui.global_main:label("Script Version: "..kurumi.menu.create.script.."")



kurumi.menu.globals.tab.global_label2 = kurumi.menu.ui.global_main:label("Join best leaking server")

local function discordbutton()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")
    utils.console_exec(string.format("playvol buttons/bell1.wav 1"))
end

kurumi.menu.globals.tab.discord_button = kurumi.menu.ui.global_main:button("\a".. sidebar_color ..""..kurumi.menu.icon.discordserver .."\aFFFFFFFF Discord server", discordbutton, true)

kurumi.menu.globals.tab.anim_switch = kurumi.menu.ui.global_main:switch("Loading Animation",false)



-- antiaim
kurumi.menu.globals.antiaim.enable_antiaim = kurumi.menu.ui.antiaim_menu:switch(kurumi.menu.create.ovr_aa)
kurumi.menu.globals.antiaim.custom_aa = kurumi.menu.ui.antiaim_menu:combo("Mode", {"Default", "Condictional"})  
kurumi.menu.globals.antiaim.custom_aa:tooltip("Type of AntiAim \n Disabled: No AA \n Condictional: Builder")
manual_yaw_base = kurumi.menu.ui.antiaim_menu:combo("Yaw Base", {"Disabled", "Forward", "Left", "Right"})
kurumi.menu.globals.antiaim.animation_breakers = kurumi.menu.ui.antiaim_menu:selectable(kurumi.menu.create.anims, {'Static legs in air', 'Follow direction', 'Zero pitch on land'}, 0)
--[[kurumi.menu.globals.antiaim.antibrute_switch =  kurumi.menu.ui.antiaim_menu:switch(kurumi.menu.create.beta.."\aC6D1DAFF  Anti-Bruteforce")
kurumi.menu.globals.antiaim.antibrute_group = kurumi.menu.globals.antiaim.antibrute_switch:create()
kurumi.menu.globals.antiaim.antibrute_select_mode = kurumi.menu.globals.antiaim.antibrute_group:combo("Bruteforce Mode", {"Fake Modifier", "Yaw Offset Modifier"})
kurumi.menu.globals.antiaim.antibrute_time_reset = kurumi.menu.globals.antiaim.antibrute_group:slider('Time to Reset',0,10,6,1)--]]  
-- NEXT UPDATE TO DODAMY ^^^^^^^^^^^^^^^^^^^^

kurumi.menu.globals.antiaim.fress_switch =  kurumi.menu.ui.antiaim_menu:switch("Freestanding")
kurumi.menu.globals.antiaim.fs_set = kurumi.menu.globals.antiaim.fress_switch:create()
kurumi.menu.globals.antiaim.fs_switch = kurumi.menu.globals.antiaim.fs_set:switch('Disable Yaw Modifiers', false)
kurumi.menu.globals.antiaim.fs_switch1 = kurumi.menu.globals.antiaim.fs_set:switch('Body Freestanding', false)
kurumi.menu.globals.antiaim.condition = kurumi.menu.ui.antiaim_builder:combo(""..ui.get_icon("users").."  Condition", kurumi.antiaim.aa_states)

kurumi.menu.globals.antiaim.anti_backstab =  kurumi.menu.ui.antiaim_menu:switch("Anti-Backstab")
kurumi.menu.globals.antiaim.dormant_aimbot =  kurumi.menu.ui.antiaim_menu:switch("Dormant Aimbot")
kurumi.menu.globals.antiaim.fake_pitch_exploit =  kurumi.menu.ui.antiaim_menu:switch("Fake Pitch Exploit")


kurumi.menu.globals.visuals.enable_visuals = kurumi.menu.ui.visuals_main:switch(kurumi.menu.create.ovr_vis)
kurumi.menu.globals.visuals.solusui_switch = kurumi.menu.ui.visuals_main:switch("Solus UI")
kurumi.menu.globals.visuals.solusui = kurumi.menu.globals.visuals.solusui_switch:create()
kurumi.menu.globals.visuals.solusui_selectable = kurumi.menu.globals.visuals.solusui:selectable('Select', {'Watermark', 'Keybinds', 'Spectator List'}, 0)

kurumi.menu.globals.visuals.solus_combo = kurumi.menu.globals.visuals.solusui:combo("Style", {"Default", "Modern"})
kurumi.menu.globals.visuals.accent_col = kurumi.menu.globals.visuals.solusui:color_picker("Solus UI Color", color(139, 146, 248))

kurumi.menu.globals.visuals.label = kurumi.menu.globals.visuals.solusui:label("  ")

kurumi.menu.globals.visuals.gradient = kurumi.menu.globals.visuals.solusui:switch("Rect Behind Watermark")
kurumi.menu.globals.visuals.gradientcolor = kurumi.menu.globals.visuals.solusui:color_picker("Gradient Rect Color", color(colorek.r, colorek.g, colorek.b, 255))
kurumi.menu.globals.visuals.uiclr = kurumi.menu.globals.visuals.solusui:color_picker("UI Color", color(colorek.r, colorek.g, colorek.b, 255))
kurumi.menu.globals.visuals.wm1 = kurumi.menu.globals.visuals.solusui:color_picker("Animated Gradient Color", color(colorek.r, colorek.g, colorek.b, 255))

kurumi.menu.globals.visuals.watermark_x = kurumi.menu.globals.visuals.solusui:slider("Slider 1", 0, render.screen_size().x, 700)
kurumi.menu.globals.visuals.watermark_y = kurumi.menu.globals.visuals.solusui:slider("Slider 2", 0, render.screen_size().y, 700)


kurumi.menu.globals.visuals.indicators2 = kurumi.menu.ui.visuals_main:switch("Indicators")
kurumi.menu.globals.visuals.indicators_wel = kurumi.menu.globals.visuals.indicators2:create()
kurumi.menu.globals.visuals.indicators_type = kurumi.menu.globals.visuals.indicators_wel:combo("Indicators Type", {'Default','Modern'}, 0)
kurumi.menu.globals.visuals.color23 = kurumi.menu.globals.visuals.indicators_wel:color_picker('Indicators Color', color(colorek.r, colorek.g, colorek.b, 255))
kurumi.menu.globals.visuals.color24 = kurumi.menu.globals.visuals.indicators_wel:color_picker('Indicators Color 2', color(colorek.r, colorek.g, colorek.b, 255))
kurumi.menu.globals.visuals.color25 = kurumi.menu.globals.visuals.indicators_wel:color_picker('Box Color', color(colorek.r, colorek.g, colorek.b, 255))

kurumi.menu.globals.visuals.aimbot_logs = kurumi.menu.ui.visuals_main:switch('Aimbot Logs')
kurumi.menu.globals.visuals.aimbot_refs = kurumi.menu.globals.visuals.aimbot_logs:create()
kurumi.menu.globals.visuals.logs_features = kurumi.menu.globals.visuals.aimbot_refs:selectable("", {'Dev', 'Screen', 'Console'}, 0)
kurumi.menu.globals.visuals.gradientcolor2 = kurumi.menu.globals.visuals.aimbot_refs:color_picker("Aimbot Logs Color", color(255, 255, 255, 255))


kurumi.menu.globals.visuals.custom_scope_overlay = kurumi.menu.ui.visuals_main:switch("Custom Scope")
kurumi.menu.globals.visuals.custom_scope_overlay_group = kurumi.menu.globals.visuals.custom_scope_overlay:create()
kurumi.menu.globals.visuals.custom_scope_overlay_line = kurumi.menu.globals.visuals.custom_scope_overlay_group:slider("Line", 0, 100, 60)

kurumi.menu.globals.visuals.custom_scope_overlay_gap = kurumi.menu.globals.visuals.custom_scope_overlay_group:slider("Gap", 0, 100, 5)
kurumi.menu.globals.visuals.custom_scope_overlay_color = kurumi.menu.globals.visuals.custom_scope_overlay_group:color_picker("Color", color(143, 178, 255, 255))

kurumi.menu.globals.visuals.presmoke_warning = kurumi.menu.ui.visuals_main:switch("Presmoke Notify")
--[[kurumi.menu.globals.visuals.presmoke_warning_group = kurumi.menu.globals.visuals.presmoke_warning:create()
kurumi.menu.globals.visuals.presmoke_color = kurumi.menu.globals.visuals.presmoke_warning_group:color_picker("Presmoke Notify Color", color(255, 255, 255, 255))-]]



kurumi.menu.globals.tab.enable_misc = kurumi.menu.ui.visuals_settings:switch(kurumi.menu.create.ovr_misc)
kurumi.menu.globals.tab.aspect_ratio = kurumi.menu.ui.visuals_settings:switch('Aspect Ratio')
kurumi.menu.globals.tab.aspectratio_ref = kurumi.menu.globals.tab.aspect_ratio:create()
kurumi.menu.globals.tab.aspect_ratio_change = kurumi.menu.globals.tab.aspectratio_ref:slider('Value',5,20,13,0.1)

kurumi.menu.globals.tab.trashtalk = kurumi.menu.ui.visuals_settings:switch('Trashtalk')

kurumi.menu.globals.tab.viewmodel =  kurumi.menu.ui.visuals_settings:switch("Viewmodel")
kurumi.menu.globals.tab.viewmodel_group = kurumi.menu.globals.tab.viewmodel:create()
kurumi.menu.globals.tab.viewmodel_fov = kurumi.menu.globals.tab.viewmodel_group:slider("FOV", -100, 100, 68)
kurumi.menu.globals.tab.viewmodel_x = kurumi.menu.globals.tab.viewmodel_group:slider("X", -10, 10, 2.5)
kurumi.menu.globals.tab.viewmodel_y = kurumi.menu.globals.tab.viewmodel_group:slider("Y", -10, 10, 0) 
kurumi.menu.globals.tab.viewmodel_z = kurumi.menu.globals.tab.viewmodel_group:slider("Z", -10, 10, -1.5)

kurumi.menu.globals.tab.notify = kurumi.menu.ui.visuals_settings:switch('Notifications')
kurumi.menu.globals.tab.notify_group = kurumi.menu.globals.tab.notify:create()
kurumi.menu.globals.tab.notify_select = kurumi.menu.globals.tab.notify_group:selectable(" ", {"On damage deal", "Anti-bruteforce"})


kurumi.menu.globals.tab.hitchance_modifier =  kurumi.menu.ui.visuals_settings:switch("Hitchance Modifier")
kurumi.menu.globals.tab.hitchance_modifier_group = kurumi.menu.globals.tab.hitchance_modifier:create()
kurumi.menu.globals.tab.hitchance_modifier_noscope = kurumi.menu.globals.tab.hitchance_modifier_group:slider("Noscope HC", 0, 100, 50)
kurumi.menu.globals.tab.hitchance_modifier_inair = kurumi.menu.globals.tab.hitchance_modifier_group:slider("Inair HC", 0, 100, 40)

kurumi.menu.globals.tab.fastladder =  kurumi.menu.ui.visuals_settings:switch(kurumi.menu.create.beta.."\aC6D1DAFF  Fast Ladder")

--start visuals region#--

-- presmoke notify DO SFIXOWANIA
local screen_size3 = render.screen_size()
presmoke_x = kurumi.menu.ui.visuals_main:slider("x", 1, screen_size3.x, 800)
presmoke_y = kurumi.menu.ui.visuals_main:slider("y", 1, screen_size3.y, 100)
presmoke_x:visibility(false)
presmoke_y:visibility(false)
local presmoke_warningdrag = drag_system.register({presmoke_x, presmoke_y}, vector(240,43), "", function(self)
	local has_smoke = false
    local me = entity.get_local_player()
    if me == nil then return end
    local presmokealpha = math.min(math.floor(math.sin((globals.curtime%3) * 5) * 200 + 255), 255)
    --local presmoke_clr = kurumi.menu.globals.visuals.presmoke_color:get()
    local presmokecolor = color(255, 30, 30, presmokealpha)
    local game_rules = entity.get_game_rules()
    local RoundTime = (game_rules["m_fRoundStartTime"] + game_rules["m_iRoundTime"] - globals.curtime + 1)
    if not game_rules then
      return
    end

	local weapons = me:get_player_weapon(true)
	for _, weapon in ipairs(weapons) do
	    if weapon:get_classname() == "CSmokeGrenade" then
	        	has_smoke = true
	        break
	    end
	end

    if kurumi.menu.globals.visuals.presmoke_warning:get() and kurumi.menu.globals.visuals.enable_visuals:get() then
		if ui.get_alpha() == 0 then
			if me:is_alive() then
				if RoundTime >= 0 and RoundTime <= 20 then
					if has_smoke == true then
						render.text(kurumi.visuals.font.verdanabold, vector(self.position.x + 10, self.position.y + 10), presmokecolor, "", "PRESMOKE NOW: "..(math.floor(RoundTime * 100)/100))
					end
				end
            end
        end
    end
	if ui.get_alpha() == 1 then
		if kurumi.menu.globals.visuals.presmoke_warning:get() and kurumi.menu.globals.visuals.enable_visuals:get() then
			render.text(kurumi.visuals.font.verdanabold, vector(self.position.x + 10, self.position.y + 10), presmokecolor, "", "PRESMOKE NOW: TIME")
			render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color())
		end
	end
end)

-- presmoke notify end


local x, y = render.screen_size().x, render.screen_size().y

local notify=(function() notify_cache={} local a={callback_registered=false,maximum_count=4} 
    function a:set_callback()
        if self.callback_registered then return end; 
        events.render:set(function() 
            local c={x,y} 
            local d={0,0,0} 
            local e=1; 
            local f=notify_cache; 
            for g=#f,1,-1 do 
                notify_cache[g].time=notify_cache[g].time-globals.frametime; 
                local h,i=255,0; 
                local i2 = 0; 
                local lerpy = 150; 
                local lerp_circ1 = 0.5; 
                local j=f[g] 
                if j.time<0 then 
                    table.remove(notify_cache,g) 
                else 
                    local k=j.def_time-j.time; 
                    local k=k>1 and 1 or k; 
                    if j.time<1 or k<1 then 
                        i=(k<1 and k or j.time)/1; 
                        i2=(k<1 and k or j.time)/1; 
                        h=i*255; lerpy=i*150; 
                        lerp_circ1=i*0.5;
                        if i<0.2 then e=e+8*(1.0-i/0.2) end 
                    end; 
                    local m={math.floor(render.measure_text(1, nil, "[Kurumi]  "..j.draw).x*1.03),math.floor(render.measure_text(1, nil, "[Kurumi] "..j.draw).y*1.03)} 
                    local n={render.measure_text(1, nil, "[Kurumi]  ").x,render.measure_text(1, nil, "[Kurumi]  ").y} 
                    local o={render.measure_text(1, nil, j.draw).x,render.measure_text(1, nil, j.draw).y} 
                    local p={c[1]/2-m[1]/2+3,c[2]-c[2]/100*13.4+e}
                    local col = kurumi.menu.globals.visuals.gradientcolor2:get()
                    render.circle_outline(vector(p[1]-1,p[2]-9), color(col.r, col.g, col.b, h>255 and 255 or h), 12, 90, lerp_circ1, 2) 
                    render.circle_outline(vector(p[1]+m[1]+1,p[2]-9), color(col.r, col.g, col.b, h>255 and 255 or h), 12, -90, lerp_circ1, 2)
                    render.rect(vector(p[1]-2, p[2]-21), vector(p[1]-149+m[1]+lerpy, p[2]-19), color(col.r, col.g, col.b, h>255 and 255 or h))
					--render.rect(vector(p[1]-149+m[1]+lerpy, p[2]+3), vector(p[1]-2, p[2]+1), color(col.r, col.g, col.b, h>255 and 255 or h), 0, true)
					render.rect(vector(p[1]+m[1]+1,p[2]+1), vector(p[1]+149-lerpy,p[2]+3), color(col.r, col.g, col.b, h>255 and 255 or h), 0, true)
                    render.text(1, vector(p[1]+m[1]/2-o[1]/2-2,p[2] - 10), color(col.r, col.g, col.b,h), "c", "[Kurumi]")
                    render.text(1, vector(p[1]+m[1]/2+n[1]/2-2,p[2] - 10), color(255, 255, 255,h), "c", j.draw)
                    e=e-33
                end 
            end; 
            self.callback_registered=true 
        end) 
    end;
    function a:push(q,r) 
        local s=tonumber(q)+1; 
        for g=self.maximum_count,2,-1 do 
            notify_cache[g]=notify_cache[g-1] 
        end; 
        notify_cache[1]={time=s,def_time=s,draw=r} 
        self:set_callback()
    end;
    return a 
end) () 

notify:push(4, " Welcome Back \aFFFFFFFF".. kurumi.globals.info.username .."")

kurumi.working_functions.fastladder_init = function(cmd)
    if not kurumi.menu.globals.tab.fastladder:get() and kurumi.menu.globals.tab.enable_misc:get() then return end
    local local_player = entity.get_local_player()
    if local_player == nil then return end

    local pitch = render.camera_angles()
    if local_player["m_MoveType"] == 9 then
        if cmd.forwardmove > 0 then
        if pitch.x < 45 then
            cmd.view_angles.x = 89
            cmd.view_angles.y = cmd.view_angles.y + 89
            cmd.in_moveright = 1
            cmd.in_moveleft = 0
            cmd.in_forward = 0
            cmd.in_back = 1
            if cmd.sidemove == 0 then
                cmd.move_yaw = cmd.move_yaw + 90
            end
            if cmd.sidemove < 0 then
                cmd.move_yaw = cmd.move_yaw + 150
            end
            if cmd.sidemove > 0 then
                cmd.move_yaw = cmd.move_yaw + 30
            end
        end
    end
    
    if cmd.forwardmove < 0 then
        cmd.view_angles.x = 89
        cmd.view_angles.y = cmd.view_angles.y + 89
        cmd.in_moveright = 1
        cmd.in_moveleft = 0
        cmd.in_forward = 1
        cmd.in_back = 0
        if cmd.sidemove == 0 then
            cmd.move_yaw = cmd.move_yaw + 90
        end
        if cmd.sidemove > 0 then
            cmd.move_yaw = cmd.move_yaw + 150
        end
        if cmd.sidemove < 0 then
            cmd.move_yaw = cmd.move_yaw + 30
        end
    end
end
end




kurumi.working_functions.in_air = function()
    local localplayer = entity.get_local_player()
    local b = entity.get_local_player()
        if b == nil then
            return
        end
    local flags = localplayer["m_fFlags"]
 
    if bit.band(flags, 1) == 0 then
        return true
    end
 
    return false
end

events.aim_ack:set(function(e)
    local me = entity.get_local_player()
    local target = entity.get(e.target)
    local damage = e.damage
    local wanted_damage = e.wanted_damage
    local wanted_hitgroup = hitgroup_str[e.wanted_hitgroup]
    local hitchance = e.hitchance
    local state = e.state
    local bt = e.backtrack
    if not target then return end
    if target == nil then return end
    local health = target["m_iHealth"]


    local hitgroup = hitgroup_str[e.hitgroup]

    local col = kurumi.menu.globals.visuals.gradientcolor2:get()
    local color = col:to_hex()

    if kurumi.menu.globals.visuals.aimbot_logs:get() and state == nil and kurumi.menu.globals.visuals.enable_visuals:get()  then
    if not globals.is_connected then return end
    if kurumi.menu.globals.visuals.logs_features:get('Screen') and kurumi.menu.globals.visuals.enable_visuals:get()  then
        notify:push(4, ("Hit %s's \a"..color.."%s for \aA1FF8FFF%d\aFFFFFFFF ("..string.format("%.f", wanted_damage)..") [bt: \aA1FF8FFF%s \aFFFFFFFF| hp: \aA1FF8FFF"..health.."\aFFFFFFFF]"):format(target:get_name(), hitgroup, e.damage, bt))
    end
    if kurumi.menu.globals.visuals.logs_features:get('Console') and kurumi.menu.globals.visuals.enable_visuals:get() then
        print_raw(("\aA9ACFF[KURUMI] \aA0FB87Registered \aD5D5D5shot at %s's %s for \aA0FB87%d("..string.format("%.f", wanted_damage)..") \aD5D5D5damage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
    end
    if kurumi.menu.globals.visuals.logs_features:get('Dev') and kurumi.menu.globals.visuals.enable_visuals:get() then
        print_dev(("[KURUMI] Registered shot at %s's %s for %d("..string.format("%.f", wanted_damage)..") damage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
    end
    elseif kurumi.menu.globals.visuals.aimbot_logs:get() and kurumi.menu.globals.visuals.enable_visuals:get() then
    if kurumi.menu.globals.visuals.logs_features:get('Screen') and kurumi.menu.globals.visuals.enable_visuals:get() then
        notify:push(4, ('Missed \a'..color..'%s \aFFFFFFFFin the %s due to \aE94B4BFF'..state..' \aFFFFFFFF(hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
    end
    if kurumi.menu.globals.visuals.logs_features:get('Console') and kurumi.menu.globals.visuals.enable_visuals:get() then
        print_raw(('\aA9ACFF[KURUMI] \aE94B4BMissed \aFFFFFFshot in %s in the %s due to \aE94B4B'..state..' \aFFFFFF(hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
    end
    if kurumi.menu.globals.visuals.logs_features:get('Dev') and kurumi.menu.globals.visuals.enable_visuals:get() then
        print_dev(('[KURUMI] Missed shot in %s in the %s due to '..state..' (hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
    end
end
end)

events.player_hurt:set(function(e)
    local me = entity.get_local_player()
    local attacker = entity.get(e.attacker, true)
    local weapon = e.weapon
    local type_hit = 'Hit'

    if weapon == 'hegrenade' then 
        type_hit = 'Naded'
    end

    if weapon == 'inferno' then
        type_hit = 'Burned'
    end

    if weapon == 'knife' then 
        type_hit = 'Knifed'
    end

    if weapon == 'hegrenade' or weapon == 'inferno' or weapon == 'knife' then

    if me == attacker then
        local user = entity.get(e.userid, true)
        if kurumi.menu.globals.visuals.aimbot_logs:get() and kurumi.menu.globals.visuals.enable_visuals:get() then
        print_raw(('\aA9ACFF[KURUMI] \aD5D5D5'..type_hit..' %s for %d damage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
        notify:push(4, (''..type_hit..' %s for %d damage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
    end

    end
end
end)

-- solus ui

function lerpx(time,a,b) return a * (1-time) + b * time end

function window(x, y, w, h, name, alpha) 
	local name_size = render.measure_text(1, "", name) 
	local r, g, b = kurumi.menu.globals.visuals.accent_col:get().r, kurumi.menu.globals.visuals.accent_col:get().g, kurumi.menu.globals.visuals.accent_col:get().b
    local r2, g2, b2 = kurumi.menu.globals.visuals.accent_col:get().r, kurumi.menu.globals.visuals.accent_col:get().g, kurumi.menu.globals.visuals.accent_col:get().b

    if kurumi.menu.globals.visuals.solus_combo:get() == 'Modern' then
        render.rect_outline(vector(x - 1, y), vector(x + w + 4, y + h + 1), color(r, g, b, alpha/5), 1, 4)
        render.rect(vector(x + 3, y), vector(x + w, y + 1), color(r2, g2, b2, alpha), 4)
        render.rect(vector(x, y + 1), vector(x + w + 3, y + 16), color(0, 0, 0, alpha/4), 4)
        render.circle_outline(vector(x + 3, y + 4), color(r2, g2, b2, alpha), 4.5, 175, 0.33, 1)
        render.circle_outline(vector(x + w, y + 4), color(r2, g2, b2, alpha), 4.5, 260, 0.30, 1)
        render.gradient(vector(x - 1, y + 2), vector(x, y + h - 4), color(r2, g2, b2, alpha), color(r2, g2, b2, 0), color(r2, g2, b2, alpha/2), color(r2, g2, b2, 0))
        render.gradient(vector(x + w + 3, y + 2), vector(x + w + 4, y + h - 4), color(r2, g2, b2, alpha), color(r2, g2, b2, 0), color(r2, g2, b2, alpha/2), color(r2, g2, b2, 0))
        render.text(1, vector(x+1 + w / 2 + 1 - name_size.x / 2,	y + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
        elseif kurumi.menu.globals.visuals.solus_combo:get() == 'Default'  then
        render.rect(vector(x, y), vector(x + w + 3, y + 2), color(r2, g2, b2, alpha), 4)
        render.rect(vector(x, y + 2), vector(x + w + 3, y + 19), color(0, 0, 0, alpha/4), 0)
        render.text(1, vector(x+1 + w / 2 + 1 - name_size.x / 2,	y + 2 + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
    end
end

local x, y, alphabinds, alpha_k, width_k, width_ka, data_k, width_spec = render.screen_size().x, render.screen_size().y, 0, 1, 0, 0, { [''] = {alpha_k = 0}}, 1

local pos_x = kurumi.menu.globals.visuals.solusui:slider("posx", 0, x, 150)
local pos_y = kurumi.menu.globals.visuals.solusui:slider("posy", 0, y, 150)
local pos_x1 = kurumi.menu.globals.visuals.solusui:slider("posx1", 0, x, 250)
local pos_y1 = kurumi.menu.globals.visuals.solusui:slider("posy1", 0, y, 250)

--@: sowus - keybinds
local new_drag_object = drag_system.register({pos_x, pos_y}, vector(120, 60), "Test", function(self)
    if kurumi.menu.globals.visuals.solusui_selectable:get('Keybinds') and kurumi.menu.globals.visuals.solusui_switch:get() == true and kurumi.menu.globals.visuals.enable_visuals:get() then
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

            if kurumi.menu.globals.visuals.solus_combo:get() == 'Half-rounded' then
                render.text(1, vector(self.position.x+3, self.position.y + 19 + add_y), color(255, data_k[bind.name].alpha_k), '', c_name)

                if c_name == 'Minimum damage' or c_name == 'Ping spike' then
                    render.text(1, vector(self.position.x + (width_ka - bind_state_size.x) - render.measure_text(1, nil, get_value).x + 28, self.position.y + 19 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_value..']')
                else
                    render.text(1, vector(self.position.x + (width_ka - bind_state_size.x - 8), self.position.y + 19 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_mode..']')
                end
            else
                render.text(1, vector(self.position.x+3, self.position.y + 22 + add_y), color(255, data_k[bind.name].alpha_k), '', c_name)

                if c_name == 'Minimum damage' or c_name == 'Ping spike' then
                    render.text(1, vector(self.position.x + (width_ka - bind_state_size.x) - render.measure_text(1, nil, get_value).x + 28, self.position.y + 22 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_value..']')
                else
                    render.text(1, vector(self.position.x + (width_ka - bind_state_size.x - 8), self.position.y + 22 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_mode..']')
                end
            end
            
            add_y = add_y + 16 * data_k[bind.name].alpha_k/255

            --drag
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
            window(self.position.x, self.position.y, width_ka, 16, 'keybinds', alphabinds)
            end
    end
end)

local fnay = render.load_image(network.get("https://avatars.cloudflare.steamstatic.com/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_medium.jpg"), vector(50, 50))

local new_drag_object1 = drag_system.register({pos_x1, pos_y1}, vector(120, 60), "Test2", function(self)
if kurumi.menu.globals.visuals.solusui_switch:get() == true and kurumi.menu.globals.visuals.enable_visuals:get()  then
    if kurumi.menu.globals.visuals.solusui_selectable:get('Spectator list') then
    local width_spec = 120
    if width_spec > 160-11 then
        if width_spec > max_width then
            max_width = width_spec
        end
    end

        if ui.get_alpha() > 0.3 or (ui.get_alpha() > 0.3 and not globals.is_in_game) then window(self.position.x, self.position.y, width_spec, 16, 'spectators', 255) end

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
            name_sub = string.len(name) > 30 and string.sub(name, 0, 30) .. "..." or name;
            local avatar = player_ptr:get_steam_avatar()
            if (avatar == nil or avatar.width <= 5) then avatar = fnay end

            if player_ptr:is_bot() and not player_ptr:is_player() then goto skip end
            render.text(1, vector(self.position.x + 17, self.position.y + 5 + (idx*15)), color(), 'u', name_sub)
            render.texture(avatar, vector(self.position.x + 1, self.position.y + 5 + (idx*15)), vector(12, 12), color(), 'f', 0)
            ::skip::
        end

    
        if #me:get_spectators() > 0 or (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
            window(self.position.x, self.position.y, width_spec, 16, 'spectators', 255)
        end
        
        end
    end
end)


events.mouse_input:set(function()
        if ui.get_alpha() > 0.3 then return false end
end)

-- solus ui end

-- loading shit

local alpha123 = 0
local time = kurumi.menu.globals.tab.anim_switch:get() and math.floor(globals.realtime) or 0

kurumi.working_functions.loading = function()
	local screen = render.screen_size()
	if math.floor(globals.realtime) - time > 3.5 or not kurumi.menu.globals.tab.anim_switch:get() then return end

	if globals.realtime - time > 3.5 then
		alpha123 = math.clamp(alpha123 - 1, 0, 50)
	else
		alpha123 = math.clamp(alpha123 + 1, 0, 50)	
	end

	render.texture(kurumi.menu.globals.tab.gif, vector(screen.x/2.8, screen.y/4), vector(540, 540), color(255, 255, 255, alpha123 * 3.5))

end

-- animation breakers

hook_helper = {
    copy = function(dst, src, len)
    return ffi.copy(ffi.cast('void*', dst), ffi.cast('const void*', src), len)
    end,

    virtual_protect = function(lpAddress, dwSize, flNewProtect, lpflOldProtect)
    return ffi.C.VirtualProtect(ffi.cast('void*', lpAddress), dwSize, flNewProtect, lpflOldProtect)
    end,

    virtual_alloc = function(lpAddress, dwSize, flAllocationType, flProtect, blFree)
    local alloc = ffi.C.VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect)
    if blFree then
        table.insert(buff.free, function()
        ffi.C.VirtualFree(alloc, 0, 0x8000)
        end)
    end
    return ffi.cast('intptr_t', alloc)
end
}

buff = {free = {}}
vmt_hook = {hooks = {}}

function vmt_hook.new(vt)
    local new_hook = {}
    local org_func = {}
    local old_prot = ffi.new('unsigned long[1]')
    local virtual_table = ffi.cast('intptr_t**', vt)[0]

    new_hook.this = virtual_table
    new_hook.hookMethod = function(cast, func, method)
    org_func[method] = virtual_table[method]
    hook_helper.virtual_protect(virtual_table + method, 4, 0x4, old_prot)

    virtual_table[method] = ffi.cast('intptr_t', ffi.cast(cast, func))
    hook_helper.virtual_protect(virtual_table + method, 4, old_prot[0], old_prot)

    return ffi.cast(cast, org_func[method])
end

new_hook.unHookMethod = function(method)
    hook_helper.virtual_protect(virtual_table + method, 4, 0x4, old_prot)
    local alloc_addr = hook_helper.virtual_alloc(nil, 5, 0x1000, 0x40, false)
    local trampoline_bytes = ffi.new('uint8_t[?]', 5, 0x90)

    trampoline_bytes[0] = 0xE9
    ffi.cast('int32_t*', trampoline_bytes + 1)[0] = org_func[method] - tonumber(alloc_addr) - 5

    hook_helper.copy(alloc_addr, trampoline_bytes, 5)
    virtual_table[method] = ffi.cast('intptr_t', alloc_addr)

    hook_helper.virtual_protect(virtual_table + method, 4, old_prot[0], old_prot)
    org_func[method] = nil
end

new_hook.unHookAll = function()
    for method, func in pairs(org_func) do
        new_hook.unHookMethod(method)
    end
end

table.insert(vmt_hook.hooks, new_hook.unHookAll)
    return new_hook
end

events.shutdown:set(function()
    for _, reset_function in ipairs(vmt_hook.hooks) do
        reset_function()
    end
end)

hooked_function = nil
ground_ticks, end_time = 1, 0
function updateCSA_hk(thisptr, edx)
    if entity.get_local_player() == nil or ffi.cast('uintptr_t', thisptr) == nil then return end
    local local_player = entity.get_local_player()
    local lp_ptr = get_entity_address(local_player:get_index())
    if kurumi.menu.globals.antiaim.animation_breakers:get("Follow direction") and kurumi.menu.globals.antiaim.enable_antiaim:get() then
        ffi.cast('float*', lp_ptr+10104)[0] = 1
        kurumi.ref.leg_movement:set('Sliding')
    end
    if kurumi.menu.globals.antiaim.animation_breakers:get("Zero pitch on land") and kurumi.menu.globals.antiaim.enable_antiaim:get() then
        ffi.cast('float*', lp_ptr+10104)[12] = 0
    end
    hooked_function(thisptr, edx)
    if kurumi.menu.globals.antiaim.animation_breakers:get("Static legs in air") and kurumi.menu.globals.antiaim.enable_antiaim:get() then
        ffi.cast('float*', lp_ptr+10104)[6] = 1
    end
    if kurumi.menu.globals.antiaim.animation_breakers:get("Zero pitch on land") and kurumi.menu.globals.antiaim.enable_antiaim:get() then
        if bit.band(entity.get_local_player()["m_fFlags"], 1) == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime  + 1
        end
        if not kurumi.working_functions.in_air() and ground_ticks > 1 and end_time > globals.curtime then
            ffi.cast('float*', lp_ptr+10104)[12] = 0.5
        end
    end
end


function anim_state_hook()
    local local_player = entity.get_local_player()
    if not local_player then return end

    local local_player_ptr = get_entity_address(local_player:get_index())
    if not local_player_ptr or hooked_function then return end
    local C_CSPLAYER = vmt_hook.new(local_player_ptr)
    hooked_function = C_CSPLAYER.hookMethod('void(__fastcall*)(void*, void*)', updateCSA_hk, 224)
end

events.createmove_run:set(anim_state_hook)
-- animation breakers end


kurumi.working_functions.viewmodel_changer = function()
    if kurumi.menu.globals.tab.viewmodel:get() and kurumi.menu.globals.tab.enable_misc:get() then
        cvar.viewmodel_fov:int(kurumi.menu.globals.tab.viewmodel_fov:get(), true)
		cvar.viewmodel_offset_x:float(kurumi.menu.globals.tab.viewmodel_x:get(), true)
		cvar.viewmodel_offset_y:float(kurumi.menu.globals.tab.viewmodel_y:get(), true)
		cvar.viewmodel_offset_z:float(kurumi.menu.globals.tab.viewmodel_z:get(), true)
    else
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
    end
end

kurumi.working_functions.solusui = function()
    if kurumi.menu.globals.visuals.solusui_selectable:get("Watermark") and kurumi.menu.globals.visuals.solusui_switch:get() and kurumi.menu.globals.visuals.enable_visuals:get()  then

    local lp = entity.get_local_player()
	if not lp then return end 
    local x_b, y_b = kurumi.menu.globals.visuals.watermark_x:get(), kurumi.menu.globals.visuals.watermark_y:get()
	local screensize = render.screen_size()
	local x = screensize.x
	local y = screensize.y                                         --
	local clr = kurumi.menu.globals.visuals.uiclr:get()
    local rectgradient = kurumi.menu.globals.visuals.gradientcolor:get()
    local max_width = 0
    local frametime = globals.frametime * 16
    width_ka5 = lerp(frametime,width_ka5,math.max(max_width, 150-11))
    


    local avatar = lp:get_steam_avatar()
	local alpha = math.abs(1 * math.cos(2 * math.pi * (globals.curtime + 3) / 5)) * 255
	local alpha2 = math.abs(1 * math.cos(2 * math.pi * globals.curtime / 5)) * 255
    local anim = render_gradient_text(kurumi.menu.globals.visuals.wm1:get().r, kurumi.menu.globals.visuals.wm1:get().g, kurumi.menu.globals.visuals.wm1:get().b, alpha, 255, 255, 255, 0, string.upper('USER  :  '..common.get_username()..''))
	local anim1 = render_gradient_text(255, 255, 255, 0, kurumi.menu.globals.visuals.wm1:get().r, kurumi.menu.globals.visuals.wm1:get().g, kurumi.menu.globals.visuals.wm1:get().b, alpha2, string.upper('USER  :  '..common.get_username()..''))
    if kurumi.menu.globals.visuals.gradient:get() then
    render.gradient(vector(x_b - 2, y_b - 2  ),  vector(x_b + 125, y_b + 40 ), color(kurumi.menu.globals.visuals.gradientcolor:get().r, kurumi.menu.globals.visuals.gradientcolor:get().g, kurumi.menu.globals.visuals.gradientcolor:get().b, 155), color(kurumi.menu.globals.visuals.gradientcolor:get().r, kurumi.menu.globals.visuals.gradientcolor:get().g, kurumi.menu.globals.visuals.gradientcolor:get().b, 0), color(kurumi.menu.globals.visuals.gradientcolor:get().r, kurumi.menu.globals.visuals.gradientcolor:get().g, kurumi.menu.globals.visuals.gradientcolor:get().b, 155), color(kurumi.menu.globals.visuals.gradientcolor:get().r, kurumi.menu.globals.visuals.gradientcolor:get().g, kurumi.menu.globals.visuals.gradientcolor:get().b, 0), 0)
    end
    render.texture(avatar, vector(x_b + 5, y_b + 3), vector(30, 30), color())
    render.shadow(vector(x_b + 5 , y_b + 3 ), vector(x_b + 35  , y_b + 33), color(255, 255, 255, 200), 15, 0, 0)
    render.text(2, vector(x_b + 40, y_b + 6), color(255, 255, 255, 255), "", string.upper("kurumi"))
    render.text(2, vector(x_b + 40, y_b + 17), clr, "", string.upper("USER  :  "..common.get_username()..""))
    render.text(2, vector(x_b + 40, y_b + 17), color(0, 0, 0), nil, anim)
    render.text(2, vector(x_b + 40, y_b + 17), color(0, 0, 0), nil, anim1)
    render.rect_outline(vector(x_b - 7, y_b - 7 ), vector(x_b + 130, y_b + 45 ), color(255, 255, 255, ui.get_alpha()*255))--]]

    local mouse = ui.get_mouse_position()
        if common.is_button_down(1) and (ui.get_alpha() > 0.9) then
            if mouse.x >= x_b and mouse.y >= y_b and mouse.x <= x_b + 130 and mouse.y <= y_b + 70 or drag2 then
                if not drag2 then
                    drag2 = true
                else
                    kurumi.menu.globals.visuals.watermark_x:set(mouse.x )
                    kurumi.menu.globals.visuals.watermark_y:set(mouse.y )
                end
            end
        else
            drag2 = false
        end
    end
end

function leerp(start, vend, time)
    return start + (vend - start) * time
end

local screen_size = render.screen_size()
local screen_center = screen_size / 2

local custom_scope_positions = {}
local custom_scope_generate = function()
    local line = kurumi.menu.globals.visuals.custom_scope_overlay_line:get() * 4.2
    local gap = kurumi.menu.globals.visuals.custom_scope_overlay_gap:get() * 5.5
    local overlay_color = kurumi.menu.globals.visuals.custom_scope_overlay_color:get()


    
    local hash = tostring(line) .. tostring(gap) .. tostring(overlay_color)
    if not custom_scope_positions[hash] then
        custom_scope_positions[hash] = {}

        -- right
        custom_scope_positions[hash][#custom_scope_positions[hash] + 1] = {
            position = {screen_center + vector(gap + 1, 0), screen_center + vector(line, 1)},
            color = {overlay_color, color(overlay_color.r, overlay_color.g, overlay_color.b, 0), overlay_color, color(overlay_color.r, overlay_color.g, overlay_color.b, 0)}
        }

        -- left
        custom_scope_positions[hash][#custom_scope_positions[hash] + 1] = {
            position = {screen_center - vector(gap, -1), screen_center - vector(line, 0)},
            color = {overlay_color, color(overlay_color.r, overlay_color.g, overlay_color.b, 0), overlay_color, color(overlay_color.r, overlay_color.g, overlay_color.b, 0)}
        }

        -- up
        custom_scope_positions[hash][#custom_scope_positions[hash] + 1] = {
            position = {screen_center - vector(0, gap), screen_center - vector(-1, line)},
            color = {overlay_color, overlay_color, color(overlay_color.r, overlay_color.g, overlay_color.b, 0), color(overlay_color.r, overlay_color.g, overlay_color.b, 0)}
        }

        -- down
        custom_scope_positions[hash][#custom_scope_positions[hash] + 1] = {
            position = {screen_center + vector(0, gap + 1), screen_center + vector(1, line)},
            color = {overlay_color, overlay_color, color(overlay_color.r, overlay_color.g, overlay_color.b, 0), color(overlay_color.r, overlay_color.g, overlay_color.b, 0)}
        }
    end

    return custom_scope_positions[hash]
end

local anim1 = 0
local scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")

kurumi.working_functions.customscope = function()
    local local_player = entity.get_local_player()
    if not local_player then
        return
    end

    if not local_player:is_alive() then
        return
    end
    
    anim1 = local_player.m_bIsScoped and leerp(globals.frametime * 75, anim1, 100) or leerp(globals.frametime * 75, anim1, 0)
    

    
    scope_overlay:override()
    if kurumi.menu.globals.visuals.custom_scope_overlay:get() and kurumi.menu.globals.visuals.enable_visuals:get() then
        scope_overlay:override("Remove All")
        
        local scope_overlay = custom_scope_generate()
        for key, value in pairs(scope_overlay) do
            local color1, color2, color3, color4 = value.color[1], value.color[2], value.color[3], value.color[4]
            color1 = color(color1.r, color1.g, color1.b, color1.a * anim1)
            color2 = color(color2.r, color2.g, color2.b, color2.a * anim1)
            color3 = color(color3.r, color3.g, color3.b, color3.a * anim1)
            color4 = color(color4.r, color4.g, color4.b, color4.a * anim1)
            
            render.gradient(value.position[1], value.position[2], color1, color2, color3, color4)
        end
    end
end


function state()
    if not entity.get_local_player() then return end
    local flags = entity.get_local_player().m_fFlags
    local first_velocity = entity.get_local_player()['m_vecVelocity[0]']
    local second_velocity = entity.get_local_player()['m_vecVelocity[1]']
    local velocity = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
    if bit.band(flags, 1) == 1 then
        if bit.band(flags, 4) == 4 then
            return 4
        else
            if velocity <= 3 then
                return 1
            else
                if ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
                    return 3
                else
                    return 2
                end
            end
        end
    elseif bit.band(flags, 1) == 0 then
        if bit.band(flags, 4) == 4 then
            return 6
        else
            return 5
        end
    end
end


function leerp(time, start, endd)
    return start * (1-time) + endd * time
end

local isMD = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage")
local isBA = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim")
local isSP = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points")
local isDT = ui.find("Aimbot", "Ragebot", "Main", "Double Tap")
local isAP = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist")
local isSW = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
local isHS = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
local isFS = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
local isFD = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")
local scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
kurumi.anim_dt = 0
kurumi.anim_dt_alpha = 0
kurumi.anim_hs = 0
kurumi.anim_hs_alpha = 0
kurumi.anim_ba_alpha = 0
kurumi.anim_sp_alpha = 0
kurumi.anim_fs_alpha = 0
kurumi.anim_scoped = 0
kurumi.lerp_box = 0




kurumi.working_functions.indicatorsy = function()
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    if not kurumi.menu.globals.visuals.indicators2:get() and kurumi.menu.globals.visuals.indicators_type:get() == 'Default' and kurumi.menu.globals.visuals.enable_visuals:get()  then return end

    if kurumi.menu.globals.visuals.indicators2:get() and kurumi.menu.globals.visuals.indicators_type:get() == 'Default' and kurumi.menu.globals.visuals.enable_visuals:get()  then
        local x = render.screen_size().x
        local y = render.screen_size().y
        local local_player = entity.get_local_player()

        --[[local alpha = math.abs(1 * math.cos(3 * math.pi * (globals.curtime + 4) / 10)) * 255
        local alpha2 = math.abs(1 * math.cos(3 * math.pi * globals.curtime / 5)) * 255
        local anim = render_gradient_text(kurumi.menu.globals.visuals.color2:get().r, kurumi.menu.globals.visuals.color2:get().g, kurumi.menu.globals.visuals.color2:get().b, alpha, 255, 255, 255, 0, string.upper('kurumi'))
        local anim2 = render_gradient_text(255, 255, 255, 0, kurumi.menu.globals.visuals.color2:get().r, kurumi.menu.globals.visuals.color2:get().g, kurumi.menu.globals.visuals.color2:get().b, alpha2, string.upper('kurumi'))--]]


        local scoped = local_player.m_bIsScoped
    
if scoped then
kurumi.anim_scoped = leerp(globals.frametime * 8, kurumi.anim_scoped, 40)
else
kurumi.anim_scoped = leerp(globals.frametime * 8, kurumi.anim_scoped, 0)
end

        local indclr = kurumi.menu.globals.visuals.color23:get()

        local ay = 24
        local alpha = math.min(math.floor(math.sin((globals.curtime%3) * 2) * 175+20), 255)

        local eternal_ts = render.measure_text(kurumi.visuals.font.pixel9, nil, "KURUMI")
        render.text(kurumi.visuals.font.pixel9, vector(x/2 - 17 + kurumi.anim_scoped - 16 , y/2+ay-9), color(255, 255, 255, 255), nil, "KURUMI")
        render.text(kurumi.visuals.font.pixel9, vector(x/2 + 17 + kurumi.anim_scoped - 16 , y/2+ay-9), color(indclr.r, indclr.g, indclr.b, alpha+220), nil, "stable")
        render.text(kurumi.visuals.font.pixel9, vector(x/2 + kurumi.anim_scoped, y/2+ay + 6 ), color(255, 255, 255, 255), "c", kurumi.visuals.indicators.states[state()]:upper())
        
        local asadsa = math.min(math.floor(math.sin((rage.exploit:get()%2) *1) * 122), 100)
        

        if isDT:get() then
            kurumi.anim_dt = leerp(globals.frametime * 8, kurumi.anim_dt, 9)
            kurumi.anim_dt_alpha = leerp(globals.frametime * 8, kurumi.anim_dt_alpha, 255)
        else
            kurumi.anim_dt = leerp(globals.frametime * 8, kurumi.anim_dt, 0)
            kurumi.anim_dt_alpha = leerp(globals.frametime * 8, kurumi.anim_dt_alpha, 0)
        end

        
        if isBA:get() == "Force" then
            kurumi.anim_ba_alpha = leerp(globals.frametime * 8, kurumi.anim_ba_alpha, 255)
        else
            kurumi.anim_ba_alpha = leerp(globals.frametime * 8, kurumi.anim_ba_alpha, 128)
        end

        
        if isSP:get() == "Force" then
            kurumi.anim_sp_alpha = leerp(globals.frametime * 8, kurumi.anim_sp_alpha, 255)
        else
            kurumi.anim_sp_alpha = leerp(globals.frametime * 8, kurumi.anim_sp_alpha, 128)
        end

        
        if isFS:get() then
            kurumi.anim_fs_alpha = leerp(globals.frametime * 8, kurumi.anim_fs_alpha, 255)
        else
            kurumi.anim_fs_alpha = leerp(globals.frametime * 8, kurumi.anim_fs_alpha, 128)
        end

            if isDT:get() then
                render.text(kurumi.visuals.font.pixel9, vector(x/2 + kurumi.anim_scoped - 5, y/2+ay + kurumi.anim_dt), rage.exploit:get() == 1 and color(0, 255, 0, kurumi.anim_dt_alpha) or color(255, 0, 0, kurumi.anim_dt_alpha), nil, "DT")
            else
                render.text(kurumi.visuals.font.pixel9, vector(x/2 + kurumi.anim_scoped - 5, y/2+ay + kurumi.anim_dt), rage.exploit:get() == 1 and color(0, 255, 0, kurumi.anim_dt_alpha) or color(255, 0, 0, kurumi.anim_dt_alpha), nil, "DT")
            end

        local ax = 0
        if isHS:get() then
            kurumi.anim_hs = leerp(globals.frametime * 8, kurumi.anim_hs, 9)
            kurumi.anim_hs_alpha = leerp(globals.frametime * 8, kurumi.anim_hs_alpha, 255)
        else
            kurumi.anim_hs = leerp(globals.frametime * 8, kurumi.anim_hs, 0)
            kurumi.anim_hs_alpha = leerp(globals.frametime * 8, kurumi.anim_hs_alpha, 0)
        end
        if isHS:get() then
            render.text(kurumi.visuals.font.pixel9, vector(x/2 + kurumi.anim_scoped - 5, y/2+ay + kurumi.anim_hs + kurumi.anim_dt), color(250, 173, 181, kurumi.anim_hs_alpha), nil, "HS")
        end
        --[[if isAP:get() then
            render.text(kurumi.visuals.font.pixel9, vector(x/2 - 10, y/2+ay), color(255, 255, 255, 255), nil, "PEEK")
            ay = ay + 9
        end--]]

        render.text(kurumi.visuals.font.pixel9, vector(x/2 + kurumi.anim_scoped - 20, y/2+ay + 9 + kurumi.anim_dt+kurumi.anim_hs), color(255, 255, 255, kurumi.anim_ba_alpha), nil, "BA")
        ax = ax + render.measure_text(kurumi.visuals.font.pixel9, nil, "DMG ").x

        render.text(kurumi.visuals.font.pixel9, vector(x/2+ax + kurumi.anim_scoped - 28, y/2+ay + 9 + kurumi.anim_dt+kurumi.anim_hs), color(255, 255, 255, kurumi.anim_sp_alpha), nil, "SP")
        ax = ax + render.measure_text(kurumi.visuals.font.pixel9, nil, "SP ").x

        render.text(kurumi.visuals.font.pixel9, vector(x/2+ax + kurumi.anim_scoped - 30, y/2+ay + 9 + kurumi.anim_dt+kurumi.anim_hs),  color(255, 255, 255, kurumi.anim_fs_alpha), nil, "FS")
        ax = ax + render.measure_text(kurumi.visuals.font.pixel9, nil, "FS ").x
    end

    if kurumi.menu.globals.visuals.indicators2:get() and kurumi.menu.globals.visuals.indicators_type:get() == 'Modern' and kurumi.menu.globals.visuals.enable_visuals:get()  then
        local x = render.screen_size().x
        local y = render.screen_size().y
        local local_player = entity.get_local_player()

        local scoped = local_player.m_bIsScoped
        local color_1 = kurumi.menu.globals.visuals.color23:get()
        local color_2 = kurumi.menu.globals.visuals.color24:get()
        local color_3 = kurumi.menu.globals.visuals.color25:get()
    
        if scoped then
            kurumi.anim_scoped = leerp(globals.frametime * 8, kurumi.anim_scoped, 40)
        else
            kurumi.anim_scoped = leerp(globals.frametime * 8, kurumi.anim_scoped, 0)
        end

        local indclr = kurumi.menu.globals.visuals.color23:get()

        local body_yaw = math.min(math.abs((rage.antiaim:get_max_desync() - rage.antiaim:get_rotation())), 58)
    	local body_yaw2 = body_yaw/2

        kurumi.lerp_box = leerp(globals.frametime * 8, kurumi.lerp_box, body_yaw2)

        render.rect(vector(x/2 + kurumi.anim_scoped - 25, y/2+15), vector(x/2 + kurumi.anim_scoped + 50 - 25, y/2+5+15), color(0,0, 0, 255), 4)


        render.gradient(vector(x/2 + kurumi.anim_scoped - 24, y/2+1+15), vector(x/2 + kurumi.anim_scoped - 15 + kurumi.lerp_box, y/2+4+15), color(color_3.r, color_3.g, color_3.b, 220), color(color_3.r, color_3.g, color_3.b, 0), color(color_3.r, color_3.g, color_3.b, 220), color(color_3.r, color_3.g, color_3.b, 0), 4)
        render.shadow(vector(x/2 + kurumi.anim_scoped - 24, y/2+1+15), vector(x/2 + kurumi.anim_scoped + 50 - 25, y/2+5+15), color(0, 0, 0, 200), 20, 0, 0)
        local ay = 24
        local alpha = math.min(math.floor(math.sin((globals.curtime%3) * 2) * 175+20), 255)

        local eternal_ts = render.measure_text(kurumi.visuals.font.pixel9, nil, "paste")
        local eternal_ts2 = render.measure_text(kurumi.visuals.font.pixel9, nil, "-kurumi-").x
        local eternal_ts3 = render.measure_text(kurumi.visuals.font.pixel9, nil, "DT").x

        
        local gradient_animation = gradient.text_animate("-kurumi-", -2, {
    color(color_1.r,color_1.g,color_1.b), 
    color(color_2.r,color_2.g,color_2.b)
})

        render.text(kurumi.visuals.font.pixel9, vector(x/2 + kurumi.anim_scoped - eternal_ts2/2, y/2+ay-1), color(255, 0, 220), nil, gradient_animation:get_animated_text())
        gradient_animation:animate()
        
        --render.text(kurumi.visuals.font.pixel9, vector(x/2 + 17 + kurumi.anim_scoped - 16 , y/2+ay), color(indclr.r, indclr.g, indclr.b, alpha+220), nil, "stable")
        --render.text(kurumi.visuals.font.pixel9, vector(x/2 + kurumi.anim_scoped, y/2+ay + 6 ), color(255, 255, 255, 255), "c", kurumi.visuals.indicators.states[state()]:upper())
        
        local asadsa = math.min(math.floor(math.sin((rage.exploit:get()%2) *1) * 122), 100)
        

        if isDT:get() then
            kurumi.anim_dt = leerp(globals.frametime * 8, kurumi.anim_dt, 9)
            kurumi.anim_dt_alpha = leerp(globals.frametime * 8, kurumi.anim_dt_alpha, 255)
        else
            kurumi.anim_dt = leerp(globals.frametime * 8, kurumi.anim_dt, 0)
            kurumi.anim_dt_alpha = leerp(globals.frametime * 8, kurumi.anim_dt_alpha, 0)
        end

        
        if isBA:get() == "Force" then
            kurumi.anim_ba_alpha = leerp(globals.frametime * 8, kurumi.anim_ba_alpha, 255)
        else
            kurumi.anim_ba_alpha = leerp(globals.frametime * 8, kurumi.anim_ba_alpha, 128)
        end

        
        if isSP:get() == "Force" then
            kurumi.anim_sp_alpha = leerp(globals.frametime * 8, kurumi.anim_sp_alpha, 255)
        else
            kurumi.anim_sp_alpha = leerp(globals.frametime * 8, kurumi.anim_sp_alpha, 128)
        end

        
        if isFS:get() then
            kurumi.anim_fs_alpha = leerp(globals.frametime * 8, kurumi.anim_fs_alpha, 255)
        else
            kurumi.anim_fs_alpha = leerp(globals.frametime * 8, kurumi.anim_fs_alpha, 128)
        end

            if isDT:get() then
                render.text(kurumi.visuals.font.pixel9, vector(x/2 + kurumi.anim_scoped - eternal_ts3/2, y/2+ay + kurumi.anim_dt), rage.exploit:get() == 1 and color(255, 255, 255, kurumi.anim_dt_alpha) or color(255, 0, 0, kurumi.anim_dt_alpha), nil, "DT")
            else
                render.text(kurumi.visuals.font.pixel9, vector(x/2 + kurumi.anim_scoped - eternal_ts3/2, y/2+ay + kurumi.anim_dt), rage.exploit:get() == 1 and color(255, 255, 255, kurumi.anim_dt_alpha) or color(255, 0, 0, kurumi.anim_dt_alpha), nil, "DT")
            end

        local ax = 0
        if isHS:get() then
            kurumi.anim_hs = leerp(globals.frametime * 8, kurumi.anim_hs, 9)
            kurumi.anim_hs_alpha = leerp(globals.frametime * 8, kurumi.anim_hs_alpha, 255)
        else
            kurumi.anim_hs = leerp(globals.frametime * 8, kurumi.anim_hs, 0)
            kurumi.anim_hs_alpha = leerp(globals.frametime * 8, kurumi.anim_hs_alpha, 0)
        end
        if isHS:get() then
            render.text(kurumi.visuals.font.pixel9, vector(x/2 + kurumi.anim_scoped - eternal_ts3/2, y/2+ay + kurumi.anim_hs + kurumi.anim_dt), color(255, 255, 255, kurumi.anim_hs_alpha), nil, "HS")
        end

        render.text(kurumi.visuals.font.pixel9, vector(x/2+kurumi.anim_scoped - eternal_ts3/2 - 15, y/2+ay + 9 + kurumi.anim_dt+kurumi.anim_hs), color(255, 255, 255, kurumi.anim_ba_alpha), nil, "BA")

        render.text(kurumi.visuals.font.pixel9, vector(x/2+kurumi.anim_scoped - eternal_ts3/2, y/2+ay + 9 + kurumi.anim_dt+kurumi.anim_hs), color(255, 255, 255, kurumi.anim_sp_alpha), nil, "SP")

        render.text(kurumi.visuals.font.pixel9, vector(x/2+kurumi.anim_scoped - eternal_ts3/2 + 15, y/2+ay + 9 + kurumi.anim_dt+kurumi.anim_hs),  color(255, 255, 255, kurumi.anim_fs_alpha), nil, "FS")
    end
end



--end visuals region#--

--start global region#--

kurumi.menu.globals.aspect_ratio = function()
    if not kurumi.menu.globals.tab.enable_misc:get() then return end
    if kurumi.menu.globals.tab.aspect_ratio:get() then
        cvar.r_aspectratio:float(kurumi.menu.globals.tab.aspect_ratio_change:get()/10)
    end

end

local phrases = {
   "最好的 KURUMI.LUA！想击败世界上最好的吗？使用 KURUMI.SYS，您将永远领先对手一步",
   "чертов бот",
   "блядь, иди умывайся",
   "1",
   "ты ебаный аист",
   "оближи мой член и я убью тебя за это время",
   "Я использую KURUMI.SYS и горжусь (`・ω・´)",
   "Ты слышал о КУРУМИ, потому что ты просто лжешь облажался. ლ(ಠ益ಠლ",
   "трахни всю свою семью с тобой на земле",
   "но я трахнул тебя хахахаха",
   "Трахни меня, учись играть",
   "1 собака бля что случилось?",
   "тебе лучше записаться на какой-нибудь класс",
   "почему ты плачешь каждый день?",
   "генетическое и скриптовое доминирование",
   "fucking botik hahahhah! 1",
   "𝕘𝕖𝕥 𝕠𝕨𝕟𝕖𝕕 𝕒𝕟𝕕 𝕤𝕥𝕒𝕪 𝕤𝕒𝕗𝕖 𝕨𝕚𝕥𝕙 𝕜𝕦𝕣𝕦𝕞𝕚",
   "wait who r u??",
   "подожди, как тебя зовут, блядь, без имени?",
   "最好的 KURUMI.LUA！想击败世界上最好的吗？使用 KURUMI.SYS，您将永远领先对手一步",
   "𝕘𝕖𝕥 𝕠𝕨𝕟𝕖𝕕 𝕒𝕟𝕕 𝕤𝕥𝕒𝕪 𝕤𝕒𝕗𝕖 𝕨𝕚𝕥𝕙 𝕜𝕦𝕣𝕦𝕞𝕚",
   "هل تعتقد حقًا أن antiaim 90 درجة كافٍ لـkurumi user?????",
   "𝕚 𝕒𝕞 𝕥𝕠𝕡 𝟙 𝕗𝕠𝕣 𝕞𝕪 𝙛𝙖𝙢𝙞𝙡𝙮 𝕒𝕟𝕕 𝙠𝙪𝙧𝙪𝙢𝙞.𝙡𝙪𝙖",
   "i off ur antiaim with kurumi  (◣_◢)",
   "。。。。我的意思是有kurumi beta的就是300 没kurumi beta的就是600 都是全套啊。。。。",
   "ANGRY CUZ OWNED ? ? ? ? KURUMI BETA。。 kurumi.sbs 操你的屁股",
   "獲取kurumi beta，然後與狗交談",
   "принадлежит вашей собаке по оси бета kurumi.sbs",
   "𝕕𝕚𝕕 𝕦 𝕣𝕝𝕪 𝕥𝕙𝕚𝕟𝕜 𝕦 𝕔𝕒𝕟 𝕜𝕚𝕝𝕝 𝕜𝕦𝕣𝕦𝕞𝕚 𝕦𝕤𝕖𝕣 ?? ?  ? (◣_◢)",
   "𝔀𝓮𝓪𝓴 𝓻𝓪𝓽 𝓸𝔀𝓷𝓮𝓭 𝓯𝓽. 𝓴𝓾𝓻𝓾𝓶𝓲"

}

local function get_phrase()
    return phrases[utils.random_int(1, #phrases)]:gsub('"', '')
end


events.player_death:set(function(e)
    local localplayer = entity.get_local_player()
    local victim = entity.get(e.userid, true)
    
    if kurumi.menu.globals.tab.trashtalk:get() and kurumi.menu.globals.tab.enable_misc:get() then
    local me = entity.get_local_player()
    local attacker = entity.get(e.attacker, true)

    if me == attacker then
        utils.console_exec('say "' .. get_phrase() .. '"')
    end
end
        if victim ~= localplayer then return end

        miss_counter = 0
        shot_time = 0
        if kurumi.menu.globals.tab.notify_select:get(1) and kurumi.menu.globals.tab.notify:get() and kurumi.menu.globals.tab.enable_misc:get() then
        notify:push(4, "Reset due to player death")
    end
end)


--end global region#--

--start anti-brute region#--



--end anti-brute region#--

--start builder region#--


menu_condition = {}
for a, b in pairs(kurumi.antiaim.aa_states2) do
    menu_condition[a] = {
        enable = kurumi.menu.ui.antiaim_builder:switch("Enable " .. kurumi.antiaim.aa_states[a]),
        left_yaw_add = kurumi.menu.ui.antiaim_builder:slider("["..b.."] Left Yaw Add", -180, 180, 0),
        right_yaw_add = kurumi.menu.ui.antiaim_builder:slider("["..b.."] Right Yaw Add", -180, 180, 0),
        yaw_modifier = kurumi.menu.ui.antiaim_builder:combo("["..b.."] Yaw Modifier", aa_refs.yaw_modifier:list()),
        modifier_offset = kurumi.menu.ui.antiaim_builder:slider("["..b.."] Modifier Offset", -180, 180, 0),
        options = kurumi.menu.ui.antiaim_builder:selectable("["..b.."] Options", aa_refs.options:list()),
        desync_freestanding = kurumi.menu.ui.antiaim_builder:combo("["..b.."] Freestanding", aa_refs.desync_freestanding:list()),
        left_limit = kurumi.menu.ui.antiaim_builder:slider("["..b.."] Left Limit", 0, 60, 60),
        right_limit = kurumi.menu.ui.antiaim_builder:slider("["..b.."] Right Limit", 0, 60, 60),
    }
end



get_player_state = function()
    local_player = entity.get_local_player()
    if not local_player then return "Not connected" end
    
    on_ground = bit.band(local_player.m_fFlags, 1) == 1
    jump = bit.band(local_player.m_fFlags, 1) == 0
    crouch = local_player.m_flDuckAmount > 0.7
    fakeduck2 = aa_refs.fakeduck:get()
    vx, vy, vz = local_player.m_vecVelocity.x, local_player.m_vecVelocity.y, local_player.m_vecVelocity.z
    math_velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    move = math_velocity > 5

    if fakeduck2 then return "Fakeduck" end
    if jump and crouch then return "Jump+Crouch" end
    if jump then return "Jump" end
    if crouch then return "Crouch" end
    if on_ground and aa_refs.slowwalk:get() and move then return "Slowwalk" end
    if on_ground and not move then return "Standing" end
    if on_ground and move then return "Running" end
end

kurumi.working_functions.antiaim = function()
    if kurumi.menu.globals.antiaim.enable_antiaim:get() then
    aa_refs.backstab:override(kurumi.menu.globals.antiaim.anti_backstab:get())
    kurumi.ref.dormant_aimbot:override(kurumi.menu.globals.antiaim.dormant_aimbot:get())
    kurumi.ref.freestanding:override(kurumi.menu.globals.antiaim.fress_switch:get())
    kurumi.ref.dsyawfs:override(kurumi.menu.globals.antiaim.fs_switch:get())
    kurumi.ref.bodyfreestanding:override(kurumi.menu.globals.antiaim.fs_switch1:get())
    end
    if kurumi.menu.globals.antiaim.fake_pitch_exploit:get() and kurumi.menu.globals.antiaim.enable_antiaim:get() then
        if globals.tickcount % 11 == math.random(0,1) then
            aa_refs.pitch:set("Fake Up")
            aa_refs.offset:set(0)
            aa_refs.yaw_modifier:set("Offset")
            aa_refs.modifier_offset:set(10)
            aa_refs.left_limit:set(0)
            aa_refs.right_limit:set(0)
            aa_refs.options:set()
        else
            aa_refs.options:set("Jitter")
            aa_refs.pitch:set("Down")
            aa_refs.offset:set(9)
            aa_refs.yaw_modifier:set("Center")
            aa_refs.modifier_offset:set(-68)
            aa_refs.left_limit:set(58)
            aa_refs.right_limit:set(58)
            
        end
    end
    local_player = entity.get_local_player()
    if not local_player then return end
    if kurumi.menu.globals.antiaim.enable_antiaim:get() == false then return end
    if kurumi.menu.globals.antiaim.custom_aa:get() == "Condictional" == false then return end

    invert_state = (math.normalize_yaw(local_player:get_anim_state().eye_yaw - local_player:get_anim_state().abs_yaw) <= 0)

    if menu_condition[2].enable:get() and get_player_state() == "Standing" then aaid = 2
    elseif menu_condition[3].enable:get() and get_player_state() == "Running" then aaid = 3
    elseif menu_condition[4].enable:get() and get_player_state() == "Slowwalk" then aaid = 4
    elseif menu_condition[5].enable:get() and get_player_state() == "Crouch" then aaid = 5
    elseif menu_condition[6].enable:get() and get_player_state() == "Jump" then aaid = 6
    elseif menu_condition[7].enable:get() and get_player_state() == "Jump+Crouch" then aaid = 7 
    elseif menu_condition[8].enable:get() and get_player_state() == "Fakeduck" then aaid = 8
    elseif menu_condition[8].enable:get() and get_player_state() == "Fakelag" then aaid = 9
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

kurumi.working_functions.menu_ui = function()
    menu_condition[1].enable:set(true)
    aa_work = kurumi.menu.globals.antiaim.enable_antiaim:get()
    builder_work = kurumi.menu.globals.antiaim.custom_aa:get() == "Condictional"
    cond_select = kurumi.menu.globals.antiaim.condition:get()
    all_work = aa_work and builder_work
    kurumi.menu.globals.antiaim.condition:visibility(all_work)
    manual_yaw_base:visibility(aa_work)
    
    for a, b in pairs(kurumi.antiaim.aa_states2) do
        need_select = cond_select == kurumi.antiaim.aa_states[a]
        all_work2 = all_work and menu_condition[a].enable:get() and cond_select == kurumi.antiaim.aa_states[a]
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



kurumi.functions.get_config_from_elements = {
    kurumi.menu.globals.antiaim.custom_aa,
    kurumi.menu.globals.antiaim.dormant_aimbot,
    kurumi.menu.globals.antiaim.anti_backstab,
    menu_condition[8].enable,
    menu_condition[8].left_yaw_add,
    menu_condition[8].right_yaw_add,
    menu_condition[8].yaw_modifier,
    menu_condition[8].modifier_offset,
    menu_condition[8].options,
    menu_condition[8].desync_freestanding,
    menu_condition[8].left_limit,
    menu_condition[8].right_limit,
    menu_condition[7].enable,
    menu_condition[7].left_yaw_add,
    menu_condition[7].right_yaw_add,
    menu_condition[7].yaw_modifier,
    menu_condition[7].modifier_offset,
    menu_condition[7].options,
    menu_condition[7].desync_freestanding,
    menu_condition[7].left_limit,
    menu_condition[7].right_limit,
    menu_condition[6].enable,
    menu_condition[6].left_yaw_add,
    menu_condition[6].right_yaw_add,
    menu_condition[6].yaw_modifier,
    menu_condition[6].modifier_offset,
    menu_condition[6].options,
    menu_condition[6].desync_freestanding,
    menu_condition[6].left_limit,
    menu_condition[6].right_limit,
    menu_condition[5].enable,
    menu_condition[5].left_yaw_add,
    menu_condition[5].right_yaw_add,
    menu_condition[5].yaw_modifier,
    menu_condition[5].modifier_offset,
    menu_condition[5].options,
    menu_condition[5].desync_freestanding,
    menu_condition[5].left_limit,
    menu_condition[5].right_limit,
    menu_condition[4].enable,
    menu_condition[4].left_yaw_add,
    menu_condition[4].right_yaw_add,
    menu_condition[4].yaw_modifier,
    menu_condition[4].modifier_offset,
    menu_condition[4].options,
    menu_condition[4].desync_freestanding,
    menu_condition[4].left_limit,
    menu_condition[4].right_limit,
    menu_condition[3].enable,
    menu_condition[3].left_yaw_add,
    menu_condition[3].right_yaw_add,
    menu_condition[3].yaw_modifier,
    menu_condition[3].modifier_offset,
    menu_condition[3].options,
    menu_condition[3].desync_freestanding,
    menu_condition[3].left_limit,
    menu_condition[3].right_limit,
    menu_condition[2].enable,
    menu_condition[2].left_yaw_add,
    menu_condition[2].right_yaw_add,
    menu_condition[2].yaw_modifier,
    menu_condition[2].modifier_offset,
    menu_condition[2].options,
    menu_condition[2].desync_freestanding,
    menu_condition[2].left_limit,
    menu_condition[2].right_limit,
    menu_condition[1].enable,
    menu_condition[1].left_yaw_add,
    menu_condition[1].right_yaw_add,
    menu_condition[1].yaw_modifier,
    menu_condition[1].modifier_offset,
    menu_condition[1].options,
    menu_condition[1].desync_freestanding,
    menu_condition[1].left_limit,
    menu_condition[1].right_limit,
}



kurumi.working_functions.exportconfig = function()
    kurumi.config = {}
    for i = 1, #kurumi.config do
        print(kurumi.config[i])
        kurumi.config[i] = nil
    end

    for i = 1, #kurumi.functions.get_config_from_elements do
        kurumi.config[i] = kurumi.functions.get_config_from_elements[i]:get()
    end

    --clipboard.set(json.stringify(kurumi.config))
    local json_config = json.stringify(kurumi.config)
    local encoded_config = base64.encode(json_config)
    clipboard.set("<kurumi>"..encoded_config)
    utils.console_exec(string.format("playvol buttons/bell1.wav 1"))
    notify:push(4, " Successfully saved your config into clipboard\aA9ACFFFF")
    print("Successfully saved your config into clipboard")
end
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^DO LOADOWANIA CONFIGOW TEN BUTTON NA DOLE^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
kurumi.globals.save = kurumi.menu.ui.antiaim_configs:button("\a".. sidebar_color ..""..kurumi.menu.icon.export .. "\aFFFFFFFF  Export settings", kurumi.working_functions.exportconfig, true)
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


kurumi.working_functions.loadconfig = function()
    local config_clipboard = clipboard.get():gsub("<kurumi>","")
    kurumi.globals.status, kurumi.globals.config = pcall(function() return json.parse(base64.decode(config_clipboard)) end)
    if not kurumi.globals.status then return end
    if not kurumi.globals.config then
        utils.console_exec(string.format("playvol buttons/bell1.wav 1"))
        notify:push(4, " Failed to import config \aA9ACFFFF")
        print("Failed to import config")
    return end
    for i = 1, #kurumi.globals.config do
        kurumi.functions.get_config_from_elements[i]:set(kurumi.globals.config[i])
    end
    utils.console_exec(string.format("playvol buttons/bell1.wav 1"))
    notify:push(4, " Successfully Imported config to clipboard\aA9ACFFFF")
    print("Successfully Imported config to clipboard")
end
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^DO IMPORTOWANIA TEN BUTTON NA DOLE^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
kurumi.globals.load = kurumi.menu.ui.antiaim_configs:button("\a".. sidebar_color .."".. kurumi.menu.icon.import .. "\aFFFFFFFF  Import settings", kurumi.working_functions.loadconfig, true) 
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


kurumi.working_functions.defaultconfig = function()
    kurumi.globals.status, kurumi.globals.config = pcall(function() return json.parse(base64.decode("WyJDb25kaWN0aW9uYWwiLHRydWUsdHJ1ZSx0cnVlLDAuMCwwLjAsIkNlbnRlciIsMC4wLFtdLCJPZmYiLCJEZWZhdWx0IiwiRGlzYWJsZWQiLDYwLjAsNjAuMCx0cnVlLDYuMCwtNi4wLCJDZW50ZXIiLC0yMS4wLFsiSml0dGVyIl0sIk9mZiIsIlN3aXRjaCIsIk9wcG9zaXRlIiw2MC4wLDYwLjAsdHJ1ZSw1LjAsLTUuMCwiQ2VudGVyIiwtNzAuMCxbIkppdHRlciJdLCJPZmYiLCJEZWZhdWx0IiwiT3Bwb3NpdGUiLDYwLjAsNjAuMCx0cnVlLDcuMCwtNy4wLCJDZW50ZXIiLC03NC4wLFsiSml0dGVyIl0sIk9mZiIsIk9wcG9zaXRlIiwiT3Bwb3NpdGUiLDYwLjAsNjAuMCx0cnVlLDcuMCwtNy4wLCJDZW50ZXIiLC0xNy4wLFsiQXZvaWQgT3ZlcmxhcCIsIkppdHRlciJdLCJPZmYiLCJPcHBvc2l0ZSIsIlN3YXkiLDYwLjAsNjAuMCx0cnVlLDcuMCwtNy4wLCJDZW50ZXIiLC0zLjAsWyJBdm9pZCBPdmVybGFwIiwiSml0dGVyIl0sIk9mZiIsIk9wcG9zaXRlIiwiT3Bwb3NpdGUiLDU3LjAsNTcuMCx0cnVlLDQuMCwtNC4wLCJDZW50ZXIiLC03NC4wLFsiSml0dGVyIl0sIk9mZiIsIk9wcG9zaXRlIiwiT3Bwb3NpdGUiLDYwLjAsNjAuMCx0cnVlLDcuMCwtNy4wLCJDZW50ZXIiLC0zMi4wLFsiSml0dGVyIl0sIlBlZWsgRmFrZSIsIk9wcG9zaXRlIiwiT3Bwb3NpdGUiLDYwLjAsNjAuMF0=")) end)
    if not kurumi.globals.status then return end
    if not kurumi.globals.config then
        utils.console_exec(string.format("playvol buttons/bell1.wav 1"))
        notify:push(4, " Failed to import default config\aA9ACFFFF")
        print("Failed to import default config")
    return end
    for i = 1, #kurumi.globals.config do
        kurumi.functions.get_config_from_elements[i]:set(kurumi.globals.config[i])
    end
    utils.console_exec(string.format("playvol buttons/bell1.wav 1"))
    notify:push(4, " Successfully loaded default config \aA9ACFFFF")
    print("Successfully loaded default config")
end
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^DO DEFAULTCOFNIGU TEN BUTTON NA DOLE^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
kurumi.globals.discord = kurumi.menu.ui.antiaim_configs:button("\a".. sidebar_color .."".. kurumi.menu.icon.default .. "\aFFFFFFFF  Default settings", kurumi.working_functions.defaultconfig, true)
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--end builder region#--

--start visiblity region#--
kurumi.working_functions.menu_visiblity = function()

    kurumi.menu.globals.antiaim.custom_aa:visibility(kurumi.menu.globals.antiaim.enable_antiaim:get())
    kurumi.globals.save:visibility(kurumi.menu.globals.antiaim.enable_antiaim:get())
    kurumi.globals.load:visibility(kurumi.menu.globals.antiaim.enable_antiaim:get())
    kurumi.globals.discord:visibility(kurumi.menu.globals.antiaim.enable_antiaim:get())
    --load_def_config:visibility(kurumi.menu.globals.antiaim.enable_antiaim:get())
    kurumi.menu.globals.antiaim.fress_switch:visibility(kurumi.menu.globals.antiaim.enable_antiaim:get())
    kurumi.menu.globals.antiaim.anti_backstab:visibility(kurumi.menu.globals.antiaim.enable_antiaim:get())
    kurumi.menu.globals.antiaim.dormant_aimbot:visibility(kurumi.menu.globals.antiaim.enable_antiaim:get())
    kurumi.menu.globals.antiaim.fake_pitch_exploit:visibility(kurumi.menu.globals.antiaim.enable_antiaim:get())
    kurumi.menu.globals.antiaim.animation_breakers:visibility(kurumi.menu.globals.antiaim.enable_antiaim:get())

    kurumi.menu.globals.visuals.solusui_switch:visibility(kurumi.menu.globals.visuals.enable_visuals:get())

    kurumi.menu.globals.visuals.presmoke_warning:visibility(kurumi.menu.globals.visuals.enable_visuals:get())

    kurumi.menu.globals.visuals.watermark_x:visibility(false)
    kurumi.menu.globals.visuals.watermark_y:visibility(false)

    kurumi.menu.globals.visuals.gradient:visibility(kurumi.menu.globals.visuals.solusui_selectable:get('Watermark') and kurumi.menu.globals.visuals.solusui_switch:get())
    kurumi.menu.globals.visuals.uiclr:visibility(kurumi.menu.globals.visuals.solusui_selectable:get('Watermark') and kurumi.menu.globals.visuals.solusui_switch:get())
    kurumi.menu.globals.visuals.wm1:visibility(kurumi.menu.globals.visuals.solusui_selectable:get('Watermark') and kurumi.menu.globals.visuals.solusui_switch:get())
    kurumi.menu.globals.visuals.gradientcolor:visibility(kurumi.menu.globals.visuals.gradient:get() and kurumi.menu.globals.visuals.solusui_switch:get() and kurumi.menu.globals.visuals.solusui_selectable:get('Watermark'))

    kurumi.menu.globals.visuals.custom_scope_overlay:visibility(kurumi.menu.globals.visuals.enable_visuals:get())

    kurumi.menu.globals.visuals.custom_scope_overlay_line:visibility(kurumi.menu.globals.visuals.custom_scope_overlay:get())
    kurumi.menu.globals.visuals.custom_scope_overlay_gap:visibility(kurumi.menu.globals.visuals.custom_scope_overlay:get())
    kurumi.menu.globals.visuals.custom_scope_overlay_color:visibility(kurumi.menu.globals.visuals.custom_scope_overlay:get())

    kurumi.menu.globals.visuals.solusui_selectable:visibility(kurumi.menu.globals.visuals.solusui_switch:get())
    kurumi.menu.globals.visuals.label:visibility(kurumi.menu.globals.visuals.solusui_switch:get())

    kurumi.menu.globals.visuals.indicators2:visibility(kurumi.menu.globals.visuals.enable_visuals:get())
    kurumi.menu.globals.visuals.color23:visibility(kurumi.menu.globals.visuals.indicators2:get())
    kurumi.menu.globals.visuals.indicators_type:visibility(kurumi.menu.globals.visuals.indicators2:get())


    
    kurumi.menu.globals.tab.aspect_ratio:visibility(kurumi.menu.globals.tab.enable_misc:get())
    kurumi.menu.globals.tab.aspect_ratio_change:visibility( kurumi.menu.globals.tab.aspect_ratio:get() and kurumi.menu.globals.tab.enable_misc:get())
    kurumi.menu.globals.tab.trashtalk:visibility(kurumi.menu.globals.tab.enable_misc:get())
    kurumi.menu.globals.tab.notify:visibility(kurumi.menu.globals.tab.enable_misc:get())
    kurumi.menu.globals.tab.notify_select:visibility(kurumi.menu.globals.tab.notify:get())
    
    kurumi.menu.globals.tab.viewmodel:visibility(kurumi.menu.globals.tab.enable_misc:get())
    kurumi.menu.globals.tab.viewmodel_fov:visibility(kurumi.menu.globals.tab.viewmodel:get())
    kurumi.menu.globals.tab.viewmodel_x:visibility(kurumi.menu.globals.tab.viewmodel:get())
    kurumi.menu.globals.tab.viewmodel_y:visibility(kurumi.menu.globals.tab.viewmodel:get())
    kurumi.menu.globals.tab.viewmodel_z:visibility(kurumi.menu.globals.tab.viewmodel:get())

    kurumi.menu.globals.visuals.aimbot_logs:visibility(kurumi.menu.globals.visuals.enable_visuals:get())
    kurumi.menu.globals.visuals.logs_features:visibility(kurumi.menu.globals.visuals.aimbot_logs:get())
    kurumi.menu.globals.visuals.gradientcolor2:visibility(kurumi.menu.globals.visuals.aimbot_logs:get())

    kurumi.menu.globals.tab.fastladder:visibility(kurumi.menu.globals.tab.enable_misc:get())

    kurumi.menu.globals.tab.global_label2:visibility(kurumi.menu.globals.tab.language:get() == 'English' == true)
    kurumi.menu.globals.tab.global_label3:visibility(kurumi.menu.globals.tab.language:get() == 'Russian' == true)

    kurumi.menu.globals.visuals.color25:visibility(kurumi.menu.globals.visuals.indicators2:get() and kurumi.menu.globals.visuals.indicators_type:get() == 'Modern' and kurumi.menu.globals.visuals.enable_visuals:get())
    kurumi.menu.globals.visuals.color24:visibility(kurumi.menu.globals.visuals.indicators2:get() and kurumi.menu.globals.visuals.indicators_type:get() == 'Modern' and kurumi.menu.globals.visuals.enable_visuals:get())

    kurumi.menu.globals.tab.hitchance_modifier:visibility(kurumi.menu.globals.tab.enable_misc:get())
    kurumi.menu.globals.tab.hitchance_modifier_noscope:visibility(kurumi.menu.globals.tab.hitchance_modifier:get() and kurumi.menu.globals.tab.enable_misc:get())
    kurumi.menu.globals.tab.hitchance_modifier_inair:visibility(kurumi.menu.globals.tab.hitchance_modifier:get() and kurumi.menu.globals.tab.enable_misc:get())

    pos_x:visibility(false)
    pos_y:visibility(false)
    pos_x1:visibility(false)
    pos_y1:visibility(false)
    kurumi.menu.globals.visuals.accent_col:visibility(kurumi.menu.globals.visuals.solusui_selectable:get('Keybinds') or kurumi.menu.globals.visuals.solusui_selectable:get('Spectator list'))
    kurumi.menu.globals.visuals.solus_combo:visibility(kurumi.menu.globals.visuals.solusui_selectable:get('Keybinds') or kurumi.menu.globals.visuals.solusui_selectable:get('Spectator list'))

end


--end visiblity region#--




--start callbacks region#--

on_render = function()
    kurumi.working_functions.antiaim()
    kurumi.working_functions.menu_ui()
    kurumi.working_functions.menu_visiblity()
    kurumi.working_functions.indicatorsy()
    kurumi.menu.globals.aspect_ratio()
    kurumi.working_functions.solusui()
    kurumi.working_functions.customscope()
    if globals.realtime > 60 then kurumi.working_functions.loading() end
    kurumi.working_functions.viewmodel_changer()
    new_drag_object:update()
    new_drag_object1:update()
    presmoke_warningdrag:update()
end

events.createmove:set(function(cmd)
    kurumi.working_functions.fastladder_init(cmd)
end)

events.round_start:set(function(e)
    miss_counter = 0
    shot_time = 0
    if kurumi.menu.globals.tab.notify_select:get(2) and kurumi.menu.globals.tab.notify:get() and kurumi.menu.globals.tab.enable_misc:get() then
        notify:push(4, "New round start")
    end
end)

events.shutdown:set(function()
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
end)


events.render:set(on_render)