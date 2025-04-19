local ffi = require('ffi')
local bit = require('bit')
local antiaim_funcs = require('gamesense/antiaim_funcs')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
local images = require('gamesense/images')
local http = require('gamesense/http')
local ent = require ('gamesense/entity')
local vector = require 'vector'
local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'yaw', discord=''}
local username = obex_data.username

local filesystem_find = vtable_bind("filesystem_stdio.dll", "VFileSystem017", 32, "const char* (__thiscall*)(void*, const char*, int*)")
local exists = function(file)
    local int_ptr = ffi.new("int[1]")
    local res = filesystem_find(file, int_ptr)
    if res == ffi.NULL then
        return nil
    end

    return int_ptr, ffi.string(res)
end

local image_data = readfile("csgo/materials/panorama/images/icons/defensive_image.png")
if not exists("materials\\panorama\\images\\icons\\defensive_image.png") then
	local path = ("csgo/materials/panorama/images/icons/defensive_image.png"):format(path, cheat)
	http.get("http://8.218.214.22:8888/down/jGsCJ7GDHirO", function(status, response)
		if not status then
			return error("fantasy: network error, cant download image, please use vpn")
		end

		writefile("csgo/materials/panorama/images/icons/defensive_image.png", response.body)
		image_data = readfile("csgo/materials/panorama/images/icons/defensive_image.png")
	end)
end

local contain_bomb = function(ent)
	local weapons = {}
	for index = 0, 12 do
		local weapon = entity.get_prop(ent, "m_hMyWeapons", index)
		if weapon and entity.get_prop(weapon, "m_iItemDefinitionIndex") == 49 then
			return true
		end
	end

	return false
end


local success_img, defensive_image = pcall(renderer.load_png, image_data, 36, 36)
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
fantasy = {
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
        yaw_jitter_value_real = 0;
        body_yaw = "";
        body_yaw_value = 0;
        body_yaw_value_real = 0;
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
        aa_side = 0;
        aa_inverted = 0;
    };
}

fantasy.reference = {
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
        for table, values in pairs(fantasy.reference.anti_aim) do
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
dtopa8 = 0

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
function fantasy.table.visuals.animation_variables.lerp(a,b,t)
    return a + (b - a) * t
end

function fantasy.table.visuals.animation_variables.pulsate(alpha,min,max,speed)

    if alpha >= max - 2 then
        fantasy.table.visuals.new_change = false
    elseif alpha <= min  + 2 then
        fantasy.table.visuals.new_change = true
    end

    if fantasy.table.visuals.new_change == true then
        alpha = fantasy.table.visuals.animation_variables.lerp(alpha,max,globals.frametime() * speed)
    else
        alpha = fantasy.table.visuals.animation_variables.lerp(alpha,min,globals.frametime() * speed)
    end

    return alpha 
end

function fantasy.table.visuals.animation_variables.movement(offset,when,original,new_place,speed)

    if when == true then
        offset = fantasy.table.visuals.animation_variables.lerp(offset,new_place,globals.frametime() * speed)
    else
        offset = fantasy.table.visuals.animation_variables.lerp(offset,original,globals.frametime() * speed)
    end

    return offset 
end

function fantasy.table.visuals.animation_variables.fade(alpha,fade_bool,f_in,f_away,speed) 

    if fade_bool == true then 
        alpha = fantasy.table.visuals.animation_variables.lerp(alpha,f_in,globals.frametime() * speed)
    else
        alpha = fantasy.table.visuals.animation_variables.lerp(alpha,f_away,globals.frametime() * speed)
    end

    return alpha
end

-- menu elements

fantasy.menu.antiaim_elements = {}
fantasy.menu.antiaim_elements_t = {}
fantasy.menu.tab_label = ui.new_label("AA", "Anti-aimbot angles", " ")
fantasy.menu.color_picker = ui.new_color_picker("AA", "Anti-aimbot angles", " ", 175 ,175, 195, 255)
fantasy.menu.tab_selector = ui.new_combobox("AA", "Anti-aimbot angles", "\nselection", {"anti-aim", "misc", "visuals", "config"})
fantasy.menu.antiaim_enable_addons = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFKeybinds");
fantasy.menu.antiaim_manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFYaw Left");
fantasy.menu.antiaim_manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFYaw Right");
fantasy.menu.antiaim_manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFYaw Forward");
fantasy.menu.antiaim_freestanding = ui.new_hotkey("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFYaw Freestand");
fantasy.menu.antiaim_anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFAnti Backstab");
fantasy.menu.antiaim_legit_aa = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFLegit Anti-Aim");
fantasy.menu.antiaim_bomb_site_unuse = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFBomb Site E fix");
fantasy.menu.antiaim_quickpeek = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFPeek Options");
fantasy.menu.antiaim_quickpeek_addons = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFBody", "Static", "Jitter", "Opposite");
fantasy.menu.antiaim_safeknife = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFSafe Head Options");
fantasy.menu.antiaim_safeknife_options = ui.new_multiselect("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFTrigger", "Knife", "Taser");
fantasy.menu.antiaim_animation = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFAnimations");
fantasy.menu.antiaim_animation_ground = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFOn Ground", "-", "Sliding", "Modern");
fantasy.menu.antiaim_animation_air = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFIn Air", "-", "Static", "Running");
fantasy.menu.indicators = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFDefensive Indicator");
fantasy.menu.watermark = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFWatermark", "Bottom", "Side");
fantasy.menu.indicators5 = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFIndicator", "-", "Modern", "LCKSB");
fantasy.menu.indicator_main_color_label = ui.new_label("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFMain color");
fantasy.menu.indicator_main_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Main Color\nClr", 0, 255, 255, 255);
fantasy.menu.indicator_main_os_color_label = ui.new_label("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFMain(OS) color");
fantasy.menu.indicator_main_os_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Main(Os) Color\nClr", 0, 255, 0, 255);
fantasy.menu.indicator_main_dt_color_label = ui.new_label("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFMain(DT) color");
fantasy.menu.indicator_main_dt_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Main(DT) Color\nClr", 255, 0, 0, 255);
fantasy.menu.indicator_accent_color_label = ui.new_label("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFFAccent color");
fantasy.menu.indicator_accent_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Accent Color\nClr", 215, 145, 175, 255);

fantasy.menu.builder_state = {'Global', 'Stand', 'Run', 'Slow', 'Air', 'Air Crouch', 'Crouch Move', 'Crouch', 'Fakelag'}
fantasy.menu.state_to_num = { 
    ['Global'] = 1, 
    ['Stand'] = 2, 
    ['Run'] = 3, 
    ['Slow'] = 4, --export
    ['Air'] = 5,
    ['Air Crouch'] = 6,
    ['Crouch Move'] = 7,
    ['Crouch'] = 8,
    ['Fakelag'] = 9,
};
fantasy.menu.aabuilder_state = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FFState \aFFFFFFFFSelect:", fantasy.menu.builder_state)

-- anti_aim elements
for k, v in pairs(fantasy.menu.builder_state) do
    fantasy.menu.antiaim_elements[k] = {  
        enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FFEnable: "..fantasy.menu.builder_state[k].."");
        antiaim_pitch = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Pitch Type", {"L&R", "Jitter", "Delayed"});
        antiaim_pitch_slider_speed = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Pitch Speed  ", 1, 25, 0, true, "t");
        antiaim_pitch_slider_first = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." First Pitch ", -89, 89, 0, true, "°");
        antiaim_pitch_slider_second = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Second Pitch ", -89, 89, 0, true, "°");
        antiaim_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Yaw ", {"180", "Spin", "Static", "180 Z"});
        antiaim_yaw_advanced = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Yaw Type ", {"L&R", "Jitter", "Delayed"});
        antiaim_yaw_slider_speed = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Yaw Speed  ", 1, 25, 0, true, "t");
        antiaim_yaw_slider_left = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Left Yaw  ", -150, 150, 0, true, "°");
        antiaim_yaw_slider_right = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Right Yaw  ", -150, 150, 0, true, "°");
        antiaim_body_yaw_correction = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Body Yaw Correction");
        antiaim_jitter_correction = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Jitter Micro Movement");
        antiaim_yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Jitter Type ", {"Center", "Offset", "Skitter", "Random"});
        antiaim_yaw_jitter_type = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Jitter Method", {"L&R", "Jitter", "Delayed"});
        antiaim_yaw_jitter_slider_speed = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Jitter Speed  ", 1, 25, 0, true, "t");
        antiaim_yaw_jitter_slider_l = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Left Jitter ", -150, 150, 0, true, "°");
        antiaim_yaw_jitter_slider_r = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Right Jitter ", -150, 150, 0, true, "°");
        antiaim_body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Body Type ", {"Jitter", "Static", "Off"});
        antiaim_body_yaw_type = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Body Method", {"L&R", "Jitter", "Delayed"});
        antiaim_body_yaw_speed = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Body Speed  ", 1, 25, 0, true, "t");
        antiaim_body_yaw_slider_l = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Left Body", -150, 150, 0, true, "°");
        antiaim_body_yaw_slider_r = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Right Body", -150, 150, 0, true, "°");
        antiaim_defensive = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Force Breaker ", {"-", "GameSense", "NeverLose", "Fantasy"});
        antiaim_defensive_slider =  ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive LBY Ticks Addons", 0, 11, 0, true, "t", 1, {[0] = "Default"});
        antiaim_defensive_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive LBY");
        antiaim_defensive_pitch = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Pitch Type", {"L&R", "Jitter", "Delayed"});
        antiaim_defensive_pitch_slider_speed = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Pitch Speed  ", 1, 25, 0, true, "t");
        antiaim_defensive_pitch_slider_first = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive First Pitch ", -89, 89, 0, true, "°");
        antiaim_defensive_pitch_slider_second = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Second Pitch ", -89, 89, 0, true, "°");
        antiaim_defensive_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Yaw ", {"180", "Spin", "Static", "180 Z"});
        antiaim_defensive_yaw_advanced = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Yaw Type ", {"L&R", "Jitter", "Delayed"});
        antiaim_defensive_yaw_slider_speed = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Yaw Speed  ", 1, 25, 0, true, "t");
        antiaim_defensive_yaw_slider_left = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Left Yaw  ", -150, 150, 0, true, "°");
        antiaim_defensive_yaw_slider_right = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Right Yaw  ", -150, 150, 0, true, "°");
        antiaim_defensive_body_yaw_correction = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Body Yaw Correction");
        antiaim_defensive_jitter_correction = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Jitter Micro Movement");
        antiaim_defensive_yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Jitter Type ", {"Center", "Offset", "Skitter", "Random"});
        antiaim_defensive_yaw_jitter_type = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Jitter Method", {"L&R", "Jitter", "Delayed"});
        antiaim_defensive_yaw_jitter_slider_speed = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Jitter Speed  ", 1, 25, 0, true, "t");
        antiaim_defensive_yaw_jitter_slider_l = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Left Jitter ", -150, 150, 0, true, "°");
        antiaim_defensive_yaw_jitter_slider_r = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Right Jitter ", -150, 150, 0, true, "°");
        antiaim_defensive_body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Body Type ", {"Jitter", "Static", "Off"});
        antiaim_defensive_body_yaw_type = ui.new_combobox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Body Method", {"L&R", "Jitter", "Delayed"});
        antiaim_defensive_body_yaw_speed = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Jitter Speed  ", 1, 25, 0, true, "t");
        antiaim_defensive_body_yaw_slider_l = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Left Body", -150, 150, 0, true, "°");
        antiaim_defensive_body_yaw_slider_r = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Defensive Right Body", -150, 150, 0, true, "°");
        antiaim_height_asvantage = ui.new_checkbox("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Height advantage");
        antiaim_height_asvantage_slider = ui.new_slider("AA", "Anti-aimbot angles", "\aAFAFC3FF[Fantasy] \aFFFFFFFF"..fantasy.menu.builder_state[k].." Height advantage offset", 0, 300, 0, true);
    }
end

-- config data

fantasy.table.config_data.cfg_data = {
    anti_aim = {
        fantasy.menu.antiaim_elements[1].antiaim_pitch;
        fantasy.menu.antiaim_elements[1].antiaim_pitch_slider_speed;
        fantasy.menu.antiaim_elements[1].antiaim_pitch_slider_first;
        fantasy.menu.antiaim_elements[1].antiaim_pitch_slider_second;
        fantasy.menu.antiaim_elements[1].antiaim_yaw;
        fantasy.menu.antiaim_elements[1].antiaim_yaw_advanced;
        fantasy.menu.antiaim_elements[1].antiaim_yaw_slider_speed;
        fantasy.menu.antiaim_elements[1].antiaim_yaw_slider_left;
        fantasy.menu.antiaim_elements[1].antiaim_yaw_slider_right;
        fantasy.menu.antiaim_elements[1].antiaim_body_yaw_correction;
        fantasy.menu.antiaim_elements[1].antiaim_jitter_correction;
        fantasy.menu.antiaim_elements[1].antiaim_yaw_jitter;
        fantasy.menu.antiaim_elements[1].antiaim_yaw_jitter_type;
        fantasy.menu.antiaim_elements[1].antiaim_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[1].antiaim_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[1].antiaim_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[1].antiaim_body_yaw;
        fantasy.menu.antiaim_elements[1].antiaim_body_yaw_type;
        fantasy.menu.antiaim_elements[1].antiaim_body_yaw_speed;
        fantasy.menu.antiaim_elements[1].antiaim_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[1].antiaim_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[1].antiaim_defensive;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_slider;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_enable;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_pitch;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_pitch_slider_speed;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_pitch_slider_first;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_pitch_slider_second;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_yaw;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_yaw_advanced;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_yaw_slider_speed;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_yaw_slider_left;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_yaw_slider_right;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_body_yaw_correction;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_jitter_correction;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_yaw_jitter;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_yaw_jitter_type;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_body_yaw;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_body_yaw_type;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_body_yaw_speed;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[1].antiaim_defensive_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[1].antiaim_height_asvantage;
        fantasy.menu.antiaim_elements[1].antiaim_height_asvantage_slider;
        
        fantasy.menu.antiaim_elements[2].enable;
        fantasy.menu.antiaim_elements[2].antiaim_pitch;
        fantasy.menu.antiaim_elements[2].antiaim_pitch_slider_speed;
        fantasy.menu.antiaim_elements[2].antiaim_pitch_slider_first;
        fantasy.menu.antiaim_elements[2].antiaim_pitch_slider_second;
        fantasy.menu.antiaim_elements[2].antiaim_yaw;
        fantasy.menu.antiaim_elements[2].antiaim_yaw_advanced;
        fantasy.menu.antiaim_elements[2].antiaim_yaw_slider_speed;
        fantasy.menu.antiaim_elements[2].antiaim_yaw_slider_left;
        fantasy.menu.antiaim_elements[2].antiaim_yaw_slider_right;
        fantasy.menu.antiaim_elements[2].antiaim_body_yaw_correction;
        fantasy.menu.antiaim_elements[2].antiaim_jitter_correction;
        fantasy.menu.antiaim_elements[2].antiaim_yaw_jitter;
        fantasy.menu.antiaim_elements[2].antiaim_yaw_jitter_type;
        fantasy.menu.antiaim_elements[2].antiaim_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[2].antiaim_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[2].antiaim_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[2].antiaim_body_yaw;
        fantasy.menu.antiaim_elements[2].antiaim_body_yaw_type;
        fantasy.menu.antiaim_elements[2].antiaim_body_yaw_speed;
        fantasy.menu.antiaim_elements[2].antiaim_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[2].antiaim_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[2].antiaim_defensive;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_slider;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_enable;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_pitch;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_pitch_slider_speed;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_pitch_slider_first;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_pitch_slider_second;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_yaw;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_yaw_advanced;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_yaw_slider_speed;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_yaw_slider_left;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_yaw_slider_right;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_body_yaw_correction;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_jitter_correction;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_yaw_jitter;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_yaw_jitter_type;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_body_yaw;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_body_yaw_type;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_body_yaw_speed;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[2].antiaim_defensive_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[2].antiaim_height_asvantage;
        fantasy.menu.antiaim_elements[2].antiaim_height_asvantage_slider;

        fantasy.menu.antiaim_elements[3].enable;
        fantasy.menu.antiaim_elements[3].antiaim_pitch;
        fantasy.menu.antiaim_elements[3].antiaim_pitch_slider_speed;
        fantasy.menu.antiaim_elements[3].antiaim_pitch_slider_first;
        fantasy.menu.antiaim_elements[3].antiaim_pitch_slider_second;
        fantasy.menu.antiaim_elements[3].antiaim_yaw;
        fantasy.menu.antiaim_elements[3].antiaim_yaw_advanced;
        fantasy.menu.antiaim_elements[3].antiaim_yaw_slider_speed;
        fantasy.menu.antiaim_elements[3].antiaim_yaw_slider_left;
        fantasy.menu.antiaim_elements[3].antiaim_yaw_slider_right;
        fantasy.menu.antiaim_elements[3].antiaim_body_yaw_correction;
        fantasy.menu.antiaim_elements[3].antiaim_jitter_correction;
        fantasy.menu.antiaim_elements[3].antiaim_yaw_jitter;
        fantasy.menu.antiaim_elements[3].antiaim_yaw_jitter_type;
        fantasy.menu.antiaim_elements[3].antiaim_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[3].antiaim_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[3].antiaim_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[3].antiaim_body_yaw;
        fantasy.menu.antiaim_elements[3].antiaim_body_yaw_type;
        fantasy.menu.antiaim_elements[3].antiaim_body_yaw_speed;
        fantasy.menu.antiaim_elements[3].antiaim_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[3].antiaim_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[3].antiaim_defensive;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_slider;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_enable;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_pitch;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_pitch_slider_speed;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_pitch_slider_first;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_pitch_slider_second;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_yaw;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_yaw_advanced;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_yaw_slider_speed;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_yaw_slider_left;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_yaw_slider_right;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_body_yaw_correction;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_jitter_correction;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_yaw_jitter;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_yaw_jitter_type;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_body_yaw;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_body_yaw_type;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_body_yaw_speed;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[3].antiaim_defensive_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[3].antiaim_height_asvantage;
        fantasy.menu.antiaim_elements[3].antiaim_height_asvantage_slider;

        fantasy.menu.antiaim_elements[4].enable;
        fantasy.menu.antiaim_elements[4].antiaim_pitch;
        fantasy.menu.antiaim_elements[4].antiaim_pitch_slider_speed;
        fantasy.menu.antiaim_elements[4].antiaim_pitch_slider_first;
        fantasy.menu.antiaim_elements[4].antiaim_pitch_slider_second;
        fantasy.menu.antiaim_elements[4].antiaim_yaw;
        fantasy.menu.antiaim_elements[4].antiaim_yaw_advanced;
        fantasy.menu.antiaim_elements[4].antiaim_yaw_slider_speed;
        fantasy.menu.antiaim_elements[4].antiaim_yaw_slider_left;
        fantasy.menu.antiaim_elements[4].antiaim_yaw_slider_right;
        fantasy.menu.antiaim_elements[4].antiaim_body_yaw_correction;
        fantasy.menu.antiaim_elements[4].antiaim_jitter_correction;
        fantasy.menu.antiaim_elements[4].antiaim_yaw_jitter;
        fantasy.menu.antiaim_elements[4].antiaim_yaw_jitter_type;
        fantasy.menu.antiaim_elements[4].antiaim_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[4].antiaim_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[4].antiaim_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[4].antiaim_body_yaw;
        fantasy.menu.antiaim_elements[4].antiaim_body_yaw_type;
        fantasy.menu.antiaim_elements[4].antiaim_body_yaw_speed;
        fantasy.menu.antiaim_elements[4].antiaim_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[4].antiaim_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[4].antiaim_defensive;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_slider;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_enable;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_pitch;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_pitch_slider_speed;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_pitch_slider_first;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_pitch_slider_second;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_yaw;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_yaw_advanced;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_yaw_slider_speed;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_yaw_slider_left;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_yaw_slider_right;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_body_yaw_correction;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_jitter_correction;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_yaw_jitter;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_yaw_jitter_type;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_body_yaw;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_body_yaw_type;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_body_yaw_speed;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[4].antiaim_defensive_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[4].antiaim_height_asvantage;
        fantasy.menu.antiaim_elements[4].antiaim_height_asvantage_slider;

        fantasy.menu.antiaim_elements[5].enable;
        fantasy.menu.antiaim_elements[5].antiaim_pitch;
        fantasy.menu.antiaim_elements[5].antiaim_pitch_slider_speed;
        fantasy.menu.antiaim_elements[5].antiaim_pitch_slider_first;
        fantasy.menu.antiaim_elements[5].antiaim_pitch_slider_second;
        fantasy.menu.antiaim_elements[5].antiaim_yaw;
        fantasy.menu.antiaim_elements[5].antiaim_yaw_advanced;
        fantasy.menu.antiaim_elements[5].antiaim_yaw_slider_speed;
        fantasy.menu.antiaim_elements[5].antiaim_yaw_slider_left;
        fantasy.menu.antiaim_elements[5].antiaim_yaw_slider_right;
        fantasy.menu.antiaim_elements[5].antiaim_body_yaw_correction;
        fantasy.menu.antiaim_elements[5].antiaim_jitter_correction;
        fantasy.menu.antiaim_elements[5].antiaim_yaw_jitter;
        fantasy.menu.antiaim_elements[5].antiaim_yaw_jitter_type;
        fantasy.menu.antiaim_elements[5].antiaim_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[5].antiaim_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[5].antiaim_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[5].antiaim_body_yaw;
        fantasy.menu.antiaim_elements[5].antiaim_body_yaw_type;
        fantasy.menu.antiaim_elements[5].antiaim_body_yaw_speed;
        fantasy.menu.antiaim_elements[5].antiaim_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[5].antiaim_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[5].antiaim_defensive;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_slider;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_enable;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_pitch;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_pitch_slider_speed;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_pitch_slider_first;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_pitch_slider_second;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_yaw;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_yaw_advanced;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_yaw_slider_speed;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_yaw_slider_left;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_yaw_slider_right;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_body_yaw_correction;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_jitter_correction;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_yaw_jitter;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_yaw_jitter_type;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_body_yaw;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_body_yaw_type;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_body_yaw_speed;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[5].antiaim_defensive_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[5].antiaim_height_asvantage;
        fantasy.menu.antiaim_elements[5].antiaim_height_asvantage_slider;

        fantasy.menu.antiaim_elements[6].enable;
        fantasy.menu.antiaim_elements[6].antiaim_pitch;
        fantasy.menu.antiaim_elements[6].antiaim_pitch_slider_speed;
        fantasy.menu.antiaim_elements[6].antiaim_pitch_slider_first;
        fantasy.menu.antiaim_elements[6].antiaim_pitch_slider_second;
        fantasy.menu.antiaim_elements[6].antiaim_yaw;
        fantasy.menu.antiaim_elements[6].antiaim_yaw_advanced;
        fantasy.menu.antiaim_elements[6].antiaim_yaw_slider_speed;
        fantasy.menu.antiaim_elements[6].antiaim_yaw_slider_left;
        fantasy.menu.antiaim_elements[6].antiaim_yaw_slider_right;
        fantasy.menu.antiaim_elements[6].antiaim_body_yaw_correction;
        fantasy.menu.antiaim_elements[6].antiaim_jitter_correction;
        fantasy.menu.antiaim_elements[6].antiaim_yaw_jitter;
        fantasy.menu.antiaim_elements[6].antiaim_yaw_jitter_type;
        fantasy.menu.antiaim_elements[6].antiaim_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[6].antiaim_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[6].antiaim_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[6].antiaim_body_yaw;
        fantasy.menu.antiaim_elements[6].antiaim_body_yaw_type;
        fantasy.menu.antiaim_elements[6].antiaim_body_yaw_speed;
        fantasy.menu.antiaim_elements[6].antiaim_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[6].antiaim_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[6].antiaim_defensive;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_slider;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_enable;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_pitch;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_pitch_slider_speed;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_pitch_slider_first;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_pitch_slider_second;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_yaw;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_yaw_advanced;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_yaw_slider_speed;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_yaw_slider_left;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_yaw_slider_right;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_body_yaw_correction;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_jitter_correction;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_yaw_jitter;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_yaw_jitter_type;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_body_yaw;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_body_yaw_type;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_body_yaw_speed;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[6].antiaim_defensive_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[6].antiaim_height_asvantage;
        fantasy.menu.antiaim_elements[6].antiaim_height_asvantage_slider;
        
        fantasy.menu.antiaim_elements[7].enable;
        fantasy.menu.antiaim_elements[7].antiaim_pitch;
        fantasy.menu.antiaim_elements[7].antiaim_pitch_slider_speed;
        fantasy.menu.antiaim_elements[7].antiaim_pitch_slider_first;
        fantasy.menu.antiaim_elements[7].antiaim_pitch_slider_second;
        fantasy.menu.antiaim_elements[7].antiaim_yaw;
        fantasy.menu.antiaim_elements[7].antiaim_yaw_advanced;
        fantasy.menu.antiaim_elements[7].antiaim_yaw_slider_speed;
        fantasy.menu.antiaim_elements[7].antiaim_yaw_slider_left;
        fantasy.menu.antiaim_elements[7].antiaim_yaw_slider_right;
        fantasy.menu.antiaim_elements[7].antiaim_body_yaw_correction;
        fantasy.menu.antiaim_elements[7].antiaim_jitter_correction;
        fantasy.menu.antiaim_elements[7].antiaim_yaw_jitter;
        fantasy.menu.antiaim_elements[7].antiaim_yaw_jitter_type;
        fantasy.menu.antiaim_elements[7].antiaim_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[7].antiaim_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[7].antiaim_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[7].antiaim_body_yaw;
        fantasy.menu.antiaim_elements[7].antiaim_body_yaw_type;
        fantasy.menu.antiaim_elements[7].antiaim_body_yaw_speed;
        fantasy.menu.antiaim_elements[7].antiaim_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[7].antiaim_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[7].antiaim_defensive;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_slider;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_enable;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_pitch;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_pitch_slider_speed;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_pitch_slider_first;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_pitch_slider_second;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_yaw;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_yaw_advanced;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_yaw_slider_speed;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_yaw_slider_left;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_yaw_slider_right;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_body_yaw_correction;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_jitter_correction;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_yaw_jitter;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_yaw_jitter_type;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_body_yaw;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_body_yaw_type;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_body_yaw_speed;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[7].antiaim_defensive_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[7].antiaim_height_asvantage;
        fantasy.menu.antiaim_elements[7].antiaim_height_asvantage_slider;

        fantasy.menu.antiaim_elements[8].enable;
        fantasy.menu.antiaim_elements[8].antiaim_pitch;
        fantasy.menu.antiaim_elements[8].antiaim_pitch_slider_speed;
        fantasy.menu.antiaim_elements[8].antiaim_pitch_slider_first;
        fantasy.menu.antiaim_elements[8].antiaim_pitch_slider_second;
        fantasy.menu.antiaim_elements[8].antiaim_yaw;
        fantasy.menu.antiaim_elements[8].antiaim_yaw_advanced;
        fantasy.menu.antiaim_elements[8].antiaim_yaw_slider_speed;
        fantasy.menu.antiaim_elements[8].antiaim_yaw_slider_left;
        fantasy.menu.antiaim_elements[8].antiaim_yaw_slider_right;
        fantasy.menu.antiaim_elements[8].antiaim_body_yaw_correction;
        fantasy.menu.antiaim_elements[8].antiaim_jitter_correction;
        fantasy.menu.antiaim_elements[8].antiaim_yaw_jitter;
        fantasy.menu.antiaim_elements[8].antiaim_yaw_jitter_type;
        fantasy.menu.antiaim_elements[8].antiaim_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[8].antiaim_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[8].antiaim_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[8].antiaim_body_yaw;
        fantasy.menu.antiaim_elements[8].antiaim_body_yaw_type;
        fantasy.menu.antiaim_elements[8].antiaim_body_yaw_speed;
        fantasy.menu.antiaim_elements[8].antiaim_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[8].antiaim_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[8].antiaim_defensive;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_slider;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_enable;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_pitch;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_pitch_slider_speed;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_pitch_slider_first;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_pitch_slider_second;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_yaw;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_yaw_advanced;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_yaw_slider_speed;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_yaw_slider_left;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_yaw_slider_right;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_body_yaw_correction;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_jitter_correction;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_yaw_jitter;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_yaw_jitter_type;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_body_yaw;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_body_yaw_type;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_body_yaw_speed;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[8].antiaim_defensive_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[8].antiaim_height_asvantage;
        fantasy.menu.antiaim_elements[8].antiaim_height_asvantage_slider;

        fantasy.menu.antiaim_elements[9].enable;
        fantasy.menu.antiaim_elements[9].antiaim_pitch;
        fantasy.menu.antiaim_elements[9].antiaim_pitch_slider_speed;
        fantasy.menu.antiaim_elements[9].antiaim_pitch_slider_first;
        fantasy.menu.antiaim_elements[9].antiaim_pitch_slider_second;
        fantasy.menu.antiaim_elements[9].antiaim_yaw;
        fantasy.menu.antiaim_elements[9].antiaim_yaw_advanced;
        fantasy.menu.antiaim_elements[9].antiaim_yaw_slider_speed;
        fantasy.menu.antiaim_elements[9].antiaim_yaw_slider_left;
        fantasy.menu.antiaim_elements[9].antiaim_yaw_slider_right;
        fantasy.menu.antiaim_elements[9].antiaim_body_yaw_correction;
        fantasy.menu.antiaim_elements[9].antiaim_jitter_correction;
        fantasy.menu.antiaim_elements[9].antiaim_yaw_jitter;
        fantasy.menu.antiaim_elements[9].antiaim_yaw_jitter_type;
        fantasy.menu.antiaim_elements[9].antiaim_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[9].antiaim_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[9].antiaim_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[9].antiaim_body_yaw;
        fantasy.menu.antiaim_elements[9].antiaim_body_yaw_type;
        fantasy.menu.antiaim_elements[9].antiaim_body_yaw_speed;
        fantasy.menu.antiaim_elements[9].antiaim_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[9].antiaim_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[9].antiaim_defensive;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_slider;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_enable;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_pitch;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_pitch_slider_speed;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_pitch_slider_first;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_pitch_slider_second;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_yaw;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_yaw_advanced;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_yaw_slider_speed;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_yaw_slider_left;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_yaw_slider_right;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_body_yaw_correction;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_jitter_correction;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_yaw_jitter;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_yaw_jitter_type;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_yaw_jitter_slider_speed;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_yaw_jitter_slider_l;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_yaw_jitter_slider_r;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_body_yaw;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_body_yaw_type;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_body_yaw_speed;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_body_yaw_slider_l;
        fantasy.menu.antiaim_elements[9].antiaim_defensive_body_yaw_slider_r;
        fantasy.menu.antiaim_elements[9].antiaim_height_asvantage;
        fantasy.menu.antiaim_elements[9].antiaim_height_asvantage_slider;
    };

    keybindsandothertable = {};
    other_aa = {};
}

--#region configs

local export_config = ui.new_button("AA", "Anti-aimbot angles", "\aAFAFC3FFExport", function ()
    local Code = {{}, {}, {}};

    for _, main in pairs(fantasy.table.config_data.cfg_data.anti_aim) do
        if ui.get(main) ~= nil then
            table.insert(Code[1], tostring(ui.get(main)))
        end
    end

    for _, main in pairs(fantasy.table.config_data.cfg_data.keybindsandothertable) do
        if ui.get(main) ~= nil then
            table.insert(Code[2], tostring(framework.library["=>"].func.arr_to_string(main)))
        end
    end

    for _, main in pairs(fantasy.table.config_data.cfg_data.other_aa) do
        if ui.get(main) ~= nil then
            table.insert(Code[3], tostring(ui.get(main)))
        end
    end

    clipboard.set(base64.encode(json.stringify(Code)))
end);

local import_config = ui.new_button("AA", "Anti-aimbot angles", "\aAFAFC3FFImport", function ()
    local protected = function() 
        for k, v in pairs(json.parse(base64.decode(clipboard.get()))) do
            
            k = ({[1] = "anti_aim", [2] = "keybindsandothertable", [3] = "other_aa"})[k]

            for k2, v2 in pairs(v) do
                if (k == "anti_aim") then
                    if v2 == "true" then
                        ui.set(fantasy.table.config_data.cfg_data[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(fantasy.table.config_data.cfg_data[k][k2], false)
                    else
                        ui.set(fantasy.table.config_data.cfg_data[k][k2], v2)
                    end
                end
                if (k == "keybindsandothertable") then
                    ui.set(fantasy.table.config_data.cfg_data[k][k2], framework.library["=>"].func.str_to_sub(v2, ","))
                end
                if (k == "other_aa") then
                    if v2 == "true" then
                        ui.set(fantasy.table.config_data.cfg_data[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(fantasy.table.config_data.cfg_data[k][k2], false)
                    else
                        ui.set(fantasy.table.config_data.cfg_data[k][k2], v2)
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
    setup_skeet_element("vis_elem", export_config, ui.get(fantasy.menu.tab_selector) == "config", nil)
    setup_skeet_element("vis_elem", import_config, ui.get(fantasy.menu.tab_selector) == "config", nil)
    local r,g,b = ui.get(fantasy.menu.color_picker)
    if ui.is_menu_open() then
        ui.set(fantasy.menu.tab_label, text_fade_animation(8, r,g,b, 255, "FANTASY - RECODE"))
    end
    local anti_aim_tab = ui.get(fantasy.menu.tab_selector) == "anti-aim"
    local misc_tab = ui.get(fantasy.menu.tab_selector) == "misc"
    local visuals_tab = ui.get(fantasy.menu.tab_selector) == "visuals"
    local main_tab = ui.get(fantasy.menu.tab_selector) == "welcome"
    local yaw_addons_enabled = ui.get(fantasy.menu.antiaim_enable_addons)
    for i = 1,#fantasy.menu.builder_state do
        -- anti_aim elements
        local selecte = ui.get(fantasy.menu.aabuilder_state)
        local conditions_enabled_ct = ui.get(fantasy.menu.antiaim_elements[i].enable)
        local show_ct = anti_aim_tab and selecte == fantasy.menu.builder_state[i] and conditions_enabled_ct 
       
        -- counter
        ui.set_visible(fantasy.menu.antiaim_elements[i].enable, anti_aim_tab and selecte == fantasy.menu.builder_state[i] and i > 1)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_pitch, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_pitch_slider_speed, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_pitch) == "Delayed")
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_pitch_slider_first, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_pitch_slider_second, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_yaw, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_yaw_advanced, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_yaw_slider_speed, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_yaw_advanced) == "Delayed")
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_yaw_slider_left, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_yaw_slider_right, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_body_yaw_correction, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_jitter_correction, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_yaw_jitter, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_yaw_jitter_type, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_yaw_jitter_slider_speed, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_yaw_jitter_type) == "Delayed")
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_yaw_jitter_slider_r, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_yaw_jitter_slider_l, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_body_yaw, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_body_yaw_type, show_ct and not ui.get(fantasy.menu.antiaim_elements[i].antiaim_body_yaw_correction))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_body_yaw_speed, show_ct and not ui.get(fantasy.menu.antiaim_elements[i].antiaim_body_yaw_correction) and ui.get(fantasy.menu.antiaim_elements[i].antiaim_body_yaw_type) == "Delayed")
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_body_yaw_slider_l, show_ct and not ui.get(fantasy.menu.antiaim_elements[i].antiaim_body_yaw_correction))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_body_yaw_slider_r, show_ct and not ui.get(fantasy.menu.antiaim_elements[i].antiaim_body_yaw_correction))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive, show_ct and selecte ~= 'Fakelag')
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_slider, show_ct and selecte ~= 'Fakelag')
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable, show_ct and selecte ~= 'Fakelag')
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_pitch, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_pitch_slider_speed, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable) and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_pitch) == "Delayed")
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_pitch_slider_first, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_pitch_slider_second, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw_advanced, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw_slider_speed, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable) and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw_advanced) == "Delayed")
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw_slider_left, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw_slider_right, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_body_yaw_correction, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_jitter_correction, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw_jitter, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw_jitter_type, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw_jitter_slider_speed, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable) and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw_jitter_type) == "Delayed")
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw_jitter_slider_r, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_yaw_jitter_slider_l, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_body_yaw, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_body_yaw_type, show_ct and not ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_body_yaw_correction) and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_body_yaw_speed, show_ct and not ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_body_yaw_correction) and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable) and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_body_yaw_type) == "Delayed")
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_body_yaw_slider_l, show_ct and not ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_body_yaw_correction) and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_defensive_body_yaw_slider_r, show_ct and not ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_body_yaw_correction) and ui.get(fantasy.menu.antiaim_elements[i].antiaim_defensive_enable))
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_height_asvantage, show_ct)
        ui.set_visible(fantasy.menu.antiaim_elements[i].antiaim_height_asvantage_slider, show_ct and ui.get(fantasy.menu.antiaim_elements[i].antiaim_height_asvantage))
    end

    -- other elements
    ui.set_visible(fantasy.menu.antiaim_anti_knife, misc_tab)
    ui.set_visible(fantasy.menu.antiaim_legit_aa, misc_tab)
    ui.set_visible(fantasy.menu.antiaim_bomb_site_unuse, misc_tab)
    ui.set_visible(fantasy.menu.antiaim_quickpeek, misc_tab)
    ui.set_visible(fantasy.menu.antiaim_quickpeek_addons, misc_tab and ui.get(fantasy.menu.antiaim_quickpeek))
    ui.set_visible(fantasy.menu.aabuilder_state, anti_aim_tab)
    ui.set_visible(fantasy.menu.antiaim_enable_addons, anti_aim_tab)
    ui.set_visible(fantasy.menu.antiaim_manual_left, anti_aim_tab and yaw_addons_enabled)
    ui.set_visible(fantasy.menu.antiaim_manual_right, anti_aim_tab and yaw_addons_enabled)
    ui.set_visible(fantasy.menu.antiaim_manual_forward, anti_aim_tab and yaw_addons_enabled)
    ui.set_visible(fantasy.menu.antiaim_freestanding, anti_aim_tab and yaw_addons_enabled)
    ui.set_visible(fantasy.menu.antiaim_safeknife, misc_tab)
    ui.set_visible(fantasy.menu.antiaim_animation, misc_tab)
    ui.set_visible(fantasy.menu.antiaim_animation_ground, misc_tab and ui.get(fantasy.menu.antiaim_animation))
    ui.set_visible(fantasy.menu.antiaim_animation_air, misc_tab and ui.get(fantasy.menu.antiaim_animation))
    ui.set_visible(fantasy.menu.antiaim_safeknife_options, misc_tab and ui.get(fantasy.menu.antiaim_safeknife))
    ui.set_visible(fantasy.menu.indicators5, visuals_tab)
    ui.set_visible(fantasy.menu.indicators, visuals_tab)
    ui.set_visible(fantasy.menu.indicator_main_color_label, visuals_tab and ui.get(fantasy.menu.indicators5) == "LCKSB")
    ui.set_visible(fantasy.menu.indicator_main_color, visuals_tab and ui.get(fantasy.menu.indicators5) == "LCKSB")
    ui.set_visible(fantasy.menu.indicator_main_os_color_label, visuals_tab and ui.get(fantasy.menu.indicators5) == "LCKSB")
    ui.set_visible(fantasy.menu.indicator_main_os_color, visuals_tab and ui.get(fantasy.menu.indicators5) == "LCKSB")
    ui.set_visible(fantasy.menu.indicator_main_dt_color_label, visuals_tab and ui.get(fantasy.menu.indicators5) == "LCKSB")
    ui.set_visible(fantasy.menu.indicator_main_dt_color, visuals_tab and ui.get(fantasy.menu.indicators5) == "LCKSB")
    ui.set_visible(fantasy.menu.indicator_accent_color_label, visuals_tab and ui.get(fantasy.menu.indicators5) == "LCKSB")
    ui.set_visible(fantasy.menu.indicator_accent_color, visuals_tab and ui.get(fantasy.menu.indicators5) == "LCKSB")
    ui.set_visible(fantasy.menu.watermark, visuals_tab)
end)

setup_skeet_element("elem", fantasy.reference.anti_aim.master, true, nil)
setup_skeet_element("elem", fantasy.menu.antiaim_elements[1].enable, true, nil)
setup_skeet_element("vis_elem", fantasy.menu.antiaim_elements[1].enable, false, nil)

--#endregion visible

--#region events

-- custom anti_aims
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
    local slowwalk_key = ui.get(fantasy.reference.other.slow_motion[2])
    local teamnum = entity.get_prop(lp, 'm_iTeamNum')
    local vec_velocity = { entity.get_prop(lp, 'm_vecVelocity') }
    local teamnum = entity.get_prop(lp, 'm_iTeamNum') 
    local duck_amount = entity.get_prop(lp, 'm_flDuckAmount')
    local velocity = math.floor(math.sqrt(vec_velocity[1] ^ 2 + vec_velocity[2] ^ 2) + 0.5)
    local air = bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 0
    if air == false then
        fantasy.anti_aim.ground_time = fantasy.anti_aim.ground_time + 1
    else
        fantasy.anti_aim.ground_time = 0
    end
    if not ui.get(fantasy.reference.other.bunny_hop) then
        on_ground = bit.band(entity.get_prop(lp, "m_fFlags"), 1) == 1
    end


    if not ui.get(fantasy.reference.other.double_tap[2]) and not ui.get(fantasy.reference.other.hide_shots[2]) then
        state = 'Fakelag'
    elseif fantasy.anti_aim.ground_time < 8 and duck_amount > 0 then
        state = 'Air Crouch'
    elseif fantasy.anti_aim.ground_time < 8 then
        state = 'Air'
    elseif duck_amount > 0 and velocity <= 2 then
        state = 'Crouch'
    elseif duck_amount > 0 and velocity >= 2 then
        state = 'Crouch Move'
    elseif ui.get(fantasy.reference.other.fakeducking)then 
        state = 'Crouch'
    elseif not_moving then   
        state = 'Stand'
    elseif not not_moving then
        if slowwalk_key then
        state = 'Slow'
    else
        state = 'Run'
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
        fantasy.anti_aim.defensive_ticks = globals.tickcount() + toticks(.200);
    end
end

client.set_event_callback( "net_update_start", function(  )
    do_defensive()
end)

local lerp = function(a, b, t)
    if type(a) == 'table' then
        local result = {}
        for k, v in pairs(a) do
            result[k] = a[k] + (b[k] - a[k]) * t
        end
        return result
    elseif type(a) == 'cdata' then
        return vector(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t, a.z + (b.z - a.z) * t)
    else
        return a + (b - a) * t
    end
end

local last_this_status = "DEF"
local bombsite_unuse = function(e)
	local self = entity.get_local_player()
	if not entity.is_alive(self) then
		return false
	end

	local resource = entity.get_player_resource()
	local site = {
		vector(entity.get_prop(resource, "m_bombsiteCenterA")),
		vector(entity.get_prop(resource, "m_bombsiteCenterB"))
	}

	local has_bomb = contain_bomb(self)
	local origin = vector(entity.get_origin(self))
	for _, pos in pairs(site) do
		local distance = pos:dist(origin)
		if has_bomb and distance < 200 and e.in_use == 1 then
			e.in_use = 0
			return true
		end
	end

	return false
end

client.set_event_callback( "setup_command", function( arg )
    if entity.is_alive(entity.get_local_player()) then 

    if globals.tickcount() - fantasy.anti_aim.tick_var > 0 and arg.chokedcommands == 1 then
        fantasy.anti_aim.is_invert = not fantasy.anti_aim.is_invert
        fantasy.anti_aim.tick_var = globals.tickcount()
    elseif globals.tickcount() - fantasy.anti_aim.tick_var < -1 then
        fantasy.anti_aim.tick_var = globals.tickcount()
    end

    if arg.chokedcommands == 1 then
        fantasy.anti_aim.tick_variables = fantasy.anti_aim.tick_variables + 1
    end

    if fantasy.anti_aim.tick_variables > 6 then
        fantasy.anti_aim.tick_variables = 0
    end

    local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    
    fantasy.anti_aim.aa_inverted = body_yaw > 0
    fantasy.anti_aim.aa_side = fantasy.anti_aim.aa_inverted and 1 or -1
    local m_flSimulationTime = entity.get_prop(player, "m_flSimulationTime");
    fantasy.anti_aim.cur_team = entity.get_prop(entity.get_local_player(), "m_iTeamNum") 
    local build_number = get_anti_aimbuilder_state()
    last_this_status = build_number
    fantasy.anti_aim.state_id = ui.get(fantasy.menu.antiaim_elements[fantasy.menu.state_to_num[build_number] ].enable) and fantasy.menu.state_to_num[build_number] or fantasy.menu.state_to_num['Global'];


    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_pitch) == "L&R" then
        fantasy.anti_aim.pitch_value = fantasy.anti_aim.aa_side ~= 1 and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_pitch_slider_first) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_pitch_slider_second)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_pitch) == "Jitter" then
        fantasy.anti_aim.pitch_value = fantasy.anti_aim.is_invert and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_pitch_slider_first) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_pitch_slider_second)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_pitch) == "Delayed" then
        fantasy.anti_aim.pitch_value = manipulation_break(ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_pitch_slider_first), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_pitch_slider_second), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_pitch_slider_speed))
    end

    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_advanced) == "L&R" then
        fantasy.anti_aim.yaw_value = fantasy.anti_aim.aa_side ~= 1 and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_slider_left) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_slider_right)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_advanced) == "Jitter" then
        fantasy.anti_aim.yaw_value = fantasy.anti_aim.is_invert and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_slider_left) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_slider_right)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_advanced) == "Delayed" then
        fantasy.anti_aim.yaw_value = manipulation_break(ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_slider_left), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_slider_right), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_slider_speed))
    end
    
    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_jitter_type) == "L&R" then
        fantasy.anti_aim.yaw_jitter_value = fantasy.anti_aim.aa_side ~= 1 and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_jitter_slider_l) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_jitter_type) == "Jitter" then
        fantasy.anti_aim.yaw_jitter_value = fantasy.anti_aim.is_invert and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_jitter_slider_l) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_jitter_slider_r)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_jitter_type) == "Delayed" then
        fantasy.anti_aim.yaw_jitter_value = manipulation_break(ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_jitter_slider_l), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_jitter_slider_r), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_jitter_slider_speed))
    end

    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw_type) == "L&R" then
        fantasy.anti_aim.body_yaw_value = fantasy.anti_aim.aa_side ~= 1 and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw_slider_l) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw_slider_r)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw_type) == "Jitter" then
        fantasy.anti_aim.body_yaw_value = fantasy.anti_aim.is_invert and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw_slider_l) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw_slider_r)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw_type) == "Delayed" then
        fantasy.anti_aim.body_yaw_value = manipulation_break(ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw_slider_l), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw_slider_r), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw_speed))
    end

    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_jitter_correction) then
    fantasy.anti_aim.yaw_jitter_value_real = fantasy.anti_aim.yaw_jitter_value + client.random_int(0,math.random(5,10)) * 1.2 
    else
    fantasy.anti_aim.yaw_jitter_value_real = fantasy.anti_aim.yaw_jitter_value 
    end
    
    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw_correction) then
    fantasy.anti_aim.body_yaw_value_real = fantasy.anti_aim.is_invert and -1 or 1
    else 
    fantasy.anti_aim.body_yaw_value_real = fantasy.anti_aim.body_yaw_value 
    end

    fantasy.anti_aim.yaw = ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw)
    fantasy.anti_aim.yaw_jitter = ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_yaw_jitter)
    fantasy.anti_aim.body_yaw = ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_body_yaw)

    fantasy.anti_aim.defensive = fantasy.anti_aim.defensive_ticks - ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_slider) > globals.tickcount()
    if fantasy.anti_aim.defensive then
        fantasy.anti_aim.is_active = true
    else
        fantasy.anti_aim.is_active = false
    end

    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_enable) and fantasy.anti_aim.defensive and ui.get(fantasy.reference.other.double_tap[2]) then
    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_pitch) == "L&R" then
        fantasy.anti_aim.pitch_value = fantasy.anti_aim.aa_side ~= 1 and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_pitch_slider_first) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_pitch_slider_second)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_pitch) == "Jitter" then
        fantasy.anti_aim.pitch_value = fantasy.anti_aim.is_invert and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_pitch_slider_first) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_pitch_slider_second)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_pitch) == "Delayed" then
        fantasy.anti_aim.pitch_value = manipulation_break(ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_pitch_slider_first), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_pitch_slider_second), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_pitch_slider_speed))
    end
    
    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_advanced) == "L&R" then
        fantasy.anti_aim.yaw_value = fantasy.anti_aim.aa_side ~= 1 and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_slider_left) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_slider_right)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_advanced) == "Jitter" then
        fantasy.anti_aim.yaw_value = fantasy.anti_aim.is_invert and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_slider_left) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_slider_right)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_advanced) == "Delayed" then
        fantasy.anti_aim.yaw_value = manipulation_break(ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_slider_left), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_slider_right), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_slider_speed))
    end
    
    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_jitter_type) == "L&R" then
        fantasy.anti_aim.yaw_jitter_value = fantasy.anti_aim.aa_side ~= 1 and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_jitter_slider_l) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_jitter_slider_r)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_jitter_type) == "Jitter" then
        fantasy.anti_aim.yaw_jitter_value = fantasy.anti_aim.is_invert and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_jitter_slider_l) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_jitter_slider_r)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_jitter_type) == "Delayed" then
        fantasy.anti_aim.yaw_jitter_value = manipulation_break(ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_jitter_slider_l), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_jitter_slider_r), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_jitter_slider_speed))
    end
    
    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw_type) == "L&R" then
        fantasy.anti_aim.body_yaw_value = fantasy.anti_aim.aa_side ~= 1 and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw_slider_l) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw_slider_r)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw_type) == "Jitter" then
        fantasy.anti_aim.body_yaw_value = fantasy.anti_aim.is_invert and ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw_slider_l) or ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw_slider_r)
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw_type) == "Delayed" then
        fantasy.anti_aim.body_yaw_value = manipulation_break(ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw_slider_l), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw_slider_r), ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw_speed))
    end
    
    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_jitter_correction) then
    fantasy.anti_aim.yaw_jitter_value_real = fantasy.anti_aim.yaw_jitter_value + client.random_int(0,math.random(5,10)) * 1.2 
    else
    fantasy.anti_aim.yaw_jitter_value_real = fantasy.anti_aim.yaw_jitter_value 
    end
    
    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw_correction) then
    fantasy.anti_aim.body_yaw_value_real = fantasy.anti_aim.is_invert and -1 or 1
    else 
    fantasy.anti_aim.body_yaw_value_real = fantasy.anti_aim.body_yaw_value 
    end
    
    fantasy.anti_aim.yaw = ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw)
    fantasy.anti_aim.yaw_jitter = ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_yaw_jitter)
    fantasy.anti_aim.body_yaw = ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive_body_yaw)
    end



    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive) == "GameSense" then
        fantasy.anti_aim.defensive_ct = true
        fantasy.anti_aim.is_active_inds = true
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive) == "NeverLose" then
        fantasy.anti_aim.is_active_inds = true
        if globals.tickcount() % 2 == 1 then
            fantasy.anti_aim.defensive_ct = true
        else
            fantasy.anti_aim.defensive_ct = false
        end
    elseif ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_defensive) == "Fantasy" then
        fantasy.anti_aim.is_active_inds = true
        if globals.tickcount() % 3 == 1 then
            fantasy.anti_aim.defensive_ct = true
        else
            fantasy.anti_aim.defensive_ct = false
        end
    else
        fantasy.anti_aim.defensive_ct = false
        fantasy.anti_aim.is_active_inds = false
    end
        arg.force_defensive = fantasy.anti_aim.defensive_ct;
    end

    
    fantasy.anti_aim.pitch = "Custom"
    fantasy.anti_aim.yaw_base = "At Targets"


    if ui.get(fantasy.reference.other.auto_peek[2]) and ui.get(fantasy.menu.antiaim_quickpeek) then
        fantasy.anti_aim.yaw_value = 0
        fantasy.anti_aim.yaw_base = "At Targets"
        fantasy.anti_aim.yaw_jitter = "Off"
        fantasy.anti_aim.yaw_jitter_value_real = 0
        fantasy.anti_aim.body_yaw = ui.get(fantasy.menu.antiaim_quickpeek_addons)
        fantasy.anti_aim.body_yaw_value_real = 0
        fantasy.anti_aim.is_active_inds = true
        quick_peek_addons = true
    else quick_peek_addons = false
    end

    ui.set(fantasy.menu.antiaim_manual_left, "On hotkey")
	ui.set(fantasy.menu.antiaim_manual_right, "On hotkey")
    ui.set(fantasy.menu.antiaim_manual_forward, "On hotkey")
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"),1) == 1 and not client.key_state(0x20)
	local p_key = client.key_state(69)

	
       if ui.get(fantasy.menu.antiaim_manual_right) and fantasy.anti_aim.last_press + 0.2 < globals.curtime() then
        fantasy.anti_aim.aa_dir = fantasy.anti_aim.aa_dir == 2 and 0 or 2
			fantasy.anti_aim.last_press = globals.curtime()
		elseif ui.get(fantasy.menu.antiaim_manual_left) and fantasy.anti_aim.last_press + 0.2 < globals.curtime() then
			fantasy.anti_aim.aa_dir = fantasy.anti_aim.aa_dir == 1 and 0 or 1
			fantasy.anti_aim.last_press = globals.curtime()
		elseif ui.get(fantasy.menu.antiaim_manual_forward) and fantasy.anti_aim.last_press + 0.2 < globals.curtime() then
			fantasy.anti_aim.aa_dir = fantasy.anti_aim.aa_dir == 3 and 0 or 3
			fantasy.anti_aim.last_press = globals.curtime()
		elseif fantasy.anti_aim.last_press > globals.curtime() then
			fantasy.anti_aim.last_press = globals.curtime()
        end

	if fantasy.anti_aim.aa_dir == 1 or fantasy.anti_aim.aa_dir == 2 or fantasy.anti_aim.aa_dir == 3 then
		if fantasy.anti_aim.aa_dir == 1 then
            fantasy.anti_aim.yaw_value = -90
            fantasy.anti_aim.yaw = "180"
            fantasy.anti_aim.yaw_base = "Local View"
            fantasy.anti_aim.yaw_jitter = "Off"
            fantasy.anti_aim.yaw_jitter_value_real = 0
            fantasy.anti_aim.body_yaw = "Static"
            fantasy.anti_aim.body_yaw_value_real = 0
		elseif fantasy.anti_aim.aa_dir == 2 then
			fantasy.anti_aim.yaw_value = 90
            fantasy.anti_aim.yaw = "180"
            fantasy.anti_aim.yaw_base = "Local View"
            fantasy.anti_aim.yaw_jitter = "Off"
            fantasy.anti_aim.yaw_jitter_value_real = 0
            fantasy.anti_aim.body_yaw = "Static"
            fantasy.anti_aim.body_yaw_value_real = 0
		elseif fantasy.anti_aim.aa_dir == 3 then
			fantasy.anti_aim.yaw_value = 180
            fantasy.anti_aim.yaw = "180"
            fantasy.anti_aim.yaw_base = "Local View"
            fantasy.anti_aim.yaw_jitter = "Off"
            fantasy.anti_aim.yaw_jitter_value_real = 0
            fantasy.anti_aim.body_yaw = "Static"
            fantasy.anti_aim.body_yaw_value_real = 0
		end
    end

	local should_legit = true
	local origin = vector(entity.get_origin(entity.get_local_player()))
	local bombs = entity.get_all("CPlantedC4")
	for _, ptr in pairs(bombs) do
		local bomb_origin = vector(entity.get_origin(ptr))
		if bomb_origin:dist(origin) < 150 then
			should_legit = false
			break
		end
	end

    local is_bomb_site = false
    if ui.get(fantasy.menu.antiaim_bomb_site_unuse) then
	is_bomb_site = bombsite_unuse(arg)
    end
    
    if ui.get(fantasy.menu.antiaim_safeknife) then
        local lp = entity.get_local_player()
        local weapon = entity.get_player_weapon(lp)
        if contains(ui.get(fantasy.menu.antiaim_safeknife_options), "Knife") and get_anti_aimbuilder_state() == "Air Crouch" then
        if entity.get_classname(weapon) == "CKnife" then
            fantasy.anti_aim.yaw_value = 4
            fantasy.anti_aim.pitch = "Custom"
            fantasy.anti_aim.yaw = "180"
            fantasy.anti_aim.pitch_value = 89
            fantasy.anti_aim.yaw_jitter = "Offset"
            fantasy.anti_aim.yaw_jitter_value_real = 3
            fantasy.anti_aim.body_yaw = "Static"
            fantasy.anti_aim.body_yaw_value_real = 0
        end
        end
        if contains(ui.get(fantasy.menu.antiaim_safeknife_options), "Taser") and get_anti_aimbuilder_state() == "Air Crouch" then
        if entity.get_classname(weapon) == "CWeaponTaser" then
            fantasy.anti_aim.yaw_value = 4
            fantasy.anti_aim.pitch = "Custom"
            fantasy.anti_aim.yaw = "180"
            fantasy.anti_aim.pitch_value = 89
            fantasy.anti_aim.yaw_jitter = "Offset"
            fantasy.anti_aim.yaw_jitter_value_real = 3
            fantasy.anti_aim.body_yaw = "Static"
            fantasy.anti_aim.body_yaw_value_real = 0
        end
        end
    end

    if ui.get(fantasy.menu.antiaim_anti_knife) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = (math.sqrt((x - lx)^2 + (y - ly)^2 + (z - lz)^2))
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 180 then
                fantasy.anti_aim.yaw_value = 180
                fantasy.anti_aim.pitch = "Off"
                fantasy.anti_aim.yaw_base = "At targets"
            end
        end
    end

    local last_origin = vector(0, 0, 0)
    local origin = vector(entity.get_origin(entity.get_local_player()))
    local threat = client.current_threat()
    local height_to_threat = 0

    if arg.chokedcommands == 0 then
        last_origin = origin
    end

    if threat then
        local threat_origin = vector(entity.get_origin(threat))
        height_to_threat = origin.z-threat_origin.z
    end

    local freestanding_bodyyaw = false
    if ui.get(fantasy.menu.antiaim_legit_aa) and should_legit and not is_bomb_site then
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

    elseif is_bomb_site and ui.get(fantasy.menu.antiaim_legit_aa) then
	freestanding_bodyyaw = true
	fantasy.anti_aim.yaw = "Off"
	fantasy.anti_aim.pitch = "Off"
	fantasy.anti_aim.yaw_value = 0
	fantasy.anti_aim.yaw_jitter = "Off"
	fantasy.anti_aim.body_yaw = "Static"
	fantasy.anti_aim.yaw_base = "Local view"
	fantasy.anti_aim.body_yaw_value_real = - 60
    end

   
    if ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_height_asvantage) and threat and height_to_threat > ui.get(fantasy.menu.antiaim_elements[fantasy.anti_aim.state_id].antiaim_height_asvantage_slider) and fantasy.anti_aim.aa_dir == 0 then
        ui.set(fantasy.reference.anti_aim.pitch[1], "Custom");
        ui.set(fantasy.reference.anti_aim.pitch[2], 89);
        ui.set(fantasy.reference.anti_aim.yaw_base, "At targets");
        ui.set(fantasy.reference.anti_aim.yaw[1], "180");
        ui.set(fantasy.reference.anti_aim.yaw[2], 0);
        ui.set(fantasy.reference.anti_aim.yaw_jitter[1], "Off");
        ui.set(fantasy.reference.anti_aim.yaw_jitter[2], 0);
        ui.set(fantasy.reference.anti_aim.body_yaw[1], "Static");
        ui.set(fantasy.reference.anti_aim.body_yaw[2], 0);
        ui.set(fantasy.reference.anti_aim.freestanding_body_yaw, false);
        ui.set(fantasy.reference.anti_aim.freestanding[2], ui.get(fantasy.menu.antiaim_freestanding) and "Always On" or "On hotkey");
        ui.set(fantasy.reference.anti_aim.freestanding[1], ui.get(fantasy.menu.antiaim_freestanding) and true);
        ui.set(fantasy.reference.anti_aim.roll_offset, 0);
    else
        ui.set(fantasy.reference.anti_aim.pitch[1], fantasy.anti_aim.pitch);
        ui.set(fantasy.reference.anti_aim.pitch[2], fantasy.anti_aim.pitch_value);
        ui.set(fantasy.reference.anti_aim.yaw_base, fantasy.anti_aim.yaw_base);
        ui.set(fantasy.reference.anti_aim.yaw[1], fantasy.anti_aim.yaw);
        ui.set(fantasy.reference.anti_aim.yaw[2], fantasy.anti_aim.yaw_value);
        ui.set(fantasy.reference.anti_aim.yaw_jitter[1], fantasy.anti_aim.yaw_jitter);
        ui.set(fantasy.reference.anti_aim.yaw_jitter[2], fantasy.anti_aim.yaw_jitter_value_real);
        ui.set(fantasy.reference.anti_aim.body_yaw[1], fantasy.anti_aim.body_yaw);
        ui.set(fantasy.reference.anti_aim.body_yaw[2], fantasy.anti_aim.body_yaw_value_real);
        ui.set(fantasy.reference.anti_aim.freestanding_body_yaw, freestanding_bodyyaw);
        ui.set(fantasy.reference.anti_aim.freestanding[2], ui.get(fantasy.menu.antiaim_freestanding) and "Always On" or "On hotkey");
        ui.set(fantasy.reference.anti_aim.freestanding[1], ui.get(fantasy.menu.antiaim_freestanding) and true);
        ui.set(fantasy.reference.anti_aim.roll_offset, 0);
    end
end)
client.set_event_callback("shutdown", function ()
    setup_skeet_element("vis", nil, nil, "unload")
end)
defensive_opa = 0
defensive_opa2 = 0
defensive_opa3 = 0
defensive_indicator = function()
        if not ui.get(fantasy.menu.indicators) then
            return
        end
        X,Y = screen[1], screen[2]
        value2 = 0
        draw_art = fantasy.table.visuals.to_draw_ticks * 50/90 
        if is_active then
            value2 = 0.4
        else value2 = 5 
        end
        
        is_active = fantasy.anti_aim.is_active_inds == true and ui.get(fantasy.reference.other.double_tap[2]) 
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
        local r, g, b = ui.get(fantasy.menu.color_picker)
        local jedi_icon = '<svg t="1650815150236" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1757" width="1000" height="1000"><path d="M398.5 373.6c95.9-122.1 17.2-233.1 17.2-233.1 45.4 85.8-41.4 170.5-41.4 170.5 105-171.5-60.5-271.5-60.5-271.5 96.9 72.7-10.1 190.7-10.1 190.7 85.8 158.4-68.6 230.1-68.6 230.1s-.4-16.9-2.2-85.7c4.3 4.5 34.5 36.2 34.5 36.2l-24.2-47.4 62.6-9.1-62.6-9.1 20.2-55.5-31.4 45.9c-2.2-87.7-7.8-305.1-7.9-306.9v-2.4 1-1 2.4c0 1-5.6 219-7.9 306.9l-31.4-45.9 20.2 55.5-62.6 9.1 62.6 9.1-24.2 47.4 34.5-36.2c-1.8 68.8-2.2 85.7-2.2 85.7s-154.4-71.7-68.6-230.1c0 0-107-118.1-10.1-190.7 0 0-165.5 99.9-60.5 271.5 0 0-86.8-84.8-41.4-170.5 0 0-78.7 111 17.2 233.1 0 0-26.2-16.1-49.4-77.7 0 0 16.9 183.3 222 185.7h4.1c205-2.4 222-185.7 222-185.7-23.6 61.5-49.9 77.7-49.9 77.7z" p-id="1758" fill="#ffffff"></path></svg>'
        local jedi_icon2 = renderer.load_svg(jedi_icon,50,50)
        script.renderer:glow_module(X / 2 - 55, Y / 2 - 220, defensive_opa * 110, 0, 10, 0, {r, g, b, defensive_opa * 100}, {r, g, b, defensive_opa * 100})
        rounded_rectangle(X / 2 - 55, Y / 2 - 220, r, g, b, defensive_opa * 140, defensive_opa * 110, 2, 1)
    
        renderer.texture(defensive_image, (X / 2) - 18, Y / 2 - 268, 36, 36, 255, 255, 255, defensive_opa2 * 255, "f")
        

        charged_mes = renderer.measure_text("", "defensive manager ") + renderer.measure_text("", "ready  ")
        exploit_mes = renderer.measure_text("", "defensive manager ") 
        local ret = script.helpers:animate_text(globals.curtime(), "ready", r, g, b, defensive_opa2 * 255)
        renderer.text(X / 2, Y / 2 - 230,255, 255, 255, defensive_opa2 * 255, "c",  defensive_opa2 * charged_mes + 1, "defensive manager ", unpack(ret))
        fantasy.table.visuals.to_draw_ticks = fantasy.table.visuals.to_draw_ticks + 1
        if fantasy.table.visuals.to_draw_ticks == 200 then
            fantasy.table.visuals.to_draw_ticks = 0
        end
    end

--#endregion events

--#region misc

client.set_event_callback("pre_render", function()
    if ui.get(fantasy.menu.antiaim_animation) then 
    if not entity.is_alive(entity.get_local_player()) then return end
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1
    local ref_legs = ui.reference("AA", "other", "leg movement")
    if ui.get(fantasy.menu.antiaim_animation_ground) == "Sliding" and on_ground then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0) 
        ui.set(ref_legs, "Always Slide")
    elseif ui.get(fantasy.menu.antiaim_animation_ground) == "Modern" and on_ground then  
        ui.set(ref_legs, client.random_int(1, 2) == 1 and "Off" or "Always slide")
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1 - client.random_float(0.5, 1), 0)
    else ui.set(ref_legs, "Off")
    end
    local self_index = ent.new(entity.get_local_player())
    if bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 0 then
    if ui.get(fantasy.menu.antiaim_animation_air) == "Static" then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
    end
    end
    
    if ui.get(fantasy.menu.antiaim_animation_air) == "Running" then
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
mleft = 0
mright = 0
mfor = 0
offset_hs = 0

local vector = require "vector"
local indicator_data = {
	anims = {},
	text_anims = {},
	last_velocity = 0,
	last_reset_time = 0,
	chokeds = {0, 0, 0, 0, 0}
}

local container = function(x, y, w, h, r, g, b, a, text)
	renderer.rectangle(x, y, w, 1, r, g, b, a)
	renderer.gradient(x, y, 1, h, r, g, b, a, r, g, b, 0, false)
	renderer.gradient(x + w, y, 1, h, r, g, b, a, r, g, b, 0, false)
	renderer.text(x + ((w / 2) * (a / 255)), y + (h / 2), 255, 255, 255, a, "c", 0, text)
end

local function lerp(a, b, t)
	if type(a) == "table" then
		return {
			a[1] + (b[1] - a[1]) * t,
			a[2] + (b[2] - a[2]) * t,
			a[3] + (b[3] - a[3]) * t,
			a[4] + (b[4] - a[4]) * t
		}
	end

	return a + (b - a) * t
end

local anim_new = function(name, value, fraction)
	if not indicator_data.anims[name] then
		indicator_data.anims[name] = value
	end

	indicator_data.anims[name] = lerp(indicator_data.anims[name], value, globals.frametime() * (fraction / 10))
	return indicator_data.anims[name]
end

local text_animation = function(name, text, fraction)
	if not indicator_data.text_anims[name] then
		indicator_data.text_anims[name] = {
			text = "",
			fraction = 0
		}
	end

	if indicator_data.text_anims[name].text ~= text then
		indicator_data.text_anims[name].text = text
		indicator_data.text_anims[name].fraction = 0
	end

	indicator_data.text_anims[name].fraction = lerp(indicator_data.text_anims[name].fraction, 1, globals.frametime() * (fraction / 10))
	return indicator_data.text_anims[name].fraction
end

local rgbatohex = function(r, g, b, a)
	return ("%02x%02x%02x%02x"):format(r, g, b, a)
end

local rgbatohextext = function(r, g, b, a, text)
	return ("\a%s%s"):format(rgbatohex(r, g, b, a), text)
end

local gradienttext = function(text, r1, g1, b1, a1, r2, g2, b2, a2)
	local output = ""
	local len = #text - 1
	local rinc = (r2 - r1) / len
	local ainc = (a2 - a1) / len
	local ginc = (g2 - g1) / len
	local binc = (b2 - b1) / len
	for i = 1, len + 1 do 
		output = output .. ("\a%s%s"):format(rgbatohex(r1, g1, b1, a1), text:sub(i, i))
		r1 = r1 + rinc
		a1 = a1 + ainc
		b1 = b1 + binc
		g1 = g1 + ginc
	end

	return output
end

local colors = {
	{255, 255, 255, 255},
	{0, 255, 255, 255},
	{255, 0, 0, 255}
}

local velocity = function(player)
	if not player or not entity.is_alive(player) or entity.is_dormant(player) then
		return 0
	end

	return vector(entity.get_prop(player, "m_vecVelocity")):length2d()
end

local onshot = {ui.reference("AA", "Other", "On shot anti-aim")}
local doubletap = {ui.reference("RAGE", "Aimbot", "Double tap")}


local text_animation = function(name, text, fraction)
	if not indicator_data.text_anims[name] then
		indicator_data.text_anims[name] = {
			text = "",
			fraction = 0
		}
	end

	if indicator_data.text_anims[name].text ~= text then
		indicator_data.text_anims[name].text = text
		indicator_data.text_anims[name].fraction = 0
	end

	indicator_data.text_anims[name].fraction = lerp(indicator_data.text_anims[name].fraction, 1, globals.frametime() * (fraction / 10))
	return indicator_data.text_anims[name].fraction
end

local rgbatohex = function(r, g, b, a)
	return ("%02x%02x%02x%02x"):format(r, g, b, a)
end

local rgbatohextext = function(r, g, b, a, text)
	return ("\a%s%s"):format(rgbatohex(r, g, b, a), text)
end

local gradienttext = function(text, r1, g1, b1, a1, r2, g2, b2, a2)
	local output = ""
	local len = #text - 1
	local rinc = (r2 - r1) / len
	local ainc = (a2 - a1) / len
	local ginc = (g2 - g1) / len
	local binc = (b2 - b1) / len
	for i = 1, len + 1 do 
		output = output .. ("\a%s%s"):format(rgbatohex(r1, g1, b1, a1), text:sub(i, i))
		r1 = r1 + rinc
		a1 = a1 + ainc
		b1 = b1 + binc
		g1 = g1 + ginc
	end

	return output
end

local velocity = function(player)
	if not player or not entity.is_alive(player) or entity.is_dormant(player) then
		return 0
	end

	return vector(entity.get_prop(player, "m_vecVelocity")):length2d()
end

local onshot = {ui.reference("AA", "Other", "On shot anti-aim")}
local doubletap = {ui.reference("RAGE", "Aimbot", "Double tap")}
local renderable = function()
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	local colors = {
		{ui.get(fantasy.menu.indicator_main_color)},
		{ui.get(fantasy.menu.indicator_main_os_color)},
		{ui.get(fantasy.menu.indicator_main_dt_color)}
	}

	local curtime = globals.curtime()
	local accent_color = {ui.get(fantasy.menu.indicator_accent_color)}
	local center = vector(client.screen_size()) / 2
	local os = ui.get(onshot[1]) and ui.get(onshot[2])
	local dt = ui.get(doubletap[1]) and ui.get(doubletap[2])
	local wpn = entity.get_player_weapon(local_player)
	local scope = entity.get_prop(local_player, "m_bIsScoped") == 1 or (wpn and contains({
		"CSnowball",
		"CFlashbang",
		"CHEGrenade",
		"CDecoyGrenade",
		"CSensorGrenade",
		"CSmokeGrenade",
		"CMolotovGrenade",
		"CIncendiaryGrenade"
	},  entity.get_classname(wpn)))
	if math.abs(curtime - indicator_data.last_reset_time) > 0.25 then
		indicator_data.last_velocity = velocity(local_player)
		indicator_data.last_reset_time = curtime
	end

	local currentchoke = globals.chokedcommands()
	local rect_fraction = (dt or os) and math.min(0.5 + (indicator_data.last_velocity / 330), 1) or math.min(currentchoke / 14, 1)
	local accent_main_color = colors[dt and 3 or os and 2 or 1]
	local main_color = anim_new("Main Colors", accent_main_color, 70)
	local rect_size = vector(60, 15)
	local exploit_anim = anim_new("Exploits", (dt or os) and 1 or 0, 70)
	local current_state = dt and "DT" or os and "OS" or "Def"
	local text_modified = text_animation("Global Clr", current_state, 70)
	local scope_anim = anim_new("Scope Animation", scope and 1 or 0, 70)
	local extra_offset = scope_anim * 50
	if indicator_data.chokeds[5] > currentchoke then
		indicator_data.chokeds[1] = indicator_data.chokeds[2]
		indicator_data.chokeds[2] = indicator_data.chokeds[3]
		indicator_data.chokeds[3] = indicator_data.chokeds[4]
		indicator_data.chokeds[4] = indicator_data.chokeds[5]
	end

	local current_status_text = last_this_status:upper()
	local status_text_modified = text_animation("Global Status", current_status_text, 50)
	indicator_data.chokeds[5] = currentchoke
	local scopesize = vector(40, 6)
	renderer.text(center.x + extra_offset, center.y + 25, main_color[1], main_color[2], main_color[3], main_color[4], "cb", 0, "fantasy")
	renderer.rectangle(center.x - (scopesize.x / 2) + extra_offset, center.y + 35 - (scopesize.y / 2), scopesize.x, scopesize.y, 0, 0, 0, 255 * scope_anim)
	renderer.gradient(center.x - (scopesize.x / 2) + 1 + extra_offset, center.y + 35 - (scopesize.y / 2) + 1, (scopesize.x - 2) * rect_fraction, scopesize.y - 2, main_color[1], main_color[2], main_color[3], main_color[4] * scope_anim, accent_color[1], accent_color[2], accent_color[3], accent_color[4] * scope_anim, 0, false)
	local rect_text = (dt or os) and gradienttext(("%iKM/R"):format(velocity(local_player)), accent_color[1], accent_color[2], accent_color[3], accent_color[4] * scope_anim, main_color[1], main_color[2], main_color[3], main_color[4] * scope_anim) or rgbatohextext(main_color[1], main_color[2], main_color[3], main_color[4] * scope_anim, ("%i-%i-%i-%i"):format(indicator_data.chokeds[4], indicator_data.chokeds[3], indicator_data.chokeds[2], indicator_data.chokeds[1]))
	renderer.text(center.x + scopesize.x - 16 + extra_offset, center.y + 29, main_color[1], main_color[2], main_color[3], main_color[4] * scope_anim, "-", 0, rect_text)
	renderer.text(center.x + extra_offset, center.y + 35, main_color[1], main_color[2], main_color[3], main_color[4] * (1 - scope_anim) * status_text_modified, "c-", 0, current_status_text)
	if exploit_anim > 0.001 then
		container(center.x - (rect_size.x / 2) + extra_offset, center.y + 42, rect_size.x, rect_size.y, main_color[1], main_color[2], main_color[3], main_color[4] * exploit_anim, rgbatohextext(main_color[1], main_color[2], main_color[3], main_color[4] * text_modified * exploit_anim, dt and "double tap" or "os-aa"))
	end
end

local offset_center = 0
animated = function()
    r, g, b = ui.get(fantasy.menu.color_picker)
    screen = {client.screen_size()}
    center = {screen[1] / 2, screen[2] / 2}
    if fantasy.anti_aim.aa_dir == 1 then
        mleft = script.helpers:clamp(mleft + globals.frametime() / 0.15, 0, 1)
        mright = script.helpers:clamp(mright - globals.frametime() / 0.15, 0, 1)
        mfor = script.helpers:clamp(mfor - globals.frametime() / 0.15, 0, 1)
    elseif fantasy.anti_aim.aa_dir == 2 then
        mleft = script.helpers:clamp(mleft - globals.frametime() / 0.15, 0, 1)
        mright = script.helpers:clamp(mright + globals.frametime() / 0.15, 0, 1)
        mfor = script.helpers:clamp(mfor - globals.frametime() / 0.15, 0, 1)
    else
        mleft = script.helpers:clamp(mleft - globals.frametime() / 0.15, 0, 1)
        mright = script.helpers:clamp(mright - globals.frametime() / 0.15, 0, 1)
        mfor = script.helpers:clamp(mfor - globals.frametime() / 0.15, 0, 1)
    end

    --manual inds remove it if you need
    renderer.text(center[1] - 60, center[2], r, g, b, mleft * 255, "+", nil, "‹")
    renderer.text(center[1] + 60, center[2], r, g, b, mright * 255, "+", nil, "›")

    if ui.get(fantasy.menu.indicators5) == "Modern" then
        local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1
        dted = ui.get(fantasy.reference.other.double_tap[2]) == true
        hsed = ui.get(fantasy.reference.other.hide_shots[2]) == true
        qped = ui.get(fantasy.reference.other.auto_peek[2]) == true  
        dtopa = fantasy.table.visuals.animation_variables.movement(dtopa,dted,0,255,12)
        
        
        if dted and hsed then 
        location = 73
        elseif dted or hsed then
        location = 62
        else
        location = 51
        end
        
        if dted then
        location2 = 62
        else 
        location2 = 51
        end
        
        if dted then
        dtopa2 = script.helpers:clamp(dtopa2 + globals.frametime()/0.2, 0, 1)
        else
        dtopa2 = script.helpers:clamp(dtopa2 - globals.frametime()/0.2, 0, 1)
        end
        
        if hsed then
        dtopa4 = script.helpers:clamp(dtopa4 + globals.frametime()/0.2, 0, 1)
        else
        dtopa4 = script.helpers:clamp(dtopa4 - globals.frametime()/0.2, 0, 1)
        end
            
        
        if qped then
        dtopa3 = script.helpers:clamp(dtopa3 + globals.frametime()/0.2, 0, 1)
        else
        dtopa3 = script.helpers:clamp(dtopa3 - globals.frametime()/0.2, 0, 1)
        end
        qpopa = fantasy.table.visuals.animation_variables.movement(qpopa,qped,0,255,12)
        rapid_mes = renderer.measure_text("", "dt")/2 + 6
        rapid_mes2 = renderer.measure_text("-", "  DT CHARGING")/2 - 1
        rapid_mes3 = renderer.measure_text("-", "  DT DEFENSIVE")/2 - 1
        local_player = entity.get_local_player()
        if not entity.is_alive(local_player) then return end
        blink = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255
        blink2 = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 120
        cen_meas = renderer.measure_text("c", "fantasy")/2  + 5
        cen_meas3 = renderer.measure_text("c", "fantasy")/2  
        cen_meas2 = renderer.measure_text("c", "fantasy")
        build_meas = renderer.measure_text("", "sync")
        state_mes = renderer.measure_text("", "sync")/2 + 6
        qp_mes = renderer.measure_text("", "qp")/2 + 5.5
        qp_mes2 = renderer.measure_text("-", "IDEALTICK CHARGING")/2 + 2
        qp_mes3 = renderer.measure_text("-", "IDEALTICK DEFENSIVE")/2 + 1
        hs_mes = renderer.measure_text("", "os")/2 + 5.5
        offset_qp = fantasy.table.visuals.animation_variables.movement(offset_qp,qped,51,location,15)
        offset_hs = fantasy.table.visuals.animation_variables.movement(offset_hs,hsed,51,location2,15)
        offset_center = fantasy.table.visuals.animation_variables.movement(offset_center,scoped,1,cen_meas,10)
        offset_state = fantasy.table.visuals.animation_variables.movement(offset_state,scoped,0,state_mes,8)
        offset_quickpeek = fantasy.table.visuals.animation_variables.movement(offset_quickpeek,scoped,0,qp_mes,8)
        offset_quickpeek2 = fantasy.table.visuals.animation_variables.movement(offset_quickpeek2,scoped,0,qp_mes2,8)
        offset_quickpeek3 = fantasy.table.visuals.animation_variables.movement(offset_quickpeek3,scoped,0,qp_mes3,8)
        offset_rapid = fantasy.table.visuals.animation_variables.movement(offset_rapid,scoped,0,rapid_mes,8)
        offset_rapid2 = fantasy.table.visuals.animation_variables.movement(offset_rapid2,scoped,0,hs_mes,8)
        offset_rapid3 = fantasy.table.visuals.animation_variables.movement(offset_rapid3,scoped,0,rapid_mes3,8)
        dtcolor = 0
        dt_mes = renderer.measure_text("", "dt ")
        hs_mes = renderer.measure_text("", "os ")
        p_mes = renderer.measure_text("", "qp ")
        h_mes = renderer.measure_text("-", "HIDESHOT ")
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
        renderer.text(center[1] + offset_center, center[2] + 29- 10, 255, 255, 255, 255, "c", nil, "fantasy")
        renderer.text(center[1] + offset_state, center[2] + 40 - 10, r, g, b, blink, "c" , nil, "sync")
        renderer.text(center[1] + offset_rapid , center[2] + 51 - 10, 255, 255, 255, dtopa2 * 255, "c" , dtopa2 * dt_mes + 1, "dt")
        renderer.text(center[1] + offset_rapid2 , center[2] + offset_hs - 10, 155, 255, 155, dtopa4 * 255, "c" , dtopa4 * hs_mes + 1, "os")
        renderer.text(center[1] + offset_quickpeek, center[2] + offset_qp - 10, 255, 255, 255, dtopa3 * 255, "c" , dtopa3 * p_mes + 1, "qp")
    elseif ui.get(fantasy.menu.indicators5) == "LCKSB" then
	renderable()
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
            
if fantasy.anti_aim.aa_dir > 0 then
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
elseif velocity < 100 and ui.get(fantasy.reference.other.slow_motion[2]) then
state3 = '- walking -'
else
state3 = '- run -'
end
end      
client.set_event_callback('setup_command', on_setup_command) 
client.set_event_callback("paint", animated)

--#endregion indicators