local client_latency, client_set_clan_tag, client_log, client_timestamp, client_userid_to_entindex, client_trace_line, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_system_time, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_scale_damage, client_draw_hitboxes, client_get_cvar, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.latency, client.set_clan_tag, client.log, client.timestamp, client.userid_to_entindex, client.trace_line, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.system_time, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.scale_damage, client.draw_hitboxes, client.get_cvar, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get
local renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_measure_text, renderer_indicator, renderer_world_to_screen = renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.measure_text, renderer.indicator, renderer.world_to_screen
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local find_material = materialsystem.find_material
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
local ui_new_label = ui.new_label
local sx,sy = client_screen_size()
local temp_states = ui.new_slider('lua', 'b', '_temp_states', 0, 3, 0)


local http = require ('gamesense/http')
local downFilesys
local filecheck = false
local download
downFilesys = function()
    if readfile('csgo\\filesystem.lua') == nil then
        http.get("https://pastebin.com/raw/uK02CBLm",function(s,r)
             if not s or r.status ~= 200 then
                 return
             end
             writefile("csgo\\filesystem.lua",r.body)
         end)
         client.delay_call(3,downFilesys)
         client.color_log(100,100,255,"[Hyperion] Downloading (Filesystem.lua)")
    else    
        filecheck = true
        download()  
    end
end
local filsysThread = coroutine.create(downFilesys)
local s1 ,r1  = coroutine.resume(filsysThread)


download = function()
    if filecheck == true then
        local file = require("csgo/filesystem") 

         file.create_dir('hyp_release')

        
        if readfile('csgo\\hyp_release\\animate.lua') == nil then

            http.get("https://pastebin.com/raw/TvBHzfku",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\animate.lua",r.body)
            end)
            client.color_log(100,100,255,"[Hyperion] Downloading (animate.lua)")
        elseif readfile('csgo\\hyp_release\\animate.lua') ~= nil then
            http.get("https://pastebin.com/raw/TvBHzfku",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\animate.lua",r.body)
            end)
            client.color_log(100,175,255,"[Hyperion] Checking update.. (animate.lua)")

        end 

        if readfile('csgo\\hyp_release\\antiaim_funcs.lua') == nil then
            http.get("https://pastebin.com/raw/3g7jhujz",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end

                writefile("csgo\\hyp_release\\antiaim_funcs.lua",r.body)
            end)
            client.color_log(100,100,255,"[Hyperion] Downloading (antiaim_funcs.lua)")
        elseif readfile('csgo\\hyp_release\\antiaim_funcs.lua') ~= nil then
            http.get("https://pastebin.com/raw/3g7jhujz",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\antiaim_funcs.lua",r.body)
            end)        
            client.color_log(100,175,255,"[Hyperion] Checking update.. (antiaim_funcs.lua)")
        end 
    
        if readfile('csgo\\hyp_release\\color_utils.lua') == nil then
            http.get("https://pastebin.com/raw/e0EMeqw5",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\color_utils.lua",r.body)
            end)
            client.color_log(100,100,255,"[Hyperion] Downloading (color_utils.lua)")
        elseif readfile('csgo\\hyp_release\\color_utils.lua') ~= nil then
            http.get("https://pastebin.com/raw/e0EMeqw5",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\color_utils.lua",r.body)
            end)        
            client.color_log(100,175,255,"[Hyperion] Checking update.. (color_utils.lua)")

        end 
    
    
        if readfile('csgo\\hyp_release\\entity.lua') == nil then
            http.get("https://pastebin.com/raw/TZP93L80",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\entity.lua",r.body)
            end)
            client.color_log(100,100,255,"[Hyperion] Downloading (entity.lua)")
        elseif readfile('csgo\\hyp_release\\entity.lua') ~= nil then
            http.get("https://pastebin.com/raw/TZP93L80",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\entity.lua",r.body)
            end)        
            client.color_log(100,175,255,"[Hyperion] Checking update.. (entity.lua)")

        end 
        
        if readfile('csgo\\hyp_release\\gui.lua') == nil then
            http.get("https://pastebin.com/raw/Y7CvPkSh",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\gui.lua",r.body)
            end)
            client.color_log(100,100,255,"[Hyperion] Downloading (gui.lua)")
        elseif readfile('csgo\\hyp_release\\gui.lua') ~= nil then
            http.get("https://pastebin.com/raw/Y7CvPkSh",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\gui.lua",r.body)
            end)       
            client.color_log(100,175,255,"[Hyperion] Checking update.. (gui.lua)")
 
        end 
    
        if readfile('csgo\\hyp_release\\reference.lua') == nil then
            http.get("https://pastebin.com/raw/4mKvXenF",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\reference.lua",r.body)
            end)
            client.color_log(100,100,255,"[Hyperion] Downloading (reference.lua)")
        elseif readfile('csgo\\hyp_release\\reference.lua') ~= nil then
            http.get("https://pastebin.com/raw/4mKvXenF",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\reference.lua",r.body)
            end)        
            client.color_log(100,175,255,"[Hyperion] Checking update.. (reference.lua)")

        end 
    
        if readfile('csgo\\hyp_release\\render_ui.lua') == nil then
            http.get("https://pastebin.com/raw/TqLvxYp7",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\render_ui.lua",r.body)
            end)
            client.color_log(100,100,255,"[Hyperion] Downloading (render_ui.lua)")
        elseif readfile('csgo\\hyp_release\\render_ui.lua') ~= nil then
            http.get("https://pastebin.com/raw/TqLvxYp7",function(s,r)
                if not s or r.status ~= 200 then
                    return
                end
                writefile("csgo\\hyp_release\\render_ui.lua",r.body)
            end)        
            client.color_log(100,175,255,"[Hyperion] Checking update.. (render_ui.lua)")
        end 

    end
end


local __init = function ()
    local lib = {
        ['gamesense/antiaim_funcs'] = 'https://gamesense.pub/forums/viewtopic.php?id=29665',
        ['gamesense/base64'] = 'https://gamesense.pub/forums/viewtopic.php?id=21619',
        ['gamesense/clipboard'] = 'https://gamesense.pub/forums/viewtopic.php?id=28678',
        ['gamesense/http'] = 'https://gamesense.pub/forums/viewtopic.php?id=19253',
        ['gamesense/surface'] = 'https://gamesense.pub/forums/viewtopic.php?id=18793',
        ['gamesense/images'] = "https://gamesense.pub/forums/viewtopic.php?id=22917",
        ['gamesense/easing'] = 'https://gamesense.pub/forums/viewtopic.php?id=22920',
        ['gamesense/websockets'] = "https://gamesense.pub/forums/viewtopic.php?id=23653"
    }

    local _sub = {}

    for key, value in pairs(lib) do
        if not pcall(require,key)  then
            _sub[#_sub + 1] = lib[key]
        end
    end

    for i = 1,#_sub do
        error('not sub \n' .. table_concat(_sub , ", \n"))
    end

    local ffi = require("ffi")
    local bit = require("bit")
    local antiaim_funcs = require('gamesense/antiaim_funcs')
    local base64 = require('gamesense/base64')
    local clipboard = require('gamesense/clipboard')
    local surface = require('gamesense/surface')
    local images = require('gamesense/images')
    local easing = require "gamesense/easing"
    local md5 = require "gamesense/md5"
    local vector = require("vector")
    local websockets = require "gamesense/websockets"
    
    

   
    local reference = require("csgo/hyp_release/reference")
    local gui = require "csgo/hyp_release/gui"
    local color_utils = require "csgo/hyp_release/color_utils"
    local ety = require("csgo/hyp_release/entity")
    local anim = require ("csgo/hyp_release/animate")
    local rui = require ("csgo/hyp_release/render_ui")
    local afunc = require('csgo/hyp_release/antiaim_funcs')

    local uix = {}

    uix.notify = {}
    uix.notify.tb = {}
    uix.hitlog = {}
    uix.hitlog.tb = {}
    local obex_data =  {username = 'discord.gg/scriptleaks', build = 'dev', discord=''}

    local logs = function( ...)
        local ret = { ... };
    
        
        color_utils:log(
            { { 248,248,248}, {102,102,102 }, "Hyperion" },
            { { 100, 100, 100 }, " >> "},
            { { 255, 255, 255 }, string.format(unpack(ret)),true }
        )
    end

    logs('All files checked and loaded successfully , Welcome!')

    logs('Hyperion.lua v1.0.3 edition: '..obex_data.build)

    logs('Type "./help" to get command list.')
    logs('Type "./help" to get command list.')
    logs('Type "./help" to get command list.')
    logs('Type "./help" to get command list.')


    local reg_call , exp_call,aa_exp = {} , {['number'] = {},['string'] = {},['boolean'] = {},['table'] = {}}, {['number'] = {},['string'] = {},['boolean'] = {},['table'] = {}}

    local lua_dirA,lua_dirB,lua_dirC,lua_dirD,lua_dirE = "aa","anti-aimbot angles",'Fake lag','aa','anti-aimbot angles'
    local tempdirA,tempdirB = 'aa','Fake lag'
    local c_tf = "\a6C6C6CFF[Ft.]\aFFFFFFFF"
    local c_td = "\a6C6C6CFF[Ds.]\aFFFFFFFF"
    local c_tp = "\a6C6C6CFF[Lp.]\aFFFFFFFF"

    local p_states = {'stand','move','duck','slow-motion','air','air + duck'}
    local m = {  }
    local c_tb = {}


    m.spacing = ui_new_label(lua_dirA,lua_dirB," ")


    m.inf1 = gui.new(ui_new_label(lua_dirA,lua_dirB,"\a96C83CFFHyperion\aFFFFFFC8.lua"),reg_call,exp_call)
    m.inf2 = gui.new(ui_new_label(lua_dirA,lua_dirB,"\a6C6C6CFF #FEAROFGOD"),reg_call,exp_call)
    m.ins = gui.new(ui_new_checkbox(lua_dirA,lua_dirB," "),reg_call,exp_call)

    m.f_list = gui.new(ui_new_combobox(lua_dirA,lua_dirB,c_tf.." features selection",{"desync sys.","lua op."}),reg_call,exp_call)

    m.ds_mswitch = gui.new(ui_new_combobox(lua_dirA,lua_dirB,c_td.." @desync mode",{'rage','semi-rage'}),reg_call,exp_call)

    --semi 
    m.semi_builder = {}
    local c_ts = "\a6C6C6CFF[semi]\aFFFFFFFF"

    m.semi_builder.pitch = {
        gui.new(ui_new_combobox(tempdirA,tempdirB,c_ts..' pitch',{"Off","Default","Up","Down","Minimal","Random","Custom"}),reg_call,exp_call,aa_exp),
        gui.new(ui_new_slider(tempdirA,tempdirB,c_ts.." deg.",-89,89,0,true,"°"),reg_call,exp_call,aa_exp)
    } 

    m.semi_builder.yaw_base =  gui.new(ui_new_combobox(tempdirA,tempdirB,c_ts.." yaw base",{"At targets",'Local view'}),reg_call,exp_call,aa_exp)

    m.semi_builder.yaw = { 
        gui.new(ui_new_combobox(tempdirA,tempdirB,c_ts.." yaw",{"Off",'180','Spin','Static','180 Z','Crosshair'}),reg_call,exp_call,aa_exp),
        gui.new(ui_new_slider(tempdirA,tempdirB,c_ts.." yaw dir.",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
    }
    m.semi_builder.yaw_jitter = {
        gui.new(ui_new_combobox(tempdirA,tempdirB,c_ts.." yaw jitter",{"Off",'Offset','Center',"Random","Skitter"}),reg_call,exp_call,aa_exp),
        gui.new(ui_new_slider(tempdirA,tempdirB,c_ts.." yaw jitter deg.",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
    }
    m.semi_builder.body_yaw = {
        gui.new(ui_new_combobox(tempdirA,tempdirB,c_ts.." body yaw" ,{'Off','Opposite','Jitter','Static'}),reg_call,exp_call,aa_exp),
        gui.new(ui_new_slider(tempdirA,tempdirB,c_ts.." body yaw deg.",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
        gui.new(ui_new_checkbox(tempdirA,tempdirB,'freestand yaw',false),reg_call,exp_call,aa_exp)
    }

    m.semi_builder.roll = {
        gui.new(ui_new_multiselect(tempdirA,tempdirB,c_ts.." roll" ,{'Extend','Disable roll when peeking','Matchmaking'}),reg_call,exp_call,aa_exp),
        gui.new(ui_new_slider(tempdirA,tempdirB,c_ts.." roll udeg.",-90,90,0,true,"°"),reg_call,exp_call,aa_exp),
        gui.new(ui_new_slider(tempdirA,tempdirB,c_ts.." roll deg.",-45,45,0,true,"°"),reg_call,exp_call,aa_exp),
    }

    m.invert_key = ui_new_hotkey(tempdirA,tempdirB,c_tp..' invert')

    m.ds_switch = gui.new(ui_new_checkbox(lua_dirA,lua_dirB,c_td.." override antiaim"),reg_call,exp_call)

    m.ds_mode = gui.new(ui_new_combobox(lua_dirA,lua_dirB,c_td.." mode switcher",{"auto -get config from command","builder"}),reg_call,exp_call)

    m.ds_builder = {}

    m.ds_states = gui.new(ui_new_combobox(lua_dirA,lua_dirB,c_td.." player states",p_states),reg_call,exp_call)

    for k, v in pairs(p_states) do
        c_tb[k] = "\a6C6C6CFF["..p_states[k].."]\aFFFFFFFF"
        m.ds_builder[k] = {
            override = gui.new(ui_new_checkbox(tempdirA,tempdirB,c_tb[k]..' override states'),reg_call,exp_call,aa_exp),
            pitch = {
                gui.new(ui_new_combobox(tempdirA,tempdirB,c_tb[k]..' pitch',{"Off","Default","Up","Down","Minimal","Random","Custom"}),reg_call,exp_call,aa_exp),
                gui.new(ui_new_slider(tempdirA,tempdirB," ",-89,89,0,true,"°"),reg_call,exp_call,aa_exp)
            },
            yaw = { 
                gui.new(ui_new_combobox(tempdirA,tempdirB,c_tb[k].." yaw",{"Off",'180','Spin','Static','180 Z','Crosshair'}),reg_call,exp_call,aa_exp),
                gui.new(ui_new_combobox(tempdirA,tempdirB,c_tb[k].." yaw mode",{"off",'experimental'}),reg_call,exp_call,aa_exp),
                gui.new(ui_new_slider(tempdirA,tempdirB,c_tb[k].." yaw dir.",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
                gui.new(ui_new_slider(tempdirA,tempdirB,c_tb[k].." yaw.L",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
                gui.new(ui_new_slider(tempdirA,tempdirB,c_tb[k].." yaw.R",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
            },
            yaw_jitter = {
                gui.new(ui_new_combobox(tempdirA,tempdirB,c_tb[k].." yaw jitter",{"Off",'Offset','Center',"Random","Skitter"}),reg_call,exp_call,aa_exp),
                gui.new(ui_new_combobox(tempdirA,tempdirB,c_tb[k].." yaw jitter mode",{"off",'experimental'}),reg_call,exp_call,aa_exp),
                gui.new(ui_new_slider(tempdirA,tempdirB,c_tb[k].." yaw jitter deg.",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
                gui.new(ui_new_slider(tempdirA,tempdirB,c_tb[k].." yaw jitter.L",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
                gui.new(ui_new_slider(tempdirA,tempdirB,c_tb[k].." yaw jitter.R",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
            },
            body_yaw = {
                gui.new(ui_new_combobox(tempdirA,tempdirB,c_tb[k].." body yaw" ,{'Off','Opposite','Jitter','Static'}),reg_call,exp_call,aa_exp),
                gui.new(ui_new_combobox(tempdirA,tempdirB,c_tb[k].." body yaw mode",{"off",'experimental'}),reg_call,exp_call,aa_exp),
                gui.new(ui_new_slider(tempdirA,tempdirB,c_tb[k].." body yaw deg.",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
                gui.new(ui_new_slider(tempdirA,tempdirB,c_tb[k].." body.L",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
                gui.new(ui_new_slider(tempdirA,tempdirB,c_tb[k].." body.R",-180,180,0,true,"°"),reg_call,exp_call,aa_exp),
                gui.new(ui_new_checkbox(tempdirA,tempdirB,'freestand yaw',false),reg_call,exp_call,aa_exp)
            }

        }
    end

    
    m.luop_list = gui.new(ui_new_multiselect(lua_dirA,lua_dirB,c_tp.." @options",{'key','vis.','uix','misc.'}),reg_call,exp_call)



    m.manual_options = gui.new(ui_new_multiselect(lua_dirA,lua_dirC,c_tp..' manual options',{'static','force 90°','show indicator'}),reg_call,exp_call)
    m.arrow_distance = gui.new(ui_new_slider(lua_dirA,lua_dirC,c_tp..' distance',10,100,15,true,'%'),reg_call,exp_call)
    m.manual_left = {false, ui_new_hotkey(lua_dirA,lua_dirC,c_tp..' manual left')}
    m.manual_right = {false, ui_new_hotkey(lua_dirA,lua_dirC,c_tp..' manual right')}
    m.manual_reset = {false, ui_new_hotkey(lua_dirA,lua_dirC,c_tp..' manual reset')}
    m.legit_aa = ui_new_hotkey(lua_dirA,lua_dirC,c_tp..' antiaim on use')
    m.freestanding = {false, ui_new_hotkey(lua_dirA,lua_dirC,c_tp..' freestanding')}
    m.edge_yaw = {false, ui_new_hotkey(lua_dirA,lua_dirC,c_tp..' edge yaw')}

    m.misc_options = gui.new(ui_new_multiselect(lua_dirA,lua_dirC,c_tp..' misc. features',{'anti-knife','animation breaker'}),reg_call,exp_call)
    m.misc_antidis = gui.new(ui_new_slider(lua_dirA,lua_dirC,c_tp..' anti-distance',200,600,280,true,'m'),reg_call,exp_call)
    m.misc_animbreak = gui.new(ui_new_multiselect(lua_dirA,lua_dirC,c_tp..' anims',{"in air","on land","leg fucker"}),reg_call,exp_call)

    m.luop_color_label = gui.new(ui_new_label(lua_dirA,lua_dirB,c_tp..' main color'),reg_call,exp_call)
    m.luop_color = gui.new(ui_new_color_picker(lua_dirA,lua_dirB,c_tp..' main color',177,241,248,255),reg_call,exp_call)
    m.luop_arrows_clabel = gui.new(ui_new_label(lua_dirA,lua_dirB,c_tp..' arrows color'),reg_call,exp_call)
    m.luop_arrowsc = gui.new(ui_new_color_picker(lua_dirA,lua_dirB,c_tp..' arrows color',177,241,248,255),reg_call,exp_call)
    m.luop_cmode = gui.new(ui_new_combobox(lua_dirA,lua_dirB,c_tp..' container mode',{'a','b'}),reg_call,exp_call)
    m.luop_wset = gui.new(ui_new_checkbox(lua_dirA,lua_dirB,c_tp.." extend watermark",false),reg_call,exp_call)
    m.luop_uix = gui.new(ui_new_combobox(lua_dirA,lua_dirB,c_tp..' watermark pos.',{'menu','screen'}),reg_call,exp_call)
    m.luop_screenpos = gui.new(ui_new_combobox(lua_dirA,lua_dirB,c_tp.. ' screen pos',{'top left','top right','bottom middle'}),reg_call,exp_call)
    m.luop_vis = gui.new(ui_new_multiselect(lua_dirA,lua_dirB,c_tp..' vis. elements',{"crosshair",'notification','damage info'}),reg_call,exp_call)
    -- m.luop_statusop = gui.new(ui_new_multiselect(lua_dirA,lua_dirB,c_tp..' panel elements',{"exploit",'anti-aim','desync'}),reg_call,exp_call)
    -- m.luop_statusalpha = gui.new(ui_new_slider(lua_dirA,lua_dirB,c_tp..' background alpha',0,100,100,true,'%'),reg_call,exp_call)
    ui_set(m.luop_vis,'notification')
    m.luop_notify_addy = gui.new(ui_new_slider(lua_dirA,lua_dirB,c_tp..' notify offset',50,sy/2,sy/5,true,'px'),reg_call,exp_call)
    m.luop_hitlog_addy = gui.new(ui_new_slider(lua_dirA,lua_dirB,c_tp..' hitlog offset',50,sy,sy-65,true,'px'),reg_call,exp_call)
    m.pos_x = gui.new(ui_new_slider("LUA", "B", "\nSaved Position X INDICATOR", 0, 10000, 10),reg_call,exp_call)
    m.pos_y = gui.new(ui_new_slider("LUA", "B", "\nSaved Position Y INDICATOR", 0, 10000, 420),reg_call,exp_call)


    m.spacing2 = ui_new_label(lua_dirA,lua_dirB," ")

    local set_visible = function ()
        local ins = ui_get(m.ins)
        ui_set_visible(m.inf1,not ins)
        ui_set_visible(m.inf2,not ins)

        ui_set_visible(m.f_list,ins)

        local ds,luop = ui_get(m.f_list) == 'desync sys.' and ins,ui_get(m.f_list) == "lua op." and ins

        ui_set_visible(m.ds_mswitch,ds)
        ui_set_visible(m.ds_switch,ds and ui_get(m.ds_mswitch) == 'rage')
        local ds_over = ui_get(m.ds_switch) and ds and ui_get(m.ds_mswitch) == 'rage'
        local ds_semi = ds and ui_get(m.ds_mswitch) == 'semi-rage'

        ui_set_visible(m.ds_mode,ds_over)
        ui_set_visible(m.ds_states,ds_over and ui_get(m.ds_mode) == "builder")
        ui_set_visible(m.semi_builder.pitch[1],ds_semi)
        ui_set_visible(m.semi_builder.pitch[2],ds_semi and ui_get(m.semi_builder.pitch[1]) == 'Custom')
        ui_set_visible(m.semi_builder.yaw_base,ds_semi )
        ui_set_visible(m.semi_builder.yaw[1],ds_semi )
        ui_set_visible(m.semi_builder.yaw[2],ds_semi and ui_get(m.semi_builder.yaw[1]) ~= 'Off')
        ui_set_visible(m.semi_builder.yaw_jitter[1],ds_semi )
        ui_set_visible(m.semi_builder.yaw_jitter[2],ds_semi and ui_get(m.semi_builder.yaw_jitter[1]) ~= 'Off')
        ui_set_visible(m.semi_builder.body_yaw[1],ds_semi )
        ui_set_visible(m.semi_builder.body_yaw[2],ds_semi and ui_get(m.semi_builder.body_yaw[1]) ~= 'Off')
        ui_set_visible(m.semi_builder.body_yaw[3],ds_semi and ui_get(m.semi_builder.body_yaw[1]) ~= 'Off')
        ui_set_visible(m.semi_builder.roll[1],ds_semi)
        ui_set_visible(m.semi_builder.roll[2],ds_semi and gui.table_contain(ui_get(m.semi_builder.roll[1]),'Untrust'))
        ui_set_visible(m.semi_builder.roll[3],ds_semi and not gui.table_contain(ui_get(m.semi_builder.roll[1]),'Untrust'))

        ui_set_visible(m.invert_key,ds_semi)
        ui_set_visible(m.pos_x,false)
        ui_set_visible(m.pos_y,false)

        for k ,v in pairs(p_states) do
            
            local show = ds_over and ui_get(m.ds_mode) == "builder" and ui_get(m.ds_states) == p_states[k]
            
            ui_set_visible(m.ds_builder[k].override,show)

            local s = show and ui_get(m.ds_builder[k].override)

            ui_set_visible(m.ds_builder[k].pitch[1],s)
            ui_set_visible(m.ds_builder[k].pitch[2],s and ui_get(m.ds_builder[k].pitch[1]) == 'Custom')

            ui_set_visible(m.ds_builder[k].yaw[1],s)
            ui_set_visible(m.ds_builder[k].yaw[2],s and ui_get(m.ds_builder[k].yaw[1]) == '180')
            ui_set_visible(m.ds_builder[k].yaw[3],s and ui_get(m.ds_builder[k].yaw[1]) == '180' )
            ui_set_visible(m.ds_builder[k].yaw[4],s and ui_get(m.ds_builder[k].yaw[1]) == '180' and (ui_get(m.ds_builder[k].yaw[2]) == 'experimental' ))
            ui_set_visible(m.ds_builder[k].yaw[5],s and ui_get(m.ds_builder[k].yaw[1]) == '180' and (ui_get(m.ds_builder[k].yaw[2]) == 'experimental' ))


            ui_set_visible(m.ds_builder[k].yaw_jitter[1],s)
            ui_set_visible(m.ds_builder[k].yaw_jitter[2],s and ui_get(m.ds_builder[k].yaw_jitter[1]) ~= 'Off')
            ui_set_visible(m.ds_builder[k].yaw_jitter[3],s and ui_get(m.ds_builder[k].yaw_jitter[1]) ~= 'Off')
            ui_set_visible(m.ds_builder[k].yaw_jitter[4],s and ui_get(m.ds_builder[k].yaw_jitter[1]) ~= 'Off' and (ui_get(m.ds_builder[k].yaw_jitter[2]) == 'experimental' ))
            ui_set_visible(m.ds_builder[k].yaw_jitter[5],s and ui_get(m.ds_builder[k].yaw_jitter[1]) ~= 'Off' and (ui_get(m.ds_builder[k].yaw_jitter[2]) == 'experimental'))


            ui_set_visible(m.ds_builder[k].body_yaw[1],s)
            ui_set_visible(m.ds_builder[k].body_yaw[2],s and (ui_get(m.ds_builder[k].body_yaw[1]) == 'Jitter' or ui_get(m.ds_builder[k].body_yaw[1]) == 'Static'))
            ui_set_visible(m.ds_builder[k].body_yaw[3],s and (ui_get(m.ds_builder[k].body_yaw[1]) == 'Jitter' or ui_get(m.ds_builder[k].body_yaw[1]) == 'Static'))
            ui_set_visible(m.ds_builder[k].body_yaw[4],s and ui_get(m.ds_builder[k].body_yaw[1]) ~= 'Off' and (ui_get(m.ds_builder[k].body_yaw[2]) == 'experimental'))
            ui_set_visible(m.ds_builder[k].body_yaw[5],s and ui_get(m.ds_builder[k].body_yaw[1]) ~= 'Off' and (ui_get(m.ds_builder[k].body_yaw[2]) == 'experimental'))
            ui_set_visible(m.ds_builder[k].body_yaw[6],s and ui_get(m.ds_builder[k].body_yaw[1]) ~= 'Off')
        end

        --lua options start

        ui_set_visible(m.luop_list,luop)

        ui_set_visible(m.luop_color_label,luop)
        ui_set_visible(m.luop_color,luop)
        ui_set_visible(m.luop_cmode,luop)
        ui_set_visible(m.luop_arrows_clabel,luop)
        ui_set_visible(m.luop_arrowsc,luop)

        ui_set_visible(m.misc_options,luop and gui.table_contain(ui_get(m.luop_list),'misc.'))
        ui_set_visible(m.misc_antidis,luop and gui.table_contain(ui_get(m.luop_list),'misc.') and gui.table_contain(ui_get(m.misc_options),'anti-knife'))
        ui_set_visible(m.misc_animbreak,luop and gui.table_contain(ui_get(m.luop_list),'misc.') and gui.table_contain(ui_get(m.misc_options),'animation breaker'))

        ui_set_visible(m.luop_uix,luop and gui.table_contain(ui_get(m.luop_list),'uix'))
        ui_set_visible(m.luop_wset,luop and gui.table_contain(ui_get(m.luop_list),'uix'))
        ui_set_visible(m.luop_screenpos,luop and gui.table_contain(ui_get(m.luop_list),'uix') and ui_get(m.luop_uix) == 'screen')

        ui_set_visible(m.luop_vis,luop and gui.table_contain(ui_get(m.luop_list),'vis.'))
        ui_set_visible(m.luop_notify_addy,luop and gui.table_contain(ui_get(m.luop_list),'vis.') and gui.table_contain(ui_get(m.luop_vis),'notification'))
        ui_set_visible(m.luop_hitlog_addy,luop and gui.table_contain(ui_get(m.luop_list),'vis.') and gui.table_contain(ui_get(m.luop_vis),'damage info'))
        -- ui_set_visible(m.luop_statusop,luop and gui.table_contain(ui_get(m.luop_list),'vis.') and gui.table_contain(ui_get(m.luop_vis),'status panel'))
        -- ui_set_visible(m.luop_statusalpha,luop and gui.table_contain(ui_get(m.luop_list),'vis.') and gui.table_contain(ui_get(m.luop_vis),'status panel'))


        local key = luop and gui.table_contain(ui_get(m.luop_list),'key') 
        ui_set_visible(m.manual_options,key )
        ui_set_visible(m.arrow_distance,key and gui.table_contain(ui_get(m.manual_options),'show indicator'))
        ui_set_visible(m.manual_left[2],key )
        ui_set_visible(m.manual_right[2],key)
        ui_set_visible(m.manual_reset[2],key)
        ui_set_visible(m.legit_aa,key)
        ui_set_visible(m.freestanding[2],key)
        ui_set_visible(m.edge_yaw[2],key)


    end

    local fake_lag = {}

    fake_lag.r_enable = {
        ui_new_label('AA','Other','Fake Lag'),
        ui_new_checkbox('AA','Other','Enabled'),
        ui_new_hotkey('AA','Other','Enabled',true)
    }

    fake_lag.r_amount = {
        ui_new_combobox('AA','Other','Amount',{'Dynamic','Maximum','Fluctuate'})
    }

    fake_lag.r_variance = {
        ui_new_slider('AA','Other','Variance',0,100,15,true,"%")
    }

    fake_lag.r_limit = {
        ui_new_slider('AA','Other','Limit',1,15,1)
    }

    fake_lag.fn = function(state)
        local f = {
            reference.fake_enable[1],reference.fake_enable[2],reference.fake_amount,reference.fake_variance,reference.fake_limit
        }
        
        for k, v in pairs(f) do
            ui_set_visible(v,state)
        end
    end

    fake_lag.set = function()
        local f = {
            reference.fake_enable[1],reference.fake_enable[2],reference.fake_amount,reference.fake_variance,reference.fake_limit
        }
        ui_set(f[2],'Always on')

        ui_set(f[1],ui_get(fake_lag.r_enable[2]))
        ui_set(f[2],ui_get(fake_lag.r_enable[3]))
        ui_set(f[3],ui_get(fake_lag.r_amount[1]))
        ui_set(f[4],ui_get(fake_lag.r_variance[1]))
        ui_set(f[5],ui_get(fake_lag.r_limit[1]))
    end

    fake_lag.fn(false)
    uix.var =  {
        --top_bar
        tb = {
            is_open = 0,

            pos = {
                {x = 0 , y = 0},
                {x = sx , y = 0},
                {x = sx/2 , y = sy}
            },

            tpos = {
                x = 0 ,y = 0
            },

            ex = {
                ext = 0,
            }

        },

        --on load
        ol = {
            start_time = globals_realtime(),
            check = false,
            alpha = 0,

            pos = {
                x = sx/2 ,y = sy/2, w = 100,glow = 0,a = 0,a2 = 0
            }
        },

        cr = {
            alpha = 0,
            add_x = 0,
            ['values'] = {
                0,0,0,0,0,0
            },
            ['arrows'] = {
                g_alpha = 0,
                ['left'] = {
                    r = 0 , g = 0 , b = 0 , a = 0
                },
                ['right'] = {
                    r = 0 , g = 0 , b = 0 , a = 0
                },
                ['animate'] = {
                    right_x = 0,
                    left_x = 0
                },

                menu_alpha = 0
                
            },

            bar_color = {
                r = 0 , g = 0 , b = 0 , a = 0

            },
            
            desync_bar = 1,

        },

        sts = {
            ox = 0 , oy = 0 , is_drag = false , alpha = 0 ,

            dt = 0, hs = 0 , dt_shift = 0 , lag = 0 , wait = 0, 

            exp = 0 , stat = 0,
            ps = {
                0,0,0,0,0,0
            },

            add_y_a = 0,
            add_y_b = 0,
            add_y_c = 0,


        }
    }


    uix.on_load = function(  )
        local v = uix.var.ol

        local r,g,b,a = ui.get(m.luop_color)

        v.alpha = anim.new(v.alpha,0,1,v.check,3)

        local icon_cx =   (ui_get(m.luop_screenpos) == 'top left' and sx - 55) or (ui_get(m.luop_screenpos) == 'top right' and 5 ) or (ui_get(m.luop_screenpos) == 'bottom middle' and sx - 55)

        v.pos.w = anim.new(v.pos.w,50,100,v.alpha <= 0.01,3)
        v.pos.x = anim.new(v.pos.x,icon_cx,sx/2 - math_floor(180 * v.alpha),v.alpha <= 0.01,3)

        v.pos.y = anim.new(v.pos.y,0,sy/2 - 50,v.alpha <= 0.01,3)
        v.pos.glow = anim.new(v.pos.glow,0,20,v.alpha <= 0.01,3)
        v.pos.a = anim.new(v.pos.a,100,255,v.alpha <= 0.01,3)

        v.pos.a2 = anim.new(v.pos.a2,0,1,v.check,3)

        rui.icon(v.pos.x , v.pos.y,v.pos.w ,v.pos.w,r,g,b,v.pos.a ,true,v.pos.glow,true,r,g,b )

        if v.alpha <= 0.01 then
            return
        end

        local sx,sy = client_screen_size()
        local hy_temp = color_utils.fade_text(r,g,b,255* v.alpha,105,105,105,255* v.alpha,"Hyperion.lua")
        local mx, my = renderer_measure_text('+',nil,hy_temp)
        local vx, vy = renderer_measure_text('+',nil,'<-'..string.upper(obex_data.build)..'  BUILD->')

        renderer.blur(0,0,sx * v.alpha,sy )
        renderer.rectangle(0, 0, sx * v.alpha, sy , 31, 31, 31, 100 * v.alpha)

        rui.icon(v.pos.x , v.pos.y,v.pos.w ,v.pos.w,r,g,b, 255 * v.pos.a2 ,true,v.pos.glow,true,r,g,b )

        renderer_text(sx/2  - math_floor( mx/2 * v.alpha),sy/2 - my/2,r,g,b,a * v.alpha,'+',0,hy_temp)
        renderer_text(sx/2  - math_floor( vx/2 * v.alpha) + mx/2 + 10,sy/2 - vy/2 + 30 ,255,105,105,255 * v.alpha,'-',0,'<-'..string.upper(obex_data.build)..'  BUILD->')

        if v.start_time  + 5 < globals_realtime() then
            v.start_time = globals_realtime()
            v.check = true
        end
    end

    local get_name = panorama.loadstring([[ return MyPersonaAPI.GetName() ]])
    local get_gc_state = panorama.loadstring([[ return MyPersonaAPI.IsConnectedToGC() ]])
    local classptr = ffi.typeof('void***')
    local latency_ptr = ffi.typeof('float(__thiscall*)(void*, int)')
    local rawivengineclient = client.create_interface('engine.dll', 'VEngineClient014') or error('VEngineClient014 wasnt found', 2)
    local ivengineclient = ffi.cast(classptr, rawivengineclient) or error('rawivengineclient is nil', 2)
    local is_in_game = ffi.cast('bool(__thiscall*)(void*)', ivengineclient[0][26]) or error('is_in_game is nil')


    uix.top_bar = function ()
        local sx,sy = client_screen_size()
        local mx,my = ui.menu_position()
        local is_open = ui_is_menu_open()

        local x,y = mx ,my
        uix.var.tb.is_open = anim.new(uix.var.tb.is_open , 1,0,is_open,12)
        uix.var.tb.ex.ext = anim.new(uix.var.tb.ex.ext , 1,0,ui_get(m.luop_wset),6)
        
        local sys_time = { client_system_time() }
        local actual_time = ('%02d:%02d:%02d'):format(sys_time[1], sys_time[2], sys_time[3])

        local is_connected_to_gc = get_gc_state()
        local gc_state = not is_connected_to_gc and '\x20\x20\x20\x20\x20' or ''

        local nickname = obex_data.username
   
        local text = ('%s  %s  %s'):format(gc_state, nickname, actual_time)

        if is_in_game(is_in_game) == true then

            local latency = client.latency()*1000
            local latency_text = latency > 5 and (' delay: %dms'):format(latency) or ''
            text = ('%s  %s %s  %s'):format(gc_state,  nickname, latency_text, actual_time)
        end


        local ex_w =  renderer_measure_text(nil, text) + 8
        local r,g,b,a = ui.get(m.luop_color)

        if ui_get(m.luop_uix) == 'menu' then

            
            if uix.var.tb.is_open <= 0.01 then
                return
            end

            local hy_temp = color_utils.fade_text(r,g,b,255* uix.var.tb.is_open,105,105,105,255* uix.var.tb.is_open,'Hyperion')
            local hy_x , hy_y = renderer_measure_text(nil,0,hy_temp)
             
            rui.container(x,y - math_floor(30 * uix.var.tb.is_open),180 + math_floor(ex_w * uix.var.tb.ex.ext),math_floor(25 * uix.var.tb.is_open),r,g,b,a * uix.var.tb.is_open,15 * uix.var.tb.is_open,ui_get(m.luop_cmode))
            renderer_text(x + 10,y + 5 - math_floor(30 * uix.var.tb.is_open),255,255,255,255 * uix.var.tb.is_open,nil,0,hy_temp)
            rui.icon(x + 80, y - math_floor(30 * uix.var.tb.is_open) + 2, 20,20, r, g, b, a *  uix.var.tb.is_open,true,15 *  uix.var.tb.is_open,false,r,g,b)
            renderer_text(x  + hy_x+ 4,y + 5 - math_floor(30 * uix.var.tb.is_open),255,255,255,255 * uix.var.tb.is_open,nil,0,".lua")
            
            renderer_text(x  + 110 , y  + 5-  math_floor(30 * uix.var.tb.is_open),255,105,105,255 * uix.var.tb.is_open,nil,0,string.upper(obex_data.build)..'. edition')

            --ext 

            renderer_text(x+ 175, y -  math_floor(30 * uix.var.tb.is_open) + 5, 255, 255, 255, 255 * uix.var.tb.is_open * uix.var.tb.ex.ext  , '', 0,"|".. text)

    

        elseif ui_get(m.luop_uix) == 'screen' then

            local p = uix.var.tb.pos
            local tx , ty = 
            (ui_get(m.luop_screenpos) == 'top left' and p[1].x  + 10) or (ui_get(m.luop_screenpos) == 'top right' and p[2].x - 190 - math_floor(ex_w *  uix.var.tb.ex.ext) ) or (ui_get(m.luop_screenpos) == 'bottom middle' and p[3].x - 90 - math_floor(ex_w/2 *  uix.var.tb.ex.ext)),
            (ui_get(m.luop_screenpos) == 'top left' and p[1].y  + 40) or (ui_get(m.luop_screenpos) == 'top right' and p[2].y + 40 ) or (ui_get(m.luop_screenpos) == 'bottom middle' and p[3].y )

            local hy_temp = color_utils.fade_text(r,g,b,255,105,105,105,255,'Hyperion')
            local hy_x , hy_y = renderer_measure_text(nil,0,hy_temp)

            uix.var.tb.tpos.x = anim.new(uix.var.tb.tpos.x,is_open and x or tx,nil,nil,6)
            uix.var.tb.tpos.y = anim.new(uix.var.tb.tpos.y,is_open and y or ty,nil,nil,6)

            local rex,rey = math_floor(uix.var.tb.tpos.x),math_floor(uix.var.tb.tpos.y)

            rui.container(rex,rey - 30 ,180 + math_floor(ex_w * uix.var.tb.ex.ext) ,25 ,r,g,b,a,15,ui_get(m.luop_cmode))
            renderer_text(rex + 10,rey + 5 - 30 ,255,255,255,255 ,nil,0,hy_temp)
            rui.icon(rex + 80, rey- 30  + 2, 20,20, r,g,b, 255 ,true,15 )
            renderer_text(rex  + hy_x+ 4,rey + 5 - 30 ,255,255,255,255,nil,0,".lua")
            renderer_text(rex  + 110 , rey  + 5-  30 ,255,105,105,255,nil,0,string.upper(obex_data.build)..". edition")
            --ext
            renderer_text(rex+ 175, rey - 30  + 5, 255, 255, 255, 255 * uix.var.tb.ex.ext  , '', 0,"|".. text)

        end

    end


    uix.crosshair = function( )
        local sx,sy = client_screen_size()

        local mx,my = sx/2,sy/2

        uix.var.cr.alpha = anim.new(uix.var.cr.alpha,1,0,gui.table_contain(ui_get(m.luop_vis),'crosshair'),6)
        local r,g,b,a = ui.get(m.luop_color)


        local hy_temp = color_utils.fade_text(r,g,b,255 * uix.var.cr.alpha,105,105,105,255 * uix.var.cr.alpha,'HYPERION')
        local hy_x,hy_y = renderer_measure_text("-",nil,hy_temp)
        local alpha = math.sin(math.abs(-math.pi + (globals.curtime() * (1 / 0.7)) % (math.pi * 2))) * 255
        local desync = math_floor(math_abs(antiaim_funcs.get_desync(2)))
        local tx,ty = renderer.measure_text('-',nil,'HYPERION')
        uix.var.cr.add_x = anim.new(uix.var.cr.add_x,1,0,ety.is_scoped(entity_get_local_player()),12)
        renderer_text(mx - hy_x/2 + 5  + math_floor(35 * uix.var.cr.add_x) ,my + 10,255,255,255,255 ,'-',nil,hy_temp)
        rui.icon(mx  - hy_x/2  - 5 + math_floor(35 * uix.var.cr.add_x),my + 10,10,10,r,g,b,255 * uix.var.cr.alpha,false,nil,true)
        local modifier = entity_get_prop(entity_get_local_player(), "m_flVelocityModifier") ~= 1

        renderer.rectangle(mx  - hy_x/2  - 5 + math_floor(35 * uix.var.cr.add_x) + 11,my + 10 + ty,tx - 7 ,3,10,10,10,255 * uix.var.cr.alpha)

        uix.var.cr.desync_bar = anim.new(uix.var.cr.desync_bar ,modifier and (tx - 7) * entity_get_prop(entity_get_local_player(), "m_flVelocityModifier") or (tx - 7) * (desync/60),nil,nil,6)

        if uix.var.cr.desync_bar > (tx - 7 )  then
            uix.var.cr.desync_bar = (tx - 7)
        end
        uix.var.cr.bar_color = anim.new_color(uix.var.cr.bar_color,{r = 255 , g = 0,b = 0,a = 255 * uix.var.cr.alpha},{ r = r,g = g , b = b , a = 255 * uix.var.cr.alpha },modifier,6)

        renderer.rectangle(mx  - hy_x/2  - 5 + math_floor(35 * uix.var.cr.add_x) + 12,my + 11 + ty,math_floor(uix.var.cr.desync_bar),1,uix.var.cr.bar_color.r,uix.var.cr.bar_color.g,uix.var.cr.bar_color.b,uix.var.cr.bar_color.a)


        local ind_offset = 0


        local keys = {
            [1] = {
                ['condition'] = ui_get(m.freestanding[2]),
                ['text'] = 'FREESTAND',
                ['color'] = {r,g,b,255 * uix.var.cr.alpha}
            
            },

            [2] = {
                ['condition'] = ui_get(reference.force_body_aim),
                ['text'] = 'BAIM',
                ['color'] = {r,g,b,255 * uix.var.cr.alpha}
                
            },
            [3] = {
                ['condition'] = ui_get(reference.force_safe_point),
                ['text'] = 'SAFE',
                ['color'] = {r,g,b,255 * uix.var.cr.alpha}
                
            },
            [4] = {
                ['condition'] = ui_get(reference.quick_peek_assist[1]) and ui_get(reference.quick_peek_assist[2]),
                ['text'] = 'QUICK',
                ['color'] = {r,g,b,255 * uix.var.cr.alpha}
            },

            [5] = {
                ['condition'] = ui_get(reference.hide_shots[1]) and ui_get(reference.hide_shots[2]),
                ['text'] = 'ON-SHOT',
                ['color'] = {r,g,b,255 * uix.var.cr.alpha}
            },

            [6] = {
                ['condition'] = ui_get(reference.doubletap[1]) and ui_get(reference.doubletap[2]),
                ['text'] = 'CHARGE',
                ['color'] = {r,g,b,255 * uix.var.cr.alpha}              
            },
        }
        
        for k, items in pairs(keys) do
            local flags = 'c-'
            local text_width , text_height = renderer_measure_text(flags,items['text'])
            local key = items['condition'] and 1 or 0

            uix.var.cr['values'][k] = anim.new(uix.var.cr['values'][k],key,nil,nil,12)
            if k == 2 then
                ind_offset = ind_offset + 1 
            end
            
            local x , y = mx - hy_x/2 + 5  + math_floor(35 * uix.var.cr.add_x) + tx/2 - 5,my + 27

            renderer_text( 
                x , 
                y  +    math_floor(ind_offset * uix.var.cr['values'][k]),
                items['color'][1],items['color'][2],items['color'][3],items['color'][4] * uix.var.cr['values'][k] ,
                flags,
                text_width * uix.var.cr['values'][k] + 3,
                items['text']
            )
    
    
            ind_offset = ind_offset + math_floor(11 * uix.var.cr['values'][k])
        end

        local v = uix.var.cr['arrows']
        local dist = mx / 210 * ui_get(m.arrow_distance)
        v.g_alpha = anim.new(v.g_alpha,1,0,gui.table_contain(ui_get(m.manual_options),'show indicator') or (gui.table_contain(ui_get(m.manual_options),'show indicator') and ui_is_menu_open()),6)

        if v.g_alpha < 0.01 then return end

        local left_svg = '<svg t="1686019116149" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1930" width="200" height="200"><path d="M262.144 405.504l255.68-170.432a128 128 0 0 1 198.976 106.496v340.864a128 128 0 0 1-199.008 106.496l-255.648-170.432a128 128 0 0 1 0-212.992z" p-id="1931" fill="#ffffff"></path></svg>'
        local right_svg = '<svg t="1686019127483" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2144" width="200" height="200"><path d="M761.856 405.504l-255.68-170.432A128 128 0 0 0 307.2 341.568v340.864a128 128 0 0 0 199.008 106.496l255.648-170.432a128 128 0 0 0 0-212.992z" p-id="2145" fill="#ffffff"></path></svg>'

        local left_arrow = renderer.load_svg(left_svg,32,32)
        local right_arrow = renderer.load_svg(right_svg,32,32)
        local manual_state = ui_get(temp_states)

        local r1,g1,b1,a1 = ui.get(m.luop_arrowsc)

        v['left'] = anim.new_color(v['left'],{r = r1 , g = g1,b = b1,a = a1 * v.g_alpha},{ r = 0,g = 0 , b = 0 , a = 0 },manual_state == 1 or ui_is_menu_open(),6)
        v['right'] = anim.new_color(v['right'],{r = r1 , g = g1,b = b1,a = a1 * v.g_alpha},{ r = 0,g = 0 , b = 0 , a = 0 },manual_state == 2 or ui_is_menu_open(),6)
        
        local right_x = mx - 34 + dist
        local left_x = mx - dist

        v['animate'].right_x = anim.new(v['animate'].right_x,right_x,6)
        v['animate'].left_x = anim.new(v['animate'].left_x,left_x,6)

        local rex_r = math_floor(v['animate'].right_x)
        local rex_l = math_floor(v['animate'].left_x)

        renderer.texture(left_arrow,rex_l + 1,my + 1 + 1,32,31,25,25,25,v['left'].a,'f')
        renderer.texture(right_arrow,rex_r + math_floor(35 * uix.var.cr.add_x) + 1,my  - 1 + 1,32,32,25,25,25,v['right'].a,'f')

        renderer.texture(left_arrow,rex_l,my + 1,32,31,v['left'].r,v['left'].g,v['left'].b,v['left'].a,'f')
        renderer.texture(right_arrow,rex_r + math_floor(35 * uix.var.cr.add_x),my  - 1,32,32,v['right'].r,v['right'].g,v['right'].b,v['right'].a,'f')



    end

    local run_drag = function()
        local click = client.key_state(0x01)
        local mx, my = ui.mouse_position()
    
        local x, y = ui_get(m.pos_x), ui_get(m.pos_y)
        local sx, sy = client_screen_size()
    
        if uix.var.sts.dragging then
            local dx, dy = x - uix.var.sts.ox, y - uix.var.sts.oy
            ui_set(m.pos_x, math_min(math_max(mx + dx, 0), sx))
            ui_set(m.pos_y, math_min(math_max(my + dy, 0), sy))
            uix.var.sts.ox,uix.var.sts.oy = mx, my
        else
            uix.var.sts.ox, uix.var.sts.oy = mx, my
        end
    end
  
    local is_dragging = function(x , y , w , h )
        local mx, my = ui.mouse_position()
        local click = client.key_state(0x01)
        
        local in_x = mx > x and mx < x + w	
        local in_y = my > y and my < y + h 
    
        return in_x and in_y and click and ui_is_menu_open()
    end
    
    local is_dragging_menu = function()
        local x, y = ui.mouse_position()
        local px, py = ui.menu_position()
        local sx, sy = ui.menu_size()
        local click = client.key_state(0x01)
        
        local in_x = x > px and x < px + sx	
        local in_y = y > py and y < py + sy 
    
        return in_x and in_y and click and ui_is_menu_open()
    end



    -- uix.status = function()

    --     local v = uix.var.sts
    --     v.alpha = anim.new(v.alpha,1,0,gui.table_contain(ui_get(m.luop_vis),'status panel'),6)

    --     if entity_get_local_player() == nil then
    --         return
    --     end

    --     if v.alpha <= 0.01 then
    --         return
    --     end

    --     local x , y = ui_get(m.pos_x), ui_get(m.pos_y)
    --     local w , h = 135 ,25
    --     local click = client.key_state(0x01)
    --     local c = {ui_get(m.luop_color)}
    --     local alpha = 255 * (ui_get(m.luop_statusalpha)/100)
    --     --我不可能再写第二遍这个傻逼玩意
    --     rui.container_b(x,y,w,h,c[1],c[2],c[3],255 * v.alpha ,15* v.alpha,ui_get(m.luop_cmode),alpha)
    --     rui.icon(x + 5 , y + 2,20,20,c[1],c[2],c[3],255 * v.alpha  ,true,10 * v.alpha ,false,c[1],c[2],c[3])
    --     renderer_text(x + 30, y + 5, 255,255,255,255* v.alpha,nil,0,'Status Panel')
 

    --     v.add_y_a = anim.new(v.add_y_a,1,0,gui.table_contain(ui_get(m.luop_statusop),'exploit'),12)
    --     v.add_y_b = anim.new(v.add_y_b,1,0,gui.table_contain(ui_get(m.luop_statusop),'anti-aim'),12)
    --     v.add_y_c = anim.new(v.add_y_c,1,0,gui.table_contain(ui_get(m.luop_statusop),'desync'),12)

    --     --exploit

    --     local tickbase = antiaim_funcs.get_tickbase_shifting()
    --     v.dt = anim.new(v.dt,1,0,ui_get(reference.doubletap[1] and reference.doubletap[2]) and not ui_get(reference.hide_shots[1] and reference.hide_shots[2]),6)
    --     v.hs = anim.new(v.hs,1,0,ui_get(reference.hide_shots[1] and reference.hide_shots[2]) ,6)
    --     v.dt_shift = anim.new(v.dt_shift,1,0,antiaim_funcs.get_double_tap(),12)
    --     v.lag = anim.new(v.lag,0,1,antiaim_funcs.get_double_tap(),12)
    --     v.wait = anim.new(v.wait,0,1,ui_get(reference.doubletap[1] and reference.doubletap[2]) or ui_get(reference.hide_shots[1] and reference.hide_shots[2]),12)


    --     rui.rounded_rectangle(x , y + math_floor( 30 * v.add_y_a), w, h + 10 , 10,10,10,100 * v.alpha * v.add_y_a,5)
    --     renderer.blur(x , y + math_floor( 30 * v.add_y_a) , w , (h + 10) * v.add_y_a)

    --     renderer_text(x + 5, y + math_floor( 30 * v.add_y_a) + 3 , 150,150,150,100 * v.add_y_a * v.alpha ,'-',0,'EXPLOIT')
       
    --     renderer_text(x + 85, y + math_floor( 30 * v.add_y_a) + 3 , 255,255,255,255* v.alpha * v.dt * v.add_y_a,'-',0,'DOUBLE  TAP')
    --     renderer_text(x + 95, y + math_floor( 30 * v.add_y_a) + 3 , 255,255,255,255* v.alpha * v.wait * v.add_y_a,'-',0,'WAITING...')
    --     renderer_text(x + 85, y + math_floor( 30 * v.add_y_a) + 3 , 255,255,255,255* v.alpha * v.hs * v.add_y_a,'-',0,'ON-SHOT AA')

    --     renderer.circle_outline(x + 125, y + math_floor( 30 * v.add_y_a) + 25,25,25,25,255 * v.alpha * v.add_y_a,5,0,360 ,2,1)
    --     renderer.circle_outline(x + 125, y + math_floor( 30 * v.add_y_a) + 25,c[1],c[2],c[3],255 * v.alpha * v.add_y_a,5,0,190*v.dt_shift ,2,1)

    --     renderer_text(x + 110, y + math_floor( 30 * v.add_y_a) + 24, c[1],c[2],c[3],255* v.alpha * v.add_y_a ,'c',0,tickbase..'t')
    --     renderer_text(x + 23, y + math_floor( 30 * v.add_y_a) + 24, 255,255,255,255* v.alpha * v.dt_shift * v.add_y_a ,'bc',0,'Shifted')
    --     renderer_text(x + 30, y + math_floor( 30 * v.add_y_a) + 24, 255,255,255,255* v.alpha * v.lag  * v.add_y_a,'bc',0,'Lag comp.')

    --     --antiaim 

    --     local s = afunc.get_sIndex(entity_get_local_player(),m.ds_builder,'override')
    --     v.exp = anim.new(v.exp,1,0,ui_get(m.ds_builder[s].body_yaw[1]) == 'Jitter',12)
    --     v.stat = anim.new(v.stat,0,1,ui_get(m.ds_builder[s].body_yaw[1]) == 'Jitter',12)

    --     v.ps[1] = anim.new(v.ps[1] ,1,0,s == 1,12)
    --     v.ps[2] = anim.new(v.ps[2] ,1,0,s == 2,12)
    --     v.ps[3] = anim.new(v.ps[3] ,1,0,s == 3,12)
    --     v.ps[4] = anim.new(v.ps[4] ,1,0,s == 4,12)
    --     v.ps[5] = anim.new(v.ps[5] ,1,0,s == 5,12)
    --     v.ps[6] = anim.new(v.ps[6] ,1,0,s == 6,12)

    --     local desync = (math.floor(math.min(math.abs(180 / 3), (entity.get_prop(entity.get_local_player(), "m_flPoseParameter",
    --     11) * (math.abs(180 / 3) * 2) - math.abs(180 / 3)))))

    --     rui.rounded_rectangle(x , y + math_floor( 40 * v.add_y_a) + math_floor( 20 * v.add_y_b)   + 10, w, h + 10 , 10,10,10,100 * v.alpha * v.add_y_b,5)
    --     renderer.blur(x , y + math_floor( 40 * v.add_y_a) + math_floor( 20 * v.add_y_b) + 10, w, math_floor((h + 10)* v.add_y_b))

    --     renderer_text(x + 5, y + math_floor( 40 * v.add_y_a) + math_floor( 20 * v.add_y_b) + 12, 150,150,150,100* v.alpha  * v.add_y_b,'-',0,'ANTI-AIM')
    --     renderer_text(x + 20, y + math_floor( 40 * v.add_y_a) + math_floor( 20 * v.add_y_b)+ 34, 255,255,255,255* v.alpha  * v.add_y_b,'bc',0,'State')

    --     renderer_text(x + 77, y + math_floor( 40 * v.add_y_a) + math_floor( 20 * v.add_y_b) + 12, 255,255,255,255* v.alpha * v.exp * v.add_y_b,'-',0,'EXPERIMENTAL')
    --     renderer_text(x + 105, y + math_floor( 40 * v.add_y_a) + math_floor( 20 * v.add_y_b) + 12, 255,255,255,255* v.alpha * v.stat * v.add_y_b,'-',0,'STATIC')
    
        
    --     renderer_text(x + 100 + math_floor(17 * v.ps[1]) , y  + math_floor( 41 * v.add_y_a) + math_floor( 21 * v.add_y_b) + 34 , c[1],c[2],c[3],255* v.alpha * v.ps[1] * v.add_y_b ,'c',0,'Stand')
    --     renderer_text(x + 100 + math_floor(18 * v.ps[2]), y  + math_floor( 41 * v.add_y_a) + math_floor( 21 * v.add_y_b)+ 34, c[1],c[2],c[3],255* v.alpha * v.ps[2] * v.add_y_b,'c',0,'Move')
    --     renderer_text(x + 100 + math_floor(18 * v.ps[3]), y  + math_floor( 41 * v.add_y_a) + math_floor( 21 * v.add_y_b)+ 34, c[1],c[2],c[3],255* v.alpha * v.ps[3] * v.add_y_b,'c',0,"Duck")
    --     renderer_text(x + 100 + math_floor(6 * v.ps[4]), y  + math_floor( 41 * v.add_y_a) + math_floor( 21 * v.add_y_b)+ 34, c[1],c[2],c[3],255* v.alpha * v.ps[4] * v.add_y_b,'c',0,'Slow-Walk')
    --     renderer_text(x + 100 + math_floor(20 * v.ps[5]), y  + math_floor( 41 * v.add_y_a) + math_floor( 21 * v.add_y_b)+ 34, c[1],c[2],c[3],255* v.alpha * v.ps[5] * v.add_y_b,'c',0,'Air')
    --     renderer_text(x + 100 + math_floor(10 * v.ps[6]), y  + math_floor( 41 * v.add_y_a) + math_floor( 21 * v.add_y_b)+ 34, c[1],c[2],c[3],255* v.alpha * v.ps[6] * v.add_y_b,'c',0,'Air-Duck')
    --     --desync


    --     rui.rounded_rectangle(x , y + math_floor( 40 * v.add_y_a) + math_floor( 40 * v.add_y_b) +  math_floor( 10 * v.add_y_c) + 20, w, h + 10 , 10,10,10,100 * v.alpha * v.add_y_c,5)
    --     renderer.blur(x , y + math_floor( 40 * v.add_y_a) + math_floor( 40 * v.add_y_b) +  math_floor( 10 * v.add_y_c) + 20, w,math_floor((h + 10)* v.add_y_c))
    --     renderer_text(x + 5, y + math_floor( 40 * v.add_y_a) + math_floor( 40 * v.add_y_b) +  math_floor( 10 * v.add_y_c)+ 22, 150,150,150,100* v.alpha * v.add_y_c ,'-',0,'DESYNC')
    --     renderer_text(x + 25, y + math_floor( 40 * v.add_y_a) + math_floor( 40 * v.add_y_b) +  math_floor( 10 * v.add_y_c) + 44, 255,255,255,255* v.alpha * v.add_y_c ,'bc',0,'Amount')
    --     renderer_text(x + 121  , y  + math_floor( 40 * v.add_y_a) + math_floor( 40 * v.add_y_b) +  math_floor( 10 * v.add_y_c) + 45 , c[1],c[2],c[3],255* v.alpha * v.add_y_c  ,'c',0,math_abs(math_floor((desync/60) * 100)) ..'%')


    --     if is_dragging(x , y, w, h ) and not is_dragging_menu() then
	-- 		v.dragging = true
	-- 	elseif not click then
	-- 		v.dragging = false
	-- 	end
    --     run_drag()
    -- end

    uix.hitlog.render = function()
        local sx,sy = client_screen_size()
        local y = sy - ui_get(m.luop_hitlog_addy)

        for k,data in pairs(uix.hitlog.tb) do
                

                data.alpha = anim.new(data.alpha,0,1,data.timer + (data.counter + 0.2) < globals.realtime(),12)
                if gui.table_contain(ui_get(m.luop_vis),'damage info') then
                    local r,g,b,a = data.color.r,data.color.g,data.color.b


                    local _table = {
                        {text =  data.hit_miss,color = {255,255,255,data.alpha * 255},flags = nil,width = 0},
                        {text = data.target_name,color = {r,g,b,data.alpha * 255},flags = nil,width =  0},
                        {text = data.group,color = {255,255,255,data.alpha * 255},flags = nil,width =  0},
                        {text = data.group_idx,color = {r,g,b,data.alpha * 255},flags = nil,width = 0},
                        {text = data.reason,color = {255,255,255,data.alpha * 255},flags = nil,width =  0},
                        {text = data.reason_idx,color = {r,g,b,data.alpha * 255},flags = nil,width =  0},
                        {text = data.damage,color = {255,255,255,data.alpha * 255},flags = nil,width =  0},
                        {text = data.damage_idx,color = {r,g,b,data.alpha * 255},flags = nil,width =  0},
                        {text = data.health,color = {255,255,255,data.alpha * 255},flags = nil,width =  0},
                        {text = data.health_idx,color = {r,g,b,data.alpha * 255},flags = nil,width =  0},
                    }

                    local multitext = function(x,y,_table)
                        for k, v in pairs(_table) do
                            v.color = v.color or {255,255,255,255}
                            v.color[4] = v.color[4] or 255
                            renderer.text(x,y,v.color[1],v.color[2],v.color[3],v.color[4],v.flags,v.width,v.text)
                            local text_size_x,text_size_y = renderer.measure_text(v.flags,v.text)
                            x = x + text_size_x
                        end
                    end
                
                    local measure_multitext = function(flags,_table)
                        local a = 0;
                        for b, c in pairs(_table) do
                            c.flags = c.flags or ''
                            a = a + renderer.measure_text(c.flags, c.text)
                        end
                        return a
                    end

                    local text_sizex = measure_multitext(nil,_table)
                    local _,text_sizey = renderer_measure_text(nil,'','abacv')
                    local counter = anim.counter(text_sizex + 60,data.timer,data.counter)
                    rui.rounded_rectangle(0 +  math_floor(( 15) * data.alpha), y + (40/2 - text_sizey/2), text_sizex + 20, text_sizey + 10 , 10,10,10,100 * data.alpha,5)
                    renderer.blur(0 +  math_floor(( 15) * data.alpha), y + (40/2 - text_sizey/2), (text_sizex  + 20) * data.alpha, (text_sizey + 10) )
                    -- rui.notify( 0 + math_floor((15) * data.alpha),y,text_sizex + 60,45,255 * data.alpha,counter ,data.type,ui_get(m.luop_cmode))
                    -- renderer.text(0 +  math_floor(( 30) * data.alpha) + 15, y + (45/2 - text_sizey/2) + 4, 255, 255, 255, 255 * data.alpha, "", 0, data.text)
                    multitext(0 +  math_floor(( 30) * data.alpha) , y + (40/2 - text_sizey/2) + 4,_table)
                    if data.type == 'success' then
                        renderer.rectangle(0 +  math_floor(( 15) * data.alpha) + 7, y + (40/2 - text_sizey/2) + 4,2,text_sizey + 2,150,255,150,255 * data.alpha)
                    elseif data.type == 'fail' then
                        renderer.rectangle(0 +  math_floor(( 15) * data.alpha) + 7, y + (40/2 - text_sizey/2) + 4,2,text_sizey + 2,255,150,150,255 * data.alpha)
                    end
                end
        

            if data.timer + (data.counter + 1) < globals.realtime() then
                table_remove(uix.notify.tb,k)
            end
            
            y = y + (30 * data.alpha)
        end
    end


    uix.hitlog.miss = function(e)
        if not gui.table_contain(ui_get(m.luop_vis),'damage info') then
            return
        end
        if e == nil then return end

        local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?"}
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local target_name = entity.get_player_name(e.target)
        local reason
        if e.reason == "?" then
            reason = "resolver"
        else
            reason = e.reason
        end

        local message =  "miss "..string.lower(target_name)..", group: "..group..", reason: "..reason
        table.insert(uix.hitlog.tb,{
            hit_miss = "miss ",
            target_name = string.lower(target_name),
            group = " group: ",
            group_idx = group,
            reason = ' reason: ',
            reason_idx = reason,
            damage = "",
            damage_idx  = '',
            health = "",
            health_idx = '',
            alpha = 0,
            timer = globals_realtime(),
            color = {
                r = 255 , g = 150 , b =150
            },
            counter = 4,
            type = 'fail',
        })
    end

    uix.hitlog.hurt = function(e)
        if not gui.table_contain(ui_get(m.luop_vis),'damage info') then
            return
        end

        local attacker_id = client.userid_to_entindex(e.attacker)
        if attacker_id == nil then
            return
        end
    
        if attacker_id ~= entity.get_local_player() then
            return
        end
    
        local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?"}
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local target_id = client.userid_to_entindex(e.userid)
        local target_name = entity.get_player_name(target_id)
        local enemy_health = entity.get_prop(target_id, "m_iHealth")
        local rem_health = enemy_health - e.dmg_health
        if rem_health <= 0 then
            rem_health = 0
        end
    
        local message = "hit " .. string.lower(target_name) .. ", group: " .. group .. " damage: " .. e.dmg_health .. "  health remain: " .. rem_health
        if rem_health <= 0 then
            message = message .. " (death)"
        end

        table.insert(uix.hitlog.tb,{
            hit_miss = "hit ",
            target_name = string.lower(target_name),
            group = " group: ",
            group_idx = group,
            reason = '',
            reason_idx = '',
            damage = " damage: ",
            damage_idx  = e.dmg_health,
            health = " health remain: ",
            health_idx = rem_health,
            alpha = 0,
            timer = globals_realtime(),
            counter = 4,
            color = {
                r = 150 , g = 255 , b =150
            },
            type = 'success',
        })

    end

    uix.notify.render = function()
        local sx,sy = client_screen_size()
        local y = sy - ui_get(m.luop_notify_addy)

        for k,data in pairs(uix.notify.tb) do
            if k > 15 then
                table.remove( uix.notify.tb,k)
            end

            if data.text ~= nil and data.text ~= ' ' then
                local r,g,b,a = 255,255,255,255

                local text_sizex,text_sizey = renderer_measure_text('',nil,data.text)
                local counter = anim.counter(text_sizex + 60,data.timer,data.counter)
                data.alpha = anim.new(data.alpha,0,1,data.timer + (data.counter + 0.2) < globals.realtime(),12)
                if gui.table_contain(ui_get(m.luop_vis),'notification') then

                    rui.notify(sx - math_floor((text_sizex + 65) * data.alpha),y,text_sizex + 60,45,255 * data.alpha,counter ,data.type,ui_get(m.luop_cmode))
                    renderer.text(sx - math_floor((text_sizex + 65) * data.alpha) + 55, y + (45/2 - text_sizey/2), 255, 255, 255, 255 * data.alpha, "", 0, data.text)
                end
            end

            if data.timer + (data.counter + 1) < globals.realtime() then
                table_remove(uix.notify.tb,k)
            end
            
            y = y - (55 * data.alpha)
        end
    end

    uix.notify.paint = function(text,types,counter)
        table.insert(uix.notify.tb,{
            text = text,
            alpha = 0,
            timer = globals_realtime(),
            counter = counter,
            type = types,
        })
    end


    local dys ={}

    ui_set_visible(temp_states,false)

    dys.update_manual = function()
        ui_set(m.manual_left[2], 'On hotkey')
        ui_set(m.manual_right[2], 'On hotkey')
        ui_set(m.manual_reset[2], 'On hotkey')
        ui_set_visible(temp_states, false)
    
        local m_state = ui_get(temp_states)
        local left_state, right_state, backward_state = ui_get(m.manual_left[2]), ui_get(m.manual_right[2]), ui_get(m.manual_reset[2])
        local edge_on_key = ui_get(m.edge_yaw[2])
    
        ui_set(reference.edge_yaw, edge_on_key and true or false)
    
        if ui_get(m.freestanding[2]) then
            m.freestanding[1] = true
            ui_set(reference.freestanding[1], true)
            ui_set(reference.freestanding[2], 'Always on')
            return
        else
            ui_set(reference.freestanding[1], false)
            m.freestanding[1] = true
        end
    
        if left_state == m.manual_left[1] and right_state == m.manual_right[1] and backward_state == m.manual_reset[1] then return end
        m.manual_left[1], m.manual_right[1], m.manual_reset[1] = left_state, right_state, backward_state
    
        if left_state and m_state == 1 or right_state and m_state == 2 or backward_state and m_state == 3 then
              ui_set(temp_states, 0)
              return
        end
    
        if left_state and m_state ~= 1 then ui_set(temp_states, 1) end
        if right_state and m_state ~= 2 then ui_set(temp_states, 2) end
        if backward_state and m_state ~= 3 then ui_set(temp_states, 3) end
    end

    local gamerules_ptr = client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")
    local gamerules = ffi.cast("intptr_t**", ffi.cast("intptr_t", gamerules_ptr) + 2)[0]

    dys.roll = function(cmd)
        local get_trusted = function(status)
            local is_valve_ds = ffi.cast('bool*', gamerules[0] + 124)
            if is_valve_ds ~= nil then
                is_valve_ds[0] = status
            end
        end

        local body_lean = function(cmd,status)

            if (entity_get_prop(entity_get_local_player(), "m_MoveType") or 0) == 9 then --ladder fix
                return
            end
        
            local desync_amount = antiaim_funcs.get_desync(2)
            if desync_amount == nil then
                return
            end

            if math.abs(desync_amount) < 15 or cmd.chokedcommands == 0 then
                return
            end

            cmd.in_forward = status
        end

        if gui.table_contain(ui_get(m.semi_builder.roll[1]),'Extend') then
            body_lean(cmd,1)
        else
            body_lean(cmd,0)
        end
    

        if gui.table_contain(ui_get(m.semi_builder.roll[1]),'Matchmaking') then
            get_trusted(1)
        else
            get_trusted(0)
        end


        cmd.roll = 
        (gui.table_contain(ui_get(m.semi_builder.roll[1]),'Disable roll when peeking') and 
        ui_get(reference.quick_peek_assist[1]) and ui_get(reference.quick_peek_assist[2])) and 0 or
        (ui_get(gui.table_contain(ui_get(m.semi_builder.roll[1]),'Untrust') and m.semi_builder.roll[2] or m.semi_builder.roll[3]))
    end

    
    dys.data = {
        pitch = {'Default',0},
        yaw_base = 'Local view',
        yaw = {'180',0},
        yaw_jitter = {'Off',0},
        body_yaw = {'Static',0},
        freestand_yaw = false 
    }


    dys.setup_command = function(cmd)
        local s_override = ui_get(m.ds_switch)

     
        local a = dys.data


        dys.update_manual()
        --antiaim funcs start 

        local manual_state = ui_get(temp_states)
        local manual_offset = ({ 
            [1] = gui.table_contain(ui_get(m.manual_options),'force 90°') and -90 or -70, 
            [2] = gui.table_contain(ui_get(m.manual_options),'force 90°') and 90 or 110, 
        })[manual_state]

        local s = afunc.get_sIndex(entity_get_local_player(),m.ds_builder,'override')

        if ui_get(m.ds_mswitch) == 'rage' then

            if ui_get(m.ds_mode) == 'builder' then
                
                if ui_get(m.legit_aa) then
                    afunc.on_use(cmd)
                    a.pitch[1] = 'Off'
                    a.yaw[1] = 'Off'
                    a.yaw_jitter[1] = 'Off'
                    a.body_yaw[1] = 'Static'
                    a.body_yaw[2] = -180
                    a.freestand_yaw = true
                else

                    if not s_override then
                        return 
                    end
            

                    a.pitch[1] = ui_get(m.ds_builder[s].pitch[1])
                    a.pitch[2] = ui_get(m.ds_builder[s].pitch[2])
                    a.yaw[1] = ui_get(m.ds_builder[s].yaw[1])
                    a.yaw[2] = 
                    (ui_get(m.ds_builder[s].yaw[2]) == 'experimental' and 
                    afunc.get_jitter(
                        ui_get(m.ds_builder[s].yaw[5]),
                        ui_get(m.ds_builder[s].yaw[4]),
                        ui_get(m.ds_builder[s].yaw[3])
                    ))or 
                    ui_get(m.ds_builder[s].yaw[3])
                    a.yaw_jitter[1] = ui_get(m.ds_builder[s].yaw_jitter[1])
                    a.yaw_jitter[2] = 
                    (ui_get(m.ds_builder[s].yaw_jitter[2]) == 'experimental' and 
                    afunc.get_jitter(
                        ui_get(m.ds_builder[s].yaw_jitter[4]),
                        ui_get(m.ds_builder[s].yaw_jitter[5]),
                        ui_get(m.ds_builder[s].yaw_jitter[3])
                    ))or 
                    ui_get(m.ds_builder[s].yaw_jitter[3])

                    a.body_yaw[1] = ui_get(m.ds_builder[s].body_yaw[1])
                    a.body_yaw[2] = 
                    (ui_get(m.ds_builder[s].body_yaw[2]) == 'experimental' and 
                    afunc.get_jitter(
                        ui_get(m.ds_builder[s].body_yaw[4]),
                        ui_get(m.ds_builder[s].body_yaw[5]),
                        ui_get(m.ds_builder[s].body_yaw[3])
                    ))or 
                    ui_get(m.ds_builder[s].body_yaw[3])

                    a.freestand_yaw = ui_get(m.ds_builder[s].body_yaw[6])
                end

            end

            dys.data.yaw_base = (manual_state == 0 or manual_state == 3 and not ui_get(m.legit_aa)) and 'At targets' or 'Local view'
            dys.data.yaw[2] = (manual_state == 0 or manual_state == 3) and dys.data.yaw[2] or manual_offset
            dys.data.yaw_jitter[1] = (gui.table_contain(ui_get(m.manual_options),'static') and manual_state ~= 0) and 'Off' or dys.data.yaw_jitter[1]
            dys.data.body_yaw[1] = (gui.table_contain(ui_get(m.manual_options),'static') and manual_state ~= 0) and 'Off' or dys.data.body_yaw[1]

        elseif ui_get(m.ds_mswitch) == 'semi-rage' then
            afunc.on_use(cmd)
            a.pitch[1] = ui_get(m.semi_builder.pitch[1])
            a.pitch[2] = ui_get(m.semi_builder.pitch[2])
            a.yaw_base = ui_get(m.semi_builder.yaw_base)
            a.yaw[1] = ui_get(m.semi_builder.yaw[1])
            a.yaw[2] = ui_get(m.semi_builder.yaw[2])
            a.yaw_jitter[1] = ui_get(m.semi_builder.yaw_jitter[1])
            a.yaw_jitter[2] = ui_get(m.semi_builder.yaw_jitter[2])
            a.body_yaw[1] = ui_get(m.semi_builder.body_yaw[1])
            a.body_yaw[2] = ui_get(m.invert_key) and (180 or -180) or ui_get(m.semi_builder.body_yaw[2])
            a.freestand_yaw = ui_get(m.semi_builder.body_yaw[3])
            dys.roll(cmd)
        end
            


        ui_set(reference.enabled,ui_get(m.ds_switch))
        ui_set(reference.pitch[1],a.pitch[1])
        ui_set(reference.pitch[2],a.pitch[2])
        ui_set(reference.yaw_base,a.yaw_base)
        ui_set(reference.yaw[1],a.yaw[1])
        ui_set(reference.yaw[2],a.yaw[2])
        ui_set(reference.yaw_jitter[1],a.yaw_jitter[1])
        ui_set(reference.yaw_jitter[2],a.yaw_jitter[2])
        ui_set(reference.body_yaw[1],a.body_yaw[1])
        ui_set(reference.body_yaw[2],a.body_yaw[2])
        ui_set(reference.freestanding_body_yaw,a.freestand_yaw)

        local set_og_menu = function(state)
            ui_set_visible(reference.pitch[1], state)
            ui_set_visible(reference.pitch[2], state)
            ui_set_visible(reference.yaw_base, state)
            ui_set_visible(reference.yaw[1], state)
            ui_set_visible(reference.yaw[2], state)
            ui_set_visible(reference.yaw_jitter[1], state)
            ui_set_visible(reference.yaw_jitter[2], state)
            ui_set_visible(reference.body_yaw[1], state)
            ui_set_visible(reference.body_yaw[2], state)
            ui_set_visible(reference.freestanding_body_yaw, state)
            ui_set_visible(reference.edge_yaw, state)
            ui_set_visible(reference.freestanding[1], state)
            ui_set_visible(reference.freestanding[2], state)
            ui_set_visible(reference.roll, state)
         end
            
        set_og_menu(not ui_get(m.ins))

    end


    local misc = {}

    misc.antik = function()
        local get_distance = function(x1, y1, z1, x2, y2, z2)
            return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
        end

        if gui.table_contain(ui_get(m.misc_options),'anti-knife') then
            local players = entity.get_players(true)
            local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
            local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
            local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
    
            for i=1, #players do
                local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
                local distance = get_distance(lx, ly, lz, x, y, z)
                local weapon = entity.get_player_weapon(players[i])
                if entity.get_classname(weapon) == "CKnife" and distance <= ui_get(m.misc_antidis) then
                    ui.set(yaw_slider,180)
                end
            end
        end
    end

    local gts,et = 0,0
    misc.anim = function()
        if gui.table_contain(ui_get(m.misc_options),'animation breaker') then
            if not entity.is_alive(entity.get_local_player()) then return end

            if gui.table_contain(ui_get(m.misc_animbreak),'in air') then 
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
            end
               
            if gui.table_contain(ui_get(m.misc_animbreak),'on land') then
                local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
                if on_ground == 1 then
                    gts = gts + 1
                else
                    gts = 0
                    et = globals.curtime() + 1
                end 
            
                if gts > ui.get(reference.fake_lag_limit) + 1 and et > globals.curtime() then
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
                end
            end 
            local legs_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
        
            if gui.table_contain(ui_get(m.misc_animbreak),'leg fucker') then
                ui.set(reference.leg_movement, legs_types[2])
                entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 8, 0)
            end
        end
    end

    set_visible()
    uix.notify.paint('Fininshed all callback , thanks for using Hyperion.lua. v1.0.0','success',3)


    uix.notify.paint('Type "./explain" to get help with config anti-aim.','warn',5)
    uix.notify.paint('Type "./help" to get command list.','warn',5)

    
 
    local events = {
        on_console_input = function (e)

            if not ui_get(m.ins) then
                return
            end

            if string_find(e,"./import config") then
                client_exec("playvol buttons/arena_switch_press_02 1")
                gui.load(exp_call,clipboard.get())
                uix.notify.paint('Config loaded from clipboard.','success',3)
                logs('Config loaded.')
            elseif string_find(e,"./export config") then
                clipboard.set(gui.exp(exp_call))
                logs('Config exported to your clipboard.')
                client_exec("playvol buttons/arena_switch_press_02 1")
                uix.notify.paint('Config exported to your clipboard.','success',3)

            elseif string_find(e,"./import aaconfig") then
                gui.load(aa_exp,clipboard.get())
                logs('AA Config loaded.')
                uix.notify.paint('AA Config loaded to your clipboard.','success',3)
                client_exec("playvol buttons/arena_switch_press_02 1")
            elseif string_find(e,"./export aaconfig") then
                clipboard.set(gui.exp(aa_exp))
                logs('AA Config exported to your clipboard.')
                uix.notify.paint('AA Config exported to your clipboard.','success',3)
                client_exec("playvol buttons/arena_switch_press_02 1")
            elseif string_find(e,"./help") then
                client_exec("playvol buttons/arena_switch_press_02 1")
                client_color_log(255, 255, 255, " ")
                client_color_log(255, 255, 255, " ")
                client_color_log(255, 255, 255, "|-------------Hyperion-------------|")
                client_color_log(0, 150, 255, 	"            Command List           ")
                client_color_log(150, 150, 255, 	'   [1] "./import config" : load config from clipboard.')
                client_color_log(150, 150, 255, 	'   [2] "./export config" : export config to your clipboard.')
                client_color_log(150, 150, 255, 	'   [3] "./import aaconfig" : load aa config from clipboard.')
                client_color_log(150, 150, 255, 	'   [4] "./export aaconfig" : export aa config to your clipboard.')
                client_color_log(150, 150, 255, 	'   [5] "./explain" : anti-aim info.')
                client_color_log(150, 150, 255, 	'   [6] "./auto" : auto config.')
                client_color_log(150, 150, 255, 	'   [7] "./help" : get command list.')
                client_color_log(255, 255, 255, "|-------------Hyperion-------------|")
                client_color_log(255, 255, 255, " ")
                client_color_log(255, 255, 255, " ")
            elseif string_find(e,"./explain") then
                client_exec("playvol buttons/arena_switch_press_02 1")
                client_color_log(255, 255, 255, " ")
                client_color_log(255, 255, 255, " ")
                client_color_log(255, 255, 255, "|-------------Hyperion-------------|")
                client_color_log(0, 150, 255, 	"            Anti-aim info           ")
                client_color_log(150, 150, 255, 	'   "experimental mode" : switch angles by body yaw angles L/R.')
                client_color_log(150, 150, 255, 	'   "experimental mode[1]" : center dir.: change the center degree of L/R.')
                client_color_log(150, 150, 255, 	'   "experimental mode[2]" : L/R: change the L/R angles, will switch by body yaw angles.')
                client_color_log(255, 105, 105, 	'   "experimental mode[3]" : WARN: Special body angles may cause AA errors!')
                client_color_log(255, 255, 255, "|-------------Hyperion-------------|")
                client_color_log(255, 255, 255, " ")
                client_color_log(255, 255, 255, " ")
            elseif string_find(e,"./auto") then
                client_exec("playvol buttons/arena_switch_press_02 1")
               

                http.get('https://gitee.com/AslierGod/demon-sense/raw/master/BounceHWID',function(s,r)
                    
                    if not s or r.status ~= 200 then
                        logs('Failed to get cloud config')
                        uix.notify.paint('Failed to get cloud config','fail',5)
                        return
                    end
                    logs('Auto config success.')

                    uix.notify.paint('Get latest config from cloud!','success',5)
                    gui.load(exp_call,r.body)
                end)

            elseif string_find(e,"./") then
                client_exec("playvol ui\\weapon_cant_buy.wav 1")
                local rs, gs,bs,as = 150,200,60 ,255
                color_utils:log(
                    { { 248,248,248}, {102,102,102 }, "Hyperion" },
                    { { 100, 100, 100 }, " >> "},
                    { { 255,100,100 }, 'Unknown commnd,type "./help" to get command list.',true }
                )

                uix.notify.paint('Unknown commnd,type "./help" to get command list.','fail',5)

            end
        end,


        setup_command = function(cmd)

            if not ui_get(m.ins) then
                return
            end

            dys.setup_command(cmd)
            misc.antik()
        end,

        paint_ui = function ()
            local set_og_menu = function(state)
                ui_set_visible(reference.pitch[1], state)
                ui_set_visible(reference.pitch[2], state)
                ui_set_visible(reference.yaw_base, state)
                ui_set_visible(reference.yaw[1], state)
                ui_set_visible(reference.yaw[2], state)
                ui_set_visible(reference.yaw_jitter[1], state)
                ui_set_visible(reference.yaw_jitter[2], state)
                ui_set_visible(reference.body_yaw[1], state)
                ui_set_visible(reference.body_yaw[2], state)
                ui_set_visible(reference.freestanding_body_yaw, state)
                ui_set_visible(reference.edge_yaw, state)
                ui_set_visible(reference.freestanding[1], state)
                ui_set_visible(reference.freestanding[2], state)
                ui_set_visible(reference.roll, state)
             end
             
            set_og_menu(not ui_get(m.ins))



            fake_lag.set()
            uix.on_load()
            if not ui_get(m.ins) then
                return
            end

            uix.top_bar()
            uix.notify.render()
            -- uix.status()
        end,

        on_aim_miss = function(e)
            uix.hitlog.miss(e)
        end,

        on_player_hurt = function(e)
            uix.hitlog.hurt(e)
        end,

        on_player_death = function(e)
            if client.userid_to_entindex(e.userid) == entity.get_local_player() then
                uix.notify.paint('Reseted data due to death','warn',5)
            end
        end,

        on_round_start = function(e)
            if entity.get_local_player() == nil then
                return
            end
            uix.notify.paint('Reseted data due to round start','success',7)
        end,
        on_game_newmap = function(e)
            if entity.get_local_player() == nil then
                return
            end
            uix.notify.paint('Reseted data due to change map','success',7)
        end,
        on_client_disconnect = function()
            -- uix.notify.paint('Disconnected to the server','warn',10)
        end,

        on_shut_down = function()
            fake_lag.fn(true)

            local set_og_menu = function(state)
                ui_set_visible(reference.pitch[1], state)
                ui_set_visible(reference.pitch[2], state)
                ui_set_visible(reference.yaw_base, state)
                ui_set_visible(reference.yaw[1], state)
                ui_set_visible(reference.yaw[2], state)
                ui_set_visible(reference.yaw_jitter[1], state)
                ui_set_visible(reference.yaw_jitter[2], state)
                ui_set_visible(reference.body_yaw[1], state)
                ui_set_visible(reference.body_yaw[2], state)
                ui_set_visible(reference.freestanding_body_yaw, state)
                ui_set_visible(reference.edge_yaw, state)
                ui_set_visible(reference.freestanding[1], state)
                ui_set_visible(reference.freestanding[2], state)
                ui_set_visible(reference.roll, state)
             end
             
            set_og_menu(true)
        end,

        on_pre_render = function()
            misc.anim()
        end,

        paint = function ()
            uix.crosshair()
            uix.hitlog.render()
        end
    }
    client_set_event_callback('player_death',events.on_player_death)
    client_set_event_callback('round_start',events.on_round_start)
    client_set_event_callback('game_newmap',events.on_game_newmap)
    client_set_event_callback('client_disconnect',events.on_client_disconnect)
    client_set_event_callback('console_input',events.on_console_input)
    client_set_event_callback('paint_ui',events.paint_ui)
    client_set_event_callback('paint',events.paint)
    client_set_event_callback('setup_command',events.setup_command)
    client_set_event_callback('shutdown',events.on_shut_down)
    client_set_event_callback('aim_miss',events.on_aim_miss)
    client_set_event_callback('player_hurt',events.on_player_hurt)
    client_set_event_callback('pre_render',events.on_pre_render)

    gui._call(reg_call,set_visible)

end

local checkIsDown
local check = false
checkIsDown = function()
    local rd_files = {
        'csgo\\filesystem.lua',
        'csgo\\hyp_release\\animate.lua',
        'csgo\\hyp_release\\antiaim_funcs.lua',
        'csgo\\hyp_release\\color_utils.lua',
        'csgo\\hyp_release\\entity.lua',
        'csgo\\hyp_release\\gui.lua',
        'csgo\\hyp_release\\reference.lua',
        ''
    }
    
    if readfile('csgo\\filesystem.lua') == nil or  
        readfile('csgo\\hyp_release\\animate.lua') == nil or 
        readfile('csgo\\hyp_release\\antiaim_funcs.lua') == nil or
        readfile('csgo\\hyp_release\\color_utils.lua') == nil or
        readfile('csgo\\hyp_release\\entity.lua') == nil or
        readfile('csgo\\hyp_release\\gui.lua') == nil or
        readfile('csgo\\hyp_release\\reference.lua') == nil or
        readfile('csgo\\hyp_release\\render_ui.lua') == nil then
        client.delay_call(5, checkIsDown)
        check = false
    else

    
      
        client.color_log(100,255,100,"[Hyperion] All library checked.")
        check = true
        
    end
    if check == true then

        __init()
    end
end
local thread = coroutine.create(download)
local isDown = coroutine.create(checkIsDown)
local s ,r  = coroutine.resume(thread)
local s1 ,r1  = coroutine.resume(isDown)
