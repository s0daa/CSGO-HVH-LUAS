-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS



ffi.cdef[[
    int GetProcAddress(
        void*, 
        const char*
    );

    void* GetModuleHandleA(
        const char*
    );

    typedef void*(__cdecl* ShellExecute)(void*, const char*, const char*, const char*, const char*, int);
]]

local gradient = require("neverlose/gradient")
local clipboard = require("neverlose/clipboard")
local shellexecutea = ffi.cast("ShellExecute", ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("shell32.dll"), "ShellExecuteA"))

ui.sidebar(gradient.text("helper rework", false, {color("00EE6EFF"), color("0C75E6FF")}), "wheelchair")

local function make_copy(v)
    if(type(v) ~= "table") then return v end
    local tab = {}; for k, val in pairs(v) do tab[make_copy(k)] = make_copy(val) end; return tab
end

local table, math, string, bit = make_copy(table), make_copy(math), make_copy(string), make_copy(bit)
local eRender, Helper, Menu, Globals, Http, HotkeyManager

table.copy = function (tab1, tab2)
    tab2 = tab2 or {}
    for k, v in pairs(tab1) do
        if(type(v) == "table") then
            tab2[k] = {}
            table.copy(v, tab2[k])
        else
            tab2[k] = v
        end
    end
    return tab2
end

bit.xor_string = function (str, key)
    local key_len = key:len()
    local i = 1

    local ret = str:gsub("(.)", function (t)
        if(i > key_len) then i = 1 end
        local ret = string.char(bit.bxor(t:byte(), key:byte(i)))
        i = i + 1
        return ret
    end)

    return ret
end

SearchListByKey = function (list, key, eq)
    for _, v in pairs(list) do if v[key] == eq then return v end end
    return nil
end

ffi.cdef[[
    long CreateFileA
    (
        const char*                lpFileName,
        unsigned long                 dwDesiredAccess,
        unsigned long                 dwShareMode,
        unsigned long lpSecurityAttributes,
        unsigned long                 dwCreationDisposition,
        unsigned long                 dwFlagsAndAttributes,
        void*                hTemplateFile
    );

    bool ReadFile
    (
        long       hFile,
        char*       lpBuffer,
        unsigned long        nNumberOfBytesToRead,
        unsigned long*      lpNumberOfBytesRead,
        void* lpOverlapped
    );

    bool WriteFile
    (
        long       hFile,
        char*      lpBuffer,
        unsigned long        nNumberOfBytesToWrite,
        unsigned long*      lpNumberOfBytesWritten,
        void* lpOverlapped
    );
    
    unsigned long GetFileSize
    (
        long  hFile,
        unsigned long* lpFileSizeHigh
    );

    bool CloseHandle
    (
        long hHandle
    );

    void* GetClipboardData
    (
        unsigned int uFormat
    );

    void* GlobalLock
    (
        void* hMem
    );

    int GlobalUnlock
    (
        void* hMem
    );

    int OpenClipboard
    (
        void* hWndNewOwner
    );

    int CloseClipboard
    (

    );

    void* GetActiveWindow
    (

    );

    unsigned long GetLastError
    (
        
    );

    int CreateDirectoryA
    (
        const char* lpPathName,
        void* lpSecurityAttributes
    );
]]
winapi = {}
winapi.ReadFile = function(path)
    local file = ffi.C.CreateFileA(ffi.cast("char*", path), 0xC0000000, 0x1, 0x0, 0x3, 0x80, nil)
    if(file == -1) then
        print("Could not open file : \"" .. path .. "\".", "err-code : " .. ffi.C.GetLastError())
        return nil
    end

    local filesize = ffi.C.GetFileSize(file, nil)
    local text = ffi.new("char[" .. (filesize + 1) .. "]")
    ffi.C.ReadFile(file, text, filesize, nil, nil)
    ffi.C.CloseHandle(file)

    return ffi.string(text)
end
winapi.WriteFile = function(path, text, flags)
    local file = ffi.C.CreateFileA(ffi.cast("char*", path), 0xC0000000, 0x1, 0x0, 0x4, flags or 0x80, nil)
    if(file == -1) then
        print("Could not open file : \"" .. path .. "\".", "err-code : " .. ffi.C.GetLastError())
        return nil
    end

    local text_size = text:len()
    text = ffi.cast("char*", text)

    ffi.C.WriteFile(file, text, text_size, nil, nil)
    ffi.C.CloseHandle(file)
end

winapi.CreateDirectory = function (dir)
    ffi.C.CreateDirectoryA(ffi.cast("char*", dir), nil)
end



render.helper_location_render_distance_sqr = 150 ^ 2
render.helper_location_expand_distance_sqr = 75 ^ 2
render.helper_location_parking_distance_sqr = 150 ^ 2
render.helper_location_fustion_distance_sqr = 20 ^ 2

render.helper_location_render_behind_walls = false
render.helper_location_render_behind_walls_dist_sqr = 150 ^ 2

render.helper_target_minimal_fov = 30
render.helper_box_rounding = 10
render.helper_render_shadow = true
render.helper_weapon_icon_scale = {0.9, 0.9}

render.helper_target_circle_radius = 7
render.helper_target_render_distance_sqr = 50 ^ 2

render.helper_screen_scale = {render.screen_size().x / 2560, render.screen_size().y / 1440}

HotkeyManager =
{
    hotkeys = {},

    Push = function (self, key, callback)
        for _, hotkey in ipairs(self.hotkeys) do
            if(hotkey.value == key) then return end
        end

        table.insert(self.hotkeys,
        {
            value = key,
            callback = callback,
        })
    end,

    Update = function (self)
        for i, hotkey in ipairs(self.hotkeys) do
            if(common.is_button_released(hotkey.value)) then
                hotkey.callback()
                table.remove(self.hotkeys, i)
            end
        end
    end,
}

Http = -- @Brotgeschmack
{
    this = panorama.loadstring([[
        let requests = {};

        return {
            requestInternal: function(timestamp, url, options)
            {
                requests[timestamp] = {
                    complete: false,
                    value: null
                };

                options.complete = function(response) { 
                    requests[timestamp].complete = true;
                    requests[timestamp].value = response;
                };

                $.AsyncWebRequest(url, options);
            },
            getRequest: function(timestamp)
            {
                return requests[timestamp];
            },
            removeRequest: function(timestamp)
            {
                delete requests[timestamp];
            }
        };
    ]])(),

    requestTable = {},
    requestCount = 0,

    asyncWebRequest = function (self, requestType, url, data, complete)
        local options = {}
        
        options.data = data
        options.headers = {}

        options.headers.Accept = "application/json"
        options.headers["Content-type"] = "application/json"

        options.type = requestType
        options.timeout = 50000

        local timestamp = self.requestCount
        table.insert(self.requestTable, {complete = complete, timestamp = timestamp})
        self.this.requestInternal(timestamp, url, options)

        self.requestCount = self.requestCount + 1
    end,

    updateRequests = function(self)
        for i = #self.requestTable, 1, -1 do
            local request = self.requestTable[i]
            local requestJS = self.this.getRequest(request.timestamp)

            if requestJS.complete then
                request.complete(requestJS.value)
                table.remove(self.requestTable, i)
                self.this.removeRequest(request.timestamp)
            end
        end
    end,

    post = function (self, url, body, callback)
        callback = callback or function() end
        self:asyncWebRequest("POST", url, body, function (reply)
            if(reply.status < 200 or reply.status > 299) then
                print_raw("\aFF0000[HELPER SERVER ERROR]")
                print_raw("\aFF0000Url: " .. url)
                print_raw("\aFF0000Request body:")
                print_raw("\aFF0000" .. json.stringify(body))
                print_raw("\aFF0000Server reply:")
                for k, v in pairs(reply) do
                    print_raw("\aFF0000" .. k .. " " .. v)
                end
                return
            end
            callback(reply.responseText)
        end)
    end,

    get = function (self, url, callback)
        callback = callback or function() end
        self:asyncWebRequest("GET", url, nil, function (reply)
            if(reply.status < 200 or reply.status > 299) then
                print_raw("\aFF0000[HELPER SERVER ERROR]")
                print_raw("\aFF0000Url: " .. url)
                print_raw("\aFF0000Server reply:")
                for k, v in pairs(reply) do
                    print_raw("\aFF0000" .. k .. " " .. v)
                end
                return
            end
            callback(reply.responseText)
        end)
    end,

    put = function (self, url, body, callback)
        callback = callback or function() end
        self:asyncWebRequest("PUT", url, body, function (reply)
            if(reply.status < 200 or reply.status > 299) then
                print_raw("\aFF0000[HELPER SERVER ERROR]")
                print_raw("\aFF0000Url: " .. url)
                print_raw("\aFF0000Request body:")
                print_raw("\aFF0000" .. json.stringify(body))
                print_raw("\aFF0000Server reply:")
                for k, v in pairs(reply) do
                    print_raw("\aFF0000" .. k .. " " .. v)
                end
                return
            end
            callback(reply.responseText)
        end)
    end
}

Globals =
{
    Init = function (self)
        self.location_types =
        {
            "Molotov",
            "High Explosive",
            "Movement",
            "One-way",
            "Smoke",
            "Flash",
            "Decoy"
        }

        self.grenade_types_classnames =
        {
            ["CMolotovGrenade"] = "Molotov",
            ["CHEGrenade"] = "High Explosive",
            ["CSmokeGrenade"] = "Smoke",
            ["CFlashbang"] = "Flash",
            ["CDecoyGrenade"] = "Decoy"
        }

        self.design_styles =
        {
            gradient.text("Style Settings", false, {color("1CDCE8FF"), color("BB77EDFF"), color("F34A62FF")}),
        }

        self.sv_airaccelerate = cvar.sv_airaccelerate

        self.sv_airaccelerate:set_callback(function (sv_airaccelerate, old, new)
            Helper.Locations:Update()
        end)

        self.overlapping_maps =
        {
            ["de_shortnuke"] = "de_nuke",
            ["de_shortdust"] = "de_dust"
        }

        self.tickrate = math.floor(1 / globals.tickinterval + 0.5)

        self.target_location_legit_fov = 2

        self.helper_states =
        {
            "HELPER_IDLE",
            "HELPER_PARKING",
            "HELPER_PLAYBACK",
        }

        self.weapon_console_to_class_name =
        {
            ["weapon_smokegrenade"] = "CSmokeGrenade",
            ["weapon_hegrenade"] = "CHEGrenade",
            ["weapon_molotov"] = "CMolotovGrenade",
            ["weapon_flashbang"] = "CFlashbang",
            ["weapon_decoy"] = "CDecoyGrenade",
            ["weapon_knife"] = "CKnife",
        }
    end,
}

Math =
{
    Lerp = function (a, b, c)
        c = c or render.animation_speed
        local d = (b - a)

        return a + d * c
    end,

    Clamp = function (a, b, c)
        if(a < b) then
            return b
        elseif(a > c) then
            return c
        end
        return a
    end,

    Extra = 
    {
        GetVectorTableDistance = function (position, location)
            return math.sqrt((location[1] - position.x) ^ 2 + (location[2] - position.y) ^ 2 + (location[3] - position.z) ^ 2)
        end,

        GetVectorTableDistanceSqr = function (position, location)
            return (location[1] - position.x) ^ 2 + (location[2] - position.y) ^ 2 + (location[3] - position.z) ^ 2
        end,

        GetTableDistance = function(pos1, pos2)
            return math.sqrt((pos2[1] - pos1[1]) ^ 2 + (pos2[2] - pos1[2]) ^ 2 + (pos2[3] - pos1[3]) ^ 2)
        end,

        GetTableDistanceSqr = function (pos1, pos2)
            return (pos2[1] - pos1[1]) ^ 2 + (pos2[2] - pos1[2]) ^ 2 + (pos2[3] - pos1[3]) ^ 2
        end,

        GetLocationFOV = function (eyepos, eyeang, crosshair_position)
            local dvec = crosshair_position - eyepos
            local dang = (dvec:angles() - eyeang)
            dang.y = math.normalize_yaw(dang.y)
            
            return Math.Clamp(dang:length2d(), 0, 180)
        end,

        GetArmorDamage = function (damage, armor)
            if(armor > 0) then
                local dmg_ratio = damage * 0.5
                local arm_ratio = (damage - dmg_ratio) * 0.5

                if(arm_ratio > armor) then
                    arm_ratio = armor * 2
                    dmg_ratio = damage - arm_ratio
                end

                damage = dmg_ratio
            end
            return damage
        end,

        GetGrenadeDamage = function (self, player, det_pos)
            if(det_pos == nil) then return 0 end
            
            local pelvis_origin = player:get_hitbox_position(3)
            local distance = pelvis_origin:dist(det_pos)

            if(distance >= 350) then return 0 end

            local trace = utils.trace_line(det_pos, pelvis_origin, nil, 0x46004003)
            if(trace.entity ~= player) then return 0 end

            local d = (distance - 25) / 140
            local damage = 105 * math.exp(-d * d)

            return math.max(math.ceil(self.GetArmorDamage(damage, player.m_ArmorValue)), 0)
        end,
    },

    current_vectors =
    {
        vector(),
        vector(),
    },
}

local configs_database = db.helper_config_table or {}

Menu =
{
    helper =
    {
        main =
        {
            settings = {},
            binds = {},
            customization = {},
            information = {},
        },
        builder =
        {
            types = {},
            location =
            {
                grenade = {},
                movement = {},
                oneway = {},
                common = {},
            },
            extra = {},
        },
        config_system =
        {
            configs = {},
            creator = {},
            editor =
            {
                grenade = {},
                movement = {},
                oneway = {},
                common = {},
            },
            extra = {},
        },

        Init = function (self)
            --------------------------------------- SETTINGS ---------------------------------------------------

            local helper_settings = ui.create("Helper", ui.get_icon("cog") .. " Settings")
            local helper_binds = ui.create("Helper", ui.get_icon("thumbtack") .. " Binds")
            local helper_customization = ui.create("Helper", "Customization")
            local helper_information = ui.create("Helper", "Information")

            self.main.settings.autothrow_switch = helper_settings:switch(ui.get_icon("robot") .. " Auto Throw")

            self.main.settings.configs_combo = helper_settings:selectable(ui.get_icon("check-square") .. " Configs", {""})
            self.main.settings.configs_combo:set_callback(function (this)
                Helper.Locations:Update()

                Menu.extra.highlight_item:PushItem(this, -1, function ()
                    return #this:get() == 0
                end)
            end, true)

            self.main.settings.types_combo = helper_settings:selectable(ui.get_icon("bomb") .. " Types", Globals.location_types)
            self.main.settings.types_combo:set_callback(function (this)
                Helper.Locations:Update()

                Menu.extra.highlight_item:PushItem(this, -1, function ()
                    return #this:get() == 0
                end)
            end, true)

            self.main.settings.fov_slider = helper_settings:slider(ui.get_icon("eye") .. " FOV", 1, 180, 30, 1, function (value)
                if(value <= 2) then return "legit" end
                return value .. "°"
            end)
            self.main.settings.fov_slider:set_callback(function (this)
                render.helper_target_minimal_fov = this:get()
            end, true)

            ----------------------------------------- BINDS ----------------------------------------------------

            self.main.binds.parking_hotkey = helper_binds:hotkey(ui.get_icon("parking") .. " Parking [hold]")
            self.main.binds.parking_hotkey:tooltip("Holding this key moves you to closest location")
            self.main.binds.parking_hotkey:set_callback(function (this)
                Menu.extra.highlight_item:PushItem(this, -1, function ()
                    return this:key() == 0
                end)
            end, true)

            self.main.binds.update_hotkey = helper_binds:hotkey("Update [toggle]")
            self.main.binds.update_hotkey:tooltip("Update location position and angles")
            
            self.main.binds.teleport_hotkey = helper_binds:hotkey("Teleport [toggle]")
            self.main.binds.teleport_hotkey:tooltip("Teleports you to current building/editing location")

            self.main.binds.record_hotkey = helper_binds:hotkey("Record [toggle]")
            self.main.binds.record_hotkey:tooltip("Begin/stop recording for movement")

            ------------------------------------- CUSTOMIZATION ------------------------------------------------

            self.main.customization.render_design_combo = helper_customization:label(ui.get_icon("paint-brush") .. " " .. Globals.design_styles[1])
            self.main.customization.render_design_combo:set_callback(function (this)
                eRender.Style.style_name = this:get()
            end, true)

            self.main.customization.render_behind_walls_switch = helper_customization:switch("Render behind walls", false)
            self.main.customization.render_behind_walls_switch:set_callback(function (this)
                render.helper_location_render_behind_walls = this:get()
            end, true)

            self.main.customization.render_behind_walls_distance_slider = self.main.customization.render_behind_walls_switch:create():slider("Render Distance", 1, 500, 150)
            self.main.customization.render_behind_walls_distance_slider:set_callback(function (this)
                render.helper_location_render_behind_walls_dist_sqr = this:get() ^ 2
            end, true)

            self.main.customization.render_distance_slider = helper_customization:slider("Render Distance", 1, 1000, 150)
            self.main.customization.render_distance_slider:set_callback(function (this)
                render.helper_location_render_distance_sqr = this:get() ^ 2
            end, true)

            self.main.customization.render_expand_distance_slider = helper_customization:slider("Expand Distance", 1, 500, 75)
            self.main.customization.render_expand_distance_slider:set_callback(function (this)
                render.helper_location_expand_distance_sqr = this:get() ^ 2
            end, true)

            self.main.customization.location_parking_distance_slider = helper_customization:slider("Parking Distance", 50, 300, 150)
            self.main.customization.location_parking_distance_slider:set_callback(function (this)
                render.helper_location_parking_distance_sqr = this:get() ^ 2
            end, true)

            self.main.customization.helper_weapon_icon_scale = self.main.customization.render_design_combo:create():slider("Icon Size", 1, 20, 9, 0.1)
            self.main.customization.helper_weapon_icon_scale:set_callback(function (this)
                render.helper_weapon_icon_scale = {this:get() * 0.1, this:get() * 0.1}

                Helper.Locations:Update()
            end, true)

            self.main.customization.circle_radius = self.main.customization.render_design_combo:create():slider("Circle Size", 1, 10, 6)
            self.main.customization.circle_radius:set_callback(function (this)
                render.helper_target_circle_radius = this:get()

                Helper.Locations:Update()
            end, true)

            self.main.customization.font_size_slider = self.main.customization.render_design_combo:create():slider("Ground Font", 5, 20, 17)
            self.main.customization.font_size_slider:set_callback(function (this)
                eRender.Fonts.location_text_font:set_size(this:get() * render.helper_screen_scale[2])
                utils.execute_after(0.1, function ()
                    Helper.Locations:Update()
                end)
            end, true)

            self.main.customization.font_size_slider = self.main.customization.render_design_combo:create():slider("OnTarget Font", 5, 20, 15)
            self.main.customization.font_size_slider:set_callback(function (this)
                eRender.Fonts.target_text_font:set_size(this:get() * render.helper_screen_scale[2])
                utils.execute_after(0.1, function ()
                    Helper.Locations:Update()
                end)
            end, true)

            self.main.customization.render_box_rounding_slider = self.main.customization.render_design_combo:create():slider("Rounding", 0, 15, 6)
            self.main.customization.render_box_rounding_slider:set_callback(function (this)
                render.helper_box_rounding = this:get()
            end, true)

            self.main.customization.render_shadow_switch = self.main.customization.render_design_combo:create():switch("\aDEC20BFFRender Glow", true)
            self.main.customization.render_shadow_switch:tooltip("Turning this off will slightly increase your FPS")
            self.main.customization.render_shadow_switch:set_callback(function (this)
                render.helper_render_shadow = this:get()
            end, true)

            self.main.customization.location_background_color = self.main.customization.render_design_combo:create():color_picker("Background", color("000000A3"))
            self.main.customization.location_background_color:set_callback(function (this)
                eRender.Style.style_table.location_background_color = this:get():clone()
            end, true)

            self.main.customization.location_text_color = self.main.customization.render_design_combo:create():color_picker("Text", color("A9A4FFFF"))
            self.main.customization.location_text_color:set_callback(function (this)
                eRender.Style.style_table.location_text_color = this:get():clone()
            end, true)

            self.main.customization.location_weapon_color = self.main.customization.render_design_combo:create():color_picker("Icon", color("A9A4FFFF"))
            self.main.customization.location_weapon_color:set_callback(function (this)
                eRender.Style.style_table.location_weapon_color = this:get():clone()
            end, true)

            self.main.customization.target_circle_color = self.main.customization.render_design_combo:create():color_picker("Circle", color("D6BAFFFF"))
            self.main.customization.target_circle_color:set_callback(function (this)
                eRender.Style.style_table.target_circle_color = this:get():clone()
            end, true)

            ---------------------------------------INFORMATION-------------------------------------------------

            self.main.information.text_label = helper_information:label("\a6BDFDBFFHello it's Maga. Unfortunately I'm no more interested in CS:GO and will not support this script. Our team decided to make this script Open-Source so any coder among NeverLose's community could improve it.\nSince this script is open-source, cloud configs are disabled. If you had and want to use your private configs, you can create a ticket in our Discord server, and then import them through the 'Configs' tab.")

            self.main.information.discord_button = helper_information:button("Discord")
            self.main.information.discord_button:set_callback(function (this)
                shellexecutea(nil, "open", "https://discord.gg/YDKEn9k4cw", nil, nil, 1)
            end)

            self.main.information.github_button = helper_information:button("GitHub")
            self.main.information.github_button:set_callback(function (this)
                shellexecutea(nil, "open", "https://github.com/rainedot/grenade-helper", nil, nil, 1)
            end)

            ------------------------------------------BUILDER---------------------------------------------------

            local helper_builder_types = ui.create("Builder", "Type of location")
            local helper_builder_location = ui.create("Builder", "Location info")

            helper_builder_types:visibility(false) -- add them back when proper config system is ready
            helper_builder_location:visibility(false) -- same as above

            self.builder.extra.types_label = helper_builder_types:label("You will able to create more locations once you end up with current building one")
            self.builder.extra.types_label:visibility(false)

            self.builder.types.create_grenade_button = helper_builder_types:button("Create Grenade")
            self.builder.types.create_grenade_button:set_callback(function ()

                Helper.Locations.Building:Cancel()

                local localplayer = entity.get_local_player()
                if(localplayer == nil) then
                    common.add_notify("Builder", "\aFF7276FFLocalPlayer is not valid!")
                    return
                end

                local weapon = localplayer:get_player_weapon()
                if(weapon == nil) then
                    common.add_notify("Builder", "\aFF7276FFWeapon is not valid!")
                    return
                end

                local weapon_info = weapon:get_weapon_info()
                if(weapon_info == nil) then
                    common.add_notify("Builder", "\aFF7276FFWeapon is not valid!")
                    return
                end

                local map_data = common.get_map_data()
                if(map_data == nil) then
                    common.add_notify("Builder", "\aFF7276FFMap is not valid!")
                    return
                end

                if(weapon_info.weapon_type ~= 9) then
                    common.add_notify("Builder", "\aFF7276FFYour weapon must be a Grenade!")
                    return
                end

                self.builder.extra.types_label:visibility(true)

                for _, item in pairs(self.builder.types) do
                    item:visibility(false)
                end

                for key, value in pairs(self.builder.location.common) do
                    value:visibility(true)
                end

                for key, value in pairs(self.builder.location.grenade) do
                    value:visibility(true)
                end

                Helper.Locations.Building:CreateGrenade(localplayer, weapon, map_data.shortname)
                Helper.Locations:Update()
            end)

            self.builder.types.create_movement_button = helper_builder_types:button("Create Movement")
            self.builder.types.create_movement_button:set_callback(function ()

                Helper.Locations.Building:Cancel()

                local localplayer = entity.get_local_player()
                if(localplayer == nil) then
                    common.add_notify("Builder", "\aFF7276FFLocalPlayer is not valid!")
                    return
                end

                local weapon = localplayer:get_player_weapon()
                if(weapon == nil) then
                    common.add_notify("Builder", "\aFF7276FFWeapon is not valid!")
                    return
                end

                local weapon_info = weapon:get_weapon_info()
                if(weapon_info == nil) then
                    common.add_notify("Builder", "\aFF7276FFWeapon is not valid!")
                    return
                end

                local map_data = common.get_map_data()
                if(map_data == nil) then
                    common.add_notify("Builder", "\aFF7276FFMap is not valid!")
                    return
                end

                self.builder.extra.types_label:visibility(true)

                for _, item in pairs(self.builder.types) do
                    item:visibility(false)
                end

                for key, value in pairs(self.builder.location.common) do
                    value:visibility(true)
                end

                for key, value in pairs(self.builder.location.movement) do
                    value:visibility(true)
                end

                Helper.Locations.Building:CreateMovement(localplayer, weapon, map_data.shortname)
                Helper.Locations:Update()
            end)

            self.builder.types.create_oneway_button = helper_builder_types:button("Create One-way")
            self.builder.types.create_oneway_button:set_callback(function ()

                Helper.Locations.Building:Cancel()

                local localplayer = entity.get_local_player()
                if(localplayer == nil) then
                    common.add_notify("Builder", "\aFF7276FFLocalPlayer is not valid!")
                    return
                end

                local weapon = localplayer:get_player_weapon()
                if(weapon == nil) then
                    common.add_notify("Builder", "\aFF7276FFWeapon is not valid!")
                    return
                end

                local weapon_info = weapon:get_weapon_info()
                if(weapon_info == nil) then
                    common.add_notify("Builder", "\aFF7276FFWeapon is not valid!")
                    return
                end

                local map_data = common.get_map_data()
                if(map_data == nil) then
                    common.add_notify("Builder", "\aFF7276FFMap is not valid!")
                    return
                end

                if(weapon_info.weapon_type == 0 or weapon_info.weapon_type == 7 or weapon_info.weapon_type == 9) then
                    common.add_notify("Builder", "\aFF7276FFYou can't create One-Way with Knifes, Bombs or Grenades")
                    return
                end

                self.builder.extra.types_label:visibility(true)

                for _, item in pairs(self.builder.types) do
                    item:visibility(false)
                end

                for key, value in pairs(self.builder.location.common) do
                    value:visibility(true)
                end

                for key, value in pairs(self.builder.location.oneway) do
                    value:visibility(true)
                end

                Helper.Locations.Building:CreateOneway(localplayer, weapon, map_data.shortname)
                Helper.Locations:Update()
            end)

            self.builder.location.common.name = helper_builder_location:input("Name", "Custom")
            self.builder.location.common.name:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.name = this:get()

                    Helper.Locations:Update()
                end
            end)

            self.builder.location.grenade.pitch = helper_builder_location:slider("Pitch", -890, 890, 0, 0.1)
            self.builder.location.grenade.pitch:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.ang[1] = this:get() * 0.1

                    Helper.Locations:Update()
                end
            end)

            self.builder.location.grenade.yaw = helper_builder_location:slider("Yaw", - 1800, 1800, 0, 0.1)
            self.builder.location.grenade.yaw:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.ang[2] = this:get() * 0.1

                    Helper.Locations:Update()
                end
            end)

            self.builder.location.grenade.strength = helper_builder_location:slider("Throw Strength", 0, 10, 10, 0.1)
            self.builder.location.grenade.strength:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.strength = this:get() * 0.1
                end
            end)

            self.builder.location.grenade.runduration = helper_builder_location:slider("Run duration", 0, 640, 0, 0.1, function (value)
                return value * 0.1
            end)
            self.builder.location.grenade.runduration:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.runduration = this:get() * 0.1
                end
            end)

            self.builder.location.grenade.rundirection = self.builder.location.grenade.runduration:create():slider("Direction", -1800, 1800, 0, 0.1)
            self.builder.location.grenade.rundirection:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.rundirection = this:get() * 0.1
                end
            end)

            self.builder.location.grenade.runspeed = self.builder.location.grenade.runduration:create():slider("Speed", 0, 4500, 4500, 0.1)
            self.builder.location.grenade.runspeed:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.runspeed = this:get() * 0.1
                end
            end)

            self.builder.location.grenade.jump = helper_builder_location:switch("Jump")
            self.builder.location.grenade.jump:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                   location.jump = this:get()
                end
            end)

            self.builder.location.grenade.jumpdelay = self.builder.location.grenade.jump:create():slider("Jump duration", 0, 640, 0, 0.1, function (value)
                return value * 0.1
            end)
            self.builder.location.grenade.jumpdelay:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.jumpdelay = this:get() * 0.1
                end
            end)

            self.builder.location.grenade.duck = helper_builder_location:switch("Duck")
            self.builder.location.grenade.duck:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.duck = this:get()
                end
            end)

            self.builder.location.grenade.backupduration = helper_builder_location:slider("Recovery duration", 0, 640, 0, 0.1, function (value)
                return value * 0.1
            end)
            self.builder.location.grenade.backupduration:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.backupduration = this:get() * 0.1
                end
            end)

            self.builder.location.grenade.backupdirection = self.builder.location.grenade.backupduration:create():slider("Direction", -1800, 1800, 0, 0.1)
            self.builder.location.grenade.backupdirection:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                   location.backupdirection = this:get() * 0.1
                end
            end)

            self.builder.location.grenade.recoveryjump = self.builder.location.grenade.backupduration:create():switch("Jump")
            self.builder.location.grenade.recoveryjump:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.recoveryjump = this:get()
                end
            end)

            self.builder.location.oneway.allweapons = helper_builder_location:switch("Enable for every weapon")
            self.builder.location.oneway.allweapons:set_callback(function (this)
                local location = Helper.Locations.Building:Get()
                if(location) then
                    location.allweapons = this:get()
                end
            end)

            self.builder.location.common.configs_combo = helper_builder_location:combo("Config", {"1. None"})
            self.builder.location.common.save_button = helper_builder_location:button("Save")
            self.builder.location.common.save_button:set_callback(function (this)
                if(self.builder.location.common.configs_combo:get() == "1. None") then
                    Menu.extra.highlight_item:PushItem(self.builder.location.common.configs_combo, 1)
                    return
                end

                Helper.Locations.Building:Save()
            end)

            self.builder.location.common.cancel_button = helper_builder_location:button("Cancel")
            self.builder.location.common.cancel_button:set_callback(function (this)
                Helper.Locations.Building:Cancel()
            end)

            ----------------------------------------- CONFIG EDITOR ---------------------------------------------------

            -- up to you

            ----------------------------------------------------------------------------------------------------

            ------TERMPORAL CONFIG IMPORT--------------
            
            -- make your own config system, if you see this message. this was made just to allow old users use their configs

            winapi.CreateDirectory('nl/scripts/helper')

            local helper_config_import_tab = ui.create('Configs', 'Importer')
            helper_config_import_tab:label('USAGE: Copy full content from .json file that was given to you through ticket ( Discord ), and press button below.')

            local import_from_clipboard_button = helper_config_import_tab:button('Import config from clipboard')
            import_from_clipboard_button:set_callback(function (this)
                local config_raw = clipboard.get()
                local config_data = json.parse(config_raw)
                local config_path = string.format('nl/scripts/helper/%d.json', #configs_database)

                winapi.WriteFile(config_path, config_raw)

                table.insert(configs_database,
                {
                    path = config_path,
                    config = config_data,
                })

                local config_names = {}
                for i, _ in pairs(configs_database) do
                    table.insert(config_names, tostring(i - 1))
                end

                self.main.settings.configs_combo:update(config_names)
            end)

            --------------------------------------------

            utils.execute_after(0.1, function ()
                Helper.Locations.Building:Cancel()

                local config_names = {}
                for i, _ in pairs(configs_database) do
                    table.insert(config_names, tostring(i - 1))
                end

                self.main.settings.configs_combo:update(config_names)
            end)
        end,
    },

    neverlose =
    {
        items = {},

        Init = function (self)
            self.items.doubletap_switch = ui.find("Aimbot", "Ragebot", "Main", "Double Tap")
            self.items.hideshots_switch = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
            self.items.hideshots_option = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options")

            self.items.body_yaw_switch = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw")
            self.items.airstrafe_switch = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe")
            self.items.airstrafe_smoothing_slider = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe", "Smoothing")
            self.items.slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
            self.items.quick_switch_combo = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions")
        end,

        OnPlaybackBegin = function(self)
            Menu.extra.override_hook.helper_call = true
            self.items.airstrafe_switch:override(false)
            self.items.quick_switch_combo:override({})
            Menu.extra.override_hook.helper_call = false
        end,

        OnAfterplayBegin = function (self)
            Menu.extra.override_hook.helper_call = true
            self.items.airstrafe_switch:override(true)
            self.items.airstrafe_smoothing_slider:override(0)
            Menu.extra.override_hook.helper_call = false
        end,

        OnPlaybackEnd = function(self)
            Menu.extra.override_hook.helper_call = true
            self.items.airstrafe_switch:override()
            self.items.airstrafe_smoothing_slider:override()
            self.items.quick_switch_combo:override()
            Menu.extra.override_hook.helper_call = false
        end,

        OnShutdown = function (self)
            self:OnPlaybackEnd()
        end,
    },

    -- useless anti-aim scripts break parking
    extra = -- getmetatable porezali hz kak fixit', da i pohui
    {
        override_hook =
        {
            Init = function (self)
                self.menu_item_sample = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw")
                self.menu_item_override = getmetatable(self.menu_item_sample).override
    
                self.helper_call = false
    
                getmetatable(self.menu_item_sample).override = function (...)
                    local arg = {...}
                    local this = arg[1]

                    if(self.helper_call == false and Helper.CURRENT_HELPER_STATE:Get() > 1) then
                        for _, item in pairs(Menu.neverlose.items) do
                            if(item:id() == this:id()) then
                                return
                            end
                        end
                    end
                    self.menu_item_override(this, unpack(arg, 2))
                end
            end,
    
            OnShutdown = function (self)
                getmetatable(self.menu_item_sample).override = self.menu_item_override
            end,
        },

        highlight_item =
        {
            queue = {},

            PushItem = function (self, menu_item, time, check_func)
                for _, queue_item in ipairs(self.queue) do
                    if(queue_item.item:id() == menu_item:id()) then
                        return
                    end
                end

                local cur_realtime = globals.realtime

                check_func = check_func or function ()
                    return globals.realtime <= cur_realtime + time
                end

                table.insert(self.queue,
                {
                    item = menu_item,
                    checker = check_func,
                    clear_name = menu_item:name(),

                    exp_time = cur_realtime + time,
                    duration = time,

                    current_angle = 0,
                })
            end,
            
            UpdateQueue = function (self)
                local global_style = ui.get_style()

                local text_color = global_style.Text

                for i, queue_item in ipairs(self.queue) do
                    if(queue_item.checker() == false) then
                        queue_item.item:name(queue_item.clear_name)
                        table.remove(self.queue, i)
                    else
                        if(queue_item.duration > 0) then
                            local dtime = queue_item.exp_time - globals.realtime
                            queue_item.current_angle = 360 * (1 - dtime / queue_item.duration)
                        else
                            queue_item.current_angle = queue_item.current_angle + 1
                        end
                        
                        local current_alpha = math.ceil(text_color.a * math.cos(math.rad(queue_item.current_angle)) ^ 2)
                        local current_color = color(text_color.r, text_color.g, text_color.b, current_alpha)
                        local current_name = string.format("\a%s%s", current_color:to_hex(), queue_item.clear_name)
                        queue_item.item:name(current_name)
                    end
                end
            end,
        }
    },
}

eRender =
{
    Execute = function (self)
        for render_item_index = 1, #self do
            local render_item = self[render_item_index]

            render_item.api_func(unpack(render_item.params))
        end
        for debug_item_index = 1, #(self.Debug) do
            local debug_item = self.Debug[debug_item_index]

            debug_item.api_func(unpack(debug_item.params))
        end
    end,
    ClearRenderTable = function (self)
        for i = 1, #self do self[i] = nil end
    end,
    Push = function (self, api_func, params, extra)
        table.insert(self,
        {
            api_func = api_func,
            params = params,
            extra = extra,
        })
    end,

    draw = function (self)
        self:Execute()

        self:ClearRenderTable()
    end,

    Debug =
    {
        Push = function (self, api_func, params, extra)
            table.insert(self,
            {
                api_func = api_func,
                params = params,
                extra = extra,
            })
        end,
        ClearDebugRender = function (self)
            for i = 1, #self do self[i] = nil end
        end,
    },

    Fonts =
    {
        Init = function (self)
            self.location_text_font = render.load_font("Bahnschrift", 18 * render.helper_screen_scale[2], "a")
            self.target_text_font = render.load_font("Bahnschrift", 17 * render.helper_screen_scale[2], "a")
            self.description_text_font = render.load_font("Bahnschrift", 16 * render.helper_screen_scale[2], "a")
            self.warning_text_font = render.load_font("Bahnschrift", 10 * render.helper_screen_scale[2], "a")
        end,
    },

    Style =
    {
        style_name = "",

        weapon_icon_size = {},
        weapon_icon_offset = {},

        style_table =
        {
            location_background_color = color(),
            location_text_color = color(),
            location_weapon_color = color(),
            target_circle_color = color(),

            volatile_location_color = color("8B0000FF"),
            volatile_location_second_color = color(0, 255),
        },
    },

    Extra =
    {
        OutOfViewIndicator = function (screen_point, clr)
            local screen_center = render.screen_size() * 0.5
            local angle = math.rad((screen_point - screen_center):angles().y)
    
            local poly_base = screen_center + vector(math.cos(angle), math.sin(angle)) * 500
            local poly_points = {}
        
            for i = 0, 2 do
                local point_angle = angle + math.rad(120 * i)
                local point_direction = vector(math.cos(point_angle), math.sin(point_angle))
        
                table.insert(poly_points, poly_base + point_direction * 20)
            end
        
            eRender:Push(render.poly, {clr, unpack(poly_points)})
        end,
    }
}

Helper =
{
    Locations =
    {
        locations = {},
        next_visible_check_time = globals.realtime,

        Clear = function (self)
            self.locations = {}
        end,
        Check = function (self, location, weapon_classname, current_map, weapon_info)
            if(location == nil) then return false end
            if(location.map ~= current_map and Globals.overlapping_maps[current_map] ~= location.map) then return false end
            if(location.type == 0) then
                if(location.tickrate and location.tickrate ~= Globals.tickrate and location.runduration ~= 0 and location.jumpdelay ~= 0) then
                    return false
                end
                if(location.classname ~= weapon_classname) then
                    return false
                end
                if(Menu.helper.main.settings.types_combo:get(Globals.grenade_types_classnames[location.classname]) == false) then
                    return false
                end
            end
            if(location.type == 1) then
                if(location.tickrate and location.tickrate ~= Globals.tickrate) then
                    return false
                end
                if(location.airaccelerate and location.airaccelerate ~= Globals.sv_airaccelerate:int()) then
                    return false
                end
                if(location.classname ~= weapon_classname) then
                    return false
                end
                if(Menu.helper.main.settings.types_combo:get("Movement") == false) then
                    return false
                end
            end
            if(location.type == 2) then
                if(location.allweapons == false and location.classname ~= weapon_classname) then
                    return false
                end
                if(weapon_info.weapon_type == 0 or weapon_info.weapon_type == 7 or weapon_info.weapon_type == 9) then
                    return false
                end
                if(Menu.helper.main.settings.types_combo:get("One-way") == false) then
                    return false
                end
            end
            
            return true
        end,
        Update = function (self, weapon_entity_index)
            self:Clear()
            eRender:ClearRenderTable()
            self.next_visible_check_time = 0
            if(globals.is_connected == false) then return end
            if(common.get_map_data() == nil) then return end

            local current_map = common.get_map_data().shortname

            local localplayer = entity.get_local_player()
            if(localplayer == nil) then return end

            local weapon = localplayer:get_player_weapon()
            if(weapon_entity_index) then weapon = entity.get(weapon_entity_index) end
            if(weapon == nil) then return end

            local weapon_info = weapon:get_weapon_info()
            if(weapon_info == nil) then return end

            if(weapon_info.console_name == "weapon_taser") then return end

            local weapon_icon = weapon:get_weapon_icon()

            local weapon_classname = weapon:get_classname()
            if(weapon_classname == "CIncendiaryGrenade") then
                weapon_classname = "CMolotovGrenade"
            end

            local is_weapon_hegrenade = weapon:get_classname() == "CHEGrenade"

            local l_location_table = {}

            local building_location = self.Building:Get()
            local editing_location = self.Editing:Get()

            local config_table = {}
            for k, v in pairs(configs_database) do
                config_table[tostring(k - 1)] = v.config
            end

            for config_name, config in pairs(config_table) do
                if(Menu.helper.main.settings.configs_combo:get(config_name)) then
                    for location_index = 1, #config do
                        local location = config[location_index]
                        if(location ~= editing_location and self:Check(location, weapon_classname, current_map, weapon_info)) then
                            table.insert(l_location_table, location)
                        end
                    end
                end
            end

            if(self:Check(building_location, weapon_classname, current_map, weapon_info)) then
                table.insert(l_location_table, building_location)
            end
            if(self:Check(editing_location, weapon_classname, current_map, weapon_info)) then
                table.insert(l_location_table, editing_location)
            end

            eRender.Style.weapon_icon_size[1] = weapon_icon.width * render.helper_weapon_icon_scale[1] * render.helper_screen_scale[2]
            eRender.Style.weapon_icon_size[2] = weapon_icon.height * render.helper_weapon_icon_scale[2] * render.helper_screen_scale[2]

            eRender.Style.weapon_icon_offset[1] = eRender.Style.weapon_icon_size[1] * 0.5
            eRender.Style.weapon_icon_offset[2] = eRender.Style.weapon_icon_size[2] * 0.5

            local l_location_table_size = #l_location_table

            for t = 1, l_location_table_size do
                local t_loc = l_location_table[t]

                if(t_loc) then
                    local last_location_table =
                    {
                        render_info =
                        {
                            visible_state = false,

                            box = {},
                            weapon_icon = {},
                            name = {},
                            sep_line = {},
                        }
                    }

                    last_location_table.render_info.box.alpha = 0
                    last_location_table.render_info.box.base_offset = {0, 0}
                    last_location_table.render_info.box.point_offset = {0, 0}
    
                    last_location_table.render_info.weapon_icon.alpha = 0
                    last_location_table.render_info.weapon_icon.point_offset = {0, 0}
                    last_location_table.render_info.name.alpha = 0
                    last_location_table.render_info.name.text = ""
                    last_location_table.render_info.name.offset = {0, 0}
                    last_location_table.render_info.name.point_offset = {0, 0}
    
                    last_location_table.render_info.sep_line.alpha = 0
                    last_location_table.render_info.sep_line.offset = {1 * render.helper_screen_scale[1], 0}
                    last_location_table.render_info.sep_line.point_offset = {0, 0}
    
                    for t_1 = t, l_location_table_size do
                        local location = l_location_table[t_1]

                        if(location and Math.Extra.GetTableDistanceSqr(t_loc.pos, location.pos) <= render.helper_location_fustion_distance_sqr) then

                            last_location_table.render_info.name.text = last_location_table.render_info.name.text .. "   "
                            if(location == building_location or location == editing_location) then
                                last_location_table.render_info.name.text = last_location_table.render_info.name.text .. "\aFF0000FF"
                            end
                            last_location_table.render_info.name.text = last_location_table.render_info.name.text .. location.name .. "\n"

                            Math.current_vectors[1].x = location.pos[1]
                            Math.current_vectors[1].y = location.pos[2]
                            Math.current_vectors[1].z = location.pos[3] + 64
    
                            local last_location_info =
                            {
                                location = location,
            
                                render_info =
                                {
                                    box = {},
                                    circle = {},
                                    name = {},
                                    sep_line = {},
                                },
                            }
            
                            last_location_info.crosshair_position = utils.trace_line(Math.current_vectors[1], Math.current_vectors[1] + vector():angles(location.ang[1], location.ang[2]) * 600, localplayer, 0x200400B, 1).end_pos:clone()
                            
                            last_location_info.render_info.circle.alpha = 0
                            last_location_info.render_info.circle.bounds =
                            {
                                render.helper_target_circle_radius * 2 * render.helper_screen_scale[1],
                                render.helper_target_circle_radius * 2 * render.helper_screen_scale[1],
                            }
                            last_location_info.render_info.circle.offset =
                            {
                                render.helper_target_circle_radius * render.helper_screen_scale[1],
                                render.helper_target_circle_radius * render.helper_screen_scale[1],
                            }
            
                            last_location_info.render_info.name.text = "   >>" .. location.name
                            last_location_info.render_info.name.alpha = 0
                            last_location_info.render_info.name.bounds = render.measure_text(eRender.Fonts.target_text_font, "", last_location_info.render_info.name.text)
                            last_location_info.render_info.name.offset =
                            {
                                last_location_info.render_info.name.bounds.x * 0.5,
                                last_location_info.render_info.name.bounds.y * 0.5,
                            }
                            last_location_info.render_info.name.point_offset =
                            {
                                -last_location_info.render_info.circle.offset[1],
                                last_location_info.render_info.name.offset[2],
                            }
            
                            last_location_info.render_info.box.alpha = 0
                            last_location_info.render_info.box.bounds =
                            {
                                math.max(last_location_info.render_info.circle.bounds[1], last_location_info.render_info.name.bounds.y) + 10 * render.helper_screen_scale[1],
                                math.max(last_location_info.render_info.circle.bounds[2], last_location_info.render_info.name.bounds.y) + 10 * render.helper_screen_scale[2],
                            }
                            last_location_info.render_info.box.point_offset =
                            {
                                last_location_info.render_info.box.bounds[1] * 0.5,
                                last_location_info.render_info.box.bounds[2] * 0.5,
                            }
                            last_location_info.render_info.box.default_bounds =
                            {
                                last_location_info.render_info.box.bounds[1],
                                last_location_info.render_info.box.bounds[2],
                            }
            
                            last_location_info.render_info.sep_line.alpha = 0
                            last_location_info.render_info.sep_line.point_offset = {0, 0}
                            last_location_info.render_info.sep_line.offset = {1 * render.helper_screen_scale[1], 0}

                            if(is_weapon_hegrenade and location.detonate_position) then
                                last_location_info.render_info.detonate_info =
                                {
                                    ground_circle =
                                    {
                                        alpha = 0,
                                        radius = 0,
                                    },

                                    text =
                                    {
                                        alpha = 0,
                                        text = "",
                                        bounds = {0, 0},
                                    },

                                    box =
                                    {
                                        alpha = 0,
                                        point_offset = {0, 0},
                                        bounds = {0, 0},
                                    },
                                }

                                
                            end
    
                            table.insert(last_location_table, last_location_info)
                            l_location_table[t_1] = nil
                        end
                    end

                    local x, y, z = 0, 0, 0
                    local llt_size = #last_location_table

                    for i = 1, llt_size do
                        local loc_info = last_location_table[i]

                        x = x + loc_info.location.pos[1]
                        y = y + loc_info.location.pos[2]
                        z = z + loc_info.location.pos[3]
                    end

                    last_location_table.render_info.position = {x / llt_size, y / llt_size, z / llt_size}

                    local text_size = render.measure_text(eRender.Fonts.location_text_font, "", last_location_table.render_info.name.text)

                    last_location_table.render_info.name.offset[1] = text_size.x * 0.5
                    last_location_table.render_info.name.offset[2] = text_size.y * 0.5

                    table.insert(self.locations, last_location_table)
                end
            end
        end,
        GetClosestLocationTable = function (self)
            local localplayer = entity.get_local_player()
            if(localplayer == nil) then return nil end

            local localplayer_position = localplayer:get_origin()

            local min_distance = 1000000
            local closest_location_table = nil

            for _, location_table in pairs(self.locations) do
                for _, loc_info in ipairs(location_table) do
                    local dist = Math.Extra.GetVectorTableDistanceSqr(localplayer_position, loc_info.location.pos)

                    if(dist < min_distance) then
                        min_distance = dist
                        closest_location_table = location_table
                    end
                end
            end

            return closest_location_table, min_distance
        end,

        Target =
        {
            location = nil,

            executed_weapon_index = 0,

            setup_begin = false,
            setup_ready = false,
            setup_afterplay = false,

            run_tick = 0,
            jump_tick = 0,

            backup_tick = 0,
            backup_direction = 0,
            backup_jump = false,

            cmd_index = 1,
            should_hold_grenade = false,
            grenade_being_thrown = false,

            afterplay_tick = 0,

            last_executed_location = nil,

            Set = function(self, target)
                if(self:InPlayback()) then return end

                self.location = target
            end,

            Get = function(self)
                return self.location
            end,

            SetupAfterplay = function (self, cmd)
                if(self.location.type == 0) then
                    self.backup_tick = cmd.tickcount + (self.location.backupduration or 0)
                    self.backup_jump = self.location.recoveryjump or false
                    
                    self.afterplay_tick = math.max(cmd.tickcount + 64, self.backup_tick)
                else
                    self.afterplay_tick = cmd.tickcount + 64
                end

                self.last_executed_location = self.location
                self.setup_afterplay = true
                self.setup_begin = false
            end,

            Begin = function (self, weapon)
                if(self.location.type == 2) then return end
                if(self.location.type == 1 and #self.location.cmds == 0) then return end

                self.executed_weapon_index = weapon:get_index()

                Menu.neverlose:OnPlaybackBegin()
                self.setup_begin = true
            end,

            Execute = function(self, cmd)
                local localplayer = entity.get_local_player()
                local weapon = localplayer:get_player_weapon()
                local weapon_info = weapon:get_weapon_info()

                if(self.setup_begin) then

                    if(weapon:get_index() ~= self.executed_weapon_index) then
                        self:Stop()
                        return
                    end

                    Helper.CURRENT_HELPER_STATE:Set(3)

                    cmd.jitter_move = false
                    Menu.neverlose.items.slowwalk:set(false)

                    if(self.location.type == 0) then
                        local duck_ready, strength_ready, pin_ready = false, false, false

                        local strength_hard_check = false

                        cmd.buttons = 0
                        cmd.forwardmove = 0
                        cmd.sidemove = 0
    
                        if(self.location.duck) then
                            cmd.in_duck = true
                        else
                            cmd.in_duck = false
                        end

                        if(self.location.strength == nil or self.location.strength == 1) then
                            cmd.in_attack = true
                            cmd.in_attack2 = false
                        elseif(self.location.strength == 0.5) then
                            cmd.in_attack = true
                            cmd.in_attack2 = true
                        elseif(self.location.strength == 0) then
                            cmd.in_attack = false
                            cmd.in_attack2 = true
                        else
                            strength_hard_check = true
                            if(weapon.m_flThrowStrength <= (self.location.strength or 1)) then
                                cmd.in_attack = true
                            else
                                cmd.in_attack2 = true
                            end
                        end
        
                        if(weapon.m_bPinPulled) then
                            pin_ready = true
                        end
                        if(self.location.duck and localplayer.m_flDuckAmount == 1 or localplayer.m_flDuckAmount == 0) then
                            duck_ready = true
                        end
                        if(strength_hard_check) then
                            if(math.abs((self.location.strength or 1) - weapon.m_flThrowStrength) <= 0.1) then
                                strength_ready = true
                            end
                        else
                            if((self.location.strength or 1) == weapon.m_flThrowStrength) then
                                strength_ready = true
                            end
                        end
    
                        if(self.setup_ready == false and strength_ready and duck_ready and pin_ready) then
                            self.setup_ready = true
    
                            self.run_tick = cmd.tickcount + (self.location.runduration or 0)
                            self.jump_tick = self.run_tick + (self.location.jumpdelay or 0)
                            if(rage.exploit:get() == 1 and (Menu.neverlose.items.doubletap_switch:get() or Menu.neverlose.items.hideshots_switch:get() and Menu.neverlose.items.hideshots_option:get() == 'Break LC')) then
                                self.jump_tick = self.jump_tick + 6
                            end
                        end

                        if(self.setup_ready) then
                            if((self.location.runduration or 0) > 0) then
                                local move_direction = math.rad(cmd.view_angles.y - (self.location.ang[2] + (self.location.rundirection or 0)))
        
                                cmd.forwardmove = math.cos(move_direction) * (self.location.runspeed or 450)
                                cmd.sidemove = math.sin(move_direction) * (self.location.runspeed or 450)
                            end
        
                            if(cmd.tickcount >= self.run_tick) then
                                
                                if(self.location.jump) then
                                    cmd.in_jump = true
                                end
        
                                if(cmd.tickcount >= self.jump_tick) then
                                    cmd.in_attack = false
                                    cmd.in_attack2 = false
                                end
                            end
                            
                            if(weapon.m_fThrowTime > 0) then
                                cmd.view_angles.x = self.location.ang[1]
                                cmd.view_angles.y = self.location.ang[2]
                                cmd.send_packet = false

                                self.grenade_being_thrown = true
                            elseif(self.grenade_being_thrown) then
                                self.grenade_being_thrown = false
                                self:SetupAfterplay(cmd)
                            end
                        end
                    elseif(self.location.type == 1) then

                        if(self.setup_ready == false) then
                            self.setup_ready = true

                            self.cmd_index = 1

                            if(weapon_info.weapon_type == 9 and weapon.m_bPinPulled) then
                                self.should_hold_grenade = true
                            end
                        end
                    end
                end
            end,

            DCExecute = function (self)
                if(self.setup_begin and Menu.helper.main.settings.fov_slider:get() <= Globals.target_location_legit_fov) then
                    if(self.location.type == 0) then
                        render.camera_angles(vector(self.location.ang[1], self.location.ang[2]))
                    elseif(self.location.type == 1 and self.setup_ready) then
                        local current_cmd = self.location.cmds[self.cmd_index]
                        if(current_cmd.engine_viewangles) then
                            render.camera_angles(vector(current_cmd.engine_viewangles[1], current_cmd.engine_viewangles[2]))
                        end
                    end
                end
            end,

            ExecuteRuncommand = function (self, runcmd)
                local localplayer = entity.get_local_player()
                if(localplayer == nil) then return end
                
                local weapon = localplayer:get_player_weapon()
                if(weapon == nil) then return end

                local weapon_classname = weapon:get_classname()
                if(weapon_classname == "CIncendiaryGrenade") then
                    weapon_classname = "CMolotovGrenade"
                end

                if(self.setup_ready) then
                    if(self.location.type == 1) then
                        local current_cmd = self.location.cmds[self.cmd_index]

                        if(bit.band(current_cmd.buttons, 1) == 1) then
                            self.should_hold_grenade = false
                        end
                        
                        Helper.LocalPlayer.cmd.buttons = current_cmd.buttons
                        if(self.should_hold_grenade) then
                            Helper.LocalPlayer.cmd.buttons = bit.bor(Helper.LocalPlayer.cmd.buttons, 1)
                        end

                        if(Globals.grenade_types_classnames[weapon_classname] and weapon.m_fThrowTime > 0 and globals.curtime >= weapon.m_fThrowTime) then
                            Helper.LocalPlayer.cmd.forwardmove = current_cmd.forwardmove
                            Helper.LocalPlayer.cmd.sidemove = current_cmd.sidemove
                            Helper.LocalPlayer.cmd.view_angles.x = current_cmd.viewangles[1]
                            Helper.LocalPlayer.cmd.view_angles.y = current_cmd.viewangles[2]
                        else
                            local dang = math.rad(math.normalize_yaw(Helper.LocalPlayer.cmd.view_angles.y - current_cmd.viewangles[2]))

                            Helper.LocalPlayer.cmd.forwardmove = math.cos(dang) * current_cmd.forwardmove + math.cos(dang + math.pi / 2) * current_cmd.sidemove
                            Helper.LocalPlayer.cmd.sidemove = math.sin(dang) * current_cmd.forwardmove + math.sin(dang + math.pi / 2) * current_cmd.sidemove
    
                        end


                        self.cmd_index = self.cmd_index + 1

                        if(self.cmd_index > #self.location.cmds) then
                            self:SetupAfterplay(Helper.LocalPlayer.cmd)
                        end
                    end
                end
            end,

            Afterplay = function (self, cmd)
                if(self.setup_afterplay) then
                    if(self.setup_ready) then
                        Menu.neverlose:OnAfterplayBegin()
                        self.setup_ready = false
                    end

                    if(self.location.type == 0) then
                        if(self.backup_jump) then
                            cmd.in_jump = true
                            if(bit.band(entity.get_local_player().m_fFlags, 1) == 1) then
                                self.backup_jump = false
                            end
                        end
    
                        if(cmd.tickcount < self.backup_tick) then
                            local angle = math.rad(cmd.view_angles.y - self.location.ang[2] - (self.location.backupdirection or 0))
    
                            cmd.forwardmove = math.cos(angle) * 450
                            cmd.sidemove = math.sin(angle) * 450
                        end
                    end

                    if(cmd.tickcount >= self.afterplay_tick) then
                        self:Stop()
                        -- if(location_executer.current_location) then
                        --     location_executer.current_location = nil
                        --     cmd.weaponselect = location_executer.weapon_index
                        -- end
                    end
                end
            end,

            StopPlaybackOnly = function (self)
                self.setup_ready = false
                self.setup_begin = false

                self.cmd_index = 1
                self.run_tick = 0
                self.jump_tick = 0
            end,

            Stop = function (self)
                if(self:InPlayback()) then
                    self.location = nil
                    self.setup_ready = false
                    self.setup_begin = false
                    self.setup_afterplay = false
    
                    self.cmd_index = 1
                    self.should_hold_grenade = false
                    self.run_tick = 0
                    self.jump_tick = 0
                    self.backup_tick = 0
                    self.backup_jump = false
                    self.afterplay_tick = 0

                    Menu.neverlose:OnPlaybackEnd()
                end
            end,

            InAfterplay = function (self)
                return self.setup_afterplay
            end,

            InPlayback = function (self)
                return self.setup_begin or self.setup_ready or self.setup_afterplay
            end,
        },

        Editing =
        {
            backup_location = {},
            location = nil,
            config_data = nil,
            edit_table = nil,

            Get = function (self)
                return self.location
            end,

            GetLocationByIndex = function (self, idx)
                return self.edit_table[idx]
            end,

            Set = function (self, location, config_data)
                self.location = location
                self.config_data = config_data
                table.copy(self.location, self.backup_location)
            end,

            SetTable = function (self, edit_table)
                self.edit_table = edit_table
            end,

            Save = function (self, config)
                --Server:UpdateConfig(config, self.config_data)

                self.location = nil
                self.config_data = nil
            end,

            Cancel = function (self)
                if(self:Get()) then
                    table.copy(self.backup_location, self.location)
                    self.location = nil
                    self.config_data = nil
                    Helper.Locations:Update()
                end
            end,

            Remove = function (self, config)
                for idx, location in ipairs(config) do
                    if(self.location == location) then
                        table.remove(config, idx)

                        --Server:UpdateConfig(config, self.config_data)

                        self.location = nil
                        self.config_data = nil
                        Helper.Locations:Update()
                        return
                    end
                end
            end,
        },

        Building =
        {
            location = nil,
            in_record = false,

            Get = function (self)
                return self.location
            end,

            CreateGrenade = function (self, localplayer, weapon, map)
                local localplayer_position = localplayer:get_origin()
                local localplayer_viewangles = render.camera_angles()

                local weapon_classname = weapon:get_classname()
                if(weapon_classname == "CIncendiaryGrenade") then
                    weapon_classname = "CMolotovGrenade"
                end

                self.location =
                {
                    type = 0,
                    classname = weapon_classname,
                    pos =
                    {
                        localplayer_position.x,
                        localplayer_position.y,
                        localplayer_position.z,
                    },
                    ang =
                    {
                        localplayer_viewangles.x,
                        localplayer_viewangles.y,
                    },
                    name = "Custom",
                    description = "Custom",
                    map = map,
                    tickrate = Globals.tickrate,
                }

                Menu.helper.builder.location.grenade.pitch:set(localplayer_viewangles.x * 10)
                Menu.helper.builder.location.grenade.yaw:set(localplayer_viewangles.y * 10)

                common.add_notify("Builder", "\a80B362FFCreated " .. Globals.grenade_types_classnames[self.location.classname] .. " Grenade!")
            end,

            CreateMovement = function (self, localplayer, weapon, map)
                local localplayer_position = localplayer:get_origin()
                local localplayer_viewangles = render.camera_angles()
                
                local weapon_classname = weapon:get_classname()
                if(weapon_classname == "CIncendiaryGrenade") then
                    weapon_classname = "CMolotovGrenade"
                end

                self.location =
                {
                    type = 1,
                    classname = weapon_classname,
                    pos =
                    {
                        localplayer_position.x,
                        localplayer_position.y,
                        localplayer_position.z,
                    },
                    ang =
                    {
                        localplayer_viewangles.x,
                        localplayer_viewangles.y,
                    },
                    name = "Custom",
                    description = "Custom",
                    map = map,
                    tickrate = Globals.tickrate,
                    airaccelerate = Globals.sv_airaccelerate:int(),
                    cmds = {},
                }

                common.add_notify("Builder", "\a80B362FFCreated Movement!")
            end,

            CreateOneway = function (self, localplayer, weapon, map)
                local localplayer_position = localplayer:get_origin()
                local localplayer_viewangles = render.camera_angles()
                local weapon_classname = weapon:get_classname()

                self.location =
                {
                    type = 2,
                    classname = weapon_classname,
                    pos =
                    {
                        localplayer_position.x,
                        localplayer_position.y,
                        localplayer_position.z,
                    },
                    ang =
                    {
                        localplayer_viewangles.x,
                        localplayer_viewangles.y,
                    },
                    name = "Custom",
                    description = "Custom",
                    map = map,
                    allweapons = false,
                }

                common.add_notify("Builder", "\a80B362FFCreated One-Way!")
            end,

            InRecording = function (self)
                return self.in_record
            end,

            ToggleRecording = function (self)
                if(self.location == nil or self.location.type ~= 1) then return end

                local localplayer = entity.get_local_player()
                if(localplayer == nil) then return end

                local localplayer_position = localplayer:get_origin()
                local localplayer_viewangles = render.camera_angles()

                self.in_record = not self.in_record

                if(self.in_record) then
                    common.add_notify("Movement Recorder", "\a80B362FFRecording has been started!")

                    self.location.pos =
                    {
                        localplayer_position.x,
                        localplayer_position.y,
                        localplayer_position.z,
                    }
    
                    self.location.ang =
                    {
                        localplayer_viewangles.x,
                        localplayer_viewangles.y,
                    }
    
                    self.location.cmds = {}

                    Helper.Locations:Update()
                else
                    common.add_notify("Movement Recorder", "\aFF7276FFRecording has been stopped!")
                end
            end,

            RecordCurrentCmd = function (self, runcmd)
                if(self.location == nil or self.location.type ~= 1 or self.in_record == false) then return end

                local localplayer = entity.get_local_player()
                if(localplayer == nil) then return end

                if(Helper.LocalPlayer.cmd.weaponselect ~= 0) then
                    self.in_record = false

                    common.add_notify("Movement Recorder", "\aFF7276FFRecording has been stopped due to weapon switch!")
                    return
                end

                local localplayer_position = localplayer:get_origin()
                local localplayer_viewangles = render.camera_angles()

                table.insert(self.location.cmds,
                {
                    forwardmove = Helper.LocalPlayer.cmd.forwardmove,
                    sidemove = Helper.LocalPlayer.cmd.sidemove,
                    buttons = Helper.LocalPlayer.cmd.buttons,
                    viewangles = {Helper.LocalPlayer.cmd.view_angles.x, Helper.LocalPlayer.cmd.view_angles.y},
                    engine_viewangles = {localplayer_viewangles.x, localplayer_viewangles.y},
                    origin = {localplayer_position.x, localplayer_position.y, localplayer_position.z},
                })
            end,

            Cancel = function (self)
                for _, item in pairs(Menu.helper.builder.types) do
                    item:visibility(true)
                end

                Menu.helper.builder.extra.types_label:visibility(false)
                for _, items_table in pairs(Menu.helper.builder.location) do
                    for _, item in pairs(items_table) do
                        item:visibility(false)
                        item:reset()
                    end
                end

                if(self:Get()) then
                    self.location = nil
                    self.in_record = false
                    Helper.Locations:Update()
                end
            end,

            Save = function (self)
                --local config_data = SearchListByKey(Server.database, 'menu_name', Menu.helper.builder.location.common.configs_combo:get())

                --table.insert(config_data.config, self.location)

                --Server:UpdateConfig(config_data.config, config_data)
                
                --self:Cancel()
            end,
        },
    },

    LocalPlayer = 
    {
        cmd = nil,
        Weapon =
        {
            current_weapon_index = 0,

            SwapCheck = function (self)
                local localplayer = entity.get_local_player()
                if(localplayer == nil) then return false; end
                local weapon = localplayer:get_player_weapon()
                if(weapon == nil) then return false; end

                local ret = weapon:get_index() ~= self.current_weapon_index
                self.current_weapon_index = weapon:get_index()

                return ret
            end,
        },
    },

    AutoPull =
    {
        pull_state = false,

        init_weapon_id = 0,

        swap_state = false,

        Begin = function (self, cmd)
            local localplayer = entity.get_local_player()
            local weapon = localplayer:get_player_weapon()

            if(self.pull_state == false) then
                self.init_weapon_id = weapon:get_index()
                self.pull_state = true
            end

            cmd.in_attack = true
        end,

        SwitchBack = function (self, cmd)
            if(self.pull_state == false) then return end
            local localplayer = entity.get_local_player()
            local weapon = localplayer:get_player_weapon()
            if(Helper.Locations.Target:InPlayback() or weapon.m_bPinPulled == false) then
                self:Stop()
                return
            end

            if(self.swap_state) then
                cmd.weaponselect = self.init_weapon_id
                self.pull_state = false
                self.swap_state = false
            else
                local my_weapons = localplayer.m_hMyWeapons
                for i = 0, 63 do
                    if(my_weapons[i] and my_weapons[i]:get_index() ~= self.init_weapon_id) then
                        cmd.weaponselect = my_weapons[i]:get_index()
                        break
                    end
                end

                self.swap_state = true
            end
        end,

        Stop = function (self)
            self.pull_state = false
            self.swap_state = false
        end,
    },

    ExplosivePreview =
    {
        current_detonate_position = nil,
        current_location = nil,
        player_data = {},

        Set = function (self, location)
            if(location == nil or location.detonate_position == nil or location.classname ~= "CHEGrenade") then
                self.current_location = nil
                return
            end
            self.current_location = location
            self.current_detonate_position = vector(unpack(location.detonate_position))
        end,

        Update = function (self)
            local found_players_table_index = {}

            for i, player_info in ipairs(self.player_data) do
                found_players_table_index[player_info.index] = i

                if(player_info.location ~= self.current_location or player_info.damage <= 1) then
                    player_info.alpha = Math.Lerp(player_info.alpha, 0, globals.frametime * 10)
                    if(player_info.alpha < 10) then
                        table.remove(player_info, i)
                    end
                else
                    player_info.alpha = Math.Lerp(player_info.alpha, 255, globals.frametime * 10)
                end
            end

            if(self.current_location) then
                entity.get_players(true, false, function (player)
                    local player_info_index = found_players_table_index[player:get_index()]
                    local damage = Math.Extra:GetGrenadeDamage(player, self.current_detonate_position)
    
                    if(player_info_index) then
                        self.player_data[player_info_index].damage = damage
                        self.player_data[player_info_index].body_position = player:get_hitbox_position(4)
                    elseif(damage > 1) then
                        table.insert(self.player_data,
                        {
                            index = player:get_index(),
                            location = self.current_location,
                            alpha = 0,
                            damage = damage,
                            body_position = player:get_hitbox_position(4)
                        })
                    end
                end)
            end
        end,

        render = function (self)
            self:Update()

            for _, player_info in ipairs(self.player_data) do
                local body_screenpos = player_info.body_position:to_screen()
                if(body_screenpos) then
                    eRender:Push(render.text, {eRender.Fonts.target_text_font, body_screenpos, color(255, player_info.alpha), "c", player_info.damage})
                end
                
            end
        end,
    },

    CURRENT_HELPER_STATE =
    {
        Set = function (self, idx)
            self.state = Globals.helper_states[idx]
            self.state_idx = idx
        end,
        Get = function (self)
            return self.state_idx, self.state
        end,

        state = "",
        state_idx = 0,
        prev_state_idx = 0,
    },

    createmove = function (self, cmd)
        self.CURRENT_HELPER_STATE:Set(1)

        eRender.Debug:ClearDebugRender()
        self.Locations.Target:Set(nil)
        self.ExplosivePreview:Set(nil)
        self.LocalPlayer.cmd = cmd

        local localplayer = entity.get_local_player()
        if(localplayer == nil) then return end

        Globals.tickrate = math.floor(1 / globals.tickinterval + 0.5)
        globals.curtime = localplayer.m_nTickBase * globals.tickinterval
        render.animation_speed = 15 * globals.tickinterval

        local weapon = localplayer:get_player_weapon()
        if(weapon == nil) then return end

        local weapon_info = weapon:get_weapon_info()
        if(weapon_info == nil) then return end

        if(cmd.weaponselect ~= 0) then
            self.Locations.Target:Stop()
            self.AutoPull:Stop()
            return
        end

        local is_weapon_hegrenade = weapon:get_classname() == "CHEGrenade"

        if(is_weapon_hegrenade and self.Locations.Target:Get() == nil) then
            if(weapon.m_fThrowTime > 0 and weapon.m_fThrowTime <= globals.curtime) then
                self.Locations.Target.last_executed_location = nil
            end
        end

        local localplayer_position = localplayer:get_origin()
        local localplayer_eyeposition = localplayer:get_eye_position()
        local localplayer_viewangles = cmd.view_angles
        local localplayer_velocity = localplayer.m_vecAbsVelocity

        local target_location_current_fov = 181

        local closest_location_table, closest_location_table_distance_sqr = self.Locations:GetClosestLocationTable()

        local char_size_1 = render.measure_text(eRender.Fonts.location_text_font, "", " ") -- убрать в будущем
        local char_size_2 = render.measure_text(eRender.Fonts.target_text_font, "", " ") -- убрать в будущем

        local space_size_1 = char_size_1.x * 1.5 -- убрать в будущем
        local space_size_2 = char_size_2.x * 1.5 -- убрать в будущем

        local parking_pressing = Menu.helper.main.binds.parking_hotkey:get()--[[ or location_executer.current_location]]

        local should_check_visibility = self.Locations.next_visible_check_time <= globals.realtime
        if(should_check_visibility) then
            self.Locations.next_visible_check_time = globals.realtime + 0.14
            
            table.sort(self.Locations.locations, function (a, b)
                return Math.Extra.GetVectorTableDistanceSqr(localplayer_position, a.render_info.position) > Math.Extra.GetVectorTableDistanceSqr(localplayer_position, b.render_info.position)
            end)
        end

        for _, location_table in pairs(self.Locations.locations) do
            local render_info = location_table.render_info

            if(Math.Extra.GetVectorTableDistanceSqr(localplayer_position, render_info.position) < render.helper_location_render_distance_sqr) then
                local position_vector = vector(unpack(render_info.position))

                local screen_point = render.world_to_screen(position_vector)
                if(screen_point) then
                    if(should_check_visibility) then
                        local ray = utils.trace_line(localplayer_eyeposition, position_vector, localplayer, 0x200400B)
                        render_info.visible_state = ray.fraction > 0.98
                    end

                    local dist_to_location_sqr = Math.Extra.GetVectorTableDistanceSqr(localplayer_position, render_info.position)

                    if(render_info.visible_state) then
                        if(self.Locations.Target:InPlayback() == false and dist_to_location_sqr < render.helper_location_expand_distance_sqr) then

                            render_info.box.point_offset[1] = Math.Lerp(render_info.box.point_offset[1], 10 * render.helper_screen_scale[1] + eRender.Style.weapon_icon_offset[1] + render_info.name.offset[1])
                            render_info.box.point_offset[2] = Math.Lerp(render_info.box.point_offset[2], 5 * render.helper_screen_scale[2] + math.max(render_info.name.offset[2], eRender.Style.weapon_icon_offset[2]))

                            render_info.name.point_offset[1] = render_info.weapon_icon.point_offset[1] - eRender.Style.weapon_icon_size[1]
                            render_info.name.point_offset[2] = render_info.name.offset[2]

                            render_info.sep_line.point_offset[1] = render_info.name.point_offset[1] - space_size_1

                            if(render_info.box.point_offset[1] > eRender.Style.weapon_icon_offset[1] + render_info.name.offset[1] + 9 * render.helper_screen_scale[1]) then
                                render_info.name.alpha = Math.Lerp(render_info.name.alpha, eRender.Style.style_table.location_text_color.a)
                                render_info.sep_line.alpha = Math.Lerp(render_info.sep_line.alpha, eRender.Style.style_table.location_text_color.a)

                                render_info.sep_line.offset[2] = Math.Lerp(render_info.sep_line.offset[2], math.max(render_info.name.offset[2], eRender.Style.weapon_icon_offset[2]) - 4 * render.helper_screen_scale[2], render.animation_speed * 0.5)
                            end
                        else
                            render_info.sep_line.offset[2] = Math.Lerp(render_info.sep_line.offset[2], 0)
                            render_info.sep_line.alpha = Math.Lerp(render_info.sep_line.alpha, 0)
                            render_info.name.alpha = Math.Lerp(render_info.name.alpha, 0)
                            if(render_info.name.alpha < 1) then
                                render_info.box.point_offset[1] = Math.Lerp(render_info.box.point_offset[1], eRender.Style.weapon_icon_offset[1] + 10 * render.helper_screen_scale[1])
                                render_info.box.point_offset[2] = Math.Lerp(render_info.box.point_offset[2], eRender.Style.weapon_icon_offset[2] + 5 * render.helper_screen_scale[2])
                            end
                        end

                        render_info.box.alpha = Math.Lerp(render_info.box.alpha, eRender.Style.style_table.location_background_color.a)
                        if(render_info.box.point_offset[1] > eRender.Style.weapon_icon_offset[1] + 9 * render.helper_screen_scale[1]) then
                            render_info.weapon_icon.alpha = Math.Lerp(render_info.weapon_icon.alpha, eRender.Style.style_table.location_weapon_color.a)
                        end
                    elseif(render.helper_location_render_behind_walls and dist_to_location_sqr < render.helper_location_render_behind_walls_dist_sqr) then
                        render_info.box.alpha = Math.Lerp(render_info.box.alpha, 100)
                        render_info.weapon_icon.alpha = Math.Lerp(render_info.weapon_icon.alpha, 100)

                        render_info.name.alpha = Math.Lerp(render_info.name.alpha, 0)
                        render_info.sep_line.alpha = Math.Lerp(render_info.sep_line.alpha, 0)

                        if(render_info.name.alpha < 1) then
                            render_info.box.point_offset[1] = Math.Lerp(render_info.box.point_offset[1], eRender.Style.weapon_icon_offset[1] + 10 * render.helper_screen_scale[1])
                            render_info.box.point_offset[2] = Math.Lerp(render_info.box.point_offset[2], eRender.Style.weapon_icon_offset[2] + 5 * render.helper_screen_scale[2])
                        end
                    else
                        render_info.box.point_offset[1] = Math.Lerp(render_info.box.point_offset[1], eRender.Style.weapon_icon_offset[1] + 10 * render.helper_screen_scale[1])
                        render_info.box.point_offset[2] = Math.Lerp(render_info.box.point_offset[2], eRender.Style.weapon_icon_offset[2] + 5 * render.helper_screen_scale[2])

                        render_info.sep_line.alpha = Math.Lerp(render_info.sep_line.alpha, 0)
                        render_info.box.alpha = Math.Lerp(render_info.box.alpha, 0)
                        render_info.weapon_icon.alpha = Math.Lerp(render_info.weapon_icon.alpha, 0)
                        render_info.name.alpha = Math.Lerp(render_info.name.alpha, 0)
                    end
                else
                    render_info.box.point_offset[1] = Math.Lerp(render_info.box.point_offset[1], eRender.Style.weapon_icon_offset[1] + 10 * render.helper_screen_scale[1])
                    render_info.box.point_offset[2] = Math.Lerp(render_info.box.point_offset[2], eRender.Style.weapon_icon_offset[2] + 5 * render.helper_screen_scale[2])

                    render_info.sep_line.alpha = Math.Lerp(render_info.sep_line.alpha, 0)
                    render_info.box.alpha = Math.Lerp(render_info.box.alpha, 0)
                    render_info.weapon_icon.alpha = Math.Lerp(render_info.weapon_icon.alpha, 0)
                    render_info.name.alpha = Math.Lerp(render_info.name.alpha, 0)
                end
            else
                render_info.box.point_offset[1] = Math.Lerp(render_info.box.point_offset[1], eRender.Style.weapon_icon_offset[1] + 10 * render.helper_screen_scale[1])
                render_info.box.point_offset[2] = Math.Lerp(render_info.box.point_offset[2], eRender.Style.weapon_icon_offset[2] + 5 * render.helper_screen_scale[2])

                render_info.sep_line.alpha = Math.Lerp(render_info.sep_line.alpha, 0)
                render_info.box.alpha = Math.Lerp(render_info.box.alpha, 0)
                render_info.weapon_icon.alpha = Math.Lerp(render_info.weapon_icon.alpha, 0)
                render_info.name.alpha = Math.Lerp(render_info.name.alpha, 0)
            end

            render_info.weapon_icon.point_offset[1] = render_info.box.point_offset[1] - 11 * render.helper_screen_scale[1]
            render_info.weapon_icon.point_offset[2] = eRender.Style.weapon_icon_offset[2]

            if(self.Locations.Target:InPlayback() == false and location_table == closest_location_table and Math.Extra.GetVectorTableDistanceSqr(localplayer_position, render_info.position) < render.helper_target_render_distance_sqr)then
                table.sort(location_table, function(a, b)
                    return Math.Extra.GetLocationFOV(localplayer_eyeposition, localplayer_viewangles, a.crosshair_position) > Math.Extra.GetLocationFOV(localplayer_eyeposition, localplayer_viewangles, b.crosshair_position)
                end)

                local fov_location_info = location_table[#location_table]

                target_location_current_fov = Math.Extra.GetLocationFOV(localplayer_eyeposition, localplayer_viewangles, fov_location_info.crosshair_position)
                if(target_location_current_fov > render.helper_target_minimal_fov) then
                    fov_location_info = nil
                else--[[if(location_executer.current_location == nil) then]]
                    self.Locations.Target:Set(fov_location_info.location)
                    self.ExplosivePreview:Set(fov_location_info.location)
                end

                for idx, loc_info in ipairs(location_table) do
                    local location_render_info = loc_info.render_info

                    location_render_info.box.alpha = Math.Lerp(location_render_info.box.alpha, eRender.Style.style_table.location_background_color.a)
                    location_render_info.box.bounds[1] = Math.Lerp(location_render_info.box.bounds[1], location_render_info.box.default_bounds[1] + location_render_info.name.bounds.x)

                    location_render_info.sep_line.point_offset[1] = -location_render_info.circle.offset[1] - space_size_2

                    if(location_render_info.box.bounds[1] > location_render_info.box.default_bounds[1] + location_render_info.name.bounds.x - 1) then
                        location_render_info.name.alpha = Math.Lerp(location_render_info.name.alpha, eRender.Style.style_table.location_text_color.a)

                        location_render_info.sep_line.offset[2] = Math.Lerp(location_render_info.sep_line.offset[2], location_render_info.name.offset[2] - 1 * render.helper_screen_scale[2], render.animation_speed * 0.5)
                        location_render_info.sep_line.alpha = Math.Lerp(location_render_info.sep_line.alpha, eRender.Style.style_table.location_text_color.a)
                    end

                    if(loc_info == fov_location_info) then
                        location_render_info.circle.alpha = Math.Lerp(location_render_info.circle.alpha, 50 + math.sin(globals.curtime * 8) ^ 2 * 205)

                        if(location_render_info.detonate_info) then
                            location_render_info.detonate_info.ground_circle.alpha = Math.Lerp(location_render_info.detonate_info.ground_circle.alpha, 255, render.animation_speed * 0.5)
                            location_render_info.detonate_info.ground_circle.radius = Math.Lerp(location_render_info.detonate_info.ground_circle.radius, 7, render.animation_speed * 0.5)
                        end
                    else
                        location_render_info.circle.alpha = Math.Lerp(location_render_info.circle.alpha, 50)

                        if(location_render_info.detonate_info) then
                            location_render_info.detonate_info.ground_circle.alpha = Math.Lerp(location_render_info.detonate_info.ground_circle.alpha, render.animation_speed * 0.5)
                            location_render_info.detonate_info.ground_circle.radius = Math.Lerp(location_render_info.detonate_info.ground_circle.radius, render.animation_speed * 0.5)
                        end
                    end
                end
            else
                for idx, loc_info in ipairs(location_table) do
                    local location_render_info = loc_info.render_info

                    location_render_info.name.alpha = Math.Lerp(location_render_info.name.alpha, 0)

                    if(location_render_info.name.alpha < 2) then
                        location_render_info.box.alpha = Math.Lerp(location_render_info.box.alpha, 0)

                        location_render_info.box.bounds[1] = Math.Lerp(location_render_info.box.bounds[1], location_render_info.box.default_bounds[1])
                        location_render_info.box.bounds[2] = Math.Lerp(location_render_info.box.bounds[2], location_render_info.box.default_bounds[2])
    
                        location_render_info.sep_line.alpha = Math.Lerp(location_render_info.sep_line.alpha, 0)
                        location_render_info.sep_line.offset[2] = Math.Lerp(location_render_info.sep_line.offset[2], 0)
    
                        location_render_info.circle.alpha = Math.Lerp(location_render_info.circle.alpha, 0)
                    end

                    if(location_render_info.detonate_info) then
                        location_render_info.detonate_info.ground_circle.alpha = Math.Lerp(location_render_info.detonate_info.ground_circle.alpha, 0)
                        location_render_info.detonate_info.ground_circle.radius = Math.Lerp(location_render_info.detonate_info.ground_circle.radius, 0)
                    end
                end
            end
        end

        local in_move = (cmd.in_forward or cmd.in_back or cmd.in_moveright or cmd.in_moveleft)

        if(in_move == false and closest_location_table_distance_sqr < render.helper_location_parking_distance_sqr and self.Locations.Target:InPlayback() == false and parking_pressing) then
            self.CURRENT_HELPER_STATE:Set(2)

            if(weapon_info.weapon_type == 9 and Menu.helper.main.settings.autothrow_switch:get()) then
                self.AutoPull:Begin(cmd)
            end

            local target_location = self.Locations.Target:Get()
            cmd.jitter_move = false

            -- if(location_executer.current_location) then
            --     utils.console_exec(string.format("setpos %s %s %s", location_executer.current_location.pos[1], location_executer.current_location.pos[2], location_executer.current_location.pos[3]))
            --     utils.console_exec(string.format("setang %s %s", location_executer.current_location.ang[1], location_executer.current_location.ang[2]))
            -- end

            if(target_location == nil or target_location.type ~= 2) then
                Menu.neverlose.items.slowwalk:set(false)
            end

            local location_position = target_location and vector(unpack(target_location.pos)) or vector(unpack(closest_location_table.render_info.position))

            local vector_location = location_position - localplayer_position
            local angle_location = math.atan2(vector_location.y, vector_location.x)

            local distance = vector_location:length2d()
            local velocity = localplayer_velocity:length2d()

            if(localplayer.m_MoveType == 9) then
                
            else
                local duckamount = localplayer.m_flDuckAmount
                local move_direction = math.rad(cmd.view_angles.y) - angle_location
                local speed = 450
                cmd.in_speed = false

                if(distance < 0.2) then
                    speed = 1.01
                elseif(distance < 50) then
                    if(velocity > distance * 9) then
                        speed = 0
                    end
                end
    
                if(target_location and target_location.duck and distance < 20) then
                    cmd.in_duck = true
                end
    
                if(duckamount > 0) then
                    speed = speed * 2.93 * duckamount
                end
    
                speed = Math.Clamp(speed, 1.01, 250)
    
                cmd.forwardmove = speed * math.cos(move_direction)
                cmd.sidemove = speed * math.sin(move_direction)
            end

            local throw_ready, speed_ready, grenade_case_ready, legit_ready = false, false, true, false

            if(target_location) then
                if(target_location.type == 0) then
                    grenade_case_ready = weapon.m_bIsHeldByPlayer
                end

                if(localplayer.m_vecVelocity:length() < 2) then
                    speed_ready = true
                end

                if(target_location.type == 0 and Menu.helper.main.settings.autothrow_switch:get() == false) then
                    throw_ready = cmd.in_attack
                else
                    throw_ready = true
                end

                if(Menu.helper.main.settings.fov_slider:get() <= Globals.target_location_legit_fov) then

                    local dx = target_location.ang[1] - localplayer_viewangles.x
                    local dy = target_location.ang[2] - localplayer_viewangles.y

                    localplayer_viewangles.x = localplayer_viewangles.x + dx * 0.25
                    localplayer_viewangles.y = localplayer_viewangles.y + dy * 0.25

                    render.camera_angles(localplayer_viewangles)

                    if(target_location_current_fov < 0.05) then
                        legit_ready = true
                    end
                else
                    legit_ready = true
                end

                if(distance < 0.05 and throw_ready and speed_ready and grenade_case_ready and legit_ready) then
                    self.Locations.Target:Begin(weapon)
                end
            end
        else
            self.AutoPull:SwitchBack(cmd)
        end

        self.Locations.Target:Afterplay(cmd)
        self.Locations.Target:Execute(cmd)

        if(self.CURRENT_HELPER_STATE:Get() ~= self.CURRENT_HELPER_STATE.prev_state_idx) then

            if(self.CURRENT_HELPER_STATE.prev_state_idx == 2) then
                Menu.extra.override_hook.helper_call = true
                Menu.neverlose.items.body_yaw_switch:override()
                Menu.extra.override_hook.helper_call = false
            elseif(self.CURRENT_HELPER_STATE:Get() == 2) then
                Menu.extra.override_hook.helper_call = true
                Menu.neverlose.items.body_yaw_switch:override(false)
                Menu.extra.override_hook.helper_call = false
            end

            self.CURRENT_HELPER_STATE.prev_state_idx = self.CURRENT_HELPER_STATE:Get()
        end
    end,

    runcommand = function (self, cmd)
        self.Locations.Building:RecordCurrentCmd(cmd)
        self.Locations.Target:ExecuteRuncommand(cmd)
    end,

    draw = function(self)
        local localplayer = entity.get_local_player()
        if(localplayer == nil) then return end
        local weapon = localplayer:get_player_weapon()
        if(weapon == nil) then return end

        if(localplayer.m_lifeState ~= 0) then
            self.Locations.Target:Stop()
        end

        if(self.LocalPlayer.Weapon:SwapCheck()) then
            self.Locations:Update()
        end

        local localplayer_position = localplayer:get_origin()
        local screen_size = render.screen_size()

        if(screen_size.x ~= render.helper_screen_scale[1] * 2560 or screen_size.y ~= render.helper_screen_scale[2] * 1440) then
            render.helper_screen_scale[1] = screen_size.x / 2560
            render.helper_screen_scale[2] = screen_size.y / 1440

            utils.execute_after(1, function ()
                eRender.Fonts:Init()
                self.Locations:Update()
            end)
        end

        local weapon_icon = weapon:get_weapon_icon()
        local closest_location_table = self.Locations:GetClosestLocationTable()

        local editing_location = self.Locations.Editing:Get()
        local building_location = self.Locations.Building:Get()

        for _, location_table in pairs(self.Locations.locations) do
            local render_info = location_table.render_info

            local screen_point = render.world_to_screen(vector(unpack(render_info.position)))
            if(screen_point) then
                if(render_info.box.alpha > 2) then
                    Math.current_vectors[1].x = render_info.box.point_offset[1]
                    Math.current_vectors[1].y = render_info.box.point_offset[2]

                    eRender:Push(render.rect, {screen_point - Math.current_vectors[1], screen_point + Math.current_vectors[1], eRender.Style.style_table.location_background_color:alpha_modulate(render_info.box.alpha), render.helper_box_rounding})
                    if(render.helper_render_shadow) then
                        eRender:Push(render.shadow, {screen_point - Math.current_vectors[1], screen_point + Math.current_vectors[1], eRender.Style.style_table.location_weapon_color:alpha_modulate(render_info.box.alpha), 40, 0, render.helper_box_rounding})
                    end
                end
                
                if(render_info.weapon_icon.alpha > 2) then
                    Math.current_vectors[1].x = render_info.weapon_icon.point_offset[1]
                    Math.current_vectors[1].y = render_info.weapon_icon.point_offset[2] + 2 * render.helper_screen_scale[2]

                    Math.current_vectors[2].x = eRender.Style.weapon_icon_size[1]
                    Math.current_vectors[2].y = eRender.Style.weapon_icon_size[2]

                    eRender:Push(render.texture, {weapon_icon, screen_point - Math.current_vectors[1], Math.current_vectors[2]:clone(), eRender.Style.style_table.location_weapon_color:alpha_modulate(render_info.weapon_icon.alpha)})
                end

                if(render_info.sep_line.alpha > 2) then
                    Math.current_vectors[1].x = render_info.sep_line.point_offset[1] + render_info.sep_line.offset[1]
                    Math.current_vectors[1].y = render_info.sep_line.point_offset[2] + render_info.sep_line.offset[2]

                    Math.current_vectors[2].x = render_info.sep_line.point_offset[1] - render_info.sep_line.offset[1]
                    Math.current_vectors[2].y = render_info.sep_line.point_offset[2] - render_info.sep_line.offset[2]

                    eRender:Push(render.rect, {screen_point - Math.current_vectors[1], screen_point - Math.current_vectors[2], eRender.Style.style_table.location_text_color:alpha_modulate(render_info.sep_line.alpha)})
                    if(render.helper_render_shadow) then
                        eRender:Push(render.shadow, {screen_point - Math.current_vectors[1], screen_point - Math.current_vectors[2], eRender.Style.style_table.location_text_color:alpha_modulate(render_info.sep_line.alpha), 15, 0, 0})
                    end
                end

                if(render_info.name.alpha > 2) then
                    Math.current_vectors[1].x = render_info.name.point_offset[1]
                    Math.current_vectors[1].y = render_info.name.point_offset[2]

                    eRender:Push(render.text, {eRender.Fonts.location_text_font, screen_point - Math.current_vectors[1], eRender.Style.style_table.location_text_color:alpha_modulate(render_info.name.alpha), "", render_info.name.text})
                end
            end

            for i, loc_info in ipairs(location_table) do
                local location_render_info = loc_info.render_info
                local location_screen_point = render.get_offscreen(loc_info.crosshair_position, 0.9, true)

                local is_volatile = (loc_info.location == editing_location or loc_info.location == building_location)
                
                if(location_render_info.box.alpha > 2) then
                    Math.current_vectors[1].x = location_render_info.box.point_offset[1]
                    Math.current_vectors[1].y = location_render_info.box.point_offset[2]

                    Math.current_vectors[2].x = Math.current_vectors[1].x - location_render_info.box.bounds[1]
                    Math.current_vectors[2].y = Math.current_vectors[1].y - location_render_info.box.bounds[2]

                    if(is_volatile) then
                        eRender:Push(render.rect, {location_screen_point - Math.current_vectors[1], location_screen_point - Math.current_vectors[2], eRender.Style.style_table.volatile_location_second_color:alpha_modulate(location_render_info.box.alpha), render.helper_box_rounding})
                        if(render.helper_render_shadow) then
                            eRender:Push(render.shadow, {location_screen_point - Math.current_vectors[1], location_screen_point - Math.current_vectors[2], eRender.Style.style_table.volatile_location_color:alpha_modulate(location_render_info.box.alpha), 40, 0, render.helper_box_rounding})
                        end
                    else
                        eRender:Push(render.rect, {location_screen_point - Math.current_vectors[1], location_screen_point - Math.current_vectors[2], eRender.Style.style_table.location_background_color:alpha_modulate(location_render_info.box.alpha), render.helper_box_rounding})
                        if(render.helper_render_shadow) then
                            eRender:Push(render.shadow, {location_screen_point - Math.current_vectors[1], location_screen_point - Math.current_vectors[2], eRender.Style.style_table.location_text_color:alpha_modulate(location_render_info.box.alpha), 40, 0, render.helper_box_rounding})
                        end
                    end

                end
                if(location_render_info.circle.alpha > 2) then
                    if(is_volatile) then
                        eRender:Push(render.circle, {location_screen_point, eRender.Style.style_table.volatile_location_color:alpha_modulate(location_render_info.circle.alpha), render.helper_target_circle_radius * render.helper_screen_scale[1], 0, 1})
                    else
                        eRender:Push(render.circle, {location_screen_point, eRender.Style.style_table.target_circle_color:alpha_modulate(location_render_info.circle.alpha), render.helper_target_circle_radius * render.helper_screen_scale[1], 0, 1})
                    end
                end
                if(location_render_info.name.alpha > 2) then
                    Math.current_vectors[1].x = location_render_info.name.point_offset[1]
                    Math.current_vectors[1].y = location_render_info.name.point_offset[2]

                    if(is_volatile) then
                        eRender:Push(render.text, {eRender.Fonts.target_text_font, location_screen_point - Math.current_vectors[1], eRender.Style.style_table.volatile_location_color:alpha_modulate(location_render_info.name.alpha), "", location_render_info.name.text})
                    else
                        eRender:Push(render.text, {eRender.Fonts.target_text_font, location_screen_point - Math.current_vectors[1], eRender.Style.style_table.location_text_color:alpha_modulate(location_render_info.name.alpha), "", location_render_info.name.text})
                    end
                end
                if(location_render_info.sep_line.alpha > 2) then
                    Math.current_vectors[1].x = location_render_info.sep_line.point_offset[1] + location_render_info.sep_line.offset[1]
                    Math.current_vectors[1].y = location_render_info.sep_line.point_offset[2] + location_render_info.sep_line.offset[2]

                    Math.current_vectors[2].x = location_render_info.sep_line.point_offset[1] - location_render_info.sep_line.offset[1]
                    Math.current_vectors[2].y = location_render_info.sep_line.point_offset[2] - location_render_info.sep_line.offset[2]

                    if(is_volatile) then
                        eRender:Push(render.rect, {location_screen_point - Math.current_vectors[1], location_screen_point - Math.current_vectors[2], eRender.Style.style_table.volatile_location_color:alpha_modulate(location_render_info.sep_line.alpha)})
                        if(render.helper_render_shadow) then
                            eRender:Push(render.shadow, {location_screen_point - Math.current_vectors[1], location_screen_point - Math.current_vectors[2], eRender.Style.style_table.volatile_location_color:alpha_modulate(location_render_info.sep_line.alpha), 15, 0, 0})
                        end
                    else
                        eRender:Push(render.rect, {location_screen_point - Math.current_vectors[1], location_screen_point - Math.current_vectors[2], eRender.Style.style_table.location_text_color:alpha_modulate(location_render_info.sep_line.alpha)})
                        if(render.helper_render_shadow) then
                            eRender:Push(render.shadow, {location_screen_point - Math.current_vectors[1], location_screen_point - Math.current_vectors[2], eRender.Style.style_table.location_text_color:alpha_modulate(location_render_info.sep_line.alpha), 15, 0, 0})    
                        end
                    end
                end
            end
        end

        if(Menu.helper.main.binds.update_hotkey:get()) then
            HotkeyManager:Push(Menu.helper.main.binds.update_hotkey:key(), function ()
                local localplayer_viewangles = render.camera_angles()
                local location = self.Locations.Building:Get() or self.Locations.Editing:Get()

                if(location) then
                    location.pos =
                    {
                        localplayer_position.x,
                        localplayer_position.y,
                        localplayer_position.z,
                    }
    
                    Menu.helper.builder.location.grenade.pitch:set(localplayer_viewangles.x * 10)
                    Menu.helper.builder.location.grenade.yaw:set(localplayer_viewangles.y * 10)
                end
            end)
        end

        if(Menu.helper.main.binds.teleport_hotkey:get()) then
            HotkeyManager:Push(Menu.helper.main.binds.teleport_hotkey:key(), function ()
                local location = self.Locations.Building:Get() or self.Locations.Editing:Get()

                if(location) then
                    utils.console_exec(string.format("setpos %s %s %s", location.pos[1], location.pos[2], location.pos[3]))
                    utils.console_exec(string.format("setang %s %s", location.ang[1], location.ang[2]))
                end
            end)
        end

        if(Menu.helper.main.binds.record_hotkey:get()) then
            HotkeyManager:Push(Menu.helper.main.binds.record_hotkey:key(), function ()
                self.Locations.Building:ToggleRecording()
            end)
        end

        self.Locations.Target:DCExecute()
        self.ExplosivePreview:render()
    end,
}

events.render:set(function ()
    Helper:draw()

    eRender:draw()
    Http:updateRequests()
    Menu.extra.highlight_item:UpdateQueue()
    HotkeyManager:Update()
end)

events.createmove:set(function (cmd)
    Helper:createmove(cmd)
end)

events.createmove_run:set(function (cmd)
    Helper:runcommand(cmd)
end)

events.shutdown:set(function ()
    Menu.neverlose:OnShutdown()
    db.helper_config_table = configs_database
    --Menu.extra.override_hook:OnShutdown()
end)

events.hegrenade_detonate:set(function (e)
    if(Helper.Locations.Target.last_executed_location) then
        if(Helper.Locations.Target.last_executed_location == Helper.Locations.Building:Get()) then
            Helper.Locations.Building:Get().detonate_position =
            {
                e.x,
                e.y,
                e.z,
            }
        elseif(Helper.Locations.Target.last_executed_location == Helper.Locations.Editing:Get()) then
            Helper.Locations.Editing:Get().detonate_position =
            {
                e.x,
                e.y,
                e.z,
            }
        end
    end
end)

Globals:Init()
eRender.Fonts:Init()
Menu.neverlose:Init()
Menu.helper:Init()
--Menu.extra.override_hook:Init()