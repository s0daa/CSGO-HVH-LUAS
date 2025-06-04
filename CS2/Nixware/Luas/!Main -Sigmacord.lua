local settingList = {}
local font14 = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 11)
local function newSetting(type, name, value, minValue, maxValue, increment, text, callback)
    local s = {
        type = type,
        name = name, 
        value = value,
        minValue = minValue,
        maxValue = maxValue,
        increment = increment,
        text = text,
        callback = callback
    }
    table.insert(settingList, s)
    return s
end
local function newBoolean(name, value)
    return newSetting("boolean", name, value)
end
local function newSlider(name, value, minValue, maxValue, increment)
    return newSetting("int", name, value, minValue, maxValue, increment)
end
local function newText(text)
    return newSetting("text", nil, nil, nil, nil, nil, text)
end
local function newKeybind(name, callback)
    return newSetting("keybind", name, "none", nil, nil, nil, nil, callback)
end
local gui = {
    x = 320, y = 320,
    width = 200, height = 420,
    isOpen = true,
    isDragging = false,
    dragOffset = {x = 0, y = 0},
    waitingForKey = false,
    activeKeybind = nil
}
local function round(exact, quantum)
    local quant = math.floor(exact/quantum)
    return quantum * (quant + (exact/quantum - quant > 0.5 and 1 or 0))
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
    static const int VK_PRIOR = 0x21;
    static const int VK_NEXT = 0x22;
    typedef struct Vector {
        float x, y, z;
    } Vector;
]]
local user32 = ffi.load("user32")
local kernel32 = ffi.load("kernel32")
local VK = {INSERT = 0x2D, LBUTTON = 0x01, UP = 0x26, DOWN = 0x28, PRIOR = 0x21, NEXT = 0x22}
local prev = {insert = false, mouse = false}
local function get_mouse_pos()
    local point = ffi.new("POINT[1]")
    user32.GetCursorPos(point)
    user32.ScreenToClient(user32.GetForegroundWindow(), point)
    return vec2_t(point[0].x, point[0].y)
end
local function lerp(a, b, t) return a + (b - a) * t end
local function clamp(val, min, max) return math.max(min, math.min(val, max)) end
local function is_key_pressed(key) return bit.band(user32.GetAsyncKeyState(key), 0x8000) ~= 0 end
local function get_key_name(vKey)
    local keyNames = {
        [0x01] = "M1", [0x02] = "M2", [0x04] = "M3", [0x05] = "M4", [0x06] = "M5",
        [0x08] = "BACKSPACE", [0x09] = "TAB", [0x0D] = "ENTER", [0x10] = "SHIFT",
        [0x11] = "CTRL", [0x12] = "ALT", [0x14] = "CAPS", [0x1B] = "ESC",
        [0x20] = "SPACE", [0x25] = "LEFT", [0x26] = "UP", [0x27] = "RIGHT",
        [0x28] = "DOWN", [0x2D] = "INS", [0x2E] = "DEL"
    }
    if keyNames[vKey] then return keyNames[vKey] end
    local char = string.char(vKey)
    if char:match("%w") then return char end
    return string.format("0x%02X", vKey)
end
local key_states = {}
local function check_keys()
    if not gui.waitingForKey then return end
    for i = 1, 255 do
        if i ~= VK.LBUTTON and i ~= VK.RBUTTON and is_key_pressed(i) then
            gui.waitingForKey = false
            if gui.activeKeybind then
                gui.activeKeybind.value = i
            end
            return
        end
    end
end
local function renderGui()
    local insert_down = is_key_pressed(VK.INSERT)
    if insert_down and not prev.insert then gui.isOpen = not gui.isOpen end
    prev.insert = insert_down
    if not gui.isOpen then engine.execute_client_cmd("bind MOUSE1 +attack") return end
    check_keys()
    local mouse = {pos = get_mouse_pos(), down = is_key_pressed(VK.LBUTTON), click = false}
    mouse.click = mouse.down and not prev.mouse
    local isMouseOverMenu = mouse.pos.x >= gui.x and mouse.pos.x <= gui.x + gui.width and 
                           mouse.pos.y >= gui.y and mouse.pos.y <= gui.y + gui.height
    if isMouseOverMenu then engine.execute_client_cmd("unbind mouse1")
    else engine.execute_client_cmd("bind MOUSE1 +attack") end
    if mouse.click then
        local isOverControl = false
        for i, setting in ipairs(settingList) do
            if setting.type ~= "text" then
                local controlX = gui.x + gui.width - (setting.type == "boolean" and 20 or (setting.type == "keybind" and 60 or 140))
                local controlY = gui.y + 8 + (i-1) * 28
                local controlWidth = setting.type == "boolean" and 12 or (setting.type == "keybind" and 52 or 132)
                if mouse.pos.x >= controlX and mouse.pos.x <= controlX + controlWidth and
                   mouse.pos.y >= controlY and mouse.pos.y <= controlY + 12 then
                    isOverControl = true
                    if setting.type == "keybind" then
                        gui.waitingForKey = true
                        gui.activeKeybind = setting
                    end
                end
            end
        end
        if not isOverControl and isMouseOverMenu then
            gui.isDragging = true
            gui.dragOffset.x = mouse.pos.x - gui.x
            gui.dragOffset.y = mouse.pos.y - gui.y
        end
    end
    if not mouse.down then gui.isDragging = false end
    if gui.isDragging then
        gui.x = mouse.pos.x - gui.dragOffset.x
        gui.y = mouse.pos.y - gui.dragOffset.y
    end
    prev.mouse = mouse.down
    render.rect_filled(vec2_t(gui.x, gui.y), vec2_t(gui.x + gui.width, gui.y + gui.height), color_t(24/255, 24/255, 24/255, 1), 0)
    
    local y = gui.y + 8
    for i, setting in ipairs(settingList) do
        if setting.type == "text" then
            render.text(setting.text, font14, vec2_t(gui.x + 8, y), color_t(1, 1, 1, 1))
        elseif setting.type == "boolean" then
            render.text(setting.name, font14, vec2_t(gui.x + 8, y), color_t(1, 1, 1, 1))
            local boxX, boxY = gui.x + gui.width - 20, y
            render.rect_filled(vec2_t(boxX, boxY), vec2_t(boxX + 12, boxY + 12),
                             color_t(setting.value and 1 or 34/255, setting.value and 1 or 34/255, setting.value and 1 or 34/255, 1), 0)
            if mouse.click and mouse.pos.x >= boxX and mouse.pos.x <= boxX + 12 and 
               mouse.pos.y >= boxY and mouse.pos.y <= boxY + 12 then
                setting.value = not setting.value
            end
        elseif setting.type == "keybind" then
            render.text(setting.name, font14, vec2_t(gui.x + 8, y), color_t(1, 1, 1, 1))
            local bindX, bindY = gui.x + gui.width - 60, y
            render.rect_filled(vec2_t(bindX, bindY), vec2_t(bindX + 52, bindY + 12),
                             color_t(34/255, 34/255, 34/255, 1), 0)
            local text = gui.waitingForKey and setting == gui.activeKeybind and "..." or 
                        (setting.value == "none" and "none" or get_key_name(setting.value))
            render.text(text, font14, vec2_t(bindX + 26 - render.calc_text_size(text, font14).x/2, y), color_t(1, 1, 1, 1))
        elseif setting.type == "int" then
            render.text(setting.name, font14, vec2_t(gui.x + 8, y), color_t(1, 1, 1, 1))
            local sliderX, sliderY = gui.x + gui.width - 140, y
            local sliderWidth = 132
            render.rect_filled(vec2_t(sliderX, sliderY), vec2_t(sliderX + sliderWidth, sliderY + 12),
                             color_t(34/255, 34/255, 34/255, 1), 0)
            local progress = (setting.value - setting.minValue) / (setting.maxValue - setting.minValue)
            render.rect_filled(vec2_t(sliderX, sliderY), vec2_t(sliderX + sliderWidth * progress, sliderY + 12),
                             color_t(40/255, 40/255, 40/255, 1), 0)
            if mouse.down and mouse.pos.x >= sliderX and mouse.pos.x <= sliderX + sliderWidth and
               mouse.pos.y >= sliderY and mouse.pos.y <= sliderY + 12 then
                local t = clamp((mouse.pos.x - sliderX) / sliderWidth, 0, 1)
                setting.value = round(lerp(setting.minValue, setting.maxValue, t), setting.increment)
            end
            local valueText = tostring(setting.value)
            render.text(valueText, font14, vec2_t(sliderX + sliderWidth/2 - render.calc_text_size(valueText, font14).x/2, y),
                       color_t(1, 1, 1, 1))
        end
        y = y + 28
    end
end
register_callback("paint", renderGui)
local thirdperson = newSlider("3rdpers", 100, 1, 150, 1)
register_callback("paint", function()
    engine.execute_client_cmd("cam_idealdist " .. thirdperson.value)
end)
local fov = newSlider("Fov", 90, 1, 150, 1)
local m_iDesiredFOV = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_iDesiredFOV")
register_callback("paint", function()
    local controller = entitylist.get_local_player_controller()
    if controller then
        ffi.cast("int*", controller[m_iDesiredFOV])[0] = fov.value
    end
end)
local maa = newBoolean("Custom AA", false)
local indicator = newBoolean("Indicators for AA", false)
local current_yaw_offset = 180
local yaw_states = {left = false, right = false}
local pitch_offset = 1
local function handle_key(key, held)
    if not key_states[key] then key_states[key] = false end
    if held ~= key_states[key] then
        if held and key.callback then
            key.callback()
        end
        key_states[key] = held
    end
end
local left_key = newKeybind("Left", function()
    if not maa.value then return end
    yaw_states.left = not yaw_states.left
    yaw_states.right = false
    current_yaw_offset = yaw_states.left and 90 or 180
    menu.ragebot_anti_aim_base_yaw_offset = current_yaw_offset
end)
local right_key = newKeybind("Right", function()
    if not maa.value then return end
    yaw_states.right = not yaw_states.right
    yaw_states.left = false
    current_yaw_offset = yaw_states.right and -90 or 180
    menu.ragebot_anti_aim_base_yaw_offset = current_yaw_offset
end)
local pitch_key = newKeybind("Pitch Zero", function()
    pitch_offset = (pitch_offset == 1) and 0 or 1
    menu.ragebot_anti_aim_pitch = pitch_offset
end)
register_callback("paint", function()
    if not maa.value then return end
    for _, setting in ipairs(settingList) do
        if setting.type == "keybind" and setting.value ~= "none" then
            handle_key(setting, is_key_pressed(setting.value))
        end
    end
    if not indicator.value then return end
    local vecScreenSize = {x = 1920, y = 1080}
    local center_x = vecScreenSize.x / 2
    local center_y = vecScreenSize.y / 2
    local vertical_offset = -7
    local horizontal_offset = 20
    local thickness = 2
    local height = 15
    local colAlpha = color_t(1, 1, 1, 0.7)
    local colMain = color_t(0, 0, 1, 1)
    if current_yaw_offset == 90 then
        render.rect_filled_fade(vec2_t(center_x - horizontal_offset, center_y + vertical_offset), 
                              vec2_t(center_x - horizontal_offset + thickness, center_y + vertical_offset + height), 
                              colAlpha, colAlpha, colMain, colMain)
    elseif current_yaw_offset == -90 then
        render.rect_filled_fade(vec2_t(center_x + horizontal_offset, center_y + vertical_offset), 
                              vec2_t(center_x + horizontal_offset + thickness, center_y + vertical_offset + height), 
                              colAlpha, colAlpha, colMain, colMain)
    end
end)
register_callback("unload", function()
    menu.ragebot_anti_aim_base_yaw_offset = 180
    menu.ragebot_anti_aim_pitch = 1
end)
local scope = newBoolean("Custom Scope", false)
local Abs = function(addr, pre, post)
    addr = addr + (pre or 1)
    addr = addr + ffi.sizeof("int") + ffi.cast("int64_t", ffi.cast("int*", addr)[0])
    addr = addr + (post or 0)
    return addr
end;
assert(ffi, "syr1337 hook lib error: ffi is not open, please open ffi");
if not pcall(ffi.sizeof, "struct Thread32Entry") then
        ffi.cdef([[
            typedef struct Thread32Entry {
                uint32_t dwSize;
                uint32_t cntUsage;
                uint32_t th32ThreadID;
                uint32_t th32OwnerProcessID;
                long tpBasePri;
                long tpDeltaPri;
                uint32_t dwFlags;
            } Thread32Entry;
            int CloseHandle(void*);
            uint32_t ResumeThread(void*);
            uint32_t GetCurrentThreadId();
            uint32_t SuspendThread(void*);
            uint32_t GetCurrentProcessId();
            void* OpenThread(uint32_t, int, uint32_t);
            void* GetProcAddress(uintptr_t, const char*);
            int Thread32Next(void*, struct Thread32Entry*);
            int Thread32First(void*, struct Thread32Entry*);
            void* CreateToolhelp32Snapshot(uint32_t, uint32_t);
            int VirtualProtect(void*, uint64_t, uint32_t, uint32_t*);
        ]])
end
local vecScreenSize = render.screen_size() * 0.5;
local flAnim = 0.0;
local m_bIsScoped = engine.get_netvar_offset("client.dll", "C_CSPlayerPawn", "m_bIsScoped");
local arrHooks = {}
local arrThreads = {}
local NULLPTR = ffi.cast("void*", 0)
local INVALID_HANDLE = ffi.cast("void*", - 1)
local colMain_ = color_t(1,1,1,1);
local colAlpha = color_t(colMain_.r, colMain_.g, colMain_.b, 0);
local fnDrawScope = Abs(ffi.cast("uintptr_t", find_pattern("client.dll", "E8 ? ? ? ? 80 7C 24 ? ? 74 25")), 1, 0);
local Lerp = function(a, b, t)
    return a + (b - a) * t;
end;
local function Thread(nTheardID)
        local hThread = ffi.C.OpenThread(0x0002, 0, nTheardID)
        if hThread == NULLPTR or hThread == INVALID_HANDLE then
            return false
        end
        return setmetatable({
            bValid = true,
            nId = nTheardID,
            hThread = hThread,
            bIsSuspended = false
        }, {
            __index = {
                Suspend = function(self)
                    if self.bIsSuspended or not self.bValid then
                        return false
                    end
                    if ffi.C.SuspendThread(self.hThread) ~= - 1 then
                        self.bIsSuspended = true
                        return true
                    end
                    return false
                end,
                Resume = function(self)
                    if not self.bIsSuspended or not self.bValid then
                        return false
                    end
                    if ffi.C.ResumeThread(self.hThread) ~= - 1 then
                        self.bIsSuspended = false
                        return true
                    end
                    return false
                end,
                Close = function(self)
                    if not self.bValid then
                        return
                    end
                    self:Resume()
                    self.bValid = false
                    ffi.C.CloseHandle(self.hThread)
                end
            }
        })
end
local function UpdateThreadList()
        arrThreads = {}
        local hSnapShot = ffi.C.CreateToolhelp32Snapshot(0x00000004, 0)
        if hSnapShot == INVALID_HANDLE then
            return false
        end
        local pThreadEntry = ffi.new("struct Thread32Entry[1]")
        pThreadEntry[0].dwSize = ffi.sizeof("struct Thread32Entry")
        if ffi.C.Thread32First(hSnapShot, pThreadEntry) == 0 then
            ffi.C.CloseHandle(hSnapShot)
            return false
        end
        local nCurrentThreadID = ffi.C.GetCurrentThreadId()
        local nCurrentProcessID = ffi.C.GetCurrentProcessId()
        while ffi.C.Thread32Next(hSnapShot, pThreadEntry) > 0 do
            if pThreadEntry[0].dwSize >= 20 and pThreadEntry[0].th32OwnerProcessID == nCurrentProcessID and pThreadEntry[0].th32ThreadID ~= nCurrentThreadID then
                local hThread = Thread(pThreadEntry[0].th32ThreadID)
                if not hThread then
                    for _, pThread in pairs(arrThreads) do
                        pThread:Close()
                    end
                    arrThreads = {}
                    ffi.C.CloseHandle(hSnapShot)
                    return false
                end
                table.insert(arrThreads, hThread)
            end
        end
        ffi.C.CloseHandle(hSnapShot)
        return true
end
local function SuspendThreads()
        if not UpdateThreadList() then
            return false
        end
        for _, hThread in pairs(arrThreads) do
            hThread:Suspend()
        end
        return true
end
local function ResumeThreads()
        for _, hThread in pairs(arrThreads) do
            hThread:Resume()
            hThread:Close()
        end
end
local function CreateHook(pTarget, pDetour, szType)
        assert(type(pDetour) == "function", "syr1337 hook lib error: invalid detour function")
        assert(type(pTarget) == "cdata" or type(pTarget) == "number" or type(pTarget) == "function", "syr1337 hook lib error: invalid target function")
        if not SuspendThreads() then
            ResumeThreads()
            print("syr1337 hook lib error: failed suspend threads")
            return false
        end
        local arrBackUp = ffi.new("uint8_t[14]")
        local pTargetFn = ffi.cast(szType, pTarget)
        local arrShellCode = ffi.new("uint8_t[14]", {
            0xFF, 0x25, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        })
        local __Object = {
            bValid = true,
            bAttached = false,
            pBackup = arrBackUp,
            pTarget = pTargetFn,
            pOldProtect = ffi.new("uint32_t[1]")
        }
        ffi.copy(arrBackUp, pTargetFn, ffi.sizeof(arrBackUp))
        ffi.cast("uintptr_t*", arrShellCode + 0x6)[0] = ffi.cast("uintptr_t", ffi.cast(szType, function(...)
            local bSuccessfully, pResult = pcall(pDetour, __Object, ...)
            if not bSuccessfully then
                __Object:Remove()
                print(("[syr1337 hook lib]: unexception runtime error -> %s"):format(pResult))
                return pTargetFn(...)
            end
            return pResult
        end))
        __Object.__index = setmetatable(__Object, {
            __call = function(self, ...)
                if not self.bValid then
                    return nil
                end
                self:Detach()
                local bSuccessfully, pResult = pcall(self.pTarget, ...)
                if not bSuccessfully then
                    self.bValid = false
                    print(("[syr1337 hook lib]: runtime error -> %s"):format(pResult))
                    return nil
                end
                self:Attach()
                return pResult
            end,
            __index = {
                Attach = function(self)
                    if self.bAttached or not self.bValid then
                        return false
                    end
                    self.bAttached = true
                    ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), 0x40, self.pOldProtect)
                    ffi.copy(self.pTarget, arrShellCode, ffi.sizeof(arrBackUp))
                    ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), self.pOldProtect[0], self.pOldProtect)
                    return true
                end,
                Detach = function(self)
                    if not self.bAttached or not self.bValid then
                        return false
                    end
                    self.bAttached = false
                    ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), 0x40, self.pOldProtect)
                    ffi.copy(self.pTarget, self.pBackup, ffi.sizeof(arrBackUp))
                    ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), self.pOldProtect[0], self.pOldProtect)
                    return true
                end,
                Remove = function(self)
                    if not self.bValid then
                        return false
                    end
                    SuspendThreads()
                    self:Detach()
                    ResumeThreads()
                    self.bValid = false
                end
            }
        })
        __Object:Attach()
        table.insert(arrHooks, __Object)
        ResumeThreads()
        return __Object
end
local flOffset_ = 10;
local flLength_ = 100;
local flAlpha_ = 1.0;
local flOf = newSlider("flOffset", 10, -1000, 1000, 1)
local fle = newSlider("flLength", 100, -1100, 1000, 1)
local flAlpha = newSlider("Transp", 1.0, 0.0, 1.0, 0.1)
	register_callback("paint", function()
    flOffset_ = flOf.value
    flLength_ = fle.value
    flAlpha_ = flAlpha.value
end)
local fnOnPaint = function()
	local pawn = entitylist.get_local_player_pawn();
    if pawn == nil then return end;
    local game_scene_node = pawn.m_pGameSceneNode
    if game_scene_node == nil then return end;
    local weapon_services = pawn.m_pWeaponServices
    if weapon_services == nil then return end;
    local weapon = weapon_services.m_hActiveWeapon
    if weapon == nil then return end;
	if not scope.value then return end;
    local bIsScoped = ffi.cast("bool*", pawn[m_bIsScoped])[0];
    local colMain = color_t(colMain_.r, colMain_.g, colMain_.b, colMain_.a * flAlpha_);
    local colAlphaNew = color_t(colAlpha.r, colAlpha.g, colAlpha.b, colAlpha.a * flAlpha_);
    if bIsScoped then
        local flOffset = flOffset_;
        local flLength = flLength_;
        local sum = (flOffset + flLength);
		render.rect_filled_fade(vec2_t(vecScreenSize.x - flOffset, vecScreenSize.y), vec2_t(vecScreenSize.x - sum, vecScreenSize.y + 1), colAlphaNew, colMain, colMain, colAlphaNew);
        render.rect_filled_fade(vec2_t(vecScreenSize.x + sum, vecScreenSize.y), vec2_t(vecScreenSize.x + flOffset, vecScreenSize.y + 1), colMain, colAlphaNew, colAlphaNew, colMain);
        render.rect_filled_fade(vec2_t(vecScreenSize.x, vecScreenSize.y + sum), vec2_t(vecScreenSize.x + 1, vecScreenSize.y + flOffset), colMain, colMain, colAlphaNew, colAlphaNew);
        render.rect_filled_fade(vec2_t(vecScreenSize.x, vecScreenSize.y - flOffset), vec2_t(vecScreenSize.x + 1, vecScreenSize.y - sum), colAlphaNew, colAlphaNew, colMain, colMain);
    end;
end;
CreateHook(fnDrawScope, function(pObject, pRcx, pUnk) end, "void(__fastcall*)(void*, void*)")
register_callback("paint", fnOnPaint);
register_callback("unload", function() for _, pObject in pairs(arrHooks) do pObject:Remove() end end)
local lknf = newBoolean("Leftknife", false)
local wasSwitching = false
register_callback("paint", function()
    local pawn = entitylist.get_local_player_pawn()
    if not pawn then return end
    local weapon_services = pawn.m_pWeaponServices
    if not weapon_services then return end
    local weapon = weapon_services.m_hActiveWeapon
    if not weapon then return end
    local weapondata = weapon.m_pWeaponData
    if not weapondata then return end
	if not lknf.value then return end
    local weaponPrice = weapondata.m_nPrice
    if weaponPrice == 0 then
        if not wasSwitching then
            engine.execute_client_cmd("switchhandsleft")
            wasSwitching = true
        end
    elseif wasSwitching then
        engine.execute_client_cmd("switchhandsright")
        wasSwitching = false
    end
end)
local hitlg = newBoolean("Hitlog", false)
local accent = color_t(0.8, 1, 0.2588235294117647, 1)
local m_sSanitizedPlayerName = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName")
local m_hOriginalController = engine.get_netvar_offset("client.dll", "C_CSPlayerPawnBase", "m_hOriginalController")
local m_nTickBase = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_nTickBase")
local Verdana = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 12, 16)
local logs = {}
local Lerp = function(a, b, t)
    return a + (b - a) * t
end
local _LOG = function(str)
    print(str)
end
local GetHitgroupName = function(nHitgroup)
    local hitgroupNames = {
        [1] = "head",
        [2] = "chest",
        [0] = "generic",
        [4] = "arms",
        [5] = "arms",
        [8] = "neck",
        [6] = "legs",
        [7] = "legs",
        [3] = "stomach"
    }
    return hitgroupNames[nHitgroup] or "unknown"
end
local fnOnPlayerHurt = function(event)
    if not hitlg.value then return end
    local pLocalPawn = event:get_pawn("attacker")
    if pLocalPawn ~= entitylist.get_local_player_pawn() then return end
    local pLocalController = entitylist.get_local_player_controller()
    if not pLocalController then return end
    local pLocalTickBase = ffi.cast("int*", pLocalController[m_nTickBase])[0]
    local pTargetController = event:get_controller("userid")
    if not pTargetController then return end
    local szName = ffi.string(ffi.cast("char**", pTargetController[m_sSanitizedPlayerName])[0])
    local nDamage = event:get_int("dmg_health")
    local nHitgroup = event:get_int("hitgroup")
    local szHitgroup = GetHitgroupName(nHitgroup)
    local Text = string.format("Hit %s in the %s for %d damage", szName, szHitgroup, nDamage)
    _LOG(Text)
    table.insert(logs, {
        szText = Text,
        nTickBase = pLocalTickBase + (4 / 0.015625),
        flAlpha = 1
    })
end
local fnOnPaint = function()
    if not hitlg.value then return end
    local pLocalController = entitylist.get_local_player_controller()
    if not pLocalController then 
        logs = {}
        return
    end
    local pLocalTickBase = ffi.cast("int*", pLocalController[m_nTickBase])[0]
    if not pLocalTickBase then return end
    local nOffset = 0
    for i = #logs, 1, -1 do
        local v = logs[i]
        local vecRenderPos = vec2_t(5, 5 + nOffset)
        local colAccent = accent
        v.flAlpha = Lerp(v.flAlpha, pLocalTickBase > v.nTickBase and 0 or 1, 20 * render.frame_time())
        colAccent.a = v.flAlpha
        
        render.text(v.szText, Verdana, vecRenderPos + 1, color_t(0, 0, 0, v.flAlpha * 0.25))
        render.text(v.szText, Verdana, vecRenderPos, color_t(1, 1, 1, v.flAlpha))
        
        nOffset = nOffset + 16 * v.flAlpha
        
        if v.flAlpha < 0.0001 then
            table.remove(logs, i)
        end
    end
end
register_callback("paint", fnOnPaint)
register_callback("player_hurt", fnOnPlayerHurt)
local pingfps = newBoolean("Fps Ping indicator", false)
local font = render.setup_font("C:/Windows/Fonts/verdana.ttf", 12, 8)
local whiteColor = color_t(1, 1, 1, 1)
local frameCount = 0
local lastTime = os.clock()
local currentFPS = 0
local function getPing()
    local controller = entitylist.get_local_player_controller()
    if controller == nil then return 0 end
    return controller.m_iPing
end
local function fnOnPaint()
    if not pingfps.value then
        return
    end
    frameCount = frameCount + 1
    local currentTime = os.clock()
    if currentTime - lastTime >= 1 then
        currentFPS = frameCount
        lastTime = currentTime
        frameCount = 0
    end
    local screenWidth = 1920
    local screenHeight = 1080
    local ping = getPing()
    local text = string.format("%d FPS %d PING", currentFPS, ping)
    local textSize = render.calc_text_size(text, font)
    local textPos = vec2_t(screenWidth / 2, screenHeight - 15)
    render.text(text, font, textPos - vec2_t(textSize.x / 2, 0), whiteColor)
end
register_callback("paint", fnOnPaint)
local aub = newBoolean("Auto buy AWP and Others", false)
local buy_list = "buy awp;buy deagle;buy vesthelm;buy taser;buy defuser;buy hegrenade;buy molotov;buy smokegrenade";
register_callback("round_start", function ()
    if not aub.value then return end
		engine.execute_client_cmd(buy_list);
end);