--affection.source coded by kura#1111
local ffi = require('ffi')
local bit = require('bit')
local antiaim_funcs = require('gamesense/antiaim_funcs')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
local images = require('gamesense/images')
local http = require('gamesense/http')
local ent = require ('gamesense/entity')
local obex_data = {username = 'scriptleaks', build = 'Boosters', discord=''}
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
affection = {
    table = {
        config_data = {};
        visuals = {
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
        aa_inverted = 0;
        aa_side = 0;
        tick_var = 0;
        cur_team = 0;
        tick_variables = 0;
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
        tick_yaw = 0;
        current_preset = 0;
    };
}

affection.reference = {
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
        for table, values in pairs(affection.reference.anti_aim) do
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

-- outside table messy code #fix soon
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
local ground_ticks = 0
local end_time = 0
local step = 0

-- script helpers function @credit:boshka~#9502 (russian friend)

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

-- script renderer function @credit:boshka~#9502 (russian friend)

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


-- contains function @credit:Doners#7909
local function contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

-- other functions @credit:luasense scripting code snippets
function rounded_rectangle(x, y, r, g, b, a, width, height, radius)
    renderer.rectangle(x + radius, y + radius, width - (radius * 2), height - radius * 2, r, g, b, a)
    renderer.rectangle(x + radius, y, width - (radius * 2), radius, r, g, b, a)
    renderer.rectangle(x + radius, y + height - radius, width - (radius * 2), radius, r, g, b, a)
    renderer.rectangle(x, y + radius, radius, height - (radius * 2), r, g, b, a)
    renderer.rectangle(x + (width - radius), y + radius, radius, height - (radius * 2), r, g, b, a)

    renderer.circle(x + radius, y + radius, r, g, b,a, radius, 145, radius * 0.1)
    renderer.circle(x + width - radius, y + radius, r, g, b, a, radius, 90, radius * 0.1)
    renderer.circle(x + radius, y + height - radius, r, g, b, a, radius, 180, radius * 0.1)
    renderer.circle(x + width - radius, y + height - radius, r, g, b, a, radius, 0, radius * 0.1)
end

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

local function roundedRectangle(b, c, d, e, f, g, h, i, j, k)
    renderer.rectangle(b, c, d, e, f, g, h, i)
    renderer.circle(b, c, f, g, h, i, k, -180, 0.25)
    renderer.circle(b + d, c, f, g, h, i, k, 90, 0.25)
    renderer.rectangle(b, c - k, d, k, f, g, h, i)
    renderer.circle(b + d, c + e, f, g, h, i, k, 0, 0.25)
    renderer.circle(b, c + e, f, g, h, i, k, -90, 0.25)
    renderer.rectangle(b, c + e, d, k, f, g, h, i)
    renderer.rectangle(b - k, c, k, e, f, g, h, i)
    renderer.rectangle(b + d, c, k, e, f, g, h, i)
end

-- animation variables function @credit:mini#6576 animation variables library from forums
function affection.table.visuals.animation_variables.lerp(a,b,t)
    return a + (b - a) * t
end

function affection.table.visuals.animation_variables.pulsate(alpha,min,max,speed)

    if alpha >= max - 2 then
        affection.table.visuals.new_change = false
    elseif alpha <= min  + 2 then
        affection.table.visuals.new_change = true
    end

    if affection.table.visuals.new_change == true then
        alpha = affection.table.visuals.animation_variables.lerp(alpha,max,globals.frametime() * speed)
    else
        alpha = affection.table.visuals.animation_variables.lerp(alpha,min,globals.frametime() * speed)
    end

    return alpha 
end

function affection.table.visuals.animation_variables.movement(offset,when,original,new_place,speed)

    if when == true then
        offset = affection.table.visuals.animation_variables.lerp(offset,new_place,globals.frametime() * speed)
    else
        offset = affection.table.visuals.animation_variables.lerp(offset,original,globals.frametime() * speed)
    end

    return offset 
end

function affection.table.visuals.animation_variables.fade(alpha,fade_bool,f_in,f_away,speed) 

    if fade_bool == true then 
        alpha = affection.table.visuals.animation_variables.lerp(alpha,f_in,globals.frametime() * speed)
    else
        alpha = affection.table.visuals.animation_variables.lerp(alpha,f_away,globals.frametime() * speed)
    end

    return alpha
end

-- menu elements

affection.menu.antiaim_elements_ct = {}
affection.menu.antiaim_elements_t = {}
affection.menu.tab_label = ui.new_label("AA", "Anti-aimbot angles", " ")
affection.menu.color_picker = ui.new_color_picker("AA", "Anti-aimbot angles", " ", 195,175,180, 255)
affection.menu.tab_selector = ui.new_combobox("AA", "Anti-aimbot angles", "\nselection", {"anti-aim", "misc", "visuals", "config"})
affection.menu.antiaim_enable_addons = ui.new_checkbox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFkeybinds");
affection.menu.antiaim_freestanding = ui.new_hotkey("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFfreestanding");
affection.menu.antiaim_manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFmanual right");
affection.menu.antiaim_manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFmanual left");
affection.menu.antiaim_manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFmanual forward");
affection.menu.antiaim_anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFanti backstab");
affection.menu.antiaim_legit_aa = ui.new_checkbox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFlegit aa on e");
affection.menu.antiaim_quickpeek = ui.new_checkbox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFpeek options");
affection.menu.antiaim_quickpeek_addons = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFBody", "static", "jitter", "opposite");
affection.menu.antiaim_safeknife = ui.new_checkbox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFsafe head options");
affection.menu.antiaim_safeknife_options = ui.new_multiselect("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFon", "knife", "zeus");
affection.menu.antiaim_animation = ui.new_checkbox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFanimations");
affection.menu.antiaim_animation_ground = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFon ground", "-", "sliding", "modern");
affection.menu.antiaim_animation_air = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFin air", "-", "static", "moonwalk");
affection.menu.indicators5 = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFFindicator", "-", "modern");
affection.menu.builder_state = {'global', 'stand', 'run', 'slow', 'air', 'air crouch', 'crouch move', 'crouch'}
affection.menu.state_to_num = { 
    ['global'] = 1, 
    ['stand'] = 2, 
    ['run'] = 3, 
    ['slow'] = 4, --export
    ['air'] = 5,
    ['air crouch'] = 6,
    ['crouch move'] = 7,
    ['crouch'] = 8,
};
affection.menu.aabuilder_state = ui.new_combobox("AA", "Anti-aimbot angles", "\nteam", affection.menu.builder_state)
affection.menu.team_site = ui.new_combobox("AA", "Anti-aimbot angles", "\n ", {"ct", "t"});

-- button config system
send_button_t = function ()
    local str = ""
    for i=1, 9 do
        if ui.get(affection.menu.aabuilder_state) == affection.menu.builder_state[i] then
            str = str
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_left)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_right)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_tick)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_delay)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_left)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_right)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_jitter)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider_l)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider_r)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_body_yaw)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_ct[i].antiaim_body_yaw_slider)) .. "|"
        end
    end

    local tbl = str_to_sub(str, "|")
	for i2 = 1, 9 do
        if ui.get(affection.menu.aabuilder_state) == affection.menu.builder_state[i2] then
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_yaw_advanced, tostring(tbl[1]))
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_yaw_slider_left, tonumber(tbl[2]))
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_yaw_slider_right, tonumber(tbl[3]))
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_yaw_slider_adv_tick, tonumber(tbl[4]))
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_yaw_slider_adv_delay, tostring(tbl[5]))
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_yaw_slider_adv_left, tonumber(tbl[6]))
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_yaw_slider_adv_right, tonumber(tbl[7]))
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_yaw_jitter, tostring(tbl[8]))
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_yaw_jitter_slider, tonumber(tbl[9]))
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_yaw_jitter_slider_l, tonumber(tbl[10]))       
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_yaw_jitter_slider_r, tonumber(tbl[11]))    
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_body_yaw, tostring(tbl[12]))       
            ui.set(affection.menu.antiaim_elements_t[i2].antiaim_body_yaw_slider, tonumber(tbl[13]))         
        end
	end
end

send_button_ct = function ()
    local str = ""
    for i=1, 9 do
        if ui.get(affection.menu.aabuilder_state) == affection.menu.builder_state[i] then
            str = str
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_left)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_right)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_tick)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_delay)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_left)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_right)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_jitter)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider_l)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider_r)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_body_yaw)) .. "|"
            .. tostring(ui.get(affection.menu.antiaim_elements_t[i].antiaim_body_yaw_slider)) .. "|"
        end
    end

    local tbl = str_to_sub(str, "|")
	for i2 = 1, 9 do
        if ui.get(affection.menu.aabuilder_state) == affection.menu.builder_state[i2] then
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_yaw_advanced, tostring(tbl[1]))
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_left, tonumber(tbl[2]))
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_right, tonumber(tbl[3]))
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_adv_tick, tonumber(tbl[4]))
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_adv_delay, tostring(tbl[5]))
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_adv_left, tonumber(tbl[6]))
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_yaw_slider_adv_right, tonumber(tbl[7]))
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_yaw_jitter, tostring(tbl[8]))
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_yaw_jitter_slider, tonumber(tbl[9]))
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_yaw_jitter_slider_l, tonumber(tbl[10]))       
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_yaw_jitter_slider_r, tonumber(tbl[11]))    
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_body_yaw, tostring(tbl[12]))       
            ui.set(affection.menu.antiaim_elements_ct[i2].antiaim_body_yaw_slider, tonumber(tbl[13]))         
        end
	end
end

-- anti_aim elements
for k, v in pairs(affection.menu.builder_state) do
    affection.menu.antiaim_elements_ct[k] = {  
        enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\affccd4FFEnable: \aFFFFFFFFCT "..affection.menu.builder_state[k].."");
        antiaim_yaw_advanced = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct methods ", {"advanced", "delayed", "flick", "breaker", "era"});
        antiaim_yaw_slider_left = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct left yaw  ", -180, 180, 0, true, "°");
        antiaim_yaw_slider_right = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct right yaw  ", -180, 180, 0, true, "°");
        antiaim_yaw_slider_adv_tick = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct speed  ", 1, 25, 0, true, "x");
        antiaim_yaw_slider_adv_delay = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct ticks  ", 1, 10, 0, true, "d");
        antiaim_yaw_slider_adv_left = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct left custom", -180, 180, 0, true, "°");
        antiaim_yaw_slider_adv_right = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct right custom  ", -180, 180, 0, true, "°");
        antiaim_yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct modes ", {"normal", "meta", "era"});
        antiaim_yaw_jitter_slider = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct jitter ", -180, 180, 0, true, "°");
        antiaim_yaw_jitter_slider_l = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct left Jitter ", -180, 180, 0, true, "°");
        antiaim_yaw_jitter_slider_r = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct right Jitter ", -180, 180, 0, true, "°");
        antiaim_body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct types ", {"jitter", "static", "off"});
        antiaim_body_yaw_slider = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct body", -180, 180, 0, true, "°");
        antiaim_defensive = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." ct breaker ", {"-", "normal", "affection"});
        send_to_t = ui.new_button("AA", "Anti-aimbot angles", "send to \affccd4FFt", send_button_t);
    }
end

for k, v in pairs(affection.menu.builder_state) do
    affection.menu.antiaim_elements_t[k] = {
        enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\affccd4FFEnable: \aFFFFFFFFT "..affection.menu.builder_state[k].."");
        antiaim_yaw_advanced = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t methods ", {"advanced", "delayed", "flick", "breaker", "era"});
        antiaim_yaw_slider_left = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t left yaw  ", -180, 180, 0, true, "°");
        antiaim_yaw_slider_right = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t right yaw  ", -180, 180, 0, true, "°");
        antiaim_yaw_slider_adv_tick = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t speed  ", 1, 25, 0, true, "x");
        antiaim_yaw_slider_adv_delay = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t ticks  ", 1, 10, 0, true, "d");
        antiaim_yaw_slider_adv_left = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t left custom  ", -180, 180, 0, true, "°");
        antiaim_yaw_slider_adv_right = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t right custom  ", -180, 180, 0, true, "°");
        antiaim_yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t Modes ", {"normal", "meta", "era"});
        antiaim_yaw_jitter_slider = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t Jitter ", -180, 180, 0, true, "°");
        antiaim_yaw_jitter_slider_l = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t left jitter ", -180, 180, 0, true, "°");
        antiaim_yaw_jitter_slider_r = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t right jitter ", -180, 180, 0, true, "°");
        antiaim_body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t types ", {"jitter", "static", "off"});
        antiaim_body_yaw_slider = ui.new_slider("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t body", -180, 180, 0, true, "°");
        antiaim_defensive = ui.new_combobox("AA", "Anti-aimbot angles", "\affccd4FFaffection -> \aFFFFFFFF"..affection.menu.builder_state[k].." t breaker ", {"-", "normal", "affection"});
        send_to_ct = ui.new_button("AA", "Anti-aimbot angles", "send to \affccd4FFct", send_button_ct);
    }
end

-- config data

affection.table.config_data.cfg_data = {
    anti_aim = {
        affection.menu.antiaim_elements_ct[1].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_ct[1].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_ct[1].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_ct[1].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_ct[1].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_ct[1].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_ct[1].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_ct[1].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_ct[1].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_ct[1].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_ct[1].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_ct[1].antiaim_body_yaw;
        affection.menu.antiaim_elements_ct[1].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_ct[1].antiaim_defensive;

        affection.menu.antiaim_elements_ct[2].enable;
        affection.menu.antiaim_elements_ct[2].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_ct[2].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_ct[2].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_ct[2].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_ct[2].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_ct[2].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_ct[2].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_ct[2].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_ct[2].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_ct[2].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_ct[2].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_ct[2].antiaim_body_yaw;
        affection.menu.antiaim_elements_ct[2].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_ct[2].antiaim_defensive;

        affection.menu.antiaim_elements_ct[3].enable;
        affection.menu.antiaim_elements_ct[3].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_ct[3].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_ct[3].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_ct[3].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_ct[3].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_ct[3].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_ct[3].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_ct[3].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_ct[3].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_ct[3].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_ct[3].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_ct[3].antiaim_body_yaw;
        affection.menu.antiaim_elements_ct[3].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_ct[3].antiaim_defensive;

        affection.menu.antiaim_elements_ct[4].enable;
        affection.menu.antiaim_elements_ct[4].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_ct[4].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_ct[4].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_ct[4].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_ct[4].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_ct[4].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_ct[4].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_ct[4].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_ct[4].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_ct[4].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_ct[4].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_ct[4].antiaim_body_yaw;
        affection.menu.antiaim_elements_ct[4].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_ct[4].antiaim_defensive;

        affection.menu.antiaim_elements_ct[5].enable;
        affection.menu.antiaim_elements_ct[5].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_ct[5].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_ct[5].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_ct[5].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_ct[5].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_ct[5].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_ct[5].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_ct[5].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_ct[5].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_ct[5].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_ct[5].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_ct[5].antiaim_body_yaw;
        affection.menu.antiaim_elements_ct[5].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_ct[5].antiaim_defensive;

        affection.menu.antiaim_elements_ct[6].enable;
        affection.menu.antiaim_elements_ct[6].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_ct[6].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_ct[6].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_ct[6].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_ct[6].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_ct[6].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_ct[6].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_ct[6].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_ct[6].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_ct[6].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_ct[6].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_ct[6].antiaim_body_yaw;
        affection.menu.antiaim_elements_ct[6].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_ct[6].antiaim_defensive;
        
        affection.menu.antiaim_elements_ct[7].enable;
        affection.menu.antiaim_elements_ct[7].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_ct[7].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_ct[7].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_ct[7].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_ct[7].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_ct[7].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_ct[7].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_ct[7].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_ct[7].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_ct[7].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_ct[7].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_ct[7].antiaim_body_yaw;
        affection.menu.antiaim_elements_ct[7].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_ct[7].antiaim_defensive;

        affection.menu.antiaim_elements_ct[8].enable;
        affection.menu.antiaim_elements_ct[8].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_ct[8].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_ct[8].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_ct[8].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_ct[8].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_ct[8].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_ct[8].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_ct[8].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_ct[8].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_ct[8].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_ct[8].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_ct[8].antiaim_body_yaw;
        affection.menu.antiaim_elements_ct[8].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_ct[8].antiaim_defensive;

      
        affection.menu.antiaim_elements_t[1].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_t[1].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_t[1].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_t[1].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_t[1].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_t[1].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_t[1].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_t[1].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_t[1].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_t[1].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_t[1].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_t[1].antiaim_body_yaw;
        affection.menu.antiaim_elements_t[1].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_t[1].antiaim_defensive;

        affection.menu.antiaim_elements_t[2].enable;
        affection.menu.antiaim_elements_t[2].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_t[2].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_t[2].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_t[2].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_t[2].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_t[2].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_t[2].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_t[2].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_t[2].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_t[2].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_t[2].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_t[2].antiaim_body_yaw;
        affection.menu.antiaim_elements_t[2].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_t[2].antiaim_defensive;

        affection.menu.antiaim_elements_t[3].enable;
        affection.menu.antiaim_elements_t[3].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_t[3].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_t[3].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_t[3].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_t[3].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_t[3].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_t[3].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_t[3].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_t[3].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_t[3].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_t[3].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_t[3].antiaim_body_yaw;
        affection.menu.antiaim_elements_t[3].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_t[3].antiaim_defensive;

        affection.menu.antiaim_elements_t[4].enable;
        affection.menu.antiaim_elements_t[4].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_t[4].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_t[4].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_t[4].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_t[4].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_t[4].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_t[4].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_t[4].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_t[4].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_t[4].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_t[4].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_t[4].antiaim_body_yaw;
        affection.menu.antiaim_elements_t[4].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_t[4].antiaim_defensive;

        affection.menu.antiaim_elements_t[5].enable;
        affection.menu.antiaim_elements_t[5].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_t[5].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_t[5].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_t[5].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_t[5].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_t[5].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_t[5].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_t[5].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_t[5].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_t[5].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_t[5].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_t[5].antiaim_body_yaw;
        affection.menu.antiaim_elements_t[5].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_t[5].antiaim_defensive;

        affection.menu.antiaim_elements_t[6].enable;
        affection.menu.antiaim_elements_t[6].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_t[6].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_t[6].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_t[6].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_t[6].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_t[6].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_t[6].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_t[6].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_t[6].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_t[6].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_t[6].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_t[6].antiaim_body_yaw;
        affection.menu.antiaim_elements_t[6].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_t[6].antiaim_defensive;

        affection.menu.antiaim_elements_t[7].enable;
        affection.menu.antiaim_elements_t[7].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_t[7].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_t[7].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_t[7].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_t[7].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_t[7].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_t[7].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_t[7].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_t[7].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_t[7].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_t[7].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_t[7].antiaim_body_yaw;
        affection.menu.antiaim_elements_t[7].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_t[7].antiaim_defensive;

        affection.menu.antiaim_elements_t[8].enable;
        affection.menu.antiaim_elements_t[8].antiaim_yaw_advanced;
        affection.menu.antiaim_elements_t[8].antiaim_yaw_slider_left;
        affection.menu.antiaim_elements_t[8].antiaim_yaw_slider_right;
        affection.menu.antiaim_elements_t[8].antiaim_yaw_slider_adv_tick;
        affection.menu.antiaim_elements_t[8].antiaim_yaw_slider_adv_delay;
        affection.menu.antiaim_elements_t[8].antiaim_yaw_slider_adv_left;
        affection.menu.antiaim_elements_t[8].antiaim_yaw_slider_adv_right;
        affection.menu.antiaim_elements_t[8].antiaim_yaw_jitter;
        affection.menu.antiaim_elements_t[8].antiaim_yaw_jitter_slider;
        affection.menu.antiaim_elements_t[8].antiaim_yaw_jitter_slider_l;
        affection.menu.antiaim_elements_t[8].antiaim_yaw_jitter_slider_r;
        affection.menu.antiaim_elements_t[8].antiaim_body_yaw;
        affection.menu.antiaim_elements_t[8].antiaim_body_yaw_slider;
        affection.menu.antiaim_elements_t[8].antiaim_defensive;
    };

    keybindsandothertable = {};
    other_aa = {};
}

--#region configs

local export_config = ui.new_button("AA", "Anti-aimbot angles", "\affccd4FFexport", function ()
    local Code = {{}, {}, {}};

    for _, main in pairs(affection.table.config_data.cfg_data.anti_aim) do
        if ui.get(main) ~= nil then
            table.insert(Code[1], tostring(ui.get(main)))
        end
    end

    for _, main in pairs(affection.table.config_data.cfg_data.keybindsandothertable) do
        if ui.get(main) ~= nil then
            table.insert(Code[2], tostring(framework.library["=>"].func.arr_to_string(main)))
        end
    end

    for _, main in pairs(affection.table.config_data.cfg_data.other_aa) do
        if ui.get(main) ~= nil then
            table.insert(Code[3], tostring(ui.get(main)))
        end
    end

    clipboard.set(base64.encode(json.stringify(Code)))
end);

local import_config = ui.new_button("AA", "Anti-aimbot angles", "\affccd4FFimport", function ()
    local protected = function() 
        for k, v in pairs(json.parse(base64.decode(clipboard.get()))) do
            
            k = ({[1] = "anti_aim", [2] = "keybindsandothertable", [3] = "other_aa"})[k]

            for k2, v2 in pairs(v) do
                if (k == "anti_aim") then
                    if v2 == "true" then
                        ui.set(affection.table.config_data.cfg_data[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(affection.table.config_data.cfg_data[k][k2], false)
                    else
                        ui.set(affection.table.config_data.cfg_data[k][k2], v2)
                    end
                end
                if (k == "keybindsandothertable") then
                    ui.set(affection.table.config_data.cfg_data[k][k2], framework.library["=>"].func.str_to_sub(v2, ","))
                end
                if (k == "other_aa") then
                    if v2 == "true" then
                        ui.set(affection.table.config_data.cfg_data[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(affection.table.config_data.cfg_data[k][k2], false)
                    else
                        ui.set(affection.table.config_data.cfg_data[k][k2], v2)
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

--#endregion configs

--#region visible

client.set_event_callback( "paint_ui", function(  )
    setup_skeet_element("vis", nil, nil, "load")
    setup_skeet_element("vis_elem", export_config, ui.get(affection.menu.tab_selector) == "config", nil)
    setup_skeet_element("vis_elem", import_config, ui.get(affection.menu.tab_selector) == "config", nil)
    local r,g,b = ui.get(affection.menu.color_picker)
    if ui.is_menu_open() then
        ui.set(affection.menu.tab_label, text_fade_animation(8, r,g,b, 255, "affection.lua"))
    end
    local anti_aim_tab = ui.get(affection.menu.tab_selector) == "anti-aim"
    local misc_tab = ui.get(affection.menu.tab_selector) == "misc"
    local visuals_tab = ui.get(affection.menu.tab_selector) == "visuals"
    local main_tab = ui.get(affection.menu.tab_selector) == "welcome"
    local yaw_addons_enabled = ui.get(affection.menu.antiaim_enable_addons)
    for i = 1,#affection.menu.builder_state do
        -- anti_aim elements
        local selecte = ui.get(affection.menu.aabuilder_state)
        local team_selected = ui.get(affection.menu.team_site)
        local conditions_enabled_ct = ui.get(affection.menu.antiaim_elements_ct[i].enable)
        local conditions_enabled_t = ui.get(affection.menu.antiaim_elements_t[i].enable)
        local show_ct = anti_aim_tab and selecte == affection.menu.builder_state[i] and conditions_enabled_ct and team_selected == "ct"
        local show_t = anti_aim_tab and selecte == affection.menu.builder_state[i] and conditions_enabled_t and team_selected == "t"
       
        -- counter
        ui.set_visible(affection.menu.antiaim_elements_ct[i].enable, anti_aim_tab and selecte == affection.menu.builder_state[i] and i > 1 and team_selected == "ct")
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider, show_ct and ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) ~= "era")
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider_r, show_ct and ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "era")
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_yaw_jitter_slider_l, show_ct and ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_jitter) == "era")
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_left, show_ct and (ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "advanced" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "era"))
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_right, show_ct and (ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "advanced" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "era"))
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_tick, show_ct and (ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "delayed" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "breaker" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "flick"))
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_delay, show_ct and (ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "delayed"))
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_left, show_ct and (ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "delayed" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "breaker" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "flick"))
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_yaw_slider_adv_right, show_ct and (ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "delayed" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "breaker" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "flick"))
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced, show_ct)
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_yaw_jitter, show_ct)
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_body_yaw, show_ct and (ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "advanced" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "breaker" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "era"))
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_body_yaw_slider, show_ct and (ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "advanced" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "breaker" or ui.get(affection.menu.antiaim_elements_ct[i].antiaim_yaw_advanced) == "era"))
        ui.set_visible(affection.menu.antiaim_elements_ct[i].send_to_t, show_ct)
        ui.set_visible(affection.menu.antiaim_elements_ct[i].antiaim_defensive, show_ct)

        -- terrorist
        ui.set_visible(affection.menu.antiaim_elements_t[i].enable, anti_aim_tab and selecte == affection.menu.builder_state[i] and i > 1 and team_selected == "t")
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider, show_t and ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_jitter) ~= "era")
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider_r, show_t and ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "era")
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_yaw_jitter_slider_l, show_t and ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_jitter) == "era")
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_left, show_t and (ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "advanced" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "era"))
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_right, show_t and (ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "advanced" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "era"))
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_tick, show_t and (ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "delayed" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "breaker" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "flick"))
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_delay, show_t and (ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "delayed"))
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_left, show_t and (ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "delayed" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "breaker" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "flick"))
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_yaw_slider_adv_right, show_t and (ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "delayed" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "breaker" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "flick"))
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced, show_t)
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_yaw_jitter, show_t)
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_defensive, show_t)
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_body_yaw, show_t and (ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "advanced" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "breaker" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "era"))
        ui.set_visible(affection.menu.antiaim_elements_t[i].antiaim_body_yaw_slider, show_t and (ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "advanced" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "breaker" or ui.get(affection.menu.antiaim_elements_t[i].antiaim_yaw_advanced) == "era"))
        ui.set_visible(affection.menu.antiaim_elements_t[i].send_to_ct, show_t)
    end

    -- other elements
    ui.set_visible(affection.menu.antiaim_anti_knife, misc_tab)
    ui.set_visible(affection.menu.antiaim_legit_aa, misc_tab)
    ui.set_visible(affection.menu.antiaim_quickpeek, misc_tab)
    ui.set_visible(affection.menu.antiaim_quickpeek_addons, misc_tab and ui.get(affection.menu.antiaim_quickpeek))
    ui.set_visible(affection.menu.team_site, anti_aim_tab)
    ui.set_visible(affection.menu.aabuilder_state, anti_aim_tab)
    ui.set_visible(affection.menu.antiaim_enable_addons, anti_aim_tab)
    ui.set_visible(affection.menu.antiaim_manual_left, anti_aim_tab and yaw_addons_enabled)
    ui.set_visible(affection.menu.antiaim_manual_right, anti_aim_tab and yaw_addons_enabled)
    ui.set_visible(affection.menu.antiaim_manual_forward, anti_aim_tab and yaw_addons_enabled)
    ui.set_visible(affection.menu.antiaim_freestanding, anti_aim_tab and yaw_addons_enabled)
    ui.set_visible(affection.menu.antiaim_safeknife, misc_tab)
    ui.set_visible(affection.menu.antiaim_animation, misc_tab)
    ui.set_visible(affection.menu.antiaim_animation_ground, misc_tab and ui.get(affection.menu.antiaim_animation))
    ui.set_visible(affection.menu.antiaim_animation_air, misc_tab and ui.get(affection.menu.antiaim_animation))
    ui.set_visible(affection.menu.antiaim_safeknife_options, misc_tab and ui.get(affection.menu.antiaim_safeknife))
    ui.set_visible(affection.menu.indicators5, visuals_tab)
end)

setup_skeet_element("elem", affection.reference.anti_aim.master, true, nil)
setup_skeet_element("elem", affection.menu.antiaim_elements_ct[1].enable, true, nil)
setup_skeet_element("elem", affection.menu.antiaim_elements_t[1].enable, true, nil)
setup_skeet_element("vis_elem", affection.menu.antiaim_elements_ct[1].enable, false, nil)
setup_skeet_element("vis_elem", affection.menu.antiaim_elements_t[1].enable, false, nil)

--#endregion visible

--#region events

-- custom anti_aims
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

-- state functions

get_anti_aimbuilder_state = function ()
    local state = ""
    local lp = entity.get_local_player()
    local vel1, vel2, vel3 = entity.get_prop(lp, 'm_vecVelocity')
    local velocity = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))
    local on_ground = bit.band(entity.get_prop(lp, "m_fFlags"), 1) == 1
    local not_moving = velocity < 2
    local slowwalk_key = ui.get(affection.reference.other.slow_motion[2])
    local teamnum = entity.get_prop(lp, 'm_iTeamNum')
    local vec_velocity = { entity.get_prop(lp, 'm_vecVelocity') }
    local teamnum = entity.get_prop(lp, 'm_iTeamNum') 
    local duck_amount = entity.get_prop(lp, 'm_flDuckAmount')
    local velocity = math.floor(math.sqrt(vec_velocity[1] ^ 2 + vec_velocity[2] ^ 2) + 0.5)
    local air = bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 0
    if air == false then
        affection.anti_aim.ground_time = affection.anti_aim.ground_time + 1
    else
        affection.anti_aim.ground_time = 0
    end
    if not ui.get(affection.reference.other.bunny_hop) then
        on_ground = bit.band(entity.get_prop(lp, "m_fFlags"), 1) == 1
    end


    if affection.anti_aim.ground_time < 8 and duck_amount > 0 then
        state = 'air crouch'
    elseif affection.anti_aim.ground_time < 8 then
        state = 'air'
    elseif duck_amount > 0 and velocity <= 2 then
        state = 'crouch'
    elseif duck_amount > 0 and velocity >= 2 then
        state = 'crouch move'
    elseif ui.get(affection.reference.other.fakeducking)then 
        state = 'crouch'
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

-- defensive check

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
        affection.anti_aim.defensive_ticks = globals.tickcount() + toticks(.200);
    end
end

client.set_event_callback( "net_update_start", function(  )
    do_defensive()
end)

client.set_event_callback( "setup_command", function( arg )
    if entity.is_alive(entity.get_local_player()) then 

    
    if globals.tickcount() - affection.anti_aim.tick_var > 0 and arg.chokedcommands == 1 then
        affection.anti_aim.is_invert = not affection.anti_aim.is_invert
        affection.anti_aim.tick_var = globals.tickcount()
    elseif globals.tickcount() - affection.anti_aim.tick_var < -1 then
        affection.anti_aim.tick_var = globals.tickcount()
    end

    if arg.chokedcommands == 1 then
        affection.anti_aim.tick_variables = affection.anti_aim.tick_variables + 1
    end

    if affection.anti_aim.tick_variables > 6 then
        affection.anti_aim.tick_variables = 0
    end

    local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    affection.anti_aim.aa_inverted = body_yaw > 0
    affection.anti_aim.aa_side = affection.anti_aim.aa_inverted and 1 or -1
    local m_flSimulationTime = entity.get_prop(player, "m_flSimulationTime");
    affection.anti_aim.cur_team = entity.get_prop(entity.get_local_player(), "m_iTeamNum") 
    affection.anti_aim.state_id = ui.get(affection.anti_aim.cur_team == 3 and affection.menu.antiaim_elements_ct[affection.menu.state_to_num[get_anti_aimbuilder_state()] ].enable or affection.menu.antiaim_elements_t[affection.menu.state_to_num[get_anti_aimbuilder_state()] ].enable) and affection.menu.state_to_num[get_anti_aimbuilder_state()] or affection.menu.state_to_num['global'];
       
    if affection.anti_aim.cur_team == 2 then
        if ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_advanced) == "static" then
            affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider)
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_advanced) == "advanced" then
            affection.anti_aim.yaw_value = affection.anti_aim.is_invert and ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_left) or ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_right)
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_advanced) == "delayed" then
            affection.anti_aim.yaw_value = affection.anti_aim.aa_side ~= 1 and ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_adv_right) or ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_adv_left)
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_advanced) == "breaker" then
            affection.anti_aim.yaw_value = manipulation_break(ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_adv_left), ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_adv_right), ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_advanced) == "flick" then
            affection.anti_aim.yaw_value = affection.anti_aim.aa_side ~= 1 and ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_adv_right) or ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_adv_left)
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_advanced) == "era" then
            if affection.anti_aim.tick_variables == 0 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_right)
            elseif affection.anti_aim.tick_variables == 1 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_left)
            elseif affection.anti_aim.tick_variables == 2 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_right)
            elseif affection.anti_aim.tick_variables == 3 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_right)
            elseif affection.anti_aim.tick_variables == 4 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_right)
            elseif affection.anti_aim.tick_variables == 5 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_left)
            elseif affection.anti_aim.tick_variables == 6 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_left)
            end   
        end


        if ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter) == "normal" then
            affection.anti_aim.yaw_jitter = "center"
            affection.anti_aim.yaw_jitter_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter_slider)
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter) == "era" then
            affection.anti_aim.yaw_jitter = "center"
            local step_value = 0
            local rand = client.random_int(1, 6)
            if rand == 1 then
            step_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_l)
            elseif rand == 2 then
            step_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
            elseif rand == 3 then
            step_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_l)
            elseif rand == 4 then
            step_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
            elseif rand == 5 then
            step_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_l)
            elseif rand == 6 then
            step_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
            end
            affection.anti_aim.yaw_jitter_value = step_value
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter) == "meta" then
            if ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter_slider) > 0 then
                affection.anti_aim.yaw_jitter_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter_slider) - math.abs(client.random_int(0,math.random(5,10))) * 1.6
                elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter_slider) < 0 then
                affection.anti_aim.yaw_jitter_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_jitter_slider) + math.abs(client.random_int(0,math.random(5,10))) * 1.6
                end
        else affection.anti_aim.yaw_jitter_value = 0
        end

        if ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_advanced) == "advanced" then
            affection.anti_aim.body_yaw = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_body_yaw)
            affection.anti_aim.body_yaw_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_body_yaw_slider)
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_advanced) == "delayed" then
            affection.anti_aim.body_yaw = "static"
            affection.anti_aim.body_yaw_value = manipulation_tick(math.random(68, 123), math.random(-68, -123), ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_adv_delay), ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_advanced) == "breaker" then
            affection.anti_aim.body_yaw = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_body_yaw)
            affection.anti_aim.body_yaw_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_body_yaw_slider)
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_advanced) == "flick" then
            affection.anti_aim.body_yaw = "static"
            affection.anti_aim.body_yaw_value = manipulation_break(120, -120, ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_yaw_advanced) == "era" then
            affection.anti_aim.body_yaw = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_body_yaw)
            affection.anti_aim.body_yaw_value = ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_body_yaw_slider)
        end
        if ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_defensive) == "normal" then
            affection.anti_aim.defensive_t = true
            affection.anti_aim.is_active_inds = true
        elseif ui.get(affection.menu.antiaim_elements_t[affection.anti_aim.state_id].antiaim_defensive) == "affection" then
            affection.anti_aim.is_active_inds = true
            if globals.tickcount() % 2 == 1 then
                affection.anti_aim.is_active_inds = true
                affection.anti_aim.defensive_t = true
            else
                affection.anti_aim.defensive_t = false
            end
        else 
            affection.anti_aim.defensive_t = false
            affection.anti_aim.is_active_inds = false
        end
        arg.force_defensive = affection.anti_aim.defensive_t;
    elseif affection.anti_aim.cur_team == 3 then
        if ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_advanced) == "static" then
            affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider)
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_advanced) == "advanced" then
            affection.anti_aim.yaw_value = affection.anti_aim.is_invert and ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_left) or ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_right)
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_advanced) == "delayed" then
            affection.anti_aim.yaw_value = affection.anti_aim.aa_side ~= 1 and ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_adv_right) or ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_adv_left)
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_advanced) == "breaker" then
            affection.anti_aim.yaw_value = manipulation_break(ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_adv_left), ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_adv_right), ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_advanced) == "flick" then
            affection.anti_aim.yaw_value = affection.anti_aim.aa_side ~= 1 and ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_adv_right) or ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_adv_left)
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_advanced) == "era" then
            if affection.anti_aim.tick_variables == 0 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_right)
            elseif affection.anti_aim.tick_variables == 1 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_left)
            elseif affection.anti_aim.tick_variables == 2 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_right)
            elseif affection.anti_aim.tick_variables == 3 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_right)
            elseif affection.anti_aim.tick_variables == 4 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_right)
            elseif affection.anti_aim.tick_variables == 5 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_left)
            elseif affection.anti_aim.tick_variables == 6 then
                affection.anti_aim.yaw_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_left)
            end   
        end
        
        
        if ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter) == "normal" then
            affection.anti_aim.yaw_jitter = "center"
            affection.anti_aim.yaw_jitter_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter_slider)
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter) == "era" then
            affection.anti_aim.yaw_jitter = "center"
            local step_value = 0
            local rand = client.random_int(1, 6)
            if rand == 1 then
            step_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_l)
            elseif rand == 2 then
            step_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
            elseif rand == 3 then
            step_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_l)
            elseif rand == 4 then
            step_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
            elseif rand == 5 then
            step_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_l)
            elseif rand == 6 then
            step_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
            end
            affection.anti_aim.yaw_jitter_value = step_value
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter) == "meta" then
            if ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter_slider) > 0 then
                affection.anti_aim.yaw_jitter_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter_slider) - math.abs(client.random_int(0,math.random(5,10))) * 1.6
                elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter_slider) < 0 then
                affection.anti_aim.yaw_jitter_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_jitter_slider) + math.abs(client.random_int(0,math.random(5,10))) * 1.6
                end
        else affection.anti_aim.yaw_jitter_value = 0
        end
        
        if ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_advanced) == "advanced" then
            affection.anti_aim.body_yaw = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_body_yaw)
            affection.anti_aim.body_yaw_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_body_yaw_slider)
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_advanced) == "delayed" then
            affection.anti_aim.body_yaw = "static"
            affection.anti_aim.body_yaw_value = manipulation_tick(math.random(68, 123), math.random(-68, -123), ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_adv_delay), ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_advanced) == "breaker" then
            affection.anti_aim.body_yaw = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_body_yaw)
            affection.anti_aim.body_yaw_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_body_yaw_slider)
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_advanced) == "flick" then
            affection.anti_aim.body_yaw = "static"
            affection.anti_aim.body_yaw_value = manipulation_break(120, -120, ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_slider_adv_tick))
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_yaw_advanced) == "era" then
            affection.anti_aim.body_yaw = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_body_yaw)
            affection.anti_aim.body_yaw_value = ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_body_yaw_slider)
        end
        if ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_defensive) == "normal" then
            affection.anti_aim.defensive_t = true
            affection.anti_aim.is_active_inds = true
        elseif ui.get(affection.menu.antiaim_elements_ct[affection.anti_aim.state_id].antiaim_defensive) == "affection" then
            affection.anti_aim.is_active_inds = true
            if globals.tickcount() % 2 == 1 then
                affection.anti_aim.is_active_inds = true
                affection.anti_aim.defensive_t = true
            else
                affection.anti_aim.defensive_t = false
            end
        else 
            affection.anti_aim.defensive_t = false
            affection.anti_aim.is_active_inds = false
        end
        arg.force_defensive = affection.anti_aim.defensive_t;
    end

    
    affection.anti_aim.pitch = "Custom"
    affection.anti_aim.pitch_value = 89
    affection.anti_aim.yaw_base = "At Targets"
    affection.anti_aim.yaw = "180"

    affection.anti_aim.defensive = affection.anti_aim.defensive_ticks > globals.tickcount()
    if affection.anti_aim.defensive then
        affection.anti_aim.is_active = true
    else
        affection.anti_aim.is_active = false
    end

    if ui.get(affection.reference.other.auto_peek[2]) and ui.get(affection.menu.antiaim_quickpeek) then
        affection.anti_aim.yaw_value = 0
        affection.anti_aim.yaw_base = "At Targets"
        affection.anti_aim.yaw_jitter = "off"
        affection.anti_aim.yaw_jitter_value = 0
        affection.anti_aim.body_yaw = ui.get(affection.menu.antiaim_quickpeek_addons)
        affection.anti_aim.body_yaw_value = 0
        quick_peek_addons = true
    else quick_peek_addons = false
    end

    ui.set(affection.menu.antiaim_manual_left, "On hotkey")
	ui.set(affection.menu.antiaim_manual_right, "On hotkey")
    ui.set(affection.menu.antiaim_manual_forward, "On hotkey")
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"),1) == 1 and not client.key_state(0x20)
	local p_key = client.key_state(69)

	
       if ui.get(affection.menu.antiaim_manual_right) and affection.anti_aim.last_press + 0.2 < globals.curtime() then
        affection.anti_aim.aa_dir = affection.anti_aim.aa_dir == 2 and 0 or 2
			affection.anti_aim.last_press = globals.curtime()
		elseif ui.get(affection.menu.antiaim_manual_left) and affection.anti_aim.last_press + 0.2 < globals.curtime() then
			affection.anti_aim.aa_dir = affection.anti_aim.aa_dir == 1 and 0 or 1
			affection.anti_aim.last_press = globals.curtime()
		elseif ui.get(affection.menu.antiaim_manual_forward) and affection.anti_aim.last_press + 0.2 < globals.curtime() then
			affection.anti_aim.aa_dir = affection.anti_aim.aa_dir == 3 and 0 or 3
			affection.anti_aim.last_press = globals.curtime()
		elseif affection.anti_aim.last_press > globals.curtime() then
			affection.anti_aim.last_press = globals.curtime()
        end

	if affection.anti_aim.aa_dir == 1 or affection.anti_aim.aa_dir == 2 or affection.anti_aim.aa_dir == 3 then
		if affection.anti_aim.aa_dir == 1 then
            affection.anti_aim.yaw_value = -90
            affection.anti_aim.yaw = "180"
            affection.anti_aim.yaw_base = "Local View"
            affection.anti_aim.yaw_jitter = "off"
            affection.anti_aim.yaw_jitter_value = 0
            affection.anti_aim.body_yaw = "static"
		elseif affection.anti_aim.aa_dir == 2 then
			affection.anti_aim.yaw_value = 90
            affection.anti_aim.yaw = "180"
            affection.anti_aim.yaw_base = "Local View"
            affection.anti_aim.yaw_jitter = "off"
            affection.anti_aim.yaw_jitter_value = 0
            affection.anti_aim.body_yaw = "static"
		elseif affection.anti_aim.aa_dir == 3 then
			affection.anti_aim.yaw_value = 180
            affection.anti_aim.yaw = "180"
            affection.anti_aim.yaw_base = "Local View"
            affection.anti_aim.yaw_jitter = "off"
            affection.anti_aim.yaw_jitter_value = 0
            affection.anti_aim.body_yaw = "static"
		end
    end

    if ui.get(affection.menu.antiaim_legit_aa) then
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
    
    if ui.get(affection.menu.antiaim_safeknife) then
        local lp = entity.get_local_player()
        local weapon = entity.get_player_weapon(lp)
        if contains(ui.get(affection.menu.antiaim_safeknife_options), "knife") and get_anti_aimbuilder_state() == "Air Crouch" then
        if entity.get_classname(weapon) == "CKnife" then
            affection.anti_aim.yaw_value = 4
            affection.anti_aim.pitch = "Custom"
            affection.anti_aim.yaw = "180"
            affection.anti_aim.pitch_value = 89
            affection.anti_aim.yaw_jitter = "Offset"
            affection.anti_aim.yaw_jitter_value = 3
            affection.anti_aim.body_yaw = "static"
            affection.anti_aim.body_yaw_value = 0
        end
        end
        if contains(ui.get(affection.menu.antiaim_safeknife_options), "zeus") and get_anti_aimbuilder_state() == "Air Crouch" then
        if entity.get_classname(weapon) == "CWeaponTaser" then
            affection.anti_aim.yaw_value = 4
            affection.anti_aim.pitch = "Custom"
            affection.anti_aim.yaw = "180"
            affection.anti_aim.pitch_value = 89
            affection.anti_aim.yaw_jitter = "Offset"
            affection.anti_aim.yaw_jitter_value = 3
            affection.anti_aim.body_yaw = "static"
            affection.anti_aim.body_yaw_value = 0
        end
        end
    end

    if ui.get(affection.menu.antiaim_anti_knife) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = (math.sqrt((x - lx)^2 + (y - ly)^2 + (z - lz)^2))
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 180 then
                affection.anti_aim.yaw_value = 180
                affection.anti_aim.pitch = "off"
                affection.anti_aim.yaw_base = "At targets"
            end
        end
    end

    ui.set(affection.reference.anti_aim.pitch[1], affection.anti_aim.pitch);
    ui.set(affection.reference.anti_aim.pitch[2], affection.anti_aim.pitch_value);
    ui.set(affection.reference.anti_aim.yaw_base, affection.anti_aim.yaw_base);
    ui.set(affection.reference.anti_aim.yaw[1], affection.anti_aim.yaw);
    ui.set(affection.reference.anti_aim.yaw[2], affection.anti_aim.yaw_value);
    ui.set(affection.reference.anti_aim.yaw_jitter[1], affection.anti_aim.yaw_jitter);
    ui.set(affection.reference.anti_aim.yaw_jitter[2], affection.anti_aim.yaw_jitter_value);
    ui.set(affection.reference.anti_aim.body_yaw[1], affection.anti_aim.body_yaw);
    ui.set(affection.reference.anti_aim.body_yaw[2], affection.anti_aim.body_yaw_value);
    ui.set(affection.reference.anti_aim.freestanding_body_yaw, false);
    ui.set(affection.reference.anti_aim.freestanding[2], ui.get(affection.menu.antiaim_freestanding) and "Always On" or "On hotkey");
    ui.set(affection.reference.anti_aim.freestanding[1], ui.get(affection.menu.antiaim_freestanding) and true);
    ui.set(affection.reference.anti_aim.roll_offset, 0);
end
end)
client.set_event_callback("shutdown", function ()
    setup_skeet_element("vis", nil, nil, "unload")
end)

--#endregion events

--#region misc

info_panel = function()
    screen = {client.screen_size()}
    x_offset, y_offset = screen[1], screen[2]
    x, y = x_offset/2, y_offset/2
    r,g,b = ui.get(affection.menu.color_picker)
    renderer.text(x, y_offset - 42, 255,255,255, 255, 'c', nil, "nightly")
    renderer.text(x, y_offset - 30, 255,255,255, 255, 'c', nil, text_fade_animation(8, r,g,b, 255, "A F F E C T I O N"))
end

client.set_event_callback("paint", function()
    info_panel()
end)

client.set_event_callback("pre_render", function()
    if ui.get(affection.menu.antiaim_animation) then 
    if not entity.is_alive(entity.get_local_player()) then return end
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1
    local ref_legs = ui.reference("AA", "other", "leg movement")
    if ui.get(affection.menu.antiaim_animation_ground) == "sliding" and on_ground then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0) 
        ui.set(ref_legs, "Always Slide")
    elseif ui.get(affection.menu.antiaim_animation_ground) == "modern" and on_ground then  
        ui.set(ref_legs, client.random_int(1, 2) == 1 and "off" or "Always slide")
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1 - client.random_float(0.5, 1), 0)
    else ui.set(ref_legs, "off")
    end
    local self_index = ent.new(entity.get_local_player())
    if bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 0 then
    if ui.get(affection.menu.antiaim_animation_air) == "static" then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
    end
    end
    
    if ui.get(affection.menu.antiaim_animation_air) == "moonwalk" then
    local me = ent.get_local_player()
    local m_fFlags = me:get_prop("m_fFlags")
    local is_onground = bit.band(m_fFlags, 1) ~= 0
    if not is_onground then
    local my_animlayer = me:get_anim_overlay(6)
    my_animlayer.weight = 1
    end
    end

else return end
end)

--#endregion misc

--#region indicators

animated = function()
screen = {client.screen_size()}
center = {screen[1]/2, screen[2]/2}
if ui.get(affection.menu.indicators5) == "modern" then
local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1
if ui.get (affection.reference.other.double_tap[2]) then 
location = 48
else location = 39
end
dted = ui.get(affection.reference.other.double_tap[2]) == true
qped = ui.get(affection.reference.other.auto_peek[2]) == true  
dtopa = affection.table.visuals.animation_variables.movement(dtopa,dted,0,255,12)

if qped and affection.anti_aim.defensive == true then
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.15, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.15, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.15, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.15, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.15, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 + globals.frametime()/0.15, 0, 1)
elseif qped and antiaim_funcs.get_double_tap() == true then
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.15, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.15, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.15, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 + globals.frametime()/0.15, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.15, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.15, 0, 1)
elseif qped and antiaim_funcs.get_double_tap() == false then
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.15, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.15, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.15, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.15, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 + globals.frametime()/0.15, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.15, 0, 1)
elseif dted and affection.anti_aim.is_active_inds == true then
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.15, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.15, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 + globals.frametime()/0.15, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.15, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.15, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.15, 0, 1)
elseif dted and antiaim_funcs.get_double_tap() == true then
dtopa2 = script.helpers:clamp(dtopa2 + globals.frametime()/0.15, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.15, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.15, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.15, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.15, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.15, 0, 1)
elseif dted and antiaim_funcs.get_double_tap() == false then
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.15, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 + globals.frametime()/0.15, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.15, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.15, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.15, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.15, 0, 1)
else 
dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.15, 0, 1)
dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.15, 0, 1)
dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.15, 0, 1)
dtopa5 = script.helpers:clamp(dtopa5 - globals.frametime()/0.15, 0, 1)
dtopa6 = script.helpers:clamp(dtopa6 - globals.frametime()/0.15, 0, 1)
dtopa7 = script.helpers:clamp(dtopa7 - globals.frametime()/0.15, 0, 1)
end
qpopa = affection.table.visuals.animation_variables.movement(qpopa,qped,0,255,12)
rapid_mes = renderer.measure_text("-", "  DT READY")/2 - 1
rapid_mes2 = renderer.measure_text("-", "  DT CHARGING")/2 - 1
rapid_mes3 = renderer.measure_text("-", "  DT DEFENSIVE")/2 - 1
local_player = entity.get_local_player()
if not entity.is_alive(local_player) then return end
blink = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255
blink2 = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 120
r,g,b = ui.get(affection.menu.color_picker)
cen_meas = renderer.measure_text("", "affection yaw")/2  +1
cen_meas3 = renderer.measure_text("", "affection yaw")/2  
cen_meas2 = renderer.measure_text("", "affection yaw")
build_meas = renderer.measure_text("", "yaw")
state_mes = renderer.measure_text("-", string.upper(state3))/2 + 1
qp_mes = renderer.measure_text("-", "IDEALTICK READY")/2 + 2
qp_mes2 = renderer.measure_text("-", "IDEALTICK CHARGING")/2 + 2
qp_mes3 = renderer.measure_text("-", "IDEALTICK DEFENSIVE")/2 + 1
offset_qp = affection.table.visuals.animation_variables.movement(offset_qp,qped,30,location,8)
offset_center = affection.table.visuals.animation_variables.movement(offset_center,scoped,1,cen_meas,10)
offset_state = affection.table.visuals.animation_variables.movement(offset_state,scoped,0,state_mes,8)
offset_quickpeek = affection.table.visuals.animation_variables.movement(offset_quickpeek,scoped,0,qp_mes,8)
offset_quickpeek2 = affection.table.visuals.animation_variables.movement(offset_quickpeek2,scoped,0,qp_mes2,8)
offset_quickpeek3 = affection.table.visuals.animation_variables.movement(offset_quickpeek3,scoped,0,qp_mes3,8)
offset_rapid = affection.table.visuals.animation_variables.movement(offset_rapid,scoped,0,rapid_mes,8)
offset_rapid2 = affection.table.visuals.animation_variables.movement(offset_rapid2,scoped,0,rapid_mes2,8)
offset_rapid3 = affection.table.visuals.animation_variables.movement(offset_rapid3,scoped,0,rapid_mes3,8)
dtcolor = 0
dt_mes = renderer.measure_text("-", "DT ")
p_mes = renderer.measure_text("-", "IDEALTICK ")
if antiaim_funcs.get_double_tap() == false then
dtcolor = 190
else dtcolor = 255
end
charging_size = renderer.measure_text("-", "READY ")
charging_size2 = renderer.measure_text("-", "CHARGING ")
charging_size3 = renderer.measure_text("-", "DEFENSIVE ")
charging_size4 = renderer.measure_text("-", "READY ")
charging_size5 = renderer.measure_text("-", "CHARGING ")
local ret2 = script.helpers:animate_text(globals.curtime(), "CHARGING", 255, 30, 30, 255)
local ret5 = script.helpers:animate_text(globals.curtime(), "CHARGING", 255, 30, 30, 255)
renderer.text(center[1] + offset_center, center[2] + 30- 10, 255, 255, 255, 255, "c", nil, "affection " .. text_fade_animation(12,r, g,b,255, "yaw"))
renderer.text(center[1] + offset_state, center[2] + 40 - 10, 255, 255, 255, 255, "c-" , nil, string.upper(state3))
renderer.text(center[1] + offset_rapid , center[2] + 48 - 10, 255, 255, 255, dtopa2 * 255, "c-" , dt_mes + dtopa2 * charging_size, "DT \a" .. script.helpers:rgba_to_hex(120, 255, 155, dtopa2 * 255) .. "READY")
renderer.text(center[1] + offset_rapid2, center[2] + 48  - 10, 255, 255, 255, dtopa3 * 255, "c-" , dt_mes + dtopa3 * charging_size2, "DT ", unpack(ret2))
renderer.text(center[1] + offset_rapid3, center[2] + 48  - 10, 255, 255, 255, dtopa4 * 255, "c-" , dt_mes + dtopa4 * charging_size3,  "DT \a" .. script.helpers:rgba_to_hex(r, g, b, dtopa4 * 255) .. "DEFENSIVE")
renderer.text(center[1] + offset_quickpeek - 1 , center[2] + 48  - 10, 255, 255, 255, dtopa5 * 255, "c-" , p_mes + dtopa5 * charging_size4, "IDEALTICK \a" .. script.helpers:rgba_to_hex(120, 255, 155, dtopa5 * 255) .. "READY")
renderer.text(center[1] + offset_quickpeek2 - 1, center[2] + 48 - 10, 255, 255, 255, dtopa6 * 255, "c-" , p_mes + dtopa6 * charging_size5, "IDEALTICK ", unpack(ret5))
renderer.text(center[1] + offset_quickpeek3 - 1, center[2] + 48 - 10, 255, 255, 255, dtopa7 * 255, "c-" , p_mes + dtopa7 * charging_size3, "IDEALTICK \a" .. script.helpers:rgba_to_hex(r, g, b, dtopa7 * 255) .. "DEFENSIVE")
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
            
if affection.anti_aim.aa_dir > 0 then
state3 = '- manual yaw -'
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
elseif velocity < 100 and ui.get(affection.reference.other.slow_motion[2]) then
state3 = '- walking -'
else
state3 = '- run -'
end
end      
client.set_event_callback('setup_command', on_setup_command) 
client.set_event_callback("paint", animated)

--#endregion indicators