--[[
    icedancer for the primordial.dev community
    thanks to @lizzy
    thanks to @scorp
    15th april 2022

    to do list :
        - try to figure out how to change the "force min. damage"
        - optimize

    update log (date) :
]]

local checkbox = menu.add_checkbox("Made by icedancer", "Adaptive Config", false)
local symmetryCheckbox = menu.add_checkbox("ignore this, it's for symmetry", "adaptive.lua", false)

-- deagle config elements
local DeagleHitchance = menu.add_slider("Desert Eagle", "hitchance", 0, 100)
local DeagleDTHitchance = menu.add_slider("Desert Eagle", "doubletap hitchance", 0, 100)
local DeagleDynamicHitchance = menu.add_checkbox("Desert Eagle", "adaptive hitchance", false)
local DeagleMinDamage = menu.add_slider("Desert Eagle", "min. damage", 0, 101)
local DeagleScaleDmg = menu.add_checkbox("Desert Eagle", "scale damage based on hp", false)
local DeagleTargetSelection = menu.add_selection("Desert Eagle", "target selection", {"crosshair", "distance", "health"})

local DeagleHitboxes = menu.add_multi_selection("Desert Eagle", "hitboxes", {"head", "chest", "arms", "stomach", "legs", "feet"})
local DeagleMultipoints = menu.add_multi_selection("Desert Eagle", "multipoints", {"head", "chest", "arms", "stomach", "legs", "feet"})
local DeaglePreferHitboxes = menu.add_multi_selection("Desert Eagle", "prefer hitboxes", {"head", "chest", "arms", "stomach", "legs", "feet"})
local DeagleSafeHitboxes = menu.add_multi_selection("Desert Eagle", "safe hitboxes", {"head", "chest", "arms", "stomach", "legs", "feet"})
local DeagleIgnoreLimbs = menu.add_checkbox("Desert Eagle", "ignore limbs if moving", false)

local DeagleSafepoint = menu.add_selection("Desert Eagle", "safepoint", {"normal", "strict"})
local DeagleForceSafepointStates = menu.add_multi_selection("Desert Eagle", "force safepoint states", {"in air", "second doubletap shot", "unresolved", "on peek", "on enemy peek", "lethal", "on enemy shot"})
local DeagleAutostop = menu.add_checkbox("Desert Eagle", "autostop", false)
local DeagleAutostopOptions = menu.add_multi_selection("Desert Eagle", "autostop options", {"full stop", "stop between shots", "early", "dont stop in fire", "delay shot until fully accurate", "crouch"})

-- local DeagleForceMinDamage = menu.add_slider("Desert Eagle", "force min. damage", 1, 101)

-- r8 config elements
local R8Hitchance = menu.add_slider("R8 Revolver", "hitchance", 0, 100)
local R8DTHitchance = menu.add_slider("R8 Revolver", "doubletap hitchance", 0, 100)
local R8DynamicHitchance = menu.add_checkbox("R8 Revolver", "adaptive hitchance", false)
local R8MinDamage = menu.add_slider("R8 Revolver", "min. damage", 0, 101)
local R8ScaleDmg = menu.add_checkbox("R8 Revolver", "scale damage based on hp", false)
local R8TargetSelection = menu.add_selection("R8 Revolver", "target selection", {"crosshair", "distance", "health"})

local R8Hitboxes = menu.add_multi_selection("R8 Revolver", "hitboxes", {"head", "chest", "arms", "stomach", "legs", "feet"})
local R8Multipoints = menu.add_multi_selection("R8 Revolver", "multipoints", {"head", "chest", "arms", "stomach", "legs", "feet"})
local R8PreferHitboxes = menu.add_multi_selection("R8 Revolver", "prefer hitboxes", {"head", "chest", "arms", "stomach", "legs", "feet"})
local R8SafeHitboxes = menu.add_multi_selection("R8 Revolver", "safe hitboxes", {"head", "chest", "arms", "stomach", "legs", "feet"})
local R8IgnoreLimbs = menu.add_checkbox("R8 Revolver", "ignore limbs if moving", false)

local R8Safepoint = menu.add_selection("R8 Revolver", "safepoint", {"normal", "strict"})
local R8ForceSafepointStates = menu.add_multi_selection("R8 Revolver", "force safepoint states", {"in air", "second doubletap shot", "unresolved", "on peek", "on enemy peek", "lethal", "on enemy shot"})
local R8Autostop = menu.add_checkbox("R8 Revolver", "autostop", false)
local R8AutostopOptions = menu.add_multi_selection("R8 Revolver", "autostop options", {"full stop", "stop between shots", "early", "dont stop in fire", "delay shot until fully accurate", "crouch"})

-- local R8ForceMinDamage = menu.add_slider("R8 Revolver", "force min. damage", 1, 101)

-- menu elements that we will swap with the revolver/deagle elements
local hitchance = menu.find("aimbot", "heavy pistols", "targeting", "hitchance")
local DTHitchance = menu.find("aimbot", "heavy pistols", "targeting", "doubletap hitchance")
local dynamicHitchance = menu.find("aimbot", "heavy pistols", "targeting", "dynamic hitchance")
local minDamage = menu.find("aimbot", "heavy pistols", "targeting", "min. damage")
local scaleDmg = menu.find("aimbot", "heavy pistols", "targeting", "scale damage based on hp")
local ignoreLimbs = menu.find("aimbot", "heavy pistols", "hitbox selection", "ignore limbs if moving")
local autostop = menu.find("aimbot", "heavy pistols", "accuracy", "autostop")
local hitboxes = menu.find("aimbot", "heavy pistols", "hitbox selection", "hitboxes")
local multipoints = menu.find("aimbot", "heavy pistols", "hitbox selection", "multipoints")
local preferHitboxes = menu.find("aimbot", "heavy pistols", "hitbox selection", "prefer hitboxes")
local safeHitboxes = menu.find("aimbot", "heavy pistols", "hitbox selection", "safe hitboxes")
local safepoint = menu.find("aimbot", "heavy pistols", "accuracy", "safepoint")
local forceSafepointStates = menu.find("aimbot", "heavy pistols", "accuracy", "force safepoint states")
local autostopOptions = menu.find("aimbot", "heavy pistols", "accuracy", "options")

-- get the local player's weapon
local function getweapon()

    -- get local player and check if the localplayer exists
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    
    local weapon_name = nil

    -- check if we are alive and get the active weapon's name
    if local_player:get_prop("m_iHealth") > 0 then
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end
        weapon_name = active_weapon:get_name()
    else return end

    -- return the weapon's string
    return weapon_name
end

-- change the heavy pistol config accordingly depending on what weapon we are holding.
local function on_event(event)
    if checkbox then
        local i

        -- call the getweapon() function and check which gun is in hand
        if getweapon() == "deagle" then

            -- modify menu elements with the given values from the script
            hitchance:set(DeagleHitchance:get())
            DTHitchance:set(DeagleDTHitchance:get())
            dynamicHitchance:set(DeagleDynamicHitchance:get())
            minDamage:set(DeagleMinDamage:get())
            scaleDmg:set(DeagleScaleDmg:get())
            ignoreLimbs:set(DeagleIgnoreLimbs:get())
            autostop:set(DeagleAutostop:get())
            safepoint:set(DeagleSafepoint:get())
            -- all of the variables in this for have 6 values, hence why the for goes from 1 to 6
            for i=1,6,1 do 
                hitboxes:set(i, DeagleHitboxes:get(i))
                multipoints:set(i, DeagleMultipoints:get(i))
                preferHitboxes:set(i, DeaglePreferHitboxes:get(i))
                safeHitboxes:set(i, DeagleSafeHitboxes:get(i))
                autostopOptions:set(i, DeagleAutostopOptions:get(i))
            end

            -- there are 7 options for the force safepoint states, so the for will go from 1 to 7 to replace all 7 values
            for i=1,7,1 do
                forceSafepointStates:set(i, DeagleForceSafepointStates:get(i))
            end
        elseif getweapon() == "revolver" then
            hitchance:set(R8Hitchance:get())
            DTHitchance:set(R8DTHitchance:get())
            dynamicHitchance:set(R8DynamicHitchance:get())
            minDamage:set(R8MinDamage:get())
            scaleDmg:set(R8ScaleDmg:get())
            ignoreLimbs:set(R8IgnoreLimbs:get())
            autostop:set(R8Autostop:get())
            safepoint:set(R8Safepoint:get())
            for i=1,6,1 do
                hitboxes:set(i, R8Hitboxes:get(i))
                multipoints:set(i, R8Multipoints:get(i))
                preferHitboxes:set(i, R8PreferHitboxes:get(i))
                safeHitboxes:set(i, R8SafeHitboxes:get(i))
                autostopOptions:set(i, R8AutostopOptions:get(i))
            end

            -- there are 7 options for the force safepoint states, so the for will go from 1 to 7 to replace all 7 values
            for i=1,7,1 do
                forceSafepointStates:set(i, R8ForceSafepointStates:get(i))
            end
        end
    end
end


-- callback
callbacks.add(e_callbacks.EVENT, on_event)