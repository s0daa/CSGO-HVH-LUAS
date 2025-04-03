local Get = menu.find
local AddCheckbox = menu.add_checkbox
local AddSlider = menu.add_slider
local AddCombo = menu.add_selection

local JitterTypes = {"None", "Static", "Center", "Random", "Random v2", "Breaker"}
local DesyncSides = {"None", "Left", "Right", "Jitter", "Freestand", "Reversed freestand", "Sway", "Random", "Breaker"}
local FakelagTypes = {"Static", "Adaptive", "Random", "Break LC"}

local Lua = {
	OverrideAntiaim = AddCheckbox("Main", "Override antiaim"),
	OverrideFakelag = AddCheckbox("Main", "Override fakelag"),

	Antiaim = {
		Preset = AddCombo("Antiaim", "Preset", {"None", "Nervous jitter", "Low jitter", "N-Way", "Custom"}),

		NWay = {
			Type = AddCombo("Antiaim [N-Way]", "Type", {"3-Way", "4-Way", "5-Way"}),

			Timings = AddCombo("Antiaim [N-Way]", "Time", {"Static", "Randomize"}),

			YawFirstSide = AddSlider("Antiaim [N-Way]", "Yaw Side - [1]", -58, 58),
			YawSecondSide = AddSlider("Antiaim [N-Way]", "Yaw Side - [2]", -58, 58),
			YawThirdSide = AddSlider("Antiaim [N-Way]", "Yaw Side - [3]", -58, 58),
			YawFourthSide = AddSlider("Antiaim [N-Way]", "Yaw Side - [4]", -58, 58),
			YawFivthSide = AddSlider("Antiaim [N-Way]", "Yaw Side [5]", -58, 58),

			DesyncOverride = AddCheckbox("Antiaim [N-Way]", "Override desync"),
			DesyncFirstSide = AddSlider("Antiaim [N-Way]", "Desync Side - [1]", -90, 90),
			DesyncSecondSide = AddSlider("Antiaim [N-Way]", "Desync Side - [2]", -90, 90),
			DesyncThirdSide = AddSlider("Antiaim [N-Way]", "Desync Side - [3]", -90, 90),
			DesyncFourthSide = AddSlider("Antiaim [N-Way]", "Desync Side - [4]", -90, 90),
			DesyncFivthSide = AddSlider("Antiaim [N-Way]", "Desync Side - [5]", -90, 90)
		},

		Custom = {
			Mode = AddCombo("Antiaim [Custom]", "Type", {"Standing", "Walking", "Running", "In-air", "Crouching", "Crouch in air", "Deffensive"}),

			Standing = {
				Yaw = AddSlider("Antiaim [Custom]", "[S] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[S] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[S] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[S] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[S] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[S] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[S] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[S] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[S] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[S] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[S] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[S] - Right amount", 0, 90),
			},

			Walking = {
				Yaw = AddSlider("Antiaim [Custom]", "[W] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[W] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[W] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[W] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[W] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[W] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[W] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[W] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[W] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[W] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[W] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[W] - Right amount", 0, 90),
			},

			Running = {
				Yaw = AddSlider("Antiaim [Custom]", "[R] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[R] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[R] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[R] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[R] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[R] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[R] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[R] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[R] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[R] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[R] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[R] - Right amount", 0, 90),
			},

			Air = {
				Yaw = AddSlider("Antiaim [Custom]", "[A] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[A] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[A] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[A] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[A] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[A] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[A] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[A] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[A] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[A] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[A] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[A] - Right amount", 0, 90),
			},

			Crouching = {
				Yaw = AddSlider("Antiaim [Custom]", "[C] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[C] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[C] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[C] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[C] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[C] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[C] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[C] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[C] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[C] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[C] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[C] - Right amount", 0, 90),
			},

			CrouchingInAir = {
				Yaw = AddSlider("Antiaim [Custom]", "[CA] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[CA] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[CA] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[CA] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[CA] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[CA] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[CA] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[CA] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[CA] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[CA] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[CA] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[CA] - Right amount", 0, 90),
			},

			Deffensive = {
				Sensivity = AddSlider("Antiaim [Custom]", "[D] - Deffensive sensivity", 0, 100),

				Pitch = AddCombo("Antiaim [Custom]", "[D] - Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
				Yaw = AddSlider("Antiaim [Custom]", "[D] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[D] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[D] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[D] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[D] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[D] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[D] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[D] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[D] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[D] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[D] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[D] - Right amount", 0, 90),
			}
		}
	},

	Fakelag = {
		MoveType = AddCombo("Fakelag [Custom]", "Move type", {"Standing", "Walking", "Running", "Air", "Crouching", "Crouch in air"}),

		Standing = {
			Amount = AddSlider("Fakelag [Custom]", "[S] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[S] - Mode", FakelagTypes),
		},

		Walking = {
			Amount = AddSlider("Fakelag [Custom]", "[W] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[W] - Mode", FakelagTypes),
		},

		Running = {
			Amount = AddSlider("Fakelag [Custom]", "[R] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[R] - Mode", FakelagTypes),
		},

		Air = {
			Amount = AddSlider("Fakelag [Custom]", "[A] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[A] - Mode", FakelagTypes),
		},

		Crouching = {
			Amount = AddSlider("Fakelag [Custom]", "[C] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[C] - Mode", FakelagTypes),
		},

		CrouchingInAir = {
			Amount = AddSlider("Fakelag [Custom]", "[AC] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[AC] - Mode", FakelagTypes),
		}
	}
}

local Ui = {

	Exploits = {
		Doubletap = Get("aimbot", "general", "exploits", "doubletap", "enable"),
		Hideshots = Get("aimbot", "general", "exploits", "hideshots", "enable")
	},

	Antiaim = {
		Enable = Get("antiaim", "main", "general", "enable"),
		Pitch = Get("antiaim", "main", "angles", "pitch"),
		Base = Get("antiaim", "main", "angles", "yaw base"),
		Yaw = Get("antiaim", "main", "angles", "yaw add"),

		OverrideSpin = Get("antiaim", "main", "angles", "rotate"),
		SpinAmount = Get("antiaim", "main", "angles", "rotate range"),
		SpinSpeed = Get("antiaim", "main", "angles", "rotate speed"),

		JitterType = Get("antiaim", "main", "angles", "jitter mode"),
		JitterMode = Get("antiaim", "main", "angles", "jitter type"),
		JitterAmount = Get("antiaim", "main", "angles", "jitter add"),

		DesyncSide = Get("antiaim", "main", "desync","side#stand"),
		DesyncLeft = Get("antiaim", "main", "desync","left amount#stand"),
		DesyncRight = Get("antiaim", "main", "desync","right amount#stand"),
	},

	Fakelag = {
		Amount = Get("antiaim", "main", "fakelag", "amount")
	}
}

function Clamp(x, min, max)
    if min > max then
        return math.min(math.max(x, max), min)
    else
        return math.min(math.max(x, min), max)
    end  
    
    return x
end

local function GetVelocity()
    local Entity = entity_list.get_local_player()

    local VelocityX = Entity:get_prop("m_vecVelocity[0]")
    local VelocityY = Entity:get_prop("m_vecVelocity[1]")
    local VelocityZ = Entity:get_prop("m_vecVelocity[2]")
  
    local Velocity = vec3_t(VelocityX, VelocityY, VelocityZ)

    if math.ceil(Velocity:length2d()) < 5 then
        return 0
    else 
        return math.ceil(Velocity:length2d()) 
    end
end

local Tickbase = {
	LastTickcount = global_vars.tick_count(),
	Ticks = 62,
	Difference = 0,
	Deffensive = false
}

local PreviousSimulationTime = 0
local DifferenceOfSimulation = 0
function SimulationDifference(entity)
	local CurrentSimulationTime = client.time_to_ticks(entity:get_prop("m_flSimulationTime"))
	local Difference = CurrentSimulationTime - (PreviousSimulationTime + (Lua.Antiaim.Custom.Deffensive.Sensivity:get() / 100))
	PreviousSimulationTime = CurrentSimulationTime
	DifferenceOfSimulation = Difference
	return DifferenceOfSimulation
end

function RefreshTickcount()
    Tickbase.LastTickcount = global_vars.tick_count()
end

local function AntiaimCondition()
	local LocalPlayer = entity_list.get_local_player()
	local AntiaimCondition = 0

	local Deffensive = false

    local TickBase = LocalPlayer:get_prop("m_nTickBase")
    Tickbase.Deffensive = math.abs(TickBase - Tickbase.Difference) >= 2.50
    Tickbase.Difference = math.max(TickBase, Tickbase.Difference or 0)
    if Tickbase.LastTickcount < global_vars.tick_count() - (Tickbase.Ticks / 2) + exploits.get_charge() then
		if (Tickbase.Deffensive or SimulationDifference(LocalPlayer) <= -1) and Tickbase.LastTickcount < global_vars.tick_count() and Ui.Exploits.Doubletap[2]:get() == true then
			Deffensive = true
			RefreshTickcount()
			Deffensive = false
		end

		Deffensive = true
    end

	if GetVelocity() == 0 and Deffensive then 
		AntiaimCondition = 1 
	end

	if GetVelocity() > 0 and LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
		AntiaimCondition = 2
	end

	if GetVelocity() > 90 and LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
        AntiaimCondition = 3
    end

    if not LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
        AntiaimCondition = 4
    end

    if LocalPlayer:has_player_flag(e_player_flags.DUCKING) and LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
        AntiaimCondition = 5
    end

	if not LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and LocalPlayer:has_player_flag(e_player_flags.DUCKING) and Deffensive then
		AntiaimCondition = 6
	end

	if Deffensive == false and not Ui.Exploits.Hideshots[2]:get() then
		AntiaimCondition = 7
	end

	return AntiaimCondition
end

function JitterSide()
    local JitterSide = 0
    local SwapTimer = 0
    SwapTimer = global_vars.cur_time() * 10000 % 1
    Clamp(SwapTimer, 0, 1)
    JitterSide = SwapTimer > 0.5 and 1 or -1

    return JitterSide
end

function SwapSide()
    local JitterSide = 0
    local SwapTimer = 0
    SwapTimer = math.ceil(global_vars.cur_time() * 36) % 2
    Clamp(SwapTimer, 0, 1)
    JitterSide = SwapTimer > 0.5 and 1 or -1
    return JitterSide
end

local Way = 0

local function CAntiaim()
	local Curtime = global_vars.cur_time()
	local LocalPlayer = entity_list.get_local_player()

	if Lua.Antiaim.NWay.Timings:get() == 1 then
		if JitterSide() == 1 then
			Way = Way + 1
		end
	else
		if math.ceil(Curtime * client.random_int(100, 128)) % 5 > 1 then
			Way = Way + 1
		end
	end

    if Lua.Antiaim.Preset:get() == 2 then
        Ui.Antiaim.OverrideSpin:set(false)
		Ui.Antiaim.JitterType:set(1)

        Ui.Antiaim.Yaw:set(math.ceil(Curtime * 128) % 20 * SwapSide())

		Ui.Antiaim.DesyncSide:set(SwapSide() == 1 and 2 or 3)
		Ui.Antiaim.DesyncLeft:set(75)
		Ui.Antiaim.DesyncRight:set(75)
    end

    if Lua.Antiaim.Preset:get() == 3 then
        Ui.Antiaim.OverrideSpin:set(false)
		Ui.Antiaim.JitterType:set(1)

        Ui.Antiaim.Yaw:set(15 + math.ceil(Curtime * client.random_int(120, 128)) % 25 * SwapSide())

		Ui.Antiaim.DesyncSide:set(3)
		Ui.Antiaim.DesyncLeft:set(75 - math.ceil(Curtime * 65) % 20)
		Ui.Antiaim.DesyncRight:set(75 - math.ceil(Curtime * 65) % 20)
    end

	if Lua.Antiaim.Preset:get() == 4 then
		Ui.Antiaim.OverrideSpin:set(false)
		Ui.Antiaim.JitterType:set(1)

		if Way == 1 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawFirstSide:get())
		elseif Way == 2 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawSecondSide:get())
		elseif Way == 3 and Lua.Antiaim.NWay.Type:get() > 0 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawThirdSide:get())
		elseif Way == 4 and Lua.Antiaim.NWay.Type:get() > 1 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawFourthSide:get())
		elseif Way == 5 and Lua.Antiaim.NWay.Type:get() > 2 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawFivthSide:get())
		else
			Way = 1
		end

		if Lua.Antiaim.NWay.DesyncOverride:get() then
			if Way == 1 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncFirstSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncFirstSide:get() > 0 and Lua.Antiaim.NWay.DesyncFirstSide:get() or Lua.Antiaim.NWay.DesyncFirstSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncFirstSide:get() > 0 and Lua.Antiaim.NWay.DesyncFirstSide:get() or Lua.Antiaim.NWay.DesyncFirstSide:get() * -1)
			elseif Way == 2 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncSecondSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncSecondSide:get() > 0 and Lua.Antiaim.NWay.DesyncSecondSide:get() or Lua.Antiaim.NWay.DesyncSecondSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncSecondSide:get() > 0 and Lua.Antiaim.NWay.DesyncSecondSide:get() or Lua.Antiaim.NWay.DesyncSecondSide:get() * -1)
			elseif Way == 3 and Lua.Antiaim.NWay.Type:get() > 0 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncThirdSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncThirdSide:get() > 0 and Lua.Antiaim.NWay.DesyncThirdSide:get() or Lua.Antiaim.NWay.DesyncThirdSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncThirdSide:get() > 0 and Lua.Antiaim.NWay.DesyncThirdSide:get() or Lua.Antiaim.NWay.DesyncThirdSide:get() * -1)
			elseif Way == 4 and Lua.Antiaim.NWay.Type:get() > 1 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncFourthSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncFourthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFourthSide:get() or Lua.Antiaim.NWay.DesyncFourthSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncFourthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFourthSide:get() or Lua.Antiaim.NWay.DesyncFourthSide:get() * -1)
			elseif Way == 5 and Lua.Antiaim.NWay.Type:get() > 2 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncFivthSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncFivthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFivthSide:get() or Lua.Antiaim.NWay.DesyncFivthSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncFivthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFivthSide:get() or Lua.Antiaim.NWay.DesyncFivthSide:get() * -1)
			else
				Way = 1
			end
		end
	end

	if Lua.Antiaim.Preset:get() == 5 then
		if AntiaimCondition() == 1 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Standing.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Standing.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Standing.Yaw:get(), -Lua.Antiaim.Custom.Standing.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Standing.Yaw:get(), Lua.Antiaim.Custom.Standing.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Standing.Yaw:get())
			end

			if Lua.Antiaim.Custom.Standing.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Standing.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Standing.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Standing.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Standing.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Standing.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Standing.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Standing.OverrideSpin:get())

			if Lua.Antiaim.Custom.Standing.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Standing.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Standing.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Standing.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Standing.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Standing.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Standing.SpinSpeed:get())

			if Lua.Antiaim.Custom.Standing.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Standing.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Standing.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 2 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Walking.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Walking.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Walking.Yaw:get(), -Lua.Antiaim.Custom.Walking.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Walking.Yaw:get(), Lua.Antiaim.Custom.Walking.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Walking.Yaw:get())
			end

			if Lua.Antiaim.Custom.Walking.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Walking.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Walking.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Walking.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Walking.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Walking.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Walking.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Walking.OverrideSpin:get())

			if Lua.Antiaim.Custom.Walking.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Walking.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Walking.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Walking.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Walking.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Walking.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Walking.SpinSpeed:get())

			if Lua.Antiaim.Custom.Walking.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Walking.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Walking.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 3 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Running.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Running.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Running.Yaw:get(), -Lua.Antiaim.Custom.Running.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Running.Yaw:get(), Lua.Antiaim.Custom.Running.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Running.Yaw:get())
			end

			if Lua.Antiaim.Custom.Running.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Running.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Running.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Running.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Running.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Running.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Running.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Running.OverrideSpin:get())

			if Lua.Antiaim.Custom.Running.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Running.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Running.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Running.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Running.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Running.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Running.SpinSpeed:get())

			if Lua.Antiaim.Custom.Running.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Running.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Running.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 4 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Air.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Air.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Air.Yaw:get(), -Lua.Antiaim.Custom.Air.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Air.Yaw:get(), Lua.Antiaim.Custom.Air.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Air.Yaw:get())
			end

			if Lua.Antiaim.Custom.Air.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Air.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Air.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Air.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Air.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Air.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Air.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Air.OverrideSpin:get())

			if Lua.Antiaim.Custom.Air.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Air.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Air.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Air.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Air.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Air.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Air.SpinSpeed:get())

			if Lua.Antiaim.Custom.Air.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Air.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Air.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 5 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Crouching.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Crouching.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Crouching.Yaw:get(), -Lua.Antiaim.Custom.Crouching.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Crouching.Yaw:get(), Lua.Antiaim.Custom.Crouching.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Crouching.Yaw:get())
			end

			if Lua.Antiaim.Custom.Crouching.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Crouching.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Crouching.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Crouching.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Crouching.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Crouching.OverrideSpin:get())

			if Lua.Antiaim.Custom.Crouching.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Crouching.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Crouching.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Crouching.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Crouching.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Crouching.SpinSpeed:get())

			if Lua.Antiaim.Custom.Crouching.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 6 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.CrouchingInAir.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.CrouchingInAir.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.CrouchingInAir.Yaw:get(), -Lua.Antiaim.Custom.CrouchingInAir.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.CrouchingInAir.Yaw:get(), Lua.Antiaim.Custom.CrouchingInAir.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.CrouchingInAir.Yaw:get())
			end

			if Lua.Antiaim.Custom.CrouchingInAir.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.CrouchingInAir.OverrideSpin:get())

			if Lua.Antiaim.Custom.CrouchingInAir.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.CrouchingInAir.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.CrouchingInAir.SpinSpeed:get())

			if Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 7 then
			Ui.Antiaim.Pitch:set(Lua.Antiaim.Custom.Deffensive.Pitch:get())

			if Lua.Antiaim.Custom.Deffensive.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Deffensive.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Deffensive.Yaw:get(), -Lua.Antiaim.Custom.Deffensive.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Deffensive.Yaw:get(), Lua.Antiaim.Custom.Deffensive.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Deffensive.Yaw:get())
			end

			if Lua.Antiaim.Custom.Deffensive.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Deffensive.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Deffensive.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Deffensive.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Deffensive.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Deffensive.OverrideSpin:get())

			if Lua.Antiaim.Custom.Deffensive.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Deffensive.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Deffensive.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Deffensive.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Deffensive.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Deffensive.SpinSpeed:get())

			if Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.DesyncRight:get()))
			end
		end
	end
end

local function CFakelag(antiaim)
	local Fluctate = 0
	local BreakLagcomp = 64.0 / (GetVelocity() * global_vars.interval_per_tick())

	if AntiaimCondition() == 1 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Standing.Amount:get()

		if Lua.Fakelag.Standing.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Standing.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Standing.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Standing.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Standing.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Standing.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Standing.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 2 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Walking.Amount:get()

		if Lua.Fakelag.Walking.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Walking.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Walking.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Walking.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Walking.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Walking.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Walking.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 3 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Running.Amount:get()

		if Lua.Fakelag.Running.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Running.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Running.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Running.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Running.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Running.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Running.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 4 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Air.Amount:get()

		if Lua.Fakelag.Air.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Air.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Air.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Air.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Air.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Air.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Air.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 5 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Crouching.Amount:get()

		if Lua.Fakelag.Crouching.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Crouching.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Crouching.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Crouching.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Crouching.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Crouching.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Crouching.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 6 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.CrouchingInAir.Amount:get()

		if Lua.Fakelag.CrouchingInAir.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.CrouchingInAir.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.CrouchingInAir.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.CrouchingInAir.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.CrouchingInAir.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.CrouchingInAir.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.CrouchingInAir.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	end
end	

local function UiModule()

	Lua.Antiaim.Preset:set_visible(false)

	Lua.Antiaim.NWay.Type:set_visible(false)

	Lua.Antiaim.NWay.Timings:set_visible(false)
	Lua.Antiaim.NWay.YawFirstSide:set_visible(false)
	Lua.Antiaim.NWay.YawSecondSide:set_visible(false)
	Lua.Antiaim.NWay.YawThirdSide:set_visible(false)
	Lua.Antiaim.NWay.YawFourthSide:set_visible(false)
	Lua.Antiaim.NWay.YawFivthSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncOverride:set_visible(false)
	Lua.Antiaim.NWay.DesyncFirstSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncSecondSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncThirdSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncFourthSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)

	Lua.Antiaim.Custom.Mode:set_visible(false)

	Lua.Antiaim.Custom.Standing.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Standing.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Standing.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Standing.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Standing.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Standing.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Standing.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Standing.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Standing.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Standing.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Standing.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Standing.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Walking.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Walking.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Walking.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Walking.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Walking.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Walking.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Walking.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Walking.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Walking.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Walking.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Walking.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Walking.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Running.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Running.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Running.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Running.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Running.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Running.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Running.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Running.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Running.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Running.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Running.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Running.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Air.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Air.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Air.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Air.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Air.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Air.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Air.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Air.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Air.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Air.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Air.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Air.DesyncRight:set_visible(false)
	
	Lua.Antiaim.Custom.Crouching.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Crouching.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Crouching.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Crouching.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Crouching.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Crouching.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Crouching.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Crouching.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.CrouchingInAir.Yaw:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.JitterType:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.SpinType:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Deffensive.Sensivity:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.Pitch:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DesyncRight:set_visible(false)

	Lua.Fakelag.MoveType:set_visible(false)

	Lua.Fakelag.Standing.Amount:set_visible(false)
	Lua.Fakelag.Standing.Mode:set_visible(false)
	
	Lua.Fakelag.Walking.Amount:set_visible(false)
	Lua.Fakelag.Walking.Mode:set_visible(false)

	Lua.Fakelag.Running.Amount:set_visible(false)
	Lua.Fakelag.Running.Mode:set_visible(false)

	Lua.Fakelag.Air.Amount:set_visible(false)
	Lua.Fakelag.Air.Mode:set_visible(false)

	Lua.Fakelag.Crouching.Amount:set_visible(false)
	Lua.Fakelag.Crouching.Mode:set_visible(false)

	Lua.Fakelag.CrouchingInAir.Amount:set_visible(false)
	Lua.Fakelag.CrouchingInAir.Mode:set_visible(false)
	
	if Lua.OverrideAntiaim:get() then
		Lua.Antiaim.Preset:set_visible(true)

		if Lua.Antiaim.Preset:get() == 4 then
			Lua.Antiaim.NWay.Type:set_visible(true)

			Lua.Antiaim.NWay.Timings:set_visible(true)

			if Lua.Antiaim.NWay.Type:get() == 1 then
				Lua.Antiaim.NWay.YawFirstSide:set_visible(true)
				Lua.Antiaim.NWay.YawSecondSide:set_visible(true)
				Lua.Antiaim.NWay.YawThirdSide:set_visible(true)
				Lua.Antiaim.NWay.YawFourthSide:set_visible(false)
				Lua.Antiaim.NWay.YawFivthSide:set_visible(false)
			elseif Lua.Antiaim.NWay.Type:get() == 2 then
				Lua.Antiaim.NWay.YawFirstSide:set_visible(true)
				Lua.Antiaim.NWay.YawSecondSide:set_visible(true)
				Lua.Antiaim.NWay.YawThirdSide:set_visible(true)
				Lua.Antiaim.NWay.YawFourthSide:set_visible(true)
				Lua.Antiaim.NWay.YawFivthSide:set_visible(false)
			elseif Lua.Antiaim.NWay.Type:get() == 3 then
				Lua.Antiaim.NWay.YawFirstSide:set_visible(true)
				Lua.Antiaim.NWay.YawSecondSide:set_visible(true)
				Lua.Antiaim.NWay.YawThirdSide:set_visible(true)
				Lua.Antiaim.NWay.YawFourthSide:set_visible(true)
				Lua.Antiaim.NWay.YawFivthSide:set_visible(true)
			end

			Lua.Antiaim.NWay.DesyncOverride:set_visible(true)

			if Lua.Antiaim.NWay.DesyncOverride:get() then
				if Lua.Antiaim.NWay.Type:get() == 1 then
					Lua.Antiaim.NWay.DesyncFirstSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncSecondSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncThirdSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFourthSide:set_visible(false)
					Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)
				elseif Lua.Antiaim.NWay.Type:get() == 2 then
					Lua.Antiaim.NWay.DesyncFirstSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncSecondSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncThirdSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFourthSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)
				elseif Lua.Antiaim.NWay.Type:get() == 3 then
					Lua.Antiaim.NWay.DesyncFirstSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncSecondSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncThirdSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFourthSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFivthSide:set_visible(true)
				end
			else
				Lua.Antiaim.NWay.DesyncFirstSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncSecondSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncThirdSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncFourthSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)
			end
		end

		if Lua.Antiaim.Preset:get() == 5 then
			Lua.Antiaim.Custom.Mode:set_visible(true)

			if Lua.Antiaim.Custom.Mode:get() == 1 then
				Lua.Antiaim.Custom.Standing.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Standing.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Standing.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Standing.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Standing.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Standing.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Standing.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Standing.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Standing.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Standing.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Standing.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Standing.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 2 then
				Lua.Antiaim.Custom.Walking.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Walking.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Walking.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Walking.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Walking.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Walking.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Walking.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Walking.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Walking.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Walking.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Walking.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Walking.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 3 then
				Lua.Antiaim.Custom.Running.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Running.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Running.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Running.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Running.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Running.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Running.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Running.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Running.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Running.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Running.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Running.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 4 then
				Lua.Antiaim.Custom.Air.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Air.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Air.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Air.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Air.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Air.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Air.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Air.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Air.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Air.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Air.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Air.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 5 then
				Lua.Antiaim.Custom.Crouching.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Crouching.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Crouching.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Crouching.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Crouching.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Crouching.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Crouching.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Crouching.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Crouching.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Crouching.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Crouching.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Crouching.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 6 then
				Lua.Antiaim.Custom.CrouchingInAir.Yaw:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.CrouchingInAir.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.JitterType:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.CrouchingInAir.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.SpinType:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.CrouchingInAir.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 7 then
				Lua.Antiaim.Custom.Deffensive.Sensivity:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.Pitch:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.DesyncRight:set_visible(true)
			end
		end
	end

	if Lua.OverrideFakelag:get() then
		Lua.Fakelag.MoveType:set_visible(true)

		if Lua.Fakelag.MoveType:get() == 1 then
			Lua.Fakelag.Standing.Amount:set_visible(true)
			Lua.Fakelag.Standing.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 2 then
			Lua.Fakelag.Walking.Amount:set_visible(true)
			Lua.Fakelag.Walking.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 3 then
			Lua.Fakelag.Running.Amount:set_visible(true)
			Lua.Fakelag.Running.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 4 then
			Lua.Fakelag.Air.Amount:set_visible(true)
			Lua.Fakelag.Air.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 5 then
			Lua.Fakelag.Crouching.Amount:set_visible(true)
			Lua.Fakelag.Crouching.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 6 then
			Lua.Fakelag.CrouchingInAir.Amount:set_visible(true)
			Lua.Fakelag.CrouchingInAir.Mode:set_visible(true)
		end
	end
end

function HookAntiaim(antiaim)
	if Lua.OverrideFakelag:get() and Ui.Exploits.Doubletap[2]:get() == false then
		CFakelag(antiaim)
	end
end

function HookRender()
	UiModule()

	if Lua.OverrideAntiaim:get() then
		if entity_list.get_local_player() ~= nil then
			if entity_list.get_local_player():get_prop("m_iHealth") > 0 then
				CAntiaim()
			end
		end
	end
end

callbacks.add(e_callbacks.ANTIAIM, HookAntiaim)
callbacks.add(e_callbacks.PAINT, HookRender)