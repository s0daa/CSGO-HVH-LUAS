-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local clipboard = require("neverlose/clipboard")
local base64 = require("neverlose/base64")
local aa_library = require("neverlose/anti_aim")
local gradient = require("neverlose/gradient")
local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet'

ffi.cdef[[
    
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);

]]

local mainInfo = ui.create("Main", "Info")
local build = "Alpha"

local buildType = mainInfo:label("Build Type: " .. build)
local version = "2.1"
local versionText = mainInfo:label("Version: " .. version)
local username = common.get_username()
local thx = mainInfo:label("Thanks for using Gadz0.YAW. If you need help with anything join discord server https://discord.gg/P7E6BVZmvB or dm me on discord Adrian HvH#8326")
print_dev("Welcome to Gadz0.YAW " .. username .. " make sure to join our discord server")

print_raw("\n\n")
print_raw(' $$$$$$\\                  $$\\            $$$$$$\\  $$\\     $$\\  $$$$$$\\  $$\\      $$\\ ')
print_raw("$$  __$$\\                 $$ |          $$$ __$$\\ \\$$\\   $$  |$$  __$$\\ $$ | $\\  $$ |")
print_raw("$$ /  \\__| $$$$$$\\   $$$$$$$ |$$$$$$$$\\ $$$$\\ $$ | \\$$\\ $$  / $$ /  $$ |$$ |$$$\\ $$ |")
print_raw("$$ |$$$$\\  \\____$$\\ $$  __$$ |\\____$$  |$$\\$$\\$$ |  \\$$$$  /  $$$$$$$$ |$$ $$ $$\\$$ |")
print_raw("$$ |\\_$$ | $$$$$$$ |$$ /  $$ |  $$$$ _/ $$ \\$$$$ |   \\$$  /   $$  __$$ |$$$$  _$$$$ |")
print_raw("$$ |  $$ |$$  __$$ |$$ |  $$ | $$  _/   $$ |\\$$$ |    $$ |    $$ |  $$ |$$$  / \\$$$ |")
print_raw("\\$$$$$$  |\\$$$$$$$ |\\$$$$$$$ |$$$$$$$$\\ \\$$$$$$  /$$\\ $$ |    $$ |  $$ |$$  /   \\$$ |")
print_raw(" \\______/  \\_______| \\_______|\\________| \\______/ \\__|\\__|    \\__|  \\__|\\__/     \\__|")
print_raw("\n\n\n\nWelcome to Gadz0.YAW " .. username .. " make sure to join our discord server https://discord.gg/P7E6BVZmvB")
print_raw("\n\nLUA Version: " .. version)
print_raw("\n\nBuild type: " .. build)

local Download = function(from, to)
    wininet.DeleteUrlCacheEntryA(from)
    urlmon.URLDownloadToFileA(nil, from, to, 0,0)
end

local downloadFont = mainInfo:button("Download indicators font", function()
    files.create_folder("nl\\gadzoyaw\\")
    files.create_folder("nl\\gadzoyaw\\fonts\\")
    Download("https://cdn.discordapp.com/attachments/839906710507880541/1019654524169900163/pixel.ttf", "nl\\gadzoyaw\\fonts\\pixel.ttf")
end)

local openAPI = panorama.Open
local dc = mainInfo:button("Join our discord server", function()
    openAPI.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/P7E6BVZmvB")
end)

local ytlink =  mainInfo:button("Coder's youtube channel", function()
    openAPI.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/channel/UCbp8SapboV7r6u3ychZHdYQ")
end)

local mainChangelog = ui.create("Main", "Changelog")

local changelog = mainChangelog:label("20/09/2022\n[/] Some visual changes\n[/] Optimized code for better performance\n\n17/09/2022\n[+] Added Gadz0 anti-aim preset\n\n15/09/2022\n[/] Some minor changes in watermark\n[/] Fixed some bugs in acatel indicators\n\n14/09/2022\n[*] Updated LUA to v2\n[*] Renamed LUA to Gadz0.YAW\n[*] Improved info panel\n[/] Fixed Config Manager not appearing in menu when user is not joined in server\n[+] Added Custom Scope Lines\n\n09/09/2022\n[+] Added Solus UI\n[+] Added Conditional AA\n[/] Fixed some bugs in indicators\n\n04/09/2022\n[+] Added Animation Breakers\n[/] Fixed some bugs\n\n03/09/2022\n[+] Added Gadz0 Indicators\n[+] Added Info Panel\n[+] Readded Instant DT recharge\n\n02/09/2022\n[+] Added gamesense style Hit/Miss logs\n[+] Added Minimum Damage Indicator\n\n01/09/2022\n[/] Fixed leg fucker and crashes\n\n01/09/2022\n[/] Fixed crashes that happened when joining server with enabled indicators\n\n31/08/2022\n[+] Added Aspect ratio changer \n[+] Readded Indicators with improvments \n[+] Added config manager \n\n30/08/2022\n[+] Reworked lua for NL V3 update")

ui.sidebar(gradient.text("Gadz0.YAW [" .. string.lower(build) .. "]", false,{ color(0, 255, 191), color(50, 125, 205)}), "satellite-dish")

local player = entity.get_local_player()
local verdana = render.load_font("Verdana", 12)
verdanar11 = render.load_font('Verdana', 11)

local LeftLimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit")
local old_LeftLimit = LeftLimit:get()
local RightLimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit")
local old_RightLimit = RightLimit:get()
local pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch")
local old_pitch = pitch:get()
local FakeOptions = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options")
local freestandingDesync = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
local DesyncOnShot = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "On Shot")
local LBYMode = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "LBY Mode")
local YawMod = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier")
local ModDeg = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")
local flLimit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit")
local YawAdd = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset")
local YawBase = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base")
local old_YawBase = YawBase:get()
local BodyYaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw")
local Yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw")

local isMD = ui.find("Aimbot", "Ragebot", "Selection", "Minimum Damage")
local isBA = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim")
local isSP = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points")
local isDT = ui.find("Aimbot", "Ragebot", "Main", "Double Tap")
local isAP = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist")
local isSW = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
local isHS = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
local isFS = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
local isFD = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")

-- AA SECTION
local AAMain = ui.create("Anti-Aim", "Main")
local AAMasterSwitch = AAMain:switch(gradient.text("Enable anti-aim modifications", false, {color(0, 255, 191), color(50, 125, 205)}), false)

local AAMode = AAMain:combo("Anti-Aim Modes", {"Static Low Delta", "Static High Delta", "Jitter Low Delta", "Jitter High Delta", "Gadz0", "Custom"}, 0)
local conditions = AAMain:combo("Conditions", {"Stand", "Move", "Air", "Air Crouching", "Crouch", "Slow-walk"}, 0)


local AAModeSettings = AAMode:create()
local AALegFucker = AAModeSettings:switch("Leg Fucker", false)

local ui_callback = function()
    local new_state = AAMasterSwitch:get()
    AAMode:set_visible(new_state)
end

ui_callback()

AAMasterSwitch:set_callback(ui_callback)

local ui_callback = function()
    local new_state = AAMode:get("Custom")
    conditions:set_visible(new_state)
end

ui_callback()

AAMode:set_callback(ui_callback)

local conditions_short = {"[S]", "[M]", "[A]", "[A-C]", "[C]", "[SW]"}
local custom_aa = {}
local custom_aa2 = {}

local conditional_aa = ui.create("Anti-Aim", "Main")

for i = 1, 6 do
    custom_aa[i] = {
        yaw_type = conditional_aa:combo(string.format("%s Yaw", conditions_short[i]), {"Disabled", "Backward", "Static"}),
        yaw_modifier = conditional_aa:combo(string.format("%s Yaw Modifier", conditions_short[i]), {"Disabled", "Center", "Offset", "Random", "Spin"}), 
        body_yaw = conditional_aa:switch(string.format("%s Body Yaw", conditions_short[i])),
    }
end

for i = 1, 6 do
    yaw_type_ref = custom_aa[i].yaw_type:create()
    yaw_modifier_ref = custom_aa[i].yaw_modifier:create()
    body_yaw_ref = custom_aa[i].body_yaw:create()

    custom_aa2[i] = {
        base = yaw_type_ref:combo("Base", {"Local View", "At Target"}),
        offset = yaw_type_ref:slider("Offset", -180, 180, 0),
        modifier_offset = yaw_modifier_ref:slider("Offset", -180, 180, 0),
        left_limit = body_yaw_ref:slider("Left Limit", 0, 60, 0),
        right_limit = body_yaw_ref:slider("Right Limit", 0, 60, 0),
        options = body_yaw_ref:selectable("Options", {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti-Bruteforce"}),
        freestanding = body_yaw_ref:combo("Freestanding", {"Off", "Peek Fake", "Peek Real"}),
        onshot = body_yaw_ref:combo("On-Shot", {"Default", "Opposite", "Freestanding", "Switch"}),
        lby_mode = body_yaw_ref:combo("LBY Mode", {"Disabled", "Opposite", "Sway"}),
    }
end

condition_get = function()
    if conditions:get() == "Stand" then
        return 1
    end
    if conditions:get() == "Move" then
        return 2
    end
    if conditions:get() == "Air" then
        return 3
    end
    if conditions:get() == "Air Crouching" then
        return 4
    end
    if conditions:get() == "Crouch" then
        return 5
    end
    if conditions:get() == "Slow-walk" then
        return 6
    end
end

events.render:set(function()
    conditions:set_visible(AAMasterSwitch:get() and AAMode:get() == "Custom")

    current_condition = condition_get()
    for i = 1, 6 do
        custom_aa[i].yaw_type:set_visible(AAMasterSwitch:get() and AAMode:get() == "Custom" and current_condition == i)
        custom_aa[i].yaw_modifier:set_visible(AAMasterSwitch:get() and AAMode:get() == "Custom" and current_condition == i)
        custom_aa[i].body_yaw:set_visible(AAMasterSwitch:get() and AAMode:get() == "Custom" and current_condition == i)
    end
end)

velocity = function(ent)
    local speed = vector(ent["m_vecVelocity[0]"], ent["m_vecVelocity[1]"], ent["m_vecVelocity[2]"]):length2d()
    return speed
end

function AAHelpers_fun()
    
    if AAMasterSwitch:get() then
        if AAMode:get() == "Static Low Delta" then
            YawMod:set("Disabled")
            FakeOptions:set("Avoid Overlap", "Anti Bruteforce")
            LeftLimit:set(12)
            RightLimit:set(15)
        end

        if AAMode:get() == "Static High Delta" then
            YawMod:set("Disabled")
            FakeOptions:set("Avoid Overlap", "Anti Bruteforce")
            LeftLimit:set(58)
            RightLimit:set(54)
        end

        if AAMode:get() == "Jitter Low Delta" then
            YawMod:set("Center")
            ModDeg:set(15)
            FakeOptions:set("Avoid Overlap", "Jitter", "Anti Bruteforce")
            LeftLimit:set(12)
            RightLimit:set(15)
            Yaw:set("Backwards")
        end

        if AAMode:get() == "Jitter High Delta" then
            YawMod:set("Center")
            ModDeg:set(15)
            FakeOptions:set("Avoid Overlap", "Jitter", "Anti Bruteforce")
            LeftLimit:set(58)
            RightLimit:set(54)
        end
    end
end

function legfucker()
    if AAMasterSwitch:get() then
        if(AALegFucker:get() == false) then return end
        local leg = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        leg1 = math.random(1, 2)
        if leg1 == 1 then
            leg:set("Sliding")
        elseif leg1 == 2 then
            leg:set("Walking")
        end
    end
end

events.createmove:set(AAHelpers_fun)
events.createmove:set(legfucker)
events.createmove:set(function()
    local localplayer = entity.get_local_player()
    if not AAMasterSwitch:get() or not AAMode:get() == "Custom" then return end
    if AAMasterSwitch:get() and AAMode:get() == "Custom" then
        if localplayer == nil then return end
        if bit.band(localplayer.m_fFlags, bit.lshift(1,0)) == 0 and localplayer.m_flDuckAmount > 0.8 then
            stateid = 4
            aastate = "AIR"
        elseif ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
            stateid = 6
            aastate = "SHIFT"
        elseif bit.band(localplayer.m_fFlags, bit.lshift(1,0)) == 0  then
            stateid = 3
            aastate = "AIR"
        elseif localplayer.m_flDuckAmount > 0.8 or ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get() then
            stateid = 5
            aastate = "DUCK"
        elseif velocity(localplayer) > 2 then
            stateid = 2
            aastate = "MOV"
        elseif velocity(localplayer) < 2 then 
            stateid = 1 
            aastate = "STAND"
        end

        Cheat_refs = {
            yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
            yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
            yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
            yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
            modifier_degree = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
            body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
            left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
            right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
            options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
            freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
            on_shot = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "On Shot"),
            lby_mode = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "LBY Mode"),
        }

        Cheat_refs.yaw:set(custom_aa[stateid].yaw_type:get())
        Cheat_refs.yaw_base:set(custom_aa2[stateid].base:get())
        Cheat_refs.yaw_offset:set(custom_aa2[stateid].offset:get())
        Cheat_refs.yaw_modifier:set(custom_aa[stateid].yaw_modifier:get())
        Cheat_refs.modifier_degree:set(custom_aa2[stateid].modifier_offset:get())
        Cheat_refs.body_yaw:set(custom_aa[stateid].body_yaw:get())
        Cheat_refs.left_limit:set(custom_aa2[stateid].left_limit:get())
        Cheat_refs.right_limit:set(custom_aa2[stateid].right_limit:get())
        Cheat_refs.options:set(custom_aa2[stateid].options:get())
        Cheat_refs.freestanding:set(custom_aa2[stateid].freestanding:get())
        Cheat_refs.on_shot:set(custom_aa2[stateid].onshot:get())
        Cheat_refs.lby_mode:set(custom_aa2[stateid].lby_mode:get())
    end
end)



events.createmove:set(function()
    local localplayer = entity.get_local_player()
    if not AAMasterSwitch:get() or not AAMode:get() == "Gadz0" then return end
    if AAMasterSwitch:get() and AAMode:get() == "Gadz0" then
        if localplayer == nil then return end
        if bit.band(localplayer.m_fFlags, bit.lshift(1,0)) == 0 and localplayer.m_flDuckAmount > 0.8 then
            stateid = 4
            aastate = "AIR"
        elseif ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
            stateid = 6
            aastate = "SHIFT"
        elseif bit.band(localplayer.m_fFlags, bit.lshift(1,0)) == 0  then
            stateid = 3
            aastate = "AIR"
        elseif localplayer.m_flDuckAmount > 0.8 or ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get() then
            stateid = 5
            aastate = "DUCK"
        elseif velocity(localplayer) > 2 then
            stateid = 2
            aastate = "MOV"
        elseif velocity(localplayer) < 2 then 
            stateid = 1 
            aastate = "STAND"
        end

        Cheat_refs = {
            yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
            yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
            yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
            yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
            modifier_degree = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
            body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
            left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
            right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
            options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
            freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
            on_shot = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "On Shot"),
            lby_mode = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "LBY Mode"),
        }

        local preset = {
            [1] = {
                yaw = "Backwards",
                yaw_base = "At Target",
                yaw_offset = 0,
                yaw_modifier = "Center",
                modifier_degree = 51,
                body_yaw = true,
                left_limit = 46,
                right_limit = 49,
                options = "Jitter",
                freestanding = "Off",
                on_shot = "Default",
                lby_mode = "Opposite"
            },

            [2] = {
                yaw = "Backwards",
                yaw_base = "At Target",
                yaw_offset = 3,
                yaw_modifier = "Center",
                modifier_degree = 23,
                body_yaw = true,
                left_limit = 60,
                right_limit = 60,
                options = {"Avoid Overlap", "Jitter"},
                freestanding = "Peek Fake",
                on_shot = "Default",
                lby_mode = "Opposite"
            },

            [3] = {
                yaw = "Backwards",
                yaw_base = "At Target",
                yaw_offset = 0,
                yaw_modifier = "Disabled",
                modifier_degree = 0,
                body_yaw = true,
                left_limit = 33,
                right_limit = 38,
                options = {"Avoid Overlap", "Anti-Bruteforce"},
                freestanding = "Off",
                on_shot = "Default",
                lby_mode = "Sway"
            },

            [4] = {
                yaw = "Backwards",
                yaw_base = "At Target",
                yaw_offset = 0,
                yaw_modifier = "Center",
                modifier_degree = 7,
                body_yaw = true,
                left_limit = 50,
                right_limit = 54,
                options = {"Avoid Overlap", "Jitter", "Anti-Bruteforce"},
                freestanding = "Off",
                on_shot = "Switch",
                lby_mode = "Opposite"
            },

            [5] = {
                yaw = "Backwards",
                yaw_base = "At Target",
                yaw_offset = -5,
                yaw_modifier = "Center",
                modifier_degree = 10,
                body_yaw = true,
                left_limit = 60,
                right_limit = 60,
                options = {"Avoid Overlap", "Jitter"},
                freestanding = "Off",
                on_shot = "Default",
                lby_mode = "Opposite"
            },

            [6] = {
                yaw = "Backwards",
                yaw_base = "At Target",
                yaw_offset = 0,
                yaw_modifier = "Center",
                modifier_degree = 43,
                body_yaw = true,
                left_limit = 40,
                right_limit = 48,
                options = {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti-bruteforce"},
                freestanding = "Peek Fake",
                on_shot = "Opposite",
                lby_mode = "Sway"
            }
        }

        Cheat_refs.yaw:set(preset[stateid].yaw)
        Cheat_refs.yaw_base:set(preset[stateid].yaw_base)
        Cheat_refs.yaw_offset:set(preset[stateid].yaw_offset)
        Cheat_refs.yaw_modifier:set(preset[stateid].yaw_modifier)
        Cheat_refs.modifier_degree:set(preset[stateid].modifier_degree)
        Cheat_refs.body_yaw:set(preset[stateid].body_yaw)
        Cheat_refs.left_limit:set(preset[stateid].left_limit)
        Cheat_refs.right_limit:set(preset[stateid].right_limit)
        Cheat_refs.options:set(preset[stateid].options)
        Cheat_refs.freestanding:set(preset[stateid].freestanding)
        Cheat_refs.on_shot:set(preset[stateid].on_shot)
        Cheat_refs.lby_mode:set(preset[stateid].lby_mode)
    end
end)

-- FAKELAG
local AAFl = ui.create("Anti-Aim", "Fake-Lag")
local flMasterSwitch = AAFl:switch(gradient.text("Enable Gadz0 Fake-Lag", false, {color(0, 255, 191), color(50, 125, 205)}), false)
local flLimit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit")

local function gadzo_fakelag()
    if flMasterSwitch:get() then
        flLimit:set(math.random(11, 14))
    end
end

events.createmove:set(gadzo_fakelag)

local OtherRage = ui.create("Other", "Ragebot")

-- Ragebot
local rageMasterSwitch = OtherRage:switch(gradient.text("Ragebot Masterswitch", false, {color(0, 255, 191), color(50, 125, 205)}), false)

local dtDisableCorrection = OtherRage:switch("Disable Double Tap Correction", false)
local dtInstantRecharge = OtherRage:switch("Instant DT recharge", false)
local gsLog = OtherRage:switch("GS Logs", false)

local ui_callback = function()
    local new_state = rageMasterSwitch:get()
    dtDisableCorrection:set_visible(new_state)
    dtInstantRecharge:set_visible(new_state)
    gsLog:set_visible(new_state)
end

ui_callback()

rageMasterSwitch:set_callback(ui_callback)

local function dtHelpers()
    if dtDisableCorrection:get() and rageMasterSwitch:get() then
        cvar.cl_clock_correction:int(0)
        cvar.cl_clock_correction_adjustment_max_amount:int(450)
    end

    if dtDisableCorrection:get() and rageMasterSwitch:get() then
        cvar.cl_clock_correction:int(4)
        cvar.cl_clock_correction_adjustment_max_amount:int(200)
    end

    if dtInstantRecharge:get() then
        rage.exploit:force_charge()
    end
end

local hitgroup_str = {
    [0] = 'generic',
    'head', 'chest', 'stomach',
    'left arm', 'right arm',
    'left leg', 'right leg',
    'neck', 'generic', 'gear'
}

events.aim_ack:set(function(e)
    local target = entity.get(e.target)
    local damage = e.damage
    local wanted_damage = e.wanted_damage
    local wanted_hitgroup = hitgroup_str[e.wanted_hitgroup]
    local hitchance = e.hitchance
    local state = e.state
    local bt = e.backtrack
    if not target then return end
    if target == nil then return end
    if not gsLog:get() or not rageMasterSwitch:get() then return end
    local health = target["m_iHealth"]


    local hitgroup = hitgroup_str[e.hitgroup]

    if state == nil then
        print_dev(("Registered shot at %s's %s for %d("..string.format("%.f", wanted_damage)..") damage (hp: "..health..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
        print_raw(("[+] Registered shot at %s's %s for %d("..string.format("%.f", wanted_damage)..") damage (hp: "..health..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
    else
        print_dev(('Missed shot in %s in the %s due to '..state..' (hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
        print_raw(('[-] Missed shot in %s in the %s due to '..state..' (hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
    end
end)

local OtherMiscs = ui.create("Other", "Miscs")

local AspectRatio = OtherMiscs:slider("Aspect Ratio", 0, 20, 0, 0.1)
local AspectRatioTooltip = AspectRatio:set_tooltip("To turn off just set it to 0")

local anim_breakers = OtherMiscs:selectable("Animation Breakers", {'Static  air legs', 'Backward legs', 'Force landing pitch'}, 0)

AspectRatio:set_callback(function()
    cvar.r_aspectratio:float(AspectRatio:get()/10)
end)

local function in_air()
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

entity_list_pointer = ffi.cast('void***', utils.create_interface('client.dll', 'VClientEntityList003'))
get_client_entity_fn = ffi.cast('GetClientEntity_4242425_t', entity_list_pointer[0][3])
function get_entity_address(ent_index)
	local addr = get_client_entity_fn(entity_list_pointer, ent_index)
	return addr
end

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

local legmovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")

hooked_function = nil
ground_ticks, end_time = 1, 0
function updateCSA_hk(thisptr, edx)
    if entity.get_local_player() == nil or ffi.cast('uintptr_t', thisptr) == nil then return end
    if anim_breakers:get("Backward legs") then
        ffi.cast('float*', ffi.cast('uintptr_t', thisptr) + 10104)[0] = 1
        legmovement:set('Sliding')
    end
    if anim_breakers:get("Force landing pitch") then
        ffi.cast('float*', ffi.cast('uintptr_t', thisptr) + 10104)[12] = 0
    end
    hooked_function(thisptr, edx)
    if anim_breakers:get("Static  air legs") then
        ffi.cast('float*', ffi.cast('uintptr_t', thisptr) + 10104)[6] = 1
    end
    if anim_breakers:get("Force landing pitch") then
        if bit.band(entity.get_local_player()["m_fFlags"], 1) == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime  + 1
        end
        if not in_air() and ground_ticks > 1 and end_time > globals.curtime then
            ffi.cast('float*', ffi.cast('uintptr_t', thisptr) + 10104)[12] = 0.5
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

local OtherVisuals = ui.create("Other", "Visuals")

local visualsMasterSwitch = OtherVisuals:switch(gradient.text("Visuals Masterswitch", false, {color(0, 255, 191), color(50, 125, 205)}), false)
local visualsIndicators = OtherVisuals:combo("Indicator styles", {"Disabled", "Gadz0", "Acatel", "Ideal Yaw"}, 0)
local visualsInfoPanel = OtherVisuals:switch("Info Panel", false)
local visualsMinDmgIndicator = OtherVisuals:switch("Minimum Damage Indicators", false)
local visualsScopeLines = OtherVisuals:switch("Custom Scope Lines", false)
local scopeLines_ref = visualsScopeLines:create()
local scopeGap = scopeLines_ref:slider("Scope Gap", 0, 300, 15)
local scopeLength = scopeLines_ref:slider("Scope Length", 0, 300, 150)
local scopeColor = scopeLines_ref:color_picker("Scope Color", color(255, 255, 255, 255))
local visualsUIItems = OtherVisuals:selectable("Solus UI Items", {"Watermark", "Keybinds"})
local UIColor = OtherVisuals:color_picker("UI Color", color(255, 130, 130, 255))
local keybinds_x = OtherVisuals:slider("Slider 1", 0, render.screen_size().x, 0)
local keybinds_y = OtherVisuals:slider("Slider 2", 0, render.screen_size().y, 0)
keybinds_x:set_visible(false)
keybinds_y:set_visible(false)

local ui_callback = function()
    local new_state = visualsMasterSwitch:get()
    visualsIndicators:set_visible(new_state)
    visualsInfoPanel:set_visible(new_state)
    visualsMinDmgIndicator:set_visible(new_state)
    visualsUIItems:set_visible(new_state)
    UIColor:set_visible(new_state)
    visualsScopeLines:set_visible(new_state)
end

ui_callback()

visualsMasterSwitch:set_callback(ui_callback)

function condstate()
    local localplayer = entity.get_local_player()
    if localplayer == nil then return end
    if bit.band(localplayer.m_fFlags, bit.lshift(1,0)) == 0 and localplayer.m_flDuckAmount > 0.8 then
        aastate = "AIR+CROUCH"
    elseif ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
        aastate = "SLOWWALK"
    elseif bit.band(localplayer.m_fFlags, bit.lshift(1,0)) == 0  then
        aastate = "AIR"
    elseif localplayer.m_flDuckAmount > 0.8 or ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get() then
        aastate = "CROUCH"
    elseif velocity(localplayer) > 2 then
        aastate = "MOVING"
    elseif velocity(localplayer) < 2 then
        aastate = "STANDING"
    end

    return aastate
end

local render_window = function(x, y, w, h, coloru, shadow_color, outline_color, left, outline)
    local r, g, b, a = coloru.r, coloru.g, coloru.b, coloru.a
    local r1, g1, b1, a1 = shadow_color.r, shadow_color.g, shadow_color.b, shadow_color.a
    local r2, g2, b2, a2 = outline_color.r, outline_color.g, outline_color.b, outline_color.a

    if outline then
        render.circle_outline(vector(x + 4, y + 4), color(r, g, b, 255), 4, 165, 0.35, 1)

        render.rect(vector(x + 4, y), vector(w - 5, y+1), color(r, g, b, 255))
        render.circle_outline(vector(w - 4, y + 4), color(r, g, b, 255), 4, 260, 0.35, 1)

        render.gradient(vector(x, y + 4), vector(x + 1, h - 6), color(r, g, b, 255), color(r, g, b, 255), color(r, g, b, 0), color(r, g, b, 0))
        render.gradient(vector(w - 1, y + 4), vector(w, h - 6), color(r, g, b, 255), color(r, g, b, 255), color(r, g, b, 0), color(r, g, b, 0))
    end
    render.rect(vector(x, y), vector(w, h), color(r2, g2, b2, (80 / 255) * 30), 5)
    if left then
        render.rect(vector(x, y + 4), vector(x+1, h - 5), color(r, g, b, 255))

        render.circle_outline(vector(x + 5, y + 5), 5, 12, color(r, g, b, 255), 1, -90, -165)

        render.circle_outline(vector(x + 5, h - 5), 5, 12, color(r, g, b, 255), 1, -185, -255)

        render.gradient(vector(x + 4, y), vector(x+20, y+1), color(r, g, b, 255), color(r, g, b, 0), color(r, g, b, 255), color(r, g, b, 0))
        render.gradient(vector(x + 4, h - 1), vector(x+20, h), color(r, g, b, 255), color(r, g, b, 0), color(r, g, b, 255), color(r, g, b, 0))
    end
    
    render.rect(vector(x+1, y+1), vector(w-1, h-1), color(0, 0, 0, 100), 5)
    
end

function getbinds()
    local binds = {}
    local cheatbinds = ui.get_binds()
    
    for i = 1, #cheatbinds do
        table.insert(binds, 1, cheatbinds[i])
    end
    return binds
end

local keybind_names = {
    ['Double Tap'] = 'Double tap',
    ['Hide Shots'] = 'On shot anti-aim',
    ['Slow Walk'] = 'Slow motion',
    ['Edge Jump'] = 'Jump at edge',
    ['Fake Ping'] = 'Ping spike',
    ['Override Resolver'] = 'Resolver override',
    ['Fake Duck'] = 'Duck peek assist',
    ['Minimum Damage'] = 'Damage override',
    ['Auto Peek'] = 'Quick peek assist',
    ['Body Aim'] = 'Force body aim',
    ['Safe Points'] = 'Safe points',
    ['Yaw Base'] = 'Yaw base',
    ['Enable Thirdperson'] = 'Thirdperson',
    ['Manual Yaw Base'] = 'Yaw base',
}

local render_solus = function(x2, y2, w, h, name, font)
    local name_size = render.measure_text(font, nil, name)
    render_window(x2, y2, x2 + w + 3, y2 + h + 2, color(UIColor:get().r, UIColor:get().g, UIColor:get().b, 255), color(UIColor:get().r, UIColor:get().g, UIColor:get().b, 255), color(UIColor:get().r, UIColor:get().g, UIColor:get().b, 255), false, true)
    render.text(font, vector(x2+1 + w / 2 + 1 - name_size.x / 2, y2 + 2), color(255,255,255, 255), nil, name)
end

function upper_to_lower(str)
    str1 = string.sub(str, 2, #str)
    str2 = string.sub(str, 1, 1)
    return str2:upper()..str1:lower()
end

local lerp = function(time,a,b)
    return a * (1-time) + b * time
end
alpha_k = 1
width_k = 0
width_ka = 0
data_k = {
    [''] = {alpha_k = 0}
}
drag = false

function keybinds()
    if not visualsUIItems:get("Keybinds") or not visualsMasterSwitch:get() then return end
    local x_k, y_k = keybinds_x:get(), keybinds_y:get()
    local max_width = 0
    local frametime = globals.frametime * 16
    local add_y = 0
    local total_width = 66
    local active_binds = {}
    local bind = getbinds()
    for i = 1, #bind do
        local binds = bind[i]
        local bind_name = keybind_names[binds.name] == nil and upper_to_lower(binds.name) or keybind_names[binds.name]

        local bind_state = binds.mode
        if bind_state == 2 then
            bind_state = 'toggled'
        elseif bind_state == 1 then
            bind_state = 'holding'
        end
        if binds.name == "Minimum Damage" then
            bind_state = binds.value
        end
        
        if data_k[bind_name] == nil then
            data_k[bind_name] = {alpha_k = 0}
        end
        
        data_k[bind_name].alpha_k = lerp(frametime, data_k[bind_name].alpha_k,binds.active and 1 or 0)
        local bind_state_size = render.measure_text(verdanar11, nil, bind_state)
        local bind_name_size = render.measure_text(verdanar11, nil, bind_name)

        render.text(verdanar11, vector(x_k+4, y_k + 21 + add_y), color(0, 0, 0, data_k[bind_name].alpha_k*255), nil, bind_name)
        render.text(verdanar11, vector(x_k+1 + (width_ka - bind_state_size.x - 8), y_k + 21 + add_y), color(0, 0, 0, data_k[bind_name].alpha_k*255), nil, '['..bind_state..']')

        render.text(verdanar11, vector(x_k+3, y_k + 20 + add_y), color(255, 255, 255, data_k[bind_name].alpha_k*255), nil, bind_name)
        render.text(verdanar11, vector(x_k + (width_ka - bind_state_size.x- 8), y_k + 20 + add_y), color(255, 255, 255, data_k[bind_name].alpha_k*255), nil, '['..bind_state..']')

        add_y = add_y + 16 * data_k[bind_name].alpha_k

        
        local width_k = bind_state_size.x + bind_name_size.x + 18
        if width_k > 150-11 then
            if width_k > max_width then
                max_width = width_k
            end
        end
        if binds.active then
            table.insert(active_binds, binds)
        end
    end
    alpha_k = lerp(frametime,alpha_k, ((ui.get_alpha() > 0.9) or #active_binds > 0) and 1 or 0)
    width_ka = lerp(frametime,width_ka,math.max(max_width, 150-11))

    if (ui.get_alpha() > 0.9) or #active_binds > 0 then
        render_solus(x_k, y_k, width_ka, 16, 'keybinds', 11, verdanar11)

        local mouse = ui.get_mouse_position()
        if common.is_button_down(1) and (ui.get_alpha() > 0.9) then
            if mouse.x >= x_k and mouse.y >= y_k and mouse.x <= x_k + width_ka and mouse.y <= y_k + 18 or drag then
                if not drag then
                    drag = true
                else
                    keybinds_x:set(mouse.x - math.floor(width_ka / 2))
                    keybinds_y:set(mouse.y - 8)
                end
            end
        else
            drag = false
        end
    end
end

function watermark()
    if not visualsUIItems:get("Watermark") or not visualsMasterSwitch:get() then return end
    lua_name = "gadzo.yaw [" .. string.lower(build) .. "]"
    user_name = common.get_username()
    time = common.get_date("%H:%M:%S")
    watermark_text = string.format("%s  %s  %s", lua_name, user_name, time)

    if globals.is_in_game then
        watermark_text = string.format("%s  %s  %s", lua_name, user_name, time)
    end

    cock_size = render.measure_text(verdanar11, nil, watermark_text)
    render_solus(render.screen_size().x - cock_size.x - 15, 3, cock_size.x + 5, 16, watermark_text, 11, verdanar11)
end

events.render:set(function()
    keybinds()
    watermark()
end)

local clrvrs = {
    ["Alpha"] = color(154, 163, 190),
    ["Stable"] = color(120, 127, 144)
}

local vers = {
    ["Alpha"] = "[alpha]",
    ["Stable"] = "[stable]"
}

function firstToUpper(str)
    local firstLetter = string.sub(str, 1, 1)
    firstLetter = firstLetter:upper()
    return (firstLetter .. string.sub(str, 2, -1))
end

local function panel()
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    local player_name = lp:get_name()
    if player_name == nil then return end
    if not visualsInfoPanel:get() or not visualsMasterSwitch:get() then return end
    local textpanel1_1 = ("> ")
    local textpanel1_2 = ("gadzo.yaw v" .. version)
    local textpanel1_3 = (" - anti aim lua")
    
    local textpanel2_1 = ("> user: ")
    local textpanel2_2 = (username)

    local textpanel3_1 = ("> build: ")
    local textpanel3_2 = (vers[build])

    local textpanel4_1 = ("> current anti aim state: ")
    local textpanel4_2 = (string.lower(condstate()))

    local textpanel5_1 = ("> desync: ")
    local textpanel5_2 = (math.floor(desync_delta()) .. "°")


    if visualsInfoPanel:get() and visualsMasterSwitch:get() then
        render.text(1, vector(5, render.screen_size().y/2), color(255, 255, 255, 255), nil, textpanel1_1)
        render.text(1, vector(5 + render.measure_text(1, nil, textpanel1_1).x, render.screen_size().y/2), color(UIColor:get().r, UIColor:get().g, UIColor:get().b, UIColor:get().a), nil, textpanel1_2)
        render.text(1, vector(5 + render.measure_text(1, nil, textpanel1_1).x + render.measure_text(1, nil, textpanel1_2).x, render.screen_size().y/2), color(255, 255, 255, 255), nil, textpanel1_3)
        render.text(1, vector(5, render.screen_size().y/2+15), color(255, 255, 255, 255), nil, textpanel2_1)
        render.text(1, vector(5 + render.measure_text(1, nil, textpanel2_1).x, render.screen_size().y/2+15), color(UIColor:get().r, UIColor:get().g, UIColor:get().b, UIColor:get().a), nil, textpanel2_2)
        render.text(1, vector(5, render.screen_size().y/2+30), color(255, 255, 255, 255), nil, textpanel3_1)
        render.text(1, vector(5 + render.measure_text(1, nil, textpanel3_1).x, render.screen_size().y/2+30), color(UIColor:get().r, UIColor:get().g, UIColor:get().b, UIColor:get().a), nil, textpanel3_2)
        render.text(1, vector(5, render.screen_size().y/2+45), color(255, 255, 255, 255), nil, textpanel4_1)
        render.text(1, vector(5 + render.measure_text(1, nil, textpanel4_1).x, render.screen_size().y/2+45), color(UIColor:get().r, UIColor:get().g, UIColor:get().b, UIColor:get().a), nil, textpanel4_2)
        render.text(1, vector(5, render.screen_size().y/2+60), color(255, 255, 255, 255), nil, textpanel5_1)
        render.text(1, vector(5 + render.measure_text(1, nil, textpanel5_1).x, render.screen_size().y/2+60), color(UIColor:get().r, UIColor:get().g, UIColor:get().b, UIColor:get().a), nil, textpanel5_2)
    end
end

events.render:set(panel)

events.render:set(function()
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    if not visualsMinDmgIndicator:get() or not visualsMasterSwitch:get() then return end
    local x = render.screen_size().x/2
    local y = render.screen_size().y/2
    if visualsMinDmgIndicator:get() and visualsMasterSwitch:get() then
        render.text(1, vector(x+5, y-20), color(255, 255, 255, 255), nil, tostring(isMD:get()))
    end
end)

length = 0
gap = 0

events.render:set(function()
    if not visualsScopeLines:get() then 
        ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove Overlay")
        return 
    end

    local x = render.screen_size().x
    local y = render.screen_size().y
    local localplayer = entity.get_local_player()
    ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove All")
    if localplayer == nil then return end
    if localplayer.m_iHealth < 1 then return end
    length = lerp(0.15, length, localplayer.m_bIsScoped and scopeLength:get() or 0) 
    gap = lerp(0.15, gap, localplayer.m_bIsScoped and scopeGap:get() or 0) 
    local scopeColor_x = color(scopeColor:get().r, scopeColor:get().g, scopeColor:get().b, scopeColor:get().a)
    local scopeColor_y = color(scopeColor:get().r, scopeColor:get().g, scopeColor:get().b, 0)
    render.gradient(vector(x / 2 - gap, y / 2), vector(x / 2 - gap - length, y / 2 + 1), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
    render.gradient(vector(x / 2 + gap, y / 2), vector(x / 2 + gap + length, y / 2 + 1), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
    render.gradient(vector(x / 2, y / 2 + gap), vector(x / 2 + 1, y / 2 + gap + length), scopeColor_x, scopeColor_x, scopeColor_y, scopeColor_y)
    render.gradient(vector(x / 2, y / 2 - gap), vector(x / 2 + 1, y / 2 - gap - length), scopeColor_x, scopeColor_x, scopeColor_y, scopeColor_y)
end)

--GADZO INDICATORS

local x = render.screen_size().x/2
local y = render.screen_size().y/2

local lerpik = function (a, b, percentage) return math.floor(a + (b - a) * percentage) end

local anim = {0, 0, 0, 0, 0}
local font = render.load_font("nl\\gadzoyaw\\fonts\\pixel.ttf", 10, 'o')



events.render:set(function()
    local lp = entity.get_local_player()
    
    add_y = 15
    if not lp or not lp:is_alive() then return end
    if not visualsIndicators:get() == "Gadz0" or not visualsMasterSwitch:get() then return end

    if visualsIndicators:get() == "Gadz0" and visualsMasterSwitch:get() then

        local charge_clr = rage.exploit:get() == 1 and color(126, 214, 136, anim[1]) or color(226, 54, 55, anim[1])
        local desync_state = aa_library.get_inverter_state() and "R" or "L"
        if lp.m_bIsScoped then anim[4] = lerpik(anim[4], -40, globals.frametime * 5) else anim[4] = lerpik(anim[4], 0, globals.frametime * 100) end

        local alpha = math.min(math.floor(math.sin((globals.curtime%3) * 4) * 175 + 50), 255)

        render.text(font, vector(x - anim[4], y + add_y), color(UIColor:get().r, UIColor:get().g, UIColor:get().b, alpha), 'c', "ALPHA")
        add_y = add_y + 9

        render.text(font, vector(x - anim[4], y + add_y), color(255, 255, 255, 255), 'c', "GADZO.YAW")
        add_y = add_y + 9

        local cond = "-" .. condstate() .. "-"
        render.text(font, vector(x - anim[4], y + add_y), color(255, 255, 255, 255), 'c', cond)
        add_y = add_y + 9

        render.text(font, vector(x - anim[4], y + add_y), color(163, 199, 255, 255), 'c', "FAKEYAW: ")
        render.text(font, vector(x + 20 - anim[4], y + add_y), color(255, 255, 255, 255), 'c', desync_state)

        if isDT:get() then
            anim[1] = lerpik(anim[1], 255, globals.frametime * 11)
            add_y = add_y + 9
        else
            if anim[1] > 0 then
                add_y = add_y + 9
            end
            anim[1] = lerpik(anim[1], 0, globals.frametime * 11)
        end
        render.text(font, vector(x - anim[4], y + add_y), charge_clr, 'c', "doubletap")

        if isHS:get() then
            anim[2] = lerpik(anim[2], 255, globals.frametime * 11)
            add_y = add_y + 9
        else
            if anim[2] > 0 then
                add_y = add_y + 9
            end
            anim[2] = lerpik(anim[2], 0, globals.frametime * 11)
        end
        render.text(font, vector(x - anim[4], y + add_y), color(137, 174, 255, anim[2]), 'c', "on-shot")

        if isFD:get() then
            anim[3] = lerpik(anim[3], 255, globals.frametime * 11)
            add_y = add_y + 9
        else
            if anim[3] > 0 then
                add_y = add_y + 9
            end
            anim[3] = lerpik(anim[3], 0, globals.frametime * 11)
        end
        render.text(font, vector(x - anim[4], y + add_y), color(227, 139, 25, anim[3]), 'c', "duck")
    end
end)

--ACATEL
function desync_delta()
    local desync_rotation = rage.antiaim:get_rotation(true)
    local real_rotation = rage.antiaim:get_rotation()
    local delta_to_draw = math.min(math.abs(real_rotation - desync_rotation) / 2, 60)
    return string.format("%.1f", delta_to_draw)
end
local fake = desync_delta()
local currentTime = globals.curtime

local acatel_indicators = function(cmd)

    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    if not visualsIndicators:get() == "Acatel" or not visualsMasterSwitch:get() then return end

    if visualsIndicators:get() == "Acatel" and visualsMasterSwitch:get() then
        local x = render.screen_size().x
        local y = render.screen_size().y

        if globals.is_connected then
            aa_inv_state = lp.m_flPoseParameter[11] * 120 - 60 <= 0 and true or false
        else
            return
        end

        if aa_inv_state == false then
            invert ="R"
        else
            invert ="L"
        end

        local minDmg = false
        local binds = ui.get_binds()
        for i, v in pairs(binds) do
            local bind = binds[i]
            if v.name == 'Minimum Damage' then
                minDmg = true
            end
        end

        if currentTime + 0.38 < globals.curtime then
            currentTime = globals.curtime
            fake = desync_delta()
        end

        local ay = 10
        local alpha = math.min(math.floor(math.sin((globals.curtime%3) * 4) * 175 + 50), 255)

        local eternal_ts = render.measure_text(font, nil, "GADZ0.YAW ")
        render.text(font, vector(x/2, y/2+ay), color(255,255,255,255), nil, "GADZ0.YAW")
        render.text(font, vector(x/2+eternal_ts.x-2, y/2+ay), color(UIColor:get().r, UIColor:get().g, UIColor:get().b, alpha), nil, "ALPHA")
        ay = ay + 9

        local text_ =""
        local clr0 = color(0, 0, 0, 0)
        if isSW:get() then
            text_ ="DANGEROUS+ "
            clr0 = color(255, 50, 50, 255)
        else
            text_ ="DYNAMIC- "
            clr0 = color(255, 117, 107, 255)
        end

        local d_ts = render.measure_text(font, nil, text_)
        render.text(font, vector(x/2, y/2+ay), clr0, nil, text_)
        render.text(font, vector(x/2+d_ts.x, y/2+ay), color(255,255,255,255), nil, math.floor(fake).."°")
        ay = ay + 9

        local cur_condition = render.measure_text(font, nil, "CURRENT STATE: ")
        render.text(font, vector(x/2, y/2+ay), color(130, 130, 255, 255), nil, "CURRENT STATE:")
        render.text(font, vector(x/2+cur_condition.x, y/2+ay), color(255, 255, 255, 255), nil, condstate())
        ay = ay + 9

        local fake_ts = render.measure_text(font, nil, "FAKE YAW: ")
        render.text(font, vector(x/2, y/2+ay), color(130, 130, 255, 255), nil, "FAKE YAW:")
        render.text(font, vector(x/2+fake_ts.x, y/2+ay), color(255, 255, 255, 255), nil, invert)
        ay = ay + 9

        local asadsa = math.min(math.floor(math.sin((rage.exploit:get()%2) *1) * 122), 100)
        
        if isAP:get() and isDT:get() then
            local ts_tick = render.measure_text(2, nil, "IDEALTICK")
            render.text(font, vector(x/2, y/2+ay), color(255, 255, 255, 255), nil, "IDEALTICK")
            render.text(font, vector(x/2+ts_tick.x, y/2+ay), rage.exploit:get() and color(0, 255, 0, 255) or color(255, 0, 0, 255), nil, "x"..asadsa)
            ay = ay + 9
        else
            if isAP:get() then
                render.text(font, vector(x/2, y/2+ay), color(255, 255, 255, 255), nil, "PEEK")
                ay = ay + 9
            end
            if isDT:get() then
                render.text(font, vector(x/2, y/2+ay), rage.exploit:get() == 1 and color(0, 255, 0, 255) or color(255, 0, 0, 255), nil, "DT")
                ay = ay + 9
            end
        end

        local ax = 0
        if isHS:get() then
            render.text(font, vector(x/2, y/2+ay), color(250, 173, 181, 255), nil, "OS-AA")
            ay = ay + 9
        end

        render.text(font, vector(x/2, y/2+ay), isBA:get() == 2 and color(255, 255, 255, 255) or color(255, 255, 255, 128), nil, "BAIM")
        ax = ax + render.measure_text(font, nil, "BAIM ").x

        render.text(font, vector(x/2+ax, y/2+ay), isSP:get() == 2 and color(255, 255, 255, 255) or color(255, 255, 255, 128), nil, "SP")
        ax = ax + render.measure_text(font, nil, "SP ").x

        render.text(font, vector(x/2+ax, y/2+ay), isFS:get() == 2 and color(255, 255, 255, 255) or color(255, 255, 255, 128), nil, "FS")
        ax = ax + render.measure_text(font, nil, "FS ").x
    end
end

--IDEAL YAW
local ideal_ind = function()

    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    if not visualsIndicators:get() == "Ideal Yaw" or not visualsMasterSwitch:get() then return end

    if visualsIndicators:get() == "Ideal Yaw" and visualsMasterSwitch:get() then
        local ay = 0
        local x = render.screen_size().x/2
        local y = render.screen_size().y/2 + 20
        
        render.text(verdana, vector(x + 1, y), color(0, 0, 0, 255), nil, "IDEAL YAW")
        render.text(verdana, vector(x, y), color(220, 135, 49, 255), nil, "IDEAL YAW")
        ay = ay + 10
        if isFS:get() then
            render.text(verdana, vector(x + 1, y + ay), color(0, 0, 0, 255), nil, "FREESTAND")
            render.text(verdana, vector(x, y + ay), color(209, 159, 230, 255), nil, "FREESTAND")
            ay = ay + 10
        else
            render.text(verdana, vector(x + 1, y + ay), color(0, 0, 0, 255), nil, "DYNAMIC")
            render.text(verdana, vector(x, y + ay), color(209, 159, 230, 255), nil, "DYNAMIC")
            ay = ay + 10
        end
        if isDT:get() then
            local chrg = rage.exploit:get()
            render.text(verdana, vector(x + 1, y + ay), color(0, 0, 0, 255), nil, "DT")
            if chrg == 1 then
                render.text(verdana, vector(x, y + ay), color(0, 255, 0, 255), nil, "DT")
            else
                render.text(verdana, vector(x, y + ay), color(255, 0, 0, 255), nil, "DT")
            end
            ay = ay + 10
        end
        if isHS:get() then
            render.text(verdana, vector(x + 1, y + ay), color(0, 0, 0, 255), nil, "AA")
            render.text(verdana, vector(x, y + ay), color(120, 128, 200, 255), nil, "AA")
            ay = ay + 10
        end
    end
end


events.render:set(acatel_indicators)
events.render:set(ideal_ind)

local OtherCfg = ui.create("Main", "Config Manager")

local JSON = panorama.loadstring([[
    return {
        stringify: JSON.stringify,
        parse: JSON.parse
    };
]])()


local cfg_data = {
    bools = {
        AAMasterSwitch,
        AALegFucker,
        flMasterSwitch,
        rageMasterSwitch,
        dtDisableCorrection,
        visualsMasterSwitch,
        visualsMinDmgIndicator,
        gsLog,
        visualsInfoPanel,
        dtInstantRecharge,
        custom_aa[1].body_yaw,
        custom_aa[2].body_yaw,
        custom_aa[3].body_yaw,
        custom_aa[4].body_yaw,
        custom_aa[5].body_yaw,
        custom_aa[6].body_yaw
    },

    ints = {
        custom_aa2[1].offset,
        custom_aa2[2].offset,
        custom_aa2[3].offset,
        custom_aa2[4].offset,
        custom_aa2[5].offset,
        custom_aa2[6].offset,
        custom_aa2[1].modifier_offset,
        custom_aa2[2].modifier_offset,
        custom_aa2[3].modifier_offset,
        custom_aa2[4].modifier_offset,
        custom_aa2[5].modifier_offset,
        custom_aa2[6].modifier_offset,
        custom_aa2[1].left_limit,
        custom_aa2[2].left_limit,
        custom_aa2[3].left_limit,
        custom_aa2[4].left_limit,
        custom_aa2[5].left_limit,
        custom_aa2[6].left_limit,
        custom_aa2[1].right_limit,
        custom_aa2[2].right_limit,
        custom_aa2[3].right_limit,
        custom_aa2[4].right_limit,
        custom_aa2[5].right_limit,
        custom_aa2[6].right_limit,
    },

    floats = {
        AspectRatio
    },

    strings = {
        AAMode,
        visualsIndicators,
        anim_breakers,
        custom_aa[1].yaw_type,
        custom_aa[2].yaw_type,
        custom_aa[3].yaw_type,
        custom_aa[4].yaw_type,
        custom_aa[5].yaw_type,
        custom_aa[6].yaw_type,
        custom_aa2[1].base,
        custom_aa2[2].base,
        custom_aa2[3].base,
        custom_aa2[4].base,
        custom_aa2[5].base,
        custom_aa2[6].base,
        custom_aa[1].yaw_modifier,
        custom_aa[2].yaw_modifier,
        custom_aa[3].yaw_modifier,
        custom_aa[4].yaw_modifier,
        custom_aa[5].yaw_modifier,
        custom_aa[6].yaw_modifier,
        custom_aa2[1].options,
        custom_aa2[2].options,
        custom_aa2[3].options,
        custom_aa2[4].options,
        custom_aa2[5].options,
        custom_aa2[6].options,
        custom_aa2[1].freestanding,
        custom_aa2[2].freestanding,
        custom_aa2[3].freestanding,
        custom_aa2[4].freestanding,
        custom_aa2[5].freestanding,
        custom_aa2[6].freestanding,
        custom_aa2[1].onshot,
        custom_aa2[2].onshot,
        custom_aa2[3].onshot,
        custom_aa2[4].onshot,
        custom_aa2[5].onshot,
        custom_aa2[6].onshot,
        custom_aa2[1].lby_mode,
        custom_aa2[2].lby_mode,
        custom_aa2[3].lby_mode,
        custom_aa2[4].lby_mode,
        custom_aa2[5].lby_mode,
        custom_aa2[6].lby_mode,
    }
}

local ExportCfg = OtherCfg:button("Export Config", function()
    local Code = {{}, {}, {}, {}}

    for _, bools in pairs(cfg_data.bools) do
        table.insert(Code[1], bools:get())
    end

    for _, ints in pairs(cfg_data.ints) do
        table.insert(Code[2], ints:get())
    end

    for _, floats in pairs(cfg_data.floats) do
        table.insert(Code[3], floats:get())
    end

    for _, strings in pairs(cfg_data.strings) do
        table.insert(Code[4], strings:get())
    end

    clipboard.set(base64.encode(JSON.stringify(Code)))

    print_dev("Config was successfully exported into your clipboard!")
end)

local ImportCfg = OtherCfg:button("Import Config", function()
    for k, v in pairs(JSON.parse(base64.decode(clipboard.get()))) do

        k = ({[1] = "bools", [2] = "ints", [3] = "floats", [4] = "strings", [5] = "colors"})[k]

        for k2, v2 in pairs(v) do
            if (k == "bools") then
                cfg_data[k][k2]:set(v2)
            end

            if (k == "ints") then
                cfg_data[k][k2]:set(v2)
            end

            if (k == "floats") then
                cfg_data[k][k2]:set(v2)
            end

            if (k == "strings") then
                cfg_data[k][k2]:set(v2)
            end
        end
    end

    print_dev("Config was successfully imported!")
end)