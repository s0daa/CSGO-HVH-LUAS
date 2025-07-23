-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

--[[
    pastel
]]
local username = common.get_username()
local ffi = require("ffi")
local gradient = require ("neverlose/gradient");
 ffi.cdef[[
    typedef struct{
     void*   handle;
     char    name[260];
     int     load_flags;
     int     server_count;
     int     type;
     int     flags;
     float   mins[3];
     float   maxs[3];
     float   radius;
     char    pad[0x1C];
 } model_t;
 typedef struct {void** this;}aclass;
 typedef void*(__thiscall* get_client_entity_t)(void*, int);
 typedef void(__thiscall* find_or_load_model_fn_t)(void*, const char*);
 typedef const int(__thiscall* get_model_index_fn_t)(void*, const char*);
 typedef const int(__thiscall* add_string_fn_t)(void*, bool, const char*, int, const void*);
 typedef void*(__thiscall* find_table_t)(void*, const char*);
 typedef void(__thiscall* full_update_t)();
 typedef int(__thiscall* get_player_idx_t)();
 typedef void*(__thiscall* get_client_networkable_t)(void*, int);
 typedef void(__thiscall* pre_data_update_t)(void*, int);
 typedef int(__thiscall* get_model_index_t)(void*, const char*);
 typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
 typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
 typedef void(__thiscall* set_model_index_t)(void*, int);
 typedef int(__thiscall* precache_model_t)(void*, const char*, bool);
]]
local a = ffi.cast(ffi.typeof("void***"), utils.create_interface("client.dll", "VClientEntityList003")) or error("rawientitylist is nil", 2)
local b = ffi.cast("get_client_entity_t", a[0][3]) or error("get_client_entity is nil", 2)
local c = ffi.cast(ffi.typeof("void***"), utils.create_interface("engine.dll", "VModelInfoClient004")) or error("model info is nil", 2)
local d = ffi.cast("get_model_index_fn_t", c[0][2]) or error("Getmodelindex is nil", 2)
local e = ffi.cast("find_or_load_model_fn_t", c[0][43]) or error("findmodel is nil", 2)
local f = ffi.cast(ffi.typeof("void***"), utils.create_interface("engine.dll","VEngineClientStringTable001")) or error("clientstring is nil", 2)
local g = ffi.cast("find_table_t", f[0][3]) or error("find table is nil", 2)
function p(pa)
    local a_p = ffi.cast(ffi.typeof("void***"), g(f, "modelprecache"))
    if a_p~= nil then
        e(c, pa)
        local ac = ffi.cast("add_string_fn_t", a_p[0][8]) or error("ac nil", 2)
        local acs = ac(a_p, false, pa, -1, nil)
        if acs == -1 then print("failed")
            return false
        end
    end
    return true
end
function smi(en, i)
    local rw = b(a, en)
    if rw then
        local gc = ffi.cast(ffi.typeof("void***"), rw)
        local se = ffi.cast("set_model_index_t", gc[0][75])
        if se == nil then
            error("smi is nil")
        end
        se(gc, i)
    end
end
function cm(ent, md)
    if md:len() > 5 then
        if p(md) == false then
            error("invalid model", 2)
        end
        local i = d(c, md)
        if i == -1 then
            return
        end
        smi(ent, i)
    end
end

local dl_files = {}
dl_files.urlmon = ffi.load('UrlMon')
dl_files.wininet = ffi.load('WinInet')
dl_files.download_file_from_url = function(from, to)
dl_files.wininet.DeleteUrlCacheEntryA(from)
dl_files.urlmon.URLDownloadToFileA(nil, from, to, 0, 0)
end


files.create_folder('csgo\\materials\\models\\player\\custom_player')


events.render:set(function()
    local gradient_animation = gradient.text_animate("Model Changer", -0.9, {
        color(255,255,255),
        color(115,150,0)
    })

    ui.sidebar(gradient_animation:get_animated_text(), "\a739600FF" .. ui.get_icon("stream"))
    gradient_animation:animate()
end)

ui.create(" ")
local main = ui.create("Model Changer")
local en = main:switch("Enabled", false)
local custom = main:input("Custom", "")

en:tooltip("without enabled switch you can't change model! ;)")

local curak = ui.create(" ")
local info_text = curak:label("MODELS")
local zasranycurak = curak:button("Export (in console)" , function ()
    utils.execute_after(0.2, function()
        common.add_notify("\affffffFFModel \a739600FFChanger", "" .. username .. " check console!")
    end)

        files.create_folder('nl\\model changer')

        print_raw("\a739600|Model Changer| \aDEFAULTCounter-Strike Global Offensive/nl/model changer/models.txt")
end, true)

local info_text = curak:label("")

link_open = function(link)
    local steam_overlay_API = panorama.SteamOverlayAPI
    local open_external_browser_url = steam_overlay_API.OpenExternalBrowserURL
    open_external_browser_url(link)
end

local links_dl_font = curak:button("                     Download models (raz)                    ", function()
    common.add_notify("\affffffFFModel \a739600FFChanger", "models downloaded!")
    print_raw("\a739600|Model Changer| \aDEFAULTDownloaded")
    link_open('https://cdn.discordapp.com/attachments/827622765627441183/1078079221785710683/raz_models.zip')
    local read = files.read("nl\\model changer")
        if read == nil then dl_files.download_file_from_url('https://cdn.discordapp.com/attachments/858315717861965825/1082282495820705873/models.txt'
        , "nl\\model changer\\models.txt")
    end
end, true)

curak:button("                                       clear                                       " , function ()
    utils.console_exec("clear")
end, true)

events.net_update_end:set(function()

    local lp = entity.get_local_player()
    if lp==nil then return end
    if globals.is_in_game and lp:is_alive() then
        if en:get() then
            cm(lp:get_index(), custom:get())
        end
    end
end)