local fakeFlick = menu.add_checkbox("Angles", "Flick")
local flickBind = fakeFlick:add_keybind("Fake Flick")
local inverter = menu.add_checkbox("Angles", "Inverter")
local inverterBind = inverter:add_keybind("Inverter bind")
local flickPitch = menu.add_checkbox("Angles", "Flick Pitch")
local flickPitchBind = flickPitch:add_keybind("Angles", "Flick Pitch")
local fakeFlickOptionals = menu.add_checkbox("Angles", "Flick Optionals")
local flickSlider = menu.add_slider("Angles", "Flick Angle", 40, 180)
local returnFlickSlider = menu.add_slider("Angles", "Return Flick Angle", -40, 40);
local dualFlick = menu.add_checkbox("Angles", "Dual Flick")
local flickFrequency = menu.add_slider("Angles", "Flick Frequency", 15, 17)
local flickPitchActivation = menu.add_selection("Angles", "Flick Pitch Activation", {"None", "Down", "Up", "Zero", "Jitter"})
local flickPitchActivationFallback = menu.add_selection("Angles", "Flick Pitch Default", {"None", "Down", "Up", "Zero", "Jitter"})

local pitch = menu.find("antiaim", "main", "angles", "pitch")
local noPitch = menu.find("antiaim", "main", "angles", "pitch", "none")
local downPitch = menu.find("antiaim", "main", "angles", "pitch", "down")
local yawAdd = menu.find("antiaim", "main", "angles", "yaw add")
local yawBase = menu.find("antiaim", "main", "angles", "yaw base")
local velocityYawBase = menu.find("antiaim", "main", "angles", "yaw base", "velocity")
local viewangleYawBase = menu.find("antiaim", "main", "angles", "yaw base", "viewangle")

local flickPitchActivationValue = nil 
local alive = nil

local function playerCheck()
    local lp = entity_list.get_local_player()
    if not lp or lp == nil or not lp:is_alive() then
        alive = false
    else
        alive = true
    end
end

local function handleVisibility()
    inverter:set_visible(fakeFlick:get())
    if dualFlick:get() == true then
        inverter:set_visible(fakeFlick:get(), false)
    else
        inverter:set_visible(fakeFlick:get())
    end
    flickPitch:set_visible(fakeFlick:get())
    flickPitchActivation:set_visible(flickPitch:get())
    flickPitchActivationFallback:set_visible(flickPitch:get())
    fakeFlickOptionals:set_visible(fakeFlick:get())
    dualFlick:set_visible(fakeFlick:get())
    flickSlider:set_visible(fakeFlickOptionals:get())
    returnFlickSlider:set_visible(fakeFlickOptionals:get())
    flickFrequency:set_visible(fakeFlick:get())
    
end

local function handleBinds()
    if (flickPitchBind:get()) and (flickPitch:get()) == true then
        flickPitchActivationValue = true
    else
        flickPitchActivationValue = false
    end
end

local function fakeFlickHandler()	
	local TickcountModulo = global_vars.tick_count() % flickFrequency:get()
	if fakeFlickOptionals:get() then
        local Flick = TickcountModulo == 6
        if (flickBind:get()) then
            if Flick then
                if inverterBind:get() then
                    yawAdd:set(-flickSlider:get())
                    if flickPitchActivationValue == true then
                        pitch:set(flickPitchActivation() + 1)
                    else
                        pitch:set(2)
                    end
                else
                    yawAdd:set(flickSlider:get())
                    if flickPitchActivationValue == true then
                        pitch:set(flickPitchActivation() + 1)
                    else
                        pitch:set(2)
                    end
                end
            else
                yawAdd:set(returnFlickSlider:get())
                if flickPitchActivationValue == true then
                    pitch:set(flickPitchActivationFallback() + 1)
                else
                    pitch:set(2)
                end
            end
        end
    end
	if not fakeFlickOptionals:get() then
		local Flick = TickcountModulo == 6
        if (flickBind:get()) then
			if Flick then
				if inverterBind:get() then
					yawAdd:set(-90)
                    if flickPitchActivationValue == true then
                        pitch:set(flickPitchActivation() + 1)
                    else
                        pitch:set(2)
                    end
                else
                    yawAdd:set(90)
                    if flickPitchActivationValue == true then
                        pitch:set(flickPitchActivation() + 1)
                    else
                        pitch:set(2)
                    end
                end
			else
                yawAdd:set(0)
                if flickPitchActivationValue == true then
                    pitch:set(flickPitchActivationFallback() + 1)
                else
                    pitch:set(2)
                end
			end
		end
	end
end

local function dualFakeFlickHandler()	
	local TickcountModulo = global_vars.tick_count() % flickFrequency:get()
	if fakeFlickOptionals:get() then
		local Flick = TickcountModulo == 1
        local Flick2 = TickcountModulo == 2
        if (flickBind:get()) then
            if Flick2 then
                yawAdd:set(-flickSlider:get())
                if flickPitchActivationValue == true then
                    pitch:set(flickPitchActivation() + 1)
                else
                    pitch:set(2)
                end
            else
                yawAdd:set(returnFlickSlider:get())
                if flickPitchActivationValue == true then
                    pitch:set(flickPitchActivationFallback() + 1)
                else
                    pitch:set(2)
                end
            end
            if Flick then
                yawAdd:set(flickSlider:get())
                if flickPitchActivationValue == true then
                    pitch:set(flickPitchActivation() + 1)
                else
                    pitch:set(2)
                end
			end
        end
    end
	if not fakeFlickOptionals:get() then
		local Flick = TickcountModulo == 1
        local Flick2 = TickcountModulo == 2
        if (flickBind:get()) then
            if Flick2 then
                yawAdd:set(-90)
                if flickPitchActivationValue == true then
                    pitch:set(flickPitchActivation() + 1)
                else
                    pitch:set(2)
                end
            else
                yawAdd:set(0)
                if flickPitchActivationValue == true then
                    pitch:set(flickPitchActivationFallback() + 1)
                else
                    pitch:set(2)
                end
            end
            if Flick then
                yawAdd:set(90)
                if flickPitchActivationValue == true then
                    pitch:set(flickPitchActivation() + 1)
                else
                    pitch:set(2)
                end
			end
		end
	end
end

local function handleVisibilityFunction()
    handleVisibility()

    if fakeFlick:get() == true then
        if flickBind:get() == true then
            if dualFlick:get() == true then
                dualFakeFlickHandler()
            else
                fakeFlickHandler()
            end
        end
    end
end

callbacks.add(e_callbacks.PAINT, playerCheck)
callbacks.add(e_callbacks.PAINT, handleVisibility)
callbacks.add(e_callbacks.PAINT, handleVisibilityFunction)
callbacks.add(e_callbacks.PAINT, handleBinds)