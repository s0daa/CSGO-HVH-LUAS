--OG LEAKS BEST, https://discord.gg/og4leaks
_DEBUG = true

local ffi = require("ffi")
ffi.cdef[[
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);

    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_t;
 
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);
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
        char         pad1[0x4]; // 0x94
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

]]


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

local menu = {}
local helpers = {}
local antiaim = {}
local anti_bruteforce = {}
local ragebot = {}
local anitaim_condition = {}
local animations = {anim_list = {}}
local miscellaneous = {stuff = {}}
local ffi_handler = {}

local menu_items = {items = {}; visibler = {}}
menu_items.run_update = function() for name, m_table in pairs(menu_items.visibler) do m_table.ref:visibility(m_table.condition()) end end
menu_items.new = function(name, item, conditions) if menu_items.items[name] ~= nil then error("item already have") return end menu_items.items[name] = item if type(conditions) == "function" then menu_items.visibler[name] = { ref = item, condition = conditions } end item:set_callback(menu_items.run_update) return item end

local png = ui.create("Info", "`melancholia.ws - premium script [DEV]")
local welcoming = ui.create("Info", "General")
local cfgsys = ui.create("Info", "Config System")
local dsserver = ui.create("Info", "Discord Server")
local premiumtick = ui.create("Premium", "Le Ideal Ticke")
local premiumhc = ui.create("Premium", "Hitchance")
local premiumfov = ui.create("Premium", "Adaptive Silent Aimbot")
local premiumas = ui.create("Premium", "Air Autostop Fix")
local rbot = ui.create("Rage-Bot", "Rage-Bot")
local antihit = ui.create("Anti-Hit", "Anti-Hit")
local antihitbuilder = ui.create("Anti-Hit", "Builder")
local antihitantibrute = ui.create("Anti-Hit", "Anti-Brute")
local visuals = ui.create("Visuals", "Visuals")
local visualsclr = ui.create("Visuals", "Color")
local misctabgg = ui.create("Misc", "MISCellaneous")
local tttab = ui.create("Misc", "Killsay Settings")
local artab = ui.create("Misc", "Aspect Ratio Settings")
local vmtab = ui.create("Misc", "Viewmodel Settings")
local logstab = ui.create("Misc", "Logs Settings")

png:texture(render.load_image(network.get("https://media.discordapp.net/attachments/1046104989883433081/1085683761561206814/1.gif"), vector(250, 280)), vector(250, 280), color(255, 255, 255, 255), 'f')
welcoming:label("Welcome, \aA9ACFFFF"..common.get_username()..'\a89A4B5FF!')
welcoming:label("Melancholia nl v3.3 ready")
welcoming:label("Fixed by OG LEAKS")
local export_cfg = cfgsys:button("       Export Config       ")
local import_cfg = cfgsys:button("       Import Config       ")
local defcfg = cfgsys:button("                       Load Default Config                         ")
--requires
local screen_size = render.screen_size()
local clipboard = require("neverlose/clipboard")
local base64 = require("neverlose/base64")
local devalpha = 355
local alphastate = 0
local aastate = 1
local preset1 = "Smart"
animations.math_clamp = function(value, min, max) return math.min(max, math.max(min, value)) end
animations.math_lerp = function(a, b_, t) local t = animations.math_clamp(globals.frametime * (0.045 * 175), 0, 1) if type(a) == 'userdata' then r, g, b, a = a.r, a.g, a.b, a.a e_r, e_g, e_b, e_a = b_.r, b_.g, b_.b, b_.a r = animations.math_lerp(r, e_r, t) g = animations.math_lerp(g, e_g, t) b = animations.math_lerp(b, e_b, t) a = animations.math_lerp(a, e_a, t) return color(r, g, b, a) end local d = b_ - a d = d * t d = d + a if b_ == 0 and d < 0.01 and d > -0.01 then d = 0 elseif b_ == 1 and d < 1.01 and d > 0.99 then d = 1 end return d end
animations.anim_new = function(name, new, remove, speed) if not animations.anim_list[name] then animations.anim_list[name] = {} animations.anim_list[name].color = color(0, 0, 0, 0) animations.anim_list[name].number = 0 animations.anim_list[name].call_frame = true end if remove == nil then animations.anim_list[name].call_frame = true end if speed == nil then speed = 0.010 end if type(new) == 'userdata' then lerp = animations.math_lerp(animations.anim_list[name].color, new, speed) animations.anim_list[name].color = lerp return lerp end lerp = animations.math_lerp(animations.anim_list[name].number, new, speed) animations.anim_list[name].number = lerp return lerp end
animations.vector_lerp = function(vecSource, vecDestination, flPercentage) return vecSource + (vecDestination - vecSource) * flPercentage end
animations.anim_get = function(name) return animations.anim_list[name] == nil and {number = 0, color = color(255, 255, 255, 0), call_frame = false} or animations.anim_list[name] end
animations.anim_upd = function() for k, v in pairs(animations.anim_list) do if not animations.anim_list[k].call_frame then if type(animations.anim_get(k).number) == 'userdata' then if animations.same_colors(animations.anim_new(k, color(0, 0, 0, 0), true), color(0, 0, 0, 0)) then animations.anim_list[k] = nil end else if animations.anim_new(k, 0, true) == 0 then animations.anim_list[k] = nil end end goto skip end animations.anim_list[k].call_frame = false ::skip:: end end
local currentar
local watermark_alpha = 0
local fpsss = (globals.is_connected and (1 / globals.frametime) or 0)
local pingg = (globals.is_connected and (utils.net_channel().latency[1] * 1000) or 0)
local watermark_info_time = 0
local watermark_info = ('v1.4.2 | %s | [DEV]'):format(common.get_date("%H:%M:%S"))
local watermark_info_y = 0
local add_y = 0
dragging_fn = function(name, base_x, base_y) return (function() local a = {} local b, c, d, e, f, g, h, i, j, k, l, m, n, o local p = {__index = {drag = function(self, ...)  q, r = self:get()  s, t = a.drag(q, r, ...) if q ~= s or r ~= t then     self:set(s, t) end return s, t end, set = function(self, q, r)  j, k = render.screen_size().x, render.screen_size().y self.x_reference:set(math.floor(q / j * self.res)) self.y_reference:set(math.floor(r / k * self.res)) end, get = function(self)  j, k = render.screen_size().x, render.screen_size().y return self.x_reference:get() / self.res * j, self.y_reference:get() / self.res * k end}} function a.new(u, v, w, x) x = x or 10000  j, k = render.screen_size().x, render.screen_size().y  y = visuals:slider(u .. ' window position x', 0, math.floor(x), math.floor(v / j * x))  z = visuals:slider(u .. ' window position y', 0, math.floor(x), math.floor(w / k * x)) y:visibility(false) z:visibility(false) return setmetatable({name = u, x_reference = y, y_reference = z, res = x}, p) end      function a.drag(q, r, A, B, C, D, E) if globals.framecount ~= b then c = (ui.get_alpha() > 0 and true or false) f, g = d, e d, e = ui.get_mouse_position().x, ui.get_mouse_position().y i = h h = common.is_button_down(1) m = l l = {} o = n n = false j, k = render.screen_size().x, render.screen_size().y end if c and i ~= nil then if (not i or o) and h and f > q and g > r and f < q + A and g < r + B then n = true q, r = q + d - f, r + e - g if not D then q = math.max(0, math.min(j - A, q)) r = math.max(0, math.min(k - B, r)) end end end table.insert(l, {q, r, A, B}) return q, r, A, B end return a end)().new(name, base_x, base_y) end
dragging_k = dragging_fn('Keybinds', math.floor(screen_size.x - screen_size.x * cvar.safezonex:float() / 1.385), math.floor(screen_size.y * cvar.safezoney:float() / 2.5))
getbinds = function() binds = {} cheatbinds = ui.get_binds() for i = 1, #cheatbinds do table.insert(binds, 1, cheatbinds[i]) end return binds end
local data_k = {
    [''] = {alpha_k = 0}
}
width_k = 0
alpha_k = 0
width_ka = 0
local info_alpha = 0
function state() if not entity.get_local_player() then  return  end  local flags = entity.get_local_player().m_fFlags  local first_velocity = entity.get_local_player()['m_vecVelocity[0]']  local second_velocity = entity.get_local_player()['m_vecVelocity[1]']  local velocity = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))  if bit.band(flags, 1) == 1 then  if bit.band(flags, 4) == 4 then  return "Crouching" else  if velocity <= 3 then  return "Standing" else  if ui.find("Aimbot", "Anti Aim", "MISC", "Slow Walk"):get() then   return "Slowwalking" else  return "Moving" end  end  end  elseif bit.band(flags, 1) == 0 then  if bit.band(flags, 4) == 4 then  return "Air+Duck" else  return "Air" end  end  end
function statetext() if not entity.get_local_player() then return "Dead" end local flags = entity.get_local_player().m_fFlags local first_velocity = entity.get_local_player()['m_vecVelocity[0]'] local second_velocity = entity.get_local_player()['m_vecVelocity[1]'] local velocity = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity)) if bit.band(flags, 1) == 1 then if bit.band(flags, 4) == 4 then return "Crouching" else if velocity <= 3 then return "Standing" else if ui.find("Aimbot", "Anti Aim", "MISC", "Slow Walk"):get() then  return "Slowwalking" else return "Moving" end end end elseif bit.band(flags, 1) == 0 then if bit.band(flags, 4) == 4 then return "Air+Duck" else return "Air" end end end
local statepanel_images = {
Standing = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x30\x00\x00\x00\x30\x08\x06\x00\x00\x00\x57\x02\xF9\x87\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x16\x25\x00\x00\x16\x25\x01\x49\x52\x24\xF0\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x02\x42\x49\x44\x41\x54\x78\x01\xED\x98\x4F\x4E\xDB\x40\x14\xC6\xBF\x37\xA1\x59\x55\x55\x6E\x50\xF7\x04\xE5\x06\x84\x1B\x94\x8A\xAE\xC1\xAB\xA8\xDD\x50\x4E\x50\x8E\x00\xAB\x08\xA9\xD2\xB4\x52\x57\xFD\x23\x56\x5D\x37\x37\x28\xBD\xC1\xF4\x06\x6E\x91\x10\x7F\x92\x79\x8C\x31\x81\xD8\x42\x61\x66\xFC\xC0\x80\xFC\xDB\x44\x49\x9E\x67\xE6\xB3\xC7\x9F\xBF\x67\xA0\xA5\x59\x08\xC2\x68\xBD\xD7\x3B\xC1\xF8\x3D\x11\x2D\x31\xA3\x5F\x4C\xC2\xFB\xAC\x3A\xDB\x83\xB5\xD7\x9F\x21\x8C\xA8\x80\xA1\xDE\x4B\x14\xEC\x2F\x80\x93\xEB\x2B\xC8\x58\xA8\xE5\xB7\xE9\x8A\x81\x10\x0A\x82\xCC\x5F\x7C\x0E\x9F\x0B\xD4\x5A\xF7\x20\x36\xA7\x10\x43\xFD\x63\x7D\xFE\xE2\xA7\x70\x72\xA2\x9E\x6D\x40\x08\x31\x01\x1D\xB0\xF7\xA2\xC8\x72\x1F\x42\x88\x09\x60\x60\x31\xA0\xB6\x0F\x21\x44\xEF\x81\x26\x10\x13\xE0\xEC\x6C\xE4\x5F\xCD\xFB\x10\x42\x6E\x0B\x29\x1A\x79\x17\x2B\xDA\x86\x10\x62\x02\xBA\x56\xED\xB8\x0F\xE3\x51\x6A\x06\x6B\xAB\x62\x0F\x34\x31\x01\x69\xBA\x92\x59\x9C\x2E\x63\xBE\x08\x73\x51\x23\x86\x78\x94\xC8\x19\xEA\xAF\xEB\x0A\x2A\xB7\xD5\x73\x67\x72\xAE\x33\x22\xD0\xA8\x8B\xFF\x3B\x69\x9A\x66\x68\x79\x44\xD4\xDA\x42\xBB\xFA\xFB\x2B\x22\x6C\x4C\x53\x67\xF8\xE4\xF5\x53\x6A\xB4\x80\x5D\xFD\x6D\xCB\x1D\xFE\x01\x02\x4C\xC0\x9B\xEF\xD2\x37\x51\xD6\x1A\x25\xA0\xC8\xFC\xF6\xB7\x5F\x78\xF3\x22\xEB\xE2\xE0\x45\xCC\x0D\x1E\x65\xA3\x47\x18\x2F\x0A\x2E\x3E\xA7\x77\xAC\x9E\x2E\x21\x82\x28\x01\xA4\x16\x5E\x96\x7F\xE0\xE0\xCB\xCF\x44\x9F\x2A\xA3\x26\x88\x20\x4E\x00\xDB\x04\xE5\xC5\x18\x84\x42\xAA\x9C\x87\x2C\x79\xA7\xD9\x59\xE2\x04\x80\x4B\x93\xA9\xEA\x62\x7C\xC6\xB0\x93\xBF\xE5\x31\xED\xDD\x09\x60\x2E\x9F\xAD\x27\x93\x7F\x7F\x10\x88\x45\xA7\x22\x9A\x12\x44\x10\x2C\x20\x77\x20\x27\x61\xB6\xA7\xCD\x62\xDC\xA3\x68\xEC\x69\xF6\xB8\xDE\xC7\x2F\x3F\x9F\x23\x90\x60\x01\x85\x03\x5D\xE1\x72\x4E\x74\xB6\x77\x5B\xD1\xCC\x7E\x1F\x4F\x0E\x83\xB7\x51\xB0\x80\xAA\x03\x11\xC5\x37\x27\x96\xA8\xF6\x36\x0A\x17\x20\xE1\x40\x97\x83\xD5\x77\xA2\x70\x01\x02\x0E\x74\x39\x96\x80\x13\x05\x0B\x90\x70\xA0\x29\x12\x4E\x54\xB7\x23\x33\x75\x1A\x94\x6B\x9C\xE8\xF6\xB3\x90\x05\x36\x51\xB4\x8D\x99\xEB\xE4\xB7\x50\x93\xBA\xE3\x89\xB5\x94\xAE\x37\xE0\x90\xFA\x41\xBA\x2A\x32\xF7\x83\x7F\xB1\xB5\x80\x5B\xA2\x7A\x86\x43\xAF\x90\x2F\xED\xAB\xC5\xA6\x69\x05\x34\x4D\x2B\xA0\x69\x5A\x01\x4D\xD3\x0A\xB8\xA2\x94\x2A\x4D\xF8\xFF\x71\x88\x09\xB8\x29\x55\x4A\xA7\xD8\x96\xFB\xC2\x19\x8C\xC4\xCA\xC7\xD3\xA6\xEB\xBE\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(16, 14)),
Moving = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x30\x00\x00\x00\x30\x08\x06\x00\x00\x00\x57\x02\xF9\x87\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x16\x25\x00\x00\x16\x25\x01\x49\x52\x24\xF0\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x03\xFF\x49\x44\x41\x54\x78\x01\xED\x99\x4D\x72\x12\x41\x14\x80\x5F\xF7\x90\xB8\x32\xE2\x0D\xF0\x04\xC6\x13\x48\xD6\x2E\xCC\x0F\xB1\xCA\x2A\x15\x26\x65\x49\xD0\x85\xE4\x04\xC0\x09\x84\x85\xA6\x92\x85\x43\x56\x56\x99\xC4\xC4\x13\x84\x9C\x20\x78\x82\x8C\x27\x90\x72\x09\x99\x79\x76\x33\x60\xE6\x8F\xEE\x9E\xA1\x81\x4D\xBE\x0D\x45\xCF\x9B\xA6\x5F\xF7\xEB\xF7\x07\xC0\x1D\x8B\x85\xC0\x82\xB0\xAC\xB3\x6C\x1F\x6E\xAA\x84\x90\xA7\x88\x90\xF7\x16\x83\x5D\xA4\x46\xB3\x5C\xDC\x3C\x52\x9D\x67\x21\x0A\xEC\x5B\x67\x39\x0A\xEE\x05\x00\xE6\xE2\x25\x88\xED\x02\x5D\xAB\x98\x1B\xB6\x64\x2A\xA0\xB0\x00\xC4\x8B\xE7\xE0\x50\x41\xCB\xB2\xB2\x20\x9D\x6B\xCE\xEC\x5B\xA7\x25\xF1\xE2\xC7\x60\xAE\x4F\x57\x3E\xCA\xA4\xE6\xAE\x80\x01\x28\x5D\xD4\x18\xE2\x62\x5E\x26\x33\x77\x05\x10\x60\x35\x81\x6C\x5E\x26\xB3\x90\x3B\xA0\x93\xB9\x2B\xC0\xDC\x5E\x47\x5D\x1A\xBB\x32\x89\xF9\x9B\x10\x25\x1D\x65\x61\x4A\x9A\x52\x11\x98\x33\xCB\x2E\x6D\xB1\x0F\x5B\x41\xD4\x2E\x17\x0B\xD2\x80\x36\x55\x20\xE3\x01\xC9\x20\x6E\x8D\x45\xD2\x75\xB6\xB7\x93\x7C\x76\xCF\x01\x6C\xBC\x37\xB7\x9B\xB7\xEF\x7D\x63\x7E\x7E\x89\xC5\x02\xC8\x4D\x78\x87\x05\xB2\x01\x0B\x64\x2F\x6D\x90\x90\x5A\x01\x79\x34\x8D\xFC\x54\x73\x19\xFE\x36\x4C\xD3\xEC\xDD\xCE\xF1\xBD\x44\x81\x72\xB7\x3A\xF4\x4C\xCC\xEB\x74\x08\x90\x0E\x93\x6B\xF9\xE5\x84\xB3\x42\x4A\x0E\xDB\xA7\x16\x22\x96\x20\x11\xEA\x29\x82\x2A\xA9\xEE\xC0\x67\xEB\x6C\x35\xF9\xE2\x39\x3C\x45\x70\xAE\xBE\x58\xC7\x55\xD0\x44\xAA\x13\x38\xB0\x4E\xAF\x43\xA6\x63\x97\xCD\xC2\x23\xBF\x0C\x4F\x19\x28\xA0\x35\x79\x96\xA8\x49\xA5\x21\xF1\x09\xB0\xC5\x57\xC3\x76\x8F\x19\xBA\x1E\x33\x71\x0D\x84\x60\xB5\x0F\x2B\x57\xFC\x2E\xC1\x14\xA4\x31\xA1\x40\x2E\xC3\x2E\x5E\x7B\xF7\xF5\xE6\x2F\xFF\x58\x92\x84\x8D\x9B\xD4\xC1\xD7\x1F\x45\x48\x49\x1A\x05\xFC\xEE\xD2\x46\x18\x34\xFC\x0F\x3D\xEF\x24\xDB\xFD\xD0\x7C\xC4\x6D\xA6\x3D\x89\x0C\x24\xC4\x05\xD8\x1B\x2D\x30\xCB\xC2\x6A\xBD\xB2\x13\xF4\xD5\x14\x6E\x4A\xCC\xBE\x73\x90\x8C\xAC\x01\x0E\xBF\x2F\x6B\xE1\x07\x9E\xC9\x0E\x7F\xAF\x07\x48\xEA\xE5\x9D\x60\xB5\xA6\xB5\x22\x1B\xC5\x86\x2B\x41\x50\x13\xC2\x02\xDE\xDE\x38\xE0\x79\x41\xD2\xB1\xC6\xE5\xE6\x88\x1E\x73\x16\x0F\xFD\xEF\x24\x3E\x01\x11\x5E\x54\x56\x5D\x3C\xA9\xB3\x1A\x38\xEF\x4F\x99\x0D\x20\x35\xB6\xF0\x73\xB6\x09\xCC\x29\x0C\x23\x7C\x78\xAE\x88\xC7\xD2\xA6\x00\xDF\x31\x44\xA7\xA4\x28\xCE\x02\x5A\x9F\x9B\xC2\x11\x85\x65\xFF\x89\x65\x05\x27\xD8\xE3\x26\x1B\x1E\xD4\x96\xCC\xF1\xDD\x57\x16\xA6\x50\xE7\x79\x8E\x97\xEB\xB8\x8D\xE0\xC3\xE8\xE2\x79\x8A\xC1\x72\xA3\x27\x61\xFB\xE7\x68\xB9\x03\x9E\xED\x3B\xD7\x8A\xE2\x91\xA0\x77\x68\x9D\x5C\x4C\xA8\xBE\x7A\x6C\xBC\xBE\x6B\x16\x5A\x93\x26\xD3\x72\x02\xFC\xB2\xA9\xCA\xF2\x2C\x33\x3C\xB6\x04\xC6\x06\x21\xD0\xF6\x8F\x8D\x77\x5D\xB4\x78\x8E\x96\x13\x60\xAE\xEE\x8F\x8A\xE7\x19\x06\x3D\xB3\x60\x4E\x7A\xCE\xDB\x28\x03\xE3\xC1\x63\x4A\xEF\xD9\x6F\x5F\x3D\xFB\x0D\x0A\x4C\xAD\x80\x3C\xE7\xF9\x8F\x72\x8E\x9F\x84\xA9\x4D\x28\xDC\x26\x61\x3B\xC2\xEA\x58\x12\x97\xA0\xB1\x7B\x92\x29\x81\x66\xA6\xAC\xC8\x8E\xF3\x14\xC8\x85\x7F\x8C\xED\xF2\xF0\x82\x4E\xAE\xB8\xF4\xD6\x04\x53\x9D\x80\x41\x68\x20\x09\xE3\x36\x3E\x76\x8F\x9E\xA7\x21\xF5\xE8\x5B\xEA\x6D\x43\x15\x52\x2B\xE0\x05\xAE\x60\x51\x43\x0D\xDA\xF6\x7F\x2F\x9B\x5B\x0D\x17\x90\x7B\x1D\x3B\xF8\x36\x6F\x1B\xDE\x7F\x0E\x1A\x48\xAD\x40\x34\x70\x61\xF7\xDD\x9B\xCD\xCB\xB0\x5C\xC5\xDC\xE6\xEE\x70\x2D\xDA\x0F\x22\x39\xD0\x40\x2A\x05\xE2\x76\x5F\xD4\xC3\x19\x79\x9E\x80\xC9\x20\xE0\x54\x95\xD8\x98\x4C\x74\x71\xDC\x2D\xC2\x27\xB1\x5F\x77\xC2\x03\xC2\x1E\xCE\x21\xAF\xA1\xC1\x09\xF4\x44\xD1\x1D\xFC\x04\x0D\xD0\x98\x81\x5A\xE2\x74\x98\xE5\x36\xC2\xE7\xC4\x0D\x57\x71\xE7\xBA\xE2\x41\x9C\x09\x25\xF5\x0E\xC2\xDD\x8F\x37\x37\x6C\x83\x26\x22\x0A\xF0\x8A\x0B\xD4\x5A\x7F\x23\xF0\x5C\xFC\xDC\xCD\x87\x06\xEC\xDD\xE2\xB6\x16\xF3\xE1\x44\xEE\x40\xC5\xDC\x6A\xB3\x8F\x36\x68\x22\x52\x1F\xCB\xCC\x2D\xF9\xFC\xB3\xE3\xC0\x3A\x59\x0F\x77\x27\x5C\x77\x70\x09\x1A\x99\x6D\x77\x9A\x90\xD8\x48\x0D\x1A\x99\x99\x02\xC3\x36\x09\x62\xA0\xE1\xE5\x80\xDB\x02\xCD\xCC\x4C\x81\xB8\x48\xFD\xC1\x7C\x21\xFD\xC7\x25\x29\x33\x53\x20\xD4\x0E\x51\xFA\xB7\x25\x0D\xB3\xBC\x03\x81\x0E\x9E\xCA\xBF\x2D\x69\x98\x99\x02\xBE\x78\x12\xDB\x0E\xB9\x63\xC4\x3F\xC6\x77\xA4\xE6\x62\xE6\x03\xD9\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(16, 14)),
Slowwalking = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x30\x00\x00\x00\x30\x08\x06\x00\x00\x00\x57\x02\xF9\x87\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x16\x25\x00\x00\x16\x25\x01\x49\x52\x24\xF0\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x04\x15\x49\x44\x41\x54\x78\x01\xED\x59\x5D\x92\xD3\x46\x10\xFE\x7A\xEC\xF5\x5B\x92\xCD\x09\xD0\x0D\xE2\x9C\x20\xDE\x1B\xB0\x0B\xA4\x2A\x2F\xD9\x55\x5E\x5C\x5B\x3C\xB0\x9C\x00\xFB\x04\x98\x87\xD4\xD6\xF2\x10\x39\xAF\x01\x62\x72\x82\x78\x4F\x80\x73\x82\x28\x37\x50\x28\x1E\xA8\x45\x9A\xA6\x47\x62\xB1\xAC\x7F\x59\x63\xA0\x0A\xBE\x2A\x97\xAC\x99\xB6\x34\x5F\x4F\x77\x4F\x77\x1B\xF8\x82\x8F\x0B\x82\x65\x78\xDE\x62\xFF\x0A\xE1\x19\x11\xFD\xC0\x8C\x51\xF2\x12\x5E\xB1\xEA\xCD\xC6\xC7\x47\xBF\xC3\x32\xAC\x12\x38\xF7\x16\x8E\x82\xFE\x1B\x60\xA7\x58\x82\x7C\x0D\x75\x70\xEA\x1E\xFA\xB0\x04\x05\x8B\xA8\x5E\xBC\x01\xC7\x04\x3D\xCF\xDB\x87\xB5\x77\x5A\xC2\xB9\xF7\xEC\xA4\x7A\xF1\xD7\x60\xE7\x4A\x7D\x7D\x0F\x96\x60\x8D\x40\x0F\xDC\x78\x51\xA4\x79\x04\x4B\xB0\x46\x80\x81\x61\x0B\xD9\x11\x2C\xC1\xAA\x0F\x7C\x0C\x58\x23\x20\xE1\x6C\xD9\x5C\x9A\x57\xB0\x04\x7B\x26\xA4\x68\xD9\x58\x58\xD1\x0C\x96\x60\x8D\xC0\x40\xAB\x47\x72\xF1\x1B\x88\xFA\xE3\xE3\xDB\xD6\x0E\x34\x6B\x04\x5C\xF7\x30\xD0\x78\x73\x80\x6A\x12\xFE\x3B\x19\x6B\xB0\x9E\x4A\x18\x9C\x7B\x7F\x9C\x28\x28\x13\x56\xE3\xC8\x24\x51\x67\x49\xA0\xE5\x00\x2F\x1F\xB9\xAE\x1B\xE0\x0B\xD6\xD8\x6A\x07\x4C\xC2\xF6\x1A\x90\x74\x20\x74\xCC\xC9\x4A\x6A\xEF\x1B\x62\xED\x88\xA6\xF7\x95\xDC\xCB\xD5\x21\x66\x31\x29\xB5\x62\xA8\xA9\xCD\xDC\x27\x8B\x56\x04\x2E\xBC\x27\x13\xC4\xA6\xC1\x6D\x72\x99\x20\x84\x3E\xB8\xEB\xFE\x68\x2D\x74\xA6\xD1\x98\x40\x7D\xA6\x59\xF9\x1A\x5F\xEC\xFF\xFB\x5D\xD8\x7F\xE3\x28\xA4\x10\x9E\x6C\xB7\x78\x03\x49\xE0\xF0\x95\x87\x1D\xA0\xD1\x0E\x94\x68\xDF\xE7\x38\x64\x92\x4F\xA4\x83\x58\x17\xCC\x67\xD5\x4F\xE2\xE9\xD8\xBD\x33\x81\x45\x34\x22\x90\xD8\x3E\x3D\x48\x0D\xC5\xF1\xFC\xD4\xFD\xC9\x5F\xCB\x3C\xBD\x29\x97\x45\xDD\xB3\x34\x58\x7E\x77\x67\x09\x4B\xA8\x35\x21\xA3\x7D\x11\x3B\xDE\x1C\xA5\x79\x7A\xF1\xC9\x93\xE8\x3B\x34\x7A\x21\x2D\x92\x67\xDA\x81\xAA\x17\xC8\xD9\xBE\x68\xFF\x2A\x9F\x0A\x70\x59\x3A\x4D\xCF\x33\x03\xFB\x3D\x84\xB5\x3B\xD5\x14\x95\x04\x1A\x6B\xDF\x8C\x72\xB1\x83\x53\xCF\x24\x6E\x34\x49\x8F\x31\x68\x78\xE1\x3D\x7B\x08\x0B\xE8\x57\x4D\x26\xDA\x27\x27\x35\x54\xA8\xFD\xA4\x13\x11\x15\xEE\xC0\x5E\xF4\xFF\x3F\x12\x3E\x2F\x65\xC1\x32\xCF\x37\xD7\x33\x7C\xF6\x78\xFE\x74\x28\x64\x56\xE0\xF0\x32\x94\x60\xB0\xCD\x59\x51\x63\x42\xCD\xB4\xFF\x1A\x61\x89\xF9\xF0\xEA\x3A\xF6\x0F\xA0\x5C\x64\x12\xBD\xB8\xED\x12\x47\xAE\xDE\xA2\x0F\xF5\x42\x48\xFE\x7B\xF1\xDB\x9F\xC7\x68\x81\x3A\x1F\x48\x9F\xB8\xC5\xB6\x2F\x20\xD5\x2F\x74\x60\xD1\xAE\x7F\xFD\xDD\x64\xAB\x21\x7A\x87\x22\x5D\x71\x98\x89\x19\x92\x6E\x55\x2B\x54\x12\xD0\xC0\x7D\x24\x5A\x0B\xA4\x62\x99\x14\x69\xDF\xC0\xE4\x41\x85\xE3\x8A\x36\x4C\xE2\xAE\x7B\x28\xF7\x7A\x1A\x3F\xAF\x1C\xAD\x4E\xEB\x4A\x1F\x38\x75\x6F\xCD\xE5\x32\x47\x0D\xA4\xF3\x26\xB6\x9C\x07\x43\xE7\x6C\x5A\x0E\x32\xA3\xE1\xD9\xAF\xDE\x62\x38\x50\x7C\x43\x73\x34\x62\xA6\x21\x5D\x37\x05\x44\x51\x68\x81\x3E\x2C\xC0\x2C\x20\xCE\xFA\x33\x88\x34\xFF\x57\xF6\x9B\x64\x37\x60\x3E\x7F\xA1\x03\x3A\x57\x64\x8F\x45\x93\x65\xD9\x69\x9F\xFB\x8D\x0E\xB7\x2E\xE8\x4C\x80\x11\x39\xA5\x93\xA4\xE7\x6D\xA3\x4A\x5B\x74\xAF\x89\xA5\x0B\x5D\x3D\xBF\x5B\x12\x9D\x09\x18\x07\xCE\x0C\x3D\xCF\x0B\xED\x8E\x44\x77\x13\x8A\x1D\x78\x0D\xA9\xBE\xA6\x1A\xE4\xE6\x04\x77\x44\xA2\x53\x57\xC2\x38\xB0\xF8\xC0\x8B\xD4\x50\x30\x76\x6F\x7F\x6B\xBE\x98\x6E\xB5\xD4\xC7\xF9\x22\x86\xD5\xC9\xF8\x97\xA3\x4F\xA3\x2F\x94\x75\x60\x4E\xC2\x62\x0C\x73\x86\x94\xED\xC4\xA7\xF3\xFF\x40\xC6\x81\x89\x36\x7B\x9E\x25\x24\x02\x9B\xB5\x71\x27\x02\xE2\xC0\xA3\xF4\x3D\x53\x51\x83\x57\xFB\x9B\xF7\xEC\xC3\x22\xB6\x3A\x89\xCF\xBD\x27\x23\xE9\xBC\x79\x9C\xA9\x01\x8A\x4E\x5E\xA9\xC0\x36\xCC\x85\x2B\x93\xB9\xF6\x68\x45\xC0\xE4\x2F\x7B\x14\x3D\x4C\xFE\x7D\xCC\xA5\x0E\x41\x51\x3E\x2F\xFF\x4E\xDE\x20\x1D\xBD\xBF\xCF\x9A\x59\x57\x34\x22\x60\x0A\x96\x37\x88\x26\xE2\xB4\xF7\x98\x0B\x45\x02\x19\x9E\x14\x4D\x64\x33\x55\xA6\x75\x8A\x6D\x03\xB5\x04\x4C\x38\xBC\x82\x36\xE5\x5F\x49\xE4\xE0\xD9\x00\xAF\xA6\x65\x8E\x99\xCF\x54\x3F\xB0\x0F\x88\x97\x3F\x28\x4A\xD6\x4C\xC7\x39\x82\xBE\x5F\x5B\x06\xF2\x26\x71\x45\xBD\x0F\xEE\x03\xD9\xC5\xFB\xD4\x93\xC3\xE8\xE7\xA3\x4B\x34\x80\x38\xAD\x93\xF6\x17\x53\x23\xC3\x22\x6A\x09\x98\xAA\x2C\xD9\x05\x43\x84\x66\x63\xF7\xD6\x14\xDB\xC3\xB7\xDD\x1F\xAD\x25\xD0\xB4\x2A\x2B\xC3\x86\x02\x5A\x56\x5B\x9F\x05\xDE\x02\xDD\x18\xB3\xD1\x24\x70\xD0\xB9\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(16, 14)),
Air = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x30\x00\x00\x00\x30\x08\x06\x00\x00\x00\x57\x02\xF9\x87\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x16\x25\x00\x00\x16\x25\x01\x49\x52\x24\xF0\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x04\x0A\x49\x44\x41\x54\x78\x01\xED\x59\x41\x72\xD3\x48\x14\x7D\xBF\x95\xC9\xCC\x8A\x61\x6E\xE0\xB9\x01\x39\xC1\x38\x27\x20\x99\x84\xA9\x9A\xCD\xD8\x9A\x8D\x13\x58\xE0\x9C\x20\xC9\x09\x70\x16\xE0\x0A\x0B\x5A\xAC\xA8\x82\x80\x73\x83\x98\x13\x60\x4E\x80\x38\x01\x2E\xD8\x25\x71\x37\xBF\xA5\x98\xD8\x8A\x64\x75\xCB\x92\x53\x54\xF9\x6D\x64\x4B\xDF\xDD\xFD\xD5\xEF\xFF\xFF\xFA\x1B\x58\xE2\x76\x41\x58\x10\xA4\xEC\xDD\x3D\xC7\x65\x9B\x88\xFE\xD2\x1A\xF5\x78\x72\x3D\xD0\xC2\xEB\xB4\x1A\x7F\xBF\x44\x41\x2C\xC4\x81\xAE\xEC\xD5\x04\xD4\x19\xA0\x6B\xE9\x16\x14\x2A\x88\xF5\x5D\x7F\x33\x84\x23\x04\x16\x80\xD9\x8B\x37\xD0\x91\x83\x52\xCA\xBB\x70\x1E\xBB\x62\x74\xE5\xDB\xE6\xEC\xC5\x8F\xA1\x6B\xE7\xE2\xCE\x63\x38\xA2\x72\x07\x3C\x68\xEB\x45\x91\xD2\x75\x38\xA2\x72\x07\x34\x70\xCF\xC1\xB6\x0E\x47\x2C\x24\x06\xAA\x44\xE5\x0E\x70\x9A\xEB\xDB\x5B\xEB\x01\x1C\x51\x3D\x85\x04\xF5\xAD\x8D\x05\x75\xE0\x88\xCA\x1D\x58\x55\xE2\x88\x2F\xA1\x85\x69\xD8\x6A\x6C\x3B\x17\xB4\xCA\x1D\xF0\xFD\xCD\xA1\xC2\xC5\x3A\x66\x3B\x11\x5E\xD9\x38\xA3\x50\x25\x3E\x96\x6F\xDB\x7C\xD9\x8F\x07\x50\xA1\x26\x0A\x41\x34\x50\x6A\xF4\xD9\x54\xD5\xDF\xB0\x32\x30\x0B\x4F\xFE\xAE\x2B\x5F\x37\x05\x84\x49\xAB\x51\x66\xE2\xAC\xD3\x27\x50\x7F\x15\x5F\x8F\x7C\xDF\x1F\xA2\x00\x9C\x1D\x78\x2E\x4F\x3A\x3C\xB1\x45\x6E\xA7\x21\x48\xF7\x35\x79\xFD\x91\xBA\x78\xFF\xC8\xFF\xC7\x39\x40\x6D\x60\xED\x80\xD1\x33\x1E\x8D\xE4\x58\x88\x15\x98\xAA\x12\x87\xAC\x1C\x78\x2A\x7B\xF7\x56\xA0\x7A\x76\x92\xC0\x7A\xEA\x10\x9A\x0E\x5A\xFF\x67\x2B\x51\x23\x43\x38\x48\x9F\xF0\xC7\x61\x96\x6D\xAE\x03\xD7\x83\xE8\xA4\xD0\x0A\xC9\x13\x4D\xF3\x41\x6B\x55\xE3\xA1\x6A\x50\x11\xB7\xEB\x29\xB6\xD9\xD0\xA2\x99\xB6\xB0\xF8\xA5\x8D\x3E\x4C\xDC\x1A\xB6\xFC\xED\x3F\x92\x76\x2B\xC8\x81\x88\x82\x75\x7A\x41\x26\xF8\x7E\xC5\xB7\x4D\xFF\xBF\x1F\x81\xF7\x7E\xFC\x8C\x03\xFC\x13\x5F\xEC\x1D\x20\x15\x1C\xBF\x78\x87\x49\x27\xAE\xE4\x77\x2F\x61\x39\xCC\x58\x5F\x2E\x12\x8B\xD1\x9D\x1D\x7F\x7B\x3D\x2D\x6B\x74\xE5\x9B\x7A\x21\x9A\xC5\x4E\x34\xCC\x47\x73\xF0\x49\x93\xDF\xFC\xD2\x52\x8B\x5C\xEE\x0E\x28\x60\x2F\xDE\x05\x76\x44\x8B\xF6\x2C\xCE\x7A\x24\x1A\x9A\xA3\xBC\x10\xAE\x76\xE2\x1C\x6A\xE3\xE6\x4B\xA0\x83\x1D\x7F\xEB\x28\xF5\x67\x28\x11\x31\x7D\xF2\x77\xC0\x50\x50\x83\x5E\x0A\x68\x89\x7C\x9C\x32\xF7\x37\xB3\x1E\x96\x56\x89\x8F\xE5\xC9\x86\x2D\x7D\x48\x20\xD8\xF5\xB7\x02\x05\xF2\x73\x4C\xC3\x55\x7C\x9B\x69\x53\x9E\x94\x20\x6A\xD8\x9A\x2A\xAE\x03\xE6\x9A\xE3\x44\x24\x2F\xF2\x2A\x74\x29\x14\x8A\xB3\xC6\xE8\x93\x8D\x2D\xD3\xE7\x74\x27\x41\x89\x38\x55\x4F\xD3\xE9\x12\x6A\xCD\xA6\xD8\x95\xB4\x03\xAA\x6E\x6D\x2A\x74\x90\xBC\x35\xB1\x13\x21\xA2\xA2\x25\x9A\xB6\x95\xBA\x94\x1D\x78\x1E\x9C\x9C\x59\x4A\x8C\x90\x03\xF2\x4F\x94\x88\xB9\x77\xC0\xD0\xC7\x56\x1F\x69\xA7\xD3\x99\x1D\xE6\x76\x40\x44\x79\xDB\xD2\xD6\x13\x01\x4A\xC6\xDC\x14\xB2\xCD\xFD\xD1\x64\x84\xBE\x22\xEF\x54\xAB\xCB\x8F\xBB\xFE\x83\x3E\x4A\xC0\x5C\x0E\xA4\x65\x0F\x87\xA9\x0B\xB7\x13\x27\x91\x29\x25\x26\xA5\xEC\x08\xEA\xE8\xA1\xFF\xE0\x86\x16\x11\x84\xFB\x98\x56\x0E\xA7\x5A\x30\xCF\x15\x36\x28\xB7\xC7\x63\xDA\x89\xA3\x0F\x1C\x43\x6B\xF3\x38\x91\xB9\x03\x49\x6A\x70\xE9\x0F\x34\xC4\xE1\x78\xB2\xB4\xDC\x3F\x99\xBB\x4D\x9F\xF3\x52\xFC\xCE\x9D\x68\xB5\xC1\x41\x6E\x64\x76\x56\x83\x6B\xA6\x54\x98\xC7\x81\x2F\x37\x75\xBD\xD9\x76\xE5\x1B\xFE\xA6\xD0\x67\x66\x8A\xEC\xCA\x57\x35\x96\x7B\x75\x01\xEF\x3E\x8F\x3B\x15\xF8\x0A\x7A\xBD\x68\x4C\x50\xF6\x84\x99\x07\x19\x86\x3E\x64\x02\x35\xA6\x82\x57\xA0\x69\xDB\x16\xE1\x73\xF5\xD9\x74\x1B\x91\x58\xF3\x7C\x5D\x2B\x72\xB0\xCF\x4C\xA3\x71\x75\x3C\x5F\x43\x6A\x3B\x84\xF6\x93\x99\x67\xAC\x6F\x6C\x70\x01\x6F\x6F\xFA\x0E\x77\xA6\x71\x67\x1F\x05\x60\x95\x85\x98\x4E\x66\xC1\x07\x59\xCF\xF9\x6D\x06\xAC\x6F\xF2\x94\x65\x72\x4C\xB3\xBB\xED\xC9\x7B\xB6\xFA\x67\x12\x56\x85\xAC\xE5\x6F\x1D\x1A\x9E\x22\xBD\x39\x15\x6A\x5C\x1C\xC2\x11\xAB\x9C\x10\x92\xE3\xFD\x02\xF1\x04\x8E\xB0\xAE\xC4\x26\xC8\x8C\xBC\xE5\x62\x14\xF0\xD7\x41\x34\x39\xE9\x0E\xEB\x75\x4E\x83\xFF\x86\x70\x44\xDC\xB1\xD3\x53\xBB\x66\xE2\xE2\x99\x7C\xD3\x76\x19\x67\x61\x7F\xF2\x65\x81\xA9\xD4\x4B\x64\xA5\xD4\xEE\x43\x16\x6E\xFD\xFF\x01\x4E\x14\x7B\x51\xD3\xEB\x1A\x4E\x99\xE8\xD6\x1D\x30\xF4\x33\x8D\x03\x5C\x9F\x05\x0E\xB0\xC4\x12\x4B\x2C\xF1\xD3\xE0\x3B\xB0\x34\xCF\x2D\x1A\x3C\x48\x2E\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(16, 14)),
["Air+Duck"] = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x30\x00\x00\x00\x30\x08\x06\x00\x00\x00\x57\x02\xF9\x87\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x16\x25\x00\x00\x16\x25\x01\x49\x52\x24\xF0\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x03\xE4\x49\x44\x41\x54\x78\x01\xED\x99\x4D\x6E\xD3\x40\x14\xC7\xFF\x33\x4E\xCA\xC7\x02\x85\x1B\x98\x1B\x34\x27\x20\x3D\x01\x0D\xB4\x48\xAC\x12\xB3\x20\x20\x16\xB4\x27\x68\x38\x01\x65\x81\xA2\xB2\x71\xBA\x42\x6A\xA9\xD2\x1B\x34\x37\x68\x6F\xC0\xF4\x04\xB5\x28\x12\x52\x9B\xCC\xF0\x5E\x9C\x88\x7C\x67\x26\xB5\xDD\x4D\x7E\x52\x54\xD7\x79\x76\xDE\xF3\xCC\xFB\x34\xB0\xE2\x7E\x11\xC8\x98\x30\x6C\x15\x6E\xD0\xD9\x11\x42\x3C\x37\x06\xA5\x58\x09\x73\x61\xA4\xB7\x5F\xAB\xBC\x3C\x84\x23\x99\x1A\xD0\x08\x5B\xBE\x84\x3E\x03\x8C\x3F\x5D\x42\x28\x0D\xB9\xF1\x21\x28\x2B\x58\x22\x91\x21\xF3\x95\x67\x4C\xCF\xC0\x30\x0C\x0B\xB0\xBE\x67\x46\x34\xC2\x93\xEA\x7C\xE5\x07\x18\xFF\x46\x3E\xF9\x04\x4B\x32\x33\xC0\x83\xB1\x56\x4A\x68\x53\xB2\x95\xCD\xCC\x00\x03\xAC\x3B\xC8\x96\x6C\x65\x33\xF5\x81\x34\xC8\xCC\x00\x0A\x77\x6D\x7B\x69\x73\x61\x2B\x99\xDD\x16\x92\xA2\x6D\x2D\x2C\xC5\xBE\xB5\x28\x32\x62\x4D\xCB\xAF\xF4\x47\x59\x88\xAA\x5A\x65\xCB\x3A\xA1\x65\x66\x40\x10\x94\x23\x8D\xDB\x0D\xCC\x37\x42\xF5\x65\xAC\x71\xCE\xC4\xDF\xC2\xD6\x7A\x0E\x9D\x4D\xB2\x9D\xC2\xA2\x29\xD0\x1D\x14\xDD\x44\x51\xE4\x88\x0C\x44\x24\x04\x1F\xCB\x48\xE8\x9B\x4B\xCA\xAA\x11\x90\x53\x0F\xE9\x3B\x36\x60\x70\x8F\x46\x78\x54\x95\xBD\xEB\xE3\xC8\x44\xD7\xB6\x05\x44\x7B\x0D\xBF\xBF\x06\x41\x10\xB9\xE8\x63\x65\x40\x5C\xBF\x74\x4B\xA4\xDC\xA7\x41\xFD\xE2\x8E\x60\xC5\x9A\xB5\xE0\xD5\x2E\x12\x64\xA1\x01\x9C\x41\x69\x9F\x7D\xE9\x3D\xED\x24\x90\xA2\x5E\xAB\xBC\xFA\x8C\x84\x90\x16\x02\x7B\x89\x29\xCF\x68\xB3\x83\x04\xB1\x71\xE2\x09\xE5\x79\xCF\x4A\x69\x36\xBD\xFC\x23\x1F\x52\x56\x69\x19\xAD\xE3\x76\xD2\x2C\x34\x40\x03\xBC\x67\x15\x7D\x68\x0F\x8B\xBA\xC9\xC9\xF5\x07\xF0\xCA\x5D\xE4\x7C\xDD\xF9\xDB\x84\xD6\x4D\x97\x32\x81\xCC\x6F\x22\x41\x9C\xA3\xD0\x5D\x7C\x82\x1B\x97\x77\xC1\x76\x11\x09\xE2\x94\x07\x0E\xC2\xE3\xBA\x84\x09\x97\xF4\x09\x95\xC7\x1F\xA7\x18\x6F\x43\xCE\x46\xA8\xDF\x06\x52\x7A\x17\x95\x19\x22\x8A\x3E\xFE\x9C\x5B\xF4\x12\x94\x6B\x8C\xB7\x61\xE1\x0A\x70\x1B\x78\x8B\xEE\xD9\x14\xE5\x7B\x3E\xD1\x81\x57\x5C\xB0\x13\x7B\xCA\x7F\x08\xDE\x28\xA4\xC0\xDC\x5F\x8E\xB3\xAE\x6E\x4D\xE9\xA4\x54\x07\xBA\x2C\x91\x8F\x16\xB4\x89\x5C\x3E\x14\xD3\x52\x9E\x99\xB9\x02\xEC\xAC\xB9\x29\xCA\xB1\x23\xF2\x13\x7D\x8C\xBC\x5A\xD4\xE3\x92\x91\x1B\x69\x2A\x1F\xEB\x33\x83\x83\xF0\xE4\xD7\xA4\xF2\x68\xE6\x71\xBD\xCB\x7B\xF9\x7B\xF8\xF3\x7C\x41\xF8\x8C\xE8\x82\x36\x84\xB8\xD0\xBA\x7B\xC9\x13\x87\x87\xC8\x5D\x0C\xD7\x44\x49\x30\xCF\x80\xAB\xD1\x68\x43\x25\x40\x10\x97\x00\xA4\xFC\x3E\x29\x6F\xDD\xE3\x8E\xFD\x24\x6D\xBF\x6E\xF9\x63\xF0\x3A\x91\xE4\x37\x73\x0B\x8D\x24\x30\x23\xAB\x03\xE5\x19\x33\x3B\x1A\x59\x60\xFC\x1C\xE4\xF9\xB7\xF0\xC8\x21\xF9\xCD\x66\xA9\xC1\xD6\xE4\xEA\x2C\x05\x39\xB8\x57\x74\x19\x62\x4D\x63\xB9\x86\x46\xC2\xA2\xE5\x13\x11\xD7\x4C\x5C\x7D\xD2\xF1\x29\x26\xEB\xA5\x02\x07\x01\x0E\xD3\xB8\x03\x4B\x19\x10\x97\xC3\xBD\xBE\x75\x8E\x43\x9A\x82\xE0\xF1\x88\x46\x95\x1A\x9B\xDD\x5A\xB0\xC5\xF9\xA2\x3E\x26\xE3\x7B\xE8\xB4\x5C\x26\x71\xE3\xDC\x79\x36\x1A\x77\x57\xDE\x0B\x52\x66\x73\xB6\x94\x50\xD4\x6D\x15\x39\x7A\xD1\xF6\xE3\x3A\x6A\xBC\xA4\x3E\x25\x03\xCB\x58\x82\xC4\x86\xBB\x8D\xF0\x87\x4F\xF3\xB7\x12\xB5\x8A\xD4\x3F\x4C\x96\x15\x46\x62\xE7\x7D\x65\x8B\x1B\x7B\xF6\xA1\xD6\xA4\xC1\x62\x7F\x99\x6E\x2D\x95\xE9\x74\x3F\x83\xEF\x8D\x2A\x29\x14\x29\xF8\x8C\x8F\xB8\xB6\xE2\xF2\x64\x32\x8F\x98\xCF\xB5\x60\xBB\x0E\x07\x52\x1B\xAF\xF7\xFB\xE8\xAB\xE1\x73\x1A\x86\x32\xF3\x76\x9B\x8F\x79\xC5\xA8\x14\xA1\x4C\x3E\xB6\x5A\x1C\xB2\xDF\xBE\xBC\xFF\xB1\x0A\x67\x5C\x1A\x02\x34\x87\xCF\x79\x10\x7B\x83\x63\x2E\x31\xE2\x11\x8A\x18\x0D\x04\x42\x5B\x0F\xB5\x98\x54\xE7\x42\x5D\x63\x46\x9E\x24\x0F\x6D\x1B\xE1\x71\x69\xF0\x3F\x1B\xD1\xA1\x17\x1A\x63\x97\x39\x95\x1A\xA9\x1A\xC0\xDB\x65\x7C\x26\x2A\x20\x47\xB2\xF8\xC7\xA0\x4C\xC5\xA1\x08\xF0\x3F\xEB\xD7\xE1\x40\xEA\xAF\x98\xF8\x89\x4B\x88\xB3\xE1\x73\x6B\xB8\x7E\x9A\x54\x73\x93\xFA\x68\xB1\xEF\xB4\x6A\xF8\x9C\xCB\x1B\x98\x45\x64\x32\x1B\xE5\x37\x90\x23\x27\x12\x9C\x0D\x65\x62\xC0\x03\x8D\xC3\xB1\x68\x93\x58\x4F\x90\x89\x01\xF1\x64\x7A\xA4\x3C\xAF\x63\xC5\x8A\x15\x2B\x98\x7F\x41\x96\x8A\x32\xE6\x4D\xDD\xF5\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(16, 14)),
Crouching = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x30\x00\x00\x00\x31\x08\x06\x00\x00\x00\x9C\x5E\x2A\x22\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x16\x25\x00\x00\x16\x25\x01\x49\x52\x24\xF0\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x03\xD0\x49\x44\x41\x54\x78\x01\xED\x59\x41\x6E\xD3\x4C\x14\xFE\xDE\xB8\xE5\x5F\xFD\xA8\x37\xC0\x9C\x80\x70\x02\xC2\x09\xA0\xA5\x20\xB1\x00\x6A\x16\x84\x8A\x05\xE1\x04\x2D\x27\x68\xBB\x40\x51\xBB\x71\x61\x83\x44\x55\xD2\x1B\x90\x9E\x80\xF4\x04\xF8\x06\x04\x84\x10\x22\xCD\x3C\xDE\x24\x6D\xB1\x1D\x67\x3C\x61\x1C\xD8\xE4\x93\x22\xC7\xC9\x78\x66\xBE\x99\x37\xDF\xFB\x66\x0C\xCC\x31\xC7\x1C\x73\xCC\x31\xC7\x1C\xFF\x0E\x84\x19\x21\x8E\xDB\x4B\x3F\x71\xDA\x24\xA2\x1B\xCC\xA8\x8F\x1A\xE3\x2E\xAB\x60\xBB\xF1\x68\xE5\x35\x2A\xC2\x4C\x08\xB4\xE2\x76\xA8\xA0\x3F\x00\x1C\x16\x97\xA0\x44\x43\xDD\x5C\x8F\x96\x13\x78\x42\x61\x06\xB0\x77\xDE\x80\x87\x04\xE3\x38\x5E\x82\x77\x5B\x15\xA3\x15\x1F\xAE\xD9\x3B\x7F\x0E\x0E\x7F\xAA\xCB\xCF\xE1\x89\xCA\x09\x04\x60\xE7\x4E\x91\xE6\x3A\x3C\x51\x39\x01\x06\x6A\x53\x94\xAD\xC3\x13\x33\x59\x03\x7F\x13\x95\x13\x10\x59\xEB\xB8\x97\xE6\x2E\x3C\x51\x7D\x08\x29\xEA\x38\x17\x56\xB4\x0D\x4F\x54\x4E\xE0\x92\x56\x3B\x72\x49\x1C\x8A\x26\x8D\x47\xAB\xDE\x09\xAD\x72\x02\x51\xB4\xDC\xD3\xE8\xDF\x84\x9D\x44\x72\x56\xC6\x1B\x33\xB3\x12\x06\xAD\xF8\xDD\x9A\x82\x32\xB2\x3A\x54\x26\x51\x9D\x0E\x81\x3A\x97\xF0\x75\x27\x8A\xA2\x1E\xE6\xF8\xC3\x19\x30\x46\xED\x3B\xFA\x62\x07\x50\x53\x14\x5C\x93\x91\x5D\x52\xAC\x6B\x0C\x15\x8E\x6A\xE5\x0E\x53\xD0\x19\xE8\xFE\xF1\xB3\xE8\x9E\xB7\xD2\xD8\x30\x15\x01\x63\xD2\x02\x1A\xC4\xE7\xEE\xD2\xB1\x89\xDE\x2C\x09\x39\x13\x28\x77\x98\xCE\x4D\xF6\xC0\xD4\x6C\x3C\xAE\xC6\x52\x3B\xAB\x50\x40\x7A\xC3\xBF\xF3\x06\xBC\x24\x26\x68\xFB\x55\xFC\xCE\xD9\x72\xD8\xE0\x34\x03\xAF\xE2\x76\x6D\x01\x83\x8F\xB9\x9F\xBB\x0C\xEA\x12\x69\x09\x11\xEA\x9E\xEA\xE0\x64\x81\x06\x6D\x91\x9A\x10\x4E\xA8\x66\x4F\xE0\x44\x60\x37\x3E\xFC\x94\x1B\xFD\xA4\x11\xAD\x5E\x4D\x97\x19\xED\xC0\x06\x9F\x31\x15\x28\x11\x49\xBD\x5E\x24\xA9\xD2\x66\x53\x2E\x32\xEB\x30\x21\xB7\x39\x29\xE4\x16\x80\xD2\xCE\x37\xF3\xA1\xC3\x0B\xEA\x76\xBE\xDC\x0F\x9C\xD6\x54\xE9\x78\x18\xEB\xC0\xCD\x54\x4D\x61\x1F\xFF\xB7\xE5\xCB\x45\x52\xFB\x2D\x14\x17\x56\x5B\x42\x8E\x8D\xE5\x28\x24\xE0\xB2\x06\x32\xFE\x5E\x24\x73\xFF\xE9\x83\x95\x93\xB1\x8A\x94\xBA\x01\x3B\x64\xD6\xEE\xBC\x18\x91\xC8\xD4\x57\x97\x41\xDA\x32\xDF\xCD\x60\x89\x50\x7C\x2C\x50\xB9\x89\x49\xCF\x85\x40\x7A\xDB\x97\x30\xFA\x2F\x8B\x0A\x11\xDB\x37\x27\x7C\xE6\x52\x0D\x89\x71\xC7\xCA\xCD\xBD\xF8\x40\xD6\x18\x6F\x0D\x17\x79\x16\x12\x42\x6A\x73\x52\xBD\xA5\x04\x34\xF0\x02\x23\x5F\x33\xAC\x68\x3D\xBA\x9F\x14\x95\x63\x26\xAB\xAA\x90\xFA\xDD\xE9\x45\x04\xCB\xC8\x79\x25\x11\x84\xB1\xE7\x0D\x69\xF1\x4C\xD7\x6D\x92\x5B\x89\x17\xDA\x13\x95\xE2\x71\x95\xCA\x40\x3A\x72\x35\x4D\xBE\x15\xBF\x95\xBC\xB2\x28\x79\xA5\x50\xB5\x7A\xD2\xF9\xCD\xA7\xD1\xEA\x0E\x4A\x50\x89\x1B\xD5\x0A\xA5\xF1\x9F\x9F\x39\x73\x5F\xE4\x5A\xCF\x47\xDD\xA5\xF3\x06\x95\xCC\xC0\xEE\xFE\xA1\xE8\x3F\xDF\xB6\x14\x91\x11\xA5\x23\x86\x7E\xBD\x1E\xDD\xED\xE4\xFF\xDC\x7B\xF3\x5E\x0E\xBF\x74\x68\x72\xC9\xB3\x68\x79\x2A\xAB\x51\x0D\x81\xF1\x3C\x61\x6B\x32\x31\xA3\x3C\x89\xCC\xB4\xF0\x26\x30\x21\x81\x25\x80\x4B\x46\xE6\x97\x8D\xE8\xEE\x26\x3C\xE0\xBD\x06\xA4\xF3\xF5\xEC\x2F\xDC\x35\x59\x9A\x02\x55\x27\xC2\x3E\xAC\x3B\x33\xDA\x68\xC5\x07\x75\x78\xA0\x34\x13\x97\x41\x0E\x6F\x6F\x49\xD6\xBC\xB8\x37\xFE\xC8\x5C\x9F\x3C\x5C\x39\x96\x8B\xF9\x0C\x63\x1C\x5A\xAF\x9D\x25\xA8\x30\xF3\x3C\xC8\x24\xCA\x0E\xFE\x10\xDE\x04\x64\xF1\x66\xF5\x5B\xF1\x51\xBE\x48\x9A\xCC\x6E\x7C\x20\x56\x82\xB6\x52\x7F\x7B\x9D\x8F\x7A\x85\x90\xF1\x2D\xF9\x93\xB8\xFF\xF4\xB7\x63\xFB\x53\x94\xA0\x42\x78\xAE\x01\x5D\x4F\xDF\x19\x75\x29\xDB\xAC\xCB\xFB\x81\x2B\xE9\x7B\x22\xBF\xC3\xAD\x89\x21\x64\x4E\x99\x85\x5D\x91\x37\x49\x77\x27\x7B\xAB\x70\x84\x12\x90\xE8\x7D\xA6\x06\xF2\x9B\x11\x65\xF9\x63\xC3\xDE\xF9\x82\x67\x48\x95\x8E\xA6\xBC\xA5\xC9\x79\x1E\x4E\xE0\x01\x5B\x08\x4D\xBB\xB8\x7A\x67\x8B\xD5\x0E\xCE\xD6\x2B\xA7\x1A\x5E\xE7\x43\x13\x09\xA4\x5C\xA8\x13\xD8\x51\x0A\x45\x66\xC3\xF4\xFD\xE2\xE0\xCB\x09\x3C\x30\xD3\x93\xB9\x22\x88\xED\xF8\x9C\x0A\xCD\xB1\xAD\xE9\xB4\xF8\xEB\xEF\x07\xF2\xFB\x0B\x78\xE2\x17\xB5\xA2\x8C\xC0\x60\xFD\xA3\x03\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(16, 14)),
}

local hitgroup_str = {[0] = 'generic','head', 'chest', 'stomach','left arm', 'right arm','left leg', 'right leg','neck', 'generic', 'gear'}

player_info_prev = {}
for i = 1, 64 do player_info_prev[i] = { origin = vector(0, 0, 0), } end

local function lerpx(time,a,b) return a * (1-time) + b * time end
local render_string = function(x,y,cen,string,color,TYPE,font,fontsize)  if TYPE == 0 then  render.text(font, vector(x, y), color, '', string) elseif TYPE == 1 then render.text(font, vector(x, y), color, '', string) elseif TYPE == 2 then  render.text(font, vector(x, y), color, '', string) end  end

files.create_folder('nl\\melancholia')

local file_downloader = {}
file_downloader.urlmon = ffi.load('UrlMon')
file_downloader.wininet = ffi.load('WinInet')
file_downloader.download_file_from_url = function(from, to)
    file_downloader.wininet.DeleteUrlCacheEntryA(from)
    file_downloader.urlmon.URLDownloadToFileA(nil, from, to, 0,0)
end

for i = 1, 9 do
    local read = files.read("nl\\melancholia\\"..i..".png")
    if read == nil then
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/947429839101624320/952177172557234227/small_pixel.ttf', 'nl\\melancholia\\small_pixel.ttf')
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/967383362241167420/988498559575941130/velocity_warning.png', 'nl\\melancholia\\velocity_warning.png')
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/967383362241167420/989535076482158612/1.png', 'nl\\melancholia\\1.png')
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/967383362241167420/989535089039925308/2.png', 'nl\\melancholia\\2.png')
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/967383362241167420/989535107276759070/3.png', 'nl\\melancholia\\3.png')
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/967383362241167420/989535116068012032/4.png', 'nl\\melancholia\\4.png')
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/967383362241167420/989535127631712266/5.png', 'nl\\melancholia\\5.png')
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/967383362241167420/989535142051708958/6.png', 'nl\\melancholia\\6.png')
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/967383362241167420/989535152923357194/7.png', 'nl\\melancholia\\7.png')
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/967383362241167420/990682553419714631/8.png', 'nl\\melancholia\\8.png')
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/967383362241167420/989535189493485568/9.png', 'nl\\melancholia\\9.png')
    end
end

local image = {}
for i=1, 9 do
    image[i] = render.load_image_from_file(('nl\\melancholia\\%s.png'):format(i), vector(25, 25))
end

local Render_Shadow = function(start_pos, endpos, color1) render.gradient(start_pos, vector(start_pos.x + ((endpos.x - start_pos.x) / 2), endpos.y), color(0.0, 0.0, 0.0, 0.0), color1, color(0.0, 0.0, 0.0, 0.0), color1) render.gradient(vector(start_pos.x + ((endpos.x - start_pos.x) / 2), start_pos.y), endpos, color1, color(0.0, 0.0, 0.0, 0.0), color1, color(0.0, 0.0, 0.0, 0.0)) end
local Render_Indicator = function(i, col, cur) if not globals.is_connected then return end local position = vector(20, (screen_size.y / 1.55) + (39 * cur)) Render_Shadow(vector(position.x - 10, position.y - 7), vector(position.x + 22, position.y + 26), color(0, 0, 0, 0.41* col.a)) render.texture(image[i], vector(20, (screen_size.y / 1.55) + (39 * cur)-3), vector(25, 25), color(col.r, col.g, col.b, col.a)) end

local fonts = {
    pixel9 = render.load_font('nl\\melancholia\\small_pixel.ttf', 9, "a") or error and render.load_font('Smallest Pixel-7', 9, "a"),
    pixel = render.load_font("nl\\melancholia\\small_pixel.ttf", 9, "ao") or error and render.load_font('Smallest Pixel-7', 9, "ao"),
    verdana25 = render.load_font('verdana', 25),
    verdana12 = render.load_font('verdana', 12),
    verdana9 = render.load_font('verdana', 9),
    tahomab13 = render.load_font('tahoma', 12, 'b'),
    tahobab12 = render.load_font('tahoma', 12, 'b'),
    calibrib20 = render.load_font('calibri', 20, 'ab'),
    verdanab18 = render.load_font('verdana', 18, 'b'),
    verdanab11 = render.load_font('verdana', 11, 'b'),
    verdanab10 = render.load_font('verdana', 10, 'b'),
    verdanar11 = render.load_font('verdana', 11, 'a'),
    verdanar12 = render.load_font('verdana', 12, 'a'),
    verdanar12bi = render.load_font("verdana", 10, "bi"),
    verdanar12i = render.load_font("verdana", 12, "i"),
}

local refs = {
    double_tap = ui.find("Aimbot", "Ragebot", "MAIN", "Double Tap"),
    hide_shots = ui.find("Aimbot", "Ragebot", "MAIN", "Hide Shots"),
    legmovement = ui.find("Aimbot", "Anti Aim", "MISC", "Leg Movement"),
    safe_points = ui.find("Aimbot", "Ragebot", "SAFETY", "Safe Points"),
    body_aim = ui.find("Aimbot", "Ragebot", "SAFETY", "Body Aim"),
    remove_scope = ui.find("Visuals", "World", "MAIN", "Override Zoom", "Scope Overlay"),
    fakeduck = ui.find("Aimbot", "Anti Aim", "MISC", "Fake Duck"),
    thirdperson = ui.find("Visuals", "World", "MAIN", "Force Thirdperson"),
    daim = ui.find("Aimbot", "Ragebot", "MAIN", "Enabled", "Dormant Aimbot"),
    slowwalk = ui.find("Aimbot", "Anti Aim", "MISC", "Slow Walk"),
    pitch = ui.find("Aimbot", "Anti Aim", "ANGLES", "Pitch"),
    fl = ui.find("Aimbot", "Anti Aim", "FAKE LAG", "Limit"),
    auto_peek = ui.find("Aimbot", "Ragebot", "MAIN", "Peek Assist"),
    yaw = ui.find("Aimbot", "Anti Aim", "ANGLES", "Yaw"), --disabled or backward
    yawbase = ui.find("Aimbot", "Anti Aim", "ANGLES", "Yaw", "Base"), --local vies or at target
    yawoffset = ui.find("Aimbot", "Anti Aim", "ANGLES", "Yaw", "Offset"), --setting up yaw angles
    yawmod = ui.find("Aimbot", "Anti Aim", "ANGLES", "Yaw Modifier"), --center, offset etc
    yawmodoffset = ui.find("Aimbot", "Anti Aim", "ANGLES", "Yaw Modifier", "Offset"), --setting up yawmod jitter angle
    desync = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw"), --setting up desync
    inverter = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw", "Inverter"), --?
    leftdesync = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw", "Left Limit"),
    rightdesync = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw", "Right Limit"),
    fakeopt = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw", "Options"), --avoid overlap, jitter, rand jitter
    desyncfs = ui.find("Aimbot", "Anti Aim", "ANGLES", "Body Yaw", "Freestanding"), --peek fake peek real off
    fs = ui.find("Aimbot", "Anti Aim", "ANGLES", "Freestanding"), --switch of freestanding
}

local player_states = {[1] = 'Global', [2] = 'Standing', [3] = 'Crouching', [4] = 'Slowwalk', [5] = 'Running', [6] = 'Air', [7] = 'Crouch-Air'}
antiaim.condition_list = {
    [1] = '[G] ', [2] = '[S] ', [3] = '[C] ', [4] = '[SW] ', [5] = '[R] ', [6] = '[A] ', [7] = '[C-A] ',
}
antiaim.antibrutecondition_list = {
    [1] = '[G', [2] = '[S', [3] = '[C', [4] = '[SW', [5] = '[R', [6] = '[A', [7] = '[C-A',
}

local aastate2cond =  {
    [1] = "Melancholic",
    [2] = "Offset Tank",
    [3] = "Custom",
}
antiaim.weapon_conditions_list = {[1] = 'Global', [2] = 'AWP / Auto', [3] = 'Scout', [4] = 'Pistols'}
local aa_phases = {}
menu.anti_brute_data = {}
anti_bruteforce.work = true
anti_bruteforce.work_value = 0.0
anti_bruteforce.work_memory = {}
anti_bruteforce.memory = {}

menu.vistab = menu_items.new("visuals", visuals:selectable('Visuals', {'Watermark', 'Keybinds', 'MH Indicators', 'Extraneous indicators', 'Hands in Zoom', 'Custom Zoom', 'Ideal tick visualize', 'Velocity Modifier', 'Spectator List', '//[GS] Holo KB', 'State panel', "Damage Indicator"}))
menu.holobinds = menu_items.new("holobinds", visuals:selectable('//Keybinds (like holo)', {"DT", "OS", "FD", "DMG", "HC", "BODY", "PING", "PEEK", "SAFE"}), function() return menu.vistab:get(10) end)
menu.conditions = menu_items.new("holostates", visuals:selectable('//Keybinds Conditions', {"Thirdperson", "Firstperson"}), function() return menu.vistab:get(10) end)
menu.statepanel = menu_items.new("statepnl", visuals:selectable('State panel options', {"Antibrute Phase", "Localplayer State", "Ragebot Status"}), function() return menu.vistab:get(11) end)
menu.statestate = menu_items.new("statestate", visuals:combo('State panel aa state', {"Text", "Image"}), function() return menu.vistab:get(11) and menu.statepanel:get(2) end)
menu.statefont = menu_items.new("statefont", visuals:combo('State panel font', {"Default", "No anti-aliasing"}), function() return menu.vistab:get(11) end)
menu.statecolor1 = menu_items.new("stateclr1", visualsclr:color_picker('State panel Color 1', color(255, 255, 255, 255)), function() return menu.vistab:get(11) end)
menu.statecolor2 = menu_items.new("stateclr2", visualsclr:color_picker('State panel Color 2', color(255, 255, 255, 255)), function() return menu.vistab:get(11) end)
menu.statealpha = menu_items.new("statealpha", visuals:slider('State panel alpha', 0, 100, 67), function() return menu.vistab:get(11) end)
menu.watermarkcolor = menu_items.new("waterclr", visualsclr:color_picker('Watermark Color', color(117, 117, 255, 255)), function() return menu.vistab:get(1) end)
menu.watermarkinfocolor = menu_items.new("waterinfoclr", visualsclr:color_picker('Watermark Info Color', color(117, 117, 255, 255)), function() return menu.vistab:get(1) end)
menu.watermarkname = menu_items.new("wanername", visuals:combo('Watermark Username', {'Neverlose', 'Steam', 'Custom'}), function() return menu.vistab:get(1) end)
menu.watermarkcustomname = menu_items.new("watercustname", visuals:input("Custom Username", common.get_username()), function() return menu.vistab:get(1) and menu.watermarkname:get() == "Custom" end)
menu.keybindscolor = menu_items.new("kbindsclr", visualsclr:color_picker('Keybinds Color', color(117, 117, 255, 255)), function() return menu.vistab:get(2) end)
menu.accentcolor = menu_items.new("accentclr", visualsclr:color_picker('Accent Color', color(117, 117, 255, 255)), function() return menu.vistab:get(3) or menu.vistab:get(4) or menu.vistab:get(8) end)
menu.indsstyle = menu_items.new("indsst", visuals:combo('Indicators Style', {'Default', '//Modern'}), function() return false end)
menu.animscope = menu_items.new("zoomanim", visuals:switch("Disable Zoom anim"), function() return menu.vistab:get(6) end)
menu.marker_style = menu_items.new("markerstyle", visuals:combo("Marker Style", {"Pixel", "Kibit"}), function() return menu.vistab:get(12) end)
menu.marker_color = menu_items.new("markercolor", visualsclr:color_picker("Marker Color", color(255, 255, 255, 255)), function() return menu.vistab:get(12) end)
menu.scopecolor = menu_items.new("scopeclr", visualsclr:color_picker('Zoom Color', color(255, 255, 255, 255)), function() return menu.vistab:get(6) end)
menu.scopecolor1 = menu_items.new("scopeclr1", visualsclr:color_picker('Zoom Color 1', color(255, 255, 255, 0)), function() return menu.vistab:get(6) end)
menu.scopesize = menu_items.new("scopesize", visuals:slider('Custom Zoom Size', 20, screen_size.y/2, 50), function() return menu.vistab:get(6) end)
menu.scopegap = menu_items.new("scopegap", visuals:slider('Custom Zoom Gap', 0, screen_size.y/2, 10), function() return menu.vistab:get(6) end)
menu.misctab = menu_items.new("misc", misctabgg:selectable('MISCelanneous', {'Killsay', 'Clantag Spammer', 'Aspect Ratio', 'Viewmodel Changer', 'Console Logs'}))
menu.selectedtt = menu_items.new("ttmode", misctabgg:combo('Killsay Mode', {"Trashtalk", "Sponsor"}), function() return menu.misctab:get(1) end)
menu.delay = menu_items.new("ttdelay", tttab:slider("Killsay Delay", 1, 10, 2), function() return menu.misctab:get(1) end)
menu.arr = menu_items.new("arr", artab:slider("Aspect Ratio", 0, 200, 100, 0.01, function() if currentar == 0 then return "Off" end end), function() return menu.misctab:get(3) end)
menu.vmfov = menu_items.new("vmfov", vmtab:slider("Viewmodel FOV", 0, 100, 68), function() return menu.misctab:get(4) end)
menu.vmx = menu_items.new("vmx", vmtab:slider("Viewmodel X", -10, 10, 1), function() return menu.misctab:get(4) end)
menu.vmy = menu_items.new("vmy", vmtab:slider("Viewmodel Y", -10, 10, 1), function() return menu.misctab:get(4) end)
menu.vmz = menu_items.new("vmz", vmtab:slider("Viewmodel Z", -10, 10, 0), function() return menu.misctab:get(4) end)
menu.clantagmode = menu_items.new("ctmode", misctabgg:combo('Clantag Mode', {"Default", "Modern"}), function() return menu.misctab:get(2) end)
menu.hitlogs = menu_items.new("mainlogs", misctabgg:selectable('Hit-Logs', {'Under Cross', 'Console'}), function() return menu.misctab:get(5) end)
menu.hitcolor = menu_items.new("hitclr", logstab:color_picker("Hit Color", color(117, 117, 255)), function() return menu.misctab:get(5) end)
menu.misscolor = menu_items.new("missclr", logstab:color_picker("Miss Color", color(255, 117, 117)), function() return menu.misctab:get(5) end)

menu.ideal_tick = menu_items.new("i_t", premiumtick:switch('Ideal Tick', false))

menu.prev_os = menu_items.new("p_o", premiumtick:switch('Prevent OS', false), function () return menu.ideal_tick:get() end)

menu.airhc = menu_items.new("airhc", premiumhc:selectable("Air HC", {"AWP", "Auto", "Scout", "Pistols", "Revolver"}))
menu.hcair2 = menu_items.new("awphcair", menu.airhc:create():slider("AWP HC", 0, 100, 55), function() return menu.airhc:get(1) end)
menu.hcair3 = menu_items.new("autohcair", menu.airhc:create():slider("Auto HC", 0, 100, 55), function() return menu.airhc:get(2) end)
menu.hcair4 = menu_items.new("pisthcair", menu.airhc:create():slider("Scout HC", 0, 100, 55), function() return menu.airhc:get(3) end)
menu.hcair5 = menu_items.new("revhcair", menu.airhc:create():slider("Pistols HC", 0, 100, 55), function() return menu.airhc:get(4) end)
menu.hcair6 = menu_items.new("schcair", menu.airhc:create():slider("Revolver HC", 0, 100, 55), function() return menu.airhc:get(5) end)
menu.nshc = menu_items.new("nshc", premiumhc:selectable("No Scope HC", {"AWP", "Auto", "Scout"}))
menu.awphcns = menu_items.new("awphcns", menu.nshc:create():slider("AWP HC", 0, 100, 55), function() return menu.nshc:get(1) end)
menu.autohcns = menu_items.new("autohcns", menu.nshc:create():slider("Auto HC", 0, 100, 55), function() return menu.nshc:get(2) end)
menu.scouthcns = menu_items.new("schcns", menu.nshc:create():slider("Scout HC", 0, 100, 55), function() return menu.nshc:get(3) end)

menu.ideal_tick:tooltip('Reduces the chance of backshooting when auto-peeking')
menu.prev_os:tooltip('Reduces the chance of backshooting')

menu.silentaim = menu_items.new("silentaim", premiumfov:switch("Enable", false))
menu.customfov = menu_items.new("silentaimmode", premiumfov:combo("Mode", {"Default", "Custom"}), function() return menu.silentaim:get() end)
menu.customfovslider = menu_items.new("silentaimfov", premiumfov:slider("Custom FOV", 1, 180, 10), function() return menu.silentaim:get() and menu.customfov:get() == "Custom" end)

menu.autostop = menu_items.new("autostopfix", premiumas:switch("Enable", false))

menu.presets1 = menu_items.new("p", antihit:combo('Preset ', {'Disabled', 'Melancholic', 'Offset Tank', 'Custom', 'Smart'}, 0))

menu.smartrandom = menu_items.new("psr", menu.presets1:create():combo('Smart Type ', {"Static", "Random"}, 0), function() return menu.presets1:get() == "Smart" end)

menu.smartrandomsw = menu_items.new("psrsw", menu.presets1:create():switch('Dis. Rand. 2 times in a row', false), function() return menu.presets1:get() == "Smart" and menu.smartrandom:get() == "Random" end)

local function update_ref()
    menu.presets = menu.presets1:get()
end

menu.type = menu_items.new("t", antihitbuilder:combo('Current State', player_states, 0), function () return menu.presets1:get() == "Custom" end)

menu.manuals = menu_items.new("menumanual", antihit:combo('Manual Yaw', {"Disabled", "Right", "Left", "Freestanding"}), function() return menu.presets1:get() ~= "Disabled" end)
             
menu.mandisabler = menu_items.new("manualyaw", antihit:selectable("Manuals Settings", {"Jitter Disabler", "At Target Disabler"}), function() return menu.presets1:get() ~= "Disabled" end)

menu.attdisabler = menu_items.new("attargetyaw", antihit:selectable("Freestanding Settings", {"Jitter Disabler", "At Target Disabler"}), function() return menu.presets1:get() ~= "Disabled" end)

menu.idealfreestand = menu_items.new("idealfs", antihit:combo("Freestand Mode", {"Standart", "Smart"}), function() return menu.presets1:get() ~= "Disabled" end)

menu.anti_hit_helpers = menu_items.new("a_h_h", antihit:selectable('Anti-Hit Helpers', {'Legit AA on E', 'Bombsite E Fix', 'Shit AA on Warmup', 'Better Onshot'}, 0))

menu.legitaa = menu_items.new("laa", menu.anti_hit_helpers:create():combo("Legit AA Mode", {"Static", "Jitter"}), function() return menu.presets1:get() ~= "Disabled" and menu.anti_hit_helpers:get(1) end)

menu.animbreakers = menu_items.new("anim_b", antihit:selectable('Anim. Breakers', {'Static legs in air', 'Follow direction', 'Zero pitch on land'}, 0))

for i = 1, 7 do
    anitaim_condition[i] = {}
    if i ~= 1 then
        anitaim_condition[i].override = menu_items.new("p2" .. i, antihitbuilder:switch(antiaim.condition_list[i] .. 'Override', false), function ()
            return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i]
        end)
    end
    anitaim_condition[i].weapon = menu_items.new("p" .. i, antihitbuilder:combo(antiaim.condition_list[i] .. 'Weapon', antiaim.weapon_conditions_list, 0), function ()
        return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and (i == 1 or anitaim_condition[i].override:get())
    end)
    for v=1, 4 do
        local weapon = antiaim.weapon_conditions_list[v]
        anitaim_condition[i][v] = {}
        if v ~= 1 then
            anitaim_condition[i][v].override = menu_items.new("override weap" .. i .. v, antihitbuilder:switch(antiaim.condition_list[i] .. 'Override ' .. weapon .. " Weapon", false), function ()
                return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get())
            end)
        end
        anitaim_condition[i][v].preset = menu_items.new("pr2" .. i .. v, antihitbuilder:combo(antiaim.condition_list[i]..'Preset', {'Adaptive Center', 'Offset Jitter', 'Custom'}, 2), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) end)
        anitaim_condition[i][v].yaw_mode = menu_items.new("y_m" .. i .. v, antihitbuilder:combo(antiaim.condition_list[i]..'Yaw Mode', {'Jitter', 'Perfect'}, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" end)
        anitaim_condition[i][v].yaw_add_l = menu_items.new("y_a_l" .. i .. v, antihitbuilder:slider(antiaim.condition_list[i]..'Yaw Add L', -180, 180, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" end)
        anitaim_condition[i][v].yaw_add_r = menu_items.new("y_a_r" .. i .. v, antihitbuilder:slider(antiaim.condition_list[i]..'Yaw Add R', -180, 180, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" end)
        anitaim_condition[i][v].switch_ticks = menu_items.new("s_t" .. i .. v, antihitbuilder:slider(antiaim.condition_list[i]..'Switch Ticks', 4, 20, 4), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" and anitaim_condition[i][v].yaw_mode:get() == "Jitter" end)
        anitaim_condition[i][v].jitter = menu_items.new("j" .. i .. v, antihitbuilder:combo(antiaim.condition_list[i]..'Yaw Modif.', {'Disabled', 'Center', 'Offset', 'Random', 'Spin'}, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" end)
        anitaim_condition[i][v].modifier_mode = menu_items.new("m_m" .. i .. v, antihitbuilder:combo(antiaim.condition_list[i]..'Modif. Mode', {'Static', 'Random', 'Desync'}, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" and anitaim_condition[i][v].jitter:get() ~= "Disabled" end)
        anitaim_condition[i][v].jitter_value = menu_items.new("j_v" .. i .. v, antihitbuilder:slider(antiaim.condition_list[i]..'Modif. Deg', -180, 180, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" and anitaim_condition[i][v].jitter:get() ~= "Disabled" end)
        anitaim_condition[i][v].jitter_value1 = menu_items.new("j_v2" .. i .. v, antihitbuilder:slider(antiaim.condition_list[i]..'Modif. Deg #2', -180, 180, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" and anitaim_condition[i][v].jitter:get() ~= "Disabled" and anitaim_condition[i][v].modifier_mode:get() ~= "Static" end)
        anitaim_condition[i][v].fake_type = menu_items.new("f_t" .. i .. v, antihitbuilder:combo(antiaim.condition_list[i]..'Fake Type', {'Desync', 'Random'}, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" end)
        anitaim_condition[i][v].left_desync_value = menu_items.new("l_d_v" .. i .. v, antihitbuilder:slider(antiaim.condition_list[i]..'Left Limit', 0, 60, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" end)
        anitaim_condition[i][v].right_desync_value = menu_items.new("r_d_v" .. i .. v, antihitbuilder:slider(antiaim.condition_list[i]..'Right Limit', 0, 60, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" end)
        anitaim_condition[i][v].fake_option = menu_items.new("fp" .. i .. v,  antihitbuilder:selectable(antiaim.condition_list[i]..'Fake Options', {'Avoid Overlap', 'Jitter', 'Randomize Jitter'}, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" end)
        anitaim_condition[i][v].freestand_desync = menu_items.new("f_d" .. i .. v, antihitbuilder:combo(antiaim.condition_list[i]..'Freestand Fake', {'Off', 'Peek Fake', 'Peek Real'}, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" end)
        anitaim_condition[i][v].desync_on_shot = menu_items.new("d_o_s" .. i .. v, antihitbuilder:combo(antiaim.condition_list[i]..'Fake On Shot', {'Disabled', 'Opposite', 'Freestanding', 'Switch'}, 0), function () return menu.presets1:get() == "Custom" and menu.type:get() == player_states[i] and anitaim_condition[i].weapon:get() == antiaim.weapon_conditions_list[v] and (i == 1 or anitaim_condition[i].override:get()) and (v == 1 or anitaim_condition[i][v].override:get()) and anitaim_condition[i][v].preset:get() == "Custom" end)
    end
end

menu.anti_brute = menu_items.new("ai_b", antihitantibrute:switch('Enable', false), function () return menu.presets1:get() ~= "Disabled" end)
anti_brute_add = antihitantibrute:button('Add')
anti_brute_remove = antihitantibrute:button('Remove')
menu.anti_brute_switch = menu_items.new("ai_e_sw", antihitantibrute:switch('Switch Side', false), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() end)
menu.anti_brute_reset_time = menu_items.new("ai_e_tiime", antihitantibrute:slider('Reset time', 1, 30, 1), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() end)
menu.anti_brute_resetter = menu_items.new("a_b_rr", antihitantibrute:switch('Reset A-B Data at New Round Starts', false), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() end)
menu.phases = menu_items.new("ph", antihitantibrute:slider('Phases number', 2, 10, 7), function () return false end)
for i=1, menu.phases:get() do aa_phases[#aa_phases+1] = "Phase " .. i end
menu.anti_brute_visiblerz = menu_items.new("ahase_visibler", antihitantibrute:combo('Phase visibler', aa_phases, 0), function ()
    return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get()
end)
for i=1, 10 do
    menu.anti_brute_data[i] = {
        type = menu_items.new("a_cure_state" .. i, antihitantibrute:combo(('[P%s] Currect State'):format(i), player_states, 0), function ()
            return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_visiblerz:get() == aa_phases[i]
        end)
    }
    for v=1, 7 do
        local state = player_states[v]
        menu.anti_brute_data[i][v] = {}
        if state ~= "Global" then
            menu.anti_brute_data[i][v].override = menu_items.new("a_b.o".. i .. v, antihitantibrute:switch(('[P%s] Enable %s'):format(i, state), false), function ()
                return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_visiblerz:get() == aa_phases[i] and menu.anti_brute_data[i].type:get() == player_states[v]
            end)
        else
            menu.anti_brute_data[i][v].override = menu_items.new("a_b.o".. i .. v, antihitantibrute:switch(('[P%s] Enable %s'):format(i, state), true), function ()
                return false
            end)
        end
        menu.anti_brute_data[i][v].yaw_add = {}
        menu.anti_brute_data[i][v].yaw_add.checkbox = menu_items.new("a_b_d.y1".. i .. v, antihitantibrute:switch(('%s|P%s] Custom Yaw Adds'):format(antiaim.antibrutecondition_list[v], i), false), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_data[i][v].override:get() and menu.anti_brute_visiblerz:get() == aa_phases[i] and menu.anti_brute_data[i].type:get() == player_states[v] and menu.anti_brute_data[i][v].override:get() end)
        menu.anti_brute_data[i][v].yaw_add.yaw_add_l = menu_items.new("a_b_d.y3".. i .. v, antihitantibrute:slider(('%s|P%s] - Yaw Add L'):format(antiaim.antibrutecondition_list[v], i), -58, 58, 0), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_data[i][v].override:get() and menu.anti_brute_data[i][v].yaw_add.checkbox:get() and menu.anti_brute_visiblerz:get() == aa_phases[i] and menu.anti_brute_data[i].type:get() == player_states[v] end)
        menu.anti_brute_data[i][v].yaw_add.yaw_add_r = menu_items.new("a_b_d.y2".. i .. v, antihitantibrute:slider(('%s|P%s] - Yaw Add R'):format(antiaim.antibrutecondition_list[v], i), -58, 58, 0), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_data[i][v].override:get() and menu.anti_brute_data[i][v].yaw_add.checkbox:get() and menu.anti_brute_visiblerz:get() == aa_phases[i] and menu.anti_brute_data[i].type:get() == player_states[v] end)
        menu.anti_brute_data[i][v].fake = {}
        menu.anti_brute_data[i][v].fake.checkbox = menu_items.new("a_b_d.f".. i .. v, antihitantibrute:switch(('%s|P%s] Custom Fake Limit'):format(antiaim.antibrutecondition_list[v], i), false), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_data[i][v].override:get() and menu.anti_brute_visiblerz:get() == aa_phases[i] and menu.anti_brute_data[i].type:get() == player_states[v] end)
        menu.anti_brute_data[i][v].fake.slider = menu_items.new("a_b_d.f2".. i .. v, antihitantibrute:slider(('%s|P%s] - Fake Limit'):format(antiaim.antibrutecondition_list[v], i), -58, 58, 0), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_data[i][v].override:get() and menu.anti_brute_data[i][v].fake.checkbox:get() and menu.anti_brute_visiblerz:get() == aa_phases[i] and menu.anti_brute_data[i].type:get() == player_states[v] end)
        menu.anti_brute_data[i][v].jitter = {}
        menu.anti_brute_data[i][v].jitter.checkbox = menu_items.new("a_b_d.j".. i .. v, antihitantibrute:switch(('%s|P%s] Custom Yaw Modif.'):format(antiaim.antibrutecondition_list[v], i), false), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_data[i][v].override:get() and menu.anti_brute_visiblerz:get() == aa_phases[i] and menu.anti_brute_data[i].type:get() == player_states[v] end)
        menu.anti_brute_data[i][v].jitter.combo = menu_items.new("a_b_d.j1".. i .. v, antihitantibrute:combo(('%s|P%s] - Yaw Modif.'):format(antiaim.antibrutecondition_list[v], i), {'Disabled', 'Center', 'Offset', 'Random', 'Spin'}, 0), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_data[i][v].override:get() and menu.anti_brute_data[i][v].jitter.checkbox:get() and menu.anti_brute_visiblerz:get() == aa_phases[i] and menu.anti_brute_data[i].type:get() == player_states[v] end)
        menu.anti_brute_data[i][v].modifier_mode = menu_items.new("a_b_d.mo1".. i .. v, antihitantibrute:combo(('%s|P%s] - Modif. Mode'):format(antiaim.antibrutecondition_list[v], i), {'Static', 'Random', 'Desync'}, 0), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_data[i][v].override:get() and menu.anti_brute_data[i][v].jitter.checkbox:get() and menu.anti_brute_visiblerz:get() == aa_phases[i] and menu.anti_brute_data[i].type:get() == player_states[v] end)
        menu.anti_brute_data[i][v].jitter_value = menu_items.new("a_bs_d.j".. i .. v, antihitantibrute:slider(('%s|P%s] Modif. Deg'):format(antiaim.antibrutecondition_list[v], i), -180, 180, 0), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_data[i][v].override:get() and menu.anti_brute_data[i][v].jitter.checkbox:get() and menu.anti_brute_visiblerz:get() == aa_phases[i] and menu.anti_brute_data[i].type:get() == player_states[v] end)
        menu.anti_brute_data[i][v].jitter_value1 = menu_items.new("a_bs_d.j1".. i .. v,  antihitantibrute:slider(('%s|P%s] Modif. Deg#2'):format(antiaim.antibrutecondition_list[v], i), -180, 180, 0), function () return menu.presets1:get() ~= "Disabled" and menu.anti_brute:get() and menu.anti_brute_data[i][v].override:get() and menu.anti_brute_data[i][v].jitter.checkbox:get() and menu.anti_brute_visiblerz:get() == aa_phases[i] and menu.anti_brute_data[i].type:get() == player_states[v] and menu.anti_brute_data[i][v].modifier_mode:get() ~= "Static" and menu.anti_brute_data[i][v].jitter.combo:get() ~= "Offset" end)
    end
end
anti_brute_add:set_callback(function()
    if menu.phases:get() < 10 then
        aa_phases[#aa_phases+1] = "Phase " .. tostring(#aa_phases+1)
        menu.phases:set(menu.phases:get() + 1)
        menu.anti_brute_visiblerz:update(aa_phases)
    end
end)
anti_brute_remove:set_callback(function()
    if menu.phases:get() > 2 then
        aa_phases[#aa_phases] = nil
        menu.phases:set(menu.phases:get() - 1)
        menu.anti_brute_visiblerz:update(aa_phases)
    end
end)


local function buttonfix()
    anti_brute_add:visibility(menu.presets1:get() ~= "Disabled" and menu.anti_brute:get())
    anti_brute_remove:visibility(menu.presets1:get() ~= "Disabled" and menu.anti_brute:get())
end

--antiaim requires
for i = 0, 64 do table.insert(anti_bruteforce.memory, i, {count = 0}) end
ragebot.fix_ang = function(angles) while angles.pitch < -180.0 do angles.pitch = angles.pitch + 360.0 end while angles.pitch > 180.0 do angles.pitch = angles.pitch - 360.0 end while angles.yaw < -180.0 do angles.yaw = angles.yaw + 360.0 end while angles.yaw > 180.0 do angles.yaw = angles.yaw - 360.0 end if angles.pitch > 89.0 then angles.pitch = 89.0 elseif angles.pitch < -89.0 then angles.pitch = -89.0 end if angles.yaw > 180.0 then angles.yaw = 180.0 elseif angles.pitch < -180.0 then angles.pitch = -180.0 end return angles end
ragebot.vec_ang = function(src, dist) local forward = dist - src if forward.x == 0 and forward.y == 0 then local yaw = 0 if forward.z > 0 then pitch = 270 else pitch = 90 end else yaw = (math.atan2(forward.y, forward.x) * 180 / math.pi) if yaw < 0 then yaw = yaw + 360 end tmp = math.sqrt(forward.x * forward.x + forward.y * forward.y) pitch = (math.atan2(-forward.z, tmp) * 180 / math.pi) if pitch < 0 then pitch = pitch + 360 end end return ragebot.fix_ang(vector(pitch, yaw, 0)) end
ragebot.modify_velocity = function(cmd, goalspeed) local minspeed = math.sqrt((cmd.forwardmove * cmd.forwardmove) + (cmd.sidemove * cmd.sidemove)) if goalspeed <= 0 or minspeed <= 0 then return end if entity.get_local_player()['m_flDuckAmount'] >= 1 then goalspeed = goalspeed * 2.94117647 end if minspeed <= goalspeed then return end local speedfactor = goalspeed / minspeed cmd.forwardmove = cmd.forwardmove * speedfactor cmd.sidemove = cmd.sidemove * speedfactor end ragebot.roundStarted = 0 ragebot.player_info_prev = {} for i = 1, 64 do ragebot.player_info_prev[i] = { origin = vector(0, 0, 0), } end
ragebot.gjioer = false
ragebot.teleport_tick = 0

idealfs = function()
    if (menu.manuals:get() == "Freestanding" and menu.idealfreestand:get() == "Standart") then
        return true
    elseif (menu.manuals:get() == "Freestanding" and menu.idealfreestand:get() == "Smart") then
        if entity.get_threat(true) == nil then
            return true
        else
            return false
        end
    end
end

manualfunc = function()
    if (menu.manuals:get() == "Freestanding" and idealfs() == true) then
        refs.fs:override(true)
    else
        refs.fs:override(false)
    end

    if ((menu.manuals:get() == "Right" or menu.manuals:get() == "Left")) then
        return (menu.manuals:get() == "Right" and 102 or 0) + (menu.manuals:get() == "Left" and -78 or 0)
    else
        return (menu.manuals:get() == "Right" and 90 or 0) + (menu.manuals:get() == "Left" and -90 or 0)
    end
end

ragebot.normalize_yaw = function(yaww) while yaww > 180 do yaww = yaww - 360 end while yaww < -180 do yaww = yaww + 360 end return yaww end
antiaim.override_yaw = function(yaw_add, jitter_value, jitter_type) local yaw_modifier = yaw_add if jitter_type == 1 then yaw_modifier = yaw_modifier + (jitter_value / 2) * antiaim.side elseif jitter_type == 2 then yaw_modifier = yaw_modifier + jitter_value * ((antiaim.side+1) / 2) elseif jitter_type == 3 then yaw_modifier = math.random(-jitter_value, jitter_value) elseif jitter_type == 4 then yaw_modifier = yaw_modifier - (globals.tickcount * 3) % jitter_value end return yaw_modifier end
ragebot.mathdeg_atan = function(xdelta, ydelta) if xdelta == 0 and ydelta == 0 then return 0 end return math.deg(math.atan2(ydelta, xdelta)) end
ragebot.nearest = function() if globals.is_connected == nil then return end if entity.get_local_player() == nil then return end return entity.get_threat() end

antiaim.check = false
antiaim.side = 1

--idealtick
ragebot.gjioer = false
ragebot.teleport_tick = 0
ragebot.ideal_tick = function()
    local GetNetChannelInfo = utils.net_channel()
    local ping = GetNetChannelInfo.avg_latency[0] * 1000
    local AIPeek = false

    local binds = ui.get_binds()
    for i = 1, #binds do local bind = binds[i] if bind.name == 'Peek Assist' and bind.active then AIPeek = true end end

    if (refs.auto_peek:get() or AIPeek) and refs.double_tap:get() then
        idt = true
    else
        idt = false
    end

    if menu.ideal_tick:get() then
        if menu.prev_os:get() and idt then
            refs.fl:set(0)
            if ping >= 60 then
                refs.fl:set(8)
            elseif ping <= 30 then
                refs.fl:set(0)
            else
                refs.fl:set(4)
            end
        else
            refs.fl:set(14)
        end

        if idt then
            if ragebot.gjioer then
                ragebot.teleport_tick = ragebot.teleport_tick + 1
                if ragebot.teleport_tick > 1 then
                    ragebot.gjioer = false
                    ragebot.teleport_tick = 0
                end
                cvar.sv_maxusrcmdprocessticks:int(23) -- O_o
            end
        else
            cvar.sv_maxusrcmdprocessticks:int(13)
        end
    else
        refs.fl:set(14)
        cvar.sv_maxusrcmdprocessticks:int(13)
    end
end

---visuals

local dowloaded = false
network.get(('https://steamcommunity.com/profiles/%s/?xml=1'):format(panorama.MyPersonaAPI.GetXuid()), '', function(url_content)
    if url_content == nil then return end
    link_start = string.find(url_content, '<avatarMedium>')
    if link_start == nil then return end
    link_end = string.find(url_content, '</avatarMedium>')
    if link_end == nil then return end
    ht4r = url_content:sub(link_start+23,link_end-4);
    network.get(ht4r, '', function(response) image1 = render.load_image(response, vector(110, 110)) dowloaded = true end)
end)

watermark = function()
    if not globals.is_connected then return end
    watermark_alpha = lerpx(globals.frametime*16, watermark_alpha, menu.vistab:get(1) and 255 or 0)
    if globals.is_connected and watermark_alpha > 0.01*255 then
        if globals.tickcount%64 == 1 or globals.tickcount%64 == 33 then fpsss = (1 / globals.frametime) pingg = ((utils.net_channel().latency[1] * 1000) or 0) end
        if menu.watermarkname:get() == "Neverlose" then username = common.get_username() elseif menu.watermarkname:get() == "Steam" then username = panorama.MyPersonaAPI.GetName() else username = menu.watermarkcustomname:get() end
        local text = ('melancholia.ws    | %s | %sms | %sfps'):format(username, math.floor(pingg), math.floor(fpsss))
        bw1 = render.measure_text(fonts.pixel9, '', text).x
        bw = bw1
        height = 20
        local sw, sh = screen_size.x, screen_size.y
        local x = sw*0.5
        local y = sh - 20
        add_y = lerpx(globals.frametime*12, add_y, watermark_info_y)
        if watermark_info_time < 850 then watermark_info_y = 50 watermark_info_time = watermark_info_time + 1 else watermark_info_y = 0 end
        info_alpha = lerpx(globals.frametime*12, info_alpha, add_y > 6.7 and 1 or 0)
        if add_y > 1.7 and info_alpha > 0.01 then
            render.text(fonts.pixel9, vector(sw/2-render.measure_text(fonts.pixel9, '', watermark_info).x/2, y+30-add_y), color(menu.watermarkinfocolor:get().r, menu.watermarkinfocolor:get().g, menu.watermarkinfocolor:get().b, watermark_alpha*info_alpha), watermark_info)
        end
        render.rect(vector((x - bw/2)-5, y+1), vector((x + bw/2)+4, y + height), color(9, 9, 10, math.floor(watermark_alpha)))
        render.rect_outline(vector((x - bw/2)-5, y+1), vector((x + bw/2)+4, y + height), color(9, 9, 10, math.floor(watermark_alpha)))
        render.text(fonts.pixel9, vector(sw/2-bw/2, y+6), color(menu.watermarkinfocolor:get().r, menu.watermarkinfocolor:get().g, menu.watermarkinfocolor:get().b, watermark_alpha), '', text)
        render.text(fonts.pixel9, vector(sw/2-bw/2, y+6), color(menu.watermarkcolor:get().r, menu.watermarkcolor:get().g, menu.watermarkcolor:get().b, watermark_alpha), '', 'melancholia.ws')
        render.text(fonts.pixel9, vector(sw/2-bw/2 + render.measure_text(fonts.pixel9, '', ('melancholia.ws    | %s | '):format(username)).x, y+6), color(menu.watermarkcolor:get().r, menu.watermarkcolor:get().g, menu.watermarkcolor:get().b, watermark_alpha), '', math.floor(pingg))
        render.text(fonts.pixel9, vector(sw/2-bw/2 + render.measure_text(fonts.pixel9, '', ('melancholia.ws    | %s | %sms | '):format(username, math.floor(pingg))).x, y+6), color(menu.watermarkcolor:get().r, menu.watermarkcolor:get().g, menu.watermarkcolor:get().b, watermark_alpha), '', tostring(math.floor(fpsss)))
        render.texture(image1, vector(sw/2-bw/2 + render.measure_text(fonts.pixel9, '', ('melancholia.ws'):format(username)).x+4, y+5), vector(11, 11), color(255, 255, 255, watermark_alpha))
    end
end

kbnds = function()
    if not globals.is_connected then return end
    local hotkey_list_alpha = animations.anim_new('hotkey_list alpha', menu.vistab:get(2) and 255 or 0)
    local max_width = 0
    local frametime = 14 * globals.frametime
    local add_y = 0
    local total_width = 66
    local x, y = dragging_k:get()
    x,y=math.floor(x), math.floor(y)
    local active_binds = {}
    local bind = getbinds()
    for i = 1, #bind do
        local binds = bind[i]
        local bind_name = binds.name:lower():gsub("^%l", string.upper)
        local bind_state = binds.mode
        if bind_state == 2 then bind_state = 'toggled' elseif bind_state == 1 then bind_state = 'holding' end
        if data_k[bind_name] == nil then data_k[bind_name] = {alpha_k = 0} end
        data_k[bind_name].alpha_k = animations.math_lerp(data_k[bind_name].alpha_k, binds.active and 255 or 0, frametime)
        local bind_state_size = render.measure_text(fonts.pixel, '', bind_state)
        local bind_name_size = render.measure_text(fonts.pixel, '', bind_name)
        render.text(fonts.pixel, vector(x+2+1, y + 22 + add_y), color(0.8*255, 0.8*255, 0.8*255, data_k[bind_name].alpha_k*hotkey_list_alpha/255), '' , bind_name)
        render.text(fonts.pixel, vector(x-1+2 + (width_ka - bind_state_size.x - 9), y + 22 + add_y), color(0.8*255, 0.8*255, 0.8*255, data_k[bind_name].alpha_k*hotkey_list_alpha/255), '', '['..bind_state..']')
        add_y = add_y + 13 * data_k[bind_name].alpha_k/255
        width_k = bind_state_size.x + bind_name_size.x + 18
        if width_k > 119 then if width_k > max_width then max_width = width_k end end
        if binds.active then table.insert(active_binds, binds) end
    end
    alpha_k = animations.math_lerp(alpha_k, (ui.get_alpha() > 0.03 or #active_binds > 0) and 255 or 0, frametime)
    width_ka = animations.math_lerp(width_ka, math.max(max_width, 119), frametime)
    if (alpha_k > 0 or ui.get_alpha() > 0.03) and globals.is_connected then
        render.rect(vector(x, y), vector(x+width_ka, y+19), color(9, 9, 10, math.floor(alpha_k*hotkey_list_alpha/255)))
        render.rect_outline(vector(x, y), vector(x+width_ka, y+19), color(9, 9, 10, math.floor(alpha_k*hotkey_list_alpha/255)))
        render.text(fonts.pixel9, vector(x+1+width_ka / 2 - render.measure_text(fonts.pixel9, 'a', 'keybinds').x/2, y+5), color(menu.keybindscolor:get().r, menu.keybindscolor:get().g, menu.keybindscolor:get().b, alpha_k*hotkey_list_alpha/255), '', 'keybinds')
    end
    dragging_k:drag(width_ka, 18)
end

damage_indicator = function()
    if entity.get_local_player() == nil or not globals.is_connected or not entity.get_local_player():is_alive() then return end
    local add_x = animations.anim_new('m_bIsScoped add 1', entity.get_local_player().m_bIsScoped and 40 or 0)
    local isDmg = false
    local binds = ui.get_binds()
    for i = 1, #binds do local bind = binds[i] if bind.name == 'Min. Damage' and bind.active then isDmg = true end end
    local screendmgind = animations.anim_new("screen damage indicator", menu.vistab:get(12) and 255 or 0)
    local cur_dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()
    if cur_dmg == 0 then cur_dmg = 'auto' elseif cur_dmg > 100 then cur_dmg = '+'..cur_dmg-100 end
    if menu.marker_style:get() == "Pixel" then
        render.text(fonts.pixel, vector(screen_size.x/2+2+add_x, screen_size.y/2-25), color(menu.marker_color:get().r, menu.marker_color:get().g, menu.marker_color:get().b, screendmgind), 'c', tostring(cur_dmg))
    else
        render.text(fonts.pixel, vector(screen_size.x/2-15, screen_size.y/2-25), color(menu.marker_color:get().r, menu.marker_color:get().g, menu.marker_color:get().b, screendmgind), nil, isDmg and '1' or '0')
        render.text(fonts.pixel, vector(screen_size.x/2+10, screen_size.y/2-25), color(menu.marker_color:get().r, menu.marker_color:get().g, menu.marker_color:get().b, screendmgind), nil, tostring(cur_dmg))
    end
end

indsundrcrs1 = function()
    local local_player = entity.get_local_player()
    if not local_player then return end
    local bodyyaw = local_player.m_flPoseParameter[11] * 120 - 60
    if bodyyaw < 0 then angle = bodyyaw*-1 else angle = bodyyaw end
    if not globals.is_connected or not local_player:is_alive() or local_player == nil then
    return
    end
    local anti_aim_invert = bodyyaw > 0 and 1 or -1
    local isDmg = false
    local isPing = false
    local binds = ui.get_binds()
    for i = 1, #binds do bind = binds[i] if bind.name== 'Min. Damage' and bind.active then isDmg = true end if bind.name == 'Fake Latency' and bind.active then isPing = true end end
    local anims = { indicators_style1 = animations.anim_new('indicators style 1', menu.vistab:get(3) and menu.indsstyle:get() == "Default" and 1 or 0), add_x = animations.anim_new('m_bIsScoped add 1', local_player.m_bIsScoped and 40 or 0) }
    if anti_aim_invert == 1 then anims.indicator_color = color(menu.accentcolor:get().r, menu.accentcolor:get().g, menu.accentcolor:get().b, anims.indicators_style1*255) else anims.indicator_color = color(255, 255, 255, anims.indicators_style1*255) end
    anims.anim_pc = animations.anim_new('prec color 1', anims.indicator_color)
    if devalpha == 255 then alphastate = 0 end
    if devalpha == 0 then alphastate = 1 end
    if alphastate == 0 then devalpha = devalpha - 5 end
    if alphastate == 1 then devalpha = devalpha + 5 end
    if anti_aim_invert == -1 then anims.indicator_color = color(menu.accentcolor:get().r, menu.accentcolor:get().g, menu.accentcolor:get().b, anims.indicators_style1*255) else anims.indicator_color = color(255, 255, 255, anims.indicators_style1*255) end
    anims.anim_tn = animations.anim_new('tion color 1', anims.indicator_color)
    if anims.indicators_style1 >= 0.01 then
        local add_y = 22 * anims.indicators_style1
        local w1 = render.measure_text(fonts.pixel, nil, '[DEV]')
        render.text(fonts.pixel, vector(screen_size.x/2-w1.x/2 + anims.add_x, screen_size.y/2+add_y), color(255, 255, 255, math.min(anims.indicators_style1*255, devalpha)), nil, "[DEV]")
        add_y = add_y + 9
        local w = render.measure_text(fonts.pixel, nil, 'melancholia.ws')
        local w2 = render.measure_text(fonts.pixel, nil, 'melanch')
        render.text(fonts.pixel, vector(screen_size.x/2-w.x/2 + anims.add_x, screen_size.y/2+add_y), anims.anim_pc, nil, "melanch")
        render.text(fonts.pixel, vector(screen_size.x/2-w.x/2+w2.x + anims.add_x-2, screen_size.y/2+add_y), anims.anim_tn, nil, "olia.ws")
        add_y = add_y + 9
        render.rect(vector(screen_size.x/2-w.x/2 + 4 + anims.add_x, screen_size.y/2+add_y+1), vector(screen_size.x/2-w.x/2 + 65 + anims.add_x, screen_size.y/2+add_y+6), color(25, 25, 25, 179 * anims.indicators_style1))
        render.rect_outline(vector(screen_size.x/2-w.x/2 + 4 + anims.add_x, screen_size.y/2+add_y+1), vector(screen_size.x/2-w.x/2 + 65 + anims.add_x, screen_size.y/2+add_y+7), color(25, 25, 25, 179 * anims.indicators_style1))
        render.gradient(vector(screen_size.x/2-w.x/2 + 5 + anims.add_x, screen_size.y/2+add_y+2), vector(screen_size.x/2-w.x/2 + 18 + (angle/1.23) + anims.add_x, screen_size.y/2+add_y+6), color(menu.accentcolor:get().r, menu.accentcolor:get().g, menu.accentcolor:get().b, 255 * anims.indicators_style1), color(menu.accentcolor:get().r, menu.accentcolor:get().g, menu.accentcolor:get().b, 77 * anims.indicators_style1), color(menu.accentcolor:get().r, menu.accentcolor:get().g, menu.accentcolor:get().b, 255 * anims.indicators_style1), color(menu.accentcolor:get().r, menu.accentcolor:get().g, menu.accentcolor:get().b, 77 * anims.indicators_style1))
        add_y = add_y + 7
        local m_indicators = {{text = "RAPID",color = rage.exploit:get() == 1 and color(212, 212, 212) or color(255, 0, 0),bool = refs.double_tap:get()},{text = "OS-AA",color = color(130, 194, 18),bool = refs.hide_shots:get()},{text = "DMG",color = color(212, 212, 212),bool = isDmg},{text = "SAFE",color = color(212, 212, 212),bool = (refs.safe_points:get() == "Force")},{text = "BAIM",color = color(212, 212, 212),bool = (refs.body_aim:get() == "Force")},{text = "PING",color = color(130, 194, 18),bool = isPing},{text = "DUCK",color = color(212, 212, 212),bool = refs.fakeduck:get()}}
        for i, v in pairs(m_indicators) do
            local width = render.measure_text(fonts.pixel, nil, v.text)
            anims.alpha = animations.anim_new(('alpha %s'):format(i), v.bool and 1 or 0)
            anims.color = animations.anim_new(('color %s'):format(i), color(v.color.r, v.color.g, v.color.b, math.floor(anims.alpha*255*anims.indicators_style1*10)/10))
            if anims.alpha > 0.01 then
                add_y1 = animations.anim_new(('das %s'):format(i), add_y)-1
                render.text(fonts.pixel, vector(screen_size.x/2-width.x/2 + anims.add_x, screen_size.y/2+add_y1), anims.color, nil, v.text)
                add_y = add_y + 9
            end
        end
    end
end

indicator2 = function()
    if not globals.is_connected or not entity.get_local_player() or not entity.get_local_player():is_alive() then return end
    local cur_dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()
    if cur_dmg == 0 then cur_dmg = 'auto' elseif cur_dmg > 100 then cur_dmg = '+'..cur_dmg-100 end
    local isDmg = false
    local isPing = false
    local binds = ui.get_binds()
    for i = 1, #binds do bind = binds[i] if bind.name== 'Min. Damage' and bind.active then isDmg = true end if bind.name == 'Fake Latency' and bind.active then isPing = true end end
    local anims2 = {indicators_stylel = animations.anim_new('ui.visuals:Get(4)', menu.vistab:get(4) and 1 or 0)}
    if anims2.indicators_stylel >= 0.01 then
        local current_pos = 1
        local colors = color(255*0.51, 255*0.76, 255*0.07)
        for k, v in pairs(player_info_prev) do if k ~= nil then if v[3] then colors = color(255*0.98, 255*0.87, 255*0.11) break end end end
        local s_indicators = { { img = 3, color = rage.exploit:get() == 1 and color(255*0.83, 255*0.83, 255*0.83) or color(255, 0, 0), bool = refs.double_tap:get(), }, { img = 4, color = color(255*0.51, 255*0.76, 255*0.07), bool = refs.hide_shots:get() }, { img = 9, color = color(255*0.83, 255*0.83, 255*0.83), bool = isDmg }, { img = 1, color = color(255*0.83, 255*0.83, 255*0.83), bool = refs.safe_points:get() == "Force" }, { img = 6, color = color(255*0.83, 255*0.83, 255*0.83), bool = refs.body_aim:get() == "Force" }, { img = 2, color = color(255*0.51, 255*0.76, 255*0.07), bool = isPing }, { img = 7, color = color(255*0.83, 255*0.83, 255*0.83), bool = refs.fakeduck:get() },             { img = 5, color = entity.get_local_player().m_vecVelocity:length() > 260 and color(0.51*255, 0.76*255, 0.07*255) or color(255, 0, 0), bool = bit.band(entity.get_local_player().m_fFlags, bit.lshift(1,0)) == 0 }, { img = 8, color = colors, bool = refs.daim:get() } }
        for idx, value in pairs(s_indicators) do
            anims2.alpha2 = animations.anim_new(('alpha2 %s'):format(idx), value.bool and 1 or 0)
            anims2.color2 = animations.anim_new(('color2 %s'):format(idx), color(value.color.r, value.color.g, value.color.b, anims2.alpha2*anims2.indicators_stylel*255))
            if anims2.alpha2 > 0.01 then Render_Indicator(value.img, anims2.color2, current_pos);  current_pos = current_pos - 1; end
        end
    end
end

viewmodel_in_scope = function() if not menu.vistab:get(5) then cvar.fov_cs_debug:int(0) return end if entity.get_local_player() == nil then return end local m_bIsScoped = entity.get_local_player()['m_bIsScoped'] if m_bIsScoped then cvar.fov_cs_debug:int(90) else cvar.fov_cs_debug:int(0) end end

dragginvm = dragging_fn('Velocity Modifier', screen_size.x / 2 - 82, screen_size.y / 2 - 200)

rgb_health_based = function(percentage)
    local r = 124*2 - 124 * percentage
    local g = 195 * percentage
    local b = 13
    return r, g, b
end

a_width = 0
modifier_vel = 0
velocity_warning = render.load_image_from_file('nl\\melancholia\\velocity_warning.png', vector(75, 61))
velocity_modifier = function()
    local velind = animations.anim_new('velocity indicator', menu.vistab:get(8) and 1 or 0)
    if velind <= 0.01 then return end
    local me = entity.get_local_player()
    if not me then return end
    if not me:is_alive() then return end
    if ui.get_alpha() > 0 then modifier_vel = 0.5 if not menu.vistab:get(8) then modifier_vel = 1 end vel_show_off = true else modifier_vel = me['m_flVelocityModifier'] vel_show_off = false end
    modifier_vel = animations.math_lerp(modifier_vel, modifier_vel, globals.frametime * 8)
    local text_vel = string.format('Slowed down %.0f%%', math.floor(modifier_vel*100))
    local text_width_vel = 95
    a_width = animations.math_lerp(a_width, math.floor((text_width_vel - 2) * modifier_vel), globals.frametime * 8)
    local xv, yv = dragginvm:get()
    local r, g, b = rgb_health_based(modifier_vel)
    local velind1 = animations.anim_new('modifier_vel == 1', modifier_vel == 1 and 0 or 1)
    if not vel_show_off and modifier_vel == 1.00 and velind1 <= 0.01 then return end
    render.texture(velocity_warning, vector(xv+90-73, yv-50+40), vector(75, 61), color(menu.accentcolor:get().r, menu.accentcolor:get().g, menu.accentcolor:get().b, 255*velind*velind1))
    render.rect(vector(xv, yv+14+32), vector(xv+165-55, yv+31+32), color(16, 16, 16, math.floor(255*velind*velind1)), 6, true)
    render.rect(vector(xv, yv+15+32), vector(xv+65-55+(a_width + 6), yv+30+32), color(menu.accentcolor:get().r, menu.accentcolor:get().g, menu.accentcolor:get().b, 255*velind*velind1), 6, true)
    render.rect_outline(vector(xv, yv+14+32), vector(xv+165-55, yv+31+32), color(0, 0, 0, math.floor(255*velind*velind1)), 1, 6, true)
    render.text(fonts.pixel9, vector(xv+15, yv+19+32), color(255, 255, 255, math.floor(255*velind*velind1)), '', text_vel)
    dragginvm:drag(110, 65)
    if ui.get_alpha() > 0 then
        render.rect_outline(vector(xv, yv), vector(xv+110, yv+65), color(255, 255, 255, velind))
    end
end

local indicatoridealtick = function()
    if not entity.get_local_player() then return end
    if not entity.get_local_player():is_alive() then return end
    local add_x = animations.anim_new('idtickstatex', entity.get_local_player().m_bIsScoped and 40 or 0)
    local add_y = animations.anim_new('idtickstatey', (menu.ideal_tick:get() and menu.vistab:get(7) and (ui.find("Aimbot", "Ragebot", "MAIN", "Peek Assist"):get() or AIPeek) and ui.find("Aimbot", "Ragebot", "MAIN", "Double Tap"):get()) and 40 or 0)
    local idealtickalpha = animations.anim_new("idtick", (menu.vistab:get(7) and (ui.find("Aimbot", "Ragebot", "MAIN", "Peek Assist"):get() or AIPeek) and ui.find("Aimbot", "Ragebot", "MAIN", "Double Tap"):get()) and 255 or 0)
    local charge = rage.exploit:get()
    local charge_x = charge * 100
    local charge_comp = math.floor(charge_x)
    local AIPeek = false
    local binds = ui.get_binds()
    for i = 1, #binds do bind = binds[i] if bind.name == 'Peek Assist' and bind.active then AIPeek = true end end
    local xol = math.max(0.83*255*rage.exploit:get(), 0.83*255)
    local color_it = color(xol, xol, xol, idealtickalpha)
    local text_size = render.measure_text(fonts.pixel, '', "+/-CHARGED IDEAL TICK (" .. charge_comp .. "%)")
    render.text(fonts.pixel, vector((screen_size.x / 2) - text_size.x / 2 + add_x, screen_size.y / 2 + add_y - 80), color_it, '', "+/-CHARGED IDEAL TICK (" .. charge_comp .. "%)")
end

custom_scope = function()
    if not menu.vistab:get(6) then refs.remove_scope:set("Remove Overlay") return end
    refs.remove_scope:set("Remove All")
    local_player = entity.get_local_player()
    if local_player == nil or not local_player:is_alive() then return end
    local anim_num = (not menu.animscope:get() and (animations.anim_new('custom scope anim', local_player['m_bIsScoped'] and 1 or 0)) or (local_player['m_bIsScoped'] and 1 or 0))
    local scope_gap1 = menu.scopegap:get() * anim_num
    local scope_size1 = menu.scopesize:get() * anim_num
    local scope_color_1 = menu.scopecolor:get()
    local scope_color_2 = menu.scopecolor1:get()
    local width = 1
    scope_color_1.a = scope_color_1.a * anim_num
    scope_color_2.a = scope_color_2.a * anim_num
    local start_x = screen_size.x / 2
    local start_y = screen_size.y / 2
    render.gradient(vector(start_x - scope_gap1, start_y), vector(start_x - scope_size1, start_y + width), scope_color_1, color(scope_color_1.r, scope_color_1.g, scope_color_1.b, scope_color_2.a), scope_color_1, color(scope_color_1.r, scope_color_1.g, scope_color_1.b, scope_color_2.a))
    render.gradient(vector(start_x + scope_gap1, start_y), vector(start_x + scope_size1, start_y + width), scope_color_1, color(scope_color_1.r, scope_color_1.g, scope_color_1.b, scope_color_2.a), scope_color_1, color(scope_color_1.r, scope_color_1.g, scope_color_1.b, scope_color_2.a))
    render.gradient(vector(start_x, start_y + scope_gap1), vector(start_x + width, start_y + scope_size1), scope_color_1, scope_color_1, color(scope_color_1.r, scope_color_1.g, scope_color_1.b, scope_color_2.a), color(scope_color_1.r, scope_color_1.g, scope_color_1.b, scope_color_2.a))
    render.gradient(vector(start_x, start_y - scope_gap1), vector(start_x + width, start_y - scope_size1), scope_color_1, scope_color_1, color(scope_color_1.r, scope_color_1.g, scope_color_1.b, scope_color_2.a), color(scope_color_1.r, scope_color_1.g, scope_color_1.b, scope_color_2.a))
end
local shots_var = {hits = 0,misses = 0,all_shots = 0}
local count_shots = function(shot) if not globals.is_connected then return end local localplayer_ent = entity.get_local_player() if not localplayer_ent then return end local lp = localplayer_ent if globals.is_connected and lp:is_alive() then if shot.state == nil then shots_var.hits = shots_var.hits + 1 else shots_var.misses = shots_var.misses + 1 end shots_var.all_shots = shots_var.all_shots + 1 end end
dragging_state_panel = dragging_fn('state_panel', math.floor(screen_size.x - screen_size.x * (cvar.safezonex:float() / 1.385)), math.floor(screen_size.y * (cvar.safezoney:float() / 2.5)))
local x_size, y_add_state = 0, 10
statepanelfunc = function()
    if not menu.vistab:get(11) then return end
    local localplayer = entity.get_local_player()
    if not localplayer then return end
    if not localplayer:is_alive() then return end
    local font = menu.statefont:get() == "Default" and fonts.verdanar12 or fonts.verdana12
    local ui_color1 = menu.statecolor1:get()
    local ui_color2 = menu.statecolor2:get()
    local ragebot_data = (shots_var.hits / shots_var.all_shots) * 100
    local ragebot_status = ""
    if ragebot_data <= 25 then ragebot_status = "terrible" elseif ragebot_data >= 25 and ragebot_data <= 45 then ragebot_status = "bad" elseif ragebot_data >= 45 and ragebot_data <= 65 then ragebot_status = "warming up" elseif ragebot_data >= 65 and ragebot_data <= 80 then ragebot_status = "good" else ragebot_status = "cheat peppy" end
    local x, y = dragging_state_panel:get()
    x, y = math.floor(x), math.floor(y)
    local vec2_pos = vector(x, y)
    local nearest = ragebot.nearest()
    if nearest == nil then abphase = "none" elseif nearest ~= nil then if anti_bruteforce.memory[nearest:get_index()].count == 0 then abphase = "none" else abphase = tostring(anti_bruteforce.memory[nearest:get_index()].count) end end
    render.rect(vec2_pos - vector(5, 1), vec2_pos + vector(x_size + 5, y_add_state + 6), color(16, 16, 16, math.floor(menu.statealpha:get()*2.55)))
    render.text(font, vec2_pos, color(1*255, 0.1294117647*255, 0.537254902*255, 1*255), menu.statefont:get() == "Default" and '' or 'a', "» ")
    x_size = render.measure_text(font, menu.statefont:get() == "Default" and '' or 'a', "» ").x
    render.text(font, vec2_pos + vector(x_size, 0), color(255, 33, 137), menu.statefont:get() == "Default" and '' or 'a', "melancholia.ws")
    x_size = x_size + render.measure_text(font, menu.statefont:get() == "Default" and '' or 'a', "melancholia.ws").x
    render.text(font, vec2_pos + vector(x_size, 0), color(161, 80, 240), menu.statefont:get() == "Default" and '' or 'a', " - [DEV] version 1.0.1")
    x_size = x_size + render.measure_text(font, menu.statefont:get() == "Default" and '' or 'a', " - [DEV] version 1.0.1").x
    y_add_state = 10
    if menu.statepanel:get(1) then
        render.text(font, vec2_pos + vector(0, y_add_state), ui_color1, menu.statefont:get() == "Default" and '' or 'a', "» antibrute phase: ")
        render.text(font, vec2_pos + vector(render.measure_text(font, menu.statefont:get() == "Default" and '' or 'a', "» antibrute phase: ").x, y_add_state), ui_color2, menu.statefont:get() == "Default" and '' or 'a', abphase)
        y_add_state = y_add_state + 10
    end
    if menu.statepanel:get(2) then
        local state = tostring(statetext())
        render.text(font, vec2_pos + vector(0, y_add_state), ui_color1, menu.statefont:get() == "Default" and '' or 'a', "» localplayer state: ")
        if menu.statestate:get() == "Text" then
            render.text(font, vec2_pos + vector(render.measure_text(font, menu.statefont:get() == "Default" and '' or 'a', "» localplayer state: ").x, y_add_state), ui_color2, menu.statefont:get() == "Default" and '' or 'a', statetext():lower())
        else
            render.texture(statepanel_images[state], vec2_pos + vector(render.measure_text(font, '', "» localplayer state: ").x - 4, y_add_state + ((state == "Crouching") and -2 or 0)), vector(16, 14), color(ui_color2.r, ui_color2.g, ui_color2.b, 255))
        end

        y_add_state = y_add_state + 10
    end
    if menu.statepanel:get(3) then
        render.text(font, vec2_pos + vector(0, y_add_state), ui_color1, menu.statefont:get() == "Default" and '' or 'a', "» ragebot status: ")
        render.text(font, vec2_pos + vector(render.measure_text(font, menu.statefont:get() == "Default" and '' or 'a', "» ragebot status: ").x, y_add_state), ui_color2, menu.statefont:get() == "Default" and '' or 'a', tostring(ragebot_status))
        y_add_state = y_add_state + 10
    end
    dragging_state_panel:drag(x_size + 5, y_add_state + 6)
end

spectator_list = function() if not globals.is_connected then return end if not menu.vistab:get(9) then return end if not entity.get_local_player() then return end local get_spectators = entity.get_local_player():get_spectators() if get_spectators == nil then return end for i = 1, #get_spectators do v = get_spectators[i] render.text(fonts.pixel, vector(screen_size.x-render.measure_text(fonts.pixel, '', v:get_name()).x-2,-10+12*i), color(), '', v:get_name()) end end

local function enemyfov()
    if not globals.is_connected then return end
    if not entity.get_local_player() then return end
    if not entity.get_local_player():is_alive() then return end
    local ent = entity.get_players(true)
    local viewangles = render.camera_angles()
    local eye = entity.get_local_player():get_eye_position()
    local bestenemy = nil
    local fov = menu.customfov:get() == "Default" and 5 or menu.customfovslider:get()
    for i = 1, #ent do
        local enemy = ent[i]
        local cur = enemy:get_origin()
        local daun = math.abs(ragebot.normalize_yaw(ragebot.mathdeg_atan(eye.x - cur.x, eye.y - cur.y) - viewangles.y + 180))
        if daun < fov then
                fov = daun
                bestenemy = enemy
        end
    end
    return fov
end

--misc
gamesense_anim = function(text, indices) if not globals.is_connected then return end local text_anim = '               ' .. text .. '                      '  local tickinterval = globals.tickinterval local tickcount = globals.tickcount + math.floor(utils.net_channel().avg_latency[0]+0.22 / globals.tickinterval + 0.5) local i = tickcount / math.floor(0.3 / globals.tickinterval + 0.5) i = math.floor(i % #indices) i = indices[i+1]+1 return string.sub(text_anim, i, i+15) end
set_clantag = ffi.cast('int(__fastcall*)(const char*, const char*)', utils.opcode_scan('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))
set_clantag('\0', '\0')
clantag = function()
    if not globals.is_connected then return end
    if menu.misctab:get(2) and menu.clantagmode:get() == "Modern" then
        local local_player = entity.get_local_player()
        if local_player ~= nil and globals.is_connected and globals.choked_commands then
            clan_tag = gamesense_anim('`melancholia.ws', {0, 3, 3, 4, 5, 6, 7, 8, 9, 10, 12, 12, 12, 12, 12, 12, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25})
            if entity.get_game_rules()['m_gamePhase'] == 5 or entity.get_game_rules()['m_gamePhase'] == 4 then
                clan_tag = gamesense_anim('`melancholia.ws', {12})
                set_clantag(clan_tag, clan_tag)
            elseif clan_tag ~= clan_tag_prev then
                set_clantag(clan_tag, clan_tag)
            end
            clan_tag_prev = clan_tag
        end
        enabled_prev = false
    elseif menu.misctab:get(2) and menu.clantagmode:get() == "Default" then
        local local_player = entity.get_local_player()
        if local_player ~= nil and globals.is_connected and globals.choked_commands then
            clan_tag = gamesense_anim('melancholia', {0, 3, 3, 4, 5, 6, 7, 8, 9, 10, 12, 12, 12, 12, 12, 12, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25})
            if entity.get_game_rules()['m_gamePhase'] == 5 or entity.get_game_rules()['m_gamePhase'] == 4 then
                clan_tag = gamesense_anim('melancholia', {12})
                set_clantag(clan_tag, clan_tag)
            elseif clan_tag ~= clan_tag_prev then
                set_clantag(clan_tag, clan_tag)
            end
            clan_tag_prev = clan_tag
        end
        enabled_prev = false
    elseif not menu.misctab:get(2) and enabled_prev == false then
        set_clantag('\0', '\0')
        enabled_prev = true
    end
end

local current_phase = 0

local sponsortt = {"ᴍᴇʟᴀɴᴄʜᴏʟɪᴀ ɪs ʟᴏᴀᴅᴇᴅ ɢᴇᴛ ʏᴏᴜʀ ᴀss ʀᴇᴀᴅʏ",'𝚖𝚎𝚕𝚊𝚗𝚌𝚑𝚘𝚕𝚒𝚊 - 𝚙𝚛𝚎𝚖𝚒𝚞𝚖 𝚜𝚌𝚛𝚒𝚙𝚝', '𝔤𝔞𝔪𝔢𝔰𝔢𝔫𝔰𝔢? 𝔟𝔲𝔶 𝔪𝔢𝔩𝔞𝔫𝔠𝔥𝔬𝔩𝔦𝔞.𝔴𝔰','忧郁[MELANCHOLIA]摧毁一切!','`𝐦𝐞𝐥𝐚𝐧𝐜𝐡𝐨𝐥𝐢𝐚.𝐰𝐬 𝐨𝐰𝐧𝐢𝐧𝐠 𝐦𝐞 𝐚𝐧𝐝 𝐚𝐥𝐥', '𝐫𝐮 𝐩𝐚𝐬𝐭𝐞 𝐝𝐞𝐬𝐭𝐫𝐨𝐲𝐬 𝐟𝐫𝐨𝐦 𝐦𝐞𝐥𝐚𝐧𝐜𝐡𝐨𝐥𝐢𝐚 𝐫𝐞𝐥𝐞𝐚𝐬𝐞','𝕴 𝖒𝖆𝖐𝖊 𝖈𝖔𝖋𝖋𝖊𝖊 𝖆𝖓𝖉 𝖋𝖚𝖈𝖐 𝖞𝖔𝖚𝖗 𝖒𝖔𝖙𝖍𝖊𝖗 𝖋𝖙. 𝖒𝖊𝖑𝖆𝖓𝖈𝖍𝖔𝖑𝖎𝖆.',  'ⓜⓔⓛⓐⓝⓒⓗⓞⓛⓘⓐ ???最好的lua ｄｏｍｉｎａｔｅｓ ｈｖｈ ｓｃｅｎｅ ', 'did you want to kill me? ᵍᵉᵗ `ᵐᵉˡᵃⁿᶜʰᵒˡⁱᵃ.ʷˢ',
'▄︻デ`ᵯēłⱥꞥȼħꝋłīⱥ.ⱳꞩ > ƀēꞩⱦ łᵾⱥ ӻꝋɍ ꞥēꝟēɍłꝋꞩē══━一', '𝚍𝚘 𝚢𝚘𝚞 𝚠𝚊𝚗𝚝 𝚝𝚘 𝚋𝚎 𝚕𝚒𝚔𝚎 𝚖𝚎? 𝚋𝚞𝚢 `𝚖𝚎𝚕𝚊𝚗𝚌𝚑𝚘𝚕𝚒𝚊.𝚠𝚜 ',  '𝘮𝘦𝘭𝘢𝘯𝘤𝘩𝘰𝘭𝘪𝘢 - 𝘵𝘩𝘦 𝘮𝘰𝘴𝘵 𝘦𝘭𝘪𝘵𝘦 𝘴𝘤𝘳𝘪𝘱𝘵 ' , '☆꧁✬◦°˚°◦. ɛʐ ʄօʀ ʍɛʟǟռƈɦօʟɨǟ .◦°˚°◦✬꧂☆', '☆꧁✬◦°˚°◦. ɮʏ ɮɛֆȶ ʟʊǟ .◦°˚°◦✬꧂☆',
'𝚖𝚎𝚕𝚊𝚗𝚌𝚑𝚘𝚕𝚒𝚊 - 𝚙𝚛𝚎𝚖𝚒𝚞𝚖 𝚜𝚌𝚛𝚒𝚙𝚝', '𝔤𝔞𝔪𝔢𝔰𝔢𝔫𝔰𝔢? 𝔟𝔲𝔶 𝔪𝔢𝔩𝔞𝔫𝔠𝔥𝔬𝔩𝔦𝔞.𝔴𝔰','[ 🇵 🇷 🇪 🇲 🇮 🇺 🇲 ] 🇸🇨🇷🇮🇵🇹','ｍｅｌａｎｃｈｏｌｉａ.ｗｓ - ｐｒｏｄ. ｂｙ ＡＰＰＬＥ ＩＮＣ',  }

local trashtalktt = {'sᴇɪ ᴀɴᴄʜᴇ ɴᴇʟ ɢɪᴏᴄᴏ ᴅᴇʟ ᴘᴏᴠᴇʀᴏ ʀᴀɢᴀᴢᴢᴏ', '𝕨𝕙𝕪 𝕪𝕠𝕦 𝕤𝕠 𝕓𝕒𝕕? 𝕘𝕠 𝕡𝕝𝕒𝕪 𝕃𝕖𝔾𝕚𝕋','𝐈 𝐝𝐫𝐢𝐧𝐤 𝐉𝐚𝐜𝐤 𝐃𝐚𝐧𝐢𝐞𝐥𝐬 𝐚𝐧𝐝 𝐬𝐦𝐨𝐤𝐞 𝐩𝐚𝐫𝐥𝐢𝐚𝐦𝐞𝐧𝐭', '♡｡✧|3ㄴ¥∆ㅜ✧。* °*: ᑭᒪᗩYS Iᑎ ᗰY EᗩᖇS','𝕙𝕒𝕤𝕤𝕖 𝕖𝕤 𝕠𝕕𝕖𝕣 𝕝𝕚𝕖𝕓𝕖 𝕖𝕤.','𝕀𝕔𝕙 𝕤𝕡𝕦𝕔𝕜𝕖 𝕒𝕦𝕗 𝕕𝕖𝕚𝕟 𝕘𝕣𝕒𝕓', '𝐄 𝐌𝐎 𝐒𝐆𝐑𝐈𝐎𝐁𝐓 𝐀𝐒 𝐅𝐇𝐄À𝐑𝐑 𝐀𝐈𝐑 𝐀 𝐌𝐇𝐀𝐑𝐆𝐀𝐈𝐃','𝕤𝕔𝕙𝕝𝕒𝕗 𝕧𝕖𝕣𝕕𝕒𝕞𝕞𝕥𝕖𝕤 𝕒𝕣𝕤𝕔𝕙𝕝𝕠𝕔𝕙',
'𝔭𝔦𝔰𝔰 𝔬𝔣𝔣 𝔴𝔢𝔞𝔨 𝔡𝔬𝔤, 𝔶𝔬𝔲𝔯 𝔭𝔩𝔞𝔠𝔢 𝔦𝔰 𝔲𝔫𝔡𝔢𝔯𝔤𝔯𝔬𝔲𝔫𝔡 ',  'աh͙ҽr͙ҽ a͙ɾe͙ վo͙մ g͙օi͙ղg͙ ҍa͙ʂt͙ąr͙ժ',  '▄︻デ₲Ꝋ ꞨŁɆɆꝐ ⱲɆȺҞ ĐꝊ₲ ══━一', '𝓽𝓱𝓲𝓼 𝓲𝓼 𝓶𝔂 𝓹𝓪𝓻𝓽𝔂 𝓪𝓷𝓭 𝔂𝓸𝓾 𝓪𝓻𝓮 𝓶𝔂 𝔀𝓱𝓸𝓻𝓮 ',  'ｗｈａｔ ａｒｅ ｕ ｄｏｉｎｇ ｄｏｇ', '𝙸 𝚜𝚙𝚒𝚝 𝚘𝚗 𝚢𝚘𝚞𝚛 𝚐𝚛𝚊𝚟𝚎', '𝐖𝐄𝐑 𝐁𝐈𝐒𝐓 𝐃𝐔 𝐃𝐄𝐑 𝐒𝐎𝐇𝐍 𝐄𝐈𝐍𝐄𝐑 𝐇𝐔𝐑𝐄',
'ɪᴄʜ ɢɪᴇʙᴇ ᴍᴇᴘʜᴇᴅʀᴏɴ ᴀᴜꜰ ɪʜʀᴇɴ ᴀʀsᴄʜ','𝙱𝚄𝚁𝙽 𝙸𝙽 𝙷𝙴𝙻𝙻', '𝐰𝐡𝐚𝐭 𝐜𝐚𝐧 𝐲𝐨𝐮 𝐝𝐨 𝐰𝐢𝐭𝐡 𝐫𝐮 𝐩𝐚𝐬𝐭𝐞','ｓｋｅｅｔ ｄｏｎｔ ｎｅｅｄ ｕｐｄａｔｅ (◣_◢)', }

get_word = function(words)  current_phase = current_phase + 1 if current_phase > #words then current_phase = 1 end return words[current_phase]:gsub('\'', '') end

events.player_death:set(function(e) local localplayer = entity.get_local_player() local victim = entity.get(e.userid, true) local attacker = entity.get(e.attacker, true) if attacker == localplayer and victim~=localplayer then if menu.misctab:get(1) and menu.selectedtt:get() == "Sponsor" then utils.execute_after(menu.delay:get(), function() utils.console_exec("say "..(get_word(sponsortt))) end) elseif menu.misctab:get(1) and menu.selectedtt:get() == "Trashtalk" then utils.execute_after(menu.delay:get(), function() utils.console_exec("say "..(get_word(trashtalktt))) end) end end end)


hitlog_draw = function()
    local y_add = 0
    for i, notify in ipairs(miscellaneous.stuff) do
        local frametime = globals.frametime * 8
        if notify.time + 1 > globals.realtime then
            notify.alpha = animations.math_lerp(notify.alpha, 1, frametime)
            notify.alpha1 = animations.math_lerp(notify.alpha1, 1, frametime / 1.5)
        end
        local string = notify.text2.name .. notify.text2.hit .. notify.text2.who .. notify.text2.in_the .. notify.text2.where ..notify.text2.for_ .. notify.text2.how_much .. notify.text2.damage .. notify.text2.how_muc_r .. notify.text2.health
        local s = {
            string = render.measure_text(fonts.pixel, '', tostring(string)).x / 2,
            name = render.measure_text(fonts.pixel, '', tostring(notify.text2.name)).x,
            hit = render.measure_text(fonts.pixel, '', tostring(notify.text2.hit)).x,
            in_the = render.measure_text(fonts.pixel, '', tostring(notify.text2.in_the)).x,
            who = render.measure_text(fonts.pixel, '', tostring(notify.text2.who)).x,
            where = render.measure_text(fonts.pixel, '', tostring(notify.text2.where)).x,
            for_ = render.measure_text(fonts.pixel, '', tostring(notify.text2.for_)).x,
            how_much = render.measure_text(fonts.pixel, '', tostring(notify.text2.how_much)).x,
            damage = render.measure_text(fonts.pixel, '', tostring(notify.text2.damage)).x,
            how_muc_r = render.measure_text(fonts.pixel, '', tostring(notify.text2.how_muc_r)).x,
            health = render.measure_text(fonts.pixel, '', tostring(notify.text2.health)).x
        }
        render_string(notify.alpha1 * 40 - 40 + screen_size.x / 2 - s.string,screen_size.y * 81 / 100 - y_add,false,tostring(notify.text2.name),notify.type == 'Hit' and color(menu.hitcolor:get().r, menu.hitcolor:get().g, menu.hitcolor:get().b, notify.alpha*255) or color(menu.misscolor:get().r, menu.misscolor:get().g, menu.misscolor:get().b, notify.alpha*255),1,fonts.pixel, 9)
        render_string(notify.alpha1 * 40 - 40 + screen_size.x / 2 - s.string + s.name,screen_size.y * 81 / 100 - y_add,false,tostring(notify.text2.hit),color(255, 255, 255, notify.alpha*255),1,fonts.pixel, 9)
        render_string(notify.alpha1 * 40 - 40 + screen_size.x / 2 - s.string + s.name + s.hit,screen_size.y * 81 / 100 - y_add,false,tostring(notify.text2.who),notify.type == 'Hit' and color(menu.hitcolor:get().r, menu.hitcolor:get().g, menu.hitcolor:get().b, notify.alpha*255) or color(menu.misscolor:get().r, menu.misscolor:get().g, menu.misscolor:get().b, notify.alpha*255),1,fonts.pixel, 9)
        render_string(notify.alpha1 * 40 - 40 + screen_size.x / 2 - s.string + s.name + s.hit + s.who,screen_size.y * 81 / 100 - y_add,false,tostring(notify.text2.in_the),color(255, 255, 255, notify.alpha*255),1,fonts.pixel, 9)
        render_string(notify.alpha1 * 40 - 40 + screen_size.x / 2 - s.string + s.name + s.hit + s.in_the + s.who,screen_size.y * 81 / 100 - y_add,false,tostring(notify.text2.where),notify.type == 'Hit' and color(menu.hitcolor:get().r, menu.hitcolor:get().g, menu.hitcolor:get().b, notify.alpha*255) or color(menu.misscolor:get().r, menu.misscolor:get().g, menu.misscolor:get().b, notify.alpha*255),1,fonts.pixel, 9)
        render_string(notify.alpha1 * 40 - 40 + screen_size.x / 2 - s.string + s.name + s.hit + s.in_the + s.who + s.where,screen_size.y * 81 / 100 - y_add,false,tostring(notify.text2.for_),color(255, 255, 255, notify.alpha*255),1,fonts.pixel, 9)
        render_string(notify.alpha1 * 40 - 40 + screen_size.x / 2 - s.string + s.name + s.hit + s.in_the + s.who + s.where + s.for_,screen_size.y * 81 / 100 - y_add,false,tostring(notify.text2.how_much),notify.type == 'Hit' and color(menu.hitcolor:get().r, menu.hitcolor:get().g, menu.hitcolor:get().b, notify.alpha*255) or color(menu.misscolor:get().r, menu.misscolor:get().g, menu.misscolor:get().b, notify.alpha*255),1,fonts.pixel, 9)
        render_string(notify.alpha1 * 40 - 40 + screen_size.x / 2 - s.string + s.name + s.hit + s.in_the + s.who + s.where + s.for_ +s.how_much,screen_size.y * 81 / 100 - y_add,false,tostring(notify.text2.damage),color(255, 255, 255, notify.alpha*255),1,fonts.pixel, 9)
        render_string(notify.alpha1 * 40 - 40 + screen_size.x / 2 - s.string + s.name + s.hit + s.in_the + s.who + s.where + s.for_ +s.how_much +s.damage,screen_size.y * 81 / 100 - y_add,false,tostring(notify.text2.how_muc_r),notify.type == 'Hit' and color(menu.hitcolor:get().r, menu.hitcolor:get().g, menu.hitcolor:get().b, notify.alpha*255) or color(menu.misscolor:get().r, menu.misscolor:get().g, menu.misscolor:get().b, notify.alpha*255),1,fonts.pixel, 9)
        render_string(notify.alpha1 * 40 - 40 + screen_size.x / 2 - s.string + s.name + s.hit + s.in_the + s.who + s.where + s.for_ +s.how_much +s.damage +s.how_muc_r,screen_size.y * 81 / 100 - y_add,false,tostring(notify.text2.health),color(255, 255, 255, notify.alpha*255),1,fonts.pixel, 9)
        if notify.time + (5 - 0.1) < globals.realtime then
            notify.alpha1 = animations.math_lerp(notify.alpha1, 2, frametime / 1.5)
        end
        if notify.time + 5 < globals.realtime and notify.alpha1 > 1.5 then
            notify.alpha = animations.math_lerp(notify.alpha, 0, frametime)
        end
        if notify.alpha < 0.02 and (notify.time + 5 < globals.realtime) or #miscellaneous.stuff > 5 then
            table.remove(miscellaneous.stuff, i)
        end
        y_add = y_add + 12 * notify.alpha
    end
end

--antiaim

antiaim.set_preset = function(settings)
    local yaw_add = settings[1]
    local yaw_modifier = settings[2]
    local modifier_degree = settings[3]
    local left_desync_value = settings[4]
    local right_desync_value = settings[5]
    local fake_options = settings[6]
    local freestanding_desync = settings[8]
    local desync_on_shot = settings[9]
                                         
    local nearest = ragebot.nearest()
    if anti_bruteforce.work and menu.anti_brute:get() and nearest ~= nil and menu.presets ~= "Disabled" then
        local i = anti_bruteforce.memory[nearest:get_index()].count
        if i > 0 then
            local items = menu.anti_brute_data[i]
            local antibrute_state_aa
            if player_state == 'Air+Duck' and items[7].override:get() then antibrute_state_aa = 7 elseif player_state == 'Air' and items[6].override:get() then antibrute_state_aa = 6 elseif player_state == 'Crouching' and items[3].override:get() then antibrute_state_aa = 3 elseif player_state == 'Slowwalking' and items[4].override:get() then antibrute_state_aa = 4 elseif player_state == 'Moving' and items[5].override:get() then antibrute_state_aa = 5 elseif player_state == 'Standing' and items[2].override:get() then antibrute_state_aa = 2 else antibrute_state_aa = 1 end
            local settings = items[antibrute_state_aa]
            if settings.yaw_add.checkbox:get() then yaw_add = antiaim.side ~= 1 and settings.yaw_add.yaw_add_r:get() or settings.yaw_add.yaw_add_l:get() end
            if settings.fake.checkbox:get() then local fake = settings.fake.slider:get() left_desync_value = fake right_desync_value = fake end
            if settings.jitter.checkbox:get() then
                yaw_modifier = settings.jitter.combo:get()
                local ui_modifier_mode = settings.modifier_mode:get()
                local jitter_value, jitter_value1
                if ui_modifier_mode == "Static" then jitter_value = settings.jitter_value:get() else jitter_value = settings.jitter_value:get() jitter_value1 = settings.jitter_value1:get() end
                if ui_modifier_mode == "Static" then modifier_degree = jitter_value elseif ui_modifier_mode == "Random" then modifier_degree = math.random(jitter_value, jitter_value1) else modifier_degree = antiaim.side == 1 and jitter_value or jitter_value1 end
            end
            if settings.jitter.checkbox:get() then yaw_modifier = settings.jitter.combo:get() end
            if settings.jitter.checkbox:get() then yaw_modifier = settings.jitter.combo:get() end
        end
    end
    refs.yawoffset:override((manualfunc() ~= 0 and manualfunc() or ragebot.normalize_yaw(yaw_add)))
    refs.leftdesync:override(left_desync_value)
    refs.rightdesync:override(right_desync_value)
    if fake_options == "Jitter" then refs.inverter:override(invert) end                                
    refs.fakeopt:override((((menu.manuals:get() == "Right" or menu.manuals:get() == "Left") and menu.mandisabler:get(1)) or ((menu.manuals:get() == "Freestanding") and menu.attdisabler:get(1))) and "Avoid Overlap" or fake_options)
    refs.desyncfs:override((((menu.manuals:get() == "Right" or menu.manuals:get() == "Left") and menu.mandisabler:get(1)) or ((menu.manuals:get() == "Freestanding") and menu.attdisabler:get(1))) and "Off" or freestanding_desync)
    refs.yawmod:override((((menu.manuals:get() == "Right" or menu.manuals:get() == "Left") and menu.mandisabler:get(1)) or ((menu.manuals:get() == "Freestanding") and menu.attdisabler:get(1))) and "Disabled" or yaw_modifier)
    refs.yawmodoffset:override(modifier_degree)
end

local function entity_has_c4(presource) if presource == nil then return end return presource["m_iPlayerC4"] == 1 end
local classnames = {"CWorld","CCSPlayer","CFuncBrush"}
local function vec_distance(vec_one, vec_two) local delta_x, delta_y, delta_z = vec_one.x - vec_two.x, vec_one.y - vec_two.y return math.sqrt(delta_x * delta_x + delta_y * delta_y) end
local aainverted = false
local yaw_m = function(localplayer) local bodyyaw = localplayer.m_flPoseParameter[11] * 120 - 60 if globals.choked_commands == 0 then aainverted = bodyyaw > 0 end antiaim.side = aainverted and 1 or -1 end
antiaim.conditions = function(cmd)
    local localplayer = entity.get_local_player()
    if not localplayer then return end
    if not localplayer:is_alive() then return end
    yaw_m(localplayer)
    local active_weapon = localplayer:get_player_weapon()
    local anti_aim_invert = antiaim.side ~= 1
    local selected_preset = menu.presets
    local player_state = state()
    local default_presets = {
        -- {Yaw Add, Yaw Modifier, Modifier Degree, Left Limit, Right Limit, Fake Options, LBY Mode, Freestanding Desync, Desync On Shot}
        [1] = {
            ['Standing'] = {(antiaim.side ~= 1) and -4 or 4, "Center", -19, 56, 56, "Jitter", "Disabled", "Off", "Freestanding"},
            ['Moving'] = {(antiaim.side ~= 1) and 4 or 0, "Center", -12, 56, 56, "Jitter", "Disabled", "Off", "Freestanding"},
            ['Crouching'] = {(antiaim.side ~= 1) and 4 or 4, "Center", -18, 60, 60, "Jitter", "Disabled", "Off", "Freestanding"},
            ['Slowwalking'] = {(antiaim.side ~= 1) and 0 or -1, "Disabled", 0, 60, 60, "Jitter", "Disabled", "Off", "Default"},
            ['Air'] = {(antiaim.side ~= 1) and -4 or -4, "Center", -29, 60, 60, "Jitter", "Disabled", "Off", "Default"},
            ['Air+Duck'] = {(antiaim.side ~= 1) and -4 or -4, "Center", -12, 60, 60, "Jitter", "Disabled", "Off", "Default"},
        },
        [2] = {
            ['Standing'] = {(antiaim.side ~= 1) and 3 or 8, "Center", -68, 60, 60, "Jitter", "Disabled", "Off", "Switch"},
            ['Moving'] = {(antiaim.side ~= 1) and 0 or 0, "Center", -69, 60, 60, "Jitter", "Opposite", "Off", "Freestanding"},
            ['Crouching'] = {(antiaim.side ~= 1) and -1 or 5, "Center", -62, 60, 60, "Jitter", "Disabled", "Off", "Switch"},
            ['Slowwalking'] = {(antiaim.side ~= 1) and 0 or 4, "Center", -64, 60, 60, "Jitter", "Disabled", "Off", "Switch"},
            ['Air'] = {(antiaim.side ~= 1) and 8 or 13, "Center", -48, 60, 60, {"Avoid Overlap", "Jitter"}, "Opposite", "Peek Fake", "Switch"},
            ['Air+Duck'] = {(antiaim.side ~= 1) and -3 or 3, "Center", -80, 60, 60, "Jitter", "Disabled", "Off", "Switch"}
        }
    }
    refs.desync:override(selected_preset ~= "Disabled" and true or false)
    if selected_preset ~= "Disabled" then
        refs.yaw:override("Backward")
        refs.yawbase:override((((menu.manuals:get() == "Left" or menu.manuals:get() == "Right") and menu.mandisabler:get(2)) or ((menu.mandisabler:get() == "Freestanding") and menu.attdisabler:get(2))) and "Local View" or "At Target")
        if selected_preset ~= "Custom" then
            local current_preset_settings = default_presets[selected_preset == "Melancholic" and 1 or 2][player_state]
            antiaim.set_preset(current_preset_settings)
            aastate = (selected_preset == "Melancholic" and 1 or 2)
        else
            aastate = 3
            local state_aa, weapon
            if player_state == 'Air+Duck' and anitaim_condition[7].override:get() then
                state_id = 7
            elseif player_state == 'Air' and anitaim_condition[6].override:get() then
                state_id = 6
            elseif player_state == 'Crouching' and anitaim_condition[3].override:get() then
                state_id = 3
            elseif player_state == 'Slowwalking' and anitaim_condition[4].override:get() then
                state_id = 4
            elseif player_state == 'Moving' and anitaim_condition[5].override:get() then
                state_id = 5
            elseif player_state == 'Standing' and anitaim_condition[2].override:get() then
                state_id = 2
            else
                state_id = 1
            end
            local condition = (anitaim_condition[state_id] ~= nil and anitaim_condition[state_id] or anitaim_condition[1])
            if active_weapon ~= nil then
                local weapon_id = active_weapon:get_weapon_index()
                if (weapon_id == 1 or weapon_id == 2 or weapon_id == 3 or weapon_id == 4 or weapon_id == 30 or weapon_id == 32 or weapon_id == 36 or weapon_id == 61 or weapon_id == 63 or weapon_id == 64) and condition[4].override:get() then weapon = 4 elseif weapon_id == 40 and condition[3].override:get() then weapon = 3 elseif (weapon_id == 9 or weapon_id == 11 or weapon_id == 38) and condition[2].override:get() then weapon = 2 else weapon = 1 end
            end
            local weapon_condition = (condition[weapon] ~= nil and condition[weapon] or condition[1])
            local condition_preset = (weapon_condition.preset:get() == nil and "Custom" or weapon_condition.preset:get())
            if (condition_preset ~= "Custom") then
                local current_preset_settings = default_presets[(condition_preset == "Adaptive Center") and 1 or 2][player_state]
                antiaim.set_preset(current_preset_settings)
            else
                local condition = weapon_condition
                local ui_modifier_mode = condition.modifier_mode:get()
                local ui_jitter = condition.jitter:get()
                local ui_jitter_value = condition.jitter_value:get()
                local ui_jitter_value1 = condition.jitter_value1:get()
                local ui_yaw_mode = condition.yaw_mode:get()
                local ui_switch_ticks = condition.switch_ticks:get()
                local ui_yaw_add_r = condition.yaw_add_r:get()
                local ui_yaw_add_l = condition.yaw_add_l:get()
                local ui_left_desync_value = condition.left_desync_value:get()
                local ui_right_desync_value = condition.right_desync_value:get()
                local ui_fake_type = condition.fake_type:get()
                local nearest = ragebot.nearest()
                if anti_bruteforce.work and menu.anti_brute:get() and nearest ~= nil then
                    local i = anti_bruteforce.memory[nearest:get_index()].count
                    if i > 0 then
                        local items = menu.anti_brute_data[i]

                        local antibrute_state_aa
                        if player_state == 'Air+Duck' and items[7].override:get() then
                            antibrute_state_aa = 7
                        elseif player_state == 'Air' and items[6].override:get() then
                            antibrute_state_aa = 6
                        elseif player_state == 'Crouching' and items[3].override:get() then
                            antibrute_state_aa = 3
                        elseif player_state == 'Slowwalking' and items[4].override:get() then
                            antibrute_state_aa = 4
                        elseif player_state == 'Moving' and items[5].override:get() then
                            antibrute_state_aa = 5
                        elseif player_state == 'Standing' and items[2].override:get() then
                            antibrute_state_aa = 2
                        else
                            antibrute_state_aa = 1
                        end
                     
                        local settings = items[antibrute_state_aa]

                        if settings.yaw_add.checkbox:get() then
                            ui_yaw_add_r = settings.yaw_add.yaw_add_r:get()
                            ui_yaw_add_l = settings.yaw_add.yaw_add_l:get()
                        end

                        if settings.fake.checkbox:get() then
                            local fake = settings.fake.slider:get()
                            ui_left_desync_value = fake
                            ui_right_desync_value = fake
                        end
                     
                        if settings.jitter.checkbox:get() then
                            ui_jitter = settings.jitter.combo:get()

                            ui_modifier_mode = settings.modifier_mode:get()
                         
                            if ui_modifier_mode == "Static" then
                                ui_jitter_value = settings.jitter_value:get()
                            else
                                ui_jitter_value = settings.jitter_value:get()
                                ui_jitter_value1 = settings.jitter_value1:get()
                            end
                        end
                    end
                end
             
                local jitter_value
                if ui_modifier_mode == "Static" then
                    jitter_value = ui_jitter_value
                elseif ui_modifier_mode == "Random" then
                    jitter_value = math.random(ui_jitter_value, ui_jitter_value1)
                else
                    jitter_value = antiaim.side == 1 and ui_jitter_value or ui_jitter_value1
                end

                local invert
                if ui_yaw_mode == "Jitter" then
                    invert = (ui_switch_ticks / 2 <= (globals.tickcount % ui_switch_ticks)) and ui_yaw_add_r or ui_yaw_add_l
                else
                    if condition.fake_option:get(3) then
                        local rndm = math.random(0, 1) == 0
                        invert = rndm and ui_yaw_add_r or ui_yaw_add_l
                    elseif condition.fake_option:get(2) then
                        invert = antiaim.side == 1 and ui_yaw_add_r or ui_yaw_add_l
                    else
                        invert = refs.inverter:get_override() and ui_yaw_add_r or ui_yaw_add_l
                    end
                end

                refs.yawoffset:override(0)

                local override_yaw_offset, override_limit, override_inverter
                if condition.fake_option:get(3) then
                    override_yaw_offset = antiaim.override_yaw(invert, jitter_value, ui_jitter)

                    local rndm = math.random(0, 1) == 0
                    if ui_fake_type == 0 then
                        override_limit = rndm and ui_left_desync_value or ui_right_desync_value
                    else
                        override_limit = math.random(ui_left_desync_value, ui_right_desync_value)
                    end

                    override_inverter = rndm
                elseif condition.fake_option:get(2) then
                    override_yaw_offset = antiaim.override_yaw(invert, jitter_value, ui_jitter)

                    if ui_fake_type == 0 then
                        override_limit = antiaim.side ~= 1 and ui_left_desync_value or ui_right_desync_value
                    else
                        override_limit = math.random(ui_left_desync_value, ui_right_desync_value)
                    end
                 
                    override_inverter = antiaim.side ~= 1
                else
                    override_yaw_offset = antiaim.override_yaw(invert, jitter_value, ui_jitter)

                    if ui_fake_type == 0 then
                        override_limit = refs.inverter:get_override() and ui_left_desync_value or ui_right_desync_value
                    else
                        override_limit = math.random(ui_left_desync_value, ui_right_desync_value)
                    end
                    override_inverter = refs.inverter:get()
                end

                refs.yawoffset:override(manualfunc() ~= 0 and manualfunc() or ragebot.normalize_yaw(override_yaw_offset))
                refs.leftdesync:override((((menu.manuals:get() == "Right" or menu.manuals:get() == "Left") and menu.mandisabler:get(1)) or ((menu.manuals:get() == "Freestanding") and menu.attdisabler:get(1))) and 60 or override_limit)
                refs.rightdesync:override((((menu.manuals:get() == "Right" or menu.manuals:get() == "Left") and menu.mandisabler:get(1)) or ((menu.manuals:get() == "Freestanding") and menu.attdisabler:get(1))) and 60 or override_limit)
                refs.inverter:override(override_inverter)
                refs.yawmod:override((((menu.manuals:get() == "Right" or menu.manuals:get() == "Left") and menu.mandisabler:get(1)) or ((menu.manuals:get() == "Freestanding") and menu.attdisabler:get(1))) and "Disabled" or ui_jitter)
                refs.yawmodoffset:override(jitter_value)
                refs.fakeopt:override((((menu.manuals:get() == "Right" or menu.manuals:get() == "Left") and menu.mandisabler:get(1)) or ((menu.manuals:get() == "Freestanding") and menu.attdisabler:get(1))) and "" or condition.fake_option:get())
                refs.desyncfs:override((((menu.manuals:get() == "Right" or menu.manuals:get() == "Left") and menu.mandisabler:get(1)) or ((menu.manuals:get() == "Freestanding") and menu.attdisabler:get(1))) and "Off" or condition.freestand_desync:get())
            end
        end
    end

    if bit.band(cmd.buttons, 32) ~= 32 then
        refs.pitch:override("Down")
    end

    if menu.presets == "Disabled" then
       refs.pitch:override("Disabled")
    end

    local active_weapon = entity.get_local_player():get_player_weapon()
    if active_weapon == nil then
        return
    end
    local weapon_id = active_weapon:get_weapon_index()
 
    if menu.anti_hit_helpers:get(1) and bit.band(cmd.buttons, 32) == 32 then
        local localplayer = entity.get_local_player()
        local distance = 100
        local bomb = entity.get_entities("CPlantedC4")[1]

        if bomb ~= nil then
            local bomb_pos = bomb["m_vecOrigin"]
            local player_pos = localplayer["m_vecOrigin"]
            distance = vector(bomb_pos.x, bomb_pos.y, bomb_pos.z):dist(vector(player_pos.x, player_pos.y, player_pos.z))
        end
     
        local team_num = localplayer["m_iTeamNum"]
        local defusing = team_num == 3 and distance < 62

        local on_bombsite = localplayer["m_bInBombZone"]

        local trynna_plant = on_bombsite and (team_num == 2) and (localplayer:get_player_weapon():get_weapon_index() == 49) and menu.anti_hit_helpers:get(2)
     
        local eyepos = localplayer:get_eye_position()
        local viewangles = localplayer:get_angles()
 
        local sin_pitch = math.sin(math.rad(viewangles.x))
        local cos_pitch = math.cos(math.rad(viewangles.x))
        local sin_yaw = math.sin(math.rad(viewangles.y))
        local cos_yaw = math.cos(math.rad(viewangles.y))

        local dir_vec = {
            cos_pitch * cos_yaw,
            cos_pitch * sin_yaw,
            -sin_pitch
        }

        local trace = utils.trace_line(eyepos, vector(eyepos.x + (dir_vec[1] * 8192), eyepos.y + (dir_vec[2] * 8192), eyepos.z + (dir_vec[3] * 8192)), localplayer, 0x4600400B)

        local using = true

        if trace.did_hit ~= nil then
            for i=0, #classnames do
                if trace.entity:get_classname() == classnames[i] then
                    using = false
                end
            end
        end

        if not using and not trynna_plant and not defusing then
            legitaa_enabled = true
            if menu.legitaa:get() == "Static" then
                refs.pitch:override("Disabled")
                refs.leftdesync:override(60)
                refs.rightdesync:override(60)
                refs.fakeopt:override("Avoid Overlap")
                refs.yaw:override("Backward")
                refs.yawbase:override("Local View")
                refs.yawoffset:override(180)
                refs.desyncfs:override("Peek Fake")
                cmd.buttons = bit.band(cmd.buttons, bit.bnot(32))
            else
                refs.pitch:override("Disabled")
                refs.leftdesync:override(60)
                refs.rightdesync:override(60)
                refs.fakeopt:override("Jitter")
                refs.yaw:override("Backward")
                refs.yawbase:override("Local View")
                refs.yawoffset:override(180)
                refs.yawmod:override("Center")
                refs.yawmodoffset:override(-75)
                refs.desyncfs:override("Off")
                cmd.buttons = bit.band(cmd.buttons, bit.bnot(32))
            end
        else
            legitaa_enabled = false
        end
    end
end

antiaim.better_hs = function()
    if menu.anti_hit_helpers:get(4) and refs.hide_shots:get() then
        rage.exploit:force_charge()
    end
end

antiaim.shit_aa_on_warmup = function()
    if menu.anti_hit_helpers:get(3) and entity.get_game_rules()['m_bWarmupPeriod'] and legitaa_enabled == false then
        if not off_legit_aa then
            refs.yawoffset:override(math.random(-30, 30))
            refs.leftdesync:override(math.random(0, 40))
            refs.rightdesync:override(math.random(0, 40))
        end
    end
end


anti_bruteforce.override_limit = function(angle, isoverride)
    if angle < 0 then
        if isoverride and menu.anti_brute_switch:get() then refs.inverter:override(true) end
        refs.leftdesync:override(math.abs(angle))
        refs.rightdesync:override(math.abs(angle))
    elseif angle == 0 or angle > 0 then
        if isoverride and menu.anti_brute_switch:get() then refs.inverter:override(false) end
        refs.leftdesync:override(angle)
        refs.rightdesync:override(angle)
    end
end

anti_bruteforce.vec_closest_point_on_ray = function(target, ray_start, ray_end)
    local to = target - ray_start
    local direction = ray_end - ray_start
    local ray_length = #direction
    direction.x = direction.x / ray_length
    direction.y = direction.y / ray_length
    direction.z = direction.z / ray_length
    local direction_along = direction.x * to.x + direction.y * to.y + direction.z * to.z
    if direction_along < 0 then return ray_start end
    if direction_along > ray_length then return ray_end end
    return vector(ray_start.x + direction.x * direction_along, ray_start.y + direction.y * direction_along, ray_start.z + direction.z * direction_along)
end

anti_bruteforce.tick_work = 0
anti_bruteforce.distance = 0
anti_bruteforce.bullet_impact = function(eye_pos, eyepos, impact)
    anti_bruteforce.distance = anti_bruteforce.vec_closest_point_on_ray(eye_pos, eyepos, impact):dist(eye_pos)
    if anti_bruteforce.distance > 55 then return end
    anti_bruteforce.tick_work = globals.tickcount
end

anti_bruteforce.handle_brutforcetime = function()
    if menu.presets == "Disabled" then return end
    for i, var in ipairs(anti_bruteforce.work_memory) do
        if i > 1 then table.remove(anti_bruteforce.work_memory,i) end
        anti_bruteforce.work = true
        anti_bruteforce.work_value = globals.realtime - var.time
    end
end

anti_bruteforce.count = 0
anti_bruteforce.anti_bruteforcee = function(e)
        if menu.presets == "Disabled" then return end
        if anti_bruteforce.tick_work == globals.tickcount then return end
        if not globals.is_connected then return end
        if not entity.get_local_player():is_alive() then return end
        if not entity.get(e.userid, true) then return end
        if not e.userid then return end
        if entity.get(e.userid, true):is_alive() == false then return end
        if entity.get(e.userid, true):is_dormant() then return end
        if not entity.get(e.userid, true):is_enemy() then return end
        if not menu.anti_brute:get() then return end
        local impact = vector(e.x, e.y, e.z)
        local eyepos = entity.get(e.userid, true):get_eye_position()
        local eye_pos = entity.get_local_player():get_eye_position()
        local head_vec = anti_bruteforce.bullet_impact(eye_pos, eyepos, impact)
        if anti_bruteforce.distance < 55 then
            local index = entity.get(e.userid, true):get_index()
            anti_bruteforce.memory[index].count = anti_bruteforce.memory[index].count + 1
            if menu.phases:get() < anti_bruteforce.memory[index].count then anti_bruteforce.memory[index].count = 1 end
            anti_bruteforce.count = anti_bruteforce.memory[index].count
            utils.execute_after(menu.anti_brute_reset_time:get(), function() anti_bruteforce.memory[index].count = 0 end)
            table.insert(miscellaneous.stuff, {text2 = {name = '', hit = 'Switch due to shot [dst: ', who = ('%.0f'):format(anti_bruteforce.distance), in_the = ']', where = '', for_ = '', how_much = '', damage = '', how_muc_r = '', health = '' }, alpha = 0, alpha1 = 0, type = 'Hit', time = globals.realtime})
            table.insert(anti_bruteforce.work_memory, 1, {time = globals.realtime})
        end
end

anti_bruteforce.resetter = function(e)
    if menu.presets == "Disabled" and not menu.anti_brute_resetter:get() then return end
    if e.userid == nil then return end
    if not globals.is_connected then return end
    if not entity.get(e.userid, true) then return end
    if entity.get(e.userid, true):is_alive() == false then return end
    if entity.get(e.userid, true):is_dormant() then return end
    if entity.get_local_player() == nil then return end
    if entity.get(e.userid, true) == entity.get_local_player() then
        anti_bruteforce.memory[entity.get(e.attacker, true):get_index()].count = 0
        table.insert(miscellaneous.stuff, {text2 = {name = '', hit = 'Reset Brute-Force Data', who = '', in_the = '', where = '', for_ = '', how_much = '', damage = '', how_muc_r = '', health = '' }, alpha = 0, alpha1 = 0, type = 'Hit', time = globals.realtime})
    end
end

--vis++
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

local function logsclr(color)
    local output = ''
    output = output .. ('\a%02x%02x%02x'):format(color.r, color.g, color.b)
    return output
end

ui.sidebar(gradient_text(0, 40, 255, 255, 245, 0, 245, 255, "melancholia.ws"), "check")

hooked_function = nil
ground_ticks, end_time = 1, 0
function updateCSA_hk(thisptr, edx)
    if entity.get_local_player() == nil or ffi.cast('uintptr_t', thisptr) == nil then return end
    local local_player = entity.get_local_player()
    local lp_ptr = get_entity_address(local_player:get_index())
    if menu.animbreakers:get("Follow direction") then
        ffi.cast('float*', lp_ptr+10104)[0] = 1
        refs.legmovement:set('Sliding')
    end
    if menu.animbreakers:get("Zero pitch on land") then
        ffi.cast('float*', lp_ptr+10104)[12] = 0
    end
    hooked_function(thisptr, edx)
    if menu.animbreakers:get("Static legs in air") then
        ffi.cast('float*', lp_ptr+10104)[6] = 1
    end
    if menu.animbreakers:get("Zero pitch on land") then
        if bit.band(entity.get_local_player()["m_fFlags"], 1) == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime  + 1
        end
        if not in_air() and ground_ticks > 1 and end_time > globals.curtime then
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

local function aimack(shot)
    if refs.auto_peek:get() and refs.double_tap:get() and menu.ideal_tick:get() then
        rage.exploit:force_teleport()
        rage.exploit:force_charge()
        ragebot.gjioer = true
        ragebot.teleport_tick = 0
    end
    if not menu.misctab:get(5) then return end
    local hitgroup = hitgroup_str[shot.hitgroup]
    local misscolor = logsclr(menu.misscolor:get())
    local hitcolor = logsclr(menu.hitcolor:get())
    if shot.state == nil then
        if menu.hitlogs:get(2) then
            print_raw(("\aFFFFFF["..hitcolor.."melancholia\aFFFFFF] Registered shot in "..shot.target:get_name().."\'s "..hitcolor..hitgroup_str[shot.hitgroup].."\aFFFFFF for "..hitcolor..shot.damage.."\aFFFFFF("..hitcolor..shot.wanted_damage.."\aFFFFFF) (hitchance: "..hitcolor..shot.hitchance.."% \aFFFFFF| history(Δ): "..hitcolor..shot.backtrack.." \aFFFFFF| flags: "..hitcolor..(refs.double_tap:get() and 1 or 0)..(refs.hide_shots:get() and 1 or 0).."\aFFFFFF)"))
        end
        table.insert(miscellaneous.stuff, {text2 = {
            name = '',
            hit = 'Hit ',
            who = shot.target:get_name(),
            in_the = ' in the ',
            where = hitgroup_str[shot.hitgroup],
            for_ = ' for ',
            how_much = shot.damage,
            damage = ' damage (',
            how_muc_r = tostring(math.max(shot.target['m_iHealth'], 0)),
            health = ' health remaining)'
        }, alpha = 0, alpha1 = 0, type = 'Hit', time = globals.realtime})
    else
        if menu.hitlogs:get(2) then
            print_raw(("\aFFFFFF["..misscolor.."melancholia\aFFFFFF] Missed shot in "..shot.target:get_name().."\'s "..misscolor..hitgroup_str[shot.wanted_hitgroup].."\aFFFFFF due to "..misscolor..shot.state.." \aFFFFFF(hitchance: "..misscolor..shot.hitchance.."% \aFFFFFF| history(Δ): "..misscolor..shot.backtrack.." \aFFFFFF| flags: "..misscolor..(refs.double_tap:get() and 1 or 0)..(refs.hide_shots:get() and 1 or 0).."\aFFFFFF)"))
        end
        table.insert(miscellaneous.stuff,{text2 = {
            name = '',
            hit = 'Missed ',
            who = shot.target:get_name(),
            in_the = ' in the ',
            where = hitgroup_str[shot.wanted_hitgroup],
            for_ = ' due to ',
            how_much = shot.state,
            damage = '',
            how_muc_r = '',
            health = ''
        }, alpha = 0, alpha1 = 0, type = 'Miss', time = globals.realtime})
    end
end

local function resetter() if menu.anti_brute_resetter:get() then anti_bruteforce.work_memory = {} anti_bruteforce.memory = {} end end
local function smartpreset()
    if menu.presets1:get() ~= "Smart" then return end
    if menu.smartrandomsw:get() and menu.smartrandom:get() == "Random" then
        local zxc = (aastate + math.random(0, 2))
        if zxc == 4 then zxc = 1 elseif zxc == 5 then zxc = 2 end
        if zxc ~= aastate then aastate = zxc else zxc = (aastate + math.random(0, 2)) aastate = zxc end
    elseif not menu.smartrandomsw:get() and menu.smartrandom:get() == "Random" then
        local zxc = (aastate + math.random(0, 2))
        if zxc == 4 then zxc = 1 elseif zxc == 5 then zxc = 2 end
        aastate = zxc
    else
        if aastate == 3 then aastate = 1 else aastate = aastate + 1 end
    end
    if menu.presets1:get() ~= "Smart" then preset1 = menu.presets1:get() else preset1 = aastate2cond[aastate] end
    menu.presets = preset1
end

local function bestfob()
    local curfov = enemyfov()
    if not entity.get_local_player() then return end
    if curfov == nil then curfov = 180 end
    if menu.silentaim:get() then
        if curfov < (menu.customfov:get() == "Default" and 5 or menu.customfovslider:get()) then ui.find("Aimbot", "Ragebot", "MAIN", "Enabled", "Silent Aim"):override(false) else ui.find("Aimbot", "Ragebot", "MAIN", "Enabled", "Silent Aim"):override(ui.find("Aimbot", "Ragebot", "MAIN", "Enabled", "Silent Aim"):get()) end
    else
        ui.find("Aimbot", "Ragebot", "MAIN", "Enabled", "Silent Aim"):override(ui.find("Aimbot", "Ragebot", "MAIN", "Enabled", "Silent Aim"):get())
    end
end

local weaptable = {[1] = 4, [2] = 4, [3] = 4, [4] = 4, [9] = 1, [11] = 2, [30] = 4, [32] = 4, [36] = 4, [38] = 2, [50] = 3, [61] = 4, [63] = 4, [64] = 5}


events.player_hurt:set(function(e)
    local me = entity.get_local_player()
    local attacker = entity.get(e.attacker, true)
    if me ~= attacker or attacker == nil then return end
    local weapon = tostring(e.weapon)
    local hittype = "Hit"
    if weapon == 'hegrenade' then hittype = 'naded'; elseif weapon == 'inferno' then hittype = 'burned'; elseif weapon == 'knife' then hittype = 'knifed'; end
    if weapon ~= "hegrenade" and weapon ~= "inferno" and weapon ~= "knife" then return end
    local target_id = entity.get(e.userid, true)
    if target_id == nil then return end
    local target_name = target_id:get_name()
    local server_damage = e.dmg_health
    local health = (target_id.m_iHealth)-server_damage
    if health < 0 then health = 0 end
    table.insert(miscellaneous.stuff,{text2 = {
        name = '',
        hit = hittype..' ',
        who = target_name,
        in_the = ' for ',
        where = server_damage,
        for_ = ' damage (',
        how_much = health,
        damage = ' remaining)',
        how_muc_r = '',
        health = ''
    }, alpha = 0, alpha1 = 0, type = 'Hit', time = globals.realtime})
end)

local function customhitchance()
    if not entity.get_local_player() then return end
    if not entity.get_local_player():is_alive() then return end
    if entity.get_local_player():get_player_weapon() == nil then return end
    if entity.get_local_player():get_player_weapon():get_weapon_index() == nil then return end
    if weaptable[entity.get_local_player():get_player_weapon():get_weapon_index()] == 1 and menu.nshc:get(1) and not entity.get_local_player().m_bIsScoped then ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override((menu.awphcns:get()))
    elseif weaptable[entity.get_local_player():get_player_weapon():get_weapon_index()] == 2 and menu.nshc:get(2) and not entity.get_local_player().m_bIsScoped then ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override((menu.autohcns:get()))
    elseif weaptable[entity.get_local_player():get_player_weapon():get_weapon_index()] == 3 and menu.nshc:get(3) and not entity.get_local_player().m_bIsScoped then ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override((menu.schcns:get()))
    elseif weaptable[entity.get_local_player():get_player_weapon():get_weapon_index()] == 1 and menu.airhc:get(1) and in_air() then ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override((menu.hcair2:get()))
    elseif weaptable[entity.get_local_player():get_player_weapon():get_weapon_index()] == 2 and menu.airhc:get(2) and in_air() then ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override((menu.hcair3:get()))
    elseif weaptable[entity.get_local_player():get_player_weapon():get_weapon_index()] == 3 and menu.airhc:get(3) and in_air() then ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override((menu.hcair4:get()))
    elseif weaptable[entity.get_local_player():get_player_weapon():get_weapon_index()] == 4 and menu.airhc:get(4) and in_air() then ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override((menu.hcair5:get()))
    elseif weaptable[entity.get_local_player():get_player_weapon():get_weapon_index()] == 5 and menu.airhc:get(5) and in_air() then ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override((menu.hcair6:get()))
    else ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override(ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):get())
    end
end

local function asfix()
    if not entity.get_local_player() then return end
    if not entity.get_local_player():is_alive() then return end
    if (vector(entity.get_local_player().m_vecVelocity.x, entity.get_local_player().m_vecVelocity.y):length()) < 36 then ui.find("MISCellaneous", "MAIN", "Movement", "Air Strafe"):override(false) else ui.find("MISCellaneous", "MAIN", "Movement", "Air Strafe"):override(ui.find("MISCellaneous", "MAIN", "Movement", "Air Strafe"):get()) end
end

---functions
local function aspectratio() currentar = menu.arr:get() if menu.misctab:get(3) then cvar.r_aspectratio:float(currentar/100) else cvar.r_aspectratio:float(0) end end
local function viewmodel() if menu.misctab:get(4) then cvar.viewmodel_fov:int(menu.vmfov:get(), true) cvar.viewmodel_offset_x:float(menu.vmx:get(), true) cvar.viewmodel_offset_y:float(menu.vmy:get(), true) cvar.viewmodel_offset_z:float(menu.vmz:get(), true) else cvar.viewmodel_fov:int(68) cvar.viewmodel_offset_x:int(1) cvar.viewmodel_offset_y:int(1) cvar.viewmodel_offset_z:int(-1) end end
local function allvisuals()
    aspectratio()
    viewmodel()
    watermark()
    kbnds()
    damage_indicator()
    indsundrcrs1()
    indicator2()
    viewmodel_in_scope()
    custom_scope()
    spectator_list()
    clantag()
    statepanelfunc()
    velocity_modifier()
    buttonfix()
    indicatoridealtick()
    bestfob()
    hitlog_draw()
end
events.render:set(function() allvisuals() end)
events.aim_ack:set(function(shot) count_shots(shot) aimack(shot) end)
events.round_prestart:set(function() smartpreset() end)
events.bullet_impact:set(function(e) anti_bruteforce.anti_bruteforcee(e) end)
events.createmove:set(function(cmd) antiaim.conditions(cmd) antiaim.shit_aa_on_warmup() antiaim.better_hs() end)
events.createmove:set(function() anti_bruteforce.handle_brutforcetime() customhitchance() asfix() update_ref() end)



export_cfg:set_callback(function()
    local protected = function()
        local cfg_data = {}
        for key, value in pairs(menu_items.items) do
            local ui_value = value:get()
            if type(ui_value) == "userdata" then
                cfg_data[key] = ui_value:to_hex()
            else
                cfg_data[key] = ui_value
            end
        end
        cfg_data["loadusername"] = common.get_username()
        local json_config = json.stringify(cfg_data)
        local encoded_config = base64.encode(json_config)
        clipboard.set("melancholia_"..encoded_config)
        table.insert(miscellaneous.stuff,{text2 = {
            name = '',
            hit = 'config has been succecfully',
            who = " exported",
            in_the = '',
            where = '',
            for_ = '',
            how_much = "",
            damage = '',
            how_muc_r = '',
            health = ''
        }, alpha = 0, alpha1 = 0, type = 'Hit', time = globals.realtime})
    end
    local status, message = pcall(protected)
    if not status then
        return
    end
end)

config_load = function(text)
    local protected = function()
        local text = base64.decode(text)
        local cfg_data = json.parse(text)
        if cfg_data ~= nil then
            for key, value in pairs(cfg_data) do
                local item = menu_items.items[key]
                if item ~= nil then
                    local invalue = value
                    item:set(invalue)
                end
            end
            table.insert(miscellaneous.stuff,{text2 = {
                name = '',
                hit = 'config by ',
                who = cfg_data["loadusername"],
                in_the = ' has been succecfully ',
                where = '',
                for_ = '',
                how_much = "imported",
                damage = '',
                how_muc_r = '',
                health = ''
            }, alpha = entity.get_local_player() and 0 or 1, alpha1 = entity.get_local_player() and 0 or 1, type = 'Hit', time = globals.realtime})
        end
    end

    local status, message = pcall(protected)
    if not status then
        table.insert(miscellaneous.stuff,{text2 = {
            name = '',
            hit = 'failed to ',
            who = 'import',
            in_the = ' current ',
            where = '',
            for_ = '',
            how_much = "config",
            damage = '',
            how_muc_r = '',
            health = ''
        }, alpha = entity.get_local_player() and 0 or 1, alpha1 = entity.get_local_player() and 0 or 1, type = 'Miss', time = globals.realtime})
        return
    end
end

import_cfg:set_callback(function()
    config_load(clipboard.get():gsub("melancholia_", ""))
end)

defcfg:set_callback(function()
config_load([[eyJhX2IubzEwMSI6dHJ1ZSwiYV9iLm8xMDIiOmZhbHNlLCJhX2IubzEwMyI6ZmFsc2UsImFfYi5vMTA0IjpmYWxzZSwiYV9iLm8xMDUiOmZhbHNlLCJhX2IubzEwNiI6ZmFsc2UsImFfYi5vMTA3IjpmYWxzZSwiYV9iLm8xMSI6dHJ1ZSwiYV9iLm8xMiI6ZmFsc2UsImFfYi5vMTMiOnRydWUsImFfYi5vMTQiOmZhbHNlLCJhX2IubzE1Ijp0cnVlLCJhX2IubzE2IjpmYWxzZSwiYV9iLm8xNyI6dHJ1ZSwiYV9iLm8yMSI6dHJ1ZSwiYV9iLm8yMiI6ZmFsc2UsImFfYi5vMjMiOnRydWUsImFfYi5vMjQiOmZhbHNlLCJhX2IubzI1IjpmYWxzZSwiYV9iLm8yNiI6ZmFsc2UsImFfYi5vMjciOmZhbHNlLCJhX2IubzMxIjp0cnVlLCJhX2IubzMyIjpmYWxzZSwiYV9iLm8zMyI6ZmFsc2UsImFfYi5vMzQiOmZhbHNlLCJhX2IubzM1IjpmYWxzZSwiYV9iLm8zNiI6ZmFsc2UsImFfYi5vMzciOmZhbHNlLCJhX2IubzQxIjp0cnVlLCJhX2IubzQyIjpmYWxzZSwiYV9iLm80MyI6ZmFsc2UsImFfYi5vNDQiOmZhbHNlLCJhX2IubzQ1IjpmYWxzZSwiYV9iLm80NiI6ZmFsc2UsImFfYi5vNDciOmZhbHNlLCJhX2IubzUxIjp0cnVlLCJhX2IubzUyIjpmYWxzZSwiYV9iLm81MyI6ZmFsc2UsImFfYi5vNTQiOmZhbHNlLCJhX2IubzU1IjpmYWxzZSwiYV9iLm81NiI6ZmFsc2UsImFfYi5vNTciOmZhbHNlLCJhX2IubzYxIjp0cnVlLCJhX2IubzYyIjpmYWxzZSwiYV9iLm82MyI6ZmFsc2UsImFfYi5vNjQiOmZhbHNlLCJhX2IubzY1IjpmYWxzZSwiYV9iLm82NiI6ZmFsc2UsImFfYi5vNjciOmZhbHNlLCJhX2IubzcxIjp0cnVlLCJhX2IubzcyIjpmYWxzZSwiYV9iLm83MyI6ZmFsc2UsImFfYi5vNzQiOmZhbHNlLCJhX2Iubzc1IjpmYWxzZSwiYV9iLm83NiI6ZmFsc2UsImFfYi5vNzciOmZhbHNlLCJhX2IubzgxIjp0cnVlLCJhX2IubzgyIjpmYWxzZSwiYV9iLm84MyI6ZmFsc2UsImFfYi5vODQiOmZhbHNlLCJhX2Iubzg1IjpmYWxzZSwiYV9iLm84NiI6ZmFsc2UsImFfYi5vODciOmZhbHNlLCJhX2IubzkxIjp0cnVlLCJhX2IubzkyIjpmYWxzZSwiYV9iLm85MyI6ZmFsc2UsImFfYi5vOTQiOmZhbHNlLCJhX2Iubzk1IjpmYWxzZSwiYV9iLm85NiI6ZmFsc2UsImFfYi5vOTciOmZhbHNlLCJhX2JfZC5mMTAxIjpmYWxzZSwiYV9iX2QuZjEwMiI6ZmFsc2UsImFfYl9kLmYxMDMiOmZhbHNlLCJhX2JfZC5mMTA0IjpmYWxzZSwiYV9iX2QuZjEwNSI6ZmFsc2UsImFfYl9kLmYxMDYiOmZhbHNlLCJhX2JfZC5mMTA3IjpmYWxzZSwiYV9iX2QuZjExIjpmYWxzZSwiYV9iX2QuZjEyIjpmYWxzZSwiYV9iX2QuZjEzIjp0cnVlLCJhX2JfZC5mMTQiOmZhbHNlLCJhX2JfZC5mMTUiOnRydWUsImFfYl9kLmYxNiI6ZmFsc2UsImFfYl9kLmYxNyI6ZmFsc2UsImFfYl9kLmYyMSI6ZmFsc2UsImFfYl9kLmYyMTAxIjowLjAsImFfYl9kLmYyMTAyIjowLjAsImFfYl9kLmYyMTAzIjowLjAsImFfYl9kLmYyMTA0IjowLjAsImFfYl9kLmYyMTA1IjowLjAsImFfYl9kLmYyMTA2IjowLjAsImFfYl9kLmYyMTA3IjowLjAsImFfYl9kLmYyMTEiOjAuMCwiYV9iX2QuZjIxMiI6MC4wLCJhX2JfZC5mMjEzIjo1OC4wLCJhX2JfZC5mMjE0IjowLjAsImFfYl9kLmYyMTUiOjU4LjAsImFfYl9kLmYyMTYiOjAuMCwiYV9iX2QuZjIxNyI6MC4wLCJhX2JfZC5mMjIiOmZhbHNlLCJhX2JfZC5mMjIxIjowLjAsImFfYl9kLmYyMjIiOjAuMCwiYV9iX2QuZjIyMyI6NTguMCwiYV9iX2QuZjIyNCI6MC4wLCJhX2JfZC5mMjI1IjowLjAsImFfYl9kLmYyMjYiOjAuMCwiYV9iX2QuZjIyNyI6MC4wLCJhX2JfZC5mMjMiOnRydWUsImFfYl9kLmYyMzEiOjAuMCwiYV9iX2QuZjIzMiI6MC4wLCJhX2JfZC5mMjMzIjowLjAsImFfYl9kLmYyMzQiOjAuMCwiYV9iX2QuZjIzNSI6MC4wLCJhX2JfZC5mMjM2IjowLjAsImFfYl9kLmYyMzciOjAuMCwiYV9iX2QuZjI0IjpmYWxzZSwiYV9iX2QuZjI0MSI6MC4wLCJhX2JfZC5mMjQyIjowLjAsImFfYl9kLmYyNDMiOjAuMCwiYV9iX2QuZjI0NCI6MC4wLCJhX2JfZC5mMjQ1IjowLjAsImFfYl9kLmYyNDYiOjAuMCwiYV9iX2QuZjI0NyI6MC4wLCJhX2JfZC5mMjUiOmZhbHNlLCJhX2JfZC5mMjUxIjowLjAsImFfYl9kLmYyNTIiOjAuMCwiYV9iX2QuZjI1MyI6MC4wLCJhX2JfZC5mMjU0IjowLjAsImFfYl9kLmYyNTUiOjAuMCwiYV9iX2QuZjI1NiI6MC4wLCJhX2JfZC5mMjU3IjowLjAsImFfYl9kLmYyNiI6ZmFsc2UsImFfYl9kLmYyNjEiOjAuMCwiYV9iX2QuZjI2MiI6MC4wLCJhX2JfZC5mMjYzIjowLjAsImFfYl9kLmYyNjQiOjAuMCwiYV9iX2QuZjI2NSI6MC4wLCJhX2JfZC5mMjY2IjowLjAsImFfYl9kLmYyNjciOjAuMCwiYV9iX2QuZjI3IjpmYWxzZSwiYV9iX2QuZjI3MSI6MC4wLCJhX2JfZC5mMjcyIjowLjAsImFfYl9kLmYyNzMiOjAuMCwiYV9iX2QuZjI3NCI6MC4wLCJhX2JfZC5mMjc1IjowLjAsImFfYl9kLmYyNzYiOjAuMCwiYV9iX2QuZjI3NyI6MC4wLCJhX2JfZC5mMjgxIjowLjAsImFfYl9kLmYyODIiOjAuMCwiYV9iX2QuZjI4MyI6MC4wLCJhX2JfZC5mMjg0IjowLjAsImFfYl9kLmYyODUiOjAuMCwiYV9iX2QuZjI4NiI6MC4wLCJhX2JfZC5mMjg3IjowLjAsImFfYl9kLmYyOTEiOjAuMCwiYV9iX2QuZjI5MiI6MC4wLCJhX2JfZC5mMjkzIjowLjAsImFfYl9kLmYyOTQiOjAuMCwiYV9iX2QuZjI5NSI6MC4wLCJhX2JfZC5mMjk2IjowLjAsImFfYl9kLmYyOTciOjAuMCwiYV9iX2QuZjMxIjpmYWxzZSwiYV9iX2QuZjMyIjpmYWxzZSwiYV9iX2QuZjMzIjpmYWxzZSwiYV9iX2QuZjM0IjpmYWxzZSwiYV9iX2QuZjM1IjpmYWxzZSwiYV9iX2QuZjM2IjpmYWxzZSwiYV9iX2QuZjM3IjpmYWxzZSwiYV9iX2QuZjQxIjpmYWxzZSwiYV9iX2QuZjQyIjpmYWxzZSwiYV9iX2QuZjQzIjpmYWxzZSwiYV9iX2QuZjQ0IjpmYWxzZSwiYV9iX2QuZjQ1IjpmYWxzZSwiYV9iX2QuZjQ2IjpmYWxzZSwiYV9iX2QuZjQ3IjpmYWxzZSwiYV9iX2QuZjUxIjpmYWxzZSwiYV9iX2QuZjUyIjpmYWxzZSwiYV9iX2QuZjUzIjpmYWxzZSwiYV9iX2QuZjU0IjpmYWxzZSwiYV9iX2QuZjU1IjpmYWxzZSwiYV9iX2QuZjU2IjpmYWxzZSwiYV9iX2QuZjU3IjpmYWxzZSwiYV9iX2QuZjYxIjpmYWxzZSwiYV9iX2QuZjYyIjpmYWxzZSwiYV9iX2QuZjYzIjpmYWxzZSwiYV9iX2QuZjY0IjpmYWxzZSwiYV9iX2QuZjY1IjpmYWxzZSwiYV9iX2QuZjY2IjpmYWxzZSwiYV9iX2QuZjY3IjpmYWxzZSwiYV9iX2QuZjcxIjpmYWxzZSwiYV9iX2QuZjcyIjpmYWxzZSwiYV9iX2QuZjczIjpmYWxzZSwiYV9iX2QuZjc0IjpmYWxzZSwiYV9iX2QuZjc1IjpmYWxzZSwiYV9iX2QuZjc2IjpmYWxzZSwiYV9iX2QuZjc3IjpmYWxzZSwiYV9iX2QuZjgxIjpmYWxzZSwiYV9iX2QuZjgyIjpmYWxzZSwiYV9iX2QuZjgzIjpmYWxzZSwiYV9iX2QuZjg0IjpmYWxzZSwiYV9iX2QuZjg1IjpmYWxzZSwiYV9iX2QuZjg2IjpmYWxzZSwiYV9iX2QuZjg3IjpmYWxzZSwiYV9iX2QuZjkxIjpmYWxzZSwiYV9iX2QuZjkyIjpmYWxzZSwiYV9iX2QuZjkzIjpmYWxzZSwiYV9iX2QuZjk0IjpmYWxzZSwiYV9iX2QuZjk1IjpmYWxzZSwiYV9iX2QuZjk2IjpmYWxzZSwiYV9iX2QuZjk3IjpmYWxzZSwiYV9iX2QuajEwMSI6ZmFsc2UsImFfYl9kLmoxMDIiOmZhbHNlLCJhX2JfZC5qMTAzIjpmYWxzZSwiYV9iX2QuajEwNCI6ZmFsc2UsImFfYl9kLmoxMDUiOmZhbHNlLCJhX2JfZC5qMTA2IjpmYWxzZSwiYV9iX2QuajEwNyI6ZmFsc2UsImFfYl9kLmoxMSI6ZmFsc2UsImFfYl9kLmoxMTAxIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTEwMiI6IkRpc2FibGVkIiwiYV9iX2QuajExMDMiOiJEaXNhYmxlZCIsImFfYl9kLmoxMTA0IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTEwNSI6IkRpc2FibGVkIiwiYV9iX2QuajExMDYiOiJEaXNhYmxlZCIsImFfYl9kLmoxMTA3IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTExIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTEyIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTEzIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTE0IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTE1IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTE2IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTE3IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTIiOmZhbHNlLCJhX2JfZC5qMTIxIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTIyIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTIzIjoiT2Zmc2V0IiwiYV9iX2QuajEyNCI6IkRpc2FibGVkIiwiYV9iX2QuajEyNSI6IkRpc2FibGVkIiwiYV9iX2QuajEyNiI6IkRpc2FibGVkIiwiYV9iX2QuajEyNyI6IkRpc2FibGVkIiwiYV9iX2QuajEzIjp0cnVlLCJhX2JfZC5qMTMxIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTMyIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTMzIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTM0IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTM1IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTM2IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTM3IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTQiOmZhbHNlLCJhX2JfZC5qMTQxIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTQyIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTQzIjoiRGlzYWJsZWQiLCJhX2JfZC5qMTQ0IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTQ1IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTQ2IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTQ3IjoiRGlzYWJsZWQiLCJhX2JfZC5qMTUiOnRydWUsImFfYl9kLmoxNTEiOiJEaXNhYmxlZCIsImFfYl9kLmoxNTIiOiJEaXNhYmxlZCIsImFfYl9kLmoxNTMiOiJEaXNhYmxlZCIsImFfYl9kLmoxNTQiOiJEaXNhYmxlZCIsImFfYl9kLmoxNTUiOiJEaXNhYmxlZCIsImFfYl9kLmoxNTYiOiJEaXNhYmxlZCIsImFfYl9kLmoxNTciOiJEaXNhYmxlZCIsImFfYl9kLmoxNiI6ZmFsc2UsImFfYl9kLmoxNjEiOiJEaXNhYmxlZCIsImFfYl9kLmoxNjIiOiJEaXNhYmxlZCIsImFfYl9kLmoxNjMiOiJEaXNhYmxlZCIsImFfYl9kLmoxNjQiOiJEaXNhYmxlZCIsImFfYl9kLmoxNjUiOiJEaXNhYmxlZCIsImFfYl9kLmoxNjYiOiJEaXNhYmxlZCIsImFfYl9kLmoxNjciOiJEaXNhYmxlZCIsImFfYl9kLmoxNyI6ZmFsc2UsImFfYl9kLmoxNzEiOiJEaXNhYmxlZCIsImFfYl9kLmoxNzIiOiJEaXNhYmxlZCIsImFfYl9kLmoxNzMiOiJEaXNhYmxlZCIsImFfYl9kLmoxNzQiOiJEaXNhYmxlZCIsImFfYl9kLmoxNzUiOiJEaXNhYmxlZCIsImFfYl9kLmoxNzYiOiJEaXNhYmxlZCIsImFfYl9kLmoxNzciOiJEaXNhYmxlZCIsImFfYl9kLmoxODEiOiJEaXNhYmxlZCIsImFfYl9kLmoxODIiOiJEaXNhYmxlZCIsImFfYl9kLmoxODMiOiJEaXNhYmxlZCIsImFfYl9kLmoxODQiOiJEaXNhYmxlZCIsImFfYl9kLmoxODUiOiJEaXNhYmxlZCIsImFfYl9kLmoxODYiOiJEaXNhYmxlZCIsImFfYl9kLmoxODciOiJEaXNhYmxlZCIsImFfYl9kLmoxOTEiOiJEaXNhYmxlZCIsImFfYl9kLmoxOTIiOiJEaXNhYmxlZCIsImFfYl9kLmoxOTMiOiJEaXNhYmxlZCIsImFfYl9kLmoxOTQiOiJEaXNhYmxlZCIsImFfYl9kLmoxOTUiOiJEaXNhYmxlZCIsImFfYl9kLmoxOTYiOiJEaXNhYmxlZCIsImFfYl9kLmoxOTciOiJEaXNhYmxlZCIsImFfYl9kLmoyMSI6ZmFsc2UsImFfYl9kLmoyMiI6ZmFsc2UsImFfYl9kLmoyMyI6dHJ1ZSwiYV9iX2QuajI0IjpmYWxzZSwiYV9iX2QuajI1IjpmYWxzZSwiYV9iX2QuajI2IjpmYWxzZSwiYV9iX2QuajI3IjpmYWxzZSwiYV9iX2QuajMxIjpmYWxzZSwiYV9iX2QuajMyIjpmYWxzZSwiYV9iX2QuajMzIjpmYWxzZSwiYV9iX2QuajM0IjpmYWxzZSwiYV9iX2QuajM1IjpmYWxzZSwiYV9iX2QuajM2IjpmYWxzZSwiYV9iX2QuajM3IjpmYWxzZSwiYV9iX2QuajQxIjpmYWxzZSwiYV9iX2QuajQyIjpmYWxzZSwiYV9iX2QuajQzIjpmYWxzZSwiYV9iX2QuajQ0IjpmYWxzZSwiYV9iX2QuajQ1IjpmYWxzZSwiYV9iX2QuajQ2IjpmYWxzZSwiYV9iX2QuajQ3IjpmYWxzZSwiYV9iX2QuajUxIjpmYWxzZSwiYV9iX2QuajUyIjpmYWxzZSwiYV9iX2QuajUzIjpmYWxzZSwiYV9iX2QuajU0IjpmYWxzZSwiYV9iX2QuajU1IjpmYWxzZSwiYV9iX2QuajU2IjpmYWxzZSwiYV9iX2QuajU3IjpmYWxzZSwiYV9iX2QuajYxIjpmYWxzZSwiYV9iX2QuajYyIjpmYWxzZSwiYV9iX2QuajYzIjpmYWxzZSwiYV9iX2QuajY0IjpmYWxzZSwiYV9iX2QuajY1IjpmYWxzZSwiYV9iX2QuajY2IjpmYWxzZSwiYV9iX2QuajY3IjpmYWxzZSwiYV9iX2QuajcxIjpmYWxzZSwiYV9iX2QuajcyIjpmYWxzZSwiYV9iX2QuajczIjpmYWxzZSwiYV9iX2Quajc0IjpmYWxzZSwiYV9iX2Quajc1IjpmYWxzZSwiYV9iX2Quajc2IjpmYWxzZSwiYV9iX2Quajc3IjpmYWxzZSwiYV9iX2QuajgxIjpmYWxzZSwiYV9iX2QuajgyIjpmYWxzZSwiYV9iX2QuajgzIjpmYWxzZSwiYV9iX2Quajg0IjpmYWxzZSwiYV9iX2Quajg1IjpmYWxzZSwiYV9iX2Quajg2IjpmYWxzZSwiYV9iX2Quajg3IjpmYWxzZSwiYV9iX2QuajkxIjpmYWxzZSwiYV9iX2QuajkyIjpmYWxzZSwiYV9iX2QuajkzIjpmYWxzZSwiYV9iX2Quajk0IjpmYWxzZSwiYV9iX2Quajk1IjpmYWxzZSwiYV9iX2Quajk2IjpmYWxzZSwiYV9iX2Quajk3IjpmYWxzZSwiYV9iX2QubGUxMDEiOmZhbHNlLCJhX2JfZC5sZTEwMiI6ZmFsc2UsImFfYl9kLmxlMTAzIjpmYWxzZSwiYV9iX2QubGUxMDQiOmZhbHNlLCJhX2JfZC5sZTEwNSI6ZmFsc2UsImFfYl9kLmxlMTA2IjpmYWxzZSwiYV9iX2QubGUxMDciOmZhbHNlLCJhX2JfZC5sZTExIjp0cnVlLCJhX2JfZC5sZTEyIjpmYWxzZSwiYV9iX2QubGUxMyI6dHJ1ZSwiYV9iX2QubGUxNCI6ZmFsc2UsImFfYl9kLmxlMTUiOnRydWUsImFfYl9kLmxlMTYiOmZhbHNlLCJhX2JfZC5sZTE3IjpmYWxzZSwiYV9iX2QubGUyMSI6ZmFsc2UsImFfYl9kLmxlMjEwMSI6IkRpc2FibGVkIiwiYV9iX2QubGUyMTAyIjoiRGlzYWJsZWQiLCJhX2JfZC5sZTIxMDMiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjEwNCI6IkRpc2FibGVkIiwiYV9iX2QubGUyMTA1IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTIxMDYiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjEwNyI6IkRpc2FibGVkIiwiYV9iX2QubGUyMTEiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjEyIjoiRGlzYWJsZWQiLCJhX2JfZC5sZTIxMyI6IkRpc2FibGVkIiwiYV9iX2QubGUyMTQiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjE1IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTIxNiI6IkRpc2FibGVkIiwiYV9iX2QubGUyMTciOiJEaXNhYmxlZCIsImFfYl9kLmxlMjIiOmZhbHNlLCJhX2JfZC5sZTIyMSI6IkRpc2FibGVkIiwiYV9iX2QubGUyMjIiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjIzIjoiT3Bwb3NpdGUiLCJhX2JfZC5sZTIyNCI6IkRpc2FibGVkIiwiYV9iX2QubGUyMjUiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjI2IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTIyNyI6IkRpc2FibGVkIiwiYV9iX2QubGUyMyI6dHJ1ZSwiYV9iX2QubGUyMzEiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjMyIjoiRGlzYWJsZWQiLCJhX2JfZC5sZTIzMyI6IkRpc2FibGVkIiwiYV9iX2QubGUyMzQiOiJEaXNhYmxlZCIsImFfYl
9kLmxlMjM1IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTIzNiI6IkRpc2FibGVkIiwiYV9iX2QubGUyMzciOiJEaXNhYmxlZCIsImFfYl9kLmxlMjQiOmZhbHNlLCJhX2JfZC5sZTI0MSI6IkRpc2FibGVkIiwiYV9iX2QubGUyNDIiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjQzIjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI0NCI6IkRpc2FibGVkIiwiYV9iX2QubGUyNDUiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjQ2IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI0NyI6IkRpc2FibGVkIiwiYV9iX2QubGUyNSI6ZmFsc2UsImFfYl9kLmxlMjUxIjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI1MiI6IkRpc2FibGVkIiwiYV9iX2QubGUyNTMiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjU0IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI1NSI6IkRpc2FibGVkIiwiYV9iX2QubGUyNTYiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjU3IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI2IjpmYWxzZSwiYV9iX2QubGUyNjEiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjYyIjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI2MyI6IkRpc2FibGVkIiwiYV9iX2QubGUyNjQiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjY1IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI2NiI6IkRpc2FibGVkIiwiYV9iX2QubGUyNjciOiJEaXNhYmxlZCIsImFfYl9kLmxlMjciOmZhbHNlLCJhX2JfZC5sZTI3MSI6IkRpc2FibGVkIiwiYV9iX2QubGUyNzIiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjczIjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI3NCI6IkRpc2FibGVkIiwiYV9iX2QubGUyNzUiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjc2IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI3NyI6IkRpc2FibGVkIiwiYV9iX2QubGUyODEiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjgyIjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI4MyI6IkRpc2FibGVkIiwiYV9iX2QubGUyODQiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjg1IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI4NiI6IkRpc2FibGVkIiwiYV9iX2QubGUyODciOiJEaXNhYmxlZCIsImFfYl9kLmxlMjkxIjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI5MiI6IkRpc2FibGVkIiwiYV9iX2QubGUyOTMiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjk0IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTI5NSI6IkRpc2FibGVkIiwiYV9iX2QubGUyOTYiOiJEaXNhYmxlZCIsImFfYl9kLmxlMjk3IjoiRGlzYWJsZWQiLCJhX2JfZC5sZTMxIjpmYWxzZSwiYV9iX2QubGUzMiI6ZmFsc2UsImFfYl9kLmxlMzMiOmZhbHNlLCJhX2JfZC5sZTM0IjpmYWxzZSwiYV9iX2QubGUzNSI6ZmFsc2UsImFfYl9kLmxlMzYiOmZhbHNlLCJhX2JfZC5sZTM3IjpmYWxzZSwiYV9iX2QubGU0MSI6ZmFsc2UsImFfYl9kLmxlNDIiOmZhbHNlLCJhX2JfZC5sZTQzIjpmYWxzZSwiYV9iX2QubGU0NCI6ZmFsc2UsImFfYl9kLmxlNDUiOmZhbHNlLCJhX2JfZC5sZTQ2IjpmYWxzZSwiYV9iX2QubGU0NyI6ZmFsc2UsImFfYl9kLmxlNTEiOmZhbHNlLCJhX2JfZC5sZTUyIjpmYWxzZSwiYV9iX2QubGU1MyI6ZmFsc2UsImFfYl9kLmxlNTQiOmZhbHNlLCJhX2JfZC5sZTU1IjpmYWxzZSwiYV9iX2QubGU1NiI6ZmFsc2UsImFfYl9kLmxlNTciOmZhbHNlLCJhX2JfZC5sZTYxIjpmYWxzZSwiYV9iX2QubGU2MiI6ZmFsc2UsImFfYl9kLmxlNjMiOmZhbHNlLCJhX2JfZC5sZTY0IjpmYWxzZSwiYV9iX2QubGU2NSI6ZmFsc2UsImFfYl9kLmxlNjYiOmZhbHNlLCJhX2JfZC5sZTY3IjpmYWxzZSwiYV9iX2QubGU3MSI6ZmFsc2UsImFfYl9kLmxlNzIiOmZhbHNlLCJhX2JfZC5sZTczIjpmYWxzZSwiYV9iX2QubGU3NCI6ZmFsc2UsImFfYl9kLmxlNzUiOmZhbHNlLCJhX2JfZC5sZTc2IjpmYWxzZSwiYV9iX2QubGU3NyI6ZmFsc2UsImFfYl9kLmxlODEiOmZhbHNlLCJhX2JfZC5sZTgyIjpmYWxzZSwiYV9iX2QubGU4MyI6ZmFsc2UsImFfYl9kLmxlODQiOmZhbHNlLCJhX2JfZC5sZTg1IjpmYWxzZSwiYV9iX2QubGU4NiI6ZmFsc2UsImFfYl9kLmxlODciOmZhbHNlLCJhX2JfZC5sZTkxIjpmYWxzZSwiYV9iX2QubGU5MiI6ZmFsc2UsImFfYl9kLmxlOTMiOmZhbHNlLCJhX2JfZC5sZTk0IjpmYWxzZSwiYV9iX2QubGU5NSI6ZmFsc2UsImFfYl9kLmxlOTYiOmZhbHNlLCJhX2JfZC5sZTk3IjpmYWxzZSwiYV9iX2QubW8xMTAxIjoiU3RhdGljIiwiYV9iX2QubW8xMTAyIjoiU3RhdGljIiwiYV9iX2QubW8xMTAzIjoiU3RhdGljIiwiYV9iX2QubW8xMTA0IjoiU3RhdGljIiwiYV9iX2QubW8xMTA1IjoiU3RhdGljIiwiYV9iX2QubW8xMTA2IjoiU3RhdGljIiwiYV9iX2QubW8xMTA3IjoiU3RhdGljIiwiYV9iX2QubW8xMTEiOiJTdGF0aWMiLCJhX2JfZC5tbzExMiI6IlN0YXRpYyIsImFfYl9kLm1vMTEzIjoiU3RhdGljIiwiYV9iX2QubW8xMTQiOiJTdGF0aWMiLCJhX2JfZC5tbzExNSI6IlN0YXRpYyIsImFfYl9kLm1vMTE2IjoiU3RhdGljIiwiYV9iX2QubW8xMTciOiJTdGF0aWMiLCJhX2JfZC5tbzEyMSI6IlN0YXRpYyIsImFfYl9kLm1vMTIyIjoiU3RhdGljIiwiYV9iX2QubW8xMjMiOiJTdGF0aWMiLCJhX2JfZC5tbzEyNCI6IlN0YXRpYyIsImFfYl9kLm1vMTI1IjoiU3RhdGljIiwiYV9iX2QubW8xMjYiOiJTdGF0aWMiLCJhX2JfZC5tbzEyNyI6IlN0YXRpYyIsImFfYl9kLm1vMTMxIjoiU3RhdGljIiwiYV9iX2QubW8xMzIiOiJTdGF0aWMiLCJhX2JfZC5tbzEzMyI6IlN0YXRpYyIsImFfYl9kLm1vMTM0IjoiU3RhdGljIiwiYV9iX2QubW8xMzUiOiJTdGF0aWMiLCJhX2JfZC5tbzEzNiI6IlN0YXRpYyIsImFfYl9kLm1vMTM3IjoiU3RhdGljIiwiYV9iX2QubW8xNDEiOiJTdGF0aWMiLCJhX2JfZC5tbzE0MiI6IlN0YXRpYyIsImFfYl9kLm1vMTQzIjoiU3RhdGljIiwiYV9iX2QubW8xNDQiOiJTdGF0aWMiLCJhX2JfZC5tbzE0NSI6IlN0YXRpYyIsImFfYl9kLm1vMTQ2IjoiU3RhdGljIiwiYV9iX2QubW8xNDciOiJTdGF0aWMiLCJhX2JfZC5tbzE1MSI6IlN0YXRpYyIsImFfYl9kLm1vMTUyIjoiU3RhdGljIiwiYV9iX2QubW8xNTMiOiJTdGF0aWMiLCJhX2JfZC5tbzE1NCI6IlN0YXRpYyIsImFfYl9kLm1vMTU1IjoiU3RhdGljIiwiYV9iX2QubW8xNTYiOiJTdGF0aWMiLCJhX2JfZC5tbzE1NyI6IlN0YXRpYyIsImFfYl9kLm1vMTYxIjoiU3RhdGljIiwiYV9iX2QubW8xNjIiOiJTdGF0aWMiLCJhX2JfZC5tbzE2MyI6IlN0YXRpYyIsImFfYl9kLm1vMTY0IjoiU3RhdGljIiwiYV9iX2QubW8xNjUiOiJTdGF0aWMiLCJhX2JfZC5tbzE2NiI6IlN0YXRpYyIsImFfYl9kLm1vMTY3IjoiU3RhdGljIiwiYV9iX2QubW8xNzEiOiJTdGF0aWMiLCJhX2JfZC5tbzE3MiI6IlN0YXRpYyIsImFfYl9kLm1vMTczIjoiU3RhdGljIiwiYV9iX2QubW8xNzQiOiJTdGF0aWMiLCJhX2JfZC5tbzE3NSI6IlN0YXRpYyIsImFfYl9kLm1vMTc2IjoiU3RhdGljIiwiYV9iX2QubW8xNzciOiJTdGF0aWMiLCJhX2JfZC5tbzE4MSI6IlN0YXRpYyIsImFfYl9kLm1vMTgyIjoiU3RhdGljIiwiYV9iX2QubW8xODMiOiJTdGF0aWMiLCJhX2JfZC5tbzE4NCI6IlN0YXRpYyIsImFfYl9kLm1vMTg1IjoiU3RhdGljIiwiYV9iX2QubW8xODYiOiJTdGF0aWMiLCJhX2JfZC5tbzE4NyI6IlN0YXRpYyIsImFfYl9kLm1vMTkxIjoiU3RhdGljIiwiYV9iX2QubW8xOTIiOiJTdGF0aWMiLCJhX2JfZC5tbzE5MyI6IlN0YXRpYyIsImFfYl9kLm1vMTk0IjoiU3RhdGljIiwiYV9iX2QubW8xOTUiOiJTdGF0aWMiLCJhX2JfZC5tbzE5NiI6IlN0YXRpYyIsImFfYl9kLm1vMTk3IjoiU3RhdGljIiwiYV9iX2QueTExMDEiOmZhbHNlLCJhX2JfZC55MTEwMiI6ZmFsc2UsImFfYl9kLnkxMTAzIjpmYWxzZSwiYV9iX2QueTExMDQiOmZhbHNlLCJhX2JfZC55MTEwNSI6ZmFsc2UsImFfYl9kLnkxMTA2IjpmYWxzZSwiYV9iX2QueTExMDciOmZhbHNlLCJhX2JfZC55MTExIjp0cnVlLCJhX2JfZC55MTEyIjpmYWxzZSwiYV9iX2QueTExMyI6dHJ1ZSwiYV9iX2QueTExNCI6ZmFsc2UsImFfYl9kLnkxMTUiOnRydWUsImFfYl9kLnkxMTYiOmZhbHNlLCJhX2JfZC55MTE3Ijp0cnVlLCJhX2JfZC55MTIxIjpmYWxzZSwiYV9iX2QueTEyMiI6ZmFsc2UsImFfYl9kLnkxMjMiOnRydWUsImFfYl9kLnkxMjQiOmZhbHNlLCJhX2JfZC55MTI1IjpmYWxzZSwiYV9iX2QueTEyNiI6ZmFsc2UsImFfYl9kLnkxMjciOmZhbHNlLCJhX2JfZC55MTMxIjpmYWxzZSwiYV9iX2QueTEzMiI6ZmFsc2UsImFfYl9kLnkxMzMiOmZhbHNlLCJhX2JfZC55MTM0IjpmYWxzZSwiYV9iX2QueTEzNSI6ZmFsc2UsImFfYl9kLnkxMzYiOmZhbHNlLCJhX2JfZC55MTM3IjpmYWxzZSwiYV9iX2QueTE0MSI6ZmFsc2UsImFfYl9kLnkxNDIiOmZhbHNlLCJhX2JfZC55MTQzIjpmYWxzZSwiYV9iX2QueTE0NCI6ZmFsc2UsImFfYl9kLnkxNDUiOmZhbHNlLCJhX2JfZC55MTQ2IjpmYWxzZSwiYV9iX2QueTE0NyI6ZmFsc2UsImFfYl9kLnkxNTEiOmZhbHNlLCJhX2JfZC55MTUyIjpmYWxzZSwiYV9iX2QueTE1MyI6ZmFsc2UsImFfYl9kLnkxNTQiOmZhbHNlLCJhX2JfZC55MTU1IjpmYWxzZSwiYV9iX2QueTE1NiI6ZmFsc2UsImFfYl9kLnkxNTciOmZhbHNlLCJhX2JfZC55MTYxIjpmYWxzZSwiYV9iX2QueTE2MiI6ZmFsc2UsImFfYl9kLnkxNjMiOmZhbHNlLCJhX2JfZC55MTY0IjpmYWxzZSwiYV9iX2QueTE2NSI6ZmFsc2UsImFfYl9kLnkxNjYiOmZhbHNlLCJhX2JfZC55MTY3IjpmYWxzZSwiYV9iX2QueTE3MSI6ZmFsc2UsImFfYl9kLnkxNzIiOmZhbHNlLCJhX2JfZC55MTczIjpmYWxzZSwiYV9iX2QueTE3NCI6ZmFsc2UsImFfYl9kLnkxNzUiOmZhbHNlLCJhX2JfZC55MTc2IjpmYWxzZSwiYV9iX2QueTE3NyI6ZmFsc2UsImFfYl9kLnkxODEiOmZhbHNlLCJhX2JfZC55MTgyIjpmYWxzZSwiYV9iX2QueTE4MyI6ZmFsc2UsImFfYl9kLnkxODQiOmZhbHNlLCJhX2JfZC55MTg1IjpmYWxzZSwiYV9iX2QueTE4NiI6ZmFsc2UsImFfYl9kLnkxODciOmZhbHNlLCJhX2JfZC55MTkxIjpmYWxzZSwiYV9iX2QueTE5MiI6ZmFsc2UsImFfYl9kLnkxOTMiOmZhbHNlLCJhX2JfZC55MTk0IjpmYWxzZSwiYV9iX2QueTE5NSI6ZmFsc2UsImFfYl9kLnkxOTYiOmZhbHNlLCJhX2JfZC55MTk3IjpmYWxzZSwiYV9iX2QueTIxMDEiOjAuMCwiYV9iX2QueTIxMDIiOjAuMCwiYV9iX2QueTIxMDMiOjAuMCwiYV9iX2QueTIxMDQiOjAuMCwiYV9iX2QueTIxMDUiOjAuMCwiYV9iX2QueTIxMDYiOjAuMCwiYV9iX2QueTIxMDciOjAuMCwiYV9iX2QueTIxMSI6LTQxLjAsImFfYl9kLnkyMTIiOjAuMCwiYV9iX2QueTIxMyI6LTI4LjAsImFfYl9kLnkyMTQiOjAuMCwiYV9iX2QueTIxNSI6LTQxLjAsImFfYl9kLnkyMTYiOjAuMCwiYV9iX2QueTIxNyI6LTUuMCwiYV9iX2QueTIyMSI6MC4wLCJhX2JfZC55MjIyIjowLjAsImFfYl9kLnkyMjMiOi0yMC4wLCJhX2JfZC55MjI0IjowLjAsImFfYl9kLnkyMjUiOjAuMCwiYV9iX2QueTIyNiI6MC4wLCJhX2JfZC55MjI3IjowLjAsImFfYl9kLnkyMzEiOjAuMCwiYV9iX2QueTIzMiI6MC4wLCJhX2JfZC55MjMzIjowLjAsImFfYl9kLnkyMzQiOjAuMCwiYV9iX2QueTIzNSI6MC4wLCJhX2JfZC55MjM2IjowLjAsImFfYl9kLnkyMzciOjAuMCwiYV9iX2QueTI0MSI6MC4wLCJhX2JfZC55MjQyIjowLjAsImFfYl9kLnkyNDMiOjAuMCwiYV9iX2QueTI0NCI6MC4wLCJhX2JfZC55MjQ1IjowLjAsImFfYl9kLnkyNDYiOjAuMCwiYV9iX2QueTI0NyI6MC4wLCJhX2JfZC55MjUxIjowLjAsImFfYl9kLnkyNTIiOjAuMCwiYV9iX2QueTI1MyI6MC4wLCJhX2JfZC55MjU0IjowLjAsImFfYl9kLnkyNTUiOjAuMCwiYV9iX2QueTI1NiI6MC4wLCJhX2JfZC55MjU3IjowLjAsImFfYl9kLnkyNjEiOjAuMCwiYV9iX2QueTI2MiI6MC4wLCJhX2JfZC55MjYzIjowLjAsImFfYl9kLnkyNjQiOjAuMCwiYV9iX2QueTI2NSI6MC4wLCJhX2JfZC55MjY2IjowLjAsImFfYl9kLnkyNjciOjAuMCwiYV9iX2QueTI3MSI6MC4wLCJhX2JfZC55MjcyIjowLjAsImFfYl9kLnkyNzMiOjAuMCwiYV9iX2QueTI3NCI6MC4wLCJhX2JfZC55Mjc1IjowLjAsImFfYl9kLnkyNzYiOjAuMCwiYV9iX2QueTI3NyI6MC4wLCJhX2JfZC55MjgxIjowLjAsImFfYl9kLnkyODIiOjAuMCwiYV9iX2QueTI4MyI6MC4wLCJhX2JfZC55Mjg0IjowLjAsImFfYl9kLnkyODUiOjAuMCwiYV9iX2QueTI4NiI6MC4wLCJhX2JfZC55Mjg3IjowLjAsImFfYl9kLnkyOTEiOjAuMCwiYV9iX2QueTI5MiI6MC4wLCJhX2JfZC55MjkzIjowLjAsImFfYl9kLnkyOTQiOjAuMCwiYV9iX2QueTI5NSI6MC4wLCJhX2JfZC55Mjk2IjowLjAsImFfYl9kLnkyOTciOjAuMCwiYV9iX2QueTMxMDEiOjAuMCwiYV9iX2QueTMxMDIiOjAuMCwiYV9iX2QueTMxMDMiOjAuMCwiYV9iX2QueTMxMDQiOjAuMCwiYV9iX2QueTMxMDUiOjAuMCwiYV9iX2QueTMxMDYiOjAuMCwiYV9iX2QueTMxMDciOjAuMCwiYV9iX2QueTMxMSI6MjMuMCwiYV9iX2QueTMxMiI6MC4wLCJhX2JfZC55MzEzIjozNi4wLCJhX2JfZC55MzE0IjowLjAsImFfYl9kLnkzMTUiOjQ0LjAsImFfYl9kLnkzMTYiOjAuMCwiYV9iX2QueTMxNyI6MjUuMCwiYV9iX2QueTMyMSI6MC4wLCJhX2JfZC55MzIyIjowLjAsImFfYl9kLnkzMjMiOjIwLjAsImFfYl9kLnkzMjQiOjAuMCwiYV9iX2QueTMyNSI6MC4wLCJhX2JfZC55MzI2IjowLjAsImFfYl9kLnkzMjciOjAuMCwiYV9iX2QueTMzMSI6MC4wLCJhX2JfZC55MzMyIjowLjAsImFfYl9kLnkzMzMiOjAuMCwiYV9iX2QueTMzNCI6MC4wLCJhX2JfZC55MzM1IjowLjAsImFfYl9kLnkzMzYiOjAuMCwiYV9iX2QueTMzNyI6MC4wLCJhX2JfZC55MzQxIjowLjAsImFfYl9kLnkzNDIiOjAuMCwiYV9iX2QueTM0MyI6MC4wLCJhX2JfZC55MzQ0IjowLjAsImFfYl9kLnkzNDUiOjAuMCwiYV9iX2QueTM0NiI6MC4wLCJhX2JfZC55MzQ3IjowLjAsImFfYl9kLnkzNTEiOjAuMCwiYV9iX2QueTM1MiI6MC4wLCJhX2JfZC55MzUzIjowLjAsImFfYl9kLnkzNTQiOjAuMCwiYV9iX2QueTM1NSI6MC4wLCJhX2JfZC55MzU2IjowLjAsImFfYl9kLnkzNTciOjAuMCwiYV9iX2QueTM2MSI6MC4wLCJhX2JfZC55MzYyIjowLjAsImFfYl9kLnkzNjMiOjAuMCwiYV9iX2QueTM2NCI6MC4wLCJhX2JfZC55MzY1IjowLjAsImFfYl9kLnkzNjYiOjAuMCwiYV9iX2QueTM2NyI6MC4wLCJhX2JfZC55MzcxIjowLjAsImFfYl9kLnkzNzIiOjAuMCwiYV9iX2QueTM3MyI6MC4wLCJhX2JfZC55Mzc0IjowLjAsImFfYl9kLnkzNzUiOjAuMCwiYV9iX2QueTM3NiI6MC4wLCJhX2JfZC55Mzc3IjowLjAsImFfYl9kLnkzODEiOjAuMCwiYV9iX2QueTM4MiI6MC4wLCJhX2JfZC55MzgzIjowLjAsImFfYl9kLnkzODQiOjAuMCwiYV9iX2QueTM4NSI6MC4wLCJhX2JfZC55Mzg2IjowLjAsImFfYl9kLnkzODciOjAuMCwiYV9iX2QueTM5MSI6MC4wLCJhX2JfZC55MzkyIjowLjAsImFfYl9kLnkzOTMiOjAuMCwiYV9iX2QueTM5NCI6MC4wLCJhX2JfZC55Mzk1IjowLjAsImFfYl9kLnkzOTYiOjAuMCwiYV9iX2QueTM5NyI6MC4wLCJhX2JfcnIiOnRydWUs
ImFfYnNfZC5qMTAxIjowLjAsImFfYnNfZC5qMTAyIjowLjAsImFfYnNfZC5qMTAzIjowLjAsImFfYnNfZC5qMTA0IjowLjAsImFfYnNfZC5qMTA1IjowLjAsImFfYnNfZC5qMTA2IjowLjAsImFfYnNfZC5qMTA3IjowLjAsImFfYnNfZC5qMTEiOjAuMCwiYV9ic19kLmoxMTAxIjowLjAsImFfYnNfZC5qMTEwMiI6MC4wLCJhX2JzX2QuajExMDMiOjAuMCwiYV9ic19kLmoxMTA0IjowLjAsImFfYnNfZC5qMTEwNSI6MC4wLCJhX2JzX2QuajExMDYiOjAuMCwiYV9ic19kLmoxMTA3IjowLjAsImFfYnNfZC5qMTExIjowLjAsImFfYnNfZC5qMTEyIjowLjAsImFfYnNfZC5qMTEzIjowLjAsImFfYnNfZC5qMTE0IjowLjAsImFfYnNfZC5qMTE1IjowLjAsImFfYnNfZC5qMTE2IjowLjAsImFfYnNfZC5qMTE3IjowLjAsImFfYnNfZC5qMTIiOjAuMCwiYV9ic19kLmoxMjEiOjAuMCwiYV9ic19kLmoxMjIiOjAuMCwiYV9ic19kLmoxMjMiOjAuMCwiYV9ic19kLmoxMjQiOjAuMCwiYV9ic19kLmoxMjUiOjAuMCwiYV9ic19kLmoxMjYiOjAuMCwiYV9ic19kLmoxMjciOjAuMCwiYV9ic19kLmoxMyI6LTQuMCwiYV9ic19kLmoxMzEiOjAuMCwiYV9ic19kLmoxMzIiOjAuMCwiYV9ic19kLmoxMzMiOjAuMCwiYV9ic19kLmoxMzQiOjAuMCwiYV9ic19kLmoxMzUiOjAuMCwiYV9ic19kLmoxMzYiOjAuMCwiYV9ic19kLmoxMzciOjAuMCwiYV9ic19kLmoxNCI6MC4wLCJhX2JzX2QuajE0MSI6MC4wLCJhX2JzX2QuajE0MiI6MC4wLCJhX2JzX2QuajE0MyI6MC4wLCJhX2JzX2QuajE0NCI6MC4wLCJhX2JzX2QuajE0NSI6MC4wLCJhX2JzX2QuajE0NiI6MC4wLCJhX2JzX2QuajE0NyI6MC4wLCJhX2JzX2QuajE1IjowLjAsImFfYnNfZC5qMTUxIjowLjAsImFfYnNfZC5qMTUyIjowLjAsImFfYnNfZC5qMTUzIjowLjAsImFfYnNfZC5qMTU0IjowLjAsImFfYnNfZC5qMTU1IjowLjAsImFfYnNfZC5qMTU2IjowLjAsImFfYnNfZC5qMTU3IjowLjAsImFfYnNfZC5qMTYiOjAuMCwiYV9ic19kLmoxNjEiOjAuMCwiYV9ic19kLmoxNjIiOjAuMCwiYV9ic19kLmoxNjMiOjAuMCwiYV9ic19kLmoxNjQiOjAuMCwiYV9ic19kLmoxNjUiOjAuMCwiYV9ic19kLmoxNjYiOjAuMCwiYV9ic19kLmoxNjciOjAuMCwiYV9ic19kLmoxNyI6MC4wLCJhX2JzX2QuajE3MSI6MC4wLCJhX2JzX2QuajE3MiI6MC4wLCJhX2JzX2QuajE3MyI6MC4wLCJhX2JzX2QuajE3NCI6MC4wLCJhX2JzX2QuajE3NSI6MC4wLCJhX2JzX2QuajE3NiI6MC4wLCJhX2JzX2QuajE3NyI6MC4wLCJhX2JzX2QuajE4MSI6MC4wLCJhX2JzX2QuajE4MiI6MC4wLCJhX2JzX2QuajE4MyI6MC4wLCJhX2JzX2QuajE4NCI6MC4wLCJhX2JzX2QuajE4NSI6MC4wLCJhX2JzX2QuajE4NiI6MC4wLCJhX2JzX2QuajE4NyI6MC4wLCJhX2JzX2QuajE5MSI6MC4wLCJhX2JzX2QuajE5MiI6MC4wLCJhX2JzX2QuajE5MyI6MC4wLCJhX2JzX2QuajE5NCI6MC4wLCJhX2JzX2QuajE5NSI6MC4wLCJhX2JzX2QuajE5NiI6MC4wLCJhX2JzX2QuajE5NyI6MC4wLCJhX2JzX2QuajIxIjowLjAsImFfYnNfZC5qMjIiOjAuMCwiYV9ic19kLmoyMyI6LTIyLjAsImFfYnNfZC5qMjQiOjAuMCwiYV9ic19kLmoyNSI6MC4wLCJhX2JzX2QuajI2IjowLjAsImFfYnNfZC5qMjciOjAuMCwiYV9ic19kLmozMSI6MC4wLCJhX2JzX2QuajMyIjowLjAsImFfYnNfZC5qMzMiOjAuMCwiYV9ic19kLmozNCI6MC4wLCJhX2JzX2QuajM1IjowLjAsImFfYnNfZC5qMzYiOjAuMCwiYV9ic19kLmozNyI6MC4wLCJhX2JzX2QuajQxIjowLjAsImFfYnNfZC5qNDIiOjAuMCwiYV9ic19kLmo0MyI6MC4wLCJhX2JzX2QuajQ0IjowLjAsImFfYnNfZC5qNDUiOjAuMCwiYV9ic19kLmo0NiI6MC4wLCJhX2JzX2QuajQ3IjowLjAsImFfYnNfZC5qNTEiOjAuMCwiYV9ic19kLmo1MiI6MC4wLCJhX2JzX2QuajUzIjowLjAsImFfYnNfZC5qNTQiOjAuMCwiYV9ic19kLmo1NSI6MC4wLCJhX2JzX2QuajU2IjowLjAsImFfYnNfZC5qNTciOjAuMCwiYV9ic19kLmo2MSI6MC4wLCJhX2JzX2QuajYyIjowLjAsImFfYnNfZC5qNjMiOjAuMCwiYV9ic19kLmo2NCI6MC4wLCJhX2JzX2QuajY1IjowLjAsImFfYnNfZC5qNjYiOjAuMCwiYV9ic19kLmo2NyI6MC4wLCJhX2JzX2QuajcxIjowLjAsImFfYnNfZC5qNzIiOjAuMCwiYV9ic19kLmo3MyI6MC4wLCJhX2JzX2Quajc0IjowLjAsImFfYnNfZC5qNzUiOjAuMCwiYV9ic19kLmo3NiI6MC4wLCJhX2JzX2Quajc3IjowLjAsImFfYnNfZC5qODEiOjAuMCwiYV9ic19kLmo4MiI6MC4wLCJhX2JzX2QuajgzIjowLjAsImFfYnNfZC5qODQiOjAuMCwiYV9ic19kLmo4NSI6MC4wLCJhX2JzX2Quajg2IjowLjAsImFfYnNfZC5qODciOjAuMCwiYV9ic19kLmo5MSI6MC4wLCJhX2JzX2QuajkyIjowLjAsImFfYnNfZC5qOTMiOjAuMCwiYV9ic19kLmo5NCI6MC4wLCJhX2JzX2Quajk1IjowLjAsImFfYnNfZC5qOTYiOjAuMCwiYV9ic19kLmo5NyI6MC4wLCJhX2N1cmVfc3RhdGUxIjoiUnVubmluZyIsImFfY3VyZV9zdGF0ZTEwIjoiR2xvYmFsIiwiYV9jdXJlX3N0YXRlMiI6IkNyb3VjaGluZyIsImFfY3VyZV9zdGF0ZTMiOiJHbG9iYWwiLCJhX2N1cmVfc3RhdGU0IjoiR2xvYmFsIiwiYV9jdXJlX3N0YXRlNSI6Ikdsb2JhbCIsImFfY3VyZV9zdGF0ZTYiOiJHbG9iYWwiLCJhX2N1cmVfc3RhdGU3IjoiR2xvYmFsIiwiYV9jdXJlX3N0YXRlOCI6Ikdsb2JhbCIsImFfY3VyZV9zdGF0ZTkiOiJHbG9iYWwiLCJhX2hfaCI6WyJMZWdpdCBBQSBvbiBFIiwiLz9Cb21ic2l0ZSBFIEZpeCIsIlNoaXQgQUEgb24gV2FybXVwIiwiQmV0dGVyIE9uc2hvdCJdLCJhY2NlbnRjbHIiOiJGRkI2OTBGRiIsImFoYXNlX3Zpc2libGVyIjoiUGhhc2UgMSIsImFpX2IiOnRydWUsImFpX2Vfc3ciOmZhbHNlLCJhaV9lX3RpaW1lIjo1LjAsImFpcmhjIjpudWxsLCJhbmltX2IiOlsiU3RhdGljIGxlZ3MgaW4gYWlyIiwiRm9sbG93IGRpcmVjdGlvbiIsIlplcm8gcGl0Y2ggb24gbGFuZCJdLCJhcnIiOjE3MC4wLCJhdHRtYW51YWx5YXciOnRydWUsImF1dG9oY2FpciI6NTUuMCwiYXV0b2hjbnMiOjU1LjAsImF3cGhjYWlyIjo1NS4wLCJhd3BoY25zIjo1NS4wLCJkX29fczExIjoiRGlzYWJsZWQiLCJkX29fczEyIjoiRGlzYWJsZWQiLCJkX29fczEzIjoiRGlzYWJsZWQiLCJkX29fczE0IjoiRGlzYWJsZWQiLCJkX29fczIxIjoiRGlzYWJsZWQiLCJkX29fczIyIjoiRGlzYWJsZWQiLCJkX29fczIzIjoiRGlzYWJsZWQiLCJkX29fczI0IjoiRGlzYWJsZWQiLCJkX29fczMxIjoiRGlzYWJsZWQiLCJkX29fczMyIjoiRGlzYWJsZWQiLCJkX29fczMzIjoiRGlzYWJsZWQiLCJkX29fczM0IjoiRGlzYWJsZWQiLCJkX29fczQxIjoiRGlzYWJsZWQiLCJkX29fczQyIjoiRGlzYWJsZWQiLCJkX29fczQzIjoiRGlzYWJsZWQiLCJkX29fczQ0IjoiRGlzYWJsZWQiLCJkX29fczUxIjoiRGlzYWJsZWQiLCJkX29fczUyIjoiRGlzYWJsZWQiLCJkX29fczUzIjoiRGlzYWJsZWQiLCJkX29fczU0IjoiRGlzYWJsZWQiLCJkX29fczYxIjoiRGlzYWJsZWQiLCJkX29fczYyIjoiRGlzYWJsZWQiLCJkX29fczYzIjoiRGlzYWJsZWQiLCJkX29fczY0IjoiRGlzYWJsZWQiLCJkX29fczcxIjoiRGlzYWJsZWQiLCJkX29fczcyIjoiRGlzYWJsZWQiLCJkX29fczczIjoiRGlzYWJsZWQiLCJkX29fczc0IjoiRGlzYWJsZWQiLCJmX2QxMSI6Ik9mZiIsImZfZDEyIjoiT2ZmIiwiZl9kMTMiOiJPZmYiLCJmX2QxNCI6Ik9mZiIsImZfZDIxIjoiT2ZmIiwiZl9kMjIiOiJPZmYiLCJmX2QyMyI6Ik9mZiIsImZfZDI0IjoiT2ZmIiwiZl9kMzEiOiJPZmYiLCJmX2QzMiI6Ik9mZiIsImZfZDMzIjoiT2ZmIiwiZl9kMzQiOiJPZmYiLCJmX2Q0MSI6Ik9mZiIsImZfZDQyIjoiT2ZmIiwiZl9kNDMiOiJPZmYiLCJmX2Q0NCI6Ik9mZiIsImZfZDUxIjoiT2ZmIiwiZl9kNTIiOiJPZmYiLCJmX2Q1MyI6Ik9mZiIsImZfZDU0IjoiT2ZmIiwiZl9kNjEiOiJPZmYiLCJmX2Q2MiI6Ik9mZiIsImZfZDYzIjoiT2ZmIiwiZl9kNjQiOiJPZmYiLCJmX2Q3MSI6Ik9mZiIsImZfZDcyIjoiT2ZmIiwiZl9kNzMiOiJPZmYiLCJmX2Q3NCI6Ik9mZiIsImZfdDExIjoiRGVzeW5jIiwiZl90MTIiOiJEZXN5bmMiLCJmX3QxMyI6IkRlc3luYyIsImZfdDE0IjoiRGVzeW5jIiwiZl90MjEiOiJEZXN5bmMiLCJmX3QyMiI6IkRlc3luYyIsImZfdDIzIjoiRGVzeW5jIiwiZl90MjQiOiJEZXN5bmMiLCJmX3QzMSI6IkRlc3luYyIsImZfdDMyIjoiRGVzeW5jIiwiZl90MzMiOiJEZXN5bmMiLCJmX3QzNCI6IkRlc3luYyIsImZfdDQxIjoiRGVzeW5jIiwiZl90NDIiOiJEZXN5bmMiLCJmX3Q0MyI6IkRlc3luYyIsImZfdDQ0IjoiRGVzeW5jIiwiZl90NTEiOiJEZXN5bmMiLCJmX3Q1MiI6IkRlc3luYyIsImZfdDUzIjoiRGVzeW5jIiwiZl90NTQiOiJEZXN5bmMiLCJmX3Q2MSI6IkRlc3luYyIsImZfdDYyIjoiRGVzeW5jIiwiZl90NjMiOiJEZXN5bmMiLCJmX3Q2NCI6IkRlc3luYyIsImZfdDcxIjoiRGVzeW5jIiwiZl90NzIiOiJEZXN5bmMiLCJmX3Q3MyI6IkRlc3luYyIsImZfdDc0IjoiRGVzeW5jIiwiZnAxMSI6WyJKaXR0ZXIiXSwiZnAxMiI6bnVsbCwiZnAxMyI6bnVsbCwiZnAxNCI6bnVsbCwiZnAyMSI6WyJKaXR0ZXIiXSwiZnAyMiI6bnVsbCwiZnAyMyI6bnVsbCwiZnAyNCI6bnVsbCwiZnAzMSI6WyJKaXR0ZXIiXSwiZnAzMiI6bnVsbCwiZnAzMyI6bnVsbCwiZnAzNCI6WyJKaXR0ZXIiXSwiZnA0MSI6bnVsbCwiZnA0MiI6bnVsbCwiZnA0MyI6bnVsbCwiZnA0NCI6bnVsbCwiZnA1MSI6WyJKaXR0ZXIiXSwiZnA1MiI6WyJKaXR0ZXIiXSwiZnA1MyI6WyJKaXR0ZXIiXSwiZnA1NCI6WyJKaXR0ZXIiXSwiZnA2MSI6bnVsbCwiZnA2MiI6bnVsbCwiZnA2MyI6bnVsbCwiZnA2NCI6bnVsbCwiZnA3MSI6WyJKaXR0ZXIiXSwiZnA3MiI6bnVsbCwiZnA3MyI6WyJKaXR0ZXIiXSwiZnA3NCI6bnVsbCwiZ2xoY2FpciI6NTUuMCwiaGl0Y2xyIjoiOUZGRjk1RkYiLCJob2xvYmluZHMiOlsiRFQiLCJPUyIsIkZEIiwiRE1HIiwiSEMiLCJCT0RZIiwiUElORyIsIlBFRUsiLCJTQUZFIl0sImhvbG9zdGF0ZXMiOlsiVGhpcmRwZXJzb24iLCJGaXJzdHBlcnNvbiJdLCJpX3QiOmZhbHNlLCJpZGVhbGZzIjoiU21hcnQiLCJpbmRzc3QiOiJEZWZhdWx0IiwiajExIjoiRGlzYWJsZWQiLCJqMTIiOiJEaXNhYmxlZCIsImoxMyI6IkRpc2FibGVkIiwiajE0IjoiRGlzYWJsZWQiLCJqMjEiOiJEaXNhYmxlZCIsImoyMiI6IkRpc2FibGVkIiwiajIzIjoiRGlzYWJsZWQiLCJqMjQiOiJEaXNhYmxlZCIsImozMSI6IkRpc2FibGVkIiwiajMyIjoiRGlzYWJsZWQiLCJqMzMiOiJEaXNhYmxlZCIsImozNCI6IkNlbnRlciIsImo0MSI6IkRpc2FibGVkIiwiajQyIjoiRGlzYWJsZWQiLCJqNDMiOiJEaXNhYmxlZCIsImo0NCI6IkRpc2FibGVkIiwiajUxIjoiU3BpbiIsImo1MiI6IkNlbnRlciIsImo1MyI6IkNlbnRlciIsImo1NCI6IlNwaW4iLCJqNjEiOiJEaXNhYmxlZCIsImo2MiI6IkRpc2FibGVkIiwiajYzIjoiRGlzYWJsZWQiLCJqNjQiOiJEaXNhYmxlZCIsImo3MSI6IkRpc2FibGVkIiwiajcyIjoiRGlzYWJsZWQiLCJqNzMiOiJDZW50ZXIiLCJqNzQiOiJEaXNhYmxlZCIsImpfdjExIjo1LjAsImpfdjEyIjowLjAsImpfdjEzIjowLjAsImpfdjE0IjowLjAsImpfdjIxIjowLjAsImpfdjIxMSI6MC4wLCJqX3YyMTIiOjAuMCwial92MjEzIjowLjAsImpfdjIxNCI6MC4wLCJqX3YyMiI6MC4wLCJqX3YyMjEiOjAuMCwial92MjIyIjowLjAsImpfdjIyMyI6MC4wLCJqX3YyMjQiOjAuMCwial92MjMiOjAuMCwial92MjMxIjowLjAsImpfdjIzMiI6MC4wLCJqX3YyMzMiOjAuMCwial92MjM0IjotMjcuMCwial92MjQiOjAuMCwial92MjQxIjowLjAsImpfdjI0MiI6MC4wLCJqX3YyNDMiOjAuMCwial92MjQ0IjowLjAsImpfdjI1MSI6Mi4wLCJqX3YyNTIiOi02Ny4wLCJqX3YyNTMiOi0zMi4wLCJqX3YyNTQiOi00LjAsImpfdjI2MSI6MC4wLCJqX3YyNjIiOjAuMCwial92MjYzIjowLjAsImpfdjI2NCI6MC4wLCJqX3YyNzEiOi0yNy4wLCJqX3YyNzIiOjAuMCwial92MjczIjotMjIuMCwial92Mjc0IjowLjAsImpfdjMxIjowLjAsImpfdjMyIjowLjAsImpfdjMzIjowLjAsImpfdjM0IjoyNy4wLCJqX3Y0MSI6MC4wLCJqX3Y0MiI6MC4wLCJqX3Y0MyI6MC4wLCJqX3Y0NCI6MC4wLCJqX3Y1MSI6LTEyLjAsImpfdjUyIjoxNy4wLCJqX3Y1MyI6NTIuMCwial92NTQiOjQuMCwial92NjEiOjAuMCwial92NjIiOjAuMCwial92NjMiOjAuMCwial92NjQiOjAuMCwial92NzEiOi0yNy4wLCJqX3Y3MiI6MC4wLCJqX3Y3MyI6NTcuMCwial92NzQiOjAuMCwia2JpbmRzY2xyIjoiRkZCODhERkYiLCJsX2RfdjExIjo2MC4wLCJsX2RfdjEyIjowLjAsImxfZF92MTMiOjAuMCwibF9kX3YxNCI6MC4wLCJsX2RfdjIxIjo2MC4wLCJsX2RfdjIyIjowLjAsImxfZF92MjMiOjAuMCwibF9kX3YyNCI6MC4wLCJsX2RfdjMxIjo2MC4wLCJsX2RfdjMyIjowLjAsImxfZF92MzMiOjAuMCwibF9kX3YzNCI6NjAuMCwibF9kX3Y0MSI6MC4wLCJsX2RfdjQyIjowLjAsImxfZF92NDMiOjAuMCwibF9kX3Y0NCI6MC4wLCJsX2RfdjUxIjo2MC4wLCJsX2RfdjUyIjo0OC4wLCJsX2RfdjUzIjo1OC4wLCJsX2RfdjU0Ijo2MC4wLCJsX2RfdjYxIjowLjAsImxfZF92NjIiOjAuMCwibF9kX3Y2MyI6MC4wLCJsX2RfdjY0IjowLjAsImxfZF92NzEiOjYwLjAsImxfZF92NzIiOjAuMCwibF9kX3Y3MyI6NjAuMCwibF9kX3Y3NCI6MC4wLCJsX20xMSI6Ik9wcG9zaXRlIiwibF9tMTIiOiJEaXNhYmxlZCIsImxfbTEzIjoiRGlzYWJsZWQiLCJsX20xNCI6IkRpc2FibGVkIiwibF9tMjEiOiJPcHBvc2l0ZSIsImxfbTIyIjoiRGlzYWJsZWQiLCJsX20yMyI6IkRpc2FibGVkIiwibF9tMjQiOiJEaXNhYmxlZCIsImxfbTMxIjoiRGlzYWJsZWQiLCJsX20zMiI6IkRpc2FibGVkIiwibF9tMzMiOiJEaXNhYmxlZCIsImxfbTM0IjoiT3Bwb3NpdGUiLCJsX200MSI6IkRpc2FibGVkIiwibF9tNDIiOiJEaXNhYmxlZCIsImxfbTQzIjoiRGlzYWJsZWQiLCJsX200NCI6IkRpc2FibGVkIiwibF9tNTEiOiJEaXNhYmxlZCIsImxfbTUyIjoiT3Bwb3NpdGUiLCJsX201MyI6IkRpc2FibGVkIiwibF9tNTQiOiJPcHBvc2l0ZSIsImxfbTYxIjoiRGlzYWJsZWQiLCJsX202MiI6IkRpc2FibGVkIiwibF9tNjMiOiJEaXNhYmxlZCIsImxfbTY0IjoiRGlzYWJsZWQiLCJsX203MSI6IkRpc2FibGVkIiwibF9tNzIiOiJEaXNhYmxlZCIsImxfbTczIjoiRGlzYWJsZWQiLCJsX203NCI6IkRpc2FibGVkIiwibV9tMTEiOiJTdGF0aWMiLCJtX20xMiI6IlN0YXRpYyIsIm1fbTEzIjoiU3RhdGljIiwibV9tMTQiOiJTdGF0aWMiLCJtX20yMSI6IlN0YXRpYyIsIm1fbTIyIjoiU3RhdGljIiwibV9tMjMiOiJTdGF0aWMiLCJtX20yNCI6IlN0YXRpYyIsIm1fbTMxIjoiU3RhdGljIiwibV9tMzIiOiJTdGF0aWMiLCJtX20zMyI6IlN0YXRpYyIsIm1fbTM0IjoiRGVzeW5jIiwibV9tNDEiOiJTdGF0aWMiLCJtX200MiI6IlN0YXRpYy
IsIm1fbTQzIjoiU3RhdGljIiwibV9tNDQiOiJTdGF0aWMiLCJtX201MSI6IkRlc3luYyIsIm1fbTUyIjoiRGVzeW5jIiwibV9tNTMiOiJEZXN5bmMiLCJtX201NCI6IkRlc3luYyIsIm1fbTYxIjoiU3RhdGljIiwibV9tNjIiOiJTdGF0aWMiLCJtX202MyI6IlN0YXRpYyIsIm1fbTY0IjoiU3RhdGljIiwibV9tNzEiOiJEZXN5bmMiLCJtX203MiI6IlN0YXRpYyIsIm1fbTczIjoiRGVzeW5jIiwibV9tNzQiOiJTdGF0aWMiLCJtYW51YWx5YXciOnRydWUsIm1hcmtlcmNvbG9yIjoiRkZGRkZGRkYiLCJtYXJrZXJzdHlsZSI6IlBpeGVsIiwibWVudW1hbnVhbCI6IkRpc2FibGVkIiwibWlzYyI6WyJUcmFodGFsayIsIkNsYW50YWcgU3BhbW1lciIsIkFzcGVjdCBSYXRpbyIsIlZpZXdtb2RlbCBDaGFuZ2VyIiwiQ29uc29sZSBMb2dzIl0sIm1pc3NjbHIiOiJGRjc1NzVGRiIsIm5zaGMiOm51bGwsIm92ZXJyaWRlIHdlYXAxMiI6ZmFsc2UsIm92ZXJyaWRlIHdlYXAxMyI6ZmFsc2UsIm92ZXJyaWRlIHdlYXAxNCI6ZmFsc2UsIm92ZXJyaWRlIHdlYXAyMiI6ZmFsc2UsIm92ZXJyaWRlIHdlYXAyMyI6ZmFsc2UsIm92ZXJyaWRlIHdlYXAyNCI6ZmFsc2UsIm92ZXJyaWRlIHdlYXAzMiI6ZmFsc2UsIm92ZXJyaWRlIHdlYXAzMyI6ZmFsc2UsIm92ZXJyaWRlIHdlYXAzNCI6dHJ1ZSwib3ZlcnJpZGUgd2VhcDQyIjpmYWxzZSwib3ZlcnJpZGUgd2VhcDQzIjpmYWxzZSwib3ZlcnJpZGUgd2VhcDQ0IjpmYWxzZSwib3ZlcnJpZGUgd2VhcDUyIjp0cnVlLCJvdmVycmlkZSB3ZWFwNTMiOnRydWUsIm92ZXJyaWRlIHdlYXA1NCI6dHJ1ZSwib3ZlcnJpZGUgd2VhcDYyIjpmYWxzZSwib3ZlcnJpZGUgd2VhcDYzIjpmYWxzZSwib3ZlcnJpZGUgd2VhcDY0IjpmYWxzZSwib3ZlcnJpZGUgd2VhcDcyIjpmYWxzZSwib3ZlcnJpZGUgd2VhcDczIjp0cnVlLCJvdmVycmlkZSB3ZWFwNzQiOmZhbHNlLCJwIjoiQ3VzdG9tIiwicDEiOiJTY291dCIsInAyIjoiR2xvYmFsIiwicDIyIjp0cnVlLCJwMjMiOnRydWUsInAyNCI6ZmFsc2UsInAyNSI6dHJ1ZSwicDI2IjpmYWxzZSwicDI3Ijp0cnVlLCJwMyI6IlBpc3RvbHMiLCJwNCI6Ikdsb2JhbCIsInA1IjoiUGlzdG9scyIsInA2IjoiR2xvYmFsIiwicDciOiJHbG9iYWwiLCJwX28iOmZhbHNlLCJwaCI6Ny4wLCJwaXN0aGNhaXIiOjU1LjAsInByMjExIjoiQ3VzdG9tIiwicHIyMTIiOiJBZGFwdGl2ZSBDZW50ZXIiLCJwcjIxMyI6IkFkYXB0aXZlIENlbnRlciIsInByMjE0IjoiQWRhcHRpdmUgQ2VudGVyIiwicHIyMjEiOiJDdXN0b20iLCJwcjIyMiI6IkFkYXB0aXZlIENlbnRlciIsInByMjIzIjoiQWRhcHRpdmUgQ2VudGVyIiwicHIyMjQiOiJBZGFwdGl2ZSBDZW50ZXIiLCJwcjIzMSI6IkN1c3RvbSIsInByMjMyIjoiQWRhcHRpdmUgQ2VudGVyIiwicHIyMzMiOiJBZGFwdGl2ZSBDZW50ZXIiLCJwcjIzNCI6IkN1c3RvbSIsInByMjQxIjoiQWRhcHRpdmUgQ2VudGVyIiwicHIyNDIiOiJBZGFwdGl2ZSBDZW50ZXIiLCJwcjI0MyI6IkFkYXB0aXZlIENlbnRlciIsInByMjQ0IjoiQWRhcHRpdmUgQ2VudGVyIiwicHIyNTEiOiJDdXN0b20iLCJwcjI1MiI6IkN1c3RvbSIsInByMjUzIjoiQ3VzdG9tIiwicHIyNTQiOiJDdXN0b20iLCJwcjI2MSI6IkFkYXB0aXZlIENlbnRlciIsInByMjYyIjoiQWRhcHRpdmUgQ2VudGVyIiwicHIyNjMiOiJBZGFwdGl2ZSBDZW50ZXIiLCJwcjI2NCI6IkFkYXB0aXZlIENlbnRlciIsInByMjcxIjoiQ3VzdG9tIiwicHIyNzIiOiJBZGFwdGl2ZSBDZW50ZXIiLCJwcjI3MyI6IkN1c3RvbSIsInByMjc0IjoiQWRhcHRpdmUgQ2VudGVyIiwicl9kX3YxMSI6NjAuMCwicl9kX3YxMiI6MC4wLCJyX2RfdjEzIjowLjAsInJfZF92MTQiOjAuMCwicl9kX3YyMSI6NjAuMCwicl9kX3YyMiI6MC4wLCJyX2RfdjIzIjowLjAsInJfZF92MjQiOjAuMCwicl9kX3YzMSI6NjAuMCwicl9kX3YzMiI6MC4wLCJyX2RfdjMzIjowLjAsInJfZF92MzQiOjYwLjAsInJfZF92NDEiOjAuMCwicl9kX3Y0MiI6MC4wLCJyX2RfdjQzIjowLjAsInJfZF92NDQiOjAuMCwicl9kX3Y1MSI6NjAuMCwicl9kX3Y1MiI6NjAuMCwicl9kX3Y1MyI6NTUuMCwicl9kX3Y1NCI6NjAuMCwicl9kX3Y2MSI6MC4wLCJyX2RfdjYyIjowLjAsInJfZF92NjMiOjAuMCwicl9kX3Y2NCI6MC4wLCJyX2RfdjcxIjo2MC4wLCJyX2RfdjcyIjowLjAsInJfZF92NzMiOjYwLjAsInJfZF92NzQiOjAuMCwicmV2aGNhaXIiOjU1LjAsInNfdDExIjo0LjAsInNfdDEyIjo0LjAsInNfdDEzIjo0LjAsInNfdDE0Ijo0LjAsInNfdDIxIjo0LjAsInNfdDIyIjo0LjAsInNfdDIzIjo0LjAsInNfdDI0Ijo0LjAsInNfdDMxIjo0LjAsInNfdDMyIjo0LjAsInNfdDMzIjo0LjAsInNfdDM0Ijo0LjAsInNfdDQxIjo0LjAsInNfdDQyIjo0LjAsInNfdDQzIjo0LjAsInNfdDQ0Ijo0LjAsInNfdDUxIjo0LjAsInNfdDUyIjo0LjAsInNfdDUzIjo0LjAsInNfdDU0Ijo0LjAsInNfdDYxIjo0LjAsInNfdDYyIjo0LjAsInNfdDYzIjo0LjAsInNfdDY0Ijo0LjAsInNfdDcxIjo0LjAsInNfdDcyIjo0LjAsInNfdDczIjo0LjAsInNfdDc0Ijo0LjAsInNjaGNhaXIiOjU1LjAsInNjaGNucyI6NTUuMCwic2NvcGVjbHIiOiJGRkZGRkZGRiIsInNjb3BlY2xyMSI6IkZGRkZGRjAwIiwic2NvcGVnYXAiOjEwLjAsInNjb3Blc2l6ZSI6NTAuMCwic3RhdGVhbHBoYSI6MC4wLCJzdGF0ZWNscjEiOiJGRkQ1QjFGRiIsInN0YXRlY2xyMiI6IkZGRkZGRkZGIiwic3RhdGVmb250IjoiTm8gYW50aS1hbGlhc2luZyIsInN0YXRlcG5sIjpbIkFudGlicnV0ZSBQaGFzZSIsIkxvY2FscGxheWVyIFN0YXRlIiwiUmFnZWJvdCBTdGF0dXMiXSwic3RhdGVzdGF0ZSI6IkltYWdlIiwidCI6IkNyb3VjaC1BaXIiLCJ0dGRlbGF5IjoyLjAsInZpc3VhbHMiOlsiV2F0ZXJtYXJrIiwiS2V5YmluZHMiLCJNSCBJbmRpY2F0b3JzIiwiRXh0cmFuZW91cyBpbmRpY2F0b3JzIiwiSGFuZHMgaW4gWm9vbSIsIkN1c3RvbSBab29tIiwiSWRlYWwgdGljayB2aXN1YWxpemUiLCJWZWxvY2l0eSBNb2RpZmllciIsIlNwZWN0YXRvciBMaXN0IiwiLy9bR1NdIEhvbG8gS0IiLCJTdGF0ZSBwYW5lbCIsIkRhbWFnZSBJbmRpY2F0b3IiXSwidm1mb3YiOjM2LjAsInZteCI6LTEuMCwidm15IjotNC4wLCJ2bXoiOi0xLjAsIndhbmVybmFtZSI6IlN0ZWFtIiwid2F0ZXJjbHIiOiJGN0FEODZGRiIsIndhdGVyY3VzdG5hbWUiOiJrZXF4Iiwid2F0ZXJpbmZvY2xyIjoiNjQ2NDY0RkYiLCJ5X2FfbDExIjozNy4wLCJ5X2FfbDEyIjowLjAsInlfYV9sMTMiOjAuMCwieV9hX2wxNCI6MC4wLCJ5X2FfbDIxIjo0Ni4wLCJ5X2FfbDIyIjowLjAsInlfYV9sMjMiOjAuMCwieV9hX2wyNCI6MC4wLCJ5X2FfbDMxIjozMi4wLCJ5X2FfbDMyIjowLjAsInlfYV9sMzMiOjAuMCwieV9hX2wzNCI6MjIuMCwieV9hX2w0MSI6MC4wLCJ5X2FfbDQyIjowLjAsInlfYV9sNDMiOjAuMCwieV9hX2w0NCI6MC4wLCJ5X2FfbDUxIjoyNy4wLCJ5X2FfbDUyIjo3LjAsInlfYV9sNTMiOjE3LjAsInlfYV9sNTQiOjM2LjAsInlfYV9sNjEiOjAuMCwieV9hX2w2MiI6MC4wLCJ5X2FfbDYzIjowLjAsInlfYV9sNjQiOjAuMCwieV9hX2w3MSI6MzcuMCwieV9hX2w3MiI6MC4wLCJ5X2FfbDczIjoyMi4wLCJ5X2FfbDc0IjowLjAsInlfYV9yMTEiOi0yOC4wLCJ5X2FfcjEyIjowLjAsInlfYV9yMTMiOjAuMCwieV9hX3IxNCI6MC4wLCJ5X2FfcjIxIjotMzcuMCwieV9hX3IyMiI6MC4wLCJ5X2FfcjIzIjowLjAsInlfYV9yMjQiOjAuMCwieV9hX3IzMSI6LTMyLjAsInlfYV9yMzIiOjAuMCwieV9hX3IzMyI6MC4wLCJ5X2FfcjM0IjotMjcuMCwieV9hX3I0MSI6MC4wLCJ5X2FfcjQyIjowLjAsInlfYV9yNDMiOjAuMCwieV9hX3I0NCI6MC4wLCJ5X2FfcjUxIjotNDIuMCwieV9hX3I1MiI6LTM3LjAsInlfYV9yNTMiOi02Mi4wLCJ5X2FfcjU0IjotMzAuMCwieV9hX3I2MSI6MC4wLCJ5X2FfcjYyIjowLjAsInlfYV9yNjMiOjAuMCwieV9hX3I2NCI6MC4wLCJ5X2FfcjcxIjotMjguMCwieV9hX3I3MiI6MC4wLCJ5X2FfcjczIjotNDcuMCwieV9hX3I3NCI6MC4wLCJ5X20xMSI6IlBlcmZlY3QiLCJ5X20xMiI6IkppdHRlciIsInlfbTEzIjoiSml0dGVyIiwieV9tMTQiOiJKaXR0ZXIiLCJ5X20yMSI6IlBlcmZlY3QiLCJ5X20yMiI6IkppdHRlciIsInlfbTIzIjoiSml0dGVyIiwieV9tMjQiOiJKaXR0ZXIiLCJ5X20zMSI6IlBlcmZlY3QiLCJ5X20zMiI6IkppdHRlciIsInlfbTMzIjoiSml0dGVyIiwieV9tMzQiOiJQZXJmZWN0IiwieV9tNDEiOiJKaXR0ZXIiLCJ5X200MiI6IkppdHRlciIsInlfbTQzIjoiSml0dGVyIiwieV9tNDQiOiJKaXR0ZXIiLCJ5X201MSI6IlBlcmZlY3QiLCJ5X201MiI6IlBlcmZlY3QiLCJ5X201MyI6IlBlcmZlY3QiLCJ5X201NCI6IlBlcmZlY3QiLCJ5X202MSI6IkppdHRlciIsInlfbTYyIjoiSml0dGVyIiwieV9tNjMiOiJKaXR0ZXIiLCJ5X202NCI6IkppdHRlciIsInlfbTcxIjoiUGVyZmVjdCIsInlfbTcyIjoiSml0dGVyIiwieV9tNzMiOiJQZXJmZWN0IiwieV9tNzQiOiJKaXR0ZXIiLCJ6b29tYW5pbSI6ZmFsc2V9
]]) end)

menu_items.run_update()