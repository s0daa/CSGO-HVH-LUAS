ffi.cdef [[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local allowload = true
local build = "stable"
local buildver = "2.2"

client.log_screen("Solutions ", color_t(207,218,255), "["..build.."] ",  color_t(255,255,255), "successfuly loaded! User:", color_t(232,209,255), ""..user.name.. " [" ..user.uid.. "].")
engine.execute_cmd("play load_sound.wav")

-- other shit
local pixel = render.create_font("Smallest Pixel-7", 11, 20, e_font_flags.OUTLINE)
local smallfonts = render.create_font("Small Fonts", 11, 20, e_font_flags.OUTLINE)
local screensize = render.get_screen_size()
local engine_client_interface = memory.create_interface("engine.dll", "VEngineClient014")
local get_net_channel_info = ffi.cast("void*(__thiscall*)(void*)",memory.get_vfunc(engine_client_interface,78))
local net_channel_info = get_net_channel_info(ffi.cast("void***",engine_client_interface))
local get_latency = ffi.cast("float(__thiscall*)(void*,int)",memory.get_vfunc(tonumber(ffi.cast("unsigned long",net_channel_info)),9))

-- killsay phrases
local killsay_phrases = {

    ksay_russian = {

        "Используйте Solutions.tech, чтобы исправить все ваши проблемы с hvh"
    },

    ksay_english = {
        "what this fella doin??",
        "Use Solutions.tech to fix all your hvh problems",
        "dont be loser buy Solutions Prim",
        "which fella stole your resolver?",
        "Did you really sold your soul for that cheat?",
		"Get Good, Get primordial.dev.",
        "Insert > Ragebot > Turn ON.",
        "Refund that paste.",
		"*dead*",
		"Give me ur selly so i can fix that trash cfg lmao",
        "get time hacked lol",
        "fix ur cheat fella",
        "by god mode hack",
        "1",
        "oops it looks like your cheat is pasted",
    },

    ksay_english_hs = {
        "Use Solutions.tech to fix all your hvh problems",
        "Dam that crazy aa ",
        "INSANE AA",
        "OMG nice aa ",
        "sussy aa",
        "The best aa",
        "1000p aa",
        "cracked aa",
        "mindblowing aa can i get the same one?",
        "seems like ur incredible 5 nle shitpasted aa's got owned",
        "is your antiaim enabled?",
        "2 x 1 = ?",
        "W aa",
        "pasted ass aa bro",
        'still wasting ur money on "antiaim" luas?',
        "shitty aa lua, buy another one",
    }

}

-- primo menu references
local refs = {
    -- aimbot refs
    as_scout                = menu.find("aimbot", "scout", "accuracy", "options"),
    as_awp                  = menu.find("aimbot", "awp", "accuracy", "options"),
    autopeek                = menu.find("aimbot", "general", "misc", "autopeek")[2],
    doubletap               = menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2],
    hideshots               = menu.find("aimbot", "general", "exploits", "hideshots", "enable")[2],
    prediction              = menu.find("aimbot", "general", "exploits", "force prediction"),
    min_damage_a            = menu.find("aimbot", "auto", "target overrides", "force min. damage")[2],
    min_damage_s            = menu.find("aimbot", "scout", "target overrides", "force min. damage")[2],
    min_damage_r            = menu.find("aimbot", "revolver", "target overrides", "force min. damage")[2],
    min_damage_d            = menu.find("aimbot", "deagle", "target overrides", "force min. damage")[2],
    min_damage_p            = menu.find("aimbot", "pistols", "target overrides", "force min. damage")[2],
    min_damage_awp          = menu.find("aimbot", "awp", "target overrides", "force min. damage")[2],
    amount_auto             = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage")),
    amount_scout            = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage")),
    amount_awp              = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage")),
    amount_revolver         = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage")),
    amount_deagle           = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage")),
    amount_pistol           = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage")),
    -- antiaim refs
    pitch                   = menu.find("antiaim", "main", "angles", "pitch"),
    yawbase                 = menu.find("antiaim", "main", "angles", "yaw base"),
    yawadd                  = menu.find("antiaim", "main", "angles", "yaw add"),
    leanmode                = menu.find("antiaim", "main", "angles", "body lean"),
    jittertype              = menu.find("antiaim", "main", "angles", "jitter type"),
    jittermode              = menu.find("antiaim", "main", "angles", "jitter mode"),
    jitteradd               = menu.find("antiaim", "main", "angles", "jitter add"),
    legslide                = menu.find("antiaim", "main", "general", "leg slide"),
    fakelagval              = menu.find("antiaim", "main", "fakelag", "amount"),
    fakemode                = menu.find("antiaim", "main", "desync", "stand", "side"),
    fakevalleft             = menu.find("antiaim", "main", "desync", "stand", "left amount"),
    fakevalright            = menu.find("antiaim", "main", "desync", "stand", "right amount"),
    overridestandmove       = menu.find("antiaim", "main", "desync", "override stand#move"),
    overridestandslide      = menu.find("antiaim", "main", "desync", "override stand#slow walk"),
    manualleft              = menu.find("antiaim", "main", "manual", "left"),
    manualright             = menu.find("antiaim", "main", "manual", "right"),
    fakeval                 = menu.find("antiaim", "main", "angles", "yaw add"),
    leanval                 = menu.find("antiaim", "main", "angles", "body lean value"),
    fake_duck               = menu.find("antiaim", "main", "general", "fake duck")[2],
    -- visuals refs
    penetration             = menu.find("visuals", "other", "crosshair", "penetration crosshair")[1],
    -- misc refs
    slowwalk                = menu.find("misc", "main", "movement", "slow walk")[2],
    autostrafe_ref          = menu.find("misc", "main", "movement", "autostrafer"),
    gh_ref                  = menu.find("misc", "utility", "nade helper", "autothrow")[2],
    accentclr               = menu.find("misc", "main", "config", "accent color")[2],
    buybot                  = menu.find("misc", "utility", "buybot", "enable"),
}

-- getting velocity
function get_velocity()
    local first_velocity = entity_list.get_local_player():get_prop("m_vecVelocity[0]")
    local second_velocity = entity_list.get_local_player():get_prop("m_vecVelocity[1]")
    local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
    
    return speed
end

-- getting weapon
local function getweapon()
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

local function getweapon_enemy()
    local weapon_name = nil

    for _, enemy in pairs(entity_list.get_players(true)) do
        local active_weapon = enemy:get_active_weapon()
        if active_weapon == nil then return end

        enemy_weapon_name = active_weapon:get_name()
    end

    return enemy_weapon_name

end

function get_state(speed)
    if not engine.is_connected() then return end
    if not entity_list.get_local_player():is_alive() then return end

    local flags = entity_list.get_local_player():get_prop("m_fFlags")
    if bit.band(flags, 1) == 1 then
        if bit.band(flags, 4) == 4 or antiaim.is_fakeducking() then 
            return 4 -- Crouching
        else
            if speed <= 3 then
                return 1 -- Standing
            else
                if refs.slowwalk:get() then
                    return 3 -- Slowwalk
                else
                    return 2 -- Moving
                end
            end
        end
    elseif bit.band(flags, 1) == 0 then
        if bit.band(flags, 4) == 4 then
            return 6 -- Air Crouch
        else
            return 5 -- Air
        end
    end
end

-- config shit
local VGUI_System010 =  memory.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
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

local function str_to_sub(text, sep)
	local t = {}
	for str2 in string.gmatch(text, "([^"..sep.."]+)") do
		t[#t + 1] = string.gsub(str2, "\n", " ")
	end
	return t
end

local function to_boolean(str2)
	if str2 == "true" or str2 == "false" then
		return (str2 == "true")
	else
		return str2
	end
end

-- tab shit
local maintab = {
    tabselection                  = menu.add_list("Solutions", "hello " ..user.name.. ", please select tab", {"›  ragebot", "›  antiaim", "›  visual", "›  miscellaneous", "›  information"}, 5),
    textaa                        = menu.add_text("Solutions", "antiaim configs -"),
    cfg_import                    = menu.add_button("Solutions", "import config", function() configs.import() end),
    cfg_export                    = menu.add_button("Solutions", "export config", function() configs.export() end),
    cfg_default                   = menu.add_button("Solutions", "get default config", function() clipboard_export("true|0|0|0|-11|41|2|0|0|0|-5|-29|0|61|100|100|100|19|88|28|17|0|26|100|100|false|1|false|1|false|1|false|1|false|1|false|1|0|0|0|0|0|0|0|0|0|0|0|0|28|30|21|23|17|32|1|1|1|1|1|1|0|-5|0|9|58|17|false|false|true|true|true|false|1|false|false|0|0|false|0|0|true|0|14|true|0|14|false|0|0|false|0|0|true|-3|-8|true|-3|-8|true|-1|-8|true|-1|-8|true|-2|1|true|-2|1|true|2|5|true|2|5|true|true|true|false|true|true|0|0|100|50|false|1|0|0|26|1|12|true|true|false|false|false|false|false|true|false|false|true|true|17|") client.log_screen("copied!") engine.execute_cmd("play aa_config.wav") end),
    space123                      = menu.add_text("Solutions", "discord server -"),
    discordlink                   = menu.add_button("Solutions", "copy link", function() clipboard_export("https://discord.gg/FZpMQkde") client.log_screen("copied!") end),
}

maintab.tabselection:set(5)

local aa_f = {
    --tanki online
    aa_check                      = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "antiaim builder", false),
    conditionselection            = menu.add_selection("Solutions  ›  antiaim  ›  main", "condition", {"global", "standing", "moving", "air", "air-duck", "crouching", "slow walk"}),

    -- override global
    aa_overg_stand                = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[s]  override global", false),
    aa_overg_move                 = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[m]  override global", false),
    aa_overg_air                  = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[a]  override global", false),
    aa_overg_airduck              = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[a-d] override global", false),
    aa_overg_crouch               = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[c]  override global", false),
    aa_overg_slowwalk             = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[sw] override global", false),

    -- jitter type
    aa_jittertype_global          = menu.add_selection("Solutions  ›  antiaim  ›  main", "[g] jitter type ", {"center", "offset"}),
    aa_jittertype_stand           = menu.add_selection("Solutions  ›  antiaim  ›  main", "[s] jitter type ", {"center", "offset"}),
    aa_jittertype_move            = menu.add_selection("Solutions  ›  antiaim  ›  main", "[m] jitter type", {"center", "offset"}),
    aa_jittertype_air             = menu.add_selection("Solutions  ›  antiaim  ›  main", "[a] jitter type", {"center", "offset"}),
    aa_jittertype_airduck         = menu.add_selection("Solutions  ›  antiaim  ›  main", "[a-d] jitter type", {"center", "offset"}),
    aa_jittertype_crouch          = menu.add_selection("Solutions  ›  antiaim  ›  main", "[c] jitter type", {"center", "offset"}),
    aa_jittertype_slowwalk        = menu.add_selection("Solutions  ›  antiaim  ›  main", "[sw] jitter type", {"center", "offset"}),
    -- jitter add
    aa_jitter_global              = menu.add_slider("Solutions  ›  antiaim  ›  main", "[g] jitter add", -180, 180),
    aa_jitter_stand               = menu.add_slider("Solutions  ›  antiaim  ›  main", "[s] jitter add", -180, 180),
    aa_jitter_move                = menu.add_slider("Solutions  ›  antiaim  ›  main", "[m] jitter add", -180, 180),
    aa_jitter_air                 = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a] jitter add", -180, 180),
    aa_jitter_crouch              = menu.add_slider("Solutions  ›  antiaim  ›  main", "[c] jitter add", -180, 180),
    aa_jitter_airduck             = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a-d] jitter add", -180, 180),
    aa_jitter_slowwalk            = menu.add_slider("Solutions  ›  antiaim  ›  main", "[sw] jitter add", -180, 180),
    --yaw left
    aa_yawlimleft_global          = menu.add_slider("Solutions  ›  antiaim  ›  main", "[g] yaw limit left", -90, 90),
    aa_yawlimleft_stand           = menu.add_slider("Solutions  ›  antiaim  ›  main", "[s] yaw limit left", -90, 90),
    aa_yawlimleft_move            = menu.add_slider("Solutions  ›  antiaim  ›  main", "[m] yaw limit left", -90, 90),
    aa_yawlimleft_air             = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a] yaw limit left", -90, 90),
    aa_yawlimleft_airduck         = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a-d] yaw limit left", -90, 90),
    aa_yawlimleft_crouch          = menu.add_slider("Solutions  ›  antiaim  ›  main", "[c] yaw limit left", -90, 90),
    aa_yawlimleft_slowwalk        = menu.add_slider("Solutions  ›  antiaim  ›  main", "[sw] yaw limit left", -90, 90),
    --yaw right
    aa_yawlimright_global          = menu.add_slider("Solutions  ›  antiaim  ›  main", "[g] yaw limit right", -90, 90),
    aa_yawlimright_stand          = menu.add_slider("Solutions  ›  antiaim  ›  main", "[s] yaw limit right", -90, 90),
    aa_yawlimright_move           = menu.add_slider("Solutions  ›  antiaim  ›  main", "[m] yaw limit right", -90, 90),
    aa_yawlimright_air            = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a] yaw limit right", -90, 90),
    aa_yawlimright_airduck        = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a-d] yaw limit right", -90, 90),
    aa_yawlimright_crouch         = menu.add_slider("Solutions  ›  antiaim  ›  main", "[c] yaw limit right", -90, 90),
    aa_yawlimright_slowwalk       = menu.add_slider("Solutions  ›  antiaim  ›  main", "[sw] yaw limit right", -90, 90),
    --yaw offset
    aa_offset_global               = menu.add_slider("Solutions  ›  antiaim  ›  main", "[g] yaw offset", -180, 180),
    aa_offset_stand               = menu.add_slider("Solutions  ›  antiaim  ›  main", "[s] yaw offset", -180, 180),
    aa_offset_move                = menu.add_slider("Solutions  ›  antiaim  ›  main", "[m] yaw offset", -180, 180),
    aa_offset_air                 = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a] yaw offset", -180, 180),
    aa_offset_airduck             = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a-d] yaw offset", -180, 180),
    aa_offset_crouch              = menu.add_slider("Solutions  ›  antiaim  ›  main", "[c] yaw loffset", -180, 180),
    aa_offset_slowwalk            = menu.add_slider("Solutions  ›  antiaim  ›  main", "[sw] yaw offset", -180, 180),
    --fake left
    aa_fakelimleft_global          = menu.add_slider("Solutions  ›  antiaim  ›  main", "[g] fake limit left", 0, 100),
    aa_fakelimleft_stand          = menu.add_slider("Solutions  ›  antiaim  ›  main", "[s] fake limit left", 0, 100),
    aa_fakelimleft_move           = menu.add_slider("Solutions  ›  antiaim  ›  main", "[m] fake limit left", 0, 100),
    aa_fakelimleft_air            = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a] fake limit left", 0, 100),
    aa_fakelimleft_airduck        = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a-d] fake limit left", 0, 100),
    aa_fakelimleft_crouch         = menu.add_slider("Solutions  ›  antiaim  ›  main", "[c] fake limit left", 0, 100),
    aa_fakelimleft_slowwalk       = menu.add_slider("Solutions  ›  antiaim  ›  main", "[sw] fake limit left", 0, 100),
    --fake right
    aa_fakelimright_global         = menu.add_slider("Solutions  ›  antiaim  ›  main", "[g] fake limit right", 0, 100),
    aa_fakelimright_stand         = menu.add_slider("Solutions  ›  antiaim  ›  main", "[s] fake limit right", 0, 100),
    aa_fakelimright_move          = menu.add_slider("Solutions  ›  antiaim  ›  main", "[m] fake limit right", 0, 100),
    aa_fakelimright_air           = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a] fake limit right", 0, 100),
    aa_fakelimright_airduck       = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a-d] fake limit right", 0, 100),
    aa_fakelimright_crouch        = menu.add_slider("Solutions  ›  antiaim  ›  main", "[c] fake limit right", 0, 100),
    aa_fakelimright_slowwalk      = menu.add_slider("Solutions  ›  antiaim  ›  main", "[sw] fake limit right", 0, 100),
    --lean checks & modes
    aa_lean_check_global           = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[g] use body lean", false),
    aa_lean_mode_global            = menu.add_selection("Solutions  ›  antiaim  ›  main", "[g] body lean mode", {"static", "jitter"}),
    aa_lean_check_stand           = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[s] use body lean", false),
    aa_lean_mode_stand            = menu.add_selection("Solutions  ›  antiaim  ›  main", "[s] body lean mode", {"static", "jitter"}),
    aa_lean_check_move            = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[m] use body lean", false),
    aa_lean_mode_move             = menu.add_selection("Solutions  ›  antiaim  ›  main", "[m] body lean mode", {"static", "jitter"}),
    aa_lean_check_air             = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[a] use body lean", false),
    aa_lean_mode_air              = menu.add_selection("Solutions  ›  antiaim  ›  main", "[a] body lean mode", {"static", "jitter"}),
    aa_lean_check_airduck         = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[a-d] use body lean", false),
    aa_lean_mode_airduck          = menu.add_selection("Solutions  ›  antiaim  ›  main", "[a-d] body lean mode", {"static", "jitter"}),
    aa_lean_check_crouch          = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[c] use body lean", false),
    aa_lean_mode_crouch           = menu.add_selection("Solutions  ›  antiaim  ›  main", "[c] body lean mode", {"static", "jitter"}),
    aa_lean_check_slowwalk        = menu.add_checkbox("Solutions  ›  antiaim  ›  main", "[sw] use body lean", false),
    aa_lean_mode_slowwalk         = menu.add_selection("Solutions  ›  antiaim  ›  main", "[sw] body lean mode", {"static", "jitter"}),
    --lean left
    aa_leanlimleft_global          = menu.add_slider("Solutions  ›  antiaim  ›  main", "[g] lean limit left", 0, 50),
    aa_leanlimleft_stand          = menu.add_slider("Solutions  ›  antiaim  ›  main", "[s] lean limit left", 0, 50),
    aa_leanlimleft_move           = menu.add_slider("Solutions  ›  antiaim  ›  main", "[m] lean limit left", 0, 50),
    aa_leanlimleft_air            = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a] lean limit left", 0, 50),
    aa_leanlimleft_airduck        = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a-d] lean limit left", 0, 50),
    aa_leanlimleft_crouch         = menu.add_slider("Solutions  ›  antiaim  ›  main", "[c] lean limit left", 0, 50),
    aa_leanlimleft_slowwalk       = menu.add_slider("Solutions  ›  antiaim  ›  main", "[sw] lean limit left", 0, 50),
    --lean right
    aa_leanlimright_global         = menu.add_slider("Solutions  ›  antiaim  ›  main", "[g] lean limit right", 0, 50),
    aa_leanlimright_stand         = menu.add_slider("Solutions  ›  antiaim  ›  main", "[s] lean limit right", 0, 50),
    aa_leanlimright_move          = menu.add_slider("Solutions  ›  antiaim  ›  main", "[m] lean limit right", 0, 50),
    aa_leanlimright_air           = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a] lean limit right", 0, 50),
    aa_leanlimright_airduck       = menu.add_slider("Solutions  ›  antiaim  ›  main", "[a-d] lean limit right", 0, 50),
    aa_leanlimright_crouch        = menu.add_slider("Solutions  ›  antiaim  ›  main", "[c] lean limit right", 0, 50),
    aa_leanlimright_slowwalk      = menu.add_slider("Solutions  ›  antiaim  ›  main", "[sw] lean limit right", 0, 50),
    aa_lean_switchside            = menu.add_text("Solutions  ›  antiaim  ›  main", "switch static Lean side"),
    --yaw randomise left
    aa_randomise_global_left_check = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[g] randomise left yaw side", false),
    aa_randomise_global_left1      = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[g] randomise value 1", -20, 20),
    aa_randomise_global_left2      = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[g] randomise value 2", -20, 20),
    aa_randomise_stand_left_check = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[s] randomise left yaw side", false),
    aa_randomise_stand_left1      = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[s] randomise value 1", -20, 20),
    aa_randomise_stand_left2      = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[s] randomise value 2", -20, 20),
    aa_randomise_move_left_check  = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[m] randomise left yaw side", false),    
    aa_randomise_move_left1       = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[m] randomise value 1", -20, 20),
    aa_randomise_move_left2       = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[m] randomise value 2", -20, 20),    
    aa_randomise_air_left_check   = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[a] randomise left yaw side", false),    
    aa_randomise_air_left1        = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[a] randomise value 1", -20, 20),
    aa_randomise_air_left2        = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[a] randomise value 2", -20, 20),    
    aa_randomise_airduck_left_check   = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[a-d] randomise left yaw side", false),    
    aa_randomise_airduck_left1    = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[a-d] randomise value 1", -20, 20),
    aa_randomise_airduck_left2    = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[a-d] randomise value 2", -20, 20),
    aa_randomise_crouch_left_check   = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[c] randomise left yaw side", false),    
    aa_randomise_crouch_left1     = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[c] randomise value 1", -20, 20),
    aa_randomise_crouch_left2     = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[c] randomise value 2", -20, 20),    
    aa_randomise_slowwalk_left_check   = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[sw] randomise left yaw side", false),    
    aa_randomise_slowwalk_left1   = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[sw] randomise value 1", -20, 20),
    aa_randomise_slowwalk_left2   = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[sw] randomise value 2", -20, 20),    
    --yaw randomise right
    aa_randomise_global_right_check= menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[g] randomise right yaw side", false),
    aa_randomise_global_right1     = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[g] randomise value 1", -20, 20),
    aa_randomise_global_right2     = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[g] randomise value 2", -20, 20),
    aa_randomise_stand_right_check= menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[s] randomise right yaw side", false),
    aa_randomise_stand_right1     = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[s] randomise value 1", -20, 20),
    aa_randomise_stand_right2     = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[s] randomise value 2", -20, 20),
    aa_randomise_move_right_check = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[m] randomise right yaw side", false),    
    aa_randomise_move_right1      = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[m] randomise value 1", -20, 20),
    aa_randomise_move_right2      = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[m] randomise value 2", -20, 20),   
    aa_randomise_air_right_check  = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[a] randomise right yaw side", false),    
    aa_randomise_air_right1       = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[a] randomise value 1", -20, 20),
    aa_randomise_air_right2       = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[a] randomise value 2", -20, 20),    
    aa_randomise_airduck_right_check  = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[a-d] randomise right yaw side", false),    
    aa_randomise_airduck_right1   = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[a-d] randomise value 1", -20, 20),
    aa_randomise_airduck_right2   = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[a-d] randomise value 2", -20, 20), 
    aa_randomise_crouch_right_check  = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[c] randomise right yaw side", false),    
    aa_randomise_crouch_right1    = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[c] randomise value 1", -20, 20),
    aa_randomise_crouch_right2    = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[c] randomise value 2", -20, 20),    
    aa_randomise_slowwalk_right_check  = menu.add_checkbox("Solutions  ›  antiaim  ›  main  ›  additional features", "[sw] randomise right yaw side", false),    
    aa_randomise_slowwalk_right1  = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[sw] randomise value 1", -20, 20),
    aa_randomise_slowwalk_right2  = menu.add_slider("Solutions  ›  antiaim  ›  main  ›  additional features", "[sw] randomise value 2", -20, 20),
    -- animbreaker
    aa_animbreaker_check          = menu.add_checkbox("Solutions  ›  antiaim  ›  other", "animation breakers", false),
    aa_animbreaker_main           = menu.add_multi_selection("Solutions  ›  antiaim  ›  other", "main", {"lean in air", "legs in air", "backward slide", "0 pitch on land", "static legs on slowwalk"}),
    aa_animbreaker_legs           = menu.add_selection("Solutions  ›  antiaim  ›  other", "legs in air", {"static", "walk"}),
    aa_animbreaker_other          = menu.add_multi_selection("Solutions  ›  antiaim  ›  other", "other", {"sus"}),
    -- onshot fl
    onshotfl_check                = menu.add_checkbox("Solutions  ›  antiaim  ›  other", "on shot fakelag", false),
    -- lc
    lc_check                      = menu.add_checkbox("Solutions  ›  antiaim  ›  other", "break lc in air", false),
    lc_weapons                    = menu.add_multi_selection("Solutions  ›  antiaim  ›  other", "weapons", {"scout", "auto", "awp", "pistols", "deagle", "revolver", "taser", "other"}),
    lc_state_check                = menu.add_checkbox("Solutions  ›  antiaim  ›  other", "in all states", false),
    -- anti zeus
    anti_zeus_check               = menu.add_checkbox("Solutions  ›  antiaim  ›  other", "anti zeus", false),
    anti_zeus_max_dist            = menu.add_slider("Solutions  ›  antiaim  ›  other", "distance", 10, 30),
    -- warmup
    warmup_check                  = menu.add_checkbox("Solutions  ›  antiaim  ›  other", "shitty preset on warmup", false),
}
aa_f.anti_zeus_max_dist:set(17)

local rage_f = {
    customdt_check                = menu.add_checkbox("Solutions  ›  ragebot  ›  main", "override doubletap", false),
    customdt_speed                = menu.add_slider("Solutions  ›  ragebot  ›  main", "speed", 10, 22),
    customdt_waning               = menu.add_text("Solutions  ›  ragebot  ›  main", "this dt speed may cause unregistered shots."),
    customdt_corrections          = menu.add_checkbox("Solutions  ›  ragebot  ›  main", "disable corrections", false),
    recharge_check                = menu.add_checkbox("Solutions  ›  ragebot  ›  main", "faster recharge", false),
    disableinterp_check           = menu.add_checkbox("Solutions  ›  ragebot  ›  main", "disable interpolation", false),
    prediction_check              = menu.add_checkbox("Solutions  ›  ragebot  ›  main", "better prediction", false),
    prediction_warning            = menu.add_text("Solutions  ›  ragebot  ›  main", "recommended to use this feature only with force prediction."),
    early_check                   = menu.add_checkbox("Solutions  ›  ragebot  ›  main", "early autostop on autopeek", false),
    early_weapons                 = menu.add_multi_selection("Solutions  ›  ragebot  ›  main", "weapons", {"scout", "awp"}),
}
rage_f.customdt_speed:set(15)

local visual_f = {
    windows_combo                 = menu.add_multi_selection("Solutions  ›  visual  ›  main", "windows", {"watermark", "keybinds"}),
    windows_mode                  = menu.add_selection("Solutions  ›  visual  ›  main", "windows style", {"Solutions ui v1", "Solutions ui v2"}),
    watermark_custom_watername    = menu.add_selection("Solutions  ›  visual  ›  main", "watermark name", {"Solutions", "primordial", "primordial | Solutions", "custom"}),
    watermark_custom_custom       = menu.add_text_input("Solutions  ›  visual  ›  main", "name"),
    watermark_custom_showuid      = menu.add_checkbox("Solutions  ›  visual  ›  main", "show uid", false),
    indicators_check              = menu.add_checkbox("Solutions  ›  visual  ›  main", "indicators", false),
    indicators_customisation      = menu.add_multi_selection("Solutions  ›  visual  ›  main", "customisation", {"doubletap charge bar", "background", "state color", "display desync side"}),
    indicators_customisation_bg   = menu.add_multi_selection("Solutions  ›  visual  ›  main", "apply background on", {"watermark", "state", "binds"}),
    indicators_state_color        = menu.add_selection("Solutions  ›  visual  ›  main", "state color mode", {"default", "state based"}),
    indicators_customisation_rect = menu.add_checkbox("Solutions  ›  visual  ›  main", "background rect", false),
    disable_primomark             = menu.add_checkbox("Solutions  ›  visual  ›  main", "disable primordial watermark", false),

    lethal_indicator_check        = menu.add_checkbox("Solutions  ›  visual  ›  main", "lethal indicator", false),
    slowdownind_check             = menu.add_checkbox("Solutions  ›  visual  ›  main", "slowed down indicator", false),
    infobox_check                 = menu.add_checkbox("Solutions  ›  visual  ›  main", "info box", false),
    penisdot_check                = menu.add_checkbox("Solutions  ›  visual  ›  main", "better penetration dot", false),
    zeus_warning_check            = menu.add_checkbox("Solutions  ›  visual  ›  main", "zeus warning", false),
    lobby_waning                  = menu.add_text("Solutions  ›  visual  ›  main", "you are in lobby some visual features will not work."),

    floydmode_check               = menu.add_checkbox("Solutions  ›  visual  ›  other", "dark theme", false),

    color_theme_mode              = menu.add_selection("Solutions  ›  visual  ›  accent color", "accent color mode", {"custom", "sync with menu"}),
    color_theme_text              = menu.add_text("Solutions  ›  visual  ›  accent color", "accent color main"),
    color_theme_text_2            = menu.add_text("Solutions  ›  visual  ›  accent color", "accent color second"),
    color_theme_alpha             = menu.add_slider("Solutions  ›  visual  ›  accent color", "global alpha", 0, 255),

    fonttext                      = menu.add_text("Solutions  ›  visual  ›  font", "install this font for the visuals work properly -"),
    fontlink                      = menu.add_button("Solutions  ›  visual  ›  font", "copy link", function() clipboard_export("https://www.dafont.com/smallest-pixel-7.font") client.log_screen("copied!") engine.execute_cmd("play reggin.wav") end),
}
visual_f.color_theme_alpha:set(148)

local misc_f = {
    trashtalk_check               = menu.add_checkbox("Solutions  ›  miscellaneous  ›  main", "trashtalk", false),
    trashtalk_mode                = menu.add_selection("Solutions  ›  miscellaneous  ›  main", "trashtalk mode", {"russian", "english"}),
    tt_hs_check                   = menu.add_checkbox("Solutions  ›  miscellaneous  ›  main", "announce headshot", false),
    clantag_check                 = menu.add_checkbox("Solutions  ›  miscellaneous  ›  main", "clantag", false),
    clantag_mode                  = menu.add_selection("Solutions  ›  miscellaneous  ›  main", "clantag mode", {"Solutions", "Solutions Prim"}),
    gh_fix_check                  = menu.add_checkbox("Solutions  ›  miscellaneous  ›  main", "grenade helper fix", false),
    autobuy_check                 = menu.add_checkbox("Solutions  ›  miscellaneous  ›  main", "disable autobuy on pistol round", false),

    localserver_check             = menu.add_checkbox("Solutions  ›  miscellaneous  ›  local server", "enable", false),
    localserver_configure         = menu.add_button("Solutions  ›  miscellaneous  ›  local server", "configure", function() engine.execute_cmd("sv_cheats 1; mp_do_warmup_offine 1; mp_warmuptime 14881488; mp_warmup_pausetimer 1;  mp_warmup_start; sv_infinite_ammo 1; mp_limitteams 16; mp_autoteambalance 0; bot_kick; god; sv_airaccelerate 80; bot_stop 1") end),
    localserver_bottext           = menu.add_text("Solutions  ›  miscellaneous  ›  local server", "bots -"),
    localserver_botaddct          = menu.add_button("Solutions  ›  miscellaneous  ›  local server", "add ct", function() engine.execute_cmd("bot_add_ct;") end),
    localserver_botaddt           = menu.add_button("Solutions  ›  miscellaneous  ›  local server", "add t", function() engine.execute_cmd("bot_add_t;") end),
    localserver_botkick           = menu.add_button("Solutions  ›  miscellaneous  ›  local server", "kick", function() engine.execute_cmd("bot_kick;") end),
}

local binds = {
    aa_lean_switchside_bind       = aa_f.aa_lean_switchside:add_keybind("Solutions  ›  antiaim  ›  main", "switch static lean side"),
}

local colorpickers = {
    color_theme                   = visual_f.color_theme_text:add_color_picker("Color Theme"),
    color_theme_2                 = visual_f.color_theme_text_2:add_color_picker("Color Theme 2"),
}
colorpickers.color_theme:set(color_t(207,218,255, 255))
colorpickers.color_theme_2:set(color_t(232,209,255, 255))

local infotab = {
    space132                      = menu.add_text("Solutions  ›  information  ›  main", ""),
    neforlogo                     = menu.add_text("Solutions  ›  information  ›  main", "||| Solutions.Tech"),
    space12                       = menu.add_text("Solutions  ›  information  ›  main", ""),
    neforbild                     = menu.add_text("Solutions  ›  information  ›  main", "build: "..build.. "."),
    neforver                      = menu.add_text("Solutions  ›  information  ›  main", "version: "..buildver.. "."),
    neforuser                     = menu.add_text("Solutions  ›  information  ›  main", "user: " ..user.name.. " [" ..user.uid.. "]."),
    neforcord                     = menu.add_text("Solutions  ›  information  ›  main", "join our discord server to stay up to date."),
    neforlog                      = menu.add_text("Solutions  ›  information  ›  main", "changelog and other info in discord."),
}

local unregtab = {
    text1                         = menu.add_text("error", "security exception: user doesnt have beta-access."),
    text2                         = menu.add_text("error", ""),
    text3                         = menu.add_text("error", "if someone gave you this script please messege"),
    text4                         = menu.add_text("error", "me who did it, contacts can be found below."),
    contactscopy                  = menu.add_button("error", "discord (click to copy)", function() clipboard_export("Spencer on rtx 3090 ti#0001") client.log_screen("copied!") end),
}

menu.set_group_column("Solutions", 1)
menu.set_group_column("Solutions  ›  ragebot  ›  main", 2)
menu.set_group_column("Solutions  ›  antiaim  ›  main", 2)
menu.set_group_column("Solutions  ›  antiaim  ›  main  ›  additional features", 2)
local function aa_sort() if not aa_f.aa_check:get() then menu.set_group_column("Solutions  ›  antiaim  ›  other", 2) else menu.set_group_column("Solutions  ›  antiaim  ›  other", 1) end end
menu.set_group_column("Solutions  ›  visual  ›  main", 2)
menu.set_group_column("Solutions  ›  visual  ›  other", 1)
menu.set_group_column("Solutions  ›  visual  ›  font", 1)
menu.set_group_column("Solutions  ›  visual  ›  accent color", 2)
menu.set_group_column("Solutions  ›  miscellaneous  ›  main", 2)
menu.set_group_column("Solutions  ›  miscellaneous  ›  other", 2)
menu.set_group_column("Solutions  ›  miscellaneous  ›  local server", 2)
menu.set_group_column("Solutions  ›  information  ›  main", 2)

-- config shit
configs = {}
configs.import = function(input)
    local protected = function()
        local clipboard = input == nil and clipboard_import() or input
        local tbl = str_to_sub(clipboard, "|")
        aa_f.aa_check:set(to_boolean(tbl[1]))
        aa_f.aa_yawlimleft_stand:set(tonumber(tbl[2]))
        aa_f.aa_yawlimleft_move:set(tonumber(tbl[3]))
        aa_f.aa_yawlimleft_air:set(tonumber(tbl[4]))
        aa_f.aa_yawlimleft_airduck:set(tonumber(tbl[5]))
        aa_f.aa_yawlimleft_crouch:set(tonumber(tbl[6]))
        aa_f.aa_yawlimleft_slowwalk:set(tonumber(tbl[7]))
        aa_f.aa_yawlimright_stand:set(tonumber(tbl[8]))
        aa_f.aa_yawlimright_move:set(tonumber(tbl[9]))
        aa_f.aa_yawlimright_air:set(tonumber(tbl[10]))
        aa_f.aa_yawlimright_airduck:set(tonumber(tbl[11]))
        aa_f.aa_yawlimright_crouch:set(tonumber(tbl[12]))
        aa_f.aa_yawlimright_slowwalk:set(tonumber(tbl[13]))
        aa_f.aa_fakelimleft_stand:set(tonumber(tbl[14]))
        aa_f.aa_fakelimleft_move:set(tonumber(tbl[15]))
        aa_f.aa_fakelimleft_air:set(tonumber(tbl[16]))
        aa_f.aa_fakelimleft_airduck:set(tonumber(tbl[17]))
        aa_f.aa_fakelimleft_crouch:set(tonumber(tbl[18]))
        aa_f.aa_fakelimleft_slowwalk:set(tonumber(tbl[19]))
        aa_f.aa_fakelimright_stand:set(tonumber(tbl[20]))
        aa_f.aa_fakelimright_move:set(tonumber(tbl[21]))
        aa_f.aa_fakelimright_air:set(tonumber(tbl[22]))
        aa_f.aa_fakelimright_airduck:set(tonumber(tbl[23]))
        aa_f.aa_fakelimright_crouch:set(tonumber(tbl[24]))
        aa_f.aa_fakelimright_slowwalk:set(tonumber(tbl[25]))
        aa_f.aa_lean_check_stand:set(to_boolean(tbl[26]))
        aa_f.aa_lean_mode_stand:set(tonumber(tbl[27]))
        aa_f.aa_lean_check_move:set(to_boolean(tbl[28]))
        aa_f.aa_lean_mode_move:set(tonumber(tbl[29]))
        aa_f.aa_lean_check_air:set(to_boolean(tbl[30]))
        aa_f.aa_lean_mode_air:set(tonumber(tbl[31]))
        aa_f.aa_lean_check_airduck:set(to_boolean(tbl[32]))
        aa_f.aa_lean_mode_airduck:set(tonumber(tbl[33]))
        aa_f.aa_lean_check_crouch:set(to_boolean(tbl[34]))
        aa_f.aa_lean_mode_crouch:set(tonumber(tbl[35]))
        aa_f.aa_lean_check_slowwalk:set(to_boolean(tbl[36]))
        aa_f.aa_lean_mode_slowwalk:set(tonumber(tbl[37]))

        aa_f.aa_leanlimleft_stand:set(tonumber(tbl[38]))
        aa_f.aa_leanlimleft_move:set(tonumber(tbl[39]))
        aa_f.aa_leanlimleft_air:set(tonumber(tbl[40]))
        aa_f.aa_leanlimleft_airduck:set(tonumber(tbl[41]))
        aa_f.aa_leanlimleft_crouch:set(tonumber(tbl[42]))
        aa_f.aa_leanlimleft_slowwalk:set(tonumber(tbl[43]))
        aa_f.aa_leanlimright_stand:set(tonumber(tbl[44]))
        aa_f.aa_leanlimright_move:set(tonumber(tbl[45]))
        aa_f.aa_leanlimright_air:set(tonumber(tbl[46]))
        aa_f.aa_leanlimright_airduck:set(tonumber(tbl[47]))
        aa_f.aa_leanlimright_crouch:set(tonumber(tbl[48]))
        aa_f.aa_leanlimright_slowwalk:set(tonumber(tbl[49]))

        aa_f.aa_jitter_stand:set(tonumber(tbl[50]))
        aa_f.aa_jitter_move:set(tonumber(tbl[51]))
        aa_f.aa_jitter_air:set(tonumber(tbl[52]))
        aa_f.aa_jitter_airduck:set(tonumber(tbl[53]))
        aa_f.aa_jitter_crouch:set(tonumber(tbl[54]))
        aa_f.aa_jitter_slowwalk:set(tonumber(tbl[55]))

        aa_f.aa_jittertype_stand:set(tonumber(tbl[56]))
        aa_f.aa_jittertype_move:set(tonumber(tbl[57]))
        aa_f.aa_jittertype_air:set(tonumber(tbl[58]))
        aa_f.aa_jittertype_airduck:set(tonumber(tbl[59]))
        aa_f.aa_jittertype_crouch:set(tonumber(tbl[60]))
        aa_f.aa_jittertype_slowwalk:set(tonumber(tbl[61]))

        aa_f.aa_offset_stand:set(tonumber(tbl[62]))
        aa_f.aa_offset_move:set(tonumber(tbl[63]))
        aa_f.aa_offset_air:set(tonumber(tbl[64]))
        aa_f.aa_offset_airduck:set(tonumber(tbl[65]))
        aa_f.aa_offset_crouch:set(tonumber(tbl[66]))
        aa_f.aa_offset_slowwalk:set(tonumber(tbl[67]))

        aa_f.aa_animbreaker_check:set(to_boolean(tbl[68]))

        aa_f.aa_animbreaker_main:set(1, to_boolean(tbl[69]))
        aa_f.aa_animbreaker_main:set(2, to_boolean(tbl[70]))
        aa_f.aa_animbreaker_main:set(3, to_boolean(tbl[71]))
        aa_f.aa_animbreaker_main:set(4, to_boolean(tbl[72]))
        aa_f.aa_animbreaker_main:set(5, to_boolean(tbl[73]))

        aa_f.aa_animbreaker_legs:set(tonumber(tbl[74]))

        aa_f.aa_animbreaker_other:set(1, to_boolean(tbl[75]))

        aa_f.aa_randomise_stand_left_check:set(to_boolean(tbl[76]))
        aa_f.aa_randomise_stand_left1:set(tonumber(tbl[77]))
        aa_f.aa_randomise_stand_left2:set(tonumber(tbl[78]))
        aa_f.aa_randomise_stand_right_check:set(to_boolean(tbl[79]))
        aa_f.aa_randomise_stand_right1:set(tonumber(tbl[80]))
        aa_f.aa_randomise_stand_right2:set(tonumber(tbl[81]))

        aa_f.aa_randomise_move_left_check:set(to_boolean(tbl[82]))
        aa_f.aa_randomise_move_left1:set(tonumber(tbl[83]))
        aa_f.aa_randomise_move_left2:set(tonumber(tbl[84]))
        aa_f.aa_randomise_move_right_check:set(to_boolean(tbl[85]))
        aa_f.aa_randomise_move_right1:set(tonumber(tbl[86]))
        aa_f.aa_randomise_move_right2:set(tonumber(tbl[87]))

        aa_f.aa_randomise_air_left_check:set(to_boolean(tbl[88]))
        aa_f.aa_randomise_air_left1:set(tonumber(tbl[89]))
        aa_f.aa_randomise_air_left2:set(tonumber(tbl[90]))
        aa_f.aa_randomise_air_right_check:set(to_boolean(tbl[91]))
        aa_f.aa_randomise_air_right1:set(tonumber(tbl[92]))
        aa_f.aa_randomise_air_right2:set(tonumber(tbl[93]))

        aa_f.aa_randomise_airduck_left_check:set(to_boolean(tbl[94]))
        aa_f.aa_randomise_airduck_left1:set(tonumber(tbl[95]))
        aa_f.aa_randomise_airduck_left2:set(tonumber(tbl[96]))
        aa_f.aa_randomise_airduck_right_check:set(to_boolean(tbl[97]))
        aa_f.aa_randomise_airduck_right1:set(tonumber(tbl[98]))
        aa_f.aa_randomise_airduck_right2:set(tonumber(tbl[99]))

        aa_f.aa_randomise_crouch_left_check:set(to_boolean(tbl[100]))
        aa_f.aa_randomise_crouch_left1:set(tonumber(tbl[101]))
        aa_f.aa_randomise_crouch_left2:set(tonumber(tbl[102]))
        aa_f.aa_randomise_crouch_right_check:set(to_boolean(tbl[103]))
        aa_f.aa_randomise_crouch_right1:set(tonumber(tbl[104]))
        aa_f.aa_randomise_crouch_right2:set(tonumber(tbl[105]))

        aa_f.aa_randomise_slowwalk_left_check:set(to_boolean(tbl[106]))
        aa_f.aa_randomise_slowwalk_left1:set(tonumber(tbl[107]))
        aa_f.aa_randomise_slowwalk_left2:set(tonumber(tbl[108]))
        aa_f.aa_randomise_slowwalk_right_check:set(to_boolean(tbl[109]))
        aa_f.aa_randomise_slowwalk_right1:set(tonumber(tbl[110]))
        aa_f.aa_randomise_slowwalk_right2:set(tonumber(tbl[111]))

        aa_f.aa_randomise_global_left_check:set(to_boolean(tbl[112]))
        aa_f.aa_randomise_global_left1:set(tonumber(tbl[113]))
        aa_f.aa_randomise_global_left2:set(tonumber(tbl[114]))
        aa_f.aa_randomise_global_right_check:set(to_boolean(tbl[115]))
        aa_f.aa_randomise_global_right1:set(tonumber(tbl[116]))
        aa_f.aa_randomise_global_right2:set(tonumber(tbl[117]))

        aa_f.aa_overg_stand:set(to_boolean(tbl[118]))
        aa_f.aa_overg_move:set(to_boolean(tbl[119]))
        aa_f.aa_overg_air:set(to_boolean(tbl[120]))
        aa_f.aa_overg_airduck:set(to_boolean(tbl[121]))
        aa_f.aa_overg_crouch:set(to_boolean(tbl[122]))
        aa_f.aa_overg_slowwalk:set(to_boolean(tbl[123]))

        aa_f.aa_yawlimleft_global:set(tonumber(tbl[124]))
        aa_f.aa_yawlimright_global:set(tonumber(tbl[125]))
        aa_f.aa_fakelimleft_global:set(tonumber(tbl[126]))
        aa_f.aa_fakelimright_global:set(tonumber(tbl[127]))
        aa_f.aa_lean_check_global:set(to_boolean(tbl[128]))
        aa_f.aa_lean_mode_global:set(tonumber(tbl[129]))
        aa_f.aa_leanlimleft_global:set(tonumber(tbl[130]))
        aa_f.aa_leanlimright_global:set(tonumber(tbl[131]))
        aa_f.aa_jitter_global:set(tonumber(tbl[132]))
        aa_f.aa_jittertype_global:set(tonumber(tbl[133]))
        aa_f.aa_offset_global:set(tonumber(tbl[134]))

        aa_f.lc_check:set(to_boolean(tbl[135]))
        aa_f.lc_weapons:set(1, to_boolean(tbl[136]))
        aa_f.lc_weapons:set(2, to_boolean(tbl[137]))
        aa_f.lc_weapons:set(3, to_boolean(tbl[138]))
        aa_f.lc_weapons:set(4, to_boolean(tbl[139]))
        aa_f.lc_weapons:set(5, to_boolean(tbl[140]))
        aa_f.lc_weapons:set(6, to_boolean(tbl[141]))
        aa_f.lc_weapons:set(7, to_boolean(tbl[142]))
        aa_f.lc_weapons:set(8, to_boolean(tbl[143]))
        aa_f.lc_state_check:set(to_boolean(tbl[144]))
        aa_f.onshotfl_check:set(to_boolean(tbl[145]))
        aa_f.anti_zeus_check:set(to_boolean(tbl[146]))
        aa_f.anti_zeus_max_dist:set(tonumber(tbl[147]))
        aa_f.warmup_check:set(to_boolean(tbl[148]))

        client.log_screen("[Solutions] config loaded")
        engine.execute_cmd("play aa_config.wav")
    end
    local status, message = pcall(protected)
    if not status then
        client.log_screen("[Solutions] failed to load config or not all items have changed")
        engine.execute_cmd("play aa_config_error.wav")
        return
    end
end

configs.export = function()
	local str = {}
	local str = tostring(aa_f.aa_check:get()) .. "|"
    .. tostring(aa_f.aa_yawlimleft_stand:get()) .. "|"
    .. tostring(aa_f.aa_yawlimleft_move:get()) .. "|"
    .. tostring(aa_f.aa_yawlimleft_air:get()) .. "|"
    .. tostring(aa_f.aa_yawlimleft_airduck:get()) .. "|"
    .. tostring(aa_f.aa_yawlimleft_crouch:get()) .. "|"
    .. tostring(aa_f.aa_yawlimleft_slowwalk:get()) .. "|"

    .. tostring(aa_f.aa_yawlimright_stand:get()) .. "|"
    .. tostring(aa_f.aa_yawlimright_move:get()) .. "|"
    .. tostring(aa_f.aa_yawlimright_air:get()) .. "|"
    .. tostring(aa_f.aa_yawlimright_airduck:get()) .. "|"
    .. tostring(aa_f.aa_yawlimright_crouch:get()) .. "|"
    .. tostring(aa_f.aa_yawlimright_slowwalk:get()) .. "|"

    .. tostring(aa_f.aa_fakelimleft_stand:get()) .. "|"
    .. tostring(aa_f.aa_fakelimleft_move:get()) .. "|"
    .. tostring(aa_f.aa_fakelimleft_air:get()) .. "|"
    .. tostring(aa_f.aa_fakelimleft_airduck:get()) .. "|"
    .. tostring(aa_f.aa_fakelimleft_crouch:get()) .. "|"
    .. tostring(aa_f.aa_fakelimleft_slowwalk:get()) .. "|"

    .. tostring(aa_f.aa_fakelimright_stand:get()) .. "|"
    .. tostring(aa_f.aa_fakelimright_move:get()) .. "|"
    .. tostring(aa_f.aa_fakelimright_air:get()) .. "|"
    .. tostring(aa_f.aa_fakelimright_airduck:get()) .. "|"
    .. tostring(aa_f.aa_fakelimright_crouch:get()) .. "|"
    .. tostring(aa_f.aa_fakelimright_slowwalk:get()) .. "|"

    .. tostring(aa_f.aa_lean_check_stand:get()) .. "|"
    .. tostring(aa_f.aa_lean_mode_stand:get()) .. "|"
    .. tostring(aa_f.aa_lean_check_move:get()) .. "|"
    .. tostring(aa_f.aa_lean_mode_move:get()) .. "|"
    .. tostring(aa_f.aa_lean_check_air:get()) .. "|"
    .. tostring(aa_f.aa_lean_mode_air:get()) .. "|"
    .. tostring(aa_f.aa_lean_check_airduck:get()) .. "|"
    .. tostring(aa_f.aa_lean_mode_airduck:get()) .. "|"
    .. tostring(aa_f.aa_lean_check_crouch:get()) .. "|"
    .. tostring(aa_f.aa_lean_mode_crouch:get()) .. "|"
    .. tostring(aa_f.aa_lean_check_slowwalk:get()) .. "|"
    .. tostring(aa_f.aa_lean_mode_slowwalk:get()) .. "|"

    .. tostring(aa_f.aa_leanlimleft_stand:get()) .. "|"
    .. tostring(aa_f.aa_leanlimleft_move:get()) .. "|"
    .. tostring(aa_f.aa_leanlimleft_air:get()) .. "|"
    .. tostring(aa_f.aa_leanlimleft_airduck:get()) .. "|"
    .. tostring(aa_f.aa_leanlimleft_crouch:get()) .. "|"
    .. tostring(aa_f.aa_leanlimleft_slowwalk:get()) .. "|"

    .. tostring(aa_f.aa_leanlimright_stand:get()) .. "|"
    .. tostring(aa_f.aa_leanlimright_move:get()) .. "|"
    .. tostring(aa_f.aa_leanlimright_air:get()) .. "|"
    .. tostring(aa_f.aa_leanlimright_airduck:get()) .. "|"
    .. tostring(aa_f.aa_leanlimright_crouch:get()) .. "|"
    .. tostring(aa_f.aa_leanlimright_slowwalk:get()) .. "|"

    .. tostring(aa_f.aa_jitter_stand:get()) .. "|"
    .. tostring(aa_f.aa_jitter_move:get()) .. "|"
    .. tostring(aa_f.aa_jitter_air:get()) .. "|"
    .. tostring(aa_f.aa_jitter_airduck:get()) .. "|"
    .. tostring(aa_f.aa_jitter_crouch:get()) .. "|"
    .. tostring(aa_f.aa_jitter_slowwalk:get()) .. "|"

    .. tostring(aa_f.aa_jittertype_stand:get()) .. "|"
    .. tostring(aa_f.aa_jittertype_move:get()) .. "|"
    .. tostring(aa_f.aa_jittertype_air:get()) .. "|"
    .. tostring(aa_f.aa_jittertype_airduck:get()) .. "|"
    .. tostring(aa_f.aa_jittertype_crouch:get()) .. "|"
    .. tostring(aa_f.aa_jittertype_slowwalk:get()) .. "|"

    .. tostring(aa_f.aa_offset_stand:get()) .. "|"
    .. tostring(aa_f.aa_offset_move:get()) .. "|"
    .. tostring(aa_f.aa_offset_air:get()) .. "|"
    .. tostring(aa_f.aa_offset_airduck:get()) .. "|"
    .. tostring(aa_f.aa_offset_crouch:get()) .. "|"
    .. tostring(aa_f.aa_offset_slowwalk:get()) .. "|"

    .. tostring(aa_f.aa_animbreaker_check:get()) .. "|"

    .. tostring(aa_f.aa_animbreaker_main:get(1)) .. "|"
    .. tostring(aa_f.aa_animbreaker_main:get(2)) .. "|"
    .. tostring(aa_f.aa_animbreaker_main:get(3)) .. "|"
    .. tostring(aa_f.aa_animbreaker_main:get(4)) .. "|"
    .. tostring(aa_f.aa_animbreaker_main:get(5)) .. "|"

    .. tostring(aa_f.aa_animbreaker_legs:get()) .. "|"

    .. tostring(aa_f.aa_animbreaker_other:get(1)) .. "|"

    .. tostring(aa_f.aa_randomise_stand_left_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_stand_left1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_stand_left2:get()) .. "|"
    .. tostring(aa_f.aa_randomise_stand_right_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_stand_right1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_stand_right2:get()) .. "|"

    .. tostring(aa_f.aa_randomise_move_left_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_move_left1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_move_left2:get()) .. "|"
    .. tostring(aa_f.aa_randomise_move_right_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_move_right1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_move_right2:get()) .. "|"

    .. tostring(aa_f.aa_randomise_air_left_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_air_left1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_air_left2:get()) .. "|"
    .. tostring(aa_f.aa_randomise_air_right_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_air_right1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_air_right2:get()) .. "|"

    .. tostring(aa_f.aa_randomise_airduck_left_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_airduck_left1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_airduck_left2:get()) .. "|"
    .. tostring(aa_f.aa_randomise_airduck_right_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_airduck_right1:get()) .. "|"

    local str2 = {}
	local str2 = tostring(aa_f.aa_randomise_airduck_right2:get()) .. "|"
    .. tostring(aa_f.aa_randomise_crouch_left_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_crouch_left1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_crouch_left2:get()) .. "|"
    .. tostring(aa_f.aa_randomise_crouch_right_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_crouch_right1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_crouch_right2:get()) .. "|"

    .. tostring(aa_f.aa_randomise_slowwalk_left_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_slowwalk_left1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_slowwalk_left2:get()) .. "|"
    .. tostring(aa_f.aa_randomise_slowwalk_right_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_slowwalk_right1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_slowwalk_right2:get()) .. "|"

    .. tostring(aa_f.aa_randomise_global_left_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_global_left1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_global_left2:get()) .. "|"
    .. tostring(aa_f.aa_randomise_global_right_check:get()) .. "|"
    .. tostring(aa_f.aa_randomise_global_right1:get()) .. "|"
    .. tostring(aa_f.aa_randomise_global_right2:get()) .. "|"

    .. tostring(aa_f.aa_overg_stand:get()) .. "|"
    .. tostring(aa_f.aa_overg_move:get()) .. "|"
    .. tostring(aa_f.aa_overg_air:get()) .. "|"
    .. tostring(aa_f.aa_overg_airduck:get()) .. "|"
    .. tostring(aa_f.aa_overg_crouch:get()) .. "|"
    .. tostring(aa_f.aa_overg_slowwalk:get()) .. "|"

    .. tostring(aa_f.aa_yawlimleft_global:get()) .. "|"
    .. tostring(aa_f.aa_yawlimright_global:get()) .. "|"
    .. tostring(aa_f.aa_fakelimleft_global:get()) .. "|"
    .. tostring(aa_f.aa_fakelimright_global:get()) .. "|"
    .. tostring(aa_f.aa_lean_check_global:get()) .. "|"
    .. tostring(aa_f.aa_lean_mode_global:get()) .. "|"
    .. tostring(aa_f.aa_leanlimleft_global:get()) .. "|"
    .. tostring(aa_f.aa_leanlimright_global:get()) .. "|"
    .. tostring(aa_f.aa_jitter_global:get()) .. "|"
    .. tostring(aa_f.aa_jittertype_global:get()) .. "|"
    .. tostring(aa_f.aa_offset_global:get()) .. "|"

    .. tostring(aa_f.lc_check:get()) .. "|"
    .. tostring(aa_f.lc_weapons:get(1)) .. "|"
    .. tostring(aa_f.lc_weapons:get(2)) .. "|"
    .. tostring(aa_f.lc_weapons:get(3)) .. "|"
    .. tostring(aa_f.lc_weapons:get(4)) .. "|"
    .. tostring(aa_f.lc_weapons:get(5)) .. "|"
    .. tostring(aa_f.lc_weapons:get(6)) .. "|"
    .. tostring(aa_f.lc_weapons:get(7)) .. "|"
    .. tostring(aa_f.lc_weapons:get(8)) .. "|"
    .. tostring(aa_f.lc_state_check:get()) .. "|"
    .. tostring(aa_f.onshotfl_check:get()) .. "|"

    .. tostring(aa_f.anti_zeus_check:get()) .. "|"
    .. tostring(aa_f.anti_zeus_max_dist:get()) .. "|"

    .. tostring(aa_f.warmup_check:get()) .. "|"

    clipboard_export(str..str2)
	client.log_screen("[Solutions] config exported")
    engine.execute_cmd("play aa_config.wav")
end

-- visiblity shit
local function drawshit()
    -- maintab
    maintab.tabselection:set_visible(allowload == true)
    maintab.textaa:set_visible(allowload == true)
    maintab.cfg_import:set_visible(allowload == true)
    maintab.cfg_export:set_visible(allowload == true)
    maintab.cfg_default:set_visible(allowload == true)
    maintab.space123:set_visible(allowload == true)
    maintab.discordlink:set_visible(allowload == true)
    -- rage
    rage_f.customdt_check:set_visible(maintab.tabselection:get() == 1 and allowload == true)
    rage_f.customdt_speed:set_visible(maintab.tabselection:get() == 1 and rage_f.customdt_check:get() and allowload == true)
    rage_f.customdt_corrections:set_visible(maintab.tabselection:get() == 1 and rage_f.customdt_check:get() and allowload == true)
    rage_f.customdt_waning:set_visible(maintab.tabselection:get() == 1 and rage_f.customdt_check:get() and rage_f.customdt_speed:get() >16 and allowload == true)
    rage_f.recharge_check:set_visible(maintab.tabselection:get() == 1 and allowload == true)
    rage_f.disableinterp_check:set_visible(maintab.tabselection:get() == 1 and allowload == true)
    rage_f.prediction_check:set_visible(maintab.tabselection:get() == 1 and allowload == true)
    rage_f.prediction_warning:set_visible(maintab.tabselection:get() == 1 and rage_f.prediction_check:get() and not refs.prediction:get() and allowload == true)
    rage_f.early_check:set_visible(maintab.tabselection:get() == 1 and allowload == true)
    rage_f.early_weapons:set_visible(maintab.tabselection:get() == 1 and rage_f.early_check:get() and allowload == true)
    -- aa
    aa_f.aa_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_switchside:set_visible(maintab.tabselection:get() == 2 and aa_f.aa_check:get() and allowload == true)
    aa_f.aa_animbreaker_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_animbreaker_main:set_visible(maintab.tabselection:get() == 2 and aa_f.aa_animbreaker_check:get() and allowload == true)
    aa_f.aa_animbreaker_legs:set_visible(maintab.tabselection:get() == 2 and aa_f.aa_animbreaker_check:get() and aa_f.aa_animbreaker_main:get(2) and allowload == true)
    aa_f.aa_animbreaker_other:set_visible(maintab.tabselection:get() == 2 and aa_f.aa_animbreaker_check:get() and allowload == true)
    aa_f.onshotfl_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    aa_f.lc_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    aa_f.lc_weapons:set_visible(maintab.tabselection:get() == 2 and aa_f.lc_check:get() and allowload == true)
    aa_f.lc_state_check:set_visible(maintab.tabselection:get() == 2 and aa_f.lc_check:get() and allowload == true)
    aa_f.anti_zeus_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    aa_f.anti_zeus_max_dist:set_visible(maintab.tabselection:get() == 2 and aa_f.anti_zeus_check:get() and allowload == true)
    aa_f.warmup_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    -- visual
    visual_f.color_theme_text:set_visible(maintab.tabselection:get() == 3 and visual_f.color_theme_mode:get() == 1 and allowload == true)
    visual_f.color_theme_text_2:set_visible(maintab.tabselection:get() == 3 and visual_f.color_theme_mode:get() == 1 and allowload == true)
    visual_f.color_theme_alpha:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.fonttext:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.fontlink:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.lobby_waning:set_visible(maintab.tabselection:get() == 3 and not engine.is_connected() and allowload == true)
    visual_f.indicators_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.indicators_customisation:set_visible(maintab.tabselection:get() == 3 and visual_f.indicators_check:get() and allowload == true)
    visual_f.indicators_customisation_bg:set_visible(maintab.tabselection:get() == 3 and visual_f.indicators_check:get() and visual_f.indicators_customisation:get(2) and allowload == true)
    visual_f.indicators_customisation_rect:set_visible(maintab.tabselection:get() == 3 and visual_f.indicators_check:get() and visual_f.indicators_customisation:get(2) and allowload == true)
    visual_f.indicators_state_color:set_visible(maintab.tabselection:get() == 3 and visual_f.indicators_check:get() and visual_f.indicators_customisation:get(3) and allowload == true)
    visual_f.watermark_custom_watername:set_visible(maintab.tabselection:get() == 3 and visual_f.windows_combo:get(1) and allowload == true)
    visual_f.watermark_custom_custom:set_visible(maintab.tabselection:get() == 3 and visual_f.windows_combo:get(1) and visual_f.watermark_custom_watername:get() == 4 and allowload == true)
    visual_f.watermark_custom_showuid:set_visible(maintab.tabselection:get() == 3 and visual_f.windows_combo:get(1) and allowload == true)
    visual_f.lethal_indicator_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.slowdownind_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.infobox_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.color_theme_mode:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.penisdot_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.floydmode_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.windows_combo:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.windows_mode:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.disable_primomark:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.zeus_warning_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    -- misc
    misc_f.trashtalk_check:set_visible(maintab.tabselection:get() == 4 and allowload == true)
    misc_f.trashtalk_mode:set_visible(maintab.tabselection:get() == 4 and misc_f.trashtalk_check:get() and allowload == true)
    misc_f.tt_hs_check:set_visible(maintab.tabselection:get() == 4 and misc_f.trashtalk_check:get() and misc_f.trashtalk_mode:get() == 2 and allowload == true)
    misc_f.clantag_check:set_visible(maintab.tabselection:get() == 4 and allowload == true)
    misc_f.clantag_mode:set_visible(maintab.tabselection:get() == 4 and misc_f.clantag_check:get() and allowload == true)
    misc_f.gh_fix_check:set_visible(maintab.tabselection:get() == 4 and allowload == true)
    misc_f.autobuy_check:set_visible(maintab.tabselection:get() == 4 and allowload == true)
    misc_f.localserver_check:set_visible(maintab.tabselection:get() == 4 and allowload == true)
    misc_f.localserver_configure:set_visible(maintab.tabselection:get() == 4 and misc_f.localserver_check:get() and allowload == true)
    misc_f.localserver_bottext:set_visible(maintab.tabselection:get() == 4 and misc_f.localserver_check:get()and allowload == true)
    misc_f.localserver_botaddct:set_visible(maintab.tabselection:get() == 4 and misc_f.localserver_check:get() and allowload == true)
    misc_f.localserver_botaddt:set_visible(maintab.tabselection:get() == 4 and misc_f.localserver_check:get() and allowload == true)
    misc_f.localserver_botkick:set_visible(maintab.tabselection:get() == 4 and misc_f.localserver_check:get() and allowload == true)
    -- info
    infotab.space132:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforlogo:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.space12:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforbild:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforver:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforuser:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforcord:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforlog:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    ----- aa shit
    aa_f.conditionselection:set_visible(aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    -- override global
    aa_f.aa_overg_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_overg_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_overg_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_overg_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_overg_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_overg_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --jitter type
    aa_f.aa_jittertype_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)

    aa_f.aa_randomise_global_left_check:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_global_left1:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_global_left_check:get() and allowload == true)
    aa_f.aa_randomise_global_left2:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_global_left_check:get() and allowload == true)
    aa_f.aa_randomise_global_right_check:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_global_right1:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_global_right_check:get() and allowload == true)
    aa_f.aa_randomise_global_right2:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_global_right_check:get() and allowload == true)
    
    aa_f.aa_randomise_stand_left_check:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_stand_left1:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_stand_left_check:get() and allowload == true)
    aa_f.aa_randomise_stand_left2:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_stand_left_check:get() and allowload == true)
    aa_f.aa_randomise_stand_right_check:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_stand_right1:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_stand_right_check:get() and allowload == true)
    aa_f.aa_randomise_stand_right2:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_stand_right_check:get() and allowload == true)

    aa_f.aa_randomise_move_left_check:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_move_left1:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_move_left_check:get() and allowload == true)
    aa_f.aa_randomise_move_left2:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_move_left_check:get() and allowload == true)
    aa_f.aa_randomise_move_right_check:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_move_right1:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_move_right_check:get() and allowload == true)
    aa_f.aa_randomise_move_right2:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_move_right_check:get() and allowload == true)

    aa_f.aa_randomise_air_left_check:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_air_left1:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_air_left_check:get() and allowload == true)
    aa_f.aa_randomise_air_left2:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_air_left_check:get() and allowload == true)
    aa_f.aa_randomise_air_right_check:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_air_right1:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_air_right_check:get() and allowload == true)
    aa_f.aa_randomise_air_right2:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_air_right_check:get() and allowload == true)

    aa_f.aa_randomise_airduck_left_check:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_airduck_left1:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_airduck_left_check:get() and allowload == true)
    aa_f.aa_randomise_airduck_left2:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_airduck_left_check:get() and allowload == true)
    aa_f.aa_randomise_airduck_right_check:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_airduck_right1:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_airduck_right_check:get() and allowload == true)
    aa_f.aa_randomise_airduck_right2:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_airduck_right_check:get() and allowload == true)

    aa_f.aa_randomise_crouch_left_check:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_crouch_left1:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_crouch_left_check:get() and allowload == true)
    aa_f.aa_randomise_crouch_left2:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_crouch_left_check:get() and allowload == true)
    aa_f.aa_randomise_crouch_right_check:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_crouch_right1:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_crouch_right_check:get() and allowload == true)
    aa_f.aa_randomise_crouch_right2:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_crouch_right_check:get() and allowload == true)

    aa_f.aa_randomise_slowwalk_left_check:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_slowwalk_left1:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_slowwalk_left_check:get() and allowload == true)
    aa_f.aa_randomise_slowwalk_left2:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_slowwalk_left_check:get() and allowload == true)
    aa_f.aa_randomise_slowwalk_right_check:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_slowwalk_right1:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_slowwalk_right_check:get() and allowload == true)
    aa_f.aa_randomise_slowwalk_right2:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_slowwalk_right_check:get() and allowload == true)
    --
    --yaw
    aa_f.aa_yawlimleft_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --yaw jitter
    aa_f.aa_jitter_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --yaw offset
    aa_f.aa_offset_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --fake
    aa_f.aa_fakelimleft_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --lean
    aa_f.aa_leanlimleft_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_global:get() and allowload == true)
    aa_f.aa_leanlimright_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_global:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_stand:get() and allowload == true)
    aa_f.aa_leanlimright_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_stand:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_move:get() and allowload == true)
    aa_f.aa_leanlimright_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_move:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_air:get() and allowload == true)
    aa_f.aa_leanlimright_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_air:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_airduck:get() and allowload == true)
    aa_f.aa_leanlimright_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_airduck:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_crouch:get() and allowload == true)
    aa_f.aa_leanlimright_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_crouch:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_slowwalk:get() and allowload == true)
    aa_f.aa_leanlimright_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_slowwalk:get() and allowload == true)
    --
    aa_f.aa_lean_check_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_lean_mode_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_global:get() and allowload == true)
    aa_f.aa_lean_mode_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_stand:get() and allowload == true)
    aa_f.aa_lean_mode_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_move:get() and allowload == true)
    aa_f.aa_lean_mode_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_air:get() and allowload == true)
    aa_f.aa_lean_mode_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_airduck:get() and allowload == true)
    aa_f.aa_lean_mode_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_crouch:get() and allowload == true)
    aa_f.aa_lean_mode_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_slowwalk:get() and allowload == true)

    unregtab.text1:set_visible(allowload == false)
    unregtab.text2:set_visible(allowload == false)
    unregtab.text3:set_visible(allowload == false)
    unregtab.text4:set_visible(allowload == false)
    unregtab.contactscopy:set_visible(allowload == false)
end

------------------------------------------------------- main code -------------------------------------------------------
------------------------------------------------------- antiaim feauteres
-- antiaim builder
local function mainaa()
    if not engine.is_connected() then return end
    if not entity_list.get_local_player():is_alive() then return end
    if aa_f.warmup_check:get() and game_rules.get_prop("m_bWarmupPeriod") == 1 then return end

    if aa_f.aa_check:get() then
        local state = get_state(get_velocity())

        refs.overridestandmove:set(false)
        refs.overridestandslide:set(false)
        refs.jittermode:set(2)
        refs.leanmode:set(1)

        local randgloballeft = 0
        local randglobalright = 0

        local randstandleft = 0
        local randstandright = 0

        local randmoveleft = 0
        local randmoveright = 0

        local randairleft = 0
        local randairright = 0

        local randairduckleft = 0
        local randairduckright = 0

        local randcrouchleft = 0
        local randcrouchright = 0

        local randslowwalkleft = 0
        local randslowwalkright = 0
        -- randomise global
        if aa_f.aa_randomise_global_left_check:get(true) then
            randgloballeft = math.random(aa_f.aa_randomise_global_left1:get(), aa_f.aa_randomise_global_left2:get())
        else
            randgloballeft = 0
        end
        if aa_f.aa_randomise_global_right_check:get(true) then
            randglobalright = math.random(aa_f.aa_randomise_global_right1:get(), aa_f.aa_randomise_global_right2:get())
        else
            randglobalright = 0
        end
        -- randomise stand
        if aa_f.aa_randomise_stand_left_check:get(true) then
            randstandleft = math.random(aa_f.aa_randomise_stand_left1:get(), aa_f.aa_randomise_stand_left2:get())
        else
            randstandleft = 0
        end
        if aa_f.aa_randomise_stand_right_check:get(true) then
            randstandright = math.random(aa_f.aa_randomise_stand_right1:get(), aa_f.aa_randomise_stand_right2:get())
        else
            randstandright = 0
        end
        -- randomise move
        if aa_f.aa_randomise_move_left_check:get(true) then
            randmoveleft = math.random(aa_f.aa_randomise_move_left1:get(), aa_f.aa_randomise_move_left2:get())
        else
            randmoveleft = 0
        end
        if aa_f.aa_randomise_move_right_check:get(true) then
            randmoveright = math.random(aa_f.aa_randomise_move_right1:get(), aa_f.aa_randomise_move_right2:get())
        else
            randmoveright = 0
        end
        -- randomise air
        if aa_f.aa_randomise_air_left_check:get(true) then
            randairleft = math.random(aa_f.aa_randomise_air_left1:get(), aa_f.aa_randomise_air_left2:get())
        else
            randairleft = 0
        end
        if aa_f.aa_randomise_air_right_check:get(true) then
            randairright = math.random(aa_f.aa_randomise_air_right1:get(), aa_f.aa_randomise_air_right2:get())
        else
            randairright = 0
        end
        -- randomise airduck
        if aa_f.aa_randomise_airduck_left_check:get(true) then
            randairduckleft = math.random(aa_f.aa_randomise_airduck_left1:get(), aa_f.aa_randomise_airduck_left2:get())
        else
            randairduckleft = 0
        end
        if aa_f.aa_randomise_airduck_right_check:get(true) then
            randairduckright = math.random(aa_f.aa_randomise_airduck_right1:get(), aa_f.aa_randomise_airduck_right2:get())
        else
            randairduckright = 0
        end
        -- randomise crouch
        if aa_f.aa_randomise_crouch_left_check:get(true) then
            randcrouchleft = math.random(aa_f.aa_randomise_crouch_left1:get(), aa_f.aa_randomise_crouch_left2:get())
        else
            randcrouchleft = 0
        end
        if aa_f.aa_randomise_crouch_right_check:get(true) then
            randcrouchright = math.random(aa_f.aa_randomise_crouch_right1:get(), aa_f.aa_randomise_crouch_right2:get())
        else
            randcrouchright = 0
        end
        -- randomise slowwalk
        if aa_f.aa_randomise_slowwalk_left_check:get(true) then
            randslowwalkleft = math.random(aa_f.aa_randomise_slowwalk_left1:get(), aa_f.aa_randomise_slowwalk_left2:get())
        else
            randslowwalkleft = 0
        end
        if aa_f.aa_randomise_slowwalk_right_check:get(true) then
            randslowwalkright = math.random(aa_f.aa_randomise_slowwalk_right1:get(), aa_f.aa_randomise_slowwalk_right2:get())
        else
            randslowwalkright = 0
        end

        -- global
        refs.yawadd:set(antiaim.get_desync_side() == 2 and -aa_f.aa_yawlimleft_global:get() + randgloballeft + aa_f.aa_offset_global:get() or aa_f.aa_yawlimright_global:get() + randglobalright + aa_f.aa_offset_global:get())
        refs.fakemode:set(4)
        if aa_f.aa_jittertype_global:get() == 1 then refs.jittertype:set(2) else refs.jittertype:set(1) end
        refs.jitteradd:set(aa_f.aa_jitter_global:get())
        if aa_f.aa_lean_mode_global:get() == 2 and aa_f.aa_lean_check_global:get() then
            refs.leanval:set(antiaim.get_desync_side() == 2 and -aa_f.aa_leanlimleft_global:get() or aa_f.aa_leanlimright_global:get())
            refs.leanmode:set(2)
        end
        --stand
        if aa_f.aa_overg_stand:get() and state == 1 then
            refs.yawadd:set(antiaim.get_desync_side() == 2 and -aa_f.aa_yawlimleft_stand:get() + randstandleft + aa_f.aa_offset_stand:get() or aa_f.aa_yawlimright_stand:get() + randstandright + aa_f.aa_offset_stand:get())
            refs.fakemode:set(4)
            if aa_f.aa_jittertype_stand:get() == 1 then refs.jittertype:set(2) else refs.jittertype:set(1) end
            refs.jitteradd:set(aa_f.aa_jitter_stand:get())
            if aa_f.aa_lean_mode_stand:get() == 2 and aa_f.aa_lean_check_stand:get() then
                refs.leanval:set(antiaim.get_desync_side() == 2 and -aa_f.aa_leanlimleft_stand:get() or aa_f.aa_leanlimright_stand:get())
                refs.leanmode:set(2)
            end
        end
        --move
        if aa_f.aa_overg_move:get() and state == 2 then
            refs.yawadd:set(antiaim.get_desync_side() == 2 and -aa_f.aa_yawlimleft_move:get() + randmoveleft + aa_f.aa_offset_move:get() or aa_f.aa_yawlimright_move:get() + randmoveright + aa_f.aa_offset_move:get())
            refs.fakemode:set(4)
            if aa_f.aa_jittertype_move:get() == 1 then refs.jittertype:set(2) else refs.jittertype:set(1) end
            refs.jitteradd:set(aa_f.aa_jitter_move:get())
            if aa_f.aa_lean_mode_move:get() == 2 and aa_f.aa_lean_check_move:get() then
                refs.leanval:set(antiaim.get_desync_side() == 2 and -aa_f.aa_leanlimleft_move:get() or aa_f.aa_leanlimright_move:get())
                refs.leanmode:set(2)
            end
        end
        --air
        if aa_f.aa_overg_air:get() and state == 5 then
            refs.yawadd:set(antiaim.get_desync_side() == 2 and -aa_f.aa_yawlimleft_air:get() + randairleft + aa_f.aa_offset_air:get() or aa_f.aa_yawlimright_air:get() + randairright + aa_f.aa_offset_air:get())
            refs.fakemode:set(4)
            if aa_f.aa_jittertype_air:get() == 1 then refs.jittertype:set(2) else refs.jittertype:set(1) end
            refs.jitteradd:set(aa_f.aa_jitter_air:get())
            if aa_f.aa_lean_mode_air:get() == 2 and aa_f.aa_lean_check_air:get() then
                refs.leanval:set(antiaim.get_desync_side() == 2 and -aa_f.aa_leanlimleft_air:get() or aa_f.aa_leanlimright_air:get())
                refs.leanmode:set(2)
            end
        end
        --crouch
        if aa_f.aa_overg_crouch:get() and state == 4 then
            refs.yawadd:set(antiaim.get_desync_side() == 2 and -aa_f.aa_yawlimleft_crouch:get() + randcrouchleft + aa_f.aa_offset_crouch:get() or aa_f.aa_yawlimright_crouch:get() + randcrouchright + aa_f.aa_offset_crouch:get())
            refs.fakemode:set(4)
            if aa_f.aa_jittertype_crouch:get() == 1 then refs.jittertype:set(2) else refs.jittertype:set(1) end
            refs.jitteradd:set(aa_f.aa_jitter_crouch:get())
            if aa_f.aa_lean_check_crouch:get() == 2 and aa_f.aa_lean_mode_crouch:get() then
                refs.leanval:set(antiaim.get_desync_side() == 2 and -aa_f.aa_leanlimleft_crouch:get() or aa_f.aa_leanlimright_crouch:get())
                refs.leanmode:set(2)
            end
        end
        --air-duck
        if aa_f.aa_overg_airduck:get() and state == 6 then
            refs.yawadd:set(antiaim.get_desync_side() == 2 and -aa_f.aa_yawlimleft_airduck:get() + randairduckleft + aa_f.aa_offset_airduck:get() or aa_f.aa_yawlimright_airduck:get() + randairduckright + aa_f.aa_offset_airduck:get())
            refs.fakemode:set(4)
            if aa_f.aa_jittertype_airduck:get() == 1 then refs.jittertype:set(2) else refs.jittertype:set(1) end
            refs.jitteradd:set(aa_f.aa_jitter_airduck:get())
            if aa_f.aa_lean_mode_airduck:get() == 2 and aa_f.aa_lean_check_airduck:get() then
                refs.leanval:set(antiaim.get_desync_side() == 2 and -aa_f.aa_leanlimleft_airduck:get() or aa_f.aa_leanlimright_airduck:get())
                refs.leanmode:set(2)
            end
        end
        --slowwalk
        if aa_f.aa_overg_slowwalk:get() and state == 3 then
            refs.yawadd:set(antiaim.get_desync_side() == 2 and -aa_f.aa_yawlimleft_slowwalk:get() + randslowwalkleft + aa_f.aa_offset_slowwalk:get() or aa_f.aa_yawlimright_slowwalk:get() + randslowwalkright + aa_f.aa_offset_slowwalk:get())
            refs.fakemode:set(4)
            if aa_f.aa_jittertype_slowwalk:get() == 1 then refs.jittertype:set(2) else refs.jittertype:set(1) end
            refs.jitteradd:set(aa_f.aa_jitter_slowwalk:get())
            if aa_f.aa_lean_mode_slowwalk:get() == 2 and aa_f.aa_lean_check_slowwalk:get() then
                refs.leanval:set(antiaim.get_desync_side() == 2 and -aa_f.aa_leanlimleft_slowwalk:get() or aa_f.aa_leanlimright_slowwalk:get())
                refs.leanmode:set(2)
            end
        end
        
        --static lean
        --stand
        if not binds.aa_lean_switchside_bind:get() then
            --global
            if aa_f.aa_lean_mode_global:get() == 1 and aa_f.aa_lean_check_global:get() then
                refs.leanval:set(-aa_f.aa_leanlimleft_global:get())
                refs.leanmode:set(2)
            end
            --stand
            if aa_f.aa_lean_mode_stand:get() == 1 and aa_f.aa_lean_check_stand:get() and aa_f.aa_overg_stand:get() then
                if state == 1 then
                    refs.leanval:set(-aa_f.aa_leanlimleft_stand:get())
                    refs.leanmode:set(2)
                end
            end
            --move
            if aa_f.aa_lean_mode_move:get() == 1 and aa_f.aa_lean_check_move:get() and aa_f.aa_overg_move:get() then
                if state == 2 then
                    refs.leanval:set(-aa_f.aa_leanlimleft_move:get())
                    refs.leanmode:set(2)
                end
            end
            --air
            if aa_f.aa_lean_mode_air:get() == 1 and aa_f.aa_lean_check_air:get() and aa_f.aa_overg_air:get() then
                if state == 5 then
                    refs.leanval:set(-aa_f.aa_leanlimleft_air:get())
                    refs.leanmode:set(2)                    
                end
            end
            --crouch
            if aa_f.aa_lean_mode_crouch:get() == 1 and aa_f.aa_lean_check_crouch:get() and aa_f.aa_overg_crouch:get() then
                if state == 4 then
                    refs.leanval:set(-aa_f.aa_leanlimleft_crouch:get())
                    refs.leanmode:set(2)                    
                end
            end
            --air-duck
            if aa_f.aa_lean_mode_airduck:get() == 1 and aa_f.aa_lean_check_airduck:get() and aa_f.aa_overg_airduck:get() then
                if state == 6 then
                    refs.leanval:set(-aa_f.aa_leanlimleft_airduck:get())
                    refs.leanmode:set(2)                    
                end
            end
            --slowwalk
            if aa_f.aa_lean_mode_slowwalk:get() == 1 and aa_f.aa_lean_check_slowwalk:get() and aa_f.aa_overg_slowwalk:get() then
                if state == 3 then
                    refs.leanval:set(-aa_f.aa_leanlimleft_slowwalk:get())
                    refs.leanmode:set(2)                    
                end
            end
        else
            --global
            if aa_f.aa_lean_mode_global:get() == 1 and aa_f.aa_lean_check_global:get() then
                refs.leanval:set(aa_f.aa_leanlimright_global:get())
                refs.leanmode:set(2)
            end
            --stand
            if aa_f.aa_lean_mode_stand:get() == 1 and aa_f.aa_lean_check_stand:get() and aa_f.aa_overg_stand:get() then
                if state == 1 then
                    refs.leanval:set(aa_f.aa_leanlimright_stand:get())
                    refs.leanmode:set(2)
                end
            end
            --move
            if aa_f.aa_lean_mode_move:get() == 1 and aa_f.aa_lean_check_move:get() and aa_f.aa_overg_move:get() then
                if state == 2 then
                    refs.leanval:set(aa_f.aa_leanlimright_move:get())
                    refs.leanmode:set(2)
                end
            end
            --air
            if aa_f.aa_lean_mode_air:get() == 1 and aa_f.aa_lean_check_air:get() and aa_f.aa_overg_air:get() then
                if state == 5 then
                    refs.leanval:set(aa_f.aa_leanlimright_air:get())
                    refs.leanmode:set(2)
                end
            end
            --crouch
            if aa_f.aa_lean_mode_crouch:get() == 1 and aa_f.aa_lean_check_crouch:get() and aa_f.aa_overg_crouch:get() then
                if state == 4 then
                    refs.leanval:set(aa_f.aa_leanlimright_crouch:get())
                    refs.leanmode:set(2)
                end
            end
            --air-duck
            if aa_f.aa_lean_mode_airduck:get() == 1 and aa_f.aa_lean_check_airduck:get() and aa_f.aa_overg_airduck:get() then
                if state == 6 then
                    refs.leanval:set(aa_f.aa_leanlimright_airduck:get())
                    refs.leanmode:set(2)
                end
            end
            if aa_f.aa_lean_mode_slowwalk:get() == 1 and aa_f.aa_lean_check_slowwalk:get() and aa_f.aa_overg_slowwalk:get() then
                if state == 3 then
                    refs.leanval:set(aa_f.aa_leanlimright_slowwalk:get())
                    refs.leanmode:set(2)
                end
            end
        end

        ---- fake
        --global
        refs.fakevalright:set(aa_f.aa_fakelimright_global:get())
        refs.fakevalleft:set(aa_f.aa_fakelimleft_global:get())
        --stand
        if aa_f.aa_overg_stand:get() and state == 1 then
            refs.fakevalright:set(aa_f.aa_fakelimright_stand:get())
            refs.fakevalleft:set(aa_f.aa_fakelimleft_stand:get())
        end
        --move
        if aa_f.aa_overg_move:get() and state == 2 then
            refs.fakevalright:set(aa_f.aa_fakelimright_move:get())
            refs.fakevalleft:set(aa_f.aa_fakelimleft_move:get())
        end
        --air
        if aa_f.aa_overg_air:get() and state == 5 then
            refs.fakevalright:set(aa_f.aa_fakelimright_air:get())
            refs.fakevalleft:set(aa_f.aa_fakelimleft_air:get())
        end
        --crouch
        if aa_f.aa_overg_crouch:get() and state == 4 then
            refs.fakevalright:set(aa_f.aa_fakelimright_crouch:get())
            refs.fakevalleft:set(aa_f.aa_fakelimleft_crouch:get())
        end
        --air-duck
        if aa_f.aa_overg_airduck:get() and state == 6 then
            refs.fakevalright:set(aa_f.aa_fakelimright_airduck:get())
            refs.fakevalleft:set(aa_f.aa_fakelimleft_airduck:get())
        end
        --slowwalk
        if aa_f.aa_overg_slowwalk:get() and state == 3 then
            refs.fakevalright:set(aa_f.aa_fakelimright_slowwalk:get())
            refs.fakevalleft:set(aa_f.aa_fakelimleft_slowwalk:get())
        end
    end
end

-- anim
local ground_tick = 1
local end_time = 0
local function animbreakers(ctx)
    if not engine.is_connected() then return end
    if not entity_list.get_local_player():is_alive() then return end
    if not aa_f.aa_animbreaker_check:get(true) then return end
    local state = get_state(get_velocity())

    local flags = entity_list.get_local_player():get_prop("m_fFlags")
    local on_land = bit.band(flags, bit.lshift(1, 0)) ~= 0

    if on_land == true then
        ground_tick = ground_tick + 1
    else
        ground_tick = 0
        end_time = global_vars.cur_time() + 1
    end

    -- main
    if aa_f.aa_animbreaker_main:get(1) and state >= 5 then
        ctx:set_render_animlayer(e_animlayers.LEAN, 1)
    end
    if aa_f.aa_animbreaker_main:get(3) then
        ctx:set_render_pose(e_poses.RUN, 0)
        refs.legslide:set(3)
    end
    if aa_f.aa_animbreaker_main:get(4) and ground_tick > 1 and end_time > global_vars.cur_time() then
        ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
    end
    if aa_f.aa_animbreaker_main:get(5) and state == 3 then
        ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0)
    end
    -- legs
    if aa_f.aa_animbreaker_legs:get() == 1 and aa_f.aa_animbreaker_main:get(2) and state >= 5  then
        ctx:set_render_pose(e_poses.JUMP_FALL, 1)
    end
    if aa_f.aa_animbreaker_legs:get() == 2 and aa_f.aa_animbreaker_main:get(2) and state >= 5  then
        ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1)
    end
    -- other
    if aa_f.aa_animbreaker_other:get(1) and get_velocity() <1 then
        ctx:set_render_animlayer(e_poses.AIM_BLEND_CROUCH_IDLE, 1)
    end
end
callbacks.add(e_callbacks.ANTIAIM, animbreakers)

---- pasted from forum https://primordial.dev/resources/fakelag-on-shoot.230/ but this thing is p asf so i idc
local forcesendnextpacket = false
local function on_aimbot_shoot(shot)
    if aa_f.onshotfl_check:get(true) then
        forcesendnextpacket = true
    end
end
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)

function on_antiaim(ctx)
    if aa_f.onshotfl_check:get(true) then
        if forcesendnextpacket then
            ctx:set_fakelag(false)
            forcesendnextpacket = false
        end
    end
end
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)

-- break lc
local is_point_visible = function(ent)
    local e_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    if entity_list.get_local_player():is_point_visible(e_pos) then
        return true
    else
        return false
    end
end

local function breaklc()
    if not engine.is_connected() then return end
    if not entity_list.get_local_player():is_alive() then return end
    if not aa_f.lc_check:get(true) then return end
    local state = get_state(get_velocity())

    -- getting enemy visiblity
    local e_visible = false
    local enemies = entity_list.get_players(true)
    for _, enemy in pairs(enemies) do if is_point_visible(enemy) then e_visible = true end end

    -- weapons
    if not aa_f.lc_weapons:get(1) then if getweapon() == "ssg08" then return end end
    if not aa_f.lc_weapons:get(2) then if getweapon() == "scar20" or getweapon() == "g3sg1" then return end end
    if not aa_f.lc_weapons:get(3) then if getweapon() == "awp" then return end end
    if not aa_f.lc_weapons:get(4) then if getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" or getweapon() == "hkp2000" then return end end
    if not aa_f.lc_weapons:get(5) then if getweapon() == "deagle" then return end end
    if not aa_f.lc_weapons:get(6) then if getweapon() == "revolver" then return end end
    if not aa_f.lc_weapons:get(7) then if getweapon() == "taser" then return end end
    if not aa_f.lc_weapons:get(8) then if getweapon() == "knife" or getweapon() == "aug" or getweapon() == "ak47" or getweapon() == "m4a1" or getweapon() == "m4a1_silencer" or getweapon() == "galilar" or getweapon() == "famas" or getweapon() == "p90" or getweapon() == "ump45" or getweapon() == "mac10" or getweapon() == "xm1014" or getweapon() == "m249" or getweapon() == "negev" or getweapon() == "sawedoff" or getweapon() == "nova" or getweapon() == "sg553" or getweapon() == "mag7" or getweapon() == "bizon" or getweapon() == "c4" or getweapon() == "molotov" or getweapon() == "flashbang" or getweapon() == "smokegrenade" or getweapon() == "hegrenade" or getweapon() == "decoy" then return end end

    if not aa_f.lc_state_check:get() then if state == 1 or state == 2 or state == 3 or state == 4 then return end end
    if e_visible then exploits.force_uncharge() end
end

local pidoras = false
local function antitaser()
    if not engine.is_connected() then return end
    if not entity_list.get_local_player():is_alive() then return end
    if not aa_f.anti_zeus_check:get() then return end
    if entity_list.get_local_player():get_active_weapon() == nil then return end

    local distance = 0
    local pidoras2 = false
    local enemies_only = entity_list.get_players(true)
    for _, enemy in pairs(enemies_only) do 
        if enemy:is_alive() then
            if enemy:is_dormant() then return end
            if enemy:get_active_weapon() == nil then return end
            if enemy:get_active_weapon():get_name() == "taser" then
                distance = math.floor(enemy:get_render_origin():dist(entity_list.get_local_player():get_render_origin()) / 17)

                if distance > 0 then
                    if distance <= aa_f.anti_zeus_max_dist:get() then
                        if pidoras == true then
                            engine.execute_cmd("slot3")
                        end
                        pidoras2 = true
                    end

                    if entity_list.get_local_player():get_active_weapon():get_name() < "taser" then
                        if not pidoras2 then
                            pidoras = true
                        end
                    elseif entity_list.get_local_player():get_active_weapon():get_name() == "taser" then
                        if pidoras2 then
                            pidoras = false
                        end
                    end
                end
            end
        end
        --targeting_log = ""
        --if pidoras then targeting_log = "true" else targeting_log = "false" end
        --client.log_screen("enemy:",color_t(255,111,111),enemy:get_name().."",color_t(255,255,255)," | distance: ",color_t(111,255,111),""..distance.."",color_t(255,255,255),"| targeting: ",color_t(111,111,255),""..targeting_log)
    end
    if entity_list.get_local_player():get_active_weapon():get_name() == "taser" and pidoras == true then pidoras = false end
end
callbacks.add(e_callbacks.SETUP_COMMAND, antitaser)

-- warmup
local function warmup_preset()
    if not engine.is_connected() then return end
    if not entity_list.get_local_player():is_alive() then return end
    if not aa_f.warmup_check:get() then return end

    if game_rules.get_prop("m_bWarmupPeriod") == 1 then
        refs.yawadd:set(antiaim.get_desync_side() == 2 and 11 or -8)
        refs.fakemode:set(4)
        refs.jittertype:set(2)
        refs.jitteradd:set(50)
        refs.leanmode:set(1)
        refs.fakevalright:set(0)
        refs.fakevalleft:set(0)
    end
end
------------------------------------------------------- rage feauteres
-- custom dt
local function customdt()
    if rage_f.customdt_check:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(rage_f.customdt_speed:get())
        if rage_f.customdt_corrections:get() then
            cvars.cl_clock_correction:set_int(0)
        end
    elseif not rage_f.customdt_check:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(16)
        cvars.cl_clock_correction:set_int(1)
    end
end

-- faster recharge
local function fasterrecharge()
    if rage_f.recharge_check:get() then
        exploits.force_recharge()
    end
end

-- interpolation
local function disableinterp()
    if rage_f.disableinterp_check:get() then
        cvars.cl_interpolate:set_int(0)
    else
        cvars.cl_interpolate:set_int(1)
    end
end

-- prediction
local function betterprediction()
    if rage_f.prediction_check:get() then
        cvars.sv_maxupdaterate:set_int(128)
    else
        cvars.sv_maxupdaterate:set_int(64)
    end
end

local backup = {
    b_as_scout_1 = refs.as_scout:get(1),
    b_as_scout_2 = refs.as_scout:get(2),
    b_as_scout_3 = refs.as_scout:get(3),
    b_as_scout_4 = refs.as_scout:get(4),
    b_as_scout_5 = refs.as_scout:get(5),
    b_as_scout_6 = refs.as_scout:get(6),

    b_as_awp_1 = refs.as_awp:get(1),
    b_as_awp_2 = refs.as_awp:get(2),
    b_as_awp_3 = refs.as_awp:get(3),
    b_as_awp_4 = refs.as_awp:get(4),
    b_as_awp_5 = refs.as_awp:get(5),
    b_as_awp_6 = refs.as_awp:get(6),
    override = true,
}

local function early_on_autopeek()
    if not rage_f.early_check:get() then return end
    
    if refs.autopeek:get() then
        if rage_f.early_weapons:get(1) then refs.as_scout:set(3, true) refs.as_scout:set(1, false) refs.as_scout:set(2, false) refs.as_scout:set(4, false) refs.as_scout:set(5, false) refs.as_scout:set(6, false) end
        if rage_f.early_weapons:get(2) then refs.as_awp:set(3, true) refs.as_awp:set(1, false) refs.as_awp:set(2, false) refs.as_awp:set(4, false) refs.as_awp:set(5, false) refs.as_awp:set(6, false) end
        backup.override = true
    else
        if backup.override then
            refs.as_scout:set(1, backup.b_as_scout_1) refs.as_scout:set(2, backup.b_as_scout_2) refs.as_scout:set(3, backup.b_as_scout_3) refs.as_scout:set(4, backup.b_as_scout_4) refs.as_scout:set(5, backup.b_as_scout_5) refs.as_scout:set(6, backup.b_as_scout_6)
            refs.as_awp:set(1, backup.b_as_awp_1) refs.as_awp:set(2, backup.b_as_awp_2) refs.as_awp:set(3, backup.b_as_awp_3) refs.as_awp:set(4, backup.b_as_awp_4) refs.as_awp:set(5, backup.b_as_awp_5) refs.as_awp:set(6, backup.b_as_awp_6)
            backup.override = false
        else
            backup.b_as_scout_1 = refs.as_scout:get(1) backup.b_as_scout_2 = refs.as_scout:get(2) backup.b_as_scout_3 = refs.as_scout:get(3) backup.b_as_scout_4 = refs.as_scout:get(4) backup.b_as_scout_5 = refs.as_scout:get(5) backup.b_as_scout_6 = refs.as_scout:get(6)
            backup.b_as_awp_1 = refs.as_awp:get(1) backup.b_as_awp_2 = refs.as_awp:get(2) backup.b_as_awp_3 = refs.as_awp:get(3) backup.b_as_awp_4 = refs.as_awp:get(4) backup.b_as_awp_5 = refs.as_awp:get(5) backup.b_as_awp_6 = refs.as_awp:get(6)
        end
    end
end
------------------------------------------------------- visual feauteres
-- menu water
local function menuwater()
    if menu.is_open() then 
        local hrs, mins, sec = client.get_local_time() -- time
        local anal_string = string.format("| user: %s | build: %s | build version: %s | latency: %s | tickrate: %s | time: %02d:%02d:%02d", user.name, build, buildver, math.floor(engine.get_latency(e_latency_flows.INCOMING)), client.get_tickrate(), hrs, mins, sec)
        render.rect_filled(vec2_t(menu.get_pos().x, menu.get_pos().y - 19), vec2_t(menu.get_size().x, 16), (color_t(0,0,0, 188)))
        if visual_f.color_theme_mode:get() == 2 then
            render.rect_fade(vec2_t(menu.get_pos().x, menu.get_pos().y - 21), vec2_t(menu.get_size().x, 2), refs.accentclr:get(), refs.accentclr:get(), true)
            render.text(pixel, "Solutions ", vec2_t(menu.get_pos().x + 10, menu.get_pos().y - 16), refs.accentclr:get())
        else
            render.rect_fade(vec2_t(menu.get_pos().x, menu.get_pos().y - 21), vec2_t(menu.get_size().x, 2), colorpickers.color_theme:get(), colorpickers.color_theme_2:get(), true)
            render.text(pixel, "Solutions ", vec2_t(menu.get_pos().x + 10, menu.get_pos().y - 16), colorpickers.color_theme:get())
        end

        render.text(pixel, ".tech ", vec2_t(render.get_text_size(pixel, "Solutions").x + menu.get_pos().x + 10, menu.get_pos().y - 16), color_t(200,200,200, 255))
        render.text(pixel, anal_string, vec2_t(render.get_text_size(pixel, "Solutions.tech ").x + menu.get_pos().x + 10, menu.get_pos().y - 16), color_t(255,255,255, 255))
    end
end

-- indicators
local function indicators()
    if visual_f.indicators_check:get() then
        if not engine.is_connected() then return end
        if not engine.is_in_game() then return end
        if not entity_list.get_local_player():is_alive() then return end

        local state = get_state(get_velocity()) -- getting state
        local state_ind = nil -- indicate state
        local sort = 0 -- sorting
        local sort2 = 0 -- sorting
        local sort3 = 0 -- sorting
        local sort4 = 0 -- sorting
        local daun = exploits.get_charge() / exploits.get_max_charge() -- exploit charge

        local statecolred = 0 -- color for states
        local statecolgreen = 0 -- color for states
        local statecolblue = 0 -- color for states

        local manualdir = "" -- indicate manual direction

        -- setting state 
        if state == 1 then
            state_ind = "stand"
        elseif state == 2 then
            state_ind = "move"
        elseif state == 3 then
            state_ind = "slide"
        elseif state == 4 then
            state_ind = "crouch"
        elseif state == 5 then
            state_ind = "air"
        elseif state == 6 then
            state_ind = "air-DUCK"
        end

        -- setting state color
        if visual_f.indicators_state_color:get() == 1 then
            statecolred = 255
            statecolgreen = 255
            statecolblue = 255
        elseif visual_f.indicators_state_color:get() == 2 then
            if visual_f.indicators_customisation:get(3) then
                if state == 1 then
                    statecolred = 140
                    statecolgreen = 181
                    statecolblue = 186
                elseif state == 2 then
                    statecolred = 157
                    statecolgreen = 251
                    statecolblue = 126
                elseif state == 3 then
                    statecolred = 55
                    statecolgreen = 225
                    statecolblue = 174
                elseif state == 4 then
                    statecolred = 205
                    statecolgreen = 122
                    statecolblue = 134
                elseif state == 5 then
                    statecolred = 250
                    statecolgreen = 253
                    statecolblue = 109
                elseif state == 6 then
                    statecolred = 225
                    statecolgreen = 157
                    statecolblue = 223
                end
            else
                statecolred = 255
                statecolgreen = 255
                statecolblue = 255
            end
        end

        -- setting manual dirreciton
        if antiaim.get_manual_override() == 1 then
            manualdir = ": <"
        elseif antiaim.get_manual_override() == 2 then
            manualdir = ": V"
        elseif antiaim.get_manual_override() == 3 then
            manualdir = ": >"
        end

        local pulse3 = math.floor(math.sin(global_vars.real_time() * 20 + 2) * 100 + 101)

        -- indicators watermark
        if visual_f.indicators_customisation:get(2) then
            if visual_f.indicators_customisation_bg:get(1) then
                render.rect_filled(vec2_t(screensize.x/2 + 6, screensize.y/2 + 11), vec2_t(render.get_text_size(pixel, "Solutions").x + 5, render.get_text_size(pixel, "Solutions").y - 3), (color_t(0,0,0, 188)))
                if visual_f.indicators_customisation_rect:get() then
                    if visual_f.color_theme_mode:get() == 1 then
                        render.rect_filled(vec2_t(screensize.x/2 + 4, screensize.y/2 + 11), vec2_t(2, render.get_text_size(pixel, "Solutions").y - 3), colorpickers.color_theme:get())
                    else
                        render.rect_filled(vec2_t(screensize.x/2 + 4, screensize.y/2 + 11), vec2_t(2, render.get_text_size(pixel, "Solutions").y - 3), refs.accentclr:get())
                    end
                end
            end
        end

        if visual_f.color_theme_mode:get() == 1 then
            if visual_f.indicators_customisation:get(4) then
                render.text(pixel, "med", vec2_t(screensize.x/2 + 8, screensize.y/2 + 10), antiaim.get_desync_side() == 2 and color_t(colorpickers.color_theme:get().r, colorpickers.color_theme:get().g, colorpickers.color_theme:get().b, 255) or color_t(255, 255, 255, 255))
                render.text(pixel, "usa", vec2_t(screensize.x/2 + 8 + render.get_text_size(pixel, "med").x, screensize.y/2 + 10), antiaim.get_desync_side() == 1 and color_t(colorpickers.color_theme:get().r, colorpickers.color_theme:get().g, colorpickers.color_theme:get().b, 255) or color_t(255, 255, 255, 255))
            else
                render.text(pixel, "Solutions", vec2_t(screensize.x/2 + 8, screensize.y/2 + 10), color_t(colorpickers.color_theme:get().r, colorpickers.color_theme:get().g, colorpickers.color_theme:get().b, 255))
            end
        else
            if visual_f.indicators_customisation:get(4) then
                render.text(pixel, "med", vec2_t(screensize.x/2 + 8, screensize.y/2 + 10), antiaim.get_desync_side() == 2 and color_t(refs.accentclr:get().r, refs.accentclr:get().g, refs.accentclr:get().b, 255) or color_t(255, 255, 255, 255))
                render.text(pixel, "usa", vec2_t(screensize.x/2 + 8 + render.get_text_size(pixel, "med").x, screensize.y/2 + 10), antiaim.get_desync_side() == 1 and color_t(refs.accentclr:get().r, refs.accentclr:get().g, refs.accentclr:get().b, 255) or color_t(255, 255, 255, 255))
            else
                render.text(pixel, "Solutions", vec2_t(screensize.x/2 + 8, screensize.y/2 + 10), color_t(refs.accentclr:get().r, refs.accentclr:get().g, refs.accentclr:get().b, 255))
            end
        end

        -- state
        if visual_f.indicators_customisation:get(2) then
            if visual_f.indicators_customisation_bg:get(2) then
                render.rect_filled(vec2_t(screensize.x/2 + 6, screensize.y/2 + 21), vec2_t(render.get_text_size(pixel, state_ind .. manualdir).x + 3, render.get_text_size(pixel, state_ind .. manualdir).y - 3), (color_t(0,0,0, 188)))
                if visual_f.indicators_customisation_rect:get() then
                    if visual_f.indicators_state_color:get() == 1 then
                        if visual_f.color_theme_mode:get() == 1 then
                            render.rect_filled(vec2_t(screensize.x/2 + 4, screensize.y/2 + 21), vec2_t(2, render.get_text_size(pixel, state_ind .. manualdir).y - 3), colorpickers.color_theme:get())
                        else
                            render.rect_filled(vec2_t(screensize.x/2 + 4, screensize.y/2 + 21), vec2_t(2, render.get_text_size(pixel, state_ind .. manualdir).y - 3), refs.accentclr:get())
                        end
                    elseif visual_f.indicators_state_color:get() == 2 then
                        render.rect_filled(vec2_t(screensize.x/2 + 4, screensize.y/2 + 21), vec2_t(2, render.get_text_size(pixel, state_ind .. manualdir).y - 3), color_t(statecolred, statecolgreen, statecolblue, 255))
                    end
                end
            end
        end
        render.text(pixel, state_ind .. manualdir, vec2_t(screensize.x/2 + 8, screensize.y/2 + 20), color_t(statecolred, statecolgreen, statecolblue, 255))
        
        if visual_f.indicators_customisation:get(2) then
            if visual_f.indicators_customisation_bg:get(3) then
                if visual_f.indicators_customisation_rect:get() then
                    if refs.doubletap:get() or refs.hideshots:get() or refs.fake_duck:get() or refs.autopeek:get() then
                        if visual_f.color_theme_mode:get() == 1 then
                            render.rect_filled(vec2_t(screensize.x/2 + 4, screensize.y/2 + 31), vec2_t(2, 9), colorpickers.color_theme:get())
                        else
                            render.rect_filled(vec2_t(screensize.x/2 + 4, screensize.y/2 + 31), vec2_t(2, 9), refs.accentclr:get())
                        end
                    elseif not refs.doubletap:get() and not refs.hideshots:get() and not refs.fake_duck:get() and not refs.autopeek:get() then
                        if refs.min_damage_p:get() then
                            if getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" or getweapon() == "ssg08" or getweapon() == "deagle" or getweapon() == "revolver" or getweapon() == "scar20" or getweapon() == "g3sg1" or getweapon() == "awp" then
                                if visual_f.color_theme_mode:get() == 1 then
                                    render.rect_filled(vec2_t(screensize.x/2 + 4, screensize.y/2 + 31), vec2_t(2, 9), colorpickers.color_theme:get())
                                else
                                    render.rect_filled(vec2_t(screensize.x/2 + 4, screensize.y/2 + 31), vec2_t(2, 9), refs.accentclr:get())
                                end
                            end
                        end
                    end
                end
            end
        end

        -- binds
        if refs.doubletap:get() then
            if visual_f.indicators_customisation:get(1) then
                render.rect_filled(vec2_t(screensize.x/2 + 7, screensize.y/2 + 40), vec2_t(render.get_text_size(pixel, "dt").x + 1, 3), (color_t(0,0,0, 188)))
                render.rect_filled(vec2_t(screensize.x/2 + 8, screensize.y/2 + 41), vec2_t(daun*render.get_text_size(pixel, "dt").x - 1, 1), (daun == 1 and color_t(255,255,255, 255) or color_t(255,0,0, 188)))

                if visual_f.indicators_customisation:get(2) then
                    if visual_f.indicators_customisation_bg:get(3) then
                        render.rect_filled(vec2_t(screensize.x/2 + 6, screensize.y/2 + 40), vec2_t(render.get_text_size(pixel, "dt").x + 3, 3), (color_t(0,0,0, 188)))
                        render.rect_filled(vec2_t(screensize.x/2 + 8, screensize.y/2 + 41), vec2_t(daun*render.get_text_size(pixel, "dt").x - 1, 1), (daun == 1 and color_t(255,255,255, 255) or color_t(255,0,0, 188)))
                        if visual_f.indicators_customisation_rect:get() then
                            render.rect_filled(vec2_t(screensize.x/2 + 6, screensize.y/2 + 40), vec2_t(render.get_text_size(pixel, "dt").x + 3, 3), (color_t(0,0,0, 188)))
                            if visual_f.color_theme_mode:get() == 1 then
                                render.rect_filled(vec2_t(screensize.x/2 + 4, screensize.y/2 + 31), vec2_t(2, 12), colorpickers.color_theme:get())
                            else
                                render.rect_filled(vec2_t(screensize.x/2 + 4, screensize.y/2 + 31), vec2_t(2, 12), refs.accentclr:get())
                            end
                            render.rect_filled(vec2_t(screensize.x/2 + 8, screensize.y/2 + 41), vec2_t(daun*render.get_text_size(pixel, "dt").x - 1, 1), (daun == 1 and color_t(255,255,255, 255) or color_t(255,0,0, 188)))
                        end
                    end
                end
            end
            if visual_f.indicators_customisation:get(2) then
                if visual_f.indicators_customisation_bg:get(3) then
                    render.rect_filled(vec2_t(screensize.x/2 + 6, screensize.y/2 + 31), vec2_t(render.get_text_size(pixel, "dt").x + 3, render.get_text_size(pixel, "dt").y - 3), (color_t(0,0,0, 188)))
                end
            end
            render.text(pixel, "dt", vec2_t(screensize.x/2 + 8, screensize.y/2 + 30), (daun == 1 and color_t(255,255,255, 255) or color_t(255,0,0, 188))) sort = sort + 13
        end

        if refs.hideshots:get() then
            if visual_f.indicators_customisation:get(2) then        
                if visual_f.indicators_customisation_bg:get(3) then
                    render.rect_filled(vec2_t(screensize.x/2 + 6 + sort + sort2, screensize.y/2 + 31), vec2_t(render.get_text_size(pixel, "hs").x + 3, render.get_text_size(pixel, "hs").y - 3), (color_t(0,0,0, 188))) sort2 = sort2 + 1
                end
            end
            render.text(pixel, "hs", vec2_t(screensize.x/2 + 7 + sort + sort2, screensize.y/2 + 30), (daun == 1 and color_t(255,255,255, 255) or color_t(255,0,0, 188))) sort = sort + 13
        end

        if refs.fake_duck:get() then
            if visual_f.indicators_customisation:get(2) then        
                if visual_f.indicators_customisation_bg:get(3) then
                    render.rect_filled(vec2_t(screensize.x/2 + 6 + sort + sort2, screensize.y/2 + 31), vec2_t(render.get_text_size(pixel, "fd").x + 3, render.get_text_size(pixel, "fd").y - 3), (color_t(0,0,0, 188))) sort2 = sort2 + 1
                end
            end
            render.text(pixel, "fd", vec2_t(screensize.x/2 + 7 + sort + sort2, screensize.y/2 + 30), color_t(255, 255, 255, 255 - pulse3)) sort = sort + 13
        end

        if refs.autopeek:get() then
            if visual_f.indicators_customisation:get(2) then        
                if visual_f.indicators_customisation_bg:get(3) then
                    render.rect_filled(vec2_t(screensize.x/2 + 6 + sort + sort2, screensize.y/2 + 31), vec2_t(render.get_text_size(pixel, "ap").x + 3, render.get_text_size(pixel, "ap").y - 3), (color_t(0,0,0, 188))) sort2 = sort2 + 1
                end
            end
            render.text(pixel, "ap ", vec2_t(screensize.x/2 + 7 + sort + sort2, screensize.y/2 + 30), color_t(255, 255, 255, 255)) sort = sort + 13
        end

        if getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
            if refs.min_damage_p:get() then
                if visual_f.indicators_customisation:get(2) then        
                    if visual_f.indicators_customisation_bg:get(3) then
                        render.rect_filled(vec2_t(screensize.x/2 + 6 + sort + sort2, screensize.y/2 + 31), vec2_t(render.get_text_size(pixel, tostring(refs.amount_pistol:get())).x + 3, 9), (color_t(0,0,0, 188)))
                    end
                end
                render.text(pixel, tostring(refs.amount_pistol:get()), vec2_t(screensize.x/2 + 8 + sort + sort2, screensize.y/2 + 30), color_t(255, 255, 255, 255)) sort = sort + 13
            end
        elseif getweapon() == "ssg08" then
            if refs.min_damage_s:get() then
                if visual_f.indicators_customisation:get(2) then        
                    if visual_f.indicators_customisation_bg:get(3) then
                        render.rect_filled(vec2_t(screensize.x/2 + 6 + sort + sort2, screensize.y/2 + 31), vec2_t(render.get_text_size(pixel, tostring(refs.amount_scout:get())).x + 3, 9), (color_t(0,0,0, 188)))
                    end
                end
                render.text(pixel, tostring(refs.amount_scout:get()), vec2_t(screensize.x/2 + 8 + sort + sort2, screensize.y/2 + 30), color_t(255, 255, 255, 255)) sort = sort + 13
            end
        elseif getweapon() == "deagle" then
            if refs.min_damage_d:get() then
                if visual_f.indicators_customisation:get(2) then        
                    if visual_f.indicators_customisation_bg:get(3) then
                        render.rect_filled(vec2_t(screensize.x/2 + 6 + sort + sort2, screensize.y/2 + 31), vec2_t(render.get_text_size(pixel, tostring(refs.amount_deagle:get())).x + 3, 9), (color_t(0,0,0, 188)))
                    end
                end
                render.text(pixel, tostring(refs.amount_deagle:get()), vec2_t(screensize.x/2 + 8 + sort + sort2, screensize.y/2 + 30), color_t(255, 255, 255, 255)) sort = sort + 13
            end
        elseif getweapon() == "revolver" then
            if refs.min_damage_r:get() then
                if visual_f.indicators_customisation:get(2) then        
                    if visual_f.indicators_customisation_bg:get(3) then
                        render.rect_filled(vec2_t(screensize.x/2 + 6 + sort + sort2, screensize.y/2 + 31), vec2_t(render.get_text_size(pixel, tostring(refs.amount_revolver:get())).x + 3, 9), (color_t(0,0,0, 188)))
                    end
                end
                render.text(pixel, tostring(refs.amount_revolver:get()), vec2_t(screensize.x/2 + 8 + sort + sort2, screensize.y/2 + 30), color_t(255, 255, 255, 255)) sort = sort + 13
            end
        elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
            if refs.min_damage_a:get() then
                if visual_f.indicators_customisation:get(2) then        
                    if visual_f.indicators_customisation_bg:get(3) then
                        render.rect_filled(vec2_t(screensize.x/2 + 6 + sort + sort2, screensize.y/2 + 31), vec2_t(render.get_text_size(pixel, tostring(refs.amount_auto:get())).x + 3, 9), (color_t(0,0,0, 188)))
                    end
                end
                render.text(pixel, tostring(refs.amount_auto:get()), vec2_t(screensize.x/2 + 8 + sort + sort2, screensize.y/2 + 30), color_t(255, 255, 255, 255)) sort = sort + 13
            end
        elseif getweapon() == "awp" then
            if refs.min_damage_awp:get() then
                if visual_f.indicators_customisation:get(2) then        
                    if visual_f.indicators_customisation_bg:get(3) then
                        render.rect_filled(vec2_t(screensize.x/2 + 6 + sort + sort2, screensize.y/2 + 31), vec2_t(render.get_text_size(pixel, tostring(refs.amount_awp:get())).x + 3, 9), (color_t(0,0,0, 188)))
                    end
                end
                render.text(pixel, tostring(refs.amount_awp:get()), vec2_t(screensize.x/2 + 8 + sort + sort2, screensize.y/2 + 30), color_t(255, 255, 255, 255)) sort = sort + 13
            end
        end
    end
end

-- watermark
local function watermark(watermark_text)
    if visual_f.disable_primomark:get() then
        return ""
    else
        return "primordial - " ..user.name
    end
end
callbacks.add(e_callbacks.DRAW_WATERMARK, watermark)

local function watermarkcustom()
    if visual_f.windows_combo:get(1) then
        local wmname = ""
        local wuid = ""
    
        if visual_f.watermark_custom_watername:get() == 1 then
            wmname = "Solutions"
        elseif visual_f.watermark_custom_watername:get() == 2 then
            wmname = "primordial"
        elseif visual_f.watermark_custom_watername:get() == 3 then
            wmname = "primordial | Solutions"
        elseif visual_f.watermark_custom_watername:get() == 4 then
            wmname = visual_f.watermark_custom_custom:get() == "" and "Solutions" or visual_f.watermark_custom_custom:get()
        end
    
        if visual_f.watermark_custom_showuid:get(true) then
            wuid = " ["..user.uid.."]"
        end
    
        local h, m, s = client.get_local_time() -- time
        local x, y = render.get_screen_size().x, render.get_screen_size().y
        local h, m, s = client.get_local_time()
        local wtm_string = string.format("%s | %s%s | time: %02d:%02d", wmname, user.name, wuid, h, m)
        local wtm_string2 = string.format("%s | %s%s | time: %02d:%02d", wmname, user.name, wuid, h, m)
        local wtm_size = render.get_text_size(pixel, wtm_string)

        textsize3 = render.get_text_size(pixel, tostring(wmname.." | " ..user.name..wuid.. " | time: " ..h..":"..m))
        if visual_f.windows_mode:get() == 1 then
            render.rect_filled(vec2_t(screensize.x - textsize3.x - 23, 13), vec2_t(wtm_size.x + 10, wtm_size.y + 3), (color_t(0,0,0, visual_f.color_theme_alpha:get())))
        else
            render.rect_filled(vec2_t(x-wtm_size.x-35, 12), vec2_t(wtm_size.x, 17), color_t(13,13,13, visual_f.color_theme_alpha:get()))
            render.rect_filled(vec2_t(x-35, 12), vec2_t(10, 7), color_t(13,13,13, visual_f.color_theme_alpha:get()))
            render.rect_filled(vec2_t(x-wtm_size.x-45, 12), vec2_t(10, 7), color_t(13,13,13, visual_f.color_theme_alpha:get()))
            if visual_f.color_theme_mode:get() == 1 then
                render.rect_fade(vec2_t(x-wtm_size.x-45, 12), vec2_t(wtm_size.x+20, 2), colorpickers.color_theme:get(), colorpickers.color_theme_2:get(), true)
            else
                render.rect_fade(vec2_t(x-wtm_size.x-45, 12), vec2_t(wtm_size.x+20, 2), refs.accentclr:get(), refs.accentclr:get(), true)
            end
        
            render.text(pixel, wtm_string, vec2_t(x-wtm_size.x-35, 16), color_t(255,255,255,255))

            render.push_clip(vec2_t(x-wtm_size.x-45, 19), vec2_t(10,10))
            render.circle_filled(vec2_t.new(x-wtm_size.x-35, 19), 10, color_t.new(13,13,13, visual_f.color_theme_alpha:get()))
            render.pop_clip()

            render.push_clip(vec2_t(x-35, 19), vec2_t(10,10))
            render.circle_filled(vec2_t.new(x-35, 19), 10, color_t.new(13,13,13, visual_f.color_theme_alpha:get()))
            render.pop_clip()
        end

        if visual_f.color_theme_mode:get() == 1 then
            if visual_f.windows_mode:get() == 1 then
                render.rect_fade(vec2_t(screensize.x - textsize3.x - 23, 12), vec2_t(wtm_size.x + 10, 2), colorpickers.color_theme:get(), colorpickers.color_theme_2:get(), true)
            end
        else
            if visual_f.windows_mode:get() == 1 then
                render.rect_fade(vec2_t(screensize.x - textsize3.x - 23, 12), vec2_t(wtm_size.x + 10, 2), refs.accentclr:get(), refs.accentclr:get(), true)
            end
        end
        if visual_f.windows_mode:get() == 1 then
            render.text(pixel, wtm_string2, vec2_t(screensize.x - textsize3.x - 18, 15), color_t(255, 255, 255, 255))
        end
    end
end

-- lethal indicator
local function lethalindicator()
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end
    if not entity_list.get_local_player():is_alive() then return end
    
    local health = entity_list.get_local_player():get_prop("m_iHealth")
    local armor = entity_list.get_local_player():get_prop("m_ArmorValue")
    local enemies_only = entity_list.get_players(true)

    if visual_f.lethal_indicator_check:get() then

        for _, enemy in pairs(enemies_only) do 
            if enemy:is_alive() then
                if enemy:get_active_weapon() == nil then return end

                if health == 93 and armor > 0 then
                    render.text(pixel, "LETHAL", vec2_t(screensize.x/2 - 37, screensize.y/2 + 10), color_t(242,167,38, 255))
                elseif enemy:get_active_weapon():get_name() == "revolver" or enemy:get_active_weapon():get_name() == "ssg08" and health <= 92 and armor > 0 then
                    render.text(pixel, "LETHAL", vec2_t(screensize.x/2 - 37, screensize.y/2 + 10), color_t(255,90,90, 255))
                end

                if health > 99 and armor == 0 and enemy:get_active_weapon():get_name() == "scar20" or enemy:get_active_weapon():get_name() == "g3sg1" then
                    render.text(pixel, "LETHAL", vec2_t(screensize.x/2 - 37, screensize.y/2 + 10), color_t(255,90,90, 255))
                elseif armor == 0 and enemy:get_active_weapon():get_name() == "revolver" or enemy:get_active_weapon():get_name() == "ssg08" then
                    render.text(pixel, "LETHAL", vec2_t(screensize.x/2 - 37, screensize.y/2 + 10), color_t(255,90,90, 255))
                elseif health <= 99 and armor > 0 and enemy:get_active_weapon():get_name() == "revolver" then
                    render.text(pixel, "LETHAL", vec2_t(screensize.x/2 - 37, screensize.y/2 + 10), color_t(242,167,38, 255))
                end
            end
        end
    end
end

local function slowdownind()
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end
    if not entity_list.get_local_player():is_alive() then return end

    if visual_f.slowdownind_check:get() then
	    local modifier = entity_list.get_local_player():get_prop("m_flVelocityModifier")
	    if modifier == 1 then return end

        render.text(pixel, "VELOCITY", vec2_t(screensize.x/2 - render.get_text_size(pixel, "VELOCITY").x/2, screensize.y/2 - 55), color_t.new(math.floor(255 - modifier * 140), math.floor(100 + modifier * 60), math.floor(36 + modifier * 50)), 255)
        render.rect_filled(vec2_t.new(screensize.x/2 - render.get_text_size(pixel, "VELOCITY").x/2 - 1, screensize.y/2 - 45), vec2_t.new(render.get_text_size(pixel, "VELOCITY").x + 1, 6), color_t.new(0,0,0, 188))
        render.rect_filled(vec2_t.new(screensize.x/2 - render.get_text_size(pixel, "VELOCITY").x/2, screensize.y/2 - 43), vec2_t.new(math.floor(modifier * render.get_text_size(pixel, "VELOCITY").x - 1), 2), color_t.new(math.floor(255 - modifier * 140), math.floor(100 + modifier * 60), math.floor(36 + modifier * 50)))
    end
end

local is_in_bounds = function(bound_a, bound_b, position)
    return position.x >= bound_a.x and position.y >= bound_a.y and position.x <= bound_b.x and position.y <= bound_b.y
end
local screen_size = render.get_screen_size()
local dragging = false
local drag_offset = vec2_t(0, 0)
local pos_x = menu.add_slider("window", "spectators_position_x", 0, screen_size.x)
local pos_y = menu.add_slider("window", "spectators_position_y", 0, screen_size.y)
pos_x:set_visible(false)
pos_y:set_visible(false)
pos_x:set(300)
pos_y:set(400)

local variables = {
    keybind = {
        offsetx = 0,
        offsety = 0,
        modes = {"[toggled]", "[hold on]", "[on]", "[on]","[off]"},
        size = 140
    },
}

local daun = ""
local function keybinds()
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end
    if not entity_list.get_local_player():is_alive() then return end

    local sort = 0
    local a=entity_list.get_local_player():get_active_weapon()if a==nil then return end;weapon_name=a:get_name()if weapon_name=="glock"or weapon_name=="p250"or weapon_name=="cz75a"or weapon_name=="usp-s"or weapon_name=="tec9"or weapon_name=="p2000"or weapon_name=="fiveseven"or weapon_name=="elite"then daun="pistols"elseif weapon_name=="ssg08"then daun="scout"elseif weapon_name=="deagle"then daun="deagle"elseif weapon_name=="revolver"then daun="revolver"elseif weapon_name=="scar20"or weapon_name=="g3sg1"then daun="auto"elseif weapon_name=="awp"then daun="awp"else daun="other"end
    
    local x, y = render.get_screen_size().x, render.get_screen_size().y
    local kb_string = string.format("keybinds")
    local kb_size = render.get_text_size(pixel, kb_string)

    keybindings = {
        ["double tap"]                    = menu.find("aimbot","general","exploits","doubletap","enable"),
        ["hide shots"]                    = menu.find("aimbot","general","exploits","hideshots","enable"),
        ["roll resolver"]                 = menu.find("aimbot","general","aimbot","body lean resolver"),
        ["override resolver"]             = menu.find("aimbot","general","aimbot","override resolver"),
        ["auto peek"]                     = menu.find("aimbot","general","misc","autopeek"),
        ["fake ping"]                     = menu.find("aimbot","general","fake ping","enable"),
        ["dont use recharge"]             = menu.find("aimbot","general","exploits","doubletap","dont use charge"),
        
        ["min damage"]                    = menu.find("aimbot", daun, "target overrides", "force min. damage"),
        ["force lethal"]                  = menu.find("aimbot", daun, "target overrides", "force lethal shot"),
        ["hitchance override"]            = menu.find("aimbot", daun, "target overrides", "force hitchance"),
        ["force hitbox"]                  = menu.find("aimbot", daun, "target overrides", "force hitbox"),
        ["force safepoint"]               = menu.find("aimbot", daun, "target overrides", "force safepoint"),
        ["force body lean safepoint"]     = menu.find("aimbot", daun, "target overrides", "force body lean safepoint"),

        ["fake duck"]                     = menu.find("antiaim","main","general","fake duck"),
        ["invert"]                        = menu.find("antiaim","main","manual","invert desync"),
        ["auto direction"]                = menu.find("antiaim","main","auto direction","enable"),
        ["extended angles"]               = menu.find("antiaim","main","extended angles","enable"),
              
        ["autothrow"]                     = menu.find("misc","utility","nade helper","autothrow"),
    }
    
    textsize2 = render.get_text_size(pixel, tostring("Keybinds"))
    textsize = render.get_text_size(pixel, tostring("DAYNDAYNDAYNDAYNDAYNDAYNDAYNDAYN*"))

    if visual_f.windows_combo:get(2) then
        if visual_f.windows_mode:get() == 1 then
            render.rect_filled(vec2_t(pos_x:get(), pos_y:get()), vec2_t(161, textsize2.y + 3), (color_t(0,0,0, visual_f.color_theme_alpha:get())))
            if visual_f.color_theme_mode:get() == 1 then
                render.rect_fade(vec2_t(pos_x:get(), pos_y:get() - 1), vec2_t(161, 2), colorpickers.color_theme:get(), colorpickers.color_theme_2:get(), true)
            else
                render.rect_fade(vec2_t(pos_x:get(), pos_y:get() - 1), vec2_t(161, 2), refs.accentclr:get(), refs.accentclr:get(), true)
            end
        else
        
            if visual_f.color_theme_mode:get() == 1 then
                render.rect_fade(vec2_t(pos_x:get(), pos_y:get() - 2), vec2_t(160, 2), colorpickers.color_theme:get(), colorpickers.color_theme_2:get(), true)
            else
                render.rect_fade(vec2_t(pos_x:get(), pos_y:get() - 2), vec2_t(160, 2), refs.accentclr:get(), refs.accentclr:get(), true)
            end
            render.rect_filled(vec2_t(pos_x:get() + 10, pos_y:get()), vec2_t(140, textsize2.y + 3), color_t(13,13,13, visual_f.color_theme_alpha:get()))
            render.rect_filled(vec2_t(pos_x:get(), pos_y:get()), vec2_t(10, 5), color_t(13,13,13, visual_f.color_theme_alpha:get()))
            render.rect_filled(vec2_t(pos_x:get() + 150, pos_y:get()), vec2_t(10, 5), color_t(13,13,13, visual_f.color_theme_alpha:get()))
        
            render.push_clip(vec2_t(pos_x:get(), pos_y:get() + 5), vec2_t(10,10))
            render.circle_filled(vec2_t.new(pos_x:get() + 10, pos_y:get() + 5), 10, color_t.new(13,13,13, visual_f.color_theme_alpha:get()))
            render.pop_clip()
        
            render.push_clip(vec2_t(pos_x:get() + 150, pos_y:get() + 5), vec2_t(10,10))
            render.circle_filled(vec2_t.new(pos_x:get() + 150, pos_y:get() + 5), 10, color_t.new(13,13,13, visual_f.color_theme_alpha:get()))
            render.pop_clip()
        end

        render.text(pixel, "Keybinds", vec2_t(pos_x:get() + 63, pos_y:get() + 2.5), color_t(255, 255, 255, 255))

        offset = 1

        for i, v in pairs(keybindings) do
            local dap = v[2]
            if dap:get() then
                local itssize = render.get_text_size(pixel, variables.keybind.modes[dap:get_mode()+1])
                if visual_f.color_theme_mode:get() == 1 then
                    render.text(pixel, i, vec2_t(pos_x:get()+variables.keybind.size-2 - 136, pos_y:get() + 8 + (12*offset)), colorpickers.color_theme:get())
                    render.text(pixel, variables.keybind.modes[dap:get_mode()+1], vec2_t(pos_x:get()+variables.keybind.size-2-itssize.x + 21, pos_y:get() + 8 + (12*offset)), colorpickers.color_theme_2:get())
                else
                    render.text(pixel, i, vec2_t(pos_x:get()+variables.keybind.size-2 - 136, pos_y:get() + 8 + (12*offset)), refs.accentclr:get())
                    render.text(pixel, variables.keybind.modes[dap:get_mode()+1], vec2_t(pos_x:get()+variables.keybind.size-2-itssize.x + 21, pos_y:get() + 8 + (12*offset)), refs.accentclr:get())
                end
                offset = offset + 1
            end
        end
    end

    if input.is_key_held(e_keys.MOUSE_LEFT) and menu.is_open() then
        local mouse_position = input.get_mouse_pos()
        if dragging == false and is_in_bounds(vec2_t(pos_x:get(), pos_y:get()), vec2_t(pos_x:get() + textsize.x + 5, pos_y:get()+19), mouse_position) == true then
            drag_offset.x = mouse_position.x - pos_x:get()
            drag_offset.y = mouse_position.y - pos_y:get()
            dragging = true
        end
        if dragging == true then
            pos_x:set(mouse_position.x - drag_offset.x)
            pos_y:set(mouse_position.y - drag_offset.y)
        end
    else
        dragging = false
    end
end

local function infobox()
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end
    if not entity_list.get_local_player():is_alive() then return end

    if visual_f.infobox_check:get() then
        local clr1 = color_t(0,0,0, 255)
        local clr2 = color_t(0,0,0, 255)

        if antiaim.get_desync_side() == 0 then
            clr1 = color_t(249,72,72, 255)
            clr2 = color_t(249,72,72, 255)
        elseif antiaim.get_desync_side() == 1 then
            if visual_f.color_theme_mode:get() == 1 then
                clr1 = colorpickers.color_theme_2:get()
            else
                clr1 = refs.accentclr:get()
            end
            clr2 = color_t(255,255,255, 255)
        elseif antiaim.get_desync_side() == 2 then
            clr1 = color_t(255,255,255, 255)
            if visual_f.color_theme_mode:get() == 1 then
                clr2 = colorpickers.color_theme_2:get()
            else
                clr2 = refs.accentclr:get()
            end
        end

        local bodyyaw = entity_list.get_local_player():get_prop("m_flPoseParameter", 11) * 120 - 60
        if bodyyaw < 0 then angle = bodyyaw*-1 else angle = bodyyaw end

        if visual_f.color_theme_mode:get() == 1 then
            render.text(pixel, ">>>", vec2_t(screensize.x/20 - 50, screensize.y/2.5 + 20), colorpickers.color_theme:get())
            render.text(pixel, "Solutions.tech", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> ").x, screensize.y/2.5 + 20), color_t(255, 255, 255, 255))
            render.text(pixel, "["..build.."]", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> Solutions.tech ").x, screensize.y/2.5 + 20), colorpickers.color_theme:get())
            render.text(pixel, ">>>", vec2_t(screensize.x/20 - 50, screensize.y/2.5 + 35), colorpickers.color_theme_2:get())
            render.text(pixel, "fake:", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> ").x, screensize.y/2.5 + 35), color_t(255,255,255, 255))
            render.text(pixel, ""..math.floor(angle), vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> fake: ").x, screensize.y/2.5 + 35), colorpickers.color_theme_2:get())
            render.text(pixel, "° | side: ", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ".>>> fake: " ..math.floor(angle)).x, screensize.y/2.5 + 35), color_t(255,255,255, 255))
            render.text(pixel, "<<", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ".>>> fake: "..math.floor(angle).."% | side: ").x, screensize.y/2.5 + 35), clr1)
            render.text(pixel, ">>", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ".>>> fake: "..math.floor(angle).."% | side: << ").x, screensize.y/2.5 + 35), clr2)
            render.text(pixel, ">>>", vec2_t(screensize.x/20 - 50, screensize.y/2.5 + 50), colorpickers.color_theme:get())
            render.text(pixel, "fps:", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> ").x, screensize.y/2.5 + 50), color_t(255,255,255, 255))
            render.text(pixel, ""..client.get_fps(), vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> fps: ").x, screensize.y/2.5 + 50), colorpickers.color_theme:get())
            render.text(pixel, " tickrate:", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> fps: "..client.get_fps()).x, screensize.y/2.5 + 50), color_t(255,255,255, 255))
            render.text(pixel, ""..client.get_tickrate(), vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> fps: "..client.get_fps().." tickrate: ").x, screensize.y/2.5 + 50), colorpickers.color_theme:get())
        else
            render.text(pixel, ">>>", vec2_t(screensize.x/20 - 50, screensize.y/2.5 + 20), refs.accentclr:get())
            render.text(pixel, "Solutions.tech", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> ").x, screensize.y/2.5 + 20), color_t(255, 255, 255, 255))
            render.text(pixel, "["..build.."]", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> Solutions.tech").x, screensize.y/2.5 + 20), refs.accentclr:get())
            render.text(pixel, ">>>", vec2_t(screensize.x/20 - 50, screensize.y/2.5 + 35), refs.accentclr:get())
            render.text(pixel, "fake:", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> ").x, screensize.y/2.5 + 35), color_t(255,255,255, 255))
            render.text(pixel, ""..math.floor(angle), vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> fake: ").x, screensize.y/2.5 + 35), refs.accentclr:get())
            render.text(pixel, "° | side: ", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ".>>> fake: " ..math.floor(angle)).x, screensize.y/2.5 + 35), color_t(255,255,255, 255))
            render.text(pixel, "<<", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ".>>> fake: "..math.floor(angle).."% | side: ").x, screensize.y/2.5 + 35), clr1)
            render.text(pixel, ">>", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ".>>> fake: "..math.floor(angle).."% | side: << ").x, screensize.y/2.5 + 35), clr2)
            render.text(pixel, ">>>", vec2_t(screensize.x/20 - 50, screensize.y/2.5 + 50), refs.accentclr:get())
            render.text(pixel, "fps:", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> ").x, screensize.y/2.5 + 50), color_t(255,255,255, 255))
            render.text(pixel, ""..client.get_fps(), vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> fps: ").x, screensize.y/2.5 + 50), refs.accentclr:get())
            render.text(pixel, " tickrate:", vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> fps: "..client.get_fps()).x, screensize.y/2.5 + 50), color_t(255,255,255, 255))
            render.text(pixel, ""..client.get_tickrate(), vec2_t(screensize.x/20 - 50 + render.get_text_size(pixel, ">>> fps: "..client.get_fps().." tickrate: ").x, screensize.y/2.5 + 50), refs.accentclr:get())
        end
    end
end

-- penis dot
local wpn_ignored = {
    'CKnife',
    'CWeaponTaser',
    'CC4',
    'CHEGrenade',
    'CSmokeGrenade',
    'CMolotovGrenade',
    'CSensorGrenade',
    'CFlashbang',
    'CDecoyGrenade',
    'CIncendiaryGrenade'
}

local function contains(tbl, val) 
    for i=1,#tbl do 
        if tbl[i] == val then 
            return true 
        end
    end 
    return false 
end

local function angle_forward(angle) 
    local sin_pitch = math.sin(math.rad(angle[1]))
    local cos_pitch = math.cos(math.rad(angle[1]))
    local sin_yaw = math.sin(math.rad(angle[2]))
    local cos_yaw = math.cos(math.rad(angle[2]))

    return {        
        cos_pitch * cos_yaw,
        cos_pitch * sin_yaw,
        -sin_pitch
    }
end

local function pendot()
    if not visual_f.penisdot_check:get(true) then return end
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end
    if not entity_list.get_local_player():is_alive() then return end

    local local_player = entity_list.get_local_player()
    local weapon = local_player:get_active_weapon()

    refs.penetration:set(false)

    local x, y = render.get_screen_size().x/2, render.get_screen_size().y/2

    if weapon == nil or contains(wpn_ignored, weapon:get_class_name()) then
        return
    end

    local pitch, yaw = engine.get_view_angles().x, engine.get_view_angles().y
    local fwd = angle_forward({ pitch, yaw, 0 })
    local start_pos = { local_player:get_eye_position().x, local_player:get_eye_position().y,  local_player:get_eye_position().z }
    
    local fraction = trace.line(vec3_t(start_pos[1], start_pos[2], start_pos[3]), vec3_t(start_pos[1] + (fwd[1] * 8192), start_pos[2] + (fwd[2] * 8192), start_pos[3] + (fwd[3] * 8192)), local_player).fraction

    if fraction < 1 then
        local end_pos = {
            start_pos[1] + (fwd[1] * (8192 * fraction + 128)),
            start_pos[2] + (fwd[2] * (8192 * fraction + 128)),
            start_pos[3] + (fwd[3] * (8192 * fraction + 128)),
        }

        local ent = trace.bullet(vec3_t(start_pos[1], start_pos[2], start_pos[3]), vec3_t(end_pos[1], end_pos[2], end_pos[3]), local_player).entity
        local dmg = trace.bullet(vec3_t(start_pos[1], start_pos[2], start_pos[3]), vec3_t(end_pos[1], end_pos[2], end_pos[3]), local_player).damage

        if ent == nil then
            ent = -1
        end

        if dmg > 0 then
            render.rect_filled(vec2_t(x-1, y), vec2_t(3, 1), color_t(0,255,0))
            render.rect_filled(vec2_t(x, y-1), vec2_t(1, 3), color_t(0,255,0))
        else
            render.rect_filled(vec2_t(x-1, y), vec2_t(3, 1), color_t(255,0,0))
            render.rect_filled(vec2_t(x, y-1), vec2_t(1, 3), color_t(255,0,0))
        end
    end
end

-- floyd mode
local function floyd()
    if visual_f.floydmode_check:get() then
        cvars.r_skin:set_int(1)
    else
        cvars.r_skin:set_int(0)
    end
end

local function zeus_warning()
    if not engine.is_connected() then return end
    if entity_list.get_local_player() == nil then return end
    if not entity_list.get_local_player():is_alive() then return end
    if not visual_f.zeus_warning_check:get() then return end
    
    local enemies_only = entity_list.get_players(true)
    for _,enemy in pairs(enemies_only) do
        if enemy:is_alive() then
            if enemy:is_dormant() then return end
            if enemy:get_active_weapon() == nil then return end
            if enemy:get_active_weapon():get_name() == "taser" then
                local distance = math.floor(enemy:get_render_origin():dist(entity_list.get_local_player():get_render_origin()) / 17)
                if distance <= 30 then
                    render.text(pixel, "you can be zeused!", vec2_t(screensize.x/2 - render.get_text_size(pixel, "you can be zeused!").x/2, screensize.y/2 - 35), color_t.new(255,math.floor(255 + distance * 5),math.floor(255 + distance), 255))
                end
            end
        end
    end
end
------------------------------------------------------- misc feauteres
-- killsay
local function table_lengh(data)
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end
    if not entity_list.get_local_player():is_alive() then return end

    if type(data) ~= 'table' then
        return 0													
    end
    local count = 0
    for _ in pairs(data) do
        count = count + 1
    end
    return count
end

local function on_event(event)
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end
    if not entity_list.get_local_player():is_alive() then return end

    local kill_cmd = "say "

    if misc_f.trashtalk_check:get() then
        if misc_f.trashtalk_mode:get() == 1 then
            kill_cmd = 'say ' .. killsay_phrases.ksay_russian[math.random(table_lengh(killsay_phrases.ksay_russian))]
        elseif misc_f.trashtalk_mode:get() == 2 then
            if event.headshot == true and misc_f.tt_hs_check:get() then
                kill_cmd = 'say ' .. killsay_phrases.ksay_english_hs[math.random(table_lengh(killsay_phrases.ksay_english_hs))]
            else
                kill_cmd = 'say ' .. killsay_phrases.ksay_english[math.random(table_lengh(killsay_phrases.ksay_english))]
            end
        end

        if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end
        engine.execute_cmd(kill_cmd)
    end
end

callbacks.add(e_callbacks.EVENT, on_event, "player_death")

-- clantag changer
local _set_clantag = ffi.cast('int(__fastcall*)(const char*, const char*)', memory.find_pattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))
local _last_clantag = nil

local set_clantag = function(v)
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end

  if v == _last_clantag then return end
  _set_clantag(v, v)
  _last_clantag = v
end

local clantags = {

    george = {
        "Solutions.tech ",
        "Solutions.tec- ",
        "Solutions.te- ",
        "Solutions.t- ",
        "Solutions.- ",
        "Solutions- ",
        "Solution- ",
        "Solutio- ",
        "Soluti- ",
        "Solut- ",
        "Solu- ",
        "Sol- ",
        "So- ",
        "S- ",
        "So- ",
        "Sol- ",
        "Solu- ",
        "Solut- ",
        "Soluti- ",
        "Solutio- ",
        "Solution- ",
        "Solutions- ",
        "Solutions.- ",
        "Solutions.t- ",
        "Solutions.te- ",
        "Solutions.tec- ",
        "Solutions.tech- ",
    },

    george2 = {
        "Solutions Prim ",
        "Solutions Prim ",
        "Solutions Pri ",
        "Solutions Pr ",
        "Solutions P ",
        "Solutions ",
        "Solution ",
        "Solutio ",
        "Soluti ",
        "Solui ",
        "Solu ",
        "Sol ",
        "So ",
        "S ",
        "So ",
        "Sol ",
        "Solu ",
        "Solut ",
        "Soluti ",
        "Solutio ",
        "Solution ",
        "Solutions ",
        "Solutions P ",
        "Solutions Pr ",
        "Solutions Pri ",
        "Solutions Prim ",
    },
}

local function clantag_animation()
    
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end

    local latency = engine.get_latency(0) / global_vars.interval_per_tick()
    local tickcount_pred = global_vars.tick_count() + latency
    local floyd = math.floor(math.fmod(tickcount_pred / 27, #clantags.george) + 1)
    local floyd2 = math.floor(math.fmod(tickcount_pred / 25, #clantags.george2) + 1)

    if misc_f.clantag_check:get() then
        if misc_f.clantag_mode:get() == 1 then
            set_clantag(clantags.george[floyd])
        elseif misc_f.clantag_mode:get() == 2 then
            set_clantag(clantags.george2[floyd2])
        end
    else
        set_clantag("")
    end 
end

local function clantag_destroy()
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end
    set_clantag("")
end

-- gh fixer
local function on_gh_enable()
    if misc_f.gh_fix_check:get() then
        if refs.gh_ref:get() then
            refs.autostrafe_ref:set(false)
        else
            refs.autostrafe_ref:set(true)
        end
    end
end

local function nigger123()
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() then return end
    local money = entity_list.get_local_player():get_prop("m_iAccount")

    if misc_f.autobuy_check:get() then
        if money <= 1000 then
            refs.buybot:set(false)
        else
            refs.buybot:set(true)
        end
    end
end

-- callbacks
callbacks.add(e_callbacks.ANTIAIM, function()
    mainaa()
    warmup_preset()
end)

callbacks.add(e_callbacks.SETUP_COMMAND, function()
    fasterrecharge()
    breaklc()
end)

callbacks.add(e_callbacks.PAINT, function()
    drawshit()
    customdt()
    disableinterp()
    betterprediction()
    menuwater()
    indicators()
    watermarkcustom()
    lethalindicator()
    slowdownind()
    keybinds()
    infobox()
    pendot()
    floyd()
    clantag_animation()
    on_gh_enable()
    nigger123()
    aa_sort()
    early_on_autopeek()
    zeus_warning()
end)

callbacks.add(e_callbacks.SHUTDOWN, function()
    clantag_destroy()
    engine.execute_cmd("play unload_sound.wav")
end)