--coded and developed by prophesy staff team xdxd#1111 & Doners#7909
local ffi = require('ffi')
local bit = require('bit')
local antiaim_funcs = require('gamesense/antiaim_funcs')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
local images = require('gamesense/images')
local http = require('gamesense/http')
local ent = require ('gamesense/entity')
local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'nightly', discord=''}
local username = obex_data.username

local function str_to_sub(input, sep)
	local t = {}
	for str in string.gmatch(input, "([^"..sep.."]+)") do
		t[#t + 1] = string.gsub(str, "\n", "")
	end
	return t
end

local function to_boolean(str)
	if str == "true" or str == "false" then
		return (str == "true")
	else
		return str
	end
end
prophesy = {
    table = {
        config_data = {};
        visuals = {
            picture = "https://cdn.discordapp.com/attachments/1110068391785529415/1110418348258365440/255px-Transgender_Pride_flag.png";
            image_loaded = "";
            animation_variables = {};
            new_change = true;
            to_draw_ticks = 0;
            offset_maxed2 = 0;
            indi_op = 0;
            offset_maxed = 0;
            indi_op2 = 0;
            indi_op3 = 0;
            indi_op4 = 0;
        };
    };
    reference = {};
    menu = {};
    anti_aim = {
        is_invert = false;
        tick_var = 0;
        cur_team = 0;
        state_id = 0;
        is_active_inds = 0;
        pitch = "";
        pitch_value = 0;
        yaw_base = "";
        yaw = "";
        yaw_value = 0;
        yaw_jitter = "";
        yaw_jitter_value = 0;
        body_yaw = "";
        body_yaw_value = 0;
        freestanding_body_yaw = false;
        freestanding = "";
        freestanding_value = 0;
        defensive_ct = false;
        defensive_t = false;
        is_active = false;
        last_press = 0;
        aa_dir = 0;
        defensive = false;
        defensive_ticks = 0;
        ground_time = 0;
        current_preset = 0;
    };
}

prophesy.reference = {
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
    }
}

setup_skeet_element = function (types, element, value, type_of)
    if types == "vis" then
        for table, values in pairs(prophesy.reference.anti_aim) do
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

--#functions

-- helpers function @credit:boshka~#9502 (russian friend)


local script = {}

script.helpers = {
    defensive = 0,
    checker = 0,

    easeInOut = function(self, t)
        return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
    end,

    clamp = function(self, val, lower, upper)
        assert(val and lower and upper, "not very useful error message here")
        if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
        return math.max(lower, math.min(upper, val))
    end,

    split = function(self, inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
    end,

    rgba_to_hex = function(self, r, g, b, a)
      return bit.tohex(
        (math.floor(r + 0.5) * 16777216) + 
        (math.floor(g + 0.5) * 65536) + 
        (math.floor(b + 0.5) * 256) + 
        (math.floor(a + 0.5))
      )
    end,

    hex_to_rgba = function(self, hex)
    local color = tonumber(hex, 16)

    return 
    math.floor(color / 16777216) % 256, 
    math.floor(color / 65536) % 256, 
    math.floor(color / 256) % 256, 
    color % 256
    end,

    color_text = function(self, string, r, g, b, a)
        local accent = "\a" .. self:rgba_to_hex(r, g, b, a)
        local white = "\a" .. self:rgba_to_hex(255, 255, 255, a)

        local str = ""
        for i, s in ipairs(self:split(string, "$")) do
            str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
        end

        return str
    end,

    animate_text = function(self, time, string, r, g, b, a)
        local t_out, t_out_iter = { }, 1

        local l = string:len( ) - 1

        local r_add = (255 - r)
        local g_add = (255 - g)
        local b_add = (255 - b)
        local a_add = (155 - a)

        for i = 1, #string do
            local iter = (i - 1)/(#string - 1) + time
            t_out[t_out_iter] = "\a" .. script.helpers:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )

            t_out[t_out_iter + 1] = string:sub( i, i )

            t_out_iter = t_out_iter + 2
        end

        return t_out
    end,

    get_time = function(self, h12)
        local hours, minutes, seconds = client.system_time()

        if h12 then
                local hrs = hours % 12

                if hrs == 0 then
                        hrs = 12
                else
                        hrs = hrs < 10 and hrs or ('%02d'):format(hrs)
                end

                return ('%s:%02d %s'):format(
                        hrs,
                        minutes,
                        hours >= 12 and 'pm' or 'am'
                )
        end

        return ('%02d:%02d:%02d'):format(
                hours,
                minutes,
                seconds
        )
end,
}


script.renderer = {
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
        end
        for k = 0, width do
            if a * (k/width)^(1) > 5 then
                local accent = {r, g, b, a * (k/width)^(2)}
                self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
            end
        end
    end
}

local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

-- LERP FUNCTION FOR THE ANIMATION
function prophesy.table.visuals.animation_variables.lerp(a,b,t)
    return a + (b - a) * t
end

-- ALPHA = ALPHA; MIN = MINIMUM ALPHA FOR THE PULSATION; MAX = MAXIMUM ALPHA FOR THE PULSATION; SPEED = ANIMATION SPEED
function prophesy.table.visuals.animation_variables.pulsate(alpha,min,max,speed)

    if alpha >= max - 2 then
        prophesy.table.visuals.new_change = false
        --alpha = animation_variables.lerp(alpha,max,globals.frametime() * speed)
    elseif alpha <= min  + 2 then
        prophesy.table.visuals.new_change = true
        --alpha = animation_variables.lerp(alpha,min,globals.frametime() * speed)
    end

    if prophesy.table.visuals.new_change == true then
        alpha = prophesy.table.visuals.animation_variables.lerp(alpha,max,globals.frametime() * speed)
    else
        alpha = prophesy.table.visuals.animation_variables.lerp(alpha,min,globals.frametime() * speed)
    end

    return alpha 
end

-- OFFSET TO BE MODULATED; WHEN = TRUE OR FALSE TO MODULATE; ORIGINAL = ORIGINAL POSITION; NEW_PLACE = LOCATION FOR THE OFFSET TO MOVE TO; SPEED = ANIMATION SPEED
function prophesy.table.visuals.animation_variables.movement(offset,when,original,new_place,speed)

    if when == true then
        offset = prophesy.table.visuals.animation_variables.lerp(offset,new_place,globals.frametime() * speed)
    else
        offset = prophesy.table.visuals.animation_variables.lerp(offset,original,globals.frametime() * speed)
    end

    return offset 
end

-- ALPHA = YOUR ALPHA; FADE_BOOL = IF TRUE FADES IN IF NEGATIVE FADES AWAY;F_IN = FADE IN ALPHA; F_AWAY = FADE AWAY ALPHA; SPEED = ANIMATION SPEED
function prophesy.table.visuals.animation_variables.fade(alpha,fade_bool,f_in,f_away,speed) 

    if fade_bool == true then 
        alpha = prophesy.table.visuals.animation_variables.lerp(alpha,f_in,globals.frametime() * speed)
    else
        alpha = prophesy.table.visuals.animation_variables.lerp(alpha,f_away,globals.frametime() * speed)
    end

    return alpha
end

rounded_rectangle = function(x, y, r, g, b, a, width, height, radius)
    -- rectangles
  
    renderer.rectangle(x + radius, y, width - (radius * 2), radius, r, g, b, a)
    renderer.rectangle(x + radius, y + height - radius, width - (radius * 2), radius, r, g, b, a)
    renderer.rectangle(x, y + radius, radius, height - (radius * 2), r, g, b, a)
    renderer.rectangle(x + (width - radius), y + radius, radius, height - (radius * 2), r, g, b, a)

    -- circles
    renderer.circle(x + radius, y + radius, r, g, b,a, radius, 145, radius * 0.1)
    renderer.circle(x + width - radius, y + radius, r, g, b, a, radius, 90, radius * 0.1)
    renderer.circle(x + radius, y + height - radius, r, g, b, a, radius, 180, radius * 0.1)
    renderer.circle(x + width - radius, y + height - radius, r, g, b, a, radius, 0, radius * 0.1)
end

prophesy.menu.antiaim_elements_ct = {}
prophesy.menu.antiaim_elements_t = {}
prophesy.menu.tab_label = ui.new_label("AA", "Anti-aimbot angles", " ")
prophesy.menu.color_picker = ui.new_color_picker("AA", "Anti-aimbot angles", " ", 179, 190, 214, 255)
prophesy.menu.tab_selector = ui.new_combobox("AA", "Anti-aimbot angles", "\nselection", {"welcome", "anti-aim", "misc", "visuals", "config"})
prophesy.menu.antiaim_button = ui.new_label("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFlinks");
prophesy.menu.antiaim_combo = ui.new_combobox("AA", "Anti-aimbot angles", "\nbuttons", "discord", "youtube")

prophesy.menu.antiaim_discord = ui.new_button("AA", "Anti-aimbot angles", "load button" , function()
    if ui.get(prophesy.menu.antiaim_combo) == "discord" then
    panorama.loadstring("SteamOverlayAPI.OpenExternalBrowserURL('https://discord.gg/jitter');")()
    elseif ui.get(prophesy.menu.antiaim_combo) == "youtube" then
    panorama.loadstring("SteamOverlayAPI.OpenExternalBrowserURL('https://www.youtube.com/@kurahvh/videos');")()
    end
end);
prophesy.menu.antiaim_list = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFpresets", "slow jitter", "custom desync", "unmatched");
prophesy.menu.antiaim_enable_addons = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFkeybinds");
prophesy.menu.antiaim_manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFleft");
prophesy.menu.antiaim_manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFright");
prophesy.menu.antiaim_manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFforward");
prophesy.menu.antiaim_freestanding = ui.new_hotkey("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFfs");
prophesy.menu.antiaim_enable_resolver = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFcorrection");
prophesy.menu.antiaim_enable_resolver_combo = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFtype", "small correction", "desync correction");
prophesy.menu.antiaim_anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFavoid backstab");
prophesy.menu.antiaim_legit_aa = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFlegit anti-aim");
prophesy.menu.antiaim_quickpeek = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFpeek addons");
prophesy.menu.antiaim_quickpeek_addons = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFbody", "static", "jitter", "opposite");
prophesy.menu.antiaim_quickpeek_addons_second = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFmanipulation", "none", "slow", "fast");
prophesy.menu.antiaim_quickpeek_addons_third = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFdefensive", "off", "on");
prophesy.menu.antiaim_safeknife = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFsafe head");
prophesy.menu.antiaim_safeknife_options = ui.new_multiselect("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFtrigger", "knife", "zeus");
prophesy.menu.antiaim_animation = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFanimations");
prophesy.menu.antiaim_animation_ground = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFground", "off", "sliding", "moonwalk", "break", "modern");
prophesy.menu.antiaim_animation_air = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFin air", "off", "static", "moonwalk", "running");
prophesy.menu.antiaim_animation_extra = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFextras", "off", "reset pitch");
prophesy.menu.antiaim_defensive_exploit = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFdefensive");
prophesy.menu.antiaim_defensive_type = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFtype", "meta", "custom");
prophesy.menu.antiaim_defensive_pitch = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFpitch", "off", "default", "up", "down", "minimal", "random", "custom");
prophesy.menu.antiaim_defensive_pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFcustom pitch", -89, 89, 0, true, "°");
prophesy.menu.antiaim_defensive_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFyaw", "off", "180", "spin", "static", "180 Z", "crosshair");
prophesy.menu.antiaim_defensive_offset = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFyaw offset", -180, 180, 0, true, "°");
prophesy.menu.antiaim_defensive_byaw = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFbody", "off", "off", "opposite", "jitter", "static");
prophesy.menu.antiaim_defensive_boffset = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFbody offset", -180, 180, 0, true, "°");
prophesy.menu.indicators5 = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFindicator", "none", "modern");
prophesy.menu.indicators2 = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFwatermark type", "text", "flag", "legacy");
prophesy.menu.indicators = ui.new_multiselect("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFdefensive indicator", "text", "bar", "icon")
prophesy.menu.builder_state = {'global', 'stand', 'run', 'slow', 'in air', 'air duck', 'move duck', 'duck', 'fake lag'}
prophesy.menu.state_to_num = { 
    ['global'] = 1, 
    ['stand'] = 2, 
    ['run'] = 3, 
    ['slow'] = 4, --export
    ['in air'] = 5,
    ['air duck'] = 6,
    ['move duck'] = 7,
    ['duck'] = 8,
    ['fake lag'] = 9, 
};
prophesy.menu.team_site = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFFselector", {"counter", "terror"})
prophesy.menu.aabuilder_state = ui.new_combobox("AA", "Anti-aimbot angles", "\nstate", prophesy.menu.builder_state);
send_button_t = function ()
    local str = ""
    for i=1, 9 do
        if ui.get(prophesy.menu.aabuilder_state) == prophesy.menu.builder_state[i] then
            str = str
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_pitch)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_pitch_slider)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_base)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_left)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_right)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_tick)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_delay)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_left)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_right)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_body_yaw_adv_left)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_body_yaw_adv_right)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider_l)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider_r)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_body_yaw)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_body_yaw_slider)) .. "|"
        end
    end

    local tbl = str_to_sub(str, "|")
	for i2 = 1, 9 do
        if ui.get(prophesy.menu.aabuilder_state) == prophesy.menu.builder_state[i2] then
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_pitch, tostring(tbl[1]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_pitch_slider, tonumber(tbl[2]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_base, tostring(tbl[3]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw, tostring(tbl[4]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_advanced, tostring(tbl[5]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_slider, tonumber(tbl[6]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_slider_left, tonumber(tbl[7]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_slider_right, tonumber(tbl[8]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_slider_adv_tick, tonumber(tbl[9]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_slider_adv_delay, tostring(tbl[10]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_slider_adv_left, tonumber(tbl[11]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_slider_adv_right, tonumber(tbl[12]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_body_yaw_adv_left, tostring(tbl[13]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_body_yaw_adv_right, tostring(tbl[14]))   
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_jitter, tostring(tbl[15]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_jitter_slider, tonumber(tbl[16]))
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_jitter_slider_l, tonumber(tbl[17]))       
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_yaw_jitter_slider_r, tonumber(tbl[18]))    
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_body_yaw, tostring(tbl[19]))       
            ui.set(prophesy.menu.antiaim_elements_t[i2].antiaim_body_yaw_slider, tonumber(tbl[20]))         
        end
	end
end

send_button_ct = function ()
    local str = ""
    for i=1, 9 do
        if ui.get(prophesy.menu.aabuilder_state) == prophesy.menu.builder_state[i] then
            str = str
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_pitch)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_pitch_slider)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_base)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_left)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_right)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_tick)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_delay)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_left)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_right)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_body_yaw_adv_left)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_body_yaw_adv_right)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider_l)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider_r)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_body_yaw)) .. "|"
            .. tostring(ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_body_yaw_slider)) .. "|"
        end
    end

    local tbl = str_to_sub(str, "|")
	for i2 = 1, 9 do
        if ui.get(prophesy.menu.aabuilder_state) == prophesy.menu.builder_state[i2] then
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_pitch, tostring(tbl[1]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_pitch_slider, tonumber(tbl[2]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_base, tostring(tbl[3]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw, tostring(tbl[4]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_advanced, tostring(tbl[5]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_slider, tonumber(tbl[6]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_left, tonumber(tbl[7]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_right, tonumber(tbl[8]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_adv_tick, tonumber(tbl[9]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_adv_delay, tostring(tbl[10]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_adv_left, tonumber(tbl[11]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_adv_right, tonumber(tbl[12]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_body_yaw_adv_left, tostring(tbl[13]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_body_yaw_adv_right, tostring(tbl[14]))   
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_jitter, tostring(tbl[15]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_jitter_slider, tonumber(tbl[16]))
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_jitter_slider_l, tonumber(tbl[17]))       
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_yaw_jitter_slider_r, tonumber(tbl[18]))    
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_body_yaw, tostring(tbl[19]))       
            ui.set(prophesy.menu.antiaim_elements_ct[i2].antiaim_body_yaw_slider, tonumber(tbl[20]))         
        end
	end
end
for k, v in pairs(prophesy.menu.builder_state) do
    prophesy.menu.antiaim_elements_ct[k] = {  
        enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB3BED6FFenable \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].."");
        antiaim_pitch = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] pitch  ", {"off", "default", "up", "down", "minimal", "random", "custom"});
        antiaim_pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] custom pitch", -89, 89, 0, true, "°");
        antiaim_yaw_base = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] yaw base  ", {"at targets", "local view"});
        antiaim_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] yaw  ", {"off", "180", "spin", "static", "180 Z", "crosshair"});
        antiaim_yaw_advanced = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] yaw type ", {"static", "custom desync", "tick", "break", "anti-break", "sync"});
        antiaim_yaw_slider = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] static yaw", -180, 180, 0, true, "°");
        antiaim_yaw_slider_left = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] left yaw  ", -180, 180, 0, true, "°");
        antiaim_yaw_slider_right = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] right yaw  ", -180, 180, 0, true, "°");
        antiaim_yaw_slider_adv_tick = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] manipulation speed  ", 1, 50, 0, true, "x");
        antiaim_yaw_slider_adv_delay = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] manipulation delay  ", 1, 10, 0, true, "d");
        antiaim_yaw_slider_adv_left = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] manipulation left  ", -180, 180, 0, true, "°");
        antiaim_yaw_slider_adv_right = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] manipulation right  ", -180, 180, 0, true, "°");
        antiaim_body_yaw_adv_left = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] body yaw left ", {"off", "opposite", "jitter", "static"});
        antiaim_body_yaw_adv_right = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] body yaw right ", {"off", "opposite", "jitter", "static"});
        antiaim_yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] yaw jitter ", {"off", "offset", "center", "random", "skitter", "left ^ right offset", "left ^ right center", "left ^ right random", "left ^ right skitter"});
        antiaim_yaw_jitter_slider = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] static jitter ", -180, 180, 0, true, "°");
        antiaim_yaw_jitter_slider_l = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] left jitter ", -180, 180, 0, true, "°");
        antiaim_yaw_jitter_slider_r = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] right jitter ", -180, 180, 0, true, "°");
        antiaim_body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] body yaw ", {"off", "opposite", "jitter", "static"});
        antiaim_body_yaw_slider = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] static body yaw", -180, 180, 0, true, "°");
        antiaim_defensive = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [ct] defensive ", {"off", "always on", "switch cycle"});
        send_to_t = ui.new_button("AA", "Anti-aimbot angles", "Send to \aB3BED6FFT", send_button_t);
    }
end

for k, v in pairs(prophesy.menu.builder_state) do
    prophesy.menu.antiaim_elements_t[k] = {
        enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\aB3BED6FFenable \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].."");
        antiaim_pitch = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] pitch  ", {"off", "default", "up", "down", "minimal", "random", "custom"});
        antiaim_pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] custom pitch", -89, 89, 0, true, "°");
        antiaim_yaw_base = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] yaw base  ", {"at targets", "local view"});
        antiaim_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] yaw  ", {"off", "180", "spin", "static", "180 Z", "crosshair"});
        antiaim_yaw_advanced = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] yaw manipulation ", {"static", "custom desync", "tick", "break", "anti-break", "sync"});
        antiaim_yaw_slider = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] static yaw", -180, 180, 0, true, "°");
        antiaim_yaw_slider_left = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] left yaw  ", -180, 180, 0, true, "°");
        antiaim_yaw_slider_right = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] right yaw  ", -180, 180, 0, true, "°");
        antiaim_yaw_slider_adv_tick = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] manipulation speed  ", 1, 50, 0, true, "x");
        antiaim_yaw_slider_adv_delay = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] manipulation delay  ", 1, 10, 0, true, "d");
        antiaim_yaw_slider_adv_left = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] manipulation left  ", -180, 180, 0, true, "°");
        antiaim_yaw_slider_adv_right = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] manipulation right  ", -180, 180, 0, true, "°");
        antiaim_body_yaw_adv_left = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] body yaw left ", {"off", "opposite", "jitter", "static"});
        antiaim_body_yaw_adv_right = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] body yaw right ", {"off", "opposite", "jitter", "static"});
        antiaim_yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] yaw jitter ", {"off", "offset", "center", "random", "skitter", "left ^ right offset", "left ^ right center", "left ^ right random", "left ^ right skitter"});
        antiaim_yaw_jitter_slider = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] static jitter ", -180, 180, 0, true, "°");
        antiaim_yaw_jitter_slider_l = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] left jitter ", -180, 180, 0, true, "°");
        antiaim_yaw_jitter_slider_r = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] right jitter ", -180, 180, 0, true, "°");
        antiaim_body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] body yaw ", {"off", "opposite", "jitter", "static"});
        antiaim_body_yaw_slider = ui.new_slider("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t]] static body yaw", -180, 180, 0, true, "°");
        antiaim_defensive = ui.new_combobox("AA", "Anti-aimbot angles", "\aB3BED6FFprophesy \a989898FF- \aFFFFFFFF"..prophesy.menu.builder_state[k].." [t] defensive ", {"off", "always on", "switch cycle"});
        send_to_ct = ui.new_button("AA", "Anti-aimbot angles", "Send to \aB3BED6FFCT", send_button_ct);
    }
end

prophesy.table.config_data.cfg_data = {
    anti_aim = {
        prophesy.menu.antiaim_elements_ct[1].antiaim_pitch;
        prophesy.menu.antiaim_elements_ct[1].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_ct[1].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_ct[1].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_ct[1].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_ct[1].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_ct[1].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_ct[1].antiaim_defensive;

        prophesy.menu.antiaim_elements_ct[2].enable;
        prophesy.menu.antiaim_elements_ct[2].antiaim_pitch;
        prophesy.menu.antiaim_elements_ct[2].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_ct[2].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_ct[2].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_ct[2].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_ct[2].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_ct[2].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_ct[2].antiaim_defensive;
        prophesy.menu.antiaim_elements_ct[3].enable;
        prophesy.menu.antiaim_elements_ct[3].antiaim_pitch;
        prophesy.menu.antiaim_elements_ct[3].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_ct[3].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_ct[3].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_ct[3].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_ct[3].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_ct[3].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_ct[3].antiaim_defensive;

        prophesy.menu.antiaim_elements_ct[4].enable;
        prophesy.menu.antiaim_elements_ct[4].antiaim_pitch;
        prophesy.menu.antiaim_elements_ct[4].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_ct[4].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_ct[4].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_ct[4].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_ct[4].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_ct[4].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_ct[4].antiaim_defensive;

        prophesy.menu.antiaim_elements_ct[5].enable;
        prophesy.menu.antiaim_elements_ct[5].antiaim_pitch;
        prophesy.menu.antiaim_elements_ct[5].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_ct[5].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_ct[5].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_ct[5].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_ct[5].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_ct[5].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_ct[5].antiaim_defensive;

        prophesy.menu.antiaim_elements_ct[6].enable;
        prophesy.menu.antiaim_elements_ct[6].antiaim_pitch;
        prophesy.menu.antiaim_elements_ct[6].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_ct[6].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_ct[6].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_ct[6].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_ct[6].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_ct[6].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_ct[6].antiaim_defensive;
        prophesy.menu.antiaim_elements_ct[7].enable;
        prophesy.menu.antiaim_elements_ct[7].antiaim_pitch;
        prophesy.menu.antiaim_elements_ct[7].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_ct[7].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_ct[7].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_ct[7].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_ct[7].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_ct[7].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_ct[7].antiaim_defensive;

        prophesy.menu.antiaim_elements_ct[8].enable;
        prophesy.menu.antiaim_elements_ct[8].antiaim_pitch;
        prophesy.menu.antiaim_elements_ct[8].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_ct[8].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_ct[8].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_ct[8].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_ct[8].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_ct[8].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_ct[8].antiaim_defensive;

        prophesy.menu.antiaim_elements_ct[9].enable;
        prophesy.menu.antiaim_elements_ct[9].antiaim_pitch;
        prophesy.menu.antiaim_elements_ct[9].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_ct[9].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_ct[9].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_ct[9].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_ct[9].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_ct[9].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_ct[9].antiaim_defensive;

        prophesy.menu.antiaim_elements_t[1].antiaim_pitch;
        prophesy.menu.antiaim_elements_t[1].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_t[1].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_t[1].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_t[1].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_t[1].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_t[1].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_t[1].antiaim_defensive;
        prophesy.menu.antiaim_elements_t[2].enable;
        prophesy.menu.antiaim_elements_t[2].antiaim_pitch;
        prophesy.menu.antiaim_elements_t[2].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_t[2].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_t[2].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_t[2].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_t[2].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_t[2].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_t[2].antiaim_defensive;
        prophesy.menu.antiaim_elements_t[3].enable;
        prophesy.menu.antiaim_elements_t[3].antiaim_pitch;
        prophesy.menu.antiaim_elements_t[3].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_t[3].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_t[3].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_t[3].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_t[3].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_t[3].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_t[3].antiaim_defensive;
        prophesy.menu.antiaim_elements_t[4].enable;
        prophesy.menu.antiaim_elements_t[4].antiaim_pitch;
        prophesy.menu.antiaim_elements_t[4].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_t[4].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_t[4].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_t[4].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_t[4].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_t[4].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_t[4].antiaim_defensive;
        prophesy.menu.antiaim_elements_t[5].enable;
        prophesy.menu.antiaim_elements_t[5].antiaim_pitch;
        prophesy.menu.antiaim_elements_t[5].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_t[5].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_t[5].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_t[5].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_t[5].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_t[5].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_t[5].antiaim_defensive;
        prophesy.menu.antiaim_elements_t[6].enable;
        prophesy.menu.antiaim_elements_t[6].antiaim_pitch;
        prophesy.menu.antiaim_elements_t[6].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_t[6].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_t[6].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_t[6].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_t[6].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_t[6].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_t[6].antiaim_defensive;
        prophesy.menu.antiaim_elements_t[7].enable;
        prophesy.menu.antiaim_elements_t[7].antiaim_pitch;
        prophesy.menu.antiaim_elements_t[7].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_t[7].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_t[7].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_t[7].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_t[7].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_t[7].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_t[7].antiaim_defensive;
        prophesy.menu.antiaim_elements_t[8].enable;
        prophesy.menu.antiaim_elements_t[8].antiaim_pitch;
        prophesy.menu.antiaim_elements_t[8].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_t[8].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_t[8].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_t[8].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_t[8].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_t[8].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_t[8].antiaim_defensive;
        prophesy.menu.antiaim_elements_t[9].enable;
        prophesy.menu.antiaim_elements_t[9].antiaim_pitch;
        prophesy.menu.antiaim_elements_t[9].antiaim_pitch_slider;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_base;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_advanced;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_slider;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_slider_left;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_slider_right;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_slider_adv_tick;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_slider_adv_delay;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_slider_adv_left;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_slider_adv_right;
        prophesy.menu.antiaim_elements_t[9].antiaim_body_yaw_adv_left;
        prophesy.menu.antiaim_elements_t[9].antiaim_body_yaw_adv_right;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_jitter;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_jitter_slider;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_jitter_slider_l;
        prophesy.menu.antiaim_elements_t[9].antiaim_yaw_jitter_slider_r;
        prophesy.menu.antiaim_elements_t[9].antiaim_body_yaw;
        prophesy.menu.antiaim_elements_t[9].antiaim_body_yaw_slider;
        prophesy.menu.antiaim_elements_t[9].antiaim_defensive;
    };

    keybindsandothertable = {};
    other_aa = {};
}

local export_config = ui.new_button("AA", "Anti-aimbot angles", "\aB3BED6FFExport", function ()
    local Code = {{}, {}, {}};

    for _, main in pairs(prophesy.table.config_data.cfg_data.anti_aim) do
        if ui.get(main) ~= nil then
            table.insert(Code[1], tostring(ui.get(main)))
        end
    end

    for _, main in pairs(prophesy.table.config_data.cfg_data.keybindsandothertable) do
        if ui.get(main) ~= nil then
            table.insert(Code[2], tostring(framework.library["=>"].func.arr_to_string(main)))
        end
    end

    for _, main in pairs(prophesy.table.config_data.cfg_data.other_aa) do
        if ui.get(main) ~= nil then
            table.insert(Code[3], tostring(ui.get(main)))
        end
    end

    clipboard.set(base64.encode(json.stringify(Code)))
end);
local import_config = ui.new_button("AA", "Anti-aimbot angles", "\aB3BED6FFImport", function ()
    local protected = function() 
        for k, v in pairs(json.parse(base64.decode(clipboard.get()))) do
            
            k = ({[1] = "anti_aim", [2] = "keybindsandothertable", [3] = "other_aa"})[k]

            for k2, v2 in pairs(v) do
                if (k == "anti_aim") then
                    if v2 == "true" then
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], false)
                    else
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], v2)
                    end
                end
                if (k == "keybindsandothertable") then
                    ui.set(prophesy.table.config_data.cfg_data[k][k2], framework.library["=>"].func.str_to_sub(v2, ","))
                end
                if (k == "other_aa") then
                    if v2 == "true" then
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], false)
                    else
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], v2)
                    end
                end
            end
        end
    end
    local status, message = pcall(protected)
    if not status then
        error("we get error on importing config")
        return
    end
end);

client.set_event_callback( "paint_ui", function(  )
if ui.get(prophesy.menu.antiaim_list) == "slow jitter" then
    preset_data = "W1siZG93biIsIjAiLCJhdCB0YXJnZXRzIiwiMTgwIiwic3RhdGljIiwiNSIsIjAiLCIwIiwiMSIsIjEiLCIwIiwiMCIsIm9mZiIsIm9mZiIsImNlbnRlciIsIjY4IiwiMCIsIjAiLCJqaXR0ZXIiLCIwIiwib2ZmIiwidHJ1ZSIsImRvd24iLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsInRpY2siLCIwIiwiMzQiLCItMzQiLCI1IiwiNiIsIjMwIiwiLTIwIiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsIm9mZiIsInRydWUiLCJkb3duIiwiODkiLCJhdCB0YXJnZXRzIiwiMTgwIiwidGljayIsIjAiLCItMzIiLCIyNyIsIjciLCI3IiwiNDMiLCItMjgiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwib2ZmIiwidHJ1ZSIsImRvd24iLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsInRpY2siLCIwIiwiMCIsIjAiLCI2IiwiNSIsIjI1IiwiLTE4Iiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsIm9mZiIsInRydWUiLCJtaW5pbWFsIiwiMCIsImF0IHRhcmdldHMiLCIxODAiLCJ0aWNrIiwiMCIsIi0yMyIsIjMwIiwiNSIsIjYiLCIzMCIsIi0xMiIsIm9mZiIsIm9mZiIsIm9mZiIsIjAiLCIwIiwiMCIsIm9mZiIsIjAiLCJvZmYiLCJ0cnVlIiwibWluaW1hbCIsIjAiLCJhdCB0YXJnZXRzIiwiMTgwIiwidGljayIsIjAiLCItMTkiLCIzOCIsIjUiLCI2IiwiMzkiLCItMTYiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwiYWx3YXlzIG9uIiwidHJ1ZSIsImRvd24iLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsInRpY2siLCIwIiwiLTMwIiwiNDAiLCI2IiwiNiIsIjM5IiwiLTIzIiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsIm9mZiIsInRydWUiLCJtaW5pbWFsIiwiMCIsImF0IHRhcmdldHMiLCIxODAiLCJ0aWNrIiwiMCIsIi00MSIsIjM0IiwiNSIsIjUiLCIyNCIsIi0yMCIsIm9mZiIsIm9mZiIsIm9mZiIsIjAiLCIwIiwiMCIsIm9mZiIsIjAiLCJvZmYiLCJ0cnVlIiwibWluaW1hbCIsIjAiLCJhdCB0YXJnZXRzIiwiMTgwIiwidGljayIsIjQiLCIxNiIsIi0xIiwiNiIsIjMiLCIzNCIsIi0yMyIsIm9mZiIsIm9mZiIsIm9mZiIsIjEiLCIxMDQiLCItNyIsImppdHRlciIsIjAiLCJvZmYiLCJkb3duIiwiMCIsImF0IHRhcmdldHMiLCIxODAiLCJzdGF0aWMiLCI1IiwiMCIsIjAiLCIxIiwiMSIsIjAiLCIwIiwib2ZmIiwib2ZmIiwiY2VudGVyIiwiNjgiLCIwIiwiMCIsImppdHRlciIsIjAiLCJvZmYiLCJ0cnVlIiwiZG93biIsIjAiLCJhdCB0YXJnZXRzIiwiMTgwIiwidGljayIsIjAiLCIzNCIsIi0zNCIsIjUiLCI2IiwiMzAiLCItMjAiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwib2ZmIiwidHJ1ZSIsImRvd24iLCI4OSIsImF0IHRhcmdldHMiLCIxODAiLCJ0aWNrIiwiMCIsIi0zMiIsIjI3IiwiNyIsIjciLCI0MyIsIi0yOCIsIm9mZiIsIm9mZiIsIm9mZiIsIjAiLCIwIiwiMCIsIm9mZiIsIjAiLCJvZmYiLCJ0cnVlIiwiZG93biIsIjAiLCJhdCB0YXJnZXRzIiwiMTgwIiwidGljayIsIjAiLCIwIiwiMCIsIjYiLCI1IiwiMjUiLCItMTgiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwib2ZmIiwidHJ1ZSIsIm1pbmltYWwiLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsInRpY2siLCIwIiwiLTIzIiwiMzAiLCI1IiwiNiIsIjMwIiwiLTEyIiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsIm9mZiIsInRydWUiLCJtaW5pbWFsIiwiMCIsImF0IHRhcmdldHMiLCIxODAiLCJ0aWNrIiwiMCIsIi0xOSIsIjM4IiwiNSIsIjYiLCIzOSIsIi0xNiIsIm9mZiIsIm9mZiIsIm9mZiIsIjAiLCIwIiwiMCIsIm9mZiIsIjAiLCJhbHdheXMgb24iLCJ0cnVlIiwiZG93biIsIjAiLCJhdCB0YXJnZXRzIiwiMTgwIiwidGljayIsIjAiLCItMzAiLCI0MCIsIjYiLCI2IiwiMzkiLCItMjMiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwib2ZmIiwidHJ1ZSIsIm1pbmltYWwiLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsInRpY2siLCIwIiwiLTQxIiwiMzQiLCI1IiwiNSIsIjM3IiwiLTI0Iiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsIm9mZiIsInRydWUiLCJtaW5pbWFsIiwiMCIsImF0IHRhcmdldHMiLCIxODAiLCJ0aWNrIiwiNCIsIjE2IiwiLTEiLCI2IiwiMyIsIjM0IiwiLTIzIiwib2ZmIiwib2ZmIiwib2ZmIiwiMSIsIjEwNCIsIi03Iiwiaml0dGVyIiwiMCIsIm9mZiJdLHt9LHt9XQ=="
elseif ui.get(prophesy.menu.antiaim_list) == "custom desync" then
    preset_data = "W1siZG93biIsIjAiLCJhdCB0YXJnZXRzIiwiMTgwIiwic3RhdGljIiwiNSIsIjAiLCIwIiwiMSIsIjEiLCIwIiwiMCIsIm9mZiIsIm9mZiIsImNlbnRlciIsIjY4IiwiMCIsIjAiLCJqaXR0ZXIiLCIwIiwib2ZmIiwidHJ1ZSIsImRvd24iLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsImN1c3RvbSBkZXN5bmMiLCIwIiwiMzQiLCItMzQiLCIxIiwiMSIsIjAiLCIwIiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsIm9mZiIsInRydWUiLCJkb3duIiwiODkiLCJhdCB0YXJnZXRzIiwiMTgwIiwiY3VzdG9tIGRlc3luYyIsIjAiLCItMzIiLCIyNyIsIjEiLCIxIiwiMCIsIjAiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwiYWx3YXlzIG9uIiwidHJ1ZSIsImRvd24iLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsInRpY2siLCIwIiwiMCIsIjAiLCIxMCIsIjUiLCItMzAiLCI2MCIsImppdHRlciIsIm9mZiIsIm9mZiIsIjAiLCIwIiwiMCIsIm9mZiIsIjAiLCJvZmYiLCJ0cnVlIiwibWluaW1hbCIsIjAiLCJhdCB0YXJnZXRzIiwiMTgwIiwiY3VzdG9tIGRlc3luYyIsIjAiLCItMjUiLCIzMCIsIjEiLCIxIiwiMCIsIjAiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwiYWx3YXlzIG9uIiwidHJ1ZSIsIm1pbmltYWwiLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsImN1c3RvbSBkZXN5bmMiLCIwIiwiLTE5IiwiMzgiLCIxIiwiMSIsIjAiLCIwIiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsIm9mZiIsInRydWUiLCJkb3duIiwiMCIsImF0IHRhcmdldHMiLCIxODAiLCJjdXN0b20gZGVzeW5jIiwiMCIsIi0yNSIsIjQwIiwiMSIsIjEiLCIwIiwiMCIsIm9mZiIsIm9mZiIsIm9mZiIsIjAiLCIwIiwiMCIsIm9mZiIsIjAiLCJvZmYiLCJ0cnVlIiwibWluaW1hbCIsIjAiLCJhdCB0YXJnZXRzIiwiMTgwIiwiY3VzdG9tIGRlc3luYyIsIjAiLCItNDEiLCIzNCIsIjEiLCIxIiwiMCIsIjAiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwib2ZmIiwidHJ1ZSIsIm1pbmltYWwiLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsInN0YXRpYyIsIjQiLCIwIiwiMCIsIjEiLCIxIiwiMCIsIjAiLCJvZmYiLCJvZmYiLCJjZW50ZXIiLCI2MSIsIjAiLCIwIiwiaml0dGVyIiwiMCIsIm9mZiIsImRvd24iLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsInN0YXRpYyIsIjUiLCIwIiwiMCIsIjEiLCIxIiwiMCIsIjAiLCJvZmYiLCJvZmYiLCJjZW50ZXIiLCI2OCIsIjAiLCIwIiwiaml0dGVyIiwiMCIsIm9mZiIsInRydWUiLCJkb3duIiwiMCIsImF0IHRhcmdldHMiLCIxODAiLCJjdXN0b20gZGVzeW5jIiwiMCIsIjM0IiwiLTM0IiwiMSIsIjEiLCIwIiwiMCIsIm9mZiIsIm9mZiIsIm9mZiIsIjAiLCIwIiwiMCIsIm9mZiIsIjAiLCJvZmYiLCJ0cnVlIiwiZG93biIsIjg5IiwiYXQgdGFyZ2V0cyIsIjE4MCIsImN1c3RvbSBkZXN5bmMiLCIwIiwiLTMyIiwiMjciLCIxIiwiMSIsIjAiLCIwIiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsImFsd2F5cyBvbiIsInRydWUiLCJkb3duIiwiMCIsImF0IHRhcmdldHMiLCIxODAiLCJ0aWNrIiwiMCIsIjAiLCIwIiwiMTAiLCI1IiwiLTMwIiwiNjAiLCJqaXR0ZXIiLCJvZmYiLCJvZmYiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwib2ZmIiwidHJ1ZSIsIm1pbmltYWwiLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsImN1c3RvbSBkZXN5bmMiLCIwIiwiLTIzIiwiMzAiLCIxIiwiMSIsIjAiLCIwIiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsImFsd2F5cyBvbiIsInRydWUiLCJtaW5pbWFsIiwiMCIsImF0IHRhcmdldHMiLCIxODAiLCJjdXN0b20gZGVzeW5jIiwiMCIsIi0xOSIsIjM2IiwiMSIsIjEiLCIwIiwiMCIsIm9mZiIsIm9mZiIsIm9mZiIsIjAiLCIwIiwiMCIsIm9mZiIsIjAiLCJvZmYiLCJ0cnVlIiwiZG93biIsIjAiLCJhdCB0YXJnZXRzIiwiMTgwIiwiY3VzdG9tIGRlc3luYyIsIjAiLCItMzAiLCI0MCIsIjEiLCIxIiwiMCIsIjAiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwib2ZmIiwidHJ1ZSIsIm1pbmltYWwiLCIwIiwiYXQgdGFyZ2V0cyIsIjE4MCIsImN1c3RvbSBkZXN5bmMiLCIwIiwiLTQxIiwiMzQiLCIxIiwiMSIsIjAiLCIwIiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsIm9mZiIsInRydWUiLCJtaW5pbWFsIiwiMCIsImF0IHRhcmdldHMiLCIxODAiLCJzdGF0aWMiLCI0IiwiMCIsIjAiLCIxIiwiMSIsIjAiLCIwIiwib2ZmIiwib2ZmIiwiY2VudGVyIiwiNjEiLCIwIiwiMCIsImppdHRlciIsIjAiLCJvZmYiXSx7fSx7fV0="
elseif ui.get(prophesy.menu.antiaim_list) == "unmatched" then
    preset_data = "W1siY3VzdG9tIiwiODkiLCJhdCB0YXJnZXRzIiwiMTgwIiwiY3VzdG9tIGRlc3luYyIsIjAiLCItMjAiLCIyMCIsIjEiLCIxIiwiMCIsIjAiLCJvZmYiLCJvZmYiLCJsZWZ0IF4gcmlnaHQgY2VudGVyIiwiMCIsIi0xMCIsIjEwIiwib2ZmIiwiMCIsInN3aXRjaCBjeWNsZSIsInRydWUiLCJjdXN0b20iLCI4OSIsImF0IHRhcmdldHMiLCIxODAiLCJhbnRpLWJyZWFrIiwiMCIsIjAiLCIwIiwiNiIsIjEiLCItMjQiLCIyNCIsIm9mZiIsIm9mZiIsIm9mZiIsIjAiLCItMTAiLCIxMCIsIm9mZiIsIjAiLCJvZmYiLCJ0cnVlIiwiY3VzdG9tIiwiODkiLCJhdCB0YXJnZXRzIiwiMTgwIiwiY3VzdG9tIGRlc3luYyIsIjAiLCItMjQiLCIyNCIsIjMiLCIxIiwiLTE1IiwiMTUiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiLTE1IiwiMTUiLCJvZmYiLCIwIiwib2ZmIiwidHJ1ZSIsImN1c3RvbSIsIjg5IiwiYXQgdGFyZ2V0cyIsIjE4MCIsImN1c3RvbSBkZXN5bmMiLCIwIiwiLTIwIiwiMjAiLCIxIiwiMSIsIjAiLCIwIiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIi0xMCIsIjEwIiwib2ZmIiwiMCIsIm9mZiIsInRydWUiLCJjdXN0b20iLCI4OSIsImF0IHRhcmdldHMiLCIxODAiLCJjdXN0b20gZGVzeW5jIiwiMCIsIi0zMSIsIjMxIiwiMiIsIjEiLCItMzAiLCIzMCIsIm9mZiIsIm9mZiIsIm9mZiIsIjAiLCItMTciLCIxNyIsIm9mZiIsIjAiLCJzd2l0Y2ggY3ljbGUiLCJ0cnVlIiwiY3VzdG9tIiwiODkiLCJhdCB0YXJnZXRzIiwiMTgwIiwiY3VzdG9tIGRlc3luYyIsIjAiLCItMjkiLCIyOSIsIjEiLCIxIiwiLTIyIiwiMjIiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiLTE1IiwiMTUiLCJvZmYiLCIwIiwic3dpdGNoIGN5Y2xlIiwidHJ1ZSIsImN1c3RvbSIsIjg5IiwiYXQgdGFyZ2V0cyIsIjE4MCIsImN1c3RvbSBkZXN5bmMiLCIwIiwiNDAiLCItMTYiLCIxIiwiMSIsIjAiLCIwIiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIjAiLCIwIiwib2ZmIiwiMCIsIm9mZiIsInRydWUiLCJjdXN0b20iLCI4OSIsImF0IHRhcmdldHMiLCIxODAiLCJhbnRpLWJyZWFrIiwiMCIsIjAiLCIwIiwiMSIsIjEiLCItMTciLCIxNyIsIm9mZiIsIm9mZiIsImxlZnQgXiByaWdodCBjZW50ZXIiLCIwIiwiLTE5IiwiMTkiLCJvZmYiLCIwIiwic3dpdGNoIGN5Y2xlIiwidHJ1ZSIsImN1c3RvbSIsIjg5IiwiYXQgdGFyZ2V0cyIsIjE4MCIsImFudGktYnJlYWsiLCIwIiwiMCIsIjAiLCIxIiwiMSIsIi0yNiIsIjI2Iiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIi0xMCIsIjEwIiwib2ZmIiwiMCIsIm9mZiIsImN1c3RvbSIsIjg5IiwiYXQgdGFyZ2V0cyIsIjE4MCIsImN1c3RvbSBkZXN5bmMiLCIwIiwiLTIwIiwiMjAiLCIxIiwiMSIsIjAiLCIwIiwib2ZmIiwib2ZmIiwibGVmdCBeIHJpZ2h0IGNlbnRlciIsIjAiLCItMTAiLCIxMCIsIm9mZiIsIjAiLCJvZmYiLCJ0cnVlIiwiY3VzdG9tIiwiODkiLCJhdCB0YXJnZXRzIiwiMTgwIiwiY3VzdG9tIGRlc3luYyIsIjAiLCIzMCIsIi0zMCIsIjYiLCIxIiwiLTI0IiwiMjQiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiLTEwIiwiMTAiLCJvZmYiLCIwIiwib2ZmIiwidHJ1ZSIsImN1c3RvbSIsIjg5IiwiYXQgdGFyZ2V0cyIsIjE4MCIsImN1c3RvbSBkZXN5bmMiLCIwIiwiLTI0IiwiMjQiLCIzIiwiMSIsIi0xNSIsIjE1Iiwib2ZmIiwib2ZmIiwib2ZmIiwiMCIsIi0xNSIsIjE1Iiwib2ZmIiwiMCIsIm9mZiIsInRydWUiLCJjdXN0b20iLCI4OSIsImF0IHRhcmdldHMiLCIxODAiLCJjdXN0b20gZGVzeW5jIiwiMCIsIi0yMCIsIjIwIiwiMSIsIjEiLCIwIiwiMCIsIm9mZiIsIm9mZiIsIm9mZiIsIjAiLCItMTAiLCIxMCIsIm9mZiIsIjAiLCJhbHdheXMgb24iLCJ0cnVlIiwiY3VzdG9tIiwiODkiLCJhdCB0YXJnZXRzIiwiMTgwIiwiYW50aS1icmVhayIsIjAiLCIzNiIsIi0yOSIsIjgiLCIxIiwiMzYiLCItMjkiLCJvZmYiLCJvZmYiLCJvZmZzZXQiLCIxIiwiLTE3IiwiMTciLCJvZmYiLCIwIiwiYWx3YXlzIG9uIiwidHJ1ZSIsImN1c3RvbSIsIjg5IiwiYXQgdGFyZ2V0cyIsIjE4MCIsInRpY2siLCIwIiwiLTI5IiwiMjkiLCI1IiwiNiIsIjM5IiwiLTE2Iiwib2ZmIiwib2ZmIiwib2ZmIiwiMyIsIjMiLCItMyIsIm9mZiIsIjAiLCJhbHdheXMgb24iLCJ0cnVlIiwiY3VzdG9tIiwiODkiLCJhdCB0YXJnZXRzIiwiMTgwIiwiY3VzdG9tIGRlc3luYyIsIjAiLCI0MCIsIi0xNiIsIjEiLCIxIiwiMCIsIjAiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiMCIsIjAiLCJvZmYiLCIwIiwib2ZmIiwidHJ1ZSIsImN1c3RvbSIsIjg5IiwiYXQgdGFyZ2V0cyIsIjE4MCIsImFudGktYnJlYWsiLCIwIiwiMCIsIjAiLCIxIiwiMSIsIi0xNyIsIjE3Iiwib2ZmIiwib2ZmIiwibGVmdCBeIHJpZ2h0IGNlbnRlciIsIjAiLCItMTkiLCIxOSIsIm9mZiIsIjAiLCJhbHdheXMgb24iLCJ0cnVlIiwiY3VzdG9tIiwiODkiLCJhdCB0YXJnZXRzIiwiMTgwIiwiYW50aS1icmVhayIsIjAiLCIwIiwiMCIsIjEiLCIxIiwiLTI2IiwiMjYiLCJvZmYiLCJvZmYiLCJvZmYiLCIwIiwiLTEwIiwiMTAiLCJvZmYiLCIwIiwib2ZmIl0se30se31d"
end
end)

local load_preset = ui.new_button("AA", "Anti-aimbot angles", "load preset", function ()
    local protected = function() 
        for k, v in pairs(json.parse(base64.decode(preset_data))) do
            
            k = ({[1] = "anti_aim", [2] = "keybindsandothertable", [3] = "other_aa"})[k]

            for k2, v2 in pairs(v) do
                if (k == "anti_aim") then
                    if v2 == "true" then
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], false)
                    else
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], v2)
                    end
                end
                if (k == "keybindsandothertable") then
                    ui.set(prophesy.table.config_data.cfg_data[k][k2], framework.library["=>"].func.str_to_sub(v2, ","))
                end
                if (k == "other_aa") then
                    if v2 == "true" then
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], false)
                    else
                        ui.set(prophesy.table.config_data.cfg_data[k][k2], v2)
                    end
                end
            end
        end
    end
    local status, message = pcall(protected)
    if not status then
        error("we get error on loading preset")
        return
    end
end);

rgba_to_hex = function(b,c,d,e)
    return string.format('%02x%02x%02x%02x',b,c,d,e)
end
text_fade_animation = function(speed, r, g, b, a, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i=0, #text do
        local color = rgba_to_hex(r, g, b, a*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)))
        final_text = final_text..'\a'..color..text:sub(i, i)
    end
    return final_text
end

client.set_event_callback( "paint_ui", function(  )
    --print(tostring(ui.get(prophesy.menu.antiaim_elements_t[1].enable)) .." "..tostring(ui.get(prophesy.menu.antiaim_elements_ct[1].enable)))
    setup_skeet_element("vis", nil, nil, "load")
    setup_skeet_element("vis_elem", export_config, ui.get(prophesy.menu.tab_selector) == "config", nil)
    setup_skeet_element("vis_elem", import_config, ui.get(prophesy.menu.tab_selector) == "config", nil)
    setup_skeet_element("vis_elem", load_preset, ui.get(prophesy.menu.tab_selector) == "welcome", nil)
    local r,g,b = ui.get(prophesy.menu.color_picker)
    if ui.is_menu_open() then
        ui.set(prophesy.menu.tab_label, "prophesy \a989898FF- " .. text_fade_animation(8, r,g,b, 255, "anti-aim technology"))
    end
    local anti_aim_tab = ui.get(prophesy.menu.tab_selector) == "anti-aim"
    local misc_tab = ui.get(prophesy.menu.tab_selector) == "misc"
    local visuals_tab = ui.get(prophesy.menu.tab_selector) == "visuals"
    local main_tab = ui.get(prophesy.menu.tab_selector) == "welcome"
    local yaw_addons_enabled = ui.get(prophesy.menu.antiaim_enable_addons)
    for i = 1,#prophesy.menu.builder_state do
        local selecte = ui.get(prophesy.menu.aabuilder_state)
        local team_selected = ui.get(prophesy.menu.team_site)
        local conditions_enabled_ct = ui.get(prophesy.menu.antiaim_elements_ct[i].enable)
        local conditions_enabled_t = ui.get(prophesy.menu.antiaim_elements_t[i].enable)
        local show_ct = anti_aim_tab and selecte == prophesy.menu.builder_state[i] and conditions_enabled_ct and team_selected == "counter"
        local show_t = anti_aim_tab and selecte == prophesy.menu.builder_state[i] and conditions_enabled_t and team_selected == "terror"
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].enable, anti_aim_tab and selecte == prophesy.menu.builder_state[i] and i > 1 and team_selected == "counter")
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider, show_ct and (ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "offset" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "center" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "random" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "skitter"))
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider_r, show_ct and (ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "left ^ right offset" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "left ^ right center" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "left ^ right random" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "left ^ right skitter"))
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider_l, show_ct and (ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "left ^ right offset" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "left ^ right center" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "left ^ right random" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "left ^ right skitter"))

        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "static")
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_left, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "custom desync")
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_right, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "custom desync")
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_tick, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw) ~= "off" and (ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "tick" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "break" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "anti-break" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "sync"))
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_delay, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw) ~= "off" and (ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "tick"))
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_left, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw) ~= "off" and (ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "tick" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "break" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "anti-break" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "sync"))
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_right, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw) ~= "off" and (ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "tick" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "break" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "anti-break" or ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "sync"))
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_pitch, show_ct)
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_pitch_slider, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_pitch) == "custom")
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_base, show_ct)
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw, show_ct)
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw) ~= "off")
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_jitter, show_ct)
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_body_yaw, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) ~= "custom desync" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) ~= "tick" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) ~= "break" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) ~= "anti-break" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) ~= "sync")
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_body_yaw_slider, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) ~= "custom desync" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_body_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) ~= "tick" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) ~= "break" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) ~= "anti-break" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) ~= "sync")
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].send_to_t, show_ct)
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_defensive, show_ct and selecte ~= "fake lag")
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_body_yaw_adv_left, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "tick")
        ui.set_visible(prophesy.menu.antiaim_elements_ct[i].antiaim_body_yaw_adv_right, show_ct and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "tick")

        --TT
        
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].enable, anti_aim_tab and selecte == prophesy.menu.builder_state[i] and i > 1 and team_selected == "terror")
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider, show_t and (ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "offset" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "center" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "random" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "skitter"))
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider_r, show_t and (ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "left ^ right offset" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "left ^ right center" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "left ^ right random" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "left ^ right skitter"))
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider_l, show_t and (ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "left ^ right offset" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "left ^ right center" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "left ^ right random" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "left ^ right skitter"))
        
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "static")
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_left, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "custom desync")
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_right, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "custom desync")
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_tick, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw) ~= "off" and (ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "tick" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "break" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "anti-break" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "sync"))
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_delay, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw) ~= "off" and (ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "tick"))
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_left, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw) ~= "off" and (ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "tick" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "break" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "anti-break" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "sync"))
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_right, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw) ~= "off" and (ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "tick" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "break" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "anti-break" or ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "sync"))
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_pitch, show_t)
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_pitch_slider, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_pitch) == "custom")
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_base, show_t)
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw, show_t)
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw) ~= "off")
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_jitter, show_t)
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_defensive, show_t and selecte ~= "fake lag")
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_body_yaw, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) ~= "custom desync" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) ~= "tick" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) ~= "break" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) ~= "anti-break" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) ~= "sync") 
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_body_yaw_slider, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) ~= "custom desync" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_body_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) ~= "tick" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) ~= "break" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) ~= "anti-break" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) ~= "sync")
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].send_to_ct, show_t)
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_body_yaw_adv_left, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "tick")
        ui.set_visible(prophesy.menu.antiaim_elements_t[i].antiaim_body_yaw_adv_right, show_t and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw) ~= "off" and ui.get(prophesy.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "tick")
    end
    ui.set_visible(prophesy.menu.antiaim_anti_knife, misc_tab)
    ui.set_visible(prophesy.menu.antiaim_legit_aa, misc_tab)
    ui.set_visible(prophesy.menu.antiaim_quickpeek, misc_tab)
    ui.set_visible(prophesy.menu.antiaim_enable_resolver, misc_tab)
    ui.set_visible(prophesy.menu.antiaim_enable_resolver_combo, misc_tab and ui.get(prophesy.menu.antiaim_enable_resolver))
    ui.set_visible(prophesy.menu.antiaim_quickpeek_addons, misc_tab and ui.get(prophesy.menu.antiaim_quickpeek))
    ui.set_visible(prophesy.menu.antiaim_quickpeek_addons_second, misc_tab and ui.get(prophesy.menu.antiaim_quickpeek) and ui.get(prophesy.menu.antiaim_quickpeek_addons) == "static")
    ui.set_visible(prophesy.menu.antiaim_quickpeek_addons_third, misc_tab and ui.get(prophesy.menu.antiaim_quickpeek))
    ui.set_visible(prophesy.menu.indicators, visuals_tab)
    ui.set_visible(prophesy.menu.antiaim_button, main_tab)
    ui.set_visible(prophesy.menu.antiaim_list, main_tab)
    ui.set_visible(prophesy.menu.antiaim_combo, main_tab)
    ui.set_visible(prophesy.menu.antiaim_discord, main_tab) 
    ui.set_visible(prophesy.menu.team_site, anti_aim_tab)
    ui.set_visible(prophesy.menu.aabuilder_state, anti_aim_tab)
    ui.set_visible(prophesy.menu.antiaim_enable_addons, misc_tab)
    ui.set_visible(prophesy.menu.antiaim_manual_left, misc_tab and yaw_addons_enabled)
    ui.set_visible(prophesy.menu.antiaim_manual_right, misc_tab and yaw_addons_enabled)
    ui.set_visible(prophesy.menu.antiaim_manual_forward, misc_tab and yaw_addons_enabled)
    ui.set_visible(prophesy.menu.antiaim_freestanding, misc_tab and yaw_addons_enabled)
    ui.set_visible(prophesy.menu.antiaim_defensive_exploit, misc_tab)
    ui.set_visible(prophesy.menu.antiaim_safeknife, misc_tab)
    ui.set_visible(prophesy.menu.antiaim_animation, misc_tab)
    ui.set_visible(prophesy.menu.antiaim_animation_ground, misc_tab and ui.get(prophesy.menu.antiaim_animation))
    ui.set_visible(prophesy.menu.antiaim_animation_air, misc_tab and ui.get(prophesy.menu.antiaim_animation))
    ui.set_visible(prophesy.menu.antiaim_animation_extra, misc_tab and ui.get(prophesy.menu.antiaim_animation))
    ui.set_visible(prophesy.menu.antiaim_safeknife_options, misc_tab and ui.get(prophesy.menu.antiaim_safeknife))
    ui.set_visible(prophesy.menu.antiaim_defensive_type, misc_tab and ui.get(prophesy.menu.antiaim_defensive_exploit))
    ui.set_visible(prophesy.menu.antiaim_defensive_pitch, misc_tab and ui.get(prophesy.menu.antiaim_defensive_type) == "custom" and ui.get(prophesy.menu.antiaim_defensive_exploit))
    ui.set_visible(prophesy.menu.antiaim_defensive_pitch_slider, misc_tab and ui.get(prophesy.menu.antiaim_defensive_type) == "custom" and ui.get(prophesy.menu.antiaim_defensive_exploit) and ui.get(prophesy.menu.antiaim_defensive_pitch) == "custom")
    ui.set_visible(prophesy.menu.antiaim_defensive_yaw, misc_tab and ui.get(prophesy.menu.antiaim_defensive_type) == "custom" and ui.get(prophesy.menu.antiaim_defensive_exploit))
    ui.set_visible(prophesy.menu.antiaim_defensive_offset, misc_tab and ui.get(prophesy.menu.antiaim_defensive_type) == "custom" and ui.get(prophesy.menu.antiaim_defensive_exploit))
    ui.set_visible(prophesy.menu.antiaim_defensive_byaw, misc_tab and ui.get(prophesy.menu.antiaim_defensive_type) == "custom" and ui.get(prophesy.menu.antiaim_defensive_exploit) )
    ui.set_visible(prophesy.menu.antiaim_defensive_boffset, misc_tab and ui.get(prophesy.menu.antiaim_defensive_type) == "custom" and ui.get(prophesy.menu.antiaim_defensive_exploit))
    ui.set_visible(prophesy.menu.indicators2, visuals_tab)
    ui.set_visible(prophesy.menu.indicators5, visuals_tab)
end)

setup_skeet_element("elem", prophesy.reference.anti_aim.master, true, nil)
setup_skeet_element("elem", prophesy.menu.antiaim_elements_ct[1].enable, true, nil)
setup_skeet_element("elem", prophesy.menu.antiaim_elements_t[1].enable, true, nil)
setup_skeet_element("vis_elem", prophesy.menu.antiaim_elements_ct[1].enable, false, nil)
setup_skeet_element("vis_elem", prophesy.menu.antiaim_elements_t[1].enable, false, nil)

--#endregion Visible

--#region Events

manipulation_tick = function(a, b, time, delay)
    local tick = globals.tickcount()
    local period = delay + time
    
    if tick % period < time then
        return a
    else
        return b
    end
end;

manipulation_break = function(a, b, time)
    return (time / 2 <= (globals.tickcount() % time)) and a or b --print
end;

get_body_yaw = function(player)
	return entity.get_prop(player, "m_flPoseParameter", 11) * 120 - 60
end

get_anti_aimbuilder_state = function ()
    local state = "" --local
    local lp = entity.get_local_player()
    local vel1, vel2, vel3 = entity.get_prop(lp, 'm_vecVelocity')
    local velocity = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))
    local on_ground = bit.band(entity.get_prop(lp, "m_fFlags"), 1) == 1
    local not_moving = velocity < 2
    local slowwalk_key = ui.get(prophesy.reference.other.slow_motion[2])
    local teamnum = entity.get_prop(lp, 'm_iTeamNum')
    local vec_velocity = { entity.get_prop(lp, 'm_vecVelocity') }
    local teamnum = entity.get_prop(lp, 'm_iTeamNum') 
    local duck_amount = entity.get_prop(lp, 'm_flDuckAmount')
    local velocity = math.floor(math.sqrt(vec_velocity[1] ^ 2 + vec_velocity[2] ^ 2) + 0.5)
    local air = bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 0
    if air == false then
        prophesy.anti_aim.ground_time = prophesy.anti_aim.ground_time + 1
    else
        prophesy.anti_aim.ground_time = 0
    end
    if not ui.get(prophesy.reference.other.bunny_hop) then
        on_ground = bit.band(entity.get_prop(lp, "m_fFlags"), 1) == 1
    end

    if not ui.get(prophesy.reference.other.double_tap[2]) and not ui.get(prophesy.reference.other.hide_shots[2]) then
        state = 'fake lag'
    elseif prophesy.anti_aim.ground_time < 8 and duck_amount > 0 then
        state = 'air duck'
    elseif prophesy.anti_aim.ground_time < 8 then
        state = 'in air'
    elseif duck_amount > 0 and velocity <= 2 then
        state = 'duck'
    elseif duck_amount > 0 and velocity >= 2 then
        state = 'move duck'
    elseif ui.get(prophesy.reference.other.fakeducking)then 
        state = 'duck'
    elseif not_moving then   
        state = 'stand'
    elseif not not_moving then
        if slowwalk_key then
        state = 'slow'
    else
        state = 'run'
        end
    end
    return state
end

local native_GetClientEntity = vtable_bind("client.dll", "VClientEntityList003", 3, "uintptr_t(__thiscall*)(void*, int)");

do_defensive = function ()
    local player = entity.get_local_player( )

    if player == nil then
        return
    end

    local ptr = native_GetClientEntity(player);

    local m_flSimulationTime = entity.get_prop(player, "m_flSimulationTime");
    local m_flOldSimulationTime = ffi.cast("float*", ptr + 0x26C)[0];

    if (m_flSimulationTime - m_flOldSimulationTime < 0) then
        prophesy.anti_aim.defensive_ticks = globals.tickcount() + toticks(.200);
    end
end

client.set_event_callback( "net_update_start", function(  )
    do_defensive()
end)

client.set_event_callback( "setup_command", function( arg )
    if not entity.get_local_player( ) then
        return
    end
    if globals.tickcount() - prophesy.anti_aim.tick_var > 0 and arg.chokedcommands == 1 then
        prophesy.anti_aim.is_invert = not prophesy.anti_aim.is_invert
        prophesy.anti_aim.tick_var = globals.tickcount()
    elseif globals.tickcount() - prophesy.anti_aim.tick_var < -1 then
        prophesy.anti_aim.tick_var = globals.tickcount()
    end
    local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = body_yaw > 0 and 1 or -1
    local m_flSimulationTime = entity.get_prop(player, "m_flSimulationTime");
    prophesy.anti_aim.cur_team = entity.get_prop(entity.get_local_player(), "m_iTeamNum") -- 2 TT 3 CT
    prophesy.anti_aim.state_id = ui.get(prophesy.anti_aim.cur_team == 3 and prophesy.menu.antiaim_elements_ct[prophesy.menu.state_to_num[get_anti_aimbuilder_state()] ].enable or prophesy.menu.antiaim_elements_t[prophesy.menu.state_to_num[get_anti_aimbuilder_state()] ].enable) and prophesy.menu.state_to_num[get_anti_aimbuilder_state()] or prophesy.menu.state_to_num['global'];
    if prophesy.anti_aim.cur_team == 2 then
        prophesy.anti_aim.pitch = ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_pitch)
        prophesy.anti_aim.pitch_value = ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_pitch_slider)
        prophesy.anti_aim.yaw_base = ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_base)
        prophesy.anti_aim.yaw = ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw)
        if ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "static" then
            prophesy.anti_aim.yaw_value = ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "custom desync" then
            prophesy.anti_aim.yaw_value = prophesy.anti_aim.is_invert and ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_left) or ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_right)
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "tick" then
            prophesy.anti_aim.yaw_value = manipulation_tick(ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_left), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_right), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_delay), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "break" then
            prophesy.anti_aim.yaw_value = manipulation_break(ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_left), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_right), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "anti-break" then
            prophesy.anti_aim.yaw_value = manipulation_break(ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_left), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_right), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "sync" then
            prophesy.anti_aim.yaw_value = manipulation_break(ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_left), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_right), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        end

        if ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "off" then
            prophesy.anti_aim.yaw_jitter = "off"
            prophesy.anti_aim.yaw_jitter_value = 0
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "offset" then
            prophesy.anti_aim.yaw_jitter = "offset"
            prophesy.anti_aim.yaw_jitter_value = ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "center" then
            prophesy.anti_aim.yaw_jitter = "center"
            prophesy.anti_aim.yaw_jitter_value = ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "random" then
            prophesy.anti_aim.yaw_jitter = "random"
            prophesy.anti_aim.yaw_jitter_value = ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "skitter" then
            prophesy.anti_aim.yaw_jitter = "skitter"
            prophesy.anti_aim.yaw_jitter_value = ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "left ^ right offset" then
            prophesy.anti_aim.yaw_jitter = "offset"
            prophesy.anti_aim.yaw_jitter_value = prophesy.anti_aim.is_invert and ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_l) or ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "left ^ right center" then
            prophesy.anti_aim.yaw_jitter = "center"
            prophesy.anti_aim.yaw_jitter_value = prophesy.anti_aim.is_invert and ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_l) or ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "left ^ right random" then
            prophesy.anti_aim.yaw_jitter = "random"
            prophesy.anti_aim.yaw_jitter_value = prophesy.anti_aim.is_invert and ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_l) or ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "left ^ right skitter" then
            prophesy.anti_aim.yaw_jitter = "skitter"
            prophesy.anti_aim.yaw_jitter_value = prophesy.anti_aim.is_invert and ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_l) or ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
        end

        if ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "static" then
            prophesy.anti_aim.body_yaw = ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_body_yaw)
            prophesy.anti_aim.body_yaw_value = ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_body_yaw_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "custom desync" then
            prophesy.anti_aim.body_yaw = "static"
            prophesy.anti_aim.body_yaw_value = 0
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "tick" then
            prophesy.anti_aim.body_yaw = manipulation_tick(ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_body_yaw_adv_left), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_body_yaw_adv_right), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_delay), ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
            prophesy.anti_aim.body_yaw_value = 0
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "break" then
            prophesy.anti_aim.body_yaw = "static"
            prophesy.anti_aim.body_yaw_value = 0
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "anti-break" then
            prophesy.anti_aim.body_yaw = "off"
            prophesy.anti_aim.body_yaw_value = 0
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "sync" then
            prophesy.anti_aim.body_yaw = "static"
            prophesy.anti_aim.body_yaw_value = manipulation_break(-120, 120, ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        end
        if ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_defensive) == "always on" then
            prophesy.anti_aim.defensive_t = true
            prophesy.anti_aim.is_active_inds = true
        elseif ui.get(prophesy.menu.antiaim_elements_t[prophesy.anti_aim.state_id].antiaim_defensive) == "switch cycle" then
            prophesy.anti_aim.is_active_inds = true
            if globals.tickcount() % 2 == 1 then
                prophesy.anti_aim.is_active_inds = true
            else
                prophesy.anti_aim.defensive_t = false
            end
        else 
            prophesy.anti_aim.defensive_t = false
            prophesy.anti_aim.is_active_inds = false
        end
        arg.force_defensive = prophesy.anti_aim.defensive_t;
        --print('tt')
    elseif prophesy.anti_aim.cur_team == 3 then
        prophesy.anti_aim.pitch = ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_pitch)
        prophesy.anti_aim.pitch_value = ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_pitch_slider)
        prophesy.anti_aim.yaw_base = ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_base)
        prophesy.anti_aim.yaw = ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw)
        if ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "static" then
            prophesy.anti_aim.yaw_value = ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "custom desync" then
            prophesy.anti_aim.yaw_value = prophesy.anti_aim.is_invert and ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_left) or ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_right)
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "tick" then
            prophesy.anti_aim.yaw_value = manipulation_tick(ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_left), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_right), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_delay), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "break" then
            prophesy.anti_aim.yaw_value = manipulation_break(ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_left), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_right), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "anti-break" then
            prophesy.anti_aim.yaw_value = manipulation_break(ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_left), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_right), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "sync" then
            prophesy.anti_aim.yaw_value = manipulation_break(ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_left), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_right), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        end

        if ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "off" then
            prophesy.anti_aim.yaw_jitter = "off"
            prophesy.anti_aim.yaw_jitter_value = 0
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "offset" then
            prophesy.anti_aim.yaw_jitter = "offset"
            prophesy.anti_aim.yaw_jitter_value = ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "center" then
            prophesy.anti_aim.yaw_jitter = "center"
            prophesy.anti_aim.yaw_jitter_value = ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "random" then
            prophesy.anti_aim.yaw_jitter = "random"
            prophesy.anti_aim.yaw_jitter_value = ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "skitter" then
            prophesy.anti_aim.yaw_jitter = "skitter"
            prophesy.anti_aim.yaw_jitter_value = ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "left ^ right offset" then
            prophesy.anti_aim.yaw_jitter = "offset"
            prophesy.anti_aim.yaw_jitter_value = prophesy.anti_aim.is_invert and ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_l) or ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "left ^ right center" then
            prophesy.anti_aim.yaw_jitter = "center"
            prophesy.anti_aim.yaw_jitter_value = prophesy.anti_aim.is_invert and ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_l) or ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "left ^ right random" then
            prophesy.anti_aim.yaw_jitter = "random"
            prophesy.anti_aim.yaw_jitter_value = prophesy.anti_aim.is_invert and ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_l) or ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter) == "left ^ right skitter" then
            prophesy.anti_aim.yaw_jitter = "skitter"
            prophesy.anti_aim.yaw_jitter_value = prophesy.anti_aim.is_invert and ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_l) or ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
        end

        if ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "static" then
            prophesy.anti_aim.body_yaw = ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_body_yaw)
            prophesy.anti_aim.body_yaw_value = ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_body_yaw_slider)
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "custom desync" then
            prophesy.anti_aim.body_yaw = "static"
            prophesy.anti_aim.body_yaw_value = 0
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "tick" then
            prophesy.anti_aim.body_yaw = manipulation_tick(ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_body_yaw_adv_left), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_body_yaw_adv_right), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_delay), ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
            prophesy.anti_aim.body_yaw_value = 0
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "break" then
            prophesy.anti_aim.body_yaw = "static"
            prophesy.anti_aim.body_yaw_value = 0
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "anti-break" then
            prophesy.anti_aim.body_yaw = "off"
            prophesy.anti_aim.body_yaw_value = 0
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_advanced) == "sync" then
            prophesy.anti_aim.body_yaw = "static"
            prophesy.anti_aim.body_yaw_value = manipulation_break(-120, 120, ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        end
        if ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_defensive) == "always on" then
            prophesy.anti_aim.defensive_ct = true
            prophesy.anti_aim.is_active_inds = true
        elseif ui.get(prophesy.menu.antiaim_elements_ct[prophesy.anti_aim.state_id].antiaim_defensive) == "switch cycle" then
            prophesy.anti_aim.is_active_inds = true
            if globals.tickcount() % 2 == 1 then
                prophesy.anti_aim.defensive_ct = true
            else
                prophesy.anti_aim.defensive_ct = false
            end
        else
            prophesy.anti_aim.defensive_ct = false
            prophesy.anti_aim.is_active_inds = false
        end
        --print('ct')
        arg.force_defensive = prophesy.anti_aim.defensive_ct;
    end

    prophesy.anti_aim.defensive = prophesy.anti_aim.defensive_ticks > globals.tickcount()
    if prophesy.anti_aim.defensive then
        prophesy.anti_aim.is_active = true
    else
        prophesy.anti_aim.is_active = false
    end

    if prophesy.anti_aim.is_active and ui.get(prophesy.reference.other.double_tap[2]) and ui.get(prophesy.menu.antiaim_defensive_type) == "meta" and ui.get(prophesy.menu.antiaim_defensive_exploit) and not quick_peek_addons == true then
        prophesy.anti_aim.pitch = "Custom"
        prophesy.anti_aim.pitch_value = -45
        prophesy.anti_aim.yaw = "spin"
        prophesy.anti_aim.yaw_value = 70
        prophesy.anti_aim.body_yaw = "opposite"
        prophesy.anti_aim.body_yaw_value = 48
    end

    if prophesy.anti_aim.is_active and ui.get(prophesy.reference.other.double_tap[2]) and ui.get(prophesy.menu.antiaim_defensive_type) == "custom" and ui.get(prophesy.menu.antiaim_defensive_exploit) and not quick_peek_addons == true then
        prophesy.anti_aim.pitch = ui.get(prophesy.menu.antiaim_defensive_pitch)
        prophesy.anti_aim.pitch_value = ui.get(prophesy.menu.antiaim_defensive_pitch_slider)
        prophesy.anti_aim.yaw = ui.get(prophesy.menu.antiaim_defensive_yaw)
        prophesy.anti_aim.yaw_value = ui.get(prophesy.menu.antiaim_defensive_offset)
        prophesy.anti_aim.body_yaw = ui.get(prophesy.menu.antiaim_defensive_byaw)
        prophesy.anti_aim.body_yaw_value = ui.get(prophesy.menu.antiaim_defensive_boffset)
    end

    if ui.get(prophesy.reference.other.auto_peek[2]) and ui.get(prophesy.menu.antiaim_quickpeek) then
        prophesy.anti_aim.yaw_value = 0
        prophesy.anti_aim.yaw_base = "At Targets"
        prophesy.anti_aim.yaw_jitter = "Off"
        prophesy.anti_aim.yaw_jitter_value = 0
        prophesy.anti_aim.body_yaw = ui.get(prophesy.menu.antiaim_quickpeek_addons)
        if ui.get(prophesy.menu.antiaim_quickpeek_addons_second) == "none" and ui.get(prophesy.menu.antiaim_quickpeek_addons) == "static" then
        prophesy.anti_aim.body_yaw_value = 0
        elseif ui.get(prophesy.menu.antiaim_quickpeek_addons_second) == "slow" and ui.get(prophesy.menu.antiaim_quickpeek_addons) == "static" then
        prophesy.anti_aim.body_yaw_value = manipulation_break(120, -120, 12)
        elseif ui.get(prophesy.menu.antiaim_quickpeek_addons_second) == "fast" and ui.get(prophesy.menu.antiaim_quickpeek_addons) == "static" then
        prophesy.anti_aim.body_yaw_value = manipulation_break(120, -120, 3)
        else prophesy.anti_aim.body_yaw_value = 0
        end
        if ui.get(prophesy.menu.antiaim_quickpeek_addons_third) == "on" then
        prophesy.anti_aim.is_active_inds = true
        end
        quick_peek_addons = true
    else quick_peek_addons = false
    end

    ui.set(prophesy.menu.antiaim_manual_left, "On hotkey")
	ui.set(prophesy.menu.antiaim_manual_right, "On hotkey")
    ui.set(prophesy.menu.antiaim_manual_forward, "On hotkey")
    if prophesy.anti_aim.last_press + 0.22 < globals.curtime() then
		if prophesy.anti_aim.aa_dir == 0 then
			if ui.get(prophesy.menu.antiaim_manual_left) then
				prophesy.anti_aim.aa_dir = 1
				prophesy.anti_aim.last_press = globals.curtime()
			elseif ui.get(prophesy.menu.antiaim_manual_right) then
				prophesy.anti_aim.aa_dir = 2
				prophesy.anti_aim.last_press = globals.curtime()
			elseif ui.get(prophesy.menu.antiaim_manual_forward) then
				prophesy.anti_aim.aa_dir = 3
				prophesy.anti_aim.last_press = globals.curtime()
			end
		elseif prophesy.anti_aim.aa_dir == 1 then
			if ui.get(prophesy.menu.antiaim_manual_right) then
				prophesy.anti_aim.aa_dir = 2
				prophesy.anti_aim.last_press = globals.curtime()
			elseif ui.get(prophesy.menu.antiaim_manual_forward) then
				prophesy.anti_aim.aa_dir = 3
				prophesy.anti_aim.last_press = globals.curtime()
			elseif ui.get(prophesy.menu.antiaim_manual_left) then
				prophesy.anti_aim.aa_dir = 0
				prophesy.anti_aim.last_press = globals.curtime()
			end
		elseif prophesy.anti_aim.aa_dir == 2 then
			if ui.get(prophesy.menu.antiaim_manual_left) then
				prophesy.anti_aim.aa_dir = 1
				prophesy.anti_aim.last_press = globals.curtime()
			elseif ui.get(prophesy.menu.antiaim_manual_forward) then
				prophesy.anti_aim.aa_dir = 3
				prophesy.anti_aim.last_press = globals.curtime()
			elseif ui.get(prophesy.menu.antiaim_manual_right) then
				prophesy.anti_aim.aa_dir = 0
				prophesy.anti_aim.last_press = globals.curtime()
			end
		elseif prophesy.anti_aim.aa_dir == 3 then
			if ui.get(prophesy.menu.antiaim_manual_forward) then
				prophesy.anti_aim.aa_dir = 0
				prophesy.anti_aim.last_press = globals.curtime()
			elseif ui.get(prophesy.menu.antiaim_manual_left) then
				prophesy.anti_aim.aa_dir = 1
				prophesy.anti_aim.last_press = globals.curtime()
			elseif ui.get(prophesy.menu.antiaim_manual_right) then
				prophesy.anti_aim.aa_dir = 2
				prophesy.anti_aim.last_press = globals.curtime()
			end
		end
	end
	if prophesy.anti_aim.aa_dir == 1 or prophesy.anti_aim.aa_dir == 2 or prophesy.anti_aim.aa_dir == 3 then
		if prophesy.anti_aim.aa_dir == 1 then
            prophesy.anti_aim.yaw_value = -90
            prophesy.anti_aim.yaw = "180"
            prophesy.anti_aim.yaw_base = "At Targets"
            prophesy.anti_aim.yaw_jitter = "Off"
            prophesy.anti_aim.yaw_jitter_value = 0
            prophesy.anti_aim.body_yaw = "Static"
		elseif prophesy.anti_aim.aa_dir == 2 then
			prophesy.anti_aim.yaw_value = 90
            prophesy.anti_aim.yaw = "180"
            prophesy.anti_aim.yaw_base = "At Targets"
            prophesy.anti_aim.yaw_jitter = "Off"
            prophesy.anti_aim.yaw_jitter_value = 0
            prophesy.anti_aim.body_yaw = "Static"
		elseif prophesy.anti_aim.aa_dir == 3 then
			prophesy.anti_aim.yaw_value = 180
            prophesy.anti_aim.yaw = "180"
            prophesy.anti_aim.yaw_base = "At Targets"
            prophesy.anti_aim.yaw_jitter = "Off"
            prophesy.anti_aim.yaw_jitter_value = 0
            prophesy.anti_aim.body_yaw = "Static"
		end
    end

    if ui.get(prophesy.menu.antiaim_legit_aa) then
        if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
            if arg.in_attack == 1 then
                arg.in_attack = 0 
                arg.in_use = 1
            end
        else
            if arg.chokedcommands == 0 then
                arg.in_use = 0
            end
        end
    end
    if ui.get(prophesy.menu.antiaim_safeknife) then
        local lp = entity.get_local_player()
        local weapon = entity.get_player_weapon(lp)
        if table_contains(ui.get(prophesy.menu.antiaim_safeknife_options), "knife") then
        if entity.get_classname(weapon) == "CKnife" then
            prophesy.anti_aim.yaw_value = 4
            prophesy.anti_aim.pitch = "Custom"
            prophesy.anti_aim.yaw = "180"
            prophesy.anti_aim.pitch_value = 89
            prophesy.anti_aim.yaw_jitter = "Offset"
            prophesy.anti_aim.yaw_jitter_value = 3
            prophesy.anti_aim.body_yaw = "Static"
            prophesy.anti_aim.body_yaw_value = 0
        end
        end
        if table_contains(ui.get(prophesy.menu.antiaim_safeknife_options), "zeus") then
        if entity.get_classname(weapon) == "CWeaponTaser" then
            prophesy.anti_aim.yaw_value = 4
            prophesy.anti_aim.pitch = "Custom"
            prophesy.anti_aim.yaw = "180"
            prophesy.anti_aim.pitch_value = 89
            prophesy.anti_aim.yaw_jitter = "Offset"
            prophesy.anti_aim.yaw_jitter_value = 3
            prophesy.anti_aim.body_yaw = "Static"
            prophesy.anti_aim.body_yaw_value = 0
        end
        end
    end
    if ui.get(prophesy.menu.antiaim_anti_knife) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = (math.sqrt((x - lx)^2 + (y - ly)^2 + (z - lz)^2))
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 180 then
                prophesy.anti_aim.yaw_value = 180
                prophesy.anti_aim.pitch = "Off"
                prophesy.anti_aim.yaw_base = "At targets"
            end
        end
    end

    ui.set(prophesy.reference.anti_aim.pitch[1], prophesy.anti_aim.pitch);
    ui.set(prophesy.reference.anti_aim.pitch[2], prophesy.anti_aim.pitch_value);
    ui.set(prophesy.reference.anti_aim.yaw_base, prophesy.anti_aim.yaw_base);
    ui.set(prophesy.reference.anti_aim.yaw[1], prophesy.anti_aim.yaw);
    ui.set(prophesy.reference.anti_aim.yaw[2], prophesy.anti_aim.yaw_value);
    ui.set(prophesy.reference.anti_aim.yaw_jitter[1], prophesy.anti_aim.yaw_jitter);
    ui.set(prophesy.reference.anti_aim.yaw_jitter[2], prophesy.anti_aim.yaw_jitter_value);
    ui.set(prophesy.reference.anti_aim.body_yaw[1], prophesy.anti_aim.body_yaw);
    ui.set(prophesy.reference.anti_aim.body_yaw[2], prophesy.anti_aim.body_yaw_value);
    ui.set(prophesy.reference.anti_aim.freestanding[2], ui.get(prophesy.menu.antiaim_freestanding) and "Always on" or "On hotkey");
    ui.set(prophesy.reference.anti_aim.freestanding[1], ui.get(prophesy.menu.antiaim_freestanding) and true);
    ui.set(prophesy.reference.anti_aim.roll_offset, 0);
end)
client.set_event_callback("shutdown", function ()
    setup_skeet_element("vis", nil, nil, "unload")
end)
http.get(prophesy.table.visuals.picture, function(s, r)
    if s and r.status == 200 then --return
        prophesy.table.visuals.image_loaded = images.load(r.body)
    else
        error("Failed to load: " .. response.status_message)
    end
end)

local screen = {client.screen_size()}
local x_offset, y_offset = screen[1], screen[2]
local x, y = x_offset/2, y_offset/2
info_panel = function()
    if prophesy.table.visuals.image_loaded ~= "" then
    if ui.get(prophesy.menu.indicators2) == "flag" then
    local r,g,b = ui.get(prophesy.menu.color_picker)
    local measure_text = renderer.measure_text("-", "PROPHESY ")
    local username_text = renderer.measure_text("-", "NAME - ")
    renderer.gradient(0, y + 4.6, 130, 20, r,g,b, 255, 50, 50, 50, 5, true)
    prophesy.table.visuals.image_loaded:draw(x - 957, y + 7, 30, 15)
    renderer.text(33, y + 5, 255, 255, 255, 255, '-', nil, "PROPHESY")
    renderer.text(33 + measure_text, y + 5, r,g,b, 255, '-', nil, "LUA")
    renderer.text(33, y + 13, 255, 255, 255, 255, '-', nil, "NAME -")
    renderer.text(33 + username_text, y + 13, r,g,b, 255, '-', nil, string.upper(username))
    end
    end
    if ui.get(prophesy.menu.indicators2) == "text" then
    local r,g,b = ui.get(prophesy.menu.color_picker)
    renderer.text(x, y + 530, r,g,b, 255, 'c', nil, text_fade_animation(8, r,g,b, 255, "P R O P H E S Y"))
    end
    if ui.get(prophesy.menu.indicators2) == "legacy" then
    local r,g,b = ui.get(prophesy.menu.color_picker)
    renderer.text(0, y - 25, 80,80,80, 255, '', nil, "prophesy")
    renderer.text(0, y - 25, 255,255,255, 255, '', nil, text_fade_animation(10, r,g,b, 255, "prophesy"))
    renderer.text(renderer.measure_text("", " prophesy"), y - 25, r,g,b, 255, '', nil, "~ anti-aim system")
    renderer.text(0, y - 15, 180,180,180, 255, '', nil, "user: " .. string.lower(username) .. " [nightly]")
    end
end

defensive_opa = 0
defensive_opa2 = 0
defensive_opa3 = 0
defensive_indicator = function()
        
        X,Y = screen[1], screen[2]
        value2 = 0
        draw_art = prophesy.table.visuals.to_draw_ticks * 50/90 
        if is_active then
            value2 = 0.4
        else value2 = 5 
        end
        
        is_active = prophesy.anti_aim.is_active_inds == true and ui.get(prophesy.reference.other.double_tap[2]) 
        if is_active then
            defensive_opa = script.helpers:clamp(defensive_opa + globals.frametime()/0.4, 0, 1)
            defensive_opa2 = script.helpers:clamp(defensive_opa2 + globals.frametime()/0.15, 0, 1)
            defensive_opa3 =  script.helpers:clamp(defensive_opa2 + globals.frametime()/0.15, 0, 1)
        else
            defensive_opa = script.helpers:clamp(defensive_opa - globals.frametime()/0.25, 0, 1)
            defensive_opa2 = script.helpers:clamp(defensive_opa2 - globals.frametime()/0.25, 0, 1)
            defensive_opa3 = script.helpers:clamp(defensive_opa2 - globals.frametime()/0.25, 0, 1)
        end
       
        if 50 < defensive_opa * 110 then
            maxed = "yes"
        else 
            maxed = "no"
        end

        local maxed_true = maxed == "yes"
    
        local r, g, b = ui.get(prophesy.menu.color_picker)
        local jedi_icon = '<svg t="1650815150236" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1757" width="1000" height="1000"><path d="M398.5 373.6c95.9-122.1 17.2-233.1 17.2-233.1 45.4 85.8-41.4 170.5-41.4 170.5 105-171.5-60.5-271.5-60.5-271.5 96.9 72.7-10.1 190.7-10.1 190.7 85.8 158.4-68.6 230.1-68.6 230.1s-.4-16.9-2.2-85.7c4.3 4.5 34.5 36.2 34.5 36.2l-24.2-47.4 62.6-9.1-62.6-9.1 20.2-55.5-31.4 45.9c-2.2-87.7-7.8-305.1-7.9-306.9v-2.4 1-1 2.4c0 1-5.6 219-7.9 306.9l-31.4-45.9 20.2 55.5-62.6 9.1 62.6 9.1-24.2 47.4 34.5-36.2c-1.8 68.8-2.2 85.7-2.2 85.7s-154.4-71.7-68.6-230.1c0 0-107-118.1-10.1-190.7 0 0-165.5 99.9-60.5 271.5 0 0-86.8-84.8-41.4-170.5 0 0-78.7 111 17.2 233.1 0 0-26.2-16.1-49.4-77.7 0 0 16.9 183.3 222 185.7h4.1c205-2.4 222-185.7 222-185.7-23.6 61.5-49.9 77.7-49.9 77.7z" p-id="1758" fill="#ffffff"></path></svg>'
        local jedi_icon2 = renderer.load_svg(jedi_icon,50,50)
        if table_contains(ui.get(prophesy.menu.indicators), "bar") then
        script.renderer:glow_module(X / 2 - 55, Y / 2 - 220, defensive_opa * 110, 0, 10, 0, {r, g, b, defensive_opa * 100}, {r, g, b, defensive_opa * 100})
        rounded_rectangle(X / 2 - 55, Y / 2 - 220, r, g, b, defensive_opa * 140, defensive_opa * 110, 2, 1)
        end
        charged_mes = renderer.measure_text("", "defensive manager ") + renderer.measure_text("", "ready  ")
        exploit_mes = renderer.measure_text("", "defensive manager ") 
        if table_contains(ui.get(prophesy.menu.indicators), "text") then
        local ret = script.helpers:animate_text(globals.curtime(), "ready", r, g, b, defensive_opa2 * 255)
        renderer.text(X / 2, Y / 2 - 230,255, 255, 255, defensive_opa2 * 255, "c",  defensive_opa2 * charged_mes + 1, "defensive manager ", unpack(ret))
        end
        if table_contains(ui.get(prophesy.menu.indicators), "icon") then
        renderer.texture(jedi_icon2, X/2 - 11, Y/2 - 260, 50, 50, r, g, b, defensive_opa * 220, 'f')
        end
        prophesy.table.visuals.to_draw_ticks = prophesy.table.visuals.to_draw_ticks + 1
        if prophesy.table.visuals.to_draw_ticks == 200 then
            prophesy.table.visuals.to_draw_ticks = 0
        end
    end
client.set_event_callback("paint", function()
    defensive_indicator()
    info_panel()
end)
local ground_ticks = 0
local end_time = 0
client.set_event_callback("pre_render", function()
    if ui.get(prophesy.menu.antiaim_animation) then 
    if not entity.is_alive(entity.get_local_player()) then return end
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1
    local slidewalk_directory = ui.reference("AA", "other", "leg movement")
    if ui.get(prophesy.menu.antiaim_animation_ground) == "moonwalk" and on_ground then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7) 
        ui.set(slidewalk_directory, "Never Slide")
    elseif ui.get(prophesy.menu.antiaim_animation_ground) == "sliding" and on_ground then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0) 
        ui.set(slidewalk_directory, "Always Slide")
    elseif ui.get(prophesy.menu.antiaim_animation_ground) == "break" and on_ground then  
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 8)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 9)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 10)
        ui.set(slidewalk_directory, "Never Slide")
    elseif ui.get(prophesy.menu.antiaim_animation_ground) == "modern" and on_ground then  
        ui.set(slidewalk_directory, client.random_int(1, 2) == 1 and "Off" or "Always slide")
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1 - client.random_float(0.5, 1), 0)
    else ui.set(slidewalk_directory, "Off")
    end
    local self_index = ent.new(entity.get_local_player())
    if bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 0 then
    if ui.get(prophesy.menu.antiaim_animation_air) == "static" then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
    end
    end
    if ui.get(prophesy.menu.antiaim_animation_extra) == "reset pitch" then 
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
    local fakelag = ui.reference("AA", "Fake lag", "Limit")
    if on_ground == 1 then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
        end_time = globals.curtime() + 1
    end 
    if ground_ticks > ui.get(fakelag)+1 and end_time > globals.curtime() then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
    end
end
else return end
end)
client.set_event_callback(
    "pre_render",
    function()
        if not ui.get(prophesy.menu.antiaim_animation) then return end
        if not entity.is_alive(entity.get_local_player()) then
            return
        end
        if ui.get(prophesy.menu.antiaim_animation_air) == "moonwalk" then
            local me = ent.get_local_player()
            local m_fFlags = me:get_prop("m_fFlags")
            local is_onground = bit.band(m_fFlags, 1) ~= 0
            if not is_onground then
                local my_animlayer = me:get_anim_overlay(6)
                my_animlayer.weight = 1
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
            end
        end
    end
)

client.set_event_callback(
    "pre_render",
    function()
        if not ui.get(prophesy.menu.antiaim_animation) then return end
        if not entity.is_alive(entity.get_local_player()) then
            return
        end
        if ui.get(prophesy.menu.antiaim_animation_air) == "running" then
            local me = ent.get_local_player()
            local m_fFlags = me:get_prop("m_fFlags")
            local is_onground = bit.band(m_fFlags, 1) ~= 0
            if not is_onground then
                local my_animlayer = me:get_anim_overlay(6)
                my_animlayer.weight = 1
            end
        end
    end
)

screen = {client.screen_size()}
center = {screen[1]/2, screen[2]/2}
state3, ground_time = 'nil', 0
alpha_pulse = 0
offset_move = 0
alpha_fade = 0
offset_dt = 0
offset_qp = 0
offset_center = 0
offset_state = 0
offset_quickpeek = 0
offset_rapid = 0
offset_center2 = 0
dtopa = 0
qpopa = 0
dtopa2 = 0
dtopa3 = 0 
dtopa4 = 0
dtopa5 = 0
dtopa6 = 0
offset_rapid2 = 0
offset_rapid3 = 0
offset_quickpeek2 = 0
dtopa7 = 0
offset_quickpeek3 = 0
animated = function()
if ui.get(prophesy.menu.indicators5) == "modern" then
local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1
if ui.get (prophesy.reference.other.double_tap[2]) then 
location = 48
else location = 39
end
dted = ui.get(prophesy.reference.other.double_tap[2]) == true
qped = ui.get(prophesy.reference.other.auto_peek[2]) == true  
dtopa = prophesy.table.visuals.animation_variables.movement(dtopa,dted,0,255,12)

if qped and prophesy.anti_aim.defensive == true then
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.12, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.12, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.12, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.12, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.12, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 + globals.frametime()/0.12, 0, 1)
elseif qped and antiaim_funcs.get_double_tap() == true then
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.12, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.12, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.12, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 + globals.frametime()/0.12, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.12, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.12, 0, 1)
elseif qped and antiaim_funcs.get_double_tap() == false then
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.12, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.12, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.12, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.12, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 + globals.frametime()/0.12, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.12, 0, 1)
elseif dted and prophesy.anti_aim.is_active_inds == true then
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.12, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.12, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 + globals.frametime()/0.12, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.12, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.12, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.12, 0, 1)
elseif dted and antiaim_funcs.get_double_tap() == true then
dtopa2 = script.helpers:clamp(dtopa2 + globals.frametime()/0.12, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.12, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.12, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.12, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.12, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.12, 0, 1)
elseif dted and antiaim_funcs.get_double_tap() == false then
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.12, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 + globals.frametime()/0.12, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.12, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.12, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.12, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.12, 0, 1)
else 
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.12, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.12, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.12, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.12, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.12, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.12, 0, 1)
end
if prophesy.anti_aim.is_active_inds == true then 
dt_r, dt_g, dt_b = 155, 255, 155
elseif antiaim_funcs.get_double_tap() == true then
dt_r, dt_g, dt_b = 155, 255, 155
elseif antiaim_funcs.get_double_tap() == false then
dt_r, dt_g, dt_b =  255, 30, 30
end
    
qpopa = prophesy.table.visuals.animation_variables.movement(qpopa,qped,0,255,12)
rapid_mes = renderer.measure_text("", "  dt ready")/2 - 1
rapid_mes2 = renderer.measure_text("", "  dt charging")/2 - 1
rapid_mes3 = renderer.measure_text("", "  dt defensive")/2 - 1
local_player = entity.get_local_player()
if not entity.is_alive(local_player) then return end

blink = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255
blink2 = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 120
r,g,b = ui.get(prophesy.menu.color_picker)
cen_meas = renderer.measure_text("b", "prophesy nightly")/2 - 1
cen_meas3 = renderer.measure_text("b", "prophesy nightly")/2 - 6 
cen_meas2 = renderer.measure_text("b", "prophesy nightly") - 12
build_meas = renderer.measure_text("b", "nightly")
state_mes = renderer.measure_text("", state3)/2 + 1
qp_mes = renderer.measure_text("", "idealtick ready")/2 + 2
qp_mes2 = renderer.measure_text("", "idealtick charging")/2 + 2
qp_mes3 = renderer.measure_text("", "idealtick defensive")/2 + 1
offset_qp = prophesy.table.visuals.animation_variables.movement(offset_qp,qped,30,location,8)
offset_center = prophesy.table.visuals.animation_variables.movement(offset_center,scoped,1,cen_meas,10)
offset_state = prophesy.table.visuals.animation_variables.movement(offset_state,scoped,0,state_mes,8)
offset_quickpeek = prophesy.table.visuals.animation_variables.movement(offset_quickpeek,scoped,0,qp_mes,8)
offset_quickpeek2 = prophesy.table.visuals.animation_variables.movement(offset_quickpeek2,scoped,0,qp_mes2,8)
offset_quickpeek3 = prophesy.table.visuals.animation_variables.movement(offset_quickpeek3,scoped,0,qp_mes3,8)
offset_rapid = prophesy.table.visuals.animation_variables.movement(offset_rapid,scoped,0,rapid_mes,8)
offset_rapid2 = prophesy.table.visuals.animation_variables.movement(offset_rapid2,scoped,0,rapid_mes2,8)
offset_rapid3 = prophesy.table.visuals.animation_variables.movement(offset_rapid3,scoped,0,rapid_mes3,8)
dtcolor = 0
dt_mes = renderer.measure_text("", "dt ")
p_mes = renderer.measure_text("", "idealtick ")
if antiaim_funcs.get_double_tap() == false then
dtcolor = 190
else dtcolor = 255
end
charging_size = renderer.measure_text("", "ready ")
charging_size2 = renderer.measure_text("", "charging ")
charging_size3 = renderer.measure_text("", "defensive ")
charging_size4 = renderer.measure_text("", "ready ")
charging_size5 = renderer.measure_text("", "charging ")
--script.renderer:glow_module(center[1] + offset_center - cen_meas3, center[2] + 30 - 10, cen_meas2, 0, 15, 0, {r, g, b, 90}, {r, g, b, 90})
local ret = script.helpers:animate_text(globals.curtime(), "ready", dt_r, dt_g, dt_b, 255)
local ret2 = script.helpers:animate_text(globals.curtime(), "charging", dt_r, dt_g, dt_b, 255)
local ret3 = script.helpers:animate_text(globals.curtime(), "defensive", dt_r, dt_g, dt_b, 255)
local ret4 = script.helpers:animate_text(globals.curtime(), "ready", 155, 255, 155, 255)
local ret5 = script.helpers:animate_text(globals.curtime(), "charging", 255, 30, 30, 255)
local ret6 = script.helpers:animate_text(globals.curtime(), "defensive", 155, 255, 155, 255)
renderer.text(center[1] + offset_center - build_meas/2, center[2] + 30 - 10, 255,255,255, 255, "c", nil, "prophesy")
renderer.text(center[1] + offset_center + renderer.measure_text(" ", "prophesy")/2 + 1, center[2] + 30- 10, r, g, b, 255, "c", nil, text_fade_animation(12,r, g,b,255, "nightly"))
renderer.text(center[1] + offset_state, center[2] + 40 - 10, 255, 255, 255, 255, "c" , nil, state3)
renderer.text(center[1] + offset_rapid , center[2] + 48 + 2 - 10, 255, 255, 255, dtopa2 * 255, "c" , dt_mes + dtopa2 * charging_size, "dt \a" .. script.helpers:rgba_to_hex(155, 255, 155, dtopa2 * 255) .. "ready")
renderer.text(center[1] + offset_rapid2, center[2] + 48 + 2 - 10, 255, 255, 255, dtopa3 * 255, "c" , dt_mes + dtopa3 * charging_size2, "dt ", unpack(ret2))
renderer.text(center[1] + offset_rapid3, center[2] + 48 + 2 - 10, 255, 255, 255, dtopa4 * 255, "c" , dt_mes + dtopa4 * charging_size3,  "dt \a" .. script.helpers:rgba_to_hex(r, g, b, dtopa4 * 255) .. "defensive")
renderer.text(center[1] + offset_quickpeek, center[2] + 48 + 2 - 10, 255, 255, 255, dtopa5 * 255, "c" , p_mes + dtopa5 * charging_size4, "idealtick \a" .. script.helpers:rgba_to_hex(155, 255, 155, dtopa5 * 255) .. "ready")
renderer.text(center[1] + offset_quickpeek2 , center[2] + 48 + 2 - 10, 255, 255, 255, dtopa6 * 255, "c" , p_mes + dtopa6 * charging_size5, "idealtick ", unpack(ret5))
renderer.text(center[1] + offset_quickpeek3, center[2] + 48 + 2 - 10, 255, 255, 255, dtopa7 * 255, "c" , p_mes + dtopa7 * charging_size3, "idealtick \a" .. script.helpers:rgba_to_hex(r, g, b, dtopa7 * 255) .. "defensive")
end   
end 

local function on_setup_command(cmd)
local lp = entity.get_local_player()
if not lp or not entity.is_alive(lp) then
return
end
local vec_velocity = { entity.get_prop(lp, 'm_vecVelocity') }
local flags = entity.get_prop(lp, 'm_fFlags')
              
if not vec_velocity[1] or not flags then
return
end
              
local duck_amount = entity.get_prop(lp, 'm_flDuckAmount')
local velocity = math.floor(math.sqrt(vec_velocity[1] ^ 2 + vec_velocity[2] ^ 2) + 0.5)
local air = bit.band(flags, 1) == 0         
if air == false then
ground_time = ground_time + 1
else
ground_time = 0
end
            
if prophesy.anti_aim.aa_dir > 0 then
state3 = '- direction -'
elseif not ui.get(prophesy.reference.other.double_tap[2]) then
state3 = '- fakelag -'
elseif ground_time < 8 and duck_amount > 0 then
state3 = '- air crouch -'
elseif ground_time < 8 then
state3 = '- in air -'
elseif duck_amount > 0 and velocity <= 2 then
state3 = '- crouch -'
elseif duck_amount > 0 and velocity >= 2 then
state3 = '- move crouch -'
elseif velocity < 3.1 then
state3 = '- stand -'
elseif velocity < 100 and ui.get(prophesy.reference.other.slow_motion[2]) then
state3 = '- walking -'
else
state3 = '- run -'
end
end      
client.set_event_callback('setup_command', on_setup_command) 
client.set_event_callback("paint", animated)