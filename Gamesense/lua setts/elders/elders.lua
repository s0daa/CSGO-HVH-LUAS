--// Doners#7909 - Coder
_G.elders_loader_versions = "1.0"
_G.elders_username = "dev"
if not _G.elders_loader_versions or _G.elders_loader_versions ~= "1.0" then
    print('redownload new loader from discord...')
    return
end

local elders = {
    support_function = {
        library_check = function (self)
            skeet_library = {
                ['gamesense/antiaim_funcs'] = 'https://gamesense.pub/forums/viewtopic.php?id=29665';
                ['gamesense/base64'] = 'https://gamesense.pub/forums/viewtopic.php?id=21619';
                ['gamesense/clipboard'] = 'https://gamesense.pub/forums/viewtopic.php?id=28678';
                ['gamesense/http'] = 'https://gamesense.pub/forums/viewtopic.php?id=19253';
                ['gamesense/csgo_weapons'] = 'https://gamesense.pub/forums/viewtopic.php?id=18807';
                ['gamesense/icons'] = 'https://gamesense.pub/forums/viewtopic.php?id=42379';
                ['gamesense/entity'] = '?';
            };
            for i, v in pairs(skeet_library) do
                if not pcall(require, i) then
                    error("We cannot load the library: " .. i .. " link: " .. v)
                end
            end
        end;
        rgba_to_hex = function(self, b,c,d,e)
            return string.format('%02x%02x%02x%02x',b,c,d,e)
        end;
        text_fade_animation = function(self, speed, r, g, b, a, text)
            local final_text = ''
            local curtime = globals.curtime()
            for i=0, #text do
                local color = self:rgba_to_hex(r, g, b, a*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)))
                final_text = final_text..'\a'..color..text:sub(i, i)
            end
            return final_text
        end;
        clamp = function(self, x) 
            if x == nil then 
                return 0 
            end 
            x = (x % 360 + 360) % 360 
            return x > 180 and x - 360 or x 
        end;
        str_to_sub = function (self, input, sep)
            local t = {}
            for str in string.gmatch(input, "([^"..sep.."]+)") do
                t[#t + 1] = string.gsub(str, "\n", "")
            end
            return t
        end;
        to_boolean = function (self, str)
            if str == "true" or str == "false" then
                return (str == "true")
            else
                return str
            end
        end;
        arr_to_string = function(self, arr)
            arr = ui.get(arr)
            local str = ""
            for i=1, #arr do
                str = str .. arr[i] .. (i == #arr and "" or ",")
            end
        
            if str == "" then
                str = "-"
            end
        
            return str
        end;
        color_print = function(self, ...) -- ty solicki#0374
            for i, data in ipairs({...}) do
                local r, g, b, text = 255, 255, 255, data
                if type(data) == 'table' then r, g, b, text = unpack(data) end
                client.color_log(r, g, b, i == #{...} and text or (text..'\0'))
            end
        end;
        lerp = function (self, start, vend, time)
            return start + (vend - start) * time
        end;
    };

    library = {
        ['ffi'] = require('ffi');
        ['bit'] = require('bit');
        ['antiaim_funcs'] = require('gamesense/antiaim_funcs');
        ['base64'] = require('gamesense/base64');
        ['clipboard'] = require('gamesense/clipboard');
        ['http'] = require('gamesense/http');
        ['csgo_weapons'] = require('gamesense/csgo_weapons');
        ['icons'] = require('gamesense/icons');
        ['vector'] = require('vector');
        ['entity'] = require("gamesense/entity");
    };
    storage = {
        tab_system = {
            cur_tab = 1;
            skeet_cur_tab = 0;
            skeet_cur_clicked = 0;
            size = { default = { w = 75, h = 64, }, w = 75, h = 64, x = 6, y = 20 };
            m1_down = false;
            bgtexture = renderer.load_rgba("\x14\x14\x14\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x14\x14\x14\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF", 4, 4);
            icons = {
                antiaim = {};
                misc = {};
                visuals = {};
                cfg = {};
            }
        };
        animations = {
            is_on_ground = false;
            E_POSE_PARAMETERS = {
                STRAFE_YAW = 0,
                STAND = 1,
                LEAN_YAW = 2,
                SPEED = 3,
                LADDER_YAW = 4,
                LADDER_SPEED = 5,
                JUMP_FALL = 6,
                MOVE_YAW = 7,
                MOVE_BLEND_CROUCH = 8,
                MOVE_BLEND_WALK = 9,
                MOVE_BLEND_RUN = 10,
                BODY_YAW = 11,
                BODY_PITCH = 12,
                AIM_BLEND_STAND_IDLE = 13,
                AIM_BLEND_STAND_WALK = 14,
                AIM_BLEND_STAND_RUN = 14,
                AIM_BLEND_CROUCH_IDLE = 16,
                AIM_BLEND_CROUCH_WALK = 17,
                DEATH_YAW = 18
            };
        };
        database = {
            configs = ":elders::configs:";
        };
        aa_functions = {
            old_weapon = 0;
            actual_weapon = 0;
            actual_tick = 0;
            can_defensive = false;
            to_start = false;
            old_def_state = "stand";
            prev_simulation_time = 0;
            def_ticks = 0;
        };
        clantag = {
            clan_tags = {
                " ";
                "e";
                "el";
                "eld";
                "elde";
                "elder";
                "elders";
                "elders.";
                "elders.g";
                "elders.gs";
                "elders.gs";
                "elders.gs";
                "elders.g";
                "elders.";
                "elders";
                "elder";
                "elde";
                "eld";
                "el";
                "e";
                " ";
            };
            clantag_prev = nil;
        };
        kill_say_text = {
            "You got wrecked, owned by elders.";
            "You can't handle this, dominated by elders.";
            "You're under our control, subjugated by elders.";
            "Your fate is sealed, controlled by elders.";
            "Prepare to be humiliated, subject to the might of elders.";
            "You're just a pawn, commanded by elders.";
            "Bow down to our wisdom, governed by elders.";
            "Know your place, subordinated to elders.";
            "Your destiny is written, dictated by elders.";
            "You're nothing but a puppet, enslaved by elders.";
            "discord.gg/eldersense";
            "elders.mysellix.io/";
        };
        g_aimbot_data = {};
        g_sim_ticks = {};
        g_net_data = {};
        hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' };
        cl_data = {
            tick_shifted = false;
            tick_base = 0;
        };
        presets = {};
        exploit = {
            charged = false;
        };
        antiaim = {
            state_aa = "stand";
            to_jitter = false;
            current_tickcount = 0;
            inverter = false;
            manual_input = 0;
            manual_aa = 0;
            ignora_aa_manual = false;
            ignora_aa_anti_knife = false;
            ignora_aa_safe_knife_zeus = false;
            defensive = {
                defensive_cmd = 0;
                defensive_check = 0;
                defensive = 0;
            };
            pitch = 0;
            pitch_value = 0;
            yaw_base = 0;
            yaw = 0;
            yaw_value = 0;
            five_way_status = 0;
            three_way_status = 0;
            five_way_status_defensive = 0;
            three_way_status_defensive = 0;
            yaw_jitter = 0;
            yaw_jitter_value = 0;
            body_yaw = 0;
            body_yaw_value = 0;
            roll = 0;
            fs_body_yaw = 0;
        };
        visuals = {
            defensive_lerp = 0;
            defensive_alpha_lerp = 0;
            double_tap_lerp = 0;
            hide_shots_lerp = 0;
            min_dmg_lerp = 0;
            to_add_hs_lerp = 0;
            to_add_mindmg_lerp = 0;
            arrows_lerp = 0;
        };
        misc = {};
        reference = {
            anti_aim = {
                master                                            = ui.reference("AA", "Anti-aimbot angles", "Enabled");
                yaw_base                                          = ui.reference("AA", "Anti-aimbot angles", "Yaw base");
                pitch                                             = {ui.reference("AA", "Anti-aimbot angles", "Pitch")};
                yaw                     = {ui.reference("AA", "Anti-aimbot angles", "Yaw")};
                yaw_jitter       = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")};
                body_yaw           = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")};
                freestanding_body_yaw                             = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw");
                edge_yaw                                          = ui.reference("AA", "Anti-aimbot angles", "Edge yaw");
                freestanding      = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")};
                roll_offset                                       = ui.reference("AA", "Anti-aimbot angles", "Roll");
            };
            other = {
                double_tap = {ui.reference("RAGE", "Aimbot", "Double tap")};
                hide_shots      = {ui.reference("AA", "Other", "On shot anti-aim")};
                fakeducking                                     = ui.reference("RAGE", "Other", "Duck peek assist");
                legs                                            = ui.reference("AA", "Other", "Leg movement");
                slow_motion    = {ui.reference("AA", "Other", "Slow motion")};
                bunny_hop = ui.reference("Misc", "Movement", "Bunny hop");
                enable_fakelag        = {ui.reference("AA", "Fake lag", "Enabled")};
                fakelag_limit        = ui.reference("AA", "Fake lag", "Limit");
                auto_peek = {ui.reference("rage", "other", "quick peek assist")};
                gs_clantag = ui.reference('MISC', 'MISCELLANEOUS', 'Clan tag spammer');
                min_dmg = {ui.reference("RAGE","Aimbot","Minimum damage override")};
            }
        };
    };

    setup_skeet_element = function (self, types, element, value, type_of)
        if types == "vis" then
            for table, values in pairs(self.storage.reference.anti_aim) do
                if type(values) == "table" then
                    for table_, values_ in pairs(values) do
                        if type_of == "load" then
                            ui.set_visible(values_, false)
                        else
                            ui.set_visible(values_, true)
                        end
                    end
                else
                    if type_of == "load" then
                        ui.set_visible(values, false)
                    else
                        ui.set_visible(values, true)
                    end
                end
            end
        elseif types == "vis_elem" then
            ui.set_visible(element, value)
        elseif types == "elem" then
            ui.set(element, value)
        end
    end;

    ui = {};
    ui_config = {};
    builder_state = {'global', 'stand', 'move', 'slow', 'air', 'air-d', 'duck move', 'duck', 'fakelag', 'freestanding'};
    state_to_num = { 
        ['global'] = 1; 
        ['stand'] = 2; 
        ['move'] = 3; 
        ['slow'] = 4;
        ['air'] = 5;
        ['air-d'] = 6;
        ['duck move'] = 7;
        ['duck'] = 8;
        ['fakelag'] = 9;
        ['freestanding'] = 10;
    };

    export_config = function (self) 
        local Code = {{}, {}, {}, {}};
        for index, value in pairs(self.ui_config.general) do
            if ui.get(value) ~= nil then
                table.insert(Code[1], tostring(ui.get(value)))
            end
        end

        for index, value in pairs(self.ui_config.keys_table) do
            if ui.get(value) ~= nil then
                table.insert(Code[2], tostring(self.support_function:arr_to_string(value)))
            end
        end

        for index, value in pairs(self.ui_config.misc) do
            if ui.get(value) ~= nil then
                table.insert(Code[3], tostring(ui.get(value)))
            end
        end

        for index, value in pairs(self.ui_config.visuals) do
            if ui.get(value) ~= nil then
                table.insert(Code[4], tostring(ui.get(value)))
            end
        end
        return json.stringify(Code)
    end;

    load_config = function (self, string)
        for k, v in pairs(json.parse(string)) do
            k = ({[1] = "general", [2] = "keys_table", [3] = "misc", [4] = "visuals"})[k]
            for k2, v2 in pairs(v) do
                if (k == "general") then
                    if v2 == "true" then
                        ui.set(self.ui_config[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(self.ui_config[k][k2], false)
                    else
                        ui.set(self.ui_config[k][k2], v2)
                    end
                end
                if (k == "keys_table") then
                    ui.set(self.ui_config[k][k2], self.support_function:str_to_sub(v2, ","))
                end
                if (k == "misc") then
                    if v2 == "true" then
                        ui.set(self.ui_config[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(self.ui_config[k][k2], false)
                    else
                        ui.set(self.ui_config[k][k2], v2)
                    end
                end
                if (k == "visuals") then
                    if v2 == "true" then
                        ui.set(self.ui_config[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(self.ui_config[k][k2], false)
                    else
                        ui.set(self.ui_config[k][k2], v2)
                    end
                end
            end
        end     
    end;

    get_config = function (self, name)
        local database = database.read(self.storage.database.configs) or {}
        for i, v in pairs(database) do
            if v.name == name then
                return {
                    config = v.config,
                    index = i
                }
            end
        end    

        for i, v in pairs(self.storage.presets) do
            if v.name == name then
                return {
                    config = self.library['base64'].decode(v.config),
                    index = i
                }
            end
        end

        return false
    end;

    save_config = function (self, name)
        local db = database.read(self.storage.database.configs) or {}
        local config = {}
    
        if name:match("[^%w]") ~= nil then
            return
        end
    
        table.insert(config, self:export_config())
    
        local cfg = self:get_config(name)
    
        if not cfg then
            table.insert(db, { name = name, config = table.concat(config, ":") })
        else
            db[cfg.index].config = table.concat(config, ":")
        end
    
        database.write(self.storage.database.configs, db)
    end;

    delete_config = function (self, name)
        local db = database.read(self.storage.database.configs) or {}
    
        for i, v in pairs(db) do
            if v.name == name then
                table.remove(db, i)
                break
            end
        end

        for i, v in pairs(self.storage.presets) do
            if v.name == name then
                return false
            end
        end
    
        database.write(self.storage.database.configs, db)
    end;

    get_config_list = function (self)
        local database = database.read(self.storage.database.configs) or {}
        local config = {}
        local presets = self.storage.presets

        for i, v in pairs(presets) do
            table.insert(config, v.name)
        end
    
        for i, v in pairs(database) do
            table.insert(config, v.name)
        end
    
        return config
    end;

    create_menu_elements = function (self)
        self.ui.antiaim_elements = {};
        self.ui.config = {};
        self.ui.misc = {};
        self.ui.visuals = {};
        self.ui.ui_color = "\a838be2FF"
        self.ui.tab_label = ui.new_label("AA", "Anti-aimbot angles", " ");
        self.ui.extra_switch = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ extra");
        self.ui.extra_selector = ui.new_combobox("AA", "Anti-aimbot angles", "\n", {"binds", "additionals"});
        self.ui.legit_aa_key = ui.new_hotkey("AA", "Anti-aimbot angles", " -> \a989898FFlegit aa on use");
        self.ui.manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", " -> \a989898FFmanual left");
        self.ui.manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", " -> \a989898FFmanual right");
        self.ui.manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", " -> \a989898FFmanual forward");
        self.ui.freestanding = ui.new_hotkey("AA", "Anti-aimbot angles", " -> \a989898FFfreestanding");
        self.ui.edgeyaw = ui.new_hotkey("AA", "Anti-aimbot angles", " -> \a989898FFedge yaw");
        self.ui.fl_exploit = ui.new_checkbox("AA", "Anti-aimbot angles", " -> \a989898FFmin fakelag on exploit");
        self.ui.anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", " -> \a989898FFanti knife");
        self.ui.safe_knife_zeus = ui.new_checkbox("AA", "Anti-aimbot angles", " -> \a989898FFsafe knife/taser");

        self.ui.aabuilder_state = ui.new_combobox("AA", "Anti-aimbot angles", "\nlmaos", self.builder_state)

        for k, v in pairs(self.builder_state) do
            self.ui.antiaim_elements[k] = { 
                enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFF [ ".. self.ui.ui_color .."elders \aFFFFFFFF-> \a989898FFenable "..self.builder_state[k].." \aFFFFFFFF]");
                antiaim_pitch = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ pitch", {"off", "default", "up", "down", "minimal", "random", "custom"});
                antiaim_pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ custom pitch", -89, 89, 0, true);
                antiaim_yaw_base = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ yaw base", {"at targets", "local view"});
                antiaim_yaw = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ yaw", {"off", "180", "spin", "static", "180 Z", "crosshair"});
                antiaim_yaw_mode = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ yaw modifier", {"static", "left / right", "tickbase delayed", "flick", "3 way", "5 way", "random l / r"});
                correcting_body_yaw = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ correcting body yaw");
                antiaim_yaw_static_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nstatic aa", -180, 180, 0, true);
                antiaim_yaw_left_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ left yaw", -180, 180, 0, true);
                antiaim_yaw_right_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ right yaw", -180, 180, 0, true);
                antiaim_yaw_delay_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ yaw delay", 2, 10, 0, true);
                antiaim_yaw_1way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 1 way yaw", -180, 180, 0, true);
                antiaim_yaw_2way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 2 way yaw", -180, 180, 0, true);
                antiaim_yaw_3way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 3 way yaw", -180, 180, 0, true);
                antiaim_yaw_4way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 4 way yaw", -180, 180, 0, true);
                antiaim_yaw_5way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 5 way yaw", -180, 180, 0, true);
                antiaim_yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ yaw jitter", {"off", "center", "offset", "center", "random", "skitter"});
                antiaim_yaw_jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ yaw jitter modifier",  {"static", "left / right", "3 way", "5 way", "random l / r"});
                antiaim_yaw_jitter_static_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nstatic aa", -180, 180, 0, true);
                antiaim_yaw_jitter_left_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ left yaw jitter", -180, 180, 0, true);
                antiaim_yaw_jitter_right_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ right yaw jitter", -180, 180, 0, true);
                antiaim_yaw_jitter_1way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 1 way yaw jitter", -180, 180, 0, true);
                antiaim_yaw_jitter_2way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 2 way yaw jitter", -180, 180, 0, true);
                antiaim_yaw_jitter_3way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 3 way yaw jitter", -180, 180, 0, true);
                antiaim_yaw_jitter_4way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 4 way yaw jitter", -180, 180, 0, true);
                antiaim_yaw_jitter_5way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 5 way yaw jitter", -180, 180, 0, true);
                antiaim_body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ body yaw", {"off", "opposite", "jitter", "static"});
                antiaim_body_yaw_static_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nstatic aa", -180, 180, 0, true);
                antiaim_roll = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ roll", -45, 45, 0, true);
                antiaim_freestanding_mode = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ fs mode/conditions", {"off", "on bind"});
                antiaim_freestanding_body_yaw = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ fs body yaw");
                antiaim_defensive_force = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ force defensive");
                antiaim_defensive = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ defensive builder");
                antiaim_pitch_defensive_override = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ pitch override");
                antiaim_pitch_defensive = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ pitch defensive", {"off", "default", "up", "down", "minimal", "random", "custom"});
                antiaim_pitch_defensive_mode = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ pitch custom modifier",  {"static", "jitter", "tickbase delayed", "flick", "3 way", "5 way", "random"});
                antiaim_pitch_slider_defensive = ui.new_slider("AA", "Anti-aimbot angles", "\npitch", -89, 89, 0, true);
                antiaim_pitch_first_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ first pitch value", -89, 89, 0, true);
                antiaim_pitch_second_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ second pitch value", -89, 89, 0, true);
                antiaim_pitch_delay_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ pitch delay", 2, 10, 0, true);
                antiaim_pitch_1way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 1 way pitch value", -89, 89, 0, true);
                antiaim_pitch_2way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 2 way pitch value", -89, 89, 0, true);
                antiaim_pitch_3way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 3 way pitch value", -89, 89, 0, true);
                antiaim_pitch_4way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 4 way pitch value", -89, 89, 0, true);
                antiaim_pitch_5way_slider = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 5 way pitch value", -89, 89, 0, true);
                antiaim_yaw_defensive_override = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ yaw override");
                antiaim_yaw_defensive = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ yaw defensive", {"off", "180", "spin", "static", "180 Z", "crosshair"});
                antiaim_yaw_defensive_mode = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ yaw custom modifier",  {"static", "jitter", "tickbase delayed", "flick", "3 way", "5 way", "random"});
                antiaim_yaw_static_slider_defensive = ui.new_slider("AA", "Anti-aimbot angles", "\nstatic aa", -180, 180, 0, true);
                antiaim_yaw_first_slider_defensive  = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ first yaw value", -180, 180, 0, true);
                antiaim_yaw_second_slider_defensive  = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ second yaw value", -180, 180, 0, true);
                antiaim_yaw_delay_slider_defensive  = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ yaw delay", 2, 10, 0, true);
                antiaim_yaw_1way_slider_defensive = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 1 way yaw value", -180, 180, 0, true);
                antiaim_yaw_2way_slider_defensive  = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 2 way yaw value", -180, 180, 0, true);
                antiaim_yaw_3way_slider_defensive  = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 3 way yaw value", -180, 180, 0, true);
                antiaim_yaw_4way_slider_defensive  = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 4 way yaw value", -180, 180, 0, true);
                antiaim_yaw_5way_slider_defensive  = ui.new_slider("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ 5 way yaw value", -180, 180, 0, true);
                antiaim_yaw_jitter_defensive_override = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ yaw jitter override");
                antiaim_yaw_jitter_defensive = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF*\a989898FF"..self.builder_state[k].."\aFFFFFFFF ~ defensive yaw jitter", {"off", "center", "offset", "center", "random", "skitter"});
                antiaim_yaw_jitter_static_slider_defensive = ui.new_slider("AA", "Anti-aimbot angles", "\nstatic aa", -180, 180, 0, true);
            }
        end;

        self.ui.visuals.watermark_size = ui.new_combobox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ watermark size", {"small", "+ size"});
        self.ui.visuals.manual_arrows = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ manual arrows");
        self.ui.visuals.indicator = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ indicator");
        self.ui.visuals.indicator_color = ui.new_color_picker("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ indicator color", 131, 139, 226, 255);
        self.ui.visuals.defensive_box_color_txt = ui.new_label("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ defensive box color");
        self.ui.visuals.defensive_box_color = ui.new_color_picker("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ defensive box color", 42, 42, 90, 255);
        self.ui.visuals.defensive_first_gradient_color_txt = ui.new_label("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ defensive first gradient color");
        self.ui.visuals.defensive_first_gradient_color = ui.new_color_picker("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ defensive first gradient color", 134, 164, 241, 0);
        self.ui.visuals.defensive_last_gradient_color_txt = ui.new_label("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ defensive last gradient color");
        self.ui.visuals.defensive_last_gradient_color = ui.new_color_picker("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ defensive last gradient color", 134, 164, 241, 0);

        self.ui.misc.clantag = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ synced clantag");
        self.ui.misc.killsay = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ kill say");
        self.ui.misc.aimbot_logs = ui.new_checkbox("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ aimbot logs");
        self.ui.misc.animbreaker = ui.new_multiselect("AA", "Anti-aimbot angles", self.ui.ui_color .."elders \aFFFFFFFF~ animation breaker", {"body lean", "static in air", "legs on ground", "pitch on land"});

        self.ui.config.list = ui.new_listbox("AA", "Anti-aimbot angles", "Configs", "")
        self.ui.config.name = ui.new_textbox("AA", "Anti-aimbot angles", "Config name", "")
        self.ui.config.import = ui.new_button("AA", "Anti-aimbot angles", "\aFFFFFFFF [ ".. self.ui.ui_color .."elders \aFFFFFFFF-> config]\a989898FF import settings", function() end)
        self.ui.config.export = ui.new_button("AA", "Anti-aimbot angles", "\aFFFFFFFF [ ".. self.ui.ui_color .."elders \aFFFFFFFF-> config]\a989898FF export settings", function() end)
        self.ui.config.load = ui.new_button("AA", "Anti-aimbot angles", "\aFFFFFFFF [ ".. self.ui.ui_color .."elders \aFFFFFFFF-> config]\a989898FF load", function() end)
        self.ui.config.save = ui.new_button("AA", "Anti-aimbot angles", "\aFFFFFFFF [ ".. self.ui.ui_color .."elders \aFFFFFFFF-> config]\a989898FF save", function() end)
        self.ui.config.delete = ui.new_button("AA", "Anti-aimbot angles", "\aFFFFFFFF [ ".. self.ui.ui_color .."elders \aFFFFFFFF-> config]\a989898FF delete", function() end)
        self.ui_config = {
            general = {};
            keys_table = {};
            misc = {};
            visuals = {};
        }
    end;

    check_charge = function (self) --// ty Shade
        local m_nTickBase = entity.get_prop(entity.get_local_player(), 'm_nTickBase')
        local client_latency = client.latency()
        local shift = math.floor(m_nTickBase - globals.tickcount() - 3 - toticks(client_latency) * .5 + .7 * (client_latency * 10))
        local wanted = -14 + (ui.get(self.storage.reference.other.fakelag_limit) - 3)
        self.storage.exploit.charged = shift <= wanted
    end;

    defensive_run = function (self, args)
        self.storage.antiaim.defensive.defensive_cmd = args.command_number
    end;

    defensive_setup = function (self, args)
        if args.command_number == self.storage.antiaim.defensive.defensive_cmd then
            local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
            self.storage.antiaim.defensive.defensive = math.abs(tickbase -  self.storage.antiaim.defensive.defensive_check)
            self.storage.antiaim.defensive.defensive_check = math.max(tickbase, self.storage.antiaim.defensive.defensive_check or 0)
            self.storage.antiaim.defensive.defensive_cmd = 0
        end
    end;

    sim_diff = function (self) 
        local local_player = entity.get_local_player()
        if not local_player or not entity.is_alive(local_player) then
            return 0
        end
        local current_simulation_time = math.floor(0.5 + (entity.get_prop(entity.get_local_player(), "m_flSimulationTime") / globals.tickinterval())) 
        local diff = current_simulation_time - self.storage.aa_functions.prev_simulation_time
        self.storage.aa_functions.prev_simulation_time = current_simulation_time
        return diff
    end;

    beta_defensive = function (self, args)
        self.storage.aa_functions.old_weapon = self.storage.aa_functions.actual_weapon
        self.storage.aa_functions.actual_weapon = entity.get_player_weapon(entity.get_local_player())

        if self.storage.aa_functions.old_weapon ~= self.storage.aa_functions.actual_weapon then
            self.storage.aa_functions.to_start = true
        end

        if entity.get_player_weapon(entity.get_local_player()) ~= self.storage.aa_functions.old_weapon then
            self.storage.aa_functions.actual_tick = 0
            self.storage.aa_functions.to_start = true
        end
        
        if self.storage.aa_functions.to_start == true and self.storage.aa_functions.actual_tick < 100 then
            self.storage.aa_functions.actual_tick = self.storage.aa_functions.actual_tick + 1
        elseif self.storage.aa_functions.actual_tick >= 100 then
            self.storage.aa_functions.actual_tick = 0
            self.storage.aa_functions.to_start = false
        end

        self.storage.aa_functions.old_weapon = entity.get_player_weapon(entity.get_local_player())

        if self.storage.aa_functions.can_defensive then
            if ui.get(self.ui.antiaim_elements[self.state_to_num[self.storage.aa_functions.old_def_state]].antiaim_defensive) ~= ui.get(self.ui.antiaim_elements[self.state_to_num[self.storage.antiaim.state_aa]].antiaim_defensive) then
                self.storage.aa_functions.can_defensive = false
            end
        end

        self.storage.aa_functions.old_def_state = self.storage.antiaim.state_aa

        if self.storage.aa_functions.can_defensive then
            self.storage.aa_functions.def_ticks = 27
            self.storage.aa_functions.can_defensive = false
        end

        if self.storage.aa_functions.def_ticks > 0 then
            self.storage.aa_functions.def_ticks = self.storage.aa_functions.def_ticks - 1
        else
            self.storage.aa_functions.can_defensive = false
        end

        if self.storage.aa_functions.to_start == true then 
            return false
        end

        if (ui.get(self.storage.reference.other.double_tap[2]) or ui.get(self.storage.reference.other.hide_shots[2])) then
            if self.storage.aa_functions.def_ticks > 0 or args.force_defensive == true then 
                return true
            end
        else
            return false
        end
    end;

    get_aa_state = function (self, args)
        local state = ""
        local lp = entity.get_local_player()
        local flags = entity.get_prop(lp, "m_fFlags")
        local vel1, vel2, vel3 = entity.get_prop(lp, 'm_vecVelocity')
        local velocity = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))
        local in_air = bit.band(entity.get_prop(lp, "m_fFlags"), 1) == 0 or client.key_state(0x20)
        local not_moving = velocity < 2
        local slowwalk_key = ui.get(self.storage.reference.other.slow_motion[2])
        local teamnum = entity.get_prop(lp, 'm_iTeamNum')
        if ui.get(self.storage.reference.other.double_tap[2]) == false and ui.get(self.storage.reference.other.hide_shots[2]) == false then
            state = 'fakelag'
        elseif ui.get(self.storage.reference.other.fakeducking) then
            state = 'duck'
        elseif in_air then
            state = bit.band(flags, 4) == 4 and 'air-d' or 'air'
        else
            if bit.band(flags, 4) == 4 and velocity <= 2 then
                state = 'duck'
            elseif bit.band(flags, 4) == 4 and velocity >= 2 then
                state = 'duck move'                
            elseif not_moving then   
                state = 'stand'
            elseif not not_moving then
                if slowwalk_key then
                    state = 'slow'
                else
                    state = 'move'
                end
            end
        end
        self.storage.antiaim.state_aa = state;
        return state
    end;

    anti_knife_dist = function (self, x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end;


    manipulation_flick = function(self, left, right, delay)
        if globals.tickcount() % delay == 0 then
            return left
        else
            return right
        end
    end;

    velocity = function(self, arg)
        local x, y, z = entity.get_prop(arg, "m_vecVelocity")
        return math.sqrt(x*x + y*y + z*z)
    end;

    movementjitter = function(self)
        local me = entity.get_local_player()
        local weapon_ent = entity.get_player_weapon(me)
        if not weapon_ent then
            return
        end
        local weapon = self.library["csgo_weapons"](weapon_ent)
        if not weapon then
            return
        end
        local velocity = self:velocity(me)
        local max_player_speed = (entity.get_prop(me, "m_bIsScoped") == 1) and weapon.max_player_speed_alt or weapon.max_player_speed
        local max_achieved = false
        local speed = max_achieved and max_player_speed or max_player_speed * 0.95
        if max_achieved then
            if velocity >= max_player_speed * 0.99 then
                max_achieved = false
            end
        elseif velocity <= max_player_speed * 0.95 then
            max_achieved = true
        end
        cvar.cl_sidespeed:set_int(speed)
        cvar.cl_forwardspeed:set_int(speed)
        cvar.cl_backspeed:set_int(speed)
    end;

    run_antiaim = function (self, args)
        local local_player = entity.get_local_player()
        if not local_player then
            return
        end
        local cur_team = entity.get_prop(entity.get_local_player(), "m_iTeamNum")
        local state_id = ui.get(self.ui.antiaim_elements[self.state_to_num[self:get_aa_state(args)] ].enable) and self.state_to_num[self:get_aa_state(args)] or self.state_to_num['global'];
        self.storage.antiaim.three_way_status = globals.tickcount() % 3
        self.storage.antiaim.five_way_status = globals.tickcount() % 5
        
        if ui.get(self.ui.antiaim_elements[state_id].antiaim_freestanding_mode) == "off" then
            ui.set(self.storage.reference.anti_aim.freestanding[1], false)
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_freestanding_mode) == "on bind" and ui.get(self.ui.extra_switch) and ui.get(self.ui.freestanding) then
            if ui.get(self.ui.antiaim_elements[10].enable) then
                state_id = 10
            end
            ui.set(self.storage.reference.anti_aim.freestanding[1], true)
        else
            ui.set(self.storage.reference.anti_aim.freestanding[1], false)
        end
        
        if state_id ~= 10 then
            ui.set(self.ui.antiaim_elements[10].antiaim_freestanding_mode, ui.get(self.ui.antiaim_elements[state_id].antiaim_freestanding_mode))
        else
            ui.set(self.ui.antiaim_elements[10].antiaim_freestanding_mode, "on bind")
        end

        self.storage.antiaim.three_way_status_defensive = globals.tickcount() % 6
        self.storage.antiaim.five_way_status_defensive = globals.tickcount() % 5

        self.storage.antiaim.pitch = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch)
        self.storage.antiaim.pitch_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_slider)
        self.storage.antiaim.yaw_base = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_base)
        self.storage.antiaim.yaw = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw)
        if ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "tickbase delayed" then
            if globals.tickcount() > self.storage.antiaim.current_tickcount + (ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_delay_slider)) then
                if args.chokedcommands == 0 then
                    self.storage.antiaim.to_jitter = not self.storage.antiaim.to_jitter
                    self.storage.antiaim.inverter = self.storage.antiaim.to_jitter
                    self.storage.antiaim.current_tickcount = globals.tickcount()
                end
            elseif globals.tickcount() < self.storage.antiaim.current_tickcount then
                self.storage.antiaim.current_tickcount = globals.tickcount()
            end
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "flick" then
            self.storage.antiaim.inverter = self:manipulation_flick(-1, 1, ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_delay_slider))
        else
            self.storage.antiaim.fake_body = math.max(-60, math.min(60, math.floor((entity.get_prop(local_player, "m_flPoseParameter",11) or 0) * 120 - 60.5)))
            self.storage.antiaim.inverter = self.storage.antiaim.fake_body > 0 and -1 or 1
        end

        
        if ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "static" then
            self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_static_slider)
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "left / right" then
            self.storage.antiaim.yaw_value = self.storage.antiaim.inverter == -1 and ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_left_slider) or ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_right_slider)
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "tickbase delayed" then
            self.storage.antiaim.yaw_value = self.storage.antiaim.inverter and ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_left_slider) or ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_right_slider)
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "flick" then
            self.storage.antiaim.yaw_value = self.storage.antiaim.inverter == -1 and ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_left_slider) or ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_right_slider)
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "3 way" then
            if self.storage.antiaim.three_way_status == 0 then
                self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_1way_slider)
            elseif self.storage.antiaim.three_way_status == 1 then
                self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_2way_slider)
            elseif self.storage.antiaim.three_way_status == 2 then
                self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_3way_slider)
            end
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "5 way" then
            self.storage.antiaim.five_way_status = globals.tickcount() % 5
            if self.storage.antiaim.five_way_status == 0 then
                self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_1way_slider)
            elseif self.storage.antiaim.five_way_status == 1 then
                self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_2way_slider)
            elseif self.storage.antiaim.five_way_status == 2 then
                self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_3way_slider)
            elseif self.storage.antiaim.five_way_status == 3 then
                self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_4way_slider)
            elseif self.storage.antiaim.five_way_status == 4 then
                self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_5way_slider)
            end
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "random l / r" then
            self.storage.antiaim.yaw_value = client.random_int(ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_left_slider), ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_right_slider))
        end

        self.storage.antiaim.yaw_jitter = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter)

        if ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_mode) == "static" then
            self.storage.antiaim.yaw_jitter_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_static_slider)
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_mode) == "left / right" then
            self.storage.antiaim.yaw_jitter_value = self.storage.antiaim.inverter == -1 and ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_left_slider) or ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_right_slider)
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_mode) == "3 way" then
            if self.storage.antiaim.three_way_status == 0 then
                self.storage.antiaim.yaw_jitter_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_1way_slider)
            elseif self.storage.antiaim.three_way_status == 1 then
                self.storage.antiaim.yaw_jitter_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_2way_slider)
            elseif self.storage.antiaim.three_way_status == 2 then
                self.storage.antiaim.yaw_jitter_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_3way_slider)
            end
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_mode) == "5 way" then
            if self.storage.antiaim.five_way_status == 0 then
                self.storage.antiaim.yaw_jitter_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_1way_slider)
            elseif self.storage.antiaim.five_way_status == 1 then
                self.storage.antiaim.yaw_jitter_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_2way_slider)
            elseif self.storage.antiaim.five_way_status == 2 then
                self.storage.antiaim.yaw_jitter_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_3way_slider)
            elseif self.storage.antiaim.five_way_status == 3 then
                self.storage.antiaim.yaw_jitter_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_4way_slider)
            elseif self.storage.antiaim.five_way_status == 4 then
                self.storage.antiaim.yaw_jitter_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_5way_slider)
            end
        elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_mode) == "random l / r" then
            self.storage.antiaim.yaw_jitter_value = client.random_int(ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_left_slider), ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_right_slider))
        end

        self.storage.antiaim.body_yaw = ui.get(self.ui.antiaim_elements[state_id].antiaim_body_yaw)

        if ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "tickbase delayed" then
            self.storage.antiaim.body_yaw_value = self.storage.antiaim.inverter and -115 or 115
            self.storage.antiaim.body_yaw = "Static"
        else
            if ui.get(self.ui.antiaim_elements[state_id].correcting_body_yaw) and ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "left / right" then
                self.storage.antiaim.body_yaw_value = self.storage.antiaim.inverter == -1 and -1 or 1
            elseif ui.get(self.ui.antiaim_elements[state_id].correcting_body_yaw) and ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_mode) == "flick" then
                self.storage.antiaim.body_yaw_value = self.storage.antiaim.inverter == -1 and -180 or 180
            else
                self.storage.antiaim.body_yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_body_yaw_static_slider)
            end
        end
        self.storage.antiaim.roll = ui.get(self.ui.antiaim_elements[state_id].antiaim_roll);
        self.storage.antiaim.fs_body_yaw = ui.get(self.ui.antiaim_elements[state_id].antiaim_freestanding_body_yaw);
        if ui.get(self.ui.antiaim_elements[state_id].antiaim_defensive_force) then
            if ui.get(self.storage.reference.other.double_tap[2]) or ui.get(self.storage.reference.other.hide_shots[2]) then
                args.force_defensive = true
                if args.force_defensive then
                    if globals.tickcount() % 10 <= 2 then
                        args.force_defensive = false
                    end
                end
            end
        end
        if ui.get(self.ui.antiaim_elements[state_id].antiaim_defensive) and (self:beta_defensive(args)) and self.storage.antiaim.ignora_aa_manual == false and self.storage.antiaim.ignora_aa_safe_knife_zeus == false and self.storage.antiaim.ignora_aa_anti_knife == false then
            args.no_choke = 1;
            args.quick_stop = 1;
            ui.set(self.storage.reference.anti_aim.freestanding[1], false)
            if ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_defensive_override) then
                if ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_defensive) == "random" then
                    local mathing_shits = math.random(1, 3)
                    if mathing_shits == 1 then
                        self.storage.antiaim.pitch = "minimal"
                    elseif mathing_shits == 2 then
                        self.storage.antiaim.pitch = "up"
                    else
                        self.storage.antiaim.pitch = "custom"
                        self.storage.antiaim.pitch_value = 0
                    end
                else
                    self.storage.antiaim.pitch = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_defensive)
                end
                if ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_defensive_mode) == "static" then
                    self.storage.antiaim.pitch_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_slider_defensive)
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_defensive_mode) == "jitter" then
                    self.storage.antiaim.pitch_value = globals.tickcount() % 6 > 3 and ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_first_slider) or ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_second_slider)
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_defensive_mode) == "tickbase delayed" then
                    self.storage.antiaim.pitch_value = self.storage.antiaim.to_jitter and ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_first_slider) or ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_second_slider)
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_defensive_mode) == "flick" then
                    self.storage.antiaim.pitch_value = self:manipulation_flick(-1, 1, 8) and ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_first_slider) or ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_second_slider)
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_defensive_mode) == "3 way" then
                    if self.storage.antiaim.three_way_status_defensive == 0 then
                        self.storage.antiaim.pitch_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_1way_slider)
                    elseif self.storage.antiaim.three_way_status_defensive == 1 then
                        self.storage.antiaim.pitch_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_2way_slider)
                    elseif self.storage.antiaim.three_way_status_defensive == 2 then
                        self.storage.antiaim.pitch_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_3way_slider)
                    end
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_defensive_mode) == "5 way" then
                    if self.storage.antiaim.five_way_status_defensive == 0 then
                        self.storage.antiaim.pitch_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_1way_slider)
                    elseif self.storage.antiaim.five_way_status_defensive == 1 then
                        self.storage.antiaim.pitch_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_2way_slider)
                    elseif self.storage.antiaim.five_way_status_defensive == 2 then
                        self.storage.antiaim.pitch_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_3way_slider)
                    elseif self.storage.antiaim.five_way_status_defensive == 3 then
                        self.storage.antiaim.pitch_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_4way_slider)
                    elseif self.storage.antiaim.five_way_status_defensive == 4 then
                        self.storage.antiaim.pitch_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_5way_slider)
                    end
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_defensive_mode) == "random" then
                    local mathing_def_pitch = client.random_int(ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_first_slider), ui.get(self.ui.antiaim_elements[state_id].antiaim_pitch_second_slider))
                    self.storage.antiaim.pitch_value = globals.tickcount() % 6 < 3 and mathing_def_pitch or -mathing_def_pitch
                end
            end
            if ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_defensive_override) then
                self.storage.antiaim.yaw = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_defensive)
                if ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_defensive_mode) == "static" then
                    self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_static_slider_defensive)
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_defensive_mode) == "jitter" then
                    self.storage.antiaim.yaw_value = globals.tickcount() % 6 > 3 and ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_first_slider_defensive) or ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_second_slider_defensive)
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_defensive_mode) == "tickbase delayed" then
                    self.storage.antiaim.yaw_value = self.storage.antiaim.to_jitter and ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_first_slider_defensive) or ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_second_slider_defensive)
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_defensive_mode) == "flick" then
                    self.storage.antiaim.yaw_value = self:manipulation_flick(ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_first_slider_defensive), ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_second_slider_defensive), ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_delay_slider_defensive))
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_defensive_mode) == "3 way" then
                    if self.storage.antiaim.three_way_status_defensive == 0 then
                        self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_1way_slider_defensive)
                    elseif self.storage.antiaim.three_way_status_defensive == 1 then
                        self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_2way_slider_defensive)
                    elseif self.storage.antiaim.three_way_status_defensive == 2 then
                        self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_3way_slider_defensive)
                    end
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_defensive_mode) == "5 way" then
                    if self.storage.antiaim.five_way_status_defensive == 0 then
                        self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_1way_slider_defensive)
                    elseif self.storage.antiaim.five_way_status_defensive == 1 then
                        self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_2way_slider_defensive)
                    elseif self.storage.antiaim.five_way_status_defensive == 2 then
                        self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_3way_slider_defensive)
                    elseif self.storage.antiaim.five_way_status_defensive == 3 then
                        self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_4way_slider_defensive)
                    elseif self.storage.antiaim.five_way_status_defensive == 4 then
                        self.storage.antiaim.yaw_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_5way_slider_defensive)
                    end
                elseif ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_defensive_mode) == "random" then
                    local mathing_def_yaw = client.random_int(ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_first_slider_defensive), ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_second_slider_defensive))
                    self.storage.antiaim.yaw_value = globals.tickcount() % 6 < 3 and mathing_def_yaw or -mathing_def_yaw
                end
            end

            if ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_defensive_override) then
                self.storage.antiaim.yaw_jitter = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_defensive)
                self.storage.antiaim.yaw_jitter_value = ui.get(self.ui.antiaim_elements[state_id].antiaim_yaw_jitter_static_slider_defensive)
            end
        end

        if ui.get(self.ui.extra_switch) then
            if ui.get(self.ui.legit_aa_key) then
                if entity.get_player_weapon(entity.get_local_player()) ~= nil and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CC4" then
                    if args.in_attack == 1 then
                        args.in_attack = 0 
                        args.in_use = 1
                    end
                else
                    if args.chokedcommands == 0 then
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[1], "off");
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[2], 0);
                        ui.set(self.storage.reference.anti_aim.body_yaw[1], "static");
                        ui.set(self.storage.reference.anti_aim.body_yaw[2], 180);
                        ui.set(self.storage.reference.anti_aim.yaw_base, "at targets");
                        ui.set(self.storage.reference.anti_aim.yaw[1], "180");
                        ui.set(self.storage.reference.anti_aim.yaw[2], 180);
                        ui.set(self.storage.reference.anti_aim.freestanding_body_yaw, true);
                        args.in_use = 0
                    end
                end
            end

            if ui.get(self.ui.freestanding) and self.storage.antiaim.ignora_aa_manual == false and self.storage.antiaim.ignora_aa_safe_knife_zeus == false and self.storage.antiaim.ignora_aa_anti_knife == false then
                ui.set(self.storage.reference.anti_aim.freestanding[2], "Always on")
            else
                ui.set(self.storage.reference.anti_aim.freestanding[2], "On hotkey")
            end

            if ui.get(self.ui.edgeyaw) and self.storage.antiaim.ignora_aa_manual == false and self.storage.antiaim.ignora_aa_safe_knife_zeus == false and self.storage.antiaim.ignora_aa_anti_knife == false then
                ui.set(self.storage.reference.anti_aim.edge_yaw, true)
            else
                ui.set(self.storage.reference.anti_aim.edge_yaw, false)
            end

            if ui.get(self.ui.anti_knife) then
                local players = entity.get_players(true)
                local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
                for i=1, #players do
                    local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
                    local distance = self:anti_knife_dist(lx, ly, lz, x, y, z)
                    local weapon = entity.get_player_weapon(players[i])
                    if entity.get_classname(weapon) == "CKnife" and distance <= 150 then
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[1], "off");
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[2], 0);
                        ui.set(self.storage.reference.anti_aim.body_yaw[1], "static");
                        ui.set(self.storage.reference.anti_aim.body_yaw[2], -180);
                        ui.set(self.storage.reference.anti_aim.yaw_base, "at targets");
                        ui.set(self.storage.reference.anti_aim.yaw[1], "180");
                        ui.set(self.storage.reference.anti_aim.yaw[2], 180);
                        ui.set(self.storage.reference.anti_aim.pitch[1], "minimal")
                        self.storage.antiaim.ignora_aa_anti_knife = true;
                    else
                        self.storage.antiaim.ignora_aa_anti_knife = false;
                    end
                end
            else
                self.storage.antiaim.ignora_aa_anti_knife = false;
            end
            
            if self.storage.antiaim.ignora_aa_anti_knife == false then
                if ui.get(self.ui.safe_knife_zeus) then
                    local weapon_name = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))
                    if weapon_name == "CWeaponTaser" or weapon_name == "CKnife" then
                        self.storage.antiaim.ignora_aa_safe_knife_zeus = true;
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[1], "off");
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[2], 0);
                        ui.set(self.storage.reference.anti_aim.body_yaw[1], "static");
                        ui.set(self.storage.reference.anti_aim.body_yaw[2], 180);
                        ui.set(self.storage.reference.anti_aim.yaw_base, "at targets");
                        ui.set(self.storage.reference.anti_aim.yaw[1], "180");
                        ui.set(self.storage.reference.anti_aim.yaw[2], 15);
                        ui.set(self.storage.reference.anti_aim.freestanding_body_yaw, true);
                        ui.set(self.storage.reference.anti_aim.pitch[1], "minimal")
                    else
                        self.storage.antiaim.ignora_aa_safe_knife_zeus = false;
                    end
                else
                    self.storage.antiaim.ignora_aa_safe_knife_zeus = false;
                end
            else
                self.storage.antiaim.manual_input = 0;
                self.storage.antiaim.ignora_aa_manual = false;
            end

            if self.storage.antiaim.ignora_aa_safe_knife_zeus == false and self.storage.antiaim.ignora_aa_anti_knife == false then
                if self.storage.antiaim.manual_input + 0.22 < globals.curtime() then
                    if self.storage.antiaim.manual_aa == 0 then
                        if ui.get(self.ui.manual_left) then
                            self.storage.antiaim.manual_aa = 1
                            self.storage.antiaim.manual_input = globals.curtime()
                        elseif ui.get(self.ui.manual_right) then
                            self.storage.antiaim.manual_aa = 2
                            self.storage.antiaim.manual_input = globals.curtime()
                        elseif ui.get(self.ui.manual_forward) then
                            self.storage.antiaim.manual_aa = 3
                            self.storage.antiaim.manual_input = globals.curtime()
                        end
                    elseif self.storage.antiaim.manual_aa == 1 then
                        if ui.get(self.ui.manual_right) then
                            self.storage.antiaim.manual_aa = 2
                            self.storage.antiaim.manual_input = globals.curtime()
                        elseif ui.get(self.ui.manual_forward) then
                            self.storage.antiaim.manual_aa = 3
                            self.storage.antiaim.manual_input = globals.curtime()
                        elseif ui.get(self.ui.manual_left) then
                            self.storage.antiaim.manual_aa = 0
                            self.storage.antiaim.manual_input = globals.curtime()
                        end
                    elseif self.storage.antiaim.manual_aa == 2 then
                        if ui.get(self.ui.manual_left) then
                            self.storage.antiaim.manual_aa = 1
                            self.storage.antiaim.manual_input = globals.curtime()
                        elseif ui.get(self.ui.manual_forward) then
                            self.storage.antiaim.manual_aa = 3
                            self.storage.antiaim.manual_input = globals.curtime()
                        elseif ui.get(self.ui.manual_right) then
                            self.storage.antiaim.manual_aa = 0
                            self.storage.antiaim.manual_input = globals.curtime()
                        end
                    elseif self.storage.antiaim.manual_aa == 3 then
                        if ui.get(self.ui.manual_forward) then
                            self.storage.antiaim.manual_aa = 0
                            self.storage.antiaim.manual_input = globals.curtime()
                        elseif ui.get(self.ui.manual_left) then
                            self.storage.antiaim.manual_aa = 1
                            self.storage.antiaim.manual_input = globals.curtime()
                        elseif ui.get(self.ui.manual_right) then
                            self.storage.antiaim.manual_aa = 2
                            self.storage.antiaim.manual_input = globals.curtime()
                        end
                    end
                end
                if self.storage.antiaim.manual_aa == 1 or self.storage.antiaim.manual_aa == 2 or self.storage.antiaim.manual_aa == 3 then
                    self.storage.antiaim.ignora_aa_manual = true;
                    if self.storage.antiaim.manual_aa == 1 then
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[1], "off");
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[2], 0);
                        ui.set(self.storage.reference.anti_aim.body_yaw[1], "static");
                        ui.set(self.storage.reference.anti_aim.body_yaw[2], -180);
                        ui.set(self.storage.reference.anti_aim.yaw_base, "local view");
                        ui.set(self.storage.reference.anti_aim.yaw[1], "180");
                        ui.set(self.storage.reference.anti_aim.yaw[2], -90);
                        ui.set(self.storage.reference.anti_aim.pitch[1], "minimal")
                    elseif self.storage.antiaim.manual_aa == 2 then
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[1], "off");
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[2], 0);
                        ui.set(self.storage.reference.anti_aim.body_yaw[1], "static");
                        ui.set(self.storage.reference.anti_aim.body_yaw[2], -180);
                        ui.set(self.storage.reference.anti_aim.yaw_base, "local view");
                        ui.set(self.storage.reference.anti_aim.yaw[1], "180");
                        ui.set(self.storage.reference.anti_aim.yaw[2], 90);
                        ui.set(self.storage.reference.anti_aim.pitch[1], "minimal")
                    elseif self.storage.antiaim.manual_aa == 3 then
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[1], "off");
                        ui.set(self.storage.reference.anti_aim.yaw_jitter[2], 0);
                        ui.set(self.storage.reference.anti_aim.body_yaw[1], "static");
                        ui.set(self.storage.reference.anti_aim.body_yaw[2], -180);
                        ui.set(self.storage.reference.anti_aim.yaw_base, "at targets");
                        ui.set(self.storage.reference.anti_aim.yaw[1], "180");
                        ui.set(self.storage.reference.anti_aim.yaw[2], 180);
                        ui.set(self.storage.reference.anti_aim.pitch[1], "minimal")
                    end
                else
                    self.storage.antiaim.ignora_aa_manual = false;
                end
            else
                self.storage.antiaim.manual_input = 0;
                self.storage.antiaim.ignora_aa_manual = false;
            end

            if ui.get(self.ui.fl_exploit) and not ui.get(self.storage.reference.other.fakeducking) then
                if ui.get(self.storage.reference.other.double_tap[2]) or ui.get(self.storage.reference.other.hide_shots[2]) then
                    ui.set(self.storage.reference.other.fakelag_limit, 1) 
                else
                    ui.set(self.storage.reference.other.fakelag_limit, 14)
                end
            else
                ui.set(self.storage.reference.other.fakelag_limit, 14)
            end
        else
            self.storage.antiaim.manual_input = 0;
            self.storage.antiaim.ignora_aa_manual = false;
            self.storage.antiaim.ignora_aa_anti_knife = false;
            self.storage.antiaim.ignora_aa_safe_knife_zeus = false;
            ui.set(self.storage.reference.other.fakelag_limit, 14)
        end

        if self.storage.antiaim.ignora_aa_manual == false and self.storage.antiaim.ignora_aa_safe_knife_zeus == false and self.storage.antiaim.ignora_aa_anti_knife == false then
            if args.chokedcommands == 0 then
                ui.set(self.storage.reference.anti_aim.pitch[1], self.storage.antiaim.pitch)
                ui.set(self.storage.reference.anti_aim.pitch[2], self.storage.antiaim.pitch_value)
                ui.set(self.storage.reference.anti_aim.yaw_base, self.storage.antiaim.yaw_base)
                ui.set(self.storage.reference.anti_aim.yaw[1], self.storage.antiaim.yaw)
                ui.set(self.storage.reference.anti_aim.yaw[2], self.storage.antiaim.yaw_value)
                ui.set(self.storage.reference.anti_aim.yaw_jitter[1], self.storage.antiaim.yaw_jitter)
                ui.set(self.storage.reference.anti_aim.yaw_jitter[2], self.storage.antiaim.yaw_jitter_value)
                ui.set(self.storage.reference.anti_aim.body_yaw[1], self.storage.antiaim.body_yaw)
                ui.set(self.storage.reference.anti_aim.body_yaw[2], self.storage.antiaim.body_yaw_value)
                ui.set(self.storage.reference.anti_aim.roll_offset, self.storage.antiaim.roll)
                ui.set(self.storage.reference.anti_aim.freestanding_body_yaw, self.storage.antiaim.fs_body_yaw)    
            end
        end
    end;

    table_contains = function(self, source, target)
        local source_element = ui.get(source)
        for id, name in pairs(source_element) do
            if name == target then
                return true
            end
        end
    
        return false
    end;

    anim_legs = function (self, args)
        self.storage.animations.is_on_ground = args.in_jump == 0

        if self:table_contains(self.ui.misc.animbreaker, "legs on ground") then
            ui.set(self.storage.reference.other.legs, args.command_number % 3 == 0 and "Off" or "Always slide")
        end
    end;

    get_entities = function(self, enemy_only, alive_only)
        local enemy_only = enemy_only ~= nil and enemy_only or false
        local alive_only = alive_only ~= nil and alive_only or true
        
        local result = {}
        local player_resource = entity.get_player_resource()
        
        for player = 1, globals.maxplayers() do
            local is_enemy, is_alive = true, true
            
            if enemy_only and not entity.is_enemy(player) then is_enemy = false end
            if is_enemy then
                if alive_only and entity.get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
                if is_alive then table.insert(result, player) end
            end
        end
    
        return result
    end;

    vec_substract = function(self, a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end;
    vec_lenght = function(self, x, y) return (x * x + y * y) end;

    --tab system
    rect_outline = function(self, x, y, w, h, r, g, b, a, t)
        renderer.rectangle(x, y, w - t, t, r, g, b, a)
        renderer.rectangle(x, y + t, t, h - t, r, g, b, a)
        renderer.rectangle(x + w - t, y, t, h - t, r, g, b, a)
        renderer.rectangle(x + t, y + h - t, w - t, t, r, g, b, a)
    end;
    gs_window = function (self, x, y, w, h, alpha, grad)
        local inbounds = { x = x + 6, y = y + (grad and 10 or 6), w = w - 12, h = h - (grad and 16 or 12) }
    
        renderer.texture(self.storage.tab_system.bgtexture, inbounds.x, inbounds.y, inbounds.w, inbounds.h, 255,255,255,255 * alpha, "r")
    
        self:rect_outline(x, y, w, h, 12, 12, 12, 255 * alpha, 1)
        self:rect_outline(x + 1, y + 1, w - 2, h - 2, 60, 60, 60, 255 * alpha, 1)
        self:rect_outline(x + 2, y + 2, w - 4, h - 4, 40, 40, 40, 255 * alpha, 3)
        self:rect_outline(x + 5, y + 5, w - 10, h - 10, 60, 60, 60, 255 * alpha, 1)
    
        if grad then
            self:rect_outline(x + 6, y + 6, w - 12, 4, 12, 12, 12, 255 * alpha, 1)
            renderer.rectangle(x + 7, y + 8, w - 14, 1, 3, 2, 13, 255 * alpha)
    
            local alphas = { 255, 128 }
            local width = math.floor(w / 2) - 12
            local width2 = x + w - (x + width) - 12
        
            for i = 1, 2 do
                local a = alphas[i] * alpha
                renderer.gradient(x + 6, y + i + 5, width, 1, 55, 177, 218, a, 201, 84, 192, a, true)
                renderer.gradient(x + width + 6, y + i + 5, width2, 1, 201, 84, 192, a, 204, 227, 54, a, true)
            end
        end
    
        return inbounds
    end;
    current_skeet_tab_check = function (self)
        local pos = { ui.menu_position() }
        local m_pos = { ui.mouse_position() }
        for i = 1, 9 do
            local offset = { self.storage.tab_system.size.x, self.storage.tab_system.size.y + self.storage.tab_system.size.h * (i - 1) }
            if m_pos[1] >= pos[1] + offset[1] and m_pos[1] <= pos[1] + self.storage.tab_system.size.w + offset[1] and m_pos[2] >= pos[2] + offset[2] and m_pos[2] <= pos[2] + self.storage.tab_system.size.h + offset[2] then
                return i
            end
        end
        return self.storage.tab_system.skeet_cur_tab
    end;
    current_tab_check = function (self, menu, cont, box_widths, mouse_pos)
        local prev_end_pos = cont.x
        for i = 1, 4 do
            local x = prev_end_pos
            local y = cont.y
            local width = box_widths[i]
            local height = cont.h
            if mouse_pos.x >= x and mouse_pos.x < x + width and mouse_pos.y >= y and mouse_pos.y <= y + height then
                return i
            end
            prev_end_pos = prev_end_pos + box_widths[i]
        end
        return self.storage.tab_system.cur_tab
    end;

    do_icons_setup = function (self)
        self.library['icons'].hero.get_texture("users", "solid", { 255, 255, 255 }, 48, function(texture)
            if (not texture) then
                error("failed to fetch antiaim icon texture")
            end
            self.storage.tab_system.icons.antiaim = texture
        end)
        self.library['icons'].hero.get_texture("wrench", "solid", { 255, 255, 255 }, 48, function(texture)
            if (not texture) then
                error("failed to fetch misc icon texture")
            end
            self.storage.tab_system.icons.misc = texture
        end)
        self.library['icons'].hero.get_texture("eye", "solid", { 255, 255, 255 }, 48, function(texture)
            if (not texture) then
                error("failed to fetch visuals icon texture")
            end
            self.storage.tab_system.icons.visuals = texture
        end)
        self.library['icons'].hero.get_texture("cog", "solid", { 255, 255, 255 }, 48, function(texture)
            if (not texture) then
                error("failed to fetch config icon texture")
            end
            self.storage.tab_system.icons.cfg = texture
        end)
    end;

    do_icons_tab_render = function (self)
        if not self.storage.tab_system.m1_down and client.key_state(0x01) then
            self.storage.tab_system.m1_down = true
            self.storage.tab_system.skeet_cur_tab = self:current_skeet_tab_check()
        end
        if not client.key_state(0x01) then 
            self.storage.tab_system.m1_down = false 
        end
        if self.storage.tab_system.skeet_cur_tab ~= 2 then return end
        local menu_pos_x, menu_pos_y = ui.menu_position()
        local menu_siz_x, menu_siz_y = ui.menu_size()
        local gs_window = self:gs_window(menu_pos_x, menu_pos_y - 70, menu_siz_x, 70, 1, true)
        local box_widths = {}
        local prev_end_pos = gs_window.x
        local base_width = math.floor(gs_window.w / 4)
        local total_gap = gs_window.w - base_width * 4
        for i = 1, 4 do
            if total_gap > 0 then
                box_widths[i] = base_width + 1
                total_gap = total_gap - 1
            else
                box_widths[i] = base_width
            end
            if i == self.storage.tab_system.cur_tab then
                renderer.rectangle(prev_end_pos, gs_window.y, box_widths[i], gs_window.h, 255, 255, 255, 255 * 0.026)
            end
            if i == 1 then
                renderer.texture(self.storage.tab_system.icons.antiaim, prev_end_pos + (box_widths[1] / 2) - 24, gs_window["y"], 48, 48, 255, 255, 255, 255, "f")
            elseif i == 2 then
                renderer.texture(self.storage.tab_system.icons.visuals, prev_end_pos + (box_widths[2] / 2) - 24, gs_window["y"], 48, 48, 255, 255, 255, 255, "f")
            elseif i == 3 then
                renderer.texture(self.storage.tab_system.icons.misc, prev_end_pos + (box_widths[3] / 2) - 24, gs_window["y"], 48, 48, 255, 255, 255, 255, "f")
            elseif i == 4 then
                renderer.texture(self.storage.tab_system.icons.cfg, prev_end_pos + (box_widths[4] / 2) - 24, gs_window["y"], 48, 48, 255, 255, 255, 255, "f")
            end
            prev_end_pos = prev_end_pos + box_widths[i]
        end

        if client.key_state(0x01) then
            self.storage.tab_system.cur_tab = self:current_tab_check(menu, gs_window, box_widths, self.library['vector'](ui.mouse_position()))
        end
        if self.storage.tab_system.cur_tab == 1 then
            self.ui.tab_selector = "anti aim"
        elseif self.storage.tab_system.cur_tab == 2 then
            self.ui.tab_selector = "visuals"
        elseif self.storage.tab_system.cur_tab == 3 then
            self.ui.tab_selector = "misc"
        elseif self.storage.tab_system.cur_tab == 4 then
            self.ui.tab_selector = "config"
        end
    end;

    do_watermark = function (self)
        local x, y = client.screen_size()
        renderer.text(x / 2, y - 15, 255, 255, 255, 255, ui.get(self.ui.visuals.watermark_size) == "small" and "cb" or "+cb", nil, self.support_function:text_fade_animation(1, 131, 139, 226, 255, "ELDERS.SYSTEMATIC"))
    end;

    do_indicator = function (self)
        local x, y = client.screen_size()
        local local_player = entity.get_local_player()
        if not local_player or not entity.is_alive(local_player) then
            return
        end
        local indicator_c = { ui.get(self.ui.visuals.indicator_color) }
        local indicator_b_c = { ui.get(self.ui.visuals.defensive_box_color) }
        local indicator_f_g_c = { ui.get(self.ui.visuals.defensive_first_gradient_color) }
        local indicator_l_g_c = { ui.get(self.ui.visuals.defensive_last_gradient_color) }
        renderer.text(x / 2, y / 2 + 18, indicator_c[1], indicator_c[2], indicator_c[3], self.storage.visuals.min_dmg_lerp, "c", nil, "min dmg: " ..ui.get(self.storage.reference.other.min_dmg[3]))
        renderer.text(x / 2, y / 2 + 18 + self.storage.visuals.to_add_mindmg_lerp, indicator_c[1], indicator_c[2], indicator_c[3], self.storage.visuals.hide_shots_lerp, "c", nil, "on shot")
        renderer.text(x / 2, y / 2 + 18 + self.storage.visuals.to_add_mindmg_lerp + self.storage.visuals.to_add_hs_lerp, indicator_c[1], indicator_c[2], indicator_c[3], self.storage.visuals.double_tap_lerp, "c", nil, "double tap")
        renderer.rectangle(x / 2 - 25, y / 2 + 27 + self.storage.visuals.to_add_mindmg_lerp + ((ui.get(self.storage.reference.other.double_tap[1]) and ui.get(self.storage.reference.other.double_tap[2])) and self.storage.visuals.to_add_hs_lerp or 0), 50, 7, indicator_b_c[1], indicator_b_c[2], indicator_b_c[3], self.storage.visuals.defensive_alpha_lerp)
        renderer.gradient(x / 2 - 23, y / 2 + 29 + self.storage.visuals.to_add_mindmg_lerp + ((ui.get(self.storage.reference.other.double_tap[1]) and ui.get(self.storage.reference.other.double_tap[2])) and self.storage.visuals.to_add_hs_lerp or 0), self.storage.visuals.defensive_lerp, 3, indicator_f_g_c[1], indicator_f_g_c[2], indicator_f_g_c[3], self.storage.visuals.defensive_alpha_lerp, indicator_l_g_c[1], indicator_l_g_c[2], indicator_l_g_c[3], indicator_l_g_c[4], true)
    end;

    do_manual_arrows = function (self)
        local x, y = client.screen_size()
        local local_player = entity.get_local_player()
        if not local_player or not entity.is_alive(local_player) then
            return
        end
        local velocity = self:velocity(local_player)
        local velocity_to_render = velocity * 45 / 400
        renderer.text(x / 2 - self.storage.visuals.arrows_lerp + -velocity_to_render, y / 2 , 255, 255, 255, self.storage.antiaim.manual_aa == 1 and 100 or 255, "cbr", 0, "⮜")
        renderer.text(x / 2 + self.storage.visuals.arrows_lerp + velocity_to_render, y / 2 , 255, 255, 255, self.storage.antiaim.manual_aa == 2 and 100 or 255, "cbr", 0, "⮞")
    end;

    do_callback = function (self)
        ui.set_callback(ui.reference("MISC", "Settings", "DPI scale"), function(args)
            dpi    = tonumber(ui.get(args):sub(1, 3)) * 0.01
            self.storage.tab_system.size.w = self.storage.tab_system.size.default.w * dpi
            self.storage.tab_system.size.h = self.storage.tab_system.size.default.h * dpi
        end, true)
        client.set_event_callback("paint_ui", function ()
            if ui.is_menu_open() then
                self:do_icons_tab_render()
                if self.storage.tab_system.cur_tab == 1 then
                    ui.set(self.ui.tab_label, "hi "..self.support_function:text_fade_animation(1, 131, 139, 226, 255, _G.elders_username).." \aFFFFFFFF~ anti aim")
                elseif self.storage.tab_system.cur_tab == 2 then
                    ui.set(self.ui.tab_label, "hi "..self.support_function:text_fade_animation(1, 131, 139, 226, 255, _G.elders_username).." \aFFFFFFFF~ visuals")
                elseif self.storage.tab_system.cur_tab == 3 then
                    ui.set(self.ui.tab_label, "hi "..self.support_function:text_fade_animation(1, 131, 139, 226, 255, _G.elders_username).." \aFFFFFFFF~ misc")
                elseif self.storage.tab_system.cur_tab == 4 then
                    ui.set(self.ui.tab_label, "hi "..self.support_function:text_fade_animation(1, 131, 139, 226, 255, _G.elders_username).." \aFFFFFFFF~ config")
                end
                
                for i = 1, #self.builder_state do
                    local selecte = ui.get(self.ui.aabuilder_state)
                    local is_antiaim_tab = self.ui.tab_selector == "anti aim"
                    local conditions_enabled = ui.get(self.ui.antiaim_elements[i].enable)
                    local show_ = is_antiaim_tab and selecte == self.builder_state[i] and conditions_enabled
                    ui.set_visible(self.ui.antiaim_elements[i].enable, is_antiaim_tab and selecte == self.builder_state[i] and i > 1)
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch, show_)
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_pitch) == "custom")
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_base, show_)
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw, show_)
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_mode, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw) ~= "off")
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_static_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "static")
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_left_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "left / right" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "tickbase delayed" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "flick" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "random l / r"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_right_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "left / right" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "tickbase delayed" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "flick" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "random l / r"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_delay_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "tickbase delayed" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "flick"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_1way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_2way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_3way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_4way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "5 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_5way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) == "5 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter, show_)
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter) ~= "off")
                    ui.set_visible(self.ui.antiaim_elements[i].correcting_body_yaw, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) ~= "tickbase delayed")
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_static_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "static")
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_left_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "left / right" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "random l / r"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_right_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "left / right" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "random l / r"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_1way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_2way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_3way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_4way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "5 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_5way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter) ~= "off" and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_mode) == "5 way"))
                    
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_body_yaw, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) ~= "tickbase delayed")
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_body_yaw_static_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_body_yaw) ~= "off" and ui.get(self.ui.antiaim_elements[i].correcting_body_yaw) == false and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_mode) ~= "tickbase delayed")
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_roll, show_)
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_freestanding_body_yaw, show_)
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_freestanding_mode, show_)
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_defensive, show_)
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_defensive_force, show_)
                    
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_defensive))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_defensive))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_defensive_override, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_defensive))

                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive) == "custom") 
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_slider_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive) == "custom" and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "static"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_first_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive) == "custom" and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "jitter" or ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "tickbase delayed" or ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "flick" or ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "random"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_second_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive) == "custom" and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "jitter" or ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "tickbase delayed" or ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "flick" or ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "random"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_delay_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive) == "custom" and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "tickbase delayed" or ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "flick"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_1way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive) == "custom" and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_2way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive) == "custom" and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_3way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive) == "custom" and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_4way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive) == "custom" and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "5 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_pitch_5way_slider, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive) == "custom" and ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_pitch_defensive_mode) == "5 way"))
                    
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive) ~= "off") 
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_static_slider_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "static"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_first_slider_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "jitter" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "tickbase delayed" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "flick" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "random"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_second_slider_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "jitter" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "tickbase delayed" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "flick" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "random"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_delay_slider_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "tickbase delayed" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "flick"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_1way_slider_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_2way_slider_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_3way_slider_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "5 way" or ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "3 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_4way_slider_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "5 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_5way_slider_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive) ~= "off" and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and (ui.get(self.ui.antiaim_elements[i].antiaim_yaw_defensive_mode) == "5 way"))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_defensive_override))
                    ui.set_visible(self.ui.antiaim_elements[i].antiaim_yaw_jitter_static_slider_defensive, show_ and ui.get(self.ui.antiaim_elements[i].antiaim_defensive) and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_defensive_override) and ui.get(self.ui.antiaim_elements[i].antiaim_yaw_jitter_defensive) ~= "off")
                end
            end

            
            self:setup_skeet_element("vis_elem", self.ui.visuals.watermark_size, self.ui.tab_selector == "visuals", nil)
            self:setup_skeet_element("vis_elem", self.ui.visuals.manual_arrows, self.ui.tab_selector == "visuals", nil)

            self:setup_skeet_element("vis_elem", self.ui.visuals.indicator, self.ui.tab_selector == "visuals", nil)
            self:setup_skeet_element("vis_elem", self.ui.visuals.indicator_color, self.ui.tab_selector == "visuals" and ui.get(self.ui.visuals.indicator), nil)
            self:setup_skeet_element("vis_elem", self.ui.visuals.defensive_box_color, self.ui.tab_selector == "visuals" and ui.get(self.ui.visuals.indicator), nil)
            self:setup_skeet_element("vis_elem", self.ui.visuals.defensive_last_gradient_color, self.ui.tab_selector == "visuals" and ui.get(self.ui.visuals.indicator), nil)
            self:setup_skeet_element("vis_elem", self.ui.visuals.defensive_box_color_txt, self.ui.tab_selector == "visuals" and ui.get(self.ui.visuals.indicator), nil)
            self:setup_skeet_element("vis_elem", self.ui.visuals.defensive_last_gradient_color_txt, self.ui.tab_selector == "visuals" and ui.get(self.ui.visuals.indicator), nil)
            self:setup_skeet_element("vis_elem", self.ui.visuals.defensive_first_gradient_color, self.ui.tab_selector == "visuals" and ui.get(self.ui.visuals.indicator), nil)
            self:setup_skeet_element("vis_elem", self.ui.visuals.defensive_first_gradient_color_txt, self.ui.tab_selector == "visuals" and ui.get(self.ui.visuals.indicator), nil)

            self:setup_skeet_element("vis_elem", self.ui.misc.clantag, self.ui.tab_selector == "misc", nil)
            self:setup_skeet_element("vis_elem", self.ui.misc.killsay, self.ui.tab_selector == "misc", nil)
            self:setup_skeet_element("vis_elem", self.ui.misc.aimbot_logs, self.ui.tab_selector == "misc", nil)
            self:setup_skeet_element("vis_elem",  self.ui.misc.animbreaker, self.ui.tab_selector == "misc", nil)

            self:setup_skeet_element("vis_elem", self.ui.config.list, self.ui.tab_selector == "config", nil)
            self:setup_skeet_element("vis_elem", self.ui.config.name, self.ui.tab_selector == "config", nil)
            self:setup_skeet_element("vis_elem", self.ui.config.load, self.ui.tab_selector == "config", nil)
            self:setup_skeet_element("vis_elem", self.ui.config.save, self.ui.tab_selector == "config", nil)
            self:setup_skeet_element("vis_elem", self.ui.config.delete, self.ui.tab_selector == "config", nil)
            self:setup_skeet_element("vis_elem", self.ui.config.import, self.ui.tab_selector == "config", nil)
            self:setup_skeet_element("vis_elem", self.ui.config.export, self.ui.tab_selector == "config", nil)
            self:setup_skeet_element("vis_elem", self.ui.aabuilder_state, self.ui.tab_selector == "anti aim", nil)
            self:setup_skeet_element("vis_elem", self.ui.extra_switch, self.ui.tab_selector == "anti aim", nil)
            self:setup_skeet_element("vis_elem", self.ui.extra_selector, self.ui.tab_selector == "anti aim" and ui.get(self.ui.extra_switch), nil)
            self:setup_skeet_element("vis_elem", self.ui.legit_aa_key, self.ui.tab_selector == "anti aim" and ui.get(self.ui.extra_switch) and ui.get(self.ui.extra_selector) == "binds", nil)
            self:setup_skeet_element("vis_elem", self.ui.manual_left, self.ui.tab_selector == "anti aim" and ui.get(self.ui.extra_switch) and ui.get(self.ui.extra_selector) == "binds", nil)
            self:setup_skeet_element("vis_elem", self.ui.manual_right, self.ui.tab_selector == "anti aim" and ui.get(self.ui.extra_switch) and ui.get(self.ui.extra_selector) == "binds", nil)
            self:setup_skeet_element("vis_elem", self.ui.manual_forward, self.ui.tab_selector == "anti aim" and ui.get(self.ui.extra_switch) and ui.get(self.ui.extra_selector) == "binds", nil)
            self:setup_skeet_element("vis_elem", self.ui.freestanding, self.ui.tab_selector == "anti aim" and ui.get(self.ui.extra_switch) and ui.get(self.ui.extra_selector) == "binds", nil)
            self:setup_skeet_element("vis_elem", self.ui.edgeyaw, self.ui.tab_selector == "anti aim" and ui.get(self.ui.extra_switch) and ui.get(self.ui.extra_selector) == "binds", nil)
            self:setup_skeet_element("vis_elem", self.ui.fl_exploit, self.ui.tab_selector == "anti aim" and ui.get(self.ui.extra_switch) and ui.get(self.ui.extra_selector) ~= "binds", nil)
            self:setup_skeet_element("vis_elem", self.ui.anti_knife, self.ui.tab_selector == "anti aim" and ui.get(self.ui.extra_switch) and ui.get(self.ui.extra_selector) ~= "binds", nil)
            self:setup_skeet_element("vis_elem", self.ui.safe_knife_zeus, self.ui.tab_selector == "anti aim" and ui.get(self.ui.extra_switch) and ui.get(self.ui.extra_selector) ~= "binds", nil)
            
            self:setup_skeet_element("elem", self.ui.manual_left, "On hotkey", nil)
            self:setup_skeet_element("elem", self.ui.manual_right, "On hotkey", nil)
            self:setup_skeet_element("elem", self.ui.manual_forward, "On hotkey", nil)
            self:setup_skeet_element("vis", nil, nil, self.ui.tab_selector == "debug" and "unload" or "load")
            self:setup_skeet_element("elem", self.storage.reference.anti_aim.master, true, nil)
            self:setup_skeet_element("elem", self.ui.antiaim_elements[1].enable, true, nil)
            self:setup_skeet_element("vis_elem", self.ui.antiaim_elements[1].enable, false, nil)
            self:setup_skeet_element("vis_elem", self.ui.antiaim_elements[10].antiaim_freestanding_mode, false, nil)

            self:do_watermark()
            if ui.get(self.ui.visuals.manual_arrows) then
                self:do_manual_arrows()
            end
            self:do_indicator()
            if self:sim_diff() <= -1 and self.storage.aa_functions.to_start == false then
                self.storage.aa_functions.can_defensive = true
            end
            self.storage.visuals.arrows_lerp = self.support_function:lerp(self.storage.visuals.arrows_lerp, ui.get(self.ui.visuals.manual_arrows) and 35 or 0, globals.frametime() * 15)
            self.storage.visuals.defensive_lerp = self.support_function:lerp(self.storage.visuals.defensive_lerp, (self.storage.antiaim.defensive.defensive > 1 and self.storage.antiaim.defensive.defensive < 14) and ui.get(self.ui.visuals.indicator) and 50 or 0, globals.frametime() * 15)
            self.storage.visuals.defensive_alpha_lerp = self.support_function:lerp(self.storage.visuals.defensive_alpha_lerp, (self.storage.antiaim.defensive.defensive > 1 and self.storage.antiaim.defensive.defensive < 14) and ui.get(self.ui.visuals.indicator) and 255 or 0, globals.frametime() * 15)
            self.storage.visuals.double_tap_lerp = self.support_function:lerp(self.storage.visuals.double_tap_lerp, (ui.get(self.storage.reference.other.double_tap[1]) and ui.get(self.storage.reference.other.double_tap[2])) and ui.get(self.ui.visuals.indicator) and 255 or 0, globals.frametime() * 15)
            self.storage.visuals.hide_shots_lerp = self.support_function:lerp(self.storage.visuals.hide_shots_lerp, (ui.get(self.storage.reference.other.hide_shots[1]) and ui.get(self.storage.reference.other.hide_shots[2])) and ui.get(self.ui.visuals.indicator) and 255 or 0, globals.frametime() * 15)
            self.storage.visuals.min_dmg_lerp = self.support_function:lerp(self.storage.visuals.min_dmg_lerp, (ui.get(self.storage.reference.other.min_dmg[1]) and ui.get(self.storage.reference.other.min_dmg[2])) and ui.get(self.ui.visuals.indicator) and 255 or 0, globals.frametime() * 15)
            self.storage.visuals.to_add_hs_lerp = self.support_function:lerp(self.storage.visuals.to_add_hs_lerp, (ui.get(self.storage.reference.other.hide_shots[1]) and ui.get(self.storage.reference.other.hide_shots[2])) and ui.get(self.ui.visuals.indicator) and 12 or 0, globals.frametime() * 15)
            self.storage.visuals.to_add_mindmg_lerp = self.support_function:lerp(self.storage.visuals.to_add_mindmg_lerp, (ui.get(self.storage.reference.other.min_dmg[1]) and ui.get(self.storage.reference.other.min_dmg[2])) and ui.get(self.ui.visuals.indicator) and 12 or 0, globals.frametime() * 15)
        end)
        client.set_event_callback("pre_render", function()
            local local_player = entity.get_local_player()
            if not local_player or not entity.is_alive(local_player) then
                return
            end
        
            local self_index = self.library['entity'].new(local_player)
            local self_anim_state = self_index:get_anim_state()
        
            if not self_anim_state then
                return
            end

            if self:table_contains(self.ui.misc.animbreaker, "static in air") then
                entity.set_prop(local_player, "m_flPoseParameter", 0.75, self.storage.animations.E_POSE_PARAMETERS.JUMP_FALL)
            end

            if self:table_contains(self.ui.misc.animbreaker, "legs on ground") then
                entity.set_prop(local_player, "m_flPoseParameter", self.storage.animations.E_POSE_PARAMETERS.STAND, globals.tickcount() % 4 > 1 and 0.01 or 1)
            end

            if self:table_contains(self.ui.misc.animbreaker, "body lean") then
                local self_anim_overlay = self_index:get_anim_overlay(12)
                if not self_anim_overlay then
                    return
                end
        
                local x_velocity = entity.get_prop(local_player, "m_vecVelocity[0]")
                if math.abs(x_velocity) >= 3 then
                    self_anim_overlay.weight = 0.75
                end
            end

            if self:table_contains(self.ui.misc.animbreaker, "pitch on land") then
                if not self_anim_state.hit_in_ground_animation or not self.storage.animations.is_on_ground then
                    return
                end
        
                entity.set_prop(local_player, "m_flPoseParameter", 0.5, self.storage.animations.E_POSE_PARAMETERS.BODY_PITCH)
            end 
        end)
        client.set_event_callback('net_update_end', function()
            if ui.get(self.storage.reference.other.gs_clantag) then 
                return 
            end
            local cur = math.floor(globals.tickcount() / 20) % #self.storage.clantag.clan_tags
            local clantag = self.storage.clantag.clan_tags[cur+1]
        
            if ui.get(self.ui.misc.clantag) then
                if clantag ~= self.storage.clantag.clantag_prev then
                    self.storage.clantag.clantag_prev = clantag
                    client.set_clan_tag(clantag)
                end
            end
        end)
        client.set_event_callback('net_update_end', function()
            local me = entity.get_local_player()
            local players = self:get_entities(true, true)
            local m_tick_base = entity.get_prop(me, 'm_nTickBase')
            
            self.storage.cl_data.tick_shifted = false
            
            if m_tick_base ~= nil then
                if self.storage.cl_data.tick_base ~= 0 and m_tick_base < self.storage.cl_data.tick_base then
                    self.storage.cl_data.tick_shifted = true
                end
            
                self.storage.cl_data.tick_base = m_tick_base
            end
        
            for i=1, #players do
                local idx = players[i]
                local prev_tick = self.storage.g_sim_ticks[idx]
                
                if entity.is_dormant(idx) or not entity.is_alive(idx) then
                    self.storage.g_sim_ticks[idx] = nil
                    self.storage.g_net_data[idx] = nil
                else
                    local player_origin = { entity.get_origin(idx) }
                    local simulation_time = toticks(entity.get_prop(idx, 'm_flSimulationTime'))
            
                    if prev_tick ~= nil then
                        local delta = simulation_time - prev_tick.tick
        
                        if delta < 0 or delta > 0 and delta <= 64 then
                            local m_fFlags = entity.get_prop(idx, 'm_fFlags')
        
                            local diff_origin = self:vec_substract(player_origin, prev_tick.origin)
                            local teleport_distance = self:vec_lenght(diff_origin[1], diff_origin[2])
        
                            self.storage.g_net_data[idx] = {
                                tick = delta-1,
                                origin = player_origin,
                                tickbase = delta < 0,
                                lagcomp = teleport_distance > 4096,
                            }
                        end
                    end
        
                    self.storage.g_sim_ticks[idx] = {
                        tick = simulation_time,
                        origin = player_origin,
                    }
                end
            end
        end)
        ui.set_callback(self.ui.misc.clantag, function() client.set_clan_tag('\0') end)
        client.set_event_callback("player_death", function(e)
            if not ui.get(self.ui.misc.killsay) then return end
            if client.userid_to_entindex(e.target) == entity.get_local_player() then return end
            if client.userid_to_entindex(e.attacker) == entity.get_local_player() then
                local random_number = math.random(1, #self.storage.kill_say_text)
                client.exec("say " .. self.storage.kill_say_text[random_number])
            end
        end)
        client.set_event_callback('aim_fire', function (e)
            local data = e
            local plist_sp = plist.get(e.target, 'Override safe point')
            local plist_fa = plist.get(e.target, 'Correction active')
            local sp_checkbox = ui.get(ui.reference('RAGE', 'Aimbot', 'Force safe point'))
            if self.storage.g_net_data[e.target] == nil then
                self.storage.g_net_data[e.target] = { }
            end
        
            data.tick = e.tick
        
            data.eye = self.library['vector'](client.eye_position)
            data.shot = self.library['vector'](e.x, e.y, e.z)
        
            data.teleported = self.storage.g_net_data[e.target].lagcomp or false
            data.choke = self.storage.g_net_data[e.target].tick or '?'
            data.self_choke = globals.chokedcommands()
            data.correction = plist_fa and 1 or 0
            data.safe_point = ({
                ['Off'] = 'off',
                ['On'] = true,
                ['-'] = sp_checkbox
            })[plist_sp]
        
            self.storage.g_aimbot_data[e.id] = data
        end)
        client.set_event_callback('aim_hit', function (e)
            local on_fire_data = self.storage.g_aimbot_data[e.id]
            local name = string.lower(entity.get_player_name(e.target))
            local hgroup = self.storage.hitgroup_names[e.hitgroup + 1] or '?'
            local aimed_hgroup = self.storage.hitgroup_names[on_fire_data.hitgroup + 1] or '?'
            local hitchance = math.floor(on_fire_data.hit_chance + 0.5) .. '%'
            local health = entity.get_prop(e.target, 'm_iHealth')

            if ui.get(self.ui.misc.aimbot_logs) then
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, string.format('[%d] Hit %s\'s %s for %i(%d) (%i remaining) aimed=%s(%s) sp=%s LC=%s TC=%s', e.id, name, hgroup, e.damage, on_fire_data.damage, health, aimed_hgroup, hitchance, on_fire_data.safe_point, on_fire_data.self_choke, on_fire_data.choke))
            end
        end)
        client.set_event_callback('aim_miss', function (e)
            local on_fire_data = self.storage.g_aimbot_data[e.id]
            local name = string.lower(entity.get_player_name(e.target))
            local hgroup = self.storage.hitgroup_names[e.hitgroup + 1] or '?'
            local hitchance = math.floor(on_fire_data.hit_chance + 0.5) .. '%'
            local reason = e.reason == '?' and 'unknown' or e.reason

            if ui.get(self.ui.misc.aimbot_logs) then
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, string.format('[%d] Missed %s\'s %s(%i)(%s) due to %s', e.id, name, hgroup, on_fire_data.damage, hitchance, e.reason))
            end
        end)
        client.set_event_callback("setup_command", function (args)
            if args.chokedcommands > 1 then
                self.storage.aa_functions.def_ticks = 0
                args.force_defensive = false
                self.storage.antiaim.defensive.defensive = 0
            end
            self:run_antiaim(args)
            self:movementjitter()
            self:anim_legs(args)
        end)
        client.set_event_callback("run_command", function (args)
            self:check_charge(args)
            self:defensive_run(args)
        end)
        client.set_event_callback("predict_command", function (args)
            self:defensive_setup(args)
        end)
        client.set_event_callback("round_start", function ()
            self.storage.antiaim.manual_input = 0;
            self.storage.antiaim.manual_aa = 0;
            self.storage.antiaim.ignora_aa_manual = false;
            self.storage.antiaim.ignora_aa_anti_knife = false;
            self.storage.antiaim.ignora_aa_safe_knife_zeus = false;
            ui.set(self.ui.manual_left, false)
            ui.set(self.ui.manual_right, false)
            ui.set(self.ui.manual_forward, false)
        end)
        client.set_event_callback("level_init", function ()
            self.storage.antiaim.defensive.defensive = 0
            self.storage.antiaim.defensive.defensive_check = 0
            self.storage.antiaim.manual_input = 0;
            self.storage.antiaim.manual_aa = 0;
            self.storage.antiaim.ignora_aa_manual = false;
            self.storage.antiaim.ignora_aa_anti_knife = false;
            self.storage.antiaim.ignora_aa_safe_knife_zeus = false;
            ui.set(self.ui.manual_left, false)
            ui.set(self.ui.manual_right, false)
            ui.set(self.ui.manual_forward, false)
        end)
        client.set_event_callback("shutdown", function ()
            self:setup_skeet_element("vis", nil, nil, "unload")
        end)
    end;
    
    __init__ = function (self)
        self.support_function:library_check();
        self:setup_skeet_element("vis", nil, nil, "load");
        self:create_menu_elements();
        self:do_icons_setup();
        self:do_callback();
        self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Welcome back ', {131, 139, 226, _G.elders_username})

        table.insert(self.storage.presets, { name = "~ Dons (7/11/23)", config = "W1sidHJ1ZSIsImNlbnRlciIsImZhbHNlIiwiMiIsIjIiLCIwIiwiMCIsImNlbnRlciIsIjAiLCJmYWxzZSIsIjAiLCJvbiBiaW5kIiwiMCIsIjQ1IiwiLTE0IiwiMCIsIjAiLCIwIiwiMCIsImxlZnQgXC8gcmlnaHQiLCIwIiwiMCIsIm1pbmltYWwiLCJ0cnVlIiwiMCIsInRydWUiLCIwIiwiLTE4MCIsIjkiLCIwIiwiaml0dGVyIiwiMCIsInRydWUiLCIxODAiLCIwIiwiMCIsIjAiLCIwIiwiMCIsIjE4MCIsInJhbmRvbSIsIjAiLCIwIiwiMTgwIiwiMCIsImZhbHNlIiwidXAiLCItODkiLCJ0cnVlIiwiMiIsIjAiLCJyYW5kb20iLCJzdGF0aWMiLCIwIiwiYXQgdGFyZ2V0cyIsIjAiLCItMiIsIjAiLCIwIiwiMCIsImZhbHNlIiwib2ZmIiwiZmFsc2UiLCIyIiwiMiIsIjAiLCIwIiwib2ZmIiwiMCIsImZhbHNlIiwiMCIsIm9mZiIsIjAiLCIwIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCJzdGF0aWMiLCIwIiwiMCIsIm9mZiIsImZhbHNlIiwiMCIsImZhbHNlIiwiMCIsIjAiLCIwIiwiMCIsIm9mZiIsIjAiLCJmYWxzZSIsIjAiLCIwIiwiMCIsIjAiLCIwIiwiMCIsIm9mZiIsInN0YXRpYyIsIjAiLCIwIiwib2ZmIiwiMCIsImZhbHNlIiwib2ZmIiwiMCIsImZhbHNlIiwiMiIsIjAiLCJzdGF0aWMiLCJzdGF0aWMiLCIwIiwiYXQgdGFyZ2V0cyIsIjAiLCIwIiwiMCIsIjAiLCIwIiwidHJ1ZSIsImNlbnRlciIsImZhbHNlIiwiMiIsIjIiLCIwIiwiMCIsIm9mZiIsIjAiLCJmYWxzZSIsIjAiLCJvbiBiaW5kIiwiMCIsIjQ1IiwiLTE0IiwiMCIsIjAiLCIwIiwiMCIsImxlZnQgXC8gcmlnaHQiLCIwIiwiMCIsIm1pbmltYWwiLCJ0cnVlIiwiMCIsInRydWUiLCIwIiwiMCIsIjE0IiwiMCIsImppdHRlciIsIjAiLCJmYWxzZSIsIjAiLCIwIiwiMCIsIjAiLCIwIiwiMCIsIm9mZiIsInN0YXRpYyIsIjAiLCIwIiwiMTgwIiwiMCIsImZhbHNlIiwib2ZmIiwiMCIsImZhbHNlIiwiMiIsIjAiLCJzdGF0aWMiLCJzdGF0aWMiLCIwIiwiYXQgdGFyZ2V0cyIsIjAiLCIwIiwiMCIsIjAiLCIwIiwiZmFsc2UiLCJvZmYiLCJmYWxzZSIsIjIiLCIyIiwiMCIsIjAiLCJvZmYiLCIwIiwiZmFsc2UiLCIwIiwib2ZmIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCIwIiwiMCIsInN0YXRpYyIsIjAiLCIwIiwib2ZmIiwiZmFsc2UiLCIwIiwiZmFsc2UiLCIwIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsImZhbHNlIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCIwIiwib2ZmIiwic3RhdGljIiwiMCIsIjAiLCJvZmYiLCIwIiwiZmFsc2UiLCJvZmYiLCIwIiwiZmFsc2UiLCIyIiwiMCIsInN0YXRpYyIsInN0YXRpYyIsIjAiLCJhdCB0YXJnZXRzIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCJ0cnVlIiwiY2VudGVyIiwiZmFsc2UiLCIyIiwiMiIsIjAiLCIwIiwib2ZmIiwiMCIsImZhbHNlIiwiMCIsIm9mZiIsIjAiLCI0MSIsIi0xMyIsIjAiLCIwIiwiMCIsIjAiLCJsZWZ0IFwvIHJpZ2h0IiwiMCIsIjAiLCJtaW5pbWFsIiwidHJ1ZSIsIjAiLCJ0cnVlIiwiMCIsIjAiLCIxNCIsIjAiLCJqaXR0ZXIiLCIwIiwiZmFsc2UiLCIwIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCJvZmYiLCJzdGF0aWMiLCIwIiwiMCIsIjE4MCIsIjAiLCJmYWxzZSIsIm9mZiIsIjAiLCJmYWxzZSIsIjIiLCIwIiwic3RhdGljIiwic3RhdGljIiwiMCIsImF0IHRhcmdldHMiLCIwIiwiMCIsIjAiLCIwIiwiMCIsInRydWUiLCJvZmYiLCJ0cnVlIiwiNCIsIjgiLCIwIiwiMCIsInNraXR0ZXIiLCIwIiwiZmFsc2UiLCIwIiwib2ZmIiwiMjkiLCIwIiwiLTE1IiwiMCIsIi0yOSIsIjcwIiwiMCIsInRpY2tiYXNlIGRlbGF5ZWQiLCIwIiwiMCIsIm1pbmltYWwiLCJmYWxzZSIsIjAiLCJ0cnVlIiwiMCIsIjY5IiwiNDUiLCIxNiIsIm9mZiIsIjAiLCJ0cnVlIiwiMTgwIiwiMCIsIi01MCIsIjAiLCIwIiwiLTIwIiwic3BpbiIsIjUgd2F5IiwiLTcwIiwiLTg5IiwiMTgwIiwiNDUiLCJmYWxzZSIsImN1c3RvbSIsIi04OSIsInRydWUiLCI4IiwiMCIsInN0YXRpYyIsInN0YXRpYyIsIjAiLCJhdCB0YXJnZXRzIiwiMTIwIiwiMCIsIjAiLCIwIiwiLTcwIiwiZmFsc2UiLCJvZmYiLCJmYWxzZSIsIjIiLCIyIiwiMCIsIjAiLCJvZmYiLCIwIiwiZmFsc2UiLCIwIiwib2ZmIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCIwIiwiMCIsInN0YXRpYyIsIjAiLCIwIiwib2ZmIiwiZmFsc2UiLCIwIiwiZmFsc2UiLCIwIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsImZhbHNlIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCIwIiwib2ZmIiwic3RhdGljIiwiMCIsIjAiLCJvZmYiLCIwIiwiZmFsc2UiLCJvZmYiLCIwIiwiZmFsc2UiLCIyIiwiMCIsInN0YXRpYyIsInN0YXRpYyIsIjAiLCJhdCB0YXJnZXRzIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCJmYWxzZSIsIm9mZiIsImZhbHNlIiwiMiIsIjIiLCIwIiwiMCIsIm9mZiIsIjAiLCJmYWxzZSIsIjAiLCJvZmYiLCIwIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCIwIiwic3RhdGljIiwiMCIsIjAiLCJvZmYiLCJmYWxzZSIsIjAiLCJmYWxzZSIsIjAiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwiZmFsc2UiLCIwIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCJvZmYiLCJzdGF0aWMiLCIwIiwiMCIsIm9mZiIsIjAiLCJmYWxzZSIsIm9mZiIsIjAiLCJmYWxzZSIsIjIiLCIwIiwic3RhdGljIiwic3RhdGljIiwiMCIsImF0IHRhcmdldHMiLCIwIiwiMCIsIjAiLCIwIiwiMCIsImZhbHNlIiwib2ZmIiwiZmFsc2UiLCIyIiwiMiIsIjAiLCIwIiwib2ZmIiwiMCIsImZhbHNlIiwiMCIsIm9mZiIsIjAiLCIwIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCJzdGF0aWMiLCIwIiwiMCIsIm9mZiIsImZhbHNlIiwiMCIsImZhbHNlIiwiMCIsIjAiLCIwIiwiMCIsIm9mZiIsIjAiLCJmYWxzZSIsIjAiLCIwIiwiMCIsIjAiLCIwIiwiMCIsIm9mZiIsInN0YXRpYyIsIjAiLCIwIiwib2ZmIiwiMCIsImZhbHNlIiwib2ZmIiwiMCIsImZhbHNlIiwiMiIsIjAiLCJzdGF0aWMiLCJzdGF0aWMiLCIwIiwiYXQgdGFyZ2V0cyIsIjAiLCIwIiwiMCIsIjAiLCIwIiwidHJ1ZSIsIm9mZiIsImZhbHNlIiwiMiIsIjIiLCIwIiwiMCIsIm9mZiIsIjAiLCJmYWxzZSIsIjAiLCJvbiBiaW5kIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCIwIiwiMCIsInN0YXRpYyIsIjAiLCIwIiwibWluaW1hbCIsImZhbHNlIiwiMCIsImZhbHNlIiwiMCIsIjAiLCIwIiwiMCIsIm9mZiIsIjAiLCJmYWxzZSIsIjAiLCIwIiwiMCIsIjAiLCIwIiwiMCIsIm9mZiIsInN0YXRpYyIsIjAiLCIwIiwiMTgwIiwiMCIsInRydWUiLCJvZmYiLCIwIiwiZmFsc2UiLCIyIiwiMCIsInN0YXRpYyIsInN0YXRpYyIsIjAiLCJhdCB0YXJnZXRzIiwiMCIsIjAiLCIwIiwiMCIsIjAiLCJ0cnVlIiwiYmluZHMiLCJ0cnVlIiwidHJ1ZSIsInRydWUiLCJmYWxzZSIsImZhbHNlIiwiZmFsc2UiLCJmYWxzZSIsImZhbHNlIiwiZmFsc2UiLCJ0cnVlIiwidHJ1ZSJdLFsiYm9keSBsZWFuLHN0YXRpYyBpbiBhaXIsbGVncyBvbiBncm91bmQscGl0Y2ggb24gbGFuZCJdLFsiZmFsc2UiXSxbInNtYWxsIiwidHJ1ZSIsInRydWUiXV0="})
        if database.read(self.storage.database.configs) == nil then
            database.write(self.storage.database.configs, {})
        end
        ui.update(self.ui.config.list, self:get_config_list())
        ui.set(self.ui.config.name, #database.read(self.storage.database.configs) == 0 and "" or database.read(self.storage.database.configs)[ui.get(self.ui.config.list)+1].name)
        ui.set_callback(self.ui.config.list, function(value)
            local name = ""
            local configs = self:get_config_list()
            name = configs[ui.get(value)+1] or ""
            ui.set(self.ui.config.name, name)
        end)
        ui.set_callback(self.ui.config.load, function()
            local name = ui.get(self.ui.config.name)
            if name == "" then return end
            local protected = function()
                self:load_config(self:get_config(name).config)
            end
            if pcall(protected) then
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Config successfully loaded')
            else
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Failed to load the config')
            end
        end)
        ui.set_callback(self.ui.config.save, function()
            local name = ui.get(self.ui.config.name)
            if name == "" then return end
        
            if name:match("[^%w]") ~= nil then
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Failed to get config char')
                return
            end
        
            local protected = function()
                self:save_config(name)
            end
        
            if pcall(protected) then
                ui.update(self.ui.config.list, self:get_config_list())
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Config successfully saved')
            else
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Failed to save the config')
            end
        end)
        ui.set_callback(self.ui.config.delete, function()
            local name = ui.get(self.ui.config.name)
            if name == "" then return end
        
            if self:delete_config(name) == false then
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Failed to delete config')
                ui.update(self.ui.config.list, self:get_config_list())
                return
            end
            
            local protected = function()
                self:delete_config(name)
            end
        
            if pcall(protected) then
                ui.update(self.ui.config.list, self:get_config_list())
                ui.set(self.ui.config.list, #database.read(self.storage.database.configs) - #database.read(self.storage.database.configs))
                ui.set(self.ui.config.name, #database.read(self.storage.database.configs) == 0 and "" or self:get_config_list()[#database.read(self.storage.database.configs) - #database.read(self.storage.database.configs)+1])
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Config successfully deleted')
            else
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Failed to delete config')
            end
        end)
        ui.set_callback(self.ui.config.import, function()
            local protected = function()
                self:load_config(self.library['base64'].decode(self.library['clipboard'].get()))
            end
        
            if pcall(protected) then
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Config successfully imported')
            else
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Failed to import config')
            end
        end)
        ui.set_callback(self.ui.config.export, function()
            local protected = function()
                self.library['clipboard'].set(self.library['base64'].encode(self:export_config()))
            end
        
            if pcall(protected) then
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Config successfully exported')
            else
                self.support_function:color_print( {255, 255, 255, '['}, {131, 139, 226, ' Elders '}, {255, 255, 255, ']'}, ' Failed to export config')
            end
        end)
        
        for index, value in pairs(self.ui.antiaim_elements) do
            if type(value) == "table" then
                for i, v in pairs(value) do
                    if ui.type(v) ~= "button" and ui.type(v) ~= "multiselect" then
                        table.insert(self.ui_config.general, v)
                    end
                end
            end
        end

        for index, value in pairs(self.ui.antiaim_elements) do
            if type(value) == "table" then
                for i, v in pairs(value) do
                    if ui.type(v) == "multiselect" then
                        table.insert(self.ui_config.keys_table, v)
                    end
                end
            end
        end

        table.insert(self.ui_config.general, self.ui.extra_switch)
        table.insert(self.ui_config.general, self.ui.extra_selector)
        table.insert(self.ui_config.general, self.ui.fl_exploit)
        table.insert(self.ui_config.general, self.ui.anti_knife)
        table.insert(self.ui_config.general, self.ui.safe_knife_zeus)
        table.insert(self.ui_config.general, self.ui.legit_aa_key)
        table.insert(self.ui_config.general, self.ui.manual_left)
        table.insert(self.ui_config.general, self.ui.manual_right)
        table.insert(self.ui_config.general, self.ui.manual_forward)
        table.insert(self.ui_config.general, self.ui.freestanding)
        table.insert(self.ui_config.general, self.ui.edgeyaw)

        table.insert(self.ui_config.misc, self.ui.misc.clantag)
        table.insert(self.ui_config.general, self.ui.misc.killsay)
        table.insert(self.ui_config.general, self.ui.misc.aimbot_logs)
        table.insert(self.ui_config.keys_table, self.ui.misc.animbreaker)

        table.insert(self.ui_config.visuals, self.ui.visuals.watermark_size)
        table.insert(self.ui_config.visuals, self.ui.visuals.manual_arrows)
        table.insert(self.ui_config.visuals, self.ui.visuals.indicator)
    end;
};

elders:__init__()