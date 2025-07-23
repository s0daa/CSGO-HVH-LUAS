-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS



_DEBUG = true

local smoothy = require("neverlose/smoothy")
local steam_network = require "neverlose/steam_network"
local clipboard = require "neverlose/clipboard"
local base64 = require "neverlose/base64"
local vmt_hook = require("neverlose/vmt_hook")
local gradient = require ("neverlose/gradient")
local anti_aim = require("neverlose/anti_aim")
local discord_webhooks = require("neverlose/discord_webhooks")
local
    watermark,
    sidebar,
    ui_handler,
    download_files,
    presets,
    neverlose_refs,
    callbacks,
    ffi_handler,
    defines,
    colors,
    client,
    indicators,
    skeet_indication,
    console_color,
    scope_overlay,
    aimbot_logger,
    hit_marker,
    conditional_antiaims,
    fast_ladder,
    air_modifications,
    discharge_dt,
    unmute_silenced,
    taskbar_notify,
    revolver_helper,
    velocity_warning,
    grenade_radius,
    manual_arrows,
    molotov_wireframe,
    fall_damage,
    viewmodel_changer,
    aspect_ratio_changer,
    model_breaker = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
    
print_raw([[
    ____  ______ _   _ __________  _     _    _         
    |  _ \|  ____| \ | |___  / __ \| |   | |  | |  /\    
    | |_) | |__  |  \| |  / / |  | | |   | |  | | /  \   
    |  _ <|  __| | . ` | / /| |  | | |   | |  | |/ /\ \  
    | |_) | |____| |\  |/ /_| |__| | |___| |__| / ____ \ 
    |____/|______|_| \_/_____\____/|______\____/_/    \_\
         
]])

print_raw("")

client.error_logged = false
client.webhooks_error = false
client.error_db = false
client.log_error = function(message)
    local error_message = message:gsub("\a.{6}", "")
    if not client.error_logged then
        client.error_logged = true

        print_raw(error_message)
        print_dev(error_message)
    end
end
client.discord_error = function(message)
end

local errors = db["error_time"] or 0;
client.db_error = function()
    if not client.error_db then
        errors = errors + 1

        client.error_db = true
    end
end

local safecall = function(name, report, f)
    return function(...)
        local s, ret = pcall(f, ...)


        if not s then
            local retmessage = "Failed to initialize [" .. name .. "] -> " .. ret
            local discord_message = "[" .. name:gsub("\a.{6}", "") .. "] reason: " .. ret:gsub("\a.{6}", "")

            if report then
                client.log_error(retmessage)
                client.discord_error(discord_message)
                client.db_error()
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

ffi.cdef[[

    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);  
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
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

math.difference = function (num1, num2)
    return math.abs(num1 - num2)
end

ui_handler.configs = {}

neverlose_refs.windows = ui.find("Miscellaneous", "Main", "Other", "Windows")
neverlose_refs.dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot")
neverlose_refs.hitboxes = ui.find("Aimbot", "Ragebot", "Selection", "Hitboxes")
neverlose_refs.multipoint = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint")
neverlose_refs.inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter")
neverlose_refs.slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
neverlose_refs.fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")
neverlose_refs.hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")

neverlose_refs.pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch")

neverlose_refs.yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw")
neverlose_refs.yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base")
neverlose_refs.yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset")
neverlose_refs.yaw_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab")

neverlose_refs.yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier")
neverlose_refs.yaw_modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")

neverlose_refs.body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw")
neverlose_refs.left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit")
neverlose_refs.right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit")
neverlose_refs.body_yaw_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options")
neverlose_refs.body_yaw_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")

neverlose_refs.freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
neverlose_refs.disable_yaw_modif = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers")
neverlose_refs.body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")

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
neverlose_refs.fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
neverlose_refs.legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
neverlose_refs.scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")

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
        if unoverride_all or math.difference(v.tick, ticks) > 16 then
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
colors.link_active = ui.get_style()["Link Active"]
colors.main = color(255, 120, 30, 255)

local   FL_ONGROUND	        = bit.lshift(1, 0)
local   FL_DUCKING	        = bit.lshift(1, 1)
local   FL_WATERJUMP        = bit.lshift(1, 3)
local   FL_ONTRAIN	        = bit.lshift(1, 4)
local   FL_INRAIN	        = bit.lshift(1, 5)
local   FL_FROZEN	        = bit.lshift(1, 6)
local   FL_ATCONTROLS       = bit.lshift(1, 7)
local   FL_CLIENT	        = bit.lshift(1, 8)
local   FL_FAKECLIENT       = bit.lshift(1, 9)
local   FL_INWATER	        = bit.lshift(1, 10)

getmetatable(color()).override = function (c, k, n)
    local cl = c:clone()

    cl [k] = n

    return cl
end


ffi_handler.bind_argument = function(fn, arg)
    return function(...)
        return fn(arg, ...)
    end
end
ffi_handler.engine_client = ffi.cast(ffi.typeof("void***"), utils.create_interface("engine.dll", "VEngineClient014"))
ffi_handler.entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface("client.dll", "VClientEntityList003"))
ffi_handler.get_entity_address = ffi_handler.bind_argument(ffi.cast("get_client_entity_t", ffi_handler.entity_list_003[0][3]), ffi_handler.entity_list_003)
ffi_handler.console_is_visible = ffi_handler.bind_argument(ffi.cast("bool(__thiscall*)(void*)", ffi_handler.engine_client[0][11]), ffi_handler.engine_client)
ffi_handler.raw_hwnd = utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B")
ffi_handler.raw_FlashWindow = utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7")
ffi_handler.raw_insn_jmp_ecx = utils.opcode_scan("gameoverlayrenderer.dll", "FF E1")
ffi_handler.raw_GetForegroundWindow = utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74")
ffi_handler.hwnd_ptr = ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", ffi_handler.raw_hwnd) + 2)[0])[0] + 2)
ffi_handler.flash_window = ffi.cast("int(__stdcall*)(uintptr_t, int)", ffi_handler.raw_FlashWindow)
ffi_handler.insn_jmp_ecx = ffi.cast("int(__thiscall*)(uintptr_t)", ffi_handler.raw_insn_jmp_ecx)
ffi_handler.GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", ffi_handler.raw_GetForegroundWindow) + 2)[0])[0]

defines.username = common.get_username()
defines.build = "nightly"
defines.discord_build = "debug"
defines.script_name = "benzo.gg"
defines.screen_size = render.screen_size()
defines.colored_text = safecall("defines.colored_text", true, function(...)
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
end)
defines.get_bind = safecall("defines.colored_text", true, function(name)
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
end)
defines.time_to_ticks = function(t)
    return math.floor(0.5 + (t / globals.tickinterval))
end
defines.visual_state = 1

ui_handler.elements = {}
ui_handler.refs = {}

ui_handler.global_update_callback = safecall("global_update", true, function()

    for k, v in pairs(ui_handler.refs) do
        for name, table_reference in pairs(v) do
            if table_reference ~= nil and table_reference.condition then
                table_reference.update_value(table_reference.ref)
                table_reference.ref:visibility(table_reference.condition() or false)
            end
        end
    end

end)

events.render:set(function()
    if ui.get_style()["Link Active"] ~= colors.link_active then
        colors.link_active = ui.get_style()["Link Active"]
    end
end)

ui_handler.reverse_tbl = function(tbl)

    local value_list = tbl
    local value_list_num = #value_list

    local tmp = {}
    for k, v in pairs(value_list) do
        if k ~= "_len" then
            tmp[v] = true
        end
    end

    return tmp
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
        print(f("[UI_HANDLER] Element already exists: %s->%s", tab, name))
        error("[UI_HANDLER] error")
    end

    ui_handler.refs[tab][name] = {
        ref = cheat_var,
        condition = condition,
        config = include_in_config
    }

    local update_value = function(new_value)

        local menu_type = new_value:type()
        local val = new_value:get()
        if menu_type == "selectable" then

            local tmp = ui_handler.reverse_tbl(val)

            ui_handler.elements[tab][name] = tmp
            ui_handler.elements[tab][name]._len = value_list_num -- мне лень ставить метатаблицу, пишов нахуй

        elseif menu_type == "listable" then
            local list = new_value:list()
            local len = #list

            local tmp = {}
            for k, v in ipairs(val) do
                tmp[list[v]] = k
            end

            ui_handler.elements[tab][name] = tmp
            ui_handler.elements[tab][name]._len = len
        else
            ui_handler.elements[tab][name] = val
        end

    end

    ui_handler.refs[tab][name].update_value = update_value

    cheat_var:set_callback(update_value, true)
    cheat_var:set_callback(ui_handler.global_update_callback)
    return cheat_var
end

ui_handler.groups = {}
menu = {
    __index = function(self, index, args)
        return (function(group, ...)


            local item_group
            if group.__name ~= "sol.Lua::LuaGroup" then
                local group_hash = f("%s%s", group[2] == nil and "unk" or group[2], group[1])
                item_group = ui_handler.groups[group_hash]
                if item_group == nil then
                    if group[2] ~= nil then
                        ui_handler.groups[group_hash] = ui.create(group[1], group[2])
                    else
                        ui_handler.groups[group_hash] = ui.create(group[1]) -- тут беды с таблицами, поэтому нуль туда запустить не выйдет
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
                        afn(item:create()) -- мб привязку как то организовать более автоматическую
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

    local encoded = base64.encode(msgpack.pack(ftbl))
    local clean = encoded:match("[%w%+%/]+%=*")

    return clean

end


ui_handler.configs.load = function(data)

    if data == "" or data == " " then
        return
    end

    if data == nil then
        data = clipboard.get()
    end

    local clean = string.match(data, "[%w%+%/]+%=*")


    success, data = pcall(function()
        return msgpack.unpack(base64.decode(data))
    end)

    if not success then
        return
    end

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
end

local f = string.format


download_files.urlmon = ffi.load("UrlMon")
download_files.wininet = ffi.load("WinInet")
download_files.gdi = ffi.load("Gdi32")

download_files.download = function(link, path)
    download_files.wininet.DeleteUrlCacheEntryA(link)
    download_files.urlmon.URLDownloadToFileA(nil, link, path, 0,0)
end

if files.read("nl\\scripts\\benzo\\logo.jpeg") == nil then
    download_files.download("https://cdn.discordapp.com/attachments/853055526912786432/1069273341904560138/image.png", "nl\\scripts\\benzo\\logo.jpeg")
end

if files.read("nl\\scripts\\benzo\\configs.json") == nil then
    download_files.download("https://cdn.discordapp.com/attachments/860194926612185109/1082332387423305900/configs.json", "nl\\scripts\\benzo\\configs.json")
end

if files.read("nl\\scripts\\benzo") == nil then
    files.create_folder("nl\\scripts\\benzo")
end

ui_handler.tab = {
    general = {
        information = ui.create(defines.colored_text({"icon_check", colors.link_active}, {" setup"}), defines.colored_text({"icon_circle-info", colors.link_active}, {" Info"})),
        flower = ui.create(defines.colored_text({"icon_check", colors.link_active}, {" setup"}), defines.colored_text({"icon_leaf", colors.link_active})),
        statistics = ui.create(defines.colored_text({"icon_check", colors.link_active}, {" setup"}), defines.colored_text({"icon_ballot", colors.link_active}, {" Statistics"})),
        settings = ui.create(defines.colored_text({"icon_check", colors.link_active}, {" setup"}), defines.colored_text({"icon_database", colors.link_active}, {" Settings"})),
        links = ui.create(defines.colored_text({"icon_check", colors.link_active}, { " setup"}), defines.colored_text({"icon_star", colors.link_active}, {" Check this too!"})),
        synchronization = ui.create(defines.colored_text({"icon_check", colors.link_active}, { " setup"}), defines.colored_text({"icon_rotate", colors.link_active}, {" Synchronization"})), -- ui_handler.tab.general.synchronization
    },
    antiaim = {
        general = ui.create(defines.colored_text({"icon_user", colors.link_active}, { " anti aim"}), defines.colored_text({"icon_wind-turbine", colors.link_active}, {" General"})),
        settings = ui.create(defines.colored_text({"icon_user", colors.link_active}, {" anti aim"}), defines.colored_text({"icon_bars", colors.link_active}, {" Preset"})),
        presets = ui.create(defines.colored_text({"icon_user", colors.link_active}, {" anti aim"}), defines.colored_text({"icon_gear", colors.link_active}, {" Preset Manager"})),
        builder = ui.create(defines.colored_text({"icon_user", colors.link_active}, {" anti aim"}), defines.colored_text({"icon_gears", colors.link_active}, {" Setting up: "})),
        automatic = ui.create(defines.colored_text({"icon_user", colors.link_active}, {" anti aim"}), defines.colored_text({"icon_gears", colors.link_active}, {" Automatic Mode"}))
    },
    features = {
        interface = ui.create(defines.colored_text({"icon_gears", colors.link_active}, {" settings"}), defines.colored_text({"icon_palette", colors.link_active}, {" Interface"})),
        additional = ui.create(defines.colored_text({"icon_gears", colors.link_active}, {" settings"}), defines.colored_text({"icon_users-gear", colors.link_active}, {" Misc"})),
    },
}


menu.texture(ui_handler.tab.general.flower, render.load_image_from_file("nl\\scripts\\benzo\\logo.jpeg", vector(300, 250)))("home", "settings_image", false)

menu.label(ui_handler.tab.general.information, defines.colored_text({"Glad to see you again, "}, {defines.username, colors.link_active}))("general", "logged")
menu.label(ui_handler.tab.general.information, defines.colored_text({"Current version: "}, {"3.0 / ", ui.get_style()["Link"]}, {defines.build, colors.link_active}))("general", "version")

menu.label(ui_handler.tab.general.statistics, "General: ")("statistic", "label_1")

local loads = db["times_loaded"] or 0;
loads = loads + 1;

menu.label(ui_handler.tab.general.statistics, defines.colored_text({""}, {" Times loaded: "}, {tostring(loads), colors.link_active}))("statistic", "times_loaded")

db["times_loaded"] = loads;

menu.label(ui_handler.tab.general.statistics, defines.colored_text({""}, {" Errors: "}, {tostring(errors), colors.link_active}))("statistic", "errors_time")

menu.label(ui_handler.tab.general.statistics, "\nGameplay: ")("statistic", "label_3")

local kills = db["kills"] or 0;
events.player_death:set(safecall("db_player_death", true, function(e)
    if entity.get_local_player() ~= nil then
        if entity.get(e.attacker, true) == entity.get_local_player() and entity.get(e.userid, true) ~= entity.get_local_player() then
            kills = kills+1;

            ui_handler.refs["statistic"]["kills"].ref:name(tostring(defines.colored_text({""}, {" Eliminated enemies: "}, {tostring(kills), colors.link_active})))

            db["kills"] = kills;
        end
    end
end))

menu.label(ui_handler.tab.general.statistics, defines.colored_text({""}, {" Eliminated enemies: "}, {tostring(db["kills"]), colors.link_active}))("statistic", "kills")


local hits = db["hits"] or 0;
local misses = db["misses"] or 0;
events.aim_ack:set(safecall("db_aim_ack", true, function(e)
    if entity.get_local_player() ~= nil then
        if e.state ~= nil then
            misses = misses + 1;

            ui_handler.refs["statistic"]["misses"].ref:name(tostring(defines.colored_text({""}, {" Missed shots: "}, {tostring(misses), colors.link_active})))
            

            db["misses"] = misses;
        elseif e.state == nil then
            hits = hits + 1;

            ui_handler.refs["statistic"]["hits"].ref:name(tostring(defines.colored_text({""}, {" Hits to enemies: "}, {tostring(hits), colors.link_active})))

            db["hits"] = hits;
        end
    end
end))

menu.label(ui_handler.tab.general.statistics, defines.colored_text({""}, {" Hits to enemies: "}, {tostring(db["hits"]), colors.link_active}))("statistic", "hits")
menu.label(ui_handler.tab.general.statistics, defines.colored_text({""}, {" Missed shots: "}, {tostring(db["misses"]), colors.link_active}))("statistic", "misses")



menu.button(ui_handler.tab.general.links, "Config", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=EVO1cL")
end, true)("general", "nl_config", false)

menu.button(ui_handler.tab.general.links, "Discord", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/rollmops")
end, false)("general", "discord_link", false)

menu.button(ui_handler.tab.general.links, "Youtube", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/rollmops")
end, true)("general", "youtube_link", false)

ui_handler.configs.export = safecall("configs_export", true, function()
    clipboard.set(ui_handler.configs.parse())

    table.insert(aimbot_logger.data, {
        text = {
            "Config succesfully ",
            "succesfully ",
            "exported!",
            "",
            "",
            "",
            "",
            "",
            ""
        },
        time = globals.realtime+3,
        color = color(5, 133, 182, 255)
    })

    utils.console_exec("play ui\\beepclear")
end)

ui_handler.configs.import = safecall("configs_import", true, function()
    ui_handler.configs.load()

    table.insert(aimbot_logger.data, {
        text = {
            "Config ",
            "succesfully ",
            "imported!",
            "",
            "",
            "",
            "",
            "",
            ""
        },
        time = globals.realtime+1,
        color = color(5, 133, 182, 255)
    })
    utils.console_exec("play ui\\beepclear")
end)

ui_handler.configs.default = safecall("configs_default", true, function()
    local data = "haRob21lkKhmZWF0dXJlc94AMq1zY29wZV9vdmVybGF5w7FpY29uX25vdGlmaWNhdGlvbsO3Z3JlbmFkZV9yYWRpdXNfZWxlbWVudHOSp01vbG90b3alU21va2WudmVsb2NpdHlfY29sb3KoRjNBOEE4RkaqbWlzc19jb2xvcqhGMzZGNkZGRqxkaXNjaGFyZ2VfZHTC2SJncmVuYWRlX3JhZGl1c19lbmVteV9tb2xvdG92X2NvbG9yqEY1NUE1QUZGr3Jldm9sdmVyX2hlbHBlcsOuZ3JlbmFkZV9yYWRpdXPDtG1hbnVhbF9hcnJvd3NfYWRkaW5nI7ptYW51YWxfYXJyb3dzX2FjY2VudF9jb2xvcqg3MjdEOTFGRqtmYWxsX2RhbWFnZcOsc2NvcGVfb2Zmc2V0JrFza2VldF9pbmRpY2F0aW9uc8Oxc2NvcGVfbGluZXNfY29sb3KoRkZGRkZGRkaraW5pdGlhbF9wb3MCtWNvbnNvbGVfY29sb3JfY2hhbmdlcsO7Y29uc29sZV9jb2xvcl9jaGFuZ2VyX2NvbG9yqEEyQTJBMjk3sGNyb3NzaGFpcl9vZmZzZXQJq2R0X3NldHRpbmdzqERpc2FibGVksWluZGljYXRvcnNfY29sb3IxqEZGRkZGRkZGsWluZGljYXRvcnNfY29sb3IyqEYzQThBOEZGqmxvZ29fc3R5bGWrUmlnaHQgVXBwZXKvY3Jvc3NoYWlyX2NvbG9yqEZGRkZGRkZGsG1vbG90b3Z3aXJlZnJhbWXCsG1vbG90b3ZfaWdub3JlX3rCtGNyb3NzaGFpcl9pbmRpY2F0b3Jzw6Rsb2dvzomsP/yvY3Jvc3NoYWlyX3N0eWxlp0RlZmF1bHStbWFudWFsX2Fycm93c8Osc2tlZXRfc2VsZWN0nLNIaXQgQ2hhbmNlIE92ZXJyaWRlsUhpdGJveGVzIE92ZXJyaWRlrkRvcm1hbnQgQWltYm90rEZha2UgTGF0ZW5jealGYWtlIER1Y2uoQm9keSBBaW2rU2FmZSBQb2ludHOrTWluLiBEYW1hZ2WsRnJlZXN0YW5kaW5nsEJvbWIgSW5mb3JtYXRpb26qRG91YmxlIFRhcKpIaWRlIFNob3Rzr2ZvcmNlX2RlZmVuc2l2ZcKzaW5kaWNhdGlvbl9lbGVtZW50c5K0Q3Jvc3NoYWlyIGluZGljYXRvcnOwVmVsb2NpdHkgd2FybmluZ7RkaXNjaGFyZ2VfZHRfd2VhcG9uc5C0ZmFkZV9hbmltYXRpb25fc3BlZWQMr2FpbWJvdF9lbGVtZW50c5KpT24gU2NyZWVuqkluIENvbnNvbGWrYWltYm90X2xvZ3PDqWhpdF9jb2xvcqhCREJFRkJGRqxhc3BlY3RfcmF0aW92qmxvZ29fY29sb3KoQTlBN0YzRkatbXV0ZV9ldmVyeW9uZcO6Z3JlbmFkZV9yYWRpdXNfc21va2VfY29sb3KoODI4MkZGRkbZIWdyZW5hZGVfcmFkaXVzX3RlYW1fbW9sb3Rvdl9jb2xvcqg1QUY1NUFGRqptdXRlX2VuZW15wrFtb2xvdG92X3dpcmVmcmFtZcOpdmlld21vZGVswq12aWV3bW9kZWxfZm92AKt2aWV3bW9kZWxfeACrdmlld21vZGVsX3kAq3ZpZXdtb2RlbF96AKJhYd4AfNkkY29uZGl0aW9uc19EdWNraW5nIFRfbGVmdF95YXdfb2Zmc2V04dklY29uZGl0aW9uc19EdWNraW5nIFRfcmlnaHRfeWF3X29mZnNldC3ZImNvbmRpdGlvbnNfRHVja2luZyBUX2RlZmVuc2l2ZV95YXfC2SRjb25kaXRpb25zX0R1Y2tpbmcgVF9kZWZlbnNpdmVfcGl0Y2ioRGlzYWJsZWTZK2NvbmRpdGlvbnNfRHVja2luZyBUX2RlZmVuc2l2ZV9jdXN0b21fcGl0Y2jQp6tsYWdfb3B0aW9uc5C3Y29uZGl0aW9uc19TdGFuZGluZ195YXeoQmFja3dhcmStY3VycmVudF9zdGF0ZahTdGFuZGluZ9kjY29uZGl0aW9uc19TdGFuZGluZ19sZWZ0X3lhd19vZmZzZXQCvWNvbmRpdGlvbnNfRHVja2luZyBUX2JvZHlfeWF3w9kkY29uZGl0aW9uc19TdGFuZGluZ19yaWdodF95YXdfb2Zmc2V0B79jb25kaXRpb25zX0R1Y2tpbmcgVF9sZWZ0X2xpbWl0NtkhY29uZGl0aW9uc19TdGFuZGluZ19kZWZlbnNpdmVfeWF3wtkjY29uZGl0aW9uc19TdGFuZGluZ19kZWZlbnNpdmVfcGl0Y2ioRGlzYWJsZWTZKmNvbmRpdGlvbnNfU3RhbmRpbmdfZGVmZW5zaXZlX2N1c3RvbV9waXRjaNCnuWNvbmRpdGlvbnNfU3RhbmRpbmdfcGl0Y2ikRG93btkgY29uZGl0aW9uc19TdGFuZGluZ195YXdfbW9kaWZpZXKmQ2VudGVyu2NvbmRpdGlvbnNfQWlyLUNfbGVmdF9saW1pdDzZJ2NvbmRpdGlvbnNfU3RhbmRpbmdfeWF3X21vZGlmaWVyX29mZnNldNDNvGNvbmRpdGlvbnNfQWlyLUNfcmlnaHRfbGltaXQ8vGNvbmRpdGlvbnNfU3RhbmRpbmdfYm9keV95YXfDtGNvbmRpdGlvbnNfQWlyX3BpdGNopERvd26+Y29uZGl0aW9uc19TdGFuZGluZ19sZWZ0X2xpbWl0PNkmY29uZGl0aW9uc19BaXItQ19ib2R5X3lhd19mcmVlc3RhbmRpbmejT2Zmv2NvbmRpdGlvbnNfU3RhbmRpbmdfcmlnaHRfbGltaXQ8p21hbnVhbHOpQXQgdGFyZ2V0uWNvbmRpdGlvbnNfRmFrZWR1Y2tfcGl0Y2ikRG93brhjb25kaXRpb25zX0R1Y2tpbmcgVF95YXeoQmFja3dhcmS3Y29uZGl0aW9uc19GYWtlZHVja195YXeoQmFja3dhcmStc2hvd19hbnRpYWltc8PZI2NvbmRpdGlvbnNfRmFrZWR1Y2tfbGVmdF95YXdfb2Zmc2V0ALpjb25kaXRpb25zX0R1Y2tpbmcgVF9waXRjaKREb3du2SRjb25kaXRpb25zX0Zha2VkdWNrX3JpZ2h0X3lhd19vZmZzZXQA2SFjb25kaXRpb25zX0R1Y2tpbmcgVF95YXdfbW9kaWZpZXKoRGlzYWJsZWTZIWNvbmRpdGlvbnNfRmFrZWR1Y2tfZGVmZW5zaXZlX3lhd8LZI2NvbmRpdGlvbnNfRmFrZWR1Y2tfZGVmZW5zaXZlX3BpdGNoqERpc2FibGVkt2NvbmRpdGlvbnNfTW92aW5nX3BpdGNopERvd27ZKGNvbmRpdGlvbnNfRHVja2luZyBUX3lhd19tb2RpZmllcl9vZmZzZXQAtWNvbmRpdGlvbnNfTW92aW5nX3lhd6hCYWNrd2FyZNkrY29uZGl0aW9uc19EdWNraW5nIENUX2JvZHlfeWF3X2ZyZWVzdGFuZGluZ6NPZmbZIWNvbmRpdGlvbnNfTW92aW5nX2xlZnRfeWF3X29mZnNldOjZIGNvbmRpdGlvbnNfRmFrZWR1Y2tfeWF3X21vZGlmaWVypkNlbnRlctkiY29uZGl0aW9uc19Nb3ZpbmdfcmlnaHRfeWF3X29mZnNldCnZJmNvbmRpdGlvbnNfRHVja2luZyBDVF9ib2R5X3lhd19vcHRpb25zkaZKaXR0ZXK+Y29uZGl0aW9uc19GYWtlZHVja19sZWZ0X2xpbWl0PNkhY29uZGl0aW9uc19Nb3ZpbmdfZGVmZW5zaXZlX3BpdGNoqERpc2FibGVk2Shjb25kaXRpb25zX01vdmluZ19kZWZlbnNpdmVfY3VzdG9tX3BpdGNo0KfZIGNvbmRpdGlvbnNfRHVja2luZyBUX3JpZ2h0X2xpbWl0NtkkY29uZGl0aW9uc19GYWtlZHVja19ib2R5X3lhd19vcHRpb25zkaZKaXR0ZXLZIWNvbmRpdGlvbnNfRHVja2luZyBDVF9yaWdodF9saW1pdDbZJWNvbmRpdGlvbnNfTW92aW5nX3lhd19tb2RpZmllcl9vZmZzZXQA2SVjb25kaXRpb25zX0R1Y2tpbmcgVF9ib2R5X3lhd19vcHRpb25zkaZKaXR0ZXK6Y29uZGl0aW9uc19Nb3ZpbmdfYm9keV95YXfD2SBjb25kaXRpb25zX0R1Y2tpbmcgQ1RfbGVmdF9saW1pdDa8Y29uZGl0aW9uc19Nb3ZpbmdfbGVmdF9saW1pdDy+Y29uZGl0aW9uc19BaXJfbGVmdF95YXdfb2Zmc2V0671jb25kaXRpb25zX01vdmluZ19yaWdodF9saW1pdDy+Y29uZGl0aW9uc19EdWNraW5nIENUX2JvZHlfeWF3w9kiY29uZGl0aW9uc19Nb3ZpbmdfYm9keV95YXdfb3B0aW9uc5GmSml0dGVyp2hlbHBlcnOUsFdhcm11cCBEaXNhYmxlcnOuQXZvaWQgYmFja3N0YWKwRmFzdCBMYWRkZXIgTW92Za1TdGF0aWMgTWFudWFs2Sdjb25kaXRpb25zX01vdmluZ19ib2R5X3lhd19mcmVlc3RhbmRpbmejT2ZmuWNvbmRpdGlvbnNfQWlyLUNfYm9keV95YXfDsmFuaW1hdGlvbl9icmVha2Vyc8OtbGVnX2FuaW1hdGlvbqdEZWZhdWx0rWFpcl9hbmltYXRpb26mRnJvemVu2Sljb25kaXRpb25zX0R1Y2tpbmcgQ1RfeWF3X21vZGlmaWVyX29mZnNldAC2Y29uZGl0aW9uc19XYWxraW5nX3lhd6hCYWNrd2FyZNkkY29uZGl0aW9uc19BaXItQ195YXdfbW9kaWZpZXJfb2Zmc2V0ANkiY29uZGl0aW9uc19XYWxraW5nX2xlZnRfeWF3X29mZnNldADZImNvbmRpdGlvbnNfRHVja2luZyBDVF95YXdfbW9kaWZpZXKoRGlzYWJsZWTZI2NvbmRpdGlvbnNfV2Fsa2luZ19yaWdodF95YXdfb2Zmc2V0AKpwaXRjaF9sYW5kwtkgY29uZGl0aW9uc19XYWxraW5nX2RlZmVuc2l2ZV95YXfC2SJjb25kaXRpb25zX1dhbGtpbmdfZGVmZW5zaXZlX3BpdGNoqERpc2FibGVkrndhbGtfYW5pbWF0aW9uwrBjcm91Y2hfYW5pbWF0aW9uwr9jb25kaXRpb25zX1dhbGtpbmdfeWF3X21vZGlmaWVypkNlbnRlctkpY29uZGl0aW9uc19XYWxraW5nX2RlZmVuc2l2ZV9jdXN0b21fcGl0Y2jQp9kmY29uZGl0aW9uc19XYWxraW5nX3lhd19tb2RpZmllcl9vZmZzZXQA2SFjb25kaXRpb25zX0Fpci1DX3JpZ2h0X3lhd19vZmZzZXQju2NvbmRpdGlvbnNfV2Fsa2luZ19ib2R5X3lhd8PZIGNvbmRpdGlvbnNfQWlyLUNfbGVmdF95YXdfb2Zmc2V0771jb25kaXRpb25zX1dhbGtpbmdfbGVmdF9saW1pdDy0Y29uZGl0aW9uc19BaXItQ195YXeoQmFja3dhcmS+Y29uZGl0aW9uc19XYWxraW5nX3JpZ2h0X2xpbWl0PLhjb25kaXRpb25zX1dhbGtpbmdfcGl0Y2ikRG93btkjY29uZGl0aW9uc19XYWxraW5nX2JvZHlfeWF3X29wdGlvbnORpkppdHRlctkqY29uZGl0aW9uc19EdWNraW5nIFRfYm9keV95YXdfZnJlZXN0YW5kaW5no09mZtkoY29uZGl0aW9uc19XYWxraW5nX2JvZHlfeWF3X2ZyZWVzdGFuZGluZ6NPZma8Y29uZGl0aW9uc19GYWtlZHVja19ib2R5X3lhd8PZKWNvbmRpdGlvbnNfU3RhbmRpbmdfYm9keV95YXdfZnJlZXN0YW5kaW5no09mZr5jb25kaXRpb25zX01vdmluZ195YXdfbW9kaWZpZXKoRGlzYWJsZWS7Y29uZGl0aW9uc19EdWNraW5nIENUX3BpdGNopERvd26/Y29uZGl0aW9uc19GYWtlZHVja19yaWdodF9saW1pdDy5Y29uZGl0aW9uc19EdWNraW5nIENUX3lhd6hCYWNrd2FyZNkqY29uZGl0aW9uc19GYWtlZHVja19kZWZlbnNpdmVfY3VzdG9tX3BpdGNo0KfZJWNvbmRpdGlvbnNfRHVja2luZyBDVF9sZWZ0X3lhd19vZmZzZXTh2SRjb25kaXRpb25zX1N0YW5kaW5nX2JvZHlfeWF3X29wdGlvbnORpkppdHRlctkmY29uZGl0aW9uc19EdWNraW5nIENUX3JpZ2h0X3lhd19vZmZzZXQttmNvbmRpdGlvbnNfQWlyLUNfcGl0Y2ikRG93btkjY29uZGl0aW9uc19EdWNraW5nIENUX2RlZmVuc2l2ZV95YXfC2SVjb25kaXRpb25zX0R1Y2tpbmcgQ1RfZGVmZW5zaXZlX3BpdGNoqERpc2FibGVk2Sxjb25kaXRpb25zX0R1Y2tpbmcgQ1RfZGVmZW5zaXZlX2N1c3RvbV9waXRjaNCnvmNvbmRpdGlvbnNfQWlyLUNfZGVmZW5zaXZlX3lhd8K/Y29uZGl0aW9uc19BaXJfcmlnaHRfeWF3X29mZnNldB69Y29uZGl0aW9uc19BaXItQ195YXdfbW9kaWZpZXKoRGlzYWJsZWS8Y29uZGl0aW9uc19BaXJfZGVmZW5zaXZlX3lhd8K+Y29uZGl0aW9uc19BaXJfZGVmZW5zaXZlX3BpdGNoqERpc2FibGVk2SVjb25kaXRpb25zX0Fpcl9kZWZlbnNpdmVfY3VzdG9tX3BpdGNo0Ke/Y29uZGl0aW9uc19Nb3ZpbmdfZGVmZW5zaXZlX3lhd8K7Y29uZGl0aW9uc19BaXJfeWF3X21vZGlmaWVyqERpc2FibGVk2Sljb25kaXRpb25zX0Zha2VkdWNrX2JvZHlfeWF3X2ZyZWVzdGFuZGluZ6NPZmbZImNvbmRpdGlvbnNfQWlyX3lhd19tb2RpZmllcl9vZmZzZXQA2Sdjb25kaXRpb25zX0Zha2VkdWNrX3lhd19tb2RpZmllcl9vZmZzZXTot2NvbmRpdGlvbnNfQWlyX2JvZHlfeWF3w61hY3RpdmVfcHJlc2V0q0NvbmRpdGlvbmFsuWNvbmRpdGlvbnNfQWlyX2xlZnRfbGltaXQ82SFjb25kaXRpb25zX0Fpci1DX2JvZHlfeWF3X29wdGlvbnORpkppdHRlcrpjb25kaXRpb25zX0Fpcl9yaWdodF9saW1pdDzZIGNvbmRpdGlvbnNfQWlyLUNfZGVmZW5zaXZlX3BpdGNoqERpc2FibGVkv2NvbmRpdGlvbnNfQWlyX2JvZHlfeWF3X29wdGlvbnORpkppdHRlctknY29uZGl0aW9uc19BaXItQ19kZWZlbnNpdmVfY3VzdG9tX3BpdGNo0KfZJGNvbmRpdGlvbnNfQWlyX2JvZHlfeWF3X2ZyZWVzdGFuZGluZ6NPZmayY29uZGl0aW9uc19BaXJfeWF3qEJhY2t3YXJkqXN0YXRpc3RpY4enbGFiZWxfM85m+uHZp2xhYmVsXzHOff3uXax0aW1lc19sb2FkZWTOu0z2R6VraWxsc85fpWOlpGhpdHPOJMdx76ZtaXNzZXPO5oBbzatlcnJvcnNfdGltZc6kheS1p2dlbmVyYWyEs3Nob3dfcHJlc2V0X21hbmFnZXLDq3ByZXNldF9uYW1loKd2ZXJzaW9uzp7nlWembG9nZ2VkztArFGk="
    ui_handler.configs.load(data)

    table.insert(aimbot_logger.data, {
        text = {
            "Default config ",
            "succesfully ",
            "imported!",
            "",
            "",
            "",
            "",
            "",
            ""
        },
        time = globals.realtime+1,
        color = color(5, 133, 182, 255)
    })
    utils.console_exec("play ui\\beepclear")
end)

menu.button(ui_handler.tab.general.settings, defines.colored_text({"  "}, {"icon_file-export", colors.link_active}, {" Export Settings "}), function() ui_handler.configs.export() end, true)("home", "settings_export", false)

menu.button(ui_handler.tab.general.settings, defines.colored_text({"  "}, {"icon_file-import", colors.link_active}, {" Import Settings "}), function() ui_handler.configs.import() end, true)("home", "settings_import", false)

menu.button(ui_handler.tab.general.settings, defines.colored_text({"            "}, {"icon_user-gear", colors.link_active}, {" Load Recommended Settings           "}), ui_handler.configs.default, true)("home", "settings_default", false)


presets.currently_using = db.benzo_preset
presets.db = db.benzo_manager or {}

presets.tbl = {}


presets.path = "nl\\scripts\\benzo\\configs.json"

presets.save = function()
    local ps = ui_handler.refs["general"]["preset_list"].ref
    local preset_name = ui_handler.refs["general"]["preset_name"].ref

    local config_data = presets.db

    local do_save = 0

    if preset_name:get():gsub(' ', '') == '' or preset_name:get() == '' then
        do_save = 1
        
        for i=1,#config_data do
            local config_name = config_data[i].name

            if config_name == ps:list()[ps:get()] then
                do_save = -1

                presets.db[preset_name:get()] = ui_handler.configs.parse("aa")
            
            end
        end
    end
    for i=1, #config_data do
        local config_name = config_data[i].name

        if config_name == preset_name:get() then
            do_save = 2

            presets.db[preset_name:get()] = ui_handler.configs.parse("aa")
            
            preset_name:set('')
            do_save = -2
            break
        end
    end

    if preset_name:get():gsub(' ', '') ~= '' then
        local work = true

        for i=1, #config_data do
            local config_name = config_data[i].name

            if config_name == preset_name:get() then
                work = false
            end
        end

        if work then
            do_save = 3

            presets.db[preset_name:get()] = ui_handler.configs.parse("aa")
            
            preset_name:set('')
            do_save = -3
        end
    end

    cvar.play:call("ambient\\tones\\elev1")
end

presets.delete = function()
    local ps = ui_handler.refs["general"]["preset_list"].ref
    local preset_name = ui_handler.refs["general"]["preset_name"].ref

    if presets.currently_using == ps:list()[ps:get()] then
        presets.currently_using = -1
    end

    presets.db[ps:list()[ps:get()]] = nil

    cvar.play:call("ambient\\tones\\elev1")

end

presets.export_preset = function()
    local ps = ui_handler.refs["general"]["preset_list"].ref
    local preset_name = ui_handler.refs["general"]["preset_name"].ref

    local current_preset = presets.db[ps:list()[ps:get()]]

    --name .. "\a7BCAFFFF - Active"

    if current_preset ~= nil then
        clipboard.set(current_preset)

        table.insert(aimbot_logger.data, {
            text = { "Preset was", " copied ", "into your clipboard.", "", "", "", "", "", "" },
            time = globals.realtime+1,
            color = color(5, 133, 182, 255)
        })
    end
    cvar.play:call("ambient\\tones\\elev1")
end

presets.import_preset = function()
    local ps = ui_handler.refs["general"]["preset_list"].ref
    local preset_name = ui_handler.refs["general"]["preset_name"].ref
    if preset_name:get():len() == 0 then
        return table.insert(aimbot_logger.data, {
            text = { "Enter", " valid ", "preset ", "name.", "", "", "", "", "" },
            time = globals.realtime+1,
            color = color(5, 133, 182, 255)
        })
    end

    presets.currently_using = preset_name:get()

    presets.db[presets.currently_using] = clipboard.get()
    utils.execute_after(0.5, function()
        ui_handler.configs.load(presets.db[presets.currently_using])
    end)

    table.insert(aimbot_logger.data, {
        text = { "Preset was", " imported ", "from your clipboard.", "", "", "", "", "", "" },
        time = globals.realtime+1,
        color = color(5, 133, 182, 255)
    })
    cvar.play:call("ambient\\tones\\elev1")
end
presets.load = function()
    local num = ui_handler.refs["general"]["preset_list"].ref

    presets.currently_using = num:list()[num:get()]

    ui_handler.configs.load(presets.db[presets.currently_using])
    
    table.insert(aimbot_logger.data, {
        text = { "Preset was", " loaded ", "from your clipboard.", "", "", "", "", "", "" },
        time = globals.realtime+1,
        color = color(5, 133, 182, 255)
    })
end

menu.switch(ui_handler.tab.antiaim.presets, "Show Preset Manager")("general", "show_presets", true, function() return ui_handler.elements["aa"]["show_antiaims"] end)

menu.list(ui_handler.tab.antiaim.presets, "Presets List")("general", "preset_list", false, function() return ui_handler.elements["general"]["show_presets"] and ui_handler.elements["aa"]["show_antiaims"] end)
menu.input(ui_handler.tab.antiaim.presets, "Config Name:")("general", "preset_name", true, function() return ui_handler.elements["general"]["show_presets"] and ui_handler.elements["aa"]["show_antiaims"] end)

menu.button(ui_handler.tab.antiaim.presets, defines.colored_text({"icon_floppy-disk"}, {" Save"}), function()
    presets.save()
end, true)("general", "save_preset", false, function() return ui_handler.elements["general"]["show_presets"] and ui_handler.elements["aa"]["show_antiaims"] end)


menu.button(ui_handler.tab.antiaim.presets, defines.colored_text({"icon_trash"}, {" Delete"}), function()
    presets.delete()
end, true)("general", "delete_preset", false, function() return ui_handler.elements["general"]["show_presets"] and ui_handler.elements["aa"]["show_antiaims"] end)

menu.button(ui_handler.tab.antiaim.presets, defines.colored_text({"icon_loader"}, {" Load"}), function()
    presets.load()
end, true)("general", "load_preset", false, function() return ui_handler.elements["general"]["show_presets"] and ui_handler.elements["aa"]["show_antiaims"] end)

menu.button(ui_handler.tab.antiaim.presets, defines.colored_text({"icon_loader"}, {" Export"}), function()
    presets.export_preset()
end, true)("general", "export_preset", false, function() return ui_handler.elements["general"]["show_presets"] and ui_handler.elements["aa"]["show_antiaims"] end)

menu.button(ui_handler.tab.antiaim.presets, defines.colored_text({"icon_loader"}, {" Import"}), function()
    presets.import_preset()
end, true)("general", "import_preset", false, function() return ui_handler.elements["general"]["show_presets"] and ui_handler.elements["aa"]["show_antiaims"] end)


local ctx = new_class()         
    :struct "common" {
        new_dragging = function(self, name, initial_pos)
            local name = tostring(name)
            local initial_pos = initial_pos or vector()

            local ui_group = ui.create("DRAGGINGn%_#_&")
            local mi_intersection = false

            local mt = { }
            local mt_data = {
                dragging = false,
                mouse_pos = vector(0, 0),
                mouse_pos_diff = vector(0, 0),
                intersected = nil,
                mi_intersection = nil,

                reference = (function()
                    local dragging_vector = {
                        ui_group:slider(("%s:dragging_x"):format(name), -16384, 16384, initial_pos.x),
                        ui_group:slider(("%s:dragging_y"):format(name), -16384, 16384, initial_pos.y)
                    }

                    local visibility = function()
                        dragging_vector[1]:visibility(false)
                        dragging_vector[2]:visibility(false)
                    end

                    dragging_vector[1]:set_callback(visibility)
                    dragging_vector[1]:set_callback(visibility, true)

                    return dragging_vector
                end)()

                -- ctx.common.new_dragging.reference()
            }

            function mt.intersects(self, mouse, pos, size)
                return
                    mouse.x >= pos.x and mouse.x <= pos.x+size.x and
                    mouse.y >= pos.y and mouse.y <= pos.y+size.y
            end

            function mt.get_position(self)
                return vector(
                    self.reference[1]:get(),
                    self.reference[2]:get()
                ),
                self.reference[1], self.reference[2]
            end

            function mt.is_dragging(self)
                return self.dragging
            end

            function mt.update(self, size)
                local new_mouse_pos = ui.get_mouse_position()
                local menu_pos = ui.get_position()
                local menu_size = ui.get_size()

                local holding_key, intersection_check =
                    ui.get_alpha() > 0 and common.is_button_down(1),
                    self:intersects(new_mouse_pos, self:get_position(), size) and not
                    self:intersects(new_mouse_pos, menu_pos, menu_size)

                self.mouse_pos_diff = -(self.mouse_pos-new_mouse_pos)

                if holding_key and self.intersected == nil then
                    self.intersected = intersection_check
                end

                if holding_key and self.intersected then
                    self.dragging = true
                elseif not holding_key then
                    self.dragging = false
                    self.intersected = nil
                end

                if self.dragging then
                    local screen = defines.screen_size
                    local limit, new_pos = size * .5, vector(
                        self.reference[1]:get() + self.mouse_pos_diff.x,
                        self.reference[2]:get() + self.mouse_pos_diff.y
                    )

                    self.reference[1]:set(math.max(-limit.x, math.min(screen.x-limit.x, new_pos.x)))
                    self.reference[2]:set(math.max(-limit.y, math.min(screen.y-limit.y, new_pos.y)))
                end

                self.mouse_pos = new_mouse_pos
                self.mi_intersection = intersection_check or self.dragging

                return self:get_position(), self.dragging
            end

            local dragging = setmetatable(mt, { __index = mt_data })

            events.mouse_input:set(function()
                if dragging.mi_intersection then
                    return false
                end
            end)

            return dragging
        end
}
conditional_antiaims.states = {
    unknown = -1,
    standing = 1,
    moving = 2,
    slowwalk = 3,
    crouching_t = 4,
    crouching_ct = 5,
    air = 6,
    air_crouch = 7,
    fakeduck = 8
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

    local is_crouching = bit.band(flags, FL_DUCKING) ~= 0
    local on_ground = bit.band(flags, FL_ONGROUND) ~= 0
    local is_not_moving = localplayer.m_vecVelocity:length() < 2
    local is_slowwalk = neverlose_refs.slow_walk:get()
    local is_jumping = cmd.in_jump
    local is_fakeduck = neverlose_refs.fake_duck:get()

    local get_threat = entity.get_threat()


    
    --[[
        conditional_antiaims.create_condition("Fakeduck", function()
            return conditional_antiaims.player_state == conditional_antiaims.states.fakeduck
        end)

        conditional_antiaims.create_condition("On low ground", function()
            return conditional_antiaims.player_state == conditional_antiaims.states.low_ground
        end)
        conditional_antiaims.create_condition("On hight ground", function()
            return conditional_antiaims.player_state == conditional_antiaims.states.high_ground
        end)
    ]]

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

    if is_crouching and localplayer.m_iTeamNum == 2 then
        conditional_antiaims.player_state = conditional_antiaims.states.crouching_t
        return
    end

    if is_crouching and localplayer.m_iTeamNum == 3 then
        conditional_antiaims.player_state = conditional_antiaims.states.crouching_ct
        return
    end

    if not is_crouching and not is_not_moving and not is_slowwalk then
        conditional_antiaims.player_state = conditional_antiaims.states.moving
        return
    end

    if is_fakeduck then
        conditional_antiaims.player_state = conditional_antiaims.states.fakeduck
        return
    end

    conditional_antiaims.player_state = conditional_antiaims.states.unknown
end
conditional_antiaims.manual_yaws = {
    ["Left"] = -90,
    ["Right"] = 90,
    ["Forward"] = 180,
    ["Backward"] = 0
}
conditional_antiaims.disablers = function(parameter)
    local rules = entity.get_game_rules()

    if rules == nil then
        return false
    end

    local players = entity.get_players(true, false)

    if players == nil then
        return false
    end

    if parameter == "Warmup" and rules.m_bWarmupPeriod then
        return true
    else
        return false
    end
end
conditional_antiaims.set_yaw_base = function(new_config)
    
    local manual_yaw = ui_handler.elements["aa"]["manuals"]
    local is_manuals = (manual_yaw == "Left" or manual_yaw == "Right")

    local is_predefined = conditional_antiaims.manual_yaws[manual_yaw]

    local tweaks = ui_handler.refs["aa"]["helpers"].ref

    if tweaks:get("Warmup Disablers") and conditional_antiaims.disablers() then
        new_config.pitch = "Disabled"
        new_config.yaw = "Disabled"
        new_config.yaw_base = "Local View"
        new_config.yaw_offset = 0
        new_config.freestanding = false
        new_config.body_yaw = false
    elseif manual_yaw == "Freestanding" then
        if is_predefined then
            new_config.yaw_offset = (tweaks:get("Static on Freestanding") and 0 or new_config.yaw_offset) + is_predefined
            return
        end

        if tweaks:get("Static on Freestanding") then
            if not is_predefined then
                new_config.yaw_offset = 0
            end
            new_config.yaw_modifier = "Disabled"
            new_config.body_yaw_options = ""
        end

        new_config.freestanding = true
    elseif manual_yaw ~= "Freestanding" then
        if is_manuals then
            if not is_predefined then
                new_config.yaw_offset = 0
            else
                new_config.yaw_offset = is_predefined
                new_config.yaw_modifier = "Disabled"
                new_config.body_yaw_options = ""
            end
        end
        if manual_yaw == "At target" then
            new_config.yaw_base = "At Target"
        else
            new_config.yaw_base = "Local View"
        end

    end

    new_config.yaw_backstab = true
end

conditional_antiaims.conditions = {}
conditional_antiaims.condition_names = {}

menu.switch(ui_handler.tab.antiaim.general, "Show anti-aims")("aa", "show_antiaims", true)

menu.combo(ui_handler.tab.antiaim.settings, "Mode", "Disabled", "Dynamic", "Conditional")("aa", "active_preset", true, function() return ui_handler.elements["aa"]["show_antiaims"] end) -- ui_handler.elements["aa"]["show_antiaims"]

menu.combo(ui_handler.tab.antiaim.general, "Manual AA", {"Disabled", "Forward", "Backward", "Left", "Right", "At target", "Freestanding"})("aa", "manuals", true, function()
    return ui_handler.elements["aa"]["show_antiaims"]
end)

menu.label(ui_handler.tab.antiaim.automatic, "You are using dynamic mode.\nEverything is already set up. Enjoy!")("aa", "automatic_label", false, function() return ui_handler.elements["aa"]["active_preset"] == "Dynamic" end)

menu.selectable(ui_handler.tab.antiaim.general, "Anti-aim Tweaks", {"Warmup Disablers", "Dormant Disablers", "Avoid backstab", "Fast Ladder Move", "Static Manual", "Static on Freestanding"})("aa", "helpers", true, function()
    return ui_handler.elements["aa"]["show_antiaims"]
end)

menu.selectable(ui_handler.tab.antiaim.general, "Lag Options", {"Standing", "Moving", "Walking", "Ducking CT", "Ducking T", "Air", "Air-C", "Fakeduck"})("aa", "lag_options", true, function()
    return ui_handler.elements["aa"]["show_antiaims"]
end)


menu.combo(ui_handler.tab.antiaim.settings, "Conditions", "")("aa", "current_state", true, function() return ui_handler.elements["aa"]["active_preset"] == "Conditional" and ui_handler.elements["aa"]["show_antiaims"] end)

conditional_antiaims.create_ui = function(name, idx)
    local current_condition = {}

    ui_handler.tab.antiaim.builder = ui.create(defines.colored_text({"icon_user", colors.link_active}, {" anti aim"}), defines.colored_text({"icon_gears", colors.link_active}, {" Setting up: "}, {name, colors.link_active}))

    local menu_group = ui_handler.tab.antiaim.builder

    local name_unique = "\aFFFFFF00" .. name
    local itemname_start = "conditions_" .. name .. "_"
    local yaw_modifiers = {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way", "Skitter"}

    local condition_fn = function()
        return ui_handler.elements["aa"]["active_preset"] == "Conditional" and ui_handler.elements["aa"]["current_state"] == name and ui_handler.elements["aa"]["show_antiaims"]
    end


    current_condition.pitch = menu.combo(menu_group, neverlose_refs.pitch:name():lower() .. name_unique, neverlose_refs.pitch:list())("aa", itemname_start .. "pitch", true, function() return condition_fn() end)
    current_condition.yaw = menu.combo(menu_group, neverlose_refs.yaw:name():lower() .. name_unique, neverlose_refs.yaw:list())("aa", itemname_start .. "yaw", true, function() return condition_fn() end)
    current_condition.left_yaw_offset = menu.slider(menu_group, "~ " .. "left offset" .. name_unique, -180, 180, 0)("aa", itemname_start .. "left_yaw_offset", true, function() return condition_fn() end)
    current_condition.right_yaw_offset = menu.slider(menu_group, "~ " .. "right offset" .. name_unique, -180, 180, 0)("aa", itemname_start .. "right_yaw_offset", true, function() return condition_fn() end)

    current_condition.defensive_yaw = menu.switch(menu_group, "~ " .. "defensive yaw" .. name_unique)("aa", itemname_start .. "defensive_yaw", true, function() return condition_fn() end)(function(group)
        current_condition.defensive_pitch = menu.combo(group, "pitch" .. name_unique, "Disabled", "Down", "Up", "Random", "Custom")("aa", itemname_start .. "defensive_pitch", true, function() return condition_fn() and ui_handler.elements["aa"][itemname_start .. "defensive_yaw"] end)
        current_condition.defensive_custom_pitch = menu.slider(group, "Custom Pitch", -89, 89)("aa", itemname_start .. "defensive_custom_pitch", true, function() return condition_fn() and ui_handler.elements["aa"][itemname_start .. "defensive_yaw"] and ui_handler.elements["aa"][itemname_start .. "defensive_pitch"] == "Custom" end)
    end)

    current_condition.yaw_modifier = menu.combo(menu_group, "~ " .. "modifier" .. name_unique, yaw_modifiers)("aa", itemname_start .. "yaw_modifier", true, function() return condition_fn() end)(function(group)
        current_condition.yaw_modifier_offset = menu.slider(group, neverlose_refs.yaw_modifier_offset:name() .. name_unique, -180, 180, 0)("aa", itemname_start .. "yaw_modifier_offset", true, function()
            return ui_handler.elements["aa"][itemname_start .. "yaw"] ~= "Delayed Switch"
        end)
    end)

    current_condition.body_yaw = menu.switch(menu_group, "~ " .. neverlose_refs.body_yaw:name():lower() .. name_unique, true)("aa", itemname_start .. "body_yaw", true, function() return condition_fn() end)
    current_condition.left_limit = menu.slider(menu_group, "~ " .. neverlose_refs.left_limit:name():lower() .. name_unique, 0, 60, 60)("aa", itemname_start .. "left_limit", true, function() return condition_fn() end)
    current_condition.right_limit = menu.slider(menu_group, "~ " .. neverlose_refs.right_limit:name():lower() .. name_unique, 0, 60, 60)("aa", itemname_start .. "right_limit", true, function() return condition_fn() end)
    current_condition.body_yaw_options = menu.selectable(menu_group, "~ " .. neverlose_refs.body_yaw_options:name():lower() .. name_unique, neverlose_refs.body_yaw_options:list())("aa", itemname_start .. "body_yaw_options", true, function() return condition_fn() end)
    current_condition.body_yaw_freestanding = menu.combo(menu_group, "~ " .. neverlose_refs.body_yaw_freestanding:name():lower() .. name_unique, neverlose_refs.body_yaw_freestanding:list())("aa", itemname_start .. "body_yaw_freestanding", true, function() return condition_fn() end)
    

    for k, v in pairs(current_condition) do
        if type(v) == "function" then
            current_condition[k] = current_condition[k]()
        end
    end

    return current_condition
end
defines.menu_combo_sanitizer = function(tbl)
    local tmp = {}

    for k, v in pairs(tbl) do
        table.insert(tmp, k)
    end

    return tmp
end
conditional_antiaims.set_ui = safecall("set_ui", true, function(new_config)
    for k, v in pairs(new_config) do
        local new_val = v
        if type(v) == "table" then
            new_val = defines.menu_combo_sanitizer(new_val)
        end
        --neverlose_refs.k:get() ~= "Skitter" then
            neverlose_refs.override(k, new_val)
        --end
    end
end)

conditional_antiaims.get_cond_values = function(idx)
    
    local cond_tbl = conditional_antiaims.conditions[idx]
    if cond_tbl == nil then
        return
    end

    local new_config = {}

    for k, v in pairs(cond_tbl.ui) do
        local tbl_name = "conditions_" .. cond_tbl.name .. "_"
        new_config[k] = ui_handler.elements["aa"][tbl_name .. k]
    end

    return new_config
end

conditional_antiaims.get_active_idx = function()
    for k, v in ipairs(conditional_antiaims.conditions) do
        if k ~= 1 and v.condition() --[[пихуй]] then
            return k
        end
    end

    return 1
end

conditional_antiaims.get_active_condition = function(idx, element)
    local cond_tbl = conditional_antiaims.conditions[idx]
    if cond_tbl == nil then
        return
    end

    local tbl_name = "conditions_" .. cond_tbl.name .. "_"
    return ui_handler.elements["aa"][tbl_name .. element]
end

conditional_antiaims.set_yaw = safecall("left_right_yaw", true, function(new_config)
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    if globals.choked_commands ~= 0 then 
        return
    end

    local body_yaw = player.m_flPoseParameter[11] * 120 - 60


    new_config.yaw_offset = body_yaw > 0 and new_config.left_yaw_offset or new_config.right_yaw_offset
end)

conditional_antiaims.defensive_helpers = safecall("defensive_helpers", true, function()
    if ui_handler.refs["aa"]["lag_options"].ref:get(conditional_antiaims.player_state) then
        neverlose_refs.override("doubletap_config", "Always On")
    end
end)

conditional_antiaims.dynamic_mode = safecall("dynamic_mode", true, function(new_config)
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    if ui_handler.elements["aa"]["active_preset"] == "Dynamic" then
        if conditional_antiaims.player_state == conditional_antiaims.states.standing then
            neverlose_refs.override("yaw_offset", player.m_flPoseParameter[11] * 120 - 60 > 0 and -10 or 10)
            neverlose_refs.override("pitch")
            neverlose_refs.override("yaw_modifier", "3-Way")
            neverlose_refs.override("yaw_modifier_offset", -50)
            neverlose_refs.override("body_yaw", true)
            neverlose_refs.override("left_limit", 60)
            neverlose_refs.override("right_limit", 60)
            neverlose_refs.override("body_yaw_options", "Jitter")
        elseif conditional_antiaims.player_state == conditional_antiaims.states.moving then
            neverlose_refs.override("yaw_offset", player.m_flPoseParameter[11] * 120 - 60 > 0 and -15 or 15)
            neverlose_refs.override("pitch")
            neverlose_refs.override("yaw_modifier", "3-Way")
            neverlose_refs.override("yaw_modifier_offset", -40)
            neverlose_refs.override("body_yaw", true)
            neverlose_refs.override("left_limit", 56)
            neverlose_refs.override("right_limit", 56)
            neverlose_refs.override("body_yaw_options", "Jitter")
        elseif conditional_antiaims.player_state == conditional_antiaims.states.air then
            neverlose_refs.override("yaw_offset", player.m_flPoseParameter[11] * 120 - 60 > 0 and -25 or 25)
            neverlose_refs.override("pitch")
            neverlose_refs.override("yaw_modifier", "3-Way")
            neverlose_refs.override("yaw_modifier_offset", -20)
            neverlose_refs.override("body_yaw", true)
            neverlose_refs.override("left_limit", 55)
            neverlose_refs.override("right_limit", 55)
            neverlose_refs.override("body_yaw_options", "Jitter")
        else
            neverlose_refs.override("yaw_offset", player.m_flPoseParameter[11] * 120 - 60 > 0 and -40 or 40)
            neverlose_refs.override("pitch")
            neverlose_refs.override("yaw_modifier", "Disabled")
            neverlose_refs.override("yaw_modifier_offset", 0)
            neverlose_refs.override("body_yaw", true)
            neverlose_refs.override("left_limit", 60)
            neverlose_refs.override("right_limit", 60)
            neverlose_refs.override("body_yaw_options", "Jitter")
        end
    end
end)

conditional_antiaims.skitter_aa = 0
conditional_antiaims.skitter = safecall("skitter", true, function(cmd, new_config)
    if cmd.choked_commands == 0 then
        conditional_antiaims.skitter_aa = conditional_antiaims.skitter_aa + 1;

        if conditional_antiaims.skitter_aa >= 6 then
            conditional_antiaims.skitter_aa = 1
        end
    end

    local val = conditional_antiaims.skitter_aa



    if new_config.yaw_modifier == "Skitter" then

        if val == 1 then
            new_config.yaw_offset = new_config.yaw_modifier_offset
        elseif val == 2 then
            new_config.yaw_offset = -new_config.left_limit
        elseif val == 3 then
            new_config.yaw_offset = 0
        elseif val == 4 then
            new_config.yaw_offset = -new_config.yaw_modifier_offset
        elseif val == 5 then
            new_config.yaw_offset = new_config.right_limit
        end
        new_config.yaw_modifier = "Disabled"
    end

end)
conditional_antiaims.handle = function(cmd)
    if ui_handler.elements["aa"]["active_preset"] ~= "Conditional" then
        return
    end

    local current_condition = conditional_antiaims.get_active_idx()
    local new_config = conditional_antiaims.get_cond_values(current_condition)

    conditional_antiaims.set_yaw(new_config)
    conditional_antiaims.set_yaw_base(new_config)
    conditional_antiaims.skitter(cmd, new_config)

    conditional_antiaims.defensive_helpers()

    local pitch_tbl = {
        ["Disabled"] = 0,
        ["Up"] = -89,
        ["Down"] = 89,
        ["Random"] = math.random(0, 2) == 1 and -89 or 89,
        ["Custom"] = new_config.defensive_custom_pitch
    }

    if new_config.defensive_yaw then
        new_config.hidden = true
        rage.antiaim:override_hidden_pitch(pitch_tbl[new_config.defensive_pitch])
    end

    conditional_antiaims.set_ui(new_config)
end

conditional_antiaims.create_condition = function(name, condition)

    local cond_idx = #conditional_antiaims.conditions + 1
    conditional_antiaims.conditions[cond_idx] = {
        name = name,
        condition = condition,
    }

    conditional_antiaims.conditions[cond_idx].ui = conditional_antiaims.create_ui(name, cond_idx)

    table.insert(conditional_antiaims.condition_names, name)

    ui_handler.refs["aa"]["current_state"].ref:update(conditional_antiaims.condition_names)
end

conditional_antiaims.create_condition("Standing", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.standing
end)


conditional_antiaims.create_condition("Moving", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.moving
end)

conditional_antiaims.create_condition("Walking", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.slowwalk
end)

conditional_antiaims.create_condition("Ducking CT", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.crouching_ct
end)

conditional_antiaims.create_condition("Ducking T", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.crouching_t
end)

conditional_antiaims.create_condition("Air", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.air
end)

conditional_antiaims.create_condition("Air-C", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.air_crouch
end)

conditional_antiaims.create_condition("Fakeduck", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.fakeduck
end)


fast_ladder.handle = function(cmd)
    if not ui_handler.elements["aa"]["helpers"]["Fast Ladder Move"] then
        return
    end

    local player = entity.get_local_player()
    local fixed_nade = true;
    
    if player.m_bPinPulled ~= true then
        fixed_nade = player.m_fThrowTime == nil
    end

    if player.m_MoveType == 9 and fixed_nade then
        if cmd.sidemove == 0 then
            cmd.view_angles.y = cmd.view_angles.y + 45
        end

        if cmd.in_forward then
            if cmd.sidemove > 0 then
                cmd.view_angles.y = cmd.view_angles.y - 1
            end

            if cmd.sidemove < 0 then
                cmd.view_angles.y = cmd.view_angles.y + 90
            end

            cmd.in_moveleft = 0
            cmd.in_moveright = 1
        end

        if cmd.in_back then
            if cmd.sidemove < 0 then
                cmd.view_angles.y = cmd.view_angles.y - 1
            end

            if cmd.sidemove > 0 then
                cmd.view_angles.y = cmd.view_angles.y + 90
            end

            cmd.in_moveleft = 1
            cmd.in_moveright = 0
        end
    end
end
model_breaker.last_tick = 0
model_breaker.update = safecall("model_breaker.update", true, function(thisptr, edx)
    hooked_function(thisptr, edx)

    if not ui_handler.elements["aa"]["animation_breakers"] then
        return
    end
    local player = entity.get_local_player()

    if player == nil or ffi.cast("uintptr_t", thisptr) == nil or ffi_handler.get_entity_address(player:get_index()) ~= thisptr then
        return
    end 

    local leg_animation = ui_handler.elements["aa"]["leg_animation"]
    local air_animation = ui_handler.elements["aa"]["air_animation"]
    local in_air = conditional_antiaims.player_state == conditional_antiaims.states.air or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch or conditional_antiaims.player_state == conditional_antiaims.states.crouching_ct or conditional_antiaims.player_state == conditional_antiaims.states.crouching_t or conditional_antiaims.player_state == conditional_antiaims.states.slowwalk

    if leg_animation == "Backward" then
        player.m_flPoseParameter[0] = 1
    elseif leg_animation == "Michael Jackson" then
        neverlose_refs.legs:set("Walking")
        player.m_flPoseParameter[7] = 0
    elseif leg_animation == "Jitter" then
        neverlose_refs.legs:set("Sliding")
        player.m_flPoseParameter[0] = globals.tickcount%3 > 1.6 and 0.65 or 1
        if model_breaker.last_tick < 50 and player.m_vecVelocity:length() > 4 then
            ffi.cast("CAnimationLayer**", ffi.cast("uintptr_t", thisptr) + 0x2990)[0][7].m_flWeight = 1
        end
    end


    if not in_air   then
        model_breaker.last_tick = 0
    end

    model_breaker.last_tick = model_breaker.last_tick + 1

    if air_animation == "Frozen" then
        player.m_flPoseParameter[6] = 1
    elseif air_animation == "Michael Jackson" and in_air then
        ffi.cast("CAnimationLayer**", ffi.cast("uintptr_t", thisptr) + 0x2990)[0][6].m_flWeight = 1
    end

    if ui_handler.elements["aa"]["pitch_land"] then
        if not in_air and ffi.cast("CCSGOPlayerAnimationState_534535_t**", ffi.cast("uintptr_t", thisptr) + 0x9960)[0].bHitGroundAnimation then
            player.m_flPoseParameter[12] = 0.5
        end
    end

    if ui_handler.elements["aa"]["walk_animation"] and neverlose_refs.slow_walk:get() then
        player.m_flPoseParameter[9] = 0
    end
    if ui_handler.elements["aa"]["crouch_animation"] and (conditional_antiaims.player_state == conditional_antiaims.states.crouching_ct or conditional_antiaims.player_state == conditional_antiaims.states.crouching_t) then
        player.m_flPoseParameter[8] = 0
    end
    
end)
model_breaker.handle = function()
    local player = entity.get_local_player()
                
    if player == nil then
        return
    end

    local local_player_ptr = ffi_handler.get_entity_address(player:get_index())

    if local_player_ptr == nil or hooked_function then
        return
    end

    local new_point = vmt_hook.new(local_player_ptr)
    hooked_function = new_point.hook("void(__fastcall*)(void*, void*)", model_breaker.update, 224)
end

menu.switch(ui_handler.tab.antiaim.general, "Animation Breakers")("aa", "animation_breakers", true, function() return ui_handler.elements["aa"]["show_antiaims"] end)(function(group)
    menu.combo(group, "In air", "Default", "Frozen", "Michael Jackson")("aa", "air_animation", true, function() return ui_handler.elements["aa"]["animation_breakers"] end)
    menu.combo(group, "Leg Movement", "Default", "Backward", "Jitter", "Michael Jackson")("aa", "leg_animation", true, function() return ui_handler.elements["aa"]["animation_breakers"] end)

    menu.switch(group, "Pitch 0 on Land")("aa", "pitch_land", true, function() return ui_handler.elements["aa"]["animation_breakers"] end)
    menu.switch(group, "Sliding Slow Walk")("aa", "walk_animation", true, function() return ui_handler.elements["aa"]["animation_breakers"] end)
    menu.switch(group, "Sliding Crouch")("aa", "crouch_animation", true, function() return ui_handler.elements["aa"]["animation_breakers"] end)
end)

watermark.style = 0
watermark.handle = function()
    local x, y = defines.screen_size.x, defines.screen_size.y
    local clr = ui_handler.elements["features"]["logo_color"]

    local animated_text = gradient.text_animate("benzolua", -1, {color(25, 25, 25), color(clr.r, clr.g, clr.b)})
    local text = defines.colored_text({"discord.gg/", color(255)}, {animated_text:get_animated_text()})
    local text_size = render.measure_text(1, nil, text)

    watermark.style = ui_handler.elements["features"]["logo_style"] ==  "Right Upper" and 2 or 1

    render.text(
        1,
        vector((watermark.style == 2 and defines.screen_size.x-text_size.x-10 or defines.screen_size.x/2-text_size.x/2), (watermark.style == 2 and 10 - 5 or defines.screen_size.y-25)),
        clr:override("a", 255),
        nil,
        text
    )

    
    animated_text:animate()
end

menu.label(ui_handler.tab.general.synchronization, defines.colored_text({"icon_droplet", colors.link_active}, {" [Logo] Customize -->"}))("features", "logo")(function(group)
    menu.combo(group, "Style", "Right Upper", "Bottom Center")("features", "logo_style", true)
    menu.color_picker(group, defines.colored_text({"icon_droplet", colors.link_active}, {" [LOGO] Color"}))("features", "logo_color")
end)


indicators.activity = 0
indicators.antiaim_states = {
    "STANDING",
    "MOVING",
    "WALKING",
    "CROUCHING CT",
    "CROUCHING T",
    "AIR",
    "AIR+C",
    "FD"
}
indicators.get_defensive = function()
    local net_channel, simtime = utils.net_channel(), entity.get_local_player():get_simulation_time()
    local difference = simtime.current - simtime.old
    if difference < 0 then
        indicators.activity = globals.tickcount + math.abs(difference) - defines.time_to_ticks(net_channel.latency[0])
    end

    return indicators.activity > globals.tickcount
end

indicators.gram_create = function(value, count) 
    local gram = { }; 
    for i=1, count do 
        gram[i] = value; 
    end 
    return gram; 
end

indicators.vars = {
    charge = smoothy.new(0),
    menu = smoothy.new(0),
    pulse = smoothy.new(0),
}

for i = 1, 15 do
    indicators.vars[i] = {
        alpha_modulate = smoothy.new(0),
        scope_adder = smoothy.new(0),
        width = smoothy.new(0)
    }
end


indicators.handle = function()
    local player = entity.get_local_player()
    if player == nil or not player:is_alive() then
        return 
    end

    local center = defines.screen_size / 2
    
    local offset = ui_handler.elements["features"]["crosshair_offset"]
    local first_color = ui_handler.elements["features"]["indicators_color1"]
    local second_color = ui_handler.elements["features"]["indicators_color2"]
    local ind_color = ui_handler.elements["features"]["crosshair_color"]
    local is_defensive = indicators.get_defensive()

    local is_enabled = ui_handler.refs["features"]["crosshair_indicators"].ref:get() and ui_handler.refs["features"]["indication_elements"].ref:get("Crosshair indicators")

    local pulse = indicators.vars.pulse(.05, globals.realtime%1.5 > 0.2)
    local condition = indicators.antiaim_states[conditional_antiaims.player_state]

    local menu_a = indicators.vars.menu(.05, is_enabled)

    if menu_a < 0.1 then
        return
    end

    if ui_handler.elements["features"]["crosshair_style"] == "Default" then
        local list = {
            {defines.colored_text({"BENZO ", first_color}, {defines.build:upper(), second_color:override("a", pulse*255)}), true},
            {"- " .. condition .. " -", true},
            {"DT", neverlose_refs.doubletap:get()},
            {"DMG", defines.get_bind("Min. Damage")[1]},
        }
        for idx, val in pairs(list) do
            if val[3] == nil then
                val[3] = color(255)
            end

            if val[2] == nil then
                val[2] = true
            end

            --rage.exploit:get() == 1 and (is_defensive and "DT \aAFEEEE80ACTIVE" or "DT \a32CD32FFREADY") or "DT \aDC143C80WAITING"
            local charge = indicators.vars.charge(.04, rage.exploit:get())
            local colour = (color(255, 64, 64):lerp(color(192, 255, 145), charge)):to_hex()

            local a = 255;
            local pct;

            local text = val[1]; do
                if text == "DT" then
                    if not val[2] then
                        text = f("%s OFF", text);
                    elseif charge == 0 then
                        a = 127;
                        text = f("%s \aff4040ffWAITING", text);
                    elseif charge > 0 and charge < 1 then
                        text = f(
                            "%s \a%sCHARGING",
                            text,
                            colour
                        )
                    elseif is_defensive then
                        text = f("%s \a78ffffffACTIVE", text)
                    else
                        text = f("%s \ac0ff91ffREADY", text)
                    end
                end
            end

            
            local state = val[2]
            local alpha = indicators.vars[idx].alpha_modulate(.05, val[2])*menu_a
            
            local width = render.measure_text(2, "", text)
            local max_width = indicators.vars[idx].width(.1, width.x);

            if width.x < max_width then
                max_width = width.x
                if width.x > max_width then
                    width.x = max_width
                end
            end

            max_width = math.clamp(max_width, max_width, max_width/2)

            local scope = indicators.vars[idx].scope_adder(.05, player.m_bIsScoped and 5 or -max_width/2)

             
            render.push_clip_rect(vector(center.x + scope - max_width*alpha, center.y+offset), vector(center.x + scope + max_width*alpha, center.y+offset+12))
            render.text(2, vector(center.x + scope, center.y + offset), val[3]:override("a", a*alpha), "", text)
            render.pop_clip_rect()


            offset = offset + 8*alpha
        end
    elseif ui_handler.elements["features"]["crosshair_style"] == "Modern" then

        local manual_yaw = ui_handler.elements["aa"]["manuals"]
        local is_predefined = (manual_yaw == "Left" or manual_yaw == "Right" or manual_yaw == "Forward" or manual_yaw == "Backward" or manual_yaw == "Freestanding")

        --[[
                ["Left"] = -90,
    ["Right"] = 90,
    ["Forward"] = 180,
    ["Backward"] = 0
        ]]


        local list = {
            {defines.colored_text({"benzo", color(255)}, {" tech", ind_color:override("a", 255)}), true, color(255)},
            {defines.build:lower(), true, ind_color:override("a", 1*255)},
            {"rapid", neverlose_refs.doubletap:get(), color(255, 0, 0):lerp(color(255), rage.exploit:get())},
            {"os-aa", neverlose_refs.hideshots:get(), color(255)},
            {"direction", is_predefined, color(255)},
            {"dmg", defines.get_bind("Min. Damage")[1], color(255)},
        }
        for idx, val in pairs(list) do
            

            local text_size = render.measure_text(1, "c", val[1])

            local act = player.m_bIsScoped

            
            local state = val[2] == nil and true or val[2]
            local alpha = indicators.vars[idx].alpha_modulate(.05, state)*menu_a
            local scope = indicators.vars[idx].scope_adder(.05, player.m_bIsScoped)


            local clr = val[1] == defines.build:lower() and val[3]:override("a", pulse*255) or val[3]:override("a", alpha*255)

            render.text(1, vector(center.x + (scope*text_size.x/2 + 5), center.y+offset), clr, "c", val[1])
            
            offset = offset + 11*alpha
        end
    end
end

velocity_warning.dragging = ctx.common:new_dragging("velocity_warning", vector(defines.screen_size.x/2-100, 200))
velocity_warning.in_bounds = function(x, y, x2, y2)
    return (ui.get_mouse_position().x > x) and (ui.get_mouse_position().y > y) and (ui.get_mouse_position().x < x2) and (ui.get_mouse_position().y < y2)
end

velocity_warning.alpha = smoothy.new(0)
velocity_warning.alpha_menu = smoothy.new(0)
velocity_warning.handle = function()

    local anim = {}
    local player = entity.get_local_player()

    if player == nil or not player:is_alive() then
        return
    end
    local m_flVelocityModifier = ui.get_alpha() > 0 and player.m_flVelocityModifier == 1 and 1-ui.get_alpha()/2 or player:is_alive() and player.m_flVelocityModifier or 1
    
    local menu_a = velocity_warning.alpha_menu(.05, ui_handler.refs["features"]["crosshair_indicators"].ref and ui_handler.refs["features"]["indication_elements"].ref:get("Velocity warning"))
    local alpha = velocity_warning.alpha(.05, ((ui.get_alpha() > 0 and 150 or m_flVelocityModifier ~= 1 and 255) or 0))*menu_a

    if menu_a < 0.1 then
        return
    end

    local velocity_color = ui_handler.elements["features"]["velocity_color"]
    local position, reference, reference2 = velocity_warning.dragging:get_position()
    

    render.shadow(vector(position.x, position.y+40), vector(position.x+200, position.y+4+40), color(velocity_color.r, velocity_color.g, velocity_color.b, alpha), 15, 0, 3)
    render.rect(vector(position.x, position.y+40), vector(position.x+200, position.y+5+40), color(0, 0, 0, alpha), 3)
    render.rect(vector(position.x+1, position.y+1+40), vector(position.x+m_flVelocityModifier*200-1, position.y+4+40), color(velocity_color.r, velocity_color.g, velocity_color.b, alpha), 3)

    render.text(1, vector(position.x+25, position.y-20+40), color(255, 255, 255, alpha), "", f("Max velocity reduced by %s%%", math.floor(100-m_flVelocityModifier*100)))

    if alpha > 0 and ui.get_alpha() > 0 then
        render.text(1, vector(position.x, position.y + 14+50), color(255, 255, 255, alpha), nil, "Press M2 to center.")
        render.rect_outline(vector(position.x-5, position.y+10), vector(position.x+206, position.y+60), color(255, 255, 255, alpha), 0, 3)

    end

    local measure = render.measure_text(1, nil, "Press M2 to center.")

    if common.is_button_down(0x02) and velocity_warning.in_bounds(position.x-5, position.y+10, position.x+206, position.y+60) then
        
        local lerped_x = vector(position.x, 0):lerp(vector(defines.screen_size.x/2-110, 0), 1).x
        local lerped_y = vector(0, position.y):lerp(vector(0, 200), 1).y

        reference:set(lerped_x)
        reference2:set(lerped_y)

    end
    velocity_warning.dragging:update(vector(205, 60))        
end

menu.switch(ui_handler.tab.features.interface, "Enable Indication")("features", "crosshair_indicators", true)(function(group)
    menu.selectable(group, "Elements", "Crosshair indicators", "Velocity warning")("features", "indication_elements", true, function() return ui_handler.elements["features"]["crosshair_indicators"] end)
    menu.combo(group, "[Indicators] Style", "Default", "Modern")("features", "crosshair_style", true, function() return ui_handler.elements["features"]["crosshair_indicators"] and ui_handler.elements["features"]["indication_elements"]["Crosshair indicators"] end)
    menu.slider(group, "[Indicators] Offset", 0, 100, 0)("features", "crosshair_offset", true, function() return ui_handler.elements["features"]["crosshair_indicators"] and ui_handler.elements["features"]["crosshair_style"] == "Default" and ui_handler.elements["features"]["indication_elements"]["Crosshair indicators"] end)
    menu.color_picker(group, "[Indicators] Logo Color")("features", "indicators_color1", true, function() return ui_handler.elements["features"]["crosshair_indicators"] and ui_handler.elements["features"]["crosshair_style"] == "Default" and ui_handler.elements["features"]["indication_elements"]["Crosshair indicators"] end)
    menu.color_picker(group, "[Indicators] Build Color")("features", "indicators_color2", true, function() return ui_handler.elements["features"]["crosshair_indicators"] and ui_handler.elements["features"]["crosshair_style"] == "Default" and ui_handler.elements["features"]["indication_elements"]["Crosshair indicators"] end)

    menu.color_picker(group, "[Indicators] Accent color")("features", "crosshair_color", true, function() return ui_handler.elements["features"]["crosshair_indicators"] and ui_handler.elements["features"]["crosshair_style"] == "Modern" and ui_handler.elements["features"]["indication_elements"]["Crosshair indicators"] end)

    menu.color_picker(group, "[Velocity warning] Accent color")("features", "velocity_color", true, function() return ui_handler.elements["features"]["crosshair_indicators"] and ui_handler.elements["features"]["indication_elements"]["Velocity warning"] end)
end)

manual_arrows.left = smoothy.new(0)
manual_arrows.right = smoothy.new(0)
manual_arrows.main = smoothy.new(0)
manual_arrows.handle = function()
    local player = entity.get_local_player()

    if player == nil or not player:is_alive() then
        return
    end
    

    local antiaim_manuals = ui_handler.elements["aa"]["manuals"]
    local manual_arrows_enable = ui_handler.elements["features"]["manual_arrows"]
    local manual_arrows_adding = ui_handler.elements["features"]["manual_arrows_adding"]
    local manual_arrows_accent_color = ui_handler.elements["features"]["manual_arrows_accent_color"]
    local pos = defines.screen_size/2


    local left_alpha = manual_arrows.left(.05, antiaim_manuals == "Left")
    local right_alpha = manual_arrows.right(.05, antiaim_manuals == "Right")

    local alpha = manual_arrows.main(.05, manual_arrows_enable)

    if alpha < 0.1 then
        return
    end
    
    render.poly(
        (antiaim_manuals == "Left" and manual_arrows_accent_color or colors.black):override("a", left_alpha*alpha*255),
        pos - vector(manual_arrows_adding, 0) - vector(0, 5),
        pos - vector(manual_arrows_adding, 0) - vector(9, 0),
        pos - vector(manual_arrows_adding, 0) + vector(0, 5)
    )

    render.poly(
        (antiaim_manuals == "Right" and manual_arrows_accent_color or colors.black):override("a", right_alpha*alpha*255), 
        pos + vector(manual_arrows_adding, 0) - vector(0, 5),
        pos + vector(manual_arrows_adding, 0) + vector(9, 0),
        pos + vector(manual_arrows_adding, 0) + vector(0, 5)
    )
end

menu.switch(ui_handler.tab.features.interface, "Enable Manual Indication")("features", "manual_arrows")(function(group)
    menu.slider(group, "Adding", 0, 100, 35, 1, "px")("features", "manual_arrows_adding", true, function()
        return ui_handler.elements["features"]["manual_arrows"]
    end)

    menu.color_picker(group, "Accent Color", color(113, 138, 182, 255))("features", "manual_arrows_accent_color", true, function()
        return ui_handler.elements["features"]["manual_arrows"]
    end)
end)

scope_overlay.alpha = smoothy.new(0)
scope_overlay.handle = function()
    
    neverlose_refs.override("scope_overlay", "Remove All")

	local width, height = defines.screen_size.x, defines.screen_size.y
	local offset, initial_position, speed, clr = 
        ui_handler.elements["features"]["scope_offset"],  
        ui_handler.elements["features"]["initial_pos"],  
        ui_handler.elements["features"]["fade_animation_speed"], 
        ui_handler.elements["features"]["scope_lines_color"]

	local me = entity.get_local_player()

    if me == nil or not me:is_alive() then
        return
    end
    
	local scoped = me.m_bIsScoped

	local FT = speed
	local alpha = scope_overlay.alpha(.05+FT*0.01, scoped and ui_handler.refs["features"]["scope_overlay"].ref:get())

    render.gradient(vector(width / 2, height/2 - initial_position), vector(width / 2 + 1, height/2-initial_position - offset), color(clr.r, clr.g, clr.b, alpha*clr.a), color(clr.r, clr.g, clr.b, alpha*clr.a), color(clr.r, clr.g, clr.b, 0), color(clr.r, clr.g, clr.b, 0))
	render.gradient(vector(width / 2, height/2 + initial_position), vector(width / 2 + 1, height/2+initial_position + offset), color(clr.r, clr.g, clr.b, alpha*clr.a), color(clr.r, clr.g, clr.b, alpha*clr.a), color(clr.r, clr.g, clr.b, 0), color(clr.r, clr.g, clr.b, 0))
	
    
    render.gradient(vector(width/2 + initial_position, height / 2), vector(width/2 + offset+initial_position, height / 2+1),color(clr.r, clr.g, clr.b, alpha*clr.a), color(clr.r, clr.g, clr.b, 0), color(clr.r, clr.g, clr.b, alpha*clr.a), color(clr.r, clr.g, clr.b, 0))
    render.gradient(vector(width/2 - initial_position, height / 2), vector(width/2 - offset-initial_position, height / 2+1),color(clr.r, clr.g, clr.b, alpha*clr.a), color(clr.r, clr.g, clr.b, 0), color(clr.r, clr.g, clr.b, alpha*clr.a), color(clr.r, clr.g, clr.b, 0))
	
    if alpha < 0.1 then
        return
    end
end

menu.switch(ui_handler.tab.features.interface, "Enable Custom Scope Lines")("features", "scope_overlay", true)(function(group)
    menu.color_picker(group, "Scope Lines Color", colors.white)("features", "scope_lines_color", true, function()
        return ui_handler.elements["features"]["scope_overlay"]
    end)

    menu.slider(group, "Initial pos", 0, 500, 190)("features", "initial_pos", true, function()
        return ui_handler.elements["features"]["scope_overlay"]
    end)

    menu.slider(group, "Offset", 0, 500, 15)("features", "scope_offset", true, function()
        return ui_handler.elements["features"]["scope_overlay"]
    end)

    menu.slider(group, "Fade animation speed", 3, 20, 12, nil, function(val)
        if val == 3 then return "Off" else return val.."fr" end
    end)("features", "fade_animation_speed", true, function()
        return ui_handler.elements["features"]["scope_overlay"]
    end)


end)

aimbot_logger.hitboxes = {"generic","head", "chest", "stomach","left arm", "right arm","left leg", "right leg","neck", "generic", "gear"}
aimbot_logger.data = {}
aimbot_logger.font = render.load_font("verdana", 20, "abd")
aimbot_logger.icon = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(20, 20))

aimbot_logger.container = function(text, pos, clr, time)
    local text_size = render.measure_text(1, nil, text) + vector(8, 10)
    
    pos = pos - vector(text_size.x/2, 0)

    render.shadow(pos, pos+text_size, clr, 30, 0, 4)
    render.rect(pos, pos+text_size, color(25, 25, 25):override("a", clr.a), 4)

    render.text(1, pos + vector(5, 4), colors.white:override("a", clr.a), nil, text)
end
aimbot_logger.num_format = function(b)
    local c=b%10;
    if c==1 and b~=11 then 
        return b.."st"
    elseif c==2 and b~=12 then 
        return b.."nd"
    elseif c==3 and b~=13 then 
        return b.."rd"
    else 
        return b.."th"
    end 
end

aimbot_logger.vars = {}
for i = 1, 6 do
    aimbot_logger.vars[i] = {
        alpha = smoothy.new(0)
    }
end
aimbot_logger.render = function()
    local center = defines.screen_size/2
    center.y = defines.screen_size.y/1.5

    local add_y = 0

    for k, v in ipairs(aimbot_logger.data) do
        local text = v.text

        local alpha = aimbot_logger.vars[k].alpha(.06, v.time > globals.realtime)

        aimbot_logger.container(
            defines.colored_text(
                {
                    text[1], 
                    colors.white:override("a", alpha*255)
                },
                {
                    text[2], 
                    v.color:override("a", alpha*255)
                },
                {
                    text[3], 
                    colors.white:override("a", alpha*255)
                },
                {
                    text[4], 
                    v.color:override("a", alpha*255)
                },
                {
                    text[5],
                    colors.white:override("a", alpha*255)
                },
                {
                    text[6], 
                    v.color:override("a", alpha*255)
                },
                {
                    text[7], 
                    colors.white:override("a", alpha*255)
                },
                {
                    text[8], 
                    v.color:override("a", alpha*255)
                },
                {
                    text[9], 
                    colors.white:override("a", alpha*255)
                }
            ),
            vector(defines.screen_size.x / 2, defines.screen_size.y / 1.2 + add_y),
            v.color:override("a", alpha*255),
            v.time
        )

        add_y = add_y + 30 * alpha

        if alpha < 0.01 and (v.time < globals.realtime) or #aimbot_logger.data > 5 then
            table.remove(aimbot_logger.data, k)
        end
    end
end
aimbot_logger.handle = function(e)
    local player = entity.get_local_player()

    if player == nil or not player:is_alive() then 
        return 
    end

    e.spread = e.spread ~= nil and e.spread or 0.1

    local elements = ui_handler.elements["features"]["aimbot_elements"]

    if e.state == nil then
        if ui_handler.elements["features"]["aimbot_logs"] then
            if elements["Under Crosshair"] then
                table.insert(aimbot_logger.data, {
                    text = {
                        e.target:is_alive() and "Killed " or "Hurt ",
                        e.target:get_name(),
                        " in the ",
                        aimbot_logger.hitboxes[e.hitgroup+1],
                        " for ",
                        tostring(e.damage),
                        e.target:is_alive() and " damage (" or " (",
                        e.target:is_alive() and tostring(math.max(0, e.target.m_iHealth)) or "dead",
                        e.target:is_alive() and " hp remaining)" or ")"
                    }, 
                    time = globals.realtime+3, 
                    color = ui_handler.elements["features"]["hit_color"]
                })
            end
            if elements["On Screen"] then
                print_dev(f("Registered %s shot in %s\"s %s for %s damage [angle: %.2f° | hitchance: %s%% | history(Δ): %s | flags: %s%s%s | dmg: %s | wanted_hitgroup: %s]",
                
                aimbot_logger.num_format((e.id % 15) + 1), e.target:get_name(), aimbot_logger.hitboxes[e.hitgroup+1], e.damage, e.spread, e.hitchance, e.backtrack, 
                (neverlose_refs.doubletap:get() and 1 or 0), (neverlose_refs.prefer_safety:get() == "Force" and 1 or 0), (e.spread <= 0.1 and 1 or 0), e.wanted_damage, aimbot_logger.hitboxes[e.wanted_hitgroup+1]))


            end
            if elements["In Console"] then
                print(f("Registered %s shot in %s\"s %s for %s damage [angle: %.2f° | hitchance: %s%% | history(Δ): %s | flags: %s%s%s | dmg: %s | wanted_hitgroup: %s]",
                
                aimbot_logger.num_format((e.id % 15) + 1), e.target:get_name(), aimbot_logger.hitboxes[e.hitgroup+1], e.damage, e.spread, e.hitchance, e.backtrack, 
                (neverlose_refs.doubletap:get() and 1 or 0), (neverlose_refs.prefer_safety:get() == "Force" and 1 or 0), (e.spread <= 0.1 and 1 or 0), e.wanted_damage, aimbot_logger.hitboxes[e.wanted_hitgroup+1]))
            end
        end
    else
        if ui_handler.elements["features"]["aimbot_logs"] then
            if elements["Under Crosshair"] then

                table.insert(aimbot_logger.data, {
                    text = {
                        "Missed ",
                        e.target:get_name(),
                        " in the ",
                        aimbot_logger.hitboxes[e.wanted_hitgroup+1],
                        " due to ",
                        e.state,
                        "",
                        "",
                        ""
                    }, 
                    time = globals.realtime+3, 
                    color = ui_handler.elements["features"]["miss_color"]
                })
            end
            if elements["On Screen"] then
                print_dev(f(
                    "Missed %s shot at %s\"s %s(%s%%) due to %s [dmg: %s | safety: %s | history(Δ): %s | flags: %s%s%s]",
                    aimbot_logger.num_format((e.id % 15) + 1), e.target:get_name(), aimbot_logger.hitboxes[e.wanted_hitgroup+1], e.hitchance, e.state, e.wanted_damage, (neverlose_refs.prefer_safety:get() == "Prefer" and 1 or 0), e.backtrack,
                    (neverlose_refs.doubletap:get() and 1 or 0), (neverlose_refs.prefer_safety:get() == "Force" and 1 or 0), (e.spread <= 0.1 and 1 or 0)
                ))
            end
            if elements["In Console"] then
                print(f(
                    "Missed %s shot at %s\"s %s(%s%%) due to %s [dmg: %s | safety: %s | history(Δ): %s | flags: %s%s%s]",
                    aimbot_logger.num_format((e.id % 15) + 1), e.target:get_name(), aimbot_logger.hitboxes[e.wanted_hitgroup+1], e.hitchance, e.state, e.wanted_damage, (neverlose_refs.prefer_safety:get() == "Prefer" and 1 or 0), e.backtrack,
                    (neverlose_refs.doubletap:get() and 1 or 0), (neverlose_refs.prefer_safety:get() == "Force" and 1 or 0), (e.spread <= 0.1 and 1 or 0)
                ))
            end
        end
    end
end

menu.switch(ui_handler.tab.features.interface, "Enable Aimbot Logger")("features", "aimbot_logs", true)(function(group)
    menu.selectable(group, "Screen elements", "Under Crosshair", "On Screen", "In Console")("features", "aimbot_elements", true, function() return ui_handler.elements["features"]["aimbot_logs"] end)


    menu.color_picker(group, "Hit Color")("features", "hit_color", true, function() return ui_handler.elements["features"]["aimbot_logs"] and ui_handler.elements["features"]["aimbot_elements"]["Under Crosshair"] end)
    menu.color_picker(group, "Miss Color")("features", "miss_color", true, function() return ui_handler.elements["features"]["aimbot_logs"] and ui_handler.elements["features"]["aimbot_elements"]["Under Crosshair"] end)
end)


skeet_indication.c4_info = {
    planting = false,
    on_plant_time = 0,
    fill = 0, 
    planting_site = "",
    bomb_image = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(30, 30))
}
skeet_indication.font = render.load_font("Calibri", 23, "bda")

render.indicator = function(str, ax, ay, clr, circle_clr, circle_degree)
    local x, y = 5 + ax, defines.screen_size.y/1.41 + (ay*(render.measure_text(skeet_indication.font, "s", str).y/render.measure_text(skeet_indication.font, nil, str).y))

    ts = render.measure_text(skeet_indication.font, "s", str) + vector(ax + 40, 0)
    render.gradient(vector(x, y), vector(x + (ts.x) / 2, y + ts.y + 6), color(0, 0, 0, 0), color(0, 0, 0, 55), color(0, 0, 0, 0), color(0, 0, 0, 55))
    render.gradient(vector(x + (ts.x) / 2, y), vector(x + (ts.x), y + ts.y + 6), color(0, 0, 0, 55), color(0, 0, 0, 0), color(0, 0, 0, 55), color(0, 0, 0, 0))
    render.text(skeet_indication.font, vector(x + 20, y + 4), clr, "s", str)

    if circle_clr and circle_degree then
        ts = render.measure_text(skeet_indication.font, "s", str)
        render.circle_outline(vector(x + ts.x + 25, y + ts.y/2+2), color(0, 0, 0, 255), 10.5, 90, 1, 4)
        render.circle_outline(vector(x + ts.x + 25, y + ts.y/2+2), circle_clr, 10, 90, circle_degree, 3)
    end
end

skeet_indication.bomb_image = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(30, 30))
skeet_indication.handle = function()
    if not ui_handler.elements["features"]["skeet_indications"] then
        return
    end

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
            local defusestart = c4.m_hBombDefuser ~= nil
            local defuselength = c4.m_flDefuseLength
            local defusetimer = defusestart and (c4.m_flDefuseCountDown - globals.curtime) or -1
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

    if skeet_indication.c4_info.planting then
        skeet_indication.c4_info.fill = 3.125 - (3.125 + skeet_indication.c4_info.on_plant_time - globals.curtime)
        if(skeet_indication.c4_info.fill > 3.125) then
            skeet_indication.c4_info.fill = 3.125
        end
    end

    local additional = ui_handler.refs["features"]["skeet_select"].ref
    local add_y = 0

    local ping = player:get_resource().m_iPing
    local delta = (math.abs(ping % 360)) / (neverlose_refs.fake_latency:get() / 2)
    if delta > 1 then delta = 1 end

    local ping_color = color(255 - (125 * delta), 200 * delta, 0)

    local dormant_work = #entity.get_players(true, false) ~= #entity.get_players(true, true)

    local binds = {
        {"PING",              additional:get("Fake Latency") and neverlose_refs.fake_latency:get() > 0 and player:is_alive(), ping_color},
        {"DT",                additional:get("Double Tap") and neverlose_refs.doubletap:get(), rage.exploit:get() == 1 and color(255, 200) or color(255, 0, 0, 255)},
        {"OSAA",              additional:get("Hide Shots") and neverlose_refs.hideshots:get(), color(255, 200)},
        {"DUCK",              additional:get("Fake Duck") and neverlose_refs.fake_duck:get(), color(255, 200)},
        {"DA",                additional:get("Dormant Aimbot") and neverlose_refs.dormant:get(), dormant_work and color(255, 200) or color(255, 0, 0, 255)},
        {"SAFE",              additional:get("Safe Points") and neverlose_refs.prefer_safety:get() == "Force", color(255, 200)},
        {"BODY",              additional:get("Body Aim") and neverlose_refs.prefer_body:get() == "Force", color(255, 200)},
        {"MD",                additional:get("Min. Damage") and defines.get_bind("Min. Damage")[1], color(255, 200)},
        {"FS",                additional:get("Freestanding") and ui_handler.elements["aa"]["freestanding"], color(255, 200)},
        {"-" .. dmg .. " HP", additional:get("Bomb Information") and player:is_alive() and not willKill and damage > 0.5, color(210, 216, 112, 255)},
        {"FATAL",             additional:get("Bomb Information") and player:is_alive() and willKill, color(255, 0, 0, 255)},
        {"bombsite2",         additional:get("Bomb Information") and skeet_indication.c4_info.planting, color(210, 216, 112, 255), color(255, 255), skeet_indication.c4_info.fill/3.3},
        {"bombsite1",         additional:get("Bomb Information") and timer > 0 and not defused, color(255, 200)},
        {"HITBOX OVR",        additional:get("Hitboxes Override") and defines.get_bind("Hitboxes")[1], color(255, 200)},
        {"HITCHANCE OVR",     additional:get("Hit Chance Override") and defines.get_bind("Hit Chance")[1], color(255, 200)}
    }

    local text = ""
    local x, y = defines.screen_size.x/100 + 2, defines.screen_size.y/1.41
    for k, v in pairs(binds) do
        if v[1] == "bombsite1" then
            text = bombsite.." - " .. f("%.1f", timer) .. "s"
        elseif v[1] == "bombsite2" then
            text = skeet_indication.c4_info.planting_site
        else
            text = v[1]
        end

        local is_bomsite = (v[1] == "bombsite1" or v[1] == "bombsite2") and v[2]

        if is_bomsite then
            render.texture(skeet_indication.bomb_image, vector(x, y + add_y), vector(30, 30), v[3])
        end

        if v[2] then
            render.indicator(text, is_bomsite and 35 or 0, add_y, v[3], v[4], v[5])
            add_y = add_y - 37
        end
    end
end

skeet_indication.c4_info_reset = function()    
    skeet_indication.c4_info.planting = false
    skeet_indication.c4_info.fill = 0
    skeet_indication.c4_info.on_plant_time = 0
    skeet_indication.c4_info.planting_site = ""
end

skeet_indication.c4_info_bomb_beginplant = function(e)
    local player_resource = entity.get_player_resource()

    if player_resource == nil then
        return
    end

    skeet_indication.c4_info.on_plant_time = globals.curtime
    skeet_indication.c4_info.planting = true

    local m_bombsiteCenterA = player_resource.m_bombsiteCenterA
    local m_bombsiteCenterB = player_resource.m_bombsiteCenterB
    
    local userid = entity.get(e.userid, true)
    local userid_origin = userid:get_origin()
    local dist_to_a = userid_origin:dist(m_bombsiteCenterA)
    local dist_to_b = userid_origin:dist(m_bombsiteCenterB)
    
    skeet_indication.c4_info.planting_site = dist_to_a < dist_to_b and "A" or "B"
end

menu.switch(ui_handler.tab.features.interface, "Enable " .. defines.colored_text({"G", color(255)}, {"S", color(173, 255, 47)}, {" Indication"}))("features", "skeet_indications", true)(function(group)
    menu.selectable(group, "Elements", {"Hit Chance Override", "Hitboxes Override", "Dormant Aimbot", "Fake Latency", "Fake Duck", "Body Aim", "Safe Points", "Min. Damage", "Freestanding", "Bomb Information", "Double Tap", "Hide Shots"})("features", "skeet_select")
end)
            
console_color.material = {
    "vgui_white", 
    "vgui/hud/800corner1", 
    "vgui/hud/800corner2", 
    "vgui/hud/800corner3", 
    "vgui/hud/800corner4"
}

console_color.last = color(0, 0, 0, 255)
console_color.change = function(clr)
    if console_color.last ~= clr then
        for _, mat in pairs(console_color.material) do
            materials.get_materials(mat)[1]:color_modulate(color(clr.r, clr.g, clr.b))
            materials.get_materials(mat)[1]:alpha_modulate(clr.a/255)
        end
        console_color.last = clr
    end
end

console_color.handle = function()

    local clr = (ui_handler.elements["features"]["console_color_changer"] and ffi_handler.console_is_visible()) and ui_handler.elements["features"]["console_color_changer_color"] or colors.white
    console_color.change(clr)
end

menu.switch(ui_handler.tab.features.interface, "Enable Console Customization")("features", "console_color_changer", true)(function(group)
    menu.color_picker(group, "Accent Color", color(255, 255, 255, 255))("features", "console_color_changer_color", true, function()
        return ui_handler.elements["features"]["console_color_changer"]
    end)
end)


air_modifications.handle = function(cmd)
    local player = entity.get_local_player()
    if player == nil or not player:is_alive() then
        return
    end
    if not ui_handler.elements["features"]["force_defensive"] then
        return
    end
    local in_air = conditional_antiaims.player_state == conditional_antiaims.states.air or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch

    local dt_settings = ui_handler.elements["features"]["dt_settings"]
    local hs_settings = ui_handler.elements["features"]["hs_settings"]

    if in_air and neverlose_refs.doubletap:get() then
        neverlose_refs.doubletap_config:override(dt_settings)
    end
end

menu.switch(ui_handler.tab.features.additional, "Force Defensive In Air")("features", "force_defensive", true)(function(group)
    menu.combo(group, "Exploit Preset", "Disabled", "On Peek", "Always On")("features", "dt_settings", true, function() return ui_handler.elements["features"]["force_defensive"] end)
end)

discharge_dt.weapons_names = {"AWP", "SSG-08", "AutoSnipers", "Heavy Pistols", "Pistols", "Rifle", "SMG", "ShotGun", "Nades", "Taser", "Knife"}
discharge_dt.weapons_id = {
    ["AWP"] = {9}, 
    ["SSG-08"] = {40}, 
    ["AutoSnipers"] = {11, 38}, 
    ["Heavy Pistols"] = {1, 64}, 
    ["Pistols"] = {2, 3, 4, 30, 32, 36, 61, 63}, 
    ["Rifle"] = {7, 8, 10, 13, 16, 39, 60}, 
    ["SMG"] = {17, 19, 23, 24, 33, 34}, 
    ["ShotGun"] = {25, 27, 29, 35}, 
    ["Nades"] = {43, 44, 45, 46, 47, 48}, 
    ["Taser"] = {31}, 
    ["Knife"] = {41, 42, 59, 500, 503, 505, 506, 507, 508, 509, 512, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 525}
}

discharge_dt.work = false
discharge_dt.teleported = false
discharge_dt.handle = function()
    if not ui_handler.elements["features"]["discharge_dt"] then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local weapon = player:get_player_weapon()

    if weapon == nil then
        return
    end

    local weapon_id = weapon:get_weapon_index()

    if weapon_id == nil then
        return
    end

    local players = entity.get_players(true)

    if players == nil or #players == 0 then
        return
    end

    local can_hit = function(entity)
        local damage, trace = utils.trace_bullet(entity, entity:get_hitbox_position(3), player:get_hitbox_position(3))
    
        if damage > 0 then
            if trace.entity and trace.entity == player then
                return true
            end
        end
    
        return false
    end

    local in_air = conditional_antiaims.player_state == conditional_antiaims.states.air or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch

    local allow_teleport = false
    for k, v in pairs(discharge_dt.weapons_id) do
        if ui_handler.elements["features"]["discharge_dt_weapons"][k] then
            for i = 1, #v do
                if v[i] == weapon_id then
                    allow_teleport = true
                else
                    discharge_dt.teleported = false 
                end
            end
        end
    end

    local teleport_ready = false

    if allow_teleport then
        for k, enemy in pairs(players) do
            if enemy == local_player then
                return
            end

            if can_hit(enemy) then
                teleport_ready = true
            else
                discharge_dt.teleported = false
            end
        end
    end

    discharge_dt.work = false

    if neverlose_refs.doubletap:get() and in_air then
        discharge_dt.work = true
        if teleport_ready and not discharge_dt.teleported then
            rage.exploit:force_teleport()
            discharge_dt.teleported = true
        end
    end
end

menu.switch(ui_handler.tab.features.additional, "Discharge Exploit In Air")("features", "discharge_dt", true)(function(group)
    menu.selectable(group, "Weapons", discharge_dt.weapons_names)("features", "discharge_dt_weapons", true, function()
        return ui_handler.elements["features"]["discharge_dt"]
    end)
end)

unmute_silenced.toggle_mute = panorama.FriendsListAPI.ToggleMute
unmute_silenced.is_muted = panorama.FriendsListAPI.IsSelectedPlayerMuted


unmute_silenced.handle = function()
    if not ui_handler.elements["features"]["mute_everyone"] then
        return
    end

    local combo_status = ui_handler.elements["features"]["mute_everyone_settings"]

    local players = entity.get_players(ui_handler.elements["features"]["mute_enemy"], true, function(player)
        local info = player:get_player_info()
        local steamid64 = info.steamid64
        local is_muted = unmute_silenced.is_muted(steamid64)

        if is_muted then
            unmute_silenced.toggle_mute(steamid64)
        end
    end)
end

menu.switch(ui_handler.tab.features.additional, "Unmute Silenced Players")("features", "mute_everyone", true)(function(group)
    menu.switch(group, "Only Enemies")("features", "mute_enemy", true, function() return ui_handler.elements["features"]["mute_everyone"] end)():set_callback(unmute_silenced.handle)
end):set_callback(unmute_silenced.handle)


taskbar_notify.get_csgo_hwnd = function()
    return ffi_handler.hwnd_ptr[0]
end

taskbar_notify.get_foreground_hwnd = function()
    return ffi_handler.insn_jmp_ecx(ffi_handler.GetForegroundWindow)
end

taskbar_notify.notify_user = function()
    local csgo_hwnd = taskbar_notify.get_csgo_hwnd()
    if ui_handler.elements["features"]["icon_notification"] and taskbar_notify.get_foreground_hwnd() ~= csgo_hwnd then
        ffi_handler.flash_window(csgo_hwnd, 1)
    end
end

events.round_start:set(function()
    taskbar_notify.notify_user()
end)

menu.switch(ui_handler.tab.features.additional, "Icon Flash On Round Start")("features", "icon_notification", true)

revolver_helper.distance = safecall("revolver_helper", true, function(player, victim)
    if player == nil then
        return nil
    end

    if victim == nil then
        return nil
    end

    local wpn = player:get_player_weapon()

    if wpn == nil then
        return nil
    end

    local wpn_id = wpn:get_weapon_index()

    if wpn_id == nil then
        return nil
    end

    local player_origin = player:get_origin()
    local victim_origin = victim:get_origin()

    local units = player_origin:dist(victim_origin)
    local no_kevlar = victim.m_ArmorValue == 0

    if not (wpn_id == 64 and no_kevlar) then
        return 0 
    end

    if units < 585 and units > 511 then
        return 1
    elseif units < 511 then
        return 2
    else
        return 0
    end
end)

esp.enemy:new_text("Revolver Helper", "DMG+", safecall("revolver_helper", true, function(enemy)
    if not ui_handler.elements["features"]["revolver_helper"] then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local trace = revolver_helper.distance(player, enemy)

    if trace == nil or trace == 0 then
        return
    end

    if trace == 1 then
        return defines.colored_text({"DMG", color(255, 0, 0)})
    else
        return defines.colored_text({"DMG+", color(50, 205, 50)})
    end
end))

menu.switch(ui_handler.tab.features.interface, "Enable R8 Helper")("features", "revolver_helper", true)
grenade_radius.get = function()
    local player = entity.get_local_player()
    
    if player == nil then
        return
    end

    local CSmokeGrenadeProjectile = entity.get_entities("CSmokeGrenadeProjectile")
    local CInferno = entity.get_entities("CInferno")
    local is_not_friendly_fire = cvar.mp_friendlyfire:int() == 0

    local smoke = {}
    local molotov = {}

    local tickcount = globals.tickcount
    local tickinterval = globals.tickinterval

    if CSmokeGrenadeProjectile ~= nil then
        for k, v in pairs(CSmokeGrenadeProjectile) do
            if smoke[k] == nil then
                smoke[k] = {}
                smoke[k].position = vector(0, 0, 0)
                smoke[k].alpha = 0
                smoke[k].draw = false
            end

            smoke[k].position = v:get_origin()
            smoke[k].alpha = v:get_bbox().alpha*255

            if v.m_bDidSmokeEffect and v:get_bbox().alpha > 0 then
                smoke[k].draw = true
            end
        end
    end

    if CInferno ~= nil then
        for k, v in pairs(CInferno) do
            if molotov[k] == nil then
                molotov[k] = {}
                molotov[k].position = vector(0, 0, 0)
                molotov[k].alpha = 0
                molotov[k].draw = false
                molotov[k].teammate = false
            end

            local percentage = (7.125 -  tickinterval * (tickcount - v.m_nFireEffectTickBegin))/7.125
            molotov[k].position = v:get_origin()
            molotov[k].alpha = percentage*255

            local m_hOwnerEntity = v.m_hOwnerEntity

            if m_hOwnerEntity ~= nil and is_not_friendly_fire and m_hOwnerEntity ~= player and not m_hOwnerEntity:is_enemy() then
                molotov[k].teammate = true
            end

            local cells = {}
            local highest_distance = 100
            for i = 1, 64 do
                if v.m_bFireIsBurning[i] then
                    table.insert(cells, {v.m_fireXDelta[i], v.m_fireYDelta[i], v.m_fireZDelta[i]})
                end
            end

            for i = 1, #cells do
                local cell = cells[i]
                local x_delta, y_delta, z_delta = unpack(cell)

                for i2 = 1, #cells do
                    local cell2 = cells[i2]
                    local distance = vector(x_delta, y_delta):dist(vector(cell2[1], cell2[2]))
                    if distance > highest_distance then
                        highest_distance = distance
                    end
                end
            end

            if percentage > 0 then
                molotov[k].draw = true
                molotov[k].radius = highest_distance/2 + 40
            end
        end
    end

    return {smoke = smoke, molotov = molotov}
end

for i = 1, 15 do
    grenade_radius[i] = {
        molotov_radius = smoothy.new(0),
        smoke_radius = smoothy.new(0)
    }
end
grenade_radius.handle = function()
    if not ui_handler.elements["features"]["grenade_radius"] or ui_handler.elements["features"]["grenade_radius_elements"]._len == 0 then
        return
    end

    local grenade_radius_style = ui_handler.elements["features"]["grenade_radius_style"]

    local molotov_enabled = ui_handler.elements["features"]["grenade_radius_elements"]["Molotov"]
    local smoke_enabled   = ui_handler.elements["features"]["grenade_radius_elements"]["Smoke"]

    if not molotov_enabled and not smoke_enabled then
        return
    end

    local grenade = grenade_radius.get()
    
    if grenade == nil then
        return
    end

    local enemy_molotov_color = ui_handler.elements["features"]["grenade_radius_enemy_molotov_color"]
    local team_molotov_color = ui_handler.elements["features"]["grenade_radius_team_molotov_color"]
    local smoke_color = ui_handler.elements["features"]["grenade_radius_smoke_color"]

    local anim = {}

    for i = 1, #grenade.molotov do
        local v = grenade.molotov[i]
        anim.molotov_radius = grenade_radius[i].molotov_radius(.05, v.draw)

        if v.draw and molotov_enabled then
            local clr = v.teammate and team_molotov_color or enemy_molotov_color
            render.text(1, render.world_to_screen(v.position), (v.teammate and color(149, 184, 6, 255) or color(230, 21, 21, 255)):override("a", anim.molotov_radius*255), nil, v.teammate and "✔" or "❌")
            render.circle_3d_outline(v.position, clr:override("a", clr.a*v.alpha), anim.molotov_radius*125, 0, 1, 1.5)
            
        end
    end

    local magic_alpha_smoke = smoke_color.a / 255
    local smoke_zero_alpha = smoke_color:override("a", 0)

    for i = 1, #grenade.smoke do
        local v = grenade.smoke[i]

        anim.smoke_radius = grenade_radius[i].smoke_radius(.05, v.draw)

        if v.draw and smoke_enabled then

            render.text(1, render.world_to_screen(v.position), (v.teammate and color(149, 184, 6, 255) or color(230, 21, 21, 255)):override("a", 255), nil, v.teammate and "✔" or "❌")
            render.circle_3d_outline(v.position, smoke_color:override("a",  magic_alpha_smoke * v.alpha), anim.smoke_radius*125, 0, 1, 1.5)
        end
    end
end


menu.switch(ui_handler.tab.features.interface, "Enable Grenade Radius")("features", "grenade_radius", true)(function(group)
    menu.selectable(group, "Grenades", {"Molotov", "Smoke"})("features", "grenade_radius_elements", true, function()
        return ui_handler.elements["features"]["grenade_radius"]
    end)
    menu.color_picker(group, "Enemy Molotov Color", color(245, 90, 90, 255))("features", "grenade_radius_enemy_molotov_color", true, function()
        return ui_handler.elements["features"]["grenade_radius"] and ui_handler.elements["features"]["grenade_radius_elements"]["Molotov"]
    end)

    menu.color_picker(group, "Team Molotov Color", color(90, 245, 90, 255))("features", "grenade_radius_team_molotov_color", true, function()
        return ui_handler.elements["features"]["grenade_radius"] and ui_handler.elements["features"]["grenade_radius_elements"]["Molotov"]
    end)

    menu.color_picker(group, "Smoke Color", color(130, 130, 255, 255))("features", "grenade_radius_smoke_color", true, function()
        return ui_handler.elements["features"]["grenade_radius"] and ui_handler.elements["features"]["grenade_radius_elements"]["Smoke"]
    end)
end)

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
            material:var_flag(28, ui_handler.elements["features"]["molotov_wireframe"] and ui_handler.elements["features"]["molotovwireframe"])
            material:var_flag(15, ui_handler.elements["features"]["molotov_wireframe"] and ui_handler.elements["features"]["molotov_ignore_z"])
        end
    end
end

menu.switch(ui_handler.tab.features.additional, "Molotov Wireframe")("features", "molotov_wireframe", true)(function(group)
    menu.switch(group, "Wireframe")("features", "molotovwireframe")
    menu.switch(group, "Ignore Z")("features", "molotov_ignore_z", true)
end)

fall_damage.trace = function(length)
    local player = entity.get_local_player()
            
    if player == nil or not player:is_alive() then
        return
    end
    local x, y, z = player.m_vecOrigin.x, player.m_vecOrigin.y, player.m_vecOrigin.z
    local max_radias = math.pi * 2
    local step = max_radias / 8

    for a = 0, max_radias, step do
        local ptX, ptY = ((10 * math.cos( a ) ) + x), ((10 * math.sin( a ) ) + y)
        local trace = utils.trace_line(vector(ptX, ptY, z), vector(ptX, ptY, z-length), player)
        local fraction, entity = trace.fraction, trace.entity

        if fraction~=1 then 
            return true
        end
    end
    return false
end
fall_damage.handle = function(cmd)
    if not ui_handler.elements["features"]["fall_damage"] then 
        return 
    end

    local player = entity.get_local_player()
    if player == nil or not player:is_alive() then 
        return 
    end

    if player.m_vecVelocity.z >= -500 then
        no_fall_damage = false
    else
        if fall_damage.trace(15) then
            no_fall_damage = false
        elseif fall_damage.trace(75) then
            no_fall_damage = true
        end
    end

    if player.m_vecVelocity.z < -500 then
        if no_fall_damage then
            cmd.in_duck = 1
        else
            cmd.in_duck = 0
        end
    end
end

menu.switch(ui_handler.tab.features.additional, "No Fall Self Damage")("features", "fall_damage", true)

aspect_ratio_changer.set_aspect_ratio = function(aspect_ratio_multiplier)
    local screen_width, screen_height = defines.screen_size.x, defines.screen_size.y
	local aspectratio_value = (screen_width*aspect_ratio_multiplier)/screen_height

	if aspect_ratio_multiplier == 1 then
		aspectratio_value = 0
	end
	cvar.r_aspectratio:float(tonumber(aspectratio_value))
end

aspect_ratio_changer.screen_width = 0
aspect_ratio_changer.screen_height = 0

aspect_ratio_changer.multiplier = 0.01
aspect_ratio_changer.steps = 200

aspect_ratio_changer.on_change = function()
    local aspect_ratio = ui_handler.elements["features"]["aspect_ratio"]*0.01
    aspect_ratio = 2 - aspect_ratio
    aspect_ratio_changer.set_aspect_ratio(aspect_ratio)
end

aspect_ratio_changer.gcd = function(m, n)
    while m ~= 0 do
        m, n = math.fmod(n, m), m
    end

    return n
end

aspect_ratio_changer.table = {}
aspect_ratio_changer.tooltip = aspect_ratio_changer.table == nil and "%" or function(val) if aspect_ratio_changer.table[val] ~= nil then return aspect_ratio_changer.table[val] else return val.."%" end end
aspect_ratio_changer.setup = function(screen_width_temp, screen_height_temp)
    aspect_ratio_changer.screen_width, aspect_ratio_changer.screen_height = screen_width_temp, screen_height_temp

    for i=1, aspect_ratio_changer.steps do
        local i2=(aspect_ratio_changer.steps-i)*aspect_ratio_changer.multiplier
        local divisor = aspect_ratio_changer.gcd(aspect_ratio_changer.screen_width*i2, aspect_ratio_changer.screen_height)
        if aspect_ratio_changer.screen_width*i2/divisor < 100 or i2 == 1 then
            aspect_ratio_changer.table[i] = aspect_ratio_changer.screen_width*i2/divisor .. ":" .. aspect_ratio_changer.screen_height/divisor
        end
    end

    local reference = ui_handler.refs["features"]["aspect_ratio"].ref

    reference:set_callback(aspect_ratio_changer.on_change)
end


menu.slider(ui_handler.tab.features.additional, "Force Aspect Ratio", 0, aspect_ratio_changer.steps-1, aspect_ratio_changer.steps/2, 1, aspect_ratio_changer.tooltip)("features", "aspect_ratio")


aspect_ratio_changer.on_paint = function(ctx)
	local screen_width_temp, screen_height_temp = defines.screen_size.x, defines.screen_size.y
	if screen_width_temp ~= aspect_ratio_changer.screen_width or screen_height_temp ~= aspect_ratio_changer.screen_height then
		aspect_ratio_changer.setup(screen_width_temp, screen_height_temp)
	end
end

viewmodel_changer.handle = function()
    if ui_handler.elements["features"]["viewmodel"] then
        local fov = ui_handler.elements["features"]["viewmodel_fov"]
        local x = ui_handler.elements["features"]["viewmodel_x"]
        local y = ui_handler.elements["features"]["viewmodel_y"]
        local z = ui_handler.elements["features"]["viewmodel_z"]

        cvar.viewmodel_fov:int(fov, true)
        cvar.viewmodel_offset_x:int(x, true)
        cvar.viewmodel_offset_y:int(y, true)
        cvar.viewmodel_offset_z:int(z, true)
    end
end

menu.switch(ui_handler.tab.features.additional, "Custom Viewmodel")("features", "viewmodel")(function(group)
    menu.slider(group, "FOV", -100, 100, 0)("features", "viewmodel_fov")
    menu.slider(group, "Offset X", -100, 100, 0)("features", "viewmodel_x")
    menu.slider(group, "Offset Y", -100, 100, 0)("features", "viewmodel_y")
    menu.slider(group, "Offset Z", -100, 100, 0)("features", "viewmodel_z")
end)



callbacks.register("bomb_abortplant", "c4_info", skeet_indication.c4_info_reset)
callbacks.register("bomb_defused", "c4_info", skeet_indication.c4_info_reset)
callbacks.register("bomb_planted", "c4_info", skeet_indication.c4_info_reset)
callbacks.register("round_prestart", "c4_info", skeet_indication.c4_info_reset)
callbacks.register("bomb_beginplant", "c4_info", skeet_indication.c4_info_bomb_beginplant)

callbacks.register("createmove", "conditional_antiaims.update_player_state", conditional_antiaims.update_player_state)

callbacks.register("createmove", "conditional_antiaims.handle", conditional_antiaims.handle)
callbacks.register("createmove", "conditional_antiaims.dynamic_mode", conditional_antiaims.dynamic_mode)

callbacks.register("createmove", "fast_ladder.handle", fast_ladder.handle)
callbacks.register("createmove", "discharge_dt.handle", discharge_dt.handle)
callbacks.register("createmove", "air_modifications.handle", air_modifications.handle)
callbacks.register("createmove", "model_breaker", model_breaker.handle)
callbacks.register("createmove", "fall_damage.handle", fall_damage.handle)
callbacks.register("createmove", "neverlose_refs.reverse", function()
    local tick = globals.tickcount

    if tick == neverlose_refs.last_update then
        return
    end

    neverlose_refs.last_update = tick
    neverlose_refs.deoverride_unused()

end)

callbacks.register("render", "watermark.handle", watermark.handle)

presets.new_db = db.init or { }
callbacks.register("render", "config_system.init_db", function() 
    local ps = ui_handler.refs["general"]["preset_list"].ref
    local tbl = {}
    local db = presets.db

    for slot4, slot5 in pairs(db) do
        tbl[#tbl + 1] = slot4
    end

    table.sort(tbl)

    uv1 = tbl

    if #tbl == 0 then
        ps:update({
            " B0B0B0FFNothing there. Create preset or import it."
        })
    else
        tbl = {}

        for k, v in pairs(db) do
            tbl[k] = k
        end

        ps:update(tbl)
    end
end)
callbacks.register("render", "indicators.handle", indicators.handle)
callbacks.register("render", "scope_overlay.handle", scope_overlay.handle)
callbacks.register("render", "skeet_indication.handle", skeet_indication.handle)
callbacks.register("render", "velocity_warning.handle", velocity_warning.handle)
callbacks.register("render", "grenade_radius.handle", grenade_radius.handle)
callbacks.register("render", "manual_arrows.handle", manual_arrows.handle)
callbacks.register("render", "molotov_wireframe.handle", molotov_wireframe.handle)
callbacks.register("render", "aimbot_logger.render", aimbot_logger.render)
callbacks.register("render", "console_color.handle", console_color.handle)

callbacks.register("render", "aspect_ratio_changer.on_paint", aspect_ratio_changer.on_paint)
callbacks.register("render", "viewmodel_changer.handle", viewmodel_changer.handle)

callbacks.register("aim_ack", "aimbot_logger.handle", aimbot_logger.handle)


callbacks.register("shutdown", "shutdown", function()
    neverlose_refs.deoverride_unused(true)

    db["times_loaded"] = loads;
    db["kills"] = kills;
    db["hits"] = hits;
    db["misses"] = misses;
    db["error_time"] = errors

    db.benzo_preset = presets.currently_using
    db.benzo_manager = presets.db
    db.init = presets.new_db

end)

sidebar.handle = function()
    
    if ui.get_alpha() < 1 then 
        return 
    end

    local sidebar_text = gradient.text_animate("benzo." .. defines.build, 2, {
        ui.get_style()["Link Active"], 
        color(187, 196, 255)
    })
    ui.sidebar(sidebar_text:get_animated_text(), "wifi")

    sidebar_text:animate()
end

callbacks.register("render", "sidebar.handle", sidebar.handle)

ui_handler.global_update_callback()