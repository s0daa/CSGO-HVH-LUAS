-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local obex_data = obex_fetch and obex_fetch() or {username = "coder", build = "source", discord = "morcao"}

username = obex_data.username
version = obex_data.build

local ffi = require 'ffi'
local pui = require("gamesense/pui")
local vector = require("vector")
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard")
local inspect = require("gamesense/inspect")
local weapons = require("gamesense/csgo_weapons")
local antiaim = require 'gamesense/antiaim_funcs'

ffi.cdef[[
	struct animation_layer_t {
		char pad20[24];
		uint32_t m_nSequence;
		float m_flPrevCycle;
		float m_flWeight;
		char pad20[4];
		float m_flPlaybackRate;
		float m_flCycle;
		void *m_pOwner;
		char pad_0038[ 4 ];
	};
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
        char pad4465[ 4 ];
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    };
]]

local crr_t = ffi.typeof('void*(__thiscall*)(void*)')
local cr_t = ffi.typeof('void*(__thiscall*)(void*)')
local gm_t = ffi.typeof('const void*(__thiscall*)(void*)')
local gsa_t = ffi.typeof('int(__fastcall*)(void*, void*, int)')

local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)

local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
local get_client_networkable = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][0]) or error('get_client_networkable_t is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity is nil', 2)

local rawivmodelinfo = client.create_interface('engine.dll', 'VModelInfoClient004')
local ivmodelinfo = ffi.cast(classptr, rawivmodelinfo) or error('rawivmodelinfo is nil', 2)
local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', ivmodelinfo[0][32])

local seq_activity_sig = client.find_signature('client.dll','\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83')

local function get_model(b)if b then b=ffi.cast(classptr,b)local c=ffi.cast(crr_t,b[0][0])local d=c(b)or error('error getting client unknown',2)if d then d=ffi.cast(classptr,d)local e=ffi.cast(cr_t,d[0][5])(d)or error('error getting client renderable',2)if e then e=ffi.cast(classptr,e)return ffi.cast(gm_t,e[0][8])(e)or error('error getting model_t',2)end end end end
local function get_sequence_activity(b,c,d)b=ffi.cast(classptr,b)local e=get_studio_model(ivmodelinfo,get_model(c))if e==nil then return-1 end;local f=ffi.cast(gsa_t, seq_activity_sig)return f(b,e,d)end
local function get_anim_layer(b,c)c=c or 1;b=ffi.cast(classptr,b)return ffi.cast('struct animation_layer_t**',ffi.cast('char*',b)+0x2990)[0][c]end

json.encode_sparse_array(true)

local new_class = function()
	local mt, mt_data, this_mt = { }, { }, { }

	mt.__metatable = false
	mt_data.struct = function(self, name)
		assert(type(name) == 'string', 'invalid class name')
		assert(rawget(self, name) == nil, 'cannot overwrite subclass')

		return function(data)
			assert(type(data) == 'table', 'invalid class data')
			rawset(self, name, setmetatable(data, {
				__metatable = false,
				__index = function(self, key)
					return
						rawget(mt, key) or
						rawget(this_mt, key)
				end
			}))

			return this_mt
		end
	end

	this_mt = setmetatable(mt_data, mt)

	return this_mt
end

table.indexOf = function ( tab, value )
  for index, val in ipairs(tab) do
    if value == val then
      return index
    else
      return -1
    end
  end
end

local ctx = new_class()
    :struct 'globals' {
        teams = {'Terrorist', 'Counter-terrorist'},
        states = {'Global', 'Stand', 'Run', 'Jump', 'Duck', 'Duck move', 'Duck jump', 'Slow move', 'Fake lag', 'Dormant', 'Hide shots', 'Height'},
		disabler_states = {'Stand', 'Run', 'Jump', 'Duck', 'Duck move', 'Duck jump', 'Slow move'},
		in_ladder = 0,
		nade = 0,
    }

    :struct 'ref' {
		aa = {
			enabled = {ui.reference("aa", "anti-aimbot angles", "enabled")},
			pitch = {ui.reference("aa", "anti-aimbot angles", "pitch")},
			yaw_base = {ui.reference("aa", "anti-aimbot angles", "Yaw base")},
			yaw = {ui.reference("aa", "anti-aimbot angles", "Yaw")},
			yaw_jitter = {ui.reference("aa", "anti-aimbot angles", "Yaw Jitter")},
			body_yaw = {ui.reference("aa", "anti-aimbot angles", "Body yaw")},
			freestanding_body_yaw = {ui.reference("aa", "anti-aimbot angles", "Freestanding body yaw")},
			freestand = {ui.reference("aa", "anti-aimbot angles", "Freestanding")},
			roll = {ui.reference("aa", "anti-aimbot angles", "Roll")},
			edge_yaw = {ui.reference("aa", "anti-aimbot angles", "Edge yaw")}
		},
		fakelag = {
			enable = {ui.reference("aa", "fake lag", "enabled")},
			amount = {ui.reference("aa", "fake lag", "amount")},
			variance = {ui.reference("aa", "fake lag", "variance")},
			limit = {ui.reference("aa", "fake lag", "limit")},
		},
        other = {
            slow_motion = {ui.reference("aa", "other", "Slow motion")},
            leg_movement = {ui.reference("aa", "other", "Leg movement")},
            on_shot = {ui.reference("aa", "other", "On shot anti-aim")},
            fake_peek = {ui.reference("aa", "other", "Fake peek")}
        },
		rage = {
			sp = {ui.reference('rage', 'aimbot', 'Force safe point')},
			fb = {ui.reference('rage', 'aimbot', 'Force body aim')},
			dt = {ui.reference("rage", "aimbot", "Double tap")},
			dt_limit = {ui.reference("rage", "aimbot", "Double tap fake lag limit")},
			fd = {ui.reference("rage", "other", "Duck peek assist")},
			os = {ui.reference("aa", "other", "On shot anti-aim")},
			silent = {ui.reference("rage", "Other", "Silent aim")},
			dmg_override = {ui.reference('rage', 'aimbot', 'Minimum damage override')}
		}
	}

    :struct 'helpers' {
		
		contains = function (self, table, value)
		    for v, k in pairs(table) do
		        if k == value or v == value then return true; end
		    end
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
				t_out[t_out_iter] = "\a" .. self:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )
	
				t_out[t_out_iter + 1] = string:sub( i, i )
	
				t_out_iter = t_out_iter + 2
			end
	
			return t_out
		end,

		easeInOut = function(self, t)
			return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
		end,

		rgba_to_hex = function(self, r, g, b, a)
		  return bit.tohex(
		    (math.floor(r + 0.5) * 16777216) + 
		    (math.floor(g + 0.5) * 65536) + 
		    (math.floor(b + 0.5) * 256) + 
		    (math.floor(a + 0.5))
		  )
		end,

		round = function (self, num, decimals)
			local mult = 10^(decimals or 0)
			return math.floor(num * mult + 0.5) / mult
		end,

        menu_visibility = function(self, visible)
            for _, name in ipairs({"aa", "other", "fakelag"}) do
			    for _, v in pairs(self.ref[name]) do
			    	for _, item in ipairs(v) do
			    		ui.set_visible(item, visible)
			    	end
			    end
            end
		end,

        string_join = function (self, arr)
            local str = ""
            for k, v in pairs(arr) do
                if type(v) == "string" then
                    str = str .. v
                else
                    return error('expected "string", got ' .. type(v))
                end
            end

            return str
        end,

        first_upper = function(self, str)
            return (str:gsub("^%l", string.upper))
        end,

		color_to_string = function (self, color)
			local r, g, b, a = unpack(color)
			return string.format("\a%02x%02x%02x%02x", r, g, b, a)
		end,

		rgba_lerp = function(self, from, to, percent)
			local arr = {}
			for i, v in ipairs(from) do
				arr[i] = v + (to[i] - v) * percent
			end
			return arr
		end,

        gradient_text = function(self, rgba1, rgba2, str )
            local t_out, t_out_iter = { }, 1
        
            local l = str:len( ) - 1
        
            local r_add = (rgba2.r - rgba1.r) / l
            local g_add = (rgba2.g - rgba1.g) / l
            local b_add = (rgba2.b - rgba1.b) / l
            local a_add = (rgba2.a - rgba1.a) / l
        
            for iter = 1, #str do
                t_out[t_out_iter] = ('\a%02x%02x%02x%02x'):format( rgba1.r + r_add * ( iter - 1 ), rgba1.g + g_add * ( iter - 1 ), rgba1.b + b_add * ( iter - 1 ), rgba1.a + a_add * ( iter - 1 ) )
            
                t_out[t_out_iter + 1] = str:sub( iter, iter )
            
                t_out_iter = t_out_iter + 2
            end
        
            return t_out
        end,

        clamp = function(self, val, lower, upper)
			assert(val and lower and upper, "not very useful error message here")
			if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
			return math.max(lower, math.min(upper, val))
		end,

		normalize = function(self, angle)
			angle =  angle % 360 
			angle = (angle + 360) % 360
			if (angle > 180)  then
				angle = angle - 360
			end
			return angle
		end,

        time_to_ticks = function(self, t)
			return math.floor(0.5 + (t / globals.tickinterval()))
		end,

        get_charge = function ()
			local me = entity.get_local_player()
			local simulation_time = entity.get_prop(entity.get_local_player(), "m_flSimulationTime")
			return (globals.tickcount() - simulation_time/globals.tickinterval())
		end,

        in_ladder = function(self)
			local me = entity.get_local_player()

			if entity.is_alive(me) then
				if entity.get_prop(me, "m_MoveType") == 9 then
					self.globals.in_ladder = globals.tickcount() + 8
				end
			else
				self.globals.in_ladder = 0
			end

		end,

		in_air = function(self, ent)
			local flags = entity.get_prop(ent, "m_fFlags")
			return bit.band(flags, 1) == 0
		end,

		in_duck = function(self, ent)
			local flags = entity.get_prop(ent, "m_fFlags")
			return bit.band(flags, 4) == 4
		end,

		get_state = function(self)
			local me = entity.get_local_player()
			local velocity = vector(entity.get_prop(me, "m_vecVelocity")):length2d()
			
			if self:in_air(me) then
				return self:in_duck(me) and "Duck jump" or "Jump"
			else
				if ui.get(self.ref.other.slow_motion[1]) and ui.get(self.ref.other.slow_motion[2]) then
					return "Slow move"
				elseif self:in_duck(me) then
					return velocity > 15 and "Duck move" or "Duck"
				else
					return velocity > 1.5 and "Run" or "Stand"
				end
			end
		end,

		get_team = function(self)
			local me = entity.get_local_player()
			local index = entity.get_prop(me, "m_iTeamNum")

			return index == 2 and "Terrorist" or "Counter-terrorist"
		end,

		in_height = function (self)
			local me = entity.get_local_player()
			local target = client.current_threat()

			if not me or not entity.is_alive(me) or not target then
				return false
			end

			local pos = vector(entity.get_origin(me))
			local epos = vector(entity.get_origin(target))

			pitch = (epos - pos):angles()

			return pitch > 30
		end
    }

    :struct 'ui' {
        menu = {
            global = {},
            other = {},
            home = {},
            antiaim = {},
			settings = {},
        },

        execute = function (self)
            pui.macros.accent = "\abb96ffff"
            pui.macros.dark = "\affffff64"
            pui.macros.red = "\aff9696ff"
            pui.macros.dot_dark = '\affffff64•\r  '
            pui.macros.dot = '\abb96ffff•\r  '

            local global = pui.group('AA', 'Fake lag')

            local name = self.helpers:gradient_text({ r = 187, g = 150, b = 255, a = 255 }, { r = 187, g = 150, b = 255, a = 55 }, "lavender")

            self.menu.global.main = global:checkbox(self.helpers:string_join(name))
            self.menu.global.main:set_callback(function (item)
                self.helpers:menu_visibility(not item.value)
            end)
            self.menu.global.colored_line = global:label('\f<accent>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯')
            self.menu.global.tab = global:combobox("\n", {'Home', 'Antiaim', 'Settings'})
            self.menu.global.user = global:label('\f<dark>User  \r' .. username)
            self.menu.global.version = global:label('\f<dark>Version  \r' .. version)
			self.menu.global.space = global:label('\n')

            local other = pui.group('AA', 'Other')

            self.menu.home.label = other:label('\f<dot>New config')
            self.menu.home.line1 = other:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n line')
            self.menu.home.name = other:textbox('\n name')
            self.menu.home.create = other:button('Create', function ()
                self.config:create()
            end)
            self.menu.home.import = other:button('Import', function ()
                self.config:import(clipboard.get(), 'config')
            end)

            self.menu.home.space = other:label('\n')

            self.menu.home.other_label = other:label('\f<dot>Discord')
            self.menu.home.line2 = other:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯')
            self.menu.home.join_discord = other:button('Join us', function ()
				local js = panorama.open()

				js.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.com/invite/antiaim");
			end)

            local group = pui.group('AA', 'Anti-aimbot angles')

            self.menu.home.name2 = group:label('\f<dot>Your configs')
            self.menu.home.line3 = group:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n home')
            self.menu.home.list = group:listbox('\n', {})
            self.menu.home.selected_config = group:label("Selected: \f<red>" .. "NONE")
            self.menu.home.load = group:button('\f<accent> Load', function ()
                self.config:load()
            end)
            self.menu.home.save = group:button('Save', function ()
                self.config:save()
            end)
            self.menu.home.export = group:button('Export', function ()
                clipboard.set(self.config:export('config'))
            end)
            self.menu.home.delete = group:button('\f<red>Delete', function ()
                self.config:delete()
            end)

			--self.menu.misc.space2 = group:label('\n space2')

            self.menu.antiaim.label1 = global:label('\f<dot>Antiaim')
            self.menu.antiaim.line1 = global:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n antiaim other')
            self.menu.antiaim.mode = global:combobox('Mode', {'Builder'}) -- 'Preset', 'Logic'

			self.menu.antiaim.other = other:label('\f<dot>Other')
			self.menu.antiaim.line2 = other:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n antiaim other 2')

			self.menu.antiaim.edge_yaw = other:hotkey('\f<dot_dark>Edge yaw')

			self.menu.antiaim.freestand_options = other:multiselect('Freestanding', {'Force static', 'Disablers'}) -- 'Safe mode', 'Custom'
			self.menu.antiaim.freestand_key = other:hotkey('\n Freestanding key', true)
			self.menu.antiaim.freestand_disablers = other:multiselect('\n freestanding disablers', self.globals.disabler_states):depend({self.menu.antiaim.freestand_options, 'Disablers'})

			--self.menu.misc.space1 = group:label('\n space 1')

			self.menu.antiaim.manual_mode = other:combobox('Manual yaw', {'Default', 'Mouse direction'})
			self.menu.antiaim.manual_global = other:hotkey('\n manual mouse mode key', true):depend({self.menu.antiaim.manual_mode, 'Mouse direction'})
			self.menu.antiaim.manual_left = other:hotkey('\f<dot_dark>Left'):depend({self.menu.antiaim.manual_mode, 'Default'})
			self.menu.antiaim.manual_right = other:hotkey('\f<dot_dark>Right'):depend({self.menu.antiaim.manual_mode, 'Default'})
			self.menu.antiaim.manual_forward = other:hotkey('\f<dot_dark>Forward'):depend({self.menu.antiaim.manual_mode, 'Default'})


            self.menu.antiaim.builder = {}

            self.menu.antiaim.builder.label = group:label('\f<dot>Conditions')
            --self.menu.antiaim.builder.line = group:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n antiaim builder')
			self.menu.antiaim.builder.state = group:combobox('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n state', self.globals.states)
            self.menu.antiaim.builder.team = group:combobox('\nTeam', self.globals.teams)
			self.menu.antiaim.builder.space = group:label('\n space')
            self.menu.antiaim.builder.states = {}

            for _, team in ipairs(self.globals.teams) do
                self.menu.antiaim.builder.states[team] = {}
                for _, state in ipairs(self.globals.states) do
                    self.menu.antiaim.builder.states[team][state] = {}
                    local menu = self.menu.antiaim.builder.states[team][state]

                    pui.macros.ext = "\n " .. team .. state

                    if state ~= "Global" then
						menu.enable = group:checkbox('Activate' .. '\f<ext>')
					end

					local stuff = '\f<accent>' .. string.lower(state) .. '\r \f<accent>' .. (team == "Terrorist" and 't' or 'ct') .. '\r • '

					menu.yaw_label = group:label('\f<dot> Yaw' .. '\f<ext>')
					menu.yaw_line = group:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n yaw' .. '\f<ext>')

                    menu.yaw = group:combobox('Yaw' .. '\f<ext>', {'Off', '180', 'Spin', 'Static', '180-z', 'Crosshair'})
					menu.yaw_base = group:checkbox('\f<dot_dark> At targets' .. '\f<ext>'):depend({menu.yaw, 'Off', true})
					menu.multiply = group:checkbox('\f<dot_dark> Multiply yaw' .. '\f<ext>'):depend({menu.yaw, 'Off', true})
                    menu.yaw_single = group:slider('Offset' .. '\f<ext>', -180, 180, 0, true, '°', 1):depend({menu.yaw, 'Off', true}, {menu.multiply, false})
                    menu.yaw_multiple_left = group:slider('Offset left' .. '\f<ext>', -180, 180, 0, true, '°', 1):depend({menu.yaw, 'Off', true}, {menu.multiply, true})
                    menu.yaw_multiple_right = group:slider('Offset right' .. '\f<ext>', -180, 180, 0, true, '°', 1):depend({menu.yaw, 'Off', true}, {menu.multiply, true})
					menu.yaw_space = group:label('\n\f<ext>'):depend({menu.yaw, 'Off', true})
					menu.yaw_jitter = group:combobox('Type' .. '\f<ext>', {'Off', 'Offset', 'Center', 'Random', 'Skitter'}):depend({menu.yaw, 'Off', true})
                    menu.yaw_jitter_value = group:slider('Variance' .. '\f<ext>', -180, 180, 0, true, '°', 1):depend({menu.yaw, 'Off', true}, {menu.yaw_jitter, 'Off', true})

					menu.desync_space = group:label('\n desync space' ..  '\f<ext>')
					menu.desync_label = group:label('\f<dot> Desync' .. '\f<ext>')
					menu.desync_line = group:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n desync' .. '\f<ext>')

                    menu.desync_mode = group:combobox('Mode' .. '\f<ext>', {'Off', 'Gamesense', 'Lavender'})
                    menu.body_yaw = group:combobox('\n' .. '\f<ext>', {'Jitter', 'Static', 'Opposite'}):depend({menu.desync_mode, 'Off', true})
                    menu.body_yaw_side = group:combobox('Side' .. '\f<ext>', {'Left', 'Right', 'Freestand'}):depend({menu.body_yaw, 'Jitter', true}, {menu.desync_mode, 'Off', true})

					menu.other_space = group:label('\n extras space' ..  '\f<ext>'):depend({menu.yaw, 'Off', true})
					menu.other_label = group:label('\f<dot> Extras' .. '\f<ext>'):depend({menu.yaw, 'Off', true})
					menu.other_line = group:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n extras' .. '\f<ext>'):depend({menu.yaw, 'Off', true})

                    menu.jitter_delay = group:slider('Variance delay' .. '\f<ext>', 1, 4, 1, true, 't', 1, {'Disabled', 'Normal', 'Slow', 'Slowest'}):depend({menu.yaw, 'Off', true})
					
                    for _, v in pairs(menu) do
						local arr =  { {self.menu.antiaim.builder.state, state}, {self.menu.antiaim.builder.team, team}, {self.menu.antiaim.mode, "Builder"} }
						if _ ~= "enable" and state ~= "Global" then
							arr =  { {self.menu.antiaim.builder.state, state}, {self.menu.antiaim.builder.team, team}, {self.menu.antiaim.mode, "Builder"}, {menu.enable, true} }
						end

						v:depend(table.unpack(arr))
					end
                end
            end

			self.menu.settings.label1 = group:label('\f<dot>Visuals')
			self.menu.settings.line1 = group:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n visuals' )

			self.menu.settings.crosshair = group:combobox('Crosshair style', {'-', 'Default', 'New'})
			self.menu.settings.accent = group:color_picker('\n', 255, 255, 255, 255):depend({self.menu.settings.crosshair, 'New'})
			self.menu.settings.crosshair_size = group:combobox('Crosshair size', {'small', 'normal', 'bold'}):depend({self.menu.settings.crosshair, 'New'}, {self.menu.settings.crosshair, '-', true})
			--self.menu.settings.crosshair_options = group:multiselect('\n xhair options', {'Double tap', 'On-shot aa', 'Force baim', 'Force safe point', 'Defensive status'}):depend({self.menu.settings.crosshair, '-', true})
			self.menu.settings.damage_indicator = group:checkbox('\f<dot_dark>Damage indicator')
			--self.menu.settings.watermark = group:checkbox('\f<dot_dark>Watermark')
			--self.menu.settings.slow_down = group:checkbox('\f<dot_dark>Slowdown warning')
			--self.menu.settings.defensive = group:checkbox('\f<dot_dark>Defensive status')
			--self.menu.settings.event_logger = group:multiselect('Event logger', {'Damage input', 'Damage output', 'Antiaim information'})

			self.menu.settings.space2 = group:label('\n Misc')
			self.menu.settings.label2 = group:label('\f<dot>Misc')
			self.menu.settings.line2 = group:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n Misc' )
			self.menu.settings.fast_ladder = group:checkbox('Fast ladder')
			self.menu.settings.clan_tag = group:checkbox('Clan tag')
			self.menu.settings.kill_say = group:checkbox('Kill say')
			self.menu.settings.animations = group:multiselect('Animations', {''})


			--self.menu.settings.space3 = group:label('\n Rage')
			--self.menu.settings.label3 = group:label('\f<dot>Rage')
			--self.menu.settings.line3 = group:label('\f<dark>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n Rage' )

            for tab, arr in pairs(self.menu) do
				if type(arr) == "table" then
					Loop = function (arr)
						for _, v in pairs(arr) do
							if type(v) == "table" then
								if v.__type == "pui::element" then
                                    if v ~= self.menu.global.main then
                                        v:depend({self.menu.global.main, true})
                                    end
                                    if tab ~= 'global' then
                                        v:depend({self.menu.global.tab, self.helpers:first_upper(tab)})
                                    end
								else
									Loop(v, tab)
								end
							end
						end
					end

					Loop(arr)
				end
			end
        end
    }

    :struct  'config' {
        configs = {},

        write_file = function (self, path, data)
			if not data or type(path) ~= "string" then
				return
			end

			return writefile(path, json.stringify(data))
		end,

        get_selected = function (self)
			local index = self.ui.menu.home.list()
            if not index then
                return
            end

			local i = 1
            
            for name, v in pairs(self.configs) do
                if i == index + 1 then
                    return name
                end
                i = i + 1
            end
		end,

		update_configs = function (self, name)
			local names = {}
            local i = 0
			for k, v in pairs(self.configs) do
				table.insert(names, k)
                if k == name then
                    i = #names
                end
			end
			
			if #names > 0 then
                self.ui.menu.home.list(i - 1)
            end

            ui.update(self.ui.menu.home.list.ref, names)
			self:write_file("lavender_configs.txt", self.configs)
		end,

		setup = function (self)
			local data = readfile('lavender_configs.txt')
			if data == nil then
				self.configs = {}
				return
			end

			self.configs = json.parse(data)

			self:update_configs()
		end,

        export_config = function(self, ...)
			local config = pui.setup({self.ui.menu.antiaim, self.ui.menu.aimbot})

			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )

			return encrypted
		end,

		export_state = function (self, team, state)
			local config = pui.setup({self.ui.menu.antiaim.builder.states[team][state]})

			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )

			return encrypted
		end,

		export_team = function (self, team)
			local config = pui.setup({self.ui.menu.antiaim.builder.states[team]})

			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )

			return encrypted
		end,

		export = function (self, type, ...)
			local success, result = pcall(self['export_' .. type], self, ...)
			if not success then
                print(result)
				return
			end

			return "{lavender:" .. type .. "}:" .. result
		end,

        import_config = function (self, encrypted)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.menu.antiaim, self.ui.menu.aimbot})
			config:load(data)
		end,

		import_state = function (self, encrypted, team, state)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.menu.antiaim.builder.states[team][state]})
			config:load(data)
		end,

		import_team = function (self, encrypted, team)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.menu.antiaim.builder.states[team]})
			config:load(data)
		end,

		import = function (self, data, type, ...)
			local name = data:match("{lavender:(.+)}")
			if not name or name ~= type then
				return error('This is not valid lavender data')
			end

			local success, err = pcall(self['import_'..name], self, data:gsub("{lavender:" .. name .. "}:", ""), ...)
			if not success then
                print(err)
				return error('This is not valid lavender data')
			end
		end,

        save = function (self)
            local name = self:get_selected()
            local data = self.configs[name]
            if not name or not data then
                return error('No config selected')
            end

            local data = self:export("config")

			self.configs[name] = data

			self:update_configs(name)
        end,

        create = function (self)
			local name = self.ui.menu.home.name()
			if name:match("%w") == nil then
				return error("Invalid name")
			end

			local data = self:export("config")

			self.configs[name] = data

			self:update_configs(name)
		end,

		load = function (self)
			local name = self:get_selected()
            local data = self.configs[name]
			if not data then
				return error("No config selected")
			end

			self:import(data, "config")
		end,

		delete = function(self)
			local name = self:get_selected()
			local data = self.configs[name]
			if not data or not name then
				return error("No config selected")
			end

			self.configs[name] = nil

			self:update_configs()
		end,

    }

    :struct 'fakelag' {
		send_packet = true,

		get_limit = function (self)
			if not ui.get(self.ref.fakelag.enable[1]) then
				return 1
			end

			local limit = ui.get(self.ref.fakelag.limit[1])

			if not ui.get(self.ref.rage.fd[1]) then
				if ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2]) then
					limit = ui.get(self.ref.rage.dt_limit[1])
				elseif ui.get(self.ref.rage.os[1]) and ui.get(self.ref.rage.os[2]) then
					limit = 1
				end
			end
			
			return limit
		end,

		run = function (self, cmd)
			local limit = self:get_limit()

			if cmd.chokedcommands < limit and (not cmd.no_choke or self.defensive.defensive ~= 0) then
				self.send_packet = false
			else
				cmd.no_choke = true
				self.send_packet = true
			end

			--print(self.send_packet)

			cmd.allow_send_packet = self.send_packet

			return self.send_packet
		end
	}

	:struct 'desync' {
		switch_move = true,

		get_yaw_base = function (self, base)
			local threat = client.current_threat()
			local _, yaw = client.camera_angles()
			if base == "at targets" and threat then
				local pos = vector(entity.get_origin(entity.get_local_player()))
				local epos = vector(entity.get_origin(threat))
		
				_, yaw = pos:to(epos):angles()
			end
		
			return yaw
		end,

		do_micromovements = function(self, cmd, send_packet)
			local me = entity.get_local_player()
			local speed = 1.01
			local vel = vector(entity.get_prop(me, "m_vecVelocity")):length2d()

			if vel > 3 then
				return
			end

			if self.helpers:in_duck(me) or ui.get(self.ref.rage.fd[1]) then
				speed = speed * 2.94117647
			end

			self.switch_move = self.switch_move or false

			if self.switch_move then
				cmd.sidemove = cmd.sidemove + speed
			else
				cmd.sidemove = cmd.sidemove - speed
			end

			self.switch_move = not self.switch_move
		end,

		can_desync = function (self, cmd)
			local me = entity.get_local_player()

			if cmd.in_use == 1 then
				return false
			end
			local weapon_ent = entity.get_player_weapon(me)

			if cmd.in_attack == 1 then
				local weapon = entity.get_classname(weapon_ent)

				--print(weapon)

				if weapon == nil then
					return false
				end
                if weapon:find("Grenade") or weapon:find('Flashbang') then
                    self.globals.nade = globals.tickcount()
				else
					if math.max(entity.get_prop(weapon_ent, "m_flNextPrimaryAttack"), entity.get_prop(me, "m_flNextAttack")) - globals.tickinterval() - globals.curtime() < 0 then
						return false
					end
				end
			end
			local throw = entity.get_prop(weapon_ent, "m_fThrowTime")

			--print(throw)

			if self.globals.nade + 15 == globals.tickcount() or (throw ~= nil and throw ~= 0) then 
                return false 
            end
			if entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1 then
				return false
			end
		
			if entity.get_prop(me, "m_MoveType") == 9 or self.globals.in_ladder > globals.tickcount() then
				return false
			end
			if entity.get_prop(me, "m_MoveType") == 10 then
				return false
			end
		
			return true
		end,

		run = function (self, cmd, send_packet, data)
			if not self:can_desync(cmd) then
				return
			end

			self:do_micromovements(cmd, send_packet)

			local yaw = self:get_yaw_base(data.base)

			if send_packet then
				cmd.pitch = data.pitch or 88.9
				cmd.yaw = yaw + 180 + data.offset
			else
				cmd.pitch = 88.9
				cmd.yaw = yaw + 180 + data.offset + (data.side == 2 and 0 or (data.side == 0 and 120 or -120))
			end
		end
	}

    :struct 'antiaim' {
        side = 1,
        last_count = globals.tickcount(),
        skitter_counter = 1,
        cycle = 0,
        last_rand = 0,
        last_skitter = 0,

		manual_side = 0,

		calculate_additional_states = function (self, team, state)
			local dt = (ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2]))
			local os = (ui.get(self.ref.rage.os[1]) and ui.get(self.ref.rage.os[2]))

			if self.ui.menu.antiaim.builder.states[team]['Dormant'].enable and (not client.current_threat() or entity.is_dormant(client.current_threat())) then
				return 'Dormant'
			elseif self.ui.menu.antiaim.builder.states[team]['Hide shots'].enable and os and not dt then
				return 'Hide shots'
			elseif self.ui.menu.antiaim.builder.states[team]['Fake lag'].enable and not os and not dt then
				return 'Fake lag'
			elseif self.ui.menu.antiaim.builder.states[team]['Height'].enable and self.helpers:in_height() then
				return 'Height'
			end

			return state
		end,

		get_best_side = function (self, opposite)
			local me = entity.get_local_player()
			local eye = vector(client.eye_position())
			local target = client.current_threat()
			local _, yaw = client.camera_angles()

			local epos
			if target then
				epos = vector(entity.get_origin(target)) + vector(0,0,64)
				_, yaw = (epos - eye):angles()
			end

			local angles = {60,45,30,-30,-45,-60}
			local data = {left = 0, right = 0}

			for _, angle in ipairs(angles) do
				local forward = vector():init_from_angles(0, yaw + 180 + angle, 0)

				if target then
					local vec = eye + forward:scaled(128)
					local _, dmg = client.trace_bullet(target, epos.x, epos.y, epos.z, vec.x, vec.y, vec.z, me)
					data[angle < 0 and 'left' or 'right'] = data[angle < 0 and 'left' or 'right'] + dmg
				else
					local vec = eye + forward:scaled(8192)
					local fraction = client.trace_line(me, eye.x, eye.y, eye.z, vec.x, vec.y, vec.z)
					data[angle < 0 and 'left' or 'right'] = data[angle < 0 and 'left' or 'right'] + fraction
				end
			end

			if data.left == data.right then
				return 2
			elseif data.left > data.right then
				return opposite and 1 or 0
			else
				return opposite and 0 or 1
			end
		end,

		get_manual = function (self)
			local me = entity.get_local_player()

			local left = self.ui.menu.antiaim.manual_left:get()
			local right = self.ui.menu.antiaim.manual_right:get()
			local forward = self.ui.menu.antiaim.manual_forward:get()

			if self.last_forward == nil then
				self.last_forward, self.last_right, self.last_left = forward, right, left
			end

			if left ~= self.last_left then
				if self.manual_side == 1 then
					self.manual_side = nil
				else
					self.manual_side = 1
				end
			end

			if right ~= self.last_right then
				if self.manual_side == 2 then
					self.manual_side = nil
				else
					self.manual_side = 2
				end
			end

			if forward ~= self.last_forward then
				if self.manual_side == 3 then
					self.manual_side = nil
				else
					self.manual_side = 3
				end
			end

			self.last_forward, self.last_right, self.last_left = forward, right, left

			if not self.manual_side then
				return
			end

			return ({-90, 90, 180})[self.manual_side]
		end,

        run = function (self, cmd)
            local mode = self.ui.menu.antiaim.mode:get()

            if mode == "Builder" then
                self:run_builder(cmd)
            elseif mode == 'Preset' then
                self:run_preset(cmd)
            else
                self:run_logic(cmd)
            end

        end,

        setup_data = function (self, data, team, state)
			state = self:calculate_additional_states(team, state)

            if type(data) == 'string' then
                
            else
                if state ~= 'Global' and not data[team][state].enable:get() then
                    state = 'Global'
                end

                local arr = {}

                for k, v in pairs(data[team][state]) do
                    arr[k] = v:get()
                end

                return arr
            end
        end,

		run_preset = function ()
			
		end,

        run_builder = function (self, cmd)
			local team = self.helpers:get_team()
            local state = self.helpers:get_state()

            local data = self:setup_data(self.ui.menu.antiaim.builder.states, team, state)

			local delay = {1, 2, 4, 12}

            local delayed = true
            if globals.chokedcommands() == 0 and self.cycle == delay[data.jitter_delay] then
                delayed = false
                self.side = self.side == 1 and 0 or 1
            end

			local best_side = self:get_best_side()
            local side = self.side
            local body_yaw = data.body_yaw

            if body_yaw == "Jitter" then
                body_yaw = "Static"
            else
                if data.body_yaw_side == "Left" then
                    side = 1
                elseif data.body_yaw_side == "Right" then
                    side = 0
                else
                    side = best_side
                end
            end

            local yaw_offset = 0
            
            if data.yaw_jitter == 'Offset' then
                if self.side == 1 then
                    yaw_offset = yaw_offset + data.yaw_jitter_value
                end
            elseif data.yaw_jitter == 'Center' then
                yaw_offset = yaw_offset + (self.side == 1 and data.yaw_jitter_value/2 or -data.yaw_jitter_value/2)
            elseif data.yaw_jitter == 'Random' then
                local rand = (math.random(0, data.yaw_jitter_value) - data.yaw_jitter_value/2)
                if not delayed then
                    yaw_offset = yaw_offset + rand

                    self.last_rand = rand
                else
                    yaw_offset = yaw_offset + self.last_rand
                end
            elseif data.yaw_jitter == 'Skitter' then
                local sequence = {0, 2, 1, 0, 2, 1, 0, 1, 2, 0, 1, 2, 0, 1, 2}

                local next_side
                if self.skitter_counter == #sequence then
                    self.skitter_counter = 1
                elseif not delayed then
                    self.skitter_counter = self.skitter_counter + 1
                end

                next_side = sequence[self.skitter_counter]

                self.last_skitter = next_side

                if data.body_yaw == "Jitter" then
                    side = next_side
                end

                if next_side == 0 then
                    yaw_offset = yaw_offset - 16 - math.abs(data.yaw_jitter_value)/2
                elseif next_side == 1 then
                    yaw_offset = yaw_offset + 16 + math.abs(data.yaw_jitter_value)/2
                end
            end

            if data.multiply then
                yaw_offset = yaw_offset + (side == 0 and data.yaw_multiple_right or (side == 1 and data.yaw_multiple_left or 0))
            else
                yaw_offset = yaw_offset + data.yaw_single
            end

			ui.set(self.ref.aa.edge_yaw[1], self.ui.menu.antiaim.edge_yaw:get())

			ui.set(self.ref.aa.freestand[2], 'Always on')
			ui.set(self.ref.aa.freestand[1], false)

			local manual = self:get_manual()

			if manual then
				yaw_offset = manual
			elseif self.ui.menu.antiaim.freestand_key:get() and not (self.ui.menu.antiaim.freestand_options:get('Disablers') and self.ui.menu.antiaim.freestand_disablers:get(state)) then
				ui.set(self.ref.aa.freestand[1], true)
				if self.ui.menu.antiaim.freestand_options:get("Force static") then
					yaw_offset = 0
					side = best_side
				end
			end

            if data.desync_mode == 'Gamesense' then
                ui.set(self.ref.aa.enabled[1], true)
                ui.set(self.ref.aa.pitch[1], 'default')
                ui.set(self.ref.aa.yaw_base[1], data.yaw_base and 'At targets' or 'Local view')
                ui.set(self.ref.aa.yaw[1], data.yaw)
                ui.set(self.ref.aa.yaw[2], self.helpers:normalize(yaw_offset))
                ui.set(self.ref.aa.yaw_jitter[1], 'off')
                ui.set(self.ref.aa.yaw_jitter[2], 0)
                ui.set(self.ref.aa.body_yaw[1], body_yaw)
                ui.set(self.ref.aa.body_yaw[2], (side == 2) and 0 or (side == 1 and 90 or -90))
			elseif data.desync_mode == 'Lavender' then
                local send_packet = self.fakelag:run(cmd)

                self.desync:run(cmd, send_packet, {
                    base = data.yaw_base and "at targets" or "local view",
                    side = side,
                    offset = yaw_offset,
                })
            else
				ui.set(self.ref.aa.enabled[1], data.yaw ~= 'Off')
                ui.set(self.ref.aa.pitch[1], 'default')
                ui.set(self.ref.aa.yaw_base[1], data.yaw_base and "at targets" or "local view")
                ui.set(self.ref.aa.yaw[1], data.yaw)
                ui.set(self.ref.aa.yaw[2], self.helpers:normalize(yaw_offset))
                ui.set(self.ref.aa.yaw_jitter[1], 'off')
                ui.set(self.ref.aa.yaw_jitter[2], 0)
                ui.set(self.ref.aa.body_yaw[1], 'Off')
			end

            self.last_count = globals.tickcount()

            if globals.chokedcommands() == 0 then
                if self.cycle >= delay[data.jitter_delay] then
                    self.cycle = 1
                else
                    self.cycle = self.cycle + 1
                end
            end
            
        end
    }

	:struct 'defensive' {
		cmd = 0,
		check = 0,
		defensive = 0,
		predict = function(self)
			local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
			self.defensive = math.abs(tickbase - self.check)
			self.check = math.max(tickbase, self.check or 0)
			self.cmd = 0
		end,
		reset = function(self)
			self.check, self.defensive = 0, 0
		end
	}

	:struct 'animation_layers' {
		sixth_layer = { },
    	sixth_layer_weight = { },
		get_animation_state = function(self, _entity)
			if not _entity then
				return
			end
			local player_ptr = ffi.cast( "void***", get_client_entity(ientitylist, _entity))
			local animstate_ptr = ffi.cast( "char*" , player_ptr ) + 0x9960
			local state = ffi.cast( "struct c_animstate**", animstate_ptr )[0]
		
			return state
		end,

		get_max_desync = function (self, _entity)
			local animstate = self:get_animation_state(_entity)

			duckammount = animstate.m_fDuckAmount
			
			speedfraction = math.max( 0, math.min( animstate.m_flFeetSpeedForwardsOrSideWays, 1 ) )
		
			speedfactor = math.max( 0, math.min( 1, animstate.m_flFeetSpeedUnknownForwardOrSideways ) )
		
			unk1 = ( ( animstate.m_flStopToFullRunningFraction * -0.30000001 ) - 0.19999999 ) * speedfraction
			unk2 = unk1 + 1
			unk3 = 0
		
			if ( duckammount > 0 ) then
		
				unk2 = unk2 + ( ( duckammount * speedfactor ) * ( 0.5 - unk2 ) )
		
			end
		
			unk3 = animstate.m_flMaxYaw * unk2;
			
			return math.abs(unk3)
		end,

		get_body_yaw = function (self, _entity)
			local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (360/math.pi) - (180/math.pi)
			return body_yaw
		end,
		
        -- Returns animation layer data
        collect = function (self, entity)
            local animations = { }

			local lpent = get_client_entity(ientitylist, entity)
			local lpentnetworkable = get_client_networkable(ientitylist, entity)

            if lpent ~= nil and lpentnetworkable ~= nil then
                for i=1, 13 do
                    local anim_layer = get_anim_layer(lpent, i)

                    animations[i] = { m_flPrevCycle=0, m_flWeight=0, m_flCycle=0, m_pOwner=nil, m_nSequence=0, m_nSequenceId=-1 }

                    if anim_layer ~= nil then
                        animations[i] = {
                            m_flPrevCycle = (anim_layer.m_flPrevCycle * 1000) or 0,
                            m_flWeight = (anim_layer.m_flWeight * 1000) or 0,
                            m_flCycle = (anim_layer.m_flCycle * 1000) or 0,
                            m_pOwner = anim_layer.m_pOwner or nil,

                            m_nSequence = anim_layer.m_nSequence or 0,
                            m_nSequenceId = get_sequence_activity(lpent, lpentnetworkable, anim_layer.m_nSequence),
                        }
                    end

                end
            end

            return animations
        end,

        -- Returns player animation patterns
        generate_data = function (self, _ent, animations)
            if animations == nil then
                return
            end

            local player_state =
            {
                in_air = animations[4].m_flCycle >= 16 and animations[4].m_flWeight > 1,
                moving = (animations[12].m_flWeight > 3 and animations[12].m_flWeight <= 75) or animations[6].m_flWeight > 110,

                accel = (function()
                    local is_in_air = animations[4].m_flCycle >= 16 and animations[4].m_flWeight > 1
                    local started_moving = animations[6].m_flWeight >= 30 and animations[6].m_flWeight < 930
                    local first_cycle = animations[12].m_flCycle == 0 and started_moving or (animations[12].m_flWeight > 125 and math.random(0, 90) < 80)
                
                    return not is_in_air and first_cycle
                end)(),
                
                ducking = (function()
                    local wish_limit = 15

                    local m_flDuckAmount = entity.get_prop(_ent, 'm_flDuckAmount')
                    local m_flDuckSpeed = entity.get_prop(_ent, 'm_flDuckSpeed')

                    local duck_per_tick = m_flDuckSpeed * globals.tickinterval()
                    local unduck_time = math.min((duck_per_tick*(wish_limit/2)), 1)

                    if m_flDuckAmount > 0 and m_flDuckAmount < unduck_time then
                        return true
                    end
                end)()
            }

            local weapon_state = 
            {
                equip = animations[1].m_nSequenceId == 972 and animations[1].m_flWeight > 0,
                reloading = animations[1].m_nSequenceId == 967 and animations[1].m_flWeight > 0,
                firing = animations[1].m_flCycle < 450 and
                    (
                        animations[1].m_nSequenceId == 961 or 
                        animations[1].m_nSequenceId == 962 or 
                        animations[1].m_nSequenceId == 964
                    ) 
            }

            local animation_state =
            {
                -- detect lower body updates
                lowerbody = animations[3].m_nSequenceId == 979 and animations[3].m_flWeight > 1,

                -- attempting to determine desync side by using 12 and 6 layers
                -- if enemy is not accelerating or gained speed -> getting prev layers -> finding delta between layers -> comparing deltas withing a period
                -- if the player is 100%desyncing and ur not able to detect desync_move condition = enemy is using JitterMove 
                desync_move = (function()
                    if self.sixth_layer_weight[_ent] == nil then
                        self.sixth_layer_weight[_ent] = animations[6]
                    end

                    local state = 
                        player_state.moving and animations[12].m_flWeight < 5 and 
                        math.abs(animations[6].m_flWeight-self.sixth_layer_weight[_ent].m_flWeight) < 3

                    self.sixth_layer_weight[_ent] = animations[6]

                    return state
                end)(),

                -- Using fakelag/desyncing forces sixth layer to update the cycle (when standing still / in air)
                -- we can potentially determine desync side
                desync_stand = (function()
                    if self.sixth_layer[_ent] == nil then
                        self.sixth_layer[_ent] = animations[6].m_flCycle
                    end

                    local state = not player_state.moving and animations[6].m_flWeight < 1 and math.abs(animations[6].m_flCycle - self.sixth_layer[_ent]) >= 1
        
                    if math.abs(animations[6].m_flCycle-self.sixth_layer[_ent]) >= 1 then
                        self.sixth_layer[_ent] = animations[6].m_flCycle
                    end

                    return state
                end)(),

                land_heavy = (function()
                    if animations[11].m_nSequenceId == 981 and animations[11].m_flWeight == 1000 then
                        if math.floor(animations[11].m_flCycle / 10 % 35) == 0 then
                            return true
                        end
                    end

                    return false
                end)()
            }

            return player_state, weapon_state, animation_state
        end
	}

	:struct 'indicators' {
		scope_frac = 1,
		charge_frac = 0,
		fraction = 0,
		active_fraction = 0,
		inactive_fraction = 0,
		hide_fraction = 0,
		
		run = function (self)
			local x, y = client.screen_size()
			local me = entity.get_local_player()

			if not me or not entity.is_alive(me) then
				return
			end

			local state = self.helpers:get_state(me)

			local ss = {client.screen_size()}
			self.ss = {
				x = ss[1],
				y = ss[2]
			}

			local is_scoped = entity.get_prop(me, "m_bIsScoped") == 1
			local r, g, b, a = 255,255,255,255

			if is_scoped then
				self.scope_frac = self.helpers:clamp(self.scope_frac - globals.frametime()*5, 0, 1)
			else
				self.scope_frac = self.helpers:clamp(self.scope_frac + globals.frametime()*5, 0, 1)
			end

			local visual_size = self.ui.menu.settings.crosshair_size:get()
			local size = ""
			if visual_size == "small" then
				size = "-"
			elseif visual_size == "bold" then
				size = "b"
			end

			local r, g, b, a = self.ui.menu.settings.accent:get()

			if self.ui.menu.settings.crosshair:get() == 'Default' then

				local fr = self.scope_frac ^ 3

				local prim = {255,255,255,255} --{self.ui.menu.settings.accent:get()}
				local sec = {255,255,255,255}
				local str = "LAVENDER"
				local speed = 1
				local time = speed/string.len(str)
				local f = ""
				for k = 1, #str do
					local clr = self.helpers:rgba_lerp(prim, sec, math.abs(math.sin(globals.realtime()*4 + time*k)))
					f = f .. self.helpers:color_to_string(clr) .. string.sub(str, k, k)
				end
				local size = vector(renderer.measure_text("-", f))
				renderer.text(x/2 - ((size.x/2 + 4) * fr) + 4, y/2 + 20, 255, 255, 255, 255, "-", 0, f)
				local max_desync = self.animation_layers:get_max_desync(me)
				local r, g, b, a = 255,255,255,255 --self.ui.menu.settings.accent:get()
				--renderer.gradient(x/2 - ((max_desync/2 + 4) * fr) + 5, y/2 + size.y + 22, max_desync, 2, 255, 255, 255, 255, 255, 255, 255, 255, false)
				--local size2 = vector(renderer.measure_text("-", string.upper(version)))
				--renderer.text(x/2 - ((size2.x/2 + 4) * fr) + 4, y/2 + 30, 255, 255, 255, 155, "-", 0, string.upper(version))
				local size3 = vector(renderer.measure_text("-", self.helpers:round(max_desync, 0) .. "%"))
				renderer.text(x/2 - ((size3.x/2 + 4) * fr) + 4, y/2 + 30, r, g, b, a, "-", 0, self.helpers:round(max_desync, 0) .. "%")

				local charging = antiaim.get_tickbase_shifting() > 1 and antiaim.get_tickbase_shifting()/10 <= 1.2 
				if charging then
					self.charge_frac = self.helpers:clamp(self.charge_frac + globals.frametime()*7, 0, 1)
				else
					self.charge_frac = self.helpers:clamp(self.charge_frac - globals.frametime()*7, 0, 1)
				end

				local charge_fr = math.sin(self.charge_frac)

				local size4 = renderer.measure_text("-", "DT")
				local size_dt = ((size4 + 10 * charge_fr)/2 + 4) * fr

				renderer.circle_outline(x/2 - size_dt + 4 + size4 + 6, y/2 + 46, 0, 0, 0, 155* charge_fr, 4, 90, 1, 3)
            	renderer.circle_outline(x/2 - size_dt + 4 + size4 + 6, y/2 + 46, 255, 255, 255, 255 * charge_fr, 3, 90, antiaim.get_tickbase_shifting()/10, 1)

				local dt_active = ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2])
				renderer.text(x/2 - size_dt + 4, y/2 + 40, 255,255,255,dt_active and 255 or 100, "-", 0, "DT")

				local sp = ui.get(self.ref.rage.sp[1])
				local baim = ui.get(self.ref.rage.fb[1])
				local fs = ui.get(self.ref.aa.freestand[1]) and ui.get(self.ref.aa.freestand[2])
				local active_clr = self.helpers:color_to_string({255,255,255,255})
				local inactive_clr = self.helpers:color_to_string({255,255,255,100})
				local str = (baim and active_clr or inactive_clr) .. 'BAIM' .. '  ' .. (sp and active_clr or inactive_clr) .. 'SP' .. '  ' .. (fs and active_clr or inactive_clr) .. 'FS'
				local str_size = renderer.measure_text('-', str)
				renderer.text(x/2 - ((str_size/2 + 4) * fr) + 4, y/2 + 50, 255,255,255,sp and 255 or 100, "-", 0, str)
			elseif self.ui.menu.settings.crosshair:get() == 'New' then
				local scoped_frac = 1 - self.scope_frac

				local func = string[size == "-" and "upper" or "lower"]

				local strike_w, strike_h = renderer.measure_text(size, func"lavender yaw")

				--ctx.m_render:glow_module(x/2 + ((strike_w + 2)/2) * scoped_frac - strike_w/2 + 4, y/2 + 20, strike_w - 3, 0, 10, 0, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))}, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))})
				renderer.text(self.ss.x/2 + ((strike_w + 2)/2) * scoped_frac, self.ss.y/2 + 20, 255, 255, 255, 255, size .. "c", 0, func"lavender ", func("\a" .. self.helpers:rgba_to_hex( r, g, b, 255 * math.abs(math.cos(globals.curtime()*2))) .. "yaw"))

				local next_attack = entity.get_prop(me, "m_flNextAttack")
				local next_primary_attack = entity.get_prop(entity.get_player_weapon(me), "m_flNextPrimaryAttack")

				local dt_toggled = ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2])
				local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime()) --or (ctx.helpers.defensive and ctx.helpers.defensive > ui.get(ctx.ref.dt_fl))

				if dt_toggled and dt_active then
					self.active_fraction = self.helpers:clamp(self.active_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.active_fraction = self.helpers:clamp(self.active_fraction - globals.frametime()/0.15, 0, 1)
				end

				if dt_toggled and not dt_active then
					self.inactive_fraction = self.helpers:clamp(self.inactive_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.inactive_fraction = self.helpers:clamp(self.inactive_fraction - globals.frametime()/0.15, 0, 1)
				end

				if ui.get(self.ref.rage.os[1]) and ui.get(self.ref.rage.os[2]) and ui.get(self.ref.rage.silent[1]) and not dt_toggled then
					self.hide_fraction = self.helpers:clamp(self.hide_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.hide_fraction = self.helpers:clamp(self.hide_fraction - globals.frametime()/0.15, 0, 1)
				end

				if math.max(self.hide_fraction, self.inactive_fraction, self.active_fraction) > 0 then
					self.fraction = self.helpers:clamp(self.fraction + globals.frametime()/0.2, 0, 1)
				else
					self.fraction = self.helpers:clamp(self.fraction - globals.frametime()/0.2, 0, 1)
				end

				local dt_size, dt_h = renderer.measure_text(size, func"DT ")
				local ready_size = renderer.measure_text(size, func"READY")
				renderer.text(self.ss.x/2 + ((dt_size + ready_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h, 255, 255, 255, self.active_fraction * 255, size .. "c", dt_size + self.active_fraction * ready_size + 1, func"DT ", func("\a" .. self.helpers:rgba_to_hex(155, 255, 155, 255 * self.active_fraction) .. "READY"))

				local charging_size = renderer.measure_text(size, func"CHARGING")
				local ret = self.helpers:animate_text(globals.curtime(), func"CHARGING", 255, 100, 100, 255)
				renderer.text(self.ss.x/2 + ((dt_size + charging_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h, 255, 255, 255, self.inactive_fraction * 255, size .. "c", dt_size + self.inactive_fraction * charging_size + 1, func"DT ", unpack(ret))

				local hide_size = renderer.measure_text(size, func"HIDE ")
				local active_size = renderer.measure_text(size, func"ACTIVE")
				renderer.text(self.ss.x/2 + ((hide_size + active_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h, 255, 255, 255, self.hide_fraction * 255, size .. "c", hide_size + self.hide_fraction * active_size + 1, func"HIDE ", func("\a" .. self.helpers:rgba_to_hex(155, 155, 200, 255 * self.hide_fraction) .. "ACTIVE"))
			
				local state_size = renderer.measure_text(size, '- ' .. func(state) .. ' -')
				renderer.text(self.ss.x/2 + ((state_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h + dt_h * self.helpers:easeInOut(self.fraction), 255, 255, 255, 255, size .. "c", 0, func('- ' .. state .. ' -'))
			
			end

			if self.ui.menu.settings.damage_indicator:get() and ui.get(self.ref.rage.dmg_override[1]) and ui.get(self.ref.rage.dmg_override[2]) then
				renderer.text(x/2 + 5, y/2 - 8, 255, 255, 255, 255, 'c-', 0, ui.get(self.ref.rage.dmg_override[3]))
			end
		end
	}


for _, eid in ipairs({
    {
        'load', function ()
            ctx.ui:execute()
            ctx.config:setup()
        end,
    },
	{
		'shutdown', function ()
			ctx.helpers:menu_visibility(true)
		end
	},
    {
        'setup_command', function (cmd)
			ctx.antiaim:run(cmd)
			if ui.is_menu_open() then
				ctx.helpers:menu_visibility(not ctx.ui.menu.global.main:get())
			end
        end
    },
	{
		"predict_command", function()
			ctx.defensive:predict()
		end
	},
	{
		"level_init", function()
			ctx.defensive:reset()
		end
	},
	{
		'paint', function ()
			ctx.indicators:run()
		end
	}
}) do
	if eid[1] == "load" then
		eid[2]()
	else
		client.set_event_callback(eid[1], eid[2])
	end
end