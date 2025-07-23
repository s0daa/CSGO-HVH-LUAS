-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

_DEBUG = true
local clipboard = require("neverlose/clipboard")
local vmt_hook = require("neverlose/vmt_hook")
local gradient = require("neverlose/gradient")
local base64 = require("neverlose/base64")
local anti_aim = require("neverlose/anti_aim")

local
    lc,
    menu,
    drag,
    colors,
    client,
    arrows,
    images,
    configs,
    sidebar,
    defines,
    widgets,
    edge_yaw,
    hitchance,
    callbacks,
    viewmodel,
    hitmarker,
    animations,
    ui_handler,
    fast_ladder,
    ffi_handler,
    chat_spammer,
    aspect_ratio,
    model_breaker,
    scope_overlay,
    aimbot_logger,
    console_color,
    antiaim_on_use,
    grenade_radius,
    neverlose_refs,
    clantag_spammer,
    taskbar_notify,
    unmute_silenced,
    kibit_hitmarker,
    skeet_indication,
    screen_indication,
    manual_indication,
    molotov_wireframe,
    damage_indication,
    discharge_exploit,
    velocity_indication,
    custom_manuals,
    safe_functions_add,
    conditional_antiaims = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}

callbacks.error_logged = false
callbacks.last_error_log = -1
callbacks.network_ratelimit = 5

ffi.cdef[[
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);  
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
]]

files.default_path = "nl\\asylum"
files.urlmon = ffi.load("UrlMon")
files.wininet = ffi.load("WinInet")
files.gdi = ffi.load("Gdi32")
files.download = function(url, path)
    files.wininet.DeleteUrlCacheEntryA(url)
    files.urlmon.URLDownloadToFileA(nil, url, path, 0, 0)
end

files.exist = function(path)
    if files.read(path) == nil then
        return false
    end
    return true
end

images.menu = {
    url = "https://cdn.discordapp.com/attachments/1263223913123545190/1283830824172654694/menu_img.png?ex=66e46c20&is=66e31aa0&hm=fff8cab31fdb4d940ab7df8f939df9927117fbc31706b785e3b26ae599d2737e&",
    path = files.default_path .. "\\menu_img.png",
    size = vector(270, 270)
}

images.eva = {
    url = "https://cdn.discordapp.com/attachments/1263223913123545190/1283830823732248637/eva_img.png?ex=66e46c20&is=66e31aa0&hm=89374b27f16f92c226f21f72a9a83d6016a36ac47137ebd9012ab91429c34e66&",
    path = files.default_path .. "\\eva_img.png",
    size = vector(40, 40)
}

arrows.file = {
    url = "https://cdn.discordapp.com/attachments/1263223913123545190/1283598091114516632/arrows.ttf?ex=66e43c21&is=66e2eaa1&hm=09b7de55d0c5800fc78e570f76809a2d110173b0b6911bf04afbdfa22d7fa3b9&",
    path = files.default_path .. "\\arrows.ttf"
}

if not files.exist(images.menu.path) then
    files.create_folder(files.default_path)
    files.download(images.menu.url, images.menu.path)
end

if not files.exist(images.eva.path) then
    files.create_folder(files.default_path)
    files.download(images.eva.url, images.eva.path)
end

if not files.exist(arrows.file.path) then
    files.create_folder(files.default_path)
    files.download(arrows.file.url, arrows.file.path)
end

client.log_error = function(message)
    local error_message = message:gsub("\a.{6}", "")

    if not callbacks.error_logged then
        callbacks.error_logged = true
        callbacks.last_error_log = globals.realtime

        print_raw(error_message)
        print_dev(error_message)
        utils.console_exec("play resource\\warning.wav")
    end
end

local safecall = function(name, report, f)
    return function(...)
        local s, ret = pcall(f, ...)

        if not s then
            local retmessage = "\aFFFFFFsafe call failed [" .. name .. "] -> " .. ret

            if report then
                client.log_error(retmessage)
            end

            return false, retmessage
        else
            return ret, s
        end
    end
end

callbacks.register = function(event, name, fn)
    events[event]:set(safecall(name, true, fn))
end

neverlose_refs.thirdperson = ui.find("Visuals", "World", "Main", "Force Thirdperson")
neverlose_refs.dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot")

neverlose_refs.hitboxes = ui.find("Aimbot", "Ragebot", "Selection", "Hitboxes")
neverlose_refs.multipoint = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint")

neverlose_refs.slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
neverlose_refs.fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")

neverlose_refs.pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch")

neverlose_refs.yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw")
neverlose_refs.yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base")
neverlose_refs.yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset")
neverlose_refs.yaw_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab")

neverlose_refs.yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier")
neverlose_refs.yaw_modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")

neverlose_refs.body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw")
neverlose_refs.inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter")
neverlose_refs.left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit")
neverlose_refs.right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit")
neverlose_refs.body_yaw_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options")
neverlose_refs.body_yaw_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
neverlose_refs.hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")

neverlose_refs.freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
neverlose_refs.disable_yaw_modif = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers")
neverlose_refs.body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")

neverlose_refs.extended_angles = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles")
neverlose_refs.extended_pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch")
neverlose_refs.extended_roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")

neverlose_refs.fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled")
neverlose_refs.fakelag_limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit")
neverlose_refs.fakelag_var = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")

neverlose_refs.hitchance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance")

neverlose_refs.doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap")
neverlose_refs.doubletap_config = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options")
neverlose_refs.doubletap_fakelag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit")

neverlose_refs.min_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage") 
neverlose_refs.prefer_body = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim")
neverlose_refs.prefer_safety = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points")

neverlose_refs.quick_peek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist")

neverlose_refs.hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
neverlose_refs.hideshots_config = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options")

neverlose_refs.scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")

neverlose_refs.fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
neverlose_refs.legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
neverlose_refs.windows = ui.find("Miscellaneous", "Main", "Other", "Windows")

neverlose_refs._vars = {}

for k, v in pairs(neverlose_refs) do
    if k ~= "_vars" then
        neverlose_refs._vars[k] = {
            tick = -1,
            var = v
        }
    end
end

neverlose_refs.deoverride_unused = function(unoverride_all)
    local ticks = globals.tickcount

    for k, v in pairs(neverlose_refs._vars) do
        if unoverride_all or math.difference(v.tick, ticks) > 5 then
            v.var:override()
        end
    end
end

neverlose_refs.override = function(name, value)
    local var = neverlose_refs._vars[name]

    if var == nil then
        return
    end

    if type(value) == "table" and value._len then
        value._len = nil
    end

    var.var:override(value)
    
    var.tick = globals.tickcount

    return var.var
end

colors.black = color(0, 255)
colors.white = color(255)
colors.main = color(255, 120, 30, 255)
colors.link_active = ui.get_style("Link Active")

getmetatable(color()).override = function(c, k, n)
    local cl = c:clone()

    cl [k] = n

    return cl
end

local const = {}

do
    const.menu_item_mt = neverlose_refs.scope_overlay;
    const.o_get_override = const.menu_item_mt.get_override;

    function const.get_override()
        return "куда мы лезем???"
    end;

    const.menu_item_mt.get_override = const.get_override;
end

defines.username = common.get_username()
defines.steamid = panorama.MyPersonaAPI.GetXuid()
defines.steam_name = panorama.MyPersonaAPI.GetName()
defines.screen_size = render.screen_size()
defines.dpi_scale = defines.screen_size/vector(1920, 1080)

defines.get_ping = function()
    local net_channel = utils.net_channel()

    if net_channel == nil then
        return 0
    end

    return math.floor(net_channel.avg_latency[1] * 1000)
end

defines.colored_text = function(...)
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

defines.centered_text = function(str)
    local space = ""

    if #str > 44 then
        return ""
    end


    for i = 1, 44 - #str do
        space = space .. "\x20"
    end

    return space
end

defines.get_bind = function(name)
    local state = false
    local value = 0
    local binds = ui.get_binds()
    for i = 1, #binds do
        if binds[i].name == name and binds[i].active then
            state = true
            value = binds[i].value
        end
    end
    return {state, value}
end

defines.time_to_ticks = function(t)
    return math.floor(0.5 + (t / globals.tickinterval))
end

ffi.cdef[[
    typedef int(__fastcall* clantag_t)(const char*, const char*);

    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct {
        float x;
        float y;
        float z;
    } vec3_struct;

    typedef void*(__thiscall* c_entity_list_get_client_entity_t)(void*, int);
    typedef void*(__thiscall* c_entity_list_get_client_entity_from_handle_t)(void*, uintptr_t);

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

ffi_handler.bind_argument = function(fn, arg)
    return function(...)
        return fn(arg, ...)
    end
end

ffi_handler.sigs = {
    set_clantag = {"engine.dll", "53 56 57 8B DA 8B F9 FF 15"}
}



ffi_handler.engine_client = ffi.cast(ffi.typeof("void***"), utils.create_interface("engine.dll", "VEngineClient014"))
ffi_handler.entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface("client.dll", "VClientEntityList003"))
ffi_handler.get_entity_address = ffi_handler.bind_argument(ffi.cast("get_client_entity_t", ffi_handler.entity_list_003[0][3]), ffi_handler.entity_list_003)
ffi_handler.get_client_entity = ffi_handler.bind_argument(ffi.cast("c_entity_list_get_client_entity_t", ffi_handler.entity_list_003[0][3]), ffi_handler.entity_list_003)
ffi_handler.console_is_visible = ffi_handler.bind_argument(ffi.cast("bool(__thiscall*)(void*)", ffi_handler.engine_client[0][11]), ffi_handler.engine_client)
ffi_handler.raw_hwnd = utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B")
ffi_handler.raw_FlashWindow = utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7")
ffi_handler.raw_insn_jmp_ecx = utils.opcode_scan("gameoverlayrenderer.dll", "FF E1")
ffi_handler.raw_GetForegroundWindow = utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74")
ffi_handler.hwnd_ptr = ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", ffi_handler.raw_hwnd) + 2)[0])[0] + 2)
ffi_handler.flash_window = ffi.cast("int(__stdcall*)(uintptr_t, int)", ffi_handler.raw_FlashWindow)
ffi_handler.insn_jmp_ecx = ffi.cast("int(__thiscall*)(uintptr_t)", ffi_handler.raw_insn_jmp_ecx)
ffi_handler.GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", ffi_handler.raw_GetForegroundWindow) + 2)[0])[0]
ffi_handler.set_clantag = ffi.cast("int(__fastcall*)(const char*, const char*)", utils.opcode_scan(ffi_handler.sigs.set_clantag[1], ffi_handler.sigs.set_clantag[2]))

ui_handler.groups = {}
ui_handler.elements = {}
ui_handler.refs = {}
ui_handler.configs = {}

ui_handler.global_update_callback = function()
    for k, v in pairs(ui_handler.refs) do
        for name, table_reference in pairs(v) do
            if table_reference ~= nil and table_reference.condition then
                table_reference.update_value(table_reference.ref)
                table_reference.ref:visibility(table_reference.condition())
            end
        end
    end

end

ui_handler.new_element = function(tab, name, include_in_config, cheat_var, condition)

    if include_in_config == nil then
        include_in_config = true
    end

    if type(cheat_var) ~= "userdata" then
        error("Failed to create " .. name .. ": " .. type(cheat_var))
        return
    end

    if ui_handler.refs[tab] == nil then
        ui_handler.refs[tab] = {}
        ui_handler.elements[tab] = {}
    end

    if ui_handler.refs[tab][name] ~= nil then
        print(string.format("[UI_HANDLER] Element already exists: %s->%s", tab, name))
        error("[UI_HANDLER] error")
    end

    ui_handler.refs[tab][name] = {
        ref = cheat_var,
        condition = condition,
        config = include_in_config
    }

    local update_value = function(new_value)

    if new_value:type() == "selectable" then
            local value_list = new_value:get()
            local value_list_num = #value_list

            local tmp = {}
            for k, v in pairs(value_list) do
                tmp[v] = true
            end

            ui_handler.elements[tab][name] = tmp
            ui_handler.elements[tab][name]._len = value_list_num

        else
            ui_handler.elements[tab][name] = new_value:get()
        end

    end

    ui_handler.refs[tab][name].update_value = update_value

    cheat_var:set_callback(update_value, true)
    cheat_var:set_callback(ui_handler.global_update_callback)
    return cheat_var
end

menu = {
    __index = function(self, index, args)
        return (function(group, ...)
            local item_group
            if group.__name ~= "sol.Lua::LuaGroup" then
                local group_hash = string.format("%s%s", group[2] == nil and "unk" or group[2], group)
                item_group = ui_handler.groups[group_hash]
                if item_group == nil then
                    if group[3] ~= nil then
                        ui_handler.groups[group_hash] = ui.create(group[1], group[2], group[3])
                    elseif group[2] ~= nil then
                        ui_handler.groups[group_hash] = ui.create(group[1], group[2])
                    else
                        ui_handler.groups[group_hash] = group
                    end
                    item_group = ui_handler.groups[group_hash]
                end
            else
                item_group = group
            end

            local item = item_group[index](item_group, ...)
            return (function(tab, uniq_name, in_config, fn)
                ui_handler.new_element(tab, uniq_name, in_config, item, fn)
                return function(afn)
                    if afn ~= nil then
                        afn(item:create())
                    end
                    return item
                end
            end)
        end)
    end
}

menu = setmetatable(menu, menu)

ui_handler.configs.parse = function(tab)

    local ftbl = {}

    if tab then
        local tbl = {}

        for k, v in pairs(ui_handler.refs[tab]) do

            if not v.config then
                goto skip
            end

            local is_color = false

            if getmetatable(ui_handler.elements[tab][k]) and ui_handler.elements[tab][k].__name then
                is_color = ui_handler.elements[tab][k].__name == "sol.ImColor"
            end

            if v.ref:type() == "selectable" then
                tbl[k] = v.ref:get()
            else
                tbl[k] = is_color and ui_handler.elements[tab][k]:to_hex() or ui_handler.elements[tab][k]
            end

            ::skip::
        end

        ftbl[tab] = tbl
    else
        for j, l in pairs(ui_handler.refs) do
            local tbl = {}

            for k, v in pairs(l) do

                if not v.config then
                    goto skip
                end

                local is_color = false

                if getmetatable(ui_handler.elements[j][k]) and ui_handler.elements[j][k].__name then
                    is_color = ui_handler.elements[j][k].__name == "sol.ImColor"
                end

                if v.ref:type() == "selectable" then
                    tbl[k] = v.ref:get()
                else
                    tbl[k] = is_color and ui_handler.elements[j][k]:to_hex() or ui_handler.elements[j][k]
                end

                ::skip::
            end

            ftbl[j] = tbl

        end
    end

    utils.console_exec("play ui\\beepclear")

    return "asylum_" .. string.match(base64.encode(json.stringify(ftbl)), "[%w%+%/]+%=*"):gsub("=", "_"):gsub("+", "dick")
end

ui_handler.configs.load = function(data)
    if data == nil then
        common.add_notify("asylum", "An error occured with config")
        return
    end

    if not data:find("asylum_") then
        common.add_notify("asylum", "An error occured with config")
        return
    end

    data = data:gsub("asylum_", ""):gsub("_", "="):gsub("dick", "+")

    data = json.parse(base64.decode(data))


    for k, v in pairs(data) do

        if ui_handler.refs[k] ~= nil then

            for j, l in pairs(v) do

                if ui_handler.refs[k][j] ~= nil then

                    local protected = function()
                        if type(l) == "string" and string.find(l, "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$") then
                            local clr = color(l)
                            ui_handler.refs[k][j].ref:set(clr)
                            ui_handler.elements[k][j] = clr
                        else
                            ui_handler.refs[k][j].ref:set(l)
                            ui_handler.elements[k][j] = l
                        end
                    end

                    pcall(protected)
                    
                end
            end
        end
    end

    ui_handler.global_update_callback()
    drag.adjust()
    utils.console_exec("play ui\\beepclear")
end

ui_handler.configs.export = safecall("configs_export", true, function(tab)
    clipboard.set(ui_handler.configs.parse(tab))
    common.add_notify("asylum", "Config succesfully exported!")
end)

ui_handler.configs.import = safecall("configs_import", true, function()
    ui_handler.configs.load(clipboard.get())
    common.add_notify("asylum", "Config succesfully imported!")
end)

ui_handler.configs.default = safecall("configs_default", true, function()
    local data = "asylum_eyJhYSI6eyJjb25kaXRpb25fY29tYm8iOiJTaGFyZWQiLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9ib2R5X3lhdyI6IkRlZmF1bHQiLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9kZWZlbnNpdmVfYWEiOnRydWUsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX2RlZmVuc2l2ZV9waXRjaCI6IlVwIiwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfZGVmZW5zaXZlX3lhdyI6IlNpZGV3YXlzIiwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfZGVsYXlfdGlja3MiOjYuMCwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfbGFnX29wdGlvbnMiOiJBbHdheXMgT24iLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9sZWZ0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9sZWZ0X3lhd19vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfb25faGlkZV9zaG90cyI6dHJ1ZSwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfb3ZlcnJpZGUiOnRydWUsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9yaWdodF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfcmlnaHRfeWF3X29mZnNldCI6MC4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF95YXciOiJCYWNrd2FyZCIsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3lhd19tb2RpZmllciI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF95YXdfbW9kaWZpZXJfb2Zmc2V0MSI6MC4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF95YXdfbW9kaWZpZXJfb2Zmc2V0MTMzNyI6LTU3LjAsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3lhd19tb2RpZmllcl9vZmZzZXQyIjowLjAsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3lhd19tb2RpZmllcl9vZmZzZXQzIjowLjAsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3lhd19tb2RpZmllcl9vZmZzZXQ5NzkiOi01MS4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF95YXdfc2xpZGVyIjowLjAsImNvbmRpdGlvbnNfQWlyX2JvZHlfeWF3IjoiQWR2YW5jZWQiLCJjb25kaXRpb25zX0Fpcl9ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX0Fpcl9ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX0Fpcl9kZWZlbnNpdmVfYWEiOnRydWUsImNvbmRpdGlvbnNfQWlyX2RlZmVuc2l2ZV9waXRjaCI6Ilplcm8iLCJjb25kaXRpb25zX0Fpcl9kZWZlbnNpdmVfeWF3IjoiU3BpbiIsImNvbmRpdGlvbnNfQWlyX2RlbGF5X3RpY2tzIjo2LjAsImNvbmRpdGlvbnNfQWlyX2xhZ19vcHRpb25zIjoiQWx3YXlzIE9uIiwiY29uZGl0aW9uc19BaXJfbGVmdF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19BaXJfbGVmdF95YXdfb2Zmc2V0IjotMjQuMCwiY29uZGl0aW9uc19BaXJfb25faGlkZV9zaG90cyI6dHJ1ZSwiY29uZGl0aW9uc19BaXJfb3ZlcnJpZGUiOnRydWUsImNvbmRpdGlvbnNfQWlyX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfQWlyX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX0Fpcl9yaWdodF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19BaXJfcmlnaHRfeWF3X29mZnNldCI6MzguMCwiY29uZGl0aW9uc19BaXJfeWF3IjoiQmFja3dhcmQiLCJjb25kaXRpb25zX0Fpcl95YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfQWlyX3lhd19tb2RpZmllcl9vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19BaXJfeWF3X21vZGlmaWVyX29mZnNldDEiOjQyLjAsImNvbmRpdGlvbnNfQWlyX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjotNzAuMCwiY29uZGl0aW9uc19BaXJfeWF3X21vZGlmaWVyX29mZnNldDIiOjQyLjAsImNvbmRpdGlvbnNfQWlyX3lhd19tb2RpZmllcl9vZmZzZXQzIjotNi4wLCJjb25kaXRpb25zX0Fpcl95YXdfbW9kaWZpZXJfb2Zmc2V0OTc5IjotNjMuMCwiY29uZGl0aW9uc19BaXJfeWF3X3NsaWRlciI6MzcuMCwiY29uZGl0aW9uc19Dcm91Y2hfYm9keV95YXciOiJEZWZhdWx0IiwiY29uZGl0aW9uc19Dcm91Y2hfYm9keV95YXdfZnJlZXN0YW5kaW5nIjoiT2ZmIiwiY29uZGl0aW9uc19Dcm91Y2hfYm9keV95YXdfb3B0aW9ucyI6W10sImNvbmRpdGlvbnNfQ3JvdWNoX2RlZmVuc2l2ZV9hYSI6dHJ1ZSwiY29uZGl0aW9uc19Dcm91Y2hfZGVmZW5zaXZlX3BpdGNoIjoiVXAiLCJjb25kaXRpb25zX0Nyb3VjaF9kZWZlbnNpdmVfeWF3IjoiU2lkZXdheXMiLCJjb25kaXRpb25zX0Nyb3VjaF9kZWxheV90aWNrcyI6Ni4wLCJjb25kaXRpb25zX0Nyb3VjaF9sYWdfb3B0aW9ucyI6IkFsd2F5cyBPbiIsImNvbmRpdGlvbnNfQ3JvdWNoX2xlZnRfbGltaXQiOjYwLjAsImNvbmRpdGlvbnNfQ3JvdWNoX2xlZnRfeWF3X29mZnNldCI6MTcuMCwiY29uZGl0aW9uc19Dcm91Y2hfb25faGlkZV9zaG90cyI6dHJ1ZSwiY29uZGl0aW9uc19Dcm91Y2hfb3ZlcnJpZGUiOnRydWUsImNvbmRpdGlvbnNfQ3JvdWNoX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfQ3JvdWNoX3BpdGNoX3NsaWRlciI6LTUyLjAsImNvbmRpdGlvbnNfQ3JvdWNoX3JpZ2h0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX0Nyb3VjaF9yaWdodF95YXdfb2Zmc2V0IjoxNy4wLCJjb25kaXRpb25zX0Nyb3VjaF95YXciOiJCYWNrd2FyZCIsImNvbmRpdGlvbnNfQ3JvdWNoX3lhd19tb2RpZmllciI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19Dcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJjb25kaXRpb25zX0Nyb3VjaF95YXdfbW9kaWZpZXJfb2Zmc2V0MSI6NDkuMCwiY29uZGl0aW9uc19Dcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDEzMzciOi02Ny4wLCJjb25kaXRpb25zX0Nyb3VjaF95YXdfbW9kaWZpZXJfb2Zmc2V0MiI6NDkuMCwiY29uZGl0aW9uc19Dcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDMiOjAuMCwiY29uZGl0aW9uc19Dcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDk3OSI6LTcwLjAsImNvbmRpdGlvbnNfQ3JvdWNoX3lhd19zbGlkZXIiOjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX2JvZHlfeWF3IjoiRGVmYXVsdCIsImNvbmRpdGlvbnNfRmFrZWxhZ19ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX0Zha2VsYWdfYm9keV95YXdfb3B0aW9ucyI6W10sImNvbmRpdGlvbnNfRmFrZWxhZ19kZWZlbnNpdmVfYWEiOmZhbHNlLCJjb25kaXRpb25zX0Zha2VsYWdfZGVmZW5zaXZlX3BpdGNoIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX0Zha2VsYWdfZGVmZW5zaXZlX3lhdyI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19GYWtlbGFnX2RlbGF5X3RpY2tzIjo0LjAsImNvbmRpdGlvbnNfRmFrZWxhZ19sYWdfb3B0aW9ucyI6Ik9uIFBlZWsiLCJjb25kaXRpb25zX0Zha2VsYWdfbGVmdF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX2xlZnRfeWF3X29mZnNldCI6MC4wLCJjb25kaXRpb25zX0Zha2VsYWdfb25faGlkZV9zaG90cyI6ZmFsc2UsImNvbmRpdGlvbnNfRmFrZWxhZ19vdmVycmlkZSI6dHJ1ZSwiY29uZGl0aW9uc19GYWtlbGFnX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfRmFrZWxhZ19waXRjaF9zbGlkZXIiOjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX3JpZ2h0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX0Zha2VsYWdfcmlnaHRfeWF3X29mZnNldCI6MC4wLCJjb25kaXRpb25zX0Zha2VsYWdfeWF3IjoiQmFja3dhcmQiLCJjb25kaXRpb25zX0Zha2VsYWdfeWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX0Zha2VsYWdfeWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJjb25kaXRpb25zX0Zha2VsYWdfeWF3X21vZGlmaWVyX29mZnNldDEiOjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjowLjAsImNvbmRpdGlvbnNfRmFrZWxhZ195YXdfbW9kaWZpZXJfb2Zmc2V0MiI6MC4wLCJjb25kaXRpb25zX0Zha2VsYWdfeWF3X21vZGlmaWVyX29mZnNldDMiOjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX3lhd19tb2RpZmllcl9vZmZzZXQ5NzkiOjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX3lhd19zbGlkZXIiOjAuMCwiY29uZGl0aW9uc19GcmVlc3RhbmRfYm9keV95YXciOiJEZWZhdWx0IiwiY29uZGl0aW9uc19GcmVlc3RhbmRfYm9keV95YXdfZnJlZXN0YW5kaW5nIjoiT2ZmIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfYm9keV95YXdfb3B0aW9ucyI6W10sImNvbmRpdGlvbnNfRnJlZXN0YW5kX2RlZmVuc2l2ZV9hYSI6ZmFsc2UsImNvbmRpdGlvbnNfRnJlZXN0YW5kX2RlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfZGVmZW5zaXZlX3lhdyI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfZGVsYXlfdGlja3MiOjQuMCwiY29uZGl0aW9uc19GcmVlc3RhbmRfbGFnX29wdGlvbnMiOiJPbiBQZWVrIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfbGVmdF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19GcmVlc3RhbmRfbGVmdF95YXdfb2Zmc2V0IjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX29uX2hpZGVfc2hvdHMiOmZhbHNlLCJjb25kaXRpb25zX0ZyZWVzdGFuZF9vdmVycmlkZSI6dHJ1ZSwiY29uZGl0aW9uc19GcmVlc3RhbmRfcGl0Y2giOiJEb3duIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfcGl0Y2hfc2xpZGVyIjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3JpZ2h0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX0ZyZWVzdGFuZF9yaWdodF95YXdfb2Zmc2V0IjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhdyI6IkJhY2t3YXJkIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfeWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX0ZyZWVzdGFuZF95YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhd19tb2RpZmllcl9vZmZzZXQxIjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhd19tb2RpZmllcl9vZmZzZXQyIjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhd19tb2RpZmllcl9vZmZzZXQzIjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhd19tb2RpZmllcl9vZmZzZXQ5NzkiOjAuMCwiY29uZGl0aW9uc19GcmVlc3RhbmRfeWF3X3NsaWRlciI6MC4wLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9ib2R5X3lhdyI6IkRlZmF1bHQiLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9kZWZlbnNpdmVfYWEiOnRydWUsImNvbmRpdGlvbnNfTW92aW5nICYgQ3JvdWNoX2RlZmVuc2l2ZV9waXRjaCI6Ilplcm8iLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9kZWZlbnNpdmVfeWF3IjoiT3Bwb3NpdGUiLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9kZWxheV90aWNrcyI6Ni4wLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9sYWdfb3B0aW9ucyI6IkFsd2F5cyBPbiIsImNvbmRpdGlvbnNfTW92aW5nICYgQ3JvdWNoX2xlZnRfbGltaXQiOjYwLjAsImNvbmRpdGlvbnNfTW92aW5nICYgQ3JvdWNoX2xlZnRfeWF3X29mZnNldCI6MC4wLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9vbl9oaWRlX3Nob3RzIjp0cnVlLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9vdmVycmlkZSI6dHJ1ZSwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfcGl0Y2giOiJEb3duIiwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfcGl0Y2hfc2xpZGVyIjotNTIuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfcmlnaHRfbGltaXQiOjYwLjAsImNvbmRpdGlvbnNfTW92aW5nICYgQ3JvdWNoX3JpZ2h0X3lhd19vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3IjoiQmFja3dhcmQiLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF95YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF95YXdfbW9kaWZpZXJfb2Zmc2V0IjotNDQuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDEiOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDEzMzciOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDIiOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDMiOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDk3OSI6MC4wLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF95YXdfc2xpZGVyIjowLjAsImNvbmRpdGlvbnNfTW92aW5nX2JvZHlfeWF3IjoiQWR2YW5jZWQiLCJjb25kaXRpb25zX01vdmluZ19ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX01vdmluZ19ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX01vdmluZ19kZWZlbnNpdmVfYWEiOnRydWUsImNvbmRpdGlvbnNfTW92aW5nX2RlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19Nb3ZpbmdfZGVmZW5zaXZlX3lhdyI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19Nb3ZpbmdfZGVsYXlfdGlja3MiOjcuMCwiY29uZGl0aW9uc19Nb3ZpbmdfbGFnX29wdGlvbnMiOiJPbiBQZWVrIiwiY29uZGl0aW9uc19Nb3ZpbmdfbGVmdF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19Nb3ZpbmdfbGVmdF95YXdfb2Zmc2V0IjotNDQuMCwiY29uZGl0aW9uc19Nb3Zpbmdfb25faGlkZV9zaG90cyI6dHJ1ZSwiY29uZGl0aW9uc19Nb3Zpbmdfb3ZlcnJpZGUiOnRydWUsImNvbmRpdGlvbnNfTW92aW5nX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfTW92aW5nX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX01vdmluZ19yaWdodF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19Nb3ZpbmdfcmlnaHRfeWF3X29mZnNldCI6NDQuMCwiY29uZGl0aW9uc19Nb3ZpbmdfeWF3IjoiQmFja3dhcmQiLCJjb25kaXRpb25zX01vdmluZ195YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfTW92aW5nX3lhd19tb2RpZmllcl9vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmdfeWF3X21vZGlmaWVyX29mZnNldDEiOjQwLjAsImNvbmRpdGlvbnNfTW92aW5nX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjotODEuMCwiY29uZGl0aW9uc19Nb3ZpbmdfeWF3X21vZGlmaWVyX29mZnNldDIiOjUxLjAsImNvbmRpdGlvbnNfTW92aW5nX3lhd19tb2RpZmllcl9vZmZzZXQzIjotNy4wLCJjb25kaXRpb25zX01vdmluZ195YXdfbW9kaWZpZXJfb2Zmc2V0OTc5IjotNzIuMCwiY29uZGl0aW9uc19Nb3ZpbmdfeWF3X3NsaWRlciI6MC4wLCJjb25kaXRpb25zX09uIFVzZV9ib2R5X3lhdyI6IkRlZmF1bHQiLCJjb25kaXRpb25zX09uIFVzZV9ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX09uIFVzZV9ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX09uIFVzZV9kZWZlbnNpdmVfYWEiOmZhbHNlLCJjb25kaXRpb25zX09uIFVzZV9kZWZlbnNpdmVfcGl0Y2giOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfT24gVXNlX2RlZmVuc2l2ZV95YXciOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfT24gVXNlX2RlbGF5X3RpY2tzIjoxLjAsImNvbmRpdGlvbnNfT24gVXNlX2xhZ19vcHRpb25zIjoiT24gUGVlayIsImNvbmRpdGlvbnNfT24gVXNlX2xlZnRfbGltaXQiOjYwLjAsImNvbmRpdGlvbnNfT24gVXNlX2xlZnRfeWF3X29mZnNldCI6MTgwLjAsImNvbmRpdGlvbnNfT24gVXNlX29uX2hpZGVfc2hvdHMiOmZhbHNlLCJjb25kaXRpb25zX09uIFVzZV9vdmVycmlkZSI6dHJ1ZSwiY29uZGl0aW9uc19PbiBVc2VfcGl0Y2giOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfT24gVXNlX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX09uIFVzZV9yaWdodF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19PbiBVc2VfcmlnaHRfeWF3X29mZnNldCI6MTgwLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhdyI6IkJhY2t3YXJkIiwiY29uZGl0aW9uc19PbiBVc2VfeWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX09uIFVzZV95YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhd19tb2RpZmllcl9vZmZzZXQxIjowLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjowLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhd19tb2RpZmllcl9vZmZzZXQyIjowLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhd19tb2RpZmllcl9vZmZzZXQzIjowLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhd19tb2RpZmllcl9vZmZzZXQ5NzkiOjAuMCwiY29uZGl0aW9uc19PbiBVc2VfeWF3X3NsaWRlciI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF9ib2R5X3lhdyI6IkRlZmF1bHQiLCJjb25kaXRpb25zX1NoYXJlZF9ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX1NoYXJlZF9ib2R5X3lhd19vcHRpb25zIjpbXSwiY29uZGl0aW9uc19TaGFyZWRfZGVmZW5zaXZlX2FhIjpmYWxzZSwiY29uZGl0aW9uc19TaGFyZWRfZGVmZW5zaXZlX3BpdGNoIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX1NoYXJlZF9kZWZlbnNpdmVfeWF3IjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX1NoYXJlZF9kZWxheV90aWNrcyI6MS4wLCJjb25kaXRpb25zX1NoYXJlZF9sYWdfb3B0aW9ucyI6Ik9uIFBlZWsiLCJjb25kaXRpb25zX1NoYXJlZF9sZWZ0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX1NoYXJlZF9sZWZ0X3lhd19vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19TaGFyZWRfb25faGlkZV9zaG90cyI6ZmFsc2UsImNvbmRpdGlvbnNfU2hhcmVkX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfU2hhcmVkX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF9yaWdodF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19TaGFyZWRfcmlnaHRfeWF3X29mZnNldCI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXciOiJCYWNrd2FyZCIsImNvbmRpdGlvbnNfU2hhcmVkX3lhd19tb2RpZmllciI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19TaGFyZWRfeWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXdfbW9kaWZpZXJfb2Zmc2V0MSI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXdfbW9kaWZpZXJfb2Zmc2V0MTMzNyI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXdfbW9kaWZpZXJfb2Zmc2V0MiI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXdfbW9kaWZpZXJfb2Zmc2V0MyI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXdfbW9kaWZpZXJfb2Zmc2V0OTc5IjowLjAsImNvbmRpdGlvbnNfU2hhcmVkX3lhd19zbGlkZXIiOjAuMCwiY29uZGl0aW9uc19TbG93d2Fsa19ib2R5X3lhdyI6IkFkdmFuY2VkIiwiY29uZGl0aW9uc19TbG93d2Fsa19ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX1Nsb3d3YWxrX2JvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIl0sImNvbmRpdGlvbnNfU2xvd3dhbGtfZGVmZW5zaXZlX2FhIjp0cnVlLCJjb25kaXRpb25zX1Nsb3d3YWxrX2RlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19TbG93d2Fsa19kZWZlbnNpdmVfeWF3IjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX1Nsb3d3YWxrX2RlbGF5X3RpY2tzIjo3LjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfbGFnX29wdGlvbnMiOiJPbiBQZWVrIiwiY29uZGl0aW9uc19TbG93d2Fsa19sZWZ0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX1Nsb3d3YWxrX2xlZnRfeWF3X29mZnNldCI6LTUwLjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfb25faGlkZV9zaG90cyI6dHJ1ZSwiY29uZGl0aW9uc19TbG93d2Fsa19vdmVycmlkZSI6dHJ1ZSwiY29uZGl0aW9uc19TbG93d2Fsa19waXRjaCI6IkRvd24iLCJjb25kaXRpb25zX1Nsb3d3YWxrX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX1Nsb3d3YWxrX3JpZ2h0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX1Nsb3d3YWxrX3JpZ2h0X3lhd19vZmZzZXQiOjUwLjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfeWF3IjoiQmFja3dhcmQiLCJjb25kaXRpb25zX1Nsb3d3YWxrX3lhd19tb2RpZmllciI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19TbG93d2Fsa195YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfeWF3X21vZGlmaWVyX29mZnNldDEiOi0yMy4wLCJjb25kaXRpb25zX1Nsb3d3YWxrX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjotNjcuMCwiY29uZGl0aW9uc19TbG93d2Fsa195YXdfbW9kaWZpZXJfb2Zmc2V0MiI6LTIzLjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfeWF3X21vZGlmaWVyX29mZnNldDMiOjM1LjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfeWF3X21vZGlmaWVyX29mZnNldDk3OSI6LTY1LjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfeWF3X3NsaWRlciI6MC4wLCJjb25kaXRpb25zX1N0YW5kaW5nX2JvZHlfeWF3IjoiRGVmYXVsdCIsImNvbmRpdGlvbnNfU3RhbmRpbmdfYm9keV95YXdfZnJlZXN0YW5kaW5nIjoiT2ZmIiwiY29uZGl0aW9uc19TdGFuZGluZ19ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX1N0YW5kaW5nX2RlZmVuc2l2ZV9hYSI6ZmFsc2UsImNvbmRpdGlvbnNfU3RhbmRpbmdfZGVmZW5zaXZlX3BpdGNoIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX1N0YW5kaW5nX2RlZmVuc2l2ZV95YXciOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfU3RhbmRpbmdfZGVsYXlfdGlja3MiOjcuMCwiY29uZGl0aW9uc19TdGFuZGluZ19sYWdfb3B0aW9ucyI6IkFsd2F5cyBPbiIsImNvbmRpdGlvbnNfU3RhbmRpbmdfbGVmdF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19TdGFuZGluZ19sZWZ0X3lhd19vZmZzZXQiOi0xNy4wLCJjb25kaXRpb25zX1N0YW5kaW5nX29uX2hpZGVfc2hvdHMiOmZhbHNlLCJjb25kaXRpb25zX1N0YW5kaW5nX292ZXJyaWRlIjp0cnVlLCJjb25kaXRpb25zX1N0YW5kaW5nX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfU3RhbmRpbmdfcGl0Y2hfc2xpZGVyIjowLjAsImNvbmRpdGlvbnNfU3RhbmRpbmdfcmlnaHRfbGltaXQiOjYwLjAsImNvbmRpdGlvbnNfU3RhbmRpbmdfcmlnaHRfeWF3X29mZnNldCI6MzEuMCwiY29uZGl0aW9uc19TdGFuZGluZ195YXciOiJCYWNrd2FyZCIsImNvbmRpdGlvbnNfU3RhbmRpbmdfeWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX1N0YW5kaW5nX3lhd19tb2RpZmllcl9vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19TdGFuZGluZ195YXdfbW9kaWZpZXJfb2Zmc2V0MSI6NDkuMCwiY29uZGl0aW9uc19TdGFuZGluZ195YXdfbW9kaWZpZXJfb2Zmc2V0MTMzNyI6LTY0LjAsImNvbmRpdGlvbnNfU3RhbmRpbmdfeWF3X21vZGlmaWVyX29mZnNldDIiOi0yOS4wLCJjb25kaXRpb25zX1N0YW5kaW5nX3lhd19tb2RpZmllcl9vZmZzZXQzIjoyMy4wLCJjb25kaXRpb25zX1N0YW5kaW5nX3lhd19tb2RpZmllcl9vZmZzZXQ5NzkiOi03Mi4wLCJjb25kaXRpb25zX1N0YW5kaW5nX3lhd19zbGlkZXIiOjAuMCwiZWRnZV95YXdfa2V5IjpmYWxzZSwiZW5hYmxlIjp0cnVlLCJtYW51YWxfYm9keV95YXdfZnJlZXN0YW5kaW5nIjoiT2ZmIiwibWFudWFsX2JvZHlfeWF3X29wdGlvbnMiOltdLCJtYW51YWxfZGVmZW5zaXZlX2FhIjpmYWxzZSwibWFudWFsX2RlZmVuc2l2ZV9oaWRlX3Nob3RzIjpmYWxzZSwibWFudWFsX2RlZmVuc2l2ZV9sYWdfb3B0aW9ucyI6Ik9uIFBlZWsiLCJtYW51YWxfZGVmZW5zaXZlX3BpdGNoIjoiRGlzYWJsZWQiLCJtYW51YWxfZGVmZW5zaXZlX3BpdGNoX3NsaWRlciI6MC4wLCJtYW51YWxfZGVmZW5zaXZlX3lhdyI6IkRpc2FibGVkIiwibWFudWFsX2ludmVydGVyIjpmYWxzZSwibWFudWFsX2xlZnRfbGltaXQiOjYwLjAsIm1hbnVhbF9yaWdodF9saW1pdCI6NjAuMCwibWFudWFscyI6IkF0IFRhcmdldCIsIm1hbnVhbHNfb3Zlcl9mcyI6dHJ1ZSwibW9kZWxfYnJlYWtlcnMiOnRydWUsIm1vZGVsX2JyZWFrZXJzX2Fpcl9sZWdzIjoiU3RhdGljIiwibW9kZWxfYnJlYWtlcnNfYnJlYWtlZF9sZWdzIjoiRGlzYWJsZWQiLCJtb2RlbF9icmVha2Vyc19sZWdzX3NwZWVkIjo2MC4wLCJtb2RlbF9icmVha2Vyc19sZWdzX3ZhbCI6ODUuMCwibW9kZWxfYnJlYWtlcnNfbW92ZV9sZWFuIjowLjAsIm1vZGVsX2JyZWFrZXJzX3BpdGNoX29uX2xhbmQiOmZhbHNlLCJzYWZlX2RlZmVuc2l2ZV9hYSI6dHJ1ZSwic2FmZV9kZWZlbnNpdmVfaGlkZV9zaG90cyI6dHJ1ZSwic2FmZV9kZWZlbnNpdmVfbGFnX29wdGlvbnMiOiJBbHdheXMgT24iLCJzYWZlX2RlZmVuc2l2ZV9waXRjaCI6IlVwIiwic2FmZV9kZWZlbnNpdmVfcGl0Y2hfc2xpZGVyIjowLjAsInNhZmVfZGVmZW5zaXZlX3lhdyI6IlNwaW4iLCJzYWZlX2Z1bmNzX3NldHRpbmdzIjpbIkhlYWQiLCJLbmlmZSIsIlpldXMiXSwic2FmZV9mdW5jdGlvbnMiOnRydWUsInNhZmVfaGVhZF9zZXR0aW5ncyI6WyJIZWlnaHQiLCJIaWdoIERpc3RhbmNlIl0sInN0YXRpY19vbl9tYW51YWxzIjp0cnVlLCJ0ZWxlcG9ydF9leHAiOmZhbHNlLCJ0ZWxlcG9ydF9pbl9haXJfb25seSI6ZmFsc2V9LCJkcmFnIjp7ImRhbWFnZV9pbmRpY2F0aW9uX3Bvc194Ijo5NDYuMCwiZGFtYWdlX2luZGljYXRpb25fcG9zX3kiOjU5My4wLCJrZXliaW5kc19wb3NfeCI6MjM4LjAsImtleWJpbmRzX3Bvc195Ijo4NjcuMCwic3BlY3RhdG9yc19wb3NfeCI6MS4wLCJzcGVjdGF0b3JzX3Bvc195Ijo1MzAuMCwidmVsb2NpdHlfaW5kaWNhdGlvbl9wb3NfeCI6MzkwLjAsInZlbG9jaXR5X2luZGljYXRpb25fcG9zX3kiOjE0Ni4wfSwiaG9tZSI6W10sImludGVyZmFjZSI6eyJhaW1ib3RfbG9nZ2VyIjp0cnVlLCJhaW1ib3RfbG9nZ2VyX2hpdF9jb2xvciI6IjZDODVCNkZGIiwiYWltYm90X2xvZ2dlcl9taXNzX2NvbG9yIjoiRkY3MjcyRkYiLCJhaW1ib3RfbG9nZ2VyX291dHB1dCI6IkNTOkdPIEV2ZW50cyIsImFpbWJvdF9sb2dnZXJfc2V0dGluZ3MiOlsiQ29uc29sZSJdLCJjaGF0X3NwYW1tZXIiOmZhbHNlLCJjbGFudGFnX3NwYW1tZXIiOmZhbHNlLCJjb25zb2xlX2NvbG9yIjoiNTk1OTU5QkYiLCJjb25zb2xlX3N3aXRjaCI6dHJ1ZSwiZGFtYWdlX2luZGljYXRpb25fYWNjZW50X2NvbG9yIjoiRkZGRkZGRkYiLCJkZXNpZ25fYWNjZW50X2NvbG9yIjoiQ0ZEQkZGNTUiLCJkZXNpZ25fYnJlYXRoX2NvbG9yIjoiRkZGRkZGRkYiLCJmYXN0X2xhZGRlciI6dHJ1ZSwiZ3JlbmFkZV9yYWRpdXMiOnRydWUsImdyZW5hZGVfcmFkaXVzX21vbG90b3YiOiJGNTVBNUFGRiIsImdyZW5hZGVfcmFkaXVzX3Ntb2tlIjoiODI4MkZGRkYiLCJncmVuYWRlX3JhZGl1c190eXBlIjpbIlNtb2tlIl0sImhpdGNoYW5jZV9tYW5pcHVsYXRpb24iOnRydWUsImhpdGNoYW5jZV9tYW5pcHVsYXRpb25faW5fYWlyIjo1MC4wLCJoaXRjaGFuY2VfbWFuaXB1bGF0aW9uX25vc2NvcGUiOjQwLjAsImhpdGNoYW5jZV9tYW5pcHVsYXRpb25zIjoiTm9zY29wZSIsImhpdG1hcmtlcl9oaXQiOiJGRjAwMDBGRiIsImhpdG1hcmtlcl9sZXRoYWwiOiIwMDAwMDBGRiIsImhpdG1hcmtlcl9zY3JlZW4iOmZhbHNlLCJoaXRtYXJrZXJfc2V0dGluZ3MiOlsiUGxheWVycyJdLCJpbmFpcl9hbGxvd2VkX3dlYXBvbnMiOltdLCJraWJpdF9jb2wiOiJEREZGQTVGRiIsImtpYml0X2xpZmUiOjUwLjAsImtpYml0X3NpemUiOjYuMCwibWFudWFsX2luZGljYXRpb24iOnRydWUsIm1hbnVhbF9pbmRpY2F0aW9uX2FjY2VudF9jb2xvciI6IjcxOEFCQkZGIiwibWFudWFsX2luZGljYXRpb25fYWRkaW5nIjozNS4wLCJtYW51YWxfaW5kaWNhdGlvbl9nZXR6ZXVzX2FjY2VudF9jb2xvciI6IkZGRkZGRkZGIiwibWFudWFsX2luZGljYXRpb25fZ2V0emV1c19hZGRpbmciOjQ0LjAsIm1hbnVhbF9pbmRpY2F0aW9uX2dldHpldXNfc2Vjb25kX2NvbG9yIjoiRkY5Nzk3MDAiLCJtYW51YWxfaW5kaWNhdGlvbl9zY29wZSI6IkxvdyBPcGFjaXR5IiwibWFudWFsX2luZGljYXRpb25fdGVhbXNrZWV0X2FjY2VudF9jb2xvciI6IkFGRkYwMEZGIiwibWFudWFsX2luZGljYXRpb25fdGVhbXNrZWV0X2FkZGluZyI6NDIuMCwibWFudWFsX2luZGljYXRpb25fdGVhbXNrZWV0X2Rlc3luY19jb2xvciI6IjAwQzhGRkZGIiwibWFudWFsX2luZGljYXRpb25fdHlwZSI6IkludmljdHVzIiwibW9sb3Rvdl93aXJlZnJhbWUiOmZhbHNlLCJtb2xvdG92X3dpcmVmcmFtZV8iOmZhbHNlLCJtb2xvdG92X3dpcmVmcmFtZV9pZ25vcmVfeiI6ZmFsc2UsIm11dGVfZW5lbXkiOmZhbHNlLCJtdXRlX2V2ZXJ5b25lIjp0cnVlLCJtdXRlX2V2ZXJ5b25lX3NldHRpbmdzIjoiVW5tdXRlIiwibm9zY29wZV9hbGxvd2VkX3dlYXBvbnMiOlsiQXV0b1NuaXBlcnMiXSwic2NvcGVfb3ZlcmxheSI6ZmFsc2UsInNjb3BlX292ZXJsYXlfYWNjZW50X2NvbG9yIjoiRkZGRkZGOTciLCJzY29wZV9vdmVybGF5X2FkZGl0aW9uYWwiOltdLCJzY29wZV9vdmVybGF5X2dhcCI6NS4wLCJzY29wZV9vdmVybGF5X3NlY29uZF9jb2xvciI6IjAwMDAwMDAwIiwic2NvcGVfb3ZlcmxheV9zZXR0aW5ncyI6W10sInNjb3BlX292ZXJsYXlfc2l6ZSI6MTAwLjAsInNjb3BlX292ZXJsYXlfc3BlZWQiOjEyLjAsInNjb3BlX292ZXJsYXlfdGhpY2tuZXNzIjoxLjAsInNjcmVlbl9pbmRpY2F0aW9uIjp0cnVlLCJzY3JlZW5faW5kaWNhdGlvbl9hY2NlbnRfY29sb3IiOiJBRUM5RkZGRiIsInNjcmVlbl9pbmRpY2F0aW9uX2JyZWF0aF9jb2xvciI6IkFFQzlGRkZGIiwic2NyZWVuX2luZGljYXRpb25fZ2xvdyI6dHJ1ZSwic2NyZWVuX2luZGljYXRpb25fc2V0dGluZ3MiOlsiQ3Jvc3NoYWlyIl0sInNoYXJlZF9sb2dvIjpmYWxzZSwic2hvcnRfYWltYm90X2xvZ2dlcl9zZXR0aW5ncyI6WyJIaXRjaGFuY2UiLCJCYWNrdHJhY2siXSwic2hvcnRfbG9ncyI6dHJ1ZSwic2tlZXRfaW5kaWNhdGlvbiI6dHJ1ZSwic2tlZXRfaW5kaWNhdGlvbl9hZGRpdGlvbmFsIjpbMS4wLDIuMCwzLjAsNy4wLDkuMCwxMC4wLDExLjAsMTIuMCwxMy4wLDE0LjAsMTUuMF0sInNrZWV0X2luZGljYXRpb25fc3BlY3RhdG9ycyI6ZmFsc2UsInNvbHVzX3NldHRpbmdzIjpbXSwic29sdXNfd2luZG93cyI6dHJ1ZSwidGFza2Jhcl9ub3RpZnkiOnRydWV9fQ__"
    ui_handler.configs.load(data)
    common.add_notify("asylum", "Default config succesfully loaded!")
end)

math.difference = function (num1, num2)
    return math.abs(num1 - num2)
end

math.static_lerp = function(start, end_pos, time)
    return start + (end_pos - start) * time
end

math.static_color_lerp = function(start, end_pos, time)
    return start:lerp(end_pos, time)
end

math.color_lerp = function(start, end_pos, time)
    local frametime = globals.frametime * 100
    time = time * math.min(frametime, math.max_lerp_low_fps)
    return start:lerp(end_pos, time)
end

math.vector_lerp = function(start, end_pos, time)
    local frametime = globals.frametime * 100
    time = time * math.min(frametime, math.max_lerp_low_fps)
    return start:lerp(end_pos, time)
end

math.max_lerp_low_fps = (1 / 45) * 100
math.lerp = function(start, end_pos, time)
    if start == end_pos then
        return end_pos
    end

    local frametime = globals.frametime * 170
    time = time * frametime

    local val = start + (end_pos - start) * time

    if(math.abs(val - end_pos) < 0.01) then
        return end_pos
    end

    return val
end

math.normalize_yaw = math.normalize_yaw

animations.base_speed = 0.095
animations._list = {}
animations.new = function(name, new_value, speed, init)
    speed = speed or animations.base_speed
    local is_color = type(new_value) == "userdata"
    local is_vector = type(new_value) == "vector"

    if animations._list[name] == nil then
        animations._list[name] = (init and init) or (is_color and colors.white or 0)
    end

    local interp_func

    if is_vector then
        interp_func = math.vector_lerp
    elseif is_color then
        interp_func = math.color_lerp
    else
        interp_func = math.lerp
    end

    animations._list[name] = interp_func(animations._list[name], new_value, speed)
    
    return animations._list[name]
end

ui_handler.tab = {
    home = {
        asylum = {
            "Home",
            ">.<"
        },

        information = {
            "Home",
            "Information",
            2
        },

        settings = {
            "Home",
            "Configs",
            2
        },

        recommendations = {
            "Home",
            "Recommendations",
            2
        }
    },

    interface = {
        interface = {
            "Misc",
            "Visuals"
        },

        widgets = {
            "Misc",
            "Widgets"
        },

        additional = {
            "Misc",
            "Other"
        },

        miscellaneous = {
            "Misc",
            "Miscellaneous"
        }
    },

    antiaim = {
        general = {
            "Anti Aim",
            "Settings"
        },

        builder = {
            "Anti Aim",
            "Builder"
        },

        presets = {
            "Anti Aim",
            "Preset Manager"
        }
    }
}

--@note: home

--menu.texture(ui_handler.tab.home.asylum, render.load_image_from_file(images.menu.path, images.menu.size), images.menu.size)("home", "image", false)

menu.label(ui_handler.tab.home.information, 

    defines.colored_text({"User: "}, {defines.username, colors.link_active}) .. "\n" ..

    defines.colored_text({"Version: "}, {"2.0.0", colors.link_active}) .. "\n" ..

    defines.colored_text({"Build: "}, {"stable", colors.link_active}) .. "\n" 

)("home", "information_label", false)

menu.button(ui_handler.tab.home.settings, defines.colored_text({"  "}, {"icon_file-export", colors.link_active}, {" Export settings "}), function() ui_handler.configs.export() end, true)("home", "settings_export", false)

menu.button(ui_handler.tab.home.settings, defines.colored_text({"  "}, {"icon_file-import", colors.link_active}, {" Import settings "}), function() ui_handler.configs.import() end, true)("home", "settings_import", false)

menu.button(ui_handler.tab.home.settings, defines.colored_text({"            "}, {"icon_user-gear", colors.link_active}, {" Load recommended settings           "}), ui_handler.configs.default, true)("home", "settings_default", false)

menu.button(ui_handler.tab.home.recommendations, defines.colored_text({"icon_discord", colors.link_active}, {" Discord Server"}), function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/VzDGjBYAy6")
end, true)("home", "settings_discord_server", false)

menu.button(ui_handler.tab.home.recommendations, defines.colored_text({"icon_youtube", colors.link_active}, {" YouTube Channel "}), function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@fifty1337")
end, true)("home", "settings_youtube_channel", false)
--@note: interface

--@note: anti-aim
menu.switch(ui_handler.tab.antiaim.general, "Enable Anti Aim")("aa", "enable", true)

menu.switch(ui_handler.tab.antiaim.general, "Custom Manuals")("aa", "static_on_manuals", true, function()
    return ui_handler.elements["aa"]["enable"]
end)(function(group)
    custom_manuals.inverter = menu.switch(group, neverlose_refs.inverter:name() .. '\nmanual_inverter')("aa", "manual_inverter", true, function()
        return ui_handler.elements["aa"]["static_on_manuals"]
    end)
    custom_manuals.left_limit = menu.slider(group, neverlose_refs.left_limit:name() .. '\nmanual_left_limit', 0, 60, 60)("aa", "manual_left_limit", true, function()
        return ui_handler.elements["aa"]["static_on_manuals"]
    end)
    custom_manuals.right_limit = menu.slider(group, neverlose_refs.right_limit:name() .. '\nmanual_right_limit', 0, 60, 60)("aa", "manual_right_limit", true, function()
        return ui_handler.elements["aa"]["static_on_manuals"]
    end)
    custom_manuals.body_yaw_options = menu.selectable(group, neverlose_refs.body_yaw_options:name() .. '\nmanual_body_options', neverlose_refs.body_yaw_options:list())("aa", "manual_body_yaw_options", true, function()
        return ui_handler.elements["aa"]["static_on_manuals"]
    end)
    custom_manuals.body_yaw_freestanding = menu.combo(group, neverlose_refs.body_yaw_freestanding:name() .. '\nmanual_body_freestand', neverlose_refs.body_yaw_freestanding:list())("aa", "manual_body_yaw_freestanding", true, function()
        return ui_handler.elements["aa"]["static_on_manuals"]
    end)
    custom_manuals.defensive_aa = menu.switch(group, 'Defensive AA')("aa", "manual_defensive_aa", true, function()
        return ui_handler.elements["aa"]["static_on_manuals"]
    end)
    custom_manuals.defensive_pitch = menu.combo(group, "Pitch\nmanual_defensive_pitch", {"Disabled", "Up", "Zero", "Random", "Custom"})("aa", "manual_defensive_pitch", true, function()
        return ui_handler.elements["aa"]["static_on_manuals"] and ui_handler.elements["aa"]["manual_defensive_aa"]
    end)
    custom_manuals.defensive_yaw = menu.combo(group, "Yaw\nmanual_defensive_yaw", {"Disabled", "Sideways", "Opposite", "Random", "Spin", "3-Way", "5-Way", "Neverlose", "Custom"})("aa", "manual_defensive_yaw", true, function()
        return ui_handler.elements["aa"]["static_on_manuals"] and ui_handler.elements["aa"]["manual_defensive_aa"]
    end)
    custom_manuals.pitch_slider = menu.slider(group, "Custom Pitch\nmanual_defensive_custom_pitch", -89, 89, 0)("aa", "manual_defensive_pitch_slider", true, function()
        return ui_handler.elements["aa"]["static_on_manuals"] and ui_handler.elements["aa"]["manual_defensive_aa"] and ui_handler.elements["aa"]["manual_defensive_pitch"] == "Custom"
    end)
    custom_manuals.hide_shots = menu.switch(group, 'On Hide Shots\nmanual_defensive_hide_shots')("aa", "manual_defensive_hide_shots", true, function()
        return ui_handler.elements["aa"]["static_on_manuals"] and ui_handler.elements["aa"]["manual_defensive_aa"]
    end)
    custom_manuals.lag_options = menu.combo(group, "Lag Options\nmanual_defensive_lag_options", {"On Peek", "Always On"})("aa", "manual_defensive_lag_options", true, function()
        return ui_handler.elements["aa"]["static_on_manuals"]
    end)
end)

gradient.animate_text = function(time, string, r, g, b, a, r1, g1, b1, a1)
    local t_out, t_out_iter = {}, 1
    local l = string:len() - 1

    local r_add = (r1 - r)
    local g_add = (g1 - g)
    local b_add = (b1 - b)
    local a_add = (a1 - a)

    for i = 1, #string do
        local iter = (i - 1)/(#string - 1) + time
        t_out[t_out_iter] = '\a' .. color(r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter ))):to_hex()

        t_out[t_out_iter+1] = string:sub(i, i)
        t_out_iter = t_out_iter + 2
    end

    return table.concat(t_out)
end

screen_indication.font = render.load_font("Verdana", 11, "bo")
screen_indication.handle = function()
    local anim = {}

    local indication_enable =         ui_handler.elements["interface"]["screen_indication"] and ui_handler.refs["interface"]["screen_indication_settings"].ref:get("Crosshair")
    local indication_accent_color =   ui_handler.elements["interface"]["screen_indication_accent_color"]
    local indication_breath_color =   ui_handler.elements["interface"]["screen_indication_breath_color"]

    if not (indication_enable or (ui_handler.elements["interface"]["solus_windows"] and (ui_handler.refs["interface"]["solus_settings"].ref:get("Branded Watermark") or ui_handler.refs["interface"]["solus_settings"].ref:get("Watermark")))) then
        render.text(aimbot_logger.font, vector(defines.screen_size.x*0.5, defines.screen_size.y-15), color(), 'c', 'asylum')
	end
    anim.main = animations.new("screen_indication_main", indication_enable and 255 or 0)

    if anim.main < 1 then
        return
    end

    local player = entity.get_local_player()

    if player == nil or not player:is_alive() then
        return
    end

    local scope_based = (not (ui_handler.elements["interface"]["scope_overlay_settings"]["Rotated"] and ui_handler.elements["interface"]["scope_overlay"]) and player.m_bIsScoped)
    
    local add_y = 25

    local binds = {
        {"dt", neverlose_refs.doubletap:get()},
        {"hide", neverlose_refs.hideshots:get()},
        {"safe", neverlose_refs.prefer_safety:get() == "Force"},
        {"body", neverlose_refs.prefer_body:get() == "Force"},
        {"dmg", defines.get_bind("Min. Damage")[1]},
        {"fs", ui_handler.elements["aa"]["manuals"] == "Freestanding"}
    }

    local text_size = render.measure_text(aimbot_logger.font, nil, "asylum").x

    anim.lua_name = {}
    anim.lua_name.move = {}
    anim.lua_name.alpha = animations.new("lua_name_alpha", indication_enable and 255 or 0) -- 
    anim.lua_name.move = 0 + string.format('%.0f', animations.new("lua_name_move", indication_enable and not scope_based and -text_size*0.5 or 15))
    anim.lua_name.text = gradient.animate_text(globals.curtime*2, 'asylum', indication_accent_color.r, indication_accent_color.g, indication_accent_color.b, anim.lua_name.alpha, indication_breath_color.r, indication_breath_color.g, indication_breath_color.b, anim.lua_name.alpha) -- gradient.text_animate("asylum", -2, {indication_accent_color, indication_breath_color})
    if anim.lua_name.alpha > 1 then
        if ui_handler.elements["interface"]["screen_indication_glow"] then
            render.shadow(defines.screen_size * 0.5 + vector(anim.lua_name.move, add_y + 7), defines.screen_size * 0.5 + vector(anim.lua_name.move, add_y + 7) + vector(text_size, 0), indication_accent_color:override('a', anim.lua_name.alpha), 20, 0)
        end
        render.text(
            aimbot_logger.font,
            defines.screen_size * 0.5 + vector(anim.lua_name.move, add_y),
            indication_accent_color:override("a", anim.lua_name.alpha),
            nil,
            anim.lua_name.text
        )

        add_y = add_y + string.format('%.0f', anim.lua_name.alpha / 255 * 12)

    end
    
    local conds = {
        "shared",
        "standing",
        "running",
        "slowwalking",
        "ducking",
        "moving+duck",
        "air",
        "air+duck",
        "freestand",
        "fakelag",
        "on-use",
        [777] = "safe"
    }

    anim.state = {}

    anim.state.text = conds[(conditional_antiaims.safe_active or conditional_antiaims.safe_knife or conditional_antiaims.safe_zeus) and 777 or conditional_antiaims.get_active_idx(conditional_antiaims.player_state)]
    local text_size = render.measure_text(1, nil, anim.state.text).x
    anim.state.alpha = animations.new("state_alpha", indication_enable and 255 or 0)
    anim.state.scoped_check = animations.new("scoped_check", indication_enable and not scope_based and 1 or 0) ~= 1
    anim.state.move = anim.state.scoped_check and 0 + string.format("%.0f", animations.new("binds_move_state", indication_enable and not scope_based and -render.measure_text(1, nil, anim.state.text).x*0.5 or 15)) or -render.measure_text(1, nil, anim.state.text).x*0.5
    if anim.state.alpha > 1 then
        render.text(
            1,
            defines.screen_size * 0.5 + vector(anim.state.move, add_y),
            color(255, 255, 255, anim.state.alpha),
            nil,
            anim.state.text
        )

        add_y = add_y + string.format('%.0f', anim.state.alpha / 255 * 12)
    end

    local text = ""

    anim.binds = {}

    for k, v in pairs(binds) do

        anim.binds[v[1]] = {}
        anim.binds[v[1]].alpha = animations.new("binds_alpha_"..v[1], indication_enable and v[2] and 255 or 0)
        anim.binds[v[1]].move = 0 + string.format("%.0f", animations.new('binds_move_'..v[1], indication_enable and not scope_based and -render.measure_text(1, nil, v[1]).x*0.5 or 15))

        if anim.binds[v[1]].alpha > 1 then -- and not neverlose_refs.doubletap:get()
            render.text(1, defines.screen_size * 0.5 + vector(anim.binds[v[1]].move, add_y), ((v[1] ~= "hide" and color() or (not neverlose_refs.doubletap:get() and color() or color(255, 100, 100, 255))):override("a", anim.binds[v[1]].alpha)) or ((v[1] ~= "dt" and color() or (rage.exploit:get() == 1 and color() or color(255, 100, 100, 255))):override("a", anim.binds[v[1]].alpha)), nil, v[1])

            add_y = add_y + string.format('%.0f', anim.binds[v[1]].alpha / 255 * 12)
        end
    end
end

skeet_indication.font = render.load_font("Calibri Bold", 24, "ad")
skeet_indication.shots = 0
skeet_indication.percentage = 0
skeet_indication.sm1_is_dormant = false
skeet_indication.bomb_image = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(30, 30))

function draw_500_(gap, text, icon, time, r, g, b, a)
    if a == nil then a = 255 end
    local x, y = render.screen_size().x, render.screen_size().y
    local measure_text = render.measure_text(skeet_indication.font, nil, text) 
    if icon == nil and time == nil then
        render.gradient(vector(0, (y - 351) - gap), vector(29 + measure_text.x/2, (y - 317) - gap), color(0,0,0,0), color(0,0,0,60), color(0,0,0,0), color(0,0,0,60), 0)
        render.gradient(vector(58 + measure_text.x, (y - 351) - gap), vector(29 + measure_text.x/2, (y - 317) - gap), color(0,0,0,0), color(0,0,0,60), color(0,0,0,0), color(0,0,0,60), 0)
        render.text(skeet_indication.font, vector(29, (y - 343) - gap), color(r, g, b, a), nil, text)
    elseif icon ~= nil and time ~= nil then
        --render.gradient(vector(x/40, y/1.43 - 4 - gap), vector(x/40 + measure_text.x - 20, y/1.43 + 30 - gap), color(0,0,0,45), color(0,0,0,0), color(0,0,0,45), color(0,0,0,0), 0)
        --render.gradient(vector(x/40 - 40, y/1.43 - 4 - gap), vector(x/40, y/1.43 + 30 - gap), color(0,0,0,0), color(0,0,0,45), color(0,0,0,0), color(0,0,0,45), 0)
        render.gradient(vector(0, (y - 351) - gap), vector(29 + measure_text.x/2, (y - 317) - gap), color(0,0,0,0), color(0,0,0,60), color(0,0,0,0), color(0,0,0,60), 0)
        render.gradient(vector(58 + measure_text.x, (y - 351) - gap), vector(29 + measure_text.x/2, (y - 317) - gap), color(0,0,0,0), color(0,0,0,60), color(0,0,0,0), color(0,0,0,60), 0)
        render.text(skeet_indication.font, vector(67, (y - 343) - gap), color(r, g, b, a), nil, text)
        render.texture(icon, vector(29, (y - 347) - gap), vector(32, 28), color(r, g, b, 255), f, 0)
        render.circle_outline(vector(99, (y - 334) - gap), color(10,10,10,255), 10, 0, 1, 5)
        render.circle_outline(vector(99, (y - 334) - gap), color(255, 255, 255, 200), 9, 0, time, 3)
    elseif icon ~= nil and time == nil then
        --render.gradient(vector(x/40, y/1.43 - 4 - gap), vector(x/40 + measure_text.x - 20, y/1.43 + 30 - gap), color(0,0,0,45), color(0,0,0,0), color(0,0,0,45), color(0,0,0,0), 0)
        --render.gradient(vector(x/40 - 40, y/1.43 - 4 - gap), vector(x/40, y/1.43 + 30 - gap), color(0,0,0,0), color(0,0,0,45), color(0,0,0,0), color(0,0,0,45), 0)
        render.gradient(vector(0, (y - 351) - gap), vector(29 + measure_text.x/2, (y - 317) - gap), color(0,0,0,0), color(0,0,0,60), color(0,0,0,0), color(0,0,0,60), 0)
        render.gradient(vector(58 + measure_text.x, (y - 351) - gap), vector(29 + measure_text.x/2, (y - 317) - gap), color(0,0,0,0), color(0,0,0,60), color(0,0,0,0), color(0,0,0,60), 0)
        render.text(skeet_indication.font, vector(67, (y - 343) - gap), color(r, g, b, a), nil, text)
        render.texture(icon, vector(29, (y - 347) - gap), vector(32, 28), color(r, g, b, 255), f, 0)
    end
end

skeet_indication.real_yaw = 0
skeet_indication.positions = {}
skeet_indication.lc = false
events.createmove:set(function(cmd)
    local plocal = entity.get_local_player()
    local origin = plocal:get_origin()
    local time = 1 / globals.tickinterval

    if cmd.choked_commands == 0 then
        skeet_indication.positions[#skeet_indication.positions + 1] = origin

        if #skeet_indication.positions >= time then
            local record = skeet_indication.positions[time]
            skeet_indication.lc = (origin - record):lengthsqr() > 4096
        end
    end

    if #skeet_indication.positions > time then
        table.remove(skeet_indication.positions, 1)
    end

    skeet_indication.is_jumping = cmd.in_jump

    if cmd.choked_commands > 0 then
        return
    end

    skeet_indication.real_yaw = plocal['m_flPoseParameter'][11] * 120 - 60
end)

skeet_indication.handle = function()
    if not ui_handler.elements["interface"]["skeet_indication"] then
        return
    end

    local skeet_indication_additional = ui_handler.refs["interface"]["skeet_indication_additional"].ref

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local c4 = entity.get_entities("CPlantedC4", true)[1]
    local bombsite = ""
    local timer = 0
    local defused = false
    local damage = 0
    local dmg = 0
    local willKill = false
    if c4 ~= nil then
        timer = (c4.m_flC4Blow - globals.curtime)
        defused = c4.m_bBombDefused
        if timer > 0 and not defused then
            local defusestart = c4.m_hBombDefuser ~= 4294967295
            local defuselength = c4.m_flDefuseLength
            local bomb_defusing = c4.m_hBombDefuser and c4.m_hBombDefuser.m_bIsDefusing or false
            local defusetimer = (defusestart and bomb_defusing) and (c4.m_flDefuseCountDown - globals.curtime) or -1
            if defusetimer > 0 then
                local clr = timer > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)
                
                local barlength = (((defines.screen_size.y - 50) / defuselength) * (defusetimer))
                render.rect(vector(0.0, 0.0), vector(16, defines.screen_size.y), color(25, 25, 25, 160))
                render.rect_outline(vector(0.0, 0.0), vector(16, defines.screen_size.y), color(25, 25, 25, 160))
                
                render.rect(vector(0, defines.screen_size.y - barlength), vector(16, defines.screen_size.y), clr)
            end
            
            bombsite = c4.m_nBombSite == 0 and "A" or "B"
            local health = player.m_iHealth
            local armor = player.m_ArmorValue
            local eLoc = c4.m_vecOrigin
            local lLoc = player.m_vecOrigin
            local distance = eLoc:dist(lLoc)
            local a = 450.7
            local b = 75.68
            local c = 789.2
            local d = (distance - b) / c;

            damage = a * math.exp(-d * d)
            
            if armor > 0 then
                local newDmg = damage * 0.5;

                local armorDmg = (damage - newDmg) * 0.5
                if armorDmg > armor then
                    armor = armor * (1 / .5)
                    newDmg = damage - armorDmg
                end
                damage = newDmg;
            end

            dmg = math.ceil(damage)

            if dmg >= health then
                willKill = true
            else 
                willKill = false
            end
        end
    end
    if c4_info.planting then
        c4_info.fill = 3.125 - (3.125 + c4_info.on_plant_time - globals.curtime)
        if(c4_info.fill > 3.125) then
            c4_info.fill = 3.125
        end
    end

    skeet_indication.sm1_is_dormant = false

    local all_players = entity.get_players(true, true)
    if not all_players then return end
    
    for _, player in ipairs(all_players) do
        if player:is_dormant() then
            skeet_indication.sm1_is_dormant = true
        end
    end
    
    if not ui_handler.elements["interface"]["skeet_indication"] then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    skeet_indication.sm1_is_dormant = false

    local all_players = entity.get_players(true, true)
    if not all_players then return end
    
    for _, player in ipairs(all_players) do
        if player:is_dormant() then
            skeet_indication.sm1_is_dormant = true
        end
    end
    
    local local_player = entity.get_local_player()
    if globals.is_connected == false or local_player == nil or local_player:is_alive() == false then return end
    local player_resource = local_player:get_resource()
    local ping = player_resource['m_iPing']
    local delta = (math.abs(ping % 360)) / (neverlose_refs.fake_latency:get() / 4)
    if delta > 1 then delta = 1 end
    local pr, pg, pb = (132 * delta) + (255 * (1 - delta)), (196 * delta) + (255 * (1 - delta)), (20 * delta) + (255 * (1 - delta))
    local dsy_delta = math.min(60, math.abs(skeet_indication.real_yaw)) / 60
    local fr, fg, fb = (132 * dsy_delta) + (250 * (1 - dsy_delta)), (196 * dsy_delta) + (15 * (1 - dsy_delta)), (20 * dsy_delta) + (15 * (1 - dsy_delta))

    local gs_gap = 0
    local x, y = render.screen_size().x, render.screen_size().y
    if skeet_indication_additional:get("Fake Latency") and neverlose_refs.fake_latency:get() > 0 then
        draw_500_(gs_gap, "PING", nil, nil, pr, pg, pb, 255)
        gs_gap = gs_gap + 42
    end
    if skeet_indication_additional:get("Hide Shots") and (neverlose_refs.hideshots:get() and not neverlose_refs.doubletap:get()) then
        draw_500_(gs_gap, "OSAA", nil, nil, 255, 255, 255, 200)
        gs_gap = gs_gap + 42
    end
    if skeet_indication_additional:get("Double Tap") and (neverlose_refs.doubletap:get() and not neverlose_refs.fake_duck:get()) then
        local DTcharge = rage.exploit:get()
        if DTcharge == 1 then
            draw_500_(gs_gap, "DT", nil, nil, 255, 255, 255, 200)
            gs_gap = gs_gap + 42
        else
            draw_500_(gs_gap, "DT", nil, nil, 255, 0, 50, 255)
            gs_gap = gs_gap + 42
        end 
    end
    
    if skeet_indication_additional:get("Dormant Aimbot") and neverlose_refs.dormant:get() then
        if skeet_indication.sm1_is_dormant then
            draw_500_(gs_gap, "DA", nil, nil, 255, 255, 255, 200)
            gs_gap = gs_gap + 42
        else
            draw_500_(gs_gap, "DA", nil, nil, 255, 0, 50, 255)
            gs_gap = gs_gap + 42
        end
    end

    if skeet_indication_additional:get("Lag Compensation") then
        skeet_indication.r, skeet_indication.g, skeet_indication.b, skeet_indication.a = 240, 15, 15, 240
        
        local lc_air = not (bit.band(local_player.m_fFlags, bit.lshift(1, 0)) ~= 0) or skeet_indication.is_jumping
        if skeet_indication.lc then
            skeet_indication.r, skeet_indication.g, skeet_indication.b = 132, 196, 20
        end

        if lc_air and math.sqrt(local_player.m_vecVelocity.x ^ 2 + local_player.m_vecVelocity.y ^ 2) > 230 then 
            draw_500_(gs_gap, "LC", nil, nil, skeet_indication.r, skeet_indication.g, skeet_indication.b, skeet_indication.a)
            gs_gap = gs_gap + 42
        end
    end

    if skeet_indication_additional:get("Fake Angles") then
        draw_500_(gs_gap, "FAKE", nil, nil, fr, fg, fb, 255)
        gs_gap = gs_gap + 42
    end

    if skeet_indication_additional:get("Safe Points") and neverlose_refs.prefer_safety:get() == "Force" then
        draw_500_(gs_gap, "SAFE", nil, nil, 255, 255, 255, 200)
        gs_gap = gs_gap + 42
    end
    if skeet_indication_additional:get("Body Aim") and neverlose_refs.prefer_body:get() == "Force" then
        draw_500_(gs_gap, "BODY", nil, nil, 255, 255, 255, 200)
        gs_gap = gs_gap + 42
    end
    if skeet_indication_additional:get("Fake Duck") and neverlose_refs.fake_duck:get() then
        draw_500_(gs_gap, "DUCK", nil, nil, 255, 255, 255, 200)
        gs_gap = gs_gap + 42
    end
    
    if skeet_indication_additional:get("Damage Override") and defines.get_bind("Min. Damage")[1] then
        draw_500_(gs_gap, "MD", nil, nil, 255, 255, 255, 200)
        gs_gap = gs_gap + 42
    end
        
    if skeet_indication_additional:get("Freestanding") and neverlose_refs.freestanding:get() then
        draw_500_(gs_gap, "FS", nil, nil, 255, 255, 255, 200)
        gs_gap = gs_gap + 42
    end
        
    if skeet_indication_additional:get("Hit/Miss") then
        draw_500_(gs_gap, tostring(skeet_indication.percentage) .."%", nil, nil, 255, 255, 255, 200)
        gs_gap = gs_gap + 42
    end
    
    if skeet_indication_additional:get("Bomb Info") and timer > 0 and not defused then
        draw_500_(gs_gap, bombsite.." - " .. string.format("%.1f", timer) .. "s              ", skeet_indication.bomb_image, nil, 255, 255, 255, 200)
        gs_gap = gs_gap + 42
    end

    if skeet_indication_additional:get("Bomb Info") and c4_info.planting then
        draw_500_(gs_gap, c4_info.planting_site .."              ", skeet_indication.bomb_image, c4_info.fill / 3.125, 252, 243, 105, 255)
        gs_gap = gs_gap + 42
    end

    if skeet_indication_additional:get("Bomb Info") and player:is_alive() and willKill then
        draw_500_(gs_gap, 'FATAL', nil, nil, 255, 0, 50, 255)
        gs_gap = gs_gap + 42
    end

    if skeet_indication_additional:get("Bomb Info") and player:is_alive() and not willKill and damage > 0.5 then
        draw_500_(gs_gap, "-" .. dmg .. " HP", nil, nil, 252, 243, 105, 255)
        gs_gap = gs_gap + 42
    end
        
    if skeet_indication_additional:get("Hitchance Override") and defines.get_bind("Hit Chance")[1] then
        draw_500_(gs_gap, "HITCHANCE OVR", nil, nil, 255, 255, 255, 200)
        gs_gap = gs_gap + 42
    end
        
    if skeet_indication_additional:get("Hitbox Override") and defines.get_bind("Hitboxes")[1] then
        draw_500_(gs_gap, "HITBOX OVR", nil, nil, 255, 255, 255, 200)
        gs_gap = gs_gap + 42
    end

end


c4_info = {}

c4_info.reset = function()
    c4_info.planting = false
	c4_info.fill = 0
	c4_info.on_plant_time = 0
	c4_info.planting_site = ""
end

c4_info.bomb_beginplant = function(e)
    local player_resource = entity.get_player_resource()

    if player_resource == nil then
        return
    end

    c4_info.on_plant_time = globals.curtime
    c4_info.planting = true

    local m_bombsiteCenterA = player_resource.m_bombsiteCenterA
    local m_bombsiteCenterB = player_resource.m_bombsiteCenterB
    
    local userid = entity.get(e.userid, true)
    local userid_origin = userid:get_origin()
    local dist_to_a = userid_origin:dist(m_bombsiteCenterA)
    local dist_to_b = userid_origin:dist(m_bombsiteCenterB)
    
    c4_info.planting_site = dist_to_a < dist_to_b and "A" or "B"
end

menu.switch(ui_handler.tab.interface.interface, "Windows")("interface", "solus_windows")(function(group)

    menu.selectable(group, "Settings", {"Keybinds", "Spectators", "Watermark", "Branded Watermark"})("interface", "solus_settings", true, function()
        return ui_handler.elements["interface"]["solus_windows"]
    end)

    menu.input(group, "Username", defines.username)("interface", "design_username", false, function()
        return ui_handler.elements["interface"]["solus_windows"] and (ui_handler.refs["interface"]["solus_settings"].ref:get("Watermark") or ui_handler.refs["interface"]["solus_settings"].ref:get("Branded Watermark"))
    end)
    
    menu.color_picker(group, "Accent Color", color(142, 165, 229, 85))("interface", "design_accent_color", true, function()
        return ui_handler.elements["interface"]["solus_windows"]
    end)
    
    menu.color_picker(group, "Breath Color", color(25, 25, 25, 255))("interface", "design_breath_color", true, function()
        return ui_handler.elements["interface"]["solus_windows"]
    end)

end)

menu.switch(ui_handler.tab.interface.interface, defines.colored_text({"$400", "9FCA2BFF"}, {" Indicators"}))("interface", "skeet_indication")(function(group)

    menu.switch(group, "Spectators")("interface", "skeet_indication_spectators", true, function()
        return ui_handler.elements["interface"]["skeet_indication"]
    end)

    menu.listable(group, "Additional", {"Hit/Miss", "Dormant Aimbot", "Damage Override", "Hitchance Override", "Lag Compensation", "Hitbox Override", "Fake Latency", "Fake Angles", "Fake Duck", "Body Aim", "Safe Points", "Freestanding", "Bomb Info", "Hide Shots", "Double Tap"})("interface", "skeet_indication_additional", true, function()
        return ui_handler.elements["interface"]["skeet_indication"]
    end)

end)

menu.switch(ui_handler.tab.interface.interface, "Screen Indicators")("interface", "screen_indication")(function(group)

    menu.selectable(group, "Settings", {"Crosshair", "Damage", "Velocity"})("interface", "screen_indication_settings", true, function()
        return ui_handler.elements["interface"]["screen_indication"]
    end)

    menu.switch(group, "Glow")("interface", "screen_indication_glow", true, function()
        return ui_handler.elements["interface"]["screen_indication"] and ui_handler.refs["interface"]["screen_indication_settings"].ref:get("Crosshair")
    end)

    menu.color_picker(group, "Accent Color", colors.white)("interface", "screen_indication_accent_color", true, function()
        return ui_handler.elements["interface"]["screen_indication"] and ui_handler.refs["interface"]["screen_indication_settings"].ref:get("Crosshair")
    end)

    menu.color_picker(group, "Breath Color", colors.white)("interface", "screen_indication_breath_color", true, function()
        return ui_handler.elements["interface"]["screen_indication"] and ui_handler.refs["interface"]["screen_indication_settings"].ref:get("Crosshair")
    end)

    menu.color_picker(group, "Damage Color", colors.white)("interface", "damage_indication_accent_color", true, function()
        return ui_handler.elements["interface"]["screen_indication"] and ui_handler.refs["interface"]["screen_indication_settings"].ref:get("Damage")
    end)

end)

--[[menu.switch(ui_handler.tab.interface.interface, "LC Debug")("interface", "lc_debug")(function(group)

    menu.color_picker(group, "Box Color", colors.white)("interface", "lc_debug_color", true, function()
        return ui_handler.elements["interface"]["lc_debug"]
    end)

end)


]]--

manual_indication.font = render.load_font(files.default_path .. "\\arrows.ttf", vector(19, 24), 'a')
manual_indication.font_getzeus = render.load_font('Verdana', vector(19, 22), 'bad')
manual_indication.handle = function()
    local player = entity.get_local_player()

    if player == nil or not player:is_alive() then
        return
    end

    local m_bIsScoped = player.m_bIsScoped
    local antiaim_manuals = ui_handler.elements["aa"]["manuals"]
    local manual_indication_enable = ui_handler.elements["interface"]["manual_indication"]
    local manual_indication_type = ui_handler.elements["interface"]["manual_indication_type"]
    local manual_indication_scope = ui_handler.elements["interface"]["manual_indication_scope"]
    local manual_indication_anim = animations.new("manual_indication_anim", manual_indication_enable and 1 or 0)
    local pos = defines.screen_size/2

    local anim = {}

    if manual_indication_type == "Default" then

        local manual_indication_adding = ui_handler.elements["interface"]["manual_indication_adding"]
        local manual_indication_accent_color = ui_handler.elements["interface"]["manual_indication_accent_color"]

        anim.left = animations.new("manual_indication_left", (manual_indication_enable) and (antiaim_manuals == "Left" and 255 or 100) or 0)
        anim.right = animations.new("manual_indication_right", (manual_indication_enable) and (antiaim_manuals == "Right" and 255 or 100) or 0)

        if anim.left < 1 or anim.right < 1 then
            return
        end

        anim.default = animations.new("anim_default", (manual_indication_scope == "Low Opacity" and m_bIsScoped) and 0.5 or 1)
        local ts_defanim = 0 + string.format('%.0f', animations.new("ts_defanim", (manual_indication_scope == 'Move With Lines' and m_bIsScoped) and (ui_handler.elements["interface"]["scope_overlay_size"] + ui_handler.elements["interface"]["scope_overlay_gap"]) or manual_indication_adding))

        render.poly(
            (antiaim_manuals == "Left" and manual_indication_accent_color or colors.black):override("a", anim.left*anim.default),
            pos - vector(ts_defanim, 0) - vector(0, 5),
            pos - vector(ts_defanim, 0) - vector(9, 0),
            pos - vector(ts_defanim, 0) + vector(0, 5)
        )

        render.poly(
            (antiaim_manuals == "Right" and manual_indication_accent_color or colors.black):override("a", anim.right*anim.default), 
            pos + vector(ts_defanim, 0) - vector(0, 5),
            pos + vector(ts_defanim, 0) + vector(9, 0),
            pos + vector(ts_defanim, 0) + vector(0, 5)
        )
    end

    if manual_indication_type == "Teamskeet" then

        anim.teamskeet = animations.new("anim_teamskeet", (manual_indication_scope == "Low Opacity" and m_bIsScoped) and 0.5 or 1)
        local default = { ui_handler.elements["interface"]["manual_indication_teamskeet_accent_color"].r, ui_handler.elements["interface"]["manual_indication_teamskeet_accent_color"].g, ui_handler.elements["interface"]["manual_indication_teamskeet_accent_color"].b, ui_handler.elements["interface"]["manual_indication_teamskeet_accent_color"].a }
        local default2 = { ui_handler.elements["interface"]["manual_indication_teamskeet_desync_color"].r, ui_handler.elements["interface"]["manual_indication_teamskeet_desync_color"].g, ui_handler.elements["interface"]["manual_indication_teamskeet_desync_color"].b, ui_handler.elements["interface"]["manual_indication_teamskeet_desync_color"].a }

        local ts_arrowsanim = ui_handler.elements["interface"]["manual_indication_teamskeet_adding"]
        local ts_colleft = (antiaim_manuals == "Left") and color(default[1], default[2], default[3], 255*manual_indication_anim*anim.teamskeet) or color(35, 35, 35, 150*manual_indication_anim*anim.teamskeet)
        local ts_colright = (antiaim_manuals == "Right") and color(default[1], default[2], default[3], 255*manual_indication_anim*anim.teamskeet) or color(35, 35, 35, 150*manual_indication_anim*anim.teamskeet)

        local ts_animated = 0 + string.format('%.0f', animations.new("ts_animated", (manual_indication_scope == 'Move With Lines' and m_bIsScoped) and (ui_handler.elements["interface"]["scope_overlay_size"] + ui_handler.elements["interface"]["scope_overlay_gap"]) or ts_arrowsanim))
        render.text(manual_indication.font, vector(pos.x - (ts_animated+15), pos.y - 9), ts_colleft, '', 'Q')
        render.text(manual_indication.font, vector(pos.x + ts_animated, pos.y - 9), ts_colright, '', 'R')

        local ts_lineanim = 0 + string.format('%.0f', animations.new("ts_lineanim", (manual_indication_scope == 'Move With Lines' and m_bIsScoped) and (ui_handler.elements["interface"]["scope_overlay_size"] + ui_handler.elements["interface"]["scope_overlay_gap"]) or ts_arrowsanim))
        local ts_sideleft = (not anti_aim.get_inverter_state()) and color(default2[1], default2[2], default2[3], default2[4]*manual_indication_anim*anim.teamskeet) or color(35, 35, 35, 150*manual_indication_anim*anim.teamskeet)
        local ts_sideright = (anti_aim.get_inverter_state()) and color(default2[1], default2[2], default2[3], default2[4]*manual_indication_anim*anim.teamskeet) or color(35, 35, 35, 150*manual_indication_anim*anim.teamskeet)

        render.rect(vector(pos.x-(ts_lineanim-1), pos.y-8), vector(pos.x-(ts_lineanim-3), pos.y+10), ts_sideleft, 0, true)
        render.rect(vector(pos.x+(ts_lineanim-1), pos.y-8), vector(pos.x+(ts_lineanim-3), pos.y+10), ts_sideright, 0, true)

    end

    if manual_indication_type == "Invictus" then
        local selected = ui_handler.elements["interface"]["manual_indication_getzeus_accent_color"]
        local unselected = ui_handler.elements["interface"]["manual_indication_getzeus_second_color"]
        
        anim.invictus = animations.new("anim_invictus", (manual_indication_scope == "Low Opacity" and m_bIsScoped) and 0.5 or 1)
        if antiaim_manuals == "Right" or antiaim_manuals == "Left" then
            local gt_arrowsanim = 0 + string.format('%.0f', animations.new("gt_arrowsanim", (manual_indication_scope == 'Move With Lines' and m_bIsScoped) and (ui_handler.elements["interface"]["scope_overlay_size"] + ui_handler.elements["interface"]["scope_overlay_gap"]) or ui_handler.elements["interface"]["manual_indication_getzeus_adding"]))
            local gt_colright = antiaim_manuals == "Right" and color(selected.r, selected.g, selected.b, selected.a*manual_indication_anim*anim.invictus) or color(unselected.r, unselected.g, unselected.b, unselected.a*manual_indication_anim*anim.invictus)
            local gt_colleft = antiaim_manuals == "Left" and color(selected.r, selected.g, selected.b, selected.a*manual_indication_anim*anim.invictus) or color(unselected.r, unselected.g, unselected.b, unselected.a*manual_indication_anim*anim.invictus)

            render.text(manual_indication.font_getzeus, vector(pos.x + gt_arrowsanim, pos.y - 13), gt_colright, '', '>')
            render.text(manual_indication.font_getzeus, vector(pos.x - (gt_arrowsanim+13), pos.y - 13), gt_colleft, '', '<')
        end
    end
end

menu.switch(ui_handler.tab.interface.interface, "Grenade Radius")("interface", "grenade_radius")(function(group)

    menu.selectable(group, "Additional", {"Molotov", "Smoke"})("interface", "grenade_radius_type", true, function()
        return ui_handler.elements["interface"]["grenade_radius"]
    end)

    menu.color_picker(group, "Molotov Color", color(245, 90, 90, 255))("interface", "grenade_radius_molotov", true, function()
        return ui_handler.elements["interface"]["grenade_radius"]
    end)

    menu.color_picker(group, "Smoke Color", color(130, 130, 255, 255))("interface", "grenade_radius_smoke", true, function()
        return ui_handler.elements["interface"]["grenade_radius"]
    end)

end)

menu.switch(ui_handler.tab.interface.interface, "Manual Arrows")("interface", "manual_indication")(function(group)
    menu.combo(group, "Settings", {"Default", "Invictus", "Teamskeet"})("interface", "manual_indication_type", true, function()
        return ui_handler.elements["interface"]["manual_indication"]
    end)
    
    menu.slider(group, "Adding\nDEF", 0, 100, 35, 1, "px")("interface", "manual_indication_adding", true, function()
        return ui_handler.elements["interface"]["manual_indication"] and ui_handler.elements["interface"]["manual_indication_type"] == "Default"
    end)
    
    menu.slider(group, "Adding\nTS", 4, 100, 42, 1, "px")("interface", "manual_indication_teamskeet_adding", true, function()
        return ui_handler.elements["interface"]["manual_indication"] and ui_handler.elements["interface"]["manual_indication_type"] == "Teamskeet"
    end)

    menu.slider(group, "Adding\nGT", 4, 100, 44, 1, "px")("interface", "manual_indication_getzeus_adding", true, function()
        return ui_handler.elements["interface"]["manual_indication"] and ui_handler.elements["interface"]["manual_indication_type"] == "Invictus"
    end)
    
    menu.combo(group, "With Scope", {"None", "Low Opacity", "Move With Lines"})("interface", "manual_indication_scope", true, function()
        return ui_handler.elements["interface"]["manual_indication"]
    end)

    menu.color_picker(group, "Accent Color\nDEF", color(113, 138, 187, 255))("interface", "manual_indication_accent_color", true, function()
        return ui_handler.elements["interface"]["manual_indication"] and ui_handler.elements["interface"]["manual_indication_type"] == "Default"
    end)

    menu.color_picker(group, "Accent Color\nTS", color(175, 255, 0))("interface", "manual_indication_teamskeet_accent_color", true, function()
        return ui_handler.elements["interface"]["manual_indication"] and ui_handler.elements["interface"]["manual_indication_type"] == "Teamskeet"
    end)

    menu.color_picker(group, "Desync Color\nTS", color(0, 200, 255))("interface", "manual_indication_teamskeet_desync_color", true, function()
        return ui_handler.elements["interface"]["manual_indication"] and ui_handler.elements["interface"]["manual_indication_type"] == "Teamskeet"
    end)

    menu.color_picker(group, "Accent Color\nGT", color(111, 111, 220))("interface", "manual_indication_getzeus_accent_color", true, function()
        return ui_handler.elements["interface"]["manual_indication"] and ui_handler.elements["interface"]["manual_indication_type"] == "Invictus"
    end)
    
    menu.color_picker(group, "Second Color\nGT", color(255))("interface", "manual_indication_getzeus_second_color", true, function()
        return ui_handler.elements["interface"]["manual_indication"] and ui_handler.elements["interface"]["manual_indication_type"] == "Invictus"
    end)
end)

menu.switch(ui_handler.tab.interface.interface, "Scope Overlay")("interface", "scope_overlay")(function(group)
    menu.color_picker(group, "Accent Color", color(0, 0, 0, 190))("interface", "scope_overlay_accent_color", true, function()
        return ui_handler.elements["interface"]["scope_overlay"]
    end)

    menu.color_picker(group, "Second Color", color(0, 0, 0, 0))("interface", "scope_overlay_second_color", true, function()
        return ui_handler.elements["interface"]["scope_overlay"]
    end)

    menu.selectable(group, "\nscope_overlay_settings", {"Rotated", "Dynamic Offset", "Disable Animation"})("interface", "scope_overlay_settings", true, function()
        return ui_handler.elements["interface"]["scope_overlay"]
    end)

    menu.selectable(group, "Exclude Lines", {"Left", "Top", "Right", "Bottom"})("interface", "scope_overlay_additional", true, function()
        return ui_handler.elements["interface"]["scope_overlay"]
    end)

    menu.slider(group, "\nscope_overlay_size", 0, 500, 190)("interface", "scope_overlay_size", true, function(gr)
        return ui_handler.elements["interface"]["scope_overlay"]
    end)

    menu.slider(group, "\nscope_overlay_gap", 0, 500, 10)("interface", "scope_overlay_gap", true, function()
        return ui_handler.elements["interface"]["scope_overlay"]
    end)

    menu.slider(group, "Thickness", 1, 10, 1, nil, 'px')("interface", "scope_overlay_thickness", true, function()
        return ui_handler.elements["interface"]["scope_overlay"]
    end)

    menu.slider(group, "Animation Speed", 3, 20, 12, '', 'fr')("interface", "scope_overlay_speed", true, function()
        return ui_handler.elements["interface"]["scope_overlay"]
    end)
end)

drag.menu = {}
drag.items = {"keybinds", "spectators", "velocity_indication", "damage_indication"}
for k, v in pairs(drag.items) do
    drag.menu[v] = 
    {
        pos_x = menu.slider(ui_handler.tab.interface.interface, v.."_pos_x", 0, defines.screen_size.x, math.floor(0.1 * defines.screen_size.x))("drag", v.."_pos_x", true, function()
            return false
        end),
        pos_y = menu.slider(ui_handler.tab.interface.interface, v.."_pos_y", 0, defines.screen_size.y, math.floor(0.1 * k * defines.screen_size.y))("drag", v.."_pos_y", true, function()
            return false
        end),
    }
end

drag.adjust = function()
    for k, item in pairs(drag.items) do
        ui_handler.refs["drag"][item .. "_pos_x"].ref:set(ui_handler.elements["drag"][item .. "_pos_x"] * defines.dpi_scale.x)
        ui_handler.refs["drag"][item .. "_pos_y"].ref:set(ui_handler.elements["drag"][item .. "_pos_y"] * defines.dpi_scale.y)
    end
end

drag.in_bounds = function(vec1, vec2)
    local mouse_pos = ui.get_mouse_position()
    return mouse_pos.x >= vec1.x and mouse_pos.x <= vec2.x and mouse_pos.y >= vec1.y and mouse_pos.y <= vec2.y 
end

drag.item = {}
drag.current_drugging_item = nil
drag.hovered_something = false
drag.handle = function(x, y, w, h, item, alpha)
    alpha = alpha or 0

    if drag.item[item] == nil then
        drag.item[item] = {}
        drag.item[item].drag_position = vector(0,0)
        drag.item[item].is_dragging = false
    end

    if drag.in_bounds(vector(x, y), vector(x + w, y + h)) and drag.in_bounds(vector(0, 0), vector(defines.screen_size.x, defines.screen_size.y)) then
        drag.hovered_something = true
        if common.is_button_down(0x01) and drag.item[item].is_dragging == false and (drag.current_drugging_item == nil or drag.current_drugging_item == item) then
            drag.item[item].is_dragging = true
            drag.current_drugging_item = item
            drag.item[item].drag_position = vector(x - ui.get_mouse_position().x, y - ui.get_mouse_position().y)
        end
    end

    if not drag.in_bounds(vector(0, 0), vector(defines.screen_size.x, defines.screen_size.y)) then
        drag.item[item].is_dragging = false
    end

    if not common.is_button_down(0x01) then
        drag.item[item].is_dragging = false
        drag.current_drugging_item = nil
    end

    if drag.item[item].is_dragging and ui.get_alpha() > 0 then
        ui_handler.refs["drag"][item .. "_pos_x"].ref:set(ui.get_mouse_position().x + drag.item[item].drag_position.x)
        ui_handler.refs["drag"][item .. "_pos_y"].ref:set(ui.get_mouse_position().y + drag.item[item].drag_position.y)
    end

    if alpha > 0 then
        render.rect_outline(vector(x, y), vector(x + w, y + h), color(255, 255, 255, ui.get_alpha() / 2 * alpha), 1, 4)
    end
end

events.mouse_input:set(function()
    if (drag.hovered_something or drag.current_drugging_item) and ui.get_alpha() > 0 then
        return false
    end
end)

damage_indication.handle = function()
    local damage_indication = ui_handler.elements["interface"]["screen_indication"] and ui_handler.refs["interface"]["screen_indication_settings"].ref:get("Damage")
    local damage_indication_accent_color = ui_handler.elements["interface"]["damage_indication_accent_color"]
    local pos = vector(ui_handler.elements["drag"]["damage_indication_pos_x"], ui_handler.elements["drag"]["damage_indication_pos_y"])

    local player = entity.get_local_player()

    local anim = {}
    anim.main = animations.new("damage_indication", damage_indication and (ui.get_alpha() > 0.5 or player and player:is_alive()) and 255 or 0)

    if anim.main < 1 then
        return
    end

    local text = tostring(neverlose_refs.min_damage:get())
    local text_size = render.measure_text(1, nil, text)

    render.text(1, pos + vector(5, 4), damage_indication_accent_color:override("a", anim.main), nil, text)
    drag.handle(pos.x, pos.y, text_size.x + 10, text_size.y + 10, "damage_indication", anim.main)
end

velocity_indication.bytes = {
    "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x01\x61\x00\x00\x01\x2C\x08\x06\x00\x00\x00\x12\x39\x02\x65\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0B\x13\x00\x00\x0B\x13\x01\x00\x9A\x9C\x18\x00\x00\x57\x2D\x49\x44\x41\x54\x78\x9C\xED\x9D\x79\x7C\x14\x45\xFA\xFF\x3F\x73\x4F\xAE\xC9\x7D\x27\x04\x12\x72\x02\x09\x57\x02\x04\x10\xB9\x14\x58\x3C\x10\xE1\xCB\x02\xC2\x17\x44\x3C\xF0\x8B\x28\x8A\x2B\x2E\x82\x28\x87\xA2\xA2\x22\x22\xE8\xAE\x3F\x74\x11\x45\xBC\x77\x3D\x10\x15\xE5\x90\xFB\x86\x84\x84\x90\x90\x84\x04\x72\x90\x84\x1C\x33\x93\x39\x9E\xDF\x1F\xC9\xB0\x93\x99\x4E\x48\x32\x3D\xD3\x33\x93\x7A\xBF\x5E\xFD\x52\xAA\x27\xD5\x4F\x77\x55\x7D\xBA\xBA\xEA\xA9\xA7\x44\x44\x04\x06\x83\xC1\x60\x08\x83\x48\x68\x03\x18\x8C\x36\x08\x01\x30\x16\xC0\x68\x00\xBD\x00\x44\x02\xF0\x05\xA0\x04\x20\x6E\x3E\x4C\x18\x9B\x0F\x0D\x80\x1A\x00\xC5\x00\xCE\x01\xF8\x05\xC0\xCF\x00\xCA\x1D\x66\x35\x83\xD1\x4E\x58\x27\x98\xE1\x6C\xF8\x03\x98\x8B\x26\xE1\xBC\x01\x80\xF8\x38\xC4\x62\x31\x35\xE7\xB7\x1B\xC0\x03\x68\x12\x72\x06\x43\x70\x98\x08\x33\x9C\x01\x05\x80\x19\x00\x8E\x00\x30\x80\x27\xE1\x6D\xED\x10\x8B\xC5\x24\x91\x48\x0C\x00\x0E\x03\xF8\x2B\x00\xB9\x23\x6E\x92\xC1\xE0\x82\x89\x30\x43\x48\x42\x01\xBC\x09\xA0\x0E\x76\x16\xDE\xD6\x0E\xB9\x5C\x4E\x00\x6A\x01\xAC\x6F\xB6\x87\xC1\x70\x28\x4C\x84\x19\x42\x10\x0E\xE0\x7D\x00\x3A\x08\x24\xBE\x96\x87\x54\x2A\x25\xA9\x54\xAA\x03\xB0\x05\x40\x98\x3D\x6F\x9E\xC1\x30\x87\x88\xD8\xC4\x1C\xC3\x61\xC8\x01\x3C\x0B\xE0\xEF\xE8\xE0\x10\x80\x9F\x9F\x1F\xD2\xD3\xD3\xD1\xB7\x6F\x5F\x24\x24\x24\x20\x26\x26\x06\xE1\xE1\xE1\x08\x0E\x0E\x06\x00\x94\x95\x95\xE1\xEA\xD5\xAB\x28\x28\x28\x40\x4E\x4E\x0E\x4E\x9E\x3C\x89\x23\x47\x8E\xA0\xA6\xA6\xA6\x43\x06\xCA\x64\x32\x18\x8D\x46\xAD\xC1\x60\x78\x01\x4D\xBD\xF4\xC6\x0E\x65\xC0\x60\x74\x10\x26\xC2\x0C\x47\x91\x09\x60\x3B\x80\x6E\xED\xF9\xB1\x8F\x8F\x0F\x86\x0D\x1B\x86\x11\x23\x46\x60\xC8\x90\x21\x48\x48\x48\x80\x9F\x9F\x1F\x94\x4A\x65\xBB\x2E\xA6\xD1\x68\x50\x5D\x5D\x8D\x9C\x9C\x1C\xFC\xF9\xE7\x9F\xF8\xF5\xD7\x5F\x71\xE0\xC0\x01\xD4\xD5\xD5\xB5\xEB\xEF\x7D\x7C\x7C\x50\x5B\x5B\x7B\x19\x4D\x63\xC6\x7F\xB6\xEB\x8F\x18\x8C\x4E\xC0\x86\x23\x18\xF6\x46\x06\xE0\x75\x34\xB9\x8E\xB5\x39\x24\xA0\x50\x28\x68\xEA\xD4\xA9\xF4\xCD\x37\xDF\x90\x46\xA3\x21\xBE\xD1\x68\x34\xF4\xD5\x57\x5F\xD1\x94\x29\x53\x4C\x63\xC1\xB7\x9C\xC0\xF3\xF2\xF2\x32\x02\x78\xAD\xF9\x3E\x18\x0C\xDE\x61\x22\xCC\xB0\x27\xDD\x00\x1C\xC7\x2D\xC4\x2E\x34\x34\x94\x56\xAD\x5A\x45\x57\xAF\x5E\xE5\x5D\x78\x5B\xA3\xB4\xB4\x94\x5E\x7E\xF9\x65\x0A\x0D\x0D\xBD\xA5\x18\x07\x04\x04\x10\x80\x83\x68\xF2\x51\x66\x30\x78\x85\x89\x30\xC3\x5E\x64\x00\xB8\x8E\x36\xC4\x2D\x3C\x3C\x9C\xDE\x7C\xF3\x4D\x6A\x68\x68\x70\x98\xF8\x5A\x52\x5F\x5F\x4F\xEB\xD7\xAF\xA7\xB0\xB0\xB0\x36\x85\xD8\xC7\xC7\x87\xC4\x62\x71\x05\x80\x74\xC7\x3F\x4A\x86\x3B\xC3\x44\x98\x61\x0F\xEE\x01\xA0\x45\x1B\x6E\x61\x4B\x97\x2E\xA5\xDA\xDA\x5A\xC1\xC4\xD7\x92\xDA\xDA\x5A\x5A\xBC\x78\x71\x9B\xC3\x14\x4A\xA5\x92\x94\x4A\xA5\x1A\xC0\xDD\x42\x3C\x54\x86\x7B\x42\x4C\x84\x19\x3C\x33\x05\x80\x1E\xAD\x08\x59\x66\x66\x26\x65\x67\x67\x0B\xAD\xB9\xAD\x92\x95\x95\x45\x43\x86\x0C\x69\x55\x88\x65\x32\x19\xF9\xF8\xF8\xE8\x00\x4C\x16\xE2\xE1\x32\xDC\x0F\x62\x22\xCC\xE0\x91\x29\x68\x65\xC5\x9B\x4C\x26\xA3\x75\xEB\xD6\x91\xC1\x60\x10\x5A\x67\x6F\x89\x5E\xAF\xA7\x57\x5F\x7D\x95\x64\x32\x59\xAB\x3E\xC5\x2A\x95\x4A\x0F\xD6\x23\x66\xF0\x00\x31\x11\x66\xF0\xC4\x28\xB4\xB2\xF8\xA2\x5B\xB7\x6E\xF4\xE7\x9F\x7F\x0A\xAD\xAD\x1D\xE6\x8F\x3F\xFE\xA0\xC8\xC8\xC8\x56\x87\x26\xBC\xBD\xBD\xD5\x00\x06\x09\xF3\xB8\x19\xEE\x02\x31\x11\x66\xF0\x40\x32\x5A\x09\xB6\x93\x91\x91\x41\xD7\xAE\x5D\x13\x5A\x4F\x3B\x4D\x69\x69\x29\xA5\xA7\xA7\x73\x0A\xB1\x9F\x9F\x1F\xC9\xE5\xF2\x4A\x00\x3D\x85\x79\xEC\x0C\x77\x80\x98\x08\x33\x6C\xC4\x1B\x40\x36\x38\x44\x6A\xD4\xA8\x51\x82\x7A\x3E\xF0\x45\x5D\x5D\x1D\x0D\x1A\x34\x88\x53\x88\x23\x22\x22\x08\xC0\x79\x00\x9E\x82\x3C\x7D\x86\xCB\x43\x4C\x84\x19\x36\xB2\x1D\x1C\xE2\x94\x9C\x9C\x4C\xD5\xD5\xD5\x42\xEB\x27\x6F\x94\x95\x95\x51\xCF\x9E\x3D\x39\x85\x38\x2E\x2E\x8E\x00\x7C\x24\xD0\xF3\x67\xB8\x38\xC4\x44\x98\x61\x03\xD3\xC1\x21\x4A\xDE\xDE\xDE\x74\xFE\xFC\x79\xA1\x75\x93\x77\xCE\x9E\x3D\x4B\x9E\x9E\x9E\x9C\x42\x1C\x15\x15\x45\x68\x9A\x98\x64\x30\x3A\x04\x31\x11\x66\x74\x92\x30\x00\x55\xE0\x10\xA4\xED\xDB\xB7\x0B\xAD\x97\x76\xE3\xA3\x8F\x3E\x6A\x75\x7C\x58\x22\x91\x54\xA2\x69\x27\x10\x06\xA3\xDD\x10\x13\x61\x46\x27\xF9\x1C\x1C\x62\x34\x7D\xFA\x74\xA1\x75\xD2\xEE\x4C\x99\x32\x85\x53\x88\x53\x52\x52\x08\x4D\xC3\x33\x0C\x46\xBB\x21\x26\xC2\x8C\x4E\x30\x11\x1C\x22\x14\x16\x16\x46\x95\x95\x95\x42\x6B\xA4\xDD\x29\x2F\x2F\xA7\x90\x90\x90\x56\x97\x62\x03\x18\x27\x50\xB9\x30\x5C\x10\x62\x22\xCC\xE8\x20\x5E\x00\x2E\x83\x43\x80\x3E\xFF\xFC\x73\xA1\xF5\xD1\x61\x6C\xDF\xBE\xBD\x2D\x11\xBE\x04\xC0\x43\x90\xD2\x61\xB8\x1C\xC4\x44\x98\xD1\x41\xD6\x81\x43\x7C\x26\x4E\x9C\x28\xB4\x2E\x3A\x9C\x71\xE3\xC6\xB5\x35\x2C\xB1\x46\xA0\xF2\x61\xB8\x18\xC4\x44\x98\xD1\x01\xD2\xC0\x11\x17\xC2\xCB\xCB\x8B\x0A\x0A\x0A\x84\xD6\x44\x87\x93\x97\x97\x47\x1E\x1E\x1E\x9C\x4B\xB4\x55\x2A\x95\x0E\x40\x6F\xA1\x0A\x8A\xE1\x3A\x10\x13\x61\x46\x3B\x11\xA3\x29\xA6\xAE\x95\xE8\xAC\x5B\xB7\x4E\x68\x3D\x14\x8C\x35\x6B\xD6\xB4\xE5\x3B\xBC\x0F\x60\x3B\xD7\x30\xDA\x86\x98\x08\x33\xDA\xC9\x63\xE0\x10\x9B\xB4\xB4\x34\xD2\xE9\x74\x42\x6B\xA1\x60\x34\x36\x36\x52\xEF\xDE\xBD\xDB\x12\xE2\x87\x05\x2A\x2F\x86\x8B\x40\x4C\x84\x19\xED\x20\x02\x1C\xB1\x21\xC4\x62\x31\x1D\x3C\x78\x50\x68\x1D\x14\x9C\x7D\xFB\xF6\x91\x48\x24\xB2\x12\x61\x95\x4A\x45\x32\x99\xAC\x1A\x40\xA8\x40\xE5\xC6\x70\x01\x88\x89\x30\xA3\x1D\x7C\x06\x8E\x9E\xDE\x63\x8F\x3D\x26\xB4\xFE\x39\x0D\x0F\x3F\xFC\x70\x5B\x93\x74\xDB\x04\x2A\x37\x86\x0B\x40\x4C\x84\x19\xB7\x60\x3C\x38\xC4\x25\x22\x22\xC2\xAD\x62\x43\xD8\xCA\xF5\xEB\xD7\x5B\xDD\xAF\xAE\xD9\x6D\x6D\xAC\x40\xE5\xC7\x70\x72\x88\x89\x30\xA3\x0D\x3C\x01\x14\x80\x43\x58\x3E\xFB\xEC\x33\xA1\x75\xCF\xE9\xD8\xB6\x6D\x5B\x5B\x22\x9C\x07\x40\x29\x44\x21\x32\x9C\x1B\x62\x22\xCC\x68\x83\x57\xC0\x21\x2A\xE3\xC7\x8F\x17\x5A\xEF\x9C\x96\xB1\x63\xC7\xB6\x35\x2C\xB1\x4A\xA0\x72\x64\x38\x31\xC4\x44\x98\xD1\x0A\xA9\xE0\xD8\x29\xC3\xD3\xD3\x93\xF2\xF3\xF3\x85\xD6\x3A\xA7\xE5\xE2\xC5\x8B\xA4\x54\x2A\x39\x7D\x87\x7D\x7C\x7C\x1A\x01\xA4\x08\x55\xA0\x0C\xE7\x84\x98\x08\x33\x38\x10\x03\xD8\x0F\x8E\x1E\xDD\x2B\xAF\xBC\x22\xB4\xCE\x39\x3D\xAB\x56\xAD\x6A\xCB\x65\x6D\x2F\x98\xEF\x30\xC3\x0C\x62\x22\xCC\xE0\xE0\x11\x70\x88\x48\x6A\x6A\x2A\x35\x36\x36\x0A\xAD\x71\x4E\x8F\x56\xAB\x35\x0D\x3F\xB4\x26\xC4\xF3\x04\x2A\x57\x86\x13\x42\x4C\x84\x19\x16\x84\x01\xA8\x01\x87\x4F\xF0\xFE\xFD\xFB\x85\xD6\x37\x97\x61\xEF\xDE\xBD\x9C\xBE\xC3\xBE\xBE\xBE\x24\x95\x4A\xAF\x03\x08\x16\xAA\x80\x19\xCE\x05\x31\x11\x66\x58\xC0\xB9\x5D\xD1\x23\x8F\x3C\x22\xB4\xAE\xB9\x1C\xF3\xE6\xCD\xE3\xEC\x0D\xF7\xEA\xD5\x8B\x00\x7C\x2C\x50\xF9\x32\x9C\x0C\x62\x22\xCC\x30\x63\x1C\x38\x44\x23\x2C\x2C\x8C\xAA\xAA\xAA\x84\xD6\x34\x97\xA3\xB2\xB2\x92\x82\x83\x83\x39\x85\x38\x2C\x2C\x8C\x00\x8C\x16\xA8\x9C\x19\x4E\x04\x11\x41\x2C\xB4\x11\x0C\xA7\xC0\x03\xC0\xBB\x5C\x27\xD6\xAF\x5F\x0F\x3F\x3F\x3F\xC7\x5A\xE3\x06\x04\x04\x04\xE0\x8D\x37\xDE\xE0\x3C\x27\x16\x8B\x01\xE0\x3D\x30\xDF\x61\x06\x83\xD1\xCC\x6A\x70\xF4\xD8\xC6\x8D\x1B\x27\x74\x87\xD2\xE5\x19\x3D\x7A\x34\x67\x6F\x38\x39\x39\x99\x00\xBC\x24\x50\x79\x33\x9C\x04\x62\xC3\x11\x0C\x34\xC5\xBD\xB5\xF2\x09\xF6\xF0\xF0\xA0\xBC\xBC\x3C\xA1\x35\xCC\xE5\xC9\xC9\xC9\xE1\xF4\x1D\x96\xCB\xE5\xE4\xE3\xE3\xA3\x05\x90\x2C\x54\xC1\x33\x84\x87\xD8\x70\x44\x97\x47\x84\xA6\xCF\x62\xA9\xE5\x89\x65\xCB\x96\x21\x36\x36\xD6\xF1\x16\xB9\x19\xF1\xF1\xF1\x78\xFE\xF9\xE7\xAD\xD2\x1B\x1B\x1B\x11\x16\x16\x26\x07\xB0\x09\xCC\x77\x98\xC1\xE8\xB2\xCC\x07\xC7\xA7\x72\xEF\xDE\xBD\x99\x4F\x30\x8F\x68\x34\x1A\xD3\xF0\x83\xD5\xD1\xA3\x47\x0F\x02\x30\x47\xA0\xF2\x67\x08\x0C\xB1\xE1\x88\x2E\x4D\x08\x80\x2A\x58\x88\x82\x48\x24\xA2\x7D\xFB\xF6\x09\xAD\x5B\x6E\xC7\x9E\x3D\x7B\x98\xEF\x30\xC3\x0A\x62\x22\xDC\xA5\xD9\x06\x8E\x9E\xD9\xFC\xF9\xF3\x85\xD6\x2B\xB7\x65\xCE\x9C\x39\x6D\xF9\x0E\x6F\x15\xA8\x1E\x30\x04\x84\x98\x08\x77\x59\xC6\x82\x43\x0C\x42\x42\x42\xE8\xFA\xF5\xEB\x42\x6B\x95\xDB\x52\x51\x51\xC1\xE9\x3B\x2C\x12\x89\x28\x34\x34\xD4\x08\x60\xA4\x50\x15\x82\x21\x0C\xC4\x26\xE6\xBA\x24\x4A\x34\x4D\x06\x59\xB1\x7E\xFD\x7A\xF8\xFB\xFB\x3B\xD8\x9C\xAE\x43\x60\x60\x20\x5E\x7B\xED\x35\xAB\x74\x22\x82\x54\x2A\x35\x4D\x92\x2A\x1C\x6E\x18\x83\xC1\x70\x28\xAB\xC0\xD1\x0B\x1E\x3B\x76\xAC\xD0\x1D\xC5\x2E\x81\xD1\x68\xA4\x91\x23\x47\xB6\xE5\x3B\xBC\x42\x98\x6A\xC1\x10\x02\x62\xC3\x11\x5D\x8E\x14\x00\x8D\xB0\x68\xFC\x4A\xA5\x92\x72\x73\x73\x85\xD6\xA7\x2E\x43\x76\x76\x36\x29\x14\x0A\x4E\xDF\x61\x6F\x6F\x6F\x2D\x80\x44\xA1\x2A\x08\xC3\xB1\x10\x1B\x8E\xE8\x52\x98\x3E\x77\x65\x96\x27\x96\x2D\x5B\x86\x9E\x3D\x7B\x3A\xDE\xA2\x2E\x4A\x62\x62\x22\x9E\x7B\xEE\x39\xAB\xF4\xC6\xC6\x46\x84\x87\x87\x33\xDF\x61\x06\xC3\x4D\x79\x10\x1C\x9F\xC0\x29\x29\x29\xA4\xD5\x6A\x85\xEE\x1C\x76\x39\x34\x1A\x0D\x25\x26\x26\xB6\xE5\x3B\x3C\x5B\xA0\x7A\xC2\x70\x20\xC4\x86\x23\xBA\x0C\xC1\x00\xAE\x83\x63\x56\xFE\x8F\x3F\xFE\x10\x5A\x8F\xBA\x2C\xBF\xFE\xFA\x2B\xA7\xEF\xB0\x9F\x9F\x1F\x49\x24\x92\x0A\x00\x81\x42\x55\x18\x86\x63\x20\x26\xC2\x5D\x86\x8F\xC1\xD1\xE3\x7A\xF0\xC1\x07\x85\xD6\xA1\x2E\xCF\xEC\xD9\xB3\xDB\xF2\x1D\xFE\xA7\x40\xF5\x85\xE1\x20\x88\x89\x70\x97\x60\x34\x00\x23\x2C\x1A\x79\x70\x70\x30\x55\x56\x56\x0A\xAD\x41\x5D\x9E\xF2\xF2\x72\x0A\x0C\x0C\xE4\xF4\x1D\x0E\x09\x09\x31\x02\x18\x21\x54\xC5\x61\xD8\x1F\x62\x13\x73\x6E\x8F\x12\x4D\x93\x71\x56\x93\x3C\x6F\xBC\xF1\x06\x02\x02\x02\x1C\x6F\x11\xA3\x05\x41\x41\x41\x58\xB7\x6E\x9D\x55\x3A\x11\x41\x2E\x97\x8B\x00\x6C\x06\xF3\x1D\x66\x30\x5C\x96\x95\xE0\xF8\xD4\x1D\x3D\x7A\x34\x19\x8D\x46\xA1\x3B\x81\x8C\x66\x8C\x46\x23\x8D\x18\x31\xA2\x2D\xDF\xE1\x65\x02\xD5\x1F\x86\x9D\x21\x22\xE6\x06\xE3\xC6\x24\x01\x38\x05\x40\x6E\x9E\xA8\x54\x2A\x71\xFA\xF4\x69\xC4\xC7\xC7\x0B\x63\x15\x83\x93\xEC\xEC\x6C\xF4\xED\xDB\x17\x5A\xAD\xB6\x45\xBA\x42\xA1\x80\x44\x22\xD1\x36\x34\x34\xA4\x02\xC8\x11\xC6\x3A\x86\xBD\x20\x36\x1C\xE1\xB6\x98\x7C\x82\xE5\x96\x27\x96\x2E\x5D\xCA\x04\xD8\x09\x49\x4A\x4A\xC2\x92\x25\x4B\xAC\xD2\xB5\x5A\x2D\xA2\xA2\xA2\x14\x68\xDA\x7E\x8A\x75\x9A\x18\x0C\x17\x61\x0E\x38\x3E\x6D\x93\x92\x92\x48\xA3\xD1\x08\xFD\xF5\xCD\x68\x05\xB5\x5A\x4D\x09\x09\x09\x9C\xC3\x12\xDD\xBB\x77\x27\x00\x33\x05\xAA\x4F\x0C\x3B\x41\xCC\x3B\xC2\x2D\x09\x02\x50\x09\x8E\xD9\xF6\x3D\x7B\xF6\x08\xAD\x33\x8C\x5B\xB0\x7B\xF7\x6E\x4E\xDF\x61\x7F\x7F\x7F\x92\x48\x24\xE5\x00\xD8\x6C\xAA\x1B\x41\x4C\x84\xDD\x92\xAD\xE0\xE8\x49\xCD\x99\x33\x47\x68\x7D\x61\xB4\x93\x99\x33\x67\xB6\xE5\x3B\xFC\x81\x40\xF5\x8A\x61\x07\x88\x4D\xCC\xB9\x1D\x23\x01\xFC\x02\x8B\xB1\xC3\xA0\xA0\x20\x64\x67\x67\x23\x30\x90\x2D\xC0\x72\x05\xCA\xCB\xCB\x91\x94\x94\x84\xEB\xD7\xAF\xB7\x48\x17\x89\x44\x08\x0A\x0A\xA2\xF2\xF2\xF2\x11\x00\xF6\x0A\x63\x1D\x83\x4F\x88\x4D\xCC\xB9\x15\x0A\xB4\xE2\x13\xFC\xFA\xEB\xAF\x33\x01\x76\x21\x82\x83\x83\xF1\xEA\xAB\xAF\x5A\xA5\x13\x11\x94\x4A\xA5\xC9\x77\xD8\x6A\xD2\x95\xC1\x60\x08\xCB\x72\x70\x7C\xC2\x8E\x1C\x39\x92\xF9\x04\xBB\x20\x46\xA3\x91\x86\x0F\x1F\xCE\x39\x2C\x91\x94\x94\x44\x00\xAC\xB7\x70\x66\xB8\x1C\xC4\x86\x23\xDC\x86\x44\x00\xA7\x61\xD1\x3B\x52\x28\x14\x38\x75\xEA\x14\x12\x13\x59\x78\x5A\x57\xE4\xFC\xF9\xF3\xE8\xD7\xAF\x1F\x1A\x1B\x1B\x5B\xA4\x9B\xF9\x0E\xF7\x06\x70\x51\x18\xEB\x18\x7C\x40\x6C\x38\xC2\x2D\x10\xA1\x29\xFE\xAC\xD5\xE7\xE9\xDF\xFE\xF6\x37\x26\xC0\x2E\x4C\x4A\x4A\x0A\x9E\x79\xE6\x19\xAB\x74\x0B\xDF\x61\x06\x83\x21\x30\xB3\xC0\xF1\xC9\x9A\x98\x98\xC8\x7C\x82\xDD\x00\xB5\x5A\x4D\x3D\x7B\xF6\x6C\xCB\x77\x78\xBA\x40\xF5\x8E\xC1\x03\xC4\x7A\xC2\x2E\x4F\x20\x80\x37\x2C\x13\x45\x22\x11\x36\x6D\xDA\x04\x85\x82\xC5\x7D\x71\x75\x94\x4A\x25\xDE\x7D\x97\xBB\xC3\x5B\x53\x53\x03\x89\x44\xF2\x26\x00\xB6\x3B\x2B\x83\x21\x10\xFF\x04\x47\x0F\x69\xD6\xAC\x59\x42\x77\xE0\x18\x3C\x33\x7D\xFA\xF4\xB6\x7C\x87\x37\x0B\x54\xFF\x18\x36\x42\x6C\x62\xCE\xA5\x19\x01\xE0\x37\x58\xB8\xA4\x05\x06\x06\x22\x2B\x2B\x0B\xC1\xC1\xC1\xC2\x58\xC5\xB0\x0B\x65\x65\x65\x48\x4A\x4A\x42\x55\x55\x55\x8B\x74\x33\xDF\xE1\xE1\x00\xF6\x0B\x63\x1D\xA3\xB3\x10\x1B\x8E\x70\x59\x5A\xF5\x09\x5E\xB7\x6E\x1D\x13\x60\x37\x24\x24\x24\x04\x6B\xD7\xAE\xB5\x4A\x27\x22\x78\x78\x78\x98\x7C\x87\xAD\x36\x71\x65\x30\x18\xF6\x61\x19\x38\x3E\x4D\x47\x8C\x18\xC1\x7C\x82\xDD\x18\xA3\xD1\x48\x43\x87\x0E\x6D\xCB\x77\xD8\x7A\x0B\x67\x86\x53\x43\x6C\x38\xC2\x25\x89\x07\x70\x06\x16\xBB\x2D\x28\x14\x0A\x9C\x38\x71\x02\xC9\xC9\xC9\xC2\x58\xC5\x70\x08\x67\xCF\x9E\x45\xFF\xFE\xFD\xA1\xD3\xE9\x5A\xA4\x2B\x95\x4A\x88\x44\x22\x8D\x5A\xAD\xEE\x05\xE0\x92\x30\xD6\x31\x3A\x0A\xB1\xE1\x08\x97\x64\x13\x38\xB6\xBB\x59\xB2\x64\x09\x13\xE0\x2E\x40\xEF\xDE\xBD\xF1\xF4\xD3\x4F\x5B\xA5\x6B\x34\x1A\x44\x47\x47\x2B\xC1\x7C\x87\x19\x0C\xBB\x32\x13\x1C\x9F\xA2\xF1\xF1\xF1\xA4\x56\xAB\x85\xFE\x5A\x66\x38\x88\x86\x86\x06\x8A\x8D\x8D\xE5\x1C\x96\x88\x89\x89\x21\x00\xD3\x04\xAA\x9F\x8C\x0E\x42\xAC\x27\xEC\x52\x04\x00\x58\xCF\x75\x62\xD3\xA6\x4D\x50\x2A\x95\x0E\x36\x87\x21\x14\x1E\x1E\x1E\xAD\xFA\x0E\xD7\xD5\xD5\x41\x2C\x16\xBF\x05\xC0\xCF\xA1\x46\x31\x18\x5D\x80\xF7\xC1\xD1\xF3\x99\x39\x73\xA6\xD0\x1D\x33\x86\x40\x4C\x9B\x36\xAD\x2D\xDF\xE1\x4D\x02\xD5\x53\x46\x07\x20\x36\x31\xE7\x32\x0C\x07\xF0\x3B\x2C\x5C\xD2\x02\x02\x02\x90\x9D\x9D\xCD\x5C\xD2\xBA\x28\x57\xAF\x5E\x45\x72\x72\x32\xAA\xAB\xAB\x5B\xA4\x8B\xC5\x62\xF8\xFB\xFB\x1B\x2B\x2B\x2B\x87\x03\x38\x20\x88\x71\x8C\x76\x41\x6C\x38\xC2\x25\x90\xA3\xC9\x07\xD4\xEA\x85\xF9\xCA\x2B\xAF\x30\x01\xEE\xC2\x84\x85\x85\x61\xCD\x9A\x35\x56\xE9\x46\xA3\x11\x5E\x5E\x5E\x62\x34\xF9\x92\x33\xDF\x61\x06\xC3\x46\x96\x82\xE3\x93\x73\xF8\xF0\xE1\xCC\x27\x98\x41\x06\x83\x81\x32\x33\x33\x39\x87\x25\x12\x13\x13\x09\x80\xF5\x16\xCE\x0C\xA7\x81\xD8\x70\x84\xD3\x13\x07\xE0\x1C\x2C\x5C\xD2\xE4\x72\x39\x4E\x9C\x38\x81\x94\x94\x14\x61\xAC\x72\x32\xAE\x5C\xB9\x82\x6F\xBF\xFD\x16\x95\x95\x95\x18\x3F\x7E\x3C\x7A\xF4\xE8\x01\xB9\x5C\x0E\xB1\x58\x0C\x4F\x4F\x4F\xA1\xCD\xB3\x3B\xA7\x4F\x9F\xC6\xC0\x81\x03\xAD\x7C\x87\x3D\x3C\x3C\x00\x40\xDD\xEC\x3B\x9C\x2F\x84\x6D\x8C\xB6\x21\xB6\xD1\xA7\xD3\xB3\x0B\x1C\x3D\x9C\xA5\x4B\x97\x0A\xDD\x01\x73\x2A\x7E\xFF\xFD\x77\xF2\xF3\xF3\x23\x4F\x4F\x4F\x0A\x0C\x0C\xA4\xFB\xEF\xBF\x9F\xD6\xAC\x59\x43\xEF\xBF\xFF\xBE\xD0\xA6\x39\x8C\x25\x4B\x96\xB4\xD5\x1B\xFE\x5E\xA0\xFA\xCB\xB8\x05\xC4\x7A\xC2\x4E\xCD\x74\x00\xDB\x2C\x13\xE3\xE2\xE2\x70\xF6\xEC\x59\xE6\x92\x66\xC6\x9F\x7F\xFE\x89\xCC\xCC\xCC\x9B\xFF\xF6\xF0\xF0\x80\x9F\x9F\x1F\xE4\x72\x39\x7A\xF4\xE8\x81\xD8\xD8\x58\x24\x27\x27\x63\xC2\x84\x09\x6E\xFB\xF5\xD0\xD0\xD0\x80\xDE\xBD\x7B\x23\x3F\xDF\xBA\xC3\xDB\xAD\x5B\x37\x14\x16\x16\xFE\x0F\x80\x1D\x8E\xB7\x8C\xD1\x16\x4C\x84\x9D\x17\x7F\x00\x17\x00\x58\xCD\xBA\xED\xDA\xB5\x0B\x63\xC7\x8E\x75\xBC\x45\x4E\x4A\x6E\x6E\x2E\xDE\x7B\xEF\x3D\xBC\xF1\x86\x55\x58\xE5\x16\x44\x44\x44\xA0\x5F\xBF\x7E\x48\x4B\x4B\x83\x4A\xA5\x42\xB7\x6E\xDD\x30\x71\xE2\x44\xF8\xF8\xF8\x38\xC8\x52\xFB\xF3\xC3\x0F\x3F\x60\xC2\x84\x09\x56\xE9\x41\x41\x41\xB8\x7E\xFD\xFA\x55\xA3\xD1\x98\x04\xA0\xC6\xF1\x96\x31\x5A\x83\xD8\x70\x84\xD3\xB2\x19\x1C\x9F\x96\xD3\xA7\x4F\x17\xF8\xA3\xD7\xF9\xF8\xF4\xD3\x4F\x29\x20\x20\x80\xF3\x53\xBC\xAD\xA3\x5B\xB7\x6E\xB4\x7C\xF9\x72\xFA\xFA\xEB\xAF\xE9\xFB\xEF\xBF\xA7\x2B\x57\xAE\x90\x5E\xAF\x17\xFA\x76\x6C\x66\xEA\xD4\xA9\x6D\xF9\x0E\x6F\x74\x60\x1D\x66\xB4\x03\x62\x22\xEC\x94\x0C\x05\x60\x84\x45\x23\xF2\xF7\xF7\xA7\xAB\x57\xAF\x0A\xDD\xC6\x9D\x0A\x8D\x46\x43\xEB\xD6\xAD\x23\xB1\x58\xDC\x61\x11\x36\x3F\xC4\x62\x31\x7D\xF4\xD1\x47\x54\x5B\x5B\x2B\xF4\x2D\xD9\xCC\x95\x2B\x57\xC8\xD7\xD7\x97\xF3\x1E\x03\x03\x03\x0D\x00\x06\x39\xAC\x26\x33\x6E\x09\x31\x3F\x61\xA7\x43\x86\x56\x7C\x82\xD7\xAE\x5D\x8B\xD0\xD0\x50\xC7\x5B\xE4\xC4\xEC\xDF\xBF\x1F\xFF\xFE\xF7\xBF\x61\x34\x1A\x6D\xCA\x47\xA5\x52\xF1\x64\x91\xF0\x44\x44\x44\x60\xF5\xEA\xD5\x56\xE9\x46\xA3\x11\xDE\xDE\xDE\x62\x00\x5B\x00\x48\x1D\x6E\x18\x83\xE1\x22\xFC\x0D\x1C\x3D\xB5\xA1\x43\x87\x32\x9F\x60\x0E\x7E\xFA\xE9\x27\x4A\x4F\x4F\xB7\xA9\x17\x2C\x91\x48\x68\xF8\xF0\xE1\x54\x54\x54\xE4\x16\xC3\x11\x44\x4D\xBE\xC3\x83\x06\x0D\xE2\xBC\xDF\x84\x84\x04\x02\x60\xBD\x85\x33\x43\x10\x88\xF5\x84\x9D\x8A\x58\x00\xCB\x2D\x13\x65\x32\x19\xDE\x7B\xEF\x3D\x88\x44\x6C\x0E\xD5\x92\xC3\x87\x0F\xA3\xB0\xB0\xD0\xA6\x3C\x02\x02\x02\x30\x62\xC4\x08\x44\x45\x45\x41\x22\x91\xF0\x64\x99\xB0\x88\xC5\x62\x6C\xDE\xBC\x19\x52\xA9\x75\x87\xB7\xB8\xB8\x18\x4A\xA5\x72\x05\x80\x18\x87\x1B\xC6\xE0\x84\x89\xB0\xF3\xB0\x11\x80\x95\xDF\xD9\xE2\xC5\x8B\xD1\xBB\x77\x6F\x01\xCC\x71\x7E\x0E\x1F\x3E\x8C\x6B\xD7\xAE\xD9\x94\x87\xB7\xB7\x37\xBA\x75\xEB\x66\xB5\xD0\xC1\xD5\x49\x4B\x4B\xC3\x93\x4F\x3E\x69\x95\xDE\xD0\xD0\x80\xEE\xDD\xBB\x7B\x02\x78\xC7\xF1\x56\x31\xB8\x60\x22\xEC\x1C\x4C\x03\x30\xCE\x32\x31\x36\x36\x16\x2F\xBC\xF0\x82\x00\xE6\x38\x37\x44\x84\xBA\xBA\x3A\xD4\xD7\xD7\xDB\x9C\x97\x97\x97\x17\x7C\x7D\x7D\xDD\xF2\x4B\x63\xF9\xF2\xE5\x88\x89\xB1\xEE\xF0\x66\x67\x67\x23\x3A\x3A\x7A\x22\x80\xFB\x1D\x6F\x15\xC3\x12\x26\xC2\xC2\xE3\x07\xE0\x4D\xAE\x13\x1B\x37\x6E\x34\x2D\x3D\x65\x98\xA1\xD5\x6A\xB1\x6D\xDB\x36\x5C\xBA\x64\xFB\x2E\x3E\xC3\x86\x0D\xC3\x7D\xF7\xDD\xC7\xF9\xE9\xEE\xEA\x78\x79\x79\xE1\x9D\x77\xB8\x3B\xBC\x1A\x8D\x06\x22\x91\xE8\x2D\x00\xEE\x33\x2B\xE9\xA2\x30\x11\x16\x9E\x35\x00\xAC\xDC\x1E\xA6\x4D\x9B\x86\x71\xE3\xAC\x3A\xC7\x0C\x00\x8D\x8D\x8D\xF8\xF1\xC7\x1F\x51\x52\x52\x62\x53\x3E\xB1\xB1\xB1\x48\x4F\x4F\x77\x4B\x01\x36\x31\x71\xE2\x44\xDC\x7F\xBF\x75\x87\xB7\xBC\xBC\x1C\x29\x29\x29\x11\x00\x56\x39\xDE\x2A\x06\xC3\x79\x18\x02\xC0\x00\x8B\x19\x6C\x3F\x3F\x3F\x2A\x29\x29\x11\x7A\x92\xDD\x69\xD1\x6A\xB5\xD4\xBD\x7B\x77\x9B\xBC\x22\x00\x50\xDF\xBE\x7D\xE9\xDB\x6F\xBF\x15\xFA\x76\xEC\x4E\x71\x71\x31\xA9\x54\x2A\x4E\xCF\x10\x7F\x7F\x7F\x03\x80\x74\x47\x55\x78\x46\x4B\x88\x79\x47\x08\x8A\xC9\x27\xD8\xAA\x0C\xD6\xAC\x59\x83\xF0\xF0\x70\xC7\x5B\xE4\x02\xA8\xD5\x6A\x1C\x39\x72\x04\x95\x95\x95\x36\xE7\x95\x90\x90\x80\xD8\xD8\x58\x1E\xAC\x72\x6E\x22\x23\x23\xB1\x6A\x95\x75\x87\xD7\x60\x30\xC0\xD7\xD7\x97\xF9\x0E\x33\xBA\x2C\x4B\xC0\xD1\x3B\x1B\x32\x64\x08\x19\x0C\x06\xA1\x3B\x4F\x4E\xCB\xA5\x4B\x97\x68\xF6\xEC\xD9\xE4\xE1\xE1\x61\x53\x2F\x58\x2E\x97\xD3\x07\x1F\x7C\x20\xF4\xED\x38\x0C\xBD\x5E\xDF\xAA\x4F\x75\xB3\xEF\xF0\x53\x8E\xAA\xF8\x8C\xFF\x42\xAC\x27\x2C\x18\xDD\x01\xAC\xB0\x4C\x34\xF9\x04\x8B\xC5\xAC\x58\x5A\xA3\xA1\xA1\x01\xC5\xC5\xC5\xD0\xEB\xF5\x36\xE5\xD3\xA7\x4F\x1F\x74\xEF\xDE\x9D\x1F\xA3\x5C\x00\x89\x44\xD2\xA6\xEF\xB0\x42\xA1\x58\x09\x20\xDA\xF1\x96\x31\x58\x6B\x17\x86\x8D\x00\xAC\xDC\x1E\x9E\x7C\xF2\x49\xA4\xA6\xA6\x0A\x60\x8E\xEB\xA0\x56\xAB\x71\xE8\xD0\x21\x9B\x45\x58\xA5\x52\xC1\xCB\xCB\x8B\x27\xAB\x5C\x83\x7E\xFD\xFA\x61\xE1\xC2\x85\x56\xE9\x0D\x0D\x0D\xE8\xD1\xA3\x87\x17\x58\x80\x1F\x46\x17\x61\x2A\x38\x3E\x09\xBB\x77\xEF\x4E\xF5\xF5\xF5\x42\x7F\xB5\x3A\x35\x45\x45\x45\xB4\x6C\xD9\x32\x9B\x27\xE4\x00\xD0\xDB\x6F\xBF\x4D\xE5\xE5\xE5\x42\xDF\x92\xC3\xA9\xAD\xAD\xA5\xE8\xE8\x68\xCE\x67\xD2\x9C\x3E\xC9\x31\xCD\x80\x01\xB0\xE1\x08\x21\xF0\x05\xF0\x16\xD7\x89\x8D\x1B\x37\x76\x89\xAD\x78\x6C\xE1\xF2\xE5\xCB\xD8\xB3\x67\x0F\x2F\x79\x0D\x1B\x36\x0C\x41\x41\x41\xBC\xE4\xE5\x4A\x78\x7B\x7B\x63\xE3\x46\xEE\x0E\x6F\xB3\xEF\xF0\x06\x00\xEE\x13\x64\xD9\x05\x60\x22\xEC\x58\x56\x01\x08\xB3\x4C\x9C\x3A\x75\x2A\x67\x30\x6E\x46\x4B\x6A\x6B\x6B\x51\x53\x63\x5B\x4C\x72\xB1\x58\x8C\x6E\xDD\xBA\x75\xE9\x38\xAE\x77\xDD\x75\x17\x26\x4D\xB2\xEE\xF0\x36\xFB\x0E\x47\x02\x78\xC9\xF1\x56\x31\x18\xF6\x67\x10\x38\x7C\x82\x7D\x7D\x7D\xE9\xCA\x95\x2B\x42\x7F\xA5\xBA\x04\x1B\x36\x6C\x20\x91\x48\x64\xD3\x30\x84\x97\x97\x17\x2D\x58\xB0\x80\x8A\x8A\x8A\x84\xBE\x1D\x41\x29\x2A\x2A\x22\x1F\x1F\x9F\xB6\x7C\x87\x07\x38\xAC\x65\x74\x61\x88\x88\xF9\x06\x3A\x08\x29\x9A\x7C\x31\xAD\xBE\x3C\x56\xAD\x5A\x85\x88\x88\x08\x87\x18\xF1\xF5\xD7\x5F\xE3\xE2\xC5\x8B\x38\x79\xF2\x24\xF2\xF2\xF2\xDA\x9C\xDC\x8A\x8D\x8D\x45\x62\x62\x22\xBA\x75\xEB\x86\x3E\x7D\xFA\x60\xD0\x20\x61\x63\x81\x9F\x3D\x7B\x16\x7B\xF6\xEC\xB1\xB9\x07\xAB\x52\xA9\xF0\xC4\x13\x4F\x74\xF9\xD8\xCC\x51\x51\x51\x78\xE9\xA5\x97\xB0\x68\xD1\xA2\x16\xE9\x26\xDF\xE1\xAA\xAA\xAA\xF7\xD1\xB4\x88\xC3\x20\x84\x7D\x0C\x06\xDF\x3C\x0D\x8E\x5E\xD9\xA0\x41\x83\xEC\xEE\x13\x5C\x51\x51\x41\x5F\x7E\xF9\x25\x2D\x5F\xBE\x9C\xFA\xF5\xEB\x47\x51\x51\x51\xED\xDE\x89\x22\x38\x38\x98\xE2\xE3\xE3\xE9\x2F\x7F\xF9\x0B\xFD\xFC\xF3\xCF\x76\xB5\xF3\x56\xEC\xDE\xBD\x9B\x32\x33\x33\x6D\x9E\x90\x0B\x09\x09\x21\x9D\x4E\x27\xE8\xBD\x38\x0B\x7A\xBD\x9E\x06\x0C\x18\xD0\x96\xEF\xF0\x13\xF6\x6D\x16\x0C\xEA\xC2\xC3\x62\x8E\x24\x06\x40\x1D\x2C\x2A\xB9\x54\x2A\xA5\x93\x27\x4F\xDA\xB5\x91\x95\x96\x96\xD2\xEA\xD5\xAB\xA9\x4F\x9F\x3E\x24\x95\x4A\x6D\x12\xAF\xA1\x43\x87\xD2\xA6\x4D\x9B\xE8\xC0\x81\x03\x54\x57\x57\x67\x57\xBB\xB9\x78\xFF\xFD\xF7\x6D\x5E\xAA\x2C\x97\xCB\x29\x33\x33\xD3\x2D\xB6\x31\xE2\x8B\x63\xC7\x8E\x91\x44\x22\xB1\x7A\x56\x9E\x9E\x9E\xA4\x50\x28\xEA\x00\x44\xD9\xAF\x69\x30\x88\x89\xB0\x43\xF8\x0E\x1C\x82\xF0\xF4\xD3\x4F\xDB\xB5\x71\x5D\xBB\x76\x8D\x56\xAE\x5C\x49\x41\x41\x41\xBC\xB8\x74\x99\x8E\x8C\x8C\x0C\xFA\xEC\xB3\xCF\x1C\xE6\x4E\x67\x34\x1A\xA9\xBA\xBA\x9A\x66\xCC\x98\x61\xB3\xED\xC1\xC1\xC1\xF4\xF7\xBF\xFF\x9D\xD4\x6A\xB5\x43\x6C\x77\x15\x9E\x78\xE2\x09\xCE\xE7\x95\x9C\x9C\x4C\x00\xBE\xB2\x47\xA3\x60\x34\x41\x4C\x84\xED\xCE\x64\x70\x54\xEE\x98\x98\x18\xBB\xF6\xC6\xAA\xAA\xAA\xE8\xE1\x87\x1F\x26\x7F\x7F\x7F\x9B\x27\xB2\x2C\x0F\x91\x48\x44\xFD\xFB\xF7\xA7\x6F\xBE\xF9\xC6\x6E\xF6\x9B\xA3\xD1\x68\x68\xEB\xD6\xAD\x14\x17\x17\x67\xB3\xED\x31\x31\x31\xB4\x61\xC3\x06\xD2\x68\x34\x0E\xB1\xDD\x55\xA8\xAD\xAD\xA5\xA8\xA8\x28\xCE\x67\xD6\x9C\x7E\xB7\x3D\x1A\x07\x83\x89\xB0\xBD\x51\x01\xB8\x02\x8E\x8A\xFD\xDD\x77\xDF\xD9\xAD\x41\xE5\xE5\xE5\xD1\xFD\xF7\xDF\x4F\xFE\xFE\xFE\xBC\x8A\xAF\xF9\x21\x93\xC9\x68\xF0\xE0\xC1\x76\xBD\x0F\x13\x5A\xAD\x96\xB6\x6D\xDB\x46\xB1\xB1\xB1\x36\xDB\x3D\x72\xE4\x48\x2A\x2F\x2F\x67\xFB\xF5\x71\xF0\xD5\x57\x5F\x71\x3E\xB3\x90\x90\x10\x12\x89\x44\x45\x00\xBC\xF9\x6E\x20\x0C\x26\xC2\xF6\x66\x03\x38\x2A\xF5\xE4\xC9\x93\xED\xD6\x90\x4A\x4A\x4A\xE8\xD9\x67\x9F\xE5\x1C\xE3\xB3\xC7\x31\x60\xC0\x00\xDA\xB9\x73\x27\xD5\xD4\xD4\xD8\xED\x9E\x6A\x6B\x6B\x69\xDA\xB4\x69\x9C\xEE\x54\x1D\x39\x14\x0A\x05\x3D\xF1\xC4\x13\x76\xB3\xD3\x1D\xB8\xFB\xEE\xBB\x39\x9F\x5D\xAF\x5E\xBD\x08\xC0\x1B\x3C\xB7\x0F\x06\x98\x08\xDB\x13\x93\x6B\x4F\x8B\xCA\xAC\x52\xA9\xA8\xB8\xB8\xD8\x2E\x0D\xA8\xA4\xA4\x84\xDE\x7C\xF3\xCD\x56\x3F\x2B\xED\x75\x4C\x9D\x3A\x95\xF2\xF3\xF3\xED\x72\x4F\x44\x44\x6A\xB5\x9A\x42\x43\x43\x6D\xB6\x33\x2A\x2A\x8A\xDE\x7B\xEF\x3D\xBB\xD9\xE9\x0E\x14\x16\x16\x92\xB7\xB7\xB7\xD5\xB3\x93\x48\x24\xE4\xE7\xE7\x67\x00\xD0\x8F\xD7\x56\xC2\x60\xCB\x96\xED\x84\x04\x6D\xF8\x04\x47\x46\x46\xDA\xE5\xA2\x07\x0F\x1E\xC4\xE7\x9F\x7F\x8E\xE2\xE2\x62\xBB\xE4\xCF\x85\x48\x24\xC2\xF9\xF3\xE7\x71\xF6\xEC\x59\x68\x34\x1A\xDE\xF3\xD7\xEB\xF5\x28\x29\x29\xE1\xA5\xB7\x90\x9C\x9C\xCC\x36\x4C\xBD\x05\xD1\xD1\xD1\x58\xB9\x72\xA5\x55\xBA\xC1\x60\x80\xBF\xBF\xBF\x18\xC0\xFB\x68\xAA\xDF\x0C\x86\x53\xF3\x14\x38\x7A\x62\xE9\xE9\xE9\xA4\xD7\xEB\xED\xD6\x8B\xF9\xE0\x83\x0F\xA8\x67\xCF\x9E\x0E\xED\x05\x9B\x8E\x89\x13\x27\xD2\xE1\xC3\x87\x79\xBF\xA7\x92\x92\x12\x7A\xEE\xB9\xE7\x38\x7B\x67\x1D\x3D\x56\xAD\x5A\xC5\xBB\x7D\xEE\x88\x5E\xAF\xA7\x7E\xFD\xFA\x71\x3E\xC3\xF8\xF8\x78\x02\xF0\x7F\xFC\x35\x15\x06\xB1\x9E\x30\xEF\x44\x03\xB0\xEA\x4A\x98\x62\xB9\x4A\x24\xFC\x77\x22\x1A\x1A\x1A\xB0\x73\xE7\x4E\xFC\xE3\x1F\xFF\xC0\xE5\xCB\x97\x79\xCF\xBF\x3D\x9C\x39\x73\x06\x39\x39\x39\xBC\xE7\x7B\xE3\xC6\x0D\x1C\x3D\x7A\x14\x8D\x8D\x8D\x36\xE7\x15\x10\x10\xC0\x83\x45\xEE\x8F\x44\x22\xC1\x96\x2D\x5B\x38\xEB\x6A\x69\x69\x29\xE4\x72\xF9\x2A\x00\xF6\xF9\x9C\xEB\xA2\x30\x11\xE6\x97\x77\x00\x58\x05\xA9\x7D\xE2\x89\x27\xD0\xAF\x9F\x7D\x86\xD3\xF4\x7A\x3D\x72\x73\x73\x91\x9B\x9B\x0B\x9D\x4E\x67\x97\x6B\xDC\x8A\x92\x92\x12\xBB\x88\xB0\x56\xAB\xC5\xD1\xA3\x47\x6D\xBE\xAF\xDE\xBD\x7B\x77\xA9\x00\xEE\xB6\x32\x70\xE0\x40\x3C\xF6\xD8\x63\x56\xE9\x75\x75\x75\x88\x8B\x8B\xF3\x41\x2B\x91\x00\x19\x9D\x83\x89\x30\x7F\xDC\x0B\x0E\x7F\xCA\xE8\xE8\x68\xBC\xF8\xE2\x8B\x76\xBB\xA8\xD1\x68\xC4\x8D\x1B\x37\x04\x9D\x65\xD5\xE9\x74\x38\x75\xEA\x14\x8A\x8A\x8A\x78\xCB\xB3\xBA\xBA\x1A\x7F\xFE\xF9\x27\xAA\xAA\xAA\x6C\xBE\xB7\xC8\xC8\x48\x04\x06\x06\xF2\x64\x59\xD7\xE0\xE5\x97\x5F\xE6\x9C\xBF\xC8\xCA\xCA\x42\x64\x64\xE4\x64\x00\x77\x39\xDE\x2A\xF7\x84\x89\x30\x3F\xF8\xA0\xA9\x17\x6C\xC5\x3B\xEF\xBC\x03\x6F\x6F\xFB\xB9\x58\xEA\xF5\x7A\x5C\xBE\x7C\xD9\x2E\x13\x63\x1D\xE1\xD2\xA5\x4B\x38\x7C\xF8\x30\x6F\xF9\xE5\xE6\xE6\xE2\xEB\xAF\xBF\xB6\x39\x1F\xB1\x58\x8C\x98\x98\x18\xF8\xF8\xB0\x10\xB9\x1D\x41\xA5\x52\xE1\xAD\xB7\xB8\x3B\xBC\x7A\xBD\x1E\x22\x91\xE8\x1D\x30\xDF\x61\x5E\x60\x22\xCC\x0F\x2F\x81\x63\x9C\xEC\xDE\x7B\xEF\xC5\xDD\x77\xDB\x77\xB1\x91\x4E\xA7\x43\x6E\x6E\x2E\x1A\x1A\x1A\xEC\x7A\x9D\x5B\x21\x91\x48\x38\xF7\x2F\xEB\x2C\xD5\xD5\xD5\x28\x2B\x2B\xB3\x29\x0F\x91\x48\x04\x95\x4A\x85\xB9\x73\xE7\x22\x29\x29\x89\x27\xCB\xBA\x0E\x93\x27\x4F\xC6\x5D\x77\x59\x77\x78\xAF\x5D\xBB\x86\x94\x94\x94\x6E\x00\x96\x3B\xDE\x2A\xF7\x83\x89\xB0\xED\xF4\x07\xC7\x8C\xB1\x8F\x8F\x0F\x36\x6C\xD8\x60\xF7\x8B\xEB\xF5\x7A\x14\x15\x15\x09\xEE\xF4\x7D\xE3\xC6\x0D\x94\x94\x94\xF0\x96\x5F\x49\x49\x09\xCE\x9F\x3F\x6F\x53\x1E\x62\xB1\x18\xC1\xC1\xC1\x50\x2A\x95\x3C\x59\xD5\xF5\xD8\xB0\x61\x03\xE7\x97\xDC\x85\x0B\x17\xE0\xEB\xEB\xFB\x24\x80\x34\xC7\x5B\xE5\x5E\x30\x11\xB6\x0D\x09\x80\x0F\xC0\xF1\x1C\x5F\x7A\xE9\x25\x44\x45\xD9\x3F\x00\x95\x48\x24\x72\x0A\x91\xA9\xAB\xAB\xB3\xB9\xE7\x6A\xA2\xA0\xA0\x00\xBF\xFF\xFE\xBB\xCD\x43\x2C\x72\xB9\x1C\x83\x06\x0D\x82\x4A\xA5\xE2\xC5\xAE\xAE\x48\x4C\x4C\x0C\x96\x2F\xB7\xEE\xF0\xEA\xF5\x7A\x04\x04\x04\xB4\xEA\x13\xCF\x68\x3F\xEC\xE1\xD9\xC6\xE3\xE0\x58\x45\xD4\xBF\x7F\x7F\x3C\xFE\xF8\xE3\x0E\x33\xC2\x1E\xAE\x6F\x1D\xC5\x68\x34\xC2\x68\x34\xF2\x92\x57\x51\x51\x11\x2E\x5E\xBC\xC8\x4B\x5E\x71\x71\x71\x76\x1D\x93\xEF\x0A\x2C\x5A\xB4\x08\x69\x69\xD6\x1D\xDE\xFC\xFC\x7C\xC4\xC7\xC7\x67\x00\x78\xD4\xF1\x56\xB9\x0F\x4C\x84\x3B\x4F\x14\x80\x97\x2D\x13\x25\x12\x09\xDE\x7F\xFF\x7D\x87\x09\x23\x11\x41\xAB\xD5\x3A\xE4\x5A\x6D\xE1\xE5\xE5\xC5\x9B\x07\x42\x79\x79\x39\x6A\x6B\x6B\x6D\xCA\x43\x24\x12\xC1\xDF\xDF\x1F\xF1\xF1\xF1\x50\x28\x14\xBC\xD8\xD5\x55\x91\x4A\xA5\xD8\xB2\x65\x0B\xC4\x62\x6B\xB9\xB8\x7A\xF5\x2A\xE4\x72\xF9\x1A\x00\x8E\xD9\x1E\xC6\x0D\x61\x22\xDC\x79\xDE\x06\xC7\xEC\xF0\xE3\x8F\x3F\x8E\xFE\xFD\xFB\x3B\xCC\x08\x89\x44\xE2\x14\xEE\x57\x2A\x95\x8A\xB7\x6D\x9A\x8E\x1C\x39\x62\xF3\x78\xB0\x5C\x2E\x47\x66\x66\x26\xEE\xBD\xF7\x5E\x36\x1C\xC1\x03\x19\x19\x19\x78\xF4\x51\xEB\x0E\x6F\x6D\x6D\xAD\xC9\x77\xF8\x4D\x87\x1B\xE5\x26\x30\x11\xEE\x1C\x77\x03\xB0\xDA\xAE\xD6\xB4\x6F\x97\x23\x51\x28\x14\xC8\xC8\xC8\x80\xAF\xAF\xAF\x43\xAF\x6B\x89\x87\x87\x07\xFC\xFC\xFC\x78\xC9\xAB\xB0\xB0\xD0\xE6\x55\x72\xBE\xBE\xBE\xE8\xD5\xAB\x17\xAF\x1E\x1B\x5D\x9D\xD6\xF6\x43\xCC\xCA\xCA\x42\x44\x44\xC4\x14\x00\x6C\xCB\xF0\x4E\xC0\x44\xB8\xE3\x78\x03\xD8\xC8\x75\xE2\xED\xB7\xDF\x76\xB8\x3F\xAA\x58\x2C\x86\xAF\xAF\xAF\xE0\xE3\xC2\x62\xB1\x18\xFE\xFE\xFE\x36\xE7\xB3\x63\xC7\x0E\x5E\xFC\x8D\x7B\xF6\xEC\x89\x07\x1E\x78\x80\x89\x30\x8F\xF8\xFA\xFA\xE2\xCD\x37\xDF\xE4\x3C\xD7\x3C\x1F\xF0\x2E\x00\x4F\x07\x9A\xC4\xE8\xA2\xBC\x0E\x8E\xE0\x26\x77\xDF\x7D\xB7\x20\x01\x57\x1A\x1A\x1A\xE8\xC7\x1F\x7F\xA4\x98\x98\x18\x41\x82\xF7\x00\x4D\x7B\xB7\xCD\x9F\x3F\x9F\xCA\xCA\xCA\x3A\x6C\x7F\x75\x75\x35\xE5\xE5\xE5\xD1\x9F\x7F\xFE\x49\xEB\xD7\xAF\xA7\xDE\xBD\x7B\xF3\xB2\x1B\x88\x3D\xE3\x36\x77\x75\x26\x4C\x98\xC0\xF9\xCC\x9B\xE3\x0E\xBF\xC2\x5B\x4B\xEB\x02\x10\x8B\x27\xDC\x61\xFA\x81\x23\x4E\xB0\xB7\xB7\x37\x15\x16\x16\x0A\xDA\x30\xEE\xBB\xEF\x3E\x92\xCB\xE5\x82\x88\x70\x4A\x4A\x4A\xA7\xB6\x3B\xAA\xAE\xAE\xA6\xCD\x9B\x37\xD3\xA3\x8F\x3E\x4A\xB7\xDF\x7E\x3B\x6F\xF6\x78\x7A\x7A\xD2\xE2\xC5\x8B\xED\xF0\x94\x19\x44\x44\xF9\xF9\xF9\xE4\xE9\xE9\x69\xF5\xDC\xA5\x52\x29\xF9\xFA\xFA\xEA\x01\xA4\xF2\xD6\xE2\xDC\x1C\x62\x22\xDC\x21\x24\x00\x8E\x80\xA3\xD1\xBF\xFE\xFA\xEB\x42\xB7\x0B\xFA\xF4\xD3\x4F\xA9\x4F\x9F\x3E\x82\x88\xF0\xDC\xB9\x73\x29\x2F\x2F\xAF\x5D\x76\x1A\x8D\x46\xD2\xE9\x74\x54\x57\x57\x47\x9B\x37\x6F\xA6\x1E\x3D\x7A\xF0\x6E\x4F\x7A\x7A\xBA\x43\xB6\x5E\xEA\xCA\xBC\xF2\xCA\x2B\x9C\xCF\xBE\x79\x2F\xC0\x03\x60\x43\x9D\xED\x82\x98\x08\x77\x88\xC7\xC1\x51\xE9\xFA\xF5\xEB\x67\xD7\x38\xC1\xED\xA5\xAE\xAE\x8E\xE6\xCE\x9D\x2B\x88\x08\xFF\xEB\x5F\xFF\x22\x9D\x4E\xD7\x2E\x3B\xCB\xCA\xCA\xE8\x85\x17\x5E\xA0\xB4\xB4\x34\x0A\x09\x09\xB1\xCB\x56\x4C\x03\x06\x0C\x60\x22\x6C\x67\x74\x3A\x1D\xA5\xA6\xA6\xB6\x25\xC4\xCC\x77\xB8\x1D\x10\x13\xE1\x76\x13\x09\xE0\x06\x2C\x2A\x9B\x44\x22\xB1\x4B\x30\xF3\xCE\xF2\xD1\x47\x1F\x51\x64\x64\xA4\xC3\xC4\xD7\xD7\xD7\x97\x66\xCF\x9E\x4D\x17\x2F\x5E\xBC\xA5\x6D\xA7\x4F\x9F\xA6\x0D\x1B\x36\xD0\x94\x29\x53\x78\xD9\xAE\xA8\xAD\xE3\xB1\xC7\x1E\xA3\xD2\xD2\x52\x07\x3C\xF1\xAE\xCD\x81\x03\x07\x48\x2C\x16\x5B\x3D\x7F\x1F\x1F\x1F\x92\x4A\xA5\x35\x00\xC2\x79\x6A\x7F\x6E\x0B\x31\x11\x6E\x37\x3B\xC1\xD1\xD8\x1F\x7F\xFC\x71\xA1\xDB\x41\x0B\x8A\x8A\x8A\xE8\xEF\x7F\xFF\x3B\xC9\x64\x32\xBB\x0B\xB0\x48\x24\xA2\x59\xB3\x66\xD1\xF1\xE3\xC7\x6F\xD9\x0B\xDE\xB1\x63\x07\x4D\x9E\x3C\x99\xC2\xC3\xC3\x1D\xF2\x62\xF8\xE8\xA3\x8F\x1C\xF4\xC4\x19\x8F\x3E\xFA\x28\x67\x39\xA4\xA4\xA4\x10\x80\xED\x3C\xB5\x3F\xB7\x85\x98\x08\xB7\x8B\x89\xE0\xA8\x64\x91\x91\x91\x76\xDD\x65\xB8\xB3\x14\x14\x14\xD0\x03\x0F\x3C\x60\x57\xC1\x53\x28\x14\x74\xFB\xED\xB7\xD3\x81\x03\x07\x5A\xB5\xA3\xAC\xAC\x8C\x8E\x1C\x39\x42\xFF\xFA\xD7\xBF\x28\x24\x24\xC4\xEE\xE2\x6B\x3A\x32\x32\x32\xE8\x97\x5F\x7E\x71\xE0\x13\xEF\xDA\x54\x55\x55\xB5\x5A\xD7\x9A\xD3\xC7\xF1\xD4\x0E\xDD\x12\x62\x22\x7C\x4B\xBC\x01\x5C\x06\x47\x05\xDB\xB9\x73\xA7\xD0\xF5\xBF\x55\xEA\xEA\xEA\x68\xE9\xD2\xA5\x14\x1A\x1A\xCA\xF9\xB9\x68\xCB\x21\x95\x4A\x69\xE4\xC8\x91\x74\xE8\xD0\xA1\x16\xD7\x34\x4D\xB8\x69\xB5\x5A\x6A\x68\x68\xA0\x15\x2B\x56\x90\x52\xA9\x74\x98\xF8\x9A\x8E\x19\x33\x66\xD0\xD9\xB3\x67\x05\x7A\xF2\x5D\x93\xED\xDB\xB7\xB7\x25\xC2\x97\xC0\x7C\x87\x5B\x85\x98\x08\xDF\x92\x75\xE0\xA8\x5C\x13\x27\x4E\x14\xBA\xDE\xB7\x89\x5A\xAD\xA6\xCF\x3F\xFF\x9C\x56\xAE\x5C\x69\xF2\xDD\xE4\x55\xE4\x8E\x1F\x3F\x4E\x5A\xAD\xB6\xC5\x35\xEB\xEB\xEB\xE9\x9B\x6F\xBE\xA1\xE7\x9F\x7F\x9E\x52\x53\x53\xC9\xCF\xCF\xCF\xE1\x02\x0C\x80\xBE\xF8\xE2\x0B\x2B\xDB\x18\xF6\x67\xDC\xB8\x71\x9C\xE5\xD1\x3C\x2C\xB1\x86\xA7\xF6\xE8\x76\x10\x13\xE1\x36\x49\x03\xA0\x87\x45\xA5\xF2\xF6\xF6\xA6\x82\x82\x02\xA1\xEB\x7C\x9B\xE8\xF5\x7A\x2A\x2F\x2F\xA7\x92\x92\x12\xDA\xBE\x7D\x3B\x8D\x1A\x35\xCA\x66\x71\x1B\x3C\x78\x30\x6D\xD9\xB2\x85\xB2\xB3\xB3\xAD\xAE\x77\xF1\xE2\x45\x5A\xB4\x68\x11\xF5\xEE\xDD\xDB\xA1\x43\x0F\xE6\x87\x48\x24\xA2\xC0\xC0\x40\xA7\x9A\x28\xED\x4A\xE4\xE5\xE5\x71\xFA\x0E\xCB\x64\x32\x52\xA9\x54\x3A\x00\xBD\x79\x6C\x9B\x6E\x03\x31\x11\x6E\x15\x31\x80\x83\xE0\x68\xEC\xEB\xD6\xAD\x13\xBA\xBE\x77\x08\x9D\x4E\x47\xBF\xFF\xFE\x3B\x2D\x5F\xBE\x9C\x46\x8E\x1C\x49\x49\x49\x49\xED\x16\xB6\xE0\xE0\x60\xEA\xDB\xB7\x2F\xCD\x9C\x39\x93\x7E\xFA\xE9\x27\xAB\xBC\xF3\xF3\xF3\x69\xEB\xD6\xAD\x34\x6D\xDA\x34\xF2\xF0\xF0\x10\x44\x7C\x4D\x87\x5C\x2E\xA7\x09\x13\x26\x50\x56\x56\x96\x00\x4F\x99\x41\x44\xB4\x66\xCD\x1A\xCE\xB2\x69\x76\x59\xDB\x0F\x40\xC4\x67\x23\x75\x07\x88\x88\x3D\x94\x56\x58\x00\x8E\x3D\xE3\xD2\xD2\xD2\x70\xF4\xE8\x51\x97\x8D\x47\x70\xF0\xE0\x41\x64\x67\x67\x63\xF7\xEE\xDD\xC8\xCE\xCE\xC6\x8D\x1B\x37\x00\xFC\xF7\x6D\x2C\x12\x89\x6E\xFE\xB7\x6F\xDF\xBE\x48\x49\x49\x41\x9F\x3E\x7D\x90\x91\x91\xD1\x22\x40\x7D\x71\x71\x31\xCE\x9D\x3B\x87\x7F\xFF\xFB\xDF\xD8\xB2\x65\x0B\x2F\x5B\xD2\xDB\x8A\x97\x97\x17\x16\x2E\x5C\x88\x85\x0B\x17\x22\x2C\x2C\x4C\x68\x73\xBA\x24\x3A\x9D\x0E\xFD\xFB\xF7\xC7\xD9\xB3\x67\xAD\xCE\xC5\xC5\xC5\x21\x2F\x2F\xEF\x11\x00\x9B\x1D\x6F\x99\xF3\xC2\x44\x98\x9B\x08\x00\xD9\x68\xDA\xBC\xF3\x26\x62\xB1\x18\x07\x0E\x1C\xC0\xA0\x41\x83\x84\xB1\x8A\x67\x6A\x6A\x6A\x70\xE8\xD0\x21\x00\x80\xC1\x60\x00\x80\x9B\xF1\x62\xA5\x52\x29\x86\x0F\x1F\x0E\xB9\x5C\x7E\xF3\xF7\x06\x83\x01\x3A\x9D\x0E\x45\x45\x45\x78\xED\xB5\xD7\xB0\x65\xCB\x16\xC7\x1B\xDD\x06\xDE\xDE\xDE\x78\xF1\xC5\x17\x31\x7B\xF6\x6C\xA7\x08\xED\xD9\x55\x39\x70\xE0\x00\x86\x0D\x1B\x66\xF5\x99\xAD\x52\xA9\xA0\x56\xAB\x6B\x74\x3A\x5D\x22\x80\x6B\xC2\x58\xE7\x7C\x58\x3E\x27\x46\x13\x9F\x81\xE3\x93\x6A\xC1\x82\x05\x82\x7E\xEA\xD9\x03\x8D\x46\x43\x1A\x8D\x86\xD4\x6A\x35\xA9\xD5\xEA\x9B\xFF\xD6\x68\x34\x56\xBF\xDD\xBB\x77\x2F\xCD\x9E\x3D\x9B\x62\x63\x63\xC9\xDB\xDB\x5B\xD0\xA1\x07\xAE\x43\xA5\x52\x51\x41\x41\x01\x19\x0C\x06\x01\x9E\x24\xC3\x9C\x87\x1F\x7E\x98\xB3\x8C\x9A\x27\xE9\xB6\xD9\xA1\xCD\xBA\x2C\xC4\x44\xD8\x8A\x09\xE0\xA8\x3C\x11\x11\x11\x54\x5D\x5D\x2D\x74\xDD\x76\x38\x75\x75\x75\xF4\xAF\x7F\xFD\x8B\x66\xCC\x98\x41\xFD\xFB\xF7\x27\x2F\x2F\x2F\xC1\xC5\x96\xEB\x50\x28\x14\xB4\x60\xC1\x02\xCE\x97\x07\xC3\xF1\x5C\xBF\x7E\xBD\xD5\x55\x91\xCD\x6E\x6B\x77\xF0\xDF\x74\x5D\x13\x22\x82\x6B\x0E\x6E\xDA\x07\x4F\x34\xC5\x43\xB5\x62\xFD\xFA\xF5\x82\x07\x4D\x77\x24\xF9\xF9\xF9\xB8\x72\xE5\x0A\x76\xED\xDA\x85\x9D\x3B\x77\x22\x2B\x2B\x4B\x68\x93\x5A\x25\x38\x38\x18\x63\xC6\x8C\xC1\xD8\xB1\x63\x85\x36\x85\xD1\x8C\xBF\xBF\x3F\xDE\x78\xE3\x0D\xCC\x98\x31\xA3\xB5\x9F\x6C\x02\xD0\x0B\x80\x6D\x3B\xB9\x32\xDC\x8E\x57\xC0\xF1\xE6\x9E\x30\x61\x82\xD0\x1D\x0B\x87\xA1\xD7\xEB\xE9\xC8\x91\x23\xB4\x60\xC1\x02\x1A\x31\x62\x84\x5D\x82\xEB\xF0\x75\xF8\xFA\xFA\xD2\x80\x01\x03\x68\xE5\xCA\x95\x74\xF8\xF0\x61\x3A\x73\xE6\x8C\x53\x04\x52\x62\xFC\x97\x3B\xEE\xB8\xA3\xAD\x61\x89\x55\xBC\xB7\x60\x17\x84\xD8\x70\xC4\x4D\x52\x01\xE8\x60\x51\x59\x3C\x3D\x3D\x29\x3F\x3F\x5F\xE8\xBA\x6C\x77\x4C\xA1\x25\xF7\xED\xDB\xD7\x6A\xC3\x71\x86\x43\x24\x12\x91\x42\xA1\xA0\xE0\xE0\x60\x9A\x37\x6F\x1E\x5D\xB9\x72\x45\xE8\x47\xC7\x68\x83\x8B\x17\x2F\x72\xAE\x9A\x94\xC9\x64\xE4\xE3\xE3\xA3\x03\x90\xC2\x7F\x53\x76\x2D\x88\x89\x30\x80\x26\x9F\xE0\x03\xE0\x68\xF4\xAF\xBC\xF2\x8A\xD0\xF5\xD8\x21\xFC\xF6\xDB\x6F\x74\xFF\xFD\xF7\x53\x68\x68\x28\x29\x14\x0A\xC1\xC5\xB6\xB5\x43\x2E\x97\xD3\xFF\xFD\xDF\xFF\x51\x51\x51\x11\x55\x56\x56\xB2\x49\x38\x17\x60\xD5\xAA\x55\x9C\x65\xD9\xEC\x3B\xBC\x17\x5D\xDC\x77\x98\x98\x08\x03\x00\x1E\x01\x47\x25\x49\x4D\x4D\xA5\xC6\xC6\x46\xA1\xEB\xB0\xDD\x30\x18\x0C\xF4\xC9\x27\x9F\xD0\x13\x4F\x3C\x41\x03\x07\x0E\x74\x6A\xF1\x95\x48\x24\x94\x9C\x9C\x4C\x2F\xBF\xFC\xB2\xD3\xAF\x56\x64\xB4\xA4\xB1\xB1\xD1\x34\xFC\xD0\x9A\x10\xCF\xE3\xBD\x45\xBB\x10\xC4\xFC\x84\x11\x06\xE0\x02\x80\x16\x7B\xA2\x8B\xC5\x62\xEC\xDB\xB7\x0F\x43\x86\x0C\x11\xC6\x2A\x3B\x52\x5A\x5A\x8A\xFD\xFB\xF7\xE3\xE0\xC1\x83\xF8\xF1\xC7\x1F\x71\xEE\xDC\x39\xA1\x4D\x6A\x15\x2F\x2F\x2F\x64\x64\x64\x60\xC2\x84\x09\x88\x8B\x8B\xC3\xED\xB7\xDF\xCE\xCB\x66\xA2\x0C\xC7\xB2\x6F\xDF\x3E\xDC\x76\xDB\x6D\x56\xBD\x3E\x5F\x5F\x5F\xD4\xD7\xD7\x57\xEB\xF5\xFA\x44\x00\x65\xC2\x58\x27\x2C\x96\xCF\xA4\x2B\xB2\x1D\x1C\x6F\xE8\x47\x1E\x79\x44\xE0\xFE\x03\xBF\x18\x0C\x06\xCA\xCD\xCD\xA5\xFD\xFB\xF7\xD3\x92\x25\x4B\x1C\x1A\xF8\xDD\x96\x23\x32\x32\x92\x36\x6E\xDC\x28\xF4\xE3\x63\xF0\xC0\xBC\x79\xF3\x38\xCB\xB8\x39\xC0\xD4\xC7\xFC\x36\x6B\xD7\x81\xBA\xB8\x08\x8F\x03\x47\xA5\x08\x0B\x0B\xA3\xAA\xAA\x2A\xA1\xEB\x2C\x2F\xE8\x74\x3A\xAA\xAF\xAF\xA7\x23\x47\x8E\xD0\xD4\xA9\x53\xC9\xD7\xD7\x57\x70\x61\xED\xC8\x11\x1A\x1A\x4A\x2B\x57\xAE\x64\xE3\xBF\x6E\x40\x65\x65\x65\xAB\xC1\x9D\xC2\xC2\xC2\x08\xC0\x68\x3E\x1B\xB7\xAB\x40\x44\x5D\x76\x33\x3E\x0F\xB4\xE1\x13\xEC\xE7\xE7\xE7\x58\x6B\xEC\xC4\xFE\xFD\xFB\xF1\xDC\x73\xCF\xE1\xA1\x87\x1E\xC2\xB7\xDF\x7E\x7B\x33\x56\x84\xAB\xD0\xD8\xD8\x88\x0B\x17\x2E\xE0\x8B\x2F\xBE\x40\x45\x45\x85\xD0\xE6\x30\x6C\x20\x20\x20\x00\xAF\xBF\xFE\x3A\xE7\xB9\xE6\xE5\xF2\xEF\x01\x50\x3A\xD2\x26\x86\xB0\xAC\x01\xC7\x1B\x79\xDC\xB8\x71\x42\x77\x18\x78\xE3\x83\x0F\x3E\xA0\xCC\xCC\x4C\xF2\xF7\xF7\x17\xBC\x47\xDB\xD9\x43\x2A\x95\x52\x44\x44\x04\x2D\x5E\xBC\x98\x2A\x2A\x2A\x88\x88\xA8\xA1\xA1\x41\xE0\x27\xCB\xB0\x85\xD1\xA3\x47\x73\x96\x75\x72\x72\x32\x01\x78\x89\xB7\x16\xEE\x22\x50\x17\x9D\x98\xEB\x0D\xE0\x04\xD0\x72\xB5\xA0\x87\x87\x07\xCE\x9E\x3D\x8B\xD8\xD8\x58\x61\xAC\xB2\x91\x8A\x8A\x0A\x14\x15\x15\x21\x27\x27\x07\xC7\x8F\x1F\xC7\x97\x5F\x7E\x89\x8B\x17\x2F\x0A\x6D\x16\x2F\x8C\x1D\x3B\x16\x0B\x17\x2E\xC4\xB0\x61\xC3\xE0\xE1\xE1\x01\x85\x42\x21\xB4\x49\x8C\x4E\x92\x9B\x9B\x8B\xD4\xD4\x54\x68\x34\x2D\x17\xCB\xC9\xE5\x72\x28\x14\x8A\xC6\xDA\xDA\xDA\xBE\x00\x9C\x77\x89\x26\xCF\x50\x17\x1C\x13\x16\x01\xD8\x07\x8E\x37\xF1\x9A\x35\x6B\x84\xEE\x24\x74\x9A\x82\x82\x02\x5A\xB5\x6A\x15\xDD\x77\xDF\x7D\x14\x15\x15\x25\x78\x0F\x96\xCF\x43\x2C\x16\x53\x50\x50\x10\x3D\xF4\xD0\x43\x6C\xDB\x22\x37\xE1\xA5\x97\x5E\xE2\x2C\xEB\xF8\xF8\x78\x02\xB0\x07\x5D\xC8\x77\x98\xBA\xA0\x08\xCF\x07\x47\xE1\xF7\xEE\xDD\xDB\xE5\x7C\x82\x75\x3A\x1D\x55\x57\x57\xD3\xC5\x8B\x17\x69\xFE\xFC\xF9\x82\x07\x55\xB7\xF7\x31\x7C\xF8\x70\xFA\xF5\xD7\x5F\x85\x7E\xEC\x0C\x1E\xD0\x68\x34\xA6\xE1\x07\xAB\xA3\x47\x8F\x1E\x04\x60\xAE\xAD\x0D\xDD\x55\xA0\x2E\x26\xC2\xA1\x00\xAA\x61\x51\xE8\x22\x91\x88\xF6\xED\xDB\x27\x74\xBD\xEC\x30\x47\x8E\x1C\xA1\xBB\xEE\xBA\x8B\x82\x82\x82\xC8\xC3\xC3\x83\x44\x22\x91\xE0\x42\x69\xCF\x43\x26\x93\xB9\xDC\xAE\x26\x8C\xD6\xD9\xB3\x67\x0F\x67\x9D\xF5\xF5\xF5\x25\xA9\x54\x7A\x1D\x40\xB0\xAD\x0D\xDE\x15\xA0\x2E\x26\xC2\xDB\xC0\xD1\xB8\xE7\xCF\x9F\x2F\x74\x7D\xEC\x10\x9F\x7F\xFE\x39\xCD\x98\x31\x83\xFA\xF5\xEB\xE7\xD4\xAB\xDC\xEC\x71\x0C\x1F\x3E\x9C\x7E\xFB\xED\x37\xA1\x8B\x80\xC1\x13\x73\xE7\xCE\xE5\x2C\xE7\x66\xDF\xE1\xAD\xB6\x34\x76\x57\x81\xBA\x90\x08\x8F\x05\x47\x61\x87\x86\x86\xD2\xF5\xEB\xD7\x85\xAE\x8B\xED\xA2\xBA\xBA\x9A\x96\x2D\x5B\x46\x7D\xFB\xF6\x15\x5C\x0C\x85\x3A\x94\x4A\x25\x3D\xFA\xE8\xA3\x42\x17\x05\x83\x27\x2A\x2A\x2A\x28\x38\x38\xD8\xAA\x9C\x45\x22\x11\x85\x86\x86\x1A\x01\x8C\xEC\x7C\x93\x77\x0D\xA8\x8B\x88\xB0\x12\x40\x1E\x38\x1A\xF5\xB6\x6D\xDB\x84\xAE\x87\xB7\x24\x3F\x3F\x9F\x7E\xFE\xF9\x67\x5A\xB1\x62\x85\xE0\x22\xE8\x0C\x47\x6A\x6A\x2A\x5D\xBC\x78\x91\x85\xAD\x74\x13\xB6\x6E\xDD\xCA\x59\xCE\xCD\xAB\x3A\x73\x00\xB8\xB5\x2B\x0C\x75\x11\x11\x5E\x05\x8E\x42\x1E\x3B\x76\xAC\xD0\xF5\xAF\x55\xF4\x7A\x3D\x55\x56\x56\xD2\xD5\xAB\x57\xE9\xA1\x87\x1E\x12\x5C\xF8\x9C\xE9\x50\xA9\x54\x34\x77\xEE\x5C\xAA\xAD\xAD\x15\xBA\x98\x18\x3C\x60\x34\x1A\x69\xE4\xC8\x91\x9C\x65\xDD\x3C\x79\xB7\xA2\x13\x6D\xDE\x65\xA0\x2E\x20\xC2\x29\x00\x1A\x61\x51\xB8\x4A\xA5\x92\x2E\x5E\xBC\x28\x74\xFD\x6B\x95\xBC\xBC\x3C\x1A\x37\x6E\x1C\x85\x86\x86\x72\xC6\x63\xED\xCA\x87\x48\x24\xA2\xC8\xC8\x48\xAA\xAF\xAF\x17\xBA\x98\x18\x3C\x71\xE1\xC2\x05\xCE\xF9\x0D\xB9\x5C\x4E\xDE\xDE\xDE\x5A\x00\x89\x9D\x6A\xFD\x2E\x00\xB9\xB9\x08\x8B\x00\xFC\x01\x8E\x86\xBC\x6A\xD5\x2A\xA1\xEB\x1D\x27\xBF\xFD\xF6\x1B\xCD\x9A\x35\x8B\xD2\xD3\xD3\x49\x26\x93\x09\x2E\x78\xCE\x7A\x48\xA5\x52\x7A\xF8\xE1\x87\xE9\xDA\xB5\x6B\x42\x17\x59\xAB\xFC\xF0\xC3\x0F\xB4\x63\xC7\x0E\x7A\xF4\xD1\x47\x69\xCC\x98\x31\x34\x66\xCC\x18\x1A\x37\x6E\x1C\x3D\xF7\xDC\x73\x54\x59\x59\x29\xB4\x79\x4E\x47\x6B\xC3\x6D\xCD\xBE\xC3\xBF\xC1\x4D\x7D\x87\xC9\xCD\x57\xCC\xCD\x03\xF0\xBE\x65\x62\x4A\x4A\x0A\x4E\x9C\x38\xD1\x62\x3B\x77\xA1\xF9\xE6\x9B\x6F\x50\x58\x58\x88\x2F\xBF\xFC\x12\x7B\xF6\xEC\x11\xDA\x1C\x97\x40\x2E\x97\xE3\xF9\xE7\x9F\xC7\xEC\xD9\xB3\x11\x13\x13\x23\xB4\x39\x37\x69\x6C\x6C\xC4\xF6\xED\xDB\xB1\x6D\xDB\x36\x94\x95\x95\xE1\xCC\x99\x33\x30\x1A\x8D\x37\xCF\xFB\xF8\xF8\xE0\x9E\x7B\xEE\x41\x4C\x4C\x0C\xBC\xBC\xBC\xD0\xAB\x57\x2F\xC8\xE5\x72\x8C\x1E\x3D\x1A\x32\x99\x4C\x40\xCB\x85\x45\xAB\xD5\x22\x2D\x2D\x0D\x17\x2E\x5C\xB0\x3A\xD7\xA3\x47\x0F\xE4\xE7\xE7\xFF\x2F\xDC\xD0\x63\xC2\x9D\x45\x38\x18\x4D\x71\x82\x5B\x04\x9F\x15\x89\x44\xF8\xFD\xF7\xDF\x31\x7C\xF8\x70\x61\xAC\x32\xA3\xBA\xBA\x1A\x05\x05\x05\x38\x78\xF0\x20\xDE\x79\xE7\x1D\x64\x65\x65\xB5\x68\xAC\x8C\x5B\x13\x17\x17\x87\x0D\x1B\x36\x60\xFC\xF8\xF1\x82\xDA\x91\x9B\x9B\x0B\x9D\x4E\x87\xF2\xF2\x72\x1C\x3D\x7A\x14\x5B\xB6\x6C\x41\x6E\x6E\x6E\xBB\x3E\x35\x7B\xF7\xEE\x0D\xA5\x52\x89\x69\xD3\xA6\xA1\x57\xAF\x5E\x50\xA9\x54\x08\x09\x09\x41\xCF\x9E\x3D\x1D\x60\xB9\x73\xB1\x67\xCF\x1E\x8C\x1A\x35\xCA\xEA\xB9\xF9\xF9\xF9\xA1\xB6\xB6\xB6\xD2\x60\x30\x24\x02\xA8\x14\xC6\x3A\xFB\xD0\x9E\x3A\xE2\xAA\x7C\x0C\x8E\x4F\x9B\x79\xF3\xE6\x09\xFA\xC9\x65\xCE\xEE\xDD\xBB\x69\xCC\x98\x31\x82\x7F\xDA\xBB\xF2\xE1\xEF\xEF\x4F\x9B\x36\x6D\x22\xB5\x5A\xED\xF0\xF2\xD3\x6A\xB5\x54\x55\x55\x45\xE7\xCF\x9F\xA7\x69\xD3\xA6\xD1\xC4\x89\x13\x79\x09\x96\x14\x15\x15\x45\x33\x66\xCC\xA0\x33\x67\xCE\x50\x69\x69\x29\x55\x54\x54\x50\x6D\x6D\x2D\xD5\xD6\xD6\x52\x5D\x5D\x9D\xDB\x87\xF4\x9C\x3D\x7B\x36\xE7\x73\x69\xF6\x1D\xFE\xB0\xB5\x06\xEF\xAA\x90\x9B\xF6\x84\x47\x03\xD8\x6D\x99\x18\x1C\x1C\x8C\xEC\xEC\x6C\x04\x04\x04\x08\x60\x92\x35\x9F\x7E\xFA\x29\x56\xAD\x5A\x85\xB3\x67\xCF\x0A\x6D\x8A\xCB\x22\x12\x89\x30\x68\xD0\x20\x2C\x5D\xBA\x14\x77\xDD\x75\x97\x43\xAF\xFD\xDB\x6F\xBF\xE1\x93\x4F\x3E\x41\x41\x41\x01\xF6\xEE\xDD\x0B\xA3\xD1\x08\xBD\x5E\x6F\x73\xCF\x46\x2C\x16\x43\x2A\x95\xC2\xC3\xC3\x03\x32\x99\x0C\x19\x19\x19\xC8\xCC\xCC\x84\x44\x22\x81\x52\xA9\xC4\xD4\xA9\x53\x11\x11\x11\xC1\xD3\x5D\x38\x1F\x15\x15\x15\x48\x4A\x4A\x42\x65\x65\xCB\x0E\xAF\x48\x24\x42\x70\x70\x30\x95\x95\x95\x8D\x04\xF0\xBB\x30\xD6\xF1\x8F\xAD\xF5\xC5\x19\x51\x02\xC8\x05\xC7\x9B\xF4\xE3\x8F\x3F\x16\xF8\x1D\xDF\x92\x45\x8B\x16\x31\xCF\x07\x1E\x0E\x85\x42\x41\x2F\xBC\xF0\x82\xC3\xCA\x6D\xEB\xD6\xAD\x74\xCF\x3D\xF7\x50\x72\x72\x32\xA9\x54\x2A\x92\xCB\xE5\x76\xBF\xBF\xB0\xB0\x30\x0A\x0F\x0F\xA7\xC8\xC8\x48\x9A\x39\x73\x26\xAD\x59\xB3\x86\x76\xEF\xDE\xED\xB0\x7B\x76\x34\x1F\x7E\xF8\x61\xAB\x5F\x09\x00\xB2\xE1\x46\xBE\xC3\xE4\x86\x3D\xE1\x95\x00\x96\x59\x26\x8E\x1E\x3D\x1A\xBB\x77\x5B\x75\x8E\x05\x41\xA7\xD3\x61\xEF\xDE\xBD\x58\xBC\x78\x31\x4E\x9E\x3C\x29\xB4\x39\x6E\x41\x66\x66\x26\x5E\x7D\xF5\x55\x0C\x1D\x3A\x94\xF7\xBC\xCF\x9E\x3D\x8B\x9C\x9C\x1C\x94\x96\x96\x22\x27\x27\x07\x3F\xFF\xFC\x33\xB2\xB2\x84\x8B\xB4\x28\x97\xCB\x11\x10\x10\x70\x73\xCF\xBD\xA8\xA8\x28\x04\x06\x06\xE2\xF6\xDB\x6F\x47\x70\xB0\x7B\x84\x5B\x20\x22\x8C\x1C\x39\x12\xBF\xFF\x6E\xDD\xE1\x4D\x4A\x4A\x42\x76\x76\xF6\x72\x34\xB5\x75\x97\x87\xDC\xAC\x27\x9C\x0C\x40\x0B\x8B\xB7\xA7\x52\xA9\xA4\x9C\x9C\x1C\x81\xDF\xED\xFF\xA5\xAE\xAE\x8E\x96\x2C\x59\x42\x01\x01\x01\x82\xF7\x22\xC5\x62\x31\x85\x87\x87\x53\x68\x68\xA8\xDD\x7B\x74\xF6\x3C\x14\x0A\x05\x4D\x99\x32\x85\x4E\x9E\x3C\x49\x1A\x8D\xC6\xE6\x32\xD2\xEB\xF5\x74\xE2\xC4\x09\xFA\xED\xB7\xDF\x68\xFA\xF4\xE9\x94\x98\x98\xE8\xB4\xCF\xC7\xD3\xD3\x93\xE2\xE2\xE2\xE8\x99\x67\x9E\xA1\xEF\xBE\xFB\x8E\x7E\xFB\xED\x37\x3A\x72\xE4\x88\xCB\xAF\x28\xCC\xCA\xCA\xE2\xF4\x1D\x56\x28\x14\xE4\xE9\xE9\xA9\x01\x90\x00\x37\x80\xDC\x48\x84\x45\x68\x8A\x43\x6A\x55\x68\x2B\x57\xAE\x14\xBA\x3E\xB5\xA0\xA1\xA1\x81\x9E\x7D\xF6\x59\x0A\x0A\x0A\x12\xAC\xE1\x4A\x24\x12\xF2\xF0\xF0\xA0\xE4\xE4\x64\x5A\xB9\x72\x25\x2D\x5B\xB6\xAC\xD5\x6D\xC9\x5D\xE5\x08\x0F\x0F\xA7\xA7\x9E\x7A\x8A\x8A\x8A\x8A\x3A\x5D\x36\xF5\xF5\xF5\x74\xF5\xEA\x55\xFA\xE1\x87\x1F\xE8\xF6\xDB\x6F\x17\xB4\x8C\x3A\x7B\x04\x07\x07\x53\x7A\x7A\x3A\x7D\xFF\xFD\xF7\x54\x54\x54\x44\xC5\xC5\xC5\x54\x5E\x5E\x4E\xD7\xAF\x5F\x77\xB9\x49\xBD\x17\x5E\x78\x81\xF3\x1E\x13\x12\x12\x08\x4D\xF3\x3E\x2E\xFF\x25\x4F\x6E\x24\xC2\x73\xC0\x51\x58\xC9\xC9\xC9\xBC\xF4\x8C\xF8\xA4\xA1\xA1\x81\x32\x33\x33\x05\x0D\x3D\xD9\xB3\x67\x4F\xBA\xFF\xFE\xFB\x69\xDD\xBA\x75\xD4\xD0\xD0\x40\x1A\x8D\x86\xE6\xCF\x9F\x2F\xB8\x80\xD8\x72\x78\x78\x78\xD0\xEC\xD9\xB3\xE9\xD2\xA5\x4B\x9D\x2E\x9B\x8F\x3E\xFA\x88\x32\x32\x32\xC8\xD3\xD3\x93\xA4\x52\xA9\x4B\x86\x07\x15\x8B\xC5\x24\x91\x48\xC8\xD3\xD3\x93\x7C\x7C\x7C\x28\x2A\x2A\x8A\x26\x4F\x9E\x4C\x8F\x3E\xFA\x28\x5D\xBE\x7C\x99\xC7\x9A\x6C\x7F\xD4\x6A\xB5\x49\x70\xAD\x8E\xEE\xDD\xBB\x13\x80\x99\x70\x71\x88\xA8\xE5\x16\x3F\x2E\x4A\x10\x80\xD7\x2C\x13\x45\x22\x11\x36\x6D\xDA\xE4\x54\x5B\xE1\x94\x95\x95\x61\xDB\xB6\x6D\xC8\xCE\xCE\x16\xE4\x0D\xD8\xBF\x7F\x7F\x84\x86\x86\x62\xC6\x8C\x19\x18\x3C\x78\x30\x54\x2A\x15\x3C\x3C\x3C\x00\x00\x19\x19\x19\xF8\xE6\x9B\x6F\x70\xED\xDA\x35\x87\xDB\xC5\x07\x1A\x8D\x06\xFF\xF9\xCF\x7F\xF0\xE4\x93\x4F\xB6\xFB\x6F\xB2\xB3\xB3\xF1\xCD\x37\xDF\xA0\xA2\xA2\x02\xC7\x8E\x1D\x43\x41\x41\x01\x2E\x5F\xBE\xEC\xD2\xFE\xDA\x26\xDB\x1B\x1A\x1A\x00\x00\xB5\xB5\xB5\xB8\x7E\xFD\x3A\xE4\x72\x39\x0E\x1D\x3A\x84\x98\x98\x18\xA4\xA6\xA6\x22\x3A\x3A\x1A\x6A\xB5\x1A\xF3\xE6\xCD\x83\x52\xE9\x9C\xFB\x6B\x2A\x95\x4A\xBC\xFB\xEE\xBB\x18\x3B\x76\xAC\x55\x7B\xA9\xA9\xA9\x81\x44\x22\x79\xD3\x60\x30\xFC\x00\x37\xF3\x1D\x76\x45\xB6\x82\xE3\x4D\x39\x67\xCE\x1C\x81\xDF\xE3\xD6\xE4\xE5\xE5\xD1\xCC\x99\x33\x1D\x3E\xBE\x38\x66\xCC\x18\x7A\xEB\xAD\xB7\xE8\xE7\x9F\x7F\xA6\xC3\x87\x0F\x73\xFA\xD5\x16\x16\x16\xD2\x0B\x2F\xBC\xE0\xF2\x31\x8A\x97\x2E\x5D\x7A\xCB\x21\x89\xBD\x7B\xF7\xD2\x87\x1F\x7E\x48\xFF\xF3\x3F\xFF\x43\xE1\xE1\xE1\xE4\xED\xED\x2D\xB8\xDD\x8E\x3C\x02\x03\x03\x29\x3E\x3E\x9E\x62\x62\x62\x68\xF6\xEC\xD9\xF4\xDE\x7B\xEF\xD1\x0F\x3F\xFC\x40\x07\x0F\x1E\xB4\x57\xD5\xB7\x89\x99\x33\x67\x72\xDE\x47\xB3\xEF\xF0\x07\x70\x61\xC8\x0D\x86\x23\x46\x02\x30\xC2\xA2\x70\x82\x82\x82\x6E\xEE\xCE\xEB\x4C\x64\x67\x67\xD3\x3D\xF7\xDC\xE3\x10\xA1\x93\xCB\xE5\x34\x66\xCC\x18\x9A\x3F\x7F\x3E\xED\xDF\xBF\xBF\x5D\xF6\x5D\xB9\x72\x85\x1E\x7E\xF8\x61\xC1\x45\xC2\x96\x23\x2A\x2A\x8A\x3E\xFF\xFC\x73\xAB\x7B\xAB\xA9\xA9\xA1\xFD\xFB\xF7\xD3\x67\x9F\x7D\x46\x63\xC7\x8E\xA5\xB0\xB0\x30\xC1\x6D\x75\x96\xC3\xCF\xCF\x8F\xD2\xD3\xD3\x69\xC2\x84\x09\xF4\xAF\x7F\xFD\x8B\xF6\xEC\xD9\x43\x27\x4F\x9E\xA4\xF2\xF2\x72\xBE\x9B\x40\xA7\x28\x2B\x2B\xA3\xC0\xC0\x40\x2B\xBB\x45\x22\x11\x05\x07\x07\x1B\x01\x08\xBF\x04\xB6\x93\x90\x8B\x8B\xB0\x02\x4D\x4B\x93\xAD\x0A\x67\xEB\xD6\xAD\x42\xD7\x1B\x4E\x8E\x1E\x3D\x4A\x89\x89\x89\x24\x91\x48\xEC\xD6\xA0\xBC\xBC\xBC\x28\x2E\x2E\x8E\x26\x4D\x9A\xD4\xA9\x40\x31\x45\x45\x45\x2E\xEF\xBF\xBC\x64\xC9\x12\xAA\xAE\xAE\xA6\xAA\xAA\x2A\xAA\xA8\xA8\xA0\xE2\xE2\x62\xDA\xB2\x65\x0B\xA5\xA4\xA4\x90\x58\x2C\x16\xDC\x3E\x67\x3F\xBA\x75\xEB\x46\x63\xC7\x8E\xA5\x57\x5F\x7D\x95\x0A\x0B\x0B\xA9\xB8\xB8\x98\x2A\x2A\x2A\xA8\xAA\xAA\x8A\x1A\x1A\x1A\x5A\xD4\x17\xA3\xD1\xE8\x10\x4F\x8C\x0F\x3E\xF8\x80\xD3\xD6\xE8\xE8\x68\x02\x70\x1E\x80\xF3\x04\x83\xE9\x00\xE4\xE2\x22\xBC\x02\x1C\x85\x32\x72\xE4\x48\x32\x1A\x8D\x76\xAF\x14\x9D\x61\xCF\x9E\x3D\x76\x17\x81\xD9\xB3\x67\x53\x5D\x5D\x1D\x35\x34\x34\x74\xEA\x39\x5C\xBE\x7C\x99\x32\x33\x33\x5D\x3A\x8A\xDB\xA0\x41\x83\xE8\xF9\xE7\x9F\xA7\xA7\x9F\x7E\x9A\x1E\x7C\xF0\x41\x4A\x48\x48\x20\xA5\x52\xC9\x04\xB8\x9D\x87\x58\x2C\x26\xA9\x54\x4A\x4A\xA5\x92\x82\x83\x83\x29\x2E\x2E\x8E\xE6\xCC\x99\x43\xCF\x3C\xF3\x0C\xED\xDC\xB9\xB3\x45\x7D\xA9\xAD\xAD\x75\x48\x34\x3B\xA3\xD1\x48\xC3\x87\x0F\xE7\xB4\x37\x29\x29\x89\x00\x3C\x0F\x17\x84\x5C\x58\x84\x13\xC1\xE1\x13\xAC\x50\x28\x28\x3B\x3B\xDB\xEE\x15\xA2\x33\x9C\x3A\x75\xAA\xD5\xB1\x2D\x3E\x8E\x9E\x3D\x7B\xD2\x5B\x6F\xBD\x65\xF3\x0C\xB8\x56\xAB\xA5\xAC\xAC\x2C\x53\x0F\xC3\x25\x0F\x93\x78\x04\x06\x06\x92\x4A\xA5\x12\xDC\x1E\x77\x38\x54\x2A\x15\x05\x06\x06\x52\x42\x42\x02\xCD\x9A\x35\x8B\x36\x6C\xD8\x40\x3B\x77\xEE\xA4\xE2\xE2\x62\x9E\x5A\xC8\xAD\x39\x77\xEE\x1C\xE7\x7C\x8A\x99\xEF\xB0\xCB\x45\x3D\x22\x17\x15\x61\x11\x80\x5F\xC1\x51\x51\x56\xAC\x58\xE1\xB0\x0A\xD1\x51\x7E\xFA\xE9\x27\xEA\xDD\xBB\x37\xEF\x8D\x63\xC4\x88\x11\xF4\xCE\x3B\xEF\xD0\x7F\xFE\xF3\x1F\x5E\x03\x9D\x3F\xF8\xE0\x83\xE4\xE3\xE3\x23\x78\xE3\x67\x87\x73\x1E\xDD\xBB\x77\xA7\x8C\x8C\x0C\x7A\xFD\xF5\xD7\x1D\x3A\xA1\xF7\xFC\xF3\xCF\x73\xDA\xD3\xEC\xCA\xB6\x0B\x2E\x06\xB9\xA8\x08\xCF\x02\x47\x21\x24\x26\x26\x3A\x9D\x4F\xB0\x39\x1F\x7D\xF4\x11\x85\x87\x87\xF3\xD2\x00\x7C\x7C\x7C\xE8\xB6\xDB\x6E\xA3\xC7\x1E\x7B\xCC\x6E\x31\x04\xDE\x7C\xF3\x4D\xD3\x5A\x7D\x76\xF0\x74\x38\xEB\xAA\xBB\xCE\x1E\x3E\x3E\x3E\xF4\xEC\xB3\xCF\x3A\x34\x8E\x85\x5A\xAD\xA6\x9E\x3D\x7B\x72\xDA\xD3\xEC\x3B\x3C\x03\x2E\x04\xB9\xA0\x9F\x70\x20\x80\x37\x2C\x13\x9D\xD1\x27\xD8\x92\x82\x82\x02\x94\x96\x96\xDA\x9C\x8F\x5C\x2E\xC7\x5D\x77\xDD\x85\x95\x2B\x57\x22\x2E\x2E\x8E\x07\xCB\xB8\x09\x0E\x0E\x46\x6C\x6C\x2C\xAE\x5D\xBB\x06\x9D\x4E\x67\xB7\xEB\xB8\x3B\x32\x99\x0C\xE1\xE1\xE1\x88\x8B\x8B\x43\x50\x50\x10\x6A\x6A\x6A\x50\x52\x52\x82\xEB\xD7\xAF\xA3\xAA\xAA\x0A\x06\x83\x01\x8D\x8D\x8D\x42\x9B\xD9\x29\x92\x92\x92\x30\x61\xC2\x04\xDC\x76\xDB\x6D\x0E\xBB\xA6\xC9\x77\xF8\x8E\x3B\xEE\xB0\x3A\xD7\xEC\x3B\xBC\xDE\x60\x30\x7C\x0F\xA0\xCA\x61\x46\x75\x31\xFE\x09\x8E\x37\xE0\xAC\x59\xB3\x1C\xF6\x26\xEE\x2C\xAB\x57\xAF\xB6\xB9\xE7\x21\x95\x4A\xA9\x77\xEF\xDE\x74\xEC\xD8\x31\xBB\x2F\x41\xD5\xEB\xF5\xF4\xF9\xE7\x9F\x53\x6A\x6A\xAA\xE0\x3D\x2E\x57\x3D\xA4\x52\x29\xA5\xA7\xA7\xD3\xF6\xED\xDB\x49\xA3\xD1\x90\x56\xAB\x25\x8D\x46\x43\x1A\x8D\x86\x7E\xFD\xF5\x57\xBA\xF7\xDE\x7B\x69\xD8\xB0\x61\x2E\x3B\x09\x3A\x7E\xFC\x78\x3A\x7C\xF8\xB0\x5D\xEB\x61\x6B\xCC\x98\x31\x83\xD3\xA6\x66\xDF\xE1\xCD\x70\x11\xC8\xC5\x86\x23\x46\x80\xC3\x27\x38\x30\x30\xD0\x69\xFC\x19\x5B\x63\xD7\xAE\x5D\x34\x62\xC4\x08\x9B\x2B\xBD\x87\x87\x07\x4D\x99\x32\xC5\x61\xCB\x4F\x6F\xDC\xB8\x41\x2F\xBE\xF8\xA2\xE0\x8D\xDD\xD5\x8E\x7B\xEE\xB9\x87\x0E\x1C\x38\x40\x87\x0F\x1F\xA6\xF3\xE7\xCF\x73\xEE\x0C\xAD\xD5\x6A\x29\x2F\x2F\x8F\xB2\xB3\xB3\xE9\xF0\xE1\xC3\xF4\xFC\xF3\xCF\xD3\xB0\x61\xC3\x5A\xFD\xD4\x76\xC6\xE3\xB3\xCF\x3E\xA3\xBA\xBA\x3A\x87\xD4\x45\x4B\xAE\x5D\xBB\xC6\x19\x44\xDF\xCC\x77\x98\xFF\x90\x7A\x76\x80\x5C\x68\x38\x42\x81\xA6\xB7\x9B\x55\xC0\x8E\x75\xEB\xD6\x21\x28\x28\xC8\xF1\x16\x75\x80\x03\x07\x0E\xE0\xF0\xE1\xC3\x36\xE7\x63\x30\x18\x40\x44\xD0\xEB\xF5\x3C\x58\x75\x6B\x7C\x7C\x7C\x90\x99\x99\x89\xA8\xA8\x28\x14\x17\x17\x3B\xE4\x9A\xAE\x4A\x58\x58\x18\xA6\x4E\x9D\x8A\x3E\x7D\xFA\x60\xC0\x80\x01\xE8\xD7\xAF\x5F\x9B\xBF\x97\xCB\xE5\x88\x8D\x8D\xBD\xF9\xEF\x6E\xDD\xBA\x61\xDC\xB8\x71\xA8\xAD\xAD\x45\x6E\x6E\x2E\x80\xA6\x7A\xF3\xEF\x7F\xFF\x1B\xF5\xF5\xF5\x76\xB5\xBD\x33\x88\x44\x22\x24\x24\x24\xC0\xCB\xCB\x4B\x90\xEB\x87\x84\x84\x60\xED\xDA\xB5\x78\xF8\xE1\x87\x5B\xA4\x13\x11\x94\x4A\xA5\x08\xC0\x16\x00\x7D\x01\xB0\xB1\x34\x9E\x58\x06\x8E\x37\xF1\x88\x11\x23\x9C\xD6\x27\x98\x88\xC8\x60\x30\x50\x41\x41\x01\x4D\x9C\x38\x91\x97\x9E\x47\x70\x70\x30\x6D\xD8\xB0\xC1\xA1\x3D\xFF\xE2\xE2\x62\xD6\x1B\xE6\x38\xA4\x52\x29\x05\x07\x07\x53\x4A\x4A\x0A\xCD\x9D\x3B\x97\x36\x6C\xD8\xC0\xD9\xE3\xB5\x85\x0B\x17\x2E\xD0\x4B\x2F\xBD\x44\x53\xA6\x4C\xA1\x94\x94\x14\x8A\x8B\x8B\x73\x8A\x65\xE5\x62\xB1\x98\xE2\xE3\xE3\xE9\xD4\xA9\x53\xBC\xDE\x6F\x47\x31\x1A\x8D\x34\x74\xE8\x50\x4E\x1B\x13\x13\x13\x09\xC0\x73\x70\x72\xC8\x45\x86\x23\xE2\x01\x68\x60\xF1\x90\x15\x0A\x05\x65\x65\x65\x09\x5A\x09\x6E\x85\x5A\xAD\xA6\x4D\x9B\x36\xF1\xE2\x73\x2B\x95\x4A\xE9\x8E\x3B\xEE\x10\xE4\x3E\x2E\x5F\xBE\x4C\x7E\x7E\x7E\x2E\x19\x55\x8C\xEF\xC3\xC7\xC7\x87\xBC\xBC\xBC\x68\xE4\xC8\x91\xB4\x74\xE9\x52\xDA\xB1\x63\x87\x43\xCA\x60\xC7\x8E\x1D\xB4\x65\xCB\x16\x9A\x31\x63\x06\xF5\xE9\xD3\x87\x7A\xF4\xE8\x41\xDE\xDE\xDE\x82\xAC\x6E\xF4\xF1\xF1\xA1\x65\xCB\x96\x51\x49\x49\x89\x43\xEE\xBD\x2D\xCE\x9E\x3D\xCB\x39\xA6\xAE\x54\x2A\xC9\xC3\xC3\x43\x0D\xC0\x7E\xB3\xD7\x3C\x40\x2E\x20\xC2\x22\x34\xC5\x0D\xB5\x7A\xC8\xCB\x96\x2D\x13\xBA\xFC\x6F\x89\x5A\xAD\xA6\x57\x5F\x7D\x95\x17\x57\xAF\xD0\xD0\x50\x5A\xB1\x62\x85\x20\x9B\x5A\x96\x94\x94\xD0\xBC\x79\xF3\xBA\xFC\xC2\x07\x4F\x4F\x4F\x9A\x3B\x77\x2E\xFD\xF5\xAF\x7F\xA5\x5F\x7E\xF9\x85\x74\x3A\x9D\xC3\x82\xA7\xEB\xF5\x7A\xD2\xEB\xF5\xD4\xD8\xD8\x48\x5A\xAD\x96\xB2\xB3\xB3\xE9\x81\x07\x1E\xA0\x3B\xEF\xBC\x93\x7C\x7D\x7D\x1D\xFA\x1C\x22\x23\x23\xA9\xAA\xAA\xCA\x69\xBE\x42\x9F\x7B\xEE\x39\x4E\x3B\x9B\x7D\x87\x7F\x84\x13\x43\x2E\x20\xC2\x33\xC1\xF1\x70\xE3\xE3\xE3\x05\x11\xA3\x8E\x52\x57\x57\x47\x73\xE6\xCC\x21\x2F\x2F\x2F\x9B\x2B\x7E\x60\x60\x20\xFD\xED\x6F\x7F\xB3\x5A\xBB\xEF\x08\x74\x3A\x1D\x15\x15\x15\x51\x5A\x5A\x9A\xE0\x42\x28\xC4\xD1\xBD\x7B\x77\xFA\xFB\xDF\xFF\x4E\x27\x4E\x9C\xA0\xA2\xA2\x22\xBA\x7C\xF9\xB2\x53\xD4\xBF\xC2\xC2\x42\xCA\xCB\xCB\xA3\x93\x27\x4F\xD2\x86\x0D\x1B\xE8\xB6\xDB\x6E\xA3\x8C\x8C\x0C\xBB\xFB\x23\x47\x47\x47\x3B\xC5\xFD\x9B\x68\x68\x68\xA0\xB8\xB8\x38\x4E\x5B\x63\x62\x62\x08\xC0\x34\x0E\x6D\x71\x0A\xC8\xC9\x27\xE6\x02\x00\xAC\xB7\x4C\x34\xF9\x04\x3B\x6B\x0C\x54\x73\xBC\xBC\xBC\x70\xFC\xF8\xF1\x9B\xB1\x5D\x6D\xA1\x7B\xF7\xEE\x98\x3C\x79\x32\xE4\x72\xC7\xC7\x29\x91\x4A\xA5\x88\x8A\x8A\xC2\xE0\xC1\x83\x91\x9D\x9D\x0D\xAD\x56\xEB\x70\x1B\x1C\x4D\x74\x74\x34\x7C\x7D\x7D\x31\x7B\xF6\x6C\xA4\xA4\xA4\x60\xC0\x80\x01\x08\x0D\x0D\x15\xDA\xAC\x16\x44\x47\x47\xDF\xFC\xFF\x9E\x3D\x7B\x62\xC0\x80\x01\xD0\xE9\x74\x28\x29\x29\x41\x4D\x4D\x0D\x4E\x9F\x3E\x8D\x9D\x3B\x77\xA2\xAC\xAC\x8C\xB7\x6B\x7A\x78\x78\xA0\x7F\xFF\xFE\x4E\x15\x73\xD9\xC3\xC3\x03\x1B\x37\x6E\xC4\xB8\x71\xE3\xAC\xCE\xD5\xD5\xD5\x41\x2C\x16\xBF\x65\x34\x1A\x7F\x04\x50\xED\x70\xE3\xDA\x81\x33\x8B\xF0\xAB\x68\x0A\xD8\xDE\x82\x19\x33\x66\x60\xF4\xE8\xD1\x02\x98\xD3\x31\xEA\xEB\xEB\x71\xF0\xE0\x41\x14\x14\x14\xD8\xFC\xC9\xE1\xE9\xE9\x89\x61\xC3\x86\x61\xE0\xC0\x81\x3C\x59\xD7\x71\x88\x08\xD3\xA7\x4F\x47\x5E\x5E\x9E\xD3\x6C\x9A\xCA\x37\x12\x89\x04\x43\x86\x0C\x41\xFF\xFE\xFD\xD1\xBB\x77\x6F\xF8\xF9\xF9\x61\xCA\x94\x29\x42\x9B\xD5\x2E\xBC\xBC\xBC\x30\x64\xC8\x90\x16\x69\x95\x95\x95\x48\x4E\x4E\xC6\x85\x0B\x17\x50\x57\x57\x87\x33\x67\xCE\x20\x37\x37\x17\x37\x6E\xDC\xE8\xF4\x75\x7C\x7D\x7D\x91\x91\x91\x01\x89\x44\x62\xAB\xC9\xBC\x72\xE7\x9D\x77\x62\xDA\xB4\x69\xF8\xF4\xD3\x4F\x5B\xA4\x57\x56\x56\xA2\x57\xAF\x5E\x21\xE7\xCE\x9D\x5B\x0B\xE0\x11\x61\xAC\x73\x4D\x86\x83\xC3\x27\x38\x20\x20\x80\xCA\xCA\xCA\x04\xFE\xF8\x69\x1F\xB9\xB9\xB9\x34\x61\xC2\x04\x5E\x26\x4E\xBA\x77\xEF\x4E\x9B\x37\x6F\x16\xFA\x96\x88\x88\x68\xC3\x86\x0D\x6E\x15\x04\x5D\x22\x91\x50\x70\x70\x30\x8D\x18\x31\x82\xEE\xBF\xFF\x7E\x3A\x7E\xFC\xB8\xD0\x8F\xD8\x6E\xEC\xDA\xB5\x8B\x16\x2C\x58\x40\xB7\xDF\x7E\x3B\xF9\xFA\xFA\x92\x4A\xA5\x22\xA5\x52\xD9\xA1\x09\xD7\x98\x98\x18\xDA\xB4\x69\x13\x69\xB5\x5A\xA1\x6F\xC7\x8A\xD2\xD2\x52\xF2\xF3\xF3\xB3\xB2\x59\x2C\x16\x53\x60\x60\xA0\x01\x40\x66\x47\x44\xC8\x11\x90\x93\x0E\x47\xC8\xD1\x8A\x4F\xF0\xAB\xAF\xBE\xEA\x32\xDB\x7A\xAB\xD5\x6A\x5C\xBD\x7A\x15\x06\x83\xC1\xE6\xBC\x3C\x3C\x3C\x6E\x6E\x43\x24\x34\x91\x91\x91\x88\x8D\x8D\xC5\xE9\xD3\xA7\x85\x36\xC5\x66\x24\x12\x09\x92\x92\x92\x30\x65\xCA\x14\x2C\x59\xB2\x04\x0A\x85\x02\x22\x91\xCB\xEF\x1D\xD9\x2A\x63\xC6\x8C\xC1\xE8\xD1\xA3\x71\xF1\xE2\x45\xBC\xF7\xDE\x7B\xD0\xE9\x74\xC8\xCB\xCB\x43\x76\x76\x36\x4A\x4A\x4A\xDA\x35\xCC\x24\x97\xCB\xE1\xE3\xE3\xE3\x94\xCF\x29\x2C\x2C\x0C\x6B\xD7\xAE\xC5\x23\x8F\xB4\xEC\xF0\x1A\x8D\x46\x78\x79\x79\x89\x2B\x2B\x2B\xDF\x03\x30\x00\xCC\x77\xF8\x96\x2C\x05\xC7\x1B\x78\xF8\xF0\xE1\x4E\x33\x1B\x7B\x2B\x0A\x0B\x0B\xE9\x6F\x7F\xFB\x5B\x87\x7B\x19\xAD\x1D\x8B\x17\x2F\xA6\xEB\xD7\xAF\x0B\x7D\x5B\x44\xD4\xB4\x43\xC5\xFF\xFB\x7F\xFF\xCF\xA5\x43\x5D\x02\xA0\x21\x43\x86\xD0\x97\x5F\x7E\x49\x85\x85\x85\x4E\xBF\xE2\x92\x6F\x0C\x06\x03\x5D\xBD\x7A\x95\x4A\x4B\x4B\xA9\xA0\xA0\x80\xB2\xB2\xB2\xE8\xCB\x2F\xBF\xA4\x71\xE3\xC6\xD1\xC4\x89\x13\x29\x38\x38\x98\xF3\x99\x79\x7B\x7B\xD3\xA2\x45\x8B\x9C\xCA\x33\xC2\x12\x83\xC1\x40\x99\x99\x99\x9C\xF6\x37\xFB\x0E\x3F\xDB\x09\x4D\xB2\x1B\xE4\x84\x3D\xE1\x9E\x00\x5E\xB0\x4C\x94\xCB\xE5\x78\xEF\xBD\xF7\x9C\xF2\xED\xCB\x45\x45\x45\x05\xCE\x9D\x3B\x07\x8D\x46\xC3\x4B\x7E\xB1\xB1\xB1\xF0\xF7\xF7\xE7\x25\x2F\x5B\x51\xA9\x54\x48\x4B\x4B\x43\x54\x54\x14\x8A\x8A\x8A\x84\x36\xA7\xD3\x68\x34\x1A\x5C\xBA\x74\x09\x43\x87\x0E\x75\xFA\x15\x97\x7C\x23\x16\x8B\xAD\x26\x19\x93\x92\x92\x10\x1D\x1D\x0D\xB1\x58\x8C\xE2\xE2\x62\x94\x95\x95\xA1\xA0\xA0\x00\x9F\x7D\xF6\x19\xAE\x5C\xB9\x02\xB5\x5A\x0D\xBD\x5E\x8F\x84\x84\x04\xF8\xF9\xF9\x09\x63\x78\x3B\x10\x8B\xC5\xD8\xB4\x69\x13\x06\x0E\x1C\x68\x15\x78\xAA\xB0\xB0\x10\x1E\x1E\x1E\xCB\xD5\x6A\xF5\x0E\x00\xF9\xC2\x58\x68\x8D\xB3\x89\xF0\xBB\x68\x5A\xA2\xDC\x82\xA7\x9F\x7E\x1A\x29\x29\x29\x02\x98\xD3\x39\x1A\x1B\x1B\x79\x13\x60\x7F\x7F\x7F\x04\x04\x04\xF0\x92\x17\x5F\x84\x86\x86\x62\xEA\xD4\xA9\xC8\xCB\xCB\x43\x45\x45\x85\x53\xCD\x94\xB7\x97\x9C\x9C\x1C\xAC\x5F\xBF\x1E\x27\x4E\x9C\xC0\x1D\x77\xDC\x81\xC0\xC0\x40\xF8\xFA\xFA\xA2\x7F\xFF\xFE\xF0\xF4\xF4\x14\xDA\x3C\x41\x30\x4D\xFC\xF6\xEF\xDF\x1F\x40\xD3\x67\x7C\x62\x62\x22\x8A\x8B\x8B\x91\x93\x93\x83\xC8\xC8\x48\x41\x27\x87\xDB\x4B\x6A\x6A\x2A\x9E\x7A\xEA\x29\xBC\xF2\xCA\x2B\x2D\xD2\xD5\x6A\x35\x12\x13\x13\x3D\x2E\x5C\xB8\xB0\x11\xC0\x04\x61\xAC\x73\x6E\xA6\x83\xE3\x13\xA2\x67\xCF\x9E\x4E\xE5\x93\xD8\x1E\x7E\xF8\xE1\x07\xDE\x7C\x6A\xA7\x4F\x9F\x4E\x27\x4F\x9E\x14\xFA\x96\xAC\xA8\xAF\xAF\xA7\x65\xCB\x96\x71\x4E\x84\xB8\xE2\x11\x14\x14\x44\x03\x06\x0C\xA0\x2D\x5B\xB6\xD0\x99\x33\x67\xE8\xDC\xB9\x73\x74\xE9\xD2\x25\x2A\x2A\x2A\x72\xCA\x49\x28\x46\xDB\xD4\xD7\xD7\x53\x8F\x1E\x3D\x38\xCB\xBA\x5B\xB7\x6E\x04\x60\x6A\xA7\x54\x8A\x67\xC8\x89\x16\x6B\xF8\x03\x28\x03\xC7\x03\xDB\xB5\x6B\x97\xD0\xE5\xD9\x61\xDE\x7C\xF3\x4D\xDE\xC4\xE1\x97\x5F\x7E\x11\xFA\x76\x5A\x45\xAF\xD7\x53\x9F\x3E\x7D\x04\x17\x50\x7B\x1C\x0A\x85\x82\xD2\xD3\xD3\xE9\xBE\xFB\xEE\xA3\x7D\xFB\xF6\x09\xFD\xA8\x19\x9D\xE0\xFB\xEF\xBF\xE7\x2C\xDB\xC0\xC0\x40\x12\x8B\xC5\xA5\x00\x7C\x3B\xA8\x53\xBC\x43\x44\x10\x0B\x6D\x44\x33\x6B\x01\x58\xB9\x3D\x4C\x9F\x3E\x1D\x63\xC7\x8E\x15\xC0\x1C\xDB\xE0\x6B\xEC\xDA\x99\xBC\x22\xB8\x90\x48\x24\x18\x33\x66\x8C\x60\x91\xB4\xEC\x89\x56\xAB\xC5\xC9\x93\x27\xF1\xE3\x8F\x3F\x62\xD6\xAC\x59\x48\x4B\x4B\xC3\x98\x31\x63\xB0\x6E\xDD\x3A\xA1\x4D\x63\xB4\x93\xF1\xE3\xC7\x63\xEA\x54\xEB\x0E\x6F\xB3\xFF\x74\x18\x80\xD5\x8E\xB7\xCA\x1A\x67\x98\xE9\x1A\x0A\x60\x2F\x2C\x6C\xF1\xF7\xF7\x47\x56\x56\x96\xD3\xAD\x52\xBA\x15\x27\x4F\x9E\xC4\xCB\x2F\xBF\x8C\x2F\xBE\xF8\xC2\xA6\x7C\xA4\x52\x29\xFA\xF4\xE9\x83\xAD\x5B\xB7\xA2\x4F\x9F\x3E\x3C\x59\xC7\x2F\x44\x84\xDC\xDC\x5C\x6C\xDC\xB8\x11\x7F\xFC\xF1\x07\x0C\x06\x03\xCA\xCA\xCA\x70\xED\xDA\x35\xA1\x4D\xB3\x1B\x51\x51\x51\xC8\xCC\xCC\x84\x8F\x8F\x0F\x82\x82\x82\x30\x60\xC0\x00\xF8\xFB\xFB\x63\xCC\x98\x31\x42\x9B\xC6\xE0\xA0\xB4\xB4\x14\xC9\xC9\xC9\xA8\xA9\xA9\x69\x91\x2E\x16\x8B\xE1\xEF\xEF\x6F\xAC\xAC\xAC\xCC\x04\x70\x48\x18\xEB\xE0\x14\xDE\x11\x32\xB4\xE2\x13\xBC\x76\xED\x5A\x97\x13\x60\x00\xF8\xF7\xBF\xFF\x8D\x5F\x7E\xF9\xC5\xE6\x7C\xBC\xBD\xBD\xF1\xF8\xE3\x8F\x23\x32\x32\x92\x07\xAB\xEC\x83\x29\xA6\xEC\xC2\x85\x0B\x31\x6A\xD4\xA8\x9B\x22\x7C\xEE\xDC\x39\x9C\x38\x71\x02\xC5\xC5\xC5\xD0\x68\x34\x6E\x25\xCA\xC5\xC5\xC5\xD8\xB1\x63\xC7\xCD\x7F\xF7\xEA\xD5\x0B\xFE\xFE\xFE\x38\x71\xE2\x04\x7A\xF4\xE8\x81\x88\x88\x08\x44\x45\x45\xA1\x5B\xB7\x6E\x02\x5A\xC9\x30\x11\x1E\x1E\x8E\xD5\xAB\x57\x63\xC1\x82\x05\x2D\xD2\x8D\x46\x23\xBC\xBD\xBD\xC5\x95\x95\x95\x5B\xD0\xE4\x3B\xEC\x98\x20\xDD\x1C\x08\xDD\x13\x7E\x0E\x1C\x9F\x04\x43\x87\x0E\xC5\xDE\xBD\x7B\x5D\xC6\x25\xCD\x9C\x19\x33\x66\xE0\x93\x4F\x3E\xB1\x39\x9F\xF0\xF0\x70\x14\x16\x16\x42\x2A\x15\xFA\x3D\xD9\x39\x0E\x1E\x3C\x88\x83\x07\x0F\xA2\xBA\xBA\x1A\x7F\xFC\xF1\x07\xB2\xB2\xB2\xA0\xD1\x68\xA0\xD3\xE9\xD0\xD0\xD0\xE0\x54\x13\x12\x7C\xA1\x54\x2A\x31\x60\xC0\x00\x8C\x1C\x39\x12\x0B\x16\x2C\x40\x50\x50\x90\xCB\x96\x9F\x3B\x61\x34\x1A\x91\x99\x99\x89\x43\x87\xAC\x3B\xBC\x09\x09\x09\xC8\xC9\xC9\x59\x02\x40\x90\x71\x26\x22\x12\x54\x84\x63\x01\x9C\x03\xD0\x22\x12\x8F\x4C\x26\xC3\xF1\xE3\xC7\xD1\xBB\x77\x6F\x61\xAC\xB2\x01\x22\xC2\xA4\x49\x93\xF0\xCD\x37\xDF\xD8\x9C\x57\x54\x54\x14\x4E\x9D\x3A\xE5\x74\xEE\x69\x9D\xC1\x60\x30\x60\xFD\xFA\xF5\x28\x2A\x2A\x42\x69\x69\x29\xCE\x9C\x39\x83\xE2\xE2\xE2\x9B\x62\xEC\x6E\x82\xDC\xAD\x5B\xB7\x9B\xAB\xF0\x42\x42\x42\x84\x36\x87\x01\xE0\xD4\xA9\x53\x18\x38\x70\xA0\xD5\xAE\x34\x1E\x1E\x1E\x20\xA2\x06\x8D\x46\x93\x02\xE0\xB2\xA3\xED\x12\x7A\x38\x62\x23\x2C\x04\x18\x68\xF2\x09\x76\x45\x01\x6E\x6C\x6C\xC4\xD6\xAD\x5B\x71\xE6\xCC\x19\x9B\xF3\xF2\xF1\xF1\xC1\xA8\x51\xA3\x04\x89\x98\x66\x0F\x24\x12\x09\xE6\xCD\x9B\x87\xC6\xC6\x46\xE8\xF5\x7A\xA8\xD5\x6A\x34\x34\x34\xE0\xFD\xF7\xDF\xC7\xE5\xCB\x97\x91\x95\x95\x75\x73\x4B\x1F\x77\xA0\xB4\xB4\x14\x87\x0E\x1D\x72\xC9\x2F\x39\x77\x25\x2D\x2D\x0D\x4F\x3E\xF9\xA4\xD5\xC4\x6A\xB3\xEF\xB0\x67\xB3\xEF\xF0\x44\x21\x6C\x13\x4A\x84\xA7\x01\xB0\x8A\x3B\x17\x1B\x1B\x8B\x65\xCB\x96\x09\x60\x8E\xED\x18\x8D\x46\x5C\xB8\x70\x01\x55\x55\x55\x36\xE7\x25\x93\xC9\x10\x12\x12\xE2\x56\x8D\x98\x6B\x95\xD5\x53\x4F\x3D\x85\x1B\x37\x6E\xA0\xA2\xA2\x02\xD7\xAE\x5D\x43\x7D\x7D\x3D\x3E\xF9\xE4\x13\x14\x17\x17\xBB\xB4\x28\xEB\x74\x3A\x9C\x3A\x75\x0A\xFF\xF8\xC7\x3F\xF0\xC0\x03\x0F\x38\xF5\xB8\x7E\x57\x62\xF9\xF2\xE5\xD8\xB1\x63\x07\x2E\x5F\x6E\xD9\xE1\xBD\x70\xE1\x02\xA2\xA3\xA3\xFF\x52\x54\x54\x74\x3F\x80\x9D\x8E\xB6\x4B\x08\x11\xF6\x03\xF0\x16\xD7\x89\x8D\x1B\x37\x3A\xB5\x4B\x56\x5B\x28\x95\x4A\xE4\xE7\xE7\xF3\xB2\x52\x2E\x3C\x3C\x1C\x63\xC6\x8C\x81\x4C\x26\xE3\xC1\x32\xE7\xA5\x7B\xF7\xEE\x56\x69\x3D\x7B\xF6\xC4\x95\x2B\x57\x70\xE9\xD2\x25\x5C\xB9\x72\x05\x7A\xBD\x1E\x7F\xFE\xF9\x27\xB2\xB2\xB2\x5C\x6A\xD8\xA2\xB6\xB6\x16\xEF\xBE\xFB\x2E\x86\x0C\x19\xC2\x44\xD8\x49\xF0\xF2\xF2\xC2\xC6\x8D\x1B\x31\x71\xA2\x75\x87\x57\xA3\xD1\x40\x24\x12\xBD\x45\x44\xBB\x00\x74\x3E\xD6\xA7\x8B\xB0\x09\x1C\x0E\xD4\xD3\xA6\x4D\x13\xC6\xA3\x9B\x07\xB4\x5A\x2D\x9D\x3F\x7F\x9E\xBA\x77\xEF\xCE\xCB\x42\x81\xA9\x53\xA7\x0A\x7D\x4B\x4E\xC5\xB6\x6D\xDB\xE8\xAF\x7F\xFD\x2B\xA5\xA7\xA7\x53\x72\x72\x32\xA9\x54\x2A\xBB\xEF\x1E\xC1\xD7\xF1\xDA\x6B\xAF\x09\xB6\x2D\x3C\x83\x9B\xFB\xEF\xBF\x9F\xB3\xAC\x7A\xF5\xEA\x45\x00\x36\xD8\xA4\x6E\x1D\x84\x04\xE8\x58\x64\x02\x30\xC0\xE2\xE6\xFD\xFC\xFC\xA8\xB4\xB4\x54\xE8\xB2\xE9\x34\xF9\xF9\xF9\xF4\xC0\x03\x0F\x90\x87\x87\x87\xCD\x8D\x56\x26\x93\xD1\x53\x4F\x3D\x25\xF4\x2D\x39\x2D\x97\x2E\x5D\xA2\x07\x1F\x7C\x90\x6E\xBF\xFD\x76\xF2\xF7\xF7\x27\x99\x4C\x46\x52\xA9\x94\xC4\x62\xB1\xE0\x82\xCB\x75\xA4\xA5\xA5\xD1\x17\x5F\x7C\x41\x06\x83\x41\xE8\x47\xC7\x68\xA6\xB8\xB8\x98\x73\xBF\x44\x89\x44\x42\xFE\xFE\xFE\x06\x00\x19\x3C\x68\x5D\xBB\x20\x07\xAF\x98\x93\x01\x78\x0F\xB0\xBE\xE6\x9A\x35\x6B\x10\x16\x16\xE6\x40\x53\xF8\xC7\x72\xD6\xB5\xB3\x44\x47\x47\x23\x29\x29\x89\x97\xBC\xDC\x91\x98\x98\x18\xAC\x5E\xBD\x1A\x1F\x7F\xFC\x31\x0E\x1F\x3E\x8C\xB3\x67\xCF\xE2\xDB\x6F\xBF\xC5\xB0\x61\xC3\x84\x36\x8D\x93\xF3\xE7\xCF\xE3\xB5\xD7\x5E\xC3\x57\x5F\x7D\x25\xB4\x29\x8C\x66\x22\x23\x23\xB1\x6A\xD5\x2A\xAB\x74\x83\xC1\x00\x5F\x5F\x5F\x31\x9A\xD6\x2E\x38\x6C\xA8\xD6\x91\x63\xC2\x4F\x02\xB0\x5A\xFA\x95\x99\x99\x89\xF9\xF3\xE7\x3B\xD0\x0C\xFE\x21\x22\x1C\x3A\x74\x08\x8D\x8D\x8D\x36\xE7\x25\x91\x48\xDC\x72\x19\x30\x5F\x88\xC5\x62\x2B\xB7\xAF\x84\x84\x04\x04\x06\x06\xE2\xF2\xE5\xCB\xD0\x6A\xB5\x38\x7A\xF4\x28\x76\xEE\xDC\x89\x2B\x57\xAE\x08\x64\xE5\x7F\xD1\xE9\x74\x38\x76\xEC\x18\xF6\xEF\xDF\x8F\xC9\x93\x27\x0B\x6D\x0E\xA3\x99\x47\x1F\x7D\xF4\xE6\x8B\xDC\x9C\x82\x82\x02\x24\x24\x24\xF4\xCD\xC9\xC9\x59\x08\xE0\x0D\x47\xD8\xE2\xA8\xE9\xF7\xEE\x00\xCE\x03\x68\x31\xEB\x26\x93\xC9\x70\xF4\xE8\x51\xA4\xA6\xA6\x3A\xC8\x0C\xFE\xB9\x7A\xF5\x2A\xB6\x6F\xDF\x8E\xA7\x9E\x7A\xCA\xE6\xBC\x24\x12\x09\x66\xCE\x9C\x89\xC5\x8B\x17\x3B\xED\x52\x65\x57\xA0\xBC\xBC\x1C\xDF\x7D\xF7\x1D\x8A\x8B\x8B\x6F\x86\xDA\x3C\x75\xEA\x14\xF6\xEF\xDF\x2F\xD8\xE4\x5E\x46\x46\x06\x36\x6C\xD8\x80\xD4\xD4\x54\x97\xD8\xA4\xB6\x2B\x70\xE2\xC4\x09\x64\x64\x64\x58\x7D\xC5\x7A\x7A\x7A\xC2\x60\x30\xD4\x6B\xB5\xDA\x14\x00\x85\xF6\xB4\xC1\x91\xF5\xF1\x7B\x70\x8C\x97\x2D\x59\xB2\x44\xD8\xC1\x21\x1E\xF8\xFD\xF7\xDF\x69\xF0\xE0\xC1\xBC\x8C\x1F\x86\x84\x84\xD0\xD7\x5F\x7F\x2D\xF4\x2D\xB9\x25\xFB\xF6\xED\xA3\x19\x33\x66\xD0\x3D\xF7\xDC\x43\x21\x21\x21\x14\x10\x10\xE0\xD0\xBD\xF2\x64\x32\x19\x8D\x1F\x3F\xDE\xA5\xE7\x3E\xDC\x91\xA7\x9E\x7A\x8A\xB3\xBC\x92\x92\x92\x08\xC0\xB7\x7C\x8A\x20\x17\xE4\xA0\xC5\x1A\x53\x01\x8C\xB7\x4C\xEC\xDE\xBD\x3B\x96\x2F\x5F\xEE\x80\xCB\xDB\x17\x89\x44\xC2\x5B\xCF\xA6\x57\xAF\x5E\x6E\xB1\x42\xCE\x19\x19\x3A\x74\x28\x86\x0E\x1D\x8A\xBA\xBA\x3A\xAC\x5E\xBD\x1A\x1A\x8D\x06\xA5\xA5\xA5\x38\x72\xE4\x08\x8A\x8A\x8A\x6E\xEE\x05\x48\x44\x76\x09\x52\xAF\xD3\xE9\xF0\xFB\xEF\xBF\xA3\xA2\xA2\x02\xA1\xA1\xA1\x6E\xE5\x03\xEE\xCA\xBC\xF8\xE2\x8B\xD8\xB9\x73\x27\x0A\x0B\x5B\x76\x78\xB3\xB3\xB3\x11\x1D\x1D\x7D\x57\x51\x51\xD1\x24\x00\x2E\x3D\xA0\xEF\x0B\xA0\x14\x1C\x6F\x9A\xEF\xBF\xFF\x5E\xE8\x97\x20\x2F\xBC\xFF\xFE\xFB\xBC\x78\x45\x00\xA0\x4F\x3F\xFD\xD4\xE5\x02\xD8\xBB\x22\x95\x95\x95\x54\x51\x51\x41\x57\xAF\x5E\xA5\x82\x82\x02\x3A\x7A\xF4\x28\xCD\x9A\x35\x8B\x26\x4F\x9E\xCC\x5B\x30\x7E\xAE\x43\x24\x12\xD1\xFC\xF9\xF3\xA9\xA8\xA8\x48\xE8\x47\xC0\x30\xE3\xDB\x6F\xBF\xE5\x2C\xAF\xE0\xE0\x60\x12\x89\x44\xC5\x00\x7C\x78\xD6\xC5\x9B\x90\x03\x7A\xC2\xAB\x01\x58\xB9\x3D\x4C\x9D\x3A\x15\xE3\xC7\x5B\x75\x8E\x5D\x12\xB5\x5A\x0D\xB5\x5A\xCD\x4B\x5E\xA1\xA1\xA1\x6C\xBC\xD0\x01\x58\x7E\x6D\xC4\xC4\xC4\xE0\xF9\xE7\x9F\x87\x4E\xA7\x43\x4D\x4D\x0D\xCA\xCA\xCA\x50\x56\x56\x86\xAD\x5B\xB7\xE2\xDA\xB5\x6B\x28\x28\x28\xE0\x65\xD7\x6C\x22\xC2\xE7\x9F\x7F\x0E\x0F\x0F\x0F\xCC\x9F\x3F\xDF\xA5\xB6\xEC\x72\x67\xEE\xBA\xEB\x2E\x4C\x9A\x34\xC9\xCA\x83\xA5\xBC\xBC\x1C\xBD\x7A\xF5\x8A\x3C\x77\xEE\xDC\xCB\x00\x9E\xB0\xD7\xF5\xED\x29\xC2\x83\x00\x3C\x62\x99\xE8\xEB\xEB\x8B\xF5\xEB\xD7\xDB\xF1\xB2\x8E\xE3\xD8\xB1\x63\x38\x7F\xFE\xBC\xCD\xF9\x88\x44\x22\x97\x5D\x29\xE8\x2E\x24\x24\x24\x58\xA5\xF5\xE8\xD1\x03\x95\x95\x95\x28\x2E\x2E\xC6\xBE\x7D\xFB\x78\x09\xCC\x54\x55\x55\x85\xAF\xBF\xFE\x1A\x23\x46\x8C\x60\x22\xEC\x44\xBC\xFD\xF6\xDB\xD8\xBD\x7B\x37\x6A\x6B\x6B\x5B\xA4\x67\x67\x67\xC3\xDF\xDF\xFF\xF1\xAA\xAA\xAA\x8F\x00\x1C\xB3\xC7\xB5\xED\x25\xC2\x52\x00\x5B\xC0\xE1\x13\xBC\x7A\xF5\x6A\x44\x44\x44\xD8\xE9\xB2\x8E\x25\x2F\x2F\x0F\x7E\x7E\x7E\xC8\xCC\xCC\x84\x5E\xAF\xC7\xE5\xCB\x97\x51\x5B\x5B\x8B\x86\x86\x86\x0E\xE5\x23\x91\x48\x10\x17\x17\x07\x95\x4A\x65\x27\x4B\x19\x9D\xC1\x7C\x57\x97\x49\x93\x26\xA1\xBE\xBE\x1E\xBB\x77\xEF\xB6\x39\xDF\x9A\x9A\x1A\x1C\x3F\x7E\x1C\xC3\x86\x0D\x43\x70\xB0\xD5\x86\x32\x0C\x01\x88\x8A\x8A\xC2\xCB\x2F\xBF\x8C\x27\x9E\x68\xD9\xE1\x35\xF9\x0E\x57\x55\x55\xBD\x0F\x20\x1D\x4D\x8B\xCD\x5C\x82\xA7\xC1\x31\xC6\x32\x68\xD0\x20\xB7\x5E\x39\xB4\x76\xED\x5A\x9A\x34\x69\x12\xF5\xEC\xD9\x93\x94\x4A\x25\x49\xA5\x52\x92\x4A\xA5\x24\x12\x89\xDA\x1C\x2B\xF4\xF0\xF0\xA0\x39\x73\xE6\x50\x5E\x5E\x9E\xD0\xB7\xC0\x68\x83\x82\x82\x02\xF2\xF4\xF4\xBC\x65\x79\xB6\xE7\x88\x8C\x8C\xA4\xD7\x5E\x7B\x4D\xE8\x5B\x62\x98\xA1\xD7\xEB\x69\xC0\x80\x01\x9C\xE5\x95\x90\x90\x40\x00\x16\xF1\x2D\x94\x64\xA7\x78\xC2\x31\x68\xF2\x09\x6E\xB1\x6F\xB8\x54\x2A\xC5\xD1\xA3\x47\x91\x96\x96\x66\x87\x4B\x3A\x07\x37\x6E\xDC\x80\x46\xA3\x41\x63\x63\x23\x2E\x5E\xBC\x88\x2D\x5B\xB6\x00\x68\xDA\x6D\xC3\xF2\x33\xC7\x1C\x3F\x3F\x3F\x1C\x3A\x74\x08\xB1\xB1\xB1\x2C\x08\xB8\x13\x53\x5E\x5E\x8E\x85\x0B\x17\xE2\xBB\xEF\xBE\x43\x7D\x7D\xBD\x4D\x79\x89\xC5\x62\x8C\x19\x33\x06\x3F\xFD\xF4\x13\x4F\xD6\x31\xF8\xE0\xF8\xF1\xE3\xC8\xC8\xC8\xB0\x9A\x03\x30\xF3\x1D\x4E\x02\x50\xCC\xD7\xF5\xC8\x4E\x7E\xC2\xDF\x81\xE3\x4D\xF2\xF4\xD3\x4F\x0B\xFD\xA2\x73\x38\xD9\xD9\xD9\x94\x9D\x9D\x4D\x3F\xFD\xF4\x13\xED\xDC\xB9\x93\xD6\xAF\x5F\x4F\xA9\xA9\xA9\xE4\xE9\xE9\x69\xF5\x96\xAD\xAF\xAF\x17\xDA\x5C\xC6\x2D\x68\x6C\x6C\xA4\xAC\xAC\x2C\x8A\x8A\x8A\xE2\xC5\x5B\x22\x32\x32\x92\x76\xEC\xD8\x21\xF4\x6D\x31\x2C\x58\xB4\x68\x51\x5B\xBE\xC3\xBC\xBA\xAB\x11\x11\x24\x7C\x66\x08\x60\x32\x80\xBF\x5B\x26\xC6\xC4\xC4\xE0\xF3\xCF\x3F\x77\x9B\x20\xE5\xED\x25\x28\x28\x08\x41\x41\x41\x88\x8B\x8B\x43\x4A\x4A\x0A\x06\x0F\x1E\x8C\x88\x88\x08\xA4\xA7\xA7\x23\x2D\x2D\x0D\x01\x01\x01\x30\x1A\x8D\x18\x36\x6C\x18\xEE\xBC\xF3\x4E\x28\x14\x0A\xA1\x4D\x66\xB4\x81\x44\x22\x41\x50\x50\x10\x7C\x7C\x7C\x90\x9F\x9F\x8F\xB2\xB2\x32\x9B\xF2\xD3\x68\x34\xB8\x70\xE1\x02\x7C\x7D\x7D\x11\x19\x19\xC9\x26\x67\x9D\x84\x61\xC3\x86\xE1\xE3\x8F\x3F\xC6\x8D\x1B\x2D\x23\x5A\x56\x54\x54\x20\x2A\x2A\x2A\xE9\xC6\x8D\x1B\x27\x01\x5C\xE0\xE3\x5A\x2B\x56\xAC\xE0\x23\x9B\x9B\xA8\x00\x5C\x01\xC7\x1B\xE4\xBB\xEF\xBE\x13\xFA\xE5\xE6\x94\x14\x14\x14\xD0\x96\x2D\x5B\xE8\xE7\x9F\x7F\x26\xAD\x56\x2B\xB4\x39\x8C\x0E\xF0\xEC\xB3\xCF\xF2\xE6\x3F\x9C\x9E\x9E\x4E\xC7\x8E\x1D\x13\xFA\x96\x18\x66\x7C\xF5\xD5\x57\x9C\x65\x15\x12\x12\x42\x22\x91\xA8\x08\x80\x37\x1F\xA2\x49\x3C\x47\x51\x5B\x05\xC0\xCA\xED\x61\xF2\xE4\xC9\x9C\x41\x94\x19\x4D\x5F\x08\x0F\x3D\xF4\x10\xC6\x8C\x19\xD3\xE5\xBE\x12\x5C\x9D\xB0\xB0\x30\xF8\xF8\xD8\xEE\xC3\x2F\x12\x89\x70\xED\xDA\x35\x5C\xBD\x7A\x95\xB7\x48\x7C\x0C\xDB\xB9\xF7\xDE\x7B\x71\xCF\x3D\xF7\x58\xA5\x97\x95\x95\x21\x25\x25\x25\x0A\xC0\x4A\xBE\xAE\xC5\xD7\xC4\x5C\x3A\x80\x83\xB0\x70\x49\x53\xA9\x54\x38\x7F\xFE\x3C\xDB\x59\x80\xE1\x76\xDC\xB8\x71\x03\x1F\x7C\xF0\x01\x16\x2F\x5E\x6C\x73\x5E\x12\x89\x04\x63\xC7\x8E\xC5\xD2\xA5\x4B\x31\x7C\xF8\x70\x1E\xAC\x63\xF0\x41\x51\x51\x11\x52\x52\x52\x50\x57\x57\xD7\x22\x5D\x22\x91\xC0\xC7\xC7\xC7\x58\x5D\x5D\x3D\x10\xC0\x09\x5B\xAE\xC1\x57\x4F\xB8\x55\x9F\xE0\x55\xAB\x56\x31\x01\x66\xB8\x25\x2A\x95\x0A\x43\x86\x0C\xE1\x5C\xE4\xD1\x51\x0C\x06\x03\x7E\xFF\xFD\x77\x64\x65\x65\xF1\x60\x19\x83\x2F\xA2\xA3\xA3\xB1\x72\xA5\x75\x87\xD7\x60\x30\xC0\xDF\xDF\x5F\x0C\xE0\x7D\xC0\xF6\x79\x35\x3E\x44\x78\x21\x80\xBE\x96\x89\xE9\xE9\xE9\x78\xF4\xD1\x47\x79\xC8\x9E\xC1\x70\x4E\xE2\xE3\xE3\xF1\xC4\x13\x4F\x40\x2C\xB6\xBD\x19\xA9\xD5\x6A\xEC\xDA\xB5\x0B\x39\x39\x39\x3C\x58\xC6\xE0\x8B\x85\x0B\x17\xA2\x5F\xBF\x7E\x56\xE9\xF9\xF9\xF9\x88\x8F\x8F\x1F\x00\xE0\x31\x5B\xAF\x61\xEB\x70\x44\x34\x80\x2C\x00\x2D\xA2\x90\x4B\xA5\x52\x1C\x3E\x7C\x98\xD3\x78\x06\xC3\x9D\xA8\xAC\xAC\xC4\xD0\xA1\x43\x71\xE1\x82\xED\x93\xE5\x2A\x95\x0A\x33\x67\xCE\xC4\x33\xCF\x3C\x83\xA8\xA8\x28\xE6\x33\xEE\x24\x1C\x3D\x7A\x14\x83\x07\x0F\xB6\xF2\x1D\xF6\xF6\xF6\x46\x63\x63\x63\x6D\x63\x63\x63\x32\x9A\x9C\x12\x3A\x0C\xF1\xE0\xA2\xF6\x31\x38\x76\xCB\x58\xB4\x68\x11\x66\xCF\x9E\x6D\x63\xD6\x0C\x86\xF3\xA3\x56\xAB\x51\x53\x53\x83\x9C\x9C\x9C\x0E\x2F\x57\xB7\x44\xAB\xD5\x22\x2B\x2B\x0B\x6A\xB5\x1A\x43\x86\x0C\x81\xA7\xA7\xE7\xAD\xFF\x88\x61\x77\x22\x22\x22\x50\x51\x51\x61\xB5\x0B\x47\x63\x63\x23\x12\x12\x12\x14\x15\x15\x15\xDD\x01\xEC\xE8\x4C\xDE\x2B\x56\xAC\xB0\xA9\x27\x3C\x09\xC0\x97\x96\x89\xD1\xD1\xD1\x38\x7F\xFE\x3C\xBC\xBD\x79\xF1\xE0\x60\x30\x9C\x1A\xA3\xD1\x88\xBA\xBA\x3A\xBC\xF4\xD2\x4B\xF8\xE7\x3F\xFF\x89\xEB\xD7\xAF\xDB\x94\x9F\x4C\x26\x43\x66\x66\x26\xBE\xFA\xEA\x2B\xF8\xFB\xFB\xF3\x64\x25\xC3\x56\x6E\xDC\xB8\x81\x94\x94\x14\xCE\x2D\xB3\x22\x23\x23\x71\xE5\xCA\x95\xBB\xD1\xB4\x50\xAD\x43\xD8\xD2\x13\xF6\x01\xF0\x1F\x34\xF9\x06\xB7\xE0\xE3\x8F\x3F\x66\x5B\xF3\x30\xBA\x0C\x22\x91\x08\x0A\x85\x02\xC9\xC9\xC9\xC8\xCB\xCB\xC3\xB9\x73\xE7\x6C\xCA\xCF\x68\x34\xA2\xBA\xBA\x1A\x72\xB9\x1C\x3D\x7B\xF6\xE4\xC5\x0D\x8E\x61\x3B\x0A\x85\x02\xDD\xBB\x77\xC7\x8E\x1D\xD6\x1D\x5E\x4F\x4F\x4F\x34\x34\x34\x0C\x05\xF0\x01\x80\x0E\x6D\x34\xB9\x62\xC5\x8A\x4E\x4F\xCC\xBD\x04\xC0\xCA\xED\x61\xD2\xA4\x49\xB8\xFB\xEE\xBB\x3B\x99\x25\x83\xE1\xBA\x44\x47\x47\x63\xC4\x88\x11\xBC\x6C\xD2\x5A\x53\x53\x83\x4D\x9B\x36\x21\x3F\x3F\x9F\x07\xCB\x18\x7C\x71\xDF\x7D\xF7\xE1\xAE\xBB\xEE\xB2\x4A\xBF\x76\xED\x1A\x52\x52\x52\xBA\x01\x58\xDE\x99\x7C\x3B\x23\xC2\x03\x00\xFC\x9F\x65\xA2\x8F\x8F\x0F\xDE\x7E\xFB\xED\xCE\xD8\xC0\x60\xB8\x05\x19\x19\x19\xB8\xFB\xEE\xBB\x79\xF1\x96\xB8\x72\xE5\x0A\xF6\xEE\xDD\xDB\x66\xE0\x27\x86\xE3\xD9\xB0\x61\x03\xE7\x50\x6B\xF3\xF2\xF3\x27\xC1\xE1\x29\x76\x2B\x3A\x3A\x1C\x21\x41\xD3\xB8\x87\xD5\xCA\xB8\x57\x5F\x7D\x15\x77\xDC\x71\x47\x47\xAF\xCF\x60\xB8\x0D\x11\x11\x11\x88\x8E\x8E\xC6\x89\x13\x27\x50\x52\x52\x62\x73\x7E\xA5\xA5\xA5\x08\x0B\x0B\x43\x62\x62\x22\x24\x12\xBE\xC3\xBC\x30\x3A\x83\x9F\x9F\x1F\xE4\x72\x39\x7E\xFE\xF9\xE7\x16\xE9\x46\xA3\x11\x11\x11\x11\xE2\xEA\xEA\xEA\xFE\x00\xFE\x89\xA6\x65\xCE\xB7\xA4\x33\x13\x73\x4F\x00\x78\xD3\x32\x71\xC0\x80\x01\x38\x74\xE8\x10\xAB\x28\x8C\x2E\x8F\x4E\xA7\xC3\xC1\x83\x07\x71\xDB\x6D\xB7\xD9\x9C\x97\x54\x2A\x45\xBF\x7E\xFD\xB0\x64\xC9\x12\xDC\x7F\xFF\xFD\x3C\x58\xC7\xE0\x03\xBD\x5E\x8F\xF4\xF4\x74\x9C\x3C\x79\xD2\xEA\x5C\x7C\x7C\x3C\x72\x73\x73\x1F\x07\xB0\xB1\x3D\x79\x75\x74\xC5\x5C\x14\x80\x97\x2D\x13\x25\x12\x09\xB6\x6C\xD9\xC2\x04\x98\xC1\x40\x93\x77\x43\x42\x42\x02\x86\x0F\x1F\x6E\xF3\x7E\x81\x7A\xBD\x1E\x05\x05\x05\x28\x2E\xE6\x2D\x7C\x2D\x83\x07\xA4\x52\x29\x36\x6F\xDE\xCC\x39\xEC\x54\x5A\x5A\x0A\xB9\x5C\xBE\x06\x1C\xA3\x05\xAD\xD1\x11\x11\xDE\x00\x8E\xC8\x41\x8F\x3F\xFE\x38\xFA\xF7\xEF\xDF\x81\x6C\x18\x0C\xF7\xC6\xC7\xC7\x07\x2F\xBE\xF8\x22\x7C\x7D\x7D\x6D\xCE\xAB\xB6\xB6\x16\x3F\xFE\xF8\x23\xF6\xED\xDB\x07\xAD\x56\xCB\x83\x75\x0C\x3E\xC8\xC8\xC8\xE0\x5C\x11\x5C\x57\x57\x87\xB8\xB8\x38\x1F\x70\x8C\x18\xB4\x46\x7B\x87\x23\xEE\x06\x60\xB5\xCB\x61\x54\x54\x14\xCE\x9F\x3F\xCF\xDC\x68\x18\x0C\x0E\xC6\x8D\x1B\x87\xDD\xBB\x77\xDB\xBC\x53\xB3\x48\x24\xC2\x5D\x77\xDD\x85\x8F\x3E\xFA\x88\x17\x61\x67\xF0\xC3\x8D\x1B\x37\x90\x9C\x9C\xCC\x39\xFE\x1F\x11\x11\x81\x92\x92\x92\xBF\x00\xF8\xBE\xAD\x3C\xDA\x3B\x1C\xE1\x8D\x56\xC6\x37\x36\x6C\xD8\xC0\x04\x98\xC1\x68\x85\x69\xD3\xA6\x21\x29\x29\xC9\x66\x6F\x09\x22\xC2\xA1\x43\x87\x50\x52\x52\x62\xB3\xA0\x33\xF8\x43\xA5\x52\xE1\xCD\x37\xDF\xE4\x3C\x67\x34\x1A\x01\xE0\x5D\x58\x84\x74\xE0\xA2\x3D\x03\xB9\x6B\x01\xDC\x69\x99\x78\xF7\xDD\x77\xE3\xC5\x17\x5F\x6C\xC7\x9F\x33\x18\x5D\x93\xC4\xC4\x44\x10\x11\x8E\x1F\x3F\x6E\xF3\x9E\x74\x3A\x9D\x0E\xF5\xF5\xF5\xE8\xD7\xAF\x1F\xFC\xFC\xFC\xF8\x31\x90\x61\x33\xBD\x7A\xF5\xC2\x91\x23\x47\x90\x9B\x9B\xDB\x22\xBD\xAE\xAE\x0E\xBD\x7A\xF5\xF2\x2B\x2F\x2F\x97\x02\x68\x75\x8B\xEE\x15\x2B\x56\xDC\x52\x84\xFB\xA1\xC9\xDD\xA2\xC5\xB0\x85\xB7\xB7\x37\xFE\xF3\x9F\xFF\xB0\x4F\x23\x06\xA3\x0D\x64\x32\x19\xE2\xE2\xE2\x50\x57\x57\x87\x03\x07\x0E\xD8\x94\x97\xC1\x60\x40\x7E\x7E\x3E\x34\x1A\x0D\x12\x13\x13\xD9\x92\x66\x27\x62\xE8\xD0\xA1\xF8\xE0\x83\x0F\xA0\xD3\xE9\x5A\xA4\x57\x55\x55\xC1\xC7\xC7\x67\xB0\x56\xAB\xFD\x1A\xC0\x35\xAE\xBF\xBD\xD5\x8A\x39\x09\x5A\x89\x13\xBC\x72\xE5\x4A\x44\x47\x47\x77\xDE\x6A\x06\xA3\x8B\x10\x1C\x1C\x8C\x3B\xEE\xB8\x03\x61\x61\x61\x36\xE7\x55\x5D\x5D\x8D\x3F\xFF\xFC\x13\x07\x0E\x1C\x40\x61\x61\x21\x0F\xD6\x31\xF8\xA0\x7B\xF7\xEE\x78\xE1\x85\x17\xAC\xD2\xF5\x7A\x3D\x02\x03\x03\x25\x00\x36\xA3\x0D\x27\x88\xB6\x44\xF8\x31\x00\x03\x2D\x13\xFB\xF5\xEB\x87\x85\x0B\x17\x76\xC2\x54\x06\xA3\x6B\x92\x90\x90\x80\x39\x73\xE6\xF0\x92\x57\x65\x65\x25\xF6\xEE\xDD\x8B\xCB\x97\x2F\xF3\x92\x1F\x83\x1F\x9E\x7A\xEA\x29\xA4\xA6\xA6\x5A\xA5\x5F\xBA\x74\x09\x71\x71\x71\x83\x01\x3C\xDC\xDA\xDF\xB6\x26\xC2\xA1\x68\xDA\x33\xAE\x05\x12\x89\x04\x9B\x37\x6F\x66\x3E\xC1\x0C\x46\x07\x88\x89\x89\xC1\xE3\x8F\x3F\x8E\x8C\x8C\x0C\x9B\x63\x04\x5F\xBC\x78\x11\x67\xCE\x9C\x01\xD0\x14\x4A\x91\xA8\x5D\x0B\xB3\x18\x76\xA6\x2D\xDF\xE1\xB2\xB2\x32\xC8\x64\xB2\x35\x00\x42\xB8\xFE\xB6\x35\x11\x7E\x19\x4D\x91\xD2\x5A\xF0\xD8\x63\x8F\x21\x3D\x3D\xDD\x16\x5B\x19\x8C\x2E\x49\x58\x58\x18\x7E\xFC\xF1\x47\x74\xEB\xD6\xCD\xE6\xBC\x6A\x6B\x6B\x71\xE6\xCC\x19\x1C\x3C\x78\x10\x8D\x8D\x1D\x0A\xDA\xC5\xB0\x23\x83\x07\x0F\xC6\xC3\x0F\x5B\x77\x78\x6B\x6B\x6B\x11\x1F\x1F\xEF\x8B\x26\x27\x07\x2B\xB8\xFC\x84\xFB\x02\x38\x06\x0B\x81\x0E\x0D\x0D\x45\x4E\x4E\x0E\x54\x2A\xAB\xE8\x95\x0C\x06\xA3\x9D\xCC\x99\x33\x07\x3B\x76\xEC\xE8\x74\x00\xF8\xE4\xE4\x64\xFC\xE5\x2F\x7F\xC1\xB0\x61\xC3\x30\x6C\xD8\x30\xF8\xFB\xFB\xF3\x12\x30\x88\xC1\x0F\xD5\xD5\xD5\x48\x4C\x4C\x44\x59\x59\x59\x8B\x74\xB1\x58\x0C\x5F\x5F\x5F\x63\x55\x55\x55\x3F\x00\xA7\x4D\xE9\xAD\xF9\x09\x2F\x07\x47\x0F\xF9\xE5\x97\x5F\x66\x02\xCC\x60\xD8\xC8\x82\x05\x0B\xD0\xB7\x6F\xDF\x0E\xFF\x5D\x44\x44\x04\x96\x2C\x59\x82\x57\x5E\x79\x05\xF3\xE6\xCD\xC3\xA0\x41\x83\x10\x18\x18\xC8\x04\xD8\xC9\xF0\xF3\xF3\xC3\xDA\xB5\xD6\x1D\x5E\xA3\xD1\x88\xE8\xE8\x68\x31\x00\xAB\x19\x3C\xCB\x9E\x70\x2A\x80\x93\x96\xE9\x7D\xFB\xF6\xC5\xB1\x63\xC7\x58\x81\x33\x18\x3C\xF0\xC2\x0B\x2F\x60\xDD\xBA\x75\xD0\x68\x34\xB7\xFC\xAD\x42\xA1\x40\x4A\x4A\x0A\x66\xCD\x9A\x85\x45\x8B\x16\xD9\xDF\x38\x86\xCD\x18\x8D\x46\xF4\xEB\xD7\x0F\xA7\x4F\x9F\x6E\x91\x2E\x16\x8B\xE1\xE7\xE7\x67\xBC\x7E\xFD\x7A\x2A\x80\x73\x00\x77\x4F\x78\x09\x38\x86\x28\x96\x2F\x5F\xCE\x04\x98\xC1\xE0\x89\xDB\x6E\xBB\x0D\x83\x06\x0D\x6A\xF3\x37\x32\x99\x0C\x31\x31\x31\x98\x38\x71\x22\x96\x2F\x5F\xCE\x04\xD8\x85\x10\x8B\xC5\x9C\x2E\x6B\x46\xA3\x11\x3D\x7A\xF4\x10\x03\x78\xC6\x3C\xDD\x5C\x70\x83\xD0\xB4\x63\xA8\xDC\xFC\x07\xA9\xA9\xA9\x38\x79\xF2\x24\x44\x22\x5B\x37\x66\x66\x30\x18\x40\xD3\xEA\xB7\x6D\xDB\xB6\x61\xEE\xDC\xB9\xAD\x7A\x37\x0C\x1E\x3C\x18\x6B\xD6\xAC\xC1\xC0\x81\x03\x21\x97\xCB\x21\x97\xCB\x39\x7F\xC7\x70\x4E\x8C\x46\x23\x52\x53\x53\xAD\xB6\xBB\x52\x2A\x95\x20\x22\x8D\x56\xAB\x8D\x00\x50\x65\xD9\x13\x9E\x05\x0B\x01\x06\x80\x25\x4B\x96\x30\x01\x66\x30\x78\x44\x26\x93\xE1\xDE\x7B\xEF\xC5\xE6\xCD\x9B\xAD\xCE\x45\x44\x44\xE0\xDE\x7B\xEF\xC5\x6B\xAF\xBD\x86\x61\xC3\x86\xC1\xDB\xDB\x9B\x09\xB0\x0B\x22\x16\x8B\xF1\xCC\x33\xCF\x58\xA5\x6B\x34\x1A\xF4\xE9\xD3\x47\x09\xE0\xE6\x76\xF4\xE6\xEA\x7A\x02\x16\x5B\x73\x04\x05\x05\xA1\xB8\xB8\x18\x0A\x85\xC2\x4E\xA6\x32\x18\x5D\x97\x6B\xD7\xAE\xE1\xF6\xDB\x6F\x47\x76\x76\x36\x94\x4A\x25\xA6\x4D\x9B\x86\xBF\xFC\xE5\x2F\x88\x8D\x8D\x65\xE1\x61\xDD\x00\xB5\x5A\x8D\xC8\xC8\x48\x54\x55\x55\xB5\x48\x4F\x4C\x4C\xC4\x85\x0B\x17\x8E\x02\x48\x27\x22\x98\x3C\xC7\x63\xC1\xB1\x37\xD2\xAC\x59\xB3\x98\x00\x33\x18\x76\x42\xA9\x54\xE2\xF9\xE7\x9F\xC7\xAF\xBF\xFE\x8A\xF0\xF0\x70\x3C\xF8\xE0\x83\x88\x8D\x8D\x15\xDA\x2C\x06\x4F\x78\x78\x78\x60\xF6\xEC\xD9\x56\x91\xD6\x72\x72\x72\x10\x12\x12\x32\xA0\xAC\xAC\x2C\x06\xC0\x65\x53\x4F\xF8\x69\x00\xEB\x2C\x33\x39\x71\xE2\x44\xA7\xDC\x69\x1C\x81\xE5\x58\x5A\x6B\x43\x26\x44\x74\xF3\xB7\x22\x91\x88\x0D\xAD\x30\x18\x4E\x8C\xBB\xB5\xD7\xA3\x47\x8F\x72\x2E\x70\x1B\x3C\x78\x30\x0E\x1E\x3C\xF8\x24\x11\xBD\x69\x1A\x13\x1E\x65\xF9\xA3\xD8\xD8\x58\xA7\x15\x60\xA3\xD1\x08\xBD\x5E\x0F\x9D\x4E\x07\x9D\x4E\x07\x83\xC1\xC0\x39\xC1\x41\x44\x30\x18\x0C\xB7\xFC\x1D\x83\xC1\x10\x1E\x53\xBB\x6E\x6C\x6C\x84\x4E\xA7\x33\xC5\xE4\x75\x69\x06\x0C\x18\x80\x98\x98\x18\xAB\x74\xBD\x5E\x0F\x34\xEB\xAE\x14\x4D\xD1\xD2\x86\x5A\xFE\xE8\xBE\xFB\xEE\xB3\xB3\x79\x9D\xC7\x68\x34\x42\xA7\xD3\xDD\x14\x54\x89\x44\x02\xA3\xD1\x08\x89\x44\x72\xF3\xCD\x29\x12\x89\x60\x30\x18\xA0\xD7\xEB\xA1\xD7\xEB\x41\x44\x90\xC9\x64\x10\x89\x44\x10\x8B\xC5\x4C\x8C\x19\x0C\x27\x42\x24\x12\xDD\x14\x60\xBD\x5E\x7F\xB3\x8D\x9A\xDA\xAB\xAB\x22\x12\x89\x30\x69\xD2\x24\xAB\x21\x89\xDC\xDC\x5C\x88\x44\xA2\xE1\x22\x91\x48\x2C\x05\x90\x06\xC0\x6A\x29\xDC\xA8\x51\x56\x9D\x63\xA7\xC0\x68\x34\xC2\x60\x30\xDC\x7C\x4B\x8A\x44\x22\x18\x8D\x46\x10\xD1\xCD\x34\x73\x81\x35\xFF\xB4\x31\xFF\x3B\x06\x83\xE1\x5C\x98\xB7\x6D\x22\xBA\xD9\xD1\x92\xCB\xE5\x2E\x1D\x34\x6C\xD4\xA8\x51\x56\x22\x5C\x53\x53\x83\x1E\x3D\x7A\xF8\xE5\xE7\xE7\xA7\x48\xD1\x14\xB8\xBD\x05\x62\xB1\x18\x43\x87\x5A\x75\x8E\x05\xC5\x34\x56\x24\x12\x89\xA0\x50\x28\xD8\x84\x21\x83\xC1\x70\x09\x86\x0F\x1F\x0E\x91\x48\x64\xF5\xF5\x1D\x19\x19\x89\xFC\xFC\xFC\x54\x29\x80\x64\xCB\x3F\x8A\x8B\x8B\x73\xBA\x38\x11\x7A\xBD\x1E\x5A\xAD\x16\x46\xA3\x11\x62\xB1\x18\x12\x89\xA4\xC3\x43\x0A\xEE\x30\xD0\xCF\x60\x74\x25\xCC\x27\xEA\x2C\x31\xB5\x65\xF3\x61\x49\xA9\x54\xEA\x74\xBD\x66\x3F\x3F\x3F\x74\xEF\xDE\x1D\xF9\xF9\xF9\x2D\xD2\x9B\xED\xEC\x23\x05\xD0\xC3\xF2\x8F\xE2\xE3\xE3\x1D\x63\x5D\x3B\x30\x0D\x1F\x34\x36\x36\xE2\xC6\x8D\x1B\xA8\xAE\xAE\x46\x6D\x6D\xED\xCD\x4F\x15\xCB\x99\x54\xD3\xB0\x04\x97\xF7\x84\x44\x22\x81\x58\x2C\x76\xE9\x31\x26\x06\xC3\x1D\x31\xB5\x65\x2E\xD1\xB5\xEC\x38\x99\xDA\xBA\x29\xDD\xD4\xDE\x83\x83\x83\x11\x19\x19\x09\x4F\x4F\x4F\xA7\xEB\x6C\xC5\xC6\xC6\x5A\x89\xB0\x56\xAB\x05\x80\x9E\x52\x00\x51\x96\x7F\xC0\x35\x9B\x27\x04\x26\x41\x15\x89\x44\xD0\xE9\x74\xA8\xA8\xA8\xC0\x85\x0B\x17\x70\xEC\xD8\x31\x14\x14\x14\xB4\x10\x53\xD3\xA4\x9C\xC1\x60\x40\x63\x63\x63\x0B\x21\x36\x1F\xE0\x97\x4A\xA5\x10\x8B\xC5\x4E\x57\x48\x0C\x46\x57\xC6\xE4\xC9\xC4\xE5\xC1\x64\xEA\x3C\x01\x2D\x05\x58\x22\x91\x40\xAF\xD7\x43\x22\x91\x40\xA5\x52\x61\xC8\x90\x21\x18\x31\x62\x04\x94\x4A\xA5\xD3\xF5\x86\x63\x63\x63\xF1\xCB\x2F\xBF\xB4\x48\xAB\xAB\xAB\x03\x80\x08\x29\x80\x08\xCB\x3F\x08\x0F\x0F\x77\x8C\x65\xB7\xC0\x54\x30\x44\x84\xBA\xBA\x3A\x94\x94\x94\xE0\xF4\xE9\xD3\xF8\xF9\xE7\x9F\x71\xEE\xDC\xB9\x16\xBB\x14\x98\x1E\xBA\xC9\x25\xCD\x7C\x02\xCE\xBC\xB7\x6C\x5E\xA0\x0C\x06\xC3\x39\x30\x75\xB8\x0C\x06\x83\xD5\x39\x4B\xAF\x27\x73\x11\x36\x18\x0C\x10\x89\x44\xF0\xF6\xF6\x46\x5D\x5D\x1D\xC2\xC3\xC3\x11\x12\x12\xE2\x74\x22\x1C\x19\x19\x69\x95\x56\x53\x53\x03\x00\x61\x52\x70\xEC\xA0\x11\x1C\x1C\x6C\x7F\xAB\xDA\x81\x49\x84\x45\x22\x11\x34\x1A\x0D\xCA\xCB\xCB\x71\xF9\xF2\x65\x5C\xBD\x7A\x15\x5A\xAD\xD6\xD4\x9D\xEF\x10\xCD\xFE\x79\x0C\x06\xC3\x45\xE0\x12\x66\x4B\xEA\xEB\xEB\x71\xE6\xCC\x19\xE4\xE7\xE7\x63\xF0\xE0\xC1\x4E\x37\x71\x1F\x14\x14\x64\x95\x56\x5B\x5B\x0B\x00\xFE\x52\x00\x1E\x96\x27\x03\x03\x03\xED\x6F\x55\x3B\x10\x8B\xC5\x90\xC9\x64\x90\xC9\x64\xF0\xF0\xF0\x80\x48\x24\xC2\xF5\xEB\xD7\x71\xE3\xC6\x0D\xA1\x4D\x63\x30\x18\x4E\x86\x54\x2A\x85\x5C\x2E\x77\xCA\xA1\xC6\x80\x80\x00\xAB\xB4\xE6\x0E\xA1\x54\x0C\x8E\xC8\x69\x1E\x1E\x56\xBA\x2C\x08\x22\x91\x08\x32\x99\x0C\x40\x53\x70\x6B\xB1\x58\x8C\x86\x86\x86\x76\x05\xC3\x66\x30\x18\x5D\x0B\x85\x42\x01\x4F\x4F\x4F\xA7\x1C\x6E\xE4\x1A\x1E\x51\xAB\xD5\x00\xE0\x29\x06\x60\xF5\x7D\xDE\xDC\x4D\x76\x2A\xCC\xDD\x51\xD8\x6A\x37\x06\x83\x61\x89\x44\x22\xB9\xB9\x2A\x16\xB0\x8E\x2F\x23\x24\x5C\x7B\x0A\x7A\x79\x79\x01\x40\x9D\x18\x40\x9D\xE5\xC9\xE6\x01\x63\xA7\xC2\xDC\x53\xC2\x19\x3F\x37\x18\x0C\x86\xB0\x58\xBA\x9F\x6A\xB5\x5A\xA7\x11\xE2\x66\x4F\x88\x16\x78\x7B\x7B\x03\x40\x8D\x18\xC0\x75\xCB\x93\xA5\xA5\xA5\xF6\xB7\x8A\xC1\x60\x30\x78\xC4\x7C\x55\xAD\x5A\xAD\x46\x6D\x6D\xAD\xD3\x88\xF0\xB5\x6B\xD7\xAC\xD2\x3C\x3D\x3D\x01\xA0\x56\x0C\xA0\xC2\xF2\x64\x49\x49\x89\xFD\xAD\xEA\x20\xE6\xEE\x65\xAC\x27\xCC\x60\x30\x2C\xD1\x6A\xB5\x68\x68\x68\x80\x5E\xAF\xE7\x5C\xB0\x25\x24\x5C\x9A\xDA\x3C\xF7\x56\x2D\x06\x90\x6F\x79\xD2\x72\x65\x87\x33\x60\x12\x61\xD3\x62\x0B\x06\x83\xC1\x30\xA7\xA6\xA6\x06\x57\xAF\x5E\x45\x43\x43\x03\xBC\xBC\xBC\x10\x14\x14\xE4\x34\x5A\xC1\xA5\xA9\xCD\x3D\xE1\xCB\x62\x00\x97\x2C\x4F\x5E\xBC\x78\xD1\xFE\x56\x75\x10\x99\x4C\x06\x7F\x7F\x7F\x84\x86\x86\xC2\xC7\xC7\xCA\xB5\x99\xC1\x60\x74\x71\x42\x43\x43\x11\x1E\x1E\x7E\xD3\xA3\xCA\x59\x04\x18\xE0\xD6\xD4\x66\x8F\x89\x4B\x52\x00\x67\x2D\x4F\x16\x16\x16\xE2\xFA\xF5\xEB\x9C\xBE\x6D\x42\xA1\x50\x28\x10\x16\x16\x86\xD4\xD4\x54\xE4\xE7\xE7\xE3\xDC\xB9\x73\xAD\xAE\x7E\x63\xC3\x15\x0C\x86\xFB\xC0\xD5\x9E\x4D\x43\x0D\x7A\xBD\x1E\x4A\xA5\x12\x21\x21\x21\x18\x31\x62\x04\xFA\xF4\xE9\x63\xEA\x61\x3A\x0D\xE5\xE5\xE5\x28\x2E\x2E\xB6\x4A\xD7\xE9\x74\x00\x70\x56\x8A\xA6\x0D\x3E\x5B\x40\x44\xD8\xB7\x6F\x1F\xEE\xBE\xFB\x6E\xFB\x5B\xD8\x4E\xC4\x62\x31\x02\x02\x02\x90\x96\x96\x06\x89\x44\x72\x33\xD4\xA6\xF9\xD8\x8F\xF9\x90\x85\x09\xCB\xA0\x20\xE6\x05\x6A\x99\x66\xFE\xEF\xD6\x7E\x6F\xFE\xDB\x8E\x9C\x6B\x2D\x5F\x5B\xAF\xD9\x99\x7C\x85\xB8\xA6\xA3\x9F\x9F\xF9\x78\x20\x57\xBE\x5C\xF9\x70\xB9\x36\x09\x95\x6F\x57\xB9\x66\x5B\x7F\x6B\x9A\xFF\x31\xFD\xD7\x3C\x16\x8C\xC9\x5B\xCA\x68\x34\x42\x2A\x95\x42\xA5\x52\x21\x2D\x2D\xCD\x29\x97\x2C\xEF\xDB\xB7\x8F\x73\x7C\xBA\x79\x9C\xF8\xA4\x14\x40\x36\x9A\x3C\x24\x5A\x74\x7B\x7F\xFA\xE9\x27\xA7\x12\x61\x91\x48\x04\x5F\x5F\x5F\xF4\xEA\xD5\x0B\x71\x71\x71\x37\x63\x4A\x98\xCF\x88\x02\xD6\x6E\x2A\x96\x01\xDE\x2D\xFD\x8C\x6F\xE5\x53\xC8\x15\x07\xB4\x3D\x7F\xDB\xD9\x73\xE6\xE7\xB9\x7E\xD3\xD9\x73\xF6\xCC\xD7\xFC\x37\xF6\x78\x16\xCE\x34\xC1\xC2\xB0\x0F\xE6\x75\xCC\xBC\xFD\xB6\xE6\x92\x6A\x1E\x57\xC6\xD4\xE6\x7D\x7D\x7D\xA1\x52\xA9\x9C\xEE\x4B\x78\xD7\xAE\x5D\x56\x69\x01\x01\x01\xB8\x72\xE5\x4A\x39\x80\x1C\x93\xB5\xDF\x00\x68\xA1\xB8\x31\x31\x31\xC8\xCF\xCF\x77\x9A\x1B\x32\xBD\xF9\x98\x77\x04\x83\xC1\x70\x15\x8C\x46\x23\xA2\xA3\xA3\xAD\xBC\x23\x06\x0C\x18\x80\x63\xC7\x8E\x7D\x45\x44\xF7\x99\xBE\xDB\x7F\x82\x85\x08\x5F\xBE\x7C\xB9\xD5\x9D\x42\x85\xC0\x34\xD4\xD0\x19\x4C\x6F\x4D\xF3\x6D\x90\x88\x08\x52\xA9\xB4\x45\xEF\xD8\x94\xBF\x69\x8F\x2B\xB1\x58\x7C\xF3\xB7\xA6\x7F\x9B\x02\x00\x99\xF6\xB5\x33\xF5\xC2\x4D\x11\x9D\x4C\x9F\x47\xA6\xEB\x98\x7E\x6B\xB2\xC1\x14\x11\xCA\x3C\x5F\x91\x48\x64\x75\x4D\xD3\x3D\x5B\x5E\xD3\xBC\x27\xCF\x75\x4D\xD3\x39\xD3\x1E\x5D\x06\x83\xE1\xE6\xF0\x8C\x79\xBE\xE6\xD7\x34\xE5\x63\x7E\xCE\xF4\x6F\xA9\x54\xDA\x62\xC8\xC7\x64\x9F\xE5\x7D\x9A\x6C\xB5\xBC\x4F\x53\x3E\x96\xF7\x69\xBA\xA6\xF9\x33\xB0\xBC\xA6\x79\xBE\xE6\xD7\x04\x70\x33\xB0\x93\xE9\x85\x6C\xBA\xA6\xE9\x79\x99\xFE\xCE\xFC\xB7\x5C\xD7\x34\xE5\x2B\x93\xC9\x6E\xFE\xBF\xF9\xE7\xAF\xF9\xF3\x33\xE5\x63\xCA\xD7\xFC\x5E\x4C\xD7\x34\xD9\x63\x7A\xD6\x52\xA9\xB4\xC5\x35\x4D\xE7\xCC\xEB\x9F\xE9\x9A\xA6\xBA\x6A\xBE\x5F\xA2\xE5\x7D\x9A\x7E\x6B\x5E\x2F\xCC\xF3\xB5\xAC\x8B\xA6\x3A\x6D\x5E\xC7\x2D\xCB\xC8\xFC\x9A\x96\xF5\xDF\xBC\x7C\x4D\xF7\xD9\x9E\xBA\x68\x7E\x9F\x6D\x5D\xD3\x74\x1D\xF3\x7A\xD2\x1E\x57\x54\xD3\x3E\x93\x3A\x9D\x0E\x62\xB1\xF8\x66\x6C\x19\x67\x63\xCF\x9E\x3D\x9C\xEE\x69\xCD\x93\x87\xBB\x80\xA6\x8D\x3E\x01\xE0\x3F\x00\xDE\x01\xD0\xE2\x2E\x3E\xFE\xF8\x63\xA7\x11\x61\x5B\xB0\x1C\x57\x32\x8F\x4D\x6A\xC2\x24\xA6\xE6\x07\xF0\x5F\x31\x33\xA5\x99\x2A\x98\xB9\xE8\x98\x7E\x67\xCA\xDF\xF4\xB7\xA6\xCA\x67\xFA\x9D\x79\xC5\xB2\xCC\xD7\x94\x6E\xDE\xC8\x4D\xFF\x96\xC9\x64\x56\xE3\xA4\xA6\x73\x96\xD7\xB4\xC4\x74\x4D\xCB\x7C\x01\xDC\x5C\xE2\xC9\xF5\xC9\xC7\xF5\x2C\xCC\xCF\x99\x1A\x8A\xE5\x7D\x59\x5E\xD3\xF2\xEF\xCD\xAF\x69\x9E\x9F\xF9\x7F\x2D\xC7\x02\xCD\x9F\x97\xE5\x73\xE3\xBA\xA6\x79\x19\x59\xDE\x0B\xD7\x35\xCD\x1B\x3D\xD7\xBD\xB4\x76\x4D\xF3\x7B\xB1\xBC\xA6\xE5\x33\xB0\x1C\x32\xB3\xBC\xA7\xF6\xD4\xC5\x5B\xDD\xA7\x79\xBE\x5C\xF5\xA2\xB5\xBA\xC8\x65\x6F\x6B\xF7\x62\x79\xCD\xB6\xEA\xBF\x65\x99\xB5\xF7\x9A\xED\xF9\xDA\x35\x05\xF7\x32\xBD\x38\xCD\x5F\x96\xCE\xC4\x27\x9F\x7C\x62\x95\x26\x16\x8B\x91\x9D\x9D\x6D\x04\xF0\x2D\xD0\x52\x74\x0F\x03\x68\xA1\xB8\x81\x81\x81\x28\x2E\x2E\x86\x52\xA9\xB4\xA7\x9D\x0E\xC3\x72\x3C\x98\xC1\x60\x38\x17\xAD\x8D\x01\xB7\x86\x69\x77\x66\xD3\x66\xA0\xCE\xD4\x1B\x56\xAB\xD5\x88\x88\x88\x40\x75\x75\x75\x8B\xF4\xD4\xD4\x54\x9C\x3E\x7D\xFA\x57\x00\xA3\x89\x08\xE6\xAF\x8E\x8F\x61\x21\xC2\x95\x95\x95\xF8\xF8\xE3\x8F\xF1\xD0\x43\x0F\xD9\xDD\x60\x47\xD0\xD1\x02\x66\x30\x18\xCE\x8D\x5C\x2E\x87\x5C\x6E\x15\x08\xD2\x29\xF8\xF0\xC3\x0F\xAD\x04\x18\x80\x29\xD6\xF1\xCD\x2E\xB2\xB9\x22\x05\x02\xB8\x02\xA0\x45\x34\xE4\x9E\x3D\x7B\xE2\xC2\x85\x0B\x4E\xE5\xF8\xCC\x60\x30\x18\xCE\x8C\x5E\xAF\x47\x52\x52\x12\xF2\xF2\xF2\x5A\xA4\x37\x8F\x2A\x68\x34\x1A\x4D\x38\x80\x6A\x22\x82\xB9\xB2\x56\x02\xF8\xC8\x32\xB3\x8B\x17\x2F\xE2\xCB\x2F\xBF\xB4\xA7\xBD\x0C\x06\x83\xE1\x56\x7C\xF1\xC5\x17\x56\x02\x0C\x00\x7D\xFA\xF4\x81\x46\xA3\xF9\x27\x80\x6A\x53\x9A\xE5\xB7\x79\x4F\x00\x17\x80\x16\xE2\x8C\xB4\xB4\x34\x1C\x3B\x76\xCC\xE9\x9C\xA0\x19\x0C\x06\xC3\xD9\xD0\xEB\xF5\xE8\xDB\xB7\x2F\xCE\x9D\x3B\xD7\x22\x5D\x2A\x95\xC2\xC7\xC7\xC7\x50\x55\x55\x95\x08\x20\x0F\x68\x9E\x2C\xB5\xF8\xFB\x8B\x00\xAC\xBA\xBD\xA7\x4E\x9D\xC2\x96\x2D\x5B\xEC\x65\x33\x83\xC1\x60\xB8\x0D\xEF\xBE\xFB\xAE\x95\x00\x03\x4D\xBD\xE0\xAA\xAA\xAA\x9D\x68\x16\x60\x13\x5C\xB3\x54\x69\x00\x8E\xC3\xA2\x37\x1C\x18\x18\x88\x0B\x17\x2E\x38\xCD\xFE\x73\x0C\x06\x83\xE1\x6C\x54\x56\x56\x22\x21\x21\x01\xD7\xAF\xB7\x0C\xD3\x2E\x95\x4A\xE1\xEB\xEB\x6B\xA8\xAC\xAC\x4C\x03\x70\x53\xA1\xB9\x7A\xC2\x00\x70\x0A\xC0\x66\xAE\xCC\x97\x2F\x5F\xCE\xB7\xCD\x0C\x06\x83\xE1\x36\x3C\xF7\xDC\x73\x56\x02\x0C\x00\xFD\xFA\xF5\x43\x65\x65\xE5\x46\x98\x09\xB0\x89\xD6\xFC\xB5\x02\x01\xE4\xC0\x22\x9E\x84\x48\x24\xC2\xEE\xDD\xBB\x31\x6A\xD4\x28\x1E\xCC\x65\x30\x18\x0C\xF7\xE1\xBB\xEF\xBE\xC3\x3D\xF7\xDC\x63\xB5\x16\xC1\xCF\xCF\x0F\x6A\xB5\xFA\xBA\x56\xAB\x8D\x87\xC5\x4E\x46\xAD\xF5\x84\x81\x26\x4F\x89\x17\x2C\x13\x89\x08\x73\xE6\xCC\x41\x65\x65\x25\x5F\x76\x33\x18\x0C\x86\xCB\x53\x5A\x5A\x8A\x07\x1F\x7C\x90\x73\x31\x58\x60\x60\x20\xB4\x5A\xED\xDF\xC0\xB1\x95\x1C\x80\x56\x45\x18\x00\xDE\x05\xF0\xAB\x65\x62\x61\x61\x21\x1E\x78\xE0\x81\x9B\x6B\xBD\x19\x0C\x06\xA3\x2B\x63\x30\x18\x30\x7B\xF6\x6C\x94\x97\x97\x5B\x9D\x6B\xF6\x15\xFE\x0E\xC0\x07\xAD\xFD\x7D\x5B\x22\x4C\x00\xE6\x00\xA8\xB2\x3C\xF1\xC3\x0F\x3F\x60\xC9\x92\x25\x9D\x30\x97\xC1\x60\x30\xDC\x8B\xA5\x4B\x97\xE2\xE7\x9F\x7F\xB6\x4A\x0F\x0C\x0C\xC4\xC5\x8B\x17\xAF\x01\x78\x10\x4D\x7A\xCA\xC9\xAD\x96\xC1\x15\x02\x98\x01\xC0\x68\x79\xE2\x8D\x37\xDE\xC0\xA6\x4D\x9B\x3A\x66\x2D\x83\xC1\x60\xB8\x11\x9B\x36\x6D\xC2\xAB\xAF\xBE\x6A\x95\xDE\x1C\xC7\xC2\xA8\xD7\xEB\x1F\x00\x60\xDD\x45\x36\xA3\x3D\x6B\x91\x7F\x00\xF0\x0C\xD7\x89\x05\x0B\x16\x60\xED\xDA\xB5\x2C\x28\x0E\x83\xC1\xE8\x52\x10\x11\x56\xAF\x5E\x8D\x05\x0B\x16\x70\x9E\x8F\x88\x88\x40\x45\x45\xC5\x73\x00\xAC\xBB\xC8\x16\x74\x24\x9A\xCD\xBB\x00\x1E\xE5\x3A\x31\x7D\xFA\x74\x6C\xDE\xBC\x19\xDE\xDE\xDE\x1D\xC8\x8E\xC1\x60\x30\x5C\x8F\xBA\xBA\x3A\xCC\x9B\x37\x0F\x9F\x7D\xF6\x19\xE7\xF9\xE8\xE8\x68\x14\x15\x15\x6D\x02\xF0\xD8\xAD\xF2\x22\xA2\x0E\x89\xB0\x04\xC0\x4E\x00\xF7\x72\x9D\x4C\x4A\x4A\xC2\xA7\x9F\x7E\x8A\xB4\xB4\xB4\x0E\x64\xC9\x60\x30\x18\xAE\xC3\xF1\xE3\xC7\x31\x7D\xFA\x74\x5C\xB8\x70\x81\xF3\x7C\x44\x44\x04\x4A\x4A\x4A\xBE\x02\x30\x05\xC0\x2D\xBD\x17\xDA\x72\x51\xE3\xC2\x00\x60\x2A\x80\x1D\x5C\x27\xB3\xB3\xB3\x91\x91\x91\x81\x97\x5E\x7A\x09\x8D\x8D\x8D\x1D\xC8\x96\xC1\x60\x30\x9C\x9B\xC6\xC6\x46\xAC\x58\xB1\x02\x83\x07\x0F\x6E\x55\x80\xC3\xC2\xC2\x50\x52\x52\xF2\x35\x80\x69\x68\x87\x00\x9B\xE8\x4C\x70\x5D\x09\x80\x2D\x00\xE6\xB6\xF6\x83\x94\x94\x14\xBC\xFD\xF6\xDB\x18\x3D\x7A\x74\x27\xB2\x67\x30\x18\x0C\xE7\xE1\xA7\x9F\x7E\xC2\xA2\x45\x8B\x90\x9D\x9D\xDD\xEA\x6F\x82\x83\x83\x51\x5E\x5E\xBE\x0D\x4D\x1E\x65\xBA\xF6\xE6\xDD\xD1\x9E\xB0\x09\x03\x80\x79\x00\xD6\xB6\xF6\x83\xF3\xE7\xCF\x63\xCC\x98\x31\x18\x3F\x7E\x3C\x8E\x1D\x3B\xD6\x89\x4B\x30\x18\x0C\x86\xB0\x1C\x3D\x7A\x14\x77\xDE\x79\x27\xC6\x8D\x1B\xD7\xAA\x00\x8B\x44\x4D\xBB\xC0\x97\x97\x97\xAF\x06\xF0\x00\x3A\x20\xC0\x37\xF3\xB0\xD1\xCE\xE9\x00\xFE\x01\xA0\xCD\xFD\x8F\xEE\xBC\xF3\x4E\x2C\x5E\xBC\x18\x63\xC6\x8C\x61\x3B\x5B\x30\x18\x0C\xA7\xC5\x68\x34\x62\xF7\xEE\xDD\x78\xED\xB5\xD7\x38\x7D\x7F\xCD\x51\x28\x14\x30\x1A\x8D\x1A\x9D\x4E\xF7\xBF\x00\xB8\x67\xE9\x6E\x41\x47\x27\xE6\x5A\x23\x09\xC0\x57\xCD\xFF\x6D\x93\xF8\xF8\x78\xFC\xEF\xFF\xFE\x2F\xFE\xFA\xD7\xBF\xA2\x47\x8F\x1E\x3C\x5C\x9A\xC1\x60\x30\x6C\xE7\xD2\xA5\x4B\xD8\xBE\x7D\x3B\x3E\xFC\xF0\x43\xCE\x60\xEC\x96\xF8\xF8\xF8\xA0\xB6\xB6\xF6\x3C\x80\xFB\xD0\x14\x83\xBD\x53\xF0\x25\xC2\x00\x20\x07\xB0\x1C\xC0\xB3\x68\x1A\x33\x6E\x13\x91\x48\x84\xA4\xA4\x24\x8C\x19\x33\x06\xC3\x86\x0D\x43\x46\x46\x06\xC2\xC2\xC2\xDC\x66\x43\x51\x06\x83\xE1\xBC\x68\x34\x1A\x5C\xBD\x7A\x15\x87\x0E\x1D\xC2\xBE\x7D\xFB\xF0\xCB\x2F\xBF\x20\x3B\x3B\xBB\x5D\xEB\x1D\x9A\x17\x61\x18\xF4\x7A\xFD\x6A\x00\x2F\xA1\x13\xC3\x0F\xE6\xF0\x29\xC2\x26\x52\xD0\x34\x3C\x31\xB8\x23\x7F\x24\x95\x4A\xD1\xAB\x57\x2F\x0C\x1C\x38\x10\xC9\xC9\xC9\xE8\xD1\xA3\x07\xA2\xA2\xA2\x10\x12\x12\x02\x5F\x5F\x5F\x78\x78\x78\x30\x81\x66\x30\x18\xED\x46\xAD\x56\x43\xA3\xD1\xA0\xA6\xA6\x06\x65\x65\x65\x28\x2A\x2A\x42\x41\x41\x01\xCE\x9F\x3F\x8F\x63\xC7\x8E\xE1\xDC\xB9\x73\xD0\xEB\xF5\x1D\xCA\xD3\xC3\xC3\x03\x6A\xB5\x7A\x1F\x80\x87\x00\xB4\x3E\x4B\xD7\x01\xEC\x21\xC2\x26\xC6\x01\x78\x1B\x40\xBC\x9D\xF2\x67\x30\x18\x0C\x87\xA0\x50\x28\xA0\xD5\x6A\x73\x00\xFC\x1F\x80\x5D\x7C\xE6\xDD\x59\xEF\x88\xF6\xF0\x23\x80\x04\x34\x89\xF1\x71\x3B\x5D\x83\xC1\x60\x30\xEC\x82\x48\x24\x82\x54\x2A\x25\x00\xC7\xB4\x5A\xED\x1D\x00\x12\xC1\xB3\x00\xDF\xBC\x96\x3D\x32\xE5\x20\x1E\xC0\x53\x68\x72\x62\xF6\x73\xD0\x35\x19\x0C\x06\xA3\x43\xC8\x64\x32\xE8\x74\xBA\x6A\x00\x9F\x00\x78\x03\x16\xFB\xC1\xF1\x8D\x3D\x87\x23\x5A\x43\x04\xA0\x1F\x9A\xFC\x8C\xC7\x03\xE8\x86\xF6\x05\x11\x62\x30\x18\x0C\xDE\x11\x8B\xC5\x20\x22\x23\x11\x5D\x06\xF0\x3D\x80\x7F\x02\x38\x81\x36\x42\x4F\xF2\x89\x10\x22\x6C\x89\x1C\xC0\x00\x00\x13\x00\x64\x00\xE8\x01\x20\x08\x80\x27\x00\x19\x9A\x44\x5B\x68\x1B\x19\x0C\x86\x6B\x43\xCD\x87\x0E\x40\x3D\x9A\x76\x0E\xBA\x04\xE0\x30\x9A\xA2\x44\x1E\x03\x20\x48\xAC\x05\x22\x82\x88\x85\xA1\x64\x30\x18\x0C\xE1\xF8\xFF\x6F\x04\x6A\x58\xF8\xCB\xFB\x99\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82"
}

velocity_indication.interval = 0
velocity_indication.image_size = vector(34, 30)
velocity_indication.image = render.load_image('<?xml version="1.0" encoding="utf-8"?><!-- Generator: Adobe Illustrator 16.0.3, SVG Export Plug-In . SVG Version: 6.00 Build 0)  --><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"><svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="32px"	 height="32px" viewBox="0 0 32 32" enable-background="new 0 0 32 32" xml:space="preserve"><symbol  id="dude-transit" viewBox="0 -25.1 21.25 25.118">	<path fill-rule="evenodd" clip-rule="evenodd" fill="#FFFFFF" d="M15.5-4.2l0.75-1.05l1-3.1l3.9-2.65v-0.05		c0.067-0.1,0.1-0.233,0.1-0.4c0-0.2-0.05-0.383-0.15-0.55c-0.167-0.233-0.383-0.35-0.65-0.35l-4.3,1.8l-1.2,1.65l-1.5-3.95		l2.25-5.05l-3.25-6.9c-0.267-0.2-0.633-0.3-1.1-0.3c-0.3,0-0.55,0.15-0.75,0.45c-0.1,0.133-0.15,0.25-0.15,0.35		c0,0.067,0.017,0.15,0.05,0.25c0.033,0.1,0.067,0.184,0.1,0.25l2.55,5.6L10.7-14l-3.05-4.9L0.8-18.7		c-0.367,0.033-0.6,0.184-0.7,0.45c-0.067,0.3-0.1,0.467-0.1,0.5c0,0.5,0.2,0.767,0.6,0.8l5.7,0.15l2.15,5.4l3.1,5.65L9.4-5.6		c-1.367-2-2.1-3.033-2.2-3.1C7.1-8.8,6.95-8.85,6.75-8.85C6.35-8.85,6.1-8.667,6-8.3C5.9-8,5.9-7.8,6-7.7H5.95l2.5,4.4l3.7,0.3		L14-3.5L15.5-4.2z M14.55-2.9c-0.333,0.4-0.45,0.85-0.35,1.35c0.033,0.5,0.25,0.9,0.65,1.2S15.7,0.066,16.2,0		c0.5-0.067,0.9-0.3,1.2-0.7c0.333-0.4,0.467-0.85,0.4-1.35c-0.066-0.5-0.3-0.9-0.7-1.2c-0.4-0.333-0.85-0.45-1.35-0.35		C15.25-3.533,14.85-3.3,14.55-2.9z"/></symbol><g id="Layer_1">	<path fill="#FFFFFF" d="M16.041,3.33L1.081,30.039H31L16.041,3.33z M17.5,27.059h-3v-2.288h3V27.059z M14.5,22.473v-10.17h3v10.17		H14.5z"/></g><g id="Layer_2"></g></svg>', vector(35, 35))
velocity_indication.drawBar = function(modifier, x, y, r, g, b, a, text)
	velocity_indication.interval = velocity_indication.interval + (1-modifier) * 0.7 + 0.3
	local warningAlpha = math.abs(velocity_indication.interval*0.01 % 2 - 1) * 255
	
	local text_width = 95
	local sw, sh = x, y
	--local x, y = sw/2-text_width, sh*0.35
	local iw, ih = velocity_indication.image.width, velocity_indication.image.height

	-- icon
	render.texture(velocity_indication.image, vector(x - 3, y - 4), vector(iw + 6, ih + 6), color(16, 16, 16, 255*a), 'f', 0)
	if a > 0.7 then
        render.rect(vector(x+13, y+11), vector((x+13) + (8), (y+11) + (20)), color(16, 16, 16, 255*a))
	end

    render.texture(velocity_indication.image, vector(x, y), vector(35, 35), color(r, g, b, warningAlpha), 'f', 0)

	-- text
    render.text(aimbot_logger.font, vector(x + iw + 8, y + 3), color(255, 255, 255, 255*a), '', string.format('%s %d%%', text, modifier * 100))

	-- bar
	local rx, ry, rw, rh = x + iw + 8, y + 3 + 17, text_width, 12

	--renders.rectangle_outline(rx, ry, rw, rh, 0, 0, 0, 255*a, 1)
	--renders.rectangle(rx+1, ry+1, rw-2, rh-2, 16, 16, 16, 180*a)
	--renders.rectangle(rx+1, ry+1, math.floor((rw-2)*modifier), rh-2, r, g, b, 180*a)

    render.rect_outline(vector(rx, ry), vector(rx + rw, ry + rh), color(0, 0, 0, 255*a), 1)
    render.rect(vector(rx+1, ry+1), vector((rx+1) + (rw-2), (ry+1) + (rh-2)), color(16, 16, 16, 180*a))
    render.rect(vector(rx+1, ry+1), vector((rx+1) + (math.floor((rw-2)*modifier)), (ry+1) + (rh-2)), color(r, g, b, 180*a))
end

velocity_indication.handle = function()
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local velocity_indication_enable = ui_handler.elements["interface"]["screen_indication"] and ui_handler.refs["interface"]["screen_indication_settings"].ref:get("Velocity")
    local pos = vector(ui_handler.elements["drag"]["velocity_indication_pos_x"], ui_handler.elements["drag"]["velocity_indication_pos_y"])

    local m_flVelocityModifier = animations.new("m_flVelocityModifier", ui.get_alpha() > 0 and player.m_flVelocityModifier == 1 and 0.5 or player:is_alive() and player.m_flVelocityModifier or 1)

    local anim = {}

    anim.main = animations.new("velocity_indication", velocity_indication_enable and (ui.get_alpha() > 0.5 and 255 or m_flVelocityModifier < 0.9 and 255 or 0) or 0)

    if anim.main < 1 then
        return
    end

    local size = vector(155, 57)
    local clr = color(255 - m_flVelocityModifier * 255, m_flVelocityModifier * 255, 0, 255)

    velocity_indication.drawBar(m_flVelocityModifier, pos.x, pos.y, clr.r, clr.g, clr.b, anim.main, 'Slowed down')
    drag.handle(pos.x - 10, pos.y - 10, size.x, size.y, "velocity_indication", anim.main)
end

--[[local country = { --default country api
    main = json.decode(network.get("http://ip-api.com/json/"))
}]]

widgets.font = render.load_font("Verdana", 10, "bda")
widgets.container = function(item, clr, text, width, height, vec)
    width = width or 0
    height = height or 0

    local adoptation = vector(0, 0) --(item == "aimbot_logger" and render.measure_text(widgets.font, nil, "asylum: ") or vector(0, 0))

    local text_size = vector(adoptation.x, 0) + render.measure_text(1, nil, text) + vector(width + 8, height + 8)

    local tbl = {
        ["watermark"] = vector(defines.screen_size.x - text_size.x - 10, 10),
        ["aimbot_logger"] = vector(defines.screen_size.x - text_size.x, defines.screen_size.y/1.2)
    }

    local pos = vec and vec - vector(text_size.x/2, 0) or tbl[item] or vector(ui_handler.elements["drag"][item .. "_pos_x"], ui_handler.elements["drag"][item .. "_pos_y"])
    --render.shadow(pos, pos + text_size, clr, 20, 0)

    if item ~= "aimbot_logger" then
        render.rect(pos, pos + text_size, color(17, 17, 17, clr.a/3))
        render.rect(pos + vector(0, 2), pos + vector(text_size.x, 0), clr, 0, true)
    end
    
    --render.gradient(pos + vector(0, text_size.y - 2), pos + vector(text_size.x/2, text_size.y), clr:override("a", 0), clr, clr:override("a", 0), clr)
   -- render.gradient(pos + vector(text_size.x/2, text_size.y - 2), pos + text_size, clr, clr:override("a", 0), clr, clr:override("a", 0))

    render.text(1, pos + vector(width / 2 + 5 + adoptation.x, 4), colors.white:override("a", clr.a), nil, text)

    if item ~= "watermark" and item ~= "aimbot_logger" then
        drag.handle(pos.x, pos.y, text_size.x, text_size.y, item)
    end
end

widgets.branded_watermark = {}
--widgets.branded_watermark.img = render.load_image_from_file(images.eva.path, images.eva.size)
widgets.branded_watermark.handle = function()

    local widgets_branded_watermark = ui_handler.refs["interface"]["solus_settings"].ref:get("Branded Watermark")
    local design_username = ui_handler.elements["interface"]["design_username"]
    local design_accent_color = ui_handler.elements["interface"]["design_accent_color"]
    local design_breath_color = ui_handler.elements["interface"]["design_breath_color"]
    local pos = vector(5, defines.screen_size.y/2)
    local anim = {}
    anim.main = animations.new("widgets_branded_watermark", widgets_branded_watermark and 255 or 0)
    
    if anim.main < 1 then
        return
    end

    render.texture(widgets.branded_watermark.img, pos + vector(6, -16), images.eva.size)

    local text = defines.colored_text({"ASYLUM"}, {".CODES", design_accent_color})
    local text2 = defines.colored_text({"USER - " .. design_username:upper()}, {" [STABLE]", design_accent_color})
    local text_size = render.measure_text(2, nil, "USER - " .. common.get_username():upper() .. " [STABLE]") + vector(30, 0)

    
    render.text(2, pos + vector(35, 5), colors.white:override("a", anim.main), nil, text)
    render.text(2, pos + vector(35, text_size.y + 2), colors.white:override("a", anim.main), nil, text2)
end

widgets.watermark = {}
widgets.watermark.handle = function()
    local widgets_watermark = ui_handler.refs["interface"]["solus_settings"].ref:get("Watermark")
    local design_username = ui_handler.elements["interface"]["design_username"]
    local design_accent_color = ui_handler.elements["interface"]["design_accent_color"]
    local design_breath_color = ui_handler.elements["interface"]["design_breath_color"]
    
    local anim = {}
    anim.main = animations.new("widgets_watermark", widgets_watermark and 255 or 0)

    if anim.main < 1 then
        return
    end

    local ping = tostring(defines.get_ping())

    local text = defines.colored_text({"asylum | " .. design_username .. " | delay: "}, {ping}, {"ms | " .. common.get_date("%H:%M:%S", common.get_unixtime())})
    widgets.container("watermark", design_accent_color:override("a", anim.main), text)
end

widgets.keybinds = {}
widgets.keybinds.get = function()
    local binds = {}
    local cheat_binds = ui.get_binds()

    for i = 1, #cheat_binds do
        table.insert(binds, 1, cheat_binds[i])
    end

    return binds
end

widgets.keybind_names = {
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
    ['Force Thirdperson'] = 'Thirdperson'
}

widgets.upper_to_lower = function(str)
    str1 = string.sub(str, 2, #str)
    str2 = string.sub(str, 1, 1)
    return str2:upper() .. str1:lower()
end

widgets.keybinds.width = 0
widgets.keybinds.handle = function()
    local widgets_keybinds = ui_handler.refs["interface"]["solus_settings"].ref:get("Keybinds")
    local design_accent_color = ui_handler.elements["interface"]["design_accent_color"]
    local design_breath_color = ui_handler.elements["interface"]["design_breath_color"]
    
    local anim = {}
    anim.work_binds = {}

    local width = 135
    local add_y = 23
    local text = "keybinds"
    local binds = widgets.keybinds.get()
    local pos = vector(ui_handler.elements["drag"]["keybinds_pos_x"], ui_handler.elements["drag"]["keybinds_pos_y"])

    anim.binds = {}
    for _, bind in pairs(binds) do
        local name = widgets.keybind_names[bind.name] == nil and widgets.upper_to_lower(bind.name) or widgets.keybind_names[bind.name]
        local state = type(bind.value) ~= "number" and type(bind.value) ~= "string" and (bind.mode == 1 and "holding" or "toggled") or bind.value
        local colored_state = "[" .. state .. "]"

        if anim.binds[name] == nil then
            anim.binds[name] = {}
            anim.binds[name].alpha = 255
        end

        anim.binds[name].alpha = animations.new("keybinds_" .. name, widgets_keybinds and bind.active and 255 or 0)

        if anim.binds[name].alpha > 1 then     
            render.text(1, pos + vector(2, add_y), colors.white:override("a", anim.binds[name].alpha), nil, name)
            render.text(1, pos + vector(widgets.keybinds.width - render.measure_text(1, nil, "[" .. state .. "]").x + 50, add_y), colors.white:override("a", anim.binds[name].alpha), nil, colored_state)

            local text_size_name  = render.measure_text(1, nil, name).x
            local text_size_state = render.measure_text(1, nil, "[" .. state .. "]").x
            
            if ((text_size_name+21) + text_size_state) > width then
                width = (text_size_name+21) + text_size_state
            end

            if bind.active then
                table.insert(anim.work_binds, name)
            end

            add_y = add_y + 15
        end
    end

    widgets.keybinds.width = width - render.measure_text(1, nil, text).x
    anim.main = animations.new("widgets_keybinds", widgets_keybinds and (#anim.work_binds > 0 or ui.get_alpha() > 0.5) and 255 or 0)

    if anim.main > 1 then
        widgets.container("keybinds", design_accent_color:override("a", anim.main), text, widgets.keybinds.width)
    end
end

widgets.spectators = {}
widgets.spectators.get = function()
    local spectators = {}

    local local_player, target = entity.get_local_player()

    if local_player ~= nil then
        if local_player.m_hObserverTarget then
            target = local_player.m_hObserverTarget
        else
            target = local_player
        end

        local players = entity.get_players(false, false)

        if players ~= nil  then
            for k, player in pairs(players) do
                local obtarget = player.m_hObserverTarget

                if (obtarget and obtarget == target) and player ~= local_player then
                    table.insert(spectators, player)
                end
            end
        end
    end

    return spectators
end

skeet_indication.spectators = function()
    if not ui_handler.elements["interface"]["skeet_indication"] or not ui_handler.elements["interface"]["skeet_indication_spectators"] then
        return
    end

    local add_y = 0
    local spectators = widgets.spectators.get()

    for _, spec in pairs(spectators) do
        local name = spec:get_name() 
        local text_size = render.measure_text(1, nil, name).x

        render.text(1, vector(defines.screen_size.x - (text_size + 10), 5 + add_y), color(255, 255, 255, 200), nil, name)

        add_y = add_y + 18
    end
end

lc.sv_gravity = cvar.sv_gravity
lc.sv_jump_impulse = cvar.sv_jump_impulse
lc.g_net_data = {}
lc.g_sim_ticks = {}
lc.get_players = function() 
    local ents = entity.get_players()
    local res = {}
    for _, ent in pairs(ents) do 
        if ent:is_enemy() and ent:is_alive() then
            table.insert(res, ent) 
        end
    end 
    return res 
end

lc.extrapolate = function(ent, flags, ticks)
    local velocity = ent.m_vecVelocity
    local gravity = velocity.z > 0 and -lc.sv_gravity:float() * globals.tickinterval or lc.sv_jump_impulse:float() * globals.tickinterval
    local origin = ent:get_origin()
    local extrapolated = origin + vector(velocity.x * ticks * globals.tickinterval, velocity.y * ticks * globals.tickinterval, velocity.z * ticks * globals.tickinterval + (gravity * (ticks * globals.tickinterval * ticks * globals.tickinterval)) / 2)
    local damage, trace = utils.trace_bullet(ent, origin, extrapolated)
    if trace == nil then return end
    return trace.end_pos
end
lc.on_frame_stage = function()
    local lp = entity.get_local_player()
    if not lp then return end
    if not globals.is_in_game or not globals.is_connected then return end
    if not ui_handler.elements["interface"]["lc_debug"] then return end

    local players = lc.get_players()
    for _, player in pairs(players) do
        local idx = player:get_index()
        if player:is_dormant() then
            lc.g_net_data[idx] = nil
            lc.g_sim_ticks[idx] = nil
        else
            local prev_tick = lc.g_sim_ticks[idx]
            local sim_time = defines.time_to_ticks(player.m_flSimulationTime)
            local origin = player:get_origin()

            if prev_tick then
                local delta = sim_time - prev_tick.sim_time

                if delta ~= 0 then
                    local flags = player.m_fFlags

                    local teleport_distance = (prev_tick.origin - origin):lengthsqr()
                    local extrapolated = lc.extrapolate(player, flags, delta - 1)

                    lc.g_net_data[idx] = {
                        player = player,
                        delta = delta,
                        origin = origin,
                        extrapolated = extrapolated,
                        lagcomp = teleport_distance > 4096,
                        shifting = delta < 0
                    }
                end
            end

            lc.g_sim_ticks[idx] = {
                sim_time = sim_time,
                origin = origin
            }
        end
    end
end

lc.edges = {
    {0, 1}, {1, 2}, {2, 3}, {3, 0}, {5, 6}, {6, 7}, {1, 4}, {4, 8},
    {0, 4}, {1, 5}, {2, 6}, {3, 7}, {5, 8}, {7, 8}, {3, 4}
}
lc.on_render = function()
    local lp = entity.get_local_player()
    if not lp then return end
    if not globals.is_in_game or not globals.is_connected then return end
    if not ui_handler.elements["interface"]["lc_debug"] then return end

    for idx, data in pairs(lc.g_net_data) do
        if not data.player then
            goto skip
        end
        if data and data.lagcomp and data.player:is_alive() then
            local min = data.player.m_vecMins + data.extrapolated
            local max = data.player.m_vecMaxs + data.extrapolated

            local points = {
                min, vector(min.x, max.y, min.z),
                vector(max.x, max.y, min.z), vector(max.x, min.y, min.z),
                vector(min.x, min.y, max.z), vector(min.x, max.y, max.z),
                max, vector(max.x, min.y, max.z)
            }

            for k, v in pairs(lc.edges) do
                if k == 1 then
                    local origin = data.origin
                    local origin_w2s = render.world_to_screen(origin)
                    local min_w2s = render.world_to_screen(min)
                    if origin_w2s ~= nil and min_w2s ~= nil then
                        if origin_w2s.x ~= nil and min_w2s.x ~= nil then
                            render.line(origin_w2s, min_w2s, ui_handler.elements["interface"]["lc_debug_color"])
                        end
                    end
                end
                if points[v[1]] ~= nil and points[v[2]] ~= nil then
                    local p1 = render.world_to_screen(points[v[1]])
                    local p2 = render.world_to_screen(points[v[2]])
        
                    render.line(p1, p2, ui_handler.elements["interface"]["lc_debug_color"])
                end
            end
        end
        ::skip::
    end
end


hitmarker.size = 4
hitmarker.delay = 0.8
hitmarker.padding = 4

hitmarker.time = nil
hitmarker.alpha = 0
hitmarker.lethal = false

hitmarker.reset = function()
    hitmarker.time = nil;
    hitmarker.alpha = 0;
    hitmarker.lethal = false;
end

hitmarker.apply = function(is_lethal)
    hitmarker.time = globals.realtime + hitmarker.delay
    hitmarker.alpha = 1
    hitmarker.lethal = is_lethal == true
end

hitmarker.active = function()
    return globals.realtime < hitmarker.time
end

hitmarker.player_hurt = function(e)
    if not (ui_handler.elements["interface"]["hitmarker_screen"] and ui_handler.refs["interface"]["hitmarker_settings"].ref:get("Crosshair")) then return end
    hitmarker.apply(e.health <= 0)
end

hitmarker.handle = function()
    if hitmarker.time == nil or hitmarker.alpha == 0 then
        return
    end

    if not hitmarker.active() then
        hitmarker.alpha = math.lerp(hitmarker.alpha, 0, 0.095)
    end

    local mid = render.screen_size() * 0.5

    local size, padding = hitmarker.size, hitmarker.padding
    local clr = hitmarker.lethal and ui_handler.elements["interface"]["hitmarker_lethal"] or ui_handler.elements["interface"]["hitmarker_hit"]
    clr = clr:alpha_modulate(clr.a * hitmarker.alpha)

    do
        local pos_a = padding
        local pos_b = pos_a + size

        render.line(mid + pos_a, mid + pos_b, clr)
        render.line(mid - pos_a, mid - pos_b, clr)
    end

    do
        local pos_a = vector(padding, -padding)
        local pos_b = pos_a + vector(size, -size)

        render.line(mid + pos_a, mid + pos_b, clr)
        render.line(mid - pos_a, mid - pos_b, clr)
    end
end

kibit_hitmarker.impact = nil
kibit_hitmarker.markers = {}

kibit_hitmarker.aim_fire = function(e)
    if not (ui_handler.elements["interface"]["hitmarker_screen"] and ui_handler.refs["interface"]["hitmarker_settings"].ref:get("Players")) then return end
    kibit_hitmarker.impact = e.aim
end

kibit_hitmarker.aim_ack = function(e)
    if not (ui_handler.elements["interface"]["hitmarker_screen"] and ui_handler.refs["interface"]["hitmarker_settings"].ref:get("Players")) then return end

    table.insert(kibit_hitmarker.markers, 1, {
        time = globals.realtime + ui_handler.elements["interface"]["kibit_life"] / 10,
        alpha = 1.0,
        impact = kibit_hitmarker.impact
    })
end

kibit_hitmarker.handle = function()
    if not (ui_handler.elements["interface"]["hitmarker_screen"] and ui_handler.refs["interface"]["hitmarker_settings"].ref:get("Players")) then return end

    local realtime = globals.realtime
    local col = ui_handler.elements["interface"]["kibit_col"]
    local size = ui_handler.elements["interface"]["kibit_size"]

    for i = #kibit_hitmarker.markers, 1, -1 do
        local v = kibit_hitmarker.markers[i]

        if v.time < realtime then
            v.alpha = math.lerp(v.alpha, 0, 0.095)

            if v.alpha == 0.0 then
                kibit_hitmarker.markers[i] = nil
                goto skip;
            end
        end

        local w2s = render.world_to_screen(v.impact)
        if w2s == nil then
            goto skip
        end

        local vertical = vector(1, size)
        local horizontal = vector(size, 1)

        render.rect(w2s - vertical, w2s + vertical, col:alpha_modulate(col.a * v.alpha))
        render.rect(w2s - horizontal, w2s + horizontal, col:alpha_modulate(col.a * v.alpha))
        ::skip::
    end
end

menu.switch(ui_handler.tab.interface.interface, "Hitmarker")("interface", "hitmarker_screen")(function(group)

    menu.selectable(group, "Draw-On", {"Players", "Crosshair"})("interface", "hitmarker_settings", true, function()
        if not ui_handler.refs["interface"]["hitmarker_settings"].ref:get("Players") then 
            kibit_hitmarker.markers = {}
        end
        return ui_handler.elements["interface"]["hitmarker_screen"]
    end)

    menu.color_picker(group, "Crosshair Hit", colors.white)("interface", "hitmarker_hit", true, function()
        return ui_handler.elements["interface"]["hitmarker_screen"] and ui_handler.refs["interface"]["hitmarker_settings"].ref:get("Crosshair")
    end)

    menu.color_picker(group, "Crosshair Lethal", colors.white)("interface", "hitmarker_lethal", true, function()
        return ui_handler.elements["interface"]["hitmarker_screen"] and ui_handler.refs["interface"]["hitmarker_settings"].ref:get("Crosshair")
    end)

    menu.color_picker(group, "Players Color", colors.white)("interface", "kibit_col", true, function()
        return ui_handler.elements["interface"]["hitmarker_screen"] and ui_handler.refs["interface"]["hitmarker_settings"].ref:get("Players")
    end)

    menu.slider(group, "Size", 1, 10, 5)("interface", "kibit_size", true, function()
        return ui_handler.elements["interface"]["hitmarker_screen"] and ui_handler.refs["interface"]["hitmarker_settings"].ref:get("Players")
    end)

    menu.slider(group, "Life Time", 10, 50, 30, 0.1, "s")("interface", "kibit_life", true, function()
        return ui_handler.elements["interface"]["hitmarker_screen"] and ui_handler.refs["interface"]["hitmarker_settings"].ref:get("Players")
    end)

end):set_callback(function()
    if not (ui_handler.elements["interface"]["hitmarker_screen"] and ui_handler.refs["interface"]["hitmarker_settings"].ref:get("Players")) then
        kibit_hitmarker.markers = {}
    end
    hitmarker.reset()
end, true)

widgets.spectators.width = 0
widgets.spectators.handle = function()
    local widgets_spectators = ui_handler.refs["interface"]["solus_settings"].ref:get("Spectators")
    local design_accent_color = ui_handler.elements["interface"]["design_accent_color"]
    local design_breath_color = ui_handler.elements["interface"]["design_breath_color"]
    
    local anim = {}
    anim.work_specs = {}

    local width = 131
    local add_y = 23
    local text = "spectators"
    local spectators = widgets.spectators.get()
    local pos = vector(ui_handler.elements["drag"]["spectators_pos_x"], ui_handler.elements["drag"]["spectators_pos_y"])

    anim.specs = {}
    for _, spec in pairs(spectators) do
        local name = spec:get_name()
        local avatar = spec:get_steam_avatar()

        if anim.specs[name] == nil then
            anim.specs[name] = {}
            anim.specs[name].alpha = 255
        end

        anim.specs[name].alpha = animations.new("spectators_" .. name, widgets_spectators and spec and 255 or 0)

        if anim.specs[name].alpha > 1 then   
            render.text(1, pos + vector(19, add_y), colors.white:override("a", anim.specs[name].alpha), nil, name)
            render.texture(avatar, pos + vector(2, add_y), vector(12, 12), colors.white:override("a", anim.specs[name].alpha), nil, 0)


            local text_size_name  = render.measure_text(1, nil, name).x
            if (text_size_name + 24) > width then
                width = text_size_name + 24
            end

            if spec then
                table.insert(anim.work_specs, name)
            end

            add_y = add_y + 15
        end
    end

    widgets.spectators.width = width - render.measure_text(1, nil, text).x
    anim.main = animations.new("widgets_spectators", widgets_spectators and (#anim.work_specs > 0 or ui.get_alpha() > 0.5) and 255 or 0)

    if anim.main > 1 then
        widgets.container("spectators", design_accent_color:override("a", anim.main), text, widgets.spectators.width)
    end
end

widgets.handle = function()
    if not ui_handler.elements["interface"]["solus_windows"] then return end
    widgets.branded_watermark.handle()
    widgets.watermark.handle()
    widgets.keybinds.handle()
    widgets.spectators.handle()
end

aimbot_logger.data = {}
aimbot_logger.aim_data = {}
aimbot_logger.hitlogs_data = {}
aimbot_logger.shots = 0
aimbot_logger.count = function(b) local c=b%10;if c==1 and b~=11 then return b..'st'elseif c==2 and b~=12 then return b..'nd'elseif c==3 and b~=13 then return b..'rd'else return b..'th'end end
aimbot_logger.hitboxes = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
aimbot_logger.generate_flags = function(pre_data) return { pre_data.self_choke > 1 and 1 or 0, pre_data.velocity_modifier < 1.00 and 1 or 0, pre_data.flags.boosted and 1 or 0 } end
aimbot_logger.font = render.load_font("Verdana Bold",10,"ad")
aimbot_logger.print = function()local y=4;for k,information in ipairs(aimbot_logger.hitlogs_data) do if information.text and information.time and information.color then local text=information.text;local color=information.color;render.text(aimbot_logger.font,vector(8, y),color,'s',text);y=y+15;if information.time+8<globals.realtime or #aimbot_logger.hitlogs_data>7 then table.remove(aimbot_logger.hitlogs_data,k)end end end end
aimbot_logger.fired = function(e)local p_ent=e.target;local me=entity.get_local_player();aimbot_logger.aim_data[e.id]={original=e,dropped_packets={},handle_time=globals.realtime,self_choke=globals.choked_commands,flags={boosted=e.backtrack>0},safety=string.lower(neverlose_refs.prefer_safety:get()),feet_yaw=p_ent['m_flPoseParameter'][11]*120-60,correction = ui.find("Aimbot", "Ragebot", "Main", "Enabled"):get(),shot_pos=e.angle,eye=me:get_eye_position(),view=render.camera_angles(),velocity_modifier=me['m_flVelocityModifier'],total_hits=me['m_totalHitsOnServer'],history=e.backtrack}end


aimbot_logger.hit = function(e)

    if not ui_handler.elements["interface"]["aimbot_logger"] then
        return end

    if not ui_handler.refs["interface"]["aimbot_logger_settings"].ref:get("Console") then
        return end
    
    if aimbot_logger.aim_data[e.id] == nil then
        return
    end

    local p_ent = e.target
    local pre_data = aimbot_logger.aim_data[e.id]
    local shot_id = aimbot_logger.count(aimbot_logger.shots % 16)

    local me = entity.get_local_player()
    local aimed_hgroup = aimbot_logger.hitboxes[pre_data.original.hitgroup + 1] or "?"

    local target_name = string.lower(e.target:get_name())
    local hit_chance = math.floor(pre_data.original.hitchance + 0.5)
    local pflags = aimbot_logger.generate_flags(pre_data)

    local hit_color = "\a" .. ui_handler.elements["interface"]["aimbot_logger_hit_color"]:to_hex()
    
    local _verification = function()
        local text = ''

        local hg_diff = aimbot_logger.hitboxes[e.hitgroup + 1] ~= aimed_hgroup
        local dmg_diff = string.format('%.f', e.damage) ~= string.format('%.f', pre_data.original.damage)

        if hg_diff or dmg_diff then
            text = string.format(
                ' | mismatch: [ %s ]', (function()
                    local addr = ''

                    if dmg_diff then addr = 'dmg: ' .. string.format('%.f', pre_data.original.damage) .. (hg_diff and ' | ' or '') end
                    if hg_diff then addr = addr .. (hg_diff and 'hitgroup: ' .. aimed_hgroup or '') end

                    return addr
                end)()
            )
        end

        return text
    end

    if e.state == nil then
        print_raw(string.format(
            hit_color .. "[asylum] \aD5D5D5D5Registered %s shot in %s\'s %s for %d damage [angle: %.2f° | %d:%d°] ( hitchance: %d%% | safety: %s | history(Δ): %d | flags: %s%s )",
            shot_id, target_name, aimbot_logger.hitboxes[e.hitgroup + 1] or "?", e.damage,
            e.spread, pre_data.correction and 1 or 0, pre_data.feet_yaw,
            hit_chance, pre_data.safety, pre_data.history, table.concat(pflags), _verification()
        ))

        local info_hc = ui_handler.refs["interface"]["short_aimbot_logger_settings"].ref:get("Hitchance") and (not ui_handler.refs["interface"]["short_aimbot_logger_settings"].ref:get("Backtrack") and "(" .. hit_chance .. "%)" or "(" .. hit_chance .. "%") or ""
        local info_bt = ui_handler.refs["interface"]["short_aimbot_logger_settings"].ref:get("Backtrack") and (not ui_handler.refs["interface"]["short_aimbot_logger_settings"].ref:get("Hitchance") and "(" .. pre_data.history .. "t)" or ", " .. pre_data.history .. "t)") or ""
        
        if ui_handler.elements["interface"]["aimbot_logger_output"] == "CS:GO Events" then
            local default_output = ui_handler.elements["interface"]["short_logs"] and string.format('Hit %s in the %s for %d damage (%d health remaining) %s%s', 
            target_name, aimbot_logger.hitboxes[e.hitgroup + 1] or "?", e.damage,
            math.max(0, e.target.m_iHealth), info_hc, info_bt
        )
        or string.format(
            'Registered %s shot in %s\'s %s for %d damage [angle: %.2f° | %d:%d°] ( hitchance: %d%% | safety: %s | history(Δ): %d | flags: %s%s )',
            shot_id, target_name, aimbot_logger.hitboxes[e.hitgroup + 1] or "?", e.damage,
            e.spread, pre_data.correction and 1 or 0, pre_data.feet_yaw,
            hit_chance, pre_data.safety, pre_data.history, table.concat(pflags), _verification()
        )
        print_dev(default_output)
            
        elseif ui_handler.elements["interface"]["aimbot_logger_output"] == "Custom Events" then
            local custom_output = ui_handler.elements["interface"]["short_logs"] and string.format('Hit %s in the %s for %d damage (%d health remaining) %s%s', 
                target_name, aimbot_logger.hitboxes[e.hitgroup + 1] or "?", e.damage,
                math.max(0, e.target.m_iHealth), info_hc, info_bt
            )
            or string.format(
                'Registered %s shot in %s\'s %s for %d damage [angle: %.2f° | %d:%d°] ( hitchance: %d%% | safety: %s | history(Δ): %d | flags: %s%s )',
                shot_id, target_name, aimbot_logger.hitboxes[e.hitgroup + 1] or "?", e.damage,
                e.spread, pre_data.correction and 1 or 0, pre_data.feet_yaw,
                hit_chance, pre_data.safety, pre_data.history, table.concat(pflags), _verification()
            )
            
            table.insert(aimbot_logger.hitlogs_data, {
                time = globals.realtime, color = color(255), text = custom_output
            })
        end
    end
end

aimbot_logger.missed = function(e)

    if not ui_handler.elements["interface"]["aimbot_logger"] then
        return end

    if not ui_handler.refs["interface"]["aimbot_logger_settings"].ref:get("Console") then
        return end

    if aimbot_logger.aim_data[e.id] == nil or e.state == nil then
        return
    end

    local pre_data = aimbot_logger.aim_data[e.id]
    local shot_id = aimbot_logger.count(aimbot_logger.shots % 16)
    local miss_color = "\a" .. ui_handler.elements["interface"]["aimbot_logger_miss_color"]:to_hex()
    local net_data = utils.net_channel()

    local ping, avg_ping = 
        net_data.latency[1]*1000, 
        net_data.avg_latency[1]*1000

    local net_state = string.format(
        'delay: %d:%.2f | dropped: %d', 
        avg_ping, math.abs(avg_ping-ping), #pre_data.dropped_packets
    )

    local uflags = {
        math.abs(avg_ping-ping) < 1 and 0 or 1,
        cvar.cl_clock_correction:int() == 1 and 0 or 1,
        cvar.cl_clock_correction_force_server_tick:int() == 999 and 0 or 1
    }
    
    local me = entity.get_local_player()
    local target_name = string.lower(e.target:get_name())
    local hit_chance = math.floor(pre_data.original.hitchance + 0.5)
    local hgroup = aimbot_logger.hitboxes[pre_data.original.hitgroup + 1] or "?"
    local pflags = aimbot_logger.generate_flags(pre_data)

    if (globals.realtime - pre_data.handle_time) >= 0.5 then
        print_raw(string.format(
            miss_color .. "[asylum] \aD5D5D5D5Missed %s shot due to event timeout [%s] [%s]", 
            shot_id, target_name, net_state
        ))

        current_shot_text = string.format(
            "Missed %s shot due to event timeout [%s] [%s]", 
            shot_id, target_name, net_state
        )
    elseif e.state == "prediction error" or e.state == "unregistered shot" then 
        print_raw(string.format(
            miss_color .. "[asylum] \aD5D5D5D5Missed %s shot at %s\'s %s(%s%%) due to prediction error%s [%s] [vel_modifier: %.1f | history(Δ): %d | error: %s]", 
            shot_id, target_name, hgroup or 'nil value', hit_chance or 'nil value', e.state == "unregistered shot" and (" [" .. e.state .. "]") or "", net_state or 'nil value', me["m_flVelocityModifier"], pre_data.history or 'nil value', table.concat(uflags)
        ))

        current_shot_text = string.format(
            "Missed %s shot at %s\'s %s(%s%%) due to prediction error%s [%s] [vel_modifier: %.1f | history(Δ): %d | error: %s]", 
            shot_id, target_name, hgroup or 'nil value', hit_chance or 'nil value', e.state == "unregistered shot" and (" [" .. e.state .. "]") or "", net_state or 'nil value', me["m_flVelocityModifier"], pre_data.history or 'nil value', table.concat(uflags)
        )
    elseif e.state == "spread" then
        print_raw(string.format(
            miss_color .. "[asylum] \aD5D5D5D5Missed %s shot at %s\'s %s(%s%%) due to spread [angle: %.2f° | %d:%d°] ( dmg: %d | safety: %s | history(Δ): %d | flags: %s )",
            shot_id, target_name, hgroup, hit_chance, e.spread, 
            pre_data.correction and 1 or 0, pre_data.feet_yaw, 
            pre_data.original.damage, pre_data.safety, pre_data.history, table.concat(pflags)
        ))

        current_shot_text = string.format(
            "Missed %s shot at %s\'s %s(%s%%) due to spread [angle: %.2f° | %d:%d°] ( dmg: %d | safety: %s | history(Δ): %d | flags: %s )",
            shot_id, target_name, hgroup, hit_chance, e.spread, 
            pre_data.correction and 1 or 0, pre_data.feet_yaw, 
            pre_data.original.damage, pre_data.safety, pre_data.history, table.concat(pflags)
        )
    elseif e.state == "correction" or e.state == "misprediction" or e.state == "damage rejection" or e.state == "backtrack failure" then
        local misses_types = {
            ["correction"] = string.format("correction [angle: %.2f° | %d:%d°]", e.spread, pre_data.correction and 1 or 0, pre_data.feet_yaw),
            ["misprediction"] = string.format("misprediction [angle: %.2f° | %d:%d°]", e.spread, pre_data.correction and 1 or 0, pre_data.feet_yaw)
        }
        
        print_raw(string.format(
            miss_color .. "[asylum] \aD5D5D5D5Missed %s shot at %s\'s %s(%s%%) due to %s ( dmg: %d | safety: %s | history(Δ): %d | flags: %s )",
            shot_id, target_name, hgroup, hit_chance, misses_types[e.state] or e.state,
            pre_data.original.damage, pre_data.safety, pre_data.history, table.concat(pflags)
        ))

        current_shot_text = string.format(
            "Missed %s shot at %s\'s %s(%s%%) due to %s ( dmg: %d | safety: %s | history(Δ): %d | flags: %s )",
            shot_id, target_name, hgroup, hit_chance, misses_types[e.state] or e.state,
            pre_data.original.damage, pre_data.safety, pre_data.history, table.concat(pflags)
        )
    elseif e.state == "death" or e.state == "player death" then
        print_raw(string.format(
            miss_color .. "[asylum] \aD5D5D5D5Missed %s shot at %s\'s %s(%s%%) due to %s [dropped: %d | flags: %s | error: %s]", 
            shot_id, target_name, hgroup, hit_chance, e.state, #pre_data.dropped_packets, table.concat(pflags), table.concat(uflags)
        ))

        current_shot_text = string.format(
            "Missed %s shot at %s\'s %s(%s%%) due to %s [dropped: %d | flags: %s | error: %s]", 
            shot_id, target_name, hgroup, hit_chance, e.state, #pre_data.dropped_packets, table.concat(pflags), table.concat(uflags)
        )
    end

    local info_hc = ui_handler.refs["interface"]["short_aimbot_logger_settings"].ref:get("Hitchance") and (not ui_handler.refs["interface"]["short_aimbot_logger_settings"].ref:get("Backtrack") and "(" .. hit_chance .. "%)" or "(" .. hit_chance .. "%") or ""
    local info_bt = ui_handler.refs["interface"]["short_aimbot_logger_settings"].ref:get("Backtrack") and (not ui_handler.refs["interface"]["short_aimbot_logger_settings"].ref:get("Hitchance") and "(" .. pre_data.history .. "t)" or ", " .. pre_data.history .. "t)") or ""

    local current_shot_text = ui_handler.elements["interface"]["short_logs"] and 
        string.format('Missed shot due to %s %s%s', e.state, info_hc, info_bt) or current_shot_text

    if ui_handler.elements["interface"]["aimbot_logger_output"] == "CS:GO Events" then
        print_dev(current_shot_text)
    elseif ui_handler.elements["interface"]["aimbot_logger_output"] == "Custom Events" then
        table.insert(aimbot_logger.hitlogs_data, {
            time = globals.realtime, color = color(255), text = current_shot_text
        })
    end

    aimbot_logger.aim_data[e.id] = nil
end

aimbot_logger.get = function(shot)
    aimbot_logger.shots = aimbot_logger.shots + 1

    if shot.state ~= nil then
        skeet_indication.shots = skeet_indication.shots + 1
    end

    skeet_indication.shots = math.max(skeet_indication.shots, 1)
    skeet_indication.percentage = math.floor((100 - (skeet_indication.shots / aimbot_logger.shots) * 100))

    if ui_handler.elements["interface"]["aimbot_logger"] then

        local aimbot_logger_settings = ui_handler.elements["interface"]["aimbot_logger_settings"]
        local aimbot_logger_output = ui_handler.elements["interface"]["aimbot_logger_output"]
        local hit_color =      "\a" .. ui_handler.elements["interface"]["aimbot_logger_hit_color"]:to_hex()
        local miss_color =     "\a" .. ui_handler.elements["interface"]["aimbot_logger_miss_color"]:to_hex()
        
        --local dickpickovaya_dama = ("%i%s"):format(aimbot_logger.shots, aimbot_logger.count[aimbot_logger.shots] or "th")

        if shot.state == nil then
            if aimbot_logger_settings["Notify"] then
                table.insert(aimbot_logger.data, 1, {
                    {
                        "Hit ",
                        tostring(shot.target:get_name()),
                        " in the ",
                        tostring(aimbot_logger.hitboxes[shot.hitgroup+1]),
                        " for ",
                        tostring(shot.damage),
                        " damage (",
                        tostring(math.max(0, shot.target.m_iHealth)),
                        " health remaining)",
                    },
                    alpha = 0, 
                    alpha1 = 0,
                    time = globals.realtime,
                    color = ui_handler.elements["interface"]["aimbot_logger_hit_color"]
                })
            end
        else
            if aimbot_logger_settings["Notify"] then
                table.insert(aimbot_logger.data, 1, {
                    {
                        "Missed ",
                        tostring(shot.target:get_name()),
                        " in the ",
                        tostring(aimbot_logger.hitboxes[shot.wanted_hitgroup+1]),
                        " due to ",
                        tostring(shot.state),
                        "",
                        "",
                        "",
                    },
                    alpha = 0,
                    alpha1 = 0,
                    time = globals.realtime,
                    color = ui_handler.elements["interface"]["aimbot_logger_miss_color"]
                })
            end
        end
    end
end

aimbot_logger.handle = function()
    local add_y = 0
    for k, v in pairs(aimbot_logger.data) do
        local text = v[1]
        
        --local full_text = text[1] .. text[2] .. text[3] .. text[3] .. text[4] .. text[5] .. text[6] .. text[7] .. text[8] .. text[9]
        local text_sz = render.measure_text(1, nil, text[1] .. text[2] .. text[3] .. text[3] .. text[4] .. text[5] .. text[6] .. text[7] .. text[8] .. text[9])

        if v.time + 1 > globals.realtime then
            v.alpha = math.lerp(v.alpha, 255, 0.095)
            v.alpha1 = math.lerp(v.alpha1, 1, 0.03)
        end
        
        --render.shadow(vector(x - text_sz[1] / 2, y), vector(x + text_sz[1] / 2, y), color(base_color[1], base_color[2], base_color[3], base_color[4]), 50, 0, 0)
        render.shadow(vector(defines.screen_size.x/2 - (text_sz.x/2-20), defines.screen_size.y / 1.2 + add_y - v.alpha1 * 100 + 110), vector(defines.screen_size.x / 2 + (text_sz.x/2-25), defines.screen_size.y / 1.2 + add_y - v.alpha1 * 100 + 110), v.color:override("a", v.alpha), 50, 0, 0)
        
        widgets.container("aimbot_logger",
            v.color:override("a", v.alpha),
            defines.colored_text(
                {
                    text[1], 
                    colors.white:override("a", v.alpha)
                },
                {
                    text[2], 
                    v.color:override("a", v.alpha)
                },
                {
                    text[3], 
                    colors.white:override("a", v.alpha)
                },
                {
                    text[4], 
                    v.color:override("a", v.alpha)
                },
                {
                    text[5],
                    colors.white:override("a", v.alpha)
                },
                {
                    text[6], 
                    v.color:override("a", v.alpha)
                },
                {
                    text[7], 
                    colors.white:override("a", v.alpha)
                },
                {
                    text[8], 
                    v.color:override("a", v.alpha)
                },
                {
                    text[9], 
                    colors.white:override("a", v.alpha)
                }
            ), 0, 0, vector(defines.screen_size.x / 2, defines.screen_size.y / 1.2 + add_y - v.alpha1 * 100 + 100)
        )

        add_y = add_y + 15 * v.alpha / 255

        if v.time + 5 < globals.realtime then
            v.alpha = math.lerp(v.alpha, 0, 0.095)
            v.alpha1 = math.lerp(v.alpha1, 0, 0.03)
        end

        if v.alpha < 0.01 and (v.time + 7 < globals.realtime) or #aimbot_logger.data > 6 then
            table.remove(aimbot_logger.data, k)
        end
    end
end

viewmodel.handle = function()
    if ui_handler.elements["interface"]["viewmodel"] then
        cvar.viewmodel_fov:float(ui_handler.elements["interface"]["viewmodel_fov"], true)
        cvar.viewmodel_offset_x:float(ui_handler.elements["interface"]["viewmodel_x"] / 10, true)
        cvar.viewmodel_offset_y:float(ui_handler.elements["interface"]["viewmodel_y"] / 10, true)
        cvar.viewmodel_offset_z:float(ui_handler.elements["interface"]["viewmodel_z"] / 10, true)
    else
        cvar.viewmodel_fov:float(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
    end
end

viewmodel.destroy = function()
    cvar.viewmodel_fov:float(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
end

menu.switch(ui_handler.tab.interface.miscellaneous, "Override Viewmodel")("interface", "viewmodel", false)(function(group)

    menu.slider(group, "FOV", 0, 100, 68)("interface", "viewmodel_fov", false, function()
        return ui_handler.elements["interface"]["viewmodel"]
    end)():set_callback(viewmodel.handle)

    menu.slider(group, "X", -100, 100, 25, 0.1)("interface", "viewmodel_x", false, function()
        return ui_handler.elements["interface"]["viewmodel"]
    end)():set_callback(viewmodel.handle)

    menu.slider(group, "Y", -100, 100, 0, 0.1)("interface", "viewmodel_y", false, function()
        return ui_handler.elements["interface"]["viewmodel"]
    end)():set_callback(viewmodel.handle)

    menu.slider(group, "Z", -100, 100, -15, 0.1)("interface", "viewmodel_z", false, function()
        return ui_handler.elements["interface"]["viewmodel"]
    end)():set_callback(viewmodel.handle)

end):set_callback(viewmodel.handle)

menu.switch(ui_handler.tab.interface.additional, "Aimbot Logger")("interface", "aimbot_logger")(function(group)

    menu.selectable(group, "Settings", {"Console", "Notify"})("interface", "aimbot_logger_settings", true, function()
        return ui_handler.elements["interface"]["aimbot_logger"]
    end)

    menu.combo(group, "Output To", {"CS:GO Events", "Custom Events"})("interface", "aimbot_logger_output", true, function()
        return ui_handler.elements["interface"]["aimbot_logger"] and ui_handler.refs["interface"]["aimbot_logger_settings"].ref:get("Console")
    end)():set_callback(function()
        if ui_handler.refs["interface"]["aimbot_logger_output"].ref:get("CS:GO Events") then
            for i = 1, 10 do
                print_dev('   ')
            end
        end

        if ui_handler.refs["interface"]["aimbot_logger_output"].ref:get("Custom Events") then
            for i = 1, 25 do
                table.insert(aimbot_logger.hitlogs_data, {
                    time = globals.realtime, color = color(255), text = '   '
                })
            end
        end
    end)

    menu.switch(group, "Short Logs")("interface", "short_logs", true, function()
        return ui_handler.elements["interface"]["aimbot_logger"] and ui_handler.refs["interface"]["aimbot_logger_settings"].ref:get("Console")
    end)

    menu.selectable(group, "\nshortlogssettings", {"Hitchance", "Backtrack"})("interface", "short_aimbot_logger_settings", true, function()
        return ui_handler.elements["interface"]["aimbot_logger"] and ui_handler.elements["interface"]["short_logs"]
    end)

    menu.color_picker(group, "Hit Color", colors.white)("interface", "aimbot_logger_hit_color", true, function()
        return ui_handler.elements["interface"]["aimbot_logger"]
    end)

    menu.color_picker(group, "Miss Color", colors.white)("interface", "aimbot_logger_miss_color", true, function()
        return ui_handler.elements["interface"]["aimbot_logger"]
    end)

end)

menu.switch(ui_handler.tab.interface.additional, "Hitchance Manipulation")("interface", "hitchance_manipulation", true)(function(group)
    menu.combo(group, "Type", {"In-Air", "Noscope"})("interface", "hitchance_manipulations", true, function()
        return ui_handler.elements["interface"]["hitchance_manipulation"]
    end)

    menu.selectable(group, "Weapons\nIN-AIR", {"AutoSnipers", "R8 Revolver", "SSG 08", "AWP", "Pistols", "Desert Eagle", "SMG", "Shotgun", "Rifle", "Machine Gun"})("interface", "inair_allowed_weapons", true, function()
        return ui_handler.elements["interface"]["hitchance_manipulation"] and ui_handler.elements["interface"]["hitchance_manipulations"] == "In-Air"
    end)

    menu.selectable(group, "Weapons\nNOSCOPE", {"AutoSnipers", "SSG 08", "AWP"})("interface", "noscope_allowed_weapons", true, function()
        return ui_handler.elements["interface"]["hitchance_manipulation"] and ui_handler.elements["interface"]["hitchance_manipulations"] == "Noscope"
    end)

    menu.slider(group, "Hitchance\nNOSCOPE", 0, 100, 50)("interface", "hitchance_manipulation_noscope", true, function()
        return ui_handler.elements["interface"]["hitchance_manipulation"] and ui_handler.elements["interface"]["hitchance_manipulations"] == "Noscope"
    end)
    
    menu.slider(group, "Hitchance\nIN-AIR", 0, 100, 50)("interface", "hitchance_manipulation_in_air", true, function()
        return ui_handler.elements["interface"]["hitchance_manipulation"] and ui_handler.elements["interface"]["hitchance_manipulations"] == "In-Air"
    end)
end)

clantag_spammer.anim = function(text, indices)
    if not globals.is_connected then
        return
    end

    if not globals.is_in_game then
        return
    end

    local net_channel = utils.net_channel()

    if net_channel == nil then
        return
    end

    local text_anim = "               " .. text .. "                      " 
    local tickinterval = globals.tickinterval
    local tickcount = globals.tickcount + math.floor(utils.net_channel().latency[0]+0.22 / tickinterval + 0.5)
    local i = tickcount / math.floor(0.3 / tickinterval + 0.5)
    i = math.floor(i % #indices)
    i = indices[i+1]+1

    return string.sub(text_anim, i, i+15)
end

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

clantag_spammer.handle = function()
    if not ui_handler.elements["interface"]["clantag_spammer"] then
        return
    end

    local local_player = entity.get_local_player()
    if local_player ~= nil and globals.is_connected and globals.choked_commands == 0 then
            
        local gamerules = entity.get_game_rules()
        local text = clantag_spammer.anim("asylum", {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25})

        if gamerules.m_gamePhase == 5 then
            text = clantag_spammer.anim("asylum", {11})
        elseif gamerules.m_timeUntilNextPhaseStarts ~= 0 then
            text = clantag_spammer.anim("asylum", {11})
        end

        clantag_spammer.set(text)
    end
end

menu.switch(ui_handler.tab.interface.additional, "Clantag Spammer")("interface", "clantag_spammer")():set_callback(clantag_spammer.clear)

console_color.last_color = nil
console_color.list = {}
console_color.objects = {
    [ "vgui_white" ] = true,
    [ "vgui/hud/800corner1" ] = true,
    [ "vgui/hud/800corner2" ] = true,
    [ "vgui/hud/800corner3" ] = true,
    [ "vgui/hud/800corner4" ] = true
}
console_color.vgui = materials.get_materials("vgui")

do
    for i = 1, #console_color.vgui do
        local v = console_color.vgui[ i ]

        if console_color.objects[ v:get_name() ] then
            table.insert(console_color.list, v)
        end
    end

    local function set_color(clr)
        if clr == console_color.last_color then return end

        for i = 1, #console_color.list do
            local v = console_color.list[ i ];

            if not v:is_valid() then
                goto skip
            end

            if clr == nil then
                v:reset()
                goto skip
            end

            v:color_modulate(clr);
            v:alpha_modulate(clr.a / 255);

            ::skip::
        end

        console_color.last_color = clr;
    end

    local is_console_visible = utils.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)")

    console_color.shutdown = function()
        set_color()
    end

    console_color.pre_render = function()
        if not ui_handler.elements["interface"]["console_switch"] then return end

        if is_console_visible() then
            set_color(ui_handler.elements["interface"]["console_color"]);
            return
        end

        console_color.shutdown()
    end
end

scope_overlay.alpha = 0
scope_overlay.clamp=function(a,b,c)return math.max(b,math.min(c,a))end
scope_overlay.handle = function()
    local scope_overlay_enable          =      ui_handler.elements["interface"]["scope_overlay"]
    local is_disable_anim               =      ui_handler.elements["interface"]["scope_overlay_settings"]["Disable Animation"]
    local spread_dependensy             =      ui_handler.elements["interface"]["scope_overlay_settings"]["Dynamic Offset"]
    local rotated                       =      ui_handler.elements["interface"]["scope_overlay_settings"]["Rotated"]

    local left_active                   =      ui_handler.elements["interface"]["scope_overlay_additional"]["Left"]
    local top_active                    =      ui_handler.elements["interface"]["scope_overlay_additional"]["Top"]
    local right_active                  =      ui_handler.elements["interface"]["scope_overlay_additional"]["Right"]
    local bottom_active                 =      ui_handler.elements["interface"]["scope_overlay_additional"]["Bottom"]

    local size                          =      ui_handler.elements["interface"]["scope_overlay_size"]*(defines.screen_size.y/1080)
    local offset                        =      ui_handler.elements["interface"]["scope_overlay_gap"]*(defines.screen_size.y/1080)
    local scope_overlay_speed           =      ui_handler.elements["interface"]["scope_overlay_speed"]
    local scope_overlay_accent_color    =      ui_handler.elements["interface"]["scope_overlay_accent_color"]
    local scope_overlay_second_color    =      ui_handler.elements["interface"]["scope_overlay_second_color"]
    local scope_overlay_thickness       =      ui_handler.elements["interface"]["scope_overlay_thickness"]

    if scope_overlay_enable then
        neverlose_refs.override("scope_overlay", "Remove All")
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local wpn = player:get_player_weapon()

    if wpn == nil then
        return
    end

    local m_bIsScoped = player.m_bIsScoped

    local anim = {}
    anim.main = animations.new("scope_overlay", scope_overlay_enable and m_bIsScoped and 1 or 0)
    
    if anim.main < 0.1 then
        scope_overlay.alpha = 0
        return
    end

    local screen = render.screen_size()
    if spread_dependensy then
		local wpn_ent = player:get_player_weapon();
			
		if wpn_ent ~= nil then
			local spread, inaccuracy =
                wpn_ent:get_spread(),
				wpn_ent:get_inaccuracy()

			local modifier = ((inaccuracy + spread)*360)

			offset, size = offset+modifier, size+modifier
		end
	end

	local scope_lvl = wpn["m_zoomLevel"]
	local scoped, resume =
        player["m_bIsScoped"],
        player["m_bResumeZoom"]

	local valid = player:is_alive() and wpn ~= nil and scope_lvl ~= nil
	local act = valid and scope_lvl > 0 and scoped and not resume

    anim.rotated = animations.new("scope_overlay_rotated", rotated and 45 or 0)
	local ft = scope_overlay_speed > 3 and globals.frametime*scope_overlay_speed or 1

	local half_w, half_h, half_t = screen.x*.5, screen.y*.5, scope_overlay_thickness > 1 and scope_overlay_thickness*.5 or 0

	if not is_disable_anim then
		offset = offset+size*(1-scope_overlay.alpha)
	end

    if anim.rotated ~= 0 then
        render.push_rotation(anim.rotated, screen * .5)
    end
        
	if scope_overlay.alpha > 0 then
        if not left_active then
            render.gradient(vector(half_w-size+2, half_h-half_t), vector(half_w-size+2 + size-offset, half_h-half_t + scope_overlay_thickness), scope_overlay_second_color:override("a", scope_overlay_second_color.a*scope_overlay.alpha), scope_overlay_accent_color:override("a", scope_overlay_accent_color.a*scope_overlay.alpha), scope_overlay_second_color:override("a", scope_overlay_second_color.a*scope_overlay.alpha), scope_overlay_accent_color:override("a", scope_overlay_accent_color.a*scope_overlay.alpha))
        end    
        
        if not right_active then
            render.gradient(vector(half_w+offset, half_h-half_t), vector(half_w+offset + size-offset, half_h-half_t + scope_overlay_thickness), scope_overlay_accent_color:override("a", scope_overlay_accent_color.a*scope_overlay.alpha), scope_overlay_second_color:override("a", scope_overlay_second_color.a*scope_overlay.alpha), scope_overlay_accent_color:override("a", scope_overlay_accent_color.a*scope_overlay.alpha), scope_overlay_second_color:override("a", scope_overlay_second_color.a*scope_overlay.alpha))
        end

		if not top_active then
            render.gradient(vector(half_w-half_t, half_h-size+2), vector(half_w-half_t + scope_overlay_thickness, half_h-size+2 + size-offset), scope_overlay_second_color:override("a", scope_overlay_second_color.a*scope_overlay.alpha), scope_overlay_second_color:override("a", scope_overlay_second_color.a*scope_overlay.alpha), scope_overlay_accent_color:override("a", scope_overlay_accent_color.a*scope_overlay.alpha), scope_overlay_accent_color:override("a", scope_overlay_accent_color.a*scope_overlay.alpha))
		end

        if not bottom_active then
            render.gradient(vector(half_w-half_t, half_h+offset), vector(half_w-half_t + scope_overlay_thickness, half_h+offset + size-offset), scope_overlay_accent_color:override("a", scope_overlay_accent_color.a*scope_overlay.alpha), scope_overlay_accent_color:override("a", scope_overlay_accent_color.a*scope_overlay.alpha), scope_overlay_second_color:override("a", scope_overlay_second_color.a*scope_overlay.alpha), scope_overlay_second_color:override("a", scope_overlay_second_color.a*scope_overlay.alpha))
        end
    end
        
	scope_overlay.alpha = scope_overlay.clamp(scope_overlay.alpha + (act and ft or -ft), 0, 1)

    if anim.rotated ~= 0 then
        render.pop_rotation()
    end
    
    --[[
        local speed_overlay = 0.01
        anim.top = animations.new("scope_overlay_top", scope_overlay_enable and m_bIsScoped and not top_active and not inverted and scope_overlay_accent_color.a or 0, speed_overlay)
        anim.bottom = animations.new("scope_overlay_bottom", scope_overlay_enable and m_bIsScoped and not bottom_active and not inverted and scope_overlay_accent_color.a or 0, speed_overlay)
        anim.left = animations.new("scope_overlay_left", scope_overlay_enable and m_bIsScoped and not left_active and not inverted and scope_overlay_accent_color.a or 0, speed_overlay)
        anim.right = animations.new("scope_overlay_right", scope_overlay_enable and m_bIsScoped and not right_active and not inverted and scope_overlay_accent_color.a or 0, speed_overlay)

        anim.top_inverted = animations.new("scope_overlay_top_inverted", scope_overlay_enable and m_bIsScoped and not top_active and inverted and scope_overlay_accent_color.a or 0, speed_overlay)
        anim.bottom_inverted = animations.new("scope_overlay_bottom_inverted", scope_overlay_enable and m_bIsScoped and not bottom_active and inverted and scope_overlay_accent_color.a or 0, speed_overlay)
        anim.left_inverted = animations.new("scope_overlay_left_inverted", scope_overlay_enable and m_bIsScoped and not left_active and inverted and scope_overlay_accent_color.a or 0, speed_overlay)
        anim.right_inverted = animations.new("scope_overlay_right_inverted", scope_overlay_enable and m_bIsScoped and not right_active and inverted and scope_overlay_accent_color.a or 0, speed_overlay)
        
        anim.rotated = animations.new("scope_overlay_rotated", rotated and 45 or 0)
        anim.spread = spread_dependensy and animations.new("scope_overlay_spread_dependensy", weapon:get_inaccuracy() * 75) + scope_overlay_gap or scope_overlay_gap

        local clr = {
            left = scope_overlay_accent_color:override("a", anim.left),
            right = scope_overlay_accent_color:override("a", anim.right),
            top = scope_overlay_accent_color:override("a", anim.top),
            bottom = scope_overlay_accent_color:override("a", anim.bottom),
            left_inverted = scope_overlay_accent_color:override("a", anim.left_inverted),
            right_inverted = scope_overlay_accent_color:override("a", anim.right_inverted),
            top_inverted = scope_overlay_accent_color:override("a", anim.top_inverted),
            bottom_inverted = scope_overlay_accent_color:override("a", anim.bottom_inverted),
        }

        scope_overlay_size = scope_overlay_size * anim.main
        
        local position = defines.screen_size / 2

        if anim.rotated ~= 0 then
            render.push_rotation(anim.rotated, defines.screen_size / 2)
        end
        
        render.gradient(
            position - vector(-1, scope_overlay_size + anim.spread),
            position - vector(0, anim.spread),
            clr.top_inverted, clr.top_inverted, clr.top, clr.top
        )

        render.gradient(
            position + vector(1, scope_overlay_size + anim.spread),
            position + vector(0, anim.spread),
            clr.bottom_inverted, clr.bottom_inverted, clr.bottom, clr.bottom
        )

        render.gradient(
            position + vector(scope_overlay_size + anim.spread, 1),
            position + vector(anim.spread, 0),
            clr.right_inverted, clr.right, clr.right_inverted, clr.right
        )

        render.gradient(
            position - vector(scope_overlay_size + anim.spread, -1),
            position - vector(anim.spread, 0), 
            clr.left_inverted, clr.left, clr.left_inverted, clr.left
        )

        if anim.rotated ~= 0 then
            render.pop_rotation()
        end
    --]]
end

local current_link = "https://cdn.discordapp.com/attachments/1105533082045530234/1114938585565634651/20e58ccd-eaf5-4044-96b3-c3174471f806.png"
do
    local js = panorama.loadstring([[
        let entity_panels = {}
        let entity_data = {}
        let event_callbacks = {}

        let SLOT_LAYOUT = `
            <root>
                <Panel style="min-width: 3px; padding-top: 2px; padding-left: 0px;" scaling='stretch-to-fit-y-preserve-aspect'>
                    <Image id="smaller" textureheight="15" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;"  />
                    <Image id="small" textureheight="17" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;" />
                    <Image id="image" textureheight="21" style="opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; padding: 3px 5px; margin: -3px -5px; margin-top: -5px;" />
                </Panel>
            </root>
        `

        let _DestroyEntityPanel = function (key) {
            let panel = entity_panels[key]

            if(panel != null && panel.IsValid()) {
                var parent = panel.GetParent()
                let musor = parent.GetChild(0)

                musor.visible = true
                if(parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
                    parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 0px"
                }

                panel.DeleteAsync(0.0)
            }
            delete entity_panels[key]
        }

        let _DestroyEntityPanels = function() {
            for(key in entity_panels){
                _DestroyEntityPanel(key)
            }
        }

        let _GetOrCreateCustomPanel = function(xuid) {
            if(entity_panels[xuid] == null || !entity_panels[xuid].IsValid()){
                entity_panels[xuid] = null

                let scoreboard_context_panel = $.GetContextPanel().FindChildTraverse("ScoreboardContainer").FindChildTraverse("Scoreboard") || $.GetContextPanel().FindChildTraverse("id-eom-scoreboard-container").FindChildTraverse("Scoreboard")

                if(scoreboard_context_panel == null){
                    _Clear()
                    _DestroyEntityPanels()

                    return
                }

                scoreboard_context_panel.FindChildrenWithClassTraverse("sb-row").forEach(function(el){
                    let scoreboard_el

                    if(el.m_xuid == xuid) {
                        el.Children().forEach(function(child_frame){
                            let stat = child_frame.GetAttributeString("data-stat", "")
                            if(stat == "rank")
                                scoreboard_el = child_frame.GetChild(0)
                        })

                        if(scoreboard_el) {
                            let scoreboard_el_parent = scoreboard_el.GetParent()

                            let custom_icons = $.CreatePanel("Panel", scoreboard_el_parent, "custom-weapons", {
                            })

                            if(scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
                                scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 0px"
                            }

                            scoreboard_el_parent.MoveChildAfter(custom_icons, scoreboard_el_parent.GetChild(1))

                            let prev_panel = scoreboard_el_parent.GetChild(0)
                            prev_panel.visible = false

                            let panel_slot_parent = $.CreatePanel("Panel", custom_icons, `icon`)

                            panel_slot_parent.visible = false
                            panel_slot_parent.BLoadLayoutFromString(SLOT_LAYOUT, false, false)

                            entity_panels[xuid] = custom_icons

                            return custom_icons
                        }
                    }
                })
            }

            return entity_panels[xuid]
        }

        let _UpdatePlayer = function(entindex, path_to_image) {
            if(entindex == null || entindex == 0)
                return

            entity_data[entindex] = {
                applied: false,
                image_path: path_to_image
            }
        }

        let _ApplyPlayer = function(entindex) {
            let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)

            let panel = _GetOrCreateCustomPanel(xuid)

            if(panel == null)
                return

            let panel_slot_parent = panel.FindChild(`icon`)
            panel_slot_parent.visible = true

            let panel_slot = panel_slot_parent.FindChild("image")
            panel_slot.visible = true
            panel_slot.style.opacity = "1"
            panel_slot.SetImage(entity_data[entindex].image_path)

            return true
        }

        let _ApplyData = function() {
            for(entindex in entity_data) {
                entindex = parseInt(entindex)

                let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)

                if(!entity_data[entindex].applied || entity_panels[xuid] == null || !entity_panels[xuid].IsValid()) {
                    if(_ApplyPlayer(entindex)) {
                        entity_data[entindex].applied = true
                    }
                }
            }
        }

        let _Create = function() {
            event_callbacks["OnOpenScoreboard"] = $.RegisterForUnhandledEvent("OnOpenScoreboard", _ApplyData)
            event_callbacks["Scoreboard_UpdateEverything"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateEverything", function(){
                _ApplyData()
            })
            event_callbacks["Scoreboard_UpdateJob"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateJob", _ApplyData)
        }

        let _Clear = function() {
            entity_data = {}
        }

        let _Destroy = function() {
            // clear entity data
            _Clear()
            _DestroyEntityPanels()

            for(event in event_callbacks){
                $.UnregisterForUnhandledEvent(event, event_callbacks[event])

                delete event_callbacks[event]
            }
        }

        return {
            create: _Create,
            destroy: _Destroy,
            clear: _Clear,
            update_player: _UpdatePlayer,
            destroy_panel: _DestroyEntityPanels
        }
    ]], "CSGOHud")()

    js.create()

    local get_steam_id = (function ()
    	local get_xuid = panorama.GameStateAPI.GetPlayerXuidStringFromEntIndex

    	return function (player)
    		if not player then return end

    		local xuid = get_xuid(player:get_index())
    		if not xuid then return end

    		local sub = xuid:sub(4, -1)
    		if #sub == 0 then return end

    		return 76500000000000000ULL + tonumber(sub)
    	end
    end)()

    local steam_networking_messages = (function ()
        ffi.cdef[[
        	uint32_t GetModuleHandleA(const char* lpModuleName);
        	uint32_t GetProcAddress(uint32_t hModule, const char* lpProcName);
        ]]

        local SteamNetworkingIdentity_t = ffi.typeof([[
            struct {
        		int m_eType;
        		int m_cbSize;
        		union {
        			uint64_t m_steamID64;
        			char m_szGenericString[ 32 ];
        			uint8_t m_genericBytes[ 32 ];
        			char m_szUnknownRawString[ 128 ];
        			void* m_ip;
        			uint32_t m_reserved[ 32 ];
        		};
        	}
        ]])

        local SteamNetworkingMessage_t = ffi.typeof([[
            struct {
                void* m_pData;
                int m_cbSize;
                unsigned int m_conn;
                $ m_identityPeer;
                int64_t m_nConnUserData;
                long long m_usecTimeReceived;
                int64_t m_nMessageNumber;
                void(__thiscall* m_pfnFreeData)(void*);
                void(__thiscall* m_pfnRelease)(void*);
                int m_nChannel;
                int m_nFlags;
                int64_t m_nUserData;
            }
        ]], SteamNetworkingIdentity_t)

	    local proc_address = ffi.C.GetProcAddress(
	    	ffi.C.GetModuleHandleA("steamnetworkingsockets.dll"),
	    	"SteamNetworkingMessages_LibV2")

	    assert(proc_address ~= 0, "failed to get steam_networking_messages")

	    local SteamNetworkingIdentity = SteamNetworkingIdentity_t
	    local SteamNetworkingMessage_t = ffi.typeof("$* [?]", SteamNetworkingMessage_t)
	    local this = ffi.cast("void***", ffi.cast("void*(__thiscall*)()", proc_address)())

	    local send_message_to_user_fn = ffi.cast(
        	ffi.typeof("int(__thiscall*)(void*, const $&, const void *, uint32_t, int, int)", SteamNetworkingIdentity_t),
        	this[0][0]
	    )

	    local receive_messages_on_channel_fn = ffi.cast(
	        ffi.typeof(
	            "int(__thiscall*)(void*, int, $, int)",
	            SteamNetworkingMessage_t
	        ),
	        this[0][1]
	    )

	    local accept_session_with_user_fn =  ffi.cast(ffi.typeof("bool(__thiscall*)(void*, const $&)", SteamNetworkingIdentity_t), this[0][2])
	    local close_connection_with_user_fn = ffi.cast(ffi.typeof("bool(__thiscall*)(void*, const $&)", SteamNetworkingIdentity_t), this[0][3])

	    local DEFAULT_CHANNEL = 1200
	    local function send_message_to_user(steamid, message, channel)
	    	local uint64_steamid = ffi.cast("uint64_t", steamid)
	    	local message_char = ffi.cast("const char*", message)

	    	local identity = SteamNetworkingIdentity()
	    	identity.m_eType = 16
	    	identity.m_cbSize = ffi.sizeof(uint64_steamid)
	    	identity.m_steamID64 = uint64_steamid

	    	return send_message_to_user_fn(this, identity, message_char, message:len(), 8, channel or DEFAULT_CHANNEL)
	    end

	    local function receive_messages_on_channel(channel)
	    	local buff = SteamNetworkingMessage_t(1337)

	    	local num_messages = receive_messages_on_channel_fn(this, channel or DEFAULT_CHANNEL, buff, 1337)

	    	return num_messages, buff
	    end

	    local function close_connection_with_user(steamid)
	    	local uint64_steamid = ffi.cast("uint64_t", steamid)

	    	local identity = SteamNetworkingIdentity()
	    	identity.m_eType = 16
	    	identity.m_cbSize = ffi.sizeof(uint64_steamid)
	    	identity.m_steamID64 = uint64_steamid

	    	return close_connection_with_user_fn(this, identity)
	    end

	    local function accept_session_with_user(steamid)
	    	local uint64_steamid = ffi.cast("uint64_t", steamid)

	    	local identity = SteamNetworkingIdentity()
	    	identity.m_eType = 16
	    	identity.m_cbSize = ffi.sizeof(uint64_steamid)
	    	identity.m_steamID64 = uint64_steamid

	    	return accept_session_with_user_fn(this, identity)
	    end

	    return {
	    	send_message_to_user = send_message_to_user,
	    	receive_messages_on_channel = receive_messages_on_channel,
	    	close_connection_with_user = close_connection_with_user,
	    	accept_session_with_user = accept_session_with_user
	    }
    end)()

    local synchronization = (function ()
        local player_list = { }

        local function clean_players()
            for _, pl in pairs(entity.get_players()) do
                local idx = pl:get_index()

                if player_list[idx] then
                    table.remove(player_list, idx)
                end
            end

            js.destroy_panel()
        end

        local function send_messages()
            local lp = entity.get_local_player()

            clean_players()

            local message = {
                idx = lp:get_index(),
                version = 1,
                hash = "asylum_shared" -- чё за хэш?
            }

            local message_json = "[[" .. json.stringify(message) .. "]]" -- TODO: очень странная хрень, область строки неправильная
            for _, pl in pairs(entity.get_players()) do
                if pl ~= lp then
                    local steamid = get_steam_id(pl)

                    if steamid then
                        steam_networking_messages.close_connection_with_user(steamid) -- just in case
                        steam_networking_messages.send_message_to_user(steamid, message_json)
                    end
                end
            end
        end

        local function accept_connections()
            local lp = entity.get_local_player()

            for _, pl in pairs(entity.get_players()) do
                if pl ~= lp then
                    local steamid = get_steam_id(pl)

                    if steamid then
                        steam_networking_messages.accept_session_with_user(steamid)
                    end
                end
            end
        end

        local function parse_json(str)
            if not str or not str:find("asylum_shared") then
                return
            end

            local match = string.gmatch(str, "([^[[]+)([]]]+)")() -- TODO: странно, но почему то область стринга неверная

            if not match or #match == 0 then
                return
            end

            local call, result = pcall(json.parse, match)

            if not call then
                return
            end

            return result
        end

        local function update_local()
            local lp = entity.get_local_player()
            if lp then
                local idx = lp:get_index()

                player_list[idx] = {
                    backup = -1337
                }

                js.update_player(idx, "file://{images}/icons/asylum/scoreboard.png")
            end
        end

        local function receive_messages()
            local num, buff = steam_networking_messages.receive_messages_on_channel()

            for i = 1, num do
                local this = buff[i - 1][0]

                if this then
                    local data = parse_json(ffi.string(this.m_pData))

                    if data then
                        local pl = entity.get(data.idx)

                        if pl then
                            player_list[data.idx] = {
                                backup = -1337
                            }

                            local steamid = get_steam_id(pl)

                            if steamid then
                                steam_networking_messages.close_connection_with_user(steamid)
                            end

                            js.update_player(data.idx, "file://{images}/icons/asylum/scoreboard.png")
                        end
                    end
                end
            end

            update_local()
        end

        local directories = {
            "materials",
            "panorama",
            "images",
            "icons",
            "asylum"
        }

        local files_td = {
            ["scoreboard.png"] = current_link
        }

        local file_exists = utils.get_vfunc("filesystem_stdio.dll", "VBaseFileSystem011", 10, "bool(__thiscall*)(void*, const char*, const char*)")

        if not db.asylum_scoreboard then
            db.asylum_scoreboard = current_link
        end

        local function download_images()
            local game_directory = common.get_game_directory()

            local prev_path = game_directory .. "\\"
            for i = 1, #directories do
                local this_path = prev_path .. directories[i]

                files.create_folder(this_path)

                prev_path = this_path .. "\\"
            end

            local directory = prev_path
            for name, url in pairs(files_td) do
                local path = directory .. name

                if not file_exists(path, nil) or db.asylum_scoreboard ~= current_link then
                    local bytes = network.get(url)

                    if bytes then
                        files.write(path, bytes, true)
                    end

                    db.asylum_scoreboard = current_link
                end
            end
        end

        return {
            update_local       = update_local,
            clean_players      = clean_players,
            send_messages      = send_messages,
            download_images    = download_images,
            receive_messages   = receive_messages,
            accept_connections = accept_connections
        }
    end)()

    synchronization.download_images()

    local is_even_working = false
    local updated_last_time = false
    events.render:set(function ()
        is_even_working = ui_handler.elements["interface"]["shared_logo"]

        if globals.is_connected and globals.is_in_game then
            if is_even_working then
                if not updated_last_time then
                    synchronization.update_local()
                    updated_last_time = true
                end
            else
                if updated_last_time then
                    js.clear()
                    synchronization.clean_players()

                    updated_last_time = false
                end
            end
        end
    end)

    events.shutdown:set(function()
        synchronization.clean_players()

        if js and js.destroy then
	        js.destroy()
        end
    end)

    events.round_end:set(function()
        if is_even_working then
            synchronization.send_messages()
        else
            synchronization.clean_players()
        end

        js.clear()
    end)

    events.round_prestart:set(function()
        if is_even_working then
            synchronization.accept_connections()
        end
    end)

    events.round_prestart:set(function()
        if is_even_working then
            synchronization.receive_messages()
        end
    end)
end

chat_spammer.phrases = {
    "¤¸¸.•´¯•¸¸.•..>> 45y1um <<..•.¸¸•´¯•.¸¸¤", "ᶫᵒᵛᵉᵧₒᵤ ķάķ ӂέ ῆόxɤú ᶫᵒᵛᵉᵧₒᵤ", "『N』『E』『W』 『E』『R』『A』"
}

chat_spammer.handle = function(e)
    if not ui_handler.elements["interface"]["chat_spammer"] then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local victim = entity.get(e.userid, true)

    if victim == nil or victim == player then
        return
    end

    local attacker = entity.get(e.attacker, true)

    if attacker ~= player then
        return
    end

    utils.console_exec(("say %s"):format(chat_spammer.phrases[math.random(1, #chat_spammer.phrases)]))
end

menu.switch(ui_handler.tab.interface.additional, "Chat Spammer")("interface", "chat_spammer")
menu.switch(ui_handler.tab.interface.additional, "Shared Logo")("interface", "shared_logo")

hitchance.weapon_types = {
    ["SCAR-20"] = "AutoSnipers",
    ["G3SG1"] = "AutoSnipers",
    ["Glock-18"] = "Pistols",
    ["CZ75-Auto"] = "Pistols",
    ["P250"] = "Pistols",
    ["Five-SeveN"] = "Pistols",
    ["Dual Berettas"] = "Pistols",
    ["Tec-9"] = "Pistols",
    ["P2000"] = "Pistols",
    ["USP-S"] = "Pistols",
    ["MAC-10"] = "SMG",
    ["MP9"] = "SMG",
    ["MP7"] = "SMG",
    ["UMP-45"] = "SMG",
    ["PP-Bizon"] = "SMG",
    ["P90"] = "SMG",
    ["Galil AR"] = "Rifle",
    ["FAMAS"] = "Rifle",
    ["AK-47"] = "Rifle",
    ["M4A4"] = "Rifle",
    ["M4A4-S"] = "Rifle",
    ["SG 553"] = "Rifle",
    ["AUG"] = "Rifle",
    ["Nova"] = "Shotgun",
    ["XM1014"] = "Shotgun",
    ["Sawed-Off"] = "Shotgun",
    ["MAG-7"] = "Shotgun",
    ["M249"] = "Machine Gun",
    ["Negev"] = "Machine Gun"
}
hitchance.handle = function()
    if not ui_handler.elements["interface"]["hitchance_manipulation"] then
        return
    end

    local noscope_weapons = ui_handler.refs["interface"]["noscope_allowed_weapons"].ref
    local inair_weapons = ui_handler.refs["interface"]["inair_allowed_weapons"].ref

    local player = entity.get_local_player()

    if player == nil or not player:is_alive() then
        return
    end

    local weap = player:get_player_weapon()
    local wpn_name = weap ~= nil and weap:get_name()
    local wpn = weap ~= nil and weap:get_weapon_index() or 8 --чзх
    local choosed_weapon = hitchance.weapon_types[wpn_name] or wpn_name
  
    local noscope = (noscope_weapons:get(choosed_weapon)) and not player.m_bIsScoped							
    local in_air = (inair_weapons:get(choosed_weapon)) and (not (bit.band(player.m_fFlags, bit.lshift(1, 0)) ~= 0) or skeet_indication.is_jumping)

    if noscope then
        neverlose_refs.override("hitchance", ui_handler.elements["interface"]["hitchance_manipulation_noscope"])
    end

    if in_air then
        neverlose_refs.override("hitchance", ui_handler.elements["interface"]["hitchance_manipulation_in_air"])
    end
end

aspect_ratio.handle = function()
    if ui_handler.elements["interface"]["aspect_ratio"] then
        cvar.r_aspectratio:float(ui_handler.elements["interface"]["aspect_ratio_value"] / 100)
    else
        cvar.r_aspectratio:float(0)
    end
end

aspect_ratio.destroy = function()
    cvar.r_aspectratio:float(0)
end

menu.switch(ui_handler.tab.interface.miscellaneous, "Override Aspect Ratio")("interface", "aspect_ratio", false)(function(group)

    menu.slider(group, "Value", 0, 300, 0, 0.01, function(value) value = value == 0 and "off" or value end)("interface", "aspect_ratio_value", false, function()
        return ui_handler.elements["interface"]["aspect_ratio"]
    end)():set_callback(aspect_ratio.handle)

end):set_callback(aspect_ratio.handle)

grenade_radius.get = function()
    local player = entity.get_local_player()
    
    if player == nil then
        return
    end

    local CSmokeGrenadeProjectile = entity.get_entities("CSmokeGrenadeProjectile")
    local CInferno = entity.get_entities("CInferno")
    local is_not_friendly_fire = cvar.mp_friendlyfire:int() == 0

    local smoke = {{position = vector(0, 0, 0), percentage = 0, alpha = 0, draw = false}}
    local molotov = {{position = vector(0, 0, 0), percentage = 0, radius = 0, alpha = 0, draw = false, teammate = false}}

    local tickcount = globals.tickcount
    local tickinterval = globals.tickinterval

    if CSmokeGrenadeProjectile ~= nil then

        for k, v in pairs(CSmokeGrenadeProjectile) do
            if smoke[k] == nil then
                smoke[k] = {}
            end

            smoke[k].percentage = (17.55 -  tickinterval * (tickcount - v.m_nSmokeEffectTickBegin))/17.55
            smoke[k].position = v:get_origin()
            smoke[k].alpha = v:get_bbox().alpha*255

            if v.m_bDidSmokeEffect and v:get_bbox().alpha ~= 0 then
                smoke[k].draw = true
            end
        end
    end

    if CInferno ~= nil then
        for k, v in pairs(CInferno) do
            if molotov[k] == nil then
                molotov[k] = {}
            end

            molotov[k].percentage = (7 -  tickinterval * (tickcount - v.m_nFireEffectTickBegin))/7
            molotov[k].position = v:get_origin()
            molotov[k].alpha = v:get_bbox().alpha*255

            local m_hOwnerEntity = v.m_hOwnerEntity

            if m_hOwnerEntity ~= nil and is_not_friendly_fire and m_hOwnerEntity ~= player and not m_hOwnerEntity:is_enemy() then
                molotov[k].teammate = true
            end

            local Cell_Radius = 40
            local Molotov_Radius = 0
            local Cells = {}
            local Maximum_Distance = 0
            local Cell_Max_A, Cell_Max_B
            for i = 1, 64 do
                if v.m_bFireIsBurning[i] == true then
                    table.insert(Cells, vector(v.m_fireXDelta[i], v.m_fireYDelta[i], v.m_fireZDelta[i]))
                end
            end

            local cells_num = #Cells
            for v = 1, cells_num do
                for k = 1, cells_num do
                    local Distance = Cells[v]:dist(Cells[k])
                    if Distance > Maximum_Distance then
                        Maximum_Distance = Distance
                        Cell_Max_A = Cells[v]
                        Cell_Max_B = Cells[k]
                    end
                end
            end

            if Cell_Max_A ~= nil and Cell_Max_B ~= nil and v:get_bbox().alpha ~= 0 then
                molotov[k].draw = true
                molotov[k].radius = (Maximum_Distance/2 + Cell_Radius)
            end
        end
    end

    return {smoke = smoke, molotov = molotov}
end

grenade_radius.handle = function()
    --ui.find("Miscellaneous", "Main", "Other", "Windows"):set("Watermark", "")
    if not ui_handler.elements["interface"]["grenade_radius"] or ui_handler.elements["interface"]["grenade_radius_type"]._len == 0 then
        return
    end

    local grenade_radius_style = ui_handler.elements["interface"]["grenade_radius_style"]

    local molotov_enabled = ui_handler.elements["interface"]["grenade_radius_type"]["Molotov"]
    local smoke_enabled   = ui_handler.elements["interface"]["grenade_radius_type"]["Smoke"]

    if not molotov_enabled and not smoke_enabled then
        return
    end

    local grenade = grenade_radius.get()
    
    if grenade == nil then
        return
    end

    local molotov_color = ui_handler.elements["interface"]["grenade_radius_molotov"]
    local smoke_color = ui_handler.elements["interface"]["grenade_radius_smoke"]

    local anim = {}

    local molotov_alpha = molotov_color.a / 255

    anim.molotov_radius = {}
    if molotov_enabled then
        for i = 1, #grenade.molotov do
            local v = grenade.molotov[i]
            anim.molotov_radius[i] = animations.new("molotov_radius_" .. i, v.draw and v.radius or 0, 0.095)
            if v.draw then
                render.circle_3d_outline(v.position, molotov_color:override("a", molotov_alpha * v.alpha), anim.molotov_radius[i], 0, 1, 1.5)
                render.text(1, render.world_to_screen(v.position), (v.teammate and color(149, 184, 6, 255) or color(230, 21, 21, 255)):override("a", 255), nil, v.teammate and "✔" or "❌")
            end
        end
    end

    local smoke_alpha = smoke_color.a / 255

    anim.smoke_radius = {}
    if smoke_enabled then
        for i = 1, #grenade.smoke do
            local v = grenade.smoke[i]
            anim.smoke_radius[i] = animations.new("smoke_radius_" .. i, v.draw and 125 or 0, 0.095)

            if v.draw then
                render.circle_3d_outline(v.position, smoke_color:override("a",  smoke_alpha * v.alpha), anim.smoke_radius[i], 0, 1, 1.5)
            end
        end
    end
end

molotov_wireframe.materials = {
    "particle/particle_flares/particle_flare_gray",
    "particle/smoke1/smoke1_nearcull2",
    "particle/vistasmokev1/vistasmokev1_nearcull",
    "particle/smoke1/smoke1_nearcull",
    "particle/vistasmokev1/vistasmokev1_nearcull_nodepth",
    "particle/vistasmokev1/vistasmokev1_nearcull_fog",
    "particle/vistasmokev1/vistasmokev4_nearcull",
    "particle/smoke1/smoke1_nearcull3",
    "particle/fire_burning_character/fire_env_fire_depthblend_oriented",
    "particle/fire_burning_character/fire_burning_character",
    "particle/fire_explosion_1/fire_explosion_1_oriented",
    "particle/fire_explosion_1/fire_explosion_1_bright",
    "particle/fire_burning_character/fire_burning_character_depthblend",
    "particle/fire_burning_character/fire_env_fire_depthblend"
}

molotov_wireframe.handle = function()
    for _, v in pairs(molotov_wireframe.materials) do
        local material = materials.get(v)

        if material ~= nil then
            material:var_flag(28, ui_handler.elements["interface"]["molotov_wireframe"] and ui_handler.elements["interface"]["molotov_wireframe_"])
            material:var_flag(15, ui_handler.elements["interface"]["molotov_wireframe"] and ui_handler.elements["interface"]["molotov_wireframe_ignore_z"])
        end
    end
end

unmute_silenced.toggle_mute = panorama.FriendsListAPI.ToggleMute
unmute_silenced.is_muted = panorama.FriendsListAPI.IsSelectedPlayerMuted


unmute_silenced.handle = function()
    if not ui_handler.elements["interface"]["mute_everyone"] then
        return
    end

    local combo_status = ui_handler.elements["interface"]["mute_everyone_settings"]

    local players = entity.get_players(ui_handler.elements["interface"]["mute_enemy"], true, function(player)
        local info = player:get_player_info()
        local steamid64 = info.steamid64
        local is_muted = unmute_silenced.is_muted(steamid64)

        if combo_status == "Unmute" and is_muted then
            unmute_silenced.toggle_mute(steamid64)
        elseif combo_status == "Mute" and not is_muted then
            unmute_silenced.toggle_mute(steamid64)
        end
    end)
end

menu.switch(ui_handler.tab.interface.miscellaneous, "Mute/Unmute Silenced")("interface", "mute_everyone", true)(function(group)
    menu.switch(group, "Only Enemy")("interface", "mute_enemy", true, function()
        return ui_handler.elements["interface"]["mute_everyone"]
    end)():set_callback(unmute_silenced.handle)

    menu.combo(group, "Settings", {"Mute", "Unmute"})("interface", "mute_everyone_settings", true, function()
        return ui_handler.elements["interface"]["mute_everyone"]
    end)():set_callback(unmute_silenced.handle)
end):set_callback(unmute_silenced.handle)

menu.switch(ui_handler.tab.interface.miscellaneous, "Console Modulation")("interface", "console_switch")(function(group)

    menu.color_picker(group, "Color", colors.white)("interface", "console_color", true, function()
        return ui_handler.elements["interface"]["console_switch"]
    end)

end):set_callback(function()
    console_color:shutdown()
end)

menu.switch(ui_handler.tab.interface.miscellaneous, "Molotov Wireframe")("interface", "molotov_wireframe", true)(function(group)
    menu.switch(group, "Wireframe")("interface", "molotov_wireframe_", true, function()
        return ui_handler.elements["interface"]["molotov_wireframe"]
    end)()
    menu.switch(group, "Ignore Z")("interface", "molotov_wireframe_ignore_z", true, function()
        return ui_handler.elements["interface"]["molotov_wireframe"]
    end)()
end)

fast_ladder.handle = function(cmd)
    if not ui_handler.elements["interface"]["fast_ladder"] then
        return
    end

    local player = entity.get_local_player()

    if not player then
        return
    end

    if player.m_MoveType ~= 9 then
        return
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

menu.switch(ui_handler.tab.interface.miscellaneous, "Fast Ladder Move")("interface", "fast_ladder")

taskbar_notify.get_csgo_hwnd = function()
    return ffi_handler.hwnd_ptr[0]
end

taskbar_notify.get_foreground_hwnd = function()
    return ffi_handler.insn_jmp_ecx(ffi_handler.GetForegroundWindow)
end

taskbar_notify.notify_user = function()
    local csgo_hwnd = taskbar_notify.get_csgo_hwnd()
    if ui_handler.elements["interface"]["taskbar_notify"] and taskbar_notify.get_foreground_hwnd() ~= csgo_hwnd then
        ffi_handler.flash_window(csgo_hwnd, 1)
    end
end

events.round_start:set(function()
    taskbar_notify.notify_user()
end)

menu.switch(ui_handler.tab.interface.miscellaneous, "Taskbar Notify")("interface", "taskbar_notify", true)

discharge_exploit.enum = {
    WEAPONTYPE_KNIFE = 0,
    WEAPONTYPE_PISTOL = 1,
    WEAPONTYPE_SUBMACHINEGUN = 2,
    WEAPONTYPE_RIFLE = 3,
    WEAPONTYPE_SHOTGUN = 4,
    WEAPONTYPE_SNIPER_RIFLE = 5,
    WEAPONTYPE_MACHINEGUN = 6,
    WEAPONTYPE_C4 = 7,
    WEAPONTYPE_PLACEHOLDER = 8,
    WEAPONTYPE_GRENADE = 9,
    WEAPONTYPE_UNKNOWN = 10
}

discharge_exploit.createmove = function()
    if not ui_handler.elements["aa"]["teleport_exp"] or not neverlose_refs.doubletap:get() then return end

    if rage.exploit:get() ~= 1 then 
        return 
    end
        
    local me = entity.get_local_player()
    if me == nil then return end
    local wpn = me:get_player_weapon()
    if wpn == nil then return end

    local info = wpn:get_weapon_info()
    local weapon_type = info.weapon_type

    if weapon_type == discharge_exploit.enum.WEAPONTYPE_KNIFE or weapon_type >= discharge_exploit.enum.WEAPONTYPE_C4 then return end

    local enemies = entity.get_players(true, false)

    if ui_handler.elements["aa"]["teleport_in_air_only"] then
        if (conditional_antiaims.player_state == conditional_antiaims.states.air or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch) then
            for k, v in pairs(enemies) do
                if not v:is_alive() then
                    goto skip
                end

                if v:is_visible() then
                    return rage.exploit:force_teleport()
                end

                ::skip::
            end
        end
    else
        for k, v in pairs(enemies) do
            if not v:is_alive() then
                goto skip
            end

            if v:is_visible() then
                return rage.exploit:force_teleport()
            end

            ::skip::
        end
    end
end

menu.switch(ui_handler.tab.antiaim.general, "Teleport Exploit")("aa", "teleport_exp", true, function()
    return ui_handler.elements["aa"]["enable"]
end)(function(gear)
    menu.switch(gear, 'In Air Only')("aa", "teleport_in_air_only", true, function()
        return ui_handler.elements["aa"]["enable"] and ui_handler.elements["aa"]["teleport_exp"]
    end)
end)

menu.switch(ui_handler.tab.antiaim.general, "Safe Functions")("aa", "safe_functions", true, function()
    return ui_handler.elements["aa"]["enable"]
end)(function(gear)

    menu.selectable(gear, "Settings", {"Head", "Knife", "Zeus"})("aa", "safe_funcs_settings", true, function()
        return ui_handler.elements["aa"]["safe_functions"]
    end)
    
    menu.selectable(gear, "Safe Head", {"Height", "High Distance"})("aa", "safe_head_settings", true, function()
        return ui_handler.elements["aa"]["safe_functions"] and ui_handler.refs["aa"]["safe_funcs_settings"].ref:get("Head")
    end)

    safe_functions_add.defensive_aa = menu.switch(gear, 'Defensive AA')("aa", "safe_defensive_aa", true, function()
        return ui_handler.elements["aa"]["safe_functions"]
    end)

    safe_functions_add.defensive_pitch = menu.combo(gear, "Pitch\nsafe_defensive_pitch", {"Disabled", "Up", "Zero", "Random", "Custom"})("aa", "safe_defensive_pitch", true, function()
        return ui_handler.elements["aa"]["safe_functions"] and ui_handler.elements["aa"]["safe_defensive_aa"]
    end)

    safe_functions_add.defensive_yaw = menu.combo(gear, "Yaw\nsafe_defensive_yaw", {"Disabled", "Sideways", "Opposite", "Random", "Spin", "3-Way", "5-Way", "Neverlose", "Custom"})("aa", "safe_defensive_yaw", true, function()
        return ui_handler.elements["aa"]["safe_functions"] and ui_handler.elements["aa"]["safe_defensive_aa"]
    end)

    safe_functions_add.pitch_slider = menu.slider(gear, "Custom Pitch\nsafe_defensive_custom_pitch", -89, 89, 0)("aa", "safe_defensive_pitch_slider", true, function()
        return ui_handler.elements["aa"]["safe_functions"] and ui_handler.elements["aa"]["safe_defensive_aa"] and ui_handler.elements["aa"]["safe_defensive_pitch"] == "Custom"
    end)

    safe_functions_add.hide_shots = menu.switch(gear, 'On Hide Shots\nsafe_defensive_hide_shots')("aa", "safe_defensive_hide_shots", true, function()
        return ui_handler.elements["aa"]["safe_functions"] and ui_handler.elements["aa"]["safe_defensive_aa"]
    end)

    safe_functions_add.lag_options = menu.combo(gear, "Lag Options\nsafe_defensive_lag_options", {"On Peek", "Always On"})("aa", "safe_defensive_lag_options", true, function()
        return ui_handler.elements["aa"]["safe_functions"]
    end)

end)

menu.switch(ui_handler.tab.antiaim.general, "Edge Yaw")("aa", "edge_yaw_key", true, function()
    return ui_handler.elements["aa"]["enable"]
end)

model_breaker.handle = safecall("model_breaker.handle", true, function()

    if not ui_handler.elements["aa"]["enable"] or not ui_handler.elements["aa"]["model_breakers"] then
        return
    end
    
    local player = entity.get_local_player()
    local thisptr = ffi_handler.get_entity_address(player:get_index())
    if player == nil then
        return
    end

    local in_air = not (bit.band(player.m_fFlags, bit.lshift(1, 0)) ~= 0) or skeet_indication.is_jumping

    if ui_handler.elements["aa"]["model_breakers_breaked_legs"] == "Static" then
        neverlose_refs.legs:set("Sliding")
        player.m_flPoseParameter[0] = 1
    elseif ui_handler.elements["aa"]["model_breakers_breaked_legs"] == "Jitter" then
        neverlose_refs.legs:set("Sliding")
        player.m_flPoseParameter[0] = globals.tickcount%(10-ui_handler.elements["aa"]["model_breakers_legs_speed"]/10) > 1 and ui_handler.elements["aa"]["model_breakers_legs_val"]/100 or 1
    elseif ui_handler.elements["aa"]["model_breakers_breaked_legs"] == "Allah" then
        neverlose_refs.legs:set("Walking")
        player.m_flPoseParameter[7] = 0
    elseif ui_handler.elements["aa"]["model_breakers_breaked_legs"] == "Blend" then
        player.m_flPoseParameter[8] = 0
        player.m_flPoseParameter[9] = 0
    end

    if ui_handler.elements["aa"]["model_breakers_air_legs"] == "Static" then
        player.m_flPoseParameter[6] = 1
    elseif ui_handler.elements["aa"]["model_breakers_air_legs"] == "Haram" and in_air then
        ffi.cast("CAnimationLayer**", ffi.cast("uintptr_t", thisptr) + 0x2990)[0][6].m_flWeight = 1
    end

    if ui_handler.elements["aa"]["model_breakers_pitch_on_land"] then
        if not in_air and ffi.cast("CCSGOPlayerAnimationState_534535_t**", ffi.cast("uintptr_t", thisptr) + 0x9960)[0].bHitGroundAnimation then
            player.m_flPoseParameter[12] = 0.5
        end
    end

    if ui_handler.elements["aa"]["model_breakers_move_lean"] ~= 0 and player.m_vecVelocity:length() > 3 then
        ffi.cast("CAnimationLayer**", ffi.cast("uintptr_t", thisptr) + 0x2990)[0][12].m_flWeight = ui_handler.elements["aa"]["model_breakers_move_lean"]/100*2.5
    end
end)

menu.switch(ui_handler.tab.antiaim.general, defines.colored_text({"Animation Breakers", "B6B665FF"}))("aa", "model_breakers", true, function()
    return ui_handler.elements["aa"]["enable"]
end)(function(group)

    menu.combo(group, "Breaked Legs", {"Disabled", "Static", "Jitter", "Allah", "Blend"})("aa", "model_breakers_breaked_legs", true, function()
        return ui_handler.elements["aa"]["model_breakers"]
    end)

    menu.slider(group, defines.colored_text({"icon_caret-right", color(75, 75, 75)}, {"  Jitter Speed"}), 1, 100, 60, nil, "%")("aa", "model_breakers_legs_speed", true, function()
        return ui_handler.elements["aa"]["model_breakers"] and ui_handler.elements["aa"]["model_breakers_breaked_legs"] == "Jitter"
    end)

    menu.slider(group, defines.colored_text({"icon_caret-right", color(75, 75, 75)}, {"  Jitter Value"}), 1, 100, 85, nil, "%")("aa", "model_breakers_legs_val", true, function()
        return ui_handler.elements["aa"]["model_breakers"] and ui_handler.elements["aa"]["model_breakers_breaked_legs"] == "Jitter"
    end)

    menu.combo(group, "Air Legs", {"Disabled", "Static", "Haram"})("aa", "model_breakers_air_legs", true, function()
        return ui_handler.elements["aa"]["model_breakers"]
    end)

    menu.switch(group, "Pitch on Land")("aa", "model_breakers_pitch_on_land", true, function()
        return ui_handler.elements["aa"]["model_breakers"]
    end)

    menu.slider(group, "Move Lean", 0, 100, 0, nil, "%")("aa", "model_breakers_move_lean", true, function()
        return ui_handler.elements["aa"]["model_breakers"]
    end)

end)

conditional_antiaims.manual_yaws = {
    ["Forward"] = 180,
    ["Left"] = -90,
    ["Right"] = 90
}

conditional_antiaims.get_distance = function() 
    local result = math.huge;
    local heightDifference = 0;
    local localplayer = entity.get_local_player();
    local entities = entity.get_players(true, true);

    for i = 1, #entities do
      local entity = entities[i];
      if entity ~= localplayer and entity:is_alive() then
        local distance = (entity:get_origin() - localplayer:get_origin()):length2d();
        if distance < result and entity:get_network_state() == 0 then 
            result = distance; 
            heightDifference = entity:get_origin().z - localplayer:get_origin().z;
        end
      end
    end
    
    return math.floor(result/10) == 1e309 and 0 or math.floor(result/10), math.floor(result/10) == 1e309 and 0 or math.floor(heightDifference);
end

conditional_antiaims.set_yaw_base = function(new_config)
    if not ui_handler.elements["aa"]["enable"] then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end
    
    local manual_yaw = ui_handler.elements["aa"]["manuals"]
    local manuals_over_fs = ui_handler.elements["aa"]["manuals_over_fs"]
    local is_manuals = (manual_yaw == "Left" or manual_yaw == "Right" or manual_yaw == "Forward")

    local weapon = player:get_player_weapon()
    local knife = weapon ~= nil and weapon:get_classname() == "CKnife"
    local zeus = weapon ~= nil and weapon:get_classname() == "CWeaponTaser" 
    local safe_knife = (ui_handler.elements["aa"]["safe_functions"] and ui_handler.refs["aa"]["safe_funcs_settings"].ref:get("Knife")) and knife
    local safe_zeus = (ui_handler.elements["aa"]["safe_functions"] and ui_handler.refs["aa"]["safe_funcs_settings"].ref:get("Zeus")) and zeus
    
    local safe_head = (ui_handler.elements["aa"]["safe_functions"] and ui_handler.refs["aa"]["safe_funcs_settings"].ref:get("Head"))
    local distance_to_enemy = {conditional_antiaims.get_distance()}

    conditional_antiaims.safe_knife = safe_knife and (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
    conditional_antiaims.safe_zeus = safe_zeus and (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
    local is_predefined = conditional_antiaims.manual_yaws[manual_yaw]

    if edge_yaw.is_edging then
        new_config.yaw_offset = edge_yaw.angle
        new_config.yaw_base = "Local View"
        new_config.yaw = "Backward"
        new_config.freestanding = false   
    elseif (safe_knife or safe_zeus) and not is_manuals and (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag) then
        new_config.yaw_offset = 0
        new_config.yaw_modifier = "Disabled"
        new_config.body_yaw_options = ""
        new_config.left_limit = 0
        new_config.right_limit = 0   
    elseif (safe_head and not is_manuals) and (conditional_antiaims.safe_active) then
        new_config.yaw_offset = 0
        new_config.yaw_modifier = "Disabled"
        new_config.body_yaw_options = ""
        new_config.left_limit = 0
        new_config.right_limit = 0   
    elseif not antiaim_on_use.enabled then
        if ui_handler.elements["aa"]["static_on_manuals"] and is_manuals then
            new_config.yaw_modifier = "Disabled"
            new_config.inverter = ui_handler.elements["aa"]["manual_inverter"]
            new_config.left_limit = ui_handler.elements["aa"]["manual_left_limit"]
            new_config.right_limit = ui_handler.elements["aa"]["manual_right_limit"]
            new_config.body_yaw_options = ui_handler.refs["aa"]["manual_body_yaw_options"].ref:get()
            new_config.body_yaw_freestanding = ui_handler.elements["aa"]["manual_body_yaw_freestanding"]

        end

        if manual_yaw == "At Target" then
            new_config.yaw_base = "At Target"
        else
            new_config.yaw_base = "Local View"
        end
        
        if is_predefined then
            new_config.yaw_offset = (ui_handler.elements["aa"]["static_on_manuals"] and 0 or (new_config.yaw_offset or 0)) + is_predefined
        end
        
    elseif antiaim_on_use.enabled then
        new_config.yaw_base = "Local View"
    end

    new_config.freestanding = not (manuals_over_fs and (manual_yaw == "Left" or manual_yaw == "Right")) and neverlose_refs.freestanding:get()
    new_config.yaw_backstab = true
end

menu.combo(ui_handler.tab.antiaim.general, "Yaw Base", {"Forward", "Backward", "Left", "Right", "At Target"})("aa", "manuals", true, function()
    return ui_handler.elements["aa"]["enable"]
end)(function(group)
    menu.switch(group, "Manual over FS")("aa", "manuals_over_fs", true, function()
        return ui_handler.elements["aa"]["enable"]
    end)
end)

menu.combo(ui_handler.tab.antiaim.builder, "State", {"Shared"})("aa", "condition_combo", true, function()
    return ui_handler.elements["aa"]["enable"]
end)

menu.list(ui_handler.tab.antiaim.presets, "", {"Default"})("aa", "aa_presets", false, function()
    return ui_handler.elements["aa"]["enable"]
end)

menu.input(ui_handler.tab.antiaim.presets, "Preset Name", "New Config")("aa", "aa_name", false, function()
    return ui_handler.elements["aa"]["enable"]
end)

conditional_antiaims.presets = {
    names = {"Default"},
    values = {"asylum_eyJhYSI6eyJjb25kaXRpb25fY29tYm8iOiJTaGFyZWQiLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9ib2R5X3lhdyI6IkRlZmF1bHQiLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9kZWZlbnNpdmVfYWEiOnRydWUsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX2RlZmVuc2l2ZV9waXRjaCI6IlVwIiwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfZGVmZW5zaXZlX3lhdyI6IlNpZGV3YXlzIiwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfZGVsYXlfdGlja3MiOjYuMCwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfbGFnX29wdGlvbnMiOiJBbHdheXMgT24iLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9sZWZ0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9sZWZ0X3lhd19vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfb25faGlkZV9zaG90cyI6dHJ1ZSwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfb3ZlcnJpZGUiOnRydWUsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF9yaWdodF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfcmlnaHRfeWF3X29mZnNldCI6MC4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF95YXciOiJCYWNrd2FyZCIsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3lhd19tb2RpZmllciI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19BaXIgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF95YXdfbW9kaWZpZXJfb2Zmc2V0MSI6MC4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF95YXdfbW9kaWZpZXJfb2Zmc2V0MTMzNyI6LTU3LjAsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3lhd19tb2RpZmllcl9vZmZzZXQyIjowLjAsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3lhd19tb2RpZmllcl9vZmZzZXQzIjowLjAsImNvbmRpdGlvbnNfQWlyICYgQ3JvdWNoX3lhd19tb2RpZmllcl9vZmZzZXQ5NzkiOi01MS4wLCJjb25kaXRpb25zX0FpciAmIENyb3VjaF95YXdfc2xpZGVyIjowLjAsImNvbmRpdGlvbnNfQWlyX2JvZHlfeWF3IjoiQWR2YW5jZWQiLCJjb25kaXRpb25zX0Fpcl9ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX0Fpcl9ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX0Fpcl9kZWZlbnNpdmVfYWEiOnRydWUsImNvbmRpdGlvbnNfQWlyX2RlZmVuc2l2ZV9waXRjaCI6Ilplcm8iLCJjb25kaXRpb25zX0Fpcl9kZWZlbnNpdmVfeWF3IjoiU3BpbiIsImNvbmRpdGlvbnNfQWlyX2RlbGF5X3RpY2tzIjo2LjAsImNvbmRpdGlvbnNfQWlyX2xhZ19vcHRpb25zIjoiQWx3YXlzIE9uIiwiY29uZGl0aW9uc19BaXJfbGVmdF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19BaXJfbGVmdF95YXdfb2Zmc2V0IjotMjQuMCwiY29uZGl0aW9uc19BaXJfb25faGlkZV9zaG90cyI6dHJ1ZSwiY29uZGl0aW9uc19BaXJfb3ZlcnJpZGUiOnRydWUsImNvbmRpdGlvbnNfQWlyX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfQWlyX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX0Fpcl9yaWdodF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19BaXJfcmlnaHRfeWF3X29mZnNldCI6MzguMCwiY29uZGl0aW9uc19BaXJfeWF3IjoiQmFja3dhcmQiLCJjb25kaXRpb25zX0Fpcl95YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfQWlyX3lhd19tb2RpZmllcl9vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19BaXJfeWF3X21vZGlmaWVyX29mZnNldDEiOjQyLjAsImNvbmRpdGlvbnNfQWlyX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjotNzAuMCwiY29uZGl0aW9uc19BaXJfeWF3X21vZGlmaWVyX29mZnNldDIiOjQyLjAsImNvbmRpdGlvbnNfQWlyX3lhd19tb2RpZmllcl9vZmZzZXQzIjotNi4wLCJjb25kaXRpb25zX0Fpcl95YXdfbW9kaWZpZXJfb2Zmc2V0OTc5IjotNjMuMCwiY29uZGl0aW9uc19BaXJfeWF3X3NsaWRlciI6MzcuMCwiY29uZGl0aW9uc19Dcm91Y2hfYm9keV95YXciOiJEZWZhdWx0IiwiY29uZGl0aW9uc19Dcm91Y2hfYm9keV95YXdfZnJlZXN0YW5kaW5nIjoiT2ZmIiwiY29uZGl0aW9uc19Dcm91Y2hfYm9keV95YXdfb3B0aW9ucyI6W10sImNvbmRpdGlvbnNfQ3JvdWNoX2RlZmVuc2l2ZV9hYSI6dHJ1ZSwiY29uZGl0aW9uc19Dcm91Y2hfZGVmZW5zaXZlX3BpdGNoIjoiVXAiLCJjb25kaXRpb25zX0Nyb3VjaF9kZWZlbnNpdmVfeWF3IjoiU2lkZXdheXMiLCJjb25kaXRpb25zX0Nyb3VjaF9kZWxheV90aWNrcyI6Ni4wLCJjb25kaXRpb25zX0Nyb3VjaF9sYWdfb3B0aW9ucyI6IkFsd2F5cyBPbiIsImNvbmRpdGlvbnNfQ3JvdWNoX2xlZnRfbGltaXQiOjYwLjAsImNvbmRpdGlvbnNfQ3JvdWNoX2xlZnRfeWF3X29mZnNldCI6MTcuMCwiY29uZGl0aW9uc19Dcm91Y2hfb25faGlkZV9zaG90cyI6dHJ1ZSwiY29uZGl0aW9uc19Dcm91Y2hfb3ZlcnJpZGUiOnRydWUsImNvbmRpdGlvbnNfQ3JvdWNoX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfQ3JvdWNoX3BpdGNoX3NsaWRlciI6LTUyLjAsImNvbmRpdGlvbnNfQ3JvdWNoX3JpZ2h0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX0Nyb3VjaF9yaWdodF95YXdfb2Zmc2V0IjoxNy4wLCJjb25kaXRpb25zX0Nyb3VjaF95YXciOiJCYWNrd2FyZCIsImNvbmRpdGlvbnNfQ3JvdWNoX3lhd19tb2RpZmllciI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19Dcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJjb25kaXRpb25zX0Nyb3VjaF95YXdfbW9kaWZpZXJfb2Zmc2V0MSI6NDkuMCwiY29uZGl0aW9uc19Dcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDEzMzciOi02Ny4wLCJjb25kaXRpb25zX0Nyb3VjaF95YXdfbW9kaWZpZXJfb2Zmc2V0MiI6NDkuMCwiY29uZGl0aW9uc19Dcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDMiOjAuMCwiY29uZGl0aW9uc19Dcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDk3OSI6LTcwLjAsImNvbmRpdGlvbnNfQ3JvdWNoX3lhd19zbGlkZXIiOjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX2JvZHlfeWF3IjoiRGVmYXVsdCIsImNvbmRpdGlvbnNfRmFrZWxhZ19ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX0Zha2VsYWdfYm9keV95YXdfb3B0aW9ucyI6W10sImNvbmRpdGlvbnNfRmFrZWxhZ19kZWZlbnNpdmVfYWEiOmZhbHNlLCJjb25kaXRpb25zX0Zha2VsYWdfZGVmZW5zaXZlX3BpdGNoIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX0Zha2VsYWdfZGVmZW5zaXZlX3lhdyI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19GYWtlbGFnX2RlbGF5X3RpY2tzIjo0LjAsImNvbmRpdGlvbnNfRmFrZWxhZ19sYWdfb3B0aW9ucyI6Ik9uIFBlZWsiLCJjb25kaXRpb25zX0Zha2VsYWdfbGVmdF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX2xlZnRfeWF3X29mZnNldCI6MC4wLCJjb25kaXRpb25zX0Zha2VsYWdfb25faGlkZV9zaG90cyI6ZmFsc2UsImNvbmRpdGlvbnNfRmFrZWxhZ19vdmVycmlkZSI6dHJ1ZSwiY29uZGl0aW9uc19GYWtlbGFnX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfRmFrZWxhZ19waXRjaF9zbGlkZXIiOjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX3JpZ2h0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX0Zha2VsYWdfcmlnaHRfeWF3X29mZnNldCI6MC4wLCJjb25kaXRpb25zX0Zha2VsYWdfeWF3IjoiQmFja3dhcmQiLCJjb25kaXRpb25zX0Zha2VsYWdfeWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX0Zha2VsYWdfeWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJjb25kaXRpb25zX0Zha2VsYWdfeWF3X21vZGlmaWVyX29mZnNldDEiOjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjowLjAsImNvbmRpdGlvbnNfRmFrZWxhZ195YXdfbW9kaWZpZXJfb2Zmc2V0MiI6MC4wLCJjb25kaXRpb25zX0Zha2VsYWdfeWF3X21vZGlmaWVyX29mZnNldDMiOjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX3lhd19tb2RpZmllcl9vZmZzZXQ5NzkiOjAuMCwiY29uZGl0aW9uc19GYWtlbGFnX3lhd19zbGlkZXIiOjAuMCwiY29uZGl0aW9uc19GcmVlc3RhbmRfYm9keV95YXciOiJEZWZhdWx0IiwiY29uZGl0aW9uc19GcmVlc3RhbmRfYm9keV95YXdfZnJlZXN0YW5kaW5nIjoiT2ZmIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfYm9keV95YXdfb3B0aW9ucyI6W10sImNvbmRpdGlvbnNfRnJlZXN0YW5kX2RlZmVuc2l2ZV9hYSI6ZmFsc2UsImNvbmRpdGlvbnNfRnJlZXN0YW5kX2RlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfZGVmZW5zaXZlX3lhdyI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfZGVsYXlfdGlja3MiOjQuMCwiY29uZGl0aW9uc19GcmVlc3RhbmRfbGFnX29wdGlvbnMiOiJPbiBQZWVrIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfbGVmdF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19GcmVlc3RhbmRfbGVmdF95YXdfb2Zmc2V0IjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX29uX2hpZGVfc2hvdHMiOmZhbHNlLCJjb25kaXRpb25zX0ZyZWVzdGFuZF9vdmVycmlkZSI6dHJ1ZSwiY29uZGl0aW9uc19GcmVlc3RhbmRfcGl0Y2giOiJEb3duIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfcGl0Y2hfc2xpZGVyIjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3JpZ2h0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX0ZyZWVzdGFuZF9yaWdodF95YXdfb2Zmc2V0IjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhdyI6IkJhY2t3YXJkIiwiY29uZGl0aW9uc19GcmVlc3RhbmRfeWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX0ZyZWVzdGFuZF95YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhd19tb2RpZmllcl9vZmZzZXQxIjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhd19tb2RpZmllcl9vZmZzZXQyIjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhd19tb2RpZmllcl9vZmZzZXQzIjowLjAsImNvbmRpdGlvbnNfRnJlZXN0YW5kX3lhd19tb2RpZmllcl9vZmZzZXQ5NzkiOjAuMCwiY29uZGl0aW9uc19GcmVlc3RhbmRfeWF3X3NsaWRlciI6MC4wLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9ib2R5X3lhdyI6IkRlZmF1bHQiLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9kZWZlbnNpdmVfYWEiOnRydWUsImNvbmRpdGlvbnNfTW92aW5nICYgQ3JvdWNoX2RlZmVuc2l2ZV9waXRjaCI6Ilplcm8iLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9kZWZlbnNpdmVfeWF3IjoiT3Bwb3NpdGUiLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9kZWxheV90aWNrcyI6Ni4wLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9sYWdfb3B0aW9ucyI6IkFsd2F5cyBPbiIsImNvbmRpdGlvbnNfTW92aW5nICYgQ3JvdWNoX2xlZnRfbGltaXQiOjYwLjAsImNvbmRpdGlvbnNfTW92aW5nICYgQ3JvdWNoX2xlZnRfeWF3X29mZnNldCI6MC4wLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9vbl9oaWRlX3Nob3RzIjp0cnVlLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF9vdmVycmlkZSI6dHJ1ZSwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfcGl0Y2giOiJEb3duIiwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfcGl0Y2hfc2xpZGVyIjotNTIuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfcmlnaHRfbGltaXQiOjYwLjAsImNvbmRpdGlvbnNfTW92aW5nICYgQ3JvdWNoX3JpZ2h0X3lhd19vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3IjoiQmFja3dhcmQiLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF95YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF95YXdfbW9kaWZpZXJfb2Zmc2V0IjotNDQuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDEiOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDEzMzciOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDIiOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDMiOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmcgJiBDcm91Y2hfeWF3X21vZGlmaWVyX29mZnNldDk3OSI6MC4wLCJjb25kaXRpb25zX01vdmluZyAmIENyb3VjaF95YXdfc2xpZGVyIjowLjAsImNvbmRpdGlvbnNfTW92aW5nX2JvZHlfeWF3IjoiQWR2YW5jZWQiLCJjb25kaXRpb25zX01vdmluZ19ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX01vdmluZ19ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX01vdmluZ19kZWZlbnNpdmVfYWEiOnRydWUsImNvbmRpdGlvbnNfTW92aW5nX2RlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19Nb3ZpbmdfZGVmZW5zaXZlX3lhdyI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19Nb3ZpbmdfZGVsYXlfdGlja3MiOjcuMCwiY29uZGl0aW9uc19Nb3ZpbmdfbGFnX29wdGlvbnMiOiJPbiBQZWVrIiwiY29uZGl0aW9uc19Nb3ZpbmdfbGVmdF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19Nb3ZpbmdfbGVmdF95YXdfb2Zmc2V0IjotNDQuMCwiY29uZGl0aW9uc19Nb3Zpbmdfb25faGlkZV9zaG90cyI6dHJ1ZSwiY29uZGl0aW9uc19Nb3Zpbmdfb3ZlcnJpZGUiOnRydWUsImNvbmRpdGlvbnNfTW92aW5nX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfTW92aW5nX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX01vdmluZ19yaWdodF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19Nb3ZpbmdfcmlnaHRfeWF3X29mZnNldCI6NDQuMCwiY29uZGl0aW9uc19Nb3ZpbmdfeWF3IjoiQmFja3dhcmQiLCJjb25kaXRpb25zX01vdmluZ195YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfTW92aW5nX3lhd19tb2RpZmllcl9vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19Nb3ZpbmdfeWF3X21vZGlmaWVyX29mZnNldDEiOjQwLjAsImNvbmRpdGlvbnNfTW92aW5nX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjotODEuMCwiY29uZGl0aW9uc19Nb3ZpbmdfeWF3X21vZGlmaWVyX29mZnNldDIiOjUxLjAsImNvbmRpdGlvbnNfTW92aW5nX3lhd19tb2RpZmllcl9vZmZzZXQzIjotNy4wLCJjb25kaXRpb25zX01vdmluZ195YXdfbW9kaWZpZXJfb2Zmc2V0OTc5IjotNzIuMCwiY29uZGl0aW9uc19Nb3ZpbmdfeWF3X3NsaWRlciI6MC4wLCJjb25kaXRpb25zX09uIFVzZV9ib2R5X3lhdyI6IkRlZmF1bHQiLCJjb25kaXRpb25zX09uIFVzZV9ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX09uIFVzZV9ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX09uIFVzZV9kZWZlbnNpdmVfYWEiOmZhbHNlLCJjb25kaXRpb25zX09uIFVzZV9kZWZlbnNpdmVfcGl0Y2giOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfT24gVXNlX2RlZmVuc2l2ZV95YXciOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfT24gVXNlX2RlbGF5X3RpY2tzIjoxLjAsImNvbmRpdGlvbnNfT24gVXNlX2xhZ19vcHRpb25zIjoiT24gUGVlayIsImNvbmRpdGlvbnNfT24gVXNlX2xlZnRfbGltaXQiOjYwLjAsImNvbmRpdGlvbnNfT24gVXNlX2xlZnRfeWF3X29mZnNldCI6MTgwLjAsImNvbmRpdGlvbnNfT24gVXNlX29uX2hpZGVfc2hvdHMiOmZhbHNlLCJjb25kaXRpb25zX09uIFVzZV9vdmVycmlkZSI6dHJ1ZSwiY29uZGl0aW9uc19PbiBVc2VfcGl0Y2giOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfT24gVXNlX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX09uIFVzZV9yaWdodF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19PbiBVc2VfcmlnaHRfeWF3X29mZnNldCI6MTgwLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhdyI6IkJhY2t3YXJkIiwiY29uZGl0aW9uc19PbiBVc2VfeWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX09uIFVzZV95YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhd19tb2RpZmllcl9vZmZzZXQxIjowLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjowLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhd19tb2RpZmllcl9vZmZzZXQyIjowLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhd19tb2RpZmllcl9vZmZzZXQzIjowLjAsImNvbmRpdGlvbnNfT24gVXNlX3lhd19tb2RpZmllcl9vZmZzZXQ5NzkiOjAuMCwiY29uZGl0aW9uc19PbiBVc2VfeWF3X3NsaWRlciI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF9ib2R5X3lhdyI6IkRlZmF1bHQiLCJjb25kaXRpb25zX1NoYXJlZF9ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX1NoYXJlZF9ib2R5X3lhd19vcHRpb25zIjpbXSwiY29uZGl0aW9uc19TaGFyZWRfZGVmZW5zaXZlX2FhIjpmYWxzZSwiY29uZGl0aW9uc19TaGFyZWRfZGVmZW5zaXZlX3BpdGNoIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX1NoYXJlZF9kZWZlbnNpdmVfeWF3IjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX1NoYXJlZF9kZWxheV90aWNrcyI6MS4wLCJjb25kaXRpb25zX1NoYXJlZF9sYWdfb3B0aW9ucyI6Ik9uIFBlZWsiLCJjb25kaXRpb25zX1NoYXJlZF9sZWZ0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX1NoYXJlZF9sZWZ0X3lhd19vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19TaGFyZWRfb25faGlkZV9zaG90cyI6ZmFsc2UsImNvbmRpdGlvbnNfU2hhcmVkX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfU2hhcmVkX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF9yaWdodF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19TaGFyZWRfcmlnaHRfeWF3X29mZnNldCI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXciOiJCYWNrd2FyZCIsImNvbmRpdGlvbnNfU2hhcmVkX3lhd19tb2RpZmllciI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19TaGFyZWRfeWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXdfbW9kaWZpZXJfb2Zmc2V0MSI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXdfbW9kaWZpZXJfb2Zmc2V0MTMzNyI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXdfbW9kaWZpZXJfb2Zmc2V0MiI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXdfbW9kaWZpZXJfb2Zmc2V0MyI6MC4wLCJjb25kaXRpb25zX1NoYXJlZF95YXdfbW9kaWZpZXJfb2Zmc2V0OTc5IjowLjAsImNvbmRpdGlvbnNfU2hhcmVkX3lhd19zbGlkZXIiOjAuMCwiY29uZGl0aW9uc19TbG93d2Fsa19ib2R5X3lhdyI6IkFkdmFuY2VkIiwiY29uZGl0aW9uc19TbG93d2Fsa19ib2R5X3lhd19mcmVlc3RhbmRpbmciOiJPZmYiLCJjb25kaXRpb25zX1Nsb3d3YWxrX2JvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIl0sImNvbmRpdGlvbnNfU2xvd3dhbGtfZGVmZW5zaXZlX2FhIjp0cnVlLCJjb25kaXRpb25zX1Nsb3d3YWxrX2RlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19TbG93d2Fsa19kZWZlbnNpdmVfeWF3IjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX1Nsb3d3YWxrX2RlbGF5X3RpY2tzIjo3LjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfbGFnX29wdGlvbnMiOiJPbiBQZWVrIiwiY29uZGl0aW9uc19TbG93d2Fsa19sZWZ0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX1Nsb3d3YWxrX2xlZnRfeWF3X29mZnNldCI6LTUwLjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfb25faGlkZV9zaG90cyI6dHJ1ZSwiY29uZGl0aW9uc19TbG93d2Fsa19vdmVycmlkZSI6dHJ1ZSwiY29uZGl0aW9uc19TbG93d2Fsa19waXRjaCI6IkRvd24iLCJjb25kaXRpb25zX1Nsb3d3YWxrX3BpdGNoX3NsaWRlciI6MC4wLCJjb25kaXRpb25zX1Nsb3d3YWxrX3JpZ2h0X2xpbWl0Ijo2MC4wLCJjb25kaXRpb25zX1Nsb3d3YWxrX3JpZ2h0X3lhd19vZmZzZXQiOjUwLjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfeWF3IjoiQmFja3dhcmQiLCJjb25kaXRpb25zX1Nsb3d3YWxrX3lhd19tb2RpZmllciI6IkRpc2FibGVkIiwiY29uZGl0aW9uc19TbG93d2Fsa195YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfeWF3X21vZGlmaWVyX29mZnNldDEiOi0yMy4wLCJjb25kaXRpb25zX1Nsb3d3YWxrX3lhd19tb2RpZmllcl9vZmZzZXQxMzM3IjotNjcuMCwiY29uZGl0aW9uc19TbG93d2Fsa195YXdfbW9kaWZpZXJfb2Zmc2V0MiI6LTIzLjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfeWF3X21vZGlmaWVyX29mZnNldDMiOjM1LjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfeWF3X21vZGlmaWVyX29mZnNldDk3OSI6LTY1LjAsImNvbmRpdGlvbnNfU2xvd3dhbGtfeWF3X3NsaWRlciI6MC4wLCJjb25kaXRpb25zX1N0YW5kaW5nX2JvZHlfeWF3IjoiRGVmYXVsdCIsImNvbmRpdGlvbnNfU3RhbmRpbmdfYm9keV95YXdfZnJlZXN0YW5kaW5nIjoiT2ZmIiwiY29uZGl0aW9uc19TdGFuZGluZ19ib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciJdLCJjb25kaXRpb25zX1N0YW5kaW5nX2RlZmVuc2l2ZV9hYSI6ZmFsc2UsImNvbmRpdGlvbnNfU3RhbmRpbmdfZGVmZW5zaXZlX3BpdGNoIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX1N0YW5kaW5nX2RlZmVuc2l2ZV95YXciOiJEaXNhYmxlZCIsImNvbmRpdGlvbnNfU3RhbmRpbmdfZGVsYXlfdGlja3MiOjcuMCwiY29uZGl0aW9uc19TdGFuZGluZ19sYWdfb3B0aW9ucyI6IkFsd2F5cyBPbiIsImNvbmRpdGlvbnNfU3RhbmRpbmdfbGVmdF9saW1pdCI6NjAuMCwiY29uZGl0aW9uc19TdGFuZGluZ19sZWZ0X3lhd19vZmZzZXQiOi0xNy4wLCJjb25kaXRpb25zX1N0YW5kaW5nX29uX2hpZGVfc2hvdHMiOmZhbHNlLCJjb25kaXRpb25zX1N0YW5kaW5nX292ZXJyaWRlIjp0cnVlLCJjb25kaXRpb25zX1N0YW5kaW5nX3BpdGNoIjoiRG93biIsImNvbmRpdGlvbnNfU3RhbmRpbmdfcGl0Y2hfc2xpZGVyIjowLjAsImNvbmRpdGlvbnNfU3RhbmRpbmdfcmlnaHRfbGltaXQiOjYwLjAsImNvbmRpdGlvbnNfU3RhbmRpbmdfcmlnaHRfeWF3X29mZnNldCI6MzEuMCwiY29uZGl0aW9uc19TdGFuZGluZ195YXciOiJCYWNrd2FyZCIsImNvbmRpdGlvbnNfU3RhbmRpbmdfeWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJjb25kaXRpb25zX1N0YW5kaW5nX3lhd19tb2RpZmllcl9vZmZzZXQiOjAuMCwiY29uZGl0aW9uc19TdGFuZGluZ195YXdfbW9kaWZpZXJfb2Zmc2V0MSI6NDkuMCwiY29uZGl0aW9uc19TdGFuZGluZ195YXdfbW9kaWZpZXJfb2Zmc2V0MTMzNyI6LTY0LjAsImNvbmRpdGlvbnNfU3RhbmRpbmdfeWF3X21vZGlmaWVyX29mZnNldDIiOi0yOS4wLCJjb25kaXRpb25zX1N0YW5kaW5nX3lhd19tb2RpZmllcl9vZmZzZXQzIjoyMy4wLCJjb25kaXRpb25zX1N0YW5kaW5nX3lhd19tb2RpZmllcl9vZmZzZXQ5NzkiOi03Mi4wLCJjb25kaXRpb25zX1N0YW5kaW5nX3lhd19zbGlkZXIiOjAuMCwiZWRnZV95YXdfa2V5IjpmYWxzZSwiZW5hYmxlIjp0cnVlLCJtYW51YWxfYm9keV95YXdfZnJlZXN0YW5kaW5nIjoiT2ZmIiwibWFudWFsX2JvZHlfeWF3X29wdGlvbnMiOltdLCJtYW51YWxfZGVmZW5zaXZlX2FhIjpmYWxzZSwibWFudWFsX2RlZmVuc2l2ZV9oaWRlX3Nob3RzIjpmYWxzZSwibWFudWFsX2RlZmVuc2l2ZV9sYWdfb3B0aW9ucyI6Ik9uIFBlZWsiLCJtYW51YWxfZGVmZW5zaXZlX3BpdGNoIjoiRGlzYWJsZWQiLCJtYW51YWxfZGVmZW5zaXZlX3BpdGNoX3NsaWRlciI6MC4wLCJtYW51YWxfZGVmZW5zaXZlX3lhdyI6IkRpc2FibGVkIiwibWFudWFsX2ludmVydGVyIjpmYWxzZSwibWFudWFsX2xlZnRfbGltaXQiOjYwLjAsIm1hbnVhbF9yaWdodF9saW1pdCI6NjAuMCwibWFudWFscyI6IkF0IFRhcmdldCIsIm1hbnVhbHNfb3Zlcl9mcyI6dHJ1ZSwibW9kZWxfYnJlYWtlcnMiOnRydWUsIm1vZGVsX2JyZWFrZXJzX2Fpcl9sZWdzIjoiU3RhdGljIiwibW9kZWxfYnJlYWtlcnNfYnJlYWtlZF9sZWdzIjoiRGlzYWJsZWQiLCJtb2RlbF9icmVha2Vyc19sZWdzX3NwZWVkIjo2MC4wLCJtb2RlbF9icmVha2Vyc19sZWdzX3ZhbCI6ODUuMCwibW9kZWxfYnJlYWtlcnNfbW92ZV9sZWFuIjowLjAsIm1vZGVsX2JyZWFrZXJzX3BpdGNoX29uX2xhbmQiOmZhbHNlLCJzYWZlX2RlZmVuc2l2ZV9hYSI6dHJ1ZSwic2FmZV9kZWZlbnNpdmVfaGlkZV9zaG90cyI6dHJ1ZSwic2FmZV9kZWZlbnNpdmVfbGFnX29wdGlvbnMiOiJBbHdheXMgT24iLCJzYWZlX2RlZmVuc2l2ZV9waXRjaCI6IlVwIiwic2FmZV9kZWZlbnNpdmVfcGl0Y2hfc2xpZGVyIjowLjAsInNhZmVfZGVmZW5zaXZlX3lhdyI6IlNwaW4iLCJzYWZlX2Z1bmNzX3NldHRpbmdzIjpbIkhlYWQiLCJLbmlmZSIsIlpldXMiXSwic2FmZV9mdW5jdGlvbnMiOnRydWUsInNhZmVfaGVhZF9zZXR0aW5ncyI6WyJIZWlnaHQiLCJIaWdoIERpc3RhbmNlIl0sInN0YXRpY19vbl9tYW51YWxzIjp0cnVlLCJ0ZWxlcG9ydF9leHAiOmZhbHNlLCJ0ZWxlcG9ydF9pbl9haXJfb25seSI6ZmFsc2V9fQ__"} --сюда деф кфг засунешь
}

files.config_path = files.default_path .. "\\configs.json"

local configs = {main = {names = conditional_antiaims.presets.names, values = conditional_antiaims.presets.values}}

configs.on_first_load = safecall("configs_first_load", true, function()
    if files.read(files.config_path) == nil then
        files.create_folder(files.default_path)
        files.write(files.config_path, json.stringify(configs.main))
    end
end)

configs.on_first_load()

configs.exist = safecall("configs_exist", true, function()
    local list = json.parse(files.read(files.config_path))
    configs.main.names = conditional_antiaims.presets.names
    configs.main.values = conditional_antiaims.presets.values
    for i = 1, #conditional_antiaims.presets.names do
        if conditional_antiaims.presets.names[i] ~= list.names[i] or conditional_antiaims.presets.values[i] ~= list.values[i] then
            files.write(files.config_path, (json.stringify(configs.main)))
        end
    end
end)

configs.exist()

configs.parse = safecall("configs_parse", true, function()
    local list = json.parse(files.read(files.config_path))
    conditional_antiaims.presets.names = list.names
    conditional_antiaims.presets.values = list.values
    ui_handler.refs["aa"]["aa_presets"].ref:update(conditional_antiaims.presets.names)
end)

configs.parse()

configs.update = safecall("configs_update", true, function()
    configs.main.names = conditional_antiaims.presets.names
    configs.main.values = conditional_antiaims.presets.values
    files.write(files.config_path, (json.stringify(configs.main)))
end)

configs.update()

ui_handler.refs["aa"]["aa_presets"].ref:update(conditional_antiaims.presets.names)

--[[callbacks.register("render", "cfg_sad", function()
    for k, v in pairs(conditional_antiaims.presets.values) do
        print_dev(v)
    end
end)]]

menu.button(ui_handler.tab.antiaim.presets, defines.colored_text({"icon_check", colors.link_active}, {"  Load  "}), safecall("aa_load", true, function()
    local ref = ui_handler.refs["aa"]["aa_presets"].ref

    ui_handler.configs.load(conditional_antiaims.presets.values[ref:get()], "aa")

    common.add_notify("asylum", "Preset succesfully loaded!")
end), true)("aa", "aa_load", false, function()
    return ui_handler.elements["aa"]["enable"]
end)

menu.button(ui_handler.tab.antiaim.presets, defines.colored_text({"icon_floppy-disk", colors.link_active}, {"  Save  "}), safecall("aa_save", true, function()
    local ref = ui_handler.refs["aa"]["aa_presets"].ref

    configs.parse()

    table.insert(conditional_antiaims.presets.names, ui_handler.elements["aa"]["aa_name"])
    table.insert(conditional_antiaims.presets.values, ui_handler.configs.parse("aa"))

    configs.update()

    ref:update(conditional_antiaims.presets.names)

    common.add_notify("asylum", "Preset succesfully saved!")
end), true)("aa", "aa_save", false, function()
    return ui_handler.elements["aa"]["enable"]
end)

menu.button(ui_handler.tab.antiaim.presets, defines.colored_text({"icon_trash-can", colors.link_active}, {"  Delete  "}), safecall("aa_delete", true, function()
    local ref = ui_handler.refs["aa"]["aa_presets"].ref

    configs.parse()
    if ref:get() > 1 then
        table.remove(conditional_antiaims.presets.names, ref:get())
        table.remove(conditional_antiaims.presets.values, ref:get())
    end
    configs.update()

    ref:update(conditional_antiaims.presets.names)

    utils.console_exec("play ui\\beepclear")
    common.add_notify("asylum", "Preset succesfully deleted!")
end), true)("aa", "aa_delete", false, function()
    return ui_handler.elements["aa"]["enable"]
end)

menu.button(ui_handler.tab.antiaim.presets, defines.colored_text({"  "}, {"icon_file-export", colors.link_active}, {" Export settings "}), function()
    ui_handler.configs.export("aa")
end, true)("aa", "aa_export", false, function()
    return ui_handler.elements["aa"]["enable"]
end)

menu.button(ui_handler.tab.antiaim.presets, defines.colored_text({"  "}, {"icon_file-import", colors.link_active}, {" Import settings "}), function()
    ui_handler.configs.import("aa")
end, true)("aa", "aa_import", false, function()
    return ui_handler.elements["aa"]["enable"]
end)

conditional_antiaims.states = {
    unknown = -1,
    standing = 2,
    moving = 3,
    slowwalk = 4,
    crouching = 5,
    moving_crouch = 6,
    air = 7,
    air_crouch = 8,
    freestand = 9,
    fakelag = 10,
    on_use = 11
}

conditional_antiaims.states_names = {}
for k, v in pairs(conditional_antiaims.states) do
    conditional_antiaims.states_names[v] = k:sub(1,1):upper() .. k:sub(2, #k)
end

conditional_antiaims.player_state = 1
conditional_antiaims.update_player_state = function(cmd)

    local localplayer = entity.get_local_player()

    if localplayer == nil then
        return
    end

    local flags = localplayer.m_fFlags

    local is_crouching = bit.band(flags, bit.lshift(1, 1)) ~= 0
    local on_ground = bit.band(flags, bit.lshift(1, 0)) ~= 0
    local is_not_moving = localplayer.m_vecVelocity:length() < 2
    local is_slowwalk = neverlose_refs.slow_walk:get()
    local is_jumping = cmd.in_jump

    if antiaim_on_use.enabled then
        conditional_antiaims.player_state = conditional_antiaims.states.on_use
        return
    end

    if (neverlose_refs.freestanding:get()) and not antiaim_on_use.enabled then
        conditional_antiaims.player_state = conditional_antiaims.states.freestand
        return
    end

    if rage.exploit:get() == 0 then
        conditional_antiaims.player_state = conditional_antiaims.states.fakelag
        return
    end

    if is_crouching and (is_jumping or not on_ground) then
        conditional_antiaims.player_state = conditional_antiaims.states.air_crouch
        return
    end

    if is_jumping or not on_ground then
        conditional_antiaims.player_state = conditional_antiaims.states.air
        return
    end

    if is_slowwalk then
        conditional_antiaims.player_state = conditional_antiaims.states.slowwalk
        return
    end

    if not is_crouching and is_not_moving then
        conditional_antiaims.player_state = conditional_antiaims.states.standing
        return
    end

    if is_crouching and is_not_moving then
        conditional_antiaims.player_state = conditional_antiaims.states.crouching
        return
    end

    if is_crouching and not is_not_moving then
        conditional_antiaims.player_state = conditional_antiaims.states.moving_crouch
        return
    end

    if not is_crouching and not is_not_moving and not is_slowwalk then
        conditional_antiaims.player_state = conditional_antiaims.states.moving
        return
    end

    conditional_antiaims.player_state = conditional_antiaims.states.unknown
end

local yaw_modifiers = neverlose_refs.yaw_modifier:list()
table.insert(yaw_modifiers, "L&R Center")
table.insert(yaw_modifiers, "Custom Way")

conditional_antiaims.conditions = {}
conditional_antiaims.conditions_names = {"Shared", "Standing", "Moving", "Slowwalk", "Crouch", "Moving & Crouch", "Air", "Air & Crouch", "Freestand", "Fakelag", "On Use"}
for k, name in pairs(conditional_antiaims.conditions_names) do
    local name_unique = "\aFFFFFF00" .. name
    local itemname_start = "conditions_" .. name .. "_"

    local condition_fn = function()
        return ui_handler.elements["aa"]["enable"] and ui_handler.elements["aa"]["condition_combo"] == name
    end

    conditional_antiaims.conditions[k] = {}

    if name ~= "Shared" then
        conditional_antiaims.conditions[k].switch = menu.switch(ui_handler.tab.antiaim.builder, "Allow " .. name .. " Condition")("aa", itemname_start .. "override", true, condition_fn)
    end

    conditional_antiaims.conditions[k].pitch = menu.combo(ui_handler.tab.antiaim.builder, neverlose_refs.pitch:name() .. name_unique, neverlose_refs.pitch:list())("aa", itemname_start .. "pitch", true, condition_fn)
    conditional_antiaims.conditions[k].yaw = menu.combo(ui_handler.tab.antiaim.builder, neverlose_refs.yaw:name() .. name_unique, neverlose_refs.yaw:list())("aa", itemname_start .. "yaw", true, condition_fn)(function(group)
        conditional_antiaims.conditions[k].left_yaw_offset = menu.slider(group, "Left " .. neverlose_refs.yaw_offset:name() .. name_unique, -180, 180, 0)("aa", itemname_start .. "left_yaw_offset")
        conditional_antiaims.conditions[k].right_yaw_offset = menu.slider(group, "Right " .. neverlose_refs.yaw_offset:name() .. name_unique, -180, 180, 0)("aa", itemname_start .. "right_yaw_offset")
    end)

    conditional_antiaims.conditions[k].yaw_modifier = menu.combo(ui_handler.tab.antiaim.builder, neverlose_refs.yaw_modifier:name() .. name_unique, yaw_modifiers)("aa", itemname_start .. "yaw_modifier", true, condition_fn)(function(group)
        conditional_antiaims.conditions[k].yaw_modifier_offset = menu.slider(group, neverlose_refs.yaw_modifier_offset:name() .. name_unique, -180, 180, 0)("aa", itemname_start .. "yaw_modifier_offset", true, function()
            return ui_handler.elements["aa"][itemname_start .. "yaw_modifier"] ~= "Custom Way" and ui_handler.elements["aa"][itemname_start .. "yaw_modifier"] ~= "L&R Center"
        end)

        conditional_antiaims.conditions[k].yaw_modifier_offset1 = menu.slider(group, "Offset #1" .. name_unique, -180, 180, 0)("aa", itemname_start .. "yaw_modifier_offset1", true, function()
            return ui_handler.elements["aa"][itemname_start .. "yaw_modifier"] == "Custom Way"
        end)
        conditional_antiaims.conditions[k].yaw_modifier_offset2 = menu.slider(group, "Offset #2" .. name_unique, -180, 180, 0)("aa", itemname_start .. "yaw_modifier_offset2", true, function()
            return ui_handler.elements["aa"][itemname_start .. "yaw_modifier"] == "Custom Way"
        end)
        conditional_antiaims.conditions[k].yaw_modifier_offset3 = menu.slider(group, "Offset #3" .. name_unique, -180, 180, 0)("aa", itemname_start .. "yaw_modifier_offset3", true, function()
            return ui_handler.elements["aa"][itemname_start .. "yaw_modifier"] == "Custom Way"
        end)

        conditional_antiaims.conditions[k].yaw_modifier_offset979 = menu.slider(group, "Yaw Jitter Left" .. name_unique, -180, 180, 0)("aa", itemname_start .. "yaw_modifier_offset979", true, function()
            return ui_handler.elements["aa"][itemname_start .. "yaw_modifier"] == "L&R Center"
        end)
        conditional_antiaims.conditions[k].yaw_modifier_offset1337 = menu.slider(group, "Yaw Jitter Right" .. name_unique, -180, 180, 0)("aa", itemname_start .. "yaw_modifier_offset1337", true, function()
            return ui_handler.elements["aa"][itemname_start .. "yaw_modifier"] == "L&R Center"
        end)
    end)

    conditional_antiaims.conditions[k].advanced_body_yaw = menu.combo(ui_handler.tab.antiaim.builder, neverlose_refs.body_yaw:name() .. name_unique, {"Default", "Advanced"})("aa", itemname_start .. "body_yaw", true, condition_fn)(function(group)
        conditional_antiaims.conditions[k].delay_ticks = menu.slider(group, "Delay Ticks" .. name_unique, 1, 14, 4)("aa", itemname_start .. "delay_ticks", true, function()
            return ui_handler.elements["aa"][itemname_start .. "body_yaw"] == "Advanced"
        end)

        conditional_antiaims.conditions[k].left_limit = menu.slider(group, neverlose_refs.left_limit:name() .. name_unique, 0, 60, 60)("aa", itemname_start .. "left_limit", true, function()
            return ui_handler.elements["aa"][itemname_start .. "body_yaw"] ~= "Advanced"
        end)
        conditional_antiaims.conditions[k].right_limit = menu.slider(group, neverlose_refs.right_limit:name() .. name_unique, 0, 60, 60)("aa", itemname_start .. "right_limit", true, function()
            return ui_handler.elements["aa"][itemname_start .. "body_yaw"] ~= "Advanced"
        end)
        conditional_antiaims.conditions[k].body_yaw_options = menu.selectable(group, neverlose_refs.body_yaw_options:name() .. name_unique, neverlose_refs.body_yaw_options:list())("aa", itemname_start .. "body_yaw_options", true, function()
            return ui_handler.elements["aa"][itemname_start .. "body_yaw"] ~= "Advanced"
        end)
        conditional_antiaims.conditions[k].body_yaw_freestanding = menu.combo(group, neverlose_refs.body_yaw_freestanding:name() .. name_unique, neverlose_refs.body_yaw_freestanding:list())("aa", itemname_start .. "body_yaw_freestanding", true, function()
            return ui_handler.elements["aa"][itemname_start .. "body_yaw"] ~= "Advanced"
        end)
    end)


    conditional_antiaims.conditions[k].defensive_aa = menu.switch(ui_handler.tab.antiaim.builder, "Defensive AA" .. name_unique, false)("aa", itemname_start .. "defensive_aa", true, condition_fn)(function(group)
        conditional_antiaims.conditions[k].defensive_pitch = menu.combo(group, "Pitch" .. name_unique, {"Disabled", "Up", "Zero", "Random", "Custom"})("aa", itemname_start .. "defensive_pitch", true, function()
            return condition_fn() and ui_handler.elements["aa"][itemname_start .. "defensive_aa"]
        end)
        conditional_antiaims.conditions[k].pitch_slider = menu.slider(group, "Custom Pitch" .. name_unique, -89, 89, 0)("aa", itemname_start .. "pitch_slider", true, function()
            return condition_fn() and ui_handler.elements["aa"][itemname_start .. "defensive_aa"] and ui_handler.elements["aa"][itemname_start .. "defensive_pitch"] == "Custom"
        end)
        conditional_antiaims.conditions[k].defensive_yaw = menu.combo(group, "Yaw" .. name_unique, {"Disabled", "Sideways", "Opposite", "Random", "Spin", "3-Way", "5-Way", "Neverlose", "Custom"})("aa", itemname_start .. "defensive_yaw", true, function()
            return condition_fn() and ui_handler.elements["aa"][itemname_start .. "defensive_aa"]
        end)
        conditional_antiaims.conditions[k].yaw_slider = menu.slider(group, "Custom Yaw" .. name_unique, -180, 180, 0)("aa", itemname_start .. "yaw_slider", true, function()
            return condition_fn() and ui_handler.elements["aa"][itemname_start .. "defensive_aa"] and ui_handler.elements["aa"][itemname_start .. "defensive_yaw"] == "Custom"
        end)
        conditional_antiaims.conditions[k].hide_shots = menu.switch(group, 'On Hide Shots')("aa", itemname_start .. "on_hide_shots", true, function()
            return condition_fn() and ui_handler.elements["aa"][itemname_start .. "defensive_aa"]
        end)
    end)

    conditional_antiaims.conditions[k].lag_options = menu.combo(ui_handler.tab.antiaim.builder, "Lag Options" .. name_unique, {"On Peek", "Always On"})("aa", itemname_start .. "lag_options", true, condition_fn)

    for key, value in pairs(conditional_antiaims.conditions[k]) do
        if type(value) == "function" then
            conditional_antiaims.conditions[k][key] = conditional_antiaims.conditions[k][key]()
        end
    end
end

ui_handler.refs["aa"]["condition_combo"].ref:update(conditional_antiaims.conditions_names)

conditional_antiaims.desync_delta = 0
conditional_antiaims.get_desync_delta = function()
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    conditional_antiaims.desync_delta = math.normalize_yaw(player.m_flPoseParameter[11] * 120 - 60) / 2
end

conditional_antiaims.current_side = false
conditional_antiaims.get_desync_side = function()
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    if globals.choked_commands ~= 0 then 
        return
    end

    local body_yaw = player.m_flPoseParameter[11] * 120 - 60

    conditional_antiaims.current_side = body_yaw > 0
end

conditional_antiaims.swap = false
conditional_antiaims.set_yaw_right_left = safecall("set_yaw_right_left", true, function(new_config)
    if new_config.advanced_body_yaw ~= "Advanced" then
        new_config.yaw_offset = conditional_antiaims.current_side and new_config.right_yaw_offset or new_config.left_yaw_offset
    end
end)

conditional_antiaims.new_meta_defensive = safecall("new_meta_defensive", true, function(new_config)
    local plocal = entity.get_local_player()
    if (plocal == nil) or (not plocal:is_alive()) then
        return end
 
    local is_grenade = plocal:get_player_weapon():get_classname():find('Grenade') or false
    local distance_to_enemy = {conditional_antiaims.get_distance()}
    local is_manuals = (ui_handler.elements["aa"]["manuals"] == "Left" or ui_handler.elements["aa"]["manuals"] == "Right" or ui_handler.elements["aa"]["manuals"] == "Forward")
    local weapon = plocal:get_player_weapon()
    local safe_knife = ((ui_handler.elements["aa"]["safe_functions"] and ui_handler.refs["aa"]["safe_funcs_settings"].ref:get("Knife")) and (weapon ~= nil and weapon:get_classname() == "CKnife")) and (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
    local safe_zeus = ((ui_handler.elements["aa"]["safe_functions"] and ui_handler.refs["aa"]["safe_funcs_settings"].ref:get("Zeus")) and (weapon ~= nil and weapon:get_classname() == "CWeaponTaser")) and (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
    --local is_safe = ((ui_handler.elements["aa"]["safe_defensive_aa"] and ui_handler.elements["aa"]["safe_functions"] and not (ui_handler.elements["aa"]["manuals"] == "Left" or ui_handler.elements["aa"]["manuals"] == "Right"))) and (conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag) and (ui_handler.refs["aa"]["safe_head_settings"].ref:get("High Distance") and ((safe_knife or safe_zeus) or (not (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch) and distance_to_enemy[1] > 119)) or (ui_handler.refs["aa"]["safe_head_settings"].ref:get("Height") and distance_to_enemy[2] < -50))
    
    --local is_allowed = ((not is_manuals and new_config.lag_options == "Always On") or (is_manuals and ui_handler.elements["aa"]["manual_defensive_lag_options"] == 'Always On') or (is_safe and ui_handler.elements["aa"]["safe_defensive_lag_options"] == 'Always On')) and not is_grenade 
    
    --neverlose_refs.override("doubletap_config", is_allowed and "Always On" or "On Peek")-- ui_handler.refs["aa"]["safe_head_settings"].ref:get("High Distance") -- ui_handler.refs["aa"]["safe_head_settings"].ref:get("Height")

    local is_safe = ((ui_handler.elements["aa"]["safe_functions"] and ui_handler.elements["aa"]["safe_defensive_aa"] and (not is_manuals)) and (((ui_handler.refs["aa"]["safe_head_settings"].ref:get("High Distance") and distance_to_enemy[1] > 119) and (conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)) or ((ui_handler.refs["aa"]["safe_head_settings"].ref:get("Height") and distance_to_enemy[2] < -50) and (conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.moving_crouch or conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag))))
	local safe_conds = (((ui_handler.refs["aa"]["safe_head_settings"].ref:get("High Distance") and distance_to_enemy[1] > 119) and (conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)) or ((ui_handler.refs["aa"]["safe_head_settings"].ref:get("Height") and distance_to_enemy[2] < -50) and (conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.moving_crouch or conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)))
	

    if is_manuals then
		neverlose_refs.override("doubletap_config", ui_handler.elements["aa"]["manual_defensive_lag_options"])
	elseif (is_safe or safe_knife or safe_zeus) then
		neverlose_refs.override("doubletap_config", ui_handler.elements["aa"]["safe_defensive_lag_options"])
	elseif safe_conds and not (ui_handler.elements["aa"]["safe_functions"] and ui_handler.elements["aa"]["safe_defensive_aa"]) then
		neverlose_refs.override("doubletap_config", "On Peek")
	else
		neverlose_refs.override("doubletap_config", new_config.lag_options)
	end
end)

conditional_antiaims.delay_switch = safecall("delay_switch", true, function(new_config)
    if (ui_handler.elements["aa"]["manuals"] == "Left" or ui_handler.elements["aa"]["manuals"] == "Right") then 
        return 
    end

    if globals.tickcount % new_config.delay_ticks == new_config.delay_ticks-1 then
        conditional_antiaims.swap = not conditional_antiaims.swap
    end

    if new_config.advanced_body_yaw == "Advanced" then
        rage.antiaim:inverter(conditional_antiaims.swap)
        new_config.body_yaw_options = ''
        new_config.yaw_offset =  rage.antiaim:inverter() and new_config.left_yaw_offset or new_config.right_yaw_offset
    end
end)

conditional_antiaims.new_meta_antiaims = safecall("new_meta_antiaims", true, function(new_config)
    local yaw = conditional_antiaims.current_side and new_config.left_yaw_offset or new_config.right_yaw_offset
    local value = yaw

    if new_config.yaw_modifier == "L&R Center" then
        new_config.yaw_modifier = "Center"
        new_config.yaw_modifier_offset = conditional_antiaims.current_side and new_config.yaw_modifier_offset1337 or new_config.yaw_modifier_offset979
        new_config.yaw_offset = conditional_antiaims.current_side and new_config.left_yaw_offset or new_config.right_yaw_offset


        new_config.yaw_modifier = "Center"
    elseif new_config.yaw_modifier == "Custom Way" then
        if globals.tickcount % 3 == 0 then
            value = new_config.yaw_modifier_offset1
        elseif globals.tickcount % 3 == 1 then
            value = new_config.yaw_modifier_offset2
        elseif globals.tickcount % 3 == 2 then
            value = new_config.yaw_modifier_offset3
        end

        new_config.yaw_modifier_offset = 0
        new_config.yaw_modifier = "Center"
    end
    
    if new_config.advanced_body_yaw ~= "Advanced" then
        new_config.yaw_offset = value
    end
end)

conditional_antiaims.get_active_idx = function(idx)
    local name = conditional_antiaims.conditions_names[idx]
    if name ~= nil then
        if idx ~= 1 and ui_handler.elements["aa"]["conditions_" .. name .. "_override"] then
            return idx
        end
    end

    return 1
end

conditional_antiaims.get_cond_values = function(idx)
    
    local cond_tbl = conditional_antiaims.conditions_names[idx]
    if cond_tbl == nil then
        return
    end

    local new_config = {}

    for k, v in pairs(conditional_antiaims.conditions[idx]) do
        new_config[k] = v:get()
    end

    return new_config
end

conditional_antiaims.set_ui = safecall("set_ui", true, function(new_config)
    for k, v in pairs(new_config) do
        if neverlose_refs._vars[k] ~= nil then
            neverlose_refs.override(k, v)
        end
    end
end)

conditional_antiaims.defensive = false
conditional_antiaims.defensive_handle = safecall("defensive_handle", true, function()
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local simtime = player:get_simulation_time()
    local difference = defines.time_to_ticks(simtime.current - simtime.old)

    conditional_antiaims.defensive = difference < 0
end)

conditional_antiaims.handle = function(cmd)
    conditional_antiaims.update_player_state(cmd)
    conditional_antiaims.get_desync_delta()
    conditional_antiaims.get_desync_side()

    local idx = conditional_antiaims.player_state
    local current_condition = conditional_antiaims.get_active_idx(idx)
    local new_config = conditional_antiaims.get_cond_values(current_condition)
    local manual_yaw = ui_handler.elements["aa"]["manuals"]
    local manuals_over_fs = ui_handler.elements["aa"]["manuals_over_fs"]
    local is_manuals = (manual_yaw == "Left" or manual_yaw == "Right" or manual_yaw == "Forward")
    local weapon = entity.get_local_player():get_player_weapon()
    local knife = weapon ~= nil and weapon:get_classname() == "CKnife"
    local zeus = weapon ~= nil and weapon:get_classname() == "CWeaponTaser" 
    local safe_knife = ((ui_handler.elements["aa"]["safe_functions"] and ui_handler.refs["aa"]["safe_funcs_settings"].ref:get("Knife")) and knife) and (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
    local safe_zeus = ((ui_handler.elements["aa"]["safe_functions"] and ui_handler.refs["aa"]["safe_funcs_settings"].ref:get("Zeus")) and zeus) and (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
    local safe_head = (ui_handler.elements["aa"]["safe_functions"] and ui_handler.refs["aa"]["safe_funcs_settings"].ref:get("Head"))
    local distance_to_enemy = {conditional_antiaims.get_distance()}    
    local is_safe = ((ui_handler.elements["aa"]["safe_defensive_aa"] and ui_handler.elements["aa"]["safe_functions"] and not (ui_handler.elements["aa"]["manuals"] == "Left" or ui_handler.elements["aa"]["manuals"] == "Right"))) and (conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag) and (ui_handler.refs["aa"]["safe_head_settings"].ref:get("High Distance") and ((safe_knife or safe_zeus) or (not (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch) and distance_to_enemy[1] > 119)) or (ui_handler.refs["aa"]["safe_head_settings"].ref:get("Height") and distance_to_enemy[2] < -50))
    
    conditional_antiaims.safe_active = (
		(ui_handler.elements["aa"]["safe_functions"] and (not is_manuals)) and 
		
		(
			(
				(ui_handler.refs["aa"]["safe_head_settings"].ref:get("High Distance") and distance_to_enemy[1] > 119) and 
				(conditional_antiaims.player_state == conditional_antiaims.states.crouching or 
				conditional_antiaims.player_state == conditional_antiaims.states.standing or 
				conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
			) 
			or 
			(
				(ui_handler.refs["aa"]["safe_head_settings"].ref:get("Height") and distance_to_enemy[2] < -50) and 
				(conditional_antiaims.player_state == conditional_antiaims.states.crouching or 
				conditional_antiaims.player_state == conditional_antiaims.states.moving_crouch or 
				conditional_antiaims.player_state == conditional_antiaims.states.standing or 
				conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or 
				conditional_antiaims.player_state == conditional_antiaims.states.fakelag)
			)
		)
	)

    local pitch_tbl = {
        ["Disabled"] = 89,
        ["Up"] = -89,
        ["Zero"] = 0,
        ["Random"] = math.random(-89, 89),
        ["Custom"] = new_config.pitch_slider
    }

    local yaw_tbl = {
        ["Disabled"] = 0,
        ["Opposite"] = utils.random_int(160, 180),
        ["Sideways"] = globals.tickcount % 3 == 0 and utils.random_int(-100, -90) or globals.tickcount % 3 == 1 and 180 or globals.tickcount % 3 == 2 and utils.random_int(90, 100) or 0,
        ["Random"] = math.random(-180, 180),
        ["Spin"] = math.normalize_yaw(globals.curtime * 1000),
        ["3-Way"] = globals.tickcount % 3 == 0 and utils.random_int(-110, -90) or globals.tickcount % 3 == 1 and utils.random_int(90, 120) or globals.tickcount % 3 == 2 and utils.random_int(-180, -150) or 0,
        ["5-Way"] = globals.tickcount % 5 == 0 and utils.random_int(-90, -75) or globals.tickcount % 5 == 1 and utils.random_int(-45, -30) or globals.tickcount % 5 == 2 and utils.random_int(-180, -160) or globals.tickcount % 5 == 3 and utils.random_int(45, 60) or globals.tickcount % 5 == 3 and utils.random_int(90, 110) or 0,
        ["Custom"] = new_config.yaw_slider
    }

    if new_config.defensive_aa and not (is_manuals or conditional_antiaims.safe_active or safe_knife or safe_zeus) then
        if new_config.hide_shots then
            neverlose_refs.override("hideshots_config", "Break LC")
        end
        new_config.hidden = true
        rage.antiaim:override_hidden_pitch(pitch_tbl[new_config.defensive_pitch])
        if not (new_config.defensive_yaw == "Neverlose") then
            rage.antiaim:override_hidden_yaw_offset(yaw_tbl[new_config.defensive_yaw])
        end
    elseif (ui_handler.elements["aa"]["safe_defensive_aa"] and (safe_head) and not is_manuals) and (conditional_antiaims.player_state == conditional_antiaims.states.standing or conditional_antiaims.player_state == conditional_antiaims.states.crouching or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.fakelag)then
        if (ui_handler.refs["aa"]["safe_head_settings"].ref:get("High Distance") and (not (conditional_antiaims.player_state == conditional_antiaims.states.air_crouch) and distance_to_enemy[1] > 119)) or (ui_handler.refs["aa"]["safe_head_settings"].ref:get("Height") and distance_to_enemy[2] < -50) then
            if ui_handler.elements["aa"]["safe_defensive_hide_shots"] then
                neverlose_refs.override("hideshots_config", "Break LC")
            end
            new_config.hidden = true
            rage.antiaim:override_hidden_pitch(pitch_tbl[ui_handler.elements["aa"]["safe_defensive_pitch"]])
            if not (ui_handler.elements["aa"]["safe_defensive_yaw"] == "Neverlose") then
                rage.antiaim:override_hidden_yaw_offset(yaw_tbl[ui_handler.elements["aa"]["safe_defensive_yaw"]])
            end
        elseif (safe_knife or safe_zeus) then
            if ui_handler.elements["aa"]["safe_defensive_hide_shots"] then
                neverlose_refs.override("hideshots_config", "Break LC")
            end
            new_config.hidden = true
            rage.antiaim:override_hidden_pitch(pitch_tbl[ui_handler.elements["aa"]["safe_defensive_pitch"]])
            if not (ui_handler.elements["aa"]["safe_defensive_yaw"] == "Neverlose") then
                rage.antiaim:override_hidden_yaw_offset(yaw_tbl[ui_handler.elements["aa"]["safe_defensive_yaw"]])
            end
        end
    elseif ui_handler.elements["aa"]["manual_defensive_aa"] and is_manuals then
        if ui_handler.elements["aa"]["manual_defensive_hide_shots"] then
            neverlose_refs.override("hideshots_config", "Break LC")
        end
        new_config.hidden = true
        rage.antiaim:override_hidden_pitch(pitch_tbl[ui_handler.elements["aa"]["manual_defensive_pitch"]])
        if not (ui_handler.elements["aa"]["manual_defensive_yaw"] == "Neverlose") then
            rage.antiaim:override_hidden_yaw_offset(yaw_tbl[ui_handler.elements["aa"]["manual_defensive_yaw"]])
        end
    else
        new_config.hidden = false
    end

    conditional_antiaims.defensive_handle()
    conditional_antiaims.new_meta_defensive(new_config)
    conditional_antiaims.set_yaw_right_left(new_config)
    conditional_antiaims.new_meta_antiaims(new_config)
    conditional_antiaims.delay_switch(new_config)
    conditional_antiaims.set_yaw_base(new_config)
    neverlose_refs.override("body_yaw", true)
    conditional_antiaims.set_ui(new_config)

end

defines.reverse_table = function(tbl)
    local tmp = {}

    for k, v in pairs(tbl) do
        tmp[v] = k
    end

    return tmp
end

antiaim_on_use.enabled = false
antiaim_on_use.start_time = globals.realtime
antiaim_on_use.handle = function(cmd)

    antiaim_on_use.enabled = false

    if not ui_handler.elements["aa"]["enable"] then
        return
    end

    if not ui_handler.elements["aa"]["conditions_On Use_override"] then
        return
    end

    if not cmd.in_use then
        antiaim_on_use.start_time = globals.realtime
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local player_origin = player:get_origin()

    local CPlantedC4 = entity.get_entities("CPlantedC4")
    local dist_to_bomb = 999

    if #CPlantedC4 > 0 then
        local bomb = CPlantedC4[1]

        local bomb_origin = bomb:get_origin()

        dist_to_bomb = player_origin:dist(bomb_origin)
    end

    local CHostage = entity.get_entities("CHostage")
    local dist_to_hostage = 999

    if CHostage ~= nil then
        if #CHostage > 0 then
            local hostage_origin = {CHostage[1]:get_origin(), CHostage[2]:get_origin()}

            dist_to_hostage = math.min(player_origin:dist(hostage_origin[1]), player_origin:dist(hostage_origin[2]))
        end
    end

    if dist_to_hostage < 65 and player.m_iTeamNum ~= 2 then
        return
    end

    if dist_to_bomb < 65 and player.m_iTeamNum ~= 2 then
        return
    end

    if cmd.in_use then
        if globals.realtime - antiaim_on_use.start_time < 0.02 then
            return
        end
    end

    cmd.in_use = false
    antiaim_on_use.enabled = true

    neverlose_refs.override("freestanding", not antiaim_on_use.enabled)
end

edge_yaw.is_edging = false
edge_yaw.angle = 0
edge_yaw.vecTraceStart = vector(0, 0, 0)
edge_yaw.on_edge = function(cmd)

    edge_yaw.is_edging = false

    if not ui_handler.elements["aa"]["enable"] then
        return
    end
    
    if not ui_handler.elements["aa"]["edge_yaw_key"] then
        return
    end

    if conditional_antiaims.player_state == conditional_antiaims.states.air or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    if cmd.send_packet then 
        edge_yaw.vecTraceStart = player:get_eye_position() 
    end

    local aTraceEnd = {}

    local angViewAngles = render.camera_angles()
    local distances = {}


    for flYaw = 18, 360, 18 do
        flYaw = math.normalize_yaw(flYaw)

        local vecTraceEnd = edge_yaw.vecTraceStart + vector():angles(0, flYaw) * 198

        local traceInfo = utils.trace_line(edge_yaw.vecTraceStart, vecTraceEnd, player, 0x46004003)
        table.insert(distances, edge_yaw.vecTraceStart:dist(traceInfo.end_pos))

        local flFraction = traceInfo.fraction
        local pEntity = traceInfo.entity

        if pEntity and pEntity:get_classname() == 'CWorld' and flFraction < 0.3 then
            aTraceEnd[#aTraceEnd+1] = {
                vecTraceEnd = vecTraceEnd,
                flYaw = flYaw
            }

        end
    end

    table.sort(distances)

    if distances[1] > 30 then
        return
    end

    table.sort(aTraceEnd, function(a, b)
        return a.flYaw < b.flYaw
    end)

    table.remove(aTraceEnd, #aTraceEnd)

    local angEdge

    if #aTraceEnd >= 3 then
        local vecTraceCenter = aTraceEnd[1].vecTraceEnd:lerp(aTraceEnd[#aTraceEnd].vecTraceEnd, 0.5)

        angEdge = (edge_yaw.vecTraceStart - vecTraceCenter):angles()
    end

    if angEdge then

        local flYaw = angViewAngles.y
        local flEdgeYaw = angEdge.y


        local flDiff = math.normalize_yaw(flEdgeYaw - flYaw)
        if math.abs(flDiff) < 90 then 
            flDiff = 0
            flYaw = math.normalize_yaw(flEdgeYaw + 180)
        end

        local flNewYaw = -flYaw
        flNewYaw = math.normalize_yaw(flNewYaw + flEdgeYaw + flDiff + 180)

        edge_yaw.angle = flNewYaw
        edge_yaw.is_edging = true
    end

end

callbacks.error_logger = function()
    local time = math.floor(globals.realtime)

    if callbacks.error_logged then
        if callbacks.last_error_log + callbacks.network_ratelimit < time then
            callbacks.error_logged = false
        end
    end
end

sidebar.text = {}
sidebar.on_render = function()
    sidebar.text = gradient.text_animate("asylum", -1.5, {ui.get_style("Link Active"), color(25, 25, 25, 255)})
    sidebar.text:animate()
    ui.sidebar(sidebar.text:get_animated_text(), "cloud")
end

--[[esp.enemy:new_text("Lag Comp", "LAG COMP BREAKER", function(ent)
    if lc.g_net_data[ent:get_index()] and ui_handler.elements["interface"]["lc_debug"] then
        if lc.g_net_data[ent:get_index()].lagcomp then
            return "LAG COMP BREAKER"
        end
    end
end)]]--

--[[esp.enemy:new_text("Shifting Tickbase", "SHIFTING TICKBASE", function(ent)
    if lc.g_net_data[ent:get_index()] and ui_handler.elements["interface"]["lc_debug"] then
        if lc.g_net_data[ent:get_index()].shifting then
            return "SHIFTING TICKBASE"
        end
    end
end)
]]--

events.round_start:set(function()
    lc.g_net_data = {}
end)

callbacks.register("render", "screen_indication", screen_indication.handle)
callbacks.register("render", "skeet_indication", skeet_indication.handle)
callbacks.register("render", "skeet_indication_spectators", skeet_indication.spectators)
callbacks.register("bomb_abortplant", "c4_info", c4_info.reset)
callbacks.register("bomb_defused", "c4_info", c4_info.reset)
callbacks.register("bomb_planted", "c4_info", c4_info.reset)
callbacks.register("round_prestart", "c4_info", c4_info.reset)
callbacks.register("round_start", "c4_info", c4_info.reset)
callbacks.register("bomb_beginplant", "c4_info", c4_info.bomb_beginplant)
callbacks.register("render", "manual_indication", manual_indication.handle)
callbacks.register("render", "screen_indication", damage_indication.handle)
callbacks.register("render", "screen_indication", velocity_indication.handle)
callbacks.register("render", "solus_windows", widgets.handle)
callbacks.register("render", "scope_overlay", scope_overlay.handle)
callbacks.register("render", "clantag_spammer", clantag_spammer.handle)
callbacks.register("render", "screen_hitmarker", hitmarker.handle)
callbacks.register("render", "screen_hitmarker", kibit_hitmarker.handle)
callbacks.register("render", "grenade_radius", grenade_radius.handle)
callbacks.register("render", "molotov_wireframe", molotov_wireframe.handle)
callbacks.register("render", "aimbot_logger", aimbot_logger.print)
callbacks.register("player_death", "chat_spammer", chat_spammer.handle)
callbacks.register("aim_fire", "aimbot_logger", aimbot_logger.fired)
callbacks.register("aim_ack", "aimbot_logger", aimbot_logger.get)
callbacks.register("aim_ack", "aimbot_logger", aimbot_logger.missed)
callbacks.register("aim_ack", "aimbot_logger", aimbot_logger.hit)
callbacks.register("aim_ack", "screen_hitmarker", kibit_hitmarker.aim_ack)
callbacks.register("aim_fire", "screen_hitmarker", kibit_hitmarker.aim_fire)
callbacks.register("render", "aimbot_logger", aimbot_logger.handle)
callbacks.register("render", "sidebar", sidebar.on_render)
callbacks.register("pre_render", "console_color", console_color.pre_render)
--callbacks.register("net_update_start", "lc_debug", lc.on_frame_stage)
--callbacks.register("render", "lc_debug", lc.on_render)

callbacks.register("createmove", "hitchance", hitchance.handle)
callbacks.register("createmove", "teleport", discharge_exploit.createmove)
callbacks.register("createmove", "fast_ladder", fast_ladder.handle)
callbacks.register("createmove", "conditional_antiaims", conditional_antiaims.handle)
callbacks.register("pre_render", "unmute_silenced", unmute_silenced.handle)
callbacks.register("createmove", "antiaim_on_use", antiaim_on_use.handle)
callbacks.register("createmove", "edge_yaw", edge_yaw.on_edge)
callbacks.register("post_update_clientside_animation", "model_breaker", model_breaker.handle)
callbacks.register("createmove", "deoverride_unused", function()
    neverlose_refs.deoverride_unused()
end)

callbacks.register("shutdown", "clantag_spammer", clantag_spammer.clear)
callbacks.register("shutdown", "aspect_ratio", aspect_ratio.destroy)
callbacks.register("shutdown", "viewmodel", viewmodel.destroy)
callbacks.register("shutdown", "console_color", console_color.shutdown)

callbacks.register("shutdown", "deoverride_unused", function()
    neverlose_refs.deoverride_unused(true)
end)

callbacks.register("player_hurt", "screen_hitmarker", function(e)
    local me = entity.get_local_player()
    local userid = entity.get(e.userid, true)
    local attacker = entity.get(e.attacker, true)

    if attacker == me and userid ~= me then
        hitmarker.player_hurt(e)
    end
end)

callbacks.register("render", "error_logger", callbacks.error_logger)

aspect_ratio.handle()
viewmodel.handle()
ui_handler.global_update_callback()