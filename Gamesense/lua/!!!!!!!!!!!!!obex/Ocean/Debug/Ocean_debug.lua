-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server




--Requirements
local ffi = require("ffi")
local vector = require("vector")
local csgo_weapon = require("gamesense/csgo_weapons")
local engineclient = require("gamesense/engineclient")
local http = require("gamesense/http")
--local pui = require("gamesense/pui")

--Menu elements
local AntiAim_tab = {
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
    pitch_val = select(2, ui.reference("AA", "Anti-aimbot angles", "Pitch")),
    yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = ui.reference("AA", "Anti-aimbot angles", "Yaw"),
    yaw_val = select(2, ui.reference("AA", "Anti-aimbot angles", "Yaw")),
    jitter = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter"),
    jitter_val = select(2, ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")),
    body = ui.reference("AA", "Anti-aimbot angles", "Body yaw"),
    body_val = select(2, ui.reference("AA", "Anti-aimbot angles", "Body yaw")),
    freestand_body = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = ui.reference("AA", "Anti-aimbot angles", "Freestanding"),
    freestanding_key = select(2, ui.reference("AA", "Anti-aimbot angles", "Freestanding")),
    roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
    fake_peek1 = select(1, ui.reference("AA", "Other", "Fake peek")),
    fake_peek2 = select(2, ui.reference("AA", "Other", "Fake peek")),
    featuress = ui.reference("VISUALS", "Other esp", "Feature indicators"),

}

local refs = {
    slow = {ui.reference("AA", "Other", "Slow motion")},
    body = ui.reference("AA", "Anti-aimbot angles", "Body yaw"),
    roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
    enabled = {ui.reference("RAGE", "Aimbot", "Enabled")},
    is_qp = {ui.reference("RAGE", "Other", "Quick peek assist")},
    body_yaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    fov = ui.reference("RAGE", "Other", "Maximum FOV"),
    auto_fire = ui.reference("RAGE", "Other", "Automatic fire"),
    auto_pen = ui.reference("RAGE", "Other", "Automatic penetration"),
    duck = ui.reference("RAGE", "Other", "Duck peek assist"),
    FBaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    FSPoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
    MinDmg =  ui.reference( "RAGE" , "Aimbot" , "Minimum damage" ),
    ovr =  {ui.reference( "RAGE" , "Aimbot" , "Minimum damage override" )},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    Def_feature = ui.reference("VISUALS", "Other esp", "Feature indicators"),
    remove_scope = ui.reference("VISUALS", "Effects", "Remove scope overlay"),
    scope_zoom = ui.reference("MISC", "Miscellaneous", "Override zoom FOV"),
    thirdperson = {ui.reference("VISUALS", "Effects", "Force third person (alive)")},
    thirdperson_dead = ui.reference("VISUALS", "Effects", "Force third person (dead)"),
    nameSteal = ui.reference("Misc", "Miscellaneous", "Steal player name"),
    Players = ui.reference("PLAYERS", "Players", "Player list"),
    ApplyToAll = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
    ResetAll = ui.reference("PLAYERS", "Players", "Reset all"),
    ForceBodyYaw = ui.reference("PLAYERS", "Adjustments", "Force body yaw"),
    ForceSlider = ui.reference("PLAYERS", "Adjustments", "Force body yaw value"),
    GSColor = ui.reference("Misc", "Settings", "Menu color"),
    Untrusted = ui.reference("Misc", "Settings", "Anti-untrusted"),
    Ping = {ui.reference("Misc", "Miscellaneous", "Ping spike")},
    FL_Check = {ui.reference("AA", "Fake lag", "Enabled")},
    FL_Check1 = ui.reference("AA", "Fake lag", "Enabled"),
    FL_Check2 = select(2, ui.reference("AA", "Fake lag", "Enabled")),
    FL_Amount = ui.reference("AA", "Fake lag", "Amount"),
    FL_Variance = ui.reference("AA", "Fake lag", "Variance"),
    FL_Limit = ui.reference("AA", "Fake lag", "Limit"),
    SW_Check1 = ui.reference("AA", "Other", "Slow motion"),
    SW_Check2 = select(2, ui.reference("AA", "Other", "Slow motion")),
    Leg_mvt = ui.reference("AA", "Other", "Leg movement"),
    OS_Check = {ui.reference("AA", "Other", "On shot anti-aim")},
    OS_Check1 = ui.reference("AA", "Other", "On shot anti-aim"),
    OS_Check2 = select(2, ui.reference("AA", "Other", "On shot anti-aim")),
    Gs_Tag = ui.reference("MISC", "Miscellaneous", "Clan tag spammer"),
}
-- FFI Chat Print STUFF
local ffi = require("ffi")
ffi.cdef[[
typedef void***(__thiscall* FindHudElement_t)(void*, const char*);
typedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...);
]]

local signature_gHud = "\xB9\xCC\xCC\xCC\xCC\x88\x46\x09"
local signature_FindElement = "\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28"

local match = client.find_signature("client_panorama.dll", signature_gHud) or error("sig1 not found")
local hud = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("hud is nil")

match = client.find_signature("client_panorama.dll", signature_FindElement) or error("FindHudElement not found")
local find_hud_element = ffi.cast("FindHudElement_t", match)
local hudchat = find_hud_element(hud, "CHudChat") or error("CHudChat not found")

local chudchat_vtbl = hudchat[0] or error("CHudChat instance vtable is nil")
local print_to_chat = ffi.cast("ChatPrintf_t", chudchat_vtbl[27])

local function print_chat(text)
    print_to_chat(hudchat, 0, 0, text)
end

local libary = {}
libary.pi = 3.14159265358979323846

libary.d2r =  function(value)
    return value * (libary.pi / 180)
end

libary.vectorangle = function(x,y,z)
    local fwd_x, fwd_y, fwd_z
    local sp, sy, cp, cy

    sy = math.sin(libary.d2r(y))
    cy = math.cos(libary.d2r(y))
    sp = math.sin(libary.d2r(x))
    cp = math.cos(libary.d2r(x))
    fwd_x = cp * cy
    fwd_y = cp * sy
    fwd_z = -sp
    return fwd_x, fwd_y, fwd_z
end


libary.multiplyvalues = function(x,y,z,val)
    x = x * val y = y * val z = z * val
    return x, y, z
end

function containsSymbol(str, symbol)
    local symbolBytes = {symbol:byte(1, -1)}
    local symbolLength = #symbolBytes

    for i = 1, #str do
        local char = str:byte(i, i + symbolLength - 1)
        if char == symbolBytes[1] then
            local match = true
            for j = 2, symbolLength do
                if str:byte(i + j - 1) ~= symbolBytes[j] then
                    match = false
                    break
                end
            end
            if match then
                return true
            end
        end
    end

    return false
end

local function indicator_circle(x, y, r, g, b, a, percentage, outline)
    local outline = outline or true
    local start_degrees, radius = 0, 9

    if outline then
        renderer.circle_outline(x, y, 0, 0, 0, 200, radius, start_degrees, 1.0, 5)
    end
    renderer.circle_outline(x, y, r, g, b, a, radius-1, start_degrees, percentage, 3)
end

local lua_log = function(...) 
    r, g, b = ui.get(refs.GSColor)
    client.color_log(255, 255, 255, "[\0")
    client.color_log(0, 157, 196, "Ocean\0")
    client.color_log(255, 255, 255, ".log]\0")
    local arg_index = 1
    while select(arg_index, ...) ~= nil do
        client.color_log(217, 217, 217, " ", select(arg_index, ...), "\0")
        arg_index = arg_index + 1
    end
    client.color_log(217, 217, 217, " ")
end

local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
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

local function lerp(_, a, b, t)
    return a + (b - a) * t
end

local function Clamp(Value, Min, Max)
    return Value < Min and Min or (Value > Max and Max or Value)
end


local function setName(delay, name)
    client.delay_call(delay, function() 
        client.set_cvar("name", name)
    end)
end


local ent_state = {
    speed = function(ent) local speed = math.sqrt(math.pow(entity.get_prop(ent, "m_vecVelocity[0]"), 2) + math.pow(entity.get_prop(ent, "m_vecVelocity[1]"), 2)) return speed end,
    is_peeking = function() return (ui.get(refs.is_qp[1]) and ui.get(refs.is_qp[2])) end,
    is_ladder = function(ent) return (entity.get_prop(ent, "m_MoveType") or 0) == 9 end
}

local is_mm_state = 0
local game_rule = ffi.cast("intptr_t**", ffi.cast("intptr_t", client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")) + 2)[0]

local table_contains = function(tbl, value)
    for i = 1, #tbl do
        if tbl[i] == value then
            return true
        end
    end
    return false
end

local hitbox_e =
{
	head = 0,
	pelvis = 2,
	body = 3,
	thorax = 4,
	chest = 5,
	left_thigh = 7,
	right_thigh = 8,
	left_foot = 11,
	right_foot = 12,
	left_hand = 13,
	right_hand = 14,
	left_upper_arm = 15,
	left_forearm = 16,
	right_upper_arm = 17,
	right_forearm = 18
}

local DYNAMIC_FOV_DISTANCE_SCALE = 4000.0
local DYNAMIC_FOV_UPDATE_INTERVAL = 4 
local DYNAMIC_FOV_MIN_DISTANCE = 1500.0
local DYNAMIC_FOV_MAX_DISTANCE = 100.0
local SMOKE_HITBOXES = { hitbox_e.head, hitbox_e.left_foot, hitbox_e.right_foot, hitbox_e.left_hand, hitbox_e.right_hand }
local SMOKE_PERSISTANCE_TIMER = 17.0
local g_anUserWhitelisted = {}
local VISIBILITY_SCALE = 30.0
local VISIBILITY_DIRECTIONS =
{
	{ 0.0, 0.0 },
	{ VISIBILITY_SCALE, 0.0 },
	{ -VISIBILITY_SCALE, 0.0 },
	{ 0.0, VISIBILITY_SCALE },
	{ 0.0, -VISIBILITY_SCALE }
}
local g_flFlashDurationCache = 0.0
local g_flLastFlashUpdate = 0.0
local g_pfnLineGoesThroughSmoke = ffi.cast(ffi.typeof("bool(__cdecl*)(float flFromX, float flFromY, float flFromZ, float flToX, float flToY, float flToZ)"),
	client.find_signature("client.dll", "\x55\x8B\xEC\x83\xEC\x08\x8B\x15\xCC\xCC\xCC\xCC\x0F") or error("client.dll!::LineGoesThroughSmoke could not be found. Signature is outdated."))
local manual_side = 0
local time = 1
local delay = 1
local timer = 0

local entity_get_prop, entity_get_game_rules = entity.get_prop, entity.get_game_rules

local is_freezetime = function()
    return entity_get_prop(entity_get_game_rules(), "m_bFreezePeriod") == 1
end

local rounds_played = function()
    return entity.get_prop(entity.get_game_rules(), "m_totalRoundsPlayed")
end

local round_time = function()
    return entity.get_prop(entity.get_game_rules(), "m_iRoundTime")
end

local timer_reset = function()
    if is_freezetime() and can_timer==true then
        timer = round_time()
        can_timer = false
    else
        can_timer = true
    end
end

local round_timer = function()
    if globals.curtime() - time >= delay then
		time = globals.curtime()
        timer = timer - 1
	end
    return timer
end

if time - globals.curtime() >= delay then 
    time = globals.curtime()
end

function normalize(slot0)
	while slot0 > 180 do
		slot0 = slot0 - 360
	end

	while slot0 < -180 do
		slot0 = slot0 + 360
	end

	return slot0
end

local function vectorDist(A,B,C)
    local d = (A-B) / A:dist(B)
    local v = C - B
    local t = v:dot(d) 
    local P = B + d:scaled(t)
    
    return P:dist(C)
end

function math.round(number, precision)
	local mult = math.pow(10, (precision or 0))

	return math.floor(number * mult + 0.5) / mult
end
local Players = {}
function checkPlayerStatus(player)
    if(not player) then return end
  
    if (not Players[player] ) then
      Players[player] = { disabled = false, defaultL = 50, defaultR = -50}
    end
end

local function setSpeed(newSpeed)
	if newSpeed == 245 then
		return
	end
	local LocalPlayer = entity.get_local_player()
    local velocity = math.sqrt(math.pow(entity.get_prop(LocalPlayer, "m_vecVelocity[0]"), 2) + math.pow(entity.get_prop(LocalPlayer, "m_vecVelocity[1]"), 2))
	local maxvelo = newSpeed

	if(velocity<maxvelo) then
		client.set_cvar("cl_sidespeed", maxvelo)
		client.set_cvar("cl_forwardspeed", maxvelo)
		client.set_cvar("cl_backspeed", maxvelo)
	end

	if(velocity>=maxvelo) then
		local kat=math.atan2(client.get_cvar("cl_forwardspeed"), client.get_cvar("cl_sidespeed"))
		local forward=math.cos(kat)*maxvelo;
		local side=math.sin(kat)*maxvelo;
		client.set_cvar("cl_sidespeed", side)
		client.set_cvar("cl_forwardspeed", forward)
		client.set_cvar("cl_backspeed", forward)
	end
end

local FallbackName = { }

local clantag = {
    states = {
    "🫷",
    "🫷", 
    "🫷O",
    "🫷Oc", 
    "🫷Oce",
    "🫷Ocea", 
    "🫷Ocean",
    "🫷Ocean.", 
    "🫷Ocean.T",
    "🫷Ocean.Te", 
    "🫷Ocean.Tec",
    "🫷Ocean.Tech", 
    "🫷Ocean.Tech",
    "🫷Ocean.Tech", 
    "🫷Ocean.Tech", 
    "🫷Ocean.Tech",
    "🫷Ocean.Tech", 
    "🫷cean.Tech",
    "🫷ean.Tech", 
    "🫷an.Tech",
    "🫷n.Tech", 
    "🫷.Tech",
    "🫷Tech", 
    "🫷ech",
    "🫷ch", 
    "🫷h",
    "🫷",
    "🫷",
    },
    timer = 0,
    reset = true
}

local clantag1 = {
    states = {
    "",
    "", 
    "O",
    "Oc", 
    "Oce",
    "Ocea", 
    "Ocean",
    "Ocean.", 
    "Ocean.T",
    "Ocean.Te", 
    "Ocean.Tec",
    "Ocean.Tech", 
    "Ocean.Tech",
    "Ocean.Tech", 
    "Ocean.Tech", 
    "Ocean.Tech",
    "Ocean.Tech", 
    "cean.Tech",
    "ean.Tech", 
    "an.Tech",
    "n.Tech", 
    ".Tech",
    "Tech", 
    "ech",
    "ch", 
    "h",
    "",
    "",
    },
    timer = 0,
    reset = true
}


--Menu Build
local Ocean_tab = {
    border_top = ui.new_label("AA", "Anti-aimbot angles", "ㅤㅤㅤㅤㅤ  \aCDCDCDFF[\a009dc4FFOcean\aCDCDCDFF.Tech] ㅤㅤㅤㅤㅤ"),

    --Main
    MasterSwitch = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFOcean\aCDCDCDFF.Tech - \aD6BE73FFMaster switch"),
    TabSelection = ui.new_combobox("AA", "Anti-aimbot angles", "Tab Selection", "Aimbot", "Anti-Aim", "Visuals", "Misc"),
    Spacer = ui.new_label("AA", "Anti-aimbot angles", "ㅤ"),

    --Aimbot
    Aimbot_Enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Enable"),
    Aimbot_Autofire = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Automatic fire"),
    Aimbot_Autofire_hotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Automatic fire", true),
    Aimbot_Autopenetration = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Automatic penetration"),
    Aimbot_Autopenetration_hotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Automatic penetration", true),
    Aimbot_DynamicFOV = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Dynamic FOV"),
    Aimbot_Min_Fov = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Min FOV", 1, 180, 5, true, "°"),
    Aimbot_Max_Fov = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Max FOV", 1, 180, 25, true, "°"),
    Aimbot_Prio_System = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Ragebot priority system"),
    Aimbot_Prio_System_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Ragebot priority system", 255, 219, 127, 225),
    Aimbot_Disablers_checkbox = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Ragebot Disablers"),
    Aimbot_Disablers = ui.new_multiselect("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Ragebot Disablers", "Through Smoke", "While Flashed"),
    Aimbot_Roll_Enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Custom Resolver [\aD6BE73FFWIP Feature\aCDCDCDFF]"),
    Aimbot_Roll_Overrides = ui.new_multiselect("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Overrides", "Force Override Desync", "Force Override Roll"),
    Aimbot_Roll_Override_L = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Roll Override Left", -90, 90, 50, true, "°"),
    Aimbot_Roll_Override_R = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Roll Override Right", -90, 90, -50, true, "°"),
    Aimbot_Roll_Resolver_Modes = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Resolver Modes", "Auto", "Bruteforce", "Manual"),
    Aimbot_Roll_Inverter = ui.new_hotkey("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Manual Resolver Override", false),
    Aimbot_Roll_Untrusted_Pitch = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Resolve HalfPitch"),
    Aimbot_Roll_Untrusted_Pitch_Value = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAimbot\aCDCDCDFF - Resolve HalfPitch Angle", -89, 89, 45, true, "°"),



    --AntiAim
    AntiAim_Enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Enable"),
    AntiAim_Inverter = ui.new_hotkey("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Inverter"),
    AntiAim_Freestand = ui.new_hotkey("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Freestanding"),
    AntiAim_AtTarget = ui.new_hotkey("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - At Target"),
    AntiAim_PitchKey = ui.new_hotkey("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Pitch on Key"),
    AntiAim_HalfPitchKey = ui.new_hotkey("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Half Pitch on Key"),
    AntiAim_Extras = ui.new_multiselect("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Extras", "Lower Body Yaw", "Roll", "Freestanding", "Yaw: At Targets", "Pitch-Down (\aD6BE73FFUnsafe\aCDCDCDFF)", "Half-Pitch (\aD6BE73FFUnsafe\aCDCDCDFF and \aD6BE73FFGay\aCDCDCDFF)"),
    AntiAim_Disablers = ui.new_multiselect("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Anti-Aim Disablers", "While Fakeduck", "Tabbed Out", "Low FPS"),
    AntiAim_States = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - States", "Stand", "Duck", "Move", "Slowwalk", "In-Air"),
    --Stand
    AntiAim_Stand_BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw[\a009dc4FFStand\aCDCDCDFF]", "Freestand", "Opposite", "Jitter"),
    AntiAim_Stand_Open = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw - Vis[\a009dc4FFStand\aCDCDCDFF]", "Opposite", "Jitter"),
    AntiAim_Stand_Reverse = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Reverse Freestanding[\a009dc4FFStand\aCDCDCDFF]"),
    AntiAim_Stand_Brute = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Anti-Bruteforce[\a009dc4FFStand\aCDCDCDFF]"),
    AntiAim_Stand_Roll = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll[\a009dc4FFStand\aCDCDCDFF]"),
    AntiAim_Stand_Roll_L = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Left[\a009dc4FFStand\aCDCDCDFF]", -45, 45, 0),
    AntiAim_Stand_Roll_R = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Right[\a009dc4FFStand\aCDCDCDFF]", -45, 45, 0),
    AntiAim_Stand_Untrusted_L = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Left[\a009dc4FFStand\aCDCDCDFF]", -75, 75, 0),
    AntiAim_Stand_Untrusted_R = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Right[\a009dc4FFStand\aCDCDCDFF]", -75, 75, 0),

    --Duck
    AntiAim_Duck_BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw[\a009dc4FFDuck\aCDCDCDFF]", "Freestand", "Opposite", "Jitter"),
    AntiAim_Duck_Open = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw - Vis[\a009dc4FFDuck\aCDCDCDFF]", "Opposite", "Jitter"),
    AntiAim_Duck_Reverse = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Reverse Freestanding[\a009dc4FFDuck\aCDCDCDFF]"),
    AntiAim_Duck_Brute = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Anti-Bruteforce[\a009dc4FFDuck\aCDCDCDFF]"),
    AntiAim_Duck_Roll = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll[\a009dc4FFDuck\aCDCDCDFF]"),
    AntiAim_Duck_Roll_L = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Left[\a009dc4FFDuck\aCDCDCDFF]", -45, 45, 0),
    AntiAim_Duck_Roll_R = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Right[\a009dc4FFDuck\aCDCDCDFF]", -45, 45, 0),
    AntiAim_Duck_Untrusted_L = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Left[\a009dc4FFDuck\aCDCDCDFF]", -75, 75, 0),
    AntiAim_Duck_Untrusted_R = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Right[\a009dc4FFDuck\aCDCDCDFF]", -75, 75, 0),
    --Move
    AntiAim_Move_BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw[\a009dc4FFMove\aCDCDCDFF]", "Freestand", "Opposite", "Jitter"),
    AntiAim_Move_Open = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw - Vis[\a009dc4FFMove\aCDCDCDFF]", "Opposite", "Jitter"),
    AntiAim_Move_Reverse = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Reverse Freestanding[\a009dc4FFMove\aCDCDCDFF]"),
    AntiAim_Move_Brute = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Anti-Bruteforce[\a009dc4FFMove\aCDCDCDFF]"),
    AntiAim_Move_Roll = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll[\a009dc4FFMove\aCDCDCDFF]"),
    AntiAim_Move_Roll_L = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Left[\a009dc4FFMove\aCDCDCDFF]", -45, 45, 0),
    AntiAim_Move_Roll_R = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Right[\a009dc4FFMove\aCDCDCDFF]", -45, 45, 0),
    AntiAim_Move_Untrusted_L = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Left[\a009dc4FFMove\aCDCDCDFF]", -75, 75, 0),
    AntiAim_Move_Untrusted_R = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Right[\a009dc4FFMove\aCDCDCDFF]", -75, 75, 0),
    --Slowwalk
    AntiAim_Slowwalk_BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw[\a009dc4FFSlowwalk\aCDCDCDFF]", "Freestand", "Opposite", "Jitter"),
    AntiAim_Slowwalk_Open = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw - Vis[\a009dc4FFSlowwalk\aCDCDCDFF]", "Opposite", "Jitter"),
    AntiAim_Slowwalk_Reverse = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Reverse Freestanding[\a009dc4FFSlowwalk\aCDCDCDFF]"),
    AntiAim_Slowwalk_Brute = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Anti-Bruteforce[\a009dc4FFSlowwalk\aCDCDCDFF]"),
    AntiAim_Slowwalk_Roll = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll[\a009dc4FFSlowwalk\aCDCDCDFF]"),
    AntiAim_Slowwalk_Roll_L = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Left[\a009dc4FFSlowwalk\aCDCDCDFF]", -45, 45, 0),
    AntiAim_Slowwalk_Roll_R = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Right[\a009dc4FFSlowwalk\aCDCDCDFF]", -45, 45, 0),
    AntiAim_Slowwalk_Untrusted_L = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Left[\a009dc4FFSlowwalk\aCDCDCDFF]", -180, 180, 0),
    AntiAim_Slowwalk_Untrusted_R = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Right[\a009dc4FFSlowwalk\aCDCDCDFF]", -180, 180, 0),
    AntiAim_Slowwalk_Speed = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Custom Slowwalk[\a009dc4FFSlowwalk\aCDCDCDFF]"),
    AntiAim_Slowwalk_Speed_Value = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Custom Slowwalk Speed", 0, 100, 50, true, "%"),
    --In-Air
    AntiAim_In_Air_BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw[\a009dc4FFIn-Air\aCDCDCDFF]", "Freestand", "Opposite", "Jitter"),
    AntiAim_In_Air_Open = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw - Vis[\a009dc4FFIn-Air\aCDCDCDFF]", "Opposite", "Jitter"),
    AntiAim_In_Air_Reverse = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Reverse Freestanding[\a009dc4FFStand\aCDCDCDFF]"),
    AntiAim_In_Air_Brute = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Anti-Bruteforce[\a009dc4FFIn-Air\aCDCDCDFF]"),
    AntiAim_In_Air_Roll = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll[\a009dc4FFIn-Air\aCDCDCDFF]"),
    AntiAim_In_Air_Roll_L = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Left[\a009dc4FFIn-Air\aCDCDCDFF]", -45, 45, 0),
    AntiAim_In_Air_Roll_R = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Right[\a009dc4FFIn-Air\aCDCDCDFF]", -45, 45, 0),
    AntiAim_In_Air_Untrusted_L = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Left[\a009dc4FFIn-Air\aCDCDCDFF]", -75, 75, 0),
    AntiAim_In_Air_Untrusted_R = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Right[\a009dc4FFIn-Air\aCDCDCDFF]", -75, 75, 0),

    --Fakelag
    FL_Enable = ui.new_checkbox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Enabled"),
    FL_Key = ui.new_hotkey("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Enabled", true),
    FL_Restrict = ui.new_checkbox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Restrict Fake-lag on R8"),
    FL_State = ui.new_combobox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - States", "Global", "Stand", "Duck", "Move", "Slowwalk", "In-Air"),

    --Global
    FL_Global_Amount = ui.new_combobox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Amount [\a009dc4FFGlobal\aCDCDCDFF]", "Dynamic", "Maximum", "Fluctuate"),
    FL_Global_Variance = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Variance [\a009dc4FFGlobal\aCDCDCDFF]", 0, 100, 0, true, "%"),
    FL_Global_Limit = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Limit [\a009dc4FFGlobal\aCDCDCDFF]", 1, 6, 0),
    --Stand
    FL_Stand_Override = ui.new_checkbox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Override Global [\a009dc4FFStand\aCDCDCDFF]"),
    FL_Stand_Amount = ui.new_combobox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Amount [\a009dc4FFStand\aCDCDCDFF]", "Dynamic", "Maximum", "Fluctuate"),
    FL_Stand_Variance = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Variance [\a009dc4FFStand\aCDCDCDFF]", 0, 100, 0, true, "%"),
    FL_Stand_Limit = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Limit [\a009dc4FFStand\aCDCDCDFF]", 1, 6, 0),
    --Duck
    FL_Duck_Override = ui.new_checkbox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Override Global [\a009dc4FFDuck\aCDCDCDFF]"),
    FL_Duck_Amount = ui.new_combobox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Amount [\a009dc4FFDuck\aCDCDCDFF]", "Dynamic", "Maximum", "Fluctuate"),
    FL_Duck_Variance = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Variance [\a009dc4FFDuck\aCDCDCDFF]", 1, 100, 0, true, "%"),
    FL_Duck_Limit = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Limit [\a009dc4FFDuck\aCDCDCDFF]", 1, 6, 0),
    --Move
    FL_Move_Override = ui.new_checkbox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Override Global [\a009dc4FFMove\aCDCDCDFF]"),
    FL_Move_Amount = ui.new_combobox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Amount [\a009dc4FFMove\aCDCDCDFF]", "Dynamic", "Maximum", "Fluctuate"),
    FL_Move_Variance = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Variance [\a009dc4FFMove\aCDCDCDFF]", 0, 100, 0, true, "%"),
    FL_Move_Limit = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Limit [\a009dc4FFMove\aCDCDCDFF]", 1, 6, 0),
    --Slowwalk
    FL_Slowwalk_Override = ui.new_checkbox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Override Global [\a009dc4FFSlowwalk\aCDCDCDFF]"),
    FL_Slowwalk_Amount = ui.new_combobox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Amount [\a009dc4FFSlowwalk\aCDCDCDFF]", "Dynamic", "Maximum", "Fluctuate"),
    FL_Slowwalk_Variance = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Variance [\a009dc4FFSlowwalk\aCDCDCDFF]", 0, 100, 0, true, "%"),
    FL_Slowwalk_Limit = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Limit [\a009dc4FFSlowwalk\aCDCDCDFF]", 1, 6, 0),
    --In-Air
    FL_In_Air_Override = ui.new_checkbox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Override Global [\a009dc4FFIn-Air\aCDCDCDFF]"),
    FL_In_Air_Amount = ui.new_combobox("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Amount [\a009dc4FFIn-Air\aCDCDCDFF]", "Dynamic", "Maximum", "Fluctuate"),
    FL_In_Air_Variance = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Variance [\a009dc4FFIn-Air\aCDCDCDFF]", 0, 100, 0, true, "%"),
    FL_In_Air_Limit = ui.new_slider("AA", "Fake lag", "\a009dc4FFFake-lag\aCDCDCDFF - Limit [\a009dc4FFIn-Air\aCDCDCDFF]", 1, 6, 0),

    --OtherA5A55C
    Other_Slowwalk = ui.new_checkbox("AA", "Other", "\a009dc4FFOther\aCDCDCDFF - Slow motion"),
    Other_Slowwalk_Key = ui.new_hotkey("AA", "Other", "\a009dc4FFOther\aCDCDCDFF - Slow motion", true),
    Other_Leg_movement = ui.new_combobox("AA", "Other", "\a009dc4FFOther\aCDCDCDFF - Leg movement", "Off", "Always slide", "Never slide", "Leg breaker"),
    Other_Hideshots = ui.new_checkbox("AA", "Other", "\a009dc4FFOther\aCDCDCDFF - \aAFAF5FFFOn shot anti-aim"),
    Other_Hideshots_Key = ui.new_hotkey("AA", "Other", "\a009dc4FFOther\aCDCDCDFF - \aAFAF5FFFOn shot anti-aim", true),

    --Misc
    Misc_Feature = ui.new_multiselect("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Feature Indicator", "Auto Fire","Auto Wall","FOV","Duck peek assist","Force Baim","Force Safepoint","AA","FL","Min. Damage","Ping","Freestand","Yaw: At Targets","Pitch","Half-Pitch","On-Shot","Resolver","State"),
    Misc_Feature_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Feature Indicator", 255, 255, 255, 225),
    Misc_Feature_color2 = ui.new_color_picker("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Feature Indicator ", 124, 195, 13, 255),
    Misc_Custom_Scope = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Custom Scope Settings"),
    Misc_First_Person = ui.new_multiselect("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - First Person Settings", "Remove scope overlay", "Custom Scope Zoom"),
    Misc_First_Person_Zoom = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - First Person Zoom", 0, 100, 100, true, "%"),
    Misc_Third_Person = ui.new_multiselect("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Third Person Settings", "Remove scope overlay", "Custom Scope Zoom"),
    Misc_Third_Person_Zoom = ui.new_slider("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Third Person Zoom", 0, 100, 100, true, "%"),
    Misc_Crosshair_Indicator = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Crosshair Indicator"),
    Misc_Crosshair_Indicator_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Crosshair Indicator", 0, 157, 196, 225),
    Misc_Crosshair_Indicator_color1 = ui.new_color_picker("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Crosshair Indicator1", 255, 255, 255, 225),
    Misc_Crosshair_Indicator_select = ui.new_multiselect("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Crosshair Indicator", "Name", "Ragebot", "Fov", "Safe", "Baim", "Min. Dmg"),
    Misc_Body_Yaw_indicator = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Body yaw Indicator"),
    Misc_Body_Yaw_indicator_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Body yaw Indicator", 255, 255, 255, 225),
    Misc_Body_Yaw_indicator_selections = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Body yaw Indicator Style", "⮜ - ⮞", "◀ - ▶", "◃ - ▹", "— - —"),
    Misc_Body_Yaw_indicator_Desync = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Fake Amount Color"),  
    Misc_Body_Yaw_indicator_Invert = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Invert Body yaw Indicator"),
    Misc_Watermark = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Watermark"),
    Misc_Watermark_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Watermark", 0, 157, 196, 225),
    Misc_Peek_Prediction = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - LynX Hitprediction"),
    Misc_Peek_Prediction_Selection = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Hitprediction Settings", "Hit", "Name", "Name(Health)"),
    Misc_Peek_Prediction_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - LynX Hitprediction", 0, 157, 196, 225),
    Misc_Peek_Prediction_color2 = ui.new_color_picker("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Hitprediction Settings", 0, 157, 196, 225),
    Misc_EventLogs = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFMisc\aCDCDCDFF - Event Logs"),
    Misc_EventLogs_Output = ui.new_multiselect("AA", "Anti-aimbot angles", "\a009dc4FFMisc\aCDCDCDFF - Output Methodes", "Chat", "Console"),
    Misc_Shared_Feature = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFMisc\aCDCDCDFF - Scoreboard Icon"),
    Misc_Untrusted = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFMisc\aCDCDCDFF - Allow \aD6BE73FFUntrusted\aCDCDCDFF Features"),
    Misc_Clantag = ui.new_combobox("AA", "Anti-aimbot angles", "\a009dc4FFMisc\aCDCDCDFF - Clan tag spammers", "-", "Ocean.Tech", "Ocean.Tech Static"),
    Misc_Hide_Settings = ui.new_checkbox("AA", "Anti-aimbot angles", "\a009dc4FFVisuals\aCDCDCDFF - Hide Settings"),
    Misc_NameSpam = ui.new_button("AA", "Anti-aimbot angles", "\a009dc4FFMisc\aCDCDCDFF - NameSpam", function()
        tempName = "Ocean.Tech > ALL"
        endname = "​Ocean.Tech​ ​>​ ​ALL​"
        local lp = entity.get_local_player()
        local lp_name = entity.get_player_name(lp)
        can_name = true
        if can_name == true then
            table.insert(FallbackName, lp_name)
            can_name = false
        end
        for V, N in pairs(FallbackName) do 
           Final = N

        end

        if Final == nil then return end
        tempName11 = tempName .. "​"
        ui.set(refs.nameSteal, true)
        client.set_cvar("name", tempName)
        setName(0.15, endname)
        setName(0.25, tempName)
        setName(0.35, Final)
        for V, N in pairs(FallbackName) do 
            table.remove(FallbackName, V)
        end
        can_name = true
    end),

    border_bottom = ui.new_label("AA", "Anti-aimbot angles", "ㅤㅤㅤㅤㅤ  \aCDCDCDFF[\a009dc4FFOcean\aCDCDCDFF.Tech]  ㅤㅤㅤㅤㅤ"),
}

-- local Playerlist = {
--     Enable_Settings = pui.plist:checkbox("\a009dc4FFResolver\aCDCDCDFF - Enable Ocean Resolver Settings"),
--     Disable_Resolver = pui.plist:checkbox("\a009dc4FFResolver\aCDCDCDFF - Disable Ocean Resolver"),
--     Custom_Value = pui.plist:checkbox("\a009dc4FFResolver\aCDCDCDFF - Custom Roll Values"),
--     Roll_Override_L = pui.plist:slider("\a009dc4FFResolver\aCDCDCDFF - Roll Override Left", -90, 90, 50),
--     Roll_Override_R = pui.plist:slider("\a009dc4FFResolver\aCDCDCDFF - Roll Override Right", -90, 90, -50),
-- }

-- Playerlist.Disable_Resolver:depend({Playerlist.Enable_Settings, true})
-- Playerlist.Custom_Value:depend({Playerlist.Enable_Settings, true})
-- Playerlist.Roll_Override_L:depend({Playerlist.Custom_Value, true})
-- Playerlist.Roll_Override_R:depend({Playerlist.Custom_Value, true})

--Functions

local menu_update = function()

    local L = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Lower Body Yaw")
    local R = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Roll")
    local Free = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Freestanding")
    local AT = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Yaw: At Targets")
    local Pitchonkey = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Pitch-Down (\aD6BE73FFUnsafe\aCDCDCDFF)")
    local HalfPitch = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Half-Pitch (\aD6BE73FFUnsafe\aCDCDCDFF and \aD6BE73FFGay\aCDCDCDFF)")

    local F = table_contains(ui.get(Ocean_tab.Misc_First_Person), "Custom Scope Zoom")
    local T = table_contains(ui.get(Ocean_tab.Misc_Third_Person), "Custom Scope Zoom")
    local RO = table_contains(ui.get(Ocean_tab.Aimbot_Roll_Overrides), "Force Override Roll")
    local DO = table_contains(ui.get(Ocean_tab.Aimbot_Roll_Overrides), "Force Override Desync")
    local Feature_AA = table_contains(ui.get(Ocean_tab.Misc_Feature), "AA")
    local Feature_FL = table_contains(ui.get(Ocean_tab.Misc_Feature), "FL")




    

    if ui.get(Ocean_tab.TabSelection) == "Aimbot" and ui.get(Ocean_tab.MasterSwitch) then
        ui.set_visible(Ocean_tab.Aimbot_Enable, true)

        if ui.get(Ocean_tab.Aimbot_Enable)==true then
            ui.set_visible(Ocean_tab.Aimbot_Autofire, true)
            ui.set_visible(Ocean_tab.Aimbot_Autofire_hotkey, true)
            ui.set_visible(Ocean_tab.Aimbot_Autopenetration, true)
            ui.set_visible(Ocean_tab.Aimbot_Autopenetration_hotkey, true)
            ui.set_visible(Ocean_tab.Aimbot_DynamicFOV, true)
            if ui.get(Ocean_tab.Aimbot_DynamicFOV)==true then
                ui.set_visible(Ocean_tab.Aimbot_Min_Fov, true)
                ui.set_visible(Ocean_tab.Aimbot_Max_Fov, true)
            else
                ui.set_visible(Ocean_tab.Aimbot_Min_Fov, false)
                ui.set_visible(Ocean_tab.Aimbot_Max_Fov, false)
            end
            ui.set_visible(Ocean_tab.Aimbot_Prio_System, true)
            if ui.get(Ocean_tab.Aimbot_Prio_System) then
                ui.set_visible(Ocean_tab.Aimbot_Prio_System_color, true)
            else
                ui.set_visible(Ocean_tab.Aimbot_Prio_System_color, false)
            end
            ui.set_visible(Ocean_tab.Aimbot_Disablers_checkbox, true)
            if ui.get(Ocean_tab.Aimbot_Disablers_checkbox) then
                ui.set_visible(Ocean_tab.Aimbot_Disablers, true)
            else
                ui.set_visible(Ocean_tab.Aimbot_Disablers, false)
            end
            ui.set_visible(Ocean_tab.Aimbot_Roll_Enable, true)
            if ui.get(Ocean_tab.Aimbot_Roll_Enable)==true then
                ui.set_visible(Ocean_tab.Aimbot_Roll_Overrides, true)
                if RO then

                    ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, true)
                    ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, true)
                    ui.set_visible(Ocean_tab.Aimbot_Roll_Resolver_Modes, true)
                    ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch , true)
                    if ui.get(Ocean_tab.Aimbot_Roll_Untrusted_Pitch) then
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch_Value, true)
                    else
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch_Value, false)
                    end
                    if ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Auto" then
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, true)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, true)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
                    elseif ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Bruteforce" then
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, true)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, true)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
                    elseif ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Manual" then
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, true)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, true)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, true)
                    else
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
                    end
                elseif DO then
                    ui.set_visible(Ocean_tab.Aimbot_Roll_Resolver_Modes, true)
                    if ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Auto" then
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
                    elseif ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Bruteforce" then
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
                    elseif ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Manual" then
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, true)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
                    else
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
                        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
                    end
                else
                    ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
                    ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
                    ui.set_visible(Ocean_tab.Aimbot_Roll_Resolver_Modes, false)
                    ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
                    ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch, false)
                    ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch_Value, false)
                end
            else
                ui.set_visible(Ocean_tab.Aimbot_Roll_Overrides, false)
                ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
                ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
                ui.set_visible(Ocean_tab.Aimbot_Roll_Resolver_Modes, false)
                ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
                ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch, false)
                ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch_Value, false)
            end

        else
            ui.set_visible(Ocean_tab.Aimbot_Autofire, false)
            ui.set_visible(Ocean_tab.Aimbot_Autofire_hotkey, false)
            ui.set_visible(Ocean_tab.Aimbot_Autopenetration, false)
            ui.set_visible(Ocean_tab.Aimbot_Autopenetration_hotkey, false)
            ui.set_visible(Ocean_tab.Aimbot_DynamicFOV, false)
            ui.set_visible(Ocean_tab.Aimbot_Min_Fov, false)
            ui.set_visible(Ocean_tab.Aimbot_Max_Fov, false)
            ui.set_visible(Ocean_tab.Aimbot_Prio_System, false)
            ui.set_visible(Ocean_tab.Aimbot_Prio_System_color, false)
            ui.set_visible(Ocean_tab.Aimbot_Disablers_checkbox, false)
            ui.set_visible(Ocean_tab.Aimbot_Disablers, false)
            ui.set_visible(Ocean_tab.Aimbot_Roll_Enable, false)
            ui.set_visible(Ocean_tab.Aimbot_Roll_Overrides, false)
            ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
            ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
            ui.set_visible(Ocean_tab.Aimbot_Roll_Resolver_Modes, false)
            ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
            ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch, false)
            ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch_Value, false)
        end

        
        
        ui.set_visible(Ocean_tab.AntiAim_Enable, false)
        ui.set_visible(Ocean_tab.AntiAim_Inverter, false)
        ui.set_visible(Ocean_tab.AntiAim_Freestand, false)
        ui.set_visible(Ocean_tab.AntiAim_AtTarget, false)
        ui.set_visible(Ocean_tab.AntiAim_PitchKey, false)
        ui.set_visible(Ocean_tab.AntiAim_HalfPitchKey, false)
        ui.set_visible(Ocean_tab.AntiAim_Extras, false)
        ui.set_visible(Ocean_tab.AntiAim_Disablers, false)
        ui.set_visible(Ocean_tab.AntiAim_States, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)

        
        ui.set_visible(Ocean_tab.Misc_Feature, false)
        ui.set_visible(Ocean_tab.Misc_Feature_color, false)
        ui.set_visible(Ocean_tab.Misc_Feature_color2, false)
        ui.set_visible(Ocean_tab.Misc_Custom_Scope, false)
        ui.set_visible(Ocean_tab.Misc_First_Person, false)
        ui.set_visible(Ocean_tab.Misc_First_Person_Zoom, false)
        ui.set_visible(Ocean_tab.Misc_Third_Person, false)
        ui.set_visible(Ocean_tab.Misc_Third_Person_Zoom, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color1, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_select, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_color, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_selections, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Desync, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Invert, false)
        ui.set_visible(Ocean_tab.Misc_Watermark, false)
        ui.set_visible(Ocean_tab.Misc_Watermark_color, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_Selection, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color2, false)
        ui.set_visible(Ocean_tab.Misc_EventLogs, false)
        ui.set_visible(Ocean_tab.Misc_EventLogs_Output, false)
        ui.set_visible(Ocean_tab.Misc_Shared_Feature, false)
        ui.set_visible(Ocean_tab.Misc_Clantag, false)
        ui.set_visible(Ocean_tab.Misc_Untrusted, false)
        ui.set_visible(Ocean_tab.Misc_Hide_Settings, false)
        ui.set_visible(Ocean_tab.Misc_NameSpam, false)
        
        


    elseif ui.get(Ocean_tab.TabSelection) == "Anti-Aim" and ui.get(Ocean_tab.MasterSwitch) then
        ui.set_visible(Ocean_tab.AntiAim_Enable, true)
        if ui.get(Ocean_tab.AntiAim_Enable) then
            ui.set_visible(Ocean_tab.AntiAim_States, true)
            ui.set_visible(Ocean_tab.AntiAim_Inverter, true)
            if ui.get(Ocean_tab.AntiAim_Enable) and Free then
                ui.set_visible(Ocean_tab.AntiAim_Freestand, true)
            else
                ui.set_visible(Ocean_tab.AntiAim_Freestand, false)
            end
            if AT and ui.get(Ocean_tab.AntiAim_Enable) then
                ui.set_visible(Ocean_tab.AntiAim_AtTarget, true)
            else
                ui.set_visible(Ocean_tab.AntiAim_AtTarget, false)
            end
            if Pitchonkey and ui.get(Ocean_tab.AntiAim_Enable) then
                ui.set_visible(Ocean_tab.AntiAim_PitchKey, true)
            else
                ui.set_visible(Ocean_tab.AntiAim_PitchKey, false)
            end
            if HalfPitch and ui.get(Ocean_tab.AntiAim_Enable) then
                ui.set_visible(Ocean_tab.AntiAim_HalfPitchKey, true)
            else
                ui.set_visible(Ocean_tab.AntiAim_HalfPitchKey, false)
            end
            ui.set_visible(Ocean_tab.AntiAim_Extras, true)
            ui.set_visible(Ocean_tab.AntiAim_Disablers, true)
            if ui.get(Ocean_tab.AntiAim_States)=="Stand" then
                ui.set_visible(Ocean_tab.AntiAim_Stand_BodyYaw, true)
                if ui.get(Ocean_tab.AntiAim_Stand_BodyYaw) == "Freestand" then
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Open, true)
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, true)
                else
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Open, false)
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, false)
                end
                ui.set_visible(Ocean_tab.AntiAim_Stand_Brute, true)
                if R then   
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, true)
                elseif not R then
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, false)
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
                end
                if ui.get(Ocean_tab.AntiAim_Stand_Roll)==true and R then
                    if ui.get(Ocean_tab.Misc_Untrusted)==true then
                        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, true)
                        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, true)
                        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
                        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
                    else
                        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, true)
                        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, true)
                        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
                        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
                    end
                else
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
                end
                ui.set_visible(Ocean_tab.AntiAim_Duck_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)
            elseif ui.get(Ocean_tab.AntiAim_States)=="Duck" then
                ui.set_visible(Ocean_tab.AntiAim_Duck_BodyYaw, true)
                if ui.get(Ocean_tab.AntiAim_Duck_BodyYaw) == "Freestand" then
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Open, true)
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, true)
                else
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Open, false)
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, false)
                end
                ui.set_visible(Ocean_tab.AntiAim_Duck_Brute, true)
                if R then
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, true)
                elseif not R then
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, false)
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
                end
                if ui.get(Ocean_tab.AntiAim_Duck_Roll)==true and R then
                    if ui.get(Ocean_tab.Misc_Untrusted)==true then
                        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, true)
                        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, true)
                        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
                        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
                    else
                        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, true)
                        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, true)
                        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
                        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
                    end
                else
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
                end
                ui.set_visible(Ocean_tab.AntiAim_Stand_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)
            elseif ui.get(Ocean_tab.AntiAim_States)=="Move" then
                ui.set_visible(Ocean_tab.AntiAim_Move_BodyYaw, true)
                if ui.get(Ocean_tab.AntiAim_Move_BodyYaw) == "Freestand" then
                    ui.set_visible(Ocean_tab.AntiAim_Move_Open, true)
                    ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, true)
                else
                    ui.set_visible(Ocean_tab.AntiAim_Move_Open, false)
                    ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, false)
                end
                ui.set_visible(Ocean_tab.AntiAim_Move_Brute, true)
                if R then
                    ui.set_visible(Ocean_tab.AntiAim_Move_Roll, true)
                elseif not R then
                    ui.set_visible(Ocean_tab.AntiAim_Move_Roll, false)
                    ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
                    ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
                end
                if ui.get(Ocean_tab.AntiAim_Move_Roll)==true and R then
                    if ui.get(Ocean_tab.Misc_Untrusted)==true then
                        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, true)
                        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, true)
                        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
                        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
                    else
                        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, true)
                        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, true)
                        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
                        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
                    end
                else
                    ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
                    ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
                end
                ui.set_visible(Ocean_tab.AntiAim_Stand_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)
            elseif ui.get(Ocean_tab.AntiAim_States)=="Slowwalk" then
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_BodyYaw, true)
                if ui.get(Ocean_tab.AntiAim_Slowwalk_BodyYaw) == "Freestand" then
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, true)
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, true)
                else
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, false)
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, false)
                end
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Brute, true)
                if R then
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, true)
                elseif not R then
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, false)
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
                end
                if ui.get(Ocean_tab.AntiAim_Slowwalk_Roll)==true and R then
                    if ui.get(Ocean_tab.Misc_Untrusted)==true then
                        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, true)
                        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, true)
                        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
                        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
                    else
                        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, true)
                        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, true)
                        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
                        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
                    end
                else
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
                end
                --ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed, true)
                if ui.get(Ocean_tab.AntiAim_Slowwalk_Speed) then
                    --ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, true)
                else
                    ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, false)
                end
                ui.set_visible(Ocean_tab.AntiAim_Stand_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)
            elseif ui.get(Ocean_tab.AntiAim_States)=="In-Air" then
                ui.set_visible(Ocean_tab.AntiAim_In_Air_BodyYaw, true)
                if ui.get(Ocean_tab.AntiAim_In_Air_BodyYaw) == "Freestand" then
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, true)
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, true)
                else
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, false)
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, false)
                end
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Brute, true)
                if R then
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, true)
                elseif not R then
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, false)
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)
                end
                if ui.get(Ocean_tab.AntiAim_In_Air_Roll)==true and R then
                    if ui.get(Ocean_tab.Misc_Untrusted)==true then
                        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, true)
                        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, true)
                        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
                        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
                    else
                        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, true)
                        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, true)
                        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
                        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)
                    end
                else
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
                    ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)
                end
                ui.set_visible(Ocean_tab.AntiAim_Stand_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, false)
            else
                ui.set_visible(Ocean_tab.AntiAim_Stand_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed, false)
                ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_BodyYaw, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Brute, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
                ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)
            end


        else
            ui.set_visible(Ocean_tab.AntiAim_Inverter, false)
            ui.set_visible(Ocean_tab.AntiAim_Extras, false)
            ui.set_visible(Ocean_tab.AntiAim_Freestand, false)
            ui.set_visible(Ocean_tab.AntiAim_AtTarget, false)
            ui.set_visible(Ocean_tab.AntiAim_PitchKey, false)
            ui.set_visible(Ocean_tab.AntiAim_HalfPitchKey, false)
            ui.set_visible(Ocean_tab.AntiAim_Disablers, false)
            ui.set_visible(Ocean_tab.AntiAim_States, false)
            ui.set_visible(Ocean_tab.AntiAim_Stand_BodyYaw, false)
            ui.set_visible(Ocean_tab.AntiAim_Stand_Open, false)
            ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, false)
            ui.set_visible(Ocean_tab.AntiAim_Stand_Brute, false)
            ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, false)
            ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
            ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
            ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
            ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
            ui.set_visible(Ocean_tab.AntiAim_Duck_BodyYaw, false)
            ui.set_visible(Ocean_tab.AntiAim_Duck_Open, false)
            ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, false)
            ui.set_visible(Ocean_tab.AntiAim_Duck_Brute, false)
            ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, false)
            ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
            ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
            ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
            ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
            ui.set_visible(Ocean_tab.AntiAim_Move_BodyYaw, false)
            ui.set_visible(Ocean_tab.AntiAim_Move_Open, false)
            ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, false)
            ui.set_visible(Ocean_tab.AntiAim_Move_Brute, false)
            ui.set_visible(Ocean_tab.AntiAim_Move_Roll, false)
            ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
            ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
            ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
            ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
            ui.set_visible(Ocean_tab.AntiAim_Slowwalk_BodyYaw, false)
            ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, false)
            ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, false)
            ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Brute, false)
            ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, false)
            ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
            ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
            ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
            ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
            ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed, false)
            ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, false)
            ui.set_visible(Ocean_tab.AntiAim_In_Air_BodyYaw, false)
            ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, false)
            ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, false)
            ui.set_visible(Ocean_tab.AntiAim_In_Air_Brute, false)
            ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, false)
            ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
            ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
            ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
            ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)
        end



        ui.set_visible(Ocean_tab.Aimbot_Enable, false)
        ui.set_visible(Ocean_tab.Aimbot_Autofire, false)
        ui.set_visible(Ocean_tab.Aimbot_Autofire_hotkey, false)
        ui.set_visible(Ocean_tab.Aimbot_Autopenetration, false)
        ui.set_visible(Ocean_tab.Aimbot_Autopenetration_hotkey, false)
        ui.set_visible(Ocean_tab.Aimbot_DynamicFOV, false)
        ui.set_visible(Ocean_tab.Aimbot_Min_Fov, false)
        ui.set_visible(Ocean_tab.Aimbot_Max_Fov, false)
        ui.set_visible(Ocean_tab.Aimbot_Prio_System, false)
        ui.set_visible(Ocean_tab.Aimbot_Prio_System_color, false)
        ui.set_visible(Ocean_tab.Aimbot_Disablers_checkbox, false)
        ui.set_visible(Ocean_tab.Aimbot_Disablers, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Enable, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Overrides, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Resolver_Modes, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch_Value, false)


        ui.set_visible(Ocean_tab.Misc_Feature, false)
        ui.set_visible(Ocean_tab.Misc_Feature_color, false)
        ui.set_visible(Ocean_tab.Misc_Feature_color2, false)
        ui.set_visible(Ocean_tab.Misc_Custom_Scope, false)
        ui.set_visible(Ocean_tab.Misc_First_Person, false)
        ui.set_visible(Ocean_tab.Misc_First_Person_Zoom, false)
        ui.set_visible(Ocean_tab.Misc_Third_Person, false)
        ui.set_visible(Ocean_tab.Misc_Third_Person_Zoom, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color1, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_select, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_color, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_selections, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Desync, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Invert, false)
        ui.set_visible(Ocean_tab.Misc_Watermark, false)
        ui.set_visible(Ocean_tab.Misc_Watermark_color, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_Selection, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color2, false)
        ui.set_visible(Ocean_tab.Misc_EventLogs, false)
        ui.set_visible(Ocean_tab.Misc_EventLogs_Output, false)
        ui.set_visible(Ocean_tab.Misc_Shared_Feature, false)
        ui.set_visible(Ocean_tab.Misc_Clantag, false)
        ui.set_visible(Ocean_tab.Misc_Untrusted, false)
        ui.set_visible(Ocean_tab.Misc_Hide_Settings, false)
        ui.set_visible(Ocean_tab.Misc_NameSpam, false)
        
    elseif ui.get(Ocean_tab.TabSelection) == "Visuals" and ui.get(Ocean_tab.MasterSwitch) then

        ui.set_visible(Ocean_tab.Misc_Feature, true)
        ui.set_visible(Ocean_tab.Misc_Feature_color, true)
        if Feature_AA or Feature_FL then
            ui.set_visible(Ocean_tab.Misc_Feature_color2, true)
        else
            ui.set_visible(Ocean_tab.Misc_Feature_color2, false)
        end
        ui.set_visible(Ocean_tab.Misc_Custom_Scope, true)
        if ui.get(Ocean_tab.Misc_Custom_Scope)==true then
            ui.set_visible(Ocean_tab.Misc_First_Person, true)
            if F then
                ui.set_visible(Ocean_tab.Misc_First_Person_Zoom, true)
            else
                ui.set_visible(Ocean_tab.Misc_First_Person_Zoom, false)
            end
            ui.set_visible(Ocean_tab.Misc_Third_Person, true)
            if T then
                ui.set_visible(Ocean_tab.Misc_Third_Person_Zoom, true)
            else
                ui.set_visible(Ocean_tab.Misc_Third_Person_Zoom, false)
            end
        else

            ui.set_visible(Ocean_tab.Misc_First_Person, false)
            ui.set_visible(Ocean_tab.Misc_Third_Person, false)
            ui.set_visible(Ocean_tab.Misc_First_Person_Zoom, false)
            ui.set_visible(Ocean_tab.Misc_Third_Person_Zoom, false)
        end

        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator, true)
        if ui.get(Ocean_tab.Misc_Crosshair_Indicator) then
            ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color, true)
            ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color1, true)
            ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_select, true)
        else
            ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color, false)
            ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color1, false)
            ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_select, false)
        end

        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator, true)
        if ui.get(Ocean_tab.Misc_Body_Yaw_indicator)==true then
            ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Desync, true)
            if ui.get(Ocean_tab.Misc_Body_Yaw_indicator_color) == true then
                ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_color, true)
            else
                ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_color, false)
            end
            ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_selections, true)
            ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Invert, true)
        else
            ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_color, false)
            ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_selections, false)
            ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Invert, false)
            ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Desync, false)
        end
        ui.set_visible(Ocean_tab.Misc_Watermark, true)
        if ui.get(Ocean_tab.Misc_Watermark)==true then
            ui.set_visible(Ocean_tab.Misc_Watermark_color, true)
        else
            ui.set_visible(Ocean_tab.Misc_Watermark_color, false)
        end
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction, true)
        if ui.get(Ocean_tab.Misc_Peek_Prediction) then
            ui.set_visible(Ocean_tab.Misc_Peek_Prediction_Selection, true)
            ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color, true)
            ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color2, true)
        else
            ui.set_visible(Ocean_tab.Misc_Peek_Prediction_Selection, false)
            ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color, false)
            ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color2, false)
        end


        if ui.get(Ocean_tab.Misc_Body_Yaw_indicator) or ui.get(Ocean_tab.Misc_Crosshair_Indicator) or ui.get(Ocean_tab.Misc_Custom_Scope) or ui.get(Ocean_tab.Misc_Peek_Prediction) then
            ui.set_visible(Ocean_tab.Misc_Hide_Settings, true)
            if ui.get(Ocean_tab.Misc_Hide_Settings) then
                ui.set_visible(Ocean_tab.Misc_First_Person, false)
                ui.set_visible(Ocean_tab.Misc_Third_Person, false)
                ui.set_visible(Ocean_tab.Misc_First_Person_Zoom, false)
                ui.set_visible(Ocean_tab.Misc_Third_Person_Zoom, false)
                ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_select, false)
                ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_selections, false)
                ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_color, false)
                ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Invert, false)
                ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Desync, false)
                ui.set_visible(Ocean_tab.Misc_Peek_Prediction_Selection, false)
                ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color, false)
                ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color2, false)
            else
                if ui.get(Ocean_tab.Misc_Body_Yaw_indicator) then
                    ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Desync, true)
                    if ui.get(Ocean_tab.Misc_Body_Yaw_indicator_Desync) == true then
                        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_color, false)
                    else
                        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_color, true)
                    end
                    ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_selections, true)
                    ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Invert, true)
                end
                if ui.get(Ocean_tab.Misc_Crosshair_Indicator) then
                    ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_select, true)
                end
                if ui.get(Ocean_tab.Misc_Custom_Scope) then
                    if F then
                        ui.set_visible(Ocean_tab.Misc_First_Person_Zoom, true)
                    end
                    ui.set_visible(Ocean_tab.Misc_Third_Person, true)
                    if T then
                        ui.set_visible(Ocean_tab.Misc_Third_Person_Zoom, true)
                    end
                end
                if ui.get(Ocean_tab.Misc_Peek_Prediction) then
                    ui.set_visible(Ocean_tab.Misc_Peek_Prediction_Selection, true)
                    ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color, true)
                    ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color2, true)
                else
                    ui.set_visible(Ocean_tab.Misc_Peek_Prediction_Selection, false)
                    ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color, false)
                    ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color2, false)
                end
            end
        end

        ui.set_visible(Ocean_tab.Aimbot_Enable, false)
        ui.set_visible(Ocean_tab.Aimbot_Autofire, false)
        ui.set_visible(Ocean_tab.Aimbot_Autofire_hotkey, false)
        ui.set_visible(Ocean_tab.Aimbot_Autopenetration, false)
        ui.set_visible(Ocean_tab.Aimbot_Autopenetration_hotkey, false)
        ui.set_visible(Ocean_tab.Aimbot_DynamicFOV, false)
        ui.set_visible(Ocean_tab.Aimbot_Min_Fov, false)
        ui.set_visible(Ocean_tab.Aimbot_Max_Fov, false)
        ui.set_visible(Ocean_tab.Aimbot_Prio_System, false)
        ui.set_visible(Ocean_tab.Aimbot_Prio_System_color, false)
        ui.set_visible(Ocean_tab.Aimbot_Disablers_checkbox, false)
        ui.set_visible(Ocean_tab.Aimbot_Disablers, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Enable, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Overrides, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Resolver_Modes, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch_Value, false)

        ui.set_visible(Ocean_tab.AntiAim_Enable, false)
        ui.set_visible(Ocean_tab.AntiAim_Inverter, false)
        ui.set_visible(Ocean_tab.AntiAim_Freestand, false)
        ui.set_visible(Ocean_tab.AntiAim_AtTarget, false)
        ui.set_visible(Ocean_tab.AntiAim_PitchKey, false)
        ui.set_visible(Ocean_tab.AntiAim_HalfPitchKey, false)
        ui.set_visible(Ocean_tab.AntiAim_Extras, false)
        ui.set_visible(Ocean_tab.AntiAim_Disablers, false)
        ui.set_visible(Ocean_tab.AntiAim_States, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)
        ui.set_visible(Ocean_tab.Misc_EventLogs, false)
        ui.set_visible(Ocean_tab.Misc_EventLogs_Output, false)
        ui.set_visible(Ocean_tab.Misc_Shared_Feature, false)
        ui.set_visible(Ocean_tab.Misc_Clantag, false)
        ui.set_visible(Ocean_tab.Misc_Untrusted, false)
        ui.set_visible(Ocean_tab.Misc_NameSpam, false)

    elseif ui.get(Ocean_tab.TabSelection) == "Misc" and ui.get(Ocean_tab.MasterSwitch) then

        ui.set_visible(Ocean_tab.Misc_EventLogs, true)
        if ui.get(Ocean_tab.Misc_EventLogs) then
            ui.set_visible(Ocean_tab.Misc_EventLogs_Output, true)
        else
            ui.set_visible(Ocean_tab.Misc_EventLogs_Output, false)
        end

        ui.set_visible(Ocean_tab.Misc_Shared_Feature, true)
        ui.set_visible(Ocean_tab.Misc_Clantag, true)
        ui.set_visible(Ocean_tab.Misc_Untrusted, true)
        ui.set_visible(Ocean_tab.Misc_NameSpam, true)

        ui.set_visible(Ocean_tab.Aimbot_Enable, false)
        ui.set_visible(Ocean_tab.Aimbot_Autofire, false)
        ui.set_visible(Ocean_tab.Aimbot_Autofire_hotkey, false)
        ui.set_visible(Ocean_tab.Aimbot_Autopenetration, false)
        ui.set_visible(Ocean_tab.Aimbot_Autopenetration_hotkey, false)
        ui.set_visible(Ocean_tab.Aimbot_DynamicFOV, false)
        ui.set_visible(Ocean_tab.Aimbot_Min_Fov, false)
        ui.set_visible(Ocean_tab.Aimbot_Max_Fov, false)
        ui.set_visible(Ocean_tab.Aimbot_Prio_System, false)
        ui.set_visible(Ocean_tab.Aimbot_Prio_System_color, false)
        ui.set_visible(Ocean_tab.Aimbot_Disablers_checkbox, false)
        ui.set_visible(Ocean_tab.Aimbot_Disablers, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Enable, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Overrides, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Resolver_Modes, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch_Value, false)

        ui.set_visible(Ocean_tab.AntiAim_Enable, false)
        ui.set_visible(Ocean_tab.AntiAim_Inverter, false)
        ui.set_visible(Ocean_tab.AntiAim_Freestand, false)
        ui.set_visible(Ocean_tab.AntiAim_AtTarget, false)
        ui.set_visible(Ocean_tab.AntiAim_PitchKey, false)
        ui.set_visible(Ocean_tab.AntiAim_HalfPitchKey, false)
        ui.set_visible(Ocean_tab.AntiAim_Extras, false)
        ui.set_visible(Ocean_tab.AntiAim_Disablers, false)
        ui.set_visible(Ocean_tab.AntiAim_States, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)

        ui.set_visible(Ocean_tab.Misc_Feature, false)
        ui.set_visible(Ocean_tab.Misc_Feature_color, false)
        ui.set_visible(Ocean_tab.Misc_Feature_color2, false)
        ui.set_visible(Ocean_tab.Misc_Custom_Scope, false)
        ui.set_visible(Ocean_tab.Misc_First_Person, false)
        ui.set_visible(Ocean_tab.Misc_First_Person_Zoom, false)
        ui.set_visible(Ocean_tab.Misc_Third_Person, false)
        ui.set_visible(Ocean_tab.Misc_Third_Person_Zoom, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color1, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_select, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_color, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_selections, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Desync, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Invert, false)
        ui.set_visible(Ocean_tab.Misc_Watermark, false)
        ui.set_visible(Ocean_tab.Misc_Watermark_color, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_Selection, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color2, false)
        ui.set_visible(Ocean_tab.Misc_Hide_Settings, false)

    else

        ui.set_visible(Ocean_tab.Misc_Feature, false)
        ui.set_visible(Ocean_tab.Misc_Feature_color, false)
        ui.set_visible(Ocean_tab.Misc_Feature_color2, false)
        ui.set_visible(Ocean_tab.Misc_Custom_Scope, false)
        ui.set_visible(Ocean_tab.Misc_First_Person, false)
        ui.set_visible(Ocean_tab.Misc_First_Person_Zoom, false)
        ui.set_visible(Ocean_tab.Misc_Third_Person, false)
        ui.set_visible(Ocean_tab.Misc_Third_Person_Zoom, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_color1, false)
        ui.set_visible(Ocean_tab.Misc_Crosshair_Indicator_select, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_color, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_selections, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Desync, false)
        ui.set_visible(Ocean_tab.Misc_Body_Yaw_indicator_Invert, false)
        ui.set_visible(Ocean_tab.Misc_Watermark, false)
        ui.set_visible(Ocean_tab.Misc_Watermark_color, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_Selection, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color, false)
        ui.set_visible(Ocean_tab.Misc_Peek_Prediction_color2, false)
        ui.set_visible(Ocean_tab.Misc_EventLogs, false)
        ui.set_visible(Ocean_tab.Misc_EventLogs_Output, false)
        ui.set_visible(Ocean_tab.Misc_Shared_Feature, false)
        ui.set_visible(Ocean_tab.Misc_Clantag, false)
        ui.set_visible(Ocean_tab.Misc_Untrusted, false)
        ui.set_visible(Ocean_tab.Misc_Hide_Settings, false)
        ui.set_visible(Ocean_tab.Misc_NameSpam, false)
       

        ui.set_visible(Ocean_tab.Aimbot_Enable, false)
        ui.set_visible(Ocean_tab.Aimbot_Autofire, false)
        ui.set_visible(Ocean_tab.Aimbot_Autofire_hotkey, false)
        ui.set_visible(Ocean_tab.Aimbot_Autopenetration, false)
        ui.set_visible(Ocean_tab.Aimbot_Autopenetration_hotkey, false)
        ui.set_visible(Ocean_tab.Aimbot_DynamicFOV, false)
        ui.set_visible(Ocean_tab.Aimbot_Min_Fov, false)
        ui.set_visible(Ocean_tab.Aimbot_Max_Fov, false)
        ui.set_visible(Ocean_tab.Aimbot_Prio_System, false)
        ui.set_visible(Ocean_tab.Aimbot_Prio_System_color, false)
        ui.set_visible(Ocean_tab.Aimbot_Disablers_checkbox, false)
        ui.set_visible(Ocean_tab.Aimbot_Disablers, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Enable, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Overrides, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_L, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Override_R, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Resolver_Modes, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Inverter, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch, false)
        ui.set_visible(Ocean_tab.Aimbot_Roll_Untrusted_Pitch_Value, false)


        ui.set_visible(Ocean_tab.AntiAim_Enable, false)
        ui.set_visible(Ocean_tab.AntiAim_Inverter, false)
        ui.set_visible(Ocean_tab.AntiAim_Freestand, false)
        ui.set_visible(Ocean_tab.AntiAim_AtTarget, false)
        ui.set_visible(Ocean_tab.AntiAim_PitchKey, false)
        ui.set_visible(Ocean_tab.AntiAim_HalfPitchKey, false)
        ui.set_visible(Ocean_tab.AntiAim_Extras, false)
        ui.set_visible(Ocean_tab.AntiAim_Disablers, false)
        ui.set_visible(Ocean_tab.AntiAim_States, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Stand_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Duck_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Move_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Untrusted_R, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed, false)
        ui.set_visible(Ocean_tab.AntiAim_Slowwalk_Speed_Value, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_BodyYaw, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Open, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Reverse, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Brute, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_L, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Roll_R, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_L, false)
        ui.set_visible(Ocean_tab.AntiAim_In_Air_Untrusted_R, false)
    end

    if ui.get(Ocean_tab.MasterSwitch) then
        --Invisble
        ui.set_visible(refs.FL_Check1, false)
        ui.set_visible(refs.FL_Check2, false)
        ui.set_visible(refs.FL_Amount, false)
        ui.set_visible(refs.FL_Variance, false)
        ui.set_visible(refs.FL_Limit, false)
        --Visble
        ui.set_visible(Ocean_tab.FL_Enable, true)
        ui.set_visible(Ocean_tab.FL_Restrict, true)
        ui.set_visible(Ocean_tab.FL_Key, true)
        ui.set_visible(Ocean_tab.FL_State, true)
        if ui.get(Ocean_tab.FL_State)=="Global" and ui.get(Ocean_tab.FL_Enable) then
            ui.set_visible(Ocean_tab.FL_Global_Amount, true)
            ui.set_visible(Ocean_tab.FL_Global_Variance, true)
            ui.set_visible(Ocean_tab.FL_Global_Limit, true)
            ui.set_visible(Ocean_tab.FL_Stand_Override , false)
            ui.set_visible(Ocean_tab.FL_Stand_Amount, false)
            ui.set_visible(Ocean_tab.FL_Stand_Variance, false)
            ui.set_visible(Ocean_tab.FL_Stand_Limit, false)
            ui.set_visible(Ocean_tab.FL_Duck_Override , false)
            ui.set_visible(Ocean_tab.FL_Duck_Amount, false)
            ui.set_visible(Ocean_tab.FL_Duck_Variance, false)
            ui.set_visible(Ocean_tab.FL_Duck_Limit, false)
            ui.set_visible(Ocean_tab.FL_Move_Override , false)
            ui.set_visible(Ocean_tab.FL_Move_Amount, false)
            ui.set_visible(Ocean_tab.FL_Move_Variance, false)
            ui.set_visible(Ocean_tab.FL_Move_Limit, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Override , false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Amount, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Variance, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Limit, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Override , false)
            ui.set_visible(Ocean_tab.FL_In_Air_Amount, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Variance, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Limit, false)
        elseif ui.get(Ocean_tab.FL_State)=="Stand" and ui.get(Ocean_tab.FL_Enable)  then
            ui.set_visible(Ocean_tab.FL_Global_Amount, false)
            ui.set_visible(Ocean_tab.FL_Global_Variance, false)
            ui.set_visible(Ocean_tab.FL_Global_Limit, false)
            ui.set_visible(Ocean_tab.FL_Stand_Override , true)
            if ui.get(Ocean_tab.FL_Stand_Override) then
                ui.set_visible(Ocean_tab.FL_Stand_Amount, true)
                ui.set_visible(Ocean_tab.FL_Stand_Variance, true)
                ui.set_visible(Ocean_tab.FL_Stand_Limit, true)
            else
                ui.set_visible(Ocean_tab.FL_Stand_Amount, false)
                ui.set_visible(Ocean_tab.FL_Stand_Variance, false)
                ui.set_visible(Ocean_tab.FL_Stand_Limit, false)
            end
            ui.set_visible(Ocean_tab.FL_Duck_Override , false)
            ui.set_visible(Ocean_tab.FL_Duck_Amount, false)
            ui.set_visible(Ocean_tab.FL_Duck_Variance, false)
            ui.set_visible(Ocean_tab.FL_Duck_Limit, false)
            ui.set_visible(Ocean_tab.FL_Move_Override , false)
            ui.set_visible(Ocean_tab.FL_Move_Amount, false)
            ui.set_visible(Ocean_tab.FL_Move_Variance, false)
            ui.set_visible(Ocean_tab.FL_Move_Limit, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Override , false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Amount, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Variance, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Limit, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Override , false)
            ui.set_visible(Ocean_tab.FL_In_Air_Amount, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Variance, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Limit, false)
        elseif ui.get(Ocean_tab.FL_State)=="Duck" and ui.get(Ocean_tab.FL_Enable) then
            ui.set_visible(Ocean_tab.FL_Global_Amount, false)
            ui.set_visible(Ocean_tab.FL_Global_Variance, false)
            ui.set_visible(Ocean_tab.FL_Global_Limit, false)
            ui.set_visible(Ocean_tab.FL_Stand_Override , false)
            ui.set_visible(Ocean_tab.FL_Stand_Amount, false)
            ui.set_visible(Ocean_tab.FL_Stand_Variance, false)
            ui.set_visible(Ocean_tab.FL_Stand_Limit, false)
            ui.set_visible(Ocean_tab.FL_Duck_Override, true)
            if ui.get(Ocean_tab.FL_Duck_Override) then
                ui.set_visible(Ocean_tab.FL_Duck_Amount, true)
                ui.set_visible(Ocean_tab.FL_Duck_Variance, true)
                ui.set_visible(Ocean_tab.FL_Duck_Limit, true)
            else
                ui.set_visible(Ocean_tab.FL_Duck_Amount, false)
                ui.set_visible(Ocean_tab.FL_Duck_Variance, false)
                ui.set_visible(Ocean_tab.FL_Duck_Limit, false)
            end
            ui.set_visible(Ocean_tab.FL_Move_Override , false)
            ui.set_visible(Ocean_tab.FL_Move_Amount, false)
            ui.set_visible(Ocean_tab.FL_Move_Variance, false)
            ui.set_visible(Ocean_tab.FL_Move_Limit, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Override , false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Amount, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Variance, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Limit, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Override , false)
            ui.set_visible(Ocean_tab.FL_In_Air_Amount, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Variance, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Limit, false)
        elseif ui.get(Ocean_tab.FL_State)=="Move" and ui.get(Ocean_tab.FL_Enable) then
            ui.set_visible(Ocean_tab.FL_Global_Amount, false)
            ui.set_visible(Ocean_tab.FL_Global_Variance, false)
            ui.set_visible(Ocean_tab.FL_Global_Limit, false)
            ui.set_visible(Ocean_tab.FL_Stand_Override , false)
            ui.set_visible(Ocean_tab.FL_Stand_Amount, false)
            ui.set_visible(Ocean_tab.FL_Stand_Variance, false)
            ui.set_visible(Ocean_tab.FL_Stand_Limit, false)
            ui.set_visible(Ocean_tab.FL_Duck_Override , false)
            ui.set_visible(Ocean_tab.FL_Duck_Amount, false)
            ui.set_visible(Ocean_tab.FL_Duck_Variance, false)
            ui.set_visible(Ocean_tab.FL_Duck_Limit, false)
            ui.set_visible(Ocean_tab.FL_Move_Override , true)
            if ui.get(Ocean_tab.FL_Move_Override) then
                ui.set_visible(Ocean_tab.FL_Move_Amount, true)
                ui.set_visible(Ocean_tab.FL_Move_Variance, true)
                ui.set_visible(Ocean_tab.FL_Move_Limit, true)
            else
                ui.set_visible(Ocean_tab.FL_Move_Amount, false)
                ui.set_visible(Ocean_tab.FL_Move_Variance, false)
                ui.set_visible(Ocean_tab.FL_Move_Limit, false)
            end
            ui.set_visible(Ocean_tab.FL_Slowwalk_Override , false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Amount, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Variance, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Limit, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Override , false)
            ui.set_visible(Ocean_tab.FL_In_Air_Amount, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Variance, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Limit, false)
        elseif ui.get(Ocean_tab.FL_State)=="Slowwalk" and ui.get(Ocean_tab.FL_Enable) then
            ui.set_visible(Ocean_tab.FL_Global_Amount, false)
            ui.set_visible(Ocean_tab.FL_Global_Variance, false)
            ui.set_visible(Ocean_tab.FL_Global_Limit, false)
            ui.set_visible(Ocean_tab.FL_Stand_Override , false)
            ui.set_visible(Ocean_tab.FL_Stand_Amount, false)
            ui.set_visible(Ocean_tab.FL_Stand_Variance, false)
            ui.set_visible(Ocean_tab.FL_Stand_Limit, false)
            ui.set_visible(Ocean_tab.FL_Duck_Override , false)
            ui.set_visible(Ocean_tab.FL_Duck_Amount, false)
            ui.set_visible(Ocean_tab.FL_Duck_Variance, false)
            ui.set_visible(Ocean_tab.FL_Duck_Limit, false)
            ui.set_visible(Ocean_tab.FL_Move_Override , false)
            ui.set_visible(Ocean_tab.FL_Move_Amount, false)
            ui.set_visible(Ocean_tab.FL_Move_Variance, false)
            ui.set_visible(Ocean_tab.FL_Move_Limit, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Override , true)
            if ui.get(Ocean_tab.FL_Slowwalk_Override) then  
                ui.set_visible(Ocean_tab.FL_Slowwalk_Amount, true)
                ui.set_visible(Ocean_tab.FL_Slowwalk_Variance, true)
                ui.set_visible(Ocean_tab.FL_Slowwalk_Limit, true)
            else
                ui.set_visible(Ocean_tab.FL_Slowwalk_Amount, false)
                ui.set_visible(Ocean_tab.FL_Slowwalk_Variance, false)
                ui.set_visible(Ocean_tab.FL_Slowwalk_Limit, false)
            end
            ui.set_visible(Ocean_tab.FL_In_Air_Override , false)
            ui.set_visible(Ocean_tab.FL_In_Air_Amount, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Variance, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Limit, false)
        elseif ui.get(Ocean_tab.FL_State)=="In-Air" and ui.get(Ocean_tab.FL_Enable) then
            ui.set_visible(Ocean_tab.FL_Global_Amount, false)
            ui.set_visible(Ocean_tab.FL_Global_Variance, false)
            ui.set_visible(Ocean_tab.FL_Global_Limit, false)
            ui.set_visible(Ocean_tab.FL_Stand_Override , false)
            ui.set_visible(Ocean_tab.FL_Stand_Amount, false)
            ui.set_visible(Ocean_tab.FL_Stand_Variance, false)
            ui.set_visible(Ocean_tab.FL_Stand_Limit, false)
            ui.set_visible(Ocean_tab.FL_Duck_Override , false)
            ui.set_visible(Ocean_tab.FL_Duck_Amount, false)
            ui.set_visible(Ocean_tab.FL_Duck_Variance, false)
            ui.set_visible(Ocean_tab.FL_Duck_Limit, false)
            ui.set_visible(Ocean_tab.FL_Move_Override , false)
            ui.set_visible(Ocean_tab.FL_Move_Amount, false)
            ui.set_visible(Ocean_tab.FL_Move_Variance, false)
            ui.set_visible(Ocean_tab.FL_Move_Limit, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Override , false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Amount, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Variance, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Limit, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Override , true)
            if ui.get(Ocean_tab.FL_In_Air_Override) then
                ui.set_visible(Ocean_tab.FL_In_Air_Amount, true)
                ui.set_visible(Ocean_tab.FL_In_Air_Variance, true)
                ui.set_visible(Ocean_tab.FL_In_Air_Limit, true)
            else
                ui.set_visible(Ocean_tab.FL_In_Air_Amount, false)
                ui.set_visible(Ocean_tab.FL_In_Air_Variance, false)
                ui.set_visible(Ocean_tab.FL_In_Air_Limit, false)
            end
        else
            ui.set_visible(Ocean_tab.FL_Global_Amount, false)
            ui.set_visible(Ocean_tab.FL_Global_Variance, false)
            ui.set_visible(Ocean_tab.FL_Global_Limit, false)
            ui.set_visible(Ocean_tab.FL_Stand_Override , false)
            ui.set_visible(Ocean_tab.FL_Stand_Amount, false)
            ui.set_visible(Ocean_tab.FL_Stand_Variance, false)
            ui.set_visible(Ocean_tab.FL_Stand_Limit, false)
            ui.set_visible(Ocean_tab.FL_Duck_Override , false)
            ui.set_visible(Ocean_tab.FL_Duck_Amount, false)
            ui.set_visible(Ocean_tab.FL_Duck_Variance, false)
            ui.set_visible(Ocean_tab.FL_Duck_Limit, false)
            ui.set_visible(Ocean_tab.FL_Move_Override , false)
            ui.set_visible(Ocean_tab.FL_Move_Amount, false)
            ui.set_visible(Ocean_tab.FL_Move_Variance, false)
            ui.set_visible(Ocean_tab.FL_Move_Limit, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Override , false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Amount, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Variance, false)
            ui.set_visible(Ocean_tab.FL_Slowwalk_Limit, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Override , false)
            ui.set_visible(Ocean_tab.FL_In_Air_Amount, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Variance, false)
            ui.set_visible(Ocean_tab.FL_In_Air_Limit, false)
        end
    else
        --Invisble
        ui.set_visible(refs.FL_Check1, true)
        ui.set_visible(refs.FL_Check2, true)
        ui.set_visible(refs.FL_Amount, true)
        ui.set_visible(refs.FL_Variance, true)
        ui.set_visible(refs.FL_Limit, true)
        --Visble
        ui.set_visible(Ocean_tab.FL_Enable, false)
        ui.set_visible(Ocean_tab.FL_Restrict, false)
        ui.set_visible(Ocean_tab.FL_Key, false)
        ui.set_visible(Ocean_tab.FL_State, false)
        ui.set_visible(Ocean_tab.FL_Global_Amount, false)
        ui.set_visible(Ocean_tab.FL_Global_Variance, false)
        ui.set_visible(Ocean_tab.FL_Global_Limit, false)
        ui.set_visible(Ocean_tab.FL_Stand_Override , false)
        ui.set_visible(Ocean_tab.FL_Stand_Amount, false)
        ui.set_visible(Ocean_tab.FL_Stand_Variance, false)
        ui.set_visible(Ocean_tab.FL_Stand_Limit, false)
        ui.set_visible(Ocean_tab.FL_Duck_Override , false)
        ui.set_visible(Ocean_tab.FL_Duck_Amount, false)
        ui.set_visible(Ocean_tab.FL_Duck_Variance, false)
        ui.set_visible(Ocean_tab.FL_Duck_Limit, false)
        ui.set_visible(Ocean_tab.FL_Move_Override , false)
        ui.set_visible(Ocean_tab.FL_Move_Amount, false)
        ui.set_visible(Ocean_tab.FL_Move_Variance, false)
        ui.set_visible(Ocean_tab.FL_Move_Limit, false)
        ui.set_visible(Ocean_tab.FL_Slowwalk_Override , false)
        ui.set_visible(Ocean_tab.FL_Slowwalk_Amount, false)
        ui.set_visible(Ocean_tab.FL_Slowwalk_Variance, false)
        ui.set_visible(Ocean_tab.FL_Slowwalk_Limit, false)
        ui.set_visible(Ocean_tab.FL_In_Air_Override , false)
        ui.set_visible(Ocean_tab.FL_In_Air_Amount, false)
        ui.set_visible(Ocean_tab.FL_In_Air_Variance, false)
        ui.set_visible(Ocean_tab.FL_In_Air_Limit, false)
    end  

    if ui.get(Ocean_tab.MasterSwitch) then
        --invisble
        ui.set_visible(refs.SW_Check1, false)
        ui.set_visible(refs.SW_Check2, false)
        ui.set_visible(refs.Leg_mvt, false)
        ui.set_visible(refs.OS_Check1, false)
        ui.set_visible(refs.OS_Check2, false)
        --visble
        ui.set_visible(Ocean_tab.Other_Slowwalk, true)
        ui.set_visible(Ocean_tab.Other_Slowwalk_Key, true)
        ui.set_visible(Ocean_tab.Other_Leg_movement, true)
        ui.set_visible(Ocean_tab.Other_Hideshots, true)
        ui.set_visible(Ocean_tab.Other_Hideshots_Key, true)
    else
        --visble
        ui.set_visible(refs.SW_Check1, true)
        ui.set_visible(refs.SW_Check2, true)
        ui.set_visible(refs.Leg_mvt, true)
        ui.set_visible(refs.OS_Check1, true)
        ui.set_visible(refs.OS_Check2, true)
        --invisble
        ui.set_visible(Ocean_tab.Other_Slowwalk, false)
        ui.set_visible(Ocean_tab.Other_Slowwalk_Key, false)
        ui.set_visible(Ocean_tab.Other_Leg_movement, false)
        ui.set_visible(Ocean_tab.Other_Hideshots, false)
        ui.set_visible(Ocean_tab.Other_Hideshots_Key, false)
    end

end
--LynxPrediction


-- Function to calculate vector angles
local function calculateVectorAngles(vector1, vector2)
    local vectorA, vectorB
    if vector2 == nil then
        vectorB, vectorA = vector1, vector(client.eye_position())
        if vectorA.x == nil then
            return
        end
    else
        vectorA, vectorB = vector1, vector2
    end
    local vectorDiff = vectorB - vectorA
    if vectorDiff.x == 0 and vectorDiff.y == 0 then
        return 0, vectorDiff.z > 0 and 270 or 90
    else
        local angleY = math.deg(math.atan2(vectorDiff.y, vectorDiff.x))
        local hypotenuse = math.sqrt(vectorDiff.x * vectorDiff.x + vectorDiff.y * vectorDiff.y)
        local angleX = math.deg(math.atan2(-vectorDiff.z, hypotenuse))
        return angleX, angleY
    end
end

-- Function to check overlap
local function checkOverlap(object1, object2)
    if object1 and not object2 then
        return object1
    elseif not object1 and object2 then
        return object2
    end
    if object1.is_active and object2.is_active then
        if object1.length < object2.length then
            object2.is_active = false
            return object1
        elseif object1.length > object2.length then
            object1.is_active = false
            return object2
        end
    else
        return object1.is_active and object1 or object2
    end
end

-- Function to scan side
local function scanSide(entityIndex, origin, target, direction, position, side)
    local scanLength, hitFraction, counter = 15, 0, 0
    local previousPosition = position
    while hitFraction < 1 and scanLength < scan_length do
        position = origin + direction * scanLength
        _, hitFraction = client.trace_bullet(entityIndex, target.x, target.y, target.z, position.x, position.y, position.z)
        scanLength = scanLength + scan_width

		local fraction, entity_index = client.trace_line( entity.get_local_player(),
			previousPosition.x, previousPosition.y, previousPosition.z,
			position.x, position.y, position.z
		)
        if fraction < 1 and counter > 4 then
            return nil
        end
        previousPosition = position
        counter = counter + 1
    end
    return scanLength <= scan_length and {is_active = true, vector = position, index = entityIndex, length = scanLength, side = side} or nil
end

-- Function to calculate right angle
local function calculateRightAngle(angle)
    local sinX = math.sin(math.rad(angle.x))
    local cosX = math.cos(math.rad(angle.x))
    local sinY = math.sin(math.rad(angle.y))
    local cosY = math.cos(math.rad(angle.y))
    local sinZ = math.sin(math.rad(angle.z))
    local cosZ = math.cos(math.rad(angle.z))
    return vector(-1.0 * sinZ * sinX * cosY + -1.0 * cosZ * -sinY, -1.0 * sinZ * sinX * sinY + -1.0 * cosZ * cosY, -1.0 * sinZ * cosX)
end

-- Function to get scan result
local function getScanResult(entityIndex)
    if entityIndex == -1 then
        return nil
    end
    if not entity.is_alive(entityIndex) or not entity.is_enemy(entityIndex) then
        return nil
    end
    local localPlayer = entity.get_local_player()
    local eyePosition = vector(client.eye_position())
    local localOrigin = vector(entity.get_origin(localPlayer))
    local entityOrigin = vector(entity.get_prop(entityIndex, "m_vecOrigin"))
    local entityView = entityOrigin + vector(entity.get_prop(entityIndex, "m_vecViewOffset"))
    local angleX, angleY = calculateVectorAngles(localOrigin, entityOrigin)
    local angleVector = vector(angleX, angleY, 0)
    local rightAngleVector = calculateRightAngle(angleVector)
    local leftAngleVector = rightAngleVector*-1
    local leftPosition = eyePosition + leftAngleVector * scan_width
    local rightPosition = eyePosition + rightAngleVector * scan_width
    local hitboxPosition = vector(entity.hitbox_position(localPlayer, 1))
    local _, hitFraction = client.trace_bullet(entityIndex, entityView.x, entityView.y, entityView.z, hitboxPosition.x, hitboxPosition.y, hitboxPosition.z)
    if hitFraction <= 0 then
        local leftScan = scanSide(entityIndex, eyePosition, entityView, leftAngleVector, leftPosition, "left")
        local rightScan = scanSide(entityIndex, eyePosition, entityView, rightAngleVector, rightPosition, "right")
        return (leftScan or rightScan) and checkOverlap(leftScan, rightScan) or nil
    else
        return nil
    end
end

-- Define main functions
local function angleScan()
    local target = client.current_threat()
	if not target then return end

    local target_result = getScanResult(target)
    local t_scan_result = getScanResult(scan_result and scan_result.index or -1)      

    if not t_scan_result and target_result then
        scan_result = target_result
    elseif t_scan_result and target_result then   
        scan_result = target_result.length < t_scan_result.length and target_result or t_scan_result
    elseif not t_scan_result and not target_result then
        scan_result = nil
    end
end

local function drawHitLines()
    if not scan_result then return end

    local local_player  = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    local local_origin  = vector(entity.get_origin(local_player))
	local target = client.current_threat()
	if target == nil then return end
	local target_name = entity.get_player_name(target)
	local target_health = entity.get_prop(target, 'm_iHealth')


    local tr, tg, tb, ta = ui.get(Ocean_tab.Misc_Peek_Prediction_color)
    local lr, lg, lb, la = ui.get(Ocean_tab.Misc_Peek_Prediction_color2)

    local pos = scan_result.vector
    local xl, yl = renderer.world_to_screen(pos.x, pos.y, pos.z)

    if ui.get(Ocean_tab.Misc_Peek_Prediction_Selection) == "Hit" then
        Draw_Text = "Hit"
    elseif ui.get(Ocean_tab.Misc_Peek_Prediction_Selection) == "Name" then
        Draw_Text = target_name
    elseif ui.get(Ocean_tab.Misc_Peek_Prediction_Selection) == "Name(Health)" then
        Draw_Text = target_name.."("..target_health..")"
    end

    if xl ~= nil and yl ~= nil then
        local x, y = renderer.world_to_screen(pos.x, pos.y, local_origin.z)
        renderer.text(xl, yl - 15, tr, tg, tb, ta, "bcd", 0, Draw_Text)
        renderer.line(xl, yl, x, y, lr, lg, lb, la)    
    end
end

local function paint()
	local local_player = entity.get_local_player()
	if not local_player then return end
    
    local is_alive = entity.is_alive(local_player)
    if not is_alive then return end

    scan_width, scan_length = 2 * 2, 4 * 40

    drawHitLines()
end


local function on_enable()
	local enabled = ui.get(Ocean_tab.Misc_Peek_Prediction)
	local call = client[enabled and 'set_event_callback' or 'unset_event_callback']
	call('paint', paint)
	call('run_command', angleScan)
end
ui.set_callback(Ocean_tab.Misc_Peek_Prediction, on_enable)
--END

local function time_to_ticks(time)
	return math.floor(time / globals.tickinterval() + .5)
end

function containsSymbol(str, symbol)
    local symbolBytes = {symbol:byte(1, -1)}
    local symbolLength = #symbolBytes

    for i = 1, #str do
        local char = str:byte(i, i + symbolLength - 1)
        if char == symbolBytes[1] then
            local match = true
            for j = 2, symbolLength do
                if str:byte(i + j - 1) ~= symbolBytes[j] then
                    match = false
                    break
                end
            end
            if match then
                return true
            end
        end
    end

    return false
end

local function distance_to_dynamic_fov(min, max, dist)
	if dist >= DYNAMIC_FOV_MIN_DISTANCE then
		return min
	elseif dist <= DYNAMIC_FOV_MAX_DISTANCE then
		return max
	end
	
	return math.min(max, math.max(min, DYNAMIC_FOV_DISTANCE_SCALE / dist))
end

-- Iterates over all valid targets
local function iter_enemies(lambda)
	local anEnemies = entity.get_players(true)

	for i = 1, #anEnemies do
		lambda(anEnemies[i])
	end
end

local function is_valid_target(ent)
	return ent ~= nil and not entity.is_dormant(ent) and entity.is_alive(ent)
end

local function get_closest_enemy_distance()
	local nLocalPlayer = entity.get_local_player()
	local flaLocalHead = vector(client.eye_position())
	local flMinimumDistance = DYNAMIC_FOV_DISTANCE_SCALE

	iter_enemies(function(target)
		local flaEnemyHead = vector(entity.hitbox_position(target, hitbox_e.head))
		local flDistance = flaLocalHead:dist(flaEnemyHead)
		
		if flDistance < flMinimumDistance then
			flMinimumDistance = flDistance
		end
	end)
	
	return flMinimumDistance
end


local function is_rage_aimbot_running() 
	return ui.get(Ocean_tab.Aimbot_Autofire) and ui.get(Ocean_tab.Aimbot_Autofire_hotkey)
end

local function get_screen_center()
	local width, height = client.screen_size()

	return { width / 2, height / 2 }
end

local function get_distance_2d(pos1, pos2)
	return math.sqrt(math.pow((pos1[1] - pos2[1]), 2) + math.pow((pos1[2] - pos2[2]), 2))
end

local function get_closest_target_crosshair()
	local anCenter = get.screen_center()
	local nTarget = nil
	local flClosest = 8192.0

	iter_enemies(function(target)
		local flX, flY, flZ = entity.hitbox_position(target, hitbox_e.head)
		local nX, nY = renderer.world_to_screen(flX, flY, flZ)

		-- Not on screen..
		if nX == nil then
			return
		end

		local flDistance = get_distance_2d(anCenter, { nX, nY })

		if flDistance < flClosest then
			flClosest = flDistance
			nTarget = target
		end
	end)

	return nTarget
end

local function update_ignore_behind_smokes()
	if ui.get(Ocean_tab.Aimbot_Autofire)==true and not ui.get(Ocean_tab.Aimbot_Autofire_hotkey) then
		return
	end
	local bSmokeExists = false
	local anSmokeGrenadeProjectiles = entity.get_all("CSmokeGrenadeProjectile")
	local nTickCount = globals.tickcount()
	local flTickInterval = globals.tickinterval()

	for i = 1, #anSmokeGrenadeProjectiles do
		if entity.get_prop(anSmokeGrenadeProjectiles[i], "m_bDidSmokeEffect") == 1 and nTickCount < entity.get_prop(anSmokeGrenadeProjectiles[i], "m_nSmokeEffectTickBegin") + SMOKE_PERSISTANCE_TIMER / flTickInterval then
			bSmokeExists = true
		end
	end

	if not bSmokeExists then
		return
	end

	local flLocalX, flLocalY, flLocalZ = client.eye_position()

	iter_enemies(function(target)
		-- Don't run the code on anyone if enemy is already whitelisted..
		if g_anUserWhitelisted[target] then
			return
		end

		local bWhitelist = true

		for i = 1, #SMOKE_HITBOXES do
			-- If we already know that the target is visible, there is no reason to run more checks. Break out of the loop, and move on to the next target
			if not bWhitelist then
				break
			end

			-- "multipoints" XD. It works though! :)
			local flaEnemyHitbox = vector(entity.hitbox_position(target, SMOKE_HITBOXES[i]))

			for j = 1, #VISIBILITY_DIRECTIONS do
				if not g_pfnLineGoesThroughSmoke(flLocalX, flLocalY, flLocalZ, flaEnemyHitbox.x + VISIBILITY_DIRECTIONS[j][1], flaEnemyHitbox.y + VISIBILITY_DIRECTIONS[j][2], flaEnemyHitbox.z) then
					bWhitelist = false
	
					break
				end
			end
		end

		if bWhitelist then
			g_anUserWhitelisted[target] = true
		end
	end)
end

local function get_weapon_definition_index(ent)
	local nWeapon = entity.get_player_weapon(ent)

	if nWeapon ~= nil then
		return entity.get_prop(nWeapon, "m_iItemDefinitionIndex")
	end

	return nil
end

local function update_honor_flashbangs()
	if not ui.get(Ocean_tab.Aimbot_Autofire) and ui.get(Ocean_tab.Aimbot_Autofire_hotkey) or  ui.get(Ocean_tab.Aimbot_Autopenetration)==true and ui.get(Ocean_tab.Aimbot_Autopenetration_hotkey) then
		return
	end

	local nLocalPlayer = entity.get_local_player()
	local nWeapon = get_weapon_definition_index(nLocalPlayer)
	local cPrefix = string.sub(csgo_weapon[nWeapon].type, 1, 1)
	
	if cPrefix ~= 'p' and -- pistol
		cPrefix ~= 's' and -- smg, shotgun, sniperrifle
		cPrefix ~= 'r' and -- rifle
		cPrefix ~= 'm' then -- machinegun
		return
	end

	local flFlashDuration = entity.get_prop(nLocalPlayer, "m_flFlashDuration")
	local flBlindnessThreshold = 44 * 0.05
	local flCurtime = globals.curtime()

	if flFlashDuration > 0.0 then
		if g_flFlashDurationCache == 0.0 then
			g_flLastFlashUpdate = flCurtime
		end

		if flCurtime - g_flLastFlashUpdate < flFlashDuration - flBlindnessThreshold then
			iter_enemies(function(target)
				g_anUserWhitelisted[target] = true
			end)
		end
	end

	g_flFlashDurationCache = flFlashDuration
end

local function update_whitelist()
	iter_enemies(function(target)
		plist.set(target, "Add to whitelist", g_anUserWhitelisted[target])
	end)

	g_anUserWhitelisted = {}
end

local SE_Detect = ""
local SelfEdge = function(player)
    --ui.set(references.body_yaw[1], "Static")
    if player == nil then return end
    local eyepos_x, eyepos_y, eyepos_z = entity.get_prop(player, "m_vecAbsOrigin")
    local offsetx, offsety, offsetz = entity.get_prop(player, "m_vecViewOffset")
    eyepos_z = eyepos_z + offsetz
    local lowestfrac = 1
    local dir = false
    local desync = entity.get_prop(player, "m_flPoseParameter", 11) * 120 - 60
    local cpitch, cyaw = entity.get_prop(player, "m_angRotation")
    local fractionleft, fractionright = 0, 0
    local amountleft, amountright = 0, 0
    for i = -70, 70, 5 do
        if i ~= 0 then

            local fwdx, fwdy, fwdz = libary.vectorangle(0, cyaw + i + desync, 0)
            fwdx, fwdy, fwdz = libary.multiplyvalues(fwdx, fwdy, fwdz, 70)

            local fraction =
                client.trace_line(
                player,
                eyepos_x,
                eyepos_y,
                eyepos_z,
                eyepos_x + fwdx,
                eyepos_y + fwdy,
                eyepos_z + fwdz
            )

            local outx, outy = renderer.world_to_screen(eyepos_x + fwdx, eyepos_y + fwdy, eyepos_z + fwdz)

           
            if i > 0 then
                fractionleft = fractionleft + fraction
                amountleft = amountleft + 1
            else
                fractionright = fractionright + fraction
                amountright = amountright + 1
            end

        end

    end

    local averageleft, averageright = fractionleft / amountleft, fractionright / amountright

    if averageleft < averageright then
        SE_Detect = "left"
    elseif averageleft > averageright then
        SE_Detect = "right"
    else
        SE_Detect = "none"
    end

end

local micro_move = function(cmd)
    if not ui.get(Ocean_tab.MasterSwitch) then return end
    local local_player = entity.get_local_player()
    local game_rule = entity.get_game_rules()
    local Tpitch, Tyaw = entity.get_prop (local_player, 'm_angEyeAngles')
    if cmd.chokedcommands == 0 or ent_state.speed(local_player) > 2 or cmd.in_use == 1 or cmd.in_attack == 1 or is_freezetime() then return end
    if  ui.get(refs.slow[1]) and ui.get(refs.slow[2]) and ent_state.speed(local_player) > 15 then
        cmd.forwardmove = 0.1
        cmd.in_forward = 0
    else
        cmd.forwardmove = 0.1
        cmd.in_forward = 1
    end
end

local AA_Brute = false

local brute_reset = function()
    AA_Brute = false
end

local function bullet_impact(e)
    local shooter = client.userid_to_entindex(e.userid)
    if not entity.is_enemy(shooter) or not entity.is_alive(entity.get_local_player()) then return end

    local shot_start_pos 	= vector(entity.get_prop(shooter, "m_vecOrigin"))
	shot_start_pos.z 		= shot_start_pos.z + entity.get_prop(shooter, "m_vecViewOffset[2]")
	local eye_pos			= vector(client.eye_position())
	local shot_end_pos 		= vector(e.x, e.y, e.z)
	local closest			= vectorDist(shot_start_pos, shot_end_pos, eye_pos)

    if closest < 32 then 
        if AA_Brute == false and can_brute == true then
            AA_Brute = true
            can_brute = false
        elseif AA_Brute == true and can_brute == true then
            AA_Brute = false
            can_brute = false
        end
    end
    can_brute = true
end
local get_state = function(cmd)
    local plocal = entity.get_local_player()
	local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
	local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
    local flags = entity.get_prop(plocal, "m_fFlags")
    local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and cmd.in_jump == 0
    local p_slow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
    local old_state = state
	if bit.band(flags, 1) == 0 then
		state = "in_air"
        if state ~= old_state then  
            brute_reset()
        end
    elseif cmd.in_duck == 1 and on_ground or ui.get(refs.duck) then
        state = "duck"
        if state ~= old_state then  
            brute_reset()
        end
    elseif p_slow then
        state = "slowwalk"
        if state ~= old_state then  
            brute_reset()
        end
    elseif not p_still then
        state = "move"
        if state ~= old_state then  
            brute_reset()
        end
    elseif p_still then
        state = "stand"
        if state ~= old_state then  
            brute_reset()
        end
	end

end

local side = false
client.set_event_callback('setup_command', function(cmd)
    if cmd.chokedcommands == 0 then
        local lp_bodyyaw = entity.get_prop(entity.get_local_player(), 'm_flPoseParameter', 11) * 120 - 60
        side = lp_bodyyaw < 0 
    end
end)
local roll_amount = 0
local body_side = 0
local statee = ""
local roll_value = 0
local Main = function(cmd)
    if not ui.get(Ocean_tab.MasterSwitch) then return end
    local local_player = entity.get_local_player()
    local L = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Lower Body Yaw")
    local R = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Roll")
    local Dis_fake = table_contains(ui.get(Ocean_tab.AntiAim_Disablers), "While Fakeduck")
    local Dis_out = table_contains(ui.get(Ocean_tab.AntiAim_Disablers), "Tabbed Out")
    local Dis_fps = table_contains(ui.get(Ocean_tab.AntiAim_Disablers), "Low FPS")
    if ui.get(Ocean_tab.MasterSwitch)==true and ui.get(Ocean_tab.AntiAim_Enable)==true then

        if Dis_fake and ui.get(refs.duck) or Dis_out and engineclient.is_app_active()==false or Dis_fps and math.floor(1 / globals.absoluteframetime() + 0.5) < 60 then
            ui.set(AntiAim_tab.enabled, false)
        else
            ui.set(AntiAim_tab.enabled, true)
        end

    else
        ui.set(AntiAim_tab.enabled, false)
    end

    if state == "stand" then
        if ui.get(Ocean_tab.AntiAim_Stand_BodyYaw)=="Freestand" then
            if L then
                if SE_Detect == "left" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Stand_Reverse) then
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Stand_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Stand_Reverse) then
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    end
                elseif SE_Detect == "right" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Stand_Reverse) then
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Stand_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Stand_Reverse) then
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    end
                elseif SE_Detect == "none" then
                    if ui.get(Ocean_tab.AntiAim_Stand_Open) == "Opposite" then
                        ui.set(refs.body, "Static")
                        if AA_Brute == false then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60)
                            body_side = ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60
                        elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Stand_Brute) then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60)
                            body_side = ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60
                        end
                    elseif ui.get(Ocean_tab.AntiAim_Stand_Open) == "Jitter" then
                        ui.set(refs.body, "Jitter")
                        body_side = 0
                        ui.set(AntiAim_tab.body_val, 0)
                    end
                end
            else
                if SE_Detect == "left" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Stand_Reverse) then
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Stand_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Stand_Reverse) then
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    end
                elseif SE_Detect == "right" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Stand_Reverse) then
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Stand_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Stand_Reverse) then
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    end
                elseif SE_Detect == "none" then
                    if ui.get(Ocean_tab.AntiAim_Stand_Open) == "Opposite" then
                        ui.set(refs.body, "Static")
                        if AA_Brute == false then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60)
                        elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Stand_Brute) then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60)
                        end
                    elseif ui.get(Ocean_tab.AntiAim_Stand_Open) == "Jitter" then
                        ui.set(refs.body, "Jitter")
                        body_side = 0
                        ui.set(AntiAim_tab.body_val, 0)
                    end
                end
            end
        elseif ui.get(Ocean_tab.AntiAim_Stand_BodyYaw)=="Opposite" then
            if L then
                ui.set(refs.body, "Static")
                if ui.get(Ocean_tab.AntiAim_Inverter) then 
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, 60)
                        body_side = 60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Stand_Brute) then
                        ui.set(AntiAim_tab.body_val, -60)
                        body_side = -60
                    end
                else
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, -60)
                        body_side = -60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Stand_Brute) then
                        ui.set(AntiAim_tab.body_val, 60)
                        body_side = 60
                    end
                end
            else
                ui.set(refs.body, "Static")
                if ui.get(Ocean_tab.AntiAim_Inverter) then 
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, 1)
                        body_side = 60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Stand_Brute) then
                        ui.set(AntiAim_tab.body_val, -1)
                        body_side = -60
                    end
                else
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, -1)
                        body_side = -60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Stand_Brute) then
                        ui.set(AntiAim_tab.body_val, 1)
                        body_side = 60
                    end
                end
            end
        elseif ui.get(Ocean_tab.AntiAim_Stand_BodyYaw)=="Jitter" then
            ui.set(refs.body, "Jitter")
            body_side = 0
            ui.set(AntiAim_tab.body_val, 0)
        end
        if side==false then 
            if ui.get(Ocean_tab.Misc_Untrusted)==true then
                roll_amount = ui.get(Ocean_tab.AntiAim_Stand_Untrusted_L)
            else
                roll_amount = ui.get(Ocean_tab.AntiAim_Stand_Roll_L)
            end
        else
            if ui.get(Ocean_tab.Misc_Untrusted)==true then
                roll_amount = ui.get(Ocean_tab.AntiAim_Stand_Untrusted_R)
            else
                roll_amount = ui.get(Ocean_tab.AntiAim_Stand_Roll_R)
            end
        end
        if ui.get(Ocean_tab.AntiAim_Stand_Roll)==false then
            roll_amount = 0
        end
        statee = "STAND"
    elseif state == "duck" then
        if ui.get(Ocean_tab.AntiAim_Duck_BodyYaw)=="Freestand" then
            if L then
                if SE_Detect == "left" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Duck_Reverse) then
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Duck_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Duck_Reverse) then
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    end
                elseif SE_Detect == "right" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Duck_Reverse) then
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Duck_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Duck_Reverse) then
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    end
                elseif SE_Detect == "none" then
                    if ui.get(Ocean_tab.AntiAim_Duck_Open) == "Opposite" then
                        ui.set(refs.body, "Static")
                        if AA_Brute == false then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60)
                            body_side = ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60
                        elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Duck_Brute) then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60)
                            body_side = ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60
                        end
                    elseif ui.get(Ocean_tab.AntiAim_Duck_Open) == "Jitter" then
                        ui.set(refs.body, "Jitter")
                        body_side = 0
                        ui.set(AntiAim_tab.body_val, 0)
                    end
                end
            else
                if SE_Detect == "left" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Duck_Reverse) then
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Duck_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Duck_Reverse) then
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    end
                elseif SE_Detect == "right" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Duck_Reverse) then
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Duck_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Duck_Reverse) then
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    end
                elseif SE_Detect == "none" then
                    if ui.get(Ocean_tab.AntiAim_Duck_Open) == "Opposite" then
                        ui.set(refs.body, "Static")
                        if AA_Brute == false then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60)
                        elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Duck_Brute) then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60)
                        end
                    elseif ui.get(Ocean_tab.AntiAim_Duck_Open) == "Jitter" then
                        ui.set(refs.body, "Jitter")
                        body_side = 0
                        ui.set(AntiAim_tab.body_val, 0)
                    end
                end
            end
        elseif ui.get(Ocean_tab.AntiAim_Duck_BodyYaw)=="Opposite" then
            if L then
                ui.set(refs.body, "Static")
                if ui.get(Ocean_tab.AntiAim_Inverter) then 
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, 60)
                        body_side = 60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Duck_Brute) then
                        ui.set(AntiAim_tab.body_val, -60)
                        body_side = -60
                    end
                else
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, -60)
                        body_side = -60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Duck_Brute) then
                        ui.set(AntiAim_tab.body_val, 60)
                        body_side = 60
                    end
                end
            else
                ui.set(refs.body, "Static")
                if ui.get(Ocean_tab.AntiAim_Inverter) then 
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, 1)
                        body_side = 60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Duck_Brute) then
                        ui.set(AntiAim_tab.body_val, -1)
                        body_side = -60
                    end
                else
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, -1)
                        body_side = -60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Duck_Brute) then
                        ui.set(AntiAim_tab.body_val, 1)
                        body_side = 60
                    end
                end
            end
        elseif ui.get(Ocean_tab.AntiAim_Duck_BodyYaw)=="Jitter" then
            ui.set(refs.body, "Jitter")
            body_side = 0
            ui.set(AntiAim_tab.body_val, 0)
        end
        if side==false then 
            if ui.get(Ocean_tab.Misc_Untrusted)==true then
                roll_amount = ui.get(Ocean_tab.AntiAim_Duck_Untrusted_L)
            else
                roll_amount = ui.get(Ocean_tab.AntiAim_Duck_Roll_L)
            end
        else
            if ui.get(Ocean_tab.Misc_Untrusted)==true then
                roll_amount = ui.get(Ocean_tab.AntiAim_Duck_Untrusted_R)
            else
                roll_amount = ui.get(Ocean_tab.AntiAim_Duck_Roll_R)
            end
        end
        if ui.get(Ocean_tab.AntiAim_Duck_Roll)==false then
            roll_amount = 0
        end
        statee = "DUCK"
    elseif state == "move" then
        if ui.get(Ocean_tab.AntiAim_Move_BodyYaw)=="Freestand" then
            if L then
                if SE_Detect == "left" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Move_Reverse) then
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Move_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Move_Reverse) then
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    end
                elseif SE_Detect == "right" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Move_Reverse) then
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Move_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Move_Reverse) then
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    end
                elseif SE_Detect == "none" then
                    if ui.get(Ocean_tab.AntiAim_Move_Open) == "Opposite" then
                        ui.set(refs.body, "Static")
                        if AA_Brute == false then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60)
                            body_side = ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60
                        elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Move_Brute) then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60)
                            body_side = ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60
                        end
                    elseif ui.get(Ocean_tab.AntiAim_Move_Open) == "Jitter" then
                        ui.set(refs.body, "Jitter")
                        body_side = 0
                        ui.set(AntiAim_tab.body_val, 0)
                    end
                end
            else
                if SE_Detect == "left" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Move_Reverse) then
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Move_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Move_Reverse) then
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    end
                elseif SE_Detect == "right" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Move_Reverse) then
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Move_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Move_Reverse) then
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    end
                elseif SE_Detect == "none" then
                    if ui.get(Ocean_tab.AntiAim_Move_Open) == "Opposite" then
                        ui.set(refs.body, "Static")
                        if AA_Brute == false then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60)
                        elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Move_Brute) then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60)
                        end
                    elseif ui.get(Ocean_tab.AntiAim_Move_Open) == "Jitter" then
                        ui.set(refs.body, "Jitter")
                        body_side = 0
                        ui.set(AntiAim_tab.body_val, 0)
                    end
                end
            end
        elseif ui.get(Ocean_tab.AntiAim_Move_BodyYaw)=="Opposite" then
            if L then
                ui.set(refs.body, "Static")
                if ui.get(Ocean_tab.AntiAim_Inverter) then 
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, 60)
                        body_side = 60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Move_Brute) then
                        ui.set(AntiAim_tab.body_val, -60)
                        body_side = -60
                    end
                else
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, -60)
                        body_side = -60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Move_Brute) then
                        ui.set(AntiAim_tab.body_val, 60)
                        body_side = 60
                    end
                end
            else
                ui.set(refs.body, "Static")
                if ui.get(Ocean_tab.AntiAim_Inverter) then 
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, 1)
                        body_side = 60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Move_Brute) then
                        ui.set(AntiAim_tab.body_val, -1)
                        body_side = -60
                    end
                else
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, -1)
                        body_side = -60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Move_Brute) then
                        ui.set(AntiAim_tab.body_val, 1)
                        body_side = 60
                    end
                end
            end
        elseif ui.get(Ocean_tab.AntiAim_Move_BodyYaw)=="Jitter" then
            ui.set(refs.body, "Jitter")
            body_side = 0
            ui.set(AntiAim_tab.body_val, 0)
        end
        if side==false then 
            if ui.get(Ocean_tab.Misc_Untrusted)==true then
                roll_amount = ui.get(Ocean_tab.AntiAim_Move_Untrusted_L)
            else
                roll_amount = ui.get(Ocean_tab.AntiAim_Move_Roll_L)
            end
        else
            if ui.get(Ocean_tab.Misc_Untrusted)==true then
                roll_amount = ui.get(Ocean_tab.AntiAim_Move_Untrusted_R)
            else
                roll_amount = ui.get(Ocean_tab.AntiAim_Move_Roll_R)
            end
        end
        if ui.get(Ocean_tab.AntiAim_Move_Roll)==false then
            roll_amount = 0
        end
        statee = "MOVE"
    elseif state == "slowwalk" then
        if ui.get(Ocean_tab.AntiAim_Slowwalk_BodyYaw)=="Freestand" then
            if L then
                if SE_Detect == "left" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Slowwalk_Reverse) then
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Slowwalk_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Slowwalk_Reverse) then
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    end
                elseif SE_Detect == "right" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Slowwalk_Reverse) then
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Slowwalk_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Slowwalk_Reverse) then
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    end
                elseif SE_Detect == "none" then
                    if ui.get(Ocean_tab.AntiAim_Slowwalk_Open) == "Opposite" then
                        ui.set(refs.body, "Static")
                        if AA_Brute == false then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60)
                            body_side = ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60
                        elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Slowwalk_Brute) then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60)
                            body_side = ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60
                        end
                    elseif ui.get(Ocean_tab.AntiAim_Slowwalk_Open) == "Jitter" then
                        ui.set(refs.body, "Jitter")
                        body_side = 0
                        ui.set(AntiAim_tab.body_val, 0)
                    end
                end
            else
                if SE_Detect == "left" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Slowwalk_Reverse) then
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Slowwalk_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Slowwalk_Reverse) then
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    end
                elseif SE_Detect == "right" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_Slowwalk_Reverse) then
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Slowwalk_Brute) then
                        if ui.get(Ocean_tab.AntiAim_Slowwalk_Reverse) then
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    end
                elseif SE_Detect == "none" then
                    if ui.get(Ocean_tab.AntiAim_Slowwalk_Open) == "Opposite" then
                        ui.set(refs.body, "Static")
                        if AA_Brute == false then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60)
                        elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Slowwalk_Brute) then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60)
                        end
                    elseif ui.get(Ocean_tab.AntiAim_Slowwalk_Open) == "Jitter" then
                        ui.set(refs.body, "Jitter")
                        body_side = 0
                        ui.set(AntiAim_tab.body_val, 0)
                    end
                end
            end
        elseif ui.get(Ocean_tab.AntiAim_Slowwalk_BodyYaw)=="Opposite" then
            if L then
                ui.set(refs.body, "Static")
                if ui.get(Ocean_tab.AntiAim_Inverter) then 
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, 60)
                        body_side = 60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Slowwalk_Brute) then
                        ui.set(AntiAim_tab.body_val, -60)
                        body_side = -60
                    end
                else
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, -60)
                        body_side = -60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Slowwalk_Brute) then
                        ui.set(AntiAim_tab.body_val, 60)
                        body_side = 60
                    end
                end
            else
                ui.set(refs.body, "Static")
                if ui.get(Ocean_tab.AntiAim_Inverter) then 
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, 1)
                        body_side = 60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Slowwalk_Brute) then
                        ui.set(AntiAim_tab.body_val, -1)
                        body_side = -60
                    end
                else
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, -1)
                        body_side = -60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_Slowwalk_Brute) then
                        ui.set(AntiAim_tab.body_val, 1)
                        body_side = 60
                    end
                end
            end
        elseif ui.get(Ocean_tab.AntiAim_Slowwalk_BodyYaw)=="Jitter" then
            ui.set(refs.body, "Jitter")
            body_side = 0
            ui.set(AntiAim_tab.body_val, 0)
        end
        if side==false then 
            if ui.get(Ocean_tab.Misc_Untrusted)==true then
                roll_amount = ui.get(Ocean_tab.AntiAim_Slowwalk_Untrusted_L)
            else
                roll_amount = ui.get(Ocean_tab.AntiAim_Slowwalk_Roll_L)
            end
        else
            if ui.get(Ocean_tab.Misc_Untrusted)==true then
                roll_amount = ui.get(Ocean_tab.AntiAim_Slowwalk_Untrusted_R)
            else
                roll_amount = ui.get(Ocean_tab.AntiAim_Slowwalk_Roll_R)
            end
        end
        if ui.get(Ocean_tab.AntiAim_Slowwalk_Roll)==false then
            roll_amount = 0
        end
        statee = "SLOW"
    elseif state == "in_air" then
        if ui.get(Ocean_tab.AntiAim_In_Air_BodyYaw)=="Freestand" then
            if L then
                if SE_Detect == "left" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_In_Air_Reverse) then
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_In_Air_Brute) then
                        if ui.get(Ocean_tab.AntiAim_In_Air_Reverse) then
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    end
                elseif SE_Detect == "right" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_In_Air_Reverse) then
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_In_Air_Brute) then
                        if ui.get(Ocean_tab.AntiAim_In_Air_Reverse) then
                            body_side = 60
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            body_side = -60
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    end
                elseif SE_Detect == "none" then
                    if ui.get(Ocean_tab.AntiAim_In_Air_Open) == "Opposite" then
                        ui.set(refs.body, "Static")
                        if AA_Brute == false then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60)
                            body_side = ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60
                        elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_In_Air_Brute) then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60)
                            body_side = ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60
                        end
                    elseif ui.get(Ocean_tab.AntiAim_In_Air_Open) == "Jitter" then
                        ui.set(refs.body, "Jitter")
                        body_side = 0
                        ui.set(AntiAim_tab.body_val, 0)
                    end
                end
            else
                if SE_Detect == "left" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_In_Air_Reverse) then
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_In_Air_Brute) then
                        if ui.get(Ocean_tab.AntiAim_In_Air_Reverse) then
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    end
                elseif SE_Detect == "right" then
                    ui.set(refs.body, "Static")
                    if AA_Brute == false then
                        if ui.get(Ocean_tab.AntiAim_In_Air_Reverse) then
                            ui.set(AntiAim_tab.body_val, -60)
                        else
                            ui.set(AntiAim_tab.body_val, 60)
                        end
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_In_Air_Brute) then
                        if ui.get(Ocean_tab.AntiAim_In_Air_Reverse) then
                            ui.set(AntiAim_tab.body_val, 60)
                        else
                            ui.set(AntiAim_tab.body_val, -60)
                        end
                    end
                elseif SE_Detect == "none" then
                    if ui.get(Ocean_tab.AntiAim_In_Air_Open) == "Opposite" then
                        ui.set(refs.body, "Static")
                        if AA_Brute == false then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and 60 or -60)
                        elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_In_Air_Brute) then
                            ui.set(AntiAim_tab.body_val, ui.get(Ocean_tab.AntiAim_Inverter) and -60 or 60)
                        end
                    elseif ui.get(Ocean_tab.AntiAim_In_Air_Open) == "Jitter" then
                        ui.set(refs.body, "Jitter")
                        body_side = 0
                        ui.set(AntiAim_tab.body_val, 0)
                    end
                end
            end
        elseif ui.get(Ocean_tab.AntiAim_In_Air_BodyYaw)=="Opposite" then
            if L then
                ui.set(refs.body, "Static")
                if ui.get(Ocean_tab.AntiAim_Inverter) then 
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, 60)
                        body_side = 60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_In_Air_Brute) then
                        ui.set(AntiAim_tab.body_val, -60)
                        body_side = -60
                    end
                else
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, -60)
                        body_side = -60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_In_Air_Brute) then
                        ui.set(AntiAim_tab.body_val, 60)
                        body_side = 60
                    end
                end
            else
                ui.set(refs.body, "Static")
                if ui.get(Ocean_tab.AntiAim_Inverter) then 
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, 1)
                        body_side = 60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_In_Air_Brute) then
                        ui.set(AntiAim_tab.body_val, -1)
                        body_side = -60
                    end
                else
                    if AA_Brute == false then
                        ui.set(AntiAim_tab.body_val, -1)
                        body_side = -60
                    elseif AA_Brute == true and ui.get(Ocean_tab.AntiAim_In_Air_Brute) then
                        ui.set(AntiAim_tab.body_val, 1)
                        body_side = 60
                    end
                end
            end
        elseif ui.get(Ocean_tab.AntiAim_In_Air_BodyYaw)=="Jitter" then
            ui.set(refs.body, "Jitter")
            body_side = 0
            ui.set(AntiAim_tab.body_val, 0)
        end
        if side==false then 
            if ui.get(Ocean_tab.Misc_Untrusted)==true then
                roll_amount = ui.get(Ocean_tab.AntiAim_In_Air_Untrusted_L)
            else
                roll_amount = ui.get(Ocean_tab.AntiAim_In_Air_Roll_L)
            end
        else
            if ui.get(Ocean_tab.Misc_Untrusted)==true then
                roll_amount = ui.get(Ocean_tab.AntiAim_In_Air_Untrusted_R)
            else
                roll_amount = ui.get(Ocean_tab.AntiAim_In_Air_Roll_R)
            end
        end
        if ui.get(Ocean_tab.AntiAim_In_Air_Roll)==false then
            roll_amount = 0
        end
        statee = "IN-AIR"
    end

    local me = entity.get_local_player()
    local weapon_ent = entity.get_player_weapon(me)
    local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
    local weapon = csgo_weapon[weapon_idx]
    local R8 = weapon.name == "R8 Revolver"


    if ui.get(Ocean_tab.FL_Enable) and ui.get(Ocean_tab.FL_Key) then
        if ui.get(Ocean_tab.FL_Restrict) and R8 and ui.get(refs.enabled[1]) and ui.get(refs.enabled[2]) then
            ui.set(refs.FL_Check1, false)
        else
            ui.set(refs.FL_Check1, true)
        end
        ui.set(refs.FL_Check2, "Always on")
        if state == "stand" then
            if ui.get(Ocean_tab.FL_Stand_Override) then
                ui.set(refs.FL_Amount, ui.get(Ocean_tab.FL_Stand_Amount))
                ui.set(refs.FL_Variance, ui.get(Ocean_tab.FL_Stand_Variance))
                ui.set(refs.FL_Limit, ui.get(Ocean_tab.FL_Stand_Limit))
            else
                ui.set(refs.FL_Amount, ui.get(Ocean_tab.FL_Global_Amount))
                ui.set(refs.FL_Variance, ui.get(Ocean_tab.FL_Global_Variance))
                ui.set(refs.FL_Limit, ui.get(Ocean_tab.FL_Global_Limit))
            end
        elseif state == "duck" then
            if ui.get(Ocean_tab.FL_Duck_Override) then
                ui.set(refs.FL_Amount, ui.get(Ocean_tab.FL_Duck_Amount))
                ui.set(refs.FL_Variance, ui.get(Ocean_tab.FL_Duck_Variance))
                ui.set(refs.FL_Limit, ui.get(Ocean_tab.FL_Duck_Limit))
            else
                ui.set(refs.FL_Amount, ui.get(Ocean_tab.FL_Global_Amount))
                ui.set(refs.FL_Variance, ui.get(Ocean_tab.FL_Global_Variance))
                ui.set(refs.FL_Limit, ui.get(Ocean_tab.FL_Global_Limit))
            end
        elseif state == "move" then
            if ui.get(Ocean_tab.FL_Move_Override) then
                ui.set(refs.FL_Amount, ui.get(Ocean_tab.FL_Move_Amount))
                ui.set(refs.FL_Variance, ui.get(Ocean_tab.FL_Move_Variance))
                ui.set(refs.FL_Limit, ui.get(Ocean_tab.FL_Move_Limit))
            else
                ui.set(refs.FL_Amount, ui.get(Ocean_tab.FL_Global_Amount))
                ui.set(refs.FL_Variance, ui.get(Ocean_tab.FL_Global_Variance))
                ui.set(refs.FL_Limit, ui.get(Ocean_tab.FL_Global_Limit))
            end
        elseif state == "slowwalk" then
            if ui.get(Ocean_tab.FL_Slowwalk_Override) then
                ui.set(refs.FL_Amount, ui.get(Ocean_tab.FL_Slowwalk_Amount))
                ui.set(refs.FL_Variance, ui.get(Ocean_tab.FL_Slowwalk_Variance))
                ui.set(refs.FL_Limit, ui.get(Ocean_tab.FL_Slowwalk_Limit))
            else
                ui.set(refs.FL_Amount, ui.get(Ocean_tab.FL_Global_Amount))
                ui.set(refs.FL_Variance, ui.get(Ocean_tab.FL_Global_Variance))
                ui.set(refs.FL_Limit, ui.get(Ocean_tab.FL_Global_Limit))
            end
        elseif state == "in_air" then
            if ui.get(Ocean_tab.FL_In_Air_Override) then
                ui.set(refs.FL_Amount, ui.get(Ocean_tab.FL_In_Air_Amount))
                ui.set(refs.FL_Variance, ui.get(Ocean_tab.FL_In_Air_Variance))
                ui.set(refs.FL_Limit, ui.get(Ocean_tab.FL_In_Air_Limit))
            else
                ui.set(refs.FL_Amount, ui.get(Ocean_tab.FL_Global_Amount))
                ui.set(refs.FL_Variance, ui.get(Ocean_tab.FL_Global_Variance))
                ui.set(refs.FL_Limit, ui.get(Ocean_tab.FL_Global_Limit))
            end
        end
    else
        ui.set(refs.FL_Check1, false)
    end

    if ui.get(Ocean_tab.Other_Slowwalk) and ui.get(Ocean_tab.Other_Slowwalk_Key) then
        ui.set(refs.slow[1], true)
        ui.set(refs.slow[2], "Always on")
    else
        ui.set(refs.slow[1], false)
        ui.set(refs.slow[2], "Always on")
    end

    if ui.get(Ocean_tab.Other_Leg_movement) == "Off" then
        ui.set(refs.Leg_mvt, "Off")
    elseif ui.get(Ocean_tab.Other_Leg_movement) == "Always slide" then
        ui.set(refs.Leg_mvt, "Always slide")
    elseif ui.get(Ocean_tab.Other_Leg_movement) == "Never slide" then
        ui.set(refs.Leg_mvt, "Never slide")
    elseif ui.get(Ocean_tab.Other_Leg_movement) == "Leg breaker" then
        local legs_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
        ui.set(refs.Leg_mvt, legs_types[math.random(1, 3)])
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
    end

    if ui.get(Ocean_tab.Other_Hideshots) and ui.get(Ocean_tab.Other_Hideshots_Key) then
        ui.set(refs.OS_Check[1], true)
        ui.set(refs.OS_Check[2], "Always on")
    else
        ui.set(refs.OS_Check[1], false)
        ui.set(refs.OS_Check[2], "Always on")
    end

    local Free = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Freestanding")
    local YawAT = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Yaw: At Targets")
    local PitchKey = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Pitch-Down (\aD6BE73FFUnsafe\aCDCDCDFF)")
    local HalfPitch = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Half-Pitch (\aD6BE73FFUnsafe\aCDCDCDFF and \aD6BE73FFGay\aCDCDCDFF)")


    if HalfPitch and ui.get(Ocean_tab.AntiAim_HalfPitchKey) then
        ui.set(AntiAim_tab.pitch, "Custom")
        ui.set(AntiAim_tab.pitch_val, 45)

    else
        ui.set(AntiAim_tab.pitch, "Off")
        ui.set(AntiAim_tab.pitch_val, 0)
    end

    if Free and ui.get(Ocean_tab.AntiAim_Freestand) then
        ui.set(AntiAim_tab.freestanding, true)
        ui.set(AntiAim_tab.freestanding_key, "Always on")
    else
        ui.set(AntiAim_tab.freestanding, false)
    end

    if PitchKey and ui.get(Ocean_tab.AntiAim_PitchKey) then
        ui.set(AntiAim_tab.pitch, "Down")
        ui.set(AntiAim_tab.yaw, "180")
        ui.set(AntiAim_tab.yaw_val, 0)
    else
        --ui.set(AntiAim_tab.pitch, "Off")
        ui.set(AntiAim_tab.yaw, "180")
        ui.set(AntiAim_tab.yaw_val, -180)
    end

    if ui.get(Ocean_tab.Misc_Untrusted) == true then
        ui.set(refs.Untrusted, false)
        can_off = true
    else
        if can_off==true then
            ui.set(refs.Untrusted, true)
            can_off = false
        end
    end



    local FR = table_contains(ui.get(Ocean_tab.Misc_First_Person), "Remove scope overlay")
    local F = table_contains(ui.get(Ocean_tab.Misc_First_Person), "Custom Scope Zoom")

    local TR = table_contains(ui.get(Ocean_tab.Misc_Third_Person), "Remove scope overlay")
    local T = table_contains(ui.get(Ocean_tab.Misc_Third_Person), "Custom Scope Zoom")
   


    if ui.get(Ocean_tab.Misc_Custom_Scope)==true then
        local Scope = entity.get_prop(entity.get_local_player(), 'm_bIsScoped', 11)

        if ui.get(refs.thirdperson[1]) and ui.get(refs.thirdperson[2]) then
            
            if TR then
                ui.set(refs.remove_scope, true)
            else
                ui.set(refs.remove_scope, false)
            end
            if T then
                ui.set(refs.scope_zoom, ui.get(Ocean_tab.Misc_Third_Person_Zoom))
            end

        else
            
            if FR then
                ui.set(refs.remove_scope, true)
            else
                ui.set(refs.remove_scope, false)
            end
            if F then
                ui.set(refs.scope_zoom, ui.get(Ocean_tab.Misc_First_Person_Zoom))
            end


        end



    end

    if ui.get(Ocean_tab.Aimbot_Min_Fov) == ui.get(Ocean_tab.Aimbot_Max_Fov) or ui.get(Ocean_tab.Aimbot_Min_Fov) > ui.get(Ocean_tab.Aimbot_Max_Fov) then
        ui.set(Ocean_tab.Aimbot_Max_Fov, ui.get(Ocean_tab.Aimbot_Min_Fov))
    end

    if ui.get(Ocean_tab.Aimbot_Autofire)==true and ui.get(Ocean_tab.Aimbot_Autofire_hotkey) then
        ui.set(refs.auto_fire, true)
    elseif ui.get(Ocean_tab.Aimbot_Autofire)==true and not ui.get(Ocean_tab.Aimbot_Autofire_hotkey) then
        ui.set(refs.auto_fire, false)
    end

    if ui.get(Ocean_tab.Aimbot_Autopenetration)==true and ui.get(Ocean_tab.Aimbot_Autopenetration_hotkey) then
        ui.set(refs.auto_pen, true)
    elseif ui.get(Ocean_tab.Aimbot_Autopenetration)==true and not ui.get(Ocean_tab.Aimbot_Autopenetration_hotkey) then
        ui.set(refs.auto_pen, false)
    end
            
    ui.set(refs.Def_feature, "-")
    


    if L then 
        local local_player = entity.get_local_player()
        local weapon = csgo_weapon[entity.get_prop(entity.get_player_weapon(local_player), "m_iItemDefinitionIndex")]
        local PitchKey = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Pitch-Down (\aD6BE73FFUnsafe\aCDCDCDFF)")
        local Targets = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Yaw: At Targets")
        if ent_state.is_ladder(local_player) then return end
        if weapon == nil or weapon.type == "grenade" then return end
        if cmd.in_use == 1 then return end
        if is_freezetime() then return end
        if PitchKey and ui.get(Ocean_tab.AntiAim_PitchKey) then return end
        local Tpitch, Tyaw = entity.get_prop (local_player, 'm_angEyeAngles')
        local threat = client.current_threat()
        local ATYAW = math.round(Tyaw)

        if cmd.chokedcommands == 0 and cmd.in_attack ~= 1 then
            if Targets and ui.get(Ocean_tab.AntiAim_AtTarget) or Targets and not threat == nil then
                cmd.yaw = ATYAW + body_side/1.5
                cmd.allow_send_packet = false 
            end
            cmd.yaw = cmd.yaw + body_side
            cmd.allow_send_packet = false 
        end
        micro_move(cmd)
    end

    
    if not ui.get(AntiAim_tab.enabled) then return end
    if R then
        local local_player = entity.get_local_player()
        --Spoofs Client to use Roll in MM
        local is_mm_value = ffi.cast("bool*", game_rule[0] + 124)
        if is_mm_value ~= nil then
            if R then
                if ui.get(Ocean_tab.Misc_Untrusted)==true then
                    ui.set(refs.roll, 0)
                    cmd.roll = roll_amount
                else
                    ui.set(refs.roll, roll_amount)
                    cmd.roll = roll_amount
                end
                if is_mm_value[0] == true then
                    is_mm_value[0] = 0
                    is_mm_state = 1
                end
            else
                if is_mm_value[0] == false and is_mm_state == 1 then
                    ui.set(refs.roll, 0)
                    cmd.roll = 0
                end
                ui.set(refs.roll, 0)
                cmd.roll = 0
            end
        end
    else
        ui.set(refs.roll, 0)
        cmd.roll = 0
    end

    if YawAT and ui.get(Ocean_tab.AntiAim_AtTarget) then
        ui.set(AntiAim_tab.yaw_base, "At targets")
    else
        ui.set(AntiAim_tab.yaw_base, "Local view")
    end

end

local function update_fov()

    if not is_rage_aimbot_running() and globals.tickcount() % DYNAMIC_FOV_UPDATE_INTERVAL ~= 0 then
		return
	end

	local nMinimumFOV = ui.get(Ocean_tab.Aimbot_Min_Fov)
	local nMaximumFOV = ui.get(Ocean_tab.Aimbot_Max_Fov)
	local nDesiredFOV = nMinimumFOV

	-- Don't run distance checks if minimum is maximum. Spare CPU cycles ma'am?
	if nMinimumFOV ~= nMaximumFOV then
		nDesiredFOV = distance_to_dynamic_fov(nMinimumFOV, nMaximumFOV, get_closest_enemy_distance())
	end
    
    if ui.get(Ocean_tab.Aimbot_DynamicFOV)==true then
	    ui.set(refs.fov, nDesiredFOV)
    else
        return
    end

end

local unload_lby = function()
    if globals.mapname() == nil then is_mm_state = 0 return end
    local is_mm_value = ffi.cast("bool*", game_rule[0] + 124)
    if is_mm_value ~= nil then
        if is_mm_value[0] == false and is_mm_state == 1 then
            is_mm_value[0] = 1
            is_mm_state = 0
        end
    end
    
end

local Bodyyaw_indicator = function()
    if not ui.get(Ocean_tab.MasterSwitch) then return end
    local localplayer = entity.get_local_player()
    if not entity.is_alive(localplayer) then return end
	if not ui.get(Ocean_tab.Misc_Body_Yaw_indicator) then return end

    local x, y = client.screen_size()
    local Width = (x / 2)
    local Height = (y / 2)
    local desync = math.min(57, math.abs(entity.get_prop(localplayer, "m_flPoseParameter", 11) * 120 - 60))
    local TRed,TGreen, TBlue, TAlpha = ui.get(Ocean_tab.Misc_Body_Yaw_indicator_color)
    if ui.get(Ocean_tab.Misc_Body_Yaw_indicator_Desync) == true then
        CRed = 255 - desync * 2.29824561404
        CGreen = desync * 3.42105263158
        CBlue = desync * 0.22807017543
        CAlpha = 255
    else
        CRed, CGreen, CBlue, CAlpha = ui.get(Ocean_tab.Misc_Body_Yaw_indicator_color)
    end
    
    if ui.get(Ocean_tab.Misc_Body_Yaw_indicator_Invert)==false then
        if ui.get(Ocean_tab.Misc_Body_Yaw_indicator_selections) == "⮜ - ⮞" then
            Left_Side = "⮜"
            Right_Side = "⮞"
            Render_Flag = "b+"
            Render_Minus = 0
        elseif ui.get(Ocean_tab.Misc_Body_Yaw_indicator_selections) == "◀ - ▶" then
            Left_Side = "◀"
            Right_Side = "▶"
            Render_Flag = "b"
            Render_Minus = 9
        elseif ui.get(Ocean_tab.Misc_Body_Yaw_indicator_selections) == "◃ - ▹" then
            Left_Side = "◃"
            Right_Side = "▹"
            Render_Flag = "b+"
            Render_Minus = 0
        elseif ui.get(Ocean_tab.Misc_Body_Yaw_indicator_selections) == "— - —" then
            Left_Side = "➖"
            Right_Side = "➖"
            Render_Flag = "b"
            Render_Minus = 10
        end
    else
        if ui.get(Ocean_tab.Misc_Body_Yaw_indicator_selections) == "⮜ - ⮞" then
            Right_Side = "⮞"
            Left_Side = "⮜"
            Render_Flag = "b+"
            Render_Minus = 0
        elseif ui.get(Ocean_tab.Misc_Body_Yaw_indicator_selections) == "◀ - ▶" then
            Right_Side = "▶"
            Left_Side = "◀"
            Render_Flag = "b"
            Render_Minus = 9
        elseif ui.get(Ocean_tab.Misc_Body_Yaw_indicator_selections) == "◃ - ▹" then
            Right_Side = "▹"
            Left_Side = "◃"
            Render_Flag = "b+"
            Render_Minus = 0
        elseif ui.get(Ocean_tab.Misc_Body_Yaw_indicator_selections) == "— - —" then
            Right_Side = "➖"
            Left_Side = "➖"
            Render_Flag = "b"
            Render_Minus = 10
        end
    end
    if ui.get(Ocean_tab.Misc_Body_Yaw_indicator_Invert)==false then
        if side == false then
            renderer.text(Width - 65, Height - 16.5 + Render_Minus, CRed, CGreen, CBlue, CAlpha, Render_Flag, 0, Left_Side)
        elseif side == true then
            renderer.text(Width + 50, Height - 16.5 + Render_Minus, CRed, CGreen, CBlue, CAlpha, Render_Flag, 0, Right_Side)
        end
    else
        if side == true then
            renderer.text(Width - 65, Height - 16.5 + Render_Minus, CRed, CGreen, CBlue, CAlpha, Render_Flag, 0, Left_Side)
        elseif side == false then
            renderer.text(Width + 50, Height - 16.5 + Render_Minus, CRed, CGreen, CBlue, CAlpha, Render_Flag, 0, Right_Side)
        end
    end
    
end

local brutestate = false

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

-- local is_freezetime = function()
--     return entity_get_prop(entity_get_game_rules(), "m_bFreezePeriod") == 1
-- end

local function aim_miss(e)
    local chat = table_contains(ui.get(Ocean_tab.Misc_EventLogs_Output), "Chat")
    local console = table_contains(ui.get(Ocean_tab.Misc_EventLogs_Output), "Console")
	local group = hitgroup_names[e.hitgroup + 1] or '?'
    if e.reason == "spread" then
        brutestate = brutestate
    else
        if brutestate == true then
            brutestate = false
        elseif brutestate == false then
            brutestate = true
        end
    end
    if not ui.get(Ocean_tab.Misc_EventLogs) then return end
    if chat then 
        print_chat(string.format('[\x0bOcean\x01.Log\x01] Missed %s'.."'s"..' \x07%s\x01 due to \x07%s\x01', entity.get_player_name(e.target), group, e.reason))
    end
    if console then
        lua_log(string.format('Missed %s'.."'s"..' %s due to %s', entity.get_player_name(e.target), group, e.reason))
    end
end

local function aim_hit(e)
    local chat = table_contains(ui.get(Ocean_tab.Misc_EventLogs_Output), "Chat")
    local console = table_contains(ui.get(Ocean_tab.Misc_EventLogs_Output), "Console")
	local group = hitgroup_names[e.hitgroup + 1] or '?'
    if ui.get(Ocean_tab.Aimbot_Roll_Enable) then
        brutestate = false
    end
    if not ui.get(Ocean_tab.Misc_EventLogs) then return end
    if chat then 
        print_chat(string.format('[\x0bOcean\x01.Log\x01] Hit \x07%s'.."'s\x01 "..' in the %s for \x07%d\x01 damage (\x05%d\x01 health remaining)', entity.get_player_name(e.target), group, e.damage, entity.get_prop(e.target, 'm_iHealth')))
    end
    if console then
        lua_log(string.format('Hit %s'.."'s "..' in the %s for %d damage (%d health remaining)', entity.get_player_name(e.target), group, e.damage, entity.get_prop(e.target, 'm_iHealth')))
    end
end

local function local_death(e)
    local victim = client.userid_to_entindex(e.userid)
    local LocalPlayer = entity.get_local_player()
    if ui.get(Ocean_tab.Aimbot_Roll_Enable) then
        if victim == LocalPlayer then
            brutestate = false
        end
    end
    AA_Brute = false
end

local function reset_globals()
	g_flFlashDurationCache = 0.0
	g_flLastFlashUpdate = 0.0
end



local function on_player_spawn()
    reset_globals()
    AA_Brute = false
end

local function on_round_start()
    if ui.get(Ocean_tab.Aimbot_Roll_Enable) then
        brutestate = false
    end
    reset_globals()
    AA_Brute = false
end

--Side Detection
local detected_side = ""
local detected_state = ""
local detected_desync = ""
local last_detected = "left"
local player_freestanding = function(player)
    if not ui.get(Ocean_tab.MasterSwitch) then return end
    if player == nil then return end
    local eyepos_x, eyepos_y, eyepos_z = entity.get_prop(player, "m_vecAbsOrigin")
    local offsetx, offsety, offsetz = entity.get_prop(player, "m_vecViewOffset")
    eyepos_z = eyepos_z + offsetz
    local lowestfrac = 1
    local dir = false
    local desync = entity.get_prop(player, "m_flPoseParameter", 11) * 120 - 60
    local cpitch, cyaw = entity.get_prop(player, "m_angRotation")
    local speed = math.sqrt(math.pow(entity.get_prop(player, "m_vecVelocity[0]"), 2) + math.pow(entity.get_prop(player, "m_vecVelocity[1]"), 2))
    local duck = entity.get_prop(player, "m_flDuckAmount")
    local on_ground = bit.band(entity.get_prop(player, "m_fFlags"), 1)
    local fractionleft, fractionright = 0, 0
    local amountleft, amountright = 0, 0
    for i = -70, 70, 5 do
        if i ~= 0 then

            local fwdx, fwdy, fwdz = libary.vectorangle(0, cyaw + i + desync, 0)
            fwdx, fwdy, fwdz = libary.multiplyvalues(fwdx, fwdy, fwdz, 70)

            local fraction =
                client.trace_line(
                player,
                eyepos_x,
                eyepos_y,
                eyepos_z,
                eyepos_x + fwdx,
                eyepos_y + fwdy,
                eyepos_z + fwdz
            )

            local outx, outy = renderer.world_to_screen(eyepos_x + fwdx, eyepos_y + fwdy, eyepos_z + fwdz)

            if i > 0 then
                fractionleft = fractionleft + fraction
                amountleft = amountleft + 1
            else
                fractionright = fractionright + fraction
                amountright = amountright + 1
            end

        end

    end

    local averageleft, averageright = fractionleft / amountleft, fractionright / amountright

    if averageleft < averageright then
        if speed > 15 and speed < 80 then
            detected_state = "slow"
        elseif speed < 10 and duck==1 and on_ground==1 then
            detected_state = "duck"
        elseif speed > 25 and duck==1 and on_ground==1 then
            detected_state = "duckmove"
        elseif speed < 10 and on_ground==1 then
            detected_state = "stand"
        elseif speed > 120 and duck==0 then
            detected_state = "move"
        elseif on_ground==0 then
            detected_state = "air"
        end
        detected_side = "left"
        last_detected = "left"
        desync_deg = -56
    elseif averageleft > averageright then
        if speed > 15 and speed < 80 then
            detected_state = "slow"
        elseif speed < 10 and duck==1 and on_ground==1 then
            detected_state = "duck"
        elseif speed > 25 and duck==1 and on_ground==1 then
            detected_state = "duckmove"
        elseif speed < 10 and on_ground==1 then
            detected_state = "stand"
        elseif speed > 120 and duck==0 then
            detected_state = "move"
        elseif on_ground==0 then
            detected_state = "air"
        end
        detected_side = "right"
        last_detected = "right"
        desync_deg = 56
    else
        if speed > 15 and speed < 80 and duck==0 then
            detected_state = "slow"
        elseif speed < 10 and duck==1 and on_ground==1 then
            detected_state = "duck"
        elseif speed > 25 and duck==1 and on_ground==1 then
            detected_state = "duckmove"
        elseif speed < 10 and on_ground==1 then
            detected_state = "stand"
        elseif speed > 120 and duck==0 then
            detected_state = "move"
        elseif on_ground==0 then
            detected_state = "air"
        end
        detected_side = "none"
    end
    if desync > 5 then
        detected_desync = "right"
    elseif desync < -5 then
        detected_desync = "left"
    else
        detected_desync = "Might not have desync"
    end

end

local run_painter = function()
    local target = client.current_threat()
    player_freestanding(target)
    local lp = entity.get_local_player()
    SelfEdge(lp)
end

local flag = "OFF"
local function test_reso()

    if manual_side == 0 and canManual==true then
        flag = "LEFT"
        manual_side = 1
    elseif manual_side == 1 and canManual==true then
        flag = "RIGHT"
        manual_side = 2
    elseif manual_side == 2 and canManual==true then
        flag = "OFF"
        manual_side = 0
    end

end

local function manual_reso()

    if ui.get(Ocean_tab.Aimbot_Roll_Inverter) then
        test_reso()
        canManual = false
    else
        canManual = true
    end

end

local Roll_override = function(self, idx, deg)
    local _ , yaw = entity.get_prop ( idx, 'm_angRotation' )
    local pitch = 89 * ( ( 2 * entity.get_prop ( idx, 'm_flPoseParameter', 12 ) ) - 1 )
    entity.set_prop ( idx, 'm_angEyeAngles', pitch, yaw, deg )
end

local Roll_Resolver = function()
    if not ui.get(Ocean_tab.MasterSwitch) then return end
    local RO = table_contains(ui.get(Ocean_tab.Aimbot_Roll_Overrides), "Force Override Roll")
    if ui.get(Ocean_tab.Aimbot_Roll_Enable) then
        if RO then
            if ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Auto" then
                if detected_state == "stand" then
                    if detected_side == "left" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L)
                    elseif detected_side == "right" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R)
                    elseif detected_side == "none" then
                        if last_detected == "left" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L)
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R)
                            end
                        elseif last_detected == "right" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R)
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L)
                            end
                        end
                    end
                elseif detected_state == "duck" then
                    if detected_side == "left" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L)
                    elseif detected_side == "right" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R)
                    elseif detected_side == "none" then
                        if last_detected == "left" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L)
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R)
                            end
                        elseif last_detected == "right" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R)
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L)
                            end
                        end
                    end
                elseif detected_state == "duckmove" then
                    if detected_side == "left" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                    elseif detected_side == "right" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R) / 2
                    elseif detected_side == "none" then
                        if last_detected == "left" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R) / 2 
                            end
                        elseif last_detected == "right" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R) / 2
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                            end
                        end
                    end
                elseif detected_state == "slow" then
                    if detected_side == "left" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                    elseif detected_side == "right" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R) / 2
                    elseif detected_side == "none" then
                        if last_detected == "left" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R) / 2
                            end
                        elseif last_detected == "right" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R) / 2
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                            end
                        end
                    end
                elseif detected_state == "move" then
                    if detected_side == "left" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                    elseif detected_side == "right" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R) / 2
                    elseif detected_side == "none" then
                        if last_detected == "left" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R)/ 2
                            end
                        elseif last_detected == "right" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R) / 2
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                            end
                        end
                    end
                elseif detected_state == "air" then
                    if detected_side == "left" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                    elseif detected_side == "right" then
                        deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R) / 2
                    elseif detected_side == "none" then
                        if last_detected == "left" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R) / 2
                            end
                        elseif last_detected == "right" then
                            if brutestate == false then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R) / 2
                            elseif brutestate == true then
                                deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L) / 2
                            end
                        end
                    end
                end
                flag = "Auto"
            elseif ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Bruteforce" then
                if brutestate == false then
                    deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L)
                elseif brutestate == true then
                    deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R)
                end
                flag = "Brute"
            elseif ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Manual" then
                if manual_side == 0 then
                    deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L)
                elseif manual_side == 1 then  
                    deg = ui.get(Ocean_tab.Aimbot_Roll_Override_L)
                elseif manual_side == 2 then
                    deg = ui.get(Ocean_tab.Aimbot_Roll_Override_R)
                end
            end
        else
            deg = 0
        end
    else
        deg = 0
    end

    local enemies = entity.get_players(true)
    for i=1, #enemies do
		local entindex = enemies[i]

        local _ , yaw = entity.get_prop ( entindex, 'm_angRotation' )
        local pitch = 89 * ( ( 2 * entity.get_prop ( entindex, 'm_flPoseParameter', 12 ) ) - 1 )
        entity.set_prop ( entindex, 'm_angEyeAngles', pitch, yaw, deg )

        if ui.get(Ocean_tab.Aimbot_Roll_Untrusted_Pitch) then
            plist.set(entindex, "Force pitch", true)
            plist.set(entindex, "Force pitch value", ui.get(Ocean_tab.Aimbot_Roll_Untrusted_Pitch_Value))
        else
            plist.set(entindex, "Force pitch", false)
            plist.set(entindex, "Force pitch value", 0)
            
        end

    end
        

end


local desync_deg = 0
local Desync_Resolver = function()
    if not ui.get(Ocean_tab.MasterSwitch) then return end
    local DO = table_contains(ui.get(Ocean_tab.Aimbot_Roll_Overrides), "Force Override Desync")
    local Target = client.current_threat()
    if Target == nil then
        return
    end
    client.update_player_list()
    local Target_Speed_1 = entity.get_prop(Target, "m_vecVelocity[0]")
    local Target_Speed_2 = entity.get_prop(Target, "m_vecVelocity[1]")
    local desync_amount = -math.min(60, math.max(-60, normalize(entity.get_prop(Target, "m_angEyeAngles[1]") - entity.get_prop(Target, "m_flLowerBodyYawTarget"))))
    local desync_amount_Brute = math.min(60, math.max(-60, normalize(entity.get_prop(Target, "m_angEyeAngles[1]") - entity.get_prop(Target, "m_flLowerBodyYawTarget"))))
    
    if ui.get(Ocean_tab.Aimbot_Roll_Enable) then
        
        if DO then
            if ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Auto" then
                if detected_state == "stand" then
                    if brutestate == false then
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_amount)
                        ui.set(refs.ApplyToAll, true)
                    elseif brutestate == true then
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_amount_Brute)
                        ui.set(refs.ApplyToAll, true)
                    end
                elseif detected_state == "duck" then
                    if brutestate == false then
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_amount)
                        ui.set(refs.ApplyToAll, true)
                    elseif brutestate == true then
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_amount_Brute)
                        ui.set(refs.ApplyToAll, true)
                    end
                elseif detected_state == "duckmove" then
                    if detected_side == "left" then
                        if brutestate == false then
                            desync_deg = -60
                        elseif brutestate == true then
                            desync_deg = 60
                        end
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg/2)
                        ui.set(refs.ApplyToAll, true)
                    elseif detected_side == "right" then
                        if brutestate == false then
                            desync_deg = 60
                        elseif brutestate == true then
                            desync_deg = -60
                        end
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg/2)
                        ui.set(refs.ApplyToAll, true)
                    elseif detected_side == "none" then
                        if last_detected == "left" then
                            if brutestate == false then
                                desync_deg = -60
                            elseif brutestate == true then
                                desync_deg = 60
                            end
                        elseif last_detected == "right" then
                            if brutestate == false then
                                desync_deg = 60
                            elseif brutestate == true then
                                desync_deg = -60
                            end
                        end
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg / 2)
                        ui.set(refs.ApplyToAll, true)
                    end
                elseif detected_state == "slow" then
                    if detected_side == "left" then
                        if brutestate == false then
                            desync_deg = -60
                        elseif brutestate == true then
                            desync_deg = 60
                        end
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg)
                        ui.set(refs.ApplyToAll, true)
                    elseif detected_side == "right" then
                        if brutestate == false then
                            desync_deg = 60
                        elseif brutestate == true then
                            desync_deg = -60
                        end
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg)
                        ui.set(refs.ApplyToAll, true)
                    elseif detected_side == "none" then
                        if last_detected == "left" then
                            if brutestate == false then
                                desync_deg = -60
                            elseif brutestate == true then
                                desync_deg = 60
                            end
                        elseif last_detected == "right" then
                            if brutestate == false then
                                desync_deg = 60
                            elseif brutestate == true then
                                desync_deg = -60
                            end
                        end
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg)
                        ui.set(refs.ApplyToAll, true)
                    end
                elseif detected_state == "move" then
                    if detected_side == "left" then
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg/2)
                        ui.set(refs.ApplyToAll, true)
                    elseif detected_side == "right" then
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg/2)
                        ui.set(refs.ApplyToAll, true)
                    elseif detected_side == "none" then
                        if last_detected == "left" then
                            if brutestate == false then
                                desync_deg = -56
                            elseif brutestate == true then
                                desync_deg = 56
                            end
                        elseif last_detected == "right" then
                            if brutestate == false then
                                desync_deg = 56
                            elseif brutestate == true then
                                desync_deg = -56
                            end
                        end
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg/2)
                        ui.set(refs.ApplyToAll, true)
                    end
                elseif detected_state == "air" then
                    if detected_side == "left" then
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg/2)
                        ui.set(refs.ApplyToAll, true)
                    elseif detected_side == "right" then
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg/2)
                        ui.set(refs.ApplyToAll, true)
                    elseif detected_side == "none" then
                        if last_detected == "left" then
                            if brutestate == false then
                                desync_deg = -60
                            elseif brutestate == true then
                                desync_deg = 60
                            end
                        elseif last_detected == "right" then
                            if brutestate == false then
                                desync_deg = 60
                            elseif brutestate == true then
                                desync_deg = -60
                            end
                        end
                        ui.set(refs.ForceBodyYaw, true)
                        ui.set(refs.ForceSlider, desync_deg/2)
                        ui.set(refs.ApplyToAll, true)
                    end
                    
                end
                flag = "Auto"
                Desync_Can_Off = true
            elseif ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Bruteforce" then
                if brutestate == false then
                    ui.set(refs.ForceBodyYaw, true)
                    ui.set(refs.ForceSlider, -60)
                    ui.set(refs.ApplyToAll, true)
                    flag = "BRUTE"
                elseif brutestate == true then
                    ui.set(refs.ForceBodyYaw, true)
                    ui.set(refs.ForceSlider, 60)
                    ui.set(refs.ApplyToAll, true)
                    flag = "BRUTE"
                else
                    ui.set(refs.ForceBodyYaw, true)
                    ui.set(refs.ForceSlider, 0)
                    ui.set(refs.ApplyToAll, true)
                    flag = "BRUTE"
                end
                Desync_Can_Off = true
            elseif ui.get(Ocean_tab.Aimbot_Roll_Resolver_Modes) == "Manual" then
                if manual_side == 0 then
                    ui.set(refs.ForceBodyYaw, false)
                    ui.set(refs.ForceSlider, 0)
                    ui.set(refs.ApplyToAll, true)
                elseif manual_side == 1 then
                    ui.set(refs.ForceBodyYaw, true)
                    ui.set(refs.ForceSlider, -60)
                    ui.set(refs.ApplyToAll, true)
                elseif manual_side == 2 then
                    ui.set(refs.ForceBodyYaw, true)
                    ui.set(refs.ForceSlider, 60)
                    ui.set(refs.ApplyToAll, true)
                end
                Desync_Can_Off = true
            end
        else
            if Desync_Can_Off == true then
                ui.set(refs.ForceBodyYaw, false)
                ui.set(refs.ForceSlider, 0)
                ui.set(refs.ApplyToAll, true)
                Desync_Can_Off = false
            end
        end
        
    else
        if Desync_Can_Off == true then
            ui.set(refs.ForceBodyYaw, false)
            ui.set(refs.ForceSlider, 0)
            ui.set(refs.ApplyToAll, true)
            Desync_Can_Off = false
        end
    end

end
local chokedcmds = 0
client.set_event_callback("run_command", function (e)
	chokedcmds = e.chokedcommands
end)

local feature_indi = function()
    if not ui.get(Ocean_tab.MasterSwitch) then return end
    local r,g,b,a = ui.get(Ocean_tab.Misc_Feature_color)
    local rr,gg,bb,aa = ui.get(Ocean_tab.Misc_Feature_color2)
    local RO = table_contains(ui.get(Ocean_tab.Aimbot_Roll_Overrides), "Force Override Roll")
    local DO = table_contains(ui.get(Ocean_tab.Aimbot_Roll_Overrides), "Force Override Desync")
    local localplayer = entity.get_local_player()
    local desync = Clamp(math.abs(entity.get_prop(localplayer, "m_flPoseParameter", 11) * 120 - 59), 0.5 / 60, 60) / 56
    if not entity.is_alive(localplayer) then return end

    local Feature_AF = table_contains(ui.get(Ocean_tab.Misc_Feature), "Auto Fire")
    local Feature_AW = table_contains(ui.get(Ocean_tab.Misc_Feature), "Auto Wall")
    local Feature_FOV = table_contains(ui.get(Ocean_tab.Misc_Feature), "FOV")
    local Feature_DUCK = table_contains(ui.get(Ocean_tab.Misc_Feature), "Duck peek assist")
    local Feature_FB = table_contains(ui.get(Ocean_tab.Misc_Feature), "Force Baim")
    local Feature_FS = table_contains(ui.get(Ocean_tab.Misc_Feature), "Force Safepoint")
    local Feature_AA = table_contains(ui.get(Ocean_tab.Misc_Feature), "AA")
    local Feature_FL = table_contains(ui.get(Ocean_tab.Misc_Feature), "FL")
    local Feature_MD = table_contains(ui.get(Ocean_tab.Misc_Feature), "Min. Damage")
    local Feature_Ping = table_contains(ui.get(Ocean_tab.Misc_Feature), "Ping")
    local Feature_FREES = table_contains(ui.get(Ocean_tab.Misc_Feature), "Freestand")
    local Feature_AT = table_contains(ui.get(Ocean_tab.Misc_Feature), "Yaw: At Targets")
    local Feature_PITCH = table_contains(ui.get(Ocean_tab.Misc_Feature), "Pitch")
    local Feature_HALFPITCH = table_contains(ui.get(Ocean_tab.Misc_Feature), "Half-Pitch")
    local Feature_OS = table_contains(ui.get(Ocean_tab.Misc_Feature), "On-Shot")
    local Feature_ST = table_contains(ui.get(Ocean_tab.Misc_Feature), "State")
    local Feature_RE = table_contains(ui.get(Ocean_tab.Misc_Feature), "Resolver")

    local Free = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Freestanding")
    local AT = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Yaw: At Targets")
    local Pitchonkey = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Pitch-Down (\aD6BE73FFUnsafe\aCDCDCDFF)")
    local HalfPitch = table_contains(ui.get(Ocean_tab.AntiAim_Extras), "Half-Pitch (\aD6BE73FFUnsafe\aCDCDCDFF and \aD6BE73FFGay\aCDCDCDFF)")


    if Feature_OS and ui.get(refs.os[1]) and ui.get(refs.os[2]) then
        renderer.indicator(r,g,b,a, "OS")
    end
    if Feature_FB and ui.get(refs.FBaim ) then
        renderer.indicator(r,g,b,a, "BAIM")
    end
    if Feature_FS and ui.get(refs.FSPoint) then
        renderer.indicator(r,g,b,a, "SAFE")
    end
    if Feature_DUCK and ui.get(refs.duck) then
        renderer.indicator(r,g,b,a, "DUCK")
    end
    if Feature_ST then 
        renderer.indicator(r,g,b,a, statee)
    end
    if Feature_RE and ui.get(Ocean_tab.Aimbot_Roll_Enable) and RO or Feature_RE and ui.get(Ocean_tab.Aimbot_Roll_Enable) and DO then
        renderer.indicator(r,g,b,a, "R: "..flag)
    end
    if Feature_PITCH and ui.get(Ocean_tab.AntiAim_PitchKey) and Pitchonkey then
        renderer.indicator(r,g,b,a, "Pitch")
    end
    if Feature_HALFPITCH and ui.get(Ocean_tab.AntiAim_HalfPitchKey) and HalfPitch then
        renderer.indicator(r,g,b,a, "Half-Pitch")
    end
    if Feature_AT and ui.get(Ocean_tab.AntiAim_AtTarget) and AT then
        renderer.indicator(r,g,b,a, "AT")
    end
    if Feature_FREES and ui.get(Ocean_tab.AntiAim_Freestand) and Free then
        renderer.indicator(r,g,b,a, "FS")
    end
    if Feature_MD and ui.get(refs.ovr[2]) then
        renderer.indicator(r,g,b,a, "DMG: "..ui.get(refs.ovr[3]))
    end
    if Feature_FL and ui.get(refs.FL_Check[1]) and ui.get(refs.FL_Check[2]) then
        y = renderer.indicator(r, g, b, a, 'FL')
        indicator_circle(72, y + 18, rr, gg, bb, aa, chokedcmds / ui.get(refs.FL_Limit))
    end
    if Feature_AA and ui.get(AntiAim_tab.enabled) then
        y = renderer.indicator(r, g, b, a, 'AA')
        indicator_circle(72, y + 18, rr, gg, bb, aa, desync)
    end
    if Feature_Ping and ui.get(refs.Ping[1]) and ui.get(refs.Ping[2]) then
        renderer.indicator(r,g,b,a, "PING")
    end
    if Feature_AW and ui.get(refs.auto_pen) then
        renderer.indicator(r,g,b,a, "AW")
    end
    if Feature_AF and ui.get(refs.auto_fire) then
        renderer.indicator(r,g,b,a, "TM")
    end
    if Feature_FOV then
        renderer.indicator(r,g,b,a, "FOV: "..ui.get(refs.fov).."°")
    end

end
local clan_tag_prev = ""
local clantag_fix = false
local clan_tag = ""
local function Clantag()

    if ui.get(refs.Gs_Tag) and can_ovr == true then
        ui.set(Ocean_tab.Misc_Clantag, "-")
        can_ovr = false
        can_ovvr = true
        can_ovvvr = true
    end

    if not ui.get(Ocean_tab.MasterSwitch) then return end
    local LocalPlayer = entity.get_local_player()
    local N_tag = ui.get(Ocean_tab.Misc_Clantag) == "-"
    local OT_tag = ui.get(Ocean_tab.Misc_Clantag) == "Ocean.Tech"
    local OTS_tag = ui.get(Ocean_tab.Misc_Clantag) == "Ocean.Tech Static"
    local Identifier = "🫷"
    local curtime = math.floor(globals.curtime() * 2.75)
    if N_tag then
        if ui.get(Ocean_tab.Misc_Shared_Feature)then
            if not ui.get(refs.Gs_Tag) then
                client.set_clan_tag("🫷")
            end
        else
            if can_ovvvr == true then
                client.set_clan_tag("")
                can_ovvvr = false
            end
        end

    elseif OT_tag then
        if can_ovvr == true then
            ui.set(refs.Gs_Tag, false)
            can_ovvr = false
        end
        can_ovvvr = true
        if ui.get(Ocean_tab.Misc_Shared_Feature) then
            if clantag.timer ~= curtime then
                client.set_clan_tag(clantag.states[curtime % #clantag.states + 1])
                clantag.timer = curtime
            end
        else
            if clantag.timer ~= curtime then
                client.set_clan_tag(clantag1.states[curtime % #clantag1.states + 1])
                clantag.timer = curtime
            end
        end
        can_ovr = true
    elseif OTS_tag then
        if can_ovvr == true then
            ui.set(refs.Gs_Tag, false)
            can_ovvr = false
        end
        can_ovvvr = true
        if ui.get(Ocean_tab.Misc_Shared_Feature) then
            client.set_clan_tag("🫷Ocean.Tech")
        else
            client.set_clan_tag("Ocean.Tech")
        end
        can_ovr = true
    end

    if clan_tag ~= clan_tag_prev then
        if ui.get(Ocean_tab.Misc_Shared_Feature)then
            client.set_clan_tag(clan_tag)
        else
            client.set_clan_tag(clan_tag)
        end
    end
    clan_tag_prev = clan_tag
    clantag_fix = true
end

local function on_paint(c)
    local Identifier = "🫷"
    if globals.tickcount() % 64 == 0 then
            for ent = 1, globals.maxplayers() do
                if entity.get_classname(ent) == 'CCSPlayer' then
                local player_resource = entity.get_player_resource()
                        
                local user_detected = entity.get_prop(player_resource, 'm_szClan', ent)
                if user_detected and ui.get(Ocean_tab.Misc_Shared_Feature) and containsSymbol(user_detected, Identifier) then
                    entity.set_prop(player_resource, 'm_nPersonaDataPublicLevel', '1315112', ent)
                else
                    entity.set_prop(player_resource, 'm_nPersonaDataPublicLevel', '1315122', ent)
                end
            end
        end
    end
end
client.set_event_callback('paint', on_paint)
local native_CreateDirectory = vtable_bind('filesystem_stdio.dll', 'VFileSystem017', 22, 'void(__thiscall*)(void*, const char*, const char*)')
local writedir = function(path, pathID)
    native_CreateDirectory(({path:gsub('/', '\\')})[1], pathID)
end
local has_image = readfile('csgo/materials/panorama/images/icons/xp/level1315112.png')
local has_image2 = readfile('csgo/materials/panorama/images/icons/xp/level1315122.png')
function image_recursive()
    if not has_image then
        http.get('https://cdn.discordapp.com/attachments/825913505793441852/1115959775386161323/level1315112.png', function(success, response)
            if not success or response.status ~= 200 then
                client.delay_call(3, image_recursive)
            else
                writedir('/csgo/materials/panorama/images/icons/xp', 'GAME')
                writefile('csgo/materials/panorama/images/icons/xp/level1315112.png', response.body)
            end
        end)
    end
    if not has_image2 then
        http.get('https://cdn.discordapp.com/attachments/518439995942371329/1112444110280863834/femboy-thighs-v0-s8cank814i2a1.png', function(success, response)
            if not success or response.status ~= 200 then
                client.delay_call(3, image_recursive)
            else
                writedir('/csgo/materials/panorama/images/icons/xp', 'GAME')
                writefile('csgo/materials/panorama/images/icons/xp/level1315122.png', response.body)
            end
        end)
    end
end
image_recursive()

local function ocean_prio()
    if not ui.get(Ocean_tab.Aimbot_Prio_System) then return end
    local me = entity.get_local_player()
    for i, players in pairs(entity.get_players(true)) do
        plist.set(players, "High priority",false)
        local weapon = entity.get_player_weapon(players)
        if weapon ~= nil then
            plist.set(players, "High priority", entity.get_classname(weapon) == "CWeaponAWP")
        end
        for i = 64 , 0 , -1 do
            local idx = entity.get_prop(entity.get_prop(players, "m_hMyWeapons", i), "m_iItemDefinitionIndex")
            if idx == 49 then
                plist.set(players, "High priority", true)
            end
        end
        if entity.get_prop(players, "m_hCarriedHostage") == nil then return end
        plist.set(players, "High priority", true)
    end
end

local function prio_flag()
    if not ui.get(Ocean_tab.Aimbot_Prio_System) then return end
    local r,g,b,a = ui.get(Ocean_tab.Aimbot_Prio_System_color)
    for i, players in pairs(entity.get_players(true)) do
        local bounding_box = {entity.get_bounding_box(players)}
        if #bounding_box == 5 and bounding_box[5] ~= 0 then
            local center = bounding_box[1] + (bounding_box[3] - bounding_box[1]) / 2
            if plist.get(players, "High priority") then
                renderer.text(center, bounding_box[2]- 18,  r, g, b, a, "dbc", 1000, "High priority")
            end
            --renderer.text(center, bounding_box[2] - 18, 255, 255, 255, 255, "dbc", 100, "LEFT")
        end

    end
end
client.set_event_callback("paint",prio_flag)

local function on_run_command(e)

    local smoke = table_contains(ui.get(Ocean_tab.Aimbot_Disablers), "Through Smoke")
    local flash = table_contains(ui.get(Ocean_tab.Aimbot_Disablers), "While Flashed")

    if smoke and ui.get(Ocean_tab.Aimbot_Disablers_checkbox)==true then
        update_ignore_behind_smokes()
    end
    if flash and ui.get(Ocean_tab.Aimbot_Disablers_checkbox)==true then
        update_honor_flashbangs()
    end
    update_whitelist()
end

local function run_command()

    ocean_prio()

    local speed = ui.get(Ocean_tab.AntiAim_Slowwalk_Speed_Value)

	--if ui.get(refs.slow[1]) and ui.get(refs.slow[2]) and ui.get(Ocean_tab.AntiAim_Slowwalk_Speed) then
    --    setSpeed(speed)
	--else
	--	setSpeed(450)
	--end


end



local function Watermark()
    if not ui.get(Ocean_tab.MasterSwitch) then return end
    local x, y = client.screen_size()
    local r, g, b, a = ui.get(Ocean_tab.Misc_Watermark_color)
    local water_name =  gradient_text(r, g, b, 255, 255, 255, 255, 255, 'Ocean.Tech')
    local fps = math.floor(1 / globals.absoluteframetime() + 0.5)
    local ping = math.floor(math.min(1000, client.latency() * 1000) + 0.5)
    local hours, minutes, seconds = client.system_time()
    local time = string.format("%02d:%02d:%02d", hours, minutes, seconds)



    if ui.get(Ocean_tab.Misc_Watermark) and entity.get_local_player() then
        renderer.gradient(x - 193, y - y + 10, 188, 20, 26, 26, 30, a, 33, 33, 38, a, true)
        renderer.gradient(x - 265, y - y + 10, 64.9, 20, 26, 26, 30, a, 33, 33, 38, a, true)
        renderer.rectangle(x - 265, y - y + 10, 64, 3, r, g, b, 255)
        renderer.rectangle(x - 193, y - y + 10, 188, 3, r, g, b, 255)
        renderer.text(x - 260, y - y + 15, r, g, b, 255, nil, 100, water_name)
        renderer.text(x - 190, y - y + 15, 255, 255, 255, 255, nil, 100, "Fps: ",fps)
        renderer.text(x - 145, y - y + 15, 255, 255, 255, 255, nil, 100, "| Ping: ",ping)
        renderer.text(x - 95, y - y + 15, 255, 255, 255, 255, nil, 100, " | Time: ",time)

    end

end

local C_side = false
client.set_event_callback('setup_command', function(cmd)
    if cmd.chokedcommands == 0 then
        local lp_bodyyaw = entity.get_prop(entity.get_local_player(), 'm_flPoseParameter', 11) * 120 - 60
        C_side = lp_bodyyaw < 0
    end
end)


local Scope_spacer = 0
local function Crosshair_indicators()
    if not ui.get(Ocean_tab.MasterSwitch) then return end
    local localplayer = entity.get_local_player()
    if not entity.is_alive(localplayer) then return end
    if not ui.get(Ocean_tab.Misc_Crosshair_Indicator) then return end
    local IName = table_contains(ui.get(Ocean_tab.Misc_Crosshair_Indicator_select), "Name")
    local IRagebot = table_contains(ui.get(Ocean_tab.Misc_Crosshair_Indicator_select), "Ragebot")
    local IFov = table_contains(ui.get(Ocean_tab.Misc_Crosshair_Indicator_select), "Fov")
    local ISafe = table_contains(ui.get(Ocean_tab.Misc_Crosshair_Indicator_select), "Safe")
    local IBaim = table_contains(ui.get(Ocean_tab.Misc_Crosshair_Indicator_select), "Baim")
    local IDmg = table_contains(ui.get(Ocean_tab.Misc_Crosshair_Indicator_select), "Min. Dmg")
    local screen = {client.screen_size()}
    local x_offset, y_offset = screen[1], screen[2]
    local x, y =  x_offset/2,y_offset/2 
    local r,g,b,a = ui.get(Ocean_tab.Misc_Crosshair_Indicator_color)
    local rr,gg,bb,aa = ui.get(Ocean_tab.Misc_Crosshair_Indicator_color1)
    local penis = 28
    local Scope = entity.get_prop(entity.get_local_player(), 'm_bIsScoped') == 1

    if ui.get(Ocean_tab.Misc_Body_Yaw_indicator_Invert)==false then
        if C_side == false then
            lua_name =  gradient_text(r, g, b, a, rr, gg, bb, aa, 'Ocean')
            penis = 28
        elseif C_side == true then
            lua_name =  gradient_text(rr, gg, bb, aa, r, g, b, a, 'Ocean')
            penis = -28
        end
    else
        if C_side == true then
            lua_name =  gradient_text(r, g, b, a, rr, gg, bb, aa, 'Ocean')
            penis = 28
        elseif C_side == false then
            lua_name =  gradient_text(rr, gg, bb, aa, r, g, b, a, 'Ocean')
            penis = -28
        end
    end

    if Scope then
        Scope_spacer = 20
    elseif not Scope then
        Scope_spacer = 0
    end
    local Spacer = 0
    if IName then
        renderer.text(x-15+Scope_spacer, y+15, r, g, b, 255, "b", 100, lua_name)
        Spacer = Spacer + 13
    end

    if IRagebot then
        if ui.get(Ocean_tab.Aimbot_Autofire)==true and ui.get(Ocean_tab.Aimbot_Autofire_hotkey) and ui.get(Ocean_tab.Aimbot_Autopenetration)==true and ui.get(Ocean_tab.Aimbot_Autopenetration_hotkey) then
            renderer.text(x-14+Scope_spacer, y+15+Spacer, r, g, b, 255, "-", 100, "AF")
            renderer.text(x-3+Scope_spacer, y+15+Spacer, 225, 225, 225, 255, "-", 100, ":")
            renderer.text(x+2+Scope_spacer, y+15+Spacer, r, g, b, 255, "-", 100, "AW")
        elseif ui.get(Ocean_tab.Aimbot_Autofire)==true and ui.get(Ocean_tab.Aimbot_Autofire_hotkey) and not ui.get(Ocean_tab.Aimbot_Autopenetration_hotkey) then
            renderer.text(x-14+Scope_spacer, y+15+Spacer, r, g, b, 255, "-", 100, "AF")
            renderer.text(x-3+Scope_spacer, y+15+Spacer, 225, 225, 225, 255, "-", 100, ":")
            renderer.text(x+2+Scope_spacer, y+15+Spacer, 138, 138, 138, 255, "-", 100, "AW")
        elseif ui.get(Ocean_tab.Aimbot_Autopenetration)==true and ui.get(Ocean_tab.Aimbot_Autopenetration_hotkey) and not ui.get(Ocean_tab.Aimbot_Autofire_hotkey) then
            renderer.text(x-14+Scope_spacer, y+15+Spacer, 138, 138, 138, 255, "-", 100, "AF")
            renderer.text(x-3+Scope_spacer, y+15+Spacer, 225, 225, 225, 255, "-", 100, ":")
            renderer.text(x+2+Scope_spacer, y+15+Spacer, r, g, b, 255, "-", 100, "AW")
        else
            renderer.text(x-14+Scope_spacer, y+15+Spacer, 138, 138, 138, 255, "-", 100, "AF")
            renderer.text(x-3+Scope_spacer, y+15+Spacer, 225, 225, 225, 255, "-", 100, ":")
            renderer.text(x+2+Scope_spacer, y+15+Spacer, 138, 138, 138, 255, "-", 100, "AW")
        end
        Spacer = Spacer + 13
    end
    
    if IFov then
        renderer.text(x-12+Scope_spacer, y+12+Spacer, 225, 225, 225, 255, "-", 100, "FOV:")
        renderer.text(x+6+Scope_spacer, y+12+Spacer, r, g, b, 255, "-", 100, ui.get(refs.fov))
        Spacer = Spacer + 10
    end

    if IDmg and ui.get(refs.ovr[2]) then
        renderer.text(x-12+Scope_spacer, y+12+Spacer, 225, 225, 225, 255, "-", 100, "DMG:")
        renderer.text(x+6+Scope_spacer, y+12+Spacer, r, g, b, 255, "-", 100, ui.get(refs.ovr[3]))
        Spacer = Spacer + 10
    end

    if ISafe and ui.get(refs.FSPoint) then
        renderer.text(x-10+Scope_spacer, y+12+Spacer, 225, 225, 225, 255, "-", 100, "SAFE")
        Spacer = Spacer + 10
    end

    if IBaim and ui.get(refs.FBaim) then
        renderer.text(x-10+Scope_spacer, y+12+Spacer, 225, 225, 225, 255, "-", 100, "BAIM")
        Spacer = Spacer + 10
    end

end

--Hide/Show Defaults
local Lua_load = function()
    -- for i, v in pairs(AntiAim_tab) do 
    --     ui.set_visible(v, false)
    -- end
    Clantag()
end

local Lua_Unload = function()
    for i, v in pairs(AntiAim_tab) do 
        ui.set_visible(v, true)
    end
    ui.set_visible(refs.FL_Check1, true)
    ui.set_visible(refs.FL_Check2, true)
    ui.set_visible(refs.FL_Amount, true)
    ui.set_visible(refs.FL_Variance, true)
    ui.set_visible(refs.FL_Limit, true)
end

--Callbacks
client.set_event_callback("paint", run_painter)
client.set_event_callback("paint", Crosshair_indicators)
client.set_event_callback("paint", Watermark)
client.set_event_callback("paint", Bodyyaw_indicator)
client.set_event_callback("paint", feature_indi)
client.set_event_callback("paint_ui", timer_reset)
client.set_event_callback("paint_ui", Lua_load)
client.set_event_callback("paint_ui", menu_update)
client.set_event_callback("setup_command", Main)
client.set_event_callback("setup_command", get_state)
client.set_event_callback("run_command", manual_reso)
client.set_event_callback("run_command", update_fov)
client.set_event_callback("run_command", on_run_command)
client.set_event_callback("run_command", run_command)
client.set_event_callback("aim_miss", aim_miss)
client.set_event_callback("aim_hit", aim_hit)
client.set_event_callback('bullet_impact', bullet_impact)
client.set_event_callback("net_update_start", Roll_Resolver)
client.set_event_callback("paint", Desync_Resolver)
client.set_event_callback("player_death", local_death)
client.set_event_callback("round_start", on_round_start)
client.set_event_callback("shutdown", Lua_Unload)
client.set_event_callback("shutdown", unload_lby)