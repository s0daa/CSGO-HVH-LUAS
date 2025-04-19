local username = "bozo"
local build = "Nightly"--_G.astra and loader_decode_string(loader_get_user_build()) or "Private"
local function try_require(module, msg)
    local success, result = pcall(require, module)
    if success then return result else return error(msg) end
end
local images = try_require("gamesense/images", "Download images library: https://gamesense.pub/forums/viewtopic.php?id=22917")
local bit = try_require("bit")
local base64 = try_require("gamesense/base64", "Download base64 encode/decode library: https://gamesense.pub/forums/viewtopic.php?id=21619")
local antiaim_funcs = try_require("gamesense/antiaim_funcs", "Download anti-aim functions library: https://gamesense.pub/forums/viewtopic.php?id=29665")
local ffi = try_require("ffi", "Failed to require FFI, please make sure Allow unsafe scripts is enabled!")
local vector = try_require("vector", "Missing vector")
local http = try_require("gamesense/http", "Download HTTP library: https://gamesense.pub/forums/viewtopic.php?id=21619")
local clipboard = try_require("gamesense/clipboard", "Download Clipboard library: https://gamesense.pub/forums/viewtopic.php?id=28678")
local ent = try_require("gamesense/entity", "Download Entity Object library: https://gamesense.pub/forums/viewtopic.php?id=27529")
local csgo_weapons = try_require("gamesense/csgo_weapons", "Download CS:GO weapon data library: https://gamesense.pub/forums/viewtopic.php?id=18807")
local c_entity = require("gamesense/entity")
local steamworks = try_require("gamesense/steamworks") or error('Missing https://gamesense.pub/forums/viewtopic.php?id=26526')
local luaname = "LACONISM"
local luabuild = "perfect"
local invert = true
local value = 0
function sway()
    if invert == true then
        value = value + 1

        if value > 255 then 
            invert = false
        end

    else
        value = value - 1
        if value == 0 then
            invert = true
        end
    end
    return value
end
-- Helpful FCS
function lerp(a, b, t)
    if not b or not a or not t then return end
    return a + (b - a) * t
end
function ui.multiReference(tab, groupbox, name)
    local ref1, ref2, ref3 = ui.reference(tab, groupbox, name)
    return { ref1, ref2, ref3 }
end
rgba_to_hex = function(r, g, b, a)
    return bit.tohex((math.floor(r + 0.5) * 16777216) + (math.floor(g + 0.5) * 65536) + (math.floor(b + 0.5) * 256) + (math.floor(a + 0.5)))
end
func = {
    table_contains = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
    end,
    includes = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
    end,
}
animate_text = function(time, string, r, g, b, a, r2, g2, b2, a2)
    local m, n, o, p = r2, g2, b2, a2
    local t_out = {}
    local l = string:len() - 1
    local r_add = (m - r)
    local g_add = (n - g)
    local b_add = (o - b)
    local a_add = (p - a)

    for i = 1, #string do
        local iter = (i - 1) / (#string - 1) + time
        t_out[#t_out + 1] = "\a" .. rgba_to_hex(r + r_add * math.abs(math.cos(iter)), g + g_add * math.abs(math.cos(iter)), b + b_add * math.abs(math.cos(iter)), a + a_add * math.abs(math.cos(iter)))
        t_out[#t_out + 1] = string:sub(i, i)
    end

    return table.concat(t_out)
end

function animate_color(time, r, g, b, a, r2, g2, b2, a2)
    local finished = false
    local newR, newG, newB, newA = r, g, b, a
    if newR == r2 and newG == g2 and newB == b2 and newA == a2 then
        newR = lerp(r, r2, time)
        newG = lerp(g, g2, time)
        newB = lerp(b, b2, time)
        newA = lerp(a, a2, time)
    else
        newR = lerp(r2, r, time)
        newG = lerp(g2, g, time)
        newB = lerp(b2, b, time)
        newA = lerp(a2, a, time)
    end
    return newR, newG, newB, newA
end

local function traverse_table(tbl, prefix)
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
                -- Применяем ui.set_visible к каждому элементу
                ui.set_visible(value, false) -- Здесь можно изменить параметр видимости на нужное значение
            end
        end
    end
end

local function traverse_table_on(tbl, prefix)
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
                -- Применяем ui.set_visible к каждому элементу
                ui.set_visible(value, true) -- Здесь можно изменить параметр видимости на нужное значение
            end
        end
    end
end
-- ANIM ON LOAD
local y = 0
local alpha = 0
local startup_anim = true
local chuj = true
local show_text = false


client.set_event_callback('paint_ui', function()
    local screen = vector(client.screen_size())
    local size = vector(screen.x, screen.y)

    if startup_anim == true then
        local start, en = {184, 184, 184, alpha}, {62, 62, 62, 100}
        local text = "welcome back!"
        local rotation = lerp(0, 360, globals.realtime() % 1)
        if chuj == true then
        alpha = lerp(alpha, 255, globals.frametime() * 24)
        end
	    renderer.blur(0,0,size.x, size.y)
        
        renderer.text(screen.x/2, screen.y/2 +50, 255, 255, 255, alpha, 'c', 0, text)
        if alpha > 210 then
            if chuj == true then
                y = lerp(y, 150, globals.frametime() * 24)
            end
        end
        if y > 149 then
            chuj = false
            alpha = lerp(alpha, 0, globals.frametime() * 24)
            
            if alpha < 1 then
                startup_anim = false
            end
        end
        if show_text == true then
            renderer.text(screen.x/2, screen.y - y/2 + 65, 184, 184, 184, alpha, 'c', 0, '')
        end
    end
end)


local ref = 
{
    antiaim = {
        anti_aim = ui.multiReference("AA", "Anti-aimbot angles", "Enabled"),
        pitch = ui.multiReference("AA", "Anti-aimbot angles", "Pitch"),
        yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
        yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw Base"),
        jitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
        body_yaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
        fs_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        rollslider = ui.reference("AA", "Anti-aimbot angles", "Roll"),
        slow_motion = { ui.reference("AA", "Other", "Slow motion") },
		freestand, freestandkey = ui.reference("AA", "Anti-aimbot angles", "Freestanding"),
		fd = ui.reference("RAGE", "Other", "Duck peek assist"),
		edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
		fakelaglimit = ui.multiReference("AA","Fake lag", "Limit"),
		fakelagvariance = ui.multiReference("AA","Fake lag", "Variance"),
        fakelagamount = ui.multiReference("AA","Fake lag", "Amount"),
        fakelagenabled = ui.multiReference("AA","Fake lag", "Enabled"),
        legmovement = ui.multiReference("AA","Other", "Leg movement"),
        fakepeek = ui.multiReference("AA","Other", "Fake peek"),
        onshotaa = ui.multiReference("AA","Other", "On shot anti-aim"),
    }
}
------------------------Time-------------------------------------
local start_time = client.unix_time()
local function get_elapsed_time()
    local elapsed_seconds = client.unix_time() - start_time
    local hours = math.floor(elapsed_seconds / 3600)
    local minutes = math.floor((elapsed_seconds - hours * 3600) / 60)
    local seconds = math.floor(elapsed_seconds - hours * 3600 - minutes * 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end
----------------------------------------------------------------

uistate = 7
UI_Label_Empty = ui.new_label("AA", "Anti-aimbot angles", " ") 
UI_Label_Empty2 = ui.new_label("AA", "Anti-aimbot angles", " ") 

UI_Button_Back = ui.new_button("AA", "Anti-aimbot angles", "\a737373ffback", function()
    ui.set_visible(UI_Button_Back, false)
    ui.set_visible(UI_Button_Visuals, true)
    ui.set_visible(UI_Button_AA, true)
	ui.set_visible(UI_Button_Configs, true)
	ui.set_visible(UI_Button_Keybinds, true)
    ui.set_visible(UI_Button_Ragebot, true)
	uistate = 7
end)
ui.set_visible(UI_Button_Back, false)
UI_Button_AA = ui.new_button("AA", "Anti-aimbot angles", "\a737373ffanti-aim", function()
    ui.set_visible(UI_Button_Back, true)
    ui.set_visible(UI_Button_Visuals, false)
    ui.set_visible(UI_Button_AA, false)
	ui.set_visible(UI_Button_Configs, false)
	ui.set_visible(UI_Button_Keybinds, false)
	ui.set_visible(UI_Button_Ragebot, false)
	uistate = 1
end)

UI_Button_Ragebot = ui.new_button("AA", "Anti-aimbot angles", "\a737373ffragebot", function()
    ui.set_visible(UI_Button_Back, true)
    ui.set_visible(UI_Button_Visuals, false)
    ui.set_visible(UI_Button_AA, false)
	ui.set_visible(UI_Button_Configs, false)
	ui.set_visible(UI_Button_Keybinds, false)
	ui.set_visible(UI_Button_Ragebot, false)
	uistate = 2
end)
UI_Button_Keybinds = ui.new_button("AA", "Anti-aimbot angles", "\a737373ffkeybinds", function()
    ui.set_visible(UI_Button_Back, true)
    ui.set_visible(UI_Button_Visuals, false)
    ui.set_visible(UI_Button_AA, false)
	ui.set_visible(UI_Button_Configs, false)
	ui.set_visible(UI_Button_Keybinds, false)
	ui.set_visible(UI_Button_Ragebot, false)
	uistate = 6
end)
UI_Button_Visuals = ui.new_button("AA", "Anti-aimbot angles", "\a737373ffvisuals", function()
    ui.set_visible(UI_Button_Back, true)
    ui.set_visible(UI_Button_Visuals, false)
    ui.set_visible(UI_Button_AA, false)
	ui.set_visible(UI_Button_Configs, false)
	ui.set_visible(UI_Button_Keybinds, false)
	ui.set_visible(UI_Button_Ragebot, false)
	uistate = 3
end)
UI_Button_Configs = ui.new_button("AA", "Anti-aimbot angles", "\a737373ffconfigs", function()
    ui.set_visible(UI_Button_Back, true)
    ui.set_visible(UI_Button_Visuals, false)
    ui.set_visible(UI_Button_AA, false)
	ui.set_visible(UI_Button_Configs, false)
	ui.set_visible(UI_Button_Keybinds, false)
	ui.set_visible(UI_Button_Ragebot, false)
	uistate = 5
end)

------------------- User info -------------------------------- 

local usermode = {
    Fakelag = {
        fk1 = ui.new_label("AA", "Fake lag", "\a8AECF1FF•  \aFFFFFFFFScript info"),
        fk2 = ui.new_label("AA", "Fake lag", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
        fk3 = ui.new_label("AA", "Fake lag", "\aFFFFFFFFUser: tester"),
        fk4 = ui.new_label("AA", "Fake lag", "\aFFFFFFFFBuild: perfect"),
        fk5 = ui.new_label("AA", "Fake lag", "\aFFFFFFFFLast update: 09/01/2024"),
        fk6 = ui.new_label("AA", "Fake lag", " "),
        fk7 = ui.new_label("AA", "Fake lag", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
        fk9 = ui.new_label("AA", "Fake lag", "\a8AECF1FF•  \aFFFFFFFFCondition bind system"),
        fk8 = ui.new_label("AA", "Fake lag", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    },
    Other = {
        useri = ui.new_label("AA", "Other", "\a8AECF1FF•  \aFFFFFFFFUser zone"),
        useri1 = ui.new_label("AA", "Other", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
        Timezone = ui.new_label("AA", "Other", "Time session: time"),
    },
    forcfg = {
        cf0 = ui.new_label("AA", "Fake lag", " "),
        cf1 = ui.new_label("AA", "Anti-aimbot angles", " "),
        cf2 = ui.new_label("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFFFull configuration system"),
        cf3 = ui.new_label("AA", "Anti-aimbot angles", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
        cf4 = ui.new_label("AA", "Fake lag", "<Last update information>"),
        cf5 = ui.new_label("AA", "Fake lag", "Laconism -> Got Rework Design"),
        cf6 = ui.new_label("AA", "Fake lag", "Laconsim -> Got Rework Defensive"),
        cf7 = ui.new_label("AA", "Fake lag", "<Last update information>"),
    }
}

--------------------------------------------------------------

local state_selector = ui.new_combobox("AA","Anti-aimbot angles", "state", {"crouching", "crouchrunning", "standing", "slowmotion", "running", "jumping", "aircrouching", "fakelag"})
local antiaim_tab = {
 crouching = {
 pitch = ui.new_combobox("AA","Anti-aimbot angles", "[c] pitch", {"local view", "custom", "down", "up", "random"}),
 pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[c] custom pitch", -89, 89, 0, true, nil, 1, { }),
 at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[c] at targets"),
 ways = ui.new_slider("AA","Anti-aimbot angles", "[c] ways", 2, 3, 2, true, nil, 1, { }),
 left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[c] left yaw", -180, 180, 0, true, nil, 1, { }),
 right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[c] right yaw", -180, 180, 0, true, nil, 1, { }),
 multiplier = ui.new_slider("AA","Anti-aimbot angles", "[c] multiplier", -180, 180, 0, true, nil, 1, { }),
 randomization = ui.new_slider("AA","Anti-aimbot angles", "[c] randomization", -180, 180, 0, true, nil, 1, { }),
 lby = ui.new_combobox("AA","Anti-aimbot angles", "[c] breaker", {"off", "tickcount", "speed based", "static", "opposite"}),
 lbyside = ui.new_combobox("AA","Anti-aimbot angles", "[c] side", {"left", "right", "auto"}),
 lbyspeed = ui.new_slider("AA","Anti-aimbot angles", "[c] speed", 1, 10, 6, true, nil, 1, { }),
 fakelagmode = ui.new_combobox("AA","Anti-aimbot angles", "[c] fake lag mode", {"maximum", "dynamic", "fluctuate"}),
 fakelagslider = ui.new_slider("AA","Anti-aimbot angles", "[c] fake lag amount", 1, 15, 1, true, nil, 1, { }),
 defensive = {
 aa = ui.new_combobox("AA","Anti-aimbot angles", "[cd] defensive aa", {"off", "on peek", "force"}),
 pitch = ui.new_combobox("AA","Anti-aimbot angles", "[cd] pitch", {"local view", "semi-up", "semi-down", "sway", "sideways", "down", "up", "random", "custom"}),
 pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[cd] custom pitch", -89, 89, 0, true, nil, 1, { }),
 at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[cd] at targets"),
 yaw = ui.new_combobox("AA","Anti-aimbot angles", "[cd] yaw", {"sideways", "slow spin", "fast spin", "all the sides", "custom"}),
 left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[cd] first yaw", -180, 180, 0, true, nil, 1, { }),
 right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[cd] second yaw", -180, 180, 0, true, nil, 1, { }),
 },
 },
 crouchrunning = {
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[cr] pitch", {"local view", "custom", "down", "up", "random"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[cr] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[cr] at targets"),
    ways = ui.new_slider("AA","Anti-aimbot angles", "[cr] ways", 2, 3, 2, true, nil, 1, { }),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[cr] left yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[cr] right yaw", -180, 180, 0, true, nil, 1, { }),
    multiplier = ui.new_slider("AA","Anti-aimbot angles", "[cr] multiplier", -180, 180, 0, true, nil, 1, { }),
    randomization = ui.new_slider("AA","Anti-aimbot angles", "[cr] randomization", -180, 180, 0, true, nil, 1, { }),
    lby = ui.new_combobox("AA","Anti-aimbot angles", "[cr] breaker", {"off", "tickcount", "speed based", "static", "opposite"}),
    lbyside = ui.new_combobox("AA","Anti-aimbot angles", "[cr] side", {"left", "right", "auto"}),
    lbyspeed = ui.new_slider("AA","Anti-aimbot angles", "[cr] speed", 1, 10, 6, true, nil, 1, { }),
    fakelagmode = ui.new_combobox("AA","Anti-aimbot angles", "[cr] fake lag mode", {"maximum", "dynamic", "fluctuate"}),
    fakelagslider = ui.new_slider("AA","Anti-aimbot angles", "[cr] fake lag amount", 1, 15, 1, true, nil, 1, { }),
    defensive = {
    aa = ui.new_combobox("AA","Anti-aimbot angles", "[crd] defensive aa", {"off", "on peek", "force"}),
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[crd] pitch", {"local view", "semi-up", "semi-down", "sway", "sideways", "down", "up", "random", "custom"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[crd] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[crd] at targets"),
    yaw = ui.new_combobox("AA","Anti-aimbot angles", "[crd] yaw", {"sideways", "slow spin", "fast spin", "all the sides", "custom"}),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[crd] first yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[crd] second yaw", -180, 180, 0, true, nil, 1, { }),
    },
    },
 standing = {
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[s] pitch", {"local view", "custom", "down", "up", "random"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[s] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[s] at targets"),
    ways = ui.new_slider("AA","Anti-aimbot angles", "[s] ways", 2, 3, 2, true, nil, 1, { }),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[s] left yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[s] right yaw", -180, 180, 0, true, nil, 1, { }),
    multiplier = ui.new_slider("AA","Anti-aimbot angles", "[s] multiplier", -180, 180, 0, true, nil, 1, { }),
    randomization = ui.new_slider("AA","Anti-aimbot angles", "[s] randomization", -180, 180, 0, true, nil, 1, { }),
    lby = ui.new_combobox("AA","Anti-aimbot angles", "[s] breaker", {"off", "tickcount", "speed based", "static", "opposite"}),
    lbyside = ui.new_combobox("AA","Anti-aimbot angles", "[s] side", {"left", "right", "auto"}),
    lbyspeed = ui.new_slider("AA","Anti-aimbot angles", "[s] speed", 1, 10, 6, true, nil, 1, { }),
    fakelagmode = ui.new_combobox("AA","Anti-aimbot angles", "[s] fake lag mode", {"maximum", "dynamic", "fluctuate"}),
    fakelagslider = ui.new_slider("AA","Anti-aimbot angles", "[s] fake lag amount", 1, 15, 1, true, nil, 1, { }),
    defensive = {
    aa = ui.new_combobox("AA","Anti-aimbot angles", "[sd] defensive aa", {"off", "on peek", "force"}),
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[sd] pitch", {"local view", "semi-up", "semi-down", "sway", "sideways", "down", "up", "random", "custom"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[sd] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[sd] at targets"),
    yaw = ui.new_combobox("AA","Anti-aimbot angles", "[sd] yaw", {"sideways", "slow spin", "fast spin", "all the sides", "custom"}),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[sd] first yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[sd] second yaw", -180, 180, 0, true, nil, 1, { }),
    },
    },
 slowmotion = {
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[sm] pitch", {"local view", "custom", "down", "up", "random"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[sm] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[sm] at targets"),
    ways = ui.new_slider("AA","Anti-aimbot angles", "[sm] ways", 2, 3, 2, true, nil, 1, { }),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[sm] left yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[sm] right yaw", -180, 180, 0, true, nil, 1, { }),
    multiplier = ui.new_slider("AA","Anti-aimbot angles", "[sm] multiplier", -180, 180, 0, true, nil, 1, { }),
    randomization = ui.new_slider("AA","Anti-aimbot angles", "[sm] randomization", -180, 180, 0, true, nil, 1, { }),
    lby = ui.new_combobox("AA","Anti-aimbot angles", "[sm] breaker", {"off", "tickcount", "speed based", "static", "opposite"}),
    lbyside = ui.new_combobox("AA","Anti-aimbot angles", "[sm] side", {"left", "right", "auto"}),
    lbyspeed = ui.new_slider("AA","Anti-aimbot angles", "[sm] speed", 1, 10, 6, true, nil, 1, { }),
    fakelagmode = ui.new_combobox("AA","Anti-aimbot angles", "[sm] fake lag mode", {"maximum", "dynamic", "fluctuate"}),
    fakelagslider = ui.new_slider("AA","Anti-aimbot angles", "[sm] fake lag amount", 1, 15, 1, true, nil, 1, { }),
    defensive = {
    aa = ui.new_combobox("AA","Anti-aimbot angles", "[smd] defensive aa", {"off", "on peek", "force"}),
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[smd] pitch", {"local view", "semi-up", "semi-down", "sway", "sideways", "down", "up", "random", "custom"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[smd] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[smd] at targets"),
    yaw = ui.new_combobox("AA","Anti-aimbot angles", "[smd] yaw", {"sideways", "slow spin", "fast spin", "all the sides", "custom"}),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[smd] first yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[smd] second yaw", -180, 180, 0, true, nil, 1, { }),
    },
    },
 running = {
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[m] pitch", {"local view", "custom", "down", "up", "random"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[m] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[m] at targets"),
    ways = ui.new_slider("AA","Anti-aimbot angles", "[m] ways", 2, 3, 2, true, nil, 1, { }),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[m] left yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[m] right yaw", -180, 180, 0, true, nil, 1, { }),
    multiplier = ui.new_slider("AA","Anti-aimbot angles", "[m] multiplier", -180, 180, 0, true, nil, 1, { }),
    randomization = ui.new_slider("AA","Anti-aimbot angles", "[m] randomization", -180, 180, 0, true, nil, 1, { }),
    lby = ui.new_combobox("AA","Anti-aimbot angles", "[m] breaker", {"off", "tickcount", "speed based", "static", "opposite"}),
    lbyside = ui.new_combobox("AA","Anti-aimbot angles", "[m] side", {"left", "right", "auto"}),
    lbyspeed = ui.new_slider("AA","Anti-aimbot angles", "[m] speed", 1, 10, 6, true, nil, 1, { }),
    fakelagmode = ui.new_combobox("AA","Anti-aimbot angles", "[m] fake lag mode", {"maximum", "dynamic", "fluctuate"}),
    fakelagslider = ui.new_slider("AA","Anti-aimbot angles", "[m] fake lag amount", 1, 15, 1, true, nil, 1, { }),
    defensive = {
    aa = ui.new_combobox("AA","Anti-aimbot angles", "[md] defensive aa", {"off", "on peek", "force"}),
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[md] pitch", {"local view", "semi-up", "semi-down", "sway", "sideways", "down", "up", "random", "custom"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[md] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[md] at targets"),
    yaw = ui.new_combobox("AA","Anti-aimbot angles", "[md] yaw", {"sideways", "slow spin", "fast spin", "all the sides", "custom"}),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[md] first yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[md] second yaw", -180, 180, 0, true, nil, 1, { }),
    },
    },
 jumping = {
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[j] pitch", {"local view", "custom", "down", "up", "random"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[j] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[j] at targets"),
    ways = ui.new_slider("AA","Anti-aimbot angles", "[j] ways", 2, 3, 2, true, nil, 1, { }),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[j] left yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[j] right yaw", -180, 180, 0, true, nil, 1, { }),
    multiplier = ui.new_slider("AA","Anti-aimbot angles", "[j] multiplier", -180, 180, 0, true, nil, 1, { }),
    randomization = ui.new_slider("AA","Anti-aimbot angles", "[j] randomization", -180, 180, 0, true, nil, 1, { }),
    lby = ui.new_combobox("AA","Anti-aimbot angles", "[j] breaker", {"off", "tickcount", "speed based", "static", "opposite"}),
    lbyside = ui.new_combobox("AA","Anti-aimbot angles", "[j] side", {"left", "right", "auto"}),
    lbyspeed = ui.new_slider("AA","Anti-aimbot angles", "[j] speed", 1, 10, 6, true, nil, 1, { }),
    fakelagmode = ui.new_combobox("AA","Anti-aimbot angles", "[j] fake lag mode", {"maximum", "dynamic", "fluctuate"}),
    fakelagslider = ui.new_slider("AA","Anti-aimbot angles", "[j] fake lag amount", 1, 15, 1, true, nil, 1, { }),
    defensive = {
    aa = ui.new_combobox("AA","Anti-aimbot angles", "[jd] defensive aa", {"off", "on peek", "force"}),
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[jd] pitch", {"local view", "semi-up", "semi-down", "sway", "sideways", "down", "up", "random", "custom"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[jd] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[jd] at targets"),
    yaw = ui.new_combobox("AA","Anti-aimbot angles", "[jd] yaw", {"sideways", "slow spin", "fast spin", "all the sides", "custom"}),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[jd] first yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[jd] second yaw", -180, 180, 0, true, nil, 1, { }),
    },
    },
 aircrouching = {
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[ac] pitch", {"local view", "custom", "down", "up", "random"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[ac] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[ac] at targets"),
    ways = ui.new_slider("AA","Anti-aimbot angles", "[ac] ways", 2, 3, 2, true, nil, 1, { }),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[ac] left yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[ac] right yaw", -180, 180, 0, true, nil, 1, { }),
    multiplier = ui.new_slider("AA","Anti-aimbot angles", "[ac] multiplier", -180, 180, 0, true, nil, 1, { }),
    randomization = ui.new_slider("AA","Anti-aimbot angles", "[ac] randomization", -180, 180, 0, true, nil, 1, { }),
    lby = ui.new_combobox("AA","Anti-aimbot angles", "[ac] breaker", {"off", "tickcount", "speed based", "static", "opposite"}),
    lbyside = ui.new_combobox("AA","Anti-aimbot angles", "[ac] side", {"left", "right", "auto"}),
    lbyspeed = ui.new_slider("AA","Anti-aimbot angles", "[ac] speed", 1, 10, 6, true, nil, 1, { }),
    fakelagmode = ui.new_combobox("AA","Anti-aimbot angles", "[ac] fake lag mode", {"maximum", "dynamic", "fluctuate"}),
    fakelagslider = ui.new_slider("AA","Anti-aimbot angles", "[ac] fake lag amount", 1, 15, 1, true, nil, 1, { }),
    defensive = {
    aa = ui.new_combobox("AA","Anti-aimbot angles", "[acd] defensive aa", {"off", "on peek", "force"}),
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[acd] pitch", {"local view", "semi-up", "semi-down", "sway", "sideways", "down", "up", "random", "custom"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[acd] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[acd] at targets"),
    yaw = ui.new_combobox("AA","Anti-aimbot angles", "[acd] yaw", {"sideways", "slow spin", "fast spin", "all the sides", "custom"}),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[acd] first yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[acd] second yaw", -180, 180, 0, true, nil, 1, { }),
    },
    },
 fakelag = {
    pitch = ui.new_combobox("AA","Anti-aimbot angles", "[lag] pitch", {"local view", "custom", "down", "up", "random"}),
    pitch_slider = ui.new_slider("AA","Anti-aimbot angles", "[lag] custom pitch", -89, 89, 0, true, nil, 1, { }),
    at_targets = ui.new_checkbox("AA","Anti-aimbot angles", "[lag] at targets"),
    ways = ui.new_slider("AA","Anti-aimbot angles", "[lag] ways", 2, 3, 2, true, nil, 1, { }),
    left_yaw = ui.new_slider("AA","Anti-aimbot angles", "[lag] left yaw", -180, 180, 0, true, nil, 1, { }),
    right_yaw = ui.new_slider("AA","Anti-aimbot angles", "[lag] right yaw", -180, 180, 0, true, nil, 1, { }),
    multiplier = ui.new_slider("AA","Anti-aimbot angles", "[lag] multiplier", -180, 180, 0, true, nil, 1, { }),
    randomization = ui.new_slider("AA","Anti-aimbot angles", "[lag] randomization", -180, 180, 0, true, nil, 1, { }),
    lby = ui.new_combobox("AA","Anti-aimbot angles", "[lag] breaker", {"off", "tickcount", "speed based", "static", "opposite"}),
    lbyside = ui.new_combobox("AA","Anti-aimbot angles", "[lag] side", {"left", "right", "auto"}),
    lbyspeed = ui.new_slider("AA","Anti-aimbot angles", "[lag] speed", 1, 10, 6, true, nil, 1, { }),
    },
 other = {
    oth1 = ui.new_label("AA", "Other", " "),
    oth2 = ui.new_label("AA", "Other", "\a8AECF1FF•  \aFFFFFFFFOther Functions"),
    oth3 = ui.new_label("AA", "Other", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    safe_knife = ui.new_checkbox("AA","Other", "safe knife"),
    safe_zeus = ui.new_checkbox("AA","Other", "safe taser"),
    safe_head = ui.new_checkbox("AA","Other", "safe head on height advantage"),
    avoid_backstab = ui.new_checkbox("AA","Other", "avoid backstab"),
    static_freestand = ui.new_checkbox("AA","Other", "static on fs"),
    flickonmanuls = ui.new_checkbox("AA", "Other", "flick opposite e on manual & fs"),
    bombsiteefix = ui.new_checkbox("AA", "Other", "bombsite e fix"),
    legitaa = ui.new_combobox("AA","Other", "legit aa", {"off", "2 way", "static", "3 way"}),
 },
}
 keybinds_tab = {
    key0 = ui.new_label("AA", "Anti-aimbot angles", " "),
    key1 = ui.new_label("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFFBind System"),
    key2 = ui.new_label("AA", "Anti-aimbot angles", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    edgeyaw = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF edge yaw", false),
    freestand = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF freestand", false),
    manual_left = ui.new_hotkey("AA","Anti-aimbot angles","\a8AECF1FF•  \aFFFFFFFF manual left", false),
    manual_right = ui.new_hotkey("AA","Anti-aimbot angles","\a8AECF1FF•  \aFFFFFFFF manual right", false),
    manual_forward = ui.new_hotkey("AA","Anti-aimbot angles","\a8AECF1FF•  \aFFFFFFFF manual forward", false),
    no_defensive = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF disable defensive aa", false),
    hideshots = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF hideshots", false),
 }
 ragebot_tab = {
    raglab = ui.new_label("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFFRage System"),
    raglab1 = ui.new_label("AA", "Anti-aimbot angles", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    custom_exploits = ui.new_checkbox("AA","Anti-aimbot angles", "custom exploits"),
 }

 visuals_tab = {
    lab0 = ui.new_label("AA", "Anti-aimbot angles", " "),
    lab1 = ui.new_label("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFFAnimfix"),
    lab2 = ui.new_label("AA", "Anti-aimbot angles", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    lab3 = ui.new_label("AA", "Fake lag", " "),
    lab4 = ui.new_label("AA", "Fake lag", "\a8AECF1FF•  \aFFFFFFFFMiscellaneous"),
    lab5 = ui.new_label("AA", "Fake lag", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    confil = ui.new_checkbox("AA","Fake lag", "console filter"),
    aspect_ratio = ui.new_checkbox("AA", "Fake lag", "aspect ratio"),
    ratio = ui.new_slider("AA", "Fake lag", "\nAspect Ratio", 50, 200, 100, true, "", 0.01, {
        [133] = "4:3",
        [160] = "16:10",
        [178] = "16:9",
        [150] = "3:2",
        [125] = "5:4"
    }),
    animfixenb = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Animations"),
    animfixsel = ui.new_multiselect("AA", "Anti-aimbot angles", "\nanims" ,"air", "ground", "bodylean", "zero on ground"),
    airtype = ui.new_combobox("AA", "Anti-aimbot angles", "air type", "default", "moonwalk", "shaker"),
    vis1 = ui.new_label("AA", "Anti-aimbot angles", " "),
    vis2 = ui.new_label("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFFVisuals feature"),
    vis3 = ui.new_label("AA", "Anti-aimbot angles", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    indicators = ui.new_checkbox("AA","Anti-aimbot angles", "laconism inds"),
    eventlogs = ui.new_checkbox("AA","Anti-aimbot angles", "event logs"),
    center_indicators = ui.new_combobox("AA","Anti-aimbot angles", "crosshair inds", {"off", "dangerous", "minimalism", "modern"}),
    onscope = ui.new_combobox("AA","Anti-aimbot angles", "on scope animation", {"off", "left", "right", "alpha"}),
    accentlabel = ui.new_label("AA","Anti-aimbot angles", "accent color"),
    accent = ui.new_color_picker("AA","Anti-aimbot angles", "accent color"),
    arrows = ui.new_combobox("AA","Anti-aimbot angles", "arrows", {"Off", "Manual", "Old", "TS4", "Always"}),
 }





 -- CFG
local database_name = "laconism_cfg"
local db = database.read(database_name) or { configs = {} }
local config_list = {}
local binds = {}
function ui.multiReference(tab, groupbox, name)
    local ref1, ref2, ref3 = ui.reference(tab, groupbox, name)
    return { ref1, ref2, ref3 }
end
local references = {
}

local Configs = { }
local menu = {} do
    menu.update_list = function(update_listbox)
        config_list = {}

        for _, v in pairs(db.configs) do
            table.insert(config_list, v.name)
        end
    
        if (update_listbox) then
            ui.update(menu.listbox, config_list)
        end
    
        return config_list
    end

    menu.listbox = ui.new_listbox("AA", "Anti-aimbot angles", "Anti-aim config list", menu.update_list(false))
    menu.textbox = ui.new_textbox("AA", "Anti-aimbot angles", "Anti-aim config name")
    ui.set_callback(menu.listbox, function()
        local index = ui.get(menu.listbox)

        if index == nil then return end

        local name = config_list[index + 1]

        for _, v in pairs(binds) do
            ui.set_visible(v.ref, false)
        end

        local bind = binds[name]
        if bind == nil then
            binds[name] = {
                ref = ui.new_hotkey("AA", "Fake lag", string.format("Load the config: \ac17f82ff%s", name)),
                state = false,
                deleted = false,
            }
        else
            ui.set_visible(bind.ref, true)
        end

        ui.set(menu.textbox, name)
    end)
    Configs.Load = ui.new_button("AA", "Anti-aimbot angles", "\a737373ffLoad", function()
        local index = ui.get(menu.listbox)

        if index == nil then
            client.error_log("Select a config from listbox before loading")
            return
        end

        local cfg = db.configs[config_list[index + 1]]

        if type(cfg) ~= "table" then
            client.error_log('Attempt to load a corrupted or non-existent config')
            return
        end

        for i, val in pairs(cfg.values) do
            local success = true
            local ref = references[i]
       if type(ref) == "table" then
   success = pcall(ui.set, ref[1], val[1])
  if not success then client.error_log("Attempt to load an outdated config") return end
   success = pcall(ui.set, ref[2], val[2])
  if not success then client.error_log("Attempt to load an outdated config") return end
 else
  success = pcall(ui.set, ref, val)
   if not success then client.error_log("Attempt to load an outdated config") return end
            end
        end
        menu.update_list(true)
    end)
    Configs.Save = ui.new_button("AA", "Anti-aimbot angles", "\a737373ffSave", function()
        local name = ui.get(menu.textbox)

        if name == "" then
            client.error_log('Fill in the config name textbox before saving')
            return
        end

        local temp = { ["name"] = name, ["values"] = {} }
        for i, ref in pairs(references) do
            if type(ref) == "table" then
                temp.values[i] = { ui.get(ref[1]), ui.get(ref[2]) }
            else
                temp.values[i] = ui.get(ref)
            end
        end
        db.configs[name] = temp
        database.write(database_name, db)

        menu.update_list(true)
    end)
    Configs.Delete = ui.new_button("AA", "Anti-aimbot angles", "\a737373ffDelete", function()
        local index = ui.get(menu.listbox)

        if index == nil then
            client.error_log("Select a config from listbox before deleting")
            return
        end

        local name = config_list[index + 1]

        if name == "nil" then
            client.error_log('Attempt to delete non-existent config')
            return
        end
        binds[name].deleted = true
        db.configs[name] = nil
        database.write(database_name, db)

        menu.update_list(true)
    end)
    Configs.Import = ui.new_button("AA", "Anti-aimbot angles", "\a737373ffImport from clipboard", function()
        local success, cfg = pcall(json.parse, clipboard.get())

        if not success then
            client.error_log('Attempt to load an invalid config')
            return
        end

        for i, val in pairs(cfg) do
            local success = true
            local ref = references[i]
            if type(ref) == "table" then
                success = pcall(ui.set, ref[1], val[1])
                if not success then client.error_log("Attempt to load an outdated config") return end
                success = pcall(ui.set, ref[2], val[2])
                if not success then client.error_log("Attempt to load an outdated config") return end
            else
                success = pcall(ui.set, ref, val)
                if not success then client.error_log("Attempt to load an outdated config") return end
            end
        end
    end)
    Configs.Export = ui.new_button("AA", "Anti-aimbot angles", "\a737373ffExport to clipboard", function()
        local temp = {}

        for i, ref in pairs(references) do
            if type(ref) == "table" then
                temp[i] = { ui.get(ref[1]), ui.get(ref[2]) }
            else
                temp[i] = ui.get(ref)
            end
        end

        clipboard.set(json.stringify(temp))
    end)
    local visible = true
end
function flattenTable(source, destination, prefix)
    for key, value in pairs(source) do
        local fullKey = prefix and (prefix .. "." .. key) or key
        if type(value) == "table" then
            flattenTable(value, destination, fullKey) -- Рекурсивно объединяем вложенную таблицу
        else
            destination[fullKey] = value -- Добавляем ключ и значение в плоскую таблицу
        end
    end
end
flattenTable(antiaim_tab, references)
flattenTable(visuals_tab, references)
flattenTable(ragebot_tab, references)
function flattenTableValues(source)
    local flattenedValues = {}

    local function flatten(source)
        for _, value in pairs(source) do
            if type(value) == "table" then
                flatten(value) -- Рекурсивно обрабатываем вложенную таблицу
            else
                table.insert(flattenedValues, value) -- Добавляем значение в плоский список
            end
        end
    end

    flatten(source)

    return flattenedValues
end
------------- Pr1Vat04kA 6y M3G4P0L9S -------------

client.set_event_callback("paint_ui", function()
    ui.set_visible(usermode.forcfg.cf0, uistate == 5)
    ui.set_visible(usermode.forcfg.cf1, uistate == 5)
    ui.set_visible(usermode.forcfg.cf2, uistate == 5)
    ui.set_visible(usermode.forcfg.cf3, uistate == 5)
    ui.set_visible(usermode.forcfg.cf4, uistate == 5)
    ui.set_visible(usermode.forcfg.cf5, uistate == 5)
    ui.set_visible(usermode.forcfg.cf6, uistate == 5)
    ui.set_visible(usermode.forcfg.cf7, uistate == 5)
    ui.set_visible(usermode.Other.Timezone, uistate == 7)
    ui.set_visible(usermode.Other.useri, uistate == 7)
    ui.set_visible(usermode.Other.useri1, uistate == 7)
    ui.set_visible(usermode.Fakelag.fk1, uistate == 7)
    ui.set_visible(usermode.Fakelag.fk2, uistate == 7)
    ui.set_visible(usermode.Fakelag.fk3, uistate == 7)
    ui.set_visible(usermode.Fakelag.fk4, uistate == 7)
    ui.set_visible(usermode.Fakelag.fk5, uistate == 7)
    ui.set_visible(usermode.Fakelag.fk6, uistate == 7)
    ui.set_visible(usermode.Fakelag.fk7, uistate == 7)

    if ui.is_menu_open() then
        ui.set(usermode.Other.Timezone, "Time session: \aC47AFFFF"..get_elapsed_time())
    end
end)

----------------------------------------------------
UI_Export_Condition = ui.new_button('AA', 'Fake lag', '\a737373ffExport current condition', function()
    local temp = {}
    currentcondui = antiaim_tab[ui.get(state_selector)]
    for k, v in ipairs(flattenTableValues(currentcondui)) do
        table.insert(temp, ui.get(v))
    end

    clipboard.set(base64.encode(base64.encode(json.stringify(temp), "base64"), "base64"))
end)

UI_Import_Condition = ui.new_button('AA', 'Fake lag', '\a737373ffImport to current condition', function()
    local temp = json.parse(base64.decode(base64.decode(clipboard.get(),"base64"), "base64"))
    currentcondui = antiaim_tab[ui.get(state_selector)]
    for i=1, #temp do
        ui.set(flattenTableValues(currentcondui)[i], temp[i])
    end
end)
client.set_event_callback("paint_ui", function()
    ui.set_visible(usermode.Fakelag.fk9, uistate == 1)
    ui.set_visible(usermode.Fakelag.fk8, uistate == 1)
    
    if uistate == 1 then
        ui.set_visible(UI_Export_Condition, true)
        ui.set_visible(UI_Import_Condition, true)
        else
        ui.set_visible(UI_Export_Condition, false)
        ui.set_visible(UI_Import_Condition, false)
        end
traverse_table(ref)

-- CFG TAB
if uistate == 5 then
    ui.set_visible(menu.listbox,true)
    ui.set_visible(menu.textbox,true)
    traverse_table_on(Configs)
else
    ui.set_visible(menu.listbox,false)
    ui.set_visible(menu.textbox,false)
    traverse_table(Configs)
    for _, v in pairs(binds) do
        ui.set_visible(v.ref, false)
      end
end
-- AA TAB
if uistate ~= 1 then traverse_table(antiaim_tab) ui.set_visible(state_selector, false) else 
    currentcondition = antiaim_tab[ui.get(state_selector)]
traverse_table(antiaim_tab)
traverse_table_on(antiaim_tab.other)
traverse_table_on(currentcondition) ui.set_visible(state_selector, true) 
if ui.get(currentcondition.pitch) ~= "custom" then ui.set_visible(currentcondition.pitch_slider, false) else ui.set_visible(currentcondition.pitch_slider, true) end
if ui.get(currentcondition.ways) ~= 2 then ui.set_visible(currentcondition.left_yaw, false) ui.set_visible(currentcondition.right_yaw, false) ui.set_visible(currentcondition.randomization, false) ui.set_visible(currentcondition.multiplier, true) else ui.set_visible(currentcondition.randomization, true) ui.set_visible(currentcondition.left_yaw, true) ui.set_visible(currentcondition.right_yaw, true) ui.set_visible(currentcondition.multiplier, false) end
if ui.get(currentcondition.lby) == "tickcount" then ui.set_visible(currentcondition.lbyside, false) ui.set_visible(currentcondition.lbyspeed, false) end
if ui.get(currentcondition.lby) == "static" or ui.get(currentcondition.lby) == "opposite" then ui.set_visible(currentcondition.lbyside, true) ui.set_visible(currentcondition.lbyspeed, false) end
if ui.get(currentcondition.lby) == "speed based" then ui.set_visible(currentcondition.lbyside, false) ui.set_visible(currentcondition.lbyspeed, true) end
if ui.get(currentcondition.lby) == "off" then ui.set_visible(currentcondition.lbyside,false) ui.set_visible(currentcondition.lbyspeed, false) end
if ui.get(state_selector) ~= "fakelag" then
if ui.get(currentcondition.defensive.aa) == "off" then traverse_table(currentcondition.defensive) ui.set_visible(currentcondition.defensive.aa, true)
else
traverse_table_on(currentcondition.defensive)
if ui.get(currentcondition.defensive.pitch) ~= "custom" then ui.set_visible(currentcondition.defensive.pitch_slider, false) else ui.set_visible(currentcondition.defensive.pitch_slider, true) end
if ui.get(currentcondition.defensive.yaw) ~= "custom" then ui.set_visible(currentcondition.defensive.left_yaw, false) ui.set_visible(currentcondition.defensive.right_yaw, false) else ui.set_visible(currentcondition.defensive.left_yaw, true) ui.set_visible(currentcondition.defensive.right_yaw, true) end
end
end
end
--


-- KEYBINDS TAB
if uistate == 6 then 
traverse_table_on(keybinds_tab)
else 
traverse_table(keybinds_tab)
end

-- RAGEBOT TAB
if uistate == 2 then
traverse_table_on(ragebot_tab)
else
traverse_table(ragebot_tab)
end
--
if uistate == 3 then
traverse_table_on(visuals_tab)
ui.set_visible(visuals_tab.animfixsel, ui.get(visuals_tab.animfixenb))
ui.set_visible(visuals_tab.airtype, func.includes(ui.get(visuals_tab.animfixsel), "air"))
ui.set_visible(visuals_tab.ratio, ui.get(visuals_tab.aspect_ratio))
else
traverse_table(visuals_tab)
end
end)
local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
local gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table.insert(new_tab, value); table.remove(new_tab, 1); end; tab = new_tab; end
local get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end
breaker = {
    defensive = 0,
    defensive_check = 0,
    cmd = 0,
    last_origin = nil,
    origin = nil,
    tp_dist = 0,
    tp_data = gram_create(0,3)
}
tickbase = 0
 function get_velocity(player)
    local x,y,z = entity.get_prop(player, "m_vecVelocity")
    if x == nil then return end
    return math.sqrt(x*x + y*y + z*z)
end
client.set_event_callback("run_command", function(cmd)
    breaker.cmd = cmd.command_number
    me = entity.get_local_player()
    if not me or not entity.is_alive(me) then     
        breaker.defensive = 0
        breaker.defensive_check = 0
        return end
        if math.abs(tickbase - breaker.defensive_check) > 64 then
            breaker.defensive = 0
            breaker.defensive_check = 0
        end
end)


-- client.set_event_callback("predict_command", function(e)
--     me = entity.get_local_player()
--         if not me or not entity.is_alive(me) then     
--             breaker.defensive = 0
--             breaker.defensive_check = 0
--             return end
--             tickbase = entity.get_prop(me,"m_nTickbase")
--         if e.command_number == breaker.cmd then
--     if math.abs(tickbase - breaker.defensive_check) > 64 then
--         breaker.defensive_check = 0
--         breaker.defensive = 0
--     end

--     breaker.defensive = 0
--     if tickbase > breaker.defensive_check then
--         breaker.defensive_check = tickbase
--     elseif breaker.defensive_check > tickbase then
--         breaker.defensive = math.min(12, math.max(0, breaker.defensive_check-tickbase-1))
--     end
--     if math.abs(tickbase - breaker.defensive_check) > 64 then
--         breaker.defensive = 0
--         breaker.defensive_check = 0
--     end
--     breaker.cmd = 0
-- end
-- if math.abs(tickbase - breaker.defensive_check) > 64 then
--     breaker.defensive = 0
--     breaker.defensive_check = 0
-- end
-- end)
client.set_event_callback("predict_command", function(cmd)
    me = entity.get_local_player()
        if not me or not entity.is_alive(me) then     
            breaker.defensive = 0
            breaker.defensive_check = 0
            return end
    if cmd.command_number == breaker.cmd then
        tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
        breaker.defensive_check = math.max(tickbase, breaker.defensive_check)
        breaker.cmd = 0
        if math.abs(tickbase - breaker.defensive_check) > 64 then
            breaker.defensive = 0
            breaker.defensive_check = 0
        end
        if breaker.defensive_check > tickbase then          
            breaker.defensive = math.abs(tickbase - breaker.defensive_check)
            end
    end
    if math.abs(tickbase - breaker.defensive_check) > 64 then
        breaker.defensive = 0
        breaker.defensive_check = 0
    end
end)
forrealtime = 0
function smoothJitter(switchyaw1, switchyaw2, switchingspeed)
    if globals.curtime() > forrealtime + 1 / (switchingspeed * 2) then
        finalyawgg = switchyaw1
        if globals.curtime() - forrealtime > 2 / (switchingspeed * 2) then
            forrealtime = globals.curtime()
        end
    else
        finalyawgg = switchyaw2
    end
    return finalyawgg
end
client.set_event_callback("level_init", function()
        breaker.cmd = 0
        breaker.defensive = 0
        breaker.defensive_check = 0
    forrealtime = 0
end)
client.set_event_callback("round_start", function()
    breaker.cmd = 0
    breaker.defensive = 0
    breaker.defensive_check = 0
end)
function desyncside()
    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then
        return
    end
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and -1 or 1
    return side
end
condtotake = ""
function calculate_body_fs()
    if not entity.get_local_player() or not client.current_threat() then
        return 1
    end
    local x1, y1, z1 = entity.hitbox_position(entity.get_local_player(), 0)
    local x2, y2, z2 = entity.hitbox_position(client.current_threat(), 0)

    local result
    if x2 - x1 < 10 then
        result = -1
    else
        result = 1
    end

    return result
end
local anti_aims = {
    condition = "",
}
local helpers = {
    lp = entity.get_local_player(),
    ground_ticks = 0,
}
skeetfakelaglimit = ui.reference("AA","Fake lag", "Limit")
skeetfakelagamount = ui.reference("AA","Fake lag", "Amount")
local keysforinds = 
{
   doubletap = ui.multiReference("RAGE", "Aimbot", "Double tap");
   hideshots =  ui.multiReference("AA", "Other", "On shot anti-aim");
   freestand = ui.multiReference("AA", "Anti-aimbot angles", "Freestanding");
   dmg = ui.multiReference("RAGE", "Aimbot", "Minimum damage override");
}  
function helpers:is_on_ground()
    lp = entity.get_local_player()
    if not lp then return end
    local flags = entity.get_prop(lp, 'm_fFlags')
    if bit.band(flags, 1) == 0 then
        helpers.ground_ticks = 0
    elseif helpers.ground_ticks <= 45 then
        helpers.ground_ticks = helpers.ground_ticks + 1
    end
    return helpers.ground_ticks >= 45
end
function anti_aims:get_condition_type()
    lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end
            if not entity.is_alive(lp) then return end
            local duck_amt = entity.get_prop(lp, 'm_flDuckAmount')
            local speed = vector(entity.get_prop(lp, 'm_vecVelocity')):length()
            if ui.get(keysforinds.doubletap[1]) and ui.get(keysforinds.doubletap[2]) and not ui.get(ref.antiaim.fd) or ui.get(keysforinds.hideshots[1]) and not ui.get(ref.antiaim.fd) and ui.get(keysforinds.hideshots[2]) then
                if not helpers:is_on_ground() and duck_amt == 0 then
                    return "jumping"
                elseif duck_amt > 0 and not helpers:is_on_ground() then
                    return "aircrouching"
                elseif duck_amt > 0 and speed < 3 and helpers:is_on_ground() and not ui.get(ref.antiaim.fd) then
                    return "crouching"
                elseif duck_amt > 0 and speed > 3 and helpers:is_on_ground() and not ui.get(ref.antiaim.fd) then
                    return "crouchrunning"
                elseif speed > 2 and not ui.get(ref.antiaim.slow_motion[2]) then
                    return "running"
                elseif ui.get(ref.antiaim.slow_motion[2]) then
                    return "slowmotion"
                else
                    return "standing"
                end
            else
                return "fakelag"
            end
end
function anti_aims:get_fakelag_cond()
    lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end
            if not entity.is_alive(lp) then return end
            local duck_amt = entity.get_prop(lp, 'm_flDuckAmount')
            local speed = vector(entity.get_prop(lp, 'm_vecVelocity')):length()
                if not helpers:is_on_ground() and duck_amt == 0 then
                    return "jumping"
                elseif duck_amt > 0 and not helpers:is_on_ground() then
                    return "aircrouching"
                elseif duck_amt > 0 and speed < 3 and helpers:is_on_ground() and not ui.get(ref.antiaim.fd) then
                    return "crouching"
                elseif duck_amt > 0 and speed > 3 and helpers:is_on_ground() and not ui.get(ref.antiaim.fd) then
                    return "crouchrunning"
                elseif speed > 2 and not ui.get(ref.antiaim.slow_motion[2]) then
                    return "running"
                elseif ui.get(ref.antiaim.slow_motion[2]) then
                    return "slowmotion"
                else
                    return "standing"
                end
            end

-- CREATE MOVE
local custominvert = true
local customvalue = 0
  function customsway()
    if custominvert == true then
        customvalue = customvalue + 0.1

        if customvalue > 1 then 
            custominvert = false
        end

    else
        customvalue = customvalue - 0.1
        if customvalue < 0 then
            customvalue = 0
            custominvert = true
        end
    end
    return customvalue
end
local function get_ent_dist(ent_1, ent_2)
    local ent1_pos = vector(entity.get_prop(ent_1, "m_vecOrigin"))
    local ent2_pos = vector(entity.get_prop(ent_2, "m_vecOrigin"))

    local dist = ent1_pos:dist(ent2_pos)

    return dist
end
local function is_visible(ent)
    local me = entity.get_local_player()
    local l_x, l_y, l_z = entity.hitbox_position(me, 0)
    local e_x, e_y, e_z = entity.hitbox_position(ent, 0)

    local frac, ent = client.trace_line(me, l_x, l_y, l_z, e_x, e_y, e_z)

    return frac > 0.65
end
client.set_event_callback("setup_command", function(cmd)
    me = entity.get_local_player()
    if not me or not entity.is_alive(me) then return end
    breaker.tickbase_check = globals.tickcount() > entity.get_prop(me, "m_nTickbase")
end)
local function antibackstab() 
    local bestenemy = client.current_threat()
    local lp = entity.get_local_player()
    if not bestenemy or not lp then return false end
    if entity.get_classname(entity.get_player_weapon(bestenemy)) == "CKnife" and is_visible(bestenemy) and get_ent_dist(lp, bestenemy) < 450 and bestenemy ~= nil then 
        return true 
    else 
        return false
    end
end
function safeheadtarget() 
    local bestenemy = client.current_threat()
    if bestenemy == nil then return false end
    if entity.get_classname(entity.get_player_weapon(bestenemy)) ~= "CKnife" and get_ent_dist(lp, bestenemy) > 25 then
        local origin = vector(entity.get_origin(entity.get_local_player()))
        local origin2 = vector(entity.get_origin(bestenemy))
        return origin.z - origin2.z > 70
    else
        return false
    end
end
client.set_event_callback("player_death", function(e)
    local attacker_entindex = client.userid_to_entindex(e.attacker)
	local victim_entindex   = client.userid_to_entindex(e.userid)
	local local_player 		= entity.get_local_player()
if victim_entindex == local_player then
    local message = string.format("you've got killed by %s | safehead: %s | broken lc: %s", entity.get_player_name(attacker_entindex), safeheadtarget() and ui.get(antiaim_tab.other.safe_head) and (anti_aims:get_condition_type() == "aircrouching" or anti_aims:get_condition_type() == "crouching" or anti_aims:get_condition_type() == "crouchrunning" or anti_aims:get_condition_type() == "standing" or anti_aims:get_condition_type() == "fakelag"), is_defensive)
    print(message)
end
end)
freestand, freestandkey = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
last_press_t = 0

client.set_event_callback("paint_ui", function()
    if ui.get(keybinds_tab.hideshots) then
        ui.set(keysforinds.hideshots[1], true)
        ui.set(keysforinds.hideshots[2], "Always on")
    else 
        ui.set(keysforinds.hideshots[1], false)
        ui.set(keysforinds.hideshots[2], "On hotkey")
    end
    if ui.get(keybinds_tab.edgeyaw) then
        ui.set(ref.antiaim.edgeyaw, true)
	else 
        ui.set(ref.antiaim.edgeyaw, false)
    end
    ui.set(keybinds_tab.manual_right, "On hotkey")
    ui.set(keybinds_tab.manual_left, "On hotkey")
    ui.set(keybinds_tab.manual_forward, "On hotkey")
    if ui.get(keybinds_tab.manual_right) and last_press_t + 0.2 < globals.curtime() then
        manual_dir = manual_dir == 2 and 0 or 2
        last_press_t = globals.curtime()
    elseif ui.get(keybinds_tab.manual_left) and last_press_t + 0.2 < globals.curtime() then
        manual_dir = manual_dir == 1 and 0 or 1
        last_press_t = globals.curtime()
    elseif ui.get(keybinds_tab.manual_forward) and last_press_t + 0.2 < globals.curtime() then
        manual_dir = manual_dir == 3 and 0 or 3
        last_press_t = globals.curtime()
    elseif last_press_t > globals.curtime() then
        last_press_t = globals.curtime()
    end
    if ui.get(keybinds_tab.freestand) and manual_dir == 0 then
		ui.set(freestand, true)
        ui.set(freestandkey, "Always on") 
    else 
	ui.set(freestand, false)
        ui.set(freestandkey, "On hotkey")    
		end
end)
abstoflick = 0
clamper = function(count)
if count > 180 then 
return -180 + (count - 180)
elseif count < -180 then
return 180 - (-180 - count)
end
end
manual_dir = 0
client.set_event_callback("setup_command", function(cmd)
    local tp_amount = get_average(breaker.tp_data)/get_velocity(entity.get_local_player())*100 
    exploiting = ui.get(keysforinds.doubletap[1]) and ui.get(keysforinds.doubletap[2]) and not ui.get(ref.antiaim.fd) or ui.get(keysforinds.hideshots[1]) and not ui.get(ref.antiaim.fd) and ui.get(keysforinds.hideshots[2]) 
    is_defensive = not ui.get(keybinds_tab.no_defensive) and breaker.tickbase_check and breaker.defensive > 2 and breaker.defensive < 14 and exploiting 
    -- and not (tp_amount >= 25 and breaker.defensive >= 12)
    handle_aa = function(pitch, pitchslider, at_targets, ways, left_yaw, right_yaw, multiplier, randomization, lby, lbyside, lbyspeed, fakelagmode, fakelagslider, defensivemode, defensivepitch, defensiveslider, defensiveattargets, defensiveyaw, defensiveleft, defensiveright)
        if defensivemode == "force" then cmd.force_defensive = 1 end
        if pitch == "local view" then ui.set(ref.antiaim.pitch[1], "Off") elseif pitch == "custom" then ui.set(ref.antiaim.pitch[1], "Custom") ui.set(ref.antiaim.pitch[2], pitchslider) elseif pitch == "random" then ui.set(ref.antiaim.pitch[1], "Random") elseif pitch == "up" then ui.set(ref.antiaim.pitch[1], "Up") elseif pitch == "down" then ui.set(ref.antiaim.pitch[1], "Minimal") end
        if at_targets then ui.set(ref.antiaim.yaw_base, "At targets") else ui.set(ref.antiaim.yaw_base, "Local view") end
        ui.set(ref.antiaim.yaw[1], "180")
        if ways == 3 then ui.set(ref.antiaim.jitter[1], "Skitter") ui.set(ref.antiaim.jitter[2], multiplier) ui.set(ref.antiaim.yaw[2], 0) 
        else 
            ui.set(ref.antiaim.jitter[1], "Random")
            ui.set(ref.antiaim.jitter[2], randomization)
        if desyncside() == -1 then ui.set(ref.antiaim.yaw[2], left_yaw) else ui.set(ref.antiaim.yaw[2], right_yaw) end
        end
            ui.set(ref.antiaim.fs_body_yaw, false)
        if lby == "opposite" then
            ui.set(ref.antiaim.body_yaw[1], "Opposite")
            ui.set(ref.antiaim.fs_body_yaw, true)
        elseif lby == "static" then
            ui.set(ref.antiaim.body_yaw[1], "Static")
            if lbyside == "left" then ui.set(ref.antiaim.body_yaw[2], -58) elseif lbyside == "right" then ui.set(ref.antiaim.body_yaw[2], 58) elseif lbyside == "auto" then ui.set(ref.antiaim.body_yaw[2], 58 * calculate_body_fs()) end
        elseif lby == "tickcount" then 
            ui.set(ref.antiaim.body_yaw[1], "Jitter")
            ui.set(ref.antiaim.body_yaw[2], -1)
        elseif lby == "speed based" then
            ui.set(ref.antiaim.body_yaw[1], "Static")
            ui.set(ref.antiaim.body_yaw[2], smoothJitter(-60,60,lbyspeed))
        elseif lby == "off" then
            ui.set(ref.antiaim.body_yaw[1], "Off")
        end
        ui.set(ref.antiaim.fakelagenabled[1], true)
        -- ui.set(ref.antiaim.fakelagvariance, math.random(1,5))
        if fakelagmode == "maximum" then
        ui.set(ref.antiaim.fakelagamount[1], "Maximum")
        elseif fakelagmode == "dynamic" then
        ui.set(ref.antiaim.fakelagamount[1], "Dynamic")
        elseif fakelagmode == "fluctuate" then
        ui.set(ref.antiaim.fakelagamount[1], "Fluctuate")
        end
        ui.set(skeetfakelaglimit, fakelagslider)
        -- SAFEKNIFE
        if ui.get(antiaim_tab.other.safe_knife) and anti_aims:get_condition_type() == "aircrouching" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CKnife" then
            ui.set(ref.antiaim.pitch[1], "Minimal")
            ui.set(ref.antiaim.yaw_base, "At targets")
            ui.set(ref.antiaim.yaw[1], "180")
            ui.set(ref.antiaim.yaw[2], 0)
            ui.set(ref.antiaim.jitter[1], "Offset")
            ui.set(ref.antiaim.jitter[2], 0)
            ui.set(ref.antiaim.body_yaw[1], "Static")
            ui.set(ref.antiaim.body_yaw[2], 0)
            ui.set(ref.antiaim.fs_body_yaw, false)
        end
        -- SAFEZEUS
        if ui.get(antiaim_tab.other.safe_zeus) and anti_aims:get_condition_type() == "aircrouching" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CWeaponTaser" then
            ui.set(ref.antiaim.pitch[1], "Custom")
            ui.set(ref.antiaim.pitch[2], 89)
            ui.set(ref.antiaim.yaw_base, "At targets")
            ui.set(ref.antiaim.yaw[1], "180")
            ui.set(ref.antiaim.yaw[2], 0)
            ui.set(ref.antiaim.jitter[1], "Random")
            ui.set(ref.antiaim.jitter[2], 0)
            ui.set(ref.antiaim.body_yaw[1], "Static")
            ui.set(ref.antiaim.body_yaw[2], 0)
            ui.set(ref.antiaim.fs_body_yaw, false)
    end 
        -- SAFE HEAD 
        if ui.get(antiaim_tab.other.safe_head) and safeheadtarget() and (anti_aims:get_condition_type() == "aircrouching" or anti_aims:get_condition_type() == "crouching" or anti_aims:get_condition_type() == "crouchrunning" or anti_aims:get_condition_type() == "standing" or anti_aims:get_condition_type() == "fakelag") then
                ui.set(ref.antiaim.pitch[1], "Minimal")
            ui.set(ref.antiaim.yaw_base, "At targets")
            ui.set(ref.antiaim.yaw[1], "180")
            ui.set(ref.antiaim.yaw[2], 0)
            ui.set(ref.antiaim.jitter[1], "Offset")
            ui.set(ref.antiaim.jitter[2], 0)
            ui.set(ref.antiaim.body_yaw[1], "Static")
            ui.set(ref.antiaim.body_yaw[2], 0)
            ui.set(ref.antiaim.fs_body_yaw, false)
    end     
         -- STATIC FREESTAND
    if ui.get(antiaim_tab.other.static_freestand) and ui.get(keybinds_tab.freestand) then
        if ui.get(antiaim_tab.other.flickonmanuls) then cmd.force_defensive = 1 end
    if ui.get(antiaim_tab.other.flickonmanuls) and is_defensive then
        cmd.yaw = abstoflick + 180
        cmd.pitch = 1080
        cmd.force_defensive = 1
        ui.set(ref.antiaim.pitch[1], "Custom")
        ui.set(ref.antiaim.pitch[2], 0)
        ui.set(ref.antiaim.yaw_base, "Local view")
        ui.set(ref.antiaim.yaw[1], "180")
        ui.set(ref.antiaim.yaw[2], clamper(abstoflick))
        ui.set(ref.antiaim.jitter[1], "Offset")
        ui.set(ref.antiaim.jitter[2], 0)
        ui.set(ref.antiaim.body_yaw[1], "Static")
        ui.set(ref.antiaim.body_yaw[2], 0)
        ui.set(ref.antiaim.fs_body_yaw, false)   
    else
    abstoflick = antiaim_funcs.get_abs_yaw()
    ui.set(ref.antiaim.pitch[1], "Minimal")
    ui.set(ref.antiaim.yaw_base, "At targets")
    ui.set(ref.antiaim.yaw[1], "180")
    ui.set(ref.antiaim.yaw[2], 0)
    ui.set(ref.antiaim.jitter[1], "Offset")
    ui.set(ref.antiaim.jitter[2], 0)
    ui.set(ref.antiaim.body_yaw[1], "Static")
    ui.set(ref.antiaim.body_yaw[2], 0)
    ui.set(ref.antiaim.fs_body_yaw, true)
    end
        end   
        -- DEFENSIVE AA
        if is_defensive and defensivemode ~= "off" then 
            ui.set(ref.antiaim.body_yaw[1], "Off")
        if defensivepitch == "local view" then ui.set(ref.antiaim.pitch[1], "Off") 
        elseif defensivepitch == "sideways" then  ui.set(ref.antiaim.pitch[1], "Custom") ui.set(ref.antiaim.pitch[2], -69 - 19 * customsway())
        elseif defensivepitch == "sway" then  ui.set(ref.antiaim.pitch[1], "Custom") ui.set(ref.antiaim.pitch[2], -80 * customsway())
        elseif defensivepitch == "custom" then ui.set(ref.antiaim.pitch[1], "Custom") ui.set(ref.antiaim.pitch[2], defensiveslider) 
        elseif defensivepitch == "semi-up" then  ui.set(ref.antiaim.pitch[1], "Custom") ui.set(ref.antiaim.pitch[2], -45)
        elseif defensivepitch == "semi-down" then ui.set(ref.antiaim.pitch[1], "Custom") ui.set(ref.antiaim.pitch[2], 45)  
        elseif defensivepitch == "up" then ui.set(ref.antiaim.pitch[1], "Custom") ui.set(ref.antiaim.pitch[2], -89)
        elseif defensivepitch == "down" then ui.set(ref.antiaim.pitch[1], "Minimal") 
        elseif defensivepitch == "random" then ui.set(ref.antiaim.pitch[1], "Random") 
        end 
        if defensiveattargets then ui.set(ref.antiaim.yaw_base, "At targets") else ui.set(ref.antiaim.yaw_base, "Local view") end
        if defensiveyaw ~= "all the sides" then
            ui.set(ref.antiaim.jitter[1], "Random") ui.set(ref.antiaim.jitter[2], 0)
        if defensiveyaw == "slow spin" then
        ui.set(ref.antiaim.yaw[1], "Spin")
        ui.set(ref.antiaim.yaw[2], 30)
        elseif defensiveyaw == "fast spin" then
        ui.set(ref.antiaim.yaw[1], "Spin")
        ui.set(ref.antiaim.yaw[2], 117)
        elseif defensiveyaw == "sideways" then
        ui.set(ref.antiaim.yaw[1], "180")
        ui.set(ref.antiaim.yaw[2], smoothJitter(math.random(-90,-107), math.random(90,107), 10))
        elseif defensiveyaw == "custom" then
        ui.set(ref.antiaim.yaw[1], "180")
        ui.set(ref.antiaim.yaw[2], smoothJitter(defensiveleft, defensiveright, 10))
        end
    else 
            ui.set(ref.antiaim.yaw[1], "180")
            ui.set(ref.antiaim.jitter[1], "Skitter") ui.set(ref.antiaim.jitter[2], -180)
        end 


        end
    --
        -- MANUAL AA
        if manual_dir == 2 then
            cmd.force_defensive = 1
            if not is_defensive or not ui.get(antiaim_tab.other.flickonmanuls) then 
            ui.set(ref.antiaim.pitch[1], "Minimal")
            ui.set(ref.antiaim.yaw_base, "Local view")
            ui.set(ref.antiaim.yaw[1], "180")
            ui.set(ref.antiaim.yaw[2], 90)
            ui.set(ref.antiaim.jitter[1], "Offset")
            ui.set(ref.antiaim.jitter[2], 0)
            ui.set(ref.antiaim.body_yaw[1], "Off")
            ui.set(ref.antiaim.body_yaw[2], 0)
            ui.set(ref.antiaim.fs_body_yaw, false)
            else 
                ui.set(ref.antiaim.pitch[1], "Custom")
                ui.set(ref.antiaim.pitch[2], 0)
                ui.set(ref.antiaim.yaw_base, "Local view")
                ui.set(ref.antiaim.yaw[1], "180")
                ui.set(ref.antiaim.yaw[2], -90)
                ui.set(ref.antiaim.jitter[1], "Offset")
                ui.set(ref.antiaim.jitter[2], 0)
                ui.set(ref.antiaim.body_yaw[1], "Off")
                ui.set(ref.antiaim.body_yaw[2], 0)
                ui.set(ref.antiaim.fs_body_yaw, false)
            end
        elseif manual_dir == 1 then
            cmd.force_defensive = 1
            if not is_defensive or not ui.get(antiaim_tab.other.flickonmanuls) then 
                ui.set(ref.antiaim.pitch[1], "Minimal")
                ui.set(ref.antiaim.yaw_base, "Local view")
                ui.set(ref.antiaim.yaw[1], "180")
                ui.set(ref.antiaim.yaw[2], -90)
                ui.set(ref.antiaim.jitter[1], "Offset")
                ui.set(ref.antiaim.jitter[2], 0)
                ui.set(ref.antiaim.body_yaw[1], "Off")
                ui.set(ref.antiaim.body_yaw[2], 0)
                ui.set(ref.antiaim.fs_body_yaw, false)
                else 
                    ui.set(ref.antiaim.pitch[1], "Custom")
                    ui.set(ref.antiaim.pitch[2], 0)
                    ui.set(ref.antiaim.yaw_base, "Local view")
                    ui.set(ref.antiaim.yaw[1], "180")
                    ui.set(ref.antiaim.yaw[2], 90)
                    ui.set(ref.antiaim.jitter[1], "Offset")
                    ui.set(ref.antiaim.jitter[2], 0)
                    ui.set(ref.antiaim.body_yaw[1], "Off")
                    ui.set(ref.antiaim.body_yaw[2], 0)
                    ui.set(ref.antiaim.fs_body_yaw, false)
                end
        elseif manual_dir == 3 then
            cmd.force_defensive = 1
            if not is_defensive or not ui.get(antiaim_tab.other.flickonmanuls) then 
                ui.set(ref.antiaim.pitch[1], "Minimal")
                ui.set(ref.antiaim.yaw_base, "Local view")
                ui.set(ref.antiaim.yaw[1], "180")
                ui.set(ref.antiaim.yaw[2], 180)
                ui.set(ref.antiaim.jitter[1], "Offset")
                ui.set(ref.antiaim.jitter[2], 0)
                ui.set(ref.antiaim.body_yaw[1], "Off")
                ui.set(ref.antiaim.body_yaw[2], 0)
                ui.set(ref.antiaim.fs_body_yaw, false)
                else
                    ui.set(ref.antiaim.pitch[1], "Custom")
                    ui.set(ref.antiaim.pitch[2], 0)
                    ui.set(ref.antiaim.yaw_base, "Local view")
                    ui.set(ref.antiaim.yaw[1], "180")
                    ui.set(ref.antiaim.yaw[2], 0)
                    ui.set(ref.antiaim.jitter[1], "Offset")
                    ui.set(ref.antiaim.jitter[2], 0)
                    ui.set(ref.antiaim.body_yaw[1], "Off")
                    ui.set(ref.antiaim.body_yaw[2], 0)
                    ui.set(ref.antiaim.fs_body_yaw, false)
                end
        end
        end
---
    condtotake = antiaim_tab[anti_aims:get_condition_type()]
    condtotakeflags = antiaim_tab[anti_aims:get_fakelag_cond()]
    local pitch = ui.get(condtotake.pitch)
    local pitchslider = ui.get(condtotake.pitch_slider) 
    local at_targets = ui.get(condtotake.at_targets) 
    local ways = ui.get(condtotake.ways) 
    local left_yaw = ui.get(condtotake.left_yaw) 
    local right_yaw = ui.get(condtotake.right_yaw) 
    local multiplier = ui.get(condtotake.multiplier) 
    local randomization = ui.get(condtotake.randomization) 
    local lby = ui.get(condtotake.lby) 
    local lbyside = ui.get(condtotake.lbyside)  
    local lbyspeed = ui.get(condtotake.lbyspeed) 
    if anti_aims:get_condition_type() ~= "fakelag" then
     fakelagmode = ui.get(condtotake.fakelagmode) 
     fakelagslider = ui.get(condtotake.fakelagslider) 
     defensivemode = ui.get(condtotake.defensive.aa) 
     defensivepitch = ui.get(condtotake.defensive.pitch)  
     defensiveslider = ui.get(condtotake.defensive.pitch_slider) 
     defensiveattargets = ui.get(condtotake.defensive.at_targets) 
     defensiveyaw = ui.get(condtotake.defensive.yaw) 
     defensiveleft = ui.get(condtotake.defensive.left_yaw) 
     defensiveright = ui.get(condtotake.defensive.right_yaw) 
    else
         fakelagmode = ui.get(condtotakeflags.fakelagmode) 
         fakelagslider = ui.get(condtotakeflags.fakelagslider) 
         defensivemode = ui.get(condtotakeflags.defensive.aa) 
         defensivepitch = ui.get(condtotakeflags.defensive.pitch)  
         defensiveslider = ui.get(condtotakeflags.defensive.pitch_slider) 
         defensiveattargets = ui.get(condtotakeflags.defensive.at_targets) 
         defensiveyaw = ui.get(condtotakeflags.defensive.yaw) 
         defensiveleft = ui.get(condtotakeflags.defensive.left_yaw) 
         defensiveright = ui.get(condtotakeflags.defensive.right_yaw) 
    end
    if exploiting and ui.get(ragebot_tab.custom_exploits) then 
        ui.set(ref.antiaim.fakelagenabled[1], false)
    end
    handle_aa(pitch, pitchslider, at_targets, ways, left_yaw, right_yaw, multiplier, randomization, lby, lbyside, lbyspeed, fakelagmode, fakelagslider, defensivemode, defensivepitch, defensiveslider, defensiveattargets, defensiveyaw, defensiveleft, defensiveright)

end)

client.set_event_callback("setup_command", function()
    if ui.get(antiaim_tab.other.avoid_backstab) and antibackstab() then
        ui.set(ref.antiaim.pitch[1], "Down")
        ui.set(ref.antiaim.yaw_base, "At targets")
        ui.set(ref.antiaim.yaw[1], "180")
        ui.set(ref.antiaim.yaw[2], 180)
        ui.set(ref.antiaim.jitter[1], "Offset")
        ui.set(ref.antiaim.jitter[2], 0)
        ui.set(ref.antiaim.body_yaw[1], "Static")
        ui.set(ref.antiaim.body_yaw[2], 0)
        ui.set(ref.antiaim.fs_body_yaw, false)
    end
end)

-- bombsite e fix 
 function distance3d(x1, y1, z1, x2, y2, z2)
	return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

 function entity_has_c4(ent)
	local bomb = entity.get_all("CC4")[1]
	return bomb ~= nil and entity.get_prop(bomb, "m_hOwnerEntity") == ent
end
 classnames = {
	"CWorld",
	"CCSPlayer",
	"CFuncBrush"
	}
    trynna_plant = false
    using = false
-- LEGIT AA + BOMBSITE E FIX
    client.set_event_callback("setup_command", function(cmd)
		local plocal = entity.get_local_player()
        if cmd.in_use == 1 then
        if ui.get(antiaim_tab.other.legitaa) == "off" then
                ui.set(ref.antiaim.pitch[1], "Off")
                ui.set(ref.antiaim.yaw_base, "Local view")
                ui.set(ref.antiaim.yaw[1], "180")
                ui.set(ref.antiaim.yaw[2], 180)
                ui.set(ref.antiaim.jitter[1], "Offset")
                ui.set(ref.antiaim.jitter[2], 0)
                ui.set(ref.antiaim.body_yaw[1], "Off")
                ui.set(ref.antiaim.body_yaw[2], 0)
                ui.set(ref.antiaim.fs_body_yaw, false)
        elseif ui.get(antiaim_tab.other.legitaa) == "2 way" then
            ui.set(ref.antiaim.pitch[1], "Off")
            ui.set(ref.antiaim.yaw_base, "Local view")
            ui.set(ref.antiaim.yaw[1], "180")
            ui.set(ref.antiaim.yaw[2], 180)
            ui.set(ref.antiaim.jitter[1], "Center")
            ui.set(ref.antiaim.jitter[2], 90)
            ui.set(ref.antiaim.body_yaw[1], "Jitter")
            ui.set(ref.antiaim.body_yaw[2], -1)
            ui.set(ref.antiaim.fs_body_yaw, false)
        elseif ui.get(antiaim_tab.other.legitaa) == "3 way" then
            ui.set(ref.antiaim.pitch[1], "Off")
            ui.set(ref.antiaim.yaw_base, "Local view")
            ui.set(ref.antiaim.yaw[1], "180")
            ui.set(ref.antiaim.yaw[2], 180)
            ui.set(ref.antiaim.jitter[1], "Skitter")
            ui.set(ref.antiaim.jitter[2], 77)
            ui.set(ref.antiaim.body_yaw[1], "Jitter")
            ui.set(ref.antiaim.body_yaw[2], -1)
            ui.set(ref.antiaim.fs_body_yaw, false)
        elseif ui.get(antiaim_tab.other.legitaa) == "static" then
            ui.set(ref.antiaim.pitch[1], "Off")
            ui.set(ref.antiaim.yaw_base, "Local view")
            ui.set(ref.antiaim.yaw[1], "180")
            ui.set(ref.antiaim.yaw[2], 180)
            ui.set(ref.antiaim.jitter[1], "Offset")
            ui.set(ref.antiaim.jitter[2], 0)
            ui.set(ref.antiaim.body_yaw[1], "Opposite")
            ui.set(ref.antiaim.fs_body_yaw, true)
        end
            end 
		if not plocal or not entity.is_alive(plocal) then return end
		local distance = 100
		local bomb = entity.get_all("CPlantedC4")[1]
		local bomb_x, bomb_y, bomb_z = entity.get_prop(bomb, "m_vecOrigin")

		if bomb_x ~= nil then
			local player_x, player_y, player_z = entity.get_prop(plocal, "m_vecOrigin")
			distance = distance3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
		end
		
		local team_num = entity.get_prop(plocal, "m_iTeamNum")
		local defusing = team_num == 3 and distance < 62

		local on_bombsite = entity.get_prop(plocal, "m_bInBombZone")

		local has_bomb = entity_has_c4(plocal)
		local trynna_plant = on_bombsite ~= 0 and team_num == 2 and has_bomb and not ui.get(antiaim_tab.other.bombsiteefix)
		
		local px, py, pz = client.eye_position()
		local pitch, yaw = client.camera_angles()
	
		local sin_pitch = math.sin(math.rad(pitch))
		local cos_pitch = math.cos(math.rad(pitch))
		local sin_yaw = math.sin(math.rad(yaw))
		local cos_yaw = math.cos(math.rad(yaw))

		local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

		local fraction, entindex = client.trace_line(plocal, px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))

		local using = true

		if entindex ~= nil then
			for i=0, #classnames do
				if entity.get_classname(entindex) == classnames[i] then
					using = false
				end
			end
		end

		if not using and not trynna_plant and not defusing then
			cmd.in_use = 0
		end
end)


-- ANIM FUCKERS AND SHIT
client.set_event_callback("setup_command", function(e)
    local local_player = entity.get_local_player()
    legMovement = ui.reference("AA", "Other", "Leg movement")
    local is_on_ground = e.in_jump == 0
    if func.includes(ui.get(visuals_tab.animfixsel), "ground") then
        if func.includes(ui.get(visuals_tab.animfixsel), "ground") then
            entity.set_prop(local_player, "m_flPoseParameter", client.random_float(5 / 10, 1), 0)
            ui.set(legMovement, client.random_int(1, 2) == 1 and "Off" or "Always slide")
        end
    end
end)

local legsSaved = false
local legsTypes = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
local ground_ticks = 0
client.set_event_callback("pre_render", function()
    if not entity.get_local_player() then return end
    if not ui.get(visuals_tab.animfixenb) then return end
    local lp = entity.get_local_player()
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)
    local self_index = c_entity.new(lp)

    if func.includes(ui.get(visuals_tab.animfixsel), "air") and ui.get(visuals_tab.airtype) == "default" then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
    end

    if func.includes(ui.get(visuals_tab.animfixsel), "ground") then
        entity.set_prop(lp, "m_flPoseParameter", 1, globals.tickcount() % 3 > 0 and 1 / 3 or 10)
    end

    if func.includes(ui.get(visuals_tab.animfixsel), "air") and ui.get(visuals_tab.airtype) == "shaker" then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 3)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 7)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 6)
    end

    if func.includes(ui.get(visuals_tab.animfixsel), "zero on ground") then
        ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0

        if ground_ticks > 20 and ground_ticks < 150 then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end

    if func.includes(ui.get(visuals_tab.animfixsel), "bodylean") then
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end

        local x_velocity = entity.get_prop(lp, "m_vecVelocity[0]")
        if math.abs(x_velocity) >= 0 then
            self_anim_overlay.weight = 100 / 100
        end
    end

    if func.includes(ui.get(visuals_tab.animfixsel), "air") and ui.get(visuals_tab.airtype) == "moonwalk" then
        if not legsSaved then
            legsSaved = ui.get(legMovement)
        end
        ui.set_visible(legMovement, false)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
        local me = ent.get_local_player()
        local flags = me:get_prop("m_fFlags")
        local onground = bit.band(flags, 1) ~= 0
        if not onground then
            local my_animlayer = me:get_anim_overlay(6) -- MOVEMENT_MOVE
            my_animlayer.weight = 1
        end
        ui.set(legMovement, "Off")
    elseif (legsSaved == "Off" or legsSaved == "Always slide" or legsSaved == "Never slide") then
        ui.set_visible(legMovement, true)
        ui.set(legMovement, legsSaved)
        legsSaved = false
    end

    
end)


-- LACONISM INDICATORS
local curtime = globals.curtime
local unset_event_callback = client.unset_event_callback
local render_circle_outline, measure_text, render_text = renderer.circle_outline, renderer.measure_text, renderer.text
local table_insert = table.insert
local ui_get = ui.get

local x, y = client.screen_size()

local Width = 6
local Height = (y / 2) + y /12
function lerp(a, b, t)
    if not b or not a or not t then return end
    return a + (b - a) * t
end
local indicators = {}

local TIME_TO_PLANT_BOMB = 3
local timeAtBombWillBePlanted

local function innerCircleOutlinePercentage()
	local timeElapsed = (curtime() + TIME_TO_PLANT_BOMB) - timeAtBombWillBePlanted
	local timeElapsedInPerc = (timeElapsed / TIME_TO_PLANT_BOMB * 100) + 0.5
	return timeElapsedInPerc * 0.01
end

-- Gap between indicators text
local indicatorTextGap = 36

-- Outer circle
local o_circleRadius = 6
local o_cricleThickness = o_circleRadius/2

-- Inner circle
local i_circleRadius = o_circleRadius-1
local i_cricleThickness = (o_circleRadius-1)/3
dtcircle = 0
-- Main
client.set_event_callback('paint', function ()
    if safeheadtarget() and ui.get(antiaim_tab.other.safe_head) and (anti_aims:get_condition_type() == "aircrouching" or anti_aims:get_condition_type() == "crouching" or anti_aims:get_condition_type() == "crouchrunning" or anti_aims:get_condition_type() == "standing" or anti_aims:get_condition_type() == "fakelag") then
    renderer.indicator(255, 255, 255, 200, "SAFEHEAD") end
    if ui.get(antiaim_tab.other.avoid_backstab) and antibackstab() then
        renderer.indicator(255, 255, 255, 200, "ANTI BACKSTAB") end
    if not ui.get(visuals_tab.indicators) then
        return end
	for i=1, #indicators do
		local indicator = indicators[i]

		local text = indicator.text
		local r, g, b, a = indicator.r, indicator.g, indicator.b, indicator.a

		local textH = Height + (i*-indicatorTextGap) + (#indicators*indicatorTextGap)
        m_textW, m_textH = measure_text('+b', text)
        renderer.gradient(Width, textH, m_textW + 50, m_textH + 4, 0, 0, 0, 255, 0, 0, 0, 0,true)
        renderer.blur(Width, textH, m_textW + 50, m_textH + 4)
        renderer.rectangle(Width, textH, 3, m_textH + 4, r, g, b, a)
		render_text(Width + 10, textH + 2, r, g, b, a, '+b', 0, text)
        if indicator.r == 255 and indicator.g == 0 and indicator.b == 50 and text:find("DT") then
			dtcircle = lerp(dtcircle, 0, globals.frametime() * 24)
			elseif text:find("DT") then
            dtcircle = lerp(dtcircle, 1, globals.frametime() * 24)
			end			
        -- if text:find("DT") then
        --     renderer.circle_outline(Width + 22 + m_textW, textH + (m_textH + 4) / 2 + 2, 0, 0, 0, 200, 8, 0, 1.0, 8 / 3)
        --     renderer.circle_outline(Width + 22 + m_textW, textH + (m_textH + 4) / 2 + 2, r, g, b, a, 8, 0, dtcircle, 8 / 3)
        -- end        
		if isBombBeingPlanted and text:find('Bombsite') then
			local m_textW, m_textH = measure_text('+b', text)

			local cricleW = Width+m_textW+o_circleRadius+4
			local cricleH = textH+(m_textH/1.71)

			render_circle_outline(cricleW, cricleH, 0, 0, 0, 200, o_circleRadius, 0, 1.0, o_cricleThickness)
			render_circle_outline(cricleW, cricleH, 255, 255, 255, 200, i_circleRadius, 0, innerCircleOutlinePercentage(), i_cricleThickness)
		end
	end

	-- Reset indicator table
	indicators = {}
end)

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

--
local function IndicatorCallback(indicator)
    if not ui.get(visuals_tab.indicators) then
        return end
	table_insert(indicators, indicator)
end


client.set_event_callback('shutdown', function ()
	unset_event_callback('indicator', IndicatorCallback)
end)
client.set_event_callback('paint', function ()
    if not ui.get(visuals_tab.indicators) then
	unset_event_callback('indicator', IndicatorCallback)
    else
        client.set_event_callback('indicator', IndicatorCallback)
 end
end)
-- EVENT LOGS
-- local variables for API functions. any changes to the line below will be lost on re-generation
local globals_curtime, require, ipairs, math_abs, table_insert, table_remove, ui_get, ui_new_checkbox, ui_reference, ui_set, ui_set_callback, ui_set_enabled, defer = globals.curtime, require, ipairs, math.abs, table.insert, table.remove, ui.get, ui.new_checkbox, ui.reference, ui.set, ui.set_callback, ui.set_enabled, defer


local custom_logs = {} do
    local logs = {}
    function custom_logs.count_lines()
        local count = 0
        for _, log in ipairs(logs) do
            if log.newline then count = count + 1 end
        end
        return count
    end
    
    function custom_logs.remove_line()
        while true do
            local log = table_remove(logs, 1)
            if log.newline then
                break
            end
        end
    end

    function custom_logs.output(e)
        local cur_log = { text = e.text, r = e.r, g = e.g, b = e.b, a = e.a, time = globals_curtime(), newline = (e.text:sub(-1) ~= "\0") }
        table_insert(logs, cur_log)
    
        if custom_logs.count_lines() > 6 then
            custom_logs.remove_line()
        end
    end

    function custom_logs.paint()
        if not ui.get(visuals_tab.eventlogs) then return end
        local screen_x, screen_y = client.screen_size()
        local x = 8
        local y = screen_y / 2 - screen_y / 14.4
        local i = 1
    
        while i <= #logs do
            local log = logs[i]
            local text_width, text_height = renderer.measure_text("",log.text)
            renderer.rectangle(x - 2, y, 2, text_height + 4, 255, 255, 255, 200)
            renderer.gradient(x, y, text_width + 50, text_height + 4, 0, 0, 0, 255, 0, 0, 0, 0,true)
            renderer.blur(x, y, text_width + 50, text_height + 4)
            renderer.text(x + 5, y + 1, log.r, log.g, log.b, log.a, '', 0, log.text)
    
            if log.newline then
                y = y + text_height + 8
                x = 8
            else
                x = x + text_width
            end
    
            if math_abs(globals_curtime() - log.time) > 8 then
                table_remove(logs, i)
                y = y - text_height
            else
                i = i + 1
            end
        end
    end
end

local draw_output = ui_reference("Misc", "Miscellaneous", "Draw console output")
ui_set_callback(ui_reference("AA", "Anti-aimbot angles", "event logs"), function (self)
    local enabled = ui_get(self)
    local update_callback = enabled and client.set_event_callback or client.unset_event_callback

    update_callback("output", custom_logs.output)
    update_callback("paint", custom_logs.paint)
    
    ui_set(draw_output, not enabled)
    ui_set_enabled(draw_output, not enabled)
end)

defer(function ()
    ui_set(draw_output, true)
    ui_set_enabled(draw_output, true)
end)

local log = client.log

local hitgroup_names = {
    "generic",
    "head",
    "chest",
    "stomach",
    "left arm",
    "right arm",
    "left leg",
    "right leg",
    "neck",
    "?",
    "gear"
}
dt_active = false
client.set_event_callback("aim_fire", function(e)
    if not ui.get(visuals_tab.eventlogs) then return end
    stored_shot = {
    damage = e.damage,
    hitbox = hitgroup_names[e.hitgroup + 1],
    lagcomp = e.teleported,
    backtrack = globals.tickcount() - e.tick
}
end)
local function on_aim_missed( event )
    if not ui.get(visuals_tab.eventlogs) then return end
    output = string.format("missed %s in the %s for %s (%s health remaining) due to %s | bt= %s | hc= %s",entity.get_player_name( event.target ), stored_shot.hitbox, stored_shot.damage, entity.get_prop( event.target, 'm_iHealth'),event.reason, stored_shot.backtrack, event.hit_chance)
      log(output)
end

client.set_event_callback( "aim_miss", on_aim_missed )

local function on_aim_hit( event )
    if not ui.get(visuals_tab.eventlogs) then return end
    output = string.format("hit %s in the %s (%s) for %s (%s) (%s health remaining) | bt= %s | hc= %s",entity.get_player_name( event.target ), hitgroup_names[ event.hitgroup + 1 ], stored_shot.hitbox, event.damage, stored_shot.damage, entity.get_prop( event.target, 'm_iHealth'),stored_shot.backtrack, event.hit_chance)
    --output = 'hit ' .. entity.get_player_name( event.target ) .. ' for ' .. event.damage .. ' ('.. stored_shot.damage ..') ' .. entity
    log(output)
end

client.set_event_callback( "aim_hit", on_aim_hit )
-- 
local animated =
{
desyncsize = 0,
newsway = 0,
dtalpha = 75,
hsalpha = 75,
fsalpha = 75,
dmgalpha = 75, 
lcbar = 0,
addiction = 0,
baralpha = 1,
scopedalpha = 1,
scopedalign = 0,
arrow_left = 0,
arrow_right = 0,
forarrows = 0,
inactive_fraction = 0,
active_fraction = 0, 
fraction = 0,
hide_fraction = 0,
scoped_fraction = 0,
}
ctx_clamp = function(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end
easeInOut = function(t)
    return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
end
function round(number)
    return math.floor(number + 0.5)
  end
-- CENTER INDICATORS
client.set_event_callback("paint", function()
    local player = entity.get_local_player()
    if not player or not entity.is_alive(player) then return end
    cvet1, cvet2, cvet3, cvet4 = ui.get(visuals_tab.accent)
local scr_x, scr_y = client.screen_size()
renderer.text(scr_x / 2 - renderer.measure_text("+","laconism") / 2, scr_y - 30, 255, 255, 255, 50, "+", nil, animate_text(globals.curtime() * 1.2, "laconism", 0, 0, 0, 255, cvet1, cvet2, cvet3, 255)) 
local scr = { client.screen_size() }
local scpd = entity.get_prop(entity.get_local_player(), "m_bIsScoped")
local me = entity.get_local_player()
if not me or not entity.is_alive(me) then return end
-- Arrows
if ui.get(visuals_tab.arrows) ~= "Off" then
	if scpd ~= 0 then animated.forarrows = lerp(animated.forarrows, 0, globals.frametime() * 24) else animated.forarrows = lerp(animated.forarrows, 1, globals.frametime() * 24) end
	if ui.get(visuals_tab.arrows) == "Manual" then
	if manual_dir == 2 then
	animated.arrow_right = lerp(animated.arrow_right, 255, globals.frametime() * 24)
	else
	animated.arrow_right = lerp(animated.arrow_right, 0, globals.frametime() * 24)
	end
	if manual_dir == 1 then
	animated.arrow_left = lerp(animated.arrow_left, 255, globals.frametime() * 24)
	else
	animated.arrow_left = lerp(animated.arrow_left, 0, globals.frametime() * 24)
	end


	renderer.text(scr[1] / 2 - 85 , scr[2] / 2, cvet1, cvet2, cvet3, animated.arrow_left, "+cb", nil, "⮘") 
	renderer.text(scr[1] / 2 + 85 , scr[2] / 2, cvet1, cvet2, cvet3, animated.arrow_right, "+cb", nil, "⮚") 
	elseif ui.get(visuals_tab.arrows) == "TS4" then
	x = scr[1]
	y = scr[2]
		local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
		renderer.triangle(x / 2 + 55, y / 2 + 2, x / 2 + 42, y / 2 - 7, x / 2 + 42, y / 2 + 11, 
		manual_dir == 2 and cvet1 or 25, 
		manual_dir == 2 and cvet2 or 25, 
		manual_dir == 2 and cvet3 or 25, 
		manual_dir == 2 and 255 * animated.forarrows or 160 * animated.forarrows)

		renderer.triangle(x / 2 - 55, y / 2 + 2, x / 2 - 42, y / 2 - 7, x / 2 - 42, y / 2 + 11, 
		manual_dir == 1 and cvet1 or 25, 
		manual_dir == 1 and cvet2 or 25, 
		manual_dir == 1 and cvet3 or 25, 
		manual_dir == 1 and 255 * animated.forarrows or 160 * animated.forarrows)
	
		renderer.rectangle(x / 2 + 38, y / 2 - 7, 2, 18, 
		bodyyaw < -10 and cvet1 or 25,
		bodyyaw < -10 and cvet2 or 25,
		bodyyaw < -10 and cvet3 or 25,
		bodyyaw < -10 and 255 * animated.forarrows or 160 * animated.forarrows)
		renderer.rectangle(x / 2 - 40, y / 2 - 7, 2, 18,			
		bodyyaw > 10 and cvet1 or 25,
		bodyyaw > 10 and cvet2 or 25,
		bodyyaw > 10 and cvet3 or 25,
		bodyyaw > 10 and 255 * animated.forarrows or 160 * animated.forarrows)
	elseif ui.get(visuals_tab.arrows) == "Old" then
		if manual_dir == 2 then
	animated.arrow_right = lerp(animated.arrow_right, 255, globals.frametime() * 24)
	else
	animated.arrow_right = lerp(animated.arrow_right, 0, globals.frametime() * 24)
	end
	if manual_dir == 1 then
	animated.arrow_left = lerp(animated.arrow_left, 255, globals.frametime() * 24)
	else
	animated.arrow_left = lerp(animated.arrow_left, 0, globals.frametime() * 24)
	end
	renderer.text(scr[1] / 2 - 85 , scr[2] / 2, cvet1, cvet2, cvet3, animated.arrow_left, "+cb", nil, "<") 
	renderer.text(scr[1] / 2 + 85 , scr[2] / 2, cvet1, cvet2, cvet3, animated.arrow_right, "+cb", nil, ">") 
	elseif ui.get(visuals_tab.arrows) == "Always" then
			if manual_dir == 2 then
	animated.arrow_right = lerp(animated.arrow_right, 255, globals.frametime() * 24)
	else
	animated.arrow_right = lerp(animated.arrow_right, 0, globals.frametime() * 24)
	end
	if manual_dir == 1 then
	animated.arrow_left = lerp(animated.arrow_left, 255, globals.frametime() * 24)
	else
	animated.arrow_left = lerp(animated.arrow_left, 0, globals.frametime() * 24)
	end
	renderer.text(scr[1] / 2 - 55 , scr[2] / 2, 255, 255, 255, 50 * animated.forarrows, "+c", nil, "<") 
	renderer.text(scr[1] / 2 + 55 , scr[2] / 2, 255, 255, 255, 50 * animated.forarrows, "+c", nil, ">") 
	renderer.text(scr[1] / 2 - 55 , scr[2] / 2, cvet1, cvet2, cvet3, animated.arrow_left, "+c", nil, "<") 
	renderer.text(scr[1] / 2 + 55 , scr[2] / 2, cvet1, cvet2, cvet3, animated.arrow_right, "+c", nil, ">") 
end
	end
-- ARROWS
-- dangerous indicators
if ui.get(visuals_tab.center_indicators) == "dangerous" then
if scpd ~= 0 then 
if ui.get(visuals_tab.onscope) == "left" then 
    animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    animated.scopedalign = lerp(animated.scopedalign, -40, globals.frametime() * 24)
elseif ui.get(visuals_tab.onscope) == "alpha" then 
    animated.scopedalpha = lerp(animated.scopedalpha, 0, globals.frametime() * 24)
    animated.scopedalign = lerp(animated.scopedalign, 0, globals.frametime() * 24)
elseif ui.get(visuals_tab.onscope) == "right" then 
    animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    animated.scopedalign = lerp(animated.scopedalign, 40, globals.frametime() * 24)
elseif ui.get(visuals_tab.onscope) == "off" then 
    animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    animated.scopedalign = lerp(animated.scopedalign, 0, globals.frametime() * 24)
end
else
    animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    animated.scopedalign = lerp(animated.scopedalign, 0, globals.frametime() * 24)
end
angle = math.min(57, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60))	
if angle > 35 then
animated.desyncsize = lerp(animated.desyncsize, renderer.measure_text("-", string.upper(luaname)) + renderer.measure_text("-", string.upper(luabuild)) + math.random(0,-20), globals.frametime() * 24)
elseif angle > 10 then
animated.desyncsize = lerp(animated.desyncsize, angle, globals.frametime() * 24)
elseif angle < 10 or is_freezetime() then
animated.desyncsize = lerp(animated.desyncsize, 0, globals.frametime() * 24)
end
if shouldonfreezetime and is_freezetime() then
    animated.desyncsize = lerp(animated.desyncsize, 0, globals.frametime() * 24)
end
dtchargedforinds = is_defensive and 1 or 0
if sway() > 0 then
animated.newsway = lerp(animated.newsway, sway(), globals.frametime() * 24)
else 
animated.newsway = lerp(animated.newsway, 0, globals.frametime() * 24)
end
if animated.desyncsize < 2 or anti_aims:get_condition_type() == "Warmup" then
    animated.addiction = lerp(animated.addiction, 8, globals.frametime() * 24)
    animated.baralpha = lerp(animated.baralpha, 0, globals.frametime() * 24)
else 
    animated.addiction = lerp(animated.addiction, 0, globals.frametime() * 24)
    animated.baralpha = lerp(animated.baralpha, 1, globals.frametime() * 24)
end
renderer.text(scr_x / 2 - 35 + animated.scopedalign, scr_y / 2 + 12 + animated.addiction, 255, 255, 255, 255 * animated.scopedalpha, "-", nil, string.upper(luaname))
renderer.text(scr_x / 2 - 33 + animated.scopedalign + renderer.measure_text("-", string.upper(luaname)), scr_y / 2 + 12 + animated.addiction, cvet1, cvet2, cvet3, animated.newsway, "-", nil, animate_text(globals.curtime(), string.upper(luabuild), cvet1, cvet2, cvet3, animated.newsway * animated.scopedalpha, cvet1 / 1.5, cvet2 / 1.5, cvet3 / 1.5, animated.newsway * animated.scopedalpha))
renderer.rectangle(scr_x / 2 - 36 + animated.scopedalign, scr_y / 2 + 23, renderer.measure_text("-", string.upper(luaname)) + renderer.measure_text("-", string.upper(luabuild)) + 8, 5, 0, 0, 0, 255 * animated.baralpha * animated.scopedalpha)
renderer.gradient(scr_x / 2 - 35 + animated.scopedalign, scr_y / 2 + 24, animated.desyncsize, 3, cvet1, cvet2, cvet3, 255 * animated.baralpha * animated.scopedalpha, cvet1 / 4, cvet2 / 4, cvet3 / 4, 255 * animated.baralpha * animated.scopedalpha, true)
offsetinds = scr_y / 2 + 30
if ui.get(keysforinds.doubletap[1]) and ui.get(keysforinds.doubletap[2]) then 
    animated.dtalpha = lerp(animated.dtalpha,255,globals.frametime() * 24)
    animated.hsalpha = lerp(animated.hsalpha,75,globals.frametime() * 24)
    renderer.text(scr_x / 2 - 35 + animated.scopedalign, offsetinds, 255, 255, 255, animated.dtalpha * animated.scopedalpha, "-", nil, "DOUBLETAP")
else
    animated.dtalpha = lerp(animated.dtalpha,75,globals.frametime() * 24)
    renderer.text(scr_x / 2 - 35 + animated.scopedalign, offsetinds, 255, 255, 255, animated.dtalpha * animated.scopedalpha, "-", nil, "DOUBLETAP")
end
if ui.get(keysforinds.hideshots[1]) and ui.get(keysforinds.hideshots[2]) then 
    animated.hsalpha = lerp(animated.hsalpha,255,globals.frametime() * 24)
    renderer.text(scr_x / 2 - 35 + animated.scopedalign + renderer.measure_text("-", "DOUBLETAP") + 2, offsetinds, 255, 255, 255, animated.hsalpha * animated.scopedalpha, "-", nil, "ONSHOT")
else
    animated.hsalpha = lerp(animated.hsalpha,75,globals.frametime() * 24)
    renderer.text(scr_x / 2 - 35 + animated.scopedalign + renderer.measure_text("-", "DOUBLETAP") + 2, offsetinds, 255, 255, 255, animated.hsalpha * animated.scopedalpha, "-", nil, "ONSHOT")
end
if ui.get(keybinds_tab.freestand) and ui.get(keybinds_tab.freestand) then 
    animated.fsalpha = lerp(animated.fsalpha,255,globals.frametime() * 24)
    renderer.text(scr_x / 2 - 35 + animated.scopedalign, offsetinds + 10, 255, 255, 255, animated.fsalpha * animated.scopedalpha, "-", nil, "FS")
else
    animated.fsalpha = lerp(animated.fsalpha,75,globals.frametime() * 24)
    renderer.text(scr_x / 2 - 35 + animated.scopedalign, offsetinds + 10, 255, 255, 255, animated.fsalpha * animated.scopedalpha, "-", nil, "FS")
end
if ui.get(keysforinds.dmg[1]) and ui.get(keysforinds.dmg[2]) then 
    animated.dmgalpha = lerp(animated.dmgalpha,255,globals.frametime() * 24)
    renderer.text(scr_x / 2 - 35 + animated.scopedalign + renderer.measure_text("-", "FS") + 2, offsetinds + 10, 255, 255, 255, animated.dmgalpha * animated.scopedalpha, "-", nil, "DMG")
else
    animated.dmgalpha = lerp(animated.dmgalpha,75,globals.frametime() * 24)
    renderer.text(scr_x / 2 - 35 + animated.scopedalign + renderer.measure_text("-", "FS") + 2, offsetinds + 10, 255, 255, 255, animated.dmgalpha * animated.scopedalpha, "-", nil, "DMG")
end
renderer.text(scr_x / 2 - 35  + animated.scopedalign + renderer.measure_text("-", "FS") + renderer.measure_text("-", "DMG") + 4, offsetinds + 10, 255, 255, 255, 255 * animated.scopedalpha, "-", nil, "LC")
if dtchargedforinds == 1 then animated.lcbar = lerp(animated.lcbar,renderer.measure_text("-", "ONSHOT"),globals.frametime() * 24) else animated.lcbar = lerp(animated.lcbar,0,globals.frametime() * 24) end
renderer.rectangle(scr_x / 2 - 35 + animated.scopedalign + renderer.measure_text("-", "FS") + renderer.measure_text("-", "DMG") + renderer.measure_text("-", "LC") + 10, offsetinds + 14, renderer.measure_text("-", "ONSHOT"), 3, 0, 0, 0, 200 * animated.scopedalpha)
renderer.gradient(scr_x / 2 - 35 + animated.scopedalign + renderer.measure_text("-", "FS") + renderer.measure_text("-", "DMG") + renderer.measure_text("-", "LC") + 10, offsetinds + 14, animated.lcbar, 3, cvet1, cvet2, cvet3, 255, cvet1 / 4, cvet2 / 4, cvet3 / 4, 255 / 2 * animated.scopedalpha, true)
offsetinds = offsetinds + 15
elseif ui.get(visuals_tab.center_indicators) == "minimalism" then
    local x, y = client.screen_size()
    local logo_w, logo_h = renderer.measure_text("-", string.format("%s %s",string.upper(luaname), string.upper(luabuild)))
    local r,g,b,a = cvet1, cvet2, cvet3, cvet4
    state = anti_aims:get_condition_type()

    if ui.get(visuals_tab.onscope) == "right" then 
    if scpd ~= 0 then
        animated.scoped_fraction = 1
        animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    else
        animated.scoped_fraction = lerp(animated.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
        animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    end
    elseif ui.get(visuals_tab.onscope) == "left" then 
    if scpd ~= 0 then
    animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    animated.scoped_fraction = lerp(animated.scoped_fraction, -1, globals.frametime() * 24, 0, 1)
    else
    animated.scoped_fraction = lerp(animated.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
    animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    end
    elseif ui.get(visuals_tab.onscope) == "alpha" then 
    animated.scoped_fraction = lerp(animated.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
    if scpd ~= 0 then
    animated.scopedalpha = lerp(animated.scopedalpha, 0, globals.frametime() * 24)
    else 
        animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    end
    elseif ui.get(visuals_tab.onscope) == "off" then 
        animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
        animated.scoped_fraction = lerp(animated.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
    end
    local scoped_fraction = animated.scoped_fraction 
    renderer.text(x/2 + ((logo_w + 2)/2) * scoped_fraction, y/2 + 20, 255, 255, 255, 255 * animated.scopedalpha , "-c", 0, "LACONISM ", "\a" .. rgba_to_hex( r, g, b, 255 * math.abs(math.cos(globals.curtime()*2)) * animated.scopedalpha) .. string.upper(luabuild))

    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack")
    local next_primary_attack = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_flNextPrimaryAttack")

    local dt_toggled = ui.get(keysforinds.doubletap[1]) and ui.get(keysforinds.doubletap[2])
    local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime())

    if dt_toggled and dt_active then
        animated.active_fraction = ctx_clamp(animated.active_fraction + globals.frametime()/0.15, 0, 1)
    else
        animated.active_fraction = ctx_clamp(animated.active_fraction - globals.frametime()/0.15, 0, 1)
    end

    if dt_toggled and not dt_active then
        animated.inactive_fraction = ctx_clamp(animated.inactive_fraction + globals.frametime()/0.15, 0, 1)
    else
        animated.inactive_fraction = ctx_clamp(animated.inactive_fraction - globals.frametime()/0.15, 0, 1)
    end

    if ui.get(keysforinds.hideshots[1]) and ui.get(keysforinds.hideshots[2]) and not dt_toggled then
        animated.hide_fraction = ctx_clamp(animated.hide_fraction + globals.frametime()/0.15, 0, 1)
    else
        animated.hide_fraction = ctx_clamp(animated.hide_fraction - globals.frametime()/0.15, 0, 1)
    end

    if math.max(animated.hide_fraction, animated.inactive_fraction, animated.active_fraction) > 0 then
        animated.fraction = ctx_clamp(animated.fraction + globals.frametime()/0.2, 0, 1)
    else
        animated.fraction = ctx_clamp(animated.fraction - globals.frametime()/0.2, 0, 1)
    end

    local dt_size = renderer.measure_text("-", "DT ")
    local ready_size = renderer.measure_text("-", "CHARGED")
    renderer.text(x/2 + ((dt_size + ready_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, animated.active_fraction * 255 * animated.scopedalpha, "-c", dt_size + animated.active_fraction * ready_size + 1, "DT ", "\a" .. rgba_to_hex(155, 255, 155, 255 * animated.active_fraction * animated.scopedalpha) .. "CHARGED")

    local charging_size = renderer.measure_text("-", "CHARGING")
    local ret = animate_text(globals.curtime() * 8, "CHARGING", 100, 255, 100, 255 * animated.scopedalpha, 255, 100, 100, 255 * animated.scopedalpha) 
    renderer.text(x/2 + ((dt_size + charging_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, animated.inactive_fraction * 255 * animated.scopedalpha, "-c", dt_size + animated.inactive_fraction * charging_size + 1, "DT ", ret)

    local hide_size = renderer.measure_text("-", "HIDE ")
    local active_size = renderer.measure_text("-", "ACTIVE")
    renderer.text(x/2 + ((hide_size + active_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, animated.hide_fraction * 255 * animated.scopedalpha, "-c", hide_size + animated.hide_fraction * active_size + 1, "HIDE ", "\a" .. rgba_to_hex(155, 155, 200, 255 * animated.hide_fraction * animated.scopedalpha) .. "ACTIVE")

    local state_size = renderer.measure_text("-", '> ' .. string.upper(state) .. ' <')
    renderer.text(x/2 + ((state_size + 2)/2) * scoped_fraction, y/2 + 30 + 10 * easeInOut(animated.fraction), 255, 255, 255, 255 * animated.scopedalpha, "-c", 0, '> ' .. string.upper(state) .. ' <')
elseif ui.get(visuals_tab.center_indicators) == "modern" then
    local x, y = client.screen_size()
    local logo_w, logo_h = renderer.measure_text("b", "laconism°")
    local r,g,b,a = cvet1, cvet2, cvet3, cvet4
    state = anti_aims:get_condition_type()

    if ui.get(visuals_tab.onscope) == "right" then 
    if scpd ~= 0 then
        animated.scoped_fraction = 1
        animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
        alphaforlogo = "\affffffff"
    else
        animated.scoped_fraction = lerp(animated.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
        animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
        alphaforlogo = "\affffffff"
    end
    elseif ui.get(visuals_tab.onscope) == "left" then 
        alphaforlogo = "\affffffff"
    if scpd ~= 0 then
    animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    animated.scoped_fraction = lerp(animated.scoped_fraction, -1, globals.frametime() * 24, 0, 1)
    else
    animated.scoped_fraction = lerp(animated.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
    animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    end
    elseif ui.get(visuals_tab.onscope) == "alpha" then 
    animated.scoped_fraction = lerp(animated.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
    if scpd ~= 0 then
        alphaforlogo = "\affffff00"
    animated.scopedalpha = lerp(animated.scopedalpha, 0, globals.frametime() * 24)
    else 
        alphaforlogo = "\affffffff"
        animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
    end
    elseif ui.get(visuals_tab.onscope) == "off" then 
        alphaforlogo = "\affffffff"
        animated.scopedalpha = lerp(animated.scopedalpha, 1, globals.frametime() * 24)
        animated.scoped_fraction = lerp(animated.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
    end
    local scoped_fraction = animated.scoped_fraction 
    dangerouscolor = string.format("\a%s",rgba_to_hex(255,255,255,animated.scopedalpha))
    renderer.text(x/2 + ((logo_w + 2)/2) * scoped_fraction, y/2 + 20, 255, 255, 255, 255 * animated.scopedalpha , "cb", 0, string.format("%s°",animate_text(globals.curtime() * 2.5, "laconism", 255, 255, 255, 255 * animated.scopedalpha, cvet1, cvet2, cvet3, 255 * animated.scopedalpha)))
    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack")
    local next_primary_attack = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_flNextPrimaryAttack")

    local dt_toggled = ui.get(keysforinds.doubletap[1]) and ui.get(keysforinds.doubletap[2])
    local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime())

    if dt_toggled and dt_active then
        animated.active_fraction = ctx_clamp(animated.active_fraction + globals.frametime()/0.15, 0, 1)
    else
        animated.active_fraction = ctx_clamp(animated.active_fraction - globals.frametime()/0.15, 0, 1)
    end

    if dt_toggled and not dt_active then
        animated.inactive_fraction = ctx_clamp(animated.inactive_fraction + globals.frametime()/0.15, 0, 1)
    else
        animated.inactive_fraction = ctx_clamp(animated.inactive_fraction - globals.frametime()/0.15, 0, 1)
    end

    if ui.get(keysforinds.hideshots[1]) and ui.get(keysforinds.hideshots[2]) and not dt_toggled then
        animated.hide_fraction = ctx_clamp(animated.hide_fraction + globals.frametime()/0.15, 0, 1)
    else
        animated.hide_fraction = ctx_clamp(animated.hide_fraction - globals.frametime()/0.15, 0, 1)
    end

    if math.max(animated.hide_fraction, animated.inactive_fraction, animated.active_fraction) > 0 then
        animated.fraction = ctx_clamp(animated.fraction + globals.frametime()/0.2, 0, 1)
    else
        animated.fraction = ctx_clamp(animated.fraction - globals.frametime()/0.2, 0, 1)
    end

    local dt_size = renderer.measure_text("-", "")
    local ready_size = renderer.measure_text("-", "DT")
    renderer.text(x/2 + ((dt_size + ready_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, animated.active_fraction * 255 * animated.scopedalpha, "-c", dt_size + animated.active_fraction * ready_size + 1, animate_text(globals.curtime() * 1.5, "", 50, 50, 50, 255 * animated.scopedalpha, cvet1, cvet2, cvet3, 255 * animated.scopedalpha), "\a" .. rgba_to_hex(155, 255, 155, 255 * animated.active_fraction * animated.scopedalpha) .. animate_text(globals.curtime() * 1.5, "DT", 200, 200, 200, 255 * animated.scopedalpha, 200, 200, 200, 255 * animated.scopedalpha))

    local charging_size = renderer.measure_text("-", "DT")
    local ret = animate_text(globals.curtime() * 1.5, "DT", 100, 0, 0, 255 * animated.scopedalpha, 100, 0, 0, 255 * animated.scopedalpha) 
    renderer.text(x/2 + ((dt_size + charging_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, animated.inactive_fraction * 255 * animated.scopedalpha, "-c", dt_size + animated.inactive_fraction * charging_size + 1, "", ret)

    local hide_size = renderer.measure_text("-", "")
    local active_size = renderer.measure_text("-", "HS")
    renderer.text(x/2 + ((hide_size + active_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, animated.hide_fraction * 255 * animated.scopedalpha, "-c", hide_size + animated.hide_fraction * active_size + 1, animate_text(globals.curtime() * 1.5, "HS", 200, 200, 200, 255 * animated.scopedalpha, 200, 200, 200, 255 * animated.scopedalpha), "\a" .. rgba_to_hex(155, 155, 200, 255 * animated.hide_fraction * animated.scopedalpha) .. "")

    local state_size = renderer.measure_text("-", '> ' .. string.upper(state) .. ' <')
    renderer.text(x/2 + ((state_size + 2)/2) * scoped_fraction, y/2 + 30 + 10 * easeInOut(animated.fraction), 255, 255, 255, 255 * animated.scopedalpha, "-c", 0, animate_text(globals.curtime() * 1.5, string.format("> %s <", string.upper(state)), 200, 200, 200, 255 * animated.scopedalpha, 200, 200, 200, 255 * animated.scopedalpha))
end

ui.set_callback(visuals_tab.confil, function()
    if ui.get(visuals_tab.confil) then
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


end)