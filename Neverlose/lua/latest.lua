-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- #region : Library

local pui = require "neverlose/pui"
local clipboard = require "neverlose/clipboard"
local base64 = require "neverlose/base64"
local gradient = require "neverlose/gradient"
local smoothy = require "neverlose/smoothy"
local bomb = require "neverlose/bomb"

-- #endregion

-- #region : Ffi

ffi.cdef[[
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);

    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef struct {
        char  pad_0000[20];
        int m_nOrder;
        int m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        float m_flWeightDeltaRate;
        float m_flPlaybackRate;
        float m_flCycle;
        void *m_pOwner;
        char  pad_0038[4];
    } animstate_layer_t;
]]

local uintptr_t = ffi.typeof("uintptr_t**")
local get_entity_address = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local animslsg = nil

-- #endregion

-- #region : Files shit

files.create_folder("nl\\Invincible")

local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet' 
local File = function(from, to)
    wininet.DeleteUrlCacheEntryA(from)
    urlmon.URLDownloadToFileA(nil, from, to, 0,0)
end

File("https://github.com/shetyx1338/gaffdafdsa/raw/main/object.ttf", "nl\\Invincible\\PP-Object-Sans.ttf")

-- #endregion

-- #region : Sidebar

events.render:set(function()
    local animated_gradient = gradient.text_animate("I N V I N C I B L E", -2, { ui.get_style("Link Active"), color(50) })
    pui.sidebar(animated_gradient:get_animated_text(), "trophy")
    animated_gradient:animate()
end)

-- #endregion

-- #region : Animation handler | Lerp

function lerp(a, b, t)
    return a + (b - a) * t
end

math.max_lerp_low_fps = (1 / 45) * 100
math.lerp = function(start, end_pos, time)
    if start == end_pos then
        return end_pos
    end

    local frametime = globals.frametime * 170
    time = time * math.min(frametime, math.max_lerp_low_fps)

    local val = start + (end_pos - start) * globals.frametime * time

    if(math.abs(val - end_pos) < 0.01) then
        return end_pos
    end

    return val
end

local animations = {}
animations.base_speed = 0.095
animations._list = {}
animations.new = function(name, new_value, speed, init)
    speed = speed or animations.base_speed

    if animations._list[name] == nil then
        animations._list[name] = (init and init) or 0
    end

    animations._list[name] = math.lerp(animations._list[name], new_value, speed)
    
    return animations._list[name]
end

-- #endregion

-- #region : Window system

local window_system do
    window_system = { }

    local group = ui.create "Windows"
        :visibility(false)

    local list = { }

    local hovered_window = nil
    local foreground_window = nil

    local function extract(value)
        local ok, result = pcall(
            json.parse, value
        )

        return ok and result or nil
    end

    local function is_collided(point, a, b)
        return point.x >= a.x and point.x <= b.x
            and point.y >= a.y and point.y <= b.y
    end

    local ctx = { } do
        ctx.mouse_pos = vector()
        ctx.mouse_pos_prev = vector()

        ctx.mouse_down = false
        ctx.mouse_clicked = false

        ctx.mouse_down_duration = 0

        ctx.mouse_delta = vector()
        ctx.mouse_clicked_pos = vector()

        function ctx.update_mouse_inputs()
            local dt = globals.frametime

            local cursor = ui.get_mouse_position()
            local is_down = common.is_button_down(0x01)

            ctx.mouse_pos_prev = ctx.mouse_pos
            ctx.mouse_pos = cursor

            ctx.mouse_delta = ctx.mouse_pos - ctx.mouse_pos_prev

            ctx.mouse_down = is_down
            ctx.mouse_clicked = is_down and ctx.mouse_down_duration < 0

            ctx.mouse_down_duration = is_down and (ctx.mouse_down_duration < 0 and 0 or ctx.mouse_down_duration + dt) or -1

            if ctx.mouse_clicked then
                ctx.mouse_clicked_pos = ctx.mouse_pos
            end
        end
    end

    local Window = { } do
        Window.__index = Window

        function Window:__new(name, options)
            local item = group:value(name, "{ }")
            local item_data = extract(item:get())

            local initial_pos = vector(0, 0)
            local initial_size = vector(0, 0)
            local initial_anchor = vector(0, 0)

            if type(options) == "table" then
                if options.pos ~= nil then
                    initial_pos.x = options.pos.x or 0
                    initial_pos.y = options.pos.y or 0
                end

                if options.size ~= nil then
                    initial_size.x = options.size.x or 0
                    initial_size.y = options.size.y or 0
                end

                if options.anchor ~= nil then
                    initial_anchor.x = options.anchor.x or 0
                    initial_anchor.y = options.anchor.y or 0
                end
            end

            if item_data ~= nil then
                if item_data.pos ~= nil then
                    initial_pos.x = item_data.pos.x or 0
                    initial_pos.y = item_data.pos.y or 0
                end
            end

            local data = {
                item = item,
                name = name,

                pos = initial_pos,
                size = initial_size,
                anchor = initial_anchor,

                is_active = true,

                is_dragged = false,
                is_hovered = false,
            }

            table.insert(list, data)
            return setmetatable(data, self)
        end

        function Window:get_pos()
            return self.pos
        end

        function Window:get_size()
            return self.size
        end

        function Window:get_anchor()
            return self.anchor
        end

        function Window:set_pos(pos)
            local new_pos = pos:clone()

            if self.pos ~= new_pos then
                local saved_pos = vector(
                    new_pos.x + self.size.x * self.anchor.x,
                    new_pos.y + self.size.y * self.anchor.y
                )

                local data_to_save = {
                    pos = {
                        x = saved_pos.x,
                        y = saved_pos.y
                    }
                }

                self.item:set(json.stringify(data_to_save))
            end

            self.pos = new_pos
            return self
        end

        function Window:set_size(size)
            local delta = size - self.size
            local new_pos = self.pos - delta * self.anchor

            self.size = size
            self:set_pos(new_pos)

            return self
        end

        function Window:set_anchor(anchor)
            self.anchor = anchor
            return self
        end
    end

    local function find_hovered_window()
        local found_window = nil

        if ui.get_alpha() > 0 then
            for i = 1, #list do
                local window = list[i]

                local pos = window.pos
                local size = window.size

                if not window.is_active then
                    goto continue
                end

                if not is_collided(ctx.mouse_pos, pos, pos + size) then
                    goto continue
                end

                found_window = window
                ::continue::
            end
        end

        hovered_window = found_window
    end

    local function find_foreground_window()
        if not ctx.mouse_down then
            foreground_window = nil
            return
        end

        if ctx.mouse_clicked and hovered_window ~= nil then
            foreground_window = hovered_window
        end
    end

    local function update_all_windows()
        for i = 1, #list do
            local window = list[i]

            window.is_dragged = false
            window.is_hovered = false
        end
    end

    local function update_hovered_window()
        if hovered_window == nil then
            return
        end

        hovered_window.is_hovered = true
    end

    local function update_foreground_window()
        if foreground_window == nil then
            return
        end

        local new_position = foreground_window.pos + ctx.mouse_delta

        foreground_window:set_pos(new_position)
        foreground_window.is_dragged = true
    end

    local function on_render()
        ctx.update_mouse_inputs()

        find_hovered_window()
        find_foreground_window()

        update_all_windows()

        update_hovered_window()
        update_foreground_window()
    end

    local function on_createmove(cmd)
        local blocked = foreground_window ~= nil
            or hovered_window ~= nil

        if not blocked then
            return
        end

        cmd.in_attack = false
        cmd.in_attack2 = false
    end

    function window_system.new(name, options)
        return Window:__new(name, options)
    end

    events.render(on_render)
    events.createmove(on_createmove)
end

-- #endregion

-- #region : Get original convar

local function get_original(convar)
    return tonumber(convar:string())
end

-- #endregion

-- #region : Script info references

local invincible = { 
    script_info = { "Invincible", "Renewed" }, 
    neverlose_user = common.get_username(),
}

-- #endregion

-- #region : Menu references

local refs = {
    enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw =  ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    hidden_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    yaw_modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    body_yaw_inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    body_yaw_left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    body_yaw_right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    body_yaw_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    body_yaw_inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    body_yaw_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    freestanding_disable_yaw_modifiers = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    freestanding_body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    extended_angles = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
    extended_angles_pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"),
    extended_angles_roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll"),
    fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    legs_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    hide_shots_options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    clantag = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"),
    doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    hide_shots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    minimum_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
    body_aim = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Body Aim"),
    safe_points = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Safe Points"),
    fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
    weapon_actions = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"),
    field_of_view = ui.find("Visuals", "World", "Main", "Field of View"),
    override_zoom = ui.find("Visuals", "World", "Main", "Override Zoom"),
    filters = ui.find("Miscellaneous", "Main", "Other", "Filters"),
    ssg_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"),
    awp_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance"),
    autosnipers_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance")
}

-- #endregion

-- #region : Menu

local menu = { } do
    ZWSP = "\xE2\x80\x8A"

    function pad(count)
        return ZWSP:rep(count)
    end

    function pad_button(icon, name, count)
        return pad(count) .. "\v\f<" .. icon .. ">\r  " .. name .. pad(count)
    end

    function set_tab_callback(menu, options)
        menu:set_callback(function(self)
            local num = self:get()
            local name = {}
            for i, option in ipairs(options) do
                name[i] = (num == i and "\v" .. "\v•\r" .. '\aFFFFFFFF  ' or '') .. option
            end
            self:update(name)
        end)
    end

    tabs = { }
    tabs.labels = { "\f<house-night>", "\f<users-gear>", "\f<gears>" }
    tabs.home = { 
        Under_logo = pui.create(tabs.labels[1], "About", 1),
        logo = pui.create(tabs.labels[1], "Changelog", 1),
        Upper_logo = pui.create (tabs.labels[1], "Info", 1), 
        Under_logo2 = pui.create (tabs.labels[1], "\n\n\n", 1),
        section = pui.create(tabs.labels[1], "\n\n\n\n\n", 2), 
        under_section = pui.create(tabs.labels[1], "Config system", 2), 
        under_section2 = pui.create(tabs.labels[1], "\n\n\n\n\n\n", 2), 
    }
    
    tabs.antiaim = { 
        section = pui.create(tabs.labels[2], "\n", 1), 
        under_section = pui.create(tabs.labels[2], "Conditional", 1),
        under_section2 = pui.create(tabs.labels[2], "Addons", 1), 
        under_section3 = pui.create(tabs.labels[2], "Binds", 1), 
        under_section4 = pui.create(tabs.labels[2], "\n\n\n\n", 1), 
        upper2_builder = pui.create(tabs.labels[2], "\n\n\n\n\n", 2), 
        upper_builder = pui.create(tabs.labels[2], "Builder", 2), 
        builder = pui.create(tabs.labels[2], "\n\n\n\n\n\n\n", 2), 
        under_builder = pui.create(tabs.labels[2], "\n\n\n\n\n\n\n\n", 2), 
        under2_builder = pui.create(tabs.labels[2], "\n\n\n\n\n\n\n\n\n", 2), 
    }

    tabs.other = { 
        upper_visuals = pui.create(tabs.labels[3], "Color switcher", 2), 
        ragebot = pui.create(tabs.labels[3], "Ragebot", 1), 
        visuals = pui.create(tabs.labels[3], "Visuals", 2), 
        misc1 = pui.create(tabs.labels[3], "Misc", 1), 
        misc2 = pui.create(tabs.labels[3], "Movement & Other", 2), 
    }

    elements = { }
    elements.home = {
        logo1 = tabs.home.logo:label("\a9B5454FFInformation about changelog can be found in the anti-aim tab within neverlose."),
        logo = tabs.home.Upper_logo:label("                                         \v\f<circle-question>\r \n\nTo get a \vrole\r in the discord server you need to leave a \v5 star review\r on the marketplace, open a \vticket\r and send there a \vscreenshot\r of your review. The \vmoderator\r who will answer you will immediately give the role after making sure that it is not \vfake\r."),
        config = tabs.home.Upper_logo:button(pad_button("discord", "", 25), function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/UdMAQWXvde")
        
        end, true),
        config = tabs.home.Upper_logo:button(pad_button("gear", "", 25), function() 
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=5Gd8L0")
            
        end, true),
        accent_color = tabs.other.upper_visuals:color_picker("\vAccent color", color(255)),
        about = {
            welcome_back = tabs.home.Under_logo:label(" \v\f<user>\r    User: \v" .. invincible.neverlose_user .. "\r"),
            build = tabs.home.Under_logo:label("\v\f<code-compare>\r    Build: \v" .. invincible.script_info[2]),
        },
    }

    elements.antiaim = {
        main = {
            avoid_backstab = tabs.antiaim.under_section2:switch("\v\f<knife-kitchen>\r   Avoid Backstab", false),
            smart_teleport = tabs.antiaim.under_section2:switch("\v\f<transporter>\r    Smart Teleport", false),
            disablers = tabs.antiaim.under_section2:switch(" \v\f<xmark>\r     Disablers", false, function(gear)
                return 
                {
                    select = gear:listable("\n", "On Warmup", "On Round End", "No Enemies")
                }
            end),
            safe_head = tabs.antiaim.under_section2:switch(" \v\f<user-helmet-safety>\r    Safe Functions", false, function(gear)
                return 
                {
                    select = gear:listable("\n", "Knife", "Taser", "Distance", "Above Enemy")
                }
            end),
            manual_yaw = tabs.antiaim.under_section3:label("\v\f<arrows-left-right-to-line>\r   Manual Yaw", function(gear)
                return
                {
                    select_manual_yaw = gear:combo("Manual Yaw \v[Bind]", {"Disabled", "Left", "Right", "Front"}),
                    manual_edge = gear:switch("Manual Edge", false),
                    static_manuals = gear:switch("Static Yaw", false),
                    ignore_freestanding = gear:switch("Ignore Freestanding", false),
                }
            end),
            freestanding = tabs.antiaim.under_section3:label(" \v\f<arrows-turn-to-dots>\r    Freestanding", function(gear)
                return 
                {
                    freestanding_key = gear:switch("Freestanding \v[Bind]", false),
                    static_yaw = gear:switch("Static Yaw"),
                }
            end),
        },
        builder = {
            conditions = tabs.antiaim.under_section:combo("\v\f<chart-bar>\r  Conditional", {"Shared", "Standing", "Walking", "Running", "Crouching", "Crouching Moving", "Air", "Air Crouching", "Freestanding"})
        }
    }
    elements.other = {
        ragebot = {
            grenades = tabs.other.ragebot:label(" \v\f<bomb>\r   Grenade's", false, function(gear)
                return 
                {
                    automatic_release = gear:switch("Automatic Release", false),
                    automatic_release_damage = gear:slider("Amount", 0, 50, 0, 1, "dmg"),
                    super_toss = gear:switch("Super Toss", false),
                    throw_fix = gear:switch("Throw Fix", false),
                }
            end),
            dormant_aimbot = tabs.other.ragebot:switch("\v\f<eye-slash>\r   Dormant Aimbot", false, function(gear)
                return 
                {
                    hitboxes = gear:selectable("Select", {"Head", "Chest", "Stomach", "Legs"}),
                    accuracy = gear:slider("Accuracy", 50, 85, 0, 1, "%"),
                    minimum_damage = gear:slider("Min. Damage", 0, 130, 0, 1),
                    auto_scope = gear:switch("Auto Scope", false)
                }
            end),
            aimbot_logs = tabs.other.ragebot:switch(" \v\f<chart-simple-horizontal>\r    Aimbot Logs", false, function(gear)
                return 
                {
                    select = gear:listable("\n", {"Console", "Event"}),
                }
            end),
            fake_latency = tabs.other.ragebot:switch("\v\f<wifi>\r   Fake Latency \v[Unlock]", false, function(gear)
                return 
                {
                    amount = gear:slider("Amount", 0, 375, 0, 1, "ms"),
                    warning = gear:label("\v\f<triangle-exclamation>\r  The performance of hack can be significantly reduced"),
                }
            end),
            no_scope_mode = tabs.other.ragebot:switch("\v\f<location-crosshairs-slash>\r   No-Scope hitchance \v[override]", false, function(gear)
                return
                {
                    current_weapon = gear:list("\n", {"SSG-08", "AWP", "Auto-Snipers"}),
                    ssg_amount = gear:slider("Amount", 0, 100, 0, 1, "%"),
                    awp_amount = gear:slider("Amount", 0, 100, 0, 1, "%"),
                    autosnipers_amount = gear:slider("Amount", 0, 100, 0, 1, "%"),
                }
            end),
            air_mode = tabs.other.ragebot:switch(" \v\f<dove>\r   Air hitchance \v[override]", false, function(gear)
                return 
                {
                    current_weapon = gear:list("\n", {"SSG-08", "AWP", "Auto-Snipers"}),
                    ssg_amount = gear:slider("Amount", 0, 100, 0, 1, "%"),
                    awp_amount = gear:slider("Amount", 0, 100, 0, 1, "%"),
                    autosnipers_amount = gear:slider("Amount", 0, 100, 0, 1, "%"),
                }
            end),
        },
        visuals = {
            anti_aim_arrows = tabs.other.visuals:switch("\v\f<arrow-up-short-wide>\r  Manual Arrows ", false, function(gear)
                return 
                {
                    accent_color = gear:color_picker("Color", color(255)),
                }
            end),
            crosshair_indicators = tabs.other.visuals:switch("\v\f<crosshairs>\r   Crosshair Indicators ", false, function(gear)
                return 
                {
                    accent_color = gear:color_picker("Color", color(255)),
                }
            end),
            damage_indicator = tabs.other.visuals:switch("\v\f<desktop>\r   Damage Indicator ", false, function(gear)
                return 
                {
                    font = gear:combo("Font", {"Verdana", "Pixel"}),
                }
            end),
            scope_overlay = tabs.other.visuals:switch("\v\f<crosshairs-simple>\r    Scope \v[Overlay]", false, function(gear)
                return 
                {
                    accent_color = gear:color_picker("Color", color(255)),
                    position = gear:slider("Position", 0, 200, 100, 1, "px"),
                    offset = gear:slider("Offset", 0, 200, 5, 1, "px"),
                    inverted = gear:switch("Inverted", false),
                    t_style = gear:switch("T-Style", false),
                }
            end),
            hit_marker = tabs.other.visuals:switch(" \v\f<square-xmark>\r    Hitmarker \v[World]", false, function(gear)
                return 
                {
                    accent_color = gear:color_picker("Color", color(255)),
                }
            end),
            keep_model_transparency = tabs.other.visuals:switch(" \v\f<face-dotted>\r    Keep Model Transparency", false),
            side_indicators = tabs.other.visuals:switch(" \v\f<bars-progress>\r    \a9ECE47FF500$ \v[Indicators]", false, function(gear)
                return 
                {
                    side_indicators_type = gear:combo("Type", {"500$", "Modern"}),
                }
            end),
        },
        misc = {
            clantag = tabs.other.misc1:switch("\v\f<user-tag>\r  Clantag spammer", false),
            aspect_ratio = tabs.other.misc1:switch("\v\f<panorama>\r  Aspect Ratio", false, function(gear)
                return 
                {
                    amount = gear:slider("Amount", 0, 200, 0, 0.01),
                }
            end),
            viewmodel_changer = tabs.other.misc1:switch("\v\f<hand>\r    Viewmodel Changer", false, function(gear)
                return 
                {
                    viewmodel_fov = gear:slider("FOV", 0, 1000, 600, 0.1),
                    viewmodel_x = gear:slider("X", -100, 100, 10, 0.1),
                    viewmodel_y = gear:slider("Y", -100, 100, 10, 0.1),
                    viewmodel_z = gear:slider("Z", -100, 100, -10, 0.1),
                    knife_hand = gear:switch("Opposite Knife Hand"),
                    cs2 = gear:switch("CS:2 Scope Animation"),
                }
            end),
            killsay = tabs.other.misc1:switch("\v\f<face-swear>\r   Killsay", false),
            no_fall_damage = tabs.other.misc2:switch(" \v\f<triangle-exclamation>\r   No Fall Damage", false),
            fast_ladder = tabs.other.misc2:switch(" \v\f<rabbit-running>\r  Fast Ladder", false),
            animation_breakers = tabs.other.misc2:label("\v\f<bone-break>\r   Animation Breakers", false, function(gear)
                return 
                {
                    ground_legs = gear:combo("Ground Legs", {"Disabled", "Reversed", "Jitter", "Allah"}),
                    ground_legs_jitter_first_value = gear:slider("First Value", 0, 100, 0, 1, "%"),
                    ground_legs_jitter_second_value = gear:slider("Second Value", 0, 100, 0, 1, "%"),
                    air_legs = gear:combo("Air Legs", {"Disabled", "Static", "Jitter", "Allah"}),
                    addons = gear:listable("Addons", {"Pitch 0 On Land", "Move Lean", "Earth Quake", "Kangaroo"}),
                }
            end),
        },
    }

    conditions_mass = {[1] = "Shared", [2] = "Standing", [3] = "Walking", [4] = "Running", [5] = "Crouching", [6] = "Crouching Moving", [7] = "Air", [8] = "Air Crouching", [9] = "Freestanding"}
    elements.antiaim_builder = { }
    for i = 1, #conditions_mass do
        elements.antiaim_builder[i] = {
            state_enable = tabs.antiaim.under_section:switch("\v\f<user-check>\r Enable \v" .. conditions_mass[i], false),
            yaw = tabs.antiaim.upper_builder:combo("\v\f<arrows-rotate>\r  Yaw", {"Default", "Switch"}),
            yaw_offset = tabs.antiaim.upper_builder:slider("\v\f<arrows-left-right-to-line>\r  Offset", -90, 90, 0),
            yaw_left_offset = tabs.antiaim.upper_builder:slider("\v\f<square-arrow-left>\r  Offset Left", -90, 90, 0),
            yaw_right_offset = tabs.antiaim.upper_builder:slider("\v\f<square-arrow-right>\r  Offset Right", -90, 90, 0),
            yaw_modifier = tabs.antiaim.builder:combo("\v\f<arrows-repeat-1>\r  Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}),
            yaw_modifier_offset = tabs.antiaim.builder:slider("\v\f<arrows-left-right-to-line>\r  Offset", -180, 180, 0),
            body_yaw = tabs.antiaim.under_builder:switch("\v\f<arrows-to-eye>\r  Body Yaw", false),
            body_yaw_left_limit = tabs.antiaim.under_builder:slider("\v\f<square-arrow-left>\r  Left Limit", 0, 60, 0, 1, "°"),
            body_yaw_right_limit = tabs.antiaim.under_builder:slider("\v\f<square-arrow-right>\r  Right Limit", 0, 60, 0, 1, "°"),
            body_yaw_randomization = tabs.antiaim.under_builder:slider("\v\f<shuffle>\r  Randomization", 0, 100, 0, 1, "%"),
            body_yaw_options = tabs.antiaim.under_builder:selectable("\v\f<gear>\r  Options", {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"}),
            jitter_delay = tabs.antiaim.under_builder:slider("\v\f<gauge>\r  Delay", 1, 10, 1, 1, "t"),
            force_lc = tabs.antiaim.under2_builder:switch("\v\f<bolt>\r  Force LC", false),
            defensive_setup = tabs.antiaim.under2_builder:switch("\v\f<rectangles-mixed>\r  Defensive Setup", false, function(gear)
                return 
                {
                    pitch = gear:combo("Pitch", {"Disabled", "Down", "Up", "Random", "Sway", "Custom"}),
                    pitch_random1 = gear:slider("First Value", -89, 89, 0, 1),
                    pitch_random2 = gear:slider("Second Value", -89, 89, 0, 1),
                    pitch_custom1 = gear:slider("First Value", -89, 89, 0, 1),
                    pitch_custom2 = gear:slider("Second Value", -89, 89, 0, 1),
                    pitch_sway_speed = gear:slider("Speed", 1, 15, 1),
                    yaw = gear:combo("Yaw", {"Sideways", "Opposite", "Spin", "Random", "Custom"}),
                    yaw_random1 = gear:slider("First Value", -180, 180, 0, 1),
                    yaw_random2 = gear:slider("Second Value", -180, 180, 0, 1),
                    yaw_spin_speed = gear:slider("Speed", 1, 20, 0, 1),
                    yaw_custom1 = gear:slider("First Value", -180, 180, 0, 1),
                    yaw_custom2 = gear:slider("Second Value", -180, 180, 0, 1),
                    e_spam = gear:switch("E-Spam While Safe Head")
                }
            end),
        }
    end

    dependencies = {
        {menu = elements.antiaim.main.disablers.select, depend = {elements.antiaim.main.disablers}},
        {menu = elements.antiaim.main.safe_head.select, depend = {elements.antiaim.main.safe_head}},
        
        {menu = elements.other.ragebot.dormant_aimbot.hitboxes, depend = {elements.other.ragebot.dormant_aimbot}},
        {menu = elements.other.ragebot.dormant_aimbot.accuracy, depend = {elements.other.ragebot.dormant_aimbot}},
        {menu = elements.other.ragebot.dormant_aimbot.minimum_damage, depend = {elements.other.ragebot.dormant_aimbot}},
        {menu = elements.other.ragebot.dormant_aimbot.auto_scope, depend = {elements.other.ragebot.dormant_aimbot}},

        {menu = elements.other.ragebot.fake_latency.amount, depend = {elements.other.ragebot.fake_latency}},
        {menu = elements.other.ragebot.fake_latency.warning, depend = {elements.other.ragebot.fake_latency, {elements.other.ragebot.fake_latency.amount, function() return elements.other.ragebot.fake_latency.amount.value > 149 end}}},
    
        {menu = elements.other.ragebot.grenades.automatic_release_damage, depend = {elements.other.ragebot.grenades.automatic_release}},

        {menu = elements.other.ragebot.no_scope_mode.current_weapon, depend = {elements.other.ragebot.no_scope_mode}},
        {menu = elements.other.ragebot.no_scope_mode.ssg_amount, depend = {elements.other.ragebot.no_scope_mode, {elements.other.ragebot.no_scope_mode.current_weapon, 1}}},
        {menu = elements.other.ragebot.no_scope_mode.awp_amount, depend = {elements.other.ragebot.no_scope_mode, {elements.other.ragebot.no_scope_mode.current_weapon, 2}}},
        {menu = elements.other.ragebot.no_scope_mode.autosnipers_amount, depend = {elements.other.ragebot.no_scope_mode, {elements.other.ragebot.no_scope_mode.current_weapon, 3}}},

        {menu = elements.other.ragebot.air_mode.current_weapon, depend = {elements.other.ragebot.air_mode}},
        {menu = elements.other.ragebot.air_mode.ssg_amount, depend = {elements.other.ragebot.air_mode, {elements.other.ragebot.air_mode.current_weapon, 1}}},
        {menu = elements.other.ragebot.air_mode.awp_amount, depend = {elements.other.ragebot.air_mode, {elements.other.ragebot.air_mode.current_weapon, 2}}},
        {menu = elements.other.ragebot.air_mode.autosnipers_amount, depend = {elements.other.ragebot.air_mode, {elements.other.ragebot.air_mode.current_weapon, 3}}},

        {menu = elements.other.ragebot.aimbot_logs.select, depend = {elements.other.ragebot.aimbot_logs}},
    
        {menu = elements.other.visuals.anti_aim_arrows.accent_color, depend = {elements.other.visuals.anti_aim_arrows}},

        {menu = elements.other.visuals.crosshair_indicators.accent_color, depend = {elements.other.visuals.crosshair_indicators}},

        {menu = elements.other.visuals.damage_indicator.font, depend = {elements.other.visuals.damage_indicator}},

        {menu = elements.other.visuals.scope_overlay.accent_color, depend = {elements.other.visuals.scope_overlay}},
        {menu = elements.other.visuals.scope_overlay.position, depend = {elements.other.visuals.scope_overlay}},
        {menu = elements.other.visuals.scope_overlay.offset, depend = {elements.other.visuals.scope_overlay}},
        {menu = elements.other.visuals.scope_overlay.inverted, depend = {elements.other.visuals.scope_overlay}},
        {menu = elements.other.visuals.scope_overlay.t_style, depend = {elements.other.visuals.scope_overlay}},

        {menu = elements.other.visuals.hit_marker.accent_color, depend = {elements.other.visuals.hit_marker}},
    
        {menu = elements.other.visuals.side_indicators.side_indicators_type, depend = {elements.other.visuals.side_indicators}},

        {menu = elements.other.misc.aspect_ratio.amount, depend = {elements.other.misc.aspect_ratio}},

        {menu = elements.other.misc.viewmodel_changer.viewmodel_fov, depend = {elements.other.misc.viewmodel_changer}},
        {menu = elements.other.misc.viewmodel_changer.viewmodel_x, depend = {elements.other.misc.viewmodel_changer}},
        {menu = elements.other.misc.viewmodel_changer.viewmodel_y, depend = {elements.other.misc.viewmodel_changer}},
        {menu = elements.other.misc.viewmodel_changer.viewmodel_z, depend = {elements.other.misc.viewmodel_changer}},
        {menu = elements.other.misc.viewmodel_changer.knife_hand, depend = {elements.other.misc.viewmodel_changer}},
        {menu = elements.other.misc.viewmodel_changer.cs2, depend = {elements.other.misc.viewmodel_changer}},

        {menu = elements.other.misc.animation_breakers.ground_legs_jitter_first_value, depend = {{elements.other.misc.animation_breakers.ground_legs, "Jitter"}}},
        {menu = elements.other.misc.animation_breakers.ground_legs_jitter_second_value, depend = {{elements.other.misc.animation_breakers.ground_legs, "Jitter"}}},
    }

    function builder_visibility()
        for i = 1, #conditions_mass do
            condit_fn2 = function()
                if i ~= 1 then
                    return elements.antiaim_builder[i].state_enable:get()
                else
                    return true
                end
            end
    
            elements.antiaim_builder[i].state_enable:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and i ~= 1)
            elements.antiaim_builder[i].yaw:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and condit_fn2())
            elements.antiaim_builder[i].yaw_offset:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].yaw:get() == "Default" and condit_fn2())
            elements.antiaim_builder[i].yaw_left_offset:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].yaw:get() ~= "Default" and condit_fn2())
            elements.antiaim_builder[i].yaw_right_offset:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].yaw:get() ~= "Default" and condit_fn2())
            elements.antiaim_builder[i].yaw_modifier:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and condit_fn2())
            elements.antiaim_builder[i].yaw_modifier_offset:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].yaw_modifier:get() ~= "Disabled" and elements.antiaim_builder[i].yaw_modifier:get() ~= "Custom" and condit_fn2())
            elements.antiaim_builder[i].body_yaw:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and condit_fn2())
            elements.antiaim_builder[i].body_yaw_left_limit:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].body_yaw:get() and condit_fn2())
            elements.antiaim_builder[i].body_yaw_right_limit:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].body_yaw:get() and condit_fn2())
            elements.antiaim_builder[i].body_yaw_randomization:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].body_yaw:get() and condit_fn2())
            elements.antiaim_builder[i].body_yaw_options:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].body_yaw:get() and condit_fn2())
            elements.antiaim_builder[i].jitter_delay:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].body_yaw:get() and elements.antiaim_builder[i].body_yaw_options:get("Jitter") and condit_fn2())
            
            elements.antiaim_builder[i].force_lc:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and condit_fn2())
            elements.antiaim_builder[i].defensive_setup:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.pitch:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.pitch_random1:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and elements.antiaim_builder[i].defensive_setup.pitch:get() == "Random" and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.pitch_random2:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and elements.antiaim_builder[i].defensive_setup.pitch:get() == "Random" and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.pitch_custom1:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and elements.antiaim_builder[i].defensive_setup.pitch:get() == "Custom" and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.pitch_custom2:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and elements.antiaim_builder[i].defensive_setup.pitch:get() == "Custom" and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.pitch_sway_speed:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and elements.antiaim_builder[i].defensive_setup.pitch:get() == "Sway" and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.yaw:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.yaw_random1:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and elements.antiaim_builder[i].defensive_setup.yaw:get() == "Random" and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.yaw_random2:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and elements.antiaim_builder[i].defensive_setup.yaw:get() == "Random" and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.yaw_spin_speed:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and elements.antiaim_builder[i].defensive_setup.yaw:get() == "Spin" and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.yaw_custom1:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and elements.antiaim_builder[i].defensive_setup.yaw:get() == "Custom" and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.yaw_custom2:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and elements.antiaim_builder[i].defensive_setup.yaw:get() == "Custom" and condit_fn2())
            elements.antiaim_builder[i].defensive_setup.e_spam:visibility(elements.antiaim.builder.conditions:get() == conditions_mass[i] and elements.antiaim_builder[i].defensive_setup:get() and condit_fn2())
        end
    end
    
    for _, dep in ipairs(dependencies) do
        pui.traverse(dep.menu, function(ref, path)
            ref:depend(unpack(dep.depend))
        end)
    end

    function hide_menu_elements()
        refs.enabled:visibility(false)
        refs.pitch:visibility(false)
        refs.yaw:visibility(false)
        refs.yaw_modifier:visibility(false)
        refs.body_yaw:visibility(false)
        refs.freestanding:visibility(false)
        refs.extended_angles:visibility(false)
    end

    local changelog = ui.find("Aimbot", "Anti Aim", "Angles"):label("\a{Link Active}Invincible ~ changelog\aDEFAULT \n\n - Minor anti-aim bugs have been fixed \n - Added Force LC \n - Added Sway Defensive Pitch \n - Added Keep Model Transparency \n - Reworked UI \n - Added additional values for jitter legs \n\n\aFF0000FFLast update - 13.08.2024")
end

-- #endregion

-- #region : Anti-aim

local is_round_end = false

events.round_end:set(function()
    is_round_end = true
end)

events.round_start:set(function()
    is_round_end = false
end)

local antiaim = { } do 
    stateid = 0
    ground_ticks, end_time = 1, 0
    yaw_modifier_offset = 0
    e_spam_trigger = false
    should_disable = false
    yawadd = 0
    yawadd2 = 0
    yaw_add = 0
    is_inverted = false
    inverter = false
    ticks = 0
    switch = false
    start_time = globals.realtime

    antiaim.create_move = function(cmd)
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end
    
        in_air = function()
            if not entity.get_local_player() == nil then return end
            if bit.band(entity.get_local_player()["m_fFlags"], 1) == 1 then
                ground_ticks = ground_ticks + 1
            else
                ground_ticks = 0
                end_time = globals.curtime + 1
            end
            return ground_ticks > 1 and end_time > globals.curtime
        end
        
        get_player_state = function(cmd)
            in_air()
        
            on_ground = bit.band(entity.get_local_player().m_fFlags, bit.lshift(1, 0)) ~= 0
            jump = end_time > (globals.curtime + 0.9)
            is_slowwalk = refs.slow_walk:get()
            crouch = bit.band(entity.get_local_player().m_fFlags, bit.lshift(1, 1)) ~= 0 or refs.fake_duck:get()
            vx, vy, vz = entity.get_local_player().m_vecVelocity.x, entity.get_local_player().m_vecVelocity.y, entity.get_local_player().m_vecVelocity.z
            math_velocity = math.sqrt(vx ^ 2 + vy ^ 2)
            move = math_velocity > 5

            if refs.freestanding:get_override() then 
                return "FREESTANDING"
            else
                if on_ground and not move and not crouch then return "STANDING"
                elseif not jump and not crouch and not is_slowwalk then return "MOVING"
                elseif is_slowwalk and on_ground then return "SLOW-WALK"
                elseif crouch and not move and (not jump and on_ground) then return "CROUCH"
                elseif crouch and move and (not jump and on_ground) then return "CROUCH-MOVING"
                elseif jump and not crouch then return "AIR"
                elseif crouch and (jump or not on_ground) then return "AIR-C"
                end
            end
        end
    
        if elements.antiaim_builder[2].state_enable:get() and get_player_state(cmd) == "STANDING" then stateid = 2
        elseif elements.antiaim_builder[3].state_enable:get() and get_player_state(cmd) == "SLOW-WALK" then stateid = 3
        elseif elements.antiaim_builder[4].state_enable:get() and get_player_state(cmd) == "MOVING" then stateid = 4
        elseif elements.antiaim_builder[5].state_enable:get() and get_player_state(cmd) == "CROUCH" then stateid = 5
        elseif elements.antiaim_builder[6].state_enable:get() and get_player_state(cmd) == "CROUCH-MOVING" then stateid = 6
        elseif elements.antiaim_builder[7].state_enable:get() and get_player_state(cmd) == "AIR" then stateid = 7
        elseif elements.antiaim_builder[8].state_enable:get() and get_player_state(cmd) == "AIR-C" then stateid = 8
        elseif elements.antiaim_builder[9].state_enable:get() and get_player_state(cmd) == "FREESTANDING" then stateid = 9
        else
            stateid = 1
        end

        local weapon = lp:get_player_weapon()
        if weapon == nil then return end
        
        local weapon_class = weapon:get_classname()
        if weapon_class == nil then return end

        if cmd.choked_commands == 0 then 
            refs.pitch:override("Down")
            refs.yaw:override("Backward")
            refs.yaw_base:override("At Target")
            refs.avoid_backstab:override(elements.antiaim.main.avoid_backstab:get())
    
            is_inverted = not rage.antiaim:inverter()

            if elements.antiaim_builder[stateid].jitter_delay:get() > 1 then        
                ticks = ticks + 1
                
                if ticks > elements.antiaim_builder[stateid].jitter_delay:get() then
                    ticks = 0
                    switch = not switch
                end

                is_inverted = switch
            end

            refs.body_yaw:override(elements.antiaim_builder[stateid].body_yaw:get())

            if elements.antiaim_builder[stateid].body_yaw:get() then
                if elements.antiaim_builder[stateid].body_yaw_options:get("Jitter") then
                    if elements.antiaim_builder[stateid].jitter_delay:get() > 1 then
                        refs.body_yaw_inverter:override(is_inverted)
                        refs.body_yaw_options:override("")
                    else
                        refs.body_yaw_inverter:override()
                        refs.body_yaw_options:override(elements.antiaim_builder[stateid].body_yaw_options:get())
                    end  
                else
                    refs.body_yaw_options:override("")
                end

                refs.body_yaw_left_limit:override(elements.antiaim_builder[stateid].body_yaw_randomization:get() > 0 and utils.random_int(elements.antiaim_builder[stateid].body_yaw_left_limit:get() - (elements.antiaim_builder[stateid].body_yaw_randomization:get()/100) * elements.antiaim_builder[stateid].body_yaw_left_limit:get(), elements.antiaim_builder[stateid].body_yaw_left_limit:get()) or elements.antiaim_builder[stateid].body_yaw_left_limit:get())
                refs.body_yaw_right_limit:override(elements.antiaim_builder[stateid].body_yaw_randomization:get() > 0 and utils.random_int(elements.antiaim_builder[stateid].body_yaw_right_limit:get() - (elements.antiaim_builder[stateid].body_yaw_randomization:get()/100) * elements.antiaim_builder[stateid].body_yaw_right_limit:get(), elements.antiaim_builder[stateid].body_yaw_right_limit:get()) or elements.antiaim_builder[stateid].body_yaw_right_limit:get())
        
                refs.body_yaw_freestanding:override("Off") 
            end

            refs.yaw_modifier:override(elements.antiaim_builder[stateid].yaw_modifier:get())
            refs.yaw_modifier_offset:override(elements.antiaim_builder[stateid].yaw_modifier_offset:get())

            if elements.antiaim_builder[stateid].yaw:get() == "Switch" then
                yaw_add = is_inverted and elements.antiaim_builder[stateid].yaw_left_offset:get() or elements.antiaim_builder[stateid].yaw_right_offset:get()
            else
                yaw_add = elements.antiaim_builder[stateid].yaw_offset:get()
            end

            if elements.antiaim_builder[stateid].yaw_modifier:get() ~= "Disabled" then
                if is_inverted then
                    yaw_add = yaw_add + elements.antiaim_builder[stateid].yaw_modifier_offset:get() * 0.5
                else
                    yaw_add = yaw_add - elements.antiaim_builder[stateid].yaw_modifier_offset:get() * 0.5
                end

                refs.yaw_modifier:override("Disabled")
                refs.yaw_modifier_offset:override(0)
            end

            refs.yaw_offset:override(yaw_add)
        end
        
        if entity.get_threat() ~= nil then  
            local delta = entity.get_threat():get_origin() - lp:get_origin()
            local distancesqr = delta:length2dsqr()

            if elements.antiaim.main.safe_head:get() then
                e_spam_trigger = false
                
                function values()
                    refs.pitch:override("Down")
                    refs.yaw_offset:override(0)
                    refs.yaw_modifier:override("Disabled")
                    refs.yaw_modifier_offset:override(0)
                    refs.body_yaw:override(true)
                    refs.body_yaw_options:override("")
                    refs.body_yaw_left_limit:override(0)
                    refs.body_yaw_right_limit:override(0)
                    refs.body_yaw_freestanding:override("Off")
                end
    
                if elements.antiaim.main.safe_head.select:get(1) and weapon_class == "CKnife" and get_player_state(cmd) == "AIR-C" then
                    values()
                    e_spam_trigger = true
                elseif elements.antiaim.main.safe_head.select:get(2) and weapon_class == "CWeaponTaser" and get_player_state(cmd) == "AIR-C" then
                    values()
                    e_spam_trigger = true
                elseif elements.antiaim.main.safe_head.select:get(3) and distancesqr > (1000 * 1000) then
                    values()
                    e_spam_trigger = false
                elseif elements.antiaim.main.safe_head.select:get(4) and lp:get_origin().z - entity.get_threat():get_origin().z > 55 then
                    values()
                    e_spam_trigger = false
                end
            end
        end

        if elements.antiaim_builder[stateid].force_lc:get() then
            refs.lag_options:override("Always On")
            refs.hide_shots_options:override("Break LC")
        else
            refs.lag_options:override("On Peek")
            refs.hide_shots_options:override("Favor Fire Rate")
        end

        local weapon_info = weapon:get_weapon_info()
        if weapon_info == nil then return end

        if weapon_info.weapon_type ~= 9 then
            if elements.antiaim.main.manual_yaw.manual_edge:get() and get_player_state(cmd) == "CROUCH" and elements.antiaim.main.manual_yaw.select_manual_yaw:get() ~= "Disabled" then
                refs.hidden_yaw:set(true)

                rage.antiaim:override_hidden_pitch(0)
                rage.antiaim:override_hidden_yaw_offset(-180)
            else
                if e_spam_trigger and elements.antiaim_builder[stateid].defensive_setup.e_spam:get() then
                    refs.hidden_yaw:set(true)
        
                    rage.antiaim:override_hidden_pitch(0)
                    rage.antiaim:override_hidden_yaw_offset(180)
                else
                    refs.hidden_yaw:set(false)
            
                    if not e_spam_trigger and elements.antiaim_builder[stateid].defensive_setup:get() then
                        refs.hidden_yaw:set(true)
            
                        if elements.antiaim_builder[stateid].defensive_setup.pitch:get() == "Disabled" then
                            rage.antiaim:override_hidden_pitch(0)
                        elseif elements.antiaim_builder[stateid].defensive_setup.pitch:get() == "Down" then
                            rage.antiaim:override_hidden_pitch(89)
                        elseif elements.antiaim_builder[stateid].defensive_setup.pitch:get() == "Up" then
                            rage.antiaim:override_hidden_pitch(-89)
                        elseif elements.antiaim_builder[stateid].defensive_setup.pitch:get() == "Random" then
                            rage.antiaim:override_hidden_pitch(math.random(elements.antiaim_builder[stateid].defensive_setup.pitch_random1:get(), elements.antiaim_builder[stateid].defensive_setup.pitch_random2:get()))
                        elseif elements.antiaim_builder[stateid].defensive_setup.pitch:get() == "Sway" then
                            local time = 0
                            time = time + (elements.antiaim_builder[stateid].defensive_setup.pitch_sway_speed:get() * 0.5) * globals.curtime
                            local value = math.sin(time) * 89
                            rage.antiaim:override_hidden_pitch(value)
                        elseif elements.antiaim_builder[stateid].defensive_setup.pitch:get() == "Custom" then
                            rage.antiaim:override_hidden_pitch(not rage.antiaim:inverter() and elements.antiaim_builder[stateid].defensive_setup.pitch_custom1:get() or elements.antiaim_builder[stateid].defensive_setup.pitch_custom2:get())
                        end
            
                        if elements.antiaim_builder[stateid].defensive_setup.yaw:get() == "Sideways" then
                            rage.antiaim:override_hidden_yaw_offset(not rage.antiaim:inverter() and -120 or 120)
                        elseif elements.antiaim_builder[stateid].defensive_setup.yaw:get() == "Opposite" then
                            rage.antiaim:override_hidden_yaw_offset(-180)
                        elseif elements.antiaim_builder[stateid].defensive_setup.yaw:get() == "Spin" then
                            if yawadd >= 180 then
                                yawadd = -180
                            else
                                yawadd = yawadd + elements.antiaim_builder[stateid].defensive_setup.yaw_spin_speed:get()
                            end
        
                            rage.antiaim:override_hidden_yaw_offset(yawadd)    
                        elseif elements.antiaim_builder[stateid].defensive_setup.yaw:get() == "Random" then
                            rage.antiaim:override_hidden_yaw_offset(math.random(elements.antiaim_builder[stateid].defensive_setup.yaw_random1:get(), elements.antiaim_builder[stateid].defensive_setup.yaw_random2:get()))
                        elseif elements.antiaim_builder[stateid].defensive_setup.yaw:get() == "Custom" then
                            rage.antiaim:override_hidden_yaw_offset(not rage.antiaim:inverter() and elements.antiaim_builder[stateid].defensive_setup.yaw_custom1:get() or elements.antiaim_builder[stateid].defensive_setup.yaw_custom2:get())
                        end
                    else
                        refs.hidden_yaw:set(false)
                    end
                end
            end
        else
            refs.hidden_yaw:set(false)
        end

        if elements.antiaim.main.manual_yaw.ignore_freestanding:get() and elements.antiaim.main.manual_yaw.select_manual_yaw:get() ~= "Disabled" then
            refs.freestanding:override(false)
            refs.freestanding_disable_yaw_modifiers:override(false) 
            refs.freestanding_body_freestanding:override(false)
        else
            if stateid == 9 then
                if elements.antiaim.main.freestanding.freestanding_key:get() then
                    refs.freestanding:override(true)

                    if elements.antiaim.main.freestanding.static_yaw:get() then
                        refs.yaw:override("Backward")
                        refs.yaw_base:override("Local View")
                        refs.body_yaw:override(true)
                        refs.body_yaw_options:override("")
                        refs.body_yaw_left_limit:override(60)
                        refs.body_yaw_right_limit:override(60)
                        refs.body_yaw_freestanding:override("Off") 
                        rage.antiaim:inverter(false)
                        refs.yaw_modifier:override("Disabled")
                        refs.yaw_modifier_offset:override(0)
                        refs.yaw_offset:override(0)
                    end
                else
                    refs.freestanding:override(false)
                end

                refs.pitch:override("Down")
                refs.yaw:override("Backward")
                refs.yaw_base:override("At Target")
        
                is_inverted = not rage.antiaim:inverter()
    
                if elements.antiaim_builder[stateid].jitter_delay:get() > 1 then        
                    ticks = ticks + 1
                    
                    if ticks > elements.antiaim_builder[stateid].jitter_delay:get() then
                        ticks = 0
                        switch = not switch
                    end
    
                    is_inverted = switch
                end
    
                refs.body_yaw:override(elements.antiaim_builder[stateid].body_yaw:get())
    
                if elements.antiaim_builder[stateid].body_yaw_options:get("Jitter") then
                    if elements.antiaim_builder[stateid].jitter_delay:get() > 1 then
                        refs.body_yaw_inverter:override(is_inverted)
                        refs.body_yaw_options:override("")
                    else
                        refs.body_yaw_inverter:override()
                        refs.body_yaw_options:override(elements.antiaim_builder[stateid].body_yaw_options:get())
                    end  
                end
            
                refs.body_yaw_left_limit:override(elements.antiaim_builder[stateid].body_yaw_randomization:get() > 0 and utils.random_int(elements.antiaim_builder[stateid].body_yaw_left_limit:get() - (elements.antiaim_builder[stateid].body_yaw_randomization:get()/100) * elements.antiaim_builder[stateid].body_yaw_left_limit:get(), elements.antiaim_builder[stateid].body_yaw_left_limit:get()) or elements.antiaim_builder[stateid].body_yaw_left_limit:get())
                refs.body_yaw_right_limit:override(elements.antiaim_builder[stateid].body_yaw_randomization:get() > 0 and utils.random_int(elements.antiaim_builder[stateid].body_yaw_right_limit:get() - (elements.antiaim_builder[stateid].body_yaw_randomization:get()/100) * elements.antiaim_builder[stateid].body_yaw_right_limit:get(), elements.antiaim_builder[stateid].body_yaw_right_limit:get()) or elements.antiaim_builder[stateid].body_yaw_right_limit:get())
        
                refs.body_yaw_freestanding:override("Off") 

                if elements.antiaim_builder[stateid].yaw:get() == "Switch" then
                    yaw_add = is_inverted and elements.antiaim_builder[stateid].yaw_left_offset:get() or elements.antiaim_builder[stateid].yaw_right_offset:get()
                else
                    yaw_add = elements.antiaim_builder[stateid].yaw_offset:get()
                end
    
                refs.yaw_offset:override(yaw_add)
    
                refs.yaw_modifier:override(elements.antiaim_builder[stateid].yaw_modifier:get())
                refs.yaw_modifier_offset:override(elements.antiaim_builder[stateid].yaw_modifier_offset:get())
            else
                if elements.antiaim.main.freestanding.freestanding_key:get() then
                    refs.freestanding:override(true)

                    if elements.antiaim.main.freestanding.static_yaw:get() then
                        refs.yaw:override("Backward")
                        refs.yaw_base:override("Local View")
                        refs.body_yaw:override(true)
                        refs.body_yaw_options:override("")
                        refs.body_yaw_left_limit:override(60)
                        refs.body_yaw_right_limit:override(60)
                        refs.body_yaw_freestanding:override("Off") 
                        rage.antiaim:inverter(false)
                        refs.yaw_modifier:override("Disabled")
                        refs.yaw_modifier_offset:override(0)
                        refs.yaw_offset:override(0)
                    end
                else
                    refs.freestanding:override(false)
                end
            end
        end
    
        if elements.antiaim.main.manual_yaw.select_manual_yaw:get() == "Front" then
            refs.yaw_offset:override(180)
        elseif elements.antiaim.main.manual_yaw.select_manual_yaw:get() == "Left" then
            refs.yaw_offset:override(-90)
        elseif elements.antiaim.main.manual_yaw.select_manual_yaw:get() == "Right" then
            refs.yaw_offset:override(90)
        end
    
        if elements.antiaim.main.manual_yaw.static_manuals:get() then
            if elements.antiaim.main.manual_yaw.select_manual_yaw:get() ~= "Disabled" then
                refs.yaw_modifier:override("Disabled")
                refs.yaw_modifier_offset:override(0)
                refs.body_yaw_options:override("")
                refs.body_yaw_left_limit:override(60)
                refs.body_yaw_right_limit:override(60)
                refs.body_yaw_freestanding:override("Off") 
                rage.antiaim:inverter(false)
            end
        end

        if elements.antiaim.main.disablers:get() then
            if elements.antiaim.main.disablers.select:get(1) and entity.get_game_rules().m_bWarmupPeriod then
                cmd.in_use = 1
            elseif elements.antiaim.main.disablers.select:get(2) and is_round_end then
                cmd.in_use = 1
            elseif elements.antiaim.main.disablers.select:get(3) and not entity.get_threat() then
                cmd.in_use = 1
            end
        end

        if elements.antiaim.main.smart_teleport:get() then
            if get_player_state(cmd) == "AIR-C" or get_player_state(cmd) == "AIR" then
                if entity.get_threat(true) then
                    if globals.tickcount % 15 == 0 then
                        rage.exploit:force_teleport()
                    else
                        rage.exploit:force_charge()
                    end
                end
            end
        end
    end
end

-- #region : Ragebot

local ragebot = { } do
    local hitgroup_str = {
        [0] = 'generic',
        'head', 'chest', 'stomach',
        'left arm', 'right arm',
        'left leg', 'right leg',
        'neck', 'generic', 'gear'
    }
    
    ragebot.render = function()
        local lp = entity.get_local_player()
        if lp == nil then return end

        if elements.other.ragebot.fake_latency:get() then
            cvar.sv_maxunlag:float(0.8)
            refs.fake_latency:override(elements.other.ragebot.fake_latency.amount:get())
        else
            cvar.sv_maxunlag:float(0.2)
            refs.fake_latency:override()
        end
    end
    
    ragebot.aim_ack = function(e)
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        local id = e.id
        local target = entity.get(e.target)
        local damage = e.damage
        local wanted_damage = e.wanted_damage
        local hitgroup = hitgroup_str[e.hitgroup]
        local wanted_hitgroup = hitgroup_str[e.wanted_hitgroup]
        local hitchance = e.hitchance
        local state = e.state
        local bt = e.backtrack
        if not target then return end
        if target == nil then return end

        if elements.other.ragebot.aimbot_logs:get() then
            refs.filters:set("Console")

            if state == nil then
                if elements.other.ragebot.aimbot_logs.select:get("Event") then
                    print_dev("[\a81A939FFInvincible\aDEFAULT] » Hit ".. target:get_name() .."'s \a81A939FF".. hitgroup .."\aDEFAULT for ".. damage .."(".. wanted_damage ..") aimed=".. wanted_hitgroup .."(".. hitchance .."%) (".. bt .." ticks)")
                end
                if elements.other.ragebot.aimbot_logs.select:get("Console") then
                    print_raw("[\a81A939FFInvincible\aDEFAULT] » Hit ".. target:get_name() .."'s \a81A939FF".. hitgroup .."\aDEFAULT for ".. damage .."(".. wanted_damage ..") aimed=".. wanted_hitgroup .."(".. hitchance .."%) (".. bt .." ticks)")
                end
            else
                if elements.other.ragebot.aimbot_logs.select:get("Event") then
                    print_dev("[\a9B5454FFInvincible\aDEFAULT] » Missed shot due to \a9B5454FF".. state .."\aDEFAULT in ".. target:get_name() .."'s ".. wanted_hitgroup .." (".. bt .." ticks)")
                end
                if elements.other.ragebot.aimbot_logs.select:get("Console") then
                    print_raw("[\a9B5454FFInvincible\aDEFAULT] » Missed shot due to \a9B5454FF".. state .."\aDEFAULT in ".. target:get_name() .."'s ".. wanted_hitgroup .." (".. bt .." ticks)")
                end
            end
        else
            refs.filters:set("")
        end
    end

    local WEAPONTYPE_SNIPER_RIFLE = 5

    local aim_target
    local aim_point
    local aim_hitbox
    local aim_damage
    local aim_accuracy

    local is_hit = false
    local is_shot = false

    local target_index = 1
    local round_started = 0.0

    local e_hitbox = {
        [0]  = "Generic",
        [1]  = "Head",
        [2]  = "Chest",
        [3]  = "Stomach",
        [4]  = "Chest",
        [5]  = "Chest",
        [6]  = "Legs",
        [7]  = "Legs",
        [8]  = "Head",
        [10] = "Gear"
    }

    local hitbox_points = {
        {
            scale = 5,
            hitbox = "Stomach",
            vec = vector(0, 0, 40)
        },

        {
            scale = 6,
            hitbox = "Chest",
            vec = vector(0, 0, 50)
        },

        {
            scale = 3,
            hitbox = "Head",
            vec = vector(0, 0, 58)
        },

        {
            scale = 4,
            hitbox = "Legs",
            vec = vector(0, 0, 20)
        }
    }

    local function contains(list, value)
        for i = 1, #list do
            if list[i] == value then
                return true
            end
        end

        return false
    end

    local function is_weapon_gun(type)
        return type >= 1 and type <= 6
    end

    local function get_aimbot_targets()
        local list = { }

        local player_resource = entity.get_player_resource()

        for i = 1, globals.max_players do
            local player = entity.get(i)

            if player == nil then
                goto continue
            end

            local is_target_valid = player_resource.m_bConnected[i]
                and player:is_enemy() and player:is_dormant()

            if not is_target_valid then
                goto continue
            end

            table.insert(list, player)
            ::continue::
        end

        return list
    end

    local function create_multipoints(from, to, radius)
        local angles = from:to(to):angles()
        local radian = math.rad(angles.y + 90)

        local forward = vector(math.cos(radian), math.sin(radian), 0)
        local direction = forward * radius

        return {
            {
                text = "Middle",
                vec = to
            },

            {
                text = "Left",
                vec = to + direction
            },

            {
                text = "Right",
                vec = to - direction
            }
        }
    end

    local function trace_bullet(player, start_pos, end_pos, skip)
        local damage, trace = utils.trace_bullet(player, start_pos, end_pos, skip)

        if trace ~= nil then
            local ent = trace.entity

            if ent == nil then
                return 0, trace
            end

            if ent:is_player() and not ent:is_enemy() then
                return 0, trace
            end
        end

        return damage, trace
    end

    local WEAPONTYPE_GRENADE = 9
    local GRENADE_SECONDARY_DAMPENING = 0.3

    local function get_throw_toss(throw_angle, throw_velocity, throw_strength, abs_velocity)
        local vel = math.clamp(throw_velocity, 15, 750)
        local clamped_throw_strength = math.clamp(throw_strength, 0.0, 1.0)

        vel = vel * lerp(GRENADE_SECONDARY_DAMPENING, 1.0, clamped_throw_strength)

        local forward = vector():angles(throw_angle)
        local throw = forward * vel - abs_velocity

        return throw:angles()
    end

    ragebot.create_move = function(cmd)
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        if elements.other.ragebot.grenades.throw_fix:get() then
            local weapon = lp:get_player_weapon()
            if weapon == nil then return end

            local weapon_info = weapon:get_weapon_info()
            if weapon_info == nil then return end
    
            if weapon_info.weapon_type == 9 then
                refs.weapon_actions:override({ })
            else
                refs.weapon_actions:override()
            end
        end

        if elements.other.ragebot.no_scope_mode:get() or elements.other.ragebot.air_mode:get() then
            local weapon = lp:get_player_weapon()
            if weapon == nil then return end

            local weapon_index = weapon:get_weapon_index()
            if weapon_index == nil then return end

            if bit.band(entity.get_local_player().m_fFlags, bit.lshift(1, 0)) == 0 then
                if weapon_index == 40 then
                    refs.ssg_hitchance:override(elements.other.ragebot.air_mode.ssg_amount:get())
                end
                if weapon_index == 9 then
                    refs.awp_hitchance:override(elements.other.ragebot.air_mode.awp_amount:get())
                end
                if weapon_index == 38 or weapon_index == 11 then
                    refs.autosnipers_hitchance:override(elements.other.ragebot.air_mode.autosnipers_amount:get())
                end
            else
                refs.ssg_hitchance:override()
                refs.awp_hitchance:override()
                refs.autosnipers_hitchance:override()
            end

            if not lp.m_bIsScoped or bit.band(entity.get_local_player().m_fFlags, bit.lshift(1, 0)) == 0 then
                if bit.band(entity.get_local_player().m_fFlags, bit.lshift(1, 0)) == 0 and elements.other.ragebot.air_mode:get()  then
                    if weapon_index == 40 then
                        refs.ssg_hitchance:override(elements.other.ragebot.air_mode.ssg_amount:get())
                    end
                    if weapon_index == 9 then
                        refs.awp_hitchance:override(elements.other.ragebot.air_mode.awp_amount:get())
                    end
                    if weapon_index == 38 or weapon_index == 11 then
                        refs.autosnipers_hitchance:override(elements.other.ragebot.air_mode.autosnipers_amount:get())
                    end
                else
                    if elements.other.ragebot.no_scope_mode:get() then
                        if weapon_index == 40 then
                            refs.ssg_hitchance:override(elements.other.ragebot.no_scope_mode.ssg_amount:get())
                        end
                        if weapon_index == 9 then
                            refs.awp_hitchance:override(elements.other.ragebot.no_scope_mode.awp_amount:get())
                        end
                        if weapon_index == 38 or weapon_index == 11 then
                            refs.autosnipers_hitchance:override(elements.other.ragebot.no_scope_mode.autosnipers_amount:get())
                        end
                    else
                        refs.ssg_hitchance:override()
                        refs.awp_hitchance:override()
                        refs.autosnipers_hitchance:override()
                    end
                end
            else
                refs.ssg_hitchance:override()
                refs.awp_hitchance:override()
                refs.autosnipers_hitchance:override()
            end
        end

        if elements.other.ragebot.grenades.super_toss:get() then
            if render.camera_angles() ~= cmd.view_angles:clone() then return end

            local lp = entity.get_local_player()
            if lp == nil then return end

            local weapon = lp:get_player_weapon()
            if weapon == nil then return end

            local weapon_info = weapon:get_weapon_info()
            if weapon_info == nil then return end

            local weapon_type = weapon_info.weapon_type

            if weapon_type == WEAPONTYPE_GRENADE then
                local predicted_time = globals.curtime - to_time(globals.clock_offset)
                
                if weapon.m_fThrowTime > predicted_time then
                    cmd.in_speed = true
    
                    cmd.view_angles = get_throw_toss(
                        render.camera_angles(),
                        weapon_info.throw_velocity,
                        weapon.m_flThrowStrength,
                        lp.m_vecVelocity
                    )
                end
            end
        end

        if elements.other.ragebot.dormant_aimbot:get() then
            refs.dormant_aimbot:override(false)

            local weapon = lp:get_player_weapon()
            if weapon == nil then return end
    
            local weapon_info = weapon:get_weapon_info()
            if weapon_info == nil then return end
    
            local inaccuracy = weapon:get_inaccuracy()
            if inaccuracy == nil then return end
    
            local tickcount = globals.tickcount
    
            local eye_pos = lp:get_eye_position()
            local simtime = lp:get_simulation_time().current
    
            local onground = bit.band(lp.m_fFlags, bit.lshift(1, 0)) ~= 0
    
            if tickcount < round_started then
                return
            end
    
            if cmd.in_jump and not onground then
                return
            end
    
            local weapon_type = weapon_info.weapon_type
    
            if not is_weapon_gun(weapon_type) or weapon.m_iClip1 <= 0 then
                return false
            end
    
            local targets = get_aimbot_targets()
            local hitboxes = elements.other.ragebot.dormant_aimbot.hitboxes:get()
    
            if tickcount % #targets ~= 0 then
                target_index = target_index + 1
            else
                target_index = 1
            end
    
            local target = targets[target_index]
    
            if target == nil then
                return
            end
    
            local bbox = target:get_bbox()
            local origin = target:get_origin()
    
            local duck_amount = target.m_flDuckAmount
    
            local hitchance = elements.other.ragebot.dormant_aimbot.accuracy:get()
            local desired_damage = elements.other.ragebot.dormant_aimbot.minimum_damage:get()
    
            if desired_damage == -1 then
                desired_damage = refs.minimum_damage:get()
            end
    
            if desired_damage > 100 then
                desired_damage = desired_damage - 100 + target.m_iHealth
            end
    
            local points = { }
    
            for i = 1, #hitbox_points do
                local data = hitbox_points[i]
    
                local vec = data.vec
                local scale = data.scale
                local hitbox = data.hitbox
    
                if hitbox == "Head" then
                    vec = vec - vector(0, 0, 10 * duck_amount)
                end
    
                if hitbox == "Chest" then
                    vec = vec - vector(0, 0, 4 * duck_amount)
                end
    
                if #hitboxes ~= 0 then
                    if contains(hitboxes, hitbox) then
                        table.insert(points, {
                            vec = vec,
                            scale = scale,
                            hitbox = hitbox
                        })
                    end
                else
                    table.insert(points, 1, {
                        vec = vec,
                        scale = scale,
                        hitbox = hitbox
                    })
                end
            end
    
            local is_available_to_shoot = weapon_info.is_revolver and weapon.m_flNextPrimaryAttack < simtime
                or math.max(lp.m_flNextAttack, weapon.m_flNextPrimaryAttack, weapon.m_flNextSecondaryAttack) < simtime
    
            if not is_available_to_shoot then
                return
            end
    
            local found_pos
            local found_damage
    
            if hitchance >= math.floor(bbox.alpha * 100) + 5 then
                return
            end
    
            for j = 1, #points do
                local point = points[j]
                local multipoints = create_multipoints(eye_pos, origin + point.vec, point.scale)
    
                for k = 1, #multipoints do
                    local multipoint = multipoints[k]
                    local aimpoint = multipoint.vec
    
                    local damage, tr = trace_bullet(lp, eye_pos, aimpoint, function(ent)
                        return ent == target
                    end)
    
                    if tr ~= nil and tr:is_visible() then
                        goto continue
                    end
    
                    if damage ~= 0 and desired_damage < damage then
                        found_pos = aimpoint
                        found_damage = damage
    
                        aim_target = target
                        aim_hitbox = point.hitbox
                        aim_damage = damage
                        aim_point = multipoint.text
                        aim_accuracy = bbox.alpha
    
                        break
                    end
    
                    ::continue::
                end
    
                if found_pos and found_damage then
                    break
                end
            end
    
            if not found_pos or not found_damage then
                return
            end
    
            local angles = eye_pos:to(found_pos):angles()
    
            cmd.block_movement = 1
    
            if elements.other.ragebot.dormant_aimbot.auto_scope:get() then
                local is_onground = not cmd.in_jump and onground
    
                local is_scoped = lp.m_bIsScoped or lp.m_bResumeZoom
                local is_sniper = weapon_info.weapon_type == WEAPONTYPE_SNIPER_RIFLE
    
                if not is_scoped and is_sniper and is_onground then
                    cmd.in_attack2 = true
                end
            end
    
            if inaccuracy < 0.01 then
                cmd.view_angles = angles
                cmd.in_attack = true
    
                is_shot = true
            end
        else
            refs.dormant_aimbot:override()
        end
    end

    ragebot.grenade_override_view = function(e)
        local lp = entity.get_local_player()
        if lp == nil then return end

        if not elements.other.ragebot.grenades.super_toss:get() then return end

        local weapon = lp:get_player_weapon()
        if weapon == nil then return end

        local weapon_info = weapon:get_weapon_info()
        if weapon_info == nil then return end

        e.angles = get_throw_toss(
            e.angles,
            weapon_info.throw_velocity,
            weapon.m_flThrowStrength,
            e.velocity
        )
    end

    ragebot.grenade_prediction = function(e)
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        local weapon = lp:get_player_weapon()
        if weapon == nil then return end
    
        local weapon_idx = weapon:get_weapon_index()
        if not weapon_idx == 44 or not weapon_idx == 46 then return end

        if elements.other.ragebot.grenades.automatic_release:get() then
            if weapon.m_bPinPulled and e.damage > elements.other.ragebot.grenades.automatic_release_damage:get() then
                utils.console_exec("+attack") 
                utils.execute_after(0.1, function()
                    utils.console_exec("-attack") 
                end)
            end
        end
    end

    ragebot.weapon_fire = function(e)
        utils.execute_after(0.03, function()
            if entity.get(e.userid, true) == entity.get_local_player() then
                if is_shot and not is_hit then
                    events["dormant_miss"]:call {
                        userid = aim_target,
                        aim_hitbox = aim_hitbox,
                        aim_damage = aim_damage,
                        aim_point = aim_point,
                        accuracy = aim_accuracy
                    }
                end

                is_hit = false
                is_shot = false

                aim_target = nil
                aim_hitbox = nil
                aim_damage = nil
                aim_point = nil
                aim_accuracy = nil
            end
        end)
    end

    ragebot.player_hurt = function(e)
        local lp = entity.get_local_player()

        local userid = entity.get(e.userid, true)
        local attacker = entity.get(e.attacker, true)

        if userid == nil or attacker ~= lp then
            return
        end

        local bbox = userid:get_bbox()

        if bbox == nil then
            return
        end

        if userid:is_dormant() and is_shot == true then
            is_hit = true

            events["dormant_hit"]:call {
                userid = userid,
                attacker = attacker,
                health = e.health,
                armor = e.armor,
                weapon = e.weapon,
                dmg_health = e.dmg_health,
                dmg_armor = e.dmg_armor,
                hitgroup = e.hitgroup,
                accuracy = bbox.alpha,
                hitbox = e_hitbox[e.hitgroup],
                aim_point = aim_point,
                aim_hitbox = aim_hitbox,
                aim_damage = aim_damage
            }
        end
    end
end

-- #endregion

-- #region : Visuals

local visuals = { } do
    local x, y = render.screen_size().x, render.screen_size().y

    local verdana = render.load_font("Verdana", 16, "ad")
    local calibri = render.load_font("Calibri", 24, "bad")

    local window = window_system.new("damage_indicator", { pos = vector(x * 0.5 + 5, y * 0.5 - 5), anchor = vector(0.0, 1.0) })

    local draw_list = { }

    local bomb_img = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x64\x00\x00\x00\x5C\x08\x03\x00\x00\x00\xAF\x15\xE0\xA6\x00\x00\x00\x01\x73\x52\x47\x42\x01\xD9\xC9\x2C\x7F\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0B\x13\x00\x00\x0B\x13\x01\x00\x9A\x9C\x18\x00\x00\x02\xDF\x50\x4C\x54\x45\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x76\x99\x69\x74\x00\x00\x00\xF5\x74\x52\x4E\x53\x00\x01\x43\x93\x58\x06\x5A\xFB\xFF\xFD\x96\x04\xD5\xF9\x02\x0E\xE3\x18\x16\xEA\x2B\x1B\xEF\x36\x29\x73\x72\x1E\xF2\x3F\x75\x6B\x20\xEB\xF4\x32\x21\xF6\x47\x2F\xE7\xE2\x37\x5E\xB7\x0F\x23\xF8\x51\x08\xB3\x9A\x7D\xF7\x63\x00\x70\x7A\xC1\x25\x6E\x2D\xE0\x62\xFC\xC2\x28\x76\xAE\x88\x0B\xC9\x5D\x7E\xFA\xE9\x27\x5C\xDF\x12\x31\x84\xD8\x8C\xCF\x97\x3A\x8A\x03\xAC\xDA\x1C\x6C\x2E\x42\x8F\x7B\xA1\x4B\x95\x10\xCA\x13\x55\x3D\x1A\x33\x0A\x4E\x69\x82\xBB\x41\xC7\x80\x87\x91\x9E\xA6\xAA\x86\x7F\x5F\x26\xDC\xFE\x49\xE8\x17\xC3\x46\x89\x92\xBA\x2C\xC0\xB8\xA3\x9F\xA8\xAF\xB1\xB5\xBC\xD4\x7C\xF3\x9D\x24\x0D\x8E\x5B\x05\xD9\xD1\x99\xF1\xCC\xCB\x9B\x4F\x14\xCE\xC5\xCD\x19\x30\xF5\x07\xDE\x15\xA4\x1D\x11\xE5\x83\x2A\xA0\x71\xD6\xD0\xC6\xB9\xA9\x6D\x52\x35\xDD\x0C\xE4\x64\xED\xBF\xC4\x8D\x77\x85\x8B\x90\xEE\xE6\xA5\x78\xEC\x09\x60\x1F\x81\xAB\x9C\x98\x38\x61\x4A\xB2\x34\x4C\xDB\xA7\xD2\x45\x39\x53\xB0\xF0\xBD\x94\x4D\xB4\x44\x54\x3E\xA2\x22\x59\x6A\xE1\xD7\xAD\x40\x48\x3B\xBE\x65\x74\x34\x72\x01\xD4\x00\x00\x07\x6E\x49\x44\x41\x54\x78\x9C\xED\x9A\xF9\x5B\xD4\x46\x18\xC7\xB3\x22\x32\x2B\x8B\x8A\x58\xD0\x42\xE5\x10\x54\x28\x42\x11\x70\x11\x11\x10\x95\x22\x28\x56\x2C\x88\x14\x05\xE4\xB4\x1C\xC5\x20\x60\x45\xBC\x51\x01\xA1\x88\x88\xA2\xA2\x78\x71\x15\x15\x0B\x88\x78\x0B\x15\x54\x14\xCF\x0A\x78\xB6\xB5\xD5\x5A\xDB\xDA\xEB\x0F\x68\x66\x26\xBB\x9B\x84\xDD\x25\x86\xA5\xCF\xD3\x3E\xBE\xBF\x64\xE7\x9B\xF7\x7D\x3F\x39\x66\x92\x77\x26\x4B\x10\x02\x4C\x34\x40\x6B\xA0\xB6\x90\xC0\x37\xB1\x41\x3A\x40\x3C\xB8\x9F\x19\xBA\x12\x00\x80\xDE\x90\xFE\x85\x0C\x1D\x46\x41\x80\x7E\xFF\x42\x86\x1B\x40\xC8\x88\xFE\x85\xBC\x63\x08\x21\x46\x9A\x4B\x38\x72\xD4\xBB\x3D\x0E\xD9\xD8\x04\x42\xDE\xE3\xA8\xA2\x91\xA3\x4D\xCD\x04\x31\xF4\xCD\x01\xB0\x18\xC3\x11\x2D\xAD\x20\x64\x2C\x47\x1D\x37\x1E\x00\x6B\x1B\x21\x90\xF7\x61\x3A\xDB\x09\x6C\xD1\xCE\x1E\xAA\x1F\xB0\x45\x87\x89\x50\x74\x14\x02\xB1\x13\xC3\x50\x27\x8E\xE8\x0C\xC5\x49\x2C\x4D\xEA\xA2\x03\xC5\xC9\x42\x20\x84\x2B\x0C\x15\xB3\x6F\xCB\x14\x3D\x28\xBA\xB1\xB4\xA9\xE3\xA1\xE6\x6E\x26\x08\xE2\xE1\x09\x83\xA7\x39\x30\x35\x2F\xA4\x4D\x67\x4A\xBA\x33\xA0\x04\x66\x0A\x62\x10\xDE\x1F\xA2\x68\x1F\xA6\x36\x02\x49\xB3\x18\x8A\xD4\xC3\x17\x4A\x7E\xB3\x85\x41\x88\x39\x28\xA3\xFF\x5C\x86\xF4\x11\x92\xE6\x31\x14\xCB\x00\x24\xCD\x17\xFC\xA8\xF9\x18\xC5\x07\x32\xE2\x83\x90\xB2\x40\x21\x04\x2F\x44\x4A\xC8\x27\x42\x19\x44\x28\xBA\x03\x16\x8B\x14\xCA\x62\x94\x32\x4C\x21\x8C\x45\x02\x08\x17\xCC\x90\xDD\x95\x08\x85\xB2\x04\x09\x91\xF2\x76\x14\xF6\x88\x8E\x11\x0E\x21\xC6\xC4\x42\x8B\x53\x08\x4B\x91\xF0\xA9\xBC\x1D\x9F\x90\xE8\x96\xE4\xF8\x59\x72\x1F\x18\x6F\xED\x7F\x63\x52\xE3\x50\xDB\x65\x83\x44\xB2\x66\x82\xA9\x9B\x13\x49\x92\x29\xCB\x23\xB1\x05\xA6\xA6\xA5\xF3\xB4\x88\x40\x18\xA0\xB5\xE2\x73\x97\x95\x19\x6C\x86\xFE\x74\x77\xAA\x57\xDB\x7B\xE1\x96\x03\x69\x0F\x34\x61\xAB\x18\x7D\x7C\xC8\x94\xF9\xAB\x32\x91\xBA\x1A\x0B\x6E\x62\x8D\x30\xA8\x27\xB5\xB7\x8C\x61\xB6\x60\x0D\xAD\x19\xAC\xC5\xCA\x3A\x0D\x31\x80\xF3\x7A\x9C\xD0\x7B\x83\xBF\x4C\xB2\x5A\x42\x63\xFD\xD5\x05\xBE\x91\x85\xA2\x7C\x1B\xCD\xE5\x42\xD6\x26\xD9\xB9\x19\xF0\xCB\x10\xB0\x79\x4B\x76\x8E\xC2\x22\xB2\xD3\x72\xD3\x17\x6E\xCD\x9B\x98\xBF\x25\xEB\x8B\x02\xEC\xB2\x0D\xE5\x93\x47\x78\x92\x51\xF2\x9B\x54\xC8\x07\x61\xA1\xF6\x6D\x14\x8B\x9D\x52\x98\x10\xCF\xED\x45\x0C\x0F\x5E\x7D\xCB\x7A\x07\x0F\x48\x31\x03\xE2\xB7\x73\x17\xD3\x83\x57\xE7\x2A\xD9\xA5\x34\x3B\x1B\xA2\x25\x87\x18\x6A\x71\x0A\x65\x3E\x0C\x20\x11\x29\xC9\xCD\x85\x04\xA2\x06\xF5\x8A\xCB\x32\xD2\xE5\x78\xF0\x82\xEC\x56\xC7\x90\x41\xF6\xA0\xC6\xDE\xD2\xD5\x5C\x04\x4F\xC8\x3E\x3E\x90\xFD\xA8\x51\x76\x40\x89\x07\x2F\xC8\x41\x3E\x90\xED\xAA\x3D\x78\x41\x0E\xF1\x81\xA4\xF6\x11\x12\x0D\x3D\x63\xE2\x0E\x1F\x11\x89\xCA\x2B\x66\x0E\x25\x2A\xC3\x4B\x8D\xE3\x35\x0D\x29\x80\x9E\xB9\x85\x3A\x55\xD5\xC3\xFD\x80\xD5\x72\x62\x52\xA6\x78\x8D\x62\x42\x41\x43\x72\xFA\x08\x91\x48\x29\xCF\x2F\x01\x30\xA9\x39\x7A\x0C\x96\x75\xC7\xA9\x9F\xB5\x5C\xC8\x89\xBE\x42\xE0\x38\xB1\xFC\x2A\x2B\xD6\x41\x64\x63\x10\xB8\x96\x98\xBD\xA0\xC4\x67\x82\xA6\x21\x75\x6A\x8B\x5C\x0D\x41\x02\x82\xFF\x05\x48\x88\xDA\x45\x0E\x1A\x82\x0B\xD9\xF1\xC3\xAA\x4A\x0A\xEA\xF7\x35\xB8\x9E\x9C\x91\xDE\xB8\x67\xDE\xA9\xA6\xD3\x4B\x45\xFC\x20\x67\x1C\x78\x40\xB2\x55\x1C\xB4\xA1\x1B\x3F\x88\xFB\x59\x1E\x90\x34\x55\x57\x66\x95\x4A\x88\x39\xAA\x79\xF6\xE2\xC6\xB9\x28\x1E\x90\x74\x55\x10\x13\x55\x90\xCC\xF3\x28\x44\x82\x5B\x17\xD4\x2E\xA4\xF4\x06\x89\x56\x05\xB9\x38\x81\x09\x11\x5F\xCA\x6B\x6E\x19\xCD\xB0\x96\xC9\xDB\x66\x91\x49\x5F\xA7\x6C\xB8\xDC\xDC\xBA\xD1\x96\x03\x11\x5B\xB4\x5D\x71\x2F\x91\x48\x0E\xBB\xE6\x5F\x6D\xBD\x66\xDA\x14\xA3\x02\xD2\x6E\x44\x5C\x2F\x52\x40\x78\x59\x23\x82\x1C\xF5\x56\xD2\xDD\x95\x07\xB4\x4A\x45\xE1\x37\x04\x41\x94\x9A\xCC\xC5\x6A\xF3\xAC\xB8\x8E\xCA\xA8\x51\xA8\x51\x65\x46\x94\x5F\x18\xCB\x80\x18\xEE\x27\x6F\xE6\x9A\x50\xDD\xAC\x99\x24\xB3\x9D\xA9\x6E\xB1\x35\x29\xE9\x96\x0E\x35\x4A\xC3\x48\xF2\xB6\x2F\x5F\x48\xBD\x11\x7E\x8D\xD7\xC0\x86\xAF\x87\x94\xB8\x03\xEE\x32\x20\xF7\xE0\x3E\x12\x80\x32\xB8\x0D\x03\x7A\x41\xD4\x46\xBA\x05\xB4\x75\xC0\xF6\x49\xEC\x93\xDB\x1B\xA4\x74\x28\x6E\x49\xBF\x81\xAD\xFB\xC1\x44\x67\x3B\x58\xC4\x80\xA0\xC5\xAD\x2E\x00\x3A\xF1\xD6\x1F\xD5\xBD\x81\xA0\x1B\x3D\x09\x22\xB1\xCF\x83\x5E\x20\x7A\xB0\xA0\xDC\x71\xF9\xA1\x44\xD2\x4E\xB5\x2A\x3A\x08\xDD\x13\x78\x69\x4E\x06\x81\x67\x45\x3C\x02\x00\x4D\x3E\x1F\xD3\xD5\xCB\x6D\xB0\xAA\x12\x6E\xB5\xF8\x41\xF2\xA8\x1F\xDA\xF7\xE9\x84\x99\xCD\x54\x1E\x67\x36\xE4\x11\x74\x6D\x02\xE0\x09\xDC\x2E\xA1\xEB\xB0\x5B\x74\xD1\x97\x8D\x7D\xD2\x7A\x81\xC0\x4B\x7E\x4F\xD6\x05\xFC\x6B\x08\x22\x15\xB0\x21\xA7\x6A\x29\x73\x02\x20\xDC\x4C\xBF\xBA\xA6\x11\x54\x94\x0D\xAF\x5E\x5A\x74\x08\x98\x07\x41\x9D\x9E\x18\x5C\xED\x05\x72\x9A\xBA\x1B\x0D\x32\xC8\x64\x6A\x86\xE1\x2A\x91\x48\xEC\xA8\xBD\x79\x12\x13\x15\x1D\xB6\xA7\xE1\x07\xE4\x01\x65\x6F\x05\xB4\x7F\x1C\x35\x3B\xAA\xA3\x7D\xCD\xD9\xCF\xA9\xC1\xBC\x21\xF8\x51\xDF\xB0\xDC\x58\x05\x04\xCE\x5F\x02\x69\xDF\xA7\xEC\xFD\x37\x91\xA8\x53\x25\x09\xF8\x96\xDA\x7A\x76\x4B\x4A\x2C\xA0\x60\x20\xA9\x6B\xA3\x36\xCE\x25\x92\xEE\x0A\x3A\x10\xD7\x5D\x56\xA0\xDD\xAD\x47\x79\x8E\xF6\xC3\x05\xB2\x8C\x76\xEC\xDB\x10\x4B\x1B\xEC\xD5\x46\xB1\xDF\x21\xB1\x39\x46\x5A\x69\x33\x0D\x00\xC7\xB3\xC4\xF5\xE4\x6E\x00\xBE\xAF\x15\xE9\x06\xED\x05\xBE\xE7\xE3\x89\x1D\xCF\xDA\x70\x20\x5E\x7F\x84\x87\xF0\xC3\x5D\x65\x90\x68\xD8\x25\xCB\x1F\x5A\xB1\x4E\x1F\xDE\xF8\x83\xF4\x6F\x38\xF8\x88\xD5\x00\xA0\x3A\x28\x14\xF8\xA1\x5A\x74\x06\xB0\x46\xC3\x2B\x15\xFB\xE0\x15\x1D\x3C\xA9\x0A\xEB\xE8\x09\x11\xFF\x08\x7F\xCE\x1D\xF0\x3C\x36\x96\x05\x91\xCA\x7A\xD7\x63\xB8\x3F\x19\x80\xA9\x70\xFB\x02\x04\xA0\x9A\x7A\x3F\x3D\x4E\xE8\xDB\x86\xD7\xA6\x86\xE1\x46\x48\x53\x30\x17\x02\xCE\x58\xD2\x4D\x11\xFB\x4C\x64\x90\xC5\x70\x5F\x17\x3D\x5E\x64\x83\x31\x82\x1E\xF9\x3F\x61\x9F\x15\x28\x41\xB7\x2C\x3C\xFD\xA5\x94\x03\x01\x75\x03\xF1\x1B\xD6\x4C\x39\xA4\x0B\xEE\xF3\x01\xE0\x67\xB8\x7D\x05\xAE\xA0\xD5\xC2\x3C\x70\x0C\xF5\x44\x7A\x14\x87\xA3\x04\x97\xE5\xF3\xC3\xAA\x04\x2E\x04\x00\xFB\x89\xC5\x24\x19\xF6\x0B\x50\x6A\x05\x17\x29\x2B\x01\xE0\xD7\xAD\xD9\x39\xE9\xD4\xAD\x0B\x89\xC8\x79\x90\x6F\x08\x7C\x2F\x41\xDD\x10\xFB\xBC\xC2\x09\x2D\x9F\xCA\xBA\x1B\x28\x9E\xCB\x85\xF4\xD5\x3C\x9F\xD0\x19\x77\x25\x94\x66\xD2\x5A\x3E\x3D\x0D\xB4\xD6\x14\x64\x8D\x97\xFC\xEA\x54\x27\xD6\xD1\x53\x51\x7A\x79\xEF\x74\xB7\xFA\x58\xDE\xD6\xC8\x2C\x65\x8F\x5C\xC3\x07\x2F\xFB\x40\x30\xD5\xBD\x4F\xB9\xC5\x15\x15\x15\x85\x06\x7E\x55\xBF\xD9\xB1\x46\x06\x61\xD6\xB2\xCF\xB0\x30\x57\x3E\x6B\x1E\x11\xDB\x17\x6B\x4A\x7E\xFD\xFA\xC5\xA6\x91\x4A\x66\x8A\xDA\x9D\x71\xF1\x3D\xD5\xB7\xF6\x5F\x31\x6F\x17\x92\x24\x9D\x7C\x18\x8B\xFD\x2F\x49\x68\xBF\x2B\x84\x3F\xA0\x0B\x39\x5D\x6D\x55\xAE\xDE\x12\xD1\x77\x24\xF1\x33\x85\xF2\x02\xF5\xDD\xF9\x0A\xE1\x39\xEE\xCD\xA6\xC2\x21\xA5\x28\xC1\x6E\x6F\x85\x62\x83\x94\x14\x85\xA0\xBD\x0C\x29\xD1\x6A\x67\x31\xEA\x6C\x10\x8A\xF7\x65\x7E\xBA\x2C\x47\x52\x12\x43\xE9\x44\xAF\x2A\x4F\x37\x6E\x30\x4F\xBB\x8E\x0F\xD2\x91\xB9\x16\xD5\xF3\x73\xD3\x90\xE3\x48\xAA\x57\xB6\x78\xC3\xC3\x6E\xA0\x3B\x72\xC1\x92\xA9\x79\xA1\xA7\x5F\x0B\x53\x8A\xA9\x47\x14\x0F\x61\x90\x3F\x51\xF0\x24\x29\x53\xCB\x40\x65\xBC\x0B\xCB\xEF\x39\x02\xAF\x13\xF4\x57\x80\xB5\xE8\x44\x6C\xD9\x6B\x05\x45\x68\xDD\x32\x91\xA5\x69\x47\x40\xCD\xBE\x4B\x08\x64\x25\x0C\x3D\x57\xCB\x16\xF1\xB7\x5F\xCE\xA5\xE9\x40\xAF\x8C\x40\x21\x90\x32\x18\x39\x87\x23\x76\xA0\xF2\x6E\x27\x47\xFD\x8B\xBA\x60\x3A\xA1\x42\x20\xBA\x91\x56\x86\x4E\xDC\x85\x95\x1A\x34\xF1\xE6\x7C\x60\x26\x1C\xFE\x0E\x28\xBD\xA7\xB9\xBF\x67\x1C\x41\x25\xE3\x7A\x8D\xE5\x53\x6A\xD5\x7E\x10\xA2\xC1\x7F\x16\x28\x33\xFC\x47\x0C\xCB\xDE\x1D\xFB\x62\xBA\x70\x96\xE1\xAB\x76\xD1\x5B\x03\x56\x4C\x41\xA6\xF5\x33\x83\x88\x69\x4D\xBF\x93\xD1\xBB\x9B\xDC\xFE\x01\x51\x90\x30\x2B\x44\x5E\xBA\x6C\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(32, 27))

    local function calc_dist(pos1, pos2)
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
    end

    local hitted, reg_shot = 0, 0

    local function render_indicators(text, colors, ind_dst, img)
        local ts = render.measure_text(calibri, "bad", text)
        local x = 28
        local y = y - 350
        
        if elements.other.visuals.side_indicators.side_indicators_type:get() == "Modern" then
            if img then
                render.rect(vector(19, y - 350 - ind_dst + 350), vector(32 + (render.measure_text(calibri, "bad", text).x), (y - 345 - ind_dst) + 28 + 350), color(0, 0, 0, 100), 8)
                render.rect_outline(vector(18, y - 350 - ind_dst + 350), vector(33 + (render.measure_text(calibri, "bad", text).x), (y - 345 - ind_dst) + 28 + 350), color(0,0,0, 12), 1, 8)
                render.text(calibri, vector(26, (y - 343) - ind_dst + 350), color(0, 0, 0, 150), "bad", text)
                render.text(calibri, vector(25, (y - 344) - ind_dst + 350), colors, "bad", text)
            else
                render.rect(vector(19, y - 350 - ind_dst + 350), vector(32 + (render.measure_text(calibri, "bad", text).x), (y - 345 - ind_dst) + 28 + 350), color(0, 0, 0, 100), 8)
                render.rect_outline(vector(18, y - 350 - ind_dst + 350), vector(33 + (render.measure_text(calibri, "bad", text).x), (y - 345 - ind_dst) + 28 + 350), color(0,0,0, 12), 1, 8)
                render.text(calibri, vector(25, (y - 344) - ind_dst + 350), colors, "bad", text)
            end
        else
            if img then
                render.gradient(vector(5, y + 3 - ind_dst), vector(x + ((img.width) + (ts.x)) / 2 + 3, y + 37 - ind_dst), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50))
                render.gradient(vector(x + ((img.width) + (ts.x)) / 2 + 3, y + 3 - ind_dst), vector(x + (ts.x) + (img.width) + 29, y + 37 - ind_dst), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0))
                render.texture(img, vector(x, y + 6 - ind_dst), colors)
                render.text(calibri, vector(x + (img.width) + 6, y + 10 - ind_dst), colors, "bad", text)
            else
                render.gradient(vector(5, y + 3 - ind_dst), vector(x + (ts.x) / 2, y + 37 - ind_dst), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50))
                render.gradient(vector(x + (ts.x) / 2, y + 3 - ind_dst), vector(x + (ts.x) + 23, y + 37 - ind_dst), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0))
                render.text(calibri, vector(x, y + 4 - ind_dst + 5), colors, "bad", text)
            end
        end
    end

    get_bind = function(name)
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
    visuals.render = function()
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        if elements.other.visuals.anti_aim_arrows:get() then
            local scoped_arrows = animations.new("scoped_arrows", lp.m_bIsScoped and 100 or 255, 5)
            
            render.text(verdana, vector(x / 2 - 47, y / 2), elements.antiaim.main.manual_yaw:get() == "Left" and color(elements.other.visuals.anti_aim_arrows.accent_color:get().r, elements.other.visuals.anti_aim_arrows.accent_color:get().g, elements.other.visuals.anti_aim_arrows.accent_color:get().b, scoped_arrows) or color(100, 100, 100, scoped_arrows), "c", "❰" )
            render.text(verdana, vector(x / 2 + 43, y / 2), elements.antiaim.main.manual_yaw:get() == "Right" and color(elements.other.visuals.anti_aim_arrows.accent_color:get().r, elements.other.visuals.anti_aim_arrows.accent_color:get().g, elements.other.visuals.anti_aim_arrows.accent_color:get().b, scoped_arrows) or color(100, 100, 100, scoped_arrows), "c", "❱")
        end

        if elements.other.visuals.crosshair_indicators:get() then
            local scope = animations.new("scope", lp.m_bIsScoped and 1 or 0, 10)

            local invincible_size = render.measure_text(4, "c", "invincible°")

            local scoped_invincible = animations.new("scoped_invincible", lp.m_bIsScoped and 100 or 255, 10)

            local gradient_text = gradient.text_animate("invincible°", -1, { color(elements.other.visuals.crosshair_indicators.accent_color:get().r, elements.other.visuals.crosshair_indicators.accent_color:get().g, elements.other.visuals.crosshair_indicators.accent_color:get().b, scoped_invincible),  color(25, 25, 25, scoped_invincible) })
            render.text(4, vector(x / 2 + ((invincible_size.x / 2 + 2) * scope), y / 2 + 25), color(255), "c", gradient_text:get_animated_text())
            gradient_text:animate()

            local add_y_key = animations.new("add_y_key", (refs.doubletap:get() or refs.hide_shots:get()) and 10 or 0, 10)
            
            local alpha_dt = animations.new("alpha_dt", (refs.doubletap:get()) and 255 or 0, 5)
            local alpha_hide_shots = animations.new("alpha_hide_shots", (refs.hide_shots:get() and not refs.doubletap:get()) and 255 or 0, 10)

            local alpha_dt_scoped = animations.new("alpha_dt_scoped", lp.m_bIsScoped and (refs.doubletap:get() and 100 or 0) or 255, 10)
            local alpha_hide_shots_scoped = animations.new("alpha_hide_shots_scoped", refs.hide_shots:get() and (lp.m_bIsScoped and ((refs.hide_shots:get() and not refs.doubletap:get()) and 100 or 0) or 255) or 0, 10)

            local scoped_doubletap = animations.new("scoped_hideshots", lp.m_bIsScoped and alpha_dt_scoped or alpha_dt, 10)
            local scoped_hideshots = animations.new("scoped_doubletap", lp.m_bIsScoped and alpha_hide_shots_scoped or alpha_hide_shots, 10)
    
            local dt_size = render.measure_text(2, "c", "DT")
            local os_aa_size = render.measure_text(2, "c", "OS-AA")

            render.text(2, vector(x / 2 + ((dt_size.x / 2 + 2) * scope), y / 2 + 25 + add_y_key), color(255, 255, 255, scoped_doubletap), "c", "DT")
            render.text(2, vector(x / 2 + ((os_aa_size.x / 2 + 2) * scope), y / 2 + 25 + add_y_key), color(255, 255, 255, scoped_hideshots), "c", "OS-AA")
        end

        if elements.other.visuals.damage_indicator:get() then          
            local is_rect_dragged = window.is_dragged
            local is_rect_drawing = ui.get_alpha() > 0.0

            local rect_alpha = animations.new("damage_indicator_alpha", is_rect_drawing and (is_rect_dragged and 0.5 or 1.0) or 0.0, 10)

            local damage_text = tostring(refs.minimum_damage:get())
            local damage_scope_alpha = animations.new("damage_scope_alpha", lp.m_bIsScoped and 100 or 255, 10)

            local pos = window:get_pos()
            local text = math.floor(damage_text)

            local text_flags = "cs"

            local text_size = render.measure_text(elements.other.visuals.damage_indicator.font:get() == "Verdana" and 1 or 2, text_flags, text)
            local rect_size = text_size + vector(4.0, 4.0) * 2.0 + vector(1, 0)

            local text_pos = pos + rect_size * 0.5 + vector(1, 0)

            local rect_color = color(200, 200, 200, 128)
            rect_color.a = rect_color.a * rect_alpha

            render.rect_outline(pos, pos + rect_size, rect_color, 1, 4)
            render.text(elements.other.visuals.damage_indicator.font:get() == "Verdana" and 1 or 2, text_pos, color(255, 255, 255, damage_scope_alpha), text_flags, text)

            window:set_size(rect_size)
        end

        if elements.other.visuals.scope_overlay:get() then
            refs.scope_overlay:set("Remove All")

            local position = animations.new("position", lp.m_bIsScoped and elements.other.visuals.scope_overlay.position:get() or 0, 10) 
            local offset = animations.new("offset", lp.m_bIsScoped and elements.other.visuals.scope_overlay.offset:get() or 0, 10) 

            local scope_color_x = color(elements.other.visuals.scope_overlay.accent_color:get().r, elements.other.visuals.scope_overlay.accent_color:get().g, elements.other.visuals.scope_overlay.accent_color:get().b, elements.other.visuals.scope_overlay.inverted:get() and 0 or elements.other.visuals.scope_overlay.accent_color:get().a)
            local scope_color_y = color(elements.other.visuals.scope_overlay.accent_color:get().r, elements.other.visuals.scope_overlay.accent_color:get().g, elements.other.visuals.scope_overlay.accent_color:get().b, elements.other.visuals.scope_overlay.inverted:get() and 255 or 0)
            
            render.gradient(vector(x / 2 - offset, y / 2), vector(x / 2 - offset - position, y / 2 + 1), scope_color_x, scope_color_y, scope_color_x, scope_color_y)
            render.gradient(vector(x / 2 + offset, y / 2), vector(x / 2 + offset + position, y / 2 + 1), scope_color_x, scope_color_y, scope_color_x, scope_color_y)
            render.gradient(vector(x / 2, y / 2 + offset), vector(x / 2 + 1, y / 2 + offset + position), scope_color_x, scope_color_x, scope_color_y, scope_color_y)

            if not elements.other.visuals.scope_overlay.t_style:get() then
                render.gradient(vector(x / 2, y / 2 - offset), vector(x / 2 + 1, y / 2 - offset - position), scope_color_x, scope_color_x, scope_color_y, scope_color_y)
            end
        else
            refs.scope_overlay:set("Remove Overlay")
        end

        if elements.other.visuals.hit_marker:get() then
            local dt = globals.frametime
            local time = globals.realtime

            for i = #draw_list, 1, -1 do
                local data = draw_list[i]

                if time > data.time then
                    table.remove(draw_list, i)
                end
            end

            for i = 1, #draw_list do
                local data = draw_list[i]

                local alpha = 1.0
                local liferemaining = data.time - time

                if liferemaining < 0.5 then
                    alpha = liferemaining / 0.5
                end

                local screen = render.world_to_screen(data.point)

                if screen ~= nil then
                    local animated_circle = animations.new("animated_circle", liferemaining < 0.5 and 0 or 10, 3)
                    render.circle_outline(vector(screen.x, screen.y), color(elements.other.visuals.hit_marker.accent_color:get().r, elements.other.visuals.hit_marker.accent_color:get().g, elements.other.visuals.hit_marker.accent_color:get().b, 150), animated_circle, 0, 1)
                end
            end
        else
            for i = 1, #draw_list do
                draw_list[i] = nil
            end
        end

        if elements.other.visuals.side_indicators:get() then
            local ind_dst = 0
            local ind_spr = 41

            local x = 28
            local y = y - 350
        
            local percent = hitted > 0 and reg_shot > 0 and (hitted / reg_shot) * 100 or 0
            render_indicators(string.format("%d/%d (%.1f)", hitted, reg_shot, percent), color(215, 215, 215, 255), ind_dst)
            ind_dst = ind_dst + ind_spr

            if (elements.other.ragebot.fake_latency:get() and elements.other.ragebot.fake_latency.amount:get() > 0 or refs.fake_latency:get() > 0) then
                render_indicators("PING", color(150, 189, 18, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            if refs.doubletap:get() then
                render_indicators("DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            elseif refs.hide_shots:get() and not refs.doubletap:get()  then
                render_indicators("OSAA", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
            
            if refs.freestanding:get() then
                render_indicators("FS", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            if refs.body_aim:get() == "Force" then
                render_indicators("BODY", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            if get_bind("Min. Damage")[1] then
                render_indicators("MD", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            if get_bind("Hit Chance")[1] then
                render_indicators("HC", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
                
            if refs.fake_duck:get() then
                render_indicators("DUCK", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            local dormant_work = #entity.get_players(true, false) ~= #entity.get_players(true, true)
            if refs.dormant_aimbot:get() then
                if dormant_work then
                    render_indicators("DA", color(215, 215, 215, 255), ind_dst)
                else
                    render_indicators("DA", color(255, 0, 0, 255), ind_dst)
                end
                ind_dst = ind_dst + ind_spr
            end
        
            if refs.safe_points:get() == "Force" then
                render_indicators("SAFE", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            local c4 = entity.get_entities("CPlantedC4")[1];
            if c4 ~= nil then
                local time = ((c4.m_flC4Blow - globals.curtime) * 10) / 10
                local defused = c4.m_bBombDefused

                if math.floor(time) >= -1 and not defused then
                    local defusestart = c4.m_hBombDefuser ~= 4294967295
                    local defuselength = c4.m_flDefuseLength
                    local defusetimer = defusestart and math.floor((c4.m_flDefuseCountDown - globals.curtime) * 10) / 10 or -1

                    if defusetimer > 0 and not abort_defuse then
                        local col = math.floor(time) > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)
                        local barlength = (((y - 50) / defuselength) * (defusetimer))
                        render.rect(vector(0, 0), vector(16, y), color(25, 25, 25, 160))
                        render.rect(vector(0, y - barlength), vector(16, y), col)
                    end

                    local bombsite = c4.m_nBombSite == 0 and "A" or "B"
                    local health = lp.m_iHealth
                    local armor = lp.m_ArmorValue
                    local will_die = false
                    local eLoc = c4.m_vecOrigin
                    local lLoc = lp.m_vecOrigin
                    local distance = calc_dist(eLoc, lLoc)
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
                        will_die = true
                    else
                        will_die = false
                    end

                    if time > 0.01 then
                        render_indicators(bombsite .. " - " .. string.format("%.1f", time >= 0 and time or 0) .. "s", color(215, 215, 215, 255), ind_dst, bomb_img)
                        ind_dst = ind_dst + ind_spr
    
                        if will_die then
                            render_indicators("FATAL", color(255, 0, 0, 255), ind_dst)
                            ind_dst = ind_dst + ind_spr
                        elseif damage > 0.5 then
                            render_indicators("-" .. dmg .. " HP", color(255, 240, 100, 255), ind_dst)
                            ind_dst = ind_dst + ind_spr
                        end
                    end
                end
            end
    
            if bomb.state == false then
                render_indicators(bomb.site, color(255, 240, 100, 255), ind_dst, bomb_img)
                ts = render.measure_text(calibri, "bad", bomb.site) + vector(20, 0)
                if elements.other.visuals.side_indicators.side_indicators_type:get() ~= "Modern" then
                    render.circle_outline(vector(x + ts.x + 32, y + ts.y/2 - ind_dst + 9), color(0, 0, 0, 255), 9.5, 0, 1, 4)
                    render.circle_outline(vector(x + ts.x + 32, y + ts.y/2 - ind_dst + 9), color(255, 255, 255, 255), 9, 0, bomb.plant_percentage, 3)
                end
                ind_dst = ind_dst + ind_spr
            end
        end

        if not elements.other.visuals.crosshair_indicators:get() then
            local bottom_gradient_text = gradient.text_animate("I N V I N C I B L E", -2, { color(elements.home.accent_color:get().r, elements.home.accent_color:get().g, elements.home.accent_color:get().b, 255),  color(25, 25, 25, 255) })
            render.text(1, vector(x / 30, y - 530), color(255), "c", bottom_gradient_text:get_animated_text())
            bottom_gradient_text:animate()
        end
    end

    visuals.override_view = function(e)
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end
    
        local weapon = lp:get_player_weapon()
        if weapon == nil then return end
    
        local zoomlevel = weapon.m_zoomLevel
        local scoped = lp.m_bIsScoped

        if elements.other.visuals.scope_overlay:get() then
            local zoom_fov = 0
            if scoped then
                if zoomlevel == 1 then
                    zoom_fov = refs.override_zoom:get()
                elseif zoomlevel == 2 then
                    zoom_fov = refs.override_zoom:get() * 2
                end
            end
        
            e.fov = animations.new("animated_zoom", refs.field_of_view:get() - zoom_fov, 10)
        end
    end

    visuals.aim_ack = function(e)
        if e.state == nil then hitted = hitted + 1 end
        reg_shot = reg_shot + 1

        if e.state == nil then
            local time = globals.realtime + 1

            table.insert(draw_list, {
                time = time,
                point = e.aim,
            })
        end
    end
end

-- #endregion

-- #region : Misc
local clantag = {} do
    clantag.time_to_ticks = function(t) return math.floor(t / globals.tickinterval + 0.5) end
    clantag.vars = {
        clantag_cache = "",
        set_clantag = function(self, tag)
            if tag ~= self.clantag_cache then
                common.set_clan_tag(tag)    
                self.clantag_cache = tag
            end
        end
    }
    clantag.animation = function(text, indices)
        local text_anim = "               " .. text .. "                      " 
        local netchann_info = utils.net_channel()
        if netchann_info == nil then return end
        local tickcount = globals.tickcount + clantag.time_to_ticks(netchann_info.latency[0] + 0.321)
        local i = tickcount / clantag.time_to_ticks(0.3)
        i = math.floor(i % #indices)
        i = indices[i+1]+1
        return text_anim:sub(i, i+15)
    end
    clantag.clan_tag_prev = ''
    clantag.executer = function()
        local local_player = entity.get_local_player()
        if not local_player then return end
        if elements.other.misc.clantag:get() then
            local clan_tag = clantag.animation("invincible", {0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23})
            local game_rules = entity.get_game_rules()
            if game_rules.m_gamePhase == 5 or game_rules.m_timeUntilNextPhaseStarts ~= 0 then
                clantag.vars:set_clantag(clantag.animation("invincible", {11}))
            end
            if clan_tag ~= clantag.clan_tag_prev then
                clantag.vars:set_clantag(clan_tag)
            end
            clantag.clan_tag_prev = clan_tag
        end
    end
end

elements.other.misc.clantag:set_callback(function(el) if not el:get() then common.set_clan_tag("\0") end end)
events.pre_render:set(clantag.executer)

local misc = { } do
    misc.render = function()
        local lp = entity.get_local_player()
        if lp == nil then return end

        if elements.other.misc.aspect_ratio:get() then
            local aspect_ratio_value = animations.new("aspect_ratio_value", elements.other.misc.aspect_ratio.amount:get() / 100, 5)
            cvar.r_aspectratio:float(aspect_ratio_value)
        else
            cvar.r_aspectratio:float(0)
        end

        local viewmodel_fov_value = animations.new("viewmodel_fov_value", elements.other.misc.viewmodel_changer:get() and elements.other.misc.viewmodel_changer.viewmodel_fov:get() / 10 or get_original(cvar.viewmodel_fov), 5)
        local viewmodel_x_value = animations.new("viewmodel_x_value", elements.other.misc.viewmodel_changer:get() and elements.other.misc.viewmodel_changer.viewmodel_x:get() / 10 or get_original(cvar.viewmodel_offset_x), 5)
        local viewmodel_y_value = animations.new("viewmodel_y_value", elements.other.misc.viewmodel_changer:get() and elements.other.misc.viewmodel_changer.viewmodel_y:get() / 10 or get_original(cvar.viewmodel_offset_y), 5)
        local viewmodel_z_value = animations.new("viewmodel_z_value", elements.other.misc.viewmodel_changer:get() and elements.other.misc.viewmodel_changer.viewmodel_z:get() / 10 or get_original(cvar.viewmodel_offset_z), 5)

        cvar.viewmodel_fov:float(viewmodel_fov_value, true)
        cvar.viewmodel_offset_x:float(viewmodel_x_value, true)
        cvar.viewmodel_offset_y:float(viewmodel_y_value, true)
        cvar.viewmodel_offset_z:float(viewmodel_z_value, true)
    end


    phrases = {
        "✮⋆˙ｉｎｖｉｎｃｉｂｌｅ.ｌｕａ✮⋆˙",
        "1 why bot walking?",
        "спиной тя лоха убил,прикупи луа мою не позорься",
        "⋆˚✿˖°1 ʀᴀᴘᴇᴅ ʏᴏᴜ⋆˚✿˖°",
        "1. ʏᴏᴜ ʙᴏʀɴ ᴛᴏ ᴅɪᴇ>ᴗ<",
        "1, научись брикать lc как я",
        "куда ты на короля полез? не по твоим шансам братуха",
        "даже боты на локалке играют лучше чем ты.",
        "Че папе че маме че бабке шлюхе?",
    }

    misc.player_death = function(e)
        local lp = entity.get_local_player()
        if lp == nil then return end

        local userid = entity.get(e.userid, true)
        local attacker = entity.get(e.attacker, true)

        if elements.other.misc.killsay:get() then
            if lp ~= userid and lp == attacker then
                utils.console_exec("say " .. phrases[math.random(#phrases)])
            end
        end
    end

    misc.create_move = function(cmd)
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        if elements.other.misc.no_fall_damage:get() then
            local state = false

            local MATH_TAU = math.pi * 2.0
            local TRACE_STEP = MATH_TAU / 8
            
            function trace_fall(player, length)
                local origin = player:get_origin()
        
                for i = 0, MATH_TAU, TRACE_STEP do
                    local sin = math.sin(i)
                    local cos = math.cos(i)
        
                    local x = origin.x + cos * 10
                    local y = origin.y + sin * 10
        
                    local start_pos = vector(x, y, origin.z)
        
                    local end_pos = start_pos:clone()
                    end_pos.z = end_pos.z - length
        
                    local trace = utils.trace_line(start_pos, end_pos, player)
        
                    if trace.fraction < 1.0 then
                        return true
                    end
                end
        
                return false
            end

            local velocity = lp.m_vecVelocity

            if velocity.z <= -500 then
                if trace_fall(lp, 15) then
                    state = false
                elseif trace_fall(lp, 75) then
                    state = true
                end

                cmd.in_duck = state
            end
        end

        if elements.other.misc.fast_ladder:get() then
            if lp.m_MoveType == 9 then
                if cmd.forwardmove > 0 then
                    if render.camera_angles().x < 45 then
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

    misc.post_update_clientside_animation = function()
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end
        if lp:get_index() == nil then return end

        animslsg = get_entity_address(lp:get_index())
    
        local animstate = lp:get_anim_state()
        if animstate == nil then return end
    
        move = math.sqrt(lp.m_vecVelocity.x ^ 2 + lp.m_vecVelocity.y ^ 2) > 5
        jump = bit.band(lp.m_fFlags, 1) == 0

        if elements.other.misc.animation_breakers.air_legs:get() == "Static" then
            lp.m_flPoseParameter[6] = 1
        elseif elements.other.misc.animation_breakers.air_legs:get() == "Jitter" then
            lp.m_flPoseParameter[6] = globals.tickcount % 4 > 0 and (globals.tickcount % 4 > 1 and utils.random_float(utils.random_float(0.1, 1.0), 1.0) or utils.random_float(0.1, 1.0)) or utils.random_float(0.1, 1.0)
        elseif elements.other.misc.animation_breakers.air_legs:get() == "Allah" and jump and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][6].m_flWeight = 1
        else
            lp.m_flPoseParameter[6] = 0
        end

        if elements.other.misc.animation_breakers.ground_legs:get() == "Reversed" then
            lp.m_flPoseParameter[0] = 1
            refs.legs_movement:set("Sliding")
        elseif elements.other.misc.animation_breakers.ground_legs:get() == "Jitter" then
            lp.m_flPoseParameter[0] = globals.tickcount % 4 and math.random(utils.random_float(elements.other.misc.animation_breakers.ground_legs_jitter_first_value:get() / 100, elements.other.misc.animation_breakers.ground_legs_jitter_second_value:get() / 100), 1.0) or utils.random_float(0.0, 1.0)
        elseif elements.other.misc.animation_breakers.ground_legs:get() == "Allah" and move and not jump then
            lp.m_flPoseParameter[7] = 1
            refs.legs_movement:set("Walking")
        else
            refs.legs_movement:set("Sliding")
        end
    
        if elements.other.misc.animation_breakers.addons:get("Pitch 0 On Land") and animstate.landing then
            lp.m_flPoseParameter[12] = 0.5
        elseif elements.other.misc.animation_breakers.addons:get("Move Lean") and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = 1
        elseif elements.other.misc.animation_breakers.addons:get("Earth Quake") then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = utils.random_float(0.1, 1)
        elseif elements.other.misc.animation_breakers.addons:get("Kangaroo") then
            lp.m_flPoseParameter[3] = math.random(0, 10) / 10
            lp.m_flPoseParameter[6] = math.random(0, 10) / 10
            lp.m_flPoseParameter[7] = math.random(0, 10) / 10
        end
    end

    misc.localplayer_transparency = function()
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        if elements.other.visuals.keep_model_transparency:get() then 
            return (lp.m_bIsScoped or lp.m_bResumeZoom) and 100 or 255
        end
    end
end

-- #endregion

-- #region : Configs

local config = pui.setup({elements.antiaim, elements.antiaim_builder, elements.other, elements.home.accent_color}, true)
local configsystem = { }
configdata = db.cfg_dbgxz2 or { }
configdata.cfg_list = configdata.cfg_list or {{'Default', 'W3siYnVpbGRlciI6eyJjb25kaXRpb25zIjoiU2hhcmVkIn0sIm1haW4iOnsiYXZvaWRfYmFja3N0YWIiOnRydWUsImRpc2FibGVycyI6dHJ1ZSwiZnJlZXN0YW5kaW5nIjp7ImZyZWVzdGFuZGluZ19rZXkiOmZhbHNlLCJzdGF0aWNfeWF3IjpmYWxzZX0sIm1hbnVhbF95YXciOnsiaWdub3JlX2ZyZWVzdGFuZGluZyI6ZmFsc2UsIm1hbnVhbF9lZGdlIjpmYWxzZSwic2VsZWN0X21hbnVhbF95YXciOiJEaXNhYmxlZCIsInN0YXRpY19tYW51YWxzIjpmYWxzZX0sInNhZmVfaGVhZCI6dHJ1ZSwic21hcnRfdGVsZXBvcnQiOmZhbHNlLCJ+ZGlzYWJsZXJzIjp7InNlbGVjdCI6WzEuMCwifiJdfSwifnNhZmVfaGVhZCI6eyJzZWxlY3QiOlsxLjAsMi4wLCJ+Il19fX0sW3siYm9keV95YXciOnRydWUsImJvZHlfeWF3X2xlZnRfbGltaXQiOjYwLjAsImJvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjowLjAsImJvZHlfeWF3X3JpZ2h0X2xpbWl0Ijo2MC4wLCJkZWZlbnNpdmVfc2V0dXAiOmZhbHNlLCJmb3JjZV9sYyI6ZmFsc2UsImppdHRlcl9kZWxheSI6NC4wLCJzdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXciOiJEZWZhdWx0IiwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwieWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwifmRlZmVuc2l2ZV9zZXR1cCI6eyJlX3NwYW0iOnRydWUsInBpdGNoIjoiRGlzYWJsZWQiLCJwaXRjaF9jdXN0b20xIjowLjAsInBpdGNoX2N1c3RvbTIiOjAuMCwicGl0Y2hfcmFuZG9tMSI6MC4wLCJwaXRjaF9yYW5kb20yIjowLjAsInBpdGNoX3N3YXlfc3BlZWQiOjEwLjAsInlhdyI6IlNwaW4iLCJ5YXdfY3VzdG9tMSI6MC4wLCJ5YXdfY3VzdG9tMiI6MC4wLCJ5YXdfcmFuZG9tMSI6MC4wLCJ5YXdfcmFuZG9tMiI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTAuMH19LHsiYm9keV95YXciOnRydWUsImJvZHlfeWF3X2xlZnRfbGltaXQiOjYwLjAsImJvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjoxMC4wLCJib2R5X3lhd19yaWdodF9saW1pdCI6NjAuMCwiZGVmZW5zaXZlX3NldHVwIjpmYWxzZSwiZm9yY2VfbGMiOmZhbHNlLCJqaXR0ZXJfZGVsYXkiOjEuMCwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJEZWZhdWx0IiwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19tb2RpZmllcl9vZmZzZXQiOi01MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwifmRlZmVuc2l2ZV9zZXR1cCI6eyJlX3NwYW0iOmZhbHNlLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tMSI6MC4wLCJwaXRjaF9jdXN0b20yIjowLjAsInBpdGNoX3JhbmRvbTEiOjAuMCwicGl0Y2hfcmFuZG9tMiI6MC4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxLjAsInlhdyI6IlNpZGV3YXlzIiwieWF3X2N1c3RvbTEiOjAuMCwieWF3X2N1c3RvbTIiOjAuMCwieWF3X3JhbmRvbTEiOjAuMCwieWF3X3JhbmRvbTIiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMH19LHsiYm9keV95YXciOnRydWUsImJvZHlfeWF3X2xlZnRfbGltaXQiOjYwLjAsImJvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjoxOS4wLCJib2R5X3lhd19yaWdodF9saW1pdCI6NjAuMCwiZGVmZW5zaXZlX3NldHVwIjp0cnVlLCJmb3JjZV9sYyI6dHJ1ZSwiaml0dGVyX2RlbGF5IjoxLjAsInN0YXRlX2VuYWJsZSI6dHJ1ZSwieWF3IjoiRGVmYXVsdCIsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfbW9kaWZpZXIiOiJTcGluIiwieWF3X21vZGlmaWVyX29mZnNldCI6LTUuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsIn5kZWZlbnNpdmVfc2V0dXAiOnsiZV9zcGFtIjpmYWxzZSwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20xIjotNzcuMCwicGl0Y2hfY3VzdG9tMiI6LTEyLjAsInBpdGNoX3JhbmRvbTEiOi03Ny4wLCJwaXRjaF9yYW5kb20yIjotMTIuMCwicGl0Y2hfc3dheV9zcGVlZCI6MS4wLCJ5YXciOiJSYW5kb20iLCJ5YXdfY3VzdG9tMSI6LTc3LjAsInlhd19jdXN0b20yIjotMTIuMCwieWF3X3JhbmRvbTEiOi03Ny4wLCJ5YXdfcmFuZG9tMiI6LTEyLjAsInlhd19zcGluX3NwZWVkIjoxLjB9fSx7ImJvZHlfeWF3Ijp0cnVlLCJib2R5X3lhd19sZWZ0X2xpbWl0Ijo2MC4wLCJib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciIsIn4iXSwiYm9keV95YXdfcmFuZG9taXphdGlvbiI6MTQuMCwiYm9keV95YXdfcmlnaHRfbGltaXQiOjYwLjAsImRlZmVuc2l2ZV9zZXR1cCI6ZmFsc2UsImZvcmNlX2xjIjpmYWxzZSwiaml0dGVyX2RlbGF5IjoxLjAsInN0YXRlX2VuYWJsZSI6dHJ1ZSwieWF3IjoiRGVmYXVsdCIsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjotNTguMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsIn5kZWZlbnNpdmVfc2V0dXAiOnsiZV9zcGFtIjp0cnVlLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tMSI6MC4wLCJwaXRjaF9jdXN0b20yIjowLjAsInBpdGNoX3JhbmRvbTEiOjAuMCwicGl0Y2hfcmFuZG9tMiI6MC4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxLjAsInlhdyI6IlNpZGV3YXlzIiwieWF3X2N1c3RvbTEiOjAuMCwieWF3X2N1c3RvbTIiOjAuMCwieWF3X3JhbmRvbTEiOjAuMCwieWF3X3JhbmRvbTIiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMH19LHsiYm9keV95YXciOnRydWUsImJvZHlfeWF3X2xlZnRfbGltaXQiOjYwLjAsImJvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjowLjAsImJvZHlfeWF3X3JpZ2h0X2xpbWl0Ijo2MC4wLCJkZWZlbnNpdmVfc2V0dXAiOnRydWUsImZvcmNlX2xjIjp0cnVlLCJqaXR0ZXJfZGVsYXkiOjEuMCwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJEZWZhdWx0IiwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwieWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwifmRlZmVuc2l2ZV9zZXR1cCI6eyJlX3NwYW0iOmZhbHNlLCJwaXRjaCI6IlN3YXkiLCJwaXRjaF9jdXN0b20xIjowLjAsInBpdGNoX2N1c3RvbTIiOjAuMCwicGl0Y2hfcmFuZG9tMSI6MC4wLCJwaXRjaF9yYW5kb20yIjowLjAsInBpdGNoX3N3YXlfc3BlZWQiOjEuMCwieWF3IjoiT3Bwb3NpdGUiLCJ5YXdfY3VzdG9tMSI6MC4wLCJ5YXdfY3VzdG9tMiI6MC4wLCJ5YXdfcmFuZG9tMSI6MC4wLCJ5YXdfcmFuZG9tMiI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MS4wfX0seyJib2R5X3lhdyI6dHJ1ZSwiYm9keV95YXdfbGVmdF9saW1pdCI6NjAuMCwiYm9keV95YXdfb3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sImJvZHlfeWF3X3JhbmRvbWl6YXRpb24iOjAuMCwiYm9keV95YXdfcmlnaHRfbGltaXQiOjYwLjAsImRlZmVuc2l2ZV9zZXR1cCI6dHJ1ZSwiZm9yY2VfbGMiOnRydWUsImppdHRlcl9kZWxheSI6MS4wLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkRlZmF1bHQiLCJ5YXdfbGVmdF9vZmZzZXQiOjAuMCwieWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ+ZGVmZW5zaXZlX3NldHVwIjp7ImVfc3BhbSI6dHJ1ZSwicGl0Y2giOiJTd2F5IiwicGl0Y2hfY3VzdG9tMSI6LTg5LjAsInBpdGNoX2N1c3RvbTIiOjg5LjAsInBpdGNoX3JhbmRvbTEiOi04OS4wLCJwaXRjaF9yYW5kb20yIjo4OS4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxLjAsInlhdyI6Ik9wcG9zaXRlIiwieWF3X2N1c3RvbTEiOi04OS4wLCJ5YXdfY3VzdG9tMiI6ODkuMCwieWF3X3JhbmRvbTEiOi04OS4wLCJ5YXdfcmFuZG9tMiI6ODkuMCwieWF3X3NwaW5fc3BlZWQiOjEuMH19LHsiYm9keV95YXciOnRydWUsImJvZHlfeWF3X2xlZnRfbGltaXQiOjYwLjAsImJvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjowLjAsImJvZHlfeWF3X3JpZ2h0X2xpbWl0Ijo2MC4wLCJkZWZlbnNpdmVfc2V0dXAiOnRydWUsImZvcmNlX2xjIjp0cnVlLCJqaXR0ZXJfZGVsYXkiOjEuMCwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJEZWZhdWx0IiwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19tb2RpZmllcl9vZmZzZXQiOjM1LjAsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ+ZGVmZW5zaXZlX3NldHVwIjp7ImVfc3BhbSI6ZmFsc2UsInBpdGNoIjoiUmFuZG9tIiwicGl0Y2hfY3VzdG9tMSI6NC4wLCJwaXRjaF9jdXN0b20yIjo5LjAsInBpdGNoX3JhbmRvbTEiOjQuMCwicGl0Y2hfcmFuZG9tMiI6OS4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxNS4wLCJ5YXciOiJTcGluIiwieWF3X2N1c3RvbTEiOjQuMCwieWF3X2N1c3RvbTIiOjkuMCwieWF3X3JhbmRvbTEiOjQuMCwieWF3X3JhbmRvbTIiOjkuMCwieWF3X3NwaW5fc3BlZWQiOjE1LjB9fSx7ImJvZHlfeWF3Ijp0cnVlLCJib2R5X3lhd19sZWZ0X2xpbWl0Ijo2MC4wLCJib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciIsIn4iXSwiYm9keV95YXdfcmFuZG9taXphdGlvbiI6Ny4wLCJib2R5X3lhd19yaWdodF9saW1pdCI6NjAuMCwiZGVmZW5zaXZlX3NldHVwIjp0cnVlLCJmb3JjZV9sYyI6dHJ1ZSwiaml0dGVyX2RlbGF5IjoxLjAsInN0YXRlX2VuYWJsZSI6dHJ1ZSwieWF3IjoiRGVmYXVsdCIsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjotMTAuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsIn5kZWZlbnNpdmVfc2V0dXAiOnsiZV9zcGFtIjpmYWxzZSwicGl0Y2giOiJEb3duIiwicGl0Y2hfY3VzdG9tMSI6MC4wLCJwaXRjaF9jdXN0b20yIjowLjAsInBpdGNoX3JhbmRvbTEiOjAuMCwicGl0Y2hfcmFuZG9tMiI6MC4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxNS4wLCJ5YXciOiJTcGluIiwieWF3X2N1c3RvbTEiOjAuMCwieWF3X2N1c3RvbTIiOjAuMCwieWF3X3JhbmRvbTEiOjAuMCwieWF3X3JhbmRvbTIiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjE4LjB9fSx7ImJvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfbGVmdF9saW1pdCI6MC4wLCJib2R5X3lhd19vcHRpb25zIjpbIn4iXSwiYm9keV95YXdfcmFuZG9taXphdGlvbiI6MC4wLCJib2R5X3lhd19yaWdodF9saW1pdCI6MC4wLCJkZWZlbnNpdmVfc2V0dXAiOmZhbHNlLCJmb3JjZV9sYyI6ZmFsc2UsImppdHRlcl9kZWxheSI6MS4wLCJzdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXciOiJEZWZhdWx0IiwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwieWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwifmRlZmVuc2l2ZV9zZXR1cCI6eyJlX3NwYW0iOmZhbHNlLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tMSI6MC4wLCJwaXRjaF9jdXN0b20yIjowLjAsInBpdGNoX3JhbmRvbTEiOjAuMCwicGl0Y2hfcmFuZG9tMiI6MC4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxLjAsInlhdyI6IlNpZGV3YXlzIiwieWF3X2N1c3RvbTEiOjAuMCwieWF3X2N1c3RvbTIiOjAuMCwieWF3X3JhbmRvbTEiOjAuMCwieWF3X3JhbmRvbTIiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMH19XSx7Im1pc2MiOnsiYW5pbWF0aW9uX2JyZWFrZXJzIjp7ImFkZG9ucyI6WyJ+Il0sImFpcl9sZWdzIjoiRGlzYWJsZWQiLCJncm91bmRfbGVncyI6IkRpc2FibGVkIiwiZ3JvdW5kX2xlZ3Nfaml0dGVyX2ZpcnN0X3ZhbHVlIjowLjAsImdyb3VuZF9sZWdzX2ppdHRlcl9zZWNvbmRfdmFsdWUiOjAuMH0sImFzcGVjdF9yYXRpbyI6dHJ1ZSwiY2xhbnRhZyI6ZmFsc2UsImZhc3RfbGFkZGVyIjpmYWxzZSwia2lsbHNheSI6ZmFsc2UsIm5vX2ZhbGxfZGFtYWdlIjpmYWxzZSwidmlld21vZGVsX2NoYW5nZXIiOnRydWUsIn5hc3BlY3RfcmF0aW8iOnsiYW1vdW50IjoxMzMuMH0sIn52aWV3bW9kZWxfY2hhbmdlciI6eyJ2aWV3bW9kZWxfZm92Ijo2MDAuMCwidmlld21vZGVsX3giOjEwLjAsInZpZXdtb2RlbF95IjoxMC4wLCJ2aWV3bW9kZWxfeiI6LTEwLjB9fSwicmFnZWJvdCI6eyJhaW1ib3RfbG9ncyI6dHJ1ZSwiYWlyX21vZGUiOmZhbHNlLCJkb3JtYW50X2FpbWJvdCI6ZmFsc2UsImZha2VfbGF0ZW5jeSI6ZmFsc2UsImdyZW5hZGVzIjp7ImF1dG9tYXRpY19yZWxlYXNlIjpmYWxzZSwiYXV0b21hdGljX3JlbGVhc2VfZGFtYWdlIjowLjAsInN1cGVyX3Rvc3MiOmZhbHNlLCJ0aHJvd19maXgiOmZhbHNlfSwibm9fc2NvcGVfbW9kZSI6ZmFsc2UsIn5haW1ib3RfbG9ncyI6eyJzZWxlY3QiOlsxLjAsMi4wLCJ+Il19LCJ+YWlyX21vZGUiOnsiYXV0b3NuaXBlcnNfYW1vdW50IjowLjAsImF3cF9hbW91bnQiOjAuMCwiY3VycmVudF93ZWFwb24iOjEuMCwic3NnX2Ftb3VudCI6MC4wfSwifmRvcm1hbnRfYWltYm90Ijp7ImFjY3VyYWN5Ijo1MC4wLCJhdXRvX3Njb3BlIjpmYWxzZSwiaGl0Ym94ZXMiOlsifiJdLCJtaW5pbXVtX2RhbWFnZSI6MC4wfSwifmZha2VfbGF0ZW5jeSI6eyJhbW91bnQiOjAuMH0sIn5ub19zY29wZV9tb2RlIjp7ImF1dG9zbmlwZXJzX2Ftb3VudCI6MC4wLCJhd3BfYW1vdW50IjowLjAsImN1cnJlbnRfd2VhcG9uIjoxLjAsInNzZ19hbW91bnQiOjAuMH19LCJ2aXN1YWxzIjp7ImFudGlfYWltX2Fycm93cyI6ZmFsc2UsImNyb3NzaGFpcl9pbmRpY2F0b3JzIjpmYWxzZSwiZGFtYWdlX2luZGljYXRvciI6dHJ1ZSwiaGl0X21hcmtlciI6ZmFsc2UsImtlZXBfbW9kZWxfdHJhbnNwYXJlbmN5IjpmYWxzZSwic2NvcGVfb3ZlcmxheSI6ZmFsc2UsInNpZGVfaW5kaWNhdG9ycyI6ZmFsc2UsIn5hbnRpX2FpbV9hcnJvd3MiOnsiYWNjZW50X2NvbG9yIjoiI0ZGRkZGRkZGIn0sIn5jcm9zc2hhaXJfaW5kaWNhdG9ycyI6eyJhY2NlbnRfY29sb3IiOiIjRkZGRkZGRkYifSwifmRhbWFnZV9pbmRpY2F0b3IiOnsiZm9udCI6IlBpeGVsIn0sIn5oaXRfbWFya2VyIjp7ImFjY2VudF9jb2xvciI6IiNGRkZGRkZGRiJ9LCJ+c2NvcGVfb3ZlcmxheSI6eyJhY2NlbnRfY29sb3IiOiIjRkZGRkZGRkYiLCJpbnZlcnRlZCI6ZmFsc2UsIm9mZnNldCI6NS4wLCJwb3NpdGlvbiI6MTAwLjAsInRfc3R5bGUiOmZhbHNlfSwifnNpZGVfaW5kaWNhdG9ycyI6eyJzaWRlX2luZGljYXRvcnNfdHlwZSI6IjUwMCQifX19LCIjNzU5NkM1RkYiXQ=='}}
configdata.menu_list = configdata.menu_list or {'Default'}

configdata.cfg_list[1][2] = "W3siYnVpbGRlciI6eyJjb25kaXRpb25zIjoiU2hhcmVkIn0sIm1haW4iOnsiYXZvaWRfYmFja3N0YWIiOnRydWUsImRpc2FibGVycyI6dHJ1ZSwiZnJlZXN0YW5kaW5nIjp7ImZyZWVzdGFuZGluZ19rZXkiOmZhbHNlLCJzdGF0aWNfeWF3IjpmYWxzZX0sIm1hbnVhbF95YXciOnsiaWdub3JlX2ZyZWVzdGFuZGluZyI6ZmFsc2UsIm1hbnVhbF9lZGdlIjpmYWxzZSwic2VsZWN0X21hbnVhbF95YXciOiJEaXNhYmxlZCIsInN0YXRpY19tYW51YWxzIjpmYWxzZX0sInNhZmVfaGVhZCI6dHJ1ZSwic21hcnRfdGVsZXBvcnQiOmZhbHNlLCJ+ZGlzYWJsZXJzIjp7InNlbGVjdCI6WzEuMCwifiJdfSwifnNhZmVfaGVhZCI6eyJzZWxlY3QiOlsxLjAsMi4wLCJ+Il19fX0sW3siYm9keV95YXciOnRydWUsImJvZHlfeWF3X2xlZnRfbGltaXQiOjYwLjAsImJvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjowLjAsImJvZHlfeWF3X3JpZ2h0X2xpbWl0Ijo2MC4wLCJkZWZlbnNpdmVfc2V0dXAiOmZhbHNlLCJmb3JjZV9sYyI6ZmFsc2UsImppdHRlcl9kZWxheSI6NC4wLCJzdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXciOiJEZWZhdWx0IiwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwieWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwifmRlZmVuc2l2ZV9zZXR1cCI6eyJlX3NwYW0iOnRydWUsInBpdGNoIjoiRGlzYWJsZWQiLCJwaXRjaF9jdXN0b20xIjowLjAsInBpdGNoX2N1c3RvbTIiOjAuMCwicGl0Y2hfcmFuZG9tMSI6MC4wLCJwaXRjaF9yYW5kb20yIjowLjAsInBpdGNoX3N3YXlfc3BlZWQiOjEwLjAsInlhdyI6IlNwaW4iLCJ5YXdfY3VzdG9tMSI6MC4wLCJ5YXdfY3VzdG9tMiI6MC4wLCJ5YXdfcmFuZG9tMSI6MC4wLCJ5YXdfcmFuZG9tMiI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTAuMH19LHsiYm9keV95YXciOnRydWUsImJvZHlfeWF3X2xlZnRfbGltaXQiOjYwLjAsImJvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjoxMC4wLCJib2R5X3lhd19yaWdodF9saW1pdCI6NjAuMCwiZGVmZW5zaXZlX3NldHVwIjpmYWxzZSwiZm9yY2VfbGMiOmZhbHNlLCJqaXR0ZXJfZGVsYXkiOjEuMCwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJEZWZhdWx0IiwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19tb2RpZmllcl9vZmZzZXQiOi01MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwifmRlZmVuc2l2ZV9zZXR1cCI6eyJlX3NwYW0iOmZhbHNlLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tMSI6MC4wLCJwaXRjaF9jdXN0b20yIjowLjAsInBpdGNoX3JhbmRvbTEiOjAuMCwicGl0Y2hfcmFuZG9tMiI6MC4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxLjAsInlhdyI6IlNpZGV3YXlzIiwieWF3X2N1c3RvbTEiOjAuMCwieWF3X2N1c3RvbTIiOjAuMCwieWF3X3JhbmRvbTEiOjAuMCwieWF3X3JhbmRvbTIiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMH19LHsiYm9keV95YXciOnRydWUsImJvZHlfeWF3X2xlZnRfbGltaXQiOjYwLjAsImJvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjoxOS4wLCJib2R5X3lhd19yaWdodF9saW1pdCI6NjAuMCwiZGVmZW5zaXZlX3NldHVwIjp0cnVlLCJmb3JjZV9sYyI6dHJ1ZSwiaml0dGVyX2RlbGF5IjoxLjAsInN0YXRlX2VuYWJsZSI6dHJ1ZSwieWF3IjoiRGVmYXVsdCIsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfbW9kaWZpZXIiOiJTcGluIiwieWF3X21vZGlmaWVyX29mZnNldCI6LTUuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsIn5kZWZlbnNpdmVfc2V0dXAiOnsiZV9zcGFtIjpmYWxzZSwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20xIjotNzcuMCwicGl0Y2hfY3VzdG9tMiI6LTEyLjAsInBpdGNoX3JhbmRvbTEiOi03Ny4wLCJwaXRjaF9yYW5kb20yIjotMTIuMCwicGl0Y2hfc3dheV9zcGVlZCI6MS4wLCJ5YXciOiJSYW5kb20iLCJ5YXdfY3VzdG9tMSI6LTc3LjAsInlhd19jdXN0b20yIjotMTIuMCwieWF3X3JhbmRvbTEiOi03Ny4wLCJ5YXdfcmFuZG9tMiI6LTEyLjAsInlhd19zcGluX3NwZWVkIjoxLjB9fSx7ImJvZHlfeWF3Ijp0cnVlLCJib2R5X3lhd19sZWZ0X2xpbWl0Ijo2MC4wLCJib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciIsIn4iXSwiYm9keV95YXdfcmFuZG9taXphdGlvbiI6MTQuMCwiYm9keV95YXdfcmlnaHRfbGltaXQiOjYwLjAsImRlZmVuc2l2ZV9zZXR1cCI6ZmFsc2UsImZvcmNlX2xjIjpmYWxzZSwiaml0dGVyX2RlbGF5IjoxLjAsInN0YXRlX2VuYWJsZSI6dHJ1ZSwieWF3IjoiRGVmYXVsdCIsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjotNTguMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsIn5kZWZlbnNpdmVfc2V0dXAiOnsiZV9zcGFtIjp0cnVlLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tMSI6MC4wLCJwaXRjaF9jdXN0b20yIjowLjAsInBpdGNoX3JhbmRvbTEiOjAuMCwicGl0Y2hfcmFuZG9tMiI6MC4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxLjAsInlhdyI6IlNpZGV3YXlzIiwieWF3X2N1c3RvbTEiOjAuMCwieWF3X2N1c3RvbTIiOjAuMCwieWF3X3JhbmRvbTEiOjAuMCwieWF3X3JhbmRvbTIiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMH19LHsiYm9keV95YXciOnRydWUsImJvZHlfeWF3X2xlZnRfbGltaXQiOjYwLjAsImJvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjowLjAsImJvZHlfeWF3X3JpZ2h0X2xpbWl0Ijo2MC4wLCJkZWZlbnNpdmVfc2V0dXAiOnRydWUsImZvcmNlX2xjIjp0cnVlLCJqaXR0ZXJfZGVsYXkiOjEuMCwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJEZWZhdWx0IiwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwieWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwifmRlZmVuc2l2ZV9zZXR1cCI6eyJlX3NwYW0iOmZhbHNlLCJwaXRjaCI6IlN3YXkiLCJwaXRjaF9jdXN0b20xIjowLjAsInBpdGNoX2N1c3RvbTIiOjAuMCwicGl0Y2hfcmFuZG9tMSI6MC4wLCJwaXRjaF9yYW5kb20yIjowLjAsInBpdGNoX3N3YXlfc3BlZWQiOjEuMCwieWF3IjoiT3Bwb3NpdGUiLCJ5YXdfY3VzdG9tMSI6MC4wLCJ5YXdfY3VzdG9tMiI6MC4wLCJ5YXdfcmFuZG9tMSI6MC4wLCJ5YXdfcmFuZG9tMiI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MS4wfX0seyJib2R5X3lhdyI6dHJ1ZSwiYm9keV95YXdfbGVmdF9saW1pdCI6NjAuMCwiYm9keV95YXdfb3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sImJvZHlfeWF3X3JhbmRvbWl6YXRpb24iOjAuMCwiYm9keV95YXdfcmlnaHRfbGltaXQiOjYwLjAsImRlZmVuc2l2ZV9zZXR1cCI6dHJ1ZSwiZm9yY2VfbGMiOnRydWUsImppdHRlcl9kZWxheSI6MS4wLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkRlZmF1bHQiLCJ5YXdfbGVmdF9vZmZzZXQiOjAuMCwieWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ+ZGVmZW5zaXZlX3NldHVwIjp7ImVfc3BhbSI6dHJ1ZSwicGl0Y2giOiJTd2F5IiwicGl0Y2hfY3VzdG9tMSI6LTg5LjAsInBpdGNoX2N1c3RvbTIiOjg5LjAsInBpdGNoX3JhbmRvbTEiOi04OS4wLCJwaXRjaF9yYW5kb20yIjo4OS4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxLjAsInlhdyI6Ik9wcG9zaXRlIiwieWF3X2N1c3RvbTEiOi04OS4wLCJ5YXdfY3VzdG9tMiI6ODkuMCwieWF3X3JhbmRvbTEiOi04OS4wLCJ5YXdfcmFuZG9tMiI6ODkuMCwieWF3X3NwaW5fc3BlZWQiOjEuMH19LHsiYm9keV95YXciOnRydWUsImJvZHlfeWF3X2xlZnRfbGltaXQiOjYwLjAsImJvZHlfeWF3X29wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJib2R5X3lhd19yYW5kb21pemF0aW9uIjowLjAsImJvZHlfeWF3X3JpZ2h0X2xpbWl0Ijo2MC4wLCJkZWZlbnNpdmVfc2V0dXAiOnRydWUsImZvcmNlX2xjIjp0cnVlLCJqaXR0ZXJfZGVsYXkiOjEuMCwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJEZWZhdWx0IiwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19tb2RpZmllcl9vZmZzZXQiOjM1LjAsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ+ZGVmZW5zaXZlX3NldHVwIjp7ImVfc3BhbSI6ZmFsc2UsInBpdGNoIjoiUmFuZG9tIiwicGl0Y2hfY3VzdG9tMSI6NC4wLCJwaXRjaF9jdXN0b20yIjo5LjAsInBpdGNoX3JhbmRvbTEiOjQuMCwicGl0Y2hfcmFuZG9tMiI6OS4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxNS4wLCJ5YXciOiJTcGluIiwieWF3X2N1c3RvbTEiOjQuMCwieWF3X2N1c3RvbTIiOjkuMCwieWF3X3JhbmRvbTEiOjQuMCwieWF3X3JhbmRvbTIiOjkuMCwieWF3X3NwaW5fc3BlZWQiOjE1LjB9fSx7ImJvZHlfeWF3Ijp0cnVlLCJib2R5X3lhd19sZWZ0X2xpbWl0Ijo2MC4wLCJib2R5X3lhd19vcHRpb25zIjpbIkppdHRlciIsIn4iXSwiYm9keV95YXdfcmFuZG9taXphdGlvbiI6Ny4wLCJib2R5X3lhd19yaWdodF9saW1pdCI6NjAuMCwiZGVmZW5zaXZlX3NldHVwIjp0cnVlLCJmb3JjZV9sYyI6dHJ1ZSwiaml0dGVyX2RlbGF5IjoxLjAsInN0YXRlX2VuYWJsZSI6dHJ1ZSwieWF3IjoiRGVmYXVsdCIsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjotMTAuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsIn5kZWZlbnNpdmVfc2V0dXAiOnsiZV9zcGFtIjpmYWxzZSwicGl0Y2giOiJEb3duIiwicGl0Y2hfY3VzdG9tMSI6MC4wLCJwaXRjaF9jdXN0b20yIjowLjAsInBpdGNoX3JhbmRvbTEiOjAuMCwicGl0Y2hfcmFuZG9tMiI6MC4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxNS4wLCJ5YXciOiJTcGluIiwieWF3X2N1c3RvbTEiOjAuMCwieWF3X2N1c3RvbTIiOjAuMCwieWF3X3JhbmRvbTEiOjAuMCwieWF3X3JhbmRvbTIiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjE4LjB9fSx7ImJvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfbGVmdF9saW1pdCI6MC4wLCJib2R5X3lhd19vcHRpb25zIjpbIn4iXSwiYm9keV95YXdfcmFuZG9taXphdGlvbiI6MC4wLCJib2R5X3lhd19yaWdodF9saW1pdCI6MC4wLCJkZWZlbnNpdmVfc2V0dXAiOmZhbHNlLCJmb3JjZV9sYyI6ZmFsc2UsImppdHRlcl9kZWxheSI6MS4wLCJzdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXciOiJEZWZhdWx0IiwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwieWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwifmRlZmVuc2l2ZV9zZXR1cCI6eyJlX3NwYW0iOmZhbHNlLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tMSI6MC4wLCJwaXRjaF9jdXN0b20yIjowLjAsInBpdGNoX3JhbmRvbTEiOjAuMCwicGl0Y2hfcmFuZG9tMiI6MC4wLCJwaXRjaF9zd2F5X3NwZWVkIjoxLjAsInlhdyI6IlNpZGV3YXlzIiwieWF3X2N1c3RvbTEiOjAuMCwieWF3X2N1c3RvbTIiOjAuMCwieWF3X3JhbmRvbTEiOjAuMCwieWF3X3JhbmRvbTIiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMH19XSx7Im1pc2MiOnsiYW5pbWF0aW9uX2JyZWFrZXJzIjp7ImFkZG9ucyI6WyJ+Il0sImFpcl9sZWdzIjoiRGlzYWJsZWQiLCJncm91bmRfbGVncyI6IkRpc2FibGVkIiwiZ3JvdW5kX2xlZ3Nfaml0dGVyX2ZpcnN0X3ZhbHVlIjowLjAsImdyb3VuZF9sZWdzX2ppdHRlcl9zZWNvbmRfdmFsdWUiOjAuMH0sImFzcGVjdF9yYXRpbyI6dHJ1ZSwiY2xhbnRhZyI6ZmFsc2UsImZhc3RfbGFkZGVyIjpmYWxzZSwia2lsbHNheSI6ZmFsc2UsIm5vX2ZhbGxfZGFtYWdlIjpmYWxzZSwidmlld21vZGVsX2NoYW5nZXIiOnRydWUsIn5hc3BlY3RfcmF0aW8iOnsiYW1vdW50IjoxMzMuMH0sIn52aWV3bW9kZWxfY2hhbmdlciI6eyJ2aWV3bW9kZWxfZm92Ijo2MDAuMCwidmlld21vZGVsX3giOjEwLjAsInZpZXdtb2RlbF95IjoxMC4wLCJ2aWV3bW9kZWxfeiI6LTEwLjB9fSwicmFnZWJvdCI6eyJhaW1ib3RfbG9ncyI6dHJ1ZSwiYWlyX21vZGUiOmZhbHNlLCJkb3JtYW50X2FpbWJvdCI6ZmFsc2UsImZha2VfbGF0ZW5jeSI6ZmFsc2UsImdyZW5hZGVzIjp7ImF1dG9tYXRpY19yZWxlYXNlIjpmYWxzZSwiYXV0b21hdGljX3JlbGVhc2VfZGFtYWdlIjowLjAsInN1cGVyX3Rvc3MiOmZhbHNlLCJ0aHJvd19maXgiOmZhbHNlfSwibm9fc2NvcGVfbW9kZSI6ZmFsc2UsIn5haW1ib3RfbG9ncyI6eyJzZWxlY3QiOlsxLjAsMi4wLCJ+Il19LCJ+YWlyX21vZGUiOnsiYXV0b3NuaXBlcnNfYW1vdW50IjowLjAsImF3cF9hbW91bnQiOjAuMCwiY3VycmVudF93ZWFwb24iOjEuMCwic3NnX2Ftb3VudCI6MC4wfSwifmRvcm1hbnRfYWltYm90Ijp7ImFjY3VyYWN5Ijo1MC4wLCJhdXRvX3Njb3BlIjpmYWxzZSwiaGl0Ym94ZXMiOlsifiJdLCJtaW5pbXVtX2RhbWFnZSI6MC4wfSwifmZha2VfbGF0ZW5jeSI6eyJhbW91bnQiOjAuMH0sIn5ub19zY29wZV9tb2RlIjp7ImF1dG9zbmlwZXJzX2Ftb3VudCI6MC4wLCJhd3BfYW1vdW50IjowLjAsImN1cnJlbnRfd2VhcG9uIjoxLjAsInNzZ19hbW91bnQiOjAuMH19LCJ2aXN1YWxzIjp7ImFudGlfYWltX2Fycm93cyI6ZmFsc2UsImNyb3NzaGFpcl9pbmRpY2F0b3JzIjpmYWxzZSwiZGFtYWdlX2luZGljYXRvciI6dHJ1ZSwiaGl0X21hcmtlciI6ZmFsc2UsImtlZXBfbW9kZWxfdHJhbnNwYXJlbmN5IjpmYWxzZSwic2NvcGVfb3ZlcmxheSI6ZmFsc2UsInNpZGVfaW5kaWNhdG9ycyI6ZmFsc2UsIn5hbnRpX2FpbV9hcnJvd3MiOnsiYWNjZW50X2NvbG9yIjoiI0ZGRkZGRkZGIn0sIn5jcm9zc2hhaXJfaW5kaWNhdG9ycyI6eyJhY2NlbnRfY29sb3IiOiIjRkZGRkZGRkYifSwifmRhbWFnZV9pbmRpY2F0b3IiOnsiZm9udCI6IlBpeGVsIn0sIn5oaXRfbWFya2VyIjp7ImFjY2VudF9jb2xvciI6IiNGRkZGRkZGRiJ9LCJ+c2NvcGVfb3ZlcmxheSI6eyJhY2NlbnRfY29sb3IiOiIjRkZGRkZGRkYiLCJpbnZlcnRlZCI6ZmFsc2UsIm9mZnNldCI6NS4wLCJwb3NpdGlvbiI6MTAwLjAsInRfc3R5bGUiOmZhbHNlfSwifnNpZGVfaW5kaWNhdG9ycyI6eyJzaWRlX2luZGljYXRvcnNfdHlwZSI6IjUwMCQifX19LCIjNzU5NkM1RkYiXQ=="
configsystem.save_config = function(id)
    if id == 1 then return end
    local raw = config:save()
    configdata.cfg_list[id][2] = base64.encode(json.stringify(raw))
    cvar.play:call("ambient\\tones\\elev1")
    db.cfg_dbgxz2 = configdata
end

configsystem.update_values = function(id)
    local name = configdata.cfg_list[id][1]
    local new_name = name.."\a{Link Active} ~ Loaded"
    for k, v in ipairs(configdata.cfg_list) do
        configdata.menu_list[k] = v[1]
    end
    configdata.menu_list[id] = new_name
end

configsystem.create_config = function(name)
    if type(name) ~= 'string' then return end
    if name == nil or name == '' or name == ' ' then return end
    for i=#configdata.menu_list, 1, -1 do if configdata.menu_list[i] == name then common.add_notify('\vInvincible', 'Config with this name has already been created') return end end
    if #configdata.cfg_list > 6 then common.add_notify('\vInvincible', 'Too much configs') return end
    local completed = {name, ''}
    table.insert(configdata.cfg_list, completed)
    table.insert(configdata.menu_list, name)
    db.cfg_dbgxz2 = configdata
end

configsystem.remove_config = function(id)
    if id == 1 then return end
    local item = configdata.cfg_list[id][1]
    for i=#configdata.cfg_list, 1, -1 do if configdata.cfg_list[i][1] == item then table.remove(configdata.cfg_list, i) table.remove(configdata.menu_list, i) end end
    db.cfg_dbgxz2 = configdata
end

configsystem.load_config = function(id)
    if configdata.cfg_list[id][2] == nil or configdata.cfg_list[id][2] == '' then print("Error[data_base[".. id .."]]") return end
    if id > #configdata.cfg_list then print("Error[data_base[".. id .."]]") return end
        config:load(json.parse(base64.decode(configdata.cfg_list[id][2])))
        cvar.play:call("ambient\\tones\\elev1")
end
configs = {
    cfg_selector = tabs.home.under_section:list('', configdata.menu_list),
    name = tabs.home.under_section:input(""),

    export = tabs.home.under_section:button("      \aA3A6DBFF\f<upload>       ", function()
        clipboard.set(base64.encode(json.stringify(config:save())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true),

    save = tabs.home.under_section:button("      \v\f<floppy-disk>      ", function()
        configsystem.save_config(configs.cfg_selector:get())
    end, true),

    load = tabs.home.under_section:button("      \v\f<loader>      ", function()
        configsystem.update_values(configs.cfg_selector:get())
        configsystem.load_config(configs.cfg_selector:get())
        configs.cfg_selector:update(configdata.menu_list)
    end, true),

    import = tabs.home.under_section:button("       \a90E190FF\f<download>       ", function()
        config:load(json.parse(base64.decode(clipboard.get())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true),

    create = tabs.home.under_section:button("                 \aA3A6DBFF\f<layer-plus>                  ", function()
        configsystem.create_config(configs.name:get())
        configs.cfg_selector:update(configdata.menu_list)
    end, true),
    
    remove  = tabs.home.under_section:button("                  \aA86464FF\f<trash-can-xmark>                  ", function()
        configsystem.remove_config(configs.cfg_selector:get())
        configs.cfg_selector:update(configdata.menu_list)
    end, true),
}

configs.load:tooltip("Load config")
configs.save:tooltip("Save config")
configs.remove:tooltip("Remove config")
configs.create:tooltip("Create config")
configs.import:tooltip("Import config to clipboard")
configs.export:tooltip("Export config to clipboard")

-- #endregion

-- #region : Callbacks

events.render:set(function()
    builder_visibility()
    hide_menu_elements()

    misc.render()
    visuals.render()
    ragebot.render()
end)

events.createmove:set(function(cmd)
    antiaim.create_move(cmd)
    misc.create_move(cmd)
    ragebot.create_move(cmd)
end)

events.grenade_prediction:set(function(e)
    ragebot.grenade_prediction(e)
end)

events.grenade_override_view:set(function(e)
    ragebot.grenade_override_view(e)
end)

events.post_update_clientside_animation:set(function()
    misc.post_update_clientside_animation()
end)

events.localplayer_transparency:set(misc.localplayer_transparency)

events.override_view:set(function(e)
    visuals.override_view(e)
end)

events.aim_ack:set(function(e)
    visuals.aim_ack(e)
    ragebot.aim_ack(e)
end)

events.weapon_fire:set(function(e)
    ragebot.weapon_fire(e)
end)

events.player_hurt:set(function(e)
    ragebot.player_hurt(e)
end)

events.player_death:set(function(e)
    misc.player_death(e)
end)

events.shutdown:set(function()
    common.set_clan_tag("")

    cvar.viewmodel_fov:float(get_original(cvar.viewmodel_fov), true)
    cvar.viewmodel_offset_x:float(get_original(cvar.viewmodel_offset_x), true)
    cvar.viewmodel_offset_y:float(get_original(cvar.viewmodel_offset_y), true)
    cvar.viewmodel_offset_z:float(get_original(cvar.viewmodel_offset_z), true)

    cvar.sv_maxunlag:float(0.2)

    refs.dormant_aimbot:override()

    refs.weapon_actions:override()
end)

-- #endregion