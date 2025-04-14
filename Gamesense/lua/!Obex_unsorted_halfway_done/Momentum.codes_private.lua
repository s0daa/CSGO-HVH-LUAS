-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- momentum.codes

local bit = require "bit"
local ffi = require "ffi"
local vector = require "vector"
local http = require "gamesense/http"
local ent = require "gamesense/entity"
local easing = require "gamesense/easing"
local base64 = require "gamesense/base64"
local images = require "gamesense/images"
local surface = require "gamesense/surface" 
local clipboard = require "gamesense/clipboard"
local discord = require "gamesense/discord_webhooks"
local csgo_weapons = require "gamesense/csgo_weapons"
local antiaim_funcs = require "gamesense/antiaim_funcs"

local js = panorama.open()

local main = function()
    local tab, container = "AA", "Anti-aimbot angles"
    local set, get = ui.set, ui.get
    
    local ui_update, ui_new_color_picker, ui_reference, ui_set_visible, ui_new_listbox, ui_new_button, ui_new_checkbox, ui_new_label, ui_new_combobox, ui_new_multiselect, ui_new_slider, ui_new_hotkey, ui_set_callback, ui_new_textbox = ui.update, ui.new_color_picker, ui.reference, ui.set_visible, ui.new_listbox, ui.new_button, ui.new_checkbox, ui.new_label, ui.new_combobox, ui.new_multiselect, ui.new_slider, ui.new_hotkey, ui.set_callback, ui.new_textbox
    local entity_get_local_player, entity_is_dormant, entity_get_player_name, entity_hitbox_position, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_local_player, entity.is_dormant, entity.get_player_name, entity.hitbox_position, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
    local client_latency, client_timestamp, client_userid_to_entindex, client_set_event_callback, client_screen_size, client_color_log, client_delay_call, client_exec, client_random_int, client_random_float, client_set_cvar = client.latency, client.timestamp, client.userid_to_entindex, client.set_event_callback, client.screen_size, client.color_log, client.delay_call, client.exec, client.random_int, client.random_float, client.set_cvar
    local math_ceil, math_pow, math_sqrt =  math.ceil, math.pow, math.sqrt
    local plist_set, plist_get = plist.set, plist.get
    local globals_curtime = globals.curtime

    local elements = {}

    local aa_tab, vis_tab, misc_tab, cfg_tab
    local obex_data = obex_fetch and obex_fetch() or {username = "admin", build = "private"}

    --- start of momentum panorama banner
    local menu_item_list = {
        {str = "MainMenuSettingsAlert", state = false},
        {str = "NotificationsContainer", state = false},
        {str = "JsNewsContainer", state = false},
        {str = "NewsPanelLister", state = false},
        {str = "MainMenuNavBarShowCommunityServerBrowser", state = true},
    }
    local menu_js = panorama.loadstring([[
        return {
            set_visible: (name, state) => {
                var item = $.GetContextPanel().FindChildTraverse(name)
                if (item != null)
                    item.visible = state
            },
    
            check_movie: () => {
                var movies = $.GetContextPanel().FindChildTraverse("MainMenuMovie")
                return movies
            },
    
            set_movie: (movie_name) => {
                var res_dir = "file://{resources}/videos/" + movie_name + ".webm"
                var movies = $.GetContextPanel().FindChildTraverse("MainMenuMovie")
                if (movies != null){
                    movies.SetMovie(res_dir)
                    movies.SetRepeat(true)
                    movies.SetSound("")
                    movies.Play()
                }
            },
    
            set_vanity_directional_light: (mode, r, g, b, x1, y1, z1, x2, y2, z2, pulse) => {
                var characters = $.GetContextPanel().FindChildTraverse("JsMainmenu_Vanity")
                if (characters != null){
                    characters.SetDirectionalLightModify(mode)
                    characters.SetDirectionalLightColor(r, g, b)
                    characters.SetDirectionalLightDirection(x1, y1, z1)
                    characters.SetDirectionalLightPulseFlicker(x2, y2, z2, pulse)
                    characters.SetFlashlightAmount(0)
                }
            }
        }
    ]], "MainMenu")()
    
    local file_name = "momentum_banner3"
    local file_link = "https://cdn.discordapp.com/attachments/1089437811104546916/1089634612642336919/gsfontbanner_4_1_1.webm"
    local base_clr = { 1.4, 1, 5 }
    
    local function menu_set(state)
        for k, v in pairs(menu_item_list) do
            menu_js.set_visible(v.str, not state and not v.state or v.state)
        end
        menu_js.set_movie(state and file_name or "sirocco_night")
        if not state then -- using a for loop with be the same amount of lines as pasting it 3 times
            menu_js.set_vanity_directional_light(0, 0.2, 0.5, 1, 0.1, 0.1, 0.1, 0, 0, 0, 0)
            menu_js.set_vanity_directional_light(1, 0.2, 0.5, 1, 0.1, 0.1, 0.1, 0, 0, 0, 0)
            menu_js.set_vanity_directional_light(2, 0.2, 0.5, 1, 0.1, 0.1, 0.1, 0, 0, 0, 0)
        end
    end
    
    local native_CreateDirectory = vtable_bind("filesystem_stdio.dll", "VFileSystem017", 22, "void(__thiscall*)(void*, const char*, const char*)")
    local writedir = function(path, pathID)
        native_CreateDirectory(({path:gsub("/", "\\")})[1], pathID)
    end
    
    local has_image = readfile("csgo/panorama/videos/" .. file_name ..  ".webm")
    function webm_recursive()
        if not has_image then
            http.get(file_link, function(success, response)
                if not success or response.status ~= 200 then
                    client_delay_call(3, webm_recursive)
                else
                    writedir("/csgo/panorama/videos", "GAME")
                    writefile("csgo/panorama/videos/" .. file_name ..  ".webm", response.body)
                    client_delay_call(1, function()
                        menu_set(true)
                    end)
                end
            end)
        else
            menu_set(true)
        end
    end
    webm_recursive()
    
    local checked, movie_set = false, false
    client_set_event_callback("paint_ui", function() -- upkeep
        if globals.mapname() == nil then
            local time_rem = math.floor(globals_curtime() * 4) % 2
            if time_rem == 0 and not checked then
                if menu_js.check_movie() then
                    if not movie_set then
                        menu_set(true)
                        movie_set = true
                    end
                else
                    movie_set = false
                end
                checked = true
            elseif time_rem ~= 0 then
                checked = false
            end

            -- constant application
            menu_js.set_vanity_directional_light(0, base_clr[1], base_clr[2], base_clr[3], 0.01, 0.03, -0.01, 0, 0, 0, 0)
            menu_js.set_vanity_directional_light(1, base_clr[1] * 0.3, base_clr[2] * 0.3, base_clr[3] * 0.3, 0.01, 0.03, -0.01, 0, 0, 0, 0)
            menu_js.set_vanity_directional_light(2, base_clr[1] * 0.3, base_clr[2] * 0.3, base_clr[3] * 0.3, 0.01, 0.03, -0.01, 0, 0, 0, 0)  
        end
    end)
    
    client_set_event_callback("shutdown", function()
        menu_set(false)
    end)

    local clamp = function(b,c,d)return math.min(d,math.max(c,b))end

    local dpi_scale = ui.reference("MISC", "Settings", "DPI scale")
    local gscale = tonumber(ui.get(dpi_scale):sub(1, -2))/100

    -- Header related
    local images_links = {
        "https://cdn.discordapp.com/attachments/1096597728743657482/1097025441916784680/untitled.png",
        "https://cdn.discordapp.com/attachments/777208889769852941/1097741326688202803/image2.png",
        "https://cdn.discordapp.com/attachments/777208889769852941/1097741326428143677/image3.png",
        "https://cdn.discordapp.com/attachments/777208889769852941/1097741326939856927/image1.png",
        "https://cdn.discordapp.com/attachments/777208889769852941/1097741326109384815/image4.png",
    }

    local header = {
        draw_box = function(x, y, w, h, alpha)
            -- Box
            renderer.rectangle(x, y, w, h, 12, 12, 12, alpha)
            renderer.rectangle(x + 1, y + 1, w - 2, h + 2, 60, 60, 60, alpha)
            renderer.rectangle(x + 2, y + 2, w - 4, h + 4, 40, 40, 40, alpha)
            renderer.rectangle(x + 5, y + 5, w - 10, h + 10, 60, 60, 60, alpha)
            renderer.rectangle(x + 6, y + 6, w - 12, h + 12, 12, 12, 12, alpha)
        
            -- Gradient
            renderer.gradient(x + 7, y + 7, w / 2, 2, 55, 177, 218, alpha, 201, 84, 205, alpha, true)
            renderer.gradient(x + w / 2, y + 7, w / 2 - 6, 2, 201, 84, 205, alpha, 204, 207, 53, alpha, true)
            renderer.line(x + 7, y + 8, x + w - 6, y + 8, 25, 25, 25, alpha)
        end,
        
        get_images = function (self, link, index)
            local db_read = database.read(link) 
            if db_read then
                self.images[index] = images.load_png(db_read)
            else
                http.get(link, function(success, response)
                    if not success or response.status ~= 200 then
                        client_delay_call(5, image_recursive)
                    else
                        self.images[index] = images.load_png(response.body)
                        database.write(link, response.body)
                    end
                end)
            end
        end,

        init = function(self)  
            self.images = {}
            for i, link in pairs(images_links) do
                self:get_images(link, i)
            end        
        end,

        update = function(self)
            local menu_pos = {ui.menu_position()}
            local menu_size = {ui.menu_size()}
            gscale = tonumber(get(dpi_scale):sub(1, -2))/100

            self.height = 37.5 * gscale
            self.width = menu_size[1] 

            self.x, self.y, self.w, self.h = menu_pos[1], menu_pos[2] - self.height, self.width, self.height
        end,
    }
    header:init()

    -- Mouse related funcs (stolen from my gmenu lmao)

    local mouse = {
        is_within = function(px, py, x, y, w, h)
            return px > x and px < x + w and py > y and py < y + h
        end,

        hover_applicable = function(self, x, y, w, h)
            return self.is_within(self.mouse_x, self.mouse_y, x, y, w, h)
        end,

        click_applicable = function(self, x, y, w, h, name)
            if not self.is_within(self.mouse_x, self.mouse_y, header.x, header.y, header.w, header.h) then 
                return 
            end

            if self.got_click and client.key_state(0x01) then
                if self.is_within(self.click_x, self.click_y, x, y, w, h) then
                    return true
                end
            end
            return false
        end,
 
        init = function(self)
            self.got_click, self.off_click = false, false
            self.click_x, self.click_y, self.mouse_x, self.mouse_y = 0, 0, 0, 0
            self.header_index = database.read("momentum_header_index") or 1

            aa_tab   = self.header_index == 2
            vis_tab  = self.header_index == 3
            misc_tab = self.header_index == 4
            cfg_tab  = self.header_index == 5
        end,

        listen = function(self)
            self.mouse_x, self.mouse_y = ui.mouse_position()
            if client.key_state(0x01) and ui.is_menu_open() then
                self.off_click = true
                if not self.got_click then
                    self.click_x, self.click_y = ui.mouse_position()
                    self.got_click = true
                end
            else
                if self.off_click then
                    self.off_click = false
                    self.got_click = false
                end
            end
        end,
    }
    mouse:init()

    -- Standalone menu alpha calcu-malator
    local menu_key = {ui.get(ui.reference("MISC", "Settings", "Menu key"))}
    function get_menu_alpha()local a=ui.is_menu_open()local b=0;if a~=last_state then draw_swap=globals_curtime()last_state=a end;local c=0.07;if not ignore_next and client.key_state(menu_key[3])then is_closing=true else if not client.key_state(menu_key[3])then ignore_next=false end end;local d=state;local e;if ui.is_menu_open()then if is_closing then state="closed"e=false else state="open"e=true end else is_closing=false;e=false;ignore_next=true;state="closed"end;if d~=state then swap_time=globals_curtime()end;b=clamp((swap_time+c-globals_curtime())/c,0,1)b=(e and a and 1-b or b)*255;return b end

    client.set_event_callback("paint_ui", function()  
        local alpha = get_menu_alpha()
        if alpha > 0 and ui.is_menu_open() then 
            -- Capture mouse events
            mouse:listen()

            -- Update header info
            header:update()

            -- Button bounds
            header.draw_box(header.x, header.y, header.w, header.h, alpha, true)

            local sections = 5
            local sub_w = (header.w / sections) - 2.5
            for i = 1, sections do
                -- Section bounds
                local sx, sy, sw, sh = header.x + 7 + ((i - 1) * sub_w), header.y + 9, sub_w, header.h - 9

                -- Check for recent clicks
                if mouse:click_applicable(sx, sy, sw, sh, i) then
                    mouse.header_index = i
                    database.write("momentum_header_index", i)

                    aa_tab   = i == 2
                    vis_tab  = i == 3
                    misc_tab = i == 4
                    cfg_tab  = i == 5
                end

                -- Section bars
                if i ~= sections then
                    local line_gap = sh * 0.1
                    renderer.rectangle(sx + sw, sy + line_gap, 1, sh - (line_gap * 2), 26, 26, 26, alpha) 
                end

                -- Section Images
                if header.images[i] then
                    local is_hovering = mouse:hover_applicable(sx, sy, sw, sh)
                    local rescale = 0.7
                    local iw, ih = i == 1 and sh or sh * rescale, i == 1 and sh or sh * rescale
                    local ix, iy = sx + (sw * 0.5) - (iw * 0.5), sy + (sh * 0.5) - (ih * 0.5)
                    header.images[i]:draw(ix, iy, iw, ih, 169, 169, 255, alpha * (mouse.header_index == i and 1 or (is_hovering and 0.5 or 0.2)), false, "f")
                end
            end
        end
    end)

    local reference = {
        antiaim = {
            enabled = ui_reference(tab, container, "Enabled"),
            pitch = ui_reference(tab, container, "pitch"),
            yawbase = ui_reference(tab, container, "Yaw base"),
            yaw = {ui_reference(tab, container, "Yaw")},
            fsbodyyaw = ui_reference(tab, container, "Freestanding body yaw"),
            edgeyaw = ui_reference(tab, container, "Edge yaw"),
            yaw_jitt = {ui_reference(tab, container, "Yaw jitter")},
            body_yaw = {ui_reference(tab, container, "Body yaw")},
            freestand = {ui_reference(tab, container, "Freestanding")},
            roll = ui_reference(tab, container, "Roll"),
            edge = ui_reference(tab, container, "Edge yaw")
        },
        fakelag = {
            fl_limit = ui_reference(tab, "Fake lag", "Limit"),
            fl_amount = ui_reference(tab, "Fake lag", "Amount"),
            enablefl = ui_reference(tab, "Fake lag", "Enabled"),
            fl_var = ui_reference(tab, "Fake lag", "Variance"),
            fakelag = {ui_reference(tab, "Fake lag", "Limit")}
        },
        rage = {
            dt = {ui_reference("RAGE", "Aimbot", "Double tap")},
            os = {ui_reference(tab, "Other", "On shot anti-aim")},
            lm = ui_reference(tab, "Other", "Leg movement"),
            fakeduck = ui_reference("RAGE", "Other", "Duck peek assist"),
            safepoint = ui_reference("RAGE", "Aimbot", "Force safe point"),
            forcebaim = ui_reference("RAGE", "Aimbot", "Force body aim"),
            quickpeek = {ui_reference("RAGE", "Other", "Quick peek assist")},
            slow = {ui_reference(tab, "Other", "Slow motion")},
            sw,
            slowwalk = ui_reference("AA", "Other", "Slow motion"),
            damage = ui_reference("RAGE", "Aimbot", "Minimum damage"),
            ping_spike = {ui_reference("MISC", "Miscellaneous", "Ping spike")},
            air_strafe = ui_reference("Misc", "Movement", "Air strafe"),
            dt_mode = ui_reference("RAGE", "Aimbot", "Double tap"),
            dt_fakelag = ui_reference("RAGE", "Aimbot", "Double tap fake lag limit"),
            third_person = {ui_reference("VISUALS", "Effects", "Force third person (alive)")},
            menucolor = ui_reference("MISC", "Settings", "Menu color")
        }
    }

    local vars = {
        state = {"Default", "Stand", "Move", "Slow motion", "Duck", "In air", "Air duck", "Fake lag", "Defensive"},
        ind_state = "",
        p_state = 1,
        last_press = 0,
    }

    local colors = {
        blue = "\aA9B7FFFF",
        bright = "\aE3E9FFFF",
        grey = "\aFFFFFF8D",  
        default = "\aD5D5D5FF",
        bright_red = "\aFF9A9AFF",
        white = "\aFFFFFFFF",
        new_blue = "\aBABAF9F7",
    }

    local status = {
        build = obex_data.build:lower(),
        last_update = "3.5",
        username = obex_data.username:lower(),
    }

    local function table_visible(tbl, state) -- recursiveness!
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                table_visible(v, state)
            elseif type(v) == "number" then
                ui_set_visible(v, state)
            end
        end
    end

    local function contains(table, value)
        if table == nil then
            return false
        end

        table = get(table)
        for i = 0, #table do
            if table[i] == value then
                return true
            end
        end
        return false
    end

    local bit_tohex = bit.tohex
    local function rgba_to_hex(r, g, b, a)
    return bit_tohex(r, 2) .. bit_tohex(g, 2) .. bit_tohex(b, 2) .. bit_tohex(a, 2)
    end

    local function create_labels(ref, con, name, samples)
        local label = {
            list = {},
            offset = samples,
            time = globals_curtime(),
        
            callback = function(self, enabled, time)
                if not ui.is_menu_open() then return end
                if enabled then
                    local full_cycle_time = samples * time
                    local normal_time = globals_curtime() - self.time
                    self.offset = samples - math.floor(normal_time * full_cycle_time)
                    if self.offset < 1 then
                        self.offset = samples
                        self.time = globals_curtime()
                    end
                    for i, v in pairs(self.list) do
                        ui_set_visible(v, i == (self.offset + 1))
                    end
                else
                    for i, v in pairs(self.list) do
                        ui_set_visible(v, false)
                    end
                end
            end,
        }
        
        for i = 0, samples do
            local compound_str, length, shift = "", #name, (i / (samples * 0.5)) * #name
            for j = 0, length do
                local char = string.sub(name, j, j)
                if char ~= " " then
                    local base_num = j + shift
                    local x_val = base_num / length
                    local sin_val = (math.sin(x_val * math.pi) + 1) * 0.5
                    
                    local char_enc = string.format("\a%s%s", rgba_to_hex(186, 186, 249, clamp((sin_val * 255) * 1.15, 0, 255)), char)
                    compound_str = compound_str .. char_enc
                else
                    compound_str = compound_str .. char
                end
            end
            table.insert(label.list, ui_new_label(ref, con, compound_str))
        end   
        return label
    end

    local momentum_anim_label = create_labels(tab, container, "                 MOMENTUM", 50)
    local empty_lbl = ui_new_label(tab, container, "\n")
    local menuSelectionRefs = {    
        update_label = ui_new_label(tab, container, "                " .. colors.new_blue .. "Version" .. colors.grey .. " ~ " .. colors.default .. status.last_update),
        build_label = ui_new_label(tab, container, "               " .. colors.new_blue .. "Build" .. colors.grey .. " ~ " .. colors.default .. status.build)
    }

    local _sub = function(input, arg)
        local t = {}
        for m in string.gmatch(input, "([^" .. arg .. "]+)") do
            t[#t + 1] = string.gsub(m, "\n", "")
        end
        return t
    end

    local _string = function(arg)
        arg = get(arg)
        local m = ""
        for i = 1, #arg do
            m = m .. arg[i] .. (i == #arg and "" or ",")
        end

        if m == "" then
            m = "-"
        end

        return m
    end

    local _boolean = function(m)
        if m == "true" or m == "false" then
            return (m == "true")
        else
            return m
        end
    end

    local _storing = {}
    _storing.export = {["number"] = {}, ["boolean"] = {}, ["table"] = {}, ["string"] = {}}
    _storing.pcall = {}

    local store = function(value)
        if type(value) ~= "number" then
            log("unable to store value, value should be a number")
        end

        if type(value) == "number" then
            table.insert(_storing.export[type(get(value))], value)
        end

        if type(value) == "number" then
            table.insert(_storing.pcall, value)
        end
        return value
    end

    local lastupdate = "unknown"
    local antiaim = {
        tab_handle = ui_new_label(tab, container, colors.new_blue .. "Current tab" .. colors.default .. " ~ Anti-aim"), 
        additions = ui_new_combobox(tab, container, "\n", "Anti-aim", "Binds"),
        tab_gap = ui_new_label(tab, container, "\n"),
        configmenu = ui_new_combobox(tab, container, colors.new_blue .. "Configs menu", "Local", "Public", "Import/export"),
        listbox = ui_new_listbox(tab, container, "Configs", {}),
        createtext = ui_new_textbox(tab, container, "Config name"),
        publiclistbox = ui_new_listbox(tab, container, "Public Configs", {}),
        updatelabel = ui_new_label(tab, container, lastupdate),
        toggle_manual = ui_new_checkbox(tab, container, "Manual anti-aim"),
        manual_left = ui_new_hotkey(tab, container, "Manual left"),
        manual_right = ui_new_hotkey(tab, container, "Manual right"),
        manual_forward = ui_new_hotkey(tab, container, "Manual forward"),
        manual_reset = ui_new_hotkey(tab, container, "Manual reset"),
        fs = ui_new_hotkey(tab, container, "Freestanding", false),
        lc_break = ui_new_hotkey(tab, container, "Teleport if hit-able", false),
        
        player_state = ui_new_combobox(tab, container, colors.new_blue .. "Player states", vars.state),
        --aa_spacer = ui_new_label(tab, container, "\nMode gap"),
    }

    local keybind_options = { -- the exact name of the "use_name" value
        'Double tap', 'On shot anti-aim', 'Safe point', 'Force body aim', 'Quick peek assist', 'Duck peek assist', 'Slow motion', 'Freestanding', 'Ping spike', 'Fake peek', 'Blockbot', 'Last second defuse'
    }
    local keybind_list = {
        {reference = {ui.reference('rage','aimbot','Double tap')}, use_name = 'Double tap'},
        {reference = {ui.reference('aa','other','On shot anti-aim')}, use_name = 'On shot anti-aim'},
        {reference = {ui.reference('rage','aimbot','Force safe point')}, use_name = 'Safe point'},
        {reference = {ui.reference('rage','aimbot','Force body aim')}, use_name = 'Force body aim'},
        {reference = {ui.reference('rage','other','Quick peek assist')}, use_name = 'Quick peek assist'},
        {reference = {ui.reference('rage','other','Duck peek assist')}, use_name = 'Duck peek assist'},
        {reference = {ui.reference('aa','other','Slow motion')}, use_name = 'Slow motion'},
        {reference = {ui.reference('aa', container, 'Freestanding')}, use_name = 'Freestanding'},
        {reference = {ui.reference('misc','miscellaneous','Ping spike')}, use_name = 'Ping spike'},
        {reference = {ui.reference('aa','other','Fake peek')}, use_name = 'Fake peek'},
        {reference = {ui.reference('misc','movement','Blockbot')}, use_name = 'Blockbot'},
        {reference = {ui.reference('misc','miscellaneous','Last second defuse')}, use_name = 'Last second defuse'},
    }

    local vis = {
        vis_menu = ui_new_multiselect(tab, container, colors.new_blue .. "Visual features", "Keybinds", "Indicators", "Watermark", "Min dmg indicator", "Console logs", "Screen logs"),
        
        bind_multi = ui_new_multiselect(tab, container, "Keybind options", keybind_options),
        bind_clr = ui_new_color_picker(tab, container, "Keybinds Main color", 255, 255, 255, 255),
        
        main_clr_l = ui_new_label(tab, container, "Animation color"),
        main_clr = ui_new_color_picker(tab, container, "Main color", 255, 255, 255, 255),
        main_clr_l2 = ui_new_label(tab, container, "Base color"),
        main_clr2 = ui_new_color_picker(tab, container, "Second color", 255, 255, 255, 255),

        watermark_on = ui_new_label(tab, container, "Watermark color"),
        wat_color = ui_new_color_picker(tab, container, "watermark color", 255, 255, 255, 255),
        hit_label = ui_new_label(tab, container, "Hit color"),
        hit_color = ui_new_color_picker(tab, container, "Hit color", 255, 255, 255, 255),
        miss_label = ui_new_label(tab, container, "Miss color"),
        miss_color = ui_new_color_picker(tab, container, "Miss color", 255, 255, 255, 255),
    }

    local misc = {
        misc_menu = ui_new_multiselect(tab, container, colors.new_blue .. "Misc features", "Momentum resolver", "Manipulate backtracking", "Animation breakers", "Anti-knife", "Anti-zeus", "Hoodtalk"),
        anim_breaker = ui_new_multiselect(tab, container, "Animation breakers", "Legbreaker", "Moonwalk", "0 pitch on land"),
        manipsvbt = ui_new_combobox(tab, container, "Backtracking options", "Game default", "Over-predict fix", "Extended optimal", "Extended"),
        zeus_options = ui_new_combobox(tab, container, "Anti-zeus options", "Pull pistol", "Pull zeus"),
        zeus_distance = ui_new_slider(tab, container, "Anti-zeus radius", 0, 500, 250, true),
        knife_distance = ui_new_slider(tab, container, "Anti-knife radius", 0, 1000, 450, true),
    }

	local fl_tab = {													
		advanced_fl = ui.new_checkbox(tab, "Fake lag", "Advanced fakelag"),
		fakelag_tab = ui.new_combobox(tab, "Fake lag", "Fake lag", "Maximum", "Dynamic", "Alternative"),
		trigger = ui.new_multiselect(tab, "Fake lag", "Trigger while", "Standing", "Moving", "Slowwalk", "In air", "On land"),
		triggerlimit = ui.new_slider(tab, "Fake lag", "Limit",1,15,15),
		sendlimit = ui.new_slider(tab, "Fake lag", "Send limit",1,15,13),
		forcelimit = ui.new_multiselect(tab, "Fake lag", "Low fakelag", "While standing", "While shooting", "While os-aa"),
	}

    -- re-minfied 
    local notify=(function()local a={callback_registered=false,maximum_count=4,data2={}}function a:stored_callbacks()if self.callback_registered then return end;client_set_event_callback("paint_ui",function()local b={client_screen_size()}local c={56,56,57}local d=5;local e=self.data2;for f=#e,1,-1 do self.data2[f].time=self.data2[f].time-globals.frametime()local g,h=255,0;local i=e[f]local j=18;local k=20;if i.time<0 then table.remove(self.data2,f)else local l=i.def_time-i.time;local l=l>1 and 1 or l;if i.time<0.5 or l<0.5 then h=(l<1 and l or i.time)/0.5;g=h*255;j=h*18;k=h*20;if h<0.2 then d=d+15*(1.0-h/0.2)end end;local m,n,o,p=get(vis.main_clr)local q,r=20,20;local s='<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>'local t=renderer.load_svg(s,q,r)local u={renderer.measure_text(nil,i.draw)}local v={b[1]/2-u[1]/2+3,b[2]-b[2]/100*17.4+d}renderer.blur(v[1]-22,v[2]-20,u[1]+27,18,0,0,0,g>255 and 255 or g)renderer.texture(t,v[1]-22,v[2]-21,q,r,m,n,o,g)renderer.texture(t,v[1]-22,v[2]-21,q,r,m,n,o,g)renderer.texture(t,v[1]-22,v[2]-21,q,r,m,n,o,g)renderer.text(v[1]+u[1]/2,v[2]-12,255,255,255,g,"c",nil,i.draw)for w=0,8 do local w=w/2;renderer.rectangle(v[1]-22,v[2]-20,-w,j,m,n,o,g>15 and 15 or g)end;d=d-30 end end;self.callback_registered=true end)end;function a:paint(x,y)local z=tonumber(x)+1;for f=self.maximum_count,2,-1 do self.data2[f]=self.data2[f-1]end;self.data2[1]={time=z,def_time=z,draw=y}self:stored_callbacks()end;return a end)()

    for i = 1, #vars.state do
        local pre_text = colors.new_blue .. vars.state[i] .. colors.white
        -- encode for configs
        local c_enc = " \aeeeeeeee"
        local s_enc = "     \affffffff"

		elements[i] = {
            -- advanced specific items
            enable_state = store(ui_new_checkbox(tab, container, pre_text .. " | Enable state" .. c_enc)),
            mode_spacer = ui_new_label(tab, container, "\n mode gap"),
            mode = store(ui_new_combobox(tab, container, pre_text .. " | Mode", {"Simple", "Advanced"})),
            
            -- Advanced items
            advanced = {
                pitch = store(ui_new_combobox(tab, container, pre_text .." | Pitch" .. c_enc, { "Disabled", "Down", "Up", "Random" })),
                yaw_mode = store(ui_new_combobox(tab, container, pre_text .." | Yaw system" .. c_enc, {"Default", "3 way", "Extrapolated", "Extrapolated skitter", "Synced body", "Synced random"})),
        
                yaw_3_way_1 = store(ui_new_slider(tab, container, pre_text .." | 3 way"..colors.new_blue.." [1st angle]" .. c_enc, -180, 180, 0, true, "°")),
                yaw_3_way_2 = store(ui_new_slider(tab, container, pre_text .." | 3 way"..colors.new_blue.." [2nd angle]" .. c_enc, -180, 180, 0, true, "°")),
                yaw_3_way_3 = store(ui_new_slider(tab, container, pre_text .." | 3 way"..colors.new_blue.." [3rd angle]" .. c_enc, -180, 180, 0, true, "°")),
                
                yaw_default = store(ui_new_slider(tab, container, "\n" .. pre_text .." | Jitter degree", -180, 180, 0, true, "°")),

                yaw_left = store(ui_new_slider(tab, container, pre_text .." | Jitter degree "..colors.new_blue.."[L]" .. c_enc, -180, 180, 10, true, "°")),
                yaw_right = store(ui_new_slider(tab, container, pre_text .." | Jitter degree "..colors.new_blue.."[R]" .. c_enc, -180, 180, -10, true, "°")),
                yaw_min_left = store(ui_new_slider(tab, container, pre_text .." | Jitter degree min "..colors.new_blue.."[L]" .. c_enc, -180, 180, 0, true, "°")),
                yaw_max_left = store(ui_new_slider(tab, container, pre_text .." | Jitter degree max "..colors.new_blue.."[L]" .. c_enc, -180, 180, 0, true, "°")),
                yaw_min_right = store(ui_new_slider(tab, container, pre_text .." | Jitter degree min "..colors.new_blue.."[R]" .. c_enc, -180, 180, 0, true, "°")),
                yaw_max_right = store(ui_new_slider(tab, container, pre_text .." | Jitter degree max "..colors.new_blue.."[R]" .. c_enc, -180, 180, 0, true, "°")),
                
                b_yaw = store(ui_new_combobox(tab, container, pre_text .." | Body system" .. c_enc, {"Jitter", "Static", "Opposite"})),
                b_yaw_side = store(ui_new_combobox(tab, container, pre_text.." | Body direction" .. c_enc, {"Left", "Right"})),
                b_yaw_speed = store(ui_new_slider(tab, container, "\n" .. pre_text .." | Body jitter speed" .. c_enc, 0, 31, 31, true, "%", 10/3, {[0] = "Random", [31] = "Max (tickbased)"})),

                aa_disabled = store(ui_new_checkbox(tab, container, pre_text .." | Disable freestanding" .. c_enc)),
                defensive = store(ui_new_checkbox(tab, container, pre_text .." | Force defensive" .. c_enc)),
            },

            -- Simple items
            simple = {
                pitch = store(ui_new_combobox(tab, container, pre_text .." | Pitch" .. s_enc, { "Disabled", "Down", "Up", "Random" })),

                yaw_mode = store(ui_new_combobox(tab, container, pre_text .." | Yaw system" .. s_enc, {"Synced body"})),

                yaw_left = store(ui_new_slider(tab, container, pre_text .." | Jitter degree "..colors.new_blue.."[L]" .. s_enc, -180, 180, 10, true, "°")),
                yaw_right = store(ui_new_slider(tab, container, pre_text .." | Jitter degree "..colors.new_blue.."[R]" .. s_enc, -180, 180, -10, true, "°")),

                b_yaw = store(ui_new_combobox(tab, container, pre_text .." | Body system" .. s_enc, {"Jitter", "Static"})),
                b_yaw_side = store(ui_new_combobox(tab, container, pre_text.." | Body direction" .. s_enc, {"Left", "Right"})),
                b_yaw_speed = store(ui_new_slider(tab, container, "\n" .. pre_text .." | Body jitter speed" .. s_enc, 0, 31, 31, true, "%", 10/3, {[0] = "Random", [31] = "Max (tickbased)"})),

                aa_disabled = store(ui_new_checkbox(tab, container, pre_text .." | Disable freestanding" .. s_enc)),
            },
		}
	end

    local import_config = function()
        local table = _sub(base64.decode(clipboard.get(), "base64"), "|")
        local p = 1

        for i, o in pairs(_storing.export["number"]) do
            set(o, tonumber(table[p]))
            p = p + 1
        end
        for i, o in pairs(_storing.export["string"]) do
            set(o, table[p])
            p = p + 1
        end
        for i, o in pairs(_storing.export["boolean"]) do
            set(o, _boolean(table[p]))
            p = p + 1
        end
        for i, o in pairs(_storing.export["table"]) do
            set(o, _sub(table[p], ","))
            p = p + 1
        end
        notify:paint(3, "Imported momentum settings")
    end

    local load_config = function(config)
        local table = _sub(base64.decode(config, "base64"), "|")
        local p = 1
        for i, o in pairs(_storing.export["number"]) do
            set(o, tonumber(table[p]))
            p = p + 1
        end
        for i, o in pairs(_storing.export["string"]) do
            set(o, table[p])
            p = p + 1
        end
        for i, o in pairs(_storing.export["boolean"]) do
            set(o, _boolean(table[p]))
            p = p + 1
        end
        for i, o in pairs(_storing.export["table"]) do
            set(o, _sub(table[p], ","))
            p = p + 1
        end
        notify:paint(3, "Config loaded")
    end

    local export_config = function(should_notify)
        local m = ""
        for i, o in pairs(_storing.export["number"]) do
            m = m .. tostring(get(o)) .. "|"
        end
        for i, o in pairs(_storing.export["string"]) do
            m = m .. (get(o)) .. "|"
        end
        for i, o in pairs(_storing.export["boolean"]) do
            m = m .. tostring(get(o)) .. "|"
        end
        for i, o in pairs(_storing.export["table"]) do
            m = m .. _string(o) .. "|"
        end
        clipboard.set(base64.encode(m, "base64"))
        if should_notify then
            notify:paint(3, "Exported momentum settings")
        end
    end

    local encode_config = function()
        local m = ""
        for i, o in pairs(_storing.export["number"]) do
            m = m .. tostring(get(o)) .. "|"
        end
        for i, o in pairs(_storing.export["string"]) do
            m = m .. (get(o)) .. "|"
        end
        for i, o in pairs(_storing.export["boolean"]) do
            m = m .. tostring(get(o)) .. "|"
        end
        for i, o in pairs(_storing.export["table"]) do
            m = m .. _string(o) .. "|"
        end
        return base64.encode(m, "base64")
    end

    local steam_name = js.MyPersonaAPI.GetName()
    local steam64 = js.MyPersonaAPI.GetXuid()

    local Webhook = discord.new("https://discord.com/api/webhooks/1090808328449425449/_k5XvpDTtKG-zrzt2ixhZiKklEL8KtZ6NdAOVJPmgJ2Gel7ZSOzge2l-HQTIxAaqypaA")
    local RichEmbed = discord.newEmbed()

    Webhook:setUsername("Momentum")
    Webhook:setAvatarURL("https://cdn.discordapp.com/attachments/974370155985510471/1035193574679138354/Background_minus.png")
    RichEmbed:setTitle(status.username .. " just loaded momentum private")
    RichEmbed:setThumbnail("https://cdn.discordapp.com/icons/770374971087388732/a_90e65c655cb31978f29c8f0b781338d6.webp?size=1024")
    RichEmbed:setColor(7661062)
    RichEmbed:addField("steam link", "[" .. steam_name .. "](https://steamcommunity.com/profiles/" .. steam64 .. ")", true)
    RichEmbed:setAuthor("Momentum load system", "", "https://cdn.discordapp.com/attachments/974370155985510471/1035193574679138354/Background_minus.png")
    Webhook:send(RichEmbed)

    local tab_handler = function()
        cur = get(antiaim.additions)
        set(antiaim.tab_handle, colors.new_blue .. "Current tab" .. colors.grey .. " ~ " .. colors.default .. cur)
    end

    tab_handler()
    ui_set_callback(antiaim.additions, tab_handler)

    local steam_name = js.MyPersonaAPI.GetName()
    local steam64 = js.MyPersonaAPI.GetXuid()

    local export_btn = ui_new_button(tab, container, "Export settings", export_config)
    local import_btn = ui_new_button(tab, container, "Import settings", import_config)

    local skeet_menu = function(state)
        table_visible(reference.antiaim, state)  
    end

    local HEXtoRGB = function(hexArg)
        hexArg = hexArg:gsub("#", "")
        if (string.len(hexArg) == 3) then
            return tonumber("0x" .. hexArg:sub(1, 1)) * 17, tonumber("0x" .. hexArg:sub(2, 2)) * 17, tonumber("0x" .. hexArg:sub(3, 3)) * 17
        elseif (string.len(hexArg) == 8) then
            return tonumber("0x" .. hexArg:sub(1, 2)), tonumber("0x" .. hexArg:sub(3, 4)), tonumber("0x" .. hexArg:sub(5, 6)), tonumber("0x" .. hexArg:sub(7, 8))
        else
            return 0, 0, 0
        end
    end

    local RGBtoHEX = function(redArg, greenArg, blueArg)
        return string.format("%.2x%.2x%.2xFF", redArg, greenArg, blueArg)
    end

    local RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
        return string.format("%.2x%.2x%.2x%.2x", redArg, greenArg, blueArg, alphaArg)
    end

    local get_timestamp = function()
        return client.unix_time()
    end

    local realtime_offset = get_timestamp() - globals.realtime()

    local get_unix_timestamp = function()
        return globals.realtime() + realtime_offset + 50
    end

    local format_timestamp = function(timestamp)
        local day_count, year, days, month = function(yr) return (yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0)) and 366 or 365 end, 1970, math.ceil(timestamp / 86400)
        while days >= day_count(year) do
            days = days - day_count(year)
            year = year + 1
        end

        local tab_overflow = function(seed, table)
            for i = 1, #table do
                if seed - table[i] <= 0 then
                    return i, seed
                end

                seed = seed - table[i]
            end
        end

        month, days = tab_overflow(days, {31, (day_count(year) == 366 and 29 or 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31})

        local hours, minutes, seconds = math.floor(timestamp / 3600 % 24), math.floor(timestamp / 60 % 60), math.floor(timestamp % 60)
        local period = hours > 12 and "pm" or "am"

        return string.format("%d/%d/%04d %02d:%02d", days, month, year, hours, minutes)
    end

    local format_timestamp = setmetatable({}, {
        __index = function(tbl, ts)
            tbl[ts] = format_timestamp(ts)
            return tbl[ts]
        end
    })

    local format_duration = function(secs, ignore_seconds, max_parts)
        local units, dur, part = {"day", "hour", "minute"}, "", 1
        max_parts = max_parts or 4

        for i, v in ipairs({86400, 3600, 60}) do
            if part > max_parts then
                break
            end

            if secs >= v then
                dur = dur .. math.floor(secs / v) .. " " .. units[i] .. (math.floor(secs / v) > 1 and "s" or "") .. ", "
                secs = secs % v
                part = part + 1
            end
        end

        if secs == 0 or ignore_seconds or part > max_parts then
            return dur:sub(1, -3)
        else
            secs = math.floor(secs)
            return dur .. secs .. (secs > 1 and " seconds" or " second")
        end
    end

    local format_unix_timestamp = function(timestamp, allow_future, ignore_seconds, max_parts)
        local secs = timestamp - get_unix_timestamp()

        if secs < 0 or allow_future then
            local duration = format_duration(math.abs(secs), ignore_seconds, max_parts)
            return secs > 0 and ("In " .. duration) or (duration .. " ago")
        else
            return format_timestamp[timestamp]
        end
    end

    local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
    local enemy_hurt = function(e)
        local hgroup = hitgroup_names[e.hitgroup + 1] or "?"
        local name = string.lower(entity_get_player_name(e.target))
        local health = entity_get_prop(e.target, "m_iHealth")
        local angle = math.floor(entity_get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60)
        local chance = math.floor(e.hit_chance)
        local bt = globals.tickcount() - e.tick
        local r, g, b = get(vis.hit_color)
        local hex = RGBtoHEX(r, g, b)

        if contains(vis.vis_menu, "Screen logs") then
            notify:paint(3, string.format( "\a" .. hex .. "Hit \aFFFFFFFF" .. name .. "'s \a" .. hex .. hgroup .. "\aFFFFFFFF for \a" .. hex .. e.damage .. "\aFFFFFFFF (" .. health .. "hp remaining)" ))
        end

        if contains(vis.vis_menu, "Console logs") then
            client_color_log(r, g, b, "[Momentum] \0")
            client_color_log(r, g, b, "Hit " .. name .. "'s " .. hgroup .. " for " .. e.damage .. " (" .. health .. "hp remaining) angle: " .. angle .. "° hc: " .. chance .. " bt: " .. bt .. "")
        end
    end

    local missed_enemy = function(e)
        local hgroup = hitgroup_names[e.hitgroup + 1] or "?"
        local name = string.lower(entity_get_player_name(e.target))
        local health = entity_get_prop(e.target, "m_iHealth")
        local angle = math.floor(entity_get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60)
        local chance = math.floor(e.hit_chance)
        local bt = globals.tickcount() - e.tick
        local r, g, b = get(vis.miss_color)
        local hex = RGBtoHEX(r, g, b)
        local r1, g1, b1 = 255, 255, 255

        if contains(vis.vis_menu, "Screen logs") then
            notify:paint(3, string.format( "\a" .. hex .. "Missed \aFFFFFFFF" .. name .. "'s \a" .. hex .. hgroup .. "\aFFFFFFFF due to \a" .. hex .. e.reason .. "\aFFFFFFFF (" .. health .. "hp remaining)"))
        end

        if contains(vis.vis_menu, "Console logs") then
            client_color_log(r, g, b, "[Momentum] \0")
            client_color_log(r, g, b, "Missed " .. name .. "'s " .. hgroup .. " due to " .. e.reason .. " (" .. health .. "hp remaining) angle: " .. angle .. "° hc: " .. chance .. " bt: " .. bt)
        end

        if e.reason ~= "?" then
            return
        end
    end

    local anim = {}
    anim.helpers = {
        rgba_to_hex = function(self, r, g, b, a)
            return bit.tohex((math.floor(r + 0.5) * 16777216) + (math.floor(g + 0.5) * 65536) + (math.floor(b + 0.5) * 256) + (math.floor(a + 0.5)))
        end,

        animate_text = function(self, time, string, r, g, b, a)
            local m, n, o, p = get(vis.main_clr2)
            local t_out, t_out_iter = {}, 1
            local l = string:len() - 1
            local r_add = (m - r)
            local g_add = (n - g)
            local b_add = (o - b)
            local a_add = (p - a)

            for i = 1, #string do
                local iter = (i - 1) / (#string - 1) + time
                t_out[t_out_iter] = "\a" .. anim.helpers:rgba_to_hex(r + r_add * math.abs(math.cos(iter)), g + g_add * math.abs(math.cos(iter)), b + b_add * math.abs(math.cos(iter)), a + a_add * math.abs(math.cos(iter)))
                t_out[t_out_iter + 1] = string:sub(i, i)
                t_out_iter = t_out_iter + 2
            end

            return t_out
        end
    }

    local helpers = {}
    helpers = {
        variance = function(ticks, fin_var, seed)
            fin_var = fin_var >= ticks and ticks - 1 or fin_var
            local min_ticks = ticks - fin_var
            math.randomseed(seed or client_timestamp())
            return math.random(min_ticks, ticks)
        end,
        consistent = function(last_tick, max_ticks)
            return math.min(last_tick, max_ticks)
        end,
        get_velocity = function(player)
            local x, y, z = entity_get_prop(player, "m_vecVelocity")
            if x == nil then
                return
            end
            return math.sqrt(x * x + y * y + z * z)
        end,
        in_air = function(player)
            local flags = entity_get_prop(player, "m_fFlags")
            if bit.band(flags, 1) == 0 then
                return true
            end
            return false
        end,
        limit = function(num, min, max)
            if num < min then
                num = min
            elseif num > max then
                num = max
            end
            return num
        end,
        KaysFunction = function(A, B, C)
            local d = (A - B) / A:dist(B)
            local v = C - B
            local t = v:dot(d)
            local P = B + d:scaled(t)

            return P:dist(C)
        end,
        doubletap_charged = function()
            if not get(reference.rage.dt[1]) or not get(reference.rage.dt[2]) then
                return false
            end

            if not entity_is_alive(entity_get_local_player()) or entity_get_local_player() == nil then
                return
            end

            local weapon = entity_get_prop(entity_get_local_player(), "m_hActiveWeapon")
            if weapon == nil then
                return false
            end

            local next_attack = entity_get_prop(entity_get_local_player(), "m_flNextAttack") + 0.25
            local next_ready = entity_get_prop(weapon, "m_flNextPrimaryAttack")
            if next_ready == nil then
                return
            end

            local next_primary_attack = next_ready + 0.5
            if next_attack == nil or next_primary_attack == nil then
                return false
            end
            return next_attack - globals_curtime() < 0 and next_primary_attack - globals_curtime() < 0
        end,
        modify_velocity = function(c, goalspeed)
            if goalspeed <= 0 then
                return
            end

            local minimalspeed = math.sqrt((c.forwardmove * c.forwardmove) + (c.sidemove * c.sidemove))

            if minimalspeed <= 0 then
                return
            end

            if c.in_duck == 1 then
                goalspeed = goalspeed * 2.94117647
            end

            if minimalspeed <= goalspeed then
                return
            end

            local speedfactor = goalspeed / minimalspeed
            c.forwardmove = c.forwardmove * speedfactor
            c.sidemove = c.sidemove * speedfactor
        end,
        map = function(n, start, stop, new_start, new_stop)
            local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start
            return new_start < new_stop and math.max(math.min(value, new_stop), new_start) or
                math.max(math.min(value, new_start), new_stop)
        end,
        GetClosestPoint = function(A, B, P)
            a_to_p = {P[1] - A[1], P[2] - A[2]}
            a_to_b = {B[1] - A[1], B[2] - A[2]}

            atb2 = a_to_b[1] ^ 2 + a_to_b[2] ^ 2

            atp_dot_atb = a_to_p[1] * a_to_b[1] + a_to_p[2] * a_to_b[2]
            t = atp_dot_atb / atb2

            return {A[1] + a_to_b[1] * t, A[2] + a_to_b[2] * t}
        end,
        last_sim_time = 0,
        defensive_until = 0,
        is_defensive_active = function(local_player)
            local local_player = entity_get_local_player()
            local tickcount = globals.tickcount()
            local sim_time = toticks(entity_get_prop(local_player, "m_flSimulationTime"))
            local sim_diff = sim_time - helpers.last_sim_time

            if sim_diff < 0 then
                helpers.defensive_until = tickcount + math.abs(sim_diff) - toticks(client_latency())
            end

            helpers.last_sim_time = sim_time

            return helpers.defensive_until > tickcount
        end,
    }

    string.startswith = function(self, str)
        return self:find("^" .. str) ~= nil
    end

    local configslist = {}
    local publicconfigslist = {}
    local publicconfigstimestamplist = {}

    local updateconfigs = function()
        local http_data = {
            ["key"] = "kZj0e0F5MvrcLz1Ux3gkSQ",
            ["type"] = "search",
            ["username"] = status.username
        }

        http.post("https://hollywood.codes/api/", {params = http_data}, function(success, response)
            if not success or response.status ~= 200 then
                client.color_log(255, 0, 0, "Something went wrong, contact devs please, connection error1: " .. response.status)
                return
            end

            local configs = json.parse(response.body)
            configslist = {}
            ui_update(antiaim.listbox, configs)
            configslist = configs
            notify:paint(3, "Configs refreshed")
        end)
    end

    local loadpublic = function()
        if table.getn(publicconfigslist) == 0 then
            return
        end

        local cfgpos = get(antiaim.publiclistbox) + 1
        local cfgname = publicconfigslist[cfgpos]
        local http_data = {
            ["key"] = "kZj0e0F5MvrcLz1Ux3gkSQ",
            ["type"] = "loadpublic",
            ["confignamepublic"] = cfgname
        }

        http.post("https://hollywood.codes/api/", {params = http_data}, function(success, response)
            if not success or response.status ~= 200 then
                client.color_log(255, 0, 0, "Something went wrong, contact devs please, connection error2: " .. response.status)
                return
            end

            load_config(response.body)
        end)
    end
    local loadpublicbutton = ui_new_button(tab, container, "Load", loadpublic)

    local updatepublic = function()
        local http_data = {
            ["key"] = "kZj0e0F5MvrcLz1Ux3gkSQ",
            ["type"] = "searchpublic"
        }

        http.post("https://hollywood.codes/api/", {params = http_data}, function(success, response)
            if not success or response.status ~= 200 then
                client.color_log(255, 0, 0, "Something went wrong, contact devs please, connection error4: " .. response.status)
                return
            end

            local configs = json.parse(response.body)
            publicconfigstimestamplist = {}
            publicconfigslist = {}
            for i = 1, #configs do
                publicconfigslist[i] = configs[i][1]
            end
            for i = 1, #configs do
                publicconfigstimestamplist[i] = configs[i][2]
            end
            ui_update(antiaim.publiclistbox, publicconfigslist)
            notify:paint(3, "Public configs refreshed")
        end)
    end

    local deletepublic = function()
        if table.getn(publicconfigslist) == 0 then
            return
        end

        local cfgpos = get(antiaim.publiclistbox) + 1
        local cfgname = publicconfigslist[cfgpos]
        if cfgname == nil then
            return
        end

        if not cfgname:startswith(status.username) then
            notify:paint(3, "You can't delete other people's configs")
            return
        else
            local http_data = {
                ["key"] = "kZj0e0F5MvrcLz1Ux3gkSQ",
                ["type"] = "deletepublic",
                ["confignamepublic"] = cfgname
            }
            http.post("https://hollywood.codes/api/", {params = http_data}, function(success, response)
                if not success or response.status ~= 200 then
                    client.color_log(255, 0, 0, "Something went wrong, contact devs please, connection error3: " .. response.status)
                    return
                end
            end)
            notify:paint(3, "Config deleted")
        end
        client_delay_call(0.5, updatepublic)
        client_delay_call(0.6, function() set(antiaim.publiclistbox, 1) end)
    end
    local deletepublicbutton = ui_new_button(tab, container, "Delete", deletepublic)
    
    local updatepublicbutton = ui_new_button(tab, container, "Refresh", updatepublic)
    local loadconfig = function()
        if table.getn(configslist) == 0 then
            return
        end

        local cfgpos = get(antiaim.listbox) + 1
        local cfgname = configslist[cfgpos]
        local http_data = {
            ["key"] = "kZj0e0F5MvrcLz1Ux3gkSQ",
            ["type"] = "load",
            ["username"] = status.username,
            ["configname"] = cfgname
        }

        http.post("https://hollywood.codes/api/", {params = http_data}, function(success, response)
            if not success or response.status ~= 200 then
                client.color_log(255, 0, 0, "Something went wrong, contact devs please, connection error5: " .. response.status)
                return
            end

            load_config(response.body)
        end)
    end
    local loadbutton = ui_new_button(tab, container, "Load", loadconfig)

    local saveconfig = function()
        local createtextget = get(antiaim.createtext)
        local content = encode_config()
        if createtextget == "" then
            local cfgpos = get(antiaim.listbox) + 1
            local cfgname = configslist[cfgpos]
            createtextget = cfgname
        end
        local http_data = {
            ["key"] = "kZj0e0F5MvrcLz1Ux3gkSQ",
            ["type"] = "update",
            ["username"] = status.username,
            ["configname"] = createtextget,
            ["configcontent"] = content
        }

        http.post("https://hollywood.codes/api/", {params = http_data}, function(success, response)
            if not success or response.status ~= 200 then
                client.color_log(255, 0, 0, "Something went wrong, contact devs please, connection error6: " .. response.status)
                return
            end
            notify:paint(3, "Config saved")
        end)
        client_delay_call(0.5, updateconfigs)
    end

    client_delay_call(0.8, updateconfigs)
    client_delay_call(0.8, updatepublic)

    local updatebutton = ui_new_button(tab, container, "Save", saveconfig)

    local deleteconfig = function()
        if table.getn(configslist) == 0 then
            return
        end
        local cfgpos = get(antiaim.listbox) + 1
        local cfgname = configslist[cfgpos]

        local http_data = {
            ["key"] = "kZj0e0F5MvrcLz1Ux3gkSQ",
            ["type"] = "delete",
            ["username"] = status.username,
            ["configname"] = cfgname
        }
        http.post("https://hollywood.codes/api/", {params = http_data}, function(success, response)
            if not success or response.status ~= 200 then
                client.color_log(255, 0, 0, "Something went wrong, contact devs please, connection error7: " .. response.status)
                return
            end
            notify:paint(3, "Config deleted")
        end)

        client_delay_call(0.5, updateconfigs)
        client_delay_call(0.6, function() set(antiaim.listbox, 1) end)
    end

    local deletebutton = ui_new_button(tab, container, "Delete", deleteconfig)
    local refreshbutton = ui_new_button(tab, container, "Refresh", updateconfigs)

    local share = function()
        if table.getn(configslist) == 0 then
            return
        end
        local cfgpos = get(antiaim.listbox) + 1
        local cfgname = configslist[cfgpos]
        local http_data = {
            ["key"] = "kZj0e0F5MvrcLz1Ux3gkSQ",
            ["type"] = "share",
            ["username"] = status.username,
            ["configname"] = cfgname
        }
        http.post("https://hollywood.codes/api/", {params = http_data}, function(success, response)
            if not success or response.status ~= 200 then
                client.color_log(255, 0, 0, "Something went wrong, contact devs please, connection error8: " .. response.status)
                return
            end
            notify:paint(3, "Config shared to public list")
        end)
        client_delay_call(0.5, updatepublic)
    end

    local share = ui_new_button(tab, container, "Share", share)

    local mode = (function()
		local aa = {}
		aa.terno = function(og_val, min, max, terno_v, terno_t)
			local terno_min, terno_max = min, max
			local terno_v = terno_v
			local terno_ticks = globals.tickcount() % 7

			if terno_ticks == 7 - 1 then
				if og_val < terno_max then
					og_val = og_val + terno_v
				elseif og_val >= terno_max then
					og_val = terno_min
				end
			end
			return helpers.limit(og_val, terno_min, terno_max)
		end

		aa.get_invert = function()
			local invert = (math.floor(math.min(get(reference.antiaim.body_yaw[2]), (entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * (get(reference.antiaim.body_yaw[2]) * 2) - get(reference.antiaim.body_yaw[2]))))) > 0
			return invert
		end

		aa.sync = function(a,b)
			local invert = (math.floor(math.min(get(reference.antiaim.body_yaw[2]), (entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * (get(reference.antiaim.body_yaw[2]) * 2) - get(reference.antiaim.body_yaw[2]))))) > 0
			return invert and a or b
		end

		aa.o_sync = function(a,b)     
			local invert = (math.floor(math.min(get(reference.antiaim.body_yaw[2]), (entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * (get(reference.antiaim.body_yaw[2]) * 2) - get(reference.antiaim.body_yaw[2]))))) > 0
			return invert and b or a
		end

		aa.random = function(minl,minr,maxl,maxr)
			return aa.sync(math.random(minl,minr), math.random(maxl,maxr))
		end

		aa.sway = function(max, speed, min)
			return math.abs(math.floor(math.sin(globals_curtime() / speed * 1) * max))
		end

		aa.calculate = function(a)
			local rounded = function(num, decimals)
				local mult = 10^(decimals or 0)
				return math.floor(num * mult + 0.5) / mult
			end

			body_yaw = math.max(-60, math.min(60, rounded((entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) or 0)*120-60+0.5, 1)))
			if body_yaw == nil then body_yaw = 0 end
			local function dump(o)
				if type(o) == 'table' then
					local s = '{ '
					for k, v in pairs(o) do
                        if type(k) ~= 'number' then 
                            k = '"'..k..'"' 
                        end
                        s = s .. '['..k..'] = ' .. dump(v) .. ','
                    end
					return s .. '} '
				else
					return tostring(o)
				end
			end

			last_by = tonumber(dump(get(reference.antiaim.body_yaw[2])))
			return math.ceil(math.ceil((last_by > 0) and math.abs(body_yaw)/math.pi or (-math.abs(body_yaw)/math.pi))/(a/5))
		end
		return aa
	end)()

    local command = {}
    command = {
        ["switch"] = false,
        ["ground_ticks"] = 1,
        ["end_time"] = 0,
        ["on_ground"] = 0,
        ["fsdisabled"] = false,
        ["manual"] = {
            back_dir = true,
            left_dir = false,
            right_dir = false,
            forward_dir = false
        },
        ["antiaim"] = {
            pitch = "off",
            yaw = "180",
            yaw_val = 0,
            yaw_base = "at targets",
            yaw_jitter = "off",
            yaw_jitter_val = 0,
            body = "off",
            fsbody = false,
            body_val = 0,
        },
        manip_svbt = function()
            if contains(misc.misc_menu, "Manipulate backtracking") then
                if get(misc.manipsvbt) == "Game default" then
                    client_set_cvar("sv_maxunlag", 0.2)
                end
                if get(misc.manipsvbt) == "Over-predict fix" then
                    client_set_cvar("sv_maxunlag", 0.19)
                end
                if get(misc.manipsvbt) == "Extended optimal" then
                    client_set_cvar("sv_maxunlag", 0.3)
                end
                if get(misc.manipsvbt) == "Extended" then
                    client_set_cvar("sv_maxunlag", 1)
                end
            end

            if not contains(misc.misc_menu, "Manipulate backtracking") then
                client_set_cvar("sv_maxunlag", 0.2)
            end
        end,
        anti_backstab = function()
            local get_distance = function(x1, y1, z1, x2, y2, z2)
                return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
            end

            if contains(misc.misc_menu, "Anti-knife") then
                local players = entity_get_players(true)
                local lx, ly, lz = entity_get_prop(entity_get_local_player(), "m_vecOrigin")
                for i = 1, #players do
                    local x, y, z = entity_get_prop(players[i], "m_vecOrigin")
                    local distance = get_distance(lx, ly, lz, x, y, z)
                    local weapon = entity_get_player_weapon(players[i])
                    if entity_get_classname(weapon) == "CKnife" and distance <= get(misc.knife_distance) then
                        command["antiaim"].pitch = "off"
                        command["antiaim"].yaw_val = 180
                        command["antiaim"].yaw_base = "At targets"
                    end
                end
            end
        end,
        anti_zeus = function()
            local get_distance = function(x1, y1, z1, x2, y2, z2)
                return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
            end

            if contains(misc.misc_menu, "Anti-zeus") then
                local players = entity_get_players(true)
                local lx, ly, lz = entity_get_prop(entity_get_local_player(), "m_vecOrigin")
                for i = 1, #players do
                    local x, y, z = entity_get_prop(players[i], "m_vecOrigin")
                    local distance = get_distance(lx, ly, lz, x, y, z)
                    local weapon = entity_get_player_weapon(players[i])
                    local selfweapon = entity_get_player_weapon(entity_get_local_player())

                    if entity_get_classname(weapon) == "CWeaponTaser" and distance <= get(misc.zeus_distance) then
                        if get(misc.zeus_options) == "Pull pistol" then
                            client_exec("slot2")
                        elseif
                            get(misc.zeus_options) == "Pull zeus" and entity_get_classname(selfweapon) ~= "CWeaponTaser"
                         then
                            client_exec("slot3;")
                        end
                    end
                end
            end
        end,
        _states = function(c)
            local me = entity_get_local_player()

            -- setup of player state heirarchy
            local flags = entity_get_prop(me, "m_fFlags")
            local ducking = c.in_duck == 1
            local air = command["on_ground"] < 5
            local velocity = {entity_get_prop(me, 'm_vecVelocity')}
            local walking = math.abs(velocity[1]) > 2 or math.abs(velocity[2]) > 2 or math.abs(velocity[3]) > 2
            local standing = not walking
            local slow_motion = get(reference.rage.slow[1]) and get(reference.rage.slow[2])
            local fakeducking = get(reference.rage.fakeduck)
            local wpn = entity_get_player_weapon(me)
            local wpn_id = entity_get_prop(wpn, "m_iItemDefinitionIndex")

            local is_dt = get(reference.rage.dt[1]) and get(reference.rage.dt[2])
            local is_os = get(reference.rage.os[1]) and get(reference.rage.os[2])
            local is_fl = not is_dt and not is_os and get(reference.fakelag.fl_limit) > 1

            command["on_ground"] = bit.band(flags, 1) == 0 and 0 or (command["on_ground"] < 5 and command["on_ground"] + 1 or command["on_ground"])
            
            -- see what we are doing rn
            -- heirarchy    1          2       3         4           5           6        7          8           9
            -- state = {"Default", "Stand", "Move", "Fake lag", "Slow motion", "Duck", "In air", "Air duck", "Defensive"},
            local now_state = 1
            local now_indi = "DEFAULT"
            if helpers.is_defensive_active(me) and is_dt then
                now_state = 9
                now_indi = "DEFEND"
            elseif is_fl then
                now_state = 8
                now_indi = "FAKELAG"
            elseif air and ducking then
                now_state = 7
                now_indi = "AIR + D"
            elseif air and not ducking then
                now_state = 6
                now_indi = "IN AIR"      
            elseif (fakeducking or ducking) then
                now_state = 5
                now_indi = "DUCK"
            elseif slow_motion then
                now_state = 4
                now_indi = "SLOW MO"
            elseif walking then
                now_state = 3
                now_indi = "MOVE"
            elseif standing then
                now_state = 2
                now_indi = "STAND"
            else
                -- we must be doing something weird, resort to init values
            end

            -- check if player state is activated
            local mode_active_for_state = get(elements[now_state].enable_state)

            -- check the given comboboxmode for the player state
            local aa_mode = string.lower(get(elements[now_state].mode))

            -- if the combo's mode is active for the state, update p_state
            if mode_active_for_state then
                vars.p_state = now_state
                vars.ind_state = now_indi
            else
                vars.p_state = 1
                vars.ind_state = "DEFAULT"
            end

            local can_defensive = elements[vars.p_state][aa_mode].defensive
            local is_def = can_defensive and get(can_defensive) or false

            if is_def and get(reference.rage.dt[2]) then
                c.force_defensive = true
                c.no_choke = true
                c.quick_stop = true
            else
                c.force_defensive = false
                c.no_choke = false
                c.quick_stop = false
            end
        end,
        fl_adaptive = function(c)
            local m_velocity = vector(entity_get_prop(entity_get_local_player(), "m_vecVelocity"))
            local is_dt = get(reference.rage.dt[1]) and get(reference.rage.dt[2])
            local distance_per_tick = m_velocity:length2d() * globals.tickinterval()
            local on_ground = bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1)

            if on_ground == 1 then
                command["ground_ticks"] = command["ground_ticks"] + 1
            else
                command["ground_ticks"] = 0
                command["end_time"] = globals_curtime() + 1
            end

            if not entity_is_alive(entity_get_local_player()) then
                return
            end

            local lpweapon = entity_get_player_weapon(entity_get_local_player())
            if lpweapon == nil then
                return
            end

            local weapon_index = bit.band(65535, entity_get_prop(lpweapon, "m_iItemDefinitionIndex"))
            if weapon_index == nil then
                return
            end

            local moving = distance_per_tick > 0.0158 and not helpers.in_air(entity_get_local_player()) and (contains(fl_tab.trigger, "Moving"))
            local in_air = helpers.in_air(entity_get_local_player()) and (contains(fl_tab.trigger, "In air"))
            local stand = distance_per_tick < 0.0158 and (contains(fl_tab.trigger, "Standing"))
            local landed = command["ground_ticks"] > c.chokedcommands + 1 and command["end_time"] > globals_curtime() and (contains(fl_tab.trigger, "On land"))
            local slowwalking = get(reference.rage.slow[1]) and get(reference.rage.slow[2]) and (contains(fl_tab.trigger, "Slowwalk"))

            if in_air or moving or landed or stand or get(reference.rage.fakeduck) or slowwalking then
                trigger = true
            else
                trigger = false
            end

            local lc = helpers.in_air(entity_get_local_player()) or distance_per_tick >= 3 or get(reference.rage.dt[1]) and get(reference.rage.dt[2]) and distance_per_tick > 0.0158
            if get(reference.rage.fakeduck) then
                fl = 14
            else
                if (c.in_attack == 1 and contains(fl_tab.forcelimit, "While shooting") and not (weapon_index == 44 or weapon_index == 46 or weapon_index == 43 or weapon_index == 47 or weapon_index == 45 or weapon_index == 48)) or (distance_per_tick < 0.0158 and not helpers.in_air(entity_get_local_player()) and contains(fl_tab.forcelimit, "While standing")) or (get(reference.rage.os[2]) and contains(fl_tab.forcelimit, "While os-aa")) then
                    fl = 1
                elseif get(fl_tab.fakelag_tab) == "Maximum" then
                    fl = get(fl_tab.sendlimit)
                elseif get(fl_tab.fakelag_tab) == "Dynamic" then
                    fl = (trigger == true and get(fl_tab.triggerlimit) or get(fl_tab.sendlimit))
                else
                    fl = (command["switch"] and get(fl_tab.triggerlimit) or get(fl_tab.sendlimit))
                end
            end

            local stable = lc and 14 or fl
            local send = helpers.consistent(14, 15)
            local lagcomp = lc and send or 2
            local outgo = globals.lastoutgoingcommand()
            local amount = helpers.variance(lagcomp, 1, outgo) == 2 and stable or 0

            if get(fl_tab.advanced_fl) then
                set(reference.fakelag.enablefl, false)
                set(reference.fakelag.fl_limit, fl)
                set(reference.fakelag.fl_amount, "Maximum")
                set(reference.fakelag.fl_var, 0)

                c.allow_send_packet = amount
            else
                set(reference.fakelag.enablefl, true)
            end
        end,
        anti_aim_on_use = function(c)
            if c.in_use == 1 then
                command["antiaim"].yaw_val = 0
                command["antiaim"].yaw_jitter_val = 0
                command["antiaim"].body = "static"
                command["antiaim"].fsbody = true
                if entity_get_classname(entity_get_player_weapon(entity_get_local_player())) == "CC4" then
                    return
                end
                if c.in_attack == 1 then
                    c.in_use = 1
                end
                if c.chokedcommands == 0 then
                    c.in_use = 0
                end
            else
                command["antiaim"].fsbody = false
            end
        end,
        manualaa = function()
            local mnl_aa = command["manual"]
            if get(antiaim.manual_reset) then
                mnl_aa.back_dir = true
                mnl_aa.right_dir = false
                mnl_aa.left_dir = false
                mnl_aa.forward_dir = false
                vars.last_press = globals_curtime()
            elseif get(antiaim.manual_right) and get(antiaim.toggle_manual) then
                if mnl_aa.right_dir == true and vars.last_press + 0.02 < globals_curtime() then
                    mnl_aa.back_dir = true
                    mnl_aa.right_dir = false
                    mnl_aa.left_dir = false
                    mnl_aa.forward_dir = false
                elseif mnl_aa.right_dir == false and vars.last_press + 0.02 < globals_curtime() then
                    mnl_aa.right_dir = true
                    mnl_aa.back_dir = false
                    mnl_aa.left_dir = false
                    mnl_aa.forward_dir = false
                end
                vars.last_press = globals_curtime()
            elseif get(antiaim.manual_left) and get(antiaim.toggle_manual) then
                if mnl_aa.left_dir == true and vars.last_press + 0.02 < globals_curtime() then
                    mnl_aa.back_dir = true
                    mnl_aa.right_dir = false
                    mnl_aa.left_dir = false
                    mnl_aa.forward_dir = false
                elseif mnl_aa.left_dir == false and vars.last_press + 0.02 < globals_curtime() then
                    mnl_aa.left_dir = true
                    mnl_aa.back_dir = false
                    mnl_aa.right_dir = false
                    mnl_aa.forward_dir = false
                end
                vars.last_press = globals_curtime()
            elseif get(antiaim.manual_forward) and get(antiaim.toggle_manual) then
                if mnl_aa.forward_dir == true and vars.last_press + 0.02 < globals_curtime() then
                    mnl_aa.back_dir = true
                    mnl_aa.right_dir = false
                    mnl_aa.left_dir = false
                    mnl_aa.forward_dir = false
                elseif mnl_aa.forward_dir == false and vars.last_press + 0.02 < globals_curtime() then
                    mnl_aa.left_dir = false
                    mnl_aa.back_dir = false
                    mnl_aa.right_dir = false
                    mnl_aa.forward_dir = true
                end
                vars.last_press = globals_curtime()
            end

            if mnl_aa.right_dir == true then
                command["antiaim"].yaw = 180
                command["antiaim"].yaw_val = 90
                command["antiaim"].yaw_base = "local view"
                command["antiaim"].body = "opposite"
            elseif mnl_aa.left_dir == true then
                command["antiaim"].yaw = 180
                command["antiaim"].yaw_val = -90
                command["antiaim"].yaw_base = "local view"
                command["antiaim"].body = "opposite"
            elseif mnl_aa.forward_dir == true then
                command["antiaim"].yaw = 180
                command["antiaim"].yaw_val = 180
                command["antiaim"].yaw_base = "local view"
                command["antiaim"].body = "opposite"
            end
        end,
        freestand = function()
            local b_yaw = entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60
            local is_fs = get(antiaim.fs) and not command["fsdisabled"]
            local is_manual = command["manual"].back_dir
            
            command["fsdisabled"] = false

            if get(antiaim.fs) then
                set(reference.antiaim.freestand[2], "Always on")
                set(reference.antiaim.freestand[1], true)
            end

            local aa_mode = string.lower(get(elements[vars.p_state].mode))
            if get(elements[vars.p_state][aa_mode].aa_disabled) or not is_manual then
                command["fsdisabled"] = true
            end

            if not get(antiaim.fs) or command["fsdisabled"] then
                set(reference.antiaim.freestand[2], "On hotkey")
                set(reference.antiaim.freestand[1], false)
            end
        end,
        aa_builder = function(c)
            local mnl_aa = command["manual"]
            local is_fs = get(antiaim.fs) and not command["fsdisabled"]
            if not entity_is_alive(entity_get_local_player()) then
                return
            end
            local inverter = 1

            if globals.chokedcommands() == 0 then
                random_jitter = client_random_int(0, 1) == 1 and 1 or -1
            end

            local aa_mode = string.lower(get(elements[vars.p_state].mode))
            local current_aa = elements[vars.p_state][aa_mode]

            local e_yaw_mode = get(current_aa.yaw_mode)

            if e_yaw_mode == "Extrapolated" or e_yaw_mode == "Extrapolated skitter" then
                inverter = random_jitter
            end

            if inverter == nil then
                return
            end

            if mnl_aa.back_dir == true then
                if c.chokedcommands ~= 0 then

                else
                    local current_stage_3way = e_yaw_mode == "3 way" and ((globals.tickcount() % 3) + 1) or 0
                    local three_way = 0

                    if current_stage_3way == 1 then
                        three_way = get(current_aa.yaw_3_way_1)
                    elseif current_stage_3way == 2 then
                        three_way = get(current_aa.yaw_3_way_2)
                    elseif current_stage_3way == 3 then
                        three_way = get(current_aa.yaw_3_way_3)
                        current_stage_3way = 0
                    end

                    --main
                    command["antiaim"].yaw = "180"

                    -- pitch
                    local new_pitch = get(current_aa.pitch)
                    if new_pitch ~= "Zero" and new_pitch ~= "Disabled" then
                        command["antiaim"].pitch = new_pitch
                    else
                        command["antiaim"].pitch = "Off"
                    end
                    
                    command["antiaim"].yaw_jitter = "Off"
                    command["antiaim"].yaw_jitter_val = 0

                    -- yaw
                    if e_yaw_mode == "Extrapolated" then
                        command["antiaim"].yaw_val = (inverter == -1 and get(current_aa.yaw_left) or get(current_aa.yaw_right)) or 0
                    elseif e_yaw_mode == "Extrapolated skitter" then
                        command["antiaim"].yaw_jitter = "Skitter"
                        command["antiaim"].yaw_jitter_val = (inverter == -1 and get(current_aa.yaw_left) or get(current_aa.yaw_right)) or 0
                    elseif e_yaw_mode == "Synced body" then
                        command["antiaim"].yaw_val = mode.sync(
                            get(current_aa.yaw_left),
                            get(current_aa.yaw_right)
                        )
                    elseif e_yaw_mode == "Synced random" then
                        command["antiaim"].yaw_val = mode.random(
                            get(current_aa.yaw_min_left),
                            get(current_aa.yaw_max_left),
                            get(current_aa.yaw_min_right),
                            get(current_aa.yaw_max_right)
                        )
                    elseif e_yaw_mode == "3 way" then
                        command["antiaim"].yaw_val = three_way
                    elseif e_yaw_mode == "Default" then
                        command["antiaim"].yaw_val = -1
                        command["antiaim"].yaw_jitter = "Center"
                        command["antiaim"].yaw_jitter_val = get(current_aa.yaw_default)
                    end

                    -- deysnc
                    local body_mode = get(current_aa.b_yaw)
                    if body_mode == "Opposite" then
                        command["antiaim"].body = "Opposite"
                        command["antiaim"].body_val = 0
                    elseif body_mode == "Static" then
                        command["antiaim"].body = "Static"
                        local byawside = get(current_aa.b_yaw_side)
                        if byawside == "Left" then
                            command["antiaim"].body_val = -1
                        elseif byawside == "Right" then
                            command["antiaim"].body_val = 1
                        end
                    elseif body_mode == "Jitter" then
                        command["antiaim"].body = "Static"
                        local bspeed = get(current_aa.b_yaw_speed)
                        local tick_rate = 1 / globals.tickinterval()
                        bspeed = bspeed == 0 and client_random_int(1, 30) or (bspeed == 31 and (tick_rate / 2) or bspeed)
                        command["antiaim"].body_val = math.floor((globals_curtime() * bspeed) % 2) == 0 and -180 or 180
                    end
                end
            end
        end,
        
        apply_aa = function()
            local vals = command["antiaim"]
            set(reference.antiaim.pitch, vals.pitch)
            set(reference.antiaim.yaw[1], vals.yaw)
            set(reference.antiaim.yaw[2], vals.yaw_val)
            set(reference.antiaim.yawbase, vals.yaw_base)
            set(reference.antiaim.yaw_jitt[1], vals.yaw_jitter)
            set(reference.antiaim.yaw_jitt[2], vals.yaw_jitter_val)
            set(reference.antiaim.fsbodyyaw, vals.fsbody)
            set(reference.antiaim.body_yaw[1], vals.body)
            set(reference.antiaim.body_yaw[2], vals.body_val)
        end,

        teleport = function()
            local client_visible = client.visible
            local local_player = entity_get_local_player()
            if not get(antiaim.lc_break) then
                set(reference.rage.dt[1], true)
                return
            end
            if not entity_is_alive(local_player) then
                return
            end
            local enemies = entity_get_players(true)
            local vis = false
            for i = 1, #enemies do
                local entindex = enemies[i]
                local body_x, body_y, body_z = entity_hitbox_position(entindex, 1)
                if client_visible(body_x, body_y, body_z + 20) then
                    vis = true
                end
            end
            if vis then
                set(reference.rage.dt[1], false)
            else
                set(reference.rage.dt[1], true)
            end
        end
    }

    local function indicator()
        local text = ("TP")
        if get(antiaim.lc_break) and entity_is_alive(entity_get_local_player()) then
            renderer.indicator(255, 255, 255, 255, text)
        end
    end
    client_set_event_callback("paint", indicator)

    local old_anim = function()
        local localplayer = entity_get_local_player()
        if localplayer == nil then
            return
        end
        local is_sw = get(reference.rage.slow[1]) and get(reference.rage.slow[2])
        local bodyyaw = entity_get_prop(localplayer, "m_flPoseParameter", 11) * 120 - 60
        local side = bodyyaw > 0 and 1 or -1

        if contains(misc.anim_breaker, "0 pitch on land") and contains(misc.misc_menu, "Animation breakers") then
            local on_ground = bit.band(entity_get_prop(localplayer, "m_fFlags"), 1)

            if on_ground == 1 then
                command["ground_ticks"] = command["ground_ticks"] + 1
            else
                command["ground_ticks"] = 0
                command["end_time"] = globals_curtime() + 1
            end

            if command["ground_ticks"] > get(reference.fakelag.fl_limit) + 1 and command["end_time"] > globals_curtime() then
                entity_set_prop(localplayer, "m_flPoseParameter", 0.5, 12)
            end
        end

        if not contains(misc.anim_breaker, "Moonwalk") then
            return
        end

        local me = ent.get_local_player()
		local m_fFlags = me:get_prop("m_fFlags");
		local is_onground = bit.band(m_fFlags, 1) ~= 0;

		if contains(misc.anim_breaker, "Moonwalk") and contains(misc.misc_menu, "Animation breakers") then
			set(reference.rage.lm, "Never slide")
			entity.set_prop(localplayer, "m_flPoseParameter", 1, 7)
			if not is_onground then
				local my_animlayer = me:get_anim_overlay(6);
				my_animlayer.weight = 1;
				entity.set_prop(me, "m_flPoseParameter", 1, 6)
			end
		end
    end

    local solus_render = (function()
        local solus_m = {}
        local RoundedRect = function(x, y, w, h, radius, r, g, b, a)
            renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
            renderer.rectangle(x, y + radius, radius, h - radius * 2, r, g, b, a)
            renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, r, g, b, a)
            renderer.rectangle(x + w - radius, y + radius, radius, h - radius * 2, r, g, b, a)
            renderer.rectangle(x + radius, y + radius, w - radius * 2, h - radius * 2, r, g, b, a)
            renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
            renderer.circle(x + w - radius, y + radius, r, g, b, a, radius, 90, 0.25)
            renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, 270, 0.25)
            renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25)
        end

        local rounding = 6
        local rad = rounding + 2
        local n = 45
        local o = 20
        local OutlineGlow = function(x, y, w, h, radius, r, g, b, a)
            renderer.rectangle(x + 2, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
            renderer.rectangle(x + w - 3, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
            renderer.rectangle(x + radius + rad, y + 2, w - rad * 2 - radius * 2, 1, r, g, b, a)
            renderer.rectangle(x + radius + rad, y + h - 3, w - rad * 2 - radius * 2, 1, r, g, b, a)
            renderer.circle_outline(x + radius + rad, y + radius + rad, r, g, b, a, radius + rounding, 180, 0.25, 1)
            renderer.circle_outline(x + w - radius - rad, y + radius + rad, r, g, b, a, radius + rounding, 270, 0.25, 1)
            renderer.circle_outline(x + radius + rad, y + h - radius - rad, r, g, b, a, radius + rounding, 90, 0.25, 1)
            renderer.circle_outline(x + w - radius - rad, y + h - radius - rad, r, g, b, a, radius + rounding, 0, 0.25, 1)
        end
        local FadedRoundedRect = function(x, y, w, h, radius, r, g, b, a, glow)
            local n = a / 255 * n
            renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, a)
            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, 1)
            renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, 270, 0.25, 1)
            renderer.gradient(x, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b, n, false)
            renderer.gradient(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b, n, false)
            renderer.circle_outline(x + radius, y + h - radius, r, g, b, n, radius, 90, 0.25, 1)
            renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, n, radius, 0, 0.25, 1)
            renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
            for radius = 4, glow do
                local radius = radius / 2
                OutlineGlow(x - radius, y - radius, w + radius * 2, h + radius * 2, radius, r, g, b, glow - radius * 2)
            end
        end

        solus_m.container = function(x, y, w, h, r, g, b, a, alpha, fn)
            RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
            FadedRoundedRect(x, y, w, h, rounding, r, g, b, a, alpha * o)
            if not fn then
                return
            end
            fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
        end
        return solus_m
    end)()

    local animate = (function()
        local anim = {}

        local lerp = function(start, vend)
            return start + (vend - start) * (globals.frametime() * 6)
        end

        local lerp_notify = function(start, vend)
            return start + (vend - start) * (globals.frametime() * 8)
        end

        anim.new_notify = function(value, startpos, endpos, condition)
            if condition ~= nil then
                if condition then
                    return lerp_notify(value, startpos)
                else
                    return lerp_notify(value, endpos)
                end
            else
                return lerp_notify(value, startpos)
            end
        end

        anim.new = function(value, startpos, endpos, condition)
            if condition ~= nil then
                if condition then
                    return lerp(value, startpos)
                else
                    return lerp(value, endpos)
                end
            else
                return lerp(value, startpos)
            end
        end

        anim.color_lerp = function(color, color2, end_value, condition)
            if condition ~= nil then
                if condition then
                    color.r = lerp(color.r, color2.r)
                    color.g = lerp(color.g, color2.g)
                    color.b = lerp(color.b, color2.b)
                    color.a = lerp(color.a, color2.a)
                else
                    color.r = lerp(color.r, end_value.r)
                    color.g = lerp(color.g, end_value.g)
                    color.b = lerp(color.b, end_value.b)
                    color.a = lerp(color.a, end_value.a)
                end
            else
                color.r = lerp(color.r, color2.r)
                color.g = lerp(color.g, color2.g)
                color.b = lerp(color.b, color2.b)
                color.a = lerp(color.a, color2.a)
            end
            return {r = color.r, g = color.g, b = color.b, a = color.a}
        end

        anim.adapting = function(cur, min, max, target, step, speed)
            local step = step or 1
            local speed = speed or 0.1

            if cur < min + step then
                target = max
            elseif cur > max - step then
                target = min
            end
            return cur + (target - cur) * speed * (globals.absoluteframetime() * 10)
        end
        return anim
    end)()

    local gradient_text = function(r1, g1, b1, a1, r2, g2, b2, a2, m)
        local output = ""
        local len = #m
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len

        for i = 1, len do
            output = output .. ("\a%02x%02x%02x%02x%s"):format(r1, g1, b1, a1, m:sub(i, i))
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
        return output
    end

    local get_hotkey_index = function(refs)
        local to_return = {true, -1}
        for i = 1, #refs do
            if i == 1 and #refs > 1 then
                if not ui.get(refs[i]) then
                    to_return[1] = false
                end
            end
            if #{ui.get(refs[i])} > to_return[2] then
                to_return[2] = i
            end
        end
        return to_return
    end

    local screen = {client_screen_size()}
    local x_offset, y_offset = screen[1], screen[2]
    local x, y = x_offset / 2, y_offset / 2

    local bind_states = {'always', 'holding', 'toggled', 'off-hold'}
    local bind_easing = {}
    local active_binds = {}

    local create_bind = (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui.new_slider('LUA','A',u..' window position y',0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()
    local bind_data = database.read('momentum_bind_drag') or {
        x = screen[1] * 0.01, 
        y = screen[2] / 2,
        alpha = contains(vis.vis_menu, "Keybinds") and 255 or 0,
    }
    local binds = create_bind.new('momentum_bind', bind_data.x, bind_data.y)
    local ease_length = 0.125
    local curr_w = 15

    local visuals = {}
    visuals = {
        ["stored"] = {
            ["crosshair"] = {
                ["alpha"] = 0,
                ["scoped"] = 0,
                ["values"] = {0, 0, 0, 0, 0, 0},
                ["doubletap_color"] = {r = 0, g = 0, b = 0, a = 0},
                ["modern"] = {speed = 1, text_alpha = 0, text_alpha2 = 0, color = {r = 0, g = 0, b = 0, a = 0}},
                ["fake_anim"] = 0
            },
            ["arrows"] = {
                ["off_set"] = 0
            }
        },

        render_keybinds = function()
            if not contains(vis.vis_menu, "Keybinds") then
                return
            end

            local pos = {binds:get()}
            local bx, by = pos[1], pos[2]
            local bw, bh = 210, 25
            local pad = 5

            database.write('momentum_bind_drag', {
                x = pos[1],
                y = pos[2],
                alpha = bind_data.alpha,
            })

            for i, bind in ipairs(keybind_list) do
                local hotkey_ind = get_hotkey_index(bind.reference)
                local bind_hk = {get(bind.reference[hotkey_ind[2]])}
                active_binds[bind.use_name] = {bind.use_name, bind_states[bind_hk[2] + 1], bind_hk[1] and hotkey_ind[1], -1}
                if (bind_hk[1] and hotkey_ind[1]) and not bind_easing[bind.use_name] then
                    bind_easing[bind.use_name] = {0, 0}
                end
            end


            local total_active = 0
            for j = 1, #keybind_options do
                local bind = active_binds[keybind_options[j]]
                local bind_name = bind[1]
                if contains(vis.bind_multi, bind_name) and (bind[3] or (bind_easing[bind_name] and bind_easing[bind_name][1] > 0)) then
                    total_active = total_active + 1
                end
            end

            local fading = ease_length * 255 * 50 * globals.absoluteframetime()
            bind_data.alpha = clamp(bind_data.alpha + ((ui.is_menu_open() or (entity_is_alive(entity_get_local_player()) and total_active > 0)) and fading or -fading), 0, 255)

            local base_sizex, base_sizey = renderer.measure_text(nil, "Keybinds")
            if bind_data.alpha > 1 then
                local r, g, b = get(vis.bind_clr)

                local i, y_offset, desire_w = 1, 0, base_sizex * 1.5
                for j = 1, #keybind_options do
                    local bind = active_binds[keybind_options[j]]
                    local bind_name = bind[1]
                    if contains(vis.bind_multi, bind_name) and (bind[3] or (bind_easing[bind_name] and bind_easing[bind_name][1] > 0)) then
                        local line_y = by + bh + y_offset
                        local base_x = bx
                        local b_alpha = bind_easing[bind_name][1] * 255

                        local partial = ("\a%02x%02x%02x%02x"):format(r, g, b, b_alpha)
                        renderer.text(base_x + (curr_w * 0.5), line_y, 215, 215, 215, b_alpha, "c", 0, bind_name .. " - ".. partial .. bind[2])

                        local m_w, m_h = renderer.measure_text(nil, bind_name .. " - " .. bind[2])
                        y_offset = y_offset + m_h
                        desire_w = math.max(desire_w, m_w)

                        bind_easing[bind_name][1] = bind[3] and easing.quad_out(bind_easing[bind_name][2], 0, 1, ease_length) or easing.quad_out(ease_length - bind_easing[bind_name][2], 1, -1, ease_length)
                        bind_easing[bind_name][1] = clamp(bind_easing[bind_name][1], 0, 1)
        
                        bind_easing[bind_name][2] = bind[3] and bind_easing[bind_name][2] + globals.absoluteframetime() or bind_easing[bind_name][2] - globals.absoluteframetime()
                        bind_easing[bind_name][2] = clamp(bind_easing[bind_name][2], 0, ease_length)
                        i = i + 1
                    end
                end

                if desire_w - curr_w > 0 then
                    curr_w =  clamp(curr_w + (globals.absoluteframetime() * 200), base_sizex * 1.5, desire_w)
                else
                    curr_w =  clamp(curr_w - (globals.absoluteframetime() * 200), desire_w, math.huge)
                end

                solus_render.container(bx, by, math.floor(curr_w), base_sizey * 1.5, r, g, b, bind_data.alpha, 1)
                renderer.text(bx + (curr_w * 0.5), by + (base_sizey * 0.68), 255, 255, 255, bind_data.alpha, "c", 0, "Keybinds")
            end

            binds:drag(curr_w * 1.5, base_sizey * 2)
        end,

        render_inds = function()
            if not contains(vis.vis_menu, "Indicators") then
                return
            end

            local crshair = visuals["stored"]["crosshair"]
            local text_size_x, text_size_y = renderer.measure_text(nil, "M O M E N T U M")
            local r, g, b = get(vis.main_clr)
            local r1, g1, b1 = get(vis.main_clr2)

            local b_yaw = entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 1.3
            crshair["alpha"] = animate.new(crshair["alpha"], 1, 0, contains(vis.vis_menu, "Indicators"))
            if crshair["alpha"] < 0.01 then
                return
            end

            local is_scoped = entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_zoomLevel") == 1 or entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_zoomLevel") == 2
            local modifier = entity_get_prop(entity_get_local_player(), "m_flVelocityModifier") ~= 1

            if b_yaw then
                b_yaw = math.abs(helpers.map(b_yaw, 0, 1, -60, 60))
                b_yaw = math.max(0, math.min(57, b_yaw))
                body_yaw_solaris = b_yaw / 49
            end

            crshair["scoped"] = animate.new(crshair["scoped"], 1, 0, is_scoped)
            crshair["fake_anim"] = animate.new(crshair["fake_anim"], body_yaw_solaris, 0, contains(vis.vis_menu, "Indicators"))

            local main_text = anim.helpers:animate_text(globals_curtime(), "M O M E N T U M", r, g, b, 255)
            renderer.text(x - text_size_x / 2 + 41 + math.floor(40 * crshair["scoped"]) - 3, y + 25, 255, 255, 255, 255, "-c", nil, unpack(main_text))

            crshair["doubletap_color"] = animate.color_lerp(crshair["doubletap_color"], {r = 255, g = 255, b = 255, a = 255}, {r = 255, g = 0, b = 0, a = 255}, get(reference.rage.dt[1]) and get(reference.rage.dt[2]) and helpers.doubletap_charged())
            
            local offset = 0
            local keys = {
                [1] = {
                    ["condition"] = get(reference.rage.dt[1]) and get(reference.rage.dt[2]),
                    ["text"] = "DT",
                    ["color"] = { crshair["doubletap_color"].r, crshair["doubletap_color"].g, crshair["doubletap_color"].b, 255 * crshair["alpha"] }
                },
                [3] = {
                    ["condition"] = get(antiaim.fs) and not command["fsdisabled"],
                    ["text"] = "FS",
                    ["color"] = {255, 255, 255, 255 * crshair["alpha"]}
                }
            }

            for k, items in pairs(keys) do
                local flags = "c-"
                local text_width, text_height = renderer.measure_text(flags, items["text"])
                local key = items["condition"] and 1 or 0

                crshair["values"][k] = animate.new(crshair["values"][k], key)
                if k == 2 then
                    offset = offset + 0
                end

                local x, y = x - 1 + (19.6 * crshair["scoped"]), y + 35
                renderer.text(
                    x,
                    y + offset * crshair["values"][k],
                    items["color"][1],
                    items["color"][2],
                    items["color"][3],
                    items["color"][4] * crshair["values"][k],
                    flags,
                    text_width * crshair["values"][k] + 3,
                    items["text"]
                )
                offset = offset + 9 * crshair["values"][k]
            end
        end,

        watermark = function()
            command['switch'] = not command['switch']
            if not contains(vis.vis_menu, "Watermark") then return end
            local me = entity.get_local_player()
            if not entity.is_alive(me) then return end
            local datas = "momentum"
            local name123 = status.username
            local build = status.build
            local c1,c2,c3 = ui.get(vis.wat_color)
            local hex = RGBtoHEX(c1,c2,c3)
        
            text = ("\a"..hex.."%s \aFFFFFFAA|\aFFFFFFAA " ..build.. " \aFFFFFFAA|\a"..hex.." %s\aFFFFFFAA"):format(datas, name123)
            
            local h, w = 18, renderer.measure_text(nil, text)
            local x, y = client.screen_size()
            
            
            if contains(vis.vis_menu, "Watermark") then
                solus_render.container(x/2 - w/2 - 6, y - 30, w + 12, 16, c1,c2,c3, 200, 1)
                renderer.text(x/2 - w/2, y - 29, 255, 255, 255, 255, '', 0, text)
            end
        end,

        legfucker = function()
            local localplayer = entity_get_local_player()
            if not entity_is_alive(localplayer) then
                return
            end
            local m_flDuckAmount = entity_get_prop(localplayer, "m_flDuckAmount") > 0.5
            local is_dt = get(reference.rage.dt[1]) and get(reference.rage.dt[2])
            local is_os = get(reference.rage.os[1]) and get(reference.rage.os[2])
            local timing = globals.tickcount() % 69
            local lp_vel = helpers.get_velocity(entity_get_local_player())
            local b_yaw = entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60
            local side = b_yaw > 0 and 1 or -1

            if contains(misc.anim_breaker, "Legbreaker") and contains(misc.misc_menu, "Animation breakers") and not helpers.in_air(localplayer) and timing > 1 and lp_vel > 50
             then
                entity_set_prop(localplayer, "m_flPoseParameter", client_random_float(0.75, 1), 0)
                set(reference.rage.lm, client_random_int(1, 3) == 1 and "Off" or "Always slide")
            end

            if not is_dt and not is_os and not m_flDuckAmount and not contains(misc.misc_menu, "Legbreaker") then
                if vars.p_state == 2 then
                    entity_set_prop(localplayer, "m_flPoseParameter", 50 and 0.5 or 0, 14)
                elseif vars.p_state == 4 then
                    entity_set_prop(localplayer, "m_flPoseParameter", 5 and 50 * 0.01 or 0, 10)
                else
                    entity_set_prop(localplayer, "m_flPoseParameter", 5 and 0.8 or 0, 8)
                end
            end
        end,

        stored_paint = function()
            visuals.watermark()

            if entity_get_local_player() == nil or not entity_is_alive(entity_get_local_player()) then
                return
            end

            visuals.render_inds()
            visuals.render_keybinds()
            visuals.legfucker()
        end,

        menuToggle = function(state, reference)
            for i, v in pairs(reference) do
                if type(v) == "table" then
                    for i2, v2 in pairs(v) do
                        ui_set_visible(v2, state)
                    end
                else
                    ui_set_visible(v, state)
                end
            end
        end,

        lua_menu = function()
            local main = get(antiaim.additions)
            local add_main = get(antiaim.additions) == "Anti-aim"
            local add_keys = get(antiaim.additions) == "Binds"

            if aa_tab then
                table_visible(menuSelectionRefs, false)
                table_visible({antiaim.tab_handle, antiaim.tab_gap}, true)
            elseif vis_tab or misc_tab or cfg_tab  then
                table_visible(menuSelectionRefs, false)
                table_visible({antiaim.tab_handle, antiaim.tab_gap}, false)
            else
                table_visible(menuSelectionRefs, true)
                table_visible({antiaim.tab_handle, antiaim.tab_gap}, false)
            end

            momentum_anim_label:callback(true, 0.5)
            
            ui_set_visible(antiaim.additions, add_main and aa_tab and not add_keys)

            if add_keys and aa_tab and not add_main then
                table_visible({antiaim.fs, antiaim.lc_break, antiaim.toggle_manual}, true)
                table_visible({antiaim.manual_left, antiaim.manual_right, antiaim.manual_forward, antiaim.manual_reset}, get(antiaim.toggle_manual))
            else
                table_visible({antiaim.manual_left, antiaim.manual_right, antiaim.manual_forward, antiaim.manual_reset, antiaim.fs, antiaim.lc_break, antiaim.toggle_manual}, false)
            end

            if aa_tab then
                ui_set_visible(antiaim.additions, true)
            else
                ui_set_visible(antiaim.additions, false)
            end

            if vis_tab then
                ui_set_visible(antiaim.additions, false)
                table_visible(vis, true)

                table_visible({vis.main_clr, vis.main_clr_l, vis.main_clr2, vis.main_clr_l2}, contains(vis.vis_menu, "Indicators"))
                table_visible({vis.bind_clr, vis.bind_multi}, contains(vis.vis_menu, "Keybinds"))
                table_visible({vis.watermark_on, vis.wat_color}, contains(vis.vis_menu, "Watermark"))

                table_visible({vis.hit_label, vis.hit_color, vis.miss_label, vis.miss_color}, contains(vis.vis_menu, "Screen logs") or contains(vis.vis_menu, "Console logs"))
            else
                table_visible(vis, false)
            end

            if misc_tab then
                table_visible(misc, true)
                if contains(misc.misc_menu, "Manipulate backtracking") then
                    ui_set_visible(misc.manipsvbt, true)
                else
                    ui_set_visible(misc.manipsvbt, false)
                end
                if contains(misc.misc_menu, "Animation breakers") then
                    ui_set_visible(misc.anim_breaker, true)
                else
                    ui_set_visible(misc.anim_breaker, false)
                end
                if contains(misc.misc_menu, "Anti-knife") then
                    ui_set_visible(misc.knife_distance, true)
                else
                    ui_set_visible(misc.knife_distance, false)
                end
                if contains(misc.misc_menu, "Anti-zeus") then
                    ui_set_visible(misc.zeus_distance, true)
                    ui_set_visible(misc.zeus_options, true)
                else
                    ui_set_visible(misc.zeus_distance, false)
                    ui_set_visible(misc.zeus_options, false)
                end
            else
                table_visible(misc, false)
            end

            ui_set_visible(antiaim.configmenu, mouse.header_index == 5)

            --table_visible({}, )

            if get(antiaim.configmenu) == "Local" and mouse.header_index == 5 then
                table_visible({antiaim.createtext, antiaim.listbox, loadbutton, updatebutton, deletebutton, refreshbutton, share}, true)
                table_visible({antiaim.publiclistbox, loadpublicbutton, updatepublicbutton, import_btn, export_btn, antiaim.updatelabel, deletepublicbutton}, false)
            elseif get(antiaim.configmenu) == "Public" and mouse.header_index == 5 then
                table_visible({antiaim.createtext, antiaim.listbox, loadbutton, updatebutton, deletebutton, refreshbutton, share, import_btn, export_btn}, false)
                table_visible({antiaim.publiclistbox, loadpublicbutton, updatepublicbutton, antiaim.updatelabel, deletepublicbutton}, true)
            elseif get(antiaim.configmenu) == "Import/export" and mouse.header_index == 5 then
                table_visible({antiaim.createtext, antiaim.listbox, loadbutton, updatebutton, deletebutton, refreshbutton, share, antiaim.publiclistbox, loadpublicbutton, updatepublicbutton, antiaim.updatelabel, deletepublicbutton}, false)
                table_visible({import_btn, export_btn}, true)
            else
                table_visible({antiaim.createtext, antiaim.listbox, loadbutton, updatebutton, deletebutton, refreshbutton, share, antiaim.publiclistbox,loadpublicbutton, updatepublicbutton, import_btn, export_btn, antiaim.updatelabel, deletepublicbutton}, false)
            end

			if get(fl_tab.advanced_fl) then 
				visuals.menuToggle(true, fl_tab)
				ui.set_visible(reference.fakelag.enablefl,false)
				ui.set_visible(reference.fakelag.fl_amount,false)
				ui.set_visible(reference.fakelag.fl_limit,false)
				ui.set_visible(reference.fakelag.fl_var,false)
				if get(fl_tab.fakelag_tab) == "Dynamic" then
					ui.set_visible(fl_tab.trigger,true)
				else
					ui.set_visible(fl_tab.trigger,false)
				end
				if get(fl_tab.fakelag_tab) == "Maximum" then
					ui.set_visible(fl_tab.triggerlimit,false)
				else
					ui.set_visible(fl_tab.triggerlimit,true)
				end
			else
				ui.set_visible(reference.fakelag.enablefl,true)
				ui.set_visible(reference.fakelag.fl_amount,true)
				ui.set_visible(reference.fakelag.fl_limit,true)
				ui.set_visible(reference.fakelag.fl_var,true)
				visuals.menuToggle(false, fl_tab)
				ui.set_visible(fl_tab.advanced_fl, true)
			end

            add_main = add_main and aa_tab

            table_visible({antiaim.aa_spacer}, add_main)
            ui_set_visible(antiaim.player_state, add_main)
            
            for i = 1, #vars.state do
                -- advanced mode visiblity
                table_visible({elements[i].mode_spacer}, add_main and get(antiaim.player_state) == vars.state[i])
                ui_set_visible(elements[i].enable_state, add_main and i ~= 1 and get(antiaim.player_state) == vars.state[i])

                if i == 1 then
                    ui_set_visible(elements[i].mode, add_main and get(antiaim.player_state) == vars.state[i])
                else
                    ui_set_visible(elements[i].mode, add_main and get(elements[i].enable_state) and get(antiaim.player_state) == vars.state[i])
                end

                local custom_show = add_main and (get(elements[i].mode) == "Advanced") and get(antiaim.player_state) == vars.state[i]
                if custom_show then
                    if i ~= 1 then
                        custom_show = custom_show and get(elements[i].enable_state)
                    end

                    ui_set_visible(elements[i].advanced.pitch, custom_show)

                    local def_state = custom_show and get(elements[i].advanced.yaw_mode) == "Default"
                    ui_set_visible(elements[i].advanced.yaw_default, def_state)
                    
                    local yaw_state = custom_show and get(elements[i].advanced.yaw_mode) ~= "Default" and get(elements[i].advanced.yaw_mode) ~= "Synced random" and get(elements[i].advanced.yaw_mode) ~= "3 way"
                    table_visible({elements[i].advanced.yaw_left, elements[i].advanced.yaw_right}, yaw_state)

                    local left_state = custom_show and get(elements[i].advanced.yaw_mode) == "Synced random"
                    table_visible({elements[i].advanced.yaw_min_left, elements[i].advanced.yaw_max_left}, left_state)

                    local right_state = custom_show and get(elements[i].advanced.yaw_mode) == "Synced random"
                    table_visible({elements[i].advanced.yaw_min_right,  elements[i].advanced.yaw_max_right}, right_state)

                    local yaw3_state = custom_show and get(elements[i].advanced.yaw_mode) == "3 way"
                    table_visible({elements[i].advanced.yaw_3_way_1, elements[i].advanced.yaw_3_way_2, elements[i].advanced.yaw_3_way_3}, yaw3_state)
                    
                    table_visible({elements[i].advanced.b_yaw, elements[i].advanced.yaw_mode, elements[i].advanced.aa_disabled, elements[i].advanced.defensive}, custom_show)

                    ui_set_visible(elements[i].advanced.b_yaw_side, custom_show and get(elements[i].advanced.b_yaw) == "Static")
                    ui_set_visible(elements[i].advanced.b_yaw_speed, custom_show and get(elements[i].advanced.b_yaw) == "Jitter")
                else
                    table_visible(elements[i].advanced, false)
                end

                -- Simple mode visiblity
                local simple_show = add_main and (get(elements[i].mode) == "Simple") and get(antiaim.player_state) == vars.state[i]
                if simple_show then
                    if i ~= 1 then
                        simple_show = simple_show and get(elements[i].enable_state)
                    end

                    ui_set_visible(elements[i].simple.pitch, simple_show)
                    
                    local yaw_state = simple_show and get(elements[i].simple.yaw_mode) ~= "Default"
                    table_visible({elements[i].simple.yaw_left, elements[i].simple.yaw_right}, yaw_state)
                    
                    table_visible({elements[i].simple.b_yaw, elements[i].simple.yaw_mode, elements[i].simple.aa_disabled}, simple_show)

                    ui_set_visible(elements[i].simple.b_yaw_side, simple_show and get(elements[i].simple.b_yaw) == "Static")
                    ui_set_visible(elements[i].simple.b_yaw_speed, simple_show and get(elements[i].simple.b_yaw) == "Jitter")
                else
                    table_visible(elements[i].simple, false)
                end
            end
        end,

        stored_paint_ui = function()
            skeet_menu(false)
            visuals.lua_menu()
        end
    }

    --- start of momentum resolver

    local options = {
        force_body_yaw = true,
        correction_active = false,
        logging = false,
    }

    local nigga = 1
    local function DICK()
        local function resolve(player)
            if contains(misc.misc_menu, "Momentum resolver") and not get(reference.rage.forcebaim) then
                if entity_is_dormant(player) or entity_get_prop(player, "m_bDormant") then
                    return
                end

                local actual_angle = math.deg(math.atan2(entity_get_prop(player, "m_angEyeAngles[1]") - entity_get_prop(player, "m_flLowerBodyYawTarget"), entity_get_prop(player, "m_angEyeAngles[0]")))
                local yesyaw = math.min(60, math.max(-60, (actual_angle * 10000)))

                plist_set(player, "Force body yaw value", yesyaw)
                plist_set(player, "Force body yaw", options.force_body_yaw)
                plist_set(player, "Correction Active", options.correction_active)

                if nigga >= 40 then
                    if options.logging then
                        client.color_log(255, 0, 0, entity_get_player_name(player) .. " has been resolved with angle: " .. yesyaw)
                        nigga = 1
                    end
                else
                    nigga = nigga + 1
                end
            else
                plist_set(player, "Force body yaw", false)
                plist_set(player, "Correction Active", true)
            end
        end

        client_set_event_callback("net_update_start", function()
            local enemies = entity_get_players(true)
            for i, enemy_ent in ipairs(enemies) do
                if enemy_ent and entity_is_alive(enemy_ent) then
                    resolve(enemy_ent)
                end
            end
        end)
    end
    DICK()

    --- end of momentum resolver

    local ref_mindmg = ui_reference("rage", "aimbot", "Minimum damage")
    local ovr_checkbox, ovr_hotkey, ovr_value = ui_reference("rage", "aimbot", "Minimum damage override")
    local client_screen_size = client_screen_size
    local renderer_text = renderer.text
    local margin, padding, flags = 18, 4, nil

    client_set_event_callback("paint", function()
        if not contains(vis.vis_menu, "Min dmg indicator") or not entity_is_alive(entity_get_local_player()) then 
            return
        end

        local sw, sh = client_screen_size()
        local text = string.format(get(reference.rage.damage))
        local x, y = sw / 2, sh - 200

        if get(ovr_checkbox) and get(ovr_hotkey) then
            local text_width, text_height = renderer.measure_text(nil, get(ovr_value))
            client.draw_text(ctx, (sw / 1.963) + text_width / 2 - margin, (sh / 2 - -2) + text_height / 2 - margin, 255, 255, 255, 255, "c", 0, get(ovr_value))
        end
    end)

    local _misc = {}
    _misc = {
        value = {
            hshit = {
                "When youre too hood to be in them Hollywood circles and youre too rich to be in that hood that birthed you.",
                "Young rich nigga straight from the hood",
                "Where the hood, where the hood, where the hood at? Have that nigga in the cut, where the wood at?",
                "Im still the same me, same clique, the same hood, I came up, my bank up, but I stack that like I aint rich.",
                "Welcome to my hood. They outside playing hopscotch, And every know this is the hot spot, Welcome to my hood.",
                "A nigga young and rich who feel like can't be touched. Forty stacks for the shades, no I can't see much.",
                "Got a main bitch and got a mistress; a couple girlfriends, I'm so hood rich.",
                "I keep it own hood, And I will never change, Never go hollywood, Let it be understood, That I'll be in the hood.",
                "4 grams in my Backwood. Millionaire nigga still keep it hood. Phantom ghost got a nigga living good.",
                "I'm gettin money catch me in yo hood dog bussin down the chickens and I did it for the hood dog.",
                "Hood niggas they die young, real niggas they die rich."
            },
        },

        hoodrichtalk = function(e)
            if contains(misc.misc_menu, "Hoodtalk") then
                local attacker_entindex = client_userid_to_entindex(e.attacker)
                local victim_entindex = client_userid_to_entindex(e.userid)
                if attacker_entindex ~= entity_get_local_player() then
                    return
                end
                if victim_entindex == entity_get_local_player() then
                    return
                end
                local sendconsole = client_exec
                local _first = _misc.value.hshit[math.random(1, #_misc.value.hshit)]
                if _first ~= nil then
                    local say = "say " .. _first
                    sendconsole(say)
                end
            end
        end
    }

    local call = function(event_name, function_name, sta)
        if sta ~= nil then
            if sta then
                client_set_event_callback(event_name, function_name)
            else
                client.unset_event_callback(event_name, function_name)
            end
        else
            client_set_event_callback(event_name, function_name)
        end
    end

    local callbacks = {}
    callbacks = {
        paint = function()
            visuals.stored_paint()
        end,
        paint_ui = function()
            visuals.stored_paint_ui()
        end,
        aim_hit = function(e)
            enemy_hurt(e)
        end,
        aim_miss = function(e)
            missed_enemy(e)
        end,
        player_death = function(e)
            _misc.hoodrichtalk(e)
        end,
        round_start = function(e)
            vars.last_press = 0
        end,
        new_map = function(e)
            command["switch"] = false
            vars.last_press = 0
        end,
        shut_down = function()
            skeet_menu(true)
            set(reference.antiaim.yaw[1], "180")
            set(reference.antiaim.yaw[2], 0)
            set(reference.antiaim.yaw_jitt[1], "Off")
            set(reference.antiaim.yaw_jitt[2], 0)
            set(reference.antiaim.body_yaw[1], "Off")
            set(reference.antiaim.body_yaw[2], 0)
            set(reference.fakelag.enablefl, true)
            ui_set_visible(reference.fakelag.enablefl, true)
            ui_set_visible(reference.fakelag.fl_amount, true)
            ui_set_visible(reference.fakelag.fl_limit, true)
            ui_set_visible(reference.fakelag.fl_var, true)
        end,
        setup_command = function(c)
            command._states(c)
            command.manip_svbt()
            command.anti_zeus()
            command.fl_adaptive(c)
            command.anti_aim_on_use(c)
            command.manualaa()
            command.freestand()
            command.aa_builder(c)
            command.anti_backstab()
            command.apply_aa()
            command.teleport()

            if ui.is_menu_open() then 
                c.in_attack = false
                c.in_attack2 = false 
            end
        end,
        pre_render = function()
            old_anim()
        end,
        fully_joined = function()
            vars.last_press = 0
            command["switch"] = false
        end,
        stored_callbacks = function()
            call("pre_render", callbacks.pre_render)
            call("shutdown", callbacks.shut_down)
            call("paint", callbacks.paint)
            call("paint_ui", callbacks.paint_ui)
            call("setup_command", callbacks.setup_command)
            call("aim_hit", callbacks.aim_hit)
            call("aim_miss", callbacks.aim_miss)
            call("player_death", callbacks.player_death)
            call("round_start", callbacks.round_start)
            call("game_newmap", callbacks.new_map)
            call("player_connect_full", callbacks.fully_joined)
        end,
        ui_set_callback(antiaim.listbox, function()
            if table.getn(configslist) == 0 then
                return
            end
            local cfgpos = get(antiaim.listbox)
            local configs = configslist
            local cfgname = configs[cfgpos + 1]
            if cfgname == nil then
                return
            end
            set(antiaim.createtext, cfgname)
        end),
        ui_set_callback(antiaim.publiclistbox, function()
            if table.getn(publicconfigslist) == 0 then
                return
            end
            local cfgpos = get(antiaim.publiclistbox)
            local configs = publicconfigstimestamplist
            local update = configs[cfgpos + 1]
            if update == nil then
                return
            end
            set(antiaim.updatelabel, "Last update: " .. format_unix_timestamp(update, true, false, 1))
        end),
    }
    callbacks.stored_callbacks()
end
main()