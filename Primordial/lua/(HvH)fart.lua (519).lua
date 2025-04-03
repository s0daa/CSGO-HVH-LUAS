local build = "Live"

local cheatusername = (user.name == "          ") and "Admin" or (user.name == "" and "" or user.name)
local cheatuseruid = (user.uid == "          ") and "Admin" or (user.uid == "" and "" or user.uid)

local function log_rect(from, to, colore,roundinga,alpha)
    local b_col = colore
    local alpph = toint(alpha)
    render.rect_filled(from, vector2(to.x-from.x,to.y-from.y), color(12,12,12,toint(alpph/2)),roundinga)
    render.rect(from, vector2(to.x-from.x,to.y-from.y), color(colore.r,colore.g,colore.b,alpph),roundinga)
    for n=1,3 do
        alpph = toint(alpha/255*((4-n)/3)*27)
        render.rect(vector2(from.x-n,from.y-n), vector2(to.x-from.x+n*2,to.y-from.y+n*2), color(colore.r,colore.g,colore.b,alpph),roundinga+n)
    end
end

function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end
function realint(n)
    local number = toint(n)
    if (n%1)>=0.5 then
        number = number+1
    end
    return number
end

local function item_button(min,max)
    local mouse = input.get_mouse_pos()
    if mouse.x>=min.x and mouse.x<=max.x and mouse.y >=min.y and mouse.y<= max.y then
        return true
    end
    return false
end

local function module(number)
    local n = number
    if number<0 then
        n = 0-number
    end
    return n
end
local function math_normalize(value,min,max)
    local v = value
    while v < min do
        v = v+(max-min)
    end
    while v > max do
        v = v-(max-min)
    end
    return v
end
local function vector2(x,y)
    return vec2_t(x,y)
end
local function vector3(x,y,z)
    return vec3_t(x,y,z)
end
local function color(r,g,b,a)
    return color_t(math_normalize(realint(r),0,255),math_normalize(realint(g),0,255),math_normalize(realint(b),0,255),math_normalize(realint(a),0,255))
end

local Render = {
    rect_filled=function(from, to, color,rounding)
        render.rect_filled(from, vector2(to.x-from.x,to.y-from.y), color,rounding)
    end,
    rect=function(from, to, color,rounding)
        render.rect(from, vector2(to.x-from.x,to.y-from.y), color,rounding)
    end,
    original_rect=function(from, to, colore,rounding)
        local b_col = color(colore.r,colore.g,colore.b,255)
        local alpph = colore.a
        render.rect_filled(from, vector2(to.x-from.x,to.y-from.y), color(12,12,12,alpph),rounding)
        render.rect(from, vector2(to.x-from.x,to.y-from.y), b_col,rounding)
        for n=1,3 do
            alpph = ((4-n)/3)*27
            render.rect(vector2(from.x-n,from.y-n), vector2(to.x-from.x+n*2,to.y-from.y+n*2), color(colore.r,colore.g,colore.b,alpph),rounding+n)
        end
    end
}

local screensize = render.get_screen_size()
local currentTime = global_vars.cur_time


local ffi_handler = {}
local configs = {}

ffi.cdef [[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local Acta = render.create_font("ActaSymbolsW95-Arrows", 15, 20)
local pixel = render.create_font("Smallest Pixel-7", 11, 20, e_font_flags.OUTLINE)
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
    ["double tap"] = menu.find("aimbot","general","exploits","doubletap","enable"),
    ["on shot anti-aim"] = menu.find("aimbot","general","exploits","hideshots","enable"),
    ["quick peek assist"] = menu.find("aimbot","general","misc","autopeek"),
    ["duck peek assist"] = menu.find("antiaim","main","general","fake duck"),
    ["anti-aim invert"] = menu.find("antiaim","main","manual","invert desync"),
    ["slowmotion"] = menu.find("misc","main","movement","slow walk"),
    ["ping spike"] = menu.find("aimbot","general", "fake ping","enable"),
    ["freestanding"] = menu.find("antiaim","main","auto direction","enable"),
    ["edge jump"] = menu.find("misc","main","movement","edge jump"),
    ["sneak"] = menu.find("misc","main","movement","sneak"),
    ["edge bug"] = menu.find("misc","main","movement","edge bug helper"),
    ["jump bug"] = menu.find("misc","main","movement","jump bug"),
    ["fire extinguisher"] = menu.find("misc","utility","general","fire extinguisher"),
    ["damage override"] = menu.find("aimbot", "auto", "target overrides", "force min. damage"),
}

local primordial = {
    ping_spike = menu.find("aimbot","general", "fake ping","enable")[2],
    jittermode = menu.find("antiaim","main", "angles","jitter mode"),
    jittertype = menu.find("antiaim","main", "angles","jitter type"),
    jitteradd = menu.find("antiaim","main", "angles","jitter add"),
    yawjitter = menu.find("antiaim","main", "angles","yaw add"),
    yawadd = menu.find("antiaim","main", "angles","yaw add"),
    D_side = menu.find("antiaim","main", "desync","side"),
    pitch = menu.find("antiaim","main", "angles","pitch"),
    bodyleanmode = menu.find("antiaim","main", "angles","body lean"),
    bodyleanamount = menu.find("antiaim","main", "angles","body lean value"),
    bodyleanjitter = menu.find("antiaim","main", "angles","body lean jitter"),
    movingbodylean = menu.find("antiaim","main", "angles","moving body lean", false),
    fakelag_limit = menu.find("antiaim", "main", "fakelag", "amount"),
    Antibrute = menu.find("antiaim","main", "desync","anti bruteforce", false),
    manual_left =  antiaim.get_manual_override() == 1,
    manual_right =  antiaim.get_manual_override() == 3,
    isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable"), -- get doubletap
    isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") ,-- get hideshots
    isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable"), -- get autopeek
    isSW = menu.find("misc","main","movement","slow walk", "enable") ,-- get Slow Walk
    color_menuj = menu.find("misc", "main", "config", "accent color"), -- get yaw base
    slowwalk_key = menu.find("misc", "main", "movement", "slow walk")[2],
    on_shot = menu.find("antiaim","main", "desync","on shot"),
    D_side = menu.find("antiaim","main", "desync","side#stand"),
    leftamount = menu.find("antiaim","main", "desync","left amount"),
    rightamount = menu.find("antiaim","main", "desync","right amount"),
    aw_base = menu.find("antiaim", "main", "angles", "yaw base"),
    autopeek = menu.find("aimbot","general","misc","autopeek"),
    mindmgmain = menu.find("aimbot", "auto", "target overrides", "force min. damage"),
    rotate = menu.find("antiaim","main", "angles","rotate", false),
    rotaterange = menu.find("antiaim","main", "angles","rotate range"),
    rotatespeed = menu.find("antiaim","main", "angles","rotate speed"),
    customjitter = menu.find("antiaim","main", "angles","jitter add"),
    customfpamount = menu.find("aimbot","general", "fake ping","ping amount"),
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

local ui = {
    -- main
    welcome = menu.add_text("fart.lua - Information", "You're welcome for pasting fart.lua!"),
    buildstate = menu.add_text("fart.lua - Information", string.format("Build State: %s", build)),
    selection_item = menu.add_selection("fart.lua - Information", "Current Tab:", {"Ragebot","Anti-aims", "Visuals", "Misc"}),

    FasterDoubletap = menu.add_checkbox("fart.lua - Ragebot", "Faster Doubletap", false),
    ClockCorrection = menu.add_checkbox("fart.lua - Ragebot", "Disable Clock Correction", false),
    saferecharge    = menu.add_checkbox("fart.lua - Ragebot", "Safe Recharge", false),
    AET             = menu.add_checkbox("fart.lua - Ragebot", "Quick Fall (Awp and Scout)", false),
    customfakeping  = menu.add_checkbox("fart.lua - Ragebot", "Custom backtrack", false),
    fpamount  = menu.add_slider("fart.lua - Ragebot", "Custom backtrack amount", 0, 1000),

    selection_presets = menu.add_selection("fart.lua - Anti-Aim", "Anti-aim preset:", {"-","Jitter", "Tank", "Safe", "Conditional"}),
    selection_condition = menu.add_selection("fart.lua - Anti-Aim", "Player state:", {"Standing", "Moving", "Slowwalk", "Crouch", "Air"}),

    Sseperator = menu.add_text("fart.lua - Anti-Aim Standing", "- Yaw Base -"),
    Spitch = menu.add_selection("fart.lua - Anti-Aim Standing", "Pitch:", {"None", "Down", "Up", "Zero", "Jitter"}),
    Syawmode = menu.add_selection("fart.lua - Anti-Aim Standing", "Yaw mode", {"Static", "Jitter"}),
    Syawadd = menu.add_slider("fart.lua - Anti-Aim Standing", "Yaw add", -180, 180),
    Syawaddleft = menu.add_slider("fart.lua - Anti-Aim Standing", "Yaw jitter left", -180, 180),
    Syawaddright = menu.add_slider("fart.lua - Anti-Aim Standing", "Yaw jitter right", -180, 180),
    Saw_base = menu.add_selection("fart.lua - Anti-Aim Standing", "Yaw Base", {"View angle", "At-targets (crosshair)", "At-targets (distance)"}),
    Sseperator3 = menu.add_text("fart.lua - Anti-Aim Standing", "- Yaw Modifier -"),
    Srotate = menu.add_checkbox("fart.lua - Anti-Aim Standing", "Rotate", false),
    Srotaterange = menu.add_slider("fart.lua - Anti-Aim Standing", "Rotate Range", 0, 360),
    Srotatespeed = menu.add_slider("fart.lua - Anti-Aim Standing", "Rotate Speed", 0, 100),
    Sjittermode = menu.add_selection("fart.lua - Anti-Aim Standing", "Jitter Mode:", {"None", "Static", "Random"}),
    Sjittertype = menu.add_selection("fart.lua - Anti-Aim Standing", "Jitter Type:", {"Offset", "Center"}),
    Sjitteradd = menu.add_slider("fart.lua - Anti-Aim Standing", "Jitter Amount", -180, 180),
    Sseperator5 = menu.add_text("fart.lua - Anti-Aim Standing", "- Roll Angles -"),
    Sbodyleanmode = menu.add_selection("fart.lua - Anti-Aim Standing", "Body Lean Mode:", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"}),
    Sbodyleanamount = menu.add_slider("fart.lua - Anti-Aim Standing", "Body Lean Amount:", -50, 50),
    Sbodyleanjitter = menu.add_slider("fart.lua - Anti-Aim Standing", "Body Lean Jitter:", 0, 100),
    Sseperator7 = menu.add_text("fart.lua - Anti-Aim Standing", "- Fake Options -"),
    SD_side = menu.add_selection("fart.lua - Anti-Aim Standing", "Desync Side:", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
    Sfake_limit_left = menu.add_slider("fart.lua - Anti-Aim Standing", "Fake limit left", 0, 100),
    Sfake_limit_right = menu.add_slider("fart.lua - Anti-Aim Standing", "Fake limit right", 0, 100),
    SAntibrute = menu.add_checkbox("fart.lua - Anti-Aim Standing", "Anti-Bruteforce", false),
    SOn_shot = menu.add_selection("fart.lua - Anti-Aim Standing", "On-shot:", {"Off", "Opposite", "Same Side", "Random"}),
    Sseperator9 = menu.add_text("fart.lua - Anti-Aim Standing", "- Fake lag -"),
    Sfakelag_limit = menu.add_slider("fart.lua - Anti-Aim Standing", "Fake Lag Amount", 1, 15),

    Mseperator = menu.add_text("fart.lua - Anti-Aim Moving", "- Yaw Base -"),
    Mpitch = menu.add_selection("fart.lua - Anti-Aim Moving", "Pitch:", {"None", "Down", "Up", "Zero", "Jitter"}),
    Myawmode = menu.add_selection("fart.lua - Anti-Aim Moving", "Yaw mode", {"Static", "Jitter"}),
    Myawadd = menu.add_slider("fart.lua - Anti-Aim Moving", "Yaw add", -180, 180),
    Myawaddleft = menu.add_slider("fart.lua - Anti-Aim Moving", "Yaw jitter left", -180, 180),
    Myawaddright = menu.add_slider("fart.lua - Anti-Aim Moving", "Yaw jitter right", -180, 180),
    Maw_base = menu.add_selection("fart.lua - Anti-Aim Moving", "Yaw Base", {"View angle", "At-targets (crosshair)", "At-targets (distance)"}),
    Mseperator3 = menu.add_text("fart.lua - Anti-Aim Moving", "- Yaw Modifier -"),
    Mrotate = menu.add_checkbox("fart.lua - Anti-Aim Moving", "Rotate", false),
    Mrotaterange = menu.add_slider("fart.lua - Anti-Aim Moving", "Rotate Range", 0, 360),
    Mrotatespeed = menu.add_slider("fart.lua - Anti-Aim Moving", "Rotate Speed", 0, 100),
    Mjittermode = menu.add_selection("fart.lua - Anti-Aim Moving", "Jitter Mode:", {"None", "Static", "Random"}),
    Mjittertype = menu.add_selection("fart.lua - Anti-Aim Moving", "Jitter Type:", {"Offset", "Center"}),
    Mjitteradd = menu.add_slider("fart.lua - Anti-Aim Moving", "Jitter Amount", -180, 180),
    Mseperator5 = menu.add_text("fart.lua - Anti-Aim Moving", "- Roll Angles -"),
    Mbodyleanmode = menu.add_selection("fart.lua - Anti-Aim Moving", "Body Lean Mode:", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"}),
    Mbodyleanamount = menu.add_slider("fart.lua - Anti-Aim Moving", "Body Lean Amount:", -50, 50),
    Mbodyleanjitter = menu.add_slider("fart.lua - Anti-Aim Moving", "Body Lean Jitter:", 0, 100),
    MAseperator7 = menu.add_text("fart.lua - Anti-Aim Moving", "- Fake Options -"),
    MD_side = menu.add_selection("fart.lua - Anti-Aim Moving", "Desync Side:", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
    Mfake_limit_left = menu.add_slider("fart.lua - Anti-Aim Moving", "Fake limit left", 0, 100),
    Mfake_limit_right = menu.add_slider("fart.lua - Anti-Aim Moving", "Fake limit right", 0, 100),
    MAntibrute = menu.add_checkbox("fart.lua - Anti-Aim Moving", "Anti-Bruteforce", false),
    MOn_shot = menu.add_selection("fart.lua - Anti-Aim Moving", "On-shot:", {"Off", "Opposite", "Same Side", "Random"}),
    Mseperator9 = menu.add_text("fart.lua - Anti-Aim Moving", "- Fake lag -"),
    Mfakelag_limit = menu.add_slider("fart.lua - Anti-Aim Moving", "Fake Lag Amount", 1, 15),
   
    SLseperator = menu.add_text("fart.lua - Anti-Aim Slowwalk", "- Yaw Base -"),
    SLpitch = menu.add_selection("fart.lua - Anti-Aim Slowwalk", "Pitch:", {"None", "Down", "Up", "Zero", "Jitter"}),
    SLyawmode = menu.add_selection("fart.lua - Anti-Aim Slowwalk", "Yaw mode", {"Static", "Jitter"}),
    SLyawadd = menu.add_slider("fart.lua - Anti-Aim Slowwalk", "Yaw add", -180, 180),
    SLyawaddleft = menu.add_slider("fart.lua - Anti-Aim Slowwalk", "Yaw jitter left", -180, 180),
    SLyawaddright = menu.add_slider("fart.lua - Anti-Aim Slowwalk", "Yaw jitter right", -180, 180),
    SLaw_base = menu.add_selection("fart.lua - Anti-Aim Slowwalk", "Yaw Base", {"View angle", "At-targets (crosshair)", "At-targets (distance)"}),
    SLseperator3 = menu.add_text("fart.lua - Anti-Aim Slowwalk", "- Yaw Modifier -"),
    SLrotate = menu.add_checkbox("fart.lua - Anti-Aim Slowwalk", "Rotate", false),
    SLrotaterange = menu.add_slider("fart.lua - Anti-Aim Slowwalk", "Rotate Range", 0, 360),
    SLrotatespeed = menu.add_slider("fart.lua - Anti-Aim Slowwalk", "Rotate Speed", 0, 100),
    SLjittermode = menu.add_selection("fart.lua - Anti-Aim Slowwalk", "Jitter Mode:", {"None", "Static", "Random"}),
    SLjittertype = menu.add_selection("fart.lua - Anti-Aim Slowwalk", "Jitter Type:", {"Offset", "Center"}),
    SLjitteradd = menu.add_slider("fart.lua - Anti-Aim Slowwalk", "Jitter Amount", -180, 180),
    SLseperator5 = menu.add_text("fart.lua - Anti-Aim Slowwalk", "- Roll Angles -"),
    SLbodyleanmode = menu.add_selection("fart.lua - Anti-Aim Slowwalk", "Body Lean Mode:", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"}),
    SLbodyleanamount = menu.add_slider("fart.lua - Anti-Aim Slowwalk", "Body Lean Amount:", -50, 50),
    SLbodyleanjitter = menu.add_slider("fart.lua - Anti-Aim Slowwalk", "Body Lean Jitter:", 0, 100),
    SLseperator7 = menu.add_text("fart.lua - Anti-Aim Slowwalk", "- Fake Options -"),
    SLD_side = menu.add_selection("fart.lua - Anti-Aim Slowwalk", "Desync Side:", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
    SLfake_limit_left = menu.add_slider("fart.lua - Anti-Aim Slowwalk", "Fake limit left", 0, 100),
    SLfake_limit_right = menu.add_slider("fart.lua - Anti-Aim Slowwalk", "Fake limit right", 0, 100),
    SLAntibrute = menu.add_checkbox("fart.lua - Anti-Aim Slowwalk", "Anti-Bruteforce", false),
    SLOn_shot = menu.add_selection("fart.lua - Anti-Aim Slowwalk", "On-shot:", {"Off", "Opposite", "Same Side", "Random"}),
    SLseperator9 = menu.add_text("fart.lua - Anti-Aim Slowwalk", "- Fake lag -"),
    SLfakelag_limit = menu.add_slider("fart.lua - Anti-Aim Slowwalk", "Fake Lag Amount", 1, 15),

    Cseperator = menu.add_text("fart.lua - Anti-Aim Crouch", "- Yaw Base -"),
    Cpitch = menu.add_selection("fart.lua - Anti-Aim Crouch", "Pitch:", {"None", "Down", "Up", "Zero", "Jitter"}),
    Cyawmode = menu.add_selection("fart.lua - Anti-Aim Crouch", "Yaw mode", {"Static", "Jitter"}),
    Cyawadd = menu.add_slider("fart.lua - Anti-Aim Crouch", "Yaw add", -180, 180),
    Cyawaddleft = menu.add_slider("fart.lua - Anti-Aim Crouch", "Yaw jitter left", -180, 180),
    Cyawaddright = menu.add_slider("fart.lua - Anti-Aim Crouch", "Yaw jitter right", -180, 180),
    Caw_base = menu.add_selection("fart.lua - Anti-Aim Crouch", "Yaw Base", {"View angle", "At-targets (crosshair)", "At-targets (distance)"}),
    Cseperator3 = menu.add_text("fart.lua - Anti-Aim Crouch", "- Yaw Modifier -"),
    Crotate = menu.add_checkbox("fart.lua - Anti-Aim Crouch", "Rotate", false),
    Crotaterange = menu.add_slider("fart.lua - Anti-Aim Crouch", "Rotate Range", 0, 360),
    Crotatespeed = menu.add_slider("fart.lua - Anti-Aim Crouch", "Rotate Speed", 0, 100),
    Cjittermode = menu.add_selection("fart.lua - Anti-Aim Crouch", "Jitter Mode:", {"None", "Static", "Random"}),
    Cjittertype = menu.add_selection("fart.lua - Anti-Aim Crouch", "Jitter Type:", {"Offset", "Center"}),
    Cjitteradd = menu.add_slider("fart.lua - Anti-Aim Crouch", "Jitter Amount", -180, 180),
    Cseperator5 = menu.add_text("fart.lua - Anti-Aim Crouch", "- Roll Angles -"),
    Cbodyleanmode = menu.add_selection("fart.lua - Anti-Aim Crouch", "Body Lean Mode:", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"}),
    Cbodyleanamount = menu.add_slider("fart.lua - Anti-Aim Crouch", "Body Lean Amount:", -50, 50),
    Cbodyleanjitter = menu.add_slider("fart.lua - Anti-Aim Crouch", "Body Lean Jitter:", 0, 100),
    Cseperator7 = menu.add_text("fart.lua - Anti-Aim Crouch", "- Fake Options -"),
    CD_side = menu.add_selection("fart.lua - Anti-Aim Crouch", "Desync Side:", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
    Cfake_limit_left = menu.add_slider("fart.lua - Anti-Aim Crouch", "Fake limit left", 0, 100),
    Cfake_limit_right = menu.add_slider("fart.lua - Anti-Aim Crouch", "Fake limit right", 0, 100),
    CAntibrute = menu.add_checkbox("fart.lua - Anti-Aim Crouch", "Anti-Bruteforce", false),
    COn_shot = menu.add_selection("fart.lua - Anti-Aim Crouch", "On-shot:", {"Off", "Opposite", "Same Side", "Random"}),
    Cseperator9 = menu.add_text("fart.lua - Anti-Aim Crouch", "- Fake lag -"),
    Cfakelag_limit = menu.add_slider("fart.lua - Anti-Aim Crouch", "Fake Lag Amount", 1, 15),
       
    Aseperator = menu.add_text("fart.lua - Anti-Aim Air", "- Yaw Base -"),
    Apitch = menu.add_selection("fart.lua - Anti-Aim Air", "Pitch:", {"None", "Down", "Up", "Zero", "Jitter"}),
    Ayawmode = menu.add_selection("fart.lua - Anti-Aim Air", "Yaw mode", {"Static", "Jitter"}),
    Ayawadd = menu.add_slider("fart.lua - Anti-Aim Air", "Yaw add", -180, 180),
    Ayawaddleft = menu.add_slider("fart.lua - Anti-Aim Air", "Yaw jitter left", -180, 180),
    Ayawaddright = menu.add_slider("fart.lua - Anti-Aim Air", "Yaw jitter right", -180, 180),
    Aaw_base = menu.add_selection("fart.lua - Anti-Aim Air", "Yaw Base", {"View angle", "At-targets (crosshair)", "At-targets (distance)"}),
    Aseperator3 = menu.add_text("fart.lua - Anti-Aim Air", "- Yaw Modifier -"),
    Arotate = menu.add_checkbox("fart.lua - Anti-Aim Air", "Rotate", false),
    Arotaterange = menu.add_slider("fart.lua - Anti-Aim Air", "Rotate Range", 0, 360),
    Arotatespeed = menu.add_slider("fart.lua - Anti-Aim Air", "Rotate Speed", 0, 100),
    Ajittermode = menu.add_selection("fart.lua - Anti-Aim Air", "Jitter Mode:", {"None", "Static", "Random"}),
    Ajittertype = menu.add_selection("fart.lua - Anti-Aim Air", "Jitter Type:", {"Offset", "Center"}),
    Ajitteradd = menu.add_slider("fart.lua - Anti-Aim Air", "Jitter Amount", -180, 180),
    Aseperator5 = menu.add_text("fart.lua - Anti-Aim Air", "- Roll Angles -"),
    Abodyleanmode = menu.add_selection("fart.lua - Anti-Aim Air", "Body Lean Mode:", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"}),
    Abodyleanamount = menu.add_slider("fart.lua - Anti-Aim Air", "Body Lean Amount:", -50, 50),
    Abodyleanjitter = menu.add_slider("fart.lua - Anti-Aim Air", "Body Lean Jitter:", 0, 100),
    Aseperator7 = menu.add_text("fart.lua - Anti-Aim Air", "- Fake Options -"),
    AD_side = menu.add_selection("fart.lua - Anti-Aim Air", "Desync Side:", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"}),
    Afake_limit_left = menu.add_slider("fart.lua - Anti-Aim Air", "Fake limit left", 0, 100),
    Afake_limit_right = menu.add_slider("fart.lua - Anti-Aim Air", "Fake limit right", 0, 100),
    AAntibrute = menu.add_checkbox("fart.lua - Anti-Aim Air", "Anti-Bruteforce", false),
    AOn_shot = menu.add_selection("fart.lua - Anti-Aim Air", "On-shot:", {"Off", "Opposite", "Same Side", "Random"}),
    Aseperator9 = menu.add_text("fart.lua - Anti-Aim Air", "- Fake lag -"),
    Afakelag_limit = menu.add_slider("fart.lua - Anti-Aim Air", "Fake Lag Amount", 1, 15),

    --visuals

    Colortxt = menu.add_text("fart.lua - Visuals", "Main color"),
    manualarrows = menu.add_selection("fart.lua - Visuals", "Manual Arrows", {"-", "Modern"}),
    indicatorsmain = menu.add_selection("fart.lua - Visuals", "Indicators:", {"-", "Modern"}),
    fartUI = menu.add_multi_selection("fart.lua - Visuals", "fart.lua UI", {"Watermark", "Keybinds", "Spectators"}),
    kibitmarker = menu.add_checkbox("fart.lua - Visuals", "Kibit Marker", on_paint),

    --misc
    clientside_animations = menu.add_multi_selection("fart.lua - Misc", "Clientside animations", {"Reversed legs", "Static legs in air", "Lean in-air", "Pitch 0 on land"}),
    clantag = menu.add_checkbox("fart.lua - Misc", "Clantag"),
    killsay = menu.add_checkbox("fart.lua - Misc", "Killsay"),
}

local clicked = {
    keybind = false,
    spectator = false,
    panel = false
}
local item_offsets = {
    keybind = vector2(0,0),
    spectator = vector2(0,0),
    panel = vector2(0,0)
}

local lua_offsets = {
    keybind = {
        x = menu.add_slider("fart.lua - Hiddent", "keybind.x", 10, screensize.x),
        y = menu.add_slider("fart.lua - Hiddent", "keybind.y", 0, screensize.y),
        modes = {"[toggled]", "[hold]", "[on]", "[on]","[off]"},
        alpha = 0,
        size = 160,
    },
    spectator = {
        x = menu.add_slider("fart.lua - Hiddent", "spectators_x", 10, screensize.x),
        y = menu.add_slider("fart.lua - Hiddent", "spectators_y", 0, screensize.y),
        alpha = 0,
        list = {},
        size = 140,
    },
    panel = {
        x = menu.add_slider("fart.lua - Hiddent", "panels_x", 10, screensize.x),
        y = menu.add_slider("fart.lua - Hiddent", "panels_y", 0, screensize.y),
        alpha = 0,
        size = 140,
    },
}
local color_acc = ui.Colortxt:add_color_picker("MainColor", color_t(255, 255, 255, 255), true)

menu.add_text("fart.lua - Information","")
menu.add_text("fart.lua - Information","")
menu.add_button("fart.lua - Information", "Load Default Config", function()

---- ragebot
    ui.customfakeping:set(true)
    ui.fpamount:set(100)
---- antiaim
    ui.selection_presets:set(4)
---- visuals
    ui.manualarrows:set(2)
    ui.indicatorsmain:set(4)
    ui.fartUI:set(1, true)
    ui.fartUI:set(2, true)
    ui.fartUI:set(3, true)
    ui.fartUI:set(4, true)
    lua_offsets.keybind.x:set(10)
    lua_offsets.keybind.y:set(500)
    lua_offsets.spectator.x:set(1445)
    lua_offsets.spectator.y:set(0)
    lua_offsets.panel.x:set(130)
    lua_offsets.panel.y:set(325)
----misc
    ui.clantag:set(true)
    ui.kibitmarker:set(true)
    ui.killsay:set(true)
    ui.clientside_animations:set(1, true)
    ui.clientside_animations:set(2, true)
    ui.clientside_animations:set(3, true)
    ui.clientside_animations:set(4, true)

    color_acc:set(color_t(155, 173, 255, 255))
end)

local globals = {
    crouching          = false,
    standing           = false,
    jumping            = false,
    slowwalk           = false,
    running            = false,
    pressing_move_keys = false
}

------------------------------ end of menu stuff

--ragebot start

local is_point_visible = function(ent)
    local e_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    if entity_list.get_local_player():is_point_visible(e_pos) then
        return true
    else
        return false
    end
end

local function get_cur_weapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end

    local cur_weapon = nil
    if local_player:get_prop("m_iHealth") > 0 then
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then
            return
        end

        cur_weapon = active_weapon:get_name()
    else
        return
    end

    return cur_weapon
end

local function doubletap(cmd, unpredicted_data)
    local clockcorrectionint = ui.ClockCorrection:get()
    local enemies= entity_list.get_players(true)
    local local_player = entity_list.get_local_player()
    local in_air = local_player:get_prop("m_vecVelocity[2]") ~= 0	
    local can_see = false
    local is_cur_wep = true

if ui.ClockCorrection:get() then
        cvars.cl_clock_correction:set_int(0)
    else
        cvars.cl_clock_correction:set_int(1)
    end

if ui.FasterDoubletap:get() then
    cvars.sv_maxusrcmdprocessticks:set_int(15 + 2)
    cvars.cl_clock_correction:get_int(clockcorrectionint)
else
    cvars.sv_maxusrcmdprocessticks:set_int(15)
    cvars.cl_clock_correction:get_int(clockcorrectionint)
end

if ui.AET:get() then
    for _, enemy in pairs(enemies) do
        if is_point_visible(enemy) and in_air then
            can_see = true
        end
    end

    if not can_see and not in_air then
        exploits.allow_recharge()
    end

    if can_see then
        exploits.force_uncharge()
        exploits.block_recharge()
    end
end
end

callbacks.add(e_callbacks.RUN_COMMAND, doubletap)

--safe recharge feature
local is_point_visible = function(ent)
    local e_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    if entity_list.get_local_player():is_point_visible(e_pos) then
        return true
    else
        return false
    end
end

local function doubletap(cmd, unpredicted_data)
    local enemies= entity_list.get_players(true)
    local local_player = entity_list.get_local_player()	
    local can_see = false 

if ui.saferecharge:get() then
    for _, enemy in pairs(enemies) do
        if is_point_visible(enemy) then
            can_see = true
        end
    end

    if not can_see and not in_air then
        exploits.allow_recharge()
    end

    if can_see then
        exploits.block_recharge()
    end

    if not can_see then
        exploits.allow_recharge()
    end

elseif not ui.saferecharge:get() then
    for _, enemy in pairs(enemies) do
        if is_point_visible(enemy) then
            can_see = true
        end
    end

    if can_see then
        exploits.allow_recharge()
    end

    if not can_see then
        exploits.allow_recharge()
    end
end
end

callbacks.add(e_callbacks.RUN_COMMAND, doubletap)

local function customfakeping(cmd, unpredicted_data)

if ui.customfakeping:get() then
        cvars.sv_maxunlag:set_float(1)
    else
        cvars.sv_maxunlag:set_float(0.2)
    end
end

callbacks.add(e_callbacks.RUN_COMMAND, customfakeping)
callbacks.add(e_callbacks.PAINT, customfakeping)

local function fpamount(cmd, unpredicted_data)

if ui.customfakeping:get() then
    primordial.customfpamount:set(ui.fpamount:get())
end
end

callbacks.add(e_callbacks.RUN_COMMAND, fpamount)

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

----------------------- end of ragebot
------- start of indicators

local function animation(check, name, value, speed) 
    if check then 
        return name + (value - name) * global_vars.frame_time() * speed 
    else 
        return name - (value + name) * global_vars.frame_time() * speed-- add / 2 if u want goig back effect
        
    end
end

local offset_scope = 0

local function Visuals_indic()
    local local_player = entity_list.get_local_player()
    if not engine.is_connected() then return end
    if not engine.is_in_game() then  return  end
    if not local_player:get_prop("m_iHealth") then return end
    local ay = 40
    local alpha = math.floor(math.abs(math.sin(global_vars.real_time() * 2)) * 255)
    local velocity = local_player:get_prop("m_vecVelocity").x
    local x = screensize.x / 2
    local y = screensize.y / 2
    local scoped = local_player:get_prop("m_bIsScoped") == 1
    local x2 = screensize.x / 2
    local y2 = screensize.y / 2
    
    offset_scope = animation(scoped, offset_scope, 25, 10)


    if ui.manualarrows:get() == 2 and local_player:is_alive() then
	render.triangle_filled(vec2_t.new(x2 - 20, y2), 8, color_t(0, 0, 0, 165),-90)
        render.triangle_filled(vec2_t.new(x2 + 20, y2), 8, color_t(0, 0, 0, 165), 90)

        if antiaim.get_manual_override() == 1 then
            render.triangle_filled(vec2_t.new(x2 - 20, y2), 8, color_t(color_acc:get().r, color_acc:get().g, color_acc:get().b, alpha),-90)
        end
       
        if antiaim.get_manual_override() == 3 then
            render.triangle_filled(vec2_t.new(x2 + 20, y2), 8, color_t(color_acc:get().r, color_acc:get().g, color_acc:get().b, alpha), 90)
        end
    end

    if ui.indicatorsmain:get() == 2 and local_player:is_alive() then
        
        local eternal_ts = render.get_text_size(pixel, "Vendetta")
        render.text(pixel, "fart", vec2_t(x + offset_scope + 18, y+ay-15), color_t(color_acc:get().r, color_acc:get().g, color_acc:get().b, 255), true, true)
        render.text(pixel, ".lua", vec2_t(x + offset_scope + 35, y+ay-15), color_t(255, 255, 255, 255), true, true)
        ay = ay + 10


        local asadsa = math.min(math.floor(math.sin((exploits.get_charge()%2) * 1) * 122), 100)
        if primordial.isDT[2]:get() then
        if exploits.get_charge() >= 1 then
            render.text(pixel, "DOUBLETAP", vec2_t(x + 26 + offset_scope, y+ay-15), color_t(255, 255, 255, 255), true, true)
            ay = ay + 9
        end
        if exploits.get_charge() < 1 then
            render.text(pixel, "DOUBLETAP", vec2_t(x + 26 + offset_scope, y+ay-15), color_t(255, 0, 0, 255), true, true)
            ay = ay + 9
        end
    end
     
        local ax = 0
        if primordial.isHS[2]:get() then
            render.text(pixel, "HIDESHOTS", vec2_t(x + 26 + offset_scope, y+ay-15), color_t(255, 255, 255, 255), true, true)
            ay = ay + 10
        end
    
        if primordial.ping_spike:get() then
            render.text(pixel, "PING", vec2_t(x + 26 + offset_scope, y+ay-15), color_t(255, 255, 255, 255), true, true)
            ay = ay + 10
        end
    end

if ui.indicatorsmain:get() == 4 and local_player:is_alive() then

local pixel = render.create_font("Smallest Pixel-7", 11, 20, e_font_flags.OUTLINE)    
--binds
local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") -- get hideshots
local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") -- get autopeek
local isSW = menu.find("misc","main","movement","slow walk", "enable") -- get slow walk
local isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox") -- get froce baim
local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint") -- get safe point
local isFD = menu.find("antiaim", "general", "fakeduck") -- get fake fuck

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

    local x = render.get_screen_size().x
    local y = render.get_screen_size().y

    --screen size
    local alpha1 = math.floor(math.abs(math.sin(global_vars.real_time() * 2)) * 255)
    if local_player:is_alive() then -- check if player is alive

end
end
end

local kibitmarker = true
local screen_size = render.get_screen_size()
local x = screen_size.x / 1.98
local y = screen_size.y / 2.01

local main_font = render.create_font("Pixel", 11, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local AutoO = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local ScoutO = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local DeagleO = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local RevolverO = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local PistolO = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local AwpO = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local Auto = menu.find("aimbot", "auto", "targeting","min. damage")
local Scout = menu.find("aimbot", "scout", "targeting","min. damage")
local Deagle = menu.find("aimbot", "deagle", "targeting","min. damage")
local Revolver = menu.find("aimbot", "revolver", "targeting","min. damage")
local Pistol = menu.find("aimbot", "pistols", "targeting","min. damage")
local Awp = menu.find("aimbot", "awp", "targeting","min. damage")

local AutoFO = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local ScoutFO = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local DeagleFO = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
local RevolverFO = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local PistolFO = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))
local AwpFO = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))

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

local function on_paint()
    if kibitmarker then

      --  if menu.is_open() then return end
        if ui.kibitmarker:get() then

            if getweapon() == "ssg08" then
                if ScoutO[2]:get() then
                    render.text(main_font, tostring(ScoutFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else ui.kibitmarker:get()
                    render.text(main_font, tostring(Scout:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "deagle" then
                if DeagleO[2]:get() then
                    render.text(main_font, tostring(DeagleFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else ui.kibitmarker:get() 
                    render.text(main_font, tostring(Deagle:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "revolver" then
                if RevolverO[2]:get() then
                    render.text(main_font, tostring(RevolverFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else ui.kibitmarker:get() 
                    render.text(main_font, tostring(Revolver:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "awp" then
                if AwpO[2]:get() then
                    render.text(main_font, tostring(AwpFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else ui.kibitmarker:get()
                    render.text(main_font, tostring(Awp:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
                if AutoO[2]:get() then
                    render.text(main_font, tostring(AutoFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else ui.kibitmarker:get()
                    render.text(main_font, tostring(Auto:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
                if PistolO[2]:get() then
                    render.text(main_font, tostring(PistolFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else ui.kibitmarker:get() 
                    render.text(main_font, tostring(Pistol:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            end

        end

    end
end

callbacks.add(e_callbacks.PAINT, on_paint)

---------------- end of indicators

---------------- start of fart.lua UI

local function watermark()
    local color = color_acc()
    if not ui.fartUI:get(1) then return end
    local screensize = render.get_screen_size()
    local h, m, s = client.get_local_time()
    local color =  color_acc:get()
    local text1 = string.format("fart.lua [%s] /", build)
    local wtm_size1 = render.get_text_size(verdana, text1)
    local text2 = string.format(" %s ",cheatusername)
    local wtm_size2 = render.get_text_size(verdana, text2)
    local text3 = ""
    local wtm_size3 = render.get_text_size(verdana, text3)
    local text4 = string.format("[%s]",cheatuseruid)
    local wtm_size4 = render.get_text_size(verdana, text4)
    local text5 = string.format(" / %02d:%02d:%02d ",  h, m, s)
    local wtm_size5 = render.get_text_size(verdana, text5)
    local text6 = "time / "
    local wtm_size6 = render.get_text_size(verdana, text6)
    local text7 = "delay: "
    local wtm_size7 = render.get_text_size(verdana, text7)
    local text8 = string.format("%dms", engine.get_latency(e_latency_flows)*1000)
    local wtm_size8 = render.get_text_size(verdana, text8)
    local wtm_string = string.format("Vendetta [%s] / [%s] %s / %02d:%02d:%02d time / delay: %dms ", build, cheatusername, cheatuseruid, h, m, s, engine.get_latency(e_latency_flows)*1000)
    local wtm_size = render.get_text_size(verdana, wtm_string)
    local wtm_allsize = screensize.x-wtm_size.x



    render.rect_filled(vec2_t(screensize.x-wtm_size.x-7, 8), vec2_t(wtm_size.x+0, 20), color_t(15,15,15,200), 5)
    render.rect(vec2_t(screensize.x-wtm_size.x-7, 7), vec2_t(wtm_size.x+0, 20), color, 6)

    render.text(verdana, text1, vec2_t(screensize.x-wtm_size.x+1, 11), color_t(255,255,255,255))
    render.text(verdana, text2, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+1, 11), color_t(255,255,255,255))
    render.text(verdana, text3, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+1, 11), color_t(255,255,255,255))
    render.text(verdana, text4, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x+1, 11), color_t(255,255,255,255))
    render.text(verdana, text5, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x+wtm_size4.x+1, 11), color_t(255,255,255,255))
    render.text(verdana, text6, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x+wtm_size4.x+wtm_size5.x+1, 11), color_t(255,255,255,255))
    render.text(verdana, text7, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x+wtm_size4.x+wtm_size5.x+wtm_size6.x+1, 11), color_t(255,255,255,255))
    render.text(verdana, text8, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x+wtm_size4.x+wtm_size5.x+wtm_size6.x+wtm_size7.x+1, 11), color_t(255,255,255,255))
end

-- keybinds
local function keybinds()
    local color = color_acc()
    if not ui.fartUI:get(2) or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if lua_offsets.keybind.show or menu.is_open() then
        lua_offsets.keybind.alpha = lua_offsets.keybind.alpha > 254 and 255 or lua_offsets.keybind.alpha + 15
    else
        lua_offsets.keybind.alpha = lua_offsets.keybind.alpha < 1 and 0 or lua_offsets.keybind.alpha - 15
    end
   
    render.push_alpha_modifier(lua_offsets.keybind.alpha/255)

    local mouse = input.get_mouse_pos()
    local hovered = item_button(vector2(lua_offsets.keybind.x:get(),lua_offsets.keybind.y:get()),vector2(lua_offsets.keybind.x:get()+146,lua_offsets.keybind.y:get()+19))
    if hovered and not clicked.panel and not clicked.spectator and not clicked.keybind and input.is_key_pressed(e_keys.MOUSE_LEFT) and menu.is_open() then
        clicked.keybinds = true
    elseif clicked.keybinds and input.is_key_held(e_keys.MOUSE_LEFT) and menu.is_open() then
        lua_offsets.keybind.x:set(mouse.x-item_offsets.keybind.x)
        lua_offsets.keybind.y:set(mouse.y-item_offsets.keybind.y)
    else
        clicked.keybinds = false
        item_offsets.keybind.x = mouse.x-lua_offsets.keybind.x:get()
        item_offsets.keybind.y = mouse.y-lua_offsets.keybind.y:get()
    end

    offset = 1
    
    for i, v in pairs(keybindings) do
        local dap = v[2]
        if dap:get() then
            render.text(verdana, i, vector2(lua_offsets.keybind.x:get()+2, lua_offsets.keybind.y:get()+22+(11*offset)), color_t(255,255,255,255))
            local itssize = render.get_text_size(verdana, lua_offsets.keybind.modes[dap:get_mode()+1])
            render.text(verdana, lua_offsets.keybind.modes[dap:get_mode()+1], vector2(lua_offsets.keybind.x:get()+lua_offsets.keybind.size-2-itssize.x, lua_offsets.keybind.y:get()+22+(11*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
    end
    Render.original_rect(vector2(lua_offsets.keybind.x:get()-3,lua_offsets.keybind.y:get()+7),vector2(lua_offsets.keybind.x:get()+162, lua_offsets.keybind.y:get()+26), color_t(30,30,30,180),8)
    render.rect(vec2_t(lua_offsets.keybind.x:get() - 3, lua_offsets.keybind.y:get()+7), vec2_t(lua_offsets.keybind.size+5, 20), color, 8)
    render.text(verdana, "keybinds", vec2_t(lua_offsets.keybind.x:get()+lua_offsets.keybind.size/2, lua_offsets.keybind.y:get()+17), color_t(255,255,255,255), true)
    lua_offsets.keybind.show = offset > 1
end


--spec list
local function spectators()

    local color = color_acc()
    if not ui.fartUI:get(3) or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if lua_offsets.spectator.show or menu.is_open() then
        lua_offsets.spectator.alpha = lua_offsets.spectator.alpha > 254 and 255 or lua_offsets.spectator.alpha + 15
    else
        lua_offsets.spectator.alpha = lua_offsets.spectator.alpha < 1 and 0 or lua_offsets.spectator.alpha - 15
    end
    render.push_alpha_modifier(lua_offsets.spectator.alpha/255)

    local mouse = input.get_mouse_pos()
    local hovered = item_button(vector2(lua_offsets.spectator.x:get(),lua_offsets.spectator.y:get()),vector2(lua_offsets.spectator.x:get()+146,lua_offsets.spectator.y:get()+19))
    if hovered and not clicked.panel and not clicked.spectator and not clicked.spectator and input.is_key_pressed(e_keys.MOUSE_LEFT) and menu.is_open() then
        clicked.spectator = true
    elseif clicked.spectator and input.is_key_held(e_keys.MOUSE_LEFT) and menu.is_open() then
        lua_offsets.spectator.x:set(mouse.x-item_offsets.spectator.x)
        lua_offsets.spectator.y:set(mouse.y-item_offsets.spectator.y)
    else
        clicked.spectator = false
        item_offsets.spectator.x = mouse.x-lua_offsets.spectator.x:get()
        item_offsets.spectator.y = mouse.y-lua_offsets.spectator.y:get()
    end

    Render.original_rect(vector2(lua_offsets.spectator.x:get()-3,lua_offsets.spectator.y:get()+8),vector2(lua_offsets.spectator.x:get()+142, lua_offsets.spectator.y:get()+26), color_t(30,30,30,180),8)
    render.rect(vec2_t(lua_offsets.spectator.x:get() - 3, lua_offsets.spectator.y:get()+7), vec2_t(lua_offsets.spectator.size+5, 20), color, 8)

    render.text(verdana, "spectators", vec2_t(lua_offsets.spectator.x:get()+lua_offsets.spectator.size/2, lua_offsets.spectator.y:get()+17), color_t(255,255,255,255), true)

    offset = 1
    curspec = 1

    local local_player = entity_list.get_local_player()

    local players = entity_list.get_players()

    if local_player:is_alive() then

    if not players then return end

    for i,v in pairs(players) do
        if not v then return end
        if v:is_dormant() then goto skip end
        local playername = v:get_name()
        if playername == "<blank>" then goto skip end
        local observing = entity_list.get_entity(v:get_prop("m_hObserverTarget"))
        if not observing then goto skip end
        if observing:get_index() == local_player:get_index() then
            local size = render.get_text_size(verdana, playername)
            lua_offsets.spectator.size = size.x/2
            render.text(verdana, playername, vec2_t(lua_offsets.spectator.x:get()+2, lua_offsets.spectator.y:get()+22+(10*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
        ::skip::
    end
end

    if lua_offsets.spectator.size < 140 then lua_offsets.spectator.size = 140 end

    for i = 1, #lua_offsets.spectator.list do
        render.text(verdana, lua_offsets.spectator.list[i], vec2_t(lua_offsets.spectator.x:get()+2, lua_offsets.spectator.y:get()+22+(12*offset)), color_t(255,255,255,255))
        offset = offset + 1
    end

    lua_offsets.spectator.show = offset > 1
end


---------------- end of vendetta ui

function on_paint()
    Visuals_indic()
    watermark()
    keybinds()
    spectators()

    local local_player = entity_list.get_local_player()
    if not local_player then return end
    local local_eyepos = local_player:get_eye_position()
    local view_angle = engine.get_view_angles()
end

----------------- start of antiaim
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)  
    return math.floor(num * mult + 0.5) / mult
  end
  

local function on_antiaim(ctx)

    local local_player = entity_list.get_local_player()
    if not local_player then return end
    local Slowmotion = menu.find("misc","main","movement","slow walk")
    local presetsc = ui.selection_presets:get()
    menu.find("antiaim", "main", "desync", "override stand#move"):set(false)
    menu.find("antiaim", "main", "desync", "override stand#slow walk"):set(false)

    if presetsc == 2 then
        if globals.jumping then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(26, 42))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(100)
            primordial.rightamount:set(100)
            primordial.yawadd:set(0)
            primordial.Antibrute:set(false)
            primordial.aw_base:set(3)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        elseif globals.crouching then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(38)
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(100)
            primordial.rightamount:set(100)
            primordial.yawadd:set(0)
            primordial.Antibrute:set(false)
            primordial.aw_base:set(3)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        elseif primordial.slowwalk_key:get() then 
            primordial.pitch:set(2)
            primordial.jittermode:set(3)
            primordial.jittertype:set(1)
            primordial.jitteradd:set(client.random_int(47, 52))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(client.random_int(78, 93))
            primordial.rightamount:set(client.random_int(46,73))
            primordial.yawadd:set(-6)
            primordial.Antibrute:set(true)
            primordial.aw_base:set(3)
            primordial.on_shot:set(4)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        elseif globals.running then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(34, 44))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(client.random_int(88, 100))
            primordial.rightamount:set(client.random_int(68, 100))
            primordial.yawadd:set(client.random_int(-3, 3))
            primordial.aw_base:set(3)
            primordial.Antibrute:set(false)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        elseif globals.standing then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(28, 34))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(client.random_int(92, 100))
            primordial.rightamount:set(client.random_int(88, 100))
            primordial.yawadd:set(0)
            primordial.aw_base:set(3)
            primordial.Antibrute:set(false)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        end
    elseif presetsc == 3 then
        if globals.jumping then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(42, 48))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(client.random_int(88, 100))
            primordial.rightamount:set(client.random_int(88, 100))
            primordial.yawadd:set(client.random_int(-3, 3))
            primordial.Antibrute:set(false)
            primordial.aw_base:set(3)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        elseif globals.crouching then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(42, 48))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(client.random_int(88, 100))
            primordial.rightamount:set(client.random_int(88, 100))
            primordial.yawadd:set(client.random_int(-3, 3))
            primordial.Antibrute:set(false)
            primordial.aw_base:set(3)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        elseif primordial.slowwalk_key:get() then 
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(1, 47))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(client.random_int(96, 100))
            primordial.rightamount:set(client.random_int(96, 100))
            primordial.yawadd:set(0)
            primordial.Antibrute:set(false)
            primordial.aw_base:set(3)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        elseif globals.running then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(42, 48))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(client.random_int(88, 100))
            primordial.rightamount:set(client.random_int(88, 100))
            primordial.yawadd:set(client.random_int(-3, 3))
            primordial.Antibrute:set(false)
            primordial.aw_base:set(3)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        elseif globals.standing then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(42, 48))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(client.random_int(88, 100))
            primordial.rightamount:set(client.random_int(88, 100))
            primordial.yawadd:set(client.random_int(-3, 3))
            primordial.Antibrute:set(false)
            primordial.aw_base:set(3)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        end
    elseif presetsc == 4 then
        if globals.jumping then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(3, 7))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(100)
            primordial.rightamount:set(100)
            primordial.yawadd:set(0)
            primordial.Antibrute:set(false)
            primordial.aw_base:set(3)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        elseif globals.crouching then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(8, 13))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(100)
            primordial.rightamount:set(100)
            primordial.yawadd:set(0)
            primordial.Antibrute:set(false)
            primordial.aw_base:set(3)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        elseif primordial.slowwalk_key:get() then
            primordial.pitch:set(2)
            primordial.jittermode:set(3)
            primordial.jittertype:set(1)
            primordial.jitteradd:set(client.random_int(5, 7))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(client.random_int(60, 100))
            primordial.rightamount:set(client.random_int(84,90))
            primordial.yawadd:set(0)
            primordial.Antibrute:set(true)
            primordial.aw_base:set(3)
            primordial.on_shot:set(4)
            primordial.D_side:set(3)
            primordial.fakelag_limit:set(15)
        elseif globals.running then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(27, 35))
            primordial.bodyleanmode:set(2)
            primordial.bodyleanamount:set(20)
            primordial.bodyleanjitter:set(0)
            primordial.movingbodylean:set(true)
            primordial.leftamount:set(client.random_int(98, 100))
            primordial.rightamount:set(client.random_int(98, 100))
            primordial.yawadd:set(client.random_int(-3, 2))
            primordial.aw_base:set(3)
            primordial.Antibrute:set(true)
            primordial.on_shot:set(2)
            primordial.D_side:set(4)
            primordial.fakelag_limit:set(15)
        elseif globals.standing then
            primordial.pitch:set(2)
            primordial.jittermode:set(2)
            primordial.jittertype:set(2)
            primordial.jitteradd:set(client.random_int(0, 0))
            primordial.bodyleanmode:set(0)
            primordial.bodyleanamount:set(0)
            primordial.bodyleanjitter:set(0)
            primordial.leftamount:set(client.random_int(92, 100))
            primordial.rightamount:set(client.random_int(88, 100))
            primordial.yawadd:set(0)
            primordial.aw_base:set(3)
            primordial.Antibrute:set(false)
            primordial.on_shot:set(2)
            primordial.D_side:set(3)
            primordial.fakelag_limit:set(15)
        end
    elseif presetsc == 5 then
            if globals.jumping then
                primordial.pitch:set(ui.Apitch:get())
                primordial.rotate:set(ui.Arotate:get())
                primordial.rotaterange:set(ui.Arotaterange:get())
                primordial.rotatespeed:set(ui.Arotatespeed:get())
                primordial.jittermode:set(ui.Ajittermode:get())
                primordial.jittertype:set(ui.Ajittertype:get())
                primordial.jitteradd:set(ui.Ajitteradd:get())
                primordial.bodyleanmode:set(ui.Abodyleanmode:get())
                primordial.bodyleanamount:set(ui.Abodyleanamount:get())
                primordial.bodyleanjitter:set(ui.Abodyleanjitter:get())
                primordial.leftamount:set(ui.Afake_limit_left:get())
                primordial.rightamount:set(ui.Afake_limit_right:get())
                if ui.Ayawmode:get() == 1 then
                    primordial.yawadd:set(ui.Ayawadd:get())
                    else
                    primordial.yawjitter:set(global_vars.server_tick() % 4 > 1 and ui.Ayawaddleft:get() or ui.Ayawaddright:get())
                    end
                primordial.Antibrute:set(ui.AAntibrute:get())
                primordial.on_shot:set(ui.AOn_shot:get())
                primordial.D_side:set(ui.AD_side:get())
                primordial.fakelag_limit:set(ui.Afakelag_limit:get())
            elseif globals.crouching then
                primordial.pitch:set(ui.Cpitch:get())
                primordial.rotate:set(ui.Crotate:get())
                primordial.rotaterange:set(ui.Crotaterange:get())
                primordial.rotatespeed:set(ui.Crotatespeed:get())
                primordial.jittermode:set(ui.Cjittermode:get())
                primordial.jittertype:set(ui.Cjittertype:get())
                primordial.jitteradd:set(ui.Cjitteradd:get())
                primordial.bodyleanmode:set(ui.Cbodyleanmode:get())
                primordial.bodyleanamount:set(ui.Cbodyleanamount:get())
                primordial.bodyleanjitter:set(ui.Cbodyleanjitter:get())
                primordial.leftamount:set(ui.Cfake_limit_left:get())
                primordial.rightamount:set(ui.Cfake_limit_right:get())
                if ui.Cyawmode:get() == 1 then
                    primordial.yawadd:set(ui.Cyawadd:get())
                    else
                    primordial.yawjitter:set(global_vars.server_tick() % 4 > 1 and ui.Cyawaddleft:get() or ui.Cyawaddright:get())
                    end
                primordial.Antibrute:set(ui.CAntibrute:get())
                primordial.on_shot:set(ui.COn_shot:get())
                primordial.D_side:set(ui.CD_side:get())
                primordial.fakelag_limit:set(ui.Cfakelag_limit:get())
            elseif primordial.slowwalk_key:get() then 
                primordial.pitch:set(ui.SLpitch:get())
                primordial.rotate:set(ui.SLrotate:get())
                primordial.rotaterange:set(ui.SLrotaterange:get())
                primordial.rotatespeed:set(ui.SLrotatespeed:get())
                primordial.jittermode:set(ui.SLjittermode:get())
                primordial.jittertype:set(ui.SLjittertype:get())
                primordial.jitteradd:set(ui.SLjitteradd:get())
                primordial.bodyleanmode:set(ui.SLbodyleanmode:get())
                primordial.bodyleanamount:set(ui.SLbodyleanamount:get())
                primordial.bodyleanjitter:set(ui.SLbodyleanjitter:get())
                primordial.leftamount:set(ui.SLfake_limit_left:get())
                primordial.rightamount:set(ui.SLfake_limit_right:get())
                if ui.SLyawmode:get() == 1 then
                    primordial.yawadd:set(ui.SLyawadd:get())
                    else
                    primordial.yawjitter:set(global_vars.server_tick() % 4 > 1 and ui.SLyawaddleft:get() or ui.SLyawaddright:get())
                    end
                primordial.Antibrute:set(ui.SLAntibrute:get())
                primordial.on_shot:set(ui.SLOn_shot:get())
                primordial.D_side:set(ui.SLD_side:get())
                primordial.fakelag_limit:set(ui.SLfakelag_limit:get())
            elseif globals.running then
                primordial.pitch:set(ui.Mpitch:get())
                primordial.rotate:set(ui.Mrotate:get())
                primordial.rotaterange:set(ui.Mrotaterange:get())
                primordial.rotatespeed:set(ui.Mrotatespeed:get())
                primordial.jittermode:set(ui.Mjittermode:get())
                primordial.jittertype:set(ui.Mjittertype:get())
                primordial.jitteradd:set(ui.Mjitteradd:get())
                primordial.bodyleanmode:set(ui.Mbodyleanmode:get())
                primordial.bodyleanamount:set(ui.Mbodyleanamount:get())
                primordial.bodyleanjitter:set(ui.Mbodyleanjitter:get())
                primordial.leftamount:set(ui.Mfake_limit_left:get())
                primordial.rightamount:set(ui.Mfake_limit_right:get())
                if ui.Myawmode:get() == 1 then
                    primordial.yawadd:set(ui.Myawadd:get())
                    else
                    primordial.yawjitter:set(global_vars.server_tick() % 4 > 1 and ui.Myawaddleft:get() or ui.Myawaddright:get())
                    end
                primordial.Antibrute:set(ui.MAntibrute:get())
                primordial.on_shot:set(ui.MOn_shot:get())
                primordial.D_side:set(ui.MD_side:get())
                primordial.fakelag_limit:set(ui.Mfakelag_limit:get())
            elseif globals.standing then
                primordial.pitch:set(ui.Spitch:get())
                primordial.rotate:set(ui.Srotate:get())
                primordial.rotaterange:set(ui.Srotaterange:get())
                primordial.rotatespeed:set(ui.Srotatespeed:get())
                primordial.jittermode:set(ui.Sjittermode:get())
                primordial.jittertype:set(ui.Sjittertype:get())
                primordial.jitteradd:set(ui.Sjitteradd:get())
                primordial.bodyleanmode:set(ui.Sbodyleanmode:get())
                primordial.bodyleanamount:set(ui.Sbodyleanamount:get())
                primordial.bodyleanjitter:set(ui.Sbodyleanjitter:get())
                primordial.leftamount:set(ui.Sfake_limit_left:get())
                primordial.rightamount:set(ui.Sfake_limit_right:get())
                if ui.Syawmode:get() == 1 then
                    primordial.yawadd:set(ui.Syawadd:get())
                    else
                    primordial.yawjitter:set(global_vars.server_tick() % 4 > 1 and ui.Syawaddleft:get() or ui.Syawaddright:get())
                    end
                primordial.Antibrute:set(ui.SAntibrute:get())
                primordial.on_shot:set(ui.SOn_shot:get())
                primordial.D_side:set(ui.SD_side:get())
                primordial.fakelag_limit:set(ui.Sfakelag_limit:get())
            end
        end
    end


    ---------------------- start of AA config system

   cfg_import = menu.add_button("fart.lua - Anti-Aim", "Import Config From Clipboard", function() configs.import() end)
   cfg_export = menu.add_button("fart.lua - Anti-Aim", "Export Config To Clipboard", function() configs.export() end)

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
   
   configs.import = function(input) --- add here ur features
       local protected = function()
           local clipboard = input == nil and clipboard_import() or input
           local tbl = str_to_sub(clipboard, "|")
           ui.selection_presets:set(tonumber(tbl[1]))
           ui.Spitch:set(tonumber(tbl[2]))
           ui.Syawmode:set(tonumber(tbl[3]))
           ui.Syawadd:set(tonumber(tbl[4]))
           ui.Syawaddleft:set(tonumber(tbl[5]))
           ui.Syawaddright:set(tonumber(tbl[6]))
           ui.Saw_base:set(tonumber(tbl[7]))
           ui.Srotate:set(to_boolean(tbl[8]))
           ui.Srotaterange:set(tonumber(tbl[9]))
           ui.Srotatespeed:set(tonumber(tbl[10]))
           ui.Sjittermode:set(tonumber(tbl[11]))
           ui.Sjittertype:set(tonumber(tbl[12]))
           ui.Sjitteradd:set(tonumber(tbl[13]))
           ui.Sbodyleanmode:set(tonumber(tbl[14]))
           ui.Sbodyleanamount:set(tonumber(tbl[15]))
           ui.Sbodyleanjitter:set(tonumber(tbl[16]))
           ui.SD_side:set(tonumber(tbl[17]))
           ui.Sfake_limit_left:set(tonumber(tbl[18]))
           ui.Sfake_limit_right:set(tonumber(tbl[19]))
           ui.SAntibrute:set(to_boolean(tbl[20]))
           ui.SOn_shot:set(tonumber(tbl[21]))
           ui.Sfakelag_limit:set(tonumber(tbl[22]))
           ui.Mpitch:set(tonumber(tbl[23]))
           ui.Myawmode:set(tonumber(tbl[24]))
           ui.Myawadd:set(tonumber(tbl[25]))
           ui.Myawaddleft:set(tonumber(tbl[26]))
           ui.Myawaddright:set(tonumber(tbl[27]))
           ui.Maw_base:set(tonumber(tbl[28]))
           ui.Mrotate:set(to_boolean(tbl[29]))
           ui.Mrotaterange:set(tonumber(tbl[30]))
           ui.Mrotatespeed:set(tonumber(tbl[31]))
           ui.Mjittermode:set(tonumber(tbl[32]))
           ui.Mjittertype:set(tonumber(tbl[33]))
           ui.Mjitteradd:set(tonumber(tbl[34]))
           ui.Mbodyleanmode:set(tonumber(tbl[35]))
           ui.Mbodyleanamount:set(tonumber(tbl[36]))
           ui.Mbodyleanjitter:set(tonumber(tbl[37]))
           ui.MD_side:set(tonumber(tbl[38]))
           ui.Mfake_limit_left:set(tonumber(tbl[39]))
           ui.Mfake_limit_right:set(tonumber(tbl[40]))
           ui.MAntibrute:set(to_boolean(tbl[41]))
           ui.MOn_shot:set(tonumber(tbl[42]))
           ui.Mfakelag_limit:set(tonumber(tbl[43]))
           ui.SLpitch:set(tonumber(tbl[44]))
           ui.SLyawmode:set(tonumber(tbl[45]))
           ui.SLyawadd:set(tonumber(tbl[46]))
           ui.SLyawaddleft:set(tonumber(tbl[47]))
           ui.SLyawaddright:set(tonumber(tbl[48]))
           ui.SLaw_base:set(tonumber(tbl[49]))
           ui.SLrotate:set(to_boolean(tbl[50]))
           ui.SLrotaterange:set(tonumber(tbl[51]))
           ui.SLrotatespeed:set(tonumber(tbl[52]))
           ui.SLjittermode:set(tonumber(tbl[53]))
           ui.SLjittertype:set(tonumber(tbl[54]))
           ui.SLjitteradd:set(tonumber(tbl[55]))
           ui.SLbodyleanmode:set(tonumber(tbl[56]))
           ui.SLbodyleanamount:set(tonumber(tbl[57]))
           ui.SLbodyleanjitter:set(tonumber(tbl[58]))
           ui.SLD_side:set(tonumber(tbl[59]))
           ui.SLfake_limit_left:set(tonumber(tbl[60]))
           ui.SLfake_limit_right:set(tonumber(tbl[61]))
           ui.SLAntibrute:set(to_boolean(tbl[62]))
           ui.SLOn_shot:set(tonumber(tbl[63]))
           ui.SLfakelag_limit:set(tonumber(tbl[64]))
           ui.Cpitch:set(tonumber(tbl[65]))
           ui.Cyawmode:set(tonumber(tbl[66]))
           ui.Cyawadd:set(tonumber(tbl[67]))
           ui.Cyawaddleft:set(tonumber(tbl[68]))
           ui.Cyawaddright:set(tonumber(tbl[69]))
           ui.Caw_base:set(tonumber(tbl[70]))
           ui.Crotate:set(to_boolean(tbl[71]))
           ui.Crotaterange:set(tonumber(tbl[72]))
           ui.Crotatespeed:set(tonumber(tbl[73]))
           ui.Cjittermode:set(tonumber(tbl[74]))
           ui.Cjittertype:set(tonumber(tbl[75]))
           ui.Cjitteradd:set(tonumber(tbl[76]))
           ui.Cbodyleanmode:set(tonumber(tbl[77]))
           ui.Cbodyleanamount:set(tonumber(tbl[78]))
           ui.Cbodyleanjitter:set(tonumber(tbl[79]))
           ui.CD_side:set(tonumber(tbl[80]))
           ui.Cfake_limit_left:set(tonumber(tbl[81]))
           ui.Cfake_limit_right:set(tonumber(tbl[82]))
           ui.SAntibrute:set(to_boolean(tbl[83]))
           ui.SOn_shot:set(tonumber(tbl[84]))
           ui.Cfakelag_limit:set(tonumber(tbl[85]))
           ui.Apitch:set(tonumber(tbl[86]))
           ui.Ayawmode:set(tonumber(tbl[87]))
           ui.Ayawadd:set(tonumber(tbl[88]))
           ui.Ayawaddleft:set(tonumber(tbl[89]))
           ui.Ayawaddright:set(tonumber(tbl[90]))
           ui.Aaw_base:set(tonumber(tbl[91]))
           ui.Arotate:set(to_boolean(tbl[92]))
           ui.Arotaterange:set(tonumber(tbl[93]))
           ui.Arotatespeed:set(tonumber(tbl[94]))
           ui.Ajittermode:set(tonumber(tbl[95]))
           ui.Ajittertype:set(tonumber(tbl[96]))
           ui.Ajitteradd:set(tonumber(tbl[97]))
           ui.Abodyleanmode:set(tonumber(tbl[98]))
           ui.Abodyleanamount:set(tonumber(tbl[99]))
           ui.Abodyleanjitter:set(tonumber(tbl[100]))
           ui.AD_side:set(tonumber(tbl[101]))
           ui.Afake_limit_left:set(tonumber(tbl[102]))
           ui.Afake_limit_right:set(tonumber(tbl[103]))
           ui.AAntibrute:set(to_boolean(tbl[104]))
           ui.AOn_shot:set(tonumber(tbl[105]))
           ui.Afakelag_limit:set(tonumber(tbl[106]))
   
           client.log_screen("Config loaded")
       end
       local status, message = pcall(protected)
       if not status then
           client.log_screen("Failed to load config")
           return
       end
   end
   
   
   configs.export = function()
       local str = { tostring(ui.selection_presets:get()) .. "|",
       tostring(ui.Spitch:get()) .. "|",
       tostring(ui.Syawmode:get()) .. "|",
       tostring(ui.Syawadd:get()) .. "|",
       tostring(ui.Syawaddleft:get()) .. "|",
       tostring(ui.Syawaddright:get()) .. "|",
       tostring(ui.Saw_base:get()) .. "|",
       tostring(ui.Srotate:get()) .. "|",
       tostring(ui.Srotaterange:get()) .. "|",
       tostring(ui.Srotatespeed:get()) .. "|",
       tostring(ui.Sjittermode:get()) .. "|",
       tostring(ui.Sjittertype:get()) .. "|",
       tostring(ui.Sjitteradd:get()) .. "|",
       tostring(ui.Sbodyleanmode:get()) .. "|",
       tostring(ui.Sbodyleanamount:get()) .. "|",
       tostring(ui.Sbodyleanjitter:get()) .. "|",
       tostring(ui.SD_side:get()) .. "|",
       tostring(ui.Sfake_limit_left:get()) .. "|",
       tostring(ui.Sfake_limit_right:get()) .. "|",
       tostring(ui.SAntibrute:get()) .. "|",
       tostring(ui.SOn_shot:get()) .. "|",
       tostring(ui.Sfakelag_limit:get()) .. "|",
       tostring(ui.Mpitch:get()) .. "|",
       tostring(ui.Myawmode:get()) .. "|",
       tostring(ui.Myawadd:get()) .. "|",
       tostring(ui.Myawaddleft:get()) .. "|",
       tostring(ui.Myawaddright:get()) .. "|",
       tostring(ui.Maw_base:get()) .. "|",
       tostring(ui.Mrotate:get()) .. "|",
       tostring(ui.Mrotaterange:get()) .. "|",
       tostring(ui.Mrotatespeed:get()) .. "|",
       tostring(ui.Mjittermode:get()) .. "|",
       tostring(ui.Mjittertype:get()) .. "|",
       tostring(ui.Mjitteradd:get()) .. "|",
       tostring(ui.Mbodyleanmode:get()) .. "|",
       tostring(ui.Mbodyleanamount:get()) .. "|",
       tostring(ui.Mbodyleanjitter:get()) .. "|",
       tostring(ui.MD_side:get()) .. "|",
       tostring(ui.Mfake_limit_left:get()) .. "|",
       tostring(ui.Mfake_limit_right:get()) .. "|",
       tostring(ui.MAntibrute:get()) .. "|",
       tostring(ui.MOn_shot:get()) .. "|",
       tostring(ui.Mfakelag_limit:get()) .. "|",
       tostring(ui.SLpitch:get()) .. "|",
       tostring(ui.SLyawmode:get()) .. "|",
       tostring(ui.SLyawadd:get()) .. "|",
       tostring(ui.SLyawaddleft:get()) .. "|",
       tostring(ui.SLyawaddright:get()) .. "|",
       tostring(ui.SLaw_base:get()) .. "|",
       tostring(ui.SLrotate:get()) .. "|",
       tostring(ui.SLrotaterange:get()) .. "|",
       tostring(ui.SLrotatespeed:get()) .. "|",
       tostring(ui.SLjittermode:get()) .. "|",
       tostring(ui.SLjittertype:get()) .. "|",
       tostring(ui.SLjitteradd:get()) .. "|",
       tostring(ui.SLbodyleanmode:get()) .. "|",
       tostring(ui.SLbodyleanamount:get()) .. "|",
       tostring(ui.SLbodyleanjitter:get()) .. "|",
       tostring(ui.SLD_side:get()) .. "|",
       tostring(ui.SLfake_limit_left:get()) .. "|",
       tostring(ui.SLfake_limit_right:get()) .. "|",
       tostring(ui.SLAntibrute:get()) .. "|",
       tostring(ui.SLOn_shot:get()) .. "|",
       tostring(ui.SLfakelag_limit:get()) .. "|",
       tostring(ui.Cpitch:get()) .. "|",
       tostring(ui.Cyawmode:get()) .. "|",
       tostring(ui.Cyawadd:get()) .. "|",
       tostring(ui.Cyawaddleft:get()) .. "|",
       tostring(ui.Cyawaddright:get()) .. "|",
       tostring(ui.Caw_base:get()) .. "|",
       tostring(ui.Crotate:get()) .. "|",
       tostring(ui.Crotaterange:get()) .. "|",
       tostring(ui.Crotatespeed:get()) .. "|",
       tostring(ui.Cjittermode:get()) .. "|",
       tostring(ui.Cjittertype:get()) .. "|",
       tostring(ui.Cjitteradd:get()) .. "|",
       tostring(ui.Cbodyleanmode:get()) .. "|",
       tostring(ui.Cbodyleanamount:get()) .. "|",
       tostring(ui.Cbodyleanjitter:get()) .. "|",
       tostring(ui.CD_side:get()) .. "|",
       tostring(ui.Cfake_limit_left:get()) .. "|",
       tostring(ui.Cfake_limit_right:get()) .. "|",
       tostring(ui.CAntibrute:get()) .. "|",
       tostring(ui.COn_shot:get()) .. "|",
       tostring(ui.Cfakelag_limit:get()) .. "|",
       tostring(ui.Apitch:get()) .. "|",
       tostring(ui.Ayawmode:get()) .. "|",
       tostring(ui.Ayawadd:get()) .. "|",
       tostring(ui.Ayawaddleft:get()) .. "|",
       tostring(ui.Ayawaddright:get()) .. "|",
       tostring(ui.Aaw_base:get()) .. "|",
       tostring(ui.Arotate:get()) .. "|",
       tostring(ui.Arotaterange:get()) .. "|",
       tostring(ui.Arotatespeed:get()) .. "|",
       tostring(ui.Ajittermode:get()) .. "|",
       tostring(ui.Ajittertype:get()) .. "|",
       tostring(ui.Ajitteradd:get()) .. "|",
       tostring(ui.Abodyleanmode:get()) .. "|",
       tostring(ui.Abodyleanamount:get()) .. "|",
       tostring(ui.Abodyleanjitter:get()) .. "|",
       tostring(ui.AD_side:get()) .. "|",
       tostring(ui.Afake_limit_left:get()) .. "|",
       tostring(ui.Afake_limit_right:get()) .. "|",
       tostring(ui.AAntibrute:get()) .. "|",
       tostring(ui.AOn_shot:get()) .. "|",
       tostring(ui.Afakelag_limit:get()) .. "|",
        }
       clipboard_export(table.concat(str))
       client.log_screen("config was copied")
   end

   --------------- end of AA config system
   --------------- start of menu and tabs

local function draw_menu()
    if not show then
      --  text_input_item:set_visible(false)
        menu.set_group_visibility("fart.lua - Information", true)
        local menu_val = ui.selection_item:get()
        local menu_conditiom = ui.selection_condition:get()
        local selection_presets = ui.selection_presets:get()
        antia = false
        menu.set_group_column("fart.lua - Information", 2)

        ui.fpamount:set_visible(ui.customfakeping:get())

        ui.Sbodyleanamount:set_visible(ui.Sbodyleanmode:get() == 2)
        ui.Sbodyleanjitter:set_visible(ui.Sbodyleanmode:get() == 3 or ui.Sbodyleanmode:get() == 4)
        ui.Mbodyleanamount:set_visible(ui.Mbodyleanmode:get() == 2)
        ui.Mbodyleanjitter:set_visible(ui.Mbodyleanmode:get() == 3 or ui.Mbodyleanmode:get() == 4)
        ui.SLbodyleanamount:set_visible(ui.SLbodyleanmode:get() == 2)
        ui.SLbodyleanjitter:set_visible(ui.SLbodyleanmode:get() == 3 or ui.SLbodyleanmode:get() == 4)
        ui.Cbodyleanamount:set_visible(ui.Cbodyleanmode:get() == 2)
        ui.Cbodyleanjitter:set_visible(ui.Cbodyleanmode:get() == 3 or ui.Cbodyleanmode:get() == 4)
        ui.Abodyleanamount:set_visible(ui.Abodyleanmode:get() == 2)
        ui.Abodyleanjitter:set_visible(ui.Abodyleanmode:get() == 3 or ui.Abodyleanmode:get() == 4)

        ui.Syawadd:set_visible(ui.Syawmode:get() == 1)
        ui.Syawaddleft:set_visible(ui.Syawmode:get() == 2)
        ui.Syawaddright:set_visible(ui.Syawmode:get() == 2)
        ui.Myawadd:set_visible(ui.Myawmode:get() == 1)
        ui.Myawaddleft:set_visible(ui.Myawmode:get() == 2)
        ui.Myawaddright:set_visible(ui.Myawmode:get() == 2)
        ui.SLyawadd:set_visible(ui.SLyawmode:get() == 1)
        ui.SLyawaddleft:set_visible(ui.SLyawmode:get() == 2)
        ui.SLyawaddright:set_visible(ui.SLyawmode:get() == 2)
        ui.Cyawadd:set_visible(ui.Cyawmode:get() == 1)
        ui.Cyawaddleft:set_visible(ui.Cyawmode:get() == 2)
        ui.Cyawaddright:set_visible(ui.Cyawmode:get() == 2)
        ui.Ayawadd:set_visible(ui.Ayawmode:get() == 1)
        ui.Ayawaddleft:set_visible(ui.Ayawmode:get() == 2)
        ui.Ayawaddright:set_visible(ui.Ayawmode:get() == 2)

        ui.Srotaterange:set_visible(ui.Srotate:get())
        ui.Srotatespeed:set_visible(ui.Srotate:get())
        ui.Mrotaterange:set_visible(ui.Mrotate:get())
        ui.Mrotatespeed:set_visible(ui.Mrotate:get())
        ui.SLrotaterange:set_visible(ui.SLrotate:get())
        ui.SLrotatespeed:set_visible(ui.SLrotate:get())
        ui.Crotaterange:set_visible(ui.Crotate:get())
        ui.Crotatespeed:set_visible(ui.Crotate:get())
        ui.Arotaterange:set_visible(ui.Arotate:get())
        ui.Arotatespeed:set_visible(ui.Arotate:get())

        ui.Sbodyleanjitter:set_visible(ui.Sbodyleanmode:get() == 3 or ui.Sbodyleanmode:get() == 4)
        ui.Mbodyleanamount:set_visible(ui.Mbodyleanmode:get() == 2)
        ui.Mbodyleanjitter:set_visible(ui.Mbodyleanmode:get() == 3 or ui.Mbodyleanmode:get() == 4)
        ui.SLbodyleanamount:set_visible(ui.SLbodyleanmode:get() == 2)
        ui.SLbodyleanjitter:set_visible(ui.SLbodyleanmode:get() == 3 or ui.SLbodyleanmode:get() == 4)
        ui.Cbodyleanamount:set_visible(ui.Cbodyleanmode:get() == 2)
        ui.Cbodyleanjitter:set_visible(ui.Cbodyleanmode:get() == 3 or ui.Cbodyleanmode:get() == 4)
        ui.Abodyleanamount:set_visible(ui.Abodyleanmode:get() == 2)
        ui.Abodyleanjitter:set_visible(ui.Abodyleanmode:get() == 3 or ui.Abodyleanmode:get() == 4)

        ui.Sjitteradd:set_visible(ui.Sjittermode:get() == 2 or ui.Sjittermode:get() == 3)
        ui.Mjitteradd:set_visible(ui.Mjittermode:get() == 2 or ui.Mjittermode:get() == 3)
        ui.SLjitteradd:set_visible(ui.SLjittermode:get() == 2 or ui.SLjittermode:get() == 3)
        ui.Cjitteradd:set_visible(ui.Cjittermode:get() == 2 or ui.Cjittermode:get() == 3)
        ui.Ajitteradd:set_visible(ui.Ajittermode:get() == 2 or ui.Ajittermode:get() == 3)
        ui.Sjittertype:set_visible(ui.Sjittermode:get() == 2 or ui.Sjittermode:get() == 3)
        ui.Mjittertype:set_visible(ui.Mjittermode:get() == 2 or ui.Mjittermode:get() == 3)
        ui.SLjittertype:set_visible(ui.SLjittermode:get() == 2 or ui.SLjittermode:get() == 3)
        ui.Cjittertype:set_visible(ui.Cjittermode:get() == 2 or ui.Cjittermode:get() == 3)
        ui.Ajittertype:set_visible(ui.Ajittermode:get() == 2 or ui.Ajittermode:get() == 3)

        ui.Sfake_limit_left:set_visible(ui.SD_side:get() == 2 or ui.SD_side:get() == 3 or ui.SD_side:get() == 4 or ui.SD_side:get() == 5 or ui.SD_side:get() == 6)
        ui.Sfake_limit_right:set_visible(ui.SD_side:get() == 2 or ui.SD_side:get() == 3 or ui.SD_side:get() == 4 or ui.SD_side:get() == 5 or ui.SD_side:get() == 6)
        ui.Mfake_limit_left:set_visible(ui.MD_side:get() == 2 or ui.MD_side:get() == 3 or ui.MD_side:get() == 4 or ui.MD_side:get() == 5 or ui.MD_side:get() == 6)
        ui.Mfake_limit_right:set_visible(ui.MD_side:get() == 2 or ui.MD_side:get() == 3 or ui.MD_side:get() == 4 or ui.MD_side:get() == 5 or ui.MD_side:get() == 6)
        ui.SLfake_limit_left:set_visible(ui.SLD_side:get() == 2 or ui.SLD_side:get() == 3 or ui.SLD_side:get() == 4 or ui.SLD_side:get() == 5 or ui.SLD_side:get() == 6)
        ui.SLfake_limit_right:set_visible(ui.SLD_side:get() == 2 or ui.SLD_side:get() == 3 or ui.SLD_side:get() == 4 or ui.SLD_side:get() == 5 or ui.SLD_side:get() == 6)
        ui.Cfake_limit_left:set_visible(ui.CD_side:get() == 2 or ui.CD_side:get() == 3 or ui.CD_side:get() == 4 or ui.CD_side:get() == 5 or ui.CD_side:get() == 6)
        ui.Cfake_limit_right:set_visible(ui.CD_side:get() == 2 or ui.CD_side:get() == 3 or ui.CD_side:get() == 4 or ui.CD_side:get() == 5 or ui.CD_side:get() == 6)
        ui.Afake_limit_left:set_visible(ui.AD_side:get() == 2 or ui.AD_side:get() == 3 or ui.AD_side:get() == 4 or ui.AD_side:get() == 5 or ui.AD_side:get() == 6)
        ui.Afake_limit_right:set_visible(ui.AD_side:get() == 2 or ui.AD_side:get() == 3 or ui.AD_side:get() == 4 or ui.AD_side:get() == 5 or ui.AD_side:get() == 6)


        ui.indicatorsmain:set_visible(true)
        if menu_val == 2 then
            antia = true
            ui.selection_condition:set_visible(false)
            if selection_presets == 5 then
                ui.selection_condition:set_visible(true)
               
                if  menu_conditiom == 1 then
                    menu.set_group_column("fart.lua - Anti-Aim Standing", 1)
                    menu.set_group_visibility("fart.lua - Anti-Aim Standing", true)
                    menu.set_group_visibility("fart.lua - Anti-Aim Moving", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Slowwalk", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Crouch", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Air", false)

                   
                elseif  menu_conditiom == 2 then
                    menu.set_group_column("fart.lua - Anti-Aim Moving", 1)
                    menu.set_group_visibility("fart.lua - Anti-Aim Standing", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Moving", true)
                    menu.set_group_visibility("fart.lua - Anti-Aim Slowwalk", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Crouch", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Air", false)

               
                elseif  menu_conditiom == 3 then
                    menu.set_group_column("fart.lua - Anti-Aim Slowwalk", 1)
                    menu.set_group_visibility("fart.lua - Anti-Aim Standing", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Moving", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Slowwalk", true)
                    menu.set_group_visibility("fart.lua - Anti-Aim Crouch", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Air", false)

                   
                elseif  menu_conditiom == 4 then
                    menu.set_group_column("fart.lua - Anti-Aim Crouch", 1)
                    menu.set_group_visibility("fart.lua - Anti-Aim Standing", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Moving", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Slowwalk", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Crouch", true)
                    menu.set_group_visibility("fart.lua - Anti-Aim Air", false)

                   
                elseif  menu_conditiom == 5 then
                    menu.set_group_column("fart.lua - Anti-Aim Air", 1)
                    menu.set_group_visibility("fart.lua - Anti-Aim Standing", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Moving", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Slowwalk", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Crouch", false)
                    menu.set_group_visibility("fart.lua - Anti-Aim Air", true)
             
                  end  
            else
                menu.set_group_visibility("fart.lua - Anti-Aim Standing", false)
                menu.set_group_visibility("fart.lua - Anti-Aim Moving", false)
                menu.set_group_visibility("fart.lua - Anti-Aim Slowwalk", false)
                menu.set_group_visibility("fart.lua - Anti-Aim Crouch", false)
                menu.set_group_visibility("fart.lua - Anti-Aim Air", false)
                ui.selection_condition:set_visible(false)
       
            end
          menu.set_group_visibility("fart.lua - Anti-Aim", true)
          menu.set_group_visibility("fart.lua - Visuals", false)
          menu.set_group_visibility("fart.lua - Misc", false)
          menu.set_group_visibility("fart.lua - Ragebot", false)
          menu.set_group_visibility("fart.lua - Hiddent", false)
          menu.set_group_column("fart.lua - Anti-Aim", 2)
         
        elseif menu_val == 3 then
            menu.set_group_visibility("fart.lua - Anti-Aim Standing", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Moving", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Slowwalk", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Crouch", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Air", false)
           
   
            menu.set_group_visibility("fart.lua - Anti-Aim", false)
            menu.set_group_visibility("fart.lua - Visuals", true)
            menu.set_group_visibility("fart.lua - Misc", false)
            menu.set_group_visibility("fart.lua - Ragebot", false)
            menu.set_group_visibility("fart.lua - Hiddent", false)
            menu.set_group_column("fart.lua - Visuals", 1)
   
        elseif menu_val == 4 then
            menu.set_group_visibility("fart.lua - Anti-Aim Standing", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Moving", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Slowwalk", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Crouch", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Air", false)
           
            menu.set_group_visibility("fart.lua - Anti-Aim", false)
            menu.set_group_visibility("fart.lua - Visuals", false)
            menu.set_group_visibility("fart.lua - Misc", true)
            menu.set_group_visibility("fart.lua - Ragebot", false)
            menu.set_group_visibility("fart.lua - Hiddent", false)
            menu.set_group_column("fart.lua - Misc", 1)
        
        elseif menu_val == 1 then
            menu.set_group_visibility("fart.lua - Anti-Aim Standing", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Moving", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Slowwalk", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Crouch", false)
            menu.set_group_visibility("fart.lua - Anti-Aim Air", false)
           
            menu.set_group_visibility("fart.lua - Anti-Aim", false)
            menu.set_group_visibility("fart.lua - Visuals", false)
            menu.set_group_visibility("fart.lua - Misc", false)
            menu.set_group_visibility("fart.lua - Ragebot", true)
            menu.set_group_visibility("fart.lua - Hiddent", false)
            menu.set_group_column("fart.lua - Ragebot", 1)
        end
    else
    --  checkbox:set_visible(false)
    --  text_eu:set_visible(false)
      menu.set_group_visibility("fart.lua - Anti-Aim Standing", false)
      menu.set_group_visibility("fart.lua - Anti-Aim Moving", false)
      menu.set_group_visibility("fart.lua - Anti-Aim Slowwalk", false)
      menu.set_group_visibility("fart.lua - Anti-Aim Crouch", false)
      menu.set_group_visibility("fart.lua - Anti-Aim Air", false)
     
      menu.set_group_visibility("fart.lua - Hiddent", false)
      menu.set_group_visibility("fart.lua - Ragebot", false)
      menu.set_group_visibility("fart.lua - Anti-Aim", false)
      menu.set_group_visibility("fart.lua - Information", false)
      menu.set_group_visibility("fart.lua - Visuals", false)
      menu.set_group_visibility("fart.lua - Misc", false)
  end
end

--------------- end of menu and tabs

local function on_draw_watermark(watermark_text)
    draw_menu()

    return ""
end

  callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)
  callbacks.add(e_callbacks.PAINT, on_paint)
  callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
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

     --------------------------- start of menu header

 local color =  color_acc:get()
 local font = render.create_font("verdana", 15, 20,e_font_flags.OUTLINE)
 local pixel = render.create_font("Smallest Pixel-7", 11, 20)

 local function on_paint()

  if menu.is_open() then
 
    local function clamp(cur, min, max)
        if cur == nil or min == nil or max == nil then
            return nil
        end
        if min > max then
            return nil
        end
        if cur < min then
            return min
        end
        if cur > max then
            return max
        end
    
        return cur
    end
    
    local function math_clamp(val, low, high)
        if val <= low then
            return low
        end
    
        if val >= high then
            return high
        end
    
        return val
    end


     local pos = menu.get_pos()
     local size = menu.get_size()
     pos = pos - vec2_t(150, 2)
     local width = render.get_screen_size().x
     local height = render.get_screen_size().y
     local dpi_scale = vec2_t(math_clamp(width, 1920, 0.5, 4) / 1920, math_clamp(height, 1080, 0.5, 4) / 1080)
     color = color_acc()
 
      render.rect_filled(vec2_t(menu.get_pos().x * dpi_scale.x, (menu.get_pos().y - 30) * dpi_scale.y), vec2_t(menu.get_size().x * dpi_scale.x, 20 * dpi_scale.y), color_t(30,30,30,180), 8, 5)
      render.rect(vec2_t(menu.get_pos().x * dpi_scale.x, (menu.get_pos().y - 30) * dpi_scale.y), vec2_t(menu.get_size().x * dpi_scale.x, 20 * dpi_scale.y), color, 5, 5)

      render.text(font,"Welcome " .. user.name .. " [" .. user.uid .. "]  -  fart.lua  -  Build: ".. build .. "  -  Build Version: 1.0  -  Latest Update:  9/3/2022", pos + vec2_t(200,-25), color_t(255,255,255,255), 15, true)
 end
end
 
 callbacks.add(e_callbacks.PAINT, on_paint)
    
   --------------------------- end of menu header

   --------------------------- start of misc

   local clientside_animations = {}

   clientside_animations.ground_tick = 1
   clientside_animations.end_time = 0
   clientside_animations.handle = function (poseparam)
       local localPlayer = entity_list.get_local_player()
   
       if not localPlayer then
           return
       end
   
       local sexgod = localPlayer:get_prop("m_vecVelocity[1]") ~= 0 
       local flags = localPlayer:get_prop("m_fFlags")
       local on_land = bit.band(flags, bit.lshift(1, 0)) ~= 0
       local is_in_air = bit.band(flags, bit.lshift(1, 0)) == 0
   
       local curtime = global_vars.cur_time()
   
       if on_land == true then
           clientside_animations.ground_tick = clientside_animations.ground_tick + 1
       else
           clientside_animations.ground_tick = 0
           clientside_animations.end_time = curtime + 1
       end
   
   
       if ui.clientside_animations:get(1) then
           poseparam:set_render_pose(e_poses.RUN, 1)
       end
   
       if ui.clientside_animations:get(2) and is_in_air then
           poseparam:set_render_pose(e_poses.JUMP_FALL, 1)
       end
   
       if ui.clientside_animations:get(4) and clientside_animations.ground_tick > 1 and clientside_animations.end_time > curtime then
           poseparam:set_render_pose(e_poses.BODY_PITCH, 0.5)
       end
   
       if ui.clientside_animations:get(3) and is_in_air then
           if sexgod then
               poseparam:set_render_animlayer(e_animlayers.LEAN, 1)
           end
       end
   end
   
   callbacks.add(e_callbacks.ANTIAIM, clientside_animations.handle)

local fn_change_clantag = memory.find_pattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15") or error("Cannot get fn_change_clantag")
local set_clantag = ffi.cast("int(__fastcall*)(const char*, const char*)", fn_change_clantag) or error("Cannot get set_clantag")
local old_time = 0;
local clantagset = 0;
local primtag = menu.find("misc", "utility", "general", "clantag");
local animation = {
    "⌛",
    "⌛",
    "⌛ f",
    "⌛ fa",
    "⌛ far",
    "⌛ fart",
    "⌛ fart.",
    "⌛ fart.l",
    "⌛ fart.lu",
    "⌛ fart.lua", 
    "⌛ fart.lua", 
    "⌛ fart.lua", 
    "⌛ fart.lua", 
    "⌛ fart.lua", 
    "⌛ fart.lua", 
    "⌛ fart.lu",
    "⌛ fart.l",
    "⌛ fart.",
    "⌛ fart",
    "⌛ far",
    "⌛ fa",
    "⌛ f",
    "⌛",
    "⌛",
}

local primTag = function()
    if ui.clantag:get() then
        local curtime = math.floor(global_vars.cur_time() * 1.675);
        if old_time ~= curtime then
            set_clantag(animation[curtime % #animation+1], animation[curtime % #animation+1]);
        end
        old_time = curtime;
        clantagset = 1;
        primtag:set(false);
    else
        if clantagset == 1 then
            clantagset = 0;
            set_clantag("", "");
        end
    end
end

    callbacks.add(e_callbacks.PAINT, function()
        primTag()
    end)
    
    callbacks.add(e_callbacks.SHUTDOWN, function()
        set_clantag("", "");
    end)

local get_phrase = function()
    local phrases = {"fart.lua makes me luck boosted", "You wish you had fart.lua", "1'd by fart.lua", "fart.lua > other pasted scripts", "fart.lua better", "hear that? sounds like copium", "timehacked back to narnia", "this luas too stinky for you", "get farted on", "get 1'd by the fart gods", "FART ATTACK"}
    if #phrases == 0 then return "" end

    return phrases[client.random_int(0, #phrases)]
end

local last_chat_time = 0
local on_player_death = function(event)
    if not ui.killsay:get() then return end

    local userid, attackerid = event.userid, event.attacker
    if not userid or not attackerid then return end

    local victim, attacker, local_player = entity_list.get_player_from_userid(userid), entity_list.get_player_from_userid(attackerid), entity_list.get_local_player()
    if not victim or not attacker or not local_player then return end

    if attacker == local_player and victim ~= local_player then
        if game_rules.get_prop("m_bIsValveDS") and (last_chat_time > global_vars.cur_time() + 0.3) then
            return 
        end

        local phrase = get_phrase()
        if phrase == '' then return end

        engine.execute_cmd(('say "%s"'):format(phrase) )
    end
end

callbacks.add(e_callbacks.EVENT, on_player_death, "player_death")

local function on_paint1()

local presetsc = ui.selection_presets:get()

local Mainangles = menu.find("antiaim","main","angles","yaw add")
local Mainangles2 = menu.find("antiaim","main","angles","jitter mode")
local Mainangles3 = menu.find("antiaim","main","angles","jitter type")
local Mainangles4 = menu.find("antiaim","main","angles","jitter add")
local Mainangles5 = menu.find("antiaim","main", "desync","side#stand")
local Mainangles6 = menu.find("antiaim","main","desync","left amount#stand")
local Mainangles7 = menu.find("antiaim","main","desync","right amount#stand")
local Mainangles8 = menu.find("antiaim","main","desync","anti bruteforce")
local Mainangles9 = menu.find("antiaim","main","angles","yaw base")
local Mainangles10 = menu.find("antiaim","main","angles","body lean")
local Mainangles11 = menu.find("antiaim","main","angles","rotate")
local Mainangles12 = menu.find("antiaim","main","desync","on shot")


if presetsc == 2 or presetsc == 3 or presetsc == 4 and menu.is_open() then 
    Mainangles:set_visible(false)
    Mainangles2:set_visible(false)
    Mainangles3:set_visible(false)
    Mainangles4:set_visible(false)
    Mainangles5:set_visible(false)
    Mainangles6:set_visible(false)
    Mainangles7:set_visible(false)
    Mainangles8:set_visible(false)
    Mainangles9:set_visible(false)
    Mainangles10:set_visible(false)
    Mainangles11:set_visible(false)
    Mainangles12:set_visible(false)
else 
    Mainangles:set_visible(true)
    Mainangles2:set_visible(true)
    Mainangles3:set_visible(true)
    Mainangles4:set_visible(true)
    Mainangles5:set_visible(true)
    Mainangles6:set_visible(true)
    Mainangles7:set_visible(true)
    Mainangles8:set_visible(true)
    Mainangles9:set_visible(true)
    Mainangles10:set_visible(true)
    Mainangles11:set_visible(true)
    Mainangles12:set_visible(true)
end
end

callbacks.add(e_callbacks.PAINT, on_paint1)