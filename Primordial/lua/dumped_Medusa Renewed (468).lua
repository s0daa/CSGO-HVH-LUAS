local add_list, add_button, add_checkbox, add_text, add_selection, add_multi_selection, add_slider, add_separator = menu.add_list, menu.add_button, menu.add_checkbox, menu.add_text, menu.add_selection, menu.add_multi_selection, menu.add_slider, menu.add_separator
local lua = {
    version = "2.1",
    libs = {
        base64 = require("primordial/base64.371")
    },

    fonts = {
        pixel = render.create_font("Small Fonts", 10, 600, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE),
        pixel_b = render.create_font("Small Fonts", 25, 600, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE)
    }
}

local refs = {
    -- antiaim
    pitch = menu.find("antiaim", "main", "angles", "Pitch"),
    yaw_base = menu.find("antiaim", "main", "angles", "yaw base"),
    yaw_add = menu.find("antiaim", "main", "angles", "yaw add"),
    rotate = menu.find("antiaim", "main", "angles", "rotate"),
    rotate_range = menu.find("antiaim", "main", "angles", "rotate range"),
    rotate_speed = menu.find("antiaim", "main", "angles", "rotate speed"),
    jitter_mode = menu.find("antiaim", "main", "angles", "jitter mode"),
    jitter_type = menu.find("antiaim", "main", "angles", "jitter type"),
    jitter_add = menu.find("antiaim", "main", "angles", "jitter add"),
    body_lean = menu.find("antiaim", "main", "angles", "body lean"),
    body_lean_value = menu.find("antiaim", "main", "angles", "body lean value"),
    moving_body_lean = menu.find("antiaim", "main", "angles", "moving body lean"),
    desync_side = menu.find("antiaim", "main", "desync", "side"),
    desync_default_side = menu.find("antiaim", "main", "desync", "default side"),
    desync_left = menu.find("antiaim", "main", "desync", "left amount"),
    desync_right = menu.find("antiaim", "main", "desync", "right amount"),
    anti_brute = menu.find("antiaim", "main", "desync", "anti bruteforce"),
    desync_override_move = menu.find("antiaim", "main", "desync", "override stand#move"),
    desync_override_slowwalk = menu.find("antiaim", "main", "desync", "override stand#slow walk"),
    leg_slide = menu.find("antiaim", "main", "general", "leg slide"),
    -- misc
    slowwalk = menu.find("misc", "main", "movement", "slow walk")[2],
    --rage
    deagle_hc = menu.find("aimbot", "deagle", "targeting", "hitchance"),
    auto_direction = menu.find("antiaim", "main", "auto direction", "enable")[2],
    autopeek = menu.find("aimbot", "general", "misc", "autopeek")[2],
    doubletap = menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2],
    hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")[2],
}

-- cool things
local printc do
    ffi.cdef[[
        typedef struct { uint8_t r; uint8_t g; uint8_t b; uint8_t a; } color_struct_t;
    ]]

	local print_interface = ffi.cast("void***", memory.create_interface("vstdlib.dll", "VEngineCvar007"))
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

local function rgbToHex(_r, _g, _b)
    _r = tostring(_r);_g = tostring(_g);_b = tostring(_b)
    _r = (_r:len() == 1) and "0".._r or _r;_g = (_g:len() == 1) and "0".._g or _g;_b = (_b:len() == 1) and "0".._b or _b
    local rgb = (_r * 0x10000) + (_g * 0x100) + _b
    return (_r == "00" and _g == "00" and _b == "00") and "000000" or string.format("%x", rgb)
end

function get_velocity()
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() then return end
    local first_velocity, second_velocity = entity_list.get_local_player():get_prop("m_vecVelocity[0]"), entity_list.get_local_player():get_prop("m_vecVelocity[1]")
    local speed = math.floor((first_velocity^2 + second_velocity^2)^0.5)
    
    return speed
end
local ground_tick = 1
function get_state(speed)
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() then return end
    local flags = entity_list.get_local_player():get_prop("m_fFlags")
    local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    if land then ground_tick = ground_tick + 1 else ground_tick = 0 end

    if bit.band(flags, 1) == 1 then
        if ground_tick < 10 then if bit.band(flags, 4) == 4 then return 5 else return 4 end end
        if bit.band(flags, 4) == 4 or antiaim.is_fakeducking() then 
            return 6 -- crouching
        else
            if speed <= 3 then
                return 2 -- standing
            else
                if refs.slowwalk:get() then
                    return 7 -- slowwalk
                else
                    return 3 -- moving
                end
            end
        end
    elseif bit.band(flags, 1) == 0 then
        if bit.band(flags, 4) == 4 then
            return 5 -- air-c
        else
            return 4 -- air
        end
    end
end

getweapon = function()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end
        weapon_name = active_weapon:get_name()
    else return end

    return weapon_name
end

function lerp(time,a,b)
    return a * (1-time) + b * time
end

local alphabet = "base64"
local screensize = render.get_screen_size()

-- script_menu
local _ui = {rage = {}, antiaim = {}, antiaim_b = {}, antiaim_ab = {}, visuals = {}, other = {}}
_ui.tab = add_list("Medusa", "Tab Selection", {"Rage","Antiaim", "Visuals", "Other"}, 4)
add_separator("Medusa")
_ui.cfg_export = add_button("Medusa", "Export Antiaim Settings", function() configs.export() end)
_ui.cfg_import = add_button("Medusa", "Import Antiaim Settings", function() configs.import() end)
_ui.cfg_default = add_button("Medusa", "Load Default Config", function() configs.import("medusa__dHJ1ZXxmYWxzZXx0cnVlfGZhbHNlfGZhbHNlfGZhbHNlfHRydWV8NXx0cnVlfDJ8MnwwfHRydWV8MTc4fDQyfDF8MXwwfDF8MXwwfDB8MXwwfGZhbHNlfHRydWV8MnwzfC00fGZhbHNlfDIxfDM5fDJ8MXwyM3w0fDF8OTl8OTl8MXw1MHxmYWxzZXx0cnVlfDJ8M3wtOHxmYWxzZXwxNXw4fDJ8MXw1N3wzfDF8NjJ8OTl8MXwwfGZhbHNlfHRydWV8MnwzfDEwfGZhbHNlfDIzfDJ8MnwxfC01N3wyfDF8OTl8OTl8MXwwfGZhbHNlfHRydWV8MnwyfDEzfGZhbHNlfDB8MHwyfDJ8LTI1fDR8MXw5OHw5OXwxfDB8ZmFsc2V8dHJ1ZXwyfDN8MTN8dHJ1ZXwyfDEwMHwyfDJ8LTE1fDR8MXw5OHw3NnwxfDB8ZmFsc2V8dHJ1ZXwyfDN8MHx0cnVlfDE5fDR8MnwyfC0yM3w0fDF8OTh8OTd8MXwwfGZhbHNlfDF8MnwzfC0xNXxmYWxzZXwwfDB8MnwyfDI5fDJ8MXw5OXw5OHwxfDB8ZmFsc2V8MXwyfDN8LTI3fHRydWV8NTd8NTl8MnwxfDU5fDR8MXw5OXw5OXwxfDB8ZmFsc2V8MXwyfDN8MHx0cnVlfDIzfDY0fDJ8MnwtNTB8MXwxfDB8MHwxfDB8ZmFsc2V8MXwyfDN8MHx0cnVlfDE0OXw2NXwxfDF8MHw0fDF8OTh8NDJ8MXwwfGZhbHNlfDF8MnwzfC0yN3xmYWxzZXwwfDB8MnwxfDU0fDR8MXw0MHw5NHwxfDB8ZmFsc2V8MXwxfDF8MHxmYWxzZXwwfDB8MXwxfDB8MXwxfDB8MHwxfDB8ZmFsc2V8MXwxfDF8MHxmYWxzZXwwfDB8MXwxfDB8MXwxfDB8MHwxfDB8ZmFsc2V8MXwxfDF8MHxmYWxzZXwwfDB8MXwxfDB8MXwxfDB8MHwxfDB8ZmFsc2V8MXwxfDF8MHxmYWxzZXwwfDB8MXwxfDB8MXwxfDB8MHwxfDB8ZmFsc2V8MXwxfDF8MHxmYWxzZXwwfDB8MXwxfDB8MXwxfDB8MHwxfDB8ZmFsc2V8") end)
add_separator("Medusa")
_ui.accent_color_text = add_text("Medusa", "Accent Color")
_ui.accent_color = _ui.accent_color_text:add_color_picker("Accent Color") _ui.accent_color:set(color_t(168,186,244, 255))
_ui.hide_menu_watermark = add_checkbox("Medusa", "Hide Menu Watermark")
-- ragebot_menu
_ui.rage.master = add_checkbox("Rage", "Enable")
_ui.rage.interpolation = add_checkbox("Rage", "Disable Interpolation")
_ui.rage.deagle_nospread = add_checkbox("Rage", "Deagle Nospread")
-- visuals_menu
_ui.visuals.master = add_checkbox("Visuals", "Enable")
_ui.visuals.indicators = add_checkbox("Visuals", "Crosshair Indicators")
_ui.visuals.velocity_warning = add_checkbox("Visuals", "Velocity Warning")
-- other_menu
_ui.other.master = add_checkbox("Other", "Enable")
_ui.other.clantag = add_checkbox("Other", "Clantag")
_ui.other.trashtalk = add_checkbox("Other", "High IQ Talking")
_ui.other.tt_revenge = add_checkbox("Other", "Revenge")
_ui.other.tt_delay = add_slider("Other", "Delay (seconds)", 0, 5)
-- antiaim_menu
_ui.antiaim.master = add_checkbox("Antiaim", "Enable")
_ui.antiaim.tab = add_list("Settings", "Current Tab", {"Antiaim Builder", "Anti-Bruteforce"}, 2)
_ui.antiaim.options = add_multi_selection("Antiaim", "Options", {"Warmup Preset", "On Shot Fakelag",})
_ui.antiaim.animbreakers = add_multi_selection("Antiaim", "Anim. Breakers", {"Landing", "Moving", "Air"})
_ui.antiaim.anim_legs = add_selection("Antiaim", "Legs Mode", {"Static", "Walking"})
_ui.antiaim.antibrute = add_checkbox("Anti-Bruteforce", "Enable")
_ui.antiaim.ab_phases = add_slider("Anti-Bruteforce", "Phases", 1, 10)
_ui.antiaim.ab_current = add_selection("Anti-Bruteforce", "Current Phase", {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})
add_separator("Anti-Bruteforce")

_ui.antiaim.condition = add_selection("Antiaim Builder", "Condition", {"Global", "Standing", "Moving", "Air", "Air (Crouch)", "Crouch", "Slow Walk"})
add_separator("Antiaim Builder")

local aa_state = {[1] = "G", [2] = "S", [3] = "M", [4] = "A", [5] = "A-C", [6] = "C", [7] = "SW"}
local aa_state_full = {[1] = "Global", [2] = "Standing", [3] = "Moving", [4] = "Air", [5] = "Air (crouch)", [6] = "Crouch", [7] = "Slow walk"}

for i=1, 7 do
    _ui.antiaim_b[i] = {}
    _ui.antiaim_b[i].override = add_checkbox("Antiaim Builder", "Override "..aa_state_full[i])
    _ui.antiaim_b[i].pitch = add_selection("Antiaim Builder", aa_state[i].."  -  Pitch", {"None", "Down", "Up", "Zero", "Jitter"})
    _ui.antiaim_b[i].yaw_base = add_selection("Antiaim Builder", aa_state[i].."  -  Yaw Base", {"None", "Viewangle", "At Target (Crosshair)", "At Target (Distance)", "Velocity"})
    _ui.antiaim_b[i].yaw_add = add_slider("Antiaim Builder", aa_state[i].."  -  Yaw Add", -180, 180)
    _ui.antiaim_b[i].rotate = add_checkbox("Antiaim Builder", aa_state[i].."  -  Rotate")
    _ui.antiaim_b[i].rotate_range = add_slider("Antiaim Builder", aa_state[i].."  -  Rotate Range", 0, 360)
    _ui.antiaim_b[i].rotate_speed = add_slider("Antiaim Builder", aa_state[i].."  -  Rotate Angle", 0, 100)
    _ui.antiaim_b[i].jitter_mode = add_selection("Antiaim Builder", aa_state[i].."  -  Jitter Mode", {"None", "Static", "Random"})
    _ui.antiaim_b[i].jitter_type = add_selection("Antiaim Builder", aa_state[i].."  -  Jitter Type", {"Offset", "Center"})
    _ui.antiaim_b[i].jitter_add = add_slider("Antiaim Builder", aa_state[i].."  -  Jitter Add", -180, 180)
    _ui.antiaim_b[i].desync_side = add_selection("Antiaim Builder", aa_state[i].."  -  Desync", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"})
    _ui.antiaim_b[i].desync_default_side = add_selection("Antiaim Builder", aa_state[i].."  -  Default Side", {"Left", "Right"})
    _ui.antiaim_b[i].desync_left = add_slider("Antiaim Builder", aa_state[i].."  -  Left Amount", 0, 100)
    _ui.antiaim_b[i].desync_right = add_slider("Antiaim Builder", aa_state[i].."  -  Right Amount", 0, 100)
    _ui.antiaim_b[i].body_lean = add_selection("Antiaim Builder", aa_state[i].."  -  Body Lean", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
    _ui.antiaim_b[i].body_lean_value = add_slider("Antiaim Builder", aa_state[i].."  -  Body Lean Value", 0, 100)
    _ui.antiaim_b[i].moving_body_lean = add_checkbox("Antiaim Builder", aa_state[i].."  -  Moving Body Lean")
end

for i=1, 10 do
    _ui.antiaim_ab[i] = {}
    _ui.antiaim_ab[i].condition = add_selection("Anti-Bruteforce", "Set This Phase To", {"All States", "Standing", "Moving", "Air", "Air (Crouch)", "Crouch", "Slow Walk"})
    _ui.antiaim_ab[i].pitch = add_selection("Anti-Bruteforce", i.."  -  Pitch", {"None", "Down", "Up", "Zero", "Jitter"})
    _ui.antiaim_ab[i].yaw_base = add_selection("Anti-Bruteforce", i.."  -  Yaw Base", {"None", "Viewangle", "At Target (Crosshair)", "At Target (Distance)", "Velocity"})
    _ui.antiaim_ab[i].yaw_add = add_slider("Anti-Bruteforce", i.."  -  Yaw Add", -180, 180)
    _ui.antiaim_ab[i].rotate = add_checkbox("Anti-Bruteforce", i.."  -  Rotate")
    _ui.antiaim_ab[i].rotate_range = add_slider("Anti-Bruteforce", i.."  -  Rotate Range", 0, 360)
    _ui.antiaim_ab[i].rotate_speed = add_slider("Anti-Bruteforce", i.."  -  Rotate Angle", 0, 100)
    _ui.antiaim_ab[i].jitter_mode = add_selection("Anti-Bruteforce", i.."  -  Jitter Mode", {"None", "Static", "Random"})
    _ui.antiaim_ab[i].jitter_type = add_selection("Anti-Bruteforce", i.."  -  Jitter Type", {"Offset", "Center"})
    _ui.antiaim_ab[i].jitter_add = add_slider("Anti-Bruteforce", i.."  -  Jitter Add", -180, 180)
    _ui.antiaim_ab[i].desync_side = add_selection("Anti-Bruteforce", i.."  -  Desync", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Body Sway"})
    _ui.antiaim_ab[i].desync_default_side = add_selection("Anti-Bruteforce", i.."  -  Default Side", {"Left", "Right"})
    _ui.antiaim_ab[i].desync_left = add_slider("Anti-Bruteforce", i.."  -  Left Amount", 0, 100)
    _ui.antiaim_ab[i].desync_right = add_slider("Anti-Bruteforce", i.."  -  Right Amount", 0, 100)
    _ui.antiaim_ab[i].body_lean = add_selection("Anti-Bruteforce", i.."  -  Body Lean", {"None", "Static", "Static Jitter", "Random Jitter", "Sway"})
    _ui.antiaim_ab[i].body_lean_value = add_slider("Anti-Bruteforce", i.."  -  Body Lean Value", 0, 100)
    _ui.antiaim_ab[i].moving_body_lean = add_checkbox("Anti-Bruteforce", i.."  -  Moving Body Lean")
end

menu.set_group_column("medusa", 1) menu.set_group_column("Antiaim", 2) menu.set_group_column("Visuals", 2) menu.set_group_column("Rage", 2) menu.set_group_column("Antiaim Builder", 3) menu.set_group_column("Anti-Bruteforce", 3) menu.set_group_column("Settings", 2)

-- visiblity
local visiblity = function()
    if not menu.is_open() then return end
    for i,v in pairs(_ui.rage) do v:set_visible(_ui.tab:get() == 1 and _ui.rage.master:get()) end
    for i,v in pairs(_ui.antiaim) do v:set_visible(_ui.tab:get() == 2 and _ui.antiaim.master:get()) end
    for i,v in pairs(_ui.visuals) do v:set_visible(_ui.tab:get() == 3 and _ui.visuals.master:get()) end
    for i,v in pairs(_ui.other) do v:set_visible(_ui.tab:get() == 4 and _ui.other.master:get()) end

    local current_cond = _ui.antiaim.condition:get()
    local required = _ui.tab:get() == 2 and _ui.antiaim.master:get()
    for i=1, 7 do
        local current_state = aa_state_full[current_cond] == aa_state_full[i]
        local override = _ui.antiaim_b[i].override:get()

        _ui.antiaim_b[i].override:set_visible(required and current_state)
        _ui.antiaim_b[i].pitch:set_visible(required and current_state and override)
        _ui.antiaim_b[i].yaw_base:set_visible(required and current_state and override)
        _ui.antiaim_b[i].yaw_add:set_visible(required and current_state and override and _ui.antiaim_b[i].yaw_base:get() ~= 1)
        _ui.antiaim_b[i].rotate:set_visible(required and current_state and override)
        _ui.antiaim_b[i].rotate_range:set_visible(required and current_state and override and _ui.antiaim_b[i].rotate:get())
        _ui.antiaim_b[i].rotate_speed:set_visible(required and current_state and override and _ui.antiaim_b[i].rotate:get())
        _ui.antiaim_b[i].jitter_mode:set_visible(required and current_state and override)
        _ui.antiaim_b[i].jitter_type:set_visible(required and current_state and override and _ui.antiaim_b[i].jitter_mode:get() ~= 1)
        _ui.antiaim_b[i].jitter_add:set_visible(required and current_state and override and _ui.antiaim_b[i].jitter_mode:get() ~= 1)
        _ui.antiaim_b[i].desync_side:set_visible(required and current_state and override)
        _ui.antiaim_b[i].desync_default_side:set_visible(required and current_state and override and (_ui.antiaim_b[i].desync_side:get() == 5 or _ui.antiaim_b[i].desync_side:get() == 6))
        _ui.antiaim_b[i].desync_left:set_visible(required and current_state and override and _ui.antiaim_b[i].desync_side:get() ~= 1)
        _ui.antiaim_b[i].desync_right:set_visible(required and current_state and override and _ui.antiaim_b[i].desync_side:get() ~= 1)
        _ui.antiaim_b[i].body_lean:set_visible(required and current_state and override)
        _ui.antiaim_b[i].body_lean_value:set_visible(required and current_state and override and _ui.antiaim_b[i].body_lean:get() ~= 1)
        _ui.antiaim_b[i].moving_body_lean:set_visible(required and current_state and override and _ui.antiaim_b[i].body_lean:get() ~= 1)
    end

    
    local required_ab = _ui.tab:get() == 2 and _ui.antiaim.master:get() and _ui.antiaim.antibrute:get()
    for i=1, 10 do
        local current_phase = _ui.antiaim.ab_current:get() == i

        _ui.antiaim_ab[i].condition:set_visible(required_ab and current_phase)
        _ui.antiaim_ab[i].pitch:set_visible(required_ab and current_phase)
        _ui.antiaim_ab[i].yaw_base:set_visible(required_ab and current_phase)
        _ui.antiaim_ab[i].yaw_add:set_visible(required_ab and current_phase and _ui.antiaim_ab[i].yaw_base:get() ~= 1)
        _ui.antiaim_ab[i].rotate:set_visible(required_ab and current_phase)
        _ui.antiaim_ab[i].rotate_range:set_visible(required_ab and current_phase and _ui.antiaim_ab[i].rotate:get())
        _ui.antiaim_ab[i].rotate_speed:set_visible(required_ab and current_phase and _ui.antiaim_ab[i].rotate:get())
        _ui.antiaim_ab[i].jitter_mode:set_visible(required_ab and current_phase)
        _ui.antiaim_ab[i].jitter_type:set_visible(required_ab and current_phase and _ui.antiaim_ab[i].jitter_mode:get() ~= 1)
        _ui.antiaim_ab[i].jitter_add:set_visible(required_ab and current_phase and _ui.antiaim_ab[i].jitter_mode:get() ~= 1)
        _ui.antiaim_ab[i].desync_side:set_visible(required_ab and current_phase)
        _ui.antiaim_ab[i].desync_default_side:set_visible(required_ab and current_phase and (_ui.antiaim_ab[i].desync_side:get() == 5 or _ui.antiaim_ab[i].desync_side:get() == 6))
        _ui.antiaim_ab[i].desync_left:set_visible(required_ab and current_phase and _ui.antiaim_ab[i].desync_side:get() ~= 1)
        _ui.antiaim_ab[i].desync_right:set_visible(required_ab and current_phase and _ui.antiaim_ab[i].desync_side:get() ~= 1)
        _ui.antiaim_ab[i].body_lean:set_visible(required_ab and current_phase)
        _ui.antiaim_ab[i].body_lean_value:set_visible(required_ab and current_phase and _ui.antiaim_ab[i].body_lean:get() ~= 1)
        _ui.antiaim_ab[i].moving_body_lean:set_visible(required_ab and current_phase and _ui.antiaim_ab[i].body_lean:get() ~= 1)
    end

    _ui.other.tt_revenge:set_visible(_ui.tab:get() == 4 and _ui.other.trashtalk:get() and _ui.other.master:get())
    _ui.other.tt_delay:set_visible(_ui.tab:get() == 4 and _ui.other.trashtalk:get() and _ui.other.master:get())
    _ui.antiaim_b[1].override:set_visible(false) _ui.antiaim_b[1].override:set(true)
    _ui.antiaim.anim_legs:set_visible(_ui.tab:get() == 2 and _ui.antiaim.master:get() and _ui.antiaim.animbreakers:get(3))
    _ui.rage.master:set_visible(_ui.tab:get() == 1) _ui.antiaim.master:set_visible(_ui.tab:get() == 2) _ui.visuals.master:set_visible(_ui.tab:get() == 3) _ui.other.master:set_visible(_ui.tab:get() == 4)
    menu.set_group_visibility("Antiaim Builder",_ui.tab:get() == 2 and _ui.antiaim.tab:get() == 1 and _ui.antiaim.master:get()) 
    menu.set_group_visibility("Anti-Bruteforce",_ui.tab:get() == 2 and _ui.antiaim.tab:get() == 2 and _ui.antiaim.master:get())
    if _ui.antiaim.ab_current:get() > _ui.antiaim.ab_phases:get() then _ui.antiaim.ab_current:set(_ui.antiaim.ab_phases:get()) end
end

-- config_manager
ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local VGUI_System010 =  memory.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof("void***"), VGUI_System010 )
local get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

clipboard_import = function()
    local clipboard_text_length = get_clipboard_text_count(VGUI_System)
   
    if clipboard_text_length > 0 then
        local buffer = ffi.new("char[?]", clipboard_text_length)
        local size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
   
        get_clipboard_text(VGUI_System, 0, buffer, size )
   
        return ffi.string( buffer, clipboard_text_length-1)
    end

    return ""
end

local function clipboard_export(string)
	if string then
		set_clipboard_text(VGUI_System, string, string:len())
	end
end

local function str_to_sub(text, sep)
	local t = {}
	for str in string.gmatch(text, "([^"..sep.."]+)") do
		t[#t + 1] = string.gsub(str, "\n", " ")
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

configs = {}
configs.import = function(input)
    local _r, _g, _b = _ui.accent_color:get().r, _ui.accent_color:get().g, _ui.accent_color:get().b
    local protected = function()
        local clipboard = input == nil and clipboard_import() or input
        local cb_gsub = string.gsub(clipboard, "medusa__", "")
        local decoded = lua.libs.base64.decode(cb_gsub, alphabet)
        local tbl = str_to_sub(decoded, "|")

        _ui.antiaim.master:set(to_boolean(tbl[1]))
        _ui.antiaim.options:set(1, to_boolean(tbl[2]))
        _ui.antiaim.options:set(2, to_boolean(tbl[3]))
        _ui.antiaim.animbreakers:set(1, to_boolean(tbl[4]))
        _ui.antiaim.animbreakers:set(2, to_boolean(tbl[5]))
        _ui.antiaim.animbreakers:set(3, to_boolean(tbl[6]))
        _ui.antiaim.antibrute:set(to_boolean(tbl[7]))
        _ui.antiaim.ab_phases:set(tonumber(tbl[8]))

        local val_plus = {[1] = 0, [2] = 17, [3] = 34, [4] = 51, [5] = 68, [6] = 85, [7] = 102}
        for i=1, 7 do
            _ui.antiaim_b[i].override:set(to_boolean(tbl[9 + val_plus[i]]))
            _ui.antiaim_b[i].pitch:set(tonumber(tbl[10 + val_plus[i]]))
            _ui.antiaim_b[i].yaw_base:set(tonumber(tbl[11 + val_plus[i]]))
            _ui.antiaim_b[i].yaw_add:set(tonumber(tbl[12 + val_plus[i]]))
            _ui.antiaim_b[i].rotate:set(to_boolean(tbl[13 + val_plus[i]]))
            _ui.antiaim_b[i].rotate_range:set(tonumber(tbl[14 + val_plus[i]]))
            _ui.antiaim_b[i].rotate_speed:set(tonumber(tbl[15 + val_plus[i]]))
            _ui.antiaim_b[i].jitter_mode:set(tonumber(tbl[16 + val_plus[i]]))
            _ui.antiaim_b[i].jitter_type:set(tonumber(tbl[17 + val_plus[i]]))
            _ui.antiaim_b[i].jitter_add:set(tonumber(tbl[18 + val_plus[i]]))
            _ui.antiaim_b[i].desync_side:set(tonumber(tbl[19 + val_plus[i]]))
            _ui.antiaim_b[i].desync_default_side:set(tonumber(tbl[20 + val_plus[i]]))
            _ui.antiaim_b[i].desync_left:set(tonumber(tbl[21 + val_plus[i]]))
            _ui.antiaim_b[i].desync_right:set(tonumber(tbl[22 + val_plus[i]]))
            _ui.antiaim_b[i].body_lean:set(tonumber(tbl[23 + val_plus[i]]))
            _ui.antiaim_b[i].body_lean_value:set(tonumber(tbl[24 + val_plus[i]]))
            _ui.antiaim_b[i].moving_body_lean:set(to_boolean(tbl[25 + val_plus[i]]))
        end

        local val_plus_ab = {[1] = 0, [2] = 17, [3] = 34, [4] = 51, [5] = 68, [6] = 85, [7] = 102, [8] = 119, [9] = 136, [10] = 153}
        for i=1, 10 do
            _ui.antiaim_ab[i].condition:set(tonumber(tbl[128 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].pitch:set(tonumber(tbl[129 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].yaw_base:set(tonumber(tbl[130 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].yaw_add:set(tonumber(tbl[131 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].rotate:set(to_boolean(tbl[132 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].rotate_range:set(tonumber(tbl[133 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].rotate_speed:set(tonumber(tbl[134 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].jitter_mode:set(tonumber(tbl[135 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].jitter_type:set(tonumber(tbl[136 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].jitter_add:set(tonumber(tbl[137 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].desync_side:set(tonumber(tbl[138 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].desync_default_side:set(tonumber(tbl[139 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].desync_left:set(tonumber(tbl[140 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].desync_right:set(tonumber(tbl[141 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].body_lean:set(tonumber(tbl[142 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].body_lean_value:set(tonumber(tbl[143 + val_plus_ab[i]]))
            _ui.antiaim_ab[i].moving_body_lean:set(to_boolean(tbl[144 + val_plus_ab[i]]))
        end

        printc("\a8c8c8c[\a"..rgbToHex(_r,_g,_b).."medusa\a8c8c8c] » \affffffImported")
    end
    local status, message = pcall(protected)
    if not status then
        printc("\a8c8c8c[\add5f5fmedusa\a8c8c8c] » \affffffFailed")
        return
    end
end

configs.export = function()
	local str = {}
	local str = tostring(_ui.antiaim.master:get()) .. "|"
    .. tostring(_ui.antiaim.options:get(1)) .. "|"
    .. tostring(_ui.antiaim.options:get(2)) .. "|"
    .. tostring(_ui.antiaim.animbreakers:get(1)) .. "|"
    .. tostring(_ui.antiaim.animbreakers:get(2)) .. "|"
    .. tostring(_ui.antiaim.animbreakers:get(3)) .. "|"
    .. tostring(_ui.antiaim.antibrute:get()) .. "|"
    .. tostring(_ui.antiaim.ab_phases:get()) .. "|"

    for i=1, 7 do
        str = str .. tostring(_ui.antiaim_b[i].override:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].pitch:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].yaw_base:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].yaw_add:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].rotate:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].rotate_range:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].rotate_speed:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].jitter_mode:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].jitter_type:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].jitter_add:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].desync_side:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].desync_default_side:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].desync_left:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].desync_right:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].body_lean:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].body_lean_value:get()) .. "|"
        .. tostring(_ui.antiaim_b[i].moving_body_lean:get()) .. "|"
    end

    for i=1, 10 do
        str = str .. tostring(_ui.antiaim_ab[i].condition:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].pitch:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].yaw_base:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].yaw_add:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].rotate:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].rotate_range:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].rotate_speed:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].jitter_mode:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].jitter_type:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].jitter_add:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].desync_side:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].desync_default_side:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].desync_left:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].desync_right:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].body_lean:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].body_lean_value:get()) .. "|"
        .. tostring(_ui.antiaim_ab[i].moving_body_lean:get()) .. "|"
    end


    local _r, _g, _b = _ui.accent_color:get().r, _ui.accent_color:get().g, _ui.accent_color:get().b
    local encoded = lua.libs.base64.encode(str, alphabet)
    clipboard_export("medusa__"..encoded)
    printc("\a8c8c8c[\a"..rgbToHex(_r,_g,_b).."medusa\a8c8c8c] » \affffffExported")
end

-- antiaim_features
local antiaim = function()
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() or not _ui.antiaim.master:get() then return end
    local state = get_state(get_velocity()) 

    for k, v in pairs(refs) do
        local key = _ui.antiaim_b[state].override:get() and _ui.antiaim_b[state][k] or _ui.antiaim_b[1][k]
        if key then
            v:set(key:get())
        end
    end

    if _ui.antiaim.options:get(1) then
        if game_rules.get_prop("m_bWarmupPeriod") == 1 then
            refs.pitch:set(5) refs.yaw_base:set(3) refs.jitter_mode:set(2) refs.jitter_type:set(2) refs.jitter_add:set(40) refs.desync_side:set(4)
        end
    end
end

local antibrute_active = false
local antibrute_timer = 0
local antibrute_phase = 0

local closest_point = function(a, b, c)
    local d = a - b
    local event = c - b
    local f = #event
    event.x = event.x / f
    event.y = event.y / f
    event.z = event.z / f
    local g = event.x * d.x + event.y * d.y + event.z * d.z
    if g < 0 then return b end
    if g > f then return c end
    return vec3_t(b.x + event.x * g, b.y + event.y * g, b.z + event.z * g)
end

local function check_bullet_impact(event)
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() or not _ui.antiaim.antibrute:get() then return end

    local attacker = entity_list.get_player_from_userid(event.userid)
    if attacker and attacker ~= entity_list.get_local_player() then
        local impact = vec3_t(event.x, event.y, event.z)
        local attacker_eyepos = entity_list.get_player_from_userid(event.userid):get_eye_position()
        local lp_eyepos = entity_list.get_local_player():get_eye_position()
        local dist = closest_point(lp_eyepos, attacker_eyepos, impact):dist(lp_eyepos)

        if dist < 60 then
            antibrute_active = true
            antibrute_timer = globals.real_time() + 5
            antibrute_phase = (math.min(antibrute_phase + 1, _ui.antiaim.ab_phases:get()))
        end
    end
end
callbacks.add(e_callbacks.EVENT, check_bullet_impact, "bullet_impact")

local function antibrute()
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() or not antibrute_active then return end
    local state = get_state(get_velocity()) 
    local time_left = antibrute_timer - globals.real_time()
    if time_left > 0 then
        for k, v in pairs(refs) do
            local preview = menu.is_open()
            local key = _ui.antiaim_ab[antibrute_phase].condition:get() == state and _ui.antiaim_ab[antibrute_phase][k] or _ui.antiaim_b[state][k]
            if _ui.antiaim_ab[antibrute_phase].condition:get() == 1 then state = 1 else state = state end
            if key then
                v:set(key:get())
            end
        end
        return true
    else
        antibrute_active = false
        antibrute_timer = 0
        antibrute_phase = 0
    end
end

local forcesendnextpacket = false
local function on_aimbot_shoot(shot)
    if not _ui.antiaim.options:get(2) or not _ui.rage.master:get() then return end
    forcesendnextpacket = true
end
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)

fakelag_onshot = function(ctx)
    if not _ui.antiaim.options:get(2) or not _ui.rage.master:get() then return end
    if forcesendnextpacket then
        ctx:set_fakelag(false)
        forcesendnextpacket = false
    end
end

local land_gtick = 1 local land_end = 0
local animbreakers = function(ctx)
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() or not _ui.antiaim.master:get() then return end
    local state = get_state(get_velocity())
    local flags = entity_list.get_local_player():get_prop("m_fFlags")
    local on_land = bit.band(flags, bit.lshift(1, 0)) ~= 0

    if on_land then land_gtick = land_gtick + 1 else land_gtick = 0 land_end = global_vars.cur_time() + 1 end

    if _ui.antiaim.animbreakers:get(1) and land_gtick > 1 and land_end > global_vars.cur_time() then
        ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
    end

    if _ui.antiaim.animbreakers:get(3) and (state == 4 or state == 5) then
        ctx:set_render_animlayer(e_animlayers.LEAN, 1)
        if _ui.antiaim.anim_legs:get() == 1 then
            ctx:set_render_pose(e_poses.JUMP_FALL, 1)
        else
            ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1)
            ctx:set_render_pose(e_poses.MOVE_YAW, 0)
        end
    end

    if _ui.antiaim.animbreakers:get(2) and state ~= 4 and state ~= 5 then
        ctx:set_render_pose(e_poses.RUN, 0) refs.leg_slide:set(3) if state == 7 then ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0) end
    end
end
-- visuals_features
local weapons = {[0] = "auto", [1] = "scout", [2] = "awp", [3] = "deagle", [4] = "revolver", [5] = "pistols", [6] = "other"}

local mw_anim = {alpha = 0, appearing = 0}
local menu_watermark = function()
    if _ui.hide_menu_watermark:get() then return end
    local frametime = math.floor(globals.frame_time()*150)
    mw_anim.alpha = lerp(0.1 + math.min(frametime/10.1, 0.3), mw_anim.alpha, menu.is_open() and 255 or 0)
    mw_anim.appearing = lerp(0.06 + math.min(frametime/10.1, 0.25), mw_anim.appearing, menu.is_open() and 0 or 100)
    if mw_anim.alpha < 2 then return end

    render.rect_fade(vec2_t(menu.get_pos().x - math.floor(mw_anim.appearing), menu.get_pos().y - 21 - math.floor(mw_anim.appearing)), vec2_t(200 + math.floor(mw_anim.appearing*5), 15), color_t(29,29,29,math.floor(mw_anim.alpha)), color_t(29,29,29,0), true)
    render.rect_filled(vec2_t(menu.get_pos().x + 2 - math.floor(mw_anim.appearing), menu.get_pos().y - 19 - math.floor(mw_anim.appearing)), vec2_t(2 + math.floor(mw_anim.appearing*2), 11), color_t(_ui.accent_color:get().r, _ui.accent_color:get().g, _ui.accent_color:get().b, math.floor(mw_anim.alpha)))
    render.text(lua.fonts.pixel, "medusa | user: "..user.name.." | version: "..lua.version, vec2_t(render.get_text_size(lua.fonts.pixel, "medusa").x + menu.get_pos().x - 23 - -math.floor(mw_anim.appearing), menu.get_pos().y - 19 - math.floor(mw_anim.appearing)), color_t(255,255,255, math.floor(mw_anim.alpha)))
end

local ind_anim = {scope = 0, state = 0}
local indicators = function()
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() or not  _ui.visuals.master:get() or not _ui.visuals.indicators:get() then return end

    local state = get_state(get_velocity())
    local frametime = math.floor(globals.frame_time()*150)
    ind_anim.state = lerp(0.06 + math.min(frametime/10.1, 0.25), ind_anim.state, render.get_text_size(lua.fonts.pixel, aa_state_full[state]).x/2 or 0)
    ind_anim.scope = lerp(0.06 + math.min(frametime/10.1, 0.25), ind_anim.scope, entity_list.get_local_player():get_prop("m_bIsScoped") == 0 and 0 or -30)

    local charging = 0
    charging = math.min(exploits.get_charge(), 5) local anim = {" <>", " <|>", " <||>", " <|||>", " <||||>", " <|||||>"} local charging_anim = anim[charging % #anim+1]
    local time_left = antibrute_timer - globals.real_time()
    local indicate_binds = {
        ["ab p:"..antibrute_phase.." t:"..math.floor(time_left)] = antibrute(),
        ["dt"..charging_anim] = refs.doubletap:get(),
        ["osaa"] = refs.hideshots:get(),
        ["peek"] = refs.autopeek:get(),
        ["dmg"] = menu.find("aimbot", weapons[math.min(ragebot.get_active_cfg(), 6)], "target overrides", "min. damage")[2]:get()
    }

    render.text(lua.fonts.pixel, "medusa", vec2_t(screensize.x/2 - render.get_text_size(lua.fonts.pixel, "medusa").x/2+1 - math.min(0, math.floor(ind_anim.scope)), screensize.y/2 + 10), color_t(_ui.accent_color:get().r, _ui.accent_color:get().g, _ui.accent_color:get().b, 255))
    render.text(lua.fonts.pixel, aa_state_full[state], vec2_t(screensize.x/2 - math.floor(ind_anim.state) - math.min(math.floor(ind_anim.scope), 0), screensize.y/2 + 20), color_t(255, 255, 255, 255))
    local add_y = 20
    for _, bind_name in ipairs({"ab p:"..antibrute_phase.." t:"..math.floor(time_left), "dt"..charging_anim, "osaa", "apeek", "dmg"}) do
        if indicate_binds[bind_name] then
            render.text(lua.fonts.pixel, bind_name, vec2_t(screensize.x/2 - render.get_text_size(lua.fonts.pixel, bind_name).x/2+1 - math.floor(ind_anim.scope), screensize.y/2 + 10 + add_y), color_t(255, 255, 255, 255))
            add_y = add_y + 10
        end
    end
end

local vw_anim = {appearing = 0, appearing_alpha = 0, scope = 0, triangle = 0}
local velocity_warning = function()
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() or not _ui.visuals.master:get() or not _ui.visuals.velocity_warning:get() then return end
    local frametime = math.floor(globals.frame_time()*150)
    local modifier = entity_list.get_local_player():get_prop("m_flVelocityModifier")
    vw_anim.appearing = lerp(0.06 + math.min(frametime/10.1, 0.25), vw_anim.appearing, (modifier < 1 or menu.is_open()) and 450 or 400)
    vw_anim.appearing_alpha = lerp(0.06 + math.min(frametime/10.1, 0.25), vw_anim.appearing_alpha, (modifier < 1 or menu.is_open()) and 255 or 0)
    vw_anim.scope = lerp(0.06 + math.min(frametime/10.1, 0.25), vw_anim.scope, entity_list.get_local_player():get_prop("m_bIsScoped") == 0 and 0 or -30)
    vw_anim.triangle = lerp(0.05 + math.min(frametime/10.1, 0.25), vw_anim.triangle, (modifier < 1 or menu.is_open()) and 35 or 0)

    render.rect_filled(vec2_t(screensize.x/2 - math.floor(vw_anim.scope) - 17, math.floor(vw_anim.appearing)+10), vec2_t(35, 6), color_t(29,29,29, math.min(math.floor(vw_anim.appearing_alpha), 200)))
    render.rect_filled(vec2_t(screensize.x/2 - math.floor(vw_anim.scope) - 15, math.floor(vw_anim.appearing)+12), vec2_t(31*modifier, 2), color_t(_ui.accent_color:get().r, _ui.accent_color:get().g, _ui.accent_color:get().b, math.floor(vw_anim.appearing_alpha)))
    render.triangle(vec2_t.new(screensize.x/2 - math.floor(vw_anim.scope), math.floor(vw_anim.appearing)-5), math.floor(vw_anim.triangle)+2, color_t(_ui.accent_color:get().r, _ui.accent_color:get().g, _ui.accent_color:get().b, math.floor(vw_anim.appearing_alpha)))
    render.triangle_filled(vec2_t.new(screensize.x/2 - math.floor(vw_anim.scope), math.floor(vw_anim.appearing)-4), math.floor(vw_anim.triangle), color_t(29,29,29, math.min(math.floor(vw_anim.appearing_alpha), 225)), 0)
    render.text(lua.fonts.pixel_b, "!", vec2_t(screensize.x/2 - render.get_text_size(lua.fonts.pixel_b, "!").x/2+2 - math.floor(vw_anim.scope), math.max(math.floor(vw_anim.appearing), 425)-30), color_t(_ui.accent_color:get().r, _ui.accent_color:get().g, _ui.accent_color:get().b, math.floor(vw_anim.appearing_alpha)))
    render.text(lua.fonts.pixel, "velocity", vec2_t(screensize.x/2 - render.get_text_size(lua.fonts.pixel, "velocity").x/2+1 - math.floor(vw_anim.scope), math.floor(vw_anim.appearing)-2), color_t(255,255,255, math.floor(vw_anim.appearing_alpha)))
end

-- other_features
local _set_clantag = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15")) local _last_clantag = nil
local set_clantag = function(v) if not engine.is_connected() then return end if v == _last_clantag then return end _set_clantag(v, v) _last_clantag = v end

local clantag = {
    "⌛    M",
    "⌛    Me",
    "⌛    Med",
    "⌛    Medu",
    "⌛    Medus",
    "⌛    Medusa",
    "⌛    Medusa",
    "⌛    Medusa",
    "⌛    Medusa",
    "⌛    Medusa",
    "⌛    Medusa",
    "⌛    Medusa",
    "⌛    Medusa",
    "⌛    Medus",
    "⌛    Medu",
    "⌛    Med",
    "⌛    Me",
    "⌛    M",
    "⌛    ",
    "⌛    ",
}

local clantag = function()
    if not engine.is_connected() or not engine.is_in_game() or not _ui.other.clantag:get() or not _ui.other.master:get() then set_clantag("") return end
    local latency = engine.get_latency(0) / global_vars.interval_per_tick()
    local tickcount_pred = global_vars.tick_count() + latency
    local animation = math.floor(math.fmod(tickcount_pred / 20, #clantag) + 1)

    set_clantag(clantag[animation])
end

local target = nil
local round_start_im_retard = function(event)
    target = nil
end
callbacks.add(e_callbacks.EVENT, round_start_im_retard, "round_start")

local phrases = {
    retarded = {
        "когда видишь жопу горилы и такой кончаешь 3 раза",
        "ЪЪЪЪ)))) ооппоповап ЪЪЪ БББЮ",
        "world of tanks blitz (◣_◢)",
        "ты когда срал последний раз?",
        "бля яйцо почесал заеюись ваще",
        "do you like blak dicks?",
        "а у вас тоже говно на улице летает?",
        "Тронуло до самой души! Читать всем! Звонок в час ночи: -Алло.",
        "как же я хочу насрать тебе горячего поносика на личико",
        "мяу я срать хочу",
        "у вас тоже залупа начинает светиться после 4:61?",
        "сколько у тебя волос на яйцах? У меня вот 482",
        "кто хохол + в чат",
        "all dogs scared when i pull out my black dick (◣_◢)",
        "от меня вчера убежал хуй",
        "моё говно превратилось в монстра и выебало мою собаку",
        "ёбля армян на 8 марта"
    }
}
local target = nil
local round_start_reset = function(event)
    target = nil
end
callbacks.add(e_callbacks.EVENT, round_start_reset, "round_start")
local current_phrase_index = 1
local trashtalk = function(event)
    if not _ui.other.master:get() or not _ui.other.trashtalk:get() then return end
    local enemy = entity_list.get_player_from_userid(event.attacker, true)
    local attacker = entity_list.get_player_from_userid(event.attacker, true)
    local userid = entity_list.get_player_from_userid(event.userid, true)

    if _ui.other.tt_revenge:get() then 
        if userid == entity_list.get_local_player() then 
            target = attacker 
        elseif userid == target and target ~= entity_list.get_local_player() then
            engine.execute_cmd("say 1.")
        end
    end

    if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() or userid == entity_list.get_local_player() then return end
    local phrase = phrases.retarded[current_phrase_index]
    client.delay_call(function() engine.execute_cmd("say " .. phrase) end, _ui.other.tt_delay:get())
    current_phrase_index = (current_phrase_index % #phrases.retarded) + 1
end
callbacks.add(e_callbacks.EVENT, trashtalk, "player_death")

-- rage_features
local function interpolation()
    cvars.cl_interpolate:set_int(_ui.rage.master:get() and _ui.rage.interpolation:get() and 0 or 1)
end

local DEAGLE_LAND_HIT_CHANCE = 1
local bit = require "bit"
local WEAP_DEAGLE = 1
local restore_hit_chance = nil
local was_on_ground = false
local old_hc = {refs.deagle_hc:get()}
local function is_on_ground() return bit.band(entity_list.get_local_player():get_prop("m_fFlags"), bit.lshift(1, 0)) ~= 0 end

callbacks.add(e_callbacks.SETUP_COMMAND, function()
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() or not _ui.rage.deagle_nospread:get() or not _ui.rage.master:get() then return end
    if restore_hit_chance ~= nil then
        if refs.deagle_hc:get() == DEAGLE_LAND_HIT_CHANCE then
            refs.deagle_hc:set(restore_hit_chance)
        end
        restore_hit_chance = nil
    end
    was_on_ground = is_on_ground()
end)

callbacks.add(e_callbacks.RUN_COMMAND, function()
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() or not _ui.rage.deagle_nospread:get() or not _ui.rage.master:get() then return end
    if was_on_ground == false and is_on_ground() then
        local weapon = getweapon()
        if weapon == "deagle" then
            restore_hit_chance = refs.deagle_hc:get()
            refs.deagle_hc:set(DEAGLE_LAND_HIT_CHANCE)
        end
    end
end)

-- callbacks
callbacks.add(e_callbacks.PAINT, function()
    visiblity()
    interpolation()
    clantag()
    menu_watermark()
    indicators()
    velocity_warning()
end)

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    antiaim()
    fakelag_onshot(ctx)
    animbreakers(ctx)
    antibrute()
end)

callbacks.add(e_callbacks.AIMBOT_SHOOT, function(shot)
    on_aimbot_shoot(shot)
end)

callbacks.add(e_callbacks.SHUTDOWN, function()
    set_clantag("")
end)