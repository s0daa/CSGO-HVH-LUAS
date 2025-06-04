-- by Minarut
do
    local script_path = debug.getinfo(1, "S").source:sub(2)
    local script_dir = script_path:match("(.*[/\\])")
    package.path = package.path .. ";" .. script_dir .. "?.lua"
end

local ffi = require("ffi")
local bit = require("bit")

ffi.cdef[[
    typedef struct {
        long x;
        long y;
    } POINT;

    int GetCursorPos(POINT* lpPoint);
    int ScreenToClient(void* hWnd, POINT* lpPoint);
    short GetAsyncKeyState(int vKey);
    void* GetForegroundWindow();

    static const int VK_LBUTTON = 0x01;
    static const int VK_RBUTTON = 0x02;
    static const int VK_MBUTTON = 0x04;
    static const int VK_INSERT  = 0x2D;
]]

local user32 = ffi.load("user32")
local keys = {}

local function is_key_pressed(vk_key)
    return bit.band(user32.GetAsyncKeyState(vk_key), 0x8000) ~= 0
end

local function is_key_clicked(vk_key)
    local pressed = is_key_pressed(vk_key)
    if pressed and not keys[vk_key] then
        keys[vk_key] = true
        return true
    elseif not pressed then
        keys[vk_key] = false
    end
    return false
end

local function get_mouse_pos()
    local point = ffi.new("POINT")
    user32.GetCursorPos(point)
    local hwnd = user32.GetForegroundWindow()
    user32.ScreenToClient(hwnd, point)
    return vec2_t(point.x, point.y)
end

return {
    is_key_pressed = is_key_pressed,
    is_key_clicked = is_key_clicked,
    get_mouse_pos = get_mouse_pos,
    VK_LBUTTON = ffi.C.VK_LBUTTON,
    VK_RBUTTON = ffi.C.VK_RBUTTON,
    VK_MBUTTON = ffi.C.VK_MBUTTON,
    VK_INSERT = ffi.C.VK_INSERT,
}