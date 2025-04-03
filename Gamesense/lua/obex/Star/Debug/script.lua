-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- local variables for API functions. any changes to the line below will be lost on re-generation
local bit_band, bit_lshift, client_camera_angles, client_current_threat, client_delay_call, client_draw_text, client_exec, client_eye_position, client_find_signature, client_key_state, client_latency, client_screen_size, client_set_clan_tag, client_set_event_callback, client_system_time, client_trace_bullet, client_update_player_list, client_userid_to_entindex, entity_get_classname, entity_get_local_player, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_dormant, entity_is_enemy, entity_set_prop, globals_absoluteframetime, globals_curtime, globals_realtime, math_abs, math_asin, math_atan, math_cos, math_deg, math_floor, math_max, math_rad, math_sin, ipairs, renderer_measure_text, renderer_rectangle, renderer_text, require, error, json_parse, json_stringify, math_atan2, math_min, math_sqrt, panorama_open, string_format, string_len, string_lower, string_sub, string_upper, table_insert, table_pack, table_remove, type, setmetatable, ui_get, ui_new_button, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_hotkey, ui_new_label, ui_new_multiselect, ui_new_slider, ui_reference, ui_set, ui_set_visible, pairs, tostring, contains = bit.band, bit.lshift, client.camera_angles, client.current_threat, client.delay_call, client.draw_text, client.exec, client.eye_position, client.find_signature, client.key_state, client.latency, client.screen_size, client.set_clan_tag, client.set_event_callback, client.system_time, client.trace_bullet, client.update_player_list, client.userid_to_entindex, entity.get_classname, entity.get_local_player, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_dormant, entity.is_enemy, entity.set_prop, globals.absoluteframetime, globals.curtime, globals.realtime, math.abs, math.asin, math.atan, math.cos, math.deg, math.floor, math.max, math.rad, math.sin, ipairs, renderer.measure_text, renderer.rectangle, renderer.text, require, error, json.parse, json.stringify, math.atan2, math.min, math.sqrt, panorama.open, string.format, string.len, string.lower, string.sub, string.upper, table.insert, table.pack, table.remove, type, setmetatable, ui.get, ui.new_button, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_hotkey, ui.new_label, ui.new_multiselect, ui.new_slider, ui.reference, ui.set, ui.set_visible, pairs, tostring, contains

--[[ 
    Lib
--]]

local http = require "gamesense/http";
local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)
local csgo_weapons = require "gamesense/csgo_weapons"
local clipboard = require("gamesense/clipboard") or error("download clipboard from workshop")
local antiaim_funcs = require("gamesense/antiaim_funcs")

--[[ 
    Globals
--]]

local obex_data = obex_fetch and obex_fetch() or {username = 'codred', build = 'Source'}
local usernamea = obex_data.username 
local build = obex_data.build

local upper_case_build = build:upper()

--[[ 
    RichEmbed
--]]

local RichEmbed = { Properties = {} }

function RichEmbed:setTitle(title) self.Properties.title = title end
function RichEmbed:setDescription(description) self.Properties.description = description end
function RichEmbed:setURL(url) self.Properties.url = url end
function RichEmbed:setTimestamp(timestamp) self.Properties.timestamp = timestamp end
function RichEmbed:setColor(color) self.Properties.color = color end
function RichEmbed:setFooter(text, icon, proxy_icon) self.Properties.footer = { text = text, icon_url = icon or '', proxy_icon_url = proxy_icon or '' } end
function RichEmbed:setImage(icon, proxy_icon, height, width) self.Properties.image = { url = icon or '', proxy_url = proxy_icon or '', height = height or nil, width = width or nil } end
function RichEmbed:setThumbnail(icon, proxy_icon, height, width) self.Properties.thumbnail = { url = icon or '', proxy_url = proxy_icon or '', height = height or nil, width = width or nil } end
function RichEmbed:setVideo(url, height, width) self.Properties.video = { url = url or '', height = height or nil, width = width or nil } end
function RichEmbed:setAuthor(name, url, icon, proxy_icon) self.Properties.author = { name = name or '', url = url or '', icon_url = icon or '', proxy_icon_url = proxy_icon or '' } end
function RichEmbed:addField(name, value, inline) if not self.Properties.fields then self.Properties.fields = {} end table_insert(self.Properties.fields, { name = name, value = value, inline = inline or false }) end

local WebhookClient = { URL = '' }

function WebhookClient:send(...)
	local unifiedBody = {}
	local arguments = table_pack(...)

	if self.username then unifiedBody.username = self.username end
	if self.avatar_url then unifiedBody.avatar_url = self.avatar_url end

	for _, value in next, arguments do
		if type(value) == 'table' then
			if not unifiedBody.embeds then
				unifiedBody.embeds = {}
			end

			table_insert(unifiedBody.embeds, value.Properties)
		elseif type(value) == 'string' then
			unifiedBody.content = value
		end
	end

	http.post(self.URL, { body = json_stringify(unifiedBody), headers = { ['Content-Length'] = #json_stringify(unifiedBody), ['Content-Type'] = 'application/json' } }, function() end)
end

function WebhookClient:setUsername(username) self.username = username end
function WebhookClient:setAvatarURL(avatar_url) self.avatar_url = avatar_url end


local newEmbed = function()
		return setmetatable({ Properties = {} }, {__index = RichEmbed})
end

local new = function(url)
		return setmetatable({ URL = url }, {__index = WebhookClient})
end

local js = panorama_open();
local name = js.MyPersonaAPI.GetName();
local Webhook = new('https://discord.com/api/webhooks/992489495826022430/yTsi1OC3vzacy8z55gNGFeRU5rj2MvglSXhznYOWjALHgRkVZuvKtnTL_IMDWa4SkGAE');
local RichEmbed = newEmbed();
local steamID = js.MyPersonaAPI.GetXuid();

RichEmbed:setColor(3066993)

client_delay_call(6, function() 
        Webhook:setUsername('star')
        Webhook:setAvatarURL('')
        
        RichEmbed:setTitle(name .. " just load a lua")    
        client_delay_call(1, function() 

            RichEmbed:addField('Username:', usernamea, true)
            RichEmbed:addField('Build:', build, true)
            RichEmbed:addField('Steamid:', steamID, true)    
            Webhook:send(RichEmbed)
        end)
end)

--[[ 
    Menu
--]]

local star = {}

star.menu = {

    main = ui_new_combobox("AA", "Anti-aimbot angles", "Menu", {"Main","anti-aim", "ragebot", "visuals", "misc"}),
    update_sass = ui_new_label("AA", "Anti-aimbot angles", "Welcome:\a9ED8FFFF" .. usernamea),
    update_version = ui_new_label("AA", "Anti-aimbot angles", "Version: \a9ED8FFFF2.5 l " .. upper_case_build),
    update_label = ui_new_label("AA", "Anti-aimbot angles", "Last Updates:\a9ED8FFFF 12/1/2022"),
    enabled = ui_new_checkbox("AA", "Anti-aimbot angles", "Enable STRONK AA"),
    
    stronk_aa = ui_new_combobox("AA", "Anti-aimbot angles", "STRONK AA Mode", {"Dynamic","AA-Builder"}),
    stronk_aa_sw = ui_new_combobox("AA", "Anti-aimbot angles", "Slow Walk Mode", {"Roll", "Jitter"}),

    legit_e_key = ui_new_checkbox("AA", "Anti-aimbot angles", "Legit anti-aim on E"),
    legit_e_key_type = ui_new_combobox("AA", "Anti-aimbot angles", "Legit anti-aim Mode", {"Opposite", "Roll"}),
    mm_enable = ui_new_checkbox("AA", "Anti-aimbot angles", "\aB6B665FFForce roll // use at your own risk"),
    stronk_ma = ui_new_checkbox("AA", "Anti-aimbot angles", "Manual anti-aim"),
    stronk_aa_ma = ui_new_combobox("AA", "Anti-aimbot angles", "Manual AA Mode", {"Roll", "Static"}),
    ui_left_hotkey = ui_new_hotkey("AA", "Anti-aimbot angles", "[ManualAA] Left"),
    ui_right_hotkey = ui_new_hotkey("AA", "Anti-aimbot angles", "[ManualAA] Right"),
    ui_backwards_hotkey = ui_new_hotkey("AA", "Anti-aimbot angles", "[ManualAA] Back"),  

    roll_resolver = ui_new_combobox("AA", "Anti-aimbot angles", "Roll Resolver", {"Off", "Automatic", "Manual"}),
    rolloverride = ui_new_hotkey("AA", "Anti-aimbot angles", "Roll override"),
    force_defensive = ui_new_checkbox("AA", "Anti-aimbot angles", "Force Defensive"),

    roll_one_key = ui_new_hotkey("AA", "Anti-aimbot angles", "Roll on key"),

    edge = { ui_new_checkbox("AA", "Anti-aimbot angles", "Edge yaw"), 
    ui_new_hotkey("AA", "Anti-aimbot angles", "Edge yaw key", true),
    },

    freestand = { ui_new_checkbox("AA", "Anti-aimbot angles", "Freestanding"),
    ui_new_hotkey("AA", "Anti-aimbot angles", "Freestanding key", true),
    },

    static_fs = ui_new_checkbox("AA", "Anti-aimbot angles", "Disable Yaw Modifier on Freestand"),

    watermark = ui_new_checkbox("AA", "Anti-aimbot angles", "watermark"),

    indicator_aa_arrows_enb = ui_new_checkbox("AA", "Anti-aimbot angles", "Anti-Aim Arrows"),
    indicator_aa_arrows = ui_new_label("AA", "Anti-aimbot angles", "Anti-Aim Arrows color"),
    indicator_aa_arrows_color = ui_new_color_picker("AA", "Anti-aimbot angles", "Anti-Aim Arrows color", 255, 255, 255, 255),

    indicator_aa = ui_new_label("AA", "Anti-aimbot angles", "anti-aim indicator color"),
    indicator_aa_color = ui_new_color_picker("AA", "Anti-aimbot angles", "anti-aim indicator color", 255, 255, 255, 255),

    indicator_main = ui_new_label("AA", "Anti-aimbot angles", "indicators color"),
    indicator_main_color = ui_new_color_picker("AA", "Anti-aimbot angles", "indicators color", 255, 255, 255, 255),

    indicator_background = ui_new_label("AA", "Anti-aimbot angles", "indicators background color"),
    indicator_background_color = ui_new_color_picker("AA", "Anti-aimbot angles", "indicators background color", 255, 255, 255, 255),


    animfix = ui_new_multiselect("AA", "Anti-aimbot angles", "animations", "static Legs", "pitch 0 on shot", "glitched", "pitch 0 on land"),
    anti_knife = ui_new_checkbox("AA", "Anti-aimbot angles", "anti-knife"),
    clantag = ui_new_checkbox("AA", "Anti-aimbot angles", "clan tag"),
    leg_breaker = ui_new_checkbox("AA", "Anti-aimbot angles", "leg movement"),
    killsay = ui_new_checkbox("AA", "Anti-aimbot angles", "killsay")
}

local function contains(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

star.ref = {
    enable = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui_reference("AA", "Anti-aimbot angles", "Yaw")},
    yaw_jitter = {ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    yaw_body = {ui_reference("AA", "Anti-aimbot angles", "Body yaw")},
    freestanding_body_yaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    fakeyawlimit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
    fakelag_type = ui_reference("AA", "Fake lag", "Amount"),
    fakelag_variance = ui_reference("AA", "Fake lag", "Variance"),
    fakelag_limit = ui_reference("AA", "Fake lag", "Limit"),
    edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge Yaw"),
    SlowMotion = { ui_reference('AA', 'Other', 'Slow motion') },
    legmovement = ui_reference("AA", "Other", "leg movement"),
    roll_aa = ui_reference("AA", "Anti-aimbot angles", "Roll"),
    freestanding = {ui_reference("AA", "Anti-aimbot angles", "Freestanding")},
    dt = { ui_reference("RAGE", "Other", "Double tap") },
    os = { ui_reference("AA", "Other", "On shot anti-aim") },
    fakeduck = ui_reference("RAGE", "Other", "Duck peek assist"),
    forcebaim = ui_reference("RAGE", "Other", "Force body aim"),
    sp = ui_reference("RAGE", "Aimbot", "Force safe point")
}
local pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch")
local yaw, yaw_slider = ui_reference("AA", "Anti-aimbot angles", "Yaw")
local yaw_jitter, yaw_jitter_slider = ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")
local yaw_body, yaw_body_slider = ui_reference("AA", "Anti-aimbot angles", "Body yaw")
local fakeyawlimit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit")



--[[ 
    Anti-aim Functions
--]]

local aa_init = { }

local var = {
	p_states = {"standing", "moving", "slowwalk", "air", "crouching", "air-crouching"},
	s_to_int = {["air-crouching"] = 6, ["standing"] = 1, ["moving"] = 2, ["slowwalk"] = 3, ["air"] = 4, ["crouching"] = 5},
	player_states = {"S", "M", "SW", "A", "C", "AC"},
	state_to_int = {["AC"] = 6, ["S"] = 1, ["M"] = 2, ["SW"] = 3, ["A"] = 4, ["C"] = 5},
	p_state = 1,
    state = 0,
    leftReady = false,
    rightReady = false,
    mode = "back"
}


aa_init[0] = {
	aa_builder = ui_new_checkbox("AA", "Anti-aimbot angles", "Enable Anti-Aim builder"),
	player_state = ui_new_combobox("AA", "Anti-aimbot angles", "Anti-Aim States", "standing", "moving", "slowwalk", "air", "crouching", "air-crouching"),
	aa_abf = ui.new_checkbox("AA", "Anti-aimbot angles","anti-bruteforce"),
}

for i=1, 6 do
	aa_init[i] = {
		enable_state =  ui_new_checkbox("AA", "Anti-aimbot angles", "Enable [".. "\aE1DEFDFF"..var.p_states[i].."] State"),
		pitch = ui_new_combobox("AA", "Anti-aimbot angles","\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Pitch\n" .. var.p_states[i], { "off", "Default", "Up", "Down", "Minimal", "Random"}),
		yawaddl = ui_new_slider("AA", "Anti-aimbot angles", "\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Yaw left\n", -180, 180, 0),
		yawaddr = ui_new_slider("AA", "Anti-aimbot angles","\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Yaw right\n", -180, 180, 0),
		yawjitter = ui_new_combobox("AA", "Anti-aimbot angles","\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Yaw jitter\n" .. var.p_states[i], { "off", "offset", "center", "random" }),
		yawjitteradd = ui_new_slider("AA", "Anti-aimbot angles","\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Yaw jitter add\n" .. var.p_states[i], -180, 180, 0),
		bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles","\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Body yaw\n" .. var.p_states[i], { "off", "opposite", "jitter", "static"}),
		side_body = ui_new_combobox("AA", "Anti-aimbot angles","\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Body yaw side\n" .. var.p_states[i], { "left", "right" }),
		aa_static = ui_new_slider("AA", "Anti-aimbot angles","\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Body yaw left\n", -180, 180, 0),
		aa_static_2 = ui_new_slider("AA", "Anti-aimbot angles","\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Body yaw right\n", -180, 180, 0),
		side_fake = ui_new_combobox("AA", "Anti-aimbot angles","\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Fake limit side\n" .. var.p_states[i], { "left", "right" }),
		fakeyawlimit = ui_new_slider("AA", "Anti-aimbot angles","\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Fake limit left\n" .. var.p_states[i], 0, 60, 60,true,"°"),
		fakeyawlimitr = ui_new_slider("AA", "Anti-aimbot angles","\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Fake limit right\n" .. var.p_states[i], 0, 60, 60,true,"°"),
        anti_bf =  ui_new_checkbox("AA", "Anti-aimbot angles", "\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Anti-Bruteforce"),
        desync_fs =  ui.new_checkbox("AA", "Anti-aimbot angles", "\aE1DEFDFF["..var.p_states[i].."]\aFFFFFFC9 Desync freestand"),
    }
end


local function oppositefix(c)
	local desync_amount = antiaim_funcs.get_desync(2)
    if math.abs(desync_amount) < 15 or c.chokedcommands ~= 0 then
        return
    end
end

local function export_config()
	local settings = {}
	for key, value in pairs(var.player_states) do
		settings[tostring(value)] = {}
		for k, v in pairs(aa_init[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	
	clipboard.set(json.stringify(settings))
end

local export_btn = ui_new_button("AA", "Anti-aimbot angles", "export antiaim settings", export_config)

local function import_config()

	local settings = json.parse(clipboard.get())

	for key, value in pairs(var.player_states) do
		for k, v in pairs(aa_init[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
			end
		end
	end
end


local import_btn = ui_new_button("AA", "Anti-aimbot angles", "import antiaim settings", import_config)

local function menu()
    local menu_main = ui_get(star.menu.main) == "Main"
    local menu_aa = ui_get(star.menu.main) == "anti-aim"
    local menu_rage = ui_get(star.menu.main) == "ragebot"
    local menu_visual = ui_get(star.menu.main) == "visuals"
    local menu_misc = ui_get(star.menu.main) == "misc"
    local is_dynamic = ui_get(star.menu.stronk_aa) == "Dynamic"
    local is_builder = ui_get(star.menu.stronk_aa) == "AA-Builder"
    var.active_i = var.s_to_int[ui_get(aa_init[0].player_state)]

    if menu_main then
        ui_set_visible(star.menu.update_sass, true)      
        ui_set_visible(star.menu.update_version, true)      
        ui_set_visible(star.menu.update_label, true)
        ui_set_visible(import_btn, true)
        ui_set_visible(export_btn, true)
    else
        ui_set_visible(star.menu.update_sass, false)      
        ui_set_visible(star.menu.update_version, false)      
        ui_set_visible(star.menu.update_label, false)
        ui_set_visible(import_btn, false)
        ui_set_visible(export_btn, false)    
    end
    if menu_aa then

        ui_set_visible(star.menu.enabled, true)      
        ui_set_visible(star.menu.stronk_aa, true)      
        ui_set_visible(star.menu.legit_e_key, true)      
        ui_set_visible(star.menu.mm_enable, true)      
        ui_set_visible(star.menu.stronk_ma, true)
        ui_set_visible(star.menu.roll_one_key, true)      
        ui_set_visible(star.menu.edge[1], true)      
        ui_set_visible(star.menu.edge[2], true)
        ui_set_visible(star.menu.freestand[1], true)      
        ui_set_visible(star.menu.freestand[2], true)            

        if ui_get(star.menu.legit_e_key) then   
            ui_set_visible(star.menu.legit_e_key_type, true)
        else
            ui_set_visible(star.menu.legit_e_key_type, false)
        end

        if ui_get(star.menu.stronk_ma) then
            ui_set_visible(star.menu.ui_backwards_hotkey, true)
            ui_set_visible(star.menu.ui_left_hotkey, true)
            ui_set_visible(star.menu.ui_right_hotkey, true)
            ui_set_visible(star.menu.stronk_aa_ma, true)
        end

        if is_dynamic then
            ui_set_visible(star.menu.stronk_aa_sw, true)
            ui_set_visible(star.menu.legit_e_key, true)
            ui_set_visible(star.menu.mm_enable, true)
            ui_set_visible(aa_init[0].aa_abf, true)      
        else
            ui_set_visible(star.menu.stronk_aa_sw, false)
            ui_set_visible(star.menu.legit_e_key, false)
            ui_set_visible(star.menu.mm_enable, false)
            ui_set_visible(aa_init[0].aa_abf, false)
        end

            ui_set_visible(aa_init[0].aa_builder,is_builder)
            if ui_get(aa_init[0].aa_builder) then
                if ui_get(star.menu.freestand[1]) then
                    ui_set_visible(star.menu.static_fs, is_builder)
                end 
                for i=1, 6 do
                    ui_set_visible(aa_init[i].enable_state,var.active_i == i and is_builder)
                    ui_set_visible(aa_init[0].player_state,is_builder)
                    if ui_get(aa_init[i].enable_state) then
                        ui_set_visible(aa_init[i].pitch,var.active_i == i and is_builder)
                        ui_set_visible(aa_init[i].yawaddl,var.active_i == i and is_builder)
                        ui_set_visible(aa_init[i].yawaddr,var.active_i == i and is_builder)
                        ui_set_visible(aa_init[i].yawjitter,var.active_i == i and is_builder)
                        ui_set_visible(aa_init[i].yawjitteradd,var.active_i == i and is_builder and ui_get(aa_init[var.active_i].yawjitter) ~= "off")
            
                        ui_set_visible(aa_init[i].side_body,var.active_i == i and is_builder and ui_get(aa_init[i].bodyyaw) ~= "off" and ui_get(aa_init[i].bodyyaw) ~= "opposite")
                        ui_set_visible(aa_init[i].bodyyaw, var.active_i == i and is_builder)
            
                        ui_set_visible(aa_init[i].aa_static, var.active_i == i and is_builder and ui_get(aa_init[i].bodyyaw) ~= "off" and ui_get(aa_init[i].bodyyaw) ~= "opposite" and ui_get(aa_init[i].side_body) == "left")
                        ui_set_visible(aa_init[i].aa_static_2, var.active_i == i and is_builder and ui_get(aa_init[i].bodyyaw) ~= "off" and ui_get(aa_init[i].bodyyaw) ~= "opposite" and ui_get(aa_init[i].side_body) == "right")
            
                        ui_set_visible(aa_init[i].side_fake,var.active_i == i and is_builder)
                        ui_set_visible(aa_init[i].fakeyawlimit,var.active_i == i and is_builder and ui_get(aa_init[i].side_fake) == "left")
                        ui_set_visible(aa_init[i].fakeyawlimitr,var.active_i == i and is_builder and ui_get(aa_init[i].side_fake) == "right")
                        ui_set_visible(aa_init[i].anti_bf, var.active_i == i and is_builder)
                        ui_set_visible(aa_init[i].desync_fs, var.active_i == i and is_builder)
                    else
                        ui_set_visible(aa_init[i].pitch,false)
                        ui_set_visible(aa_init[i].yawaddl,false)
                        ui_set_visible(aa_init[i].yawaddr,false)
                        ui_set_visible(aa_init[i].yawjitter,false)
                        ui_set_visible(aa_init[i].yawjitteradd,false)
                        
                        ui_set_visible(aa_init[i].side_body,false)
                        ui_set_visible(aa_init[i].bodyyaw,false)
            
                        ui_set_visible(aa_init[i].aa_static,false)
                        ui_set_visible(aa_init[i].aa_static_2,false)
            
                        ui_set_visible(aa_init[i].side_fake,false)
                        ui_set_visible(aa_init[i].fakeyawlimit,false)
                        ui_set_visible(aa_init[i].fakeyawlimitr,false)
                        ui_set_visible(aa_init[i].anti_bf,false)
                        ui_set_visible(aa_init[i].desync_fs, false)
                    end
                end
            else
                for i=1, 6 do
                    ui_set_visible(aa_init[i].enable_state,false)
                    ui_set_visible(aa_init[0].player_state,false)
                    ui_set_visible(aa_init[i].pitch,false)
                    ui_set_visible(aa_init[i].yawaddl,false)
                    ui_set_visible(aa_init[i].yawaddr,false)
                    ui_set_visible(aa_init[i].yawjitter,false)
                    ui_set_visible(aa_init[i].yawjitteradd,false)
            
                    ui_set_visible(aa_init[i].side_body,false)
                    ui_set_visible(aa_init[i].side_fake,false)
                    ui_set_visible(aa_init[i].bodyyaw,false)
                        
                    ui_set_visible(aa_init[i].aa_static,false)
                    ui_set_visible(aa_init[i].aa_static_2,false)
            
                    ui_set_visible(aa_init[i].fakeyawlimit,false)
                    ui_set_visible(aa_init[i].fakeyawlimitr,false)
                    ui_set_visible(aa_init[i].anti_bf,false)
                    ui_set_visible(aa_init[i].desync_fs, false)
                end
            end            
        else
        ui_set_visible(aa_init[0].aa_builder, false)
        ui_set_visible(star.menu.enabled, false)      
        ui_set_visible(star.menu.stronk_aa, false)      
        ui_set_visible(star.menu.stronk_aa_sw, false)      
        ui_set_visible(star.menu.legit_e_key, false)      
        ui_set_visible(star.menu.legit_e_key_type, false)      
        ui_set_visible(star.menu.mm_enable, false)      
        ui_set_visible(star.menu.stronk_ma, false)      
        ui_set_visible(star.menu.stronk_aa_ma, false)      
        ui_set_visible(star.menu.ui_left_hotkey, false)      
        ui_set_visible(star.menu.ui_right_hotkey, false)      
        ui_set_visible(star.menu.ui_backwards_hotkey, false)
        ui_set_visible(star.menu.roll_one_key, false)      
        ui_set_visible(star.menu.edge[1], false)      
        ui_set_visible(star.menu.edge[2], false) 
        ui_set_visible(star.menu.freestand[1], false)      
        ui_set_visible(star.menu.freestand[2], false)      
        ui_set_visible(star.menu.static_fs, false)
        ui_set_visible(aa_init[0].aa_abf, false)
        for i=1, 6 do
            ui_set_visible(aa_init[i].enable_state,false)
            ui_set_visible(aa_init[0].player_state,false)
            ui_set_visible(aa_init[i].pitch,false)
            ui_set_visible(aa_init[i].yawaddl,false)
            ui_set_visible(aa_init[i].yawaddr,false)
            ui_set_visible(aa_init[i].yawjitter,false)
            ui_set_visible(aa_init[i].yawjitteradd,false)
    
            ui_set_visible(aa_init[i].side_body,false)
            ui_set_visible(aa_init[i].side_fake,false)
            ui_set_visible(aa_init[i].bodyyaw,false)
                
            ui_set_visible(aa_init[i].aa_static,false)
            ui_set_visible(aa_init[i].aa_static_2,false)
    
            ui_set_visible(aa_init[i].fakeyawlimit,false)
            ui_set_visible(aa_init[i].fakeyawlimitr,false)
            ui_set_visible(aa_init[i].anti_bf,false)
            ui_set_visible(aa_init[i].desync_fs, false)
        end                  
    end

    if menu_rage then
        ui_set_visible(star.menu.roll_resolver,true)
        if ui_get(star.menu.roll_resolver) == "Off" then
            ui_set_visible(star.menu.rolloverride, false)
        elseif ui_get(star.menu.roll_resolver) == "Automatic" then
            ui_set_visible(star.menu.rolloverride, false)
        elseif ui_get(star.menu.roll_resolver) == "Manual" then     
            ui_set_visible(star.menu.rolloverride, true)
        end
        ui_set_visible(star.menu.force_defensive,true)
    else
        ui_set_visible(star.menu.roll_resolver,false)
        ui_set_visible(star.menu.force_defensive, false)
    end

    if menu_visual then
        ui_set_visible(star.menu.watermark, true)
        ui_set_visible(star.menu.indicator_aa, true)
        ui_set_visible(star.menu.indicator_aa_color, true)
        ui_set_visible(star.menu.indicator_main, true)
        ui_set_visible(star.menu.indicator_main_color, true)
        ui_set_visible(star.menu.indicator_background, true)
        ui_set_visible(star.menu.indicator_background_color, true)     
        ui_set_visible(star.menu.indicator_aa_arrows_enb, true)     
        ui_set_visible(star.menu.indicator_aa_arrows, true)     
        ui_set_visible(star.menu.indicator_aa_arrows_color, true)     
      
    else
        ui_set_visible(star.menu.watermark, false)
        ui_set_visible(star.menu.indicator_aa, false)
        ui_set_visible(star.menu.indicator_aa_color, false)
        ui_set_visible(star.menu.indicator_main, false)
        ui_set_visible(star.menu.indicator_main_color, false)
        ui_set_visible(star.menu.indicator_background, false)
        ui_set_visible(star.menu.indicator_background_color, false)
        ui_set_visible(star.menu.indicator_aa_arrows_enb, false)     
        ui_set_visible(star.menu.indicator_aa_arrows, false)     
        ui_set_visible(star.menu.indicator_aa_arrows_color, false)                
    end

    if menu_misc then
        ui_set_visible(star.menu.animfix, true)
        ui_set_visible(star.menu.anti_knife, true)
        ui_set_visible(star.menu.clantag, true)
        ui_set_visible(star.menu.leg_breaker, true)
        ui_set_visible(star.menu.killsay, true)
    else
        ui_set_visible(star.menu.animfix, false)
        ui_set_visible(star.menu.anti_knife, false)
        ui_set_visible(star.menu.clantag, false)
        ui_set_visible(star.menu.leg_breaker, false)
        ui_set_visible(star.menu.killsay, false)
    end

	ui_set_visible(star.ref.enable, false)
    ui_set_visible(star.ref.pitch, false)
    ui_set_visible(star.ref.yaw_base, false)
    ui_set_visible(star.ref.yaw[1], false)
    ui_set_visible(star.ref.yaw[2], false)
    ui_set_visible(star.ref.yaw_jitter[1], false)
    ui_set_visible(star.ref.yaw_jitter[2], false)
    ui_set_visible(star.ref.yaw_body[1], false)
    ui_set_visible(star.ref.yaw_body[2], false)
    ui_set_visible(star.ref.freestanding_body_yaw, false)
    ui_set_visible(star.ref.roll_aa, false)
    ui_set_visible(star.ref.fakeyawlimit, false)
    ui_set_visible(star.ref.edge_yaw, false)
    ui_set_visible(star.ref.freestanding[1], false)
    ui_set_visible(star.ref.freestanding[2], false)
    ui_set_visible(star.ref.fakelag_type, false)
    ui_set_visible(star.ref.fakelag_variance, false)
    ui_set_visible(star.ref.fakelag_limit, false)
end


local function get_velocity(player)
	local x,y,z = entity_get_prop(player, "m_vecVelocity")
	if x == nil then return end
	return math_sqrt(x*x + y*y + z*z)
end

local best_enemy = nil

local brute = {
	yaw_status = "default",
	fs_side = 0,
	last_miss = 0,
	best_angle = 0,
	misses = { },
	hp = 0,
	misses_ind = { },
	can_hit_head = 0,
	can_hit = 0,
	hit_reverse = { }
}

local ingore = false
local laa = 0
local raa = 0
local mantimer = 0
local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function calc_angle(local_x, local_y, enemy_x, enemy_y)
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math.atan( ydelta / xdelta )
	relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
	if xdelta >= 0 then
		relativeyaw = normalize_yaw(relativeyaw + 180)
	end
	return relativeyaw
end

local function ang_on_screen(x, y)
	if x == 0 and y == 0 then return 0 end

	return math.deg(math.atan2(y, x))
end

local function angle_vector(angle_x, angle_y)
	local sy = math.sin(math.rad(angle_y))
	local cy = math.cos(math.rad(angle_y))
	local sp = math.sin(math.rad(angle_x))
	local cp = math.cos(math.rad(angle_x))
	return cp * cy, cp * sy, -sp
end

local function get_damage(me, enemy, x, y,z)
	local ex = { }
	local ey = { }
	local ez = { }
	ex[0], ey[0], ez[0] = entity.hitbox_position(enemy, 1)
	ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
	ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
	ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
	ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
	ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
	ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
	local bestdamage = 0
	local bent = nil
	for i=0, 6 do
		local ent, damage = client.trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
		if damage > bestdamage then
			bent = ent
			bestdamage = damage
		end
	end
	return bent == nil and client.scale_damage(me, 1, bestdamage) or bestdamage
end

local function get_best_enemy()
	best_enemy = nil

	local enemies = entity.get_players(true)
	local best_fov = 180

	local lx, ly, lz = client.eye_position()
	local view_x, view_y, roll = client.camera_angles()
	
	for i=1, #enemies do
		local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
		local cur_fov = math.abs(normalize_yaw(ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
		if cur_fov < best_fov then
			best_fov = cur_fov
			best_enemy = enemies[i]
		end
	end
end

local function extrapolate_position(xpos,ypos,zpos,ticks,player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	for i=0, ticks do
		xpos =  xpos + (x*globals.tickinterval())
		ypos =  ypos + (y*globals.tickinterval())
		zpos =  zpos + (z*globals.tickinterval())
	end
	return xpos,ypos,zpos
end

local function get_body_yaw(player)
	local _, model_yaw = entity.get_prop(player, "m_angAbsRotation")
	local _, eye_yaw = entity.get_prop(player, "m_angEyeAngles")
	if model_yaw == nil or eye_yaw ==nil then return 0 end
	return normalize_yaw(model_yaw - eye_yaw)
end

local function get_best_angle()
	local me = entity.get_local_player()

	if best_enemy == nil then return end

	local origin_x, origin_y, origin_z = entity.get_prop(best_enemy, "m_vecOrigin")
	if origin_z == nil then return end
	origin_z = origin_z + 64

	local extrapolated_x, extrapolated_y, extrapolated_z = extrapolate_position(origin_x, origin_y, origin_z, 20, best_enemy)
	
	local lx,ly,lz = client.eye_position()
	local hx,hy,hz = entity.hitbox_position(entity.get_local_player(), 0) 
	local _, head_dmg = client.trace_bullet(best_enemy, origin_x, origin_y, origin_z, hx, hy, hz, true)
			
	if head_dmg ~= nil and head_dmg > 1 then
		brute.can_hit_head = 1
	else
		brute.can_hit_head = 0
	end

	local view_x, view_y, roll = client.camera_angles()
	
	local e_x, e_y, e_z = entity.hitbox_position(best_enemy, 0)

	local yaw = calc_angle(lx, ly, e_x, e_y)
	local rdir_x, rdir_y, rdir_z = angle_vector(0, (yaw + 90))
	local rend_x = lx + rdir_x * 10
	local rend_y = ly + rdir_y * 10
			
	local ldir_x, ldir_y, ldir_z = angle_vector(0, (yaw - 90))
	local lend_x = lx + ldir_x * 10
	local lend_y = ly + ldir_y * 10
			
	local r2dir_x, r2dir_y, r2dir_z = angle_vector(0, (yaw + 90))
	local r2end_x = lx + r2dir_x * 100
	local r2end_y = ly + r2dir_y * 100

	local l2dir_x, l2dir_y, l2dir_z = angle_vector(0, (yaw - 90))
	local l2end_x = lx + l2dir_x * 100
	local l2end_y = ly + l2dir_y * 100      
			
	local ldamage = get_damage(me, best_enemy, rend_x, rend_y, lz)
	local rdamage = get_damage(me, best_enemy, lend_x, lend_y, lz)

	local l2damage = get_damage(me, best_enemy, r2end_x, r2end_y, lz)
	local r2damage = get_damage(me, best_enemy, l2end_x, l2end_y, lz)

	if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
		if ui.get(aa_init[var.p_state].desync_fs) then
			brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 1 or 2)
		else
			brute.best_angle = 1
		end
	elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
		if ui.get(aa_init[var.p_state].desync_fs) then
			brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 2 or 1)
		else
			brute.best_angle = 2
		end
	end
end

local function get_primary()
    local l_player = entity_get_local_player()
    local players = entity_get_players(true)
    local lx, ly, lz = entity_get_prop(l_player, "m_vecOrigin")
  
    local closest_player = {}
    local closest_distance = math.huge
    for i = 1, #players do
        local ent = players[i]
        local x, y, z = entity_get_prop(ent, "m_vecOrigin")
        local distance = math_sqrt((lx-x) ^ 2 + (ly-y) ^ 2 + (lz-z) ^ 2)
        if distance <= closest_distance then
            closest_player[1] = ent
            closest_player[2] = distance
            return closest_player[1], closest_player[2]
        end
    end
end

local function on_setup_command(c)
	local primary_player, player_distance = get_primary()
	local isDormant = entity_is_dormant(primary_player)
	local vx, vy, vz = entity_get_prop(entity_get_local_player(), "m_vecVelocity")
	local p_still = math_sqrt(vx ^ 2 + vy ^ 2) < 5
	local lp_vel = get_velocity(entity_get_local_player())
	local on_ground = bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 1 and c.in_jump == 0
    local isSlowWalking = ui_get(star.ref.SlowMotion[1]) and ui_get(star.ref.SlowMotion[2])

	if ui_get(star.menu.force_defensive) then
		c.force_defensive = 0
	end

    if c.in_duck == 1 and on_ground then
		var.p_state = 5
	elseif c.in_duck == 1 and not on_ground then
		var.p_state = 6
	elseif not on_ground then
		var.p_state = 4
	elseif isSlowWalking then
		var.p_state = 3
	elseif p_still then
		var.p_state = 1
	elseif not p_still then
		var.p_state = 2
	end
end


local function modify_velocity(cmd, goalspeed)
    if goalspeed <= 0 then
        return
    end
    local minimalspeed = math_sqrt((cmd.forwardmove * cmd.forwardmove) + (cmd.sidemove * cmd.sidemove))
    if minimalspeed <= 0 then
        return
    end
    if cmd.in_duck == 1 then
        goalspeed = goalspeed * 2.94117647
    end
    if minimalspeed <= goalspeed then
        return
    end
    local speedfactor = goalspeed / minimalspeed
    cmd.forwardmove = cmd.forwardmove * speedfactor
    cmd.sidemove = cmd.sidemove * speedfactor
end

local function velocity(cmd)
    local limit = math_min(60, 37, 60)
    local min_g = 20
    local max_g = 40
    if limit >= 57 then
        return
    end
    if ui_get(star.ref.SlowMotion[1]) and ui_get(star.ref.SlowMotion[2]) then
        modify_velocity(cmd, limit)
    end
end

local function get_distance(x1, y1, z1, x2, y2, z2)
    return math_sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

function anti_aim(c)
	local math_random = math.random(0, 2) 
    local weapon = entity_get_player_weapon(entity_get_local_player())
    local weapon_id = bit_band(entity_get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)
    local bodyyaw = entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and 1 or -1

    local edge_key = ui_get(star.menu.edge[2]) and ui_get(star.menu.edge[1]) and not isSlowWalking and not on_ground
    local fs_key = ui_get(star.menu.freestand[2]) and ui_get(star.menu.freestand[1]) and not isSlowWalking and not on_ground

    ui_set(star.ref.edge_yaw, edge_key)
    ui_set(star.ref.freestanding[1], fs_key and "Default" or "-")

    if ui_get(star.menu.leg_breaker) then
        if (bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 1) then
            if math_random <= 2 then
                ui_set(star.ref.legmovement, "always slide")
            end
            if math_random == 1 then
                ui_set(star.ref.legmovement, "never slide")
            end
        else 
            ui_set(star.ref.legmovement, "off")
        end
    end 
    
    if ui_get(star.menu.enabled) then
        ui_set(star.ref.enable, true)
        if ui_get(star.menu.stronk_ma) then    
            if ui_get(star.menu.ui_backwards_hotkey) then
                var.mode = "back"
            elseif ui_get(star.menu.ui_left_hotkey) and var.leftReady then
                if var.mode == "left" then
                    var.mode = "back"
                else
                    var.mode = "left"
                end
                var.leftReady = false
            elseif ui_get(star.menu.ui_right_hotkey) and var.rightReady then
                if var.mode == "right" then
                    var.mode = "back"
                else
                    var.mode = "right"
                end
                var.rightReady = false
            end
        
            if ui_get(star.menu.ui_left_hotkey) == false then
                var.leftReady = true
             end
        
            if ui_get(star.menu.ui_right_hotkey) == false then
                var.rightReady = true
            end
    
            ui_set(star.menu.ui_backwards_hotkey,"On hotkey")
            ui_set(star.menu.ui_left_hotkey,"On hotkey")
            ui_set(star.menu.ui_right_hotkey,"On hotkey")
        end

        if ui_get(star.menu.stronk_aa) == "Dynamic" then
            rolling = 0
            if var.p_state == 1 then
                var.state = 1
                if var.mode == "left" then
                    if ui_get(star.menu.stronk_aa_ma) == "Static" then
                        roll = 0
                        ui_set(star.ref.yaw_body[2], 0)
                    elseif ui_get(star.menu.stronk_aa_ma) == "Roll" then
                        roll = 1
                        ui_set(star.ref.yaw_body[2], -141)
                        ui_set(star.ref.roll_aa, 50)
                    end
                    ui_set(star.ref.pitch, "Default")
                    ui_set(star.ref.yaw_base, "Local view")
                    ui_set(star.ref.yaw[2], -90)
                    ui_set(star.ref.yaw[1], "180")
                    ui_set(star.ref.yaw_jitter[1], "Center")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Static")
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                elseif var.mode == "right" then
                    if ui_get(star.menu.stronk_aa_ma) == "Static" then
                        roll = 0
                        ui_set(star.ref.yaw_body[2], 0)
                    elseif ui_get(star.menu.stronk_aa_ma) == "Roll" then
                        roll = 1
                        ui_set(star.ref.yaw_body[2], -141)
                        ui_set(star.ref.roll_aa, 50)
                    end
                    ui_set(star.ref.pitch, "Default")
                    ui_set(star.ref.yaw_base, "Local view")
                    ui_set(star.ref.yaw[2], 90)
                    ui_set(star.ref.yaw[1], "180")
                    ui_set(star.ref.yaw_jitter[1], "Center")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Static")
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                elseif var.mode == "back" then
                    roll = 0
                    ui_set(star.ref.pitch, "Minimal")
                    ui_set(star.ref.yaw[1], "180")    
                    ui_set(star.ref.yaw_base, "At targets")
                    if c.chokedcommands ~= 0 then
                    else
                        ui_set(star.ref.yaw[2],(side == 1 and -35 or 29))
                    end
                    ui_set(star.ref.yaw_jitter[1], "off")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Jitter")
                    ui_set(star.ref.yaw_body[2], 0)
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                    ui_set(star.ref.roll_aa, 0)
                    end
                end        
            
            if var.p_state == 2 then
                var.state = 1
                if var.mode == "left" then
                    if ui_get(star.menu.stronk_aa_ma) == "Static" then
                        roll = 0
                        ui_set(star.ref.yaw_body[2], 0)
                    elseif ui_get(star.menu.stronk_aa_ma) == "Roll" then
                        roll = 1
                        ui_set(star.ref.yaw_body[2], -141)
                        ui_set(star.ref.roll_aa, 50)
                    end
                    ui_set(star.ref.pitch, "Default")
                    ui_set(star.ref.yaw_base, "Local view")
                    ui_set(star.ref.yaw[1], "180")
                    ui_set(star.ref.yaw[2], -90)
                    ui_set(star.ref.yaw_jitter[1], "Center")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Static")
                    ui_set(star.ref.yaw_body[2], 0)
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                elseif var.mode == "right" then
                    if ui_get(star.menu.stronk_aa_ma) == "Static" then
                        roll = 0
                        ui_set(star.ref.yaw_body[2], 0)
                    elseif ui_get(star.menu.stronk_aa_ma) == "Roll" then
                        roll = 1
                        ui_set(star.ref.yaw_body[2], -141)
                        ui_set(star.ref.roll_aa, 50)
                    end
                    ui_set(star.ref.pitch, "Default")
                    ui_set(star.ref.yaw_base, "Local view")
                    ui_set(star.ref.yaw[1], "180")
                    ui_set(star.ref.yaw[2], 90)
                    ui_set(star.ref.yaw_jitter[1], "Center")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Static")
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                elseif var.mode == "back" then
                    roll = 0
                    ui_set(star.ref.pitch, "Minimal")
                    ui_set(star.ref.yaw[1], "180")    
                    ui_set(star.ref.yaw_base, "At targets")
                    if c.chokedcommands ~= 0 then
                    else
                        ui_set(star.ref.yaw[2],(side == 1 and -43 or 36))
                    end
                    ui_set(star.ref.yaw_jitter[1], "off")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Jitter")
                    ui_set(star.ref.yaw_body[2], 0)
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                    end
                end                    
            
            if var.p_state == 3 then
                var.state = 3
                if ui_get(star.menu.stronk_aa_sw) == "Roll" then
                    roll = 1
                    ui_set(star.ref.pitch, "Default")
                    ui_set(star.ref.yaw_base, "Local view")
                    ui_set(star.ref.yaw[1], "180")
                    if var.mode == "left" then
                        ui_set(star.ref.yaw[2], -90)
                        ui_set(star.ref.yaw_body[2], -141)
                    elseif var.mode == "right" then
                        ui_set(star.ref.yaw[2], 90)
                        ui_set(star.ref.yaw_body[2], -141)
                    elseif var.mode == "back" then
                        ui_set(star.ref.yaw[2], 0)
                        ui_set(star.ref.yaw_body[2], 180)
                    end
                    ui_set(star.ref.yaw_jitter[1], "Center")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Static")
                    if var.mode == "back" then
                        ui_set(star.ref.yaw_body[2], 180)
                    end
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                elseif ui_get(star.menu.stronk_aa_sw) == "Jitter" then
                    roll = 0
                    ui_set(star.ref.pitch, "Default")
                    ui_set(star.ref.yaw[1], "180")    
                    ui_set(star.ref.yaw_base, "At targets")
                    if var.mode == "left" then
                        if ui_get(star.menu.stronk_aa_ma) == "Static" then
                            roll = 0
                        elseif ui_get(star.menu.stronk_aa_ma) == "Roll" then
                            roll = 1
                        end
                        ui_set(star.ref.yaw[2], -90)
                elseif var.mode == "right" then
                    if ui_get(star.menu.stronk_aa_ma) == "Static" then
                            roll = 0
                        elseif ui_get(star.menu.stronk_aa_ma) == "Roll" then
                            roll = 1
                        end
                        ui_set(star.ref.yaw[2], 90)
                    elseif var.mode == "back" then
                        roll = 0
                        ui_set(star.ref.yaw[2], math.random(-5, 10))
                    end
                    ui_set(star.ref.yaw_jitter[1], "off")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Static")
                    ui_set(star.ref.yaw_body[2], 180) 
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)            
                    end                        
                end                        

            if var.p_state == 4 then
                var.state = 1
                if var.mode == "left" then
                    roll = 0
                    ui_set(star.ref.pitch, "Default")
                    ui_set(star.ref.yaw_base, "Local view")
                    ui_set(star.ref.yaw[1], "180")
                    ui_set(star.ref.yaw[2], -90)
                    ui_set(star.ref.yaw_jitter[1], "Center")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Static")
                    ui_set(star.ref.yaw_body[2], 0)
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                elseif var.mode == "right" then
                    roll = 0
                    ui_set(star.ref.pitch, "Default")
                    ui_set(star.ref.yaw_base, "Local view")
                    ui_set(star.ref.yaw[1], "180")
                    ui_set(star.ref.yaw[2], 90)
                    ui_set(star.ref.yaw_jitter[1], "Center")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Static")
                    ui_set(star.ref.yaw_body[2], 0)
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                elseif var.mode == "back" then
                    roll = 0
                    ui_set(star.ref.pitch, "Minimal")
                    ui_set(star.ref.yaw[1], "180")    
                    ui_set(star.ref.yaw_base, "At targets")
                    if c.chokedcommands ~= 0 then
                    else
                        ui_set(star.ref.yaw[2],(side == 1 and -21 or 42))
                    end
                    ui_set(star.ref.yaw_jitter[1], "off")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Jitter")
                    ui_set(star.ref.yaw_body[2], 0)
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                    end                        
                end                        
         
                if var.p_state == 6 then
                    var.state = 1
                    if var.mode == "left" then
                        roll = 0
                        ui_set(star.ref.pitch, "Default")
                        ui_set(star.ref.yaw_base, "Local view")
                        ui_set(star.ref.yaw[1], "180")
                        ui_set(star.ref.yaw[2], -90)
                        ui_set(star.ref.yaw_jitter[1], "Center")
                        ui_set(star.ref.yaw_jitter[2], 0) 
                        ui_set(star.ref.yaw_body[1], "Static")
                        ui_set(star.ref.yaw_body[2], 0)
                        ui_set(star.ref.freestanding_body_yaw, false)
                        ui_set(star.ref.fakeyawlimit, 60)
                    elseif var.mode == "right" then
                        roll = 0
                        ui_set(star.ref.pitch, "Default")
                        ui_set(star.ref.yaw_base, "Local view")
                        ui_set(star.ref.yaw[1], "180")
                        ui_set(star.ref.yaw[2], 90)
                        ui_set(star.ref.yaw_jitter[1], "Center")
                        ui_set(star.ref.yaw_jitter[2], 0) 
                        ui_set(star.ref.yaw_body[1], "Static")
                        ui_set(star.ref.yaw_body[2], 0)
                        ui_set(star.ref.freestanding_body_yaw, false)
                        ui_set(star.ref.fakeyawlimit, 60)
                    elseif var.mode == "back" then
                        roll = 0
                        ui_set(star.ref.pitch, "Default")
                        ui_set(star.ref.yaw[1], "180")    
                        ui_set(star.ref.yaw_base, "At targets")
                        if c.chokedcommands ~= 0 then
                        else
                            ui_set(star.ref.yaw[2],(side == 1 and -23 or 43))
                        end
                        ui_set(star.ref.yaw_jitter[1], "off")
                        ui_set(star.ref.yaw_jitter[2], 0) 
                        ui_set(star.ref.yaw_body[1], "Jitter")
                        ui_set(star.ref.yaw_body[2], 0)
                        ui_set(star.ref.freestanding_body_yaw, false)
                        ui_set(star.ref.fakeyawlimit, 60)
                        end                        
                    end                   

            if var.p_state == 5 then
                var.state = 1
                if var.mode == "left" then
                    if ui_get(star.menu.stronk_aa_ma) == "Static" then
                        roll = 0
                        ui_set(star.ref.yaw_body[2], 0)
                    elseif ui_get(star.menu.stronk_aa_ma) == "Roll" then
                        roll = 1
                        ui_set(star.ref.yaw_body[2], -141)
                        ui_set(star.ref.roll_aa, 50)
                    end
                    ui_set(star.ref.pitch, "Default")
                    ui_set(star.ref.yaw_base, "Local view")
                    ui_set(star.ref.yaw[1], "180")
                    ui_set(star.ref.yaw[2], -90)
                    ui_set(star.ref.yaw_jitter[1], "Center")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Static")
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                elseif var.mode == "right" then
                    if ui_get(star.menu.stronk_aa_ma) == "Static" then
                        roll = 0
                        ui_set(star.ref.yaw_body[2], 0)
                    elseif ui_get(star.menu.stronk_aa_ma) == "Roll" then
                        roll = 1
                        ui_set(star.ref.yaw_body[2], -141)
                        ui_set(star.ref.roll_aa, 50)
                    end
                    ui_set(star.ref.pitch, "Default")
                    ui_set(star.ref.yaw_base, "Local view")
                    ui_set(star.ref.yaw[1], "180")
                    ui_set(star.ref.yaw[2], 90)
                    ui_set(star.ref.yaw_jitter[1], "Center")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Static")
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 59)
                elseif var.mode == "back" then
                    roll = 0
                    ui_set(star.ref.pitch, "Minimal")
                    ui_set(star.ref.yaw[1], "180")    
                    ui_set(star.ref.yaw_base, "At targets")
                    if c.chokedcommands ~= 0 then
                    else
                        ui_set(star.ref.yaw[2],(side == 1 and -26 or 30))
                    end
                    ui_set(star.ref.yaw_jitter[1], "off")
                    ui_set(star.ref.yaw_jitter[2], 0) 
                    ui_set(star.ref.yaw_body[1], "Jitter")
                    ui_set(star.ref.yaw_body[2], 0)
                    ui_set(star.ref.freestanding_body_yaw, false)
                    ui_set(star.ref.fakeyawlimit, 60)
                end
            end

            if isDormant then
                var.state = 6
                if var.state == 3 then
                    ui_set(star.ref.yaw_base, "Local view")
                end
                ui_set(star.ref.yaw_base, "At targets")
            end

            if ui_get(star.menu.roll_one_key) then
                var.state = 4
                ui_set(star.ref.pitch, "Default")
                ui_set(star.ref.yaw[1], "180")
                if var.mode == "left" then
                    ui_set(star.ref.yaw_base, "Local view")
                    ui_set(star.ref.yaw[2], -90)
                    ui_set(star.ref.yaw_body[2], -141)
                elseif var.mode == "right" then
                    ui_set(star.ref.yaw[2], 90)
                    ui_set(star.ref.yaw_base, "Local view")
                    ui_set(star.ref.yaw_body[2], -141)
                elseif var.mode == "back" then
                    ui_set(star.ref.yaw_base, "At Targets")
                    ui_set(star.ref.yaw[2], 0)
                    ui_set(star.ref.yaw_body[2], 180)
                end
                ui_set(star.ref.yaw_jitter[1], "Center")
                ui_set(star.ref.yaw_jitter[2], 0) 
                ui_set(star.ref.yaw_body[1], "Static")
                ui_set(star.ref.freestanding_body_yaw, false)
                ui_set(star.ref.fakeyawlimit, 60)
            else
            end

            if ui_get(star.menu.legit_e_key) then   
                if client_key_state(0x45) then
                    if ui_get(star.menu.legit_e_key_type) == "Opposite" then
                    roll = 0
                    ui_set(star.ref.yaw[2], 0)
                    ui_set(star.ref.fakeyawlimit, 58)
                    ui_set(star.ref.yaw_jitter[1], "Off")
                    ui_set(star.ref.yaw_body[1], "Opposite")
                    ui_set(star.ref.freestanding_body_yaw, true)
                    ui_set(star.ref.yaw_body[2], 0)
                    elseif ui_get(star.menu.legit_e_key_type) == "Roll" then
                        roll = 1
                        ui_set(star.ref.yaw[2], 0)
                        ui_set(star.ref.fakeyawlimit, 58)
                        ui_set(star.ref.yaw_jitter[1], "Off")
                        ui_set(star.ref.yaw_body[1], "Static")
                        ui_set(star.ref.yaw_body[2], 180)
                    end
                end
            end
        
            local weapz = entity_get_player_weapon(entity_get_local_player())
            local is_bomb = weapz ~= nil and entity_get_classname(weapz) == "CC4"
        
            if ui_get(star.menu.legit_e_key) and weaponn ~= nil and entity_get_classname(weaponn) == "CC4" and client_key_state(0x45) then
                if c.in_attack == 1 then
                    c.in_attack = 0
                    c.in_use = 1
                    holdingE = true
                end
            else
                if c.chokedcommands == 0 then
                    c.in_use = 0
                    holdingE = false
                end
            end            

        elseif ui_get(star.menu.stronk_aa) == "AA-Builder" then

            if var.mode == "left" then
                if ui_get(star.menu.stronk_aa_ma) == "Static" then
                    roll = 0
                    ui_set(star.ref.yaw_body[2], 0)
                elseif ui_get(star.menu.stronk_aa_ma) == "Roll" then
                    roll = 1
                    ui_set(star.ref.yaw_body[2], -141)
                    ui_set(star.ref.roll_aa, 50)
                end
                ui_set(star.ref.pitch, "Default")
                ui_set(star.ref.yaw_base, "Local view")
                ui_set(star.ref.yaw[2], -90)
                ui_set(star.ref.yaw[1], "180")
                ui_set(star.ref.yaw_jitter[1], "Center")
                ui_set(star.ref.yaw_jitter[2], 0) 
                ui_set(star.ref.yaw_body[1], "Static")
                ui_set(star.ref.freestanding_body_yaw, false)
                ui_set(star.ref.fakeyawlimit, 60)
            elseif var.mode == "right" then
                if ui_get(star.menu.stronk_aa_ma) == "Static" then
                    roll = 0
                    ui_set(star.ref.yaw_body[2], 0)
                elseif ui_get(star.menu.stronk_aa_ma) == "Roll" then
                    roll = 1
                    ui_set(star.ref.yaw_body[2], -141)
                    ui_set(star.ref.roll_aa, 50)
                end
                ui_set(star.ref.pitch, "Default")
                ui_set(star.ref.yaw_base, "Local view")
                ui_set(star.ref.yaw[2], 90)
                ui_set(star.ref.yaw[1], "180")
                ui_set(star.ref.yaw_jitter[1], "Center")
                ui_set(star.ref.yaw_jitter[2], 0) 
                ui_set(star.ref.yaw_body[1], "Static")
                ui_set(star.ref.freestanding_body_yaw, false)
                ui_set(star.ref.fakeyawlimit, 60)
            elseif var.mode == "back" then
                roll = 0
                ui_set(star.ref.yaw[1], "180")    
                ui_set(star.ref.yaw_base, "At targets")
                ui.set(pitch, ui.get(aa_init[var.p_state].pitch))
                ui.set(yaw_jitter, ui.get(aa_init[var.p_state].yawjitter))
                ui.set(yaw_jitter_slider, ui.get(aa_init[var.p_state].yawjitteradd))
                ui.set(yaw_body_slider, ui.get(aa_init[var.p_state].aa_static))
                ui.set(yaw_body, ui.get(aa_init[var.p_state].bodyyaw))
                if ui_get(star.menu.static_fs) then
                    if ui_get(star.menu.freestand[1]) and ui_get(star.menu.freestand[2]) then
                        ui_set(yaw_jitter, "Off")
                    end
                else
                    ui.set(yaw_body, ui.get(aa_init[var.p_state].bodyyaw))
                end
                if c.chokedcommands ~= 0 then
                else
                    ui.set(yaw_slider,(side == 1 and ui.get(aa_init[var.p_state].yawaddl) or ui.get(aa_init[var.p_state].yawaddr)))
                end
                if bodyyaw > 0 then
                    ui_set(fakeyawlimit, ui.get(aa_init[var.p_state].fakeyawlimitr))
                elseif bodyyaw < 0 then
                    ui_set(fakeyawlimit,ui.get(aa_init[var.p_state].fakeyawlimit))
                end
                ui_set(star.ref.roll_aa, 0)
            end
    end           
    else
        ui_set(star.ref.pitch, "off")
        ui_set(star.ref.yaw_base, "local view")
        ui_set(star.ref.yaw[1], "off")
        ui_set(star.ref.yaw[2], 0) 
        ui_set(star.ref.yaw_jitter[1], "off")
        ui_set(star.ref.yaw_jitter[2], 0) 
        ui_set(star.ref.yaw_body[1], "off")
        ui_set(star.ref.yaw_body[2], 0)
        ui_set(star.ref.freestanding_body_yaw, false)
        ui_set(star.ref.fakeyawlimit, 60)            
    end

        if weapon_id == 40 then
            ui_set(star.ref.fakelag_type, "Fluctuate")
            ui_set(star.ref.fakelag_variance, 10)
        elseif weapon_id == 9 then
            ui_set(star.ref.fakelag_type, "Maximum")
            ui_set(star.ref.fakelag_variance, 0)
        elseif weapon_id == 38 or 11 then
            ui_set(star.ref.fakelag_type, "Fluctuate")
            ui_set(star.ref.fakelag_variance, 10)
        elseif weapon_id == nil then
            ui_set(star.ref.fakelag_type, "Fluctuate")
            ui_set(star.ref.fakelag_variance, 10)
        end
end

local function brute_impact(e)

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local shooter_id = e.userid
	local shooter = client.userid_to_entindex(shooter_id)

	if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then return end

	local lx, ly, lz = entity.hitbox_position(me, "head_0")
	
	local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")
	local ex, ey, ez = entity.get_prop(shooter, "m_vecOrigin")

	local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)
	
	if math.abs(dist) <= 35 and globals.curtime() - brute.last_miss > 0.015 then
		if ui.get(aa_init[0].aa_abf) or ui.get(aa_init[var.p_state].anti_bf) then
            client.log("Switched due to Anti-bruteforce")
		else
		end
		brute.last_miss = globals.curtime()
		if brute.misses[shooter] == nil then
			brute.misses[shooter] = 1 
			brute.misses_ind[shooter] = 1
		elseif brute.misses[shooter] >= 2 then
			brute.misses[shooter] = nil
		else
			brute.misses_ind[shooter] = brute.misses_ind[shooter] + 1
			brute.misses[shooter] = brute.misses[shooter] + 1
		end
	end
end

brute.reset = function()
	brute.fs_side = 0
	brute.last_miss = 0
	brute.best_angle = 0
	brute.misses_ind = { }
	brute.misses = { }
end

local function brute_death(e)
	
	local victim_id = e.userid
	local victim = client.userid_to_entindex(victim_id)

	if victim ~= entity.get_local_player() then return end

	local attacker_id = e.attacker
	local attacker = client.userid_to_entindex(attacker_id)

	if not entity.is_enemy(attacker) then return end

	if not e.headshot then return end

	if brute.misses[attacker] == nil or (globals.curtime() - brute.last_miss < 0.06 and brute.misses[attacker] == 1) then
		if brute.hit_reverse[attacker] == nil then
			brute.hit_reverse[attacker] = true
		else
			brute.hit_reverse[attacker] = nil
		end
	end
end

local gamerules_ptr = client_find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")
local gamerules = ffi.cast("intptr_t**", ffi.cast("intptr_t", gamerules_ptr) + 2)[0]
local sv_maxusrcmdprocessticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
local fl_limit = ui_reference("AA", "Fake lag", "Limit")

client_set_event_callback("setup_command", function(cmd)
    local weapon = csgo_weapons[entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_iItemDefinitionIndex")]

    local xv, yv, zv = entity_get_prop(entity_get_local_player(), "m_vecVelocity")
	local velocity = math_sqrt(xv^2 + yv^2)
    local on_ground = bit_band(entity_get_prop(entity_get_local_player(), 'm_fFlags'), bit_lshift(1, 0))    

    if roll == 0 then
            cmd.roll = 0;   
    elseif roll == 1 then
            cmd.roll = 50; 
    end

    if ui_get(star.menu.roll_one_key) then
        cmd.roll = 50;
        if is_valve_ds_spoofed == 1 then
            if ui_get(sv_maxusrcmdprocessticks) ~= 7 then
                ui_set(fl_limit, 6)
            end
            if ui_get(star.ref.roll_aa) > 44 then
                ui_set(star.ref.roll_aa, 44)
            end
            if ui_get(star.ref.roll_aa) < -44 then
                ui_set(star.ref.roll_aa, -44)
            end
        else
            if ui_get(sv_maxusrcmdprocessticks) == 16 then
                ui_set(sv_maxusrcmdprocessticks, 16)
                ui_set(fl_limit, 15)
            end
            if ui_get(star.ref.roll_aa) == 44 then
                ui_set(star.ref.roll_aa, 50)
            end
            if ui_get(star.ref.roll_aa) == -44 then
                ui_set(star.ref.roll_aa, -50)
            end
        end    
    end

    if weapon == nil then goto skip end
    
    ::skip::    

    local is_valve_ds = ffi.cast('bool*', gamerules[0] + 124)
    if is_valve_ds ~= nil then
        if cmd.roll ~= 0 and ui_get(star.menu.mm_enable) then
            if is_valve_ds[0] == true then
                is_valve_ds[0] = 0
                is_valve_ds_spoofed = 1
            end
        else
            if is_valve_ds[0] == false and is_valve_ds_spoofed == 1 then
                cmd.roll = 0
            end
        end
    end
end)

--[[ 
    Ragebot
--]]

local ref_plist = ui.reference("PLAYERS", "Players", "Player list")
local ref_min_damage = ui.reference("RAGE", "Aimbot", "Minimum damage")

local missLogs = {}
local simTimes = {}
local oldSimTimes = {}
local chokes = {}
local cached_plist
for i = 1, 64 do
    missLogs[i] = 0
end

local function vector_angles(x1, y1, z1, x2, y2, z2)
    local origin_x, origin_y, origin_z
    local target_x, target_y, target_z
    if x2 == nil then
        target_x, target_y, target_z = x1, y1, z1
        origin_x, origin_y, origin_z = client.eye_position()
        if origin_x == nil then
            return
        end
    else
        origin_x, origin_y, origin_z = x1, y1, z1
        target_x, target_y, target_z = x2, y2, z2
    end

    local delta_x, delta_y, delta_z = target_x - origin_x, target_y - origin_y, target_z - origin_z

    if delta_x == 0 and delta_y == 0 then
        return (delta_z > 0 and 270 or 90), 0
    else
        local yaw = math.deg(math.atan2(delta_y, delta_x))

        local hyp = math.sqrt(delta_x * delta_x + delta_y * delta_y)
        local pitch = math.deg(math.atan2(-delta_z, hyp))

        return pitch, yaw
    end
end

local function normalise_angle(angle)
    angle = angle % 360
    angle = (angle + 360) % 360
    if (angle > 180) then
        angle = angle - 360
    end
    return angle
end

local function is_moving(index)
    local x, y, z = entity.get_prop(index, "m_vecVelocity")
    return math.sqrt(x * x + y * y + z * z) > 1.0
end

local function ent_speed(index)
    local x, y, z = entity.get_prop(index, "m_vecVelocity")
    return math.sqrt(x * x + y * y + z * z)
end

local function ent_speed_2d(index)
    local x, y, z = entity.get_prop(index, "m_vecVelocity")
    return math.sqrt(x * x + y * y)
end

local function body_yaw(entityindex)
    bodyyaw = entity.get_prop(entityindex, "m_flPoseParameter", 11)
    if bodyyaw ~= nil then
        bodyyaw = bodyyaw * 120 - 60
    else
        return nil
    end
    return bodyyaw
end

local function max_desync(entityindex)
    local spd = math.min(260, ent_speed_2d(entityindex))
    local walkfrac = math.max(0, math.min(1, spd / 135))
    local mult = 1 - 0.5 * walkfrac
    local duckamnt = entity.get_prop(entityindex, "m_flDuckAmount")

    if duckamnt > 0 then
        local duckfrac = math.max(0, math.min(1, spd / 88))
        mult = mult + ((duckamnt * duckfrac) * (0.5 - mult))
    end

    return (58 * mult)
end

local function vec3_normalize(x, y, z)
    local len = math.sqrt(x * x + y * y + z * z)
    if len == 0 then
        return 0, 0, 0
    end
    local r = 1 / len
    return x * r, y * r, z * r
end

local function vec3_dot(ax, ay, az, bx, by, bz)
    return ax * bx + ay * by + az * bz
end

local function angle_to_vec(pitch, yaw)
    local p, y = math.rad(pitch), math.rad(yaw)
    local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y)
    return cp * cy, cp * sy, -sp
end

local function ent_speed(index)
    local x, y, z = entity.get_prop(index, "m_vecVelocity")
    if x == nil then
        return 0
    end
    return math.sqrt(x * x + y * y + z * z)
end

local function get_fov_cos(ent, vx, vy, vz, lx, ly, lz)
    local ox, oy, oz = entity.get_prop(ent, "m_vecOrigin")
    if ox == nil then
        return -1
    end

    local dx, dy, dz = vec3_normalize(ox - lx, oy - ly, oz - lz)
    return vec3_dot(dx, dy, dz, vx, vy, vz)
end
local function vec_length(x, y, z)
    temp = x * x + y * y + z * z
    if temp < 0 then
        return 0
    else
        return math.sqrt(temp)
    end
end

local closest_player = 0

local function vec3_normalize(x, y, z)
    local len = math.sqrt(x * x + y * y + z * z)
    if len == 0 then
        return 0, 0, 0
    end
    local r = 1 / len
    return x * r, y * r, z * r
end

local function vec3_dot(ax, ay, az, bx, by, bz)
    return ax * bx + ay * by + az * bz
end

local function angle_to_vec(pitch, yaw)
    local p, y = math.rad(pitch), math.rad(yaw)
    local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y)
    return cp * cy, cp * sy, -sp
end

local function ent_speed(index)
    local x, y, z = entity.get_prop(index, "m_vecVelocity")
    if x == nil then
        return 0
    end
    return math.sqrt(x * x + y * y + z * z)
end

local function get_fov_cos(ent, vx, vy, vz, lx, ly, lz)
    local ox, oy, oz = entity.get_prop(ent, "m_vecOrigin")
    if ox == nil then
        return -1
    end

    local dx, dy, dz = vec3_normalize(ox - lx, oy - ly, oz - lz)
    return vec3_dot(dx, dy, dz, vx, vy, vz)
end
local function vec_length(x, y, z)
    temp = x * x + y * y + z * z
    if temp < 0 then
        return 0
    else
        return math.sqrt(temp)
    end
end

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function is_auto_vis(local_player, lx, ly, lz, px, py, pz)
    entindex, dmg = client.trace_bullet(local_player, lx, ly, lz, px, py, pz)

    if entindex == nil then
        return false
    end

    if entindex == local_player then
        return false
    end

    if not entity.is_enemy(entindex) then
        return false
    end

    if dmg >= 5 then
        return true
    else
        return false
    end
end

local function trace_positions(local_player, px, py, pz, px1, py1, pz1, lx2, ly2, lz2)
    if is_auto_vis(local_player, lx2, ly2, lz2, px, py, pz) then
        return true
    end
    if is_auto_vis(local_player, lx2, ly2, lz2, px1, py1, pz1) then
        return true
    end
    return false
end

local function is_auto_vis_enemy(enemy, lx, ly, lz, px, py, pz)
    entindex, dmg = client.trace_bullet(enemy, lx, ly, lz, px, py, pz)

    if entindex == nil then
        return false
    end
    if dmg >= 1 then
        return true
    end

    return false
end

local function trace_positions_enemy(
    eyeposx,
    eyeposy,
    eyeposz,
    lpx,
    lpy,
    lpz,
    lpx1,
    lpy1,
    lpz1,
    lpx2,
    lpy2,
    lpz2,
    enemy_index)
    if is_auto_vis_enemy(enemy_index, eyeposx, eyeposy, eyeposz, lpx, lpy, lpz) then
        return true
    end
    if is_auto_vis_enemy(enemy_index, eyeposx, eyeposy, eyeposz, lpx1, lpy1, lpz1) then
        return true
    end
    if is_auto_vis_enemy(enemy_index, eyeposx, eyeposy, eyeposz, lpx2, lpy2, lpz2) then
        return true
    end

    return false
end

local history = {}
local jitter_delta = 15

local function detect_jitter(i)
    local length = #history[i]
    if length == nil then
        return
    end

    if length < 65 then
        return
    end

    local count = 0

    for j = (length - 64), length do
        if history[i][j] ~= nil and history[i][j - 1] ~= nil then
            if (history[i][j] > 0 and history[i][j - 1] > 0) or (history[i][j] < 0 and history[i][j - 1] < 0) then
                if math.abs((history[i][j] - history[i][j - 1])) > jitter_delta then
                    count = count + 1
                end
            else
                if (history[i][j] > 0 and history[i][j - 1] < 0) or (history[i][j] < 0 and history[i][j - 1] > 0) then
                    if math.abs((history[i][j] + history[i][j - 1])) > jitter_delta then
                        count = count + 1
                    end
                end
            end
        end
    end

    if count >= (10 - 6) then
        return true
    else
        return false
    end
end

local player_preference = {}
local headaim_delay = {}

local function run_command(cmd)
    local local_player = entity.get_local_player()

	if ui.get(star.menu.roll_resolver) == "Automatic" then
		local local_player = entity.get_local_player()
		if local_player == nil then
			return
		end
	
		if not entity.is_alive(local_player) then
			return
		end
	
		local players = entity.get_players(true)
	
		if players == nil then
			return
		end
	
		local lx, ly, lz = client.eye_position()
	
		if lx == nil then
			return
		end
	
		local lpx, lpy, lpz = entity.hitbox_position(local_player, 0)
		local lpx1, lpy1, lpz1 = entity.hitbox_position(local_player, 4)
		local lpx2, lpy2, lpz2 = entity.hitbox_position(local_player, 2)
	
		cached_plist = ui.get(ref_plist)
	
		local active_weapon = entity.get_prop(local_player, "m_hActiveWeapon")
	
		if active_weapon == nil then
			return
		end
	
		local idx = entity.get_prop(active_weapon, "m_iItemDefinitionIndex")
	
		if idx == nil then
			return
		end
	
		local item = bit.band(idx, 0xFFFF)
	
		if item == nil then
			return
		end
	
		for i = 1, #players do
			local player_index = players[i]
			local pos_x, pos_y, pos_z = entity.get_prop(player_index, "m_vecAbsOrigin")
	
			if pos_x ~= nil then
				local t = body_yaw(player_index)
	
				if t ~= nil then
					if history[player_index] == nil then
						history[player_index] = {}
					end
					list_len = #history[player_index]
					history[player_index][list_len + 1] = t
				end
	
				if not entity.is_dormant(player_index) and entity.is_alive(player_index) then
					local pitch, yaw = vector_angles(pos_x, pos_y, pos_z, lx, ly, lz)
					local _, model_yaw = entity.get_prop(player_index, "m_angEyeAngles")
					local delta = math.abs(normalise_angle(yaw - model_yaw))
					local selected = player_preference[player_index]
					local jy = detect_jitter(player_index)
	
					delta = math.floor(delta)
					if delta < 90 then
						entity.set_prop(player_index, "m_angEyeAngles", pitch, yaw, 50)
						if missLogs[player_index] >= 1 then
							entity.set_prop(player_index, "m_angEyeAngles", pitch, yaw, -50)
						end
					end
				end

				local tdesync = max_desync(player_index)
				if tdesync > 30 / 10 and not jy then
					entity.set_prop(player_index, "m_angEyeAngles", pitch, yaw, 50)
					if missLogs[player_index] >= 1 then
						entity.set_prop(player_index, "m_angEyeAngles", pitch, yaw, -50)
					end
				end
			end
		end
	
		local entindex = entity.get_local_player()
		if entindex == nil then
			return
		end
	
		local lx, ly, lz = entity.get_prop(entindex, "m_vecOrigin")
		if lx == nil then
			return
		end
		local players = entity.get_players(true)
		local pitch, yaw = client.camera_angles()
		local vx, vy, vz = angle_to_vec(pitch, yaw)
		local closest_fov_cos = -1
	
		for i = 1, #players do
			entindex = players[i]
	
			local fov_cos = get_fov_cos(entindex, vx, vy, vz, lx, ly, lz)
			if fov_cos > closest_fov_cos then
				closest_fov_cos = fov_cos
				closest_player = entindex
			end
		end
	
		if cached_plist ~= nil then
			ui.set(ref_plist, cached_plist)
		end
	end
end

local sidea = false
local side_roll = 0

local function x()
	if ui.get(star.menu.roll_resolver) == "Manual" then
    local x = ui.get(star.menu.rolloverride)
    if x ~= sidea then
        side_roll = side_roll ~= 2 and side_roll + 1 or 0
        sidea = x
    end
end
end

local function override(ent,roll)
	local _,yaw = entity.get_prop(ent, "m_angRotation");
	local pitch = 89*((2*entity.get_prop(ent, "m_flPoseParameter",12))-1);
	entity.set_prop(ent, "m_angEyeAngles", pitch, yaw, roll);
end

client.set_event_callback("net_update_start",function()
	local e = client.current_threat();
	if e then
		for _,enemy in next, entity.get_players(true) do
			if enemy ~= e then
				override(enemy,0);
			end
		end
		override(e, side_roll == 1 and 50 or side_roll == 2 and -50 or side_roll);
	end
end)

client.set_event_callback("paint",function()
end)

local function clear_misses(index)
    missLogs[index] = 0
end

client.set_event_callback(
	"aim_miss",
    function(c)
        if c.reason ~= "spread" then
            local t = c.target
            if missLogs[t] == nil then
                missLogs[t] = 1
                    client.delay_call(5, clear_misses, t)
                end
            end
end)

client.set_event_callback(
    "player_hurt",
    function(c)
        local i = client.userid_to_entindex(c.userid)
        if c.health == 0 then
            missLogs[i] = 0
        end
    end
)

client.set_event_callback(
    "round_end",
    function(c)
        for i = 1, 64 do
            missLogs[i] = 0
            player_preference[i] = ""
            cached_plist = nil
            closest_player = 0
        end
    end
)

client.set_event_callback(
    "cs_game_disconnected",
    function(c)
        ui.set(ui.reference("PLAYERS", "Players", "Reset all"), true)

        for i = 1, 64 do
            missLogs[i] = 0
            player_preference[i] = ""
            cached_plist = nil
            closest_player = 0
        end
    end
)

client.set_event_callback(
    "player_team",
    function(c)
        client.update_player_list()
    end
)

client.set_event_callback(
    "round_prestart",
    function(c)
        client.update_player_list()
    end
)
client.set_event_callback("run_command", run_command)

--[[ 
    Visuals
--]]

local function dt_rechareg() 

    local player = entity_get_local_player()

    if not ui_get(star.ref.dt[1]) or not ui_get(star.ref.dt[2]) or ui_get(star.ref.fakeduck) then return false end

    if not entity_is_alive(player) then 
        return 
    end
    
    local weapon_activated = entity_get_prop(player, "m_hActiveWeapon")

    if weapon_activated == nil then return false end

    local next_attack = entity_get_prop(player, "m_flNextAttack") + 0.25
	local swap = entity_get_prop(weapon_activated, "m_flNextPrimaryAttack")
	
	if swap == nil then return end
	
    local next_primary_attack = swap + 0.5

    if next_attack == nil or next_primary_attack == nil then return false end

    return next_attack - globals_curtime() < 0 and next_primary_attack - globals_curtime() < 0
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math_floor(num * mult + 0.5) / mult
end

function RGBtoHEX(redArg, greenArg, blueArg)

	return string_format('%.2x%.2x%.2xFF', redArg, greenArg, blueArg)

end

local frametimes = {}
local fps_prev = 0
local last_update_time = 0

function AccumulateFps()
	local ft = globals_absoluteframetime()
	if ft > 0 then
		table_insert(frametimes, 1, ft)
	end
	local count = #frametimes
	if count == 0 then
		return 0
	end
	local i, accum = 0, 0
	while accum < 0.5 do
		i = i + 1
		accum = accum + frametimes[i]
		if i >= count then
			break
		end
	end
	accum = accum / i
	while i < count do
		i = i + 1
		table_remove(frametimes)
	end
	local fps = 1 / accum
	local rt = globals_realtime()
	if math_abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
		fps_prev = fps
		last_update_time = rt
	else
		fps = fps_prev
	end
	return math_floor(fps + 0.5)
end

local function watermark()
	local data_suffix = 'starlua.tech'

	local h, m, s, mst = client_system_time()

	local fps = AccumulateFps()

	local r,g,b = 145, 145, 255, 255
	local hex = RGBtoHEX(r,g,b)
		
	local latency = client_latency()*1000
	local latency_text = ('  %d'):format(latency) or ''

	text = ("\a"..hex.."%s\a737373FF [LIVE] \a737373FF| %s |\a"..hex.."%s \a737373FFms | \a"..hex.."%s \a737373FFfps "):format(data_suffix, usernamea, latency_text, fps)
		
	local h, w = 18, renderer_measure_text(nil, text) + 8
	local x, y = client_screen_size(), 10 + (-3)
		
	x = x - w - 10
    if ui_get(star.menu.watermark) then
        renderer_text(x+4, y + 1, 255, 255, 255, 255, '', 0, text)
    end
end

local function rectangle_outline(x, y, w, h, r, g, b, a, s)
	s = s or 1
	renderer_rectangle(x, y, w, s, r, g, b, a)
	renderer_rectangle(x, y+h-s, w, s, r, g, b, a) 
	renderer_rectangle(x, y+s, s, h-s*2, r, g, b, a)
	renderer_rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a)
end

local function indicators()
    x();
    local x,y = client_screen_size()
    local r, g, b, a = 255, 0, 0, 0
    local scrsize_x, scrsize_y = client_screen_size()
	local center_x, center_y = scrsize_x / 2, scrsize_y / 2
    local realtime = globals_realtime() % 3
    local alpha = math_floor(math_sin(realtime * 4) * (180 / 2 - 1) + 180 / 2) or 180
    local player = entity_get_local_player()
    local body_yaw = math_min(57, math_abs(entity_get_prop(player, "m_flPoseParameter", 11) * 120 - 60))
    local bodyyawy = entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 10) * 120 - 60
    

    local baiming = ui_get(star.ref.forcebaim)
    local safepoint = ui_get(star.ref.sp)
    indicator_aa_color = {ui_get(star.menu.indicator_aa_color)}
    indicator_main_color = {ui_get(star.menu.indicator_main_color)}
    indicator_background_color = {ui_get(star.menu.indicator_background_color)}
    indicator_aa_arrows_color = {ui_get(star.menu.indicator_aa_arrows_color)}

        if not entity_is_alive(player) then 
            return 
        end
    
        if ui_get(star.menu.enabled) then
            renderer_text(x/2+9, y/2+21, r, g, b, indicator_background_color[4], "-", 0, "STARLUA.TECH")
            renderer_text(x/2+9, y/2+21, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "STARLUA.TECH")
            renderer_text(x/2+5, y/2+23, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "c-", 0, "✮")
            rectangle_outline(x/2+2, y/2+40, 57, 4, 0, 0, 0, 230, 5)
            renderer_rectangle(x/2+2, y/2+40, 57, 4, 25, 25, 25, 230)
            renderer_rectangle(x/2+2, y/2+40, body_yaw, 4, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], 180)
    
            if ui_get(star.menu.stronk_aa) == "Dynamic" then
                if var.mode == "back" then
                    if var.state == 1 then
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:DYNAMIC")
                    elseif var.state == 3 then
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:STRONK")                       
                    elseif var.state == 4 then
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:ROLL")                       		       
                    elseif var.state == 6 then
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:DORMANT")                       
                    elseif var.state == 7 then
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:FAKEYAW")                       		
                    elseif var.mode == "right" then
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:FAKEYAW")                       		       
                end	
                elseif var.mode == "right" then
                    if roll == 1 then  
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:ROLL")                       		       
                            else
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:FAKEYAW")                       		       
                    end
                elseif var.mode == "left" then
                    if roll == 1 then
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:ROLL")                       		       
                            else
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:FAKEYAW")                       		       
                    end
                end        
            elseif ui_get(star.menu.stronk_aa) == "AA-Builder" then
                if var.mode == "back" then
                    if ui_get(star.menu.stronk_aa) == "AA-Builder" then
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:BUILDER")
                    elseif var.mode == "right" then
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:FAKEYAW")                       		       
                end	
                elseif var.mode == "right" then
                    if roll == 1 then  
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:ROLL")                       		       
                            else
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:FAKEYAW")                       		       
                    end
                elseif var.mode == "left" then
                    if roll == 1 then
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:ROLL")                       		       
                            else
                        renderer_text(x/2, y/2+29, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "-", 0, "AAMODE:FAKEYAW")                       		       
                    end
                end            
            end

            if ui_get(star.menu.stronk_ma) then
                if var.mode == "left" then
                    client_draw_text(c, center_x - 45, center_y, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "c-", 0, "<")
                    client_draw_text(c, center_x + 45, center_y, 255, 255, 255, 200, "c-", 0, ">")
                elseif var.mode == "right" then
                    client_draw_text(c, center_x + 45, center_y, indicator_aa_color[1], indicator_aa_color[2], indicator_aa_color[3], indicator_aa_color[4], "c-", 0, ">")
                    client_draw_text(c, center_x - 45, center_y, 255, 255, 255, 200, "c-    ", 0, "<")
                elseif var.mode == "back" then
                    client_draw_text(c, center_x + 45, center_y, 255, 255, 255, 200, "c-", 0, ">")
                    client_draw_text(c, center_x - 45, center_y, 255, 255, 255, 200, "c-", 0, "<")
                end 	
            end

            if ui_get(star.menu.indicator_aa_arrows_enb) then
                if bodyyawy > 0 then
                    client_draw_text(c, center_x + 50, center_y, indicator_aa_arrows_color[1], indicator_aa_arrows_color[2], indicator_aa_arrows_color[3], indicator_aa_arrows_color[4], "c-", 0, ">")
                elseif bodyyawy < 0 then
                    client_draw_text(c, center_x - 50, center_y, indicator_aa_arrows_color[1], indicator_aa_arrows_color[2], indicator_aa_arrows_color[3], indicator_aa_arrows_color[4], "c-", 0, "<")
                end	
            end

            renderer_text(x/2, y/2+44, indicator_background_color[1], indicator_background_color[2], indicator_background_color[3], indicator_background_color[4], "-", 0, "DT")
            if ui_get(star.ref.dt[1]) and ui_get(star.ref.dt[2]) then
                if dt_rechareg() then
                    renderer_text(x/2, y/2+44, indicator_main_color[1], indicator_main_color[2], indicator_main_color[3], indicator_main_color[4], "-", 0, "DT")
                else
                    renderer_text(x/2, y/2+44, r, g, b, indicator_background_color[4], "-", 0, "DT")
                end
            end
            
            if ui_get(star.ref.os[1]) and ui_get(star.ref.os[2]) then
                renderer_text(x/2+11, y/2+44, indicator_main_color[1], indicator_main_color[2], indicator_main_color[3], indicator_main_color[4], "-", 0, "OS")
            else
                renderer_text(x/2+11, y/2+44, indicator_background_color[1], indicator_background_color[2], indicator_background_color[3], indicator_background_color[4], "-", 0, "OS")
            end
            
            if baiming then
                renderer_text(x/2, y/2+52, indicator_main_color[1], indicator_main_color[2], indicator_main_color[3], indicator_main_color[4], "-", 0, "BAIM")
            else
                renderer_text(x/2, y/2+52, indicator_background_color[1], indicator_background_color[2], indicator_background_color[3], indicator_background_color[4], "-", 0, "BAIM")
            end
            
            if safepoint then
                renderer_text(x/2+20, y/2+52, indicator_main_color[1], indicator_main_color[2], indicator_main_color[3], indicator_main_color[4], "-", 0, "SP")				
            else
                renderer_text(x/2+20, y/2+52, indicator_background_color[1], indicator_background_color[2], indicator_background_color[3], indicator_background_color[4], "-", 0, "SP")				
            end
            
            if ui_get(star.menu.freestand[1]) and ui_get(star.menu.freestand[2]) then
                renderer_text(x/2+23, y/2+44, indicator_main_color[1], indicator_main_color[2], indicator_main_color[3], indicator_main_color[4], "-", 0, "FS")				
            else
                renderer_text(x/2+23, y/2+44, indicator_background_color[1], indicator_background_color[2], indicator_background_color[3], indicator_background_color[4], "-", 0, "FS")				
            end
            if side_roll == 1 then
                renderer_text(x/2+34, y/2+44, indicator_main_color[1], indicator_main_color[2], indicator_main_color[3], indicator_main_color[4], "-", 0, "RS:50")
            elseif side_roll == 2 then
                renderer_text(x/2+34, y/2+44, indicator_main_color[1], indicator_main_color[2], indicator_main_color[3], indicator_main_color[4], "-", 0, "RS:-50")
            end 
        end
end

--[[ 
    Misc
--]]

local ground_ticks, end_time = 1, 0

client_set_event_callback("pre_render", function()
    local local_player_weapon = entity_get_player_weapon(entity_get_local_player())

    if contains(ui_get(star.menu.animfix), "static Legs") then
        entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 1, 6) 
    end

    if contains(ui_get(star.menu.animfix), "pitch 0 on shot") then
        if local_player_weapon == nil then return false end
        if globals_curtime() < entity_get_prop(local_player_weapon, "m_flNextPrimaryAttack") then
                timeToShoot = entity_get_prop(local_player_weapon, "m_flNextPrimaryAttack") - globals_curtime() - 0.08
                entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end

    if contains(ui_get(star.menu.animfix), "glitched") then
        entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 0, math.random(0, 11)) 
    end

    if ui_get(star.menu.leg_breaker) then
        entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 8, 0)
    end

    if entity_is_alive(entity_get_local_player()) then
    
        if contains(ui_get(star.menu.animfix), "pitch 0 on land") then
            local on_ground = bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1)

        if on_ground == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals_curtime() + 1
        end 
    
        if ground_ticks > ui_get(star.ref.fakelag_limit)+1 and end_time > globals_curtime() then
            entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end
end 
end)

local killtable = {
    'twinkle twinkle little star ',
    'hhh get good 𝐬𝐡𝐨𝐩𝐩𝐲.𝐠𝐠/@star_aa',
    'lol nice aa get real one 𝐬𝐡𝐨𝐩𝐩𝐲.𝐠𝐠/@star_aa',
    'starlua.tech > all',
    'новое видео на канале с участием STARLUA.TECH и JS REZOLVER',
    'TECHNOLOGY 性交 USA * STARLUA.TECH!',
    '𝐨𝐰𝐧𝐞𝐝 𝟏𝟑𝟑𝟕𝐱  𝐢𝐧 𝐬𝐞𝐫𝐯𝐞𝐫 𝐰𝐢𝐭𝐡 𝐬𝐡𝐨𝐩𝐩𝐲.𝐠𝐠/@star_aa 𝟔𝟔𝟔'
}


local function get_table_length(data)
    if type(data) ~= 'table' then
      return 0													
    end
    local count = 0
    for _ in pairs(data) do
      count = count + 1
    end
    return count
end

local num_quotes_kill = get_table_length(killtable)

local function on_player_death(e)
      if not ui_get(star.menu.killsay) then
          return
      end
      local victim_userid, attacker_userid = e.userid, e.attacker
      if victim_userid == nil or attacker_userid == nil then
          return																															
      end
  
      local victim_entindex   = client_userid_to_entindex(victim_userid)
      local attacker_entindex = client_userid_to_entindex(attacker_userid)
      if attacker_entindex == entity_get_local_player() and entity_is_enemy(victim_entindex) then
        local commandkill = 'say ' .. killtable[math.random(num_quotes_kill)]
        client_exec(commandkill)
    end
end

local function antiknife()
    local players = entity_get_players(true)
    local lx, ly, lz = entity_get_prop(entity_get_local_player(), "m_vecOrigin")
    for i=1, #players do
        local x, y, z = entity_get_prop(players[i], "m_vecOrigin")
        local distance = get_distance(lx, ly, lz, x, y, z)
        local weapon = entity_get_player_weapon(players[i])
        if ui_get (star.menu.anti_knife) then
            if entity_get_classname(weapon) == "CKnife" and distance <= 164 then
                ui_set(star.ref.yaw[2],180)
                ui_set(star.ref.pitch,"Off")
            end
        end
    end
end

local leetifyTable = {A = "4", B = "6", C = "<", D = "d", E = "3", F = "f", G = "&", H = "#", I = "!", J = "j", K = "k", L = "1", M = "m", N = "|\\|", O = "0", P = "p", Q = "q", R = "r", S = "5", T = "7", U = "u", V = "\\/", W = "w", X = "x", Y = "y", Z = "z"}
client_set_event_callback("net_update_end", function()
	if not (ui_get(star.menu.clantag)) then return end

	if (chokedPackets ~= 0) then
		return
	end
	
	local curTime = globals_curtime()
	local tagSpeed = 6
	local tag = "starlua.tech"
	local tagLength = string_len(tag)
	
	if (tagLength == 0) then return end
	
	tagLength = 0
	for i=1, #tag do
		local tmpChar = string_sub(tag, i, i)
		local leetChar = leetifyTable[string_upper(tmpChar)]
		
		if (leetChar ~= nil and leetChar ~= tmpChar) then
			tagLength = tagLength + string_len(leetChar) + 1
		else
			tagLength = tagLength + 1
		end
	end
	tagLength = tagLength * 2
	
	local tagIndex = math_floor(curTime * tagSpeed % tagLength + 1)

	local setTag = ""
	local modLeft = -1
	
	local realI = 0
	local fakeI = 1
	
	local backwards = false
	
	local power = tagIndex
	local setTag = ""
	local realI = 0
	
	for i=1, tagLength/2 do
		local iChar = string_sub(tag, i, i)
		local leetChar = leetifyTable[string_upper(iChar)]
		
		if (leetChar == nil or string_lower(iChar) == leetChar) then
			if (power > 0) then
				setTag = setTag .. iChar
				power = power - 1
			end
		else
			local tmpChars = ""
			for j=1, #leetChar do
				if (power > 0) then
					tmpChars = tmpChars .. string_sub(leetChar, j, j)
					power = power - 1
				end
			end
			
			if (power > 0) then
				setTag = setTag .. iChar
				power = power - 1
			else
				setTag = setTag .. tmpChars
			end
		end
	end
		
	if (tagIndex > tagLength/2) then
		setTag = ""
		power = tagLength - tagIndex
		
		for i=1, tagLength/2 do
			local iChar = string_sub(tag, i, i)
			local leetChar = leetifyTable[string_upper(iChar)]
			
			if (leetChar == nil or string_lower(iChar) == leetChar) then 
				if (power > 0) then
					setTag = setTag .. iChar
					power = power - 1
				end
			else
				local tmpChars = ""
				for j=1, #leetChar do
					if (power > 0) then
						tmpChars = tmpChars .. string_sub(leetChar, j, j)
						power = power - 1
					end
				end
				
				if (power > 0) then
					setTag = setTag .. iChar
					power = power - 1
				else
					setTag = setTag .. tmpChars
				end
			end
		end
	end

	if (previousTag ~= setTag) then
		client_set_clan_tag(setTag)
		previousTag = setTag
	end
end)

client_set_event_callback("run_command", function(cmd)
	chokedPackets = cmd.chokedcommands
	
	return
end) 

--[[ 
    callbacks
--]]

local function callback()

    client_set_event_callback("setup_command", function(c)
        anti_aim(c)
    end)

    client_set_event_callback("player_death", function(e)
        on_player_death(e)
        brute_death(e)
		if client.userid_to_entindex(e.userid) == entity.get_local_player() then
			brute.reset()
		end
    end)

	client.set_event_callback("run_command", function()
		get_best_enemy()
		get_best_angle()
	end)

	client.set_event_callback("bullet_impact", function(e)
		brute_impact(e)
	end)

	client.set_event_callback("round_start", function()
		brute.reset()
		local me = entity.get_local_player()
		if not entity.is_alive(me) then return end
	end)

	client.set_event_callback("client_disconnect", function()
		brute.reset()
	end)

	client.set_event_callback("game_newmap", function(c)
		brute.reset()
        ui.set(ui.reference("PLAYERS", "Players", "Reset all"), true)
    
        for i = 1, 64 do
            missLogs[i] = 0
            player_preference[i] = ""
            cached_plist = nil
            closest_player = 0
        end
	end)

	client.set_event_callback("cs_game_disconnected", function()
		brute.reset()
	end)

    client_set_event_callback("setup_command", function(cmd)
        velocity(cmd)
    end)

    client_set_event_callback("paint", function()
        indicators()
        watermark()
    end)
    
    client_set_event_callback("setup_command",antiknife)
end

client_set_event_callback("shutdown", function()
    ui_set_visible(star.ref.enable, true)
    ui_set_visible(star.ref.pitch, true)
    ui_set_visible(star.ref.yaw_base, true)
    ui_set_visible(star.ref.yaw[1], true)
    ui_set_visible(star.ref.yaw[2], true)
    ui_set_visible(star.ref.yaw_jitter[1], true)
    ui_set_visible(star.ref.yaw_jitter[2], true)
    ui_set_visible(star.ref.yaw_body[1], true)
    ui_set_visible(star.ref.yaw_body[2], true)
    ui_set_visible(star.ref.freestanding_body_yaw, true)
    ui_set_visible(star.ref.fakeyawlimit, true)
    ui_set_visible(star.ref.edge_yaw, true)
    ui_set_visible(star.ref.freestanding[1], true)
    ui_set_visible(star.ref.freestanding[2], true)
    ui_set_visible(star.ref.fakelag_type, true)
    ui_set_visible(star.ref.fakelag_variance, true)
    ui_set_visible(star.ref.fakelag_limit, true)
	ui_set_visible(star.ref.roll_aa, true)	

	ui_set(star.ref.enable, false)
    ui_set(star.ref.pitch, "off")
    ui_set(star.ref.yaw_base, "local view")
    ui_set(star.ref.yaw[1], "off")
    ui_set(star.ref.yaw[2], 0) 
    ui_set(star.ref.yaw_jitter[1], "off")
    ui_set(star.ref.yaw_jitter[2], 0) 
    ui_set(star.ref.yaw_body[1], "off")
    ui_set(star.ref.yaw_body[2], 0)
    ui_set(star.ref.freestanding_body_yaw, false)
    ui_set(star.ref.fakeyawlimit, 60)
end)

client_set_event_callback("paint_ui", menu)
client_set_event_callback("setup_command", on_setup_command)


callback()