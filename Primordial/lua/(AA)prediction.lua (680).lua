local updated = "03/27/23"
local username = ""..user.name.." ["..user.uid.."]"
local welcoming = menu.add_text("Information", "Welcome to prediction.lua!")
local lastupd = menu.add_text("Information", "Updated: "..updated.."")
local nameinfo = menu.add_text("Information", "User: " ..username.. "")
local versionfree = menu.add_text("Information", "Version: Public")

if user.name == "Neymash" or user.name == "Akkov" then
 client.log_screen(color_t(255, 192, 203),"Phobia.su system")
client.log_screen(color_t(255, 192, 203),"Phobia.su user identification")
client.log_screen(color_t(255, 192, 203),"Identification completed")
client.log_screen(color_t(255, 192, 203),"Welcome back, "..user.name.."!")
                    end

menu.set_group_column("Antiaim",3)
menu.set_group_column("Fakelag Builder",3)

local keybindings = {
    ["Double tap"] = menu.find("aimbot","general","exploits","doubletap","enable"),
    ["On shot anti-aim"] = menu.find("aimbot","general","exploits","hideshots","enable"),
    ["Quick peek assist"] = menu.find("aimbot","general","misc","autopeek"),
    ["Duck peek assist"] = menu.find("antiaim","main","general","fakeduck"),
    ["Anti-Aim invert"] = menu.find("antiaim","main","manual","invert desync"),
    ["Slow motion"] = menu.find("misc","main","movement","slow walk"),
   --[[ ["Manual anti-aim left"] = antiaim.get_manual_override() == 1,
    ["Manual anti-aim back"] = antiaim.get_manual_override() == 2,
    ["Manual anti-aim right"] = antiaim.get_manual_override() == 3,]]
    ["Ping spike"] = menu.find("aimbot","general", "fake ping","enable"),
    ["Freestanding"] = menu.find("antiaim","main","auto direction","enable"),
    ["Damage override"] = menu.find("aimbot", "auto", "target overrides", "min. damage"),
}

local variables = {
    keybind = {
        x = menu.add_slider("prediction | hidden", "kb_x", 0, 3840),
        y = menu.add_slider("prediction | hidden", "kb_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        modes = {"[toggled]", "[hold]", "[on]", "[on]","[off]"},
        alpha = 0,
        size = 160,
    },
}
    --visuals
   variables.keybind.x:set_visible(false)
      variables.keybind.y:set_visible(false)
    variables.keybind.x:set(365)
    variables.keybind.y:set(367)


local function on_draw_watermark(watermark_text)
    -- watermark
    return "prediction.lua   |  " .. user.name
end
local widgets_enable = menu.add_multi_selection("Visuals", "Widgets", {"Watermark", "Keybinds" ,"Centered Indicators", "Info Box"})
local clr5 = widgets_enable:add_color_picker("Accent")
local verdana = render.create_font("Verdana", 12, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local function watermark()
    if not widgets_enable:get(1) then return end
    if user.name == "Akkov" or user.name == "Neymash" then
        cheatusername = "admin"
    else 
    	cheatusername = user.name
    end
    local screensize = render.get_screen_size()
    local h, m, s = client.get_local_time()
    local color =  clr5:get()
    local text1 = string.format("prediction.lua")
    local wtm_size1 = render.get_text_size(verdana, text1)
    local text2 = string.format(" / %s ",cheatusername)
    local wtm_size2 = render.get_text_size(verdana, text2)
    local text3 = string.format("%s ms ",  math.floor(engine.get_latency(e_latency_flows.INCOMING)))
    local wtm_size3 = render.get_text_size(verdana, text3)
    local text4 = string.format("%02d:%02d:%02d ",  h, m, s)
    local wtm_size4 = render.get_text_size(verdana, text4)
    local text5 = "time"
    local wtm_string = string.format("prediction.lua / %s %dms %02d:%02d:%02d time", cheatusername, math.floor(engine.get_latency(e_latency_flows.INCOMING)), h, m, s)
    local wtm_size = render.get_text_size(verdana, wtm_string)
    local wtm_allsize = screensize.x-wtm_size.x

    render.rect_filled(vec2_t(screensize.x-wtm_size.x-18, 8), vec2_t(wtm_size.x+14, 24), color_t(41,41,41,255), 3)
    render.rect_filled(vec2_t(screensize.x-wtm_size.x-16, 10), vec2_t(wtm_size.x+10, 20), color_t(0,0,0,255), 3)
    render.rect(vec2_t(screensize.x-wtm_size.x-19, 7), vec2_t(wtm_size.x+15, 25), color_t(0,0,0,255), 3)

    render.text(verdana, text1, vec2_t(screensize.x-wtm_size.x-12, 13), color)
    render.text(verdana, text2, vec2_t(screensize.x-wtm_size.x+wtm_size1.x-12, 13), color_t(97,97,97,255))
    render.text(verdana, text3, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x-12, 13), color)
    render.text(verdana, text4, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x-12, 13), color)
    render.text(verdana, text5, vec2_t(screensize.x-wtm_size.x+wtm_size1.x+wtm_size2.x+wtm_size3.x+wtm_size4.x-12, 13), color_t(97,97,97,255))
end


local function keybinds()
    if not widgets_enable:get(2) or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.keybind.show or menu.is_open() then
        variables.keybind.alpha = variables.keybind.alpha > 254 and 255 or variables.keybind.alpha + 15
    else
        variables.keybind.alpha = variables.keybind.alpha < 1 and 0 or variables.keybind.alpha - 15
    end
   
    render.push_alpha_modifier(variables.keybind.alpha/255)

    render.rect_filled(vec2_t(variables.keybind.x:get()- 2, variables.keybind.y:get()+8), vec2_t(variables.keybind.size+4, 24), color_t(41,41,41,255), 3)
    render.rect_filled(vec2_t(variables.keybind.x:get(), variables.keybind.y:get()+10), vec2_t(variables.keybind.size, 20), color_t(0,0,0,255), 3)
    render.rect(vec2_t(variables.keybind.x:get() - 3, variables.keybind.y:get()+7), vec2_t(variables.keybind.size+5, 25), color_t(0,0,0,255), 3)

    render.text(verdana, "keybinds", vec2_t(variables.keybind.x:get()+variables.keybind.size/2, variables.keybind.y:get()+20), clr5:get(), true)
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables.keybind.x:get()-20,variables.keybind.y:get()-20),vec2_t(variables.keybind.x:get()+160,variables.keybind.y:get()+48)) then
        if not hasoffset then
            variables.keybind.offsetx = variables.keybind.x:get()-mousepos.x
            variables.keybind.offsety = variables.keybind.y:get()-mousepos.y
            hasoffset = true
        end
        variables.keybind.x:set(mousepos.x + variables.keybind.offsetx)
        variables.keybind.y:set(mousepos.y + variables.keybind.offsety)
    else
        hasoffset = false
    end
   
    offset = 1

    for i, v in pairs(keybindings) do
        local dap = v[2]
        if dap:get() then
            render.text(verdana, i, vec2_t(variables.keybind.x:get()+2, variables.keybind.y:get()+22+(13*offset)), color_t(255,255,255,255))
            local itssize = render.get_text_size(verdana, variables.keybind.modes[dap:get_mode()+1])
            render.text(verdana, variables.keybind.modes[dap:get_mode()+1], vec2_t(variables.keybind.x:get()+variables.keybind.size-2-itssize.x, variables.keybind.y:get()+22+(13*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
    end

    variables.keybind.show = offset > 1
end

local function getweapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
    
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end

        weapon_name = active_weapon:get_name()


    else return end

    return weapon_name
end

--binds
local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") -- get hideshots
local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") -- get autopeek
local isSW = menu.find("misc","main","movement","slow walk", "enable") -- get Slow Walk
local min_damage_a = menu.find("aimbot", "auto", "target overrides", "Min. Damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "Min. Damage")
local min_damage_r = menu.find("aimbot", "revolver", "target overrides", "Min. Damage")
local min_damage_d = menu.find("aimbot", "deagle", "target overrides", "Min. Damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "Min. Damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "Min. Damage")
local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "Min. Damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "Min. Damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "Min. Damage"))
local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "Min. Damage"))
local amount_deagle = unpack(menu.find("aimbot", "deagle", "target overrides", "Min. Damage"))
local amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "Min. Damage"))
local isBA = menu.find("aimbot", "scout", "target overrides", "Hitbox", "enable")
local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint", "enable")
local isAA = menu.find("antiaim", "main", "angles", "yaw base") -- get yaw base

local pixel = render.create_font("Verdana Bold", 12, 22)
local pixel_font = render.create_font("smallest pixel-7", 11, 300, e_font_flags.OUTLINE)

local fake = antiaim.get_fake_angle()
local currentTime = global_vars.cur_time

local sv = {}

sv.fn = {
    normalize_yaw = function(yaw)
        local result = yaw

        while (result < -180) do
            result = result + 360
        end

        while (result > 180) do
            result = result - 360
        end

        return result
    end,

    angle_to_vector = function(angle)
        local p, y = math.rad(angle.x), math.rad(angle.y)
        local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y)
        return vec3_t(cp * cy, cp * sy, -sp)
    end,

    multiply_vector = function(vec, mul)
        return vec3_t(vec.x * mul, vec.y * mul, vec.z * mul)
    end,

    angle_between_vectors = function(vec1, vec2)
        local delta = vec2 - vec1

        local hyp = math.sqrt(delta.x * delta.x + delta.y * delta.y)
        local pitch = math.deg(math.atan2(-delta.z, hyp))
        local yaw = math.deg(math.atan2(delta.y, delta.x))

        return angle_t(pitch, yaw, 0)
    end,

    extrapolate_vector_by_units = function(self, target, origin, angle, units)
        local vecForward_vector = self.angle_to_vector(angle)
        local vecExtrapolated = self.multiply_vector(vecForward_vector, units)
        local fFraction = trace_line(origin, vecExtrapolated, target, 0x200400B).fraction
        return origin + self.multiply_vector(vecExtrapolated, fFraction)
    end,

    extrapolate_player_position = function(self, player, origin, ticks)
        local vel = player:get_prop('m_vecVelocity')
        if not vel then
            return nil
        end
        local pred_tick = global_vars_interval_per_tick() * ticks
        return origin + self.multiply_vector(vel, pred_tick)
    end,

    interpolate_color_tickbase = function(number, max)
        local colors = {{237, 27, 3}, {235, 63, 6}, {229, 104, 8}, {228, 126, 10}, {115, 220, 13}}

        local i = g_math(number, max, #colors)
        return colors[i <= 1 and 1 or i][1], colors[i <= 1 and 1 or i][2], colors[i <= 1 and 1 or i][3]
    end,

    interpolate_color_fakelag = function(number, max)
        local colors = {{124, 195, 13}, {176, 205, 10}, {213, 201, 19}, {220, 169, 16}, {228, 126, 10}, {229, 104, 8},
                        {235, 63, 6}, {237, 27, 3}, {255, 0, 0}}

        local i = g_math(number, max, #colors)
        return colors[i <= 1 and 1 or i][1], colors[i <= 1 and 1 or i][2], colors[i <= 1 and 1 or i][3]
    end,

    detect_defensive = function()
        --if not exploits.get_charge() then return end
        
        local lp = entity_list_get_local_player()
        if not lp then return end
        local simtime = lp:get_prop("m_flSimulationTime")
        local simtime_dif = simtime - sv.data.stored_simtime

        local latency_outgoing = engine.get_latency(e_latency_flows.OUTGOING)
        
        if simtime_dif < 0 then
            local shifted_amount = client.time_to_ticks(simtime_dif)

            sv.data.simtime_dif = simtime_dif --We only wanna update the shifted amount when defensive actually triggers
            sv.data.simtime_dif2 = shifted_amount
            sv.data.active_until = globals.tick_count() + shifted_amount
            --sv.data.defensive_active = true
        end

        sv.data.stored_simtime = simtime
        --sv.data.simtime_dif = simtime_dif
    end,
}

sv.fn.on_paint = {}
local condition_calculation = {}
condition_calculation.landtime_aa = global_vars.cur_time()
sv.fn.on_paint.condition_calc = function()
    if engine.is_connected() and entity_list.get_local_player() then

        local curtime = global_vars.cur_time()
        local player = entity_list.get_local_player()
        local velocity = player:get_prop("m_vecVelocity"):length()

        local air = not player:has_player_flag(e_player_flags.ON_GROUND)
        local air_duck = not player:has_player_flag(e_player_flags.ON_GROUND) and
                             player:has_player_flag(e_player_flags.DUCKING)
        local moving = velocity > 5
        local ducking = player:has_player_flag(e_player_flags.DUCKING)

        if not player:has_player_flag(e_player_flags.ON_GROUND) then
            condition_calculation.landtime_aa = curtime + 0.1
        end

        sv.current_condition = "STANDING"

        if condition_calculation.landtime_aa > curtime and ((air and ducking) or ducking) then
            sv.current_condition = "JUMP+DUCK"
        elseif condition_calculation.landtime_aa > curtime or air then
            sv.current_condition = "JUMPING"
        elseif isSW[2]:get() and condition_calculation.landtime_aa < curtime then
            sv.current_condition = "SLOWWALKING"
        elseif moving and not ducking and condition_calculation.landtime_aa < curtime then
            sv.current_condition = "MOVING"
        elseif ducking and condition_calculation.landtime_aa < curtime then
            sv.current_condition = "DUCKING"
        end
    end
end

callbacks.add(e_callbacks.PAINT, sv.fn.on_paint.condition_calc)

local function indicators2()
	    if not widgets_enable:get(3) then return end
    if not engine.is_connected() then
        return
    end

    if not engine.is_in_game() then
        return
    end

    local local_player = entity_list.get_local_player()

    if not local_player:get_prop("m_iHealth") then
        return
    end

    local clr1 = clr5:get()
    --screen size
    local x = render.get_screen_size().x
    local y = render.get_screen_size().y

    --invert state
    if antiaim.is_inverting_desync() == false then
        invert ="RIGHT"
    else
        invert ="LEFT"
    end

    --screen size
    local ay = 40
    local alpha = math.min(math.floor(math.sin((global_vars.real_time()%3) * 4) * 175 + 50), 255)
    if local_player:is_alive() then -- check if player is alive
    --render
    local eternal_ts = render.get_text_size(pixel, "prediction.lua° ")
    render.text(pixel, "prediction.lua° ", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
    ay = ay + 10.5
        render.text(pixel_font, sv.current_condition, vec2_t(x/2, y/2+ay+2), color_t(255, 255, 255, 255), 10, true)
    ay = ay + 10.5
        	render.text(pixel_font, "DOUBLETAP", vec2_t(x/2, y/2+ay+2), isDT[2]:get() and clr5:get() or color_t(255, 255, 255, 128), 10, true)
            ay = ay + 10.5
  

    local ax = 0
        	render.text(pixel_font, "ON-SHOT", vec2_t(x/2, y/2+ay-1), isHS[2]:get() and clr5:get() or color_t(255, 255, 255, 128), 10, true)
        ay = ay + 10.5
 if getweapon() == "ssg08" then
        if min_damage_s[2]:get() then
            render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), clr5:get(), 10, true)
            ay = ay + 10.5
        else 
        	render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), color_t(255, 255, 255, 128), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "deagle" then
        if min_damage_d[2]:get() then
          render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), clr5:get(), 10, true)
            ay = ay + 10.5
        else 
        	render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), color_t(255, 255, 255, 128), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "revolver" then
        if min_damage_r[2]:get() then
            render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), clr5:get(), 10, true)
            ay = ay + 10.5
        else 
        	render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), color_t(255, 255, 255, 128), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "awp" then
        if min_damage_awp[2]:get() then
            render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), clr5:get(), 10, true)
            ay = ay + 10.5
        else 
        	render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), color_t(255, 255, 255, 128), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
        if min_damage_a[2]:get() then
           render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), clr5:get(), 10, true)
            ay = ay + 10.5
        else 
        	render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), color_t(255, 255, 255, 128), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
        if min_damage_p[2]:get() then
           render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), clr5:get(), 10, true)
            ay = ay + 10.5
        else 
        	render.text(pixel_font, "DAMAGE", vec2_t(x/2, y/2+ay-4), color_t(255, 255, 255, 128), 10, true)
            ay = ay + 10.5
        end
    end
end
end

local Get = menu.find
local AddCheckbox = menu.add_checkbox
local AddSlider = menu.add_slider
local AddCombo = menu.add_selection

local JitterTypes = {"None", "Static", "Center", "Random", "Random v2", "Breaker"}
local DesyncSides = {"None", "Left", "Right", "Jitter", "Freestand", "Reversed freestand", "Sway", "Random", "Breaker"}
local FakelagTypes = {"Static", "Adaptive", "Random", "Break LC"}

local Lua = {
    OverrideAntiaim = AddCheckbox("Antiaim", "Enable Antiaim"),
    OverrideFakelag = AddCheckbox("Antiaim", "Enable Fakelag"),

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
            Mode = AddCombo("Builder", "Type", {"Standing", "Walking", "Running", "In-air", "Crouching", "Crouch in air", "Deffensive"}),

            Standing = {
                Yaw = AddSlider("Builder", "[S] - Yaw", -58, 58),
                DynamicYaw = AddCheckbox("Builder", "[S] - Randomize yaw"),

                OverrideJitter = AddCheckbox("Builder", "[S] - Override jitter"),
                JitterType = AddCombo("Builder", "[S] - Jitter type", JitterTypes),
                JitterAmount = AddSlider("Builder", "[S] - Amount", -58, 58),

                OverrideSpin = AddCheckbox("Builder", "[S] - Override spin"),
                SpinType = AddCombo("Builder", "[S] - Spin type", {"Static", "Ways", "Random"}),
                SpinAmount = AddSlider("Builder", "[S] - Amount", 0, 360),
                SpinSpeed = AddSlider("Builder", "[S] - Speed", 0, 100),

                DesyncType = AddCombo("Builder", "[S] - Desync side", DesyncSides),
                DesyncLeft = AddSlider("Builder", "[S] - Left amount", 0, 90),
                DesyncRight = AddSlider("Builder", "[S] - Right amount", 0, 90),
            },

            Walking = {
                Yaw = AddSlider("Builder", "[W] - Yaw", -58, 58),
                DynamicYaw = AddCheckbox("Builder", "[W] - Randomize yaw"),

                OverrideJitter = AddCheckbox("Builder", "[W] - Override jitter"),
                JitterType = AddCombo("Builder", "[W] - Jitter type", JitterTypes),
                JitterAmount = AddSlider("Builder", "[W] - Amount", -58, 58),

                OverrideSpin = AddCheckbox("Builder", "[W] - Override spin"),
                SpinType = AddCombo("Builder", "[W] - Spin type", {"Static", "Ways", "Random"}),
                SpinAmount = AddSlider("Builder", "[W] - Amount", 0, 360),
                SpinSpeed = AddSlider("Builder", "[W] - Speed", 0, 100),

                DesyncType = AddCombo("Builder", "[W] - Desync side", DesyncSides),
                DesyncLeft = AddSlider("Builder", "[W] - Left amount", 0, 90),
                DesyncRight = AddSlider("Builder", "[W] - Right amount", 0, 90),
            },

            Running = {
                Yaw = AddSlider("Builder", "[R] - Yaw", -58, 58),
                DynamicYaw = AddCheckbox("Builder", "[R] - Randomize yaw"),

                OverrideJitter = AddCheckbox("Builder", "[R] - Override jitter"),
                JitterType = AddCombo("Builder", "[R] - Jitter type", JitterTypes),
                JitterAmount = AddSlider("Builder", "[R] - Amount", -58, 58),

                OverrideSpin = AddCheckbox("Builder", "[R] - Override spin"),
                SpinType = AddCombo("Builder", "[R] - Spin type", {"Static", "Ways", "Random"}),
                SpinAmount = AddSlider("Builder", "[R] - Amount", 0, 360),
                SpinSpeed = AddSlider("Builder", "[R] - Speed", 0, 100),

                DesyncType = AddCombo("Builder", "[R] - Desync side", DesyncSides),
                DesyncLeft = AddSlider("Builder", "[R] - Left amount", 0, 90),
                DesyncRight = AddSlider("Builder", "[R] - Right amount", 0, 90),
            },

            Air = {
                Yaw = AddSlider("Builder", "[A] - Yaw", -58, 58),
                DynamicYaw = AddCheckbox("Builder", "[A] - Randomize yaw"),

                OverrideJitter = AddCheckbox("Builder", "[A] - Override jitter"),
                JitterType = AddCombo("Builder", "[A] - Jitter type", JitterTypes),
                JitterAmount = AddSlider("Builder", "[A] - Amount", -58, 58),

                OverrideSpin = AddCheckbox("Builder", "[A] - Override spin"),
                SpinType = AddCombo("Builder", "[A] - Spin type", {"Static", "Ways", "Random"}),
                SpinAmount = AddSlider("Builder", "[A] - Amount", 0, 360),
                SpinSpeed = AddSlider("Builder", "[A] - Speed", 0, 100),

                DesyncType = AddCombo("Builder", "[A] - Desync side", DesyncSides),
                DesyncLeft = AddSlider("Builder", "[A] - Left amount", 0, 90),
                DesyncRight = AddSlider("Builder", "[A] - Right amount", 0, 90),
            },

            Crouching = {
                Yaw = AddSlider("Builder", "[C] - Yaw", -58, 58),
                DynamicYaw = AddCheckbox("Builder", "[C] - Randomize yaw"),

                OverrideJitter = AddCheckbox("Builder", "[C] - Override jitter"),
                JitterType = AddCombo("Builder", "[C] - Jitter type", JitterTypes),
                JitterAmount = AddSlider("Builder", "[C] - Amount", -58, 58),

                OverrideSpin = AddCheckbox("Builder", "[C] - Override spin"),
                SpinType = AddCombo("Builder", "[C] - Spin type", {"Static", "Ways", "Random"}),
                SpinAmount = AddSlider("Builder", "[C] - Amount", 0, 360),
                SpinSpeed = AddSlider("Builder", "[C] - Speed", 0, 100),

                DesyncType = AddCombo("Builder", "[C] - Desync side", DesyncSides),
                DesyncLeft = AddSlider("Builder", "[C] - Left amount", 0, 90),
                DesyncRight = AddSlider("Builder", "[C] - Right amount", 0, 90),
            },

            CrouchingInAir = {
                Yaw = AddSlider("Builder", "[CA] - Yaw", -58, 58),
                DynamicYaw = AddCheckbox("Builder", "[CA] - Randomize yaw"),

                OverrideJitter = AddCheckbox("Builder", "[CA] - Override jitter"),
                JitterType = AddCombo("Builder", "[CA] - Jitter type", JitterTypes),
                JitterAmount = AddSlider("Builder", "[CA] - Amount", -58, 58),

                OverrideSpin = AddCheckbox("Builder", "[CA] - Override spin"),
                SpinType = AddCombo("Builder", "[CA] - Spin type", {"Static", "Ways", "Random"}),
                SpinAmount = AddSlider("Builder", "[CA] - Amount", 0, 360),
                SpinSpeed = AddSlider("Builder", "[CA] - Speed", 0, 100),

                DesyncType = AddCombo("Builder", "[CA] - Desync side", DesyncSides),
                DesyncLeft = AddSlider("Builder", "[CA] - Left amount", 0, 90),
                DesyncRight = AddSlider("Builder", "[CA] - Right amount", 0, 90),
            },

            Deffensive = {
                Sensivity = AddSlider("Builder", "[D] - Deffensive sensivity", 0, 100),

                Pitch = AddCombo("Builder", "[D] - Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
                Yaw = AddSlider("Builder", "[D] - Yaw", -58, 58),
                DynamicYaw = AddCheckbox("Builder", "[D] - Randomize yaw"),

                OverrideJitter = AddCheckbox("Builder", "[D] - Override jitter"),
                JitterType = AddCombo("Builder", "[D] - Jitter type", JitterTypes),
                JitterAmount = AddSlider("Builder", "[D] - Amount", -58, 58),

                OverrideSpin = AddCheckbox("Builder", "[D] - Override spin"),
                SpinType = AddCombo("Builder", "[D] - Spin type", {"Static", "Ways", "Random"}),
                SpinAmount = AddSlider("Builder", "[D] - Amount", 0, 360),
                SpinSpeed = AddSlider("Builder", "[D] - Speed", 0, 100),

                DesyncType = AddCombo("Builder", "[D] - Desync side", DesyncSides),
                DesyncLeft = AddSlider("Builder", "[D] - Left amount", 0, 90),
                DesyncRight = AddSlider("Builder", "[D] - Right amount", 0, 90),
            }
        }
    },

    Fakelag = {
        MoveType = AddCombo("Fakelag Builder", "Move type", {"Standing", "Walking", "Running", "Air", "Crouching", "Crouch in air"}),

        Standing = {
            Amount = AddSlider("Fakelag Builder", "[S] - Amount", 0, 15),
            Mode = AddCombo("Fakelag Builder", "[S] - Mode", FakelagTypes),
        },

        Walking = {
            Amount = AddSlider("Fakelag Builder", "[W] - Amount", 0, 15),
            Mode = AddCombo("Fakelag Builder", "[W] - Mode", FakelagTypes),
        },

        Running = {
            Amount = AddSlider("Fakelag Builder", "[R] - Amount", 0, 15),
            Mode = AddCombo("Fakelag Builder", "[R] - Mode", FakelagTypes),
        },

        Air = {
            Amount = AddSlider("Fakelag Builder", "[A] - Amount", 0, 15),
            Mode = AddCombo("Fakelag Builder", "[A] - Mode", FakelagTypes),
        },

        Crouching = {
            Amount = AddSlider("Fakelag Builder", "[C] - Amount", 0, 15),
            Mode = AddCombo("Fakelag Builder", "[C] - Mode", FakelagTypes),
        },

        CrouchingInAir = {
            Amount = AddSlider("Fakelag Builder", "[AC] - Amount", 0, 15),
            Mode = AddCombo("Fakelag Builder", "[AC] - Mode", FakelagTypes),
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



local tags5 = menu.add_checkbox("Miscellaneous", "Clantag Spammer")
local vibor = menu.add_selection("Miscellaneous", "Mode", {"prediction", "timehack", "time prediction"})
local removals5 = menu.add_multi_selection("Miscellaneous", "Additionals Removals", {"Shadows", "Sleeves"})

local function additionals_removals()
    cvars.cl_csm_shadows:set_int(removals5:get(1) and 0 or 1)
end
 callbacks.add(e_callbacks.DRAW_MODEL, additionals_removals)

function on_draw_model(ctx)
    if not removals5:get(2) then return end
    if ctx.model_name:find("v_sleeve") == nil then 
       return
    end
    ctx.override_original = true
 end
 
 callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)

 local animation_breaker = {}

animation_breaker.anim_breaker = menu.add_multi_selection("Miscellaneous", "Animation Breakers", {"Jackson", "in Air", "Zero Pitch on Land"})
local ducarimode = menu.add_checkbox("Miscellaneous", "DucaRii Mode")
local freezymode = menu.add_checkbox("Miscellaneous", "Freeze Move")
animation_breaker.ground_tick = 1
animation_breaker.end_time = 0
animation_breaker.handle = function (poseparam)
    local localPlayer = entity_list.get_local_player()
    if not localPlayer then
        return
    end

    local flags = localPlayer:get_prop("m_fFlags")
    local on_land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    local is_in_air = bit.band(flags, bit.lshift(1, 0)) == 0

    local curtime = global_vars.cur_time()

    if on_land == true then
        animation_breaker.ground_tick = animation_breaker.ground_tick + 1
    else
        animation_breaker.ground_tick = 0
        animation_breaker.end_time = curtime + 1
    end


    if animation_breaker.anim_breaker:get(1) then
menu.find("antiaim", "main", "general", "leg slide"):set(2)
            poseparam:set_render_pose(e_poses.MOVE_YAW, 0)
             poseparam:set_render_pose(e_poses.MOVE_BLEND_WALK, 0)
    end
        if ducarimode:get() then
            entity_list.get_local_player():set_prop("m_flModelScale", 0.5)
        else
                        entity_list.get_local_player():set_prop("m_flModelScale", 1)
    end
     if freezymode:get() then
    poseparam:set_render_pose(e_poses.MOVE_BLEND_RUN, 0)
    end


    if animation_breaker.anim_breaker:get(2) and is_in_air then
 poseparam:set_render_pose(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0)
    end

    if animation_breaker.anim_breaker:get(3) and animation_breaker.ground_tick > 1 and animation_breaker.end_time > curtime then
        poseparam:set_render_pose(e_poses.BODY_PITCH, 0.5)
    end

end

callbacks.add(e_callbacks.ANTIAIM, animation_breaker.handle)


-- clantag changer
local _set_clantag = ffi.cast('int(__fastcall*)(const char*, const char*)', memory.find_pattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))
local _last_clantag = nil




local set_clantag = function(v)
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end

  if v == _last_clantag then return end
  _set_clantag(v, v)
  _last_clantag = v
end

local clantags = {

    george = {
        "pr",
        "pre",
        "pred",
        "predi",
        "predic",
        "predict",
        "predicti",
        "predictio",
        "prediction",
        "prediction.",
        "prediction.l",
        "prediction.lu",
        "prediction.lua      ",
        "prediction.lua      ",
                "prediction.lua      ",
                        "prediction.lua      ",
                                "prediction.lua      ",
                                        "prediction.lua      ",
        "prediction.lu",
        "prediction.l",
        "prediction.",
        "prediction",
        "predictio",
        "predicti",
        "predict",
        "predic",
        "predi",
        "pred",
        "pre",
        "pr",
        "p",
        "",
    },

    george2 = {
        "⌛ t",
        "⌛ ti",
        "⌛ tim",
        "⌛ time",
        "⌛ timeh",
        "⌛ timeha",
        "⌛ timehac",
        "⌛ timehack ",
        "⌛ timehack ",
        "⌛ timehack ",
        "⌛ timehack ",
        "⌛ timehack ",
        "⌛ timehack ",
        "⌛ timehac",
        "⌛ timeha",
        "⌛ timeh",
        "⌛ time",
        "⌛ tim",
        "⌛ ti",
        "⌛ t",
        "⌛ ",
        "⌛ ",
        "⌛ ",
    },

    george3 = {
        "⌛ p",
        "⌛ pr",
        "⌛ pre",
        "⌛ pred",
        "⌛ predi",
        "⌛ predic",
        "⌛ predict",
        "⌛ predicti",
                "⌛ predictio",
        "⌛ prediction ",
        "⌛ prediction ",
        "⌛ prediction ",
        "⌛ prediction ",
        "⌛ prediction ",
        "⌛ prediction ",
        "⌛ predictio",
        "⌛ predicti",
        "⌛ predict",
        "⌛ predic",
        "⌛ predi",
        "⌛ pre",
        "⌛ pr",
        "⌛ p",
        "⌛ ",
        "⌛ ",
        "⌛ ",
        "⌛ ",
    },
}

local function clantag_animation()
    
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end

    local latency = engine.get_latency(0) / global_vars.interval_per_tick()
    local tickcount_pred = global_vars.tick_count() + latency
    local floyd = math.floor(math.fmod(tickcount_pred / 30, #clantags.george) + 1)
    local floyd2 = math.floor(math.fmod(tickcount_pred / 30, #clantags.george2) + 1)
    local floyd3 = math.floor(math.fmod(tickcount_pred / 30, #clantags.george3) + 1)

    if tags5:get() then
        if vibor:get() == 1 then
            set_clantag(clantags.george[floyd])
        elseif vibor:get() == 2 then
            set_clantag(clantags.george2[floyd2])
        elseif vibor:get() == 3 then
                set_clantag(clantags.george3[floyd3])
        end
    else
        set_clantag("")
    end 
end


local function are_have_weapon(ent)
    if not entity_list.get_local_player():is_alive() or not ent:get_active_weapon() then return end
    local t_cur_wep = ent:get_active_weapon():get_class_name()
    return t_cur_wep ~= "CKnife" and t_cur_wep ~= "CC4" and t_cur_wep ~= "CMolotovGrenade" and t_cur_wep ~= "CSmokeGrenade" and t_cur_wep ~= "CHEGrenade" and t_cur_wep ~= "CWeaponTaser"
end
local function are_them_visibles(ent)
    local local_p = entity_list:get_local_player()
    local generic_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    local left_arm_pos = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local right_arm_pos = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if local_p:is_point_visible(generic_pos) or local_p:is_point_visible(left_arm_pos) or local_p:is_point_visible(right_arm_pos) then return true else return false end
end
local function strangerdranger(cmd)
    if not enabled:get() then return end
    if not key:get() then return end
    if ragebot.get_autopeek_pos() then return end
    local enemies = entity_list.get_players(true)
    for i,v in ipairs(enemies) do
        if are_them_visibles(v) and are_have_weapon(v) then
            exploits.force_uncharge()
            exploits.block_recharge()
        else
            exploits.allow_recharge()
        end
    end
end
enabled = menu.add_checkbox("Ragebot", "Teleport in Air")
key     = enabled:add_keybind("Teleport keybind")


disable_int = menu.add_checkbox("Ragebot", "Disable Interpolation")
local function disableinterp()
    if disable_int:get() then
        cvars.cl_interpolate:set_int(0)
    else
        cvars.cl_interpolate:set_int(1)
    end
end

local killsays = {
   "завалился петушара ебаный",
     "))",
    "улетаешь малыха",
    "омагад ботиха",
        "охайо!",
                "парни купил гранту люкс поддержанную норм?",
    "я люблю разных сучек",
        "твои яйца откушены пузатый",
        "я был приятно удивлен при игре с этим скриптом!",
        "vot eto vantap",
            "техасхук емае",
                "примо донт нид апдеит)",
    "нл донт нид апдеит)",
    "[prediction.lua] Missed shot due to spread сука паста",
    "убил из-за fipp cfg",
    "эй малышка у тебя слишком классная стрижка",
    "prediction - better solution",
    "играю с метой и курю ашкудишку",
    "primordial dont need update",
    "чернобыль говно кстати",
    "тутутуту тутутутут изи)",
    "хуйпасоус завален)",
    "чунгук отмирает)",
    "шнюк ссаныи",
    "БАЙ МЕТАМЕТОД ЛУА СУЧКАА",
        "я твою мать доской с гвоздями ебашил жирбос",
            "neverlegend#2478 - buy prediction.lua",
                        "твоя жизнь это ирония",
                "В чёрных масках мы дырявим этот Rover",
   "shoppy.gg/@Akkov1337",
   "с позором моча бля",
      "сколько блядей я ебал в оружейной",
      "Сценарий моей жизни - получил платину",
      "+35, но все равно холод",
      "Курим со Смоки на студийной сессии",
"gamesense.pub/forums/profile.php?id=555 слыш не твой юид?",
    'за сабкой и кфг @fipp1337',
    "держи зонтик ☂, тебя обоссали",
    "𝕠𝕨𝕟𝕖𝕕 𝕓𝕪 𝕘𝕠𝕕𝕖𝕝𝕖𝕤𝕤 𝕜𝕚𝕕",
    "by rod9 хуесос)",
}

local trashtalk_enabled = menu.add_checkbox("Miscellaneous", "Trashtalk")
local start_random = 0
local function on_event(event)
    if not trashtalk_enabled:get() then return end
    local lp = entity_list.get_local_player()
    ::generate::
    local random = killsays[math.random(#killsays)]
    if (random == start_random) then
        goto generate
    end
    local kill_cmd = 'say ' .. random
    if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end --checking if the killer is us
    engine.execute_cmd(kill_cmd)
    start_random = random
end

callbacks.add(e_callbacks.EVENT, on_event, "player_death")
local antizevs = menu.add_checkbox("Ragebot", "Anti Taser")
local antizevs_dist = menu.add_slider("Ragebot", "Anti Taser Distance", 10, 30)
antizevs_dist:set(20)
local pidoras = false
local function antitaser()
    if not engine.is_connected() then return end
    if not entity_list.get_local_player():is_alive() then return end
    if not antizevs:get() then return end
    if entity_list.get_local_player():get_active_weapon() == nil then return end

    local distance = 0
    local pidoras2 = false
    local enemies_only = entity_list.get_players(true)
    for _, enemy in pairs(enemies_only) do 
        if enemy:is_alive() then
            if enemy:is_dormant() then return end
            if enemy:get_active_weapon() == nil then return end
            if enemy:get_active_weapon():get_name() == "taser" then
                distance = math.floor(enemy:get_render_origin():dist(entity_list.get_local_player():get_render_origin()) / 17)

                if distance > 0 then
                    if distance <= antizevs_dist:get() then
                        if pidoras == true then
                            engine.execute_cmd("slot3")
                        end
                        pidoras2 = true
                    end

                    if entity_list.get_local_player():get_active_weapon():get_name() < "taser" then
                        if not pidoras2 then
                            pidoras = true
                        end
                    elseif entity_list.get_local_player():get_active_weapon():get_name() == "taser" then
                        if pidoras2 then
                            pidoras = false
                        end
                    end
                end
            end
        end
    end
    if entity_list.get_local_player():get_active_weapon():get_name() == "taser" and pidoras == true then pidoras = false end
end

local shitpres = menu.add_checkbox("Ragebot", "Shit Preset on Warmup")
local function warmup_preset()
    if not engine.is_connected() then return end
    if not entity_list.get_local_player():is_alive() then return end
    if not shitpres:get() then return end

    if game_rules.get_prop("m_bWarmupPeriod") == 1 then
        refs.yawadd:set(antiaim.get_desync_side() == 2 and 11 or -8)
        refs.fakemode:set(4)
        refs.jittertype:set(2)
        refs.jitteradd:set(50)
        refs.leanmode:set(1)
        refs.fakevalright:set(0)
        refs.fakevalleft:set(0)
    end
end

local function infobox()
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end
    if not entity_list.get_local_player():is_alive() then return end

local screensize = render.get_screen_size()
        local bodyyaw = entity_list.get_local_player():get_prop("m_flPoseParameter", 11) * 120 - 60
        if bodyyaw < 0 then angle = bodyyaw*-1 else angle = bodyyaw end

            if not widgets_enable:get(4) then return end
            render.text(pixel, "prediction.lua", vec2_t(screensize.x/20 - 100 + render.get_text_size(pixel, ">>> ").x, screensize.y/2.5 + 70), clr5:get())
                        render.text(verdana, "user: "..user.name.." [beta]", vec2_t(screensize.x/20 - 100 + render.get_text_size(pixel, ">>> ").x, screensize.y/2.5 + 80), color_t(255, 255, 255, 255))
            render.text(verdana, "fake:", vec2_t(screensize.x/20 - 100 + render.get_text_size(pixel, ">>> ").x, screensize.y/2.5 + 90), color_t(255,255,255, 255))
            render.text(verdana, ""..math.floor(angle), vec2_t(screensize.x/20 - 100 + render.get_text_size(pixel, ">>> fake: ").x, screensize.y/2.5 + 90), color_t(255,255,255,255))
            render.text(verdana, "°", vec2_t(screensize.x/20 - 100 + render.get_text_size(pixel, ".>>> fake: " ..math.floor(angle)).x, screensize.y/2.5 + 90), color_t(255,255,255, 255))
       
            render.text(verdana, "fps:", vec2_t(screensize.x/20 - 100 + render.get_text_size(pixel, ">>> ").x, screensize.y/2.5 + 100), color_t(255,255,255, 255))
            render.text(verdana, ""..client.get_fps(), vec2_t(screensize.x/20 - 100 + render.get_text_size(pixel, ">>> fps: ").x, screensize.y/2.5 + 100), color_t(255,255,255,255))
            render.text(verdana, "tickrate:", vec2_t(screensize.x/20 - 100 + render.get_text_size(pixel, ">>> ").x, screensize.y/2.5 + 110), color_t(255,255,255, 255))
            render.text(verdana, ""..client.get_tickrate(), vec2_t(screensize.x/20 - 100 + render.get_text_size(pixel, ">>> tickrate: ").x, screensize.y/2.5 + 110), color_t(255,255,255,255))
    end

callbacks.add(e_callbacks.PAINT, infobox)
callbacks.add(e_callbacks.PAINT, indicators2)

local dispis = menu.add_checkbox("Ragebot", "Disable Autobuy on Pistol Round")

local refs = {
    buybot                  = menu.find("misc", "utility", "buybot", "enable"),
}

local function nigger123()
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() then return end
    local money = entity_list.get_local_player():get_prop("m_iAccount")

    if dispis:get() then
        if money <= 1000 then
            refs.buybot:set(false)
        else
            refs.buybot:set(true)
        end
    end
end

local function clantag_destroy()
    if not engine.is_connected() then return end
    if not engine.is_in_game() then return end
    set_clantag("")
end

callbacks.add(e_callbacks.PAINT, function()
watermark()
keybinds()
clantag_animation()
  HookRender()
end)

callbacks.add(e_callbacks.SETUP_COMMAND, function()
strangerdranger()
antitaser()
end)