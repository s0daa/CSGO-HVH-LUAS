--version 1.1.6 // last updated 07/19/20

--comes with manual aa
--first try // deadline 2 weeks (i'll just update it from now no recode and maybe bugfixes)
--not customizable just hardcoded

--getting locals for ui.set
local bodyyaw, yaw = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local bodyyaw, bodyyaw2 = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local jyaw, jyawslide = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local freestanding = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")


--the stuff we need to begin with
local enabled = ui.new_checkbox("LUA", "B", "Enable AA")
local color  = ui.new_color_picker("LUA", "B", "Indicator color", 235, 146, 52, 255)

--fixed the multiselect stupid stuff and now its combobox
local option = ui.new_combobox("LUA", "B", "AA Options", "Manual AA", "Ideal Yaw")
local back = ui.new_hotkey("LUA", "B", "[M] BACK")
local left = ui.new_hotkey("LUA", "B", "[M] LEFT")
local right = ui.new_hotkey("LUA", "B", "[M] RIGHT")
local ideal = ui.new_checkbox("LUA", "B", "Ideal Yaw")
local idealoption = ui.new_combobox("LUA", "B", "Ideal Yaw Mode", "Normal", "Opposite", "Jitter")
local idealinvert = ui.new_hotkey("LUA", "B", "Ideal Yaw Inverter")
local idealepeek = ui.new_hotkey("LUA", "B", "Ideal Yaw E Peek")



--lets see what we have active // tropics did this 
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

--setting the function for tables
local function setTableVisibility(table, state)
    for i=1, #table do
        ui.set_visible(table[i], state)
    end
end

local function handleGUI()
    local enabled = ui.get(enabled)
    setTableVisibility({color, option}, enabled)
    setTableVisibility({back, left, right}, enabled and ui.get(option) == "Manual AA")
    ui.set_visible(ideal, enabled and ui.get(option) == "Ideal Yaw")
    local setactive = ui.get(ideal)
    setTableVisibility({idealinvert, idealoption, idealepeek}, setactive and ui.get(option), "Ideal Yaw")
end

--locals for manual aa and indicators
local leftReady = false
local rightReady = false
local mode = "back"
local screen = {client.screen_size()}
local center = {screen[1]/2, screen[2]/2}

local function runCommand()
    if ui.get(enabled) == false then
        return
    end

--ideal yaw bullshit dont touch or copy or i kell u LMAOOO
--now it has freestanding LOL
    if ui.get(option) == "Ideal Yaw" then
        if ui.get(idealoption) == "Normal" then
            if ui.get(idealinvert) then
                ui.set(yaw, -3)
                ui.set(bodyyaw2, -138)
                ui.set(bodyyaw, "Static")
                ui.set(yawbase, "At targets")
                ui.set(pitch, "Minimal")
                ui.set(freestanding, true)
            else
                ui.set(yaw, 2)
                ui.set(bodyyaw2, 141)
                ui.set(bodyyaw, "Static")
                ui.set(yawbase, "At targets")
                ui.set(pitch, "Minimal")
                ui.set(freestanding, true)
            end
        end
        if ui.get(idealoption) == "Opposite" then
            if ui.get(idealinvert) then
                ui.set(yaw, -2)
                ui.set(bodyyaw2, -118)
                ui.set(bodyyaw, "Static")
                ui.set(yawbase, "At targets")
                ui.set(pitch, "Minimal")
                ui.set(freestanding, true)
            else
                ui.set(yaw, 4)
                ui.set(bodyyaw2, 101)
                ui.set(bodyyaw, "Static")
                ui.set(yawbase, "At targets")
                ui.set(pitch, "Minimal")
                ui.set(freestanding, true)
            end
        end
        if ui.get(idealoption) == "Jitter" then
            ui.set(yaw, 0)
            ui.set(bodyyaw2, 157)
            ui.set(freestanding, false)
            ui.set(bodyyaw, "Jitter")
            ui.set(pitch, "Minimal")
        end
        if ui.get(idealepeek) then
            ui.set(yaw, 180)
            ui.set(bodyyaw2, 133)
            ui.set(bodyyaw, "Static")
            ui.set(fyawlimit, 48)
            ui.set(lowerbody, "Opposite")
            ui.set(pitch, "Off")
        else return
        end
    end
--manual aa // i didnt do this, pewds3 and kez2474 did
    if ui.get(option) == "Manual AA" then
        if ui.get(back) then
            mode = "back"
        elseif ui.get(left) and leftReady then
            if mode == "left" then
                mode = "back"
            else
                mode = "left"
            end
            leftReady = false
        elseif ui.get(right) and rightReady then
            if mode == "right" then
                mode = "back"
            else
                mode = "right"
            end
            rightReady = false
        end
    
        if ui.get(left) == false then
            leftReady = true
         end
    
        if ui.get(right) == false then
            rightReady = true
        end
    
        if mode == "back" then
            ui.set(yaw, 0)
        elseif mode == "left" then
            ui.set(yaw, -90)
        elseif mode == "right" then
            ui.set(yaw, 90)
        end
    end
end

local function paint()
    if ui.get(enabled) == false then
        return
    end
    
    local lp = entity.get_local_player()

    if lp == nil or entity.is_alive(lp) == false then
        return
    end

    local color_g = {ui.get(color)}

    if ui.get(option) == "Manual AA" then
        renderer.text(center[1], center[2] + 43, 45, 45, 45, 255, "cb+", 0, "v" )
        renderer.text(center[1] - 43, center[2] - 3, 45, 45, 45, 255, "cb+", 0, "<" )
        renderer.text(center[1] + 43, center[2] - 3, 45, 45, 45, 255, "cb+", 0, ">" )

        if mode == "back" then
            renderer.text(center[1], center[2] + 43, color_g[1], color_g[2], color_g[3], color_g[4], "cb+", 0, "v" )
        elseif mode == "left" then
            renderer.text(center[1] - 43, center[2] - 3, color_g[1], color_g[2], color_g[3], color_g[4], "cb+", 0, "<" )
        elseif mode == "right" then
            renderer.text(center[1] + 43, center[2] - 3, color_g[1], color_g[2], color_g[3], color_g[4], "cb+", 0, ">" )
        end
    end

    if ui.get(ideal) then
        if ui.get(idealinvert) then
            renderer.text(center[1] + 43, center[2] - 3, color_g[1], color_g[2], color_g[3], color_g[4], "cb+", 0, ">" )
            renderer.text(center[1] - 43, center[2] - 3, 45, 45, 45, 255, "cb+", 0, "<" )
        else
            renderer.text(center[1] - 43, center[2] - 3, color_g[1], color_g[2], color_g[3], color_g[4], "cb+", 0, "<" )
            renderer.text(center[1] + 43, center[2] - 3, 45, 45, 45, 255, "cb+", 0, ">" )
        end
        
        renderer.text(center[1], center[2] + 23, 235, 146, 52, 255, "b", 0, "IDEAL YAW" )
        if ui.get(idealoption) == "Normal" then
            renderer.text(center[1], center[2] + 33, 97, 150, 255, 255, "b", 0, "NORMAL" )
        elseif ui.get(idealoption) == "Opposite" then
            renderer.text(center[1], center[2] + 33, 255, 59, 59, 255, "b", 0, "OPPOSITE" )
        elseif ui.get(idealoption) == "Jitter" then
            renderer.text(center[1], center[2] + 33, 255, 251, 23, 255, "b", 0, "JITTER" )
        end
        if ui.get(idealepeek) then
            renderer.text(center[1], center[2] + 43, 0, 219, 22, 255, "b", 0, "PEEKING LEGIT AA" )
        else
            renderer.text(center[1], center[2] + 43, 168, 0, 0, 0, "b", 0, "PEEKING LEGIT AA" )
        end
    end
end


client.set_event_callback("paint", paint)
client.set_event_callback("run_command", runCommand) 
client.set_event_callback("paint_ui", handleGUI)