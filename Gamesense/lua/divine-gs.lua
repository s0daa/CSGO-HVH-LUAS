-- downloaded from dsc.gg/southwestcfgs

local clipboard     = require "gamesense/clipboard"
local base64        = require"gamesense/base64"
local ffi           = require"ffi"
local http          = require "gamesense/http"
local c_entity = require("gamesense/entity")
local vector        = require "vector"
local csgo_weapons  = require "gamesense/csgo_weapons"
local ease          = require "gamesense/easing"
local anti_aim      = require "gamesense/antiaim_funcs"
local trace         = require "gamesense/trace"
local images        = require "gamesense/images"
local surface = require 'gamesense/surface'
local js = panorama.open()
local persona_api = js.MyPersonaAPI

local obex_data = obex_fetch and obex_fetch() or {username = 'kay', build = 'Source', discord=''}

local div = {}
local logprefix = "\aFFFFFF[\aB0CEFFdivine\aFFFFFF] "
local printc do
    ffi.cdef[[
        typedef struct { uint8_t r; uint8_t g; uint8_t b; uint8_t a; } color_struct_t;
    ]]

	local print_interface = ffi.cast("void***", client.create_interface("vstdlib.dll", "VEngineCvar007"))
	local color_print_fn = ffi.cast("void(__cdecl*)(void*, const color_struct_t&, const char*, ...)", print_interface[0][25])

    -- 
    local hex_to_rgb = function (hex)
        return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16), tonumber(hex:sub(7, 8), 16)
    end
	
	local raw = function(text, r, g, b, a)
		local col = ffi.new("color_struct_t")
		col.r, col.g, col.b, col.a = r or 217, g or 217, b or 217, a or 255
	
		color_print_fn(print_interface, col, tostring(text))
	end

	printc = function (...)
		for i, v in ipairs{...} do
			local r = "\aD9D9D9"..v
			for col, text in r:gmatch("\a(%x%x%x%x%x%x)([^\a]*)") do
				raw(text, hex_to_rgb(col))
			end
		end
		raw "\n"
	end
end

local draw_logs = function()
    local name = {
"        .                                              ",
"        :i ..                                           ",
"        ,i :,                                           ",
"        :i.,,             :,.                           ",
"        ,r,,i             :i:i,.                        ",
"        ,;::i:            ii::iii:,                     ",
"        .rii:;,           i;:i:ii;;;:.",
"        .7;i;;r,          ;;;i;i;iii;7;",
"        .X;;;;;Xi         ;r;;;r;;;;;r;X,            7MM```Yb. `7MMF``7MMF'   `7MF``7MMF``7MN.   `7MF'`7MM```YMM     `7MMF'    `7MMF'   `7MF'    db",
"        .77rrrrrSr.       r7r;r;rrrrrrrrS:            MM    `Yb. MM    `MA     ,V    MM    MMN.    M    MM    `7       MM        MM       M     ;MM:",
"         S77r7r7rXXr.     7X777777r7r7r77S.           MM     `Mb MM     VM:   ,V     MM    M YMb   M    MM   d         MM        MM       M    ,V^MM.",
"        .2X7X7X7X7XS27i   XSX7X777X7X7X7XSX           MM      MM MM      MM.  M'     MM    M  `MN. M    MMmmMM         MM        MM       M   ,M  `MM",
"         22XXXXXXXXXX22aXiXZa2SSXXXXXXXXXS2           MM     ,MP MM      `MM A'      MM    M   `MM.M    MM   Y  ,      MM      , MM       M   AbmmmqMA",
"         78SSXSXSXSXSSSSZZ. 7aZZ2SSXSXSSSSZi          MM    ,dP' MM       :MM;       MM    M     YMM    MM     ,M ,,   MM     ,M YM.     ,M  A'     VML",
"         .ZZS2SSS2S2S2S228    .XZ8a2SSSSS2Z;        .JMMmmmdP' .JMML.      VF      .JMML..JML.    YM  .JMMmmmmMMM db .JMMmmmmMMM  `bmmmmd`'.AMA.   .AMMA.",
"          7BZa22a2a2a2a2Z8.      700Z2a22a0i",
"           XWBZZaZaaaZaZZB.        aW8ZZZZ0;",
"            ;BW88ZZZZZZZ8B.         7WBZZZWi",
"              SW@WB8Z8Z88@           ;@BZ0Wi",
"                78MM@BB0BM.           7@BB@i            ",
"                   ;Z@MMMM.            8MWMi            ",
"                      .X@Mi            .MMMi            ",
"                         .              BMM;            ",
"                                        ZMMr            ",
"                                        rMMi             "                                                                                                                                                                                                      

    }

    client.exec("clear")
	
    for _, line in pairs(name) do
        printc("\aB0CEFF"..line) 
        --client.color_log(255 / 6 * _, 8 / 6 * _, 5/ 6 * _, line)
    end


    client.exec("con_filter_enable 1")
    client.exec("con_filter_text IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
end
draw_logs()

div.database = {
    configs = ":divine_solutions::cfg:",
    locations = ":divine_solutions::locations:"
}

div.presets = {}

div.locations = database.read(div.database.locations) or {}

div.handlers      = {
    ui              = {
        elements    = {},
        config      = {}
    }
}
function contains(t, v)
    for i, vv in pairs(t) do
        if vv == v then
            return true
        end
    end
    return false
end

div.handlers.ui.new = function(element, config)
    config = config or false
    
    table.insert(div.handlers.ui.elements, {element = element})
    if config then
        table.insert(div.handlers.ui.config, element)
    end

    return element
end

split = function(string, sep)
    local result = {}
    for str in (string):gmatch("([^"..sep.."]+)") do
        table.insert(result, str)
    end
    return result
end
function get_config(name)
    local database = database.read(div.database.configs) or {}

    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    for i, v in pairs(div.presets) do
        if v.name == name then
            return {
                config = base64.decode(v.config),
                index = i
            }
        end
    end

    return false
end
function save_config(name)
    local db = database.read(div.database.configs) or {}
    local config = {}

    if name:match("[^%w]") ~= nil then
        return
    end

    for _, v in pairs(div.handlers.ui.config) do
        local val = ui.get(v)

        if type(val) == "table" then
            if #val > 0 then
                val = table.concat(val, "|")
            else
                val = nil
            end
        end

        table.insert(config, tostring(val))
    end

    local cfg = get_config(name)

    if not cfg then
        table.insert(db, { name = name, config = table.concat(config, ":") })
    else
        db[cfg.index].config = table.concat(config, ":")
    end

    database.write(div.database.configs, db)
end
function delete_config(name)
    local db = database.read(div.database.configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            table.remove(db, i)
            break
        end
    end

    for i, v in pairs(div.presets) do
        if v.name == name then
            return false
        end
    end

    database.write(div.database.configs, db)
end
function get_config_list()
    local database = database.read(div.database.configs) or {}
    local config = {}
    local presets = div.presets

    for i, v in pairs(presets) do
        table.insert(config, v.name)
    end

    for i, v in pairs(database) do
        table.insert(config, v.name)
    end

    return config
end
function config_tostring()
    local config = {}
    for _, v in pairs(div.handlers.ui.config) do
        local val = ui.get(v)
        if type(val) == "table" then
            if #val > 0 then
                val = table.concat(val, "|")
            else
                val = nil
            end
        end
        table.insert(config, tostring(val))
    end

    return table.concat(config, ":")
end
function load_settings(config)
    local type_from_string = function(input)
        if type(input) ~= "string" then return input end

        local value = input:lower()

        if value == "true" then
            return true
        elseif value == "false" then
            return false
        elseif tonumber(value) ~= nil then
            return tonumber(value)
        else
            return tostring(input)
        end
    end

    config = split(config, ":")

    for i, v in pairs(div.handlers.ui.config) do
        if string.find(config[i], "|") then
            local values = split(config[i], "|")
            ui.set(v, values)
        else
            ui.set(v, type_from_string(config[i]))
        end
    end
end
function export_settings()
    local config = config_tostring()
    local encoded = base64.encode(config)
    clipboard.set(encoded)
   
end
function import_settings()
    local config = clipboard.get()
    local decoded = base64.decode(config)
    load_settings(decoded)
end
function load_config(name)
    local config = get_config(name)
    load_settings(config.config)
    
end

local rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end
function lerp(a, b, t)
    return a + (b - a) * t
end
function clamp(x, minval, maxval)
    if x < minval then
        return minval
    elseif x > maxval then
        return maxval
    else
        return x
    end
end
local function text_fade_animation(x, y, speed, color1, color2, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10  
        local wave = math.cos(2 * speed * curtime / 4 + x / 100)
        local color = rgba_to_hex(
            lerp(color1.r, color2.r, clamp(wave, 0, 1)),
            lerp(color1.g, color2.g, clamp(wave, 0, 1)),
            lerp(color1.b, color2.b, clamp(wave, 0, 1)),
            color1.a
        ) 
        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
    end
    
    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, "c-", nil, final_text .. "°")
end
local function in_air(player)
    local flags = entity.get_prop(player, "m_fFlags")
    
    if bit.band(flags, 1) == 0 then
        return true
    end
    
    return false
end

local refs_aa = {
	enable = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
    yawjitter = { ui.reference("AA", "Anti-aimbot angles", "yaw jitter") },
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
	yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    freestand = { ui.reference("AA", "anti-aimbot angles", "freestanding") },
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
    slow = { ui.reference("AA", "Other", "Slow motion") },
}

local ref = {
    fd = ui.reference("Rage", "Other", "Duck peek assist"),
    qp = {ui.reference("Rage", "Other", "Quick peek assist")},
    qpm = ui.reference('Rage', 'Other', 'Quick peek assist mode'),
    dt = {ui.reference("Rage", "Aimbot", "Double Tap")},
    baim = {ui.reference("Rage", "Aimbot", "Force body aim")},
    safe = {ui.reference("Rage", "Aimbot", "Force safe point")},
    dt_fl = ui.reference("Rage", "Aimbot", "Double tap fake lag limit"),
    hs = {ui.reference("AA", "Other", "On shot anti-aim")},
    silent = ui.reference("Rage", "Other", "Silent aim"),
    slow_motion = {ui.reference("AA", "Other", "Slow motion")},
    ping = {ui.reference("MISC", "Miscellaneous", "Ping spike")}
}
local m_iJitterTick = 0

local mindmg = ui.reference("rage", "aimbot", "minimum damage")
local mindmgoverride, key, slider = ui.reference("rage", "aimbot", "minimum damage override")
legsref = ui.reference("AA", "Other", "Leg movement")

antiaim = {}


local var1 = {
    player_states = {"ct-lowvel", "ct-walk", "ct-aerobic", "ct-aerial", "ct-duck", "ct-slowwalk", "ct-fakelag", "ct-fakecrouch"},
    player_states_idx = {["ct-lowvel"] = 1, ["ct-walk"] = 2, ["ct-aerobic"] = 3, ["ct-aerial"] = 4, ["ct-duck"] = 5, ["ct-slowwalk"] = 6, ["ct-fakelag"] = 7, ["ct-fakecrouch"] = 8},
    p_state = 0
}

local var = {
    player_states = {"t-lowvel", "t-walk", "t-aerobic", "t-aerial", "t-duck", "t-slowwalk", "t-fakelag", "t-fakecrouch"},
    player_states_idx = {["t-lowvel"] = 1, ["t-walk"] = 2, ["t-aerobic"] = 3, ["t-aerial"] = 4, ["t-duck"] = 5, ["t-slowwalk"] = 6, ["t-fakelag"] = 7, ["t-fakecrouch"] = 8},
    p_state = 0
}


--new
local ui_label = div.handlers.ui.new(ui.new_label("aa", "anti-aimbot angles", "\aB0CEFFFF>>\a848484BB[\aB0CEFFFFdivine.\aFFFFFFFFsolutions\a848484BB]"))
local ui_empty_label = div.handlers.ui.new(ui.new_label("aa", "anti-aimbot angles", " "))
local ui_tabs = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFBBSelect category", "ragebot", "anti-aim", "semi-rage", "generals", "configs"), true)

--ragebot
local ui_resolver = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "+/- \aB0CEFFFFdivine\aFFFFFFFF resolver"), true)
local prediction = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFdivine\aFFFFFFFF prediction"), true)
local disableinterpolation = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFdisable\aFFFFFFFF interpolation"), true)
local ipeek = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFdivine\aFFFFFFFF idealpeek"), true) 
local ipeekbind = div.handlers.ui.new(ui.new_hotkey("aa", "anti-aimbot angles", "\aB0CEFFFFidealpeek\aFFFFFFFF bind"), true)
local ipeekopts = div.handlers.ui.new(ui.new_multiselect("aa", "anti-aimbot angles", "\aB0CEFFFFoptions\aFFFFFFFF:", "\aB0CEFFFFdouble\aFFFFFFFF tap", "\aB0CEFFFFedge\aFFFFFFFF yaw"), true)
local baimlogic = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFautomatic force\aFFFFFFFF body-aim"), true)
local baimlogicopts = div.handlers.ui.new(ui.new_multiselect("aa", "anti-aimbot angles", "\aB0CEFFFFbaim \aFFFFFFFFwhen:", "\aB0CEFFFFenemy \aFFFFFFFF< than x hp", "\aB0CEFFFFbaim\aFFFFFFFF if lethal"), true)
local baimhp = div.handlers.ui.new(ui.new_slider("aa", "anti-aimbot angles", "\aB0CEFFFFhp", 0, 100, 90), true)
local safelogic = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFautomatic force\aFFFFFFFF safepoint"), true)
local safelogicopts = div.handlers.ui.new(ui.new_multiselect("aa", "anti-aimbot angles", "\aB0CEFFFFsafe \aFFFFFFFFwhen:", "\aB0CEFFFFenemy \aFFFFFFFF< than x hp"), true)
local safehp = div.handlers.ui.new(ui.new_slider("aa", "anti-aimbot angles", "\aB0CEFFFFhp", 0, 100, 90), true)

--aa
local teamside = div.handlers.ui.new(ui.new_combobox("aa", "anti-aimbot angles", "\aB0CEFFFFteam\aFFFFFFFF side", "CT", "T"), true)
local ui_aapresets = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine aa\aFFFFFFFF presets", "Disabled", "\aB0CEFFFFdivine \aFFFFFFFFbeta", "\aB0CEFFFFsimple \aFFFFFFFFbuilder", "\aB0CEFFFFbuilder"), true)
local ui_conditions = div.handlers.ui.new(ui.new_combobox("aa", "anti-aimbot angles", "\aB0CEFFFFdivine\aFFFFFFFF conditions", var.player_states, 0), true)
local ui_conditions1 = div.handlers.ui.new(ui.new_combobox("aa", "anti-aimbot angles", "\aB0CEFFFFdivine\aFFFFFFFF conditions", var1.player_states, 0), true)

local ui_sb_delay = div.handlers.ui.new(ui.new_slider("aa", "anti-aimbot angles", "\aB0CEFFFFswitch delay", 0, 5, 2), true)
local ui_sb_yaw = div.handlers.ui.new(ui.new_slider("aa", "anti-aimbot angles", "\aB0CEFFFFyaw offset", -180, 180, 0), true)
local ui_sb_real = div.handlers.ui.new(ui.new_slider("aa", "anti-aimbot angles", "\aB0CEFFFFreal offset", -90, 90, 45), true)
local ui_sb_fake = div.handlers.ui.new(ui.new_slider("aa", "anti-aimbot angles", "\aB0CEFFFFfake offset", -90, 90, -90), true)

--semirage
local ui_enable_semirage = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "+/- \aB0CEFFFFenable\aFFFFFFFF semirage"), true)


--exploits
local ui_forcedef = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFforce\aFFFFFFFF defensive"), true)
local ui_defconds = div.handlers.ui.new(ui.new_multiselect("aa", "anti-aimbot angles", "\aB0CEFFFFDefensive \aFFFFFFFFwhen:", "\aB0CEFFFFIn \aFFFFFFFFAir", "\aB0CEFFFFOn \aFFFFFFFFpeeking"), true)
local ui_defaa = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFdefensive\aFFFFFFFF anti-aim builder"), true)
local ui_defair = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFonly\aFFFFFFFF in Air"), true)
local ui_defdelay = div.handlers.ui.new(ui.new_slider("aa", "anti-aimbot angles", "\aB0CEFFFFlasting\aFFFFFFFF time", 0, 200, 100), true)
local ui_defpitch = div.handlers.ui.new(ui.new_combobox("aa", "anti-aimbot angles", "\aB0CEFFFFdivine defensive\aFFFFFFFF pitch", "off", "default", "up", "down", "minimal", "random"), true)
local ui_defyawt = div.handlers.ui.new(ui.new_combobox("aa", "anti-aimbot angles", "\aB0CEFFFFdivine defensive\aFFFFFFFF yaw type", "off", "180", "spin", "static", "180 Z", "crosshair"), true)
local ui_defyaw = div.handlers.ui.new(ui.new_slider("aa", "anti-aimbot angles", "\aB0CEFFFFdivine defensive\aFFFFFFFF yaw offset", -180, 180, 0), true)
local ui_defyawm = div.handlers.ui.new(ui.new_combobox("aa", "anti-aimbot angles", "\aB0CEFFFFdivine defensive\aFFFFFFFF yaw jitter type", "off", "offset", "center", "random", "skitter"), true)
local ui_defyawmo = div.handlers.ui.new(ui.new_slider("aa", "anti-aimbot angles", "\aB0CEFFFFdivine defensive\aFFFFFFFF yaw jitter value", -180, 180, 0), true)
local ui_defdsy = div.handlers.ui.new(ui.new_combobox("aa", "anti-aimbot angles", "\aB0CEFFFFdivine defensive\aFFFFFFFF yaw type", "static", "Jitter"), true)
local ui_defdsya = div.handlers.ui.new(ui.new_slider("aa", "anti-aimbot angles", "\aB0CEFFFFdivine defensive\aFFFFFFFF yaw value", -180, 180, 0), true)
--visuals 
local eindicatorx = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFenable mid-screen\aFFFFFFFF indicators"), true)
local indicatorxc = div.handlers.ui.new(ui.new_color_picker("aa", "anti-aimbot angles", "\aB0CEFFFFindicator\aFFFFFFFF color", 176, 206, 255,255), true)
local indicatorx = div.handlers.ui.new(ui.new_combobox("aa", "anti-aimbot angles", "\aB0CEFFFFmid-screen \aFFFFFFFFindicator", "old", "modern"), true)
local indoptions = div.handlers.ui.new(ui.new_multiselect("aa", "anti-aimbot angles", "\aB0CEFFFFindicate\aFFFFFFFF:", "\aB0CEFFFFdouble\aFFFFFFFF tap", "\aB0CEFFFFhide\aFFFFFFFF shots", "\aB0CEFFFFping\aFFFFFFFF spike", "\aB0CEFFFFdam\aFFFFFFFFage", "\aB0CEFFFFfree\aFFFFFFFFstanding", "\aB0CEFFFFfake \aFFFFFFFFduck"), true)
local ui_min_dmg_ind = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFenable min-dmg \aFFFFFFFFindicator"), true)
local text_color = div.handlers.ui.new(ui.new_color_picker("aa", "anti-aimbot angles", "\aB0CEFFFFindicator \aFFFFFFFFcolor", 176, 206, 255,255), true)
local fs = div.handlers.ui.new(ui.new_hotkey("aa", "anti-aimbot angles", "\aB0CEFFFFfree\aFFFFFFFFstanding"), true)
local staticfs = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFstatic\aFFFFFFFF freestanding"), true)
local dbgpanel = div.handlers.ui.new(ui.new_checkbox("aa", "anti-aimbot angles", "\aB0CEFFFFside de\aFFFFFFFFbug panel"), true)
local screen = {client.screen_size()}
local x_offset, y_offset = screen[1], screen[2]
local x, y =  x_offset/2,y_offset/2 

-- Misc
local ground_ticks  = 180
local ui_ui_animsge = div.handlers.ui.new(ui.new_multiselect("aa", "anti-aimbot angles", "\aB0CEFFFFgeneral \aFFFFFFFFanims:", "pitch 0 on ground", "animate move lean"), true)
local ui_animsa = div.handlers.ui.new(ui.new_combobox("aa", "anti-aimbot angles", "\aB0CEFFFFlegs in\aFFFFFFFF air anims:", "disabled", "static legs in air", "moonwalk in air"), true)
local ui_animsg = div.handlers.ui.new(ui.new_combobox("aa", "anti-aimbot angles", "\aB0CEFFFFlegs on\aFFFFFFFF ground anims:", "disabled", "backward legs", "moonwalk"), true)

--Config


local ui_configs = div.handlers.ui.new(ui.new_listbox("aa", "anti-aimbot angles", "configs", "")), function()
    return
end
--config name
local ui_configs_name = div.handlers.ui.new(ui.new_textbox("aa", "anti-aimbot angles", "Config name", "")), function()
    return 
end
--load
local ui_load_cfgs = div.handlers.ui.new(ui.new_button("aa", "anti-aimbot angles", "\aB0CEFFFFLoad", function() end)), function()
    return
end
--save
local ui_save_cfgs = div.handlers.ui.new(ui.new_button("aa", "anti-aimbot angles", "\aB0CEFFFFSave", function() end)), function()
    return
end
--delete
local ui_delete_cfgs = div.handlers.ui.new(ui.new_button("aa", "anti-aimbot angles", "\aB0CEFFFFDelete", function() end)), function()
    return
end
--import
local ui_import_cfgs = div.handlers.ui.new(ui.new_button("aa", "anti-aimbot angles", "\aB0CEFFFFImport settings", function() end)), function() 
    return
end
-- export
local ui_export_cfgs = div.handlers.ui.new(ui.new_button("aa", "anti-aimbot angles", "\aB0CEFFFFExport settings", function() end)), function()
    return
end

local ui_default_cfg = div.handlers.ui.new(ui.new_button("aa", "anti-aimbot angles", "\aB0CEFFFFLoad default settings", function() end)), function()
    return
end

--misc
for i = 1,8 do 
	antiaim[i] ={
        ui_pitch = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBpitch",{"off", "default", "up", "down", "minimal", "random"}, 0), true),
        ui_yawbase = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BByaw base",{"local view", "at targets"}, 0), true),
        ui_yaw = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BByaw",{"off", "static", "yaw add left/right", "divine meta", "slow-jit meta"}, 0), true),
        ui_yaw_value_jit = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBswitch delay",0, 10, 5), true),
        ui_yaw_value = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBstatic",-180, 180, 1), true),
        ui_slowjit_value = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBslow-jit value",0, 180, 45), true),
        ui_yaw_value1 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BByaw add left",-180, 180, 1), true),
        ui_yaw_value2 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BByaw add right",-180, 180, 1), true),
        ui_yaw_value3 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBmeta left",-180, 180, 1), true),
        ui_yaw_value4 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBmeta right",-180, 180, 1), true),
        ui_yawjitter = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BByaw jitter",{"off", "offset", "center", "random", "skitter", "dynamic center", "divine meta", "divine logic"}, 0), true),
        ui_yawjitter_jit = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBswitch delay",0, 10, 5), true),
        ui_yawjitter_value = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BByaw jitter",-180, 180, 1), true),
        ui_yawjitter_value1 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBleft limit",-180, 180, 1), true),
        ui_yawjitter_value2 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBright limit",-180, 180, 1), true),
        ui_yawjitter_value3 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBmeta left limit",-180, 180, 1), true),
        ui_yawjitter_value4 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBmeta right limit",-180, 180, 1), true),
        ui_bodyway = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBbody yaw",{"off", "opposite", "Jitter", "static", "divine meta", "divine logic"}, 0), true),
        ui_bodyway_value = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBbody yaw",-180, 180, 1), true),
        ui_roll_value = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var.player_states[i]).." \a848484BBroll",-45, 45, 0), true),




        ui_pitch1 = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBpitch",{"off", "default", "up", "down", "minimal", "random"}, 0), true),
        ui_yawbase1 = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BByaw base",{"local view", "at targets"}, 0), true),
        ui_yaw1 = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BByaw",{"off", "static", "yaw add left/right", "divine meta", "slow-jit meta"}, 0), true),
        ui_yaw_value_jit1 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBswitch delay",0, 10, 5), true),
        ui_yaw_value111 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBstatic",-180, 180, 1), true),
        ui_slowjit_value1 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBslow-jit value",0, 180, 45), true),
        ui_yaw_value11 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BByaw add left",-180, 180, 1), true),
        ui_yaw_value21 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BByaw add right",-180, 180, 1), true),
        ui_yaw_value31 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBmeta left",-180, 180, 1), true),
        ui_yaw_value41 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBmeta right",-180, 180, 1), true),
        ui_yawjitter1 = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BByaw jitter",{"off", "offset", "center", "random", "skitter", "dynamic center", "divine meta", "divine logic"}, 0), true),
        ui_yawjitter_jit1 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBswitch delay",0, 10, 5), true),
        ui_yawjitter_value111 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BByaw jitter",-180, 180, 1), true),
        ui_yawjitter_value11 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBleft limit",-180, 180, 1), true),
        ui_yawjitter_value21 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBright limit",-180, 180, 1), true),
        ui_yawjitter_value31 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBmeta left limit",-180, 180, 1), true),
        ui_yawjitter_value41 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBmeta right limit",-180, 180, 1), true),
        ui_bodyway1 = div.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBbody yaw",{"off", "opposite", "Jitter", "static", "divine meta", "divine logic"}, 0), true),
        ui_bodyway_value1 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBbody yaw",-180, 180, 1), true),
        ui_roll_value1 = div.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", "\aB0CEFFFFdivine "..(var1.player_states[i]).." \a848484BBroll",-45, 45, 0), true),
    }
end
local ui_defensive_tab = div.handlers.ui.new(ui.new_button("aa", "anti-aimbot angles", "\aB0CEFFFFdefensive aa", function() end)), function()
    return
end
local close_defensive = div.handlers.ui.new(ui.new_button("aa", "anti-aimbot angles", "\aB0CEFFFFback", function() end)), function()
    return
end





function init_database()
    if database.read(div.database.configs) == nil then
        database.write(div.database.configs, {})
    end
    
        for i, preset in pairs(div.presets) do
            table.insert(div.presets, { name = "*"..preset.name, config = preset.config})
        end
    
        ui.update(ui_configs, get_config_list())
    end

init_database()

animation_variables = {};

-- LERP FUNCTION FOR THE ANIMATION
function animation_variables.lerp(a, b, t)
    return a + (b - a) * t
end

-- ALPHA = ALPHA; MIN = MINIMUM ALPHA FOR THE PULSATION; MAX = MAXIMUM ALPHA FOR THE PULSATION; SPEED = ANIMATION SPEED
function animation_variables.pulsate(alpha, min, max, speed)
    local threshold = 0.01
    local new_change = true
    if alpha >= max - threshold then
        new_change = false
    elseif alpha <= min + threshold then
        new_change = true
    end

    if new_change == true then
        alpha = animation_variables.lerp(alpha, max, globals.frametime() * speed)
    else
        alpha = animation_variables.lerp(alpha, min, globals.frametime() * speed)
    end

    return alpha 
end

-- OFFSET TO BE MODULATED; WHEN = TRUE OR FALSE TO MODULATE; ORIGINAL = ORIGINAL POSITION; NEW_PLACE = LOCATION FOR THE OFFSET TO MOVE TO; SPEED = ANIMATION SPEED
function animation_variables.movement(offset, when, original, new_place, speed)
    if when then
        offset = animation_variables.lerp(offset, new_place, globals.frametime() * speed)
    else
        offset = animation_variables.lerp(offset, original, globals.frametime() * speed)
    end

    return offset 
end

-- ALPHA = YOUR ALPHA; FADE_BOOL = IF TRUE FADES IN IF NEGATIVE FADES AWAY;F_IN = FADE IN ALPHA; F_AWAY = FADE AWAY ALPHA; SPEED = ANIMATION SPEED
function animation_variables.fade(alpha, fade_bool, f_in, f_away, speed) 
    if fade_bool then
        alpha = animation_variables.lerp(alpha, f_in, globals.frametime() * speed)
    else
        alpha = animation_variables.lerp(alpha, f_away, globals.frametime() * speed)
    end

    return alpha
end

alpha_pulse = 0
offset_move = 0
offset_move2 = 0
dtoffset = 0
duckoffset = 0
alpha_fade = 0
dmgoffset = 0
pingoffset = 0
fsoffset = 0
local fonts = {
    mid = surface.create_font("verdana", 11, 900, {0x010, 0x080}),
    pixel = surface.create_font("Smallest Pixel-7", 10, 400, {0x200}),
    exp = surface.create_font("Smallest Pixel-7", 11, 500, {0x200}),
}
local ctx = {}
ctx.m_render = {
    rec = function(self, x, y, w, h, radius, color)
        radius = math.min(x/2, y/2, radius)
        local r, g, b, a = unpack(color)
        renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
        renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
    end,

    rec_outline = function(self, x, y, w, h, radius, thickness, color)
        radius = math.min(w/2, h/2, radius)
        local r, g, b, a = unpack(color)
        if radius == 1 then
            renderer.rectangle(x, y, w, thickness, r, g, b, a)
            renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
        else
            renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
            renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
            renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
            renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
            renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
            renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
            renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
        end
    end,

    glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
        local thickness = 1
        local offset = 1
        local r, g, b, a = unpack(accent)
        if accent_inner then
            self:rec(x , y, w, h + 1, rounding, accent_inner)
            --renderer.blur(x , y, w, h)
            --m_render.rec_outline(x + width*thickness - width*thickness, y + width*thickness - width*thickness, w - width*thickness*2 + width*thickness*2, h - width*thickness*2 + width*thickness*2, color(r, g, b, 255), rounding, thickness)
        end
        for k = 0, width do
            if a * (k/width)^(1) > 5 then
                local accent = {r, g, b, a * (k/width)^(2)}
                self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
            end
        end
    end
}

function string_anim(text, frac)
    return string.sub(text,1, math.ceil(string.len(text) * frac))
  end

function RGBAtoHEX(redArg, greenArg, blueArg, alphaArg)
    return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
end

local aa_states_table = {}

local reference = {
    slowmo = { ui.reference("AA", "Other", "Slow motion") },
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
    roll = ui.reference("AA", "Anti-aimbot angles", "roll")
}

aa_states_table.get_state = function()
    if entity.get_local_player() == nil then return end
    local vx, vy = entity.get_prop(entity.get_local_player(), 'm_vecVelocity')
    local player_Standing = math.sqrt(vx ^ 2 + vy ^ 2) < 2 
    local player_jumping = (bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 0) and not (entity.get_prop(entity.get_local_player(), "m_flDuckAmount") > 0.5)
    local slowmo = ui.get(reference.slowmo[2])
    local player_Fakeduck = ui.get(reference.fakeduck)
    local player_Crouching = entity.get_prop(entity.get_local_player(), "m_flDuckAmount") > 0.5 and not (bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 0)
    local player_air_crouch = entity.get_prop(entity.get_local_player(), "m_flDuckAmount") > 0.5 and (bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 0)
    
    if player_Standing then
        return 'LOWVEL'
    elseif player_jumping then
        return 'AERO'
    elseif player_Fakeduck then
        return 'FAKECROUCH'
    elseif player_Crouching then
        return 'CROUCHING'
    elseif player_air_crouch then
        return 'AERIAL'
    elseif slowmo then
        return 'TURTLE'
    else 
        return 'MOVE'
    end
    return aa_states_table
end

ctx.indicators = {
    render = function(self)
        local me = entity.get_local_player()

        if not me or not entity.is_alive(me) then
            return
        end

        local h,j,k,l = ui.get(text_color)
        local dmgog = ui.get(mindmg)
        local text = ui.get(slider)
        local me = entity.get_local_player()
        local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
        local measure = renderer.measure_text("bc", "divine.sys")
        local rounding_px = math.floor((measure + 4 ) / 2)

        if ui.get(ui_min_dmg_ind) then
            if ui.get(key) then 
                renderer.text(x + 15, y - 15, h,j,k,l, "c", nil, text)
            else
                renderer.text(x + 15, y - 15, h,j,k,l, "c", nil, dmgog)
            end
        end

        if not entity.is_alive(entity.get_local_player()) then return end

        if not ui.get(eindicatorx) then return end
        local r,g,b = ui.get(indicatorxc)
        local offsetttt = 0

        local nicehardcodebraindead = ui.get(indoptions)


                offset_move2 = animation_variables.movement(offset_move2, scoped, 0, 16, 4)
                fsoffset = animation_variables.movement(fsoffset, ui.get(fs), 0, 20, 8)
                dmgoffset = animation_variables.movement(dmgoffset, ui.get(key), 0, 20, 8)
                pingoffset = animation_variables.movement(pingoffset, ui.get(ref.ping[2]), 0, 20, 8)
                dtoffset = animation_variables.movement(dtoffset, ui.get(ref.dt[2]) or ui.get(ref.hs[2]), 0, 20, 8)
                duckoffset = animation_variables.movement(duckoffset, ui.get(ref.fd), 0, 20, 8)
            if ui.get(indicatorx) == "old" then
                local current_yaw = 0
                local lerp_factor = 0.05
                offset_move = animation_variables.movement(offset_move, scoped, 0, 32, 5)
                surface.draw_text(x + offset_move2 * 1.1 - 10, y + 25, 255, 255, 255, 255, fonts.pixel, tostring(math.floor(anti_aim.get_desync(nil))) .. "%")
                if anti_aim.get_desync(2) <= 0 then
                    renderer.text(x + 2 - 15 + offset_move * 1.1, y + 20, r,g,b, 255, "bc", nil, "divine")
                    renderer.text(x + 2 + 10 + offset_move * 1.1, y + 20, 255,255,255, 255, "bc", nil, ".lua")    
                elseif anti_aim.get_desync(2) > 0 then
                    renderer.text(x + 2 - 15 + offset_move * 1.1, y + 20, 255 ,255 ,255, 255, "bc", nil, "divine")   
                    renderer.text(x + 2 + 10 + offset_move * 1.1, y + 20, r,g,b, 255, "bc", nil, ".lua")        
                end

                --"\aB0CEFFFFdouble\aFFFFFFFF tap", "\aB0CEFFFFhide\aFFFFFFFF shots", "\aB0CEFFFFping\aFFFFFFFF spike", "\aB0CEFFFFdam\aFFFFFFFFage", "\aB0CEFFFFfree\aFFFFFFFFstanding", "\aB0CEFFFFfake \aFFFFFFFFduck")
                if ui.get(ref.dt[2]) and anti_aim.get_double_tap() and not ui.get(ref.qp[2]) and contains(nicehardcodebraindead, "\aB0CEFFFFdouble\aFFFFFFFF tap") then
                    renderer.text(x - 4 + offset_move2 * 1.3, y + 20 + offsetttt + dtoffset, 255, 255, 255, 220, "-c", nil, "RAPID")
                    offsetttt = offsetttt + 10
                elseif ui.get(ref.dt[2]) and not anti_aim.get_double_tap() and not ui.get(ref.qp[2]) and contains(nicehardcodebraindead, "\aB0CEFFFFdouble\aFFFFFFFF tap") then
                    renderer.text(x - 4 + offset_move2 * 1.3, y + 20 + offsetttt + dtoffset, 200, 0, 0, 255, "-c", nil, "RAPID")
                    offsetttt = offsetttt + 10
                elseif ui.get(ref.qp[2]) and ui.get(ref.dt[2]) and anti_aim.get_double_tap() and contains(nicehardcodebraindead, "\aB0CEFFFFdouble\aFFFFFFFF tap") then
                    renderer.text(x - 4 + offset_move2 * 1.8, y + 20 + offsetttt + dtoffset, 255, 255, 255, 255, "-c", nil, "~READY TICK")
                    offsetttt = offsetttt + 10
                elseif ui.get(ref.qp[2]) and ui.get(ref.dt[2]) and not anti_aim.get_double_tap() and contains(nicehardcodebraindead, "\aB0CEFFFFdouble\aFFFFFFFF tap") then
                    renderer.text(x - 4 + offset_move2 * 1.8, y + 20 + offsetttt + dtoffset, 200, 0, 0, 255, "-c", nil, "~WAITING TICK")
                    offsetttt = offsetttt + 10
                elseif ui.get(ref.hs[2]) and not ui.get(ref.dt[2]) and contains(nicehardcodebraindead, "\aB0CEFFFFhide\aFFFFFFFF shots") then
                    renderer.text(x - 4 + offset_move2 * 1.2, y + 20 + offsetttt + dtoffset, 136,207,52, 220, "-c", 0, "OSAA")
                    offsetttt = offsetttt + 10
                end
                if ui.get(ref.fd) and contains(nicehardcodebraindead, "\aB0CEFFFFfake \aFFFFFFFFduck") then
                    renderer.text(x - 4 + offset_move2 * 1.2, y + 20 + offsetttt + duckoffset, 150, 150, 150, 255, "-c", 0, "DUCK")
                    offsetttt = offsetttt + 10
                end
                if ui.get(fs) and contains(nicehardcodebraindead, "\aB0CEFFFFfree\aFFFFFFFFstanding") then
                    renderer.text(x - 4 + offset_move2 * 0.9, y + 20 + offsetttt + fsoffset, 240, 255, 71, 255, "-c", 0, "FS")
                    offsetttt = offsetttt + 10
                end
                if ui.get(ref.ping[2]) and contains(nicehardcodebraindead, "\aB0CEFFFFping\aFFFFFFFF spike") then
                    renderer.text(x - 4 + offset_move2 * 1.1, y + 20 + offsetttt + pingoffset, 132, 195, 16, 255, "-c", 0, "PING")
                    offsetttt = offsetttt + 10
                end
                if ui.get(key) and contains(nicehardcodebraindead, "\aB0CEFFFFdam\aFFFFFFFFage") then
                    renderer.text(x - 4 + offset_move2 * 1.1, y + 19 + offsetttt + dmgoffset, 225, 230, 235, 240, "-c", 0, "DMG")
                    offsetttt = offsetttt + 10
                end
                ctx.m_render:glow_module(x + 2 - 30 + offset_move, y + 20, measure, 0, 10 , 0, {r, g, b, 90}, {r, g, b, 90})
            elseif ui.get(indicatorx) == "modern" then

                local aA = {
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 80 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 75 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 70 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 65 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 60 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 55 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 50 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 45 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 40 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 35 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 30 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 25 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 20 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 15 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 10 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 5 / 30))},
                    {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 0 / 30))}
                }
            
                alpha_pulse = animation_variables.pulsate(alpha_pulse,0,255,5)
                offset_move = animation_variables.movement(offset_move,scoped,0,30,5)
                alpha_fade = animation_variables.fade(alpha_fade,scoped,255,0,5)

                renderer.text(x + offset_move * 0.9,  y + 30 + offsetttt, 255, 255, 255, 255, "-c", nil, "{-" .. aa_states_table.get_state() .. "-}")
                offsetttt = offsetttt + 8
                if ui.get(ref.dt[2]) and anti_aim.get_double_tap() and not ui.get(ref.qp[2]) and contains(nicehardcodebraindead, "\aB0CEFFFFdouble\aFFFFFFFF tap") then
                    renderer.text(x + offset_move2 * 1.3, y + 12 + offsetttt + dtoffset, 255, 255, 255, 220, "-c", nil, "RAPID")
                    offsetttt = offsetttt + 8
                elseif ui.get(ref.dt[2]) and not anti_aim.get_double_tap() and not ui.get(ref.qp[2]) and contains(nicehardcodebraindead, "\aB0CEFFFFdouble\aFFFFFFFF tap") then
                    renderer.text(x + offset_move2 * 1.3, y + 12 + offsetttt + dtoffset, 200, 0, 0, 255, "-c", nil, "RAPID")
                    offsetttt = offsetttt + 8
                elseif ui.get(ref.qp[2]) and ui.get(ref.dt[2]) and anti_aim.get_double_tap() and contains(nicehardcodebraindead, "\aB0CEFFFFdouble\aFFFFFFFF tap") then
                    renderer.text(x + offset_move2 * 1.8, y + 12 + offsetttt + dtoffset, 255, 255, 255, 255, "-c", nil, "~READY TICK")
                    offsetttt = offsetttt + 8
                elseif ui.get(ref.qp[2]) and ui.get(ref.dt[2]) and not anti_aim.get_double_tap() and contains(nicehardcodebraindead, "\aB0CEFFFFdouble\aFFFFFFFF tap") then
                    renderer.text(x + offset_move2 * 1.8, y + 12 + offsetttt + dtoffset, 200, 0, 0, 255, "-c", nil, "~WAITING TICK")
                    offsetttt = offsetttt + 8
                elseif ui.get(ref.hs[2]) and not ui.get(ref.dt[2]) and contains(nicehardcodebraindead, "\aB0CEFFFFhide\aFFFFFFFF shots") then
                    renderer.text(x + offset_move2 * 1.2, y + 12 + offsetttt + dtoffset, 136,207,52, 220, "-c", 0, "OSAA")
                    offsetttt = offsetttt + 8
                end
                if ui.get(ref.fd) and contains(nicehardcodebraindead, "\aB0CEFFFFfake \aFFFFFFFFduck") then
                    renderer.text(x + offset_move2 * 1.2, y + 12 + offsetttt + duckoffset, 150, 150, 150, 255, "-c", 0, "DUCK")
                    offsetttt = offsetttt + 8
                end
                if ui.get(fs) and contains(nicehardcodebraindead, "\aB0CEFFFFfree\aFFFFFFFFstanding") then
                    renderer.text(x + offset_move2 * 0.9, y + 12 + offsetttt + fsoffset, 240, 255, 71, 255, "-c", 0, "FS")
                    offsetttt = offsetttt + 8
                end
                if ui.get(ref.ping[2]) and contains(nicehardcodebraindead, "\aB0CEFFFFping\aFFFFFFFF spike") then
                    renderer.text(x + offset_move2 * 1.1, y + 12 + offsetttt + pingoffset, 132, 195, 16, 255, "-c", 0, "PING")
                    offsetttt = offsetttt + 8
                end
                if ui.get(key) and contains(nicehardcodebraindead, "\aB0CEFFFFdam\aFFFFFFFFage") then 
                    renderer.text(x + offset_move2 * 1.1, y + 12 + offsetttt + dmgoffset, 225, 230, 235, 240, "-c", 0, "DMG")
                    offsetttt = offsetttt + 8
                end
                renderer.text(x + offset_move * 1.1, y + 20, 0, 0, 0, 255, "bc", nil, "divine.lua")
                renderer.text(x + offset_move * 1.1, y + 20, 255, 255, 255, 255, "bc", nil, string.format("\a%sd\a%si\a%sv\a%si\a%sn\a%se\a%s.\a%sl\a%su\a%sa", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7])), RGBAtoHEX(unpack(aA[8])), RGBAtoHEX(unpack(aA[9])),RGBAtoHEX(unpack(aA[10])),RGBAtoHEX(unpack(aA[11])),RGBAtoHEX(unpack(aA[12])),RGBAtoHEX(unpack(aA[13])),RGBAtoHEX(unpack(aA[14])),RGBAtoHEX(unpack(aA[15])),RGBAtoHEX(unpack(aA[16])),RGBAtoHEX(unpack(aA[17]))))
                ctx.m_render:glow_module(x - 25 + offset_move, y + 20, measure, 0, 10 , 0, {r, g, b, 90}, {r, g, b, 90})
                
            end
        end
}
ffi = require 'ffi'

ffi.cdef[[
    struct c_animstate {
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334

        float velocity_subtract_x; //0x0330 
        float velocity_subtract_y; //0x0334 
        float velocity_subtract_z; //0x0338 
    };

    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct
    {
        float   m_anim_time;		
        float   m_fade_out_time;	
        int     m_flags;			
        int     m_activity;			
        int     m_priority;			
        int     m_order;			
        int     m_sequence;			
        float   m_prev_cycle;		
        float   m_weight;			
        float   m_weight_delta_rate;
        float   m_playback_rate;	
        float   m_cycle;			
        void* m_owner;			
        int     m_bits;				
    } C_AnimationLayer;

    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);
]]

ffi.cdef[[
	typedef struct MaterialAdapterInfo_tt
	{
		char m_pDriverName[512];
		unsigned int m_VendorID;
		unsigned int m_DeviceID;
		unsigned int m_SubSysID;
		unsigned int m_Revision;
		int m_nDXSupportLevel;			// This is the *preferred* dx support level
		int m_nMinDXSupportLevel;
		int m_nMaxDXSupportLevel;
		unsigned int m_nDriverVersionHigh;
		unsigned int m_nDriverVersionLow;
	};

	typedef int(__thiscall* get_current_adapter_fn)(void*);
	typedef void(__thiscall* get_adapter_info_fn)(void*, int adapter, struct MaterialAdapterInfo_t& info);
]]

math.clamp = function(v, min, max)
    if min > max then min, max = max, min end
    if v > max then return max end
    if v < min then return v end
    return v
end

math.vec_length2d = function(vec)
    root = 0.0
    sqst = vec.x * vec.x + vec.y * vec.y
    root = math.sqrt(sqst)
    return root
end

math.angle_diff = function(dest, src)
    local delta = 0.0

    delta = math.fmod(dest - src, 360.0)

    if dest > src then
        if delta >= 180 then delta = delta - 360 end
    else
        if delta <= -180 then delta = delta + 360 end
    end

    return delta
end

math.angle_normalize = function(angle)
    local ang = 0.0
    ang = math.fmod(angle, 360.0)

    if ang < 0.0 then ang = ang + 360 end

    return ang
end

math.anglemod = function(a)
    local num = (360 / 65536) * bit.band(math.floor(a * (65536 / 360.0), 65535))
    return num
end

math.approach_angle = function(target, value, speed)
    target = math.anglemod(target)
    value = math.anglemod(value)

    local delta = target - value

    if speed < 0 then speed = -speed end

    if delta < -180 then
        delta = delta + 360
    elseif delta > 180 then
        delta = delta - 360
    end

    if delta > speed then
        value = value + speed
    elseif delta < -speed then
        value = value - speed
    else
        value = target
    end

    return value
end

local entity_list_ptr = ffi.cast("void***", client.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][3])
local get_client_entity_by_handle_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][4])
local voidptr = ffi.typeof("void***")
local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(voidptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

entity.get_vector_prop = function(idx, prop, array)
    local v1, v2, v3 = entity.get_prop(idx, prop, array)
    return {
        x = v1, y = v2, z = v3
    }
end

entity.get_address = function(idx)
    return get_client_entity_fn(entity_list_ptr, idx)
end

entity.get_animstate = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("struct c_animstate**", addr + 0x9960)[0]
end

entity.get_animlayer = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', addr) + 0x9960)[0]
end

local resolver = {}
resolver.m_flMaxDelta = function(idx)
    local animstate = entity.get_animstate(idx)

    local speedfactor = math.clamp(animstate.m_flFeetSpeedForwardsOrSideWays, 0, 1)
    local avg_speedfactor = (animstate.m_flStopToFullRunningFraction * -0.3 - 0.2) * speedfactor + 1

    local duck_amount = animstate.m_fDuckAmount

    if duck_amount > 0 then
        local max_velocity = math.clamp(animstate.m_flFeetSpeedForwardsOrSideWays, 0, 1)
        local duck_speed = duck_amount * max_velocity

        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return avg_speedfactor
end

resolver.layers = {}
resolver.update_layers = function(idx)
    local layers = entity.get_animlayer(idx)
    if not layers then return end

    if not resolver.layers[idx] then
        resolver.layers[idx] = {}
    end

    for i = 1, 12 do
        local layer = layers[i]
        if not layer then goto continue end

        if not resolver.layers[idx][i] then
            resolver.layers[idx][i] = {}
        end

        resolver.layers[idx][i].m_playback_rate = layer.m_playback_rate or resolver.layers[idx][i].m_playback_rate
        resolver.layers[idx][i].m_sequence = layer.m_sequence or resolver.layers[idx][i].m_sequence

        ::continue::
    end
end

resolver.m_bIsBreakingLby = function(idx)
    if not resolver.layers[idx] then return end
    for i = 1, 12 do
        if not resolver.layers[idx][i] then goto continue end
        if not resolver.layers[idx][i].m_sequence then goto continue end

        if resolver.layers[idx][i].m_sequence == 979 then return true end

        ::continue::
    end
    return false
end

resolver.safepoints = {}
resolver.rotation = {
    CENTER = 1,
    LEFT = 2,
    RIGHT = 3
}
resolver.update_safepoints = function(idx, side, desync)
    if not resolver.safepoints[idx] then
        resolver.safepoints[idx] = {}
    end

    if not resolver.safepoints[idx][3] then
        for i = 1, 3 do
            resolver.safepoints[idx][i] = {}
            resolver.safepoints[idx][i].m_playback_rate = nil
            resolver.safepoints[idx][i].m_flDesync = nil
        end
    end

    if side < 0 then
        if not resolver.safepoints[idx][3].m_flDesync then
            resolver.safepoints[idx][3].m_flDesync = -desync
        end

        if math.abs(resolver.safepoints[idx][3].m_flDesync) <= desync then
            resolver.safepoints[idx][3].m_flDesync = -desync
            resolver.safepoints[idx][3].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end

        if not resolver.safepoints[idx][3].m_playback_rate then
            resolver.safepoints[idx][3].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end
    elseif side > 0 then
        if not resolver.safepoints[idx][2].m_flDesync then
            resolver.safepoints[idx][2].m_flDesync = desync
        end

        if resolver.safepoints[idx][2].m_flDesync >= desync then
            resolver.safepoints[idx][2].m_flDesync = desync
            resolver.safepoints[idx][2].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end

        if not resolver.safepoints[idx][2].m_playback_rate then
            resolver.safepoints[idx][2].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end 
    else
        local m_flDesync = side * desync
        if not resolver.safepoints[idx][1].m_flDesync then
            resolver.safepoints[idx][1].m_flDesync = m_flDesync
        end
    
        if math.abs(resolver.safepoints[idx][1].m_flDesync) >= desync then
            resolver.safepoints[idx][1].m_flDesync = m_flDesync
            resolver.safepoints[idx][1].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end
    
        if not resolver.safepoints[idx][1].m_playback_rate then
            resolver.safepoints[idx][1].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end 
    end

    if resolver.safepoints[idx][2].m_playback_rate and resolver.safepoints[idx][3].m_playback_rate then
        local m_flDesync = side * desync
        if m_flDesync >= resolver.safepoints[idx][3].m_flDesync then
            if m_flDesync <= resolver.safepoints[idx][2].m_flDesync then
                if not resolver.safepoints[idx][1].m_flDesync then
                    resolver.safepoints[idx][1].m_flDesync = m_flDesync
                end
            
                if math.abs(resolver.safepoints[idx][1].m_flDesync) >= desync then
                    resolver.safepoints[idx][1].m_flDesync = m_flDesync
                    resolver.safepoints[idx][1].m_playback_rate = resolver.layers[idx][6].m_playback_rate
                end
            
                if not resolver.safepoints[idx][1].m_playback_rate then
                    resolver.safepoints[idx][1].m_playback_rate = resolver.layers[idx][6].m_playback_rate
                end 
            end
        end
    end
end

resolver.walk_to_run_transition = function(m_flWalkToRunTransition, m_bWalkToRunTransitionState,
    m_flLastUpdateIncrement, m_flVelocityLengthXY)
    ANIM_TRANSITION_WALK_TO_RUN = false
    ANIM_TRANSITION_RUN_TO_WALK = true
    CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED = 2.0
    CS_PLAYER_SPEED_RUN = 260.0
    CS_PLAYER_SPEED_DUCK_MODIFIER = 0.34
    CS_PLAYER_SPEED_WALK_MODIFIER = 0.52

    if m_flWalkToRunTransition > 0 and m_flWalkToRunTransition < 1 then
        if m_bWalkToRunTransitionState == ANIM_TRANSITION_WALK_TO_RUN then
            m_flWalkToRunTransition = m_flWalkToRunTransition + m_flLastUpdateIncrement * CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED
        else
            m_flWalkToRunTransition = m_flWalkToRunTransition - m_flLastUpdateIncrement * CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED
        end

        m_flWalkToRunTransition = math.clamp(m_flWalkToRunTransition, 0, 1)
    end

    if m_flVelocityLengthXY >
        (CS_PLAYER_SPEED_RUN * CS_PLAYER_SPEED_WALK_MODIFIER) and m_bWalkToRunTransitionState == ANIM_TRANSITION_RUN_TO_WALK then
        m_bWalkToRunTransitionState = ANIM_TRANSITION_WALK_TO_RUN
        m_flWalkToRunTransition = math.max(0.01, m_flWalkToRunTransition)
    elseif m_flVelocityLengthXY < (CS_PLAYER_SPEED_RUN * CS_PLAYER_SPEED_WALK_MODIFIER) and m_bWalkToRunTransitionState == ANIM_TRANSITION_WALK_TO_RUN then
        m_bWalkToRunTransitionState = ANIM_TRANSITION_RUN_TO_WALK
        m_flWalkToRunTransition = math.min(0.99, m_flWalkToRunTransition)
    end

    return m_flWalkToRunTransition, m_bWalkToRunTransitionState
end

resolver.calculate_predicted_foot_yaw = function(m_flFootYawLast, m_flEyeYaw, m_flLowerBodyYawTarget, m_flWalkToRunTransition, m_vecVelocity, m_flMinBodyYaw, m_flMaxBodyYaw)
    local m_flVelocityLengthXY = math.min(math.vec_length2d( m_vecVelocity ), 260.0)

    local m_flFootYaw = math.clamp(m_flFootYawLast, -360, 360)
    local flEyeFootDelta = math.angle_diff(m_flEyeYaw, m_flFootYaw)

    if flEyeFootDelta > m_flMaxBodyYaw then
        m_flFootYaw = m_flEyeYaw - math.abs(m_flMaxBodyYaw)
    elseif flEyeFootDelta < m_flMinBodyYaw then
        m_flFootYaw = m_flEyeYaw + math.abs(m_flMinBodyYaw)
    end

    m_flFootYaw = math.angle_normalize(m_flFootYaw)

    local m_flLastUpdateIncrement = globals.tickinterval()

    if m_flVelocityLengthXY > 0.1 or m_vecVelocity.z > 100 then
        m_flFootYaw = math.approach_angle(m_flEyeYaw, m_flFootYaw, m_flLastUpdateIncrement * (30.0 + 20.0 * m_flWalkToRunTransition))
    else
        m_flFootYaw = math.approach_angle(m_flLowerBodyYawTarget, m_flFootYaw, m_flLastUpdateIncrement * 100)
    end

    return m_flFootYaw
end

resolver.previous = {}
resolver.resolve = function(idx)
    -- type of idx = unsigned int, can t go under 1
    if not idx or idx <= 0 then return end

    -- Checking For Valid Index.
    -- Required for !crash
    local m_bIsValidIdx = entity.get_address(idx)
    if not m_bIsValidIdx then return end

    local animstate = entity.get_animstate(idx)
    if not animstate then return end
    resolver.update_layers(idx) -- Update Entity Animation Layers

    if not resolver.previous[idx] then
        resolver.previous[idx] = {}
    end

    local m_vecVelocity = entity.get_vector_prop(idx, 'm_vecVelocity')
    local m_flVelocityLengthXY = math.vec_length2d(m_vecVelocity) -- We don t need to check for jump

    local m_flMaxDesyncDelta = resolver.m_flMaxDelta(idx) -- return float
    local m_flDesync = m_flMaxDesyncDelta * 57 -- 57 (Max Desync Value)

    local m_flEyeYaw = animstate.m_flEyeYaw -- Current Entity Eye Yaw
    local m_flGoalFeetYaw = animstate.m_flGoalFeetYaw -- Current Feet Yaw
    local m_flLowerBodyYawTarget = entity.get_prop(idx, 'm_flLowerBodyYawTarget') -- Current Lower Body Yaw

    local m_flAngleDiff = math.angle_diff(m_flEyeYaw, m_flGoalFeetYaw)

    local side = 0 -- It can be centered? Oh yeah bots and legit players
    if m_flAngleDiff < 0 then
        side = 1
    elseif m_flAngleDiff > 0 then
        side = -1
    end

    local m_flAbsAngleDiff = math.abs(m_flAngleDiff) -- Current Angle Diffrence, Only positive value
    local m_flAbsPreviousDiff = math.abs(resolver.previous[idx].m_flAbsAngleDiff or m_flAbsAngleDiff) -- Previous Angle Diffrence

    local m_bShouldTryResolve = true -- Yes, we wanna resolve

    if m_flAbsAngleDiff > 0 or m_flAbsPreviousDiff > 0 then
        if m_flAbsAngleDiff < m_flAbsPreviousDiff then
            m_bShouldTryResolve = false

            if m_flVelocityLengthXY > (resolver.previous[idx].m_flVelocityLengthXY or 0) then
                m_bShouldTryResolve = true
            end
        end

        if resolver.m_bIsBreakingLby(idx) then m_bShouldTryResolve = true end

        if m_bShouldTryResolve then
            local m_flCurrentAngle = math.max(m_flAbsAngleDiff, m_flAbsPreviousDiff)
            if m_flAbsAngleDiff <= 10.0 and m_flAbsPreviousDiff <= 10.0 then
                m_flDesync = m_flCurrentAngle
            elseif m_flAbsAngleDiff <= 35.0 and m_flAbsPreviousDiff <= 35.0 then
                m_flDesync = math.max(29.0, m_flCurrentAngle)
            else
                m_flDesync = math.clamp(m_flCurrentAngle, 29.0, 57)
            end
        end
    end

    m_flDesync = math.clamp(m_flDesync, 0, (m_flMaxDesyncDelta * 57))

    resolver.update_safepoints(idx, side, m_flDesync) -- I wanna kill myself

    if m_flVelocityLengthXY > 5 and side ~= 0 then
        if resolver.safepoints[1] and resolver.safepoints[2] and resolver.safepoints[3] then
            if resolver.safepoints[1].m_playback_rate and resolver.safepoints[2].m_playback_rate and resolver.safepoints[3].m_playback_rate then
                local server_playback = resolver.layers[idx][6].m_playback_rate
                local center_playback = resolver.safepoints[1].m_playback_rate
                local left_playback = resolver.safepoints[2].m_playback_rate
                local right_playback = resolver.safepoints[3].m_playback_rate

                local m_layer_delta1 = math.abs(server_playback - center_playback)
                local m_layer_delta2 = math.abs(server_playback - left_playback)
                local m_layer_delta3 = math.abs(server_playback - right_playback)

                if m_layer_delta1 < m_layer_delta2 or m_layer_delta3 <= m_layer_delta2 then
                    if m_layer_delta1 >= m_layer_delta3 or m_layer_delta2 > m_layer_delta3 then
                        side = 1
                    end
                else
                    side = -1
                end
            end
        end
    end

    -- @BackupPrevious
    resolver.previous[idx].m_flAbsAngleDiff = m_flAbsAngleDiff
    resolver.previous[idx].m_flVelocityLengthXY = m_flVelocityLengthXY

    resolver.previous[idx].m_flDesync = m_flDesync * side

    resolver.previous[idx].m_flGoalFeetYaw = animstate.m_flGoalFeetYaw
    -- #EndBackupPrevious

    -- @Debug

    --print(tostring(entity.get_player_name(idx) .. ' : ' .. resolver.previous[idx].m_flDesync))
    
    -- #EndDebug

    resolver.previous[idx].m_flWalkToRunTransition, resolver.previous[idx].m_bWalkToRunTransitionState = resolver.walk_to_run_transition(
        resolver.previous[idx].m_flWalkToRunTransition or 0,
        resolver.previous[idx].m_bWalkToRunTransitionState or false,
        globals.tickinterval(), m_flVelocityLengthXY
    ) -- We need this only for m_flWalkToRunTransition

    resolver.previous[idx].m_flPredictedFootYaw = resolver.calculate_predicted_foot_yaw(
        m_flGoalFeetYaw, m_flEyeYaw + resolver.previous[idx].m_flDesync, m_flLowerBodyYawTarget,
        resolver.previous[idx].m_flWalkToRunTransition, m_vecVelocity, -57, 57
    ) -- Calculate new foot yaw

    --animstate.m_flGoalFeetYaw = resolver.previous[idx].m_flPredictedFootYaw -- Set New Resolved Foot Yaw
    dbgangle = math.floor(resolver.previous[idx].m_flDesync)
    dbgside = side
    if ui.get(ui_resolver) then
    plist.set(idx, 'Force body yaw', true)
    plist.set(idx, 'Force body yaw value', math.floor(resolver.previous[idx].m_flPredictedFootYaw))
    end
end

resolver.call = function()
    local lp = entity.get_local_player()
    if not lp or lp <= 0 then return end
    local lp_health = entity.get_prop(lp, 'm_iHealth')
    if lp_health < 1 then return end

    local players = entity.get_players(true)
    --if ui.get(ui_resolver) then
    for idx in pairs(players) do
        if idx == lp then goto continue end
        local m_iHealth = entity.get_prop(idx, 'm_iHealth')
        if not m_iHealth then goto continue end
        if m_iHealth < 1 then goto continue end

        resolver.resolve(idx)

        ::continue::
    end
--end
end

client.set_event_callback('net_update_start', function()
    resolver.call()
end)
local x2,y2 = client.screen_size()
local rec1, rec2 = x2-x2+40, y2-(y2/2)
local cur_x, cur_y = (x2-x2)+40, (y2-y2/2)

menu = {
    mouse = ui.new_hotkey("LUA", "B", "Mouse 1", true, 0x0001)
}

client.set_event_callback("paint", function()
    local cursx, cursy = ui.mouse_position()
    local player = entity.get_local_player()
    local alive = entity.is_alive(player)
    if not player or not alive then return end
    local side = anti_aim.get_desync(1)
    if side >= 0 then side = "right" else side = "left" end
    local me = entity.get_local_player()

    if not me or not entity.is_alive(me) then
        return
    end
    local players = entity.get_players(true)
    local idx = client.current_threat()
    --coronavirus
    if ui.get(menu.mouse) then
        if (cursx < (cur_x + 150)) and (cursx > (cur_x-30)) and (cursy < (cur_y + 90)) and (cursy > (cur_y-30)) then
            cur_x,cur_y = cursx, cursy
        else
            cur_x , cur_y = cur_x, cur_y
        end
    end

    if ui.get(dbgpanel) then

    renderer.text(cur_x + 7, cur_y-15, 255, 255, 255, 255, "c", nil, "Current state: ")
    renderer.text(cur_x + 85, cur_y-15, 255, 255, 255, 255, "c", nil, "~ " .. aa_states_table.get_state() .. " ~")
    renderer.text(cur_x+13, cur_y, 255, 255, 255, 255, "c", 98, "Current desync:  ")
    renderer.text(cur_x+65, cur_y, 255, 255, 255, 255, "c", 19, anti_aim.get_desync(1))
    renderer.text(cur_x+24, cur_y+15, 255, 255, 255, 255, "c", "nil", "Current desync side:  ")
    renderer.text(cur_x + 85, cur_y+15, 255, 255, 255, 255, "c", nil, side)
    renderer.text(cur_x+12, cur_y+30, 255, 255, 255, 255, "c", 80, "Current LBY:  " .. entity.get_prop(entity.get_local_player(), "m_flLowerBodyYawTarget"))
    renderer.text(cur_x+27, cur_y+45, 255, 255, 255, 255, "c", nil, "Current overlap:       %")
    renderer.text(cur_x+65, cur_y+45, 255, 255, 255, 255, "c", 15, anti_aim.get_overlap() * 100)
    renderer.text(cur_x+10, cur_y+60, 255, 255, 255, 255, "c", nil, "Current choke:  ")
    renderer.text(cur_x + 50, cur_y+60, 255, 255, 255, 255, "c", nil, globals.chokedcommands())
    for idx in pairs(players) do
        if idx == lp then goto continue end
        local m_iHealth = entity.get_prop(idx, 'm_iHealth')
        if not m_iHealth then goto continue end
        if m_iHealth < 1 then goto continue end
        if idx == 0 then goto continue end
    --renderer.text(x - 890, y + 20, 255, 255, 255, 220, "c", nil, "target name: ")
    renderer.text(cur_x+50, cur_y+90, 255, 255, 255, 255, "c", nil, "--@ Divine resolver data cache:")
    renderer.text(cur_x+11, cur_y+105, 255, 255, 255, 255, "c", nil, "Current threat:  ")
    renderer.text(cur_x+70, cur_y+105, 255, 255, 255, 255, "c", nil, entity.get_player_name(client.current_threat()))    
    renderer.text(cur_x+14, cur_y+120, 255, 255, 255, 255, "c", nil, "Resolved angle:  " )
    renderer.text(cur_x+65, cur_y+120, 255, 255, 255, 255, "c", nil, dbgangle)  
    renderer.text(cur_x+11, cur_y+135, 255, 255, 255, 255, "c", nil, "Resolved side:  " )
    renderer.text(cur_x+65, cur_y+135, 255, 255, 255, 255, "c", nil, dbgside)
        ::continue::
    end
end
end)


    function interpolate()
        if ui.get(disableinterpolation) then
            cvar.cl_interpolate:set_int(0)
        else
            cvar.cl_interpolate:set_int(1)
    end
    end
    
    function impprediction()
        if ui.get(prediction) then
            cvar.cl_interp_ratio:set_int(0)
            cvar.cl_interp:set_int(0)
            cvar.cl_updaterate:set_int(62)
        else
            cvar.cl_interp_ratio:set_int(1)
            cvar.cl_interp:set_int(0.15)
            cvar.cl_updaterate:set_int(64)
    end
    end

    local stat = {
        [0] = "Always on",
        [1] = "On hotkey",
        [2] = "Toggle",
        [3] = "Off hotkey"
    }
    
    local dtcache = {ui.get(ref.dt[2])}
    local cacheddata = false
    
    local function ipeekrun()
        local lp = entity.get_local_player()
        local yescode = ui.get(ipeekopts)
        if not entity.is_alive(lp) then return end
          if ui.get(ipeek) and ui.get(ipeekbind) and ui.get(ref.qp[2]) then

           local toggled = "Always on"

              if not entity.is_alive(lp) then return end
                 if cacheddata then
                    dtcache = {ui.get(ref.dt[2])}
                    cacheddata = false
                 end --\aB0CEFFFFdouble\aFFFFFFFF tap", "\aB0CEFFFFedge\aFFFFFFFF yaw
                if contains(yescode,"\aB0CEFFFFdouble\aFFFFFFFF tap") then
                   ui.set(ref.dt[2], toggled)
                else 
                    return
                end
                if contains(yescode,"\aB0CEFFFFedge\aFFFFFFFF yaw") then
                      ui.set(refs_aa.edgeyaw, true)
                else 
                    return
                end
           else
               if not cacheddata then
                   ui.set(ref.dt[2], stat[dtcache[2]])
                   ui.set(refs_aa.edgeyaw, false)
                   cacheddata = true
               end
          end
       end

       --@ pasta go brr, self reminder: make defensiev exploit yourself its simple dont be fag
local var_table = {};

local prev_simulation_time = 0


local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end
local diff_sim = 0
function var_table:sim_diff() 
    local current_simulation_time = time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

sim_time_dt = 0
to_draw = "no"
to_up = "no"
to_draw_ticks = 0
go_ = "no"
lastingtime = 0

function watermark()
    local screen_width, screen_height = client.screen_size()


	local text = (('%s / %s'):format(obex_data.username, obex_data.build))

	local margin, padding, flags = 18, 4, nil

	local text_width, text_height = renderer.measure_text(flags, text)


	renderer.rectangle(screen_width-text_width-margin-padding, margin-padding, text_width+padding*2, text_height+padding*2, 32, 32, 32, 200)
	renderer.text(screen_width-text_width-margin, margin, 235, 235, 235, 255, flags, 0, text)

end


function defensive_indicator()
    if not ui.get(ref.dt[2]) or not ui.get(ref.dt[1]) then return end
   
    local diff_mmeme = var_table.sim_diff()

    if diff_mmeme > 2 then
        to_draw = "yes"
        to_up = "yes"
        go_ = "yes"
     
    end
end 

function defensive_indicator_paint()
    if to_draw == "yes" and ui.get(ref.dt[2]) then
        draw_art = to_draw_ticks * 100 / 52

        to_draw_ticks = to_draw_ticks + 1

        if to_draw_ticks == 24 then
            to_draw_ticks = 0
            to_draw = "no"
            to_up = "no"
        end
    end
end

local get_entities = function(enemy_only, alive_only)
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
end

local weapon_is_enabled = function(idx)
	if (idx == 38 or idx == 11) then
		return true
	elseif (idx == 40) then
		return true
	elseif (idx == 9) then
		return true
	elseif (idx == 64) then
		return true
	elseif (idx == 1) then
		return true
	end
	return false
end

--@ pasta kekw
local is_lethal = function(player)
    local local_player = entity.get_local_player()
    if local_player == nil or not entity.is_alive(local_player) then return end
    local local_origin = vector(entity.get_prop(local_player, "m_vecAbsOrigin"))
    local distance = local_origin:dist(vector(entity.get_prop(player, "m_vecOrigin")))
    local enemy_health = entity.get_prop(player, "m_iHealth")

	local weapon_ent = entity.get_player_weapon(entity.get_local_player())
	if weapon_ent == nil then return end
	
	local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
	if weapon_idx == nil then return end
	
	local weapon = csgo_weapons[weapon_idx]
	if weapon == nil then return end

	if not weapon_is_enabled(weapon_idx) then return end

	local dmg_after_range = (weapon.damage * math.pow(weapon.range_modifier, (distance * 0.002))) * 1.25
	local armor = entity.get_prop(player,"m_ArmorValue")
	local newdmg = dmg_after_range * (weapon.armor_ratio * 0.5)
	if dmg_after_range - (dmg_after_range * (weapon.armor_ratio * 0.5)) * 0.5 > armor then
		newdmg = dmg_after_range - (armor / 0.5)
	end
	return newdmg >= enemy_health
end
----

local logicskekw = function()
    local players = get_entities(true, true)
    local plocal = entity.get_local_player()
    local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
	local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
    for i=1, #players do
		local idx = players[i]
        local m_iHealth = entity.get_prop(idx, 'm_iHealth')
        if ui.get(baimlogic) then
        if idx == nil then end
        if (m_iHealth < ui.get(baimhp)) and ui.get(baimlogicopts)[1] then
            plist.set(idx, "Override prefer body aim", "Force")
            print("forced true")
        elseif (m_iHealth > ui.get(baimhp)) or not ui.get(baimlogicopts)[1] then
            plist.set(idx, "Override prefer body aim", "-")
            print("forced false")
        end
        if is_lethal(players[i]) and ui.get(baimlogicopts)[2] then
            plist.set(idx, "Override prefer body aim", "Force") 
            print("forced lethal true")
        else
            plist.set(idx, "Override prefer body aim", "-")
            print("forced lethal false")
        end

        
        
    end
    
    
    if ui.get(safelogic) then
        if (m_iHealth < ui.get(safehp)) and ui.get(safelogicopts)[1] then
            plist.set(idx, "Override safe point", "On")
            print("forced safepoint on")
        elseif (m_iHealth > ui.get(safehp)) or not ui.get(safelogicopts)[1] then
            plist.set(idx, "Override safe point", "Off")
            print("forced safepoint off")
        end
        end

	end
     
     
end

client.set_event_callback("run_command", logicskekw)

counter = 0
counters = 0
counterss = 0
defdelay = 0
side = false
curtime = globals.curtime()
rt = globals.realtime()
defcheck = false
local timer = 0
local defdelay = 0
client.set_event_callback("setup_command", function(cmd)
    if globals.realtime() > timer then
        if valuesjit == true then
            valuesjit = false
        else
            valuesjit = true
        end
        timer = globals.realtime() + 0.1
    end
end)

client.set_event_callback("setup_command", function(cmd)
    if globals.realtime() > ui.get(ui_defdelay) / 20 - defdelay then
        if defcheck == true then
            defcheck = false
        else
            defcheck = true
        end
        defdelay = globals.realtime() + 0.1
    end
end)


local function antiaim_enable(cmd)

    local plocal = entity.get_local_player()
    local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
    local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 2
    local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1
    local crouching = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and bit.band(entity.get_prop(plocal, "m_fFlags"), 4) == 4
    local air_crouch = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 0 and bit.band(entity.get_prop(plocal, "m_fFlags"), 4) == 4
    local p_slow = ui.get(refs_aa.slow[1]) and ui.get(refs_aa.slow[2])
    local player_team = entity.get_prop(plocal, "m_iTeamNum")
    if p_still == true and on_ground == true then
        var.p_state = 1
        var1.p_state = 1
    end
    if p_still == false and on_ground == true then
        var.p_state = 2
        var1.p_state = 2
    end
    if on_ground == false then
        var.p_state = 3
        var1.p_state = 3
    end
    if air_crouch == true then
        var.p_state = 4
        var1.p_state = 4
    end
    if crouching == true then
        var.p_state = 5
        var1.p_state = 5
    end
    if p_slow == true then
        var.p_state = 6
        var1.p_state = 6
    end
    if not ui.get(ref.dt[2]) and not ui.get(ref.hs[2]) then
        var.p_state = 7
        var1.p_state = 7
    end
    if ui.get(ref.fd) then
        var.p_state = 8
        var1.p_state = 8
    end

    if ui.get(ui_enable_semirage) then
        ui.set(ui_aapresets, "Disabled")
    end

    if cmd.chokedcommands == 0 then
        counterss = counterss + 0.5
        counters = counters + 0.5
        counter = counter + 0.5
    end

    if counterss > 2 then
        counterss = 0
    end
    
        if counters > 2 then
            counters = 0
        end
    
        if counter > 2 then
            counter = 0
        end

        if cmd.chokedcommands == 0 then
            if counters >= ui.get(antiaim[var.p_state].ui_yawjitter_jit) / 10 then
                checks = not checks
            end
            if counter >= ui.get(antiaim[var.p_state].ui_yaw_value_jit) / 10 then
                check = not check
            end
            if counterss >= ui.get(ui_sb_delay) / 10 then
                checkss = not checkss
            end
        end

        if cmd.chokedcommands == 0 then
            if counters >= ui.get(antiaim[var1.p_state].ui_yawjitter_jit1) / 10 then
                checks1 = not checks1
            end
            if counter >= ui.get(antiaim[var1.p_state].ui_yaw_value_jit1) / 10 then
                check1 = not check1
            end
        end

        if m_iJitterTick + 1 <= 2 then
            m_iJitterTick = m_iJitterTick + 1
        else
            m_iJitterTick = 0
        end

        local sjitvalue = ui.get(antiaim[var.p_state].ui_slowjit_value)
        local sjitvalue1 = ui.get(antiaim[var1.p_state].ui_slowjit_value1)

        if ui.get(ui_aapresets) == "Disabled" then 
            ui.set(refs_aa.pitch, "Off")
            ui.set(refs_aa.yawbase, "local view")
            ui.set(refs_aa.yaw[1], "Off")
            ui.set(refs_aa.yaw[2], 0)
            ui.set(refs_aa.yawjitter[1], "Off")
            ui.set(refs_aa.yawjitter[2], 0)
            ui.set(refs_aa.bodyyaw[1], "Off")
            ui.set(refs_aa.bodyyaw[2], 0)
            ui.set(refs_aa.roll, 0)
        end

        if ui.get(staticfs) and ui.get(fs) then
            ui.set(refs_aa.enable, true)
            ui.set(refs_aa.pitch, "Down")
            ui.set(refs_aa.yawbase, "At Targets")
            ui.set(refs_aa.yaw[1], "180")
            ui.set(refs_aa.yaw[2], "0")
            ui.set(refs_aa.yawjitter[1], "center")
            ui.set(refs_aa.yawjitter[2], "0")
            ui.set(refs_aa.bodyyaw[1], "Static")
            ui.set(refs_aa.bodyyaw[2], "180")
        else
        if ui.get(ui_aapresets) == "\aB0CEFFFFbuilder" then 
           ui.set(refs_aa.enable, true)
           if player_team == 2 then
           ui.set(refs_aa.pitch, ui.get(antiaim[var.p_state].ui_pitch))
           ui.set(refs_aa.yawbase, ui.get(antiaim[var.p_state].ui_yawbase))

        if ui.get(antiaim[var.p_state].ui_yaw) == "static" then
            ui.set(refs_aa.yaw[1], "180")
            ui.set(refs_aa.yaw[2], ui.get(antiaim[var.p_state].ui_yaw_value))
            elseif ui.get(antiaim[var.p_state].ui_yaw) == "yaw add left/right" then
            ui.set(refs_aa.yaw[1], "180")
            ui.set(refs_aa.yaw[2], check and ui.get(antiaim[var.p_state].ui_yaw_value1) or ui.get(antiaim[var.p_state].ui_yaw_value2))
        elseif ui.get(antiaim[var.p_state].ui_yaw) == "divine meta" then
            ui.set(refs_aa.yaw[1], "180")
            ui.set(refs_aa.yaw[2], m_iJitterTick > 0 and ui.get(antiaim[var.p_state].ui_yaw_value3) or ui.get(antiaim[var.p_state].ui_yaw_value4))
        elseif ui.get(antiaim[var.p_state].ui_yaw) == "slow-jit meta" then
            ui.set(refs_aa.yaw[1], "180")
            ui.set(refs_aa.yaw[2], valuesjit == true and -sjitvalue or sjitvalue)
        end

        if ui.get(antiaim[var.p_state].ui_yawjitter) == "dynamic center" and ui.get(antiaim[var.p_state].ui_yawjitter) ~= "divine meta" then
        ui.set(refs_aa.yawjitter[1], "center")
        ui.set(refs_aa.yawjitter[2], checks and ui.get(antiaim[var.p_state].ui_yawjitter_value1) or ui.get(antiaim[var.p_state].ui_yawjitter_value2))
        elseif ui.get(antiaim[var.p_state].ui_yawjitter) ~= "dynamic center" and ui.get(antiaim[var.p_state].ui_yawjitter) == "divine meta" then
        ui.set(refs_aa.yawjitter[1], "center")
        ui.set(refs_aa.yawjitter[2], m_iJitterTick > 0 and ui.get(antiaim[var.p_state].ui_yawjitter_value3) or ui.get(antiaim[var.p_state].ui_yawjitter_value4))
        elseif ui.get(antiaim[var.p_state].ui_yawjitter) ~= "dynamic center" and ui.get(antiaim[var.p_state].ui_yawjitter) ~= "divine meta" and ui.get(antiaim[var.p_state].ui_yawjitter) == "divine logic" then
        ui.set(refs_aa.yawjitter[1], m_iJitterTick > 0 and "Offset" or "center")
        ui.set(refs_aa.yawjitter[2], ui.get(antiaim[var.p_state].ui_yawjitter_value))
        elseif ui.get(antiaim[var.p_state].ui_yawjitter) ~= "dynamic center" and ui.get(antiaim[var.p_state].ui_yawjitter) ~= "divine meta" and ui.get(antiaim[var.p_state].ui_yawjitter) ~= "divine logic" then
        ui.set(refs_aa.yawjitter[1], ui.get(antiaim[var.p_state].ui_yawjitter))
        ui.set(refs_aa.yawjitter[2], ui.get(antiaim[var.p_state].ui_yawjitter_value))
        end

        if ui.get(antiaim[var.p_state].ui_bodyway) == "divine meta" then
            ui.set(refs_aa.bodyyaw[1], "Jitter")
            ui.set(refs_aa.bodyyaw[2], m_iJitterTick > 0 and ui.get(antiaim[var.p_state].ui_bodyway_value) or ui.get(antiaim[var.p_state].ui_bodyway_value) * -1)
        elseif ui.get(antiaim[var.p_state].ui_bodyway) == "divine logic" then
            ui.set(refs_aa.bodyyaw[1], m_iJitterTick > 0 and "Jitter" or "static")
            ui.set(refs_aa.bodyyaw[2], ui.get(antiaim[var.p_state].ui_bodyway_value))
        elseif ui.get(antiaim[var.p_state].ui_bodyway) ~= "divine meta" and ui.get(antiaim[var.p_state].ui_bodyway) ~= "divine logic"  then
            ui.set(refs_aa.bodyyaw[1], ui.get(antiaim[var.p_state].ui_bodyway))
            ui.set(refs_aa.bodyyaw[2], ui.get(antiaim[var.p_state].ui_bodyway_value))
        end
        ui.set(refs_aa.roll, ui.get(antiaim[var.p_state].ui_roll_value))
    elseif player_team == 3 then
        ui.set(refs_aa.pitch, ui.get(antiaim[var1.p_state].ui_pitch1))
        ui.set(refs_aa.yawbase, ui.get(antiaim[var1.p_state].ui_yawbase1))

     if ui.get(antiaim[var1.p_state].ui_yaw1) == "static" then
         ui.set(refs_aa.yaw[1], "180")
         ui.set(refs_aa.yaw[2], ui.get(antiaim[var1.p_state].ui_yaw_value111))
         elseif ui.get(antiaim[var1.p_state].ui_yaw1) == "yaw add left/right" then
         ui.set(refs_aa.yaw[1], "180")
         ui.set(refs_aa.yaw[2], check1 and ui.get(antiaim[var1.p_state].ui_yaw_value11) or ui.get(antiaim[var1.p_state].ui_yaw_value21))
     elseif ui.get(antiaim[var1.p_state].ui_yaw1) == "divine meta" then
         ui.set(refs_aa.yaw[1], "180")
         ui.set(refs_aa.yaw[2], m_iJitterTick > 0 and ui.get(antiaim[var1.p_state].ui_yaw_value31) or ui.get(antiaim[var1.p_state].ui_yaw_value41))
     elseif ui.get(antiaim[var1.p_state].ui_yaw1) == "slow-jit meta" then
         ui.set(refs_aa.yaw[1], "180")
         ui.set(refs_aa.yaw[2], valuesjit == true and -sjitvalue1 or sjitvalue1)
     end

     if ui.get(antiaim[var1.p_state].ui_yawjitter1) == "dynamic center" and ui.get(antiaim[var1.p_state].ui_yawjitter1) ~= "divine meta" then
     ui.set(refs_aa.yawjitter[1], "center")
     ui.set(refs_aa.yawjitter[2], checks1 and ui.get(antiaim[var1.p_state].ui_yawjitter_value11) or ui.get(antiaim[var1.p_state].ui_yawjitter_value21))
     elseif ui.get(antiaim[var1.p_state].ui_yawjitter1) ~= "dynamic center" and ui.get(antiaim[var1.p_state].ui_yawjitter1) == "divine meta" then
     ui.set(refs_aa.yawjitter[1], "center")
     ui.set(refs_aa.yawjitter[2], m_iJitterTick > 0 and ui.get(antiaim[var1.p_state].ui_yawjitter_value3) or ui.get(antiaim[var1.p_state].ui_yawjitter_value4))
     elseif ui.get(antiaim[var1.p_state].ui_yawjitter1) ~= "dynamic center" and ui.get(antiaim[var1.p_state].ui_yawjitter1) ~= "divine meta" and ui.get(antiaim[var1.p_state].ui_yawjitter1) == "divine logic" then
     ui.set(refs_aa.yawjitter[1], m_iJitterTick > 0 and "Offset" or "center")
     ui.set(refs_aa.yawjitter[2], ui.get(antiaim[var1.p_state].ui_yawjitter_value111))
     elseif ui.get(antiaim[var1.p_state].ui_yawjitter1) ~= "dynamic center" and ui.get(antiaim[var1.p_state].ui_yawjitter1) ~= "divine meta" and ui.get(antiaim[var1.p_state].ui_yawjitter1) ~= "divine logic" then
     ui.set(refs_aa.yawjitter[1], ui.get(antiaim[var1.p_state].ui_yawjitter1))
     ui.set(refs_aa.yawjitter[2], ui.get(antiaim[var1.p_state].ui_yawjitter_value111))
     end

     if ui.get(antiaim[var1.p_state].ui_bodyway1) == "divine meta" then
         ui.set(refs_aa.bodyyaw[1], "Jitter")
         ui.set(refs_aa.bodyyaw[2], m_iJitterTick > 0 and ui.get(antiaim[var1.p_state].ui_bodyway_value1) or ui.get(antiaim[var1.p_state].ui_bodyway_value1) * -1)
     elseif ui.get(antiaim[var1.p_state].ui_bodyway1) == "divine logic" then
         ui.set(refs_aa.bodyyaw[1], m_iJitterTick > 0 and "Jitter" or "static")
         ui.set(refs_aa.bodyyaw[2], ui.get(antiaim[var1.p_state].ui_bodyway_value1))
     elseif ui.get(antiaim[var1.p_state].ui_bodyway1) ~= "divine meta" and ui.get(antiaim[var1.p_state].ui_bodyway1) ~= "divine logic"  then
         ui.set(refs_aa.bodyyaw[1], ui.get(antiaim[var1.p_state].ui_bodyway1))
         ui.set(refs_aa.bodyyaw[2], ui.get(antiaim[var1.p_state].ui_bodyway_value1))
     end
     ui.set(refs_aa.roll, ui.get(antiaim[var1.p_state].ui_roll_value1))
    end
    elseif ui.get(ui_aapresets) == "\aB0CEFFFFsimple \aFFFFFFFFbuilder" then 
    ui.set(refs_aa.enable, true)
    ui.set(refs_aa.pitch, "Down")
    ui.set(refs_aa.yawbase, "At Targets")
    ui.set(refs_aa.yaw[1], "180")
    ui.set(refs_aa.yaw[2], ui.get(ui_sb_yaw))
    ui.set(refs_aa.yawjitter[1], "center")
    ui.set(refs_aa.yawjitter[2], checkss and -ui.get(ui_sb_real) or ui.get(ui_sb_real))
    ui.set(refs_aa.bodyyaw[1], "Jitter")
    ui.set(refs_aa.bodyyaw[2], ui.get(ui_sb_fake) * 2)
end


if ui.get(ui_defaa) then
if ui.get(ui_defair) and in_air(plocal) or not ui.get(ui_defair) then
    if defcheck == true then
if to_up == "yes" then
    ui.set(refs_aa.pitch, ui.get(ui_defpitch))
    ui.set(refs_aa.yaw[1], ui.get(ui_defyawt))
    ui.set(refs_aa.yaw[2], ui.get(ui_defyaw))
    ui.set(refs_aa.yawjitter[1], ui.get(ui_defyawm))
    ui.set(refs_aa.yawjitter[2], ui.get(ui_defyawmo))
    ui.set(refs_aa.bodyyaw[1], ui.get(ui_defdsy))
    ui.set(refs_aa.bodyyaw[2], ui.get(ui_defdsya))

    if not ui.get(ref.dt[1]) or not ui.get(ref.dt[2]) or defcheck == false then
        to_up = "no"
    end
end
end
end
end
end
end

client.set_event_callback("setup_command", function(cmd)

    ui.set(refs_aa.freestand[1], ui.get(fs))
    ui.set(refs_aa.freestand[2], "Always on")
    ipeekrun()

    if ui.get(ui_forcedef) then
        local plocal = entity.get_local_player()
        local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1
        if ui.get(ui_defconds) == "\aB0CEFFFFIn \aFFFFFFFFAir" and on_ground == false then
        cmd.force_defensive = 1
    else goto fuckdef
    end
        if ui.get(ui_defconds) == "\aB0CEFFFFOn \aFFFFFFFFpeeking" and ui.get(ref.qp[2]) then
        cmd.force_defensive = 1
    else goto fuckdef
    end

    ::fuckdef::
    cmd.force_defensive = 0
end
end)

client.set_event_callback("pre_render", function()
    local self = entity.get_local_player()
    if not self or not entity.is_alive(self) then
        return
    end

    local self_index = c_entity.new(self)
    local self_anim_state = self_index:get_anim_state()

    local me = entity.get_local_player()
    local age = ui.get(ui_ui_animsge)
    if not me or not entity.is_alive(me) then return end

    local flags = entity.get_prop(me, "m_fFlags")
    if ui.get(ui_animsa) == "static legs in air" then 
        entity.set_prop(me, "m_flPoseParameter", 1, 6) 
    end
    if contains(age, "pitch 0 on ground") then 
    ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0
    if ground_ticks > 20 and ground_ticks < 160 then
        entity.set_prop(me, "m_flPoseParameter", 0.5, 12)
    end
    end

    if ui.get(ui_animsa) == "moonwalk in air" and in_air(me) then 
    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 7)
        local my_animlayer = self_index:get_anim_overlay(6);
        my_animlayer.weight = 1;
        entity.set_prop(self_index, "m_flPoseParameter", 1, 6)
    end

    if contains(age, "animate move lean") then 
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end

            self_anim_overlay.weight = 1
    end

    if ui.get(ui_animsg) == "moonwalk" and not in_air(me) then 
        local me    = entity.get_local_player()
        local flags = entity.get_prop(me, "m_fFlags")
        local vel1, vel2, vel3 = entity.get_prop(me, 'm_vecVelocity')
        local speed = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))
        local walking = speed >= 2
        if walking then
        ui.set(legsref, "Never slide")
        entity.set_prop(self_index, "m_flPoseParameter", 1, 6)
            local my_animlayer = self_index:get_anim_overlay(6);
            my_animlayer.weight = 1;
            entity.set_prop(self_index, "m_flPoseParameter", 1, 6)
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 7)
        end
    end
    if ui.get(ui_animsg) == "backward legs" and not in_air(me) then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        ui.set(legsref, "Always slide")
    end
end)



local pressed_close = true

local function on_load()

    --# ragebot render
    ui.set_visible(ipeek, ui.get(ui_tabs) == "ragebot")
    ui.set_visible(ipeekopts, ui.get(ui_tabs) == "ragebot" and ui.get(ipeek))
    ui.set_visible(ipeekbind, ui.get(ui_tabs) == "ragebot" and ui.get(ipeek))
    ui.set_visible(baimlogic, ui.get(ui_tabs) == "ragebot")
    ui.set_visible(baimlogicopts, ui.get(ui_tabs) == "ragebot" and ui.get(baimlogic))
    ui.set_visible(baimhp, ui.get(ui_tabs) == "ragebot" and ui.get(baimlogicopts)[1] and ui.get(baimlogic))
    ui.set_visible(safelogic, ui.get(ui_tabs) == "ragebot")
    ui.set_visible(safelogicopts, ui.get(ui_tabs) == "ragebot" and ui.get(safelogic))
    ui.set_visible(safehp, ui.get(ui_tabs) == "ragebot" and ui.get(safelogic) and ui.get(safelogicopts)[1])
    ui.set_visible(ui_resolver, ui.get(ui_tabs) == "ragebot")
    ui.set_visible(prediction, ui.get(ui_tabs) == "ragebot")
    ui.set_visible(disableinterpolation, ui.get(ui_tabs) == "ragebot")


    --# aa render
    if pressed_open then
        ui.set_visible(close_defensive, ui.get(ui_tabs) == "anti-aim" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
    else
        ui.set_visible(close_defensive, false)
    end
   

    ui.set_visible(ui_aapresets, pressed_close and ui.get(ui_tabs) == "anti-aim" )
    ui.set_visible(teamside, pressed_close and ui.get(ui_tabs) == "anti-aim" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder") 
    ui.set_visible(ui_conditions, pressed_close and ui.get(teamside) == "T"  and ui.get(ui_tabs) == "anti-aim" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder") 
    ui.set_visible(ui_conditions1, pressed_close and ui.get(teamside) == "CT" and ui.get(ui_tabs) == "anti-aim" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder") 
    active_i = var.player_states_idx[ui.get(ui_conditions)]
    active_v = var1.player_states_idx[ui.get(ui_conditions1)]
    for i = 1,8 do
        ui.set_visible(antiaim[i].ui_pitch, pressed_close and active_i == i and pressed_close and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder" ) 
        ui.set_visible(antiaim[i].ui_yawbase,pressed_close and active_i == i and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw,pressed_close and active_i == i and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yaw) == "static" or ui.get(antiaim[i].ui_yaw) == "divine logic") and (ui.get(antiaim[i].ui_yaw) ~= "yaw add left/right" and ui.get(antiaim[i].ui_yaw) ~= "slow-jit meta" and ui.get(antiaim[i].ui_yaw) ~= "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value_jit,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yaw) == "yaw add left/right") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value1,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yaw) == "yaw add left/right") and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "T" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value2,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yaw) == "yaw add left/right") and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "T" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value3,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yaw) == "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value4,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yaw) == "divine meta") and ui.get(ui_tabs) == "anti-aim"   and ui.get(teamside) == "T" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_slowjit_value,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yaw) == "slow-jit meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter,pressed_close and active_i == i and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "T" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_jit,pressed_close and active_i == i and ui.get(antiaim[i].ui_yawjitter) == "dynamic center" and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "T" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_value,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yawjitter) ~= "dynamic center" and ui.get(antiaim[i].ui_yawjitter) ~= "divine meta") and ui.get(antiaim[i].ui_yawjitter) ~= "Off" and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_value1,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yawjitter) == "dynamic center" and ui.get(antiaim[i].ui_yawjitter) ~= "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        --ui.set_visible(antiaim[i].ui_yawjitter_value1, active_i == i and (ui.get(antiaim[i].ui_yawjitter) == "dynamic center" and ui.get(ui_tabs) == "anti-aim"   and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_value2,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yawjitter) == "dynamic center" and ui.get(antiaim[i].ui_yawjitter) ~= "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_value3,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yawjitter) == "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_value4,pressed_close and active_i == i and (ui.get(antiaim[i].ui_yawjitter) == "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
       
        ui.set_visible(antiaim[i].ui_bodyway,pressed_close and active_i == i and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "T" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_bodyway_value,pressed_close and active_i == i and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "T"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_roll_value,pressed_close and active_i == i and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "T" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")

        


        ui.set_visible(antiaim[i].ui_pitch1, pressed_close and active_v == i and pressed_close and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder" ) 
        ui.set_visible(antiaim[i].ui_yawbase1,pressed_close and active_v == i and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw1,pressed_close and active_v == i and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value111,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yaw1) == "static" or ui.get(antiaim[i].ui_yaw1) == "divine logic") and (ui.get(antiaim[i].ui_yaw1) ~= "yaw add left/right" and ui.get(antiaim[i].ui_yaw1) ~= "slow-jit meta" and ui.get(antiaim[i].ui_yaw1) ~= "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value_jit1,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yaw1) == "yaw add left/right") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_slowjit_value1,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yaw1) == "slow-jit meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value11,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yaw1) == "yaw add left/right") and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "CT" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value21,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yaw1) == "yaw add left/right") and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "CT" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value31,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yaw1) == "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yaw_value41,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yaw1) == "divine meta") and ui.get(ui_tabs) == "anti-aim"   and ui.get(teamside) == "CT" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter1,pressed_close and active_v == i and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "CT" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_jit1,pressed_close and active_v == i and ui.get(antiaim[i].ui_yawjitter1) == "dynamic center" and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "CT" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_value111,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yawjitter1) ~= "dynamic center" and ui.get(antiaim[i].ui_yawjitter1) ~= "divine meta") and ui.get(antiaim[i].ui_yawjitter1) ~= "Off" and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_value11,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yawjitter1) == "dynamic center" and ui.get(antiaim[i].ui_yawjitter1) ~= "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        --ui.set_visible(antiaim[i].ui_yawjitter_value1, active_v == i and (ui.get(antiaim[i].ui_yawjitter) == "dynamic center" and ui.get(ui_tabs) == "anti-aim"   and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_value21,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yawjitter1) == "dynamic center" and ui.get(antiaim[i].ui_yawjitter1) ~= "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_value31,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yawjitter1) == "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_yawjitter_value41,pressed_close and active_v == i and (ui.get(antiaim[i].ui_yawjitter1) == "divine meta") and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
       
        ui.set_visible(antiaim[i].ui_bodyway1,pressed_close and active_v == i and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "CT" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_bodyway_value1,pressed_close and active_v == i and ui.get(ui_tabs) == "anti-aim" and ui.get(teamside) == "CT"  and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
        ui.set_visible(antiaim[i].ui_roll_value1,pressed_close and active_v == i and ui.get(ui_tabs) == "anti-aim"  and ui.get(teamside) == "CT" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
    end


    ui.set_visible(ui_defensive_tab, ui.get(ui_tabs) == "anti-aim" and pressed_close and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
    

   -- ui.set_visible(ui_defensive_tab, ui.get(ui_tabs) == "anti-aim" and ui.get(ui_aapresets) == "\aB0CEFFFFbuilder")
    
    
    ui.set_visible(ui_sb_delay, ui.get(ui_tabs) == "anti-aim"   and ui.get(ui_aapresets) == "\aB0CEFFFFsimple \aFFFFFFFFbuilder")
    ui.set_visible(ui_sb_real, ui.get(ui_tabs) == "anti-aim"   and ui.get(ui_aapresets) == "\aB0CEFFFFsimple \aFFFFFFFFbuilder")
    ui.set_visible(ui_sb_yaw, ui.get(ui_tabs) == "anti-aim"   and ui.get(ui_aapresets) == "\aB0CEFFFFsimple \aFFFFFFFFbuilder")
    ui.set_visible(ui_sb_fake, ui.get(ui_tabs) == "anti-aim"   and ui.get(ui_aapresets) == "\aB0CEFFFFsimple \aFFFFFFFFbuilder")

    ui.set_visible(ui_enable_semirage, ui.get(ui_tabs) == "semi-rage")
    --# exploits render
    if pressed_open then
        ui.set_visible(ui_forcedef, pressed_open and ui.get(ui_tabs) == "anti-aim")
        ui.set_visible(ui_defconds, pressed_open and ui.get(ui_forcedef) and ui.get(ui_tabs) == "anti-aim")
        ui.set_visible(ui_defaa, pressed_open and ui.get(ui_tabs) == "anti-aim")
        ui.set_visible(ui_defair, pressed_open and ui.get(ui_defaa) and ui.get(ui_tabs) == "anti-aim")
        ui.set_visible(ui_defdelay, pressed_open and ui.get(ui_defaa) and ui.get(ui_tabs) == "anti-aim")
        ui.set_visible(ui_defpitch, pressed_open and ui.get(ui_defaa) and ui.get(ui_tabs) == "anti-aim")
        ui.set_visible(ui_defyawt, pressed_open and ui.get(ui_defaa) and ui.get(ui_tabs) == "anti-aim")
        ui.set_visible(ui_defyaw, pressed_open and ui.get(ui_defaa) and ui.get(ui_tabs) == "anti-aim")
        ui.set_visible(ui_defyawm, pressed_open and ui.get(ui_defaa) and ui.get(ui_tabs) == "anti-aim")
        ui.set_visible(ui_defyawmo, pressed_open and ui.get(ui_defaa) and ui.get(ui_tabs) == "anti-aim")
        ui.set_visible(ui_defdsy, pressed_open and ui.get(ui_defaa) and ui.get(ui_tabs) == "anti-aim")
        ui.set_visible(ui_defdsya, pressed_open and ui.get(ui_defaa) and ui.get(ui_tabs) == "anti-aim")
    end

    if pressed_close then
        ui.set_visible(ui_forcedef, false)
        ui.set_visible(ui_defconds, false)
        ui.set_visible(ui_defaa, false)
        ui.set_visible(ui_defair, false)
        ui.set_visible(ui_defdelay, false)
        ui.set_visible(ui_defpitch, false)
        ui.set_visible(ui_defyawt, false)
        ui.set_visible(ui_defyaw, false)
        ui.set_visible(ui_defyawm, false)
        ui.set_visible(ui_defyawmo, false)
        ui.set_visible(ui_defdsy, false)
        ui.set_visible(ui_defdsya, false)
    end

    --# visuals render

    ui.set_visible(ui_min_dmg_ind, ui.get(ui_tabs) == "generals")
    ui.set_visible(text_color, ui.get(ui_min_dmg_ind) and ui.get(ui_tabs) == "generals")
    ui.set_visible(eindicatorx, ui.get(ui_tabs) == "generals")
    ui.set_visible(dbgpanel, ui.get(ui_tabs) == "generals")
    ui.set_visible(indoptions, ui.get(ui_tabs) == "generals" and ui.get(eindicatorx))
    ui.set_visible(indicatorx, ui.get(ui_tabs) == "generals" and ui.get(eindicatorx))
    ui.set_visible(indicatorxc, ui.get(ui_tabs) == "generals" and ui.get(eindicatorx))
    ui.set_visible(fs, ui.get(ui_tabs) == "generals")
    ui.set_visible(staticfs, ui.get(ui_tabs) == "generals")

    --# misc render
    ui.set_visible(ui_ui_animsge, ui.get(ui_tabs) == "generals")
    ui.set_visible(ui_animsa, ui.get(ui_tabs) == "generals")
    ui.set_visible(ui_animsg, ui.get(ui_tabs) == "generals")

    --# config render

    ui.set_visible(ui_configs, ui.get(ui_tabs) == "configs")
    ui.set_visible(ui_configs_name, ui.get(ui_tabs) == "configs")
    ui.set_visible(ui_load_cfgs, ui.get(ui_tabs) == "configs")
    ui.set_visible(ui_save_cfgs, ui.get(ui_tabs) == "configs")
    ui.set_visible(ui_delete_cfgs, ui.get(ui_tabs) == "configs")
    ui.set_visible(ui_import_cfgs, ui.get(ui_tabs) == "configs")
    ui.set_visible(ui_export_cfgs, ui.get(ui_tabs) == "configs")
    ui.set_visible(ui_default_cfg, ui.get(ui_tabs) == "configs")

    --# gamesense stuff
    ui.set_visible(refs_aa.enable, false)
    ui.set_visible(refs_aa.yaw[1], false)
    ui.set_visible(refs_aa.yaw[2], false)
    ui.set_visible(refs_aa.bodyyaw[1], false)
    ui.set_visible(refs_aa.bodyyaw[2], false)
    ui.set_visible(refs_aa.roll, false)
    ui.set_visible(refs_aa.yawjitter[1], false)
    ui.set_visible(refs_aa.yawjitter[2], false)
    ui.set_visible(refs_aa.pitch, false)
    ui.set_visible(refs_aa.yawbase, false)
    ui.set_visible(refs_aa.fsbodyyaw, false)
    ui.set_visible(refs_aa.edgeyaw, false)
    ui.set_visible(refs_aa.freestand[1], false)
    ui.set_visible(refs_aa.freestand[2], false)
end

client.set_event_callback("shutdown", function()
    ui.set_visible(refs_aa.enable, true)
    ui.set_visible(refs_aa.yaw[1], true)
    ui.set_visible(refs_aa.yaw[2], true)
    ui.set_visible(refs_aa.bodyyaw[1], true)
    ui.set_visible(refs_aa.bodyyaw[2], true)
    ui.set_visible(refs_aa.roll, true)
    ui.set_visible(refs_aa.yawjitter[1], true)
    ui.set_visible(refs_aa.yawjitter[2], true)
    ui.set_visible(refs_aa.pitch, true)
    ui.set_visible(refs_aa.yawbase, true)
    ui.set_visible(refs_aa.fsbodyyaw, true)
    ui.set_visible(refs_aa.edgeyaw, true)
    ui.set_visible(refs_aa.freestand[1], true)
    ui.set_visible(refs_aa.freestand[2], true)
end)

client.set_event_callback("paint_ui", function()
    on_load()

end)

client.set_event_callback("paint", function(cmd)
    ctx.indicators:render()
    defensive_indicator_paint()
    defensive_indicator()
    watermark()
end)


client.set_event_callback("setup_command", function(cmd)
    antiaim_enable(cmd)
    interpolate()
    impprediction()
end)

ui.update(ui_configs, get_config_list())

--ui.set(ui_configs_name, #database.read(div.database.configs) == 0 and "" or database.read(div.database.configs)[ui.get(ui_configs_name)+1].name)

ui.set_callback(ui_load_cfgs, function()
    local name = ui.get(ui_configs_name)
    if name == "" then return end

    local protected = function()
        load_config(name)
    end

    if pcall(protected) then
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Successfully loaded the config \aB0CEFF"..name) 
    else
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Failed to load the config \aB0CEFF"..name) 
    end
end)

ui.set_callback(ui_save_cfgs, function()
    local name = ui.get(ui_configs_name)
    if name == "" then return end

    if name:match("[^%w]") ~= nil then
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Failed to save config because it contains invalid characters") 
        return
    end

    local protected = function()
        save_config(name)
    end

    if pcall(protected) then
        ui.update(ui_configs, get_config_list())

       printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Successfully saved the config \aB0CEFF"..name) 
    else
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Failed to save the config \aB0CEFF"..name) 
    end
end)

ui.set_callback(ui_delete_cfgs, function()
    local name = ui.get(ui_configs_name)
    if name == "" then return end

    if delete_config(name) == false then
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Failed to delete the config \aB0CEFF"..name) 
        ui.update(ui_configs, get_config_list())
        return
    end
    
    local protected = function()
        delete_config(name)
    end

    if pcall(protected) then
        ui.update(ui_configs, get_config_list())
        ui.set(ui_configs, #div.presets + #database.read(div.database.configs) - #database.read(div.database.configs))
        ui.set(ui_configs_name, #database.read(div.database.configs) == 0 and "" or get_config_list()[#div.presets + #database.read(div.database.configs) - #database.read(div.database.configs)+1])
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Successfully deleted the config \aB0CEFF"..name) 
    else
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Failed to delete the config \aB0CEFF"..name)
    end
end)

ui.set_callback(ui_import_cfgs, function()
    local protected = function()
       import_settings()
    end

    if pcall(protected) then
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Successfully imported the settings")
    else
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Failed to import the settings")
    end
end)

ui.set_callback(ui_export_cfgs, function()
    local protected = function()
        export_settings(name)
    end

    if pcall(protected) then
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Successfully exported the settings")
    else
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Failed to export the settings") 
    end
end)

function load_default()
    local config = "Y29uZmlnczp0cnVlOmZhbHNlOnRydWU6dHJ1ZTpmYWxzZToHQjBDRUZGRkZkb3VibGUHRkZGRkZGRkYgdGFwOmZhbHNlOm5pbDo5MDpmYWxzZTpuaWw6OTA6VDoHQjBDRUZGRkZidWlsZGVyOnQtZmFrZWNyb3VjaDpjdC1mYWtlY3JvdWNoOjI6MDo0NTotOTA6dHJ1ZToHQjBDRUZGRkZJbiAHRkZGRkZGRkZBaXJ8B0IwQ0VGRkZGT24gB0ZGRkZGRkZGcGVla2luZzpmYWxzZTpmYWxzZToxMDA6b2ZmOm9mZjowOm9mZjowOnN0YXRpYzowOnRydWU6MTc2Om9sZDoHQjBDRUZGRkZkb3VibGUHRkZGRkZGRkYgdGFwfAdCMENFRkZGRmhpZGUHRkZGRkZGRkYgc2hvdHN8B0IwQ0VGRkZGcGluZwdGRkZGRkZGRiBzcGlrZXwHQjBDRUZGRkZkYW0HRkZGRkZGRkZhZ2V8B0IwQ0VGRkZGZnJlZQdGRkZGRkZGRnN0YW5kaW5nfAdCMENFRkZGRmZha2UgB0ZGRkZGRkZGZHVjazp0cnVlOjE3NjpmYWxzZTp0cnVlOnRydWU6cGl0Y2ggMCBvbiBncm91bmR8YW5pbWF0ZSBtb3ZlIGxlYW46bW9vbndhbGsgaW4gYWlyOm1vb253YWxrOmRlZmF1bHQ6YXQgdGFyZ2V0czpkaXZpbmUgbWV0YTo1OjE6NDU6MToxOi0yNzozOmRpdmluZSBtZXRhOjU6MToxOjE6LTc6MTc6ZGl2aW5lIGxvZ2ljOjE2NzowOmRlZmF1bHQ6YXQgdGFyZ2V0czpzbG93LWppdCBtZXRhOjU6MTo5OjE6MToxOjE6ZGl2aW5lIG1ldGE6NToxOjE6MTotMzE6MjU6ZGl2aW5lIGxvZ2ljOjE3MzowOmRlZmF1bHQ6YXQgdGFyZ2V0czpzbG93LWppdCBtZXRhOjU6MToxMDoxOjE6MToxOmR5bmFtaWMgY2VudGVyOjM6MTotMzE6NzoxOjE6ZGl2aW5lIG1ldGE6MTcxOjA6ZGVmYXVsdDphdCB0YXJnZXRzOnlhdyBhZGQgbGVmdC9yaWdodDoyOjE6NDU6Mjc6LTMxOjE6MTpkaXZpbmUgbWV0YTo1Oi03OjE6MTotMTU6OTpkaXZpbmUgbG9naWM6MTU5OjA6ZGVmYXVsdDphdCB0YXJnZXRzOmRpdmluZSBtZXRhOjU6MTo0NToxOjE6LTE1OjIzOmRpdmluZSBsb2dpYzo1OjExOjE6MToxOjE6ZGl2aW5lIGxvZ2ljOjE2NTowOmRlZmF1bHQ6YXQgdGFyZ2V0czpzbG93LWppdCBtZXRhOjU6MToxNDoxOjE6MToxOmR5bmFtaWMgY2VudGVyOjI6MToyNTotMzM6MToxOmRpdmluZSBsb2dpYzoxNjk6MDpkZWZhdWx0OmF0IHRhcmdldHM6c2xvdy1qaXQgbWV0YTo1OjE6MTQ6MToxOjE6MTpkeW5hbWljIGNlbnRlcjo0OjE6LTE3OjE3OjE6MTpkaXZpbmUgbWV0YToxNzM6MDpkZWZhdWx0OmF0IHRhcmdldHM6eWF3IGFkZCBsZWZ0L3JpZ2h0OjM6MTo0NToyOTotMTM6MToxOmRpdmluZSBtZXRhOjU6MToxOjE6LTEzOjMzOmRpdmluZSBsb2dpYzoxNzc6MDpkZWZhdWx0OmF0IHRhcmdldHM6ZGl2aW5lIG1ldGE6NToxOjQ1OjE6MTotMTU6MTE6ZHluYW1pYyBjZW50ZXI6MjoxOi0xNzo5OjE6MTpkaXZpbmUgbG9naWM6MTY5OjA6ZGVmYXVsdDphdCB0YXJnZXRzOnlhdyBhZGQgbGVmdC9yaWdodDozOjE6NDU6LTE3OjExOjE6MTpkaXZpbmUgbWV0YTo1OjE6MToxOi0yNToxNTpkaXZpbmUgbG9naWM6MTc1OjA6ZGVmYXVsdDphdCB0YXJnZXRzOnNsb3ctaml0IG1ldGE6NToxOjE0OjE6MToxOjE6ZHluYW1pYyBjZW50ZXI6NDoxOi0xNToyNToxOjE6ZGl2aW5lIGxvZ2ljOjE2NTowOmRlZmF1bHQ6YXQgdGFyZ2V0czpzbG93LWppdCBtZXRhOjU6MTo2OjE6MToxOjE6ZHluYW1pYyBjZW50ZXI6MzoxOi0zMTo5OjE6MTpkaXZpbmUgbWV0YToxMzowOmRlZmF1bHQ6YXQgdGFyZ2V0czpkaXZpbmUgbWV0YTo1OjE3OjQ1OjE6MTotMjM6MTM6ZHluYW1pYyBjZW50ZXI6NDotOTotMjM6MTc6MToxOmRpdmluZSBtZXRhOjE2OTowOmRlZmF1bHQ6YXQgdGFyZ2V0czpkaXZpbmUgbWV0YTo1OjE6NDU6MToxOjEzOi0xMTpkaXZpbmUgbWV0YTo1OjE6MToxOi0yMzoxMTpkaXZpbmUgbG9naWM6MTczOjA6ZGVmYXVsdDphdCB0YXJnZXRzOnlhdyBhZGQgbGVmdC9yaWdodDo0OjE6NDU6LTE3Ojk6MToxOmRpdmluZSBtZXRhOjU6MToxOjE6LTExOjI5OmRpdmluZSBtZXRhOjE3NTowOmRlZmF1bHQ6YXQgdGFyZ2V0czpkaXZpbmUgbWV0YTo1Ojk6MjU6MToxOi0yMzoyMTpkeW5hbWljIGNlbnRlcjo0OjE6LTMxOjEzOjE6MTpkaXZpbmUgbG9naWM6MTY3OjA="
    local decoded = base64.decode(config)
    load_settings(decoded)
end

ui.set_callback(ui_default_cfg, function()
    local protected = function()
        load_default()
    end

    if pcall(protected) then
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Successfully loaded the default settings")
    else
        printc("\aFFFFFF[\aB0CEFFdivine\aFFFFFF] Failed to load the default settings") 
    end
end)

ui.set_callback(ui_defensive_tab, function()
    pressed_open = true
    pressed_close = false

end)
ui.set_callback(close_defensive, function()
    pressed_close = true
    pressed_open = false
    
end)

ui.set(ui_configs_name, get_config_list()[1])


local prev_selected_index = ui.get(ui_configs)

ui.set_callback(ui_configs, function()
    local selected_index = ui.get(ui_configs) + 1
    local selected_name = get_config_list()[selected_index]
    if selected_name then
        ui.set(ui_configs_name, selected_name)
        prev_selected_index = selected_index
    else
        ui.set(ui_configs_name, get_config_list()[prev_selected_index])
    end
end)

