-- downloaded from dsc.gg/southwestcfgs

local bit = require("bit")
local ffi = require("ffi")
local vector = require("vector")
local http = require("gamesense/http")
local ent = require("gamesense/entity")
local images = require("gamesense/images")
local clipboard = require("gamesense/clipboard")

local main = function()
    local tab, container = "AA", "Anti-aimbot angles"

    local antiaim_elements = {}

    local aa_tab, misc_tab, vis_tab, cfg_tab
    local obex_data = obex_fetch and obex_fetch() or {username = "alyn", build = "private"}

    local status = {
        build = obex_data.build:lower();
        version = "recode";
        last_update = "21-Oct-23";
        username = obex_data.username:lower();
    }

    local colors = {
        main = "\a779DFDFF";
        main_rgba = { 119, 157, 253, 255 };
        main_rgb = { 119, 157, 253 };
        white = "\aFFFFFFFF";
        grey = "\aFFFFFF8D";
    }

    local clamp = function(b, c, d) return math.min(d, math.max(c, b)) end

    local dpi_scale = ui.reference("MISC", "Settings", "DPI scale")
    local gscale = tonumber(ui.get(dpi_scale):sub(1, -2)) / 100

    local gmenu_size = { default = { w = 75, h = 64 }, w = 75, h = 64, x = 6, y = 20 }

    ui.set_callback(ui.reference("MISC", "Settings", "DPI scale"), function(args)
        dpi = tonumber(ui.get(args):sub(1, 3)) * 0.01
        gmenu_size.w = gmenu_size.default.w * dpi
        gmenu_size.h = gmenu_size.default.h * dpi
    end, true)

    -- Header related
    local images_links = {
        "https://cdn.discordapp.com/attachments/1113023220673679411/1157718772266827826/Untitl.png"; -- logo
        "https://cdn.discordapp.com/attachments/1113023220673679411/1157722840347447366/iconmonstr-accessibility-1-240.png"; -- antiaim
        "https://cdn.discordapp.com/attachments/1113023220673679411/1157722840594923630/iconmonstr-gear-11-240.png"; -- misc
        "https://cdn.discordapp.com/attachments/1113023220673679411/1157722841098227743/iconmonstr-weather-114-240.png"; -- visuals
        "https://cdn.discordapp.com/attachments/1113023220673679411/1157722840854966432/iconmonstr-save-3-240.png"; -- cfg
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
        end;

        get_images = function (self, link, index)
            local db_read = database.read(link) 
            if db_read then
                self.images[index] = images.load_png(db_read)
            else
                http.get(link, function(success, response)
                    if not success or response.status ~= 200 then
                        client.delay_call(5, image_recursive)
                    else
                        self.images[index] = images.load_png(response.body)
                        database.write(link, response.body)
                    end
                end)
            end
        end;

        init = function(self)
            self.images = {}
            for i, link in pairs(images_links) do
                self:get_images(link, i)
            end
        end;

        update = function(self)
            local menu_pos = {ui.menu_position()}
            local menu_size = {ui.menu_size()}
            gscale = tonumber(ui.get(dpi_scale):sub(1, -2)) / 100

            self.height = 37.5 * gscale
            self.width = menu_size[1]

            self.x, self.y, self.w, self.h = menu_pos[1], menu_pos[2] - self.height, self.width, self.height
        end;
    }
    header:init()

    -- Mouse related funcs

    local mouse = {
        is_within = function(px, py, x, y, w, h)
            return px > x and px < x + w and py > y and py < y + h
        end;

        hover_applicable = function(self, x, y, w, h)
            return self.is_within(self.mouse_x, self.mouse_y, x, y, w, h)
        end;

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
        end;

        init = function(self)
            self.got_click, self.off_click = false, false
            self.click_x, self.click_y, self.mouse_x, self.mouse_y = 0, 0, 0, 0
            self.header_index = database.read("header_index") or 1

            aa_tab   = self.header_index == 2
            misc_tab = self.header_index == 3
            vis_tab  = self.header_index == 4
            cfg_tab  = self.header_index == 5
        end;

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
        end;
    }
    mouse:init()

    -- Standalone menu alpha calcu-malator
    local menu_key = {ui.get(ui.reference("MISC", "Settings", "Menu key"))}
    function get_menu_alpha()local a=ui.is_menu_open()local b=0;if a~=last_state then draw_swap=globals.curtime()last_state=a end;local c=0.07;if not ignore_next and client.key_state(menu_key[3])then is_closing=true else if not client.key_state(menu_key[3])then ignore_next=false end end;local d=state;local e;if ui.is_menu_open()then if is_closing then state="closed"e=false else state="open"e=true end else is_closing=false;e=false;ignore_next=true;state="closed"end;if d~=state then swap_time=globals.curtime()end;b=clamp((swap_time+c-globals.curtime())/c,0,1)b=(e and a and 1-b or b)*255;return b end

    local m1_down = false
    local skeet_selected_tab = 0

    local check_skeet_tab = function()
        local pos = { ui.menu_position() }
        local m_pos = { ui.mouse_position() }

        for i = 1, 9 do
            local Offset = { gmenu_size.x, gmenu_size.y + gmenu_size.h * (i - 1) }
            if m_pos[1] >= pos[1] + Offset[1] and m_pos[1] <= pos[1] + gmenu_size.w + Offset[1] and m_pos[2] >= pos[2] + Offset[2] and m_pos[2] <= pos[2] + gmenu_size.h + Offset[2] then
                return i
            end
        end

        return skeet_selected_tab
    end

    local function is_aa_tab()
        if not m1_down and client.key_state(0x01) then
            m1_down = true
            skeet_selected_tab = check_skeet_tab()
        end

        if not client.key_state(0x01) then
            m1_down = false
        end

        return skeet_selected_tab == 2 and true or false
    end

    client.set_event_callback("paint_ui", function()  
        local alpha = get_menu_alpha()
        if alpha > 0 and ui.is_menu_open() and is_aa_tab() then 
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
                    database.write("header_index", i)

                    aa_tab   = i == 2
                    misc_tab = i == 3
                    vis_tab  = i == 4
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
                    header.images[i]:draw(ix, iy, iw, ih, colors.main_rgba[1], colors.main_rgba[2], colors.main_rgba[3], alpha * (mouse.header_index == i and 1 or (is_hovering and 0.5 or 0.2)), false, "f")
                end
            end
        end
    end)

    local reference = {
        antiaim = {
            enabled = ui.reference(tab, container, "Enabled"),
            pitch = {ui.reference(tab, container, "Pitch")},
            yawbase = ui.reference(tab, container, "Yaw base"),
            yaw = {ui.reference(tab, container, "Yaw")},
            fsbodyyaw = ui.reference(tab, container, "Freestanding body yaw"),
            edgeyaw = ui.reference(tab, container, "Edge yaw"),
            yaw_jitt = {ui.reference(tab, container, "Yaw jitter")},
            body_yaw = {ui.reference(tab, container, "Body yaw")},
            freestand = {ui.reference(tab, container, "Freestanding")},
            roll = ui.reference(tab, container, "Roll")
        },
        fakelag = {
            fl_limit = ui.reference(tab, "Fake lag", "Limit"),
            fl_amount = ui.reference(tab, "Fake lag", "Amount"),
            enablefl = ui.reference(tab, "Fake lag", "Enabled"),
            fl_var = ui.reference(tab, "Fake lag", "Variance"),
            fakelag = {ui.reference(tab, "Fake lag", "Limit")}
        },
        rage = {
            dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
            os = {ui.reference(tab, "Other", "On shot anti-aim")},
            lm = ui.reference(tab, "Other", "Leg movement"),
            fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
            safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
            forcebaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
            quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
            slow = {ui.reference(tab, "Other", "Slow motion")},
            slowwalk = ui.reference("AA", "Other", "Slow motion"),
            damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
            ping_spike = {ui.reference("MISC", "Miscellaneous", "Ping spike")},
            air_strafe = ui.reference("Misc", "Movement", "Air strafe"),
            dt_mode = ui.reference("RAGE", "Aimbot", "Double tap"),
            dt_fakelag = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit"),
            third_person = {ui.reference("VISUALS", "Effects", "Force third person (alive)")},
            menucolor = ui.reference("MISC", "Settings", "Menu color")
        }
    }

    local vars = {
        aa_states = {"Global", "Stand", "Move", "Slow", "Duck", "Duck-Move", "Air", "Air-Duck", "Fakelag"};
        p_state = 1;
        p_state_ind = 1;
        m1_time = 0;
        choked = 0;

        defensive = {
            defensive_cmd = 0;
            defensive_check = 0;
            defensive = 0;

            old_weapon = 0;
            actual_weapon = 0;
            actual_tick = 0;
            can_defensive = false;
            to_start = false;
            old_def_state = 1;
            prev_simulation_time = 0;
            def_ticks = 0;
        };
    }

    local function table_visible(tbl, state)
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                table_visible(v, state)
            elseif type(v) == "number" then
                ui.set_visible(v, state)
            end
        end
    end

    local function contains(table, value)
        if table == nil then
            return false
        end

        table = ui.get(table)
        for i = 0, #table do
            if table[i] == value then
                return true
            end
        end
        return false
    end

    local function rgba_to_hex(r, g, b, a)
        return bit.tohex(r, 2) .. bit.tohex(g, 2) .. bit.tohex(b, 2) .. bit.tohex(a, 2)
    end

    local anim_label = ui.new_label(tab, container, colors.main .. "starlight")
    local empty_lbl = ui.new_label(tab, container, "\n")

    local menuSelectionRefs = {
        build_label     = ui.new_label(tab, container, "Build: " .. colors.main .. status.build);
        version_label   = ui.new_label(tab, container, "Version: " .. colors.main .. status.version);
        update_label    = ui.new_label(tab, container, "Updated: " .. colors.main .. status.last_update);
    }

    local _sub = function(input, arg)
        local t = {}
        for m in string.gmatch(input, "([^" .. arg .. "]+)") do
            t[#t + 1] = string.gsub(m, "\n", "")
        end
        return t
    end

    local _string = function(arg)
        arg = ui.get(arg)
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
            table.insert(_storing.export[type(ui.get(value))], value)
        end

        if type(value) == "number" then
            table.insert(_storing.pcall, value)
        end
        return value
    end

    local antiaim = {
        tab_handle = ui.new_label(tab, container, colors.main .. "Current tab" .. colors.white .. " ~ Anti-aim");
        additions = ui.new_combobox(tab, container, "\n", "Anti-aim", "Binds");
        tab_gap = ui.new_label(tab, container, "\n");

        aa_state = ui.new_combobox(tab, container, "Anti-Aim State:", vars.aa_states);
    }

    local binds = {
        legitAAHotkey = ui.new_hotkey(tab, container, "Legit AA");
        freestand = ui.new_combobox(tab, container, "Freestanding", "Default", "Static");
        freestandHotkey = ui.new_hotkey(tab, container, "Freestand", true);
        freestanding_disablers = ui.new_multiselect("AA", "Anti-aimbot angles", "Freestanding Disablers", vars.aa_states);
    };

    local manuals = {
        enable = ui.new_combobox(tab, container, "Manuals", "Off", "Default", "Static");
        manualLeft = ui.new_hotkey(tab, container, "Manual left");
        manualRight = ui.new_hotkey(tab, container, "Manual right");
        manualForward = ui.new_hotkey(tab, container, "Manual forward");
    };

    local vis = {
        vis_menu = ui.new_multiselect(tab, container, colors.main .. "Visual features", "Indicators", "Manual indicators", "Min dmg indicator", "Console logs");

        indicators_label = ui.new_label(tab, container, "Indicators color");
        indicators_color = ui.new_color_picker(tab, container, "Indicators color", unpack(colors.main_rgba));
    }

    local misc = {
        misc_menu = ui.new_multiselect(tab, container, colors.main .. "Misc features", "Fast ladder", "Fix osaa", "Manipulate backtracking", "Animation breakers", "Safe-knife", "Anti-knife", "Anti-zeus", "Kill Say");
        fastLadder = ui.new_multiselect(tab, container, "Fast ladder", "Ascending", "Descending");
        manipsvbt = ui.new_combobox(tab, container, "Backtracking options", "Game default", "Over-predict fix", "Extended optimal", "Extended");
        anim_breaker = ui.new_multiselect(tab, container, "Animation breakers", "Legbreaker", "Moonwalk", "0 pitch on land");
        zeus_options = ui.new_combobox(tab, container, "Anti-zeus options", "Pull pistol", "Pull zeus");
        zeus_distance = ui.new_slider(tab, container, "Anti-zeus radius", 0, 500, 250, true);
    }

    local config = {
        import_default = ui.new_button(tab, container, "Import Default Config", function()
            local json_str = '{"starlight":{"Move":{"wayFirst":0,"fakeYawLimit":0,"pitch":"Off","pitchSlider":0,"yawJitterLeft":0,"defensive_pitch":"Off","waySecond":0,"yawJitterRight":0,"yawLeft":0,"defensive":false,"force_defensive":false,"defensive_yaw":"Off","switchTicks":6,"yaw":"Off","yawBase":"Local view","yawStatic":0,"yawJitter":"Off","bodyYaw":"Off","yawJitterStatic":0,"bodyYawStatic":0,"enabled":false,"wayThird":0,"yawRight":0},"Duck-Move":{"wayFirst":0,"fakeYawLimit":0,"pitch":"Off","pitchSlider":0,"yawJitterLeft":0,"defensive_pitch":"Off","waySecond":0,"yawJitterRight":0,"yawLeft":0,"defensive":false,"force_defensive":false,"defensive_yaw":"Off","switchTicks":6,"yaw":"Off","yawBase":"Local view","yawStatic":0,"yawJitter":"Off","bodyYaw":"Off","yawJitterStatic":0,"bodyYawStatic":0,"enabled":false,"wayThird":0,"yawRight":0},"Stand":{"wayFirst":0,"fakeYawLimit":0,"pitch":"Off","pitchSlider":0,"yawJitterLeft":0,"defensive_pitch":"Off","waySecond":0,"yawJitterRight":0,"yawLeft":0,"defensive":false,"force_defensive":false,"defensive_yaw":"Off","switchTicks":6,"yaw":"Off","yawBase":"Local view","yawStatic":0,"yawJitter":"Off","bodyYaw":"Off","yawJitterStatic":0,"bodyYawStatic":0,"enabled":false,"wayThird":0,"yawRight":0},"Fakelag":{"wayFirst":0,"fakeYawLimit":0,"pitch":"Off","pitchSlider":0,"yawJitterLeft":0,"defensive_pitch":"Off","waySecond":0,"yawJitterRight":0,"yawLeft":0,"defensive":false,"force_defensive":false,"defensive_yaw":"Off","switchTicks":6,"yaw":"Off","yawBase":"Local view","yawStatic":0,"yawJitter":"Off","bodyYaw":"Off","yawJitterStatic":0,"bodyYawStatic":0,"enabled":false,"wayThird":0,"yawRight":0},"Air":{"wayFirst":0,"fakeYawLimit":0,"pitch":"Off","pitchSlider":0,"yawJitterLeft":0,"defensive_pitch":"Off","waySecond":0,"yawJitterRight":0,"yawLeft":0,"defensive":false,"force_defensive":false,"defensive_yaw":"Off","switchTicks":6,"yaw":"Off","yawBase":"Local view","yawStatic":0,"yawJitter":"Off","bodyYaw":"Off","yawJitterStatic":0,"bodyYawStatic":0,"enabled":false,"wayThird":0,"yawRight":0},"Global":{"wayFirst":0,"fakeYawLimit":12,"pitch":"Minimal","pitchSlider":0,"yawJitterLeft":-26,"defensive_pitch":"Off","waySecond":0,"yawJitterRight":28,"yawLeft":0,"defensive":false,"force_defensive":false,"defensive_yaw":"Off","switchTicks":6,"yaw":"180","yawBase":"At targets","yawStatic":0,"yawJitter":"L&R","bodyYaw":"Custom Desync","yawJitterStatic":0,"bodyYawStatic":0,"enabled":true,"wayThird":0,"yawRight":0},"Air-Duck":{"wayFirst":0,"fakeYawLimit":0,"pitch":"Off","pitchSlider":0,"yawJitterLeft":0,"defensive_pitch":"Off","waySecond":0,"yawJitterRight":0,"yawLeft":0,"defensive":false,"force_defensive":false,"defensive_yaw":"Off","switchTicks":6,"yaw":"Off","yawBase":"Local view","yawStatic":0,"yawJitter":"Off","bodyYaw":"Off","yawJitterStatic":0,"bodyYawStatic":0,"enabled":false,"wayThird":0,"yawRight":0},"Duck":{"wayFirst":0,"fakeYawLimit":0,"pitch":"Off","pitchSlider":0,"yawJitterLeft":0,"defensive_pitch":"Off","waySecond":0,"yawJitterRight":0,"yawLeft":0,"defensive":false,"force_defensive":false,"defensive_yaw":"Off","switchTicks":6,"yaw":"Off","yawBase":"Local view","yawStatic":0,"yawJitter":"Off","bodyYaw":"Off","yawJitterStatic":0,"bodyYawStatic":0,"enabled":false,"wayThird":0,"yawRight":0},"Slow":{"wayFirst":0,"fakeYawLimit":0,"pitch":"Off","pitchSlider":0,"yawJitterLeft":0,"defensive_pitch":"Off","waySecond":0,"yawJitterRight":0,"yawLeft":0,"defensive":false,"force_defensive":false,"defensive_yaw":"Off","switchTicks":6,"yaw":"Off","yawBase":"Local view","yawStatic":0,"yawJitter":"Off","bodyYaw":"Off","yawJitterStatic":0,"bodyYawStatic":0,"enabled":false,"wayThird":0,"yawRight":0}}}'
            local imported_data = json.parse(json_str)
        
            if imported_data and imported_data.starlight then
                for i = 1, #vars.aa_states do
                    local state_name = vars.aa_states[i]
                    local imported_state = imported_data.starlight[state_name]
        
                    if imported_state then
                        for key, item in pairs(antiaim_elements[i]) do
                            if imported_state[key] ~= nil then
                                ui.set(item, imported_state[key])
                            end
                        end
                    end
                end
            end
        end);

        import = ui.new_button(tab, container, "Import From Clipboard", function()
            local json_str = clipboard.get()
            local imported_data = json.parse(json_str)
        
            if imported_data and imported_data.starlight then
                for i = 1, #vars.aa_states do
                    local state_name = vars.aa_states[i]
                    local imported_state = imported_data.starlight[state_name]
        
                    if imported_state then
                        for key, item in pairs(antiaim_elements[i]) do
                            if imported_state[key] ~= nil then
                                ui.set(item, imported_state[key])
                            end
                        end
                    end
                end
            end
        end);
        
        export = ui.new_button(tab, container, "Export To Clipboard", function()
            local antiaim_elements_export = {}
        
            for i = 1, #vars.aa_states do
                local state_name = vars.aa_states[i]
                antiaim_elements_export[state_name] = {}
        
                for key, item in pairs(antiaim_elements[i]) do
                    antiaim_elements_export[state_name][key] = ui.get(item)
                end
            end
        
            local json_str = json.stringify({ starlight = antiaim_elements_export })
            clipboard.set(json_str)
        end);
    }

    for i = 1, #vars.aa_states do
        local str = colors.main .. vars.aa_states[i] .. colors.white

		antiaim_elements[i] = {
            enabled = store(ui.new_checkbox(tab, container, str .. " | Enable"));

            pitch = store(ui.new_combobox(tab, container, str .. " | Pitch", "Off", "Zero", "Up", "Down", "Minimal", "Random", "Custom"));
            pitchSlider = store(ui.new_slider(tab, container, "\nPitch" .. vars.aa_states[i], -89, 89, 0, true, "°", 1));

            yawBase = store(ui.new_combobox(tab, container, str .. " | Yaw Base", "Local view", "At targets"));
            yaw = store(ui.new_combobox(tab, container, str .. " | Yaw", "Off", "180", "180 Z", "Spin", "Slow Jitter", "Delay Jitter", "L&R"));
            yawStatic = store(ui.new_slider(tab, container, "\nYaw" .. vars.aa_states[i], -180, 180, 0, true, "°", 1));
            yawLeft = store(ui.new_slider(tab, container, "Left\nYaw" .. vars.aa_states[i], -180, 180, 0, true, "°", 1));
            yawRight = store(ui.new_slider(tab, container, "Right\nYaw" .. vars.aa_states[i], -180, 180, 0, true, "°", 1));
            switchTicks = store(ui.new_slider(tab, container, "\nTicks" .. vars.aa_states[i], 1, 14, 6, 0));

            yawJitter = store(ui.new_combobox(tab, container, str .. " | Yaw Jitter", "Off", "Offset", "Center", "Skitter", "Random", "3-Way", "L&R"));
            yawJitterStatic = store(ui.new_slider(tab, container, "\nYaw Jitter" .. vars.aa_states[i], -180, 180, 0, true, "°", 1));
            yawJitterLeft = store(ui.new_slider(tab, container, "Left\nYaw Jitter" .. vars.aa_states[i], -180, 180, 0, true, "°", 1));
            yawJitterRight = store(ui.new_slider(tab, container, "Right\nYaw Jitter" .. vars.aa_states[i], -180, 180, 0, true, "°", 1));
            wayFirst = store(ui.new_slider(tab, container, "First\nYaw Jitter" .. vars.aa_states[i], -180, 180, 0, true, "°", 1));
            waySecond = store(ui.new_slider(tab, container, "Second\nYaw Jitter" .. vars.aa_states[i], -180, 180, 0, true, "°", 1));
            wayThird = store(ui.new_slider(tab, container, "Third\nYaw Jitter" .. vars.aa_states[i], -180, 180, 0, true, "°", 1));

            bodyYaw = store(ui.new_combobox(tab, container, str .. " | Body Yaw", "Off", "Custom Desync", "Opposite", "Jitter", "Static"));
            bodyYawStatic = store(ui.new_slider(tab, container, "\nBody Yaw" .. vars.aa_states[i], -180, 180, 0, true, "°", 1));
            fakeYawLimit = store(ui.new_slider(tab, container, str .. " | Fake Yaw Limit", -59, 59, 0, true, "°", 1));

            defensive = store(ui.new_checkbox(tab, container, str .. " | Defensive"));
            force_defensive = store(ui.new_checkbox(tab, container, str .. " | Force Defensive"));
            defensive_pitch = store(ui.new_combobox(tab, container, str .. " | Defensive Pitch", "Off", "Zero", "Up", "Minimal", "Random"));
            defensive_yaw = store(ui.new_combobox(tab, container, str .. " | Defensive Yaw", "Off", "Spin", "Jitter"));
        }
	end

    local tab_handler = function()
        cur = ui.get(antiaim.additions)
        ui.set(antiaim.tab_handle, colors.main .. "Current tab" .. colors.grey .. " ~ " .. colors.white .. cur)
    end

    tab_handler()
    ui.set_callback(antiaim.additions, tab_handler)

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

    local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
    local enemy_hurt = function(e)
        local hgroup = hitgroup_names[e.hitgroup + 1] or "?"
        local name = string.lower(entity.get_player_name(e.target))
        local health = entity.get_prop(e.target, "m_iHealth")
        local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60)
        local chance = math.floor(e.hit_chance)
        local bt = globals.tickcount() - e.tick
        local r, g, b = 0, 255, 0

        if contains(vis.vis_menu, "Console logs") then
            client.color_log(r, g, b, "[starlight] \0")
            client.color_log(r, g, b, "Hit " .. name .. "'s " .. hgroup .. " for " .. e.damage .. " (" .. health .. "hp remaining) angle: " .. angle .. "° hc: " .. chance .. " bt: " .. bt .. "")
        end
    end

    local missed_enemy = function(e)
        local hgroup = hitgroup_names[e.hitgroup + 1] or "?"
        local name = string.lower(entity.get_player_name(e.target))
        local health = entity.get_prop(e.target, "m_iHealth")
        local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60)
        local chance = math.floor(e.hit_chance)
        local bt = globals.tickcount() - e.tick
        local r, g, b = 255, 0, 0

        if contains(vis.vis_menu, "Console logs") then
            client.color_log(r, g, b, "[starlight] \0")
            client.color_log(r, g, b, "Missed " .. name .. "'s " .. hgroup .. " due to " .. e.reason .. " (" .. health .. "hp remaining) angle: " .. angle .. "° hc: " .. chance .. " bt: " .. bt)
        end

        if e.reason ~= "?" then
            return
        end
    end

    local fade_text = function(rgba, text)
        local final_text = ""
        local curtime = globals.curtime()
        local r, g, b, a = unpack(rgba)

        for i = 1, #text do
            local color = rgba_to_hex(r, g, b, a * math.abs(1 * math.cos(2 * 3 * curtime / 4 + i * 5 / 30)))
            final_text = final_text .. "\a" .. color .. text:sub(i, i)
        end

        return final_text
    end

    local helpers = {}
    helpers = {
        get_velocity = function(player)
            local x, y, z = entity.get_prop(player, "m_vecVelocity")
            if x == nil then
                return
            end
            return math.sqrt(x * x + y * y + z * z)
        end;

        in_air = function(player)
            local flags = entity.get_prop(player, "m_fFlags")
            if bit.band(flags, 1) == 0 then
                return true
            end
            return false
        end;

        doubletap_charged = function()
            if not ui.get(reference.rage.dt[1]) or not ui.get(reference.rage.dt[2]) then
                return false
            end

            if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then
                return
            end

            local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
            if weapon == nil then
                return false
            end

            local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
            local next_ready = entity.get_prop(weapon, "m_flNextPrimaryAttack")
            if next_ready == nil then
                return
            end

            local next_primary_attack = next_ready + 0.5
            if next_attack == nil or next_primary_attack == nil then
                return false
            end
            return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
        end;
    }

    local function vec_angles(angle_x, angle_y)
        local sy = math.sin(math.rad(angle_y))
        local cy = math.cos(math.rad(angle_y))
        local sp = math.sin(math.rad(angle_x))
        local cp = math.cos(math.rad(angle_x))
        return cp * cy, cp * sy, -sp
    end

    -- @region FFI start
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
        }
        ]],
        angle3d_struct,
        vec_struct,
        angle3d_struct,
        vec_struct
    )

    local client_sig = client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85") or error("client.dll!:input not found.")
    local get_cUserCmd = ffi.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)", cUserCmd)
    local input_vtbl = ffi.typeof([[struct{uintptr_t padding[8];$ GetUserCmd;}]],get_cUserCmd)
    local input = ffi.typeof([[struct{$* vfptr;}*]], input_vtbl)
    local get_input = ffi.cast(input,ffi.cast("uintptr_t**",tonumber(ffi.cast("uintptr_t", client_sig)) + 1)[0])
    -- @region FFI end

    local function can_desync(cmd)
        if entity.get_prop(entity.get_local_player(), "m_MoveType") == 9 then
            return false
        end
        local client_weapon = entity.get_player_weapon(entity.get_local_player())
        if client_weapon == nil then
            return false
        end
        local weapon_classname = entity.get_classname(client_weapon)
        local in_use = cmd.in_use == 1
        local in_attack = cmd.in_attack == 1
        local in_attack2 = cmd.in_attack2 == 1
        if in_use then
            return false
        end
        if in_attack or in_attack2 then
            if weapon_classname:find("Grenade") then
                vars.m1_time = globals.curtime() + 0.15
            end
        end
        if vars.m1_time > globals.curtime() then
            return false
        end
        if in_attack then
            if client_weapon == nil then
                return false
            end
            if weapon_classname then
                return false
            end
            return false
        end
        return true
    end
    
    local function get_choke(cmd)
        local fl_limit = ui.get(reference.fakelag.fl_limit)
        local fl_p = fl_limit % 2 == 1
        local chokedcommands = cmd.chokedcommands
        local cmd_p = chokedcommands % 2 == 0
        local doubletap_ref = ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2])
        local osaa_ref = ui.get(reference.rage.os[1]) and ui.get(reference.rage.os[2])
        local fd_ref = ui.get(reference.rage.fakeduck)
        local velocity = helpers.get_velocity(entity.get_local_player())
        if doubletap_ref then
            if vars.choked > 2 then
                if cmd.chokedcommands >= 0 then
                    cmd_p = false
                end
            end
        end
        vars.choked = cmd.chokedcommands
        if vars.dt_state ~= doubletap_ref then
            vars.doubletap_time = globals.curtime() + 0.25
        end
        if not doubletap_ref and not osaa_ref and not cmd.no_choke or fd_ref then
            if not fl_p then
                if vars.doubletap_time > globals.curtime() then
                    if cmd.chokedcommands >= 0 and cmd.chokedcommands < fl_limit then
                        cmd_p = chokedcommands % 2 == 0
                    else
                        cmd_p = chokedcommands % 2 == 1
                    end
                else
                    cmd_p = chokedcommands % 2 == 1
                end
            end
        end
        vars.dt_state = doubletap_ref
        return cmd_p
    end

    local function apply_desync(cmd, fake)
        local usrcmd = get_input.vfptr.GetUserCmd(ffi.cast("uintptr_t", get_input), 0, cmd.command_number)
        cmd.allow_send_packet = false

        local pitch, yaw = client.camera_angles()

        local can_desync = can_desync(cmd)
        local is_choke = get_choke(cmd)

        ui.set(reference.antiaim.body_yaw[1], is_choke and "Static" or "Off")
        if cmd.chokedcommands == 0 then
            vars.yaw = (yaw + 180) - fake*2;
        end

        if can_desync then
            if not usrcmd.hasbeenpredicted then
                if is_choke then
                    cmd.yaw = vars.yaw;
                end
            end
        end
    end

    -- defensive funcs
    local defensive_run = function(cmd)
        vars.defensive.defensive_cmd = cmd.command_number
    end

    local defensive_setup = function(cmd)
        if cmd.command_number == vars.defensive.defensive_cmd then
            local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
            vars.defensive.defensive = math.abs(tickbase -  vars.defensive.defensive_check)
            vars.defensive.defensive_check = math.max(tickbase, vars.defensive.defensive_check or 0)
            vars.defensive.defensive_cmd = 0
        end
    end

    local sim_diff = function() 
        local local_player = entity.get_local_player()
        if not local_player or not entity.is_alive(local_player) then
            return 0
        end
        local current_simulation_time = math.floor(0.5 + (entity.get_prop(entity.get_local_player(), "m_flSimulationTime") / globals.tickinterval())) 
        local diff = current_simulation_time - vars.defensive.prev_simulation_time
        vars.defensive.prev_simulation_time = current_simulation_time
        return diff
    end

    local can_defensive = function(cmd)
        vars.defensive.old_weapon = vars.defensive.actual_weapon
        vars.defensive.actual_weapon = entity.get_player_weapon(entity.get_local_player())

        if vars.defensive.old_weapon ~= vars.defensive.actual_weapon then
            vars.defensive.to_start = true
        end

        if entity.get_player_weapon(entity.get_local_player()) ~=vars.defensive.old_weapon then
            vars.defensive.actual_tick = 0
            vars.defensive.to_start = true
        end

        if vars.defensive.to_start == true and vars.defensive.actual_tick < 100 then
            vars.defensive.actual_tick = vars.defensive.actual_tick + 1
        elseif vars.defensive.actual_tick >= 100 then
            vars.defensive.actual_tick = 0
            vars.defensive.to_start = false
        end

        vars.defensive.old_weapon = entity.get_player_weapon(entity.get_local_player())

        if vars.defensive.can_defensive then
            if ui.get(antiaim_elements[vars.defensive.old_def_state].defensive) ~= ui.get(antiaim_elements[vars.p_state].defensive) then
                vars.defensive.can_defensive = false
            end
        end

        vars.defensive.old_def_state = vars.p_state

        if vars.defensive.can_defensive then
            vars.defensive.def_ticks = 27
            vars.defensive.can_defensive = false
        end

        if vars.defensive.def_ticks > 0 then
            vars.defensive.def_ticks = vars.defensive.def_ticks - 1
        else
            vars.defensive.can_defensive = false
        end

        if vars.defensive.to_start == true then 
            return false
        end

        if (ui.get(reference.rage.dt[2]) or ui.get(reference.rage.os[2])) then
            if vars.defensive.def_ticks > 0 or cmd.force_defensive == true then
                return true
            end
        else
            return false
        end
    end

    local command = {}
    command = {
        counter = 0;
        switch = false;
        switch2 = false;

        aa = {
            ignore = false;
            manualAA= 0;
            input = 0;
        };

        ground_ticks = 1;
        end_time = 0;
        on_ground = 0;
        fsdisabled = false;

        manual = {
            back_dir = true;
            left_dir = false;
            right_dir = false;
            forward_dir = false;
        };

        manip_svbt = function()
            if contains(misc.misc_menu, "Manipulate backtracking") then
                if ui.get(misc.manipsvbt) == "Game default" then
                    client.set_cvar("sv_maxunlag", 0.2)
                end
                if ui.get(misc.manipsvbt) == "Over-predict fix" then
                    client.set_cvar("sv_maxunlag", 0.19)
                end
                if ui.get(misc.manipsvbt) == "Extended optimal" then
                    client.set_cvar("sv_maxunlag", 0.3)
                end
                if ui.get(misc.manipsvbt) == "Extended" then
                    client.set_cvar("sv_maxunlag", 1)
                end
            end

            if not contains(misc.misc_menu, "Manipulate backtracking") then
                client.set_cvar("sv_maxunlag", 0.2)
            end
        end;

        anti_zeus = function()
            local get_distance = function(x1, y1, z1, x2, y2, z2)
                return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
            end

            if contains(misc.misc_menu, "Anti-zeus") then
                local players = entity.get_players(true)
                local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
                for i = 1, #players do
                    local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
                    local distance = get_distance(lx, ly, lz, x, y, z)
                    local weapon = entity.get_player_weapon(players[i])
                    local selfweapon = entity.get_player_weapon(entity.get_local_player())

                    if entity.get_classname(weapon) == "CWeaponTaser" and distance <= ui.get(misc.zeus_distance) then
                        if ui.get(misc.zeus_options) == "Pull pistol" then
                            client.exec("slot2")
                        elseif
                            ui.get(misc.zeus_options) == "Pull zeus" and entity.get_classname(selfweapon) ~= "CWeaponTaser"
                         then
                            client.exec("slot3;")
                        end
                    end
                end
            end
        end;

        _states = function(c)
            local localPlayer = entity.get_local_player()

            if not localPlayer  or not entity.is_alive(localPlayer) then return end
            local flags = entity.get_prop(localPlayer, "m_fFlags")
            local onground = bit.band(flags, 1) ~= 0 and c.in_jump == 0
            local velocity = vector(entity.get_prop(localPlayer, "m_vecVelocity"))
            local pStill = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2) < 5

            local isSlow = ui.get(reference.rage.slow[1]) and ui.get(reference.rage.slow[2])
            local isOs = ui.get(reference.rage.os[1]) and ui.get(reference.rage.os[2])
            local isFd = ui.get(reference.rage.fakeduck)
            local isDt = ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2])
            local isFl = ui.get(reference.fakelag.enablefl)

            vars.p_state = 1 -- global
            vars.p_state_ind = 1 -- global

            if pStill then vars.p_state = 2; vars.p_state_ind = 2; end -- standing
            if not pStill then vars.p_state = 3; vars.p_state_ind = 3; end -- moving
            if isSlow then vars.p_state = 4; vars.p_state_ind = 4; end -- slowwalking
            if entity.get_prop(localPlayer, "m_flDuckAmount") > 0.1 then vars.p_state = 5; vars.p_state_ind = 5; end -- crouching
            if not pStill and entity.get_prop(localPlayer, "m_flDuckAmount") > 0.1 then vars.p_state = 6; vars.p_state_ind = 6; end -- crouch-moving
            if not onground then vars.p_state = 7; vars.p_state_ind = 7; end -- air
            if not onground and entity.get_prop(localPlayer, "m_flDuckAmount") > 0.1 then vars.p_state = 8; vars.p_state_ind = 8; end -- air-crouching

            if ui.get(antiaim_elements[9].enabled) and isDt == false and isOs == false and isFl == true then
                vars.p_state = 9; -- fakelag
            end

            if isDt == false and isOs == false and isFl == true then
                vars.p_state_ind = 9; -- fakelag
            end

            if ui.get(antiaim_elements[vars.p_state].enabled) == false and vars.p_state ~= 1 then
                vars.p_state = 1 -- global
            end
        end;

        run_aa = function(cmd)
            if cmd.chokedcommands == 0 then
                command.counter = command.counter + 1
            end

            if command.counter >= 8 then
                command.counter = 0
            end

            if globals.tickcount() % ui.get(antiaim_elements[vars.p_state].switchTicks) == 1 then
                command.switch = not command.switch
            end

            if globals.tickcount() % 6 == 1 then
                command.switch2 = not command.switch2
            end

            if not ui.get(reference.antiaim.enabled) then
                ui.set(reference.antiaim.enabled, true)
            end

            local isOs = ui.get(reference.rage.os[1]) and ui.get(reference.rage.os[2])
            local isFd = ui.get(reference.rage.fakeduck)
            local isDt = ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2])

            -- apply antiaim set
            local localPlayer = entity.get_local_player()
            local bodyYaw = entity.get_prop(localPlayer, "m_flPoseParameter", 11) * 120 - 60
            local side = bodyYaw > 0 and 1 or -1

            -- manual aa
            if ui.get(manuals.enable) ~= "Off" then
                ui.set(manuals.manualLeft, "On hotkey")
                ui.set(manuals.manualRight, "On hotkey")
                ui.set(manuals.manualForward, "On hotkey")
                if command.aa.input + 0.22 < globals.curtime() then
                    if command.aa.manualAA == 0 then
                        if ui.get(manuals.manualLeft) then
                            command.aa.manualAA = 1
                            command.aa.input = globals.curtime()
                        elseif ui.get(manuals.manualRight) then
                            command.aa.manualAA = 2
                            command.aa.input = globals.curtime()
                        elseif ui.get(manuals.manualForward) then
                            command.aa.manualAA = 3
                            command.aa.input = globals.curtime()
                        end
                    elseif command.aa.manualAA == 1 then
                        if ui.get(manuals.manualRight) then
                            command.aa.manualAA = 2
                            command.aa.input = globals.curtime()
                        elseif ui.get(manuals.manualForward) then
                            command.aa.manualAA = 3
                            command.aa.input = globals.curtime()
                        elseif ui.get(manuals.manualLeft) then
                            command.aa.manualAA = 0
                            command.aa.input = globals.curtime()
                        end
                    elseif command.aa.manualAA == 2 then
                        if ui.get(manuals.manualLeft) then
                            command.aa.manualAA = 1
                            command.aa.input = globals.curtime()
                        elseif ui.get(manuals.manualForward) then
                            command.aa.manualAA = 3
                            command.aa.input = globals.curtime()
                        elseif ui.get(manuals.manualRight) then
                            command.aa.manualAA = 0
                            command.aa.input = globals.curtime()
                        end
                    elseif command.aa.manualAA == 3 then
                        if ui.get(manuals.manualForward) then
                            command.aa.manualAA = 0
                            command.aa.input = globals.curtime()
                        elseif ui.get(manuals.manualLeft) then
                            command.aa.manualAA = 1
                            command.aa.input = globals.curtime()
                        elseif ui.get(manuals.manualRight) then
                            command.aa.manualAA = 2
                            command.aa.input = globals.curtime()
                        end
                    end
                end
                if command.aa.manualAA == 1 or command.aa.manualAA == 2 or command.aa.manualAA == 3 then
                    command.aa.ignore = true

                    if ui.get(manuals.enable) == "Static" then
                        ui.set(reference.antiaim.yaw_jitt[1], "Off")
                        ui.set(reference.antiaim.yaw_jitt[2], 0)
                        ui.set(reference.antiaim.body_yaw[1], "Static")
                        ui.set(reference.antiaim.body_yaw[2], 180)

                        if command.aa.manualAA == 1 then
                            ui.set(reference.antiaim.yawbase, "local view")
                            ui.set(reference.antiaim.yaw[1], "180")
                            ui.set(reference.antiaim.yaw[2], -90)
                        elseif command.aa.manualAA == 2 then
                            ui.set(reference.antiaim.yawbase, "local view")
                            ui.set(reference.antiaim.yaw[1], "180")
                            ui.set(reference.antiaim.yaw[2], 90)
                        elseif command.aa.manualAA == 3 then
                            ui.set(reference.antiaim.yawbase, "local view")
                            ui.set(reference.antiaim.yaw[1], "180")
                            ui.set(reference.antiaim.yaw[2], 180)
                        end
                    elseif ui.get(manuals.enable) == "Default" and ui.get(antiaim_elements[vars.p_state].enabled) then
                        if ui.get(antiaim_elements[vars.p_state].yawJitter) == "3-Way" then
                            ui.set(reference.antiaim.yaw_jitt[1], "Center")
                            local ways = {
                                ui.get(antiaim_elements[vars.p_state].wayFirst),
                                ui.get(antiaim_elements[vars.p_state].waySecond),
                                ui.get(antiaim_elements[vars.p_state].wayThird)
                            }
                            ui.set(reference.antiaim.yaw_jitt[2], ways[(globals.tickcount() % 3) + 1] )
                        elseif ui.get(antiaim_elements[vars.p_state].yawJitter) == "L&R" then
                            ui.set(reference.antiaim.yaw_jitt[1], "Center")
                            ui.set(reference.antiaim.yaw_jitt[2], (side == 1 and ui.get(antiaim_elements[vars.p_state].yawJitterLeft) or ui.get(antiaim_elements[vars.p_state].yawJitterRight)))
                        else
                            ui.set(reference.antiaim.yaw_jitt[1], ui.get(antiaim_elements[vars.p_state].yawJitter))
                            ui.set(reference.antiaim.yaw_jitt[2], ui.get(antiaim_elements[vars.p_state].yawJitterStatic))
                        end

                        ui.set(reference.antiaim.body_yaw[1], "Opposite")
                        ui.set(reference.antiaim.body_yaw[2], -180)

                        if command.aa.manualAA == 1 then
                            ui.set(reference.antiaim.yawbase, "local view")
                            ui.set(reference.antiaim.yaw[1], "180")
                            ui.set(reference.antiaim.yaw[2], -90)
                        elseif command.aa.manualAA == 2 then
                            ui.set(reference.antiaim.yawbase, "local view")
                            ui.set(reference.antiaim.yaw[1], "180")
                            ui.set(reference.antiaim.yaw[2], 90)
                        elseif command.aa.manualAA == 3 then
                            ui.set(reference.antiaim.yawbase, "local view")
                            ui.set(reference.antiaim.yaw[1], "180")
                            ui.set(reference.antiaim.yaw[2], 180)
                        end
                    end

                else
                    command.aa.ignore = false
                end
            else
                command.aa.ignore = false
                command.aa.manualAA= 0
                command.aa.input = 0
            end

            if not ui.get(binds.legitAAHotkey) and command.aa.ignore == false then
                if ui.get(antiaim_elements[vars.p_state].enabled) then

                    if ui.get(antiaim_elements[vars.p_state].pitch) ~= "Custom" then
                        if ui.get(antiaim_elements[vars.p_state].pitch) == "Zero" then
                            ui.set(reference.antiaim.pitch[1], "Custom")
                            ui.set(reference.antiaim.pitch[2], 0)
                        else
                            ui.set(reference.antiaim.pitch[1], ui.get(antiaim_elements[vars.p_state].pitch))
                        end
                    else
                        ui.set(reference.antiaim.pitch[1], ui.get(antiaim_elements[vars.p_state].pitch))
                        ui.set(reference.antiaim.pitch[2], ui.get(antiaim_elements[vars.p_state].pitchSlider))
                    end

                    ui.set(reference.antiaim.yawbase, ui.get(antiaim_elements[vars.p_state].yawBase))

                    if ui.get(antiaim_elements[vars.p_state].yaw) == "Slow Jitter" then
                        ui.set(reference.antiaim.yaw[1], "180")
                        ui.set(reference.antiaim.yaw[2], command.switch and ui.get(antiaim_elements[vars.p_state].yawRight) or ui.get(antiaim_elements[vars.p_state].yawLeft))
                    elseif ui.get(antiaim_elements[vars.p_state].yaw) == "Delay Jitter" then
                        ui.set(reference.antiaim.yaw[1], "180")
                        if command.counter == 0 then
                            --right
                            ui.set(reference.antiaim.yaw[2], ui.get(antiaim_elements[vars.p_state].yawRight))
                        elseif command.counter == 1 then
                            --left
                            ui.set(reference.antiaim.yaw[2], ui.get(antiaim_elements[vars.p_state].yawLeft))
                        elseif command.counter == 2 then
                            --left
                            ui.set(reference.antiaim.yaw[2], ui.get(antiaim_elements[vars.p_state].yawLeft))
                        elseif command.counter == 3 then
                            --left
                            ui.set(reference.antiaim.yaw[2], ui.get(antiaim_elements[vars.p_state].yawLeft))
                        elseif command.counter == 4 then
                            --right
                        ui.set(reference.antiaim.yaw[2], ui.get(antiaim_elements[vars.p_state].yawRight))
                        elseif command.counter == 5 then
                            --left
                            ui.set(reference.antiaim.yaw[2], ui.get(antiaim_elements[vars.p_state].yawLeft))
                        elseif command.counter == 6 then
                            --right
                        ui.set(reference.antiaim.yaw[2], ui.get(antiaim_elements[vars.p_state].yawRight))
                        elseif command.counter == 7 then
                            --right
                        ui.set(reference.antiaim.yaw[2], ui.get(antiaim_elements[vars.p_state].yawRight))
                        end

                    elseif ui.get(antiaim_elements[vars.p_state].yaw) == "L&R" then
                        ui.set(reference.antiaim.yaw[1], "180")
                        ui.set(reference.antiaim.yaw[2],(side == 1 and ui.get(antiaim_elements[vars.p_state].yawLeft) or ui.get(antiaim_elements[vars.p_state].yawRight)))
                    else
                        ui.set(reference.antiaim.yaw[1], ui.get(antiaim_elements[vars.p_state].yaw))
                        ui.set(reference.antiaim.yaw[2], ui.get(antiaim_elements[vars.p_state].yawStatic))
                    end


                    if ui.get(antiaim_elements[vars.p_state].yawJitter) == "3-Way" then
                        ui.set(reference.antiaim.yaw_jitt[1], "Center")
                        local ways = {
                            ui.get(antiaim_elements[vars.p_state].wayFirst),
                            ui.get(antiaim_elements[vars.p_state].waySecond),
                            ui.get(antiaim_elements[vars.p_state].wayThird)
                        }

                        ui.set(reference.antiaim.yaw_jitt[2], ways[(globals.tickcount() % 3) + 1] )
                    elseif ui.get(antiaim_elements[vars.p_state].yawJitter) == "L&R" then 
                        ui.set(reference.antiaim.yaw_jitt[1], "Center")
                        ui.set(reference.antiaim.yaw_jitt[2], (side == 1 and ui.get(antiaim_elements[vars.p_state].yawJitterLeft) or ui.get(antiaim_elements[vars.p_state].yawJitterRight)))
                    else
                        ui.set(reference.antiaim.yaw_jitt[1], ui.get(antiaim_elements[vars.p_state].yawJitter))
                        ui.set(reference.antiaim.yaw_jitt[2], ui.get(antiaim_elements[vars.p_state].yawJitterStatic))
                    end

                    if ui.get(antiaim_elements[vars.p_state].bodyYaw) == "Custom Desync" then
                        ui.set(reference.antiaim.body_yaw[1], "Opposite")
                        apply_desync(cmd, ui.get(antiaim_elements[vars.p_state].fakeYawLimit))
                    else
                        ui.set(reference.antiaim.body_yaw[1], ui.get(antiaim_elements[vars.p_state].bodyYaw))
                    end

                    ui.set(reference.antiaim.body_yaw[2], (ui.get(antiaim_elements[vars.p_state].bodyYawStatic)))
                    ui.set(reference.antiaim.fsbodyyaw, false)

                    -- defensive
                    if ui.get(antiaim_elements[vars.p_state].defensive) and ui.get(antiaim_elements[vars.p_state].force_defensive) then
                        if ui.get(reference.rage.dt[2]) or ui.get(reference.rage.os[2]) then
                            cmd.force_defensive = true
                            if cmd.force_defensive then
                                if globals.tickcount() % 10 <= 2 then
                                    cmd.force_defensive = false
                                end
                            end
                        end
                    end

                    if ui.get(antiaim_elements[vars.p_state].defensive) and can_defensive(cmd) then
                        cmd.no_choke = 1;
                        cmd.quick_stop = 1;

                        -- pitch
                        if ui.get(antiaim_elements[vars.p_state].defensive_pitch) ~= "Off" then
                            if ui.get(antiaim_elements[vars.p_state].defensive_pitch) == "Zero" then
                                ui.set(reference.antiaim.pitch[1], "Custom")
                                ui.set(reference.antiaim.pitch[2], 0)
                            else
                                ui.set(reference.antiaim.pitch[1], ui.get(antiaim_elements[vars.p_state].defensive_pitch))
                            end
                        end

                        -- yaw
                        if ui.get(antiaim_elements[vars.p_state].defensive_yaw) ~= "Off" then
                            if ui.get(antiaim_elements[vars.p_state].defensive_yaw) == "Spin" then
                                ui.set(reference.antiaim.yaw[1], "Spin")
                                ui.set(reference.antiaim.yaw[2], command.switch2 and 90 or -45)
                            elseif ui.get(antiaim_elements[vars.p_state].defensive_yaw) == "Jitter" then
                                ui.set(reference.antiaim.yaw[1], "180")
                                ui.set(reference.antiaim.yaw[2], command.switch2 and 90 or -90)
                                ui.set(reference.antiaim.body_yaw[1], "Jitter")
                                ui.set(reference.antiaim.body_yaw[2], 1)
                            end
                        end
                    end

                elseif not ui.get(antiaim_elements[vars.p_state].enabled) then
                    ui.set(reference.antiaim.pitch[1], "Off")
                    ui.set(reference.antiaim.yawbase, "Local view")
                    ui.set(reference.antiaim.yaw[1], "Off")
                    ui.set(reference.antiaim.yaw[2], 0)
                    ui.set(reference.antiaim.yaw_jitt[1], "Off")
                    ui.set(reference.antiaim.yaw_jitt[2], 0)
                    ui.set(reference.antiaim.body_yaw[1], "Off")
                    ui.set(reference.antiaim.body_yaw[2], 0)
                    ui.set(reference.antiaim.fsbodyyaw, false)
                    ui.set(reference.antiaim.edgeyaw, false)
                    ui.set(reference.antiaim.roll, 0)
                end
            elseif ui.get(binds.legitAAHotkey) and command.aa.ignore == false then
                if entity.get_classname(entity.get_player_weapon(localPlayer)) == "CC4" then 
                    return
                end

                local should_disable = false
                local planted_bomb = entity.get_all("CPlantedC4")[1]

                if planted_bomb ~= nil then
                    bomb_distance = vector(entity.get_origin(localPlayer)):dist(vector(entity.get_origin(planted_bomb)))

                    if bomb_distance <= 64 and entity.get_prop(localPlayer, "m_iTeamNum") == 3 then
                        should_disable = true
                    end
                end

                local pitch, yaw = client.camera_angles()
                local direct_vec = vector(vec_angles(pitch, yaw))

                local eye_pos = vector(client.eye_position())
                local fraction, ent = client.trace_line(localPlayer, eye_pos.x, eye_pos.y, eye_pos.z, eye_pos.x + (direct_vec.x * 8192), eye_pos.y + (direct_vec.y * 8192), eye_pos.z + (direct_vec.z * 8192))

                if ent ~= nil and ent ~= -1 then
                    if entity.get_classname(ent) == "CPropDoorRotating" then
                        should_disable = true
                    elseif entity.get_classname(ent) == "CHostage" then
                        should_disable = true
                    end
                end

                if should_disable ~= true then
                    ui.set(reference.antiaim.pitch[1], "Off")
                    ui.set(reference.antiaim.yawbase, "Local view")
                    ui.set(reference.antiaim.yaw[1], "Off")
                    ui.set(reference.antiaim.yaw[2], 0)
                    ui.set(reference.antiaim.yaw_jitt[1], "Off")
                    ui.set(reference.antiaim.yaw_jitt[2], 0)
                    ui.set(reference.antiaim.body_yaw[1], "Opposite")
                    ui.set(reference.antiaim.fsbodyyaw, false)
                    ui.set(reference.antiaim.edgeyaw, false)
                    ui.set(reference.antiaim.roll, 0)

                    cmd.in_use = 0
                    cmd.roll = 0
                end
            end

            -- fix osaa
            if contains(misc.misc_menu, "Fix osaa") then
                if isOs and not isDt and not isFd then
                    if not hsSaved then
                        hsValue = ui.get(reference.fakelag.fakelag[1])
                        hsSaved = true
                    end
                    ui.set(reference.fakelag.fakelag[1], 1)
                elseif hsSaved then
                    ui.set(reference.fakelag.fakelag[1], hsValue)
                    hsSaved = false
                end
            end

            -- Avoid backstab
            if contains(misc.misc_menu, "Anti-knife") then
                local players = entity.get_players(true)
                for i=1, #players do
                    local distance = vector(entity.get_origin(localPlayer)):dist(vector(entity.get_origin(players[i])))
                    local weapon = entity.get_player_weapon(players[i])
                    if entity.get_classname(weapon) == "CKnife" and distance <= 250 then
                        ui.set(reference.antiaim.yaw[2], 180)
                        ui.set(reference.antiaim.pitch[1], "Off")
                    end
                end
            end

            -- freestand
            if (ui.get(binds.freestandHotkey) and ui.get(binds.freestand) and not contains(binds.freestanding_disablers, vars.aa_states[vars.p_state])) then
                if command.aa.ignore == true then
                    ui.set(reference.antiaim.freestand[2], "On hotkey")
                    return
                else
                    if ui.get(binds.freestand) == "Static" then
                        ui.set(reference.antiaim.yaw_jitt[1], "Off")
                        ui.set(reference.antiaim.body_yaw[1], "Off")
                    end
                    ui.set(reference.antiaim.freestand[2], "Always on")
                    ui.set(reference.antiaim.freestand[1], true)
                end
            else
                ui.set(reference.antiaim.freestand[1], false)
                ui.set(reference.antiaim.freestand[2], "On hotkey")
            end

            -- fast ladder
            local pitch, yaw = client.camera_angles()
            if entity.get_prop(localPlayer, "m_MoveType") == 9 then
                cmd.yaw = math.floor(cmd.yaw + 0.5)
                cmd.roll = 0

                if contains(misc.misc_menu, "Fast ladder") and contains(misc.fastLadder, "Ascending") then
                    if cmd.forwardmove > 0 then
                        if pitch < 45 then
                            cmd.pitch = 89
                            cmd.in_moveright = 1
                            cmd.in_moveleft = 0
                            cmd.in_forward = 0
                            cmd.in_back = 1
                            if cmd.sidemove == 0 then
                                cmd.yaw = cmd.yaw + 90
                            end
                            if cmd.sidemove < 0 then
                                cmd.yaw = cmd.yaw + 150
                            end
                            if cmd.sidemove > 0 then
                                cmd.yaw = cmd.yaw + 30
                            end
                        end 
                    end
                end
                if contains(misc.misc_menu, "Fast ladder") and contains(misc.fastLadder, "Descending") then
                    if cmd.forwardmove < 0 then
                        cmd.pitch = 89
                        cmd.in_moveleft = 1
                        cmd.in_moveright = 0
                        cmd.in_forward = 1
                        cmd.in_back = 0
                        if cmd.sidemove == 0 then
                            cmd.yaw = cmd.yaw + 90
                        end
                        if cmd.sidemove > 0 then
                            cmd.yaw = cmd.yaw + 150
                        end
                        if cmd.sidemove < 0 then
                            cmd.yaw = cmd.yaw + 30
                        end
                    end
                end
            end

            if contains(misc.misc_menu, "Safe-knife") and entity.get_classname(entity.get_player_weapon(localPlayer)) == "CKnife" then
                ui.set(reference.antiaim.pitch[1], "Minimal")
                ui.set(reference.antiaim.yawbase, "At targets")
                ui.set(reference.antiaim.yaw[1], "180")
                ui.set(reference.antiaim.yaw[2], 0)
                ui.set(reference.antiaim.yaw_jitt[1], "Offset")
                ui.set(reference.antiaim.yaw_jitt[2], 0)
                ui.set(reference.antiaim.body_yaw[1], "Static")
                ui.set(reference.antiaim.body_yaw[2], 0)
                ui.set(reference.antiaim.fsbodyyaw, false)
                ui.set(reference.antiaim.edgeyaw, false)
                ui.set(reference.antiaim.roll, 0)
            end
        end;
    }

    local old_anim = function()
        local localplayer = entity.get_local_player()
        if localplayer == nil then
            return
        end
        local is_sw = ui.get(reference.rage.slow[1]) and ui.get(reference.rage.slow[2])
        local bodyyaw = entity.get_prop(localplayer, "m_flPoseParameter", 11) * 120 - 60
        local side = bodyyaw > 0 and 1 or -1

        if contains(misc.anim_breaker, "0 pitch on land") and contains(misc.misc_menu, "Animation breakers") then
            local on_ground = bit.band(entity.get_prop(localplayer, "m_fFlags"), 1)

            if on_ground == 1 then
                command.ground_ticks = command.ground_ticks + 1
            else
                command.ground_ticks = 0
                command.end_time = globals.curtime() + 1
            end

            if command.ground_ticks > ui.get(reference.fakelag.fl_limit) + 1 and command.end_time > globals.curtime() then
                entity.set_prop(localplayer, "m_flPoseParameter", 0.5, 12)
            end
        end

        if not contains(misc.anim_breaker, "Moonwalk") then
            return
        end

        local me = ent.get_local_player()
		local m_fFlags = me:get_prop("m_fFlags");
		local is_onground = bit.band(m_fFlags, 1) ~= 0;

		if contains(misc.anim_breaker, "Moonwalk") and contains(misc.misc_menu, "Animation breakers") then
			ui.set(reference.rage.lm, "Never slide")
			entity.set_prop(localplayer, "m_flPoseParameter", 1, 7)
			if not is_onground then
				local my_animlayer = me:get_anim_overlay(6);
				my_animlayer.weight = 1;
				entity.set_prop(me, "m_flPoseParameter", 1, 6)
			end
		end
    end

    local lerp = function(start, _end)
        return start + (_end - start) * (globals.frametime() * 6)
    end

    local ref_mindmg = ui.reference("rage", "aimbot", "Minimum damage")
    local ovr_checkbox, ovr_hotkey, ovr_value = ui.reference("rage", "aimbot", "Minimum damage override")
    local renderer_text = renderer.text
    local margin, padding, flags = 18, 4, nil

    local visuals = {}
    visuals = {
        indicators = {
            text_anim = { 0, 0, 0, 0 };
            add_y = { 0, 0 };
            addition = 0;
        };

        render_indicators = function()
            if not entity.is_alive(entity.get_local_player()) then return end

            local w, h = client.screen_size()

            -- indicators
            if contains(vis.vis_menu, "Indicators") then
                local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1 and true or false
                local indicators_color = { ui.get(vis.indicators_color) }
                
                -- logo
                renderer.text(w / 2 + math.ceil(visuals.indicators.text_anim[1]), h / 2 + 25, 255, 255, 255, 255, "cdb", 0,
                    fade_text({indicators_color[1], indicators_color[2], indicators_color[3], indicators_color[4]}, "starlight") .. colors.white .. " recode")

                -- dt
                if ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2]) then
                    if helpers.doubletap_charged() then
                        renderer.text(w / 2 + math.ceil(visuals.indicators.text_anim[2]), h / 2 + 25 + math.ceil(visuals.indicators.add_y[1]), 0, 255, 0, 255, "cd", 0, "dt")
                    else
                        renderer.text(w / 2 + math.ceil(visuals.indicators.text_anim[2]), h / 2 + 25 + math.ceil(visuals.indicators.add_y[1]), 255, 0, 0, 255, "cd", 0, "dt")
                    end
                end

                -- hs
                if ui.get(reference.rage.os[1]) and ui.get(reference.rage.os[2]) and not ui.get(reference.rage.dt[2]) then
                    renderer.text(w / 2 + math.ceil(visuals.indicators.text_anim[3]), h / 2 + 25 + math.ceil(visuals.indicators.add_y[2]), 255, 255, 255, 255, "cd", 0, "hs")
                end

                if ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2]) then
                    visuals.indicators.addition = visuals.indicators.add_y[1]
                elseif ui.get(reference.rage.os[1]) and ui.get(reference.rage.os[2]) and not ui.get(reference.rage.dt[2]) then
                    visuals.indicators.addition = visuals.indicators.add_y[2]
                else
                    visuals.indicators.addition = lerp(visuals.indicators.addition, 0, globals.frametime() * 15)
                end

                -- state
                renderer.text(w / 2 + math.ceil(visuals.indicators.text_anim[4]), h / 2 + 35 + math.ceil(visuals.indicators.addition), 255, 255, 255, 255, "cd", 0, "'" .. vars.aa_states[vars.p_state_ind]:lower() .. "'")

                local text = { "starlight recode", "dt", "hs", "'" .. vars.aa_states[vars.p_state_ind]:lower() .. "'" }
                for i = 1, #text do
                    local measure = {
                        vector(renderer.measure_text("cdb", text[i]));
                        vector(renderer.measure_text("cd", text[i]));
                        vector(renderer.measure_text("cd", text[i]));
                        vector(renderer.measure_text("cd", text[i]));
                    }

                    visuals.indicators.text_anim[i] = lerp(visuals.indicators.text_anim[i], scoped and measure[i].x / 2 + 3 or 0, globals.frametime() * 15)

                    if i < 3 then
                        if i == 1 then
                            visuals.indicators.add_y[i] = lerp(visuals.indicators.add_y[i], (ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2])) and 10 or 0, globals.frametime() * 15)
                        else
                            local can = ui.get(reference.rage.os[1]) and ui.get(reference.rage.os[2]) and not ui.get(reference.rage.dt[2])
                            visuals.indicators.add_y[i] = lerp(visuals.indicators.add_y[i], can and 10 or 0, globals.frametime() * 15)
                        end
                    end
                end
            end

            -- minimum damage indicator
            if contains(vis.vis_menu, "Min dmg indicator") then
                local sw, sh = client.screen_size()
                local text = string.format(ui.get(reference.rage.damage))
                local x, y = sw / 2, sh - 200

                if ui.get(ovr_checkbox) and ui.get(ovr_hotkey) then
                    local text_width, text_height = renderer.measure_text(nil, ui.get(ovr_value))
                    client.draw_text(ctx, (sw / 1.963) + text_width / 2 - margin, (sh / 2 - -2) + text_height / 2 - margin, 255, 255, 255, 255, "c", 0, ui.get(ovr_value))
                else
                    local text_width, text_height = renderer.measure_text(nil, ui.get(ref_mindmg))
                    client.draw_text(ctx, (sw / 1.963) + text_width / 2 - margin, (sh / 2 - -2) + text_height / 2 - margin, 255, 255, 255, 255, "c", 0, ui.get(ref_mindmg))
                end
            end

            -- manual indicators
            if contains(vis.vis_menu, "Manual indicators") then
                renderer.text(w / 2 - 35, h / 2, 255, 255, 255, command.aa.manualAA == 1 and 255 or 100, "cb", 0, "⮜")
                renderer.text(w / 2 + 35, h / 2, 255, 255, 255, command.aa.manualAA == 2 and 255 or 100, "cb", 0, "⮞")
            end
        end;

        watermark = function()
            local r, g, b, a = ui.get(vis.indicators_color)
            local hex = RGBAtoHEX(r, g, b, a)
            local anim = fade_text({ r, g, b, a }, "s t a r l i g h t")
            local text = ("\a" .. hex .. "%s \aFFFFFFAA|\aFFFFFFAA " .. status.build .. " \aFFFFFFAA|\a" .. hex .. " %s\aFFFFFFAA"):format(anim, status.username)

            local h, w = 18, renderer.measure_text(nil, text)
            local x, y = client.screen_size()

            renderer.text(x/2 - w/2, y - 40, 255, 255, 255, 255, 'b', 0, text)
        end;

        legfucker = function()
            local localplayer = entity.get_local_player()
            if not entity.is_alive(localplayer) then
                return
            end
            local m_flDuckAmount = entity.get_prop(localplayer, "m_flDuckAmount") > 0.5
            local is_dt = ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2])
            local is_os = ui.get(reference.rage.os[1]) and ui.get(reference.rage.os[2])
            local timing = globals.tickcount() % 69
            local lp_vel = helpers.get_velocity(entity.get_local_player())
            local b_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
            local side = b_yaw > 0 and 1 or -1

            if contains(misc.anim_breaker, "Legbreaker") and contains(misc.misc_menu, "Animation breakers") and not helpers.in_air(localplayer) and timing > 1 and lp_vel > 50 then
                entity.set_prop(localplayer, "m_flPoseParameter", client.random_float(0.75, 1), 0)
                ui.set(reference.rage.lm, client.random_int(1, 3) == 1 and "Off" or "Always slide")
            end

            if not is_dt and not is_os and not m_flDuckAmount and not contains(misc.misc_menu, "Legbreaker") then
                if vars.p_state == 2 then
                    entity.set_prop(localplayer, "m_flPoseParameter", 50 and 0.5 or 0, 14)
                elseif vars.p_state == 4 then
                    entity.set_prop(localplayer, "m_flPoseParameter", 5 and 50 * 0.01 or 0, 10)
                else
                    entity.set_prop(localplayer, "m_flPoseParameter", 5 and 0.8 or 0, 8)
                end
            end
        end;

        stored_paint = function()
            visuals.watermark()
            visuals.render_indicators()
            visuals.legfucker()

            if sim_diff() <= -1 and vars.defensive.to_start == false then
                vars.defensive.can_defensive = true
            end
        end;

        menuToggle = function(state, reference)
            for i, v in pairs(reference) do
                if type(v) == "table" then
                    for i2, v2 in pairs(v) do
                        ui.set_visible(v2, state)
                    end
                else
                    ui.set_visible(v, state)
                end
            end
        end;

        lua_menu = function()
            local main = ui.get(antiaim.additions)
            local add_main = ui.get(antiaim.additions) == "Anti-aim"
            local add_keys = ui.get(antiaim.additions) == "Binds"

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

            ui.set(anim_label, fade_text(colors.main_rgba, "               starlight"));
            ui.set_visible(anim_label, true)
            
            ui.set_visible(antiaim.additions, add_main and aa_tab and not add_keys)

            if add_keys and aa_tab and not add_main then
                table_visible({binds, manuals}, true)
                table_visible({manuals.manualLeft, manuals.manualRight, manuals.manualForward}, ui.get(manuals.enable) ~= "Off")
            else
                table_visible({binds, manuals}, false)
            end

            if aa_tab then
                ui.set_visible(antiaim.additions, true)
            else
                ui.set_visible(antiaim.additions, false)
            end

            if vis_tab then
                ui.set_visible(antiaim.additions, false)
                table_visible(vis, true)

                table_visible({vis.indicators_label, vis.indicators_color}, contains(vis.vis_menu, "Indicators"))
            else
                table_visible(vis, false)
            end

            if misc_tab then
                table_visible(misc, true)
                
                if contains(misc.misc_menu, "Fast ladder") then
                    ui.set_visible(misc.fastLadder, true)
                else
                    ui.set_visible(misc.fastLadder, false)
                end

                if contains(misc.misc_menu, "Manipulate backtracking") then
                    ui.set_visible(misc.manipsvbt, true)
                else
                    ui.set_visible(misc.manipsvbt, false)
                end

                if contains(misc.misc_menu, "Animation breakers") then
                    ui.set_visible(misc.anim_breaker, true)
                else
                    ui.set_visible(misc.anim_breaker, false)
                end

                if contains(misc.misc_menu, "Anti-zeus") then
                    ui.set_visible(misc.zeus_distance, true)
                    ui.set_visible(misc.zeus_options, true)
                else
                    ui.set_visible(misc.zeus_distance, false)
                    ui.set_visible(misc.zeus_options, false)
                end
            else
                table_visible(misc, false)
            end

            if cfg_tab then
                table_visible(config, true)
            else
                table_visible(config, false)
            end

            add_main = add_main and aa_tab

            ui.set_visible(antiaim.aa_state, add_main)

            for i = 1, #vars.aa_states do
                local active = add_main and ui.get(antiaim.aa_state) == vars.aa_states[i]
                ui.set_visible(antiaim_elements[i].enabled, active)

                local enabled = ui.get(antiaim_elements[i].enabled)
                ui.set_visible(antiaim_elements[i].pitch, active and enabled)
                ui.set_visible(antiaim_elements[i].pitchSlider , active and enabled and ui.get(antiaim_elements[i].pitch) == "Custom")
                ui.set_visible(antiaim_elements[i].yawBase, active and enabled)
                ui.set_visible(antiaim_elements[i].yaw, active and enabled)
                ui.set_visible(antiaim_elements[i].yawStatic, active and enabled and ui.get(antiaim_elements[i].yaw) ~= "Off" and ui.get(antiaim_elements[i].yaw) ~= "Slow Jitter" and ui.get(antiaim_elements[i].yaw) ~= "L&R" and ui.get(antiaim_elements[i].yaw) ~= "Delay Jitter")
                ui.set_visible(antiaim_elements[i].yawLeft, active and enabled and ui.get(antiaim_elements[i].yaw) ~= "Off" and (ui.get(antiaim_elements[i].yaw) == "Slow Jitter" or ui.get(antiaim_elements[i].yaw) == "L&R" or ui.get(antiaim_elements[i].yaw) == "Delay Jitter"))
                ui.set_visible(antiaim_elements[i].yawRight, active and enabled and ui.get(antiaim_elements[i].yaw) ~= "Off" and (ui.get(antiaim_elements[i].yaw) == "Slow Jitter" or ui.get(antiaim_elements[i].yaw) == "L&R" or ui.get(antiaim_elements[i].yaw) == "Delay Jitter"))
                ui.set_visible(antiaim_elements[i].switchTicks, active and enabled and ui.get(antiaim_elements[i].yaw) == "Slow Jitter")
                ui.set_visible(antiaim_elements[i].yawJitter, active and enabled and ui.get(antiaim_elements[i].yaw) ~= "Off")
                ui.set_visible(antiaim_elements[i].wayFirst, active and enabled and ui.get(antiaim_elements[i].yaw) ~= "Off" and ui.get(antiaim_elements[i].yawJitter) == "3-Way" )
                ui.set_visible(antiaim_elements[i].waySecond, active and enabled and ui.get(antiaim_elements[i].yaw) ~= "Off" and ui.get(antiaim_elements[i].yawJitter) == "3-Way" )
                ui.set_visible(antiaim_elements[i].wayThird, active and enabled and ui.get(antiaim_elements[i].yaw) ~= "Off" and ui.get(antiaim_elements[i].yawJitter) == "3-Way" )
                ui.set_visible(antiaim_elements[i].yawJitterStatic, active and enabled and ui.get(antiaim_elements[i].yaw) ~= "Off" and ui.get(antiaim_elements[i].yawJitter) ~= "Off" and ui.get(antiaim_elements[i].yawJitter) ~= "L&R" and ui.get(antiaim_elements[i].yawJitter) ~= "3-Way")
                ui.set_visible(antiaim_elements[i].yawJitterLeft, active and enabled and ui.get(antiaim_elements[i].yaw) ~= "Off" and ui.get(antiaim_elements[i].yawJitter) == "L&R")
                ui.set_visible(antiaim_elements[i].yawJitterRight, active and enabled and ui.get(antiaim_elements[i].yaw) ~= "Off" and ui.get(antiaim_elements[i].yawJitter) == "L&R")
                ui.set_visible(antiaim_elements[i].bodyYaw, active and enabled and enabled)
                ui.set_visible(antiaim_elements[i].bodyYawStatic, active and enabled and ui.get(antiaim_elements[i].bodyYaw) ~= "Off" and ui.get(antiaim_elements[i].bodyYaw) ~= "Opposite" and ui.get(antiaim_elements[i].bodyYaw) ~= "Custom Desync")
                ui.set_visible(antiaim_elements[i].fakeYawLimit, active and enabled and ui.get(antiaim_elements[i].bodyYaw) == "Custom Desync")

                ui.set_visible(antiaim_elements[i].defensive, active and enabled)
                ui.set_visible(antiaim_elements[i].force_defensive, active and enabled and ui.get(antiaim_elements[i].defensive))
                ui.set_visible(antiaim_elements[i].defensive_pitch, active and enabled and ui.get(antiaim_elements[i].defensive))
                ui.set_visible(antiaim_elements[i].defensive_yaw, active and enabled and ui.get(antiaim_elements[i].defensive))

            end
        end;

        stored_paint_ui = function()
            skeet_menu(false)
            visuals.lua_menu()
        end;
    }

    local _misc = {}
    _misc = {
        value = {
            kill_say_msg = {
                "✧:･ﾟ✧ 𝔹𝕌𝕐 𝕄𝕐 ℂ𝕆ℕ𝔽𝕀𝔾 ✧:･ﾟ✧",
                "𝕒𝕕𝕕 𝕞𝕖 = 𝕓𝕝𝕠𝕔𝕜 ♕ ONLY ACCEPT LVL 200+",
                "never vac and you know",
                "𝕒𝕕𝕕𝕖𝕕 𝕓𝕖𝕔𝕦𝕒𝕤𝕖 𝕚 𝕨𝕒𝕟𝕥𝕖𝕕 𝕤𝕠𝕞𝕖 𝕥𝕠 𝕒𝕕𝕕 𝕝𝕖𝕧𝕖𝕝 𝕙𝕚𝕘𝕙 𝕝𝕖𝕧𝕖𝕝 𝕡𝕖𝕠𝕡𝕝𝕖𝕤 ♛ (◣◢) ♛",
                "𝓨𝓸𝓾𝓻 𝓹𝓻𝓸𝓯𝓲𝓵𝓮 𝓲𝓼 𝓫𝓮𝓲𝓷𝓰 𝓯𝓸𝓻𝓬𝓮𝓭 𝓹𝓻𝓲𝓿𝓪𝓽𝓮 𝓭𝓾𝓮 𝓽𝓸 𝓪𝓷 𝓪𝓬𝓽𝓲𝓿𝓮 𝓒𝓸𝓶𝓶𝓾𝓷𝓲𝓽𝔂 𝓑𝓪𝓷 𝓸𝓷 𝔂𝓸𝓾𝓻 𝓪𝓬𝓬𝓸𝓾𝓷𝓽.",
                "ＥＳＯＴＥＲＩＫ Ｉ ＷＩＬＬ ＳＥＥ ＹＯＵ ＩＮ ＨＥＬＬ (◣◢)",
                "how im can cheating? i is lvl 130 own all bronze medal? u is dumb dog)))",
                "dont wake the beast inside me, you dont want to see my 4.1 avg kd hunter",
                "𝕡𝕦𝕥𝕚𝕟 𝕙𝕚𝕣𝕖 𝕞𝕖 𝕗𝕠𝕣 𝕨𝕒𝕣, 𝕨𝕙𝕖𝕟 𝕟𝕒𝕥𝕠 𝕤𝕖𝕖𝕤 𝕞𝕪 𝕔𝕗𝕘, 𝕥𝕙𝕖𝕪 𝕒𝕣𝕖 𝕣𝕢𝕚𝕟𝕘.",
                "next time its win (◣◢)",
                "me try harding for nova 1 (◣◢)",
                "cooldowns are not on my side (◣◢)",
                "can't escape (◣◢)",
                "sorry i dont speak to nns im busy @ hvhacadamy majoring in 1 ways",
                "whats your networth? why dont you spend $2k on steam levels NN? xaxaxaxa",
                "yo this vaccine got me feelin kinda differen上帝保佑中国共产党、习近平和武汉P4病毒学实验室",
                "ɴᴏɴᴀᴍᴇ ʟɪꜱᴛᴇɴ ᴛᴏ ᴍᴇ ! ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ ɪꜱ ɴᴏᴛ ʏᴏᴜʀ ᴘʀᴏᴘᴇʀᴛʏ. ᴅᴏɴ'ᴛ ꜰᴏʟʟᴏᴡɪɴɢ ᴍᴇ ᴏɴ ᴍʏ ꜱᴄʀᴇᴇɴꜱʜᴏᴛꜱ ! ɪ ᴅᴏɴ'ᴛ ʟɪᴋᴇ ꜱᴘʏɪɴɢ..",
                "playing csgo takes me p a i n a w a y (◣◢)",
                "欢迎使用 Gboard 剪贴板，您复制的所有文本都会保存到这里。",
                "is your uid above 1k on? (◣◢)(◣◢)(◣◢)(◣◢)(◣◢)(◣◢)(◣◢) = blocked!!!",
                "𝕖𝕧𝕖𝕣𝕪 𝕥𝕚𝕞𝕖 𝕚𝕕𝕚𝕠𝕥 𝕒𝕤𝕜 𝕞𝕖, 𝕦𝕚𝕕? 𝕒𝕟𝕕 𝕚𝕞 𝕕𝕠𝕟𝕥 𝕒𝕟𝕤𝕨𝕖𝕣, 𝕚 𝕝𝕖𝕥 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖𝕓𝕠𝕒𝕣𝕕 𝕤𝕡𝕖𝕒𝕜♛",
                "no care (◣◢)",
                "u dont talk anyways",
                "go fix",
                "new main? can buy, hvh win? dont think im can (◣◢)",
                "low iq player dont big",
                "𝕓𝕚𝕘 𝕟𝕒𝕞𝕖𝕣, 𝕚𝕞 𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦 𝕕𝕣𝕠𝕡 𝕪𝕠𝕦𝕣 𝕔𝕣𝕠𝕨𝕟, 𝕤𝕠 𝕚𝕞 𝕨𝕖𝕟𝕥 𝕡𝕚𝕥𝕔𝕙𝕕𝕠𝕨𝕟 𝕚𝕟 𝕞𝕞 𝕒𝕟𝕕 𝕡𝕚𝕔𝕜 𝕚𝕥 𝕦𝕡 𝕗𝕠𝕣 𝕪𝕠𝕦, 𝕙𝕖𝕣𝕖 𝕪𝕠𝕦 𝕘𝕠 𝕜𝕚𝕟𝕘 ♕",
                "ᴀɢᴀɪɴ ɴᴏɴᴀᴍᴇ ᴏɴ ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ. ɪ ꜱᴇᴇ ᴀɢᴀɪɴ ᴀᴄᴛɪᴠɪᴛʏ.",
                "𝕨𝕖𝕝𝕔𝕠𝕞𝕖 𝕥𝕠 𝕔𝕝𝕒𝕤𝕤, 𝕦'𝕣𝕖 𝕣𝕖𝕒𝕕𝕪 𝕗𝕠𝕣 𝕝𝕖𝕤𝕤𝕠𝕟?",
                "dont think im can lose hvh to nn (◣◢)",
                "im donr cheat (◣◢)",
                "i dont antiaim i look coin on ground(◣◢)",
                "start destroy (◣◢)",
            },
        },

        kill_say = function(e)
            if contains(misc.misc_menu, "Hoodtalk") then
                local attacker_entindex = client.userid_to_entindex(e.attacker)
                local victim_entindex = client.userid_to_entindex(e.userid)
                if attacker_entindex ~= entity.get_local_player() then
                    return
                end
                if victim_entindex == entity.get_local_player() then
                    return
                end
                local sendconsole = client.exec
                local _first = _misc.value.kill_say_msg[math.random(1, #_misc.value.kill_say_msg)]
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
                client.set_event_callback(event_name, function_name)
            else
                client.unset_event_callback(event_name, function_name)
            end
        else
            client.set_event_callback(event_name, function_name)
        end
    end

    local callbacks = {}
    callbacks = {
        paint = function()
            visuals.stored_paint()
        end;

        paint_ui = function()
            visuals.stored_paint_ui()
        end;

        aim_hit = function(e)
            enemy_hurt(e)
        end;

        aim_miss = function(e)
            missed_enemy(e)
        end;

        player_death = function(e)
            _misc.kill_say(e)
        end;

        round_start = function(e)
            command.aa.ignore = false;
            command.aa.manualAA= 0;
            command.aa.input = 0;
        
            ui.set(manuals.manualLeft, false)
            ui.set(manuals.manualRight, false)
            ui.set(manuals.manualForward, false)
        end;

        shut_down = function()
            skeet_menu(true)
            ui.set(reference.antiaim.yaw[1], "180")
            ui.set(reference.antiaim.yaw[2], 0)
            ui.set(reference.antiaim.yaw_jitt[1], "Off")
            ui.set(reference.antiaim.yaw_jitt[2], 0)
            ui.set(reference.antiaim.body_yaw[1], "Off")
            ui.set(reference.antiaim.body_yaw[2], 0)
            ui.set(reference.fakelag.enablefl, true)
            ui.set_visible(reference.fakelag.enablefl, true)
            ui.set_visible(reference.fakelag.fl_amount, true)
            ui.set_visible(reference.fakelag.fl_limit, true)
            ui.set_visible(reference.fakelag.fl_var, true)
        end;

        setup_command = function(c)
            if c.chokedcommands > 1 then
                vars.defensive.def_ticks = 0
                c.force_defensive = false
                vars.defensive.defensive = 0
            end

            command._states(c)
            command.run_aa(c)
            command.anti_zeus()
            command.manip_svbt()

            if ui.is_menu_open() then
                c.in_attack = false
                c.in_attack2 = false
            end
        end;

        pre_render = function()
            old_anim()
        end;

        run_command = function(cmd)
            defensive_run(cmd)
        end;

        predict_command = function(cmd)
            defensive_setup(cmd)
        end;

        level_init = function()
            vars.defensive.defensive = 0
            vars.defensive.defensive_check = 0
            
            command.aa.ignore = false;
            command.aa.manualAA= 0;
            command.aa.input = 0;
        
            ui.set(manuals.manualLeft, false)
            ui.set(manuals.manualRight, false)
            ui.set(manuals.manualForward, false)
        end;

        stored_callbacks = function()
            call("pre_render", callbacks.pre_render)
            call("shutdown", callbacks.shut_down)
            call("paint", callbacks.paint)
            call("paint_ui", callbacks.paint_ui)
            call("setup_command", callbacks.setup_command)
            call("run_command", callbacks.run_command)
            call("predict_command", callbacks.predict_command)
            call("level_init", callbacks.level_init)
            call("aim_hit", callbacks.aim_hit)
            call("aim_miss", callbacks.aim_miss)
            call("player_death", callbacks.player_death)
            call("round_start", callbacks.round_start)
        end
    }

    callbacks.stored_callbacks()
end

main()
