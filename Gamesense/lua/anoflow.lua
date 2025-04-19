--cracked by legias (maybe)
local nick_name = "Legias"

if not LPH_OBFUSCATED then
    LPH_JIT = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
end

local lua_name, lua_color, script_build, altrue, m_out_pos, m_time, m_alpha, panel_height, panel_offset, panel_color, text_color = "anoflow", {r = 255, g = 255, b = 255}, "[nebula]", true, { ui.menu_position() }, globals.realtime(), 0, 25, 5, { 25, 25, 25, 200 }, { 255, 255, 255, 255 }
local
event_callback,
 unset_event_callback,
  label,
   switch,
    combo,
     slider,
      multi,
       tickcount,
        ref_ui =
        client.set_event_callback, client.unset_event_callback, ui.new_label, ui.new_checkbox, ui.new_combobox, ui.new_slider, ui.new_multiselect, globals.tickcount, ui.reference
        
function try_require(module, msg)
    local success, result = pcall(require, module)
    if success then return result else return error(msg) end
end
a = function (...) return ... end

local tooltips = {
    delay = {[1] = "GS"},
    delay_2 = {[2] = "Off", [3] = "Random"},
    bt = {[1] = "Small", [2] = "Medium", [3] = "Maximum", [4] = "Extreme"},
    def = {[14] = "Always on", [1] = "Flick", },
    pitch = {[-89] = "Up", [0] = "Zero", [89] = "Down"},
    body = {[-2] = "Full Left", [-1] = "Left", [0] = "None", [1] = "Right", [2] = "Full Light"},
    backtrack = {[2] = "Default", [7] = "Maximum"},
    predict = {[1] = "Head", [2] = "Chest", [3] = "Legs"},
    lethal = {[92] = "Lethal"},
    viewmodel_fov = {[68] = "Fov"},
    viewmodel_x = {[0] = "X"},
    viewmodel_y = {[0] = "Y"},
    viewmodel_z = {[0] = "Z"}
}
local scrsize_x, scrsize_y = client.screen_size()
local center_x, center_y = scrsize_x / 2, scrsize_y / 2
local json = require("json")
gram_create = function(value, count)
    local gram = {}
    for i = 1, count do
        gram[i] = value
    end
    return gram
end
gram_update = function(tab, value, forced)
    if forced or tab[#tab] ~= value then
        table.insert(tab, value)
        table.remove(tab, 1)
    end
end
get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end
math.lerp = function (a, b, w) return a + (b - a) * w end
bit, base64, antiaim_funcs, ffi, vector, http, clipboard, c_ent, csgo_weapons, steamworks, surface = try_require("bit"), try_require("gamesense/base64"), try_require("gamesense/antiaim_funcs"), try_require("ffi"), try_require("vector", "Missing vector"), try_require("gamesense/http"), try_require("gamesense/clipboard", "Download Clipboard library: https://gamesense.pub/forums/viewtopic.php?id=28678"), try_require("gamesense/entity", "Download Entity Object library: https://gamesense.pub/forums/viewtopic.php?id=27529"), try_require("gamesense/csgo_weapons", "Download CS:GO weapon data library: https://gamesense.pub/forums/viewtopic.php?id=18807"), try_require("gamesense/steamworks"), try_require("gamesense/surface")
function ui.multiReference(tab, groupbox, name)
    local ref1, ref2, ref3 = ref_ui(tab, groupbox, name)
    return { ref1, ref2, ref3 }
end
local slider_data = {ref = 0, last_item = false, hovered_another = false}
-- function get_glow_color()
--     glow_time = glow_time + globals.frametime() * 2
--     local r = math.floor(128 + 127 * math.sin(glow_time))
--     local g = math.floor(128 + 127 * math.sin(glow_time + 2))
--     local b = math.floor(128 + 127 * math.sin(glow_time + 4))
--     return r, g, b
-- end
local rounding, o, queue = 6, 20, {}
local rad, n = rounding + 2, 45
local RoundedRect = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)renderer.rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25) end
local OutlineGlow = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+2,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+w-3,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+radius+rad,y+2,w-rad*2-radius*2,1,r,g,b,a)renderer.rectangle(x+radius+rad,y+h-3,w-rad*2-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius+rad,y+radius+rad,r,g,b,a,radius+rounding,180,0.25,1)renderer.circle_outline(x+w-radius-rad,y+radius+rad,r,g,b,a,radius+rounding,270,0.25,1)renderer.circle_outline(x+radius+rad,y+h-radius-rad,r,g,b,a,radius+rounding,90,0.25,1)renderer.circle_outline(x+w-radius-rad,y+h-radius-rad,r,g,b,a,radius+rounding,0,0.25,1) end
local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;renderer.rectangle(x+radius,y,w-radius*2,1,r,g,b,n)renderer.circle_outline(x+radius,y+radius,r,g,b,n,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,n,radius,270,0.25,1)renderer.rectangle(x,y+radius,1,h-radius*2,r,g,b,n)renderer.rectangle(x+w-1,y+radius,1,h-radius*2,r,g,b,n)renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n) for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end
local container_glow = function(x, y, w, h, r, g, b, a, alpha,r1, g1, b1, fn) if alpha*255>0 then renderer.blur(x,y,w,h)end;RoundedRect(x,y,w,h,rounding,17,17,17,a)FadedRoundedGlow(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end

-- local frametime, g_speed = globals.absoluteframetime(), 1
-- local anim = {
--     lerp = a(function (a, b, s, t)
--     local c = a + (b - a) * frametime * (s or 8) * g_speed
--     return math.abs(b - c) < (t or .005) and b or c
--     end)
-- }

    local menu_c = ui.reference("MISC", "Settings", "Menu color")
    menu_r, menu_g, menu_b, menu_a = ui.get(menu_c)
    
is_peeking = function ()
    local me = entity.get_local_player()
    if not me then return end
    local enemies = entity.get_players(true)
    if not enemies then
        return false
    end

    local predict_amt = 0.25
    local eye_position = vector(client.eye_position())
    local velocity_prop_local = vector(entity.get_prop(me, 'm_vecVelocity'))
    local predicted_eye_position = vector(eye_position.x + velocity_prop_local.x * predict_amt, eye_position.y + velocity_prop_local.y * predict_amt, eye_position.z + velocity_prop_local.z * predict_amt)
    for i = 1, #enemies do
        local player = enemies[i]
        local velocity_prop = vector(entity.get_prop(player, 'm_vecVelocity'))
        local origin = vector(entity.get_prop(player, 'm_vecOrigin'))
        local predicted_origin = vector(origin.x + velocity_prop.x * predict_amt, origin.y + velocity_prop.y * predict_amt, origin.z + velocity_prop.z * predict_amt)
        entity.get_prop(player, 'm_vecOrigin', predicted_origin)
        local head_origin = vector(entity.hitbox_position(player, 0))
        local predicted_head_origin = vector(head_origin.x + velocity_prop.x * predict_amt, head_origin.y + velocity_prop.y * predict_amt, head_origin.z + velocity_prop.z * predict_amt)
        local trace_entity, damage = client.trace_bullet(me, predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y, predicted_head_origin.z)
        entity.get_prop( player, 'm_vecOrigin', origin )
        if damage > 0 then
            return true
        end
    end
    return false
end

local refs = {
    slowmotion = ref_ui("AA", "Other", "Slow motion"),
    OSAAA = ref_ui("AA", "Other", "On shot anti-aim"),
    Legmoves = ref_ui("AA", "Other", "Leg movement"),
    legit = ref_ui("LEGIT", "Aimbot", "Enabled"),
    minimum_damage_override = { ref_ui("Rage", "Aimbot", "Minimum damage override") },
    fakeDuck = ref_ui("RAGE", "Other", "Duck peek assist"),
    minimum_damage = ref_ui("Rage", "Aimbot", "Minimum damage"),
    hitChance = ref_ui("RAGE", "Aimbot", "Minimum hit chance"),
    safePoint = ref_ui("RAGE", "Aimbot", "Force safe point"),
    forceBaim = ref_ui("RAGE", "Aimbot", "Force body aim"),
    dtLimit = ref_ui("RAGE", "Aimbot", "Double tap fake lag limit"),
    quickPeek = {ref_ui("RAGE", "Other", "Quick peek assist")},
    delay_shot = {ref_ui("RAGE", "Other", "Delay shot")},
    dt = {ref_ui("RAGE", "Aimbot", "Double tap")},
    dormantEsp = ref_ui("VISUALS", "Player ESP", "Dormant"),
    air_strafe = ref_ui("Misc", "Movement", "Air strafe"),
    multi_points = ref_ui("RAGE", "Aimbot", "Multi-point scale"),
    enabled = ref_ui("AA", "Anti-aimbot angles", "Enabled"),
    pitch = {ref_ui("AA", "Anti-aimbot angles", "pitch")},
    roll = ref_ui("AA", "Anti-aimbot angles", "roll"),
    yawBase = ref_ui("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ref_ui("AA", "Anti-aimbot angles", "Yaw")},
    flLimit = ref_ui("AA", "Fake lag", "Limit"),
    flamount = ref_ui("AA", "Fake lag", "Amount"),
    flenabled = ref_ui("AA", "Fake lag", "Enabled"),
    flVariance = ref_ui("AA", "Fake lag", "Variance"),
    AAfake = ref_ui("AA", "Other", "Fake peek"),
    fsBodyYaw = ref_ui("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeYaw = ref_ui("AA", "Anti-aimbot angles", "Edge yaw"),
    yawJitter = {ref_ui("AA", "Anti-aimbot angles", "Yaw jitter")},
    bodyYaw = {ref_ui("AA", "Anti-aimbot angles", "Body yaw")},
    freeStand = {ref_ui("AA", "Anti-aimbot angles", "Freestanding")},
    os = {ref_ui("AA", "Other", "On shot anti-aim")},
    slow = {ref_ui("AA", "Other", "Slow motion")},
    fakeLag = {ref_ui("AA", "Fake lag", "Limit")},
    legMovement = ref_ui("AA", "Other", "Leg movement"),
    indicators = {ref_ui("VISUALS", "Other ESP", "Feature indicators")},
    ping = {ref_ui("MISC", "Miscellaneous", "Ping spike")},
}

local ref = {
    aimbot = ref_ui('RAGE', 'Aimbot', 'Enabled'),
    doubletap = {
        main = { ref_ui('RAGE', 'Aimbot', 'Double tap') },
        fakelag_limit = ref_ui('RAGE', 'Aimbot', 'Double tap fake lag limit')
    }
}

local binds = {
    legMovement = ui.multiReference("AA", "Other", "Leg movement"),
    slowmotion = ui.multiReference("AA", "Other", "Slow motion"),
    OSAAA = ui.multiReference("AA", "Other", "On shot anti-aim"),
    AAfake = ui.multiReference("AA", "Other", "Fake peek"),
    
}

-- if nick_name == "marolower" or nick_name == "lbyking666" or nick_name == "admin" then
--     script_build = "[вазязя]"
-- elseif nick_name == "wmentol" then
--     script_build = " [beta]"
-- else
--     script_build = " [nebula]"
-- end

local vars = {
    localPlayer = 0,
    hitgroup_names = { 'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', '?', 'Gear' },
    aaStates = {"Global", "Standing", "Running", "Moving", "Crouching", "Air", "Air+C", "Sneaking", "On FL", "On FS"},
    pStates = {"G", "S", "M", "SW", "C", "A", "AC", "CM", "FL", "FS"},
	sToInt = {["Global"] = 1, ["Standing"] = 2, ["Running"] = 3, ["Moving"] = 4, ["Crouching"] = 5, ["Air"] = 6, ["Air+C"] = 7, ["Sneaking"] = 8 , ["On FL"] = 9, ["On FS"] = 10},
    intToS = {[1] = "Global", [2] = "Standing", [3] = "Running", [4] = "Moving", [5] = "Crouching", [6] = "Air", [7] = "Air+C", [8] = "Sneaking", [9] = "On FL", [10] = "On FS"},
    currentTab = 1,
    activeState = 1,
    pState = 1,
    yaw = 0,
    sidemove = 0,
    m1_time = 0,
    choked = 0,
    dt_state = 0,
    doubletap_time = 0,
    breaker = {
        defensive = 0,
        defensive_check = 0,
        cmd = 0,
        last_origin = nil,
        origin = nil,
        tp_dist = 0,
        tp_data = gram_create(0,3)
    },
    mapname = globals.mapname()
}

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

local L_hc = ui.get(refs.hitChance)

local func = {
    easeInOut = function(t)
        return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
    end,
    rec = function(x, y, w, h, radius, color)
        radius = math.min(x/2, y/2, radius)
        local r, g, b, a = unpack(color)
        renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
        renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
    end,
    rec_outline = function(x, y, w, h, radius, thickness, color)
        radius = math.min(w/2, h/2, radius)
        local r, g, b, a = unpack(color)
        if radius == 1 then
            renderer.rectangle(x, y, w, thickness, r, g, b, a)
            renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
        else
            renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
            renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
            renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
            renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
            renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
            renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
            renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
        end
    end,
    clamp = function(x, min, max)
        return x < min and min or x > max and max or x
    end,
    table_contains = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
    end,
    setAATab = function(ref)
        ui.set_visible(refs.enabled, ref)
        ui.set_visible(refs.pitch[1], ref)
        ui.set_visible(refs.pitch[2], ref)
        ui.set_visible(refs.roll, ref)
        ui.set_visible(refs.slowmotion, ref)
        ui.set_visible(refs.Legmoves, ref)
        ui.set_visible(refs.yawBase, ref)
        ui.set_visible(refs.yaw[1], ref)
        ui.set_visible(refs.yaw[2], ref)
        ui.set_visible(refs.yawJitter[1], ref)
        ui.set_visible(refs.yawJitter[2], ref)
        ui.set_visible(refs.bodyYaw[1], ref)
        ui.set_visible(refs.bodyYaw[2], ref)
        ui.set_visible(refs.freeStand[1], ref)
        ui.set_visible(refs.freeStand[2], ref)
        ui.set_visible(refs.fsBodyYaw, ref)
        ui.set_visible(refs.edgeYaw, ref)
        ui.set_visible(refs.flLimit, ref)
        ui.set_visible(refs.flamount, ref)
        ui.set_visible(refs.flVariance, ref)
        ui.set_visible(refs.flenabled, ref)
        ui.set_visible(refs.AAfake, ref)
        ui.set_visible(refs.OSAAA, ref)
    end,
    resetAATab = function()
        ui.set(refs.OSAAa, false)
        ui.set(refs.enabled, false)
        ui.set(refs.pitch[1], "Off")
        ui.set(refs.pitch[2], 0)
        ui.set(refs.roll, 0)
        ui.set(refs.slowmotion, false)
        ui.set(refs.yawBase, "local view")
        ui.set(refs.yaw[1], "Off")
        ui.set(refs.yaw[2], 0)
        ui.set(refs.yawJitter[1], "Off")
        ui.set(refs.yawJitter[2], 0)
        ui.set(refs.bodyYaw[1], "Off")
        ui.set(refs.bodyYaw[2], 0)
        ui.set(refs.freeStand[1], false)
        ui.set(refs.freeStand[2], "On hotkey")
        ui.set(refs.fsBodyYaw, false)
        ui.set(refs.edgeYaw, false)
        ui.set(refs.flLimit, false)
        ui.set(refs.flamount, false)
        ui.set(refs.flenabled, false)
        ui.set(refs.flVariance, false)
        ui.set(refs.AAfake, false)
    end,
    lerp = function(start, vend, time)
        return start + (vend - start) * time
    end,
    vec_angles = function(angle_x, angle_y)
        local sy = math.sin(math.rad(angle_y))
        local cy = math.cos(math.rad(angle_y))
        local sp = math.sin(math.rad(angle_x))
        local cp = math.cos(math.rad(angle_x))
        return cp * cy, cp * sy, -sp
    end,
    hex = function(arg)
        local result = "\a"
        for key, value in next, arg do
            local output = ""
            while value > 0 do
                local index = math.fmod(value, 16) + 1
                value = math.floor(value / 16)
                output = string.sub("0123456789ABCDEF", index, index) .. output 
            end
            if #output == 0 then 
                output = "00" 
            elseif #output == 1 then 
                output = "0" .. output 
            end 
            result = result .. output
        end 
        return result .. "FF"
    end,
    RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
        return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
    end,
    includes = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
    end,
    -- time_to_ticks = function(t)
    --     return math.floor(0.5 + (t / globals.tickinterval()))
    -- end,
}

text_fade_animation = function(speed, r, g, b, a, text)
    local final_text = ''
    local curtime = globals.curtime()
    local max_length = 100

    for i = 0, math.min(#text, max_length) do
        local alpha = a * math.abs(1 * math.cos(2 * speed * curtime / 4 + i * 5 / 30))
        local color = func.RGBAtoHEX(r, g, b, alpha)
        final_text = final_text .. '\a' .. color .. text:sub(i, i)
    end

    if #text > max_length then
        final_text = final_text .. text:sub(max_length + 1)
    end

    return final_text
end

split = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
        if #t > 100 then
            break
        end
    end
    return t
end
color_text = function(string, r, g, b, a)
    local accent = "\a" .. func.RGBAtoHEX(r, g, b, a)
    local white = "\a" .. func.RGBAtoHEX(255, 255, 255, a)

    local str = ""
    for i, s in ipairs(split(string, "$")) do
        str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
    end
    return str
end

local tab, container = "AA", "Anti-aimbot angles"

local aa_tab, fl_tab, other_tab = "Anti-aimbot angles", "Fake lag", "Other"

function switch(tab, name)
    return ui.new_checkbox("AA", tab, name)
end
function label(tab, name)
    return ui.new_label("AA", tab, name)
end
function list(tab, name, vl)
    return ui.new_multiselect("AA", tab, name, vl)
end
function combo(tab, name, ...)
    local vl_values = {...}
    return ui.new_combobox("AA", tab, name, table.unpack(vl_values))
end 
--[[function slider(tab, name, ...)
    local args = {...}
    return ui.new_slider("AA", tab, name, table.unpack(args))
end]]
local lableb321 = label(aa_tab, "\rAnoflow ~" .. func.hex({menu_r, menu_g, menu_b}) .. script_build)
local calar = ui.new_color_picker("AA", container, "\rAnoflow ~" .. func.hex({menu_r, menu_g, menu_b}) .. script_build, lua_color.r, lua_color.g, lua_color.b, 255)


local tabPicker = combo(aa_tab, "\nTab", " Main", " Anti-aim", " Settings")
local aaTabs = combo(fl_tab, func.hex({menu_r, menu_g, menu_b}) .. "Anti-aim" .. func.hex({200, 200, 200}) .. " ~ selector", {" Settings", " Builder"})
local mTabs = combo(fl_tab, func.hex({menu_r, menu_g, menu_b}) .. "Settings" .. func.hex({200, 200, 200}) .. " ~ selector", {" Visuals", " Miscellaneous"})
local iTabs = combo(fl_tab, func.hex({menu_r, menu_g, menu_b}) .. "Main" .. func.hex({200, 200, 200}) .. " ~ selector", {" Information", " Other"})


local menu = {
    aaTab = {
        pusto = label(aa_tab, " "),
        spin_exploit = switch(aa_tab, "".. func.hex({menu_r, menu_g, menu_b}) .."Spin exploit " .. "\a808080FF[if no ememy alive]"),
        anti_knife = switch(aa_tab, "Avoid Backstab"),
        avoid_dist = slider(tab, container, "Distance", 50, 300, 150, true, "unints", 1),
        label332 = label(fl_tab, "    "),
        label333 = label(fl_tab, "\aFFFFFFFF•  \aFFFFFFFFBinds"),
        freestandlabel = label(fl_tab, "Freestand"),
        freestandHotkey = ui.new_hotkey("AA", "Fake lag", "Freestand", true),
        legitAAHotkey = switch(aa_tab, "Adjust body yaw on legit"),
        m_left = ui.new_hotkey("AA", "Fake lag", "Manual left"),
        m_right = ui.new_hotkey("AA", "Fake lag", "Manual right"),
        m_forward = ui.new_hotkey("AA", "Fake lag", "Manual forward"),
        static_m = switch(fl_tab, "Static manuals"),
        edge_on_fd = switch(aa_tab, "Edge yaw on Fd"),
        safe_head = list(aa_tab, "Safe head", {"Air Knife hold", "Air Zeus hold", "Target lower than you"}),
        safe_flick = switch(aa_tab, "Defensive safe head"),
        safe_flick_mode = combo(aa_tab, "Mode", {"Flick", "E spam"}),
        safe_flick_pitch = combo(aa_tab, "Pitch", {"Fluculate", "Custom"}),
        safe_flick_pitch_value = slider(tab, container, "\npitch", -89, 89, 0, true, "°", 1, tooltips.pitch),
    },
    builderTab = {
        lableb = label(aa_tab, " "),
        lableb22 = label(fl_tab, " "),
        state = combo(fl_tab, "\nAnti-aim state\r", vars.aaStates), 
    },
    visualsTab = {
        visboba = label(aa_tab, func.hex({menu_r, menu_g, menu_b}) .. "                 Local Visuals"),
        d_321321 = label(aa_tab, func.hex({100, 100, 100}) .. "⟟‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾⟟"),

        cros_ind = switch(aa_tab, "Crosshair Indicators"),
        min_ind = switch(aa_tab, "Min Damage Indicator"),
        min_ind_mode = combo(aa_tab, "\nselect", "Bind", "Always"),
        min_text = combo(aa_tab, "Size", "Default", "Pixel"),
        zoom_animate = switch(aa_tab, "Animate zoom"),
        zoom_speed = slider(tab, container, "Zoom speed", 4, 20, 12),
        zoom_1 = slider(tab, container, "Zoom first - second", 10, 50, 10),
        zoom_2 = slider(tab, container, "\nZoom second", 10, 80, 10),
        on_screen_logs = switch(aa_tab, "On screen logs"),
        on_screen_v = list(aa_tab, "\nA", {"On hit", "On miss", "Evaded shot"}),
        on_screen_alpha = slider("AA", "Anti-aimbot angles", "Alpha", 0, 255, 100, false, "%", 1),
        on_screen_offset = slider("AA", "Anti-aimbot angles", "Offset", 40, 255, 100, false, "px", 1),
        on_screen_max = slider("AA", "Anti-aimbot angles", "Maximum", 1, 10, 4, true, nil, 1),
        debug_panel = switch(aa_tab, "Info panel"),
        arows_txt = switch(aa_tab, "Manuals arrows"),
        arows_txt_color = ui.new_color_picker("AA", container, "Manuals arrows", lua_color.r, lua_color.g, lua_color.b, 255),
        arows_txt_offset = slider("AA", "Anti-aimbot angles", "Offset", 30, 120, 50),
        arows_txt_up_or_daun = combo(aa_tab, "Move on scope", {"-", "Up", "Down"}),
        arows_txt_up_or_daun_offset = slider("AA", "Anti-aimbot angles", "Y Offset", 5, 40, 10),
        --def_ind = switch(aa_tab, "/Defensive bar"),
        slow_down = switch(aa_tab, "Stamina indicator"),
        widgets_slow = list(aa_tab, "\nStamina additions", {"Blackout", "Dynamic color", "Show procents"}),
        widgets_slow_length = slider("AA", "Anti-aimbot angles", "Length / Width", 20,150,100),
        widgets_slow_width = slider("AA", "Anti-aimbot angles", "\nWidth", 1,15,4),
        ammo_low = switch(aa_tab, "Low ammo warning"),
        gs_ind = switch(aa_tab, "Custom indicators"),
        wtm_style = combo(aa_tab, "Watermark style", {"Default", "Glowed", "Modified"}),

        fha87sfas = label(fl_tab, func.hex({menu_r, menu_g, menu_b}) .. "               Render Visuals"),
        d_gvdanh = label(fl_tab, func.hex({100, 100, 100}) .. "⟟‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾⟟"),

        fpsboost = switch(fl_tab, "FPS Optimization"),
        bul_trace = switch(fl_tab, "Local bullet tracer"),
        bul_color = ui.new_color_picker("AA", "Fake lag", "Local bullet tracer", 255, 255, 255, 255),
        bul_dur = slider("AA", "Fake lag", "Duration", 1, 10, 2, true, "s", 1),
        zeus_warning = switch(fl_tab, "Esp zeus warning"),
        trace_target = switch(fl_tab, "Trace to target"),
        plus_hitmarker = switch(fl_tab, "Plus hitmarker"),
        plus_col = ui.new_color_picker("AA", "Fake lag", "Plus hitmarker", 255, 255, 255, 255),
        plus_dur = slider("AA", "Fake lag", "Duration", 1, 10, 2, true, "s", 1),
        grenade_radius = switch(fl_tab, "/Grenades radius"),
        grenade_nades = list(fl_tab, "\a808080FF• \aDCDCDCFFShow", {"Smoke", "Molotov"}),
        predict_position = switch(fl_tab, "Show predict enemy position"),
        _PREDICT_COLOR = ui.new_color_picker("AA", "Fake lag", "Show predict enemy position", 255, 255, 255, 255),

        fha8tsgsfas2 = label(aa_tab, func.hex({menu_r, menu_g, menu_b}) .. "               "),
        fhadsfas = label(aa_tab, func.hex({menu_r, menu_g, menu_b}) .. "                 Other Visuals"),
        d_g312vdanh = label(aa_tab, func.hex({100, 100, 100}) .. "⟟‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾⟟"),

        asp = switch(aa_tab, "Aspect ratio"),
        asp_v = slider("AA", container, "Value", 10, 200, 100),
        third_ = switch(aa_tab, func.hex({255, 0, 0}) .. "• ".. func.hex({200,200,200}) .. "Custom 3rd person distance"),
        third_dis = slider("AA", container, "\nDistance\r", 30, 140, 70),
        viewmodel_en = switch(aa_tab, "Viewmodel changer"),
        viewmodel_fov = slider("AA", container, "Fov / X / Y / Z", 0, 140, 68, true, "°", 1, tooltips.viewmodel_fov),
        viewmodel_x = slider("AA", container, "\nX", -100, 200, 0, true, "°", 1, tooltips.viewmodel_x),
        viewmodel_y = slider("AA", container, "\nY", -100, 200, 0, true, "°", 1, tooltips.viewmodel_y),
        viewmodel_z = slider("AA", container, "\nZ", -100, 200, 0, true, "°", 1, tooltips.viewmodel_z),
        custom_scope = switch(aa_tab, "Custom scope lines"),
        custom_color = ui.new_color_picker("AA", container, "Custom scope lines", 255, 255, 255, 255),
        custom_initial_pos = slider("AA", container, "\na", 0, 400, 100, true, "px", 1),
        custom_offset = slider("AA", container, "\na", 0, 200, 10, true, "px", 1),
        weapon_scope = switch(aa_tab, "Show weapon in scope"),

        fhadsfasa = label(other_tab, func.hex({menu_r, menu_g, menu_b}) .. "                 Animations"),
        d_g312vdadnh = label(other_tab, func.hex({100, 100, 100}) .. "⟟‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾⟟"),
        a_pitch = switch(other_tab, "\a808080FF• \aDCDCDCFFPitch 0 on land"),
        a_body = switch(other_tab, "\a808080FF• \aDCDCDCFFBody lean"),
        a_legacy = switch(other_tab, "\a808080FF• \aDCDCDCFFLegacy 'Moving' state"),
        ap_move = combo(other_tab, "Move legs", {"-", "Static", "Jitter", "Walking", "Kangaroo", "Earthquake"}),
        ap_air = combo(other_tab, "Air legs", {"-", "Force falling", "Walking", "Kangaroo", "Earthquake"}),
        walk_cycle = switch(other_tab, "Always walking"),
        fu8ayafsyu8n = label(fl_tab, " "),
        b3837372 = label(aa_tab, "       "),
    },
    miscTab = {
        miscboba = label(fl_tab, func.hex({menu_r, menu_g, menu_b}) .. "                 Miscellaneous"),
        uhfv3 = label(fl_tab, func.hex({100, 100, 100}) .. "⟟‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾⟟"),
        filtercons = switch(fl_tab, "Console Filter"),
        clanTag = switch(fl_tab, "Animated clantag"),
        clantag_mode = combo(fl_tab, "Mode", {"Anoflow", "#airstopgang"}),
        clan_w = switch(fl_tab, "WMENTOL CLANTAG"),
        clan_a = switch(fl_tab, "ALKASH CLANTAG"),
        inf_ammo = switch(fl_tab, "БЕСКАНЕЧНИЕ ПАТРОНИ"),

        kill_say = switch(fl_tab, "Kill say"),
        --kill_v = list(fl_tab, "\nMode", {"On kill", "On death"}),
        console_logs = switch(fl_tab, "Console logs"),
        console_logs_custom_vibor = switch(fl_tab, "Custom '?' reason"),
        console_logs_resolver = combo(fl_tab, "\nCustom '?' reason\r", {"resolver", "unknown", "correction", "custom"}),
        console_logs_custom = ui.new_textbox("AA", "Fake lag", "Custom name", ""),
        drop_gr = switch(fl_tab, "Drop grenades"),
        drop_key = ui.new_hotkey("AA", "Fake lag", "Drop grenades", true),
        drop_multi = list(fl_tab, "\ngrenades", {"HE Grenade", "Flashbang", "Smoke Grenade", "Molotov", "Decoy"}),
        bomb_fix = switch(fl_tab, "Fix 'E' in bombsite"),
        auto_buy = switch(fl_tab, "Auto buy"),
        auto_w = combo(fl_tab, "\nweapon", {"-", "Awp", "Scout", "ScarCT/ScarT"}),
        auto_p = combo(fl_tab, "\nweapon", {"-", "Deagle", "Seven/Tec"}),
        auto_g = list(fl_tab, "\ngrenades", {"Molotov", "Grenade", "Smoke"}),

        mdadadaa = label(aa_tab, func.hex({menu_r, menu_g, menu_b}) .. "                      Ragebot"),
        fabgynishuo = label(aa_tab, func.hex({100, 100, 100}) .. "⟟‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾⟟"),
        auto_tp = switch(aa_tab, "Automatic teleport"),
        auto_tpHotkey = ui.new_hotkey("AA", container, "Automatic teleport", true),
        auto_tp_indicator_disable = switch(aa_tab, "\a808080FF• \aDCDCDCFFDisable indicators"),

        predict_enable = switch(aa_tab, "Anti \aDC143CFFDefensive"),
        predict_accuracy = switch(aa_tab, "\a808080FF• \aDCDCDCFFEnhance accuracy boost"),
        predict_states = list(aa_tab, "Enable on", {"Standing", "Moving", "Crouching", "Sneaking"}),
        predict_ind = switch(aa_tab, "\a808080FF• \aDCDCDCFFShow indicators"),
        predict_ind_mode = combo(aa_tab, "\a808080FF• \aDCDCDCFFIndicators mode", {"-/+", "off/on"}),

        backtrack_exploit = switch(aa_tab, "Enhance backtrack"),
        backtrack_hitbox = combo(aa_tab, "\a808080FF• \aDCDCDCFFHigh priority hitbox", {"Chest", "Legs"}),
        backtrack_mode2  = switch(aa_tab, "\a808080FF• \aDCDCDCFF???"),
        backtrack_value = slider("AA", container, "\a808080FF• \aDCDCDCFFValue", 2, 7, 1, true, nil, 0.1, tooltips.backtrack),
        jump_scout = switch(aa_tab, "Jumpscout"),
        charge_dt = switch(aa_tab, "Allow charge DT in air"),
        daun_baim = switch(aa_tab, "Baim on defensive"),
        daun_baim_key = ui.new_hotkey("AA", container, "Baim on defensive", true),
        label(aa_tab, "       "),
        
        mdadadaa321 = label(aa_tab, func.hex({menu_r, menu_g, menu_b}) .. "               Resolver / Correction"),
        fabgynishuodad = label(aa_tab, func.hex({100, 100, 100}) .. "⟟‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾⟟"),
        resolver = switch(aa_tab, "Jitter" .. func.hex({menu_r, menu_g, menu_b}) .. " Correction"),
        rs_mode = combo(aa_tab, "\a808080FF• \aDCDCDCFFCorrection mode", {"Wide desync", "Beta"}),

        defensive_resolver =  switch(aa_tab, func.hex({menu_r, menu_g, menu_b}) .. "Defensive" .. func.hex({200,200,200}) .. " Resolver"),
        defensive_v = list(aa_tab, "\nResolve", {"Spin", "Pitch", "Jitter desync"}),

        lab321321 = label(fl_tab, " "),
        lab3s = label(fl_tab, " "),

        lab3 = label(aa_tab, " "),
        mdadad2aa = label(aa_tab, func.hex({menu_r, menu_g, menu_b}) .. "                      Aimtools"),
        fabgynsishuo = label(aa_tab, func.hex({100, 100, 100}) .. "⟟‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾⟟"),
        
        aim_tools_enable = switch(aa_tab, func.hex({menu_r, menu_g, menu_b}) .. "Aim".. func.hex({200,200,200}) .. "Tools"),
        
        aim_tab = slider("AA", container, "Aimtools tab", 1, 4, 1, true, nil, 1, {[1] = "Baim/Safep", [2] = "Hitchance", [3] = "Silent aim", [4] = "Delay shot"}),
        
        aim_tools_baim_mode = combo(aa_tab, "Predfer Body-aim mode", {"Force", "On"}),
        aim_tools_baim_trigers = list(aa_tab, "\nBody-aim if", {"Enemy higher than you", "Enemy HP < X"}),
        aim_tools_baim_hp = slider("AA", "Anti-aimbot angles", func.hex({255, 0, 0}) .. "• ".. func.hex({200,200,200}) .. "HP / X", 30, 92, 92, true, "", 1, tooltips.lethal),
        label_aim = label(aa_tab, " "),
        aim_tools_safe_trigers = list(aa_tab, "Prefer Safe-point if", {"Enemy higher than you", "Enemy HP < X"}),
        aim_tools_safe_hp = slider("AA", "Anti-aimbot angles", func.hex({255, 0, 0}) .. "• ".. func.hex({200,200,200}) .. "HP / X", 30, 92, 92, true, nil, 1, tooltips.lethal),

        aim_tools_hitchance_warning = label(aa_tab, "Pre save config to use this feature"),
        aim_tools_hitchance = switch(aa_tab, "Enable custom hitchance"),
        aim_tools_hc_land = slider("AA", "Anti-aimbot angles", "On land", 0, 100, 80, true, "%", 1, {[0] = "Off", [80] = "Adaptive"}),
        aim_tools_hc_air = slider("AA", "Anti-aimbot angles", "In air", 0, 100, 45, true, "%", 1, {[0] = "Off", [45] = "Adaptive"}),

        aim_tools_silent = switch(aa_tab, "Enable adaptive silent aim"),
        aim_tools_silent_out = list(aa_tab, "Adaptive on", {"Out of fov", "Higher than you"}),

        aim_tools_delay_shot = switch(aa_tab, "Enable custom delay shot"),
        aim_tools_delay_states = list(aa_tab, "States", {"Standing", "Running", "Moving", "Crouching", "Sneaking"}),
        aim_tools_delay_hp = combo(aa_tab, "If enemy", {"-", "Lethal", "Not lethal"}),
        aim_tools_delay_land = switch(aa_tab, "Adjust on land"),
        aim_tools_delay_ind = switch(aa_tab, "Show indicators"),

        mdadad2aaa = label(other_tab, func.hex({menu_r, menu_g, menu_b}) .. "                      Movement"),
        fabgynsdishuo = label(other_tab, func.hex({100, 100, 100}) .. "⟟‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾⟟"),
        ai_peek = switch(other_tab, "".. func.hex({menu_r, menu_g, menu_b}) .. "AI ".. func.hex({200,200,200}) .."Peek bot"),
        ai_peek_key = ui.new_hotkey("AA", "Other", "".. func.hex({menu_r, menu_g, menu_b}) .. "AI ".. func.hex({200,200,200}) .."Peek bot", true),
        ai_peek_info = label(other_tab, "".. func.hex({menu_r, menu_g, menu_b}) .. "• ".. func.hex({200,200,200}) .."This feature in beta"),
        ai_peek_info_2 = label(other_tab, "".. func.hex({255, 0, 0}) .. " Warning! ".. func.hex({200,200,200}) .."Your FPS may decrease!"),
        fast_ladder = switch(other_tab, "Fast ladder"),
        air_stop = switch(other_tab, "Air quick stop"),
        air_stop_k = ui.new_hotkey("AA", "Other", "Air quick stop", true),


    },
    extras = {
        text = ui.new_checkbox("LUA","B","Icon_extra"),
        icon = ui.new_checkbox("LUA","B","text_exetra"),
        gradient = ui.new_checkbox("LUA","B","gradient_extras"),
        length = slider("LUA","B", "legfnth_Extra", 20,150 ,100, true),
        width = slider("LUA","B", "width_extra", 1,15 ,4, true),
        text1 = ui.new_checkbox("LUA","B","Icon_extra1"),
        icon1 = ui.new_checkbox("LUA","B","text_exetra1"),
        gradient1 = ui.new_checkbox("LUA","B","gradient_extras1"),
        dynamic = ui.new_checkbox("LUA","B","dynamic_extras1"),
        length1=slider("LUA","B", "legfnth_Extra1", 20,150 ,100, true),
        width1=slider("LUA","B", "width_extra1", 1,15 ,4, true),
    },
    configTab = {
        list = ui.new_listbox(tab, container, "Configs", ""),
        name = ui.new_textbox(tab, container, "Config name", ""),
        load = ui.new_button(tab, container, "\aFFFFFFFF Load", function() end),
        save = ui.new_button(tab, container, "\aFFFFFFFF Save", function() end),
        delete = ui.new_button(tab, container, "\aFFFFFFFF Delete", function() end),
        labelc = label(other_tab, "Create config"),
        create_name = ui.new_textbox("AA", "Other", "Config name", ""),
        create = ui.new_button("AA", "Other", "\aFFFFFFFF Create", function() end),
        import = ui.new_button("AA", "Other", "\aFFFFFFFF Import", function() end),
        export = ui.new_button("AA", "Other", "\aFFFFFFFF Export", function() end),
        default = ui.new_button("AA", "Other", " Default cfg", function() end),

    },
    infoTab = {
        label1 = label(fl_tab, "Welcome back " .. nick_name),
        label2 = label(fl_tab, " Last update was \aFFFFFFFF 22.01.2025 "),
        label3 = label(fl_tab, " Your build is " .. func.hex({menu_r, menu_g, menu_b}) .. script_build),
        label1488 = label(fl_tab, " Session time: "),
        evaded = label(fl_tab, "Evaded miss to anoflow:"),
        label900 = label(fl_tab, "       "),
        dada = label(fl_tab, "  "),
        stats = ui.new_button("AA", "Fake lag", "Statistic [discord]", function()
            send_stats()
            panorama.loadstring("SteamOverlayAPI.OpenExternalBrowserURL('https://discord.com/channels/1306899464040218716/1333428869998448713');")()
        end),
        spons = ui.new_button("AA", "Fake lag", "Sponsor the project", function()
            panorama.loadstring("SteamOverlayAPI.OpenExternalBrowserURL('https://www.donationalerts.com/r/marolower');")()
        end),
    },
    custTab = {
        info_panel_pos = combo(fl_tab, "Info panel position", {"Up", "Down"})
    }
}

local aaBuilder = {}
    for i = 1, #vars.aaStates do
        aaBuilder[i] = {
            label_huy = label(fl_tab, "   "),
            enableState = switch(fl_tab, "\rOverride " .. func.hex({menu_r, menu_g, menu_b}) .. vars.aaStates[i] .. func.hex({200,200,200})),
            stateDisablers = list(aa_tab, "\rDisablers\r", {"Standing", "Running", "Moving", "Crouching", "Air", "Air+C", "Sneaking"}),
            yaw = combo(aa_tab, "\rYaw Mode\n", {"Offset", "Left / Right"}),
            yawStatic = slider(tab, container, "\nyaw\r", -180, 180, 0, true, "°", 1),
            yawLeft = slider(tab, container, "\nLeft\nyaw", -90, 90, 0, true, "°", 1),
            yawRight = slider(tab, container, "\nRight\nyaw", -90, 90, 0, true, "°", 1),
            yawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "\rYaw Modifier\r", "Off", "Center", "Skitter", "Random", "3-Way", "Sway"),
            wayFirst = slider(tab, container, "\nFirst yaw jitter\r", -180, 180, 0, true, "°", 1),
            waySecond = slider(tab, container, "\nSecond yaw jitter\r", -180, 180, 0, true, "°", 1),
            wayThird = slider(tab, container, "\nThird yaw jitter\r", -180, 180, 0, true, "°", 1),
            yawJitterStatic = slider(tab, container, "\nOffset yaw jitter\r", 0, 90, 0, true, "°", 1),
            sway_speed = slider(tab, container, "Speed\n", 2, 16, 0, true, nil, 1),
            bodyYaw = combo(aa_tab, "Body yaw\n", "Off", "Opposite", "Static", "Jitter"),
            bodyYawStatic = slider(tab, container, "Side", -2, 2, 0, true, "°", 1, tooltips.body),
            delayed_body = slider(tab, container, "Delay\r", 1, 11, 1, true, "t", 1, tooltips.delay),
            random_delay = slider(tab, container, "Randomize delay\r", 1, 11, 1, true, "t", 1, {[1] = "Off"}),
            randomization = slider("AA", "Other", "Randomization", 0, 100, 0, true, "%", 1),
    
            label_anti = label(aa_tab, "   "),
            --Min/Max \a808080FF• \aDCDCDCFF
            force_defensive = switch(aa_tab, "Force " .. func.hex({menu_r, menu_g, menu_b}) .. "defensive"),
            defensive_mode = combo(aa_tab, "\nMode", {"On peek", "Default", "Switch"}),
            defensive_delay = slider(tab, container, "Defensive delay", 0, 50, 3, true, "%", 1, {[0] = "Default", [7] = "Neverlose"}),

            defensiveAntiAim = ui.new_checkbox("AA", "Anti-aimbot angles", func.hex({menu_r, menu_g, menu_b}) .. "Defensive" .. func.hex({200, 200, 200}) ..  " Anti-Aim"),
            def_pitch = combo(aa_tab, "Pitch\n", "Off", "Custom", "Random", "Random (gamesense)", "3-way", "Dynamic", "Sway", "Switch", "Flick"),
            def_pitchSlider = slider("AA", "Anti-aimbot angles", "\nPitch add", -89, 89, 0, true, "°", 1, tooltips.pitch),
            def_pitch_s1 = slider("AA", "Anti-aimbot angles", func.hex({80, 80, 80}) .. "Min/Max" .. func.hex({menu_r, menu_g, menu_b}) .. " pitch", -89, 89, -89, true, "°", 1, tooltips.pitch),
            def_pitch_s2 = slider("AA", "Anti-aimbot angles", "\nTo", -89, 89, 89, true, "°", 1, tooltips.pitch),
            def_slow_gen = slider("AA", "Anti-aimbot angles", "Generate speed\n", 0, 10, 0, true, "", 0.1, {[0] = "Default", [2] = "Static"}),
            def_dyn_speed = slider("AA", "Anti-aimbot angles", "\rSpeed\n", 1, 20, 0, true, "", 1),
            def_jit_delay = slider("AA", "Anti-aimbot angles", "\rDelay\n", 2, 20, 0, true, "", 1),
            def_3_1 = slider("AA", "Anti-aimbot angles", "\rFirst/Second/Third", -89, 89, 0, true, "°", 1, tooltips.pitch),
            def_3_2 = slider("AA", "Anti-aimbot angles", "\nsecond", -89, 89, 0, true, "°", 1, tooltips.pitch),
            def_3_3 = slider("AA", "Anti-aimbot angles", "\nthird", -89, 89, 0, true, "°", 1, tooltips.pitch),
            
            def_yawMode = combo(aa_tab, "\rYaw\n", "Off", "Custom", "Spin", "Distorion", "Switch", "Random", "3-ways"),
            def_yawStatic = slider("AA", "Anti-aimbot angles", "\nOffset\r", -180, 180, 0, true, "°", 1),
            def_yaw_spin_range = ui.new_slider("AA", "Anti-aimbot angles", "Range\n", 0, 360, 180, true, "°", 1),
            def_yaw_spin_speed = ui.new_slider("AA", "Anti-aimbot angles", "Speed\n", -15, 15, 4, true, "t", 1),
            def_yaw_left = slider("AA", "Anti-aimbot angles", func.hex({80, 80, 80}) .. "Min/Max" .. func.hex({menu_r, menu_g, menu_b}) .. " yaw", -180, 180, -90, true, "°", 1),
            def_yaw_right = slider("AA", "Anti-aimbot angles", "\n", -180, 180, 90, true, "°", 1),
            def_yaw_random = slider("AA", "Anti-aimbot angles", "Randomization\n", 0, 180, 0, true, "%", 1, {[0] = "Off"}),
            def_yaw_switch_delay = slider("AA", "Anti-aimbot angles", "Delay\n", 2, 20, 2, true, "t", 1, {[2] = "Off"}),
            def_yaw_exploit_speed = slider("AA", "Anti-aimbot angles", "Speed\n", 1, 20, 1, true, "", 0.2),
            def_slow_gena = slider("AA", "Anti-aimbot angles", "Generate speed\n", 0, 10, 0, true, "", 0.1, {[0] = "Default", [2] = "Static"}),
            def_way_1 = slider("AA", "Anti-aimbot angles", "\nfirst", -180, 180, 0, true, "°", 1),
            def_way_2 = slider("AA", "Anti-aimbot angles", "\nsecond", -180, 180, 0, true, "°", 1),
            def_way_3 = slider("AA", "Anti-aimbot angles", "\nthird", -180, 180, 0, true, "°", 1),
    
            bidy = switch(aa_tab, "Adaptive body yaw"), 


            fl_enable = switch(fl_tab, "Custom fake-lag"),
            fl_mode = combo(fl_tab, "Fake lag mode", {"Maximum", "Random", "Fluculate [custom]"}),
            
            --anti brute
            antibrute_enable = switch(other_tab, "Override " .. func.hex({menu_r, menu_g, menu_b}) .. vars.aaStates[i] .. func.hex({200,200,200}) .. " Anti-brute"),
            antibrute_aa = list(other_tab, "Anti-brute AA", {"Yaw", "Modifier", "Body yaw"}),
            antibrute_yaw = slider("AA", "Other",  "\nYaw", -60, 60, 0, true, "°", 1),
            antibrute_mod = combo(other_tab, "Modifier", {"-","Center", "Random", "Sway", "Delayed"}),
            antibrute_mod_range = slider("AA", "Other",  "\nModifier range", -70, 70, 0, true, "°", 1),
            antibrute_body = combo(other_tab, "Body yaw mode", {"-", "Static", "Jitter", "Delayed"}),
            antibrute_body_range = slider("AA", "Other", "\nbody range", -59, 59, 0, true, "°", 1),
        }
    end
--client.exec("clear")

event_callback("paint_ui", function()
    max_notifs = ui.get(menu.visualsTab.on_screen_max)
end)
local anim_time, data = 0.3,  {}
local notifications = {

    new = function(string, r, g, b)
        if #data >= max_notifs then
            table.remove(data, 1)
        end
        table.insert(data, {
            time = globals.curtime(),
            string = string,
            color = {r, g, b, 255},
            fraction = 0
        })
    end,

    render = function()
        local x, y = client.screen_size()
        local to_remove = {}
        local Offset = ui.get(menu.visualsTab.on_screen_offset)
        local col1, col2, col3, col4 = ui.get(calar)
        for i = 1, #data do
            local notif = data[i]

            local data = {rounding = 8, size = 3, glow = 9, time = 4}

            if notif.time + data.time - globals.curtime() > 0 then
                notif.fraction = func.clamp(notif.fraction + globals.frametime() / anim_time, 0, 1)
            else
                notif.fraction = func.clamp(notif.fraction - globals.frametime() / anim_time, 0, 1)
            end

            if notif.fraction <= 0 and notif.time + data.time - globals.curtime() <= 0 then
                table.insert(to_remove, i)
            else
                table.remove(to_remove, i)
            end

            local fraction = func.easeInOut(notif.fraction)

            local r, g, b, a = unpack(notif.color)
            local string = color_text(notif.string, r, g, b, a * fraction)

            local strw, strh = renderer.measure_text("", string)
            local strw2 = renderer.measure_text("b", "")
            local alp = ui.get(menu.visualsTab.on_screen_alpha)
            local paddingx, paddingy = 3, data.size
            local offsetY = 0

            Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction
            container_glow(x/2 - (strw + strw2)/2 - paddingx, y - offsetY - strh/2 - paddingy - Offset, strw + strw2 + paddingx*2, strh + paddingy*3, r, g, b, alp--[[ * fraction]], 1.3, col1, col2, col3, function(cx, cy, cw, ch)
                renderer.text(x/2 + strw2/2, y - offsetY - Offset, 255, 255, 255, 255 * fraction, "c", 0, string)
            end)        end

        for i = #to_remove, 1, -1 do
            table.remove(data, to_remove[i])
        end
    end,

    clear = function()
        data = {}
    end
}

my_font = surface.create_font("Verdana", 12, 500, 128)

local lua = {
    database = {
        configs = "anoflow:configs"
    }
}
presets,slow_turtle = {}, renderer.load_svg('<svg width="800" height="800" viewBox="0 0 128 128" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" class="iconify iconify--noto"><path d="M112.7 59.21s3.94-2.21 4.93-2.77c.99-.56 4.6-2.82 5.91-.84.77 1.16-.7 4.44-3.05 7.86-2.14 3.13-7.12 9.56-7.4 10.83-.28 1.27 1.11 6.36 1.53 8.33.42 1.97 1.74 6.71 1.17 8.54s-3.43 6.85-10.75 6.76c-5.82-.07-7.51-1.78-7.7-2.82-.14-.75-.56-3.24-.56-3.24s-4.79 2.96-7.04 4.08-8.31 4.22-8.31 4.22 1.17 5.35 1.36 7.51c.19 2.16.86 5.25-.28 7.32-1.03 1.88-4.25 5.02-11.83 4.97-5.92-.04-7.41-1.88-8.35-3-.94-1.13-1.13-6.48-1.13-7.6s-.19-5.07-.19-5.07-8.02-.4-12.86-.75c-4.38-.32-10.16-.99-10.16-.99s.21 2.33.42 4.01c.19 1.5.23 4.64-1.34 6.17-2.11 2.06-7.56 2.21-10.56 1.92-3-.28-7.18-1.83-8.4-4.55-1.22-2.72.38-6.29 1.03-8.35.58-1.81 1.6-4.41 1.22-5.16-.38-.75-4.04-1.69-9.29-6.95-5.26-5.26-12.13-23.52 3.28-36.23 15.49-12.76 43.81 1.1 45.31 2.04 1.54.96 53.04 3.76 53.04 3.76z" fill="#bdcf47"/><path d="M66.25 25.28c-13.93.62-24.38 7.52-29.57 15.06-3.1 4.5-4.65 7.74-4.65 7.74s4.81.14 9.15 2.46c5 2.67 10.8 5.56 14.61 18.13 2.87 9.5 3.98 18.53 11.44 20.52 8.45 2.25 28.16 1.13 37.59-8.02s11.26-16.05 8.87-25.06-13.17-25.05-28.16-29.28C79.06 25 72.58 25 66.25 25.28z" fill="#6e823a"/><path d="M111.93 51.32c-.42-.99-1.3-2.5-1.3-2.5s-.07 2.05-.25 3.13c-.28 1.76-1.25 5.42-1.81 4.88-1-.97-5.73-6.92-7.98-10.23-1.71-2.52-7.6-9.11-7.74-11.26-.07-1.06 1.27-4.65 1.27-4.65s-1.22-.7-2.35-1.34c-.88-.49-2.16-1.03-2.16-1.03s-.77 4.9-1.62 5.82c-.75.81-5.32 2.6-8.87 3.94-4.29 1.62-8.45 3.73-10 4.01-1.36.25-9.09-1.41-12-1.97-3.66-.7-9.18-2.26-10.45-3.17-1.48-1.06-3.07-3.78-3.07-3.78s-.89.61-1.78 1.31c-.88.69-2.02 2.06-2.02 2.06s2.31 2.32 2.44 3.18c.18 1.2-1.27 2.83-2.46 4.38-.72.93-2.75 4.85-2.75 4.85s.97.09 2.15.63c1.23.57 2.38 1.16 2.38 1.16s2.97-6.9 4.9-7.53c1.65-.54 6.3.99 9.68 1.69 4.79.99 9.64 1.87 10.66 3.17 1.06 1.34 2.06 6.68 3.03 11.19C70.89 64.2 73.64 77.02 73 78c-.63.99-5.7.63-8.59.28-2.45-.3-6.41-1.76-6.41-1.76s.58 2.11.77 2.67c.28.81 1.16 3.06 1.16 3.06s5.67 2.5 22.42.95 25.03-12.96 27.38-18.02c3.14-6.78 3.54-10.39 3.54-10.39s-.92-2.48-1.34-3.47zM96.65 73.21c-4.24 2.67-15.2 5.49-17.18 4.43-1.58-.85-3.94-13.94-5.07-19.78-.72-3.74-2.45-9.42-1.41-11.19.7-1.2 4.79-2.99 7.81-4.4 2.87-1.33 6.97-3.13 8.17-2.99 1.7.2 5.35 6.12 9.01 11.19 3.66 5.07 7.67 10.35 7.74 12.18.09 1.84-4.7 7.82-9.07 10.56z" fill="#484e23"/><path d="M41.18 65.86c.5 2.83-.95 5.75-4.07 6.02-2.56.22-4.59-1.57-5.09-4.4s1.14-5.49 3.68-5.94c2.52-.45 4.98 1.48 5.48 4.32zm-18.36.25c.07 2.84-2.42 5.69-5.5 5.11-2.53-.48-3.99-2.73-3.71-5.55.29-2.82 2.59-4.9 5.15-4.65s3.99 2.13 4.06 5.09zm7.95 10.48c1.16-.79 3.1-2.67 4.36-1.06 1.27 1.62-.92 3.1-2.18 4.01-1.27.92-4.08 3.17-6.12 3.17-1.9 0-4.79-2.32-6.62-3.87-1.49-1.26-2.18-2.89-1.34-3.87s2.14-.62 3.24.35c1.27 1.13 3.72 3.38 4.72 3.38.98.01 2.39-1.05 3.94-2.11z" fill="#2a2b28"/></svg>', 100, 100)


--[[local function initDatabase()
    if database.read(lua.database.configs) == nil then
        database.write(lua.database.configs, {})
    end

    local link = "https://pastebin.com/raw/11vQhZaS"
    http.get(link, function(success, response)
        if not success then
            print("Failed to get presets")
            return
        end

        writefile("default_cfg.txt", response.body)
    
        data = json.parse(response.body)
    
        for i, preset in pairs(data.presets) do
            table.insert(presets, { name = "*"..preset.name, config = preset.config})
            ui.set(menu.configTab.name, "*"..preset.name)
        end
        ui.update(menu.configTab.list, getConfigList())
    end)
end]]
--initDatabase()
local db = {
    lua = "beta",
}

local data = database.read(db.lua)

if not data then
    data = {
        configs = {},
        stats = {
            killed = 0, evaded = 0, loaded = 1
        },
    }
    database.write(db.lua, data)
end

if not data.stats then
    data.stats = {
        killed = 0, evaded = 0, loaded = 1
    }
end

if not data.stats.evaded then
    data.stats.evaded = 0
end

if not data.stats.killed then
    data.stats.killed = 0
end

if not data.stats.loaded then
    data.stats.loaded = 1
end

data.stats.loaded = data.stats.loaded + 1

my = {
    entity = entity.get_local_player()
}

database.write(db.lua, data)


function traverse_table_on(tbl, prefix)
    prefix = prefix or ""
    local stack = {{tbl, prefix}}

    while #stack > 0 do
        local current = table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        for key, value in pairs(current_tbl) do
            local full_key = current_prefix .. key
            if type(value) == "table" then
                table.insert(stack, {value, full_key .. "."})
            else
                ui.set_visible(value, true)
            end
        end
    end
end

function traverse_table(tbl, prefix, set_visible)
    prefix = prefix or ""
    local stack = {{tbl, prefix}}
    local visited = {}

    while #stack > 0 do
        local current = table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        if not visited[current_tbl] then
            visited[current_tbl] = true

            for key, value in pairs(current_tbl) do
                local full_key = current_prefix .. key
                if type(value) == "table" then
                    table.insert(stack, {value, full_key .. "."})
                else
                    ui.set_visible(value, set_visible)
                end
            end
        end
    end
end

local isEnabled, saved = true, true
event_callback("paint_ui", function()
    vars.activeState = vars.sToInt[ui.get(menu.builderTab.state)]
    if ui.is_menu_open() then
        ui.set(menu.infoTab.label1488, " Session time: \aFFFFFFFF"..get_elapsed_time())
    end
    ui.set(menu.infoTab.evaded, " Evaded misses to anoflow: " .. data.stats.evaded)
    ui.set(aaBuilder[1].enableState, true)
    ui.set_enabled(menu.infoTab.stats, false)
    --ui.set_visible(menu.infoTab.spons, false)
    ui.set_visible(tabPicker, isEnabled)
    ui.set_visible(aaTabs, ui.get(tabPicker) == " Anti-aim" and isEnabled)
    ui.set_visible(mTabs, ui.get(tabPicker) == " Settings" and isEnabled)
    ui.set_visible(iTabs, ui.get(tabPicker) == " Main" and isEnabled)
    traverse_table(binds)
    local isAATab = ui.get(tabPicker) == " Anti-aim" and ui.get(aaTabs) == " Settings"
    local isBuilderTab = ui.get(tabPicker) == " Anti-aim" and ui.get(aaTabs) == " Builder"
    local isVisualsTab = ui.get(tabPicker) == " Settings" and ui.get(mTabs) == " Visuals"
    local isMiscTab = ui.get(tabPicker) == " Settings" and ui.get(mTabs) == " Miscellaneous"
    local isCFGTab = ui.get(tabPicker) == " Main"
    local isINFOTab = ui.get(tabPicker) == " Main" and ui.get(iTabs) == " Information"
    local isCUSTtab = ui.get(tabPicker) == " Main" and ui.get(iTabs) == " Other"
    for i = 1, #vars.aaStates do
        local stateEnabled = ui.get(aaBuilder[i].enableState)
        ui.set_visible(aaBuilder[i].label_huy, vars.activeState == i and i~=1 and isBuilderTab and isEnabled)
        ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and i~=1 and isBuilderTab and isEnabled)
        ui.set_visible(aaBuilder[i].force_defensive, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].defensive_mode, vars.activeState == i and ui.get(aaBuilder[i].force_defensive) and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].defensive_delay, vars.activeState == i and ui.get(aaBuilder[i].force_defensive) and ui.get(aaBuilder[i].defensive_mode) == "Switch" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].stateDisablers, vars.activeState == 9 and i == 9 and isBuilderTab and ui.get(aaBuilder[9].enableState) and isEnabled)
        ui.set_visible(aaBuilder[i].yaw, (vars.activeState == i and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].yawStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) == "Offset" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawLeft, (vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and (ui.get(aaBuilder[i].yaw) == "Left / Right") and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and (ui.get(aaBuilder[i].yaw) == "Left / Right") and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitter, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].wayFirst, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].waySecond, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].wayThird, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitter) ~= "3-Way" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].sway_speed, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "Sway" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawStatic, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and ui.get(aaBuilder[i].bodyYaw) ~= "Jitter" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].delayed_body, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) == "Jitter" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].random_delay, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) == "Jitter" and ui.get(aaBuilder[i].delayed_body)~=1 and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].randomization, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        
        ui.set_visible(aaBuilder[i].defensiveAntiAim, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)

        ui.set_visible(aaBuilder[i].def_pitch, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_pitchSlider , ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].def_pitch) == "Custom" and isEnabled))
        ui.set_visible(aaBuilder[i].def_pitch_s1 , ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and (ui.get(aaBuilder[i].def_pitch) == "Random" or ui.get(aaBuilder[i].def_pitch) == "Switch" or ui.get(aaBuilder[i].def_pitch) == "Flick" or ui.get(aaBuilder[i].def_pitch) == "Dynamic" or ui.get(aaBuilder[i].def_pitch) == "Sway") and isEnabled))
        ui.set_visible(aaBuilder[i].def_pitch_s2 , ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and (ui.get(aaBuilder[i].def_pitch) == "Random" or ui.get(aaBuilder[i].def_pitch) == "Switch" or ui.get(aaBuilder[i].def_pitch) == "Flick" or ui.get(aaBuilder[i].def_pitch) == "Dynamic" or ui.get(aaBuilder[i].def_pitch) == "Sway") and isEnabled))
        ui.set_visible(aaBuilder[i].def_slow_gen, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].def_pitch) == "Random" and isEnabled))
        ui.set_visible(aaBuilder[i].def_dyn_speed, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and (ui.get(aaBuilder[i].def_pitch) == "Dynamic" or ui.get(aaBuilder[i].def_pitch) == "Sway") and isEnabled))
        ui.set_visible(aaBuilder[i].def_jit_delay, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].def_pitch) == "Switch" and isEnabled))
        ui.set_visible(aaBuilder[i].def_3_1, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].def_pitch) == "3-way" and isEnabled))
        ui.set_visible(aaBuilder[i].def_3_2, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].def_pitch) == "3-way" and isEnabled))
        ui.set_visible(aaBuilder[i].def_3_3, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].def_pitch) == "3-way" and isEnabled))
        ui.set_visible(aaBuilder[i].def_yawMode, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yawStatic, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and (ui.get(aaBuilder[i].def_yawMode) == "Custom") and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yaw_spin_range, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yawMode) == "Spin" and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yaw_spin_speed, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yawMode) == "Spin" and isBuilderTab and stateEnabled and isEnabled))

        ui.set_visible(aaBuilder[i].def_yaw_left, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and (ui.get(aaBuilder[i].def_yawMode) == "Switch" or ui.get(aaBuilder[i].def_yawMode) == "Random" or ui.get(aaBuilder[i].def_yawMode) == "Distorion") and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yaw_right, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and (ui.get(aaBuilder[i].def_yawMode) == "Switch" or ui.get(aaBuilder[i].def_yawMode) == "Random" or ui.get(aaBuilder[i].def_yawMode) == "Distorion") and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yaw_switch_delay, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yawMode) == "Switch" and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_yaw_random, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and (ui.get(aaBuilder[i].def_yawMode) == "Switch" or ui.get(aaBuilder[i].def_yawMode) == "Custom") and isBuilderTab and stateEnabled and isEnabled))

        ui.set_visible(aaBuilder[i].def_yaw_exploit_speed, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and (ui.get(aaBuilder[i].def_yawMode) == "Distorion") and isBuilderTab and stateEnabled and isEnabled))
        
        ui.set_visible(aaBuilder[i].def_slow_gena, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yawMode) == "Random" and isBuilderTab and stateEnabled and isEnabled))
        
        ui.set_visible(aaBuilder[i].def_way_1, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yawMode) == "3-ways" and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_way_2, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yawMode) == "3-ways" and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].def_way_3, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and ui.get(aaBuilder[i].def_yawMode) == "3-ways" and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].bidy, ui.get(aaBuilder[i].defensiveAntiAim) and (vars.activeState == i and isBuilderTab and stateEnabled and isEnabled))
        ui.set_visible(aaBuilder[i].label_anti, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)

        ui.set_visible(aaBuilder[i].fl_enable, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and not i==9)
        ui.set_visible(aaBuilder[i].fl_mode, vars.activeState == i and ui.get(aaBuilder[i].fl_enable) and isBuilderTab and stateEnabled and isEnabled and not i==9)

        ui.set_visible(aaBuilder[i].antibrute_enable, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].antibrute_aa, vars.activeState == i and ui.get(aaBuilder[i].antibrute_enable) and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].antibrute_yaw, vars.activeState == i and ui.get(aaBuilder[i].antibrute_enable) and func.includes(ui.get(aaBuilder[i].antibrute_aa), "Yaw") and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].antibrute_mod, vars.activeState == i and ui.get(aaBuilder[i].antibrute_enable) and func.includes(ui.get(aaBuilder[i].antibrute_aa), "Modifier") and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].antibrute_mod_range, vars.activeState == i and ui.get(aaBuilder[i].antibrute_enable) and func.includes(ui.get(aaBuilder[i].antibrute_aa), "Modifier") and ui.get(aaBuilder[i].antibrute_mod) ~= "-" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].antibrute_body, vars.activeState == i and ui.get(aaBuilder[i].antibrute_enable) and func.includes(ui.get(aaBuilder[i].antibrute_aa), "Body yaw") and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].antibrute_body_range, vars.activeState == i and ui.get(aaBuilder[i].antibrute_enable) and func.includes(ui.get(aaBuilder[i].antibrute_aa), "Body yaw") and ui.get(aaBuilder[i].antibrute_body) ~= "-"and isBuilderTab and stateEnabled and isEnabled)
        
        
    --[[ui.set_enabled(aaBuilder[i].antibrute_enable, false)
    ui.set_enabled(aaBuilder[i].antibrute_aa, false)
    ui.set_enabled(aaBuilder[i].antibrute_yaw, false)
    ui.set_enabled(aaBuilder[i].antibrute_mod, false)
    ui.set_enabled(aaBuilder[i].antibrute_mod_range, false)
    ui.set_enabled(aaBuilder[i].antibrute_body, false)
    ui.set_enabled(aaBuilder[i].antibrute_body_range, false)]]
    end

    for i, feature in pairs(menu.aaTab) do
        ui.set_visible(feature, isAATab and isEnabled)
    end

    for i, feature in pairs(menu.custTab) do
        ui.set_visible(feature, isCUSTtab and isEnabled)
    end

    for i, feature in pairs(menu.builderTab) do
		ui.set_visible(feature, isBuilderTab and isEnabled)
	end

    for i, feature in pairs(menu.visualsTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isVisualsTab and isEnabled)
        end
	end
    
    for i, feature in pairs(menu.miscTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isMiscTab and isEnabled)
        end
	end

    ui.set_visible(menu.visualsTab.fu8ayafsyu8n, isCUSTtab)

    ui.set_visible(menu.miscTab.clan_w, _WMENTOL and isMiscTab)
    ui.set_visible(menu.miscTab.clan_a, _ALKASH and isMiscTab)
    ui.set_visible(menu.miscTab.inf_ammo, (_ALKASH or _WMENTOL) and isMiscTab)

    ui.set_enabled(menu.visualsTab.weapon_scope, false)
    ui.set(menu.visualsTab.weapon_scope, false)
    ui.set_enabled(menu.configTab.default, false)
    ui.set_visible(menu.miscTab.clantag_mode, ui.get(menu.miscTab.clanTag) and (isMiscTab and isEnabled))
    ui.set_visible(menu.miscTab.console_logs_custom_vibor, ui.get(menu.miscTab.console_logs) and (isMiscTab and isEnabled))
    ui.set_visible(menu.miscTab.console_logs_resolver, ui.get(menu.miscTab.console_logs) and ui.get(menu.miscTab.console_logs_custom_vibor) and (isMiscTab and isEnabled))
    ui.set_visible(menu.miscTab.console_logs_custom, ui.get(menu.miscTab.console_logs) and ui.get(menu.miscTab.console_logs_custom_vibor) and ui.get(menu.miscTab.console_logs_resolver) == "custom" and (isMiscTab and isEnabled))
    ui.set_visible(menu.visualsTab.min_ind_mode, ui.get(menu.visualsTab.min_ind) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.min_text, ui.get(menu.visualsTab.min_ind) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.asp_v, ui.get(menu.visualsTab.asp) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.third_dis, ui.get(menu.visualsTab.third_) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.zoom_speed, ui.get(menu.visualsTab.zoom_animate) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.zoom_1, ui.get(menu.visualsTab.zoom_animate) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.zoom_2, ui.get(menu.visualsTab.zoom_animate) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.bul_color, ui.get(menu.visualsTab.bul_trace) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.bul_dur, ui.get(menu.visualsTab.bul_trace) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.plus_dur, ui.get(menu.visualsTab.plus_hitmarker) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.plus_col, ui.get(menu.visualsTab.plus_hitmarker) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.on_screen_v, ui.get(menu.visualsTab.on_screen_logs) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.on_screen_alpha, ui.get(menu.visualsTab.on_screen_logs) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.on_screen_offset, ui.get(menu.visualsTab.on_screen_logs) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.visualsTab.on_screen_max, ui.get(menu.visualsTab.on_screen_logs) and (isVisualsTab and isEnabled))
    ui.set_visible(menu.miscTab.auto_tp_indicator_disable, ui.get(menu.miscTab.auto_tp) and isMiscTab)
    ui.set_enabled(menu.miscTab.auto_tp, false)
    ui.set_visible(menu.miscTab.rs_mode, ui.get(menu.miscTab.resolver) and isMiscTab)
    ui.set_visible(menu.miscTab.defensive_v, ui.get(menu.miscTab.defensive_resolver) and isMiscTab)
    ui.set_visible(menu.aaTab.avoid_dist, ui.get(menu.aaTab.anti_knife) and isAATab)
    ui.set_visible(menu.aaTab.safe_flick, isAATab and (func.includes(ui.get(menu.aaTab.safe_head), "Knife") or func.includes(ui.get(menu.aaTab.safe_head), "Air Zeus hold")))
    ui.set_visible(menu.aaTab.safe_flick_mode, isAATab and (ui.get(menu.aaTab.safe_flick) and (func.includes(ui.get(menu.aaTab.safe_head), "Knife") or func.includes(ui.get(menu.aaTab.safe_head), "Air Zeus hold"))))
    ui.set_visible(menu.aaTab.safe_flick_pitch, isAATab and (ui.get(menu.aaTab.safe_flick) and ui.get(menu.aaTab.safe_flick_mode) == "E spam" and (func.includes(ui.get(menu.aaTab.safe_head), "Knife") or func.includes(ui.get(menu.aaTab.safe_head), "Air Zeus hold"))))
    ui.set_visible(menu.aaTab.safe_flick_pitch_value, isAATab and (ui.get(menu.aaTab.safe_flick) and ui.get(menu.aaTab.safe_flick_mode) == "E spam" and (ui.get(menu.aaTab.safe_flick_pitch) == "Custom") and (func.includes(ui.get(menu.aaTab.safe_head), "Knife") or func.includes(ui.get(menu.aaTab.safe_head), "Air Zeus hold"))))

    ui.set_visible(menu.miscTab.backtrack_hitbox, ui.get(menu.miscTab.backtrack_exploit) and isMiscTab)
    ui.set_enabled(menu.miscTab.backtrack_hitbox, false)
    ui.set_visible(menu.miscTab.backtrack_value, ui.get(menu.miscTab.backtrack_exploit) and isMiscTab)
    ui.set_visible(menu.miscTab.predict_accuracy, ui.get(menu.miscTab.predict_enable) and isMiscTab)
    ui.set_visible(menu.miscTab.predict_states, ui.get(menu.miscTab.predict_enable) and isMiscTab)
    ui.set_visible(menu.miscTab.predict_ind, ui.get(menu.miscTab.predict_enable) and isMiscTab)
    ui.set_visible(menu.miscTab.predict_ind_mode, ui.get(menu.miscTab.predict_enable) and ui.get(menu.miscTab.predict_ind) and isMiscTab)
    ui.set_enabled(menu.aaTab.spin_exploit, false)
    ui.set(menu.aaTab.spin_exploit, false)
    ui.set_visible(menu.miscTab.ai_peek_info, ui.get(menu.miscTab.ai_peek) and isMiscTab)
    ui.set_visible(menu.miscTab.ai_peek_info_2, ui.get(menu.miscTab.ai_peek) and isMiscTab)
    ui.set_visible(menu.miscTab.drop_multi, ui.get(menu.miscTab.drop_gr) and isMiscTab)
    ui.set_visible(menu.miscTab.drop_key, ui.get(menu.miscTab.drop_gr) and isMiscTab)
    ui.set_visible(menu.miscTab.drop_gr, false)

    ui.set_visible(menu.miscTab.auto_w, ui.get(menu.miscTab.auto_buy) and isMiscTab)
    ui.set_visible(menu.miscTab.auto_p, ui.get(menu.miscTab.auto_buy) and isMiscTab)
    ui.set_visible(menu.miscTab.auto_g, ui.get(menu.miscTab.auto_buy) and isMiscTab)
    ui.set_visible(menu.visualsTab.grenade_nades, ui.get(menu.visualsTab.grenade_radius) and isVisualsTab)
    ui.set_visible(menu.visualsTab.viewmodel_fov, ui.get(menu.visualsTab.viewmodel_en) and isVisualsTab)
    ui.set_visible(menu.visualsTab.viewmodel_x, ui.get(menu.visualsTab.viewmodel_en) and isVisualsTab)
    ui.set_visible(menu.visualsTab.viewmodel_y, ui.get(menu.visualsTab.viewmodel_en) and isVisualsTab)
    ui.set_visible(menu.visualsTab.viewmodel_z, ui.get(menu.visualsTab.viewmodel_en) and isVisualsTab)
    ui.set_visible(menu.visualsTab.widgets_slow, ui.get(menu.visualsTab.slow_down) and isVisualsTab)
    ui.set_visible(menu.visualsTab.widgets_slow_length, ui.get(menu.visualsTab.slow_down) and isVisualsTab)
    ui.set_visible(menu.visualsTab.widgets_slow_width, ui.get(menu.visualsTab.slow_down) and isVisualsTab)

    ui.set_visible(menu.visualsTab.arows_txt_color, ui.get(menu.visualsTab.arows_txt) and isVisualsTab)
    ui.set_visible(menu.visualsTab.arows_txt_offset, ui.get(menu.visualsTab.arows_txt) and isVisualsTab)
    ui.set_visible(menu.visualsTab.arows_txt_up_or_daun, ui.get(menu.visualsTab.arows_txt) and isVisualsTab)
    ui.set_visible(menu.visualsTab.arows_txt_up_or_daun_offset, ui.get(menu.visualsTab.arows_txt) and ui.get(menu.visualsTab.arows_txt_up_or_daun) ~= "-" and isVisualsTab)

    ui.set_visible(menu.visualsTab.custom_color, ui.get(menu.visualsTab.custom_scope) and isVisualsTab)
    ui.set_visible(menu.visualsTab.custom_initial_pos, ui.get(menu.visualsTab.custom_scope) and isVisualsTab)
    ui.set_visible(menu.visualsTab.custom_offset, ui.get(menu.visualsTab.custom_scope) and isVisualsTab)

    ui.set(menu.visualsTab.grenade_radius, false)
    ui.set_enabled(menu.visualsTab.grenade_radius, false)

    ui.set_visible(menu.miscTab.aim_tab, ui.get(menu.miscTab.aim_tools_enable) and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_baim_mode, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 1 and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_baim_trigers, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 1 and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_baim_hp, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 1 and func.includes(ui.get(menu.miscTab.aim_tools_baim_trigers), "Enemy HP < X") and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_safe_trigers, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 1 and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_safe_hp, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 1 and func.includes(ui.get(menu.miscTab.aim_tools_safe_trigers), "Enemy HP < X") and isMiscTab)

    ui.set_visible(menu.miscTab.aim_tools_hitchance_warning, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 2 and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_hitchance, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 2 and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_hc_land, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 2 and ui.get(menu.miscTab.aim_tools_hitchance) and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_hc_air, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 2 and ui.get(menu.miscTab.aim_tools_hitchance) and isMiscTab)

    ui.set_enabled(menu.miscTab.aim_tools_silent, false)
    ui.set_visible(menu.miscTab.aim_tools_silent, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 3 and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_silent_out, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 3 and ui.get(menu.miscTab.aim_tools_silent) and isMiscTab)

    ui.set_visible(menu.miscTab.aim_tools_delay_shot, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tab) == 4 and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_delay_states, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tools_delay_shot) and ui.get(menu.miscTab.aim_tab) == 4 and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_delay_land, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tools_delay_shot) and ui.get(menu.miscTab.aim_tab) == 4 and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_delay_hp, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tools_delay_shot) and ui.get(menu.miscTab.aim_tab) == 4 and isMiscTab)
    ui.set_visible(menu.miscTab.aim_tools_delay_ind, ui.get(menu.miscTab.aim_tools_enable) and ui.get(menu.miscTab.aim_tools_delay_shot) and ui.get(menu.miscTab.aim_tab) == 4 and isMiscTab)

    ui.set(lableb321, text_fade_animation(3, menu_r,menu_g,menu_b, 255, "anoflow ~ " .. script_build))
    ui.set(menu.infoTab.label3, " Your build is:" .. text_fade_animation(3, menu_r,menu_g,menu_b, 255, script_build))
    ui.set(menu.infoTab.label1, " Welcome back " .. text_fade_animation(3, menu_r,menu_g,menu_b, 255, nick_name) .. "")
    for i, feature in pairs(menu.configTab) do
		ui.set_visible(feature, isCFGTab and isEnabled)
        ui.set_visible(menu.configTab.name, false)
	end

    for i, feature in pairs(menu.infoTab) do
        ui.set_visible(feature, isINFOTab and isEnabled)
    end

    for i, feature in pairs(menu.extras) do
        ui.set_visible(feature, false)
    end

    if not isEnabled and not saved then
        func.resetAATab()
        ui.set(refs.fsBodyYaw, isEnabled)
        ui.set(refs.enabled, isEnabled)
        saved = true
    elseif isEnabled and saved then
        ui.set(refs.fsBodyYaw, not isEnabled)
        ui.set(refs.enabled, isEnabled)
        saved = false
    end
    func.setAATab(not isEnabled)
end)


local anoflow = {}

anoflow.config_data = {}
anoflow.config_data.cfg_data = {
    anti_aim = {
        -- 1
        aaBuilder[1].enableState;
        aaBuilder[1].stateDisablers;
        aaBuilder[1].yaw;
        aaBuilder[1].yawStatic;
        aaBuilder[1].yawLeft;
        aaBuilder[1].yawRight;
        aaBuilder[1].yawJitter;
        aaBuilder[1].wayFirst;
        aaBuilder[1].waySecond;
        aaBuilder[1].wayThird;
        aaBuilder[1].yawJitterStatic;
        aaBuilder[1].sway_speed;
        aaBuilder[1].bodyYaw;
        aaBuilder[1].bodyYawStatic;
        aaBuilder[1].delayed_body;
        aaBuilder[1].randomization;
        aaBuilder[1].force_defensive;
        aaBuilder[1].defensive_mode;
        aaBuilder[1].defensiveAntiAim;
        aaBuilder[1].def_pitch;
        aaBuilder[1].def_pitchSlider;
        aaBuilder[1].def_pitch_s1;
        aaBuilder[1].def_pitch_s2;
        aaBuilder[1].def_slow_gen;
        aaBuilder[1].def_dyn_speed;
        aaBuilder[1].def_jit_delay;
        aaBuilder[1].def_3_1;
        aaBuilder[1].def_3_2;
        aaBuilder[1].def_3_3;
        aaBuilder[1].def_yawMode;
        aaBuilder[1].def_yaw_spin_gs_mode;
        aaBuilder[1].def_yawStatic;
        aaBuilder[1].def_yaw_spin_range;
        aaBuilder[1].def_yaw_spin_speed;
        aaBuilder[1].def_yaw_spin_tick;
        aaBuilder[1].def_yaw_left;
        aaBuilder[1].def_yaw_right;
        aaBuilder[1].def_yaw_switch_delay;
        aaBuilder[1].def_yaw_exploit_speed;
        aaBuilder[1].def_slow_gena;
        aaBuilder[1].def_way_1;
        aaBuilder[1].def_way_2;
        aaBuilder[1].def_way_3;
        aaBuilder[1].bidy;
        aaBuilder[1].label_anti;
        aaBuilder[1].antibrute_enable;
        aaBuilder[1].antibrute_aa;
        aaBuilder[1].antibrute_yaw;
        aaBuilder[1].antibrute_mod;
        aaBuilder[1].antibrute_mod_range;
        aaBuilder[1].antibrute_body;
        aaBuilder[1].antibrute_body_range;

        -- 2
        aaBuilder[2].enableState;
        aaBuilder[2].stateDisablers;
        aaBuilder[2].yaw;
        aaBuilder[2].yawStatic;
        aaBuilder[2].yawLeft;
        aaBuilder[2].yawRight;
        aaBuilder[2].yawJitter;
        aaBuilder[2].wayFirst;
        aaBuilder[2].waySecond;
        aaBuilder[2].wayThird;
        aaBuilder[2].yawJitterStatic;
        aaBuilder[2].sway_speed;
        aaBuilder[2].bodyYaw;
        aaBuilder[2].bodyYawStatic;
        aaBuilder[2].delayed_body;
        aaBuilder[2].randomization;
        aaBuilder[2].force_defensive;
        aaBuilder[2].defensive_mode;
        aaBuilder[2].defensiveAntiAim;
        aaBuilder[2].def_pitch;
        aaBuilder[2].def_pitchSlider;
        aaBuilder[2].def_pitch_s1;
        aaBuilder[2].def_pitch_s2;
        aaBuilder[2].def_slow_gen;
        aaBuilder[2].def_dyn_speed;
        aaBuilder[2].def_jit_delay;
        aaBuilder[2].def_3_1;
        aaBuilder[2].def_3_2;
        aaBuilder[2].def_3_3;
        aaBuilder[2].def_yawMode;
        aaBuilder[2].def_yaw_spin_gs_mode;
        aaBuilder[2].def_yawStatic;
        aaBuilder[2].def_yaw_spin_range;
        aaBuilder[2].def_yaw_spin_speed;
        aaBuilder[2].def_yaw_spin_tick;
        aaBuilder[2].def_yaw_left;
        aaBuilder[2].def_yaw_right;
        aaBuilder[2].def_yaw_switch_delay;
        aaBuilder[2].def_yaw_exploit_speed;
        aaBuilder[2].def_slow_gena;
        aaBuilder[2].def_way_1;
        aaBuilder[2].def_way_2;
        aaBuilder[2].def_way_3;
        aaBuilder[2].bidy;
        aaBuilder[2].label_anti;
        aaBuilder[2].antibrute_enable;
        aaBuilder[2].antibrute_aa;
        aaBuilder[2].antibrute_yaw;
        aaBuilder[2].antibrute_mod;
        aaBuilder[2].antibrute_mod_range;
        aaBuilder[2].antibrute_body;
        aaBuilder[2].antibrute_body_range;

        --3
        aaBuilder[3].enableState;
        aaBuilder[3].stateDisablers;
        aaBuilder[3].yaw;
        aaBuilder[3].yawStatic;
        aaBuilder[3].yawLeft;
        aaBuilder[3].yawRight;
        aaBuilder[3].yawJitter;
        aaBuilder[3].wayFirst;
        aaBuilder[3].waySecond;
        aaBuilder[3].wayThird;
        aaBuilder[3].yawJitterStatic;
        aaBuilder[3].sway_speed;
        aaBuilder[3].bodyYaw;
        aaBuilder[3].bodyYawStatic;
        aaBuilder[3].delayed_body;
        aaBuilder[3].randomization;
        aaBuilder[3].force_defensive;
        aaBuilder[3].defensive_mode;
        aaBuilder[3].defensiveAntiAim;
        aaBuilder[3].def_pitch;
        aaBuilder[3].def_pitchSlider;
        aaBuilder[3].def_pitch_s1;
        aaBuilder[3].def_pitch_s2;
        aaBuilder[3].def_slow_gen;
        aaBuilder[3].def_dyn_speed;
        aaBuilder[3].def_jit_delay;
        aaBuilder[3].def_3_1;
        aaBuilder[3].def_3_2;
        aaBuilder[3].def_3_3;
        aaBuilder[3].def_yawMode;
        aaBuilder[3].def_yaw_spin_gs_mode;
        aaBuilder[3].def_yawStatic;
        aaBuilder[3].def_yaw_spin_range;
        aaBuilder[3].def_yaw_spin_speed;
        aaBuilder[3].def_yaw_spin_tick;
        aaBuilder[3].def_yaw_left;
        aaBuilder[3].def_yaw_right;
        aaBuilder[3].def_yaw_switch_delay;
        aaBuilder[3].def_yaw_exploit_speed;
        aaBuilder[3].def_slow_gena;
        aaBuilder[3].def_way_1;
        aaBuilder[3].def_way_2;
        aaBuilder[3].def_way_3;
        aaBuilder[3].bidy;
        aaBuilder[3].label_anti;
        aaBuilder[3].antibrute_enable;
        aaBuilder[3].antibrute_aa;
        aaBuilder[3].antibrute_yaw;
        aaBuilder[3].antibrute_mod;
        aaBuilder[3].antibrute_mod_range;
        aaBuilder[3].antibrute_body;
        aaBuilder[3].antibrute_body_range;

        --4
        aaBuilder[4].enableState;
        aaBuilder[4].stateDisablers;
        aaBuilder[4].yaw;
        aaBuilder[4].yawStatic;
        aaBuilder[4].yawLeft;
        aaBuilder[4].yawRight;
        aaBuilder[4].yawJitter;
        aaBuilder[4].wayFirst;
        aaBuilder[4].waySecond;
        aaBuilder[4].wayThird;
        aaBuilder[4].yawJitterStatic;
        aaBuilder[4].sway_speed;
        aaBuilder[4].bodyYaw;
        aaBuilder[4].bodyYawStatic;
        aaBuilder[4].delayed_body;
        aaBuilder[4].randomization;
        aaBuilder[4].force_defensive;
        aaBuilder[4].defensive_mode;
        aaBuilder[4].defensiveAntiAim;
        aaBuilder[4].def_pitch;
        aaBuilder[4].def_pitchSlider;
        aaBuilder[4].def_pitch_s1;
        aaBuilder[4].def_pitch_s2;
        aaBuilder[4].def_slow_gen;
        aaBuilder[4].def_dyn_speed;
        aaBuilder[4].def_jit_delay;
        aaBuilder[4].def_3_1;
        aaBuilder[4].def_3_2;
        aaBuilder[4].def_3_3;
        aaBuilder[4].def_yawMode;
        aaBuilder[4].def_yaw_spin_gs_mode;
        aaBuilder[4].def_yawStatic;
        aaBuilder[4].def_yaw_spin_range;
        aaBuilder[4].def_yaw_spin_speed;
        aaBuilder[4].def_yaw_spin_tick;
        aaBuilder[4].def_yaw_left;
        aaBuilder[4].def_yaw_right;
        aaBuilder[4].def_yaw_switch_delay;
        aaBuilder[4].def_yaw_exploit_speed;
        aaBuilder[4].def_slow_gena;
        aaBuilder[4].def_way_1;
        aaBuilder[4].def_way_2;
        aaBuilder[4].def_way_3;
        aaBuilder[4].bidy;
        aaBuilder[4].label_anti;
        aaBuilder[4].antibrute_enable;
        aaBuilder[4].antibrute_aa;
        aaBuilder[4].antibrute_yaw;
        aaBuilder[4].antibrute_mod;
        aaBuilder[4].antibrute_mod_range;
        aaBuilder[4].antibrute_body;
        aaBuilder[4].antibrute_body_range;

        --5
        aaBuilder[5].enableState;
        aaBuilder[5].stateDisablers;
        aaBuilder[5].yaw;
        aaBuilder[5].yawStatic;
        aaBuilder[5].yawLeft;
        aaBuilder[5].yawRight;
        aaBuilder[5].yawJitter;
        aaBuilder[5].wayFirst;
        aaBuilder[5].waySecond;
        aaBuilder[5].wayThird;
        aaBuilder[5].yawJitterStatic;
        aaBuilder[5].sway_speed;
        aaBuilder[5].bodyYaw;
        aaBuilder[5].bodyYawStatic;
        aaBuilder[5].delayed_body;
        aaBuilder[5].randomization;
        aaBuilder[5].force_defensive;
        aaBuilder[5].defensive_mode;
        aaBuilder[5].defensiveAntiAim;
        aaBuilder[5].def_pitch;
        aaBuilder[5].def_pitchSlider;
        aaBuilder[5].def_pitch_s1;
        aaBuilder[5].def_pitch_s2;
        aaBuilder[5].def_slow_gen;
        aaBuilder[5].def_dyn_speed;
        aaBuilder[5].def_jit_delay;
        aaBuilder[5].def_3_1;
        aaBuilder[5].def_3_2;
        aaBuilder[5].def_3_3;
        aaBuilder[5].def_yawMode;
        aaBuilder[5].def_yaw_spin_gs_mode;
        aaBuilder[5].def_yawStatic;
        aaBuilder[5].def_yaw_spin_range;
        aaBuilder[5].def_yaw_spin_speed;
        aaBuilder[5].def_yaw_spin_tick;
        aaBuilder[5].def_yaw_left;
        aaBuilder[5].def_yaw_right;
        aaBuilder[5].def_yaw_switch_delay;
        aaBuilder[5].def_yaw_exploit_speed;
        aaBuilder[5].def_slow_gena;
        aaBuilder[5].def_way_1;
        aaBuilder[5].def_way_2;
        aaBuilder[5].def_way_3;
        aaBuilder[5].bidy;
        aaBuilder[5].label_anti;
        aaBuilder[5].antibrute_enable;
        aaBuilder[5].antibrute_aa;
        aaBuilder[5].antibrute_yaw;
        aaBuilder[5].antibrute_mod;
        aaBuilder[5].antibrute_mod_range;
        aaBuilder[5].antibrute_body;
        aaBuilder[5].antibrute_body_range;

        --6
        aaBuilder[6].enableState;
        aaBuilder[6].stateDisablers;
        aaBuilder[6].yaw;
        aaBuilder[6].yawStatic;
        aaBuilder[6].yawLeft;
        aaBuilder[6].yawRight;
        aaBuilder[6].yawJitter;
        aaBuilder[6].wayFirst;
        aaBuilder[6].waySecond;
        aaBuilder[6].wayThird;
        aaBuilder[6].yawJitterStatic;
        aaBuilder[6].sway_speed;
        aaBuilder[6].bodyYaw;
        aaBuilder[6].bodyYawStatic;
        aaBuilder[6].delayed_body;
        aaBuilder[6].randomization;
        aaBuilder[6].force_defensive;
        aaBuilder[6].defensive_mode;
        aaBuilder[6].defensiveAntiAim;
        aaBuilder[6].def_pitch;
        aaBuilder[6].def_pitchSlider;
        aaBuilder[6].def_pitch_s1;
        aaBuilder[6].def_pitch_s2;
        aaBuilder[6].def_slow_gen;
        aaBuilder[6].def_dyn_speed;
        aaBuilder[6].def_jit_delay;
        aaBuilder[6].def_3_1;
        aaBuilder[6].def_3_2;
        aaBuilder[6].def_3_3;
        aaBuilder[6].def_yawMode;
        aaBuilder[6].def_yaw_spin_gs_mode;
        aaBuilder[6].def_yawStatic;
        aaBuilder[6].def_yaw_spin_range;
        aaBuilder[6].def_yaw_spin_speed;
        aaBuilder[6].def_yaw_spin_tick;
        aaBuilder[6].def_yaw_left;
        aaBuilder[6].def_yaw_right;
        aaBuilder[6].def_yaw_switch_delay;
        aaBuilder[6].def_yaw_exploit_speed;
        aaBuilder[6].def_slow_gena;
        aaBuilder[6].def_way_1;
        aaBuilder[6].def_way_2;
        aaBuilder[6].def_way_3;
        aaBuilder[6].bidy;
        aaBuilder[6].label_anti;
        aaBuilder[6].antibrute_enable;
        aaBuilder[6].antibrute_aa;
        aaBuilder[6].antibrute_yaw;
        aaBuilder[6].antibrute_mod;
        aaBuilder[6].antibrute_mod_range;
        aaBuilder[6].antibrute_body;
        aaBuilder[6].antibrute_body_range;

        --7
        aaBuilder[7].enableState;
        aaBuilder[7].stateDisablers;
        aaBuilder[7].yaw;
        aaBuilder[7].yawStatic;
        aaBuilder[7].yawLeft;
        aaBuilder[7].yawRight;
        aaBuilder[7].yawJitter;
        aaBuilder[7].wayFirst;
        aaBuilder[7].waySecond;
        aaBuilder[7].wayThird;
        aaBuilder[7].yawJitterStatic;
        aaBuilder[7].sway_speed;
        aaBuilder[7].bodyYaw;
        aaBuilder[7].bodyYawStatic;
        aaBuilder[7].delayed_body;
        aaBuilder[7].randomization;
        aaBuilder[7].force_defensive;
        aaBuilder[7].defensive_mode;
        aaBuilder[7].defensiveAntiAim;
        aaBuilder[7].def_pitch;
        aaBuilder[7].def_pitchSlider;
        aaBuilder[7].def_pitch_s1;
        aaBuilder[7].def_pitch_s2;
        aaBuilder[7].def_slow_gen;
        aaBuilder[7].def_dyn_speed;
        aaBuilder[7].def_jit_delay;
        aaBuilder[7].def_3_1;
        aaBuilder[7].def_3_2;
        aaBuilder[7].def_3_3;
        aaBuilder[7].def_yawMode;
        aaBuilder[7].def_yaw_spin_gs_mode;
        aaBuilder[7].def_yawStatic;
        aaBuilder[7].def_yaw_spin_range;
        aaBuilder[7].def_yaw_spin_speed;
        aaBuilder[7].def_yaw_spin_tick;
        aaBuilder[7].def_yaw_left;
        aaBuilder[7].def_yaw_right;
        aaBuilder[7].def_yaw_switch_delay;
        aaBuilder[7].def_yaw_exploit_speed;
        aaBuilder[7].def_slow_gena;
        aaBuilder[7].def_way_1;
        aaBuilder[7].def_way_2;
        aaBuilder[7].def_way_3;
        aaBuilder[7].bidy;
        aaBuilder[7].label_anti;
        aaBuilder[7].antibrute_enable;
        aaBuilder[7].antibrute_aa;
        aaBuilder[7].antibrute_yaw;
        aaBuilder[7].antibrute_mod;
        aaBuilder[7].antibrute_mod_range;
        aaBuilder[7].antibrute_body;
        aaBuilder[7].antibrute_body_range;

        --8
        aaBuilder[8].enableState;
        aaBuilder[8].stateDisablers;
        aaBuilder[8].yaw;
        aaBuilder[8].yawStatic;
        aaBuilder[8].yawLeft;
        aaBuilder[8].yawRight;
        aaBuilder[8].yawJitter;
        aaBuilder[8].wayFirst;
        aaBuilder[8].waySecond;
        aaBuilder[8].wayThird;
        aaBuilder[8].yawJitterStatic;
        aaBuilder[8].sway_speed;
        aaBuilder[8].bodyYaw;
        aaBuilder[8].bodyYawStatic;
        aaBuilder[8].delayed_body;
        aaBuilder[8].randomization;
        aaBuilder[8].force_defensive;
        aaBuilder[8].defensive_mode;
        aaBuilder[8].defensiveAntiAim;
        aaBuilder[8].def_pitch;
        aaBuilder[8].def_pitchSlider;
        aaBuilder[8].def_pitch_s1;
        aaBuilder[8].def_pitch_s2;
        aaBuilder[8].def_slow_gen;
        aaBuilder[8].def_dyn_speed;
        aaBuilder[8].def_jit_delay;
        aaBuilder[8].def_3_1;
        aaBuilder[8].def_3_2;
        aaBuilder[8].def_3_3;
        aaBuilder[8].def_yawMode;
        aaBuilder[8].def_yaw_spin_gs_mode;
        aaBuilder[8].def_yawStatic;
        aaBuilder[8].def_yaw_spin_range;
        aaBuilder[8].def_yaw_spin_speed;
        aaBuilder[8].def_yaw_spin_tick;
        aaBuilder[8].def_yaw_left;
        aaBuilder[8].def_yaw_right;
        aaBuilder[8].def_yaw_switch_delay;
        aaBuilder[8].def_yaw_exploit_speed;
        aaBuilder[8].def_slow_gena;
        aaBuilder[8].def_way_1;
        aaBuilder[8].def_way_2;
        aaBuilder[8].def_way_3;
        aaBuilder[8].bidy;
        aaBuilder[8].label_anti;
        aaBuilder[8].antibrute_enable;
        aaBuilder[8].antibrute_aa;
        aaBuilder[8].antibrute_yaw;
        aaBuilder[8].antibrute_mod;
        aaBuilder[8].antibrute_mod_range;
        aaBuilder[8].antibrute_body;
        aaBuilder[8].antibrute_body_range;

        --9
        aaBuilder[9].enableState;
        aaBuilder[9].stateDisablers;
        aaBuilder[9].yaw;
        aaBuilder[9].yawStatic;
        aaBuilder[9].yawLeft;
        aaBuilder[9].yawRight;
        aaBuilder[9].yawJitter;
        aaBuilder[9].wayFirst;
        aaBuilder[9].waySecond;
        aaBuilder[9].wayThird;
        aaBuilder[9].yawJitterStatic;
        aaBuilder[9].sway_speed;
        aaBuilder[9].bodyYaw;
        aaBuilder[9].bodyYawStatic;
        aaBuilder[9].delayed_body;
        aaBuilder[9].randomization;
        aaBuilder[9].force_defensive;
        aaBuilder[9].defensive_mode;
        aaBuilder[9].defensiveAntiAim;
        aaBuilder[9].def_pitch;
        aaBuilder[9].def_pitchSlider;
        aaBuilder[9].def_pitch_s1;
        aaBuilder[9].def_pitch_s2;
        aaBuilder[9].def_slow_gen;
        aaBuilder[9].def_dyn_speed;
        aaBuilder[9].def_jit_delay;
        aaBuilder[9].def_3_1;
        aaBuilder[9].def_3_2;
        aaBuilder[9].def_3_3;
        aaBuilder[9].def_yawMode;
        aaBuilder[9].def_yaw_spin_gs_mode;
        aaBuilder[9].def_yawStatic;
        aaBuilder[9].def_yaw_spin_range;
        aaBuilder[9].def_yaw_spin_speed;
        aaBuilder[9].def_yaw_spin_tick;
        aaBuilder[9].def_yaw_left;
        aaBuilder[9].def_yaw_right;
        aaBuilder[9].def_yaw_switch_delay;
        aaBuilder[9].def_yaw_exploit_speed;
        aaBuilder[9].def_slow_gena;
        aaBuilder[9].def_way_1;
        aaBuilder[9].def_way_2;
        aaBuilder[9].def_way_3;
        aaBuilder[9].bidy;
        aaBuilder[9].label_anti;
        aaBuilder[9].antibrute_enable;
        aaBuilder[9].antibrute_aa;
        aaBuilder[9].antibrute_yaw;
        aaBuilder[9].antibrute_mod;
        aaBuilder[9].antibrute_mod_range;
        aaBuilder[9].antibrute_body;
        aaBuilder[9].antibrute_body_range;

        --10
        aaBuilder[10].enableState;
        aaBuilder[10].stateDisablers;
        aaBuilder[10].yaw;
        aaBuilder[10].yawStatic;
        aaBuilder[10].yawLeft;
        aaBuilder[10].yawRight;
        aaBuilder[10].yawJitter;
        aaBuilder[10].wayFirst;
        aaBuilder[10].waySecond;
        aaBuilder[10].wayThird;
        aaBuilder[10].yawJitterStatic;
        aaBuilder[10].sway_speed;
        aaBuilder[10].bodyYaw;
        aaBuilder[10].bodyYawStatic;
        aaBuilder[10].delayed_body;
        aaBuilder[10].randomization;
        aaBuilder[10].force_defensive;
        aaBuilder[10].defensive_mode;
        aaBuilder[10].defensiveAntiAim;
        aaBuilder[10].def_pitch;
        aaBuilder[10].def_pitchSlider;
        aaBuilder[10].def_pitch_s1;
        aaBuilder[10].def_pitch_s2;
        aaBuilder[10].def_slow_gen;
        aaBuilder[10].def_dyn_speed;
        aaBuilder[10].def_jit_delay;
        aaBuilder[10].def_3_1;
        aaBuilder[10].def_3_2;
        aaBuilder[10].def_3_3;
        aaBuilder[10].def_yawMode;
        aaBuilder[10].def_yaw_spin_gs_mode;
        aaBuilder[10].def_yawStatic;
        aaBuilder[10].def_yaw_spin_range;
        aaBuilder[10].def_yaw_spin_speed;
        aaBuilder[10].def_yaw_spin_tick;
        aaBuilder[10].def_yaw_left;
        aaBuilder[10].def_yaw_right;
        aaBuilder[10].def_yaw_switch_delay;
        aaBuilder[10].def_yaw_exploit_speed;
        aaBuilder[10].def_slow_gena;
        aaBuilder[10].def_way_1;
        aaBuilder[10].def_way_2;
        aaBuilder[10].def_way_3;
        aaBuilder[10].bidy;
        aaBuilder[10].label_anti;
        aaBuilder[10].antibrute_enable;
        aaBuilder[10].antibrute_aa;
        aaBuilder[10].antibrute_yaw;
        aaBuilder[10].antibrute_mod;
        aaBuilder[10].antibrute_mod_range;
        aaBuilder[10].antibrute_body;
        aaBuilder[10].antibrute_body_range
    },
    aa_other = {
        menu.aaTab.spin_exploit;
        menu.aaTab.anti_knife;
        menu.aaTab.avoid_dist;
        menu.aaTab.freestandHotkey;
        menu.aaTab.legitAAHotkey;
        menu.aaTab.m_left;
        menu.aaTab.m_right;
        menu.aaTab.static_m;
        menu.aaTab.edge_on_fd;
        menu.aaTab.safe_head;
        menu.aaTab.safe_flick;
        menu.aaTab.safe_flick_mode;
        menu.aaTab.safe_flick_pitch;
        menu.aaTab.safe_flick_pitch_value
    },
    visuals = {
        menu.visualsTab.cros_ind;
        menu.visualsTab.min_ind;
        menu.visualsTab.min_ind_mode;
        menu.visualsTab.fpsboost;
        menu.visualsTab.bul_trace;
        menu.visualsTab.bul_color;
        menu.visualsTab.bul_dur;
        menu.visualsTab.zoom_animate;
        menu.visualsTab.zoom_speed;
        menu.visualsTab.zoom_1;
        menu.visualsTab.zoom_2;
        menu.visualsTab.viewmodel_en;
        menu.visualsTab.viewmodel_x;
        menu.visualsTab.viewmodel_y;
        menu.visualsTab.viewmodel_z;
        menu.visualsTab.custom_scope;
        menu.visualsTab.custom_color;
        menu.visualsTab.custom_initial_pos;
        menu.visualsTab.custom_offset;
        menu.visualsTab.weapon_scope;

        menu.visualsTab.zeus_warning;
        menu.visualsTab.ammo_low;
        menu.visualsTab.third_;
        menu.visualsTab.third_dis;
        menu.visualsTab.min_text;
        menu.visualsTab.asp;
        menu.visualsTab.asp_v;
        menu.visualsTab.watermarkClr;
        menu.visualsTab.debug_panel;
        menu.visualsTab.gs_ind;
        menu.visualsTab.arows_txt;
        menu.visualsTab.arows_txt_color;
        menu.visualsTab.arows_txt_offset;
        menu.visualsTab.arows_txt_up_or_daun;
        menu.visualsTab.arows_txt_up_or_daun_offset;

        menu.visualsTab.on_screen_logs;
        menu.visualsTab.slow_down;
        menu.visualsTab.on_screen_v;
        menu.visualsTab.widgets_slow;
        menu.visualsTab.widgets_slow_length;
        menu.visualsTab.widgets_slow_width;
        menu.visualsTab.a_pitch;
        menu.visualsTab.a_body;
        menu.visualsTab.a_legacy;
        menu.visualsTab.ap_move;
        menu.visualsTab.ap_air;
    },
    misc = {
        menu.miscTab.auto_tp;
        menu.miscTab.auto_tpHotkey;
        menu.miscTab.auto_tp_indicator_disable;
        menu.miscTab.resolver;
        menu.miscTab.rs_mode;
        menu.miscTab.fast_ladder;
        menu.miscTab.predict_enable;
        menu.miscTab.predict_states;
        menu.miscTab.predict_ind_mode;
        menu.miscTab.backtrack_exploit;
        menu.miscTab.backtrack_value;
        menu.miscTab.jump_scout;
        menu.miscTab.charge_dt;
        menu.miscTab.ai_peek;
        menu.miscTab.ai_peek_key;
        menu.miscTab.air_stop;
        menu.miscTab.air_stop_k;
        menu.miscTab.aim_tools_enable;
        menu.miscTab.aim_tools_baim_mode;
        menu.miscTab.aim_tools_baim_trigers;
        menu.miscTab.aim_tools_baim_hp;
        menu.miscTab.aim_tools_safe_trigers;
        menu.miscTab.aim_tools_safe_hp;
        menu.miscTab.filtercons;
        menu.miscTab.clanTag;
        menu.miscTab.clantag_mode;
        menu.miscTab.kill_say;
        menu.miscTab.console_logs;
        menu.miscTab.console_logs_custom_vibor;
        menu.miscTab.console_logs_resolver;
        menu.miscTab.console_logs_custom;
        menu.miscTab.drop_gr;
        menu.miscTab.drop_key;
        menu.miscTab.drop_multi;
        menu.miscTab.daun_baim;
        menu.miscTab.daun_baim_key;
        menu.miscTab.bomb_fix;
    }
}


--#region configs

ui.set_callback(menu.configTab.export, function ()
    local Code = {{}, {}, {}, {}}; 

    for _, main in pairs(anoflow.config_data.cfg_data.anti_aim) do
        if ui.get(main) ~= nil then
            table.insert(Code[1], tostring(ui.get(main)))
        end
    end

    for _, main in pairs(anoflow.config_data.cfg_data.aa_other) do
        if ui.get(main) ~= nil then
            table.insert(Code[2], tostring(ui.get(main)))
        end
    end

    for _, main in pairs(anoflow.config_data.cfg_data.visuals) do
        if ui.get(main) ~= nil then
            table.insert(Code[3], tostring(ui.get(main)))
        end
    end

    for _, main in pairs(anoflow.config_data.cfg_data.misc) do
        if ui.get(main) ~= nil then
            table.insert(Code[4], tostring(ui.get(main)))
        end
    end

    clipboard.set(base64.encode(json.stringify(Code)))
end);

ui.set_callback(menu.configTab.import, function ()
    local protected = function() 
        for k, v in pairs(json.parse(base64.decode(clipboard.get()))) do
            
            k = ({[1] = "anti_aim", [2] = "aa_other", [3] = "visuals", [4] = "misc"})[k]

            for k2, v2 in pairs(v) do
                if (k == "anti_aim" or k == "aa_other" or k == "visuals" or k == "misc") then
                    if v2 == "true" then
                        ui.set(anoflow.config_data.cfg_data[k][k2], true)
                    elseif v2 == "false" then
                        ui.set(anoflow.config_data.cfg_data[k][k2], false)
                    else
                        ui.set(anoflow.config_data.cfg_data[k][k2], v2)
                    end
                end
            end
        end
    end
    local status, message = pcall(protected)
    if not status then
        error("error cfg")
        return
    end
end)



function getConfig(name)
    local database = database.read(lua.database.configs) or {}

    
    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    
    for i, v in pairs(presets) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    return nil
end
function saveConfig(menu, name)
    local db = database.read(lua.database.configs) or {}
    local config = {}

    
    if name:match("[^%w%s%p]") ~= nil then
        return
    end

    
    for category, data in pairs(anoflow.config_data.cfg_data) do
        config[category] = {}
        for key, element in pairs(data) do
            config[category][key] = ui.get(element)
        end
    end

    
    local cfg = getConfig(name)

    if not cfg then
        
        table.insert(db, { name = name, config = config })
    else
        db[cfg.index].config = config
    end

    database.write(lua.database.configs, db)
end

function deleteConfig(name)
    local db = database.read(lua.database.configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            table.remove(db, i)
            break
        end
    end

    for i, v in pairs(presets) do
        if v.name == name then
            return false
        end
    end

    database.write(lua.database.configs, db)
    return true
end

function getConfigList()
    local database = database.read(lua.database.configs) or {}
    local config = {}

    for i, v in pairs(presets) do
        table.insert(config, v.name)
    end

    for i, v in pairs(database) do
        table.insert(config, v.name)
    end

    return config
end

function typeFromString(input)
    if type(input) ~= "string" then return input end

    local value = input:lower()

    if value == "true" then
        return true
    elseif value == "false" then
        return false
    elseif tonumber(value) ~= nil then
        return tonumber(value)
    else
        return tostring(input)
    end
end
function loadSettings(config)
    for category, data in pairs(config) do
        for key, value in pairs(data) do
            local element = anoflow.config_data.cfg_data[category][key]
            if element then
                ui.set(element, value)
            else
                print("[DEBUG] Element not found: " .. category .. "." .. key)
            end
        end
    end
end
function importSettings()
    local clipboard_data = clipboard.get()
    if clipboard_data then
        local config = json.parse(clipboard_data)
        loadSettings(config)
    end
end
function exportSettings(name)
    local config = {}

    for category, data in pairs(anoflow.config_data.cfg_data) do
        config[category] = {}
        for key, element in pairs(data) do
            config[category][key] = ui.get(element)
        end
    end

    clipboard.set(json.stringify(config))
end
function loadConfig(name)
    local config = getConfig(name)
    if config then
        loadSettings(config.config)
    else
        error("Config not found: " .. name)
    end
end

--#endregion configs


vec_add = function(a, b) return { a[1] + b[1], a[2] + b[2], a[3] + b[3] } end

function extrapolate_position(ent, origin, ticks)
    local tickinterval = globals.tickinterval()
    local velocity = { entity.get_prop(ent, 'm_vecVelocity') }
    local gravity = cvar.sv_gravity:get_float() * tickinterval

    local predicted_pos = origin

    for i = 1, ticks do
        predicted_pos = {
            predicted_pos[1] + velocity[1] * tickinterval,
            predicted_pos[2] + velocity[2] * tickinterval,
            predicted_pos[3] + (velocity[3] - gravity) * tickinterval
        }
    end

    return predicted_pos
end

function getspeed(player_index)
    return vector(entity.get_prop(player_index, "m_vecVelocity")):length()
end

function draw_predicted_positions()
    local local_player = entity.get_local_player()

    if not local_player or not entity.is_alive(local_player) then
        return
    end
    local color_a, color_b, color_c, color_alpha = ui.get(menu.visualsTab._PREDICT_COLOR)

    for player = 1, globals.maxplayers() do
        if player ~= local_player and entity.is_alive(player) and entity.is_enemy(player) then
            if not (math.floor(getspeed(player)) > 200) then return end
            local origin = { entity.get_origin(player) }
            local velocity = { entity.get_prop(player, 'm_vecVelocity') }

            if origin[1] and velocity[1] then
                local predicted_pos = extrapolate_position(player, origin, 10)

                local mins = { entity.get_prop(player, 'm_vecMins') }
                local maxs = { entity.get_prop(player, 'm_vecMaxs') }

                local min = vec_add(mins, predicted_pos)
                local max = vec_add(maxs, predicted_pos)

                local points = {
                    {min[1], min[2], min[3]}, {min[1], max[2], min[3]},
                    {max[1], max[2], min[3]}, {max[1], min[2], min[3]},
                    {min[1], min[2], max[3]}, {min[1], max[2], max[3]},
                    {max[1], max[2], max[3]}, {max[1], min[2], max[3]},
                }

                local edges = {
                    {1, 2}, {2, 3}, {3, 4}, {4, 1},
                    {5, 6}, {6, 7}, {7, 8}, {8, 5},
                    {1, 5}, {2, 6}, {3, 7}, {4, 8}
                }

                for _, edge in pairs(edges) do
                    local p1 = { renderer.world_to_screen(points[edge[1]][1], points[edge[1]][2], points[edge[1]][3]) }
                    local p2 = { renderer.world_to_screen(points[edge[2]][1], points[edge[2]][2], points[edge[2]][3]) }

                    if p1[1] and p2[1] then
                        renderer.line(p1[1], p1[2], p2[1], p2[2], color_a, color_b, color_c, color_alpha)
                    end
                end
            end
        end
    end
end



local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI


event_callback("round_prestart", function()
    if not ui.get(menu.miscTab.auto_buy) then
        return
    end
    local w = ui.get(menu.miscTab.auto_w)
    local p = ui.get(menu.miscTab.auto_p)
    
    if w == "Awp" then
        client.exec("buy awp")
    elseif w == "Scout" then
        client.exec("buy ssg08")
    elseif w == "ScarCT/ScarT" then
        client.exec("buy scar20")
    end

    if p == "Deagle" then
        client.exec("buy deagle")
    elseif p == "Seven/Tec" then
        client.exec("buy tec9")
    end

    if func.includes(ui.get(menu.miscTab.auto_g), "Molotov") then
        client.exec("buy molotov")
    end
    if func.includes(ui.get(menu.miscTab.auto_g), "Grenade") then
        client.exec("buy hegrenade")
    end
    if func.includes(ui.get(menu.miscTab.auto_g), "Smoke") then
        client.exec("buy smokegrenade")
    end
end)
client.delay_call(1, function()
    notifications.new(string.format('Welcome back ! ') .. nick_name, 255, 255, 255)
end)


client.delay_call(3, function()
    notifications.new(string.format('Your build is: \v') .. script_build .. " ", 255, 255, 255)
end)
local mx,my = client.screen_size()
local dbs = {
    defensive_x = database.read("def_indicator_x") or mx / 2, 
    defensive_y = database.read("def_indicator_y") or my / 2 - 100,
    slow_x = database.read("slow_indicator_x") or mx / 2, 
    slow_y = database.read("slow_indicator_y") or my / 2 - 200,
    is_dragging = false,
    defensive_menu = false,
    slow_menu = false,
    size = 0,
    should_drag = false,
    last_item = "Slow",
    not_last_item = "Slow",
}

func.in_air = (function(player)
    if player == nil then return end
    local flags = entity.get_prop(player, "m_fFlags")
    if flags == nil then return end
    if bit.band(flags, 1) == 0 then
        return true
    end
    return false
end)

function is_vulnerable()
    for _, v in ipairs(entity.get_players(true)) do
        local flags = (entity.get_esp_data(v)).flags

        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
            return true
        end
    end

    return false
end

function get_velocity(player)
    local x,y,z = entity.get_prop(player, "m_vecVelocity")
    if x == nil then return end
    return math.sqrt(x*x + y*y + z*z)
end


animate_text = function(time, string, r, g, b, a)
    local t_out, t_out_iter = { }, 1

    local l = string:len( ) - 1

    local r_add = (0 - r) * 0.5
    local g_add = (0 - g) * 0.5
    local b_add = (0 - b) * 0.5
    local a_add = (255 - a) * 0.5

    for i = 1, #string do
        local iter = (i - 1)/(#string - 1) + time
        t_out[t_out_iter] = "\a" .. func.RGBAtoHEX( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )

        t_out[t_out_iter + 1] = string:sub( i, i )

        t_out_iter = t_out_iter + 2
    end

    return t_out
end

glow_module = function(x, y, w, h, width, rounding, accent, accent_inner)
    local thickness = 1
    local Offset = 1
    local r, g, b, a = unpack(accent)
    if accent_inner then
        func.rec(x, y, w, h + 1, rounding, accent_inner)
    end
    for k = 0, width do
        if a * (k/width)^(1) > 5 then
            local accent = {r, g, b, a * (k/width)^(2)}
            func.rec_outline(x + (k - width - Offset)*thickness, y + (k - width - Offset) * thickness, w - (k - width - Offset)*thickness*2, h + 1 - (k - width - Offset)*thickness*2, rounding + thickness * (width - k + Offset), thickness, accent)
        end
    end
end

local last_update_time = globals.realtime()
local static_random_value = -50


function generate_slow_random(min, max, interval)
    local current_time = globals.realtime()

    if current_time - last_update_time >= interval then
        static_random_value = client.random_int(min * 1, max * 1)
        last_update_time = current_time
    end

    return static_random_value
end

local last_update_time2 = globals.realtime()
local static_random_value2 = 0

function generate_slow_random2(min, max, interval)
    local current_time = globals.realtime()

    if current_time - last_update_time2 >= interval then
        static_random_value2 = client.random_int(min * 1, max * 1)
        last_update_time2 = current_time
    end

    return static_random_value2
end

local last_update_time3 = globals.realtime()
local last_update_time4 = globals.realtime()
function value_to_0(value, interval)
    if last_update_time3 - last_update_time4 >= interval then
        value = 0
        last_update_time4 = last_update_time3
    end

    if value == 0 and last_update_time3 - last_update_time4 >= interval then
        last_update_time4 = last_update_time3
    elseif value ~= 0 and last_update_time3 - last_update_time4 >= interval then
        value = value
    end
end


local aa = {
	ignore = false,
	manualAA= 0,
	input = 0,
}


vars.last_press = 0
vars.aa_dir = 0
vars.pitch = 0

event_callback("player_connect_full", function() 
	aa.ignore = false
	aa.manualAA= 0
	aa.input = 0
    vars.last_press = 0
    vars.aa_dir = 0
end) 

vars.phrases = {
    '┊𝒮𝒾𝓂𝓅𝓁𝓎 𝓊𝓃𝓂𝒶𝓉𝒸𝒽𝑒𝒹 🌌 𝒜𝓃𝑜𝒻𝓁𝑜𝓌 𝐷𝑜𝓂𝒾𝓃𝒶𝓉𝒾𝑜𝓃',
    'ɴᴏᴛʜɪɴɢ ᴘᴇʀsᴏɴᴀʟ, ᴊᴜsᴛ ᴅᴀᴛᴀ ᴄᴏʟʟᴇᴄᴛɪᴏɴ ⚡',
    '❄💀 𝙉𝙤𝙘𝙩𝙪𝙧𝙣𝙖𝙡 𝙀𝙣𝙙𝙜𝙖𝙢𝙚 💀❄ 𝔸𝕟𝕠𝕗𝕝𝕠𝕨',
    '•.¸✹💢 𝒯𝐻𝐸 𝒜𝒩𝒪𝐹𝐿𝒪𝒲 𝒦𝐼𝒩𝒢 💢✹¸.•',
    '⛓️ ℝ𝔼ℂ𝕆𝔻𝔼𝔻 & ℝ𝔼𝕊𝕆𝕃𝕍𝔼𝔻 ⛓️ 𝔽𝕚𝕘𝕦𝕣𝕖 𝕚𝕥 𝕠𝕦𝕥 𝕟𝕖𝕩𝕥 𝕥𝕚𝕞𝕖',
    '「🔮 𝑼𝒏𝒔𝒕𝒐𝒑𝒑𝒂𝒃𝒍𝒆 𝒑𝒐𝒘𝒆𝒓 - 𝑨𝒏𝒐𝒇𝒍𝒐𝒘 🌌」',
    '⛧₲ⱤØɄ₦Đ 𝔷ɆⱤØ, ₮ⱧɆ ₲₳₥Ɇ ł₴ 𝕆VɆⱤ ⛧」',
    '✖️ 𝙏𝙝𝙞𝙨 𝙬𝙖𝙨𝙣𝙩 𝙡𝙪𝙘𝙠, 𝙞𝙩 𝙬𝙖𝙨 𝙥𝙧𝙚𝙙𝙞𝙘𝙩 ✖️',
    '「⛓️ 𝐔𝐍𝐁𝐑𝐄𝐀𝐊𝐀𝐁𝐋𝐄 ⛓️」',
    '「⛧ Resolved your anti-aim in milliseconds ⛧」',
    '「✨ Anoflow: rewriting the rules of engagement ✨」',
    
}

local userid_to_entindex, get_local_player, is_enemy, console_cmd = client.userid_to_entindex, entity.get_local_player, entity.is_enemy, client.exec

function on_player_death(e)
    if not ui.get(menu.miscTab.kill_say) then return end

    local victim_userid, attacker_userid = e.userid, e.attacker
    if victim_userid == nil or attacker_userid == nil then
        return
    end

    local victim_entindex = userid_to_entindex(victim_userid)
    local attacker_entindex = userid_to_entindex(attacker_userid)

    if attacker_entindex == get_local_player() and is_enemy(victim_entindex) and entity.is_alive(entity.get_local_player()) then
        client.delay_call(2, function() console_cmd("say ", vars.phrases[math.random(1, #vars.phrases)]) end)
    end
end
event_callback("player_death", on_player_death)


local delsw, a_bodydel, delaa, d_sw, bodydel, last_switch_time = false, false, false, false, false,  globals.curtime()



event_callback("run_command", function(cmd)
    vars.breaker.cmd = cmd.command_number
    if cmd.chokedcommands == 0 then
        vars.breaker.origin = vector(entity.get_origin(entity.get_local_player()))
        if vars.breaker.last_origin ~= nil then
            vars.breaker.tp_dist = (vars.breaker.origin - vars.breaker.last_origin):length2dsqr()
            gram_update(vars.breaker.tp_data, vars.breaker.tp_dist, true)
        end
        vars.breaker.last_origin = vars.breaker.origin
    end
end)

event_callback("predict_command", function(cmd)
    if cmd.command_number == vars.breaker.cmd then
        local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
        vars.breaker.defensive = math.abs(tickbase - vars.breaker.defensive_check)
        vars.breaker.defensive_check = math.max(tickbase, vars.breaker.defensive_check)
        vars.breaker.cmd = 0
    end
end)


local local_player, callback_reg, dt_charged = entity.get_local_player(), false, false

function check_charge()
    local m_nTickBase = entity.get_prop(entity.get_local_player(), 'm_nTickBase')
    local client_latency = client.latency()
    local shift = math.floor(m_nTickBase - globals.tickcount() - 3 - toticks(client_latency) * .5 + .5 * (client_latency * 10))

    local wanted = -14 + (ui.get(ref.doubletap.fakelag_limit) - 1) + 3 

    dt_charged = shift <= wanted
end

local ae, should_shoot, delay_w, del_jit = true, false, false, false
local is_math, start_timer, slow_turtle_pos, clicked, can_press_under, elect_svg = false, 0, 0, false, false, renderer.load_svg("<svg id=\"svg\" version=\"1.1\" width=\"608\" height=\"689\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" ><g id=\"svgg\"><path id=\"path0\" d=\"M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 \" stroke=\"none\" fill=\"#fff200\" fill-rule=\"evenodd\"></path></g></svg>", 25, 25)

-- set_spin = function()
--     ui.set(refs.pitch[1], "Off")
--     ui.set(refs.yawBase, "At targets")
--     ui.set(refs.yaw[1], "Spin")
--     ui.set(refs.yaw[2], 50)
--     ui.set(refs.yawJitter[1], "Off")
--     ui.set(refs.yawJitter[2], 0)
--     ui.set(refs.bodyYaw[1], "Static")
--     ui.set(refs.bodyYaw[2], 0)
--     ui.set(refs.fsBodyYaw, false)
--     ui.set(refs.edgeYaw, false)
--     ui.set(refs.roll, 0)
--     aa.ignore = true
-- end
-- local def_e, def_su, chat_spammer = true, false, {}

-- hours, minutes = client.system_time()
-- text, get_name, nickname, username, fps = string.format("%02d:%02d", hours, minutes), panorama.loadstring([[ return MyPersonaAPI.GetName() ]]), entity.get_player_name(), globals.frametime()
last_fps, update_interval, frame_count, lastmiss, bruteforce_reset, shot_time = 0, 60, 0, 0, true, 0



local last_sim_time = 0
local defensive_until = 0

is_defensive_active = function()
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
    end

    last_sim_time = sim_time

    return defensive_until > tickcount
end

def_switch = false

-- function dt_es()
--     return antiaim_funcs.get_double_tap()
-- end
main_aa = function(cmd)
    vars.localPlayer = entity.get_local_player()

    if not vars.localPlayer or not entity.is_alive(vars.localPlayer) then return end
	local flags = entity.get_prop(vars.localPlayer, "m_fFlags")
    local onground = bit.band(flags, 1) ~= 0 and cmd.in_jump == 0
	local valve = entity.get_prop(entity.get_game_rules(), "m_bIsValveDS")
	local origin = vector(entity.get_prop(vars.localPlayer, "m_vecOrigin"))
	local camera = vector(client.camera_angles())
	local eye = vector(client.eye_position())
    local velocity = vector(entity.get_prop(vars.localPlayer, "m_vecVelocity"))
    local weapon = entity.get_player_weapon()
	local pStill = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2) < 5
    local bodyYaw = entity.get_prop(vars.localPlayer, "m_flPoseParameter", 11) * 120 - 60
    local tp_amount = get_average(vars.breaker.tp_data)/get_velocity(entity.get_local_player())*100 
    local is_defensive = (vars.breaker.defensive > 1) and not (tp_amount >= 25 and vars.breaker.defensive >= 13)

    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
	local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
	local isFd = ui.get(refs.fakeDuck)
	local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    local isFl = ui.get(ref_ui("AA", "Fake lag", "Enabled"))
    local isFs1 = ui.get(menu.aaTab.freestandHotkey)
    local legitAA = false
    local man_aa = ui.get(menu.aaTab.m_left) or ui.get(menu.aaTab.m_right)

    vars.pState = 1
    if pStill then vars.pState = 2 end
    if not pStill then vars.pState = 3 end
    if isSlow then vars.pState = 4 end
    if entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 5 end
    if not pStill and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 8 end
    if not onground then vars.pState = 6 end
    if not onground and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 7 end
    if isFs1 then vars.pState = 10 end


    if ui.get(aaBuilder[9].enableState) and not func.table_contains(ui.get(aaBuilder[9].stateDisablers), vars.intToS[vars.pState]) and isDt == false and isOs == false and isFl == true then
		vars.pState = 9
    end

    if ui.get(aaBuilder[vars.pState].enableState) == false and vars.pState ~= 1 then
        vars.pState = 1
    end

    if (tickcount() % ui.get(aaBuilder[vars.pState].def_yaw_switch_delay)) == 1 then
        dele = not dele
    end

    if (tickcount() % math.random(1, 12) == 1) then
        delaa = not delaa
    end

    if tickcount() % 2 == 1 then
        del_jit = not del_jit
    end

    if (globals.tickcount() % ui.get(aaBuilder[vars.pState].def_jit_delay)) == 1 then
        d_sw = not d_sw
    end

    local da_value = ui.get(aaBuilder[vars.pState].delayed_body)
    local ra_value =ui.get(aaBuilder[vars.pState].random_delay)

    if (globals.tickcount() % (math.random(da_value, da_value + (ra_value-1)) * 2)) == 1 then
        bodydel = not bodydel
    end

    if (globals.tickcount() % 6) == 1 then
        a_bodydel = not a_bodydel
    end

    if (globals.tickcount() % 14) == 1 then
        def_switch = not def_switch
    end


    ui.set(refs.yawBase, "At targets")

    
    if ui.get(menu.aaTab.freestandHotkey) then
        ui.set(refs.freeStand[2], "Always on")
        ui.set(refs.freeStand[1], true)
    else
        ui.set(refs.freeStand[1], false)
        ui.set(refs.freeStand[2], "On hotkey")
    end
    local nextAttack = entity.get_prop(vars.localPlayer, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(vars.localPlayer), "m_flNextPrimaryAttack")
    local dtActive = false
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end

    local side = bodyYaw > 0 and 1 or -1

    -- if ui.get(menu.aaTab.spin_exploit) then
    --     local all_dead, enemy_found = true, false
    --     for i = 1, globals.maxplayers() do
    --         if entity.get_prop(entity.get_player_resource(), 'm_bConnected', i) == 1 and entity.is_enemy(i) then
    --             enemy_found = true
    --             if entity.is_alive(i) then all_dead = false break end
    --         end
    --     end
    --     if not enemy_found or all_dead then set_spin() else aa.ignore = false end
    -- end

    safe_head = function()
        ui.set(refs.pitch[1], "Down")
        ui.set(refs.yawBase, "At targets")
        ui.set(refs.yaw[1], "180")
        ui.set(refs.yaw[2], 0)
        ui.set(refs.yawJitter[1], "Off")
        ui.set(refs.yawJitter[2], 0)
        ui.set(refs.bodyYaw[1], "Static")
        ui.set(refs.bodyYaw[2], 0)
        ui.set(refs.fsBodyYaw, false)
        --ui.set(refs.edgeYaw, false)
        ui.set(refs.roll, 0)
        aa.ignore = true
    end

    get_distance = function() 
        local result = math.huge;
        local heightDifference = 0;
        local localplayer = entity.get_local_player();
        local entities = entity.get_players(true);
    
        for i = 1, #entities do
          local ent = entities[i];
          local ent_origin = { entity.get_origin(ent) }
          local lp_origin = { entity.get_origin(localplayer) }
          if ent ~= localplayer and entity.is_alive(ent) then
            local distance = (vector(ent_origin[1], ent_origin[2], ent_origin[3]) - vector(lp_origin[1], lp_origin[2], lp_origin[3])):length2d();
            if distance < result then 
                result = distance; 
                heightDifference = ent_origin[3] - lp_origin[3];
            end
          end
        end
      
        return math.floor(result/10), math.floor(heightDifference);
    end

    local distance_to_enemy = {get_distance()}

    if ae and (func.includes(ui.get(menu.aaTab.safe_head), "Air Zeus hold") and vars.pState == 7 and entity.get_classname(entity.get_player_weapon(vars.localPlayer)) == "CWeaponTaser") or (func.includes(ui.get(menu.aaTab.safe_head), "Air Knife hold") and vars.pState == 7 and entity.get_classname(entity.get_player_weapon(vars.localPlayer)) == "CKnife") or (func.includes(ui.get(menu.aaTab.safe_head), "Target lower than you") and distance_to_enemy[2] < -50) then
        if not ui.get(menu.aaTab.safe_flick) then
            safe_head()
        elseif ui.get(menu.aaTab.safe_flick) == true then
            cmd.force_defensive = true
            if not is_defensive then
                ui.set(refs.pitch[1], "Down")
                ui.set(refs.yawBase, "At targets")
                ui.set(refs.yaw[1], "180")
                ui.set(refs.yaw[2], 0)
                ui.set(refs.yawJitter[1], "Off")
                ui.set(refs.yawJitter[2], 0)
                ui.set(refs.bodyYaw[1], "Static")
                ui.set(refs.bodyYaw[2], 0)
                ui.set(refs.fsBodyYaw, false)
                --ui.set(refs.edgeYaw, false)
                ui.set(refs.roll, 0)
                aa.ignore = true
            elseif is_defensive then
                if ui.get(menu.aaTab.safe_flick_mode) == "Flick" then
                    ui.set(refs.pitch[1], "Down")
                    ui.set(refs.yawBase, "At targets")
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], 90)
                    ui.set(refs.yawJitter[1], "Off")
                    ui.set(refs.yawJitter[2], 1)
                    ui.set(refs.bodyYaw[1], "Static")
                    ui.set(refs.bodyYaw[2], 0)
                    ui.set(refs.fsBodyYaw, false)
                    --ui.set(refs.edgeYaw, false)
                    ui.set(refs.roll, 0)
                    aa.ignore = true
                elseif ui.get(menu.aaTab.safe_flick_mode) == "E spam" then
                    if ui.get(menu.aaTab.safe_flick_pitch) == "Fluculate" then
                        local speed = 8
                        local range = 80
                        ui.set(refs.pitch[1], "Custom")
                        ui.set(refs.pitch[2], (-math.sin(globals.curtime() * speed) * range))
                    elseif ui.get(menu.aaTab.safe_flick_pitch) == "Custom" then
                        ui.set(refs.pitch[1], "Custom")
                        ui.set(refs.pitch[2], ui.get(menu.aaTab.safe_flick_pitch_value))
                    end
                    ui.set(refs.yawBase, "At targets")
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], 180)
                    ui.set(refs.yawJitter[1], "Off")
                    ui.set(refs.yawJitter[2], 1)
                    ui.set(refs.bodyYaw[1], "Off")
                    ui.set(refs.bodyYaw[2], 0)
                    ui.set(refs.fsBodyYaw, false)
                    --ui.set(refs.edgeYaw, false)
                    ui.set(refs.roll, 0)
                    aa.ignore = true
                end
            end
        end
    else
        aa.ignore = false
    end

    if not (ui.get(menu.aaTab.legitAAHotkey) and cmd.in_use == 1) and aa.ignore == false then
        if ui.get(aaBuilder[vars.pState].enableState) then
        if ui.get(aaBuilder[vars.pState].force_defensive) then
            if ui.get(aaBuilder[vars.pState].defensive_mode) == "Default" then 
                cmd.force_defensive = true
            elseif ui.get(aaBuilder[vars.pState].defensive_mode) == "Switch" then
                if ui.get(aaBuilder[vars.pState].defensive_delay) ~= 0 then
                    if globals.tickcount() % ui.get(aaBuilder[vars.pState].defensive_delay) == 0 then
                        cmd.force_defensive = true
                    end
                else
                    cmd.force_defensive = true
                end
            elseif ui.get(aaBuilder[vars.pState].defensive_mode) == "On peek" and is_peeking() then
                cmd.allow_send_packet = false
                cmd.force_defensive = true
            end
        else
            if --[[l_peek() or ]]isOs then
                cmd.force_defensive = true
            else
                cmd.force_defensive = false
            end
        end
            if ui.get(aaBuilder[vars.pState].defensiveAntiAim) and ((isDt and is_defensive_active()) or isOs and is_defensive_active()) then
                if ui.get(aaBuilder[vars.pState].def_pitch) == "3-way" then
                    local first = ui.get(aaBuilder[vars.pState].def_3_1)
                    local second = ui.get(aaBuilder[vars.pState].def_3_2)
                    local third = ui.get(aaBuilder[vars.pState].def_3_3)
                    if tickcount() % 3 == 0 then
                        ui.set(refs.pitch[1], "Custom")
                        ui.set(refs.pitch[2], first)
                    elseif tickcount() % 3 == 1 then
                        ui.set(refs.pitch[1], "Custom")
                        ui.set(refs.pitch[2], second)
                    elseif tickcount() % 3 == 2 then
                        ui.set(refs.pitch[1], "Custom")
                        ui.set(refs.pitch[2], third)
                    end
                elseif ui.get(aaBuilder[vars.pState].def_pitch) == "Custom" then
                    ui.set(refs.pitch[1], "Custom")
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].def_pitchSlider))
                elseif ui.get(aaBuilder[vars.pState].def_pitch) == "Switch" then
                    ui.set(refs.pitch[1], "Custom")
                    ui.set(refs.pitch[2], d_sw and ui.get(aaBuilder[vars.pState].def_pitch_s1) or ui.get(aaBuilder[vars.pState].def_pitch_s2))
                elseif ui.get(aaBuilder[vars.pState].def_pitch) == "Dynamic" then
                    local min_value = ui.get(aaBuilder[vars.pState].def_pitch_s1)
                    local max_value = ui.get(aaBuilder[vars.pState].def_pitch_s2)
                    local speed = ui.get(aaBuilder[vars.pState].def_dyn_speed)
                    local delay = 3
                    local last_update = 0
                    
                    local function get_pitch_value()
                        local midpoint = (min_value + max_value) / 2
                        local amplitude = (max_value - min_value) / 2
                        return midpoint + math.sin(globals.curtime() * speed) * amplitude
                    end
                    
                    local function update_pitch()
                        if globals.curtime() - last_update >= delay then
                            ui.set(refs.pitch[1], "Custom")
                            ui.set(refs.pitch[2], get_pitch_value())
                            last_update = globals.curtime()
                        end
                    end
                    
                    update_pitch()
                elseif ui.get(aaBuilder[vars.pState].def_pitch) == "Random" then
                    local first = ui.get(aaBuilder[vars.pState].def_pitch_s1)
                    local second = ui.get(aaBuilder[vars.pState].def_pitch_s2)
                    local speed = ui.get(aaBuilder[vars.pState].def_slow_gen)
                    ui.set(refs.pitch[1], "Custom")
                    ui.set(refs.pitch[2], generate_slow_random2(first, second, speed / 10))                elseif ui.get(aaBuilder[vars.pState].def_pitch) == "Random (gamesense)" then
                    ui.set(refs.pitch[1], "Random")
                    ui.set(refs.pitch[2], 0)
                elseif ui.get(aaBuilder[vars.pState].def_pitch) == "Sway" then
                    local min_value = ui.get(aaBuilder[vars.pState].def_pitch_s1)
                    local max_value = ui.get(aaBuilder[vars.pState].def_pitch_s2)
                    local speed = ui.get(aaBuilder[vars.pState].def_dyn_speed) * 60
                    local delay = 1
                    local last_update = 0
                    
                    local function get_pitch_value()
                        local t = globals.curtime() * speed
                        local range = max_value - min_value
                        local progress = t % range
                        return min_value + progress
                    end
                    
                    local function update_pitch()
                        if globals.curtime() - last_update >= delay then
                            ui.set(refs.pitch[1], "Custom")
                            ui.set(refs.pitch[2], get_pitch_value())
                            last_update = globals.curtime()
                        end
                    end
                    
                    update_pitch()
                elseif ui.get(aaBuilder[vars.pState].def_pitch) == "Flick" then
                    ui.set(refs.pitch[1], "Custom")
                    if globals.tickcount() % math.random(15, 20) > 1 then
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].def_pitch_s1))
                    else
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].def_pitch_s2))
                    end
                end
                
                if ui.get(aaBuilder[vars.pState].def_yawMode) == "Switch" then
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], dele and ui.get(aaBuilder[vars.pState].def_yaw_left) or ui.get(aaBuilder[vars.pState].def_yaw_right))
                    ui.set(refs.yawJitter[1], "Random")
                    ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].def_yaw_random))
                elseif ui.get(aaBuilder[vars.pState].def_yawMode) == "Custom" then
                    ui.set(refs.yawJitter[1], "Random")
                    ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].def_yaw_random))
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].def_yawStatic))
                elseif ui.get(aaBuilder[vars.pState].def_yawMode) == "3-ways" then
                    ui.set(refs.yaw[1], "180")
                    local ways = {
                        ui.get(aaBuilder[vars.pState].def_way_1),
                        ui.get(aaBuilder[vars.pState].def_way_2),
                        ui.get(aaBuilder[vars.pState].def_way_3)
                    }

                    ui.set(refs.yaw[2], ways[(tickcount() % 3) + 1] )
                    ui.set(refs.yawJitter[1], "Off")
                    ui.set(refs.yawJitter[2], 0)
                elseif ui.get(aaBuilder[vars.pState].def_yawMode) == "Distorion" then
                    local angle1 = ui.get(aaBuilder[vars.pState].def_yaw_left)
                    local angle2 = ui.get(aaBuilder[vars.pState].def_yaw_right)
                    local speed = ui.get(aaBuilder[vars.pState].def_yaw_exploit_speed) / 3
                    
                    local mid = (angle1 + angle2) / 2
                    local amplitude = (angle2 - angle1) / 2
                    local yaw_value = mid + math.sin(globals.curtime() * speed) * amplitude
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], yaw_value)
                    ui.set(refs.yawJitter[1], "Off")
                    ui.set(refs.yawJitter[2], 0)
                elseif ui.get(aaBuilder[vars.pState].def_yawMode) == "Spin" then
                    local speed = ui.get(aaBuilder[vars.pState].def_yaw_spin_speed) / 4
                    local range = ui.get(aaBuilder[vars.pState].def_yaw_spin_range)
                    local spined = math.lerp(-range * 0.5, range * 0.5, math.sin(globals.curtime() * speed % 1))
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], spined)
                    ui.set(refs.yawJitter[1], "Off")
                    ui.set(refs.yawJitter[2], 0)
                elseif ui.get(aaBuilder[vars.pState].def_yawMode) == "Random" then
                    local first = ui.get(aaBuilder[vars.pState].def_yaw_left)
                    local second = ui.get(aaBuilder[vars.pState].def_yaw_right)
                    local speed = ui.get(aaBuilder[vars.pState].def_slow_gena)
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], generate_slow_random(first, second, speed / 10))
                    ui.set(refs.yawJitter[1], "Off")
                    ui.set(refs.yawJitter[2], 0)
                end
                
                if ui.get(aaBuilder[vars.pState].bidy) then
                    if ui.get(aaBuilder[vars.pState].bodyYaw) == "Static" or ui.get(aaBuilder[vars.pState].bodyYaw) == "Jitter" or ui.get(aaBuilder[vars.pState].bodyYaw) == "Opposite" then
                        ui.set(refs.bodyYaw[1], "Off")
                    end
                else
                    if ui.get(aaBuilder[vars.pState].bodyYaw) == "Static" then
                        ui.set(refs.bodyYaw[1], "Static")
                        ui.set(refs.bodyYaw[2], (ui.get(aaBuilder[vars.pState].bodyYawStatic)))
                    elseif ui.get(aaBuilder[vars.pState].bodyYaw) == "Jitter" then
                        if ui.get(aaBuilder[vars.pState].delayed_body) == 1 then
                            ui.set(refs.bodyYaw[1], "Jitter")
                            ui.set(refs.bodyYaw[2], 2)
                        elseif ui.get(aaBuilder[vars.pState].delayed_body) ~= 1 then
                            ui.set(refs.bodyYaw[1], "Static")
                            ui.set(refs.bodyYaw[2], bodydel and -1 or 1)
                        end
                    elseif ui.get(aaBuilder[vars.pState].bodyYaw) == "Opposite" then
                        ui.set(refs.bodyYaw[1], "Opposite")
                    end
                end
           
            else
                ui.set(refs.pitch[1], "Down")

                if ui.get(aaBuilder[vars.pState].yaw) == "Left / Right" then
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2],(side == 1 and (ui.get(aaBuilder[vars.pState].yawLeft) - math.random(0, ui.get(aaBuilder[vars.pState].randomization))) or (ui.get(aaBuilder[vars.pState].yawRight) + math.random(0, ui.get(aaBuilder[vars.pState].randomization)))))
                elseif ui.get(aaBuilder[vars.pState].yaw) == "Offset" then
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawStatic))
                end


                if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                    ui.set(refs.yawJitter[1], "Center")
                    local ways = {
                        ui.get(aaBuilder[vars.pState].wayFirst),
                        ui.get(aaBuilder[vars.pState].waySecond),
                        ui.get(aaBuilder[vars.pState].wayThird)
                    }

                    ui.set(refs.yawJitter[2], ways[(tickcount() % 3) + 1] )
                elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Sway" then
                    local speed = ui.get(aaBuilder[vars.pState].sway_speed) / 2
                    local min_value = 0
                    local max_value = ui.get(aaBuilder[vars.pState].yawJitterStatic)


                    local function get_pitch_value()
                        local midpoint = (min_value + max_value) / 2
                        local amplitude = (max_value - min_value) / 2
                        return midpoint + math.sin(globals.curtime() * speed) * amplitude
                    end

                    ui.set(refs.yawJitter[1], "Center")
                    ui.set(refs.yawJitter[2], get_pitch_value())
                else
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
                    ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic) + math.random(0, ui.get(aaBuilder[vars.pState].randomization)))
                end

                if ui.get(aaBuilder[vars.pState].bodyYaw) == "Jitter" then
                    if ui.get(aaBuilder[vars.pState].delayed_body) == 1 then
                        ui.set(refs.bodyYaw[1], "Jitter")
                        ui.set(refs.bodyYaw[2], 2)
                    elseif ui.get(aaBuilder[vars.pState].delayed_body) ~= 1 then
                        ui.set(refs.bodyYaw[1], "Static")
                        ui.set(refs.bodyYaw[2], bodydel and -1 or 1)
                    end
                elseif ui.get(aaBuilder[vars.pState].bodyYaw) == "Static" then
                    local value = ui.get(aaBuilder[vars.pState].bodyYawStatic)
                    ui.set(refs.bodyYaw[1], "Static")
                    if value == -2 then
                        ui.set(refs.bodyYaw[2], -180)
                    elseif value == -1 then
                        ui.set(refs.bodyYaw[2], -1)
                    elseif value == 0 then
                        ui.set(refs.bodyYaw[2], 0)
                    elseif value == 1 then
                        ui.set(refs.bodyYaw[2], 1)
                    elseif value == 2 then
                        ui.set(refs.bodyYaw[2], 180)
                    end
                else
                    ui.set(refs.bodyYaw[1], ui.get(aaBuilder[vars.pState].bodyYaw))
                    ui.set(refs.bodyYaw[2], ui.get(aaBuilder[vars.pState].bodyYawStatic))
                end
        
                if ui.get(aaBuilder[vars.pState].fl_enable) and not isFD then
                    if ui.get(aaBuilder[vars.pState].fl_mode) == "Maximum" then
                        ui.set(refs.flLimit, 15)
                        ui.set(refs.flamount, "Maximum")
                        ui.set(refs.flVariance, 0)
                        ui.set(refs.flenabled, true)
                    elseif ui.get(aaBuilder[vars.pState].fl_mode) == "Random" then
                        ui.set(refs.flLimit, math.random(1, 14))
                        ui.set(refs.flamount, "Maximum")
                        ui.set(refs.flVariance, 50)
                        ui.set(refs.flenabled, true)
                    elseif ui.get(aaBuilder[vars.pState].fl_mode) == "Fluculate [custom]" then
                        local speed = 4
                        local range = 20
                        ui.set(refs.flamount, "Maximum")
                        ui.set(refs.flLimit, (math.sin(globals.curtime() * speed) * 6.5) + 7.5)
                        ui.set(refs.flVariance, 0)
                        ui.set(refs.flenabled, true)
                    end
                elseif ui.get(aaBuilder[vars.pState].fl_enable) and isFD then
                    ui.set(refs.flLimit, 15)
                    ui.set(refs.flamount, "Maximum")
                    ui.set(refs.flVariance, 0)
                    ui.set(refs.flenabled, true)
                end

                ui.set(refs.fsBodyYaw, false)
            end
        elseif not ui.get(aaBuilder[vars.pState].enableState) then
            ui.set(refs.pitch[1], "Off")
            ui.set(refs.yawBase, "At targets")
            ui.set(refs.yaw[1], "180")
            ui.set(refs.yaw[2], 0)
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            ui.set(refs.bodyYaw[1], "Off")
            ui.set(refs.bodyYaw[2], 0)
            ui.set(refs.fsBodyYaw, false)
            --ui.set(refs.edgeYaw, false)
            ui.set(refs.roll, 0)
        end
    elseif (ui.get(menu.aaTab.legitAAHotkey) and cmd.in_use == 1) and aa.ignore == false then
        if entity.get_classname(entity.get_player_weapon(vars.localPlayer)) == "CC4" then 
            return 
        end
        
        local should_disable = false
        local planted_bomb = entity.get_all("CPlantedC4")[1]
    
        if planted_bomb ~= nil then
            bomb_distance = vector(entity.get_origin(vars.localPlayer)):dist(vector(entity.get_origin(planted_bomb)))
            
            if bomb_distance <= 64 and entity.get_prop(vars.localPlayer, "m_iTeamNum") == 3 then
                should_disable = true
            end
        end
    
        local pitch, yaw = client.camera_angles()
        local direct_vec = vector(func.vec_angles(pitch, yaw))
    
        local eye_pos = vector(client.eye_position())
        local fraction, ent = client.trace_line(vars.localPlayer, eye_pos.x, eye_pos.y, eye_pos.z, eye_pos.x + (direct_vec.x * 8192), eye_pos.y + (direct_vec.y * 8192), eye_pos.z + (direct_vec.z * 8192))
    
        if ent ~= nil and ent ~= -1 then
            if entity.get_classname(ent) == "CPropDoorRotating" then
                should_disable = true
            elseif entity.get_classname(ent) == "CHostage" then
                should_disable = true
            end
        end
        
        if should_disable ~= true then
            ui.set(refs.pitch[1], "Off")
            ui.set(refs.yaw[1], "180")
            ui.set(refs.yaw[2], 180)
            ui.set(refs.yawJitter[1], "Center")
            ui.set(refs.yawJitter[2], 0)
            if ui.get(aaBuilder[vars.pState].bodyYaw) == "Static" then
                ui.set(refs.bodyYaw[1], "Static")
                ui.set(refs.bodyYaw[2], (ui.get(aaBuilder[vars.pState].bodyYawStatic)))
            elseif ui.get(aaBuilder[vars.pState].bodyYaw) == "Jitter" then
                ui.set(refs.bodyYaw[1], "Static")
                ui.set(refs.bodyYaw[2], bodydel and -1 or 1)
            elseif ui.get(aaBuilder[vars.pState].bodyYaw) == "Opposite" then
                ui.set(refs.bodyYaw[1], "Opposite")
            end
            ui.set(refs.fsBodyYaw, true)
            ui.set(refs.edgeYaw, false)
            ui.set(refs.roll, 0)
            ui.set(refs.yawBase, "Local view")
            ui.set(refs.freeStand[1], false)
            ui.set(refs.freeStand[2], "On hotkey")
            cmd.in_use = 0
            cmd.roll = 0
        end
    end

    ui.set(menu.aaTab.m_left, "On hotkey")
        ui.set(menu.aaTab.m_right, "On hotkey")
        ui.set(menu.aaTab.m_forward, "On hotkey")
        if vars.last_press + 0.22 < globals.curtime() then
            if vars.aa_dir == 0 then
                if ui.get(menu.aaTab.m_left) then
                    vars.aa_dir = 1
                    vars.last_press = globals.curtime()
                elseif ui.get(menu.aaTab.m_right) then
                    vars.aa_dir = 2
                    vars.last_press = globals.curtime()
                elseif ui.get(menu.aaTab.m_forward) then
                    vars.aa_dir = 3
                    vars.last_press = globals.curtime()
                end
            elseif vars.aa_dir == 1 then
                if ui.get(menu.aaTab.m_right) then
                    vars.aa_dir = 2
                    vars.last_press = globals.curtime()
                elseif ui.get(menu.aaTab.m_forward) then
                    vars.aa_dir = 3
                    vars.last_press = globals.curtime()
                elseif ui.get(menu.aaTab.m_left) then
                    vars.aa_dir = 0
                    vars.last_press = globals.curtime()
                end
            elseif vars.aa_dir == 2 then
                if ui.get(menu.aaTab.m_left) then
                    vars.aa_dir = 1
                    vars.last_press = globals.curtime()
                elseif ui.get(menu.aaTab.m_forward) then
                    vars.aa_dir = 3
                    vars.last_press = globals.curtime()
                elseif ui.get(menu.aaTab.m_right) then
                    vars.aa_dir = 0
                    vars.last_press = globals.curtime()
                end
            elseif vars.aa_dir == 3 then
                if ui.get(menu.aaTab.m_forward) then
                    vars.aa_dir = 0
                    vars.last_press = globals.curtime()
                elseif ui.get(menu.aaTab.m_left) then
                    vars.aa_dir = 1
                    vars.last_press = globals.curtime()
                elseif ui.get(menu.aaTab.m_right) then
                    vars.aa_dir = 2
                    vars.last_press = globals.curtime()
                end
            end
        end
        if vars.aa_dir == 1 or vars.aa_dir == 2 or vars.aa_dir == 3 then
            if vars.aa_dir == 1 then
                cmd.force_defensive = false
                ui.set(refs.yawBase, "Local view")
                ui.set(refs.yaw[1], "180")
                ui.set(refs.yaw[2], -90)
                if ui.get(menu.aaTab.static_m) then
                    ui.set(refs.yawJitter[1], "Center")
                    ui.set(refs.yawJitter[2], 0)
                    ui.set(refs.bodyYaw[1], "Off")
                end
                ui.set(refs.pitch[1], "Down")
                aa.ignore = true
            elseif vars.aa_dir == 2 then
                cmd.force_defensive = false
                ui.set(refs.yawBase, "local view")
                ui.set(refs.yaw[1], "180")
                ui.set(refs.yaw[2], 90)
                if ui.get(menu.aaTab.static_m) then
                    ui.set(refs.yawJitter[1], "Center")
                    ui.set(refs.yawJitter[2], 0)
                    ui.set(refs.bodyYaw[1], "Off")
                end
                ui.set(refs.pitch[1], "Down")
                aa.ignore = true
            elseif vars.aa_dir == 3 then
                cmd.force_defensive = false
                ui.set(refs.yawBase, "local view")
                ui.set(refs.yaw[1], "180")
                ui.set(refs.yaw[2], 180)
                if ui.get(menu.aaTab.static_m) then
                    ui.set(refs.yawJitter[1], "Center")
                    ui.set(refs.yawJitter[2], 0)
                    ui.set(refs.bodyYaw[1], "Off")
                end
                ui.set(refs.pitch[1], "Down")
                aa.ignore = true
            end
        end

    if ui.get(menu.miscTab.bomb_fix) then
        if cmd.in_use == 0 then
            return
        end
        local me = entity.get_local_player()
        if me == nil then
            return
        end
        local m_bInBombZone = entity.get_prop(me, "m_bInBombZone")
        if m_bInBombZone == 1 then
            cmd.in_use = 0
        end
    end
    

    local self = entity.get_local_player()

    local players = entity.get_players(true)
    local eye_x, eye_y, eye_z = client.eye_position()
    returnthat = false 
    if ui.get(menu.aaTab.anti_knife) ~= false then
        if players ~= nil then
            for i, enemy in pairs(players) do
                local head_x, head_y, head_z = entity.hitbox_position(players[i], 5)
                local wx, wy = renderer.world_to_screen(head_x, head_y, head_z)
                local fractions, entindex_hit = client.trace_line(self, eye_x, eye_y, eye_z, head_x, head_y, head_z)
    
                if ui.get(menu.aaTab.avoid_dist) >= vector(entity.get_prop(enemy, 'm_vecOrigin')):dist(vector(entity.get_prop(self, 'm_vecOrigin'))) and entity.is_alive(enemy) and entity.get_player_weapon(enemy) ~= nil and entity.get_classname(entity.get_player_weapon(enemy)) == 'CKnife' and (entindex_hit == players[i] or fractions == 1) and not entity.is_dormant(players[i]) then
                    ui.set(refs.pitch[1], "Down")
                    ui.set(refs.yaw[1], "180")
                    ui.set(refs.yaw[2], 180)
                    ui.set(refs.yawBase, "At targets")
                    ui.set(refs.bodyYaw[1], "Static")
                    ui.set(refs.bodyYaw[2], 1)
                    ui.set(refs.yawJitter[1], "Off")

                    aa.ignore = true
                    ae = false
                    returnthat = true
                else 
                    ae = true
                    aa.ignore = false
                end
            end
        end
    end

    if ui.get(menu.aaTab.edge_on_fd) and isFd then
        ui.set(refs.edgeYaw, true)
    else
        ui.set(refs.edgeYaw, false)
    end

end

fastladder = function(cmd)
    if not ui.get(menu.miscTab.fast_ladder) then return end
    local me = entity.get_local_player()
    if not me then return end

    local move_type = entity.get_prop(me, 'm_MoveType')
    local weapon = entity.get_player_weapon(me)
    local throw = entity.get_prop(weapon, 'm_fThrowTime')

    if move_type ~= 9 then
        return
    end

    if weapon == nil then
        return
    end

    if throw ~= nil and throw ~= 0 then
        return
    end

    if cmd.forwardmove > 0 then
        if cmd.pitch < 45 then
            cmd.pitch = 89
            cmd.in_moveright = 1
            cmd.in_moveleft = 0
            cmd.in_forward = 0
            cmd.in_back = 1

            if cmd.sidemove == 0 then
                cmd.yaw = cmd.yaw + 90
            end

            if cmd.sidemove < 0 then
                cmd.yaw = cmd.yaw + 150
            end

            if cmd.sidemove > 0 then
                cmd.yaw = cmd.yaw + 30
            end
        end
    elseif cmd.forwardmove < 0 then
        cmd.pitch = 89
        cmd.in_moveleft = 1
        cmd.in_moveright = 0
        cmd.in_forward = 1
        cmd.in_back = 0

        if cmd.sidemove == 0 then
            cmd.yaw = cmd.yaw + 90
        end

        if cmd.sidemove > 0 then
            cmd.yaw = cmd.yaw + 150
        end

        if cmd.sidemove < 0 then
            cmd.yaw = cmd.yaw + 30
        end
    end
end
-- anti-brute анти

function GetClosestPoint(A, B, P)
    a_to_p = { P[1] - A[1], P[2] - A[2] }
    a_to_b = { B[1] - A[1], B[2] - A[2] }

    atb2 = a_to_b[1]^2 + a_to_b[2]^2

    atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    t = atp_dot_atb / atb2
    
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end



--брут
event_callback("bullet_impact", function(cmd)
    if ui.get(aaBuilder[vars.pState].antibrute_enable) == false then return end
    
    --if not entity.is_alive(entity.get_local_player()) then return end
    local ent = client.userid_to_entindex(cmd.userid)
    if ent ~= client.current_threat() then return end
    if entity.is_dormant(ent) or not entity.is_enemy(ent) then return end

    local ent_origin = { entity.get_prop(ent, "m_vecOrigin") }
    ent_origin[3] = ent_origin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
    local local_head = { entity.hitbox_position(entity.get_local_player(), 0) }
    local closest = GetClosestPoint(ent_origin, { cmd.x, cmd.y, cmd.z }, local_head)
    local delta = { local_head[1]-closest[1], local_head[2]-closest[2] }
    local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)

    if bruteforce then return end
    if math.abs(delta_2d) <= 60 and globals.curtime() - lastmiss > 0.015 then
        lastmiss = globals.curtime()
        bruteforce = true
        shot_time = globals.realtime()
        notifications.new("Anti Bruteforce Switched due to shot", 255, 255, 255)
    end
end)

function Returner()
    brut3 = true
    return brut3
end

client.set_event_callback("setup_command", function(cmd)
    if bruteforce and ui.get(aaBuilder[vars.pState].antibrute_enable) then
        client.set_event_callback("paint_ui", Returner)
        unset_event_callback("setup_command", main_aa)
        bruteforce = false
        bruteforce_reset = false
        set_brute = true
        aa.ignore = true
    else
        if shot_time + 3 < globals.realtime() or not ui.get(aaBuilder[vars.pState].antibrute_enable) then
            client.unset_event_callback("paint_ui", Returner)
            event_callback("setup_command", main_aa)
            set_brute = false
            brut3 = false
            bruteforce_reset = true
            set_brute = false
            aa.ignore = false
        end
    end
    return shot_time
end)

client.set_event_callback("setup_command", function(cmd)
    ground_check = cmd.in_jump == 0
    if set_brute == false then return end
    ui.set(refs.pitch[1], "Down")
    aa.ignore = true
    if func.table_contains(ui.get(aaBuilder[vars.pState].antibrute_aa), "Yaw") then
        ui.set(refs.yaw[1], "180")
        ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].antibrute_yaw))
    end
    if func.table_contains(ui.get(aaBuilder[vars.pState].antibrute_aa), "Modifier") then
        if ui.get(aaBuilder[vars.pState].antibrute_mod) == "Center" then
            ui.set(refs.yawJitter[1], "Center")
            ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].antibrute_mod_range))
        elseif ui.get(aaBuilder[vars.pState].antibrute_mod) == "Random" then
            ui.set(refs.yawJitter[1], "Random")
            ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].antibrute_mod_range))
        elseif ui.get(aaBuilder[vars.pState].antibrute_mod) == "Sway" then
            local speed = 4
            local range = ui.get(aaBuilder[vars.pState].antibrute_mod_range)
            ui.set(refs.yawJitter[1], "Center")
            ui.set(refs.yawJitter[2], math.sin(globals.curtime() * speed) * range)
        elseif ui.get(aaBuilder[vars.pState].antibrute_mod) == "Delayed" then
            ui.set(refs.yaw[1], "180")
            ui.set(refs.yaw[2], a_bodydel and -ui.get(aaBuilder[vars.pState].antibrute_mod_range) or ui.get(aaBuilder[vars.pState].antibrute_mod_range))
        end
            

    end
    if func.table_contains(ui.get(aaBuilder[vars.pState].antibrute_aa), "Body yaw") then
        if ui.get(aaBuilder[vars.pState].antibrute_body) == "Static" then
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], ui.get(aaBuilder[vars.pState].antibrute_body_range))
        elseif ui.get(aaBuilder[vars.pState].antibrute_body) == "Jitter" then
            ui.set(refs.bodyYaw[1], "Jitter")
            ui.set(refs.bodyYaw[2], ui.get(aaBuilder[vars.pState].antibrute_body_range))
        elseif ui.get(aaBuilder[vars.pState].antibrute_body) == "Delayed" then
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], a_bodydel and -1 or 1)
        end
    end
end)

local hitboxes = {
    ind = {
        1, 
        2, 
        3, 
        4, 
        5, 
        6, 
        7
    }, 

    name = {
        "head", 
        "chest", 
        "stomach", 
        "left_arm", 
        "right_arm", 
        "left_leg", 
        "right_leg"
    }
}

local bot_data = {
    start_position = vector(0,0,0),
    cache_eye_left = vector(0,0,0), 
    cache_eye_right = vector(0,0,0),
    left_trace_active,
    right_trace_active,
    peekbot_active,
    calculate_wall_dist_left = 0, 
    calculate_wall_dist_right = 0,
    set_location = true,
    shot_fired = false,
    reload_timer = 0,
    reached_max_distance = false,
    should_return = false,
    tracer_position,
    lerp_distance = 0
}


local ground_ticks = 0
event_callback("pre_render", function(cmd)
    if not entity.get_local_player() then return end
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)
    local self = entity.get_local_player()
    local self_index = c_ent.new(self)
    local self_anim_state = self_index:get_anim_state()
    local onground = bit.band(flags, 1) ~= 0

    local function jitter_value()
        local current_time = globals.tickcount() / 10
        local jitter_frequency = 7
        local jitter_factor = 0.5 + 0.5 * math.sin(current_time * jitter_frequency)
        return jitter_factor * 100
    end

    if ui.get(menu.visualsTab.ap_move) == "Jitter" and onground then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, tickcount() % 4 > 1 and 0 or 1)
        ui.set(refs.legMovement, "Always slide")
    elseif ui.get(menu.visualsTab.ap_move) == "Static" and onground then
        ui.set(refs.legMovement, "Always slide")
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
    elseif ui.get(menu.visualsTab.ap_move) == "Walking" and onground then
        ui.set(refs.legMovement, "Never slide")
        if not legsSaved then
            legsSaved = ui.get(refs.legMovement)
        end
        ui.set_visible(refs.legMovement, false)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
        me = c_ent.get_local_player()
        flags = me:get_prop("m_fFlags")
        onground = bit.band(flags, 1) ~= 0
        if onground then
            my_animlayer = me:get_anim_overlay(6)
            my_animlayer.weight = 1
            my_animlayer.cycle = globals.realtime() * 0.5 % 1
        end
    elseif ui.get(menu.visualsTab.ap_move) == "Kangaroo" and onground then
        ui.set(refs.legMovement, "Always slide")
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", client.random_float(0.8, 1), 0)
    elseif ui.get(menu.visualsTab.ap_move) == "Earthquake" and onground then
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then return end

        if globals.tickcount() % 90 > 1 then
            self_anim_overlay.weight = jitter_value() / 100
        end
    end

    if ui.get(menu.visualsTab.ap_air) == "Force falling" and not onground then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
    elseif ui.get(menu.visualsTab.ap_air) == "Walking" and not onground then
        ui.set(refs.legMovement, "Never slide")
        if not legsSaved then
            legsSaved = ui.get(refs.legMovement)
        end
        ui.set_visible(refs.legMovement, false)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
        me = c_ent.get_local_player()
        flags = me:get_prop("m_fFlags")
        onground = bit.band(flags, 1) ~= 0
        if not onground then
            my_animlayer = me:get_anim_overlay(6)
            my_animlayer.weight = 1
            my_animlayer.cycle = globals.realtime() * 0.5 % 1
        end
    elseif ui.get(menu.visualsTab.ap_air) == "Kangaroo" and not onground then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 2)/2, 2)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 2)/2, 1)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 2)/2, 2)
    elseif ui.get(menu.visualsTab.ap_air) == "Earthquake" and not onground then
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then return end

        if globals.tickcount() % 90 > 1 then
            self_anim_overlay.weight = jitter_value() / 100
        end
    end


    if ui.get(menu.visualsTab.a_pitch) then
        ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0

        if ground_ticks > 5 and ground_ticks < 80 then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end

    if ui.get(menu.visualsTab.a_body) then
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end

        local x_velocity = entity.get_prop(self, "m_vecVelocity[0]")
        if math.abs(x_velocity) >= 3 then
            self_anim_overlay.weight = 1
        end
    end

    if ui.get(menu.visualsTab.a_legacy) then
        local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
        local self_anim_overlay = self_index:get_anim_overlay(6)
        if not self_anim_overlay then
            return
        end

        if isSlow then
            self_anim_overlay.weight = 0
        end
    end

end)



local alpha, scopedFraction, acatelScoped, dtModifier, barMoveY, activeFraction, inactiveFraction, defensiveFraction, hideFraction, hideInactiveFraction, dtPos, osPos, mainIndClr, dtClr, chargeClr, chargeInd, psClr, dtInd, qpInd, fdInd, spInd, baInd, fsInd, osInd, psInd, wAlpha, interval = 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, {y = 0}, {y = 0}, {r = 0, g = 0, b = 0, a = 0}, {r = 0, g = 0, b = 0, a = 0}, {r = 0, g = 0, b = 0, a = 0}, {w = 0, x = 0, y = 25}, {r = 0, g = 0, b = 0, a = 0}, {w = 0, x = 0, y = 25}, {w = 0, x = 0, y = 25, a = 0}, {w = 0, x = 0, y = 25, a = 0}, {w = 0, x = 0, y = 25, a = 0}, {w = 0, x = 0, y = 25, a = 0}, {w = 0, x = 0, y = 25, a = 0}, {w = 0, x = 0, y = 25, a = 0}, {w = 0, x = 0, y = 25}, 0, 0

-- data = {}

-- local aa_dir, m_iSide = 0, 0

-- e_manuals = function()
--     local m_iSide = 0 

--     local isLeft = ui.get(menu.aaTab.m_left)
--     local isRight = ui.get(menu.aaTab.m_right)

    
--     if isLeft and isRight then
        
--         ui.set(menu.aaTab.m_right, false)
--         m_iSide = 1 
--     elseif isLeft then
--         m_iSide = 1 
--     elseif isRight then
--         m_iSide = 2 
--     end

    
--     if not isLeft and not isRight then
--         m_iSide = 0 
--     end

--     return m_iSide
-- end

--сд

local current_damage = 0
local target_damage = 0
local anim_start_time = 0
local anim_duration = 3


local last_fps = 0
local update_interval = 60
local frame_count = 0

function get_fps()
    frame_count = frame_count + 1

    if frame_count >= update_interval then
        last_fps = 1.0 / globals.frametime()
        frame_count = 0
    end

    return last_fps
end

function get_rate()
    return 1.0 / globals.tickinterval()
end

local glow_time = 0
function get_glow_color()
    glow_time = glow_time + globals.frametime() * 2
    local r = math.floor(128 + 127 * math.sin(glow_time))
    local g = math.floor(128 + 127 * math.sin(glow_time + 2))
    local b = math.floor(128 + 127 * math.sin(glow_time + 4))
    return r, g, b
end

function RenderRoundRectangle(x, y, w, h, radius, color)
    if color[4] <= 0 then
        return
    end

    renderer.rectangle(x, y + radius, radius, h - radius * 2, color[1], color[2], color[3], color[4])
    renderer.rectangle(x + radius, y, w - radius * 2, radius, color[1], color[2], color[3], color[4])
    renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, color[1], color[2], color[3], color[4])
    renderer.rectangle(x + w - radius, y + radius, radius, h - radius * 2, color[1], color[2], color[3], color[4])

    renderer.rectangle(x + radius, y + radius, w - radius * 2, h - radius * 2, color[1], color[2], color[3], color[4])

    renderer.circle(x + radius, y + radius, color[1], color[2], color[3], color[4], radius, 180, 0.25)
    renderer.circle(x + radius, y + h - radius, color[1], color[2], color[3], color[4], radius, 270, 0.25)
    renderer.circle(x + w - radius, y + radius, color[1], color[2], color[3], color[4], radius, 90, 0.25)
    renderer.circle(x + w - radius, y + h - radius, color[1], color[2], color[3], color[4], radius, 0, 0.25)
end

function RenderBlurredLine(x, y, w, h, r, g, b, a, blur_strength)
    blur_strength = 0.2
    local blur_alpha = math.floor(a / (blur_strength * 2))

    for i = -blur_strength, blur_strength do
        for j = -blur_strength, blur_strength do
            if i ~= 0 or j ~= 0 then
                renderer.rectangle(x + i, y + j, w, h, r, g, b, blur_alpha)
            end
        end
    end

    renderer.rectangle(x, y, w, h, r, g, b, a)
end

dragg = (function()
    local a = {}
    local b, c, d, e, f, g, h, i, j, k, l, m, n, o

    local p = {
        __index = {
            drag = function(self, ...)
                local q, r = self:get()
                local s, t = a.drag(q, r, ...)
                if q ~= s or r ~= t then
                    self:set(s, t)
                end
                return s, t
            end,
            set = function(self, q, r)
                local j, k = client.screen_size()
                ui.set(self.x_reference, q / j * self.res)
                ui.set(self.y_reference, r / k * self.res)
            end,
            get = function(self)
                local j, k = client.screen_size()
                return ui.get(self.x_reference) / self.res * j, ui.get(self.y_reference) / self.res * k
            end
        }
    }

    function a.new(u, v, w, x)
        x = x or 10000
        local j, k = client.screen_size()
        local y = ui.new_slider('LUA', 'A', u .. ' window position', 0, x, v / j * x)
        local z = ui.new_slider('LUA', 'A', '\n' .. u .. ' window position y', 0, x, w / k * x)
        ui.set_visible(y, false)
        ui.set_visible(z, false)
        return setmetatable({ name = u, x_reference = y, y_reference = z, res = x }, p)
    end

    function a.drag(q, r, A, B, C, D, E)
        if globals.framecount() ~= b then
            c = ui.is_menu_open()
            f, g = d, e
            d, e = ui.mouse_position()
            i = h
            h = client.key_state(0x01) == true
            m = l
            l = {}
            o = n
            n = false
            j, k = client.screen_size()
        end

        if c and i ~= nil then
            if (not i or o) and h and f > q and g > r and f < q + A and g < r + B then
                n = true
                q, r = q + d - f, r + e - g
                if not D then
                    q = math.max(0, math.min(j - A, q))
                    r = math.max(0, math.min(k - B, r))
                end
            end
        end

        table.insert(l, { q, r, A, B })
        return q, r, A, B
    end

    return a
end)()

dragg2 = (function()
    local a = {}
    local b, c, d, e, f, g, h, i, j, k, l, m, n, o

    local p = {
        __index = {
            drag = function(self, ...)
                local q, r = self:get()
                local s, t = a.drag(q, r, ...)
                if q ~= s or r ~= t then
                    self:set(s, t)
                end
                return s, t
            end,
            set = function(self, q, r)
                local j, k = client.screen_size()
                ui.set(self.x_reference, q / j * self.res)
                ui.set(self.y_reference, r / k * self.res)
            end,
            get = function(self)
                local j, k = client.screen_size()
                return ui.get(self.x_reference) / self.res * j, ui.get(self.y_reference) / self.res * k
            end
        }
    }

    function a.new(u, v, w, x)
        x = x or 10000
        local j, k = client.screen_size()
        local y = ui.new_slider('LUA', 'A', u .. ' window position', 0, x, v / j * x)
        local z = ui.new_slider('LUA', 'A', '\n' .. u .. ' window position y', 0, x, w / k * x)
        ui.set_visible(y, false)
        ui.set_visible(z, false)
        return setmetatable({ name = u, x_reference = y, y_reference = z, res = x }, p)
    end

    function a.drag(q, r, A, B, C, D, E)
        if globals.framecount() ~= b then
            c = ui.is_menu_open()
            f, g = d, e
            d, e = ui.mouse_position()
            i = h
            h = client.key_state(0x01) == true
            m = l
            l = {}
            o = n
            n = false
            j, k = client.screen_size()
        end

        if c and i ~= nil then
            if (not i or o) and h and f > q and g > r and f < q + A and g < r + B then
                n = true
                q, r = q + d - f, r + e - g
                if not D then
                    q = math.max(0, math.min(j - A, q))
                    r = math.max(0, math.min(k - B, r))
                end
            end
        end

        table.insert(l, { q, r, A, B })
        return q, r, A, B
    end

    return a
end)()

dragg3 = (function()
    local a = {}
    local b, c, d, e, f, g, h, i, j, k, l, m, n, o

    local p = {
        __index = {
            drag = function(self, ...)
                local q, r = self:get()
                local s, t = a.drag(q, r, ...)
                if q ~= s or r ~= t then
                    self:set(s, t)
                end
                return s, t
            end,
            set = function(self, q, r)
                local j, k = client.screen_size()
                ui.set(self.x_reference, q / j * self.res)
                ui.set(self.y_reference, r / k * self.res)
            end,
            get = function(self)
                local j, k = client.screen_size()
                return ui.get(self.x_reference) / self.res * j, ui.get(self.y_reference) / self.res * k
            end
        }
    }

    function a.new(u, v, w, x)
        x = x or 10000
        local j, k = client.screen_size()
        local y = ui.new_slider('LUA', 'A', u .. ' window position', 0, x, v / j * x)
        local z = ui.new_slider('LUA', 'A', '\n' .. u .. ' window position y', 0, x, w / k * x)
        ui.set_visible(y, false)
        ui.set_visible(z, false)
        return setmetatable({ name = u, x_reference = y, y_reference = z, res = x }, p)
    end

    function a.drag(q, r, A, B, C, D, E)
        if globals.framecount() ~= b then
            c = ui.is_menu_open()
            f, g = d, e
            d, e = ui.mouse_position()
            i = h
            h = client.key_state(0x01) == true
            m = l
            l = {}
            o = n
            n = false
            j, k = client.screen_size()
        end

        if c and i ~= nil then
            if (not i or o) and h and f > q and g > r and f < q + A and g < r + B then
                n = true
                q, r = q + d - f, r + e - g
                if not D then
                    q = math.max(0, math.min(j - A, q))
                    r = math.max(0, math.min(k - B, r))
                end
            end
        end

        table.insert(l, { q, r, A, B })
        return q, r, A, B
    end

    return a
end)()

-- local col1, col2, col3, col4 = ui.get(menu.visualsTab.watermarkClr)
local screen_x, screen_y = client.screen_size()
local hud_x = screen_x / 2
local hud_y = screen_y / 2
-- local sys_h, sys_m = client.system_time()
-- local time = string.format("%02d:%02d", sys_h, sys_m)

-- RenderRoundRectangle(hud_x+hud_x - 320, hud_y -  hud_y + 30, 100, 20, 8, {10, 10, 10, 150})

-- RenderBlurredLine(hud_x+hud_x - 313, hud_y-hud_y + 50, 90, 2, col1, col2, col3, 255, 5)

-- renderer.text(hud_x+hud_x - 310, hud_y-hud_y + 34, 255, 255, 255, 255, nil, 0, "Anoflow /")
-- renderer.text(hud_x+hud_x - 265, hud_y-hud_y + 34, col1, col2, col3, 255, nil, 0, text_fade_animation(3, col1, col2, col3, 255, "nebula"))

-- --dadad
-- RenderRoundRectangle(hud_x+hud_x - 210, hud_y - hud_y + 30, 100, 20, 8, {10, 10, 10, 150})

-- RenderBlurredLine(hud_x+hud_x - 205, hud_y - hud_y + 50, 90, 2, col1, col2, col3, 255, 5)

-- renderer.text(hud_x+hud_x - 205, hud_y-hud_y + 34, 255, 255, 255, 255, nil, 0, nick_name:sub(1, 8) .. " /")
-- renderer.text(hud_x+hud_x - 150, hud_y-hud_y + 34, col1, col2, col3, 255, nil, 0, math.floor(get_fps()) .. "fps")
-- --вфвфвфвф
-- RenderRoundRectangle(hud_x+hud_x - 106, hud_y - hud_y + 30, 40, 20, 8, {10, 10, 10, 150})

-- RenderBlurredLine(hud_x+hud_x - 100, hud_y-hud_y + 50, 30, 2, col1, col2, col3, 255, 5)

-- renderer.text(hud_x+hud_x - 100, hud_y-hud_y + 34, 255, 255, 255, 255, nil, 0, time)

local watermarkDraggable = dragg.new("Watermark", hud_x+hud_x - 320, hud_y -  hud_y + 30)
local fpsDraggable = dragg2.new("FPS", hud_x+hud_x - 210, hud_y - hud_y + 30)
local timeDraggable = dragg3.new("Time", hud_x+hud_x - 106, hud_y - hud_y + 30)


event_callback("paint", function()
    -- print("Memory usage:", collectgarbage("count"))
    local local_player = entity.get_local_player()
    vars.localPlayer = entity.get_local_player()
    if local_player == nil or entity.is_alive(local_player) == false then return end
    local sizeX, sizeY = client.screen_size()
    local weapon = entity.get_player_weapon(local_player)
    local bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1
    local state = "Running"
    local mainClr = {}
    mainClr.r, mainClr.g, mainClr.b, mainClr.a = ui.get(calar)
    local fake = math.floor(antiaim_funcs.get_desync(1))
    


    local scopeLevel = entity.get_prop(weapon, 'm_zoomLevel')
    local scoped = entity.get_prop(local_player, 'm_bIsScoped') == 1
    local resumeZoom = entity.get_prop(local_player, 'm_bResumeZoom') == 1
    local isValid = weapon ~= nil and scopeLevel ~= nil
    local act = isValid and scopeLevel > 0 and scoped and not resumeZoom
    local time = globals.frametime() * 30

    if act then
        if scopedFraction < 1 then
            scopedFraction = func.lerp(scopedFraction, 1 + 0.1, time)
        else
            scopedFraction = 1
        end
    else
        scopedFraction = func.lerp(scopedFraction, 0, time)
    end


    local dpi = 0
    local globalFlag = "cd-"
    local globalMoveY = 0
    local indX, indY = renderer.measure_text(globalFlag, "DT")
    indY = globalFlag == "cd-" and indY - 3 or indY - 2

    local nextAttack = entity.get_prop(vars.localPlayer, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(vars.localPlayer), "m_flNextPrimaryAttack")
    local dtActive = false
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end
    local isCharged = dtActive
    local isFs = ui.get(menu.aaTab.freestandHotkey)
    local isBa = ui.get(refs.forceBaim)
    local isSp = ui.get(refs.safePoint)
    local isQp = ui.get(refs.quickPeek[2])
    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
    local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
    local isFd = ui.get(refs.fakeDuck)
    local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])

    local state = vars.intToS[vars.pState]:upper()

    

    if ui.get(menu.visualsTab.cros_ind) then
        local strike_w, strike_h = renderer.measure_text("-cd", lua_name )
        local ate = animate_text(globals.curtime(), "NEBULA", mainClr.r, mainClr.g, mainClr.b, 255)

        renderer.text(sizeX/2 + ((strike_w + 2)/2) * scopedFraction, sizeY/2 + 20 - dpi/10, 155, 0, 0, 0, "-cd", nil, unpack(ate))

        local count = 0

        if isDt and dtActive and isDefensive == false then
            activeFraction = func.clamp(activeFraction + globals.frametime()/0.15, 0, 1)
            if dtPos.y < indY * count then
                dtPos.y = func.lerp(dtPos.y, indY * count + 0.1, time)
            else
                dtPos.y = indY * count
            end
            count = count + 1
        else
            activeFraction = func.clamp(activeFraction - globals.frametime()/0.15, 0, 1)
        end

        if isDt and dtActive and isDefensive then
            defensiveFraction = func.clamp(defensiveFraction + globals.frametime()/0.15, 0, 1)
            if dtPos.y < indY * count then
                dtPos.y = func.lerp(dtPos.y, indY * count + 0.1, time)
            else
                dtPos.y = indY * count
            end
            count = count + 1
        else
            defensiveFraction = func.clamp(defensiveFraction - globals.frametime()/0.15, 0, 1)
            isDefensive = false
        end

        if isDt and not dtActive then
            inactiveFraction = func.clamp(inactiveFraction + globals.frametime()/0.15, 0, 1)
            if dtPos.y < indY * count then
                dtPos.y = func.lerp(dtPos.y, indY * count + 0.1, time)
            else
                dtPos.y = indY * count
            end
            count = count + 1
        else
            inactiveFraction = func.clamp(inactiveFraction - globals.frametime()/0.15, 0, 1)
        end

        if isOs and ui.get(ref_ui("Rage", "Other", "Silent aim")) and isDt then
            hideInactiveFraction = func.clamp(hideInactiveFraction + globals.frametime()/0.15, 0, 1)
            if osPos.y < indY * count then
                osPos.y = func.lerp(osPos.y, indY * count + 0.1, time)
            else
                osPos.y = indY * count
            end
            count = count + 1
        else
            hideInactiveFraction = func.clamp(hideInactiveFraction - globals.frametime()/0.15, 0, 1)
        end

        if isOs and ui.get(ref_ui("Rage", "Other", "Silent aim")) and not isDt then
            hideFraction = func.clamp(hideFraction + globals.frametime()/0.15, 0, 1)
            if osPos.y < indY * count then
                osPos.y = func.lerp(osPos.y, indY * count + 0.1, time)
            else
                osPos.y = indY * count
            end
            count = count + 1
        else
            hideFraction = func.clamp(hideFraction - globals.frametime()/0.15, 0, 1)
        end

        local globalMarginX, globalMarginY = renderer.measure_text("-cd", "DSAD")
        globalMarginY = globalMarginY - 2
        local dt_size = renderer.measure_text("-cd", "DT ")
        local ready_size = renderer.measure_text("-cd", "CHARGED")
        renderer.text(sizeX/2 + ((dt_size + ready_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + dtPos.y, 255, 255, 255, activeFraction * 255, "-cd", dt_size + activeFraction * ready_size + 1, "DT ", "\a" .. func.RGBAtoHEX(5, 255, 5, 255 * activeFraction) .. "CHARGED")

        local charging_size = renderer.measure_text("-cd", "CHARGED")
        local ret = animate_text(globals.curtime(), "CHARGED", 255, 0, 0, 255)
        renderer.text(sizeX/2 + ((dt_size + charging_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + dtPos.y, 255, 255, 255, inactiveFraction * 255, "-cd", dt_size + inactiveFraction * charging_size + 1, "DT ", unpack(ret))

        local defensive_size = renderer.measure_text("-cd", "DEFENSIVE")
        local def = animate_text(globals.curtime(), "DEFENSIVE", mainClr.r, mainClr.g, mainClr.b, 255)
        renderer.text(sizeX/2 + ((dt_size + defensive_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + dtPos.y, 255, 255, 255, defensiveFraction * 255, "-cd", dt_size + defensiveFraction * defensive_size + 1, "DT ", unpack(def))

        local hide_size = renderer.measure_text("-cd", "OSAA ")
        local active_size = renderer.measure_text("-cd", "ACTIVE")
        renderer.text(sizeX/2 + ((hide_size + active_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + osPos.y, 255, 255, 255, hideFraction * 255, "-cd", hide_size + hideFraction * active_size + 1, "OSAA ", "\a" .. func.RGBAtoHEX(255, 255, 0, 255 * hideFraction) .. "ACTIVE")
        
        local inactive_size = renderer.measure_text("-cd", "INACTIVE")
        local osin = animate_text(globals.curtime(), "INACTIVE", 255, 0, 0, 255)
        renderer.text(sizeX/2 + ((hide_size + inactive_size + 2)/2) * scopedFraction, sizeY/2 + 30 + globalMarginY + osPos.y, 255, 255, 255, hideInactiveFraction * 255, "-cd", hide_size + hideInactiveFraction * inactive_size + 1, "OSAA ", unpack(osin))
    
        local state_size = renderer.measure_text("-cd", '' .. string.upper(state) .. '')
        renderer.text(sizeX/2 + ((state_size + 2)/2) * scopedFraction, sizeY/2 + 30 , 255, 255, 255, 255, "-cd", 0, '' .. string.upper(state) .. '')
    end
    


    if ui.get(menu.visualsTab.min_ind_mode) ~= "-" and entity.get_classname(weapon) ~= "CKnife"  then
        local new_damage = ui.get(refs.minimum_damage)
        if ui.get(refs.minimum_damage_override[1]) and ui.get(refs.minimum_damage_override[2]) then
            new_damage = ui.get(refs.minimum_damage_override[3])
        end
    
        if new_damage ~= target_damage then
            target_damage = new_damage
            anim_start_time = globals.realtime()
        end
    
        local progress = (globals.realtime() - anim_start_time) / anim_duration
        progress = math.min(progress, 1)
    
        current_damage = lerp(current_damage, target_damage, progress)
    
        if ui.get(menu.visualsTab.min_ind) and ui.get(menu.visualsTab.min_ind_mode) == "Always" then
            if ui.get(menu.visualsTab.min_text) == "Pixel" then
                renderer.text(sizeX / 2 + 5, sizeY / 2 - 7, 255, 255, 255, 255, "-cd", 0, math.floor(current_damage))
            elseif ui.get(menu.visualsTab.min_text) == "Default" then
                renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, math.floor(current_damage))
            end
        elseif ui.get(menu.visualsTab.min_ind) and ui.get(refs.minimum_damage_override[1]) and ui.get(refs.minimum_damage_override[2]) and ui.get(menu.visualsTab.min_ind_mode) == "Bind" then
            if ui.get(menu.visualsTab.min_text) == "Pixel" then
                renderer.text(sizeX / 2 + 3, sizeY / 2 - 7, 255, 255, 255, 255, "-cd", 0, math.floor(current_damage))
            elseif ui.get(menu.visualsTab.min_text) == "Default" then
                renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, math.floor(current_damage))
            end
        end
    else
        anim_start_time = 0
        current_damage = 0
        target_damage = 0
    end

    if not ui.get(menu.visualsTab.cros_ind) and not ui.get(menu.visualsTab.debug_panel) then
        if ui.get(menu.visualsTab.wtm_style) == "Default" then
            local clr_r, clr_g, clr_b = ui.get(calar)
        
            local watermaro4ka = animate_text(globals.curtime(), lua_name .. " ~ nebula", clr_r, clr_g, clr_b, 255)
            renderer.text(sizeX/2 - renderer.measure_text("db", lua_name .. " nebula")/2, sizeY - 20, 155, 0, 0, 0, "db", nil, unpack(watermaro4ka))
        elseif ui.get(menu.visualsTab.wtm_style) == "Glowed" then
            local col1, col2, col3, col4 = ui.get(calar)
    
            local sizeX, sizeY = client.screen_size()

            local panelX, panelY = sizeX / 2 - 80, sizeY / 2 + sizeY / 2 - 30
    
            container_glow(panelX, panelY, 170, 20, col1, col2, col3, col4, 1.3, col1, col2, col3)
    
            container_glow(panelX + 30, panelY - 25, 100, 20, col1, col2, col3, col4, 1.3, col1, col2, col3)
            renderer.text(panelX + 35, panelY - 22, 255, 255, 255, 255, "Light", 0, "Anoflow ~ ")
            renderer.text(panelX + 85, panelY - 22, col1, col2, col3, 255, "Light", 0, text_fade_animation(3, col1, col2, col3, 255, script_build))

            renderer.text(panelX + 5, panelY + 3, col1, col2, col3, 255, "Light", 0, " ")
            renderer.text(panelX + 20, panelY + 3.5, 255, 255, 255, 255, "Light", 0, nick_name:sub(1, 8))
            renderer.text(panelX + 70, panelY + 3, col1, col2, col3, 255, "Light", 0, " ")
            renderer.text(panelX + 85, panelY + 3.5, 255, 255, 255, 255, "Light", 0, math.floor(get_fps()))
            renderer.text(panelX + 105, panelY + 3, col1, col2, col3, 255, "Light", 0, " ")
            renderer.text(panelX + 120, panelY + 3.5, 255, 255, 255, 255, "Light", 0, math.floor(math.min(1000, client.latency() * 1000)) .. "")
            renderer.text(panelX + 138, panelY + 3, col1, col2, col3, 255, "Light", 0, " ")
            renderer.text(panelX + 153, panelY + 3.5, 255, 255, 255, 255, "Light", 0, math.floor(get_rate()))
            
        elseif ui.get(menu.visualsTab.wtm_style) == "Modified" then
            local col1, col2, col3, col4 = ui.get(calar)
            local screen_x, screen_y = client.screen_size()
            local hud_x = screen_x / 2
            local hud_y = screen_y / 2
            local sys_h, sys_m = client.system_time()
            local time = string.format("%02d:%02d", sys_h, sys_m)
    
            local wmX, wmY = watermarkDraggable:get()
            local fpsX, fpsY = fpsDraggable:get()
            local timeX, timeY = timeDraggable:get()
            watermarkDraggable:drag(100, 20)
            fpsDraggable:drag(100, 20)
            timeDraggable:drag(40, 20)
    
            RenderRoundRectangle(wmX, wmY, 100, 20, 8, {10, 10, 10, 150})
            RenderBlurredLine(wmX + 7, wmY + 20, 90, 2, col1, col2, col3, 255, 5)
            renderer.text(wmX + 10, wmY + 4, 255, 255, 255, 255, nil, 0, "Anoflow /")
            renderer.text(wmX + 55, wmY + 4, col1, col2, col3, 255, nil, 0, text_fade_animation(3, col1, col2, col3, 255, "nebula"))

            RenderRoundRectangle(fpsX, fpsY, 100, 20, 8, {10, 10, 10, 150})
            RenderBlurredLine(fpsX + 5, fpsY + 20, 90, 2, col1, col2, col3, 255, 5)
            renderer.text(fpsX + 5, fpsY + 4, 255, 255, 255, 255, nil, 0, nick_name:sub(1, 8) .. " /")
            renderer.text(fpsX + 60, fpsY + 4, col1, col2, col3, 255, nil, 0, math.floor(get_fps()) .. "fps")

            RenderRoundRectangle(timeX, timeY, 40, 20, 8, {10, 10, 10, 150})
            RenderBlurredLine(timeX + 4, timeY + 20, 30, 2, col1, col2, col3, 255, 5)
            renderer.text(timeX + 4, timeY + 4, 255, 255, 255, 255, nil, 0, time)

        end
        
        
        --функция блять  
    end
end)

--#region ragebot

--#region resolver
ffi.cdef[[
    struct animation_layer_t
    {
        char pad20[24];
        uint32_t m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        float m_flWeightDeltaRate;
        float m_flPlaybackRate;
        float m_flCycle;
        uintptr_t m_pOwner;
        char pad_0038[4];
    };
]]

vars.classptr = ffi.typeof('void***')
vars.rawientitylist = client.create_interface('client_panorama.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)
vars.ientitylist = ffi.cast(vars.classptr, vars.rawientitylist) or error('rawientitylist is nil', 2)
vars.get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', vars.ientitylist[0][3]) or error('get_client_entity is nil', 2)

function get_anim_layer(b, c)
    c = c or 1
    b = ffi.cast(vars.classptr, b)
    return ffi.cast('struct animation_layer_t**', ffi.cast('char*', b) + 0x2990)[0][c]
end

vars.Desync = {}
for i = 1, 64, 1 do
    vars.Desync[i] = 25
end

vars.miss_counter = {}

function handle_player(current_threat)
    if current_threat == nil or not entity.is_alive(current_threat) or entity.is_dormant(current_threat) then
        return
    end
    local yaw_values_normal = { 0, 0, 60, -60 }
    local yaw_values_desync = { 45, -60, 0 }
    local counter = vars.miss_counter[current_threat] or 0
    plist.set(current_threat, "Force body yaw", true)
    plist.set(current_threat, "Correction active", true)
    if vars.Desync[current_threat] ~= nil and vars.Desync[current_threat] < 64 then
        plist.set(current_threat, "Force body yaw value", yaw_values_desync[(counter % 3) + 1] or 0)
    else
        plist.set(current_threat, "Force body yaw value", yaw_values_normal[(counter % 3) + 1] or 0)
    end
end

function update_players()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then
        return
    end
    local Players = entity.get_players(true)
    if not Players then
        return
    end
    for i, Player in pairs(Players) do
        local PlayerP = vars.get_client_entity(vars.ientitylist, Player)
        if PlayerP == nil then goto continue_loop end
        local Animlayers = {}
        Animlayers[6] = {}
        Animlayers[6]["Main"] = get_anim_layer(PlayerP, 6)
        if Animlayers[6]["Main"] == nil then goto continue_loop end
        Animlayers[6]["m_flPlaybackRate"] = Animlayers[6]["Main"].m_flPlaybackRate
        local RSideR = math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^4) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^5) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^6) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^7) % 10
        local RSideS = math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^6) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^7) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^8) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^9) % 10
        local Tmp
        if math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^3) % 10 == 0 then
            Tmp = -3.4117 * RSideS + 98.9393
        else
            Tmp = -3.4117 * RSideR + 98.9393
        end
        vars.Desync[Player] = Tmp
        handle_player(Player)
        ::continue_loop::
    end
end

event_callback("setup_command", function(cmd)
    if ui.get(menu.miscTab.resolver) then
        update_players()
    end
end)

function on_aim_miss(e)
    vars.miss_counter[e.target] = (vars.miss_counter[e.target] or 0) + 1 
end

event_callback('aim_miss', on_aim_miss)


--#end region resolver

--#region defensive resolver
local player_data = {}

function normalize_angle(angle, min_val, max_val)
    while angle > max_val do angle = angle - 360 end
    while angle < min_val do angle = angle + 360 end
    return math.max(min_val, math.min(max_val, angle))
end

function get_enemy_data(enemy)
    local enemy_idx = client.userid_to_entindex(enemy)
    if not player_data[enemy_idx] then
        player_data[enemy_idx] = {
            last_yaw = 0,
            avg_desync = 0,
            spin_speed = 0,
            desync_history = {},
            last_update_time = globals.curtime(),
            defensive_yaw_min = -180,
            defensive_yaw_max = 180,
            defensive_pitch_min = -89,
            defensive_pitch_max = 89,
            spin_history = {},
            desync_trend = 0,
            brute_state = 0,
            last_desync_switch = 0
        }
    end
    return player_data[enemy_idx]
end

function calculate_defensive_limits(enemy)
    local lower_body_yaw = entity.get_prop(enemy, "m_flLowerBodyYawTarget") or 0
    local eye_angles = {entity.get_prop(enemy, "m_angEyeAngles") or 0, 0}
    local eye_yaw, eye_pitch = eye_angles[2], eye_angles[1]

    local desync_angle = normalize_angle(eye_yaw - lower_body_yaw, -180, 180)
    local yaw_range = math.min(60, math.abs(desync_angle) + 30)
    local yaw_min = normalize_angle(lower_body_yaw - yaw_range, -180, 180)
    local yaw_max = normalize_angle(lower_body_yaw + yaw_range, -180, 180)
    local pitch_min = normalize_angle(eye_pitch - 80, -89, 89)
    local pitch_max = normalize_angle(eye_pitch + 80, -89, 89)

    return desync_angle, yaw_min, yaw_max, pitch_min, pitch_max
end

function update_enemy_data(enemy)
    local data = get_enemy_data(enemy)
    local current_time = globals.curtime()
    local time_delta = current_time - data.last_update_time
    if time_delta <= 0 then return end
    data.last_update_time = current_time

    local eye_angles = {entity.get_prop(enemy, "m_angEyeAngles") or 0, 0}
    local eye_yaw = eye_angles[2]

    local desync_angle, yaw_min, yaw_max, pitch_min, pitch_max = calculate_defensive_limits(enemy)

    table.insert(data.desync_history, desync_angle)
    if #data.desync_history > 10 then table.remove(data.desync_history, 1) end
    data.avg_desync = 0
    for _, v in ipairs(data.desync_history) do data.avg_desync = data.avg_desync + v end
    data.avg_desync = #data.desync_history > 0 and data.avg_desync / #data.desync_history or 0

    if #data.desync_history >= 2 then
        local prev_desync = data.desync_history[#data.desync_history - 1]
        data.desync_trend = desync_angle - prev_desync > 0 and 1 or -1
    end

    data.defensive_yaw_min = yaw_min
    data.defensive_yaw_max = yaw_max
    data.defensive_pitch_min = pitch_min
    data.defensive_pitch_max = pitch_max

    local spin_delta = normalize_angle(eye_yaw - data.last_yaw, -180, 180)
    data.spin_speed = math.abs(spin_delta) / time_delta
    table.insert(data.spin_history, data.spin_speed)
    if #data.spin_history > 5 then table.remove(data.spin_history, 1) end
    data.last_yaw = eye_yaw

    if math.abs(desync_angle - data.avg_desync) > 50 and current_time - data.last_desync_switch > 0.1 then
        data.last_desync_switch = current_time
        data.brute_state = (data.brute_state + 1) % 3
    end
end

function apply_resolver(enemy)
    local data = get_enemy_data(enemy)
    if not data then return end

    local eye_angles = {entity.get_prop(enemy, "m_angEyeAngles") or 0, 0}
    local correction_yaw, correction_pitch = eye_angles[2], eye_angles[1]

    if func.includes(ui.get(menu.miscTab.defensive_v), "Spin") and data.spin_speed > 40 then
        correction_yaw = normalize_angle(correction_yaw + (data.desync_trend > 0 and -90 or 90), -180, 180)
    end

    if func.includes(ui.get(menu.miscTab.defensive_v), "Pitch") and math.abs(data.avg_desync) > 25 then
        correction_pitch = normalize_angle((data.defensive_pitch_min + data.defensive_pitch_max) / 2, -89, 89)
    end

    if math.abs(data.avg_desync) > 30 then
        if data.brute_state == 1 then
            correction_yaw = normalize_angle(data.defensive_yaw_min, -180, 180)
        elseif data.brute_state == 2 then
            correction_yaw = normalize_angle(data.defensive_yaw_max, -180, 180)
        end
    end

    entity.set_prop(enemy, "m_angEyeAngles[1]", correction_yaw)
    entity.set_prop(enemy, "m_angEyeAngles[0]", correction_pitch)
end

function update_resolver()
    if not ui.get(menu.miscTab.defensive_resolver) then return end
    
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    for _, enemy in ipairs(entity.get_players(true)) do
        if entity.is_alive(enemy) then
            update_enemy_data(enemy)
            apply_resolver(enemy)
        end
    end
end
--#end region defensive reslover

local backtrack_cache = {}

function unl41(player)
    if not backtrack_cache[player] then
        backtrack_cache[player] = {}
    end

    table.insert(backtrack_cache[player], entity.get_prop(player, "m_flSimulationTime"))

    if #backtrack_cache[player] > 42 then
        table.remove(backtrack_cache[player], 1)
    end

    local last_record = backtrack_cache[player][#backtrack_cache[player]]
    if last_record then
        entity.set_prop(player, "m_flSimulationTime", last_record)
    end
end

--#region backtrack
event_callback("setup_command", function()
    if ui.get(menu.miscTab.backtrack_exploit) then
        local value = ui.get(menu.miscTab.backtrack_value)
        cvar.sv_maxunlag:set_float(value / 10)
    else
        cvar.sv_maxunlag:set_float( .2)
    end

    if ui.get(menu.miscTab.backtrack_exploit) and ui.get(menu.miscTab.backtrack_mode2) then
        local players = entity.get_players(true)
        for i = 1, #players do
            local player = players[i]
            unl41(player)
        end
    end
end)

--#end region backtrack

--#region predict

local menu_3 = {
    predict_improve = {
        args = {
            cl_interp = {
                DEFAULT = 0.015625,
                SCOUT = 0.078125,
                OTHER = 0.031000
            },
            sv_max_allowed_net_graph = {
                DEFAULT = 1,
                CHANGE = 2
            },
            cl_interpolate = {
                DEFAULT = 1,
                CHANGE = 0
            },
            cl_interp_ratio = {
                DEFAULT = 2,
                CHANGE = 1
            }
        }
    } 
}
pred_ = false

function predict()
        if ui.get(menu.miscTab.predict_enable) then
            if (func.includes(ui.get(menu.miscTab.predict_states), "Standing") and vars.pState == 2) or
            (func.includes(ui.get(menu.miscTab.predict_states), "Moving") and vars.pState == 4) or
            (func.includes(ui.get(menu.miscTab.predict_states), "Crouching") and vars.pState == 5) or
            (func.includes(ui.get(menu.miscTab.predict_states), "Sneaking") and vars.pState == 8) then
                local local_player = entity.get_local_player()
                local weapon = entity.get_player_weapon(local_player)
                cvar.sv_max_allowed_net_graph:set_int(menu_3.predict_improve.args.sv_max_allowed_net_graph.CHANGE)
                cvar.cl_interpolate:set_int(menu_3.predict_improve.args.cl_interpolate.CHANGE)
                cvar.cl_interp_ratio:set_int(menu_3.predict_improve.args.cl_interp_ratio.CHANGE)
                if entity.get_classname(weapon) == 'CWeaponSSG08' then
                    cvar.cl_interp:set_float(menu_3.predict_improve.args.cl_interp.SCOUT)
                else
                    cvar.cl_interp:set_float(menu_3.predict_improve.args.cl_interp.OTHER)
                end
                pred_ = true
            else
                cvar.sv_max_allowed_net_graph:set_int(menu_3.predict_improve.args.sv_max_allowed_net_graph.DEFAULT)
                cvar.cl_interpolate:set_int(menu_3.predict_improve.args.cl_interpolate.DEFAULT)
                cvar.cl_interp_ratio:set_int(menu_3.predict_improve.args.cl_interp_ratio.DEFAULT)
                cvar.cl_interp:set_float(menu_3.predict_improve.args.cl_interp.DEFAULT)
                pred_ = false
            end
        else
            cvar.sv_max_allowed_net_graph:set_int(menu_3.predict_improve.args.sv_max_allowed_net_graph.DEFAULT)
            cvar.cl_interpolate:set_int(menu_3.predict_improve.args.cl_interpolate.DEFAULT)
            cvar.cl_interp_ratio:set_int(menu_3.predict_improve.args.cl_interp_ratio.DEFAULT)
            cvar.cl_interp:set_float(menu_3.predict_improve.args.cl_interp.DEFAULT)
            pred_ = false
        end
end

--#end region predict

--#region aimtools
local silent_a = ref_ui("Rage", "Other", "Silent aim")
vars.dl_shot = false

aimtools_debug = function()
    if not ui.get(menu.miscTab.aim_tools_enable) then
        return
    end
    
    --[[if not entity.is_alive(entity.get_local_player()) then
        return
    end]]

    local function get_distance()
        local result = math.huge
        local heightDifference = 0
        local localplayer = entity.get_local_player()
        local lp_origin = { entity.get_origin(localplayer) }
        local entities = entity.get_players(true)

        local target = client.current_threat()
    
        for i = 1, #entities do
            local ent = entities[i]
            if ent == target and ent ~= localplayer and entity.is_alive(ent) then
                local ent_origin = { entity.get_origin(ent) }
                local distance = (vector(ent_origin[1], ent_origin[2], ent_origin[3]) - vector(lp_origin[1], lp_origin[2], lp_origin[3])):length2d()
                if distance < result then
                    result = distance
                    heightDifference = ent_origin[3] - lp_origin[3]
                end
            end
        end
    
        return math.floor(result / 10), math.floor(heightDifference)
    end

    local distance_to_enemy = { get_distance() }
    local is_higher = distance_to_enemy[2] > 50

    local baim_mode = ui.get(menu.miscTab.aim_tools_baim_mode)
    local safe_hp = ui.get(menu.miscTab.aim_tools_safe_hp)
    local baim_hp = tonumber(ui.get(menu.miscTab.aim_tools_baim_hp))

    local enemies = entity.get_players(true)

    local baim_triggers = ui.get(menu.miscTab.aim_tools_baim_trigers)
    local safe_triggers = ui.get(menu.miscTab.aim_tools_safe_trigers)

    for i, enemy_ent in ipairs(enemies) do
        local health = entity.get_prop(enemy_ent, "m_iHealth")

        if (func.includes(baim_triggers, "Enemy higher than you") and is_higher) or
           (func.includes(baim_triggers, "Enemy HP < X") and health < baim_hp) then
            plist.set(enemy_ent, "Override prefer body aim", baim_mode)
        else
            plist.set(enemy_ent, "Override prefer body aim", "-")
        end

        if (func.includes(safe_triggers, "Enemy higher than you") and is_higher) or
           (func.includes(safe_triggers, "Enemy HP < X") and health < safe_hp) then
            plist.set(enemy_ent, "Override safe point", "On")
        else
            plist.set(enemy_ent, "Override safe point", "-")
        end
    end

    local me = c_ent.get_local_player()
    local flags = me:get_prop("m_fFlags")

    local air_hc = ui.get(menu.miscTab.aim_tools_hc_air)
    local land_hc = ui.get(menu.miscTab.aim_tools_hc_land)

    if ui.get(menu.miscTab.aim_tools_hitchance) then
        ui.set_visible(refs.hitChance, false)
        ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0

        if func.in_air(entity.get_local_player()) then
            ui.set(refs.hitChance, air_hc)
        elseif ground_ticks > 5 and ground_ticks < 80 then
            ui.set(refs.hitChance, land_hc)
        else
            ui.set(refs.hitChance, L_hc)
        end
    end
    if ui.get(menu.miscTab.aim_tools_silent) then
        if func.includes(ui.get(menu.miscTab.aim_tools_silent_out), "Out of fov") then
            
        end
    end

    if ui.get(menu.miscTab.aim_tools_delay_shot) then
        local target = client.current_threat()
        local health = entity.get_prop(target, "m_iHealth")
        if (func.includes(ui.get(menu.miscTab.aim_tools_delay_states), "Standing") and vars.pState == 2) or 
        (func.includes(ui.get(menu.miscTab.aim_tools_delay_states), "Running") and vars.pState == 3) or
        (func.includes(ui.get(menu.miscTab.aim_tools_delay_states), "Moving") and vars.pState == 4) or
        (func.includes(ui.get(menu.miscTab.aim_tools_delay_states), "Crouching") and vars.pState == 5) or
        (func.includes(ui.get(menu.miscTab.aim_tools_delay_states), "Sneaking") and vars.pState == 6) or
        (ui.get(menu.miscTab.aim_tools_delay_hp) == "Lethal" and target ~= nil and health <= 90 ) or 
        (ui.get(menu.miscTab.aim_tools_delay_hp) == "Not lethal" and target ~= nil and health >= 91) or
        (ui.get(menu.miscTab.aim_tools_delay_land) and (ground_ticks > 5 and ground_ticks < 80)) then
            ui.set(refs.delay_shot[1], true)
            vars.dl_shot = true
        else
            ui.set(refs.delay_shot[1], false)
            vars.dl_shot = false
        end
    end
end

--#end region aimtools

--#region jumpscout

function jumpscout(cmd)
    if ui.get(menu.miscTab.jump_scout) then
        local vel_x, vel_y = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
        local vel = math.sqrt(vel_x^2 + vel_y^2)
        ui.set(refs.air_strafe, not (cmd.in_jump and (vel < 10)) or ui.is_menu_open())
    end
end

--#end region jumpscout

--#region chargedt

function charge_dt()
    local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
            
    if ui.get(menu.miscTab.charge_dt) then
        if not ui.get(ref.doubletap.main[2]) or not ui.get(ref.doubletap.main[1]) then
            ui.set(ref.aimbot, true)

            if callback_reg then
                unset_event_callback('run_command', check_charge)
                callback_reg = false
            end
            return
        end
        
        local_player = entity.get_local_player()
        
        if not callback_reg then
            event_callback('run_command', check_charge)
            callback_reg = true
        end
        
        local threat = client.current_threat()
        
        if not dt_charged
        and threat
        and bit.band(entity.get_prop(local_player, 'm_fFlags'), 1) == 0
        and bit.band(entity.get_esp_data(threat).flags, bit.lshift(1, 11)) == 2048 then
            ui.set(ref.aimbot, false)
        else
            ui.set(ref.aimbot, true)
        end
    end
end

--#eng region chargedt

--#end region ragebot


local skeetclantag = ui.reference('MISC', 'MISCELLANEOUS', 'Clan tag spammer')

local duration = 15
local clantags = {

'anoflow',
'anoflo-',
'anofl--',
'anof---',
'ano----',
'an-----',
'a------',
'-------',
'a------',
'an-----',
'ano----',
'anof---',
'anofl--',
'anoflo-',
'anoflow',
'-noflow',
'--oflow',
'---flow',
'----low',
'-----ow',
'------w',
'-------',
'------w',
'-----ow',
'----low',
'---flow',
'--oflow',
'-noflow',
'anoflow',

}

local empty = {''}
local clantag_prev
event_callback('net_update_end', function()
    if ui.get(skeetclantag) then 
        return 
    end

    local cur = math.floor(globals.tickcount() / duration) % #clantags
    local clantag = clantags[cur+1]

    if ui.get(menu.miscTab.clanTag) then
        if ui.get(menu.miscTab.clantag_mode) == "Anoflow" then
            if clantag ~= clantag_prev then
                clantag_prev = clantag
                client.set_clan_tag(clantag)
            end
        elseif ui.get(menu.miscTab.clantag_mode) == "#airstopgang" then
            client.set_clan_tag("#AIRSTOPGANG")
        end
    end
    if ui.get(menu.miscTab.clan_w) then
        client.set_clan_tag("#WMENTOLGANG")
    end
    if ui.get(menu.miscTab.clan_a) then
        client.set_clan_tag("#ALKAESHKAGANG")
    end
end)
ui.set_callback(menu.miscTab.clanTag, function() client.set_clan_tag('\0') end)

ui.set_callback(menu.miscTab.inf_ammo, function()
    if menu.miscTab.inf_ammo then
        cvar.sv_infinite_ammo:set_float(2)
    end
end)

function getspeed(player_index)
    return vector(entity.get_prop(player_index, "m_vecVelocity")):length()
end




ui.update(menu.configTab.list,getConfigList())
if database.read(lua.database.configs) == nil then
    database.write(lua.database.configs, {})
end
ui.set(menu.configTab.name, #database.read(lua.database.configs) == 0 and "" or database.read(lua.database.configs)[ui.get(menu.configTab.list)+1].name)
ui.set_callback(menu.configTab.list, function(value)
    local protected = function()
        if value == nil then return end
        local name = ""
    
        local configs = getConfigList()
        if configs == nil then return end
    
        name = configs[ui.get(value)+1] or ""
    
        ui.set(menu.configTab.name, name)
    end

    if pcall(protected) then

    end
end)

ui.set_callback(menu.configTab.load, function()
    local name = ui.get(menu.configTab.name)
    if name == "" then
        notifications.new( "Config name is empty", 255, 120, 120)
        return
    end

    local protected = function()
        print("Loading config: " .. name)

        local config = getConfig(name)
        if not config then
            error("Config not found: " .. name)
        end

        loadSettings(config.config)

        
        print("Config loaded successfully: " .. name)
    end

    local status, err = pcall(protected)
    if status then
        name = name:gsub('*', '')
        notifications.new(string.format('Successfully loaded "%s"', name), 0, 255, 0)
    else
        notifications.new(string.format('Failed to load "%s": %s', name, err), 255, 120, 120)
    end
end)

ui.set_callback(menu.configTab.save, function()

        local name = ui.get(menu.configTab.name)
        if name == "" then return end
    
        for i, v in pairs(presets) do
            if v.name == name:gsub('*', '') then
                notifications.new(string.format('You can`t save built-in preset "%s"', name:gsub('*', '')), 255, 120, 120)
                return
            end
        end

        if name:match("[^%w%s%p]") ~= nil then
            notifications.new(string.format('Failed to save "%s" due to invalid characters', name), 255, 120, 120)
            return
        end
    local protected = function()
        saveConfig(menu, name)
        ui.update(menu.configTab.list, getConfigList())
    end
    if pcall(protected) then
        notifications.new(string.format('Successfully saved "%s"', name), 255, 255, 255)
    end
end)

ui.set_callback(menu.configTab.create, function()
    local name = ui.get(menu.configTab.create_name)
    if name == "" then return end
    for i, v in pairs(presets) do
        if v.name == name:gsub('*', '') then
            notifications.new(string.format('You can`t create built-in preset "%s"', name:gsub('*', '')), 255, 120, 120)
            return
        end
    end
    if name:match("[^%w%s%p]") ~= nil then
        notifications.new(string.format('Failed to create "%s" due to invalid characters', name), 255, 120, 120)
        return
    end

    local protected = function()
        saveConfig(menu, name)
        ui.update(menu.configTab.list, getConfigList())
    end

    local status, err = pcall(protected)
    if status then
        name = name:gsub('*', '')
        notifications.new(string.format('Successfully created "%s"', name), 255, 255, 255)
    else
        notifications.new(string.format('Failed to created "%s": %s', name, err), 255, 120, 120)
    end
end)

ui.set_callback(menu.configTab.delete, function()
    local name = ui.get(menu.configTab.name)
    if name == "" or name == "*Default" then return end
    if deleteConfig(name) == false then
        notifications.new(string.format('Failed to delete "%s"', name), 255, 120, 120)
        ui.update(menu.configTab.list, getConfigList())
        return
    end

    for i, v in pairs(presets) do
        if v.name == name:gsub('*', '') then
            notifications.new(string.format('You can`t delete built-in preset "%s"', name:gsub('*', '')), 255, 120, 120)
            return
        end
    end

    local protected = function()
        deleteConfig(name)
    end

    if pcall(protected) then
        ui.update(menu.configTab.list, getConfigList())
        ui.set(menu.configTab.list, #presets + #database.read(lua.database.configs) - #database.read(lua.database.configs))
        ui.set(menu.configTab.name, #database.read(lua.database.configs) == 0 and "" or getConfigList()[#presets + #database.read(lua.database.configs) - #database.read(lua.database.configs)+1])
        notifications.new(string.format('Successfully deleted "%s"', name), 255, 255, 255)
    end
end)

up_down, arrow_left, arrow_right =0,0,0
event_callback("paint_ui", function()
    if ui.get(menu.visualsTab.arows_txt) then
        local scr = { client.screen_size() }
        local cvet1, cvet2, cvet3 = ui.get(menu.visualsTab.arows_txt_color)
        if entity.get_prop(entity.get_local_player(), 'm_bIsScoped') == 1 then
            if ui.get(menu.visualsTab.arows_txt_up_or_daun) == "Up" then
                up_down = -ui.get(menu.visualsTab.arows_txt_up_or_daun_offset)
            elseif ui.get(menu.visualsTab.arows_txt_up_or_daun) == "Down" then
                up_down = ui.get(menu.visualsTab.arows_txt_up_or_daun_offset)
            else
                up_down = 0
            end
        else
            up_down = 0
        end
        if vars.aa_dir == 2 then
            arrow_right = func.lerp(arrow_right, 255, globals.frametime() * 24)
        else
            arrow_right = func.lerp(arrow_right, 0, globals.frametime() * 24)
        end
        if vars.aa_dir == 1 then
            arrow_left = func.lerp(arrow_left, 255, globals.frametime() * 24)
        else
            arrow_left = func.lerp(arrow_left, 0, globals.frametime() * 24)
        end
        renderer.text(scr[1] / 2 - ui.get(menu.visualsTab.arows_txt_offset) , scr[2] / 2 + up_down, cvet1, cvet2, cvet3, arrow_left, "+cb", nil, "<") 
        renderer.text(scr[1] / 2 + ui.get(menu.visualsTab.arows_txt_offset) , scr[2] / 2 + up_down, cvet1, cvet2, cvet3, arrow_right, "+cb", nil, ">") 
    end
end)

--виев

lerpd = function(start, vend, time)
    return start + (vend - start) * time
end

local current_fov = 0
local current_x = 0
local current_y = 0
local current_z = 0

local target_fov = 68
local target_x = 0
local target_y = 0
local target_z = 0

local animation_speed = 0.1

viewmodel_ch = function()
    if ui.get(menu.visualsTab.viewmodel_en) then
        target_fov = ui.get(menu.visualsTab.viewmodel_fov)
        target_x = ui.get(menu.visualsTab.viewmodel_x) / 10
        target_y = ui.get(menu.visualsTab.viewmodel_y) / 10
        target_z = ui.get(menu.visualsTab.viewmodel_z) / 10
    else
        target_fov = 68
        target_x = 0
        target_y = 0
        target_z = 0
    end
end

local function animate_viewmodel()
    current_fov = lerpd(current_fov, target_fov, animation_speed)
    current_x = lerpd(current_x, target_x, animation_speed)
    current_y = lerpd(current_y, target_y, animation_speed)
    current_z = lerpd(current_z, target_z, animation_speed)

    client.set_cvar("viewmodel_fov", current_fov)
    client.set_cvar("viewmodel_offset_x", current_x)
    client.set_cvar("viewmodel_offset_y", current_y)
    client.set_cvar("viewmodel_offset_z", current_z)
end

client.set_event_callback("paint_ui", function()
    animate_viewmodel()
end)

ui.set_callback(menu.visualsTab.viewmodel_en, viewmodel_ch)
ui.set_callback(menu.visualsTab.viewmodel_fov, viewmodel_ch)
ui.set_callback(menu.visualsTab.viewmodel_x, viewmodel_ch)
ui.set_callback(menu.visualsTab.viewmodel_y, viewmodel_ch)
ui.set_callback(menu.visualsTab.viewmodel_z, viewmodel_ch)

clamp2 = function(v, min, max) local num = v; num = num < min and min or num; num = num > max and max or num; return num end

easing, m_alpha = require "gamesense/easing", 0

scope_overlay = ui.reference('VISUALS', 'Effects', 'Remove scope overlay')

g_paint_ui = function()
	ui.set(scope_overlay, true)
end

g_paint = function()
	ui.set(scope_overlay, false)

	local width, height = client.screen_size()
	local offset, initial_position, speed, color =
		ui.get(menu.visualsTab.custom_offset) * height / 1080, 
		ui.get(menu.visualsTab.custom_initial_pos) * height / 1080, 
		12, { ui.get(menu.visualsTab.custom_color) }

	local me = entity.get_local_player()
	local wpn = entity.get_player_weapon(me)

	local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
	local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
	local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1

	local is_valid = --[[entity.is_alive(me) and ]]wpn ~= nil and scope_level ~= nil
	local act = is_valid and scope_level > 0 and scoped and not resume_zoom

	local FT = speed > 3 and globals.frametime() * speed or 1
	local alpha = easing.linear(m_alpha, 0, 1, 1)

	renderer.gradient(width/2 - initial_position + 2, height / 2, initial_position - offset, 1, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], true)
	renderer.gradient(width/2 + offset, height / 2, initial_position - offset, 1, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, true)

	renderer.gradient(width / 2, height/2 - initial_position + 2, 1, initial_position - offset, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], false)
	renderer.gradient(width / 2, height/2 + offset, 1, initial_position - offset, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, false)
	
	m_alpha = clamp2(m_alpha + (act and FT or -FT), 0, 1)
end

ui_callback = function(c)
	local master_switch, addr = ui.get(c), ''

	if not master_switch then
		m_alpha, addr = 0, 'un'
	end
	
	local _func = client[addr .. 'set_event_callback']

	_func('paint_ui', g_paint_ui)
	_func('paint', g_paint)
end

ui.set_callback(menu.visualsTab.custom_scope, ui_callback)
ui_callback(menu.visualsTab.custom_scope)


start_time = client.unix_time()
function get_elapsed_time()
    local elapsed_seconds = client.unix_time() - start_time
    local hours = math.floor(elapsed_seconds / 3600)
    local minutes = math.floor((elapsed_seconds - hours * 3600) / 60)
    local seconds = math.floor(elapsed_seconds - hours * 3600 - minutes * 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

icon_texture = renderer.load_png(readfile("csgo/materials/panorama/images/amnesia_water.png"))


g_paint_handler = function()
    if ui.is_menu_open() then

        local menu_pos = { ui.menu_position() }
        local menu_size = { ui.menu_size() }
        local speed = globals.frametime() * 8


        local hours, minutes = client.system_time()
        local time = string.format("%02d:%02d", hours, minutes)


        if menu_pos[1] and menu_size[1] then

            renderer.gradient(
                menu_pos[1],
                menu_pos[2] - panel_height - panel_offset,
                menu_size[1],
                panel_height,
                panel_color[1], panel_color[2], panel_color[3], panel_color[4],
                panel_color[1] * 0.8, panel_color[2] * 0.8, panel_color[3] * 0.8, panel_color[4],
                true
            )


            local border_thickness = 2
            renderer.gradient(
                menu_pos[1] - border_thickness,
                menu_pos[2] - panel_height - panel_offset - border_thickness,
                menu_size[1] + border_thickness * 2,
                border_thickness,
                255, 255, 255, 50,
                255, 255, 255, 0,
                false
            )
            renderer.gradient(
                menu_pos[1] - border_thickness,
                menu_pos[2] - panel_offset,
                menu_size[1] + border_thickness * 2,
                border_thickness,
                255, 255, 255, 50,
                255, 255, 255, 0,
                false
            )
            renderer.gradient(
                menu_pos[1] - border_thickness,
                menu_pos[2] - panel_height - panel_offset,
                border_thickness,
                panel_height + border_thickness,
                255, 255, 255, 50,
                255, 255, 255, 0,
                true
            )
            renderer.gradient(
                menu_pos[1] + menu_size[1],
                menu_pos[2] - panel_height - panel_offset,
                border_thickness,
                panel_height + border_thickness,
                255, 255, 255, 50,
                255, 255, 255, 0,
                true
            )


            renderer.texture(
                icon_texture,
                menu_pos[1] + 5,
                menu_pos[2] - panel_height - panel_offset + 5,
                15, 15,
                255, 255, 255, 255
            )
            renderer.rectangle(
                menu_pos[1] + 4,
                menu_pos[2] - panel_height - panel_offset + 4,
                17, 17,
                0, 0, 0, 100
            )


            renderer.text(
                menu_pos[1] + 25 + 1,
                menu_pos[2] - panel_height - panel_offset + 6,
                0, 0, 0, 100,
                "", 0, lua_name .. " / " .. script_build
            )
            renderer.text(
                menu_pos[1] + 25,
                menu_pos[2] - panel_height - panel_offset + 5,
                text_color[1], text_color[2], text_color[3], text_color[4],
                "", 0, lua_name .. " / " .. script_build
            )


            renderer.text(
                menu_pos[1] + menu_size[1] - 51,
                menu_pos[2] - panel_height - panel_offset + 6,
                0, 0, 0, 100,
                "", 0, time
            )
            renderer.text(
                menu_pos[1] + menu_size[1] - 50,
                menu_pos[2] - panel_height - panel_offset + 5,
                text_color[1], text_color[2], text_color[3], text_color[4],
                "", 0, time
            )


            renderer.text(
                menu_pos[1] + menu_size[1] - 351,
                menu_pos[2] - panel_height - panel_offset + 6,
                0, 0, 0, 100,
                my_font, 0, nick_name
            )
            renderer.text(
                menu_pos[1] + menu_size[1] - 350,
                menu_pos[2] - panel_height - panel_offset + 5,
                text_color[1], text_color[2], text_color[3], text_color[4],
                my_font, 0, nick_name
            )
        end
    end
end


g_paint_handler_u = function()
    if ui.is_menu_open() then

        local menu_pos = { ui.menu_position() }
        local menu_size = { ui.menu_size() }
        local speed = globals.frametime() * 8

        local hours, minutes = client.system_time()
        local time = string.format("%02d:%02d", hours, minutes)

        if menu_pos[1] and menu_size[1] then
            renderer.gradient(
                menu_pos[1],
                menu_pos[2] + menu_size[2] + panel_offset,
                menu_size[1],
                panel_height,
                panel_color[1], panel_color[2], panel_color[3], panel_color[4],
                panel_color[1] * 0.8, panel_color[2] * 0.8, panel_color[3] * 0.8, panel_color[4],
                true
            )

            local border_thickness = 2
            renderer.gradient(
                menu_pos[1] - border_thickness,
                menu_pos[2] + menu_size[2] + panel_offset,
                menu_size[1] + border_thickness * 2,
                border_thickness,
                255, 255, 255, 50,
                255, 255, 255, 0,
                false
            )
            renderer.gradient(
                menu_pos[1] - border_thickness,
                menu_pos[2] + menu_size[2] + panel_offset + panel_height,
                menu_size[1] + border_thickness * 2,
                border_thickness,
                255, 255, 255, 50,
                255, 255, 255, 0,
                false
            )
            renderer.gradient(
                menu_pos[1] - border_thickness,
                menu_pos[2] + menu_size[2] + panel_offset,
                border_thickness,
                panel_height + border_thickness,
                255, 255, 255, 50,
                255, 255, 255, 0,
                true
            )
            renderer.gradient(
                menu_pos[1] + menu_size[1],
                menu_pos[2] + menu_size[2] + panel_offset,
                border_thickness,
                panel_height + border_thickness,
                255, 255, 255, 50,
                255, 255, 255, 0,
                true
            )

            renderer.texture(
                icon_texture,
                menu_pos[1] + 5,
                menu_pos[2] + menu_size[2] + panel_offset + 5,
                15, 15,
                255, 255, 255, 255
            )
            renderer.rectangle(
                menu_pos[1] + 4,
                menu_pos[2] + menu_size[2] + panel_offset + 4,
                17, 17,
                0, 0, 0, 100
            )

            renderer.text(
                menu_pos[1] + 25 + 1,
                menu_pos[2] + menu_size[2] + panel_offset + 6,
                0, 0, 0, 100,
                "", 0, lua_name .. " / " .. script_build
            )
            renderer.text(
                menu_pos[1] + 25,
                menu_pos[2] + menu_size[2] + panel_offset + 5,
                text_color[1], text_color[2], text_color[3], text_color[4],
                "", 0, lua_name .. " / " .. script_build
            )

            renderer.text(
                menu_pos[1] + menu_size[1] - 51,
                menu_pos[2] + menu_size[2] + panel_offset + 6,
                0, 0, 0, 100,
                "", 0, time
            )
            renderer.text(
                menu_pos[1] + menu_size[1] - 50,
                menu_pos[2] + menu_size[2] + panel_offset + 5,
                text_color[1], text_color[2], text_color[3], text_color[4],
                "", 0, time
            )

            renderer.text(
                menu_pos[1] + menu_size[1] - 351,
                menu_pos[2] + menu_size[2] + panel_offset + 6,
                0, 0, 0, 100,
                my_font, 0, nick_name
            )
            renderer.text(
                menu_pos[1] + menu_size[1] - 350,
                menu_pos[2] + menu_size[2] + panel_offset + 5,
                text_color[1], text_color[2], text_color[3], text_color[4],
                my_font, 0, nick_name
            )
        end
    end
end


lerp = function(start, vend, time)
    return start + (vend - start) * time
end

current_aspect = 0
target_aspect = 0

animation_speed2 = 0.1

function update_aspect()
    if ui.get(menu.visualsTab.asp) then
        target_aspect = ui.get(menu.visualsTab.asp_v) / 50
    else
        target_aspect = 0
    end
end

function animate_aspect()
    current_aspect = lerp(current_aspect, target_aspect, animation_speed2)

    client.set_cvar("r_aspectratio", current_aspect)
end

client.set_event_callback("paint", function()
    animate_aspect()
end)

ui.set_callback(menu.visualsTab.asp, update_aspect)
ui.set_callback(menu.visualsTab.asp_v, update_aspect)


function tpdistance()
    if ui.get(menu.visualsTab.third_) then
	    client.exec("cam_idealdist ", ui.get(menu.visualsTab.third_dis))
    else
        client.exec("cam_idealdist ", 100)
    end
end
ui.set_callback(menu.visualsTab.third_dis, tpdistance)


event_callback("aim_fire", function(e)
    wanted_dmg = e.damage
    wanted_hitbox = hitgroup_names[e.hitgroup + 1] or "?"
end)
event_callback("aim_hit", function(e)
    if not ui.get(menu.miscTab.console_logs) then return end

    local function color_log(r, g, b, text)
        client.color_log(r, g, b, text .. "\0")
    end

    local who = entity.get_player_name(e.target)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local dmg = e.damage
    local health = entity.get_prop(e.target, "m_iHealth")
    local bt = globals.tickcount() - e.tick
    local hc = math.floor(e.hit_chance)

    local r, g, b, a = ui.get(calar)

    local is_alive = health ~= 0
    local prefix = is_alive and "hit" or "killed"
    local color = is_alive and {r, g, b} or {255, 50, 50}

    color_log(color[1], color[2], color[3], "anoflow ~ ")
    color_log(color[1], color[2], color[3], prefix .. " ")
    color_log(200, 200, 200, who .. " ")
    color_log(color[1], color[2], color[3], "in " .. group .. " ")
    color_log(200, 200, 200, "(" .. dmg .. "dmg) ")

    if is_alive then
        color_log(200, 200, 200, "| " .. health .. "hp ")
    end

    color_log(200, 200, 200, "| bt:" .. bt .. "t ")
    color_log(200, 200, 200, "| hc:" .. hc .. "%\n")
end)

event_callback("aim_miss", function(e)
    if not ui.get(menu.miscTab.console_logs) then return end

    local function color_log(r, g, b, text)
        client.color_log(r, g, b, text .. "\0")
    end

    local who = entity.get_player_name(e.target)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local reason = e.reason
    local bt = globals.tickcount() - e.tick
    local hc = math.floor(e.hit_chance)

    if reason == "?" then
        if ui.get(menu.miscTab.console_logs_custom_vibor) then
            if ui.get(menu.miscTab.console_logs_resolver) == "resolver" then
                reason = "resolver"
            elseif ui.get(menu.miscTab.console_logs_resolver) == "unknown" then
                reason = "unknown"
            elseif ui.get(menu.miscTab.console_logs_resolver) == "correction" then
                reason = "correction"
            elseif ui.get(menu.miscTab.console_logs_resolver) == "custom" then
                reason = ui.get(menu.miscTab.console_logs_custom)
            end
        else
            reason = "?"
        end
    end

    local r, g, b, a = ui.get(calar)

    local highlight_color = {r, g, b}
    if e.reason == "spread" then
        highlight_color = {255, 255, 0}
    elseif e.reason == "?" then
        highlight_color = {255, 165, 0}
    end

    color_log(highlight_color[1], highlight_color[2], highlight_color[3], "anoflow ~ ")
    color_log(200, 200, 200, "missed to ")
    color_log(highlight_color[1], highlight_color[2], highlight_color[3], who .. " ")
    color_log(200, 200, 200, "in ")
    color_log(highlight_color[1], highlight_color[2], highlight_color[3], group .. " ")
    color_log(200, 200, 200, "due to ")
    color_log(highlight_color[1], highlight_color[2], highlight_color[3], reason .. " ")
    color_log(200, 200, 200, "| bt:" .. bt .. " ")
    color_log(200, 200, 200, "| hc:" .. hc .. "%\n")
end)

function aim_hit(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"


    if ui.get(menu.visualsTab.on_screen_logs) and func.includes(ui.get(menu.visualsTab.on_screen_v), "On hit") then
        notifications.new(string.format("\a75DB67FFHit \aFFFFFFFF%s in the %s for \a75DB67FF%d \aFFFFFFFFdamage (%d remaining)", entity.get_player_name(e.target), group, e.damage, entity.get_prop(e.target, "m_iHealth") ), 255,255,255,255) 
    end
end

event_callback("aim_hit", aim_hit)

function aim_miss(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"

    if ui.get(menu.visualsTab.on_screen_logs) and func.includes(ui.get(menu.visualsTab.on_screen_v), "On miss") then
        notifications.new(string.format("\aE05C5CFFMissed \aFFFFFFFF%s (%s) due to \aE05C5CFF%s", entity.get_player_name(e.target), group, e.reason), 255,255,255,255)
    end
end

event_callback("aim_miss", aim_miss)

lastmiss2 = 0
last_hurt_time = 0

event_callback("player_hurt", function(cmd)
    local victim = client.userid_to_entindex(cmd.userid)
    if victim == entity.get_local_player() then
        last_hurt_time = globals.curtime()
    end
end)

event_callback("bullet_impact", function(cmd)
    if not entity.is_alive(entity.get_local_player()) then return end
    local ent = client.userid_to_entindex(cmd.userid)
    if ent ~= client.current_threat() then return end
    if entity.is_dormant(ent) or not entity.is_enemy(ent) then return end

    if globals.curtime() - last_hurt_time < 0.5 then return end

    local ent_origin = { entity.get_prop(ent, "m_vecOrigin") }
    ent_origin[3] = ent_origin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
    local local_head = { entity.hitbox_position(entity.get_local_player(), 0) }
    local closest = GetClosestPoint(ent_origin, { cmd.x, cmd.y, cmd.z }, local_head)
    local delta = { local_head[1]-closest[1], local_head[2]-closest[2] }
    local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)

    if math.abs(delta_2d) <= 80 and globals.curtime() - lastmiss2 > 0.015 then
        if ui.get(menu.visualsTab.on_screen_logs) and func.includes(ui.get(menu.visualsTab.on_screen_v), "Evaded shot") then
            notifications.new("Evaded miss from: "..entity.get_player_name(ent), 255, 255, 255)
        end
        lastmiss2 = globals.curtime()
        data.stats.evaded = data.stats.evaded + 1
    end
end)

event_callback('paint_ui', function ()
    local isAATab = ui.get(tabPicker) == " Anti-aim" and ui.get(aaTabs) == " Settings"
    if isAATab then
        traverse_table_on(binds)
        else
            traverse_table(binds)
    end 
    if (globals.mapname() ~= vars.mapname) then
        vars.breaker.cmd = 0
        vars.breaker.defensive = 0
        vars.breaker.defensive_check = 0
        vars.mapname = globals.mapname()
    end
end)

event_callback("round_start", function()
    vars.breaker.cmd = 0
    vars.breaker.defensive = 0
    vars.breaker.defensive_check = 0
end)

event_callback("player_connect_full", function(e)
    local ent = client.userid_to_entindex(e.userid)
    if ent == entity.get_local_player() then
        vars.breaker.cmd = 0
        vars.breaker.defensive = 0
        vars.breaker.defensive_check = 0
    end
end)


dragging2 = (function()
    local a = {}
    local b, c, d, e, f, g, h, i, j, k, l, m, n, o

    local p = {
        __index = {
            drag = function(self, ...)
                local q, r = self:get()
                local s, t = a.drag(q, r, ...)
                if q ~= s or r ~= t then
                    self:set(s, t)
                end
                return s, t
            end,
            set = function(self, q, r)
                local j, k = client.screen_size()
                ui.set(self.x_reference, q / j * self.res)
                ui.set(self.y_reference, r / k * self.res)
            end,
            get = function(self)
                local j, k = client.screen_size()
                return ui.get(self.x_reference) / self.res * j, ui.get(self.y_reference) / self.res * k
            end
        }
    }

    function a.new(u, v, w, x)
        x = x or 10000
        local j, k = client.screen_size()
        local y = ui.new_slider('LUA', 'A', u .. ' window position', 0, x, v / j * x)
        local z = ui.new_slider('LUA', 'A', '\n' .. u .. ' window position y', 0, x, w / k * x)
        ui.set_visible(y, false)
        ui.set_visible(z, false)
        return setmetatable({ name = u, x_reference = y, y_reference = z, res = x }, p)
    end

    function a.drag(q, r, A, B, C, D, E)
        if globals.framecount() ~= b then
            c = ui.is_menu_open()
            f, g = d, e
            d, e = ui.mouse_position()
            i = h
            h = client.key_state(0x01) == true
            m = l
            l = {}
            o = n
            n = false
            j, k = client.screen_size()
        end

        if c and i ~= nil then
            if (not i or o) and h and f > q and g > r and f < q + A and g < r + B then
                n = true
                q, r = q + d - f, r + e - g
                if not D then
                    q = math.max(0, math.min(j - A, q))
                    r = math.max(0, math.min(k - B, r))
                end
            end
        end

        table.insert(l, { q, r, A, B })
        return q, r, A, B
    end

    return a
end)()


dragginger = (function()
    local a = {}
    local b, c, d, e, f, g, h, i, j, k, l, m, n, o

    local p = {
        __index = {
            drag = function(self, ...)
                local q, r = self:get()
                local s, t = a.drag(q, r, ...)
                if q ~= s or r ~= t then
                    self:set(s, t)
                end
                return s, t
            end,
            set = function(self, q, r)
                local j, k = client.screen_size()
                ui.set(self.x_reference, q / j * self.res)
                ui.set(self.y_reference, r / k * self.res)
            end,
            get = function(self)
                local j, k = client.screen_size()
                return ui.get(self.x_reference) / self.res * j, ui.get(self.y_reference) / self.res * k
            end
        }
    }

    function a.new(u, v, w, x)
        x = x or 10000
        local j, k = client.screen_size()
        local y = ui.new_slider('LUA', 'A', u .. ' window position', 0, x, v / j * x)
        local z = ui.new_slider('LUA', 'A', '\n' .. u .. ' window position y', 0, x, w / k * x)
        ui.set_visible(y, false)
        ui.set_visible(z, false)
        return setmetatable({ name = u, x_reference = y, y_reference = z, res = x }, p)
    end

    function a.drag(q, r, A, B, C, D, E)
        if globals.framecount() ~= b then
            c = ui.is_menu_open()
            f, g = d, e
            d, e = ui.mouse_position()
            i = h
            h = client.key_state(0x01) == true
            m = l
            l = {}
            o = n
            n = false
            j, k = client.screen_size()
        end

        if c and i ~= nil then
            if (not i or o) and h and f > q and g > r and f < q + A and g < r + B then
                n = true
                q, r = q + d - f, r + e - g
                if not D then
                    q = math.max(0, math.min(j - A, q))
                    r = math.max(0, math.min(k - B, r))
                end
            end
        end

        table.insert(l, { q, r, A, B })
        return q, r, A, B
    end

    return a
end)()


local panelDragger = dragginger.new("Debug Panel", 200, 200)

anoflow.level_system = {
    xp = 0,
    level = 0 
}

local level_file = "csgo/cache/level.txt"
local level_data_file = "csgo/cache/level_data.txt"

function load_level_data()
    local file_content = readfile(level_data_file)
    if file_content then
        local level, xp = file_content:match("(%d+),(%d+)")
        if level and xp then
            return tonumber(level), tonumber(xp)
        end
    end
    return 0, 0
end


function save_level_data()
    writefile(level_data_file, anoflow.level_system.level .. "," .. anoflow.level_system.xp)
end

anoflow.level_system.level, anoflow.level_system.xp = load_level_data()



function calculate_level_and_progress(level)
    local current_level = anoflow.level_system.level
    local threshold = 100 + (current_level * 100)
    local remaining_level = level

    local current_progress = (remaining_level / threshold) * 100
    return current_level, current_progress, threshold
end

function draw_progress_bar(x, y, width, height, level, r, g, b, a)

    local current_level, current_progress, threshold = calculate_level_and_progress(level)

    local filled_width = (current_progress / 100) * width

    renderer.rectangle(x, y, width, height, 50, 50, 50, a)

    renderer.rectangle(x, y, filled_width, height, r, g, b, a)

    renderer.gradient(x, y, filled_width, height, r, g, b, a, r, g, b, a, true)

    renderer.rectangle(x - 1, y - 1, width + 2, height + 2, 0, 0, 0, 150)

    renderer.text(x + width + 5, y - 4, 255, 255, 255, 255, nil, 0, "Level: " .. current_level)
    renderer.text(x + width + 5, y + 4, 255, 255, 255, 255, nil, 0, "XP: " .. level .. "/" .. threshold)

end

level_drag = dragging2.new("Level System", 100, 100)

function on_paint()
    local width, height = 100, 5
    local r, g, b, a = 0, 255, 0, 255

    local level_X, level_Y = level_drag:drag(width, height)

    draw_progress_bar(level_X, level_Y, width, height, anoflow.level_system.xp, r, g, b, a)

end

event_callback("paint", on_paint)

local my = {
    entity = entity.get_local_player()
}

event_callback("player_death", function(event)
    local target = client.userid_to_entindex(event.userid)
    local attacker = client.userid_to_entindex(event.attacker)
    --if entity.get_prop(entity.get_player_resource(), "m_iPing", target) == 0 then return end

    if target == my.entity then
        return
    end

    if target ~= my.entity and attacker == my.entity then
        anoflow.level_system.xp = anoflow.level_system.xp + client.random_int(5, 20)
        local _, _, threshold = calculate_level_and_progress(anoflow.level_system.xp)

        if anoflow.level_system.xp >= threshold then
            anoflow.level_system.level = anoflow.level_system.level + 1
            anoflow.level_system.xp = 0
        end
        save_level_data()
    end
end)

function d_lerp(a, b, t)
    return a + (b - a) * t
end

degree_to_radian = function(degree)
	return (math.pi / 180) * degree
end

angle_to_vector = function(x, y)
	local pitch = degree_to_radian(x)
	local yaw = degree_to_radian(y)
	return math.cos(pitch) * math.cos(yaw), math.cos(pitch) * math.sin(yaw), -math.sin(pitch)
end

set_movement = function(cmd, desired_pos)
    local local_player = entity.get_local_player()
	local vec_angles = {
		vector(
			entity.get_origin( local_player )
		):to(
			desired_pos
		):angles()
	}

    local pitch, yaw = vec_angles[1], vec_angles[2]

    cmd.in_forward = 1
    cmd.in_back = 0
    cmd.in_moveleft = 0
    cmd.in_moveright = 0
    cmd.in_speed = 0
    cmd.forwardmove = 800
    cmd.sidemove = 0
    cmd.move_yaw = yaw
end


do_return = function(cmd)
	if bot_data.start_position and bot_data.should_return then
		local lp_origin = vector(entity.get_origin(entity.get_local_player()))
		if bot_data.start_position:dist2d(lp_origin) > 5 then
            if not client.key_state(0x57) and not client.key_state(0x41) and not client.key_state(0x53) and not client.key_state(0x44) and not ui.get(refs.quickPeek[2]) then
			    set_movement( cmd, bot_data.start_position )
            end
		else
			bot_data.should_return = false
            bot_data.shot_fired = false
            bot_data.reached_max_distance = false
		end
	end
end

peek_bot = function(cmd)
    ui.set(menu.miscTab.ai_peek_key, "on hotkey")
    local frametime = globals.frametime() * 15
    bot_data.lerp_distance = d_lerp(bot_data.lerp_distance, ui.get(menu.miscTab.ai_peek) and 70 or 0, frametime)

    if not ui.get(menu.miscTab.ai_peek) then return end

    if not ui.get(menu.miscTab.ai_peek_key) then 
        bot_data.set_location = true 
        bot_data.lerp_distance = 0
        return 
    end
    
    local lp_eyepos = vector(client.eye_position())
    local lp_origin = vector(entity.get_origin(entity.get_local_player()))

    if bot_data.set_location then
        bot_data.start_position = lp_origin
        bot_data.set_location = false
    end


    do_return(cmd)

    local target = client.current_threat()
    if not target or entity.is_dormant(target) then return end

    if bot_data[target] == nil then
        bot_data[target] = {
            head = false,
            chest = false,
            stomach = false,
            left_arm = false,
            right_arm = false,
            left_leg = false,
            right_leg = false
        }
    end

    local enemy_origin = vector(entity.get_origin(target))

	local enemy_x, enemy_y = lp_eyepos.x - enemy_origin.x, lp_eyepos.y - enemy_origin.y
	local enemy_ang = math.atan2(enemy_y, enemy_x) * (180 / math.pi)
	local left_x, left_y, left_z = angle_to_vector(0, enemy_ang - 90)
    local right_x, right_y, right_z = angle_to_vector(0, enemy_ang + 90)

    local eye_left = vector(left_x * math.max(0,bot_data.lerp_distance - bot_data.calculate_wall_dist_left) + lp_eyepos.x, left_y * math.max(0,bot_data.lerp_distance - bot_data.calculate_wall_dist_left) + lp_eyepos.y, lp_eyepos.z)
	local eye_right = vector(right_x * math.max(0,bot_data.lerp_distance - bot_data.calculate_wall_dist_right) + lp_eyepos.x, right_y * math.max(0,bot_data.lerp_distance - bot_data.calculate_wall_dist_right) + lp_eyepos.y, lp_eyepos.z)
    local eye_left_ext = vector(left_x * bot_data.lerp_distance*1.2 + lp_eyepos.x, left_y * bot_data.lerp_distance*1.2 + lp_eyepos.y, lp_eyepos.z)
	local eye_right_ext = vector(right_x * bot_data.lerp_distance*1.2 + lp_eyepos.x, right_y * bot_data.lerp_distance*1.2 + lp_eyepos.y, lp_eyepos.z)

    bot_data.cache_eye_left = eye_left
    bot_data.cache_eye_right = eye_right

    for i, v in pairs(hitboxes.ind) do
        hitbox = vector(entity.hitbox_position(target, v))

        left, damage_left = client.trace_bullet(entity.get_local_player(), eye_left.x, eye_left.y, eye_left.z, hitbox.x, hitbox.y, hitbox.z, false)
        right, damage_right = client.trace_bullet(entity.get_local_player(), eye_right.x, eye_right.y, eye_right.z, hitbox.x, hitbox.y, hitbox.z, false)

        trace_wall_left = client.trace_line(0, eye_left.x, eye_left.y, eye_left.z, eye_left_ext.x, eye_left_ext.y, eye_left_ext.z)
        trace_wall_right = client.trace_line(0, eye_right.x, eye_right.y, eye_right.z, eye_right_ext.x, eye_right_ext.y, eye_right_ext.z)
        
        if trace_wall_left ~= 1 then
            bot_data.calculate_wall_dist_left = (1 - trace_wall_left)*(70/(70/100))
        else
            bot_data.calculate_wall_dist_left = 0
        end

        if trace_wall_right ~= 1 then
            bot_data.calculate_wall_dist_right = (1 - trace_wall_right)*(70/(70/100))
        else
            bot_data.calculate_wall_dist_right = 0
        end

        if left or right then
            bot_data[target][hitboxes.name[v]] = true

            if left and not bot_data.right_trace_active then
                bot_data.tracer_position = eye_left
                bot_data.left_trace_active = true
            else
                bot_data.left_trace_active = false
            end
    
            if right and not bot_data.left_trace_active then
                bot_data.tracer_position = eye_right
                bot_data.right_trace_active = true
            else
                bot_data.right_trace_active = false
            end
        else
            bot_data[target][hitboxes.name[v]] = false
        end
    end

    if bot_data[target].head or bot_data[target].chest or bot_data[target].stomach or bot_data[target].left_arm or bot_data[target].right_arm or bot_data[target].left_leg or bot_data[target].right_leg then
        bot_data.peekbot_active = true
    elseif not bot_data[target].head and not bot_data[target].chest and not bot_data[target].stomach and not bot_data[target].left_arm and not bot_data[target].right_arm and not bot_data[target].left_leg and not bot_data[target].right_leg then
        bot_data.peekbot_active = false
    end

    if bot_data.start_position:dist2d(lp_origin) > 70 then
        bot_data.reached_max_distance = true
    end
    
    if bot_data.peekbot_active and not bot_data.shot_fired and (bot_data.reload_timer < globals.realtime()) and not bot_data.reached_max_distance then

        if bot_data.peekbot_active and bot_data.left_trace_active then
			set_movement(cmd, eye_left)
        elseif bot_data.peekbot_active and bot_data.right_trace_active then
			set_movement(cmd, eye_right)
        end

    else
        bot_data.should_return = true
    end
end

function renderer_trace_positions()
    if ui.get(menu.miscTab.ai_peek) and ui.get(menu.miscTab.ai_peek_key) then
        local r, g, b = 149, 255, 162
        local text = "AI PEEK"

        if bot_data.peekbot_active then
            if bot_data.left_trace_active then
                r, g, b = 255, 100, 100
                text = "AI PEEK / LEFT"
            elseif bot_data.right_trace_active then
            r, g, b = 100, 100, 255
                text = "AI PEEK / RIGHT"
            end
        end

        renderer.indicator(r, g, b, 255, text)
    end
end


function debug_new()
    if ui.get(menu.visualsTab.debug_panel) then
        local threat = client.current_threat()
        local target = "unknown"
        local threat_desync = 0
        if threat then
            target = entity.get_player_name(threat) or "unknown"
            threat_desync = math.floor(entity.get_prop(threat, 'm_flPoseParameter', 11) * 120 - 60)
        end
        local state = "Running"
        local state = vars.intToS[vars.pState]:upper()
        local col1, col2, col3, col4 = ui.get(calar)
        local r_mode = ui.get(menu.miscTab.rs_mode)

        local panelX, panelY = panelDragger:get()
        container_glow(panelX, panelY, 130, 80, col1, col2, col3, col4, 1.4, col1, col2, col3)

        renderer.text(panelX + 5, panelY + 3, 255, 255, 255, 255, "Light", 0, "• anoflow")
        renderer.text(panelX + 54, panelY + 3, col1, col2, col3, 255, "Light", 0, script_build)
        renderer.text(panelX + 5, panelY + 15.5, 255, 255, 255, 255, "Light", 0, "• user:")
        renderer.text(panelX + 50, panelY + 15.5, col1, col2, col3, 255, "Light", 0, nick_name)
        renderer.text(panelX + 5, panelY + 28, 255, 255, 255, 255, "Light", 0, "• build:")
        renderer.text(panelX + 52, panelY + 28, col1, col2, col3, 255, "Light", 0, "dev")
        renderer.text(panelX + 5, panelY + 40.5, 255, 255, 255, 255, "Light", 0, "• target:")
        renderer.text(panelX + 52, panelY + 40.5, col1, col2, col3, 255, "Light", 0, string.lower(target:sub(1, 10)).. " " ..math.abs(threat_desync).."°")
        renderer.text(panelX + 5, panelY + 53, 255, 255, 255, 255, "Light", 0, "• state:")
        renderer.text(panelX + 52, panelY + 53, col1, col2, col3, 255, "Light", 0, string.lower(state))
        renderer.text(panelX + 5, panelY + 65.5, 255, 255, 255, 255, "Light", 0, "• resolver:")
        if ui.get(menu.miscTab.resolver) then
            renderer.text(panelX + 60, panelY + 65.5, col1, col2, col3, 255, "Light", 0, string.lower(r_mode))
        else
            renderer.text(panelX + 60, panelY + 65.5, col1, col2, col3, 255, "Light", 0, "gamesense")
        end

        panelDragger:drag(130, 80)
    end
end
intersect = function(x, y, w, h)
    local cx, cy = ui.mouse_position()
    return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

checkboxes = function(checkbox_name,checkbox_state,x,y)

    local color = {63,63,63,255}

    if intersect(x,y - 35 + dbs.size,55,10) then

        if client.key_state(0x1) then

            if clicked == false then
                ui.set(checkbox_state,not ui.get(checkbox_state)) 
            end
            clicked = true
            
        else
            clicked = false
        end
   
    end

    if ui.get(checkbox_state) then
        color = {255,255,255,255}
    else
        color = {24,24,24,255}
    end

    renderer.rectangle(x - 1,y - 35 + dbs.size,8,8,24,24,24,255)
    renderer.rectangle(x, y - 34 + dbs.size,6,6, color[1],color[2],color[3],color[4])
    renderer.text(x + 10, y - 37 + dbs.size,255,255,255,255,"-",0,string.upper(checkbox_name))

    dbs.size = dbs.size + 10
     
end

slider_e = function(slider_name,slider_value,min_value,max_value,slider_addition,x,y)

    local slider_text_bool = 0
    if slider_name ~= "" then
        slider_text_bool = 12
    else
        slider_text_bool = 0
    end
  
    
    if slider_name ~= "" then
        renderer.text(x - 1,y- 35 + dbs.size,220,220,220,255,"-",0,string.upper(slider_name))
    end
    local mpos =  vector(ui.mouse_position())


   
     
    

    if intersect(x - 1,y - 36 + dbs.size + slider_text_bool,60,4) then
        slider_data.hovered_another = true
        dbs.should_drag = false
        if client.key_state(0x1) then
            
            ui.set(slider_value, math.max(min_value,math.min(max_value,math.floor(min_value + (max_value - min_value) * ((mpos.x  - (x - 1)) / 60)))))
            slider_data.ref = slider_value

            slider_data.last_item = true
        end
    end

    
    if slider_data.last_item then
        if client.key_state(0x25) then
            if is_math == false or start_timer > 200 then
                ui.set(slider_data.ref,math.max(min_value,math.min(max_value,ui.get(slider_data.ref) - 1)))
                if start_timer > 200 then
                    start_timer = 0
                end 
            end
            start_timer = start_timer + 1
            is_math = true
        elseif  client.key_state(0x27) then
            if is_math == false or start_timer > 200 then
                ui.set(slider_data.ref,math.max(min_value,math.min(max_value,ui.get(slider_data.ref) + 1)))
                if start_timer > 200 then
                    start_timer = 0
                end 
            end
            start_timer = start_timer + 1
            is_math = true
        else
            is_math = false
            start_timer = 0
        end
    end


    local base = (ui.get(slider_value) - min_value) / (max_value - min_value) * 60
   
   
    renderer.rectangle(x,y - 35 + dbs.size + slider_text_bool,60,2,24,24,24,255)
    renderer.rectangle(x,y - 35 + dbs.size + slider_text_bool,base,2,220,220,220,255)
    renderer.circle(x + base, y - 34 + dbs.size + slider_text_bool , 220,220,220,255, 3, 0, 1)
    
  
    
    dbs.size = dbs.size + (slider_name ~= "" and 17 or 12)
end

round_rectangle = function(x, y, w, h, r, g, b, a, thickness)
    renderer.rectangle(x, y, w, h, r, g, b, a)
    renderer.circle(x, y, r, g, b, a, thickness, -180, 0.25)
    renderer.circle(x + w, y, r, g, b, a, thickness, 90, 0.25)
    renderer.rectangle(x, y - thickness, w, thickness, r, g, b, a)
    renderer.circle(x + w, y + h, r, g, b, a, thickness, 0, 0.25)
    renderer.circle(x, y + h, r, g, b, a, thickness, -90, 0.25)
    renderer.rectangle(x, y + h, w, thickness, r, g, b, a)
    renderer.rectangle(x - thickness, y, thickness, h, r, g, b, a)
    renderer.rectangle(x + w, y, thickness, h, r, g, b, a)
end
function slow_e(w, h)
    if not (ui.get(menu.visualsTab.slow_down)) or not entity.is_alive(entity.get_local_player()) and ui.is_menu_open() or not entity.is_alive(entity.get_local_player()) then
        return 
    end

    local slowdowncolor = { 255, 255, 255, 200 }
    local slow_status = math.floor(entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") * 100)

    if slow_status < 100 and slow_status > 0 then

        
       
        local percentage = slow_status * ui.get(menu.visualsTab.widgets_slow_length) / 100


        if ui.get(menu.extras.icon1) then 
            local add = ui.get(menu.extras.text1) and 16 or 0
            slow_turtle_pos = math.lerp(slow_turtle_pos, w / 2 - 12.5,globals.frametime() * 10)
            renderer.texture(slow_turtle,slow_turtle_pos,dbs.slow_y-30 - add, 25 , 25, 255,255,255,255,"f")
        end

        if func.includes(ui.get(menu.visualsTab.widgets_slow), "Show procents") then 
            renderer.text(dbs.slow_x,dbs.slow_y - 12,255,255,255,255,"c",0,100 - slow_status .. "%")
        end


        renderer.rectangle(dbs.slow_x - ui.get(menu.visualsTab.widgets_slow_length) / 2 - 1,dbs.slow_y - 4,ui.get(menu.visualsTab.widgets_slow_length) + 2, ui.get(menu.visualsTab.widgets_slow_width) + 4,0,0,0,130)
        
    
    

        local slowdowncolor = ui.get(menu.visualsTab.slow_down) and  func.includes(ui.get(menu.visualsTab.widgets_slow), "Dynamic color") and {255 - (slow_status*2),2.55 * slow_status,0,slowdowncolor[4]} or { 255, 255, 255, 255 }
        
        if ui.get(menu.visualsTab.slow_down) and  func.includes(ui.get(menu.visualsTab.widgets_slow), "Blackout") then 
            renderer.gradient(dbs.slow_x - ui.get(menu.visualsTab.widgets_slow_length) / 2 + 1,dbs.slow_y - 2,percentage, ui.get(menu.visualsTab.widgets_slow_width), slowdowncolor[1], slowdowncolor[2], slowdowncolor[3],slowdowncolor[4],12, 12, 12,130,true)
        else
            renderer.rectangle(dbs.slow_x - ui.get(menu.visualsTab.widgets_slow_length) / 2 + 1,dbs.slow_y - 2, percentage, ui.get(menu.visualsTab.widgets_slow_width), slowdowncolor[1], slowdowncolor[2], slowdowncolor[3],255)
        end

        return
    end

    slow_turtle_pos = w / 2 - 110
end
function slow_a(w, h)
    if ui.is_menu_open() and (ui.get(menu.visualsTab.slow_down)) then 

        local cx,cy = ui.mouse_position()

        if dbs.is_dragging and not client.key_state(0x01) then 
            dbs.is_dragging = false 
        end
    
        if dbs.is_dragging and client.key_state(0x01) and dbs.last_item == "Slow" then 
            dbs.slow_x = cx - dbs.drag_slow_x
            dbs.slow_y = cy - dbs.drag_slow_y
        end
    
       
        if intersect(dbs.slow_x - ui.get(menu.extras.length) / 2,dbs.slow_y - 10,ui.get(menu.extras.length),20) and client.key_state(0x01) then 
            dbs.last_item = "Slow"
            dbs.is_dragging = true 
            dbs.drag_slow_x = cx - dbs.slow_x
            dbs.drag_slow_y = cy - dbs.slow_y
            dbs.slow_menu = false
            should_shoot = false
        end

        if intersect(dbs.slow_x - ui.get(menu.extras.length) / 2,dbs.slow_y - 10,ui.get(menu.extras.length),20) and client.key_state(0x02) then 
            dbs.slow_menu = true
            dbs.defensive_menu = false
            should_shoot = false
        end

        if ui.get(menu.extras.icon1) then 

            local add = func.includes(ui.get(menu.visualsTab.widgets_slow), "Show procents") and 16 or 0
            renderer.texture(slow_turtle,dbs.slow_x - 25/2,dbs.slow_y-30 - add, 25 , 25, 255,255,255,255,"f")
        end

        if func.includes(ui.get(menu.visualsTab.widgets_slow), "Show procents") then 
            renderer.text(dbs.slow_x,dbs.slow_y - 12,255,255,255,255,"c",0,"100%")
        end
    
        renderer.rectangle(dbs.slow_x - ui.get(menu.visualsTab.widgets_slow_length) / 2 - 1,dbs.slow_y - 4,ui.get(menu.visualsTab.widgets_slow_length) + 2, ui.get(menu.visualsTab.widgets_slow_width) + 4,0,0,0,150)
        
    
    

        local slowdowncolor = { 255, 255, 255, 255 }
        if ui.get(menu.visualsTab.slow_down) and  func.includes(ui.get(menu.visualsTab.widgets_slow), "Blackout")  then 
            renderer.gradient(dbs.slow_x - ui.get(menu.visualsTab.widgets_slow_length) / 2 + 1,dbs.slow_y - 2,ui.get(menu.visualsTab.widgets_slow_length) - 2, ui.get(menu.visualsTab.widgets_slow_width), slowdowncolor[1], slowdowncolor[2], slowdowncolor[3],slowdowncolor[4],12, 12, 12,130,true)
        else
            renderer.rectangle(dbs.slow_x - ui.get(menu.visualsTab.widgets_slow_length) / 2 + 1,dbs.slow_y - 2, ui.get(menu.visualsTab.widgets_slow_length) - 2, ui.get(menu.visualsTab.widgets_slow_width), slowdowncolor[1], slowdowncolor[2], slowdowncolor[3],255)
        end

    else
        dbs.slow_menu = false 
    end

    if dbs.slow_x ~= w/2 and not dbs.is_dragging then 
        dbs.slow_x = math.lerp(dbs.slow_x,w/2,globals.frametime() * 10)
    end
end

function slow_c(w, h)
    if ui.is_menu_open() and dbs.slow_menu and (ui.get(menu.visualsTab.slow_down)) then 

        if intersect(dbs.slow_x + 85,dbs.slow_y - 50,82,100) then 
            should_shoot = false
        end

        round_rectangle(dbs.slow_x + 90,dbs.slow_y - 50 , 70, 90 , 24,24,24,100,5)
        renderer.gradient(dbs.slow_x + 90,dbs.slow_y - 40, 35, 1, 24,24,24,0,255,255,255,255, true)
        renderer.gradient(dbs.slow_x + 90 + 35,dbs.slow_y - 40, 35, 1, 255,255,255,255, 24,24,24,0 ,true)
        renderer.text(dbs.slow_x + 90 + 33,dbs.slow_y - 47, 255,255,255,255, "-c", 0, "SETTINGS")


        checkboxes("Text",menu.extras.text1,dbs.slow_x + 90,dbs.slow_y + 3)
        checkboxes("Turtle",menu.extras.icon1,dbs.slow_x + 90,dbs.slow_y + 3)
        checkboxes("Gradient",menu.extras.gradient1,dbs.slow_x + 90,dbs.slow_y + 3)
        checkboxes("Dynamic",menu.extras.dynamic,dbs.slow_x + 90,dbs.slow_y + 3)
        slider_e("length",menu.extras.length1,20,150,"º",dbs.slow_x + 90,dbs.slow_y + 3)
        slider_e("width",menu.extras.width1,1,15,"º",dbs.slow_x + 90 ,dbs.slow_y + 3)
    end
end





airstop = function(cmd)
    local lp = entity.get_local_player()
    if not lp then return end
    if ui.get(menu.miscTab.air_stop) then
        if ui.get(menu.miscTab.air_stop_k) then
            if cmd.quick_stop then
                if (globals.tickcount() - ticks) > 3 then
                    cmd.in_speed = 1
                end
            else
            ticks = globals.tickcount()
            end
        end
    end
end
     

zoomoffset2 = 0
fov_ = ref_ui("MISC", "Miscellaneous", "Override FOV")

event_callback("override_view", function(tbl)
    if ui.get(menu.visualsTab.zoom_animate) then
        lp = entity.get_local_player()
        if not lp or not entity.is_alive(lp) then return end

        weapon = entity.get_player_weapon(lp)
        if not weapon then return end

        zoom_fov = 0

        if entity.get_prop(lp, "m_bIsScoped") == 1 then
            zoom_level = entity.get_prop(weapon, "m_zoomLevel")
            if zoom_level == 1 then
                zoom_fov = ui.get(menu.visualsTab.zoom_1)
            elseif zoom_level == 2 then
                zoom_fov = ui.get(menu.visualsTab.zoom_2)
            end
        end

        target_fov = ui.get(fov_)
        if entity.get_prop(lp, "m_bIsScoped") == 1 then
            target_fov = target_fov - zoom_fov
        end

        speed = ui.get(menu.visualsTab.zoom_speed)
        zoomoffset2 = math.lerp(zoomoffset2, target_fov, globals.frametime() * speed)
        tbl.fov_ = zoomoffset2
    end
end)

event_callback("bullet_impact", function(e)
    if not ui.get(menu.visualsTab.bul_trace) then
        return
    end
    if client.userid_to_entindex(e.userid) ~= entity.get_local_player() then
        return
    end
    local lx, ly, lz = client.eye_position()
    queue[globals.tickcount()] = {lx, ly, lz, e.x, e.y, e.z, globals.curtime() + ui.get(menu.visualsTab.bul_dur)}
end)

hitmarker = {
    queue = {},
    aim_fire_f = function(self, e)
        self.queue[globals.tickcount()] = {e.x, e.y, e.z, globals.curtime() + ui.get(menu.visualsTab.plus_dur)}
    end,
    render_func = function(self)
        if not ui.get(menu.visualsTab.plus_hitmarker) then return end
        for tick, data in pairs(self.queue) do
            if globals.curtime() <= data[4] then
                local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
                if x1 ~= nil and y1 ~= nil then
                renderer.line(x1 - 6, y1, x1 + 6, y1, ui.get(menu.visualsTab.plus_col))
                renderer.line(x1, y1 - 6, x1, y1 + 6, ui.get(menu.visualsTab.plus_col))
                end
            else
                table.remove(self.queue, tick)
            end
        end
    end
}

event_callback("aim_fire", function(e) hitmarker:aim_fire_f(e) end)
event_callback("paint", function() hitmarker:render_func() end)

function is_grenade(weapon_class)
    return weapon_class == "CBaseCSGrenade" or
           weapon_class == "CDecoyGrenade" or
           weapon_class == "CFlashbang" or
           weapon_class == "CHEGrenade" or
           weapon_class == "CIncendiaryGrenade" or
           weapon_class == "CSmokeGrenade" or
           weapon_class == "CMolotovGrenade"
end


low_ammo_icon, low_ammo_warning, alpha, alpha_direction = renderer.load_svg("<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 64 64\" width=\"64\" height=\"64\"><path fill=\"#FF0000\" d=\"M32 4L2 56h60L32 4z\"/><path fill=\"#333\" d=\"M32 16v24m0 8v4\"/></svg>"), false, 255, -1

event_callback("paint_ui", function()
    if ui.get(menu.visualsTab.ammo_low) then

        local lp = entity.get_local_player()
        --if not lp or not entity.is_alive(lp) then return end
    

        local weapon = entity.get_player_weapon(lp)
        if not weapon then return end
    

        local weapon_class = entity.get_classname(weapon)
    

        if weapon_class == "CKnife" or weapon_class == "CWeaponTaser" or is_grenade(weapon_class) or entity.get_classname(entity.get_player_weapon(vars.localPlayer)) == "CC4" then
            return
        end
    

        local ammo = entity.get_prop(weapon, "m_iClip1")
    

        local text = "Low Ammo: "
        local r, g, b = 255, 255, 0
    

        if ammo == 3 then
            r, g, b = 255, 165, 0
        elseif ammo == 2 then
            r, g, b = 255, 0, 0
        elseif ammo == 1 then
            text = "Last ammo!"
            r, g, b = 255, 0, 0
        end
    

        local low_ammo_warning = ammo <= 4 and ammo > 0
    

        if not low_ammo_warning then return end
    

        alpha = alpha + (alpha_direction * 5)
        if alpha <= 50 or alpha >= 255 then
            alpha_direction = -alpha_direction
        end
    

        local x, y = client.screen_size()
        local icon_x, icon_y = x / 2 - 50, y / 2 - 95
        local text_x, text_y = x / 2, y / 2 - 90
    

        renderer.texture(low_ammo_icon, icon_x - 2, icon_y, 25, 25, r, g, b, alpha)
        renderer.text(text_x, text_y, r, g, b, alpha, "c", 0, text, ammo)
    end
    
end)
local curtime = globals.curtime
local unset_event_callback = client.unset_event_callback
local render_circle_outline, measure_text, render_text, render_rect, render_gradient, render_blur = 
    renderer.circle_outline, renderer.measure_text, renderer.text, renderer.rectangle, renderer.gradient, renderer.blur
local table_insert = table.insert
local ui_get = ui.get

local screen_width, screen_height = client.screen_size()

local WIDTH = 6
local HEIGHT = (screen_height / 2) + screen_height / 12
local TIME_TO_PLANT_BOMB = 3
local INDICATOR_TEXT_GAP = 36
local OUTER_CIRCLE_RADIUS = 6
local OUTER_CIRCLE_THICKNESS = OUTER_CIRCLE_RADIUS / 2
local INNER_CIRCLE_RADIUS = OUTER_CIRCLE_RADIUS - 1
local INNER_CIRCLE_THICKNESS = (OUTER_CIRCLE_RADIUS - 1) / 3

local timeAtBombWillBePlanted
local isBombBeingPlanted = false
local indicators = {}

function lerp(a, b, t)
    return a + (b - a) * t
end

function innerCircleOutlinePercentage()
    local timeElapsed = (curtime() + TIME_TO_PLANT_BOMB) - timeAtBombWillBePlanted
    local timeElapsedInPerc = (timeElapsed / TIME_TO_PLANT_BOMB * 100) + 0.5
    return timeElapsedInPerc * 0.01
end

function draw_indicators()
    for i = 1, #indicators do
        local indicator = indicators[i]
        local text = indicator.text
        local r, g, b, a = indicator.r, indicator.g, indicator.b, indicator.a

        local textH = HEIGHT + (i * -INDICATOR_TEXT_GAP) + (#indicators * INDICATOR_TEXT_GAP)
        local m_textW, m_textH = measure_text('+b', text)

        render_gradient(WIDTH, textH, m_textW + 40, m_textH + 4, 0, 0, 0, 150, 0, 0, 0, 0, true)
        render_blur(WIDTH, textH, m_textW + 40, m_textH + 4, 5)
        render_rect(WIDTH, textH, 3, m_textH + 4, r, g, b, a)
        render_text(WIDTH + 10, textH + 2, r, g, b, a, '+b', 0, text)

        if isBombBeingPlanted and text:find('Bombsite') then
            local cricleW = WIDTH + m_textW + OUTER_CIRCLE_RADIUS + 4
            local cricleH = textH + (m_textH / 1.71)

            render_circle_outline(cricleW, cricleH, 0, 0, 0, 100, OUTER_CIRCLE_RADIUS, 0, 1.0, OUTER_CIRCLE_THICKNESS)
            render_circle_outline(cricleW, cricleH, 255, 255, 255, 200, INNER_CIRCLE_RADIUS, 0, innerCircleOutlinePercentage(), INNER_CIRCLE_THICKNESS)
        end
    end

    indicators = {}
end

client.set_event_callback('bomb_beginplant', function ()
    timeAtBombWillBePlanted = curtime() + TIME_TO_PLANT_BOMB
    isBombBeingPlanted = true
end)

client.set_event_callback('bomb_abortplant', function ()
    isBombBeingPlanted = false
end)

client.set_event_callback('bomb_planted', function ()
    isBombBeingPlanted = false
end)


function IndicatorCallback(indicator)
    if not ui.get(menu.visualsTab.gs_ind) then return end
    table_insert(indicators, indicator)
end

client.set_event_callback('shutdown', function ()
    unset_event_callback('indicator', IndicatorCallback)
end)

client.set_event_callback('paint', function ()
    if not ui.get(menu.visualsTab.gs_ind) then
        unset_event_callback('indicator', IndicatorCallback)
    else
        client.set_event_callback('indicator', IndicatorCallback)
        draw_indicators()
    end
end)

event_callback("paint_ui", function()
    local me = entity.get_local_player()

    --[[if not ui.get(menu.visualsTab.zeus_warning) or elect_svg == nil or me == nil or not entity.is_alive(me) then
        return
    end]]


    for _, i in pairs(entity.get_players(true)) do
        esp_data = entity.get_esp_data(i)

        if esp_data ~= nil then

            active_weapon = entity.get_prop(i, "m_hActiveWeapon")
            if active_weapon then

                weapon_id = entity.get_prop(active_weapon, "m_iItemDefinitionIndex")
                if weapon_id == 31 then

                    x1, y1, x2, y2, a = entity.get_bounding_box(i)

                    if x1 ~= 0 and a > 0.000 then
                        renderer.texture(elect_svg, x1 - 24, y1, 25, 25, 255, 0, 0, a * 255)
                    end
                end
            end
        end
    end
end)

event_callback("paint_ui", function()
    if ui.get(menu.visualsTab.trace_target) then
    local me = entity.get_local_player()
    --[[if not entity.is_alive(me) then
        return
    end]]

    local target = client.current_threat()

    if not target then
        return
    end

    local color = {255, 255, 255, 255}
    local to_origin = vector(entity.get_origin(client.current_threat()))
    local origin_to_screen = vector(renderer.world_to_screen(to_origin.x, to_origin.y, to_origin.z))
    local screen_size = vector(client.screen_size())

    if  ((origin_to_screen.x ~= nil) and (origin_to_screen.y ~= nil)) and ((origin_to_screen.x ~= 0) and (origin_to_screen.y ~= 0)) then
        renderer.line(screen_size.x/2, screen_size.y, origin_to_screen.x, origin_to_screen.y, color[1], color[2], color[3], color[4])
    end
end

end)
event_callback("paint", function()
    if not ui.get(menu.visualsTab.bul_trace) then
        return
    end

    local curtime = globals.curtime()
    local to_remove = {}

    for tick, data in pairs(queue) do
        if curtime > data[7] then
            table.insert(to_remove, tick)
        else
            local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
            local x2, y2 = renderer.world_to_screen(data[4], data[5], data[6])
            if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
                renderer.line(x1, y1, x2, y2, ui.get(menu.visualsTab.bul_color))
            end
        end
    end

    for _, tick in ipairs(to_remove) do
        queue[tick] = nil
    end
end)

event_callback("paint_ui", function()
if ui.get(menu.visualsTab.fpsboost) then
        cvar.r_shadows:set_float(0)
        cvar.cl_csm_static_prop_shadows:set_float(0)
        cvar.cl_csm_shadows:set_float(0)
        cvar.cl_csm_world_shadows:set_float(0)
        cvar.cl_foot_contact_shadows:set_float(0)
        cvar.cl_csm_viewmodel_shadows:set_float(0)
        cvar.cl_csm_rope_shadows:set_float(0)
        cvar.cl_csm_sprite_shadows:set_float(0)
        cvar.r_dynamic:set_float(0)
        cvar.cl_autohelp:set_float(0)
        cvar.r_eyesize:set_float(0)
        cvar.r_eyeshift_z:set_float(0)
        cvar.r_eyeshift_y:set_float(0)
        cvar.r_eyeshift_x:set_float(0)
        cvar.r_eyemove:set_float(0)
        cvar.r_eyegloss:set_float(0)
        cvar.r_drawtracers_firstperson:set_float(0)
        cvar.r_drawtracers:set_float(0)
        cvar.fog_enable_water_fog:set_float(0)
        cvar.mat_postprocess_enable:set_float(0)
        cvar.cl_disablefreezecam:set_float(0)
        cvar.cl_freezecampanel_position_dynamic:set_float(0)
        cvar.r_drawdecals:set_float(0)
        cvar.muzzleflash_light:set_float(0)
        cvar.r_drawropes:set_float(0)
        cvar.r_drawsprites:set_float(0)
        cvar.cl_disablehtmlmotd:set_float(0)
        cvar.cl_freezecameffects_showholiday:set_float(0)
        cvar.cl_bob_lower_amt:set_float(0)
        cvar.cl_detail_multiplier:set_float(0)
        cvar.mat_drawwater:set_float(0) 
    else
        cvar.r_shadows:set_float(1)
        cvar.cl_csm_static_prop_shadows:set_float(1)
        cvar.cl_csm_shadows:set_float(1)
        cvar.cl_csm_world_shadows:set_float(1)
        cvar.cl_foot_contact_shadows:set_float(1)
        cvar.cl_csm_viewmodel_shadows:set_float(1)
        cvar.cl_csm_rope_shadows:set_float(1)
        cvar.cl_csm_sprite_shadows:set_float(1)
        cvar.r_dynamic:set_float(1)
        cvar.cl_autohelp:set_float(1)
        cvar.r_eyesize:set_float(1)
        cvar.r_eyeshift_z:set_float(1)
        cvar.r_eyeshift_y:set_float(1)
        cvar.r_eyeshift_x:set_float(1)
        cvar.r_eyemove:set_float(1)
        cvar.r_eyegloss:set_float(1)
        cvar.r_drawtracers_firstperson:set_float(1)
        cvar.r_drawtracers:set_float(1)
        cvar.fog_enable_water_fog:set_float(1)
        cvar.mat_postprocess_enable:set_float(1)
        cvar.cl_disablefreezecam:set_float(1)
        cvar.cl_freezecampanel_position_dynamic:set_float(1)
        cvar.r_drawdecals:set_float(1)
        cvar.muzzleflash_light:set_float(1)
        cvar.r_drawropes:set_float(1)
        cvar.r_drawsprites:set_float(1)
        cvar.cl_disablehtmlmotd:set_float(1)
        cvar.cl_freezecameffects_showholiday:set_float(1)
        cvar.cl_bob_lower_amt:set_float(1)
        cvar.cl_detail_multiplier:set_float(1)
        cvar.mat_drawwater:set_float(1)
    end
end)

ui.set_callback(menu.miscTab.filtercons, function()
    if menu.miscTab.filtercons then
        cvar.developer:set_int(0)
        cvar.con_filter_enable:set_int(1)
        cvar.con_filter_text:set_string("IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
        client.exec("con_filter_enable 1")
    else
        cvar.con_filter_enable:set_int(0)
        cvar.con_filter_text:set_string("")
        client.exec("con_filter_enable 0")
    end
end)

event_callback("shutdown", function()
    cvar.con_filter_enable:set_int(0)
    cvar.con_filter_text:set_string("")
    client.exec("con_filter_enable 0")
    ui.set(ref.aimbot, true)
    client.set_clan_tag("\0")
    traverse_table_on(refs)
    ui.set(refs.hitChance, L_hc)
    ui.set(silent_a, true)
end)

event_callback("round_prestart", function()
    queue = {}
    hitmarker.queue = {}
    collectgarbage()
    collectgarbage("collect")
    notifications.clear()
end)

event_callback("paint_ui", function()
    local w,h = client.screen_size()
    if not entity.get_local_player() then return end
    if not ui.get(menu.miscTab.auto_tp_indicator_disable) then
        doubletap_ref = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
        if ui.get(menu.miscTab.auto_tp) and ui.get(menu.miscTab.auto_tpHotkey) and doubletap_ref and not is_vulnerable() then
            renderer.indicator(215,211,213,255, "TELEPORT")
        end
        if ui.get(menu.miscTab.auto_tp) and ui.get(menu.miscTab.auto_tpHotkey) and not doubletap_ref then
            renderer.indicator(215,1,1,255, "TELEPORT")
        end
        if ui.get(menu.miscTab.auto_tp) and ui.get(menu.miscTab.auto_tpHotkey) and doubletap_ref and is_vulnerable() then
            renderer.indicator(143, 194, 21, 255, "TELEPORTING")
        end
    end
    if ui.get(menu.miscTab.air_stop) and ui.get(menu.miscTab.air_stop_k) then
        renderer.indicator(215,211,213, 255, "AIR-STOP")
    end
    if ui.get(menu.miscTab.daun_baim) and ui.get(menu.miscTab.daun_baim_key) then
        renderer.indicator(215,211,213, 255, "DEF-BAIM")
    end
    if ui.get(menu.miscTab.predict_enable) and ui.get(menu.miscTab.predict_ind) then
        if ui.get(menu.miscTab.predict_ind_mode) == "-/+" then
            if pred_ then
                renderer.indicator(215,211,213, 255, "\affffffff[+] " .. text_fade_animation(3, 255, 255, 255, 255, "PREDICT"))
            elseif not pred_ then
                renderer.indicator(215,211,213, 255, "\aff0000ff[-] " .. text_fade_animation(3, 255, 255, 255, 255, "PREDICT"))
            end
        elseif ui.get(menu.miscTab.predict_ind_mode) == "off/on" then
            if pred_ then
                renderer.indicator(215,211,213, 255, "\affffffff[on] " .. text_fade_animation(3, 255, 255, 255, 255, "PREDICT"))
            elseif not pred_ then
                renderer.indicator(215,211,213, 255, "\aff0000ff[off] ".. text_fade_animation(3, 255, 255, 255, 255, "PREDICT"))
            end
        end
    end
    if ui.get(menu.miscTab.aim_tools_delay_ind) and ui.get(menu.miscTab.aim_tools_delay_shot) then
        if vars.dl_shot then
            renderer.indicator(215,211,213,255, "DELAY SHOT")
        elseif not vars.dl_shot then
            renderer.indicator(215,1,1,255, "DELAY SHOT")
        end
    end
    slow_e(w, h)
    slow_a(w, h)
    debug_new()
    notifications.render()
    if ui.get(menu.visualsTab.predict_position) then
        draw_predicted_positions()
    end
end)


event_callback("setup_command", function(cmd)
    if ui.get(menu.miscTab.aim_tools_enable) then
        aimtools_debug()
    end
    peek_bot(cmd)
    predict()
    if not should_shoot then
        cmd.in_attack = false
        cmd.in_attack2 = 0
    end
    airstop(cmd)
    should_shoot = true
    fastladder(cmd)
    jumpscout(cmd)
    charge_dt()
    update_resolver()
end)


event_callback('paint_ui', function()
    if ui.get(menu.custTab.info_panel_pos) == "Up" then
        g_paint_handler()
    elseif ui.get(menu.custTab.info_panel_pos) == "Down" then
        g_paint_handler_u()
    end
    renderer_trace_positions()
    local target = client.current_threat()
    if target then local threat_origin = vector(entity.get_origin(target)) threat_origin_wts_x = renderer.world_to_screen(threat_origin.x, threat_origin.y, threat_origin.z) end
end)