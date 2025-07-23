-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

--[[
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
]]

--[[ 
    Better Neverlose LUA FRIENDLY EDIT/ESSENTIALS
    Project owner: xXYu3_zH3nGL1ngXx, FastVoider
    Updated date: 9/16/2023
]]

_DEBUG = true

----------------------- FFI CODE ---------------------
local ffi = require("ffi")

ffi.cdef[[
	bool PlaySound(
		const char* pszSound,
		void* hmod,
		unsigned int fdwSound
	);
]]
------------------------------------------------------

local nick = {} -- You can't replace/change this name

local weapons = {"Global","SSG-08","Pistols","AutoSnipers","Snipers","Rifles","SMGs","Shotguns","Machineguns","AWP","AK-47","M4A1/M4A4","Desert Eagle","R8 Revolver","AUG/SG 553","Taser"}
local ui_ragebot = {}

nick.ref = {
    ["ragebot"] = {
        main = ui.find("Aimbot", "Ragebot", "Main"),
        autopeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
        hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
        dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
        lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
        hs_options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
        hitboxes = ui.find("Aimbot", "Ragebot", "Selection", "Hitboxes"),
        multipoint = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint"),
        safepoint = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
        baim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
        safety = ui.find("Aimbot", "Ragebot", "Safety"),
        accuracy = ui.find("Aimbot", "Ragebot", "Accuracy", "SSG-08"),
    },
    ["antiaim"] = {
        angles = ui.find("Aimbot", "Anti Aim", "Angles"),
        pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
        yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
        base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
        offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
        fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag"),
        misc = ui.find("Aimbot", "Anti Aim", "Misc"),
        bodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
        fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):disabled(true),
        fl_enabled = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
        aa_enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
        limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
        fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")
    },
    ["world"] = {
        main = ui.find("Visuals", "World", "Main"),
        other = ui.find("Visuals", "World", "Other"),
    },
    ["misc"] = {
        in_game = ui.find("Miscellaneous", "Main", "In-Game"),
        other = ui.find("Miscellaneous", "Main", "Other"),
        air_strafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),
    }
}

nick.ragebot_item = function ()

    for i, v in ipairs(weapons) do
        ui_ragebot[i] = {
            only_head = ui.find("Aimbot", "Ragebot", "Safety", v):switch("Only Head"),
            baim = ui.find("Aimbot", "Ragebot", "Safety", v):switch("Force Baim"),
            safe = ui.find("Aimbot", "Ragebot", "Safety", v):switch("Force Safe Point"),

        }
    end

end
    
nick.menu = {
    ["ragebot"] = {
        tp = nick.ref.ragebot.main:switch("Teleport on Key (BIND)"):tooltip("Bind a key. Exploits charged and press key to teleport"),
        ax = nick.ref.ragebot.main:switch("\aF7FF8FFFAnti Defensive"):tooltip("Disabling lag compensation will allow to hit players which using defensive/lag-peek exploit.\n\nIt affects ragebot accuracy, avoid using it on high ping/head shot weapons\n\n\aF7FF8FFFTip: Does not bypass cl_lagcompensation detection, this operation may not be supported on some servers"),
        os_peek = nick.ref.ragebot.main:switch("OS Peek"):tooltip("Safety lag peek\n\nTeleport a short ticks in shooting"),
        jumpscout = nick.ref.ragebot.accuracy:switch("Jumpscout"):tooltip("Allow to static jump to stabilize accuracy"),
    },
    ["antiaim"] = {
        fakeflick = nick.ref.antiaim.angles:switch("Fake Flick (BETA)"):tooltip("Testing phase\n\nYou need to use it with Manual AA (Left and Right)\n\n\a698EFFFF" .. ui.get_icon("triangle-exclamation") .. " You need to bind it and use Hold, it is strongly recommended to bind it with Manual AA on a Key, Manual AA is not an override"),
        alwayschoke = nick.ref.antiaim.fakelag:switch("Always Chock"):tooltip("Disabled variability jitter send packet"):disabled(true),
        flonshot = nick.ref.antiaim.fakelag:switch("Slient shots"):tooltip("A.K.A No fakelag on shots\n\nForce send packet while every shots"),
        manualaa = nick.ref.antiaim.misc:combo("Manual AA", {"None", "Left", "Backwards", "Right", "Forwards", "Freestanding"}):tooltip("\a698EFFFF" .. ui.get_icon("triangle-exclamation") .. " If you need to use Fake Flick, it is strongly recommended that you bind the keys, otherwise the settings will be messed up"),
    },
    ["world"] = {
        viewmodel = nick.ref.world.main:switch("Custom Viewmodel"):tooltip("Allow to change viewmodel fov"),
        debug = nick.ref.world.main:switch("\a698EFFFF" .. ui.get_icon("triangle-exclamation") .. " Debug Mode"),
        misssound = nick.ref.world.other:switch("Missed sound"):tooltip("Play sound when missed shot\n\nPut the files in [csgo folder]/sound"),
        indicator = nick.ref.world.other:switch("Indicators"):tooltip("Still in beta. Hold on!")
    },
    ["misc"] = {
        sv_cheat = nick.ref.misc.other:switch("Force sv_cheats"):tooltip("Unlock some client commands need sv_cheats 1"),
        sv_pure  = nick.ref.misc.other:switch("Bypass sv_pure"):tooltip("Bypass server checking local game files\n\nThat's allow you to use thrid-party model files in official server or enabled sv_pure server"),
        killsay  = nick.ref.misc.in_game:switch("Trashtalk on kill"):tooltip("Say something nonsense talk while kill a enemy"),
        vote     = nick.ref.misc.in_game:switch("Vote reveals"):tooltip("Print the voting information on the console")
    }
}

nick.CreateElements = {
    ["ragebot"] = {
        ospeek = nick.menu.ragebot.os_peek:create(),
        dt = nick.ref.ragebot.dt:create(),
    },
    ["antiaim"] = {
--        defensive = nick.menu.antiaim.defensive:create(),
        fakeflick = nick.menu.antiaim.fakeflick:create(),
        alwayschoke = nick.menu.antiaim.alwayschoke:create(),
        slientshots = nick.menu.antiaim.flonshot:create(),
    },
    ["world"] = {
        viewmodel = nick.menu.world.viewmodel:create(),
        debug = nick.menu.world.debug:create(),
        missed = nick.menu.world.misssound:create(),
        indicator = nick.menu.world.indicator:create(),
    },
    ["misc"] = {
        killsay = nick.menu.misc.killsay:create(),
    }
}

nick.Elements = {
    ["ospeek"] = {
        breaklc = nick.CreateElements.ragebot.ospeek:switch("Break LC"):tooltip("Breaking backtrack"),
    },
--    ["defensive"] = {
--        pitch = nick.CreateElements.antiaim.defensive:combo("Pitch", {"Zero", "Up", "Down", "Random", "Jitter"}),
--        yaw = nick.CreateElements.antiaim.defensive:combo("Yaw", {"Static", "Random", "Jitter", "Spin"}),
--        inair = nick.CreateElements.antiaim.defensive:switch("Only In air"),
--        spin = nick.CreateElements.antiaim.defensive:slider("Spin speed", 120, 7200, 1300),
--    },
    ["fakeflick"] = {
        timer = nick.CreateElements.antiaim.fakeflick:slider("LBY Break timer", 30, 160),
    },
    ["alwayschoke"] = {
        mode = nick.CreateElements.antiaim.alwayschoke:combo("Mode", {"Limit", "Maxmium"}),
    },
    ["slientshots"] = {
        mode = nick.CreateElements.antiaim.slientshots:combo("Mode", "Overrides", "Send packets"),
    },
    ["miss_sound"] = {
        files = nick.CreateElements.world.missed:input("File name"),
        volume = nick.CreateElements.world.missed:slider("Volume", 0, 100, 70),
    },
    ["viewmodel"] = {
        fov = nick.CreateElements.world.viewmodel:slider("Fov", 0, 100, 90),
        x = nick.CreateElements.world.viewmodel:slider("X", - 15, 15, 0),
        y = nick.CreateElements.world.viewmodel:slider("Y", - 15, 15, 0),
        z = nick.CreateElements.world.viewmodel:slider("Z", - 15, 15, 0),
        aspectratio = nick.CreateElements.world.viewmodel:slider("Aspect Ratio", 0, 100, 0, 0.1),
    },
    ["debug"] = {
        watermark = nick.CreateElements.world.debug:switch("Watermark"),
        list = nick.CreateElements.world.debug:listable("Elements", {"Feet Yaw", "Choked Commands", "Real Yaw", "Abs Yaw", "Desync"}),
    },
    ["trashtalk"] = {
        text = nick.CreateElements.misc.killsay:input("Text"),
        check = nick.CreateElements.misc.killsay:switch("Add username"),
        test = nick.CreateElements.misc.killsay:label("\a698EFFFF" .. ui.get_icon("triangle-exclamation") .. " add username needs to be typed with a %s in the text, no more. Otherwise the script will crash, this is to let the user decide where to let the victim's name appear")
    },
    ["indicator"] = {
        crosshair = nick.CreateElements.world.indicator:switch("Crosshair"),
        left = nick.CreateElements.world.indicator:listable("Elements", {"Double Tap & Hide Shots", "Fake Duck", "Antiaim info", "AX", "DMG", "HS"}),
    },
    ["tp"] = {
        tp = nick.CreateElements.ragebot.dt:switch("Automatic Teleport"),
        inair = nick.CreateElements.ragebot.dt:switch("Auto Teleport in Air"),
    }
}


nick.CffiHelper = {
    PlaySound = (function()
		local PlaySound = utils.get_vfunc("engine.dll", "IEngineSoundClient003", 12, "void*(__thiscall*)(void*, const char*, float, int, int, float)")
		return function(sound_name, volume)
			local name = sound_name:lower():find(".wav") and sound_name or ("%s.wav"):format(sound_name)
			pcall(PlaySound, name, tonumber(volume) / 100, 100, 0, 0)
		end
	end)()
}

function normalize_yaw (angle)
    adjusted_yaw = angle;

    if adjusted_yaw < -180 then
        adjusted_yaw = adjusted_yaw + 360
    end
    
    if adjusted_yaw > 180 then
        adjusted_yaw = adjusted_yaw - 360
    end
    

    return adjusted_yaw;
end

local clamp = function (val, min, max) 
    if val > max then
        return max
    end

    if val < min then
        return min
    end

    return val
end

nick.menu.ragebot.tp:set_callback(function()
    if nick.menu.ragebot.tp:get() then
        rage.exploit:force_teleport()
    end
end)

nick.ax_function = function ()
    
    if nick.menu.ragebot.ax:get() then 
        cvar.cl_lagcompensation:int(0) 
    else 
        cvar.cl_lagcompensation:int(1) 
    end

end

nick.jumpscout_fix = function ()

    local localplayer = entity.get_local_player()
    if not localplayer then return end
    
    local vel = localplayer.m_vecVelocity
    local speed = math.sqrt(vel.x * vel.x + vel.y * vel.y)

    if nick.menu.ragebot.jumpscout:get() then
        nick.ref.misc.air_strafe:override(math.floor(speed) > 15)
    end

end

nick.os_peek = function ()

    local localplayer = entity.get_local_player()
    if not localplayer then return end

    local my_weapon = localplayer:get_player_weapon()

    if nick.Elements.ospeek.breaklc:get() then
        nick.ref.ragebot.hs_options:override("Break LC")
    else
        nick.ref.ragebot.hs_options:override()
    end

    if my_weapon then
        local last_shot_time = my_weapon["m_fLastShotTime"]
		local time_difference = globals.curtime - last_shot_time

        if nick.menu.ragebot.os_peek:get() then
            nick.ref.ragebot.autopeek:override(true)
            if time_difference <= 0.5 and time_difference >= 0.255 then
                nick.ref.ragebot.hs:override(false)
            elseif time_difference >= 0.5 then
                nick.ref.ragebot.hs:override(true)
            end
        else
            nick.ref.ragebot.hs_options:override()
            nick.ref.ragebot.autopeek:override()
            nick.ref.ragebot.hs:override()
        end
    end

end


local tick_count = 0

nick.fakeflick = function (cmd)

    if nick.menu.antiaim.fakeflick:get() then 

        nick.ref.antiaim.fl_enabled:override(false)
        nick.ref.antiaim.bodyyaw:override(false)

        tick_count = tick_count + 1
        if tick_count >= nick.Elements.fakeflick.timer:get() then
            if nick.menu.antiaim.manualaa:get() == "Left" then
                nick.menu.antiaim.manualaa:set("Right")
                utils.execute_after(globals.tickinterval / 100,function() 
                    nick.menu.antiaim.manualaa:set("Left")
                end)
            elseif nick.menu.antiaim.manualaa:get() == "Right" then
                nick.menu.antiaim.manualaa:set("Left")
                utils.execute_after(globals.tickinterval / 100,function() 
                    nick.menu.antiaim.manualaa:set("Right")
                end)
            elseif nick.menu.antiaim.manualaa:get() ~= "Right" and nick.menu.antiaim.manualaa:get() ~= "Left" then
                nick.menu.antiaim.manualaa:set()
            end
            tick_count = 0
        end
    
    else
        --nick.ref.antiaim.fl_enabled:override()
        --nick.ref.antiaim.bodyyaw:override()
    end
    
end

nick.always_choke_slient_shots = function()

    events.createmove:set(function(cmd)
    
        local localplayer = entity.get_local_player()
        if not localplayer then return end
    
        local my_weapon = localplayer:get_player_weapon()
    
        if nick.menu.antiaim.flonshot:get() then
            if my_weapon then
                local last_shot_time = my_weapon["m_fLastShotTime"]
    	    	local time_difference = globals.curtime - last_shot_time
        
                if time_difference <= 0.025 then
                    if nick.Elements.slientshots.mode:get() == "Overrides" then
                        nick.ref.antiaim.bodyyaw:override(false)
                        nick.ref.antiaim.fl_enabled:override(false)
                        nick.ref.antiaim.limit:override(1)
                    elseif nick.Elements.slientshots.mode:get() == "Send packets" then
                        --sendpacket_switch = true
                        cmd.no_choke = true
                    end
                else
                    nick.ref.antiaim.bodyyaw:override()
                    nick.ref.antiaim.fl_enabled:override()
                    nick.ref.antiaim.limit:override()
                end
            end
        end
    end)
end

nick.missed_sound = function ()
    events.aim_ack:set(function(e)
        if e.state ~= nil then
            if nick.menu.world.misssound:get() then    
                nick.CffiHelper.PlaySound(nick.Elements.miss_sound.files:get(), nick.Elements.miss_sound.volume:get())
            end
        end
    end)
end

nick.vote_reveals = function()
    events.vote_cast:set(function(e)
        -- Source from: https://en.neverlose.cc/market/item?id=7IeKYA
        -- This event only on https://wiki.alliedmods.net/Generic_Source_Events
    
        if not nick.menu.misc.vote:get() then return end
    
        local team = e.team
        local voteOption = e.vote_option == 0 and "YES" or "NO"
    
        local user = entity.get(e.entityid)
    	local userName = user:get_name()
    
        print(("%s voted %s"):format(userName, voteOption))
        print_dev(("%s voted %s"):format(userName, voteOption))
    end)
end

nick.cvar_changer = function ()

    if nick.menu.misc.sv_cheat:get() then
        cvar.sv_cheats:int(1)
    else
        cvar.sv_cheats:int()
    end

    if nick.menu.misc.sv_pure:get() then
        cvar.sv_pure:int(0)
    else
        cvar.sv_pure:int()
    end

end

nick.viewmodel = function ()

    fov = nick.Elements.viewmodel.fov:get()
    x = nick.Elements.viewmodel.x:get()
    y = nick.Elements.viewmodel.y:get()
    z = nick.Elements.viewmodel.z:get()
    aspectratio = nick.Elements.viewmodel.aspectratio:get() / 10

    if nick.menu.world.viewmodel:get() then
        cvar["sv_competitive_minspec"]:int(0)
        cvar["viewmodel_fov"]:float(fov)
        cvar["viewmodel_offset_x"]:float(x)
        cvar["viewmodel_offset_y"]:float(y)
        cvar["viewmodel_offset_z"]:float(z)
        cvar["r_aspectratio"]:float(aspectratio)
    else
        cvar["sv_competitive_minspec"]:int(1)
        cvar["viewmodel_fov"]:string("def.")
        cvar["viewmodel_offset_x"]:string("def.")
        cvar["viewmodel_offset_y"]:string("def.")
        cvar["viewmodel_offset_z"]:string("def.")
        cvar["r_aspectratio"]:float(0)
    end

end

nick.trashtalk = function ()
    events.aim_ack:set(function(e)
        local target = e.target
        local get_target_entity = entity.get(target)
        if not get_target_entity then return end
        
        local health = get_target_entity.m_iHealth
    
        if not target:get_name() or not health then return end
        
        if not nick.menu.misc.killsay:get() then
            return end
        if health == 0 then
            if nick.Elements.trashtalk.check:get() then
                utils.console_exec("say " .. (nick.Elements.trashtalk.text:get()):format(target:get_name()))
            else
                utils.console_exec("say " .. nick.Elements.trashtalk.text:get())
            end
            
        end
    end)
end

nick.debug_mode = function()

    if not nick.menu.world.debug:get() then return end


    local elements = {
        ["Feet Yaw"] = nick.Elements.debug.list:get("Feet Yaw"),
        ["Choked Commands"] = nick.Elements.debug.list:get("Choked Commands"),
        ["Real Yaw"] = nick.Elements.debug.list:get("Real Yaw"),
        ["Abs Yaw"] = nick.Elements.debug.list:get("Abs Yaw"),
        ["Desync"] = nick.Elements.debug.list:get("Desync"),
    }

    local x,y = render.screen_size().x,render.screen_size().y
    local time_h = string.format("%02d", common.get_system_time().hours)
    local time_m = string.format("%02d", common.get_system_time().minutes)
    local time_s = string.format("%02d", common.get_system_time().seconds)
    local time = time_h .. ":" .. time_m .. ":" .. time_s

    if nick.Elements.debug.watermark:get() then
        if not globals.is_in_game or not globals.is_connected then
            render.text(1, vector(10, y - 15), color(255,255,255), "", "neverlose.cc - \a4FFF1EFFSep 16 2023 for client version:".. common.get_product_version() .. "\aDEFAULT / " .. common.get_username() .. " [Debug Mode] " .. time .. "")
        else
            render.text(1, vector(10, y - 15), color(255,255,255), "", "neverlose.cc - \a4FFF1EFFSep 16 2023 for client version:".. common.get_product_version() .. "\aDEFAULT / " .. common.get_username() .. " [Debug Mode] " .. time .. " info: " .. utils.net_channel():get_server_info().address .. " | " .. utils.net_channel():get_server_info().name)
        end
    end

    if not entity.get_local_player() then return end
    if not globals.is_in_game or not globals.is_connected then return end
    local DesyncAngle = math.ceil(math.abs(normalize_yaw(entity.get_local_player():get_anim_state().eye_yaw % 360 - math.floor(entity.get_local_player():get_anim_state().abs_yaw) % 360)))



    -- from newbing XD
    local i = 0
    for element, value in pairs(elements) do
        if value then
            local position = vector(300, y - 800 + (15 * i))
            local text = ""
            
            if element == "Feet Yaw" then
                text = "Feet Yaw: " .. math.floor(entity.get_local_player().m_flPoseParameter[11] == nil and 0 or entity.get_local_player().m_flPoseParameter[11] * 120 - 60) or "Unknown ?"
            elseif element == "Choked Commands" then
                text = "Choke: " .. globals.choked_commands
            elseif element == "Real Yaw" then
                text = "Real yaw: " .. math.floor(entity.get_local_player():get_anim_state().eye_yaw)
            elseif element == "Abs Yaw" then
                text = "Abs yaw: " .. math.floor(entity.get_local_player():get_anim_state().abs_yaw)
            elseif element == "Desync" then
                text = "Desync: " .. DesyncAngle
            end
            render.text(1, position, color(255, 255, 255), "", text)
            i = i + 1
        end
    end
end
-- 1
local font = render.load_font("c:/windows/fonts/calibrib.ttf", 28, "ad")
local alpha = 255

nick.indicators = function()

    if not nick.menu.world.indicator:get() then return end

    local x, y = render.screen_size().x, render.screen_size().y
    local elements = {
        ["DT"] = nick.Elements.indicator.left:get("Double Tap & Hide Shots"),
        ["FD"] = nick.Elements.indicator.left:get("Fake Duck"),
        ["ANTIAIM"] = nick.Elements.indicator.left:get("Antiaim info"),
        ["AX"] = nick.Elements.indicator.left:get("AX"),
        ["DMG"] = nick.Elements.indicator.left:get("DMG"),
        ["HS"] = nick.Elements.indicator.left:get("HS")
    }
    local h = nil
    local i = 0
    local localplayer = entity.get_local_player()
    if not localplayer then return end
    
    local slowdown = entity.get_local_player().m_flVelocityModifier
    local fade_factor = ((1 / .15) * globals.frametime) * 255

    if localplayer:is_alive() then
        if (slowdown == 1 and alpha ~= 0) then
            alpha = clamp(alpha - fade_factor, 0, 255) 
        elseif (slowdown ~= 1 and alpha ~= 255) then
            alpha = clamp(alpha + fade_factor, 0, 255)
        end
    else
        alpha = 0
    end
    
    for element, value in pairs(elements) do
        if value then
            local position = vector(20, y - 500 + (35 * i))
            local text = ""
            local col = color(255, 0, 0)
            if element == "DT" and nick.ref.ragebot.dt:get() or nick.ref.ragebot.hs:get() then
                if nick.ref.ragebot.dt:get() then text = "DT" elseif nick.ref.ragebot.hs:get() then text = "ON SHOT" end
                if rage.exploit:get() == 1 then
                    col = color("cccccd")
                else
                    col = color("ff0000")
                end
            elseif element == "FD" and nick.ref.antiaim.fd:get() then
                text = "FD"
                col = color("cccccd")
            elseif element == "ANTIAIM" then
                if nick.menu.antiaim.manualaa:get() == "Left" then
                    text = "LEFT"
                elseif nick.menu.antiaim.manualaa:get() == "Backwards" then
                    text = "BACKWARDS"
                elseif nick.menu.antiaim.manualaa:get() == "Right" then
                    text = "RIGHT"
                elseif nick.menu.antiaim.manualaa:get() == "Forwards" then
                    text = "FORWARDS"
                elseif nick.menu.antiaim.manualaa:get() == "Freestanding" then
                    text = "FS"
                elseif nick.menu.antiaim.manualaa:get() == "None" then
                    text = "AA"
                end

                col = color("cccccd")
            elseif element == "AX" and nick.menu.ragebot.ax:get() then
                text = "AX"
                col = color("FFD65A")
            elseif element == "DMG" then
                text = "DMG: " .. ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()
                col = color("7fbd14")
            elseif element == "HS" then
                text = "HS: " .. ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):get()
                col = color("7fbd14")
            end
            render.text(font, position, col, "", text)
            i = i + 1
        end
    end

    if nick.Elements.indicator.crosshair:get() then
        render.text(1, vector(x / 2 - 110, y / 2 - 15), color("FFFFFF"), "", "" .. ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):get())
        render.text(1, vector(x / 2 + 100, y / 2 - 15), color("FFFFFF"), "", "" .. ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get())
    end

    if not entity.get_local_player() then return end
    render.shadow(vector(x/2 - 120,y / 2 - 333), vector(x/2 + 120,y / 2 - 325), color(76, 159, 242, alpha),20,0,1)
    render.rect_outline(vector(x/2 - 120,y / 2 - 333), vector(x/2 + 120,y / 2 - 325), color(0,0,0, alpha), 1.2)
    render.rect(vector(x/2 - 119,y / 2 - 332), vector(x/2 + slowdown * (119 - (-119)) + (-119) ,y / 2 - 326), color(168, 151, 205, alpha))
    render.text(1, vector(x / 2, y / 2 - 345), color(255,255,255,alpha), "c", "\a698EFFFF" .. ui.get_icon("triangle-exclamation") .. " Slowed Down: " .. math.floor(slowdown * 100 + 0.5) .. "%")

end

nick.autotp = function ()

    local tp = nick.Elements.tp.tp:get()
    local inair = nick.Elements.tp.inair:get()

    if not tp then return end

    local localplayer = entity.get_local_player()
    if not localplayer then return end

    local prop = localplayer["m_fFlags"]
    if inair then
        if prop == 256 or prop == 262 then
            if entity.get_threat(true) then rage.exploit:force_teleport() end
        end
    else
        if entity.get_threat(true) then rage.exploit:force_teleport() end
    end

end

nick.ragebot = function()
    for i, v in ipairs(weapons) do
        local baim = ui_ragebot[i].baim:get()
        local safe = ui_ragebot[i].safe:get()
        local only_head = ui_ragebot[i].only_head:get()

        ui.find("Aimbot", "Ragebot", "Selection", v, "Hitboxes"):override(baim and "Chest" or nil, baim and "Stomach" or nil)
        ui.find("Aimbot", "Ragebot", "Selection", v, "Multipoint"):override(baim and "Chest" or nil, baim and "Stomach" or nil)
        ui.find("Aimbot", "Ragebot", "Safety", v, "Body Aim"):override(baim and "Force" or nil)
        ui.find("Aimbot", "Ragebot", "Safety", v, "Safe Points"):override(safe and "Force" or nil)
        ui.find("Aimbot", "Ragebot", "Selection", v, "Hitboxes"):override(only_head and "Head" or nil)
        ui.find("Aimbot", "Ragebot", "Selection", v, "Multipoint"):override(only_head and "Head" or nil)
    end
end

nick.unload = function ()
    ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):disabled(false)

    cvar["sv_competitive_minspec"]:int(1)
    cvar["r_aspectratio"]:float(0)
    cvar.sv_cheats:int()
    cvar.sv_pure:int()
    cvar.cl_lagcompensation:int(1)

end

events.createmove:set(function(cmd)
    nick.fakeflick()
    nick.ax_function()
    nick.jumpscout_fix()
--    nick.defensive_aa()
    nick.os_peek()
--    nick.manual_aa()
    nick.autotp()
    nick.ragebot()
end)

events.render:set(function()
    nick.viewmodel()
    nick.debug_mode()
    nick.indicators()
end)

nick.once_callback = function ()
    nick.ragebot_item()
    nick.vote_reveals()
    nick.missed_sound()
    nick.always_choke_slient_shots()
    nick.trashtalk()
end

events.shutdown:set(function()
    nick.unload()
end)

nick.once_callback()
