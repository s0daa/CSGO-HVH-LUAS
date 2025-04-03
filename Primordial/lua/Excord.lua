local build = "Beta"
local pixel = render.create_font("Smallest Pixel-7", 10, 20, e_font_flags.OUTLINE)
--| Service object
ffi.cdef[[
    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_t;

    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

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
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
    typedef int(__fastcall* clantag_t)(const char*, const char*);

    void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);

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
    void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);

    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
]]
-- #region ffi
local ffi = require("ffi")

-- #endregion

local verdana = render.create_font("Verdana", 12, 22)

local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local min_damage_h = menu.find("aimbot", "heavy pistols", "target overrides", "force min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local amount_heavy = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
local amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))
local keybindings = {
    ["Double tap"] = menu.find("aimbot","general","exploits","doubletap","enable"),
    ["On shot anti-aim"] = menu.find("aimbot","general","exploits","hideshots","enable"),
    ["Quick peek assist"] = menu.find("aimbot","general","misc","autopeek"),
    ["Duck peek assist"] = menu.find("antiaim","main","general","fake duck"),
    ["Anti-Aim invert"] = menu.find("antiaim","main","manual","invert desync"),
    ["Slow motion"] = menu.find("misc","main","movement","slow walk"),
   --[[ ["Manual anti-aim left"] = antiaim.get_manual_override() == 1,
    ["Manual anti-aim back"] = antiaim.get_manual_override() == 2,
    ["Manual anti-aim right"] = antiaim.get_manual_override() == 3,]]
    ["Ping spike"] = menu.find("aimbot","general", "fake ping","enable"),
    ["Freestanding"] = menu.find("antiaim","main","auto direction","enable"),
    ["edge jump"] = menu.find("misc","main","movement","edge jump"),
    ["sneak"] = menu.find("misc","main","movement","sneak"),
    ["edge bug"] = menu.find("misc","main","movement","edge bug helper"),
    ["jump bug"] = menu.find("misc","main","movement","jump bug"),
    ["fire extinguisher"] = menu.find("misc","utility","general","fire extinguisher"),
    ["Damage override"] = menu.find("aimbot", "auto", "target overrides", "force min. damage"),
}

local service = {
    notifications = {},
    text_font = render.create_font("Tahoma", 13, 400, e_font_flags.DROPSHADOW),
    direction = 1
}

--| Variables
local accent_color = select(2, unpack(menu.find("misc", "main", "config", "accent color")))
local background_color_fade = color_t(41, 41, 41, 50)
local background_color = color_t(41, 41, 41, 255)
local title_color = color_t(255, 255, 255, 255)
local text_color = color_t(155, 155, 155, 255)
local idle_color = color_t(35, 35, 35, 255)
local function easeInQuad(x)
    return x * x
end
local function notifications_draw()
    local screen_size = render.get_screen_size()
    local base_position = vec2_t(screen_size.x * 0.95, screen_size.y * 0.95)
    table.foreach(service.notifications, function(index, notification)
        local time_delta = notification.duration - (notification.expires_at - global_vars.real_time())
        if time_delta >= notification.duration then
            return table.remove(service.notifications, index)
        end
    end)

    local height_offset = 0
    table.foreach(service.notifications, function(index, notification)  
        local time_delta = notification.duration - (notification.expires_at - global_vars.real_time())
        local title_size = render.get_text_size(service.text_font, notification.title)
        local text_size = render.get_text_size(service.text_font, notification.text)
        local max_size = math.max(title_size.x, text_size.x)
        max_size = vec2_t(max_size + 20, title_size.y + text_size.y + 30)
        local animation_delta = 1
        if time_delta < 0.25 then
            animation_delta = easeInQuad(time_delta * 4)
        elseif time_delta > notification.duration - 0.25 then
            animation_delta = easeInQuad((notification.duration - time_delta) * 4)
        end
        max_size.x = max_size.x > 270 and 270 or max_size.x
        local size_delta = (text_size.x - max_size.x + 20)
        local text_animation = ((time_delta - 0.5) / (notification.duration - 1))
        if text_size.x < max_size.x or time_delta < 0.5 then
            text_animation = 0
        elseif time_delta > (notification.duration - 0.5) then
            text_animation = 1
        end
        local color_alpha = math.floor(255 * animation_delta)
        local time_color = accent_color:get()
        render.push_alpha_modifier(color_alpha / 255)
        local clip_position = vec2_t(base_position.x - max_size.x, base_position.y - max_size.y - height_offset)
        local position = vec2_t(base_position.x - max_size.x * animation_delta, base_position.y - max_size.y - height_offset)
        local bar_width = max_size.x * time_delta / (notification.duration - 0.25)
        local text_clip = position + vec2_t(10, 15 + title_size.y)
        if service.direction == 1 then
            bar_width = max_size.x - bar_width
        end
        render.push_clip(clip_position - vec2_t(0, 10), max_size + vec2_t(0, 10))
        if input.is_mouse_in_bounds(position, max_size) and input.is_key_pressed(e_keys.MOUSE_LEFT) then
            if time_delta < notification.duration - 0.25 then
                notification.expires_at = global_vars.real_time() + 0.25
            end
        end
        render.rect_filled(position, max_size, background_color, 5)
        render.rect_filled(position + vec2_t(0, 10), vec2_t(max_size.x, 1), idle_color)
        render.rect_filled(position + vec2_t(0, 10), vec2_t(bar_width, 1), time_color)
        render.text(service.text_font, notification.title, position + vec2_t(10, 15), title_color)
        render.push_clip(text_clip, vec2_t(250, text_size.y))
        render.text(service.text_font, notification.text, position + vec2_t(10 - size_delta * text_animation, 15 + title_size.y), text_color)
        if max_size.x == 270 then
            if text_animation > 0 then
                render.rect_fade(text_clip, vec2_t(10, text_size.y), background_color, background_color_fade, true)
            end
            if text_animation < 1 then
                render.rect_fade(text_clip + vec2_t(240, 0), vec2_t(10, text_size.y), background_color_fade, background_color, true)
            end
        end
        render.pop_clip()
        render.pop_clip()
        render.pop_alpha_modifier()
        height_offset = height_offset + max_size.y * animation_delta + 5
    end)
end



function service:add_notification(title, text, duration)
    duration = duration + 0.25
    table.insert(self.notifications, {
        title = title, text = text,
        expires_at = global_vars.real_time() + duration,
        duration = duration
    })
end
local cheatusername = (user.name == "����� ����") and "Admin" or (user.name == "" and "" or user.name)
service:add_notification("excord | Load",string.format("Welcome back %s, have a nice game", cheatusername), 4)
local primordial = {
    key_bind = unpack(menu.find("antiaim","main","manual","invert desync")),
    find_slow_walk_key = unpack(menu.find("misc","main","movement","slow walk")),
    ref_onshot_key = unpack(menu.find("aimbot", "general", "exploits", "hideshots", "enable")),
    ref_peek_key = unpack(menu.find("aimbot","general","misc","autopeek")),
    side_stand = menu.find("antiaim","main", "desync","side#stand"),
    llimit_stand = menu.find("antiaim","main", "desync","left amount#stand"),
    rlimit_stand = menu.find("antiaim","main", "desync","right amount#stand"),
    side_move = menu.find("antiaim","main", "desync","side#move"),
    llimit_move = menu.find("antiaim","main", "desync","left amount#move"),
    rlimit_move = menu.find("antiaim","main", "desync","right amount#move"),
    side_slowm = menu.find("antiaim","main", "desync","side#slow walk"),
    llimit_slowm = menu.find("antiaim","main", "desync","left amount#slow walk"),
    rlimit_slowm = menu.find("antiaim","main", "desync","right amount#slow walk"),
    frestends = menu.find("antiaim", "main", "auto direction", "enable")[2],
    fake_duck = menu.find("antiaim","main", "general","fake duck")[2],
    ping_skipe = menu.find("aimbot","general", "fake ping","enable")[2],

    manual_left =  antiaim.get_manual_override() == 1,
    manual_back =  antiaim.get_manual_override() == 2,
    manual_right =  antiaim.get_manual_override() == 3,

    hitbox_override = menu.find("aimbot", "auto", "target overrides", "force hitbox"),
    safepoint_ovride = menu.find("aimbot", "auto", "target overrides", "force safepoint"),
    isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable"), -- get doubletap
    isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") ,-- get hideshots
    isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable"), -- get autopeek
    isSW = menu.find("misc","main","movement","slow walk", "enable") ,-- get Slow Walk
    min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage"),
    min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage"),
    min_damage_h = menu.find("aimbot", "deagle", "target overrides", "force min. damage"),
    min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage"),
    min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage"),
   
    amount_auto = unpack(menu.find("aimbot", "auto", "target overrides","force min. damage")),
   
    --local amount_auto =  unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
    amount_heavy =  unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage")),
    amount_heavy =  unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage")),
    amount_scout =  unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage")),
    amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage")),
    amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage")),
    isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox"), -- get froce baim
    isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint"), -- get safe point
    isAA = menu.find("antiaim", "main", "angles", "yaw base"), -- get yaw base
    color_menuj = menu.find("misc", "main", "config", "accent color"), -- get yaw base
    slowwalk_key = menu.find("misc", "main", "movement", "slow walk")[2],
    oh_shot = menu.find("antiaim","main", "desync","on shot"),

}
local variables = {
    keybind = {
        x = menu.add_slider("excord | hidden", "kb_x", 0, 3840),
        y = menu.add_slider("excord | hidden", "kb_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        modes = {"[toggled]", "[hold]", "[on]", "[on]","[off]"},
        alpha = 0,
        size = 160,
    },
    spectator = {
        x = menu.add_slider("excord | hidden", "spec_x", 0, 3840),
        y = menu.add_slider("excord | hidden", "spec_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        alpha = 0,
        list = {},
        size = 140,
    }
}
local function is_crouching(player)
    if player == nil then return end
    local flags = player:get_prop("m_fFlags")
    if bit.band(flags, 4) == 4 then
        return true
    end
    return false
end

local function in_air(player)
    if player == nil then return end
    local flags = player:get_prop("m_fFlags")
    if bit.band(flags, 1) == 0 then
        return true
    end
    return false
end
local function get_state()
    if not entity_list.get_local_player():has_player_flag(e_player_flags.ON_GROUND) and not primordial.slowwalk_key:get() and (entity_list.get_local_player():get_prop("m_vecVelocity").x ~= 0 and entity_list.get_local_player():get_prop("m_vecVelocity").y ~= 0) then
        return 1
    elseif entity_list.get_local_player():get_prop("m_vecVelocity").x == 0 and entity_list.get_local_player():get_prop("m_vecVelocity").y == 0 then
        return 2
    elseif primordial.slowwalk_key:get() then
        return 3
    end
end
local list_names =
{
    'Dallas',
    'Battle Mask',
    'Evil Clown',
    'Anaglyph',
    'Boar',
    'Bunny',
    'Bunny Gold',
    'Chains',
    'Chicken',
    'Devil Plastic',
    'Hoxton',
    'Pumpkin',
    'Samurai',
    'Sheep Bloody',
    'Sheep Gold',
    'Sheep Model',
    'Skull',
    'Template',
    'Wolf',
    'Doll',
}

local lua_menu = {
    --main
    welcome = menu.add_text("excord | DATA", "Welcome To excord.lua"),
    user = menu.add_text("excord | Information", string.format("Username: %s", cheatusername)),
    buildstate = menu.add_text("excord | Information", string.format("Build State: %s", build)),
    selection_item = menu.add_selection("excord | Information", "Currnet Tab:", {"Anti-aims", "Visuals", "Misc"}),

    --antiaims
    selection_presets = menu.add_selection("excord | Anti-aims", "Anti-aim preset:", {"Jitter Slow", "Default", "Jitter Fast", "Custom"}),
    selection_condition = menu.add_selection("excord | Anti-aims", "Player state:", {"Global","Standing", "Moving", "Slowwalk", "Crouch", "air"}),
    yaw_base = menu.add_selection("excord | Anti-aims", "Yaw Base", {"Center", "At target crosshair", "At target distance"}),
    Disabler_jite = menu.add_checkbox("excord | Anti-aims", "Multiple Freestanding", false),

    Enable_global = menu.add_checkbox("excord | Anti-aims Global", "Enable", false),
    Gl_yaw_add = menu.add_slider("excord | Anti-aims Global", "Yaw add left", -50, 50),
    Gr_yaw_add = menu.add_slider("excord | Anti-aims Global", "Yaw add right", -50, 50),
    Gjitter_offset = menu.add_slider("excord | Anti-aims Global", "jitter offset", -90, 90),
    GOn_shot = menu.add_selection("excord | Anti-aims Global", "On-shot:", {"Off", "Opposite", "Same Side", "Random"}),
    Gfake_limit_left = menu.add_slider("excord | Anti-aims Global", "Fake limit Left", 1, 60),
    Gfake_limit_right = menu.add_slider("excord | Anti-aims Global", "Fake limit right", 1, 60),

    Sl_yaw_add = menu.add_slider("excord | Anti-aims Standing", "Yaw add left", -50, 50),
    Sr_yaw_add = menu.add_slider("excord | Anti-aims Standing", "Yaw add right", -50, 50),
    Saw_base = menu.add_selection("excord | Anti-aims Standing", "Yaw Jitter", {"Center", "At target crosshair", "At target distance"}),
    Sjitter_offset = menu.add_slider("excord | Anti-aims Standing", "jitter offset", -90, 90),
    SOn_shot = menu.add_selection("excord | Anti-aims Standing", "On-shot:", {"Off", "Opposite", "Same Side", "Random"}),
    Sfake_limit_left = menu.add_slider("excord | Anti-aims Standing", "Fake limit Left", 1, 60),
    Sfake_limit_right = menu.add_slider("excord | Anti-aims Standing", "Fake limit right", 1, 60),
   
    Ml_yaw_add = menu.add_slider("excord | Anti-aims Moving", "Yaw add left", -50, 50),
    Mr_yaw_add = menu.add_slider("excord | Anti-aims Moving", "Yaw add right", -50, 50),

    Mjitter_offset = menu.add_slider("excord | Anti-aims Moving", "jitter offset", -90, 90),
    MOn_shot = menu.add_selection("excord | Anti-aims Moving", "On-shot:", {"Off", "Opposite", "Same Side", "Random"}),
    Mfake_limit_left = menu.add_slider("excord | Anti-aims Moving", "Fake limit Left", 1, 60),
    Mfake_limit_right = menu.add_slider("excord| Anti-aims Moving", "Fake limit right", 1, 60),
   
    SLl_yaw_add = menu.add_slider("excord | Anti-aims Slowwalk", "Yaw add left", -50, 50),
    SLr_yaw_add = menu.add_slider("excord | Anti-aims Slowwalk", "Yaw add right", -50, 50),

    SLjitter_offset = menu.add_slider("excord | Anti-aims Slowwalk", "jitter offset", -90, 90),
    SLOn_shot = menu.add_selection("excord | Anti-aims Slowwalk", "On-shot:", {"Off", "Opposite", "Same Side", "Random"}),
    SLfake_limit_left = menu.add_slider("excord | Anti-aims Slowwalk", "Fake limit Left", 1, 60),
    SLfake_limit_right = menu.add_slider("excord | Anti-aims Slowwalk", "Fake limit right", 1, 60),
   
    Cl_yaw_add = menu.add_slider("excord | Anti-aims Crouch", "Yaw add left", -50, 50),
    Cr_yaw_add = menu.add_slider("excord | Anti-aims Crouch", "Yaw add right", -50, 50),
 
    Cjitter_offset = menu.add_slider("excord | Anti-aims Crouch", "jitter offset", -90, 90),
    COn_shot = menu.add_selection("excord | Anti-aims Crouch", "On-shot:", {"Off", "Opposite", "Same Side", "Random"}),
    Cfake_limit_left = menu.add_slider("excord | Anti-aims Crouch", "Fake limit Left", 1, 60),
    Cfake_limit_right = menu.add_slider("excord | Anti-aims Crouch", "Fake limit right", 1, 60),
       
    Al_yaw_add = menu.add_slider("excord | Anti-aims air", "Yaw add left", -50, 50),
    Ar_yaw_add = menu.add_slider("excord | Anti-aims air", "Yaw add right", -50, 50),

    Ajitter_offset = menu.add_slider("excord | Anti-aims air", "jitter offset", -90, 90),
    AOn_shot = menu.add_selection("excord | Anti-aims air", "On-shot:", {"Off", "Opposite", "Same Side", "Random"}),
    Afake_limit_left = menu.add_slider("excord | Anti-aims air", "Fake limit Left", 1, 60),
    Afake_limit_right = menu.add_slider("excord | Anti-aims air", "Fake limit right", 1, 60),

    --visuals
    Colortxt = menu.add_text("excord | Visuals", "Main color"),
    Hitlogsss = menu.add_checkbox("excord | Visuals", "HitLogs", false),
    manual_indicator = menu.add_checkbox("excord | Visuals", "Manual Indicator", false),
    indicators = menu.add_checkbox("excord | Visuals", "Indicators", false),
    selection_indicators = menu.add_selection("excord | Visuals", "Indicators:", {"None", "Classic", "Modern", "Standard"}),

    wtm_enable = menu.add_checkbox("excord | Visuals", "Watermark"),
    keybind_enable = menu.add_checkbox("excord | Visuals", "Keybinds"),
    spectator_enable = menu.add_checkbox("excord | Visuals", "Spectators"),
    masks = menu.add_selection("excord | Mask Changer", "Select", list_names),
    custom_models = menu.add_checkbox("excord | Models", "Custom Models", false),
    custom_modes_path = menu.add_text_input("excord | Mask Changer", "Path"),
    --misc
    m_max_compensation_ticks = menu.add_slider( "excord | Misc", "max compensation ticks", 0, 12 ),
    killsay = menu.add_checkbox("excord | Misc", "TrashTalk", false),
    multi_selection = menu.add_multi_selection("excord | Misc", "animlayer mods", {"reversed legs", "Static when slow walk", "static legs in air", "Lean when running"}),
    custom_font_enable = menu.add_checkbox("excord | Misc", "Custom ESP font"),
}
font1 = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
font2 = render.create_font("Small Fonts", 8, 550, e_font_flags.DROPSHADOW)
local color_acc = lua_menu.Colortxt:add_color_picker("MainColor", color_t(64, 155, 246,255), true)
local variables = {
    keybind = {
        x = menu.add_slider("excord | hidden", "kb_x", 0, 3840),
        y = menu.add_slider("excord | hidden", "kb_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        modes = {"[toggled]", "[hold]", "[on]", "[on]","[off]"},
        alpha = 0,
        size = 160,
    },
    spectator = {
        x = menu.add_slider("excord | hidden", "spec_x", 0, 3840),
        y = menu.add_slider("excord | hidden", "spec_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        alpha = 0,
        list = {},
        size = 140,
    }
}
menu.add_button("excord | Information", "Load Default Config", function()
    --anti-aims
 
    lua_menu.selection_presets:set(3)
   
    lua_menu.Disabler_jite:set(true)
    lua_menu.yaw_base:set(2)
    --visuals
    lua_menu.spectator_enable:set(false)
    lua_menu.keybind_enable:set(true)
    lua_menu.wtm_enable:set(true)
    lua_menu.Hitlogsss:set(true)
    lua_menu.indicators:set(true)
    lua_menu.selection_indicators:set(4)
    variables.keybind.x:set(365)
    variables.keybind.y:set(367)
    variables.spectator.x:set(6)
    variables.spectator.y:set(359)
    --misc
    lua_menu.killsay:set(false)
    lua_menu.custom_font_enable:set(true)
   
    color_acc:set(color_t(169, 38, 80,255))
    service:add_notification("excord | Config", "Default Config load Succses", 4)
end)
menu.add_button("excord | Information", "Discord", function()
    --anti-aims
    Panorama.Open().SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/3KxeQZ9EXC");
end)

local function getweapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
   
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end

        weapon_name = active_weapon:get_name()


    else return end

    return weapon_name

end
local screensize = render.get_screen_size()
local fake = antiaim.get_fake_angle()
local currentTime = global_vars.cur_time
local globals = {
    crouching          = false,
    standing           = false,
    jumping            = false,
    running            = false,
    pressing_move_keys = false
}
local colors = {
    white = color_t(255, 255, 255),
    red   = color_t(255, 0, 0),
    green   = color_t(0, 255, 0),
    gray  = color_t(100, 100, 100)
}

local function Visuals_indic()
    local local_player = entity_list.get_local_player()
    if not engine.is_connected() then return end
    if not engine.is_in_game() then  return  end
    if not local_player:is_alive() then return end
    if not local_player:get_prop("m_iHealth") then return end
    local ay = 40
    local alpha = math.floor(math.abs(math.sin(global_vars.real_time() * 3)) * 255)
    local velocity = local_player:get_prop("m_vecVelocity").x
    local x = screensize.x
    local y = screensize.y
    local scoped = local_player:get_prop("m_bIsScoped");
    if scoped == 1 then
        x = screensize.x / 2  + 50
        y = screensize.y / 2
    else
        x = screensize.x / 2
        y = screensize.y / 2
    end
    local x2 = screensize.x / 2
    local y2 = screensize.y / 2
    if lua_menu.manual_indicator:get() then
        render.triangle_filled(vec2_t.new(x2 - 20, y2), 16, color_t(0, 0, 0, 255),-90)
        render.triangle_filled(vec2_t.new(x2 + 20, y2), 16, color_t(0, 0, 0, 255),90)

        if antiaim.get_manual_override() == 1 then
            render.triangle_filled(vec2_t.new(x2 - 20, y2), 16, color_t(color_acc:get().r, color_acc:get().g, color_acc:get().b, alpha),-90)
        end
       
        if antiaim.get_manual_override() == 3 then
            render.triangle_filled(vec2_t.new(x2 + 20, y2), 16, color_t(color_acc:get().r, color_acc:get().g, color_acc:get().b, alpha),90)
        end
    end
    if lua_menu.selection_indicators:get() == 3 then
        local eternal_ts = render.get_text_size(pixel, "excord")
        render.text(pixel, "excord", vec2_t(x - 10, y+ay), color_t(255, 255, 255, 255), true, true)
        render.text(pixel, "BETA", vec2_t(x+eternal_ts.x-2 - 16, y+ay),color_t(color_acc:get().r, color_acc:get().g, color_acc:get().b, alpha), false, true)
        ay = ay + 10
        local player_state = get_state()

        local text_ =""
        local clr0 = color_t(0, 0, 0, 0)
        clr0 = color_acc:get()
        local current_state  = "excord"
        local ind_offset     = 0
   
        if globals.jumping then
            current_state = "AIR"
        elseif globals.running then
            current_state = "RUNNING"
        elseif globals.standing then
            current_state = "STANDING"
        elseif globals.crouching then
            current_state = "DUCKING"
        end

        render.text(pixel, current_state, vec2_t(x, y+ay), clr0, true, true)
        ay = ay + 9
   
        local asadsa = math.min(math.floor(math.sin((exploits.get_charge()%2) * 1) * 122), 100)
        if primordial.isDT[2]:get() then
        if exploits.get_charge() >= 1 then
            render.text(pixel, "DT", vec2_t(x, y+ay), color_t(0, 255, 0, 255), true, true)
            ay = ay + 9
        end
        if exploits.get_charge() < 1 then
            render.text(pixel, "DT", vec2_t(x, y+ay), color_t(255, 0, 0, 255), true, true)
            ay = ay + 9
        end
        end
     
        local ax = 0
        if primordial.isHS[2]:get() then
            render.text(pixel, "OS", vec2_t(x, y+ay), color_t(250, 173, 181, 255), true, true)
            ay = ay + 10
        end
        if primordial.ping_skipe:get() then
            render.text(pixel, "PING", vec2_t(x, y+ay), color_t(255, 0, 0, 255), true, true)
            ay = ay + 10
        end
    end


    if lua_menu.selection_indicators:get() == 2 then
        local lethal         = local_player:get_prop("m_iHealth") <= 92
        local font_inds      = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font
     
        local indi_color     = color_acc:get()
        local text_size      = render.get_text_size(font_inds, "excord")
        local text_size2     = render.get_text_size(font_inds, "lethal")
        local cur_weap       = local_player:get_prop("m_hActiveWeapon")
        local current_state  = "excord"
        local ind_offset     = 0
   
     
        if globals.jumping then
            current_state = "*AIR"
        elseif globals.running then
            current_state = "RUNNING"
        elseif globals.standing then
            current_state = "STANDING"
        elseif globals.crouching then
            current_state = "DUCKING"
        end

       
        -- LETHAL --
        if lethal then
            render.text(font_inds, "lethal", vec2_t(x + 2, y + 23), indi_color, true)
        end
   
        render.text(font_inds, current_state, vec2_t(x + 1, y + 33), indi_color, true)
   
        render.text(font_inds, "Excord", vec2_t(x + 2, y + 43), indi_color, true)
   
        -- DT --
        if primordial.isDT[2]:get() then
            if exploits.get_charge() < 1 then
                render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.red, true)
                ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
            else
                render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.white, true)
                ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
            end
        else
            render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.gray, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
        end
   
        -- HS --
        if primordial.isHS[2]:get() then
            render.text(font_inds, "HS", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
        else
            render.text(font_inds, "HS", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
        end
   
        -- BA --
        if primordial.hitbox_override[2]:get() then
            render.text(font_inds, "BA", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "BA")[0] + 5
        else
            render.text(font_inds, "BA", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "BA")[0] + 5
        end
   
        -- SP --
        if primordial.safepoint_ovride[2]:get() then
            render.text(font_inds, "SP", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 5
        else
            render.text(font_inds, "SP", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 5
        end
    end
    if lua_menu.selection_indicators:get() == 4 then
        local lethal         = local_player:get_prop("m_iHealth") <= 92
        local font_inds      = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font
     
        local indi_color     = color_acc:get()
        local text_size      = render.get_text_size(font_inds, "excord")
        local text_size2     = render.get_text_size(font_inds, "lethal")
        local cur_weap       = local_player:get_prop("m_hActiveWeapon")
        local current_state  = "excord"
        local ind_offset     = 0
        local ay = 53
     
        if globals.jumping then
            current_state = "AIR"
        elseif globals.running then
            current_state = "RUNNING"
        elseif globals.standing then
            current_state = "STANDING"
        elseif globals.crouching then
            current_state = "DUCKING"
        end

       
        -- LETHAL --
        if lethal then
            render.text(font_inds, "lethal", vec2_t(x + 2, y + 23), indi_color, true)
        end
        local eternal_ts = render.get_text_size(pixel, "excord")
        render.text(font_inds, "excord", vec2_t(x - 10, y+ 33), indi_color, true, true)
        render.text(font_inds, "BETA", vec2_t(x+eternal_ts.x-2 - 16, y+ 33),color_t(255, 255, 255, alpha), false, true)
        render.text(font_inds, current_state, vec2_t(x + 1, y + 43), indi_color, true)
        -- DT --
        if primordial.isDT[2]:get() then
            if exploits.get_charge() < 1 then
                render.text(font_inds, "DT", vec2_t(x , y+ay), colors.red, true)
                --ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
                ay = ay + 9
            else
                render.text(font_inds, "DT", vec2_t(x , y+ay), colors.green, true)
                --ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
                ay = ay + 9
            end
        end
   
        -- BA --
        if primordial.hitbox_override[2]:get() then
            render.text(font_inds, "BAIM", vec2_t(x - 13 + ind_offset, y+ay), colors.white, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "BAIM")[0]  - 2
        else
            render.text(font_inds, "BAIM", vec2_t(x - 13 + ind_offset, y+ay), colors.gray, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "BAIM")[0] - 2
        end
        -- HS --
        if primordial.isHS[2]:get() then
            render.text(font_inds, "OS", vec2_t(x - 13 + ind_offset, y+ay), colors.white, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 2
        else
            render.text(font_inds, "OS", vec2_t(x - 13 + ind_offset, y+ay), colors.gray, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 2
        end
   
       
   
        -- SP --
        if primordial.safepoint_ovride[2]:get() then
            render.text(font_inds, "SP", vec2_t(x - 13 + ind_offset, y+ay), colors.white, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 2
        else
            render.text(font_inds, "SP", vec2_t(x - 13 + ind_offset, y+ay), colors.gray, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 2
        end
    end
end

local function watermark()
    if not lua_menu.wtm_enable:get() then return end
    local screensize = render.get_screen_size()
    local h, m, s = client.get_local_time()
    local color =  color_acc:get()
    local text1 = string.format("excord [%s]", build)
    local wtm_size1 = render.get_text_size(verdana, text1)
    local text2 = string.format(" / %s ",cheatusername)
    local wtm_size2 = render.get_text_size(verdana, text2)
    local text3 = string.format("%s ms ",  math.floor(engine.get_latency(e_latency_flows.INCOMING)))
    local wtm_size3 = render.get_text_size(verdana, text3)
    local text4 = string.format("%02d:%02d ",  h, m)
    local wtm_size4 = render.get_text_size(verdana, text4)
    local text5 = "time"
    local wtm_string = string.format("excord [%s] / %s %dms %02d:%02d time", build, cheatusername, math.floor(engine.get_latency(e_latency_flows.INCOMING)), h, m, s)
    local wtm_size = render.get_text_size(verdana, wtm_string)
    local wtm_allsize = screensize.x-wtm_size.x

    render.rect_filled(vec2_t(screensize.x-wtm_size.x-18, 8), vec2_t(wtm_size.x+14, 24), color_t(41,41,41,255), 3)
    render.rect_filled(vec2_t(screensize.x-wtm_size.x-16, 10), vec2_t(wtm_size.x+10, 20), color_t(0,0,0,255), 3)
    render.rect(vec2_t(screensize.x-wtm_size.x-19, 7), vec2_t(wtm_size.x+15, 25), color_t(0,0,0,255), 3)

    render.text(verdana, text1, vec2_t(screensize.x-wtm_size.x-12, 13), color)
    render.text(verdana, text2, vec2_t(screensize.x-wtm_size.x+wtm_size1.x-12, 13), color_t(97,97,97,255))
    render.text(verdana, text3, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x-12, 13), color)
    render.text(verdana, text4, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x-12, 13), color)
    render.text(verdana, text5, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x+wtm_size4.x-12, 13), color_t(97,97,97,255))
end

local function keybinds()
    if not lua_menu.keybind_enable:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.keybind.show or menu.is_open() then
        variables.keybind.alpha = variables.keybind.alpha > 254 and 255 or variables.keybind.alpha + 15
    else
        variables.keybind.alpha = variables.keybind.alpha < 1 and 0 or variables.keybind.alpha - 15
    end
   
    render.push_alpha_modifier(variables.keybind.alpha/255)

    render.rect_filled(vec2_t(variables.keybind.x:get()- 2, variables.keybind.y:get()+8), vec2_t(variables.keybind.size+4, 24), color_t(41,41,41,255), 3)
    render.rect_filled(vec2_t(variables.keybind.x:get(), variables.keybind.y:get()+10), vec2_t(variables.keybind.size, 20), color_t(0,0,0,255), 3)
    render.rect(vec2_t(variables.keybind.x:get() - 3, variables.keybind.y:get()+7), vec2_t(variables.keybind.size+5, 25), color_t(0,0,0,255), 3)

    render.text(verdana, "keybinds", vec2_t(variables.keybind.x:get()+variables.keybind.size/2, variables.keybind.y:get()+20), color_acc:get(), true)
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables.keybind.x:get()-20,variables.keybind.y:get()-20),vec2_t(variables.keybind.x:get()+160,variables.keybind.y:get()+48)) then
        if not hasoffset then
            variables.keybind.offsetx = variables.keybind.x:get()-mousepos.x
            variables.keybind.offsety = variables.keybind.y:get()-mousepos.y
            hasoffset = true
        end
        variables.keybind.x:set(mousepos.x + variables.keybind.offsetx)
        variables.keybind.y:set(mousepos.y + variables.keybind.offsety)
    else
        hasoffset = false
    end
   
    offset = 1

    for i, v in pairs(keybindings) do
        local dap = v[2]
        if dap:get() then
            render.text(verdana, i, vec2_t(variables.keybind.x:get()+2, variables.keybind.y:get()+22+(13*offset)), color_t(255,255,255,255))
            local itssize = render.get_text_size(verdana, variables.keybind.modes[dap:get_mode()+1])
            render.text(verdana, variables.keybind.modes[dap:get_mode()+1], vec2_t(variables.keybind.x:get()+variables.keybind.size-2-itssize.x, variables.keybind.y:get()+22+(13*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
    end

    variables.keybind.show = offset > 1
end

local function spectators()
    if not lua_menu.spectator_enable:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.spectator.show or menu.is_open() then
        variables.spectator.alpha = variables.spectator.alpha > 254 and 255 or variables.spectator.alpha + 15
    else
        variables.spectator.alpha = variables.spectator.alpha < 1 and 0 or variables.spectator.alpha - 15
    end
    render.push_alpha_modifier(variables.spectator.alpha/255)
    render.rect_filled(vec2_t(variables.spectator.x:get()- 2, variables.spectator.y:get()+8), vec2_t(variables.spectator.size+4, 24), color_t(41,41,41,255), 3)
    render.rect_filled(vec2_t(variables.spectator.x:get(), variables.spectator.y:get()+10), vec2_t(variables.spectator.size, 20), color_t(0,0,0,255), 3)
    render.rect(vec2_t(variables.spectator.x:get() - 3, variables.spectator.y:get()+7), vec2_t(variables.spectator.size+5, 25), color_t(0,0,0,255), 3)

    render.text(verdana, "spectators", vec2_t(variables.spectator.x:get()+variables.spectator.size/2, variables.spectator.y:get()+20), color_acc:get(), true)

    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables.spectator.x:get()-20,variables.spectator.y:get()-20),vec2_t(variables.spectator.x:get()+160,variables.spectator.y:get()+48)) then
        if not hasoffsetspec then
            variables.spectator.offsetx = variables.spectator.x:get()-mousepos.x
            variables.spectator.offsety = variables.spectator.y:get()-mousepos.y
            hasoffsetspec = true
        end
        variables.spectator.x:set(mousepos.x + variables.spectator.offsetx)
        variables.spectator.y:set(mousepos.y + variables.spectator.offsety)
    else
        hasoffsetspec = false
    end
    offset = 1

    curspec = 1

    local local_player = entity_list.get_local_player_or_spectating()

    local players = entity_list.get_players()

    if not players then return end

    for i,v in pairs(players) do
        if not v then return end
        if v:is_alive() or v:is_dormant() then goto skip end
        local playername = v:get_name()
        if playername == "<blank>" then goto skip end
        local observing = entity_list.get_entity(v:get_prop("m_hObserverTarget"))
        if not observing then goto skip end
        if observing:get_index() == local_player:get_index() then
            local size = render.get_text_size(verdana, playername)
            variables.spectator.size = size.x/2
            render.text(verdana, playername, vec2_t(variables.spectator.x:get()+2, variables.spectator.y:get()+22+(12*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
        ::skip::
    end

    if variables.spectator.size < 140 then variables.spectator.size = 140 end

    for i = 1, #variables.spectator.list do
        render.text(verdana, variables.spectator.list[i], vec2_t(variables.spectator.x:get()+2, variables.spectator.y:get()+22+(12*offset)), color_t(255,255,255,255))
        offset = offset + 1
    end

    variables.spectator.show = offset > 1
end


local backup_cache = {
    side_stand = primordial.side_stand:get(),
    side_move = primordial.side_move:get(),
    side_slowm =  primordial.side_slowm:get(),

    llimit_stand = primordial.llimit_stand:get(),
    rlimit_stand =  primordial.rlimit_stand:get(),

    llimit_move =  primordial.llimit_move:get(),
    rlimit_move =  primordial.rlimit_move:get(),

    llimit_slowm =  primordial.llimit_slowm:get(),
    rlimit_slowm =  primordial.rlimit_slowm:get()
}


local vars = {
    yaw_base = 0,
    _jitter = 0,
    _yaw_add = 0,
    _limit_left = 0,
    _limit_right = 0,
    val_n = 0,
    desync_val = 0,
    yaw_offset = 0,
    temp_vars = 0,
    revs = 1,
    last_time = 0
}
local handle_yaw = 0

local function on_shutdown()
    primordial.side_stand:set(backup_cache.side_stand)
    primordial.side_move:set(backup_cache.side_move)
    primordial.side_slowm:set(backup_cache.side_slowm)

    primordial.llimit_stand:set(backup_cache.llimit_stand)
    primordial.rlimit_stand:set(backup_cache.rlimit_stand)

    primordial.llimit_move:set(backup_cache.llimit_move)
    primordial.rlimit_move:set(backup_cache.rlimit_move)

    primordial.llimit_slowm:set(backup_cache.llimit_slowm)
    primordial.rlimit_slowm:set(backup_cache.rlimit_slowm)
end

local normalize_yaw = function(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end

    return yaw
end

local function calc_shit(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then
        return 0
    end
   
    return math.deg(math.atan2(ydelta, xdelta))
end

local function calc_angle(src, dst)
    local vecdelta = vec3_t(dst.x - src.x, dst.y - src.y, dst.z - src.z)
    local angles = angle_t(math.atan2(-vecdelta.z, math.sqrt(vecdelta.x^2 + vecdelta.y^2)) * 180.0 / math.pi, (math.atan2(vecdelta.y, vecdelta.x) * 180.0 / math.pi), 0.0)
    return angles
end

local function calc_distance(src, dst)
    return math.sqrt(math.pow(src.x - dst.x, 2) + math.pow(src.y - dst.y, 2) + math.pow(src.z - dst.z, 2) )
end

local function get_distance_closest_enemy()
    local enemies_only = entity_list.get_players(true)
    if enemies_only == nil then return end
    local local_player = entity_list.get_local_player()
    local local_origin = local_player:get_render_origin()
    local bestenemy = nil
    local dis = 10000
    for _, enemy in pairs(enemies_only) do
        local enemy_origin = enemy:get_render_origin()
        local cur_distance = calc_distance(enemy_origin, local_origin)
        if cur_distance < dis then
            dis = cur_distance
            bestenemy = enemy
        end
    end
    return bestenemy
end

local function get_crosshair_closet_enemy()
    local enemies_only = entity_list.get_players(true)
    if enemies_only == nil then return end
    local local_player = entity_list.get_local_player()
    local local_eyepos = local_player:get_eye_position()
    local local_angles = engine.get_view_angles()
    local bestenemy = nil
    local fov = 180
    for _, enemy in pairs(enemies_only) do
        local enemy_origin = enemy:get_render_origin()
        local cur_fov = math.abs(normalize_yaw(calc_shit(local_eyepos.x - enemy_origin.x, local_eyepos.y - enemy_origin.y) - local_angles.y + 180))
        if cur_fov < fov then
            fov = cur_fov
            bestenemy = enemy
        end
    end

    return bestenemy
end
local logs = {}
local fonts = nil

local function logs222()
    if(fonts == nil) then
        fonts =
        {
            regular = render.create_font("Smallest Pixel-7", 11, 20, e_font_flags.OUTLINE);
            bold = render.create_font("Smallest Pixel-7", 11, 20, e_font_flags.OUTLINE);
        }
    end
    if (engine.is_connected() ~= true) then
        return
    end
    local time = global_vars.frame_time()
    local screenSize = render.get_screen_size()
    local screenWidth = screenSize.x
    local screenHeight = screenSize.y
    if lua_menu.Hitlogsss:get() then
        for i = 1, #logs do
            local log = logs[i]
            if log == nil then goto continue
            end
            local x = screenWidth / 2
            local y = screenHeight / 1.25 + (i * 15)
            local alpha = 0
            if (log.state == 'appearing') then
                local progress = log.currentTime / log.lifeTime.fadeIn
                x = x - Lerp(log.offset, 0, Ease(progress))
                alpha = Lerp(0, 255, Ease(progress))
                log.currentTime = log.currentTime + time
                if (log.currentTime >= log.lifeTime.fadeIn) then
                    log.state = 'visible'
                    log.currentTime = 0
                end
            elseif(log.state == 'visible') then
            alpha = 255
            log.currentTime = log.currentTime + time
            if (log.currentTime >= log.lifeTime.visible) then
                log.state = 'disappearing'
                log.currentTime = 0
            end
            elseif(log.state == 'disappearing') then
                local progress = log.currentTime / log.lifeTime.fadeOut
                x = x + Lerp(0, log.offset, Ease(progress))
                alpha = Lerp(255, 0, Ease(progress))
   
                log.currentTime = log.currentTime + time
                if(log.currentTime >= log.lifeTime.fadeOut) then
                    table.remove(logs, i)
                    goto continue
                end
            end
            log.totalTime = log.totalTime + time
            alpha = math.floor(alpha)
            local white = color_t(255, 255, 255, alpha)
            local detail = color_acc:get()
            detail.a = alpha
            local message = {}
            local combined = {}
            for a = 1, #log.header do
                local t = log.header[a]
                table.insert(combined, t)
            end
            for a = 1, #log.body do
                local t = log.body[a]
                table.insert(combined, t)
            end
            for j = 1, #combined do
                local data = combined[j]
   
                local text = tostring(data[1])
                local color = data[2]
                table.insert(message,{text, color and detail or white})
            end
            render.string(x, y, message, 'c', fonts.bold)
            ::continue::
        end
    end

end
local hitgroupMap = {
    [0] = 'generic',
    [1] = 'head',
    [2] = 'chest',
    [3] = 'stomach',
    [4] = 'left arm',
    [5] = 'right arm',
    [6] = 'left leg',
    [7] = 'right leg',
    [8] = 'neck',
    [9] = 'gear'
}
function on_aimbot_hit(hit)
    local name = hit.player:get_name()
    local hitbox = hitgroupMap[hit.hitgroup]
    local damage = hit.damage
    local health = hit.player:get_prop('m_iHealth')

    AddLog('PlayerHitEvent', {
        {'Hurt ', false};
        {name .. ' ', true};
        {'in ', false};
        {hitbox .. ' ', true};
        {'for ', false};
        {damage .. ' ', true};
        {'damage (remaining: ', false};
        {health, true};
        {')', false};
       -- client.log_screen(string.format("Hurt %s in %s for %d damage(remainig: %d)", name,hitbox,damage,health))
    })
end
function AddLog(type, body)
    local log = {
        type = type,
        state = 'appearing',
        offset = 250,
        currentTime = 0,
        totalTime = 0,
        lifeTime = {
            fadeIn = 0.75,
            visible = 3,
            fadeOut = 0.75
        },
        header = {
          --  {'[', false},
         --   {'excord', true},
         --   {'] ', false},
        },
        body = body
    }
    table.insert(logs, log)
end

function Lerp(from, to, progress)
    return from + (to - from) * progress
end

function Ease(progress)
    return progress < 0.5 and 15 * progress * progress * progress * progress * progress or 1 - math.pow(-2 * progress + 2, 5) / 2
end

render.string = function(x, y, data, alignment, font)
    local length = 0
    for i = 1, #data do
        local text = data[i][1]      
        local size = render.get_text_size(font, text)
        length = length + size.x
    end
    local offset = x
    for i = 1, #data do
        local text = data[i][1]
        local color = data[i][2]

        local sX = offset
        local sY = y
        if(alignment) == 'l' then
            sX = offset - length
        elseif(alignment) == 'c' then
            sX = offset - (length / 2)
        elseif(alignment) == 'r' then
            sX = offset
        end
        render.text(font, text, vec2_t(sX + 1, sY + 1), color_t(16, 16, 16, color.a))
        render.text(font, text, vec2_t(sX, sY), color)
        local size = render.get_text_size(font, text)
        offset = offset + size.x
    end
end
local function __thiscall(func, this) -- bind wrapper for __thiscall functions
    return function(...)
        return func(this, ...)
    end
end

local interface_ptr = ffi.typeof("void***")
local vtable_bind = function(module, interface, index, typedef)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or safe_error(interface .. " is nil.")
    return __thiscall(ffi.cast(typedef, addr[0][index]), addr)
end

local vtable_entry = function(instance, i, ct)
    return ffi.cast(ct, ffi.cast(interface_ptr, instance)[0][i])
end

local vtable_thunk = function(i, ct)
    local t = ffi.typeof(ct)
    return function(instance, ...)
        return vtable_entry(instance, i, t)(instance, ...)
    end
end

local nativeCBaseEntityGetClassName = vtable_thunk(143, "const char*(__thiscall*)(void*)")
local nativeCBaseEntitySetModelIndex = vtable_thunk(75, "void(__thiscall*)(void*,int)")

local nativeClientEntityListGetClientEntityFromHandle = vtable_bind("client.dll", "VClientEntityList003", 4, "void*(__thiscall*)(void*,void*)")
local nativeModelInfoClientGetModelIndex = vtable_bind("engine.dll", "VModelInfoClient004", 2, "int(__thiscall*)(void*, const char*)")


local filepath = {
    'player/holiday/facemasks/facemask_dallas',
    'player/holiday/facemasks/facemask_battlemask',
    'player/holiday/facemasks/evil_clown',
    'player/holiday/facemasks/facemask_anaglyph',
    'player/holiday/facemasks/facemask_boar',
    'player/holiday/facemasks/facemask_bunny',
    'player/holiday/facemasks/facemask_bunny_gold',
    'player/holiday/facemasks/facemask_chains',
    'player/holiday/facemasks/facemask_chicken',
    'player/holiday/facemasks/facemask_devil_plastic',
    'player/holiday/facemasks/facemask_hoxton',
    'player/holiday/facemasks/facemask_pumpkin',
    'player/holiday/facemasks/facemask_samurai',
    'player/holiday/facemasks/facemask_sheep_bloody',
    'player/holiday/facemasks/facemask_sheep_gold',
    'player/holiday/facemasks/facemask_sheep_model',
    'player/holiday/facemasks/facemask_skull',
    'player/holiday/facemasks/facemask_template',
    'player/holiday/facemasks/facemask_wolf',
    'player/holiday/facemasks/porcelain_doll',
}

local function maskchander()
   
    local local_player = entity_list.get_local_player()

    if local_player == nil then return end

    local models = ""

    if lua_menu.custom_models:get() then
        lua_menu.custom_modes_path:set_visible(true)
        models = lua_menu.custom_modes_path:get()
    else
        lua_menu.custom_modes_path:set_visible(false)
        models = "models/" .. filepath[lua_menu.masks:get()] .. ".mdl"
    end

    local modelIndex = nativeModelInfoClientGetModelIndex(models)
    if modelIndex == -1 then
        client.precache_model(models)
    end
    modelIndex = nativeModelInfoClientGetModelIndex(models)

    local local_player = entity_list.get_local_player()

    local lpAddr = ffi.cast("intptr_t*", local_player:get_address())

    local m_AddonModelsHead = ffi.cast("intptr_t*", lpAddr + 0x462F) -- E8 ? ? ? ? A1 ? ? ? ? 8B CE 8B 40 10
    local m_AddonModelsInvalidIndex = -1

    local i, next = m_AddonModelsHead[0], -1

    while i ~= m_AddonModelsInvalidIndex do
        next = ffi.cast("intptr_t*", lpAddr + 0x462C)[0] + 0x18 * i -- this is the pModel (CAddonModel) afaik
        i = ffi.cast("intptr_t*", next + 0x14)[0]

        local m_pEnt = ffi.cast("intptr_t**", next)[0] -- CHandle<C_BaseAnimating> m_hEnt -> Get()
        local m_iAddon = ffi.cast("intptr_t*", next + 0x4)[0]

        if tonumber(m_iAddon) == 16 and modelIndex ~= -1 then -- face mask addon bits
            local entity = nativeClientEntityListGetClientEntityFromHandle(m_pEnt)
            nativeCBaseEntitySetModelIndex(entity, modelIndex)
        end
    end
end
callbacks.add(e_callbacks.AIMBOT_HIT,on_aimbot_hit)


function on_paint()
    notifications_draw()
    maskchander()
    Visuals_indic()
    logs222()
    watermark()
    keybinds()
    spectators()
   
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    local local_eyepos = local_player:get_eye_position()
    local view_angle = engine.get_view_angles()



    if lua_menu.yaw_base:get() == 1 then
        vars.yaw_base = view_angle.y
    elseif lua_menu.yaw_base:get() == 2 then
        vars.yaw_base = get_crosshair_closet_enemy() == nil and view_angle.y or calc_angle(local_eyepos, get_crosshair_closet_enemy():get_render_origin()).y
    elseif lua_menu.yaw_base:get() == 3 then
        vars.yaw_base = get_distance_closest_enemy() == nil and view_angle.y or calc_angle(local_eyepos, get_distance_closest_enemy():get_render_origin()).y
    end

end

local function animlayes(ctx)
    local lp = entity_list.get_local_player()
    local sexgod = lp:get_prop("m_vecVelocity[1]") ~= 0  
    if lua_menu.multi_selection:get(1) then
        ctx:set_render_pose(e_poses.RUN, 0)
    end

    if primordial.find_slow_walk_key:get() and lua_menu.multi_selection:get(2) then
        ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0)
    end

    if lua_menu.multi_selection:get(4) then
        if sexgod then
            ctx:set_render_animlayer(e_animlayers.LEAN, 1)
        end
    end

    if primordial.slowwalk_key:get() then
         ctx:set_render_animlayer(e_animlayers.LEAN, 0.75)
    end
    if lua_menu.multi_selection:get(3) then
        ctx:set_render_pose(e_poses.JUMP_FALL, 1)
    end
end
callbacks.add(e_callbacks.ANTIAIM, animlayes)


function on_antiaim(ctx)

    local local_player = entity_list.get_local_player()
    if not local_player then return end


    if lua_menu.Disabler_jite:get() then
        if antiaim.get_manual_override() == 1 or antiaim.get_manual_override() == 3 then
            on_shutdown()
            return
        end
    end
    if lua_menu.Disabler_jite:get() then
        if antiaim.get_manual_override() == 2 then
            on_shutdown()
            return
        end
    end
    if lua_menu.Disabler_jite:get() then
        if primordial.frestends:get() then
            vars.yaw_base = 0
            return
        end
    end



    if math.abs(global_vars.tick_count() - vars.temp_vars) > 1 then
       vars.revs = vars.revs == 1 and 0 or 1
       vars.temp_vars = global_vars.tick_count()
    end

    local is_invert = vars.revs == 1 and  primordial.key_bind:get() and false or true

    local local_player = entity_list.get_local_player()
    local velocity = local_player:get_prop("m_vecVelocity").x
    local presetsc = lua_menu.selection_presets:get()
    _l_yaw_add = 0
    _r_yaw_add = 0
    if presetsc == 3 then
        vars._jitter = 26
        vars._limit_left = math.random(26, 46)
        vars._limit_right = math.random(15, 35)
        _l_yaw_add = -6
        _r_yaw_add = 6
        primordial.oh_shot:set(2)
    elseif presetsc == 4 then
        if lua_menu.selection_condition:get() == 1 then
            if lua_menu.Enable_global:get() then
                vars._jitter = lua_menu.Gjitter_offset:get()
                vars._limit_left = lua_menu.Gfake_limit_left:get()
                vars._limit_right = lua_menu.Gfake_limit_right:get()
                _l_yaw_add = lua_menu.Gl_yaw_add:get()
                _r_yaw_add = lua_menu.Gr_yaw_add:get()
                primordial.oh_shot:set(lua_menu.GOn_shot:get())
            end
        else
            if globals.jumping then
                vars._jitter = lua_menu.Ajitter_offset:get()
                vars._limit_left = lua_menu.Afake_limit_left:get()
                vars._limit_right = lua_menu.Afake_limit_right:get()
                _l_yaw_add = lua_menu.Al_yaw_add:get()
                _r_yaw_add = lua_menu.Ar_yaw_add:get()
                primordial.oh_shot:set(lua_menu.AOn_shot:get())
            elseif globals.running then
                vars._jitter = lua_menu.Mjitter_offset:get()
                vars._limit_left = lua_menu.Mfake_limit_left:get()
                vars._limit_right = lua_menu.Mfake_limit_right:get()
                _l_yaw_add = lua_menu.Ml_yaw_add:get()
                _r_yaw_add = lua_menu.Mr_yaw_add:get()
                primordial.oh_shot:set(lua_menu.MOn_shot:get())
            elseif globals.standing then
                vars._jitter = lua_menu.Sjitter_offset:get()
                vars._limit_left = lua_menu.Sfake_limit_left:get()
                vars._limit_right = lua_menu.Sfake_limit_right:get()
                _l_yaw_add = lua_menu.Sl_yaw_add:get()
                _r_yaw_add = lua_menu.Sr_yaw_add:get()
                primordial.oh_shot:set(lua_menu.SOn_shot:get())
            elseif globals.crouching then
                vars._jitter = lua_menu.Cjitter_offset:get()
                vars._limit_left = lua_menu.Cfake_limit_left:get()
                vars._limit_right = lua_menu.Cfake_limit_right:get()
                _l_yaw_add = lua_menu.Cl_yaw_add:get()
                _r_yaw_add = lua_menu.Cr_yaw_add:get()
                primordial.oh_shot:set(lua_menu.COn_shot:get())
            elseif primordial.slowwalk_key:get() then
                vars._jitter = lua_menu.SLjitter_offset:get()
                vars._limit_left = lua_menu.SLfake_limit_left:get()
                vars._limit_right = lua_menu.SLfake_limit_right:get()
                _l_yaw_add = lua_menu.SLl_yaw_add:get()
                _r_yaw_add = lua_menu.SLr_yaw_add:get()
                primordial.oh_shot:set(lua_menu.SLOn_shot:get())
            end
   
        end
     

    end
    if math.abs(global_vars.tick_count() - vars.temp_vars) > 1 then
        vars.revs = vars.revs == 1 and 0 or 1
        vars.temp_vars = global_vars.tick_count()
     end
    vars.val_n = vars.revs == 1 and vars._jitter or -(vars._jitter)
   -- vars.desync_val = vars.val_n > 0 and -(vars._limit/120) or vars._limit/60
    vars._yaw_add = vars.val_n > 0 and _l_yaw_add or _r_yaw_add

    handle_yaw = normalize_yaw(vars.val_n + vars._yaw_add + vars.yaw_base + 180)

 
    --ctx:set_desync(vars.desync_val)
    ctx:set_yaw(handle_yaw)
   
    primordial.side_stand:set(4)
    primordial.side_move:set(4)
    primordial.side_slowm:set(4)

    primordial.llimit_stand:set(vars._limit_left)
    primordial.rlimit_stand:set(vars._limit_right)

    primordial.llimit_move:set(vars._limit_left)
    primordial.rlimit_move:set(vars._limit_right)

    primordial.llimit_slowm:set(vars._limit_left)
    primordial.rlimit_slowm:set(vars._limit_right)
   
end
local c_visibility = function()
    return lua_menu.selection_presets:get() and lua_menu.selection_presets:get() == 2 and lua_menu.selection_presets:get() == 2 and lua_menu.selection_presets:get() == 2
end

local function draw_menu()
    if not show then
      --  text_input_item:set_visible(false)
        menu.set_group_visibility("excord | Information", true)
        local menu_val = lua_menu.selection_item:get()
        local menu_conditiom = lua_menu.selection_condition:get()
        local selection_presets = lua_menu.selection_presets:get()
        antia = false
        menu.set_group_column("excord | Information", 1)
        lua_menu.Gjitter_offset:set_visible(lua_menu.Enable_global:get())
        lua_menu.Gfake_limit_left:set_visible(lua_menu.Enable_global:get())
        lua_menu.Gfake_limit_right:set_visible(lua_menu.Enable_global:get())
        lua_menu.Gl_yaw_add:set_visible(lua_menu.Enable_global:get())
        lua_menu.Gr_yaw_add:set_visible(lua_menu.Enable_global:get())
        lua_menu.GOn_shot:set_visible(lua_menu.Enable_global:get())

        lua_menu.selection_indicators:set_visible(lua_menu.indicators:get())
        if menu_val == 1 then
            antia = true
            lua_menu.selection_condition:set_visible(false)
            if selection_presets == 4 then
                lua_menu.selection_condition:set_visible(true)

                if menu_conditiom == 1 then
                    --excord | hidden
                    menu.set_group_visibility("excord | Anti-aims Global", true)
                    menu.set_group_visibility("excord | Anti-aims Standing", false)
                    menu.set_group_visibility("excord | Anti-aims Moving", false)
                    menu.set_group_visibility("excord | Anti-aims Slowwak", false)
                    menu.set_group_visibility("excord | Anti-aims Slowwalk", false)
                    menu.set_group_visibility("excord | Anti-aims Crouch", false)
                    menu.set_group_visibility("excord | Anti-aims air", false)

               
                elseif  menu_conditiom == 2 then
                    menu.set_group_visibility("excord | Anti-aims Global", false)
                    menu.set_group_visibility("excord | Anti-aims Standing", true)
                    menu.set_group_visibility("excord | Anti-aims Moving", false)
                    menu.set_group_visibility("excord | Anti-aims Slowwak", false)
                    menu.set_group_visibility("excord | Anti-aims Crouch", false)
                    menu.set_group_visibility("excord | Anti-aims air", false)

                   
                elseif  menu_conditiom == 3 then
                    menu.set_group_visibility("excord | Anti-aims Global", false)
                    menu.set_group_visibility("excord | Anti-aims Standing", false)
                    menu.set_group_visibility("excord | Anti-aims Moving", true)
                    menu.set_group_visibility("excord | Anti-aims Global", false)
                    menu.set_group_visibility("excord | Anti-aims Slowwalk", false)
                    menu.set_group_visibility("excord | Anti-aims Crouch", false)
                    menu.set_group_visibility("excord | Anti-aims air", false)

               
                elseif  menu_conditiom == 4 then
                    menu.set_group_visibility("excord | Anti-aims Global", false)
                    menu.set_group_visibility("excord | Anti-aims Standing", false)
                    menu.set_group_visibility("excord | Anti-aims Moving", false)
                    menu.set_group_visibility("excord | Anti-aims Slowwalk", true)
                    menu.set_group_visibility("excord | Anti-aims Crouch", false)
                    menu.set_group_visibility("excord | Anti-aims air", false)

                   
                elseif  menu_conditiom == 5 then
                    menu.set_group_visibility("excord | Anti-aims Global", false)
                    menu.set_group_visibility("excord | Anti-aims Standing", false)
                    menu.set_group_visibility("excord | Anti-aims Moving", false)
                    menu.set_group_visibility("excord | Anti-aims Slowwalk", false)
                    menu.set_group_visibility("excord | Anti-aims Crouch", true)
                    menu.set_group_visibility("excord | Anti-aims air", false)

                   
                elseif  menu_conditiom == 6 then
                    menu.set_group_visibility("excord | Anti-aims Global", false)
                    menu.set_group_visibility("excord | Anti-aims Standing", false)
                    menu.set_group_visibility("excord | Anti-aims Moving", false)
                    menu.set_group_visibility("excord | Anti-aims Slowwalk", false)
                    menu.set_group_visibility("excord | Anti-aims Crouch", false)
                    menu.set_group_visibility("excord | Anti-aims air", true)
             
                  end  
            else
                menu.set_group_visibility("excord | Anti-aims Global", false)
                menu.set_group_visibility("excord | Anti-aims Standing", false)
                menu.set_group_visibility("excord | Anti-aims Moving", false)
                menu.set_group_visibility("excord | Anti-aims Global", false)
                menu.set_group_visibility("excord | Anti-aims Slowwalk", false)
                menu.set_group_visibility("excord | Anti-aims Crouch", false)
                menu.set_group_visibility("excord | Anti-aims air", false)
                lua_menu.selection_condition:set_visible(false)
       
            end
            menu.set_group_visibility("excord | Mask Changer", false)
          menu.set_group_visibility("excord | Visuales", false)
          menu.set_group_visibility("excord | Adicionales", false)
          menu.set_group_visibility("excord | Anti-aims", true)
          menu.set_group_column("excord | Anti-aims", 2)
         
        elseif menu_val == 2 then
            menu.set_group_visibility("excord | Anti-aims Standing", false)
            menu.set_group_visibility("excord | Anti-aims Moving", false)
            menu.set_group_visibility("excord | Anti-aims Global", false)
            menu.set_group_visibility("excord | Anti-aims Slowwalk", false)
            menu.set_group_visibility("excord | Anti-aims Crouch", false)
            menu.set_group_visibility("excord | Anti-aims air", false)
           
   
            menu.set_group_visibility("excord | Anti-aims", false)
            menu.set_group_visibility("excord | Visuales", true)
            menu.set_group_visibility("excord | Cambiador De Mascara", true)
            menu.set_group_visibility("excord | Adicionales", false)
            menu.set_group_column("excord | Visuales", 2)
   
        elseif menu_val == 3 then
            menu.set_group_visibility("excord | Anti-aims Standing", false)
            menu.set_group_visibility("excord | Anti-aims Moving", false)
            menu.set_group_visibility("excord | Anti-aims Global", false)
            menu.set_group_visibility("excord | Anti-aims Slowwalk", false)
            menu.set_group_visibility("excord | Anti-aims Crouch", false)
            menu.set_group_visibility("excord | Mask Changer", false)
            menu.set_group_visibility("excord | Anti-aims air", false)
           
            menu.set_group_visibility("excord | Anti-aims", false)
            menu.set_group_visibility("excord | Visuales", false)
            menu.set_group_visibility("excord | Adicionales", true)
            menu.set_group_column("excord | Adicionales", 2)
        end
        menu.set_group_visibility("excord | hidden", false)
        menu.set_group_column("excord | hidden", 3)
    else
    --  checkbox:set_visible(false)
    --  text_eu:set_visible(false)
      menu.set_group_visibility("excord | hidden", false)
      menu.set_group_visibility("excord | Information", false)
      menu.set_group_visibility("excord | Anti-aims Standing", false)
      menu.set_group_visibility("excord | Anti-aims Moving", false)
      menu.set_group_visibility("excord | Anti-aims Global", false)
      menu.set_group_visibility("excord | Anti-aims Slowwalk", false)
      menu.set_group_visibility("excord | Anti-aims Crouch", false)
      menu.set_group_visibility("excord | Anti-aims air", false)
     
      menu.set_group_visibility("excord | Mask Changer", false)
      menu.set_group_visibility("excord | Visuales", false)
      menu.set_group_visibility("excord | Adicionales", false)
      menu.set_group_visibility("excord | Anti-aims", false)
  end
end

local function on_draw_watermark(watermark_text)
    draw_menu()

    return ""
end
local killsays = {
    'GORDO POBRE', 
}
local function table_lengh(data) --grabbing how many killsay quotes are in our table
    if type(data) ~= 'table' then
        return 0                                                  
    end
    local count = 0
    for _ in pairs(data) do
        count = count + 1
    end
    return count
end

local function on_event(event)
    if lua_menu.killsay:get() then
        local lp = entity_list.get_local_player() --grabbing out local player
        local kill_cmd = 'say ' .. killsays[math.random(table_lengh(killsays))] --randomly selecting a killsay
     
        engine.execute_cmd(kill_cmd) --executing the killsay command
    end
end




callbacks.add(e_callbacks.NET_UPDATE, function()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    if bit.band(local_player:get_prop("m_iAddonBits"), 0x10000) ~= 0x10000 then
        local_player:set_prop("m_iAddonBits", 0x10000 + local_player:get_prop("m_iAddonBits"))
    end
end)




  local math_const = {
    m_pi_radians = 57.295779513082
  }

  local player_records = { }


  local function push_player_record( player )
    local index = player:get_index( )
    local record = { }

    record.m_eye_position = player:get_eye_position( )
    record.m_simulation_time = player:get_prop( "m_flSimulationTime" )

    if( player_records[ index ] == nil ) then
      player_records[ index ] = { }
    end

    for i = 11, 0, -1 do
      if( player_records[ index ][ i ] ~= nil ) then
        player_records[ index ][ i + 1 ] = player_records[index ][ i ]
      end
    end

    player_records[ index ][ 0 ] = record
  end


  -- clamp values ( https://github.com/topameng/CsToLua/blob/master/tolua/Assets/Lua/Math.lua ) - straight stolen cause very lazzy :-)
  local function clamp(num, min, max)
      if num < min then
          num = min
      elseif num > max then
          num = max
      end

      return num
  end


  -- convert ticks to time
  local function ticks_to_time( ticks )
    return global_vars.interval_per_tick( ) * ticks
  end


  -- convert time to ticks
  local function time_to_ticks( time )
    return math.floor( 0.5 + time / global_vars.interval_per_tick( ) )
  end

  -- calc interpolation adjustment
  local function calc_lerp( )
    local update_rate = clamp( cvars.cl_updaterate:get_float( ), cvars.sv_minupdaterate:get_float( ), cvars.sv_maxupdaterate:get_float( ) )
    local lerp_ratio = clamp( cvars.cl_interp_ratio:get_float( ), cvars.sv_client_min_interp_ratio:get_float( ), cvars.sv_client_max_interp_ratio:get_float( ) )

    return clamp( lerp_ratio / update_rate, cvars.cl_interp:get_float( ), 1 )
  end

  -- calc if a record is valid
  local function is_record_valid( record, tick_base )
    local max_unlag = cvars.sv_maxunlag:get_float( )
    local current_time = ticks_to_time( tick_base )

    local correct = engine.get_latency( e_latency_flows.INCOMING ) + engine.get_latency( e_latency_flows.OUTGOING )
    local correct = clamp( correct, 0, max_unlag )

    return math.abs( correct - ( current_time - record.m_simulation_time ) ) <= 0.2
  end


  -- calc angle to position
  local function calc_angle( from, to )
    local result = angle_t( 0.0, 0.0, 0.0 )
    local delta = from - to
    local hyp = math.sqrt( delta.x * delta.x + delta.y * delta.y )

    result.x = math.atan( delta.z / hyp ) * math_const.m_pi_radians
    result.y = math.atan( delta.y / delta.x ) * math_const.m_pi_radians

    if( delta.x >= 0 ) then
      result.y = result.y + 180
    end

    return result
  end

  -- normalize angle
  local function normalize_angle( angle )
    local result = angle

    while result.x < -180 do
      result.x = result.x + 360
    end

    while result.x > 180 do
      result.x = result.x - 360
    end

    while result.y < -180 do
      result.y = result.y + 360
    end

    while result.y > 180 do
      result.y = result.y - 360
    end

    result.x = clamp( result.x, -89, 89 )

    return result
  end

  -- calc fov to position
  local function calc_fov( view_angle, target_angle )
    local delta = target_angle - view_angle
    local delta_normalized = normalize_angle( delta )

    return math.min( math.sqrt( math.pow( delta_normalized.x, 2 ) + math.pow( delta_normalized.y, 2 ) ), 180 )
  end

  -- loop trough all entities on net update
  -- to store new records

  local function on_net_update( )
    local enemies_only = entity_list.get_players(true)
    if( enemies_only == nil ) then
      return
    end

    for _, enemy in pairs(enemies_only) do
      if enemy:is_alive() then
        push_player_record( enemy )
      end
    end
  end

  local function on_setup_command( cmd )
    local enemies_only = entity_list.get_players(true)

    local closest_enemy = nil
    local closest_fov = 180

    local local_player = entity_list.get_local_player( )
    if( local_player == nil or local_player:is_alive( ) ~= true or cmd:has_button( e_cmd_buttons.ATTACK ) ~= true ) then
      return
    end

    local view_angle = engine.get_view_angles( )
    local eye_position = local_player:get_eye_position( )

    -- search for closest enemy to fov first (could maybe completely be swit)
    for _, enemy in pairs(enemies_only) do
      if enemy:is_alive() then
        local fov = calc_fov( view_angle, calc_angle( eye_position, enemy:get_eye_position( ) ) )

        if( fov < closest_fov ) then
          closest_enemy = enemy
          closest_fov = fov
        end
      end
    end

    if( closest_enemy ~= nil ) then
      closest_fov = 180

      local best_record = nil
      if( player_records[ closest_enemy:get_index( ) ] == nil ) then
        return
      end

      for i = 0, 12 do
        if( player_records[ closest_enemy:get_index( ) ][ i ] ~= nil ) then
          local record = player_records[ closest_enemy:get_index( ) ][ i ]
          local compensation_ticks = time_to_ticks( closest_enemy:get_prop( "m_flSimulationTime" ) - record.m_simulation_time )

          if( is_record_valid( record, local_player:get_prop( "m_nTickBase" ) ) and compensation_ticks <= lua_menu.m_max_compensation_ticks:get( ) ) then
              local fov = calc_fov( view_angle, calc_angle( eye_position, record.m_eye_position ) )

              if( fov < closest_fov ) then
                closest_fov = fov
                best_record = record
              end
          end
        end
      end

      -- we found an record, apply it to the cmd
      if( best_record ~= nil ) then
        local tick_count = cmd.tick_count

        cmd.tick_count = time_to_ticks( best_record.m_simulation_time + calc_lerp( ) )
      end
    end
  end


  -- register all callbacks
callbacks.add( e_callbacks.NET_UPDATE, on_net_update )
callbacks.add( e_callbacks.SETUP_COMMAND, on_setup_command )
callbacks.add(e_callbacks.EVENT, on_event, "player_death") -- calling the function only when a player dies
callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)
callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    local local_player = entity_list.get_local_player()
    globals.pressing_move_keys = (cmd:has_button(e_cmd_buttons.MOVELEFT) or cmd:has_button(e_cmd_buttons.MOVERIGHT) or cmd:has_button(e_cmd_buttons.FORWARD) or cmd:has_button(e_cmd_buttons.BACK))

    if (not local_player:has_player_flag(e_player_flags.ON_GROUND)) or (local_player:has_player_flag(e_player_flags.ON_GROUND) and cmd:has_button(e_cmd_buttons.JUMP)) then
        globals.jumping = true
    else
        globals.jumping = false
    end

    if globals.pressing_move_keys then
        if not globals.jumping then
            if cmd:has_button(e_cmd_buttons.DUCK) then
                globals.crouching = true
                globals.running = false
            else
                globals.running = true
                globals.crouching = false
            end
        elseif globals.jumping and not cmd:has_button(e_cmd_buttons.JUMP) then
            globals.running = false
            globals.crouching = false
        end

        globals.standing = false
    elseif not globals.pressing_move_keys then
        if not globals.jumping then
            if cmd:has_button(e_cmd_buttons.DUCK) then
                globals.crouching = true
                globals.standing = false
            else
                globals.standing = true
                globals.crouching = false
            end
        else
            globals.standing = false
            globals.crouching = false
        end
       
        globals.running = false
    end
end)

local function on_player_esp(sex)
    if lua_menu.custom_font_enable:get() then
        sex:set_font(font1)
        sex:set_small_font(font2)
    end
end
callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)

local enable_clantag = menu.add_checkbox("rawetrip fake","on/off")


local function on_draw_watermark(watermark_text)
    -- watermark
    return "excord.lua   |  " .. user.name
end

local _set_clantag = ffi.cast('int(__fastcall*)(const char*, const char*)', memory.find_pattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))
local _last_clantag = nil

local set_clantag = function(v)
  if v == _last_clantag then return end
  _set_clantag(v, v)
  _last_clantag = v
end

local tag = {   

    '',
    'E',
    'eX',
    'exC',
    'excO',
    'excoR',
    'excorD',
    'excoR',
    'excO',
    'exC',
    'eX',
    'E',
    '',

} 

local engine_client_interface = memory.create_interface("engine.dll", "VEngineClient014")
local get_net_channel_info = ffi.cast("void*(__thiscall*)(void*)",memory.get_vfunc(engine_client_interface,78))
local net_channel_info = get_net_channel_info(ffi.cast("void***",engine_client_interface))
local get_latency = ffi.cast("float(__thiscall*)(void*,int)",memory.get_vfunc(tonumber(ffi.cast("unsigned long",net_channel_info)),9))

local function clantag_animation()
    if not engine.is_connected() then return end

    local latency = get_latency(ffi.cast("void***",net_channel_info),1) / global_vars.interval_per_tick()
    local tickcount_pred = global_vars.tick_count() + latency
    local iter = math.floor(math.fmod(tickcount_pred / 64, #tag) + 1)
    if enable_clantag:get() then
        set_clantag(tag[iter])
    else
        set_clantag("")
    end 
end

local function clantag_destroy()
    set_clantag("")
end

callbacks.add(e_callbacks.PAINT, function()
    clantag_animation()
end)

callbacks.add(e_callbacks.SHUTDOWN, function()
    clantag_destroy()
end)

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)