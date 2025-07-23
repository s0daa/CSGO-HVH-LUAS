-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local ffi = require("ffi")
local base64 = require("neverlose/base64")
local mtools = require("neverlose/mtools")
local clipboard = require("neverlose/clipboard")
local gradient = require("neverlose/gradient")
local drag_system = require("neverlose/drag_system")
local pui = require("neverlose/pui")
local events = require("neverlose/events")
local bomb_info = require("neverlose/bomb")
local smoothy = require('neverlose/smoothy')

ffi.cdef[[ 
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    bool CreateDirectoryA(const char* lpPathName, void* lpSecurityAttributes);

    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct {
        char  pad_0000[20];
        int m_nOrder; //0x0014
        int m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030
        char  pad_0038[4]; //0x0034
    } c_animlayers;
    typedef struct {
        float x;
        float y;
        float z;
    } vector_t;
]]

local function this_call(call_function, parameters) return function(...) return call_function(parameters, ...) end end
local entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface("client.dll", "VClientEntityList003"))
local get_entity_address = this_call(ffi.cast("get_client_entity_t", entity_list_003[0][3]), entity_list_003)
local engine_client = ffi.cast(ffi.typeof('void***'), utils.create_interface('engine.dll', 'VEngineClient014'))
local console_is_visible = ffi.cast(ffi.typeof('bool(__thiscall*)(void*)'), engine_client[0][11])

local downloads = {
    createfolder = function()
        create_lua_folder = mtools.FileSystem.CreateDir("nl\\redrum");
    end,

    downloadfile = function()
        mtools.Network.Download(
            "https://cdn.discordapp.com/attachments/1263223913123545190/1283602906926284830/right.png?ex=66e397dd&is=66e2465d&hm=2f043210ca3682c7b06bf82803ed7c470081161fd3dd70fe4fb2822f36ab63cf&", 
            "nl\\redrum\\right.png", 
            true,
            97
        );
        mtools.Network.Download(
            "https://cdn.discordapp.com/attachments/1263223913123545190/1283602906678956104/left.png?ex=66e397dd&is=66e2465d&hm=8fe1ec75912c01867b73d13d5f765da09b22c0b4cf46e1c7c9c938aca38794d0&", 
            "nl\\redrum\\left.png", 
            true,
            97
        );
        mtools.Network.Download(
            "https://media.discordapp.net/attachments/1263223913123545190/1283602906372903065/c4_icon.png?ex=66e397dd&is=66e2465d&hm=cd2de794d88c897a080a1afd26a56cb37b8c75964fbdd39ddc4e48eb05fc5a2a&=&format=webp&quality=lossless", 
            "nl\\redrum\\c4_icon.png", 
            true,
            97
        );
    end
}
downloads:createfolder()
downloads:downloadfile()

local REDRUM_gradient = gradient.text_animate("𝙍𝙀𝘿𝙍𝙐𝙈", -1, {
    color(ui.get_style("Link Active").r, ui.get_style("Link Active").g, ui.get_style("Link Active").b, ui.get_style("Link Active").a),
    color(ui.get_style("Link Active").r, ui.get_style("Link Active").g, ui.get_style("Link Active").b, ui.get_style("Link Active").a - 180),
})

events.pre_render:set(function()
    if ui.get_alpha() > 0 then
        pui.sidebar(REDRUM_gradient:get_animated_text(), '🔪')
        REDRUM_gradient:animate()
    end
end)

local redrum = {
    groups = {
        selection = pui.create("", " ", 1),
        antiaim = {
            builder = pui.create("", "  ", 2),
            additionals = pui.create("", "    ", 2),
            selection = pui.create("", "", 1),
        },
        configs = {
            list = pui.create("", "   ", 2),
        },
        visuals = {
            selection = pui.create("", "     ", 1),
            screen = pui.create("", "      ", 2),
            ingame = pui.create("", "      ", 2),
        },
        misc = {
            main = pui.create("", "       ", 2),
        },
    },
    vars = {
        lua_version = "Debug",
        username = common.get_username(),
        customscope_length = 0,
        customscope_gap = 0,
        c4_icon = render.load_image_from_file(("nl\\redrum\\c4_icon.png"), vector(32,28)),
        refs = {
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
            yawbase = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
            yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
            base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
            yawoffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
            avoidbackstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
            hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
            yawmodifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
            yawmodifieroffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
            bodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
            bodyyaw_invert = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
            bodyyaw_leftlimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
            bodyyaw_rightlimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
            bodyyaw_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
            bodyyaw_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
            freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
            antiuntrusted = ui.find("Miscellaneous", "Main", "Other", "Anti Untrusted"),
            lagoptions = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
            hideshotsoptions = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
            doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
            hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
            immediateteleport = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Immediate Teleport"),
            fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
            mindamage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
            fakeping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
            dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
            safepoint = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
            bodyaim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
        }
    },
    font = {
        arrow_left = render.load_image_from_file("nl\\redrum\\left.png", vector(12, 12)),
        arrow_right = render.load_image_from_file("nl\\redrum\\right.png", vector(12, 12)),
        verdana = render.load_font("Verdana", 11, "dba"),
        verdana3 = render.load_font("Verdana",16, "ab"),
        gs_font = render.load_font("Calibri Bold", vector(24,24), "ad"),
        gs_font_small = render.load_font("Calibri Bold", vector(21,20), "ad"),
        widgets = render.load_font("Verdana", 30, "ba"),
        eventlogger = render.load_font("Verdana", 15, "ba"),
    }
}
anim_tbl = {}
easing_table = smoothy.new(anim_tbl)
local functions = {
    player_invert = function()
        local local_player = entity.get_local_player()
        local player_invert = local_player.m_flPoseParameter[11] * 120 - 60 <= 0 and true or false
        return player_invert
    end,
    get_player_active_weapon = function(player)
        local get_weapon = player:get_player_weapon():get_classname()
        return get_weapon
    end,
    get_air = function(player)
        if not player then return end
        local get_jump = bit.band(player.m_fFlags, bit.lshift(1, 0)) == 0
        local get_duck = player.m_flDuckAmount > 0.8
    
        if get_jump and not get_duck and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() == false then
            return 1
        elseif get_jump and get_duck and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() == false then
            return 2
        else
            return false
        end
    end,
    get_anim_layer = function(b,c)
        c = c or 1;b=ffi.cast(ffi.typeof('void***'),b)
        return ffi.cast('c_animlayers**',ffi.cast('char*',b)+0x2990)[0][c]
    end,
    animated_text = function(name, argument, additional, position, font, text_color, flags, text)
        if anim_tbl[name] == nil then
            anim_tbl[name] = 0
            easing_table = smoothy.new(anim_tbl)
        end

        local measure_normal = render.measure_text(font, nil, text)

        local text_size
        if argument then
            text_size = easing_table(0.08, { [name] = vector(0,8,0)})[name]
        else
            text_size = easing_table(0.08, { [name] = render.measure_text(font, nil, text)})[name]
        end


        if additional == true then
            render.push_clip_rect(vector(position.x - measure_normal.x + text_size.x*2, position.y - text_size.y), vector(position.x + measure_normal.x - text_size.x*2, position.y + text_size.y*2), true)
        else
            render.push_clip_rect(vector(position.x, position.y - text_size.y), vector(position.x + measure_normal.x - text_size.x/1.95, position.y + text_size.y*2), true)
        end

        if additional == true then
            render.text(font, vector(position.x, position.y), text_color, flags, text)
        else
            render.text(font, vector(position.x + text_size.x, position.y), text_color, flags, text)
        end

        render.pop_clip_rect()
    end,
    lerp = function(time,a,b) 
        return a * (1-time) + b * time 
    end,
    lerp_position = function(position_al, position_bl, recharge)
        return vector((position_bl.x - position_al.x) * recharge + position_al.x, (position_bl.y - position_al.y) * recharge + position_al.y, (position_bl.z - position_al.z) * recharge + position_al.z)
    end,
    is_bounded = function(vec1_x, vec1_y, vec2_x, vec2_y)
        local mouse_pos = ui.get_mouse_position()
        return mouse_pos.x >= vec1_x and mouse_pos.x <= vec2_x and mouse_pos.y >= vec1_y and mouse_pos.y <= vec2_y
    end,
    gamesensefade = function(gap, text, icon, time, r, g, b, scale)
        local x, y = render.screen_size().x, (render.screen_size().y + 50)
        if scale == "100%" then
            local measure_text = render.measure_text(redrum.font.gs_font, "c", text) 
            if icon == nil and time == nil then
                render.gradient(vector(x/40, y/1.43 - 4 - gap), vector(x/40 + measure_text.x + 5, y/1.43 + 30 - gap), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), 0)
                render.gradient(vector(x/40 - 45, y/1.43 - 4 - gap), vector(x/40, y/1.43 + 30 - gap), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), 0)
                render.text(redrum.font.gs_font, vector(x/62, y/1.43 + 3 - gap), color(r, g, b, 255), nil, text)
            elseif icon ~= nil and time ~= nil then
                render.gradient(vector(x/40, y/1.43 - 4 - gap), vector(x/40 + measure_text.x, y/1.43 + 30 - gap), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), 0)
                render.gradient(vector(x/40 - 45, y/1.43 - 4 - gap), vector(x/40, y/1.43 + 30 - gap), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), 0)
                render.text(redrum.font.gs_font, vector(x/62 + 38, y/1.43 + 3 - gap), color(r, g, b, 255), nil, text)
                render.texture(icon, vector(x/62, y/1.43 - gap), vector(32, 28), color(r, g, b, 255), f, 0)
                render.circle_outline(vector(x/62 + 70, y/1.43 + 12 - gap), color(10,10,10,255), 10, 0, 1, 5)
                render.circle_outline(vector(x/62 + 70, y/1.43 + 12 - gap), color(200,200,200), 9, 0, time, 3)
            elseif icon ~= nil and time == nil then
                render.gradient(vector(x/40, y/1.43 - 4 - gap), vector(x/40 + measure_text.x, y/1.43 + 30 - gap), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), 0)
                render.gradient(vector(x/40 - 45, y/1.43 - 4 - gap), vector(x/40, y/1.43 + 30 - gap), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), 0)
                render.text(redrum.font.gs_font, vector(x/62 + 38, y/1.43 + 3 - gap), color(r, g, b, 255), nil, text)
                render.texture(icon, vector(x/62, y/1.43 - gap), vector(32, 28), color(r, g, b, 255), f, 0)
            end
        elseif scale == "75%" then
            local measure_text = render.measure_text(redrum.font.gs_font_small, "c", text) 
            if icon == nil and time == nil then
                render.gradient(vector(x/40, y/1.43 + 68 - gap), vector(x/40 + measure_text.x - 5, y/1.43 + 95 - gap), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), 0)
                render.gradient(vector(x/40 - 45, y/1.43 + 68 - gap), vector(x/40, y/1.43 + 95 - gap), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), 0)
                render.text(redrum.font.gs_font_small, vector(x/62, y/1.43 + 73 - gap), color(r, g, b, 255), nil, text)
            elseif icon ~= nil and time ~= nil then
                render.gradient(vector(x/40, y/1.43 + 68 - gap), vector(x/40 + measure_text.x - 5, y/1.43 + 95 - gap), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), 0)
                render.gradient(vector(x/40 - 45, y/1.43 + 68 - gap), vector(x/40, y/1.43 + 95 - gap), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), 0)
                render.text(redrum.font.gs_font_small, vector(x/62 + 38, y/1.43 + 73 - gap), color(r, g, b, 255), nil, text)
                render.texture(icon, vector(x/62, y/1.43 - gap + 68), vector(32,28), color(r, g, b, 255), f, 0)
                render.circle_outline(vector(x/62 + 70, y/1.43 + 82 - gap), color(10,10,10,255), 9, 0, 1, 5)
                render.circle_outline(vector(x/62 + 70, y/1.43 + 82 - gap), color(200,200,200), 8, 0, time, 3)
            elseif icon ~= nil and time == nil then
                render.gradient(vector(x/40, y/1.43 + 68 - gap), vector(x/40 + measure_text.x, y/1.43 + 95 - gap), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), 0)
                render.gradient(vector(x/40 - 45, y/1.43 + 68 - gap), vector(x/40, y/1.43 + 95 - gap), color(0,0,0,0), color(0,0,0,50), color(0,0,0,0), color(0,0,0,50), 0)
                render.text(redrum.font.gs_font_small, vector(x/62 + 38, y/1.43 + 73 - gap), color(r, g, b, 255), nil, text)
                render.texture(icon, vector(x/62, y/1.43 - gap + 68), vector(32,28), color(r, g, b, 255), f, 0)
            end
        end
    end,
    ang_vec = function(ang) 
        return vector(math.cos(ang.x * math.pi / 180) * math.cos(ang.y * math.pi / 180), math.cos(ang.x * math.pi / 180) * math.sin(ang.y * math.pi / 180), -math.sin(ang.x * math.pi / 180))
    end,
    luatag_anim = function(text, indices) if not globals.is_connected then return end local text_anim = '               ' .. text .. '               '  local tickinterval = globals.tickinterval local tickcount = globals.tickcount + math.floor(utils.net_channel().avg_latency[0]+0.22 / globals.tickinterval + 0.5) local i = tickcount / math.floor(0.3 / globals.tickinterval + 0.5) i = math.floor(i % #indices) i = indices[i+1]+1 return string.sub(text_anim, i, i+15) end,
    trace = function(arg)
        local max_radias = math.pi * 2
        local step = max_radias / 8
        local x, y, z = entity.get_local_player()["m_vecOrigin"].x, entity.get_local_player()["m_vecOrigin"].y, entity.get_local_player()["m_vecOrigin"].z
    
        for a = 0, max_radias, step do
            local ptX, ptY = ((10 * math.cos( a ) ) + x), ((10 * math.sin( a ) ) + y)
            local trace = utils.trace_line(vector(ptX, ptY, z), vector(ptX, ptY, z-arg), entity.get_local_player())
            local fraction, entity = trace.fraction, trace.entity
    
            if fraction~=1 then 
                return true
            end
        end
        return false
    end,
    dist_to_2d = function(vec1, vec2)
        return math.sqrt(math.pow(vec1.x - vec2.x, 2) + math.pow(vec1.y - vec2.y, 2))
    end,
}

local rui = {
    tab_select = redrum.groups.selection:list("", "\v\f<shield>  \rAnti Aim", "\v›  \rVisuals"),
}
local antiaim = {
    Convert = {
        ["S"] = 1,
        ["W"] = 2,
        ["SW"] = 3,
        ["C"] = 4,
        ["A"] = 5,
        ["AC"] = 6,
        ["NE"] = 7,
    },
    slowyaw_invert = false,
    breaklc_counter = 0,
    breaklc_check = false,
    ground_ticks = 0,
    menu = function(self)
        self.player_states = {"Standing", "Walking", "Slow Walk", "Crouch", "Air", "Air+Duck", "Fakelag"}
        self.player_states_idx = {["Standing"] = 1, ["Walking"] = 2, ["Slow Walk"] = 3, ["Crouch"] = 4, ["Air"] = 5, ["Air+Duck"] = 6, ["Fakelag"] = 7}
        self.player_states_idx_r = {[1] = "Standing", [2] = "Walking", [3] = "Slow Walk", [4] = "Crouch", [5] = "Air", [6] = "Air+Duck", [7] = "Fakelag"}
        self.options = {}
        self.bodyyaw = {}
        self.defensive = {}

        self.selection = redrum.groups.antiaim.selection:list("", "\v›  \rBuilder", "\v›  \rAdditionals")
        self.additionals = {
            manualyaw = redrum.groups.antiaim.additionals:combo("\v\f<code>   \rManual Yaw", "Disabled", "Left", "Right"),
            safehead = redrum.groups.antiaim.additionals:selectable("\v\f<shield>     \rSafe Head", "Standing", "Walking", "Slow Walk", "Crouch", "Air", "Air+Duck", "Fakelag"),
            tweaks = redrum.groups.antiaim.additionals:selectable("\v\f<wand-magic-sparkles>    \rTweaks", "Avoid Backstab", "Break LC in air", "Force Defensive"),
            animbuilder = redrum.groups.antiaim.additionals:switch("\v\f<person-running>      \rAnim. Builder"),
        }
        self.tweaks_group = {
            defensivestate = self.additionals.tweaks:create():selectable("Defensive when", "Standing", "Walking", "Slow Walk", "Crouch", "Air", "Air+Duck", "Fakelag"),
        }
        self.animbuilder_group = {
            legsonground = self.additionals.animbuilder:create():combo("Legs on ground", "Disabled", "Static", "Moon Walk", "Jitter"),
            legsinair = self.additionals.animbuilder:create():combo("Legs in air", "Disabled", "Allah", "Static", "Jitter"),
            bodylean = self.additionals.animbuilder:create():slider("Body lean", 0, 100, 0, 1, "%"),
            pitchzero = self.additionals.animbuilder:create():switch("Pitch 0 on land"),
        }
        self.builder = {
            state = redrum.groups.antiaim.builder:combo("\v[  \f<user>  ] \r Condition", self.player_states)
        }
        for i = 1,7 do 
            self.options[i] = {
                pitch = redrum.groups.antiaim.builder:combo("\v["..self.player_states_idx_r[i].."] \rPitch", "Down", "Up", "Zero"),
                yawmode = redrum.groups.antiaim.builder:combo("\v["..self.player_states_idx_r[i].."] \rYaw Mode", "Left & Right", "Tick Switcher"),
                yawleft = redrum.groups.antiaim.builder:slider("\v["..self.player_states_idx_r[i].."] \rYaw Left", -180, 180, 0),
                yawright = redrum.groups.antiaim.builder:slider("\v["..self.player_states_idx_r[i].."] \rYaw Right", -180, 180, 0),
                switchdelay = redrum.groups.antiaim.builder:slider("\v["..self.player_states_idx_r[i].."] \rDelay", 2, 20, 8, "t"),
                jittertype = redrum.groups.antiaim.builder:combo("\v["..self.player_states_idx_r[i].."] \rJitter Type", "Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"),
                jitteroffset = redrum.groups.antiaim.builder:slider("\v["..self.player_states_idx_r[i].."] \rOffset", -180, 180, 0),
                bodyyaw = redrum.groups.antiaim.builder:switch("\v["..self.player_states_idx_r[i].."] \rBody Yaw"),
                defensive = redrum.groups.antiaim.builder:switch("\v["..self.player_states_idx_r[i].."] \rDefensive"),
            }
            local bodyyaw_options = self.options[i].bodyyaw:create()
            self.bodyyaw[i] = {
                desyncleft = bodyyaw_options:slider("Left limit", 0, 60, 60),
                desyncright = bodyyaw_options:slider("Right limit", 0, 60, 60),
                options = bodyyaw_options:selectable("Options", "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"),
                freestanding = bodyyaw_options:combo("Freestanding", "Off", "Peek Fake", "Peek Real"),
            }
            local defensive_options = self.options[i].defensive:create()
            self.defensive[i] = {
                speed = defensive_options:slider("Speed", 1, 12, 6),
                pitch = defensive_options:combo("Pitch", "Up", "Down", "Zero", "Random", "Custom"),
                pitch_value = defensive_options:slider("Pitch Value", -89, 89, 0, "°"),
                yaw = defensive_options:combo("Yaw", "Spin", "Random", "Sideway", "Custom"),
                yaw_value = defensive_options:slider("Yaw Value", -180, 180, 0, "°"),
            }
        end
    end,

    breaklc = function(self, cmd)
        if self.additionals.tweaks:get("Break LC in air") and entity.get_threat(true) ~= nil and redrum.vars.refs.doubletap:get() then
            if self.breaklc_check == false and (self.Convert[mtools.AntiAims.Condition:Get()] == 5 or self.Convert[mtools.AntiAims.Condition:Get()] == 6) and (functions.get_air(entity.get_threat(true)) == false) and ((entity.get_threat(true):get_player_weapon():get_weapon_reload()) == -1) then
                self.breaklc_counter = self.breaklc_counter + 1
                if self.breaklc_counter == math.random(5,8) then
                    rage.exploit:force_teleport()
                elseif self.breaklc_counter > math.random(5,8) then
                    rage.exploit:force_charge()
                    self.breaklc_check = true
                end
            else
                self.breaklc_counter = 0
                rage.exploit:force_charge()
            end
        else
            self.breaklc_check = false
        end
    end,

    pitch_0_ticks = function(self, cmd)
        if self.ground_ticks >= 0 then
            if self.Convert[mtools.AntiAims.Condition:Get()] == 5 or self.Convert[mtools.AntiAims.Condition:Get()] == 6 then
                self.ground_ticks = 0
            else
                self.ground_ticks = self.ground_ticks + 1
            end
        end
    end,

    animbuilder = function(self)
        if not self.additionals.animbuilder:get() then
            return
        end

        local local_player = entity.get_local_player()

        if local_player == nil then
            return
        end  

        if not local_player:is_alive() then
            return
        end 

        local local_player_ptr = get_entity_address(local_player:get_index())
        if self.Convert[mtools.AntiAims.Condition:Get()] ~= 5 and self.Convert[mtools.AntiAims.Condition:Get()] ~= 6 and self.Convert[mtools.AntiAims.Condition:Get()] ~= 1 then
            if self.animbuilder_group.legsonground:get() == "Static" then
                ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override('sliding')
                local_player.m_flPoseParameter[0] = 1
            elseif self.animbuilder_group.legsonground:get() == "Moon Walk" then
                ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override('walking')
                local_player.m_flPoseParameter[7] = 0
            elseif self.animbuilder_group.legsonground:get() == "Jitter" then
                ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override('sliding')
                local_player.m_flPoseParameter[0] = utils.random_float(0.08,1)
                if self.Convert[mtools.AntiAims.Condition:Get()] ~= 7 then
                    local_player.m_flPoseParameter[14] = utils.random_float(0.08,1)
                end
            end
            if self.animbuilder_group.pitchzero:get() and self.ground_ticks > 0 and self.ground_ticks < 50 then
                local_player.m_flPoseParameter[12] = 0.5
            end
        end
        if self.Convert[mtools.AntiAims.Condition:Get()] == 5 or self.Convert[mtools.AntiAims.Condition:Get()] == 6 then
            if self.animbuilder_group.legsinair:get() == "Static" then
                ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override('sliding')
                local_player.m_flPoseParameter[6] = 1
            elseif self.animbuilder_group.legsinair:get() == "Allah" then
                ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override('walking')
                functions.get_anim_layer(local_player_ptr, 6).m_flWeight = 1
            elseif self.animbuilder_group.legsinair:get() == "Jitter" then
                ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override('sliding')
                local_player.m_flPoseParameter[6] = (globals.tickcount % 3 > 1 and 0 or 1)
            end
        end
        functions.get_anim_layer(local_player_ptr, 12).m_flWeight = self.animbuilder_group.bodylean:get()/100
    end,

    main = function(self, cmd)
        local local_player = entity.get_local_player()

        if local_player == nil then
            return
        end  

        if not local_player:is_alive() then
            return
        end 

        redrum.vars.refs.antiuntrusted:override(true)
        redrum.vars.refs.avoidbackstab:override(self.additionals.tweaks:get("Avoid Backstab"))
        for i = 1, 7 do
            if self.additionals.safehead:get() ~= nil then
                if self.additionals.safehead:get()[i] == self.player_states_idx_r[self.Convert[mtools.AntiAims.Condition:Get()]] and (functions.get_player_active_weapon(local_player) == 'CWeaponTaser' or functions.get_player_active_weapon(local_player) == 'CKnife') then
                    redrum.vars.refs.pitch:override("Down")
                    redrum.vars.refs.yaw:override("Backward")
                    redrum.vars.refs.yawbase:override("Local View")
                    redrum.vars.refs.yawmodifier:override("Disabled")
                    redrum.vars.refs.yawoffset:override(0)
                    redrum.vars.refs.yawmodifieroffset:override(0)
                    redrum.vars.refs.bodyyaw:override(false)
                    redrum.vars.refs.hidden:override(false) 
                    return
                end
            end
        end

        if self.additionals.manualyaw:get() ~= "Disabled" then
            if self.additionals.manualyaw:get() == "Right" then
                redrum.vars.refs.yawoffset:override(90)
            elseif self.additionals.manualyaw:get() == "Left" then
                redrum.vars.refs.yawoffset:override(-90)
            end
            redrum.vars.refs.pitch:override("Down")
            redrum.vars.refs.yaw:override("Backward")
            redrum.vars.refs.yawbase:override("Local View")
            redrum.vars.refs.yawmodifier:override("Disabled")
            redrum.vars.refs.bodyyaw:override(true)
            redrum.vars.refs.bodyyaw_options:override("")
            redrum.vars.refs.bodyyaw_leftlimit:override(60)
            redrum.vars.refs.bodyyaw_rightlimit:override(60)
            redrum.vars.refs.hidden:override(false) 
            return
        end

        redrum.vars.refs.lagoptions:override(redrum.vars.refs.lagoptions:get())
        redrum.vars.refs.hideshotsoptions:override(redrum.vars.refs.hideshotsoptions:get())
        rage.exploit:allow_defensive(false)
        redrum.vars.refs.immediateteleport:override(redrum.vars.refs.immediateteleport:get())

        for i = 1, 7 do
            if self.additionals.tweaks:get("Force Defensive") then
                if self.tweaks_group.defensivestate:get()[i] == self.player_states_idx_r[self.Convert[mtools.AntiAims.Condition:Get()]] then
                    redrum.vars.refs.lagoptions:override("Always On")
                    redrum.vars.refs.hideshotsoptions:override("Break LC")
                    rage.exploit:allow_defensive(true)
                    redrum.vars.refs.immediateteleport:override(false)
                end
            end
        end

        redrum.vars.refs.yawbase:override("At Target")
        redrum.vars.refs.pitch:override(self.options[self.Convert[mtools.AntiAims.Condition:Get()]].pitch:get() ~= "Down" and (self.options[self.Convert[mtools.AntiAims.Condition:Get()]].pitch:get() == "Up" and "Fake Up" or "Disabled") or "Down")
        redrum.vars.refs.yawmodifier:override(self.options[self.Convert[mtools.AntiAims.Condition:Get()]].jittertype:get())
        redrum.vars.refs.yawmodifieroffset:override(self.options[self.Convert[mtools.AntiAims.Condition:Get()]].jitteroffset:get())
        redrum.vars.refs.bodyyaw:override(self.options[self.Convert[mtools.AntiAims.Condition:Get()]].bodyyaw:get())
        redrum.vars.refs.bodyyaw_leftlimit:override(self.bodyyaw[self.Convert[mtools.AntiAims.Condition:Get()]].desyncleft:get())
        redrum.vars.refs.bodyyaw_rightlimit:override(self.bodyyaw[self.Convert[mtools.AntiAims.Condition:Get()]].desyncright:get())
        redrum.vars.refs.bodyyaw_options:override(self.bodyyaw[self.Convert[mtools.AntiAims.Condition:Get()]].options:get())
        redrum.vars.refs.bodyyaw_freestanding:override(self.bodyyaw[self.Convert[mtools.AntiAims.Condition:Get()]].freestanding:get())
        if self.options[self.Convert[mtools.AntiAims.Condition:Get()]].yawmode:get() == "Left & Right" then
            redrum.vars.refs.yawoffset:override(functions:player_invert() and self.options[self.Convert[mtools.AntiAims.Condition:Get()]].yawright:get() or self.options[self.Convert[mtools.AntiAims.Condition:Get()]].yawleft:get())
        elseif self.options[self.Convert[mtools.AntiAims.Condition:Get()]].yawmode:get() == "Tick Switcher" then 
            if globals.tickcount % (self.options[self.Convert[mtools.AntiAims.Condition:Get()]].switchdelay:get() * 2) == 0 then self.slowyaw_invert = not self.slowyaw_invert end
            redrum.vars.refs.bodyyaw_invert:override(self.slowyaw_invert)
            redrum.vars.refs.bodyyaw_options:override("")
            redrum.vars.refs.yawmodifieroffset:override(self.options[self.Convert[mtools.AntiAims.Condition:Get()]].jitteroffset:get())
            redrum.vars.refs.yawoffset:override((self.slowyaw_invert and self.options[self.Convert[mtools.AntiAims.Condition:Get()]].yawleft:get() or self.options[self.Convert[mtools.AntiAims.Condition:Get()]].yawright:get()))
        end
        if self.options[self.Convert[mtools.AntiAims.Condition:Get()]].defensive:get() and (redrum.vars.refs.doubletap:get() or redrum.vars.refs.hideshots:get()) then
            redrum.vars.refs.hidden:override(true) 
            if self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].pitch:get() == "Up" then
                rage.antiaim:override_hidden_pitch(-89)
            elseif self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].pitch:get() == "Down" then
                rage.antiaim:override_hidden_pitch(89)
            elseif self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].pitch:get() == "Zero" then
                rage.antiaim:override_hidden_pitch(0)
            elseif self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].pitch:get() == "Random" then
                rage.antiaim:override_hidden_pitch(utils.random_int(-89,89))
            elseif self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].pitch:get() == "Custom" then
                rage.antiaim:override_hidden_pitch(-self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].pitch_value:get())
            end
            if self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].yaw:get() == "Custom" then
                rage.antiaim:override_hidden_yaw_offset(self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].yaw_value:get())
            elseif self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].yaw:get() == "Spin" then
                rage.antiaim:override_hidden_yaw_offset(globals.tickcount*(self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].speed:get()*5) % 360)
            elseif self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].yaw:get() == "Random" then
                rage.antiaim:override_hidden_yaw_offset(utils.random_int(-180,180))
            elseif self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].yaw:get() == "Sideway" then
                rage.antiaim:override_hidden_yaw_offset(globals.tickcount*(self.defensive[self.Convert[mtools.AntiAims.Condition:Get()]].speed:get()*5) % 360 > 180 and -90 or 90)
            end
        else
            redrum.vars.refs.hidden:override(false) 
        end
        mtools.AntiAims.Condition:Update()
    end,
}

antiaim:menu()

local aimbot_stats = { all_shots = {0}, hit = {0}, mis = {0} }
events.aim_ack:set(function(e) if e.state == nil then aimbot_stats.hit[1] = aimbot_stats.hit[1] + 1 aimbot_stats.all_shots[1] = aimbot_stats.all_shots[1] + 1 elseif e.state ~= nil then aimbot_stats.all_shots[1] = aimbot_stats.all_shots[1] + 1 end end)

local visuals = {
    menu = function(self)
        self.eventlogger_array = {}
        self.eventlogger_hitgroups = {[0] = 'body', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', 'generic', 'gear'}
        self.selection = redrum.groups.visuals.selection:list("", "\v›  \rScreen", "\v›  \rIn Game")
        self.accentcolor = redrum.groups.visuals.selection:color_picker("\v\f<palette>   \rAccent Color", color(225,155,155,255))

        self.screen = {
            crosshairindicator = redrum.groups.visuals.screen:switch("\v\f<display>   \rCrosshair Indicator"),
            damageoverride = redrum.groups.visuals.screen:switch("\v\f<lemon>     \rDamage Override"),
            manualarrows = redrum.groups.visuals.screen:switch("\v\f<arrows-repeat>    \rManual Arrows"),
            customscope = redrum.groups.visuals.screen:switch("\v\f<crosshairs>    \rCustom Scope"),
            eventlogger = redrum.groups.visuals.screen:switch("\v\f<sparkles>    \rEvent logger"),
            widgets = redrum.groups.visuals.screen:switch("\v\f<keyboard>    \rWidgets"),
            gamesenseindicator = redrum.groups.visuals.screen:switch("\v\f<sack-dollar>    \rGame\a96C83CFFSense \rIndicator"),
        }

        self.screen_group = {
            customscope = {
                color = self.screen.customscope:create():color_picker("Color", color(255, 255, 255, 255)),
                length = self.screen.customscope:create():slider("Length", 0, 300, 150),
                gap = self.screen.customscope:create():slider("Gap", 0, 300, 15),
            },
            eventlogger = {
                selecttoshow = self.screen.eventlogger:create():selectable("", "Under Crosshair", "Console", "Upper-Left"),
                trigger = self.screen.eventlogger:create():selectable("Trigger", "Enemy hit", "Enemy miss", "Purchases"),
                hitcolor = self.screen.eventlogger:create():color_picker("Hit color", color(150,200,60,255)),
                misscolor = self.screen.eventlogger:create():color_picker("Miss color", color(215,100,100,255)),
                buycolor = self.screen.eventlogger:create():color_picker("Purchases color", color(135,160,200,255)),
            },
            damageoverride = {
                x = self.screen.damageoverride:create():slider("dmg_x", 0, render.screen_size().x, render.screen_size().x - (render.screen_size().x/2)),
                y = self.screen.damageoverride:create():slider("dmg_y", 0, render.screen_size().y, render.screen_size().y - (render.screen_size().y/2) - 22),
            },
            gamesenseindicator = {
                animation = self.screen.gamesenseindicator:create():switch("Animation"),
                scale = self.screen.gamesenseindicator:create():combo("Scale", "100%", "75%"),
                select = self.screen.gamesenseindicator:create():listable("", "Dormant", "Double tap", "Ping spike", "On shot anti-aim", "Freestanding", "Duck peek assist", "Minimum damage override", "Bomb info", "Force safe points", "Force body aim", "Aimbot stats", "Spectators"),
            },
            widgets = {
                select = self.screen.widgets:create():listable("", "Watermark", "Infopanel", "Defensive", "Slowdown"),
                infopanel_x = self.screen.widgets:create():slider("infopanel_x", 0, render.screen_size().x, render.screen_size().x - (render.screen_size().x) + 10),
                infopanel_y = self.screen.widgets:create():slider("infopanel_y", 0, render.screen_size().y, render.screen_size().y - render.screen_size().y + 500),
                defensive_x = self.screen.widgets:create():slider("defensive_x", 0, render.screen_size().x, render.screen_size().x - (render.screen_size().x/2) - 50),
                defensive_y = self.screen.widgets:create():slider("defensive_y", 0, render.screen_size().y, render.screen_size().y - render.screen_size().y + 100),
                velocity_x = self.screen.widgets:create():slider("velocity_x", 0, render.screen_size().x, render.screen_size().x - (render.screen_size().x/2) - 50),
                velocity_y = self.screen.widgets:create():slider("velocity_y", 0, render.screen_size().y, render.screen_size().y - render.screen_size().y + 200),
            }
        }

        self.screen.widgets:tooltip("Press M2 to reset\nPress M3 to center")

        self.ingame = {
            aspectratio = redrum.groups.visuals.ingame:switch("\v\f<screencast>   \rAspect Ratio"),
            viewmodel = redrum.groups.visuals.ingame:switch("\v\f<hand>    \rViewmodel"),
            naderadius = redrum.groups.visuals.ingame:switch("\v\f<bomb>    \rNade radius"),
        }

        self.ingame_group = {
            viewmodel = {
                fov = self.ingame.viewmodel:create():slider("Fov", -100, 100, 68),
                x = self.ingame.viewmodel:create():slider("X", -10, 10, 1),
                y = self.ingame.viewmodel:create():slider("Y", -10, 10, 0),
                z = self.ingame.viewmodel:create():slider("Z", -10, 10, -2),
            },
            aspectratio = {
                value = self.ingame.aspectratio:create():slider("Value", 100, 200, 178, 0.01, ""),
                _54 = self.ingame.aspectratio:create():button("5:4", function()
                    self.ingame_group.aspectratio.value:set(125)
                end, true),
                _43 = self.ingame.aspectratio:create():button("4:3", function()
                    self.ingame_group.aspectratio.value:set(133)
                end, true),
                _32 = self.ingame.aspectratio:create():button("3:2", function()
                    self.ingame_group.aspectratio.value:set(150)
                end, true),
                _1610 = self.ingame.aspectratio:create():button("16:10", function()
                    self.ingame_group.aspectratio.value:set(160)
                end, true),
                _169 = self.ingame.aspectratio:create():button("16:9", function()
                    self.ingame_group.aspectratio.value:set(178)
                end, true),
                _21 = self.ingame.aspectratio:create():button("2:1", function()
                    self.ingame_group.aspectratio.value:set(200)
                end, true),
            },
            naderadius = {
                select = self.ingame.naderadius:create():selectable("Options","Molotov","Smoke"),
                molotov = self.ingame.naderadius:create():color_picker("Molotov Color", color(255, 63, 63, 190)),
                smoke = self.ingame.naderadius:create():color_picker("Smoke Color", color(61, 147, 250, 180)),
            },
        }
    end,

    eventlogger_hit = function(self, e)
        if not self.screen.eventlogger:get() then
            return
        end

        if not self.screen_group.eventlogger.trigger:get("Enemy hit") then
            return
        end

        local local_player = entity.get_local_player()

        if not local_player then
            return
        end

        local attacker = entity.get(e.attacker, true)
        local target = entity.get(e.userid, true)
        local hitgroup = self.eventlogger_hitgroups[e.hitgroup]
        local hc = self.screen_group.eventlogger.hitcolor:get()
        local prefix = string.format('\a%sredrum \aFFFFFFFF·', hc:to_hex())
        
        if local_player == attacker and attacker:get_name() ~= target:get_name() then
            if self.screen_group.eventlogger.selecttoshow:get("Console") then
                print_raw(string.format("%s \aE7E7E7FFHit \a%s%s \aE7E7E7FFin the \a%s%s \aE7E7E7FFfor \a%s%s \aE7E7E7FFdamage (\a%s%s\aE7E7E7FF)", prefix, hc:to_hex(), string.sub(target:get_name(), 1, 8), hc:to_hex(), hitgroup, hc:to_hex(), e.dmg_health, hc:to_hex(), (e.health == 0 and "dead" or e.health.." \aE7E7E7FFhealth remaining")))
            end
            if self.screen_group.eventlogger.selecttoshow:get("Upper-Left") then
                print_dev(string.format("\aE7E7E7FFHit \a%s%s \aE7E7E7FFin the \a%s%s \aE7E7E7FFfor \a%s%s \aE7E7E7FFdamage (\a%s%s\aE7E7E7FF)", hc:to_hex(), string.sub(target:get_name(), 1, 8), hc:to_hex(), hitgroup, hc:to_hex(), e.dmg_health, hc:to_hex(), (e.health == 0 and "dead" or e.health.." \aE7E7E7FFhealth remaining")))
            end
            if self.screen_group.eventlogger.selecttoshow:get("Under Crosshair") then
                self.eventlogger_array[#self.eventlogger_array+1] = {string.format("\a%sHit \a%s%s\aFFFFFFFF's \a%s%s \aFFFFFFFFfor \a%s%s \aFFFFFFFFdamage", "FFFFFFFF", hc:to_hex(), string.sub(target:get_name(), 1, 8), hc:to_hex(), hitgroup, hc:to_hex(), e.dmg_health), globals.tickcount + 300, 0, 'Hit'} 
            end
        end
    end,

    eventlogger_miss = function(self, e)
        if not self.screen.eventlogger:get() then
            return
        end

        if not self.screen_group.eventlogger.trigger:get("Enemy miss") then
            return
        end

        local local_player = entity.get_local_player()

        if not local_player then
            return
        end

        local attacker = entity.get(e.attacker, true)
        local target = e.target
        local hitgroup = self.eventlogger_hitgroups[e.wanted_hitgroup]
        local mc = self.screen_group.eventlogger.misscolor:get()

        local prefix = string.format('\a%sredrum \aFFFFFFFF·', mc:to_hex())

        if e.state ~= nil then
            if self.screen_group.eventlogger.selecttoshow:get("Console") then
                print_raw(string.format("%s \aE7E7E7FFMissed shot at \a%s%s \aE7E7E7FFin the \a%s%s \aE7E7E7FFdue to \a%s%s", prefix, mc:to_hex(), string.sub(target:get_name(), 1, 8), mc:to_hex(), hitgroup, mc:to_hex(), e.state))
            end
            if self.screen_group.eventlogger.selecttoshow:get("Upper-Left") then
                print_dev(string.format("\aE7E7E7FFMissed shot at \a%s%s \aE7E7E7FFin the \a%s%s \aE7E7E7FFdue to \a%s%s", mc:to_hex(), string.sub(target:get_name(), 1, 8), mc:to_hex(), hitgroup, mc:to_hex(), e.state))
            end
            if self.screen_group.eventlogger.selecttoshow:get("Under Crosshair") then
                self.eventlogger_array[#self.eventlogger_array+1] = {string.format("\a%sMissed \a%s%s\aFFFFFFFF's \a%s%s \aFFFFFFFFdue to \a%s%s", "FFFFFFFF", mc:to_hex(), string.sub(target:get_name(), 1, 8), mc:to_hex(), hitgroup, mc:to_hex(), e.state), globals.tickcount + 300, 0, 'Miss'} 
            end
        end
   
    end,

    eventlogger_purchases = function(self, e)
        if not self.screen.eventlogger:get() then
            return
        end

        if not self.screen_group.eventlogger.trigger:get("Purchases") then
            return
        end

        local local_player = entity.get_local_player()

        if not local_player then
            return
        end
        
        local name = entity.get(e.userid, true):get_name() or "?"
        local weapon = e.weapon or "weapon_unknown"
        local bc = self.screen_group.eventlogger.buycolor:get()
        
        local prefix = string.format('\a%sredrum \aFFFFFFFF·', bc:to_hex())
    
        if weapon == "unknown" then
            return
        elseif weapon == "item_assaultsuit" then
            weapon = "Kevlar + Helmet"
        elseif weapon == "item_kevlar" then
            weapon = "Kevlar"
        end
    
        if string.sub(weapon, 1,7) == "weapon_" then
            if weapon == "weapon_usp_silencer" then
                weapon = "Usp"
            elseif weapon == "weapon_m4a1_silencer" then
                weapon = "M4a1-S"
            elseif weapon == "weapon_awp" then
                weapon = "AWP"
            elseif weapon == "weapon_ssg08" then
                weapon = "Scout"
            elseif weapon == "weapon_smokegrenade" then
                weapon = "Smoke"
            elseif weapon == "weapon_hegrenade" then
                weapon = "Exploding granade"
            elseif weapon == "weapon_incgrenade" or weapon == "weapon_molotov" then
                weapon = "Molotov"
            else
                weapon = mtools.String.FirstUpper(string.sub(weapon, 8,1000));
            end
        end

        if self.screen_group.eventlogger.selecttoshow:get("Console") then
            print_raw(string.format("%s \aE7E7E7FFPlayer \a%s%s \aE7E7E7FFbought \a%s%s", prefix, bc:to_hex(), name, bc:to_hex(), weapon))
        end
        if self.screen_group.eventlogger.selecttoshow:get("Upper-Left") then
            print_dev(string.format("\aE7E7E7FFPlayer \a%s%s \aE7E7E7FFbought \a%s%s", bc:to_hex(), name, bc:to_hex(), weapon))
        end
        if self.screen_group.eventlogger.selecttoshow:get("Under Crosshair") then
            self.eventlogger_array[#self.eventlogger_array+1] = {string.format("\a%sPlayer \a%s%s\aFFFFFFFF bought \a%s%s", "FFFFFFFF", bc:to_hex(), name, bc:to_hex(), weapon), globals.tickcount + 300, 0, 'Buy'} 
        end
    end,

    eventlogger_draw = function(self)
        if not self.screen.eventlogger:get() then
            return
        end

        if not self.screen_group.eventlogger.selecttoshow:get("Under Crosshair") then
            return
        end

        local local_player = entity.get_local_player()

        if not local_player then
            return
        end
        
        local xv, xy = render.screen_size().x, render.screen_size().y

        if entity.get_local_player() == nil then
            table.remove(self.eventlogger_array, #self.eventlogger_array)
        end
    
        if not globals.is_in_game then return end

        if #self.eventlogger_array > 0 then
            if globals.tickcount >= self.eventlogger_array[1][2] then
                if self.eventlogger_array[1][3] > 0 then
                    self.eventlogger_array[1][3] = self.eventlogger_array[1][3] - 20
                elseif self.eventlogger_array[1][3] <= 0 then
                    table.remove(self.eventlogger_array, 1)
                end
            end
            if #self.eventlogger_array > 6 then
                table.remove(self.eventlogger_array, 1)
            end

            for i = 1, #self.eventlogger_array do
                text_size = render.measure_text(1, nil, self.eventlogger_array[i][1]).x
                if self.eventlogger_array[i][3] < 255 then 
                    self.eventlogger_array[i][3] = self.eventlogger_array[i][3] + 10
                end
                local checkstring = string.sub(self.eventlogger_array[i][1], 10, 12)
                local ts = render.measure_text(1, nil, self.eventlogger_array[i][1])
                if checkstring == "Hit" then
                    render.rect(vector(xv/2 - ts.x/2 - 19, xy - 260 + (self.eventlogger_array[i][3]/45) + 25 * i), vector(xv/2 - ts.x/2 + 2, xy - 240 + (self.eventlogger_array[i][3]/45) + 25 * i), color(15,15,15,self.eventlogger_array[i][3] - 105), 4)
                    render.rect(vector(xv/2 - ts.x/2 + 5, xy - 260 + (self.eventlogger_array[i][3]/45) + 25 * i), vector(xv/2 - ts.x/2 + ts.x + 18, xy - 240 + (self.eventlogger_array[i][3]/45) + 25 * i), color(15,15,15,self.eventlogger_array[i][3] - 105), 4)
                    render.text(1, vector(xv/2 - ts.x/2 + 12, xy - 257 + (self.eventlogger_array[i][3]/45) + 25 * i), color(255, 255, 255, self.eventlogger_array[i][3]), nil, self.eventlogger_array[i][1])
                    render.text(redrum.font.eventlogger, vector(xv/2 - ts.x/2 - 15, xy - 258 + (self.eventlogger_array[i][3]/45) + 25 * i), color(self.screen_group.eventlogger.hitcolor:get().r, self.screen_group.eventlogger.hitcolor:get().g, self.screen_group.eventlogger.hitcolor:get().b, self.eventlogger_array[i][3]), nil, pui.string("\f<crosshairs>"))
                elseif checkstring == "Mis" then
                    render.rect(vector(xv/2 - ts.x/2 - 19, xy - 260 + (self.eventlogger_array[i][3]/45) + 25 * i), vector(xv/2 - ts.x/2 + 2, xy - 240 + (self.eventlogger_array[i][3]/45) + 25 * i), color(15,15,15,self.eventlogger_array[i][3] - 105), 4)
                    render.rect(vector(xv/2 - ts.x/2 + 5, xy - 260 + (self.eventlogger_array[i][3]/45) + 25 * i), vector(xv/2 - ts.x/2 + ts.x + 18, xy - 240 + (self.eventlogger_array[i][3]/45) + 25 * i), color(15,15,15,self.eventlogger_array[i][3] - 105), 4)
                    render.text(1, vector(xv/2 - ts.x/2 + 12, xy - 257 + (self.eventlogger_array[i][3]/45) + 25 * i), color(255, 255, 255, self.eventlogger_array[i][3]), nil, self.eventlogger_array[i][1])
                    render.text(redrum.font.eventlogger, vector(xv/2 - ts.x/2 - 15, xy - 258 + (self.eventlogger_array[i][3]/45) + 25 * i), color(self.screen_group.eventlogger.misscolor:get().r, self.screen_group.eventlogger.misscolor:get().g, self.screen_group.eventlogger.misscolor:get().b, self.eventlogger_array[i][3]), nil, pui.string("\f<circle-xmark>"))
                elseif checkstring == "Pla" then
                    render.rect(vector(xv/2 - ts.x/2 - 19, xy - 260 + (self.eventlogger_array[i][3]/45) + 25 * i), vector(xv/2 - ts.x/2 + 2, xy - 240 + (self.eventlogger_array[i][3]/45) + 25 * i), color(15,15,15,self.eventlogger_array[i][3] - 105), 4)
                    render.rect(vector(xv/2 - ts.x/2 + 5, xy - 260 + (self.eventlogger_array[i][3]/45) + 25 * i), vector(xv/2 - ts.x/2 + ts.x + 18, xy - 240 + (self.eventlogger_array[i][3]/45) + 25 * i), color(15,15,15,self.eventlogger_array[i][3] - 105), 4)
                    render.text(1, vector(xv/2 - ts.x/2 + 12, xy - 257 + (self.eventlogger_array[i][3]/45) + 25 * i), color(255, 255, 255, self.eventlogger_array[i][3]), nil, self.eventlogger_array[i][1])
                    render.text(redrum.font.eventlogger, vector(xv/2 - ts.x/2 - 16, xy - 258 + (self.eventlogger_array[i][3]/45) + 25 * i), color(self.screen_group.eventlogger.buycolor:get().r, self.screen_group.eventlogger.buycolor:get().g, self.screen_group.eventlogger.buycolor:get().b, self.eventlogger_array[i][3]), nil, pui.string("\f<basket-shopping>"))
                end
            end
        end
    end,


    gamesenseindicator = function(self)
        if not self.screen.gamesenseindicator:get() then
            return
        end

        local local_player = entity.get_local_player()

        if local_player == nil then
            return
        end  

        if not local_player:is_alive() then
            return
        end  

        mtools.Animation:Register("MTools_gsindicators");

        local scale = (self.screen_group.gamesenseindicator.scale:get() == "100%" and 42 or 36)
        local bombicon = redrum.vars.c4_icon
        local indicators_spacing = 0
        local all_players = entity.get_players(true, true)

        if self.screen_group.gamesenseindicator.select:get(11) then
            indicators_spacing = indicators_spacing + scale
            local aimbotstats_y = mtools.Animation:Lerp("MTools_gsindicators", "aimbotstats_y", self.screen_group.gamesenseindicator.select:get(11), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            if aimbot_stats.hit[1] == 0 and aimbot_stats.all_shots[1] == 0 then
                functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and aimbotstats_y.y - scale or indicators_spacing), "0/0 (0%)", nil, nil, 200,200,200, self.screen_group.gamesenseindicator.scale:get())
            else
                functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and aimbotstats_y.y - scale or indicators_spacing), aimbot_stats.hit[1].."/"..aimbot_stats.all_shots[1].." ("..math.floor((aimbot_stats.hit[1]/aimbot_stats.all_shots[1])*100).."%)", nil, nil, 200,200,200, self.screen_group.gamesenseindicator.scale:get())
            end
        else
            indicators_spacing = indicators_spacing + scale
            local aimbotstats_y = mtools.Animation:Lerp("MTools_gsindicators", "aimbotstats_y", self.screen_group.gamesenseindicator.select:get(11), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            indicators_spacing = indicators_spacing - scale
        end

        if self.screen_group.gamesenseindicator.select:get(3) and redrum.vars.refs.fakeping:get() > 0 then
            indicators_spacing = indicators_spacing + scale
            local ping_y = mtools.Animation:Lerp("MTools_gsindicators", "ping_y", redrum.vars.refs.fakeping:get() > 0, vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            if redrum.vars.refs.fakeping:get() >= 68 then
                functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and ping_y.y - scale or indicators_spacing), "PING", nil, nil, (223 - redrum.vars.refs.fakeping:get()),155,36, self.screen_group.gamesenseindicator.scale:get())
            elseif redrum.vars.refs.fakeping:get() < 68 then
                functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and ping_y.y - scale or indicators_spacing), "PING", nil, nil, 155,(36 + redrum.vars.refs.fakeping:get()*1.75),36, self.screen_group.gamesenseindicator.scale:get())
            end
        else
            indicators_spacing = indicators_spacing + scale
            local ping_y = mtools.Animation:Lerp("MTools_gsindicators", "ping_y", redrum.vars.refs.fakeping:get() > 0, vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            indicators_spacing = indicators_spacing - scale
        end

        if self.screen_group.gamesenseindicator.select:get(4) and redrum.vars.refs.hideshots:get() then
            indicators_spacing = indicators_spacing + scale
            local hideshots_y = mtools.Animation:Lerp("MTools_gsindicators", "hideshots_y", redrum.vars.refs.hideshots:get(), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and hideshots_y.y - scale or indicators_spacing), "OSAA", nil, nil, 200,200,200, self.screen_group.gamesenseindicator.scale:get())
        else
            indicators_spacing = indicators_spacing + scale
            local hideshots_y = mtools.Animation:Lerp("MTools_gsindicators", "hideshots_y", redrum.vars.refs.hideshots:get(), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            indicators_spacing = indicators_spacing - scale
        end

        if self.screen_group.gamesenseindicator.select:get(2) and redrum.vars.refs.doubletap:get() then
            indicators_spacing = indicators_spacing + scale
            local doubletap_y = mtools.Animation:Lerp("MTools_gsindicators", "doubletap_y", redrum.vars.refs.doubletap:get(), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            if rage.exploit:get() == 1 then
                functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and doubletap_y.y - scale or indicators_spacing), "DT", nil, nil, 200,200,200, self.screen_group.gamesenseindicator.scale:get())
            else
                functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and doubletap_y.y - scale or indicators_spacing), "DT", nil, nil, 229,26,55, self.screen_group.gamesenseindicator.scale:get())
            end
        else
            indicators_spacing = indicators_spacing + scale
            local doubletap_y = mtools.Animation:Lerp("MTools_gsindicators", "doubletap_y", redrum.vars.refs.doubletap:get(), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            indicators_spacing = indicators_spacing - scale
        end

        if self.screen_group.gamesenseindicator.select:get(1) and redrum.vars.refs.dormant:get() then
            for _, player in ipairs(all_players) do
                indicators_spacing = indicators_spacing + scale
                local dormant_y = mtools.Animation:Lerp("MTools_gsindicators", "dormant_y", redrum.vars.refs.dormant:get(), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
                if player:is_dormant() then
                    functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and dormant_y.y - scale or indicators_spacing), "DA", nil, nil, 200,200,200, self.screen_group.gamesenseindicator.scale:get())
                    break
                else
                    functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and dormant_y.y - scale or indicators_spacing), "DA", nil, nil, 229,26,55, self.screen_group.gamesenseindicator.scale:get())
                    break
                end
            end
        else
            indicators_spacing = indicators_spacing + scale
            local dormant_y = mtools.Animation:Lerp("MTools_gsindicators", "dormant_y", redrum.vars.refs.dormant:get(), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            indicators_spacing = indicators_spacing - scale
        end

        if self.screen_group.gamesenseindicator.select:get(9) and redrum.vars.refs.safepoint:get() == "Force" then
            indicators_spacing = indicators_spacing + scale
            local safepoint_y = mtools.Animation:Lerp("MTools_gsindicators", "safepoint_y", redrum.vars.refs.safepoint:get() == "Force", vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and safepoint_y.y - scale or indicators_spacing), "SAFE", nil, nil, 200,200,200, self.screen_group.gamesenseindicator.scale:get())
        else
            indicators_spacing = indicators_spacing + scale
            local safepoint_y = mtools.Animation:Lerp("MTools_gsindicators", "safepoint_y", redrum.vars.refs.safepoint:get() == "Force", vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            indicators_spacing = indicators_spacing - scale
        end

        if self.screen_group.gamesenseindicator.select:get(10) and redrum.vars.refs.bodyaim:get() == "Force" then
            indicators_spacing = indicators_spacing + scale
            local bodyaim_y = mtools.Animation:Lerp("MTools_gsindicators", "bodyaim_y", redrum.vars.refs.bodyaim:get() == "Force", vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and bodyaim_y.y - scale or indicators_spacing), "BODY", nil, nil, 200,200,200, self.screen_group.gamesenseindicator.scale:get())
        else
            indicators_spacing = indicators_spacing + scale
            local bodyaim_y = mtools.Animation:Lerp("MTools_gsindicators", "bodyaim_y", redrum.vars.refs.bodyaim:get() == "Force", vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            indicators_spacing = indicators_spacing - scale
        end

        if self.screen_group.gamesenseindicator.select:get(6) and redrum.vars.refs.fakeduck:get() then
            indicators_spacing = indicators_spacing + scale
            local fakeduck_y = mtools.Animation:Lerp("MTools_gsindicators", "fakeduck_y", redrum.vars.refs.fakeduck:get(), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and fakeduck_y.y - scale or indicators_spacing), "DUCK", nil, nil, 200,200,200, self.screen_group.gamesenseindicator.scale:get())
        else
            indicators_spacing = indicators_spacing + scale
            local fakeduck_y = mtools.Animation:Lerp("MTools_gsindicators", "fakeduck_y", redrum.vars.refs.fakeduck:get(), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            indicators_spacing = indicators_spacing - scale
        end

        if self.screen_group.gamesenseindicator.select:get(7) then
            for i in pairs(ui.get_binds()) do
                if ui.get_binds()[i].name == "Min. Damage" then
                    if ui.get_binds()[i].active then
                        indicators_spacing = indicators_spacing + scale
                        local damage_y = mtools.Animation:Lerp("MTools_gsindicators", "damage_y", self.screen_group.gamesenseindicator.select:get(7), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
                        functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and damage_y.y - scale or indicators_spacing), "MD", nil, nil, 200,200,200, self.screen_group.gamesenseindicator.scale:get())
                    end
                end
            end
        else
            indicators_spacing = indicators_spacing + scale
            local damage_y = mtools.Animation:Lerp("MTools_gsindicators", "damage_y", self.screen_group.gamesenseindicator.select:get(7), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            indicators_spacing = indicators_spacing - scale
        end

        if self.screen_group.gamesenseindicator.select:get(5) and redrum.vars.refs.freestanding:get() then
            indicators_spacing = indicators_spacing + scale
            local freestand_y = mtools.Animation:Lerp("MTools_gsindicators", "freestand_y", redrum.vars.refs.freestanding:get(), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and freestand_y.y - scale or indicators_spacing), "FS", nil, nil, 200,200,200, self.screen_group.gamesenseindicator.scale:get())
        else
            indicators_spacing = indicators_spacing + scale
            local freestand_y = mtools.Animation:Lerp("MTools_gsindicators", "freestand_y", redrum.vars.refs.freestanding:get(), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            indicators_spacing = indicators_spacing - scale
        end
        if self.screen_group.gamesenseindicator.select:get(8) then
            if bomb_info.state ~= true and bomb_info.plant_time > 0 then
                indicators_spacing = indicators_spacing + scale
                local bombsite_y = mtools.Animation:Lerp("MTools_gsindicators", "bombsite_y", self.screen_group.gamesenseindicator.select:get(8), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
                functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and bombsite_y.y - scale or indicators_spacing), bomb_info.site.."              ", bombicon, bomb_info.plant_percentage, 251, 240, 138, self.screen_group.gamesenseindicator.scale:get())
            end
            if bomb_info.state == true and bomb_info.c4time > 0.0199 then
                indicators_spacing = indicators_spacing + scale
                local bombsite2_y = mtools.Animation:Lerp("MTools_gsindicators", "bombsite2_y", (self.screen_group.gamesenseindicator.select:get(8)), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
                functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and bombsite2_y.y - scale or indicators_spacing), string.format(bomb_info.site.." - %.2fs              ", bomb_info.c4time), bombicon, nil, 200,200,200, self.screen_group.gamesenseindicator.scale:get())
            end
            if bomb_info.state == true then
                if bomb_info.dmg == "FATAL" then
                    indicators_spacing = indicators_spacing + scale
                    local bombfatal_y = mtools.Animation:Lerp("MTools_gsindicators", "bombfatal_y", self.screen_group.gamesenseindicator.select:get(8), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
                    functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and bombfatal_y.y - scale or indicators_spacing), bomb_info.dmg, nil, nil, 229,26,55, self.screen_group.gamesenseindicator.scale:get())
                elseif bomb_info.dmg ~= "-0 HP" and bomb_info.dmg ~= "FATAL" then
                    indicators_spacing = indicators_spacing + scale
                    local bombhp_y = mtools.Animation:Lerp("MTools_gsindicators", "bombhp_y", self.screen_group.gamesenseindicator.select:get(8), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
                    functions.gamesensefade((self.screen_group.gamesenseindicator.animation:get() and bombhp_y.y - scale or indicators_spacing), bomb_info.dmg, nil, nil, 251,240,138, self.screen_group.gamesenseindicator.scale:get())
                end
            end
        else
            indicators_spacing = indicators_spacing + scale
            local bomb_y = mtools.Animation:Lerp("MTools_gsindicators", "bomb_y", self.screen_group.gamesenseindicator.select:get(8), vector(0, indicators_spacing), vector(0, indicators_spacing + scale));
            indicators_spacing = indicators_spacing - scale
        end

        if self.screen_group.gamesenseindicator.select:get(12) then
            for i = 1, #local_player:get_spectators() do 
                local spec_name = local_player:get_spectators()[i]:get_name()
                render.text(1, vector(render.screen_size().x - 5, (render.screen_size().y/render.screen_size().y+16*i-14)), color(255,255,255,225), 'r', spec_name)
            end
        end

        mtools.Animation:Update("MTools_gsindicators", 15);

    end,

    aspectratio = function(self)
        if self.ingame.aspectratio:get() then
            cvar.r_aspectratio:float(self.ingame_group.aspectratio.value:get()/100)
        else
            cvar.r_aspectratio:float(0)
        end
    end,

    viewmodel = function(self)
        if not self.ingame.viewmodel:get() then
            return
        end

        cvar.viewmodel_fov:int(self.ingame_group.viewmodel.fov:get(), true)
        cvar.viewmodel_offset_x:float(self.ingame_group.viewmodel.x:get(), true)
        cvar.viewmodel_offset_y:float(self.ingame_group.viewmodel.y:get(), true)
        cvar.viewmodel_offset_z:float(self.ingame_group.viewmodel.z:get(), true)
    end,

    naderadius = function(self)
        if not self.ingame.naderadius:get() then
            return
        end

        if not entity.get_local_player() then return end
        if not entity.get_local_player():is_alive() then return end
        if self.ingame_group.naderadius.select:get(1) then
            local molotov_entity = entity.get_entities('CInferno')
            for i = 1, #molotov_entity do
                local new_molotov = molotov_entity[i]
                local molotov_origin = new_molotov:get_origin()
                local cell_radius = 40
                local cell = {}
                local maximum_distance = 0
                local max_a, max_b 
    
                local old_molotov = molotov_entity[i]
                for i = 1, 64 do
                    if old_molotov.m_bFireIsBurning[i] == true then
                        table.insert(cell, vector(new_molotov.m_fireXDelta[i], new_molotov.m_fireYDelta[i], new_molotov.m_fireZDelta[i]))
                    end
                end
    
                for v = 1, #cell do
                    for k = 1, #cell do
                        local distance = functions.dist_to_2d(cell[v], cell[k])
                        if distance > maximum_distance then
                            maximum_distance = distance
                            max_a = cell[v]
                            max_b = cell[k]
                        end
                    end
                end
    
                if max_a ~= nil and max_b ~= nil then
                    local center_delta = functions.lerp_position(max_a, max_b, 0.5)
                    local center = molotov_origin + center_delta
                    render.circle_3d_outline(center, color(self.ingame_group.naderadius.molotov:get().r, self.ingame_group.naderadius.molotov:get().g, self.ingame_group.naderadius.molotov:get().b, 255), maximum_distance / 2 + cell_radius, 0,1,1)  
                end
            end
        end

        if self.ingame_group.naderadius.select:get(2) then
            local tickcount = globals.tickcount
            local tickinterval = globals.tickinterval
            local Smokes = entity.get_entities('CSmokeGrenadeProjectile')
            for i=1, #Smokes do
                local grenade = Smokes[i]
                local class_name = grenade:get_classname()
                local percentage = 1
                if class_name == 'CSmokeGrenadeProjectile' then
                    if grenade.m_bDidSmokeEffect == true then
                        local ticks_created =grenade.m_nSmokeEffectTickBegin
                        if ticks_created ~= nil then
                            local time_since_explosion = tickinterval * (tickcount - ticks_created)
                            if time_since_explosion > 0 and 17.55-time_since_explosion > 0 then
                                if grenade_timer then
                                    percentage = 1 - time_since_explosion / 17.55
                                end
                                local r, g, b, a = self.ingame_group.naderadius.smoke:get().r, self.ingame_group.naderadius.smoke:get().g, self.ingame_group.naderadius.smoke:get().b, self.ingame_group.naderadius.smoke:get().a
                                local radius = 125
                                if 0.3 > time_since_explosion then
                                    radius = radius * 0.6 + (radius * (time_since_explosion / 0.3))*0.4
                                    a = a * (time_since_explosion / 0.3)
                                end
                                if 1.0 > 17.55-time_since_explosion then
                                    radius = radius * (((17.55-time_since_explosion) / 1.0)*0.3 + 0.7)
                                end
                                render.circle_3d_outline(grenade:get_origin(),color(r, g, b, a*math.min(1, percentage*1.3)), radius, 0,1)
                            end
                        end
                    end	
                end
            end
        end
    end,


    customscope = function(self)
        if not self.screen.customscope:get() then
            ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):override(ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):get())
            return
        end

        local local_player = entity.get_local_player()

        if local_player == nil then
            return
        end  

        if not local_player:is_alive() then
            return
        end  

        ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):override("Remove All")
		redrum.vars.customscope_length = functions.lerp(0.2, redrum.vars.customscope_length, local_player.m_bIsScoped and self.screen_group.customscope.length:get() or 0) 
		redrum.vars.customscope_gap = functions.lerp(0.2, redrum.vars.customscope_gap, local_player.m_bIsScoped and self.screen_group.customscope.gap:get() or 0) 
		local color_x = color(self.screen_group.customscope.color:get().r, self.screen_group.customscope.color:get().g, self.screen_group.customscope.color:get().b, self.screen_group.customscope.color:get().a)
		local color_y = color(self.screen_group.customscope.color:get().r, self.screen_group.customscope.color:get().g, self.screen_group.customscope.color:get().b, 0)
		render.gradient(vector(render.screen_size().x / 2 - redrum.vars.customscope_gap, render.screen_size().y / 2), vector(render.screen_size().x / 2 - redrum.vars.customscope_gap - redrum.vars.customscope_length, render.screen_size().y / 2 + 1), color_x, color_y, color_x, color_y)
		render.gradient(vector(render.screen_size().x / 2 + redrum.vars.customscope_gap, render.screen_size().y / 2), vector(render.screen_size().x / 2 + redrum.vars.customscope_gap + redrum.vars.customscope_length, render.screen_size().y / 2 + 1), color_x, color_y, color_x, color_y)
		render.gradient(vector(render.screen_size().x / 2, render.screen_size().y / 2 + redrum.vars.customscope_gap), vector(render.screen_size().x / 2 + 1, render.screen_size().y / 2 + redrum.vars.customscope_gap + redrum.vars.customscope_length), color_x, color_x, color_y, color_y)
		render.gradient(vector(render.screen_size().x / 2, render.screen_size().y / 2 - redrum.vars.customscope_gap), vector(render.screen_size().x / 2 + 1, render.screen_size().y / 2 - redrum.vars.customscope_gap - redrum.vars.customscope_length), color_x, color_x, color_y, color_y)
    end,

    manualarrows = function(self)
        if not self.screen.manualarrows:get() then
            return
        end

        local local_player = entity.get_local_player()

        if local_player == nil then
            return
        end  

        if not local_player:is_alive() then
            return
        end  

        mtools.Animation:Register("MTools_manualarrows");

        local is_scoped = local_player.m_bIsScoped
        local manualarrows_y = mtools.Animation:Lerp("MTools_manualarrows", "manualarrows_y", (is_scoped), vector(0, 0), vector(0, 20));

        if antiaim.additionals.manualyaw:get() == "Disabled" then
            render.texture(redrum.font.arrow_left, vector(render.screen_size().x/2 - 40, render.screen_size().y/2 - 6 - manualarrows_y.y), vector(12,12), color(0,0,0,150), f, 0)
            render.texture(redrum.font.arrow_right, vector(render.screen_size().x/2 + 31, render.screen_size().y/2 - 6 - manualarrows_y.y), vector(12,12), color(0,0,0,150), f, 0)
        elseif antiaim.additionals.manualyaw:get() == "Left" then
            render.texture(redrum.font.arrow_left, vector(render.screen_size().x/2 - 40, render.screen_size().y/2 - 6 - manualarrows_y.y), vector(12,12), self.accentcolor:get(), f, 0)
            render.texture(redrum.font.arrow_right, vector(render.screen_size().x/2 + 31, render.screen_size().y/2 - 6 - manualarrows_y.y), vector(12,12), color(0,0,0,150), f, 0)
        elseif antiaim.additionals.manualyaw:get() == "Right" then
            render.texture(redrum.font.arrow_left, vector(render.screen_size().x/2 - 40, render.screen_size().y/2 - 6 - manualarrows_y.y), vector(12,12), color(0,0,0,150), f, 0)
            render.texture(redrum.font.arrow_right, vector(render.screen_size().x/2 + 31, render.screen_size().y/2 - 6 - manualarrows_y.y), vector(12,12), self.accentcolor:get(), f, 0)
        end

        mtools.Animation:Update("MTools_manualarrows", 10);
    end,

    indicators = function(self)
        if not self.screen.crosshairindicator:get() then
            return
        end

        local local_player = entity.get_local_player()

        if local_player == nil then
            return
        end  

        if not local_player:is_alive() then
            return
        end 

        local additional_indicators = {
            damage = false,
            hitchance = false,
            bodyaim = false,
            safepoints = false,
            latency = false,
        }
        
        for i in pairs(ui.get_binds()) do
            if ui.get_binds()[i].name == "Min. Damage" then
                additional_indicators['damage'] = ui.get_binds()[i].active
            end
        end
        for i in pairs(ui.get_binds()) do
            if ui.get_binds()[i].name == "Hit Chance" then
                additional_indicators['hitchance'] = ui.get_binds()[i].active
            end
        end
        for i in pairs(ui.get_binds()) do
            if ui.get_binds()[i].name == "Body Aim" then
                additional_indicators['bodyaim'] = ui.get_binds()[i].active
            end
        end
        for i in pairs(ui.get_binds()) do
            if ui.get_binds()[i].name == "Safe Points" then
                additional_indicators['safepoints'] = ui.get_binds()[i].active
            end
        end
        for i in pairs(ui.get_binds()) do
            if ui.get_binds()[i].name == "Fake Latency" then
                additional_indicators['latency'] = ui.get_binds()[i].active
            end
        end

        local cx, cy = render.screen_size().x/2, render.screen_size().y/2
        
        mtools.Animation:Register("MTools_indicators");

        local is_scoped = local_player.m_bIsScoped
        local indicators_spacing = 0

        local lerp = {
            text_main = mtools.Animation:Lerp("MTools_indicators", "main", (is_scoped), vector(0, 0), vector(42, 0));
            text_doubletap = mtools.Animation:Lerp("MTools_indicators", "doubletap", (is_scoped), vector(-23, 0), vector(10, 0));
            text_hideshots = mtools.Animation:Lerp("MTools_indicators", "hideshots", (is_scoped), vector(-23, 0), vector(9, 0));
            text_freestand = mtools.Animation:Lerp("MTools_indicators", "freestand", (is_scoped), vector(-21, 0), vector(10, 0));
            text_damage = mtools.Animation:Lerp("MTools_indicators", "damage", (is_scoped), vector(-18, 0), vector(10, 0));
            text_fakeduck = mtools.Animation:Lerp("MTools_indicators", "fakeduck", (is_scoped), vector(-21, 0), vector(10, 0));
            text_latency = mtools.Animation:Lerp("MTools_indicators", "latency", (is_scoped), vector(-17, 0), vector(9, 0));
            text_hitchance = mtools.Animation:Lerp("MTools_indicators", "hitchance", (is_scoped), vector(-23, 0), vector(9, 0));
            text_bodyaim = mtools.Animation:Lerp("MTools_indicators", "bodyaim", (is_scoped), vector(-20, 0), vector(9, 0));
            text_safepoints = mtools.Animation:Lerp("MTools_indicators", "safepoints", (is_scoped), vector(-24, 0), vector(9, 0));
        }

        if redrum.vars.refs.doubletap:get() then
            indicators_spacing = indicators_spacing + 13
            doubletap_y = mtools.Animation:Lerp("MTools_indicators", "doubletap_y", redrum.vars.refs.doubletap:get(), vector(0, indicators_spacing), vector(0, indicators_spacing));
        else
            indicators_spacing = indicators_spacing + 13
            doubletap_y = mtools.Animation:Lerp("MTools_indicators", "doubletap_y", redrum.vars.refs.doubletap:get(), vector(0, indicators_spacing), vector(0, indicators_spacing));
            indicators_spacing = indicators_spacing - 13
        end

        if redrum.vars.refs.hideshots:get() then
            indicators_spacing = indicators_spacing + 13
            hideshots_y = mtools.Animation:Lerp("MTools_indicators", "hideshots_y", redrum.vars.refs.hideshots:get(), vector(0, indicators_spacing), vector(0, indicators_spacing));
        else
            indicators_spacing = indicators_spacing + 13
            hideshots_y = mtools.Animation:Lerp("MTools_indicators", "hideshots_y", redrum.vars.refs.hideshots:get(), vector(0, indicators_spacing), vector(0, indicators_spacing));
            indicators_spacing = indicators_spacing - 13
        end

        if redrum.vars.refs.freestanding:get() then
            indicators_spacing = indicators_spacing + 13
            freestand_y = mtools.Animation:Lerp("MTools_indicators", "freestand_y", redrum.vars.refs.freestanding:get(), vector(0, indicators_spacing), vector(0, indicators_spacing));
        else
            indicators_spacing = indicators_spacing + 13
            freestand_y = mtools.Animation:Lerp("MTools_indicators", "freestand_y", redrum.vars.refs.freestanding:get(), vector(0, indicators_spacing), vector(0, indicators_spacing));
            indicators_spacing = indicators_spacing - 13
        end

        if additional_indicators['damage'] == true then
            indicators_spacing = indicators_spacing + 13
            damage_y = mtools.Animation:Lerp("MTools_indicators", "damage_y", additional_indicators['damage'] == true, vector(0, indicators_spacing), vector(0, indicators_spacing));
        else
            indicators_spacing = indicators_spacing + 13
            damage_y = mtools.Animation:Lerp("MTools_indicators", "damage_y", additional_indicators['damage'] == true, vector(0, indicators_spacing), vector(0, indicators_spacing));
            indicators_spacing = indicators_spacing - 13
        end
    
        if redrum.vars.refs.fakeduck:get() then
            indicators_spacing = indicators_spacing + 13
            fakeduck_y = mtools.Animation:Lerp("MTools_indicators", "fakeduck_y", redrum.vars.refs.fakeduck:get(), vector(0, indicators_spacing), vector(0, indicators_spacing));
        else
            indicators_spacing = indicators_spacing + 13
            fakeduck_y = mtools.Animation:Lerp("MTools_indicators", "fakeduck_y", redrum.vars.refs.fakeduck:get(), vector(0, indicators_spacing), vector(0, indicators_spacing));
            indicators_spacing = indicators_spacing - 13
        end
    
        if additional_indicators['latency'] == true then
            indicators_spacing = indicators_spacing + 13
            latency_y = mtools.Animation:Lerp("MTools_indicators", "latency_y", additional_indicators['latency'] == true, vector(0, indicators_spacing), vector(0, indicators_spacing));
        else
            indicators_spacing = indicators_spacing + 13
            latency_y = mtools.Animation:Lerp("MTools_indicators", "latency_y", additional_indicators['latency'] == true, vector(0, indicators_spacing), vector(0, indicators_spacing));
            indicators_spacing = indicators_spacing - 13
        end
    
        if additional_indicators['hitchance'] == true then
            indicators_spacing = indicators_spacing + 13
            hitchance_y = mtools.Animation:Lerp("MTools_indicators", "hitchance_y", additional_indicators['hitchance'] == true, vector(0, indicators_spacing), vector(0, indicators_spacing));
        else
            indicators_spacing = indicators_spacing + 13
            hitchance_y = mtools.Animation:Lerp("MTools_indicators", "hitchance_y", additional_indicators['hitchance'] == true, vector(0, indicators_spacing), vector(0, indicators_spacing));
            indicators_spacing = indicators_spacing - 13
        end
    
        if additional_indicators['bodyaim'] == true then
            indicators_spacing = indicators_spacing + 13
            bodyaim_y = mtools.Animation:Lerp("MTools_indicators", "bodyaim_y", additional_indicators['bodyaim'] == true, vector(0, indicators_spacing), vector(0, indicators_spacing));
        else
            indicators_spacing = indicators_spacing + 13
            bodyaim_y = mtools.Animation:Lerp("MTools_indicators", "bodyaim_y", additional_indicators['bodyaim'] == true, vector(0, indicators_spacing), vector(0, indicators_spacing));
            indicators_spacing = indicators_spacing - 13
        end
    
        if additional_indicators['safepoints'] == true then
            indicators_spacing = indicators_spacing + 13
            safepoints_y = mtools.Animation:Lerp("MTools_indicators", "safepoints_y", additional_indicators['safepoints'] == true, vector(0, indicators_spacing), vector(0, indicators_spacing));
        else
            indicators_spacing = indicators_spacing + 13
            safepoints_y = mtools.Animation:Lerp("MTools_indicators", "safepoints_y", additional_indicators['safepoints'] == true, vector(0, indicators_spacing), vector(0, indicators_spacing));
            indicators_spacing = indicators_spacing - 13
        end
        

        local fading_alpha = math.min(math.floor(math.sin((globals.curtime%3) * 5) * 200 + 255), 255)
        render.text(1, vector(cx - 33 + math.floor(lerp.text_main.x), cy + 21), color(255,255,255,255), c, 'redrum')
        render.text(1, vector(cx + 6 + math.floor(lerp.text_main.x), cy + 21), color(self.accentcolor:get().r,self.accentcolor:get().g,self.accentcolor:get().b,fading_alpha), c, string.lower(redrum.vars.lua_version))
        functions.animated_text("doubletap_animation", redrum.vars.refs.doubletap:get(), is_scoped, vector(cx + math.floor(lerp.text_doubletap.x), cy + 20 + math.floor(doubletap_y.y)), 1, color(255,255,255,255), nil, "doubletap")
        functions.animated_text("hideshots_animation", redrum.vars.refs.hideshots:get(), is_scoped, vector(cx + math.floor(lerp.text_hideshots.x), cy + 20 + math.floor(hideshots_y.y)), 1, color(255,255,255,255), nil, "hideshots")
        functions.animated_text("freestand_animation", redrum.vars.refs.freestanding:get(), is_scoped, vector(cx + math.floor(lerp.text_freestand.x), cy + 20 + math.floor(freestand_y.y)), 1, color(255,255,255,255), nil, "direction")
        functions.animated_text("damage_animation", additional_indicators['damage'] == true, is_scoped, vector(cx + math.floor(lerp.text_damage.x), cy + 20 + math.floor(damage_y.y)), 1, color(255,255,255,255), nil, "damage")
        functions.animated_text("fakeduck_animation", redrum.vars.refs.fakeduck:get(), is_scoped, vector(cx + math.floor(lerp.text_fakeduck.x), cy + 20 + math.floor(fakeduck_y.y)), 1, color(255,255,255,255), nil, "fakeduck")
        functions.animated_text("latency_animation", additional_indicators['latency'] == true, is_scoped, vector(cx + math.floor(lerp.text_latency.x), cy + 20 + math.floor(latency_y.y)), 1, color(255,255,255,255), nil, "latency")
        functions.animated_text("hitchance_animation", additional_indicators['hitchance'] == true, is_scoped, vector(cx + math.floor(lerp.text_hitchance.x), cy + 20 + math.floor(hitchance_y.y)), 1, color(255,255,255,255), nil, "hitchance")
        functions.animated_text("bodyaim_animation", additional_indicators['bodyaim'] == true, is_scoped, vector(cx + math.floor(lerp.text_bodyaim.x), cy + 20 + math.floor(bodyaim_y.y)), 1, color(255,255,255,255), nil, "bodyaim")
        functions.animated_text("safepoints_animation", additional_indicators['safepoints'] == true, is_scoped, vector(cx + math.floor(lerp.text_safepoints.x), cy + 20 + math.floor(safepoints_y.y)), 1, color(255,255,255,255), nil, "safepoints")

        mtools.Animation:Update("MTools_indicators", 10);
    end,
    
    watermark = function(self)
        if not self.screen.widgets:get() then
            return
        end

        if not self.screen_group.widgets.select:get("Watermark") then
            return
        end

        local local_player = entity.get_local_player()

        if local_player == nil then
            return
        end  

        local x, y = render.screen_size().x, render.screen_size().y

        local acolor = self.accentcolor:get()

        render.rect(vector(x - 33, (y - y) + 5), vector(x - 5, (y - y) + 30), color(0,0,0,150), 5)
        render.text(redrum.font.verdana3, vector(x - 27, (y - y) + 9), color(acolor.r, acolor.g, acolor.b, 255), nil, pui.string("\f<knife-kitchen>"))

        render.rect(vector(x - 110, (y - y) + 5), vector(x - 40, (y - y) + 30), color(0,0,0,150), 5)
        render.text(redrum.font.verdana3, vector(x - 100, (y - y) + 9), color(acolor.r, acolor.g, acolor.b, 255), nil, pui.string("\f<clock>"))
        render.text(1, vector(x - 78, (y - y) + 11), color(), nil, string.format("%s:%s", mtools.Client.GetDAT().hours, mtools.Client.GetDAT().minutes))

        local wifimeasure = render.measure_text(1, nil, string.format("%s ms", mtools.Client.GetPing()))
        render.rect(vector(x - 162 - wifimeasure.x, (y - y) + 5), vector(x - 117, (y - y) + 30), color(0,0,0,150), 5)
        render.text(redrum.font.verdana3, vector(x - 152 - wifimeasure.x, (y - y) + 9), color(acolor.r, acolor.g, acolor.b, 255), nil, pui.string("\f<globe>"))
        render.text(1, vector(x - 128 - wifimeasure.x, (y - y) + 11), color(), nil, string.format("%s ms", mtools.Client.GetPing()))

    end
}

visuals:menu()

local damageoverride_drag = drag_system.register({visuals.screen_group.damageoverride.x, visuals.screen_group.damageoverride.y}, vector(31, 21), "damageoverride_drag", function(self)
    if not visuals.screen.damageoverride:get() then
        return
    end

    local local_player = entity.get_local_player()

    if local_player == nil then
        return
    end  

    if not local_player:is_alive() then
        return
    end  

    local xv, yv = self.position.x, self.position.y

    local is_bounded = functions.is_bounded(xv, yv, xv + 150, yv + 35)

    if is_bounded and common.is_button_down(0x2) and ui.get_alpha() == 1 then
        self.position.x = render.screen_size().x - (render.screen_size().x/2)
        self.position.y = render.screen_size().y - (render.screen_size().y/2) - 21
    end

    render.text(1, vector(xv + 5, yv + 5), color(255, 255, 255, math.floor(ui.get_alpha() * 255)), nil, "DMG")
    if ui.get_alpha() == 0 then
        for i in pairs(ui.get_binds()) do
            if ui.get_binds()[i].name == "Min. Damage" then
                if ui.get_binds()[i].active then
                    render.text(1, vector(xv + 5, yv + 5), color(255, 255, 255, 255), nil, redrum.vars.refs.mindamage:get())
                end
            end
        end
    end
end)

local defensive_drag = drag_system.register({visuals.screen_group.widgets.defensive_x, visuals.screen_group.widgets.defensive_y}, vector(100, 65), "defensive_drag", function(self)
    if not visuals.screen.widgets:get() then
        return
    end

    if not visuals.screen_group.widgets.select:get("Defensive") then
        return
    end

    local local_player = entity.get_local_player()

    if local_player == nil then
        return
    end  

    local xv, yv = self.position.x, self.position.y

    mtools.Animation:Register("MTools_defensive");

    local is_bounded = functions.is_bounded(xv, yv, xv + 100, yv + 65)

    is_bounded_alpha = mtools.Animation:Lerp("MTools_defensive", "is_bounded_alpha", not (is_bounded and common.is_button_down(0x1) and ui.get_alpha() == 1), 0, 150);
    render.rect(vector(render.screen_size().x - render.screen_size().x, render.screen_size().y - render.screen_size().y), vector(render.screen_size().x, render.screen_size().y), color(0, 0, 0, is_bounded_alpha), 0)
    render.blur(vector(render.screen_size().x - render.screen_size().x, render.screen_size().y - render.screen_size().y), vector(render.screen_size().x, render.screen_size().y), 1, is_bounded_alpha/800, 0)
    
    if is_bounded and common.is_button_down(0x2) and ui.get_alpha() == 1 then
        self.position.x = render.screen_size().x - (render.screen_size().x/2) - 50
        self.position.y = render.screen_size().y - render.screen_size().y + 100
    end

    if is_bounded and common.is_button_down(0x4) and ui.get_alpha() == 1 then
        self.position.x = render.screen_size().x - (render.screen_size().x/2) - 50
    end

    local acolor = visuals.accentcolor:get()
    
    if ui.get_alpha() < 1 and local_player:is_alive() then
        defensive_alpha = mtools.Animation:Lerp("MTools_defensive", "defensive_alpha", not ((redrum.vars.refs.doubletap:get() or redrum.vars.refs.hideshots:get()) and antiaim.options[antiaim.Convert[mtools.AntiAims.Condition:Get()]].defensive:get() and antiaim.additionals.tweaks:get("Force Defensive")), 0, 255);
    elseif ui.get_alpha() < 1 and local_player:is_alive() == false then
        defensive_alpha = -999
    else
        defensive_alpha = 255
    end

    render.text(redrum.font.widgets, vector(xv + 39, yv + 5), color(acolor.r, acolor.g, acolor.b, defensive_alpha), nil,  pui.string("\f<chevron-up>"))
    render.text(redrum.font.widgets, vector(xv + 39, yv + 4), color(acolor.r, acolor.g, acolor.b, defensive_alpha), nil,  pui.string("\f<chevron-up>"))

    render.text(redrum.font.widgets, vector(xv + 39, yv + 13), color(acolor.r, acolor.g, acolor.b, defensive_alpha), nil,  pui.string("\f<chevron-up>"))
    render.text(redrum.font.widgets, vector(xv + 39, yv + 12), color(acolor.r, acolor.g, acolor.b, defensive_alpha), nil,  pui.string("\f<chevron-up>"))

    render.text(1, vector(xv + 6, yv + 35), color(255, 255, 255, defensive_alpha), nil, string.format("defensive \a%schoking", acolor:to_hex()))
    render.shadow(vector(xv + 5, yv + 55), vector(xv + 95, yv + 60), color(acolor.r, acolor.g, acolor.b, defensive_alpha), 15, 0, 2)
    local choking = (ui.get_alpha() < 1 and (globals.tickcount*antiaim.defensive[antiaim.Convert[mtools.AntiAims.Condition:Get()]].speed:get()/2%40) or 40)
    render.rect(vector(xv + 5, yv + 55), vector(xv + 95, yv + 60), color(0, 0, 0, defensive_alpha - 180), 2)
    render.rect(vector(xv + 45 - choking, yv + 55), vector(xv + 55 + choking, yv + 60), color(acolor.r, acolor.g, acolor.b, defensive_alpha), 2)

    mtools.Animation:Update("MTools_defensive", 2000);
end)

local infopanel_drag = drag_system.register({visuals.screen_group.widgets.infopanel_x, visuals.screen_group.widgets.infopanel_y}, vector(120, 20), "infopanel_drag", function(self)
    if not visuals.screen.widgets:get() then
        return
    end

    if not visuals.screen_group.widgets.select:get("Infopanel") then
        return
    end

    local local_player = entity.get_local_player()

    if local_player == nil then
        return
    end  

    local xv, yv = self.position.x, self.position.y

    local is_bounded = functions.is_bounded(xv, yv, xv + 120, yv + 20)
    mtools.Animation:Register("MTools_infopanel");
    is_bounded_alpha = mtools.Animation:Lerp("MTools_infopanel", "is_bounded_alpha", not (is_bounded and common.is_button_down(0x1) and ui.get_alpha() == 1), 0, 150);
    render.rect(vector(render.screen_size().x - render.screen_size().x, render.screen_size().y - render.screen_size().y), vector(render.screen_size().x, render.screen_size().y), color(0, 0, 0, is_bounded_alpha), 0)
    render.blur(vector(render.screen_size().x - render.screen_size().x, render.screen_size().y - render.screen_size().y), vector(render.screen_size().x, render.screen_size().y), 1, is_bounded_alpha/800, 0)
    
    if is_bounded and common.is_button_down(0x2) and ui.get_alpha() == 1 then
        self.position.x = render.screen_size().x - (render.screen_size().x) + 10
        self.position.y = render.screen_size().y - render.screen_size().y + 500
    end

    if is_bounded and common.is_button_down(0x4) and ui.get_alpha() == 1 then
        self.position.x = render.screen_size().x - (render.screen_size().x/2) - 52
    end

    local acolor = visuals.accentcolor:get()

    local infopanel_gradient = gradient.text_animate("R E D R U M", -1, {
        color(255,255,255,255),
        color(100,100,100,255),
    })

    render.text(1, vector(xv + 6, yv + 5), color(255, 255, 255, 255), nil, string.format("%s \a%s[%s]", infopanel_gradient:get_animated_text(), acolor:to_hex(), string.upper(redrum.vars.lua_version)))
    infopanel_gradient:animate()
    mtools.Animation:Update("MTools_infopanel", 2000);
end)


local velocity_drag = drag_system.register({visuals.screen_group.widgets.velocity_x, visuals.screen_group.widgets.velocity_y}, vector(100, 65), "velocity_drag", function(self)
    if not visuals.screen.widgets:get() then
        return
    end

    if not visuals.screen_group.widgets.select:get("Slowdown") then
        return
    end

    local local_player = entity.get_local_player()

    if local_player == nil then
        return
    end  

    local xv, yv = self.position.x, self.position.y
    local get_velocity = math.floor(local_player['m_flVelocityModifier'] * 100)

    mtools.Animation:Register("MTools_velocity");

    local is_bounded = functions.is_bounded(xv, yv, xv + 100, yv + 65)

    is_bounded_alpha = mtools.Animation:Lerp("MTools_velocity", "is_bounded_alpha", not (is_bounded and common.is_button_down(0x1) and ui.get_alpha() == 1), 0, 150);
    render.rect(vector(render.screen_size().x - render.screen_size().x, render.screen_size().y - render.screen_size().y), vector(render.screen_size().x, render.screen_size().y), color(0, 0, 0, is_bounded_alpha), 0)
    render.blur(vector(render.screen_size().x - render.screen_size().x, render.screen_size().y - render.screen_size().y), vector(render.screen_size().x, render.screen_size().y), 1, is_bounded_alpha/800, 0)
    
    if is_bounded and common.is_button_down(0x2) and ui.get_alpha() == 1 then
        self.position.x = render.screen_size().x - (render.screen_size().x/2) - 50
        self.position.y = render.screen_size().y - render.screen_size().y + 200
    end

    if is_bounded and common.is_button_down(0x4) and ui.get_alpha() == 1 then
        self.position.x = render.screen_size().x - (render.screen_size().x/2) - 50
    end

    local acolor = visuals.accentcolor:get()

    if ui.get_alpha() < 1 and local_player:is_alive() then
        velocity_alpha = mtools.Animation:Lerp("MTools_velocity", "velocity_alpha", (get_velocity == 100), 0, 255);
    elseif ui.get_alpha() < 1 and local_player:is_alive() == false then
        velocity_alpha = -999
    else
        velocity_alpha = 255
    end


    render.text(redrum.font.widgets, vector(xv + 39, yv + 5), color(acolor.r, acolor.g, acolor.b, velocity_alpha), nil,  pui.string("\f<sparkles>"))

    render.text(1, vector(xv + 19, yv + 35), color(255, 255, 255, velocity_alpha), nil, string.format("velocity \a%s%s%s", acolor:to_hex(), get_velocity, "% "))
    render.shadow(vector(xv + 5, yv + 55), vector(xv + 95, yv + 60), color(acolor.r, acolor.g, acolor.b, velocity_alpha), 15, 0, 2)
    render.rect(vector(xv + 5, yv + 55), vector(xv + 95, yv + 60), color(0, 0, 0, velocity_alpha - 180), 2)
    render.rect(vector(xv + 45 - get_velocity/2.5, yv + 55), vector(xv + 55 + get_velocity/2.5, yv + 60), color(acolor.r, acolor.g, acolor.b, velocity_alpha), 2)

    mtools.Animation:Update("MTools_velocity", 2000);
end)

misc = {
    menu = function(self)
        self.main = {
            unmutemutedplayers = redrum.groups.misc.main:switch("\v\f<volume-slash>   \rUnmute Muted Players"),
            taskbarnotification = redrum.groups.misc.main:switch("\v\f<triangle-exclamation>    \rTaskbar Notification"),
            unlocklatency = redrum.groups.misc.main:switch("\v\f<lock>     \rUnlock Latency"),
            nofalldamage = redrum.groups.misc.main:switch("\v \f<person-falling-burst>   \rNo Fall damage"),
            fastladder = redrum.groups.misc.main:switch("\v\f<water-ladder>     \rFast Ladder"),
            supertoss = redrum.groups.misc.main:switch("\v\f<bomb>     \rSuper Toss"),
            luatag = redrum.groups.misc.main:switch("\v\f<users>    \rLua Tag"),
            killsay = redrum.groups.misc.main:switch("\v\f<skull>     \rKill Say"),
        }
    end,

    fastladder = function(self, cmd)
        if not self.main.fastladder:get() then
            return
        end

        local local_player = entity.get_local_player()
        if local_player == nil then return end
        local pitch = render.camera_angles()
        if local_player["m_MoveType"] == 9 then
            if cmd.forwardmove > 0 then
            if pitch.x < 45 then
                cmd.view_angles.x = 89
                cmd.view_angles.y = cmd.view_angles.y + 89
                cmd.in_moveright = 1
                cmd.in_moveleft = 0
                cmd.in_forward = 0
                cmd.in_back = 1
                if cmd.sidemove == 0 then
                    cmd.move_yaw = cmd.move_yaw + 90
                end
                if cmd.sidemove < 0 then
                    cmd.move_yaw = cmd.move_yaw + 150
                end
                if cmd.sidemove > 0 then
                    cmd.move_yaw = cmd.move_yaw + 30
                end
            end
        end
        
        if cmd.forwardmove < 0 then
            cmd.view_angles.x = 89
            cmd.view_angles.y = cmd.view_angles.y + 89
            cmd.in_moveright = 1
            cmd.in_moveleft = 0
            cmd.in_forward = 1
            cmd.in_back = 0
            if cmd.sidemove == 0 then
                cmd.move_yaw = cmd.move_yaw + 90
            end
            if cmd.sidemove > 0 then
                cmd.move_yaw = cmd.move_yaw + 150
            end
            if cmd.sidemove < 0 then
                cmd.move_yaw = cmd.move_yaw + 30
                end
            end
        end
    end,

    nofalldamage = function(self, cmd)
        if not self.main.nofalldamage:get() then
            return
        end

        local local_player = entity.get_local_player()
    
        if local_player == nil then return end
    
        if local_player.m_vecVelocity.z >= -500 then
            no_fall_damage = false
        else
            if functions.trace(15) then 
                no_fall_damage = false
            elseif functions.trace(75) then
                no_fall_damage = true
            end
        end
    
        if local_player.m_vecVelocity.z < -500 then
            if no_fall_damage then
                cmd.in_duck = 1
            else
                cmd.in_duck = 0
            end
        end
    end,

    unmutemutedplayers = function(self)
        if not self.main.unmutemutedplayers:get() then
            return
        end

        entity.get_players(false, true, function(player_ptr)
            local player = panorama.MatchStatsAPI.GetPlayerXuid(
                player_ptr:get_index()
            )

            if panorama.GameStateAPI.HasCommunicationAbuseMute(player) then
            if not panorama.GameStateAPI.IsSelectedPlayerMuted(player) then goto skip end

            panorama.GameStateAPI.ToggleMute(player)
            ::skip::
            end
        end)
    end,

    taskbarnotification = function(self)
        local raw_hwnd = utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B") or error("Invalid signature #1")
        local raw_FlashWindow = utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7") or error("Invalid signature #2")
        local raw_insn_jmp_ecx = utils.opcode_scan("gameoverlayrenderer.dll", "FF E1") or error("Invalid signature #3")
        local get_hwnd = utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74") or error("Invalid signature #4")
        local hwnd_ptr = ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", raw_hwnd) + 2)[0])[0] + 2)
        local FlashWindow = ffi.cast("int(__stdcall*)(uintptr_t, int)", raw_FlashWindow)
        local insn_jmp_ecx = ffi.cast("int(__thiscall*)(uintptr_t)", raw_insn_jmp_ecx)
        local GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", get_hwnd) + 2)[0])[0]
        local function get_csgo_hwnd() return hwnd_ptr[0] end
        local function get_hwnd() return insn_jmp_ecx(GetForegroundWindow) end
        local function send_notify() local csgo_hwnd = get_csgo_hwnd() if get_hwnd() ~= csgo_hwnd then FlashWindow(csgo_hwnd, 1) return true end return false end

        if not self.main.taskbarnotification:get() then
            return
        end

        send_notify()
    end,

    killsay_phrases = {
        "1 Случайный",
        "tu joues pire que Ventu",
        "liathróid redrum lua",
        "ägs av redrum lua",
        "Kaufen Sie Redrum Lua oder sterben Sie",
        "Ich kann mir nicht vorstellen, so schwach zu sein wie du",
        "without redrum lua it's not a game",
        "Ffyc chi",
        "på beina, hund",
        "redrum lua te ha penetrado",
        "Jag cumming i din mun med redrum lua",
        "Pastebin.com/raw/g3uFSPGF - Pedophile exposed by redrum lua"
    },

    killsay = function(self, e)
        if not self.main.killsay:get() then
            return
        end

        local local_player = entity.get_local_player()
        local attacker = entity.get(e.attacker, true)
    
        if local_player == attacker then
            utils.console_exec('say "' .. self.killsay_phrases[utils.random_int(1, #self.killsay_phrases)]:gsub('"', '') .. '"')
        end
    end,

    luatag = function(self)
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        if self.main.luatag:get() then
            if globals.is_connected and globals.choked_commands then
                clan_tag = functions.luatag_anim('R E D R U M', {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 , 22, 23, 24})
                if entity.get_game_rules()['m_gamePhase'] == 5 or entity.get_game_rules()['m_gamePhase'] == 4 then
                    clan_tag = functions.luatag_anim('R E D R U M', {11})
                    common.set_clan_tag(clan_tag, clan_tag)
                elseif clan_tag ~= clan_tag_prev then
                    common.set_clan_tag(clan_tag, clan_tag)
                end
                clan_tag_prev = clan_tag
            end
            enabled_prev = false
        elseif not self.main.luatag:get() and enabled_prev == false then
            common.set_clan_tag('\0')
            enabled_prev = true
        end
    end,
    
    unlocklatency = function(self)
        if self.main.unlocklatency:get() then
            cvar.sv_maxunlag:float(0.75)
        else
            cvar.sv_maxunlag:float(0.2)
        end
    end,

    supertoss = {
        active = false,
        last_angles = vector(0, 0, 0),
        target_angles = vector(0, 0, 0),
    },

    supertoss_check_active = function(self)
        misc.supertoss.active = false
        if self.main.supertoss:get() ~= true then
            return
        end
        local local_player = entity.get_local_player()
        if local_player == nil then
            return
        end
        if local_player:is_alive() == false then
            return
        end
        if local_player.m_MoveType == 8 then
            return
        end
        local weapon = local_player:get_player_weapon()
        if weapon == nil then
            return
        end
        local weapon_info = weapon:get_weapon_info()
        if weapon_info == nil then
            return
        end
        if weapon_info.weapon_type ~= 9 then
            return
        end
        misc.supertoss.active = true
    end,

    supertoss_on_pre_render = function(self)
        self.supertoss_check_active(self)
        misc.supertoss.last_angles = render.camera_angles()
        if misc.supertoss.active == true and common.is_in_thirdperson() == false then
            render.camera_angles(misc.supertoss.target_angles)
        end
    end,

    supertoss_on_override_view = function(zv)
        if misc.supertoss.active == true then
            zv.view = misc.supertoss.last_angles
            render.camera_angles(misc.supertoss.last_angles)
        end
    end,

    supertoss_on_createmove = function(self, cmd)
        if misc.supertoss.active ~= true then
            return
        end
        local local_player = entity.get_local_player()
        if local_player == nil then
            return
        end
        if local_player:is_alive() == false then
            return
        end
        local weapon = local_player:get_player_weapon()
        if weapon == nil then
            return
        end
        local weapon_info = weapon:get_weapon_info()
        if weapon_info == nil then
            return
        end
    
        local lp_addr = ffi.cast("uintptr_t", local_player[0])
    
        local ang_throw = vector(cmd.view_angles.x, cmd.view_angles.y, 0)
        ang_throw.x = ang_throw.x - (90 - math.abs(ang_throw.x)) * 10 / 90
        ang_throw = functions.ang_vec(ang_throw)

        if weapon.m_flThrowStrength == nil then
            return
        end

        local throw_strength = math.clamp(weapon.m_flThrowStrength, 0, 1)
        local fl_velocity = math.clamp(weapon_info.throw_velocity * 0.9, 15, 750)
        fl_velocity = fl_velocity * (throw_strength * 0.7 + 0.3)
    
        local localplayer_velocity = ffi.cast("vector_t*", lp_addr + 0x94)[0]
        localplayer_velocity = vector(localplayer_velocity.x, localplayer_velocity.y, localplayer_velocity.z)
        local vec_throw = (ang_throw * fl_velocity + localplayer_velocity * 1.45)
        vec_throw = vec_throw:angles()
        local yaw_difference = cmd.view_angles.y - vec_throw.y
        while yaw_difference > 180 do
            yaw_difference = yaw_difference - 360
        end
        while yaw_difference < -180 do
            yaw_difference = yaw_difference + 360
        end
        local pitch_difference = cmd.view_angles.x - vec_throw.x - 10
        while pitch_difference > 90 do
            pitch_difference = pitch_difference - 45
        end
        while pitch_difference < -90 do
            pitch_difference = pitch_difference + 45
        end
        misc.supertoss.target_angles.y = cmd.view_angles.y + yaw_difference
        cmd.view_angles.y = cmd.view_angles.y + yaw_difference
        misc.supertoss.target_angles.x = math.clamp(cmd.view_angles.x + pitch_difference, -89, 89)
        cmd.view_angles.x = math.clamp(cmd.view_angles.x + pitch_difference, -89, 89)
    end
}

misc:menu()

configs_db = db.systemtable or {}
configs_db.cfg_list = configs_db.cfg_list or {}
configs_db.alloflist = configs_db.alloflist or {}
local configs = {
    menu_config = function(self)
        self.configname_input = redrum.groups.configs.list:input("\v"..ui.get_icon("pen").."   \rConfig name", "Config Name")
        self.configlist = redrum.groups.configs.list:list("", alloflist)
        self.create = redrum.groups.configs.list:button("\v "..ui.get_icon("badge-check").." ", function()
            self.create_config(self.configname_input:get())
            self.configlist:update(configs_db.alloflist)
            utils.console_exec("playvol  buttons/button14.wav 1")  
        end, true)
        self.create:tooltip("Create new config")
        self.save = redrum.groups.configs.list:button("\v "..ui.get_icon("download").." ", function()
            self.save_config(self.configlist:get())
            utils.console_exec("playvol  buttons/button14.wav 1")  
        end, true)
        self.save:tooltip("Save selected config")
        self.load = redrum.groups.configs.list:button("\v "..ui.get_icon("upload").." ", function()
            self.load_config(self.configlist:get())
            self.configlist:update(configs_db.alloflist)
            utils.console_exec("playvol  buttons/bell1.wav 1")
        end, true)
        self.load:tooltip("Load selected config")
        self.remove = redrum.groups.configs.list:button("\v "..ui.get_icon("trash").." ", function()
            self.remove_config(self.configlist:get())
            self.configlist:update(configs_db.alloflist)
            utils.console_exec("playvol  buttons/bell1.wav 1")
        end, true)
        self.remove:tooltip("Remove selected config")
        self.export = redrum.groups.configs.list:button("\v "..ui.get_icon("file-export").."", function()
            local raw = configsave:save()
            clipboard.set("<redrum>_"..base64.encode(json.stringify(raw)))
            utils.console_exec("playvol  buttons/button14.wav 1")  
        end, true)
        self.export:tooltip("Export config")
        self.import = redrum.groups.configs.list:button("\v"..ui.get_icon("file-import").." ", function()
            local raw = clipboard.get()
            local newraw = raw:gsub("<redrum>_", "")
            configsave:load(json.parse(base64.decode(newraw)))
            utils.console_exec("playvol  buttons/bell1.wav 1")  
        end, true)
        self.import:tooltip("Import config")
        self.default = redrum.groups.configs.list:button("\v "..ui.get_icon("user").." ", function()
            local raw = '<redrum>_W3siYm9keXlhdyI6dHJ1ZSwiZGVmZW5zaXZlIjpmYWxzZSwiaml0dGVyb2Zmc2V0IjotNDEuMCwiaml0dGVydHlwZSI6IkNlbnRlciIsInBpdGNoIjoiRG93biIsInN3aXRjaGRlbGF5IjoyLjAsInlhd2xlZnQiOjcuMCwieWF3bW9kZSI6IkxlZnQgJiBSaWdodCIsInlhd3JpZ2h0IjoyMi4wfSx7ImJvZHl5YXciOnRydWUsImRlZmVuc2l2ZSI6dHJ1ZSwiaml0dGVyb2Zmc2V0IjotMi4wLCJqaXR0ZXJ0eXBlIjoiQ2VudGVyIiwicGl0Y2giOiJEb3duIiwic3dpdGNoZGVsYXkiOjMuMCwieWF3bGVmdCI6LTI4LjAsInlhd21vZGUiOiJUaWNrIFN3aXRjaGVyIiwieWF3cmlnaHQiOjQ1LjB9LHsiYm9keXlhdyI6dHJ1ZSwiZGVmZW5zaXZlIjpmYWxzZSwiaml0dGVyb2Zmc2V0IjotMjIuMCwiaml0dGVydHlwZSI6IkNlbnRlciIsInBpdGNoIjoiRG93biIsInN3aXRjaGRlbGF5Ijo4LjAsInlhd2xlZnQiOi0xNy4wLCJ5YXdtb2RlIjoiTGVmdCAmIFJpZ2h0IiwieWF3cmlnaHQiOjMxLjB9LHsiYm9keXlhdyI6dHJ1ZSwiZGVmZW5zaXZlIjpmYWxzZSwiaml0dGVyb2Zmc2V0IjotMjIuMCwiaml0dGVydHlwZSI6IkNlbnRlciIsInBpdGNoIjoiRG93biIsInN3aXRjaGRlbGF5Ijo4LjAsInlhd2xlZnQiOi0xNy4wLCJ5YXdtb2RlIjoiTGVmdCAmIFJpZ2h0IiwieWF3cmlnaHQiOjMxLjB9LHsiYm9keXlhdyI6dHJ1ZSwiZGVmZW5zaXZlIjpmYWxzZSwiaml0dGVyb2Zmc2V0IjotMzYuMCwiaml0dGVydHlwZSI6IkNlbnRlciIsInBpdGNoIjoiRG93biIsInN3aXRjaGRlbGF5IjozLjAsInlhd2xlZnQiOi0xMi4wLCJ5YXdtb2RlIjoiTGVmdCAmIFJpZ2h0IiwieWF3cmlnaHQiOjEyLjB9LHsiYm9keXlhdyI6dHJ1ZSwiZGVmZW5zaXZlIjpmYWxzZSwiaml0dGVyb2Zmc2V0IjotMjIuMCwiaml0dGVydHlwZSI6IkNlbnRlciIsInBpdGNoIjoiRG93biIsInN3aXRjaGRlbGF5IjozLjAsInlhd2xlZnQiOi03LjAsInlhd21vZGUiOiJMZWZ0ICYgUmlnaHQiLCJ5YXdyaWdodCI6MzEuMH0seyJib2R5eWF3Ijp0cnVlLCJkZWZlbnNpdmUiOmZhbHNlLCJqaXR0ZXJvZmZzZXQiOi0yNi4wLCJqaXR0ZXJ0eXBlIjoiQ2VudGVyIiwicGl0Y2giOiJEb3duIiwic3dpdGNoZGVsYXkiOjguMCwieWF3bGVmdCI6LTI2LjAsInlhd21vZGUiOiJMZWZ0ICYgUmlnaHQiLCJ5YXdyaWdodCI6MjYuMH0seyJkZXN5bmNsZWZ0Ijo2MC4wLCJkZXN5bmNyaWdodCI6NjAuMCwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il19LHsiZGVzeW5jbGVmdCI6NjAuMCwiZGVzeW5jcmlnaHQiOjYwLjAsImZyZWVzdGFuZGluZyI6Ik9mZiIsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdfSx7ImRlc3luY2xlZnQiOjYwLjAsImRlc3luY3JpZ2h0Ijo2MC4wLCJmcmVlc3RhbmRpbmciOiJPZmYiLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXX0seyJkZXN5bmNsZWZ0Ijo2MC4wLCJkZXN5bmNyaWdodCI6NjAuMCwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il19LHsiZGVzeW5jbGVmdCI6NjAuMCwiZGVzeW5jcmlnaHQiOjYwLjAsImZyZWVzdGFuZGluZyI6Ik9mZiIsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdfSx7ImRlc3luY2xlZnQiOjYwLjAsImRlc3luY3JpZ2h0Ijo2MC4wLCJmcmVlc3RhbmRpbmciOiJPZmYiLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXX0seyJkZXN5bmNsZWZ0Ijo2MC4wLCJkZXN5bmNyaWdodCI6NjAuMCwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il19LHsicGl0Y2giOiJVcCIsInBpdGNoX3ZhbHVlIjowLjAsInNwZWVkIjo2LjAsInlhdyI6IlNwaW4iLCJ5YXdfdmFsdWUiOjAuMH0seyJwaXRjaCI6Ilplcm8iLCJwaXRjaF92YWx1ZSI6MC4wLCJzcGVlZCI6MTIuMCwieWF3IjoiU2lkZXdheSIsInlhd192YWx1ZSI6MC4wfSx7InBpdGNoIjoiVXAiLCJwaXRjaF92YWx1ZSI6MC4wLCJzcGVlZCI6Ni4wLCJ5YXciOiJTcGluIiwieWF3X3ZhbHVlIjowLjB9LHsicGl0Y2giOiJVcCIsInBpdGNoX3ZhbHVlIjowLjAsInNwZWVkIjo2LjAsInlhdyI6IlNwaW4iLCJ5YXdfdmFsdWUiOjAuMH0seyJwaXRjaCI6IkN1c3RvbSIsInBpdGNoX3ZhbHVlIjo0NS4wLCJzcGVlZCI6OC4wLCJ5YXciOiJTcGluIiwieWF3X3ZhbHVlIjowLjB9LHsicGl0Y2giOiJDdXN0b20iLCJwaXRjaF92YWx1ZSI6NDUuMCwic3BlZWQiOjguMCwieWF3IjoiU3BpbiIsInlhd192YWx1ZSI6MC4wfSx7InBpdGNoIjoiVXAiLCJwaXRjaF92YWx1ZSI6MC4wLCJzcGVlZCI6Ni4wLCJ5YXciOiJTcGluIiwieWF3X3ZhbHVlIjowLjB9LHsiYW5pbWJ1aWxkZXIiOnRydWUsIm1hbnVhbHlhdyI6IkRpc2FibGVkIiwic2FmZWhlYWQiOlsifiJdLCJ0d2Vha3MiOlsiQXZvaWQgQmFja3N0YWIiLCJGb3JjZSBEZWZlbnNpdmUiLCJ+Il19LHsiYm9keWxlYW4iOjAuMCwibGVnc2luYWlyIjoiSml0dGVyIiwibGVnc29uZ3JvdW5kIjoiSml0dGVyIiwicGl0Y2h6ZXJvIjpmYWxzZX0seyJkZWZlbnNpdmVzdGF0ZSI6WyJTdGFuZGluZyIsIkNyb3VjaCIsIkFpciIsIkFpcitEdWNrIiwifiJdfSx7ImNyb3NzaGFpcmluZGljYXRvciI6dHJ1ZSwiY3VzdG9tc2NvcGUiOmZhbHNlLCJkYW1hZ2VvdmVycmlkZSI6dHJ1ZSwiZXZlbnRsb2dnZXIiOnRydWUsImdhbWVzZW5zZWluZGljYXRvciI6dHJ1ZSwibWFudWFsYXJyb3dzIjpmYWxzZSwid2lkZ2V0cyI6dHJ1ZX0seyJjdXN0b21zY29wZSI6eyJjb2xvciI6IiNGRkZGRkY3NiIsImdhcCI6NS4wLCJsZW5ndGgiOjEyNS4wfSwiZGFtYWdlb3ZlcnJpZGUiOnsieCI6OTYyLjAsInkiOjUyMC4wfSwiZXZlbnRsb2dnZXIiOnsiYnV5Y29sb3IiOiIjQjdDMzAwRkYiLCJoaXRjb2xvciI6IiNCMUMyRENGRiIsIm1pc3Njb2xvciI6IiNENzY0NjRGRiIsInNlbGVjdHRvc2hvdyI6WyJVbmRlciBDcm9zc2hhaXIiLCJDb25zb2xlIiwiVXBwZXItTGVmdCIsIn4iXSwidHJpZ2dlciI6WyJFbmVteSBoaXQiLCJFbmVteSBtaXNzIiwifiJdfSwiZ2FtZXNlbnNlaW5kaWNhdG9yIjp7ImFuaW1hdGlvbiI6dHJ1ZSwic2NhbGUiOiI3NSUiLCJzZWxlY3QiOlsxLjAsMi4wLDMuMCw0LjAsNS4wLDYuMCw3LjAsOC4wLDkuMCwxMC4wLDExLjAsIn4iXX0sIndpZGdldHMiOnsiZGVmZW5zaXZlX3giOjExODcuMCwiZGVmZW5zaXZlX3kiOjExNS4wLCJpbmZvcGFuZWxfeCI6MTAuMCwiaW5mb3BhbmVsX3kiOjUwMC4wLCJzZWxlY3QiOlsxLjAsIn4iXSwidmVsb2NpdHlfeCI6MTE5Ni4wLCJ2ZWxvY2l0eV95IjoyMTAuMH19LHsiYXNwZWN0cmF0aW8iOnRydWUsIm5hZGVyYWRpdXMiOnRydWUsInZpZXdtb2RlbCI6dHJ1ZX0seyJhc3BlY3RyYXRpbyI6eyJ2YWx1ZSI6MTUwLjB9LCJuYWRlcmFkaXVzIjp7Im1vbG90b3YiOiIjRkYzRjNGQkUiLCJzZWxlY3QiOlsiTW9sb3RvdiIsIlNtb2tlIiwifiJdLCJzbW9rZSI6IiMzRDkzRkFCNCJ9LCJ2aWV3bW9kZWwiOnsiZm92IjozNy4wLCJ4IjowLjAsInkiOi03LjAsInoiOjIuMH19LHsiZmFzdGxhZGRlciI6ZmFsc2UsImtpbGxzYXkiOmZhbHNlLCJsdWF0YWciOmZhbHNlLCJub2ZhbGxkYW1hZ2UiOmZhbHNlLCJzdXBlcnRvc3MiOmZhbHNlLCJ0YXNrYmFybm90aWZpY2F0aW9uIjp0cnVlLCJ1bmxvY2tsYXRlbmN5IjpmYWxzZSwidW5tdXRlbXV0ZWRwbGF5ZXJzIjp0cnVlfV0='
            local newraw = raw:gsub("<redrum>_", "")
            configsave:load(json.parse(base64.decode(newraw)))
            utils.console_exec("playvol  buttons/bell1.wav 1")  
        end, true)
        self.default:tooltip("Load default configuration")
        self.discord = redrum.groups.configs.list:button("\v"..ui.get_icon("discord").."", function()
            mtools.Panorama:OpenLink("https://discord.gg/tV8rD286Pg");
        end, true)
        self.discord:tooltip("Users configs")
    end,

    create_config = function(cfgname)
        if type(cfgname) ~= "string" then
            return
        end
    
        if cfgname == nil or cfgname == "" or cfgname == " " then
            return
        end
    
        for cfgname_0 = #configs_db.alloflist, 1, -1 do
            if configs_db.alloflist[cfgname_0] == cfgname then
                common.add_notify("redrum", "Error: error(config_name)")
    
                return
            end
        end
    
        if #configs_db.cfg_list > 6 then
            return
        end
    
        local var_cfgname = {
            cfgname,
            ""
        }
    
        table.insert(configs_db.cfg_list, var_cfgname)
        table.insert(configs_db.alloflist, cfgname)
    
        db.systemtable = configs_db
    
        common.add_notify("Success", "Created config!")
    end,
    
    remove_config = function(cfgname)
        if cfgname == 0 or configs_db.alloflist[cfgname] == nil then
            return
        end
    
        local var_cfgname = configs_db.cfg_list[cfgname][1]
    
        for cfgname_0 = #configs_db.cfg_list, 1, -1 do
            if configs_db.cfg_list[cfgname_0][1] == var_cfgname then
                table.remove(configs_db.cfg_list, cfgname_0)
                table.remove(configs_db.alloflist, cfgname_0)
            end
        end
    
        db.systemtable = configs_db
    
        common.add_notify("Success", "Removed config!")
    end,
    
    save_config = function(cfgname)
        if cfgname == 0 or configs_db.alloflist[cfgname] == nil then
            return
        end
    
        local var_cfgname = configsave:save()
    
        configs_db.cfg_list[cfgname][2] = base64.encode(json.stringify(var_cfgname))
        db.systemtable = configs_db
    
        common.add_notify("Success", " Saved config!")
    end,
    
    load_config = function(cfgname)
        if cfgname == 0 or configs_db.alloflist[cfgname] == nil then
            return
        end
    
        if configs_db.cfg_list[cfgname][2] == nil or configs_db.cfg_list[cfgname][2] == "" then
            print(string.format("Error[%s]", cfgname))
            return
        end
    
        if cfgname > #configs_db.cfg_list then
            print(string.format("Error[%s]", cfgname))
            return
        end
    
        configsave:load(json.parse(base64.decode(configs_db.cfg_list[cfgname][2])))
        common.add_notify("Success", "Loaded config!")
    end
}
configs:menu_config()
configs.configlist:update(configs_db.alloflist)

local visibler = {
    antiaim = function(self)
        local arg = (rui['tab_select']:get() == 1)
        local active_i = antiaim.player_states_idx[antiaim.builder.state:get()]
        antiaim.selection:visibility(arg)
        antiaim.builder.state:visibility(arg and antiaim.selection:get() == 1)
        antiaim.additionals.manualyaw:visibility(arg and antiaim.selection:get() == 2)
        antiaim.additionals.safehead:visibility(arg and antiaim.selection:get() == 2)
        antiaim.additionals.tweaks:visibility(arg and antiaim.selection:get() == 2)
        antiaim.additionals.animbuilder:visibility(arg and antiaim.selection:get() == 2)

        antiaim.tweaks_group.defensivestate:visibility(arg and antiaim.selection:get() == 2 and antiaim.additionals.tweaks:get("Force Defensive"))

        antiaim.animbuilder_group.legsonground:visibility(arg and antiaim.selection:get() == 2 and antiaim.additionals.animbuilder:get())
        antiaim.animbuilder_group.legsinair:visibility(arg and antiaim.selection:get() == 2 and antiaim.additionals.animbuilder:get())
        antiaim.animbuilder_group.pitchzero:visibility(arg and antiaim.selection:get() == 2 and antiaim.additionals.animbuilder:get())
        antiaim.animbuilder_group.bodylean:visibility(arg and antiaim.selection:get() == 2 and antiaim.additionals.animbuilder:get())
        for i = 1,7 do 
            local arg_loop = active_i == i and arg and antiaim.selection:get() == 1
            antiaim.options[i].pitch:visibility(arg_loop)
            antiaim.options[i].yawmode:visibility(arg_loop)
            antiaim.options[i].yawleft:visibility(arg_loop)
            antiaim.options[i].yawright:visibility(arg_loop)
            antiaim.options[i].switchdelay:visibility(arg_loop and antiaim.options[i].yawmode:get() == "Tick Switcher")
            antiaim.options[i].jittertype:visibility(arg_loop)
            antiaim.options[i].jitteroffset:visibility(arg_loop and antiaim.options[i].jittertype:get() ~= "Disabled")
            antiaim.options[i].bodyyaw:visibility(arg_loop)
            antiaim.options[i].defensive:visibility(arg_loop)
            antiaim.bodyyaw[i].desyncleft:visibility(arg_loop and antiaim.options[i].bodyyaw:get())
            antiaim.bodyyaw[i].desyncright:visibility(arg_loop and antiaim.options[i].bodyyaw:get())
            antiaim.bodyyaw[i].options:visibility(arg_loop and antiaim.options[i].bodyyaw:get() and antiaim.options[i].yawmode:get() == "Left & Right")
            antiaim.bodyyaw[i].freestanding:visibility(arg_loop and antiaim.options[i].bodyyaw:get())
            antiaim.defensive[i].speed:visibility(arg_loop and antiaim.options[i].defensive:get())
            antiaim.defensive[i].pitch:visibility(arg_loop and antiaim.options[i].defensive:get())
            antiaim.defensive[i].pitch_value:visibility(arg_loop and antiaim.options[i].defensive:get() and antiaim.defensive[i].pitch:get() == "Custom")
            antiaim.defensive[i].yaw:visibility(arg_loop and antiaim.options[i].defensive:get())
            antiaim.defensive[i].yaw_value:visibility(arg_loop and antiaim.options[i].defensive:get() and antiaim.defensive[i].yaw:get() == "Custom")
        end
    end,

    visuals = function(self)
        local arg = (rui['tab_select']:get() == 2)
        visuals.selection:visibility(arg)
        visuals.accentcolor:visibility(arg and visuals.selection:get() == 1)

        visuals.screen.customscope:visibility(arg and visuals.selection:get() == 1)
        visuals.screen_group.customscope.length:visibility(arg and visuals.selection:get() == 1 and visuals.screen.customscope:get())
        visuals.screen_group.customscope.gap:visibility(arg and visuals.selection:get() == 1 and visuals.screen.customscope:get())
        visuals.screen_group.customscope.color:visibility(arg and visuals.selection:get() == 1 and visuals.screen.customscope:get())

        local eventloggerarg = visuals.screen_group.eventlogger.selecttoshow:get("Under Crosshair") or visuals.screen_group.eventlogger.selecttoshow:get("Console") or visuals.screen_group.eventlogger.selecttoshow:get("Upper-Left")
        visuals.screen.eventlogger:visibility(arg and visuals.selection:get() == 1)
        visuals.screen_group.eventlogger.selecttoshow:visibility(arg and visuals.selection:get() == 1 and visuals.screen.eventlogger:get())
        visuals.screen_group.eventlogger.trigger:visibility(arg and visuals.selection:get() == 1 and visuals.screen.eventlogger:get() and eventloggerarg)
        visuals.screen_group.eventlogger.hitcolor:visibility(arg and visuals.selection:get() == 1 and visuals.screen.eventlogger:get() and visuals.screen_group.eventlogger.trigger:get("Enemy hit") and eventloggerarg)
        visuals.screen_group.eventlogger.misscolor:visibility(arg and visuals.selection:get() == 1 and visuals.screen.eventlogger:get() and visuals.screen_group.eventlogger.trigger:get("Enemy miss") and eventloggerarg)
        visuals.screen_group.eventlogger.buycolor:visibility(arg and visuals.selection:get() == 1 and visuals.screen.eventlogger:get() and visuals.screen_group.eventlogger.trigger:get("Purchases") and eventloggerarg)

        visuals.screen.gamesenseindicator:visibility(arg and visuals.selection:get() == 1)
        visuals.screen_group.gamesenseindicator.animation:visibility(arg and visuals.selection:get() == 1 and visuals.screen.gamesenseindicator:get())
        visuals.screen_group.gamesenseindicator.scale:visibility(arg and visuals.selection:get() == 1 and visuals.screen.gamesenseindicator:get())
        visuals.screen_group.gamesenseindicator.select:visibility(arg and visuals.selection:get() == 1 and visuals.screen.gamesenseindicator:get())
        
        visuals.screen.damageoverride:visibility(arg and visuals.selection:get() == 1)
        visuals.screen_group.damageoverride.x:visibility(false)
        visuals.screen_group.damageoverride.y:visibility(false)

        visuals.screen_group.widgets.defensive_x:visibility(false)
        visuals.screen_group.widgets.defensive_y:visibility(false)

        visuals.screen_group.widgets.infopanel_x:visibility(false)
        visuals.screen_group.widgets.infopanel_y:visibility(false)

        visuals.screen_group.widgets.velocity_x:visibility(false)
        visuals.screen_group.widgets.velocity_y:visibility(false)

        visuals.screen.widgets:visibility(arg and visuals.selection:get() == 1)
        visuals.screen_group.widgets.select:visibility(arg and visuals.selection:get() == 1 and visuals.screen.widgets:get())

        visuals.screen.manualarrows:visibility(arg and visuals.selection:get() == 1)

        visuals.screen.crosshairindicator:visibility(arg and visuals.selection:get() == 1)

        visuals.ingame.viewmodel:visibility(arg and visuals.selection:get() == 2)
        visuals.ingame_group.viewmodel.fov:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.viewmodel:get())
        visuals.ingame_group.viewmodel.x:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.viewmodel:get())
        visuals.ingame_group.viewmodel.y:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.viewmodel:get())
        visuals.ingame_group.viewmodel.z:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.viewmodel:get())

        visuals.ingame.aspectratio:visibility(arg and visuals.selection:get() == 2)
        visuals.ingame_group.aspectratio.value:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.aspectratio:get())
        visuals.ingame_group.aspectratio._54:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.aspectratio:get())
        visuals.ingame_group.aspectratio._43:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.aspectratio:get())
        visuals.ingame_group.aspectratio._32:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.aspectratio:get())
        visuals.ingame_group.aspectratio._1610:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.aspectratio:get())
        visuals.ingame_group.aspectratio._169:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.aspectratio:get())
        visuals.ingame_group.aspectratio._21:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.aspectratio:get())

        visuals.ingame.naderadius:visibility(arg and visuals.selection:get() == 2)
        visuals.ingame_group.naderadius.select:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.naderadius:get())
        visuals.ingame_group.naderadius.molotov:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.naderadius:get() and visuals.ingame_group.naderadius.select:get(1))
        visuals.ingame_group.naderadius.smoke:visibility(arg and visuals.selection:get() == 2 and visuals.ingame.naderadius:get() and visuals.ingame_group.naderadius.select:get(2))
    end,

    misc = function(self)
        local arg = (rui['tab_select']:get() == 3)
        misc.main.unmutemutedplayers:visibility(arg)
        misc.main.taskbarnotification:visibility(arg)
        misc.main.unlocklatency:visibility(arg)
        misc.main.killsay:visibility(arg)
        misc.main.luatag:visibility(arg)
        misc.main.supertoss:visibility(arg)
        misc.main.fastladder:visibility(arg)
        misc.main.nofalldamage:visibility(arg)
    end,

    configs = function(self)
        local arg = (rui['tab_select']:get() == 4)
        configs.configname_input:visibility(arg)
        configs.configlist:visibility(arg)
        configs.create:visibility(arg)
        configs.remove:visibility(arg)
        configs.save:visibility(arg)
        configs.load:visibility(arg)
        configs.import:visibility(arg)
        configs.export:visibility(arg)
        configs.default:visibility(arg)
        configs.discord:visibility(arg)
    end,

    menu = function(self)
        local color = ui.get_style("Link Active"):to_hex()

        if rui['tab_select']:get() == 1 then
            rui['tab_select']:update("\a"..color..ui.get_icon("user-shield").."  \rAnti Aim", ui.get_icon("paintbrush").."   \rVisuals", ui.get_icon("gear").."    \rMisc", ui.get_icon("folder").."    \rConfigs")
        elseif rui['tab_select']:get() == 2 then
            rui['tab_select']:update(ui.get_icon("user-shield").."  \rAnti Aim", "\a"..color..ui.get_icon("paintbrush").."   \rVisuals", ui.get_icon("gear").."    \rMisc", ui.get_icon("folder").."    \rConfigs")
        elseif rui['tab_select']:get() == 3 then
            rui['tab_select']:update(ui.get_icon("user-shield").."  \rAnti Aim", ui.get_icon("paintbrush").."   \rVisuals", "\a"..color..ui.get_icon("gear").."    \rMisc", ui.get_icon("folder").."    \rConfigs")
        elseif rui['tab_select']:get() == 4 then
            rui['tab_select']:update(ui.get_icon("user-shield").."  \rAnti Aim", ui.get_icon("paintbrush").."   \rVisuals", ui.get_icon("gear").."    \rMisc", "\a"..color..ui.get_icon("folder").."    \rConfigs")
        end

        if antiaim.selection:get() == 1 then
            antiaim.selection:update("\a"..color.."›  \rBuilder", "\v•  \rAdditionals")
        elseif antiaim.selection:get() == 2 then
            antiaim.selection:update("•  \rBuilder", "\a"..color.."›  \rAdditionals")
        end

        if visuals.selection:get() == 1 then
            visuals.selection:update("\a"..color.."›  \rScreen", "\v•  \rIn Game")
        elseif visuals.selection:get() == 2 then
            visuals.selection:update("•  \rScreen", "\a"..color.."›  \rIn Game")
        end

        self:antiaim()
        self:visuals()
        self:misc()
        self:configs()

    end,
}


configsave = pui.setup({
    antiaim.options[1],
    antiaim.options[2],
    antiaim.options[3],
    antiaim.options[4],
    antiaim.options[5],
    antiaim.options[6],
    antiaim.options[7],
    antiaim.bodyyaw[1],
    antiaim.bodyyaw[2],
    antiaim.bodyyaw[3],
    antiaim.bodyyaw[4],
    antiaim.bodyyaw[5],
    antiaim.bodyyaw[6],
    antiaim.bodyyaw[7],
    antiaim.defensive[1],
    antiaim.defensive[2],
    antiaim.defensive[3],
    antiaim.defensive[4],
    antiaim.defensive[5],
    antiaim.defensive[6],
    antiaim.defensive[7],
    antiaim.additionals,
    antiaim.animbuilder_group,
    antiaim.tweaks_group,
    visuals.screen,
    visuals.screen_group,
    visuals.ingame,
    visuals.ingame_group,
    misc.main,
}, true)

events.render:set(function()
    damageoverride_drag:update()
    defensive_drag:update()
    velocity_drag:update()
    infopanel_drag:update()
    visuals:eventlogger_draw()
    visuals:gamesenseindicator()
    visuals:naderadius()
    visuals:aspectratio()
    visuals:viewmodel()
    visuals:customscope()
    visuals:manualarrows()
    visuals:indicators()
    visuals:watermark()
    misc:unlocklatency()
    visibler:menu()
end)

events.createmove:set(function(cmd)
    antiaim:main(cmd)
    antiaim:breaklc(cmd)
    antiaim:pitch_0_ticks(cmd)
    misc:supertoss_on_createmove(cmd)
    misc:fastladder(cmd)
    misc:nofalldamage(cmd)
end)

events.player_hurt:set(function(e)
    visuals:eventlogger_hit(e)
end)

events.aim_ack:set(function(e)
    visuals:eventlogger_miss(e)
end)

events.item_purchase:set(function(e)
    visuals:eventlogger_purchases(e)
end)

events.round_start:set(function() misc:taskbarnotification() misc:unmutemutedplayers() end)
events.player_death:set(function(e) misc:killsay(e) end)
events.post_update_clientside_animation(function() antiaim:animbuilder() end)
events.pre_render:set(function() misc:supertoss_on_pre_render() misc:luatag() end)
events.override_view:set(function() misc:supertoss_on_override_view() end)
