ui.sidebar("\a8500FFFFYODIE.YAW [DEV]", "heart")
local visual = ui.create('Visual',ui.get_icon('palette').."  \a85AFFFC8Visual Options")
local switch = visual:switch(ui.get_icon('eye').." \a9fca2bffOn Screen Indicators", false)

local font = render.load_font("Smallest Pixel-7", 10, "o")

local isMD = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage")
local isBA = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim")
local isSP = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points")
local isDT = ui.find("Aimbot", "Ragebot", "Main", "Double Tap")
local isAP = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist")
local isSW = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
local isHS = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
local isFS = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
local isFD = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")

--On screen indicators
function desync_delta()
    local desync_rotation = rage.antiaim:get_rotation(true)
    local real_rotation = rage.antiaim:get_rotation()
    local delta_to_draw = math.min(math.abs(real_rotation - desync_rotation) / 2, 60)
    return string.format("%.1f", delta_to_draw)
end
local fake = desync_delta()
local currentTime = globals.curtime

local acatel_indicators = function()

    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    if not switch:get() then return end

    if switch:get() then
        local x = render.screen_size().x
        local y = render.screen_size().y

        

        if globals.is_connected then
            aa_inv_state = lp.m_flPoseParameter[11] * 120 - 60 <= 0 and true or false
        else
            return
        end

        if aa_inv_state == false then
            invert ="R"
        else
            invert ="L"
        end

        local minDmg = false
        local binds = ui.get_binds()
        for i, v in pairs(binds) do
            local bind = binds[i]
            if v.name == 'Minimum Damage' then
                minDmg = true
            end
        end

        if currentTime + 0.38 < globals.curtime then
            currentTime = globals.curtime
            fake = desync_delta()
        end

        local ay = 10
        local alpha = math.min(math.floor(math.sin((globals.curtime%3) * 4) * 175 + 50), 255)

        local eternal_ts = render.measure_text(font, nil, "BROKE ")
        render.text(font, vector(x/2, y/2+ay), color(255,255,255,255), nil, "#YODIE")
        render.text(font, vector(x/2+eternal_ts.x-2, y/2+ay), color(255, 130, 130, alpha), nil, ".YAW")
        ay = ay + 9

        local text_ =""
        local clr0 = color(0, 0, 0, 0)
        if isSW:get() then
            text_ ="DANGEROUS+ "
            clr0 = color(255, 50, 50, 255)
        else
            text_ ="DYNAMIC- "
            clr0 = color(255, 117, 107, 255)
        end

        local d_ts = render.measure_text(font, nil, text_)
        render.text(font, vector(x/2, y/2+ay), clr0, nil, text_)
        render.text(font, vector(x/2+d_ts.x, y/2+ay), color(255,255,255,255), nil, math.floor(fake).."°")
        ay = ay + 9

        local fake_ts = render.measure_text(font, nil, "FAKE YAW: ")
        render.text(font, vector(x/2, y/2+ay), color(130, 130, 255, 255), nil, "FAKE YAW:")
        render.text(font, vector(x/2+fake_ts.x, y/2+ay), color(255, 255, 255, 255), nil, invert)
        ay = ay + 9

        local asadsa = math.min(math.floor(math.sin((rage.exploit:get()%2) *1) * 122), 100)
        
        if isAP:get() and isDT:get() then
            local ts_tick = render.measure_text(2, nil, "IDEALTICK")
            render.text(font, vector(x/2, y/2+ay), color(255, 255, 255, 255), nil, "IDEALTICK")
            render.text(font, vector(x/2+ts_tick.x, y/2+ay), rage.exploit:get() and color(0, 255, 0, 255) or color(255, 0, 0, 255), nil, "x"..asadsa)
            ay = ay + 9
        else
            if isAP:get() then
                render.text(font, vector(x/2, y/2+ay), color(255, 255, 255, 255), nil, "PEEK")
                ay = ay + 9
            end
            if isDT:get() then
                render.text(font, vector(x/2, y/2+ay), rage.exploit:get() == 1 and color(0, 255, 0, 255) or color(255, 0, 0, 255), nil, "DT")
                ay = ay + 9
            end
        end

        local ax = 0
        if isHS:get() then
            render.text(font, vector(x/2, y/2+ay), color(250, 173, 181, 255), nil, "OS-AA")
            ay = ay + 9
        end

        render.text(font, vector(x/2, y/2+ay), isBA:get() == "Force" and color(255, 255, 255, 255) or color(255, 255, 255, 128), nil, "BAIM")
        ax = ax + render.measure_text(font, nil, "BAIM ").x

        render.text(font, vector(x/2+ax, y/2+ay), isSP:get() == "Force" and color(255, 255, 255, 255) or color(255, 255, 255, 128), nil, "SP")
        ax = ax + render.measure_text(font, nil, "SP ").x

        render.text(font, vector(x/2+ax, y/2+ay), isFS:get() and color(255, 255, 255, 255) or color(255, 255, 255, 128), nil, "FS")
        ax = ax + render.measure_text(font, nil, "FS ").x
    end
end

events.render:set(acatel_indicators)

--start of velocity indicators
--ffi
local ffi = require('ffi')
local ffi_handler = {}
local renders = {}
local main = {}
ffi.cdef[[
    bool URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
    bool CreateDirectoryA(
        const char*                lpPathName,
        void*                      lpSecurityAttributes
    );
]]
local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet'
ffi_handler.download_file = function(url, path)
    wininet.DeleteUrlCacheEntryA(url)
    urlmon.URLDownloadToFileA(nil, url, path, 0,0)
end    

-- ui
velocity_indicator_tab = ui.create("Velocity Indicator")
velocity_indicator_enable = visual:switch(ui.get_icon('shoe-prints').." \a9fca2bffVelocity Indicator")
velocity_indicator_gear = velocity_indicator_enable:create("Velocity Indicator")
velocity_indicator_color_1 = velocity_indicator_gear:color_picker("Color First", color(255, 255, 255, 255))
velocity_indicator_color_2 = velocity_indicator_gear:color_picker("Color Second", color(120, 120, 255, 255))
velocity_text_color = velocity_indicator_gear:color_picker("Velocity Text Color", color(255, 255, 255, 255))
velocity_color = velocity_indicator_gear:color_picker("Velocity Color", color(255, 255, 255, 255))
velocity_image_color = velocity_indicator_gear:color_picker("Image Color", color(255, 255, 255, 255))

-- files
ffi.C.CreateDirectoryA("nl\\Velocity_Indicator", nil)
ffi_handler.download_file("https://cdn.discordapp.com/attachments/993248204839735326/999688207560093738/running-shoe.png", "nl\\Velocity_Indicator\\Shoe.png")




-- main funcs
function renders.shadowtext(font, position, colorr, text)
    render.text(font, position + 1, color(0, 0, 0, colorr.a), nil, text)
    render.text(font, position, colorr, nil, text)
end

function math.lerp(from, to, time)
    return from + (to - from) * time
end

function main.is_menu_opened()
    if ui.get_alpha() > 0 then
        return true
    else
        return false
    end
end
    


-- drag system
function class()
local class = {}
local mClass = {__index = class}
function class.instance() return setmetatable({}, mClass) end
    return class
end

local velocity_indicator_t = class()

function velocity_indicator_t:new(x, y, w)
    local self = velocity_indicator_t.instance()
    self.x, self.y, self.w, self.h = x or 200, y or 400, w or 160, 20
    self.drag_x, self.drag_y = 0, 0
    self.is_dragging = false
    return self
end

function velocity_indicator_t:drag()
local m = ui.get_mouse_position()
local is_hovered = (m.x > (self.x) and m.x < (self.x + self.w) and m.y > (self.y) and m.y < (self.y + self.h))

if is_hovered then
    if common.is_button_down(1) and not self.is_dragging then
        self.is_dragging = true
   
        self.drag_x = self.x - m.x
        self.drag_y = self.y - m.y
    end
end
if not common.is_button_down(1) then
    self.is_dragging = false
end
if self.is_dragging and main.is_menu_opened() then
    self.x = (self.drag_x + m.x)
    self.y = (self.drag_y + m.y)
end
end

function velocity_indicator_t:paint() end
function velocity_indicator_t:draw()self:paint()self:drag()end

local velocity_indicator_pos = {}

velocity_indicator_pos.x = velocity_indicator_tab:slider("vel_pos_x", 0, render.screen_size().x, 120)
velocity_indicator_pos.y = velocity_indicator_tab:slider("vel_pos_y", 0, render.screen_size().y, 130)
local velocity_indicator_p = velocity_indicator_t:new(
velocity_indicator_pos.x:get(),
velocity_indicator_pos.y:get(),
160

)

velocity_indicator_pos.x:visibility(false)
velocity_indicator_pos.y:visibility(false)

--  main vars
main.font = render.load_font("arial", 12)
main.gamedir = string.sub(common.get_game_directory() , 0 , -5)
main.img = render.load_image_from_file(main.gamedir.."nl\\Velocity_Indicator\\Shoe.png", vector(60, 60))
main.size = 0
main.vel_alpha = 0
main.position_image = 0
main.vector = 0
-- render
function velocity_indicator_p:paint()
    if velocity_indicator_enable:get() and entity.get_local_player() then
        
        local vel_mod = entity.get_local_player().m_flVelocityModifier
        
        if main.is_menu_opened() or vel_mod < 1 then
            main.vel_alpha = math.lerp(main.vel_alpha, 1, globals.frametime * 12)
        else
            main.vel_alpha = math.lerp(main.vel_alpha, 0, globals.frametime * 12)
        end

        main.size = vel_mod * 160 == 160 and math.lerp(vel_mod * 160, main.size, globals.frametime * 4) or math.lerp(main.size, vel_mod * 160, globals.frametime * 4)
        local x,y,w = self.x, self.y, self.w
        -- gradient
        local gc1, gc2 = velocity_indicator_color_1:get(), velocity_indicator_color_2:get()
        local gradient1, gradient2 = color(gc1.r, gc1.g, gc1.b, math.floor(main.vel_alpha * 255)), color(gc2.r, gc2.g, gc2.b, math.floor(main.vel_alpha * 255))
        -- text color
        local vt = velocity_text_color:get()
        local vtc = color(vt.r, vt.g, vt.b, math.floor(main.vel_alpha * 255))
        -- velocity color
        local vc = velocity_color:get()
        local vcc = color(vc.r, vc.g, vc.b, math.floor(main.vel_alpha * 255))
        -- image color
        local vic = velocity_image_color:get()
        local vicc = color(vic.r, vic.g, vic.b, math.floor(main.vel_alpha * 255))

        renders.shadowtext(main.font, vector(x + w / 2 - 20, y - 15), vtc, "Velocity")
        render.texture(main.img, vector(x - 25 - 17 + 15, y - 25 + 15), vector(25, 25), vicc)
        render.rect(vector(x, y), vector(x + w, y + 15), color(0, 0, 0, math.floor(main.vel_alpha * 100)), 13)
        render.gradient(vector(x, y), vector(x + main.size, y + 15), gradient1, gradient2, gradient1, gradient2, 13)
        renders.shadowtext(main.font, vector(x + w / 2  - 10, y + 1), vcc, "" ..math.floor(vel_mod * 100))


    end

    velocity_indicator_pos.x:set(self.x)
    velocity_indicator_pos.y:set(self.y)

end

events.render:set(function(ctx)
    velocity_indicator_p:paint(); velocity_indicator_p:drag()
end)
-- Hit logs
			
local screen = render.screen_size()
local group_ref   = ui.create('Misc',ui.get_icon('screwdriver').."  \a85AFFFC8Miscellaneous Options")
local enebler     = group_ref:switch(ui.get_icon('comment-dots').."  \a9fca2bffHit logs", false)
local enebler_ref = enebler:create()
local hitlog_pos  = enebler_ref:selectable("Logs position", {"Left upper side", "Screen middle"})
local anim_type   = enebler_ref:combo("Anmation type", {"None", "X +", "X -", "Y +", "Y -"});
local m_color     = enebler_ref:color_picker("Accent color", color(125, 125, 225, 255))

local hitgroup_str = {[0] = 'generic','head', 'chest', 'stomach','left arm', 'right arm','left leg', 'right leg','neck', 'generic', 'gear'}

function menu_elem()
	hitlog_pos:visibility(enebler:get())
	anim_type:visibility(enebler:get() and hitlog_pos:get("Screen middle"))
	m_color:visibility(enebler:get() and hitlog_pos:get() ~= 0)
end

local hitlog = {}
local id = 1
events.aim_ack:set(function(event)
	local me = entity.get_local_player()
	local result = event.state
	local target = entity.get(event.target)
	local text = "%"
	if target == nil then return end
    local health = target["m_iHealth"]
    local state_1 = ""
	if enebler:get() then
		if event.state == "spread" then state_1 = "spread" end
	    if event.state == "prediction error" then state_1 = "prediction error" end
	    if event.state == "jitter correction" then state_1 = "jitter correction" end
	    if event.state == "correction" then state_1 = "resolver" end
	    if event.state == "lagcomp failure" then state_1 = "fake lag correction" end
		if result == nil then
			hitlog[#hitlog+1] = {("Registered shot at %s's %s(%s%s) for %s (aimed: %s for %s, health remain: %s) backtrack: %s"):format(event.target:get_name(), hitgroup_str[event.hitgroup], event.hitchance, text, event.damage, hitgroup_str[event.wanted_hitgroup], event.wanted_damage, health, event.backtrack), globals.tickcount + 250, 0}
			print_raw(("\a4562FF[yodie.yaw] \aD5D5D5[%s] Registered shot at %s's %s(%s%s) for %s (aimed: %s for %s, health remain: %s) backtrack: %s"):format(id, event.target:get_name(), hitgroup_str[event.hitgroup], event.hitchance, text, event.damage, hitgroup_str[event.wanted_hitgroup], event.wanted_damage, health, event.backtrack))
			if hitlog_pos:get('Left upper side') then
            	print_dev(("[%s] Registered shot at %s's %s(%s%s) for %s (aimed: %s for %s, health remain: %s) backtrack: %s"):format(id, event.target:get_name(), hitgroup_str[event.hitgroup], event.hitchance, text, event.damage, hitgroup_str[event.wanted_hitgroup], event.wanted_damage, health, event.backtrack))           
        	end
		else
			hitlog[#hitlog+1] = {("Missed %s`s %s (dmg:%s, %s%s) due to %s | backtrack: %s"):format(event.target:get_name(), hitgroup_str[event.wanted_hitgroup], event.wanted_damage, event.hitchance, text, state_1, event.backtrack), globals.tickcount + 250, 0}
			print_raw(("\a4562FF[yodie.yaw] \aD5D5D5[%s] Missed %s`s %s (dmg:%s, %s%s) due to %s\aD5D5D5 | backtrack: %s"):format(id, event.target:get_name(), hitgroup_str[event.wanted_hitgroup], event.wanted_damage, event.hitchance, text, state_1, event.backtrack))
			if hitlog_pos:get('Left upper side') then
            	print_dev(("[%s] Missed %s`s %s (dmg:%s, %s%s) due to %s | backtrack: %s"):format(id, event.target:get_name(), hitgroup_str[event.wanted_hitgroup], event.wanted_damage, event.hitchance, text, state_1, event.backtrack))           
        	end
		end
		id = id == 999 and 1 or id + 1 
	end
end)

function hit_event(event)
	local me = entity.get_local_player()
    local attacker = entity.get(event.attacker, true)
    local weapon = event.weapon
    local hit_type = ""
    if enebler:get() then
    	if weapon == 'hegrenade' then 
	        hit_type = 'Exploded'
	    end

	    if weapon == 'inferno' then
	        hit_type = 'Burned'
	    end

	    if weapon == 'knife' then 
	        hit_type = 'Hit from Knife'
	    end

	    if weapon == 'hegrenade' or weapon == 'inferno' or weapon == 'knife' then
		    if me == attacker then
		        local user = entity.get(event.userid, true)
		        hitlog[#hitlog+1] = {(hit_type..' %s for %d damage (%d health remaining)'):format(user:get_name(), event.dmg_health, event.health), globals.tickcount + 250, 0}
		        print_raw(('\a4562FF[yodie.yaw] \aD5D5D5[%s] '..hit_type..' %s for %d damage (%d health remaining)'):format(id, user:get_name(), event.dmg_health, event.health))
		        print_dev(("[%s] " .. hit_type..' %s for %d damage (%d health remaining)'):format(id, user:get_name(), event.dmg_health, event.health))
		    end
		    id = id == 999 and 1 or id + 1 
	    end
	end
end

events.render:set(function()
    if #hitlog > 0 then
        if globals.tickcount >= hitlog[1][2] then
            if hitlog[1][3] > 0 then
                hitlog[1][3] = hitlog[1][3] - 20
            elseif hitlog[1][3] <= 0 then
                table.remove(hitlog, 1)
            end
        end
        if #hitlog > 6 then
            table.remove(hitlog, 1)
        end
        if globals.is_connected == false then
            table.remove(hitlog, #hitlog)
        end
        for i = 1, #hitlog do
            text_size = render.measure_text(1, nil, hitlog[i][1]).x
            text_size_2 = render.measure_text(1, nil, "[#YODIE.YAW] ").x
            if hitlog[i][3] < 255 then 
                hitlog[i][3] = hitlog[i][3] + 10 
            end
            if hitlog_pos:get('Screen middle') then
            	if anim_type:get() == 'None' then
                	render.text(1, vector(screen.x/2 - text_size/2 + text_size_2, screen.y/1.5 + 15 * i), color(255, 255, 255, hitlog[i][3]), nil, hitlog[i][1])
                	render.text(1, vector(screen.x/2 - text_size/2, screen.y/1.5 + 15 * i), color(m_color:get().r, m_color:get().g, m_color:get().b, hitlog[i][3]), nil, "[yodie.yaw]")
                end
            	if anim_type:get() == 'X +' then
                	render.text(1, vector(screen.x/2 - text_size/2 + (hitlog[i][3]/35) + text_size_2, screen.y/1.5 + 15 * i), color(255, 255, 255, hitlog[i][3]), nil, hitlog[i][1])
                	render.text(1, vector(screen.x/2 - text_size/2 + (hitlog[i][3]/35), screen.y/1.5 + 15 * i), color(m_color:get().r, m_color:get().g, m_color:get().b, hitlog[i][3]), nil, "[yodie.yaw]")
                end
                if anim_type:get() == 'X -' then
                	render.text(1, vector(screen.x/2 - text_size/2 - (hitlog[i][3]/35) + text_size_2, screen.y/1.5 + 15 * i), color(255, 255, 255, hitlog[i][3]), nil, hitlog[i][1])
                	render.text(1, vector(screen.x/2 - text_size/2 - (hitlog[i][3]/35), screen.y/1.5 + 15 * i), color(m_color:get().r, m_color:get().g, m_color:get().b, hitlog[i][3]), nil, "[yodie.yaw]")
                end
                if anim_type:get() == 'Y +' then
                	render.text(1, vector(screen.x/2 - text_size/2 + text_size_2, screen.y/1.5 + (hitlog[i][3]/45) + 15 * i), color(255, 255, 255, hitlog[i][3]), nil, hitlog[i][1])
                	render.text(1, vector(screen.x/2 - text_size/2, screen.y/1.5 + (hitlog[i][3]/45) + 15 * i), color(m_color:get().r, m_color:get().g, m_color:get().b, hitlog[i][3]), nil, "[yodie.yaw]")
                end
                if anim_type:get() == 'Y -' then
                	render.text(1, vector(screen.x/2 - text_size/2 + text_size_2, screen.y/1.5 - (hitlog[i][3]/45) + 15 * i), color(255, 255, 255, hitlog[i][3]), nil, hitlog[i][1])
                	render.text(1, vector(screen.x/2 - text_size/2, screen.y/1.5 - (hitlog[i][3]/45) + 15 * i), color(m_color:get().r, m_color:get().g, m_color:get().b, hitlog[i][3]), nil, "[yodie.yaw]")
                end
            end
        end
    end
    menu_elem()
end)

events.player_hurt:set(function(event)
    hit_event(event)
end)

			--custom scopes
			local ScopeCustom = visual:switch(ui.get_icon('crosshairs').."  \a9fca2bffCustom Scope Lines", false)
local scopegroup = ScopeCustom:create()
local scopecol = scopegroup:color_picker("Scope Сolor",color(255,255))
local Scopeinverted = scopegroup:switch("Invert scope lines", false)
local Scopelength = scopegroup:slider("Scope length", 5, 200, 55)
local Scopeoffset = scopegroup:slider("Scope offset", 1, 50, 1)
local RemoveSc = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
events.render:set(function()
    if (globals.is_connected) then
        if not ScopeCustom:get() then
            return
        end
        local me = entity.get_local_player()
        if not me then
            return
        end
        RemoveSc:set("Remove all")
        local x = render.screen_size().x/2
        local y = render.screen_size().y/2
        local Player = entity.get_local_player()
        local Scope = Player.m_bIsScoped
        local r = math.floor(scopecol:get().r*120)
        local g = math.floor(scopecol:get().g*120)
        local b = math.floor(scopecol:get().b*120)
        local col = scopecol:get()
        local color = color(col.r, col.g, col.b, 1)
        local FirstCol = (function(a,s) if not Scopeinverted:get() then return s else return a end end)(col, color)
        local SecondCol = (function(a,s) if not Scopeinverted:get() then return a else return s end end)(col, color)
        if Scope then 
            render.gradient(vector(x, y + Scopeoffset:get()), vector(x + 1, y + Scopelength:get() + Scopeoffset:get()), SecondCol, SecondCol, FirstCol, FirstCol)
            render.gradient(vector((x + Scopelength:get()) + Scopeoffset:get(), y), vector(x + Scopeoffset:get(), y + 1), FirstCol, SecondCol, FirstCol, SecondCol)
            render.gradient(vector(x, y - Scopeoffset:get() - Scopelength:get()), vector(x + 1, y - Scopeoffset:get()), FirstCol, FirstCol, SecondCol, SecondCol)
            render.gradient(vector((x - Scopelength:get()) - Scopeoffset:get(), y), vector(x - Scopeoffset:get(), y + 1), FirstCol, SecondCol, FirstCol, SecondCol)
        end
        end
end)
	--view model and aspect ratio sliders
aspect_ratio_switch = visual:switch(ui.get_icon('desktop').."  \a9fca2bffAspect Ratio Changer", false)
viewmodel_switch = visual:switch(ui.get_icon('hands').."  \a9fca2bffViewmodel Changer", false)

viewmodel_ref = viewmodel_switch:create()
viewmodel_fov = viewmodel_ref:slider("FOV", -100, 100, 68)
viewmodel_x = viewmodel_ref:slider("X", -10, 10, 2.5)
viewmodel_y = viewmodel_ref:slider("Y", -10, 10, 0)
viewmodel_z = viewmodel_ref:slider("Z", -10, 10, -1.5)

aspectratio_ref = aspect_ratio_switch:create()
aspect_ratio_slider = aspectratio_ref:slider("Value", 0, 20, 0, 0.1)

events.createmove:set(function()
    if aspect_ratio_switch:get() then
        cvar.r_aspectratio:float(aspect_ratio_slider:get()/10)
    else
        cvar.r_aspectratio:float(0)
    end
end)

events.createmove:set(function()
    if viewmodel_switch:get() then
        cvar.viewmodel_fov:int(viewmodel_fov:get(), true)
		cvar.viewmodel_offset_x:float(viewmodel_x:get(), true)
		cvar.viewmodel_offset_y:float(viewmodel_y:get(), true)
		cvar.viewmodel_offset_z:float(viewmodel_z:get(), true)
    else
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
    end
end)

events.shutdown:set(function()
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
end)
					--clantag changer
					local clantag_switch = group_ref:switch(ui.get_icon('user-tag').." \a9fca2bffClantag Changer")

local tag = {
    "#",
"# Y",
"# YO",
"# YOD",
"# YODI",
"# YODIE",
"# YODIE.",
"# YODIE.Y",
"# YODIE.YA",
"# YODIE.YAW",
"# YODIE.YAW",
"# YODIE.YAW",
"#YODIE.YAW",
        "YODIE.YAW",
        "YODIE.YAW",
        "YODIE.YAW #",
"YODIE.YAW #",
"YODIE.YA #",
"YODIE.Y #",
"YODIE. #",
"YODIE #",
"YODI #",
"YOD #",
"YO #",
"Y #",
" #",
" "
}
local function getClantag()
local net = utils.net_channel()
if net == nil then return end
local latency = net.latency[0] / globals.tickinterval
local tickcount_pred = globals.tickcount + latency
local iter = math.floor(math.fmod(tickcount_pred / 16, #tag + 1) + 1)
return tag[iter]
end

local _last_clantag = nil
local function set_tag(tag)
if tag == _last_clantag then return end
if tag == nil then return end
common.set_clan_tag(tag)
_last_clantag = tag
end

events.render:set(function()
if clantag_switch:get() then
set_tag(getClantag())
else
set_tag(" ")
end
end)
					
				-- Info panel 
					local ref = ui.create("Main", "Info Panel")
	local switch1 = visual:switch(ui.get_icon('bars').."   \a9fca2bffPlayer Debug Panel", false)
    local theme_sel = visual:combo("Theme", {"Default","Modern","StayMelon"})
    local vers_sel = visual:combo("Build Name", {"Beta","Stable"})
    local name_sel = visual:combo("Name", {"Steam Nick","Cheat Nick","Custom"})
    local script_sel = visual:combo("Script Name", {"Exscord","Custom","StayMelon"})
    local avatr_sel = visual:combo("Avatar", {"Steam","Scooby Doo","Spin","Ears"})
    local cstm_nm = visual:input("Custom Name")
    local cht_nm = visual:input("Custom Script Name")
    local clr2 = visual:color_picker("Color")
    local is_avatar = visual:switch("Picture", false)
      cstm_nm:visibility(false)
    local vec = vector(1, 2, 3)

-- There are 3 fields you can access: "x", "y", and "z"
print(string.format("x: %.2f, y: %.2f, z: %.2f", vec.x, vec.y, vec.z))
local closest_distance
local closest_enemy
-- You can also set them
vec.x, vec.y, vec.z = 0, 0, 0

events.render:set(function()
	-- All vectors are 3D, even the ones you'd expect to be 2D
	local screen_center = render.screen_size() * 0.5

	local local_player = entity.get_local_player()
	if not local_player or not local_player:is_alive() then
		return
	end

	local camera_position = render.camera_position()

	-- Even angles are 3D vectors
	-- x is pitch, y is yaw, z is roll
	local camera_angles = render.camera_angles()

	-- Let's convert it to a forward vector though
	local direction = vector():angles(camera_angles)

    closest_distance, closest_enemy = math.huge
	for _, enemy in ipairs(entity.get_players(true)) do
		local head_position = enemy:get_hitbox_position(1)

		local ray_distance = head_position:dist_to_ray(
			camera_position, direction
		)
		
		if ray_distance < closest_distance then
			closest_distance = ray_distance
			closest_enemy = enemy
		end
	end

	if not closest_enemy then
		return
	end
end)
    cht_nm:visibility(false)
    local offst_sld = ref:slider("Offset panel", 0, 20)
    local function vsbl()
        if switch1:get() then
            avatr_sel:visibility(true)
            is_avatar:visibility(true)
            clr2:visibility(false)
            theme_sel:visibility(true)
            vers_sel:visibility(true)
            name_sel:visibility(true)
            script_sel:visibility(true)
            avatr_sel:visibility(true)
            cstm_nm:visibility(true)
            cht_nm:visibility(true)
            clr2:visibility(true)
            is_avatar:visibility(true)
            offst_sld:visibility(true)
            if theme_sel:get() == "Default" then
                offst_sld:visibility(false)
            elseif theme_sel:get() == "Modern" then
                is_avatar:visibility(true)
                offst_sld:visibility(true)
            end
            if script_sel:get() == "Custom" then
                cht_nm:visibility(true)
            else
                cht_nm:visibility(false)
            end
            if name_sel:get() == "Custom" then
                cstm_nm:visibility(true)
            else
                cstm_nm:visibility(false)
            end
            if theme_sel:get() == "StayMelon" then
                avatr_sel:visibility(false)
                is_avatar:visibility(false)
                offst_sld:visibility(true)
                clr2:visibility(true)
            end
        else
            theme_sel:visibility(false)
            vers_sel:visibility(false)
            name_sel:visibility(false)
            script_sel:visibility(false)
            avatr_sel:visibility(false)
            cstm_nm:visibility(false)
            cht_nm:visibility(false)
            clr2:visibility(false)
            is_avatar:visibility(false)
            offst_sld:visibility(false)
        end
        
    end
    events.render:set(vsbl)
    local clrvrs = {    
        ["Alpha"] = color(154,163,190),
        ["Beta"] = color(120,127,144),
        ["Stable"] = color(120,127,144),
    }
    local vers = {
        ["Beta"] = "[Pro]",
        ["Stable"] = "[Alpha]",
    }
    local vers2 = {
        ["Beta"] = "debug",
        ["Stable"] = "stable",
    }
    local clrs = {
        ["Beta"] = color(145,174,226),
        ["Stable"] = color(164,240,126),
    }
    local url = network.get("https://media.discordapp.net/attachments/249976167426162688/899287335303282718/The_sons_of_god_do_a_ritual_of_cleansing.gif")
    local url2 = network.get("https://cdn.discordapp.com/attachments/891635052918767647/1013797223152230460/spin.gif")
    local url3 = network.get("https://media.discordapp.net/attachments/976053489157439499/976054819750043688/b530c4381c276918.gif")
    local prm = render.load_image(url)
    local ukr = render.load_image(url2)
    local br = render.load_image(url3)
    local function bebra()
        local lp = entity.get_local_player()
        if lp == nil then return end
        local angles = lp:get_anim_state()
        local avatar = lp:get_steam_avatar()
        local lplayer_name = entity.get_local_player():get_name()
        local avtr = {
            ["Scooby Doo"] = prm,
            ["Steam"] = lp:get_steam_avatar(),
            ["Spin"] = ukr,
            ["Ears"] = br,
        }
        if lplayer_name == nil then return end
        local namevar = {
            ["Cheat Nick"] = common.get_username(),   
            ["Custom"] = cstm_nm:get(),
            ["Steam Nick"] = lplayer_name
        }
        local scriptname = {
            ["Exscord"] = "#YODIE.YAW ",
            ["Custom"] = cht_nm:get(),
            ["StayMelon"] = "#YODIE.YAW "
        }
        if not switch1:get() then return end
        local scrsize = render.screen_size()
        local systime = common.get_system_time()
        local textwtr = ("> "..scriptname[script_sel:get()])
        local textwtr2 = ("> user: "..namevar[name_sel:get()])
        local txtsize = render.measure_text(1,"с", textwtr2).x
    if theme_sel:get() == "Default" then
        render.texture(avtr[avatr_sel:get()],vector(1,scrsize.y/2-10), vector(25,25))
        render.text(1, vector(1+27,scrsize.y/2-10+10), color(255,255,255), "с", textwtr2)
        render.text(1, vector(1+27,scrsize.y/2-10), color(255,255,255), "с", textwtr)
        render.text(1, vector(1+txtsize+28,scrsize.y/2-10+10), clrs[vers_sel:get()], "с", vers[vers_sel:get()])
    elseif theme_sel:get() == "Modern" then
        if is_avatar:get() then
            local txtsize33 = render.measure_text(1,"с", "> "..scriptname[script_sel:get()].."version: ")
            local txtsize44 = render.measure_text(1,"с", "> user: ")
            local txtsize55 = render.measure_text(1,"с", "> desync angle: ")
            local txtsize66 = render.measure_text(1,"с", "> anti-aim state: ")
            if lp.m_fFlags == 263 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "crouching")
            elseif lp.m_vecVelocity:length2d() < 5 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "standing")
            elseif lp.m_fFlags == 256 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "air")
            elseif lp.m_fFlags == 262 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "c-air")
            elseif lp.m_vecVelocity:length2d() <= 90 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "slowwalk")
            elseif lp.m_vecVelocity:length2d() >= 100 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "moving")
            end
            render.texture(avtr[avatr_sel:get()],vector(offst_sld:get(),scrsize.y/2),vector(50,50))
            render.text(1, vector(offst_sld:get()+53,scrsize.y/2), color(255,255,255), "с",  "> "..scriptname[script_sel:get()].."version: ")
            render.text(1, vector(offst_sld:get()+txtsize33.x+53,scrsize.y/2), clrs[vers_sel:get()], "с",  vers[vers_sel:get()])
            render.text(1, vector(offst_sld:get()+53,scrsize.y/2+txtsize33.y+1), color(255,255,255), "с",  "> user: ")
            render.text(1, vector(offst_sld:get()+txtsize44.x+53,scrsize.y/2+txtsize33.y+1), clrs[vers_sel:get()], "с",  namevar[name_sel:get()])
            render.text(1, vector(offst_sld:get()+53,scrsize.y/2+txtsize33.y+1+txtsize44.y), color(255,255,255), "с",  "> desync angle: ")
            render.text(1, vector(offst_sld:get()+txtsize55.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y), clrs[vers_sel:get()], "с",  math.floor(rage.antiaim:get_max_desync()).."°")
            render.text(1, vector(offst_sld:get()+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), color(255,255,255), "с",  "> anti-aim state: ")
        else
            local txtsize33 = render.measure_text(1,"с", "> "..scriptname[script_sel:get()]..", version: ")
            local txtsize44 = render.measure_text(1,"с", "> user: ")
            local txtsize55 = render.measure_text(1,"с", "> desync angle: ")
            local txtsize66 = render.measure_text(1,"с", "> anti-aim state: ")
            if lp.m_fFlags == 263 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "crouching")
            elseif lp.m_vecVelocity:length2d() < 5 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "standing")
            elseif lp.m_fFlags == 256 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "air")
            elseif lp.m_fFlags == 262 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "c-air")
            elseif lp.m_vecVelocity:length2d() <= 90 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "slowwalk")
            elseif lp.m_vecVelocity:length2d() >= 100 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "moving")
            end
            render.text(1, vector(offst_sld:get(),scrsize.y/2), color(255,255,255), "с",  "> "..scriptname[script_sel:get()]..", version: ")
            render.text(1, vector(offst_sld:get()+txtsize33.x,scrsize.y/2), clrs[vers_sel:get()], "с",  vers[vers_sel:get()])
            render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize33.y+1), color(255,255,255), "с",  "> user: ")
            render.text(1, vector(offst_sld:get()+txtsize44.x,scrsize.y/2+txtsize33.y+1), clrs[vers_sel:get()], "с",  namevar[name_sel:get()])
            render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize33.y+1+txtsize44.y), color(255,255,255), "с",  "> desync angle: ")
            render.text(1, vector(offst_sld:get()+txtsize55.x,scrsize.y/2+txtsize33.y+1+txtsize44.y), clrs[vers_sel:get()], "с",  math.floor(rage.antiaim:get_max_desync()).."°")
            render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), color(255,255,255), "с",  "> anti-aim state: ")
        end
    elseif theme_sel:get() == "StayMelon" then
        local txtsize9 = render.measure_text(1,"",scriptname[script_sel:get()].." - "..namevar[name_sel:get()])
        local txtsize10 = render.measure_text(1,"","version: ")
        local txtsize11 = render.measure_text(1,"","exploit charge: ")
        local txtsize12 = render.measure_text(1,"","desync amount: ")  
        local txtsize13 = render.measure_text(1,"","target: ")
        render.text(1, vector(offst_sld:get(),scrsize.y/2), color(255,255,255), "с",  scriptname[script_sel:get()].." - "..namevar[name_sel:get()])
        render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize9.y), color(255,255,255), "с",  "version: ")
        render.text(1, vector(offst_sld:get()+txtsize10.x-2,scrsize.y/2+txtsize9.y), clr2:get(), "с",  vers2[vers_sel:get()])
        render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize9.y*2), color(255,255,255), "с",  "exploit charge: ")
        if rage.exploit:get() > 0 and rage.exploit:get() < 1 then
            render.text(1, vector(offst_sld:get()+txtsize11.x,scrsize.y/2+txtsize9.y*2), color(255,255,255), "с",  "charging")
        elseif rage.exploit:get() == 0 then
            render.text(1, vector(offst_sld:get()+txtsize11.x-2,scrsize.y/2+txtsize9.y*2), color(255,255,255), "с",  "false")
        elseif rage.exploit:get() == 1 then
            render.text(1, vector(offst_sld:get()+txtsize11.x-2,scrsize.y/2+txtsize9.y*2), color(255,255,255), "с",  "true")
        end
        render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize9.y*3), color(255,255,255), "с",  "desync amount: ")
        render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize9.y*4), color(255,255,255), "с",  "target: ")
        if not closest_enemy then
            render.text(1, vector(offst_sld:get()+txtsize13.x-2,scrsize.y/2+txtsize9.y*4), color(255,255,255), "с", "none")
        else
            render.text(1, vector(offst_sld:get()+txtsize13.x-2,scrsize.y/2+txtsize9.y*4), color(255,255,255), "с",  closest_enemy:get_name())
        end
        render.text(1, vector(offst_sld:get()+txtsize12.x,scrsize.y/2+txtsize9.y*3), color(255,255,255), "с",  math.floor(rage.antiaim:get_max_desync()).."° ("..math.floor(rage.antiaim:get_max_desync()+math.random(-3,-  2)).."°)") 
    end
    end
    events.render:set(bebra)
					--reset kdr panel
									local ui_element = group_ref:switch(ui.get_icon('reply')..'   \a9fca2bffReset KD/R when negative', false)
local rs_create = ui_element:create()
local group_ref = ui.find('miscellaneous', 'main', 'in-game')

local command_ref = rs_create:input('RS Command', 'say_team !rs')
events.player_death:set(function(e)
	if not ui_element:get() then return end
	local me = entity.get_local_player()
	local dead = entity.get(e.userid, true)

	if me == dead then
		utils.execute_after(1, function()
			local resource = me:get_resource()
			
			if  resource.m_iKills < resource.m_iDeaths then
				utils.console_exec(command_ref:get())
			end
		end)
	end
end)
					--anti aim part
					
   local base64 = require("neverlose/base64")
    local clipboard = require("neverlose/clipboard")
    local refs = {
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    yaw_b = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    yaw_o = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    anti_k = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw","Avoid Backstab"),
    yaw_j = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    yaw_j_o = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier","Offset"),
    bodi = {
    ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw","Inverter"),
    ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw","Left Limit"),
    ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw","Right Limit"),
    ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw","Options"),
    ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw","Freestanding"),
        },
        rolli = {
    ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
    ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles","Extended Pitch"),
    ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles","Extended Roll"),
        },
        fris = {
    ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding","Disable Yaw Modifiers"),
    ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding","Body Freestanding"),
            },
    his = ui.find("Aimbot", "Ragebot","Main","Hide Shots" ),
    dot = ui.find("Aimbot", "Ragebot","Main","Double Tap" ),
    slw = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    }  
    local var = {
        player_state = {"Share","Standing","Running", "Walk", "Crouch", "Air", "Air+C"},
        Custom = {},
        Custom_c = {},
        menu = {
    mainaa = ui.create(" Anti-Aim", ui.get_icon('shield-alt').." Anti-Aim"),
    antia = ui.create(" Anti-Aim", ui.get_icon('running').." Builder"),
        },
        state = {
            onground_ticks = 0,
        
            in_air = function (indx)
                return bit.band(indx.m_fFlags,1) == 0
            end,
        
            on_ground = function (indx,limit)
                local onground = bit.band(indx.m_fFlags,1)
                if onground == 1 then
                    var.state.onground_ticks = var.state.onground_ticks + 1
                else
                    var.state.onground_ticks = 0
                end
        
                return var.state.onground_ticks > limit
            end,
        
            velocity = function(indx)
                local vel = indx.m_vecVelocity
                local velocity = math.sqrt(vel.x * vel.x + vel.y * vel.y)
                return velocity
            end,
        
            is_crouching = function (indx)
                return indx.m_flDuckAmount > 0.8
            end
    
        },
    }
    local mainaa = {
    enable = var.menu.mainaa:switch("Enable Anti-Aim",false),
    state = var.menu.antia:combo("Anti-aim Condition:",var.player_state),
    manual = var.menu.mainaa:switch("Manual Anti-Aim",false),
    fris = var.menu.mainaa:switch("Freestanding",false),
    anti_k  = var.menu.mainaa:switch("Anti-Backstab",false)
    }
    
    local anims = var.menu.mainaa:selectable("Animations", {'Static legs in air', 'Follow direction'}, 0)
    local switch_dt = var.menu.mainaa:switch("Break LC In Air")
    local dt_create = switch_dt:create()
    
    local main_c = {
        manual = {
            mainaa.manual:create():hotkey("Left",0x00),
            mainaa.manual:create():hotkey("Right",0x00),
            mainaa.manual:create():hotkey("Back",0x00),
        },
        fs = {
            mainaa.fris:create():switch("Disable Yaw Modifiers",false),
            mainaa.fris:create():switch("Body Freestanding",false)
        },
    }
    for i = 1, #var.player_state do
        var.Custom[i] = {
    enable = var.menu.antia:switch("Enabled "..var.player_state[i]),
    yaw = var.menu.antia:combo("Yaw base\n"..var.player_state[i],{"Backward"}),
    pitch = var.menu.antia:combo("Pitch\n"..var.player_state[i],{"Down"}),
    yaw_l = var.menu.antia:slider("Yaw Add Left\n"..var.player_state[i],-180,180,0),
    yaw_r = var.menu.antia:slider("Yaw Add Right\n"..var.player_state[i],-180,180,0),
    yaw_j = var.menu.antia:combo("Jitter Modifer\n"..var.player_state[i],{"Disabled","Center","Offset","Random","Spin"}),
    yaw_j_o = var.menu.antia:slider("Jitter Offset°\n"..var.player_state[i],-180,180,0),
    bodi = var.menu.antia:switch("Body Yaw\n"..var.player_state[i],false),
    fris_b = var.menu.antia:switch("Freestanding Desync\n"..var.player_state[i],false),
    fake_o = var.menu.antia:selectable("Options\n"..var.player_state[i],{"Avoid Overlap","Jitter","Randomize Jitter","Anti Bruteforce"}),
    left_l = var.menu.antia:slider("LBY Limit Left\n"..var.player_state[i],0,60,60),
    right_l = var.menu.antia:slider("LBY Limit Right\n"..var.player_state[i],0,60,60),
    rolli = var.menu.mainaa:switch("Extended Angles\n"..var.player_state[i],false),
        }
    end
    
    for i = 1, #var.player_state do
        var.Custom_c[i] = {
    yaw_b = var.Custom[i].yaw:create():combo("Base\n"..var.player_state[i],{"At Target"}),
    onshot = var.Custom[i].bodi:create():combo("On Shot\n"..var.player_state[i],{"Default","Opposite","Freestanding","Switch"}),
    lby = var.Custom[i].bodi:create():combo("LBY Mode\n"..var.player_state[i],{"Disabled","Opposite","Sway"}),
    roll_p = var.Custom[i].rolli:create():slider("Extended Pitch\n"..var.player_state[i],-180,180,89),
    roll_v = var.Custom[i].rolli:create():slider("Extended Roll\n"..var.player_state[i],0,90,45),
        }
    end
    
    
    --Cfg system lol--
    local data = {
        bools = {},
        tables = {},
        ints = {},
        numbers = {}
    }
    
    function pairsort(t)  
        local a = {}  
        for n in pairs(t) do    
            a[#a+1] = n  
        end  
        table.sort(a)  
        local i = 0  
        return function()  
            i = i + 1  
            return a[i], t[a[i]]  
        end  
    end 
    
    for i, v in pairsort(var.player_state) do
        for _, v in pairsort(var.Custom[i]) do
            if type(v:get()) == "boolean" then
                table.insert(data.bools,v)
            elseif type(v:get()) == "table" then
                table.insert(data.tables,v)
            elseif type(v:get()) == "string" then
                table.insert(data.ints,v)
            else
                table.insert(data.numbers,v)
            end
        end
    end
    for i, v in pairsort(var.player_state) do
        for _, v in pairsort(var.Custom_c[i]) do
            if type(v:get()) == "boolean" then
                table.insert(data.bools,v)
            elseif type(v:get()) == "table" then
                table.insert(data.tables,v)
            elseif type(v:get()) == "string" then
                table.insert(data.ints,v)
            else
                table.insert(data.numbers,v)
            end
        end
    end
    local function export()      
        local Code = {{},{},{},{},{}}
            for _, bools in pairs(data.bools) do
                table.insert(Code[1], bools:get())
            end
            
            for _, tables in pairs(data.tables) do
                table.insert(Code[2], tables:get())
            end
            
            for _, ints in pairs(data.ints) do
                table.insert(Code[3], ints:get())
            end
            
            for _, numbers in pairs(data.numbers) do
                table.insert(Code[4], numbers:get())
            end
    
            clipboard.set(base64.encode(json.stringify(Code)))
            
        print("AA Setting Export Successfully!")
    end
    local function import()
        for k, v in pairs(json.parse(base64.decode(clipboard.get()))) do
            k = ({[1] = "bools", [2] = "tables",[3] = "ints",[4] = "numbers"})[k]
            for k2, v2 in pairs(v) do
                if (k == "bools") then
                    data[k][k2]:set(v2)
                end
        
                if (k == "tables") then
                    data[k][k2]:set(v2)
                end
        
                if (k == "ints") then
                    data[k][k2]:set(v2)
                end
                    
                if (k == "numbers") then
                    data[k][k2]:set(v2)
                end
            end
        end
        print("AA Setting Import Successfully!")
    end
    
    local function defimport()
        for k, v in pairs(json.parse(base64.decode("W1tmYWxzZSx0cnVlLGZhbHNlLGZhbHNlLHRydWUsdHJ1ZSxmYWxzZSxmYWxzZSx0cnVlLHRydWUsZmFsc2UsZmFsc2UsdHJ1ZSx0cnVlLGZhbHNlLGZhbHNlLHRydWUsdHJ1ZSxmYWxzZSxmYWxzZSx0cnVlLHRydWUsZmFsc2UsZmFsc2UsZmFsc2UsdHJ1ZSxmYWxzZSxmYWxzZV0sW1tdLFsiSml0dGVyIl0sWyJKaXR0ZXIiXSxbIkppdHRlciJdLFsiSml0dGVyIl0sWyJKaXR0ZXIiXSxbXV0sWyJEb3duIiwiQmFja3dhcmQiLCJEaXNhYmxlZCIsIkRvd24iLCJCYWNrd2FyZCIsIkNlbnRlciIsIkRvd24iLCJCYWNrd2FyZCIsIkNlbnRlciIsIkRvd24iLCJCYWNrd2FyZCIsIkNlbnRlciIsIkRvd24iLCJCYWNrd2FyZCIsIkNlbnRlciIsIkRvd24iLCJCYWNrd2FyZCIsIkNlbnRlciIsIkRvd24iLCJCYWNrd2FyZCIsIkRpc2FibGVkIiwiRGlzYWJsZWQiLCJEZWZhdWx0IiwiQXQgVGFyZ2V0IiwiRGlzYWJsZWQiLCJPcHBvc2l0ZSIsIkF0IFRhcmdldCIsIkRpc2FibGVkIiwiU3dpdGNoIiwiQXQgVGFyZ2V0IiwiRGlzYWJsZWQiLCJGcmVlc3RhbmRpbmciLCJBdCBUYXJnZXQiLCJEaXNhYmxlZCIsIlN3aXRjaCIsIkF0IFRhcmdldCIsIk9wcG9zaXRlIiwiRnJlZXN0YW5kaW5nIiwiQXQgVGFyZ2V0IiwiRGlzYWJsZWQiLCJEZWZhdWx0IiwiQXQgVGFyZ2V0Il0sWzYwLjAsNjAuMCwwLjAsMC4wLDAuMCw2MC4wLDYwLjAsLTYwLjAsMjguMCwyOC4wLDU4LjAsNTguMCwtNDguMCwtMTYuMCwxNC4wLDYwLjAsNjAuMCwtODIuMCwwLjAsMy4wLDYwLjAsNjAuMCwtODIuMCwtNS4wLDE0LjAsNjAuMCw2MC4wLC00Mi4wLDUuMCwxOC4wLDYwLjAsNjAuMCwwLjAsMC4wLDAuMCw4OS4wLDQ1LjAsODkuMCw0NS4wLDg5LjAsNDUuMCw4OS4wLDQ1LjAsODkuMCw0NS4wLDg5LjAsNDUuMCw4OS4wLDQ1LjBdLFtdXQ=="))) do
            k = ({[1] = "bools", [2] = "tables",[3] = "ints",[4] = "numbers"})[k]
            for k2, v2 in pairs(v) do
                if (k == "bools") then
                    data[k][k2]:set(v2)
                end
    
                if (k == "tables") then
                    data[k][k2]:set(v2)
                end
    
                if (k == "ints") then
                    data[k][k2]:set(v2)
                end
    
                if (k == "numbers") then
                    data[k][k2]:set(v2)
                end
            end
        end
        print("Default Setting Import Successfully!")
    end
    
    local defimport = var.menu.mainaa:button(ui.get_icon('cloud').."                 Default Anti-Aim Config                  ",defimport)			
    local export = var.menu.mainaa:button(ui.get_icon('file-export').."                  Export Anti-Aim Config                   ",export)
    local import = var.menu.mainaa:button(ui.get_icon('file-import').."                  Import Anti-Aim Config                   ",import)
    
    local function Get_table_id(table, val)if #table > 0 then for i = 1, #table do if table[i] == val then return i end end end return 0 end
    local function visible()
        local p_state = Get_table_id(var.player_state,mainaa.state:get())
        for i = 1, #var.player_state do
        local state = mainaa.enable:get()
        local show = false
            if p_state == i then
                if p_state == 1 then
                    show = state
                    var.Custom[i].enable:set(state)
                    var.Custom[i].enable:visibility(false)
                else
                    show = state
                    var.Custom[i].enable:visibility(state)
                    if var.Custom[i].enable:get() then
                        show = state
                    else
                        show = false
                    end
                end
            else
                var.Custom[i].enable:visibility(false)
            end
            var.Custom[i].pitch:visibility(false)
            var.Custom[i].yaw:visibility(false)
            var.Custom[i].yaw_l:visibility(show)
            var.Custom[i].yaw_r:visibility(show)
            var.Custom[i].yaw_j:visibility(show)
            var.Custom[i].yaw_j_o:visibility(show)
            var.Custom[i].bodi:visibility(show)
            var.Custom[i].fris_b:visibility(show)
            var.Custom[i].fake_o:visibility(show)
            var.Custom[i].left_l:visibility(show)
            var.Custom[i].right_l:visibility(show)
            var.Custom[i].rolli:visibility(show)
    
            mainaa.enable:set_callback(visible)
            var.Custom[i].enable:set_callback(visible)
        end
    end
    visible()
    mainaa.state:set_callback(visible)
    local function main_ui()
        local show = mainaa.enable:get()
    
        mainaa.state:visibility(show)
        mainaa.manual:visibility(show)
        mainaa.fris:visibility(show)
        mainaa.anti_k :visibility(show)
        export:visibility(show)
        import:visibility(show)
        defimport:visibility(show)
        anims:visibility(show)
        switch_dt:visibility(show)
        
    end
    main_ui()
    mainaa.enable:set_callback(main_ui)
    ------------------------------------------
    
    
    local aa_dir = 0
    local last_press = 0
    local function run_direction()
        
        local fs_e = mainaa.fris:get()
    
        refs.fris[1]:override(mainaa.fris:get())
        refs.fris[2]:override(main_c.fs[1]:get())
        refs.fris[3]:override(main_c.fs[2]:get())
        refs.anti_k:override(mainaa.anti_k:get())
    
        if fs_e or not mainaa.manual:get() then
            aa_dir = 0
            last_press = globals.curtime
        else
            if main_c.manual[1]:get() and last_press + 0.2 < globals.curtime then
                aa_dir = aa_dir == -90 and 0 or -90
                last_press = globals.curtime
            elseif main_c.manual[2]:get() and last_press + 0.2 < globals.curtime then
                aa_dir = aa_dir == 90 and 0 or 90
                last_press = globals.curtime
            elseif main_c.manual[3]:get() and last_press + 0.2 < globals.curtime then
                aa_dir = aa_dir == 0
                last_press = globals.curtime
            elseif last_press > globals.curtime then
                last_press = globals.curtime
            end
        end
    end
    
    --------------------- AA Setup lol ---------------------
    local is_invert = false
    local function antiaim()
        run_direction()
    
        if not mainaa.enable:get() then return end
        local lp = entity.get_local_player()
        if lp == nil then return end
    
        local state
        if var.state.in_air(lp) then
            state = 6
        elseif var.state.is_crouching(lp) then
            state = 5
        elseif var.state.velocity(lp) > 3 then
            if refs.slw:get() then
                state = 4
            else
                state = 3
            end
        else
            state = 2
        end
        if var.state.is_crouching(lp) and var.state.in_air(lp) then
            state = 7
        end
        if not var.Custom[state].enable:get() then
            state = 1
        end
    
    
        local lp_bodyyaw = lp.m_flPoseParameter[11] * 120 - 60
            
        local yaw_a = var.Custom[state].yaw_l:get()
        local yaw_b = var.Custom[state].yaw_r:get()
        local yaw   = lp_bodyyaw <= 0 and yaw_b or yaw_a
        refs.pitch:override(var.Custom[state].pitch:get())
        refs.yaw:override(var.Custom[state].yaw:get())
        refs.yaw_b:override(var.Custom_c[state].yaw_b:get())
        refs.yaw_o:override(aa_dir == 0 and yaw or aa_dir)
        refs.yaw_j:override(var.Custom[state].yaw_j:get())
        refs.yaw_j:override(var.Custom[state].yaw_j:get())
        refs.yaw_j_o:override(var.Custom[state].yaw_j_o:get())
        refs.bodi[1]:override(var.Custom[state].bodi:get())
        refs.bodi[3]:override(var.Custom[state].left_l:get())
        refs.bodi[4]:override(var.Custom[state].right_l:get())
        refs.bodi[5]:override(var.Custom[state].fake_o:get())
    
        if var.Custom[state].fris_b:get() then
            refs.bodi[6]:override("Peek Fake")
        elseif not var.Custom[state].fris_b:get() then
            refs.bodi[6]:override("Off")
        end
    
    
        refs.rolli[1]                :override(var.Custom[state].rolli:get())
        refs.rolli[2]                :override(var.Custom_c[state].roll_p:get())
        refs.rolli[3]                :override(var.Custom_c[state].roll_v:get())
    end
    events.createmove:set(antiaim) 
						-- rgb line
						local rdg = visual:switch(ui.get_icon('rainbow').."  \a9fca2bffGamesense Animated RBG Bar", false)
local rgbgroup = rdg:create()
local rbg = rgbgroup:switch("RGB Only Menu Visible", false)
local rgbs = rgbgroup:slider("RGB line size", 1, 10, 1)
events.render:set(function()
    local col1 = math.floor(math.sin(globals.realtime * 2) * 220 + 250) -- R
    local col2 = math.floor(math.sin(globals.realtime * 2 + 2 ) * 200 + 250) -- G
    local col3 = math.floor(math.sin(globals.realtime * 2 + 1) * 100 + 20) -- B
    if rdg:get() then
        render.rect(vector(-100, -10), vector(2000, rgbs:get()), color(col1, col2, col3, 255), 7)
    end
    if rbg:get() and rdg:set(false) then    
        if ui.get_alpha() == 1 then
            rdg:set(true)
        end
    end
end)
						--solus UI 
--menu

local group2 = ui.create("\a85AFFFC8Solus UI", "\a85AFFFC8Information")
local group = ui.create("\a85AFFFC8Solus UI", "\a85AFFFC8Solus UI")
local windows_theme = visual:combo(ui.get_icon('heart')..'  \a9fca2bffSolus UI', {'Disabled', 'Default', 'Rounded'}, 0)
local solus_select = visual:selectable(ui.get_icon('arrow-right').."  \a9fca2bffSolus UI Select", {'Watermark', 'Keybinds'}, 0)
local solus_ref = solus_select:create()
local color_picker = solus_ref:color_picker("Accent color", color(107, 139, 255, 255))
local custom_name = visual:input(ui.get_icon('user').."  \a9fca2bffUsername", ""..common.get_username().."")
local pulsating = visual:switch("Pulsating fade", false)
local background = visual:switch("Remove background", false)
local background_ref1 = background:create()
local background_removals = background_ref1:selectable("Back. Removals", {'Watermark', 'Keybinds'}, 0)
local solus_slider = visual:slider("Window Rounding", 6, 10, 6)

--locals
local tween=(function()local a={}local b,c,d,e,f,g,h=math.pow,math.sin,math.cos,math.pi,math.sqrt,math.abs,math.asin;local function i(j,k,l,m)return l*j/m+k end;local function n(j,k,l,m)return l*b(j/m,2)+k end;local function o(j,k,l,m)j=j/m;return-l*j*(j-2)+k end;local function p(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,2)+k end;return-l/2*((j-1)*(j-3)-1)+k end;local function q(j,k,l,m)if j<m/2 then return o(j*2,k,l/2,m)end;return n(j*2-m,k+l/2,l/2,m)end;local function r(j,k,l,m)return l*b(j/m,3)+k end;local function s(j,k,l,m)return l*(b(j/m-1,3)+1)+k end;local function t(j,k,l,m)j=j/m*2;if j<1 then return l/2*j*j*j+k end;j=j-2;return l/2*(j*j*j+2)+k end;local function u(j,k,l,m)if j<m/2 then return s(j*2,k,l/2,m)end;return r(j*2-m,k+l/2,l/2,m)end;local function v(j,k,l,m)return l*b(j/m,4)+k end;local function w(j,k,l,m)return-l*(b(j/m-1,4)-1)+k end;local function x(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,4)+k end;return-l/2*(b(j-2,4)-2)+k end;local function y(j,k,l,m)if j<m/2 then return w(j*2,k,l/2,m)end;return v(j*2-m,k+l/2,l/2,m)end;local function z(j,k,l,m)return l*b(j/m,5)+k end;local function A(j,k,l,m)return l*(b(j/m-1,5)+1)+k end;local function B(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,5)+k end;return l/2*(b(j-2,5)+2)+k end;local function C(j,k,l,m)if j<m/2 then return A(j*2,k,l/2,m)end;return z(j*2-m,k+l/2,l/2,m)end;local function D(j,k,l,m)return-l*d(j/m*e/2)+l+k end;local function E(j,k,l,m)return l*c(j/m*e/2)+k end;local function F(j,k,l,m)return-l/2*(d(e*j/m)-1)+k end;local function G(j,k,l,m)if j<m/2 then return E(j*2,k,l/2,m)end;return D(j*2-m,k+l/2,l/2,m)end;local function H(j,k,l,m)if j==0 then return k end;return l*b(2,10*(j/m-1))+k-l*0.001 end;local function I(j,k,l,m)if j==m then return k+l end;return l*1.001*(-b(2,-10*j/m)+1)+k end;local function J(j,k,l,m)if j==0 then return k end;if j==m then return k+l end;j=j/m*2;if j<1 then return l/2*b(2,10*(j-1))+k-l*0.0005 end;return l/2*1.0005*(-b(2,-10*(j-1))+2)+k end;local function K(j,k,l,m)if j<m/2 then return I(j*2,k,l/2,m)end;return H(j*2-m,k+l/2,l/2,m)end;local function L(j,k,l,m)return-l*(f(1-b(j/m,2))-1)+k end;local function M(j,k,l,m)return l*f(1-b(j/m-1,2))+k end;local function N(j,k,l,m)j=j/m*2;if j<1 then return-l/2*(f(1-j*j)-1)+k end;j=j-2;return l/2*(f(1-j*j)+1)+k end;local function O(j,k,l,m)if j<m/2 then return M(j*2,k,l/2,m)end;return L(j*2-m,k+l/2,l/2,m)end;local function P(Q,R,l,m)Q,R=Q or m*0.3,R or 0;if R<g(l)then return Q,l,Q/4 end;return Q,R,Q/(2*e)*h(l/R)end;local function S(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m;if j==1 then return k+l end;Q,R,T=P(Q,R,l,m)j=j-1;return-(R*b(2,10*j)*c((j*m-T)*2*e/Q))+k end;local function U(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m;if j==1 then return k+l end;Q,R,T=P(Q,R,l,m)return R*b(2,-10*j)*c((j*m-T)*2*e/Q)+l+k end;local function V(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m*2;if j==2 then return k+l end;Q,R,T=P(Q,R,l,m)j=j-1;if j<0 then return-0.5*R*b(2,10*j)*c((j*m-T)*2*e/Q)+k end;return R*b(2,-10*j)*c((j*m-T)*2*e/Q)*0.5+l+k end;local function W(j,k,l,m,R,Q)if j<m/2 then return U(j*2,k,l/2,m,R,Q)end;return S(j*2-m,k+l/2,l/2,m,R,Q)end;local function X(j,k,l,m,T)T=T or 1.70158;j=j/m;return l*j*j*((T+1)*j-T)+k end;local function Y(j,k,l,m,T)T=T or 1.70158;j=j/m-1;return l*(j*j*((T+1)*j+T)+1)+k end;local function Z(j,k,l,m,T)T=(T or 1.70158)*1.525;j=j/m*2;if j<1 then return l/2*j*j*((T+1)*j-T)+k end;j=j-2;return l/2*(j*j*((T+1)*j+T)+2)+k end;local function _(j,k,l,m,T)if j<m/2 then return Y(j*2,k,l/2,m,T)end;return X(j*2-m,k+l/2,l/2,m,T)end;local function a0(j,k,l,m)j=j/m;if j<1/2.75 then return l*7.5625*j*j+k end;if j<2/2.75 then j=j-1.5/2.75;return l*(7.5625*j*j+0.75)+k elseif j<2.5/2.75 then j=j-2.25/2.75;return l*(7.5625*j*j+0.9375)+k end;j=j-2.625/2.75;return l*(7.5625*j*j+0.984375)+k end;local function a1(j,k,l,m)return l-a0(m-j,0,l,m)+k end;local function a2(j,k,l,m)if j<m/2 then return a1(j*2,0,l,m)*0.5+k end;return a0(j*2-m,0,l,m)*0.5+l*.5+k end;local function a3(j,k,l,m)if j<m/2 then return a0(j*2,k,l/2,m)end;return a1(j*2-m,k+l/2,l/2,m)end;a.easing={linear=i,inQuad=n,outQuad=o,inOutQuad=p,outInQuad=q,inCubic=r,outCubic=s,inOutCubic=t,outInCubic=u,inQuart=v,outQuart=w,inOutQuart=x,outInQuart=y,inQuint=z,outQuint=A,inOutQuint=B,outInQuint=C,inSine=D,outSine=E,inOutSine=F,outInSine=G,inExpo=H,outExpo=I,inOutExpo=J,outInExpo=K,inCirc=L,outCirc=M,inOutCirc=N,outInCirc=O,inElastic=S,outElastic=U,inOutElastic=V,outInElastic=W,inBack=X,outBack=Y,inOutBack=Z,outInBack=_,inBounce=a1,outBounce=a0,inOutBounce=a2,outInBounce=a3}local function a4(a5,a6,a7)a7=a7 or a6;local a8=getmetatable(a6)if a8 and getmetatable(a5)==nil then setmetatable(a5,a8)end;for a9,aa in pairs(a6)do if type(aa)=="table"then a5[a9]=a4({},aa,a7[a9])else a5[a9]=a7[a9]end end;return a5 end;local function ab(ac,ad,ae)ae=ae or{}local af,ag;for a9,ah in pairs(ad)do af,ag=type(ah),a4({},ae)table.insert(ag,tostring(a9))if af=="number"then assert(type(ac[a9])=="number","Parameter '"..table.concat(ag,"/").."' is missing from subject or isn't a number")elseif af=="table"then ab(ac[a9],ah,ag)else assert(af=="number","Parameter '"..table.concat(ag,"/").."' must be a number or table of numbers")end end end;local function ai(aj,ac,ad,ak)assert(type(aj)=="number"and aj>0,"duration must be a positive number. Was "..tostring(aj))local al=type(ac)assert(al=="table"or al=="userdata","subject must be a table or userdata. Was "..tostring(ac))assert(type(ad)=="table","target must be a table. Was "..tostring(ad))assert(type(ak)=="function","easing must be a function. Was "..tostring(ak))ab(ac,ad)end;local function am(ak)ak=ak or"linear"if type(ak)=="string"then local an=ak;ak=a.easing[an]if type(ak)~="function"then error("The easing function name '"..an.."' is invalid")end end;return ak end;local function ao(ac,ad,ap,aq,aj,ak)local j,k,l,m;for a9,aa in pairs(ad)do if type(aa)=="table"then ao(ac[a9],aa,ap[a9],aq,aj,ak)else j,k,l,m=aq,ap[a9],aa-ap[a9],aj;ac[a9]=ak(j,k,l,m)end end end;local ar={}local as={__index=ar}function ar:set(aq)assert(type(aq)=="number","clock must be a positive number or 0")self.initial=self.initial or a4({},self.target,self.subject)self.clock=aq;if self.clock<=0 then self.clock=0;a4(self.subject,self.initial)elseif self.clock>=self.duration then self.clock=self.duration;a4(self.subject,self.target)else ao(self.subject,self.target,self.initial,self.clock,self.duration,self.easing)end;return self.clock>=self.duration end;function ar:reset()return self:set(0)end;function ar:update(at)assert(type(at)=="number","dt must be a number")return self:set(self.clock+at)end;function a.new(aj,ac,ad,ak)ak=am(ak)ai(aj,ac,ad,ak)return setmetatable({duration=aj,subject=ac,target=ad,easing=ak,clock=0},as)end;return a end)()
local tween_table = {}
local tween_data = {
    kb_alpha = 0,
    wm_alpha = 0
}
local refs = {
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    fl = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
}

--main
function tween_updater()
    for _, t in pairs(tween_table) do
        t:update(globals.frametime)
    end
end
events.render:set(tween_updater)

local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
    local output = ''
    local len = #text-1
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len
    for i=1, len+1 do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end

    return output
end


local hsv_to_rgb = function(b,c,d,e)
    local f,g,h;local i=math.floor(b*6)
    local j=b*6-i;local k=d*(1-c)
    local l=d*(1-j*c)
    local m=d*(1-(1-j)*c)i=i%6;
    if i==0 then f,g,h=d,m,k
     elseif i==1 then f,g,h=l,d,k
     elseif i==2 then f,g,h=k,d,m
     elseif i==3 then f,g,h=k,l,d
     elseif i==4 then f,g,h=m,k,d
     elseif i==5 then f,g,h=d,k,l end;
    return f*255,g*255,h*255,e*255
end

--watermark
function watermark()
    if windows_theme:get() == 'Rounded' then
    if solus_select:get('Watermark')  then
    local x,y = render.screen_size().x, render.screen_size().y
    local lp = entity.get_local_player()

    local net = utils.net_channel()
    local time = common.get_system_time()
    local time_text = string.format('%02d:%02d', time.hours, time.minutes)
    
    local maximum_off = 28
    local text_w = render.measure_text(1, nil, "neverlose  "..custom_name:get().."  "..time_text.."").x - 30
    maximum_off = maximum_off < text_w and text_w or maximum_off
    local w = 108 - maximum_off


    --[[if solus_slider:get() > 1 then
        render.gradient(vector(x - 165 - 2 + w, y/60 - 6 - 2), vector(x - 7 + 2, y/60 + 16 + 2), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(0, 0, 0, 0), color(0, 0, 0, 0), solus_slider:get())
        else
        render.gradient(vector(x - 165 + w, y/60 - 6 - 2), vector(x - 7, y/60 + 16 + 2), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(0, 0, 0, 0), color(0, 0, 0, 0), solus_slider:get())
    end--]]

    
    render.gradient(vector(x - 165 - 2 + w, y/60 - 6 - 2), vector(x - 7 + 2, y/60 + 16 - 3), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(0, 0, 0, 0), color(0, 0, 0, 0), solus_slider:get())
    render.rect(vector(x - 165 + w, y/60 - 6), vector(x - 7, y/60 + 16), color(0, 0, 0, 190), solus_slider:get())


    --render.rect(vector(x - 165 + w, y/2 1005 - 6), vector(x - 7, y/2 1002 + 16), color(0, 0, 0, 190), 7)

    --render.rect(vector(x/1.09 - 5, y/60 - 6), vector(x/1.09 + 153, y/60 + 16), color(0, 0, 0, 190), 7)
    --render.rect(vector(x - 18, y - 35), vector(x + 18, y + 35), color(0, 0, 0, 255), 7)

    render.text(1, vector(x - 150 - 5 + w, y/60 - 2), color(255, 255, 255, 255), nil, "never      ")
    render.text(1, vector(x - 127 + w, y/60 - 2), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), nil, "lose")
    render.text(1, vector(x - 150 - 5 + w + render.measure_text(1, nil, "neverlose  ").x, y/60 - 2), color(255, 255, 255, 255), nil, ""..custom_name:get().." ")
    render.text(1, vector(x - 150 - 5 + w + render.measure_text(1, nil, "neverlose  "..custom_name:get().."").x, y/60 - 2), color(255, 255, 255, 255), nil, "  "..time_text.."")
end
end
end
events.render:set(watermark)

function watermark2()


    if windows_theme:get() == 'Default' then
    if solus_select:get('Watermark')  then
        local z = globals.realtime * 0.2
        local rgb_split_ratio = 100 / 100
            r, g, b = hsv_to_rgb(z, 1, 1, 1)
            r, g, b = r * rgb_split_ratio,
            g * rgb_split_ratio,
            b * rgb_split_ratio
    local x,y = render.screen_size().x, render.screen_size().y
    local lp = entity.get_local_player()

    local net = utils.net_channel()
    local time = common.get_system_time()
    local time_text = string.format('%02d:%02d', time.hours, time.minutes)
    
    local maximum_off = 28
    local text_w = render.measure_text(1, nil, "neverlose  "..custom_name:get().."  "..time_text.."").x - 30
    maximum_off = maximum_off < text_w and text_w or maximum_off
    local w = 108 - maximum_off


   

    if windows_theme:get() == 'Default' and solus_select:get('Watermark') and pulsating:get() then
        render.gradient(vector(x - 165 + w, y/60 - 6 - 2), vector(x - 7, y/60 - 6), color(r, g, b, 255), color(b, r, g, 255), color(r, g, b, 255), color(b, r, g, 255), 0)
        if background:get() and background_removals:get('Watermark') then
            render.rect(vector(x - 165 + w, y/60 - 6), vector(x - 7, y/60 + 14), color(0, 0, 0, 0), 0)
        else
            render.rect(vector(x - 165 + w, y/60 - 6), vector(x - 7, y/60 + 14), color(0, 0, 0, 80), 0)
        end
    end

    if windows_theme:get() == 'Default' and solus_select:get('Watermark') and not pulsating:get() then
        render.rect(vector(x - 165 + w, y/60 - 6 - 2), vector(x - 7, y/60 - 6), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), 0)
        if background:get() and background_removals:get('Watermark') then
            render.rect(vector(x - 165 + w, y/60 - 6), vector(x - 7, y/60 + 14), color(0, 0, 0, 0), 0)
        else
            render.rect(vector(x - 165 + w, y/60 - 6), vector(x - 7, y/60 + 14), color(0, 0, 0, 80), 0)
        end
    end

   

    

    --render.rect(vector(x - 165 + w, y/2 1005 - 6), vector(x - 7, y/2 1002 + 16), color(0, 0, 0, 190), 7)

    --render.rect(vector(x/1.09 - 5, y/60 - 6), vector(x/1.09 + 153, y/60 + 16), color(0, 0, 0, 190), 7)
    --render.rect(vector(x - 18, y - 35), vector(x + 18, y + 35), color(0, 0, 0, 255), 7)

    render.text(1, vector(x - 150 - 5 + w, y/60 - 3), color(255, 255, 255, 255), nil, "YODIE.     ")
    render.text(1, vector(x - 127 + w, y/60 - 3), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), nil, " YAW")
    render.text(1, vector(x - 150 - 5 + w + render.measure_text(1, nil, "neverlose  ").x, y/60 - 3), color(255, 255, 255, 255), nil, ""..custom_name:get().." ")
    render.text(1, vector(x - 150 - 5 + w + render.measure_text(1, nil, "neverlose  "..custom_name:get().."").x, y/60 - 3), color(255, 255, 255, 255), nil, "  "..time_text.."")
end
end
end
events.render:set(watermark2)



--keybinds
local animations = {
	
	speed = 9.2,
	stored_values = {},
	active_this_frame = {},
	prev_realtime = globals.realtime,
    realtime = globals.realtime,
    multiplier = 0.0,

	
    clamp = function(v, min, max)
		return ((v > max) and max) or ((v < min) and min or v)
	end,

	
    new_frame = function(self)
    	self.prev_realtime = self.realtime
        self.realtime = globals.realtime
        self.multiplier = (self.realtime - self.prev_realtime) * self.speed
        
        for k, v in pairs(self.stored_values) do
            if self.active_this_frame[k] ~= nil then goto continue end
			self.stored_values[k] = nil
			::continue::
        end

        self.active_this_frame = {}
    end,
    reset = function(self, name)
        self.stored_values[name] = nil
    end,
    
    
    animate = function (self, name, decrement, max_value)
        max_value = max_value or 1.0
		decrement = decrement or false

        local frames = self.multiplier * (decrement and -1 or 1)

		local v = self.clamp(self.stored_values[name] and self.stored_values[name] or 0.0, 0.0, max_value) 
        v = self.clamp(v + frames, 0.0, max_value)

        self.stored_values[name] = v
        self.active_this_frame[name] = true

        return v
    end
}

local memory = { x, y }
local drag_items = {
    x_slider = group:slider("X position", 0, 2560, 50.0, 0.01),
    y_slider = group:slider("Y position", 0, 1440, 50.0, 0.01),
    x_slider1 = group:slider("X position", 0, 2560, 50.0, 0.01),
    y_slider1 = group:slider("Y position", 0, 1440, 50.0, 0.01),
}
drag_items.x_slider:visibility(false)
drag_items.y_slider:visibility(false)
drag_items.x_slider1:visibility(false)
drag_items.y_slider1:visibility(false)

local drag_window = function(x, y, w, h, val1, val2)
    local key_pressed  = common.is_button_down(0x01);
    local mouse_pos    = ui.get_mouse_position()

    if mouse_pos.x >= x and mouse_pos.x <= x + w and mouse_pos.y >= y and mouse_pos.y <= y + h then
        if key_pressed and drag == false then
            drag = true;
            memory.x = x - mouse_pos.x;
            memory.y = y - mouse_pos.y;
        end
    end

    if not key_pressed then
        drag = false;
    end

    if drag == true and ui.get_alpha() == 1 then
        val1:set(mouse_pos.x + memory.x);
        val2:set(mouse_pos.y + memory.y);
    end
end

local function render_conteiner(x, y, w, h, name, font_size, font, alpha)
    local alpha2 = (alpha/500)
    local name_size = render.measure_text(1, nil, name)
   
    if windows_theme:get() == 'Rounded' then
    if solus_select:get('Keybinds') then

    
    --[[if solus_slider:get() > 1 then
        render.gradient(vector(x + 1 - 2, y - 4 - 2), vector(x + w + 1 + 2, y + h + 2), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), color(0, 0, 0, alpha*0), color(0, 0, 0, alpha*0), solus_slider:get())
        render.rect(vector(x + 1, y - 4), vector(x + w + 1, y + h - 1.5), color(0, 0, 0, alpha/1.4), solus_slider:get())
    else
        --render.gradient(vector(x + 1, y - 4 - 2), vector(x + w, y), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), color(0, 0, 0, alpha*0), color(0, 0, 0, alpha*0), solus_slider:get())
        render.rect(vector(x + 1, y - 5), vector(x + w, y - 3), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), solus_slider:get())
        render.rect(vector(x + 1, y - 4), vector(x + w, y + h - 1.5), color(0, 0, 0, alpha/4), solus_slider:get())
    end--]]

    render.gradient(vector(x + 1 - 2, y - 4 - 2), vector(x + w + 1 + 2, y + h - 2), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), color(0, 0, 0, alpha*0), color(0, 0, 0, alpha*0), solus_slider:get())
    render.rect(vector(x + 1, y - 4), vector(x + w + 1, y + h - 1.5), color(0, 0, 0, alpha/1.4), solus_slider:get())
    render.text(1, vector(x-1 + w / 2 + 1 - name_size.x / 2, y - 1), color(255, 255, 255, alpha), nil, name)
    end
end
--render.gradient(vector(x + 1, y - 5), vector(x + w, y - 3), color(r, g, b, alpha), color(b, r, g, alpha), color(r, g, b, alpha), color(b, r, g, alpha), 0)
local z = globals.realtime * 0.2
        local rgb_split_ratio = 100 / 100
            r, g, b = hsv_to_rgb(z, 1, 1, 1)
            r, g, b = r * rgb_split_ratio,
            g * rgb_split_ratio,
            b * rgb_split_ratio
    if windows_theme:get() == 'Default' and solus_select:get('Keybinds') and not pulsating:get() then
    render.rect(vector(x + 1, y - 5), vector(x + 6 + w, y - 3), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), 0)
    if background:get() and background_removals:get('Keybinds') then
        render.rect(vector(x + 1, y - 4), vector(x + 6 + w, y + h - 1.5), color(0, 0, 0, 0), 0)
    else
        render.rect(vector(x + 1, y - 4), vector(x + 6 + w, y + h - 1.5), color(0, 0, 0, alpha/4), 0)
    end
    render.text(1, vector(x+2 + w / 2 + 1 - name_size.x / 2, y - 1), color(255, 255, 255, alpha), nil, name)
    end

    if windows_theme:get() == 'Default' and solus_select:get('Keybinds') and pulsating:get() then
    render.gradient(vector(x + 1, y - 5), vector(x + 6 + w, y - 3), color(r, g, b, alpha), color(b, r, g, alpha), color(r, g, b, alpha), color(b, r, g, alpha), 0)
    if background:get() and background_removals:get('Keybinds') then
        render.rect(vector(x + 1, y - 4), vector(x + 6 + w, y + h - 1.5), color(0, 0, 0, 0), 0)
    else
        render.rect(vector(x + 1, y - 4), vector(x + 6 + w, y + h - 1.5), color(0, 0, 0, alpha/4), 0)
    end
    render.text(1, vector(x+2 + w / 2 + 1 - name_size.x / 2, y - 1), color(255, 255, 255, alpha), nil, name)
    end
end


local function keybinds()
    if windows_theme:get() == 'Rounded' or windows_theme:get() == 'Default' then
    if solus_select:get('Keybinds') then
    animations:new_frame()
    local binds = ui.get_binds()
    local j = 0
    local m_alpha = 0
    local maximum_offset = 28
    local kb_shown = false

    for i = 1, #binds do
        local c_name = binds[i].name
        if c_name == 'Peek Assist' then c_name = 'Quick peek assist' end
        if c_name == 'Edge Jump' then c_name = 'Jump at edge' end
        if c_name == 'Hide Shots' then c_name = 'On shot anti-aim' end
        if c_name == 'Minimum Damage' then c_name = 'Minimum damage' end
        if c_name == 'Fake Latency' then c_name = 'Ping spike' end
        if c_name == 'Fake Duck' then c_name = 'Duck peek assist' end
        if c_name == 'Safe Points' then c_name = 'Safe point' end
        if c_name == 'Body Aim' then c_name = 'Body aim' end
        if c_name == 'Yaw Base' then c_name = 'Manual override' end
        if c_name == 'Slow Walk' then c_name = 'Slow motion' end
        
        local text_width = render.measure_text(1, nil, c_name).x - 30

        if binds[i].active then
            kb_shown = true
            maximum_offset = maximum_offset < text_width and text_width or maximum_offset
        end 
    end

    local w = 90 + maximum_offset
    local x,y = drag_items.x_slider:get(), drag_items.y_slider:get()

    m_alpha = animations:animate('state', not (kb_shown or ui.get_alpha() == 1))
    tween_table.kb_alpha = tween.new(0.25, tween_data, {kb_alpha = w}, 'outCubic');w = tween_data.kb_alpha

    render_conteiner(x-1, y, w, 17, 'keybinds', 11, 1, math.floor(tonumber(m_alpha*255)))
    --Render.BoxFilled(vector(x, y), vector(x + w, y + 18), Color.new(0,0,0,1*m_alpha))
    --Render.BoxFilled(vector(x, y), vector(x + w, y + 2), Color.new(173/255, 249/255, 1,1*m_alpha))

    --Render.Text(' ' .. 'keybinds', vector(x - Render.CalcTextSize('keybinds', 11, font).x / 2 + w/2, y + 4), Color.new(1.0, 1.0, 1.0, 1*m_alpha), 11, 1, false)

    for i=1, #binds do
        local alpha = animations:animate(binds[i].name, not binds[i].active)
        local get_mode = binds[i].mode == 1 and '[holding]' or (binds[i].mode == 2 and '[toggled]') or '[?]'

        local c_name = binds[i].name
        if c_name == 'Peek Assist' then c_name = 'Quick peek assist' end
        if c_name == 'Edge Jump' then c_name = 'Jump at edge' end
        if c_name == 'Hide Shots' then c_name = 'On shot anti-aim' end
        if c_name == 'Minimum Damage' then c_name = 'Minimum damage' end
        if c_name == 'Fake Latency' then c_name = 'Ping spike' end
        if c_name == 'Fake Duck' then c_name = 'Duck peek assist' end
        if c_name == 'Safe Points' then c_name = 'Safe point' end
        if c_name == 'Body Aim' then c_name = 'Body aim' end
        if c_name == 'Double Tap' then c_name = 'Double tap' end
        if c_name == 'Yaw Base' then c_name = 'Manual override' end
        if c_name == 'Slow Walk' then c_name = 'Slow motion' end


        local get_value = binds[i].value
        if windows_theme:get() == 'Rounded' then
        if c_name == 'Minimum damage' or c_name == 'Ping spike' then
            render.text(1, vector(x + 2, y + 18 + j), color(255, 255, 255, alpha*255), nil, c_name)
            render.text(1, vector(x - 12 + w - render.measure_text(1, nil, get_value).x , y + 18 + j), color(255, 255, 255, alpha*255), nil, "["..get_value.."]")
        else
            render.text(1, vector(x + 2, y + 18 + j), color(255, 255, 255, alpha*255), nil, c_name)
            render.text(1, vector(x - 2 + w - render.measure_text(1, nil, get_mode).x , y + 18 + j), color(255, 255, 255, alpha*255), nil, '' .. get_mode)
        end
        elseif windows_theme:get() == 'Default' then
        if c_name == 'Minimum damage' or c_name == 'Ping spike' then
            render.text(1, vector(x + 2, y + 18 + j), color(255, 255, 255, alpha*255), nil, c_name)
            render.text(1, vector(x - 7 + w - render.measure_text(1, nil, get_value).x , y + 18 + j), color(255, 255, 255, alpha*255), nil, "["..get_value.."]")
        else
            render.text(1, vector(x + 2, y + 18 + j), color(255, 255, 255, alpha*255), nil, c_name)
            render.text(1, vector(x + 3 + w - render.measure_text(1, nil, get_mode).x , y + 18 + j), color(255, 255, 255, alpha*255), nil, '' .. get_mode)
        end
    end
    
        j = j + 15*alpha
        ::skip::
    end

    drag_window(x, y, 150, 25, drag_items.x_slider, drag_items.y_slider)
end
end
end
events.render:set(keybinds)

menu_handle = function()

    if ui.get_alpha() == 0 then return end
    solus_slider:visibility(windows_theme:get() == 'Rounded')
    pulsating:visibility(windows_theme:get() == 'Default')
    background:visibility(windows_theme:get() == 'Default')
    
end
events.render:set(menu_handle)
--