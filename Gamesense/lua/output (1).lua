local L0 = require 'ffi'
local L1 = require 'bit'
local L2 = require "vector"
local L3 = require "gamesense/antiaim_funcs" or error "https://gamesense.pub/forums/viewtopic.php?id=29665"
local L4 = require "gamesense/surface"
local L5 = require "gamesense/base64" or error("Base64 library required")
local L6 = require "gamesense/clipboard" or error("Clipboard library required")
local L7, L8, L9, L10, L11, L12, L13, L14, L15 = require, pcall, ipairs, pairs, unpack, tonumber, tostring, toticks, totime;
local L16 = { new = L0.new, typeof = L0.typeof, cast = L0.cast, cdef = L0.cdef, sizeof = L0.sizeof, string = L0.string }
local L17 = { loadstring = panorama.loadstring, open = panorama.open }
local L18 = { get = plist.get, set = plist.set }
local L19 = { export = config.export, import = config.import, load = config.load }
local L20 = { flush = database.flush, read = database.read, write = database.write }
local L21 = { arshift = L1.arshift, band = L1.band, bnot = L1.bnot, bor = L1.bor, bswap = L1.bswap, bxor = L1.bxor, lshift = L1.lshift, rol = L1.rol, ror = L1.ror, rshift = L1.rshift, tobit = L1.tobit, tohex = L1.tohex }
local L22 = { byte = string.byte, char = string.char, find = string.find, format = string.format, gmatch = string.gmatch, gsub = string.gsub, len = string.len, lower = string.lower, match = string.match, rep = string.rep, reverse = string.reverse, sub = string.sub, upper = string.upper }
local L23 = { abs = math.abs, acos = math.acos, asin = math.asin, atan = math.atan, atan2 = math.atan2, ceil = math.ceil, cos = math.cos, cosh = math.cosh, deg = math.deg, exp = math.exp, floor = math.floor, fmod = math.fmod, frexp = math.frexp, ldexp = math.ldexp, log = math.log, log10 = math.log10, max = math.max, min = math.min, modf = math.modf, pow = math.pow, rad = math.rad, random = math.random, randomseed = math.randomseed, sin = math.sin, sinh = math.sinh, sqrt = math.sqrt, tan = math.tan, tanh = math.tanh, pi = math.pi }
local L24 = { get = ui.get, is_menu_open = ui.is_menu_open, menu_size = ui.menu_size, menu_position = ui.menu_position, mouse_position = ui.mouse_position, name = ui.name, new_button = ui.new_button, new_checkbox = ui.new_checkbox, new_color_picker = ui.new_color_picker, new_combobox = ui.new_combobox, new_hotkey = ui.new_hotkey, new_label = ui.new_label, new_listbox = ui.new_listbox, new_multiselect = ui.new_multiselect, new_slider = ui.new_slider, new_string = ui.new_string, new_textbox = ui.new_textbox, reference = ui.reference, set = ui.set, set_callback = ui.set_callback, set_visible = ui.set_visible, update = ui.update }
local L25 = { blur = renderer.blur, circle = renderer.circle, circle_outline = renderer.circle_outline, gradient = renderer.gradient, indicator = renderer.indicator, line = renderer.line, load_jpg = renderer.load_jpg, load_png = renderer.load_png, load_rgba = renderer.load_rgba, load_svg = renderer.load_svg, measure_text = renderer.measure_text, rectangle = renderer.rectangle, text = renderer.text, texture = renderer.texture, triangle = renderer.triangle, world_to_screen = renderer.world_to_screen }
local L26 = { absoluteframetime = globals.absoluteframetime, chokedcommands = globals.chokedcommands, commandack = globals.commandack, curtime = globals.curtime, framecount = globals.framecount, frametime = globals.frametime, lastoutgoingcommand = globals.lastoutgoingcommand, mapname = globals.mapname, maxplayers = globals.maxplayers, oldcommandack = globals.oldcommandack, realtime = globals.realtime, tickcount = globals.tickcount, tickinterval = globals.tickinterval }
local L27 = { get_all = entity.get_all, get_bounding_box = entity.get_bounding_box, get_classname = entity.get_classname, get_esp_data = entity.get_esp_data, get_game_rules = entity.get_game_rules, get_local_player = entity.get_local_player, get_origin = entity.get_origin, get_player_name = entity.get_player_name, get_player_resource = entity.get_player_resource, get_player_weapon = entity.get_player_weapon, get_players = entity.get_players, get_prop = entity.get_prop, get_steam64 = entity.get_steam64, hitbox_position = entity.hitbox_position, is_alive = entity.is_alive, is_dormant = entity.is_dormant, is_enemy = entity.is_enemy, new_prop = entity.new_prop, set_prop = entity.set_prop }
local L28 = { camera_angles = _G.client.camera_angles, camera_position = _G.client.camera_position, color_log = _G.client.color_log, create_interface = _G.client.create_interface, current_threat = _G.client.current_threat, delay_call = _G.client.delay_call, draw_debug_text = _G.client.draw_debug_text, draw_hitboxes = _G.client.draw_hitboxes, error_log = _G.client.error_log, exec = _G.client.exec, eye_position = _G.client.eye_position, find_signature = _G.client.find_signature, fire_event = _G.client.fire_event, get_cvar = _G.client.get_cvar, get_model_name = _G.client.get_model_name, key_state = _G.client.key_state, latency = _G.client.latency, log = _G.client.log, random_float = _G.client.random_float, random_int = _G.client.random_int, real_latency = _G.client.real_latency, register_esp_flag = _G.client.register_esp_flag, reload_active_scripts = _G.client.reload_active_scripts, request_full_update = _G.client.request_full_update, scale_damage = _G.client.scale_damage, screen_size = _G.client.screen_size, set_clan_tag = _G.client.set_clan_tag, set_event_callback = _G.client.set_event_callback, system_time = _G.client.system_time, timestamp = _G.client.timestamp, trace_bullet = _G.client.trace_bullet, trace_line = _G.client.trace_line, unix_time = _G.client.unix_time, unset_event_callback = _G.client.unset_event_callback, update_player_list = _G.client.update_player_list, userid_to_entindex = _G.client.userid_to_entindex, visible = _G.client.visible }
local L29 = L16.typeof('void***')
local L30 = L28.create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)
local L31 = L16.cast(L29, L30) or error('rawientitylist is nil', 2)
local L32 = L16.cast('void*(__thiscall*)(void*, int)', L31[0][3]) or error('get_client_entity is nil', 2)
local L33 = L16.cast('void*(__thiscall*)(void*, int)', L31[0][0]) or error('get_client_networkable_t is nil', 2)
L16.cdef([[
    struct animation_layer_t {
        char  pad_0000[20];
        uint32_t m_nOrder; //0x0014
        uint32_t m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030 // player's thisptr
        char  pad_0038[4]; //0x0034
    };

    struct animstate_t1 {
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
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
        float m_flLeanAmount; //0x90
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
        char m_pad[2];
        float m_flJumpToFall;
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

]])
L20.write("current_clip_board_to_save", "")
local L34 = {}
local L35 = { { 'remove_search_path', '\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x8B\xD9', 'void(__thiscall*)(void*, const char*, const char*)' }, { 'remove_file', '\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8D\x85\xCC\xCC\xCC\xCC\x56\x50\x8D\x45\x0C', 'void(__thiscall*)(void*, const char*, const char*)' }, { 'find_next', '\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC', 'const char*(__thiscall*)(void*, int)' }, { 'find_is_directory', '\x55\x8B\xEC\x0F\xB7\x45\x08', 'bool(__thiscall*)(void*, int)' }, { 'find_close', '\x55\x8B\xEC\x53\x8B\x5D\x08\x85', 'void(__thiscall*)(void*, int)' }, { 'find_first', '\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D', 'const char*(__thiscall*)(void*, const char*, const char*, int*)' }, { 'get_current_directory', '\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C', 'bool(__thiscall*)(void*, char*, int)' } }
local L36 = L7('ffi')
local function L37(L38, L39, L40, L41)
    local L42 = L28.create_interface(L38, L39) or error("invalid interface", 2)
    local L43 = L28.find_signature(L38, L40) or error("invalid signature", 2)
    local L44, L45 = L8(L36.typeof, L41)
    if not L44 then
        error(L45, 2)
    end;
    local L46 = L36.cast(L45, L43) or error("invalid typecast", 2)
    return function(...)
        return L46(L42, ...)
    end
end;
for L47 = 1, #L35 do
    local L48 = L35[L47]
    L34[L48[1]] = L37('filesystem_stdio.dll', 'VFileSystem017', L48[2], L48[3])
end;
local L49 = vtable_bind("filesystem_stdio.dll", "VFileSystem017", 11, "void(__thiscall*)(void*, const char*, const char*, int)")
local L50 = "WRAITH_CONFIGS"
local L51 = L16.typeof("char[128]")()
L34.get_current_directory(L51, L16.sizeof(L51))
local L52 = L22.format('%s', L16.string(L51))
L49(L52, L50, 0)
local function L53()
    local L54, L55 = {}, L16.typeof("int[1]")()
    local L56 = L34.find_first("*", L50, L55)
    while L56 ~= nil do
        local L57 = L16.string(L56)
        if not L34.find_is_directory(L55[0]) and L57:find('2124089493w.cfg') then
            L54[#L54 + 1] = L57
        end;
        L56 = L34.find_next(L55[0])
    end;
    L34.find_close(L55[0])
    return L54
end;
function update_cfg()
    local L58 = L53()
    local L59 = {}
    for L60 = 1, #L58 do
        L59[L60] = L58[L60]:gsub('2124089493w.cfg', '')
    end;
    return L59
end;
local L61 = vtable_bind("vgui2.dll", "VGUI_System010", 22, "bool(__thiscall*)(void*, const char*)")
if L61("-insecure") then
    L24.set(L24.reference("MISC", "Miscellaneous", "Unlock hidden cvars"), true)
end;
local L62 = { attack = L21.lshift(1, 0), use = L21.lshift(1, 5) }
local L63 = L16.typeof("struct { float pitch; float yaw; float roll; }")
local L64 = L16.typeof("struct { float x; float y; float z; }")
local L65 = L16.typeof([[
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
        }
        ]], L63, L64, L63, L64)
local L66 = L16.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)", L65)
local L67 = L16.typeof([[
        struct
        {
            uintptr_t padding[8];
            $ GetUserCmd;
        }
        ]], L66)
local L68 = L16.typeof([[
        struct
        {
            $* vfptr;
        }*
        ]], L67)
local L69 = L16.cast(L68, L16.cast("uintptr_t**", L12(L16.cast("uintptr_t", L28.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85") or error("client.dll!:input not found."))) + 1)[0])
local L70 = { reset_once = false, hitgroup_names = { [0] = "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }, fire_total_hits = 0, post_total_hits = 0, current_condition = "", mode = "back", is_defensive_running = false, banana = false, old_tick_count = 0, yaw_increment_spin = 0, tickbase_max, tickbase_diff, current_cmd, bomb_defused = false, bomb_exploded = false, pulse = 240, started = 10, smooth_wraith = 0, smooth_dt = 0, smooth_os = 0, smooth_pc = 0, smooth_bo = 0, current_desync = 0, fake_fakelag = 0, cur = 0, is_defusing = false, desync_rect_dist = 0, dt_os_text_anim = 0, current_cond_text_anim = 0, smooth_wraith_recode = 0, smooth_dt_2 = 0, smooth_stance = 0, dt_vertical_dist = 0, jumping = false, on_ground = false, rage_fired = false, last_jump_ducked = false, landing = false, waiting_scan_text = 0, hittable = false, defensive_risk = 0, smooth_defensive_bar = 0, smooth_left_arrow = 0, smooth_right_arrow = 0, smooth_up_arrow = 0, smooth_arrow_alpha = 0 }
local L71 = { cur = {}, prev = {}, pre_prev = {}, pre_pre_prev = {} }
local L72 = {}
local L73 = {}
for L74 = 1, 64 do
    L73[L74] = { stand = {}, stand_type = {}, run = {}, run_type = {}, air = {}, air_type = {}, duck = {}, duck_type = {} }
end;
local L75 = { ["user"] = "crack", ["build"] = "recode" }
local L76 = L24.new_checkbox("AA", "Anti-aimbot angles", "wraith - " .. L22.lower(L75["user"]))
local L77 = nil;
local L78 = nil;
local L79 = nil;
local L80 = nil;
local L81 = { "anti-aim", "anti-aim 2", "visuals", "misc", "config", "debug" }
local L82 = {}
local L83 = {}
local L84 = { "global", "standing", "moving", "slow motion", "in air", "in air duck", "in duck", "in duck moving", "in fake duck", "fakelag", "manual", "freestanding", "backstab", "height", "high distance", "legit" }
local L85 = { ["lua"] = "", ["star"] = "", ["lock"] = "", ["arrows"] = "", ["pizza"] = "", ["up arrow"] = "", ["cpu"] = "", ["smilie"] = "", ["heart"] = "" }
local L86 = { le_icon = "a", tabs_names = { "", "⑵", "", "", "", "F" }, tab = {}, selected_tab = 0, selected_color = { { 20, 20, 20, 255 }, { 210, 210, 210, 255 } }, is_open = true, menu_alpha = 255, is_hovered = false, height = 68, dpi_scaling_y = { { 84, 149 }, { 100, 181 }, { 116, 213 }, { 132, 245 }, { 148, 277 } }, selected_gs_tab = false, mouse_press = false, old_mpos = { 0, 0 } }
local L87 = false;
local L88 = false;
local L89 = { ["100%"] = 68, ["125%"] = 75, ["150%"] = 85, ["175%"] = 95, ["200%"] = 105 }
local L90 = { tab = L24.new_combobox("AA", "Anti-aimbot angles", "\n", L81), ["anti-aim"] = { [0] = L24.new_combobox("AA", "Anti-aimbot angles", "type", "gamesense", "wraith (dont use)"), [1] = L24.new_combobox("AA", "Anti-aimbot angles", "condition", L84) }, ["anti-aim 2"] = { [0] = L24.new_multiselect("AA", "Anti-aimbot angles", "add features", "other anti-aim binds", "manual anti-aim"), [1] = L24.new_hotkey("AA", "Anti-aimbot angles", "edge-yaw"), [2] = L24.new_hotkey("AA", "Anti-aimbot angles", "freestanding"), [3] = L24.new_checkbox("AA", "Anti-aimbot angles", "manual anti-aim"), [4] = L24.new_hotkey("AA", "Anti-aimbot angles", "left"), [8] = L24.new_slider("AA", "Anti-aimbot angles", "\n left angle", 0, 145, 90, true, "°", 1, {}), [5] = L24.new_hotkey("AA", "Anti-aimbot angles", "right"), [9] = L24.new_slider("AA", "Anti-aimbot angles", "\n right angle", 0, 145, 90, true, "°", 1, {}), [6] = L24.new_hotkey("AA", "Anti-aimbot angles", "forward"), [7] = L24.new_hotkey("AA", "Anti-aimbot angles", "reset") }, ["visuals"] = { [0] = L24.new_combobox("AA", "Anti-aimbot angles", "indicators", "off", "minimal (og)", "anti urine", "recode alpha"), [1] = L24.new_color_picker("AA", "Anti-aimbot angles", "anti-aim indicators", 200, 200, 255, 255), [6] = L24.new_multiselect("AA", "Anti-aimbot angles", "indicator extras", "animations on scope", "lowercase", "min damage", "desync", "defensive"), [3] = L24.new_combobox("AA", "Anti-aimbot angles", "indicators size", "small", "thin", "bold", "blind"), [2] = L24.new_checkbox("AA", "Anti-aimbot angles", "watermark"), [4] = L24.new_combobox("AA", "Anti-aimbot angles", "size", "small", "thin", "bold", "blind"), [7] = L24.new_checkbox("AA", "Anti-aimbot angles", "notifications size"), [5] = L24.new_combobox("AA", "Anti-aimbot angles", "\n nigga", "small", "thin", "bold", "blind"), [8] = L24.new_combobox("AA", "Anti-aimbot angles", "extended teleport prediction", "off", "box", "circle"), [9] = L24.new_checkbox("AA", "Anti-aimbot angles", "manual anti-aim"), [10] = L24.new_color_picker("AA", "Anti-aimbot angles", "manual anti-aim", 200, 200, 200, 200) }, ["misc"] = { [6] = L24.new_hotkey("AA", "Anti-aimbot angles", "extended teleport"), [7] = L24.new_hotkey("AA", "Anti-aimbot angles", "extended teleport on hit"), [8] = L24.new_combobox("AA", "Anti-aimbot angles", "extended teleport hit risk", "high", "medium", "low", "safest"), [1] = L24.new_multiselect("AA", "Anti-aimbot angles", "custom animations", "pitch on land", "fallen legs", "moonwalk", "air walk", "blind", "fake walk", "earthquake", "slide", "fake duck", "smoothing"), [2] = L24.new_multiselect("AA", "Anti-aimbot angles", "notify", "fire", "damage", "miss", "hurt", "hurt self", "config changes"), [3] = L24.new_multiselect("AA", "Anti-aimbot angles", "type \n nots", "default", "center", "console"), [4] = L24.new_checkbox("AA", "Anti-aimbot angles", "trashtalk"), [5] = L24.new_checkbox("AA", "Anti-aimbot angles", "bypass anti trashtalk") }, ["config"] = { [0] = L24.new_label("AA", "Anti-aimbot angles", "config"), [1] = L24.new_listbox("AA", "Anti-aimbot angles", "config_board", ""), [2] = L24.new_textbox("AA", "Anti-aimbot angles", "config names"), [8] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0 }, ["debug"] = { [0] = L24.new_checkbox("AA", "Anti-aimbot angles", "alternative ui"), [4] = L24.new_combobox("AA", "Anti-aimbot angles", "debug tab icon", "lua", "star", "lock", "arrows", "pizza", "up arrow", "cpu", "smilie", "heart"), [2] = L24.new_checkbox("AA", "Anti-aimbot angles", "fps optimizations"), [3] = L24.new_multiselect("AA", "Anti-aimbot angles", "disable\n optiz", "3d sky", "fog", "shadows", "blood", "decals", "bloom", "other"), [1] = L24.new_combobox("AA", "Anti-aimbot angles", "anti-aim correction", "off", "desync"), [5] = L24.new_checkbox("AA", "Anti-aimbot angles", "on shot only (ragebot)"), [6] = L24.new_hotkey("AA", "Anti-aimbot angles", "\n on shot bind", true) } }
L24.new_label("Players", "Adjustments", "wraith anti-aim stealer")
steal_aa_toggle = L24.new_checkbox("Players", "Adjustments", "scan anti-aim")
steal_aa_ignore = L24.new_checkbox("Players", "Adjustments", "ignore missing stances")
for L91, L92 in L10(L84) do
    L82[L91] = { [0] = L24.new_checkbox("AA", "Anti-aimbot angles", L22.format("[%s - gamesense]", L92)), [1] = L24.new_combobox("AA", "Anti-aimbot angles", L22.format("pitch \n %s", L92), { "off", "default", "up", "down", "minimal", "random", "custom" }), [2] = L24.new_slider("AA", "Anti-aimbot angles", L22.format("\n%s pitch slider", L92), -89, 89, 0, true, "°", 1, {}), [3] = L24.new_combobox("AA", "Anti-aimbot angles", L22.format("yaw base \n%s", L92), { "local view", "at targets" }), [4] = L24.new_combobox("AA", "Anti-aimbot angles", L22.format("yaw\n %s", L92), { "off", "180", "spin", "static", "180 Z", "crosshair" }), [5] = L24.new_slider("AA", "Anti-aimbot angles", L22.format("\n%s yaw add", L92), -180, 180, 0, true, "°", 1, {}), [6] = L24.new_combobox("AA", "Anti-aimbot angles", L22.format("yaw jitter\n%s", L92), { "off", "offset", "center", "random", "skitter", "slow" }), [7] = L24.new_slider("AA", "Anti-aimbot angles", L22.format("\n %s yaw jitter", L92), -180, 180, 0, true, "°", 1, {}), [8] = L24.new_combobox("AA", "Anti-aimbot angles", L22.format("body yaw\n %s", L92), { "off", "opposite", "jitter", "static" }), [9] = L24.new_slider("AA", "Anti-aimbot angles", L22.format("\n%s body yaw static side", L92), -180, 180, 0, true, "°", 1, {}), [10] = L24.new_checkbox("AA", "Anti-aimbot angles", L22.format("freestanding body yaw\n %s", L92)), [11] = L24.new_checkbox("AA", "Anti-aimbot angles", L22.format("edge yaw\n %s", L92)), [12] = L24.new_checkbox("AA", "Anti-aimbot angles", L22.format("freestanding\n %s", L92)), [13] = L24.new_slider("AA", "Anti-aimbot angles", L22.format("roll\n %s", L92), -45, 45, 0, true, "°", 1, {}), [14] = L24.new_checkbox("AA", "Anti-aimbot angles", L22.format("force defensive\n %s", L92)), [15] = L24.new_combobox("AA", "Anti-aimbot angles", L22.format("defensive pitch\n %s", L92), "off", "up", "random", "minimal", "zero"), [16] = L24.new_combobox("AA", "Anti-aimbot angles", L22.format("defensive yaw\n %s", L92), "off", "forward", "spin", "jitter", "opposite") }
    L83[L91] = { [0] = L24.new_checkbox("AA", "Anti-aimbot angles", L22.format("[%s - wraith] (incomplete)", L92)), [1] = L24.new_combobox("AA", "Anti-aimbot angles", L22.format("pitch\n %s w", L92), { "off", "emotion (89)", "up (-89)", "fake up (180)", "fake down (-180)", "fake zero (1080)", "fake down (-540)" }), [2] = L24.new_combobox("AA", "Anti-aimbot angles", L22.format("yaw jitter\n %s w", L92), { "off", "offset", "center", "random", "3 way", "5 way" }), [3] = L24.new_slider("AA", "Anti-aimbot angles", L22.format("\n %s yaw jitter w", L92), -180, 180, 0, true, "°", 1, {}), [4] = L24.new_combobox("AA", "Anti-aimbot angles", L22.format("body yaw\n %s w", L92), { "off", "opposite", "jitter", "static" }) }
end;
local L97 = function(L93)
    local L94 = "\n{"
    for L95, L96 in L10(L93) do
        if type(L95) == "string" then
            L94 = L94 .. "[\"" .. L95 .. "\"]" .. "="
        end;
        if type(L96) == "table" then
            L94 = L94 .. table_to_string(L96)
        elseif type(L96) == "boolean" then
            L94 = L94 .. L13(L96)
        else
            L94 = L94 .. "\"" .. L96 .. "\""
        end;
        L94 = L94 .. ",\n"
    end;
    if L94 ~= "" then
        L94 = L94:sub(1, L94:len() - 1)
    end;
    return L94 .. "}\n"
end;
local L102 = function(L98, L99)
    local L100 = {}
    for L101 in L22.gmatch(L98, "([^" .. L99 .. "]+)") do
        L100[#L100 + 1] = L22.gsub(L101, "\n", "")
    end;
    return L100
end;
local L104 = function(L103)
    if L103 == "true" or L103 == "false" then
        return L103 == "true"
    else
        return L103
    end
end;
local L106 = function(L105)
    return L23.floor(L105 + 0.5)
end;
local L110 = function(L107, L108, L109)
    return L23.max(L23.min(L107, L109), L108)
end;
local L115 = function(L111, L112, L113, L114)
    return L22.format('%02x%02x%02x%02x', L111, L112, L113, L114)
end;
local L120 = function(L116)
    local L117 = {}
    for L118, L119 in L9(L116) do
        L117[L119] = (L117[L119] or 0) + 1
    end;
    return L117
end;
local L124 = function(L121)
    local L122 = next(L121)
    for L123 in L10(L121) do
        if L121[L122] < L121[L123] then
            L122 = L123
        end
    end;
    return L122
end;
local L126 = function(L125)
    return L124(L120(L125))
end;
local L127 = { rage = { ref_doubletap = { L24.reference("RAGE", "Aimbot", "Double tap") }, ref_safepoint = L24.reference("RAGE", "Aimbot", "Force safe point"), ref_baim = { L24.reference("RAGE", "Aimbot", "Force body aim") }, ref_min_damage = { L24.reference("RAGE", "Aimbot", "Minimum damage") }, ref_min_damage_override = { L24.reference("RAGE", "Aimbot", "Minimum damage override") }, other = { ref_fakeduck = L24.reference("RAGE", "Other", "Duck peek assist") } }, anti_aim = { anti_aimbot_angles = { ref_aa_enabled = L24.reference("AA", "Anti-aimbot angles", "Enabled"), ref_pitch = { L24.reference("AA", "Anti-aimbot angles", "Pitch") }, ref_yaw = { L24.reference("AA", "Anti-aimbot angles", "Yaw") }, ref_yaw_base = L24.reference("AA", "Anti-aimbot angles", "Yaw base"), ref_body_yaw = { L24.reference("AA", "Anti-aimbot angles", "Body yaw") }, ref_yaw_jitter = { L24.reference("AA", "Anti-aimbot angles", "Yaw jitter") }, ref_freestand_body = L24.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"), ref_edge_yaw = L24.reference("AA", "Anti-aimbot angles", "Edge yaw"), ref_freestand = { L24.reference("AA", "Anti-aimbot angles", "Freestanding") }, ref_roll = L24.reference("AA", "Anti-aimbot angles", "Roll") }, fakelag = {}, other = { ref_slowmotion = { L24.reference("AA", "Other", "Slow motion") }, ref_onshotantiaim = { L24.reference("AA", "Other", "On shot anti-aim") } } }, misc = { settings = { ref_dpiscale = L24.reference("MISC", "Settings", "DPI scale"), ref_menukey = L24.reference("MISC", "Settings", "Menu key"), ref_nadetoss = L24.reference("MISC", "Settings", "Faster grenade toss") }, movement = { ref_bhop = L24.reference('MISC', 'Movement', 'Bunny hop') } }, plist = { players = L24.reference("Players", "Players", "Player list"), force_yaw = L24.reference("Players", "Adjustments", "Force body yaw"), force_yaw_value = L24.reference("Players", "Adjustments", "Force body yaw value"), force_body = L24.reference("Players", "Adjustments", "Force body yaw"), force_body_value = L24.reference("Players", "Adjustments", "Force body yaw value"), reset = L24.reference("Players", "Players", "Reset all") } }
local L132 = function(L128, L129)
    local L130 = false;
    for L131 = 1, #L128 do
        if L128[L131] == L129 then
            L130 = true;
            break
        end
    end;
    return L130
end;
local L136 = function(L133, L134, L135)
    return L133 + (L134 - L133) * L135
end;
local L138 = function(L137)
    while L137 > 180 do
        L137 = L137 - 360
    end;
    while L137 < -180 do
        L137 = L137 + 360
    end;
    return L137
end;
function calculate_angle(L139, L140)
    local L141 = L140 - L139;
    local L142 = L23.atan(L141.y / L141.x)
    L142 = L138(L142 * 180 / L23.pi)
    if L141.x >= 0 then
        L142 = L138(L142 + 180)
    end;
    return L142
end;
local L145 = function(L143)
    local L144 = L27.get_prop(L143, "m_bIsScoped")
    if L144 == 1 then
        return true
    end;
    return false
end;
local L146 = {}
local L147 = {}
L24.set_callback(steal_aa_ignore, function()
    if L24.get(steal_aa_ignore) then
        L146[L24.get(L127.plist.players)] = true
    else
        if L146[L24.get(L127.plist.players)] then
            L146[L24.get(L127.plist.players)] = nil
        end
    end
end)
L24.set_callback(L127.plist.players, function()
    L24.set(steal_aa_ignore, L146[L24.get(L127.plist.players)] ~= nil)
end)
L24.set_callback(L127.plist.reset, function()
    L146 = {}
    L24.set(steal_aa_ignore, false)
end)
L24.set_callback(steal_aa_toggle, function()
    if L24.get(steal_aa_toggle) then
        L147[L24.get(L127.plist.players)] = true
    else
        if L147[L24.get(L127.plist.players)] then
            L147[L24.get(L127.plist.players)] = nil
        end
    end
end)
L24.set_callback(L127.plist.players, function()
    L24.set(steal_aa_toggle, L147[L24.get(L127.plist.players)] ~= nil)
end)
L24.set_callback(L127.plist.reset, function()
    L147 = {}
    L24.set(steal_aa_toggle, false)
end)
local L148 = function()
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_aa_enabled, false)
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_pitch[1], "Off")
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_pitch[2], 0)
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[1], "Off")
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[2], 0)
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw_base, "Local view")
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_body_yaw[1], "Off")
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_body_yaw[2], 0)
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw_jitter[1], "Off")
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw_jitter[2], 0)
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_freestand_body, false)
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_edge_yaw, false)
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_freestand[1], false)
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_freestand[2], "Always on")
    L24.set(L127.anti_aim.anti_aimbot_angles.ref_roll, 0)
end;
local L154 = function(L149)
    for L150, L151 in L10(L127.anti_aim.anti_aimbot_angles) do
        if type(L151) ~= "table" then
            L24.set_visible(L151, not L149)
            if not L149 and L24.get(L127.anti_aim.anti_aimbot_angles.ref_body_yaw[1]) == "Off" then
                L24.set_visible(L127.anti_aim.anti_aimbot_angles.ref_freestand_body, false)
            end
        else
            for L152, L153 in L9(L151) do
                L24.set_visible(L153, not L149)
                if not L149 and L24.get(L127.anti_aim.anti_aimbot_angles.ref_body_yaw[1]) == "Opposite" then
                    L24.set_visible(L127.anti_aim.anti_aimbot_angles.ref_body_yaw[2], false)
                end;
                if not L149 and L24.get(L151[1]) == "Off" and L150 ~= "ref_pitch" then
                    L24.set_visible(L151[2], false)
                    if L24.get(L127.anti_aim.anti_aimbot_angles.ref_yaw[1]) == "Off" then
                        L24.set_visible(L127.anti_aim.anti_aimbot_angles.ref_yaw_jitter[1], false)
                    end
                end;
                if not L149 and L24.get(L127.anti_aim.anti_aimbot_angles.ref_pitch[1]) ~= "Custom" then
                    L24.set_visible(L127.anti_aim.anti_aimbot_angles.ref_pitch[2], false)
                end
            end
        end
    end
end;
local L155, L156 = L28.screen_size()
local L157 = { x = L20.read("x_82hdnujdsgfu") or L155 - L155 + 10, y = L20.read("y_ajshdahjdjhn") or L156 - L156 + 550, w = L20.read("w_akjdfsahsdff") or 100, h = L20.read("h_pi2jpoaojkfs") or 100, dragging = false }
local function L158(L159, L160, L161, L162)
    local L163, L164 = L24.mouse_position()
    return L163 >= L159 and L163 <= L159 + L161 and L164 >= L160 and L164 <= L160 + L162
end;
function watermark(L165, L166)
    if not L24.get(L90["visuals"][2]) then
        return
    end;
    local L167 = ""
    local L168 = "WRAITH [" .. L22.upper(L75["build"]) .. "]" .. " | " .. L22.upper(L75["user"]) .. " | " .. L23.floor(L28.latency() * 1000) .. "MS"
    if L166 == "small" then
        L167 = "-"
        L168 = "WRAITH   [" .. L22.upper(L75["build"]) .. "]" .. "   |   " .. L22.upper(L75["user"]) .. "   |   " .. L23.floor(L28.latency() * 1000) .. "MS"
    elseif L166 == "thin" then
        L167 = ""
    elseif L166 == "bold" then
        L167 = "b"
    elseif L166 == "blind" then
        L167 = "+"
    end;
    local L169, L170 = L28.screen_size()
    local L171 = { L24.mouse_position() }
    local L172 = L28.key_state(0x01)
    local L173 = { L25.measure_text(L167, L168) }
    if L24.is_menu_open() then
        if L157.dragging and not L172 then
            L157.dragging = false
        end;
        if L157.dragging and L172 then
            L157.x = L171[1] - L157.drag_x;
            L157.y = L171[2] - L157.drag_y
        end;
        if L158(L157.x, L157.y, L157.w + L173[1], L157.h + L173[2]) and L172 then
            L157.dragging = true;
            L157.drag_x = L171[1] - L157.x;
            L157.drag_y = L171[2] - L157.y
        end
    end;
    if L157.x + L173[1] > L169 then
        L157.x = L157.x - 5
    elseif L157.x + 20 < 0 then
        L157.x = L157.x + 5
    end;
    if L157.y + L173[2] > L170 then
        L157.y = L157.y - 10
    elseif L157.y + L173[2] < 0 then
        L157.y = L157.y + 10
    end;
    local L174 = {}
    L25.gradient(L157.x, L157.y + L173[2] + 8, L173[1] / 1.5, 1, 0, 0, 0, 0, 220, 220, 220, 220, 255, true)
    L25.gradient(L157.x + L173[1] / 1.5, L157.y + L173[2] + 8, L173[1] / 1.5, 1, 220, 220, 220, 255, 0, 0, 0, 0, true)
    L25.gradient(L157.x, L157.y, L173[1] / 1.5, L173[2] + 7, 12, 12, 12, 0, 12, 12, 12, 75, true)
    L25.gradient(L157.x + L173[1] / 1.5, L157.y, L173[1] / 1.5, L173[2] + 7, 12, 12, 12, 75, 12, 12, 12, 0, true)
    L25.text(L157.x + 18, L157.y + 5, 255, 255, 255, 220, L167, 0, L168)
    if not L27.is_alive(L165) then
        return
    end;
    table.insert(L174, { text = "- CONDITION: " .. L22.upper(L70.current_condition), r = 240, g = 240, b = 240, a = 220 })
    table.insert(L174, { text = "- TARGET: " .. L22.upper(L28.current_threat() == nil and "?" or L22.sub(L27.get_player_name(L28.current_threat()), 0, 12)), r = 240, g = 240, b = 240, a = 220 })
    table.insert(L174, { text = "- EXPLOIT CHARGE: " .. (L3.get_double_tap() == false and "0" or "1"), r = 240, g = 240, b = 240, a = 220 })
    table.insert(L174, { text = "- DESYNC: " .. L22.upper(L23.abs(L70.current_desync)) .. "*", r = 240, g = 240, b = 240, a = 220 })
    for L175, L176 in L10(L174) do
        text_size2 = { L25.measure_text(L167, L176.text) }
        L25.text(L157.x + 18, 10 + L157.y + text_size2[2] * L175, L176.r, L176.g, L176.b, L176.a, L167, 0, L176.text)
    end
end;
function draw_glow(L177, L178, L179, L180, L181, L182)
    L25.rectangle(L177, L178, L179, L180, L181[1], L181[2], L181[3], L181[4])
    local L183 = L181[1] * L182;
    local L184 = L181[2] * L182;
    local L185 = L181[3] * L182;
    for L186 = 1, L182 do
        local L187 = L181[4] * L186 / L182;
        local L188 = L179 + L186 * 2;
        local L189 = L180 + L186 * 2;
        local L190 = L177 - L186;
        local L191 = L178 - L186;
        L25.rectangle(L190, L191, L188, L189, L183, L184, L185, L187)
    end
end;
local L197 = function(L192, L193, L194, L195, L196)
    if not L132(L24.get(L90["visuals"][6]), "desync") then
        return
    end;
    dsy_rect = { 255, 255, 255, 255 }
    L196 = L196 + 5;
    if L145(L192) and L132(L24.get(L90["visuals"][6]), "animations on scope") then
        L70.desync_rect_dist = L136(L70.desync_rect_dist, 21 + 2, L26.frametime() * 15)
    elseif not L132(L24.get(L90["visuals"][6]), "animations on scope") and L24.get(L90["visuals"][0]) == "recode alpha" then
        L70.desync_rect_dist = 21 + 2
    else
        L70.desync_rect_dist = L136(L70.desync_rect_dist, 0, L26.frametime() * 10)
    end;
    L25.rectangle(L193 - 21 + L106(L70.desync_rect_dist), L194 + L196, 21 * 2, 4, 15, 15, 15, 255)
    L25.rectangle(L193 - (21 - 1) + L106(L70.desync_rect_dist), L194 + L196 + 1, L110(L23.abs(L70.current_desync) / 58 * (21 * 2 - 2), 0, 21 * 2 - 2), 2, dsy_rect[1], dsy_rect[2], dsy_rect[3], dsy_rect[4])
end;
local L205 = function(L198, L199, L200)
    if not L24.get(L90["visuals"][9]) or not L24.get(L90["anti-aim 2"][3]) then
        return
    end;
    L70.smooth_left_arrow = L145(L198) and L136(L70.smooth_left_arrow, 80, L26.frametime() * 15) or L136(L70.smooth_left_arrow, 60, L26.frametime() * 15)
    L70.smooth_right_arrow = L145(L198) and L136(L70.smooth_right_arrow, 80, L26.frametime() * 15) or L136(L70.smooth_right_arrow, 60, L26.frametime() * 15)
    L70.smooth_up_arrow = L145(L198) and L136(L70.smooth_up_arrow, 80, L26.frametime() * 15) or L136(L70.smooth_up_arrow, 60, L26.frametime() * 15)
    local L201 = { ["left"] = { indicator = "", x_pos = -L70.smooth_left_arrow, y_pos = -5 }, ["right"] = { indicator = "", x_pos = L70.smooth_left_arrow, y_pos = -5 }, ["forward"] = { indicator = "", x_pos = 0, y_pos = -L70.smooth_up_arrow } }
    local L202 = { L24.get(L90["visuals"][10]) }
    L70.smooth_arrow_alpha = L145(L198) and L136(L70.smooth_arrow_alpha, L110(L202[4] - 100, 0, 235), L26.frametime() * 15) or L136(L70.smooth_arrow_alpha, L202[4], L26.frametime() * 15)
    for L203, L204 in L10(L201) do
        if L203 == L70.mode then
            L25.text(L199 + L23.ceil(L204.x_pos), L200 + L23.ceil(L204.y_pos), L202[1], L202[2], L202[3], L70.smooth_arrow_alpha, "c+", 0, L204.indicator)
        end
    end
end;
local L213 = function(L206, L207, L208)
    if not L132(L24.get(L90["visuals"][6]), "defensive") then
        return
    end;
    if L70.tickbase_diff ~= nil and L70.tickbase_diff <= -1 and L70.tickbase_diff >= -14 then
        defensive_size_x, defensive_size_y = L25.measure_text("c", "- defensive -")
        defensive_size_x = defensive_size_x + 15;
        L25.rectangle(L207 - defensive_size_x / 2, L208 / 3 + defensive_size_y - 2, defensive_size_x, 4, 15, 15, 15, 150)
        local L209 = L70.tickbase_diff;
        local L210 = L23.abs(-L209 - 15)
        local L211 = L210;
        if L210 == L211 and L210 > 1 then
            L211 = L211 - 1
        end;
        L70.smooth_defensive_bar = L136(L70.smooth_defensive_bar, L211, L26.frametime() * 50)
        local L212 = L136(75, 200, (L70.smooth_defensive_bar - 1) / 12)
        L25.text(L207, L208 / 3, 255, 255, 255, L212, "c", 0, "- defensive -")
        L25.rectangle(L207 + 1 - defensive_size_x / 2, L208 / 3 + 10, L110(L70.smooth_defensive_bar / 12 * defensive_size_x, 0, defensive_size_x) - 2, 2, 200, 200, 200, L212)
    else
        L70.smooth_defensive_bar = 0.5
    end
end;
local L226 = function(L214, L215, L216)
    local L217 = L26.tickinterval()
    local L218 = cvar.sv_gravity:get_float() * L217;
    local L219 = cvar.sv_jump_impulse:get_float() * L217;
    local L220 = { L215[1], L215[2], L215[3] }
    local L221 = { L27.get_prop(L214, 'm_vecVelocity') }
    local L222 = L221[3] > 0 and -L218 or L219;
    for L223 = 1, L216 do
        local L224 = { L220[1], L220[2], L220[3] }
        L220[1] = L220[1] + L221[1] * L217;
        L220[2] = L220[2] + L221[2] * L217;
        L220[3] = L220[3] + (L221[3] + L222) * L217;
        local L225 = L28.trace_line(L224[1], L224[2], L224[3], L220[1], L220[2], L220[3])
        if L225.fraction <= 0.99 then
            return L224
        end
    end;
    return L220
end;
local L229 = function(L227, L228)
    return { L227[1] + L228[1], L227[2] + L228[2], L227[3] + L228[3] }
end;
local L240 = function(L230, L231)
    local L232 = L26.tickinterval()
    local L233 = cvar.sv_gravity:get_float() * L232;
    local L234 = cvar.sv_jump_impulse:get_float() * L232;
    local L235 = { L27.get_origin(L230) }
    local L236 = { L27.get_origin(L230) }
    local L237 = { L27.get_prop(L230, 'm_vecVelocity') }
    local L238 = L237[3] > 0 and -L233 or L234;
    for L239 = 1, L231 do
        L236 = L235;
        L235 = { L235[1] + L237[1] * L232, L235[2] + L237[2] * L232, L235[3] + (L237[3] + L238) * L232 }
    end;
    return L235
end;
local L251 = function(L241, L242, L243)
    local L244 = L229({ L27.get_prop(L241, 'm_vecMins') }, L242)
    local L245 = L229({ L27.get_prop(L241, 'm_vecMaxs') }, L242)
    local L246 = { { L244[1], L244[2], L244[3] }, { L244[1], L245[2], L244[3] }, { L245[1], L245[2], L244[3] }, { L245[1], L244[2], L244[3] }, { L244[1], L244[2], L245[3] }, { L244[1], L245[2], L245[3] }, { L245[1], L245[2], L245[3] }, { L245[1], L244[2], L245[3] } }
    local L247 = { { 0, 1 }, { 1, 2 }, { 2, 3 }, { 3, 0 }, { 5, 6 }, { 6, 7 }, { 1, 4 }, { 4, 8 }, { 0, 4 }, { 1, 5 }, { 2, 6 }, { 3, 7 }, { 5, 8 }, { 7, 8 }, { 3, 4 } }
    for L248 = 1, #L247 do
        if L246[L247[L248][1]] ~= nil and L246[L247[L248][2]] ~= nil then
            local L249 = { L25.world_to_screen(L246[L247[L248][1]][1], L246[L247[L248][1]][2], L246[L247[L248][1]][3]) }
            local L250 = { L25.world_to_screen(L246[L247[L248][2]][1], L246[L247[L248][2]][2], L246[L247[L248][2]][3]) }
            L25.line(L249[1], L249[2], L250[1], L250[2], 255, 255, 255, 255)
        end
    end
end;
local function L252(L253, L254, L255, L256, L257, L258, L259, L260, L261)
    local L262 = L261 or 3;
    local L263, L264;
    for L265 = 0, 360, L262 do
        local L266 = L23.rad(L265)
        local L267, L268, L269 = L256 * L23.cos(L266) + L253, L256 * L23.sin(L266) + L254, L255;
        local L270, L271 = L25.world_to_screen(L267, L268, L269)
        if L270 ~= nil and L263 ~= nil then
            L25.line(L270, L271, L263, L264, L257, L258, L259, L260)
        end;
        L263, L264 = L270, L271
    end
end;
local function L272(L273, L274, L275, L276, L277, L278, L279, L280, L281)
    local L282 = L281 or 3;
    local L283 = {}
    for L284 = 0, 360, L282 do
        local L285 = L23.rad(L284)
        local L286, L287, L288 = L276 * L23.cos(L285) + L273, L276 * L23.sin(L285) + L274, L275;
        table.insert(L283, { L286, L287, L288 })
    end;
    for L289 = 1, #L283 - 2 do
        local L290, L291, L292 = L283[1], L283[L289 + 1], L283[L289 + 2]
        local L293, L294 = L25.world_to_screen(L290[1], L290[2], L290[3])
        local L295, L296 = L25.world_to_screen(L291[1], L291[2], L291[3])
        local L297, L298 = L25.world_to_screen(L292[1], L292[2], L292[3])
        if L293 and L295 and L297 then
            L25.triangle(L293, L294, L295, L296, L297, L298, L277, L278, L279, L280)
        end
    end
end;
local function L299(L300, L301, L302, L303, L304, L305, L306, L307, L308, L309)
    local L310 = L308 or 3;
    local L311 = L309 or 5;
    local L312 = L307 / L311;
    local L313 = L307;
    for L314 = 1, L311 do
        L252(L300, L301, L302, L303 + L314, L304, L305, L306, L313, L310)
        L313 = L313 - L312
    end
end;
local L316 = function(L315)
    if L24.get(L127.anti_aim.other.ref_onshotantiaim[1]) and L24.get(L127.anti_aim.other.ref_onshotantiaim[2]) or not (L24.get(L90["misc"][6]) or L24.get(L90["misc"][7]) and L70.hittable) or L70.tickbase_diff == nil or L70.tickbase_diff > 0 then
        return
    end;
    if not L24.get(L127.rage.ref_doubletap[1]) and not L24.get(L127.rage.ref_doubletap[2]) then
        return
    end;
    predicted_pos = L240(L315, 14)
    if L24.get(L90["visuals"][8]) == "circle" then
        L299(predicted_pos[1], predicted_pos[2], predicted_pos[3], 6, 255, 255, 255, 255, 3, 10)
        L272(predicted_pos[1], predicted_pos[2], predicted_pos[3], 7, 255, 255, 255, 150, 3)
    elseif L24.get(L90["visuals"][8]) == "box" then
        L251(L315, predicted_pos, true)
    end
end;
local L317 = { main = { 0, 1, 6, 5, 4, 3, 2 }, left_arm = { 14, 18, 17, 1 }, right_arm = { 13, 16, 15, 1 }, left_leg = { 12, 10, 8, 2 }, right_leg = { 11, 9, 7, 2 } }
local L330 = function(L318, L319, L320)
    local L321 = L26.tickinterval()
    local L322 = cvar.sv_gravity:get_float() * L321;
    local L323 = cvar.sv_jump_impulse:get_float() * L321;
    local L324, L325 = L319, L319;
    local L326 = { L27.get_prop(L318, 'm_vecVelocity') }
    local L327 = L326[3] > 0 and -L322 or L323;
    for L328 = 1, L320 do
        L325 = L324;
        L324 = { L324[1] + L326[1] * L321, L324[2] + L326[2] * L321, L324[3] + (L326[3] + L327) * L321 }
        local L329 = L28.trace_line(-1, L325[1], L325[2], L325[3], L324[1], L324[2], L324[3])
    end;
    return L324
end;
local L350 = function(L331)
    for L332, L333 in L10(L317) do
        for L334, L335 in L10(L333) do
            if L334 ~= #L333 then
                local L336 = {}
                for L337 = 0, 18 do
                    local L338 = { L27.hitbox_position(L331, L337) }
                    local L339 = L338;
                    L336[L337] = { x = L339[1], y = L339[2], z = L339[3] }
                end;
                local L340, L341, L342 = L336[L333[L334]].x, L336[L333[L334]].y, L336[L333[L334]].z;
                local L343, L344 = L25.world_to_screen(L340, L341, L342)
                local L345, L346, L347 = L336[L333[L334 + 1]].x, L336[L333[L334 + 1]].y, L336[L333[L334 + 1]].z;
                local L348, L349 = L25.world_to_screen(L345, L346, L347)
                L25.line(L343, L344, L348, L349, 255, 255, 255, 255)
            end
        end
    end
end;
local function L351(L352, L353, L354)
    local L355 = L22.len(L353)
    if L352 < L355 then
        L352 = L352 + 1 * L26.frametime() * L354
    else
        L352 = L355
    end;
    local L356 = L23.floor(L352)
    local L357 = L22.sub(L353, 1, L356)
    return L352, L357
end;
local L358 = ""
local L401 = function(L359, L360, L361, L362, L363)
    if not L360 or not L27.is_alive(L361) then
        return
    end;
    L316(L361)
    local L364 = {}
    local L365, L366, L367, L368 = L24.get(L90["visuals"][1])
    local L369, L370 = L362[1] / 2, L362[2] / 2;
    local L371 = ""
    L213(L361, L369, L370)
    L205(L361, L369, L370)
    if L363 == "small" then
        L371 = "-"
    elseif L363 == "thin" then
        L371 = ""
    elseif L363 == "bold" then
        L371 = "b"
    elseif L363 == "blind" then
        L371 = "+"
    end;
    if L24.get(L90["visuals"][0]) ~= "recode alpha" then
        L70.smooth_wraith_recode = 0;
        L70.smooth_dt_2 = 0;
        L70.smooth_stance = 0;
        L70.dt_os_text_anim = 0;
        L70.current_cond_text_anim = 0
    end;
    if L24.get(L360) == "minimal (og)" then
        local L372 = "SP BAIM FS"
        local L373 = "SP"
        local L374 = " BAIM"
        local L375 = " FS"
        local L376 = "WRAITH"
        local L377 = "DT"
        local L378 = "OS"
        local L379 = L22.upper(L70.current_condition)
        if L371 == "-" then
            L373 = "SP"
            L374 = "  BAIM"
            L375 = "  FS"
            L372 = "SP  BAIM  FS"
        end;
        if L132(L24.get(L90["visuals"][6]), "lowercase") then
            L376 = L22.lower(L376)
            L377 = L22.lower(L377)
            L378 = L22.lower(L378)
            L372 = L22.lower(L372)
            L373 = L22.lower(L373)
            L374 = L22.lower(L374)
            L375 = L22.lower(L375)
            L379 = L22.lower(L379)
        end;
        local L380 = { L25.measure_text(L371, L376) }
        L70.smooth_wraith = L145(L361) and L136(L70.smooth_wraith, -2, L26.frametime() * 15) or L136(L70.smooth_wraith, L25.measure_text(L371, L376) / 2, L26.frametime() * 15)
        table.insert(L364, { text = L376, r = 210, g = 210, b = 210, a = 255, size = L23.ceil(L70.smooth_wraith) })
        L70.smooth_pc = L145(L361) and L136(L70.smooth_pc, -2, L26.frametime() * 15) or L136(L70.smooth_pc, L25.measure_text(L371, L23.abs(L70.current_desync) .. "%") / 2, L26.frametime() * 15)
        table.insert(L364, { text = L23.abs(L70.current_desync) .. "%", r = 210, g = 210, b = 210, a = 255, size = L23.ceil(L70.smooth_pc) })
        L70.smooth_dt = L145(L361) and L136(L70.smooth_dt, -2, L26.frametime() * 15) or L136(L70.smooth_dt, L25.measure_text(L371, L378) / 2, L26.frametime() * 15)
        if L24.get(L127.rage.ref_doubletap[1]) and L24.get(L127.rage.ref_doubletap[2]) then
            local L381 = L3.get_double_tap() or L70.tickbase_diff ~= 1;
            table.insert(L364, { text = L377, r = 210, g = 210, b = 210, a = L381 and 255 or 100, size = L23.ceil(L70.smooth_dt) })
            L70.dt_vertical_dist = L136(L70.dt_vertical_dist, 10, L26.frametime() * 20)
        else
            L70.dt_vertical_dist = L136(L70.dt_vertical_dist, 0, L26.frametime() * 20)
        end;
        L70.smooth_os = L145(L361) and L136(L70.smooth_os, -2, L26.frametime() * 15) or L136(L70.smooth_os, L25.measure_text(L371, L378) / 2, L26.frametime() * 15)
        if L24.get(L127.anti_aim.other.ref_onshotantiaim[1]) and L24.get(L127.anti_aim.other.ref_onshotantiaim[2]) then
            local L382 = L24.get(L127.rage.ref_doubletap[1]) and L24.get(L127.rage.ref_doubletap[2])
            table.insert(L364, { text = L378, r = 210, g = 210, b = 210, a = not L382 and 255 or L23.max(L70.pulse, 100), size = L23.ceil(L70.smooth_os) })
        end;
        L70.smooth_bo = L145(L361) and L136(L70.smooth_bo, -2, L26.frametime() * 15) or L136(L70.smooth_bo, L25.measure_text(L371, L372) / 2, L26.frametime() * 15)
        table.insert(L364, { text = ("\a%s" .. L373 .. "\a%s" .. L374 .. "\a%s" .. L375):format(L22.format("%02X%02X%02X%02X", L365, L366, L367, L24.get(L127.rage.ref_safepoint) and 210 or 100), L22.format("%02X%02X%02X%02X", L365, L366, L367, L24.get(L127.rage.ref_baim[1]) and 210 or 100), L22.format("%02X%02X%02X%02X", L365, L366, L367, L24.get(L127.anti_aim.anti_aimbot_angles.ref_freestand[1]) and L24.get(L127.anti_aim.anti_aimbot_angles.ref_freestand[2]) and 210 or 100)), r = 210, g = 210, b = 210, a = 255, size = L23.ceil(L70.smooth_bo) })
        for L383, L384 in L10(L364) do
            L25.text(L369 + (L132(L24.get(L90["visuals"][6]), "animations on scope") == true and -L384.size or -(L25.measure_text(L371, L384.text) / 2)), 10 + L370 + L380[2] * L383, L384.r, L384.g, L384.b, L384.a, L371, 0, L384.text)
        end;
        local L385 = { L25.measure_text(L371, L376) }
        L197(L361, L369, L370, L385[1], L385[2])
    else
        L70.smooth_wraith = 0;
        L70.smooth_dt = 0;
        L70.smooth_os = 0;
        L70.smooth_pc = 0;
        L70.smooth_bo = 0;
        if L24.get(L360) == "anti urine" then
            table.insert(L364, { text = "ANTI URINE", r = 255, g = 165, b = 0, a = L70.pulse, size = L25.measure_text("b", "ANTI URINE") / 2 })
            table.insert(L364, { text = "MIN DAMAGE", r = 191, g = 159, b = 255, a = L24.get(L127.rage.ref_min_damage_override[2]) and 255 or 100, size = L25.measure_text("b", "MIN DAMAGE") / 2 })
            table.insert(L364, { text = "ON SHOT", r = 128, g = 230, b = 150, a = L24.get(L127.anti_aim.other.ref_onshotantiaim[1]) and L24.get(L127.anti_aim.other.ref_onshotantiaim[2]) and 255 or 100, size = L25.measure_text("b", "ON SHOT") / 2 })
            local L386 = L24.get(L127.rage.ref_doubletap[1]) and L24.get(L127.rage.ref_doubletap[2])
            table.insert(L364, { text = "DT", r = L386 and 210 or 255, g = L386 and 210 or 0, b = L386 and 210 or 0, a = L386 and 255 or 100, size = L25.measure_text("b", "DT") / 2 })
            for L387, L388 in L10(L364) do
                L25.text(L369 - L388.size, 45 + L370 + 12 * L387, L388.r, L388.g, L388.b, L388.a, "b", 0, L388.text)
            end
        elseif L24.get(L360) == "recode alpha" then
            local L389 = ("WRAITH\a%s RECODE"):format(L22.format("%02X%02X%02X%02X", L365, L366, L367, L23.max(L368, 100)))
            local L390 = "DT"
            local L391 = "ON SHOT"
            local L392 = { L25.measure_text(L371, L389) }
            local L393 = L22.upper(L70.current_condition)
            if L70.mode == "left" then
                L393 = "MANUAL LEFT"
            elseif L70.mode == "right" then
                L393 = "MANUAL RIGHT"
            elseif L70.mode == "forward" then
                L393 = "MANUAL FORWARD"
            end;
            if L132(L24.get(L90["visuals"][6]), "lowercase") then
                L389 = L22.lower(L389)
                L390 = L22.lower(L390)
                L391 = L22.lower(L391)
                L393 = L22.lower(L393)
            end;
            local L394 = L3.get_double_tap() or L70.tickbase_diff ~= 1;
            local L395 = L24.get(L127.anti_aim.other.ref_onshotantiaim[1]) and L24.get(L127.anti_aim.other.ref_onshotantiaim[2])
            local L396 = L24.get(L127.rage.ref_doubletap[1]) and L24.get(L127.rage.ref_doubletap[2])
            local L397 = ""
            if L396 then
                L397 = L390
            elseif L395 then
                L397 = L391
            end;
            L70.dt_os_text_anim, ayo = L351(L70.dt_os_text_anim, L397, 50)
            L70.current_cond_text_anim, ayo2 = L351(L70.current_cond_text_anim, L393, 25)
            if L358 ~= L393 then
                if #L358 <= #L393 then
                    L70.current_cond_text_anim = #L358
                end;
                L358 = L393
            end;
            wraith_recode_text_size = { L25.measure_text(L371, L389) }
            L70.smooth_wraith_recode = L145(L361) and L136(L70.smooth_wraith_recode, -2, L26.frametime() * 15) or L136(L70.smooth_wraith_recode, wraith_recode_text_size[1] / 2, L26.frametime() * 15)
            table.insert(L364, { text = L389, r = 240, g = 240, b = 240, a = 255, size = L23.floor(L70.smooth_wraith_recode), txt_measure = { L25.measure_text(L371, L389) } })
            L70.smooth_dt_2 = L145(L361) and L136(L70.smooth_dt_2, -2, L26.frametime() * 15) or L136(L70.smooth_dt_2, L25.measure_text(L371, L397) / 2, L26.frametime() * 15)
            if L396 or L395 then
                table.insert(L364, { text = ayo, r = L396 and (L394 and 0 or 255) or 135, g = L396 and (L394 and 255 or 0) or 206, b = L396 and 0 or 250, a = 255, size = L23.floor(L70.smooth_dt_2), txt_measure = { L25.measure_text(L371, ayo) } })
            else
                L70.dt_os_text_anim = 0
            end;
            ayo2 = "'  " .. ayo2 .. "  '"
            L70.smooth_stance = L145(L361) and L136(L70.smooth_stance, -2, L26.frametime() * 15) or L136(L70.smooth_stance, L25.measure_text(L371, ayo2) / 2, L26.frametime() * 15)
            table.insert(L364, { text = ayo2, r = 240, g = 240, b = 240, a = 255, size = L23.floor(L70.smooth_stance), txt_measure = { L25.measure_text(L371, ayo2) } })
            for L398, L399 in L10(L364) do
                L25.text(L369 + (L132(L24.get(L90["visuals"][6]), "animations on scope") == true and -L399.size or 0), 10 + L370 + L392[2] * L398, L399.r, L399.g, L399.b, L399.a, L371, 0, L399.text)
            end;
            local L400 = { L25.measure_text(L371, L389) }
            L197(L361, L369, L370, L400[1], L400[2])
        end
    end
end;
gamesense_outer = function(L402, L403, L404, L405, L406, L407)
    L407 = L407 or false;
    if not L407 then
        L25.rectangle(L402, L403 - (L405 + 3), L404, 1, 12, 12, 12, L406)
        L25.rectangle(L402 + 2, L403 - (L405 + 2), L404 - 4, 5, 60, 60, 60, L406)
        L25.rectangle(L402 + 2, L403 - (L405 + 1), L404 - 4, 3, 40, 40, 40, L406)
        L25.rectangle(L402, L403 - (L405 + 3), 1, L405 + 3, 12, 12, 12, L406)
        L25.rectangle(L402 + 1, L403 - (L405 + 2), 4, L405 + 2, 60, 60, 60, L406)
        L25.rectangle(L402 + 2, L403 - (L405 + 1), 3, L405 + 1, 40, 40, 40, L406)
        L25.rectangle(L402 + 5, L403 - (L405 - 2), 1, L405 - 2, 60, 60, 60, L406)
        L25.rectangle(L402 + L404 - 1, L403 - (L405 + 3), 1, L405 + 3, 12, 12, 12, L406)
        L25.rectangle(L402 + L404 - 3, L403 - (L405 + 2), 2, L405 + 2, 60, 60, 60, L406)
        L25.rectangle(L402 + L404 - 5, L403 - (L405 + 1), 3, L405 + 1, 40, 40, 40, L406)
        L25.rectangle(L402 + L404 - 6, L403 - (L405 - 2), 1, L405 - 2, 60, 60, 60, L406)
    else
        L25.rectangle(L402 - L405 / 2 - 4, L403 - 47, L405 + 9, L404 + 9, 12, 12, 12, L406)
        L25.rectangle(L402 - L405 / 2 - 10, L403 - 53, L405 + 20, 1, 12, 12, 12, L406)
        L25.rectangle(L402 - L405 / 2 - 9, L403 - 52, L405 + 18, 1, 60, 60, 60, L406)
        L25.rectangle(L402 - L405 / 2 - 8, L403 - 51, L405 + 17, 3, 40, 40, 40, L406)
        L25.rectangle(L402 - L405 / 2 - 5, L403 - 48, L405 + 10, 1, 60, 60, 60, L406)
        L25.rectangle(L402 - L405 / 2 - 10, L403 - 53, 1, L404 + 19, 12, 12, 12, L406)
        L25.rectangle(L402 - L405 / 2 - 9, L403 - 51, 1, L404 + 18, 60, 60, 60, L406)
        L25.rectangle(L402 - L405 / 2 - 8, L403 - 48, 3, L404 + 10, 40, 40, 40, L406)
        L25.rectangle(L402 - L405 / 2 - 5, L403 - 48, 1, L404 + 9, 60, 60, 60, L406)
        L25.rectangle(L402 + L405 / 2 + 10, L403 - 53, 1, L404 + 20, 12, 12, 12, L406)
        L25.rectangle(L402 + L405 / 2 + 9, L403 - 52, 1, L404 + 18, 60, 60, 60, L406)
        L25.rectangle(L402 + L405 / 2 + 6, L403 - 48, 3, L404 + 10, 40, 40, 40, L406)
        L25.rectangle(L402 + L405 / 2 + 5, L403 - 48, 1, L404 + 10, 60, 60, 60, L406)
        L25.rectangle(L402 - L405 / 2 - 10, L403 - 48 + L404 + 14, L405 + 20, 1, 12, 12, 12, L406)
        L25.rectangle(L402 - L405 / 2 - 5, L403 - 51 + L404 + 12, L405 + 10, 1, 60, 60, 60, L406)
        L25.rectangle(L402 - L405 / 2 - 8, L403 - 52 + L404 + 14, L405 + 17, 3, 40, 40, 40, L406)
        L25.rectangle(L402 - L405 / 2 - 8, L403 - 49 + L404 + 14, L405 + 17, 1, 60, 60, 60, L406)
    end
end;
local L408 = 10 + (L22.sub(L24.get(L127.misc.settings.ref_dpiscale), 1, -2) - 100) / 25;
local L409 = L4.create_font('Lucida Console', L408, 400, { 0x080 })
local L410 = {}
function L410:new(L411, L412, L413)
    local L414 = { m_text = L411, m_color = L412, m_time = L413, lerped_pos = L2(L28.screen_size()).y }
    setmetatable(L414, self)
    self.__index = self;
    return L414
end;
local L415 = {}
function L415:new()
    local L416 = { m_notify_text = {} }
    setmetatable(L416, self)
    self.__index = self;
    return L416
end;
function L415:add(L417, L418, L419, L420, L421)
    L418 = L418 or { 255, 255, 255, 255 }
    L419 = L419 or 8.0;
    L420 = L132(L24.get(L90["misc"][3]), "console") or false;
    L421 = L421 or ""
    table.insert(self.m_notify_text, L410:new(L417, L418, L419))
    if L420 then
        if L421 == "fire" then
            L28.color_log(182, 231, 23, '[gamesense] \0')
            L28.color_log(210, 210, 255, L417)
        else
            print(L417)
        end
    end
end;
function L415:think(L422, L423)
    local L424, L425, L426 = 8, 5, 12 + 1;
    local L427, L428 = L422[1] / 2, L422[2] / 2;
    local L429;
    local L430;
    local L431 = "c"
    local L432 = 1;
    local L433;
    if L423 == "small" then
        L431 = "-c"
    elseif L423 == "thin" then
        L431 = "c"
    elseif L423 == "bold" then
        L431 = "bc"
    elseif L423 == "blind" then
        L431 = "+c"
        L432 = 10
    end;
    if #self.m_notify_text > 6 then
        table.remove(self.m_notify_text, 1)
    end;
    for L434 = #self.m_notify_text, 1, -1 do
        local L435 = self.m_notify_text[L434]
        L435.m_time = L435.m_time - L26.frametime()
        if L435.m_time <= 0.0 then
            table.remove(self.m_notify_text, L434)
        end
    end;
    if #self.m_notify_text == 0 then
        return
    end;
    for L436, L437 in L9(self.m_notify_text) do
        L433 = L437.m_text;
        if L423 == "small" then
            L433 = L22.upper(L437.m_text)
        end;
        local L438 = { L25.measure_text(L431, L433) }
        L437.lerped_pos = L136(L437.lerped_pos, L422[2] / 2 + 300 + L436 * (23 + L438[2]), L26.frametime() * 10)
        smooth_center_y = L437.lerped_pos;
        L430 = L437.m_time;
        L429 = L437.m_color;
        if L430 < 0.5 then
            local L439 = L430;
            L439 = L23.min(L23.max(L439, 0.0), 0.5)
            L439 = L439 / 0.5;
            L429[4] = L23.floor(L439 * 255)
            if L436 == 1 and L439 < 0.2 then
                L425 = L425 - L426 * (1.0 - L439 / 0.2)
            end
        else
            L429[4] = 255
        end;
        if L409 and L132(L24.get(L90["misc"][3]), "default") then
            L4.draw_text(L424, L425, L429[1], L429[2], L429[3], L429[4], L409, L437.m_text)
        end;
        if L132(L24.get(L90["misc"][3]), "center") then
            gamesense_outer(L427, smooth_center_y, L438[2], L438[1], L429[4], true)
            smooth_center_y = smooth_center_y - 46;
            L25.gradient(L427 - L23.ceil(L438[1] / 2 + 3), smooth_center_y, L23.ceil(L438[1]) / 2, 1, 59, 175, 222, L429[4], 202, 70, 205, L429[4], true)
            L25.gradient(L427 - 4, smooth_center_y, L23.ceil(L438[1] / 2 + 7.5), 1, 202, 70, 205, L429[4], 204, 227, 53, L429[4], true)
            L25.gradient(L427 - L23.ceil(L438[1] / 2 + 3), smooth_center_y + 1, L23.ceil(L438[1]) / 2, 1, 59, 175, 222, L23.max(0, L23.min(255, L429[4])) - 100, 202, 70, 205, L429[4], true)
            L25.gradient(L427 - 4, smooth_center_y + 1, L23.ceil(L438[1] / 2 + 7.5), 1, 202, 70, 205, L429[4], 204, 227, 53, L23.max(0, L23.min(255, L429[4])) - 100, true)
            L25.text(L427, smooth_center_y + L438[2] - L432, 209, 209, 209, L429[4], L431, 0, L433)
        end;
        L425 = L425 + L426
    end
end;
g_notify = L415:new()
local L440 = { 'جدا الحمد لله أبي', "₩Ɽ₳ł₮Ⱨ ₴Ɇ₦Đ ₲ⱤɆɆ₮ł₦₲₴ ₱₳Ɽ₳ ₳ ₵Ø₦₳ Đ₳ ₮Ʉ₳ ₥₳̃Ɇ", "ஃᅔ>.< член в заднице у русских ＷＲＡＩＴＨ ＲＥＣＯＤＥᅕஃ", "ȶʏ ʄօʀ ʍ2 ƈօʍքɨӼɨօռ աɨȶɦ ȶɦɛ քօքֆ ǟռɖ ȶɦɛ ɮǟռɢֆ ʄȶ 𝔀𝓻𝓸𝓽𝓱 𝓵𝓸𝓪", "百萬富翁買鬼 ツ", "skeet invite code in morse: ... .-- ..-. -.-- -... .-- ..-. -... .--- --.. -... .-.. -.- .... ..-. .-.. -.- --. .. .-. .--. --. .-.. --.- --.- - -.-- .---- -..- . .-- -.- -.-- --.- ---.. .-.. .... ... ...- --.. -..- -.. .--. -..- -- -... - -.--", '𝟝𝟙.𝟙𝟟𝟠.𝟙𝟠𝟝.𝟚𝟛𝟛/𝕡𝕝𝕒𝕪𝕖𝕣𝕤.𝕛𝕤𝕠𝕟 𝓬𝓽𝓻𝓵+f "𝖎𝖘𝖘𝖔 𝖋𝖔𝖎 𝖉𝖔𝖕𝖊, 𝖌𝖆𝖓𝖉𝖆 𝖙𝖔𝖖𝖚𝖊"', "🕯️⧚🎃⧚🔮 ƙąYRཞơŋ ῳıƖƖ ƈơơ℘ ʂ℘ıɛƖɛŋ 🔮⧚🎃⧚🕯️", " ⓔⓜⓑⓡⓐⓒⓔ ⓡⓐⓒⓘⓢⓜ ", "yesterday i got smoked by (っ◔◡◔)っ ιвιzα 6ℓ 1.9 т∂ι 160 ¢υρяα 2004 160 нρ / 118 кω 1896 ¢м3 (115.7 ¢υ-ιи)", "【　ＷＲＡＩＴＨ　ＡＮＴＩ－ＡＩＭＢＯＴ　ＲＥＣＯＤＥ　】", "ʀᴀᴢ ᴀᴅᴅᴇᴅ ᴛʜɪs ᴛᴏ ᴡʀᴀɪᴛʜ ʀᴇᴄᴏᴅᴇ ᴀɴᴅ ɪᴛ ᴍᴀᴅᴇ ɪᴛ sᴏ ᴍᴜᴄʜ ʙᴇᴛᴛᴇʀ" }
last_random = 0;
new_random = 0;
textalhao = ""
say_time = 0;
ran = false;
local function L441(L442)
    if not L24.get(L90["misc"][4]) and not L24.get(L90["misc"][5]) then
        return
    end;
    local L443, L444 = L442.userid, L442.attacker;
    if L443 == nil or L444 == nil then
        return
    end;
    local L445 = L28.userid_to_entindex(L443)
    local L446 = L28.userid_to_entindex(L444)
    if L446 == L27.get_local_player() and L27.is_enemy(L445) then
        new_random = L28.random_int(1, #L440)
        while new_random == last_random do
            new_random = L28.random_int(1, #L440)
        end;
        textalhao = "say " .. L440[new_random]
        if L24.get(L90["misc"][5]) then
            say_time = L26.curtime()
            ran = false
        else
            L28.exec(textalhao)
        end;
        last_random = new_random
    end
end;
local L448 = function(L447)
    if not L447 then
        ran = false;
        return
    end;
    if L26.curtime() >= say_time + 1.5 and L26.curtime() <= say_time + 1.6 and not ran then
        L28.exec(textalhao)
        ran = true
    end
end;
local L453 = function(L449, L450, L451)
    if not L449 then
        return
    end;
    local L452 = cvar.cl_crosshairsize:get_int()
    final_dmg = L24.get(L127.rage.ref_min_damage_override[2]) and L24.get(L127.rage.ref_min_damage_override[3]) or L24.get(L127.rage.ref_min_damage[1])
    dmg_size = L25.measure_text("", final_dmg)
    L25.text(L450 / 2 + 10, L451 / 2 - 20, 255, 255, 255, 250, "", 0, final_dmg)
end;
local L460 = function(L454)
    local L455 = L27.get_local_player()
    local L456 = { L28.screen_size() }
    local L457 = L24.get(L90["visuals"][3])
    local L458 = L24.get(L90["visuals"][4])
    local L459 = L24.get(L90["visuals"][5])
    L448(L24.get(L90["misc"][4]) and L24.get(L90["misc"][5]))
    L453(L132(L24.get(L90["visuals"][6]), "min damage") and L27.is_alive(L455), L456[1], L456[2])
    watermark(L455, L458)
    L401(L454, L90["visuals"][0], L455, L456, L457)
    g_notify:think(L456, L459)
end;
local L463 = function(L461, L462)
    L462 = L462 or 1;
    L461 = L16.cast(L29, L461)
    return L16.cast('struct animation_layer_t**', L16.cast('char*', L461) + 0x2990)[0][L462]
end;
local L465 = function(L464)
    duckammount = L464.m_fDuckAmount;
    speedfraction = L23.max(0, L23.min(L464.m_flFeetSpeedForwardsOrSideWays, 1))
    speedfactor = L23.max(0, L23.min(1, L464.m_flFeetSpeedUnknownForwardOrSideways))
    unk1 = (L464.m_flStopToFullRunningFraction * -0.30000001 - 0.19999999) * speedfraction;
    unk2 = unk1 + 1;
    unk3 = 0;
    if duckammount > 0 then
        unk2 = unk2 + duckammount * speedfactor * (0.5 - unk2)
    end;
    unk3 = L464.m_flMaxYaw * unk2;
    return unk3
end;
local L472 = function(L466)
    local L467 = L32(L31, L466)
    local L468 = L33(L31, L466)
    local L469 = L16.cast(L29, L467)
    local L470 = L16.cast("char*", L469) + 0x9960;
    local L471 = L16.cast("struct animstate_t1**", L470)[0]
    if L467 == nil or L468 == nil or local_animstate == nil then
        return
    end;
    L466.set_prop(L466, "m_flPoseParameter", 1, 6)
end;
local L479 = function(L473)
    local L474 = L32(L31, L473)
    local L475 = L33(L31, L473)
    local L476 = L16.cast(L29, L474)
    local L477 = L16.cast("char*", L476) + 0x9960;
    local L478 = L16.cast("struct animstate_t1**", L477)[0]
    if L474 == nil or L475 == nil or L478 == nil then
        return
    end;
    if L26.chokedcommands() == 0 then
        L70.max_desync = L465(L478)
        L70.current_desync = L23.min(L23.max(L27.get_prop(L473, "m_flPoseParameter", 11) * 120 - 60, -58), 58)
        L70.current_desync = L70.current_desync > 0 and L23.ceil(L70.current_desync) or L23.floor(L70.current_desync)
    end;
    if L132(L24.get(L90["misc"][1]), "air walk") then
        if L2(L27.get_prop(L473, 'm_vecVelocity')):length2d() > 1.5 then
            ANIMATION_LAYER_MOVEMENT_MOVE = L463(L474, 6)
            ANIMATION_LAYER_MOVEMENT_MOVE.m_flWeight = 1
        end
    end;
    if L132(L24.get(L90["misc"][1]), "earthquake") then
        ANIMATION_LAYER_LEAN = L463(L474, 12)
        ANIMATION_LAYER_LEAN.m_flWeight = L28.random_float(0, 1)
    end;
    if L132(L24.get(L90["misc"][1]), "fake walk") and L70.in_speed then
        ANIMATION_LAYER_LEAN = L463(L474, 12)
        ANIMATION_LAYER_LEAN.m_flWeight = 0;
        ANIMATION_LAYER_MOVEMENT_MOVE = L463(L474, 6)
        ANIMATION_LAYER_MOVEMENT_MOVE.m_flWeight = 0
    end;
    if L132(L24.get(L90["misc"][1]), "blind") then
        ANIMATION_LAYER_FLASHED = L463(L474, 9)
        ANIMATION_LAYER_FLASHED.m_nSequence = 224;
        ANIMATION_LAYER_FLASHED.m_flWeight = 1
    end;
    if L132(L24.get(L90["misc"][1]), "moonwalk") then
        L27.set_prop(L473, 'm_flPoseParameter', 0, 7)
    end;
    if L132(L24.get(L90["misc"][1]), "smoothing") then
        L27.set_prop(L473, "m_flPoseParameter", 0, 2)
    end;
    if L132(L24.get(L90["misc"][1]), "fallen legs") then
        L27.set_prop(L473, "m_flPoseParameter", 1, 6)
    end;
    if L132(L24.get(L90["misc"][1]), "slide") then
        L27.set_prop(L473, "m_flPoseParameter", 1, 0)
    end;
    if L132(L24.get(L90["misc"][1]), "pitch on land") or true then
        if L478.m_bInHitGroundAnimation and L478.m_flHeadHeightOrOffsetFromHittingGroundAnimation > 0.101 and L478.m_bOnGround and not L28.key_state(0x20) then
            if L132(L24.get(L90["misc"][1]), "pitch on land") then
                L27.set_prop(L473, 'm_flPoseParameter', 0.5, 12)
            end;
            L70.landing = true
        else
            L70.landing = false
        end
    end
end;
local L480 = { ["3d sky"] = { cvar = cvar.r_3dsky, value = 1 }, ["fog"] = { cvars = { cvar.fog_enable, cvar.fog_enable_water_fog }, value = 1 }, ["shadows"] = { cvars = { cvar.r_shadows, cvar.cl_csm_static_prop_shadows, cvar.cl_csm_shadows, cvar.cl_csm_world_shadows, cvar.cl_foot_contact_shadows, cvar.cl_csm_viewmodel_shadows, cvar.cl_csm_rope_shadows, cvar.cl_csm_sprite_shadows, cvar.cl_csm_translucent_shadows, cvar.cl_csm_entity_shadows, cvar.cl_csm_world_shadows_in_viewmodelcascade }, value = 1 }, ["blood"] = { cvar = cvar.violence_hblood, value = 1 }, ["decals"] = { cvars = { cvar.r_drawdecals, cvar.r_drawropes, cvar.r_drawsprites }, value = 1 }, ["bloom"] = { cvar = cvar.mat_disable_bloom, value = 0 }, ["other"] = { cvars = { cvar.r_dynamic, cvar.r_eyegloss, cvar.r_eyes, cvar.r_drawtracers_firstperson, cvar.r_dynamiclighting }, value = 1 } }
local L491 = function()
    if not L24.get(L90["debug"][2]) then
        for L481, L482 in L10(L480) do
            if L482.cvar then
                if L482.cvar:get_int() ~= L482.value then
                    L482.cvar:set_int(L482.value)
                end
            else
                for L483, L484 in L9(L482.cvars) do
                    if L484:get_int() ~= L482.value then
                        L484:set_int(L482.value)
                    end
                end
            end
        end;
        return
    end;
    for L485, L486 in L10(L480) do
        if L132(L24.get(L90["debug"][3]), L485) then
            if L486.cvar then
                if L486.cvar:get_int() == L486.value then
                    L486.cvar:set_int(L486.value == 0 and 1 or (L486.value == 1 and 0 or L486.value))
                end
            else
                for L487, L488 in L9(L486.cvars) do
                    if L488:get_int() == L486.value then
                        L488:set_int(L486.value == 0 and 1 or (L486.value == 1 and 0 or L486.value))
                    end
                end
            end
        else
            if L486.cvar then
                if L486.cvar:get_int() ~= L486.value then
                    L486.cvar:set_int(L486.value)
                end
            else
                for L489, L490 in L9(L486.cvars) do
                    if L490:get_int() ~= L486.value then
                        L490:set_int(L486.value)
                    end
                end
            end
        end
    end
end;
local L493 = function()
    local L492 = L27.get_local_player()
    if not L27.is_alive(L492) then
        return
    end;
    L479(L492)
    L491()
end;
reset = function()
    L70.tickbase_max, L70.tickbase_diff = nil, nil;
    L70.old_tick_count = 0;
    L70.cur = 0;
    L70.banana = false;
    L70.bomb_defused = false;
    L70.bomb_exploded = false;
    local L494 = { cur = {}, prev = {} }
    local L495 = {}
    local L496 = {}
end;
reset()
local L498 = function(L497)
    L70.current_cmd = L497.command_number
end;
local L501 = function(L499)
    if L499.command_number == L70.current_cmd then
        L70.current_cmd = nil;
        local L500 = L27.get_prop(L27.get_local_player(), "m_nTickBase")
        if L70.tickbase_max ~= nil then
            L70.tickbase_diff = L500 - L70.tickbase_max
        end;
        L70.tickbase_max = L23.max(L500, L70.tickbase_max or 0)
    end
end;
local L503 = function(L502)
    return L23.floor(0.5 + L502 / L26.tickinterval())
end;
local L505 = function(L504)
    return L26.tickinterval() * L504
end;
local L506 = function()
    L70.fire_total_hits = 0;
    L70.post_total_hits = 0;
    L70.mode = "back"
    reset()
end;
local L512 = function(L507)
    if not L507 then
        return
    end;
    rage_fired = true;
    if L132(L24.get(L90["misc"][2]), "fire") then
        local L508 = L70.hitgroup_names[L507.hitgroup] or "?"
        local L509 = L507.target;
        local L510 = L26.tickcount() - L507.tick;
        local L511 = L23.min(L23.max(L27.get_prop(L509, "m_flPoseParameter", 11) * 120 - 60, -58), 58)
        g_notify:add(L22.format("fired at %s's %s for %i damage (%d%%) bt=%i (%ims) body=%iº", L27.get_player_name(L507.target), L508, L507.damage, L507.hit_chance, L510, L15(L510 * 1000), L511), { 210, 210, 255, 255 }, 5, nil, "fire")
    end;
    L70.fire_total_hits = L27.get_prop(L27.get_local_player(), "m_totalHitsOnServer")
    L70.handle_time = L26.realtime()
end;
local L518 = function(L513)
    if not L513 and (L132(L24.get(L90["misc"][2]), "damage") or L132(L24.get(L90["misc"][2]), "hurt") or L132(L24.get(L90["misc"][2]), "hurt self")) then
        return
    end;
    local L514 = L27.get_local_player()
    local L515 = L70.hitgroup_names[L513.hitgroup] or '?'
    local L516 = L28.userid_to_entindex(L513.userid)
    local L517 = L28.userid_to_entindex(L513.attacker)
    if L517 == L514 then
        if L132(L24.get(L90["misc"][2]), "damage") then
            g_notify:add(L22.format('hit %s in the %s for %d damage (%d health remaining)', L27.get_player_name(L516), L515, L513.dmg_health, L513.health), { 255, 255, 255, 255 }, 5)
        end
    elseif L517 == 0 and L516 == L514 then
        if L132(L24.get(L90["misc"][2]), "hurt self") then
            g_notify:add(L22.format("hurt yourself in the %s for %d damage (%d health remaining)", L515, L513.dmg_health, L513.health), { 255, 255, 255, 255 }, 5)
        end
    elseif L517 ~= 0 and L516 == L514 then
        if L132(L24.get(L90["misc"][2]), "hurt") then
            g_notify:add(L22.format("hurt by %s in the %s for %d damage (%d health remaining)", L27.get_player_name(L517), L515, L513.dmg_health, L513.health), { 255, 255, 255, 255 }, 5)
        end
    end
end;
local L520 = function(L519)
    if not L519 and L132(L24.get(L90["misc"][2]), "miss") then
        return
    end;
    L70.post_total_hits = L27.get_prop(L27.get_local_player(), 'm_totalHitsOnServer')
    if L519.reason == "?" then
        if L70.post_total_hits == L70.fire_total_hits + 1 and L70.post_total_hits < 255 and L70.fire_total_hits < 255 then
            L519.reason = "godmode"
        elseif L26.realtime() - L70.handle_time >= 0.5 then
            L519.reason = "delay"
        end
    end;
    g_notify:add(L22.format('missed shot due to %s', L519.reason), { 255, 255, 255, 255 }, 5)
end;
local function L521(L522)
    if not L132(L24.get(L90["misc"][2]), "fire") then
        return
    end;
    g_notify:add(L22.format("fired at %s's %s for %i damage (%d%%) bt=? (?ms) body=?º s=dormant", L27.get_player_name(L522.userid), L22.lower(L522.aim_hitbox), L522.dmg_health, L522.accuracy * 100), { 210, 210, 255, 255 }, 5, nil, "fire")
end;
local function L523(L524)
    if not L132(L24.get(L90["misc"][2]), "miss") then
        return
    end;
    g_notify:add(L22.format("fired at %s's %s for ? damage (%d%%) bt=? (?ms) body=?º s=dormant", L27.get_player_name(L524.userid), L22.lower(L524.aim_hitbox), L524.accuracy * 100), { 210, 210, 255, 255 }, 5)
    L28.delay_call(0.5, function()
        g_notify:add("missed shot due to dormant", nil, 5)
    end)
end;
local function L525(L526)
    if not L526 then
        return false
    end;
    return L70.mode ~= "back"
end;
local function L527(L528, L529)
    local L530 = { "CWorld", "CCSPlayer", "CFuncBrush", "CPhysicsPropMultiplayer", "CBaseEntity", "CC4" }
    local_origin = L2(L27.get_origin(L529))
    local L531, L532, L533 = L28.eye_position()
    local L534, L535 = L28.camera_angles()
    local L536 = L23.sin(L23.rad(L534))
    local L537 = L23.cos(L23.rad(L534))
    local L538 = L23.sin(L23.rad(L535))
    local L539 = L23.cos(L23.rad(L535))
    local L540 = { L537 * L539, L537 * L538, -L536 }
    local L541, L542 = L28.trace_line(L529, L531, L532, L533, L531 + L540[1] * 8192, L532 + L540[2] * 8192, L533 + L540[3] * 8192)
    local L543 = true;
    if L542 == -1 or L542 == nil or L529 == nil then
        return
    end;
    object_origin = L2(L27.get_origin(L542))
    local L544 = L23.abs(local_origin:dist2d(object_origin)) > 150;
    if L542 ~= nil then
        for L545 = 0, #L530 do
            if L27.get_classname(L542) == L530[L545] then
                L543 = false
            end
        end
    end;
    if L544 then
        L543 = false
    end;
    if not L543 and not L70.is_defusing and L528.in_use then
        L528.in_use = 0
    end
end;
local L550 = function(L546, L547)
    if not L547 or L27.is_dormant(L547) then
        return
    end;
    local L548 = L2(L27.get_origin(L547))
    local L549 = L2(L27.get_origin(L546))
    if L549:dist2d(L548) > 1400 and L2(L27.get_prop(L546, 'm_vecVelocity')):length2d() <= 150 then
        return true
    end;
    return false
end;
local L557 = function(L551, L552, L553)
    if not L552 or L27.is_dormant(L552) then
        return
    end;
    local L554 = { L27.get_origin(L552) }
    local L555 = { L27.get_origin(L551) }
    local L556 = L27.get_player_weapon(L551)
    if L555[3] > L554[3] + 55 and (L2(L27.get_prop(L551, 'm_vecVelocity')):length2d() <= 60 or L553.in_duck == 1) or L553.in_duck == 1 and L27.get_classname(L556) == "CKnife" then
        return true
    end;
    return false
end;
local L584 = function(L558, L559)
    if not L559 or L27.is_dormant(L559) then
        return
    end;
    local L560 = { L27.get_origin(L559) }
    local L561 = { L27.get_prop(L559, "m_vecViewOffset") }
    local L562 = { L28.eye_position() }
    local L563 = { L560[1] + L561[1], L560[2] + L561[2], L560[3] + L561[3] }
    local L564 = { L23.abs(L563[1] - L562[1]), L23.abs(L563[2] - L562[2]), L23.abs(L563[3] - L562[3]) }
    local L565 = L23.abs(L564[1] + L564[2])
    if L565 > 425 then
        return
    end;
    local L566 = { L27.get_prop(L558, 'm_vecVelocity') }
    local L567 = { L27.get_prop(L559, 'm_vecVelocity') }
    local L568 = L505(16)
    local L569 = { L562[1] + L566[1] * L568, L562[2] + L566[2] * L568, L562[3] + L566[3] * L568 }
    local L570 = { L563[1] + L567[1] * L568, L563[2] + L567[2] * L568, L563[3] + L567[3] * L568 }
    local L571, L572 = L28.trace_line(L558, L569[1], L569[2], L569[3], L570[1], L570[2], L570[3])
    local L573, L574 = L28.trace_line(L558, L570[1], L570[2], L570[3], L569[1], L569[2], L569[3])
    local L575, L576 = L28.trace_line(L558, L562[1], L562[2], L562[3], L563[1], L563[2], L563[3])
    local L577, L578 = L28.trace_line(L558, L562[1], L562[2], L562[3], L560[1], L560[2], L560[3])
    local L579 = L572 == L559 or L571 == 1;
    local L580 = L574 == L558 or L573 == 1;
    local L581 = L576 == L559 or L575 == 1;
    local L582 = L578 == L559 or L577 == 1;
    local L583 = L27.get_player_weapon(L559)
    if L27.get_classname(L583) == "CKnife" and (L579 or L580 or L581 or L582) then
        return true
    end;
    return false
end;
local L589 = function()
    local L585 = L27.get_players(true)
    if #L585 == 0 then
        L70.hittable = false;
        return
    end;
    for L586, L587 in L9(L585) do
        if L27.is_alive(L587) and not L27.is_dormant(L587) then
            local L588 = L27.get_esp_data(L587).flags or 0;
            if L21.band(L588, L21.lshift(1, 11)) ~= 0 then
                L70.hittable = true
            else
                L70.hittable = false
            end
        else
            L70.hittable = false
        end
    end;
    return false
end;
local L591 = function(L590)
    if L24.get(L127.anti_aim.other.ref_onshotantiaim[1]) and L24.get(L127.anti_aim.other.ref_onshotantiaim[2]) then
        return
    end;
    if not L24.get(L127.rage.ref_doubletap[1]) and not L24.get(L127.rage.ref_doubletap[2]) then
        return
    end;
    if L24.get(L90["misc"][8]) == "safest" then
        L70.defensive_risk = -4
    elseif L24.get(L90["misc"][8]) == "low" then
        L70.defensive_risk = -3
    elseif L24.get(L90["misc"][8]) == "medium" then
        L70.defensive_risk = -2
    elseif L24.get(L90["misc"][8]) == "high" then
        L70.defensive_risk = -1
    end;
    if L24.get(L90["misc"][6]) or L24.get(L90["misc"][7]) and L70.hittable then
        L590.force_defensive = 1;
        if L70.tickbase_diff == L70.defensive_risk then
            L24.set(L127.rage.ref_doubletap[1], false)
            L590.force_defensive = 0
        end
    else
        L590.force_defensive = 0;
        L24.set(L127.rage.ref_doubletap[1], true)
    end
end;
local L593 = function(L592)
    print(L70.tickbase_diff)
    if L3.get_double_tap() or L70.tickbase_diff ~= 1 and L24.get(L127.rage.ref_doubletap[1]) and L24.get(L127.rage.ref_doubletap[2]) then
        L592.force_defensive = 1;
        if L70.tickbase_diff ~= 1 then
            L24.set(L127.rage.ref_doubletap[1], false)
        end
    else
        L24.set(L127.rage.ref_doubletap[1], true)
    end
end;
local function L594(L595, L596, L597)
    local L598 = {
        {
            index = 13,
            condition = "backstab",
            check = function()
                return L584(L596, L597)
            end
        },
        {
            index = 16,
            condition = "legit",
            check = function()
                if L21.band(L595.buttons, 32) == 32 and not L70.is_defusing then
                    L527(L595, L596)
                    return true
                end
            end
        },
        {
            index = 11,
            condition = "manual",
            check = function()
                if L525(L132(L24.get(L90["anti-aim 2"][0]), "manual anti-aim") and L24.get(L90["anti-aim 2"][3])) then
                    return true
                end
            end
        },
        {
            index = 14,
            condition = "height",
            check = function()
                return L557(L596, L597, L595)
            end
        },
        {
            index = 15,
            condition = "high distance",
            check = function()
                return L550(L596, L597)
            end
        },
        {
            index = 12,
            condition = "freestanding",
            check = function()
                return false
            end
        },
        {
            index = 9,
            condition = "in fake duck",
            check = function()
                return L24.get(L127.rage.other.ref_fakeduck) and L21.band(L27.get_prop(L596, "m_fFlags"), 1) ~= 0
            end
        },
        {
            index = 10,
            condition = "fakelag",
            check = function()
                return not L24.get(L127.rage.ref_doubletap[2]) and not L24.get(L127.anti_aim.other.ref_onshotantiaim[2])
            end
        },
        {
            index = 5,
            condition = "in air",
            check = function()
                return (L70.jumping == true or L70.on_ground == false) and L595.in_duck == 0
            end
        },
        {
            index = 6,
            condition = "in air duck",
            check = function()
                return (L70.jumping == true or L70.on_ground == false) and L595.in_duck == 1
            end
        },
        {
            index = 8,
            condition = "in duck moving",
            check = function()
                return L595.in_duck == 1 and L2(L27.get_prop(L596, 'm_vecVelocity')):length2d() > 1.1
            end
        },
        {
            index = 7,
            condition = "in duck",
            check = function()
                return L595.in_duck == 1
            end
        },
        {
            index = 2,
            condition = "standing",
            check = function()
                return L2(L27.get_prop(L596, 'm_vecVelocity')):length2d() < 1.1
            end
        },
        {
            index = 4,
            condition = "slow motion",
            check = function()
                return L24.get(L127.anti_aim.other.ref_slowmotion[1]) and L24.get(L127.anti_aim.other.ref_slowmotion[2])
            end
        },
        {
            index = 3,
            condition = "moving",
            check = function()
                return L2(L27.get_prop(L596, 'm_vecVelocity')):length2d() > 1.1 and L21.band(L27.get_prop(L596, "m_fFlags"), 1) == 1
            end
        }
    }
    for L599, L600 in L9(L598) do
        if L600.check() then
            if L24.get(L90["anti-aim"][0]) == "gamesense" then
                if L80 ~= nil and L24.get(L80[L600.index][0]) then
                    if L24.get(L80[L600.index][12]) and L24.get(L90["anti-aim 2"][2]) then
                        if L24.get(L80[12][0]) then
                            return "freestanding", 12
                        else
                            return "freestanding", 1
                        end
                    end;
                    return L600.condition, L600.index
                end
            end
        end
    end;
    if L80 ~= nil and L24.get(L80[1][0]) then
        return "global", 1
    end;
    return "invalid", -1
end;
local L610 = function(L601, L602, L603, L604)
    if not L604 then
        return
    end;
    L70.current_condition, L70.current_condition_index = L594(L601, L602, L603)
    if L70.current_condition == "invalid" then
        L148()
        return
    end;
    if L24.get(L90["anti-aim"][0]) == "gamesense" then
        L24.set(L127.anti_aim.anti_aimbot_angles.ref_pitch[1], L24.get(L80[L70.current_condition_index][1]))
        L24.set(L127.anti_aim.anti_aimbot_angles.ref_pitch[2], L24.get(L80[L70.current_condition_index][2]))
        L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw_base, L24.get(L80[L70.current_condition_index][3]))
        L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[1], L24.get(L80[L70.current_condition_index][4]))
        if L70.current_condition == "manual" then
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_freestand[1], false)
            if L70.mode == "left" then
                L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[2], -L24.get(L90["anti-aim 2"][8]))
            elseif L70.mode == "right" then
                L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[2], L24.get(L90["anti-aim 2"][9]))
            elseif L70.mode == "forward" then
                L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[2], 180)
            end
        else
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[2], L24.get(L80[L70.current_condition_index][5]))
        end;
        if L24.get(L80[L70.current_condition_index][6]) ~= "slow" then
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw_jitter[1], L24.get(L80[L70.current_condition_index][6]))
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw_jitter[2], L24.get(L80[L70.current_condition_index][7]))
        else
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw_jitter[1], "Off")
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw_jitter[2], 0)
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[2], L70.fake_fakelag >= 3 and -L24.get(L80[L70.current_condition_index][7]) / 2 or L24.get(L80[L70.current_condition_index][7]) / 2)
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_body_yaw[1], "static")
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_body_yaw[2], L70.fake_fakelag >= 3 and -180 or 180)
        end;
        if L24.get(L80[L70.current_condition_index][6]) ~= "slow" then
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_body_yaw[1], L24.get(L80[L70.current_condition_index][8]))
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_body_yaw[2], L24.get(L80[L70.current_condition_index][9]))
        end;
        L24.set(L127.anti_aim.anti_aimbot_angles.ref_freestand_body, L24.get(L80[L70.current_condition_index][10]))
        L24.set(L127.anti_aim.anti_aimbot_angles.ref_edge_yaw, L24.get(L80[L70.current_condition_index][11]))
        L24.set(L127.anti_aim.anti_aimbot_angles.ref_roll, L24.get(L80[L70.current_condition_index][13]))
        if L70.current_condition == "freestanding" then
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_freestand[1], true)
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_edge_yaw, false)
        else
            L24.set(L127.anti_aim.anti_aimbot_angles.ref_freestand[1], false)
        end;
        if L24.get(L80[L70.current_condition_index][14]) then
            L601.force_defensive = 1
        end;
        if L26.chokedcommands() < 13 and L70.tickbase_diff ~= nil and L70.tickbase_diff ~= 1 and L70.tickbase_diff < -2 then
            local L605 = L80[L70.current_condition_index]
            local L606 = L24.get(L605[15])
            local L607 = L24.get(L605[16])
            if L606 ~= "off" and L606 ~= "zero" then
                L24.set(L127.anti_aim.anti_aimbot_angles.ref_pitch[1], L606)
            else
                if L606 == "zero" then
                    L24.set(L127.anti_aim.anti_aimbot_angles.ref_pitch[1], "custom")
                    L24.set(L127.anti_aim.anti_aimbot_angles.ref_pitch[2], 0)
                end
            end;
            if L607 ~= "off" then
                L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[1], "180")
                L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw_jitter[1], "off")
                if L607 == "forward" then
                    L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[2], 180)
                elseif L607 == "spin" then
                    L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[2], L110(L138(L70.yaw_increment_spin), -180, 180))
                elseif L607 == "jitter" then
                    L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[2], L70.banana and 90 or -90)
                elseif L607 == "opposite" then
                    local L608 = { forward = 0, left = 90, right = -90 }
                    local L609 = L608[L70.mode]
                    if L609 ~= nil then
                        L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[2], L609)
                    end
                end
            end
        end;
        L24.set(L127.anti_aim.anti_aimbot_angles.ref_yaw[1], L24.get(L80[L70.current_condition_index][4]))
    else
        if L24.get(L90["anti-aim"][0]) == "wraith (dont use)" then
            L148()
        end
    end
end;
local L615 = function(L611)
    local_origin = L2(L27.get_origin(L611))
    local L612 = nil;
    local L613 = L2(L27.get_prop(L27.get_all("CPlantedC4")[1], "m_vecOrigin"))
    if L613.x ~= nil then
        L612 = local_origin:dist(L613)
    else
        L612 = nil
    end;
    local L614 = L27.get_prop(L611, "m_iTeamNum")
    L70.is_defusing = L614 == 3 and L612 < 60 and not L70.bomb_defused and not L70.bomb_exploded
end;
local L619 = function(L616)
    local L617 = L27.get_local_player()
    local L618 = L28.current_threat()
    if L24.get(L90["debug"][0]) and L86.is_hovered or L157.dragging then
        L616.in_attack = false
    end;
    L70.on_ground = L21.band(L27.get_prop(L617, "m_fFlags"), 1) == 1;
    L70.jumping = L24.get(L127.misc.movement.ref_bhop) and L616.in_jump == 1;
    L70.in_speed = L21.band(L616.buttons, 131072) > 0;
    L589()
    L591(L616)
    L615(L617)
    if L26.chokedcommands() == 0 then
        L70.current_desync = L23.min(L23.max(L27.get_prop(L617, "m_flPoseParameter", 11) * 120 - 60, -58), 58)
        L70.current_desync = L70.current_desync > 0 and L23.ceil(L70.current_desync) or L23.floor(L70.current_desync)
    end;
    if L26.chokedcommands() == 0 then
        L70.fake_fakelag = L70.fake_fakelag + 1;
        if L70.fake_fakelag >= 6 then
            L70.fake_fakelag = 0
        end
    end;
    L610(L616, L617, L618, true)
end;
local L624 = function()
    if not L86.is_open then
        L86.mouse_press = false;
        return
    end;
    local L620 = L24.get(L127.misc.settings.ref_dpiscale)
    local L621 = { L24.menu_size() }
    local L622 = { L24.menu_position() }
    local L623 = { L24.mouse_position() }
    scale = { 0, 0 }
    scale_x = 0;
    if L620 == "100%" then
        scale = { L86.dpi_scaling_y[1][1], L86.dpi_scaling_y[1][2] }
        scale_x = 76
    elseif L620 == "125%" then
        scale = { L86.dpi_scaling_y[2][1], L86.dpi_scaling_y[2][2] }
        scale_x = 95
    elseif L620 == "150%" then
        scale = { L86.dpi_scaling_y[3][1], L86.dpi_scaling_y[3][2] }
        scale_x = 113
    elseif L620 == "175%" then
        scale = { L86.dpi_scaling_y[4][1], L86.dpi_scaling_y[4][2] }
        scale_x = 132
    elseif L620 == "200%" then
        scale = { L86.dpi_scaling_y[5][1], L86.dpi_scaling_y[5][2] }
        scale_x = 151
    end;
    if L28.key_state(0x1) then
        if not L86.mouse_press then
            L86.mouse_press = true;
            if L623[1] > L622[1] + 5 and L623[1] < L622[1] + 5 + scale_x then
                if L623[2] > L622[2] + scale[1] and L623[2] < L622[2] + scale[2] then
                    L86.selected_gs_tab = true
                elseif L623[2] > L622[2] + 19 or L623[2] < L622[2] + L621[2] and (L623[2] < L622[2] + scale[1] and L623[2] > L622[2] + scale[2]) and L623[2] < L622[2] + L621[2] and L86.selected_gs_tab == true then
                    L86.selected_gs_tab = false
                end
            end
        end
    else
        L86.mouse_press = false
    end
end;
local L629 = function()
    if L27.get_prop(L27.get_local_player(), "m_MoveType") == 8 then
        L70.current_condition_index = 17;
        L70.current_condition = "noclip"
    end;
    local L625 = { ["left"] = L90["anti-aim 2"][4], ["right"] = L90["anti-aim 2"][5], ["forward"] = L90["anti-aim 2"][6], ["back"] = L90["anti-aim 2"][7] }
    local L626;
    for L627, L628 in L10(L625) do
        if L24.get(L628) and L70[L627 .. "_ready"] then
            L626 = L627 == L70.mode and "back" or L627;
            L70[L627 .. "_ready"] = false
        end;
        if not L24.get(L628) then
            L70[L627 .. "_ready"] = true
        end
    end;
    L70.mode = L626 or L70.mode
end;
local L630 = function()
    L70.cur = L26.tickcount()
    if L70.cur > L70.old_tick_count then
        L70.banana = not L70.banana;
        L70.old_tick_count = L70.cur + 1
    end;
    L70.yaw_increment_spin = L70.yaw_increment_spin + 20;
    if L70.yaw_increment_spin >= 1080 then
        L70.yaw_increment_spin = 0
    end;
    if L70.started == 10 then
        if L70.pulse >= 10 then
            L70.pulse = L70.pulse + 2.5
        end;
        if L70.pulse >= 240 then
            L70.started = 1
        end
    end;
    if L70.started == 1 then
        L70.pulse = L70.pulse - 2.5;
        if L70.pulse <= 10 then
            L70.started = 10
        end
    end
end;
local L647 = function(L631)
    local L632 = L27.get_players(true)
    if #L632 == 0 then
        L71 = { cur = {}, prev = {}, pre_prev = {}, pre_pre_prev = {} }
        return nil
    end;
    for L633, L634 in L9(L632) do
        if L27.is_alive(L634) and not L27.is_dormant(L634) then
            local L635 = 0;
            local L636 = L27.get_esp_data(L634).flags or 0;
            if L21.band(L636, L21.lshift(1, 17)) ~= 0 then
                L635 = L503(L27.get_prop(L634, "m_flSimulationTime")) - 14
            else
                L635 = L503(L27.get_prop(L634, "m_flSimulationTime"))
            end;
            if L71.cur[L634] == nil or L635 - L71.cur[L634].simtime >= 1 then
                L71.pre_pre_prev[L634] = L71.pre_prev[L634]
                L71.pre_prev[L634] = L71.prev[L634]
                L71.prev[L634] = L71.cur[L634]
                local L637 = L2(L27.get_prop(L631, "m_vecOrigin"))
                local L638 = L2(L27.get_prop(L634, "m_angEyeAngles"))
                local L639 = L2(L27.get_prop(L634, "m_vecOrigin"))
                local L640 = L23.floor(L138(L638.y - calculate_angle(L637, L639)))
                local L641 = L27.get_prop(L634, "m_flDuckAmount")
                local L642 = L21.band(L27.get_prop(L634, "m_fFlags"), 1) == 1;
                local L643 = L2(L27.get_prop(L634, 'm_vecVelocity')):length2d()
                local L644 = L642 and (L641 == 1 and "duck" or (L643 > 1.2 and "running" or "standing")) or "air"
                local L645 = L27.get_player_weapon(L634)
                local L646 = L27.get_prop(L645, "m_fLastShotTime")
                L71.cur[L634] = { id = L634, origin = L2(L27.get_origin(L634)), pitch = L638.x, yaw = L640, yaw_backwards = L23.floor(L138(calculate_angle(L637, L639))), simtime = L635, stance = L644, esp_flags = L27.get_esp_data(L634).flags or 0, last_shot_time = L646 }
            end
        end
    end
end;
local L648 = false;
local L672 = function(L649)
    if not L27.is_alive(L649) then
        if L648 then
        end;
        L648 = false;
        return
    end;
    local L650 = L27.get_players(true)
    if #L650 == 0 then
        return nil
    end;
    for L651, L652 in L9(L650) do
        if L27.is_alive(L652) and not L27.is_dormant(L652) then
            if L71.cur[L652] ~= nil and L71.prev[L652] ~= nil and L71.pre_prev[L652] ~= nil and L71.pre_pre_prev[L652] ~= nil then
                local L653 = nil;
                local L654 = nil;
                local L655;
                local L656;
                local L657 = L23.abs(L138(L71.cur[L652].yaw - L71.prev[L652].yaw))
                local L658 = L138(L71.cur[L652].yaw - L71.prev[L652].yaw)
                if L71.cur[L652].last_shot_time ~= nil then
                    L655 = L26.curtime() - L71.cur[L652].last_shot_time;
                    L656 = L655 / L26.tickinterval()
                    L654 = L656 <= L23.floor(0.2 / L26.tickinterval())
                end;
                if L24.get(L90["debug"][1]) == "desync" then
                    L648 = true;
                    local L659 = L71.cur[L652].yaw;
                    local L660 = L71.prev[L652].yaw;
                    local L661 = L71.pre_prev[L652].yaw;
                    local L662 = L71.pre_pre_prev[L652].yaw;
                    local L663 = L138(L659 - L660)
                    local L664 = L138(L659 - L661)
                    local L665 = L138(L660 - L662)
                    local L666 = L138(L660 - L661)
                    local L667 = L138(L661 - L662)
                    local L668 = L138(L662 - L659)
                    local L669 = L138(L657 - L668)
                    if L654 and L23.abs(L23.abs(L71.cur[L652].pitch) - L23.abs(L71.prev[L652].pitch)) > 30 and L71.cur[L652].pitch < L71.prev[L652].pitch then
                        L653 = "ON SHOT"
                    else
                        if L23.abs(L71.cur[L652].pitch) > 60 then
                            if L657 > 30 and L23.abs(L664) < 15 and L23.abs(L665) < 15 then
                                L653 = "[!!]"
                            elseif L23.abs(L663) > 15 or L23.abs(L666) > 15 or L23.abs(L667) > 15 or L23.abs(L668) > 15 then
                                L653 = "[!!!]"
                            end
                        end
                    end;
                    if L24.get(L90["debug"][5]) and L24.get(L90["debug"][6]) then
                        if L653 ~= "ON SHOT" then
                            L18.set(L652, "Add to whitelist", true)
                        else
                            L18.set(L652, "Add to whitelist", false)
                        end
                    else
                        L18.set(L652, "Add to whitelist", false)
                    end;
                    if L147[L652] and L653 ~= nil then
                        if L71.cur[L652].stance == "standing" and #L73[L652].stand < 20 then
                            table.insert(L73[L652].stand_type, L653)
                            if L653 == "[!!!]" and L657 > 5 then
                                table.insert(L73[L652].stand, L657)
                            else
                                if L653 == "[!!]" then
                                    table.insert(L73[L652].stand, L657)
                                end
                            end
                        elseif L71.cur[L652].stance == "running" and #L73[L652].run < 20 then
                            table.insert(L73[L652].run_type, L653)
                            if L653 == "[!!!]" and L657 > 5 then
                                table.insert(L73[L652].run, L657)
                            else
                                if L653 == "[!!]" then
                                    table.insert(L73[L652].run, L657)
                                end
                            end
                        elseif L71.cur[L652].stance == "air" and #L73[L652].air < 20 then
                            table.insert(L73[L652].air_type, L653)
                            if L653 == "[!!!]" and L657 > 5 then
                                table.insert(L73[L652].air, L657)
                            else
                                if L653 == "[!!]" then
                                    table.insert(L73[L652].air, L657)
                                end
                            end
                        elseif L71.cur[L652].stance == "duck" and #L73[L652].duck < 20 then
                            table.insert(L73[L652].duck_type, L653)
                            if L653 == "[!!!]" and L657 > 5 then
                                table.insert(L73[L652].duck, L657)
                            else
                                if L653 == "[!!]" then
                                    table.insert(L73[L652].duck, L657)
                                end
                            end
                        end
                    end;
                    if L71.cur[L652].pitch >= 78 and L71.prev[L652].pitch > 78 then
                        if L653 == "[!!!]" or L653 == "[!!]" then
                            if L653 == "[!!]" then
                                if L138(L659 - L660) > 0 then
                                    L18.set(L652, "Force body yaw", true)
                                    L18.set(L652, "Force body yaw value", 60)
                                elseif L138(L659 - L660) < 0 then
                                    L18.set(L652, "Force body yaw", true)
                                    L18.set(L652, "Force body yaw value", -60)
                                end
                            elseif L653 == "[!!!]" then
                                local L670 = 0;
                                local L671 = 0;
                                if (L660 == L138(L659 - L657) or L660 == L138(L659 + L657)) and (L661 == L138(L659 + L657) or L661 == L659) and (L661 == L138(L659 + L657) or L661 == L659) then
                                    L18.set(L652, "Force body yaw", true)
                                    L18.set(L652, "Force body yaw value", 0)
                                    L670 = L659
                                else
                                    if L659 ~= L670 then
                                        if L659 < 0 then
                                            L18.set(L652, "Force body yaw", true)
                                            L18.set(L652, "Force body yaw value", 60)
                                        else
                                            L18.set(L652, "Force body yaw", true)
                                            L18.set(L652, "Force body yaw value", -60)
                                        end
                                    end
                                end
                            end
                        else
                            L18.set(L652, "Force body yaw", false)
                            L18.set(L652, "Force body yaw value", 0)
                        end
                    end
                elseif L24.get(L90["debug"][1]) == "---" then
                    L653 = nil;
                    L648 = true;
                    break
                elseif L24.get(L90["debug"][1]) == "off" then
                    if L648 then
                        L653 = nil;
                        L24.set(L127.plist.reset, true)
                        L18.set(L652, "Force body yaw", false)
                        L18.set(L652, "Force body yaw value", 0)
                        L648 = false
                    end
                end;
                L72[L652] = { anti_aim_type = L653, yaw_delta = L658 }
            end
        else
            m_fired = false;
            time_difference = 0;
            ticks_since_last_shot = 0
        end
    end
end;
local L674 = function(L673)
    L673 = L27.get_local_player()
    if not L24.get(L76) then
        return
    end;
    if L132(L24.get(L90["misc"][1]), "fake duck") then
        L27.set_prop(L673, "m_flPoseParameter", 1, 1)
    end;
    L630()
    L647(L673)
    L672(L673)
end;
L28.register_esp_flag("", 255, 255, 255, function(L675)
    if not L27.is_alive(L27.get_local_player()) then
        return
    end;
    if L24.get(L90["debug"][1]) then
        if L27.is_alive(L675) and not L27.is_dormant(L675) then
            if L72[L675] ~= nil then
                if L72[L675].anti_aim_type ~= nil then
                    return true, "\affffffc8" .. L22.upper(L72[L675].anti_aim_type)
                end
            end
        end
    end
end)
local L690 = function()
    if not L24.get(L90["debug"][0]) or not L24.get(L76) then
        L86.menu_alpha = 0;
        L86.is_hovered = false;
        L88 = false;
        return
    end;
    local L676 = L24.get(L127.misc.settings.ref_dpiscale)
    L86.height = L89[L676] or 68;
    if L24.get(L127.misc.settings.ref_menukey) then
        if not L87 then
            L87 = true;
            L86.is_open = not L86.is_open;
            L88 = false
        end
    else
        L87 = false
    end;
    if not L24.is_menu_open() then
        L86.is_open = false
    end;
    if not L88 then
        L86.fade_start_time = L86.is_open and L26.realtime() or L26.realtime()
        L88 = true
    end;
    if not L86.selected_gs_tab then
        L86.menu_alpha = 0
    end;
    local L677 = L86.is_open and L86.selected_gs_tab and 255 or 0;
    local L678 = L26.realtime() - L86.fade_start_time;
    local L679 = L23.min(1, L678 / 0.5)
    L86.menu_alpha = L136(L86.menu_alpha, L677, L679)
    if L86.menu_alpha <= 0 then
        L86.is_hovered = false;
        return
    end;
    local L680 = { L24.menu_size() }
    local L681 = L23.ceil((L680[1] - 12) / #L86.tabs_names)
    local L682 = { L24.menu_position() }
    local L683 = { L24.mouse_position() }
    L86.is_hovered = L683[1] > L682[1] and L683[1] < L682[1] + L681 * #L86.tabs_names and L683[2] > L682[2] - L86.height and L683[2] < L682[2] - L86.height + L86.height;
    for L684, L685 in L9(L86.tabs_names) do
        local L686 = L682[1] + 6 + L681 * (L684 - 1)
        local L687 = L683[1] > L686 and L683[1] < L686 + L681 and L683[2] > L682[2] - L86.height and L683[2] < L682[2]
        if L86.selected_tab == L684 then
            L86.selected_color[1] = { 20, 20, 20 }
            L86.selected_color[2] = { 210, 210, 210 }
        else
            L86.selected_color[1] = { 12, 12, 12 }
            L86.selected_color[2] = { 90, 90, 90 }
        end;
        if L687 and L86.selected_tab ~= L684 then
            L86.selected_color[1] = { 12, 12, 12 }
            L86.selected_color[2] = { 167, 167, 167 }
        end;
        L25.rectangle(L686, L682[2] - L86.height, L681, L86.height, L86.selected_color[1][1], L86.selected_color[1][2], L86.selected_color[1][3], L86.menu_alpha)
        L25.text(L686 + L681 / 2, L682[2] - L86.height / 2, L86.selected_color[2][1], L86.selected_color[2][2], L86.selected_color[2][3], L86.menu_alpha, "c+d", 0, L684 == 6 and L85[L24.get(L90["debug"][4])] or L685)
        if L687 and L28.key_state(0x1) then
            L86.selected_tab = L684;
            for L688, L689 in L9(L81) do
                if L86.selected_tab == L688 then
                    L24.set(L90.tab, L689)
                end
            end
        end
    end;
    gamesense_outer(L682[1], L682[2], L680[1], L86.height, L86.menu_alpha, false)
end;
local L691 = L24.new_label("Players", "Adjustments", "-")
local L692 = L24.new_label("Players", "Adjustments", "-")
local function L693()
    local L694 = L24.get(L127.plist.players)
    if L694 == nil then
        return
    end;
    if not L147[L694] then
        g_notify:add("[STEALER] Please enable 'scan anti-aim'.", nil, 5)
        return
    end;
    if L146[L694] then
        if #L73[L694].stand >= 20 or #L73[L694].run >= 20 or #L73[L694].air >= 20 or #L73[L694].duck >= 20 then
            if #L73[L694].stand >= 20 then
                local L695 = L126(L73[L694].stand_type)
                local L696 = L126(L73[L694].stand)
                if L695 == "[!!]" then
                    L695 = "Center"
                elseif L695 == "[!!!]" then
                    L695 = "Skitter"
                end;
                L24.set(L80[2][6], L695)
                L24.set(L80[2][7], L696)
            end;
            if #L73[L694].run >= 20 then
                local L697 = L126(L73[L694].run_type)
                local L698 = L126(L73[L694].run)
                if L697 == "[!!]" then
                    L697 = "Center"
                elseif L697 == "[!!!]" then
                    L697 = "Skitter"
                end;
                L24.set(L80[3][6], L697)
                L24.set(L80[3][7], L698)
            end;
            if #L73[L694].air >= 20 then
                local L699 = L126(L73[L694].air_type)
                local L700 = L126(L73[L694].air)
                if L699 == "[!!]" then
                    L699 = "Center"
                elseif L699 == "[!!!]" then
                    L699 = "Skitter"
                end;
                L24.set(L80[5][6], L699)
                L24.set(L80[5][7], L700)
            end;
            if #L73[L694].duck >= 20 then
                local L701 = L126(L73[L694].duck_type)
                local L702 = L126(L73[L694].duck)
                if L701 == "[!!]" then
                    L701 = "Center"
                elseif L701 == "[!!!]" then
                    L701 = "Skitter"
                end;
                L24.set(L80[7][6], L701)
                L24.set(L80[7][7], L702)
            end
        else
            g_notify:add("[STEALER] At least one stance must be done", nil, 5)
        end
    else
        if #L73[L694].stand ~= 20 then
            g_notify:add("[STEALER] Still scanning standing anti-aim", nil, 5)
            return
        end;
        if #L73[L694].run ~= 20 then
            g_notify:add("[STEALER] Still scanning running anti-aim", nil, 5)
            return
        end;
        if #L73[L694].air ~= 20 then
            g_notify:add("[STEALER] Still scanning air anti-aim", nil, 5)
            return
        end;
        if #L73[L694].duck ~= 20 then
            g_notify:add("[STEALER] Still scanning duck anti-aim", nil, 5)
            return
        end;
        if #L73[L694].stand >= 20 then
            local L703 = L126(L73[L694].stand_type)
            local L704 = L126(L73[L694].stand)
            if L703 == "[!!]" then
                L703 = "Center"
            elseif L703 == "[!!!]" then
                L703 = "Skitter"
            end;
            L24.set(L80[2][6], L703)
            L24.set(L80[2][7], L704)
        end;
        if #L73[L694].run >= 20 then
            local L705 = L126(L73[L694].run_type)
            local L706 = L126(L73[L694].run)
            if L705 == "[!!]" then
                L705 = "Center"
            elseif L705 == "[!!!]" then
                L705 = "Skitter"
            end;
            L24.set(L80[3][6], L705)
            L24.set(L80[3][7], L706)
        end;
        if #L73[L694].air >= 20 then
            local L707 = L126(L73[L694].air_type)
            local L708 = L126(L73[L694].air)
            if L707 == "[!!]" then
                L707 = "Center"
            elseif L707 == "[!!!]" then
                L707 = "Skitter"
            end;
            L24.set(L80[5][6], L707)
            L24.set(L80[5][7], L708)
        end;
        if #L73[L694].duck >= 20 then
            local L709 = L126(L73[L694].duck_type)
            local L710 = L126(L73[L694].duck)
            if L709 == "[!!]" then
                L709 = "Center"
            elseif L709 == "[!!!]" then
                L709 = "Skitter"
            end;
            L24.set(L80[7][6], L709)
            L24.set(L80[7][7], L710)
        end
    end;
    g_notify:add("[STEALER] Imported anti-aim settings from: " .. L27.get_player_name(L694), nil, 5)
end;
local L712 = function()
    local L711 = L24.get(L127.plist.players)
    if L711 then
        if L147[L711] then
            perc_stand = #L73[L711].stand / 20 * 100;
            perc_run = #L73[L711].run / 20 * 100;
            perc_air = #L73[L711].air / 20 * 100;
            perc_duck = #L73[L711].duck / 20 * 100;
            steal_string = perc_stand .. "% - " .. perc_run .. "% - " .. perc_air .. "% - " .. perc_duck .. "%"
            L24.set(L691, L22.format("%s", steal_string))
            L24.set(L692, L22.format("%s", "stand - run - air - duck"))
            if L146[L711] then
                if perc_stand == 100 or perc_run == 100 or perc_air == 100 or perc_duck == 100 then
                    L24.set(L691, L22.format('%s', "done!"))
                end
            else
                if perc_stand == 100 and perc_run == 100 and perc_air == 100 and perc_duck == 100 then
                    L24.set(L691, L22.format('%s', "done!"))
                end
            end
        else
            L24.set(L691, L22.format('%s', "waiting for scan..."))
            L73[L711].stand = {}
            L73[L711].stand_type = {}
            L73[L711].run = {}
            L73[L711].run_type = {}
            L73[L711].air = {}
            L73[L711].air_type = {}
            L73[L711].duck = {}
            L73[L711].duck_type = {}
        end
    end
end;
local L713 = L24.new_button("Players", "Adjustments", "import anti-aim", L693)
local L714 = false;
local L734 = function()
    local L715 = L24.get(L76)
    local L716 = false;
    local L717 = L24.get(L90.tab)
    local L718 = L24.get(L90["anti-aim"][0])
    local L719 = L24.get(L90["anti-aim"][1])
    L690()
    if not L24.is_menu_open() then
        return
    end;
    L624()
    L154(L715)
    if not L715 then
        if not L70.reset_once then
            L148()
            L70.reset_once = true
        end;
        L70.smooth_wraith = -1080;
        L70.smooth_dt = -1080;
        L70.smooth_os = -1080;
        L70.smooth_pc = -1080;
        L70.smooth_bo = -1080;
        L70.smooth_wraith_recode = -1080;
        L70.smooth_dt_2 = -1080;
        L70.smooth_stance = -1080;
        L70.dt_os_text_anim = 0;
        L70.current_cond_text_anim = 0
    else
        L24.set(L127.anti_aim.anti_aimbot_angles.ref_aa_enabled, true)
        L70.reset_once = false
    end;
    if L717 == "config" then
        L24.update(L90["config"][1], update_cfg())
    end;
    L24.set_visible(L90.tab, L715 and L24.get(L90["debug"][0]) == false)
    L712()
    if L24.get(L90["debug"][1]) ~= "off" then
        L24.set_visible(L127.plist.force_body, false)
        L24.set_visible(L127.plist.force_body_value, false)
        L714 = true
    else
        if L714 then
            L24.set_visible(L127.plist.force_body, true)
            L24.set_visible(L127.plist.force_body_value, true)
            local L720 = L27.get_players(true)
            if #L720 ~= 0 then
                for L721, L722 in L9(L720) do
                    L18.set(L722, "Force body yaw", false)
                    L18.set(L722, "Force body yaw value", 0)
                end
            end;
            L714 = false
        end
    end;
    for L723, L724 in L10(L90) do
        if L724 ~= L90.tab then
            for L725, L726 in L10(L724) do
                L24.set_visible(L726, L715 and L723 == L717)
                if L717 == "anti-aim 2" then
                    for L727 = 1, 9 do
                        if L727 == 1 or L727 == 2 then
                            L24.set_visible(L90["anti-aim 2"][L727], L715 and L132(L24.get(L90["anti-aim 2"][0]), "other anti-aim binds"))
                        elseif L727 > 2 and L727 < 10 then
                            L24.set_visible(L90["anti-aim 2"][L727], L715 and L132(L24.get(L90["anti-aim 2"][0]), "manual anti-aim"))
                        end
                    end
                end;
                if L717 == "visuals" then
                    L24.set_visible(L90["visuals"][4], L715 and L24.get(L90["visuals"][2]))
                    L24.set_visible(L90["visuals"][5], L715 and L24.get(L90["visuals"][7]))
                    if not L132(L24.get(L90["misc"][3]), "default") and not L132(L24.get(L90["misc"][3]), "center") then
                        L24.set_visible(L90["visuals"][5], L715 and false)
                        L24.set_visible(L90["visuals"][7], L715 and false)
                    end
                end;
                if L717 == "misc" then
                    L24.set_visible(L90["misc"][5], L715 and L24.get(L90["misc"][4]))
                end;
                if L717 == "debug" then
                    L24.set_visible(L90["debug"][3], L715 and L24.get(L90["debug"][2]))
                end
            end
        end
    end;
    for L728, L729 in L9({ L82, L83 }) do
        L78 = L729;
        for L730, L731 in L10(L729) do
            if L718 == "gamesense" and L729 == L82 then
                L80 = L729
            elseif L718 == "wraith (dont use)" and L729 == L83 then
                L79 = L729
            end;
            for L732, L733 in L10(L731) do
                L716 = (L718 == "gamesense" and L729 == L82 or L718 == "wraith (dont use)" and L729 == L83) and L84[L730] == L719 and L717 == "anti-aim" and L715 and (L733 == L729[L730][0] or L24.get(L729[L730][0]))
                if L718 == "gamesense" and L729 == L82 then
                    if L719 == "freestanding" or L719 == "manual" or L719 == "legit" or L719 == "backstab" then
                        L716 = L716 and (L733 ~= L729[L730][11] and L733 ~= L729[L730][12])
                    end;
                    if L719 == "manual" then
                        L716 = L716 and L733 ~= L729[L730][5]
                    end;
                    if L24.get(L729[L730][1]) ~= "custom" then
                        L716 = L716 and L733 ~= L729[L730][2]
                    end;
                    if L24.get(L729[L730][4]) == "off" then
                        L716 = L716 and (L733 ~= L729[L730][5] and L733 ~= L729[L730][6] and L733 ~= L729[L730][7])
                    end;
                    if L24.get(L729[L730][6]) == "off" then
                        L716 = L716 and L733 ~= L729[L730][7]
                    end;
                    if L24.get(L729[L730][8]) then
                        if L24.get(L729[L730][8]) == "off" then
                            L716 = L716 and L733 ~= L729[L730][10]
                        end;
                        if L24.get(L729[L730][8]) == "off" or L24.get(L729[L730][8]) == "opposite" then
                            L716 = L716 and L733 ~= L729[L730][9]
                        end
                    end;
                    if L24.get(L729[L730][6]) == "slow" then
                        L716 = L716 and (L733 ~= L729[L730][9] and L733 ~= L729[L730][8])
                    end
                end;
                L24.set_visible(L733, L716)
            end
        end
    end
end;
writefile(L13("!default_preset2124089493w.cfg"), "dHJ1ZV9taW5pbWFsXzBfYXQgdGFyZ2V0c18xODBfMF9za2l0dGVyXzIwX2ppdHRlcl8wX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfZmFsc2Vfb2ZmX29mZl90cnVlX21pbmltYWxfMF9hdCB0YXJnZXRzXzE4MF8wX3NraXR0ZXJfMzBfaml0dGVyXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX3RydWVfZGVmYXVsdF8wX2F0IHRhcmdldHNfMTgwXzBfc2xvd183MF9qaXR0ZXJfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9kZWZhdWx0XzBfYXQgdGFyZ2V0c18xODBfMF9za2l0dGVyXzUwX2ppdHRlcl8wX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfZmFsc2Vfb2ZmX29mZl90cnVlX2RlZmF1bHRfMF9hdCB0YXJnZXRzXzE4MF8wX3NraXR0ZXJfMzBfaml0dGVyXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX3RydWVfZGVmYXVsdF8wX2F0IHRhcmdldHNfMTgwXzBfc2xvd183M19qaXR0ZXJfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9taW5pbWFsXzBfYXQgdGFyZ2V0c18xODBfLTE1X29mZl81X3N0YXRpY18tNTRfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX3RydWVfbWluaW1hbF8wX2F0IHRhcmdldHNfMTgwXzVfc2tpdHRlcl8zMF9qaXR0ZXJfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfZmFsc2Vfb2ZmXzBfbG9jYWwgdmlld19vZmZfMF9vZmZfMF9vZmZfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9taW5pbWFsXzBfYXQgdGFyZ2V0c18xODBfM19vZmZzZXRfMTlfaml0dGVyXzE4MF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9taW5pbWFsXzBfbG9jYWwgdmlld18xODBfMF9vZmZfMF9zdGF0aWNfMTgwX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfZmFsc2Vfb2ZmX2ppdHRlcl9mYWxzZV91cF8wX2F0IHRhcmdldHNfc3Bpbl8xOV9vZmZfNDdfaml0dGVyXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV91cF9vZmZfdHJ1ZV9yYW5kb21fMF9hdCB0YXJnZXRzXzE4MF8xODBfb2ZmXzBfb2ZmXzE4MF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9taW5pbWFsXzBfYXQgdGFyZ2V0c18xODBfMF9vZmZfOF9zdGF0aWNfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9kZWZhdWx0XzBfYXQgdGFyZ2V0c18xODBfMF9vZmZfMF9zdGF0aWNfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9vZmZfMF9sb2NhbCB2aWV3XzE4MF8xODBfb2ZmXzBfaml0dGVyXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX3RydWVfb2ZmX29mZl8wX29mZl8=")
writefile(L13("!default_fs_preset2124089493w.cfg"), "ZmFsc2Vfb2ZmXzBfbG9jYWwgdmlld19vZmZfMF9vZmZfMF9vZmZfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9kb3duXzBfYXQgdGFyZ2V0c18xODBfMF9za2l0dGVyXzQ1X2ppdHRlcl8wX2ZhbHNlX2ZhbHNlX3RydWVfMF9mYWxzZV9vZmZfb2ZmX3RydWVfZG93bl8wX2F0IHRhcmdldHNfMTgwXy0xX3Nsb3dfNDlfaml0dGVyXzBfZmFsc2VfZmFsc2VfdHJ1ZV8wX3RydWVfb2ZmX29wcG9zaXRlX3RydWVfZG93bl8wX2F0IHRhcmdldHNfMTgwXzFfc2xvd18xMTBfb3Bwb3NpdGVfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX3RydWVfb2ZmX29wcG9zaXRlX3RydWVfZG93bl8wX2F0IHRhcmdldHNfMTgwXy01X2NlbnRlcl8yN19vcHBvc2l0ZV8wX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfdHJ1ZV96ZXJvX3NwaW5fdHJ1ZV9taW5pbWFsXy00Nl9hdCB0YXJnZXRzXzE4MF8tNV9jZW50ZXJfMjdfc3RhdGljXzdfZmFsc2VfZmFsc2VfZmFsc2VfMF90cnVlX3JhbmRvbV9qaXR0ZXJfdHJ1ZV9kb3duXzBfYXQgdGFyZ2V0c18xODBfLTdfb2ZmXzMyX3N0YXRpY18tMTgwX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfZmFsc2Vfb2ZmX29mZl90cnVlX21pbmltYWxfMF9hdCB0YXJnZXRzXzE4MF8tMV9zbG93XzQ1X29wcG9zaXRlXy0xODBfZmFsc2VfZmFsc2VfZmFsc2VfMF90cnVlX21pbmltYWxfb3Bwb3NpdGVfdHJ1ZV9kb3duXzBfYXQgdGFyZ2V0c18xODBfLTJfY2VudGVyXzMyX3N0YXRpY18tMTgwX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfdHJ1ZV9taW5pbWFsX29wcG9zaXRlX2ZhbHNlX29mZl8wX2xvY2FsIHZpZXdfb2ZmXzBfb2ZmXzBfb2ZmXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX2ZhbHNlX29mZl8wX2xvY2FsIHZpZXdfb2ZmXzBfb2ZmXzBfb2ZmXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX3RydWVfZG93bl8wX2F0IHRhcmdldHNfMTgwXzBfb2ZmXzE1X29wcG9zaXRlXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX3RydWVfb2ZmXzBfYXQgdGFyZ2V0c18xODBfMTgwX29mZl8wX29wcG9zaXRlXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX2ZhbHNlX21pbmltYWxfMF9hdCB0YXJnZXRzXzE4MF8tMV9vZmZfOF9vcHBvc2l0ZV8zX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfZmFsc2VfbWluaW1hbF9vZmZfZmFsc2Vfb2ZmXzBfbG9jYWwgdmlld19vZmZfMF9vZmZfMF9vZmZfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9jdXN0b21fMF9hdCB0YXJnZXRzX29mZl8wX29mZl8wX29wcG9zaXRlXzE4MF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX2Zha2UgZG93biAoLTE4MClfY2VudGVyXzIzX2ppdHRlcl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl90cnVlX29mZl9vZmZfMF9vZmZf")
local L735 = function()
    if L24.get(L90["config"][2]) == "" then
        if L132(L24.get(L90["misc"][2]), "config changes") then
            g_notify:add("(error) empty config name", nil, 5)
        end;
        return
    end;
    if not L132(L53(), L24.get(L90["config"][2]) .. "2124089493w.cfg") then
        if L132(L24.get(L90["misc"][2]), "config changes") then
            g_notify:add("'" .. L24.get(L90["config"][2]) .. "' anti-aim config created", nil, 5)
        end;
        writefile(L13(L24.get(L90["config"][2]) .. "2124089493w.cfg"), "blank")
    else
        if L132(L24.get(L90["misc"][2]), "config changes") then
            g_notify:add("(error) '" .. L22.sub(L53()[L24.get(L90["config"][1]) + 1], 1, -16) .. "' anti-aim config already exists", nil, 5)
        end
    end
end;
local L744 = function()
    if L24.get(L90["config"][1]) == nil or L53()[L24.get(L90["config"][1]) + 1] == nil then
        if L132(L24.get(L90["misc"][2]), "config changes") then
            g_notify:add("(error) no config selected", nil, 5)
        end;
        return
    end;
    if readfile(L53()[L24.get(L90["config"][1]) + 1]) == "blank" then
        if L132(L24.get(L90["misc"][2]), "config changes") then
            g_notify:add("(error) '" .. L22.sub(L53()[L24.get(L90["config"][1]) + 1], 1, -16) .. "' anti-aim config is blank", nil, 5)
        end;
        return
    end;
    local L736 = L102(L5.decode(readfile(L53()[L24.get(L90["config"][1]) + 1]), "base64"), "_")
    local L737 = 1;
    for L738, L739 in L9({ L82, L83 }) do
        for L740, L741 in L10(L739) do
            if L739 == L82 then
                for L742 = 0, 16 do
                    if L736[L737] == "true" then
                        L24.set(L739[L740][L742], true)
                    elseif L736[L737] == "false" then
                        L24.set(L739[L740][L742], false)
                    else
                        L24.set(L739[L740][L742], L13(L736[L737]))
                    end;
                    L737 = L737 + 1
                end
            else
                for L743 = 0, 4 do
                    if L736[L737] == "true" then
                        L24.set(L739[L740][L743], true)
                    elseif L736[L737] == "false" then
                        L24.set(L739[L740][L743], false)
                    else
                        L24.set(L739[L740][L743], L13(L736[L737]))
                    end;
                    L737 = L737 + 1
                end
            end
        end
    end;
    if L132(L24.get(L90["misc"][2]), "config changes") then
        g_notify:add("'" .. L22.sub(L53()[L24.get(L90["config"][1]) + 1], 1, -16) .. "' anti-aim config loaded", nil, 5)
    end
end;
local L752 = function()
    local L745 = ""
    for L746, L747 in L9({ L82, L83 }) do
        for L748, L749 in L10(L747) do
            if L747 == L82 then
                for L750 = 0, 16 do
                    L745 = L745 .. L13(L24.get(L747[L748][L750])) .. "_"
                end
            elseif L747 == L83 then
                for L751 = 0, 4 do
                    L745 = L745 .. L13(L24.get(L747[L748][L751])) .. "_"
                end
            end
        end
    end;
    L20.write("current_clip_board_to_save", L5.encode(L745, "base64"))
    read_data = L20.read("current_clip_board_to_save")
    writefile(L53()[L24.get(L90["config"][1]) + 1], read_data)
    if L132(L24.get(L90["misc"][2]), "config changes") then
        g_notify:add("'" .. L22.sub(L53()[L24.get(L90["config"][1]) + 1], 1, -16) .. "' anti-aim config saved", nil, 5)
    end
end;
local L753 = function()
    if L24.get(L90["config"][1]) == nil or L53()[L24.get(L90["config"][1]) + 1] == nil then
        return
    end;
    if L132(L24.get(L90["misc"][2]), "config changes") then
        g_notify:add("'" .. L22.sub(L53()[L24.get(L90["config"][1]) + 1], 1, -16) .. "' anti-aim config deleted", nil, 5)
    end;
    L34.remove_file(L52 .. "/" .. L53()[L24.get(L90["config"][1]) + 1], L53()[L24.get(L90["config"][1]) + 1])
end;
local L756 = function()
    if L80 == nil then
        return
    end;
    for L754, L755 in L10(L84) do
        L24.set(L80[L754][0], false)
        L24.set(L80[L754][1], "off")
        L24.set(L80[L754][2], 0)
        L24.set(L80[L754][3], "local view")
        L24.set(L80[L754][4], "off")
        L24.set(L80[L754][5], 0)
        L24.set(L80[L754][6], "off")
        L24.set(L80[L754][7], 0)
        L24.set(L80[L754][8], "off")
        L24.set(L80[L754][9], 0)
        L24.set(L80[L754][10], false)
        L24.set(L80[L754][11], false)
        L24.set(L80[L754][12], false)
        L24.set(L80[L754][13], 0)
        L24.set(L80[L754][14], false)
        L24.set(L80[L754][15], "off")
        L24.set(L80[L754][16], "off")
    end;
    if L132(L24.get(L90["misc"][2]), "config changes") then
        g_notify:add("anti-aim config reset", nil, 5)
    end
end;
local L765 = function()
    local L757 = L102(L5.decode(L6.get(), "base64"), "_")
    local L758 = 1;
    for L759, L760 in L9({ L82, L83 }) do
        for L761, L762 in L10(L760) do
            if L760 == L82 then
                for L763 = 0, 16 do
                    if L757[L758] == "true" then
                        L24.set(L760[L761][L763], true)
                    elseif L757[L758] == "false" then
                        L24.set(L760[L761][L763], false)
                    else
                        L24.set(L760[L761][L763], L13(L757[L758]))
                    end;
                    L758 = L758 + 1
                end
            else
                for L764 = 0, 4 do
                    if L757[L758] == "true" then
                        L24.set(L760[L761][L764], true)
                    elseif L757[L758] == "false" then
                        L24.set(L760[L761][L764], false)
                    else
                        L24.set(L760[L761][L764], L13(L757[L758]))
                    end;
                    L758 = L758 + 1
                end
            end
        end
    end;
    if L132(L24.get(L90["misc"][2]), "config changes") then
        g_notify:add("imported wraith anti-aim", nil, 5)
    end
end;
local L773 = function()
    local L766 = ""
    for L767, L768 in L9({ L82, L83 }) do
        for L769, L770 in L10(L768) do
            if L768 == L82 then
                for L771 = 0, 16 do
                    L766 = L766 .. L13(L24.get(L768[L769][L771])) .. "_"
                end
            elseif L768 == L83 then
                for L772 = 0, 4 do
                    L766 = L766 .. L13(L24.get(L768[L769][L772])) .. "_"
                end
            end
        end
    end;
    L6.set(L5.encode(L766), "base64")
    if L132(L24.get(L90["misc"][2]), "config changes") then
        g_notify:add("exported wraith anti-aim", nil, 5)
    end
end;
L90["config"][9] = L24.new_button("AA", "Anti-aimbot angles", "create", L735)
L90["config"][3] = L24.new_button("AA", "Anti-aimbot angles", "load", L744)
L90["config"][4] = L24.new_button("AA", "Anti-aimbot angles", "save", L752)
L90["config"][5] = L24.new_button("AA", "Anti-aimbot angles", "delete", L753)
L90["config"][6] = L24.new_button("AA", "Anti-aimbot angles", "reset", L756)
L90["config"][7] = L24.new_button("AA", "Anti-aimbot angles", "import from clipboard", L765)
L90["config"][8] = L24.new_button("AA", "Anti-aimbot angles", "export to clipboard", L773)
local L777 = function()
    L148()
    L154(false)
    L24.set_visible(L127.plist.force_body, true)
    L24.set_visible(L127.plist.force_body_value, true)
    local L774 = L27.get_players(true)
    if #L774 == 0 then
        return nil
    end;
    for L775, L776 in L9(L774) do
        L18.set(L776, "Force body yaw", false)
        L18.set(L776, "Force body yaw value", 0)
    end
end;
local L781 = function(L778)
    local L779 = L24.get(L778)
    local L780 = L779 and L28.set_event_callback or L28.unset_event_callback;
    L780("paint", L460)
    L780("pre_render", L493)
    L780("run_command", L498)
    L780("predict_command", L501)
    L780("setup_command", L619)
    L780("net_update_start", L629)
    L780("net_update_end", L674)
    L780("dormant_hit", L521)
    L780("dormant_miss", L523)
    L780("round_prestart", L506)
    L780("aim_fire", L512)
    L780("player_hurt", L518)
    L780("aim_miss", L520)
    L780("player_death", L441)
    L780("bomb_defused", function()
        L70.bomb_defused = true
    end)
    L780("bomb_exploded", function()
        L70.bomb_exploded = true
    end)
    L780("cs_match_end_restart", reset)
    L780("cs_game_disconnected", reset)
    L780("client_disconnect", reset)
    L780("player_connect_full", reset)
    L780("game_newmap", reset)
end;
L24.set_callback(L76, L781)
L781(L76)
L28.set_event_callback("paint_ui", L734)
L28.set_event_callback("shutdown", L777)
cvar.cl_use_opens_buy_menu:set_int(0)
cvar.cl_autowepswitch:set_int(0)