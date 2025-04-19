local users = {
    nigger = 11111
}

-- references
local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local yaw, yawslider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local yawjitter, yawyjitterslider = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local bodyyaw, slider = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local freestandingbodyyaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
local lowerbodyyaw = ui.reference("AA", "Anti-aimbot angles", "Lower body yaw target")
local fakeyawlimit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
local edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
local sv_maxusrcmdprocessticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
local double_tap_fake_lag_limit = ui.reference("RAGE", "Other", "Double tap fake lag limit")
local double_tap_mode = ui.reference("RAGE", "Other", "Double tap mode")
local double_tap = { ui.reference("Rage", "Other", "Double tap") }
local quickpeekassist = { ui.reference("RAGE", "Other", "Quick peek assist") }
local fakelaglimit = ui.reference("AA", "Fake lag", "Limit")
local fakelagtype = ui.reference("AA", "Fake lag", "Amount") 
local slowmotion = { ui.reference("AA", "Other", "Slow motion") }
local legs_ref = ui.reference("AA", "OTHER", "leg movement")
local reticle = ui.reference("VISUALS", "Other ESP", "Penetration reticle")




-- hotkeys/checkboxes/multiselects etc

local title = ui.new_label("AA", "Anti-Aimbot Angles", "========={nebula}=========")
local enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "Master Switch")
local modeswitch = ui.new_combobox("AA", "Anti-Aimbot Angles", "Mode", {"-" ,"Anti-Aim", "Exploits", "Misc", "Visual"})



local aatable = {
    overrideaa = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Override Anti-Aim"),
    antiresolver = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Anti-Bruteforce"),
    legitaa = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Legit AA on E"),
    lowdeltakey =  ui.new_hotkey("AA", "Anti-Aimbot Angles", "Low Delta on Key"),
    manualback = ui.new_hotkey("AA", "Anti-Aimbot Angles", "Back"),
    manualright = ui.new_hotkey("AA", "Anti-Aimbot Angles", "Right"),
    manualleft = ui.new_hotkey("AA", "Anti-Aimbot Angles", "Left")
}

local exploitstable = {
    fasterdt = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Faster DT"),
}

local misctable = {
    idealtickkey = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Ideal Tick"),
    aa_legs = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Leg Breaker")
}

local visualtable = {
    camcollsion = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Disable Cam Collision"),
    enablereticle = ui.new_checkbox("AA", "Anti-Aimbot Angles", "Penetration Reticle If Scoped"),
    label = ui.new_label("Lua", "B", "Bar Color"),
    color = ui.new_color_picker("Lua", "B", 'Bar Color', 1, 0, 0, 255),
    label2 = ui.new_label("Lua", "B", "Second Bar Color"),
    color2 = ui.new_color_picker("Lua", "B", 'Second Color Bar', 1, 0, 0, 255),
    label3 = ui.new_label("Lua", "B", "Text Color"),
    color3 = ui.new_color_picker("Lua", "B", 'Text Color', 1, 0, 0, 255)

}

ui.set_visible(sv_maxusrcmdprocessticks, true)

local function setTableVisibility(table, state)
    for i=1, #table do
        ui.set_visible(table[i], state)
    end
end
  

local function handleGUI()
    if ui.get(modeswitch) == "Anti-Aim" then
        ui.set_visible(aatable.overrideaa, true)
        ui.set_visible(aatable.antiresolver, true)
        ui.set_visible(aatable.legitaa, true)
        ui.set_visible(aatable.lowdeltakey, true)
        ui.set_visible(aatable.manualback, true)
        ui.set_visible(aatable.manualright, true)
        ui.set_visible(aatable.manualleft, true)
    else
        ui.set_visible(aatable.overrideaa, false)
        ui.set_visible(aatable.antiresolver, false)
        ui.set_visible(aatable.legitaa, false)
        ui.set_visible(aatable.lowdeltakey, false)
        ui.set_visible(aatable.manualback, false)
        ui.set_visible(aatable.manualright, false)
        ui.set_visible(aatable.manualleft, false)
    end

    if ui.get(modeswitch) == "Exploits" then
        ui.set_visible(exploitstable.fasterdt, true)
    else
        ui.set_visible(exploitstable.fasterdt, false)
    end

    if ui.get(modeswitch) == "Misc" then
        ui.set_visible(misctable.idealtickkey, true)
        ui.set_visible(misctable.aa_legs, true)
    else
        ui.set_visible(misctable.idealtickkey, false)
        ui.set_visible(misctable.aa_legs, false)
    end

    if ui.get(modeswitch) == "Visual" then
        ui.set_visible(visualtable.enablereticle, true)
        ui.set_visible(visualtable.camcollsion, true)
    else
        ui.set_visible(visualtable.enablereticle, false)
        ui.set_visible(visualtable.camcollsion, false)

    end
end



local leftReady = false
local rightReady = false
local mode = "back"

-- baboon
local function includes(table, key)
    local state = false
    for i=1, #table do
        if table[i] == key then
            state = true
            break 
        end
    end
    return state
end

--function for tables uMAD?


-- MANUAL AA UMAD?
local function runCommand()
if ui.get(enabled) == false then
    return
end


if ui.get(aatable.manualback) then
    
        mode = "back"
    elseif ui.get(aatable.manualleft) and leftReady then
        if mode == "left" then
            mode = "back"
        else
            mode = "left"
        end
        leftReady = false
    elseif ui.get(aatable.manualright) and rightReady then
        if mode == "right" then
            mode = "back"
        else
            mode = "right"
        end
        rightReady = false
    end

    if ui.get(aatable.manualleft) == false then
        leftReady = true
     end

    if ui.get(aatable.manualright) == false then
        rightReady = true
    end

    if mode == "back" then
        ui.set(yawslider, 0)
    elseif mode == "left" then
        ui.set(yawslider, -90)
    elseif mode == "right" then
        ui.set(yawslider, 90)
    end
end



local function fasterdoubletap()
    if ui.get(exploitstable.fasterdt) then
        ui.set(sv_maxusrcmdprocessticks, 18)
        ui.set(double_tap_fake_lag_limit, 1)
        ui.set(double_tap_mode, "Offensive")
        cvar.cl_clock_correction:set_int(0)
    else
        ui.set(sv_maxusrcmdprocessticks, 16)
        ui.set(double_tap_mode, "Offensive")
        ui.set(double_tap_fake_lag_limit, 1)
        cvar.cl_clock_correction:set_int(1)
    end
end

local function idealtickfunc()
    if ui.get(misctable.idealtickkey) then
        if ui.get(double_tap[1]) and ui.get(double_tap[2]) then
            if ui.get(quickpeekassist[1]) and ui.get(quickpeekassist[2]) then
                ui.set(fakelaglimit, 1)
            else
                ui.set(fakelaglimit, 14)
            end
        end
    end
end

local function GetClosestPoint(A, B, P)
    local a_to_p = { P[1] - A[1], P[2] - A[2] }
    local a_to_b = { B[1] - A[1], B[2] - A[2] }

    local atb2 = a_to_b[1]^2 + a_to_b[2]^2

    local atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    local t = atp_dot_atb / atb2
    
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end

local should_swap = false
local it = 0
local angles = { 60, 20, -60 }
client.set_event_callback("bullet_impact", function(c)
    if ui.get(aatable.antiresolver) and entity.is_alive(entity.get_local_player()) then
        local ent = client.userid_to_entindex(c.userid)
        if not entity.is_dormant(ent) and entity.is_enemy(ent) then
            local ent_shoot = { entity.get_prop(ent, "m_vecOrigin") }
            ent_shoot[3] = ent_shoot[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
            local player_head = { entity.hitbox_position(entity.get_local_player(), 0) }
            local closest = GetClosestPoint(ent_shoot, { c.x, c.y, c.z }, player_head)
            local delta = { player_head[1]-closest[1], player_head[2]-closest[2] }
            local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)
        
            if math.abs(delta_2d) < 125 then
                it = it + 1
                should_swap = true
            end
        end
    end
end)

client.set_event_callback("run_command", function(c)
    if ui.get(aatable.antiresolver) and ui.get(enabled) and should_swap then
        local _combo = ui.get(aatable.antiresolver)
        if _combo then
            ui.set(slider, -ui.get(slider))
        end
        should_swap = false
    end
end)    

function round(num, numDecimalPlaces)
	local mult = 1^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function on_paint()
    local width, height = client.screen_size()
    local center_width = width/2
    local center_height = height/2
    local local_player = entity.get_local_player()
    if not entity.is_alive(local_player) then return end
    local fyawlimit = math.max(-60, math.min(60, round((entity.get_prop(local_player, "m_flPoseParameter", 11) or 0)*120-60+0.5, 1)))
    r, g, b, a = ui.get(visualtable.color)
    r2, g2, b2, a2 = ui.get(visualtable.color2)
    r3, g3, b3, a3 = ui.get(visualtable.color3)
    if ui.get(slider) > 0 then
    renderer.text(center_width, center_height+35, r3, g3, b3, a3, 'c', 0, "nebula")
    renderer.text(center_width, center_height+17, 255, 255, 255, 255, 'c', 0, "" .. fyawlimit .. "°")
    renderer.gradient(center_width, center_height+26, -fyawlimit, 2, r, g, b, a, r2, g2, b2, a2, true)
    renderer.gradient(center_width, center_height+26, fyawlimit, 2, r, g, b, a, r2, g2, b2, a2, true)
    else
    renderer.text(center_width, center_height+35, r3, g3, b3, a3, 'c', 0, "nebula")
    renderer.text(center_width, center_height+17, 255, 255, 255, 255, 'c', 0, "" .. -fyawlimit .. "°")
    renderer.gradient(center_width, center_height+26, fyawlimit, 2, r, g, b, a, r2, g2, b2, a2, true)
    renderer.gradient(center_width, center_height+26, -fyawlimit, 2, r, g, b, a, r2, g2, b2, a2, true)
    end
end

client.set_event_callback("setup_command",function(e)
    local weaponn = entity.get_player_weapon()

    if ui.get(aatable.legitaa) then
        if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
            if e.in_attack == 1 then
                e.in_attack = 0 
                e.in_use = 1
            end
        else
            if e.chokedcommands == 0 then
                e.in_use = 0
            end
        end
        ui.set(freestandingbodyyaw, true)
end
end)



    local function legfucker()
        if ui.get(misctable.aa_legs) and ui.get(enabled) then
          local legs_int = math.random(0, 4)
          if legs_int <= 1 then
            ui.set(legs_ref, "always slide")
          end
          if legs_int == 0 then
            ui.set(legs_ref, "never slide")
          end
          if legs_int >= 2 then
            ui.set(legs_ref, "never slide")
          end
        end
      end
    
    local function camcollisiondisable()
        if ui.get(enabled) and ui.get(visualtable.camcollsion) then
            client.exec("cam_collision 0")
        else
            client.exec("cam_collision 1")
        end
    end

      local function reticle1111()
        local isscoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped")
    
        if isscoped == 1 and ui.get(visualtable.enablereticle) and ui.get(enabled) then
            ui.set(reticle, true)
        else
            ui.set(reticle, false)
        end
    end

    local function aamain()
        if ui.get(aatable.overrideaa) then
                    ui.set(fakeyawlimit, 42)
                    ui.set(freestandingbodyyaw, true)
                    ui.set(yawjitter, "Offset")
                    ui.set(yawyjitterslider, -9)
                else
                    ui.set(fakeyawlimit, 42)
                    ui.set(freestandingbodyyaw, false)
                    ui.set(yawjitter, "Offset")
                    ui.set(yawyjitterslider, 0)
                end
            end

            local function lowdelta()
                if ui.get(enabled) then
                    if ui.get(aatable.lowdeltakey) then
                        ui.set(fakeyawlimit, 18)
                    else
                        ui.set(fakeyawlimit, 42)
                    end
                end
            end

            local function valid_user()
                return true;
            end
            client.set_event_callback("aim_miss", function(e)
            end)
            
            local first_time = true
            local valid = false
            
            if first_time then
                valid = valid_user()
                client.set_event_callback('paint', on_paint)
                client.set_event_callback("run_command", reticle1111)
                client.set_event_callback('paint', idealtickfunc)
                client.set_event_callback('paint', camcollisiondisable)
                client.set_event_callback("shutdown", fasterdoubletap)
                client.set_event_callback("paint_ui", handleGUI)
                client.set_event_callback('paint', legfucker)
                client.set_event_callback("run_command", runCommand) 
                client.set_event_callback('setup_command', lowdelta)
                client.set_event_callback('paint', aamain)
                client.color_log(150, 255, 22, "[nebula V3] Loaded. [1/2/2023]")           
             end
            
            if not valid then
                client.exec("quit")
            end