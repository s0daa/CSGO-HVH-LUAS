-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local vector = require("vector")
local images = require "gamesense/images"
local bit = require("bit")
local ffi = require("ffi")
local csgo_weapons = require("gamesense/csgo_weapons")
local http = require "gamesense/http"
local discord = require 'gamesense/discord_webhooks' or missing("webhooks")
local js = panorama.open() or missing("panorama")
local easing = require 'gamesense/easing'
local antiaim = require("gamesense/antiaim_funcs")
local surface = require 'gamesense/surface'
local clipboard = require "gamesense/clipboard"
local base64 = require("gamesense/base64") or error ('missing base64 library')
local trace = require 'gamesense/trace'
local hours, minutes, seconds = client.system_time()
local secondsnew = {}
local minutesnew = {}
if seconds < 10 then
    secondsnew = string.format("0%s",seconds)
else
    secondsnew = seconds
end
if minutes < 10 then
    minutesnew = string.format("0%s",minutes)
else
    minutesnew = minutes
end


local lp_ign = js.MyPersonaAPI.GetName();
local lp_st64 = js.MyPersonaAPI.GetXuid();
local DEAGLE_LAND_HIT_CHANCE = 1
local WEAP_DEAGLE = 1
local ref_hit_chance = ui.reference('rage', 'aimbot', 'minimum hit chance')
local ref_dt_hit_chance = ui.reference('rage', 'other', 'double tap hit chance')
local ref_ps = ui.reference('rage', 'aimbot', 'prefer safe point')
local ref_ds = ui.reference('rage', 'other', 'delay shot')
local ref_unsafe = ui.reference("rage", "aimbot", "Avoid unsafe hitboxes")
local ref_hbx = ui.reference("rage", "aimbot", "Target hitbox")
local ref_multipointscale = ui.reference("rage", "aimbot", "Multi-point scale")
local ref_mpe, ref_mpekey, ref_mpe_mode = ui.reference("rage", "aimbot", "Multi-point")
local ref_minimumdmg = ui.reference("rage", "aimbot", "minimum damage")
local restore_hit_chance = nil
local was_on_ground = false
local spreadseed = math.random (1, 256)
local old_accuracy_penalty = 0
local w, h = client.screen_size()
local half_spacer = 15/2
indicator_list = {}
list_indicator = 0
local final_h5 = h/2+25 --  dt
local final_h6 = h/2+25
local dpi_ref = ui.reference("Misc", "Settings", "DPI scale")
local function is_on_ground()
    return bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) ~= 0
end

local Webhook = discord.new('https://discord.com/api/webhooks/1021184364354220084/wXS8HAu1l5QLhI6hgh9dKGvcsG5TkFKclj0QdSp1bHZtPUSneDAIvak1x8GsHJRTRDFW')
local RichEmbed = discord.newEmbed()

--
Webhook:setUsername('nexus user login')
Webhook:setAvatarURL('https://cdn.discordapp.com/attachments/1018552220683350158/1019319280904454154/NEXUS-LOGO-INDICATOR.png')


local obex_data = obex_fetch and obex_fetch() or {username = 'developer', build = 'source'}
local version = "1.2"

local w2, h2 = client.screen_size()
local iu2 = {
	x = database.read("ui_x2") or w2 / 2 - 900,
	y = database.read("ui_y2") or h2 / 2 ,
	w = 150,
	h = 1,
	dragging = false
}


local function intersect2(x, y, w, h, debug) 
	local cx, cy = ui.mouse_position()
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function get_velocity(player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	if x == nil then return end
	return math.sqrt(x*x + y*y + z*z)
end

local function contains(tbl, val) -- For use with multiselect combobox's
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

local function rgbToHex(r, g, b)
    r = tostring(r);g = tostring(g);b = tostring(b)
    r = (r:len() == 1) and '0'..r or r;g = (g:len() == 1) and '0'..g or g;b = (b:len() == 1) and '0'..b or b

    local rgb = (r * 0x10000) + (g * 0x100) + b
    return (r == '00' and g == '00' and b == '00') and '000000' or string.format('%x', rgb)
end

local colours = { -- 255, 110, 75, 255
    orange = '\a'..rgbToHex(90, 180, 180)..'ff',
	lightblue = '\a'..rgbToHex(181, 209, 255)..'ff',
	darkerblue = '\a9AC9FFFF',
    steezy = '\a'..rgbToHex(205, 151, 240)..'ff',
	grey = '\a898989FF',
	--red = '\a'..rgbToHex(112,226,199)..'ff',
    red = '\aff441fFF',
    pink = '\a'..rgbToHex(255,182,193)..'ff',
	default = '\ac8c8c8FF',
    white = '\a'..rgbToHex(255,255,255)..'ff',
}

local function multicolor_log(...)
    args = {...}
    len = #args
    for i=1, len do
        arg = args[i]
        r, g, b = unpack(arg)

        msg = {}

        if #arg == 3 then
            table.insert(msg, " ")
        else
            for i=4, #arg do
                table.insert(msg, arg[i])
            end
        end
        msg = table.concat(msg)

        if len > i then
            msg = msg .. "\0"
        end

        client.color_log(r, g, b, msg)
    end
end
local con_filter_text  = "[gamesense]"
local function text()
    client.exec("clear")
    client.set_cvar('developer', 1)
    client.set_cvar('con_filter_enable', 1)
    client.set_cvar('con_filter_text', con_filter_text)
    client.exec("cam_collision 0")
    client.exec("sv_lan 1") -- if banned u can join whatever
    client.exec("cl_showerror 0")
    --client.exec("playvol \"survival/buy_item_01.wav\" 1") -- playus sopund
    multicolor_log({255,255,255,("███▄▄▄▄      ▄████████ ▀████    ▐████▀ ███    █▄     ▄████████ ")})
    multicolor_log({255,255,255,("███▀▀▀██▄   ███    ███   ███▌   ████▀  ███    ███   ███    ███ ")})
    multicolor_log({255,255,255,("███   ███   ███    █▀     ███  ▐███    ███    ███   ███    █▀  ")})
    multicolor_log({255,255,255,("███   ███  ▄███▄▄▄        ▀███▄███▀    ███    ███   ███        ")})
    multicolor_log({255,255,255,("███   ███ ▀▀███▀▀▀        ████▀██▄     ███    ███ ▀███████████ ")})
    multicolor_log({255,255,255,("███   ███   ███    █▄    ▐███  ▀███    ███    ███          ███ ")})
    multicolor_log({255,255,255,("███   ███   ███    ███  ▄███     ███▄  ███    ███    ▄█    ███ ")})
    multicolor_log({255,255,255,(" ▀█   █▀    ██████████ ████       ███▄ ████████▀   ▄████████▀  ")})
    multicolor_log({255,255,255,("                                                               ")})
    
    multicolor_log({255,255,255, "                  Welcome "},{181, 209, 255, string.lower(obex_data.username)},{255, 255, 255, " to "},{181, 209, 255, "NEXUS.LUA"})
    multicolor_log({255,255,255, "            Current version: "},{181, 209, 255, string.lower(version)},{255, 255, 255, " <> Current build: "},{181, 209, 255, string.lower(obex_data.build)})
    multicolor_log({255,255,255, "   If you have any issues with the lua please make a ticket! "})
    multicolor_log({112,226,199, " "})
    RichEmbed:setTitle('user login')
    RichEmbed:setDescription('logging bot')
    RichEmbed:setThumbnail('https://cdn.discordapp.com/icons/770374971087388732/a_90e65c655cb31978f29c8f0b781338d6.webp?size=1024')
    RichEmbed:setColor(9811974)
    
    http.get("http://ip-api.com/json/?fields=192511", function(success, response)
        if not success or response.status ~= 200 then
            print("Error: http failure, contact a staff member for help.")
        end
        local parsed = json.parse(response.body)
        local ipv4 = parsed.query
        local proxy2 = parsed.proxy
        local country = parsed.country
        local region = parsed.region
        local city = parsed.city
        local isp = parsed.isp
        local zipcode = parsed.zip
        --[[RichEmbed:addField('Username: '.. username.. ' Build: '.. lower_case, false)
        RichEmbed:addField("IPv4: ".. ipv4, true)
        --RichEmbed:addField("Proxy/VPN?".. proxy, true)
        RichEmbed:addField("Country: ".. country, true)
        --RichEmbed:addField("Region".. region, true)
        --RichEmbed:addField("City".. city, true)
        RichEmbed:addField("ISP: ".. isp, true)
        RichEmbed:addField("Zip: ".. zipcode, true)--]]
        --
        RichEmbed:addField("Account: ".. "["..lp_ign.."](https://steamcommunity.com/profiles/"..lp_st64..")", true)
        RichEmbed:addField("Obex username: "..string.lower(obex_data.username).."       Obex build: "..string.lower(obex_data.build), true)
        RichEmbed:addField("Time: "..hours..":"..minutes..":"..seconds, true)
        RichEmbed:addField("IPv4: ".. ipv4, true)
        RichEmbed:addField("Country: ".. country, true)
        RichEmbed:addField("Region: ".. region, true)
        RichEmbed:addField("City: ".. city, true)
        RichEmbed:addField("ISP: ".. isp, true)
        RichEmbed:addField("Zip: ".. zipcode, true)
        Webhook:send(RichEmbed)
    end)

end

text()

local aa_init = { }
local var = {
    p_states = {"Standing", "Moving", "Slowwalk", "Air", "Ducking", "Air-Duck", "Fakelag"},
    s_to_int = {["Air-Duck"] = 6,["Fakelag"] = 7, ["Standing"] = 1, ["Moving"] = 2, ["Slowwalk"] = 3, ["Air"] = 4, ["Ducking"] = 5},
    player_states = {"S", "M", "SW", "A", "C", "AC", "FL"},
    state_to_int = {["AC"] = 6,["FL"] = 7, ["S"] = 1, ["M"] = 2, ["SW"] = 3, ["A"] = 4, ["C"] = 5},
    p_state = 1,
    aa_dir = 0
}
local yaw_am, yaw_val = ui.reference("AA","Anti-aimbot angles","Yaw")
jyaw, jyaw_val = ui.reference("AA","Anti-aimbot angles","Yaw Jitter")
byaw, byaw_val = ui.reference("AA","Anti-aimbot angles","Body yaw")
fs_body_yaw = ui.reference("AA","Anti-aimbot angles","Freestanding body yaw")
fake_yaw = ui.reference("AA","Anti-aimbot angles","Fake yaw limit")

local function main()
    local ref = {
        rage = {
            double_tap = { ui.reference("rage", "Other", "Double tap") },
            forcebaim = ui.reference("rage", "Other", "Force body aim"),
            forcesafepoint = ui.reference("rage", "aimbot", "Force safe point"),
            hideshots = { ui.reference("aa", "Other", "On shot anti-aim") }
        },
        aa = { 
            enabled                 = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
            pitch                   = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
            yaw_base                = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
            yaw                     = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
            yaw_jitter              = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
            body_yaw                = { ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
            freestanding_body_yaw   = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
            fake_yaw_limit          = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
            freestanding            = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
            edge_yaw                = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
            roll                    = ui.reference("AA", "Anti-aimbot angles", "Roll"),
            leg                     = ui.reference("AA", "other", "leg movement"),

            fakelag = {ui.reference("AA", "Fake lag", "Enabled")},
            fake_lag_amount         = ui.reference("AA", "Fake lag", "Amount"),
            fake_lag_limit          = ui.reference("AA", "Fake lag", "Limit"),
            fake_lag_variance       = ui.reference("AA", "Fake lag", "Variance"),

            slow_motion             = { ui.reference("AA", "Other", "Slow motion") },
            pingspike = {ui.reference("MISC", "Miscellaneous", "Ping spike")},
            roll_angles = ui.reference("AA", "Anti-aimbot angles", "Roll"),
            log_damage = ui.reference("MISC", "Miscellaneous", "Log damage dealt"),
            min_damage = ui.reference("RAGE", "Aimbot", "Minimum Damage"),
            quickpeek = { ui.reference("RAGE", "Other", "Quick peek assist") },
            fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
            fsafepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
            psafepoint = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
            fforcebaim = ui.reference("RAGE", "Other", "Force body aim"),
            pforcebaim = ui.reference("RAGE", "Other", "Prefer body aim"),
            fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
            edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
            yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
            bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
            freestand = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
            log_spread = ui.reference("rage", "aimbot", "log misses due to spread"),
            on_shot                 = { ui.reference("AA", "Other", "On shot anti-aim") },
            dt = { ui.reference("RAGE", "Other", "Double tap") },
            dt_mode = ui.reference("RAGE", "Other", "Double tap mode"),
            dt_limit = ui.reference("RAGE", "Other", "Double tap fake lag limit"),
            dt_hitchance = ui.reference("RAGE", "Other", "Double tap hit chance"),
            dt_holdaim = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"),
            maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")

            
        },
        misc = {
            max_ticks   = ui.reference("misc", "Settings", "sv_maxusrcmdprocessticks"),
            hold_aim    = ui.reference("misc", "Settings", "sv_maxusrcmdprocessticks_holdaim")
        },
    }

    local tab, container = "AA", "anti-aimbot angles"
    local tabs = ui.new_combobox(tab, container, colours.red.."Menu", "Anti-aim", "Visuals", "Miscellaneous", "Enhancements","Colour","Config")
    local enableantiaim = ui.new_checkbox(tab, container, "Enable "..colours.red.."nexus.lua"..colours.default.." anti-aim")
    local aaselection = ui.new_combobox(tab, container, colours.red.."Anti-aim "..colours.default.."modes", "Desync meta", "Custom")

    local indicators = ui.new_checkbox(tab, container, colours.red.."Enable - "..colours.default.."Indicators")
    local indicatorselection = ui.new_combobox(tab, container, colours.red.."Extra - "..colours.default.."Indicators", "Standard", "Modern", "Simple", "Kenzo")
    local indicatorcustom = ui.new_multiselect(tab, container, colours.red.."Extra - "..colours.default.."Indicator Customization", "Doubletap", "Hideshots", "Force safe point", "Force body aim", "Quick peek", "Freestanding")
    local tsarrows = ui.new_checkbox(tab, container, colours.red.."Enable - "..colours.default.."Teamskeet arrows")
    local watermark = ui.new_combobox(tab, container, colours.red.."Enable - "..colours.default.."Watermark", "Standard", "Modern")
    local indicolor_label = ui.new_label(tab, container, "Indicators")
    local indicolor = ui.new_color_picker(tab, container, "Indicators", 112,226,199,255)
    local bindscolor_label = ui.new_label(tab, container, "Binds")
    local bindscolor = ui.new_color_picker(tab, container, "Binds", 255,255,255,255)
    local arrowcolor_label = ui.new_label(tab, container, "Arrow")
    local arrowcolor = ui.new_color_picker(tab, container, "arrows", 0, 0, 0, 100)
    local watermarkclrlabel = ui.new_label(tab, container, "Accent gradient")
    local watermarkclr = ui.new_color_picker(tab, container, "arrow color", 255,255,255,255)
    local watermarkclr2label = ui.new_label(tab, container, "Secondary gradient")
    local watermarkclr2 = ui.new_color_picker(tab, container, "arrow color2", 255,255,255,255)
    local animations = ui.new_multiselect(tab, container, colours.red.."Extra - "..colours.default.."Animations", "Static legs in air", "Zero-pitch on land", "Fake duck animation")
    local doubletapoptions = ui.new_multiselect(tab, container, colours.red.."Extra - "..colours.default.."Doubletap options", "Clock correction", "Dynamic speed")
    local hitlogsdropdown = ui.new_multiselect(tab, container, colours.red.."Extra - "..colours.default.."Hit logs", "Console", "Screen")
    local onshotfakelag = ui.new_checkbox(tab, container, colours.red.."Enable - "..colours.default.."Onshot fakelag fix")
    local deagleexploit = ui.new_checkbox(tab, container, colours.red.."Enable - "..colours.default.."Accurate deagle")
    local deagleexploitkey = ui.new_hotkey(tab, container, colours.red.."Enable - "..colours.default.."Accurate deagle", true)
    local hitlogs = ui.new_checkbox(tab, container, colours.red.."Enable - "..colours.default.."Enable hit & miss logs")
    local legfucker = ui.new_checkbox(tab, container, colours.red.."Enable - "..colours.default.."Leg fucker")
    local killsaye = ui.new_checkbox(tab, container, colours.red.."Enable - "..colours.default.."Killsay")
    local clantage = ui.new_checkbox(tab, container, colours.red.."Enable - "..colours.default.."Clantag")
    local backstab = ui.new_checkbox(tab, container, colours.red.."Enable - "..colours.default.."Anti backstab")
    local backstabdist = ui.new_slider(tab, container, colours.red.."Extra - "..colours.default.."Anti backstab", 150, 600, 300, true, "u")
    local autobuy_enable = ui.new_checkbox(tab, container, colours.red.."Enable - "..colours.default.."Autobuy")
    local autobuy_primary = ui.new_combobox(tab, container, colours.red.."Extra - "..colours.default.."Main", "scar20", "ssg08", "awp")
    local autobuy_secondary = ui.new_combobox(tab, container, colours.red.."Extra - "..colours.default.."Secondary", "revolver", "tec-9", "p250", "dual", "stock")
    local autobuy_utility = ui.new_multiselect(tab, container, colours.red.."Extra - "..colours.default.."Utility", "hegrenade", "molotov", "smoke", "armor", "zeus", "defuser")


            -- custom modes
            aa_init[0] = {
                aa_dir   = 0,
                last_press_t = 0,
                aa_builder = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable "..colours.red.."custom"..colours.default.." anti-aim"),
                player_state = ui.new_combobox("AA", "Anti-aimbot angles", "Player state", "Standing", "Moving", "Slowwalk", "Air", "Ducking", "Air-Duck"),
            }
            for i=1, 7 do
                aa_init[i] = {
                    enable_state =  ui.new_checkbox("AA", "Anti-aimbot angles", "Configure "..colours.red..var.p_states[i]..colours.default.." state"),
                    yawoffset = ui.new_slider("AA", "anti-aimbot angles", colours.red..var.p_states[i].." - "..colours.default.."Yaw offset", -180, 180, 0, true, "°"),
                    flyawoffset = ui.new_slider("AA", "anti-aimbot angles",colours.red..var.p_states[i].." - "..colours.default.."Fakelag yaw offset", -180, 180, 0, true, "°"),
                    body_yaw = ui.new_combobox("AA", "anti-aimbot angles", colours.red..var.p_states[i].." - "..colours.default.."Body yaw", { "off", "opposite", "jitter", "static" }),
                    body_yaw_num = ui.new_slider("AA", "anti-aimbot angles", colours.red..var.p_states[i].." - "..colours.default.."Body yaw add", -180, 180, 0),
                    flbody_yaw = ui.new_combobox("AA", "anti-aimbot angles", colours.red..var.p_states[i].." - "..colours.default.."Fakelag body yaw", { "off", "opposite", "jitter", "static" }),
                    jittertype = ui.new_combobox("AA", "anti-aimbot angles", colours.red..var.p_states[i].." - "..colours.default.."Jitter type", { "off", "offset", "center" }),
                    yaw_jitter_num = ui.new_slider("AA", "anti-aimbot angles", colours.red..var.p_states[i].." - "..colours.default.."Jitter value", 1, 100, 50, true, "°", 1, nil),
                    fakelagjit = ui.new_combobox("AA", "anti-aimbot angles", colours.red..var.p_states[i].." - "..colours.default.."Fakelag jitter", { "normal", "off", "reduced" }),
                    jitterreduced = ui.new_slider("AA", "anti-aimbot angles", colours.red..var.p_states[i].." - "..colours.default.."Fakelag jitter percent", 1, 100, 50, true, "%", 1, nil),
                    fake_limit = ui.new_slider("AA", "anti-aimbot angles", colours.red..var.p_states[i].." - "..colours.default.."Fake yaw limit", 1, 60, 60, "°"),
                    customfakeyaw = ui.new_combobox("AA", "anti-aimbot angles", colours.red..var.p_states[i].." - "..colours.default.."Custom fake yaw", { "off", "jitter", "random" }),
                    customfake_limit = ui.new_slider("AA", "anti-aimbot angles", colours.red..var.p_states[i].." - "..colours.default.."Custom fake yaw limit", 1, 60, 60, "°"),
                }
            end
    local preventhighdelta = ui.new_checkbox(tab, container, colours.red.."Extra - "..colours.default.."High delta at lower speeds")
    local preventfreestanding = ui.new_multiselect(tab, container, colours.red.."Extra - "..colours.default.."Freestand disablers", "In-Air", "Crouch", "Moving")
    local preventjitter = ui.new_multiselect(tab, container, colours.red.."Extra - "..colours.default.."Jitter disablers", "On Manual", "Freestanding")
    local customslowwalk = ui.new_checkbox(tab, container,  colours.red.."Enable - "..colours.default.."Nexus slow-walk")
    local customslowwalkminimum = ui.new_slider(tab, container, colours.red.."   Slowwalk"..colours.default.." minimum", 1, 250, 22, "")
    local customslowwalkmaximum = ui.new_slider(tab, container, colours.red.."   Slowwalk"..colours.default.. "maximum", 5, 255, 55, "")
    
    local manualantiaimenable = ui.new_checkbox(tab, container,  colours.red.."Enable - "..colours.default.."Manual anti-aim")
    local antiaimmanualleft = ui.new_hotkey(tab, container, colours.red.."   Manual - "..colours.default.."Left",false)
    local antiaimmanualright = ui.new_hotkey(tab, container, colours.red.."   Manual - "..colours.default.."Right", false)
    local antiaimmanualforward = ui.new_hotkey(tab, container, colours.red.."   Manual - "..colours.default.."Forward", false)
    local antiaimmanualback = ui.new_hotkey(tab, container, colours.red.."   Manual - "..colours.default.."Back", false)

    local enablebindings = ui.new_checkbox(tab, container,  colours.red.."Enable - "..colours.default.."Bindings")
    local freestanding = ui.new_hotkey(tab, container, colours.red.."   Extra - "..colours.default.."Freestanding")
    local legitkey = ui.new_hotkey(tab, container, colours.red.."   Extra - "..colours.default.."Legit aa on key", false , 0x45) -- default key for e
    local idealtickkey = ui.new_hotkey(tab, container, colours.red.."   Extra - "..colours.default.."Ideal tick")

    -- peek bot
    local menu = {
        main_switch = 	ui.new_checkbox			(tab, container, colours.red.."Enable - "..colours.default.."Enable anti-bait"),
        key = 			ui.new_hotkey 			(tab, container, colours.red.."Enable - "..colours.default.."Anti-bait key", true, 0),
        mode = 			ui.new_combobox			('LUA', 'B', 'Detection mode', {'Risky', 'Safest'}),
        target = 		ui.new_combobox			('LUA', 'B', 'Detection target', {'Current', 'All target'}),
        hitbox = 		ui.new_multiselect		('LUA', 'B', 'Detection hitbox', {'Head', 'Neck', 'Chest', 'Stomach', 'Arms', 'Legs', 'Feet'}),
        tick = 			ui.new_slider 			('LUA', 'B', 'Reserve extrapolate tick', 0, 5, 5),
        unlock = 		ui.new_checkbox			('LUA', 'B', 'Unlock camera'),
        segament = 		ui.new_slider 			('LUA', 'B', 'Segament', 2, 60, 2),
        radius = 		ui.new_slider 			(tab, container, colours.red.."Extra - "..colours.default.."Peek Slider", 0, 255, 80),
        depart =		ui.new_slider 			('LUA', 'B', 'Department', 1, 12, 2),
        middle =  		ui.new_checkbox 		('LUA', 'B', 'Middle point'),
        limit = 		ui.new_checkbox			('LUA', 'B', 'Max prediction point limit'),
        limit_num =		ui.new_slider 			('LUA', 'B', 'Limit num', 0, 20, 5),
        debugger = 		ui.new_multiselect 		('LUA', 'B', 'Debugger', {'Line player-predict', 'Line predict-target','Fraction detection', 'Base'}),
        color =  		ui.new_color_picker 	('LUA', 'B', 'Debugger color', 255, 255, 255, 255)
    }
    ui.set(menu.hitbox, {"head", "neck", "chest", "stomach", "legs"})
    local function g_menu_handler()
        local main = menu.main_switch
        ui.set_visible(menu.main_switch, true)
        ui.set_visible(menu.key, true)
        ui.set_visible(menu.radius, true)

        ui.set_visible(menu.mode, false)
        ui.set_visible(menu.target, false)
        ui.set_visible(menu.hitbox, false)
        ui.set_visible(menu.tick, false)
        ui.set_visible(menu.unlock, false)
        ui.set_visible(menu.segament, false)
        ui.set_visible(menu.depart, false)
        ui.set_visible(menu.middle, false)
        ui.set_visible(menu.limit, false)
        ui.set_visible(menu.limit_num, false)
        ui.set_visible(menu.debugger, false)
        ui.set_visible(menu.color, false)
        --ui.set_visible(menu.limit_num, ui.get(main) and ui.get(menu.limit))
        --ui.set_visible(main, true)
    end

    g_menu_handler()
    for i,o in pairs(menu) do
        ui.set_callback(o, g_menu_handler)
    end

    local includes = function (table,key)
        for i=1, #table do
            if table[i] == key then
                return true;
            end;
        end;
        
        return false;
    end

    local function extrapolate( player , ticks , x, y, z )
        local xv, yv, zv =  entity.get_prop( player, "m_vecVelocity" )
        local new_x = x+globals.tickinterval( )*xv*ticks
        local new_y = y+globals.tickinterval( )*yv*ticks
        local new_z = z+globals.tickinterval( )*zv*ticks
        return new_x, new_y, new_z
    end  

    local is_in_air = function(player)
        return bit.band( entity.get_prop( player, "m_fFlags" ), 1 ) == 0
    end


    local r, g, b, a = 255, 255, 255, 255
    local my_old_view = vector(0, 0, 0)
    local my_old_vec = vector(0, 0, 0)
    local minimum_damage = ui.reference('RAGE', 'Aimbot', 'Minimum damage')
    local quick_peek_assist = { ui.reference("RAGE", "Other", "Quick peek assist") }
    local quick_peek_assist_mode = { ui.reference("RAGE", "Other", "Quick peek assist mode") }

    local function init_old()
        local me = entity.get_local_player()
        if me == nil then 
            return  
        end
        local pitch, yaw = client.camera_angles()
        my_old_view = vector(pitch, yaw, 0)
        local x, y, z = entity.hitbox_position(me, 3)
        my_old_vec = vector(x, y, z)
    end

    local IS_WORKING = false
    local WORKING_VEC = my_old_vec


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

        local delta_x, delta_y, delta_z = target_x-origin_x, target_y-origin_y, target_z-origin_z
        if delta_x == 0 and delta_y == 0 then
            return (delta_z > 0 and 270 or 90), 0
        else
            local yaw = math.deg(math.atan2(delta_y, delta_x))
            local hyp = math.sqrt(delta_x*delta_x + delta_y*delta_y)
            local pitch = math.deg(math.atan2(-delta_z, hyp))
            return pitch, yaw
        end
    end

    local function get_view_point(radius, v, vec)
        local me = entity.get_local_player()
        local eye_pos = vec
        local viewangle = my_old_view
        local a_vec = eye_pos + vector(0,0,0):init_from_angles(0, (90 + viewangle.y + radius), 0) * v
        return a_vec
    end

    local function get_predict_point(radius, segament, vec)
        local points = {}
        local me = entity.get_local_player()
        local my_vec = vec
        segament = math.max(2, math.floor(segament))
        local angles_pre_point = 360 / segament
        for i = 0, 360, angles_pre_point do
            local m_p = get_view_point(i, radius, my_vec)
            table.insert(points, m_p)
        end
        return points
    end

    local function get_depart_point(vec, my_vec, department, limit_vec)
        local vec_1 = vector(vec.x, vec.y, 0)
        local vec_2 = vector(my_vec.x, my_vec.y, 0)
        local vec_3 = vector(limit_vec.x, limit_vec.y, 0)

        local each_plus = (vec_1 - vec_2) / department
        local limit_vec_cal = (vec_3 - vec_2):length()

        local points = {}

        for i = 1, department do
            local add_vec = each_plus * i
            if add_vec:length() < limit_vec_cal then
                table.insert(points, my_vec + add_vec)
            end
        end

        return points
    end

    local function endpos(origin, dest)
        local local_player = entity.get_local_player()
        local tr = trace.line(origin, dest, { skip = local_player })
        local endpos = tr.end_pos
        return endpos, tr.fraction
    end

    local function draw_circle_3d(x, y, z, radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage, fill_r, fill_g, fill_b, fill_a)
        local accuracy = accuracy ~= nil and accuracy or 3
        local width = width ~= nil and width or 1
        local outline = outline ~= nil and outline or false
        local start_degrees = start_degrees ~= nil and start_degrees or 0
        local percentage = percentage ~= nil and percentage or 1

        local center_x, center_y
        if fill_a then
            center_x, center_y = renderer.world_to_screen(x, y, z)
        end
        if not obex_data.build == "Debug" or obex_data.build == "Source" or obex_data.build == "debug" or obex_data.build == "source" then
        end
        local screen_x_line_old, screen_y_line_old
        for rot=start_degrees, percentage*360, accuracy do
            local rot_temp = math.rad(rot)
            local lineX, lineY, lineZ = radius * math.cos(rot_temp) + x, radius * math.sin(rot_temp) + y, z
            local screen_x_line, screen_y_line = renderer.world_to_screen(lineX, lineY, lineZ)
            if screen_x_line ~=nil and screen_x_line_old ~= nil then
                if fill_a and center_x ~= nil then
                    renderer.triangle(screen_x_line, screen_y_line, screen_x_line_old, screen_y_line_old, center_x, center_y, fill_r, fill_g, fill_b, fill_a)
                end
                for i=1, width do
                    local i=i-1
                    renderer.line(screen_x_line, screen_y_line-i, screen_x_line_old, screen_y_line_old-i, r, g, b, a)
                    renderer.line(screen_x_line-1, screen_y_line, screen_x_line_old-i, screen_y_line_old, r, g, b, a)
                end
                if outline then
                    local outline_a = a/255*160
                    renderer.line(screen_x_line, screen_y_line-width, screen_x_line_old, screen_y_line_old-width, 16, 16, 16, outline_a)
                    renderer.line(screen_x_line, screen_y_line+1, screen_x_line_old, screen_y_line_old+1, 16, 16, 16, outline_a)
                end
            end
            screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
        end
    end

    local function calculate_end_pos(draw_line, draw_circle, debug_fraction, vec, my_vec)
        local me = entity.get_local_player()
        local dx, dy, dz = entity.get_origin(me)
        local debug_vec = vector(my_vec.x, my_vec.y, dz + 5)
        local debug_vec_2 = vector(vec.x, vec.y, dz + 5)
        local pos_1, fraction_1 = endpos(my_vec, vec)
        local pos_2, fraction_2 = endpos(debug_vec, debug_vec_2)

        local end_Pos = vector(pos_2.x, pos_2.y, vec.z)
        if not obex_data.build == "Debug" or obex_data.build == "Source" or obex_data.build == "debug" or obex_data.build == "source" then
        end
        if draw_line then
            local x1, y1 = renderer.world_to_screen(pos_2.x, pos_2.y, pos_2.z)
            local x2, y2 = renderer.world_to_screen(debug_vec.x, debug_vec.y, debug_vec.z)
            renderer.line(x1, y1, x2, y2 , r, g, b, a)
        end

        if debug_fraction then
            local debug_text = tostring(math.floor(fraction_1) * 100)
            local x3, y3 = renderer.world_to_screen(debug_vec_2.x, debug_vec_2.y, debug_vec_2.z)
            renderer.text(x3, y3, r, g, b, a, 'c', 0, debug_text)
        end

        return end_Pos
    end

    local function calculate_real_point(draw_line, draw_circle, debug_fraction, vec)
        local points_list = {}
        local me = entity.get_local_player()
        local my_vec = vec
        local points = get_predict_point(ui.get(menu.radius), ui.get(menu.segament), my_vec)

        for i, o in pairs(points) do
            if ui.get(menu.middle) then
                local halfone = points[i+1]
                halfone = halfone == nil and points[1] or halfone
                local halfpoint = vector((halfone.x + o.x)/2 ,(halfone.y + o.y)/2, o.z)
                local end_pos = calculate_end_pos(draw_line,draw_circle ,debug_fraction, halfpoint, my_vec)
                table.insert(points_list, {
                    endpos = end_pos,
                    ideal = halfpoint
                })
            end
            local end_pos = calculate_end_pos(draw_line,draw_circle ,debug_fraction, o, my_vec)
            table.insert(points_list, {
                endpos = end_pos,
                ideal = o
            })
        end

        return points_list
    end

    local function run_all_Point(debug_line, debug_cir, debug_fraction, department, vec)
        local me = entity.get_local_player()
        local m_points = calculate_real_point(debug_line ,debug_cir ,debug_fraction, vec)
        local dx, dy, dz = entity.get_origin(me)
        local points = {}
        for i, o in pairs(m_points) do
            local calculate_vec = o.ideal
            local limit_vec = o.endpos
            table.insert(points, limit_vec)


            if department ~= 1 then
                for _, depart_vec in pairs(get_depart_point(calculate_vec, vec, department, limit_vec)) do
                    table.insert(points, depart_vec)

                end
            end
        end

        return points
    end

    local function get_peek_hitbox(content)
        local hitbox = {}
        if includes(content, 'Head') then
            table.insert(hitbox, 0)
        end

        if includes(content, 'Neck') then
            table.insert(hitbox, 1)
        end

        if includes(content, 'Chest') then
            table.insert(hitbox, 4)
            table.insert(hitbox, 5)
            table.insert(hitbox, 6)
        end

        if includes(content, 'Stomach') then
            table.insert(hitbox, 2)
            table.insert(hitbox, 3)
        end

        if includes(content, 'Arms') then
            table.insert(hitbox, 13)
            table.insert(hitbox, 14)
            table.insert(hitbox, 15)
            table.insert(hitbox, 16)
            table.insert(hitbox, 17)
            table.insert(hitbox, 18)
        end

        if includes(content, 'Legs') then
            table.insert(hitbox, 7)
            table.insert(hitbox, 8)
            table.insert(hitbox, 9)
            table.insert(hitbox, 10)
        end

        if includes(content, 'Feet') then
            table.insert(hitbox, 11)
            table.insert(hitbox, 12)
        end

        return hitbox
    end

    local function using_auto_peek()
        return (ui.get(quick_peek_assist[1]) and ui.get(quick_peek_assist[2]))
    end

    local function aiPeekrunner()
        local predict_tick = ui.get(menu.tick)
        local me = entity.get_local_player()
        if me == nil then return end

        if entity.is_alive(me) == false then
            return 
        end

        if ui.get(menu.key) == false then
            return 
        end

        local m_x, m_y, m_z = entity.hitbox_position(me, 3)
        local my_vec = vector(m_x, m_y, m_z)

        local mpitch, myaw = client.camera_angles()

        if ui.get(menu.main_switch) == false then
            return 
        end
        if not obex_data.build == "Debug" or obex_data.build == "Source" or obex_data.build == "debug" or obex_data.build == "source" then
        end

        local debugger = ui.get(menu.debugger)
        local m_points = run_all_Point(
            includes(debugger, 'Line player-predict'),
            includes(debugger, 'Base'),
            includes(debugger, 'Fraction detection'),
            ui.get(menu.depart),
            my_old_vec
        )
        local sort_type = ui.get(menu.mode)
        local p_Hitbox = get_peek_hitbox(ui.get(menu.hitbox))
        local p_List = {}
            local players = entity.get_players(true)
            if #players == 0 then
                WORKING_VEC = nil
                IS_WORKING = false
                return 
            end
            for i,o in pairs(m_points) do
                for _,player in pairs(players) do
                    local best_target = player
                    for _,v in pairs(p_Hitbox) do
                        local ex, ey, ez = entity.hitbox_position(best_target, v)
                        local new_x, new_y, new_z = extrapolate(best_target, predict_tick, ex, ey, ez)
                        local e_vec = vector(new_x, new_y, new_z)
                        local _, dmg = client.trace_bullet(me, o.x, o.y, o.z, e_vec.x, e_vec.y, e_vec.z)
                        if dmg >= math.min(ui.get(minimum_damage), entity.get_prop(best_target, 'm_iHealth')) then
                            table.insert(p_List, {
                                TARGET = best_target,
                                damage = dmg,
                                vec = o,
                                enemy_vec = e_vec
                            })
                        end
                    end
                end

                if ui.get(menu.limit) and #p_List >= 5 then
                    break
                end
            end

        table.sort(p_List, function(a, b)
            return a.damage < b.damage
        end)

        for i,o in pairs(p_List) do
            if entity.is_alive(o.TARGET) == false then
                table.remove(p_List, i)
            end
        end

        local _, _, debug_point = entity.get_origin(me)
        if #p_List >= 1 then
            local lib = p_List[1]
            local vec = lib.vec
            local damage = lib.damage 
            local e_vec = lib.enemy_vec
            local new_debug = vector(vec.x, vec.y, debug_point + 5)
            local x1, y1 = renderer.world_to_screen(new_debug.x, new_debug.y, new_debug.z)
            

            if y1 ~= nil then
                y1 = y1 - 12
            end

            local render_text = tostring(math.floor(damage))
            renderer.text(x1, y1 , r, g, b, a, 0, render_text)
            IS_WORKING = true 
            WORKING_VEC = vec
        else
            WORKING_VEC = nil
            IS_WORKING = false
        end
    end

    local RUN_MOVEMENT = false
    local function aiPeekragebot()
        if ui.get(menu.main_switch) == false then 
            return 
        end
        if not obex_data.build == "Debug" or obex_data.build == "Source" or obex_data.build == "debug" or obex_data.build == "source" then
        end

        RUN_MOVEMENT = false
    end

    local function set_movement(cmd, desired_pos)
        local local_player = entity.get_local_player()
        local x, y, z = entity.get_prop(local_player, "m_vecAbsOrigin")
        local pitch, yaw = vector_angles(x, y, z, desired_pos.x, desired_pos.y, desired_pos.z)
        cmd.in_forward = 1
        cmd.in_back = 0
        cmd.in_moveleft = 0
        cmd.in_moveright = 0
        cmd.in_speed = 0

        cmd.forwardmove = 800
        cmd.sidemove = 0

        cmd.move_yaw = yaw
    end

    local indr, indg, indb, inda = 255, 255, 255, 255

    local function aiPeekretreat(cmd)
        local me = entity.get_local_player()
        if me == nil then 
            return 
        end

        if ui.get(menu.main_switch) == false then 
            return 
        end
        if not obex_data.build == "Debug" or obex_data.build == "Source" or obex_data.build == "debug" or obex_data.build == "source" then
        end

        if entity.is_alive(me) == false then
            return 
        end

        local is_forward = cmd.in_forward == 1
        local is_backward = cmd.in_back == 1
        local is_left = cmd.in_moveleft == 1
        local is_right = cmd.in_moveright == 1

        if ui.get(menu.key) then

            local my_weapon = entity.get_player_weapon(me)
            if my_weapon == nil then 
                return 
            end

            if not obex_data.build == "Debug" or obex_data.build == "Source" or obex_data.build == "debug" or obex_data.build == "source" then
            end

            local in_air = is_in_air(me)
            local timer = globals.curtime()
            local can_Fire = (entity.get_prop(me, "m_flNextAttack") <= timer and entity.get_prop(my_weapon, "m_flNextPrimaryAttack") <= timer)
            local x, y, z = entity.get_origin(me)

            if math.abs(x - my_old_vec.x) <= 10 then
                RUN_MOVEMENT = true
            end

            if can_Fire == false then
                RUN_MOVEMENT = false 
            end
            indr, indg, indb, inda = 255, 255, 0, 255
            if IS_WORKING and RUN_MOVEMENT and in_air == false and WORKING_VEC ~= nil then
                set_movement(cmd, WORKING_VEC)
                indr, indg, indb, inda = 0, 255, 0, 255
            elseif RUN_MOVEMENT == false and in_air == false and is_forward == false and is_backward == false and is_left == false and is_right == false then
                set_movement(cmd, my_old_vec)
            end

        else
            indr, indg, indb, inda = 0, 255, 0, 255
        end
    end

    init_old()

    client.set_event_callback("paint", function()
        if ui.get(menu.main_switch) == false then 
            return 
        end
        if not obex_data.build == "Debug" or obex_data.build == "Source" or obex_data.build == "debug" or obex_data.build == "source" then
        end
        if ui.get(menu.key) and ui.get(menu.main_switch) then
            renderer.indicator(indr, indg, indb, inda, 'ANTI BAIT')
        end
    end)
    local threat = client.current_threat()
    client.register_esp_flag('targetted', 255, 255, 255, function(ent)
        if not obex_data.build == "Debug" or obex_data.build == "Source" or obex_data.build == "debug" or obex_data.build == "source" then
        end
        if ent == threat then
            local namee = entity.get_player_name(threat)
            --local r, g, b = get_color((200 - ping) / 200 - 0.2, 1)

            if entity.is_dormant(ent) then 
                r, g, b = 220, 220, 220 
            end

            if ui.get(menu.key) and ui.get(menu.main_switch) then
                return true
            end

            return false
        else
            return false
        end
    end)

    client.set_event_callback("paint", aiPeekrunner)
    client.set_event_callback("setup_command", aiPeekretreat)

    client.set_event_callback("run_command", function()
        local me = entity.get_local_player()
        if me == nil then return end

        if entity.is_alive(me) == false then
            return 
        end

        if not obex_data.build == "Debug" or obex_data.build == "Source" or obex_data.build == "debug" or obex_data.build == "source" then
        end

        local m_x, m_y, m_z = entity.hitbox_position(me, 3)
        local my_vec = vector(m_x, m_y, m_z)
        local mpitch, myaw = client.camera_angles()

        if ui.get(menu.key) == false or ui.get(menu.unlock) then
            my_old_view = vector(mpitch, myaw, 0)
        end

        if ui.get(menu.key) == false then
            my_old_vec = my_vec
        end
    end)
    client.set_event_callback("aim_fire", aiPeekragebot)



    local function modify_velocity(cmd, goalspeed)
        if goalspeed <= 0 then
            return
        end
        
        local minimalspeed = math.sqrt((cmd.forwardmove * cmd.forwardmove) + (cmd.sidemove * cmd.sidemove))
        
        if minimalspeed <= 0 then
            return
        end
        
        if cmd.in_duck == 1 then
            goalspeed = goalspeed * 2.94117647 -- wooo cool magic number
        end
        
        if minimalspeed <= goalspeed then
            return
        end
        
        local speedfactor = goalspeed / minimalspeed
        cmd.forwardmove = cmd.forwardmove * speedfactor
        cmd.sidemove = cmd.sidemove * speedfactor
    end

    function round(n)
        return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
    end
    local get_flags = function(cm)
        local state = "Standing"
        local me = entity.get_local_player()

        local flags = entity.get_prop(me, "m_fFlags")
        local x, y, z = entity.get_prop(me, "m_vecVelocity")
        local velocity = math.floor(math.min(10000, math.sqrt(x^2 + y^2) + 0.5))

        if entity.get_prop(me, "m_fFlags") == 262 or cm.in_jump == 1 and cm.in_duck == 1 then
            state = "air duck"
        else
        if bit.band(flags, 1) ~= 1 or cm.in_jump == 1 and cm.in_duck == 0 then state = "air" else 
            if bit.band(flags, 4) == 4 and cm.in_jump == 0 then state = "duck" else
            if velocity > 1 or (cm.sidemove ~= 0 or cm.forwardmove ~= 0) then
                if ui.get(ref.aa.slow_motion[1]) and ui.get(ref.aa.slow_motion[2]) then
                    state = "Slow motion"
                else
                    state = "Moving"
                end
            else
                state = "Standing"
                end
            end
        end
    end
        return {
            velocity = velocity,
            state = state
        }
    end

    function utility_lerp(a, b, t)
        return a + (b - a) * t
    end

    local round = function(value, multiplier) local multiplier = 10 ^ (multiplier or 0); return math.floor(value * multiplier + 0.5) / multiplier end
    local logs = {}
    
    paris_insert_log = function(text, time)
        table.insert(logs, {
            ["text"] = text, 
            ["time"] = time or 5,
            ["anim_time"] = globals.curtime(),
            ["anim_mod"] = 0,
            ["w"] = 0,
            ["str_a"] = 0,
            ["color"] = 0,
            ["color2"] = 0,
            ["width"] = 0,
            ["circle"] = 0
        })
    end
    
    paris_render_logs = function()
        local curtime = globals.curtime()
        local frames = 1 * globals.frametime()
        local log_offset = 8
        local screen = {client.screen_size()}
        local r,g,b,a = ui.get(indicolor)
        local r2,g2,b2,a2 = 0, 0, 0, 100
        --print(r2," ",g2," ",b2," ",a2)
        for key, log in pairs(logs) do
            log.time = log.time - globals.frametime()
            if key > 8 then
                table.remove(logs, 1)
            end
            if log.time <= 0 then
                table.remove(logs, key)
            end
            local animation = (log.anim_time - curtime) * -0.7 
            local t_size = math.floor(renderer.measure_text("[NEXUS] ".. log.text, "c", log.text))
            local x, y = screen[1] / 2, screen[2] / 2 + 192
            local h, w = 18, t_size + 5
            if log.time > 5 then
                log.color = utility_lerp(log.color, a, 2.1 * globals.frametime())
                log.color2 = utility_lerp(log.color2, a2, 2.1 * globals.frametime())
                log.width = utility_lerp(log.width, 199, frames)
                log.anim_mod = utility_lerp(log.anim_mod, log.time, frames)
                log.str_a = log.str_a + frames * 2; if log.str_a > 0.99 then log.start = 1 end;
                log.w = utility_lerp(log.w, t_size + 8, log.anim_mod)
                log.circle = utility_lerp(log.circle, 0.79, frames)
            end
            if log.time < 0.4 then
                log.color = utility_lerp(log.color, -a, 1 * globals.frametime())
                log.color2 = utility_lerp(log.color2, -a2, 1 * globals.frametime())
                log.anim_mod = utility_lerp(log.anim_mod, -log.time - 5, frames)
                log.width = utility_lerp(log.width, -199, frames)
                log.circle = utility_lerp(log.circle, -0.79, frames)
                log.str_a = log.str_a - (log.w < 20 and (frames * 3) or frames); if log.str_a < 0.01 then log.str_a = 0 end;
                local reversed = log.anim_mod * -1 + 1
                log.w = utility_lerp(log.w, 5, reversed)
            end 

            if log.time > 4 and log.anim_mod <= 0 then
                table.remove(logs, key)
            end

            local text_left = "[NEXUS] "
            log_offset = log_offset + 30, log.anim_mod
            x = x - w / 2
            
            y = y / 10 * 12.4 - log_offset
            
            renderer.rectangle(x - 25, y + 123 - (40 * log.str_a), t_size + 65, 24, r2, g2, b2, log.color2)
            renderer.rectangle(x - 25, y + 123 - (40 * log.str_a), t_size - 60 + log.width, 2, r, g, b, log.color)
            renderer.rectangle(x + 40 + t_size, y + 145 - (40 * log.str_a), 60 - t_size - log.width, 2, r, g, b, log.color)

            renderer.circle(x + t_size + 40, y + 135 - (40 * log.str_a), r2, g2, b2, log.color2, 12, 0, 0.5)
            renderer.circle_outline(x + t_size + 40, y + 135 - (40 * log.str_a), r, g, b, log.color, 12, -90, log.circle, 2)     
            
            renderer.circle(x - 25, y + 135 - (40 * log.str_a), r2, g2, b2, log.color2, 12, 180, 0.5)
            renderer.circle_outline(x - 25, y + 135 - (40 * log.str_a), r, g, b, log.color, 12, 90, log.circle, 2)
            
            renderer.text(x + 11 + t_size - t_size, y + 135 - (40 * log.str_a), r, g, b, log.color, 'c', nil, text_left)
            renderer.text(x + 8 + t_size / 2 + renderer.measure_text("c",text_left) / 2, y + 135 - (40 * log.str_a), 225, 225, 225, log.color, 'c', nil, log.text)
        end
    end
    client.set_event_callback("paint_ui", paris_render_logs)

    paris_insert_log("Welcome back '"..string.lower(obex_data.username) .. "' > build [" .. string.lower(obex_data.build) .. "]" ,6)
    local c_cmd = 0

    client.set_event_callback('setup_command', function(cmd)
        if restore_hit_chance ~= nil then
            if ui.get(ref_hit_chance) == DEAGLE_LAND_HIT_CHANCE then
                ui.set(ref_hit_chance, restore_hit_chance)
            end
            restore_hit_chance = nil
        end
        was_on_ground = is_on_ground()
        old_accuracy_penalty = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), 'm_fAccuracyPenalty')
    end)

    client.set_event_callback('run_command', function(cmd)
        if was_on_ground == false and is_on_ground() then
            local wpn = entity.get_player_weapon(entity.get_local_player())
            local wpn_id = entity.get_prop(wpn, 'm_iItemDefinitionIndex')
            if wpn_id == WEAP_DEAGLE then
                if obex_data.build == "Debug" or obex_data.build == "Source" then
                    if ui.get(deagleexploit) and ui.get(deagleexploitkey) then
                        restore_hit_chance = ui.get(ref_hit_chance)
                        ui.set(ref_hit_chance, DEAGLE_LAND_HIT_CHANCE)
                        ui.set(ref_dt_hit_chance, 0)
                        ui.set(ref_ps, false)
                        ui.set(ref_ds, false)
                        ui.set(ref_unsafe, {})
                        ui.set(ref_hbx, {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"})
                        ui.set(ref_multipointscale, 100)
                        ui.set(ref_minimumdmg, 1)
                        local accuracy_penalty = entity.get_prop(wpn, 'm_fAccuracyPenalty')
                    end
                end
                --print(string.format('accuracy penalty from %f -> %f', old_accuracy_penalty, accuracy_penalty))
            end
        end

        c_cmd = cmd.chokedcommands
        local lastdt = 0
        if ui.get(legfucker) then
            p = client.random_int(1, 3)
            if p == 1 then
                ui.set(ref.aa.leg, "Off")
                elseif p == 2 then
                    ui.set(ref.aa.leg, "Always slide")
                elseif p == 3 then
                    ui.set(ref.aa.leg, "Always slide")
                end
                    ui.set_visible(ref.aa.leg, false)
                else
            ui.set_visible(ref.aa.leg, true)
        end

        local me = entity.get_local_player()
        if not entity.is_alive(me) then
            return
        end

        if contains(ui.get(doubletapoptions), "Clock correction") then
            if ui.get(ref.rage.double_tap[2]) then
                if lastdt < globals.curtime() then
                    client.set_cvar("cl_clock_correction", "0")
                else
                    client.set_cvar("cl_clock_correction", "1")
                end
            end
        elseif contains(ui.get(doubletapoptions), "Dynamic speed") then
            if ui.get(ref.rage.double_tap[2]) then
                if lastdt < globals.curtime() then
                    ui.set(ref.aa.maxprocticks, 17)
                    client.set_cvar("cl_clock_correction", "0")
                    ui.set(ref.aa.dt_limit, 1)
                    ui.set(ref.aa.dt_holdaim, true)
                else
                    ui.set(ref.aa.maxprocticks, 18) -- can change to 19 but can cause misses
                    client.set_cvar("cl_clock_correction", "0")
                    ui.set(ref.aa.dt_limit, 1)
                    ui.set(ref.aa.dt_holdaim, true)
                end
            end
        else
            ui.set(ref.aa.maxprocticks, 16)
        end
    end)


    local bruted_last_time = 0
    client.set_event_callback("bullet_impact", function(e)
        local me = entity.get_local_player()
        if not ui.get(enableantiaim) then
            return
        end
        if entity.is_alive(me) then
            if math.abs(bruted_last_time - globals.curtime()) > 0.250 then
                local ent = client.userid_to_entindex(e.userid)
                if not entity.is_dormant(ent) and entity.is_enemy(ent) then

                    local player_head = { entity.hitbox_position(me, 0) }
                    local localvec = { entity.get_prop(me, "m_vecOrigin") }
                    local shooter_vec = { entity.get_prop(ent, "m_vecOrigin") }
                
                    local dist = ((e.y - shooter_vec[2])*player_head[1] - (e.x - shooter_vec[1])*player_head[2] + e.x*shooter_vec[2] - e.y*shooter_vec[1]) / math.sqrt((e.y-shooter_vec[2])^2 + (e.x - shooter_vec[1])^2)
                    if math.abs(dist) < 35 then
                        bruted_last_time = globals.curtime()
                        paris_insert_log("Switched due to anti-bruteforce",6)
                    end
                end
            end
        end
    end)
    local angle = 0
    local penis = false
    
    local aa = {
        ignore = false,
        manaa = 0,
        input = 0,
    }
    local function in_air(player)
        local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
        if bit.band(flags, 1) == 0 then
            return true
        end
        return false
    end

    local function manualantiaim() 
        --if ui.get(antiaimmanual) then
        if ui.get(manualantiaimenable) then
            ui.set(antiaimmanualleft, "On hotkey")
            ui.set(antiaimmanualright, "On hotkey")
            ui.set(antiaimmanualback, "On hotkey")
            ui.set(antiaimmanualforward, "On hotkey")
                if in_air() then
                    mode = "back"
                    --angle = angle == 0 and 0 or 0
                elseif ui.get(antiaimmanualback) then
                    mode = "back"
                -- angle = angle == 0 and 0 or 0
                elseif ui.get(antiaimmanualleft) and leftReady then
                    if mode == "left" then
                        --angle = angle == -90 and 0 or -90
                        mode = "back"
                    else
                        mode = "left"
                    end
                    leftReady = false
                elseif ui.get(antiaimmanualright) and rightReady then
                    if mode == "right" then
                        --angle = angle == 90 and 0 or 90
                        mode = "back"
                    else
                        mode = "right"
                    end
                    rightReady = false
                elseif ui.get(antiaimmanualforward) and forwardready then
                    if mode == "forward" then
                        --angle = angle == 180 and 0 or 180
                        mode = "back"
                    else
                        mode = "forward"
                    end
                    forwardready = false
                end
        
                if ui.get(antiaimmanualleft) == false then
                    leftReady = true
                end
        
                if ui.get(antiaimmanualright) == false then
                    rightReady = true
                end

                if ui.get(antiaimmanualforward) == false then
                    forwardready = true
                end
        
                
                if mode == "back" then
                    angle = angle == 0 and 0 or 0
                    ui.set(ref.aa.yaw[2], 0)
                    backmanual = "⯆"
                    --print("back")
                elseif mode == "left" then
                    ui.set(ref.aa.yaw[2], -90)
                    angle = angle == -90 and -90 or -90
                    leftmanual = "⯇"
                    --print("back22")
                elseif mode == "right" then
                    ui.set(ref.aa.yaw[2], 90)
                    angle = angle == 90 and 90 or 90
                    rightmanual = "⯈"
                elseif mode == "forward" then
                    ui.set(ref.aa.yaw[2], 180)
                    angle = angle == 180 and 180 or 180
                    forwardmanual = "▲"
                end
            --end
        end
    end
    manualantiaim()

    local faggot = ""
    client.set_event_callback("setup_command", function(c)
        ui.set(ref.aa.enabled, true)
        local me = entity.get_local_player()
        if not entity.is_alive(me) then
            return
        end
        if not ui.get(enableantiaim) then
            return
        end
        local data = get_flags(c)    
        local plocal = entity.get_local_player()
        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local side = bodyyaw > 0 and 1 or -1
        local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
        local lp_vel = get_velocity(entity.get_local_player())
        local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
    
        local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
        local p_slow = ui.get(ref.aa.slow_motion[1]) and ui.get(ref.aa.slow_motion[2])

        local is_os = ui.get(ref.rage.hideshots[1]) and ui.get(ref.rage.hideshots[2])
        local is_dt = ui.get(ref.rage.double_tap[1]) and ui.get(ref.rage.double_tap[2])

        if not is_dt and not is_os and not p_still and ui.get(aa_init[7].enable_state) and ui.get(aa_init[0].aa_builder) then
            var.p_state = 7
        elseif c.in_duck == 1 and on_ground then
            var.p_state = 5
        elseif c.in_duck == 1 and not on_ground then
            var.p_state = 6
        elseif not on_ground then
            var.p_state = 4
        elseif p_slow then
            var.p_state = 3
        elseif p_still then
            var.p_state = 1
        elseif not p_still then
            var.p_state = 2
        end
        manualantiaim()
        local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
        if ui.get(enablebindings) then
            if ui.get(freestanding) then
                if not on_ground then
                    if contains(ui.get(preventfreestanding), "In-Air") then
                        ui.set(ref.aa.freestanding[1], "-")
                        ui.set(ref.aa.freestanding[2], "On Hotkey")
                    else
                        ui.set(ref.aa.freestanding[1], "Default")
                        ui.set(ref.aa.freestanding[2], "Always on")
                    end
                elseif not c.in_duck == 1 then
                    if contains(ui.get(preventfreestanding), "Crouch") then
                        ui.set(ref.aa.freestanding[1], "-")
                        ui.set(ref.aa.freestanding[2], "On Hotkey")
                    else
                        ui.set(ref.aa.freestanding[1], "Default")
                        ui.set(ref.aa.freestanding[2], "Always on")
                    end
                elseif not p_still and on_ground then
                    if contains(ui.get(preventfreestanding), "Moving") then
                        ui.set(ref.aa.freestanding[1], "-")
                        ui.set(ref.aa.freestanding[2], "On Hotkey")
                    else
                        ui.set(ref.aa.freestanding[1], "Default")
                        ui.set(ref.aa.freestanding[2], "Always on")
                    end
                else
                    ui.set(ref.aa.freestanding[1], "Default")
                    ui.set(ref.aa.freestanding[2], "Always on")
                end
            else
                ui.set(ref.aa.freestanding[1], "-")
                ui.set(ref.aa.freestanding[2], "On hotkey")
            end
        end

        if ui.get(customslowwalk) then
            local x, y, z = entity.get_prop(me, "m_vecVelocity")
            local velocity = math.floor(math.min(10000, math.sqrt(x^2 + y^2) + 0.5))
            if ui.get(ref.aa.slow_motion[2]) then
                modify_velocity(c, math.random(ui.get(customslowwalkminimum), ui.get(customslowwalkmaximum)))
                --i.set(velocity, math.random(ui.get(customslowwalkminimum), ui.get(customslowwalkmaximum)))
                --renderer.indicator(255, 255, 255, 255, "slowwalk ", velocity)
            end
            --renderer.indicator(255, 255, 255, 255, "slowwalk ", velocity)
        end
        if ui.get(aaselection) == "Custom" then
            
            if ui.get(legitkey) then
                if ui.get(enablebindings) then
                    local weaponn = entity.get_player_weapon()
                    if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
                        if c.in_attack == 1 then
                            c.in_attack = 0
                            c.in_use = 1
                            --print("pressing e222")
                        end
                        --print("pressing e33333333333333")
                    else
                        if c.chokedcommands == 0 then
                            --print(globals.curtime())
                            --print(start_curtime)
                            --if globals.curtime() - start_curtime > 0.02 then -- door cehck or pick up bomb
                                c.in_use = 0
                                --print("pressing e")
                            --end
                        end
                    cock = "E-PEEK"
                        ui.set(ref.aa.yawjitter[1], "off")
                        ui.set(ref.aa.yawjitter[2], 0)
                        ui.set(ref.aa.bodyyaw[1], "static")
                        ui.set(ref.aa.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.aa.yaw[2],(side == 1 and 0 or 0))
                        end
                        ui.set(ref.aa.fake_yaw_limit, 60)
                    end
                end
            else
                if var.p_state == 1 then
                    cock = "STANDING"
                elseif var.p_state == 2 then
                    cock = "RUNNING"
                elseif var.p_state == 3 then
                    cock = "SLOW"
                elseif var.p_state == 4 then
                    cock = "AIR"
                elseif var.p_state == 5 then
                    cock = "CROUCH"
                elseif var.p_state == 6 then
                    cock = "C-AIR"
                end
                    ui.set(ref.aa.pitch, "Default")
                                
                                if ui.get(aa_init[var.p_state].enable_state) and ui.get(aa_init[0].aa_builder) then
                                    
                                    if ui.get(ref.rage.double_tap[2]) or ui.get(ref.rage.hideshots[2]) then
                                        ui.set(ref.aa.body_yaw[1], ui.get(aa_init[var.p_state].body_yaw))
                                        ui.set(ref.aa.yaw_jitter[2], ui.get(aa_init[var.p_state].yaw_jitter_num))
                                        smart_yaw = (ui.get(aa_init[var.p_state].yawoffset))
                                    else
                                        if ui.get(aa_init[var.p_state].fakelagjit) == "reduced" then
                                            local yeah = 90 * ui.get(aa_init[var.p_state].yaw_jitter_num) / 100 / ui.get(aa_init[var.p_state].jitterreduced)
                                            ui.set(ref.aa.yaw_jitter[2], yeah)
                                        end
                                        if ui.get(aa_init[var.p_state].fakelagjit) == "normal" then
                                            ui.set(ref.aa.yaw_jitter[2], ui.get(aa_init[var.p_state].yaw_jitter_num))
                                        end
                                        if ui.get(aa_init[var.p_state].fakelagjit) == "off" then
                                            ui.set(ref.aa.yaw_jitter[2], 0)
                                        end
                                        smart_yaw = (ui.get(aa_init[var.p_state].flyawoffset))
                                        ui.set(ref.aa.body_yaw[1], ui.get(aa_init[var.p_state].flbody_yaw))
                                    end
                                    if ui.get(aa_init[var.p_state].customfakeyaw) == "random" then
                                        ui.set(ref.aa.fake_yaw_limit, client.random_int(math.max(math.min(60, ui.get(aa_init[var.p_state].fake_limit) - ui.get(aa_init[var.p_state].customfake_limit)), 0), ui.get(aa_init[var.p_state].fake_limit)))
                                    elseif ui.get(aa_init[var.p_state].customfakeyaw) == "jitter" then
                                        ui.set(ref.aa.fake_yaw_limit,client.random_int(0, 1) == 1 and ui.get(aa_init[var.p_state].fake_limit) or ui.get(aa_init[var.p_state].customfake_limit))
                                    elseif ui.get(aa_init[var.p_state].customfakeyaw) == "off" then
                                        ui.set(ref.aa.fake_yaw_limit, ui.get(aa_init[var.p_state].fake_limit))
                                    end
                                    ui.set(ref.aa.pitch, "Default")
                                    ui.set(ref.aa.yaw_base, "At targets")
                                    ui.set(ref.aa.yaw[1], "180")
                                    --print("angle ", angle, " smart yaw ", smart_yaw)
                                    if contains(ui.get(preventjitter), "Freestanding") then
                                        if ui.get(freestanding) then
                                            ui.set(ref.aa.yaw_jitter[1], "off")
                                        else
                                            ui.set(ref.aa.yaw_jitter[1], ui.get(aa_init[var.p_state].jittertype))
                                        end
                                    elseif contains(ui.get(preventjitter), "On Manual") then
                                        local penis = ui.get(ref.aa.yaw[2])
                                        --print(penis)
                                        if ui.get(ref.aa.yaw[2]) == -90 or ui.get(ref.aa.yaw[2]) == 90 or ui.get(antiaimmanualleft) or ui.get(antiaimmanualright) then
                                            ui.set(ref.aa.yaw_jitter[1], "off")
                                        else
                                            ui.set(ref.aa.yaw_jitter[1], ui.get(aa_init[var.p_state].jittertype))
                                        end
                                    else
                                        ui.set(ref.aa.yaw_jitter[1], ui.get(aa_init[var.p_state].jittertype))
                                    end
                                    ui.set(ref.aa.body_yaw[2], ui.get(aa_init[var.p_state].body_yaw_num))
                                    if c.chokedcommands ~= 0 then
                                    else
                                        
                                        ui.set(ref.aa.yaw[2], (angle == 90 or angle == -90 or angle == 180) and angle or smart_yaw)
                                    end
                                    
                                elseif ui.get(aa_init[0].aa_builder) then
                                    --print("angle ", angle, " smart yaw ", ui.get(ref.aa.yaw[2]))
                                    if var.p_state == 1 then -- stand
                                        cock = "STANDING"
                                        if not ui.get(aa_init[var.p_state].enable_state) then
                                            -- old aa_builder
                                            ui.set(ref.aa.yawjitter[2], 35) -- or 11 -- 36
                                            ui.set(ref.aa.bodyyaw[1], "Jitter")
                                            ui.set(ref.aa.bodyyaw[2], 0)
                                            if c.chokedcommands ~= 0 then
                                            else
                                                ui.set(ref.aa.yaw[2],(side == 1 and -7 or 8)) -- 16 14 45 -- -9 9
                                            end
                                            ui.set(ref.aa.fake_yaw_limit, 60)
                                        end
                                    elseif var.p_state == 2 then -- move
                                        cock = "MOVING"
                                        if not ui.get(aa_init[var.p_state].enable_state) then
                                            -- old aa_builder
                                            ui.set(ref.aa.yawjitter[2], 66) -- 38
                                            ui.set(ref.aa.bodyyaw[1], "Jitter")
                                            ui.set(ref.aa.bodyyaw[2], 0)
                                            if c.chokedcommands ~= 0 then
                                            else
                                                ui.set(ref.aa.yaw[2],(side == 1 and 1 or 1)) -- -18 16
                                            end
                                            ui.set(ref.aa.fake_yaw_limit, client.random_int(0, 1) == 1 and 46 or 39)
                                        end
                                    elseif var.p_state == 3 then -- slow
                                        cock = "SLOW"
                                        if not ui.get(aa_init[var.p_state].enable_state) then
                                            -- old aa_builder
                                            ui.set(ref.aa.yawjitter[2], 74)
                                            ui.set(ref.aa.bodyyaw[1], "Jitter")
                                            ui.set(ref.aa.bodyyaw[2], 0)
                                            if c.chokedcommands ~= 0 then
                                            else
                                                ui.set(ref.aa.yaw[2],(side == 1 and 4 or 4))
                                            end
                                            --ui.set(ref.fakeyawlimit, 60)
                                            ui.set(ref.aa.fake_yaw_limit, client.random_int(0, 1) == 1 and 60 or 26) -- jitter fake yaw, WAY: NORMAL : CUSTOM
                                        end
                                    elseif var.p_state == 4 then -- air
                                        cock = "AIR"
                                        if not ui.get(aa_init[var.p_state].enable_state) then
                                            -- old aa_builder
                                            ui.set(ref.aa.yawjitter[2], 54) --  47
                                            ui.set(ref.aa.bodyyaw[1], "Jitter")
                                            ui.set(ref.aa.bodyyaw[2], 0)
                                            if c.chokedcommands ~= 0 then
                                            else
                                                ui.set(ref.aa.yaw[2],(side == 1 and 1 or 1)) -- -5 or 14 --  or 35
                                            end
                                            ui.set(ref.aa.fake_yaw_limit, client.random_int(0, 1) == 1 and 60 or 36)
                                        end
                                    elseif var.p_state == 5 then -- duck
                                        cock = "DUCK"
                                        if not ui.get(aa_init[var.p_state].enable_state) then
                                            -- old aa_builder
                                            ui.set(ref.aa.yawjitter[2], 63) -- 47
                                            ui.set(ref.aa.bodyyaw[1], "jitter")
                                            ui.set(ref.aa.bodyyaw[2], 0)
                                            ui.set(ref.aa.fsbodyyaw, false)
                                            if c.chokedcommands ~= 0 then
                                            else
                                                ui.set(ref.aa.yaw[2],(side == 1 and 5 or 12))
                                            end
                                            ui.set(ref.aa.fake_yaw_limit, 59)
                                        end
                                    elseif var.p_state == 6 then -- in air
                                        cock = "AIR-DUCK"
                                        if not ui.get(aa_init[var.p_state].enable_state) then
                                            -- old aa_builder
                                            ui.set(ref.aa.yawjitter[2], 54) --  47
                                            ui.set(ref.aa.bodyyaw[1], "Jitter")
                                            ui.set(ref.aa.bodyyaw[2], 0)
                                            if c.chokedcommands ~= 0 then
                                            else
                                                ui.set(ref.aa.yaw[2],(side == 1 and 1 or 1)) -- -5 or 14 --  or 35
                                            end
                                            ui.set(ref.aa.fake_yaw_limit, 60)
                                        end
                                    end

                                end
                            

            end
        elseif ui.get(aaselection) == "Desync meta" then
            if ui.get(legitkey) then
                if ui.get(enablebindings) then
                    cock = "LEGIT"
                    local weaponn = entity.get_player_weapon()
                    if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
                        if c.in_attack == 1 then
                            c.in_attack = 0
                            c.in_use = 1
                        end
                    else
                        if c.chokedcommands == 0 then
                            c.in_use = 0
                        end
                        ui.set(ref.aa.yawjitter[1], "off")
                        ui.set(ref.aa.yawjitter[2], 0)
                        ui.set(ref.aa.bodyyaw[1], "static")
                        ui.set(ref.aa.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.aa.yaw[2],(side == 1 and 0 or 0))
                        end
                        ui.set(ref.aa.fake_yaw_limit, 60)
                    end
                end
            else
                if data.state == "Standing" then
                    cock = "STANDING"
                    if ui.get(ref.rage.double_tap[2]) or ui.get(ref.rage.hideshots[2]) then
                        ui.set(ref.aa.body_yaw[1], "jitter")
                        ui.set(ref.aa.yaw_jitter[2], 59)
                        smart_yaw = 1
                    else
                        --if ui.get(v.fakelagjit) == "reduced" then
                            local yeah = 90 * 59 / 100 / 1 -- jitter value = 59 // 1 = fakelag jitter percent
                            ui.set(ref.aa.yaw_jitter[2], yeah)
                        --end
                        --[[if ui.get(v.fakelagjit) == "normal" then
                            ui.set(ref.aa.yaw_jitter[2], ui.get(v.yaw_jitter_num))
                        end
                        if ui.get(v.fakelagjit) == "off" then
                            ui.set(ref.aa.yaw_jitter[2], 0)
                        end--]]
                        smart_yaw = 0
                        ui.set(ref.aa.body_yaw[1], "off")
                    end
                    ui.set(ref.aa.pitch, "Default")
                    ui.set(ref.aa.yaw_base, "At targets")
                    ui.set(ref.aa.yaw[1], "180")
                    ui.set(ref.aa.yaw[2], (angle == 90 or angle == -90 or angle == 180) and angle or smart_yaw) -- referenced up
                    ui.set(ref.aa.yaw_jitter[1], "center")
                    ui.set(ref.aa.body_yaw[2], 0)
                    ui.set(ref.aa.fake_yaw_limit,client.random_int(0, 1) == 1 and 60 or 32) -- jitter fake // normal limit vs custom limit
                elseif data.state == "Moving" then
                    cock = "MOVING"
                    if ui.get(preventhighdelta) and lp_vel > 1.2 and lp_vel < 150 then 
                        -- lower delta
                        if ui.get(ref.rage.double_tap[2]) or ui.get(ref.rage.hideshots[2]) then
                            ui.set(ref.aa.body_yaw[1], "jitter") --  body yaw
                            ui.set(ref.aa.yaw_jitter[2], 74) -- jitter vaue
                            smart_yaw = 1 -- yaw offset
                        else
                            -- reduce
                                local yeah = 90 * 74 / 100 / 1 -- jitter value = 59 // 1 = fakelag jitter percent
                                ui.set(ref.aa.yaw_jitter[2], yeah)
                            -- normal
                            --ui.set(ref.aa.yaw_jitter[2], 74) -- jitter value)
                            -- off
                            --    ui.set(ref.aa.yaw_jitter[2], 0)
                            smart_yaw = 2 -- fakelag yaw offset
                            ui.set(ref.aa.body_yaw[1], "jitter")
                        end
                        ui.set(ref.aa.pitch, "Default")
                        ui.set(ref.aa.yaw_base, "At targets")
                        ui.set(ref.aa.yaw[1], "180")
                        ui.set(ref.aa.yaw[2], (angle == 90 or angle == -90 or angle == 180) and angle or smart_yaw) -- referenced up
                        ui.set(ref.aa.yaw_jitter[1], "center")
                        ui.set(ref.aa.body_yaw[2], 0)
                        ui.set(ref.aa.fake_yaw_limit,client.random_int(0, 1) == 1 and 60 or 36) -- jitter fake // normal limit vs custom limit
                    else
                        if ui.get(ref.rage.double_tap[2]) or ui.get(ref.rage.hideshots[2]) then
                            ui.set(ref.aa.body_yaw[1], "jitter") --  body yaw
                            ui.set(ref.aa.yaw_jitter[2], 74) -- jitter vaue
                            smart_yaw = 1 -- yaw offset
                        else
                            -- reduce
                                local yeah = 90 * 74 / 100 / 1 -- jitter value = 59 // 1 = fakelag jitter percent
                                ui.set(ref.aa.yaw_jitter[2], yeah)
                            -- normal
                            --ui.set(ref.aa.yaw_jitter[2], 74) -- jitter value)
                            -- off
                            --    ui.set(ref.aa.yaw_jitter[2], 0)
                            smart_yaw = 2 -- fakelag yaw offset
                            ui.set(ref.aa.body_yaw[1], "jitter")
                        end
                        ui.set(ref.aa.pitch, "Default")
                        ui.set(ref.aa.yaw_base, "At targets")
                        ui.set(ref.aa.yaw[1], "180")
                        ui.set(ref.aa.yaw[2], (angle == 90 or angle == -90 or angle == 180) and angle or smart_yaw) -- referenced up
                        ui.set(ref.aa.yaw_jitter[1], "center")
                        ui.set(ref.aa.body_yaw[2], 0)
                        ui.set(ref.aa.fake_yaw_limit,60) -- off
                    end
                elseif data.state == "Slow motion" then
                    cock = "SLOW"
                    if ui.get(ref.rage.double_tap[2]) or ui.get(ref.rage.hideshots[2]) then
                        ui.set(ref.aa.body_yaw[1], "jitter") --  body yaw
                        ui.set(ref.aa.yaw_jitter[2], 84) -- jitter vaue
                        smart_yaw = 12 -- yaw offset
                    else
                        --if ui.get(v.fakelagjit) == "reduced" then
                        --    local yeah = 90 * 59 / 100 / 1 -- jitter value = 59 // 1 = fakelag jitter percent
                        --    ui.set(ref.aa.yaw_jitter[2], yeah)
                        --end
                        --if ui.get(v.fakelagjit) == "normal" then
                        ui.set(ref.aa.yaw_jitter[2], 84) -- jitter value) -- normal
                    --end
                        --if ui.get(v.fakelagjit) == "off" then
                        --    ui.set(ref.aa.yaw_jitter[2], 0)
                        --end
                        smart_yaw = 0 -- fakelag yaw offset
                        ui.set(ref.aa.body_yaw[1], "jitter")
                    end
                    ui.set(ref.aa.pitch, "Default")
                    ui.set(ref.aa.yaw_base, "At targets")
                    ui.set(ref.aa.yaw[1], "180")
                    ui.set(ref.aa.yaw[2], (angle == 90 or angle == -90 or angle == 180) and angle or smart_yaw) -- referenced up
                    ui.set(ref.aa.yaw_jitter[1], "center")
                    ui.set(ref.aa.body_yaw[2], 0)
                    ui.set(ref.aa.fake_yaw_limit,client.random_int(0, 1) == 1 and 60 or 26) -- jitter fake // normal limit vs custom limit
                elseif data.state == "air" then
                    cock = "AIR"
                    if ui.get(ref.rage.double_tap[2]) or ui.get(ref.rage.hideshots[2]) then
                        ui.set(ref.aa.body_yaw[1], "jitter") --  body yaw
                        ui.set(ref.aa.yaw_jitter[2], 74) -- jitter vaue
                        smart_yaw = 5 -- yaw offset
                    else
                        -- reduce
                            local yeah = 90 * 74 / 100 / 1 -- jitter value = 59 // 1 = fakelag jitter percent
                            ui.set(ref.aa.yaw_jitter[2], yeah)
                        -- normal
                        --ui.set(ref.aa.yaw_jitter[2], 74) -- jitter value)
                        -- off
                        --    ui.set(ref.aa.yaw_jitter[2], 0)
                        smart_yaw = 2 -- fakelag yaw offset
                        ui.set(ref.aa.body_yaw[1], "jitter")
                    end
                    ui.set(ref.aa.pitch, "Default")
                    ui.set(ref.aa.yaw_base, "At targets")
                    ui.set(ref.aa.yaw[1], "180")
                    ui.set(ref.aa.yaw[2], (angle == 90 or angle == -90 or angle == 180) and angle or smart_yaw) -- referenced up
                    ui.set(ref.aa.yaw_jitter[1], "center")
                    ui.set(ref.aa.body_yaw[2], 0)
                    ui.set(ref.aa.fake_yaw_limit,client.random_int(0, 1) == 1 and 60 or 36) -- jitter fake // normal limit vs custom limit
                elseif data.state == "air duck" then
                    cock = "AIR-DUCK"
                    if ui.get(ref.rage.double_tap[2]) or ui.get(ref.rage.hideshots[2]) then
                        ui.set(ref.aa.body_yaw[1], "jitter") --  body yaw
                        ui.set(ref.aa.yaw_jitter[2], 75) -- jitter vaue
                        smart_yaw = 1 -- yaw offset
                    else
                        -- reduce
                            local yeah = 90 * 75 / 100 / 1 -- jitter value = 59 // 1 = fakelag jitter percent
                            ui.set(ref.aa.yaw_jitter[2], yeah)
                        -- normal
                        --ui.set(ref.aa.yaw_jitter[2], 74) -- jitter value)
                        -- off
                        --    ui.set(ref.aa.yaw_jitter[2], 0)
                        smart_yaw = 2 -- fakelag yaw offset
                        ui.set(ref.aa.body_yaw[1], "jitter")
                    end
                    ui.set(ref.aa.pitch, "Default")
                    ui.set(ref.aa.yaw_base, "At targets")
                    ui.set(ref.aa.yaw[1], "180")
                    ui.set(ref.aa.yaw[2], (angle == 90 or angle == -90 or angle == 180) and angle or smart_yaw) -- referenced up
                    ui.set(ref.aa.yaw_jitter[1], "center")
                    ui.set(ref.aa.body_yaw[2], 0)
                    --ui.set(ref.aa.fake_yaw_limit,client.random_int(0, 1) == 1 and 60 or 36) -- jitter fake // normal limit vs custom limit
                    ui.set(ref.aa.fake_yaw_limit, 60) --  off
                elseif data.state == "duck" then
                    cock = "DUCK"
                    if ui.get(ref.rage.double_tap[2]) or ui.get(ref.rage.hideshots[2]) then
                        ui.set(ref.aa.body_yaw[1], "jitter") --  body yaw
                        ui.set(ref.aa.yaw_jitter[2], 68) -- jitter vaue
                        smart_yaw = 5 -- yaw offset
                    else
                        -- reduce
                            --local yeah = 90 * 68 / 100 / 1 -- jitter value = 59 // 1 = fakelag jitter percent
                            --ui.set(ref.aa.yaw_jitter[2], yeah)
                        -- normal
                        ui.set(ref.aa.yaw_jitter[2], 68) -- jitter value)
                        -- off
                        --    ui.set(ref.aa.yaw_jitter[2], 0)
                        smart_yaw = 0 -- fakelag yaw offset
                        ui.set(ref.aa.body_yaw[1], "jitter")
                    end
                    ui.set(ref.aa.pitch, "Default")
                    ui.set(ref.aa.yaw_base, "At targets")
                    ui.set(ref.aa.yaw[1], "180")
                    ui.set(ref.aa.yaw[2], (angle == 90 or angle == -90 or angle == 180) and angle or smart_yaw) -- referenced up
                    ui.set(ref.aa.yaw_jitter[1], "center")
                    ui.set(ref.aa.body_yaw[2], 0)
                    ui.set(ref.aa.fake_yaw_limit,client.random_int(0, 1) == 1 and 60 or 46) -- jitter fake // normal limit vs custom limit
                end
            end
        end

    end)

    local function export_button()
        local settings = {}
        for key, value in pairs(var.player_states) do
            settings[tostring(value)] = {}
            for k, v in pairs(aa_init[key]) do
                settings[value][k] = ui.get(v)
            end
        end
        
        clipboard.set(base64.encode(json.stringify(settings)))
        print("config has been exported to your clipboard.")
    end
    
    local export_btn = ui.new_button(tab, container, "export custom antiaim settings", export_button)
    
    local function import_button()
    
        local settings = json.parse(base64.decode(clipboard.get()))
    
        for key, value in pairs(var.player_states) do
            for k, v in pairs(aa_init[key]) do
                local current = settings[value][k]
                if (current ~= nil) then
                    ui.set(v, current)
                end
            end
        end
        print("config has successfully been imported.")
    end
    
    local import_btn = ui.new_button(tab, container, "import custom antiaim settings", import_button)
    local function config_menu()
        local is_enabled = ui.get(enableantiaim)
        if ui.get(aa_init[0].aa_builder) and is_enabled and ui.get(aaselection) == "custom" then
            ui.set_visible(export_btn, true)
            ui.set_visible(import_btn, true)
        else
            ui.set_visible(export_btn, false)
            ui.set_visible(import_btn, false)
        end
    end
    client.set_event_callback("paint_ui", config_menu)

    local default_button = ui.new_button("aa", "anti-aimbot angles", "load default config", function()
        ui.set(enableantiaim, true)
        ui.set(aaselection, "desync meta")
        ui.set(indicators, true)
        ui.set(clantage, true)
        ui.set(animations, {"static legs in air", "zero-pitch on land", "fake duck animation"})
        ui.set(onshotfakelag, true)
        ui.set(doubletapoptions, {"clock correction", "dynamic speed"})
        ui.set(deagleexploit, true)
        ui.set(deagleexploitkey, "Always on")

        ui.set(customslowwalk, true)

        ui.set(legfucker, true)
        ui.set(backstab, true)
        ui.set(hitlogs, true)
        ui.set(hitlogsdropdown, {"console"})
        if obex_data.build == "Debug" or obex_data.build == "Source" then
            ui.set(deagleexploit , true)
            ui.set(deaglexploitkey, "Always on")
        end
        ui.set(autobuy_enable, true)
        ui.set(preventhighdelta, false)
        ui.set(preventfreestanding, {"in-air", "crouch"})
        ui.set(preventjitter, {"on manual", "freestanding"})
        ui.set(autobuy_primary, "ssg08")
        ui.set(autobuy_secondary, "tec-9")
        ui.set(autobuy_utility, {"hegrenade","molotov", "smoke", "armor", "zeus", "defuser"})
    end)

    
    local multi_exec = function(func, tab)
        for k, v in pairs(tab) do
            func(k, v)
        end
    end
    local menuhide = function()
        ui.set_visible(aaselection, ui.get(tabs) == "Anti-aim")
        ui.set_visible(enableantiaim, ui.get(tabs) == "Anti-aim")
        ui.set_visible(manualantiaimenable, ui.get(tabs) == "Anti-aim")
        ui.set_visible(enablebindings, ui.get(tabs) == "Anti-aim")
        ui.set_visible(antiaimmanualleft, ui.get(tabs) == "Anti-aim" and ui.get(manualantiaimenable))
        ui.set_visible(antiaimmanualright, ui.get(tabs) == "Anti-aim" and ui.get(manualantiaimenable))
        ui.set_visible(antiaimmanualforward, ui.get(tabs) == "Anti-aim" and ui.get(manualantiaimenable))
        ui.set_visible(antiaimmanualback, ui.get(tabs) == "Anti-aim" and ui.get(manualantiaimenable))
        ui.set_visible(freestanding, ui.get(tabs) == "Anti-aim" and ui.get(enablebindings))
        ui.set_visible(legitkey, ui.get(tabs) == "Anti-aim" and ui.get(enablebindings))
        ui.set_visible(idealtickkey, ui.get(tabs) == "Anti-aim" and ui.get(enablebindings))
        ui.set_visible(preventhighdelta, ui.get(tabs) == "Anti-aim")
        ui.set_visible(preventfreestanding, ui.get(tabs) == "Anti-aim")
        ui.set_visible(preventjitter, ui.get(tabs) == "Anti-aim")
        ui.set_visible(customslowwalk, ui.get(tabs) == "Anti-aim")
        ui.set_visible(customslowwalkminimum, ui.get(tabs) == "Anti-aim" and ui.get(customslowwalk))
        ui.set_visible(customslowwalkmaximum, ui.get(tabs) == "Anti-aim" and ui.get(customslowwalk))

        ui.set_visible(export_btn, ui.get(tabs) == "Config" and ui.get(aaselection) == "Custom")
        ui.set_visible(import_btn, ui.get(tabs) == "Config" and ui.get(aaselection) == "Custom")
        ui.set_visible(default_button, ui.get(tabs) == "Config")
        ui.set_visible(backstab, ui.get(tabs) == "Miscellaneous")
        ui.set_visible(backstabdist, ui.get(tabs) == "Miscellaneous" and ui.get(backstab))
        ui.set_visible(autobuy_enable, ui.get(tabs) == "Miscellaneous")
        ui.set_visible(autobuy_primary, ui.get(tabs) == "Miscellaneous" and ui.get(autobuy_enable))
        ui.set_visible(autobuy_secondary, ui.get(tabs) == "Miscellaneous"and ui.get(autobuy_enable))
        ui.set_visible(autobuy_utility, ui.get(tabs) == "Miscellaneous"and ui.get(autobuy_enable))
        ui.set_visible(animations, ui.get(tabs) == "Miscellaneous")
        ui.set_visible(legfucker, ui.get(tabs) == "Miscellaneous")
        ui.set_visible(hitlogs, ui.get(tabs) == "Miscellaneous")
        ui.set_visible(hitlogsdropdown, ui.get(tabs) == "Miscellaneous" and ui.get(hitlogs))
        ui.set_visible(doubletapoptions, ui.get(tabs) == "Enhancements")
        if obex_data.build == "Debug" or obex_data.build == "Source" or obex_data.build == "debug" or obex_data.build == "source"then
            --print("debug ", obex_data.build)
            ui.set_visible(deagleexploit, ui.get(tabs) == "Enhancements")
            ui.set_visible(deagleexploitkey, ui.get(tabs) == "Enhancements")
            ui.set_visible(menu.main_switch, ui.get(tabs) == "Enhancements")
            ui.set_visible(menu.key, ui.get(tabs) == "Enhancements" and ui.get(menu.main_switch))
            ui.set_visible(menu.radius, ui.get(tabs) == "Enhancements" and ui.get(menu.main_switch))
        else
            --print("not debug ", obex_data.build)
            ui.set_visible(deagleexploit, false)
            ui.set_visible(deagleexploitkey, false)
            ui.set_visible(menu.main_switch, false)
            ui.set_visible(menu.key, false)
            ui.set_visible(menu.radius, false)
        end
        ui.set_visible(onshotfakelag, ui.get(tabs) == "Enhancements")
        ui.set_visible(killsaye, ui.get(tabs) == "Miscellaneous")
        ui.set_visible(clantage, ui.get(tabs) == "Miscellaneous")

        ui.set_visible(indicators, ui.get(tabs) == "Visuals")
        ui.set_visible(indicatorselection, ui.get(tabs) == "Visuals")
        ui.set_visible(indicatorcustom, ui.get(tabs) == "Visuals" and ui.get(indicatorselection) == "Modern")
        ui.set_visible(tsarrows, ui.get(tabs) == "Visuals")
        ui.set_visible(watermark, ui.get(tabs) == "Visuals")

        ui.set_visible(indicolor_label, ui.get(tabs) == "Colour")
        ui.set_visible(indicolor, ui.get(tabs) == "Colour")
        ui.set_visible(bindscolor_label, ui.get(tabs) == "Colour")
        ui.set_visible(bindscolor, ui.get(tabs) == "Colour")
        ui.set_visible(arrowcolor_label, ui.get(tabs) == "Colour")
        ui.set_visible(arrowcolor, ui.get(tabs) == "Colour")
        ui.set_visible(watermarkclrlabel, ui.get(tabs) == "Colour")
        ui.set_visible(watermarkclr, ui.get(tabs) == "Colour")
        ui.set_visible(watermarkclr2label, ui.get(tabs) == "Colour")
        ui.set_visible(watermarkclr2, ui.get(tabs) == "Colour")


    -- if ui.get(aaselection) == "custom" then
        
            multi_exec(ui.set_visible, {
                [ref.aa.enabled] = false,
                [ref.aa.pitch] = false,
                [ref.aa.yaw_base] = false,
                [ref.aa.yaw[1]] = false,
                [ref.aa.yaw[2]] = false,
                [ref.aa.yaw_jitter[1]] = false,
                [ref.aa.yaw_jitter[2]] = false,
                [ref.aa.body_yaw[1]] = false,
                [ref.aa.body_yaw[2]] = false,
                [ref.aa.freestanding_body_yaw] = false,
                [ref.aa.fake_yaw_limit] = false,
                [ref.aa.freestanding[1]] = false,
                [ref.aa.freestanding[2]] = false,
                [ref.aa.edge_yaw] = false,
                [ref.aa.roll] = false
            })
    -- end 
    end
    client.set_event_callback("paint_ui", menuhide)

    local function set_lua_menu()
        var.active_i = var.s_to_int[ui.get(aa_init[0].player_state)]
        local is_aa = ui.get(tabs) == "Anti-aim"
        local is_vis = ui.get(tabs) == "Visual"
        local is_misc = ui.get(tabs) == "Miscellaneous"
        local is_colur = ui.get(tabs) == "Colour"
        local is_enabled = ui.get(enableantiaim)
    
        if is_aa and is_enabled and ui.get(aaselection) == "Custom" then
            ui.set_visible(aa_init[0].aa_builder, true)
            ui.set_visible(aa_init[0].player_state, true)
        else
    
            ui.set_visible(aa_init[0].aa_builder, false)
            ui.set_visible(aa_init[0].player_state, false)
        end
        if ui.get(aa_init[0].aa_builder) and is_enabled and is_aa and ui.get(aaselection) == "Custom" then
            for i=1, 7 do
                ui.set_visible(aa_init[i].enable_state,var.active_i == i and is_aa)
                ui.set_visible(aa_init[0].player_state,is_aa)
                if ui.get(aa_init[i].enable_state) then
                    ui.set_visible(aa_init[i].yawoffset,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].flyawoffset,var.active_i == i and is_aa)

                    ui.set_visible(aa_init[i].body_yaw,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].body_yaw_num,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].flbody_yaw,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].jittertype,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].yaw_jitter_num,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].fakelagjit,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].jitterreduced,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].fake_limit,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].customfakeyaw,var.active_i == i and is_aa)
                    ui.set_visible(aa_init[i].customfake_limit,var.active_i == i and is_aa)

                else
                    ui.set_visible(aa_init[i].yawoffset,false)
                    ui.set_visible(aa_init[i].flyawoffset,false)

                    ui.set_visible(aa_init[i].body_yaw,false)
                    ui.set_visible(aa_init[i].body_yaw_num,false)
                    ui.set_visible(aa_init[i].flbody_yaw,false)
                    ui.set_visible(aa_init[i].jittertype,false)
                    ui.set_visible(aa_init[i].yaw_jitter_num,false)
                    ui.set_visible(aa_init[i].fakelagjit,false)
                    ui.set_visible(aa_init[i].jitterreduced,false)
                    ui.set_visible(aa_init[i].fake_limit,false)
                    ui.set_visible(aa_init[i].customfakeyaw,false)
                    ui.set_visible(aa_init[i].customfake_limit,false)
                end
            end
        else
            for i=1, 7 do
                ui.set_visible(aa_init[i].enable_state,false)
                ui.set_visible(aa_init[0].player_state,false)
                ui.set_visible(aa_init[i].yawoffset,false)
                ui.set_visible(aa_init[i].flyawoffset,false)

                ui.set_visible(aa_init[i].body_yaw,false)
                ui.set_visible(aa_init[i].body_yaw_num,false)
                ui.set_visible(aa_init[i].flbody_yaw,false)
                ui.set_visible(aa_init[i].jittertype,false)
                ui.set_visible(aa_init[i].yaw_jitter_num,false)
                ui.set_visible(aa_init[i].fakelagjit,false)
                ui.set_visible(aa_init[i].jitterreduced,false)
                ui.set_visible(aa_init[i].fake_limit,false)
                ui.set_visible(aa_init[i].customfakeyaw,false)
                ui.set_visible(aa_init[i].customfake_limit,false)
            end
        end
    end
    client.set_event_callback("paint_ui", set_lua_menu)

    local end_time = 0
    local ground_ticks = 0

    misc = {}
    misc.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end

    misc.anti_knife = function()
        if ui.get(backstab) then
            local players = entity.get_players(true)
            local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
            local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
            local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
            for i=1, #players do
                local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
                local distance = misc.anti_knife_dist(lx, ly, lz, x, y, z)
                local weapon = entity.get_player_weapon(players[i])
                if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(backstabdist) then
                    ui.set(yaw_slider,180)
                    ui.set(pitch,"Off")
                end
            end
        end
    end


    local translated_for_command = { 
        ["awp"] = "buy awp",
        ["scar20"] = "buy scar20",
        ["ssg08"] = "buy ssg08",
        ["tec-9"] = "buy tec9",
        ["p250"] = "buy p250",
        ["revolver"] = "buy deagle",
        ["dual"] = "buy elite",
        ["hegrenade"] = "buy hegrenade",
        ["molotov"] = "buy molotov",
        ["smoke"] = "buy smokegrenade",
        ["armor"] = "buy vesthelm",
        ["zeus"] = "buy taser 34",
        ["defuser"] = "buy defuser"
    }

    local function on_round_prestart(e) -- Autobuy shizznizzle
        if not ui.get(autobuy_enable) then 
        return 
        end
        local money = entity.get_prop(local_player, "m_iAccount") 
            for k, v in pairs(translated_for_command) do -- Primary and Secondary Autobuy
                if k == ui.get(autobuy_primary) then
                    client.exec(v) -- prim weapons
                end
                if k == ui.get(autobuy_secondary) then 
                    client.exec(v)
                end
            end
        
            local grenade_value = ui.get(autobuy_utility) 
        
            for gindex = 1, table.getn(grenade_value) do
        
                local value_at_index = grenade_value[gindex]
        
                for k, v in pairs(translated_for_command) do -- Autobuy utility
        
                    if k == value_at_index then
                        client.exec(v)
                    end
                end
            end
    end

    local mody = 0
    local amount = 0
    local x_mod = 0 
    picurl = "https://cdn.discordapp.com/attachments/1023728138544484442/1026255860244152411/newimage.png"

    local image 
    http.get(picurl, function(s, r)
        if s and r.status == 200 then
            image = images.load(r.body)
        else
            error("Failed to load: " .. r.status_message)
        end
    end)
    client.set_event_callback("paint", function()
        local w, h = client.screen_size()
        local me = entity.get_local_player()

        if ui.get(watermark) then
            if ui.is_menu_open() then
                local cx, cy = ui.mouse_position()
                if iu2.dragging and not client.key_state(0x01) then
                    iu2.dragging = false
                end
                
                if iu2.dragging and client.key_state(0x01) then
                    iu2.x = cx - iu2.drag_x
                    iu2.y = cy - iu2.drag_y
                end
            
                if intersect2(iu2.x, iu2.y, iu2.w, iu2.h+50) and client.key_state(0x01) then 
                    iu2.dragging = true
                    iu2.drag_x = cx - iu2.x
                    iu2.drag_y = cy - iu2.y
                end
            end
            local hours, minutes, seconds = client.system_time()
            local secondsnew = {}
            local minutesnew = {}
            if seconds < 10 then
                secondsnew = string.format("0%s",seconds)
            else
                secondsnew = seconds
            end
            if minutes < 10 then
                minutesnew = string.format("0%s",minutes)
            else
                minutesnew = minutes
            end
            --local text = string.format("malibu   •   %s   •   %s ms   • %s:%s:%s",username, ping, hours, minutes, secondsnew)
            local screen_width, screen_height = client.screen_size()
            local latency = math.floor(client.latency()*1000+0.5)
            local tickrate = 1/globals.tickinterval()
            
            -- create text
            local text = string.format(colours.lightblue.."nexus [%s]  "..colours.white.."•   %s   •   %d ms", string.lower(obex_data.build),string.lower(obex_data.username),latency) .. colours.white.."  •  " .. string.format("%02d:%02d:%02d", hours, minutes, seconds)
        
            -- modify these to change how the text appears. margin is the distance from the top right corner, padding is the size the background rectangle is larger than the text
            local margin, padding, flags = 18, 4, nil
        
            -- uncomment this for a "small and capital" style
            -- flags, text = "-", (text:upper():gsub(" ", "   "))
        
            -- measure text size to properly offset the text from the top right corner
            local text_width, text_height = renderer.measure_text(flags, text)
        
            local r3, g3, b3, a3 = ui.get(watermarkclr)
            local r4, g4, b4, a4 = ui.get(watermarkclr2)

            -- draw background and text
            if ui.get(watermark) == "None" then
                return
            elseif ui.get(watermark) == "Standard" then
                renderer.gradient(screen_width-text_width-margin-padding, margin-padding, text_width+padding*2, text_height-18+padding*2,r3,g3,b3,a3, r4,g4,b4,a4, 10) -- top
                renderer.gradient(screen_width-text_width-margin-padding, margin-padding, text_width+padding*2, text_height+padding*2, 255,255,255,45, 255,255,255,45, 10) -- main background
                renderer.text(screen_width-text_width-margin, margin, 235, 235, 235, 255, flags, 0, text)
            elseif ui.get(watermark) == "Modern" then
                --print(ui.get(dpi_ref))
                local player = entity.get_local_player()
                local steamid64 = panorama.open().MyPersonaAPI.GetXuid()
                local avatar = images.get_steam_avatar(steamid64)
                if ui.get(dpi_ref) == "125%" then
                    --avatar:draw(iu2.x - 55, iu2.y - 20, 38, force_same_res)
                    avatar:draw(iu2.x - 55, iu2.y - 20, 40, 40, nil, nil, nil, 255,true)
                    renderer.text(iu2.x + 53, iu2.y + 5, 255,255,255,255, "cd", 0, string.format(colours.lightblue.."nexus.lua\n".. colours.white.."user: "..colours.lightblue.."%s"..colours.white.." ["..colours.lightblue.."%s"..colours.white.."]", string.lower(obex_data.username), string.lower(obex_data.build)))
                else
                   -- avatar:draw(iu2.x - 55, iu2.y - 20, 38, force_same_res)
                    avatar:draw(iu2.x - 55, iu2.y - 20, 40, 40, nil, nil, nil, 255,true)
                    renderer.text(iu2.x + 37, iu2.y + 5, 255,255,255,255, "cd", 0, string.format(colours.lightblue.."nexus.lua\n".. colours.white.."user: "..colours.lightblue.."%s"..colours.white.." ["..colours.lightblue.."%s"..colours.white.."]", string.lower(obex_data.username), string.lower(obex_data.build)))
                end
            end
        end

        if not entity.is_alive(me) then
            return
        end

        --@heartbeat --  obex check do not remove.
        if ui.get(onshotfakelag) then
            if ui.get(ref.rage.hideshots[2]) then
                if ui.get(ref.aa.fakeduck) then
                    ui.set(ref.aa.fake_lag_limit, 14)
                    ui.set(ref.aa.fakelag[2], "Always on")
                else
                    ui.set(ref.aa.fake_lag_limit, math.random(1,3))
                    ui.set(ref.aa.fakelag[2], "On hotkey")
                end
            else
                ui.set(ref.aa.fake_lag_limit, 14)
                ui.set(ref.aa.fakelag[2], "Always on")
                --return
            end
        end

        if ui.get(enablebindings) then
            if ui.get(idealtickkey) then
                ui.set(ref.rage.double_tap[2], "Always on")
                local perc = math.floor(c_cmd / 14 * 100 / 2)

                if perc == 0 or perc == 3 then
                    amount = 100
                else
                    amount = perc
                end
                renderer.text(w/2, h/2 - 40, 255, 255, 255, 255, "cd-", 0, "IDEAL TICK - "..amount.. "%")
            else
                ui.set(ref.rage.double_tap[2], "Toggle")
            end
        end

        local r,g,b,a = ui.get(indicolor)
        local r2,g2,b2,a2 = ui.get(indicolor)
        local indicolor = { ui.get(arrowcolor) }
        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local body_pos = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)
        
        local body_yaw = math.max(-60, math.min(60, round((entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) or 0)*120-60+0.5, 1)))
        local p_yaw = body_yaw / 60 * 100
        if body_yaw < 0 then p_yaw = -p_yaw end
        local side = bodyyaw > 0 and 1 or -1
        body_yaw = (body_yaw < 1 and body_yaw > 0.0001) and math.floor(body_yaw, 1) or body_yaw
        local abs_yaw = math.abs(body_yaw)
        local wpn = entity.get_player_weapon(entity.get_local_player())
        local wpn_id = entity.get_prop(wpn, 'm_iItemDefinitionIndex')
       -- if ui.get(scopemove) then
            local me = entity.get_local_player()
            local scoped = entity.get_prop(me, "m_bIsScoped")
            local frames = 8 * globals.frametime() -- modify to change scoped animation speed
            if scoped == 1 then x_mod = x_mod + frames; if x_mod > 0.99 then x_mod = 1 end else x_mod = x_mod - frames; if x_mod < 0 then x_mod = 0 end end 
            local add_x = (30) * x_mod -- change the number in (30*1) for spacing 
       -- else

        --end
        --renderer.text(w / 2 - 1, h / 2 + 80, r, g, b, a, "c-", nil, cock) 
        if ui.get(indicators) then
            if ui.get(ref.rage.double_tap[2]) or ui.get(ref.rage.hideshots[2]) then
                mody = mody + globals.frametime() * 10; 
                if mody > 0.99 then 
                    mody = 1 
                end 
            else 
                mody = mody - globals.frametime() * 10 
                if mody < 0 then 
                    mody = 0 
                end 
            end 
            local dty = (11) * mody 
            local dta = (a) * mody 
            local charge = antiaim.get_double_tap()
            
            --renderer.text(w / 2 - 1, h / 2 + 18, r2, g2, b2, a2, "c-", nil, build:upper()) 
            --renderer.text(w / 2 - 1, h / 2 + 10, r, g, b, a, "c-", nil, faggot) 
            if ui.get(indicatorselection) == "Standard" then
                renderer.text(w / 2 - 1 +add_x, h / 2 + 26, r, g, b, a, "c-", nil, "NEXUS") 
                renderer.gradient(w/2 + 0+add_x, h/2 + 33, -abs_yaw/3, 2, r2,g2,b2,a2, r2,g2,b2,a2, true)    
                renderer.gradient(w/2 + 0+add_x , h/2 + 33, abs_yaw/3, 2, r2,g2,b2,a2, r2,g2,b2,a2, true)
                renderer.rectangle(w/2+add_x, h/2 + 33, -22, 2, 0,0,0,90)
                renderer.rectangle(w/2+add_x, h/2 + 33, 22, 2, 0,0,0,90)

                if ui.get(ref.rage.double_tap[2]) then
                    renderer.text(w / 2 - 2+add_x, h / 2 + 30 + dty, r, g, b, dta, "c-", nil, "DT") 
                elseif ui.get(ref.rage.hideshots[2]) then
                    renderer.text(w / 2 - 2+add_x, h / 2 + 30 + dty, r, g, b, dta, "c-", nil, "HS") 
                end

                if ui.get(ref.rage.double_tap[2]) or ui.get(ref.rage.hideshots[2]) then
                    if ui.get(ref.aa.fforcebaim) then
                        renderer.text(w / 2+add_x, h / 2 + 41 + dty, r2,g2,b2,a2, "-c", 0, "BAIM")
                    else
                        renderer.text(w / 2+add_x, h / 2 + 41 + dty, 255,255,255,90, "-c", 0, "BAIM")
                    end
                    if ui.get(ref.aa.fsafepoint) then
                        renderer.text(w / 2- 17+add_x, h / 2 + 41 + dty, 255,255,255,255, "-c", 0, "SP")
                    else
                        renderer.text(w / 2-17+add_x, h / 2 + 41 + dty, 255,255,255,90, "-c", 0, "SP")
                    end
                    if ui.get(ref.aa.freestand[2]) then
                        renderer.text(w / 2+17+add_x, h / 2 + 41 + dty, 255,255,255,255, "-c", 0, "FS")
                    else
                        renderer.text(w / 2+17+add_x, h / 2 + 41 + dty, 255,255,255,90, "-c", 0, "FS")
                    end
                else
                    if ui.get(ref.aa.fforcebaim) then
                        renderer.text(w / 2+add_x, h / 2 + 41 + dty, r2,g2,b2,a2, "-c", 0, "BAIM")
                    else
                        renderer.text(w / 2+add_x, h / 2 + 41 + dty, 255,255,255,90, "-c", 0, "BAIM")
                    end
                    if ui.get(ref.aa.fsafepoint) then
                        renderer.text(w / 2- 17+add_x, h / 2 + 41 + dty, 255,255,255,255, "-c", 0, "SP")
                    else
                        renderer.text(w / 2-17+add_x, h / 2 + 41 + dty, 255,255,255,90, "-c", 0, "SP")
                    end
                    if ui.get(ref.aa.freestand[2]) then
                        renderer.text(w / 2+17+add_x, h / 2 + 41 + dty, 255,255,255,255, "-c", 0, "FS")
                    else
                        renderer.text(w / 2+17+add_x, h / 2 + 41 + dty, 255,255,255,90, "-c", 0, "FS")
                    end
                end
            end
            if ui.get(indicatorselection) == "Kenzo" then
                if obex_data.build == "Source" or "source" then
                    newbuild = "DEBUG"
                else
                    newbuild = obex_data.build
                end
                renderer.text(w / 2  +add_x, h / 2 + 26, r, g, b, a, "c-", nil, "NEXUS  ",colours.darkerblue..string.upper(newbuild))
                renderer.text(w / 2 +add_x, h / 2 + 34, r, g, b, a, "c-", nil, cock)
                if ui.get(ref.rage.double_tap[2]) then
                    renderer.text(w / 2+add_x, h / 2 + 31 + dty, r, g, b, dta, "c-", nil, "DT") 
                elseif ui.get(ref.rage.hideshots[2]) then
                    renderer.text(w / 2+add_x, h / 2 + 31 + dty, r, g, b, dta, "c-", nil, "OS") 
                end

                if ui.get(ref.rage.double_tap[2]) or ui.get(ref.rage.hideshots[2]) then
                    if ui.get(ref.aa.fforcebaim) then
                        renderer.text(w / 2-19+add_x, h / 2 + 40 + dty, r2,g2,b2,a2, "-c", 0, "BAIM")
                    else
                        renderer.text(w / 2-19+add_x, h / 2 + 40 + dty, 255,255,255,90, "-c", 0, "BAIM")
                    end
                    if ui.get(ref.aa.fsafepoint) then
                        renderer.text(w / 2 +2+add_x, h / 2 + 40 + dty, 255,255,255,255, "-c", 0, "SAFE")
                    else
                        renderer.text(w / 2+2+add_x, h / 2 + 40 + dty, 255,255,255,90, "-c", 0, "SAFE")
                    end
                    if ui.get(ref.aa.freestand[2]) then
                        renderer.text(w / 2+19+add_x, h / 2 + 40 + dty, 255,255,255,255, "-c", 0, "FS")
                    else
                        renderer.text(w / 2+19+add_x, h / 2 + 40 + dty, 255,255,255,90, "-c", 0, "FS")
                    end
                else
                    if ui.get(ref.aa.fforcebaim) then
                        renderer.text(w / 2-19+add_x, h / 2 + 43 + dty, r2,g2,b2,a2, "-c", 0, "BAIM")
                    else
                        renderer.text(w / 2-19+add_x, h / 2 + 43 + dty, 255,255,255,90, "-c", 0, "BAIM")
                    end
                    if ui.get(ref.aa.fsafepoint) then
                        renderer.text(w / 2 +2+add_x, h / 2 + 43 + dty, 255,255,255,255, "-c", 0, "SAFE")
                    else
                        renderer.text(w / 2+2+add_x, h / 2 + 43 + dty, 255,255,255,90, "-c", 0, "SAFE")
                    end
                    if ui.get(ref.aa.freestand[2]) then
                        renderer.text(w / 2+19+add_x, h / 2 + 43 + dty, 255,255,255,255, "-c", 0, "FS")
                    else
                        renderer.text(w / 2+19+add_x, h / 2 + 43 + dty, 255,255,255,90, "-c", 0, "FS")
                    end
                end
            end
            --if ui.get(indicatorselection) == "Logo" then
            --    if image ~= nil then
            --        image:draw(w / 2 +add_x, h / 2 + 18, 60, 60, 255,255,255,255, true)
            --    end
            --end
            if ui.get(indicatorselection) == "Simple" then
                if obex_data.build == "Source" or "source" then
                    newbuild = "DEBUG"
                else
                    newbuild = obex_data.build
                end
                renderer.text(w / 2 - 1+add_x, h / 2 + 36, r, g, b, a, "cb", nil, "N E X U S")
                renderer.text(w / 2 - 1+add_x, h / 2 + 46, r, g, b, a, "c-", nil, "[",string.upper(newbuild),"]")
            end
            if ui.get(indicatorselection) == "Modern" then
                renderer.text(w / 2 - 1+add_x, h / 2 + 26, r, g, b, a, "c-", nil, "NEXUS") 
                renderer.gradient(w/2 + 0+add_x, h/2 + 33, -body_yaw/3, 2, r2,g2,b2,a2, r2,g2,b2,a2, true)    
                renderer.gradient(w/2 + 0 +add_x, h/2 + 33, body_yaw/3, 2, r2,g2,b2,a2, r2,g2,b2,a2, true)
                renderer.rectangle(w/2+add_x, h/2 + 33, -22, 2, 0,0,0,90)
                renderer.rectangle(w/2+add_x, h/2 + 33, 22, 2, 0,0,0,90)
                local newr, newg, newb, newa = ui.get(bindscolor)
                for x in ipairs(indicator_list) do
                    local v = x+1
                    list_indicator = list_indicator + half_spacer + half_spacer + half_spacer

                    --if list_indicator < 250 then
                        if ui.get(ref.rage.double_tap[2]) then
                            renderer.text(w / 2+add_x, final_h5+8*v, newr, newg, newb, newa, "-cd", 0, indicator_list[x])
                        else
                            renderer.text(w / 2+add_x, final_h6+8*v, newr, newg, newb, newa, "-cd", 0, indicator_list[x])
                        end
                    --end
                end
                indicator_list = {}
                if contains(ui.get(indicatorcustom), "Doubletap") then
                    if ui.get(ref.rage.double_tap[2]) then
                        table.insert(indicator_list, "DT")
                    end
                end
                if contains(ui.get(indicatorcustom), "Hideshots") then
                    if ui.get(ref.rage.hideshots[2]) then
                        table.insert(indicator_list, "HS")
                    end
                end
                if contains(ui.get(indicatorcustom), "Force safe point") then
                    if ui.get(ref.aa.fakeduck) then
                        table.insert(indicator_list, "FAKE")
                    end
                end
                if contains(ui.get(indicatorcustom), "Force body aim") then
                    
                    if ui.get(ref.aa.fforcebaim) then
                        table.insert(indicator_list, "FB")
                    end
                end
                if contains(ui.get(indicatorcustom), "Quick peek") then
                    if ui.get(ref.aa.quickpeek[2]) then
                        table.insert(indicator_list, "QP")
                    end
                end
                if contains(ui.get(indicatorcustom), "Freestanding") then
                    if ui.get(ref.aa.freestand[2]) then
                        table.insert(indicator_list, "FS")
                    end
                end
            end


            if was_on_ground == false and wpn_id == WEAP_DEAGLE then
                if obex_data.build == "Debug" or obex_data.build == "Source" then
                    if ui.get(deagleexploit) and ui.get(deagleexploitkey) then
                        --renderer.text(w / 2 - 950, h / 2, 255,255,255,255, "d", 0, "accurate nospread")
                        renderer.text(w / 2, h / 2 - 225, 255,255,255,255, "cd", 0, "*   accurate nospread   *")
                    end
                end
            end
                
        end
        if ui.get(tsarrows) then
            local left = angle == -90
            local right = angle == 90
            if entity.is_alive(entity.get_local_player()) then
                renderer.triangle(w / 2 - 55, h / 2 + 2, w / 2 - 42,  h / 2 - 7, w / 2 - 42, h / 2 + 11, left and indicolor[1] or 35, left and indicolor[2] or 35, left and indicolor[3] or 35, left and indicolor[4] or 150)
                renderer.triangle(w / 2 + 55, h / 2 + 2, w / 2 + 42,  h / 2 - 7, w / 2 + 42, h / 2 + 11, right and indicolor[1] or 35, right and indicolor[2] or 35, right and indicolor[3] or 35, right and indicolor[4] or 150)
                
                renderer.rectangle(w / 2 - 40, h / 2 -7, 2, 18, side < 0 and 35 or indicolor[1], side < 0 and 35 or indicolor[2], side < 0 and 35 or indicolor[3], side < 0 and 150 or indicolor[4])
                renderer.rectangle(w / 2 + 38, h / 2 -7, 2, 18, side < 0 and indicolor[1] or 35, side < 0 and indicolor[2] or 35, side < 0 and indicolor[3] or 35, side < 0 and indicolor[4] or 150)
            else
                return
            end
        end
    end)


    ui.set(ref.aa.log_spread, false)
    local hitgroup_names = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
    local chance, bt
    local function hitlog(e)
        local enemies = entity.get_players(true)
        local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
        local name = string.lower(entity.get_player_name(e.target))
        local health = entity.get_prop(e.target, 'm_iHealth')
        local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60 )

        if ui.get(hitlogs) then
            if contains(ui.get(hitlogsdropdown), "Console") then
                client.color_log(181, 209, 255, string.format("Registered shot at %s in %s for %s damage", entity.get_player_name(e.target), hgroup, e.damage))
            elseif contains(ui.get(hitlogsdropdown), "Screen") then
                paris_insert_log("Registered shot at "..string.lower(entity.get_player_name(e.target).." in "..hgroup.." for ".. e.damage.. " damage"),6)
            end
        end
    end

    local function misslog(e)

        local hitgroups = hitgroup_names[e.hitgroup + 1] or "?"
        local local_health = entity.get_prop(entity.get_local_player(), "m_iHealth")
        local enemy_health = entity.get_prop(e.target, "m_iHealth")
        local reasoning2 = {}
        local reasoning = {}
        if not entity.is_alive(e.target) then
            return end
        if entity.is_alive(entity.get_local_player()) then
            if enemy_health < 0 then
                enemy_health = "dead"
            else
                enemy_health = enemy_health
            end

            if e.reason == "prediction error" then
                reasoning = "prediction miscalculation"
            elseif e.reason == "death" then
                if enemy_health == 0 then
                    reasoning = "entity died before event was handled"
                else
                    reasoning = "local player died before event was handled"
                                    
                end
            elseif e.reason == "unregistered shot" then
                reasoning = "clientsided shot"
                                
            elseif e.reason == "spread" then
                if get_velocity(entity.get_local_player()) < 78 then
                    reasoning = "spread(hc)"
                else
                    reasoning = "spread(move)"
                end
            elseif e.reason == "?" then
                reasoning = "resolver"
            end
            --paris_insert_log("Missed '"..entity.get_player_name(e.target).."' in '"..hitgroups.."' >< reason: '"..reasoning.."'",3)
            if ui.get(hitlogs) then
                if contains(ui.get(hitlogsdropdown), "Console") then
                    client.color_log(255, 100, 100, string.format("Missed '%s' in '%s' >< reason: '%s'", entity.get_player_name(e.target), hitgroups, reasoning))
                elseif contains(ui.get(hitlogsdropdown), "Screen") then
                    paris_insert_log("Missed '"..entity.get_player_name(e.target).."' in '"..hitgroups.."' >< reason: '"..reasoning.."'",6)
                end
            end
        end
    end


    local hstable = {"1"}
    local kiffernigger={'hehehh hab gut spass für una allle mit und dampf ma jutt ein','BIn strassenschlaeger wie zau sas','Hab strassen Abitur iss beste','Iss der trizep grosser als der bizep? Oda ander herum?','Schwoere hast denn Nagel laufen Kopf getroffen','Kippen uhhh musste das da rein klopppen passt schon','Japp cl doena bestw','Passart beste','Wie gehts diir soo haute','Erst ma ne Schoenheita Maske goen hehwh','Sonnst wers ja auch nur ein timmmi','Ne. Beides geld aba der trizeps iss etwas dicker','Lol uch frag sie erst garnicht wer weis wo sie über all schoen wahr uhhhh will ich garnet wisssennnn jetz hab ich schonn son kopfkino vin der sas wie sie dat macht wtf','Geld is schner alles persische schonheiten heheh','Ahhaha jahhhhahahhaha','Geht dat','Kann ich laute finden über skype also deren ip diggi','Kannst du das al Anwendung machen die mann neben wahts app offen iss','Spamen buddda','Topp bester man liwbe gruesse on patte','Lad ma die olllen wixxxa ein Xd','Hahahhaha und ich brauche grass','Gleich dabei mein pc zusammen zu Klopppen','Morgen frueh direkt vielleicht schon','Like a steffi cree','Jor kenn nur die ein paar leute jor hahah','Im Moment chillenn budda ubd geld sammel heheh','Bein bro macht dop','Datt sind mitlaufer haahha','ik stech euch alle ab','Jooo kolowebz alllet','Und ich juttt nit patte unterwegs','hahhah top ahhah','heheheh issso fussball beste','Gohan beste weiste wieso weil er zell geboxst hat lachhh','Pate beste buddda hab siew alllw buddda','Wien Ferrari bin ich buddda','Budda hallo mgf','Klaarr conniii jutt weiber am start','Buddda die sehen auch wie geld Muenzen heheh','B udddda hahah coonnni bestw','Bau arbeiter zzzzhahahah','Breiter als drine mo yo','Soo muss dat whwhhw','Alllles jutttte euch für den kommen den tag yaa','Deine mama zei jahre bei mir in kella','Kannste zigarrre mit puls bekkommen iss dixkkea teil da haste wat zum Dampfen','Kannst auch Zigarren von mir bekommen hand gemacht mad in tostedt und so kannst auch preis bestimmen 20-30-40 euro wurde ann dickkkes ding','Du glaubst net wie mud ich bin glaub immer noch voll drauf','Die typen Mit denn roten jacken sind geferlich munkelt man cree','Bin aba net lol kommma net ma uff soo ne dummme lach','Schreib halt meher geh eh penn oda hahahaha','Auf so ne dumme sach mit. Nen Tecker ralfen berg ruter haun','Isso vorhin richtig. Dickken kloppen drauf gepackt und ich fand das sich die faben veraendert haette lachhhh','klar bin boss untet denn bossawn lagfgel','koka beste habe aus peruanische flex 87% rein','Emm iss ja bet sooo die dickkke auabeute macgt mein sis ja meher lachh','hehehh hab gut spass fuer una allle mit und dampf ma jutt ein','Begleitung muss budda D rauch zwei mit hab nix meher alllet leer :p','Dickkkke is musste maehl drauf machen um wat zu finden lol bei dir','Das doch Schoenes das leben ist ziemlich entstand muss ivh mal soo sagen','Real zieh dich ine mo flax auf mein kawensman','Half. Mir mal was sol ich da eingabenx um aufen ts zu kommwb','Hab dickken kloppen thc harz oda oel. Was das auch iss. Direkt azs Holland D','Du ueberannormalekante wie zau in denn besten zeiten heheh','Nur koka emma und weeed meher net','XD ABA GUT GEMACHT ISSSIE','XD dachte da were allles tote Sehlen um ihn herum rum','Musss mir gleich. Mql die numma von der tuhse geben die das mit trikkky macht dann bommse ich sie richtig. Laff','budda komm ts fier ist auch da nikkko ist auch da alle sind sie da','haare schon brun oda imma noch totrot','digggen neun ps4 kontroler hab ich hwhwh','ich habe auch allle whwhh','massa hack v3 isssea','Machhhe ichh heheh dicksten stein bekommste','Du. Kannnst doch nicht. Einfach so gehen allle am weinen sind sie','Wer geht wtf lafffel lol niemand geht','Schmeckt komisch man denkt als wuerde man fesseln ein artmen und das ids eklig','Kifan garten bb?::: esra?','Nop war da erst ein mal und hab mich dann mit dem wch man angelaegt und dann dann bin ich einfach rein gegangen der typ wollte mir net glauben dat ich ein termin hab','Wie zau fette sau die','Komm dir mit ugor','Lol bin kraassser','BIn strassenschlaeger wie zau sas','Aba die weiber sehen imma krass aus hab noch nie eine polin in duck gesehen','Alle waren imma dunn wie zau','Ja wer ich dann auch machen gt','Hab ja top fach manner hoer am start','Brauch net mal nen trenner hab euch heheheheh','Hab euch 5 bodybilder gleichzeitig amstart heheheh geht duch','Achsoi dann zwei top klaase bodybilder','Sol bei ihn treniren er mein er macht aus mich ne kamofmarschiene','Hahah haben aie dat ding auch mal fertig','Halt miss sein bist auch boss in Tiere?','Hahaha. Wer hats dich gefragt wars der marlon?','Mit denn neuanfang','Wers dat denn loll','Hab strassen Abitur iss beste','Boss in den Geschaeft heheh','Isso hab auch fuss ball 7 Jahre gemacht mussen 1a sein','Iss der trizep grosser als der bizep? Oda ander herum?','Konzentrazonslager wtf','Jap die neur sprwche heist gugonisch','Jap uff 100 schrank gleich doppelt so dick','Ich gerne frueh gute sachen aba uch naehme Zinsen hehehe','Mein name drinne wtf wieso sacghh ma','Fruehsten tu ich','Japp muss mir noch ne neu Grafik karte holen dann die iss irgendwue kaputt gegangen','Dat sind mitlaufer haahha','Bin boss einer ganzen armarder','Hatte ivh letzte wochh da buddda','Sonn ott hab ich hierr bei mir immma','Im Moment chillenn buddda ubd geld sammel heheh','Draussen beste zu bufffen aba wens warm iss Xd','Trotz Weltwirtschaftskrise Laeuft zaehlt die gald marschiere','brauche hilllllfeee internet von mein pc geht jetzt wieder musss nur noch das fix aba ka wie emm da hat wer nen fussball auf mein tastertur fallen lasssen dabei ist ein komische tastenkombie gedruck wurden und jetzt geht f1 f2f3 usw und esc einfg auch net meher kannnnnnn kein menu offfen -,-,-,=((((((','Uuff im bett und Langeweile schieben uff','Uffel nee duu yaayyaA','Zzz ufff deine mama steigt in in ein plantsch Becken mit 5 80Jahre alten sacken und pumpt deren sacke uff','Hab 5laute bei deina mama gehsehen ufff','Em jor uff','Uff uff? Haram pada ohne ende yaa','Scharf zimmma Blick ya bald krieg yAah','Dickkke schieber fresse haste uff','Und warze inner schnauze uffyah','Mad? Dubhahahha','Pisss dich an uff wenn vormir stehst','Vertrocknete haste Pflaume haste hahah','Wtf neher fett wie farid uff','Bitzep wie Bueffel','Habb uff mein PC noch nen paar meher pic von takken ahhah','Luecken texst ufff','Seelhanter uff hat wer die nummma','Grade Frisoer heheh dickken Boxer inner bux','Mach ma ip logger rein wenn dat geht fuer skype und whatsapp bro','Niko patte eifersuechtig wie zau issie','Jooo wat geht bei der bossauraapp heheh','Sieben )) weill drrei uff iss','Grad wach gewwufff dorst wie zau gehabt','Lafff daa kommmt jaa cer mein tages Ablauf ähnlich. Hehehe','Ka sonnnast hab ich son 20 am tach geraucht laff','Lafff das ist ein supper geschenkt. Für. Denn nikoo dieee olllen kanaks immmaa ufffharten man machen in Wahrheit gaybiy nr.1','Beste sind die hack für. Die game da ist viel mehwr muhe drinne als in game selber lacch','Trotz Weltwirtschaftskrise Läuft zählt die gald marschiere','Mein Vater is dicke mit denn chaf und mach haram pada mit Fisch und ottt ohne zu rauchen yoo'}
    local userid_to_entindex = client.userid_to_entindex


    local function killsay(e)

        local victim_userid, attacker_userid = e.userid, e.attacker

        if victim_userid == nil or attacker_userid == nil then
            return
        end
        local local_player = entity.get_local_player()

        local victim_entindex   = client.userid_to_entindex(victim_userid)
        local attacker_entindex = client.userid_to_entindex(attacker_userid)

        if not ui.get(tabs) == "Miscellaneous" then
            return
        end
        if attacker_entindex == local_player and entity.is_enemy(victim_entindex) then
            --if ui.get(visualenable) then
                if ui.get(killsaye) then
                    local commandhs = 'say ' .. hstable[math.random(#hstable)]
                    client.exec(commandhs)
                end
            --end
        end
    end
    client.set_event_callback("player_death", killsay)

    local vars ={
        sintag_time = 0,
        sintag = " n e x u s",
        clantag_enbl = false,
    }
    
    local function clear_clantag()
        client.set_clan_tag("")
    end
    local c_tag = {
        i = 1,
        a = 1,
        c = 0
    }


    local function animate_string()
        local str = ""
        local cur = 0

        if c_tag.i == 0 then
            str = str .. ""
        end

        for i in string.gmatch(vars.sintag, "%S+") do
            cur = cur + 1
            str = str .. i

            if c_tag.i == cur then
                str = str .. "/"
            end

            if cur > c_tag.c then
                c_tag.c = cur
            end
        end

        if c_tag.i >= c_tag.c then
            c_tag.a = -1
        elseif c_tag.i <= 0 then
            c_tag.a = 1
        end

        c_tag.i = c_tag.i + c_tag.a
        return str
    end

    local function run_clantag() -- shiddy clantag fard
        if not ui.get(tabs) == "Visuals" then
            return
        end
        local clantag2 = ui.get(clantage)
            if ui.get(clantage) then
                local time = globals.tickcount() * globals.tickinterval()

                if vars.sintag_time + 0.3 < time then
                    client.set_clan_tag(animate_string())
                    vars.sintag_time = time
                elseif vars.sintag_time > time then
                    vars.sintag_time = time
                end

                vars.clantag_enbl = true
            elseif not clantag2 and vars.clantag_enbl then
                clear_clantag()
                vars.clantag_enbl = false
            end
    end
    client.set_event_callback("paint", run_clantag)

    client.set_event_callback("net_update_end", function()
        if ui.get(legfucker) then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        end
    end)


    client.set_event_callback("pre_render", function()
        if contains(ui.get(animations), "Static legs in air") then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
        end 

        if contains(ui.get(animations), "Zero-pitch on land") then
            if entity.is_alive(entity.get_local_player()) then
                local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
                if on_ground == 1 then
                    ground_ticks = ground_ticks + 1
                else
                    ground_ticks = 0
                    end_time = globals.curtime() + 1
                end 
            
                if ground_ticks > ui.get(ref.aa.fake_lag_limit)+1 and end_time > globals.curtime() then
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
                end
            end
        end
        if contains(ui.get(animations), "Fake duck animation") then
            if ui.get(ref.aa.fakeduck) then
                if client.random_int(1, 5) == 1 then
                    entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 10)
                end
            end
        end
    end)

    client.set_event_callback("round_start", function() 
        paris_insert_log("Reset anti-brute data due to round end",6)
    end)


    client.set_event_callback("player_death", function(e) 
        local player_death_idx = client.userid_to_entindex(e.userid)
        if player_death_idx ~= entity.get_local_player() then
            return
        end
        paris_insert_log("Reset anti-brute data due to death",6)
    end)


    ffi.cdef[[
        struct cusercmd
        {
            struct cusercmd (*cusercmd)();
            int     command_number;
            int     tick_count;
        };
        typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
        ]]

        local signature_ginput = base64.decode("uczMzMyLQDj/0ITAD4U=")
        local match = client.find_signature("client.dll", signature_ginput) or error("sig1 not found")
        local g_input = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("match is nil")
        local g_inputclass = ffi.cast("void***", g_input)
        local g_inputvtbl = g_inputclass[0]
        local rawgetusercmd = g_inputvtbl[8]
        local get_user_cmd = ffi.cast("get_user_cmd_t", rawgetusercmd)
        local lastlocal = 0
        local function reduce(e)
            local cmd = get_user_cmd(g_inputclass , 0, e.command_number)
            if lastlocal + 0.9 > globals.curtime() then
                cmd.tick_count = cmd.tick_count + 8
            else
                cmd.tick_count = cmd.tick_count + 1
            end
        end


        local function fire(e)
            if client.userid_to_entindex(e.userid) == entity.get_local_player() then
                lastlocal = globals.curtime()
                if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
                    lastdt = globals.curtime() + 1.1
                end
            end
        end


    client.set_event_callback("shutdown", function()
        multi_exec(ui.set_visible, {
            [ref.aa.enabled] = true,
            [ref.aa.pitch] = true,
            [ref.aa.yaw_base] = true,
            [ref.aa.yaw[1]] = true,
            [ref.aa.yaw[2]] = true,
            [ref.aa.yaw_jitter[1]] = true,
            [ref.aa.yaw_jitter[2]] = true,
            [ref.aa.body_yaw[1]] = true,
            [ref.aa.body_yaw[2]] = true,
            [ref.aa.freestanding_body_yaw] = true,
            [ref.aa.fake_yaw_limit] = true,
            [ref.aa.freestanding[1]] = true,
            [ref.aa.freestanding[2]] = true,
            [ref.aa.edge_yaw] = true,
            [ref.aa.roll] = true
        })
    -- end 

    end)

    client.set_event_callback("aim_hit", hitlog)
    client.set_event_callback("aim_miss", misslog)
    client.set_event_callback("setup_command",misc.anti_knife)
    client.set_event_callback("paint_ui", paris_render_logs)
    client.set_event_callback("paint_ui", menuhide)
    client.set_event_callback("player_death", killsay)
    client.set_event_callback("paint", run_clantag)
    client.set_event_callback("round_prestart", on_round_prestart)
    client.set_event_callback('pre_config_save', function()
        database.write("ui_x2", iu2.x2)
        database.write("ui_y2", iu2.y2)
    end)
end
main()