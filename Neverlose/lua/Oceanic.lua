-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

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

files.create_folder("nl/scripts/")
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

            local configs = ui_create('Main Page', ' \aFFFFFFFFCloud Configs', 2)
            local info_group = ui_create('Main Page', 'Introduction', 1)
            local local_configs = ui_create('Main Page', 'Config System', 2)
            local antiaim_group = ui_create('Anti-Aim', ' \aFFFFFFFFAnti-aims', 1)
            local antiaims_builder_tab = ui_create('Anti-Aim', ' \aFFFFFFFFAnti-aim builder', 2)
            local misc_group = ui_create('Miscellaneous', 'Other', 2)
            local rage_group = ui_create('Miscellaneous', 'Ragebot', 1)
            local visuals_group = ui_create('Miscellaneous', 'Visuals', 1)
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


                if not success or #config_data == 0 then
                    config_data = {'\aCBC9C9FFNothing there. Create preset.'}
                else
                    local name_list = {}
                    for i=1, #config_data do
                        table.insert(name_list, config_data[i].name)
                    end

                    config_data = name_list
                end


              

             
                
                global.import_preset1 = local_configs:button('  Import', function() self.config_system:import() end, true)
                global.export_preset1 = local_configs:button('  Export', function() common_add_notify('oceanic', '\a89F2CAFFsuccessfully exported your config') self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12) self.config_system:export() end, true)
                
                --global_config
                --global.fnay_label = configs_group:label("")
                global.load_defauls = local_configs:button(" \aFFFFFFFFDefault Config", function() self.config_system:import('[oceanic]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[/oceanic]') end, true)
        
               

                --llinks
                global.discord = info_group:button('Discord', function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/cfgleak") end, true)

             
                
                global.neverlose_config = info_group:button('Neverlose config', function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/cfgleak") end, true)
                global.youtube = info_group:button('Youtube', function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/cfgleak") end, true)
                global.refresh_colors = function()
                    local active_color = ui_get_style('Link Active'):to_hex()
                    local color_link = ui_get_style('Link'):to_hex()


                    global.import_preset1:name(
                        ' \a'..active_color..'\a'..color_link..'  Import'
                    )
                    global.export_preset1:name(
                        ' \a'..active_color..'\a'..color_link..'  Export'
                    )
                    global.load_defauls:name(
                        ' \a'..active_color..'\a'..color_link..'  Default Config'
                    )
                    global.discord:name(
                        ' \a'..active_color..'\a'..color_link..'  Discord '
                    )

                    global.neverlose_config:name(
                        ' \a'..active_color..'\a'..color_link..'  Kamel\'s Config '
                    )
                    global.youtube:name(
                        ' \a'..active_color..'\a'..color_link..'  Youtube '
                    )
                   
                    text:name(string_format('\aDEFAULTWelcome, \a'..active_color..'%s!\n\aDEFAULTCurrent build: %s \n\aDEFAULTSupport in discord channel only!', gradient_textz(ui_get_style()["Link Active"].r, ui_get_style()["Link Active"].g, ui_get_style()["Link Active"].b, 255, ui_get_style()["Link"].r, ui_get_style()["Link"].g, ui_get_style()["Link"].b, 255, self.cheat.username), gradient_textz(ui_get_style()["Link Active"].r, ui_get_style()["Link Active"].g, ui_get_style()["Link Active"].b, 255, ui_get_style()["Link"].r, ui_get_style()["Link"].g, ui_get_style()["Link"].b, 255, "Stable")))
                end

                events.on_style_change:set(function() global:refresh_colors() end)
            end


            events.render:set(function()
                if ui_get_alpha() < 0.3 then return end
                link_color = ui_get_style()["Link Active"]

                ui.sidebar(modify.gradient('oceanic', color(link_color.r, link_color.g, link_color.b), color(link_color.r, link_color.g, link_color.b), 1.5), modify.gradient('', color(255, 255, 255), color(link_color.r, link_color.g, link_color.b), -1.5))
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
               
              
                elements.misc.muteunmute = misc_group:switch 'Unmute Silenced Players'
                elements.misc.muteunmute:tooltip('\a'..active_color..'Unmute Silenced Players.\aDEFAULT\n\nRemoves mute from all players who are muted for abuse, updating on round start.')
                elements.visuals.watermark2 = visuals_group:combo('Watermark', {'Simple', 'Modern'}, 0)
                elements.visuals.watermark21 = visuals_group:color_picker('Watermark color', color(ui_get_style()["Link Active"].r, ui_get_style()["Link Active"].g, ui_get_style()["Link Active"].b))
         
      

             

                elements.visuals.arrows_style = visuals_group:combo('Anti Aim Arrows', 'Disabled', 'Default') do
                    local settings = elements.visuals.arrows_style:create()

                    elements.visuals.arrows_color = settings:color_picker('Arrows color', color(255, 165, 135, 255))
                end

               
                elements.visuals.sindicators = visuals_group:selectable('Game\aBFFF00FFSense', {'Double tap', 'Dormant aimbot', 'Minimum damage', 'Ping spike', 'Fake duck', 'Freestanding', 'Hit Percentage', 'Bomb info', 'Body aim', 'Hide shots'}, 0)
                elements.visuals.aimbot_logging = rage_group:switch 'Custom Logs' do
                    local settings = elements.visuals.aimbot_logging:create()

                    elements.visuals.select_log = settings:selectable('Select log', {'Upper-left', 'Under crosshair'})
                    elements.visuals.purchases = settings:switch("Purchase logs (upper-left)", true)
                    elements.visuals.dis_glow = settings:switch('Disable glow (under-crosshair)')
                    elements.visuals.accent_color = settings:color_picker("Logs color", color(247, 189, 122))
                end

                elements.visuals.custom_scope = visuals_group:switch 'Scope Overlay' do
                    local settings = elements.visuals.custom_scope:create()

                    elements.visuals.scope_style = settings:combo('Select style', {'Default', 'Reversed'})
                    elements.visuals.remove_line = settings:selectable('Exclude line', {'Left', 'Right', 'Up', 'Down'})  
                    elements.visuals.scope_gap = settings:slider("Scope gap", 0, 500, 7)
                    elements.visuals.scope_size = settings:slider("Scope size", 0, 1000, 105)
                    elements.visuals.scope_color = settings:color_picker("Scope color", color(255, 255, 255))
                    
                end

                

                elements.visuals.viewmodel_changer = visuals_group:switch 'Viewmodel Changer' do
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
       

            
               
                
               
               --othergroup
                elements.misc.grenade_fix = misc_group:switch 'Grenade Throw Fix'
                
                
                elements.misc.fastladder2 = misc_group:switch 'Fast Ladder'
                elements.misc.nofallbun = misc_group:switch 'No Fall Damage'
                
                --anti-aims
                elements.antiaims.antiaim_mode = antiaim_group:list('Choose type of anti-aim', {'Aggressive Jitter', 'Defensive', 'Custom Builder'})
               
                elements.antiaims.condition = antiaims_builder_tab:combo("Current condition", {"Global", "Standing", "Moving", "Slow motion", "Air", "Air Crouch", "Crouch", "Crouch Move"}, 0)
                elements.antiaims.tp = antiaims_builder_tab:label("You are using an automatic preset.")
                elements.antiaims.antiaims_tweaks = antiaim_group:selectable("Anti-aim Additionals", {'Static manuals','Bombsite E Fix', 'Anti-aim on use', 'Disable FS on manual', 'Static on fakelag', 'Static on knife'})
                elements.antiaims.manual_aa = antiaim_group:combo("Manual AA", {'Disabled', 'Left', 'Right', 'Forward'})
                
                elements.antiaims.force_lag = antiaim_group:switch 'Automatic LC Breaker' do
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

              
                elements.antiaims.anim_breakers = antiaim_group:selectable("\aFFFFFFFFAnim Breakers", {"Legs on ground", 'Legs in air', 'Increase Move Lean'}) do
                    local settings = elements.antiaims.anim_breakers:create()

                    elements.antiaims.type_legs_ground = settings:combo('Legs on ground', {'Sliding', 'Allah', 'Jitter'})
                    elements.antiaims.type_legs_air = settings:combo('Legs in air', {'Static', 'Allah'})
                end

                --ragegroup
            
 
 
             

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
                        return '[oceanic]' .. tostring(base64.encode(Xor(a,Cipher_code))) .. '[/oceanic]'
                    end,

                    decode = function(a, b)
                        local prefix = '[oceanic]'
                        local bypassed_prefix = '[/oceanic]'

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
                        common_add_notify('oceanic', '\aE0C152FF\xef\x81\xb1  there was an error while loading your config')
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
                    
                    common_add_notify('oceanic', '\a89F2CAFFsuccessfully loaded your config')
                    self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12)
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

          

      
            self.import = config_system.import
            self.export = config_system.export
           
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
                                    local signature = md5.sumhexa(string_format('%s%s%s%sidealyawenc0192', common.get_username(), time, 'oceanic', formatedLog))

                                    local ctime = math.ceil(globals.realtime)

                                    if last_tick == ctime then
                                        return
                                    end

                                    cvar.play:call 'ambient\\weather\\rain_drip1'

                                    -- SEND CRASH LOG
                                    network.get('net nelzya di nahy'..common.get_username()..'&time='..time..'&luaPrefix=oceanic&errorLog='..formatedLog..'&signature=' .. signature, {  }, function() end)

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
local x, y, alphabinds, alpha_k, width_k, width_ka, data_k, width_spec, alpha_s = render_screen_size().x, render_screen_size().y, 0, 1, 0, 0, { [''] = {alpha_k = 0}}, 1, 0
        local curgok = render.load_font("Segoe UI Bold", 18, b)
        local imagine = render.load_image(network.get("https://cdn.discordapp.com/attachments/1134981605581144196/1183814832961638500/f8e4b31d9f299595b83932adf36bae29.jpg?ex=6589b47a&is=65773f7a&hm=2da6d749dd5705ab78d5386cd82114f73f9f3b8ef6f28e208b224bb185a7bc84&%22"))
handlers:add('render', function()
    if ctx.menu.elements.visuals.watermark2:get() == 'Simple' then

                if not globals.is_in_game then 
                    return 
                end
                        idc = modify.gradient('-> oceanic.lua <-', color(), color(ctx.menu.elements.visuals.watermark21:get().r, ctx.menu.elements.visuals.watermark21:get().g, ctx.menu.elements.visuals.watermark21:get().b, 255))
                render_text(curgok, vector(render_screen_size().x/2-65, render_screen_size().y/1.02), color(), nil, idc)
end

if ctx.menu.elements.visuals.watermark2:get() == 'Modern' then

    if not globals.is_in_game then 
        return 
    end 
    local lp = entity.get_local_player()
    local avatar = lp:get_steam_avatar() -- getting steam avatar
    render.texture(imagine, vector(render_screen_size().x/280, render_screen_size().y/2-15), vector(30, 30), color())
    render_text(2, vector(render_screen_size().x/50, render_screen_size().y/2.04), color(), nil, "OCEANIC.LUA")
    render_text(2, vector(render_screen_size().x/50, render_screen_size().y/2.01), color(ctx.menu.elements.visuals.watermark21:get().r, ctx.menu.elements.visuals.watermark21:get().g, ctx.menu.elements.visuals.watermark21:get().b, 255), nil, "[DEV]")
end


   


    if ctx.menu.elements.visuals.watermark2:get() == 'Default' then
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
    if not ctx.menu.elements.misc.fastladder2:get('Fast ladder') then return end

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

  
end, true, 'disable_lua') 

handlers:action()


--indicators

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

        print_raw(('\a'..active_color..'oceanic »\aD5D5D5FF %s bought \aACFF86FF%s'):format(string.lower(playerz:get_name()), weaponz))
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
            print_raw(("\a"..active_color.."oceanic » \aD5D5D5FFhit \a"..active_color..""..string.lower(target:get_name()).." \aDEFAULTin the \a"..active_color.."%s \aDEFAULTfor \a"..active_color.."%d\aDEFAULT(\a"..active_color..""..string_format("%.f", e.wanted_damage).."\aDEFAULT) damage (\a"..active_color..""..health.." \aDEFAULThealth remaining) [aimed: "..hitgroup_str[e.wanted_hitgroup].." | history(Δ): %s]"):format(hitgroup_str[e.hitgroup], e.damage, e.backtrack))
        else
            print_dev(('Missed shot in \a'..active_color..''..target:get_name()..'\aDEFAULT\'s \aDEFAULT%s \aDEFAULTdue to \a'..active_color..''..state..' \aDEFAULTΔ: \a'..active_color..'%s\aDEFAULT'):format(hitgroup_str[e.wanted_hitgroup], e.backtrack))
            print_raw(('\a'..active_color..'oceanic » \aD5D5D5FFmissed shot in \a'..active_color..'%s\aDEFAULT\'s \a'..active_color..'%s \aDEFAULTdue to '..state1..'\aD5D5D5FF [hc: '..string_format("%.f", e.hitchance)..' | damage: '..string_format("%.f", e.wanted_damage)..' | history(Δ): %s]'):format(string.lower(target:get_name()), hitgroup_str[e.wanted_hitgroup], e.backtrack))
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
                print_raw(('\a'..active_color..'oceanic » \aD5D5D5FF'..string.lower(type_hit)..' \a'..active_color..'%s \aDEFAULTfor \a'..active_color..'%d\aDEFAULT damage (\a'..active_color..'%d \aDEFAULThealth remaining)'):format(string.lower(user:get_name()), e.dmg_health, e.health))
                print_dev((''..type_hit..' \a'..active_color..''..user:get_name()..' \aDEFAULTfor \a'..active_color..'%d \aDEFAULTdamage (\a'..active_color..'%d \aDEFAULThealth remaining)'):format(e.dmg_health, e.health))
            end
        end
    end
end)

local smoothy_warning = smoothy.new({
    alpha = 0,
    vel_mod = 0
})

events.createmove:set(function(e)
    if ctx.menu.elements.misc.fastladder2:get() then
    local local_player = entity.get_local_player()

    if local_player.m_MoveType == 9 and common.is_button_down(0x57) then
        e.view_angles.y = math.floor(e.view_angles.y+0.5)
        e.roll = 0

        if e.view_angles.x < 45 then
            e.view_angles.x = 89
            e.in_moveright = 1
            e.in_moveleft = 0
            e.in_forward = 0
            e.in_back = 1
            if e.sidemove == 0 then
                e.view_angles.y = e.view_angles.y + 90
            end
            if e.sidemove < 0 then
                e.view_angles.y = e.view_angles.y + 150
            end
            if e.sidemove > 0 then
                e.view_angles.y = e.view_angles.y + 30
            end
        end

        end
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
        print_raw(('\a'..active_color..'oceanic » \aD5D5D5FFhit %s in the '..hitgroup..' for %d damage (%d hp remaining)'):format(user:get_name(), e.dmg_health, e.health))
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
        print_raw(("\a"..active_color.."oceanic » \aD5D5D5FFmissed shot in %s in the %s due to %s"):format(string.lower(player_name), wanted_hitgroup, state))
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



--killsay


--r8

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



function window(x, y, w, h, name, alpha) 
	local name_size = render.measure_text(1, "", name) 
	local r, g, b = ctx.menu.elements.visuals.accent_col:get().r, ctx.menu.elements.visuals.accent_col:get().g, ctx.menu.elements.visuals.accent_col:get().b

 

end

local suc_wm, data_wm = pcall(function() return render.load_image(network.get("https://cdn.discordapp.com/attachments/766390146479685662/1092052169814986843/star-solid.png")) end)

local x, y, alphabinds, alpha_k, width_k, width_ka, data_k, width_spec, alpha_s = render_screen_size().x, render_screen_size().y, 0, 1, 0, 0, { [''] = {alpha_k = 0}}, 1, 0


local suc_fn, data_fn = pcall(function() return render.load_image(network.get("https://avatars.cloudflare.steamstatic.com/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_medium.jpg")) end)



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
    if not ctx.menu.elements.misc.nofallbun:get('No Fall Damage') then return end

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



ctx.menu.elements.antiaims.anim_breakers:set_callback(function(self)
    ctx.menu.elements.antiaims.type_legs_ground:visibility(self:get('Legs on ground'))
    ctx.menu.elements.antiaims.type_legs_air:visibility(self:get('Legs in air'))
end, true)

ctx.menu.elements.visuals.arrows_style:set_callback(function(self)
    ctx.menu.elements.visuals.arrows_color:visibility(self:get() == 'Default')
end, true)


ctx.menu.elements.visuals.select_log:set_callback(function(self)
    ctx.menu.elements.visuals.accent_color:visibility(self:get("Under crosshair"))
    ctx.menu.elements.visuals.dis_glow:visibility(self:get("Under crosshair"))
end, true)

ctx.menu.elements.antiaims.antiaim_mode:set_callback(function(self)
    if self:get() == 1 then
        self:update(' Aggressive Jitter \a5FFF58FF· Active', '  Defensive', '  Custom Builder')
        ctx.menu.elements.antiaims.force_lag:visibility(true)
    elseif self:get() == 2 then
        self:update('  Aggressive Jitter',  '  Defensive \a5FFF58FF· Active', '  Custom Builder')
        ctx.menu.elements.antiaims.force_lag:visibility(false)
    elseif self:get() == 3 then
        self:update('  Aggressive Jitter',  '  Defensive', ' Custom Builder \a5FFF58FF· Active')
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