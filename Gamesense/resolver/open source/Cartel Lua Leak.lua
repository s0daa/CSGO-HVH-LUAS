-- leaked by 9sicc
-- @param: Custom API Calls
local ffi = require 'ffi'
local pui = require 'gamesense/pui'
local http = {}
local base64 = require 'gamesense/base64'
local vector = require 'vector'

local plist_set, plist_get = plist.set, plist.get
local getplayer = entity.get_players
local entitiy_is_enemy = entity.is_enemy

local steamname = panorama.open("CSGOHud").MyPersonaAPI.GetName()

local function lerp(a, b, t)
    return a + (b - a) * t
end

local screen_width, screen_height = client.screen_size()

local function lerp(a, b, t)
    return a + (b - a) * t
end

local notification = {
    start_time = 0,       
    check = false,        
    start_time2 = 0,      
    check2 = false,       
    alpha = 0,            
    text_alpha = 0,       
    menu_alpha = 0        
}

local ba = [[
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
  <path d="M12 3a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3zm-1 2h2v6h-2zm-5 1c-2 2-3 4-2 6s3 3 5 1 1-4-1-6zm8 0c2 2 3 4 1 6s-5 1-5-1 1-4 1-6zm-3 7h2v6a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-6z" fill="#ffffff"/>
</svg>
]]

notification.on_load = function()
    local self = notification

    self.alpha = lerp(self.alpha, self.check and 0 or 1, globals.frametime() * 6)
    self.menu_alpha = lerp(self.menu_alpha, ui.is_menu_open() and 1 or 0, globals.frametime() * 6)
    self.text_alpha = lerp(self.text_alpha, self.check2 and 1 or 0, globals.frametime() * 6)

    local function draw_notification_bar(x, y, width, height, r, g, b, a)
        renderer.gradient(x + 30, y + 2, width - 4, height - 4, 15, 15, 15, a / 2, 0, 0, 0, 0, true)
        renderer.rectangle(x, y, 30, height, 25, 25, 25, a)
        renderer.triangle(x, y, x, y + height, x - 10, y + height, 25, 25, 25, a)
        renderer.triangle(x + 30, y, x + 30, y + height, x + 30 + 10, y, 25, 25, 25, a)
        renderer.gradient(x - 1, y - 2, 41, 2, r, g, b, a, r, g, b, a, true)
        renderer.line(x, y - 2, x - 10, y - 2 + height + 1, r, g, b, a)
        renderer.line(x - 1, y - 2, x - 1 - 10, y - 2 + height + 1, r, g, b, a)
        renderer.line(x - 2, y - 2, x - 2 - 10, y - 2 + height + 1, r, g, b, a)
        renderer.line(x + 41, y - 1, x + 41 - 10, y - 1 + height, 10, 10, 10, a)
        
        local icon_texture = renderer.load_svg(ba or "", 23, 23)
        renderer.texture(icon_texture, x + 4, y - 1, 23, 23, r, g, b, a, "f")
    end

    local menu_x, menu_y = ui.menu_position()
    local r, g, b, a = 255, 255, 255, 255 

    draw_notification_bar(menu_x + 12, menu_y - 25, 300 * self.menu_alpha, 20, r, g, b, a * self.menu_alpha)

    local gradient_text = "C A R T E L | DISCORD.GG/ROLLMOPS" 

    renderer.text(menu_x + 12 + 40 + 1, menu_y - 22 - 1, 0, 0, 0, 255 * self.menu_alpha, nil, nil, "C A R T E L")
    renderer.text(menu_x + 12 + 40 - 1, menu_y - 22 + 1, 0, 0, 0, 255 * self.menu_alpha, nil, nil, "C A R T E L")
    renderer.text(menu_x + 12 + 40 - 1, menu_y - 22 - 1, 0, 0, 0, 255 * self.menu_alpha, nil, nil, "C A R T E L")
    renderer.text(menu_x + 12 + 40 + 2, menu_y - 22 + 2, 0, 0, 0, 255 * self.menu_alpha, nil, nil, "C A R T E L")
    renderer.text(menu_x + 12 + 40 + 1, menu_y - 22 + 1, r, g, b, 255 * self.menu_alpha, nil, nil, gradient_text)
    renderer.text(menu_x + 12 + 40, menu_y - 22, 255, 255, 255, 255 * self.menu_alpha, nil, nil, "C A R T E L")

    local current_time = globals.realtime()
    if self.start_time2 + 3 < current_time then
        self.start_time2 = current_time
        self.check2 = true
    end
    if self.start_time + 5 < current_time then
        self.start_time = current_time
        self.check = true
    end
end

local y = 0
local alpha = 255

client.set_event_callback('paint_ui', function()
    local screen = vector(client.screen_size())
    local size = vector(screen.x, screen.y)

    local sizing = lerp(0.1, 0.9, math.sin(globals.realtime() * 0.9) * 0.5 + 0.5)
    local rotation = lerp(0, 360, globals.realtime() % 1)
    alpha = lerp(alpha, 0, globals.frametime() * 0.5)
    y = lerp(y, 20, globals.frametime() * 2)

    renderer.rectangle(0, 0, size.x, size.y, 13, 13, 13, alpha)
    renderer.circle_outline(screen.x / 2, screen.y / 2, 255, 255, 255, alpha, 20, rotation, sizing, 3)
    renderer.text(screen.x / 2, screen.y / 2 + 40, 255, 255, 255, alpha, 'c', 0, 'Loading...')
    renderer.text(screen.x / 2, screen.y / 2 + 60, 255, 255, 255, alpha, 'c', 0, 'Welcome - ' .. steamname)
    renderer.text(screen.x / 2, screen.y / 2 + 80, 255, 255, 255, alpha, 'c', 0, 'discord.gg/rollmops')

    notification.on_load()
end)

local animation_chars = {
    "                  âœ¦ Cartel Beta  âœ¦",
    "                  âœ§ Cartel Beta  âœ§"
}

local tooltips = {
    backtrack = {[2] = "Default", [7] = "Maximum"}
}

local vars = {
    pState = 1
}

local ref = {
    aimbot = ui.reference("RAGE", "Aimbot", "Enabled"),
    fd = ui.reference("Rage", "Other", "Duck peek assist"),
    qp = {ui.reference("Rage", "Other", "Quick peek assist")},
    qpm = ui.reference('Rage', 'Other', 'Quick peek assist mode'),
    dt = {ui.reference("Rage", "Aimbot", "Double Tap")},
    baim = {ui.reference("Rage", "Aimbot", "Force body aim")},
    safe = {ui.reference("Rage", "Aimbot", "Force safe point")},
    dt_fl = ui.reference("Rage", "Aimbot", "Double tap fake lag limit"),
    hs = {ui.reference("AA", "Other", "On shot anti-aim")},
    dt_fl = ui.reference("Rage", "Aimbot", "Double tap fake lag limit"),
}

local refs_aa = {
	enable = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
    yawjitter = { ui.reference("AA", "Anti-aimbot angles", "yaw jitter") },
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
	yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    freestand = { ui.reference("AA", "anti-aimbot angles", "freestanding") },
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
    slow = { ui.reference("AA", "Other", "Slow motion") },
}

local animation_speed = 0.5 
local last_update = globals.realtime() 
local animation_running = false

local menu = {

    resolver_label = ui.new_label("LUA", "A", animation_chars[1]),
    resolver_enabled = ui.new_checkbox("LUA", "A", "[Cartel] Beta Resolver  âš¡"),
    clantag_enabled = ui.new_checkbox("LUA", "A", "[Cartel] Clan Tag"),
    esp_enabled = ui.new_checkbox("LUA", "A", "[Cartel] Lagcomp Box"),

    label1 = ui.new_label("LUA", "A", " "),
    label2 = ui.new_label("LUA", "A", "\a808080FFâ€¢ \aDCDCDCFFBacktrack"),
    backtrack_exploit = ui.new_checkbox("LUA", "A", "[Cartel] Enhance Backtrack"),
    backtrack_value = ui.new_slider("LUA", "A", "\a808080FFâ€¢ \aDCDCDCFFValue", 2, 7, 1, true, nil, 0.1, tooltips.backtrack),

    label4 = ui.new_label("LUA", "A", " "),
    label5 = ui.new_label("LUA", "A", "\a808080FFâ€¢ \aDCDCDCFFAimbot Helpers"),
    predict_enable = ui.new_checkbox("LUA", "A", "[Cartel] Anti Defensive"),
    predict_accuracy = ui.new_checkbox("LUA", "A", "\a808080FFâ€¢ \aDCDCDCFFAccuracy boost"),
    predict_states = ui.new_multiselect("LUA", "A", "\a808080FFâ€¢ \aDCDCDCFFEnable on", {"Standing", "Moving", "Crouching", "Sneaking"}),

    label7 = ui.new_label("LUA", "A", " "),
    label8 = ui.new_label("LUA", "A", "\a808080FFâ€¢ \aDCDCDCFFMisc"),
    disableinterpolation = ui.new_checkbox("LUA", "A", "[Cartel] Disable interpolation"),
    prediction = ui.new_checkbox("LUA", "A", "[Cartel] Prediction"),
    ipeek = ui.new_checkbox("LUA", "A", "[Cartel] Ideal peek"),
    ipeekbind = ui.new_hotkey("LUA", "A", "\a808080FFâ€¢ \aDCDCDCFFIdeal peek"),
    ipeekopts = ui.new_multiselect("LUA", "A", "Options", {"Double-Tap", "Edge Yaw"}),
    unsafe_charge = ui.new_checkbox("LUA", "A", "[Cartel] Unsafe recharge"),

    scoreboard = ui.new_checkbox("VISUALS", "Other ESP", "Shared icon"),

    label10 = ui.new_label("LUA", "B", "\a808080FFâ€¢ \aDCDCDCFFBuy Bot"),
    buybot_checkbox = ui.new_checkbox("Lua", "B", "Enable Buybot"),
    disable_on_pistol_checkbox = ui.new_checkbox("Lua", "B", "Disable Buybot on Pistol Round"),

    primary_weapon_combo = ui.new_combobox("Lua", "B", "Primary Weapon", {
        "None", "AK-47", "M4A4", "M4A1-S", "AWP", "SG553", "UMP45", "P90", "MAC-10", "Nova", "Mag7", "SSG 08", 
        "SCAR-20 / G3SG1", "FAMAS", "Galil AR"
    }),
    secondary_weapon_combo = ui.new_combobox("Lua", "B", "Secondary Weapon", {
        "None", "Glock", "USP-S", "P250", "Deagle", "Tec-9 / Five-SeveN", "CZ75", "Dual Berettas"
    }),
    grenades_checkbox = ui.new_checkbox("Lua", "B", "Grenades"),
    armor_checkbox = ui.new_checkbox("Lua", "B", "Kevlar"),
    taser_checkbox = ui.new_checkbox("Lua", "B", "Taser")
}


local function update_ui()

    local is_backtrack_enabled = ui.get(menu.backtrack_exploit)
    ui.set_visible(menu.backtrack_value, is_backtrack_enabled)

    local is_predict_enabled = ui.get(menu.predict_enable)
    ui.set_visible(menu.predict_accuracy, is_predict_enabled)
    ui.set_visible(menu.predict_states, is_predict_enabled)

    local is_ipeek_enabled = ui.get(menu.ipeek)
    ui.set_visible(menu.ipeekbind, is_ipeek_enabled)
    ui.set_visible(menu.ipeekopts, is_ipeek_enabled)
end

update_ui()

ui.set_callback(menu.backtrack_exploit, update_ui)
ui.set_callback(menu.predict_enable, update_ui)
ui.set_callback(menu.ipeek, update_ui)

ui.set(menu.scoreboard, true) 

local function animate_text()
    if not ui.is_menu_open() then
        animation_running = false
        return
    end

    local current_time = globals.realtime()
    if current_time - last_update >= animation_speed then
        local current_index = (animation_running % #animation_chars) + 1
        ui.set(menu.resolver_label, animation_chars[current_index])
        last_update = current_time
        animation_running = current_index 
    end

    client.delay_call(0.05, animate_text)
end

-- @param: Resolver

function get_velocity()
    if not entity.get_local_player() then return end
    local first_velocity, second_velocity = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
    
    return speed
end

local ground_tick = 1
function get_state(speed)
    if not entity.is_alive(entity.get_local_player()) then return end
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    if land == true then ground_tick = ground_tick + 1 else ground_tick = 0 end

    if bit.band(flags, 1) == 1 then
        if ground_tick < 10 then if bit.band(flags, 4) == 4 then return 5 else return 4 end end
        if bit.band(flags, 4) == 4 or ui.get(ref.fakeduck) then 
            return 6 -- crouching
        else
            if speed <= 3 then
                return 2 -- standing
            else
                if ui.get(ref.slide[2]) then
                    return 7 -- slowwalk
                else
                    return 3 -- moving
                end
            end
        end
    elseif bit.band(flags, 1) == 0 then
        if bit.band(flags, 4) == 4 then
            return 5 -- air-c
        else
            return 4 -- air
        end
    end
end

ffi.cdef[[
    struct animation_layer_t {
        char pad20[24];
        uint32_t m_nSequence;
        int iOutSequenceNr;
        int iInSequenceNr;
        int iOutSequenceNrAck;
        int iOutReliableState;
        int iInReliableState;
        int iChokedPackets;
        bool m_bIsBreakingLagComp;
        float m_flPrevCycle;
        float m_flWeight;
        char pad20[8];
        float m_flCycle;
        void *m_pOwner;
        char pad_0038[ 4 ]; 
    };

    struct c_animstate { 
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x5
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAomunt; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    };

    typedef struct
    {
        float   m_anim_time;		
        float   m_fade_out_time;	
        int     m_flags;			
        int     m_activity;			
        int     m_priority;			
        int     m_order;			
        int     m_sequence;			
        float   m_prev_cycle;		
        float   m_weight;			
        float   m_weight_delta_rate;
        float   m_playback_rate;	
        float   m_cycle;			
        void* m_owner;			
        int     m_bits;				
    } C_AnimationLayer;

    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);

    typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
    typedef bool(__thiscall* console_is_visible)(void*);
]]

local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
local VGUI_System010 =  client.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
local get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)
local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity is nil', 2)
local get_client_entity_bind = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*,int)")
local get_inaccuracy = vtable_thunk(483, "float(__thiscall*)(void*)")

local angle3d_struct = ffi.typeof("struct { float pitch; float yaw; float roll; }")
local vec_struct = ffi.typeof("struct { float x; float y; float z; }")

local cUserCmd =
    ffi.typeof(
    [[
    struct
    {
        uintptr_t vfptr;
        int command_number;
        int tick_count;
        $ viewangles;
        $ aimdirection;
        float forwardmove;
        float sidemove;
        float upmove;
        int buttons;
        uint8_t impulse;
        int weaponselect;
        int weaponsubtype;
        int random_seed;
        short mousedx;
        short mousedy;
        bool hasbeenpredicted;
        $ headangles;
        $ headoffset;
        bool send_packet;
        int unknown_float2;
        int tickbase_shift;
        int unknown_float3;
        int unknown_float4;
    }
    ]],
    angle3d_struct,
    vec_struct,
    angle3d_struct,
    vec_struct
)

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

local last_sim_time = 0
local defensive_until = 0
local function is_defensive_active()
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
    end

    last_sim_time = sim_time

    return defensive_until > tickcount
end

local function is_vulnerable()
    for _, v in ipairs(entity.get_players(true)) do
        local flags = (entity.get_esp_data(v)).flags

        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
            return true
        end
    end

    return false
end

contains = function(tbl, arg)
    for index, value in next, tbl do 
        if value == arg then 
            return true end 
        end 
    return false
end

local animations = {anim_list = {}}
animations.math_clamp = function(value, min, max) return math.min(max, math.max(min, value)) end
animations.math_lerp = function(a, b_, t) local t = animations.math_clamp(globals.frametime() * (0.045 * 175), 0, 1) if type(a) == 'userdata' then r, g, b, a = a.r, a.g, a.b, a.a e_r, e_g, e_b, e_a = b_.r, b_.g, b_.b, b_.a r = math_lerp(r, e_r, t) g = math_lerp(g, e_g, t) b = math_lerp(b, e_b, t) a = math_lerp(a, e_a, t) return color(r, g, b, a) end local d = b_ - a d = d * t d = d + a if b_ == 0 and d < 0.01 and d > -0.01 then d = 0 elseif b_ == 1 and d < 1.01 and d > 0.99 then d = 1 end return d end
animations.new = function(name, new, remove, speed) if not animations.anim_list[name] then animations.anim_list[name] = {} animations.anim_list[name].color = {0, 0, 0, 0} animations.anim_list[name].number = 0 animations.anim_list[name].call_frame = true end if remove == nil then animations.anim_list[name].call_frame = true end if speed == nil then speed = 0.010 end if type(new) == 'userdata' then lerp = animations.math_lerp(animations.anim_list[name].color, new, speed) animations.anim_list[name].color = lerp return lerp end lerp = animations.math_lerp(animations.anim_list[name].number, new, speed) animations.anim_list[name].number = lerp return lerp end

local function choking(cmd)
    local choke = false

    if cmd.allow_send_packet == false or cmd.chokedcommands > 1 then
        choke = true
    else
        choke = false
    end

    return choke
end

local rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end
local hex_to_rgba = function(hex)
    hex = hex:gsub('#', '')
    return tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6)), tonumber('0x' .. hex:sub(7, 8)) or 255
end
function d_lerp(a, b, t)
    return a + (b - a) * t
end
function d_clamp(x, minval, maxval)
    if x < minval then
        return minval
    elseif x > maxval then
        return maxval
    else
        return x
    end
end

local function animated_text(x, y, speed, color1, color2, flags, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10  
        local wave = math.cos(1 * speed * curtime / 2 + x / 400)

        local color = rgba_to_hex(
            math.max(0, d_lerp(color1.r, color2.r, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.g, color2.g, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.b, color2.b, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.a, color2.a, d_clamp(wave, 0, 1)))
        )
        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
    end
    
    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, flags, nil, final_text)
end

prevent_mouse = function(cmd)
    if ui.is_menu_open() then
        cmd.in_attack = false
    end
end

local printc do
    ffi.cdef[[
        typedef struct { uint8_t r; uint8_t g; uint8_t b; uint8_t a; } color_struct_t;
    ]]

	local print_interface = ffi.cast("void***", client.create_interface("vstdlib.dll", "VEngineCvar007"))
	local color_print_fn = ffi.cast("void(__cdecl*)(void*, const color_struct_t&, const char*, ...)", print_interface[0][25])

    -- 
    local hex_to_rgb = function (hex)
        return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16), tonumber(hex:sub(7, 8), 16)
    end
	
	local raw = function(text, r, g, b, a)
		local col = ffi.new("color_struct_t")
		col.r, col.g, col.b, col.a = r or 217, g or 217, b or 217, a or 255
	
		color_print_fn(print_interface, col, tostring(text))
	end

	printc = function (...)
		for i, v in ipairs{...} do
			local r = "\aD9D9D9"..v
			for col, text in r:gmatch("\a(%x%x%x%x%x%x)([^\a]*)") do
				raw(text, hex_to_rgb(col))
			end
		end
		raw "\n"
	end
end

in_bounds = function(x1, y1, x2, y2)
    mouse_x, mouse_y = ui.mouse_position()

    if (mouse_x > x1 and mouse_x < x2) and (mouse_y > y1 and mouse_y < y2) then
        return true
    end
    
    return false
end

function extrapolate_position(xpos,ypos,zpos,ticks,player)
    local x,y,z = entity.get_prop(player, "m_vecVelocity")
    for i = 0, ticks do
        xpos =  xpos + (x * globals.tickinterval())
        ypos =  ypos + (y * globals.tickinterval())
        zpos =  zpos + (z * globals.tickinterval())
    end
    return xpos,ypos,zpos
end

math.clamp = function(v, min, max)
    if min > max then min, max = max, min end
    if v > max then return max end
    if v < min then return v end
    return v
end

math.angle_diff = function(dest, src)
    local delta = 0.00

    delta = math.fmod(dest - src, 360.0)

    if dest > src then
        if delta >= 180 then delta = delta - 360 end
    else
        if delta <= -180 then delta = delta + 360 end
    end

    return delta
end

math.angle_normalize = function(angle)
    local ang = 0.0
    ang = math.fmod(angle, 360.0)

    if ang < 0.0 then ang = ang + 360 end

    return ang
end

math.anglemod = function(a)
    local num = (360 / 65536) * bit.band(math.floor(a * (65536 / 360.0), 65535))
    return num
end

math.approach_angle = function(target, value, speed)
    target = math.anglemod(target)
    value = math.anglemod(value)

    local delta = target - value

    if speed < 0 then speed = -speed end

    if delta < -180 then
        delta = delta + 360
    elseif delta > 180 then
        delta = delta - 360
    end

    if delta > speed then
        value = value + speed
    elseif delta < -speed then
        value = value - speed
    else
        value = target
    end

    return value
end

math.vec_length2d = function(vec)
    root = 0.0
    sqst = vec.x * vec.x + vec.y * vec.y
    root = math.sqrt(sqst)
    return root
end

function samdadn(ent, tbl, array)
    local x, y, z = entity.get_prop(ent, tbl, (array or nil))
    return {x = x, y = y, z = z}
end

function globals.is_connected()
    local lp = entity.get_local_player()

    if lp ~= nil and lp > 0 then return false
        else return true end
end

local entity_list_ptr = ffi.cast("void***", client.create_interface("client.dll",
                                                                 "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntityHandle_4242425_t",
                                      entity_list_ptr[0][3])
local get_client_entity_by_handle_fn = ffi.cast(
                                           "GetClientEntityHandle_4242425_t",
                                           entity_list_ptr[0][4])

entity.get_address = function(idx)
    return get_client_entity_fn(entity_list_ptr, idx)
end

entity.get_animstate = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("struct c_animstate**", addr + 0x9960)[0]
end

entity.get_animlayer = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end

    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', addr) + 0x9960)[0]
end

renderer.circle_3d = function(pos, radius, start_at, percentage, segment, filled, r, g, b, a)
    local x, y, z = pos.x, pos.y, pos.z
    local old_x, old_y
    local end_at = math.floor(percentage * 360)
    local degrees = end_at - start_at
    local step = degrees / segment

    for rot = start_at, end_at, step do
        local rot_r = rot * (math.pi / 180)
        local line_x = radius * math.cos(rot_r) + x
        local line_y = radius * math.sin(rot_r) + y

        local curr = { renderer.world_to_screen(line_x, line_y, z) }
        local cur = { renderer.world_to_screen(x, y, z) }

        if curr[1] ~= nil and curr[2] ~= nil and old_x ~= nil then
            if filled then
                renderer.triangle(curr[1], curr[2], old_x, old_y, cur[1], cur[2], r, g, b, a)
            else
                renderer.line(curr[1], curr[2], old_x, old_y, r, g, b, a)
            end
        end

        old_x, old_y = curr[1], curr[2]
    end
end

nigger = function(val)
    if val < 0 then
        return val*-1
    else
        return val
    end
end

local degree_to_radian = function(degree)
	return (math.pi / 180) * degree
end

local angle_to_vector = function(x, y)
	local pitch = degree_to_radian(x)
	local yaw = degree_to_radian(y)
	return math.cos(pitch) * math.cos(yaw), math.cos(pitch) * math.sin(yaw), -math.sin(pitch)
end

local set_movement = function(cmd, desired_pos)
    local local_player = entity.get_local_player()
	local vec_angles = {
		vector(
			entity.get_origin( local_player )
		):to(
			desired_pos
		):angles()
	}

    local pitch, yaw = vec_angles[1], vec_angles[2]

    cmd.in_forward = 1
    cmd.in_back = 0
    cmd.in_moveleft = 0
    cmd.in_moveright = 0
    cmd.in_speed = 0
    cmd.forwardmove = 800
    cmd.sidemove = 0
    cmd.move_yaw = yaw
end

local function clamp(num, min, max)
    if num < min then
        num = min
    elseif num > max then
        num = max
    end

    return num
end

local function TIME_TO_TICKS( time )
    local t_Return = time / globals.tickinterval()
    return math.floor(t_Return)
end

local function calc_lerp()
	local update_rate = clamp( cvar.cl_updaterate:get_float(), cvar.sv_minupdaterate:get_float(), cvar.sv_maxupdaterate:get_float() )
	local lerp_ratio = clamp( cvar.cl_interp_ratio:get_float(), cvar.sv_client_min_interp_ratio:get_float(), cvar.sv_client_max_interp_ratio:get_float() )
  
	return clamp( lerp_ratio / update_rate, cvar.cl_interp:get_float(), 6 )
end

local function player()
    local enemies = entity.get_players(true)

    for itter = 1, #enemies do
        i = enemies[itter]
    end

    if i == nil then i = 0 end
    
    return i
end

function animation_layer_t_struct(_Entity)
    if not (_Entity) then
        return
    end
    local player_ptr = ffi.cast( "void***", get_client_entity(ientitylist, _Entity))
    local animstate_ptr = ffi.cast( "char*" , player_ptr ) + 0x9960
    local state = ffi.cast( "struct animation_layer_t**", animstate_ptr )[0]

    return state
end

local function hook_value(buf)
    local ptr = ffi.cast("uintptr_t",ffi.cast("unsigned long", buf))
    local ptr_s = ffi.cast("uintptr_t", ffi.cast(ptr, client_sig))
    local result_hook = tonumber(ptr_s)
    return result_hook
end

local function getspeed(player_index)
    return vector(entity.get_prop(player_index, "m_vecVelocity")):length()
end

local limiter = function(limit_min, value_to_limit, limit_max)
    if value_to_limit > limit_max then
        return limit_max
    elseif value_to_limit < limit_min then
        return limit_min
    elseif value_to_limit < limit_max then
        return value_to_limit
    elseif value_to_limit > limit_min then
        return value_to_limit
    end
end

----------------------------------------------------------

--local box = ui.new_checkbox("RAGE", "Other", "Resolver")

------------------------------------------------
local RESOLVER = {
    ORIGINAL = 0,
    NEGATIVE = -1,
    POSITIVE = 1,
    HALF_NEGATIVE = -0.5,
    HALF_POSITIVE = 0.5
}

local ANIMLAYERS = {
    AIMMATRIX = 0 ,
	WEAPON_ACTION = 1 ,
	WEAPON_ACTION_RECROUCH = 2 ,
	ADJUST = 3 ,
	JUMP_OR_FALL = 4 ,
	LAND_OR_CLIMB = 5 ,
	MOVE = 6 ,
	STRAFECHANGE = 7 ,
	WHOLE_BODY = 8 ,
	FLASHED = 9 ,
	FLINCH = 10 ,
	ALIVELOOP = 11 ,
	LEAN = 12 ,
}

local m_iMaxRecords = 30

local loopsaid = {}
    function loopsaid.deepcopy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end

    local s = seen or {}
    local res = {}
    s[obj] = res
    for k, v in next, obj do res[loopsaid.deepcopy(k, s)] = loopsaid.deepcopy(v, s) end
    return setmetatable(res, getmetatable(obj))
end

function loopsaid.push_back(tbl, push, max)
    local ret_tbl = loopsaid.deepcopy(tbl)
    if not max then max = #ret_tbl end
    for i = max - 1, 1, -1 do
        if ret_tbl[i] ~= nil then
            ret_tbl[i + 1] = ret_tbl[i] 
        end
        if i == 1 then
            ret_tbl[i] = push
        end
    end
    return ret_tbl
end

local resolver = {}
local records = {}
resolver.get_layers = function(idx)
    local layers = {}
    local get_layers = entity.get_animlayer(idx)
    for i = 1, 12 do
        local layer = get_layers[i]
        if not layer then goto continue end

        if not layers[i] then
            layers[i] = {}
        end

        layers[i].m_playback_rate = layer.m_playback_rate
        layers[i].m_sequence = layer.m_sequence
        
        ::continue::
    end
    return layers
end

records.layers = {}
resolver.update_layers = function(idx)
    if not records.layers[idx] then
        records.layers[idx] = {}
    end
    local current_layer = entity.get_animlayer(idx)
    records.layers[idx] = loopsaid.push_back(records.layers[idx], current_layer, m_iMaxRecords)
end

resolver.get_data = function(idx)
    local animstate = entity.get_animstate(idx)
    if not animstate then return end

    local ent = idx
    local ret = {}
    ret.m_flGoalFeetYaw = animstate.m_flGoalFeetYaw
    ret.m_flEyeYaw = animstate.m_flEyeYaw
    ret.m_iEntity = ent > 0 and ent or nil
    ret.m_vecVelocity = ret.m_iEntity and samdadn(ent, 'm_vecVelocity') or {x = 0, y = 0, z = 0}
    ret.m_flDifference = math.angle_diff(animstate.m_flEyeYaw, animstate.m_flGoalFeetYaw)
    ret.m_flFeetSpeedForwardsOrSideWays = animstate.m_flFeetSpeedForwardsOrSideWays
    ret.m_flStopToFullRunningFraction = animstate.m_flStopToFullRunningFraction
    ret.m_fDuckAmount = animstate.m_fDuckAmount
    ret.m_flPitch = animstate.m_flPitch

    return ret
end

records.angles = {}
resolver.update_angles = function(idx)
    if not records.angles[idx] then
        records.angles[idx] = {}
    end
    local current_angles = resolver.get_data(idx)
    records.angles[idx] = loopsaid.push_back(records.angles[idx], current_angles, m_iMaxRecords)
end

local ROTATION = {
    SERVER = 1,
    CENTER = 2,
    LEFT = 3,
    RIGHT = 4
}

records.safepoints_container = {}
resolver.get_safepoints = function(idx, side, desync)
    if not records.safepoints_container[idx] then
        records.safepoints_container[idx] = {}
    end
    for i = 1, 4 do
        if not records.safepoints_container[idx][i] then
            records.safepoints_container[idx][i] = {}
            records.safepoints_container[idx][i].m_playback_rate = 0
        end
        
    end
    records.safepoints_container[idx][1].m_playback_rate = records.layers[idx][1][6].m_playback_rate

    local m_flDesync = side * desync
    if side < 0 then
        if m_flDesync <= -44 then
            records.safepoints_container[idx][4].m_playback_rate = records.safepoints_container[idx][1].m_playback_rate
        end
    elseif side > 0 then
        if m_flDesync >= 44 then
            records.safepoints_container[idx][3].m_playback_rate = records.safepoints_container[idx][1].m_playback_rate
        end
    else
        if desync <= 29 then
            records.safepoints_container[idx][2].m_playback_rate = records.safepoints_container[idx][1].m_playback_rate
        end
    end

    return records.safepoints_container[idx]
end

resolver.safepoints = {}
resolver.update_safepoints = function(idx, side, desync)
    if not resolver.safepoints[idx] then
        resolver.safepoints[idx] = {}
    end
    
    local current_safepoints = resolver.get_safepoints(idx, side, desync)
    resolver.safepoints[idx] = loopsaid.push_back(resolver.safepoints[idx], current_safepoints, m_iMaxRecords)
end

resolver.get_layer_side = function(idx, record)
    local m_iVelocity = math.vec_length2d(records.angles[idx][record].m_vecVelocity)
    if m_iVelocity < 2 then return end
    local layer = resolver.safepoints[idx][record]

    local m_center_layer = math.abs(layer[1].m_playback_rate - layer[2].m_playback_rate)
    local m_left_layer = math.abs(layer[1].m_playback_rate - layer[3].m_playback_rate)
    local m_right_layer = math.abs(layer[1].m_playback_rate - layer[4].m_playback_rate)

    if m_center_layer < m_left_layer or m_right_layer <= m_left_layer then
        if m_center_layer >= m_right_layer or m_left_layer > m_right_layer then
            return 1
        end
    end
    return -1
end

function m_flMaxDesyncDelta(record)
    local speedfactor = math.clamp(record.m_flFeetSpeedForwardsOrSideWays, 0, 1)
    local avg_speedfactor = (record.m_flStopToFullRunningFraction * -0.3 - 0.2) * speedfactor + 1

    local duck_amount = record.m_fDuckAmount

    if duck_amount > 0 then
        local max_velocity = math.clamp(record.m_flFeetSpeedForwardsOrSideWays, 0, 1)
        local duck_speed = duck_amount * max_velocity

        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return avg_speedfactor
end

resolver.run = function(idx, record, force)
    if not records.angles[idx] or not records.angles[idx][record] or not records.angles[idx][record + 1] then return end

    local animstate = records.angles[idx][record]
    local previous = records.angles[idx][record + 1]

    if not animstate.m_iEntity or not previous.m_iEntity then return false end

    local m_flMaxDesyncFloat = m_flMaxDesyncDelta(animstate)
    local m_flDesync = m_flMaxDesyncFloat * 58 + 1

    local m_flAbsDiff = animstate.m_flDifference
    local m_flPrevAbsDiff = previous.m_flDifference

    local m_iVelocity = math.vec_length2d(animstate.m_vecVelocity)
    local m_iPrevVelocity = math.vec_length2d(previous.m_vecVelocity)

    local side = RESOLVER.ORIGINAL
    if animstate.m_flDifference <= 1 then
        side = RESOLVER.POSITIVE
    elseif animstate.m_flDifference >= 1 then
        side = RESOLVER.NEGATIVE
    end

    local m_bShouldResolve = true

    if m_flAbsDiff > 0 or m_flPrevAbsDiff > 0 then
        if m_flAbsDiff < m_flPrevAbsDiff then
            m_bShouldResolve = false

            if m_iVelocity >= m_iPrevVelocity then
                m_bShouldResolve = true
            end
        end

        if m_bShouldResolve then
            local m_flCurrentAngle = math.max(m_flAbsDiff, m_flPrevAbsDiff)
            if m_flAbsDiff <= 10.0 and m_flPrevAbsDiff <= 10.1 then
                m_flDesync = m_flCurrentAngle
            elseif m_flAbsDiff <= 40.0 and m_flPrevAbsDiff <= 40.0 then
                m_flDesync = math.max(29.0, m_flCurrentAngle)
            else
                m_flDesync = math.clamp(m_flCurrentAngle, 29.0, 58)
            end
        end
    end

    if (m_flAbsDiff < 1 or m_flPrevAbsDiff < 1 or side == 0) and not force then
        return
    end

    return {
        angle = m_flDesync,
        side = side,
        record = record,
        pitch = animstate.m_flPitch
    }
end

resolver.init = function()
    local lp = entity.get_local_player()

    if not globals.is_connected() then
        resolver.hkResetBruteforce()
    elseif globals.is_connected() and entity.get_prop(lp, 'm_iHealth') < 1 then
        resolver.hkResetBruteforce()
    elseif ui.get(menu.resolver_enabled) == true then
        resolver.hkResetBruteforce()
    end
    if globals.is_connected() or not ui.get(menu.resolver_enabled) == true then return end

    local available_clients = entity.get_players(true) 

    if entity.get_prop(lp, 'm_iHealth') >= 1 then
        resolver.reset_bruteforce = true
    end

    for array = 1, #available_clients do
        local idx = available_clients[array]

        if idx == lp then goto continue end

        if not ui.get(menu.resolver_enabled) == true then 
            plist.set(idx, 'Force body yaw', false)
            goto continue 
        end

        resolver.update_angles(idx)

        local info = nil
        local forced = false
        for record = 1, m_iMaxRecords - 1 do
            info = resolver.run(idx, record)
            if info then
                goto set_angle
            elseif record == (m_iMaxRecords - 1) then
                forced = true
                info = resolver.run(idx, 1, true)
            end
        end

        ::set_angle::
        if not info then goto continue end


        resolver.apply(idx, info.angle, info.side, info.pitch)

        ::continue::
    end
end

resolver.apply = function(m_iEntityIndex, m_flDesync, m_iSide, m_flPitch)
    local m_flFinalAngle = m_flDesync * m_iSide
    if m_flFinalAngle < 0 then
        m_flFinalAngle = math.ceil(m_flFinalAngle - 0.5)
    else
        m_flFinalAngle = math.floor(m_flFinalAngle + 0.5)
    end
    if m_iSide == 0 then
        plist.set(m_iEntityIndex, 'Force body yaw', false)
        return
    end
    plist.set(m_iEntityIndex, 'Force body yaw', true)
    plist.set(m_iEntityIndex, 'Force body yaw value', m_flFinalAngle)
end

resolver.bruteforce = {}
resolver.reset_bruteforce = false

resolver.hkResetBruteforce = function()
    for i = 1, 64 do
        resolver.bruteforce[i] = 0
        if i == 64 then
            resolver.reset_bruteforce = false
        end
    end
end
-----------------
defensive_data = {}
local defensive_resolver = function()
    if not ui.get(menu.resolver_enabled) == true then return end

    local enemies = entity.get_players(true)
    for i, enemy_ent in ipairs(enemies) do
        if defensive_data[enemy_ent] == nil then
            defensive_data[enemy_ent] = {
                pitch = 0,
                vl_p = 0,
                timer = 0,
            }
        else
            defensive_data[enemy_ent].pitch = entity.get_prop(enemy_ent, "m_angEyeAngles[0]")
            if is_defensive_active(enemy_ent) then
                if defensive_data[enemy_ent].pitch < 70 then
                    defensive_data[enemy_ent].vl_p = defensive_data[enemy_ent].vl_p + 1
                    defensive_data[enemy_ent].timer = globals.realtime() + 5
                end
            else
                if defensive_data[enemy_ent].timer - globals.realtime() < 0 then
                    defensive_data[enemy_ent].vl_p = 0
                    defensive_data[enemy_ent].timer = 0
                end
            end
        end

        if defensive_data[enemy_ent].vl_p > 3 then
            plist.set(enemy_ent,"force pitch", true)
            plist.set(enemy_ent,"force pitch value", 89)
        else
            plist.set(enemy_ent,"force pitch", false)
        end
    end
end

--------------

client.set_event_callback('net_update_end', function()
    local player = player()

    resolver.init()
    defensive_resolver()

end)


client.set_event_callback("aim_hit", function(e)
    if resolver.bruteforce[e.target] and resolver.bruteforce[e.target] > 0 and entity.get_prop(e.target, 'm_iHealth') < 1 then
        resolver.bruteforce[e.target] = 0
    end
end)

client.set_event_callback("aim_miss", function(e)
    if e.reason == '?' then
        if not resolver.bruteforce[e.target] then
            resolver.bruteforce[e.target] = 0
        end

        resolver.bruteforce[e.target] = resolver.bruteforce[e.target] + 1

        if resolver.bruteforce[e.target] > 2 then
            resolver.bruteforce[e.target] = 0
        end
    end
end)

------------------------------------------
-- End REsolver --
------------------------------------------

--#region backtrack
local backtrack_cache = {}

client.set_event_callback("setup_command", function()
    if ui.get(menu.backtrack_exploit) then

        local value = ui.get(menu.backtrack_value)
        cvar.sv_maxunlag:set_float(value / 10)

        local players = entity.get_players(true)
        for i = 1, #players do
            local player = players[i]

            if not backtrack_cache[player] then
                backtrack_cache[player] = {}
            end

            table.insert(backtrack_cache[player], entity.get_prop(player, "m_flSimulationTime"))

            if #backtrack_cache[player] > 42 then
                table.remove(backtrack_cache[player], 1)
            end

            local last_record = backtrack_cache[player][#backtrack_cache[player]]
            if last_record then
                entity.set_prop(player, "m_flSimulationTime", last_record)
            end
        end
    else
        cvar.sv_maxunlag:set_float(.2)
    end
end)

-- --#End region backtrack

--#region predict

local menu_3 = {
    predict_improve = {
        args = {
            cl_interp = {
                DEFAULT = 0.015625,
                SCOUT = 0.078125,
                OTHER = 0.031000
            },
            sv_max_allowed_net_graph = {
                DEFAULT = 1,
                CHANGE = 2
            },
            cl_interpolate = {
                DEFAULT = 1,
                CHANGE = 0
            },
            cl_interp_ratio = {
                DEFAULT = 2,
                CHANGE = 1
            }
        }
    } 
}
pred_ = false

function predict()
        if ui.get(menu.predict_enable) then
            if (ui.get(menu.predict_states) == "Standing" and vars.pState == 2) or
            (ui.get(menu.predict_states) == "Moving" and vars.pState == 4) or
            (ui.get(menu.predict_states) == "Crouching" and vars.pState == 5) or
            (ui.get(menu.predict_states) == "Sneaking" and vars.pState == 8) then         
                local local_player = entity.get_local_player()
                local weapon = entity.get_player_weapon(local_player)
                cvar.sv_max_allowed_net_graph:set_int(menu_3.predict_improve.args.sv_max_allowed_net_graph.CHANGE)
                cvar.cl_interpolate:set_int(menu_3.predict_improve.args.cl_interpolate.CHANGE)
                cvar.cl_interp_ratio:set_int(menu_3.predict_improve.args.cl_interp_ratio.CHANGE)
                if entity.get_classname(weapon) == 'CWeaponSSG08' then
                    cvar.cl_interp:set_float(menu_3.predict_improve.args.cl_interp.SCOUT)
                else
                    cvar.cl_interp:set_float(menu_3.predict_improve.args.cl_interp.OTHER)
                end
                pred_ = true
            else
                cvar.sv_max_allowed_net_graph:set_int(menu_3.predict_improve.args.sv_max_allowed_net_graph.DEFAULT)
                cvar.cl_interpolate:set_int(menu_3.predict_improve.args.cl_interpolate.DEFAULT)
                cvar.cl_interp_ratio:set_int(menu_3.predict_improve.args.cl_interp_ratio.DEFAULT)
                cvar.cl_interp:set_float(menu_3.predict_improve.args.cl_interp.DEFAULT)
                pred_ = false
            end
        else
            cvar.sv_max_allowed_net_graph:set_int(menu_3.predict_improve.args.sv_max_allowed_net_graph.DEFAULT)
            cvar.cl_interpolate:set_int(menu_3.predict_improve.args.cl_interpolate.DEFAULT)
            cvar.cl_interp_ratio:set_int(menu_3.predict_improve.args.cl_interp_ratio.DEFAULT)
            cvar.cl_interp:set_float(menu_3.predict_improve.args.cl_interp.DEFAULT)
            pred_ = false
        end
end

--#end region predict

--@param: Clan Tag
local clantag_frames = {
    "[Rollmops]",
    "[Rollmop]",
    "[Rollmo]",
    "[Rollm]",
    "[Roll]",
    "[Rol]",
    "[Ro]",
    "[Rol]",
    "[Roll]",
    "[Rollm]",
    "[Rollmo]",
    "[Rollmop]",
    "[Rollmops]"
}

local function set_clantag(tag)
    client.set_clan_tag(tag)
end

local function on_paint()
    if not ui.get(menu.clantag_enabled) then
        set_clantag("")
        return
    end
    if ui.is_menu_open() and not animation_running then
        animation_running = 1
        last_update = globals.realtime() 
        animate_text()
    end

    local tick = globals.tickcount()
    local frame_duration = 20 -- Number of ticks per frame ( Lower ticks Faster )
    local frame_index = math.floor((tick / frame_duration) % #clantag_frames) + 1

    local current_tag = clantag_frames[frame_index]
    set_clantag(current_tag)
end

--@param: Lag Comp box
local g_esp_data = { }
local g_sim_ticks, g_net_data = { }, { }

local globals_tickinterval = globals.tickinterval
local entity_is_enemy = entity.is_enemy
local entity_get_prop = entity.get_prop
local entity_is_dormant = entity.is_dormant
local entity_is_alive = entity.is_alive
local entity_get_origin = entity.get_origin
local entity_get_local_player = entity.get_local_player
local entity_get_player_resource = entity.get_player_resource
local entity_get_bounding_box = entity.get_bounding_box
local entity_get_player_name = entity.get_player_name
local renderer_text = renderer.text
local w2s = renderer.world_to_screen
local line = renderer.line
local table_insert = table.insert
local client_trace_line = client.trace_line
local math_floor = math.floor
local globals_frametime = globals.frametime

local sv_gravity = cvar.sv_gravity
local sv_jump_impulse = cvar.sv_jump_impulse

local time_to_ticks = function(t) return math_floor(0.5 + (t / globals_tickinterval())) end
local vec_substract = function(a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end
local vec_add = function(a, b) return { a[1] + b[1], a[2] + b[2], a[3] + b[3] } end
local vec_lenght = function(x, y) return (x * x + y * y) end

local get_entities = function(enemy_only, alive_only)
	local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    
    local result = {}

    local me = entity_get_local_player()
    local player_resource = entity_get_player_resource()
    
	for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true
        
        if enemy_only and not entity_is_enemy(player) then is_enemy = false end
        if is_enemy then
            if alive_only and entity_get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
            if is_alive then table_insert(result, player) end
        end
	end

	return result
end

local extrapolate = function(ent, origin, flags, ticks)
    local tickinterval = globals_tickinterval()

    local sv_gravity = sv_gravity:get_float() * tickinterval
    local sv_jump_impulse = sv_jump_impulse:get_float() * tickinterval

    local p_origin, prev_origin = origin, origin

    local velocity = { entity_get_prop(ent, 'm_vecVelocity') }
    local gravity = velocity[3] > 0 and -sv_gravity or sv_jump_impulse

    for i=1, ticks do
        prev_origin = p_origin
        p_origin = {
            p_origin[1] + (velocity[1] * tickinterval),
            p_origin[2] + (velocity[2] * tickinterval),
            p_origin[3] + (velocity[3]+gravity) * tickinterval,
        }

        local fraction = client_trace_line(-1, 
            prev_origin[1], prev_origin[2], prev_origin[3], 
            p_origin[1], p_origin[2], p_origin[3]
        )

        if fraction <= 0.99 then
            return prev_origin
        end
    end

    return p_origin
end

local function g_net_update()
	local me = entity_get_local_player()
    local players = get_entities(true, true)

	for i=1, #players do
		local idx = players[i]
        local prev_tick = g_sim_ticks[idx]
        
        if entity_is_dormant(idx) or not entity_is_alive(idx) then
            g_sim_ticks[idx] = nil
            g_net_data[idx] = nil
            g_esp_data[idx] = nil
        else
            local player_origin = { entity_get_origin(idx) }
            local simulation_time = time_to_ticks(entity_get_prop(idx, 'm_flSimulationTime'))
    
            if prev_tick ~= nil then
                local delta = simulation_time - prev_tick.tick

                if delta < 0 or delta > 0 and delta <= 64 then
                    local m_fFlags = entity_get_prop(idx, 'm_fFlags')

                    local diff_origin = vec_substract(player_origin, prev_tick.origin)
                    local teleport_distance = vec_lenght(diff_origin[1], diff_origin[2])

                    local extrapolated = extrapolate(idx, player_origin, m_fFlags, delta-1)
    
                    if delta < 0 then
                        g_esp_data[idx] = 1
                    end

                    g_net_data[idx] = {
                        tick = delta-1,

                        origin = player_origin,
                        predicted_origin = extrapolated,

                        tickbase = delta < 0,
                        lagcomp = teleport_distance > 4096,
                    }
                end
            end
    
            if g_esp_data[idx] == nil then
                g_esp_data[idx] = 0
            end

            g_sim_ticks[idx] = {
                tick = simulation_time,
                origin = player_origin,
            }
        end
	end
end

local function g_paint_handler()
    local me = entity_get_local_player()
    local player_resource = entity_get_player_resource()

    if not me or not entity_is_alive(me) then
        return
    end

	local observer_mode = entity_get_prop(me, "m_iObserverMode")
	local active_players = {}

	if (observer_mode == 0 or observer_mode == 1 or observer_mode == 2 or observer_mode == 6) then
		active_players = get_entities(true, true)
	elseif (observer_mode == 4 or observer_mode == 5) then
		local all_players = get_entities(false, true)
		local observer_target = entity_get_prop(me, "m_hObserverTarget")
		local observer_target_team = entity_get_prop(observer_target, "m_iTeamNum")

		for test_player = 1, #all_players do
			if (
				observer_target_team ~= entity_get_prop(all_players[test_player], "m_iTeamNum") and
				all_players[test_player ] ~= me
			) then
				table_insert(active_players, all_players[test_player])
			end
		end
	end

    if #active_players == 0 then
        return
    end

    for idx, net_data in pairs(g_net_data) do
        if entity_is_alive(idx) and entity_is_enemy(idx) and net_data ~= nil then
            if net_data.lagcomp then
                local predicted_pos = net_data.predicted_origin

                local min = vec_add({ entity_get_prop(idx, 'm_vecMins') }, predicted_pos)
                local max = vec_add({ entity_get_prop(idx, 'm_vecMaxs') }, predicted_pos)

                local points = {
                    {min[1], min[2], min[3]}, {min[1], max[2], min[3]},
                    {max[1], max[2], min[3]}, {max[1], min[2], min[3]},
                    {min[1], min[2], max[3]}, {min[1], max[2], max[3]},
                    {max[1], max[2], max[3]}, {max[1], min[2], max[3]},
                }

                local edges = {
                    {0, 1}, {1, 2}, {2, 3}, {3, 0}, {5, 6}, {6, 7}, {1, 4}, {4, 8},
                    {0, 4}, {1, 5}, {2, 6}, {3, 7}, {5, 8}, {7, 8}, {3, 4}
                }

                for i = 1, #edges do
                    if i == 1 then
                        local origin = { entity_get_origin(idx) }
                        local origin_w2s = { w2s(origin[1], origin[2], origin[3]) }
                        local min_w2s = { w2s(min[1], min[2], min[3]) }

                        if origin_w2s[1] ~= nil and min_w2s[1] ~= nil then
                            line(origin_w2s[1], origin_w2s[2], min_w2s[1], min_w2s[2], 47, 117, 221, 255)
                        end
                    end

                    if points[edges[i][1]] ~= nil and points[edges[i][2]] ~= nil then
                        local p1 = { w2s(points[edges[i][1]][1], points[edges[i][1]][2], points[edges[i][1]][3]) }
                        local p2 = { w2s(points[edges[i][2]][1], points[edges[i][2]][2], points[edges[i][2]][3]) }
            
                        line(p1[1], p1[2], p2[1], p2[2], 47, 117, 221, 255)
                    end
                end
            end

            local text = {
                [0] = '', [1] = 'LAG COMP BREAKER',
                [2] = 'SHIFTING TICKBASE'
            }

            local x1, y1, x2, y2, a = entity_get_bounding_box(idx)
            local palpha = 0

            if g_esp_data[idx] > 0 then
                g_esp_data[idx] = g_esp_data[idx] - globals_frametime()*2
                g_esp_data[idx] = g_esp_data[idx] < 0 and 0 or g_esp_data[idx]

                palpha = g_esp_data[idx]
            end

            local tb = net_data.tickbase or g_esp_data[idx] > 0
            local lc = net_data.lagcomp

            if not tb or net_data.lagcomp then
                palpha = a
            end

            if x1 ~= nil and a > 0 then
                local name = entity_get_player_name(idx)
                local y_add = name == '' and -8 or 0

                renderer_text(x1 + (x2-x1)/2, y1 - 18 + y_add, 255, 45, 45, palpha*255, 'c', 0, text[tb and 2 or (lc and 1 or 0)])
            end
        end
    end
end

--Misc things

function interpolate()
    if ui.get(menu.disableinterpolation) then
        cvar.cl_interpolate:set_int(0)
    else
        cvar.cl_interpolate:set_int(1)
    end
end

function impprediction()
    if ui.get(menu.prediction) then
        cvar.cl_interp_ratio:set_int(0)
        cvar.cl_interp:set_int(0)
        cvar.cl_updaterate:set_int(62)
    else
        cvar.cl_interp_ratio:set_int(1)
        cvar.cl_interp:set_int(0.15)
        cvar.cl_updaterate:set_int(64)
    end
end

local dtcache = {ui.get(ref.dt[2])}
local cacheddata = false

local function contains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

local function ipeekrun()
    local lp = entity.get_local_player()
    if not entity.is_alive(lp) then return end
    
    local yescode = ui.get(menu.ipeekopts)
    if ui.get(menu.ipeek) and ui.get(menu.ipeekbind) and ui.get(ref.qp[2]) then
        local toggled = "Always on"

        if cacheddata then
            dtcache = {ui.get(ref.dt[2])}
            cacheddata = false
        end
        
        if contains(yescode, "Double-Tap") then
            ui.set(ref.dt[2], toggled)
        end
        
        if contains(yescode, "Edge Yaw") then
            ui.set(refs_aa.edgeyaw, true)
        end
    else
        if not cacheddata then
            ui.set(ref.dt[2], dtcache[1]) 
            ui.set(refs_aa.edgeyaw, false)
            cacheddata = true
        end
    end
end

local timer = globals.tickcount()

client.set_event_callback('setup_command', function()

    if not ui.get(menu.unsafe_charge) then
        return
    end

    if ui.get(ref.dt[2]) or ui.get(ref.hs[2]) then
        if globals.tickcount() >= timer + 8 then
            ui.set(ref.aimbot, true)
        else
            ui.set(ref.aimbot, false)
        end
    else
        timer = globals.tickcount()
        ui.set(ref.aimbot, true)
    end
end)

client.set_event_callback('shutdown', function()
    ui.set(ref.aimbot, true)
end)

--@ End Misc

-- @buybot

local bought_this_round = false

local function reset_buybot()
    bought_this_round = false
end

local function update_visibility()
    local enabled = ui.get(menu.buybot_checkbox)
    
    ui.set_visible(menu.disable_on_pistol_checkbox, enabled)
    ui.set_visible(menu.primary_weapon_combo, enabled)
    ui.set_visible(menu.secondary_weapon_combo, enabled)
    ui.set_visible(menu.grenades_checkbox, enabled)
    ui.set_visible(menu.armor_checkbox, enabled)
    ui.set_visible(menu.taser_checkbox, enabled)
end

ui.set_callback(menu.buybot_checkbox, update_visibility)
update_visibility() 

local function has_weapon(weapon_name)
    local current_weapon = entity.get_player_weapon(entity.get_local_player())
    return current_weapon == weapon_name
end

local function buy_weapon()
    if bought_this_round then return end
    
    bought_this_round = true
    client.delay_call(0.1, function()
        local primary_weapon = ui.get(menu.primary_weapon_combo)
        local secondary_weapon = ui.get(menu.secondary_weapon_combo)

        local buy_commands = {}

        if primary_weapon and primary_weapon ~= "None" then
            local primary_weapon_cmd = {
                ["AK-47"] = "buy ak47",
                ["M4A4"] = "buy m4a4",
                ["M4A1-S"] = "buy m4a1_silencer",
                ["AWP"] = "buy awp",
                ["SG553"] = "buy sg553",
                ["UMP45"] = "buy ump45",
                ["P90"] = "buy p90",
                ["MAC-10"] = "buy mac10",
                ["Nova"] = "buy xm1014",
                ["Mag7"] = "buy mag7",
                ["SSG 08"] = "buy ssg08",
                ["SCAR-20 / G3SG1"] = "buy scar20",
                ["FAMAS"] = "buy famas",
                ["Galil AR"] = "buy galilar"
            }
            if primary_weapon_cmd[primary_weapon] and not has_weapon(primary_weapon) then
                table.insert(buy_commands, primary_weapon_cmd[primary_weapon])
            end
        end

        if secondary_weapon and secondary_weapon ~= "None" then
            local secondary_weapon_cmd = {
                ["Glock"] = "buy glock",
                ["USP-S"] = "buy usp_silencer",
                ["P250"] = "buy p250",
                ["Deagle"] = "buy deagle",
                ["Tec-9 / Five-SeveN"] = "buy tec9",
                ["CZ75"] = "buy cz75a",
                ["Dual Berettas"] = "buy elite"
            }
            if secondary_weapon_cmd[secondary_weapon] and not has_weapon(secondary_weapon) then
                table.insert(buy_commands, secondary_weapon_cmd[secondary_weapon])
            end
        end

        if ui.get(menu.grenades_checkbox) then
            table.insert(buy_commands, "buy smokegrenade")
            table.insert(buy_commands, "buy hegrenade")
            table.insert(buy_commands, "buy incgrenade")
        end

        if ui.get(menu.armor_checkbox) then
            table.insert(buy_commands, "buy vesthelm")
        end

        if ui.get(menu.taser_checkbox) then
            table.insert(buy_commands, "buy taser")
        end

        for _, cmd in ipairs(buy_commands) do
            client.exec(cmd)
        end
    end)
end

local function buybot_handler()
    if ui.get(menu.buybot_checkbox) and not bought_this_round then
        if not ui.get(menu.disable_on_pistol_checkbox) or not game_rules.is_pistol_round() then
            buy_weapon()
        end
    end
end

client.set_event_callback("round_start", reset_buybot)
client.set_event_callback("player_spawn", buybot_handler)

--buy bot end

-- Shared Logo 
local DEBUG_LEVEL = 0

local function get_local_steamid()
    return tostring(panorama.open().MyPersonaAPI.GetXuid())
end

client.set_event_callback("player_connect_full", function(e)
    local steamid = get_local_steamid()
    if steamid then
        local target = client.userid_to_entindex(e.userid)
        if target == entity.get_local_player() then

        else

        end
    end
end)



local last_update = 0
client.set_event_callback("shutdown", function()
    local steamid = get_local_steamid()
    if steamid then
    end
end)

-- Website button


-- End discord 

client.set_event_callback('shutdown', function()
    set_clantag("")
end)

client.set_event_callback('paint', function()
    if menu.esp_enabled and ui.get(menu.esp_enabled) then
        g_paint_handler()
    end
    on_paint()
end)

client.set_event_callback('setup_command', function()
    predict()
    ipeekrun()
end)

client.set_event_callback('net_update_end', function()
    if menu.esp_enabled and ui.get(menu.esp_enabled) then
        g_net_update()
    end

    --if menu.resolver_enabled and not ui.get(menu.resolver_enabled) then 
     --   return
   -- end
    --Resolver.Create()
end)