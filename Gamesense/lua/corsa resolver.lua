--discord.gg/fastleaks

local first = {
    ' perfectly resolver for free - perfectly',
    ' perfectly resolver for free - perfectly'
}
local second = {
    ' ',
    ' '
}

client.set_event_callback('aim_hit', function()
    client.exec('say ' ..first[math.random(0, #first)] .. second[math.random(0, #second)] )
end)


local b_2 = {}
local local_player, callback_reg, dt_charged = nil, false, false

client.exec("Clear")
client.exec("con_filter_enable 0")

local perfectly = "perfectly's Prediction ~ "

local menu_color = ui.reference("MISC", "Settings", "Menu color")

client.set_event_callback("paint", function()
    local r, g, b, a = ui.get(menu_color)
end)

client.color_log(149, 149, 201, perfectly.."Welcome back")
client.delay_call(2, function()
end)

local function lerp(a, b, t)
    return a + (b - a) * t
end

local vector = require("vector")
local y = 0
local alpha = 150
client.set_event_callback('paint_ui', function()
local screen = vector(client.screen_size())
local ladd = "perfectly's Ragebot enchantements"
local size = vector(screen.x, screen.y)

local sizing = lerp(0.1, 0.9, math.sin(globals.realtime() * 0.9) * 0.5 + 0.5)
local rotation = lerp(0, 360, globals.realtime() % 1)
alpha = lerp(alpha, 0, globals.frametime() * 0.5)
y = lerp(y, 20, globals.frametime() * 2)

renderer.rectangle(0, 0, size.x, size.y, 13, 13, 13, alpha)
renderer.circle_outline(screen.x/2, screen.y/2, 149, 149, 201, alpha, 20, rotation, sizing, 3)
renderer.text(screen.x/2, screen.y/2 + 40, 149, 149, 201, alpha, 'c', 0, 'Loaded !')
renderer.text(screen.x/2, screen.y/2 + 60, 149, 149, 201, alpha, 'c', 0, 'Welcome - '..ladd..' [DEBUG]')
 end)



local options = { "Head", "Chest", "Stomach" }
local levl = {"Jitter", "Combined","Desync"}
local topchik = {"High", "Medium", "Low"}

b_2.rage = {
    space = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾", ui.get(menu_color))),
    space = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF• Predict Enemies •", ui.get(menu_color))),
    predict = ui.new_checkbox("rage", "other", string.format("\v\rPredict Features by \a%02X%02X%02XFFCorsa\v\r", ui.get(menu_color))),
    --color = ui.new_color_picker('rage', 'other', 123,51,233),
    pingpos = ui.new_combobox("rage", "other", string.format("Latency \a%02X%02X%02XFFDepending", ui.get(menu_color)), {"High Ping > 60", "Low Ping < 45"}),
    hitboxes = ui.new_multiselect('rage', 'other', 'Inverse Hitboxes at time-line', 'Head', 'Chest', 'Stomach'),
    pingpos1 = ui.new_slider("rage", "other", "Attach BackTrack At", 1, 3, 1, true, "", 1, {"Head", "Chest", "Stomach"}),
    space = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾", ui.get(menu_color))),
    space = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF• Resolver enchantements by perfectly •", ui.get(menu_color))),
    jittercorrectionresolvercorsas = ui.new_checkbox("rage", "other", "Jitter " .. string.format("\a%02X%02X%02XFFCorrection", ui.get(menu_color))),
    pingpofass = ui.new_slider("rage", "other", "Correction " .. string.format("\a%02X%02X%02XFFMode", ui.get(menu_color)), 1, 3, 1, true, "", 1, {"Jitter", "Combined","Desync"}),
    space = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾", ui.get(menu_color))),
    space = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF• Resolver helper •", ui.get(menu_color))),
    interesting = ui.new_checkbox('rage', 'other', string.format("\v\rJitter accuracy \a%02X%02X%02XFFboost\v\r", ui.get(menu_color))),
    boost = ui.new_slider('rage', 'other', 'Intensive boost', 1, 3, 2, true, "", 2, {"High", "Medium", "Low"}),
    interlude = ui.new_checkbox('rage', 'other', string.format("\v\rInterlude \a%02X%02X%02XFFAI\v\r", ui.get(menu_color)))
}





local ref = {
    aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
    doubletap = {
        main = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
    }
}

client.set_event_callback("paint", function()
    rgba_to_hex = function(c,d,e,f)
        return string.format('%02x%02x%02x%02x',c,d,e,f)
    end
  end)
client.set_event_callback("paint", function()
    if ui.get(b_2.rage.predict) then
      local r,g,b = ui.get(menu_color)
        renderer.indicator(r,g,b,255, "\a"..rgba_to_hex(r,g,b,255 * math.abs(math.cos(globals.curtime()*1))).."perfectlyhvh")
    end
end)

--ui.set_visible
local function checks1()
if ui.get(b_2.rage.predict) == true then
--ui.set_visible(b_2.rage.color, true)
ui.set_visible(b_2.rage.pingpos, true)
ui.set_visible(b_2.rage.pingpos1, true)
ui.set_visible(b_2.rage.hitboxes, true)
else
--ui.set_visible(b_2.rage.color, false)
ui.set_visible(b_2.rage.pingpos, false)
ui.set_visible(b_2.rage.pingpos1, false)
ui.set_visible(b_2.rage.hitboxes, false)
end
end

checks1()

ui.set_callback(b_2.rage.predict, function ()
    checks1()
end)
----
local function checks2()
if ui.get(b_2.rage.jittercorrectionresolvercorsas) == true then
ui.set_visible(b_2.rage.pingpofass, true)
else
ui.set_visible(b_2.rage.pingpofass, false)
end
end

checks2()

ui.set_callback(b_2.rage.jittercorrectionresolvercorsas, function ()
    checks2()
end)
---- 
local function checks()
if ui.get(b_2.rage.interesting) == true then
ui.set_visible(b_2.rage.boost, true)
else
ui.set_visible(b_2.rage.boost, false)
end
end

checks()

to_hex = function(r, g, b, a)
        return string.format("%02x%02x%02x%02x", r, g, b, a)
    end

ui.set_callback(b_2.rage.interesting, function ()
    checks()
end)

predict = function()
    local lp = entity.get_local_player()
    if not lp then return end
    if ui.get(b_2.rage.predict) then
        if ui.get(b_2.rage.pingpos) == "Low" then
            cvar.cl_interpolate:set_int(0)
            cvar.cl_interp_ratio:set_int(1)

            cvar.cl_interp:set_float(0.031000)

        else
            cvar.cl_interp:set_float(0.031000)
            cvar.cl_interp_ratio:set_int(1)
            cvar.cl_interpolate:set_int(0)
        end
    else
        cvar.cl_interp:set_float(0.016000)
        cvar.cl_interp_ratio:set_int(1)
        cvar.cl_interpolate:set_int(0)
    end
end

client.set_event_callback("setup_command", function()
  predict()
end)



--discord.gg/fastleaks