-- DOWNLOADED FROM ROLLMOPS
-- KOSTIAS#7780
local render_world_to_screen, rage_exploit, ui_get_binds, ui_get_alpha, entity_get_players, entity_get, entity_get_entities, entity_get_game_rules, common_set_clan_tag, common_is_button_down, common_get_username, common_get_date, ffi_cast, ffi_typeof, render_gradient, render_text, render_texture, render_rect_outline, render_rect, entity_get_local_player, ui_create, ui_get_style, math_floor, math_abs, math_max, math_ceil, math_min, math_random, utils_trace_bullet, render_screen_size, render_load_font, render_load_image_from_file, render_measure_text, render_poly, render_poly_blur, common_add_notify, common_add_event, utils_console_exec, utils_execute_after, utils_create_interface, utils_trace_line, ui_find, entity_get_threat, string_format, hooked_function, entity_get_player_resource, common_get_unixtime, table_insert = render.world_to_screen, rage.exploit, ui.get_binds, ui.get_alpha, entity.get_players, entity.get, entity.get_entities, entity.get_game_rules, common.set_clan_tag, common.is_button_down, common.get_username, common.get_date, ffi.cast, ffi.typeof, render.gradient, render.text, render.texture, render.rect_outline, render.rect, entity.get_local_player, ui.create, ui.get_style, math.floor, math.abs, math.max, math.ceil, math.min, math.random, utils.trace_bullet, render.screen_size, render.load_font, render.load_image_from_file, render.measure_text, render.poly, render.poly_blur, common.add_notify, common.add_event, utils.console_exec, utils.execute_after, utils.create_interface, utils.trace_line, ui.find, entity.get_threat, string.format, nil, entity.get_player_resource, common.get_unixtime, table.insert
local clipboard = require 'neverlose/clipboard'
local base64 = require 'neverlose/base64'
local drag_system = require 'neverlose/drag_system'
local smoothy = require 'neverlose/smoothy'
local get_defensive = require 'neverlose/get_defensive'
local md5 = require 'neverlose/md5'
local inspect = require 'neverlose/inspect'
local events = require 'neverlose/events'
local table_clear = require 'table.clear'
local function on_load() cvar.clear:call() print_raw('\a'..ui_get_style('Link Active'):to_hex()..'mytools \aDEFAULTRenewed\nLast update: 31.08') end;on_load()
_DEBUG = true

ffi.cdef[[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);

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
    } c_animlayers;
]]

local function this_call(call_function, parameters) return function(...) return call_function(parameters, ...) end end
local function gradient_textz(r1, g1, b1, a1, r2, g2, b2, a2, text) local output = '' local len = #text-1 local rinc = (r2 - r1) / len local ginc = (g2 - g1) / len local binc = (b2 - b1) / len local ainc = (a2 - a1) / len for i=1, len+1 do output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i)) r1 = r1 + rinc g1 = g1 + ginc b1 = b1 + binc a1 = a1 + ainc end return output end
local clamp = function(b,c,d)local e=b;e=e<c and c or e;e=e>d and d or e;return e end
function lerp(time,a,b) return a * (1-time) + b * time end
function contains(table, element) for i = 1, #table do if table[i] == element then return true end end end
local ifHashed = function(tbl, val) for n,v in pairs(tbl) do if val == v then return true end end return false end

files.create_folder("nl/scripts/mytools")
local entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface("client.dll", "VClientEntityList003"))
local get_entity_address = this_call(ffi.cast("get_client_entity_t", entity_list_003[0][3]), entity_list_003)
local engine_client = ffi.cast(ffi.typeof('void***'), utils.create_interface('engine.dll', 'VEngineClient014'))
local console_is_visible = ffi.cast(ffi.typeof('bool(__thiscall*)(void*)'), engine_client[0][11])
local font, verdana = render.load_font('Calibri Bold', vector(25, 22, -1), 'a, d'), render.load_font("Verdana", 20, 'a')
ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set('Quick Switch', 'Auto Pistols')
local current = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):get()
local active_color, color_link = ui_get_style('Link Active'):to_hex(), ui_get_style('Link'):to_hex()
local anim_tbl, easing_table = {}, smoothy.new(anim_tbl)
local hitlog, modify = {}, {}
local disabled_windows, windows_table = {}, {}
check_windows = function() windows_table = {} for i = 1, 4 do if (ui.find("Miscellaneous", "Main", "Other", "Windows"):get()[i] ~= nil) and not contains(disabled_windows, ui.find("Miscellaneous", "Main", "Other", "Windows"):get()[i]) then table.insert(windows_table, ui.find("Miscellaneous", "Main", "Other", "Windows"):get()[i]) end end ui.find("Miscellaneous", "Main", "Other", "Windows"):set(windows_table) end

modify.math_breathe = function(offset, multiplier) return math.abs(math.sin(globals.realtime * (multiplier or 1) % math.pi + (offset or 0))) end
modify.typing_text = function(s, callback) num, length = 0, #s:gsub('[\128-\191]', '') result = '' for char in s:gmatch('.[\128-\191]*') do num = num + 1 factor = num / length result = string_format('%s\a%s%s', result, callback(num, length, char, factor):to_hex(), char) end return result end
modify.gradient_text = function(s, a, b) return modify.typing_text(s, function(num, length, char, factor) return a:lerp(b, factor) end) end
modify.gradient = function(s, a, b, t) return modify.typing_text(s, function(num, length, char, factor) interpolation = modify.math_breathe(factor, t) return a:lerp(b, interpolation) end) end
modify.static_gradient = function(s, clr1, clr2) return modify.gradient_text(s, clr1, clr2) end

local render_interpolate_string = function(name, position, font, text_color, flags, ...)
    local text = table.concat({...})
    
    if anim_tbl[name] == nil then
        anim_tbl[name] = 0
        easing_table = smoothy.new(anim_tbl)
    end
    
    local text_size = easing_table(.1, { [name] = render.measure_text(font, nil, ...)})[name]

    local normal_size = render.measure_text(font, nil, ...)

    render.push_clip_rect(vector(position.x - normal_size.x, position.y - text_size.y/2), vector(position.x + text_size.x/2, position.y + text_size.y/2), true)
    render.text(font, vector(position.x - text_size.x/2, position.y - text_size.y/2), text_color, flags, ...)
    render.pop_clip_rect()
end

local function get_type(value)
    if type(getmetatable(value)) == 'table' and value.__type then
        return value.__type.name:lower()
    end

    if type(value) == 'boolean' then
        value = value and 1 or 0
    end

    return type(value)
end

local ctx = new_class()
    :struct 'cheat' {
        screen_size = render_screen_size(),
        version = 'Nightly',
        username = common_get_username(),
    }

    :struct 'impt' {
        play_sound = function(name , volume)
            local IEngineSoundClient = ffi_cast("void***" , utils_create_interface("engine.dll", "IEngineSoundClient003")) or error("Failed to find IEngineSoundClient003!")
            local play_sound_fn = ffi_cast("void(__thiscall*)(void*, const char*, float, int, int, float)",IEngineSoundClient[0][12])
    
            return play_sound_fn( IEngineSoundClient, name , volume , 100 ,0,0)
        end
    }

    :struct 'menu' {
        var_update = {
            active_color = nil,
            link = nil,
        },

        init = function(self) 

            local configs = ui_create('🏠 Home', '🌐 \aFFFFFFFFCloud Configs', 2)
            local info_group = ui_create('🏠 Home', 'ℹ️ \aFFFFFFFFInformation', 1)
            local local_configs = ui_create('🏠 Home', '🏷 \aFFFFFFFFLocal Configs', 1)
            local antiaim_group = ui_create('🎯 Anti-Aim', '🧬 \aFFFFFFFFAnti-aims', 1)
            local antiaims_builder_tab = ui_create('🎯 Anti-Aim', '⚙ \aFFFFFFFFAnti-aim builder', 2)
            local antiaims_configs_group = ui_create('🎯 Anti-Aim', '📁 \aFFFFFFFFYour Presets', 2)
            local misc_group = ui_create('📌 Other', '🛠 \aFFFFFFFFMisc', 2)
            local rage_group = ui_create('📌 Other', '🧨 \aFFFFFFFFRagebot', 1)
            local visuals_group = ui_create('📌 Other', '🖌 \aFFFFFFFFVisuals', 1)
            local text = info_group:label("")
    
            events.pre_render:set(function() 
                local current_colors = {
                    active_color = ui_get_style()["Link Active"],
                    link = ui_get_style()["Link"]
                }
            
                if current_colors.link ~= self.var_update.link or current_colors.active_color ~= self.var_update.active_color then
                    events.on_style_change:call()
                end

                self.var_update = current_colors
            end)

           local global do
                global = {}

                local config_data = files.read('nl/scripts/mytools/mytools.config')
                local success, config_data = pcall(function()
                    return json.parse(config_data)
                end)

                if not success or #config_data == 0 then
                    config_data = {'\aCBC9C9FFNothing there. Create preset.'}
                else
                    local name_list = {}
                    for i=1, #config_data do
                        table.insert(name_list, config_data[i].name)
                    end

                    config_data = name_list
                end


              

                global.preset_list = antiaims_configs_group:list('', config_data)
                global.preset_name = antiaims_configs_group:input('Name: ')
                global.save_preset = antiaims_configs_group:button('', function() self.config_system:save() end, true)
                global.delete_preset = antiaims_configs_group:button('', function() self.config_system:delete() end, true)
                global.load_preset = antiaims_configs_group:button('            Load            ', function() self.config_system:load() end)
                global.import_preset = antiaims_configs_group:button('', function() self.config_system:import() end, true)
                global.export_preset = antiaims_configs_group:button('', function() common_add_notify('mytools', '\a89F2CAFFsuccessfully exported your config') self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12) self.config_system:export() end, true)
                
                global.import_preset1 = local_configs:button('  Import', function() self.config_system:import() end, true)
                global.export_preset1 = local_configs:button('  Export', function() common_add_notify('mytools', '\a89F2CAFFsuccessfully exported your config') self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12) self.config_system:export() end, true)
                
                --global_config
                --global.fnay_label = configs_group:label("")
                global.load_defauls = local_configs:button("✅ \aFFFFFFFFDefault Config", function() self.config_system:import('[mytools]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[/mytools]') end, true)
                global.save_preset:tooltip("Save / Create Preset")
                global.delete_preset:tooltip("Delete Preset")
                global.import_preset:tooltip("Import")
                global.export_preset:tooltip("Export")
               

                --llinks
                global.discord = info_group:button('Discord channel', function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/yXUNrR8") end, true)

                global.verify = info_group:button('Verification Token', function() 
                    --clipboard.set(self.cheat.version == 'Nightly' and '02405b_mytools' or '02405s_mytools')
                    local signObject = function(object)
                        local key = 'ioa0w3424mytools'
                        local signature = string.format('%s%s%s', object.username, object.build, key)
                    
                        return md5.sumhexa(signature)
                    end
                    
                    local _NAME = common.get_username()
                    local _BUILD = (self.cheat.version == 'Nightly' and 'beta' or 'stable') --[[stable, beta, yauma]]
                    
                    network.get(string.format('net ne dam di nahyi', _NAME, _BUILD, signObject({ username = _NAME, build = _BUILD })), {  }, function(data)
                        if not data then
                            print_error 'хз'
                        end
                    
                        clipboard.set(data)
                        print_dev("\aFFFFFFFFYour verification code is: \a"..string.sub(ui_get_style('Link Active'):to_hex(), 0, 6).."" .. data .. "\aFFFFFFFF")
                        print_raw("\aFFFFFFFFYour verification code is: \a"..string.sub(ui_get_style('Link Active'):to_hex(), 0, 6).."" .. data .. "\aFFFFFFFF")
                        print_dev("\aFFFFFFFFIt was copied to your clipboard!")
                        print_raw("\aFFFFFFFFIt was copied to your clipboard!")
                    end)
                    

                    common_add_notify('mytools', '\a89F2CAFFtoken copied to your clipboard')
                    self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12)
                end, true)
                
                global.neverlose_config = info_group:button('Neverlose config', function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=bEb3IN") end, true)
                global.youtube = info_group:button('Youtube channel', function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/channel/UCQ89_KwdfNKgrI7DG738ang") end, true)
                info_group:label("How to get role in our discord server.\n1. Press 'Verification Token'\n2. Go to our discord server\n3. Jump over to #verify channel in support tab\n4. Write /redeem and insert your code\n5. Wait a little and you will get role")
                onlineUsers = info_group:label("")
             
                global.refresh_colors = function()
                    local active_color = ui_get_style('Link Active'):to_hex()
                    local color_link = ui_get_style('Link'):to_hex()


                    global.save_preset:name(
                        ' \a'..active_color..' '
                    )
                    global.delete_preset:name(
                        ' \a'..active_color..' '
                    )
                    global.import_preset:name(
                        ' \a'..active_color..' '
                    )
                    global.export_preset:name(
                        ' \a'..active_color..' '
                    )
                    global.import_preset1:name(
                        ' \a'..active_color..'\a'..color_link..'  Import'
                    )
                    global.export_preset1:name(
                        ' \a'..active_color..'\a'..color_link..'  Export'
                    )
                    global.discord:name(
                        ' \a'..active_color..'\a'..color_link..'  Discord '
                    )
                    global.verify:name(
                        ' \a'..active_color..'\a'..color_link..'  Verification Token '
                    )
                    global.neverlose_config:name(
                        ' \a'..active_color..'\a'..color_link..'  Neverlose Config '
                    )
                    global.youtube:name(
                        ' \a'..active_color..'\a'..color_link..'  Our Youtube '
                    )
                   
                    text:name(string_format('\aDEFAULTWelcome, \a'..active_color..'%s!\n\aDEFAULTCurrent build: %s \n\aDEFAULTSupport in discord channel only!', gradient_textz(ui_get_style()["Link Active"].r, ui_get_style()["Link Active"].g, ui_get_style()["Link Active"].b, 255, ui_get_style()["Link"].r, ui_get_style()["Link"].g, ui_get_style()["Link"].b, 255, self.cheat.username == 'pikachu' and 'admin' or self.cheat.username), gradient_textz(ui_get_style()["Link Active"].r, ui_get_style()["Link Active"].g, ui_get_style()["Link Active"].b, 255, ui_get_style()["Link"].r, ui_get_style()["Link"].g, ui_get_style()["Link"].b, 255, self.cheat.version)))
                end

                events.on_style_change:set(function() global:refresh_colors() end)
            end


            events.render:set(function()
                if ui_get_alpha() < 0.3 then return end
                link_color = ui_get_style()["Link Active"]

                ui.sidebar(modify.gradient('' .. self.cheat.version == 'Nightly' and "mytools Nightly" or 'mytools Renewed' .. ' ', color(255, 115, 137), color(link_color.r, link_color.g, link_color.b), 1.5), modify.gradient('', color(255, 115, 137), color(link_color.r, link_color.g, link_color.b), -1.5))
            end)

            local elements do
                elements = {
                    antiaims = {},
                    ragebot = {},
                    visuals = {},
                    misc = {},
                    antiaims_builder = {}
                }
                local active_color = ui_get_style('Link Active'):to_hex()
               
                elements.misc.scoreboard_icon = info_group:switch("Shared scoreboard icon")
                elements.misc.scoreboard_icon:tooltip("Shows players with a script on server through icon in scoreboard")
                elements.misc.muteunmute = misc_group:switch 'Unmute Silenced Players'
                elements.misc.muteunmute:tooltip('\a'..active_color..'Unmute Silenced Players.\aDEFAULT\n\nRemoves mute from all players who are muted for abuse, updating on round start.')

                elements.visuals.on_screen = visuals_group:switch 'On-Screen Indicators' do
                    local settings = elements.visuals.on_screen:create()
                    elements.visuals.select = settings:combo('Select', {'Disable', 'Default'}, 0)
                    elements.visuals.fonts = settings:combo("Font", {"Small", "Default"})
                    elements.visuals.indicator_color = settings:color_picker('Indicator color', color(255, 255, 255))
                    elements.visuals.build_color = settings:color_picker('Build color', color(215, 163, 111))
                    elements.visuals.glow_px = settings:slider("Glow offset", 0, 100, 40, nil, 'px')
                    elements.visuals.dmg_indx = settings:slider("posxdmg", 0, render_screen_size().x, 965)
                    elements.visuals.dmg_indy = settings:slider("posydmg", 0, render_screen_size().y, 525)
                end

                elements.visuals.dmg_indx:visibility(false)
                elements.visuals.dmg_indy:visibility(false)
                
                elements.visuals.damage_indicator = visuals_group:switch 'Damage Indicator' do
                    local settings = elements.visuals.damage_indicator:create()

                    elements.visuals.damage_font = settings:combo('Damage font', 'Small', 'Default')
                    elements.visuals.dis_animation = settings:switch("Disable damage animation", false)
                end

                elements.visuals.velocity_warning = visuals_group:switch 'Velocity Indicator' do
                    local settings = elements.visuals.velocity_warning:create()

                    elements.visuals.velocity_color = settings:color_picker("Accent color", color(145, 178, 239))
                    elements.visuals.velocity_x = settings:slider("posxvelocity", 0, render_screen_size().x, 900)
                    elements.visuals.velocity_y = settings:slider("posyvelocity", 0, render_screen_size().y, 250)
                    elements.visuals.velocity_x:visibility(false)
                    elements.visuals.velocity_y:visibility(false)
                end


                elements.visuals.arrows_style = visuals_group:combo('Anti Aim Arrows', 'Disabled', 'Default') do
                    local settings = elements.visuals.arrows_style:create()

                    elements.visuals.arrows_color = settings:color_picker('Arrows color', color(255, 165, 135, 255))
                end

                elements.visuals.sindicators = visuals_group:selectable('500$ Indicators', {'Double tap', 'Dormant aimbot', 'Minimum damage', 'Ping spike', 'Fake duck', 'Freestanding', 'Spectator list', 'Hit Percentage', 'Bomb info', 'Body aim', 'Hide shots', 'Choked commands'}, 0)
                
                elements.visuals.aimbot_logging = rage_group:switch 'Custom Event Logs' do
                    local settings = elements.visuals.aimbot_logging:create()

                    elements.visuals.select_log = settings:selectable('Select log', {'Upper-left', 'Under crosshair'})
                    elements.visuals.purchases = settings:switch("Purchase logs (upper-left)", true)
                    elements.visuals.dis_glow = settings:switch('Disable glow (under-crosshair)')
                    elements.visuals.accent_color = settings:color_picker("Logs color", color(247, 189, 122))
                end

                elements.visuals.custom_scope = misc_group:switch 'Scope Overlay' do
                    local settings = elements.visuals.custom_scope:create()

                    elements.visuals.scope_style = settings:combo('Select style', {'Default', 'Reversed'})
                    elements.visuals.remove_line = settings:selectable('Exclude line', {'Left', 'Right', 'Up', 'Down'})  
                    elements.visuals.scope_gap = settings:slider("Scope gap", 0, 500, 7)
                    elements.visuals.scope_size = settings:slider("Scope size", 0, 1000, 105)
                    elements.visuals.scope_color = settings:color_picker("Scope color", color(255, 255, 255))
                    
                end

                elements.visuals.solus_widgets = misc_group:switch 'Screen Widgets' do
                    local settings = elements.visuals.solus_widgets:create()
                    elements.visuals.solus_widgets_s = settings:selectable("Widgets", {"Hotkeys", "Spectators"})
                    elements.visuals.accent_col = settings:color_picker("Widgets color", color(249, 186, 130))
                    elements.visuals.pos_x_s = settings:slider("posx", 0, render_screen_size().x, 150)
                    elements.visuals.pos_y_s = settings:slider("posy", 0, render_screen_size().y, 150)
                    elements.visuals.pos_x1_s = settings:slider("posx1", 0, render_screen_size().x, 250)
                    elements.visuals.pos_y1_s = settings:slider("posy1", 0, render_screen_size().y, 250)
                end

                elements.visuals.pos_x_s:visibility(false)
                elements.visuals.pos_y_s:visibility(false)
                elements.visuals.pos_x1_s:visibility(false)
                elements.visuals.pos_y1_s:visibility(false)
                
                elements.visuals.viewmodel_changer = misc_group:switch 'Viewmodel Changer' do
                    local settings = elements.visuals.viewmodel_changer:create()

                    elements.visuals.viewmodel_fov = settings:slider('FOV', -100, 100, 68)
                    elements.visuals.viewmodel_x = settings:slider("Offset X", -150, 150, 25, 0.1)
                    elements.visuals.viewmodel_y = settings:slider("Offset Y", -150, 150, 0, 0.1)
                    elements.visuals.viewmodel_z = settings:slider("Offset Z", -150, 150, -15, 0.1)
                    settings:button('Reset values to default', function() elements.visuals.viewmodel_fov:set(68) elements.visuals.viewmodel_x:set(25) elements.visuals.viewmodel_y:set(0) elements.visuals.viewmodel_z:set(-15) end)
                end

                elements.visuals.viewmodel_aspectratio = misc_group:slider('Aspect Ratio', 0, 200, 0, 0.01, function(self)
                    if self == 0 then 
                        return 'Off' 
                    end 
                end)

                --miscellneous
                elements.misc.killsay = misc_group:switch 'Trash Talk' do
                    local settings = elements.misc.killsay:create()


                    elements.misc.killsay_disablers = settings:switch('Disable on warmup', false)

                end
            
                elements.misc.clantag_changer = misc_group:switch 'Clan Tag'
                elements.misc.markers = misc_group:selectable("Hit/Miss Markers", {"Kibit Hitmarker", "3D Miss marker", "OT Damage Marker"})
               
                elements.misc.console_changer = misc_group:switch 'Console Color Changer' do
                    local settings = elements.misc.console_changer:create()
                    
                    elements.misc.console_color = settings:color_picker("Console color", color(255, 255, 255, 255))
                end
               
               --othergroup
                elements.misc.grenade_fix = misc_group:switch 'Nade Throw Fix'
                elements.misc.grenade_fix:tooltip("Fix the moment when you try to throw a grenade and it is not thrown.")
                elements.misc.taskbar = misc_group:switch '\aCCCC6FFFFlash Icon On Round Start'
                
                --anti-aims
                elements.antiaims.antiaim_mode = antiaim_group:list('Choose type of anti-aim', {'👑  Aggressive Jitter', '🤩  Defensive Meta', '⚙️  Builder'})
               
                elements.antiaims.condition = antiaims_builder_tab:combo("Current condition", {"Global", "Standing", "Moving", "Slow motion", "Air", "Air Crouch", "Crouch", "Crouch Move"}, 0)
                elements.antiaims.tp = antiaims_builder_tab:label("You are using an automatic preset, you don't need to adjust it. Just press it and go play.")
                elements.antiaims.antiaims_tweaks = antiaim_group:selectable("Anti-aim Additionals", {'Static manuals','Bombsite E Fix', 'Anti-aim on use', 'Disable FS on manual', 'Static on fakelag', 'Static on knife'})
                elements.antiaims.manual_aa = antiaim_group:combo("Manual AA", {'Disabled', 'Left', 'Right', 'Forward'})
                
                elements.antiaims.force_lag = antiaim_group:switch 'Force Break LC' do
                    local settings = elements.antiaims.force_lag:create()

                    elements.antiaims.lag_conditions = settings:selectable("Conditions", {'In Air', 'Standing', 'Moving', 'Slow Walking', 'Crouching', 'Crouch Move'})
                end

                elements.antiaims.defensive_aa = antiaim_group:switch('Defensive AA', false) do
                    local settings = elements.antiaims.defensive_aa:create()

                    elements.antiaims.defensive_type = settings:combo('Type', {'Presets', 'Custom'})
                    elements.antiaims.defensive_pitch = settings:combo('Pitch', {'Disabled', 'Up', 'Down', 'Semi Up', 'Semi Down', 'Random'})
                    elements.antiaims.defensive_yaw = settings:combo('Yaw', {'Disabled', 'Sideways', 'Opposite', 'Spin', 'Random', '3-Way', '5-Way'})
                    elements.antiaims.custom_pitch = settings:slider('Custom Pitch', -89, 89, 0)
                    elements.antiaims.custom_yaw = settings:slider('Custom Yaw', -180, 180, 0)
                    elements.antiaims.defensive_disablers = settings:switch("Disable on manual")
                    elements.antiaims.defensive_disablers1 = settings:switch("Disable on nades")
                end

                elements.misc.movement_helpers = antiaim_group:selectable("Movement Tweaks", {'Fast ladder', 'No fall damage'})
                elements.misc.movement_helpers:tooltip('\a'..active_color..'Auto jumpbug.\aDEFAULT\nWill try to prevent you from getting damage when falling from high height.\n\n\a'..active_color..'Fast ladder.\aDEFAULT\nYou climb faster on ladder.')

                elements.antiaims.anim_breakers = antiaim_group:selectable("⚠️ \aCCCC6FFFAnim Breakers", {"Legs on ground", 'Legs in air', 'Increase Move Lean'}) do
                    local settings = elements.antiaims.anim_breakers:create()

                    elements.antiaims.type_legs_ground = settings:combo('Legs on ground', {'Sliding', 'Allah', 'Jitter'})
                    elements.antiaims.type_legs_air = settings:combo('Legs in air', {'Static', 'Allah'})
                end

                --ragegroup
                 elements.misc.rev_help = rage_group:switch 'Revolver Helper'
                 elements.misc.rev_help:tooltip('\a'..active_color..'Revolver Helper.\aDEFAULT\nShows "DMG+" indicator next to opponent if you can give 100 damage an opponent with a revolver.\nYou can edit indicator position in esp settings.')
 
                 elements.misc.auto_tp = rage_group:switch 'Discharge Exploit' do
                     local settings = elements.misc.auto_tp:create()
                     elements.misc.weapons = settings:selectable("Weapons", "Pistols", "Auto Snipers", "AWP", "SSG-08", "Heavy Pistols", "Knife/Taser")
                 end
 
                 elements.misc.hc_enable = rage_group:switch 'Hitchance Additionals' do
                     local settings = elements.misc.hc_enable:create()
 
                     elements.misc.hc_cond = settings:selectable('Condition', {'Air', 'No scope'})
                     elements.misc.hc_air = settings:slider('Air', 0, 100, 55)
                     elements.misc.hc_ns = settings:slider('No scope', 0, 100, 55)
                 end

                 elements.misc.fakelatency = rage_group:switch 'Unlock Fake Latency'
                 elements.misc.fakelatency:tooltip('\a'..active_color..'Unlock Fake Latency.\aDEFAULT\nRemoves 100ms limit in ping spike')
            end

            local antiaim_builder do
                antiaim_builder = {}

                for i=1, 8 do
                    local spaces = string.rep(' ', i)
                    elements.antiaims_builder[i] = { }
                       
                    elements.antiaims_builder[i].enabled = antiaims_builder_tab:switch("Enable Condition" .. spaces, false)
                    elements.antiaims_builder[i].pitch = antiaims_builder_tab:combo("Pitch" .. spaces, {'Disabled', 'Down', 'Fake Down', 'Fake Up'})

                    elements.antiaims_builder[i].yaw = antiaims_builder_tab:combo("Yaw" .. spaces, {'Disabled', 'Backward', 'Static'}) do
                        local settings = elements.antiaims_builder[i].yaw:create()
                        
                        elements.antiaims_builder[i].base = settings:combo('Base' .. spaces, {'Local View', 'At Target'})
                        elements.antiaims_builder[i].type = settings:combo("Yaw Mode" .. spaces, {'Default', 'Left/Right', 'Delayed swap'})
                        elements.antiaims_builder[i].delay = settings:switch("Swap compatible with inverter" .. spaces)
                        elements.antiaims_builder[i].offset_l = settings:slider("Offset" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].offset_r = settings:slider("Offset R" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].per_tick = settings:slider("Delay ticks" .. spaces, 0, 128, 64)
                        elements.antiaims_builder[i].hidden = settings:switch("Hidden" .. spaces, false)
                    end

                    elements.antiaims_builder[i].jyaw = antiaims_builder_tab:combo("Yaw Modifier" .. spaces, {'Disabled', 'Center', 'Offset', 'Random', 'Spin', '3-Way', '5-Way'}) do
                        local settings = elements.antiaims_builder[i].jyaw:create()
                        
                        elements.antiaims_builder[i].mode = settings:combo("Mode" .. spaces, {"Static", "From/To", 'Left/Right'})
                        elements.antiaims_builder[i].type_mod = settings:combo("Settings" .. spaces, {"Default", "Custom"})
                        elements.antiaims_builder[i].offset_one = settings:slider("Offset #1" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].offset_two = settings:slider("Offset #2" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].way1 = settings:slider("1 Way" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].way2 = settings:slider("2 Way" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].way3 = settings:slider("3 Way" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].way4 = settings:slider("4 Way" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].way5 = settings:slider("5 Way" .. spaces, -180, 180, 0, nil, '°')
                    end

                    elements.antiaims_builder[i].body_yaw = antiaims_builder_tab:switch("Body Yaw" .. spaces, false) do
                        local settings = elements.antiaims_builder[i].body_yaw:create()

                        elements.antiaims_builder[i].fake_slider_main = settings:slider("Fake left" .. spaces, 0, 60, 60, nil, '°')
                        elements.antiaims_builder[i].fake_slider_next = settings:slider("Fake right" .. spaces, 0, 60, 60, nil, '°')
                        elements.antiaims_builder[i].fake_op = settings:selectable("Fake options" .. spaces, {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"}, 0)
                        elements.antiaims_builder[i].freestand = settings:combo("Freestand DS" .. spaces, {"Off", "Peek Fake", "Peek Real"}, 0)
                        elements.antiaims_builder[i].inverter = settings:switch("Anti-aim inverter" .. spaces, false)
                    end
                end

                

                local custom_aa = elements.antiaims_builder
                
                antiaim_builder.hide_all_custom = function()
                    for i = 1, 8 do
                        for _, k in pairs(custom_aa[i]) do
                            if not k:visibility() then goto skip end
                            k:visibility(false)
                            ::skip::
                        end
                    end
                end

                antiaim_builder.unhide_cur_custom = function(zxc, num)
                    if custom_aa[num].enabled:get() then
                        for _, k in pairs(custom_aa[num]) do
                            if k:visibility() then goto skip end
                            k:visibility(true)
                            ::skip::
                        end
                    else
                        for _, k in pairs(custom_aa[num]) do
                            if not k:visibility() then goto skip end
                            k:visibility(false)
                            ::skip::
                        end
                    end
                
                    custom_aa[num].enabled:visibility(true)
                end

                antiaim_builder.unhide_cur_enable_state = function(zxc, num)
                    custom_aa[num].enabled:visibility(true)
                end
                
                

                antiaim_builder.strange = function(zxc, condition_tab)

                    if condition_tab == 'Global' then
                        return 0
                    elseif condition_tab == 'Standing' then
                        return 1
                    elseif condition_tab == 'Moving' then
                        return 2
                    elseif condition_tab == 'Slow motion' then
                        return 3
                    elseif condition_tab == 'Air' then
                        return 4
                    elseif condition_tab == 'Air Crouch' then
                        return 5
                    elseif condition_tab == 'Crouch' then
                        return 6
                    elseif condition_tab == 'Crouch Move' then
                        return 7
                    elseif condition_tab == 'Dormant' then
                        return 8
                    end
                end
        
                
                antiaim_builder.init_handle = function(self)
                    events.pre_render:set(function() 
                        if ui_get_alpha() ~= 1 then return end
        
                        local state = elements.antiaims.antiaim_mode:get()
                        
                        antiaim_builder:hide_all_custom()
                        elements.antiaims.condition:visibility(state == 3)

                        if state == 3 then
                            antiaim_builder:unhide_cur_custom(antiaim_builder:strange(elements.antiaims.condition:get()) + 1)
                            antiaim_builder:unhide_cur_enable_state(antiaim_builder:strange(elements.antiaims.condition:get()) + 1)
                            for i=1, 8 do
                                if (custom_aa[i].jyaw:get() == '5-Way' or custom_aa[i].jyaw:get() == '3-Way') then custom_aa[i].mode:visibility(false) end
                                if (custom_aa[i].jyaw:get() == '3-Way' and custom_aa[i].type_mod:get() == 'Custom') then custom_aa[i].offset_one:visibility(false) custom_aa[i].offset_two:visibility(false) custom_aa[i].way1:visibility(true) custom_aa[i].way2:visibility(true) custom_aa[i].way3:visibility(true) custom_aa[i].way4:visibility(false) custom_aa[i].way5:visibility(false) end 
                                if (custom_aa[i].jyaw:get() == '5-Way' and custom_aa[i].type_mod:get() == 'Custom') then custom_aa[i].offset_one:visibility(false) custom_aa[i].offset_two:visibility(false) custom_aa[i].way1:visibility(true) custom_aa[i].way2:visibility(true) custom_aa[i].way3:visibility(true) custom_aa[i].way4:visibility(true) custom_aa[i].way5:visibility(true) end 
                                if (custom_aa[i].jyaw:get() == '5-Way' and custom_aa[i].type_mod:get() == 'Default') then custom_aa[i].offset_two:visibility(false) custom_aa[i].way1:visibility(false) custom_aa[i].way2:visibility(false) custom_aa[i].way3:visibility(false) custom_aa[i].way4:visibility(false) custom_aa[i].way5:visibility(false) end 
                                if (custom_aa[i].jyaw:get() == '3-Way' and custom_aa[i].type_mod:get() == 'Default') then custom_aa[i].offset_two:visibility(false) custom_aa[i].way1:visibility(false) custom_aa[i].way2:visibility(false) custom_aa[i].way3:visibility(false) custom_aa[i].way4:visibility(false) custom_aa[i].way5:visibility(false) end 
                                if (custom_aa[i].jyaw:get() ~= '5-Way' and custom_aa[i].jyaw:get() ~= '3-Way') then custom_aa[i].type_mod:visibility(false) custom_aa[i].way1:visibility(false) custom_aa[i].way2:visibility(false) custom_aa[i].way3:visibility(false) custom_aa[i].way4:visibility(false) custom_aa[i].way5:visibility(false) end 
                                if custom_aa[i].type:get() ~= 'Delayed swap' then custom_aa[i].per_tick:visibility(false) custom_aa[i].delay:visibility(false) end
                                if custom_aa[i].type:get() == 'Default' then custom_aa[i].offset_r:visibility(false) end
                                if custom_aa[i].mode:get() == 'Static' then custom_aa[i].offset_two:visibility(false) end

                            end

                            custom_aa[1].enabled:visibility(false)
                            custom_aa[1].enabled:set(true)
                            elements.antiaims.condition:visibility(true)
                        end
                        
                    end)
                end
            end

            self.global = global
            self.info_group = info_group
            self.elements = elements
            self.antiaim_builder = antiaim_builder

            --set callbacks
            antiaim_builder:init_handle()
        end
    }

    :struct 'refs' {
        enable_desync = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
        yaw_base = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw"),
        pitch = ui_find("Aimbot", "Anti Aim", "Angles", "Pitch"),
        yaw = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
        fake_op = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
        base_yaw = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
        --lby = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "LBY Mode"),
        freestand = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
        --desync_os = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "On Shot"),
        hidden = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
        slowwalk = ui_find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
        jyaw = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
        jyaw_slider = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
        fake_duck = ui_find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
        freestanding_def = ui_find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
        left_limit = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
        right_limit = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
        dt = ui_find('Aimbot', 'Ragebot', 'Main', 'Double Tap'),
        hs = ui_find('Aimbot', 'Ragebot', 'Main', 'Hide shots'),
        body_aim = ui_find('Aimbot', 'Ragebot', 'Safety', 'Body Aim'),
        safe_point = ui_find("Aimbot", "Ragebot", "Safety", "Safe Points"),
        auto_peek = ui_find('Aimbot', 'Ragebot', 'Main', 'Peek Assist'),
        freestanding_yaw = ui_find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
        hitchance = ui_find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
        min_dmg = ui_find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
        base = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
        dormantaim = ui_find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
        pingspike = ui_find("Miscellaneous", "Main", "Other", "Fake Latency"),
        legmovement = ui_find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
        logs = ui_find("Miscellaneous", "Main", "Other", "Log Events"),
        inverter1 = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
        disablers = ui_find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers")
    }

    :struct 'config_system' {
        init = function(self)
            local config_system do
                local path = 'nl/scripts/mytools/mytools.config'
                config_system = {}

                local Xor = function(str)
                    local key = '6a 75 73 74 73 69 6d 70 6c 65 74 65 78 74'
                    local strlen, keylen = #str, #key

                    local strbuf = ffi.new('char[?]', strlen+1)
                    local keybuf = ffi.new('char[?]', keylen+1)

                    local success,_ = pcall(function()
                        return string.dump(ffi.copy)
                    end)

                    if success then
                        print_error 'You are not allowed to edit FFI Struct.'
                        common.unload_script()

                        return
                    end

                    ffi.copy(strbuf, str)
                    ffi.copy(keybuf, key)

                    for i=0, strlen-1 do
                        strbuf[i] = bit.bxor(strbuf[i], keybuf[i % keylen])
                    end

                    return ffi.string(strbuf, strlen)
                end

                Cipher = {
                    encode = function(a, b)
                        return '[mytools]' .. tostring(base64.encode(Xor(a,Cipher_code))) .. '[/mytools]'
                    end,

                    decode = function(a, b)
                        local prefix = '[mytools]'
                        local bypassed_prefix = '[/mytools]'

                        local q,e = a:find(prefix, 1, true)
                        local z,x = a:find(bypassed_prefix, 1, true)

                        a = a:sub(e + 1, z - 1):gsub(' ', '')

                        return tostring(Xor(base64.decode(a),Cipher_code))
                    end
                }

                config_system.import = function(zxc, c, only_aa)
                    local success, config_file = pcall(function()
                        return json.parse(Cipher.decode((type(zxc) == 'table' and clipboard.get()) or zxc))
                    end)

                    if c ~= nil then
                        success, config_file = pcall(function()
                            return json.parse(Cipher.decode(c))
                        end)
                    end
    
                    if not success then
                        self.impt.play_sound('error.wav', 0.12)
                        common_add_notify('mytools', '\aE0C152FF\xef\x81\xb1  there was an error while loading your config')
                        return
                    end
                    
                    for k,v in pairs(config_file) do
                        local imported_tbl = v
    
                        for m,j in pairs(self.menu.elements) do
                            if only_aa then
                                if string.find(m, 'antiaims') == nil then
                                    goto skip
                                end
                            end

                            if m == v.tab then
                                for ce,net in pairs(j) do
                                    if get_type(net) == 'table' then
                                        for fnay,mishkat in pairs(net) do
                                            if v.name == mishkat:name() then
                                                mishkat:set(v.var)
                                            end
                                        end
                                        
                                        goto skip end

                                    if v.name == net:name() then
                                        net:set(v.var)
                                    end
                                    ::skip::
                                end
                            end

                            ::skip::
                        end
                    end
                    
                    common_add_notify('mytools', '\a89F2CAFFsuccessfully loaded your config')
                    self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12)
                end

                config_system.save = function()
                    local preset_name = self.menu.global.preset_name:get()

                    local successed_export, exported_config = pcall(function()
                        local config_data = files.read(path)
                        local success, config_data = pcall(function()
                            return json.parse(config_data)
                        end)

                        if not success or #config_data == 0 then
                            config_data = {}
                        end

                        
                        local num = self.menu.global.preset_list:get()
                        local presets_list = self.menu.global.preset_list:list()
                        
                        
                        local do_save = 0

                        if preset_name:gsub(' ', '') == '' or preset_name == '' then
                            do_save = 1
                            
                            for i=1, #config_data do
                                local config_name = config_data[i].name
                                if config_name == presets_list[num] then
                                    do_save = -1
                                    config_data[i].code = self.config_system:export()
                                    files.write(path, json.stringify(config_data))
                                end
                            end
                        end

                       

                        for i=1, #config_data do
                            local config_name = config_data[i].name

                            if config_name == preset_name then
                                do_save = 2

                                config_data[i].code = self.config_system:export()
                                files.write(path, json.stringify(config_data))
                                self.menu.global.preset_name:set('')
                                do_save = -2
                                break
                            end
                        end

                        if preset_name:gsub(' ', '') ~= '' then
                            local work = true

                            for i=1, #config_data do
                                local config_name = config_data[i].name
                                
                                if config_name == preset_name then
                                    work = false
                                end
                            end

                            if work then
                                do_save = 3

                                table.insert(config_data, {code = self.config_system:export(), name = preset_name})
    
                                local name_file = {}
                                for i=1, #config_data do
                                    table.insert(name_file, config_data[i].name)
                                end
    
                                files.write(path, json.stringify(config_data))
                                self.menu.global.preset_list:update(name_file)
                                self.menu.global.preset_name:set('')
                                do_save = -3
                            end
                        end

                        if do_save == 1 then
                            self.impt.play_sound('error.wav', 0.12)
                            common_add_notify('mytools', '\aE0C152FF\xef\x81\xb1  enter valid config name!')

                            return
                        end


                        if do_save ~= 0 then
                            common_add_notify('mytools', '\a89F2CAFFsuccessfully saved your config')
                            self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12)
                        else
                            self.impt.play_sound('error.wav', 0.12)
                            common_add_notify('mytools', '\aE0C152FF\xef\x81\xb1  there was an error while loading your config')
                        end
                    end)
                end

                config_system.delete = function()
                    local num = self.menu.global.preset_list:get()

                    local config_data = files.read(path)
                    local success, config_data = pcall(function()
                        return json.parse(config_data)
                    end)

                    if not success or #config_data == 0 then
                        config_data = {}
                    end
                    
                    table.remove(config_data, num)
                    files.write(path, json.stringify(config_data))
                    
                    local name_list = {}
                    for i=1, #config_data do
                        table.insert(name_list, config_data[i].name)
                    end

                    self.menu.global.preset_list:update(#name_list == 0 and {'\aCBC9C9FFNothing there. Create preset.'} or name_list)
                    self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12)
                end
            end

            config_system.export = function()
                local tbl = {}
                local ignore_list = {}

                for itab,tab in pairs(self.menu.elements) do
                    for k,v in pairs(tab) do
                        if get_type(v) == 'table' then 
                            for k,v in pairs(v) do
                                table.insert(tbl, {tab = itab, name = v:name(), var = get_type(v:get()) == 'imcolor' and v:get():to_hex() or v:get()})
                            end
                            goto skip end
                        table.insert(tbl, {tab = itab, name = v:name(), var = get_type(v:get()) == 'imcolor' and v:get():to_hex() or v:get()})
                        ::skip::
                    end
                end

                local config = Cipher.encode(json.stringify(tbl))

                clipboard.set(config)
                return config
            end

            config_system.load = function()
                local last_config = db.last_config or { }

                local path = 'nl/scripts/mytools/mytools.config'
                local num = self.menu.global.preset_list:get()

                local config_data = files.read(path)
                local success, config_data = pcall(function()
                    return json.parse(config_data)
                end)

                local name_list = {}

                for i=1, #config_data do
                    table.insert(name_list, config_data[i].name)
                end

                if #name_list == 0 then
                    self.impt.play_sound('error.wav', 0.12)
                    common_add_notify('mytools', '\aE0C152FF\xef\x81\xb1  there was an error while loading your config')
                    return
                end

                if not success or #config_data == 0 then
                    config_data = {}
                end 
                
                config_system:import(config_data[num].code, true)
            end

            self.save = config_system.save
            self.delete = config_system.delete
            self.import = config_system.import
            self.export = config_system.export
            self.load = config_system.load
        end
    }

    
ctx.menu:init()
ctx.config_system:init()

local Ways = {
    Number = 0
}

local custom_aa = ctx.menu.elements.antiaims_builder

local antiaim_builder do
    antiaim_builder = {}

    antiaim_builder.get_velocity = function(s, player)
        if player == nil then
            return
        end
        
        local vel = player["m_vecVelocity"]
        if vel.x == nil then return end
        return math.sqrt(vel.x*vel.x + vel.y*vel.y + vel.z*vel.z)
    end

    antiaim_builder.state = function(asd, lp_vel, player, cmd)
        local is_crouching = function()
            local localplayer = entity_get_local_player()
            local flags = localplayer['m_fFlags']
            
            if bit.band(flags, 4) == 4 then
                return true
            end
            
            return false
        end
    
        if lp_vel == nil then
            return
        end
        
        player = 0
        local get_player = nil
        local is_dormant = false
        local localplayer = entity_get_local_player()
    
        if false then
            cnds = 9
        elseif lp_vel < 5 and not cmd.in_jump and not (is_crouching(localplayer) or ctx.refs.fake_duck:get()) then
            cnds = 2
        elseif cmd.in_jump and not is_crouching(localplayer) then
            cnds = 5
        elseif cmd.in_jump and is_crouching(localplayer) then
            cnds = 6
        elseif lp_vel > 5 and (is_crouching(localplayer) or ctx.refs.fake_duck:get()) then
            cnds = 8
        elseif (is_crouching(localplayer) or ctx.refs.fake_duck:get()) then
            cnds = 7
        else
            if ctx.refs.slowwalk:get() then
            cnds = 4
            else
            cnds = 3
            end
        end
    
        return cnds
    end
    
    antiaim_builder.custom_preset = function()
        events.createmove:set(function(cmd)
            if entity_get_local_player() == nil then return end
            
            local lp = entity_get_local_player()
            local lp_vel = antiaim_builder:get_velocity(lp)
            local state = antiaim_builder:state(lp_vel, nil, cmd)

            local b, c = state, side
            if custom_aa[b] == nil then
                return
            end

            if ctx.menu.elements.antiaims.antiaim_mode:get() == 1 or ctx.menu.elements.antiaims.antiaim_mode:get() == 2 then
                if ctx.menu.elements.antiaims.antiaim_mode:get() == 1 then
                    if b == 1 then
                        ctx.refs.pitch:override("Down")
                        ctx.refs.enable_desync:override(true)
                    elseif b == 2 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and -20 or 28)
                        ctx.refs.jyaw:override("Center")
                        ctx.refs.jyaw_slider:override(-20)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(58)
                        ctx.refs.right_limit:override(58)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                    elseif b == 3 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and -6 or 10)
                        ctx.refs.jyaw:override("Center")
                        ctx.refs.jyaw_slider:override(-58)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(36)
                        ctx.refs.right_limit:override(36)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                    elseif b == 4 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and -30 or 42)
                        ctx.refs.jyaw:override("Spin")
                        ctx.refs.jyaw_slider:override(-15)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(45)
                        ctx.refs.right_limit:override(45)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                    elseif b == 5 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(35)
                        ctx.refs.jyaw:override("Offset")
                        ctx.refs.jyaw_slider:override(-50)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(60)
                        ctx.refs.right_limit:override(60)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                    elseif b == 6 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and 5 or 20)
                        ctx.refs.jyaw:override("Center")
                        ctx.refs.jyaw_slider:override(-42)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(58)
                        ctx.refs.right_limit:override(58)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                    elseif b == 7 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(0)
                        ctx.refs.jyaw:override("Center")
                        ctx.refs.jyaw_slider:override(-15)
                        ctx.refs.fake_op:override({""})
                        ctx.refs.left_limit:override(25)
                        ctx.refs.right_limit:override(25)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(true)
                        ctx.refs.enable_desync:override(true)
                    end
                    
                elseif ctx.menu.elements.antiaims.antiaim_mode:get() == 2 then
                    if b == 1 then
                        ctx.refs.pitch:override("Down")
                        ctx.refs.enable_desync:override(true)
                    elseif b == 2 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and -25 or 28)
                        ctx.refs.jyaw:override("Disabled")
                        ctx.refs.jyaw_slider:override(0)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(58)
                        ctx.refs.right_limit:override(58)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                        rage.antiaim:override_hidden_pitch(math.random(-89, 89))
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override()
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override()
                    elseif b == 3 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and -25 or 28)
                        ctx.refs.jyaw:override("Disabled")
                        ctx.refs.jyaw_slider:override(0)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(58)
                        ctx.refs.right_limit:override(58)
                        ctx.refs.hidden:override(true)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                        rage.antiaim:override_hidden_pitch(math.random(-89, 89))
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override()
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override()
                    elseif b == 4 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(43)
                        ctx.refs.jyaw:override("Offset")
                        ctx.refs.jyaw_slider:override(math.random(-65, -85))
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(30)
                        ctx.refs.right_limit:override(30)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override()
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override()
                    elseif b == 5 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        if not ctx.refs.dt:get() and not ctx.refs.hs:get() then
                            ctx.refs.yaw:override(0)
                            ctx.refs.jyaw:override("Disabled")
                            ctx.refs.jyaw_slider:override(0)
                            ctx.refs.fake_op:override("")
                            ctx.refs.left_limit:override(25)
                            ctx.refs.right_limit:override(25)
                        else
                            ctx.refs.yaw:override(40)
                            ctx.refs.jyaw:override("Random")
                            ctx.refs.jyaw_slider:override(rage.antiaim:inverter() == true and 0 or -44)
                            ctx.refs.fake_op:override({"Jitter"})
                            ctx.refs.left_limit:override(60)
                            ctx.refs.right_limit:override(60)
                        end
                        ctx.refs.hidden:override(true)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On")
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC")
                        rage.antiaim:override_hidden_pitch(math.random(-89, 89))
                    elseif b == 6 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        if not ctx.refs.dt:get() and not ctx.refs.hs:get() then
                            ctx.refs.yaw:override(0)
                            ctx.refs.jyaw:override("Disabled")
                            ctx.refs.jyaw_slider:override(0)
                            ctx.refs.fake_op:override("")
                            ctx.refs.left_limit:override(25)
                            ctx.refs.right_limit:override(25)
                        else
                            ctx.refs.yaw:override(rage.antiaim:inverter() == true and 15 or 37)
                            ctx.refs.jyaw:override("Offset")
                            ctx.refs.jyaw_slider:override(rage.antiaim:inverter() == true and 0 or -89)
                            ctx.refs.fake_op:override({"Jitter"})
                            ctx.refs.left_limit:override(60)
                            ctx.refs.right_limit:override(60)
                        end
                        ctx.refs.hidden:override(true)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On")
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC")
                        rage.antiaim:override_hidden_pitch(math.random(-89, 89))
                    elseif b == 7 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        if not ctx.refs.dt:get() and not ctx.refs.hs:get() then
                            ctx.refs.yaw:override(0)
                            ctx.refs.jyaw:override("Disabled")
                            ctx.refs.jyaw_slider:override(0)
                            ctx.refs.fake_op:override("")
                            ctx.refs.left_limit:override(25)
                            ctx.refs.right_limit:override(25)
                            ctx.refs.inverter1:override(false)
                        else
                            ctx.refs.yaw:override(rage.antiaim:inverter() == true and 0 or -15)
                            ctx.refs.jyaw:override("3 Way")
                            ctx.refs.jyaw_slider:override(math.random(-45, -70))
                            ctx.refs.fake_op:override({"Jitter"})
                            ctx.refs.left_limit:override(38)
                            ctx.refs.right_limit:override(29)
                            ctx.refs.inverter1:override(false)
                        end
                        ctx.refs.hidden:override(true)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.enable_desync:override(true)
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On")
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC")
                        rage.antiaim:override_hidden_pitch(math.random(-89, 89))
                    end
                    
                end
                    
                if ctx.menu.elements.antiaims.antiaims_tweaks:get('Disable FS on manual') and ctx.refs.freestanding_yaw:get() and (ctx.menu.elements.antiaims.manual_aa:get() == "Right" or ctx.menu.elements.antiaims.manual_aa:get() == "Left" or ctx.menu.elements.antiaims.manual_aa:get() == "Forward") then
                    ctx.refs.freestanding_yaw:set(false)
                end

                if ctx.menu.elements.antiaims.antiaims_tweaks:get('Static on knife') then
                    if entity_get_local_player():get_player_weapon() == nil then return end
                    knife = entity_get_local_player():get_player_weapon():get_classname() == "CKnife"
                    if knife then
                        ctx.refs.yaw:override(0)
                        ctx.refs.jyaw:override("Disabled")
                        ctx.refs.jyaw_slider:override(0)
                        ctx.refs.fake_op:override("")
                        ctx.refs.left_limit:override(25)
                        ctx.refs.right_limit:override(25)
                        ctx.refs.inverter1:override(true)
                    end
                end

                if (ctx.menu.elements.antiaims.manual_aa:get() == "Right" or ctx.menu.elements.antiaims.manual_aa:get() == "Left" or ctx.menu.elements.antiaims.manual_aa:get() == "Forward" or ctx.refs.freestanding_yaw:get()) and ctx.menu.elements.antiaims.antiaims_tweaks:get("Static manuals") then
                    ctx.refs.fake_op:override({})
                    ctx.refs.jyaw:override("Disabled")
                end

                if ctx.menu.elements.antiaims.antiaims_tweaks:get('Static on fakelag') then
                    if cmd.choked_commands > 1 then
                        ctx.refs.yaw:override(0)
                        ctx.refs.jyaw:override("Disabled")
                        ctx.refs.jyaw_slider:override(0)
                        ctx.refs.fake_op:override("")
                        ctx.refs.left_limit:override(25)
                        ctx.refs.right_limit:override(25)
                        ctx.refs.inverter1:override(true)
                    end
                end

                ctx.refs.base_yaw:override(ctx.menu.elements.antiaims.manual_aa:get() ~= 'Disabled' and 'Local view' or nil)
                if ctx.menu.elements.antiaims.manual_aa:get() ~= 'Disabled' then
                    ctx.refs.yaw:override(ctx.menu.elements.antiaims.manual_aa:get() == 'Left' and -90 or 90)
                    if ctx.menu.elements.antiaims.manual_aa:get() == 'Forward' then ctx.refs.yaw:override(-180) end
                end
            end 
            
            if ctx.menu.elements.antiaims.antiaim_mode:get() ~= 3 then
                return
            end
        
           
            local d = custom_aa[b].enabled:get() and b or 1
            ctx.refs.yaw:set(0)
            ctx.refs.pitch:override(custom_aa[d].pitch:get())
            ctx.refs.yaw_base:override(custom_aa[d].yaw:get())
            ctx.refs.base_yaw:override(custom_aa[d].base:get())
            ctx.refs.enable_desync:override(custom_aa[d].body_yaw:get())
            ctx.refs.left_limit:override(custom_aa[d].fake_slider_main:get())
            ctx.refs.right_limit:override(custom_aa[d].fake_slider_next:get())
            ctx.refs.hidden:override(custom_aa[d].hidden:get())
            ctx.refs.inverter1:override(custom_aa[d].inverter:get())

            if custom_aa[d].jyaw:get() == '5-Way' then
                
                if custom_aa[d].type_mod:get() == 'Custom' then
                    local Way = { 0, 0, 0 };
                    ctx.refs.jyaw:override('Disabled')
                    ctx.refs.jyaw_slider:override(0)

                    Way = { custom_aa[d].way1:get(), custom_aa[d].way2:get(), custom_aa[d].way3:get(), custom_aa[d].way4:get(), custom_aa[d].way5:get() };
                    
                    local NewYaw = ctx.refs.yaw:get();
                
                    Ways.Number = Ways.Number + 1;

                    if (Ways.Number > #Way) then
                        Ways.Number = 1;
                    end

                    if (Way[Ways.Number] ~= nil) then
                        NewYaw = NewYaw + Way[Ways.Number];
                    end

                    ctx.refs.yaw:override(NewYaw);

                elseif custom_aa[d].type_mod:get() == 'Default' then
                    ctx.refs.jyaw:override(custom_aa[d].jyaw:get())
                    ctx.refs.jyaw_slider:override(custom_aa[d].offset_one:get())
                end

            elseif custom_aa[d].jyaw:get() == '3-Way' then
                
                if custom_aa[d].type_mod:get() == 'Custom' then
                    local Way = { 0, 0, 0 };
                    ctx.refs.jyaw:override('Disabled')
                    ctx.refs.jyaw_slider:override(0)

                    Way = { custom_aa[d].way1:get(), custom_aa[d].way2:get(), custom_aa[d].way3:get() };
                    
                    local NewYaw = ctx.refs.yaw:get();
                
                    Ways.Number = Ways.Number + 1;

                    if (Ways.Number > #Way) then
                        Ways.Number = 1;
                    end

                    if (Way[Ways.Number] ~= nil) then
                        NewYaw = NewYaw + Way[Ways.Number];
                    end

                    ctx.refs.yaw:override(NewYaw);

                elseif custom_aa[d].type_mod:get() == 'Default' then
                    ctx.refs.jyaw:override(custom_aa[d].jyaw:get())
                    ctx.refs.jyaw_slider:override(custom_aa[d].offset_one:get())
                end
                
                
                else
                    ctx.refs.jyaw:override(custom_aa[d].jyaw:get())

                    if custom_aa[d].type:get() == 'Default' then
                        ctx.refs.yaw:override(custom_aa[d].offset_l:get())
                    elseif custom_aa[d].type:get() == 'Left/Right' then
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and custom_aa[d].offset_l:get() or custom_aa[d].offset_r:get())
                    elseif custom_aa[d].type:get() == 'Delayed swap' then
                        if globals.tickcount % custom_aa[d].per_tick:get() == (custom_aa[d].per_tick:get() - 1) then some_var = not some_var end
                        ctx.refs.yaw:override(some_var and custom_aa[d].offset_l:get() or custom_aa[d].offset_r:get())
                        if custom_aa[d].delay:get() then
                            ctx.refs.inverter1:override(some_var and true or false)
                        end
                    end
                    
                    if custom_aa[d].mode:get() == 'Static' then
                        ctx.refs.jyaw_slider:override(custom_aa[d].offset_one:get())
                    elseif custom_aa[d].mode:get() == 'From/To' then
                        ctx.refs.jyaw_slider:override(math.random(custom_aa[d].offset_one:get(), custom_aa[d].offset_two:get()))
                    elseif custom_aa[d].mode:get() == 'Left/Right' then
                        ctx.refs.jyaw_slider:override(rage.antiaim:inverter() == true and custom_aa[d].offset_one:get() or custom_aa[d].offset_two:get())
                    end
                    
            end
            
            ctx.refs.fake_op:override(custom_aa[d].fake_op:get())
            ctx.refs.freestand:override(custom_aa[d].freestand:get())

            local f = ctx.menu.elements.antiaims.manual_aa:get()

            if ctx.menu.elements.antiaims.antiaims_tweaks:get('Disable FS on manual') and ctx.refs.freestanding_yaw:get() and (f == "Right" or f == "Left" or f == "Forward") then
                ctx.refs.freestanding_yaw:set(false)
            end

            if ctx.menu.elements.antiaims.antiaims_tweaks:get('Static on knife') then
                if entity_get_local_player():get_player_weapon() == nil then return end
                knife = entity_get_local_player():get_player_weapon():get_classname() == "CKnife"
                if knife then
                    ctx.refs.yaw:override(0)
                    ctx.refs.jyaw:override("Disabled")
                    ctx.refs.jyaw_slider:override(0)
                    ctx.refs.fake_op:override("")
                    ctx.refs.left_limit:override(25)
                    ctx.refs.right_limit:override(25)
                    ctx.refs.inverter1:override(true)
                end
            end

            if ctx.menu.elements.antiaims.antiaims_tweaks:get('Static on fakelag') then
                if cmd.choked_commands > 1 then
                    ctx.refs.yaw:override(0)
                    ctx.refs.jyaw:override("Disabled")
                    ctx.refs.jyaw_slider:override(0)
                    ctx.refs.fake_op:override("")
                    ctx.refs.left_limit:override(25)
                    ctx.refs.right_limit:override(25)
                    ctx.refs.inverter1:override(true)
                end
            end
        
            if (f == "Right" or f == "Left" or f == "Forward" or ctx.refs.freestanding_yaw:get()) and ctx.menu.elements.antiaims.antiaims_tweaks:get("Static manuals") then
                ctx.refs.fake_op:override({})
                ctx.refs.jyaw:override("Disabled")
            end
        
            ctx.refs.base_yaw:override(f ~= 'Disabled' and 'Local view' or custom_aa[d].base:get())
            if f ~= 'Disabled' then
                ctx.refs.yaw:override(f == 'Left' and -90 or 90)
                if f == 'Forward' then ctx.refs.yaw:override(-180) end
            end
        end)
    end
    antiaim_builder:custom_preset()
end

--console
function paint_c(fn)
    table.foreach(materials.get_materials("vgui/hud/800"), function(clr, console)
        console:color_modulate(fn)
        console:alpha_modulate(fn.a / 255)
    end)
    
    table.foreach(materials.get_materials("vgui_white"), function(clr, console)
        console:color_modulate(fn)
        console:alpha_modulate(fn.a / 255)
    end)
end

cvar.toggleconsole:set_callback(function()
    if not ctx.menu.elements.misc.console_changer:get() then
        return
    end

    paint_c(color())

    if not console_is_visible(engine_client) then
        paint_c(ctx.menu.elements.misc.console_color:get())
    end
end)

ctx.menu.elements.misc.console_color:set_callback(function(self)
    if not ctx.menu.elements.misc.console_changer:get() then
        return
    end
    
    paint_c(color())

    if console_is_visible(engine_client) then
        paint_c(ctx.menu.elements.misc.console_color:get())
    end
end)

ctx.menu.elements.misc.console_changer:set_callback(function(self)
    if not self:get() then
        paint_c(color())
    else
        paint_c(ctx.menu.elements.misc.console_color:get())
    end
end, true)

--console end

local handlers do
    local loadTime = common_get_unixtime()

    local mt = {
        __index = {
            events_cache = {  },

            add = function(self, event, callback, target_bool, name)
                target_bool = true
                if self.events_cache[event] == nil then
                    self.events_cache[event] = {  }
                end

                table_insert(self.events_cache[event], { callback, target_bool == nil and true or target_bool, name })
            end,

            action = function(self)
                local last_tick = 0

                local t = self.events_cache
                
                for n,_ in pairs(t) do
                    events[n](function(arg)

                        for _,func_tbl in pairs(t[n]) do
                            if func_tbl[2] then
                                local successfullInit, output = pcall(function() return func_tbl[1](arg) end)

                                if not successfullInit then
                                    local targetFunction = func_tbl[3] or 'unnamed'

                                    local output = output
                                        :gsub(' B9BECB', '')
                                        :gsub(' 9AEFEA', '')
                                        :gsub('BFFF90', ' ')

                                    print_raw(string_format('got unexpected error ∴ [%s ~ %s] - \aF42E12FF%s', targetFunction, n, output:gsub('FF4040', '\aECC257')))

                                    local formatedLog = base64.encode(string_format('[%s:%s] - %s', targetFunction, n, output:gsub('FF4040', '')))

                                    local time = common_get_unixtime()-loadTime
                                    local signature = md5.sumhexa(string_format('%s%s%s%sidealyawenc0192', common.get_username(), time, 'Mytools', formatedLog))

                                    local ctime = math.ceil(globals.realtime)

                                    if last_tick == ctime then
                                        return
                                    end

                                    cvar.play:call 'ambient\\weather\\rain_drip1'

                                    -- SEND CRASH LOG
                                    network.get('net nelzya di nahy'..common.get_username()..'&time='..time..'&luaPrefix=Mytools&errorLog='..formatedLog..'&signature=' .. signature, {  }, function() end)

                                    last_tick = ctime
                                end
                            end
                        end
                    end)
                end
            end
        },

        __metatable = false
    }

    handlers = setmetatable({  }, mt)
end

aa_state, dt_alpha, hs_alpha, dmg_alpha, x_value, wp = 'TARGET', 0, 0, 0, 0, 0

handlers:add('createmove', function(cmd)
    if ctx.menu.elements.antiaims.defensive_aa:get() then
        local def_pitch = ctx.menu.elements.antiaims.defensive_pitch:get()
        local def_yaw = ctx.menu.elements.antiaims.defensive_yaw:get()

        if ctx.menu.elements.antiaims.defensive_type:get() == 'Presets' then
            if def_pitch == "Disabled" then
                rage.antiaim:override_hidden_pitch(0)
            elseif def_pitch == "Up" then
                rage.antiaim:override_hidden_pitch(-89)
            elseif def_pitch == "Down" then
                rage.antiaim:override_hidden_pitch(89)
            elseif def_pitch == "Semi Up" then
                rage.antiaim:override_hidden_pitch(-45)
            elseif def_pitch == "Semi Down" then
                rage.antiaim:override_hidden_pitch(45)
            elseif def_pitch == "Random" then

                local stage = globals.tickcount % 5

                if stage == 0 then
                    rage.antiaim:override_hidden_pitch(-89)
                elseif stage == 1 then
                    rage.antiaim:override_hidden_pitch(-89)
                elseif stage == 2 then
                    rage.antiaim:override_hidden_pitch(0)
                elseif stage == 3 then
                    rage.antiaim:override_hidden_pitch(89)
                elseif stage == 4 then
                    rage.antiaim:override_hidden_pitch(89)
                end
            end

            if def_yaw == "Disabled" then
                rage.antiaim:override_hidden_yaw_offset(0)
            elseif def_yaw == "Sideways" then

                local stage = cmd.tickcount % 3

                if stage == 0 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-100, -90))
                elseif stage == 2 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(90, 180))
                end
                elseif def_yaw == "Opposite" then
                    rage.antiaim:override_hidden_yaw_offset(-180)
                elseif def_yaw == "Spin" then
                    local calcspin = (globals.curtime * 550)
                    calcspin = math.normalize_yaw(calcspin)

                    rage.antiaim:override_hidden_yaw_offset(calcspin)
                elseif def_yaw == "Random" then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-180, 180))
                elseif def_yaw == "3-Way" then

                    local stage = cmd.tickcount % 3

                    if stage == 0 then
                        rage.antiaim:override_hidden_yaw_offset(utils.random_int(-110, -90))
                    elseif stage == 1 then
                        rage.antiaim:override_hidden_yaw_offset(utils.random_int(90, 120))
                    elseif stage == 2 then
                        rage.antiaim:override_hidden_yaw_offset(utils.random_int(-180, -150))
                    end

                elseif def_yaw == "5-Way" then

                local stage = cmd.tickcount % 5
                if stage == 0 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-90, -75))
                elseif stage == 1 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-45, -30))
                elseif stage == 2 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-180, -160))
                elseif stage == 3 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(45, 60))
                elseif stage == 4 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(90, 110))
                end
            end
        end

        if ctx.menu.elements.antiaims.defensive_type:get() == 'Custom' then
            rage.antiaim:override_hidden_pitch(ctx.menu.elements.antiaims.custom_pitch:get())
            rage.antiaim:override_hidden_yaw_offset(ctx.menu.elements.antiaims.custom_yaw:get())
        end

        local lp = entity_get_local_player()
        local lp_vel = antiaim_builder:get_velocity(lp)
        local state = antiaim_builder:state(lp_vel, nil, cmd)
        local b = state

        local cond_active = false

        if (b == 2 and ctx.menu.elements.antiaims.lag_conditions:get("Standing")) or
            (b == 3 and ctx.menu.elements.antiaims.lag_conditions:get("Moving")) or
            (b == 4 and ctx.menu.elements.antiaims.lag_conditions:get("Slow Walking")) or
            (b == 7 and ctx.menu.elements.antiaims.lag_conditions:get("Crouching")) or
            (b == 8 and ctx.menu.elements.antiaims.lag_conditions:get("Crouch Move")) or
            ((b == 5 or b == 6) and ctx.menu.elements.antiaims.lag_conditions:get("In Air"))
        then
            cond_active = true
        else
            cond_active = false
        end

        if cond_active == true then
            ctx.refs.hidden:override(true)
        else
            ctx.refs.hidden:override()
        end

        local f = ctx.menu.elements.antiaims.manual_aa:get()

        if (f == "Right" or f == "Left" or f == "Forward" or ctx.refs.freestanding_yaw:get()) and
            ctx.menu.elements.antiaims.defensive_disablers:get()
        then
            ctx.refs.hidden:override(false)
        end
    end
end, true, 'custom_defensive')


handlers:add('createmove', function()
    if entity.get_local_player() == nil then return end
    if entity.get_local_player():get_player_weapon() == nil then return end

    local weapon_index = entity.get_local_player():get_player_weapon():get_weapon_index()
    local is_grenade = weapon_index == 43 or weapon_index == 44 or weapon_index == 45 or weapon_index == 46 or weapon_index == 47 or weapon_index == 48

    if (ctx.menu.elements.antiaims.defensive_aa:get() and ctx.menu.elements.antiaims.defensive_disablers1:get()) and is_grenade then ctx.refs.hidden:override(false) end
end, true, 'grenades_defensive')

--tag
local misc = {}
misc._last_clantag = nil
misc._set_clantag = ffi.cast('int(__fastcall*)(const char*, const char*)', utils.opcode_scan('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))
local set_clantag = function(v)
    if v == misc._last_clantag then return end
    misc._set_clantag(v, v)
    misc._last_clantag = v
  end
  
  local build_tag = function(tag)
    local ret = { ' ' }
    
    for i = 1, #tag do
        table.insert(ret, tag:sub(1, i))
    end
    
    for i = #ret - 1, 1, -1 do
        table.insert(ret, ret[i])
    end
    
    return ret
end

handlers:add('render', function()
    if not ctx.menu.elements.misc.clantag_changer:get() then set_clantag(" ", " ") return end
    if not globals.is_connected then return end
    tag = build_tag('mytools    ')
    local netchann_info = utils.net_channel()
    if netchann_info == nil then return end

    local latency = netchann_info.avg_latency[0] / globals.client_tick
    local tickcount_pred = globals.tickcount + latency
    local iter = math.floor(math.fmod(tickcount_pred / 30, #tag + 1) + 1)

    set_clantag(tag[iter])
end, true, 'clantag')

local hit, misses = 0, 0

handlers:add('aim_ack', function(e)
    if ctx.menu.elements.visuals.sindicators:get('Hit Percentage') then
        if e.state == nil then hit = hit + 1 else misses = misses + 1 end
    end
end, true, 'aim_ack_aimbot_stats')

local c4_info = {
    planting = false,
    on_plant_time = 0,
    fill = 0,
    planting_site = ""
}

local c4_img = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(100, 100))

local OldChoke, toDraw4, toDraw3, toDraw2, toDraw1, toDraw0 = 0, 0, 0, 0, 0, 0

handlers:add('createmove', function(cmd)
    if entity_get_local_player() == nil or entity_get_local_player():is_alive() == false then return end
        
    if cmd.choked_commands < OldChoke then
        toDraw0 = toDraw1
        toDraw1 = toDraw2
        toDraw2 = toDraw3
        toDraw3 = toDraw4
        toDraw4 = OldChoke
    end

    OldChoke = cmd.choked_commands
end, true, 'chokes_commands')

render_indicator = function(str, ay, clr, circle_clr, circle_degree, bomb_ic)
    local x, y = render_screen_size().x/100 + 9, render_screen_size().y/1.47
    ts = render.measure_text(font, nil, str)

   
    render.gradient(vector(x/1.9, y + ay), vector(x/1.9 + (ts.x) / 2 + 5, y + ay + ts.y + 11), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50))
    render.gradient(vector(x/1.9 + (ts.x) / 2 + 5, y + ay), vector(x/1.9 + (ts.x) + 40, y + ay + ts.y + 11), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0))
    render.text(font, vector(x, y + 8 + ay), clr, nil, str)
    
    if bomb_ic == true then
        render.texture(c4_img, vector(x, y + ay + 2), vector(32, 30), clr, 'f', 1)
    end

    if circle_clr and circle_degree then
        render.circle_outline(vector(x + ts.x + 18, y + ay + ts.y/2+8), color(0, 0, 0, 255), 10, 1, 10, 5)
        render.circle_outline(vector(x + ts.x + 18, y + ay + ts.y/2+8), circle_clr, 9, 1, circle_degree, 3)
    end
end

handlers:add('render', function()
    local player = entity_get_local_player()
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
            local defusetimer = defusestart and (c4.m_flDefuseCountDown - globals.curtime) or -1
            if defusetimer > 0 then
                local clr = timer > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)
                    
                local barlength = (((render_screen_size().y - 50) / defuselength) * (defusetimer))
                render.rect(vector(0.0, 0.0), vector(16, render_screen_size().y), color(25, 25, 25, 160))
                render.rect_outline(vector(0.0, 0.0), vector(16, render_screen_size().y), color(25, 25, 25, 160))
                    
                render.rect(vector(0, render_screen_size().y - barlength), vector(16, render_screen_size().y), clr)
            end
                
            bombsite = c4.m_nBombSite == 0 and "A" or "B"
           
            local eLoc = c4.m_vecOrigin

            
            if player.m_hObserverTarget and (player.m_iObserverMode == 4 or player.m_iObserverMode == 5) then
                lLoc = player.m_hObserverTarget['m_vecOrigin']
                health = player.m_hObserverTarget['m_iHealth']
                armor = player.m_hObserverTarget['m_ArmorValue']
            else
                lLoc = player.m_vecOrigin
                health = player.m_iHealth
                armor = player.m_ArmorValue
            end

            if armor == nil then return end
            if health == nil then return end
            if lLoc == nil then return end

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
    

    local adjust_adding = 40
    local add_y = 0

    for _, enemy in ipairs(entity.get_players(true)) do
        if enemy == nil then fnayf = false end
        if enemy ~= nil and enemy:is_enemy() and enemy:is_dormant() then fnayf = true else
            fnayf = false end
    end

    smdmg, fnaychance = false, 0

    chance = (hit / (misses + hit))*100
    if hit == 0 and misses == 0 then fnaychance = 0 else fnaychance = chance end

    local binds = ui.get_binds()
    for k, v in pairs(binds) do
        if v.active and v.name == 'Min. Damage' then
            smdmg = true
        end
    end

    local binds = {
        {string_format('%i-%i-%i-%i-%i', toDraw4, toDraw3, toDraw2, toDraw1, toDraw0), ctx.menu.elements.visuals.sindicators:get('Choked commands') and player:is_alive(), color(200, 199, 197)},
        {string_format("%s", math.floor(fnaychance)) .. "%", ctx.menu.elements.visuals.sindicators:get('Hit Percentage') and player:is_alive(), color(200, 199, 197)},
        {"PING", ctx.menu.elements.visuals.sindicators:get('Ping spike') and player:is_alive() and ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):get() > 0 and player:is_alive(), color(163, 194, 43)},
        {"BODY", ctx.menu.elements.visuals.sindicators:get('Body Aim') and player:is_alive() and ctx.refs.body_aim:get() == 'Force', color(200, 199, 197)},
        {"DT", ctx.menu.elements.visuals.sindicators:get('Double tap') and player:is_alive() and ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get() and not ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(), rage.exploit:get() == 1 and color(200, 199, 197) or color(255, 0, 50)},
        {"DA", ctx.menu.elements.visuals.sindicators:get('Dormant aimbot') and player:is_alive() and ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"):get(), fnayf == true and color(200, 199, 197) or color(255, 0, 50)},
        {"DUCK", ctx.menu.elements.visuals.sindicators:get('Fake duck') and player:is_alive() and ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(), color(200, 199, 197)},
        {"MD", ctx.menu.elements.visuals.sindicators:get('Minimum damage') and player:is_alive() and smdmg == true, color(200, 199, 197)},
        {"FS", ctx.menu.elements.visuals.sindicators:get('Freestanding') and player:is_alive() and ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):get(), color(200, 199, 197)},
        {"        " .. bombsite .." - " .. string_format("%.1f", timer) .. "s", ctx.menu.elements.visuals.sindicators:get('Bomb info') and timer > 0 and not defused, color(200, 199, 197), nil, nil, true},
        {"FATAL", ctx.menu.elements.visuals.sindicators:get('Bomb info') and willKill, color(255, 0, 50, 255)},
        {"-" .. dmg .. " HP", ctx.menu.elements.visuals.sindicators:get('Bomb info') and not willKill and damage > 0.5, color(210, 216, 112, 255)},
        {"        " .. c4_info.planting_site, ctx.menu.elements.visuals.sindicators:get('Bomb info') and c4_info.planting, color(210, 216, 112, 255), color(255, 255), c4_info.fill/3.2, true},
        {"OSAA", ctx.menu.elements.visuals.sindicators:get('Hide shots') and player:is_alive() and ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"):get() and not ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get() and not ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(), color(200, 199, 197)}
    }

    for k, v in pairs(binds) do
        if v[2] then
            render_indicator(v[1], add_y, v[3], v[4], v[5], v[6])
            add_y = add_y - adjust_adding
        end
    end
end, true, 'sindicators')    

c4_info.reset = function()
    if not ctx.menu.elements.visuals.sindicators:get('Bomb info') then return end
    c4_info.planting = false
	c4_info.fill = 0
	c4_info.on_plant_time = 0
	c4_info.planting_site = ""
end

c4_info.bomb_beginplant = function(e)
    if not ctx.menu.elements.visuals.sindicators:get('Bomb info') then return end
    local player_resource = entity_get_player_resource()

    if player_resource == nil then
        return
    end

    c4_info.on_plant_time = globals.curtime
    c4_info.planting = true

    if c4_info.on_plant_time == nil then return end

    local m_bombsiteCenterA = player_resource.m_bombsiteCenterA
    local m_bombsiteCenterB = player_resource.m_bombsiteCenterB

    local userid = entity.get(e.userid, true)
    if userid == nil then return end

    local userid_origin = userid:get_origin()
    if userid_origin == nil then return end

    if m_bombsiteCenterA == nil or m_bombsiteCenterB == nil then return end

    local dist_to_a = userid_origin:dist(m_bombsiteCenterA)
    local dist_to_b = userid_origin:dist(m_bombsiteCenterB)

    c4_info.planting_site = dist_to_a < dist_to_b and "A" or "B"
end

handlers:add('bomb_beginplant', function(e) c4_info.bomb_beginplant(e) end, true, 'bombbegin')  
handlers:add('bomb_abortplant', function() c4_info.reset() end, true, 'bombabort') 
handlers:add('bomb_planted', function() c4_info.reset() end, true, 'bombplanted') 
handlers:add('bomb_defused', function() c4_info.reset() end, true, 'bombdefused') 
handlers:add('bomb_pickup', function() c4_info.reset() end, true, 'bombpickup') 
handlers:add('round_start', function() c4_info.reset() end, true, 'roundstart')

handlers:add('render', function()
    local x, y = render_screen_size().x, render_screen_size().y
    if ctx.menu.elements.visuals.on_screen:get() and ctx.menu.elements.visuals.select:get() == 'Default' then
        if entity_get_local_player() == nil then return end
        if entity_get_local_player():is_alive() == false then return end
        local velocity = function(ent)
            local speed_x = ent["m_vecVelocity[0]"]
            local speed_y = ent["m_vecVelocity[1]"]
            local speed = math.sqrt(speed_x * speed_x + speed_y * speed_y)
            return speed
        end

        local lp_vel = velocity(entity_get_local_player())
        local jumping = bit.band(entity_get_local_player()["m_fFlags"], bit.lshift(1,0)) == 0 or common.is_button_down(0x20)
        local is_crouching = entity_get_local_player()["m_flDuckAmount"] > 0.8 or common.is_button_down(0xA2)
        local mdmg = false

        if (jumping and not is_crouching) or (jumping and is_crouching) then
            aa_state = ctx.menu.elements.visuals.fonts:get() == 'Small' and "- JUMPING -" or "jumping"
        elseif not jumping and not common.is_button_down(0x20) and is_crouching or ctx.refs.fake_duck:get() then
            aa_state = ctx.menu.elements.visuals.fonts:get() == 'Small' and "- CROUCH -" or "crouch"
        elseif (not is_crouching or ctx.refs.fake_duck) and not jumping and not ctx.refs.slowwalk:get() and lp_vel > 4 then
            aa_state = ctx.menu.elements.visuals.fonts:get() == 'Small' and "- MOVING -" or "moving"
        elseif ctx.refs.slowwalk:get() then
            aa_state = ctx.menu.elements.visuals.fonts:get() == 'Small' and "- SLOWWALK -" or "slowwalk"
        elseif lp_vel < 5 and (not is_crouching or ctx.refs.fake_duck) and not jumping then
            aa_state = ctx.menu.elements.visuals.fonts:get() == 'Small' and "- STANDING -" or "standing"
        end
        --

        local binds = ui_get_binds();
        for k, v in pairs(binds) do
            if v.active and v.name == 'Min. Damage' then
            mdmg = true
            end
        end

        if entity.get_local_player():get_player_weapon() == nil then return end
        local weapon_index = entity.get_local_player():get_player_weapon():get_weapon_index()
        local is_grenade = weapon_index == 43 or weapon_index == 44 or weapon_index == 45 or weapon_index == 46 or weapon_index == 47 or weapon_index == 48
        
        x_value = lerp(globals.frametime * 16, x_value, entity_get_local_player().m_bIsScoped and x/2 + 43 or x/2)
        dt_alpha = lerp(globals.frametime * 8, dt_alpha, (ctx.refs.dt:get() and (is_grenade and 100 or 255) or 0))
        hs_alpha = lerp(globals.frametime * 8, hs_alpha, (ctx.refs.hs:get() and (is_grenade and 100 or 255) or 0))
        dmg_alpha = lerp(globals.frametime * 8, dmg_alpha, (mdmg == true and (is_grenade and 100 or 255) or 0))
        wp = lerp(globals.frametime * 8, wp, (is_grenade and 100 or 255))
        
        alpha_cl = clamp((math.floor(math.sin(globals.realtime * 5) * (1*255/2-1) + 1*255/2) or 1*255), 35, 255)
        render.shadow(ctx.menu.elements.visuals.fonts:get() == 'Small' and vector(x_value - 20, y/2 + 20) or vector(x_value - 35, y/2 + 20), ctx.menu.elements.visuals.fonts:get() == 'Small' and vector(x_value + 20, y/2 + 20) or vector(x_value + 30, y/2 + 20), ctx.menu.elements.visuals.indicator_color:get(), ctx.menu.elements.visuals.glow_px:get(), 0, 0)
        
        indicator_text = modify.gradient(ctx.menu.elements.visuals.fonts:get() == 'Small' and (ctx.cheat.version == 'Nightly' and "NIGHTLY" or 'STABLE') or (ctx.cheat.version == 'Nightly' and "nightly" or 'stable'), color(ctx.menu.elements.visuals.build_color:get().r, ctx.menu.elements.visuals.build_color:get().g, ctx.menu.elements.visuals.build_color:get().b, alpha_cl), color(ctx.menu.elements.visuals.build_color:get().r, ctx.menu.elements.visuals.build_color:get().g, ctx.menu.elements.visuals.build_color:get().b, alpha_cl))

        render_text(ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, vector(x_value, y/2 + 20), color(ctx.menu.elements.visuals.indicator_color:get().r, ctx.menu.elements.visuals.indicator_color:get().g, ctx.menu.elements.visuals.indicator_color:get().b, wp), "c", ctx.menu.elements.visuals.fonts:get() == 'Small' and ("MYTOOLS  " .. indicator_text) or ("mytools " .. indicator_text))
        render_interpolate_string("aa_ind", vector(x_value, y/2 + 30), ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, color(255, wp), nil, aa_state)

        if ctx.refs.dt:get() and not ui_find("Aimbot", "Ragebot", "Main", "Peek Assist"):get() then
            render_interpolate_string("dt_ind", vector(x_value, y/2 + 40), ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, color(255, 255, 255, dt_alpha), nil, rage.exploit:get() == 1 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'DT  ' or 'dt ') .. (get_defensive(entity_get_local_player(), true) > 2 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\a7FFFFFFFACTIVE' or '\a7FFFFFFFactive') or (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\aC0FF91FFREADY' or '\aC0FF91FFready')) or (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'DT  ' or 'dt ') .. (ctx.menu.elements.visuals.fonts:get() == 'Small' and "\aFF9494FFWAITING" or "\aFF9494FFwaiting"))
        elseif ctx.refs.dt:get() and ui_find("Aimbot", "Ragebot", "Main", "Peek Assist"):get() then
            render_interpolate_string("dt_ind", vector(x_value, y/2 + 40), ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, color(255, 255, 255, dt_alpha), nil, rage.exploit:get() == 1 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'IDEALTICK  ' or 'idealtick ') .. (get_defensive(entity_get_local_player(), true) > 2 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\a7FFFFFFFACTIVE' or '\a7FFFFFFFactive') or (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\aC0FF91FFREADY' or '\aC0FF91FFready')) or (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'IDEALTICK  ' or 'idealtick ') .. (ctx.menu.elements.visuals.fonts:get() == 'Small' and "\aFF9494FFWAITING" or "\aFF9494FFwaiting"))
        elseif ctx.refs.hs:get() and not ctx.refs.dt:get() then
            render_interpolate_string("dt_ind", vector(x_value, y/2 + 40), ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, color(255, 255, 255, hs_alpha), nil, rage.exploit:get() == 1 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'HIDE  ' or 'hide ') .. (get_defensive(entity_get_local_player(), true) > 2 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\a7FFFFFFFACTIVE' or '\a7FFFFFFFactive') or (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\aC0FF91FFREADY' or '\aC0FF91FFready')) or (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'HIDE  ' or 'hide ') .. (ctx.menu.elements.visuals.fonts:get() == 'Small' and "\aFF9494FFWAITING" or "\aFF9494FFwaiting"))
        end

        render_interpolate_string("dmg_ind", vector(x_value, (ctx.refs.dt:get() or ctx.refs.hs:get()) and y/2 + 50 or y/2 + 40), ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, color(255, 255, 255, mdmg == true and 255 or 0), nil, ctx.menu.elements.visuals.fonts:get() == 'Small' and (mdmg == true and "DMG" or "   ") or (mdmg == true and "dmg" or "   "))
    end

    if ctx.menu.elements.visuals.sindicators:get('Spectator list') then
        local me = entity_get_local_player()
        if me == nil then return end
        if me.m_hObserverTarget and (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
            me = me.m_hObserverTarget
        end

        local speclist = me:get_spectators()
        if speclist == nil then return end
        
        for idx,player_ptr in ipairs(speclist) do
            local sx, sy = render_screen_size().x, render_screen_size().y

            local name = player_ptr:get_name()
            local tx = render_measure_text(1, '', name).x

            if player_ptr:is_bot() and not player_ptr:is_player() then goto skip end
            render_text(1, vector(sx - tx - 7, -10 + (idx*20)), color(), 'u', name)
            ::skip::
        end
    end

    if ctx.menu.elements.visuals.arrows_style:get() == 'Default' then
        if not globals.is_connected then return end
        local player = entity_get_local_player()
        if player == nil then return end
        if player:is_alive() == false then return end
        if rage.antiaim:get_rotation(true) - rage.antiaim:get_rotation() > 0 then
            invert = true
        elseif rage.antiaim:get_rotation(true) - rage.antiaim:get_rotation() < 0 then
            invert = false
        end
        local x = render_screen_size().x / 2  
        local y = render_screen_size().y / 2
        
        local UPx = vector(x + 9, y - 43)
        local UPy = vector(x - 9, y - 43)
        local UPz = vector(x, y - 56)
        local DPx1 = vector(x + 9, y + 50)
        local DPy1 = vector(x - 9, y + 50)
        local DPz1 = vector(x, y + 63)
        local DPx = vector(x + 9, y + 43)
        local DPy = vector(x - 9, y + 43)
        local DPz = vector(x, y + 56)
        local LPx = vector(x - 43, y + 9)
        local LPy = vector(x - 43, y - 9)
        local LPz = vector(x - 56, y)
        local RPx = vector(x + 43, y + 9)
        local RPy = vector(x + 43, y - 9)
        local RPz = vector(x + 56, y)
    
        local LPx = vector(x - 43, y + 9)
        local LPy = vector(x - 43, y - 9)
        local LPz = vector(x - 56, y)
        local RPx = vector(x + 43, y + 9)
        local RPy = vector(x + 43, y - 9)
        local RPz = vector(x + 56, y)
        
        render.poly(ctx.menu.elements.antiaims.manual_aa:get() == 'Right' and color(ctx.menu.elements.visuals.arrows_color:get().r, ctx.menu.elements.visuals.arrows_color:get().g, ctx.menu.elements.visuals.arrows_color:get().b, ctx.menu.elements.visuals.arrows_color:get().a) or color(15, 15, 15, 115), RPx, RPz, RPy)
        render.poly(ctx.menu.elements.antiaims.manual_aa:get() == 'Left' and color(ctx.menu.elements.visuals.arrows_color:get().r, ctx.menu.elements.visuals.arrows_color:get().g, ctx.menu.elements.visuals.arrows_color:get().b, ctx.menu.elements.visuals.arrows_color:get().a) or color(15, 15, 15, 115), LPx, LPz, LPy)
        
        if ctx.menu.elements.antiaims.manual_aa:get() == 'Right' then
            render.rect(vector(x - 40, y - 9), vector(x - 42, y + 9), color(15, 15, 15, 115), 0, true)
            render.rect(vector(x + 40, y - 9), vector(x + 42, y + 9), color(ctx.menu.elements.visuals.arrows_color:get().r, ctx.menu.elements.visuals.arrows_color:get().g, ctx.menu.elements.visuals.arrows_color:get().b, ctx.menu.elements.visuals.arrows_color:get().a), 0, true)
        elseif ctx.menu.elements.antiaims.manual_aa:get() == 'Left' then
            render.rect(vector(x + 40, y - 9), vector(x + 42, y + 9), color(15, 15, 15, 115), 0, true)
            render.rect(vector(x - 40, y - 9), vector(x - 42, y + 9), color(ctx.menu.elements.visuals.arrows_color:get().r, ctx.menu.elements.visuals.arrows_color:get().g, ctx.menu.elements.visuals.arrows_color:get().b, ctx.menu.elements.visuals.arrows_color:get().a), 0, true)
        else
            render.rect(vector(x - 40, y - 9), vector(x - 42, y + 9), invert and color(15, 15, 15, 115) or color(ctx.menu.elements.visuals.arrows_color:get().r, ctx.menu.elements.visuals.arrows_color:get().g, ctx.menu.elements.visuals.arrows_color:get().b, ctx.menu.elements.visuals.arrows_color:get().a), 0, true)
            render.rect(vector(x + 40, y - 9), vector(x + 42, y + 9), invert and color(ctx.menu.elements.visuals.arrows_color:get().r, ctx.menu.elements.visuals.arrows_color:get().g, ctx.menu.elements.visuals.arrows_color:get().b, ctx.menu.elements.visuals.arrows_color:get().a) or color(15, 15, 15, 115), 0, true)
        end
    end
end, true, 'indicators')

local anti_aim_on_use, start_curtime = false, globals.curtime

handlers:add('createmove', function(cmd)
    local local_player = entity_get_local_player()
    if local_player == nil then return end
    local m_iTeamNum = local_player.m_iTeamNum
    local use = bit.rshift(bit.lshift(cmd.buttons, 26), 31)
    if local_player:get_player_weapon() == nil then return end
    local anti_aim_on_use_work = true
    for i, entities in pairs({entity.get_entities("CPlantedC4"), entity.get_entities("CHostage")}) do
        for i, entity in pairs(entities) do
            if local_player:get_origin():dist(entity:get_origin()) < 65 and local_player:get_origin():dist(entity:get_origin()) > 1 and m_iTeamNum == 3 then
                anti_aim_on_use_work = false
            end
        end
    end
    if m_iTeamNum == 2 and local_player.m_bInBombZone and local_player:get_player_weapon():get_weapon_index() == 49 then
        anti_aim_on_use_work = false
    end
    
   
    if ctx.menu.elements.antiaims.antiaims_tweaks:get('Anti-aim on use') and ctx.menu.elements.antiaims.manual_aa:get() == 'Left' or ctx.menu.elements.antiaims.manual_aa:get() == 'Right' or ctx.menu.elements.antiaims.manual_aa:get() == 'Forward' or ctx.refs.freestanding_def:get() and use ~= 0 and anti_aim_on_use_work then return end
    if ctx.menu.elements.antiaims.antiaims_tweaks:get('Anti-aim on use') and use ~= 0 and anti_aim_on_use_work then
        if globals.curtime - start_curtime > 0.02 then
            cmd.buttons = bit.band(cmd.buttons, bit.bnot(32))
            anti_aim_on_use = true
            ctx.refs.left_limit:override(60)
            ctx.refs.right_limit:override(60)
            ctx.refs.pitch:override('Disabled')
            ctx.refs.yaw:override(180)
            ctx.refs.jyaw_slider:override(5)
            ctx.refs.base:override('Local View')
        end
    else
        start_curtime = globals.curtime
		anti_aim_on_use = false
    end
end, true, 'legit_antiaim')

handlers:add('createmove', function(c) 
    if ctx.menu.elements.antiaims.antiaims_tweaks:get("Bombsite E Fix") then
        local plocal = entity_get_local_player()
        if entity_get_local_player() == nil then return end
        if plocal:get_player_weapon() == nil then return end
        local team_num, on_bombsite, defusing = plocal.m_iTeamNum, plocal.m_bInBombZone, team_num == 3
        local trynna_plant = team_num == 2 and has_bomb
        local inbomb = on_bombsite ~= false

        local use = common.is_button_down(0x45)

        if not inbomb and ctx.menu.elements.antiaims.antiaims_tweaks:get('Anti-aim on use') then return end
        if inbomb and not trynna_plant and not defusing and use then
            ctx.refs.jyaw_slider:override(0)
            ctx.refs.left_limit:override(0)
            ctx.refs.right_limit:override(0)
            ctx.refs.pitch:override('Disabled')
            ctx.refs.yaw_base:override('Disabled')
            ctx.refs.base:override('Local View')
        end

        if inbomb and not trynna_plant and not defusing then
            c.in_use = 0
        end
    end
end, true, 'bombsitefix')

local raw_hwnd 			= utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B") or error("Invalid signature #1")
local raw_FlashWindow 	= utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7") or error("Invalid signature #2")
local raw_insn_jmp_ecx 	= utils.opcode_scan("gameoverlayrenderer.dll", "FF E1") or error("Invalid signature #3")
local raw_GetForegroundWindow = utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74") or error("Invalid signature #4")
local hwnd_ptr 		= ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", raw_hwnd) + 2)[0])[0] + 2)
local FlashWindow 	= ffi.cast("int(__stdcall*)(uintptr_t, int)", raw_FlashWindow)
local insn_jmp_ecx 	= ffi.cast("int(__thiscall*)(uintptr_t)", raw_insn_jmp_ecx)
local GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", raw_GetForegroundWindow) + 2)[0])[0]

local function get_csgo_hwnd()
	return hwnd_ptr[0]
end

local function get_foreground_hwnd()
	return insn_jmp_ecx(GetForegroundWindow)
end

local function notify_user()
	local csgo_hwnd = get_csgo_hwnd()
	if get_foreground_hwnd() ~= csgo_hwnd then
		FlashWindow(csgo_hwnd, 1)
		return true
	end
	return false
end

handlers:add('round_start', function() 
    if ctx.menu.elements.misc.taskbar:get() then
        notify_user()
    end
end, true, 'taskbarnotify')

handlers:add('round_start', function()
    local state = ctx.menu.elements.misc.muteunmute:get()

    if not state then
        return
    end

    entity.get_players(false, true, function(player_ptr)
        local player = panorama.MatchStatsAPI.GetPlayerXuid(
            player_ptr:get_index()
        )

        if panorama.GameStateAPI.HasCommunicationAbuseMute(player) then
        if not panorama.GameStateAPI.IsSelectedPlayerMuted(player) then goto skip end

        panorama.GameStateAPI.ToggleMute(player)
        ::skip::
        end
    end)
end, true, 'autounmute')

handlers:add('createmove', function(cmd)
    if ctx.menu.elements.antiaims.anim_breakers:get('Legs on ground') and ctx.menu.elements.antiaims.type_legs_ground:get() == 'Jitter' then
        ctx.refs.legmovement:override(cmd.command_number % 3 == 0 and 'Default' or 'Sliding')
    end
end, true, 'slider_legs')   

local function get_anim_layer(b,c)c=c or 1;b=ffi.cast(ffi.typeof('void***'),b)return ffi.cast('c_animlayers**',ffi.cast('char*',b)+0x2990)[0][c]end

handlers:add('post_update_client_side_animation', function()
    if entity_get_local_player() == nil then return end
    if not entity_get_local_player():is_alive() then return end

    if ctx.menu.elements.antiaims.anim_breakers:get('Legs in air') and ctx.menu.elements.antiaims.type_legs_air:get() == 'Static' then
        entity_get_local_player().m_flPoseParameter[6] = 1
    end

    if ctx.menu.elements.antiaims.anim_breakers:get('Legs on ground') and ctx.menu.elements.antiaims.type_legs_ground:get() == 'Sliding' then
        entity_get_local_player().m_flPoseParameter[0] = 1
        ctx.refs.legmovement:set('Sliding')
    end

    if ctx.menu.elements.antiaims.anim_breakers:get('Legs on ground') and ctx.menu.elements.antiaims.type_legs_ground:get() == 'Jitter' then
        entity_get_local_player().m_flPoseParameter[0] = globals.tickcount % 4 > 1 and 0.5 or 1
        ctx.refs.legmovement:set('Sliding')
    end

    if ctx.menu.elements.antiaims.anim_breakers:get('Legs on ground') and ctx.menu.elements.antiaims.type_legs_ground:get() == 'Allah' then
        entity_get_local_player().m_flPoseParameter[7] = 0
        ctx.refs.legmovement:set('Walking')
    end

    if ctx.menu.elements.antiaims.anim_breakers:get('Increase Move Lean') then
        get_anim_layer(get_entity_address(entity_get_local_player():get_index()), 12).m_flWeight = 10
    end

    if ctx.menu.elements.antiaims.anim_breakers:get('Legs in air') and ctx.menu.elements.antiaims.type_legs_air:get() == 'Allah' then
        local velocity = function(ent)
            local speed_x = ent["m_vecVelocity[0]"]
            local speed_y = ent["m_vecVelocity[1]"]
            local speed = math.sqrt(speed_x * speed_x + speed_y * speed_y)
            return speed
        end

        if bit.band(entity_get_local_player().m_fFlags, bit.lshift(1, 0)) == 0 and velocity(entity_get_local_player()) > 2 then
            get_anim_layer(get_entity_address(entity_get_local_player():get_index()), 6).m_flWeight = 1
        end
    end
end, true, 'anim_breakers')

handlers:add('createmove', function(cmd)
    if not ctx.menu.elements.misc.movement_helpers:get('Fast ladder') then return end

    self = entity_get_local_player()

    if self == nil then return end

    if self.m_MoveType == 9 then
        cmd.view_angles.y = math.floor(cmd.view_angles.y + 0.5)

        if cmd.forwardmove > 0 then
            if cmd.view_angles.x < 45 then
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
        elseif cmd.forwardmove < 0 then
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
end, true, 'fastladder')    

handlers:add('shutdown', function()
    set_clantag(" ", " ") 
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
    cvar.r_aspectratio:float(0)
    ctx.refs.logs:override()
    ctx.refs.pitch:override()
    ctx.refs.yaw_base:override()
    ctx.refs.enable_desync:override()
    ctx.refs.left_limit:override()
    ctx.refs.right_limit:override()
    ctx.refs.jyaw:override()
    ctx.refs.jyaw_slider:override()
    ctx.refs.fake_op:override()
    ctx.refs.freestand:override()
    ctx.refs.yaw:override()
    ctx.refs.inverter1:override()
    ctx.refs.body_aim:override()
    ctx.refs.disablers:override()
    cvar.sv_maxunlag:float(0.2)
    if not entity.get_local_player() == nil then entity.get_local_player():set_icon() end
    ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):override()
    ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override()
    ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override()
    ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override()
    ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set(current)

    paint_c(color(255, 255, 255, 255))
end, true, 'disable_lua') 

handlers:action()


--indicators
local example1 = smoothy.new(ctx.refs.min_dmg:get())
local gr_alpha = 0

local new_drag_object = drag_system.register({ctx.menu.elements.visuals.dmg_indx, ctx.menu.elements.visuals.dmg_indy}, vector(20, 15), "Test", function(self)
    if entity_get_local_player() == nil then return end
    if entity_get_local_player():is_alive() == false then return end
    if ctx.menu.elements.visuals.damage_indicator:get() and ui_get_alpha() > 0.3 then
        render_rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100), 0, 5)
    end
    
    local example1_val = example1(0.05, ctx.refs.min_dmg:get(), easing_fn)

    if entity.get_local_player():get_player_weapon() == nil then return end
    local weapon_index = entity.get_local_player():get_player_weapon():get_weapon_index()
    local is_grenade = weapon_index == 43 or weapon_index == 44 or weapon_index == 45 or weapon_index == 46 or weapon_index == 47 or weapon_index == 48

    gr_alpha = lerp(globals.frametime * 8, gr_alpha, is_grenade and 100 or 255)

    if ctx.menu.elements.visuals.damage_indicator:get() and {ui_get_alpha() > 0.3 or entity_get_local_player():is_alive()} then
        render_text(ctx.menu.elements.visuals.damage_font:get() == 'Small' and 2 or 1, vector(self.position.x + 11, self.position.y + 7), color(255, gr_alpha), "c", not ctx.menu.elements.visuals.dis_animation:get() and ((example1.value / ctx.refs.min_dmg:get()) < 1 and math.ceil(example1.value) or math.floor(example1.value)) or ctx.refs.min_dmg:get())
    end
end)

events.mouse_input:set(function()
    if ui_get_alpha() > 0.3 then return false end
end)

events.render:set(function()
    new_drag_object:update()
end)

onetap_data = {}

local hitlog = new_class()
:struct 'hit_mark' {
    hitlogger =
    (function()
        local b = {callback_registered = false, maximum_count, 8, data = {}}
        function b:register_callback()
        if self.callback_registered then
            return
        end
        events.render:set(function()
                
                local c = {56, 56, 57}
                local d = 10
                local e = self.data
                for f = #e, 1, -1 do
                    self.data[f].time = self.data[f].time - globals.frametime
                    local g, h = 255, 0
                    local i = e[f]
                    if i.time < 0 then
                        table.remove(self.data, f)
                    else
                        local j = i.def_time - i.time
                        local j = j > 1 and 1 or j
                        local k = 0.20
                        local l = 0
                        if i.time < 0.20 then
                            l = (j < 1 and j or i.time) / 0.20
                        end
                        if j < k then
                            l = (j < 1 and j or i.time) / 0.20
                        end
                        if i.time < 0.20 then
                            h = (j < 1 and j or i.time) / 0.20
                            g = h * 255
                            if h < 0.2 then
                                d = d - 15 * (1.0 - h / 0.2)
                            end
                        end
                        local xui = i.time < 0.20 and -1 or 1
                        i.draw = tostring(i.draw):upper()
                        if i.draw == "" then
                            goto m
                        end

                        if i.shot_pos == nil or render_world_to_screen(i.shot_pos) == nil then
                            return
                        end
                        
                        local sx, sy = render_world_to_screen(i.shot_pos).x, render_world_to_screen(i.shot_pos).y
                        local xyeta = 55 * (g*xui) / 255*xui

                        render_text(verdana, vector(sx, sy - 20), color(255, 255, 255, g/4), "c", i.draw)
                        render_text(verdana, vector(sx, sy - 20), color(255, 0, 0, g/1.2), "c", i.draw)
                        
                       
                        d = d + 25
                        ::m::
                    end
                end
                self.callback_registered = true
            end
        )
    end
    function b:paint(p, q, userdata)
        local r = tonumber(p) + 1
        for f = 2, 2, -1 do
            self.data[f] = self.data[f - 1]
        end
            self.data[1] = {time = r, def_time = r, draw = q, shot_pos = userdata}
            self:register_callback()
        end
        return b
    end)()
    }

    :struct 'aim_hit' {
    init = function(self)
        events.aim_ack:set(function(e)
            if ctx.menu.elements.misc.markers:get('OT Damage Marker') then
                if e.hitgroup == 1 then clr = color(255, 0, 0):to_hex() else clr = color(255, 255, 255):to_hex() end

                if e.state == nil then
                    self.hit_mark.hitlogger:paint(2, "\a"..clr.."" .. e.damage, e.aim)
                end
            end
        
    end)
end
}
hitlog.aim_hit:init()

local function register_marker(z)
    if ctx.menu.elements.misc.markers:get('OT Damage Marker') then
        if entity_get_local_player() ~= nil and entity_get_local_player():is_alive() then
            if z.state == nil then
                table.insert(onetap_data,  {z.aim, globals.realtime + 3})
            end 
        end
    end
end

local function onetap_marker()
    if ctx.menu.elements.misc.markers:get('OT Damage Marker') then
        if entity_get_local_player() ~= nil and entity_get_local_player():is_alive() then
            for k, v in pairs(onetap_data) do
                    
                if globals.realtime > v[2] then
                    table.remove(onetap_data, 1)
                end

                if v[1]:to_screen() ~= nil then
                    render.line(vector(v[1]:to_screen().x + 4, v[1]:to_screen().y + 4), vector(v[1]:to_screen().x + (4 * 2), v[1]:to_screen().y + (4 * 2)), color(255, 255, 255, 255))
                    render.line(vector(v[1]:to_screen().x - 4, v[1]:to_screen().y + 4), vector(v[1]:to_screen().x - (4 * 2), v[1]:to_screen().y + (4 * 2)), color(255, 255, 255, 255))
                    render.line(vector(v[1]:to_screen().x + 4, v[1]:to_screen().y - 4), vector(v[1]:to_screen().x + (4 * 2), v[1]:to_screen().y - (4 * 2)), color(255, 255, 255, 255))
                    render.line(vector(v[1]:to_screen().x - 4, v[1]:to_screen().y - 4), vector(v[1]:to_screen().x - (4 * 2), v[1]:to_screen().y - (4 * 2)), color(255, 255, 255, 255))
                end
            end
        end
    end
end
events.aim_ack:set(register_marker)
events.render:set(onetap_marker)
events.round_prestart:set(function() onetap_data = {} end)

--kibit
kibit_data = {}

local function register_marker(z)
    if ctx.menu.elements.misc.markers:get('Kibit Hitmarker') then
        if entity_get_local_player() ~= nil and entity_get_local_player():is_alive() then
            if z.state == nil then
                table.insert(kibit_data,  {z.aim, globals.realtime + 3})
            end 
        end
    end
end

local function kibit_marker()
    if ctx.menu.elements.misc.markers:get('Kibit Hitmarker') then
        if entity_get_local_player() ~= nil and entity_get_local_player():is_alive() then
            for k, v in pairs(kibit_data) do
                
                if globals.realtime > v[2] then
                    table.remove(kibit_data, 1)
                end

                if v[1]:to_screen() ~= nil then
                    render.rect(vector(v[1]:to_screen().x - 1, v[1]:to_screen().y - 6), vector(v[1]:to_screen().x + 1, v[1]:to_screen().y + 6), color(34, 214, 132, 255))
                    render.rect(vector(v[1]:to_screen().x - 6, v[1]:to_screen().y - 1), vector(v[1]:to_screen().x + 6, v[1]:to_screen().y + 1) , color(108, 182, 203, 255))
                end
            end
        end
    end
end

events.aim_ack:set(register_marker)
events.render:set(kibit_marker)
events.round_prestart:set(function() kibit_data = {} end)

--logs
local hitgroup_str = {
    [0] = 'generic',
    'head', 'chest', 'stomach',
    'left arm', 'right arm',
    'left leg', 'right leg',
    'neck', 'generic', 'gear'
}

events.item_purchase:set(function(e)
    if ctx.menu.elements.visuals.aimbot_logging:get() and ctx.menu.elements.visuals.purchases:get() then

        local playerz = entity.get(e.userid, true)
        local weaponz = e.weapon
        
        if playerz == nil then return end
        if weaponz == 'weapon_unknown' then return end
        if not playerz:is_enemy() then return end

        print_raw(('\a'..active_color..'mytools »\aD5D5D5FF %s bought \aACFF86FF%s'):format(string.lower(playerz:get_name()), weaponz))
        print_dev(('%s bought \aACFF86FF%s\aDEFAULT'):format(playerz:get_name(), weaponz))

    end
end)

events.aim_ack:set(function(e)
    if ctx.menu.elements.visuals.aimbot_logging:get() and ctx.menu.elements.visuals.select_log:get("Upper-left") then
        local me = entity_get_local_player()
        local target = entity.get(e.target)
        local state, state1 = e.state, e.state
        if not target then return end
        if target == nil then return end
        local health = target["m_iHealth"]
        if entity_get_local_player() == nil then return end

        --paste
        if state1 == "spread" then
            state1 = "\aFEEA7DFFspread"
        end
        if state1 == "prediction error" then
            state1 = "\aFEEA7DFFpred. error"
        end
        if state1 == "correction" then
            state1 = "\aFF5959FFresolver"
        end
        if state1 == "damage rejection" then
            state1 = "\aFF5959FFdamage rejection"
        end
        if state1 == "misprediction" then
            state1 = "\aFEEA7DFFmisprediction"
        end
        if state1 == "lagcomp failure" then
            state1 = "\aFF5959FFlagcomp failure"
        end
        if state1 == "backtrack failure" then
            state1 = "\aFF5959FFbacktrack failure"
        end
        if state == "correction" then
            state = "resolver"
        end
        --

        if state == nil then
            print_dev(("Hit \a"..active_color..""..target:get_name().." \aDEFAULTin the \a"..active_color.."%s \aDEFAULTfor \a"..active_color.."%d \aDEFAULTdamage (\a"..active_color..""..health.." \aDEFAULThealth remaining) Δ: \a"..active_color.."%s\aDEFAULT"):format(hitgroup_str[e.hitgroup], e.damage, e.backtrack))
            print_raw(("\a"..active_color.."mytools » \aD5D5D5FFhit \a"..active_color..""..string.lower(target:get_name()).." \aDEFAULTin the \a"..active_color.."%s \aDEFAULTfor \a"..active_color.."%d\aDEFAULT(\a"..active_color..""..string_format("%.f", e.wanted_damage).."\aDEFAULT) damage (\a"..active_color..""..health.." \aDEFAULThealth remaining) [aimed: "..hitgroup_str[e.wanted_hitgroup].." | history(Δ): %s]"):format(hitgroup_str[e.hitgroup], e.damage, e.backtrack))
        else
            print_dev(('Missed shot in \a'..active_color..''..target:get_name()..'\aDEFAULT\'s \aDEFAULT%s \aDEFAULTdue to \a'..active_color..''..state..' \aDEFAULTΔ: \a'..active_color..'%s\aDEFAULT'):format(hitgroup_str[e.wanted_hitgroup], e.backtrack))
            print_raw(('\a'..active_color..'mytools » \aD5D5D5FFmissed shot in \a'..active_color..'%s\aDEFAULT\'s \a'..active_color..'%s \aDEFAULTdue to '..state1..'\aD5D5D5FF [hc: '..string_format("%.f", e.hitchance)..' | damage: '..string_format("%.f", e.wanted_damage)..' | history(Δ): %s]'):format(string.lower(target:get_name()), hitgroup_str[e.wanted_hitgroup], e.backtrack))
        end

        
    end
end)

events.player_hurt:set(function(e)
    if ctx.menu.elements.visuals.aimbot_logging:get() and ctx.menu.elements.visuals.select_log:get("Upper-left") then
            local me = entity_get_local_player()
            local attacker = entity.get(e.attacker, true)
            local weapon = e.weapon
            local type_hit = 'hit'
        
            if weapon == 'hegrenade' then 
                type_hit = 'Naded'
            end
        
            if weapon == 'inferno' then
                type_hit = 'Burned'
            end
        
            if weapon == 'knife' then 
                type_hit = 'Knifed'
            end

            if weapon == 'hegrenade' or weapon == 'inferno' or weapon == 'knife' then
    
            if me == attacker then
                local user = entity.get(e.userid, true)
                print_raw(('\a'..active_color..'mytools » \aD5D5D5FF'..string.lower(type_hit)..' \a'..active_color..'%s \aDEFAULTfor \a'..active_color..'%d\aDEFAULT damage (\a'..active_color..'%d \aDEFAULThealth remaining)'):format(string.lower(user:get_name()), e.dmg_health, e.health))
                print_dev((''..type_hit..' \a'..active_color..''..user:get_name()..' \aDEFAULTfor \a'..active_color..'%d \aDEFAULTdamage (\a'..active_color..'%d \aDEFAULThealth remaining)'):format(e.dmg_health, e.health))
            end
        end
    end
end)

local smoothy_warning = smoothy.new({
    alpha = 0,
    vel_mod = 0
})

local new_drag_object_5 = drag_system.register({ctx.menu.elements.visuals.velocity_x, ctx.menu.elements.visuals.velocity_y}, vector(185, 50), "Test1", function(self)
    local me = entity.get_local_player()

    local vel_mod = smoothy_warning.value.vel_mod
    local percentage = math.floor((1-vel_mod)*100)
    local alpha = smoothy_warning.value.alpha

    smoothy_warning(.05, {
        vel_mod = not me and .34 or me.m_flVelocityModifier,
        alpha = (ctx.menu.elements.visuals.velocity_warning:get() and ((percentage ~= 0 and  me) or ui_get_alpha() > 0.3)) and 255 or 0
    })

    local success, should_render = pcall(function()
        return (not me:is_alive() and ui_get_alpha() ~= 1)
    end)

    if success and should_render then
        return
    end

    local target_color = color('EA6868FF'):lerp(color(ctx.menu.elements.visuals.velocity_color:get():to_hex()), vel_mod)
    local text = string.format('⛔ Max velocity reduced by %i%%', percentage)

    render.text(1, vector(self.position.x + 94, self.position.y + self.size.y - 21), color(255, alpha), 'c', text)
    render.shadow(vector(self.position.x + 7, self.position.y + self.size.y - 10), vector(self.position.x + self.size.x - 7, self.position.y + self.size.y - 7), target_color:alpha_modulate(alpha), 14, 0, 3)
    render.rect(vector(self.position.x + 7, self.position.y + self.size.y - 10), vector(self.position.x + self.size.x - 7, self.position.y + self.size.y - 7), color(0, alpha), 3)
    render.rect(vector(self.position.x + 7, self.position.y + self.size.y - 10), vector(self.position.x + self.size.x*vel_mod - 7, self.position.y - 7 + self.size.y), target_color:alpha_modulate(alpha), 3)
end)

events.render:set(function()
    if ctx.menu.elements.visuals.velocity_warning:get() then
        new_drag_object_5:update()
    end
end)

events.createmove:set(function()
    if ctx.menu.elements.misc.grenade_fix:get() then
        if entity.get_local_player() == nil then return end
        if entity.get_local_player():get_player_weapon() == nil then return end

        local weapon_index = entity.get_local_player():get_player_weapon():get_weapon_index()
        local is_grenade = weapon_index == 43 or weapon_index == 44 or weapon_index == 45 or weapon_index == 46 or weapon_index == 47 or weapon_index == 48

        if is_grenade then
            ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set({''})
        else
            ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set(current)
        end
    end
end)
--

--logs under
local id = 1
events.player_hurt:set(function(e)
    if ctx.menu.elements.visuals.aimbot_logging:get() and ctx.menu.elements.visuals.select_log:get("Under crosshair") then
		local me = entity_get_local_player()
		local attacker = entity.get(e.attacker, true)
        if me == attacker then
        local user = entity.get(e.userid, true)
        local hitgroup = hitgroup_str[e.hitgroup]
		local weapon_name = e.weapon
        if weapon_name == 'hegrenade' or weapon_name == 'inferno' or weapon_name == 'knife' then return end

        if ctx.menu.elements.visuals.aimbot_logging:get() and ctx.menu.elements.visuals.select_log:get("Under crosshair") and not ctx.menu.elements.visuals.select_log:get("Upper-left") then
        print_raw(('\a'..active_color..'mytools » \aD5D5D5FFhit %s in the '..hitgroup..' for %d damage (%d hp remaining)'):format(user:get_name(), e.dmg_health, e.health))
        end

        if e.health < 1 then
            hitlog[#hitlog+1] = {("\aFFFFFFC8Hit \a"..ctx.menu.elements.visuals.accent_color:get():to_hex()..""..user:get_name().." \aFFFFFFC8in the \a"..ctx.menu.elements.visuals.accent_color:get():to_hex()..""..hitgroup.." \aFFFFFFC8for \a"..ctx.menu.elements.visuals.accent_color:get():to_hex()..""..e.dmg_health.." \aFFFFFFC8damage (\a"..ctx.menu.elements.visuals.accent_color:get():to_hex().."dead\aFFFFFFC8)"), globals.tickcount + 300, 0}
        else
            hitlog[#hitlog+1] = {("\aFFFFFFC8Hit \a"..ctx.menu.elements.visuals.accent_color:get():to_hex()..""..user:get_name().." \aFFFFFFC8in the \a"..ctx.menu.elements.visuals.accent_color:get():to_hex()..""..hitgroup.." \aFFFFFFC8for \a"..ctx.menu.elements.visuals.accent_color:get():to_hex()..""..e.dmg_health.." \aFFFFFFC8damage (\a"..ctx.menu.elements.visuals.accent_color:get():to_hex()..""..e.health.." \aFFFFFFC8hp remaining)"), globals.tickcount + 300, 0}
		end

        id = id == 999 and 1 or id + 1 
	    end
    end
end)

events.aim_ack:set(function(shot)
	if ctx.menu.elements.visuals.aimbot_logging:get() and ctx.menu.elements.visuals.select_log:get("Under crosshair") then
	player_name = shot.target:get_name()
    hitgroup = hitgroup_str[shot.hitgroup]
    wanted_hitgroup = hitgroup_str[shot.wanted_hitgroup]

    local state = shot.state
    
    if state == 'correction' then
        state = 'resolver'
    end

    if state == 'prediction error' then
        state = 'pred. error'
    end

    if not (state == nil) and ctx.menu.elements.visuals.aimbot_logging:get() and ctx.menu.elements.visuals.select_log:get("Under crosshair") and not ctx.menu.elements.visuals.select_log:get("Upper-left") then
        print_raw(("\a"..active_color.."mytools » \aD5D5D5FFmissed shot in %s in the %s due to %s"):format(string.lower(player_name), wanted_hitgroup, state))
    end

	if not (state == nil) then
        hitlog[#hitlog+1] = {("\aFFFFFFC8Missed shot in \a"..ctx.menu.elements.visuals.accent_color:get():to_hex()..""..player_name.."'s \aFFFFFFC8"..wanted_hitgroup.." \aFFFFFFC8due to \a"..ctx.menu.elements.visuals.accent_color:get():to_hex()..""..state.." "), globals.tickcount + 300, 0}
    end

	id = id == 999 and 1 or id + 1 

    end
end)

events.render:set(function()
    if #hitlog > 0 then
        if globals.tickcount >= hitlog[1][2] then
            if hitlog[1][3] > 0 then
                hitlog[1][3] = hitlog[1][3] - 20
            elseif hitlog[1][3] <= 0 then
                table.remove(hitlog, 1)
            end
        end
        if #hitlog > 6 then
            table.remove(hitlog, 1)
        end
        if globals.is_connected == false then
            table.remove(hitlog, #hitlog)
        end
        for i = 1, #hitlog do
            text_size = render.measure_text(1, nil, hitlog[i][1]).x
           if hitlog[i][3] < 255 then 
                hitlog[i][3] = hitlog[i][3] + 10 
            end
            if ctx.menu.elements.visuals.aimbot_logging:get() and ctx.menu.elements.visuals.select_log:get("Under crosshair") then
                if not ctx.menu.elements.visuals.dis_glow:get() then
                    render.shadow(vector(render_screen_size().x/2 - text_size/2 + 40, render_screen_size().y/1.29 - (hitlog[i][3]/45) + 15 * i + 10), vector(render_screen_size().x/2 - text_size/2 + text_size + 25, render_screen_size().y/1.29 - (hitlog[i][3]/45) + 15 * i + 10), color(ctx.menu.elements.visuals.accent_color:get().r, ctx.menu.elements.visuals.accent_color:get().g, ctx.menu.elements.visuals.accent_color:get().b, 255), 30, 0, 0)
                end
                render_text(1, vector(render_screen_size().x/2 - text_size/2 + 35, render_screen_size().y/1.3 - (hitlog[i][3]/45) + 15 * i + 10), color(255, 255, 255, hitlog[i][3]), nil, hitlog[i][1])
            end
		end
    end
end)


--viewmodel
events.render:set(function()
    if ctx.menu.elements.visuals.viewmodel_changer:get() then
        cvar.viewmodel_fov:int(ctx.menu.elements.visuals.viewmodel_fov:get(), true)
		cvar.viewmodel_offset_x:float(ctx.menu.elements.visuals.viewmodel_x:get()/10, true)
		cvar.viewmodel_offset_y:float(ctx.menu.elements.visuals.viewmodel_y:get()/10, true)
		cvar.viewmodel_offset_z:float(ctx.menu.elements.visuals.viewmodel_z:get()/10, true)
    end

    cvar.r_aspectratio:float(ctx.menu.elements.visuals.viewmodel_aspectratio:get()/100)
    
end)

ctx.menu.elements.visuals.viewmodel_changer:set_callback(function()
    if not ctx.menu.elements.visuals.viewmodel_changer:get() then
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
        end
end)

ctx.menu.elements.misc.fakelatency:set_callback(function()
    if ctx.menu.elements.misc.fakelatency:get() then
        cvar.sv_maxunlag:float(0.4)
    else
        cvar.sv_maxunlag:float(0.2)
    end
end, true)

--scope
local scope_line = {}
scope_line.screen = render_screen_size()
scope_line.var = ui_find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
scope_line.anim_num = 0
scope_line.lerp = function(a, b, t)
    return a + (b - a) * t
end

scope_line.on_draw = function()
    if ctx.menu.elements.visuals.custom_scope:get() then
        local_player = entity_get_local_player()

        if not local_player or not local_player:is_alive() or not local_player["m_bIsScoped"] then 
            scope_line.anim_num = scope_line.lerp(scope_line.anim_num, 0, 15 * globals.frametime)
        else
            scope_line.anim_num = scope_line.lerp(scope_line.anim_num, 1, 15 * globals.frametime)
        end

        scope_line.var:override("Remove All")
        scope_line.offset = ctx.menu.elements.visuals.scope_gap:get() * scope_line.anim_num
        scope_line.length = ctx.menu.elements.visuals.scope_size:get() * scope_line.anim_num
        scope_line.col_1 = ctx.menu.elements.visuals.scope_color:get()
        scope_line.width = 1

        scope_line.col_1.a = scope_line.col_1.a * scope_line.anim_num

        scope_line.start_x = scope_line.screen.x / 2
        scope_line.start_y = scope_line.screen.y / 2

        if ctx.menu.elements.visuals.scope_style:get() == 'Default' then
            render.gradient(vector(scope_line.start_x - scope_line.offset, scope_line.start_y), vector(scope_line.start_x - scope_line.offset - scope_line.length, scope_line.start_y + scope_line.width), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Left') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Left') and 0 or scope_line.col_1.a), color(255, 255, 255, 0))
            render.gradient(vector(scope_line.start_x + scope_line.offset, scope_line.start_y), vector(scope_line.start_x + scope_line.offset + scope_line.length, scope_line.start_y + scope_line.width), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Right') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Right') and 0 or scope_line.col_1.a), color(255, 255, 255, 0))
            render.gradient(vector(scope_line.start_x, scope_line.start_y + scope_line.offset), vector(scope_line.start_x + scope_line.width, scope_line.start_y + scope_line.offset + scope_line.length), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Down') and 0 or scope_line.col_1.a), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Down') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(255, 255, 255, 0))
            render.gradient(vector(scope_line.start_x, scope_line.start_y - scope_line.offset), vector(scope_line.start_x + scope_line.width, scope_line.start_y - scope_line.offset - scope_line.length), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Up') and 0 or scope_line.col_1.a), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Up') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(255, 255, 255, 0))
        else
            render.gradient(vector(scope_line.start_x - scope_line.offset, scope_line.start_y), vector(scope_line.start_x - scope_line.offset - scope_line.length, scope_line.start_y + scope_line.width), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Left') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Left') and 0 or scope_line.col_1.a))
            render.gradient(vector(scope_line.start_x + scope_line.offset, scope_line.start_y), vector(scope_line.start_x + scope_line.offset + scope_line.length, scope_line.start_y + scope_line.width), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Right') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Right') and 0 or scope_line.col_1.a))
            render.gradient(vector(scope_line.start_x, scope_line.start_y + scope_line.offset), vector(scope_line.start_x + scope_line.width, scope_line.start_y + scope_line.offset + scope_line.length), color(255, 255, 255, 0), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Down') and 0 or scope_line.col_1.a), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Down') and 0 or scope_line.col_1.a))
            render.gradient(vector(scope_line.start_x, scope_line.start_y - scope_line.offset), vector(scope_line.start_x + scope_line.width, scope_line.start_y - scope_line.offset - scope_line.length), color(255, 255, 255, 0), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Up') and 0 or scope_line.col_1.a), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Up') and 0 or scope_line.col_1.a))
        end
    end
end
events.render:set(scope_line.on_draw)

ctx.menu.elements.visuals.custom_scope:set_callback(function()
    if not ctx.menu.elements.visuals.custom_scope:get() then
        scope_line.var:override()
    end
end)


events.createmove:set(function()
    local self = entity_get_local_player()
    if self == nil then return end
    if self:get_player_weapon() == nil then return end
    if ctx.refs.hs:get() then return end

    local weapon_index = self:get_player_weapon():get_weapon_index()
    
    local is_pistol = weapon_index == 2 or weapon_index == 3 or weapon_index == 4 or weapon_index == 30 or weapon_index == 32 or weapon_index == 36 or weapon_index == 61 or weapon_index == 63
    local is_auto = weapon_index == 11 or weapon_index == 38
    local is_awp = weapon_index == 9
    local is_ssg = weapon_index == 40
    local is_heavy = weapon_index == 1 or weapon_index == 64
    local is_knifetaser = self:get_player_weapon():get_classname() == "CKnife" or weapon_index == 31
    local players = entity.get_players(true, false)

    for i, weapons in pairs({is_pistol, is_auto, is_awp, is_ssg, is_heavy, is_knifetaser, 
    not (is_pistol or is_auto or is_awp or is_ssg or is_heavy or is_knifetaser)
    }) do
        if ctx.menu.elements.misc.auto_tp:get() and ctx.menu.elements.misc.weapons:get(i) and weapons and bit.band(self.m_fFlags, bit.lshift(1, 0)) == 0 then
            for i = 1, #players do
                if players[i]:is_alive() and players[i]:is_visible(players[i]:get_origin()) then
                    rage.exploit:force_teleport()
                end
            end
        end
    end
end)

--killsay
local misc = new_class()
:struct 'killsay' {

    killsay_pharases = {
        {'⠀1', 'nice iq'},
        {'cgb gblfhfc', 'спи пидорас'},
        {'пздц', 'игрок'},
        {'1 моча', 'изи'},
        {'куда ты', 'сынок ебаный'},
        {'найс аа хуесос', 'долго делал?'},
        {'ебать что', 'как я убил ахуеть'},
        {'mytools over all pidoras'},
        {'nice iq', 'churka)'},
        {'1 чмо', 'нищий без майтулса'},
        {'лол', 'как же я тебя выебал'},
        {'че за луашку юзаешь'},
        {'чей кфг юзаешь'},
        {'найс айкью', 'хуесос'},
        {']f]f]f]f]f]f]', 'хахахаха'},
        {'jq ,kz', 'ой бля', 'найс кфг уебище'},
        {'jq', 'я в афк чит настраивал хаха'},
        {'какой же у тебя сочный ник'},
        {'хуйсос анимешный', 'думал не убью тебя?)'},
        {'моча ебаная', 'кого ты пытаешься убить'},
        {'mad cuz bad?', 'hhhhhh retardw'},
        {'учись пока я жив долбаеб'},
        {'еблан', 'включи монитор'},
        {'1', 'опять умер моча'},
        {'egc', 'упссс', 'сорри'},
        {'хахаха ебать я тебя трахнул'},
        {'nice iq', 'u sell'},
        {'изи шлюха', 'че в хуй?'},
        {'получай тварь ебаная', 'фу нахуй'},
        {']f]f]f]f]f]]f]f', 'как же мне похуй долбаеб'},
        {'изи моча', 'я ору с тебя какой же ты сочный'},
        {'ez owned', 'weak dog + rat'},
        {'пиздец ты легкий ботик'},
        {'1', 'не отвечаю?', 'мне похуй'},
        {'как же мне похуй', 'ботик'},
        {'what a terrible game you are', 'fucking bot'},
        {'♕ M Y T O O L S > A L L ♕'},
        {'market.neverlose.cc/mytools закупись чмо ебаное'}
    },
    
    death_say = {
        {'пиздец че я за хуйню купил', 'лучше бы майтулс купил бля'},
        {'ну фу', 'хуесос'},
        {'что ты делаешь', 'моча умалишенная'},
        {'бля', 'я стрелял вообще чи шо?'},
        {'чит подвел'},
        {'БЛЯЯЯЯЯЯЯЯЯЯЯЯТЬ', 'как же ты меня заебал'},
        {'ну и зачем', 'дал бы клип', 'пиздец клоун'},
        {'ахахахах', 'ну да', 'опять сын шлюхи убил бестолковый'},
        {'м', 'пон)', 'найс чит'},
        {'да блять', 'какой джиттер поставить сука'},
        {'ну фу', 'ублюдок', 'ебаный'},
        {'да сука', 'где тимейты блять', 'как же сука они меня бесят'},
        {'lf ,kznm', 'да блять', 'опять я мисснул'},
        {'да блять', 'ало', 'я вообще стрелять буду нет'},
        {'хех', 'ты сам то хоть понял', 'как меня убил'},
        {'сука', 'опять по дезу ебаному'},
        {'бля', 'клиентнуло', 'лаки'},
        {'понятно', 'ик ак ты так играешь', 'еблан бестолковый'},
        {'ну блять', 'он просто пошел', 'пиздец'},
        {'&', 'и че это', 'откуда ты меня убил?'},
        {'тварь', 'ебаная', 'ЧТО ТЫ ДЕЛАЕШЬ'},
        {'YE LF', 'ну да', 'хуесос', 'норм играешь'},
        {'сочник ебаный', 'как же ты меня заебал уже', 'что ты делаешь'},
        {'хуевый без скита', 'как ты меня убиваешь с пастой своей'},
        {'подпивас ебаный', 'как же ты меня переиграл'},
        {'бля', 'признаю, переиграл'},
        {'как ты меня убиваешь', 'ебаный owosh'},
        {'дефектус че ты делаешь', 'пиздец'},
        {'хуйсосик анимешный', 'как ты убиваешь', 'эт пздц'},
        {'бля ну бро', 'посмотри на мою команду', 'это пзиидец'},
        {'ммм', 'хуесосы бездарные в команде'},
        {'ik.[f', 'шлюха пошла нахуй'},
        {'ndfhm t,fyfz', 'тварь ебаная как же ты меня бесишь'},
        {'фу нахуй', 'опять в бекшут'},
        {'только так и умеешь да?', 'блядь ебаная'},
        {'нахуй ты меня трешкаешь', 'шлюха ебаная'},
        {'ну повезло тебе', 'дальше то что хуесос'},
        {'ебанная ты мразь', 'которая мне все проебала'},
        {'ujcgjlb', 'господи', 'мразь убогая'},
        {'хахахах', 'ну бля заебись фристенд в чите)'},
        {'фу ты заебал конч'},
        {')', 'хорош)'},
        {'норм трекаешь', 'ублюдина'},
        {'а че', 'хайдшоты на фд уже не работают?'}
    },

    init = function(self)
        events.player_death:set(function(e)

            delayed_msg = function(delay, msg)
                return utils.execute_after(delay, function() utils.console_exec('say ' .. msg) end)
            end

            local delay = 2.3
            local me = entity_get_local_player()
            local victim = entity.get(e.userid, true)
            local attacker = entity.get(e.attacker, true)

            local killsay_delay = 0
            local deathsay_delay = 0

            if entity_get_local_player() == nil then return end
            local gamerule = entity.get_game_rules()
            local warmup = gamerule["m_bWarmupPeriod"]

            if ctx.menu.elements.misc.killsay_disablers:get() and warmup == true then return end
            if not ctx.menu.elements.misc.killsay:get() then return end

            if (victim ~= attacker and attacker == me) then
                local phase_block = self.killsay.killsay_pharases[math_random(1, #self.killsay.killsay_pharases)]

                for i=1, #phase_block do
                    local phase = phase_block[i]
                    local interphrase_delay = #phase_block[i]/24*delay
                    killsay_delay = killsay_delay + interphrase_delay

                    delayed_msg(killsay_delay, phase)
                end
            end
            
            if (victim == me and attacker ~= me) then
                local phase_block = self.killsay.death_say[math_random(1, #self.killsay.death_say)]

                for i=1, #phase_block do
                    local phase = phase_block[i]
                    local interphrase_delay = #phase_block[i]/20*delay
                    deathsay_delay = deathsay_delay + interphrase_delay

                    delayed_msg(deathsay_delay, phase)
                end
            end
        end)
    end
}
misc.killsay:init()

--r8
local revolverhelper = esp.enemy:new_text("R8 Helper", "\a2FD500FFDMG+", function(player)
	local localplayer = entity_get_local_player()

    local dist_local = localplayer:get_origin()
    local dist_enemy = player:get_origin()
    local un = dist_local:dist(dist_enemy)

	if not localplayer then return end
	if localplayer:is_alive() then
		if (localplayer:get_player_weapon():get_weapon_index() == 64) then
			if (player['m_ArmorValue']) == 0 then
                if un < 585 then
					return "\a2FD500FFDMG+"
				end
			end
		end
    end
end)

ctx.menu.elements.misc.rev_help:set_callback(function()
    if ctx.menu.elements.misc.rev_help:get() then revolverhelper:set(true) end
    if not ctx.menu.elements.misc.rev_help:get() then revolverhelper:set(false) end
end)
--end r8

events.createmove:set(function(cmd)
    if ctx.menu.elements.antiaims.antiaim_mode:get() == 2 then return end
    local is_crouching = function()
    local localplayer = entity_get_local_player()
    local flags = localplayer['m_fFlags']
              
    if bit.band(flags, 4) == 4 then
        return true
    end
              
    return false
    end
  
    local cond_active = false

    local lp = entity_get_local_player()
    local lp_vel = antiaim_builder:get_velocity(lp)
    local state = antiaim_builder:state(lp_vel, nil, cmd)
    local b  = state

    local localplayer = entity_get_local_player()
    if ctx.menu.elements.antiaims.force_lag:get() then

        if (b == 2 and ctx.menu.elements.antiaims.lag_conditions:get("Standing")) or (b == 3 and ctx.menu.elements.antiaims.lag_conditions:get("Moving")) or
        (b == 4 and ctx.menu.elements.antiaims.lag_conditions:get("Slow Walking")) or
        (b == 7 and ctx.menu.elements.antiaims.lag_conditions:get("Crouching")) or
        (b == 8 and ctx.menu.elements.antiaims.lag_conditions:get("Crouch Move")) or
        ((b == 5 or b == 6) and ctx.menu.elements.antiaims.lag_conditions:get("In Air"))
        then
            cond_active = true
        else
            cond_active = false
        end

        if cond_active == true then
            ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On")
            ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC")
        else
            ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override()
            ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override()
        end
    end
end)

ctx.menu.elements.antiaims.force_lag:set_callback(function(self)
    if not self:get() then ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override() ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override() end 
end)

function hitchanceoverride(cmd)
    local hc = ui_find("Aimbot", "Ragebot", "Selection", "Hit Chance")

    if not ctx.menu.elements.misc.hc_enable:get() then return end

    local me = entity_get_local_player()
    if not me then
        return
    end

    local weap = me:get_player_weapon()
    if weap == nil then return end
    local sniper = weap:get_weapon_index() == 38 or weap:get_weapon_index() == 11 or weap:get_weapon_index() == 9 or weap:get_weapon_index() == 40

    if ctx.menu.elements.misc.hc_cond:get("No scope") and not me.m_bIsScoped and sniper then
        hc:override(ctx.menu.elements.misc.hc_ns:get())
    end

    if ctx.menu.elements.misc.hc_cond:get("Air") and cmd.in_jump and sniper then
        hc:override(ctx.menu.elements.misc.hc_air:get())
    end

    if not (ctx.menu.elements.misc.hc_cond:get("No scope") and not cmd.in_jump and not me.m_bIsScoped and sniper) and not (ctx.menu.elements.misc.hc_cond:get("Air") and cmd.in_jump and sniper) then
    hc:override()
    end
end
events.createmove:set(hitchanceoverride)

local hitlog = new_class()
:struct 'custom_miss_logger' {
    hitlogger =
    (function()
        local b = {callback_registered = false, maximum_count, 8, data = {}}
        function b:register_callback()
        if self.callback_registered then
            return
        end
        events.render:set(function()
                local c = {56, 56, 57}
                local d = 10
                local e = self.data
                for f = #e, 1, -1 do
                    self.data[f].time = self.data[f].time - globals.frametime
                    local g, h = 255, 0
                    local i = e[f]
                    if i.time < 0 then
                        table.remove(self.data, f)
                    else
                        local j = i.def_time - i.time
                        local j = j > 1 and 1 or j
                        local k = 0.48
                        local l = 0
                        if i.time < 0.48 then
                            l = (j < 1 and j or i.time) / 0.48
                        end
                        if j < k then
                            l = (j < 1 and j or i.time) / 0.48
                        end
                        if i.time < 0.48 then
                            h = (j < 1 and j or i.time) / 0.48
                            g = h * 255
                            if h < 0.2 then
                                d = d - 15 * (1.0 - h / 0.2)
                            end
                        end
                        local xui = i.time < 0.48 and -1 or 1
                        i.draw = tostring(i.draw):upper()
                        if i.draw == "" then
                            goto m
                        end

                        if i.shot_pos == nil or render_world_to_screen(i.shot_pos) == nil then
                            return
                        end
                        
                        local sx, sy = render_world_to_screen(i.shot_pos).x, render_world_to_screen(i.shot_pos).y
                        local xyeta = 55 * (g*xui) / 255*xui

                        render_text(2,vector(sx, sy), color(255, 145, 145, g), "", "\aFFFFFFFFx   \aDEFAULT" .. i.draw)
                        d = d + 25
                        ::m::
                    end
                end
                self.callback_registered = true
            end
        )
    end
    function b:paint(p, q, userdata)
        local r = tonumber(p) + 1
        for f = 1, 2, -1 do
            self.data[f] = self.data[f - 1]
        end
            self.data[1] = {time = r, def_time = r, draw = q, shot_pos = userdata}
            self:register_callback()
        end
        return b
    end)()
    }

    :struct 'aim_hit' {
    init = function(self)
        events.aim_ack:set(function(e)
        if e.state == "correction" then
            e.state = "resolver"
        end
        
        if e.state == "lagcomp failure" then
            e.state = "lagcomp"
        end
        
        if ctx.menu.elements.misc.markers:get('3D Miss marker') then
            if e.state ~= nil then
                self.custom_miss_logger.hitlogger:paint(2, e.state, e.aim)
            end
        end
    end)
end
}
hitlog.aim_hit:init()

events.createmove:set(function(cmd)
    if (ctx.menu.elements.antiaims.antiaim_mode:get() == 1 or ctx.menu.elements.antiaims.antiaim_mode:get() == 2) and ui_get_alpha() > 0.3 then 
        ctx.refs.pitch:override()
        ctx.refs.yaw:override()
        ctx.refs.jyaw:override()
        ctx.refs.jyaw_slider:override()
        ctx.refs.base:override()
        ctx.refs.fake_op:override()
        ctx.refs.left_limit:override()
        ctx.refs.right_limit:override()
        ctx.refs.hidden:override()
    end
end)

--@: sowus - helpers
local x, y, alphabinds, alpha_k, width_k, width_ka, data_k, width_spec, alpha_s = render_screen_size().x, render_screen_size().y, 0, 1, 0, 0, { [''] = {alpha_k = 0}}, 1, 0

events.render:set(function()
    if not ctx.menu.elements.visuals.on_screen:get() or ctx.menu.elements.visuals.select:get() == 'Disable' then

        if not globals.is_in_game then 
            return 
        end

        idc = modify.gradient('M Y T O O L S', color(), color(ui_get_style()["Link Active"].r, ui_get_style()["Link Active"].g, ui_get_style()["Link Active"].b, 255))
        render_text(1, vector(25, render_screen_size().y/2), color(), nil, idc .. (ctx.cheat.version == 'Nightly' and ' \aFF7777FF[DEV]' or ' \aFF7777FF[V3]'))
    end
end)

function window(x, y, w, h, name, alpha) 
	local name_size = render.measure_text(1, "", name) 
	local r, g, b = ctx.menu.elements.visuals.accent_col:get().r, ctx.menu.elements.visuals.accent_col:get().g, ctx.menu.elements.visuals.accent_col:get().b

    if ctx.menu.elements.visuals.solus_widgets:get()  then
        render.rect(vector(x-3, y), vector(x+w+6, y+3+h), color(0, 0, 0, alpha/3), 0)
		render.shadow(vector(x-3, y), vector(x+w+6, y+3+h), color(r, g, b, alpha/1.1), 15, nil, 0) 
        render_text(1, vector(x+1 + w / 2 + 1 - name_size.x / 2,	y + 1 + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name) 
    end

end

local suc_wm, data_wm = pcall(function() return render.load_image(network.get("https://cdn.discordapp.com/attachments/766390146479685662/1092052169814986843/star-solid.png")) end)

local x, y, alphabinds, alpha_k, width_k, width_ka, data_k, width_spec, alpha_s = render_screen_size().x, render_screen_size().y, 0, 1, 0, 0, { [''] = {alpha_k = 0}}, 1, 0

local new_drag_object3 = drag_system.register({ctx.menu.elements.visuals.pos_x_s, ctx.menu.elements.visuals.pos_y_s}, vector(120, 60), "Test", function(self)
    if ctx.menu.elements.visuals.solus_widgets:get() and ctx.menu.elements.visuals.solus_widgets_s:get('Hotkeys') then

    if not contains(disabled_windows, "Hotkeys") then
        table.insert(disabled_windows, "Hotkeys")
        check_windows()
    end

    local max_width = 0
    local frametime = globals.frametime * 16
    local add_y = 0
    local total_width = 66
    local active_binds = {}

    local binds = ui_get_binds()
    for i = 1, #binds do
            local bind = binds[i]
            local get_mode = binds[i].mode == 1 and 'holding' or (binds[i].mode == 2 and 'toggled') or '[?]'
            local get_value = binds[i].value

            local c_name = binds[i].name
            if c_name == 'Peek Assist' then c_name = 'Quick peek' end
            if c_name == 'Edge Jump' then c_name = 'Jump at edge' end
            if c_name == 'Hide Shots' then c_name = 'Hide shots' end
            if c_name == 'Min. Damage' then c_name = 'Minimum damage' end
            if c_name == 'Fake Latency' then c_name = 'Ping spike' end
            if c_name == 'Fake Duck' then c_name = 'Fake duck' end
            if c_name == 'Safe Points' then c_name = 'Safe point' end
            if c_name == 'Body Aim' then c_name = 'Body aim' end
            if c_name == 'Double Tap' then c_name = 'Double tap' end
            if c_name == 'Yaw Base' then c_name = 'Manual override' end
            if c_name == 'Slow Walk' then c_name = 'Slow motion' end
            if c_name == 'Dormant Aimbot' then c_name = 'Dormant aimbot' end


            local bind_state_size = render.measure_text(1, "", get_mode)
            local bind_name_size = render.measure_text(1, "", c_name)
            if data_k[bind.name] == nil then data_k[bind.name] = {alpha_k = 0} end
            data_k[bind.name].alpha_k = lerp(frametime, data_k[bind.name].alpha_k, (bind.active and 255 or 0))

            render_text(1, vector(self.position.x+3, self.position.y + 23 + add_y), color(255, data_k[bind.name].alpha_k), '', c_name)

            if c_name == 'Minimum damage' or c_name == 'Ping spike' then
                render_text(1, vector(self.position.x + (width_ka - bind_state_size.x) - render.measure_text(1, nil, get_value).x + 28, self.position.y + 23 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_value..']')
            else
                render_text(1, vector(self.position.x + (width_ka - bind_state_size.x - 8), self.position.y + 23 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_mode..']')
            end
            
            add_y = add_y + 16 * data_k[bind.name].alpha_k/255

            local width_k = bind_state_size.x + bind_name_size.x + 18
            if width_k > 130-11 then
                if width_k > max_width then
                    max_width = width_k
                end
            end

            if binds.active then
                    table.insert(active_binds, binds)
                end
            end

            alpha_k = lerp(frametime, alpha_k, (ui_get_alpha() > 0 or add_y > 0) and 1 or 0)
            
            width_ka = lerp(frametime,width_ka, math.max(max_width, 130-11))
            if ui_get_alpha()>0 or add_y > 6 then alphabinds = lerp(frametime, alphabinds, math.max(ui_get_alpha()*255, (add_y > 1 and 255 or 0))) elseif add_y < 15.99 and ui.get_alpha() == 0 then alphabinds = lerp(frametime, alphabinds, 0) end
            
            if ui_get_alpha() or #active_binds > 0 then
                window(self.position.x, self.position.y, width_ka, 16, 'keybinds', alphabinds)
            end
    end
end)

local suc_fn, data_fn = pcall(function() return render.load_image(network.get("https://avatars.cloudflare.steamstatic.com/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_medium.jpg")) end)

local new_drag_object4 = drag_system.register({ctx.menu.elements.visuals.pos_x1_s, ctx.menu.elements.visuals.pos_y1_s}, vector(120, 60), "Test2", function(self)
    if ctx.menu.elements.visuals.solus_widgets:get() and ctx.menu.elements.visuals.solus_widgets_s:get('Spectators') then

    if not contains(disabled_windows, "Spectators") then
        table.insert(disabled_windows, "Spectators")
        check_windows()
    end

    local frametime = globals.frametime * 16
    if ui_get_alpha() > 0 then alpha_s = lerp(frametime, alpha_s, math.max(ui_get_alpha()*255, (0 > 1 and 255 or 0))) elseif ui_get_alpha() == 0 then alpha_s = lerp(frametime, alpha_s, 0) end
    window(self.position.x, self.position.y, 120, 16, 'spectators', alpha_s)
    
    local me = entity_get_local_player()
    if me == nil then return end

    if me.m_hObserverTarget and (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
        me = me.m_hObserverTarget
    end

    local speclist = me:get_spectators()
    if speclist == nil then return end

    for idx, player_ptr in ipairs(speclist) do
        local name = player_ptr:get_name()
        local tx = render.measure_text(1, '', name).x
        name_sub = string.len(name) > 17 and string.sub(name, 0, 17) .. "..." or name;
        local avatar = player_ptr:get_steam_avatar()
        if (avatar == nil or avatar.width <= 5) then avatar = (suc_fn and data_fn or "") end

        if player_ptr:is_bot() and not player_ptr:is_player() then goto skip end
        render_text(1, vector(self.position.x + 17, self.position.y + 8 + (idx*16)), color(), 'u', name_sub)
        render_texture(avatar, vector(self.position.x + 1, self.position.y + 8 + (idx*16)), vector(12, 12), color(), 'f', 0)
        ::skip::
    end

    if #me:get_spectators() > 0 or (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
        window(self.position.x, self.position.y, 120, 16, 'spectators', 255)
    end
    
    end
end)

events.render:set(function()
    new_drag_object3:update()
    new_drag_object4:update()
end)

--nofall
local function trace(length)
    local x, y, z = entity_get_local_player()["m_vecOrigin"].x, entity_get_local_player()["m_vecOrigin"].y, entity_get_local_player()["m_vecOrigin"].z
    local max_radias = math.pi * 2
    local step = max_radias / 8

    for a = 0, max_radias, step do
        local ptX, ptY = ((10 * math.cos( a ) ) + x), ((10 * math.sin( a ) ) + y)
        local trace = utils_trace_line(vector(ptX, ptY, z), vector(ptX, ptY, z-length), entity_get_local_player())
        local fraction, entity = trace.fraction, trace.entity

        if fraction~=1 then 
            return true
        end
    end
    return false
end

events.createmove:set(function(cmd)
    if not ctx.menu.elements.misc.movement_helpers:get('No fall damage') then return end

    me = entity_get_local_player()

    if me == nil then return end

    if me.m_vecVelocity.z >= -500 then
        no_fall_damage = false
    else
        if trace(15) then
            no_fall_damage = false
        elseif trace(75) then
            no_fall_damage = true
        end
    end

    if me.m_vecVelocity.z < -500 then
        if no_fall_damage then
            cmd.in_duck = 1
        else
            cmd.in_duck = 0
        end
    end
end)
ctx.menu.elements.visuals.aimbot_logging:set_callback(function(self)
    if self:get() then
        ctx.refs.logs:override("")
    else
        ctx.refs.logs:override()
    end
end, true)

ctx.menu.elements.visuals.damage_indicator:set_callback(function(self)
    ctx.menu.elements.visuals.damage_font:visibility(self:get())
    ctx.menu.elements.visuals.dis_animation:visibility(self:get())
end, true)

ctx.menu.elements.visuals.select:set_callback(function(self)
    ctx.menu.elements.visuals.indicator_color:visibility(self:get() == 'Default')
    ctx.menu.elements.visuals.build_color:visibility(self:get() == 'Default')
    ctx.menu.elements.visuals.glow_px:visibility(self:get() == 'Default')
    ctx.menu.elements.visuals.fonts:visibility(self:get() == 'Default')
end, true)

ctx.menu.elements.antiaims.anim_breakers:set_callback(function(self)
    ctx.menu.elements.antiaims.type_legs_ground:visibility(self:get('Legs on ground'))
    ctx.menu.elements.antiaims.type_legs_air:visibility(self:get('Legs in air'))
end, true)

ctx.menu.elements.visuals.arrows_style:set_callback(function(self)
    ctx.menu.elements.visuals.arrows_color:visibility(self:get() == 'Default')
end, true)

ctx.menu.elements.misc.hc_cond:set_callback(function(self)
    ctx.menu.elements.misc.hc_air:visibility(self:get('Air'))
    ctx.menu.elements.misc.hc_ns:visibility(self:get('No scope'))
end, true)

ctx.menu.elements.visuals.select_log:set_callback(function(self)
    ctx.menu.elements.visuals.accent_color:visibility(self:get("Under crosshair"))
    ctx.menu.elements.visuals.dis_glow:visibility(self:get("Under crosshair"))
end, true)

ctx.menu.elements.antiaims.antiaim_mode:set_callback(function(self)
    if self:get() == 1 then
        self:update('👑  Aggressive Jitter \a5FFF58FF· Active', '🤩  Defensive Meta', '⚙️  Builder')
        ctx.menu.elements.antiaims.force_lag:visibility(true)
    elseif self:get() == 2 then
        self:update('👑  Aggressive Jitter',  '🤩  Defensive Meta \a5FFF58FF· Active', '⚙️  Builder')
        ctx.menu.elements.antiaims.force_lag:visibility(false)
    elseif self:get() == 3 then
        self:update('👑  Aggressive Jitter',  '🤩  Defensive Meta', '⚙️  Builder \a5FFF58FF· Active')
        ctx.menu.elements.antiaims.force_lag:visibility(true)
    end

    ctx.menu.elements.antiaims.tp:visibility(self:get() == 1 or self:get() == 2)
    if self:get() ~= 2 then ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override() ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override() end
end, true)

ctx.menu.elements.antiaims.defensive_type:set_callback(function(self)
    ctx.menu.elements.antiaims.defensive_pitch:visibility(self:get() == 'Presets')
    ctx.menu.elements.antiaims.defensive_yaw:visibility(self:get() == 'Presets')
    ctx.menu.elements.antiaims.custom_pitch:visibility(self:get() == 'Custom')
    ctx.menu.elements.antiaims.custom_yaw:visibility(self:get() == 'Custom')
end, true)