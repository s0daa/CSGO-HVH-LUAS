-- BOOM BOOM

statefunc = {
    onground_ticks = 0,

    in_air = function (indx)
        return bit.band(indx.m_fFlags,1) == 0
    end,
    on_ground = function (indx,limit)
        local onground = bit.band(indx.m_fFlags,1)
        if onground == 1 then
            statefunc.onground_ticks = statefunc.onground_ticks + 1
        else
            statefunc.onground_ticks = 0
        end

        return statefunc.onground_ticks > limit
    end,
    velocity = function(indx)
        local vel = indx.m_vecVelocity
        local velocity = math.sqrt(vel.x * vel.x + vel.y * vel.y)
        return velocity
    end,
    is_crouching = function (indx)
        return indx.m_flDuckAmount > 0.8
    end
}

local menurefs = {
    pitch = ui.find('Aimbot','Anti Aim',"Angles","Pitch"),
    yaw = ui.find('Aimbot','Anti Aim',"Angles","Yaw"),
    yawbase = ui.find('Aimbot','Anti Aim',"Angles","Yaw",'Base'),
    yawadd = ui.find('Aimbot','Anti Aim',"Angles","Yaw",'Offset'),
    yawmodifier = ui.find('Aimbot','Anti Aim',"Angles","Yaw Modifier"),
    yawmodifier2 = ui.find('Aimbot','Anti Aim',"Angles","Yaw Modifier"),
    yawmodifier_offset = ui.find('Aimbot','Anti Aim',"Angles","Yaw Modifier",'Offset'),
    fake = ui.find('Aimbot','Anti Aim',"Angles","Body Yaw"),
    fakeoption = ui.find('Aimbot','Anti Aim',"Angles","Body Yaw","Options"),
    fsbodyyaw = ui.find('Aimbot','Anti Aim',"Angles","Body Yaw","Freestanding"),
    left_limit = ui.find('Aimbot','Anti Aim',"Angles","Body Yaw","Left Limit"),
    right_limit = ui.find('Aimbot','Anti Aim',"Angles","Body Yaw","Right Limit"),
    slowwalk = ui.find('Aimbot','Anti Aim',"Misc","Slow Walk"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    fsstatic = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    fsbodyfreestand = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    antibackstab = ui.find('Aimbot','Anti Aim',"Angles","Yaw", "Avoid Backstab"),
    dtfl = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"),
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    mindmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    baim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    safepoint = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    fov = ui.find("Visuals", "World", "Main", "Field of View"),
    legmovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    ssgbaiming = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Body Aim"),
    ssgbaimingdisablers = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Body Aim", "Disablers"),
    ssgsafepoints =  ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Ensure Hitbox Safety"),
    awpbaiming = ui.find("Aimbot", "Ragebot", "Safety", "AWP", "Body Aim"),
    awpbaimingdisablers = ui.find("Aimbot", "Ragebot", "Safety", "AWP", "Body Aim", "Disablers"),
    awpsafepoints =  ui.find("Aimbot", "Ragebot", "Safety", "AWP", "Ensure Hitbox Safety"),
    autobaiming = ui.find("Aimbot", "Ragebot", "Safety", "AutoSnipers", "Body Aim"),
    autobaimingdisablers = ui.find("Aimbot", "Ragebot", "Safety", "AutoSnipers", "Body Aim", "Disablers"),
    autosafepoints =  ui.find("Aimbot", "Ragebot", "Safety", "AutoSnipers", "Ensure Hitbox Safety"),
    fakeping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
}

local clipboard = require("neverlose/clipboard")
local base64 = require("neverlose/base64")
local gradient = require("neverlose/gradient")
local ffi = require 'ffi'
local YawJitter = false

scriptmain = {

    menu = {
        player_states = {
            "Fakelag",
            "Stand",
            "Move",
            "Slow-Walk",
            "Air",
            "Air+C",
            "Duck"
        },
        pstates = {
            "F",
            "S",
            "M",
            "SW",
            "A",
            "AC",
            "D"
        },

create = function()

ui.sidebar("Antiaim builder", 'user-secret')

Antiaim_options = ui.create(ui.get_icon("sliders-h").." Antiaim",ui.get_icon("shield-alt").."          Antiaim Configuration         "..ui.get_icon("shield-alt"))
Antiaim_builder = ui.create(ui.get_icon("sliders-h").." Antiaim",ui.get_icon("hammer").."               Antiaim Builder              "..ui.get_icon("hammer"))
scriptmain.Antiaim = {}
scriptmain.condition = {}
scriptmain.condition2 = {}

scriptmain.Antiaim.condition_state = Antiaim_options:combo('Current Condition',scriptmain.menu.player_states)
scriptmain.Antiaim.preset_config = Antiaim_options:button('      Default    ', function() importDefault() end)
scriptmain.Antiaim.export_config = Antiaim_options:button('       Export      ', function() export() end)
scriptmain.Antiaim.load_config   = Antiaim_options:button('      Import     ', function() import() end)

for key = 1, 7 do
    scriptmain.condition[key] = {
        yaw_add_left = Antiaim_builder:slider('['..scriptmain.menu.pstates[key]..'] Left Yaw',-180,180,0),
        yaw_add_right = Antiaim_builder:slider('['..scriptmain.menu.pstates[key]..'] Right Yaw',-180,180,0),
        yaw_modifier = Antiaim_builder:combo('['..scriptmain.menu.pstates[key]..'] Yaw Modifier',{"Center","Offset","Random","Spin"}),
        yaw_modifier_value = Antiaim_builder:slider('['..scriptmain.menu.pstates[key]..'] Yaw Value',-180,180,0),
        enable_bodyyaw = Antiaim_builder:switch('['..scriptmain.menu.pstates[key]..'] Body Yaw', true),
   } 
end

for key = 1, 7 do
    bodyyawoptions = scriptmain.condition[key].enable_bodyyaw:create()
            
    scriptmain.condition2[key] = {
        jitter_options = bodyyawoptions:selectable("Options", {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti-Bruteforce"}),
        freestanding_by = bodyyawoptions:combo("Freestanding", {"Off", "Peek Fake", "Peek Real"}),
        fake_limit_left = bodyyawoptions:slider("Left Limit", 0, 58, 58),
       	fake_limit_right = bodyyawoptions:slider("Right Limit", 0, 58, 58),
       }
    end
end,

visible = function ()
        local selection = scriptmain.Antiaim.condition_state:get()
        for key, value in pairs(scriptmain.menu.player_states) do
        local AAshow = selection == scriptmain.menu.player_states[key]
        scriptmain.condition[key].yaw_add_left:visibility(AAshow)
        scriptmain.condition[key].yaw_add_right:visibility(AAshow)
        scriptmain.condition[key].yaw_modifier:visibility(AAshow)
        scriptmain.condition[key].yaw_modifier_value:visibility(AAshow)
        scriptmain.condition[key].enable_bodyyaw:visibility(AAshow)
    end
end,

set_callback = function ()
        for key, value in pairs(scriptmain.Antiaim) do
            value:set_callback(scriptmain.menu.visible)
        end
        for key, value in pairs(scriptmain.condition) do
        for index, value in pairs(scriptmain.condition[key]) do
            value:set_callback(scriptmain.menu.visible)
        end
    end         
end,
},

menufunc = function ()
    scriptmain.menu.create()
    scriptmain.menu.visible()
    scriptmain.menu.set_callback()
end
}

scriptmain.menufunc()

Antiaim = {

    values = {
        condition = 1,
        pitch = 'Down',
        yaw = 'Backward',
        yawbase = 'At Target',
        yawadd = 0,
        yawmodifier = "Disabled",
        yawmodifier_value = 0 ,
        fake = true,
        fakeoption = {
        avoidoverlap = false,
        jitter = false,
        randomjitter = false,
        anti_bruteforce = false
        },
        freestanding_by = "Off",
        on_shot = 'Default',
        lbymode = 'Opposite',
        left_limit = 0,
        right_limit = 0
    },

    SettingValues = function()

        local ConditionalState = Antiaim.states()
        local YawJitter = (math.floor(math.min(entity.get_local_player().m_flPoseParameter[11] * (menurefs.left_limit:get() * 2) - menurefs.left_limit:get()))) > 0

            Antiaim.values.pitch = 'Down'
            Antiaim.values.yawadd = YawJitter and -scriptmain.condition[ConditionalState].yaw_add_left:get() or -scriptmain.condition[ConditionalState].yaw_add_right:get()
            Antiaim.values.yawmodifier = scriptmain.condition[ConditionalState].yaw_modifier:get()
            Antiaim.values.yawmodifier_value = -scriptmain.condition[ConditionalState].yaw_modifier_value:get()
            Antiaim.values.fakeoption.avoidoverlap = scriptmain.condition2[ConditionalState].jitter_options:get('Avoid Overlap')
            Antiaim.values.fakeoption.jitter = scriptmain.condition2[ConditionalState].jitter_options:get('Jitter')
            Antiaim.values.fakeoption.randomjitter = scriptmain.condition2[ConditionalState].jitter_options:get('Randomize Jitter')
            Antiaim.values.fakeoption.anti_bruteforce = scriptmain.condition2[ConditionalState].jitter_options:get('Anti Bruteforce')
            Antiaim.values.lbymode = scriptmain.condition2[ConditionalState].lbymode:get()
            Antiaim.values.on_shot = scriptmain.condition2[ConditionalState].on_shot:get() 
            Antiaim.values.freestanding_by = scriptmain.condition2[ConditionalState].freestanding_by:get()
            Antiaim.values.left_limit = scriptmain.condition2[ConditionalState].fake_limit_left:get()
            Antiaim.values.right_limit =  scriptmain.condition2[ConditionalState].fake_limit_right:get()
        end,

        states = function ()
            local lp = entity.get_local_player()
            if statefunc.on_ground(lp, 8) and statefunc.is_crouching(lp) then
            Antiaim.values.condition = 7
            elseif statefunc.in_air(lp) and statefunc.is_crouching(lp) and not statefunc.on_ground(lp, 8) then
                Antiaim.values.condition = 6
            elseif statefunc.in_air(lp) and not statefunc.on_ground(lp, 8) then
                Antiaim.values.condition = 5
            elseif menurefs.slowwalk:get() then
                Antiaim.values.condition = 4
            elseif rage.exploit:get() == 1 and statefunc.on_ground(lp, 8) and statefunc.velocity(lp) > 3 and not menurefs.slowwalk:get() then
                Antiaim.values.condition = 3
            elseif rage.exploit:get() == 1 and statefunc.on_ground(lp, 8) and statefunc.velocity(lp) < 3 and not menurefs.slowwalk:get() then
                Antiaim.values.condition = 2
            elseif rage.exploit:get() == 0 and statefunc.on_ground(lp, 8) and statefunc.velocity(lp) > 3 and not menurefs.slowwalk:get() then
                Antiaim.values.condition = 1
            end
            return Antiaim.values.condition
        end,

    setup = function()
        Antiaim.SettingValues()

        menurefs.pitch:override(Antiaim.values.pitch)
        menurefs.yaw:override(Antiaim.values.yaw)
        menurefs.yawbase:override(Antiaim.values.yawbase)
        menurefs.yawadd:override(-Antiaim.values.yawadd)
        menurefs.yawmodifier:override(Antiaim.values.yawmodifier)
        menurefs.yawmodifier_offset:override(Antiaim.values.yawmodifier_value)
        menurefs.fake:override(Antiaim.values.fake)
        menurefs.fakeoption:override(
            Antiaim.values.fakeoption.avoidoverlap and "Avoid Overlap" or " ",
            Antiaim.values.fakeoption.jitter and "Jitter" or " ",
            Antiaim.values.fakeoption.randomjitter and "Randomize Jitter" or " ",
            Antiaim.values.fakeoption.antibrute and "Anti Bruteforce" or " "
        )
        menurefs.fsbodyyaw:override(Antiaim.values.fsbodyyaw)
        menurefs.left_limit:override(Antiaim.values.left_limit)
        menurefs.right_limit:override(Antiaim.values.right_limit)
    end

}

callback = {
    createmove = function()
        Antiaim.setup()
    end,

    setup = function()
        events.createmove:set(callback.createmove)
    end
}

callback.setup()

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

local arr_to_string = function(arr)
    arr = arr:get()
        local str = ""
        for i=1, #arr do
            str = str .. arr[i] .. (i == #arr and "" or ",")
        end
        
        if str == "" then
            str = "-"
        end
        
        return str
    end

export = function()

local str = ""

    for key = 1, 7 do
        str = str..tostring(scriptmain.condition[key].yaw_add_left:get()).."|"
        ..tostring(scriptmain.condition[key].yaw_add_right:get()).."|"
        ..tostring(scriptmain.condition[key].yaw_modifier:get()).."|"
        ..tostring(scriptmain.condition[key].yaw_modifier_value:get()).."|"
        ..arr_to_string(scriptmain.condition2[key].jitter_options).."|"
        ..tostring(scriptmain.condition2[key].freestanding_by:get()).."|"
        ..tostring(scriptmain.condition2[key].on_shot:get()).."|"
        ..tostring(scriptmain.condition2[key].lbymode:get()).."|"
        ..tostring(scriptmain.condition2[key].fake_limit_left:get()).."|"
        ..tostring(scriptmain.condition2[key].fake_limit_right:get()).."|"
    end
    clipboard.set(base64.encode(str))
    common.add_notify("Antiaim", "Successfully exported config")
end

import = function(text)
        local protected_ = function ()
        
        local clipboard = clipboard.get()
        
        local tbl = str_to_sub(base64.decode(clipboard), "|")

        for key = 1, 7 do
            scriptmain.condition[key].yaw_add_left:set(tonumber(tbl[1 + (10 * (key-1))]))
            scriptmain.condition[key].yaw_add_right:set(tonumber(tbl[2 + (10 * (key-1))]))
            scriptmain.condition[key].yaw_modifier:set(to_boolean(tbl[3 + (10 * (key-1))]))
            scriptmain.condition[key].yaw_modifier_value:set(tonumber(tbl[4 + (10 * (key-1))]))
            scriptmain.condition2[key].jitter_options:set(str_to_sub(tbl[5 + (10 * (key-1))],','))
            scriptmain.condition2[key].freestanding_by:set(to_boolean(tbl[6 + (10 * (key-1))]))
            scriptmain.condition2[key].on_shot:set(to_boolean(tbl[7 + (10 * (key-1))]))
            scriptmain.condition2[key].lbymode:set(to_boolean(tbl[8 + (10 * (key-1))]))
            scriptmain.condition2[key].fake_limit_left:set(tonumber(tbl[9 + (10 * (key-1))]))
            scriptmain.condition2[key].fake_limit_right:set(tonumber(tbl[10 + (10 * (key-1))]))
        end

    common.add_notify("Antiaim", "Successfully imported config")
end

    local status , message = pcall(protected_)
                
        if not status then
            print("Error: "..message)
            return 
        end
    end

importDefault = function(text)
    local protected_ = function ()
        local clipboards = "LTJ8N3xDZW50ZXJ8NTZ8Sml0dGVyfFBlZWsgRmFrZXxPcHBvc2l0ZXxPcHBvc2l0ZXw1OHw1OHw1fDE1fENlbnRlcnw1NXxKaXR0ZXIsQW50aS1CcnV0ZWZvcmNlfE9mZnxPcHBvc2l0ZXxPcHBvc2l0ZXw1OHw1OHwxMnwxMnxDZW50ZXJ8NTV8Sml0dGVyLEFudGktQnJ1dGVmb3JjZXxPZmZ8T3Bwb3NpdGV8T3Bwb3NpdGV8NTh8NTh8LTZ8MTR8Q2VudGVyfDU4fEppdHRlcixBbnRpLUJydXRlZm9yY2V8T2ZmfE9wcG9zaXRlfE9wcG9zaXRlfDU4fDU4fC0xMHwxMnxDZW50ZXJ8NDJ8Sml0dGVyfE9mZnxPcHBvc2l0ZXxPcHBvc2l0ZXw1OHw1OHwtMzJ8Mjh8U3BpbnwtMTJ8Sml0dGVyfE9mZnxEZWZhdWx0fERpc2FibGVkfDU4fDU4fC0zMnwyN3xSYW5kb218NXxKaXR0ZXIsQW50aS1CcnV0ZWZvcmNlfE9mZnxPcHBvc2l0ZXxPcHBvc2l0ZXw1OHw1OHw="

        local tbl = str_to_sub(base64.decode(clipboards), "|")

        for key = 1, 7 do
            scriptmain.condition[key].yaw_add_left:set(tonumber(tbl[1 + (10 * (key-1))]))
            scriptmain.condition[key].yaw_add_right:set(tonumber(tbl[2 + (10 * (key-1))]))
            scriptmain.condition[key].yaw_modifier:set(to_boolean(tbl[3 + (10 * (key-1))]))
            scriptmain.condition[key].yaw_modifier_value:set(tonumber(tbl[4 + (10 * (key-1))]))
            scriptmain.condition2[key].jitter_options:set(str_to_sub(tbl[5 + (10 * (key-1))],','))
            scriptmain.condition2[key].freestanding_by:set(to_boolean(tbl[6 + (10 * (key-1))]))
            scriptmain.condition2[key].on_shot:set(to_boolean(tbl[7 + (10 * (key-1))]))
            scriptmain.condition2[key].lbymode:set(to_boolean(tbl[8 + (10 * (key-1))]))
            scriptmain.condition2[key].fake_limit_left:set(tonumber(tbl[9 + (10 * (key-1))]))
            scriptmain.condition2[key].fake_limit_right:set(tonumber(tbl[10 + (10 * (key-1))]))
        end

        common.add_notify("Antiaim", "Successfully imported default config")
    end

    local status , message = pcall(protected_)
        
    if not status then
        print("Error: "..message)
        return 
    end
end