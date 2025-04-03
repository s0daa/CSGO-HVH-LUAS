local script_info = {
    name = "Black Sector",
    released = "yes",
    last_update = "11/11/199999999",
    script_type = "Debug",
    version = "1.0",
    state = "stabilized",
}

local obex_data = obex_fetch and obex_fetch() or {username = 'hui s gori', build = script_info.script_type, discord=''}

local dragging_fn = function(name, base_x, base_y) return (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui.new_slider('LUA','A','\n'..u..' window position y',0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)().new(name, base_x, base_y) end
local pui = require("gamesense/pui") or error("Subscribe to PUI Library | https://gamesense.pub/forums/viewtopic.php?id=41761")
local ffi = require("ffi")
local base64 = require("gamesense/base64")
local vector = require("vector")
local c_entity = require("gamesense/entity")
local notify_lol = {}
local E_POSE_PARAMETERS = {
    STRAFE_YAW = 0,
    STAND = 1,
    LEAN_YAW = 2,
    SPEED = 3,
    LADDER_YAW = 4,
    LADDER_SPEED = 5,
    JUMP_FALL = 6,
    MOVE_YAW = 7,
    MOVE_BLEND_CROUCH = 8,
    MOVE_BLEND_WALK = 9,
    MOVE_BLEND_RUN = 10,
    BODY_YAW = 11,
    BODY_PITCH = 12,
    AIM_BLEND_STAND_IDLE = 13,
    AIM_BLEND_STAND_WALK = 14,
    AIM_BLEND_STAND_RUN = 14,
    AIM_BLEND_CROUCH_IDLE = 16,
    AIM_BLEND_CROUCH_WALK = 17,
    DEATH_YAW = 18
}
local helpers = {}

local color = function(rr,gg,bb,aa) local color_r = rr local color_g = gg or 255 local color_b = bb or 255 local color_a = aa or 255 return {r = color_r, g = color_g, b = color_b, a = color_a} end

helpers.lerp = function(a,b,p) 
    return a + (b - a) * p
end

helpers.rgba2hex = function(b,c,d,e)
    return string.format('%02x%02x%02x%02x',b,c,d,e)
end

helpers.calculateGradient = function(performingText, selectedColors, animationSpeed, interpolateValue, invertAnimationDirection)
    local result = ""
    local textLength, colorLength = #performingText, 1 / (#selectedColors - (interpolateValue or 1.5))
    local animationSpeed, animationDirection = animationSpeed or 1.5, invertAnimationDirection and 1 or -1

    for i = 1, textLength do    
        local letterStep = i / textLength
        local globalLength = letterStep / colorLength

        local newIndex = math.ceil(globalLength)
        local firstColor, secondColor = selectedColors[newIndex], selectedColors[newIndex + 1]

        local calculatedPercentage = math.abs(math.cos(globals.curtime() * animationSpeed + (letterStep * animationDirection * 2.5)))
        local r, g, b, a = helpers.lerp(firstColor.r, secondColor.r, calculatedPercentage), helpers.lerp(firstColor.g, secondColor.g, calculatedPercentage), helpers.lerp(firstColor.b, secondColor.b, calculatedPercentage), helpers.lerp(firstColor.a, secondColor.a, calculatedPercentage)
        result = result .. "\a" .. helpers.rgba2hex(r, g, b, a) .. performingText:sub(i, i)
    end

    return result
end

helpers.contains = function(tbl, arg)
    for index, value in next, tbl do 
        if value == arg then 
            return true end 
        end 
    return false
end

helpers.vtable_entry = function(instance, index, type) 
    return ffi.cast(type, (ffi.cast("void***", instance)[0])[index]) 
end

helpers.vtable_bind = function(module, interface, index, typestring) 
    local instance = client.create_interface(module, interface) or error("invalid interface") 
    local fnptr = helpers.vtable_entry(instance, index, ffi.typeof(typestring)) or error("invalid vtable") 
    return function(...) 
        return fnptr(tonumber(ffi.cast("void***", instance)), ...) 
    end 
end

try = function(f, catch_f) 
    local status, exception = pcall(f) 
    if not status then 
        catch_f(exception) 
    end
end

local files = {}
files.native_GetGameDirectory = helpers.vtable_bind("engine.dll", "VEngineClient014", 36, "const char*(__thiscall*)(void*)")

files.full_filesystem = client.create_interface("filesystem_stdio.dll", "VFileSystem017")
files.full_filesystem_class = ffi.cast(ffi.typeof("void***"), files.full_filesystem)
files.full_filesystem_vftbl = files.full_filesystem_class[0]
files.func_remove_file = ffi.cast("void (__thiscall*)(void*, const char*, const char*)", files.full_filesystem_vftbl[20])

files.filesystem = client.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
files.filesystem_class = ffi.cast(ffi.typeof("void***"), files.filesystem)
files.filesystem_vftbl = files.filesystem_class[0]
files.func_read_file = ffi.cast("int (__thiscall*)(void*, void*, int, void*)", files.filesystem_vftbl[0])
files.func_write_file = ffi.cast("int (__thiscall*)(void*, void const*, int, void*)", files.filesystem_vftbl[1])
files.func_open_file = ffi.cast("void* (__thiscall*)(void*, const char*, const char*, const char*)", files.filesystem_vftbl[2])
files.func_close_file = ffi.cast("void (__thiscall*)(void*, void*)", files.filesystem_vftbl[3])
files.func_get_file_size = ffi.cast("unsigned int (__thiscall*)(void*, void*)", files.filesystem_vftbl[7])
files.func_file_exists = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", files.filesystem_vftbl[10])

files.filesystem_find = ffi.cast("void***", client.create_interface("filesystem_stdio.dll", "VFileSystem017"))
ffi.cdef([[
    typedef void (__thiscall* AddSearchPath)(void*, const char*, const char*);
    typedef void (__thiscall* RemoveSearchPaths)(void*, const char*);
    typedef const char* (__thiscall* FindNext)(void*, int);
    typedef bool (__thiscall* FindIsDirectory)(void*, int);
    typedef void (__thiscall* FindClose)(void*, int);
    typedef const char* (__thiscall* FindFirstEx)(void*, const char*, const char*, int*);
    typedef long (__thiscall* GetFileTime)(void*, const char*, const char*);
]])

files.add_search_path = ffi.cast("AddSearchPath", files.filesystem_find[0][11])
files.remove_search_paths = ffi.cast("RemoveSearchPaths", files.filesystem_find[0][14])
files.find_next = ffi.cast("FindNext", files.filesystem_find[0][33])
files.find_is_directory = ffi.cast("FindIsDirectory", files.filesystem_find[0][34])
files.find_close = ffi.cast("FindClose", files.filesystem_find[0][35])
files.find_first_ex = ffi.cast("FindFirstEx", files.filesystem_find[0][36])
files.get_file_time = ffi.cast("GetFileTime", files.filesystem_find[0][94])

files.open = function(file, mode, path_id) 
    return {    
            file = file, 
            mode = mode, 
            path_id = path_id, 
            handle = files.func_open_file(files.filesystem_class, file, mode, path_id)
        } 
end

files.exists = function(file, path_id) 
    return files.func_file_exists(files.filesystem_class, file, path_id) 
end

files.get_size = function(file) 
    return files.func_get_file_size(files.filesystem_class, file.handle) 
end

files.write = function(buffer, file) 
    files.func_write_file(files.filesystem_class, buffer, #buffer, file.handle) 
end

files.read = function(file) 
    local size = files.get_size(file) 
    local output = ffi.new("char[?]", size + 1) 
    files.func_read_file(files.filesystem_class, output, size, file.handle) 
    return ffi.string(output) 
end

files.close = function(file) 
    files.func_close_file(files.filesystem_class, file.handle) 
end

files.Read_GAME_File = function(file) 
    local p = files.open(file, "r", "GAME") 
    if files.exists(file, "GAME") then 
        local read = files.read(p) 
        files.close(p)  
        return read 
    end 
end

files.Write_GAME_File = function(file, info) 
    local p = files.open(file, "wb", "GAME") 
    files.write(info, p) 
    files.close(p) 
end

files.Delete_GAME_File = function(file) 
    files.func_remove_file(files.full_filesystem_class, file, "GAME") 
end

files.list_files = function(relative_path)
    local file_handle = ffi.new("int[1]")
    files.remove_search_paths(files.filesystem_find, "prim_temp")
    files.add_search_path(files.filesystem_find, relative_path, "prim_temp")

    local file_names = {}
    local file = files.find_first_ex(files.filesystem_find, "*", "prim_temp", file_handle)
    while file ~= nil do
        local file_name = ffi.string(file)
        if files.find_is_directory(files.filesystem_find, file_handle[0]) == false and file_name:find("black_sector_") and not file_name:find("banmdls[.]res") then
            local file_cfg = file_name:gsub("black_sector_", ""):gsub(".cfg", "")
            table.insert(file_names, file_cfg)
        end

        file = files.find_next(files.filesystem_find, file_handle[0])
    end

    files.find_close(files.filesystem_find, file_handle[0])

    return file_names
end

ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local VGUI_System010 =  client.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
local get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

local clipboard_import = function()
    local clipboard_text_length = get_clipboard_text_count(VGUI_System)
   
    if clipboard_text_length > 0 then
        local buffer = ffi.new("char[?]", clipboard_text_length)
        local size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
   
        get_clipboard_text(VGUI_System, 0, buffer, size )
   
        return ffi.string( buffer, clipboard_text_length-1)
    end

    return ""
end

local clipboard_export = function(string)
	if string then
		set_clipboard_text(VGUI_System, string, string:len())
	end
end

function new_notify(string, r, g, b, a)
    local screen = {client.screen_size()}
    screen.x = screen[1]
    screen.y = screen[2]
    local x,y = screen.x, screen.y
    local notification = {
        text = string,
        timer = globals.realtime(),
        color = { r, g, b, a },
        alpha = 0
    }

    if #notify_lol == 0 then
        notification.y = y + 20
    else
        local lastNotification = notify_lol[#notify_lol]
        notification.y = lastNotification.y + 20 
    end

    table.insert(notify_lol, notification)
end

new_notify("Welcome back! " .. obex_data.username, 255,255,255,255)

local menu = {}

local refs = {
    enabled = pui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = {pui.reference("AA", "Anti-aimbot angles", "Pitch")},
    yaw_base = pui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {pui.reference("AA", "Anti-aimbot angles", "Yaw")},
    yaw_jiiter = {pui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    body_yaw = {pui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    freestanding_body = pui.reference("AA", "Anti-aimbot angles", "Freestanding Body yaw"),
    edge_yaw = pui.reference("AA", "Anti-aimbot angles", "Edge Yaw"),
    freestanding = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    roll = pui.reference("AA", "Anti-aimbot angles", "Roll"),
    fakeduck = pui.reference("rage", "other", "duck peek assist"),
    slide = {ui.reference("AA","other","slow motion")},
    double_tap = {ui.reference('RAGE', 'Aimbot', 'Double tap')},
    hide_shots = {ui.reference('AA', 'Other', 'On shot anti-aim')},
    min_damage_override = {ui.reference('RAGE', 'Aimbot', 'Minimum damage override')},
    peek = {ui.reference('RAGE', 'Other', 'Quick peek assist')},
    dmg = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
}

menu.hide_default = function()
    ui.set_visible(refs.enabled.ref, false)
    ui.set_visible(refs.pitch[1].ref, false)
	ui.set_visible(refs.pitch[2].ref, false)
    ui.set_visible(refs.yaw_base.ref, false)
    ui.set_visible(refs.yaw[1].ref, false)
    ui.set_visible(refs.yaw[2].ref, false)
    ui.set_visible(refs.yaw_jiiter[1].ref, false)
    ui.set_visible(refs.yaw_jiiter[2].ref, false)
    ui.set_visible(refs.body_yaw[1].ref, false)
    ui.set_visible(refs.body_yaw[2].ref, false)
    ui.set_visible(refs.freestanding_body.ref, false) ui.set(refs.freestanding_body.ref, false)
    ui.set_visible(refs.edge_yaw.ref, false)
    ui.set_visible(refs.freestanding[1], false)
    ui.set_visible(refs.freestanding[2], false)
    ui.set_visible(refs.roll.ref, false)
end

menu.selected_tab = "global"
menu.group = pui.group("AA", "Anti-aimbot angles")

menu.name = menu.group:label(script_info.name .. " ~ " .. script_info.script_type:lower())
menu.user = menu.group:label("user: " .. obex_data.username)
menu.next_line1 = menu.group:label(" ")
menu.back_button = menu.group:button("Back", function() menu.selected_tab = "global" end)
menu.information_button = menu.group:button("Information", function() menu.selected_tab = "information" end)
menu.antiaim_button = menu.group:button("Anti-Aim", function() menu.selected_tab = "antiaim" end)
menu.visuals_button = menu.group:button("Visuals", function() menu.selected_tab = "visuals" end)
menu.misc_button = menu.group:button("Misc", function() menu.selected_tab = "misc" end)
menu.next_line2 = menu.group:label(" ")
menu.configs_button = menu.group:button("Configs", function() menu.selected_tab = "configs" end)
menu.tab = menu.group:combobox("hiiden", {"global", "information", "antiaim", "visuals", "misc", "configs"})

--information
menu.information = {}
menu.information.released = menu.group:label("Released ~ " .. script_info.released)
menu.information.last_update = menu.group:label("Last update ~ " .. script_info.last_update)
menu.information.script_type = menu.group:label("Script type ~ " .. script_info.script_type)
menu.information.version = menu.group:label("Version ~ " .. script_info.version)
menu.information.state = menu.group:label("State ~ " .. script_info.state)

--antiaim
menu.antiaim = {
    conditions = {[1] = "Stand", [2] = "Move", [3] = "Air", [4] = "Air-crouch", [5] = "Crouch", [6] = "Slowwalk"},
    conditions_small = {" ", "  ", "   ", "    ", "     ", "      "},
    tabs = {"Builder", "Keybinds", "Anti-Bruteforce"},
}

menu.antiaim.tab = menu.group:combobox("Tab", menu.antiaim.tabs)

menu.antiaim.keys = {
    freestanding = menu.group:hotkey("Freestanding"),
    freestanding_dis_aa = menu.group:checkbox("Disable anti-aim on freestanding", false),
    freestanding_disablers = menu.group:multiselect("Freestanding disablers", {"Stand", "Air", "Move"}),
    edge_yaw = menu.group:hotkey("Edge yaw"),
    manual_left = menu.group:hotkey("Manual left"),
    manual_right = menu.group:hotkey("Manual right"),
}

menu.antiaim.conditions = menu.group:combobox("Conditions", menu.antiaim.conditions)

for i = 1, 6 do
    menu.antiaim[i] = {
        pitch = menu.group:combobox("Pitch" .. menu.antiaim.conditions_small[i], {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"}),
        pitch_value = menu.group:slider("Pitch value" .. menu.antiaim.conditions_small[i], -89, 89, 0),

        yaw_base = menu.group:combobox("Yaw Base" .. menu.antiaim.conditions_small[i], {"Local view", "At targets"}),

        yaw_type = menu.group:combobox("Yaw Type" .. menu.antiaim.conditions_small[i], {"Off", "Static", "L & R", "Random"}),
        yaw = menu.group:slider("Yaw" .. menu.antiaim.conditions_small[i], -180, 180, 0),
        yaw_left = menu.group:slider("Left Yaw" .. menu.antiaim.conditions_small[i], -180, 180, 0),
        yaw_right = menu.group:slider("Right Yaw" .. menu.antiaim.conditions_small[i], -180, 180, 0),
        yaw_min = menu.group:slider("Min. Yaw" .. menu.antiaim.conditions_small[i], -180, 180, 0),
        yaw_max = menu.group:slider("Max. Yaw" .. menu.antiaim.conditions_small[i], -180, 180, 0),

        yaw_modifier = menu.group:combobox("Yaw modifier" .. menu.antiaim.conditions_small[i], {"Off", "Offset", "Center", "Random", "Skitter"}),
        yaw_modifier_range = menu.group:slider("Modifier range" .. menu.antiaim.conditions_small[i], -180, 180, 0),
        yaw_modifier_delay = menu.group:slider("Delay" .. menu.antiaim.conditions_small[i], 0, 20, 0),

        body_yaw = menu.group:combobox("Body yaw" .. menu.antiaim.conditions_small[i], {"Off", "Opposite", "Jitter", "Static"}),
        body_yaw_range = menu.group:slider("Body yaw range" .. menu.antiaim.conditions_small[i], -180, 180, 0),
        break_lby = menu.group:checkbox("Break LBY" .. menu.antiaim.conditions_small[i], false),

        defensive_break = menu.group:checkbox("Break defensive" .. menu.antiaim.conditions_small[i], false),
        break_type = menu.group:combobox("Break type" .. menu.antiaim.conditions_small[i], {"Always on", "Advanced"}),
        break_delay = menu.group:slider("Break delay" .. menu.antiaim.conditions_small[i], 0, 100, 0),

        defensive_antiaim = menu.group:checkbox("Defensive antiaim" .. menu.antiaim.conditions_small[i], false),

        defensive_pitch = menu.group:combobox("Defensive Pitch" .. menu.antiaim.conditions_small[i], {"Off", "Default", "Up", "Down", "Minimal", "Random"}),

        defensive_spin = menu.group:checkbox("Defensive spin" .. menu.antiaim.conditions_small[i], false),
        defensive_spin_range = menu.group:slider("Defensive spin range" .. menu.antiaim.conditions_small[i], -180, 180, 0),

        defensive_yaw_type = menu.group:combobox("Defensive Yaw Type" .. menu.antiaim.conditions_small[i], {"Off", "Static", "L & R", "Random"}),
        defensive_yaw = menu.group:slider("Defensive Yaw" .. menu.antiaim.conditions_small[i], -180, 180, 0),
        defensive_yaw_left = menu.group:slider("Defensive Left Yaw" .. menu.antiaim.conditions_small[i], -180, 180, 0),
        defensive_yaw_right = menu.group:slider("Defensive Right Yaw" .. menu.antiaim.conditions_small[i], -180, 180, 0),
        defensive_yaw_min = menu.group:slider("Defensive Min. Yaw" .. menu.antiaim.conditions_small[i], -180, 180, 0),
        defensive_yaw_max = menu.group:slider("Defensive Max. Yaw" .. menu.antiaim.conditions_small[i], -180, 180, 0),

        defensive_yaw_modifier = menu.group:combobox("Defensive Yaw modifier" .. menu.antiaim.conditions_small[i], {"Off", "Offset", "Center", "Random", "Skitter"}),
        defensive_yaw_modifier_range = menu.group:slider("Defensive Modifier range" .. menu.antiaim.conditions_small[i], -180, 180, 0),
    }
end

menu.antiaim.antibrute = {}
menu.antiaim.antibrute.phases = menu.group:slider("MEGA PRIVATE", 2, 10, 0)
ui.set_visible(menu.antiaim.antibrute.phases.ref, false)
menu.antiaim.antibrute.phases_list = { [2] = {"#1", "#2"}, [3] = {"#1", "#2", "#3"}, [4] = {"#1", "#2", "#3", "#4"}, [5] = {"#1", "#2", "#3", "#4", "#5"}, [6] = {"#1", "#2", "#3", "#4", "#5", "#6"}, [7] = {"#1", "#2", "#3", "#4", "#5", "#6", "#7"}, [8] = {"#1", "#2", "#3", "#4", "#5", "#6", "#7", "#8"}, [9] = {"#1", "#2", "#3", "#4", "#5", "#6", "#7", "#8", "#9"}, [10] = {"#1", "#2", "#3", "#4", "#5", "#6", "#7", "#8", "#9", "#10"}, }
menu.antiaim.antibrute.enable = menu.group:checkbox("Enable Anti-Bruteforce", false)
menu.antiaim.antibrute.list = menu.group:listbox("Phases", menu.antiaim.antibrute.phases_list[2])
menu.antiaim.antibrute.add_phase = menu.group:button('Add Phase', function() if ui.get(menu.antiaim.antibrute.phases.ref) == 10 then  new_notify("You cannot add more phases")  else  ui.set(menu.antiaim.antibrute.phases.ref, ui.get(menu.antiaim.antibrute.phases.ref) + 1) ui.update(menu.antiaim.antibrute.list.ref, menu.antiaim.antibrute.phases_list[menu.antiaim.antibrute.phases:get()]) end  end)
menu.antiaim.antibrute.remove_phase = menu.group:button('Remove Phase', function()  if ui.get(menu.antiaim.antibrute.phases.ref) == 2 then  new_notify("You cannot delete more phases")  else  ui.set(menu.antiaim.antibrute.phases.ref, ui.get(menu.antiaim.antibrute.phases.ref) - 1) ui.update(menu.antiaim.antibrute.list.ref, menu.antiaim.antibrute.phases_list[menu.antiaim.antibrute.phases:get()]) end  end)

for i = 1, 10 do
    local add = "[" .. i .. "] -> "
    menu.antiaim.antibrute[i] = {
        yaw = menu.group:slider(add .. "Yaw", -180, 180, 0),
        modifier_add = menu.group:slider(add .. "Modifier Degree ", -180, 180, 0),
    }
end

for i = 1, 10 do
    menu.antiaim.antibrute[i].yaw:depend({menu.tab, "antiaim"}, {menu.antiaim.tab, "Anti-Bruteforce"}, {menu.antiaim.antibrute.enable, true}, {menu.antiaim.antibrute.list, i-1})
    menu.antiaim.antibrute[i].modifier_add:depend({menu.tab, "antiaim"}, {menu.antiaim.tab, "Anti-Bruteforce"}, {menu.antiaim.antibrute.enable, true}, {menu.antiaim.antibrute.list, i-1})
end

--visuals
menu.visuals = {}
menu.visuals.watermark = menu.group:checkbox("Watermark", {245, 102, 73, 255})
menu.visuals.indicators = menu.group:checkbox("Indicators", false)
menu.visuals.defensive_manager = menu.group:checkbox("Defensive manager", false)
menu.visuals.logs = menu.group:checkbox("Logs", {245, 102, 73, 255})
menu.visuals.arrows = menu.group:checkbox("Arrows", {245, 102, 73, 255})
menu.visuals.arrows_type = menu.group:combobox("Arrows Type", {"Standart", "Teamskeet", "Velocity"})
menu.visuals.debug_box = menu.group:checkbox("Debug Box", {245, 102, 73, 255})
menu.visuals.min_indicator = menu.group:checkbox("Minimum damage indicator", false)

--misc
menu.misc = {}
menu.misc.lagcomp_ind = menu.group:checkbox("Lagcomp indicator", false)
menu.misc.resolver_helper = menu.group:checkbox("Resolver Helper", false)
menu.misc.resolver_type = menu.group:combobox("Resolver Type", {"New", "Old"})
menu.misc.last_backtrack = menu.group:checkbox("Last backtrack tick", false)
menu.misc.anim_breakers = menu.group:multiselect("Anim. Breakers", {"Jitter legs on run", "Static legs in air"})
menu.misc.safehead = menu.group:checkbox("Safe Head", false)
menu.misc.antibackstab = menu.group:checkbox("Antibackstab", false)
menu.misc.fastladder = menu.group:checkbox("Fast Ladder", false)
menu.misc.trashtalk = menu.group:checkbox("Trashtalk", false)
menu.misc.clantag = menu.group:checkbox("Clantag", false)

--configs
menu.configs = {}

local config_items = {
    menu.antiaim[1],
    menu.antiaim[2],
    menu.antiaim[3],
    menu.antiaim[4],
    menu.antiaim[5],
    menu.antiaim[6],
    menu.visuals,
    menu.misc,
    --menu.antiaim.antibrute,
    menu.antiaim.antibrute[1],
    menu.antiaim.antibrute[2],
    menu.antiaim.antibrute[3],
    menu.antiaim.antibrute[4],
    menu.antiaim.antibrute[5],
    menu.antiaim.antibrute[6],
    menu.antiaim.antibrute[7],
    menu.antiaim.antibrute[8],
    menu.antiaim.antibrute[9],
    menu.antiaim.antibrute[10],
}

local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""

menu.configs.export_fun = function()
    data = package:save()
    encrypted = base64.encode(json.stringify(data))
    clipboard_export(encrypted)
end

menu.configs.export_ = function()
    data = package:save()
    encrypted = base64.encode(json.stringify(data))
    return encrypted
end

menu.configs.import_fun = function(input)
    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard_import()))
    package:load(decrypted)
end

menu.configs.cfg_pose_text = menu.group:label("The configs are in the 'csgo' folder")
menu.configs.list = menu.group:listbox("List", files.list_files("csgo"), 10)
menu.configs.text_input_create = menu.group:textbox("Name", "Name")
menu.configs.refresh = menu.group:button("Refresh", function()
    ui.update(menu.configs.list.ref, files.list_files("csgo"))
end)

menu.configs.create_cfg = menu.group:button("Create", function()
    local name = ui.get(menu.configs.text_input_create.ref)
    files.Write_GAME_File("black_sector_" .. tostring(name) .. ".cfg", menu.configs.export_())
    ui.update(menu.configs.list.ref, files.list_files("csgo"))
    new_notify('Config created!')
    client.exec("play ui\\beepclear")
end)

menu.configs.delete = menu.group:button("Delete", function()
    files.Delete_GAME_File("black_sector_" .. files.list_files("csgo")[ui.get(menu.configs.list.ref)] .. ".cfg")
    ui.update(menu.configs.list.ref, files.list_files("csgo"))
    new_notify('Config removed!')
    client.exec("play ui\\beepclear")
end)

menu.configs.copy_cfg = menu.group:button("Copy", function()
    local cfg = files.Read_GAME_File("black_sector_" .. files.list_files("csgo")[ui.get(menu.configs.list.ref)] .. ".cfg")
    clipboard_export(cfg_c)
    ui.update(menu.configs.list.ref, files.list_files("csgo"))
    new_notify("Config copied!")
    client.exec("play ui\\beepclear")
end)

menu.configs.save_cfg = menu.group:button("Save", function()
    files.Write_GAME_File("black_sector_" .. files.list_files("csgo")[ui.get(menu.configs.list.ref)] .. ".cfg", menu.configs.export_())
    ui.update(menu.configs.list.ref, files.list_files("csgo"))
    new_notify("Config saved!")
    client.exec("play ui\\beepclear")
end)

menu.configs.load_cfg = menu.group:button("Load", function()
    try(function() menu.configs.import_fun(files.Read_GAME_File("black_sector_" .. files.list_files("csgo")[ui.get(menu.configs.list.ref) + 1] .. ".cfg")) end, function(e) new_notify('Your config is incorrect') client.exec("play resource/warning.wav") end)
    ui.update(menu.configs.list.ref, files.list_files("csgo"))
    client.exec("play ui\\beepclear")
end)

menu.configs.skip = menu.group:label(" ")
menu.configs.export = menu.group:button("Export", function() menu.configs.export_fun() new_notify("Config exported!") end)
menu.configs.import = menu.group:button("Import", function() menu.configs.import_fun() new_notify("Config imported!") end)
menu.configs.default = menu.group:button("Default cfg", function() menu.configs.import_fun("W3siYnJlYWtfdHlwZSI6IkFsd2F5cyBvbiIsInlhd190eXBlIjoiTCAmIFIiLCJwaXRjaCI6Ik1pbmltYWwiLCJib2R5X3lhdyI6IkppdHRlciIsInlhd19tYXgiOjAsImRlZmVuc2l2ZV9waXRjaCI6IlJhbmRvbSIsImRlZmVuc2l2ZV9hbnRpYWltIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19tYXgiOjAsImJvZHlfeWF3X3JhbmdlIjotMSwiZGVmZW5zaXZlX3lhd19sZWZ0IjowLCJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJkZWZlbnNpdmVfeWF3X21vZGlmaWVyIjoiT2ZmIiwiZGVmZW5zaXZlX3lhdyI6MCwieWF3X2xlZnQiOjE5LCJkZWZlbnNpdmVfeWF3X21vZGlmaWVyX3JhbmdlIjoxNiwieWF3IjowLCJkZWZlbnNpdmVfeWF3X21pbiI6MCwiZGVmZW5zaXZlX3lhd190eXBlIjoiT2ZmIiwieWF3X21pbiI6MCwieWF3X21vZGlmaWVyX2RlbGF5IjowLCJ5YXdfbW9kaWZpZXJfcmFuZ2UiOjM0LCJkZWZlbnNpdmVfYnJlYWsiOmZhbHNlLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfcmlnaHQiOi01LCJkZWZlbnNpdmVfeWF3X3JpZ2h0IjowfSx7ImJyZWFrX3R5cGUiOiJBbHdheXMgb24iLCJ5YXdfdHlwZSI6IkwgJiBSIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXdfbWF4IjowLCJkZWZlbnNpdmVfcGl0Y2giOiJEb3duIiwiZGVmZW5zaXZlX2FudGlhaW0iOmZhbHNlLCJkZWZlbnNpdmVfeWF3X21heCI6MCwiYm9keV95YXdfcmFuZ2UiOi0xLCJkZWZlbnNpdmVfeWF3X2xlZnQiOjAsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsImRlZmVuc2l2ZV95YXdfbW9kaWZpZXIiOiJPZmYiLCJkZWZlbnNpdmVfeWF3IjowLCJ5YXdfbGVmdCI6MTksImRlZmVuc2l2ZV95YXdfbW9kaWZpZXJfcmFuZ2UiOjE2LCJ5YXciOjAsImRlZmVuc2l2ZV95YXdfbWluIjowLCJkZWZlbnNpdmVfeWF3X3R5cGUiOiJPZmYiLCJ5YXdfbWluIjowLCJ5YXdfbW9kaWZpZXJfZGVsYXkiOjUsInlhd19tb2RpZmllcl9yYW5nZSI6MTAyLCJkZWZlbnNpdmVfYnJlYWsiOmZhbHNlLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfcmlnaHQiOi01LCJkZWZlbnNpdmVfeWF3X3JpZ2h0IjowfSx7ImJyZWFrX3R5cGUiOiJBZHZhbnNlZCIsInlhd190eXBlIjoiU3RhdGljIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXdfbWF4IjowLCJkZWZlbnNpdmVfcGl0Y2giOiJVcCIsImRlZmVuc2l2ZV9hbnRpYWltIjp0cnVlLCJkZWZlbnNpdmVfeWF3X21heCI6MCwiYm9keV95YXdfcmFuZ2UiOi0xLCJkZWZlbnNpdmVfeWF3X2xlZnQiOi0xMDIsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsImRlZmVuc2l2ZV95YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJkZWZlbnNpdmVfeWF3IjowLCJ5YXdfbGVmdCI6MTksImRlZmVuc2l2ZV95YXdfbW9kaWZpZXJfcmFuZ2UiOjI1LCJ5YXciOjAsImRlZmVuc2l2ZV95YXdfbWluIjowLCJkZWZlbnNpdmVfeWF3X3R5cGUiOiJMICYgUiIsInlhd19taW4iOjAsInlhd19tb2RpZmllcl9kZWxheSI6MCwieWF3X21vZGlmaWVyX3JhbmdlIjozNCwiZGVmZW5zaXZlX2JyZWFrIjp0cnVlLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfcmlnaHQiOi01LCJkZWZlbnNpdmVfeWF3X3JpZ2h0Ijo5MH0seyJicmVha190eXBlIjoiQWR2YW5zZWQiLCJ5YXdfdHlwZSI6IkwgJiBSIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXdfbWF4IjowLCJkZWZlbnNpdmVfcGl0Y2giOiJEZWZhdWx0IiwiZGVmZW5zaXZlX2FudGlhaW0iOmZhbHNlLCJkZWZlbnNpdmVfeWF3X21heCI6MCwiYm9keV95YXdfcmFuZ2UiOjM5LCJkZWZlbnNpdmVfeWF3X2xlZnQiOjAsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsImRlZmVuc2l2ZV95YXdfbW9kaWZpZXIiOiJTa2l0dGVyIiwiZGVmZW5zaXZlX3lhdyI6MCwieWF3X2xlZnQiOjE5LCJkZWZlbnNpdmVfeWF3X21vZGlmaWVyX3JhbmdlIjoxNiwieWF3IjowLCJkZWZlbnNpdmVfeWF3X21pbiI6MCwiZGVmZW5zaXZlX3lhd190eXBlIjoiTCAmIFIiLCJ5YXdfbWluIjowLCJ5YXdfbW9kaWZpZXJfZGVsYXkiOjAsInlhd19tb2RpZmllcl9yYW5nZSI6NDAsImRlZmVuc2l2ZV9icmVhayI6dHJ1ZSwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwieWF3X3JpZ2h0IjotNSwiZGVmZW5zaXZlX3lhd19yaWdodCI6MH0seyJicmVha190eXBlIjoiQWx3YXlzIG9uIiwieWF3X3R5cGUiOiJMICYgUiIsInBpdGNoIjoiTWluaW1hbCIsImJvZHlfeWF3IjoiSml0dGVyIiwieWF3X21heCI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiVXAiLCJkZWZlbnNpdmVfYW50aWFpbSI6dHJ1ZSwiZGVmZW5zaXZlX3lhd19tYXgiOjAsImJvZHlfeWF3X3JhbmdlIjotMSwiZGVmZW5zaXZlX3lhd19sZWZ0Ijo5MywieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwiZGVmZW5zaXZlX3lhd19tb2RpZmllciI6IkNlbnRlciIsImRlZmVuc2l2ZV95YXciOjAsInlhd19sZWZ0IjoxOSwiZGVmZW5zaXZlX3lhd19tb2RpZmllcl9yYW5nZSI6MTYsInlhdyI6MCwiZGVmZW5zaXZlX3lhd19taW4iOjAsImRlZmVuc2l2ZV95YXdfdHlwZSI6IkwgJiBSIiwieWF3X21pbiI6MCwieWF3X21vZGlmaWVyX2RlbGF5IjowLCJ5YXdfbW9kaWZpZXJfcmFuZ2UiOjM0LCJkZWZlbnNpdmVfYnJlYWsiOnRydWUsInlhd19tb2RpZmllciI6IlNraXR0ZXIiLCJ5YXdfcmlnaHQiOi01LCJkZWZlbnNpdmVfeWF3X3JpZ2h0IjotOTF9LHsiYnJlYWtfdHlwZSI6IkFsd2F5cyBvbiIsInlhd190eXBlIjoiTCAmIFIiLCJwaXRjaCI6Ik1pbmltYWwiLCJib2R5X3lhdyI6IkppdHRlciIsInlhd19tYXgiOjAsImRlZmVuc2l2ZV9waXRjaCI6IlJhbmRvbSIsImRlZmVuc2l2ZV9hbnRpYWltIjp0cnVlLCJkZWZlbnNpdmVfeWF3X21heCI6MCwiYm9keV95YXdfcmFuZ2UiOi0xLCJkZWZlbnNpdmVfeWF3X2xlZnQiOi0xODAsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsImRlZmVuc2l2ZV95YXdfbW9kaWZpZXIiOiJTa2l0dGVyIiwiZGVmZW5zaXZlX3lhdyI6MCwieWF3X2xlZnQiOjE5LCJkZWZlbnNpdmVfeWF3X21vZGlmaWVyX3JhbmdlIjoxNiwieWF3IjowLCJkZWZlbnNpdmVfeWF3X21pbiI6MCwiZGVmZW5zaXZlX3lhd190eXBlIjoiTCAmIFIiLCJ5YXdfbWluIjowLCJ5YXdfbW9kaWZpZXJfZGVsYXkiOjAsInlhd19tb2RpZmllcl9yYW5nZSI6MzQsImRlZmVuc2l2ZV9icmVhayI6dHJ1ZSwieWF3X21vZGlmaWVyIjoiU2tpdHRlciIsInlhd19yaWdodCI6LTUsImRlZmVuc2l2ZV95YXdfcmlnaHQiOi01fV0=") end)

menu.gradient_texts = function()
    ui.set(menu.name.ref, helpers.calculateGradient(script_info.name .. " ~ " .. script_info.script_type:lower(), {color(255,255,255), color(230, 0, 0)}, 1))
    ui.set(menu.user.ref, helpers.calculateGradient("User: " .. obex_data.username, {color(255,255,255), color(230, 0, 0)}, 1))
end

menu.set_visibles_custom = function()
    ui.set_visible(menu.tab.ref, false)
    ui.set(menu.tab.ref, menu.selected_tab)
    ui.set_visible(menu.back_button.ref, menu.selected_tab ~= "global")
    ui.set_visible(menu.information_button.ref, menu.selected_tab == "global")
    ui.set_visible(menu.antiaim_button.ref, menu.selected_tab == "global")
    ui.set_visible(menu.visuals_button.ref, menu.selected_tab == "global")
    ui.set_visible(menu.misc_button.ref, menu.selected_tab == "global")
    ui.set_visible(menu.configs_button.ref, menu.selected_tab == "global")
    ui.set_visible(menu.next_line1.ref, menu.selected_tab == "global")
    ui.set_visible(menu.next_line2.ref, menu.selected_tab == "global")

    --info 
    ui.set_visible(menu.information.released.ref, menu.selected_tab == "information")
    ui.set_visible(menu.information.last_update.ref, menu.selected_tab == "information")
    ui.set_visible(menu.information.script_type.ref, menu.selected_tab == "information")
    ui.set_visible(menu.information.version.ref, menu.selected_tab == "information")
    ui.set_visible(menu.information.state.ref, menu.selected_tab == "information")

    --antiaim
    ui.set_visible(menu.antiaim.tab.ref, menu.selected_tab == "antiaim")
    local b = ui.get(menu.antiaim.tab.ref) == "Builder"
    local k = ui.get(menu.antiaim.tab.ref) == "Keybinds"

    ui.set_visible(menu.antiaim.keys.freestanding.ref, (menu.selected_tab == "antiaim" and k))
    ui.set_visible(menu.antiaim.keys.freestanding_dis_aa.ref, (menu.selected_tab == "antiaim" and k))
    ui.set_visible(menu.antiaim.keys.freestanding_disablers.ref, (menu.selected_tab == "antiaim" and k))
    ui.set_visible(menu.antiaim.keys.edge_yaw.ref, (menu.selected_tab == "antiaim" and k))
    ui.set_visible(menu.antiaim.keys.manual_left.ref, (menu.selected_tab == "antiaim" and k))
    ui.set_visible(menu.antiaim.keys.manual_right.ref, (menu.selected_tab == "antiaim" and k))

    ui.set_visible(menu.antiaim.conditions.ref, (menu.selected_tab == "antiaim" and b))
    local cond = ui.get(menu.antiaim.conditions.ref)
    local conditions = {[1] = "Stand", [2] = "Move", [3] = "Air", [4] = "Air-crouch", [5] = "Crouch", [6] = "Slowwalk"}
    for i = 1, 6 do
        local cond_check = conditions[i] == cond
        ui.set_visible(menu.antiaim[i].pitch.ref, (menu.selected_tab == "antiaim" and cond_check and b))
        ui.set_visible(menu.antiaim[i].pitch_value.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].pitch.ref) == "Custom"))
        ui.set_visible(menu.antiaim[i].yaw_base.ref, (menu.selected_tab == "antiaim" and cond_check and b))
        ui.set_visible(menu.antiaim[i].yaw_type.ref, (menu.selected_tab == "antiaim" and cond_check and b))
        ui.set_visible(menu.antiaim[i].yaw.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].yaw_type.ref) == "Static"))
        ui.set_visible(menu.antiaim[i].yaw_left.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].yaw_type.ref) == "L & R"))
        ui.set_visible(menu.antiaim[i].yaw_right.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].yaw_type.ref) == "L & R"))
        ui.set_visible(menu.antiaim[i].yaw_min.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].yaw_type.ref) == "Random"))
        ui.set_visible(menu.antiaim[i].yaw_max.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].yaw_type.ref) == "Random"))
        ui.set_visible(menu.antiaim[i].yaw_modifier.ref, (menu.selected_tab == "antiaim" and cond_check and b))
        ui.set_visible(menu.antiaim[i].yaw_modifier_range.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].yaw_modifier.ref) ~= "Off"))
        ui.set_visible(menu.antiaim[i].yaw_modifier_delay.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].yaw_modifier.ref) == "Center"))
        ui.set_visible(menu.antiaim[i].body_yaw.ref, (menu.selected_tab == "antiaim" and cond_check and b))
        ui.set_visible(menu.antiaim[i].body_yaw_range.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].body_yaw.ref) ~= "Opposite" and ui.get(menu.antiaim[i].body_yaw.ref) ~= "Off"))
        ui.set_visible(menu.antiaim[i].break_lby.ref, (menu.selected_tab == "antiaim" and cond_check and b))
        ui.set_visible(menu.antiaim[i].defensive_break.ref, (menu.selected_tab == "antiaim" and cond_check and b))
        ui.set_visible(menu.antiaim[i].break_type.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_break.ref)))
        ui.set_visible(menu.antiaim[i].break_delay.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_break.ref)))
    
        ui.set_visible(menu.antiaim[i].defensive_antiaim.ref, (menu.selected_tab == "antiaim" and cond_check and b))
        ui.set_visible(menu.antiaim[i].defensive_pitch.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_antiaim.ref)))
        ui.set_visible(menu.antiaim[i].defensive_spin.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_antiaim.ref)))
        ui.set_visible(menu.antiaim[i].defensive_spin_range.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_antiaim.ref) and ui.get(menu.antiaim[i].defensive_spin.ref)))
        ui.set_visible(menu.antiaim[i].defensive_yaw_type.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_antiaim.ref) and ui.get(menu.antiaim[i].defensive_spin.ref) == false))
        ui.set_visible(menu.antiaim[i].defensive_yaw.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_yaw_type.ref) == "Static" and ui.get(menu.antiaim[i].defensive_antiaim.ref) and ui.get(menu.antiaim[i].defensive_spin.ref) == false))
        ui.set_visible(menu.antiaim[i].defensive_yaw_left.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_yaw_type.ref) == "L & R" and ui.get(menu.antiaim[i].defensive_antiaim.ref) and ui.get(menu.antiaim[i].defensive_spin.ref) == false))
        ui.set_visible(menu.antiaim[i].defensive_yaw_right.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_yaw_type.ref) == "L & R" and ui.get(menu.antiaim[i].defensive_antiaim.ref) and ui.get(menu.antiaim[i].defensive_spin.ref) == false))
        ui.set_visible(menu.antiaim[i].defensive_yaw_min.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_yaw_type.ref) == "Random" and ui.get(menu.antiaim[i].defensive_antiaim.ref) and ui.get(menu.antiaim[i].defensive_spin.ref) == false))
        ui.set_visible(menu.antiaim[i].defensive_yaw_max.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_yaw_type.ref) == "Random" and ui.get(menu.antiaim[i].defensive_antiaim.ref) and ui.get(menu.antiaim[i].defensive_spin.ref) == false))
        ui.set_visible(menu.antiaim[i].defensive_yaw_modifier.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_antiaim.ref)))
        ui.set_visible(menu.antiaim[i].defensive_yaw_modifier_range.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_yaw_modifier.ref) ~= "Off" and ui.get(menu.antiaim[i].defensive_antiaim.ref)))
    end

    --visuals
    ui.set_visible(menu.visuals.indicators.ref, menu.selected_tab == "visuals")
    ui.set_visible(menu.visuals.logs.ref, menu.selected_tab == "visuals")
    ui.set_visible(menu.visuals.arrows_type.ref, menu.selected_tab == "visuals" and ui.get(menu.visuals.arrows.ref))
    ui.set_visible(menu.visuals.defensive_manager.ref, menu.selected_tab == "visuals")
    ui.set_visible(menu.visuals.min_indicator.ref, menu.selected_tab == "visuals")
    
    --misc
    ui.set_visible(menu.misc.lagcomp_ind.ref, menu.selected_tab == "misc")
    ui.set_visible(menu.misc.last_backtrack.ref, menu.selected_tab == "misc")
    ui.set_visible(menu.misc.resolver_helper.ref, menu.selected_tab == "misc")
    ui.set_visible(menu.misc.resolver_type.ref, menu.selected_tab == "misc" and ui.get(menu.misc.resolver_helper.ref))
    ui.set_visible(menu.misc.anim_breakers.ref, menu.selected_tab == "misc")
    ui.set_visible(menu.misc.safehead.ref, menu.selected_tab == "misc")
    ui.set_visible(menu.misc.antibackstab.ref, menu.selected_tab == "misc")
    ui.set_visible(menu.misc.fastladder.ref, menu.selected_tab == "misc")
    ui.set_visible(menu.misc.trashtalk.ref, menu.selected_tab == "misc")
    ui.set_visible(menu.misc.clantag.ref, menu.selected_tab == "misc")

    --configs
    ui.set_visible(menu.configs.cfg_pose_text.ref, menu.selected_tab == "configs")
    ui.set_visible(menu.configs.text_input_create.ref, menu.selected_tab == "configs")
    ui.set_visible(menu.configs.refresh.ref, menu.selected_tab == "configs")
    ui.set_visible(menu.configs.create_cfg.ref, menu.selected_tab == "configs" and ui.get(menu.configs.text_input_create.ref) ~= "")
    ui.set_visible(menu.configs.delete.ref, menu.selected_tab == "configs" and ui.get(menu.configs.text_input_create.ref) == "")
    ui.set_visible(menu.configs.copy_cfg.ref, menu.selected_tab == "configs" and ui.get(menu.configs.text_input_create.ref) == "")
    ui.set_visible(menu.configs.save_cfg.ref, menu.selected_tab == "configs" and ui.get(menu.configs.text_input_create.ref) == "")
    ui.set_visible(menu.configs.load_cfg.ref, menu.selected_tab == "configs" and ui.get(menu.configs.text_input_create.ref) == "")
    ui.set_visible(menu.configs.skip.ref, menu.selected_tab == "configs")
    ui.set_visible(menu.configs.export.ref, menu.selected_tab == "configs")
    ui.set_visible(menu.configs.import.ref, menu.selected_tab == "configs")
    ui.set_visible(menu.configs.default.ref, menu.selected_tab == "configs")
end

menu.configs.list:depend({menu.tab, "configs"})
menu.visuals.logs:depend({menu.tab, "visuals"})
menu.visuals.arrows:depend({menu.tab, "visuals"})
menu.visuals.debug_box:depend({menu.tab, "visuals"})
menu.visuals.watermark:depend({menu.tab, "visuals"})
menu.antiaim.antibrute.enable:depend({menu.tab, "antiaim"}, {menu.antiaim.tab, "Anti-Bruteforce"})
menu.antiaim.antibrute.list:depend({menu.tab, "antiaim"}, {menu.antiaim.tab, "Anti-Bruteforce"}, {menu.antiaim.antibrute.enable, true})
menu.antiaim.antibrute.add_phase:depend({menu.tab, "antiaim"}, {menu.antiaim.tab, "Anti-Bruteforce"}, {menu.antiaim.antibrute.enable, true})
menu.antiaim.antibrute.remove_phase:depend({menu.tab, "antiaim"}, {menu.antiaim.tab, "Anti-Bruteforce"}, {menu.antiaim.antibrute.enable, true})

--Antiaim
local antiaim = {}

function get_velocity()
    if not entity.get_local_player() then return end
    local first_velocity, second_velocity = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
    
    return speed
end

local ground_tick = 1
antiaim.get_state_name = function(speed)
    if not entity.is_alive(entity.get_local_player()) then return end
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    if land == true then ground_tick = ground_tick + 1 else ground_tick = 0 end

    if bit.band(flags, 1) == 1 then
        if ground_tick < 10 then if bit.band(flags, 4) == 4 then return "Air-c" else return "Air" end end
        if bit.band(flags, 4) == 4 or ui.get(refs.fakeduck.ref) then 
            return "Crouch"
        else
            if speed <= 3 then
                return "Stand"
            else
                if ui.get(refs.slide[2]) then
                    return "Slow"
                else
                    return "Move"
                end
            end
        end
    elseif bit.band(flags, 1) == 0 then
        if bit.band(flags, 4) == 4 then
            return "Air-c"
        else
            return "Air"
        end
    end
end

antiaim.get_state = function()
    local state_name = antiaim.get_state_name(get_velocity())
    if state_name == "Stand" then
        return 1
    elseif state_name == "Move" then
        return 2
    elseif state_name == "Air" then
        return 3
    elseif state_name == "Air-c" then
        return 4
    elseif state_name == "Crouch" then
        return 5
    elseif state_name == "Slow" then
        return 6
    end
end

local last_sim_time = 0
local defensive_until = 0
antiaim.is_defensive_active = function()
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
    end

    last_sim_time = sim_time

    return defensive_until > tickcount
end

antiaim.aa_list = {
    pitch = "",
    yaw_base = "",
    yaw = "180",
    yaw_add = 0,
    yaw_modifier = "",
    yaw_modifier_degree = 0,
    body_yaw = "",
    body_yaw_range = 0,
    defensive_break = false,
    defensive_break_type = "",
}

local m_iSide = 0
local last_press_t = 0
antiaim.manuals = function()
    m_iSide = 0
    if ui.get(menu.antiaim.keys.manual_left.ref) then
        m_iSide = 1
        if ui.get(menu.antiaim.keys.manual_right.ref) then
            ui.set(menu.antiaim.keys.manual_left.ref, false)
            m_iSide = 2
        end
    end
    if ui.get(menu.antiaim.keys.manual_right.ref) then
        m_iSide = 2
        if ui.get(menu.antiaim.keys.manual_left.ref) then
            ui.set(menu.antiaim.keys.manual_right.ref, false)
            m_iSide = 1
        end
    end

    return m_iSide
end

local get_side_help = false
antiaim.get_side = function(delay, lp)
    if delay == nil or delay == 0 then
        return (entity.get_prop(lp,"m_flPoseParameter",11) * 120 - 60) > 0
    else
        if globals.tickcount() % delay == 0 then
            get_side_help = not get_side_help
        end
        return get_side_help
    end
end

antiaim.ent_state = {
    speed = function(ent) local speed = math.sqrt(math.pow(entity.get_prop(ent, "m_vecVelocity[0]"), 2) + math.pow(entity.get_prop(ent, "m_vecVelocity[1]"), 2)) return speed end,
    is_peeking = function() return (ui.get(refs.peek[1]) and ui.get(refs.peek[2])) end,
    is_ladder = function(ent) return (entity.get_prop(ent, "m_MoveType") or 0) == 9 end
}


antiaim.micro_move = function(cmd)
    local local_player = entity.get_local_player()
    if cmd.chokedcommands == 0 or antiaim.ent_state.speed(local_player) > 2 or antiaim.ent_state.is_peeking() or cmd.in_attack == 1 then return end
    cmd.forwardmove = 0.1
    cmd.in_forward = 1
end

antiaim.desync_func = function(cmd, body_side)
    local local_player = entity.get_local_player()
    if antiaim.ent_state.is_ladder(local_player) then return end

    antiaim.micro_move(cmd)

    if cmd.chokedcommands == 0 and cmd.in_attack ~= 1 then
        body_side = body_side and -60 or 60
        cmd.yaw = cmd.yaw - body_side
        cmd.allow_send_packet = false
    end
end

math.closest_point_on_ray = function(ray_from, ray_to, desired_point) 
    local to = {x = desired_point[1] - ray_from[1], y = desired_point[2] - ray_from[2], z = desired_point[3] - ray_from[3]} 
    local direction = {x = ray_to.x - ray_from[1], y = ray_to.y - ray_from[2], z = ray_to.z - ray_from[3]} 
    local ray_length = #direction direction.x = direction.x / ray_length direction.y = direction.y / ray_length direction.z = direction.z / ray_length 
    local direction_along = direction.x * to.x + direction.y * to.y + direction.z * to.z 
    if direction_along < 0 then 
        return ray_from
    end 
    if direction_along > ray_length then 
        return ray_to 
    end 

    return vector(ray_from[1] + direction.x * direction_along, ray_from[2] + direction.y * direction_along, ray_from[3] + direction.z * direction_along) 
end

math.dist_to = function(pos1, pos2) 
    local dx = pos1.x - pos2[1]
    local dy = pos1.y - pos2[2]
    local dz = pos1.z - pos2[3]
    return math.sqrt(dx * dx + dy * dy + dz * dz) 
end

local last_switch_tick = 0
antiaim.cur_phase = 0
antiaim.antibrute = function(e)
    if ui.get(menu.antiaim.antibrute.enable.ref) == false then return end
    local local_player = entity.get_local_player()
    if local_player == nil or not entity.is_alive(local_player) or e.userid == nil then return end
    local enemy = client.userid_to_entindex(e.userid)
    if enemy == nil or entity.is_alive(enemy) == false or entity.is_dormant(enemy) == true or entity.is_enemy(enemy) == false then return end
    
    local bullet_impact = vector(e.x, e.y, e.z)
    local eye_pos = {entity.hitbox_position(enemy, 0)}
    if not eye_pos then
        return
    end

    local local_eye_pos = {client.eye_position()}
    if not local_eye_pos then
        return
    end

    local distance_between = math.dist_to(math.closest_point_on_ray(eye_pos, bullet_impact, local_eye_pos), local_eye_pos)
    if distance_between < 250 and globals.tickcount() > last_switch_tick+5 then
        antiaim.timer = 7
        antiaim.working = true
        antiaim.cur_phase = antiaim.cur_phase + 1
        if cur_phase == 11 then antiaim.cur_phase = 0 end
        last_switch_tick = globals.tickcount()
        new_notify("Switched anti-bruteforce due to enemy shot")
    end
end

client.set_event_callback('bullet_impact', antiaim.antibrute)

antiaim.antibrute_restart = function()
    antiaim.timer = 0 
    new_notify("Switched anti-bruteforce due to round start")
end

client.set_event_callback('round_start', antiaim.antibrute_restart)

antiaim.abrute_pred = function()
    if not antiaim.working then return end
    if ui.get(menu.antiaim.antibrute.enable.ref) == false then antiaim.cur_phase = 0 return end
    
    antiaim.timer = antiaim.timer - globals.tickinterval()

    if antiaim.timer < 0 then antiaim.timer = 0 end
    if antiaim.timer == 0 and antiaim.working then new_notify("Switched anti-bruteforce due to reset") antiaim.working = false end
    
    if not antiaim.working then
        antiaim.cur_phase = 0
    end

    if antiaim.cur_phase == ui.get(menu.antiaim.antibrute.phases.ref) + 1 then antiaim.cur_phase = 1 end
end

antiaim.side = "none"
antiaim.main = function(cmd)
    antiaim.abrute_pred()
    local lp = entity.get_local_player()
    if not entity.is_alive(lp) then return end
    local players = entity.get_players(true)
    local i = antiaim.get_state()
    local player_weapon = entity.get_classname(entity.get_player_weapon(lp))

    antiaim.side = antiaim.get_side(ui.get(menu.antiaim[i].yaw_modifier_delay.ref), lp)
    if ui.get(menu.antiaim[i].break_lby.ref) then
        if player_weapon == "CIncendiaryGrenade" or player_weapon == "CHEGrenade" or player_weapon == "CSmokeGrenade" or player_weapon == "CFlashbang" or player_weapon == "CDecoyGrenade" then
        else
            antiaim.desync_func(cmd, antiaim.side)
        end
    end
    antiaim.side = antiaim.side and "right" or "left"

    if ui.get(menu.antiaim[i].defensive_break.ref) then
        if ui.get(menu.antiaim[i].break_type.ref) == "Always on" then
            if ui.get(menu.antiaim[i].break_delay.ref) ~= 0 then
                if globals.tickcount() % ui.get(menu.antiaim[i].break_delay.ref) == 0 then
                    cmd.force_defensive = true
                end
            else
                cmd.force_defensive = true
            end
        elseif ui.get(menu.antiaim[i].break_type.ref) == "Advansed" then
            if ui.get(menu.antiaim[i].break_delay.ref) ~= 0 then
                if globals.tickcount() % ui.get(menu.antiaim[i].break_delay.ref) == 0 then
                    if antiaim.side == "left" then
                        cmd.force_defensive = true
                    end
                end
            else
                if antiaim.side == "left" then
                    cmd.force_defensive = true
                end
            end
        end
    end

    local detect_defensive = antiaim.is_defensive_active()

    antiaim.aa_list.pitch = ui.get(menu.antiaim[i].pitch.ref)
    antiaim.aa_list.yaw_base = ui.get(menu.antiaim[i].yaw_base.ref)
    antiaim.aa_list.yaw = "180"
    if ui.get(menu.antiaim[i].yaw_type.ref) == "Off" then 
        antiaim.aa_list.yaw_add = 0
    elseif ui.get(menu.antiaim[i].yaw_type.ref) == "Static" then
        antiaim.aa_list.yaw_add = ui.get(menu.antiaim[i].yaw.ref)
    elseif ui.get(menu.antiaim[i].yaw_type.ref) == "L & R" then
        if antiaim.side == "left" then 
            antiaim.aa_list.yaw_add = ui.get(menu.antiaim[i].yaw_left.ref)
        elseif antiaim.side == "right" then
            antiaim.aa_list.yaw_add = ui.get(menu.antiaim[i].yaw_right.ref)
        elseif antiaim.side == "none" then
            antiaim.aa_list.yaw_add = 0
        end
    elseif ui.get(menu.antiaim[i].yaw_type.ref) == "Random" then
        antiaim.aa_list.yaw_add = math.random(ui.get(menu.antiaim[i].yaw_min.ref), ui.get(menu.antiaim[i].yaw_max.ref))
    end
    if antiaim.cur_phase ~= 0 then 
        --[[for i = 1, 10 do
            menu.antiaim.antibrute[i].yaw:depend({menu.tab, "antiaim"}, {menu.antiaim.tab, "Anti-Bruteforce"}, {menu.antiaim.antibrute.enable, true}, {menu.antiaim.antibrute.list, i-1})
            menu.antiaim.antibrute[i].modifier_add:depend({menu.tab, "antiaim"}, {menu.antiaim.tab, "Anti-Bruteforce"}, {menu.antiaim.antibrute.enable, true}, {menu.antiaim.antibrute.list, i-1})
        end]]
        antiaim.aa_list.yaw_add = ui.get(menu.antiaim.antibrute[antiaim.cur_phase].yaw.ref)
    end
    antiaim.aa_list.yaw_modifier = ui.get(menu.antiaim[i].yaw_modifier.ref)
    if ui.get(menu.antiaim[i].yaw_modifier_delay.ref) ~= 0 and ui.get(menu.antiaim[i].yaw_modifier.ref) == "Center" then
        antiaim.aa_list.yaw_modifier_range = 0
        if antiaim.cur_phase ~= 0 then
            antiaim.aa_list.yaw_add = antiaim.aa_list.yaw_add + (antiaim.side == "right" and ui.get(menu.antiaim.antibrute[antiaim.cur_phase].modifier_add.ref)/2 or -ui.get(menu.antiaim.antibrute[antiaim.cur_phase].modifier_add.ref)/2)
        else
            antiaim.aa_list.yaw_add = antiaim.aa_list.yaw_add + (antiaim.side == "right" and ui.get(menu.antiaim[i].yaw_modifier_range.ref)/2 or -ui.get(menu.antiaim[i].yaw_modifier_range.ref)/2)
        end
        if ui.get(menu.antiaim[i].body_yaw.ref) == "Jitter" then
            antiaim.aa_list.body_yaw = "off"
            antiaim.aa_list.body_yaw_range = antiaim.side == "left" and ui.get(menu.antiaim[i].body_yaw_range.ref) or -ui.get(menu.antiaim[i].body_yaw_range.ref)
            --antiaim.aa_list.yaw_add = antiaim.aa_list.yaw_add + ((entity.get_prop(lp,"m_flPoseParameter",11) * 120 - 60) > 0 and -ui.get(menu.antiaim[i].yaw_modifier_range.ref)/2 or ui.get(menu.antiaim[i].yaw_modifier_range.ref)/2)
        else
            antiaim.aa_list.body_yaw = ui.get(menu.antiaim[i].body_yaw.ref)
            antiaim.aa_list.body_yaw_range = ui.get(menu.antiaim[i].body_yaw_range.ref)
            --antiaim.aa_list.yaw_add = antiaim.aa_list.yaw_add + (antiaim.side == "right" and ui.get(menu.antiaim[i].yaw_modifier_range.ref)/2 or -ui.get(menu.antiaim[i].yaw_modifier_range.ref)/2)
        end
    else
        if antiaim.cur_phase ~= 0 then 
            antiaim.aa_list.yaw_modifier_range = ui.get(menu.antiaim.antibrute[antiaim.cur_phase].modifier_add.ref)
        else
            antiaim.aa_list.yaw_modifier_range = ui.get(menu.antiaim[i].yaw_modifier_range.ref)
        end
        antiaim.aa_list.body_yaw = ui.get(menu.antiaim[i].body_yaw.ref)
        antiaim.aa_list.body_yaw_range = ui.get(menu.antiaim[i].body_yaw_range.ref)
    end

    if ui.get(menu.antiaim[i].defensive_antiaim.ref) and detect_defensive then
        antiaim.aa_list.pitch = ui.get(menu.antiaim[i].defensive_pitch.ref)
        antiaim.aa_list.yaw = "180"
        if ui.get(menu.antiaim[i].defensive_spin.ref) then
            antiaim.aa_list.yaw = "spin"
            antiaim.aa_list.yaw_add = ui.get(menu.antiaim[i].defensive_spin_range.ref)
        else
            if ui.get(menu.antiaim[i].defensive_yaw_type.ref) == "Off" then 
                antiaim.aa_list.yaw_add = 0
            elseif ui.get(menu.antiaim[i].defensive_yaw_type.ref) == "Static" then
                antiaim.aa_list.yaw_add = ui.get(menu.antiaim[i].defensive_yaw.ref)
            elseif ui.get(menu.antiaim[i].defensive_yaw_type.ref) == "L & R" then
                if antiaim.side == "left" then 
                    antiaim.aa_list.yaw_add = ui.get(menu.antiaim[i].defensive_yaw_left.ref)
                elseif antiaim.side == "right" then
                    antiaim.aa_list.yaw_add = ui.get(menu.antiaim[i].defensive_yaw_right.ref)
                elseif antiaim.side == "none" then
                    antiaim.aa_list.yaw_add = 0
                end
            elseif ui.get(menu.antiaim[i].defensive_yaw_type.ref) == "Random" then
                antiaim.aa_list.yaw_add = math.random(ui.get(menu.antiaim[i].defensive_yaw_min.ref), ui.get(menu.antiaim[i].defensive_yaw_max.ref))
            end
        end
        antiaim.aa_list.yaw_modifier = ui.get(menu.antiaim[i].defensive_yaw_modifier.ref)
        antiaim.aa_list.yaw_modifier_range = ui.get(menu.antiaim[i].defensive_yaw_modifier_range.ref)
    end

    ui.set(refs.pitch[1].ref, antiaim.aa_list.pitch)
    ui.set(refs.pitch[2].ref, ui.get(menu.antiaim[i].pitch_value.ref))
    ui.set(refs.yaw_base.ref, antiaim.aa_list.yaw_base)
    ui.set(refs.yaw[1].ref, antiaim.aa_list.yaw)
    if antiaim.aa_list.yaw_add > 180 then antiaim.aa_list.yaw_add = 180 end
    if antiaim.aa_list.yaw_add < -180 then antiaim.aa_list.yaw_add = -180 end
    ui.set(refs.yaw[2].ref, antiaim.aa_list.yaw_add)
    ui.set(refs.yaw_jiiter[1].ref, antiaim.aa_list.yaw_modifier)
    ui.set(refs.yaw_jiiter[2].ref, antiaim.aa_list.yaw_modifier_range)
    ui.set(refs.body_yaw[1].ref, antiaim.aa_list.body_yaw)
    ui.set(refs.body_yaw[2].ref, antiaim.aa_list.body_yaw_range)

    if antiaim.manuals() == 1 then
        ui.set(refs.pitch[1].ref, "down")
        ui.set(refs.yaw[1].ref, "180")
        ui.set(refs.yaw[2].ref, -90)
        ui.set(refs.yaw_base.ref, "Local view")
        ui.set(refs.yaw_jiiter[1].ref, "Off")
        ui.set(refs.body_yaw[1].ref, "Static")
        ui.set(refs.body_yaw[2].ref, 0)
    end
    if antiaim.manuals() == 2 then
        ui.set(refs.pitch[1].ref, "down")
        ui.set(refs.yaw[1].ref, "180")
        ui.set(refs.yaw[2].ref, 90)
        ui.set(refs.yaw_base.ref, "Local view")
        ui.set(refs.yaw_jiiter[1].ref, "Off")
        ui.set(refs.body_yaw[1].ref, "Static")
        ui.set(refs.body_yaw[2].ref, 0)
    end

    if ui.get(menu.antiaim.keys.freestanding_dis_aa.ref) and ui.get(menu.antiaim.keys.freestanding.ref) then
        ui.set(refs.pitch[1].ref, "down")
        ui.set(refs.yaw[1].ref, "180")
        ui.set(refs.yaw[2].ref, 0)
        ui.set(refs.yaw_base.ref, "At targets")
        ui.set(refs.yaw_jiiter[1].ref, "Off")
        ui.set(refs.body_yaw[1].ref, "Static")
        ui.set(refs.body_yaw[2].ref, 0)
    end
    
    if ui.get(menu.antiaim.keys.freestanding.ref) then
        if (helpers.contains(menu.antiaim.keys.freestanding_disablers.value, "Stand") and i == 1) or (helpers.contains(menu.antiaim.keys.freestanding_disablers.value, "Move") and i == 2) or (helpers.contains(menu.antiaim.keys.freestanding_disablers.value, "Air") and (i == 3 or i == 4)) then
            ui.set(refs.freestanding[1], false)
        else
            ui.set(refs.freestanding[1], true)
        end
    else
        ui.set(refs.freestanding[1], ui.get(menu.antiaim.keys.freestanding.ref), false)
    end

    ui.set(refs.freestanding[2], "Always On")

    ui.set(refs.edge_yaw.ref, ui.get(menu.antiaim.keys.edge_yaw.ref) and true or false)

    ui.set_visible(menu.antiaim[i].defensive_break.ref, (menu.selected_tab == "antiaim" and cond_check and b))
    ui.set_visible(menu.antiaim[i].break_type.ref, (menu.selected_tab == "antiaim" and cond_check and b and ui.get(menu.antiaim[i].defensive_break.ref)))

    -- safe head
    if ui.get(menu.misc.safehead.ref) then
        local local_player_weapon = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))
        if local_player_weapon == "CKnife" and (i == 3 or i == 4) then
            ui.set(refs.pitch[1].ref, "down")
            ui.set(refs.yaw[1].ref, "180")
            ui.set(refs.yaw[2].ref, -1)
            ui.set(refs.yaw_base.ref, "At targets")
            ui.set(refs.yaw_jiiter[1].ref, "Off")
            ui.set(refs.body_yaw[1].ref, "Static")
            ui.set(refs.body_yaw[2].ref, 0)
        end
    end

    if ui.get(menu.misc.antibackstab.ref) then
        for i, v in pairs(players) do
            local player_weapon = entity.get_classname(entity.get_player_weapon(v))
            local player_distance = math.floor(vector(entity.get_origin(v)):dist(vector(entity.get_origin(entity.get_local_player()))) / 7)

            if player_weapon == "CKnife" then
                if player_distance < 25 then
                    ui.set(refs.pitch[1].ref, "down")
                    ui.set(refs.yaw[1].ref, "180")
                    ui.set(refs.yaw[2].ref, -180)
                    ui.set(refs.yaw_base.ref, "At targets")
                    ui.set(refs.yaw_jiiter[1].ref, "Off")
                    ui.set(refs.body_yaw[1].ref, "Static")
                    ui.set(refs.body_yaw[2].ref, 0)
                end
            end
        end
    end
end

--misc
local misc = {}
local g_esp_data = { }
local g_sim_ticks, g_net_data = { }, { }

local globals_tickinterval = globals.tickinterval
local entity_is_enemy = entity.is_enemy
local entity_get_prop = entity.get_prop
local entity_is_dormant = entity.is_dormant
local entity_is_alive = entity.is_alive
local entity_get_origin = entity.get_origin
local entity_get_local_player = entity.get_local_player
local entity_get_player_resource = entity.get_player_resource
local entity_get_bounding_box = entity.get_bounding_box
local entity_get_player_name = entity.get_player_name
local renderer_text = renderer.text
local w2s = renderer.world_to_screen
local line = renderer.line
local table_insert = table.insert
local client_trace_line = client.trace_line
local math_floor = math.floor
local globals_frametime = globals.frametime

local sv_gravity = cvar.sv_gravity
local sv_jump_impulse = cvar.sv_jump_impulse

local time_to_ticks = function(t) return math_floor(0.5 + (t / globals_tickinterval())) end
local vec_substract = function(a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end
local vec_lenght = function(x, y) return (x * x + y * y) end

local get_entities = function(enemy_only, alive_only)
	local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    
    local result = {}

    local me = entity_get_local_player()
    local player_resource = entity_get_player_resource()
    
	for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true
        
        if enemy_only and not entity_is_enemy(player) then is_enemy = false end
        if is_enemy then
            if alive_only and entity_get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
            if is_alive then table_insert(result, player) end
        end
	end

	return result
end

local extrapolate = function(ent, origin, flags, ticks)
    local tickinterval = globals_tickinterval()

    local sv_gravity = sv_gravity:get_float() * tickinterval
    local sv_jump_impulse = sv_jump_impulse:get_float() * tickinterval

    local p_origin, prev_origin = origin, origin

    local velocity = { entity_get_prop(ent, 'm_vecVelocity') }
    local gravity = velocity[3] > 0 and -sv_gravity or sv_jump_impulse

    for i=1, ticks do
        prev_origin = p_origin
        p_origin = {
            p_origin[1] + (velocity[1] * tickinterval),
            p_origin[2] + (velocity[2] * tickinterval),
            p_origin[3] + (velocity[3]+gravity) * tickinterval,
        }

        local fraction = client_trace_line(-1, 
            prev_origin[1], prev_origin[2], prev_origin[3], 
            p_origin[1], p_origin[2], p_origin[3]
        )

        if fraction <= 0.99 then
            return prev_origin
        end
    end

    return p_origin
end

misc.lagcomp_net = function()
	local me = entity_get_local_player()
    local players = get_entities(true, true)

	for i=1, #players do
		local idx = players[i]
        local prev_tick = g_sim_ticks[idx]
        
        if entity_is_dormant(idx) or not entity_is_alive(idx) then
            g_sim_ticks[idx] = nil
            g_net_data[idx] = nil
            g_esp_data[idx] = nil
        else
            local player_origin = { entity_get_origin(idx) }
            local simulation_time = time_to_ticks(entity_get_prop(idx, 'm_flSimulationTime'))
    
            if prev_tick ~= nil then
                local delta = simulation_time - prev_tick.tick

                if delta < 0 or delta > 0 and delta <= 64 then
                    local m_fFlags = entity_get_prop(idx, 'm_fFlags')

                    local diff_origin = vec_substract(player_origin, prev_tick.origin)
                    local teleport_distance = vec_lenght(diff_origin[1], diff_origin[2])

                    local extrapolated = extrapolate(idx, player_origin, m_fFlags, delta-1)
    
                    if delta < 0 then
                        g_esp_data[idx] = 1
                    end

                    g_net_data[idx] = {
                        tick = delta-1,

                        origin = player_origin,
                        predicted_origin = extrapolated,

                        tickbase = delta < 0,
                        lagcomp = teleport_distance > 4096,
                    }
                end
            end
    
            if g_esp_data[idx] == nil then
                g_esp_data[idx] = 0
            end

            g_sim_ticks[idx] = {
                tick = simulation_time,
                origin = player_origin,
            }
        end
	end
end

misc.lagcomp_paint = function()
    if ui.get(menu.misc.lagcomp_ind.ref) == false then return end
    local me = entity_get_local_player()
    local player_resource = entity_get_player_resource()

    if not me or not entity_is_alive(me) then
        return
    end

	local observer_mode = entity_get_prop(me, "m_iObserverMode")
	local active_players = {}

	if (observer_mode == 0 or observer_mode == 1 or observer_mode == 2 or observer_mode == 6) then
		active_players = get_entities(true, true)
	elseif (observer_mode == 4 or observer_mode == 5) then
		local all_players = get_entities(false, true)
		local observer_target = entity_get_prop(me, "m_hObserverTarget")
		local observer_target_team = entity_get_prop(observer_target, "m_iTeamNum")

		for test_player = 1, #all_players do
			if (
				observer_target_team ~= entity_get_prop(all_players[test_player], "m_iTeamNum") and
				all_players[test_player ] ~= me
			) then
				table_insert(active_players, all_players[test_player])
			end
		end
	end

    if #active_players == 0 then
        return
    end

    for idx, net_data in pairs(g_net_data) do
        if entity_is_alive(idx) and entity_is_enemy(idx) and net_data ~= nil then
            local text = {
                [0] = '', [1] = 'LAG COMP BREAKER',
                [2] = 'SHIFTING TICKBASE'
            }

            local x1, y1, x2, y2, a = entity_get_bounding_box(idx)
            local palpha = 0

            if g_esp_data[idx] > 0 then
                g_esp_data[idx] = g_esp_data[idx] - globals_frametime()*2
                g_esp_data[idx] = g_esp_data[idx] < 0 and 0 or g_esp_data[idx]

                palpha = g_esp_data[idx]
            end

            local tb = net_data.tickbase or g_esp_data[idx] > 0
            local lc = net_data.lagcomp

            if not tb or net_data.lagcomp then
                palpha = a
            end

            if x1 ~= nil and a > 0 then
                local name = entity_get_player_name(idx)
                local y_add = name == '' and -8 or 0

                renderer_text(x1 + (x2-x1)/2, y1 - 18 + y_add, 255, 45, 45, palpha*255, 'c', 0, text[tb and 2 or (lc and 1 or 0)])
            end
        end
    end
end

misc.resolver = {}
local function angle(p, y, r)
	return setmetatable(
		{
			p = p or 0,
			y = y or 0,
			r = r or 0
		},
		angle_mt
	)
end

ffi.cdef[[
    struct c_animstate {
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    };


    typedef struct
    {
        float   m_anim_time;		
        float   m_fade_out_time;	
        int     m_flags;			
        int     m_activity;			
        int     m_priority;			
        int     m_order;			
        int     m_sequence;			
        float   m_prev_cycle;		
        float   m_weight;			
        float   m_weight_delta_rate;
        float   m_playback_rate;	
        float   m_cycle;			
        void* m_owner;			
        int     m_bits;				
    } C_AnimationLayer;

    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);
]]

local entity_list_ptr = ffi.cast("void***", client.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][3])

entity.get_address = function(idx)
    return get_client_entity_fn(entity_list_ptr, idx)
end

entity.get_animstate = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("struct c_animstate**", addr + 0x9960)[0]
end

entity.get_animlayer = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', addr) + 0x9960)[0]
end

function GetPlayerMaxFeetYaw(_Entity)
    local S_animationState_t = entity.get_animstate(_Entity)
    local nDuckAmount = S_animationState_t.m_fDuckAmount
    local nFeetSpeedForwardsOrSideWays = math.max(0, math.min(1, S_animationState_t.m_flFeetSpeedForwardsOrSideWays))
    local nFeetSpeedUnknownForwardOrSideways = math.max(1, S_animationState_t.m_flFeetSpeedUnknownForwardOrSideways)
    local nValue =
        (S_animationState_t.m_flStopToFullRunningFraction * -0.30000001 - 0.19999999) * nFeetSpeedForwardsOrSideWays +
        1
    if nDuckAmount > 0 then
        nValue = nValue + nDuckAmount * nFeetSpeedUnknownForwardOrSideways * (0.5 - nValue)
    end
    local nDeltaYaw = (S_animationState_t.m_flMaxYaw * nValue)*-1
    return nDeltaYaw < 60 and nDeltaYaw >= 0 and nDeltaYaw or 0
end

math.clamp = function(v, min, max)
    if min > max then min, max = max, min end
    if v > max then return max end
    if v < min then return v end
    return v
end

math.vec_length2d = function(vec)
    root = 0.0
    sqst = vec.x * vec.x + vec.y * vec.y
    root = math.sqrt(sqst)
    return root
end

misc.resolver.m_flMaxDelta = function(idx)
    local animstate = entity.get_animstate(idx)

    local speedfactor = math.clamp(animstate.m_flFeetSpeedForwardsOrSideWays, 0, 1)
    local avg_speedfactor = (animstate.m_flStopToFullRunningFraction * -0.3 - 0.2) * speedfactor + 1

    local duck_amount = animstate.m_fDuckAmount

    if duck_amount > 0 then
        local max_velocity = math.clamp(animstate.m_flFeetSpeedForwardsOrSideWays, 0, 1)
        local duck_speed = duck_amount * max_velocity

        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return avg_speedfactor
end

entity.get_vector_prop = function(idx, prop, array)
    local v1, v2, v3 = entity.get_prop(idx, prop, array)
    return {
        x = v1, y = v2, z = v3
    }
end

math.angle_diff = function(dest, src)
    local delta = 0.0

    delta = math.fmod(dest - src, 360.0)

    if dest > src then
        if delta >= 180 then delta = delta - 360 end
    else
        if delta <= -180 then delta = delta + 360 end
    end

    return delta
end

local change_resolve_method = false

client.set_event_callback("aim_hit", function(handle)
    change_resolve_method = false
end)

client.set_event_callback("aim_miss", function(handle)
    change_resolve_method = true
end)



misc.resolver.execute = function()
    if ui.get(menu.misc.resolver_helper.ref) == false then return end
    local res_type = ui.get(menu.misc.resolver_type.ref)
    local LocalPlayer = entity.get_local_player()
    if LocalPlayer == nil then
        return
    end

    local entities = entity.get_players(true)

    if #entities == 0 then
        return
    end

    for i=1, #entities do
        local target = entities[i]
		local animstate = entity.get_animstate(target)
        local steamID64 = entity.get_steam64(target)

		local max_yaw = GetPlayerMaxFeetYaw(entities[i])

        local m_vecVelocity = entity.get_vector_prop(target, 'm_vecVelocity')
        local m_flVelocityLengthXY = math.vec_length2d(m_vecVelocity)

        local m_flMaxDesyncDelta = misc.resolver.m_flMaxDelta(target)
        local m_flDesync = m_flMaxDesyncDelta * 57

        local m_flEyeYaw = animstate.m_flEyeYaw
        local m_flGoalFeetYaw = animstate.m_flGoalFeetYaw
        local m_flLowerBodyYawTarget = entity.get_prop(target, 'm_flLowerBodyYawTarget')

        local m_flAngleDiff = math.angle_diff(m_flEyeYaw, m_flGoalFeetYaw)

        local side = 0
        if m_flAngleDiff < 0 then
            side = 1
        elseif m_flAngleDiff > 0 then
            side = -1
        end

        --m_flDesync = m_flDesync*side < 0 and math.random(m_flDesync, m_flDesync+3) or math.random(m_flDesync-3, m_flDesync)
        if max_yaw > m_flDesync then
            m_flDesync = m_flDesync+(max_yaw - m_flDesync)
        else
            m_flDesync = m_flDesync+(m_flDesync - max_yaw)
        end

        if m_flDesync < -60 then m_flDesync = -60 end
        if m_flDesync > 60 then m_flDesync = 60 end
        if res_type == "New" then
            if steamID64 == 0 then
                plist.set(target, "Force body yaw", false)
                plist.set(target, "Force body yaw value", 0)
            else
                plist.set(target, "Force body yaw", true)
                plist.set(target, "Force body yaw value", m_flDesync*side)
                plist.set(target, "Correction active", true)
            end
        else
            if steamID64 == 0 then
                plist.set(target, "Force body yaw", false)
                plist.set(target, "Force body yaw value", 0)
            else
                plist.set(target, "Force body yaw", true)
                plist.set(target, "Force body yaw value", math.random(35,40)*side)
                plist.set(target, "Correction active", true)
            end
        end
    end
end

misc.backtrack = function()
    if ui.get(menu.misc.last_backtrack.ref) then
        cvar.cl_interp_ratio:set_int(1)
        cvar.sv_max_allowed_net_graph:set_int(2)
        cvar.cl_interpolate:set_int(0)
    else
        cvar.cl_interp_ratio:set_int(2)
        cvar.cl_interpolate:set_int(1)
    end
end

client.set_event_callback("setup_command", function(cmd)
    if helpers.contains(menu.misc.anim_breakers.value, "Jitter legs on run") then
        ui.set(ui.reference("AA", "other", "leg movement"), cmd.command_number % 3 == 0 and "Off" or "Always slide")
    end
end)

client.set_event_callback("pre_render", function()
    local self = entity.get_local_player()
    if not self or not entity.is_alive(self) then
        return
    end

    local self_index = c_entity.new(self)
    local self_anim_state = self_index:get_anim_state()

    if not self_anim_state then
        return
    end

    if helpers.contains(menu.misc.anim_breakers.value, "Static legs in air") then
        entity.set_prop(self, "m_flPoseParameter", 1, E_POSE_PARAMETERS.JUMP_FALL)
    end

    if helpers.contains(menu.misc.anim_breakers.value, "Jitter legs on run") then
        entity.set_prop(self, "m_flPoseParameter", E_POSE_PARAMETERS.STAND, globals.tickcount() % 4 > 1 and 9 / 10 or 1)
    end
end)

misc.fast_ladder = function(e)
    if ui.get(menu.misc.fastladder.ref) then
        local local_player = entity.get_local_player()
        local pitch, yaw = client.camera_angles()
        if entity.get_prop(local_player, "m_MoveType") == 9 then
            e.yaw = math.floor(e.yaw + 0.5)
            e.roll = 0
            if e.forwardmove == 0 then
                e.pitch = 89
                e.yaw = e.yaw + 180
                if math.abs(180) > 0 and math.abs(180) < 180 and e.sidemove ~= 0 then
                    e.yaw = e.yaw - ui.get(180)
                end
                if math.abs(180) == 180 then
                    if e.sidemove < 0 then
                        e.in_moveleft = 0
                        e.in_moveright = 1
                    end
                    if e.sidemove > 0 then
                        e.in_moveleft = 1
                        e.in_moveright = 0
                    end
                end
            end
    
            if e.forwardmove > 0 then
                if pitch < 45 then
                    e.pitch = 89
                    e.in_moveright = 1
                    e.in_moveleft = 0
                    e.in_forward = 0
                    e.in_back = 1
                    if e.sidemove == 0 then
                        e.yaw = e.yaw + 90
                    end
                    if e.sidemove < 0 then
                        e.yaw = e.yaw + 150
                    end
                    if e.sidemove > 0 then
                        e.yaw = e.yaw + 30
                    end
                end 
            end
            if e.forwardmove < 0 then
                e.pitch = 89
                e.in_moveleft = 1
                e.in_moveright = 0
                e.in_forward = 1
                e.in_back = 0
                if e.sidemove == 0 then
                    e.yaw = e.yaw + 90
                end
                if e.sidemove > 0 then
                    e.yaw = e.yaw + 150
                end
                if e.sidemove < 0 then
                    e.yaw = e.yaw + 30
                end
            end
        end
    end
end

local kill_say = {}
kill_say.current_killsay_list = {
    "daunigrok228 ебал твою маму ",
    "В черном секторе тебя  будут закапывать только черные ",
    "Тебе нужен дифецит калорий, а то ты уже по клавишам не попадаешь",
    "Ты не выговариваешь 18-ю букву алфавита,потому что твоя бабка повесилась на 18 этаже",
    ":sad: сlown :",
    "Tebya ebet Ka4ok lua",
    "иди все свои пожитки складывай и собирайся к своей матери на трассу",
    "В Африке тебя бы приняли за своих",
    "Today это же завтра?",
    "Нож в печень,твоя удача не вечна",
    " ",
    "ты бля че нахуй там все переписываешь?",
    "расчехляй свою шоколадницу Black Sqad уже выехал",
    "МЕНЯ НЕ УБИТЬ! Я ВАНВЕЙ В ЭТОЙ ИГРЕ ПИДАРАС",
    "братка го я тебе бекап позову",
    "ХУЖЕ ТЕБЯ ТОЛЬКО ТВОЯ СЕМЬЯ",
    "мапу изучаешь?",
    "neverlose.cc/refund.php",
    "ВАС ЕБЕТ AMMONIA LEGEND",
    "1/",
    "bruh",
    "уёбище как дела",
    "ты чё, без читов? я тебя выebал прост",
    "Я думал ты не клин, как же я ошибался",
    "Escape from Saratov",
    "Иди какашу поешь,может быть сможешь меня убить",
    "оплата по карте или в хуй?",
    "ты как treasury от гранаты упал",
    "тебе бекап в школу завести?",
    "СЛЫШУ ZOV ,ВАГНЕРА УБИЛИ ХОХЛОВ",
    "ZV",
    " BAC ЕБЕТ ПАПА РИМСКИЙ & ПАПА КАРЛО",
    "Me (stefan) and my brother (AlexBotea) rape this weak little slut (ALINAHVH KTO ETO???) In the mouth and ass"
}

client.set_event_callback("player_death", function(event)
    if ui.get(menu.misc.trashtalk.ref) == false then return end
    if event.attacker == event.userid then
        return
    end

    local attacker = client.userid_to_entindex(event.attacker)
    local localplayer = entity.get_local_player()

    if attacker ~= localplayer then
        return
    end

    local current_phrase = kill_say.current_killsay_list[math.random(1, #kill_say.current_killsay_list)]
    
    client.exec(('say "%s"'):format(current_phrase))
end)

local clantag = {}
local GameStateAPI = panorama.open().GameStateAPI
clantag.time_to_ticks = function(t) return math.floor(t / globals.tickinterval() + 0.5) end
clantag.vars = {
    clantag_cache = "",
    set_clantag = function(self, tag)
        if tag ~= self.clantag_cache then
            --if GameStateAPI.GetPlayerTeamNumber(GameStateAPI.GetLocalPlayerXuid()) == 0 then return end
            client.set_clan_tag(tag)
            self.clantag_cache = tag
        end
    end
}

clantag.animation = function(text, indices)
    local text_anim = "               " .. text .. "                      " 
    local tickcount = globals.tickcount() + clantag.time_to_ticks(client.latency() + 0.321)
    local i = tickcount / clantag.time_to_ticks(0.3)
    i = math.floor(i % #indices)
    i = indices[i+1]+1
    return text_anim:sub(i, i+15)
end

clantag.clan_tag_prev = ''
clantag.executer = function()
    local local_player = entity.get_local_player()
    if not local_player then return end
    if ui.get(menu.misc.clantag.ref) then
        local clan_tag = clantag.animation("black sector", {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23})
        if entity.get_prop(entity.get_game_rules(), "m_gamePhase") == 5 then
            clantag.vars:set_clantag(clantag.animation("black sector", {12}))
        end
        if clan_tag ~= clantag.clan_tag_prev then
            clantag.vars:set_clantag(clan_tag)
        end
        clantag.clan_tag_prev = clan_tag
    else
        clantag.vars:set_clantag("")
    end
end

--visuals
local visuals = {}
visuals.watermark = function()
    if ui.get(menu.visuals.watermark.ref) == false then return end
    local icon = renderer.load_svg([[<svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="1080.000000pt" height="1080.000000pt" viewBox="0 0 1080.000000 1080.000000" preserveAspectRatio="xMidYMid meet"> <g transform="translate(0.000000,1080.000000) scale(0.100000,-0.100000)" fill="white" stroke="none"> <path d="M5085 10747 c-33 -18 -143 -76 -245 -129 -102 -53 -230 -119 -285 -148 -55 -29 -183 -95 -285 -147 -102 -53 -225 -117 -275 -143 -123 -65 -270 -142 -460 -240 -159 -82 -293 -152 -475 -247 -52 -28 -176 -92 -275 -143 -99 -51 -211 -110 -250 -130 -38 -21 -137 -73 -220 -115 -356 -184 -509 -264 -755 -392 -52 -28 -171 -90 -265 -138 -154 -79 -264 -137 -455 -237 -96 -51 -109 -60 -113 -83 -10 -59 -85 -19 2198 -1160 1570 -785 2187 -1089 2232 -1099 52 -12 71 -12 125 -1 50 11 562 263 2328 1147 2388 1195 2315 1156 2284 1205 -6 10 -35 30 -65 45 -62 32 -464 227 -614 298 -97 46 -223 107 -525 253 -80 38 -203 98 -275 132 -191 91 -359 173 -540 260 -88 43 -214 103 -280 135 -118 57 -251 120 -495 238 -69 33 -201 97 -295 142 -169 82 -330 159 -520 250 -55 26 -203 98 -330 160 -126 61 -255 123 -285 137 -30 14 -129 61 -219 104 -158 76 -166 79 -235 79 -61 -1 -79 -5 -131 -33z" fill="white"/> <path d="M7831 7037 c-2523 -1262 -2403 -1198 -2416 -1288 -3 -24 -5 -1288 -3 -2809 3 -2688 4 -2766 22 -2802 25 -47 78 -70 136 -57 55 12 4588 2280 4623 2313 61 57 57 -168 57 2931 0 2822 0 2835 -20 2855 -11 11 -32 20 -47 20 -17 0 -965 -469 -2352 -1163z" fill="white"/> <path d="M620 7959 c-16 -10 -37 -30 -47 -46 -17 -26 -18 -144 -21 -2718 -2 -1889 0 -2701 8 -2727 6 -20 25 -51 42 -68 21 -22 698 -365 2122 -1077 1150 -575 2107 -1050 2126 -1055 109 -30 141 -20 162 51 11 38 13 514 13 2758 l0 2712 -38 39 c-31 32 -419 229 -2130 1086 -2260 1132 -2166 1088 -2237 1045z " fill="white"/> </g> </svg> ]],1080,1080)
    local screen_size = {client.screen_size()}
    local r,g,b,a = unpack({menu.visuals.watermark:get_color()})
    screen_size.x = screen_size[1]
    screen_size.y = screen_size[2]
    renderer.texture(icon, 6, screen_size.y/2 - 34, 35, 35, r,g,b, 255, "f")
    local gradient_text = helpers.calculateGradient("B L A C K  S E C T O R", {color(255,255,255), color(r,g,b)}, 2)
    local gradient_text2 = helpers.calculateGradient("D E B U G | U S E R : " .. obex_data.username, {color(255,255,255), color(r,g,b)}, 2)
    renderer.text(45, screen_size.y/2 - 28, 255, 255, 255, 255, "", 0, gradient_text)
    renderer.text(45, screen_size.y/2 - 15, 255, 255, 255, 255, "", 0, gradient_text2)
end

math.pulse = function()
    return math.clamp((math.floor(math.sin(globals.curtime() * 2) * 220 + 221)) / 900 * 6.92, 0, 1) * 235 + 20
end

math.clamp = function(num, m, mx)
    return math.min(math.max(num, m), mx)
end

local scoped_anim = 0
local ind_anim = {0,0,0,0,0,0}
visuals.indicators = function()
    if ui.get(menu.visuals.indicators.ref) == false then return end
    local lp = entity.get_local_player()
    local screen = {client.screen_size()}
    screen.x = screen[1]
    screen.y = screen[2]
    local x,y = screen.x/2, screen.y/2
    local offset = 18

    local binds = {
        {name = "peek", color = color(200, 200, 200), bool = ui.get(refs.peek[2]), offset = 24},
        {name = "min", color = color(200, 200, 200), bool = ui.get(refs.min_damage_override[2]), offset = 20},
        {name = "dt", color = color(200, 200, 200), bool = ui.get(refs.double_tap[2]), offset = 12},
        {name = "os", color = color(200, 200, 200), bool = ui.get(refs.hide_shots[2]), offset = 12},
        {name = "fs", color = color(200, 200, 200), bool = ui.get(refs.freestanding[2]) and ui.get(refs.freestanding[1]), offset = 12},
        {name = "fd", color = color(200, 200, 200), bool = ui.get(refs.fakeduck.ref), offset = 12},
    }

    if lp == nil then return end
    if entity.is_alive(lp) == false then return end

    local state_name = antiaim.get_state_name(get_velocity())
    local scoped = entity.get_prop(entity.get_local_player(),"m_bIsScoped") == 1 and true or false
    scoped_anim = helpers.lerp(scoped_anim, scoped and 1 or 0, 17 * globals.frametime())
    local name_offset = renderer.measure_text("-", ("black:sector"):upper())

    local gradient_text = helpers.calculateGradient((":sector"):upper(), {color(255,255,255), color(224, 153, 137)}, 2)
    renderer.text(x + (scoped_anim * (name_offset/2 + 2)), y + offset, 255, 255, 255, 255, "c-", 0, "BLACK" .. gradient_text)

    offset = offset + 9
    local state_offset = {
        ["stand"] = 14,
        ["move"] = 14,
        ["air"] = 7,
        ["air-c"] = 12,
        ["crouch"] = 17,
        ["slow"] = 11

    }
    renderer.text(x + (scoped_anim * (renderer.measure_text("-", state_name:upper())/2 + 2)), y + offset, 200, 200, 200, math.floor(math.pulse()), "c-", 0, state_name:upper())
    offset = offset + 9

    for i = 1, #binds do
        local name_offset = renderer.measure_text("-", binds[i].name:upper())--binds[i].offset
        ind_anim[i] = helpers.lerp(ind_anim[i], binds[i].bool and 1 or 0, 10 * globals.frametime())
        --if binds[i].bool then
            renderer.text(x + (scoped_anim * (name_offset/2 + 2)), y + offset, 200, 200, 200, math.floor(ind_anim[i] * 200), "c-", 0, binds[i].name:upper())
        --end
        offset = offset + (binds[i].bool and 9 or 0)--helpers.lerp(offset, offset + (binds[i].bool and 11 or 0), 17 * globals.frametime())
    end
end

visuals.rec = function(x, y, w, h, radius, color)
    radius = math.min(x/2, y/2, radius)
    local r, g, b, a = unpack(color)
    renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
    renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
    renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
    renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
    renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
    renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
    renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
end

visuals.rec_outline = function(x, y, w, h, radius, thickness, color)
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
end

visuals.glow_module = function(x, y, w, h, width, rounding, accent, accent_inner)
    local thickness = 1
    local offset = 1
    local r, g, b, a = unpack(accent)
    if accent_inner then
        visuals.rec(x , y, w, h + 1, rounding, accent_inner)
    end
    for k = 0, width do
        if a * (k/width)^(1) > 5 then
            local accent = {r, g, b, a * (k/width)^(2)}
            visuals.rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
        end
    end
end

local defensive_indicator_a = 0
local defensive_tick = 0
visuals.defensive_indicator = function()
    local local_player = entity.get_local_player()
    if local_player == nil or entity.is_alive(local_player) == false then return end
    if ui.get(menu.visuals.defensive_manager.ref) == false then return end
    --local color_table = { _ui.visuals.defensive_ind:get_color() }
    local r,g,b,a = 224, 153, 137, 255--unpack(color_table)

    local screen = {client.screen_size()}
    screen.x = screen[1]
    screen.y = screen[2]
    local x,y = screen.x, screen.y
    local i = antiaim.get_state()

    local dt = ui.get(refs.double_tap[2]) and ui.get(menu.antiaim[i].defensive_break.ref)

    local defensive = antiaim.is_defensive_active()
    defensive_indicator_a = helpers.lerp(defensive_indicator_a, dt and 1 or 0, 17 * globals.frametime())

    if defensive then 
        if globals.tickcount() % 1 == 0 then
            defensive_tick = defensive_tick + 1
        end
    else
        defensive_tick = 0
    end
    if defensive_tick > 50 then defensive_tick = 50 end

    renderer.text(x / 2 , y / 2  * 0.5 - 10 , 224, 153, 137, 255*defensive_indicator_a, "c", 0, "defensive manager")
    visuals.glow_module(x / 2 - 50, y / 2  * 0.5,100,3, 14,2,{r,g,b,50*defensive_indicator_a}, {30,30,30,200*defensive_indicator_a})
    renderer.rectangle(x / 2, y / 2  * 0.5 +1,defensive_tick,2,r,g,b,255*defensive_indicator_a)
    renderer.rectangle(x / 2, y / 2  * 0.5 + 1,-defensive_tick,2,r,g,b,255*defensive_indicator_a)
end

visuals.notify = function()
    local screen = {client.screen_size()}
    screen.x = screen[1]
    screen.y = screen[2]
    local x,y = screen.x, screen.y
    local icon = renderer.load_svg([[<svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="1080.000000pt" height="1080.000000pt" viewBox="0 0 1080.000000 1080.000000" preserveAspectRatio="xMidYMid meet"> <g transform="translate(0.000000,1080.000000) scale(0.100000,-0.100000)" fill="white" stroke="none"> <path d="M5085 10747 c-33 -18 -143 -76 -245 -129 -102 -53 -230 -119 -285 -148 -55 -29 -183 -95 -285 -147 -102 -53 -225 -117 -275 -143 -123 -65 -270 -142 -460 -240 -159 -82 -293 -152 -475 -247 -52 -28 -176 -92 -275 -143 -99 -51 -211 -110 -250 -130 -38 -21 -137 -73 -220 -115 -356 -184 -509 -264 -755 -392 -52 -28 -171 -90 -265 -138 -154 -79 -264 -137 -455 -237 -96 -51 -109 -60 -113 -83 -10 -59 -85 -19 2198 -1160 1570 -785 2187 -1089 2232 -1099 52 -12 71 -12 125 -1 50 11 562 263 2328 1147 2388 1195 2315 1156 2284 1205 -6 10 -35 30 -65 45 -62 32 -464 227 -614 298 -97 46 -223 107 -525 253 -80 38 -203 98 -275 132 -191 91 -359 173 -540 260 -88 43 -214 103 -280 135 -118 57 -251 120 -495 238 -69 33 -201 97 -295 142 -169 82 -330 159 -520 250 -55 26 -203 98 -330 160 -126 61 -255 123 -285 137 -30 14 -129 61 -219 104 -158 76 -166 79 -235 79 -61 -1 -79 -5 -131 -33z" fill="white"/> <path d="M7831 7037 c-2523 -1262 -2403 -1198 -2416 -1288 -3 -24 -5 -1288 -3 -2809 3 -2688 4 -2766 22 -2802 25 -47 78 -70 136 -57 55 12 4588 2280 4623 2313 61 57 57 -168 57 2931 0 2822 0 2835 -20 2855 -11 11 -32 20 -47 20 -17 0 -965 -469 -2352 -1163z" fill="white"/> <path d="M620 7959 c-16 -10 -37 -30 -47 -46 -17 -26 -18 -144 -21 -2718 -2 -1889 0 -2701 8 -2727 6 -20 25 -51 42 -68 21 -22 698 -365 2122 -1077 1150 -575 2107 -1050 2126 -1055 109 -30 141 -20 162 51 11 38 13 514 13 2758 l0 2712 -38 39 c-31 32 -419 229 -2130 1086 -2260 1132 -2166 1088 -2237 1045z " fill="white"/> </g> </svg> ]],1080,1080)
    for i, info_noti in ipairs(notify_lol) do
        if i > 7 then
            table.remove(notify_lol, i)
        end
        if info_noti.text ~= nil and info_noti.text ~= "" then
            local color = info_noti.color
            if info_noti.timer + 3.7 < globals.realtime() then
                info_noti.y = helpers.lerp(info_noti.y, y + 150, globals.frametime() * 1.5)
                info_noti.alpha = helpers.lerp(info_noti.alpha, 0, globals.frametime() * 4.5)
            else
                info_noti.y = helpers.lerp(info_noti.y, y - 100, globals.frametime() * 1.5)
                info_noti.alpha = helpers.lerp(info_noti.alpha, 255, globals.frametime() * 4.5)
            end
        end

        local width = vector(renderer.measure_text("c", info_noti.text))
        local r,g,b,a = unpack({menu.visuals.logs:get_color()})

        visuals.glow_module(x /2 - width.x /2 - 20, info_noti.y - i*35 - 48 ,width.x + 30, width.y + 8, 14, 6, {r,g,b,info_noti.alpha - 165}, {13,13,13,(info_noti.alpha/255)*200})
        renderer.texture(icon, x /2 - width.x /2 - 15, info_noti.y - i*35 - 46, 16, 16, r,g,b, info_noti.alpha, "f")
        renderer.text(x / 2 - width.x /2 + 4, info_noti.y - i*35 - 45, 255,255,255,info_noti.alpha, "", nil, info_noti.text)

        if info_noti.timer + 4.3 < globals.realtime() then
            table.remove(notify_lol,i)
        end
    end
end

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}

local function aim_hit(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    if ui.get(menu.visuals.logs.ref) then
        new_notify(string.format("Hit %s in the %s for %d damage (%d health remaining)", entity.get_player_name(e.target), group, e.damage, entity.get_prop(e.target, "m_iHealth") ), 255,255,255,255)
    end
end

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}

local function aim_miss(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    if ui.get(menu.visuals.logs.ref) then
        new_notify(string.format("Missed %s (%s) due to %s", entity.get_player_name(e.target), group, e.reason), 255,255,255,255)
    end
end

local alpha_arrows = 0
visuals.arrows = function(e)
    local local_player = entity.get_local_player()
    if local_player == nil or entity.is_alive(local_player) == false then return end
    local bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    local screen = {client.screen_size()}
    screen.x = screen[1]
    screen.y = screen[2]
    local x,y = screen.x, screen.y
    local r,g,b,a = unpack({menu.visuals.arrows:get_color()})
    local arrows_color = {r = r,g = g,b = b,a = a}
    local manuals = antiaim.manuals()

    if ui.get(menu.visuals.arrows.ref) then
        if ui.get(menu.visuals.arrows_type.ref) == "Standart" then
            alpha_arrows = (manuals == 2 or manuals == 1) and helpers.lerp(alpha_arrows, 255, globals.frametime() * 20) or helpers.lerp(alpha_arrows, 0, globals.frametime() * 20)
            renderer.text(x / 2 + 45, y / 2 - 2.5, manuals == 2 and arrows_color.r or 200, manuals == 2 and arrows_color.g or 200, manuals == 2 and arrows_color.b or 200, alpha_arrows, "c+", 0, '>')
            renderer.text(x / 2 - 45, y / 2 - 2.5, manuals == 1 and arrows_color.r or 200, manuals == 1 and arrows_color.g or 200, manuals == 1 and arrows_color.b or 200, alpha_arrows, "c+", 0, '<')
        end

        if ui.get(menu.visuals.arrows_type.ref) == "Teamskeet" then
            renderer.triangle(x / 2 + 55, y / 2 + 2, x / 2 + 42, y / 2 - 7, x / 2 + 42, y / 2 + 11, 
            manuals == 2 and arrows_color.r or 25, 
            manuals == 2 and arrows_color.g or 25, 
            manuals == 2 and arrows_color.b or 25, 
            manuals == 2 and arrows_color.a or 160)

            renderer.triangle(x / 2 - 55, y / 2 + 2, x / 2 - 42, y / 2 - 7, x / 2 - 42, y / 2 + 11, 
            manuals == 1 and arrows_color.r or 25, 
            manuals == 1 and arrows_color.g or 25, 
            manuals == 1 and arrows_color.b or 25, 
            manuals == 1 and arrows_color.a or 160)
        
            renderer.rectangle(x / 2 + 38, y / 2 - 7, 2, 18, 
            bodyYaw < -10 and arrows_color.r or 25,
            bodyYaw < -10 and arrows_color.g or 25,
            bodyYaw < -10 and arrows_color.b or 25,
            bodyYaw < -10 and arrows_color.a or 160)
            renderer.rectangle(x / 2 - 40, y / 2 - 7, 2, 18,			
            bodyYaw > 10 and arrows_color.r or 25,
            bodyYaw > 10 and arrows_color.g or 25,
            bodyYaw > 10 and arrows_color.b or 25,
            bodyYaw > 10 and arrows_color.a or 160)
        end

        if ui.get(menu.visuals.arrows_type.ref) == "Velocity" then
            local vel = get_velocity()/4
            renderer.triangle(x / 2 + 55 + vel, y / 2 + 2, x / 2 + 42 + vel, y / 2 - 7, x / 2 + 42 + vel, y / 2 + 11, 
            manuals == 2 and arrows_color.r or 25, 
            manuals == 2 and arrows_color.g or 25, 
            manuals == 2 and arrows_color.b or 25, 
            manuals == 2 and arrows_color.a or 160)

            renderer.triangle(x / 2 - 55 - vel, y / 2 + 2, x / 2 - 42 - vel, y / 2 - 7, x / 2 - 42 - vel, y / 2 + 11, 
            manuals == 1 and arrows_color.r or 25, 
            manuals == 1 and arrows_color.g or 25, 
            manuals == 1 and arrows_color.b or 25, 
            manuals == 1 and arrows_color.a or 160)
        
            renderer.rectangle(x / 2 + 38 + vel, y / 2 - 7, 2, 18, 
            bodyYaw < -10 and arrows_color.r or 25,
            bodyYaw < -10 and arrows_color.g or 25,
            bodyYaw < -10 and arrows_color.b or 25,
            bodyYaw < -10 and arrows_color.a or 160)
            renderer.rectangle(x / 2 - 40 - vel, y / 2 - 7, 2, 18,			
            bodyYaw > 10 and arrows_color.r or 25,
            bodyYaw > 10 and arrows_color.g or 25,
            bodyYaw > 10 and arrows_color.b or 25,
            bodyYaw > 10 and arrows_color.a or 160)
        end
    end
end

math.dist_to_2d = function(pos1, pos2)
    local dx = pos1[1] - pos2.x
    local dy = pos1[2] - pos2.y
    return math.sqrt(dx * dx + dy * dy)
end

local alpha_arrows = 0
local dragging_DEBUG = dragging_fn('Debug box', 1, 1)
visuals.debug_box = function(e)
    if ui.get(menu.visuals.debug_box.ref) == false then return end
    local local_player = entity.get_local_player()
    if local_player == nil or entity.is_alive(local_player) == false then return end
    local screen = {client.screen_size()}
    --screen.x = screen[1]
    --screen.y = screen[2]
    --local x,y = screen.x, screen.y
    local x, y = dragging_DEBUG:get()
    local r,g,b,a = unpack({menu.visuals.debug_box:get_color()})

    local icon = renderer.load_svg([[<svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="1080.000000pt" height="1080.000000pt" viewBox="0 0 1080.000000 1080.000000" preserveAspectRatio="xMidYMid meet"> <g transform="translate(0.000000,1080.000000) scale(0.100000,-0.100000)" fill="white" stroke="none"> <path d="M5085 10747 c-33 -18 -143 -76 -245 -129 -102 -53 -230 -119 -285 -148 -55 -29 -183 -95 -285 -147 -102 -53 -225 -117 -275 -143 -123 -65 -270 -142 -460 -240 -159 -82 -293 -152 -475 -247 -52 -28 -176 -92 -275 -143 -99 -51 -211 -110 -250 -130 -38 -21 -137 -73 -220 -115 -356 -184 -509 -264 -755 -392 -52 -28 -171 -90 -265 -138 -154 -79 -264 -137 -455 -237 -96 -51 -109 -60 -113 -83 -10 -59 -85 -19 2198 -1160 1570 -785 2187 -1089 2232 -1099 52 -12 71 -12 125 -1 50 11 562 263 2328 1147 2388 1195 2315 1156 2284 1205 -6 10 -35 30 -65 45 -62 32 -464 227 -614 298 -97 46 -223 107 -525 253 -80 38 -203 98 -275 132 -191 91 -359 173 -540 260 -88 43 -214 103 -280 135 -118 57 -251 120 -495 238 -69 33 -201 97 -295 142 -169 82 -330 159 -520 250 -55 26 -203 98 -330 160 -126 61 -255 123 -285 137 -30 14 -129 61 -219 104 -158 76 -166 79 -235 79 -61 -1 -79 -5 -131 -33z" fill="white"/> <path d="M7831 7037 c-2523 -1262 -2403 -1198 -2416 -1288 -3 -24 -5 -1288 -3 -2809 3 -2688 4 -2766 22 -2802 25 -47 78 -70 136 -57 55 12 4588 2280 4623 2313 61 57 57 -168 57 2931 0 2822 0 2835 -20 2855 -11 11 -32 20 -47 20 -17 0 -965 -469 -2352 -1163z" fill="white"/> <path d="M620 7959 c-16 -10 -37 -30 -47 -46 -17 -26 -18 -144 -21 -2718 -2 -1889 0 -2701 8 -2727 6 -20 25 -51 42 -68 21 -22 698 -365 2122 -1077 1150 -575 2107 -1050 2126 -1055 109 -30 141 -20 162 51 11 38 13 514 13 2758 l0 2712 -38 39 c-31 32 -419 229 -2130 1086 -2260 1132 -2166 1088 -2237 1045z " fill="white"/> </g> </svg> ]],1080,1080)

    --get_weapon
    local player_weapon = entity.get_classname(entity.get_player_weapon(local_player))
    local ping = tostring(math.floor(client.latency()*1000+0.5))
    local bodyYaw = math.floor(entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60)
    local side = bodyYaw > 10 and "right" or "left"
    local state = antiaim.get_state_name(get_velocity())


    visuals.glow_module(x, y, 135, 80, 14, 6, {r,g,b,a-165}, {13,13,13,200})
    renderer.texture(icon, x + 5, y + 5, 16, 16, r,g,b,a, "f")

    local gradient_text = helpers.calculateGradient(("Black Sector ~ debug"), {color(255,255,255), color(r, g, b)}, 2)
    renderer.text(x + 25, y + 6, 255,255,255,255, "", nil, gradient_text)
    renderer.text(x + 7, y + 24, 255,255,255,255, "", nil, "weapon: " .. (player_weapon:lower():gsub("hkp2000", "usp-s"):gsub("cdeagle", "deagle"):gsub("cweapon", ""):gsub("cknife", "knife")))
    renderer.text(x + 6, y + 37, 255,255,255,255, "", nil, "side: " .. side .. " (" .. bodyYaw .. ")")
    renderer.text(x + 6, y + 50, 255,255,255,255, "", nil, "state: " .. state:lower())
    renderer.text(x + 6, y + 62, 255,255,255,255, "", nil, "ping: " .. ping)

    dragging_DEBUG:drag(135, 80)
end

visuals.damage_indicator = function()
    local screen = {client.screen_size()}
    if ui.get(menu.visuals.min_indicator.ref) and ui.get(refs.dmg[1]) and ui.get(refs.dmg[2]) then
        local dmg = ui.get(refs.dmg[3])
        renderer.text(screen[1] / 2 + 2, screen[2] / 2 - 14, 255, 255, 255, 255, "d", 0, dmg)
    end
end

------------------------------------------------------------------------------

client.set_event_callback('paint_ui', function()
    if ui.get(menu.visuals.watermark.ref) then return end
    local icon = renderer.load_svg([[<svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="1080.000000pt" height="1080.000000pt" viewBox="0 0 1080.000000 1080.000000" preserveAspectRatio="xMidYMid meet"> <g transform="translate(0.000000,1080.000000) scale(0.100000,-0.100000)" fill="white" stroke="none"> <path d="M5085 10747 c-33 -18 -143 -76 -245 -129 -102 -53 -230 -119 -285 -148 -55 -29 -183 -95 -285 -147 -102 -53 -225 -117 -275 -143 -123 -65 -270 -142 -460 -240 -159 -82 -293 -152 -475 -247 -52 -28 -176 -92 -275 -143 -99 -51 -211 -110 -250 -130 -38 -21 -137 -73 -220 -115 -356 -184 -509 -264 -755 -392 -52 -28 -171 -90 -265 -138 -154 -79 -264 -137 -455 -237 -96 -51 -109 -60 -113 -83 -10 -59 -85 -19 2198 -1160 1570 -785 2187 -1089 2232 -1099 52 -12 71 -12 125 -1 50 11 562 263 2328 1147 2388 1195 2315 1156 2284 1205 -6 10 -35 30 -65 45 -62 32 -464 227 -614 298 -97 46 -223 107 -525 253 -80 38 -203 98 -275 132 -191 91 -359 173 -540 260 -88 43 -214 103 -280 135 -118 57 -251 120 -495 238 -69 33 -201 97 -295 142 -169 82 -330 159 -520 250 -55 26 -203 98 -330 160 -126 61 -255 123 -285 137 -30 14 -129 61 -219 104 -158 76 -166 79 -235 79 -61 -1 -79 -5 -131 -33z" fill="white"/> <path d="M7831 7037 c-2523 -1262 -2403 -1198 -2416 -1288 -3 -24 -5 -1288 -3 -2809 3 -2688 4 -2766 22 -2802 25 -47 78 -70 136 -57 55 12 4588 2280 4623 2313 61 57 57 -168 57 2931 0 2822 0 2835 -20 2855 -11 11 -32 20 -47 20 -17 0 -965 -469 -2352 -1163z" fill="white"/> <path d="M620 7959 c-16 -10 -37 -30 -47 -46 -17 -26 -18 -144 -21 -2718 -2 -1889 0 -2701 8 -2727 6 -20 25 -51 42 -68 21 -22 698 -365 2122 -1077 1150 -575 2107 -1050 2126 -1055 109 -30 141 -20 162 51 11 38 13 514 13 2758 l0 2712 -38 39 c-31 32 -419 229 -2130 1086 -2260 1132 -2166 1088 -2237 1045z " fill="white"/> </g> </svg> ]],1080,1080)
    local r,g,b,a = unpack({menu.visuals.watermark:get_color()})
    renderer.texture(icon, 10, 10, 20, 20, r,g,b, 255, "f")
    local gradient_text = helpers.calculateGradient("B L A C K  S E C T O R", {color(255,255,255), color(r,g,b)}, 2)
    renderer.text(35, 14, 255, 255, 255, 255, "", 0, gradient_text)
end)

client.set_event_callback("paint_ui", menu.hide_default)
client.set_event_callback("paint_ui", menu.gradient_texts)
client.set_event_callback("paint_ui", menu.set_visibles_custom)
client.set_event_callback("setup_command", antiaim.main)
client.set_event_callback('paint', misc.lagcomp_paint)
client.set_event_callback('net_update_end', misc.lagcomp_net)
client.set_event_callback("net_update_start", misc.resolver.execute)
client.set_event_callback('paint_ui', misc.backtrack)
client.set_event_callback('paint', visuals.watermark)
client.set_event_callback("setup_command", misc.fast_ladder)
client.set_event_callback('paint', visuals.indicators)
client.set_event_callback('paint', visuals.defensive_indicator)
client.set_event_callback('paint_ui', visuals.notify)
client.set_event_callback("aim_miss", aim_miss)
client.set_event_callback("aim_hit", aim_hit)
client.set_event_callback('paint', clantag.executer)
client.set_event_callback('paint', visuals.debug_box)
client.set_event_callback('paint', visuals.arrows)
client.set_event_callback('paint', visuals.damage_indicator)