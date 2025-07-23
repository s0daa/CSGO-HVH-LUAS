-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

--nightly
luashkaname = "AFTERLIFE"
local animation, crosshair, feature, localplayer_info, renders, cfg, corner, dynamic, logs, ents, buff, vmt_hook, hooked_function, ground_ticks, end_time, lagcomp = { data = {} }, {}, {}, {}, { real_yaw = 0, side = 0, inverter = false, viewmodel_x, viewmodel_y, viewmodel_z, viewmodel_fov }, {}, {}, { Data = {} }, {}, {}, {}, { free = {} }, { hooks = {} }, nil, 1, 0, { r = 142, g = 165, b = 255, a = 0, positions = {}, lc = false}
local MTools = require("neverlose/mtools");
local LT = require("neverlose/lambotruck");
local Hook = require("neverlose/vmt_hook");
local requires = { ffi.load 'UrlMon', ffi.load 'WinInet', require('neverlose/clipboard'), require('neverlose/base64'), require('neverlose/gradient') }
local gradient = requires[5]
local base64 = require("neverlose/base64")
local shitjson = require("neverlose/nl_json")
local pui = require("neverlose/pui")
local clipboard = require("neverlose/clipboard")
local file = require("neverlose/file")
local vmt_hook = require("neverlose/vmt_hook")


local luashka_gradient = gradient.text_animate("AFTERBRUTE", -3, {
    color(255, 255, 255), -- starting color (white)
    color(160, 160, 160)  -- original color (AFTERLIFE color)
})

----KFG SYS-------------------------------------------------
local kfg_sys = {}
kfg_sys.nameslol = {}
kfg_sys.new_element = function(element, reference_element, clr)
    if not element or not reference_element then
        print_raw("wrong kfg arguments")
        return
    end

    kfg_sys.nameslol[element] = {
        reference_element = reference_element,
        clr = clr
    }

    return reference_element
end


local var = { 
    in_air = 0, 
    plr_state = 1, 
    player_states = {'AIR+', 'AIR', 'SLOWING', 'CROUCHING', 'STANDING', 'MOVING', 'FAKELAG'},
    shots = 0,
    aa_dir = 0,
    textsize = 0
}

local lua = { 
    username = common.get_username(),
    version = '',
    debug = false
}
local HookObject = {
    GTicks = 0,
    ETime = 0
};
local HookFunc = nil
ffi.cdef[[
	typedef int(__fastcall* clantag_t)(const char*, const char*);

    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    
    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);
    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);

    typedef struct
    {
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

    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);  
    void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);

    bool DeleteUrlCacheEntryA(const char* lpszUrlName);

    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

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

    typedef struct
    {
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
]]
--font downloading
MTools.FileSystem.CreateDir("nl\\afterlifelua.xyz");
MTools.Network.Download(
    "https://pashanim.autos/pixel.ttf", 
    "nl\\afterlifelua.xyz\\pixel.ttf", 
    true,
    97
);







--
local hover_over_element = false

-- innovation gone 😔
-- ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"):visibility(false)
-- ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):visibility(false)
-- ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):visibility(false)
-- ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"):visibility(false)
-- ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"):visibility(false)
-- ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):visibility(false)
-- ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"):visibility(false)
-- ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):visibility(false)
-- ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):visibility(false)
-- ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):visibility(false)
animated_menu_things = function ()
    local sidebar_text = gradient.text_animate("afterlife.lua", 2.5, {
        ui.get_style("Button"):alpha_modulate(255), 
        color(255, 255, 255)
    })
    
    ui.sidebar(sidebar_text:get_animated_text(), "😱")
    sidebar_text:animate()
end

events.render:set(animated_menu_things)

local welcome_phrases = {
    "Let's rock and roll",
    "Who's ready to rumble",
    "Ready to have some fun",
    "Are you ready to kick some ass",
    "Are you ready to dominate",
    "Let's hit the ground running!",
    "Let's get this show on the road!",
    "Let's kick it into high gear!",
    "Let's make some magic happen!",
    "Let's light up the night!",
    "Let's bring the heat!",
    "Let's make some noise!",
    "Let's tear up the dance floor!",
    "Let's blow their minds!",
    "Let's leave them speechless!",
    "Who's ready to party",
    "Who's ready to rock",
    "Who's ready to get this started",
    "Who's ready to shake things up",
    "Who's ready to have some fun",
    "Who's ready to make some noise",
    "Who's ready to kick some butt",
    "Who's ready to bring the thunder",
    "Who's ready to light the fuse",
    "Who's ready to make history",
    "Are you ready to take on the world",
    "Are you ready to show them what you're made of",
    "Are you ready to give it your all",
    "Are you ready to conquer your fears",
    "Are you ready to crush your goals",
    "Are you ready to push yourself to the limit",
    "Are you ready to dominate the competition",
    "Are you ready to unleash your full potential",
    "Are you ready to make your dreams a reality",
    "Are you ready to be unstoppable",
    "Are you ready to own it",
    "Are you ready to show them who's boss",
    "Are you ready to take charge",
    "Are you ready to be the best",
    "Are you ready to come out on top",
    "Are you ready to leave your mark",
    "Are you ready to be the champion",
    "Are you ready to rise to the occasion",
    "Are you ready to be a winner",
    "Are you ready to be the leader of the pack",
}

local combo = { menu_states = {'CA', 'A', 'SW', 'C', 'S', 'R', 'U', 'F'}, menu_states_full = { 'Crouching Air', 'Airing', 'Slowwalking', 'Crouching', 'Standing', 'Running', 'Fakelag'} }
local functions = {

    fonts = {
        hitlog = render.load_font('Calibri', vector(10, 10), 'a'),
        feature = render.load_font('Calibri', vector(24, 24, 0), 'ba'),
        legacy = render.load_font('Verdana', 25, 'bad'),
        --skeet_bold = render.load_font('Verdana', vector(10.6, 11), 'bad'),
        skeet_bold = render.load_font('Verdana', 10, 'abd'),
        csscrosshair = render.load_font('Verdana', 11, 'abd'),
        arrows = render.load_font('Verdana', 24, 'ba'),
        arrowssecond = render.load_font('Verdana', 19, 'bad'),
        teamskeetarrows = render.load_font('Verdana', 21, 'a')
    },

    hitgroups = {
        [0] = 'generic',
        'head', 'chest', 'stomach',
        'left arm', 'right arm',
        'left leg', 'right leg',
        'neck', 'generic', 'gear'
    },

    reasons = {
        ['correction'] = 'resolver',
        ['misprediction'] = 'resolver',
        ['spread'] = 'spread',
        ['prediction error'] = 'prediction error',
        ['lagcomp failure'] = 'prediction error',
        ['unregistered shot'] = 'unregistered shot',
        ['player death'] = 'player death',
        ['death'] = 'death'
    },

    reason_index = {
        ['correction'] = 1,
        ['misprediction'] = 1,
        ['spread'] = 2,
        ['prediction error'] = 4,
        ['lagcomp failure'] = 4,
        ['unregistered shot'] = 3,
        ['player death'] = 1,
        ['death'] = 1
    },

    killsays = {
        "𝕀´𝕄 𝕛𝕠𝕚𝕟 𝕤𝕖𝕣𝕧𝕖𝕣, 𝕤𝕖𝕒𝕣𝕔𝕙 𝕖𝕟𝕖𝕞𝕪, 𝕖𝕞𝕡𝕥𝕪. ♛",
        "(◣_◢) 𝚖𝚘𝚝𝚑𝚎𝚛 𝚜𝚊𝚢𝚎𝚍, 𝚗𝚘 𝚑𝚟𝚑 𝚒𝚗 𝚍𝚊𝚢 - 𝙼𝙴 𝙺𝙸𝙻𝙻𝙴𝚁 (◣_◢)",
        "ｙｏｕ´ｒｅ ｔｈｉｎｋｅｄ ｗｒｏｎｇ. ?",
        "𝕚´𝕞 5𝕧5 𝕨𝕚𝕟, 𝕟𝕠𝕨 𝕣𝕒𝕥 𝕚𝕥𝕤 𝔻𝔼𝔸𝔻",
        "ｙｏｕ ｔｈｉｎｋ ｙｏｕ´ｒｅ ｗｉｎ?. ｗｒｏｎｇ.",
        "𝕕𝕠𝕟´𝕥 𝕞𝕦𝕥𝕖𝕤 𝕗𝕠𝕣 𝕜𝕚𝕝𝕝𝕤𝕒𝕪𝕚𝕟𝕘𝕤, 𝕞𝕒𝕟𝕦𝕒𝕝 𝕥𝕪𝕡𝕖))", 
        "𝕕𝕠𝕟𝕥 𝕥𝕙𝕚𝕟𝕜 𝕨𝕚𝕟 𝕚 𝕨𝕚𝕝𝕝 𝕣𝕠𝕝𝕝 𝕓𝕚𝕘 𝕔𝕒𝕣 𝕟𝕠𝕨 (◣_◢)",
        "ｚａｂｏｌｏｔｎｙ ｄｏｎｔ ａｐｐｒｏｖｉｎｇ, ｉｍ ｓｑｌ ｉｎｊｅｃｔ ｎｖｌｚ (◣_◢)",
        "𝕝𝕠𝕔𝕒𝕝 𝕖𝕟𝕖𝕞𝕪𝕚𝕢 = 𝕞𝕒𝕥𝕙.𝕣𝕒𝕟𝕕𝕠𝕞(0, 4)",
        "ᵇʳᵃⁱⁿ ᵒⁿ ? ",
        "𝕕𝕠𝕟´𝕥 𝕙𝕠𝕡𝕖𝕤. 𝕓𝕒𝕚𝕥𝕤 𝕒𝕝𝕨𝕒𝕪𝕤 𝕨𝕚𝕟𝕟𝕖𝕥 :)",
        "１０００-７ ♛ (◣_◢)",
        "𝕚𝕞 𝕡𝕦𝕤𝕙, 𝕜𝕚𝕝𝕝, 𝕟𝕚99𝕖𝕣𝕤 - 𝕤𝕠𝕦𝕗𝕚𝕨 𝕒𝕚𝕣 𝕤𝕦𝕡𝕡𝕠𝕣𝕥.",
        "ｂｉｔｃｈ ｉｍ ｏｎ ｍｙ ｄｅｍｏｎ ｔｉｍｅ  ♛ (◣_◢)",
        "𝐦𝐨𝐭𝐡𝐞𝐫 = 𝐞𝐧𝐭𝐢𝐭𝐲.𝐞𝐧𝐞𝐦𝐲_𝐦𝐨𝐭𝐡𝐞𝐫.𝐚𝐥𝐢𝐯𝐞() FALSE",
        "𝕪𝕠𝕦 𝕥𝕙𝕚𝕟𝕜 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖? 𝕚 𝕜𝕟𝕠𝕨 𝕔𝕙𝕖𝕖𝕤𝕖𝕔𝕒𝕥.𝕝𝕦𝕒",
        "𝕤𝕖𝕒𝕔𝕙𝕚𝕟𝕘 𝕞𝕠𝕥𝕙𝕖𝕣 𝕓𝕦𝕥 𝕕𝕠𝕟𝕥 𝕗𝕚𝕟𝕕𝕤 :-)",
        "𝕤𝕜𝕖𝕖𝕥.𝕔𝕔? 𝕍𝕀ℝ𝕌𝕊)",
        "𝕋𝔸𝕊𝕋𝔼 𝕄𝕐 𝕊ℙ𝔼ℝ𝕄 8==𝔻 ~~~",
        "𝕊𝕖𝕖 𝕒 𝕟𝕚𝕘𝕘𝕖𝕣, 𝕕𝕒𝕪 ℝ𝕌𝕀ℕ𝔼𝔻",
        "𝕡𝕦𝕤𝕙, 𝕜𝕚𝕝𝕝, 𝕜𝕚𝕝𝕝, 𝕓𝕒𝕚𝕥, 𝕂𝕀𝕃𝕃 ~ 𝕒𝕗𝕥𝕖𝕣𝕝𝕚𝕗𝕖𝕝𝕦𝕒.𝕩𝕪𝕫",
        "𝕥𝕣𝕪𝕖𝕤 𝕓𝕒𝕚𝕥𝕤 = 𝕕𝕠𝕟𝕥 𝕨𝕠𝕣𝕜 𝕠𝕟 𝕞𝕖 ;;))",
        "𝕦𝕟𝕞𝕒𝕥𝕔𝕙𝕖𝕣 𝕚𝕞 𝕨𝕚𝕟𝕟𝕖𝕥 )",
        "𝕌𝕨𝕌 𝕊𝕖𝕟𝕡𝕒𝕚~ (𝕚 𝕙𝕒𝕥𝕖 𝕟𝕚𝕘𝕘𝕖𝕣𝕤)",
        "𝕒𝕕𝕞𝕚𝕟 𝕥𝕙𝕚𝕟𝕜 𝕚𝕥𝕤 𝕜𝕚𝕝𝕝𝕤𝕒𝕪? 𝕚 𝕤𝕒𝕪 𝕚𝕥𝕤 𝕔𝕞𝕕 𝕔𝕠𝕞𝕞𝕒𝕟𝕕(◣_◢)(◣_◢)(◣_◢)",
        "𝖎𝖓𝖏𝖊𝖈𝖙 𝖆𝖋𝖙𝖊𝖗𝖑𝖎𝖋𝖊𝖑𝖚𝖆: 𝟏𝟎%, 𝟓𝟎%, 𝟏𝟎𝟎%",
        "𝐤𝐢𝐥𝐥𝐞𝐝 𝐛𝐲 𝐲𝐨𝐮𝐧𝐠 𝐜𝐞𝐨( ˘︹˘ ) (𝐢 𝐬𝐡𝐚𝐭 𝐦𝐲𝐬𝐞𝐥𝐟)",
        "dont try bait? (ㆆ_ㆆ)",
        "me mma BOXER king (ง︡'-'︠)ง",
        "𝙝𝙖𝙩𝙞𝙣𝙜? 𝙇𝙐𝘾𝙆𝙀𝙍𝙎 (◣◢)┌∩┐",
        "ESOTERIK t(>.<t)::SOUFIW (っ◔◡◔)っ ❤",
        "(►.◄) big man fatman (batman)",
        "（`_ゝ´) - nice bait (try of bait)",
        "v( ‘.’ )v resolver bosster ;)",
        "𝐋𝐮𝐜𝐤𝐤𝐢𝐧𝐠𝐬 𝐝𝐨𝐧𝐭 𝐡𝐚𝐯𝐞 𝐜𝐡𝐚𝐧𝐜𝐞 𝐯𝐬 𝐦𝐞 ( ≖.≖)",
        "𝙝𝙖𝙩𝙚𝙧 𝙨𝙖𝙮 𝙠𝙞𝙡𝙡𝙨𝙖𝙮? 𝙞 𝙨𝙖𝙮 𝙗𝙞𝙣𝙙 𝙇 '𝙨𝙖𝙮 𝙙𝙤𝙣𝙩 𝙩𝙧𝙮 𝙬𝙞𝙣'",
        "𝚐𝚊𝚖𝚎𝚜𝚎𝚗𝚜𝚎.𝚙𝚞𝚋? 𝚗𝚘, (ㆆ_ㆆ)",
        "LUCKERS DONT ♛♛♛",
        "ｍｙ ｃｏｃｋ ｃｈｉｌｌ ｒｎ: (─‿─)",
        "ｓｔｏｐ ｌｕｃｋ?? ＩＤＩＯＴＳ ⊂◉‿◉つ",
        "ｎｉｃｅ ｐｒａｙ ｆｏｒ ｌｕｃｋ (▼-▼*)",
        "༼⌐■ل͟■༽ ₖᵢₗₗ by ᵢgₒᵣ",
        "(ﾒ▼_▼) ռɛʋɛʀʟօֆɛ.ƈƈ (ﾒ▼_▼)",
        "♥ヽ༼☯﹏☯༽ﾉ L♥U♥C♥K♥Y♥ B♥A♥S♥T♥A♥R♥D♥O♥",
        "𝚗𝚘 𝚙𝚛𝚊𝚢 𝚏𝚘𝚛 𝚕𝚞𝚌𝚔𝚜 𝚙𝚕𝚣 (¬_¬)",
        "𝖆𝖓𝖙𝖎-𝖆𝖎𝖒 𝖙𝖊𝖈𝖍𝖓𝖔𝖑𝖔𝖌𝖎𝖊𝖘 𝖑𝖔𝖆𝖉𝖊𝖉 ╭∩╮(︶ε︶*)chu ",
        "𝚔𝚒𝚕𝚕𝚎𝚝 𝚋𝚢 𝚋𝚘𝚜𝚜 （＾＿−）",
        "ｓｍａｌｌ ｂｏｙ? ＢＩＧ ＢＯＹ (￣^￣)ゞ",
        "ᴹᴱᴿᶜᴱᴰᴱᶻ ᵇᵉⁿᶻ hxh",
        "(⊃‿⊂) ｆｒｏｇ",
        "𝖽𝗈𝗇𝗍 𝗍𝗋𝗒 𝖿𝗂𝗀𝗁𝗍 ༼ง ͠ຈ ͟ل͜ ͠ຈ༽o:[]:::::::>",
        "𝗉𝖾𝖽𝗈𝖻𝖾𝖺𝗋 ʕ•ᴥ•ʔ",
        "𝖾𝗌𝗍𝗄=◖⚆ᴥ⚆◗",
        "𝗒𝗈𝗎 𝗍𝗋𝗂𝖾𝗌 𝗈𝖿 𝗍𝗂𝗋𝖾𝖽? 𝖭𝖨𝖢𝖤 𝗃𝗈𝖻（´＿｀）",
        "𝗃𝗎𝗌𝗍 𝖽𝗂𝖽 𝗂𝗍 𝖿𝗈𝗋 𝗍𝗁𝖾 𝗅𝗎𝗅𝗓 𝗂𝗀 ≖‿≖",
        "𝒾 𝓂𝒶𝓀𝑒 𝓇𝓊𝓁𝑒𝓈, 𝓎𝑜𝓊 𝒻𝑜𝓁𝓁𝑜𝓌 (•‿•)",
        "(˵◕ω◕˵✿) 𝓂𝒶𝓎𝒷𝑒 𝓉𝓇𝓎 𝒽𝒶𝓇𝒹𝑒𝓇, 𝒷𝓊𝓉 𝒾'𝓂 𝒽𝒶𝓇𝒹𝑒𝓈𝓉",
        "𝕪𝕠𝕦 𝕤𝕖𝕖𝕜 𝕨𝕚𝕟𝕤? 𝕀 𝕕𝕖𝕝𝕚𝕧𝕖𝕣 𝕕𝕖𝕒𝕥𝕙.",
        "𝔩𝔦𝔣𝔢'𝔰 𝔞 𝔤𝔞𝔪𝔢, 𝔞𝔫𝔡 𝔶𝔬𝔲'𝔯𝔢 𝔩𝔬𝔰𝔦𝔫𝔤 (¬_¬)",
        "ｄｏｎ´ｔ ｗａｓｔｅ ｔｉｍｅ, ｙｏｕ´ｒｅ ｏｕｔ ｏｆ ｌｕｃｋ :)",
        "𝕋𝕙𝕚𝕟𝕜 𝕚𝕥'𝕤 𝕖𝕒𝕤𝕪? 𝕋𝕣𝕪 𝕞𝕖 (ง'̀-'́)ง",
        "𝕀'𝕄 𝕪𝕠𝕦𝕣 𝕟𝕚𝕘𝕙𝕥𝕞𝕒𝕣𝕖. 𝕎𝕒𝕜𝕖 𝕦𝕡? (¬‿¬)",
        "ｉｔ´ｓ ｔｉｍｅ ｔｏ ｄｉｅ, ｇａｍｅ ｏｎ ٩(◕‿◕｡)۶",
        "𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦 𝕔𝕒𝕟 𝕓𝕖𝕒𝕥 𝕞𝕖? 𝕋𝕙𝕚𝕟𝕜 𝕒𝕘𝕒𝕚𝕟! (◣_◢)",
        "𝕘𝕒𝕞𝕖'𝕤 𝕠𝕧𝕖𝕣, 𝕥𝕚𝕞𝕖 𝕗𝕠𝕣 𝕪𝕠𝕦𝕣 𝕖𝕟𝕕 :)",
        "𝒾 𝓂𝒶𝓀𝑒 𝓇𝓊𝓁𝑒𝓈, 𝓎𝑜𝓊 𝒻𝑜𝓁𝓁𝑜𝓌 (•‿•)",
        "(˵◕ω◕˵✿) 𝓂𝒶𝓎𝒷𝑒 𝓉𝓇𝓎 𝒽𝒶𝓇𝒹𝑒𝓇, 𝒷𝓊𝓉 𝒾'𝓂 𝒽𝒶𝓇𝒹𝑒𝓈𝓉",
        "𝕪𝕠𝕦 𝕤𝕖𝕖𝕜 𝕨𝕚𝕟𝕤? 𝕀 𝕕𝕖𝕝𝕚𝕧𝕖𝕣 𝕕𝕖𝕒𝕥𝕙.",
        "𝔩𝔦𝔣𝔢'𝔰 𝔞 𝔤𝔞𝔪𝔢, 𝔞𝔫𝔡 𝔶𝔬𝔲'𝔯𝔢 𝔩𝔬𝔰𝔦𝔫𝔤 (¬_¬)",
        "ｄｏｎ´ｔ ｗａｓｔｅ ｔｉｍｅ, ｙｏｕ´ｒｅ ｏｕｔ ｏｆ ｌｕｃｋ :)",
        "𝕋𝕙𝕚𝕟𝕜 𝕚𝕥'𝕤 𝕖𝕒𝕤𝕪? 𝕋𝕣𝕪 𝕞𝕖 (ง'̀-'́)ง",
        "𝕀'𝕄 𝕪𝕠𝕦𝕣 𝕟𝕚𝕘𝕙𝕥𝕞𝕒𝕣𝕖. 𝕎𝕒𝕜𝕖 𝕦𝕡? (¬‿¬)",
        "ｉｔ´ｓ ｔｉｍｅ ｔｏ ｄｉｅ, ｇａｍｅ ｏｎ ٩(◕‿◕｡)۶",
        "𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦 𝕔𝕒𝕟 𝕓𝕖𝕒𝕥 𝕞𝕖? 𝕋𝕙𝕚𝕟𝕜 𝕒𝕘𝕒𝕚𝕟! (◣_◢)",
        "𝕘𝕒𝕞𝕖'𝕤 𝕠𝕧𝕖𝕣, 𝕥𝕚𝕞𝕖 𝕗𝕠𝕣 𝕪𝕠𝕦𝕣 𝕖𝕟𝕕 :)",
        "𝗐𝗁𝗈'𝘀 𝘁𝗵𝗲 𝗻𝗲𝘄𝗯𝗶𝗲 𝗻𝗼𝘄? ┗(＾0＾)┓",
        "𝗍𝗁𝗶𝗻𝗸 𝗎 𝖼𝖺𝗇 𝖿𝗅𝗒? 𝗒𝗈𝗎'𝗋𝖾 𝗐𝗿𝗈𝗇𝗀. (︶︹︺)",
        "𝖳𝗋𝗒 𝗍𝗈 𝖽𝖾𝖿𝖾𝖺𝗍 𝗆𝖾? 𝖭𝖮𝖳 𝖳𝖮𝖣𝖠𝖸 ♛(◣_◢)",
        "𝖳𝗁𝖾 𝗋𝖾𝖺𝗅 𝗉𝗅𝖺𝗒𝖾𝗋𝗌 𝖺𝗋𝖾 𝗁𝖾𝗋𝖾 ◕‿↼",
        "𝗒𝗈𝗎 𝗍𝗁𝗶𝗇𝗄 𝗎 𝗄𝗇𝗈𝗐 𝗍𝗁𝖾 𝗀𝖺𝗆𝖾? 𝗍𝗁𝗂𝗇𝗄 𝖺𝗀𝖺𝗂𝗇. (─‿─)",
        "𝗀𝖺𝗆𝖾 𝗈𝗏𝖾𝗋, 𝖻𝗈𝗒𝗌 〠_〠",
        "𝗁𝗈𝗉𝖾 𝗎 𝖽𝗂𝖽𝗇'𝗍 𝖿𝗈𝗋𝗀𝖾𝗍 𝗍𝗈 𝗌𝖺𝗏𝖾, 𝗅𝗈𝗅 (っ◔◡◔)っ",
        "𝖺𝗐𝗐, 𝖽𝗈𝗇'𝗍 𝖼𝗋𝗒, 𝗂𝗍'𝗌 𝗃𝗎𝗌𝗍 𝖺 𝗀𝖺𝗆𝖾 ˘︹˘",
        "𝖿𝖾𝖾𝗅𝗌 𝗀𝗈𝗈𝖽 𝗍𝗈 𝖻𝖾 𝗍𝗁𝖾 𝗄𝗂𝗇𝗀 ♛",
        "𝖿𝖺𝖼𝖾 𝗂𝗍, 𝗎'𝗋𝖾 𝗃𝗎𝗌𝗍 𝖺 𝖻𝗂𝗀 𝖻𝗎𝗌𝗍 ˘︹˘",
        "𝔼𝕟𝕖𝕞𝕪 𝕓𝕖𝕝𝕚𝕖𝕧𝕖 𝕪𝕠𝕦'𝕣𝕖 𝕨𝕖𝕒𝕜? 𝕤𝕙𝕠𝕨 𝕥𝕙𝕖𝕞 𝕨𝕙𝕠'𝕤 𝕥𝕙𝕖 𝔹𝕆𝕊𝕊 (◣_◢)",
        "𝕄𝕒𝕥𝕔𝕙 𝕤𝕥𝕒𝕣𝕥𝕚𝕟𝕘, 𝕡𝕣𝕖𝕡𝕒𝕣𝕖 𝕥𝕠 𝔻𝕆𝕄𝕀ℕ𝔸𝕋𝔼 ♛",
        "𝔻𝕠𝕟´𝕥 𝕖𝕩𝕡𝕖𝕔𝕥 𝕖𝕒𝕤𝕪 𝕨𝕚𝕟𝕤, 𝕡𝕣𝕖𝕡𝕒𝕣𝕖 𝕗𝕠𝕣 𝕔𝕙𝕒𝕝𝕝𝕖𝕟𝕘𝕖. (ง︡'-'︠)ง",
        "ℍ𝕒𝕙𝕒, 𝕪𝕠𝕦 𝕥𝕙𝕠𝕦𝕘𝕙𝕥 𝕪𝕠𝕦 𝕨𝕚𝕟? 𝔻𝔼ℕ𝕀𝔼𝔻. （⌒▽⌒）",
        "ℂ𝕠𝕟𝕗𝕚𝕕𝕖𝕟𝕔𝕖 𝕚𝕤 𝕜𝕖𝕪, 𝕨𝕚𝕥𝕙𝕠𝕦𝕥 𝕚𝕥 𝕪𝕠𝕦´𝕣𝕖 𝕛𝕦𝕤𝕥 𝕒𝕟 𝕖𝕒𝕤𝕪 𝕥𝕒𝕣𝕘𝕖𝕥. 𝕂𝕖𝕖𝕡 𝕥𝕙𝕒𝕥 𝕚𝕟 𝕞𝕚𝕟𝕕 (◣_◢)",
        "𝕒𝕞 𝕓𝕠𝕞𝕓𝕖𝕣. 𝕤𝕒𝕗𝕖 𝕖𝕩𝕡𝕝𝕠𝕕𝕖 (⌐■_■)♛",
        "𝐮 𝐝𝐢𝐞𝐝? 𝐦𝐲 𝐭𝐚𝐜𝐭𝐢𝐜𝐬 𝐰𝐨𝐫𝐤𝐞𝐝 (◣_◢)",
        "𝔠𝔞𝔫'𝔱 𝔰𝔱𝔬𝔭 𝔪𝔢? 𝔠𝔞𝔱𝔠𝔥 𝔪𝔢 𝔣𝔦𝔯𝔰𝔱! (ʘ‿ʘ)",
        "𝙄'𝙢 𝙖 𝙗𝙖𝙞𝙩𝙚𝙧, 𝙮𝙤𝙪 𝙛𝙖𝙡𝙡? 𝙃𝙖! ♛",
        "𝕕𝕠𝕟'𝕥 𝕤𝕔𝕣𝕖𝕒𝕞, 𝕚𝕥'𝕤 𝕠𝕧𝕖𝕣 (‾⌣‾)♉",
        "𝙡𝙪𝙘𝙠 𝙞𝙨 𝙛𝙤𝙧 𝙡𝙤𝙨𝙚𝙧𝙨, 𝙄 𝙝𝙖𝙫𝙚 𝙨𝙠𝙞𝙡𝙡 (ᵔᴥᵔ)",
        "𝖞𝖔𝖚 𝖙𝖗𝖞 𝖙𝖔 𝖜𝖎𝖓? 𝖍𝖔𝖕𝖊 𝖞𝖔𝖚 𝖍𝖆𝖛𝖊 𝖆 𝖕𝖑𝖆𝖓 (•_•)∫",
        "𝖂𝖍𝖔'𝖘 𝖙𝖍𝖊 𝖇𝖔𝖘𝖘? 𝖄𝖔𝖚'𝖗𝖊 𝖑𝖔𝖔𝖐𝖎𝖓𝖌 𝖆𝖙 𝖍𝖎𝖒 (⌐■_■)⊃",
        "𝖙𝖍𝖎𝖓𝖐 𝖞𝖔𝖚'𝖗𝖊 𝖘𝖆𝖋𝖊? 𝕴'𝖒 𝖈𝖔𝖒𝖎𝖓𝖌 𝖋𝖔𝖗 𝖞𝖔𝖚 (╯°□°）╯︵ ┻━┻",
        "𝕙𝕒𝕙𝕒, 𝕦 𝕥𝕙𝕚𝕟𝕜 𝕦 𝕣 𝕤𝕒𝕗𝕖? ｔｈｉｎｋ ａｇａｉｎ (◣_◢)",
        "𝐃𝐚𝐝 𝐬𝐚𝐲𝐬, 𝐧𝐨 𝐩𝐥𝐚𝐲 𝐰𝐢𝐭𝐡 𝐟𝐨𝐨𝐥𝐬 - 𝐌𝐄 𝐑𝐔𝐋𝐄𝐑 (◣_◢)",
        "ｉ ｔｈｉｎｋ ｕ ａｒｅ ｂｌｉｎｄ? ",
        "𝐈'𝐦 𝐧𝐨𝐭 𝐲𝐨𝐮𝐫 𝐟𝐫𝐢𝐞𝐧𝐝, 𝐦𝐲 𝐠𝐮𝐧𝐬 𝐚𝐫𝐞 𝐋𝐎𝐀𝐃𝐄𝐃",
        "𝕤𝕥𝕠𝕡 𝕕𝕣𝕖𝕒𝕞𝕚𝕟𝕘, 𝕚𝕥'𝕤 𝕥𝕙𝕖 𝕣𝕖𝕒𝕝 𝕨𝕠𝕣𝕝𝕕 𝕠𝕦𝕥 𝕙𝕖𝕣𝕖, 𝕥𝕨𝕖𝕣𝕡.",
        "𝕤𝕠𝕦𝕟𝕕𝕤 𝕠𝕗 𝕪𝕠𝕦𝕣 𝕔𝕣𝕪𝕚𝕟𝕘, 𝕞𝕦𝕤𝕚𝕔 𝕥𝕠 𝕞𝕪 𝕖𝕒𝕣𝕤))",
        "𝕤𝕥𝕠𝕡 𝕔𝕣𝕪𝕚𝕟𝕘, 𝕚'𝕞 𝕛𝕦𝕤𝕥 𝕡𝕝𝕒𝕪𝕚𝕟𝕘 𝕥𝕙𝕖 𝕘𝕒𝕞𝕖 (◣_◢)",
        "ｕ ｔｈｉｎｋ ｉｍ ｓｏｆｔ? ｗａｉｔ ｔｉｌ ｉ ｓｈｏｗ ｍｙ ｒｅａｌ ｐｏｗｅｒ (◣_◢)",
        "𝕄𝔼 𝔹𝕀𝔾 𝔹𝕆𝕊𝕊, 𝔾𝔸𝕄𝔼𝔻𝔼𝔸𝔻. ♛",
        "(◣_◢) 𝓭𝓪𝓭𝓼𝓲𝓮𝓼 𝓼𝓪𝔂, 𝓷𝓸 𝓰𝓪𝓶𝓮𝓼𝓲𝓮𝓼 - 𝕀𝔸𝕄 𝕋ℍ𝔼 𝔹𝔼𝔸𝕊𝕋 (◣_◢)",
        "𝕪𝕠𝕦𝕣 𝔹ℝ𝔸𝕀ℕ 𝕨𝕣𝕠𝕟𝕘𝕚𝕖𝕕. ?",
        "𝕄𝔼 𝔹𝔼𝔸𝕋 𝔸𝕃𝕃, 𝔸𝕃𝕃 𝔻𝔼𝔸𝔻",
        "𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦𝕣 𝕎𝕀ℕ𝕀ℕ𝔾?. 𝕟𝕠𝕥𝕥𝕒.",
        "𝕕𝕠𝕟´𝕥 𝕤𝕚𝕝𝕖𝕟𝕔𝕖 𝕗𝕠𝕣 𝕕𝕖𝕒𝕥𝕙𝕪𝕖𝕝𝕝𝕤, 𝕞𝕒𝕟𝕦𝕒𝕝 𝕥𝕪𝕡𝕖))", 
        "𝕕𝕠𝕟𝕥 𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦𝕣 𝕎𝕀ℕℕ𝕀ℕ𝔾, 𝕀´𝕝𝕝 𝕣𝕠𝕝𝕝 𝔹𝕀𝔾 𝕥𝕣𝕦𝕔𝕜 (◣_◢)",
        "𝕟𝕠 𝕝𝕠𝕧𝕖 𝕗𝕠𝕣 𝕓𝕒𝕕𝕘𝕦𝕪𝕤, 𝕀´𝕞 𝕤𝕠𝕦𝕣𝕔𝕖 𝕚𝕟𝕛𝕖𝕔𝕥 𝕠𝕦𝕥𝕝𝕒𝕨 (◣_◢)",


    },
    
    deathsays = {
        "𝕚 𝕕𝕚𝕖 = 𝕖𝕟𝕖𝕞𝕪 𝕝𝕦𝕔𝕜 𝕓𝕠𝕤𝕤𝕥 -.-",
        "𝚕𝚞𝚌𝚔𝚢𝚌𝚏𝚐.𝚌𝚏𝚐 <-- 𝚒𝚝𝚜 𝚢𝚘𝚞𝚛? )",
        "𝕥𝕖𝕝𝕖𝕜𝕠𝕞 =  𝕝𝕒𝕘. 𝕘𝕘 𝕝𝕦𝕔𝕜𝕖𝕣",
        "𝕕𝕠𝕟𝕥 𝕥𝕙𝕚𝕟𝕜 𝕨𝕚𝕟... 𝕨𝕣𝕠𝕟𝕘?",
        "Luck only (͠◉_◉᷅ )",
        "𝘚𝘵𝘰𝘱 𝘵𝘩𝘪𝘯𝘬 𝘺𝘰𝘶𝘳𝘦 𝘤𝘩𝘢𝘯𝘤𝘦.. ( ≖.≖)",
        "my game freeze wow",
        "wtf my internet just turned off",
        "wrong cheats loaded. -> uninject fatality -> load soufiw",
        "𝘴𝘰𝘶𝘧𝘪𝘸 𝘯𝘦𝘦𝘥 𝘵𝘰 𝘯𝘦𝘳𝘧 𝘮𝘦 𝘨𝘨 (◣◢)┌∩┐",
        "fuker idiot tupoj (◣◢)┌∩┐",
        "me mad valla billa 凸(¬‿¬)凸",
        "trying to find ur cock: (≖_≖ )"
    },

    upper_to_lower = function(str)
        str1 = string.sub(str, 2, #str)
        str2 = string.sub(str, 1, 1)
        return str2:upper() .. str1:lower()
    end,

    text_gr = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
        local output = ''
        local len = #text - 1
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
        for i = 1, len + 1 do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
        return output
    end,

    calcdist = function(pos1, pos2)
        local lx = pos1.x
        local ly = pos1.y
        local lz = pos1.z
        local tx = pos2.x
        local ty = pos2.y
        local tz = pos2.z
        local dx = lx - tx
        local dy = ly - ty
        local dz = lz - tz
        return math.sqrt(dx * dx + dy * dy + dz * dz);
    end,

    lerp = function(time, a, b)
        return a * (1 - time) + b * time
    end,

    getbinds = function()
        local binds = {}
        local cheatbinds = ui.get_binds()
        
        for i = 1, #cheatbinds do
            table.insert(binds, 1, cheatbinds[i])
        end
        
        return binds
    end,

    get_spectators = function(player)
        local buffer = {}
        
        local players = player:get_spectators()
        for tbl_idx, player_pointer in pairs(players) do
            if player_pointer:get_index() ~= player:get_index() then
                if not player_pointer:is_alive() then
                    local player_info = player_pointer:get_player_info()

                    table.insert(buffer, 1, {
                        ['id'] = player_info.steamid,
                        ['id64'] = player_info.steamid64,
                        ['name'] = player_pointer:get_name(),
                        ['avatar'] = player_pointer:get_steam_avatar()
                    })
                end
            end
        end


        return buffer
    end,

    rgb_health_based = function(percentage)
        local r = 124*2 - 124 * percentage
        local g = 195 * percentage
        local b = 13
        return r, g, b
    end,

    remap = function(val, newmin, newmax, min, max, clamp)
        min = min or 0
        max = max or 1

        local pct = (val-min)/(max-min)

        if clamp ~= false then
            pct = math.min(1, math.max(0, pct))
        end

        return newmin+(newmax-newmin)*pct
    end,

    roundedrect = function(x, y, w, h, radius, r, g, b, a) 
        render.rect(vector(x, y), vector(x + w, y + h), color(r, g, b, a), radius, true)
    end,
    
    fadedroundedrect = function(x, y, w, h, radius, r, g, b, a, glow) 
        local n = a/255*45;
        render.rect(vector(x + radius, y), vector(x + radius + w-radius*2, y + 1), color(r, g, b, a), 0, true)
        render.circle_outline(vector(x + radius, y + radius), color(r, g, b, a), radius, 180, 0.25)
        render.circle_outline(vector(x + w - radius, y + radius), color(r, g, b, a), radius, 270, 0.25)
        render.gradient(vector(x, y + radius), vector(x + 1, y + radius + h - radius * 2), color(r, g, b, a), color(r, g, b, a), color(r, g, b, n), color(r, g, b, n), 0)
        render.gradient(vector(x + w - 1, y + radius), vector(x + w, y + radius + h - radius * 2), color(r, g, b, a), color(r, g, b, a), color(r, g, b, n), color(r, g, b, n), 0)
        render.circle_outline(vector(x + radius, y + h - radius), color(r, g, b, n), radius, 90, 0.25)
        render.circle_outline(vector(x + w - radius, y + h - radius), color(r, g, b, n), radius, 0, 0.25)
        render.rect(vector(x + radius, y + h - 1), vector(x + radius + w - radius * 2, y + h), color(r, g, b, n), 0, true)
    end 

}

functions.entity_list_pointer = ffi.cast('void***', utils.create_interface('client.dll', 'VClientEntityList003'))
functions.get_client_entity_fn = ffi.cast('GetClientEntity_4242425_t', functions.entity_list_pointer[0][3])

functions.get_entity_address = function(ent_index)
    local addr = functions.get_client_entity_fn(functions.entity_list_pointer, ent_index)
    return addr
end

local ffi_helpers = {
    _pct = function(_, __, ___, ____)
        return ffi.C.VirtualProtect(ffi.cast('void*', _), __, ___, ____)
    end,
    _c = function(_, __, ___)
        return ffi.copy(ffi.cast('void*', _), ffi.cast('const void*', __), ___)
    end,
    _alc = function(lpAddress, dwSize, flAllocationType, flProtect, blFree)
    local _all = ffi.C.VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect)
    if blFree then
        table.insert(buff.free, function()
        ffi.C.VirtualFree(_all, 0, 0x8000)
        end)
    end
    return ffi.cast('intptr_t', _all)
end
}


functions.container = function(x, y, w, h, r, g, b, a, alpha, fn) 
    functions.roundedrect(x, y, w, h, 4, 17, 17, 17, a)
    functions.fadedroundedrect(x, y, w, h, 4, r, g, b, alpha*255, alpha*20)

    --render.rect_outline(vector(x, y), vector(x + w, y + h), color(r, g, b, alpha*255), 0, 3, true)


    --render.rect(vector(x, y), vector(x + w, y + (h - 1)), color(42, 42, 42, 255), 4, true)

end

functions.container2 = function(x, y, w, h, r, g, b, a, alpha, fn) 



    local _rnd = { 1, 0 }
    render.rect(vector(x , y), vector(x + w, y + h), color(17, 17, 17, 150), _rnd[1], true)
    functions.fadedroundedrect(x, y, w, h, _rnd[2], r, g, b, alpha*255, alpha*20)
    render.shadow(vector(x, y), vector(x + w, y + h), color(r, g, b, alpha*150), 20, 0, _rnd[1])

end

functions.info_spectators = function()
    if not globals.is_connected or entity.get_local_player() == nil or entity.get_local_player() == nil then return end
    local localplayer = entity.get_local_player()
    if localplayer == nil then return end

    if localplayer:is_alive() then
        return functions.get_spectators(entity.get(localplayer))
    else
        local m_iObserverMode = localplayer['m_iObserverMode']
        local m_hObserverTarget = localplayer['m_hObserverTarget']
        if m_hObserverTarget ~= nil then
            if localplayer['m_iObserverMode'] == 6 then 
                return 
            end
            if m_hObserverTarget and m_hObserverTarget:is_player() then
                return functions.get_spectators(m_hObserverTarget)
            end
        end
    end
end

function theme_color()
    return "\a" .. ui.get_style("Link Active"):to_hex()
end

local tabs = {
    global = {
        a = pui.create(theme_color() .. "\f<globe>", theme_color() .. "\f<globe>\r Get Started", 2),
        -- β = pui.create(theme_color() .. "\f<globe>", theme_color() .. "\f<circle-info> \rWhere Options", 2),
        b = pui.create(theme_color() .. "\f<globe>", theme_color() .. "\rConfiguration Options", 1),
        γ = pui.create(theme_color() .. "\f<globe>", theme_color() .. "\f<globe> \rUsefull Stuffs", 3),
    },

    ragebot = {
        a = ui.find("Aimbot", "Anti Aim", "Misc"),
        b = ui.find("Aimbot", "Anti Aim", "Angles")
    },

    visuals = {
        a = pui.create(theme_color() .. "\f<eye>", theme_color() .. "\f<paintbrush> \rVisuals")
    },

    misc = {
        a = pui.create(theme_color() .. "\f<eye>","\rMisc"),
        b = pui.create(theme_color() .. "\f<eye>","\rMisc"),
        m = pui.create(theme_color() .. "\f<eye>","\rMisc"),
    }
}
local accepted = false
local dbdata = db.afterlife_terms_of_service or {}

local default_config = {author = {"default"},date = {"-"},n = {"Default"},cfg = {""}}

files.create_folder("csgo/afterlife")
if(files.read('csgo/afterlife/configs.txt') == nil) then
    files.write('csgo/afterlife/configs.txt', json.stringify(default_config))
end

local config_data = json.parse(files.read('csgo/afterlife/configs.txt'))

local menu = {

    global = {
            
        cfg_list = tabs.global.b:list("", config_data.n),
        cfg_info = tabs.global.b:label("Author: " .. theme_color() .. "\n" .. "Config update: " .. theme_color()),
        cfg_name = tabs.global.b:input("Config name", ""),
        load_cfg = tabs.global.b:button(theme_color() .. ui.get_icon("file-arrow-up") .. " \rLoad", function()
            load_cfg()
        end, true),
        create_cfg = tabs.global.b:button(theme_color() .. ui.get_icon("plus") .. " \rCreate", function()
            create_cfg()
        end, true),
        save_cfg = tabs.global.b:button(theme_color() .. ui.get_icon("floppy-disk") .. " \rSave", function()
            save_cfg()
        end, true),
        delete_cfg = tabs.global.b:button(theme_color() .. ui.get_icon("trash") .. " \rDelete", function()
            remove_cfg()
        end, true),
        cfg_import = tabs.global.b:button(theme_color() .. ui.get_icon("file-import") .. " \rImport Config", function()
            import_cfg()
        end, true),
        cfg_export = tabs.global.b:button(theme_color() .. ui.get_icon("file-export") .. " \rExport Config", function()
            export_cfg()
        end, true),
        
        tabs.global.a:label(ui.get_icon('angle-right') .. '\aDEFAULT Welcome Back, '..functions.text_gr(ui.get_style("Button").r,ui.get_style("Button").g, ui.get_style("Button").b, ui.get_style("Button").a, 200, 200, 200, 255, lua.username)),
        tabs.global.a:label(ui.get_icon('angle-right') .. '\aDEFAULT Last Update Time: '..functions.text_gr(ui.get_style("Button").r,ui.get_style("Button").g, ui.get_style("Button").b, ui.get_style("Button").a, 200, 200, 200, 255, "15.04.23")),
        -- tabs.global.β:label("All of our script's options are integrated accordingly in the neverlose menu. eg. Visual Options is located in Visuals/Main.\n\nWe have also labeled all of our options so you can tell if it's the script's or the cheat's."),
        
        -- export = tabs.global.b:button('\a'..ui.get_style("Button"):alpha_modulate(255):to_hex()..''..ui.get_icon('right-from-bracket') .. '\a'..ui.get_style("Text"):alpha_modulate(255):to_hex()..'  Export', function() end, true),
        -- import = tabs.global.b:button('\a'..ui.get_style("Button"):alpha_modulate(255):to_hex()..''..ui.get_icon('right-to-bracket') .. '\a'..ui.get_style("Text"):alpha_modulate(255):to_hex()..'  Import', function() end, true),
        -- default = tabs.global.b:button('\a'..ui.get_style("Button"):alpha_modulate(255):to_hex()..''..ui.get_icon('cloud') .. '\a'..ui.get_style("Text"):alpha_modulate(255):to_hex()..'  Default', function() end, true),
        
        
        tabs.global.γ:button('               \a'..ui.get_style("Button"):alpha_modulate(255):to_hex()..''..ui.get_icon('discord')..'\aDEFAULT  Join Our Discord Server              ', function ()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL('https://discord.gg/y26V2rGtbJ')
        end, true),
        tabs.global.γ:button('                                   \a'..ui.get_style("Button"):alpha_modulate(255):to_hex()..''..ui.get_icon('heart')..'\aDEFAULT  FBP+                               ', function ()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL('https://en.neverlose.cc/market/item?id=N9mpqQ')
        end, true),
        tabs.global.γ:button('                 \a'..ui.get_style("Button"):alpha_modulate(255):to_hex()..''..ui.get_icon('clipboard')..'\aDEFAULT  Neverlose Configuration             ', function ()
            math.randomseed(common.get_timestamp())
            local chance = math.random(0,10)
            if chance > 5 then
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=z3fvs1")
            else
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=CkYYDl")
            end
        end, true),
        tabs.global.γ:button('                          \a'..ui.get_style("Button"):alpha_modulate(255):to_hex()..''..ui.get_icon('triangle-exclamation')..'\aDEFAULT  Don\'t Click Me                      ', function ()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL('https://youtu.be/dQw4w9WgXcQ?t=43.5s')
        end, true),
        tos1 = tabs.global.a:label("\aFFFFFFFFTerms of Service of AfterLife.lua:\nBy using this script you consent to us collecting your neverlose username, your ipv4, your ipv6 for researching and other purposes."),
        tos2 = tabs.global.a:button('\a49be25FFAccept '..ui.get_icon("check"), function ()
            print(k)
            dbdata.accepted = true
            tosagreed()
        end, true),
        
        tos3 = tabs.global.a:button('\aFf0005FFDecline '..ui.get_icon("xmark-large"), function ()
            print("Don't care lfmao it wasnt a question")
            dbdata.accepted = true
            tosagreed()
        end, true),
    },

    -- ragebot = {
    --     technologysymbol = tabs.ragebot.b:label("\aFFFFFFFF          Afterlife Anti-Aims\a"..ui.get_style("Button"):alpha_modulate(255):to_hex().." Technologies™\n "),
    -- },

    visuals = {
        -- realtweakers = kfg_sys.new_element("visuals_options", tabs.visuals.a:selectable("Visual Opts", { 'Hit-Logs', 'Velocity Warning', 'Watermark', 'Custom Scope', 'Crosshair Indicator', 'Solus UI', '500$ Features', 'Debug Panel'})),
        velocity_warning_enable = tabs.visuals.a:switch('Velocity Warning'),
        watermark_enable = tabs.visuals.a:switch('Watermark'),
        custom_scope_enable = tabs.visuals.a:switch("Custom Scope"),
        crosshair_indicator_enable = tabs.visuals.a:switch("Crosshair Indicator"),
        solus_ui_enable = tabs.visuals.a:switch("Solus UI"),
        debug_panel_enable = tabs.visuals.a:switch("Debug Panel"),
        gamesense_enable = tabs.visuals.a:switch("\aFFFFFFFFGame\a9fca2bffSense"),
    },

    misc = {
        tweakers = kfg_sys.new_element("misc_tweaks", tabs.misc.a:selectable("Shit-Talk", { 'When eliminated an opponent' , 'When died' })),
        viewmodel = kfg_sys.new_element("misc_viewmodel", tabs.misc.b:switch("Viewmodel")),
        aspectratio = kfg_sys.new_element("misc_aspectratio_switch", tabs.misc.b:switch("Aspect Ratio")),
        fastladder = kfg_sys.new_element("misc_fastladder", tabs.misc.m:switch("Fast Ladder")),
        airstrafe = kfg_sys.new_element("misc_fastladder", tabs.misc.m:switch("Jump-Scout Fix")),
        hitlogs_enable = tabs.misc.m:switch('Hit-Logs'),
    }
}



if dbdata.accepted then
    for k,v in pairs(menu.global) do
        if not string.match(k, "tos") then
            v:visibility(true)
        else
            v:visibility(false)
        end
    end
else
    for k,v in pairs(menu.global) do
        if not string.match(k, "tos") then
            v:visibility(false)
        end
    end
end

tosagreed = function()
    db.afterlife_terms_of_service = dbdata
    for k,v in pairs(menu.global) do
        if not string.match(k, "tos") then
            v:visibility(true)
        else
            v:visibility(false)
        end
    end
end

menu.corner_sttings = menu.visuals.velocity_warning_enable:create()
menu.hit_log_settings = menu.misc.hitlogs_enable:create()
menu.solus_settings = menu.visuals.solus_ui_enable:create()
menu.viewmodel_settings = menu.misc.viewmodel:create()
menu.indicator_settings = menu.visuals.crosshair_indicator_enable:create()
menu.skeet_indicator_settings = menu.visuals.gamesense_enable:create()


menu.inds500 = menu.skeet_indicator_settings:selectable("Options", { 'Indicators', 'Spectators', 'Hitmarker', 'Clantag' })
menu.aspectratio_settings = menu.misc.aspectratio:create()
menu.custom_scope_settings = menu.visuals.custom_scope_enable:create()

menu.custom_scope_gap = kfg_sys.new_element("custom_scoep_gap", menu.custom_scope_settings:slider("Scope Gap", -300, 300, 15))
menu.custom_scope_length = kfg_sys.new_element("custom_scope_length", menu.custom_scope_settings:slider("Scope Length", 0, 300, 150))
menu.custom_scope_color = kfg_sys.new_element("custom_scope_color", menu.custom_scope_settings:color_picker("Scope Color", color(255, 255, 255, 255)), true)

menu.aspectratio_value = kfg_sys.new_element("aspectratio_value", menu.aspectratio_settings:slider("Value", 0, 20, 0, 0.1))



menu.skeet_indicator_features = kfg_sys.new_element("skeet_indicator_features", menu.skeet_indicator_settings:selectable("500$ Elements", { 'Force safe point', 'Force body aim', 'Ping spike', 'Double tap', 'Duck peek assist', 'Freestanding', 'Bomb info', 'Min. damage', 'Onshot', 'Dormant aimbot', 'Hitchance', 'Lag comp', 'Fake angle' }))
-- menu.hitlogs_color = kfg_sys.new_element("hitlogs_color", menu.hit_log_settings:color_picker("Hit-Logs Color", color(125)), true)
-- menu.hitlogs_style = kfg_sys.new_element("hitlogs_style", menu.hit_log_settings:combo("Hit-Logs Style", {"Rounded", "Boxed"}))
menu.logs = kfg_sys.new_element("misc_enabled_logs", menu.hit_log_settings:selectable("Logs", { 'Ragebot', 'Buy Stuffs', 'Anti-Bruteforce', 'Console' }))

menu.velocity_warning_color = kfg_sys.new_element("velocity_warning_color", menu.visuals.velocity_warning_enable:create():color_picker("Velocity Warning", color(69)), true)

menu.indicators_theme = kfg_sys.new_element("indicators_theme", menu.visuals.crosshair_indicator_enable:create():combo('Crosshair theme', { 'Original', 'Technology', 'Old' }))

menu.watermark_color = kfg_sys.new_element("watermark_color", menu.visuals.watermark_enable:create():color_picker("Watermark Accent Color", color(69)), true)
menu.advertisement = kfg_sys.new_element("advertisement", tabs.misc.a:switch("Advertisement", true))

menu.viewmodel_fov = kfg_sys.new_element("viewmodel_fov", menu.viewmodel_settings:slider('Viewmodel FOV', -100, 100, 0, 1))
menu.viewmodel_x = kfg_sys.new_element("viewmodel_x", menu.viewmodel_settings:slider('Viewmodel X', -100, 100, 0, 1))
menu.viewmodel_y = kfg_sys.new_element("viewmodel_y", menu.viewmodel_settings:slider('Viewmodel Y', -100, 100, 0, 1))
menu.viewmodel_z = kfg_sys.new_element("viewmodel_z", menu.viewmodel_settings:slider('Viewmodel Z', -100, 100, 0, 1))

menu.elements = menu.solus_settings:selectable("Solus UI", { 'Watermark', 'Spectators', 'Keybinds' })

menu.ui_cheattext = menu.solus_settings:input('Cheat name', 'AFTERLIFE')
menu.ui_usertext = menu.solus_settings:input('Username', 'SICUNATOS x ME BO$$')
menu.solus_theme = kfg_sys.new_element("solus_theme", menu.solus_settings:combo('Theme', { 'v1', 'v2', 'v2.5' }))
menu.ui_accent_color = kfg_sys.new_element("solus_color", menu.solus_settings:color_picker('Global color', ui.get_style("Button"):alpha_modulate(155)), true)
menu.ui_keybinds_x = kfg_sys.new_element("keybinds_x", menu.solus_settings:slider('keybinds_x', 1, render.screen_size().x, render.screen_size().x / 2 - 250, '', ''))
menu.ui_keybinds_y = kfg_sys.new_element("keybinds_y", menu.solus_settings:slider('keybinds_y', 1, render.screen_size().y, render.screen_size().y / 2 - 50, '', ''))
menu.ui_spectators_x = kfg_sys.new_element("spectators_x", menu.solus_settings:slider('spectators_x', 1, render.screen_size().x, render.screen_size().x / 2 - 550, '', ''))
menu.ui_spectators_y = kfg_sys.new_element("spectators_y", menu.solus_settings:slider('spectators_y', 1, render.screen_size().y, render.screen_size().y / 2 - 50, '', ''))
menu.ind_color = kfg_sys.new_element("ind_color", menu.indicator_settings:color_picker('Main Color', ui.get_style("Button"):alpha_modulate(255)), true)
menu.ind_color2 = kfg_sys.new_element("ind_color2", menu.indicator_settings:color_picker('Secondary Color', ui.get_style("Active Text"):alpha_modulate(255)), true)
menu.ind_colorglow = kfg_sys.new_element("ind_colorglow", menu.indicator_settings:color_picker('Glow Color', ui.get_style("Active Text"):alpha_modulate(255)), true)
menu.crosshair_options = kfg_sys.new_element("crosshair_options", menu.indicator_settings:selectable("\aFFFFFFFFCrosshair Elmts.", { 'Lua name', 'Desync line', 'Player state', 'Doubletap', 'Onshot', 'Duck peek assist', 'Force body aim', 'Force safe point', 'Min. Damage' }))
menu.hctype = kfg_sys.new_element("hitchance_mode", menu.skeet_indicator_settings:combo('Hitchance mode', { 'On hotkey' , 'Always on' }))
menu.hctext = menu.skeet_indicator_settings:input('Hitchance type', 'Hitchance: ')
menu.hccolor = kfg_sys.new_element("hitchance_color", menu.skeet_indicator_settings:color_picker('Hitchance color', color(255, 255, 255, 255)), true)
menu.hcempty = menu.skeet_indicator_settings:label(' ')
menu.dmgtype = kfg_sys.new_element("damage_mode", menu.skeet_indicator_settings:combo('Damage mode', { 'On hotkey' , 'Always on' }))
menu.dmgtext =  menu.skeet_indicator_settings:input('Damage type', '')
menu.dmgcolor = kfg_sys.new_element("damage_color", menu.skeet_indicator_settings:color_picker('Damage color', color(255, 255, 255, 255)), true)


local ffi_handler = {}
local clantag_spammer = {}

ffi_handler.bind_argument = function(fn, arg)
    return function(...)
        return fn(arg, ...)
    end
end

ffi_handler.sigs = {
    set_clantag = {"engine.dll", "53 56 57 8B DA 8B F9 FF 15"}
}

ffi_handler.set_clantag = ffi.cast("int(__fastcall*)(const char*, const char*)", utils.opcode_scan(ffi_handler.sigs.set_clantag[1], ffi_handler.sigs.set_clantag[2]))


clantag_spammer.cache = nil
clantag_spammer.set = function(str)
    if str ~= clantag_spammer.cache then
        ffi_handler.set_clantag(str, str)
        clantag_spammer.cache = str
    end
end

clantag_spammer.clear = function()
    clantag_spammer.set("")
end

time_to_ticks = function(t)
    return math.floor(0.4 + (t / globals.tickinterval))
end

clantag_spammer.anim = function(text, indices)
	local text_anim = "               " .. text .. "                      " 
	local tickinterval = globals.tickinterval
    local net_channel = utils.net_channel()

    if net_channel == nil then
        return ""
    end

	local tickcount = globals.tickcount + time_to_ticks(net_channel.latency[0])
	local i = tickcount / time_to_ticks(0.3)

	i = math.floor(i % #indices)
	i = indices[i + 1] + 1

	return string.sub(text_anim, i, i + 15)
end

events.render:set(function ()
    --gs clantag function
    if not menu.inds500:get(4) then
        return
    end

    if not globals.is_connected then
        return
    end

    if not globals.is_in_game then
        return
    end

    local text = clantag_spammer.anim("gamesense", {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22})

    if text == nil then
        return
    end

    clantag_spammer.set(text)
end)


local bold_font = render.load_font("Verdana Bold", 13, "ad") -- Added "a" for anti-aliasing

local topleftlogs = {}
functions.log = function(string)
    local cumcolor = menu.ui_accent_color:get():to_hex()
    cumcolor = cumcolor:sub(1, -3)
    if not string.match(string, "[+]") and not string.match(string, "[-]") and not string.match(string, "Knifed for damage") and not string.match(string, "Burned for damage") and not string.match(string, "Naded for damage") then
        print_raw('\a'..cumcolor..'[afterlife] \a868686» \aDEFAULT' .. string)
    end
    -- print_dev(string)
    -- table.insert(topleftlogs, {info = string, time = common.get_unixtime()})
    table.insert(topleftlogs, {message = string, alpha = 0, creation_time = globals.realtime})
end

events.render:set(function(ctx)
    -- local y = 0
    -- local scale = render.get_scale(2)
    -- for i, hit in ipairs(topleftlogs) do
    --     if common.get_unixtime() - hit.time <= 5 then
    --         local text_size = render.measure_text(bold_font, hit.info)
    --         render.text(bold_font, vector(10 * scale, y), color(255, 255, 255, 255), nil, hit.info)
    --         y = y + text_size.y + 13
    --     else
    --         table.remove(topleftlogs, i)
    --     end
    -- end



    local distance_to_add = 0
	local last_render_position = 0
    local timeNow = globals.realtime
	-- rescale_fonts()
	for i = 1, #topleftlogs
	do
		if not(topleftlogs[i] == nil) then
			if(topleftlogs[i].creation_time > timeNow) or  (topleftlogs[i].alpha <= 0 and timeNow - topleftlogs[i].creation_time > 2) then
				table.remove(topleftlogs, i)
			else
			if(i >= 15) then
					topleftlogs[i].creation_time = timeNow
				end

				if(topleftlogs[i].alpha < 255) and (timeNow - topleftlogs[i].creation_time < 5) and (i < 15) then
					topleftlogs[i].alpha = topleftlogs[i].alpha + 5
				end 

				if(timeNow - topleftlogs[i].creation_time > 5) and (topleftlogs[i].alpha > 0) then
					topleftlogs[i].alpha = topleftlogs[i].alpha - 5
				end

				if(topleftlogs[i].alpha > 0) then

					local distance_modifier = topleftlogs[i].alpha / 255

					render.text(bold_font, vector(5, last_render_position + distance_to_add), color(255, 255, 255, topleftlogs[i].alpha), "s", topleftlogs[i].message)


					last_render_position = last_render_position + distance_to_add
					distance_to_add = 15 * distance_modifier

				end

			end
		end
	end
end)


local cheat = {
    dormantaim = ui.find('Aimbot', 'Ragebot', 'Main', 'Enabled', 'Dormant Aimbot'),
    doubletap = ui.find('aimbot', 'ragebot', 'main', 'double tap'),
    fakeduck = ui.find('aimbot', 'anti aim', 'misc', 'fake duck'),
    hideshots = ui.find('aimbot', 'ragebot', 'main', 'hide shots'),
    hitchance = ui.find('Aimbot', 'Ragebot', 'Selection', 'Hit Chance'),
    bodyyaw = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw'),
    slowwalk = ui.find('aimbot', 'anti aim', 'misc', 'slow walk'),
    safepoint = ui.find('aimbot', 'ragebot', 'safety', 'safe points'),
    bodyaim = ui.find('aimbot', 'ragebot', 'safety', 'body aim'),
    aa_pitch = ui.find('aimbot', 'anti aim', 'angles', 'pitch'),
    pingspike = ui.find('miscellaneous', 'main', 'other', 'fake latency'),
    mindamage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    freestand = ui.find('aimbot', 'anti aim', 'angles', 'freestanding'),
    yaw = ui.find('aimbot', 'anti aim', 'angles', 'yaw', 'offset'),
    yaw_base = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Base'),
    yaw_set = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw'),
    yaw_modifier = ui.find('aimbot', 'anti aim', 'angles', 'yaw modifier'),
    yaw_degree = ui.find('aimbot', 'anti aim', 'angles', 'yaw modifier', 'offset'),
    yaw_fakeopt = ui.find('aimbot', 'anti aim', 'angles', 'body yaw', 'options'),
    yaw_freestand = ui.find('aimbot', 'anti aim', 'angles', 'body yaw', 'freestanding'),
    yaw_desync_left = ui.find('aimbot', 'anti aim', 'angles', 'body yaw', 'left limit'),
    yaw_desync_right = ui.find('aimbot', 'anti aim', 'angles', 'body yaw', 'right limit'),
    legmovement = ui.find('Aimbot', 'Anti Aim', 'Misc', 'Leg Movement')
}



local animationas = {}

animationas.base_speed = 8.0
animationas._list = {}
animationas.new = function(name, new_value, speed, init)
    speed = speed or animationas.base_speed
    
    local is_color = type(new_value) == "userdata"

    if animationas._list[name] == nil then
        animationas._list[name] = (init and init) or (is_color and color(255) or 0)
    end

    local interp_func

    if is_color then
        interp_func = math.color_lerp
    else
        interp_func = math.lerp
    end

    animationas._list[name] = interp_func(animationas._list[name], new_value, speed)
    
    return animationas._list[name]
end


colored_text = function(...)
    local data = {...}
    local str = ""

    for k, v in pairs(data) do
        local text = v[1]
        local clr = ""

        if text:find("icon_") then
            text = ui.get_icon(text:gsub("icon_", ""))
        end

        text = text or "nil"

        if v[2] == nil then
            v[2] = "DEFAULT"
        end

        if type(v[2]) == "userdata" then
            v[2] = v[2]:to_hex()
            clr = ("\a%s"):format(v[2])
        else
            clr = "\a" .. v[2]
        end

        str = str .. clr .. text
    end

    return str
end



function leerp(start, vend, time)
    return start + (vend - start) * time
end

is_in_bounds = function(vec1, vec2)
    local mouse_pos = ui.get_mouse_position()
    return mouse_pos.x >= vec1.x and mouse_pos.x <= vec2.x and mouse_pos.y >= vec1.y and mouse_pos.y <= vec2.y 
end


function tointeger(n)
	return math.floor(n + 0.5)
end

local dragging = false
local x, y = render.screen_size().x, render.screen_size().y 

local vel_x = kfg_sys.new_element("velocity_x", menu.corner_sttings:slider("x", 0, x, 20):visibility(false))
local vel_y = kfg_sys.new_element("velocity_y", menu.corner_sttings:slider("y", 0, y, 20):visibility(false))
local a_width = 0
local vel_dragging = false
local debug_dragging = false
local dragging_vel = false
local vel_offset = vector(0, 0)
events.render:set(function ()   
    local player = entity.get_local_player()

    if player == nil then
        player = {}
        player.is_nil = true
        player.m_flVelocityModifier = 1.0
    end
    local playerisalive = false

    if not player.is_nil then
        playerisalive = player:is_alive()
    else
        playerisalive = true
    end

    local velocity_indication_enable = menu.visuals.velocity_warning_enable:get()
    local velocity_indication_color = menu.velocity_warning_color:get()
    local pos = vector(vel_x:get(), vel_y:get())

    local m_flVelocityModifier = animationas.new("m_flVelocityModifier", ui.get_alpha() > 0 and player.m_flVelocityModifier == 1 and 0.5 or playerisalive and player.m_flVelocityModifier or 1)

    
    local anim = {}

    local add_y = 0

    local size = vector(120, 0)

    anim.velocity = animationas.new("velocator_indicator", velocity_indication_enable and (ui.get_alpha() > 0.5 and 255 or m_flVelocityModifier < 0.9 and 255 or 0) or 0)

    
    size.y = size.y + anim.velocity/255*29

    if anim.velocity > 1 then
        local text = colored_text({"Slowed Down By "}, {tostring(tonumber(100 - math.floor(m_flVelocityModifier*100))), velocity_indication_color}, {"%"})

        render.text(1, vector(pos.x + 48, pos.y + add_y), color(255):alpha_modulate(anim.velocity), nil, text)
        render.shadow(vector(pos.x + 4, pos.y + add_y + 19), vector(pos.x + 196, pos.y + add_y + 25), velocity_indication_color:alpha_modulate(anim.velocity), 20, 0)
        render.rect(vector(pos.x + 4, pos.y + add_y + 19), vector(pos.x + 196, pos.y + add_y + 25), color(0, 255):alpha_modulate(anim.velocity/2), 2)
        render.rect(vector(pos.x + 5, pos.y + add_y + 20), vector(pos.x + m_flVelocityModifier*190 + 5, pos.y + add_y + 24), velocity_indication_color:alpha_modulate(anim.velocity), 2)
        render.rect_outline(vector(pos.x + 4, pos.y + add_y + 19), vector(pos.x + 196, pos.y + add_y + 25), color(0, 255):alpha_modulate(anim.velocity), 2)

        anim.menu = animationas.new("velocator_indicator_alpha", velocity_indication_enable and ui.get_alpha() > 0.5 and 255 or 0)
        
        if anim.menu > 1 then
            render.rect_outline(vector(pos.x - size.x / 10.75, pos.y - size.y), vector(pos.x + size.x * 1.75, pos.y + size.y + 40), color(255):alpha_modulate(anim.menu), 1, 6)
        end
        
        if is_in_bounds(vector(pos.x - size.x / 10.75, pos.y - size.y), vector(pos.x + size.x * 1.75, pos.y + size.y + 40)) then
            hover_over_element = true
        end
        
    end


	if common.is_button_down(0x01) and ui.get_alpha() == 1 and not dragging then
		local mouse_position = ui.get_mouse_position()
		if dragging_vel == false and vel_dragging == false and is_in_bounds(vector(pos.x - size.x / 10.75, pos.y - size.y), vector(pos.x + size.x * 1.75, pos.y + size.y + 40)) then
			vel_offset.x = mouse_position.x - vel_x:get()
			vel_offset.y = mouse_position.y - vel_y:get()
			vel_dragging = true
		end
		if vel_dragging == true then
			vel_x:set(mouse_position.x - vel_offset.x)
			vel_y:set(mouse_position.y - vel_offset.y)
		end
    elseif common.is_button_down(0x02) and ui.get_alpha() == 1 and is_in_bounds(vector(pos.x - size.x / 10.75, pos.y - size.y), vector(pos.x + size.x * 1.75, pos.y + size.y + 40)) then
        vel_x:set((render.screen_size().x/2 - size.x / 2) - 45)
	else
		vel_dragging = false
	end
    
end)



-- Infopanel

local drag_offset = vector(0, 0)

--x and y axis of the screen
local x, y = render.screen_size().x, render.screen_size().y

--creating sliders in the menu and hiding them so we can drag
local pos_x = kfg_sys.new_element("watermark_x", menu.corner_sttings:slider("x", 0, x, 20):visibility(false))

local pos_y = kfg_sys.new_element("watermark_y", menu.corner_sttings:slider("y", 0, y, y/2-50):visibility(false))
--

--main state panel function

function state_panel()
    --if enable panel switch is not enabled then stop
    if not menu.visuals.watermark_enable:get() then
        return
    end

    local textsize = render.measure_text(1, nil, ">\\ afterlife.lua anti-aims technologies").x

    --script text
    local technology_text = gradient.text_animate("technologies", -1.5, {
        color(255,255,255), 
        color(95,95,95)
    })

    local anim = {}
    
    anim.watermark = animationas.new("watermark_alpha", menu.visuals.watermark_enable:get() and ui.get_alpha() > 0.5 and 255 or 0)
    
    local sizeation = vector(120, 0)
    
    sizeation.y = sizeation.y + anim.watermark/255*15
    
    
    render.text(1, vector(pos_x:get(), pos_y:get()), menu.watermark_color:get():alpha_modulate(255), nil, ">\\ afterlife.lua anti-aims "..technology_text:get_animated_text().."™")

    if anim.watermark > 1 then
        render.rect_outline(vector(pos_x:get() - sizeation.x / 2 + 52, pos_y:get() - sizeation.y + 7), vector(pos_x:get() + sizeation.x * 2 - 32, pos_y:get() + sizeation.y + 7), color(255):alpha_modulate(anim.watermark), 1, 6)
    end

    if is_in_bounds(vector(pos_x:get() - sizeation.x / 2 + 52, pos_y:get() - sizeation.y + 7), vector(pos_x:get() + sizeation.x * 2 - 32, pos_y:get() + sizeation.y + 7)) then
        hover_over_element = true
    end

    technology_text:animate()

    --drag code
    if ui.get_alpha() == 1 then
        local mouse_position = ui.get_mouse_position()
        if common.is_button_down(0x01) and ui.get_alpha() == 1 and not vel_dragging and not debug_dragging then
            if not dragging and is_in_bounds(vector(pos_x:get() - sizeation.x / 2 + 52, pos_y:get() - sizeation.y + 7), vector(pos_x:get() + sizeation.x * 2 - 32, pos_y:get() + sizeation.y + 7)) == true then
                hover_over_element = true
                drag_offset.x = mouse_position.x - pos_x:get()
                drag_offset.y = mouse_position.y - pos_y:get()
                dragging = true
            end
            if dragging == true then
                pos_x:set(mouse_position.x - drag_offset.x)
                pos_y:set(mouse_position.y - drag_offset.y)
            end
        else
            stopped_dragging = true
            dragging = false
        end

        -- Center watermark on right-click
        if is_in_bounds(vector(pos_x:get() - sizeation.x / 2 + 52, pos_y:get() - sizeation.y + 7), vector(pos_x:get() + sizeation.x * 2 - 32, pos_y:get() + sizeation.y + 7)) and common.is_button_down(0x02) then
            pos_x:set((x - textsize) / 2)
        end
    end
end

--rendering the panelka
events.render:set(state_panel)




events.mouse_input:set(function()
    if hover_over_element and ui.get_alpha() == 1 then
        return false
    end
end)


local crosshair = {
    indicator = function(string, r, g, b, a, add_x, add_y, centered)
        render.text(2, vector((render.screen_size().x / 2) + 1 + add_x, (render.screen_size().y / 2) + 10 + add_y), color(r, g, b, a), 'c', string)
    end,

    indicator2 = function(string, r, g, b, a, index, centered)
        render.text(1, vector((render.screen_size().x / 2), (render.screen_size().y / 2) + 10 + index * 10), color(r, g, b, a), centered, string)
    end,

    indicator3 = function(string, r, g, b, a, add_x, add_y, centered)
        render.text(functions.fonts.skeet_bold, vector((render.screen_size().x / 2) + 1 + add_x, (render.screen_size().y / 2) + 10 + add_y), color(r, g, b, a), 'c', string)
    end,

    line = function(length, length2, add_x, add_y, centered, alpha)
        if length < length2 - 1 then length2 = length - 1 end
        render.rect(vector((render.screen_size().x / 2) - (length / 2 - 1) + add_x, render.screen_size().y / 2 + 25), vector((render.screen_size().x / 2) + add_x + length / 2, render.screen_size().y / 2 + 4 + 25), color(0, 0, 0, 150*alpha), 0, true)
        --render.rect(vector((render.screen_size().x / 2) - (length / 2 - 2) + add_x, (render.screen_size().y / 2) + 1 + 25), vector((render.screen_size().x / 2) + add_x - (length / 2) + length2, render.screen_size().y / 2 + 3 + 25), color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, alpha), 0, true)
        render.gradient(vector((render.screen_size().x / 2) - (length / 2 - 2) + add_x, (render.screen_size().y / 2) + 1 + 25), vector((render.screen_size().x / 2) + add_x - (length / 2) + length2, render.screen_size().y / 2 + 3 + 25), color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255*alpha), color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 10*alpha), color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255*alpha), color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 10*alpha), 0)
    end
}

local feature = {
    indicator = function(r, g, b, a, string, xtazst)
        if (string == nil or string == '' or string == ' ') then return end
        render.gradient(vector(13, render.screen_size().y - 350 - xtazst * 37), vector(13 + (render.measure_text(functions.fonts.feature, '', string).x / 2), (render.screen_size().y - 345 - xtazst * 37) + 28), color(0, 0, 0, 0), color(0, 0, 0, 60), color(0, 0, 0, 0), color(0, 0, 0, 60), 0)
        render.gradient(vector(13 + (render.measure_text(functions.fonts.feature, '', string).x), render.screen_size().y - 350 - xtazst * 37), vector(13 + (render.measure_text(functions.fonts.feature, '', string).x / 2), (render.screen_size().y - 345 - xtazst * 37) + 28), color(0, 0, 0, 0), color(0, 0, 0, 60), color(0, 0, 0, 0), color(0, 0, 0, 60), 0)

        render.text(functions.fonts.feature, vector(20, (render.screen_size().y - 343) - xtazst * 37), color(0, 0, 0, 150), '', string)
        render.text(functions.fonts.feature, vector(19, (render.screen_size().y - 344) - xtazst * 37), color(r, g, b, a), '', string)
    end
}

local legacy = {
    indicator = function(r, g, b, a, string, xtazst)
        if (string == nil or string == '' or string == ' ') then return end
        render.text(functions.fonts.legacy, vector(10, (render.screen_size().y - 69) - xtazst * 30), color(r, g, b, a), '', string)
    end
}

local renders = {
    conteiner = function(x, y, w, h, name, font_size, font)
        local name_size = render.measure_text(font, '', name)
        if menu.solus_theme:get() == 'v1' then
            render.rect(vector(x, y), vector(x + w + 2, y - 2), color(menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, 255), 0, true)
            render.rect(vector(x, y), vector(x + w + 2, y + h), color(18, 18, 18, menu.ui_accent_color:get().a), 0, true)  
            render.text(font, vector(x+1 + w / 2 + 1 - name_size.x / 2, y + 3), color(255, 255, 255, 255), '', name)
        elseif menu.solus_theme:get() == 'v2' then
            functions.container(x, y, w + 3, h, menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, menu.ui_accent_color:get().a, 1)
       
            --render.text(font, vector(x+2 + w / 2 + 1 - name_size.x / 2, y + 3), color(142, 165, 255, 255), '', name)
            render.text(font, vector(x+1 + w / 2 + 1 - name_size.x / 2, y + 2), color(255, 255, 255, 255), '', name)
        
        elseif menu.solus_theme:get() == 'v2.5' then
            functions.container2(x, y, w + 3, h, menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, menu.ui_accent_color:get().a, 1)
            
            --render.text(font, vector(x+2 + w / 2 + 1 - name_size.x / 2, y + 3), color(142, 165, 255, 255), '', name)

            render.text(font, vector(x+1 + w / 2 + 1 - name_size.x / 2, y + 2), color(255, 255, 255, 255), '', name)
        
        end
    end,

    rectangle = function(x, y, w, h, r, g, b, a) -- sorry @Zabolotny
	    return render.rect(vector(x, y), vector(x + w, y + h), color(r, g, b, a), 0, true)
    end,

    MultiColorString = function(table, x, y, size, font, centered, shadow)
        outline = outline or false
        centered = centered or false
        shadow = shadow or false
      
        if #table == 0 then return end
    
        local text = ""
        for i = 1, #table do
            text = text .. tostring(table[i][1])
        end
      
        local text_size = centered and -(render.measure_text(font, '', text).x / 2)
    
        for i = 1, #table do
            if type(table[i][1]) ~= "string" then table[i][1] = tostring(table[i][1]) end
    
            render.text(font, vector(x + text_size, y), table[i][2], '', table[i][1])
    
            text_size = text_size + render.measure_text(font, '', table[i][1]).x
        end
    end
}

-- Solus regs 

local drag = false
local drag_s = false
local g_players = { }
local alpha_k = 1
local data_k = {
    [''] = {alpha_k = 0}
}

local drag_s = false
local width_k = 0
local width_ka = 0
local alpha_s = 1
local width_sa = 0
local width_s = 0
local dick = 0
local data_s = {
    [''] = {alpha_s = 0}
}

local keybind_names = {
    ['Double Tap'] = 'Double tap',
    ['Hide Shots'] = 'On shot anti-aim',
    ['Slow Walk'] = 'Slow motion',
    ['Edge Jump'] = 'Jump at edge',
    ['Fake Latency'] = 'Ping spike',
    ['Fake Duck'] = 'Duck peek assist',
    ['Min. Damage'] = 'Damage override',
    ['Peek Assist'] = 'Quick peek assist',
    ['Body Aim'] = 'Force body aim',
    ['Safe Points'] = 'Safe points',
    ['Yaw Base'] = 'Yaw base',
    ['Force Thirdperson'] = 'Thirdperson',
    ['» Yaw base'] = 'Yaw base',
}

-- Solus regs 

local pi, max = math.pi, math.max

dynamic.__index = dynamic

function dynamic.new(f, z, r, xi)
   f = max(f, 0.001)
   z = max(z, 0)

   local pif = pi * f
   local twopif = 2 * pif

   local a = z / pif
   local b = 1 / ( twopif * twopif )
   local c = r * z / twopif

   return setmetatable({
      a = a,
      b = b,
      c = c,

      px = xi,
      y = xi,
      dy = 0
   }, dynamic)
end

function dynamic:update(dt, x, dx)
   if dx == nil then
      dx = ( x - self.px ) / dt
      self.px = x
   end

   self.y  = self.y + dt * self.dy
   self.dy = self.dy + dt * ( x + self.c * dx - self.y - self.a * self.dy ) / self.b
   return self
end

function dynamic:getval()
   return self.y
end


local verdana = render.load_font("Verdana", 12, "ad")

local isDT = ui.find("Aimbot", "Ragebot", "Main", "Double Tap")
local isHS = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
local isFS = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")

local register = {

    localplayer_state = function()
        local localplayer = entity.get_local_player()
        if not localplayer then return end
        if localplayer_info.real_yaw == nil then return end
        local p_duck = localplayer['m_flDuckAmount']
        local std1, std2, std3 = localplayer['m_vecVelocity'].x, localplayer['m_vecVelocity'].y, localplayer['m_vecVelocity'].z
        local p_still = math.sqrt(std1 ^ 2 + std2 ^ 2) < 2
        localplayer_info.side = localplayer_info.real_yaw > 0 and 1 or -1
        localplayer_info.inverter = localplayer_info.real_yaw > 0 and true or false
    
        if bit.band(localplayer['m_fFlags'], 1) == 1 and not common.is_button_down(0x20) then var.in_air = 0 else var.in_air = 1 end
        if  rage.exploit:get() == 0 and not p_still then var.plr_state = 7 elseif p_duck >= 0.7 and var.in_air == 1 then var.plr_state = 1 elseif var.in_air == 1 then var.plr_state = 2 elseif cheat.slowwalk:get() then var.plr_state = 3 elseif p_duck >= 0.7 or cheat.fakeduck:get() then var.plr_state = 4 elseif p_still then var.plr_state = 5 else var.plr_state = 6 end    
    end, 


    crosshair = function()
        if not menu.visuals.crosshair_indicator_enable:get() then return end

        local localplayer = entity.get_local_player()
        if not globals.is_in_game then return end
        if not localplayer_info.real_yaw then return end
        if not localplayer then return end
        if not localplayer:is_alive() then return end

        if menu.indicators_theme:get() == 'Technology' then
            
            local maincolor = { menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b }
            local index = 10
            local is_scoped = localplayer['m_bIsScoped']
            local scope_val = 34
            local scoped_anim = string.format('%.0f', animation.new('scoped_anim', is_scoped and scope_val or 0, 0.1))
            --'AFTERLIFE°'
            local alphaname = animation.new('alphaname', menu.crosshair_options:get(1) and 1 or 0, 0.1)
            local colAFTER = animation.new('colAFTER', (localplayer_info.inverter == true) and color(maincolor[1], maincolor[2], maincolor[3], 255) or color(255, 255, 255, 255), 0.1)
            local colLIFE = animation.new('colLIFE', (localplayer_info.inverter == false) and color(maincolor[1], maincolor[2], maincolor[3], 255) or color(255, 255, 255, 255), 0.1)
            
            local AfterlifeDEV = gradient.text("afterlife", false, {
                menu.ind_color:get(),
                menu.ind_color2:get()
            })
            
            if ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"):get() > 0 then
                AfterlifeDEV = gradient.text("afterlife", false, {
                    menu.ind_color:get(),
                    color(145,145,145)
                })
            elseif ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"):get() < 0 then
                AfterlifeDEV = gradient.text("afterlife", false, {
                    color(145,145,145),
                    menu.ind_color:get()
                })
            else
                AfterlifeDEV = gradient.text("afterlife", false, {
                    color(145,145,145),
                    color(145,145,145)
                })
            end
            
            render.text(functions.fonts.csscrosshair, vector(render.screen_size().x / 2 + scoped_anim, (render.screen_size().y / 2) + 10 + index), color(colAFTER.r, colAFTER.g, colAFTER.b, 255*alphaname), 'c', AfterlifeDEV)
            render.shadow(vector(render.screen_size().x / 2 + scoped_anim - 20, (render.screen_size().y / 2) + 10 + index), vector(render.screen_size().x / 2 + scoped_anim + 20, (render.screen_size().y / 2) + 10 + index), menu.ind_colorglow:get() - color(0,0,0,125), 20, 0, 5)
            
            local index = index + 10

            local alphastate = animation.new('alphastate', menu.crosshair_options:get(3) and 1 or 0, 0.1)
            crosshair.indicator('·  ' .. var.player_states[var.plr_state] .. '  ·', 255, 255, 255, 255*alphastate, scoped_anim, index, true)
            if menu.crosshair_options:get(3) then index = index + 9 end

            local alphadt = animation.new('alphadt', (menu.crosshair_options:get(4) and cheat.doubletap:get()) and 1 or 0, 0.15)
            local coldt = animation.new('coldt', (rage.exploit:get() == 1) and color(147, 195, 13, 255) or color(255, 0, 50, 255), 0.1)
            crosshair.indicator('DT', coldt.r, coldt.g, coldt.b, 255*alphadt, scoped_anim, index, true)
            if menu.crosshair_options:get(4) and cheat.doubletap:get() then index = index + 9 end
            
            local alphahs = animation.new('alphahs', (menu.crosshair_options:get(5) and cheat.hideshots:get()) and 1 or 0, 0.08)
            local colhs = animation.new('colhs', (cheat.doubletap:get() or cheat.fakeduck:get()) and color(255, 0, 50, 255) or color(255, 255, 255, 255), 0.1)
            crosshair.indicator('HS', colhs.r, colhs.g, colhs.b, 255*alphahs, scoped_anim, index, true)
            if menu.crosshair_options:get(5) and cheat.hideshots:get() then index = index + 9 end

            local alphafd = animation.new('alphafd', (menu.crosshair_options:get(6) and cheat.fakeduck:get()) and 1 or 0, 0.1)
            crosshair.indicator('FD', 255, 255, 255, 255*alphafd, scoped_anim, index, true)
            if menu.crosshair_options:get(6) and cheat.fakeduck:get() then index = index + 9 end

            local binds = ui.get_binds()
            local min_dmg = false
            for k, v in ipairs(binds) do
                if (v.name == 'Min. Damage') then
                    if (v.active) then
                        min_dmg = true
                        break
                    end
                end
            end

            local alphadmg = animation.new('alphadmg', (menu.crosshair_options:get(9) and min_dmg) and 1 or 0, 0.1)
            crosshair.indicator('DMG', 255, 255, 255, 255*alphadmg, scoped_anim, index, true)
            if menu.crosshair_options:get(9) and min_dmg then index = index + 9 end
            
            local alphabaim = animation.new('alphabaim', (menu.crosshair_options:get(7) and cheat.bodyaim:get() == 'Force') and 1 or 0, 0.1)
            crosshair.indicator('BAIM', 255, 255, 255, 255*alphabaim, scoped_anim, index, true)
            if menu.crosshair_options:get(7) and cheat.bodyaim:get() == 'Force' then index = index + 9 end

            local alphasafe = animation.new('alphasafe', (menu.crosshair_options:get(8) and cheat.safepoint:get() == 'Force') and 1 or 0, 0.1)
            crosshair.indicator('SAFE', 255, 255, 255, 255*alphasafe, scoped_anim, index, true)
            if menu.crosshair_options:get(8) and cheat.safepoint:get() == 'Force' then index = index + 9 end
            
        end


        local screen_size = render.screen_size()
        local dpi_scale = render.screen_size().y / 1080
        local scale_factor = screen_size.x / (1920 * dpi_scale)

        if menu.indicators_theme:get() == 'Original' then
        
            
            local index = 0
            local animate_scope = 5 * scale_factor
            local y_speed = 0.1 * scale_factor
            local is_scoped = localplayer['m_bIsScoped']
            local yaw_line = string.format('%.0f', math.min(60, math.abs(localplayer_info.real_yaw))) + 2 * scale_factor

            local alphaname = animation.new('alphaname', menu.crosshair_options:get(1) and 1 or 0, 0.1)
            local animname = string.format('%.0f', animation.new('animname', (menu.crosshair_options:get(1)) and 9 or 0, y_speed))
            local indtext = gradient.text(luashkaname, false, {
                menu.ind_color:get(),
                menu.ind_color2:get()
            })
            local scopeanim = string.format('%.0f', animation.new('scopeanim', is_scoped and (render.measure_text(2, 'c', indtext).x / 2) + animate_scope or 0, 0.1))
            local index = index + animname
            crosshair.indicator(indtext, 255, 255, 255, 255*alphaname, scopeanim, index, true)

            local alphaline = animation.new('alphaline', (menu.crosshair_options:get(2) and menu.crosshair_options:get(1)) and 1 or 0, 0.1)
            local animline = string.format('%.0f', animation.new('animline', (menu.crosshair_options:get(2)) and 6 or 0, y_speed))
            local scopeline = string.format('%.0f', animation.new('scopeline', is_scoped and (render.measure_text(2, 'c', 'AFTERLIFE').x / 2) + animate_scope or 0, 0.1))
            local index = index + animline
            crosshair.line(render.measure_text(2, 'c', 'AFTERLIFE').x * scale_factor, yaw_line, scopeline, index, true, alphaline)

            --render.text(2, vector(render.screen_size().x / 2 + (yaw_line / 4) + scopeline, render.screen_size().y / 2 + index + 5), color(255, 255, 255, 255), '', string.format('%.0f', math.min(60, math.abs(localplayer_info.real_yaw))))

            local alphastate = animation.new('alphastate', menu.crosshair_options:get(3) and 1 or 0, 0.1)
            local animstate = string.format('%.0f', animation.new('animstate', (menu.crosshair_options:get(3)) and 9 or 0, y_speed))
            local scopestate = string.format('%.0f', animation.new('scopestate', is_scoped and (render.measure_text(2, 'c', var.player_states[var.plr_state]).x / 2) + animate_scope or 0, 0.1))
            local index = index + animstate
            crosshair.indicator(var.player_states[var.plr_state], 255, 255, 255, 255*alphastate, scopestate, index, true)

            local alphadt = animation.new('alphadt', (menu.crosshair_options:get(4) and cheat.doubletap:get()) and 1 or 0, 0.08)
            local animdt = string.format('%.0f', animation.new('animdt', (cheat.doubletap:get() and menu.crosshair_options:get(4)) and 9 or 0, y_speed)) 
            local scopedt = string.format('%.0f', animation.new('scopedt', is_scoped and (6) + animate_scope or 0, 0.1))
            local coldt = animation.new('coldt', (rage.exploit:get() == 1) and color(147, 195, 13, 255) or color(255, 0, 50, 255), 0.1)
            local index = index + animdt 
            crosshair.indicator('DT', coldt.r, coldt.g, coldt.b, 255*alphadt, scopedt, index, true)
            
            local alphahs = animation.new('alphahs', (menu.crosshair_options:get(5) and cheat.hideshots:get()) and 1 or 0, 0.08)
            local animhs = string.format('%.0f', animation.new('animhs', (menu.crosshair_options:get(5) and cheat.hideshots:get()) and 9 or 0, y_speed)) 
            local scopehs = string.format('%.0f', animation.new('scopehs', is_scoped and (6) + animate_scope or 0, 0.1))
            local colhs = animation.new('colhs', (cheat.doubletap:get() or cheat.fakeduck:get()) and color(255, 0, 50, 255) or color(255, 255, 255, 255), 0.1)
            local index = index + animhs 
            crosshair.indicator('HS', colhs.r, colhs.g, colhs.b, 255*alphahs, scopehs, index, true)

            local alphafd = animation.new('alphafd', (menu.crosshair_options:get(6) and cheat.fakeduck:get()) and 1 or 0, 0.1)
            local animfd = string.format('%.0f', animation.new('animfd', (menu.crosshair_options:get(6) and cheat.fakeduck:get()) and 9 or 0, y_speed))
            local scopefd = string.format('%.0f', animation.new('scopefd', is_scoped and (render.measure_text(2, 'c', 'DUCK').x / 2) + animate_scope or 0, 0.1))
            local index = index + animfd
            crosshair.indicator('DUCK', 255, 255, 255, 255*alphafd, scopefd, index, true)

            local binds = ui.get_binds()
            local min_dmg = false
            for k, v in ipairs(binds) do
                if (v.name == 'Min. Damage') then
                    if (v.active) then
                        min_dmg = true
                        break
                    end
                end
            end
            
            
            local alphadmg = animation.new('alphadmg', (menu.crosshair_options:get(9) and min_dmg) and 1 or 0, 0.1)
            local animdmg = string.format('%.0f', animation.new('animdmg', (menu.crosshair_options:get(9) and min_dmg) and 9 or 0, y_speed))
            local scopedmg = string.format('%.0f', animation.new('scopedmg', is_scoped and (render.measure_text(2, 'c', 'DMG').x / 2) + animate_scope or 0, 0.1))
            local index = index + animdmg
            crosshair.indicator('DMG', 255, 255, 255, 255*alphadmg, scopedmg, index, true)
            
            
            local alphabaim = animation.new('alphabaim', (menu.crosshair_options:get(7) and cheat.bodyaim:get() == 'Force') and 1 or 0, 0.1)
            local animbaim = string.format('%.0f', animation.new('animbaim', (menu.crosshair_options:get(7) and cheat.bodyaim:get() == 'Force') and 9 or 0, y_speed))
            local scopebaim = string.format('%.0f', animation.new('scopebaim', is_scoped and (render.measure_text(2, 'c', 'BAIM').x / 2) + animate_scope or 0, 0.1))
            local index = index + animbaim
            crosshair.indicator('BAIM', 255, 255, 255, 255*alphabaim, scopebaim, index, true)

            local alphasafe = animation.new('alphasafe', (menu.crosshair_options:get(8) and cheat.safepoint:get() == 'Force') and 1 or 0, 0.1)
            local animsafe = string.format('%.0f', animation.new('animsafe', (menu.crosshair_options:get(8) and cheat.safepoint:get() == 'Force') and 9 or 0, y_speed))
            local scopesafe = string.format('%.0f', animation.new('scopesafe', is_scoped and (render.measure_text(2, 'c', 'SAFE').x / 2) + animate_scope or 0, 0.1))
            local index = index + animsafe
            crosshair.indicator('SAFE', 255, 255, 255, 255*alphasafe, scopesafe, index, true)
        end

        if menu.indicators_theme:get() == "Old" then
            local binds = ui.get_binds()
            local min_dmg = false
            for k, v in ipairs(binds) do
                if (v.name == 'Min. Damage') then
                    if (v.active) then
                        min_dmg = true
                        break
                    end
                end
            end
    
            local ay = 0
            local x = render.screen_size().x/2
            local y = render.screen_size().y/2 + 20
            
            if entity.get_threat(true) then
                render.text(verdana, vector(x, y), color(220, 135, 49, 255), nil, "AFTERLIFE+")
            else
                render.text(verdana, vector(x, y), color(220, 135, 49, 255), nil, "AFTERLIFE")
            end
            ay = ay + 11
            if isFS:get() then
                render.text(verdana, vector(x, y + ay), color(209, 159, 230, 255), nil, "FREESTAND")
                ay = ay + 11
            else
                render.text(verdana, vector(x, y + ay), color(209, 159, 230, 255), nil, "DYNAMIC")
                ay = ay + 11
            end
            if isDT:get() then
                local chrg = rage.exploit:get()
                if chrg == 1 then
                    render.text(verdana, vector(x, y + ay), color(0, 255, 0, 255), nil, "DT")
                else
                    render.text(verdana, vector(x, y + ay), color(255, 0, 0, 255), nil, "DT")
                end
                ay = ay + 11
            end
            if isHS:get() then
                if not isDT:get() then
                    render.text(verdana, vector(x, y + ay), color(0, 255, 0, 255), nil, "HIDE")
                else
                    render.text(verdana, vector(x, y + ay), color(255, 0, 0, 255), nil, "HIDE")
                end
                ay = ay + 11
            end
    
            if min_dmg then
                render.text(verdana, vector(x, y + ay), color(255, 255, 255, 255), nil, "DMG")
                ay = ay + 11
            end
        end
        
    end,

    feature = function()
        if not menu.visuals.gamesense_enable:get() then return end
        if not menu.inds500:get(1) then return end
        if localplayer_info.real_yaw == nil then return end


        local ping_buffer = {}
        local ping_buffer_size = 20
        local ping_weights = { 1, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9 }
        local ping_index = 1
        
        local function get_smoothed_delta()
            local sum = 0
            local weight_sum = 0
            for i = 1, #ping_buffer do
                local weight = ping_weights[i]
                sum = sum + (ping_buffer[i] * weight)
                weight_sum = weight_sum + weight
            end
            local avg_ping = sum / weight_sum
            local delta = (math.abs(avg_ping % 360)) / (cheat.pingspike:get() / 3)
            if delta < -0.35 then delta = -0.35 end
            if delta > 1 then delta = 1 end
            return delta
        end
        
        local xtazst = 0
        local localplayer = entity.get_local_player()
        if not localplayer then return end
        local dmgcol = { menu.dmgcolor:get().r, menu.dmgcolor:get().g, menu.dmgcolor:get().b, menu.dmgcolor:get().a }
        local hccol = { menu.hccolor:get().r, menu.hccolor:get().g, menu.hccolor:get().b, menu.hccolor:get().a }
        local player_resource = localplayer:get_resource()
        local ping = player_resource['m_iPing']
        ping_buffer[ping_index] = ping
        ping_index = (ping_index % ping_buffer_size) + 1
        local delta = get_smoothed_delta()
        
        local dsy_delta = string.format('%.0f', math.min(60, math.abs(localplayer_info.real_yaw))) / 58
        local red, green, blue
        if delta == 0 then
            red, green, blue = 0, 255, 0
        elseif delta > 0 then
            red, green, blue = (150 * delta^4) + (255 * (1 - delta^4)), (196 * delta^4) + (255 * (1 - delta^4)), 20
            green = green + (0.2 * delta^4) -- decrease the rate at which green is increased even further
        else
            red, green, blue = (255 * (1 - delta^4)), (255 * delta^4), 0
            green = green + (0.2 * delta^4)
        end
        
        
        
        
        
        
        
        
            

            if (menu.skeet_indicator_features:get(10) and localplayer:is_alive()) then
                if cheat.dormantaim:get() then
                    feature.indicator(132, 196, 20, 255, 'DA', xtazst)
                    xtazst = xtazst + 1
                end
            end

            if (menu.skeet_indicator_features:get(12) and localplayer:is_alive()) then
            end

            if (menu.skeet_indicator_features:get(13) and localplayer:is_alive()) then
            end

            if menu.skeet_indicator_features:get(9) and cheat.hideshots:get() and localplayer:is_alive() then
                if cheat.doubletap:get() or cheat.fakeduck:get() then
                    feature.indicator(255, 0, 50, 255, 'ONSHOT', xtazst)
                else
                    feature.indicator(132, 196, 20, 255, 'ONSHOT', xtazst)
                end
                xtazst = xtazst + 1
            end

            if (menu.skeet_indicator_features:get(8) and localplayer:is_alive()) then
                local overridingdamage = false
                local binds = ui.get_binds()
                for table_index, i in ipairs(binds) do
                    if (i.name == 'Min. Damage') then
                        if (i.active) then
                            overridingdamage = true
                        end
                    end
                end

                if menu.dmgtype:get() == 'On hotkey' and overridingdamage then 
                    feature.indicator(dmgcol[1], dmgcol[2], dmgcol[3], dmgcol[4], menu.dmgtext:get() .. cheat.mindamage:get(), xtazst)
                    xtazst = xtazst + 1
                elseif menu.dmgtype:get() == 'Always on' then
                    feature.indicator(dmgcol[1], dmgcol[2], dmgcol[3], dmgcol[4], menu.dmgtext:get() .. cheat.mindamage:get(), xtazst)
                    xtazst = xtazst + 1
                end
            end

            if (menu.skeet_indicator_features:get(11) and localplayer:is_alive()) then
                local overridinghitchance = false
                local binds = ui.get_binds()
                for table_index, i in ipairs(binds) do
                    if (i.name == 'Hit Chance') then
                        if (i.active) then
                            overridinghitchance = true
                        end
                    end
                end

                if menu.hctype:get() == 'On hotkey' and overridinghitchance then 
                    feature.indicator(hccol[1], hccol[2], hccol[3], hccol[4], menu.hctext:get() .. cheat.hitchance:get(), xtazst)
                    xtazst = xtazst + 1
                elseif menu.hctype:get() == 'Always on' then
                    feature.indicator(hccol[1], hccol[2], hccol[3], hccol[4], menu.hctext:get() .. cheat.hitchance:get(), xtazst)
                    xtazst = xtazst + 1
                end
            end

            if cheat.pingspike:get() > 0 and menu.skeet_indicator_features:get(3) and localplayer:is_alive() then
                feature.indicator(red, green, blue, 255, 'PING', xtazst)
                xtazst = xtazst + 1
            end

            if (cheat.fakeduck:get() and menu.skeet_indicator_features:get(5) and localplayer:is_alive()) then
                feature.indicator(255, 255, 255, 200, 'DUCK', xtazst)
                xtazst = xtazst + 1
            end

            if (cheat.safepoint:get() == 'Force' and menu.skeet_indicator_features:get(1) and localplayer:is_alive()) then
                feature.indicator(225, 225, 225, 255, 'SAFE', xtazst)
                xtazst = xtazst + 1
            end

            if (cheat.bodyaim:get() == 'Force' and menu.skeet_indicator_features:get(2) and localplayer:is_alive()) then
                feature.indicator(225, 225, 225, 255, 'BODY', xtazst)
                xtazst = xtazst + 1
            end

            if (cheat.freestand:get() and menu.skeet_indicator_features:get(6) and localplayer:is_alive()) then
                feature.indicator(225, 225, 225, 255, 'FS', xtazst)
                xtazst = xtazst + 1
            end

            if menu.skeet_indicator_features:get(7) then
                local c4 = entity.get_entities(129, true)[1]
                if c4 ~= nil then
                    local time = ((c4['m_flC4Blow'] - globals.curtime)*10) / 10
                    local timer = string.format('%.1f', time)
                    local defused = c4['m_bBombDefused'] 
                    if math.floor(timer) > 0 and not defused then
                        if localplayer:is_alive() then
                            local bombsite = c4['m_nBombSite'] == 0 and 'A' or 'B'
                            local health = localplayer['m_iHealth']
                            local armor = localplayer['m_ArmorValue']
                            local willKill = false
                            local eLoc = c4['m_vecOrigin']
                            local lLoc = localplayer['m_vecOrigin']
                            local distance = functions.calcdist(eLoc, lLoc)
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
                            feature.indicator(225, 225, 225, 255, bombsite .. ' - '..string.format('%.1f', timer) .. 's', xtazst)
                            xtazst = xtazst + 1
                            if localplayer then
                                if willKill == true then
                                    feature.indicator(225, 0, 50, 255, 'FATAL', xtazst)
                                    xtazst = xtazst + 1
                                elseif damage > 0.5 then
                                    feature.indicator(210, 216, 112, 255, '-' ..dmg.. ' HP', xtazst)
                                    xtazst = xtazst + 1
                                end
                            end
                        else
                            local bombsite = c4['m_nBombSite'] == 0 and 'A' or 'B'
                            local spec_mode = localplayer['m_iObserverMode']
                            local spec_target = localplayer['m_hObserverTarget']
                            local allow_draw_bomb = true
                            if spec_mode == 6 then allow_draw_bomb = false else allow_draw_bomb = true end
                            if spec_target ~= nil then
                                if spec_target and spec_target:is_player() and allow_draw_bomb then
                                    local health = spec_target['m_iHealth']
                                    local armor = spec_target['m_ArmorValue']
                                    local willKill = false
                                    local eLoc = c4['m_vecOrigin']
                                    local lLoc = spec_target['m_vecOrigin']
                                    local distance = functions.calcdist(eLoc, lLoc)
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
                                    feature.indicator(225, 225, 225, 255, bombsite .. ' - '..string.format('%.1f', timer) .. 's', xtazst)
                                    xtazst = xtazst + 1
                                    if localplayer then
                                        if willKill == true then
                                            feature.indicator(225, 0, 50, 255, 'FATAL', xtazst)
                                            xtazst = xtazst + 1
                                        elseif damage > 0.5 then
                                            feature.indicator(210, 216, 112, 255, '-' ..dmg.. ' HP', xtazst)
                                            xtazst = xtazst + 1
                                        end
                                    end
                                elseif not allow_draw_bomb then
                                    feature.indicator(225, 225, 225, 255, bombsite .. ' - '..string.format('%.1f', timer) .. 's', xtazst)
                                    xtazst = xtazst + 1
                                end
                            end
                        end
                    end
                end

                if planting then
                    feature.indicator(210, 216, 112, 255, planting_site, xtazst)
                    fill = 3.125 - (3.125 + on_plant_time - globals.curtime)
                    if(fill > 3.125) then
                        fill = 3.125
                    end

                    ts = render.measure_text(functions.fonts.feature, '', planting_site).x
                    render.circle_outline(vector(19 + ts + 17, render.screen_size().y - 333 - xtazst * 37), color(0, 0, 0, 255), 10, 0, 1, 5)
                    render.circle_outline(vector(19 + ts + 17, render.screen_size().y - 333 - xtazst * 37), color(235, 235, 235, 255), 9, 0, (fill / 3.3), 3)
                    xtazst = xtazst + 1
                end
            end

            if menu.skeet_indicator_features:get(4) and cheat.doubletap:get() and localplayer:is_alive() then
                if (rage.exploit:get() == 1) then
                    feature.indicator(225, 225, 225, 255, 'DT', xtazst)
                else
                    feature.indicator(255, 0, 50, 255, 'DT', xtazst)
                end
                xtazst = xtazst + 1
            end
    end,

    solus_watermark = function()

        if not menu.visuals.solus_ui_enable:get() then return end
        if not menu.elements:get(1) then return end
        local time = common.get_system_time()
        if time.hours < 10 then time.hours = '0' .. time.hours end
        if time.minutes < 10 then time.minutes = '0' .. time.minutes end
        if time.seconds < 10 then time.seconds = '0' .. time.seconds end
    
        local rightpadding = 12
        local vara = render.screen_size().x - var.textsize - rightpadding
        local x = vara - 18
        local y = 7
        local smth = 1
        local w = var.textsize + 20
        local h = y + 9    
        local start_position = x - 22
        local localplayer = entity.get_local_player()
        local actual_time = ("%02d:%02d:%02d"):format(time.hours, time.minutes, time.seconds) -- EngineClient.GetNetChannelInfo():GetLatency(0)
        if entity.get_local_player() == nil then latency = 0 else latency = string.format("%1.f", math.max(0.0, utils.net_channel():get_packet_response_latency(0, 0))) end
        if latency == nil then latency = 0 end
    
        local cheattext = 'AFTERLIFE'
        local usertext = lua.username
    
        if menu.ui_usertext:get() == '' then usertext = lua.username else usertext = menu.ui_usertext:get() end
        if menu.ui_cheattext:get() == '' then cheattext = 'neverlose' else cheattext = menu.ui_cheattext:get() end
    
        local cheatsize = render.measure_text(1, 'r', cheattext).x - 2

        if menu.solus_theme:get() == 'v1' then
            nexttext = (cheattext .. " | %s | delay: %sms | %s "):format(usertext, latency, actual_time)
        elseif menu.solus_theme:get() == 'v2' then 
            nexttext = (cheattext .. "  %s  delay: %sms  %s "):format(usertext, latency, actual_time)
        elseif menu.solus_theme:get() == 'v2.5' then 
            nexttext = (cheattext .. " | %s | delay: %sms | %s "):format(usertext, latency, actual_time)
        end
        
        if menu.solus_theme:get() == 'v1' then
            render.rect(vector(x + 10, y + 1), vector(x + var.textsize + 20, h - 6), color(menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, 255), 0, true)
            render.rect(vector(x + 10, y + 2 + 1), vector(x + var.textsize + 20, h + 12), color(18, 18, 18, menu.ui_accent_color:get().a), 0, true)
            render.text(1, vector(vara / smth - 3, y + 5), color(255, 255, 255, 255), '', nexttext)
        elseif menu.solus_theme:get() == 'v2' then 
            functions.container(x + 10, y + 3, var.textsize + 7, 19, menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, menu.ui_accent_color:get().a, 1)
            render.text(1, vector(vara / smth - 3, y + 6), color(255, 255, 255, 255), '', nexttext)
        elseif menu.solus_theme:get() == 'v2.5' then 
            functions.container2(x + 10, y + 3, var.textsize + 7, 19, menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, menu.ui_accent_color:get().a, 1)
            render.text(1, vector(vara / smth - 3, y + 6), color(255, 255, 255, 255), '', nexttext)
        
        end
    
        local wide = render.measure_text(1, 'r', nexttext) - 2
        vara = vara + wide.x
        var.textsize = vara - (render.screen_size().x - var.textsize - rightpadding)
    end,

    solus_keybinds = function()
        if not menu.visuals.solus_ui_enable:get() then return end
        if not menu.elements:get(3) then return end

        local x_k, y_k = menu.ui_keybinds_x:get(), menu.ui_keybinds_y:get()
        local max_width = 0
        local frametime = globals.frametime * 16
        local add_y = 0
        local total_width = 66
        local active_binds = {}
        local bind = functions.getbinds()
    
        for i = 1, #bind do
            local binds = bind[i]
            local bind_name = keybind_names[binds.name] == nil and functions.upper_to_lower(binds.name) or keybind_names[binds.name]
            local bind_state = binds.mode

            if bind_name ~= "Min. damage" then
                if bind_state == 2 then
                    bind_state = "toggled"
                elseif bind_state == 1 then
                    bind_state = "holding"
                end
            else
                bind_state = binds.value
            end


        
            if data_k[bind_name] == nil then
                data_k[bind_name] = {alpha_k = 0}
            end
    
            local bind_state_size = render.measure_text(1, '', bind_state)
            local bind_name_size = render.measure_text(1, '', bind_name)
    
            data_k[bind_name].alpha_k = functions.lerp(frametime, data_k[bind_name].alpha_k, binds.active and 1 or 0)
    
            render.text(1, vector(x_k+3, y_k + 20 + string.format('%.0f', add_y)), color(255, 255, 255, data_k[bind_name].alpha_k*255), '', bind_name)
            render.text(1, vector(x_k + (string.format('%.0f', width_ka) - bind_state_size.x - 8), y_k + 20 + string.format('%.0f', add_y)) , color(255, 255, 255, data_k[bind_name].alpha_k*255), '', '['..bind_state..']')
    
            add_y = add_y + 14 * data_k[bind_name].alpha_k
    
            local width_k = bind_state_size.x + bind_name_size.x + 23
            if width_k > 123 then
                if width_k > max_width then
                    max_width = width_k
                end
            end
    
            if binds.active then
                table.insert(active_binds, binds)
            end
        end
    
        alpha_k = functions.lerp(frametime, alpha_k, (ui.get_alpha() > 0 or #active_binds > 0) and 1 or 0)
        width_ka = functions.lerp(frametime, width_ka, math.max(max_width, 123))
    
        if ui.get_alpha() > 0 or #active_binds > 0 then
        renders.conteiner(x_k, y_k, string.format('%.0f', width_ka), 19, 'keybinds', 11, 1)
            local mouse = ui.get_mouse_position()
            if common.is_button_down(1) and drag_s == false then
                if mouse.x >= x_k and mouse.y >= y_k and mouse.x <= x_k + width_ka and mouse.y <= y_k + 18 or drag then
                    if not drag then
                        drag = true
                    else
                        menu.ui_keybinds_x:set(mouse.x - math.floor(width_ka / 2))
                        menu.ui_keybinds_y:set(mouse.y - 8)
                    end
                end
            else
                drag = false
            end
        end
    end,

    solus_spectators = function()
        if not menu.visuals.solus_ui_enable:get() then return end
        if not menu.elements:get(2) then return end

        local spectators = functions.info_spectators()
        local local_player = entity.get_local_player()
        
        if not globals.is_connected or spectators == nil or entity.get_local_player() == nil then return end
        local add_y = 0
        local max_width = 0
        local active_spec = {}
        local frametime = globals.frametime * 16
        
        if spectators ~= nil then
            local currentIndex = 1
            if spectators ~= nil then
                for i = 1, #spectators do
                    v = spectators[i]
                    local name_size = render.measure_text(1, '', v.name)
                    if data_s[v.name] == nil then
                        data_s[v.name] = {alpha_s = 0}
                    end
                        
                    data_s[v.name].alpha_s = functions.lerp(frametime, data_s[v.name].alpha_s, dick < 1 and 1 or 0)
                    render.text(1, vector(menu.ui_spectators_x:get() + 22, menu.ui_spectators_y:get() + 21 + string.format('%.0f', add_y)), color(255, 255, 255, data_s[v.name].alpha_s*255), '', v.name)
                    render.texture(v.avatar, vector(menu.ui_spectators_x:get() + 4, menu.ui_spectators_y:get() + 21 + string.format('%.0f', add_y)), vector(12, 12), color(255, 255, 255, 255), 'f', 0)
    
                    add_y = add_y + 14 * data_s[v.name].alpha_s
                    width_s = name_size.x + 21
                    if width_s > 123 then
                        if width_s > max_width then
                            max_width = width_s
                        end
                    end
                    if dick then
                        table.insert(active_spec, dick)
                    end
                    currentIndex = currentIndex + 1
                end
            end
            local dick = #spectators
        end
        
        alpha_s = functions.lerp(frametime, alpha_s, (ui.get_alpha() > 0 or #active_spec > 0) and 1 or 0)
        width_sa = functions.lerp(frametime, width_sa, math.max(max_width, 123))
    
        if #active_spec > 0 or ui.get_alpha() > 0 then
            renders.conteiner(menu.ui_spectators_x:get(), menu.ui_spectators_y:get(), string.format('%.0f', width_sa), 19, 'spectators', 11, 1)
            local mouse = ui.get_mouse_position()
            if common.is_button_down(1) and ui.get_alpha() > 0 and drag == false then
                if mouse.x >= menu.ui_spectators_x:get() and mouse.y >= menu.ui_spectators_y:get() and mouse.x <= menu.ui_spectators_x:get() + 134 and mouse.y <= menu.ui_spectators_y:get() + 18 or drag_s then
                    if not drag_s then
                        drag_s = true
                    else
                        menu.ui_spectators_x:set(mouse.x - math.floor(width_sa / 2))
                        menu.ui_spectators_y:set(mouse.y - 8)
                    end
                end
            else
                drag_s = false
            end
        end
    end,

    viewmodel_override = function()
        if menu.misc.viewmodel:get() then
            local x1, x2, x3, x4 = menu.viewmodel_x:get(), menu.viewmodel_y:get(), menu.viewmodel_z:get(), menu.viewmodel_fov:get()
            cvar.viewmodel_offset_x:float(x1, true)
            cvar.viewmodel_offset_y:float(x2, true)
            cvar.viewmodel_offset_z:float(x3, true)
            cvar.viewmodel_fov:float(x4, true)
        else
            cvar.viewmodel_offset_x:float(localplayer_info.viewmodel_x, true)
            cvar.viewmodel_offset_y:float(localplayer_info.viewmodel_y, true)
            cvar.viewmodel_offset_z:float(localplayer_info.viewmodel_z, true)
            cvar.viewmodel_fov:float(localplayer_info.viewmodel_fov, true)
        end
    end,

    onload = function()
        localplayer_info.viewmodel_x, localplayer_info.viewmodel_y, localplayer_info.viewmodel_z, localplayer_info.viewmodel_fov = cvar.viewmodel_offset_x:float(), cvar.viewmodel_offset_y:float(), cvar.viewmodel_offset_z:float(), cvar.viewmodel_fov:float()

        math.randomseed(common.get_timestamp())
        randomphrase = welcome_phrases[math.random(1,#welcome_phrases)]
        functions.log(randomphrase..', ' .. lua.username.. '?')
    end

}




events.bomb_abortplant:set(function(e)
    planting = false
    fill = 0
    on_plant_time = 0
    planting_site = ''
end)


events.bomb_defused:set(function(e)
    planting = false
    fill = 0
    on_plant_time = 0
    planting_site = ''
end)

events.bomb_planted:set(function(e)
    planting = false
    fill = 0
    on_plant_time = 0
    planting_site = ''
end)

events.round_prestart:set(function(e)
    planting = false
    fill = 0
    on_plant_time = 0
    planting_site = ''
end)

events.render:set(
    function ()
        if not globals.is_in_game then return end
        if not menu.visuals.gamesense_enable:get() then return end
        if not menu.inds500:get(2) then return end
        local local_player = entity.get_local_player()
        if not local_player or not local_player:is_alive() then return end
        local y_addition = 0
        local xlol, ylol = render.screen_size().x, render.screen_size().y
        for k,v in pairs(local_player:get_spectators()) do
            local name_length = render.measure_text(1, "", v:get_name()).x
            if menu.advertisement:get() then
                render.text(1, vector(xlol - name_length,15 + y_addition), color(255), "", v:get_name())
            else
                render.text(1, vector(xlol - name_length,1 + y_addition), color(255), "", v:get_name())
            end
            y_addition = y_addition + 20
        end
    end
)

events.render:set(function ()
    if not menu.advertisement:get() then return end

    local screensize = render.screen_size()
    local text = "afterlifelua.xyz"
    local sizedoesntmatter = render.measure_text(1, "s", text)
    local AfterlifeDEV = gradient.text_animate(text, -2.0, {
        menu.ind_color:get(),
        menu.ind_color2:get()
    })
    render.text(1, vector(screensize.x - sizedoesntmatter.x, 0), color(85,85,255,255), "s", AfterlifeDEV:get_animated_text())
    AfterlifeDEV:animate()
end)

events.bomb_beginplant:set(function(e)
    local localplayer = entity.get_local_player()
    local player_resource = localplayer:get_resource()
    on_plant_time = globals.curtime
    planting = true
    local m_bombsiteCenterA = player_resource['m_bombsiteCenterA']
    local m_bombsiteCenterB = player_resource['m_bombsiteCenterB']
    
    local player = entity.get(e.userid, true)
    local localPos = player:get_origin()
    local dist_to_a = localPos:dist(m_bombsiteCenterA)
    local dist_to_b = localPos:dist(m_bombsiteCenterB)
    
    planting_site = dist_to_a < dist_to_b and 'Bombsite A' or 'Bombsite B'
end)


events.player_death:set(function(e)

    local me = entity.get_local_player()
    local victim = entity.get(e.userid, true)
    local attacker = entity.get(e.attacker, true)

    if menu.misc.tweakers:get(1) and attacker == me and me ~= nil then
        if not me then return end
        if me:is_alive() then
            utils.console_exec('say '.. functions.killsays[utils.random_int(1, #functions.killsays)])
        end
    end

    if menu.misc.tweakers:get(2) and victim == me and attacker ~= victim then
        utils.console_exec('say '.. functions.deathsays[utils.random_int(1, #functions.deathsays)])
    end

end)

events.item_purchase:set(function(e)

    if not menu.logs:get(2) then return end
    if not menu.misc.hitlogs_enable:get() then return end

    local name = entity.get(e.userid, true)
    local item = e.weapon

    if not name then return end
    if not name:is_enemy() then return end
    if item == 'weapon_unknown' then return end

    functions.log(name:get_name() .. ' bought ' .. item)
    
end)

events.aim_fire:set(function(e)
    var.shots = var.shots + 1
    aim_hitchance = math.floor(e.hitchance + 0.5) 
    damage_shot = string.format('%.0f', e.damage)
    aimed_hgroup = functions.hitgroups[e.hitgroup]
end)

events.createmove:set(function(cmd)
    local me = entity.get_local_player()

    if cmd.choked_commands > 0 then
        return
    end

    localplayer_info.real_yaw = me['m_flPoseParameter'][11] * 120 - 60
end)

local function ragebot(cmd)

    register.viewmodel_override()
    register.localplayer_state()

end


local function visuals()

    register.crosshair()
    register.feature()
    register.solus_watermark()
    register.solus_keybinds()
    register.solus_spectators()
    
end

register.onload()

menu.inds500:set_callback(function ()
    if not menu.inds500:get(4) then
        clantag_spammer.clear()
    end
end)

events.shutdown:set(function ()
    clantag_spammer.clear()
end)

menu.ui_keybinds_x:visibility(false)
menu.ui_keybinds_y:visibility(false)
menu.ui_spectators_x:visibility(false)
menu.ui_spectators_y:visibility(false)


math.lerp = function(name, value, speed)
    return name + (value - name) * globals.frametime * speed
end

local logs, font, screen_size = {}, render.load_font("nl\\afterlifelua.xyz\\pixel.ttf", 10, "o"), render.screen_size()

hitlogs_image = render.load_image([[
<svg id="svg" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="400" height="260.9090909090909" viewBox="0, 0, 400,260.9090909090909"><g id="svgg"><path id="path0" d="M48.532 1.174 C 48.532 2.044,48.431 2.348,48.141 2.348 C 47.830 2.348,47.750 2.725,47.750 4.175 C 47.750 5.556,47.662 6.001,47.389 6.001 C 46.940 6.001,46.714 6.804,46.709 8.415 C 46.707 9.341,46.607 9.654,46.314 9.654 C 46.004 9.654,45.923 10.031,45.923 11.481 C 45.923 12.853,45.834 13.307,45.566 13.307 C 45.199 13.307,44.887 14.571,44.882 16.084 C 44.880 16.570,44.720 16.966,44.488 17.055 C 44.195 17.167,44.097 17.635,44.097 18.909 C 44.097 20.250,44.013 20.613,43.705 20.613 C 43.395 20.613,43.314 20.990,43.314 22.440 C 43.314 23.827,43.226 24.266,42.950 24.266 C 42.450 24.266,42.270 24.851,42.270 26.477 C 42.270 27.469,42.159 27.906,41.879 28.013 C 41.591 28.124,41.487 28.579,41.487 29.737 C 41.487 30.963,41.372 31.427,40.965 31.833 C 40.579 32.219,40.441 32.710,40.435 33.725 C 40.431 34.513,40.264 35.310,40.044 35.601 C 39.809 35.911,39.661 36.694,39.661 37.621 C 39.661 38.852,39.563 39.195,39.139 39.460 C 38.701 39.734,38.617 40.069,38.617 41.550 C 38.617 42.944,38.535 43.314,38.226 43.314 C 37.917 43.314,37.834 43.679,37.834 45.034 C 37.834 46.535,37.768 46.772,37.312 46.891 C 36.861 47.009,36.791 47.247,36.791 48.665 C 36.791 49.880,36.690 50.342,36.399 50.453 C 36.107 50.565,36.008 51.031,36.008 52.290 C 36.008 53.747,35.937 53.999,35.486 54.142 C 35.037 54.285,34.964 54.537,34.964 55.958 C 34.964 57.185,34.864 57.647,34.573 57.759 C 34.281 57.871,34.181 58.336,34.181 59.583 C 34.181 61.037,34.113 61.275,33.659 61.393 C 33.205 61.512,33.138 61.749,33.138 63.222 C 33.138 64.486,33.038 64.953,32.746 65.065 C 32.454 65.177,32.355 65.645,32.355 66.919 C 32.355 68.202,32.265 68.624,31.991 68.624 C 31.491 68.624,31.311 69.208,31.311 70.835 C 31.311 71.826,31.200 72.264,30.920 72.371 C 30.627 72.483,30.528 72.951,30.528 74.225 C 30.528 75.508,30.438 75.930,30.165 75.930 C 29.665 75.930,29.485 76.514,29.485 78.141 C 29.485 79.132,29.373 79.569,29.093 79.677 C 28.805 79.787,28.702 80.243,28.702 81.401 C 28.702 82.627,28.587 83.090,28.180 83.496 C 27.788 83.889,27.658 84.366,27.658 85.421 C 27.658 86.350,27.526 86.934,27.267 87.149 C 27.005 87.366,26.875 87.952,26.875 88.914 C 26.875 89.966,26.756 90.440,26.433 90.677 C 26.119 90.907,25.959 91.498,25.881 92.721 C 25.816 93.749,25.626 94.562,25.410 94.741 C 25.172 94.939,25.049 95.604,25.049 96.696 C 25.049 98.084,24.965 98.396,24.527 98.630 C 24.094 98.862,24.005 99.176,24.005 100.474 C 24.005 101.624,23.902 102.078,23.614 102.189 C 23.319 102.302,23.222 102.776,23.222 104.107 C 23.222 105.656,23.158 105.892,22.701 106.012 C 22.245 106.131,22.179 106.368,22.179 107.869 C 22.179 109.224,22.096 109.589,21.787 109.589 C 21.477 109.589,21.396 109.966,21.396 111.416 C 21.396 112.803,21.309 113.242,21.032 113.242 C 20.530 113.242,20.352 113.828,20.352 115.481 C 20.352 116.564,20.261 116.895,19.961 116.895 C 19.650 116.895,19.569 117.272,19.569 118.721 C 19.569 120.103,19.481 120.548,19.209 120.548 C 18.760 120.548,18.534 121.351,18.529 122.962 C 18.527 123.888,18.427 124.201,18.134 124.201 C 17.824 124.201,17.743 124.578,17.743 126.027 C 17.743 127.399,17.654 127.854,17.386 127.854 C 17.016 127.854,16.707 129.120,16.702 130.659 C 16.700 131.237,16.575 131.507,16.308 131.507 C 15.997 131.507,15.917 131.884,15.917 133.333 C 15.917 134.783,15.836 135.160,15.525 135.160 C 15.221 135.160,15.134 135.508,15.134 136.728 C 15.134 137.973,15.026 138.388,14.612 138.743 C 14.193 139.102,14.090 139.513,14.090 140.828 C 14.090 142.110,14.005 142.466,13.699 142.466 C 13.388 142.466,13.307 142.843,13.307 144.292 C 13.307 145.679,13.220 146.119,12.944 146.119 C 12.443 146.119,12.264 146.703,12.264 148.330 C 12.264 149.321,12.152 149.759,11.872 149.866 C 11.584 149.977,11.481 150.432,11.481 151.590 C 11.481 152.816,11.365 153.279,10.959 153.686 C 10.573 154.072,10.435 154.563,10.429 155.577 C 10.424 156.366,10.258 157.162,10.037 157.454 C 9.803 157.763,9.654 158.546,9.654 159.467 C 9.654 160.706,9.562 161.023,9.132 161.252 C 8.695 161.487,8.611 161.799,8.611 163.191 C 8.611 164.425,8.510 164.888,8.219 165.000 C 7.928 165.112,7.828 165.577,7.828 166.824 C 7.828 168.278,7.759 168.515,7.306 168.634 C 6.852 168.753,6.784 168.990,6.784 170.463 C 6.784 171.727,6.685 172.194,6.393 172.306 C 6.101 172.418,6.001 172.883,6.001 174.130 C 6.001 175.584,5.933 175.821,5.479 175.940 C 5.024 176.059,4.958 176.296,4.958 177.797 C 4.958 179.152,4.875 179.517,4.566 179.517 C 4.256 179.517,4.175 179.891,4.175 181.313 C 4.175 182.890,4.111 183.126,3.653 183.246 C 3.198 183.365,3.131 183.602,3.131 185.103 C 3.131 186.458,3.048 186.823,2.740 186.823 C 2.429 186.823,2.348 187.200,2.348 188.650 C 2.348 190.037,2.261 190.476,1.985 190.476 C 1.485 190.476,1.305 191.061,1.305 192.687 C 1.305 193.679,1.193 194.116,0.913 194.224 C 0.621 194.336,0.522 194.804,0.522 196.078 C 0.522 197.040,0.408 197.782,0.261 197.782 C 0.107 197.782,0.000 198.695,0.000 200.000 L 0.000 202.218 34.601 202.218 L 69.202 202.218 69.822 201.631 C 70.344 201.136,70.442 200.787,70.446 199.413 C 70.449 198.139,70.536 197.782,70.841 197.782 C 71.151 197.782,71.233 197.409,71.233 195.986 C 71.233 194.409,71.297 194.173,71.755 194.054 C 72.210 193.934,72.277 193.698,72.277 192.197 C 72.277 190.841,72.360 190.476,72.668 190.476 C 72.978 190.476,73.059 190.103,73.059 188.680 C 73.059 187.104,73.123 186.867,73.581 186.748 C 74.037 186.629,74.103 186.392,74.103 184.891 C 74.103 183.535,74.186 183.170,74.494 183.170 C 74.804 183.170,74.886 182.797,74.886 181.374 C 74.886 179.798,74.950 179.561,75.408 179.442 C 75.863 179.323,75.930 179.086,75.930 177.585 C 75.930 176.229,76.013 175.864,76.321 175.864 C 76.631 175.864,76.712 175.491,76.712 174.068 C 76.712 172.492,76.776 172.256,77.234 172.136 C 77.689 172.017,77.756 171.780,77.756 170.279 C 77.756 168.923,77.839 168.558,78.147 168.558 C 78.457 168.558,78.539 168.185,78.539 166.762 C 78.539 165.186,78.603 164.950,79.061 164.830 C 79.516 164.711,79.583 164.474,79.583 162.973 C 79.583 161.618,79.666 161.252,79.974 161.252 C 80.285 161.252,80.365 160.876,80.365 159.426 C 80.365 158.039,80.453 157.599,80.729 157.599 C 81.231 157.599,81.409 157.014,81.409 155.360 C 81.409 154.278,81.501 153.947,81.800 153.947 C 82.111 153.947,82.192 153.570,82.192 152.120 C 82.192 150.739,82.280 150.294,82.553 150.294 C 82.999 150.294,83.227 149.492,83.232 147.908 C 83.234 147.074,83.358 146.650,83.627 146.546 C 83.915 146.436,84.018 145.980,84.018 144.822 C 84.018 143.596,84.134 143.133,84.540 142.727 C 84.925 142.342,85.062 141.857,85.062 140.882 C 85.062 140.053,85.208 139.412,85.453 139.167 C 85.705 138.915,85.845 138.270,85.845 137.359 C 85.845 136.290,85.973 135.814,86.367 135.421 C 86.753 135.034,86.891 134.543,86.897 133.529 C 86.912 131.005,84.055 131.246,113.988 131.246 C 139.707 131.246,140.378 131.258,140.378 131.740 C 140.378 132.012,140.202 132.301,139.987 132.384 C 139.694 132.496,139.596 132.964,139.596 134.238 C 139.596 135.515,139.505 135.943,139.235 135.943 C 138.788 135.943,138.560 136.744,138.555 138.328 C 138.553 139.162,138.430 139.587,138.160 139.690 C 137.872 139.800,137.769 140.256,137.769 141.414 C 137.769 142.640,137.654 143.103,137.247 143.509 C 136.854 143.902,136.725 144.379,136.725 145.438 C 136.725 146.449,136.615 146.888,136.334 146.996 C 136.045 147.107,135.943 147.566,135.943 148.756 C 135.943 149.954,135.832 150.447,135.511 150.682 C 135.226 150.891,135.036 151.519,134.952 152.528 C 134.882 153.369,134.666 154.217,134.471 154.412 C 134.257 154.626,134.116 155.343,134.116 156.219 C 134.116 157.270,133.997 157.760,133.684 157.988 C 133.398 158.197,133.210 158.824,133.127 159.843 C 133.059 160.690,132.842 161.615,132.646 161.898 C 132.445 162.187,132.290 163.071,132.290 163.920 C 132.290 164.749,132.191 165.427,132.071 165.427 C 131.681 165.427,131.246 166.726,131.246 167.886 C 131.246 168.572,131.092 169.144,130.855 169.341 C 130.581 169.568,130.463 170.170,130.463 171.338 C 130.463 172.509,130.357 173.051,130.107 173.147 C 129.888 173.231,129.688 173.903,129.585 174.900 C 129.485 175.867,129.261 176.633,129.027 176.806 C 128.749 177.013,128.637 177.593,128.637 178.829 C 128.637 180.195,128.554 180.561,128.245 180.561 C 127.935 180.561,127.854 180.938,127.854 182.387 C 127.854 184.040,127.804 184.214,127.332 184.214 C 126.860 184.214,126.810 184.388,126.810 186.040 C 126.810 187.490,126.729 187.867,126.419 187.867 C 126.108 187.867,126.027 188.244,126.027 189.693 C 126.027 191.346,125.978 191.520,125.506 191.520 C 125.037 191.520,124.984 191.694,124.984 193.224 C 124.984 194.498,124.885 194.966,124.592 195.079 C 124.301 195.190,124.201 195.653,124.201 196.879 C 124.201 198.301,124.128 198.553,123.679 198.695 C 122.886 198.947,122.886 202.979,123.679 203.186 C 123.966 203.261,124.201 203.485,124.201 203.683 C 124.201 203.882,124.377 204.044,124.592 204.044 C 124.808 204.044,124.984 204.231,124.984 204.460 C 124.984 204.689,125.219 204.937,125.506 205.012 C 125.793 205.088,126.027 205.311,126.027 205.510 C 126.027 205.708,126.204 205.871,126.419 205.871 C 126.636 205.871,126.810 206.103,126.810 206.393 C 126.810 206.741,126.984 206.915,127.332 206.915 C 127.622 206.915,127.854 207.088,127.854 207.306 C 127.854 207.521,128.030 207.697,128.245 207.697 C 128.463 207.697,128.637 207.929,128.637 208.219 C 128.637 208.512,128.811 208.741,129.034 208.741 C 129.252 208.741,129.564 209.035,129.728 209.393 C 129.891 209.752,130.124 210.046,130.244 210.046 C 130.365 210.046,130.463 210.221,130.463 210.435 C 130.463 210.649,130.698 210.971,130.985 211.150 C 131.272 211.329,131.507 211.624,131.507 211.804 C 131.507 211.985,131.683 212.133,131.898 212.133 C 132.116 212.133,132.290 212.365,132.290 212.655 C 132.290 212.950,132.464 213.177,132.689 213.177 C 132.909 213.177,133.156 213.353,133.239 213.568 C 133.322 213.783,133.553 213.960,133.753 213.960 C 133.953 213.960,134.116 214.194,134.116 214.481 C 134.116 214.768,134.280 215.003,134.480 215.003 C 134.679 215.003,134.911 215.179,134.993 215.395 C 135.076 215.610,135.323 215.786,135.543 215.786 C 135.769 215.786,135.943 216.013,135.943 216.308 C 135.943 216.598,136.117 216.830,136.334 216.830 C 136.549 216.830,136.725 217.006,136.725 217.221 C 136.725 217.439,136.957 217.613,137.247 217.613 C 137.595 217.613,137.769 217.786,137.769 218.134 C 137.769 218.424,137.943 218.656,138.160 218.656 C 138.376 218.656,138.552 218.768,138.552 218.905 C 138.552 219.042,138.832 219.467,139.175 219.848 C 140.406 221.220,140.639 221.531,140.639 221.796 C 140.639 221.944,140.815 222.132,141.031 222.215 C 141.246 222.297,141.422 222.529,141.422 222.729 C 141.422 222.928,141.598 223.092,141.813 223.092 C 142.029 223.092,142.205 223.279,142.205 223.508 C 142.205 223.736,142.440 223.985,142.727 224.060 C 143.014 224.135,143.249 224.359,143.249 224.558 C 143.249 224.756,143.425 224.918,143.640 224.918 C 143.855 224.918,144.031 225.106,144.031 225.334 C 144.031 225.563,144.266 225.812,144.553 225.887 C 144.840 225.962,145.075 226.185,145.075 226.384 C 145.075 226.583,145.251 226.745,145.466 226.745 C 145.684 226.745,145.858 226.977,145.858 227.267 C 145.858 227.615,146.032 227.789,146.380 227.789 C 146.670 227.789,146.902 227.963,146.902 228.180 C 146.902 228.395,147.078 228.571,147.293 228.571 C 147.510 228.571,147.684 228.803,147.684 229.093 C 147.684 229.431,147.858 229.615,148.178 229.615 C 148.472 229.615,148.732 229.853,148.821 230.202 C 148.903 230.525,149.326 231.178,149.762 231.653 C 150.198 232.129,150.554 232.628,150.554 232.762 C 150.554 232.897,150.731 233.007,150.946 233.007 C 151.161 233.007,151.337 233.194,151.337 233.423 C 151.337 233.652,151.572 233.900,151.859 233.975 C 152.146 234.050,152.381 234.278,152.381 234.481 C 152.381 234.684,152.557 234.918,152.772 235.000 C 152.988 235.083,153.164 235.314,153.164 235.514 C 153.164 235.714,153.399 235.877,153.686 235.877 C 154.033 235.877,154.207 236.051,154.207 236.399 C 154.207 236.689,154.381 236.921,154.599 236.921 C 154.814 236.921,154.990 237.097,154.990 237.312 C 154.990 237.530,155.222 237.704,155.512 237.704 C 155.860 237.704,156.034 237.878,156.034 238.226 C 156.034 238.516,156.208 238.748,156.425 238.748 C 156.641 238.748,156.817 238.924,156.817 239.139 C 156.817 239.356,157.049 239.530,157.339 239.530 C 157.628 239.530,157.860 239.704,157.860 239.922 C 157.860 240.137,158.066 240.548,158.317 240.835 C 158.568 241.122,158.979 241.592,159.230 241.879 C 159.481 242.166,159.687 242.522,159.687 242.670 C 159.687 242.818,159.863 243.006,160.078 243.089 C 160.294 243.172,160.470 243.389,160.470 243.572 C 160.470 243.755,160.705 243.967,160.992 244.042 C 161.279 244.117,161.513 244.365,161.513 244.594 C 161.513 244.823,161.689 245.010,161.905 245.010 C 162.120 245.010,162.296 245.186,162.296 245.401 C 162.296 245.616,162.464 245.793,162.670 245.793 C 162.876 245.793,163.118 246.027,163.209 246.314 C 163.300 246.601,163.543 246.836,163.749 246.836 C 163.954 246.836,164.123 247.012,164.123 247.228 C 164.123 247.443,164.299 247.619,164.514 247.619 C 164.729 247.619,164.905 247.806,164.905 248.035 C 164.905 248.264,165.140 248.512,165.427 248.587 C 165.714 248.662,165.949 248.886,165.949 249.085 C 165.949 249.283,166.125 249.446,166.341 249.446 C 166.556 249.446,166.732 249.633,166.732 249.861 C 166.732 250.090,166.967 250.339,167.254 250.414 C 167.541 250.489,167.776 250.713,167.776 250.911 C 167.776 251.110,167.891 251.272,168.033 251.272 C 168.175 251.272,168.462 251.683,168.672 252.185 C 168.882 252.688,169.177 253.098,169.328 253.098 C 169.479 253.098,169.602 253.210,169.602 253.346 C 169.602 253.705,170.784 254.925,171.132 254.925 C 171.295 254.925,171.429 255.105,171.429 255.325 C 171.429 255.544,171.605 255.792,171.820 255.874 C 172.035 255.957,172.211 256.188,172.211 256.388 C 172.211 256.588,172.446 256.751,172.733 256.751 C 173.081 256.751,173.255 256.925,173.255 257.273 C 173.255 257.563,173.429 257.795,173.646 257.795 C 173.862 257.795,174.038 257.971,174.038 258.187 C 174.038 258.404,174.270 258.578,174.560 258.578 C 174.908 258.578,175.082 258.752,175.082 259.100 C 175.082 259.390,175.255 259.622,175.473 259.622 C 175.688 259.622,175.864 259.798,175.864 260.013 C 175.864 260.230,176.096 260.404,176.386 260.404 C 176.673 260.404,176.908 260.522,176.908 260.665 C 176.908 260.809,177.495 260.926,178.213 260.926 L 179.517 260.926 179.517 259.455 C 179.517 258.386,179.636 257.897,179.949 257.667 C 180.236 257.458,180.423 256.833,180.505 255.812 C 180.579 254.898,180.774 254.188,180.986 254.064 C 181.227 253.924,181.344 253.336,181.344 252.266 C 181.344 251.133,181.460 250.593,181.748 250.382 C 181.996 250.200,182.212 249.484,182.308 248.526 C 182.397 247.640,182.617 246.877,182.817 246.758 C 183.055 246.618,183.170 246.009,183.170 244.894 C 183.170 243.731,183.277 243.198,183.529 243.101 C 183.754 243.015,183.956 242.328,184.070 241.263 C 184.172 240.310,184.416 239.427,184.624 239.254 C 184.868 239.051,184.997 238.425,184.997 237.443 C 184.997 236.426,185.123 235.836,185.388 235.616 C 185.652 235.398,185.780 234.809,185.780 233.816 C 185.780 232.663,185.894 232.243,186.301 231.894 C 186.708 231.546,186.823 231.124,186.823 229.990 C 186.823 229.044,186.960 228.397,187.215 228.143 C 187.480 227.877,187.606 227.219,187.606 226.092 C 187.606 224.661,187.678 224.409,188.128 224.266 C 188.584 224.121,188.650 223.871,188.650 222.292 C 188.650 220.858,188.731 220.483,189.041 220.483 C 189.352 220.483,189.432 220.106,189.432 218.656 C 189.432 217.004,189.482 216.830,189.954 216.830 C 190.426 216.830,190.476 216.656,190.476 215.003 C 190.476 213.554,190.557 213.177,190.868 213.177 C 191.178 213.177,191.259 212.803,191.259 211.381 C 191.259 209.804,191.323 209.568,191.781 209.448 C 192.236 209.329,192.303 209.092,192.303 207.591 C 192.303 206.236,192.386 205.871,192.694 205.871 C 193.004 205.871,193.085 205.497,193.085 204.075 C 193.085 202.498,193.149 202.262,193.607 202.142 C 194.063 202.023,194.129 201.786,194.129 200.285 C 194.129 198.930,194.212 198.565,194.521 198.565 C 194.831 198.565,194.912 198.191,194.912 196.769 C 194.912 195.192,194.976 194.956,195.434 194.836 C 195.889 194.717,195.956 194.480,195.956 192.979 C 195.956 191.624,196.039 191.259,196.347 191.259 C 196.658 191.259,196.738 190.882,196.738 189.432 C 196.738 188.045,196.826 187.606,197.102 187.606 C 197.604 187.606,197.782 187.020,197.782 185.367 C 197.782 184.284,197.874 183.953,198.174 183.953 C 198.484 183.953,198.565 183.576,198.565 182.127 C 198.565 180.745,198.653 180.300,198.926 180.300 C 199.365 180.300,199.600 179.502,199.605 177.998 C 199.607 177.348,199.774 176.705,200.000 176.479 C 200.252 176.228,200.391 175.583,200.391 174.672 C 200.391 173.603,200.520 173.127,200.913 172.733 C 201.300 172.347,201.437 171.856,201.443 170.841 C 201.448 170.053,201.614 169.257,201.835 168.965 C 202.069 168.655,202.218 167.872,202.218 166.945 C 202.218 165.714,202.315 165.371,202.740 165.106 C 203.178 164.832,203.262 164.497,203.262 163.016 C 203.262 161.622,203.344 161.252,203.653 161.252 C 203.963 161.252,204.044 160.879,204.044 159.456 C 204.044 157.880,204.108 157.644,204.566 157.524 C 205.016 157.406,205.088 157.168,205.088 155.789 C 205.088 154.609,205.190 154.152,205.479 154.041 C 205.769 153.930,205.871 153.472,205.871 152.285 C 205.871 150.963,205.963 150.623,206.393 150.354 C 206.819 150.088,206.915 149.746,206.915 148.493 C 206.915 147.369,207.019 146.917,207.306 146.807 C 207.595 146.696,207.697 146.237,207.697 145.047 C 207.697 143.849,207.808 143.356,208.129 143.121 C 208.416 142.911,208.603 142.286,208.685 141.265 C 208.759 140.352,208.954 139.641,209.166 139.517 C 209.407 139.377,209.524 138.789,209.524 137.720 C 209.524 136.586,209.640 136.046,209.928 135.835 C 210.176 135.654,210.392 134.938,210.488 133.980 C 210.577 133.093,210.797 132.330,210.997 132.211 C 211.233 132.072,211.350 131.473,211.350 130.414 C 211.350 129.317,211.470 128.735,211.736 128.535 C 211.955 128.370,212.198 127.571,212.301 126.683 C 212.399 125.824,212.637 124.964,212.829 124.773 C 213.039 124.562,213.177 123.824,213.177 122.906 C 213.177 121.796,213.282 121.346,213.568 121.236 C 213.856 121.126,213.960 120.671,213.960 119.512 C 213.960 118.287,214.075 117.823,214.481 117.417 C 214.874 117.024,215.003 116.547,215.003 115.492 C 215.003 114.563,215.136 113.979,215.395 113.764 C 215.665 113.540,215.786 112.943,215.786 111.838 C 215.786 110.519,215.878 110.179,216.308 109.911 C 216.743 109.639,216.830 109.302,216.830 107.883 C 216.830 106.610,216.929 106.143,217.221 106.030 C 217.517 105.917,217.613 105.440,217.613 104.082 C 217.613 102.457,217.663 102.283,218.134 102.283 C 218.607 102.283,218.656 102.109,218.656 100.457 C 218.656 99.007,218.737 98.630,219.048 98.630 C 219.358 98.630,219.439 98.253,219.439 96.804 C 219.439 95.151,219.489 94.977,219.961 94.977 C 220.433 94.977,220.483 94.803,220.483 93.151 C 220.483 91.701,220.563 91.324,220.874 91.324 C 221.184 91.324,221.265 90.951,221.265 89.528 C 221.265 87.952,221.329 87.715,221.787 87.596 C 222.243 87.477,222.309 87.240,222.309 85.739 C 222.309 84.383,222.392 84.018,222.701 84.018 C 223.011 84.018,223.092 83.645,223.092 82.222 C 223.092 80.646,223.156 80.409,223.614 80.290 C 224.069 80.171,224.136 79.934,224.136 78.433 C 224.136 77.077,224.219 76.712,224.527 76.712 C 224.837 76.712,224.918 76.339,224.918 74.916 C 224.918 73.340,224.982 73.104,225.440 72.984 C 225.896 72.865,225.962 72.628,225.962 71.127 C 225.962 69.772,226.045 69.406,226.354 69.406 C 226.664 69.406,226.745 69.029,226.745 67.580 C 226.745 66.199,226.833 65.753,227.106 65.753 C 227.552 65.753,227.780 64.952,227.785 63.368 C 227.788 62.534,227.911 62.109,228.180 62.006 C 228.468 61.896,228.571 61.440,228.571 60.282 C 228.571 59.056,228.687 58.593,229.093 58.187 C 229.486 57.794,229.615 57.317,229.615 56.262 C 229.615 55.333,229.747 54.749,230.007 54.534 C 230.271 54.314,230.398 53.725,230.398 52.716 C 230.398 51.554,230.514 51.118,230.920 50.750 C 231.338 50.372,231.442 49.947,231.442 48.614 C 231.442 47.376,231.542 46.912,231.833 46.800 C 232.128 46.687,232.224 46.213,232.224 44.882 C 232.224 43.333,232.289 43.097,232.746 42.977 C 233.202 42.858,233.268 42.621,233.268 41.120 C 233.268 39.765,233.351 39.400,233.659 39.400 C 233.966 39.400,234.051 39.044,234.051 37.767 C 234.051 36.416,234.141 36.077,234.573 35.807 C 234.999 35.542,235.095 35.199,235.095 33.946 C 235.095 32.822,235.199 32.370,235.486 32.261 C 235.774 32.150,235.877 31.695,235.877 30.537 C 235.877 29.311,235.993 28.847,236.399 28.441 C 236.792 28.048,236.921 27.571,236.921 26.512 C 236.921 25.502,237.032 25.062,237.312 24.955 C 237.605 24.842,237.704 24.374,237.704 23.100 C 237.704 21.828,237.795 21.396,238.063 21.396 C 238.459 21.396,238.748 20.295,238.748 18.782 C 238.748 18.149,238.887 17.745,239.139 17.649 C 239.432 17.536,239.530 17.068,239.530 15.794 C 239.530 14.526,239.622 14.090,239.888 14.090 C 240.255 14.090,240.566 12.826,240.571 11.313 C 240.573 10.827,240.733 10.432,240.965 10.343 C 241.257 10.231,241.357 9.766,241.357 8.516 C 241.357 7.267,241.457 6.802,241.748 6.690 C 242.029 6.582,242.140 6.142,242.140 5.131 C 242.140 4.118,242.286 3.537,242.661 3.060 C 243.011 2.615,243.183 2.001,243.183 1.198 L 243.183 0.000 145.858 0.000 L 48.532 0.000 48.532 1.174 M157.649 61.448 C 157.584 62.003,157.400 62.361,157.180 62.361 C 156.904 62.361,156.817 62.802,156.817 64.188 C 156.817 65.637,156.736 66.014,156.425 66.014 C 156.115 66.014,156.034 66.391,156.034 67.841 C 156.034 69.493,155.984 69.667,155.512 69.667 C 155.222 69.667,154.990 69.841,154.990 70.059 C 154.990 70.404,151.888 70.450,128.637 70.450 L 102.283 70.450 102.283 69.537 C 102.283 68.899,102.401 68.624,102.674 68.624 C 102.985 68.624,103.066 68.247,103.066 66.797 C 103.066 65.145,103.116 64.971,103.588 64.971 C 104.060 64.971,104.110 64.797,104.110 63.144 C 104.110 61.695,104.190 61.318,104.501 61.318 C 104.716 61.318,104.892 61.142,104.892 60.926 C 104.892 60.581,108.003 60.535,131.324 60.535 L 157.756 60.535 157.649 61.448 " stroke="none" fill="#fcfcfc" fill-rule="evenodd"></path><path id="path1" d="M254.925 1.174 C 254.925 2.044,254.824 2.348,254.534 2.348 C 254.224 2.348,254.142 2.722,254.142 4.144 C 254.142 5.721,254.078 5.957,253.620 6.077 C 253.165 6.196,253.098 6.433,253.098 7.934 C 253.098 9.289,253.015 9.654,252.707 9.654 C 252.396 9.654,252.316 10.031,252.316 11.481 C 252.316 12.868,252.228 13.307,251.952 13.307 C 251.450 13.307,251.272 13.893,251.272 15.546 C 251.272 16.629,251.180 16.960,250.881 16.960 C 250.570 16.960,250.489 17.337,250.489 18.787 C 250.489 20.168,250.401 20.613,250.128 20.613 C 249.680 20.613,249.454 21.416,249.449 23.027 C 249.446 23.953,249.347 24.266,249.054 24.266 C 248.747 24.266,248.663 24.627,248.663 25.949 C 248.663 27.212,248.560 27.690,248.251 27.863 C 247.973 28.018,247.790 28.627,247.690 29.725 C 247.598 30.743,247.410 31.408,247.189 31.492 C 246.944 31.587,246.836 32.132,246.836 33.283 C 246.836 34.480,246.728 34.999,246.447 35.156 C 246.197 35.296,245.996 35.979,245.886 37.061 C 245.786 38.039,245.566 38.835,245.362 38.956 C 245.125 39.096,245.010 39.707,245.010 40.820 C 245.010 41.994,244.904 42.516,244.646 42.615 C 244.421 42.701,244.211 43.375,244.093 44.389 C 243.989 45.288,243.741 46.185,243.543 46.383 C 243.249 46.677,242.993 49.155,243.152 50.163 C 243.169 50.271,243.037 50.329,242.857 50.294 C 242.628 50.248,242.508 50.751,242.454 51.987 C 242.391 53.417,242.282 53.796,241.867 54.018 C 241.448 54.242,241.357 54.570,241.357 55.856 C 241.357 57.006,241.253 57.460,240.965 57.570 C 240.671 57.683,240.574 58.158,240.574 59.489 C 240.574 61.037,240.509 61.274,240.052 61.393 C 239.597 61.512,239.530 61.749,239.530 63.250 C 239.530 64.606,239.447 64.971,239.139 64.971 C 238.829 64.971,238.748 65.344,238.748 66.767 C 238.748 68.343,238.684 68.579,238.226 68.699 C 237.770 68.818,237.704 69.055,237.704 70.556 C 237.704 71.911,237.621 72.277,237.312 72.277 C 237.002 72.277,236.921 72.650,236.921 74.073 C 236.921 75.649,236.857 75.885,236.399 76.005 C 235.944 76.124,235.877 76.361,235.877 77.862 C 235.877 79.217,235.794 79.583,235.486 79.583 C 235.176 79.583,235.095 79.956,235.095 81.379 C 235.095 82.955,235.031 83.191,234.573 83.311 C 234.117 83.430,234.051 83.667,234.051 85.168 C 234.051 86.523,233.968 86.888,233.659 86.888 C 233.349 86.888,233.268 87.265,233.268 88.715 C 233.268 90.102,233.181 90.541,232.905 90.541 C 232.404 90.541,232.224 91.126,232.224 92.753 C 232.224 93.744,232.113 94.181,231.833 94.289 C 231.540 94.401,231.442 94.869,231.442 96.143 C 231.442 97.420,231.351 97.847,231.081 97.847 C 230.634 97.847,230.406 98.649,230.401 100.233 C 230.399 101.067,230.276 101.491,230.007 101.595 C 229.718 101.705,229.615 102.160,229.615 103.319 C 229.615 104.544,229.500 105.008,229.093 105.414 C 228.701 105.807,228.571 106.284,228.571 107.339 C 228.571 108.268,228.439 108.852,228.180 109.067 C 227.907 109.294,227.789 109.895,227.789 111.054 C 227.789 112.433,227.700 112.771,227.267 113.042 C 226.835 113.311,226.745 113.650,226.745 115.009 C 226.745 116.227,226.644 116.689,226.354 116.801 C 226.059 116.914,225.962 117.388,225.962 118.719 C 225.962 120.268,225.897 120.504,225.440 120.624 C 224.985 120.743,224.918 120.979,224.918 122.480 C 224.918 123.836,224.835 124.201,224.527 124.201 C 224.217 124.201,224.136 124.574,224.136 125.997 C 224.136 127.574,224.072 127.810,223.614 127.929 C 223.159 128.049,223.092 128.285,223.092 129.786 C 223.092 131.142,223.009 131.507,222.701 131.507 C 222.390 131.507,222.309 131.884,222.309 133.333 C 222.309 134.721,222.222 135.160,221.946 135.160 C 221.453 135.160,221.265 135.742,221.265 137.277 C 221.265 138.184,221.149 138.613,220.874 138.718 C 220.586 138.829,220.483 139.284,220.483 140.443 C 220.483 141.614,220.371 142.099,220.045 142.337 C 219.745 142.556,219.571 143.164,219.491 144.278 C 219.415 145.325,219.246 145.948,219.015 146.037 C 218.765 146.133,218.656 146.654,218.656 147.749 C 218.656 148.880,218.541 149.407,218.245 149.623 C 217.981 149.817,217.781 150.511,217.685 151.567 C 217.592 152.593,217.403 153.260,217.183 153.345 C 216.938 153.439,216.830 153.983,216.830 155.121 C 216.830 156.272,216.723 156.802,216.471 156.899 C 216.246 156.985,216.044 157.672,215.930 158.737 C 215.828 159.690,215.584 160.573,215.376 160.746 C 215.132 160.949,215.003 161.575,215.003 162.557 C 215.003 163.574,214.877 164.164,214.612 164.384 C 214.348 164.602,214.220 165.191,214.220 166.184 C 214.220 167.337,214.106 167.757,213.699 168.106 C 213.240 168.499,212.933 170.670,213.146 172.016 C 213.163 172.123,213.030 172.182,212.851 172.146 C 212.622 172.100,212.502 172.601,212.448 173.828 C 212.383 175.295,212.289 175.602,211.861 175.738 C 211.423 175.876,211.350 176.141,211.350 177.586 C 211.350 178.845,211.251 179.311,210.959 179.423 C 210.663 179.536,210.568 180.014,210.568 181.372 C 210.568 182.996,210.517 183.170,210.046 183.170 C 209.574 183.170,209.524 183.344,209.524 184.997 C 209.524 186.446,209.443 186.823,209.132 186.823 C 208.822 186.823,208.741 187.197,208.741 188.619 C 208.741 190.196,208.677 190.432,208.219 190.552 C 207.764 190.671,207.697 190.908,207.697 192.409 C 207.697 193.764,207.614 194.129,207.306 194.129 C 206.996 194.129,206.915 194.503,206.915 195.925 C 206.915 197.502,206.851 197.738,206.393 197.858 C 205.925 197.980,205.871 198.214,205.871 200.106 L 205.871 202.218 295.890 202.218 C 375.734 202.218,385.910 202.174,385.910 201.826 C 385.910 201.611,386.086 201.435,386.301 201.435 C 386.611 201.435,386.693 201.062,386.693 199.639 C 386.693 198.062,386.757 197.826,387.215 197.707 C 387.670 197.587,387.736 197.351,387.736 195.850 C 387.736 194.494,387.820 194.129,388.128 194.129 C 388.438 194.129,388.519 193.756,388.519 192.333 C 388.519 190.756,388.583 190.520,389.041 190.401 C 389.495 190.282,389.563 190.045,389.563 188.572 C 389.563 187.308,389.662 186.841,389.954 186.729 C 390.247 186.617,390.346 186.149,390.346 184.874 C 390.346 183.592,390.436 183.170,390.709 183.170 C 391.210 183.170,391.389 182.586,391.389 180.959 C 391.389 179.968,391.501 179.530,391.781 179.423 C 392.069 179.312,392.172 178.857,392.172 177.699 C 392.172 176.473,392.288 176.010,392.694 175.603 C 393.087 175.211,393.216 174.734,393.216 173.674 C 393.216 172.664,393.326 172.225,393.607 172.117 C 393.898 172.005,393.999 171.543,393.999 170.321 C 393.999 168.997,394.101 168.587,394.521 168.228 C 394.927 167.880,395.042 167.458,395.042 166.324 C 395.042 165.378,395.179 164.731,395.434 164.477 C 395.700 164.211,395.825 163.553,395.825 162.426 C 395.825 160.995,395.897 160.743,396.347 160.600 C 396.803 160.455,396.869 160.205,396.869 158.626 C 396.869 157.192,396.950 156.817,397.260 156.817 C 397.570 156.817,397.652 156.443,397.652 155.021 C 397.652 153.444,397.715 153.208,398.174 153.088 C 398.629 152.969,398.695 152.732,398.695 151.231 C 398.695 149.876,398.778 149.511,399.087 149.511 C 399.397 149.511,399.478 149.134,399.478 147.684 C 399.478 146.641,399.590 145.858,399.739 145.858 C 399.893 145.858,400.000 144.945,400.000 143.640 L 400.000 141.422 345.727 141.422 L 291.455 141.422 291.455 139.987 C 291.455 138.885,291.546 138.552,291.846 138.552 C 292.157 138.552,292.237 138.175,292.237 136.725 C 292.237 135.344,292.325 134.899,292.598 134.899 C 293.045 134.899,293.273 134.097,293.278 132.513 C 293.280 131.680,293.403 131.255,293.673 131.152 C 293.965 131.039,294.064 130.571,294.064 129.297 C 294.064 128.025,294.155 127.593,294.423 127.593 C 294.819 127.593,295.108 126.492,295.108 124.979 C 295.108 124.346,295.247 123.942,295.499 123.846 C 295.792 123.733,295.890 123.265,295.890 121.991 C 295.890 120.723,295.982 120.287,296.248 120.287 C 296.607 120.287,296.926 119.030,296.931 117.594 C 296.933 117.189,297.110 116.682,297.326 116.466 C 297.584 116.208,297.717 115.558,297.717 114.556 C 297.717 113.498,297.827 112.995,298.080 112.897 C 298.307 112.811,298.516 112.135,298.635 111.108 C 298.739 110.201,298.987 109.227,299.184 108.944 C 299.386 108.655,299.543 107.783,299.543 106.954 C 299.543 105.960,299.671 105.372,299.935 105.153 C 300.213 104.922,300.326 104.311,300.326 103.034 C 300.326 101.413,300.377 101.239,300.848 101.239 C 301.320 101.239,301.370 101.065,301.370 99.413 C 301.370 97.963,301.451 97.586,301.761 97.586 C 302.069 97.586,302.153 97.226,302.153 95.908 C 302.153 94.459,302.224 94.207,302.674 94.064 C 303.124 93.921,303.196 93.669,303.196 92.248 C 303.196 91.021,303.297 90.559,303.588 90.447 C 303.879 90.335,303.979 89.870,303.979 88.623 C 303.979 87.169,304.048 86.931,304.501 86.813 C 304.955 86.694,305.023 86.457,305.023 84.984 C 305.023 83.720,305.122 83.253,305.414 83.141 C 305.706 83.029,305.806 82.564,305.806 81.317 C 305.806 79.863,305.874 79.625,306.327 79.507 C 306.782 79.388,306.849 79.151,306.849 77.678 C 306.849 76.414,306.948 75.947,307.241 75.835 C 307.532 75.723,307.632 75.258,307.632 74.011 C 307.632 72.557,307.701 72.320,308.154 72.201 C 308.608 72.082,308.676 71.845,308.676 70.372 C 308.676 69.108,308.775 68.641,309.067 68.529 C 309.360 68.417,309.459 67.949,309.459 66.675 C 309.459 65.392,309.548 64.971,309.822 64.971 C 310.322 64.971,310.502 64.386,310.502 62.759 C 310.502 61.768,310.614 61.331,310.894 61.223 C 311.182 61.113,311.285 60.658,311.285 59.499 C 311.285 58.274,311.400 57.810,311.807 57.404 C 312.199 57.011,312.329 56.534,312.329 55.479 C 312.329 54.550,312.461 53.966,312.720 53.751 C 312.984 53.532,313.112 52.944,313.112 51.950 C 313.112 50.798,313.226 50.377,313.633 50.028 C 314.040 49.680,314.155 49.258,314.155 48.125 C 314.155 47.178,314.292 46.532,314.547 46.277 C 314.813 46.011,314.938 45.352,314.938 44.218 C 314.938 42.816,315.022 42.505,315.460 42.270 C 315.899 42.035,315.982 41.724,315.982 40.304 C 315.982 38.978,316.066 38.617,316.373 38.617 C 316.683 38.617,316.765 38.244,316.765 36.821 C 316.765 35.244,316.828 35.008,317.286 34.889 C 317.742 34.769,317.808 34.533,317.808 33.032 C 317.808 31.676,317.891 31.311,318.200 31.311 C 318.510 31.311,318.591 30.938,318.591 29.515 C 318.591 27.938,318.655 27.702,319.113 27.583 C 319.568 27.464,319.635 27.227,319.635 25.726 C 319.635 24.370,319.718 24.005,320.026 24.005 C 320.337 24.005,320.417 23.628,320.417 22.179 C 320.417 20.791,320.505 20.352,320.781 20.352 C 321.283 20.352,321.461 19.767,321.461 18.113 C 321.461 17.030,321.553 16.699,321.853 16.699 C 322.163 16.699,322.244 16.322,322.244 14.873 C 322.244 13.492,322.332 13.046,322.605 13.046 C 323.054 13.046,323.279 12.244,323.284 10.633 C 323.287 9.707,323.387 9.393,323.679 9.393 C 323.990 9.393,324.070 9.016,324.070 7.567 C 324.070 6.191,324.159 5.740,324.429 5.740 C 324.826 5.740,325.114 4.639,325.114 3.126 C 325.114 2.493,325.253 2.090,325.506 1.993 C 325.751 1.899,325.897 1.500,325.897 0.921 L 325.897 0.000 290.411 0.000 L 254.925 0.000 254.925 1.174 " stroke="none" fill="#7cc444" fill-rule="evenodd"></path><path id="path2" d="" stroke="none" fill="#100e0cc" fill-rule="evenodd"></path><path id="path3" d="" stroke="none" fill="#100e0cc" fill-rule="evenodd"></path><path id="path4" d="" stroke="none" fill="#100e0cc" fill-rule="evenodd"></path></g></svg>
]])

events.render:set(function()
    -- local offset, x, y = 0, screen_size.x / 2, screen_size.y / 1.4
    -- local npcdpi = render.screen_size()
    -- x = tointeger(npcdpi.x * 0.5)

    -- for idx, data in ipairs(logs) do
    --     if globals.realtime - data[3] < 7.0 and not (#logs > 7 and idx < #logs - 7) then
    --         data[2] = math.lerp(data[2], 255, 28)
    --     else
    --         data[2] = math.lerp(data[2], 0, 48)
    --     end

    --     offset = offset - 28 * (data[2] / 255)

    --     text_size = render.measure_text(font, s, data[1])
    --     left, middle, right = color(0, 200, 255, data[2]), color(255, 0, 238, data[2]), color(255, 234, 0, data[2])
    --     timer_color = menu.hitlogs_color:get() -- Change this to the desired color

    --     outline_color = color(60, 60, 60, (data[2] / 255) * 230)
    --     bg_color = color(17, 17, 17, (data[2] / 255) * 230)
    --     metal_color = color(44, 44, 44, (data[2] / 255) * 230)
    --     bg_rect_size = vector(x + 4 + text_size.x / 1.5, y - offset + 20)
    --     bg_rect_pos = vector(x - 4 - text_size.x / 1.5, y - offset)

    --     render.rect(bg_rect_pos - vector(2,2), bg_rect_size + vector(4,4), outline_color)
    --     render.rect(bg_rect_pos - vector(1,1), bg_rect_size + vector(2,2), bg_color)
    --     render.rect(bg_rect_pos, bg_rect_size, metal_color) -- add metal texture
        
    --     render.push_clip_rect(vector(x - 3 - text_size.x / 1.5, y - offset + 1), vector((x + 3 + text_size.x / 1.5) - ((globals.realtime - data[3]) / 5.25) * (text_size.x + 3), y - offset + 2))
    --     render.gradient(vector(x - 3 - text_size.x / 1.5, y - offset + 1), vector(x, y - offset + 2), left, middle, left, middle)
    --     render.gradient(vector(x, y - offset + 1), vector(x + 3 + text_size.x / 1.5, y - offset + 2), middle, right, middle, right)
    --     -- render.rect(vector(x - 3 - text_size.x / 1.5, y - offset + 1), vector((x + 3 + text_size.x / 1.5) - ((globals.realtime - data[3]) / 5.25) * (text_size.x + 3), 1), timer_color)
    --     render.pop_clip_rect()
    --     render.text(1, vector(x - text_size.x / 2, y - offset + 4), color(255, 255, 255, (data[2] / 255) * 255), nil, data[1])
    --     render.texture(hitlogs_image, vector(x - text_size.x / 1.5 + 5, y - offset + 4), vector(20,15), color(255, 255, 255, (data[2] / 255) * 255))
    --     if data[2] < 0.1 then table.remove(logs, idx) end
    -- end

     --     /$$$$$$  /$$   /$$  /$$$$$$  /$$$$$$$$        /$$$$$$  /$$$$$$$  /$$$$$$$$       /$$        /$$$$$$   /$$$$$$ 
    --     /$$__  $$| $$  | $$ /$$__  $$|__  $$__/       /$$__  $$| $$__  $$|__  $$__/      | $$       /$$__  $$ /$$__  $$
    --    | $$  \__/| $$  | $$| $$  \ $$   | $$         | $$  \__/| $$  \ $$   | $$         | $$      | $$  \ $$| $$  \__/
    --    | $$      | $$$$$$$$| $$$$$$$$   | $$         | $$ /$$$$| $$$$$$$/   | $$         | $$      | $$  | $$| $$ /$$$$
    --    | $$      | $$__  $$| $$__  $$   | $$         | $$|_  $$| $$____/    | $$         | $$      | $$  | $$| $$|_  $$
    --    | $$    $$| $$  | $$| $$  | $$   | $$         | $$  \ $$| $$         | $$         | $$      | $$  | $$| $$  \ $$
    --    |  $$$$$$/| $$  | $$| $$  | $$   | $$         |  $$$$$$/| $$         | $$         | $$$$$$$$|  $$$$$$/|  $$$$$$/
    --     \______/ |__/  |__/|__/  |__/   |__/          \______/ |__/         |__/         |________/ \______/  \______/ 
                                                                                                                                                                                                     
                                                                                                                
    local offset, x, y = 0, screen_size.x / 2, screen_size.y / 1.4
    local npcdpi = render.screen_size()
    x = tointeger(npcdpi.x * 0.5)

    for idx, data in ipairs(logs) do
        if globals.realtime - data[3] < 7.0 and not (#logs > 7 and idx < #logs - 7) then
            data[2] = math.lerp(data[2], 255, 28)
        else
            data[2] = math.lerp(data[2], 0, 48)
        end

        offset = offset - 35 * (data[2] / 255)  -- Increase this multiplier to make the how much down it go bigger retard chat gpy

        text_size = render.measure_text(font, s, data[1])
        left, middle, right = color(0, 200, 255, data[2]), color(255, 0, 238, data[2]), color(255, 234, 0, data[2])
        -- timer_color = menu.hitlogs_color:get() -- Change this to the desired color useless btw

        outline_color = color(60, 60, 60, (data[2] / 255) * 255)  -- Change this to light grey. --cancer to your mother chgat gpy
        bg_color = color(10, 10, 10, (data[2] / 255) * 255)  -- Change the background color to black.
        metal_color = color(44, 44, 44, (data[2] / 255) * 255)
        metal_color2 = color(22, 22, 22, (data[2] / 255) * 255)
        bg_rect_size = vector(x + text_size.x / 1.5, y - offset + 20)  -- Increase these values to make the rectangle bigger.
        bg_rect_pos = vector(x - text_size.x / 1.5, y - offset)

        local opacity = (data[2] / 255) * 255

        local adaptive = {
            color(20, 20, 20, 255),
            color(30, 30, 30, 255),
            color(40, 40, 40, 255),
            color(60, 60, 60, 255),
        }

        -- render.rect_outline(bg_rect_pos - vector(2,2), bg_rect_size + vector(4,4), metal_color2, 4)  -- Set the rounding to 0 and increase the thickness.
        -- render.rect_outline(bg_rect_pos - vector(2,2), bg_rect_size + vector(4,4), outline_color,2)  -- Set the rounding to 0 and increase the thickness.
        -- render.rect(bg_rect_pos - vector(1,1), bg_rect_size + vector(2,2), metal_color)  -- Set the rounding to 0.
        -- render.rect(bg_rect_pos, bg_rect_size, bg_color)  -- Set the rounding to 0 and add metal texture.

        render.rect(bg_rect_pos, bg_rect_size, adaptive[1]:alpha_modulate(opacity))
        render.push_clip_rect(vector(x - 3 - text_size.x / 1.5, y - offset + 1), vector((x + 3 + text_size.x / 1.5), y - offset + 2))
        render.gradient(vector(x - 3 - text_size.x / 1.5, y - offset + 1), vector(x, y - offset + 2), left, middle, left, middle)
        render.gradient(vector(x, y - offset + 1), vector(x + 3 + text_size.x / 1.5, y - offset + 2), middle, right, middle, right)
        -- render.rect(vector(x - 3 - text_size.x / 1.5, y - offset + 1), vector((x + 3 + text_size.x / 1.5) - ((globals.realtime - data[3]) / 5.25) * (text_size.x + 3), 1), timer_color)
        render.pop_clip_rect()
        render.rect_outline(bg_rect_pos - 6, bg_rect_size + 6, adaptive[2]:alpha_modulate(opacity), 1)
        render.rect_outline(bg_rect_pos - 5, bg_rect_size + 5, adaptive[4]:alpha_modulate(opacity), 1)
        render.rect_outline(bg_rect_pos - 4, bg_rect_size + 4, adaptive[3]:alpha_modulate(opacity), 1)
        render.rect_outline(bg_rect_pos - 3, bg_rect_size + 3, adaptive[3]:alpha_modulate(opacity), 3)
        render.rect_outline(bg_rect_pos - 1, bg_rect_size + 1, adaptive[4]:alpha_modulate(opacity), 2)

        
        if string.match(data[1], "\aA1FF8FFFMissed\aFFFFFFFF shot at \aA1FF8FFF") then
            render.texture(hitlogs_image, vector(x - text_size.x / 1.6 + 5, y - offset + 4), vector(20,15), color(255, 255, 255, (data[2] / 255) * 255))  -- Increase these values to make the texture bigger.
        else
            render.texture(hitlogs_image, vector(x - text_size.x / 1.5 + 5, y - offset + 4), vector(20,15), color(255, 255, 255, (data[2] / 255) * 255))  -- Increase these values to make the texture bigger.
        end
        
        render.text(1, vector(x - text_size.x / 2, y - offset + 4), color(255, 255, 255, (data[2] / 255) * 255), nil, data[1])  -- You can change the font size here to make the text bigger.
        if data[2] < 0.1 then table.remove(logs, idx) end
    end
end)

render.log = function(text, size)
    table.insert(logs, { text, 0, globals.realtime, size })
end

local x, y = render.screen_size().x, render.screen_size().y



-- cfg.load = function(text)

--     if string.match(text, "afterlife_") then

--         local kfg = string.gsub(text, "afterlife_", "")
--         local success, kfg_dat = pcall(shitjson.decode, base64.decode(kfg))

--         if success then
--             utils.console_exec("playvol  buttons/bell1.wav 1")
--             functions.log("[~] Config \a2BFF00FFImported Successfully")
            
--             -- if menu.hitlogs_style:get() == "Boxed" then
--                 render.log("[~] Config \a2BFF00FFImported Successfully")
--             -- end
            
--             for k,v in pairs(kfg_dat) do
--                 local milking_table = kfg_sys.nameslol[k]
--                 if milking_table then
--                     milking_table = milking_table.reference_element

--                     milking_table:set(milking_table:type() == "color_picker" and color(unpack(v)) or (v == "56575912 clear" and {} or v))

--                 end
--             end
--         else
--             functions.log("[~] Something Went Wrong While Loading This Config")
--             -- if menu.hitlogs_style:get() == "Boxed" then
--                 render.log("[~] Config \aFF1919FFerror")
--             -- end
--         end
--     else
--         functions.log('[~] Unsupported Configuration Error')
--         -- if menu.hitlogs_style:get() == "Boxed" then
--             render.log("[~] \aFF8C19FFUnsupported format")
--         -- end
--     end

-- end

animation.lerp = function(start, end_pos, time)
    if type(start) == 'userdata' then
        local color_data = {0, 0, 0, 0}
        for i, color_key in ipairs({'r', 'g', 'b', 'a'}) do
            color_data[i] = animation.lerp(start[color_key], end_pos[color_key], time)
        end
        return color(unpack(color_data))
    end
    return (end_pos - start) * (globals.frametime * time * 175) + start
end

animation.new = function(name, value, time)
    if animation.data[name] == nil then
        animation.data[name] = value
    end
    animation.data[name] = animation.lerp(animation.data[name], value, time)
    return animation.data[name]
end


-- menu.global.export:set_callback(function()

--     local kfg_stats = {}

--     for k,v in pairs(kfg_sys.nameslol) do
--         local milking_table = v.reference_element
--         local v = milking_table:get()

--         if type(v) == "table" then
--             if #v == 0 then
--                 v = "56575912 clear"
--             end
--         end
--         kfg_stats[k] = milking_table:type() == "color_picker" and {v.r, v.g, v.b, v.a} or v
--     end

--     requires[3].set("afterlife_"..base64.encode(shitjson.encode(kfg_stats)))  
--     functions.log('[~] Config Exported Successfully')
--     render.log("    Config exported successfully")
-- end)

-- menu.global.import:set_callback(function()
--     if string.match(requires[3].get(), "afterlife_") then
--         local kfg = requires[3].get()
--         cfg.load(kfg)
--     else
--         utils.console_exec("playvol  error.wav 1")
--         functions.log('[~] Unsupported Configuration Error')
--     end
-- end)

-- menu.global.default:set_callback(function()
--     local kfg = network.get('https://pashanim.autos/kfgnightly.txt')
--     if string.match(kfg, "afterlife_") then
--         cfg.load(kfg)
--     else
--         utils.console_exec("playvol  error.wav 1")
--         functions.log('[~] Unsupported Configuration Error')
--     end

-- end)





local hitgroup_str = {
    [0] = 'generic',
    'head', 'chest', 'stomach',
    'left arm', 'right arm',
    'left leg', 'right leg',
    'neck', 'generic', 'gear'
}

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

    if menu.misc.hitlogs_enable:get() and state == nil then
    --if not globals.is_connected and not globals.is_in_game then return false end

        if menu.logs:get(4) then
            local cumcolor = menu.ui_accent_color:get():to_hex()
            cumcolor = cumcolor:sub(1, -3)
            functions.log(("\aA0FB87FF[+] \aFFFFFFFFshot at %s's %s for \aA0FB87FF%d("..string.format("%.f", wanted_damage)..") \aFFFFFFFFdamage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
            print_raw(("\a"..cumcolor.."[afterlife] \a868686» \aA0FB87Registered \aFFFFFFshot at %s's %s for \aA0FB87%d("..string.format("%.f", wanted_damage)..") \aFFFFFFdamage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
        end
        
        -- if menu.hitlogs_style:get() == "Boxed" then
            -- render.log(("Hit \aA1FF8FFF%s's \aFFFFFFFF%s for \aA1FF8FFF%d\aFFFFFFFF ("..string.format("%.f", wanted_damage)..") [bt: \aA1FF8FFF%s \aFFFFFFFF| hp: \aA1FF8FFF"..health.."\aFFFFFFFF]"):format(target:get_name(), hitgroup, e.damage, bt))
            render.log(("Hit \aA1FF8FFF%s\aFFFFFFFF's \aFFFFFFFF%s for \aA1FF8FFF%d\aFFFFFFFF(%d)\aFFFFFFFF [bt: \aA1FF8FFF%s\aFFFFFFFF - hp: \aA1FF8FFF"..health.."\aFFFFFFFF]"):format(target:get_name(), hitgroup, e.damage, wanted_damage, bt))
        -- end
    elseif menu.misc.hitlogs_enable:get() then
        
        if menu.logs:get(4) then
            local cumcolor = menu.ui_accent_color:get():to_hex()
            cumcolor = cumcolor:sub(1, -3)
            functions.log(('\aE94B4BFF[-] \aFFFFFFFFshot in %s in the %s due to \aE94B4BFF'..state..' \aFFFFFFFF(hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
            print_raw(('\a'..cumcolor..'[afterlife] \a868686» \aE94B4BMissed \aFFFFFFshot at %s in the %s due to \aE94B4B'..state..' \aFFFFFF(hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
        end
        
        -- if menu.hitlogs_style:get() == "Boxed" then
            -- render.log(('Missed \aA1FF8FFF%s \aFFFFFFFFin the %s due to \aE94B4BFF'..state..' \aFFFFFFFF(hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
            if e.spread ~= nil then e.spread = math.floor(e.spread) else e.spread = 0 end
            if e.aim.z ~= nil then e.aim.z = math.floor(e.aim.z) else e.aim.z = 0 end
            render.log("\aA1FF8FFFMissed\aFFFFFFFF shot at \aA1FF8FFF"..target:get_name().."\aFFFFFFFF's \aFFFFFFFF"..wanted_hitgroup.." due to \aA1FF8FFF"..state.."\aFFFFFFFF("..hitchance.."%) \aFFFFFFFF[damage: \aA1FF8FFF"..wanted_damage.."\aFFFFFFFF bt: \aA1FF8FFF"..bt.." \aFFFFFFFFspread: \aA1FF8FFF"..math.floor(e.spread).."°\aFFFFFFFF]")
        -- end
    end
end)
-- if menu.hitlogs_style:get() == "Boxed" then
    render.log(randomphrase..", "..lua.username.."?", ui.get_style("Active Text"):alpha_modulate(255))
-- end


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
            
            local color = "FFFFFF"

            if type_hit == "Naded" then
                color = "00A11B"
            elseif type_hit == "Knifed" then
                color = "1764FF"
            elseif type_hit == "Burned" then
                color = "FF9900"
            end
            if menu.misc.hitlogs_enable:get() and menu.logs:get(4) then
                local cumcolor = menu.ui_accent_color:get():to_hex()
                cumcolor = cumcolor:sub(1, -3)
                functions.log((''..type_hit..' \a'..color..'FF%s \aFFFFFFFFfor \a'..color..'FF%d \aFFFFFFFFdamage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
                print_raw(('\a'..cumcolor..'[afterlife] \a868686» \aDEFAULT '..type_hit..' \a'..color..'%s \aFFFFFFfor \a'..color..'%d \aFFFFFFdamage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
            end
            if weapon == 'hegrenade' then
                -- if menu.hitlogs_style:get() == "Boxed" and menu.misc.hitlogs_enable:get() then
                    render.log((''..type_hit..' \a'..color..'FF%s \aFFFFFFFFfor \a'..color..'FF%d \aFFFFFFFFdamage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
                -- end
            end
        end

    end
end)


-----------HITMARKERLOL
local contents1 = "\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff"
local contents2 = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"

local texture1 = render.load_image_rgba(contents1, vector(5, 5))
local texture2 = render.load_image_rgba(contents2, vector(5, 5))
local hitmarker_alpha = 255

hitmarker_ack = function(event)
    local target = entity.get(event.target)
    if not target or target == nil then return end
    
    if event.state == nil then
        shot_hit = true
        hitmarker_alpha = 255        
    end
end

hitmarker_f =  function() 
    if not menu.inds500:get("Hitmarker") then 
        return 
    end

    local r,g,b = 255,255,255
    
    if shot_hit then 
        hitmarker_alpha = hitmarker_alpha - 2
        if hitmarker_alpha < 25 then 
            shot_hit = false 
        end
    end

    -- hit
    if shot_hit then
        render.texture(texture1, vector(x/2 -10, y/2    -10), vector(5,5), color(r, g, b, hitmarker_alpha), "")
        render.texture(texture2, vector(x/2 +6, y/2     -10), vector(5,5), color(r, g, b, hitmarker_alpha), "")
        render.texture(texture2, vector(x/2 -10, y/2    +6), vector(5,5), color(r, g, b, hitmarker_alpha), "")
        render.texture(texture1, vector(x/2 +6, y/2     +6), vector(5,5), color(r, g, b, hitmarker_alpha), "")
    end
end 

events.aim_ack:set(function(event)
    hitmarker_ack(event)
end)

events.render:set(function()
    lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    x = render.screen_size().x
    y = render.screen_size().y

    hitmarker_f()
end)


events.render:set(function ()
    if menu.misc.aspectratio:get() then 
        cvar.r_aspectratio:float(menu.aspectratio_value:get()/10)
    else
		cvar.r_aspectratio:float(0)
    end
end)


local lerp = function(time,a,b)
    return a * (1-time) + b * time
end
length = 0
gap = 0
events.render:set(function ()
    if menu.visuals.custom_scope_enable:get() then
        local x = render.screen_size().x
        local y = render.screen_size().y
        local localplayer = entity.get_local_player()
        ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove All")
        if localplayer == nil then return end
        if localplayer.m_iHealth < 1 then return end
		length = lerp(0.2, length, localplayer.m_bIsScoped and menu.custom_scope_length:get() or 0) 
		gap = lerp(0.2, gap, localplayer.m_bIsScoped and menu.custom_scope_gap:get() or 0) 
		local scopeColor_x = color(menu.custom_scope_color:get().r, menu.custom_scope_color:get().g, menu.custom_scope_color:get().b, menu.custom_scope_color:get().a)
		local scopeColor_y = color(menu.custom_scope_color:get().r, menu.custom_scope_color:get().g, menu.custom_scope_color:get().b, 0)
		render.gradient(vector(x / 2 - gap, y / 2), vector(x / 2 - gap - length, y / 2 + 1), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
		render.gradient(vector(x / 2 + gap, y / 2), vector(x / 2 + gap + length, y / 2 + 1), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
		render.gradient(vector(x / 2, y / 2 + gap), vector(x / 2 + 1, y / 2 + gap + length), scopeColor_x, scopeColor_x, scopeColor_y, scopeColor_y)
		render.gradient(vector(x / 2, y / 2 - gap), vector(x / 2 + 1, y / 2 - gap - length), scopeColor_x, scopeColor_x, scopeColor_y, scopeColor_y)
	else
		ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove Overlay")
	end
end)








-- DEBUG PANEL

local ghetto_solution_for_conditions = {
	["G"] = "Global",
	["S"] = "Standing",
	["W"] = "Moving",
	["SW"] = "Slowing",
	["C"] = "Crouch",
	["A"] = "Air",
	["AC"] = "Air+",
	["NE"] = "Fake Lag",
}

function debug_panel()
    if not menu.visuals.debug_panel_enable:get() then
        return
    end
    
    if globals.is_connected then
        if entity.get_local_player() then
            if not entity.get_local_player():is_alive() then return end
        end
    end
    
    local screensize = render.screen_size()

    render.text(1, vector(10, screensize.y / 2), color(255), "s", "[ AfterLife Technologies™ ]")
    
    local enemy = entity.get_threat()
    if not enemy then
        enemy = "None"
    else
        enemy = enemy:get_name()
    end
    render.text(1, vector(10, screensize.y / 2 + 15), color(255), "s", "[ Target: "..enemy.." ]")
    


    local preset = "None"
    if globals.is_in_game and entity.get_local_player() then
        if entity.get_local_player():is_alive() then
            preset = ghetto_solution_for_conditions[MTools.AntiAims.Condition:Get()]
        end
    end
    render.text(1, vector(10, screensize.y / 2 + 30), color(255), "s", "[ State: "..preset.." ]")
    
    local choke_limit = 0
    if globals.is_in_game then
        if rage.exploit:get() > 0 then
            choke_limit = "Exploit"
        else
            choke_limit = globals.choked_commands
        end
    end
    render.text(1, vector(10, screensize.y / 2 + 45), color(255), "s", "[ Choke Limit: "..choke_limit.." ]")
    
end

--rendering the panelka
events.render:set(debug_panel)







-- /$$$$$$  /$$$$$$$$ /$$$$$$$$ /$$$$$$$$ /$$$$$$$  /$$       /$$$$$$ /$$$$$$$$ /$$$$$$$$        /$$$$$$  /$$   /$$ /$$$$$$$$ /$$$$$$        /$$$$$$  /$$$$$$ /$$      /$$  /$$$$$$ 
-- /$$__  $$| $$_____/|__  $$__/| $$_____/| $$__  $$| $$      |_  $$_/| $$_____/| $$_____/       /$$__  $$| $$$ | $$|__  $$__/|_  $$_/       /$$__  $$|_  $$_/| $$$    /$$$ /$$__  $$
-- | $$  \ $$| $$         | $$   | $$      | $$  \ $$| $$        | $$  | $$      | $$            | $$  \ $$| $$$$| $$   | $$     | $$        | $$  \ $$  | $$  | $$$$  /$$$$| $$  \__/
-- | $$$$$$$$| $$$$$      | $$   | $$$$$   | $$$$$$$/| $$        | $$  | $$$$$   | $$$$$         | $$$$$$$$| $$ $$ $$   | $$     | $$ /$$$$$$| $$$$$$$$  | $$  | $$ $$/$$ $$|  $$$$$$ 
-- | $$__  $$| $$__/      | $$   | $$__/   | $$__  $$| $$        | $$  | $$__/   | $$__/         | $$__  $$| $$  $$$$   | $$     | $$|______/| $$__  $$  | $$  | $$  $$$| $$ \____  $$
-- | $$  | $$| $$         | $$   | $$      | $$  \ $$| $$        | $$  | $$      | $$            | $$  | $$| $$\  $$$   | $$     | $$        | $$  | $$  | $$  | $$\  $ | $$ /$$  \ $$
-- | $$  | $$| $$         | $$   | $$$$$$$$| $$  | $$| $$$$$$$$ /$$$$$$| $$      | $$$$$$$$      | $$  | $$| $$ \  $$   | $$    /$$$$$$      | $$  | $$ /$$$$$$| $$ \/  | $$|  $$$$$$/
-- |__/  |__/|__/         |__/   |________/|__/  |__/|________/|______/|__/      |________/      |__/  |__/|__/  \__/   |__/   |______/      |__/  |__/|______/|__/     |__/ \______/ 




local refs = {
    fake_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    autopeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
    fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    sw = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    yaw_mod = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    yaw_mod_degree = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    free_body = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    yaw_mod_free = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    desync_freestand = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    aaos = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    hidden_cvars = ui.find("Miscellaneous", "Main", "Other", "Unlock Hidden Cvars"),
    air_strafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),
    scope_type = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
    legmovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    ping_spike = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    fl_limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    dtlim = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"),
}



local lua = {
    conditions = {"Global", "Standing", "Moving", "Slow-walking", "Jumping", "Jump-crouching", "Crouching", "Fake-Lag"},
    conditions_non_g = {"Standing", "Moving", "Slow-walking", "Jumping", "Jump-crouching", "Crouching", "Fake-Lag"},
}

ffi.cdef[[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
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
]]

local uintptr_t = ffi.typeof("uintptr_t**")
local this_call = function(call_function, parameters)
    return function(...)
        return call_function(parameters, ...)
    end
end
local entity_list_003 = ffi.cast(uintptr_t, utils.create_interface("client.dll", "VClientEntityList003"))
local get_entity_address = this_call(ffi.cast("get_client_entity_t", entity_list_003[0][3]), entity_list_003)

local hooked_function = nil

local tabs = {
    aa = {
        main = pui.create(theme_color() .. "\f<shield>", theme_color() .. "\f<shield> \rANTI-AIM"),
        antibrute = pui.create(theme_color() .. "\f<shield>", theme_color() .. "\f<user> \rafterlife"),
        settings = pui.create(theme_color() .. "\f<shield>", theme_color() .. "\f<user> \rafterlife"),
        defensive = pui.create(theme_color() .. "\f<shield>", theme_color() .. "\f<xing> \rDEFENSIVE"),
        misc = pui.create(theme_color() .. "\f<shield>", theme_color() .. "\f<list> \rMISC"),
        -- configs = pui.create(theme_color() .. "\f<shield>", theme_color() .. "CONFIGS"),
    },
}

local anti_aims_menu = {
    aa = {
        enable = tabs.aa.main:switch("Enable", false),
        conds = tabs.aa.main:list("", theme_color().. "\f<gear>  \rGeneral", theme_color().. "\f<shield>  \rConfigure Anti-Aims"),
        cond = tabs.aa.settings:combo("", lua.conditions),
        anti_brute_reset = tabs.aa.settings:slider("Reset time", 1, 60, 6, 1, function(self)
            return self .. "s"
        end),
        max_phase = {},
        afterlife = {},
        ab_afterlife = {},
        defensive = {
            cond = tabs.aa.defensive:selectable("Works on", lua.conditions_non_g),
            pitch = tabs.aa.defensive:combo("Pitch", {"Disabled", "Down", "Fake Up", "Fake Down", "Random"}),
            yaw_mod = tabs.aa.defensive:combo("Yaw", {"Disabled", "Random", "Hidden"}),
        },
        yaw_base = tabs.aa.misc:combo("Manual Yaw", "Default", "Backward", "Left", "Right", "Forward"),
        static_if = tabs.aa.misc:selectable("Static Yaw", {"Warmup", "Manual", "Fake-lag", "Freestand"}),
        tweaks = tabs.aa.misc:selectable("Tweaks", {"Fast Ladder", "Bombsite E Fix", "Safe Knife"}, false, "", function(gear) 
            return {
                options = gear:selectable("Ladder", {"Ascending", "Descending"}),
            }
        end),
        freestand = tabs.aa.misc:switch("Freestanding", false, "", function(gear)
            return {
                disablers = gear:selectable("Disablers", lua.conditions_non_g),
                manual = gear:switch("Disable on Manual"),
            }
        end),
        anim_breakers = tabs.aa.misc:switch("\ab7a257FFAnim breakers", false, "", function(gear)
            return {
                body_lean = gear:slider("Body lean", 0, 100, 0, nil, "%"),
                legs = gear:combo("Legs", {"Disabled", "Forward", "Moonwalk"}),
                airleg = gear:combo("Legs in air", {"Disabled", "Static"}),
                pitch = gear:switch("Pitch on land", false),
            }
        end),

    },
}

for i = 1, #lua.conditions do
    anti_aims_menu.aa.afterlife[i] = {
        enabled = tabs.aa.settings:switch("Override " .. lua.conditions[i]),
        pitch = tabs.aa.settings:combo("Pitch", {"Disabled", "Down", "Fake Up", "Fake Down"}),
        yaw_base = tabs.aa.settings:combo("Yaw", {"Disabled", "Backward"}, 0, function(gear)
            return {
                yaw = gear:combo("Method", "180", "180 L&R"),
                yaw_offset = gear:slider("Offset", -180, 180, 0, nil, "°"),
                yaw_add_left = gear:slider("Left Offset", -180, 180, 0, nil, "°"),
                yaw_add_right = gear:slider("Right Offset", -180, 180, 0, nil, "°"),
            }
        end),
        yaw_mod = tabs.aa.settings:combo("Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way", "X-Way"}, 0, function(gear)
            return {
                modifier_degree = gear:slider("Offset", -180, 180, 0),
                ways = gear:combo("Ways", "3-Way", "5-Way"),
                first_degree = gear:slider("1st Degree", -180, 180, 0),
                second_degree = gear:slider("2nd Degree", -180, 180, 0),
                third_degree = gear:slider("3rd Degree", -180, 180, 0),
                fourth_degree = gear:slider("4th Degree", -180, 180, 0),
                fifth_degree = gear:slider("5th Degree", -180, 180, 0),
            }
        end),
        body_yaw = tabs.aa.settings:switch("Body Yaw", false, 0, function(gear)
            return {
                inverter = gear:switch("Inverter", false),
                left_limit = gear:slider("Left limit", 0, 60, 58, ""),
                right_limit = gear:slider("Right limit", 0, 60, 58, ""),
                fake_options = gear:selectable("Options", {"Avoid Overlap", "Jitter", "Randomize jitter"}, 0, ""),
            }
        end),

    }
    anti_aims_menu.aa.max_phase[i] = {
        enabled = tabs.aa.settings:switch("Override " .. lua.conditions[i]),
        max = tabs.aa.settings:slider("Max phase", 2, 10, 2),
    }
    for k = 1, 10 do
        if(anti_aims_menu.aa.ab_afterlife[i] == nil) then
            anti_aims_menu.aa.ab_afterlife[i] = {}
        end
        if k == 1 then
            z = "1st"
        elseif k == 2 then
            z = "2nd"
        elseif k == 3 then
            z = "3rd"
        else
            z = k.. "th"
        end
        anti_aims_menu.aa.ab_afterlife[i][k] = tabs.aa.settings:slider(z.. " phase", -180, 180, 0)
    end
end

local cond_to_num = {
    ["Global"] = 1,
    ["Standing"] = 2,
    ["Moving"] = 3,
    ["Slow-walking"] =  4,
    ["Jumping"] = 5,
    ["Jump-crouching"] = 6,
    ["Crouching"] = 7,
    ["Fake-Lag"] = 8,
}

for i = 1, #lua.conditions do
    local enable = anti_aims_menu.aa.enable
    local tb = {anti_aims_menu.aa.conds, 2}
    local abtb = {anti_aims_menu.aa.conds, 65} --this is bruteforce LLLL never going to implement
    local cond = {anti_aims_menu.aa.cond, lua.conditions[i]}
    local yaw_mod = anti_aims_menu.aa.afterlife[i].yaw_mod
    local yaw_base = anti_aims_menu.aa.afterlife[i].yaw_base
    local body_yaw = anti_aims_menu.aa.afterlife[i].body_yaw
    local condea = anti_aims_menu.aa.afterlife[i].enabled
    local ea = {condea, function() if(i == 1) then return true else return condea:get() end end}
    local ghettosolutionforbruteforce = {condea, function() if(i == 65) then return true else return condea:get() end end}--for bruteforce (can suck my cock) 65 is placeholder nerd unneded btrw
    anti_aims_menu.aa.afterlife[i].enabled:depend(enable, tb, cond, {anti_aims_menu.aa.cond, function() 
        return (i ~= 1)
    end})
    anti_aims_menu.aa.afterlife[i].pitch:depend(enable, tb, cond, ea)
    yaw_mod:depend(enable, tb, cond, ea)
    yaw_base:depend(enable, tb, cond, ea)
    body_yaw:depend(enable, tb, cond, ea)
    yaw_mod.modifier_degree:depend(enable, tb, cond, {yaw_mod, function()
        if(yaw_mod:get() == "Disabled") then
            return false
        else
            if(yaw_mod:get() == "X-Way") then 
                return false
            else
                return true
            end
        end
    end}, ea)
    yaw_base.yaw_add_left:depend(enable, tb, cond, ea, {yaw_base.yaw, "180 L&R"})
    yaw_base.yaw_add_right:depend(enable, tb, cond, ea, {yaw_base.yaw, "180 L&R"})
    yaw_base.yaw_offset:depend(enable, tb, cond, ea, {yaw_base.yaw, "180"})
    yaw_mod.ways:depend(enable, tb, cond, {yaw_mod, "X-Way"}, ea)
    yaw_mod.first_degree:depend(enable, tb, cond, {yaw_mod, "X-Way"}, ea)
    yaw_mod.second_degree:depend(enable, tb, cond, {yaw_mod, "X-Way"}, ea)
    yaw_mod.third_degree:depend(enable, tb, cond, {yaw_mod, "X-Way"}, ea)
    yaw_mod.fourth_degree:depend(enable, tb, cond, {yaw_mod, "X-Way"}, {yaw_mod.ways, "5-Way"}, ea)
    yaw_mod.fifth_degree:depend(enable, tb, cond, {yaw_mod, "X-Way"}, {yaw_mod.ways, "5-Way"}, ea)
    body_yaw.inverter:depend(enable, tb, cond, ea, {body_yaw, true})
    body_yaw.fake_options:depend(enable, tb, cond, ea, {body_yaw, true})
    body_yaw.left_limit:depend(enable, tb, cond, ea, {body_yaw, true})
    body_yaw.right_limit:depend(enable, tb, cond, ea, {body_yaw, true})
    anti_aims_menu.aa.max_phase[i].enabled:depend(enable, abtb, cond, --[[ea]]ghettosolutionforbruteforce) 
    anti_aims_menu.aa.max_phase[i].max:depend(enable, abtb, cond, anti_aims_menu.aa.max_phase[i].enabled, ea)
    for k = 1, 10 do --bruteforce lmfao
        anti_aims_menu.aa.ab_afterlife[i][k]:depend(enable, abtb, cond, anti_aims_menu.aa.max_phase[i].enabled, {anti_aims_menu.aa.max_phase[i].max, function() return anti_aims_menu.aa.max_phase[i].max:get() >= k end}, ea)
    end
end

local function locate( table, value )
    for i = 1, #table do
        if table[i] == value then
            return true
        end
    end
    return false
end

function export_cfg()
    local date_cfg = common.get_date("%m.%d.%Y %H:%M")
    local config = base64.encode(json.stringify(pui.save()))
    local authors = common.get_username()
    if(anti_aims_menu.aa.cfg_name:get() ~= "") then
        name = anti_aims_menu.aa.cfg_name:get()
    else
        name = "config by " .. authors
    end
    local cfg_to_export = {n = name, cfg = config, author = authors, date = date_cfg}
    clipboard.set(json.stringify(cfg_to_export))
end

function import_cfg()
    local imported_cfg = json.parse(clipboard.get())                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    table.insert(config_data.n, imported_cfg.n)
    table.insert(config_data.cfg, imported_cfg.cfg)
    table.insert(config_data.author, imported_cfg.author)
    table.insert(config_data.date, imported_cfg.date)
    anti_aims_menu.aa.cfg_list:update(config_data.n)
    anti_aims_menu.aa.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[anti_aims_menu.aa.cfg_list:get()] .. "\n\r" .. "Last update: " .. theme_color() .. config_data.date[anti_aims_menu.aa.cfg_list:get()])
    files.write('csgo/afterlife/configs.txt', json.stringify(config_data))
end

function load_cfg()
    if(anti_aims_menu.aa.cfg_list:get() == 1) then
        pui.load(json.parse(base64.decode("W3siYWJfYnVpbGRlciI6W1swLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjBdLFswLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjBdLFswLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjBdLFswLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjBdLFswLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjBdLFswLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjBdLFswLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjBdLFswLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjAsMC4wLDAuMCwwLjBdXSwiYW5pbV9icmVha2VycyI6eyJfUyI6ZmFsc2UsImFpcmxlZyI6IkRpc2FibGVkIiwiYm9keV9sZWFuIjowLjAsImxlZ3MiOiJEaXNhYmxlZCIsInBpdGNoIjpmYWxzZX0sImFudGlfYnJ1dGVfcmVzZXQiOjYuMCwiYnVpbGRlciI6W3siYm9keV95YXciOnsiX1MiOmZhbHNlLCJmYWtlX29wdGlvbnMiOlsifiJdLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjU4LjAsInJpZ2h0X2xpbWl0Ijo1OC4wfSwiZW5hYmxlZCI6ZmFsc2UsInBpdGNoIjoiRGlzYWJsZWQiLCJ5YXdfYmFzZSI6eyJfUyI6IkRpc2FibGVkIiwieWF3IjoiMTgwIiwieWF3X2FkZF9sZWZ0IjowLjAsInlhd19hZGRfcmlnaHQiOjAuMCwieWF3X29mZnNldCI6MC4wfSwieWF3X21vZCI6eyJfUyI6IkRpc2FibGVkIiwiZmlmdGhfZGVncmVlIjowLjAsImZpcnN0X2RlZ3JlZSI6MC4wLCJmb3VydGhfZGVncmVlIjowLjAsIm1vZGlmaWVyX2RlZ3JlZSI6MC4wLCJzZWNvbmRfZGVncmVlIjowLjAsInRoaXJkX2RlZ3JlZSI6MC4wLCJ3YXlzIjoiMy1XYXkifX0seyJib2R5X3lhdyI6eyJfUyI6ZmFsc2UsImZha2Vfb3B0aW9ucyI6WyJ+Il0sImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NTguMCwicmlnaHRfbGltaXQiOjU4LjB9LCJlbmFibGVkIjpmYWxzZSwicGl0Y2giOiJEaXNhYmxlZCIsInlhd19iYXNlIjp7Il9TIjoiRGlzYWJsZWQiLCJ5YXciOiIxODAiLCJ5YXdfYWRkX2xlZnQiOjAuMCwieWF3X2FkZF9yaWdodCI6MC4wLCJ5YXdfb2Zmc2V0IjowLjB9LCJ5YXdfbW9kIjp7Il9TIjoiRGlzYWJsZWQiLCJmaWZ0aF9kZWdyZWUiOjAuMCwiZmlyc3RfZGVncmVlIjowLjAsImZvdXJ0aF9kZWdyZWUiOjAuMCwibW9kaWZpZXJfZGVncmVlIjowLjAsInNlY29uZF9kZWdyZWUiOjAuMCwidGhpcmRfZGVncmVlIjowLjAsIndheXMiOiIzLVdheSJ9fSx7ImJvZHlfeWF3Ijp7Il9TIjpmYWxzZSwiZmFrZV9vcHRpb25zIjpbIn4iXSwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJyaWdodF9saW1pdCI6NTguMH0sImVuYWJsZWQiOmZhbHNlLCJwaXRjaCI6IkRpc2FibGVkIiwieWF3X2Jhc2UiOnsiX1MiOiJEaXNhYmxlZCIsInlhdyI6IjE4MCIsInlhd19hZGRfbGVmdCI6MC4wLCJ5YXdfYWRkX3JpZ2h0IjowLjAsInlhd19vZmZzZXQiOjAuMH0sInlhd19tb2QiOnsiX1MiOiJEaXNhYmxlZCIsImZpZnRoX2RlZ3JlZSI6MC4wLCJmaXJzdF9kZWdyZWUiOjAuMCwiZm91cnRoX2RlZ3JlZSI6MC4wLCJtb2RpZmllcl9kZWdyZWUiOjAuMCwic2Vjb25kX2RlZ3JlZSI6MC4wLCJ0aGlyZF9kZWdyZWUiOjAuMCwid2F5cyI6IjMtV2F5In19LHsiYm9keV95YXciOnsiX1MiOmZhbHNlLCJmYWtlX29wdGlvbnMiOlsifiJdLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjU4LjAsInJpZ2h0X2xpbWl0Ijo1OC4wfSwiZW5hYmxlZCI6ZmFsc2UsInBpdGNoIjoiRGlzYWJsZWQiLCJ5YXdfYmFzZSI6eyJfUyI6IkRpc2FibGVkIiwieWF3IjoiMTgwIiwieWF3X2FkZF9sZWZ0IjowLjAsInlhd19hZGRfcmlnaHQiOjAuMCwieWF3X29mZnNldCI6MC4wfSwieWF3X21vZCI6eyJfUyI6IkRpc2FibGVkIiwiZmlmdGhfZGVncmVlIjowLjAsImZpcnN0X2RlZ3JlZSI6MC4wLCJmb3VydGhfZGVncmVlIjowLjAsIm1vZGlmaWVyX2RlZ3JlZSI6MC4wLCJzZWNvbmRfZGVncmVlIjowLjAsInRoaXJkX2RlZ3JlZSI6MC4wLCJ3YXlzIjoiMy1XYXkifX0seyJib2R5X3lhdyI6eyJfUyI6ZmFsc2UsImZha2Vfb3B0aW9ucyI6WyJ+Il0sImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NTguMCwicmlnaHRfbGltaXQiOjU4LjB9LCJlbmFibGVkIjpmYWxzZSwicGl0Y2giOiJEaXNhYmxlZCIsInlhd19iYXNlIjp7Il9TIjoiRGlzYWJsZWQiLCJ5YXciOiIxODAiLCJ5YXdfYWRkX2xlZnQiOjAuMCwieWF3X2FkZF9yaWdodCI6MC4wLCJ5YXdfb2Zmc2V0IjowLjB9LCJ5YXdfbW9kIjp7Il9TIjoiRGlzYWJsZWQiLCJmaWZ0aF9kZWdyZWUiOjAuMCwiZmlyc3RfZGVncmVlIjowLjAsImZvdXJ0aF9kZWdyZWUiOjAuMCwibW9kaWZpZXJfZGVncmVlIjowLjAsInNlY29uZF9kZWdyZWUiOjAuMCwidGhpcmRfZGVncmVlIjowLjAsIndheXMiOiIzLVdheSJ9fSx7ImJvZHlfeWF3Ijp7Il9TIjpmYWxzZSwiZmFrZV9vcHRpb25zIjpbIn4iXSwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJyaWdodF9saW1pdCI6NTguMH0sImVuYWJsZWQiOmZhbHNlLCJwaXRjaCI6IkRpc2FibGVkIiwieWF3X2Jhc2UiOnsiX1MiOiJEaXNhYmxlZCIsInlhdyI6IjE4MCIsInlhd19hZGRfbGVmdCI6MC4wLCJ5YXdfYWRkX3JpZ2h0IjowLjAsInlhd19vZmZzZXQiOjAuMH0sInlhd19tb2QiOnsiX1MiOiJEaXNhYmxlZCIsImZpZnRoX2RlZ3JlZSI6MC4wLCJmaXJzdF9kZWdyZWUiOjAuMCwiZm91cnRoX2RlZ3JlZSI6MC4wLCJtb2RpZmllcl9kZWdyZWUiOjAuMCwic2Vjb25kX2RlZ3JlZSI6MC4wLCJ0aGlyZF9kZWdyZWUiOjAuMCwid2F5cyI6IjMtV2F5In19LHsiYm9keV95YXciOnsiX1MiOmZhbHNlLCJmYWtlX29wdGlvbnMiOlsifiJdLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjU4LjAsInJpZ2h0X2xpbWl0Ijo1OC4wfSwiZW5hYmxlZCI6ZmFsc2UsInBpdGNoIjoiRGlzYWJsZWQiLCJ5YXdfYmFzZSI6eyJfUyI6IkRpc2FibGVkIiwieWF3IjoiMTgwIiwieWF3X2FkZF9sZWZ0IjowLjAsInlhd19hZGRfcmlnaHQiOjAuMCwieWF3X29mZnNldCI6MC4wfSwieWF3X21vZCI6eyJfUyI6IkRpc2FibGVkIiwiZmlmdGhfZGVncmVlIjowLjAsImZpcnN0X2RlZ3JlZSI6MC4wLCJmb3VydGhfZGVncmVlIjowLjAsIm1vZGlmaWVyX2RlZ3JlZSI6MC4wLCJzZWNvbmRfZGVncmVlIjowLjAsInRoaXJkX2RlZ3JlZSI6MC4wLCJ3YXlzIjoiMy1XYXkifX0seyJib2R5X3lhdyI6eyJfUyI6ZmFsc2UsImZha2Vfb3B0aW9ucyI6WyJ+Il0sImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NTguMCwicmlnaHRfbGltaXQiOjU4LjB9LCJlbmFibGVkIjpmYWxzZSwicGl0Y2giOiJEaXNhYmxlZCIsInlhd19iYXNlIjp7Il9TIjoiRGlzYWJsZWQiLCJ5YXciOiIxODAiLCJ5YXdfYWRkX2xlZnQiOjAuMCwieWF3X2FkZF9yaWdodCI6MC4wLCJ5YXdfb2Zmc2V0IjowLjB9LCJ5YXdfbW9kIjp7Il9TIjoiRGlzYWJsZWQiLCJmaWZ0aF9kZWdyZWUiOjAuMCwiZmlyc3RfZGVncmVlIjowLjAsImZvdXJ0aF9kZWdyZWUiOjAuMCwibW9kaWZpZXJfZGVncmVlIjowLjAsInNlY29uZF9kZWdyZWUiOjAuMCwidGhpcmRfZGVncmVlIjowLjAsIndheXMiOiIzLVdheSJ9fV0sImNmZ19saXN0IjoxLjAsImNmZ19uYW1lIjoiIiwiY29uZCI6Ikdsb2JhbCIsImNvbmRzIjozLjAsImRlZmVuc2l2ZSI6eyJjb25kIjpbIn4iXSwicGl0Y2giOiJEaXNhYmxlZCIsInlhd19tb2QiOiJEaXNhYmxlZCJ9LCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6eyJfUyI6ZmFsc2UsImRpc2FibGVycyI6WyJ+Il0sIm1hbnVhbCI6ZmFsc2V9LCJtYXhfcGhhc2UiOlt7ImVuYWJsZWQiOmZhbHNlLCJtYXgiOjIuMH0seyJlbmFibGVkIjpmYWxzZSwibWF4IjoyLjB9LHsiZW5hYmxlZCI6ZmFsc2UsIm1heCI6Mi4wfSx7ImVuYWJsZWQiOmZhbHNlLCJtYXgiOjIuMH0seyJlbmFibGVkIjpmYWxzZSwibWF4IjoyLjB9LHsiZW5hYmxlZCI6ZmFsc2UsIm1heCI6Mi4wfSx7ImVuYWJsZWQiOmZhbHNlLCJtYXgiOjIuMH0seyJlbmFibGVkIjpmYWxzZSwibWF4IjoyLjB9XSwic3RhdGljX2lmIjpbIn4iXSwidHdlYWtzIjp7Il9TIjpbIn4iXSwib3B0aW9ucyI6WyJ+Il19LCJ5YXdfYmFzZSI6IkRlZmF1bHQifV0=")))
    else
        pui.load(json.parse(base64.decode(config_data.cfg[anti_aims_menu.aa.cfg_list:get()])))
    end
end

function save_cfg()
    config_data.date[anti_aims_menu.aa.cfg_list:get()] = common.get_date("%m.%d.%Y %H:%M")
    config_data.cfg[anti_aims_menu.aa.cfg_list:get()] = base64.encode(json.stringify(pui.save()))
    anti_aims_menu.aa.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[anti_aims_menu.aa.cfg_list:get()] .. "\n\aDEFAULT" .. "Last update: " .. theme_color() .. config_data.date[anti_aims_menu.aa.cfg_list:get()])
    files.write('csgo/afterlife/configs.txt', json.stringify(config_data))
end

function create_cfg()
    local date_cfg = common.get_date("%m.%d.%Y %H:%M")
    local cfg = base64.encode(json.stringify(pui.save()))
    local author = common.get_username()
    local name = anti_aims_menu.aa.cfg_name:get()
    if(name ~= "" and not locate(config_data.n, name)) then
        table.insert(config_data.n, name)
        table.insert(config_data.cfg, cfg)
        table.insert(config_data.author, author)
        table.insert(config_data.date, date_cfg)
        files.write('csgo/afterlife/configs.txt', json.stringify(config_data))
    end
    anti_aims_menu.aa.cfg_list:update(config_data.n)
    anti_aims_menu.aa.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[anti_aims_menu.aa.cfg_list:get()] .. "\n\aDEFAULT" .. "Last update: " .. theme_color() .. config_data.date[anti_aims_menu.aa.cfg_list:get()])
end

function remove_cfg()
    if(anti_aims_menu.aa.cfg_list:get() ~= 1) then
        table.remove(config_data.n, anti_aims_menu.aa.cfg_list:get())
        table.remove(config_data.author, anti_aims_menu.aa.cfg_list:get())
        table.remove(config_data.cfg, anti_aims_menu.aa.cfg_list:get())
        table.remove(config_data.date, anti_aims_menu.aa.cfg_list:get())
        files.write('csgo/afterlife/configs.txt', json.stringify(config_data))
        anti_aims_menu.aa.cfg_list:update(config_data.n)
        anti_aims_menu.aa.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[anti_aims_menu.aa.cfg_list:get() - 1] .. "\n\aDEFAULT" .. "Last update: " .. theme_color() .. config_data.date[anti_aims_menu.aa.cfg_list:get() - 1])
    end
end

anti_aims_menu.aa.conds:depend({anti_aims_menu.aa.enable, true})
anti_aims_menu.aa.cond:depend(anti_aims_menu.aa.enable, {anti_aims_menu.aa.conds, function() if(--[[anti_aims_menu.aa.conds:get() == 1 or ]]anti_aims_menu.aa.conds:get() == 2) then return true else return false end end})
anti_aims_menu.aa.anti_brute_reset:depend({anti_aims_menu.aa.enable, true}, {anti_aims_menu.aa.conds, 65}) --65 obv doesnt exist its placeholder for future update which will never come 😎👌🏻
tabs.aa.misc:depend({anti_aims_menu.aa.conds, 1}, {anti_aims_menu.aa.enable, true})


anti_aims_menu.aa.defensive.cond:depend(anti_aims_menu.aa.enable, {anti_aims_menu.aa.conds, 2})
anti_aims_menu.aa.defensive.pitch:depend(anti_aims_menu.aa.enable, {anti_aims_menu.aa.conds, 2}, {anti_aims_menu.aa.defensive.cond, function() return #anti_aims_menu.aa.defensive.cond:get() > 0 end})
anti_aims_menu.aa.defensive.yaw_mod:depend(anti_aims_menu.aa.enable, {anti_aims_menu.aa.conds, 2}, {anti_aims_menu.aa.defensive.cond, function() return #anti_aims_menu.aa.defensive.cond:get() > 0 end})
anti_aims_menu.aa.tweaks.options:depend({anti_aims_menu.aa.tweaks, "Fast Ladder"})
anti_aims_menu.aa.anim_breakers.body_lean:depend(anti_aims_menu.aa.anim_breakers)
anti_aims_menu.aa.anim_breakers.legs:depend(anti_aims_menu.aa.anim_breakers)
anti_aims_menu.aa.anim_breakers.airleg:depend(anti_aims_menu.aa.anim_breakers)
anti_aims_menu.aa.anim_breakers.pitch:depend(anti_aims_menu.aa.anim_breakers)

                                                                            

local ram = {
    jitter_move = false,
    anti_bruteforce = {
        tickcounts = {},
        realtime = {},
    },
    in_bombzone = false,
    prev_simulation_time = 0,
    defensive = {},
    jit_yaw = 0,
    yaw_add = 0,
    set_lby = false,
    jitter = false,
    jit_add = 0,
    fix_tp = rage.exploit:get(),
}

local function time_to_ticks(val)
    return math.floor(0.5 + (val / globals.tickinterval))
end

local function in_crouching(player)
    local flags = player.m_fFlags

    if bit.band(flags, 4) == 4 then
        return true
    end

    return false
end

local function in_air(player)
    local flags = player.m_fFlags

    if bit.band(flags, 1) == 0 then
        return true
    end

    return false
end

function anti_brute(event)
    local player_which_shotting = entity.get(event.userid, true)
    local lp = entity.get_local_player()
    if(player_which_shotting == nil or player_which_shotting == lp or lp == nil or lp.m_iHealth <= 0 or player_which_shotting.m_iTeamNum == lp.m_iTeamNum) then return end
    local spos = player_which_shotting.m_vecOrigin
    local epos = vector(event.x, event.y, event.z)
    local lpos = vector(lp.m_vecOrigin.x, lp.m_vecOrigin.y, lp.m_vecOrigin.z + 60)
    local closray = lpos:closest_ray_point(spos, epos)
    local dist = lpos:dist(closray)
    if(dist < 75) then
        if(ram.anti_bruteforce.tickcounts[globals.tickcount] == nil) then
            table.insert(ram.anti_bruteforce.tickcounts, 1, {[globals.tickcount] = player_which_shotting})
            table.insert(ram.anti_bruteforce.realtime, 1, globals.realtime)
        end
    end
end

function sim_diff()
    local current_simulation_time = time_to_ticks(entity.get_local_player().m_flSimulationTime)
    local diff = current_simulation_time - ram.prev_simulation_time
    ram.prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

local n = 1
local ab_csa = 0

function ab_value()
    n = anti_aims_menu.aa.afterlife[cond_trig()[1]].enabled:get() and cond_trig()[1] or 1
    local shots = #ram.anti_bruteforce.tickcounts
    local max_ph = anti_aims_menu.aa.max_phase[n].max:get()
    local phase_n = shots - max_ph * (math.floor(shots / max_ph)) + 1
    local val = anti_aims_menu.aa.ab_afterlife[n][phase_n]:get()
    if(#ram.anti_bruteforce.realtime == 0 or globals.realtime - ram.anti_bruteforce.realtime[#ram.anti_bruteforce.realtime] > anti_aims_menu.aa.anti_brute_reset:get() or not anti_aims_menu.aa.max_phase[n].enabled:get()) then
        return 0
    else
        return val
    end
end

function enter_bombzone(event)
    if(entity.get(event.userid, true) == entity.get_local_player() and event.hasbomb) then
        ram.in_bombzone = true
    end
end

function exit_bombzone(event)
    if(entity.get(event.userid, true) == entity.get_local_player()) then
        ram.in_bombzone = false
    end
end

function fix_bomb_site_e(cmd)
    local camera_angles = render.camera_angles()
    local camera_position = render.camera_position()
    local direction = vector():angles(camera_angles)
    local entities = entity.get_entities()
    local dist, orig_dist = math.huge, math.huge
    local lp = entity.get_local_player()
    if(lp ~= nil) then
        for i = 1, #entities do
            if(entities[i]:get_classname() == "CPropDoorRotating" or (entities[i]:is_weapon() and entities[i]:get_weapon_owner() ~= entity.get_local_player()) and entities[i]:is_visible()) then
                if(entities[i]:get_classname() == "CPropDoorRotating") then
                    ent_pos = vector(entities[i]:get_origin().x, entities[i]:get_origin().y, entities[i]:get_origin().z + 50)
                else
                    ent_pos = entities[i]:get_origin()
                end
                local lpor = lp:get_origin()
                local ray_dist = ent_pos:dist_to_ray(camera_position, direction)
                if(ray_dist < dist) then
                    orig_dist = lpor:dist(ent_pos)
                    dist = ray_dist
                end
            end
        end
        if((ram.in_bombzone or dist > 45 or orig_dist > 105) and lp.m_iTeamNum == 2) then
            cmd.in_use = false
            return true
        else
            return false
        end
    else
        return false
    end
end

function inside_updateCSA(thisptr, edx)
    hooked_function(thisptr, edx)
    if(anti_aims_menu.aa.anim_breakers:get()) then
        local lp = entity.get_local_player()
        if not lp or not lp:is_alive() then return end
        local n = cond_trig()[1] or 1
        local animstate = lp:get_anim_state()
        local value = anti_aims_menu.aa.anim_breakers.body_lean:get() / 100
        if n == 2 or n == 8 then
            value = 0
        end
        ffi.cast('CAnimationLayer**', ffi.cast('uintptr_t', thisptr) + 0x2990)[0][12].m_flWeight = value
          
        if(anti_aims_menu.aa.anim_breakers.airleg:get() ~= "Disabled") then
            lp.m_flPoseParameter[6] = 1
        end
        if(anti_aims_menu.aa.anim_breakers.legs:get() ~= "Disabled") then
            if(anti_aims_menu.aa.anim_breakers.legs:get() == "Forward") then
                lp.m_flPoseParameter[0] = 1
            else
                lp.m_flPoseParameter[7] = 1
            end
        end
        if(anti_aims_menu.aa.anim_breakers.pitch:get() ~= false) then
            if(animstate.landing and not in_air(lp)) then
                lp.m_flPoseParameter[12] = 0.5
            end
        end
    end
end

function set_hook()
    if(anti_aims_menu.aa.anim_breakers:get()) then
        local self = entity.get_local_player()
        if not self or not self:is_alive() then return end
    
        local self_index = self:get_index()
        local self_address = get_entity_address(self_index)
    
        if not self_address or hooked_function then return end
    
        local new_point = vmt_hook.new(self_address)
        hooked_function = new_point.hook("void(__fastcall*)(void*, void*)", inside_updateCSA, 224)
    end
end

function get_velocity(player)
    if(player == nil) then return end
    local vec = player.m_vecVelocity
    local velocity = vec:length()
    return velocity
end




local lshot = {}
local hm = {}

function cond_trig()
    local n = 1
    local c = ""
    local lp = entity.get_local_player()
    if(lp ~= nil and lp.m_iHealth > 0) then
        local fake_duck = ui.find("aimbot", "anti aim", "misc", "fake duck"):get()
        local slowwalking = ui.find("aimbot", "anti aim", "misc", "slow walk"):get()
        local crouch = in_crouching(lp)
        local standing = get_velocity(lp) < 3 and not (slowwalking or in_air(lp) or crouch or fake_duck)
        local moving = get_velocity(lp) >= 3 and not (slowwalking or in_air(lp) or crouch or fake_duck)
        local air = in_air(lp) and not (slowwalking or crouch)
        local crouch_air = in_air(lp) and crouch and not (slowwalking)
        local crouch = (crouch or fake_duck) and not (slowwalking or air or crouch_air)
        local fakelag = rage.exploit:get() == 0
        local work = {standing, moving, slowwalking, air, crouch_air, crouch, fakelag}
        for i = 1, #work do
            if(work[i]) then
                n = i + 1
                c = lua.conditions_non_g[i]
            end
        end
    end
    return {n, c}
end

function fs_dis()
    if((anti_aims_menu.aa.freestand.manual:get() and anti_aims_menu.aa.yaw_base:get() ~= "Default") or anti_aims_menu.aa.freestand.disablers:get(cond_trig()[2])) then
        return true
    else
        return false
    end
end

function force_static()
    if(anti_aims_menu.aa.static_if:get("Warmup") and entity.get_game_rules().m_bWarmupPeriod) then
        return true
    elseif(anti_aims_menu.aa.static_if:get("Manual") and anti_aims_menu.aa.yaw_base:get() ~= "Default") then
        return true
    elseif(anti_aims_menu.aa.static_if:get("Fake-lag") and rage.exploit:get() == 0) then
        return true
    elseif(anti_aims_menu.aa.static_if:get("Freestand") and anti_aims_menu.aa.freestand:get() and rage.antiaim:get_target(true) ~= nil and not fs_dis()) then
        return true
    else
        return false
    end
end

function safe_knife(lw_index)
    local lp = entity.get_local_player()
    if anti_aims_menu.aa.tweaks:get("Safe Knife") then
        if in_air(lp) then
            if lw_index == 59 or lw_index == 42 then
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function calc_angle(src, dst)
    local vecdelta = vector(dst.x - src.x, dst.y - src.y, dst.z - src.z)
    local angles = vector(math.atan2(-vecdelta.z, vecdelta:length2d()) * 180.0 / math.pi, (math.atan2(vecdelta.y, vecdelta.x) * 180.0 / math.pi), 0.0)
    return angles
end

function aim_ack_no_chole(e)
    table.insert(lshot, globals.realtime)
    table.insert(hm, {vec = e.aim, t = globals.realtime, alpha = 0})
end

function get_target()

	local screen_center = render.screen_size() * 0.5

	local local_player = entity.get_local_player()
	if not local_player or not local_player:is_alive() then
		return
	end

	local camera_position = render.camera_position()

	local camera_angles = vector(0, render.camera_angles().y)

	local direction = vector():angles(camera_angles)

	local closest_distance, closest_enemy = math.huge
	for _, enemy in ipairs(entity.get_players(true, true)) do
        if(enemy == nil or enemy.m_iHealth <= 0) then goto skip end
		local head_position = enemy:get_hitbox_position(1)
        

		local ray_distance = head_position:dist_to_ray(
			camera_position, direction
		)
		
		if ray_distance < closest_distance then
			closest_distance = ray_distance
			closest_enemy = enemy
		end
        ::skip::
	end

	if not closest_enemy then
		return
	end
    return closest_enemy
end

function yaw_base_degree()
    if(anti_aims_menu.aa.yaw_base:get() == "Default") then
        refs.base:override("Local View")
        if(get_target() ~= nil and get_target().m_vecOrigin ~= nil and not (not fs_dis() and rage.antiaim:get_target(true) ~= nil and anti_aims_menu.aa.freestand:get())) then
            yaw = calc_angle(entity.get_local_player().m_vecOrigin, get_target().m_vecOrigin).y - render.camera_angles().y
        else
            yaw = 0
        end
        refs.freestanding:override(false)
    elseif(anti_aims_menu.aa.yaw_base:get() == "Backward") then
        refs.base:override("Local View")
        yaw = 0
        refs.freestanding:override(false)
    elseif(anti_aims_menu.aa.yaw_base:get() == "Left") then
        refs.base:override("Local View")
        yaw = -90
        refs.freestanding:override(false)
    elseif(anti_aims_menu.aa.yaw_base:get() == "Right") then
        refs.base:override("Local View")
        yaw = 90
        refs.freestanding:override(false)
    elseif(anti_aims_menu.aa.yaw_base:get() == "Forward") then
        refs.base:override("Local View")
        yaw = 180
        refs.freestanding:override(false)
    elseif(anti_aims_menu.aa.freestand:get() and force_static() and not fs_dis()) then
        refs.base:override("At Target")
        yaw = 0
        refs.freestanding:override(true)
    else
        refs.base:override("Local View")
        yaw = 0
        refs.freestanding:override(false)
    end
    return yaw
end

function fast_ladder(cmd)
    if(anti_aims_menu.aa.tweaks:get(1)) then
        local local_player = entity.get_local_player()
        local pitch, yaw = render.camera_angles().x, render.camera_angles().y
        if local_player.m_MoveType == 9 then
            cmd.view_angles.y = math.floor(cmd.view_angles.y+0.5)
            cmd.roll = 0
            if (anti_aims_menu.aa.tweaks.options:get("Ascending")) then
                if cmd.forwardmove > 0 then
                    if pitch < 45 then
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
            end
            if (anti_aims_menu.aa.tweaks.options:get("Descending")) then
                if cmd.forwardmove < 0 then
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
    end
end 

function anti_aim(cmd)
    if(anti_aims_menu.aa.enable:get()) then
        local lp = entity.get_local_player()
        local standing = get_velocity(lp) < 3
        local lw = lp:get_player_weapon()
        
        if(lw ~= nil) then
            lw_index = lw:get_weapon_index()
        end
        if(lw_index ~= nil and lw_index == 64) then
            refs.dtlim:override(2)
        else
            refs.dtlim:override(refs.dtlim:get())
        end
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):override("Static")
        fast_ladder(cmd)
        if(anti_aims_menu.aa.defensive.cond:get(cond_trig()[2]) and anti_aims_menu.aa.defensive.yaw_mod:get() ~= "Disabled") then
            refs.lag_options:override("Always On")
        else
            refs.lag_options:override(refs.lag_options:get())
        end
        if(globals.choked_commands == 0) then
            ram.jitter = not ram.jitter
            inverted = entity.get_local_player().m_flPoseParameter[11] * 120 - 60 > 0
        else
            if(inverted == nil) then
                inverted = false
            else
                inverted = inverted
            end
        end
        refs.body_yaw:override(false)
        n = anti_aims_menu.aa.afterlife[cond_trig()[1]].enabled:get() and cond_trig()[1] or 1
        if(sim_diff() < 13 / 100 * -1 and refs.dt:get()) then
            table.insert(ram.defensive, globals.realtime)
        end 
        if(anti_aims_menu.aa.tweaks:get("Bomb E Fix") and fix_bomb_site_e(cmd) and common.is_button_down(0x45) and lp.m_iTeamNum == 2) then
            refs.pitch:set("Disabled")
            refs.yaw_mod_degree:set(0)
            refs.yaw_mod:set("Disabled")
            refs.offset:override(180)
            refs.left_limit:set(0)
            refs.right_limit:set(0)
            refs.fake_options:set("")
            ram.jit_yaw = 0
            ram.yaw_add = 0
        elseif(safe_knife(lw_index)) then
            refs.pitch:set("Down")
            refs.yaw_mod_degree:set(0)
            refs.yaw_mod:set("Disabled")
            refs.offset:override(180)
            refs.left_limit:set(27)
            refs.right_limit:set(27)
            refs.fake_options:set("")
            ram.jit_yaw = 0
            ram.yaw_add = 0
        elseif(force_static()) then
            refs.pitch:set("Down")
            refs.yaw_mod:set("Disabled")
            refs.yaw_mod_degree:set(0)
            refs.offset:override(yaw_base_degree())
            refs.left_limit:set(60)
            refs.right_limit:set(60)
            refs.fake_options:override("")
            refs.body_yaw:override(anti_aims_menu.aa.afterlife[n].body_yaw:get())
            ram.jit_yaw = 0
            ram.yaw_add = 0
        --elseif(#ram.defensive > 0 and globals.realtime - ram.defensive[#ram.defensive] < 1 and anti_aims_menu.aa.defensive.cond:get(cond_trig()[2])) then -- NO DELAY
        elseif(#ram.defensive > 0 and globals.realtime - ram.defensive[#ram.defensive] < 1 / 64 * (100) / 10 and anti_aims_menu.aa.defensive.cond:get(cond_trig()[2])) then -- WITH DELAY
            local dtab = anti_aims_menu.aa.defensive
            if not (dtab.yaw_mod:get() == "Hidden") then
                refs.hidden:set(false)
                if(dtab.yaw_mod:get() == "Random") then
                    ram.jit_yaw = math.random(0, math.abs(358)) - math.abs(358) / 2
                end
                refs.yaw_mod:set("Disabled")
                refs.yaw_mod_degree:set(0)
            else
                refs.yaw_mod:set("Disabled")
                refs.yaw_mod_degree:set(0)
                refs.hidden:set(true)
            end
            if(dtab.pitch:get() ~= "Random") then
                refs.pitch:set(dtab.pitch:get())
            else
                pitchs = {"Disabled", "Down", "Fake Up", "Fake Down"}
                refs.pitch:set(pitchs[math.random(1, #pitchs)])
            end
        else
            local tab = anti_aims_menu.aa.afterlife[n]
            local tab2 = anti_aims_menu.aa.afterlife[n].yaw_base
            tab3 = anti_aims_menu.aa.afterlife[n].body_yaw
            if anti_aims_menu.aa.afterlife[n].yaw_base:get() == "Backward" then
                refs.yaw:set("Static")
            else
                refs.yaw:set(anti_aims_menu.aa.afterlife[n].yaw_base:get())
            end
            if(tab3.fake_options:get("Jitter")) then
                refs.body_yaw:set(false)
            else
                refs.body_yaw:set(anti_aims_menu.aa.afterlife[n].body_yaw:get())
            end
            refs.left_limit:set(tab3.left_limit:get())
            refs.right_limit:set(tab3.right_limit:get())
            refs.inverter:set(tab3.inverter:get())
            refs.hidden:set(false)
            refs.fake_options:set(tab3.fake_options:get())
            if anti_aims_menu.aa.afterlife[n].yaw_base.yaw:get() == "180 L&R" then
                ram.yaw_add = inverted and tab2.yaw_add_left:get() - ab_value() / 2 or tab2.yaw_add_right:get() + ab_value() / 2
            elseif anti_aims_menu.aa.afterlife[n].yaw_base.yaw:get() == "180" then
                ram.yaw_add = inverted and tab2.yaw_offset:get() - ab_value() / 2 or tab2.yaw_offset:get() + ab_value() / 2
            end
            refs.pitch:set(tab.pitch:get())
            if ((tab.yaw_mod:get() == "X-Way")) then
                refs.yaw_mod:set("Disabled")
                refs.yaw_mod_degree:set(0)
                if(tab.yaw_mod.ways:get() == "3-Way") then
                    if(globals.tickcount % 3 == 2) then
                        ram.jit_yaw = tab.yaw_mod.first_degree:get() - ab_value()
                    elseif(globals.tickcount % 3 == 1) then
                        ram.jit_yaw = tab.yaw_mod.second_degree:get()
                    elseif(globals.tickcount % 3 == 0) then
                        ram.jit_yaw = tab.yaw_mod.third_degree:get() + ab_value()
                    end
                elseif(tab.yaw_mod.ways:get() == "5-Way") then
                    if(globals.tickcount % 5 == 4) then
                        ram.jit_yaw = tab.yaw_mod.first_degree:get() - ab_value()
                    elseif(globals.tickcount % 5 == 3) then
                        ram.jit_yaw = tab.yaw_mod.second_degree:get() - ab_value() / 2
                    elseif(globals.tickcount % 5 == 2) then
                        ram.jit_yaw = tab.yaw_mod.third_degree:get()
                    elseif(globals.tickcount % 5 == 1) then
                        ram.jit_yaw = tab.yaw_mod.fourth_degree:get() + ab_value() / 2
                    elseif(globals.tickcount % 5 == 0) then
                        ram.jit_yaw = tab.yaw_mod.fifth_degree:get() + ab_value()
                    end
                end
            else
                if(tab.yaw_mod:get() == "Disabled") then
                    ram.jit_yaw = 0
                elseif(tab.yaw_mod:get() == "Center") then
                    ram.jit_yaw = ram.jitter and (tab.yaw_mod.modifier_degree:get() + ab_value() / 2) / -2 or (tab.yaw_mod.modifier_degree:get() + ab_value() / 2) / 2
                elseif(tab.yaw_mod:get() == "Offset") then
                    ram.jit_yaw = ram.jitter and (tab.yaw_mod.modifier_degree:get() + ab_value()) or ab_value() * -1
                elseif(tab.yaw_mod:get() == "Random") then
                    ram.jit_yaw = math.random(0, tab.yaw_mod.modifier_degree:get() + ab_value()) - (tab.yaw_mod.modifier_degree:get() + ab_value()) / 2
                elseif(tab.yaw_mod:get() == "Spin") then
                    if(tab.yaw_mod.modifier_degree:get() >= 0) then
                        mult = 1
                    else
                        mult = -1
                    end
                    if(mult == 1) then
                        if(ram.jit_yaw < math.abs(tab.yaw_mod.modifier_degree:get() + ab_value())) then
                            ram.jit_yaw = ram.jit_yaw + 3
                        else
                            ram.jit_yaw = math.abs(tab.yaw_mod.modifier_degree:get() + ab_value()) * -1 / 2
                        end
                    else
                        if(ram.jit_yaw > math.abs(tab.yaw_mod.modifier_degree:get() + ab_value()) * -1) then
                            ram.jit_yaw = ram.jit_yaw - 3
                        else
                            ram.jit_yaw = math.abs(tab.yaw_mod.modifier_degree:get() + ab_value()) / 2
                        end
                    end
                elseif(tab.yaw_mod:get() == "3-Way") then
                    if(globals.tickcount % 3 == 2) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / -2 - ab_value()
                    elseif(globals.tickcount % 3 == 1) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / 2 + ab_value() - 10
                    elseif(globals.tickcount % 3 == 0) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / 2 + ab_value()
                    end
                elseif(tab.yaw_mod:get() == "5-Way") then
                    if(globals.tickcount % 5 == 4) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / -2 - ab_value()
                    elseif(globals.tickcount % 5 == 3) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / -2.5 - ab_value() / 2
                    elseif(globals.tickcount % 5 == 2) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / 2.5
                    elseif(globals.tickcount % 5 == 1) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / 2 - 10 + ab_value() / 2
                    elseif(globals.tickcount % 5 == 0) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / 2 + ab_value()
                    end
                end
                refs.yaw_mod:set("Disabled")
                refs.yaw_mod_degree:set(0)
            end
        end
        if not (refs.dt:get() and rage.exploit:get() ~= 1) then
            if(ram.fix_tp == rage.exploit:get()) then
                if not (#lshot > 0 and globals.realtime - lshot[#lshot] <= 1 / 64 * 14) then
                    lshot = {}
                    if(rage.exploit:get() > 0) then
                        if(globals.choked_commands == 0) then
                            cmd.send_packet = false
                        end
                    elseif(standing) then
                        if(globals.choked_commands < 3) then
                            cmd.send_packet = false
                        end
                    else
                        if(globals.choked_commands < refs.fl_limit:get()) then
                            cmd.send_packet = false
                        end
                    end
                end
                if(anti_aims_menu.aa.afterlife[n].body_yaw.fake_options:get("Jitter")) then
                    if(anti_aims_menu.aa.afterlife[n].body_yaw.fake_options:get("Randomize Jitter")) then
                        if(math.random(0, 10) > 5) then 
                            side = ram.jitter and -1 or 1
                        end
                    else
                        side = ram.jitter and -1 or 1
                    end
                else
                    side = refs.inverter:get() and 1 or -1
                end
            else
                ram.fix_tp = rage.exploit:get()
                cmd.send_packet = true
            end
        end
        if(force_static()) then
            orig_desync = 0
            desync_value = 0
            multipl = 1
        elseif safe_knife(lw_index) then
            orig_desync = 0
            desync_value = 0
            multipl = 1
        else
            orig_desync = rage.antiaim:inverter() and refs.right_limit:get() or refs.left_limit:get()
            desync_value = rage.antiaim:inverter() and (refs.right_limit:get() / 2 + 30) or (refs.left_limit:get() / 2 + 30)
            multipl = rage.antiaim:inverter() and refs.right_limit:get() / 60 or refs.left_limit:get() / 60
        end
        model_add = render.camera_angles().y
        if(rage.antiaim:get_target(true) ~= nil and anti_aims_menu.aa.freestand:get() and not fs_dis()) then
            fr_val = rage.antiaim:get_target(true)
        else
            fr_val = 180 + model_add
        end
        if(anti_aims_menu.aa.tweaks:get("Bombsite E Fix") and fix_bomb_site_e(cmd) and common.is_button_down(0x45) and lp.m_iTeamNum == 2) then
            refs.offset:override(model_add)
        else
            if(standing and not (cmd.in_moveleft or cmd.in_moveright or cmd.in_forward or cmd.in_back or cmd.in_left or cmd.in_right) and not ui.find("aimbot", "anti aim", "misc", "fake duck"):get()) then
                cmd.sidemove = ram.jitter_move and 1.1 or -1.1
                ram.jitter_move = not ram.jitter_move
            end
            if(anti_aims_menu.aa.afterlife[n].body_yaw.fake_options:get("Jitter") and anti_aims_menu.aa.afterlife[n].body_yaw:get()) then
                if not (cmd.send_packet) then
                    refs.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + orig_desync * 2 * side + fr_val))
                else
                    refs.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + fr_val))
                end
            elseif(standing) then
                if not (cmd.send_packet) then
                    ram.set_lby = not ram.set_lby
                    --if(ram.set_lby) then
                        --refs.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + desync_value * 2 * side + fr_val))
                    --else
                        --refs.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add - (120 - desync_value * 2) * side + fr_val))
                    --end
                else
                    refs.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + fr_val))
                end
            else
                if not (cmd.send_packet) then
                    ram.set_lby = not ram.set_lby
                    --if(ram.set_lby) then
                        --refs.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + orig_desync * 2 * side + fr_val))
                    --else
                        --refs.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add - 5 * side + fr_val))
                    --end
                else
                    refs.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + fr_val))
                end
            end
        end
    end
end





function createmoving(cmd)
    anti_aim(cmd)
end

events.aim_ack:set(aim_ack_no_chole)
events.bullet_impact:set(anti_brute)
events.createmove_run:set(set_hook)
events.createmove:set(createmoving)

ui.sidebar(theme_color() .. "afterlife", theme_color() .. ui.get_icon("ring"))
pui.setup({menu, anti_aims_menu.aa})










-- /$$$$$$$$ /$$   /$$ /$$$$$$$         /$$$$$$  /$$$$$$$$        /$$$$$$  /$$   /$$ /$$$$$$$$ /$$$$$$        /$$$$$$  /$$$$$$ /$$      /$$  /$$$$$$ 
-- | $$_____/| $$$ | $$| $$__  $$       /$$__  $$| $$_____/       /$$__  $$| $$$ | $$|__  $$__/|_  $$_/       /$$__  $$|_  $$_/| $$$    /$$$ /$$__  $$
-- | $$      | $$$$| $$| $$  \ $$      | $$  \ $$| $$            | $$  \ $$| $$$$| $$   | $$     | $$        | $$  \ $$  | $$  | $$$$  /$$$$| $$  \__/
-- | $$$$$   | $$ $$ $$| $$  | $$      | $$  | $$| $$$$$         | $$$$$$$$| $$ $$ $$   | $$     | $$ /$$$$$$| $$$$$$$$  | $$  | $$ $$/$$ $$|  $$$$$$ 
-- | $$__/   | $$  $$$$| $$  | $$      | $$  | $$| $$__/         | $$__  $$| $$  $$$$   | $$     | $$|______/| $$__  $$  | $$  | $$  $$$| $$ \____  $$
-- | $$      | $$\  $$$| $$  | $$      | $$  | $$| $$            | $$  | $$| $$\  $$$   | $$     | $$        | $$  | $$  | $$  | $$\  $ | $$ /$$  \ $$
-- | $$$$$$$$| $$ \  $$| $$$$$$$/      |  $$$$$$/| $$            | $$  | $$| $$ \  $$   | $$    /$$$$$$      | $$  | $$ /$$$$$$| $$ \/  | $$|  $$$$$$/
-- |________/|__/  \__/|_______/        \______/ |__/            |__/  |__/|__/  \__/   |__/   |______/      |__/  |__/|______/|__/     |__/ \______/ 
                                                                                                                                                   
                                                                                                                                                   
                                                                                                                                                   


























function fastladder(cmd)
    if not menu.misc.fastladder:get() then return end

    local player = entity.get_local_player()

    if not player then
        return
    end

    if player.m_MoveType ~= 9 then
        return
    end

    for k, v in pairs({43, 44, 45, 46, 47, 48}) do
        if player:get_player_weapon():get_weapon_index() == v then
            return
        end
    end

    if cmd.sidemove == 0 then
        cmd.view_angles.y = cmd.view_angles.y + 45
    end

    if cmd.in_forward and cmd.sidemove < 0 then
        cmd.view_angles.y = cmd.view_angles.y + 90
    end

    if cmd.in_back and cmd.sidemove > 0 then
        cmd.view_angles.y = cmd.view_angles.y + 90
    end


    cmd.in_moveleft = cmd.in_back
    cmd.in_moveright = cmd.in_forward

    if cmd.view_angles.x < 0 then
        cmd.view_angles.x = -45
    end
end

function airstrafe(cmd)
    if not menu.misc.airstrafe:get() then return end

    local local_player = entity.get_local_player()
    vx, vy, vz = local_player.m_vecVelocity.x, local_player.m_vecVelocity.y, local_player.m_vecVelocity.z
    velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"):set(velocity > 2)
end

events.createmove:set(function(cmd)
    fastladder(cmd)
    airstrafe(cmd)
end)

events.render:set(visuals)
events.createmove:set(ragebot)



local function hide_menu_elements()
    menu.velocity_warning_color:visibility(menu.visuals.velocity_warning_enable:get())
    menu.logs:visibility(menu.misc.hitlogs_enable:get())
    -- menu.hitlogs_style:visibility(menu.misc.hitlogs_enable:get())
    -- menu.hitlogs_color:visibility(menu.misc.hitlogs_enable:get())
    menu.aspectratio_value:visibility(menu.misc.aspectratio:get())
    menu.custom_scope_gap:visibility(menu.visuals.custom_scope_enable:get())
    menu.custom_scope_length:visibility(menu.visuals.custom_scope_enable:get())
    menu.custom_scope_color:visibility(menu.visuals.custom_scope_enable:get())
    menu.viewmodel_fov:visibility(menu.misc.viewmodel:get())
    menu.viewmodel_x:visibility(menu.misc.viewmodel:get())
    menu.viewmodel_y:visibility(menu.misc.viewmodel:get())
    menu.viewmodel_z:visibility(menu.misc.viewmodel:get())
    menu.watermark_color:visibility(menu.visuals.watermark_enable:get())
    menu.inds500:visibility(menu.visuals.gamesense_enable:get())
    menu.dmgtext:visibility(menu.inds500:get(1) and menu.skeet_indicator_features:get(8) and menu.visuals.gamesense_enable:get())
    menu.dmgcolor:visibility(menu.inds500:get(1) and menu.skeet_indicator_features:get(8) and menu.visuals.gamesense_enable:get())
    menu.dmgtype:visibility(menu.inds500:get(1) and menu.skeet_indicator_features:get(8) and menu.visuals.gamesense_enable:get())
    menu.hctext:visibility(menu.inds500:get(1) and menu.skeet_indicator_features:get(11) and menu.visuals.gamesense_enable:get())
    menu.hccolor:visibility(menu.inds500:get(1) and menu.skeet_indicator_features:get(11) and menu.visuals.gamesense_enable:get())
    menu.hctype:visibility(menu.inds500:get(1) and menu.skeet_indicator_features:get(11) and menu.visuals.gamesense_enable:get())
    menu.skeet_indicator_features:visibility(menu.inds500:get(1) and menu.visuals.gamesense_enable:get())
    menu.hcempty:visibility(menu.inds500:get(1) and menu.skeet_indicator_features:get(11) and menu.inds500:get(1) and menu.skeet_indicator_features:get(8) and menu.visuals.gamesense_enable:get())
    menu.crosshair_options:visibility(menu.visuals.crosshair_indicator_enable:get())
    menu.elements:visibility(menu.visuals.solus_ui_enable:get())
    menu.ui_cheattext:visibility(menu.elements:get(1) or menu.elements:get(2) or menu.elements:get(3) and menu.visuals.solus_ui_enable:get())
    menu.ui_usertext:visibility(menu.elements:get(1) or menu.elements:get(2) or menu.elements:get(3) and menu.visuals.solus_ui_enable:get())
    menu.solus_theme:visibility(menu.elements:get(1) or menu.elements:get(2) or menu.elements:get(3) and menu.visuals.solus_ui_enable:get())
    menu.ui_accent_color:visibility(menu.elements:get(1) or menu.elements:get(2) or menu.elements:get(3) and menu.visuals.solus_ui_enable:get())
    menu.ind_color:visibility(menu.visuals.crosshair_indicator_enable:get() and menu.indicators_theme:get() ~= "Old")
    menu.ind_color2:visibility(menu.visuals.crosshair_indicator_enable:get() and menu.indicators_theme:get() ~= "Old")
    menu.ind_colorglow:visibility(menu.visuals.crosshair_indicator_enable:get() and menu.indicators_theme:get() ~= "Old")
    menu.indicators_theme:visibility(menu.visuals.crosshair_indicator_enable:get())
end


events.render:set(hide_menu_elements)