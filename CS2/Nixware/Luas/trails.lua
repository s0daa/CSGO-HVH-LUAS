-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

--gui
local settingList = {}

local font24 = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 24)
local font14 = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 14)

function newBoolean(name, vaule)
	s = {}
	s.type = "boolean"
	s.name = name
	s.vaule = vaule
    table.insert(settingList, s)
	return s
end

function newSlider(name, vaule, minVaule, maxVaule, increment)
	s = {}
	s.type = "int"
	s.name = name
	s.vaule = vaule
	s.minVaule = minVaule
	s.maxVaule = maxVaule
	s.increment = increment
    table.insert(settingList, s)
	return s
end


function newText(text)
	s = {}
	s.type = "text"
	s.text = text
    table.insert(settingList, s)
	return s
end

local guiX = 10
local guiY = 10
local width = 300
local height = 470
local isGuiOpen = true
local isDragging = false
local dragX = 0
local dragY = 0

function round(exact, quantum)
    local quant,frac = math.modf(exact/quantum)
    return quantum * (quant + (frac > 0.5 and 1 or 0))
end

ffi.cdef[[
    typedef struct {
        long x;
        long y;
    } POINT;

    int GetCursorPos(POINT* lpPoint);
    int ScreenToClient(void* hWnd, POINT* lpPoint);
    short GetAsyncKeyState(int vKey);
    void* GetForegroundWindow();

    unsigned long GetTickCount();

    static const int VK_INSERT = 0x2D;
    static const int VK_LBUTTON = 0x01;
    static const int VK_UP = 0x26;
    static const int VK_DOWN = 0x28;
    static const int VK_PRIOR = 0x21; // Page Up
    static const int VK_NEXT = 0x22;  // Page Down
	
	typedef struct Vector {
        float x, y, z;
    } Vector;

]]
local user32 = ffi.load("user32")
local kernel32 = ffi.load("kernel32")

local VK_INSERT = 0x2D
local VK_LBUTTON = 0x01
local VK_UP = 0x26
local VK_DOWN = 0x28
local VK_PRIOR = 0x21 
local VK_NEXT = 0x22  
local prev_insert_down = false
local prev_mouse_down = false

local function get_mouse_pos()
    local point = ffi.new("POINT[1]")
    user32.GetCursorPos(point)
    local hwnd = user32.GetForegroundWindow()
    user32.ScreenToClient(hwnd, point)
    return vec2_t(point[0].x, point[0].y)
end

local function interpolate(old, new, vaule)
	return (old + (new-old) * vaule)
end

local function Clamp(flValue, flMin, flMax)
    return math.max(flMin, math.min(flValue, flMax))
end

local function is_key_pressed(vk_key)
    return bit.band(user32.GetAsyncKeyState(vk_key), 0x8000) ~= 0
end

local function is_key_down(vk_key)
    return user32.GetAsyncKeyState(vk_key) < 0
end


local renderGui = function()
    local insert_down = is_key_pressed(VK_INSERT)
    if insert_down and not prev_insert_down then
        isGuiOpen = not isGuiOpen
    end
    prev_insert_down = insert_down

    if not isGuiOpen then
        return
    end
	
	 local mouse_pos = get_mouse_pos()
    local mouse_down = is_key_pressed(VK_LBUTTON)
    local mouse_click = mouse_down and not prev_mouse_down
	
	
	
	if mouse_click then
        if mouse_pos.x >= guiX and mouse_pos.x <= guiX + width and mouse_pos.y >= guiY and mouse_pos.y <= (guiY + 40) then
            isDragging = true
            dragX = mouse_pos.x - guiX
            dragY = mouse_pos.y - guiY
        end
    end

    if not mouse_down then
        isDragging = false
    end

    if isDragging then
        guiX = mouse_pos.x - dragX
        guiY = mouse_pos.y - dragY
    end

    prev_mouse_down = mouse_down

    local x = guiX
    local y = guiY
	
    render.rect_filled(vec2_t(x , y ), vec2_t(x + width, y + height), color_t(24 / 255, 24 / 255, 24 / 255, 1), 8)
	
	render.text(get_script_name(), font24, vec2_t(x + 10, y + 10), color_t(1, 1, 1, 1))
	y = y + 42
	render.rect_filled(vec2_t(x , y ), vec2_t(x + width, y + 2), color_t(34 / 255, 34 / 255, 34 / 255, 1), 8)
	y = y + 8
	for i = 1, #settingList do
		if settingList[i].type == "text" then 
			render.text(settingList[i].text, font14, vec2_t(x + 10, y), color_t(1, 1, 1, 1))
			y = y + 35
		end
		if settingList[i].type == "boolean" then 
			render.text(settingList[i].name, font14, vec2_t(x + 10, y), color_t(1, 1, 1, 1))
			render.rect_filled(vec2_t((x + width) - 30 - 5, y ), vec2_t((x + width) - 15 - 5, y + 15), color_t(34 / 255, 34 / 255, 34 / 255, 1), 4)
			
			if settingList[i].vaule == true then 
				render.rect_filled(vec2_t((x + width) - 30 - 5, y ), vec2_t((x + width) - 15 - 5, y + 15), color_t(34 / 255, 34 / 255, 200 / 255, 1), 4)
			end
			if mouse_click then
				if mouse_pos.x >= (x + width) - 30 - 5  and mouse_pos.x <= (x + width) - 15 - 5 and mouse_pos.y >= y and mouse_pos.y <= (y + 15) then
					settingList[i].vaule = not settingList[i].vaule
				end
			end
			y = y + 35
		end
		if settingList[i].type == "int" then 
			render.text(settingList[i].name, font14, vec2_t(x + 10, y), color_t(1, 1, 1, 1))
			
			render.rect_filled(vec2_t((x + width) - 180 - 5, y ), vec2_t((x + width) - 15 - 5, y + 15), color_t(34 / 255, 34 / 255, 34 / 255, 1), 4)
			
			local valMax = ((x + width) - 15 - 5) - ((x + width) - 180 - 5)
			local valPerPixel = valMax / (settingList[i].maxVaule)

			local val = (valPerPixel * settingList[i].vaule)
			
			render.rect_filled(vec2_t((x + width) - 180 - 5, y ), vec2_t((x + width) - 180 - 5 + val, y + 15), color_t(34 / 255, 34 / 255, 200 / 255, 1), 4)
			if mouse_down then 
				if mouse_pos.x >= (x + width) - 180 - 5  and mouse_pos.x <= (x + width) - 15 - 5 and mouse_pos.y >= y and mouse_pos.y <= (y + 15) then
					local pX = ((x + width) - 180 - 5)
					local pWidth = ((x + width) - 15 - 5) - pX
				
			
					local vaule = interpolate(settingList[i].minVaule, settingList[i].maxVaule, Clamp(( mouse_pos.x - pX) / pWidth, 0, 1))
					settingList[i].vaule = round(vaule, settingList[i].increment)
					
				end
			end
			
			render.text(settingList[i].vaule, font14, vec2_t(((x + width) - 90 - 5) - render.calc_text_size(settingList[i].vaule, font14).x, y), color_t(1, 1, 1, 1))
			
			y = y + 35
		end
	end
end

register_callback("paint", renderGui)



--script

local enabled = newBoolean("Enabled", false)
local lifetime = newSlider("Lifetime",45, 10, 250, 1)
local size = newSlider("Size",2, 0, 5, 0.1)
local interval = newSlider("Interval",5, 1, 30, 1)
local textCol1 = newText("Color 1")
local col1Red = newSlider("Red",255, 0, 255, 1)
local col1Green = newSlider("Green",120, 0, 255, 1)
local col1Blue = newSlider("Blue",120, 0, 255, 1)
local textCol2 = newText("Color 2")
local col2Red = newSlider("Red",120, 0, 255, 1)
local col2Green = newSlider("Green",120, 0, 255, 1)
local col2Blue = newSlider("Blue",255, 0, 255, 1)

local points = {}
local currentTime = 0;

function newPoint(position)
	s = {}
	s.pos = position
	s.lifetime = lifetime.vaule * 1.5
    table.insert(points, s)
	return s
end


local arrSchema = {
    nFlags = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_fFlags"),
    nHeatlh = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iHealth"),
    nMoveType = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_MoveType"),
    nLifeState = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_lifeState"),
    vecVelocity = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_vecVelocity"),
    flWaterLevel = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_flWaterLevel")
}

local NULLPTR = ffi.cast("void*", 0)



local m_vecAbsOrigin = engine.get_netvar_offset("client.dll", "CGameSceneNode", "m_vecAbsOrigin");
local m_pGameSceneNode = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_pGameSceneNode");

local GetPlayerPosition = function(pLocalPawn)
        local GameSceneNode = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pGameSceneNode)[0];
        if not GameSceneNode or GameSceneNode == 0 then return vec3_t(0,0,0) end;
        local vecAbsOrigin = ffi.cast("struct Vector*", ffi.cast("uintptr_t", GameSceneNode) + m_vecAbsOrigin)[0];
        
        return vec3_t(vecAbsOrigin.x, vecAbsOrigin.y, vecAbsOrigin.z);
end;

local function GetField(pEntity, szName, szType)
    if not pEntity or pEntity == NULLPTR then
        return false
    end

    if not arrSchema[szName] then
        return false
    end

    return ffi.cast(("%s*"):format(szType), ffi.cast("uintptr_t", pEntity) + arrSchema[szName])[0]
end

local function IsAlive(pEntity)
    if not pEntity or pEntity == NULLPTR then
        return false
    end

    local nHealth = GetField(pEntity, "nHeatlh", "int")
    local nLifeState = GetField(pEntity, "nLifeState", "uint8_t")
    return nLifeState == 0 and nHealth > 0
end

function mod(a, b)
    return a - (math.floor(a/b)*b)
end

function interpolateColor(color1, color2, t, i)
    t = math.max(0, math.min(1, t))

    local r = color1.r + (color2.r - color1.r) * t
    local g = color1.g + (color2.g - color1.g) * t
    local b = color1.b + (color2.b - color1.b) * t

    return color_t(r,g,b,(points[i].lifetime / lifetime.vaule))
end

local fnPaint = function()
	currentTime = currentTime + 1;

	local pLocalPawn = entitylist.get_local_player_pawn()
    if not pLocalPawn or not IsAlive(pLocalPawn[0]) then
        return
    end
	if not enabled.vaule then
		return
	end
	if (mod(currentTime, interval.vaule) == 0)  then 
		newPoint(GetPlayerPosition(pLocalPawn))
	end
	for i = 1, #points do
		if points[i] ==  nil then
			return
		end
		if points[i].lifetime <= 0 then
			table.remove(points,i)
		end
	
		local color1 = color_t(col1Red.vaule / 255, col1Green.vaule / 255, col1Blue.vaule / 255, 1)
		local color2 = color_t(col2Red.vaule / 255, col2Green.vaule / 255, col2Blue.vaule / 255, 1)
		render.circle_filled_3d(points[i].pos, size.vaule, interpolateColor(color1, color2, (points[i].lifetime / lifetime.vaule), i))
		points[i].lifetime = points[i].lifetime - 1
	end

	
end





register_callback("paint", fnPaint)