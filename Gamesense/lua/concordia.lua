--[[ Developed by : chimbudzi ]]

-- [[ Libraries ]]
local surface = require("gamesense/surface");
local base64 = require("gamesense/base64");
local ffi = require("ffi");
local AAFuncs = require("gamesense/antiaim_funcs");
local vector = require("vector")
local ease = require("gamesense/easing")

-- [[ Helper methods ]]
local function getKeys(t)
    local keys = {};

    for key, _ in pairs(t) do
        table.insert(keys, key);
    end

    return keys;
end

local function getValues(t)
    local values = {};

    for _, value in pairs(t) do
        table.insert(values, value);
    end

    return values;
end

local function getContains(t, target)
    for i = 1, #t do
        if (t[i] == target) then
            return true;
        end
    end

    return false;
end

-- [[ FFI ]]
ffi.cdef [[
    typedef void (__thiscall* EnableInput)(void*, bool);
	typedef void (__thiscall* ResetInputState)(void*);
]]

local rawInputsystem = client.create_interface("inputsystem.dll", "InputSystemVersion001");
local inputSystem = ffi.cast(ffi.typeof("void***"), rawInputsystem);
local inputSystemVTABLE = inputSystem[0];
local rawEnableInput = inputSystemVTABLE[11];
local rawResetInputState = inputSystemVTABLE[39];

-- Reset input state resets all inputs, should be called once, for example, after opening our ui
local resetInputState = ffi.cast("ResetInputState", rawResetInputState);
-- Enables, disables input to csgo process
local enableInput = ffi.cast("EnableInput", rawEnableInput);
-- Enables, disables cursor
local mouseEnable = cvar.cl_mouseenable;

-- [[ Aprils dynamic easing library + modifications ]]
local DYN_EASING_FREQ = 0.5;
local DYN_EASING_DAMP = 1;
local DYN_EASING_REACT = 0.01;
local DYN_EASING_RESET = -10;

local dynamicEasing = {};
dynamicEasing.__index = dynamicEasing;

function dynamicEasing.new(f, z, r, xi)
    f = math.max(f, 0.001);
    z = math.max(z, 0);

    local pif = math.pi * f;
    local twopif = 2 * pif;

    local a = z / pif;
    local b = 1 / (twopif * twopif);
    local c = r * z / twopif;

    return setmetatable({
        a = a,
        b = b,
        c = c,
        px = xi,
        y = xi,
        dy = 0
    }, dynamicEasing);
end

function dynamicEasing:update(dt, x, dx)
    if dx == nil then
        dx = (x - self.px) / dt;
        self.px = x;
    end

    self.y  = self.y + dt * self.dy;
    self.dy = self.dy + dt * (x + self.c * dx - self.y - self.a * self.dy) / self.b;
    return self;
end

function dynamicEasing:get()
    return self.y;
end

-- [[ TODO: Restructure and re-write child system, currently when children exceed the menu height and side bar is required, the solution is iffy ]]
--[[
    Constants
]]
local UI_HEIGHT = 400;
local UI_WIDTH = 460;
local UI_ANIM_SPEED_SCALE = 2;

local UI_CHILD_BLOCK_WIDTH = 340;
local UI_CHILD_BLOCK_HEIGHT = 42;

local UI_OPACITY_BORDERLINE = 0.01;

local TAB_CHANGED = "tab-changed";                     -- Called when a new tab has been selected
local ELEMENT_HOVERED = "element-hovered";             -- Called when any element in the menu is hovered
local MENU_OPEN = "menu-open";                         -- Called when menu is opened
local MENU_CLOSED = "menu-closed";                     -- Called when menu is closed
local INPUT_FIELD_FOCUS = "input-field-focus";         -- Called when an input field is focued, in order to update all valid keys
local INPUT_FIELD_BLUR = "input-field-blur";           -- Called when an input field is no longer focused, in order to stop all key updates
local RECALC_TAB_MAX_HEIGHT = "recalc-tab-max-height"; -- Called when an elements state changes

local TYPE_UI_INPUT = "input";
local TYPE_ICON_BTN = "icon-btn";
local TYPE_CHECKBOX = "checkbox";
local TYPE_SLIDER = "slider";
local TYPE_KEYBIND = "keybind";
local TYPE_COLORPICKER = "colorpicker";
local TYPE_DROPDOWN = "dropdown";
local TYPE_MULTIDROPDOWN = "multidropdown";

local NOTIFICATION_INFO = "n-info";
local NOTIFICATION_SUCCESS = "n-success";
local NOTIFICATION_ERROR = "n-error";

local UI_KEY_STATE = {
    ["HOLD"] = 1,
    ["TOGGLE"] = 2,
    ["ALWAYS"] = 3
};

local UI_KEY_NOT_BOUND = -1;

--[[
    Helper methods
]]
local e_inBounds = function(posX, posY, mousePosX, mousePosY, width, height)
    return (mousePosX >= posX and mousePosX <= (posX + width) and mousePosY >= posY and mousePosY <= (posY + height));
end

local e_inBoundsCircle = function(centreX, centreY, mousePosX, mousePosY, radius)
    return math.sqrt(((centreX - mousePosX) ^ 2) + ((centreY - mousePosY) ^ 2)) <= radius;
end

local e_clamp = function(value, minValue, maxValue)
    return math.max(minValue, math.min(maxValue, value));
end

local e_HSVToRGB = function(hue, saturation, vibrance)
    -- Code from google, converting between hsv to rgb
    local r, g, b, i, f, p, q, t;
    hue = hue / 60;
    i = math.abs(math.floor(hue));
    f = hue - i;
    p = vibrance * (1 - saturation);
    q = vibrance * (1 - saturation * f);
    t = vibrance * (1 - saturation * (1 - f));

    local switch = {
        [0] = function()
            r = vibrance;
            g = t;
            b = p;
        end,
        [1] = function()
            r = q;
            g = vibrance;
            b = p;
        end,
        [2] = function()
            r = p;
            g = vibrance;
            b = t;
        end,
        [3] = function()
            r = p;
            g = q;
            b = vibrance;
        end,
        [4] = function()
            r = t;
            g = p;
            b = vibrance;
        end,
        ["DEFAULT"] = function()
            r = vibrance;
            g = p;
            b = q;
        end
    }

    switch[i > 4 and "DEFAULT" or i]();

    return { math.floor(r * 255), math.floor(g * 255), math.floor(b * 255) };
end

local e_isBetween = function(number, startNumber, endNumber)
    return number >= startNumber and number <= endNumber;
end

--[[
    @ s - start value
    @ e - end value
    @ t - 'time' increment fraction
]]
local e_lerp = function(s, e, t)
    return s + (e - s) * t * UI_ANIM_SPEED_SCALE;
end

--[[
    @ s - start e_UIColor
    @ e - end e_UIColor
    @ t - 'time' increment fraction
    @ return e_UIColor product
]]
local e_lerpHSV = function(s, e, t)
    local sh, ss, sv = s.getHSV();
    local eh, es, ev = e.getHSV();
    local time = t * UI_ANIM_SPEED_SCALE;

    return e_lerp(sh, eh, time), e_lerp(ss, es, time), e_lerp(sv, ev, time);
end

--[[
    Stores input system key code to key name mappings,
    update functionality for key states
]]
local e_inputKeys = {
    --[[
        Holds generic key mapping, generic keys are those that always get updated when UI is open
    ]]
    genericKeys = {
        [1] = "mouse1",
        [2] = "mouse2",
        [8] = "backspace",
        [16] = "shift",
        [27] = "escape",
        [46] = "delete"
    },
    --[[
        Holds primary key mappings, includes only the most frequently used keys
    ]]
    primaryKeys = {
        [8] = "backspace",
        [16] = "shift",
        [32] = " ",
        [45] = "insert",
        [46] = "delete",
        [48] = "0",
        [49] = "1",
        [50] = "2",
        [51] = "3",
        [52] = "4",
        [53] = "5",
        [54] = "6",
        [55] = "7",
        [56] = "8",
        [57] = "9",
        [65] = "a",
        [66] = "b",
        [67] = "c",
        [68] = "d",
        [69] = "e",
        [70] = "f",
        [71] = "g",
        [72] = "h",
        [73] = "i",
        [74] = "j",
        [75] = "k",
        [76] = "l",
        [77] = "m",
        [78] = "n",
        [79] = "o",
        [80] = "p",
        [81] = "q",
        [82] = "r",
        [83] = "s",
        [84] = "t",
        [85] = "u",
        [86] = "v",
        [87] = "w",
        [88] = "x",
        [89] = "y",
        [90] = "z",
        [186] = ";",
        [188] = ",",
        [190] = ".",
        [191] = "/"
    },
    --[[
        Holds genericKeys and primaryKeys merged mapping, required for input fields
    ]]
    mergedKeys = {}
};

--[[ Merging the key tables into mergedKeys ]]
e_inputKeys.mergedKeys = e_inputKeys.primaryKeys;

for gKeyCode, gKeyValue in pairs(e_inputKeys.genericKeys) do
    if (not e_inputKeys.mergedKeys[gKeyCode]) then
        e_inputKeys.mergedKeys[gKeyCode] = gKeyValue;
    end
end

--[[
    Framework adapter design model,
    makes it convenient and easy to switch the underlying rendering 'engine'
    @ color - e_UIColor
]]
local e_renderRect = function(posX, posY, width, height, color, alpha)
    local r, g, b = color.getRGB();

    renderer.rectangle(posX, posY, width, height, r, g, b, alpha);
end

local e_renderTexture = function(textureId, posX, posY, width, height, color, alpha)
    local r, g, b = color.getRGB();

    renderer.texture(textureId, posX, posY, width, height, r, g, b, alpha, "f");
end

local e_renderText = function(posX, posY, color, alpha, flags, upperCase, text)
    local r, g, b = color.getRGB();

    renderer.text(posX, posY, r, g, b, alpha, flags, 0, upperCase and text:upper() or text);
end

local e_measureText = function(flags, text)
    return renderer.measure_text(flags, text);
end

--[[
    Framework object storage
]]
local e_UI = {};
local e_UITab = {};
local e_UIKey = {};
local e_UIColor = {};
local e_UINotification = {};
local e_UIWatermark = {};
local e_UIIcon = {};
local e_UIInput = {};
local e_UIIconButton = {};
local e_UICheckbox = {};
local e_UISlider = {};
local e_UIKeybind = {};
local e_UIColorpicker = {};
local e_UISelector = {};

--[[
    Initializor function that hides all specified childrens and their children elements
    @ children - list of menu elements
]]
local function e_hideChildren(children)
    if (type(children) == "nil") then
        return;
    end

    for i = 1, #children do
        -- [[ Hiding top level node ]]
        children[i].setIsHidden(true);

        -- [[ Hiding any subshild elements, if applies ]]
        if (pcall(function()
                children[i].getChildren();
            end)) then
            local nestedChildren = (children[i].getType() == TYPE_DROPDOWN or children[i].getType() == TYPE_MULTIDROPDOWN) and
                getValues(children[i].getChildren()) or children[i].getChildren();
            e_hideChildren(nestedChildren);
        end
    end
end

--[[ Framework colors ]]
function e_UIColor:init(hue, saturation, vibrance, alpha)
    assert(hue >= 0 and hue <= 360, "Hue must be a degree between 0 and 360!");
    assert(saturation >= 0 and saturation <= 1, "Saturation must be a fraction between 0 and 1!");
    assert(vibrance >= 0 and vibrance <= 1, "Vibrance must be a fraction between 0 and 1!");
    assert(alpha >= 0 and alpha <= 255, "Alpha must be a number between 0 and 255!");

    local data = {
        rgb = e_HSVToRGB(hue, saturation, vibrance),
        hsv = { hue, saturation, vibrance },
        alpha = alpha
    }

    local public = {};

    public.getRGB = function()
        return data.rgb[1], data.rgb[2], data.rgb[3];
    end

    public.getHSV = function()
        return data.hsv[1], data.hsv[2], data.hsv[3];
    end

    public.setHSV = function(h, s, v)
        data.hsv[1] = e_clamp(h, 0, 360);
        data.hsv[2] = e_clamp(s, 0, 1);
        data.hsv[3] = e_clamp(v, 0, 1);
        data.rgb = e_HSVToRGB(h, s, v);
    end

    public.getAlpha = function()
        return data.alpha;
    end

    public.setAlpha = function(val)
        data.alpha = e_clamp(val, 0, 255);
    end

    public.getHex = function()
        local rgb = (data.rgb[1] * 0x10000) + (data.rgb[2] * 0x100) + data.rgb[3];
        return string.format("%x", rgb);
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

local e_UIBackgroundColor = e_UIColor:init(210, 13.3 / 100, 11.8 / 100, 255);
local e_UINavbarColor = e_UIColor:init(220, 11.8 / 100, 20 / 100, 255);
local e_UIPrimaryBlueColor = e_UIColor:init(114, 65 / 100, 79 / 100, 255);
local e_UIPrimaryGrayColor = e_UIColor:init(204, 17 / 100, 11 / 100, 255);
local e_UILightest = e_UIColor:init(0, 0, 22 / 100, 255);
local e_UIMid = e_UIColor:init(0, 0, 16 / 100, 255);
local e_UIDarkest = e_UIColor:init(0, 0, 9 / 100, 255);
local e_UIBlack = e_UIColor:init(0, 0, 0, 255);
local e_UIPrimaryLGrayColor = e_UIColor:init(214, 14 / 100, 19 / 100, 255)
local e_UIPrimaryWhiteColor = e_UIColor:init(210, 1.6 / 100, 95.7 / 100, 255);
local e_UISecondaryWhiteColor = e_UIColor:init(235, 5.8 / 100, 81.6 / 100, 255);

-- [[ Custom Notifications ]]
notify = {
    h = 25,
    gap = 5,
    padding = 10,
    max = 5,
    notifications = {},

    queue = function()
        if #notify.notifications <= notify.max then
            return 0
        end
        return #notify.notifications - notify.max
    end,
    
    clear = function()
        for i=1, notify.queue() do
            table.remove(notify.notifications, #notify.notifications)
        end
    end,
    
    new = function(timeout, text)
        table.insert(notify.notifications, {
            started = false,
            instance = setmetatable({
                ["active"]  = false,
                ["timeout"] = timeout,
                ["color"]   = {a = 255},
                ["x"]       = client.screen_size()/2,
                ["y"]       = select(2, client.screen_size())/1.08,
                ["text"]    = text,
            }, notify)
        })
    end,
    
    handle = function(self)
        local count = 0
        local visible_amount = 0
    
        for index, notification in pairs(self.notifications) do
            if not notification.instance.active and notification.started then
                table.remove(self.notifications, index)
            end
        end
    
        for i = 1, #self.notifications do
            if self.notifications[i].instance.active then
                visible_amount = visible_amount + 1
            end
        end
    
        for index, notification in pairs(self.notifications) do
    
            if index > self.max then
                goto skip
            end
            
            if notification.instance.active then
                notification.instance:render(count, visible_amount)
                count = count + 1
            end
    
            if not notification.started then
                notification.instance:start()
                notification.started = true
            end
    
        end
    
        ::skip::
    end,
    
    start = function(self)
        self.active = true
        self.delay = globals.realtime() + self.timeout
    end,
    
    
    render = function(self, index, visible_amount)
        local screen = vector(client.screen_size())
        local x, y, padding, h, gap = self.x, self.y, self.padding, self.h, self.gap
        
        local text = self.text

        local hex = function(r, g, b, a)
            return string.format("%02x%02x%02x%02x", r, g, b, a)
        end

        local accent = {e_UIPrimaryBlueColor.getRGB()}
    
        text = text:gsub("%<<", "\a" .. hex(accent[1], accent[2], accent[3], self.color.a)):gsub("%>>", "\a" ..  hex(255, 255, 255, self.color.a))
    
        if globals.realtime() < self.delay then
            self.y = ease.linear(globals.frametime()*12, self.y, (( screen.y/1.1 ) - ( (visible_amount - index) * (h + gap) )) - self.y, 1)
            self.color.a = (ease.linear(globals.frametime()*12, self.color.a, 255 - self.color.a, 1))
        else
            self.y = ease.linear(globals.frametime()*12, self.y, (( screen.y/1.12 ) - ( (visible_amount - index) * (h + gap) )) - self.y, 1)
            self.color.a = (ease.linear(globals.frametime()*18, self.color.a, 0 - self.color.a, 1))
    
            if self.color.a <= 5 then
                self.active = false
            end
        end
    
        local w = renderer.measure_text("c", 0, text)
    
        local h = 27

        renderer.rectangle(x - w/2 - (padding/2), y - (h/2), w + padding, h, 25, 25, 25, self.color.a)
    
        renderer.rectangle(x     - w/2 - (padding/2),  y- (h/2),       w     + padding,       h,  0,  0,  0, self.color.a)
        renderer.rectangle(x + 1 - w/2 - (padding/2),  y- (h/2) + (1), w - 2 + padding,   (h-2), 57, 57, 57, self.color.a)
        renderer.rectangle(x + 2 - w/2 - (padding/2),  y- (h/2) + (2), w - 4 + padding,   (h-4), 40, 40, 40, self.color.a)
        renderer.rectangle(x + 3 - w/2 - (padding/2),  y- (h/2) + (3), w - 6 + padding,   (h-6), 57, 57, 57, self.color.a)
        renderer.rectangle(x + 4 - w/2 - (padding/2),  y- (h/2) + (4), w - 8 + padding,   (h-8), 22, 22, 22, self.color.a)
        renderer.rectangle(x - w/2 - (padding/2) + 4, y - (h/2) + 4, w - 8 + padding, 1, accent[1], accent[2], accent[3], self.color.a)

        renderer.text(x, y, 255, 255, 255, self.color.a, "c", 0, text)
    end
}

notify.__index = notify

--[[ Framework icons ]]
function e_UIIcon:init(encoded, width, height)
    -- [[ Defualt base color ]]
    local h, s, v = e_UIPrimaryWhiteColor.getHSV();
    local data = {
        textureId = renderer.load_png(base64.decode(encoded, "base64"), width, height),
        width = width,
        height = height,
        color = e_UIColor:init(h, s, v, 255),
    }

    local public = {};

    public.getTextureId = function()
        return data.textureId;
    end

    public.getWidth = function()
        return data.width;
    end

    public.getHeight = function()
        return data.height;
    end

    public.getColor = function()
        return data.color;
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

local e_UIFrameworkBackground = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAAcwAAAGQCAYAAAAjl1AKAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9TpSoVBzuIiGSoTi2IijhKFYtgobQVWnUwufQLmjQkKS6OgmvBwY/FqoOLs64OroIg+AHi6uKk6CIl/i8ptIjx4Lgf7+497t4BQqPCVLNrAlA1y0jFY2I2tyoGXuHHKIBeRCRm6on0Ygae4+sePr7eRXmW97k/R7+SNxngE4nnmG5YxBvEM5uWznmfOMRKkkJ8Thwx6ILEj1yXXX7jXHRY4JkhI5OaJw4Ri8UOljuYlQyVeJo4rKga5QtZlxXOW5zVSo217slfGMxrK2mu0xxBHEtIIAkRMmooowILUVo1UkykaD/m4R92/ElyyeQqg5FjAVWokBw/+B/87tYsTE26ScEY0P1i2x9jQGAXaNZt+/vYtpsngP8ZuNLa/moDmP0kvd7WwkfAwDZwcd3W5D3gcgcYetIlQ3IkP02hUADez+ibcsDgLdC35vbW2sfpA5ChrpZvgINDYLxI2ese7+7p7O3fM63+fgBooXKjYgqjYgAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB+cDHgApFG5vkHAAAAXUSURBVHja7dqxTlNhAIbhl3ZwKiwmNL0CF0OMq2FxwdUrYHb0Bly9AicHvAlh8QqYujkTUgLKUIjA6EAxBAEnpz7P+Lf/8i1vcs5Z6ZbnGy+fVdvVVrVx+7fT0x8BwBKYVnvVzuzw4PvN4fBWLN9Vn6s31fju7cvLCxMCsAzG1avq7Wh17er8bL7/J5iLWH6snj50WzABWDKjanO0ujY/P5vvrywew36rJo/d8kgWgCU1q14Pun5nObEHANxrUm0Puv7ABwB42NagO1/DAgB/2RjYAAD+TTABQDABQDABQDABQDABQDABQDABQDABAMEEAMEEAMEEAMEEAMEEAMEEAMEEAAQTAAQTAAQTAAQTAAQTAAQTAAQTAAQTABBMABBMABBMABBMABBMABBMABBMAEAwAUAwAUAwAUAwAUAwAUAwAUAwAQDBBADBBADBBADBBADBBADBBADBBADBBAAEEwAEEwAEEwAEEwAEEwAEEwAEEwAQTAAQTAAQTAAQTAAQTAAQTAAQTABAMAFAMAFAMAFAMAFAMAFAMAFAMAFAMAEAwQQAwQQAwQQAwQQAwQQAwQQAwQQABBMABBMABBMABBMABBMABBMABBMABBMAEEwAEEwAEEwAEEwAEEwAEEwAEEwAQDABQDABQDABQDABQDABQDABQDABAMEEAMEEAMEEAMEEAMEEAMEEAMEEAMEEAAQTAAQTAAQTAAQTAAQTAAQTAAQTABBMABBMABBMABBMABBMABBMABBMAEAwAUAwAUAwAUAwAUAwAUAwAUAwAUAwAQDBBADBBADBBADBBADBBADBBADBBAAEEwAEEwAEEwAEEwAEEwAEEwAEEwAEEwAQTAAQTAAQTAAQTAAQTAAQTAAQTABAMAFAMAFAMAFAMAFAMAFAMAFAMAEAwQQAwQQAwQQAwQQAwQQAwQQAwQQAwQQABBMABBMABBMABBMABBMABBMABBMAEEwAEEwAEEwAEEwAEEwAEEwAEEwAQDABQDABQDABQDABQDABQDABQDABQDABAMEEAMEEAMEEAMEEAMEEAMEEAMEEAAQTAAQTAAQTAAQTAAQTAAQTAAQTAATTBAAgmAAgmAAgmAAgmAAgmAAgmAAgmACAYAKAYAKAYAKAYAKAYAKAYAKAYAIAggkAggkAggkAggkAggkAggkAggkAggkACCYACCYACCYACCYACCYACCYACCYAIJgAIJgAIJgAIJgAIJgAIJgAIJgAgGACgGACgGACgGACgGACgGACgGACgGACAIIJAIIJAIIJAIIJAIIJAIIJAIIJAAgmAAgmAAgmAAgmAAgmAAgmAAgmACCYACCYACCYACCYACCYACCYACCYACCYAIBgAoBgAoBgAoBgAoBgAoBgAoBgAgCCCQCCCQCCCQCCCQCCCQCCCQCCCQCCCQAIJgAIJgAIJgAIJgAIJgAIJgAIJgAgmAAgmAAgmAAgmAAgmAAgmAAgmACAYAKAYAKAYAKAYAKAYAKAYAKAYAKAYAIAggkAggkAggkAggkAggkAggkAggkACCYACCYACCYACCYACCYACCYACCYAIJgAIJgAIJgAIJgAIJgAIJgAIJgAIJgAgGACgGACgGACgGACgGACgGACgGACAIIJAIIJAIIJAIIJAIIJAIIJAIIJAIIJAAgmAAgmAAgmAAgmAAgmAAgmAAgmACCYACCYACCYACCYACCYACCYACCYAIBgAoBgAoBgAoBgAoBgAoBgAoBgAoBgAgCCCQCCCQCCCQCCCQCCCQCCCQCCCQAIJgAIJgAIJgAIJgAIJgAIJgAIJgAgmAAgmAAgmAAgmAAgmAAgmAAgmAAgmACAYAKAYALA/w/m1AwA8KjpoNqzAwA8am9Q7VQzWwDAvWbVzvDk+Ojn+nhyVW1WTx769+XlhckAWDbn1YfZ4cHusOrk+Gh/fTyZVy+qkWACQLNFLD9VDW9OF9H8Wv1aRHMsmAAsoWn1pXo/OzzYvTn8DTqfVZnG8KetAAAAAElFTkSuQmCC",
    UI_HEIGHT, UI_WIDTH);

local e_UIFrameworkNavbarBackground = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAADwAAAGQCAYAAADyVQNTAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9TpSoVBzuIiGSoTi2IijhKFYtgobQVWnUwufQLmjQkKS6OgmvBwY/FqoOLs64OroIg+AHi6uKk6CIl/i8ptIjx4Lgf7+497t4BQqPCVLNrAlA1y0jFY2I2tyoGXuHHKIBeRCRm6on0Ygae4+sePr7eRXmW97k/R7+SNxngE4nnmG5YxBvEM5uWznmfOMRKkkJ8Thwx6ILEj1yXXX7jXHRY4JkhI5OaJw4Ri8UOljuYlQyVeJo4rKga5QtZlxXOW5zVSo217slfGMxrK2mu0xxBHEtIIAkRMmooowILUVo1UkykaD/m4R92/ElyyeQqg5FjAVWokBw/+B/87tYsTE26ScEY0P1i2x9jQGAXaNZt+/vYtpsngP8ZuNLa/moDmP0kvd7WwkfAwDZwcd3W5D3gcgcYetIlQ3IkP02hUADez+ibcsDgLdC35vbW2sfpA5ChrpZvgINDYLxI2ese7+7p7O3fM63+fgBooXKjYgqjYgAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB+cDHgEYOewvoYAAACAASURBVHjarX09jjZNclzGsx8gaw2JEiCsKYHgeoQuIJvHoK0r6AI6hk4hyNEJZOkSsigSNATICxnTXRURmT3fO9X7gtzd92dmnu6ursqMiIxAya9//9d//nMBf1+svwPqb/ff4P6//SfA+jugiqwC9CtQRBVY11+wABTr+t+Fr++3/uP6BkQBlJ97//v7u1YRsM/yk1+Qi/1PVfWfC/Wn/SH3f9sPsB+I4b+g9+nh91w3a393FvCpYhXxdVPKbtr1PXjfoPbJfu2Cr4v9LwX8EeT+ZPc3vJ/e/TMpj/v+7OvD33/mqwKF0s/db8LDE4y/7zf8h0/43/313/wZhf9RVX/yb3YvsbWq1lV/LbnrAoaLuZ8a9f4DX09qXQHlZ+0nSVkF9mNtnV0/ET+/7E9V/X1V/cmWB+XJygdev3j/m5KlKL9jfK3+S/3w6/uwivy6OKLymeuPux8Gr4fx4wtG4e/2A2WhWAT1Utp7sh/U/jtS/uK6MOrHpv6etvJZ/h7bfb1fV651V7jf64NfHxb/Vh7oekcZLxD3X7YPR8AXx/XE9men3CTKc6q9zO/PgH7ZtvtjrxQeXPXnvvtr3RDDHs59VMidXrf/vhvwN7vi6fkOzfXtoE+d9zHEtqLuG697x8+XNPUGy52vKpDD0pFLAPO+rAvC9eH1Q+2Hvl+Fr6UuG9i9c8nf52c4Xc5fTxh7vd4/594PiP2Osfxcpr6v9ypB3Bj47gb0jWx9GXUf0Jdj+CLgxQXrJyG/7ja5PsSqiujFRf5M6vs7LOf9hGmrBLDDXC5wHfq+Hci/Pdql+xcjrgbXkruvivKa029CW/j+mdbFXTWnrZxVvsqeIMtXbtt17LFOqo8POdwq22C/3inmRkYvhfrRjLgJvP7MNz/dnPYqQmxqkNXzbln/lvWo3VHk3UX7u3v50zuHr73nOtv3F9HKRcbPpvQQvbZiPucaqvxfKTx8JRO0p4hcoL7i9nunK4z73N2bG2wF0FYS929WBWV3Zd9s1CptT9b0x37e2pp3IUfCLxCM1dSWgXVYgG/a3GXIVTExjinaaiC4nrye/6f79IfS+aCiZrtKTcDv8v0EV72R1RGrvdf6sO7LI8suxpf+tDHc7zn3Evlx4YHcUWFNBAvFe4nKssMCAXgtZ3rlwyj2rTrC1e/GfoAaT2mQ7VWo4tmSpj6D64mWvEZfS9iXELXLQZ7B2gFeCIcVK/t9nZ6Pvj7SIPY2/nBNf6A7FGu9s+h7lb+ieLrR+4y8uy+9OeNxxr1cAW84UL1JYPWN80ebFrT0i80H7Ne0ayIYXCO1UuuXywAU+BEIXy1aS3OhIH5cInb9HyxpP14MjFt1PO3J7PZg40r6EBhN+33mMW7evV8yyzOtwfFVWdlzuFfQEQCga4NXG5jbrdbGuA59xosHGlyzf+9nOqTxRvTErGEHYy9VCS9rf94ttY2R0w61WkbbNEjpcAV95NcZbs8Q8gTBaJf0uIqzarh59eocDphp2hU59KNcf6d9r9be2q37a7ErJ8jT41Uy8gFN3gUL6xDTymtDa1SvN5beBjLKTlJvy71LY10oiL0Urf/NC/Qj597Q7EEQJ5D0dcHMAxEGnq0duJ3NZe933raFZGiLmbs2FMPmxijpxxbYb8DpufQxGMLwIr/bGAqi3cx/bXaCRUbDnjgtOtxLtM7TABMmmHhWeXx0e0AilFpxcDgxpouQowuKcKCevwECswaut3kfc4FJvIF42OvfofjwhyK/AWT7Qtv8IH8A6QJvxGNXKbTyE0ar2KW/uuKP7sF5iuzOiDUCOXfLA/grce9ogewtkPBCB2FA/6ZivAlhdSKLNbZSv7ZplUOi5UdI2w3vOnrAnQxPZjQZ+rSvR00rinlVXmwAJfXVukp18rC01PVLdD74C4KVUpG8nqCAL5AV4lue7L5ZM2CjLOTe2eFb3tePQkdhcAjEt6OEnUMi2AG3+PC03pcLnKR8yn1W6/EjfbXQseTQj+KpFDpqHrgwYWarJ/cSF27z9eFRc22G9XqsTWbCwTDcNAafdPNN1937ev3PN65PtYLgJsLuhgCd0bs+EMnAxYMUC5BgPmelEudmO+J19wOPFBTmpzBtK+Bha5YLuTDVgZ1IuDHne+nT27994fAmoQY2UTdmKtZWa6PDi7P441+MttXj7myGmnsXSTDSkUgYtqwfjkfWWYzk3uFHxItm6X6H97lJemfN+8zkN60ZB5QDcWpTfr8YwxnTyg7OqBdQ2L46O4cVSEfcfQS5c0uP2BgIZyOe6kCOhztjY9P+25uP+2gkcA4AWOuH5JgcPWJ2V4xlPPGgBr9PJCCkpZwaEK9tcT1hnr3DvvYWQK7LDx21bLotPnFdD1KjtcNjrxeqamdgNO5amjyuqIMuvWVJEKkVpXVD3H2pgRWGQbCP7Tlh3QCaEi++RhqMG1qitW1vIZ6SGtk6m6HBLye3v+4LSkssDvRqKJV67ayvFaXLAvrNPFrS05JZO9gmqSm9LBe94ghJQjxFjIRBXiTlSrZWa1dcHKjhw036q5a2+hlOmkG706bwUfkg4j2rCwV5eNugq8U7LxevQbfrKjtRTvvhAQNlorRPbB24zlUmwL6WbLJP6EwhKpgkWU01ANxE8agf1i8TDhfBI+2eDEar3CUltHG/ZYRGs0LgaEYPv9s0ZPNSIV4zveYRe+idENeOuMvBveHQ6kVadeQoZRm8qp936pzKkFGr2jCUoy9axI+q6FgdzVOqFLJNITnc8oY8ic5NnEmVBFXiRT2iGsN8Y+k6sZ8XHrRuPxAHxtPFV7PAUOigFm9wfx1iM9wMINfrk8cpGxd6yx5nEPioeaDyRKnq8X16yXMS2VwXsGBZF5HDfpB8bNQTKD5TSXjXM318ed4bVwo7RehCZwDnZiGew72J3aIy3YuDIB+bqNi0+EYBkKIowreDmz51gM9hW1z9sCn0ktMN1GM9qRCmY8E5sd7HjY5nS9p6vcaGwjeWGyYF13u93teAZPXp5dTLJKfQZmUdGVHjuDL+aNNyfBugH/dJjVw7t4ECiKGQaVu5RaKYnpHJ09oJcCuJ9KQgX2xaZchl7JzGEGzep7WUtsLQoBo0kXiO5XSEw74GsNMC55gWB2wG/u5RVfM0cBNXa4GEbQflDYKx6Pz4hVw689wUAK2u/1lpCeN5WycTM0t3owCw0SDaeDS0mg+KKy01r80PGLhxKZDWKjsHAJS9w8AjxSmE5H/1ZgniRcrAFqP8pTGLzgEPyjuk1Ann77AC44hlg5ELngFM6pOmjUDUE+hJ1QvfEqgYY0kI+JUCYL17F4Vh0AxozIEDNXsk5F7a0PoX2QXMzQKgyp+76FF4hA0vawX4jwEA+ebe1cBUg5s3Ykcyqwsd9uidcgywhsJ1IHMpSSl2HCA4XNImPaTU1Ld4BRNcoT0UrpGdANSR9MOTCJWPDw+xK3ch28Euvd69m3VQRp/oyIz1uoxtD8M5qYS7Yho3HobHsnFSbFHZjiMgXto2miJ+uI8LyLMRrKvY8pEdMJvhGLFbbaIoRxiXxnssQW4AzhvET3ZGQLVd0QVoAp22x8Jg+/zvOk9YvZCMYWz0Q8xW2XlpeQPjjF0hud9W5LgAfJEqjJmktiHJKxFIqc4F9A0ZW9l3JHmAEFSrkHFFC0kTpICp3ZWhDeUXEE/yUQALw9Sa+kdhwxv6xeE73DfhYT1DKE7qG+jvWeJMXEcWo0RHNVlAPRcnUBRNsODjXboa2hhzwFnXVsAsq77WPrPTqSnDxoToUEwNhEtGCpQPa48PH5YYUqjFCog8u5eAaRnaLDG0IGjQtFVW6BNril4ym44jAMAYr1yaaLsiVBGP+/zO2Qm0R7HeReroH56kl76ykCqAYyB++sUg4ykKQMjGIidMiOi//j8mWUYtp2M/6MdDLOYaprt+/IT9p6Fp3FzNak4MwCCFoQB0Ob6GEkzXVxY6alIDwP+GN/3YscIKUcv+36qbZLlWkuxoLQNe9flIdTeIGxfNPaKMpBB4ZxoPrX/sDJQJMj7gU3BFPET44oQGRbM1UaMwglwlkFOtfZ/HLyAeXVmwScEu8Yd8yFn3TvYdfF0E8u/7cADjzMZ4Mp/2w6S9Zm49ERsIjBIW2GWQKRkHu4crGa9zTqhvMNB5KEfJeKx7+NjrxOuDUU5NSF/UmoD7g6PtIRC3CB2rR7wuI0xrBJ0j8Vy42ylqSSWcl8jCBTXszL0rr9hsZzpDwK7ULT1jab3uVHrav8eLJ7ww4QTQrg2I8JkD6DSoiZFyzQ8NQo6i5ZR/NGuY1O+vJtPCSCBFRIwS0SBaqEKYe7ETNb5qg7SwvSDakA+N/hs8axcezCIfHbelMl19FLjtnPBJh2fZDdr5jXwhshU8L7QuUUvoEzBtzgI1+mSvc7iqA4FqLVkjI4Fg+HfTnF9D/+vzEQBYpQXVCcsouFGfFW4Fy72Fi/gaiQE6NOueA7EPGNmWgD9OPQ++njDaPWPnWJoswjc228lNp9GpG5gcKZpNTs0DOiN5Kh8GZ8yZq751B7VJUshqHGsNfF/HxqSzWhcT9lI1AARVfFFp1Yw+QiooU9twoLupPBSfIKtKbtF25tptoJ4EKIRlnQxvnZ3D6IKyVBTHD22VLDiOn+rQNB5uVm9Fb1Uft1VOmB/x3TkcR8eA+Kf0rD9hOJJBVIKo3byP03DA18WRa2NCaE727n88TksZuOBgLFS2nm8jEmJCSNQ87J5iQUMvvJeUW8o9xNHVQ/tI5AsjD3vCmzp1OEWLe8gS1clQm/uvTcThCaIcRnq67Ux47txj9W+esJjeSa+b3dC4x5g0GPYs6e6IQ0WNb0Z0dXY4p7hvRR9wOk4L5YQZdb9ZlOxLa/TLJS1Cp3wM2JWujELtzL2WEuEwocv2GjmaLkU7960ggKp09hnFAOJrODnTMm7TrBiw/3Y0iCsE7V3n+Yq+ZEtpI4EA34j6tgN43ECG4+TGreDGuzkOSFUFxhgu+GokPp4wOZp+6U6DSYUXN8QBO3Q7aNI3qnAXwlD9Of+Eo436U3rsJKlthQVrqPVtRt+dGaohGowPPHpiNyucqV1mHbot3zMPg5uhY+Tyby4tponKuQk1kTsEt1ZzyQGHlbDHCaYhvs3tnQF5v60vhlc26/1JrpbC5crXQkSavqnACQcBFxDe8KyukjUlHsS++xjTUvNsVjMwIGHKuKfn1JDZpG+srbxGODmL27oAAWbyxdMprcS0eh9wK1cDRENnshlFBcOzcleDotkKlR5qHunNG/4FLL6opXOIivy2txOKU1AJ7BJldvl+1nuYXRXQt73h4l72w17IYzpJZfPpyMh+ekzDjbgqhhRee1voZAxhu3bTdb9yW9IeFt5zMgDx2+HB55wuZFEKBKbrB9NkTApXuM88ROQ11d7LzOToHb4LjeXcj01ky0udw87MHbT0vdJS1FHvZuxLkRWj2s1ihSLfGIrDSgtMLgdtosyPTQ2ekGlSTlgvqnnxSHlNnY01eCna0WaseWgCiHQbnhxVtEpiB9VojD4HErTCqkZUdXwwgVecK7gkOqxwcg7vO9cdj/ZwFVYtFRkOhWaL3F5yuUCWo8DfOUUDTVh1PMLz9Q5HHYvGZkMo02CfONXJcgmKLt7GvuhlIUYM0dtFZNNwWGx9smFf/Cs3GPfob6cMK5w1ICeEc+CI1CKPDhjuvZReQ79xTKOUkzr3Xyaz6l3ADJPrpsXmmgs6b9hUd6LvYrm5CMDWs/NUmIYQcKdXVhqHNAIcM8LBPvbrNyo+NLiLCqhFegP6eMw+fL3DZGNtfQ7/yee5So14028ewaJh6DaUfCWqiShJ2MsAbdVOB6apqVnJuBvLTwHk3WBVy0v1w2PwwFlAFIYjLrANDZzi8vE6O5h+M9RFWrnlHX/7ACjOJa3jRlI5vtn6RNR2Feryn4hG6+DY071OLdOzRoNlmQnVcT/pm+iSI+leFUgmAnkeewBHizupyXm45tAJ1lED8aE+2qkhz0fGjBOZSkm4qLzDX7FqHwxRatLHXK8GcNRAfJL5mzRuqzpSsA6dWZLSwKHoUREvE+JqaqDFD/RYLC9EzjUeg3ygSd+V+4VNjysRtk8kkS9QcpXuc5d9qq3CC56PA4vnrqVyDov9sYnEpdlO28XaAB8SxFItR7SZGrM3ntOm2Ks9TxEQzwsgnsYMrNJSzO6BNNYcNiin/8oHX9Am3LreWb5u8ipqBqPHA9P9hzfXQe/2RxaeE/wVzsJtlMCaBbhd2zcIFl7Alp8JOqAwBmgtGcIjPrc63/HZmZrK6Zm26huC7z0zq4YV88u7tB4tcM2FTogKdNO6o9R0PNTNxisOe1KPQNGbi+CmX3RLJjBbkn63frMuZzhj1VOvtEB56Kn0TDfXAP1Z3MeSU1kvNi2YYRZ2gJPOItBlwoh5QfDBG9p2eq20ppcdGsg0TsuU4N08bQ9Nk1Hihht4eGvRAixHhbp9mHwmQn+ZpeQ1ftCMEGUjo4wEnvDEn62d7KO7DpmhoXER6OkNRvWozr0JuyBaTdB28eHEnFWft5bzOOdBhZ2o0Ynl8ZfIGLSMZKNnHJSruMgNboSnC7p7apFvfDwgo0R0SpNdk4VWF8uxFJkNMBFLnz6F2DnvN4uxbibw4c1US9FkB2w8fpzR6F3VBNOlcyk0TIx0Z/CW/aAnPwdx4gP2/WsQD3zqYDSbp7/LUedRjovGRioPdQdDqXVUEue5LV7NxtS24hwA6MW7X6vAOvzmvY7BLWBaKHSvamXAh4CmJUXU5YwXhUdzRUKPMExKs5rVBWU2Y5oxRrOlrKaEUg4JO/G2PfXzoNbrCbvdKsp5XN72xmocki0/ku+Bu6s2mqTcQ3swNnFP/dSZnE+3fPQ2WvVk/agnaDF2ZRWvId8E9mZCM6csoLXZUz3Qom+WtL8/fXO4ie62LZPtQA3Lq6gvWeqvT+trZWJlwG7ezirNpSV1+ZSBAg2ri/nabYch8nG7HxzW9BNdAis07mjuVqMfq3jwe5PW6JbpiXDe4cmcZhG1Nu/u2q2qijucHpaoeicu1SeAfIcoS7FCGY1uKpaxYlTb11vvxRjJ4UPfaGVGuDEBx0DeB83ROWHmzGPxbMS+sLk83RG+8TB4x7WX3kTI7Y1jsOu5fwzET16NNKKMGMKSkciGTJYz8Y7u2+Gp83RQXnDwBO+Jd+fSJ22/zcFBlDdIKjQczhA2LO7YtKs0YIhX5wYfzC+gsqGQZ3NoMfUxiSHR5gKnjWTMSENJBFgsvfvshtxEjTsJVLBBgugV1iuPeItFHiZMd0sgF8ool5QzB795x7buigNMDe6Z5aFYl2X9ApduzL29a1MWInthETUjqydwGSgUbnQlMxXAVEFHmByOz+GUAbFJg9p874r4QrOJYdfhWB+9mgOTLIkW7OGQzSSE0+nDDxjk1OBhSRmjuTeM3UHRChGUuJVywMjEptkBPUR1h3SuURSvMlv8B80DviE17iuh9THIRgFRiFTovajuEGGtz4HxHzRuNTjFnODTHw5oWp/8hWsfcycnRxOPsd9gygHgqA7RdmQ20fIbq9bo3Tg4kOjcA+XJwP5NLwqzVMXwVEAnoXbcSQIhcdHHmxZz7cTMAXshUTo1vhzHaYb5ZEyBPvQoRG9/Wr5iI+FwbHzwedZO6ZPzd1JFps8MAFdGouUND14eZbPJsnNJsKt74rFOpWmfhtghsslWwqqUm7HUmH460ylMrapQ3aTILaW6UwR2bf0io/bTqlRGABxokklMQcAXE0Adfkb0YBDQvVIFP4NzT/sScD4T/0Ej8rhd0JaZASMVvlN6iLOE7JGgWGUnei7i/dSChQQUOo55inOLOK+BYcuJS5XDhVDmm8SBe4j3eYEGz4Z/RLeOuhXxa7zgjk6pOspN+yR4Y9YU13kKzobgiJO5sYmBPnJENITdZ1WLyG3ViBQtrzYtlRQJtPpFdocAfxZu+CUjcx0SGdm9hykAtMrEYJ3FGu1qfo54UFi85sejz4Ih4UffyNBlphiolPUjyZqmykl9hXTk95WBWErBg4i+WYcQl2gECTX0QpIhIeuYbbmjrVZma2XbNaKROBun/Sh5trugzSxkTWPjs/1E68ocPDQmT2R7jqWyxiDYQwzv6wnvXh5hCoJGflEGpBOJuH1A7h2U6PnuudhVjH6b3xPhYFxun8NDM+1FtWT/i0zbYEIx2F4B6O/VFLLttxBRNqoQjdV3Dc0Z50jU/eAJd2TM/DmQMAsXrbLTPlRLyWhhuyIo6UIG0rnOYmq5m06Ih4hHVkceJ3Dno3lKPHs0Tu9YGabc0ArYjyy0aosb8B9eevKU/7+TLaMT8kRndAOSwQ2cYYGPwMpAtkSI23WFTVKCspmK9m7gOLT1sylL7PIS9YgvQQuExGD4zco1d1O3vAHS6JMNYXqIdz3klsL7lRVe0MGESNrUPofBblYwZDEgWMn0iwZqKDsj0PWFz+OnJ8ziGuPZh6Avz4FvwqCj4rB9ZWY3aw6MDxvXdDu1jutN87AkiNot0WdHl0+enoTMDAed0mK8/vy+1JSKbWURD6jM6SV/yOCHMchX6YUnkd1KN+5YXJL62FruDddKMdUVPGabIxzyJgbQkneGb0IWUN+Y4TpiuTZRWAK69SbeZIQ0ueV2sjJ4EThWPEQ/3GwtNlhn7koVociMbOGBwoUtBD5TK+huAU3aRLzQacUkWTYhvGlUmMK7CQ6MvWeACYjRPEEpc45QpRbLuKyxbi9yD/2HQOZztdvuuyumtkflO2Gqh8ZH6tPFsJnF1HbuKXxReHT/L3TedjISS7TRzN+jZx7SeNzMIPNOfV/QzcuPqx/3w8HMDR9peppEdRsaix6Kmqg1JplYWlneOXJpyOrAsP2EH3ZFPoMFHMZrFkDAoRNyFCSBm2YcSLThJc4BxA9r4xXzANFVsiEPDbdbAm/0B5PJ8oJzOzTLZjOAwLAyYYv1otJqmPIdR2LDCoyULe4ARnufoy6uwAKlLMz8lyqPR9GD0XgkDiqLHy9p/eYQtax0S0w7ppYoXYaUuAp8r35IlUPOmBaj94VsUHeey4vmoQbuxw9Xs7qAGv755pH0yrZi7A7heGjgodOd9HP7JvLeiGs/Lk/qfWZT4rRlxz2ppl1V1M4uSEUNqzfe/f3z1Z8erIcJ1B8VHh4B1LuTVAWkA96QhTjhTqK3xANLPJovNeYfb2ppJQbZduiOL8/+8KjMB6d9DcOFjS3cgmvDV4M/AtVtzXk+MK1zuFB9ARsV9lAccKBXkjfaP2CLv/c4nacCZLPE5rX2bgQAkYOEAXxHG5hzbRFVgsDRkGQ5qk3pekLHUH1vOTMUPAZp78BleHmJIHum8Js2YUqFYjB3VE/mxTIkAeSwJQaKBs0t4ufnMGxfFBkpWlyXAyPoDCIHKtRsk30EAALgsSlVO51TynocNQ+B9+7wZI4ZobcLhHqL9ydej7lifHjnp0KkzSzVOZG23+EA0sxggJOTKVegWxoh5EDVTPWxtY/dwctZjobD8NR8aGgIG8Gmc/mg5wtL2Te3e45ZUWusaX6BE369dWL3O85XUy1u9H0FulErBZ/91ObbBlXQcOUJk0uUsy8gN8oDvcE+J0tvEC884aE6aDLS3AeIlOiYdTP8RDUhHnoK3pgcHgznuUGc5R7yYVOICpvdmx2WNKkDIJzf3xGvyFgAjmwE63ze4cK02MKsmO4HMacE+JD/eBrSvQBSjWREodGmngfRdufzvuHulqCWHUOI6tchr4xBKzQJYwsCxvLGIc5rTgYGEgnKyZ+sekDkwS4N01twxmQr3Vq0R3XnFnQ0I3bt+waoJiQjGGoA3UEc90ufnfG940LwGHuPNfup3RGipUIzbVWrms1L2VnOvoFt3620Z38RuAy4K0EzCoHSJpRROB1fv9X8XM2GB9ioponpNbbbxiDS7nITEYsE1LH/8Kf52QHejLFnedNe0D2hwuiezK4G6hvvu9eiUij+e/RYsZyAPfWo/UyAjkXxgV5EZJz2A/0C9j6dab+ss4jU7Igqz5qMLNXj5nA1D4FPxVBWdklufXF3VNYa9Opr+IStFKVV9KE2HAZ3T6SHGUFPolkkS+Dw1lSv3o6RwHHH3nPUVfYoEkTjEkCLuKlmDYOz9jCgmwDfhKA3VyZWKAOYlRVmNLJ9YPfMBIcHEGJsPJWgv/aEozNS24q1+/rsydp8MjJavseyoYmFovbO9/f2ucLZecero/Om+GOdB2J51ca4KGiIu5mxW1wI8gx7HsNwJt2spNLg+75BSAt1nPLDCpnyuuNpbK+JtHE2txhf6Z+nESHEGw9GFDOtpp7UPjOf9SP2UOUGqrRjda8eGBat3QHCyI6Bcd9p0c0+v5kBY0RISkvgcwCAmQbsIHru2ilAFZ7X31e0DaiGEZ1NNfAZE9XonmK94R4+CGuYUvawMPrhAjD60lGRqhqiQZ+gLTz5xRW3sylC04k3Lg8xgNOa8uaINCfhTD9/HMVTQApiCmgqIh27m4M+CJ4OaqHRKBlE0yr39m/m+sniOqGlWgVnHCF1YeprHeJagYeBy3rGPVYuq/tRTwC/SAwxJUmftvDWqm7PA3pO27LHYYC4fLGkoRg0XUIoZ6rqubKqst53OkrCmqYjsx5k0chUyTB9ZRGXUQO5IxPXPEMLSO2776ybRLSMm/5c2B9jZEdqdwzg37k8XMWl2Dyub5aMGLPZIqntpNr53BKJKSR9QCWVmNo9dm9jj/XSkA/YcYRI2LIk6U4npbIPSqeGWM3jE7KUlYQvfe3QE7xfAADDoZ7q86l2xy5GIPyUyLyDRkE0VWJLlcb7JRedtXad7tIjTD4hhBOpg+WiNE2/PDewbOqAHXk0fSIEzPSGW7IzmCE9ooPk4zAgW9DMfQ3mNavqm9VgZNpj11kqPLRkEu98PKQosC5s9oDlihXznZ1RL7pI86tS2QAAF9BJREFUHCJYSR1JUKxMiTF7Ttu77NIa8802U9eXMbqhSkGZf/R0S43yVHahBj7raUtak/HHZBrYBqswZXpz5r06ByQw4KMBJ22GsHI1hxsxxwCdOjc9aNZNVCVPS4u6XNR6y6NWVd96iOXWRT4/YW7oxzCJOlvWnzCvE8tl6V7Yj12oAYmv0urSX9+3hmbXlqv6YzbvTxkmOZtbqpwKHRh59LS6iuA4j99F0KG7UgCGA1BzSi2XVGag2qj+MbeU52EfOuhODEzLaGMHfCCTD22kwkpwuJbeUrTsaeLFpsUu6cMzTVCapqMHpYZfjGFiTB3O1m5Vis8jrowiQuO19fONbMkqGHbNXa4elmq5crfdy5cPQtWhL6uW2VRRDygbyVeSh2H9BnfUMGdDhXbIxO99iOcp8iTPGdMrKXN9oYhP5n7C2kCfLHPX0CEalxBsPlLlo/hoHS+ynqSxFTe9yjdWrWD2xOExnWM7xIPYFFNL7C1mo5tZLSaUYXLQ2lVM6XG/9Os3W5+3VSuCx8mBaPje2UxlGvOyc9UY5aQ2HBg9h9wfGdVr/bN+GIoFx6zujJG7yRTReqzUW+mfoYYafvKKt1k8DEObP17SfXKRRp+4JH+EYyw4GOb6zfF4gxdZ1MYg28MLxTTNCSZ7gV+lS/s7AnM063tiN8n3Pnn7SXsposJ6OKQxlJ9OAjCN80+nWiY2Nj05ksPn5JTIqaiX0xYZ012PXhzQnNKpU2A9aKt++RyGwywRh9txdzaBN1sbw1DOopvgM4zwEWxiPaBD9eYdHsrHrvHIuOsafADYbBmpZWHeDEU5NbokE/BCy3VechjE4zmEthchmLyiOzFklq8s4TXOHsXJirpXEF7MDNiW7yYBvt0Qf5lqofpTwpzLOPngEUtDfV+Uzu7vmCE5Y5FYNYQcC3INMa9m+aYcfEN+9A4jb+a0ZYqmBCJO2wOV6h3ojb7/u6ye2yYNGMa3j6QIx3kD4nGaPplAvbuwX3Dk9sH0V4/dTTt2ZT61FREpOM0iejThQXsob9GAIM59z97A2DOUGuCEBuu4w1rsIex1eRfInHrxMDrfbzaEvf2I3flFs9AiiBA1NqU8d4DOFHxrrmSo7FTzycppxJ9BPNkZGUxjc2q7+Oco/nBSzWSUgQl56ExCssnQJYZyPvXw4eghKZsEHPT5ulhhBaDz/AL1IXrbGoY6VkX6bOmIEft+QaZle4gk9yUDYAvBsc9o9lE896HNwuhB92VTLWKbTm8D7xWGNxPi2pkwi4mHdnCVk9BRvJ6nVLa9xdUbKaZjBYGXtbT5U2mpXjB2hQPmbojeLIgRfMtTkWFoS6XNQezlHEWDk9pNDgeme/rm0BOvs/kqLB1hW2jYTAUQD3sKeBjDmc6AtU3iCctOvuEt84DyZtvmD9iQy8SxGoccTmvuelitll6XpKkf45wS3nVLaAVRaqKG9xPiI04G4YfBooeBWrJH6gp0swWQMCmkmp4cl5b7SocUVmI+cBk8goli2dhEt1mtkBirwlaaD4ocCjFlgWNxaQYgw6dFQbvwqRHnAw2K7yB5t6IO5oFSxA3xCEuBcOh6iEZfsv22vUtKVIOzi1p1CoZRWdksaiTZfid7BV5MiOcS5rfhxljaaNx1L3/BdEx0V+2WmCd9n6oh3ZkJCRL8dEkHvh5zFGH4A5p0l62ozmkkGnpC9dEaevAc/pnS5/lCbPnJ6X2wTA+NhK1ZD9JdNOQW7Ma8W1eJBvcizm1OCMFwGv+w8BhsI+CaPIRp7r17rlRp9LesBQpkXYxU2D6gGBiKjBco3qfpsKA+dewzb6a7wspp8XlFuQEPZSByd4p20srPLFZOTS3rmi5FBE3sTqi6CIwawylzsDFCBw1oZYoWKB5H6Swc/e8wJ0y+GLZsfqqYrCggnrOKczn3q0zhgqNVVZdWkKX7AeJGRaMSNBZOz+EJsOtMpywv7vQskwdyhrB83rdDRoygdaJbSbVZedSbCfEa5AsO27oGGhsosFuulAvDoSkmUMlHUAADlGtl5RvaYdOlzt/ou0Xm0CQtbTanxtZAXXhSWRzoN7txanfnVfGXsEyv7aKkGcA9ghDt4MdURhJGsE2GI+hfYjzqHkafDKCPMa2AeNi1l3xo2JHktm5FocB7OmLGKXJSqFtR3dnmiLMJ8ZmWjCEGeldr0yoyNUp7IVT+NOcyMHGwJkyDcU2lBc9hYOtnNoLKbTYmSuC+W7DUHlv8S/0DJtraHRZL/AW2vQaab57lw7xCLVfgcsZtDuEyfVlkb5RniK0gpEJLNS3rXlAV4UHjHLaHEM0kwVGGpBbMfWT9gSGLKfJJEMwovFe6FqKwqZ5JzsPBpU/GClCmOz1QJs5JuhcaQ/a7CwhR3bG3gVnYWBqflwcD3/QGpvXWVY4KhgGcBDlOSthyE9fe4XTfDu+je1UFdA751ID4M4HefeemnTp7U4HEnRjiJOOD6JCRHF0YTKaZkO2D7vpsBKDF16N6ANR3UyYMEBMjqaiWGAs5oRad0lBwE+13McLvYrZ/BuJxXFbpzq87aOkuqkCf7laRAMDYupS4a+6mITtkODS9aIdvTKuvkRY0o08b5hf3ECjVS84NCYu7S4tMxOzKG94ff5Fa2lq95b2jKvlhp7iSL9luEFvatJGe941iiFnDsLdRGESzY/8x4tGkwXgKBd7vW1pFdYfWMAoc0rY4cE0WsGmtb175IbeEhgZGKwNEdam9rkQHZQhzJTpSYcvO0Rcbsm80YWk9xEocLenVgSBDxIczmqJknwNlgerjOOj1uosQe3dGS+fyOJjDC+7cb4vfS8Fpy3NxqxnaAIdcXmq51hE0RWy7Z7PtbXgzP9xGDgYfHMSiJwKnhozXcMCd0DxLNCvCUBBMFE+XOOO4lhazTGYXMInC0BOlc1RPPQUooS0PuY3uQUANlOQDhnXV6njzhKu/tpg2YsWpuQHs7TROmyeGOLvsE0V7ZTkLh7gFlkO9SvecmR4gByF9hgTE+oHN+lGjejDH7bY6GpsR5KYgywJck4EM69ivsvTYFB+aN+MTZs1spObNBSlv4sR/jeJuTjhLyJIQYs5X7sPTvDLhSEaTJmBgyWxEPkw4jcWIs3mzbI/WGZycjo6DLRSPhohG1oXQd1MjLCPC3lI31Jcjy7BIuUV9Rxu2/fpVzkNHHyIR9o74W+0dgqHYgH26M2DQwdyICvCwNGUkfxrXId4WHiFD8JmD7rtjI4Sg06PRw9EPnrUS0fgo+JK/B8RWCymKXuKYV5L2sPa5N8W4pcgMQ5QLZrzSzuO2DyQIyOYbwDCrWUjZ6S7NwHc4mYJY3lMmatEn8VaDoZsbH5FOysz9FshEOCx6e3G8aaEpX7PgCK9osocb0DWzCHetpaaDFhF0xp/VbR4R7a9+hsOQqZaKh2E+oTg+cG8CRDlv71v7d3iCEuTQTQsYhD/yuZLno0UDOFwjBjsn+iW0m4CM9k0MWmaPFcMavG4RM0p3hsT5VEvzA3PaY8wMspD0XVvqUFffhbFcYPKZfxc+3s//m9Y9LTzgcl0ofENY4WBQU/K2lFF2zMkcbhGHiP/kgnIMxFn5T9rBvRmnVREJNRRdDgEZz9lGEMEwWnw0e5VkhveTxdyefQBjHqq5rp0PH37cThWeyQ6ZG2QuZzUmoAW/6elFmf9vfTCqqdcwDHWMgpnDDuLjrBiH/OGY3b9z1agzCDmKhwbxrIVk+Wg1UKnDG94C095IHhrNqh8uyaTuank36EDHun7vIdwyJRerBbHOON7gy/9g04p1RoQjw4A1ZRoW6iHoUS6bKrCjnwZaxmAYOAiEVOfnXjAPaCOu21S7d/M240D0o419aQJeGpKD3zGruxpGUsCrlHibIFnSfzwdi2uER3McluxYwft+erryrqVosm1qvS/UZX52yb95rUqnNTDQKENngUopBAdoFe2COPz71GIDw77xxgQQzcEfwlN+FekTHAotHtAVqV27lZIttADJLWSpSpvHGhqWY0zLITUZv4u+Fw16444Um5rymAxl9sPVU7Z2Oshsb6TQ03HswXSyK0aYhQcaSs+phWjvplWI9HSdaUh+gBMW1VI8mzD9YNwpNAY7IU16nN8qNKQ15ACq0quqxXhMs4VEXHSbc2mBlGdkWoOYJ1UrYrpbmo6aJpYeQvuWE8r2v13jtYjJmBxBWFjXkdtStH3GSPPafTNJnhujQkr8p6MFzVv6kenVKThbICJzfBET31LiNRnvjrzNoSgVrsVcptfkticwRqdpPJHWK3umogI+EltIvtF4BLJohcfYaHPWWaRy31YOwpU0FbZdRTsaf15Pm8cgnmwkqwHAgD5W0JuReIkBk9vGu5I/3Mj0HoQzMZnG6rwa45G5f/J5m3KceMaukQ1/Ng8TFTtERzJlFgkzvWEeMIEKtml0RUDDmJEpVwq8hXRBU7Qynxg9CBZKbeoVnyoAEiHVmj57ztRbpsUmgtvld3AM8gb2dHooYJfjpeAp4jHEVZduwlg6bSioXuPUXJlPjo3xzVpJAxoC+Pde+PGOnRQe7v3KnEECxykWj2IW3oEZOcKovKq5SSRh110n8PpiZUlriARCIiTj7ePqDISzZY2K/srgXy24YpMCzKYvqSXyheTBBx15jfI8OGV0oaz1sZBwC18GcGAQ3wQeoZukdKbyXKv18YrnJqvTRl0/74OlhGav2TA0JtJw+NrZXIhhxa6wOerlLk1rwKfG298zC31Chaq2+0tXSooRhccdgRIfgUy08vzXp42xQzuUrbAzUUDqFTI7GDrQpRenUM9Oo+0ilq0bAvBQ3Z4dxB/obqKTo1jeaKOwE5H1QCXYmk9A7tSKn4kOnx3zbjAPXj5h3QpZQzgX2D7sOjYlEhB5gFeKzNB25A2YumyJGauNrrPuFeBPMS2qVDCAJqAnx7OaiY9WTIxuqg+YQVaH415AaqQxpPG84Ic7eIJm++zmP7ClyOar8w0a0cJmGAP2ZSYKY84a3o7Tcm8oU1qVkWno6250icEsP6RGlXEH0znwj3ZiNctMHivxRDaI0U3aWAROLpjTlQ2loCKUN1MBhMtEYVTvWYv6tHP/tHnYRFpYoVU14aeZm1joLMuVsRVwDisLp24hCAPGWkwJew/9o364w1KD12WLnK4Wb2/ZogOmPNmnI75nK6UiOMSBvlPHNEmVTODt1lkwOopMpUZGcacxQuWUy5DFEmkG4IyEgjjeuAKXRjgf7WJ2MBkd4mium8Q0WlMc2WOVM1ooCw8+dDE4nE77tAaXDJGZV/3bFTi0dgygnnCVPZ2S3SvZMqV99UDH99hvwjtCXJaumnjdU6AYUA36Lj46aREGxANbxEULYqVYDmoKgb/ISD/7Hx9LTb8xzNvnDDO3Is5mP/nEPMTRrc2HlImZPqCzTipwxCNr/qvvMBxfTjNc3KIVqwtE43wZ4kPclap66iyiAulFFITAk2eN7KnfxPGiBxybC79ANqiUe5flN5JP9YdLlQwEBFKfNtajeIRg3mxaVS3ZUq9fR+0axMmoe8chr1pZMJ4U4plpmuxKdEQEwPmmhQGSg2eGeNwIGJsQRkSkTNweLg9K73Ay5Yc3Lch249CmpQYFwB1nQJl0oRHkORfMofYW1HGYL7Y8lMiBoEBDNNBBP+O5AdEHA+2HGKe1p0DajZlcp2+F7nxyYngFbcZgK3VNP/3QLh51S/S6OUREtkTT1GuXhWhtoCOXdKKsQqgm3jxEvk5uYlLACyNPPWEYM/kal53MQ+usWjscQY+IXTggH9GBuHkCarQUe51Oq5ujmY30eD7aWdwDqsYMhgGDQ2xa61nzYdxVOeLDlf2ZrfkUAY/BR/uzhzvO0EN7L1huvc3OUOLZWNSqo7fsYVOXUkZpZBkuFsqM+1lzIuQ204FiWsjmYB+JCO1XTxbDYaxFJkzfSlaxj0Gb28cWnWgpiY0+rmbiRh+p7mkyq5irdQ11PpkATkb2L7klDW/FVQbebsNUlpAu6yezqc9dvbrj0tjj9jZiy5NhUNEhmdYTov39YdUkx4Y7cXsIMwJUxJBKjWDEsayVOeBASO3joeOyKeK5Yn0YjBjN290HFBkSjHQUmthDlhqgIBEPqaSQ7oZgF7kcv8P35CifIFdYEzAjcqwa/O58f55lFvvI09yfObfphTAtz0mM+pGxw7er/0bdyn68lYlLEyp27HujJNgyxGPHtFh5HJKMHEx7GJtbqrPMu60qd8ez5Wy+zkPtzdgT2kb480qri0jCKrrvqAv72sV+yokrvD4YATZcLqkcNrH+bVwM80bUorSFMHewJVVtTMBOCWgbr4CcA83pL90E9IyZRkozYwUgTwGPXlrm1BAxuMgPIzvOEQk2xUhqWEglPKe0vBdW2A50+fDOID7apRm5guGYQvGMr72EfS9Gq60dhWH5eJ46kke2KbV83YwK1H/g0o6d5y2p1ytdGnwL1aasVDcPe+iq0nW0SYwZNkxcN4ECErYhkvNIbTS2DwMR5tPfbLBpg28HA6MuMFNOa47cbj8vm7mfV1p8AkT7AbM8NeKY4kPjSxes2PSD7V2TG3/1lD3dNN+YD3Wq0odyMASXB5Y3lpJATDTa7D6HcYfBM2CozYAXQY98FlFuf2cM3biW10yZaT5wjD1tv27MYoIAEd744n1ascC0QZ4gnDIbGkbsCBXQ+p2zV6PHtp0PRGigQDIG0OzHx1IYuANt+PLuR/n4g+JtbzG1fRSoX7uGZNChpOSniW9omV9+wk+MjRZ/aHyR5g3vd3fqr3uzMA/uubKWE13zO3ldv49a0nfhPHbM0aR1ONDBlYYqAnEaYwN3PgY9tKMilrEQ6HfhNG5rgbA2dsd9DFZv3JosbvlxBu20y4GmWEaUILbnDyts606nO9Y7HLOGuWJHX9h4yoktkxVjQQMol2no0UQYcI/uIvbCMY0N/CTtzBGCWvZT9KKf4V+b88MY9dJVzfLVNmN4mvU5Nbxraed/HdJZyQPG2GHQTYWwZfhkbnuBZsTNikDmNXZHKUPrlan2J2WLSCfhBaQ7JgtlA3qWoGgiOy2huadfwKHrCsg+EQE3DqkXYzywoeg7T8m4WU2XyqdkWk3nmxZt4ktovecIh15K6IWR6qWKR7zSiH/AxmjKmE0kYdHT3pdzsAna7pYRrtFSJjIwLhepIV6rCywABHM7f40/BCMy5Sm00e1ZpwctRNMw0Y8g4krO763b+hK8odL7spmT8Ux9+KlhcnN6H5+dWblBvaiVmFngfHAuVcQaEFx6uCh6nOjBOTylZiQNyio+1J6KSVMYxnin2ZiHGoz09QknuDEIyM65pSwG4ugATJ7A8KVtvvKBdJkzosw4jvnD6LeiGW288eKZcFKlS5dJEB+jl82535fwzAFZ+a7Owibv53xxq2M9NfIkh1aLlqa1nAaNLu1fomgn6VBez1/DA+BQQ2gkQ/f4YgRgnWuU4t9IcQxwCh+9gbVIYEvFQ1vs1i2xg37NoRg8PpKuSisAFnJouGtqStcHWDHY8BmlqcrqPf/kZetHEsMKEo/e8b9EtUTRB7T2r1u/9bWIKQFOIdzY6aclqYl3qyobM3mxZ6V+vqSdBGt+8NV9cRxXQ/Uo3SsTjb4pATukkbJymjrXzEQh9jVp2Hp8LEU2Wcu6iIi40EN32Rj6Bo35yRLuOM6wVSfvzDZpMHieyPPZUvwHzhWMuOdaCIcdTzkUnuZhmcdUSu9Eu6hUC9gKwbuNPGkjPt6q+Q+0F0sDo37HdGHOUswBHv3eMm4L794mafabdulTrP9VVESC/paKfNjPjB5an7z9BKXmXEOTFU4zFH9JxAPgf1e7Y4bCClrbSplJDVvETrEdzcgeqCPCSXJ3oI6pEt38Odr2/DLi8V8L/N/10IA0Ay/BnRTwgxiMQD2rb4SkGNKIh41jStSK4+yNL/4f/ukf/88//Mu/+jf/D1X/sar+RS/bEMglVkflQendphHyHxAC7h65V88BDIm1CrC0bJ7D2vIPVVX/9I//8D//1V/963+uqv9QwB8RcZpuXAITnjZMeTA+MUdwTAyjfAN4Eh/jxu2beoZr/eH+H9dF/zcA/7eAP7Lq31qoebiKfy3hjzvhYXBL1HWCqfr2U6A9cegq2XcJPHvK/x9g2gLZnc0CwQAAAABJRU5ErkJggg==",
    60, UI_HEIGHT);

local e_UIFrameworkMouse = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAADKElEQVR4nO2Zz0sVURTHxxKFyEULSSEoheg/yDKDyAoV2wYFEbVtEUbyKFq4kKidUOrz1ypoVYskcKUR7axQiKBFZD90UYQF/dgkfeLgmTqNM+/NzHtv3pv0CxeGO3O+9/t9c+fcc+9znA38pwA2AeeAs3LtpA3AGf7itJM2AH3GQJ+TNpBWA0Az0AlMGgOT2tfkVCKA/cAo8Jb8kGdGgH2VIPwo8Iz4eCoc5RI/HiBqGZgG5kzfnPbJPT8MJC1+C/DLCPim0+IAsDnoI5Z7+syoxrj4lKgBFSOCPwNZYHvULAQ0AEPAa+CiU2lIbRqtSAPANeAFcCJCzClj4GSEuEPAI+BqbMEewmNGyHyEuCqpgbRVRYh7bMY7Elu4IbR5/mbBhPnHGzDjzRZK1mrIJO01FE1p8JiNwHczbkshZJKvXYxEiKsFuiQ9Aj1aB9XGXCSHCzHwzhC1how5DiyyFu+B7pAcbSZuoZCq0sWyu8KGEL9CMFbCmACqgS8mbmccAzIFXEyHnDZLJkbewrA2+0bkuiYE30MT0xFGcB1wHshou+epGjOe1pbD8Aeg3tyr1z4XnZ7Ygz78MqaLu6ZfNNb5GZggGn7aDQrQa+4N+vAPmvu9pr9JuaJgotwGLpXCQB1wAbiubcoEPDf90vp9ppCkylxT6GPQnGY16/R7xpAxXUyZftG4dY0BH0NW0EyI52s8H+uS+YiXPOk06kfcmVewD4G8WptGq0PEdJcoje6KbECJ3hiSf6ZMHhPyK3shi2JXYguZQHdbLsackNA1oUPLiB69rolZSmTDxvkRtaS6mBMATwzZkJPMXrs45bQStv+hg8WiqMy9CfpqxmsvFvEt4EeUvS2wRz9cSQS7I8TdCVyskgRwxfySlyPGbiudsiKfShBhv1xUyAmFnlTI9GqMcbAl2WZUM86DxI0AL41AETGmC1Cuo8VqLZ3HPalSsCNpAzfwhxw3zngOd+e1z5YHFrfLMpXk3EZyNfExCxxOXHjAip311E5BWNBn9zqVCKkctfa57/mLqSN2Vems98Pd9WogYwxknLSB1YOxV9qay61nA06J8Bsb+542qN9leQAAAABJRU5ErkJggg==",
    16, 16);

local e_tabBackground = e_UIIcon:init(
    "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AH+QcqxmVNjdAAANdmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNC40LjAtRXhpdjIiPgogPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iCiAgICB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIgogICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICAgeG1sbnM6R0lNUD0iaHR0cDovL3d3dy5naW1wLm9yZy94bXAvIgogICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iCiAgICB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iCiAgIHhtcE1NOkRvY3VtZW50SUQ9ImdpbXA6ZG9jaWQ6Z2ltcDpkMjhhNjEzNy0yOTQ0LTQ2YzUtYTAzNy1kNDMzZjNkMTQ3ZmIiCiAgIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6Y2E5MGU2MmItZTE5YS00Mjc3LTk2MjctNDI1MWQxYzMzY2FlIgogICB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6YmU4MTYwYzYtYjE4Zi00ZmE4LTgxMWItNzg0Yzk3NTIzMDEyIgogICBkYzpGb3JtYXQ9ImltYWdlL3BuZyIKICAgR0lNUDpBUEk9IjIuMCIKICAgR0lNUDpQbGF0Zm9ybT0iV2luZG93cyIKICAgR0lNUDpUaW1lU3RhbXA9IjE2ODAxOTYwMDI2MTE2MDkiCiAgIEdJTVA6VmVyc2lvbj0iMi4xMC4zMiIKICAgdGlmZjpPcmllbnRhdGlvbj0iMSIKICAgeG1wOkNyZWF0b3JUb29sPSJHSU1QIDIuMTAiCiAgIHhtcDpNZXRhZGF0YURhdGU9IjIwMjM6MDM6MzBUMTk6MDY6NDIrMDI6MDAiCiAgIHhtcDpNb2RpZnlEYXRlPSIyMDIzOjAzOjMwVDE5OjA2OjQyKzAyOjAwIj4KICAgPHhtcE1NOkhpc3Rvcnk+CiAgICA8cmRmOlNlcT4KICAgICA8cmRmOmxpCiAgICAgIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiCiAgICAgIHN0RXZ0OmNoYW5nZWQ9Ii8iCiAgICAgIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6ZWJhYmFkZjMtOGViZi00Mjk0LTgxMTQtMDUzM2Y2M2IwOGUxIgogICAgICBzdEV2dDpzb2Z0d2FyZUFnZW50PSJHaW1wIDIuMTAgKFdpbmRvd3MpIgogICAgICBzdEV2dDp3aGVuPSIyMDIzLTAzLTMwVDE5OjA2OjQyIi8+CiAgICA8L3JkZjpTZXE+CiAgIDwveG1wTU06SGlzdG9yeT4KICA8L3JkZjpEZXNjcmlwdGlvbj4KIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAKPD94cGFja2V0IGVuZD0idyI/PsbA9v8AAAAGYktHRAAtAC8AM0zTMAEAAAAJcEhZcwAACxMAAAsTAQCanBgAAAAHdElNRQfnAx4RBiqg9nzxAAAHVklEQVR42u2aT6gkRxnAv+7601U1b/L2hZBk31myZKOLikcvO91JwBA1ggf1EsWTLCseTfAS8WjAxZNoUAgRERPCQkQz3TkK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",
    64, 64);

local e_UIFrameworkInput = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAAMgAAAAkCAYAAADM3nVnAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9TpSIVBTuIiGSoTlZERRylikWwUNoKrTqYXPoFTRqSFBdHwbXg4Mdi1cHFWVcHV0EQ/ABxdXFSdJES/5cUWsR4cNyPd/ced+8AoV5mqtkxAaiaZSRjUTGTXRUDr/BjGH0YByRm6vHUYhqe4+sePr7eRXiW97k/R4+SMxngE4nnmG5YxBvEM5uWznmfOMSKkkJ8Tjxm0AWJH7kuu/zGueCwwDNDRjo5TxwiFgttLLcxKxoq8TRxWFE1yhcyLiuctzir5Spr3pO/MJjTVlJcpzmEGJYQRwIiZFRRQhkWIrRqpJhI0n7Uwz/o+BPkkslVAiPHAipQITl+8D/43a2Zn5p0k4JRoPPFtj9GgMAu0KjZ9vexbTdOAP8zcKW1/JU6MPtJeq2lhY+A3m3g4rqlyXvA5Q4w8KRLhuRIfppCPg+8n9E3ZYH+W6B7ze2tuY/TByBNXS3fAAeHwGiBstc93t3V3tu/Z5r9/QB/kHKs2KMykAAAAAZiS0dEAC0ALwAzTNMwAQAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB+cDHw8dHGh+y+0AAAIJSURBVHja7d2/axNxHMbxdy44ioNDwg3qLiFCloJDxkJBB8GlU3andlNwCgg6dKp7pi6BCHbK2MEilBuO+weslIYE/QOKi0Mvemm+kUgd7N37BbdcLsvDPdx98+NzNf5Cq925D2wCj4EWcA+4i/T/+g58BTLgEzDO0uR03TfX1izGE6AHPDNvlcAIGGRpcnitgrTanQ1gF3hupiqhIbCXpcnnVQfU/1COF8A+sGGOKqmHwFajGV/MppOTta4grXbnFvA636Sq6AP9LE1+FHdGgQMth6ooeN7XA7dVb81KFdVtNONvxdut+pUF+T5w25xUYY8azfh4Np2cXb3F2gVi81HFxXkXfi/S8+85PpqN9MvTLE0O51eQnnlIC3oAtfznI1/MQ1ryIOLyt1WSlm1GwLY5SEHbEdA1BymoG5mBtJoFkSyIZEEkCyJZEMmCSDejIEfGIAUdRcCBOUhBBxEwNgcpaBzlQ7RGZiEtGGVpcjpfpA/MQ1owmC/SySfMDc1EAmA4n7pY/Jh3Dzg3G1Xced4FoDDVZDadnDWa8QWwZUaqsJdZmnxYKkhekpNGM67jf0RUTf0sTd4Vd4S+Se/nm1SpcoTO+5XT3fMpi69wVpbKv+Z4k6XJ+9CLK6e757dbx8AdLqdgS2UzBHaKa461ryBXriY+QEdl8m8eoBMoio9g001zrUew/QT5UoOwHKsxyQAAAABJRU5ErkJggg==",
    200, 36);

local e_UIFrameworkInputActive = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAAMgAAAAkCAYAAADM3nVnAAADcHpUWHRSYXcgcHJvZmlsZSB0eXBlIGV4aWYAAHjapZZZluMqDIbfWUUvwZoYlsN4zt3BXX7/wk6q4spLqk0CYpAQ+gA7zP//W+EPHuKsQS3lWGI88GjRwhVCPs6n7pwO3fl++qOPXtsD69XBaBKUclZzvMY/2ulp4CwqJPtmKPero712lGsCzjdD10TiHjGEcRkqlyHhs4MuA/Vc1hFLTt+X0OZZXvpnGPAPnknatp9G7nVNiN4wNArzFJIDuQifDoj/JUiFoMhJEA7IBFkkImeJlycIyLs4PZ8Cj5a7qm8HvVB5SjdafC013GkpX0PkFuT4LN+2B7L3VHbov82s+ZL4tb3ZqRGOW/T9v9bIa68Zq6gaEep4LeqxxC1hXMMUbigHuBaPhL/BRNqpIGXs6g5q4+hHQ+pUiIFrkdKgSovmLjt1uKg8AycIzJ1lN2ZJXLhveuqJFicpMiSDYt/YVfjpC+1py9HDni1j5kEYygRjBJWPU/hUYS0/CkQeS6Cnky+zBxtuODnPMQxEaF1BtR3gR7o/zlVA0DzKfkQKAttOE83o6yaQDVow0FCex4XSuAwgRJja4AzOhBKokRhFOhJzIkIgMwBVuM6i3ECAzHjASVacHLDJ7FNDJdEeysZoDmjHZQYShvOVwKZIBSxVw/5JmrGHqompmUVLlq1YjRI1WowxRb8Ua5KkIVmKKaWcSqpZsmbLMaecc8m1cBFcmlZiSSWXUmrFnBWWK7QrBtTauEnTZqHFllpupdWO7dO1W4899dxLr4OHDNwfI4408iijTprYSlOnzTjTzLPMurDVloSly1ZcaeVVVn1Su7D+SB9Qo4sab1I+MD2poTWlhwny68ScGYBxUALx5AiwodmZHZlU2ck5s6Pg+hNjOGnObJATA0GdxLbowS7wSdTJ/RO3kPSFG/+WXHB0H5L7ye0dteGvob6JnafQg3oITt/iWTnXWLBMpiQaY2kFbwpgmD0MKjXOmDteVNJuvR90ht+rvnaGD1Qn1pWBvfrdqAPSzhEJjiVAo6pR9t6tZ/1XtfBbxXstoNoi3lmyF5VII7+rVb/T6/5iSrniFw/PAbbgWmtqwT8ZfHwZal9yrm6gZXwS6HwnY68hZv1LJZz6bhUTmX9/9G48b4Z/yN8Vhi8yfK+8sYR7wB1HM14Mw786/gKBplQJmMCg6gAAAYVpQ0NQSUNDIHByb2ZpbGUAAHicfZE9SMNAHMVf05ZqqThYUMQhQ3WyICriKFUsgoXSVmjVweTSL2jSkLS4OAquBQc/FqsOLs66OrgKguAHiKuLk6KLlPi/pNAixoPjfry797h7BwjNClNN3wSgajUjFY+J2dyqGHiFD0EMwo9eiZl6Ir2Ygev4uoeHr3dRnuV+7s/Rp+RNBnhE4jmmGzXiDeKZzZrOeZ84zEqSQnxOPG7QBYkfuS47/Ma5aLPAM8NGJjVPHCYWi10sdzErGSrxNHFEUTXKF7IOK5y3OKuVOmvfk78wlNdW0lynOYI4lpBAEiJk1FFGBTVEadVIMZGi/ZiLf9j2J8klk6sMRo4FVKFCsv3gf/C7W7MwNekkhWKA/8WyPkaBwC7QaljW97FltU4A7zNwpXX81SYw+0l6o6NFjoD+beDiuqPJe8DlDjD0pEuGZEtemkKhALyf0TflgIFbILjm9Nbex+kDkKGulm+Ag0NgrEjZ6y7v7unu7d8z7f5+ABFucoAj6qwsAAANdmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNC40LjAtRXhpdjIiPgogPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iCiAgICB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIgogICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICAgeG1sbnM6R0lNUD0iaHR0cDovL3d3dy5naW1wLm9yZy94bXAvIgogICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iCiAgICB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iCiAgIHhtcE1NOkRvY3VtZW50SUQ9ImdpbXA6ZG9jaWQ6Z2ltcDpiMDM0MGU2My03N2EyLTQ4NjEtYTYzOS0wY2U4NmY1ZWE3ZjEiCiAgIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDkyMWNmMjgtYzAxNC00MWI1LThkNTktNThhZWFkZDJhNzkxIgogICB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6ZDI4OTM0OTYtNDU0Mi00ZWRiLThlNjItMDUzZWIyZjRkNGUyIgogICBkYzpGb3JtYXQ9ImltYWdlL3BuZyIKICAgR0lNUDpBUEk9IjIuMCIKICAgR0lNUDpQbGF0Zm9ybT0iV2luZG93cyIKICAgR0lNUDpUaW1lU3RhbXA9IjE2ODExNjk3ODY1NzY0NjYiCiAgIEdJTVA6VmVyc2lvbj0iMi4xMC4zMiIKICAgdGlmZjpPcmllbnRhdGlvbj0iMSIKICAgeG1wOkNyZWF0b3JUb29sPSJHSU1QIDIuMTAiCiAgIHhtcDpNZXRhZGF0YURhdGU9IjIwMjM6MDQ6MTFUMDE6MzY6MjYrMDI6MDAiCiAgIHhtcDpNb2RpZnlEYXRlPSIyMDIzOjA0OjExVDAxOjM2OjI2KzAyOjAwIj4KICAgPHhtcE1NOkhpc3Rvcnk+CiAgICA8cmRmOlNlcT4KICAgICA8cmRmOmxpCiAgICAgIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiCiAgICAgIHN0RXZ0OmNoYW5nZWQ9Ii8iCiAgICAgIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6MjZkYmZmZDUtOTg1NS00NDQyLThhOTQtYzJjNzAwYTYxYzczIgogICAgICBzdEV2dDpzb2Z0d2FyZUFnZW50PSJHaW1wIDIuMTAgKFdpbmRvd3MpIgogICAgICBzdEV2dDp3aGVuPSIyMDIzLTA0LTExVDAxOjM2OjI2Ii8+CiAgICA8L3JkZjpTZXE+CiAgIDwveG1wTU06SGlzdG9yeT4KICA8L3JkZjpEZXNjcmlwdGlvbj4KIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAKPD94cGFja2V0IGVuZD0idyI/PpKdhGYAAAAGYktHRAAtAC8AM0zTMAEAAAAJcEhZcwAACxMAAAsTAQCanBgAAAAHdElNRQfnBAoXJBpIS2oXAAAL3ElEQVR42u1dvY5dSRH+PjMxEiS2LBISS0iMRjBaCSRifsQ+ACJZ2/GKYHkPB9bGiy2SfQCQICdAWIN1NcFKJnCCtOwGLE9AEZw+faqqq//uvTO22Xuk0b1zzunu6ur6r+q+xMR1fnH5LQDvAfgJgB8B+B6A7+B0na639/ongM8A/BXAXwC8uN5dfTXamIOM8QMADwH85oTv0/V/cD0F8Ox6d/XyIAY5v7j8LoAPAXxknwgEXBpLpRcBwOU9bG9DBCD1O+57rT+IekY/EETSGFwHQaVD0dAYALb7yxOYO+r9Au7tRgy+FD1Vu4IBoI6Lrmwr3wmgsOhN6Gt1L+lhby4R3rf1WCa2oU5qmC5mBI1pocF9BExnZZ4A+Ph6d/W6hsVvNJjjlwB+D+D9AkjZ+IuQDKcwMYMspAUSDIlVttYUbE/VMwIi6S4Xms8PVmYBQK7MkRCSh1MLgHXxufSZusgQpcaUZS7rMwJ2bom5JcOniZtpydd7XIgp95fmuqKAy/vUqy4EKUmIKNyk8VOPhlK2LhMZmAlLhhnCDbtuKcjlXcOoTHNKk5QNEW6llLQllEDcXhBFmF5kLeu3zW1ddxYSQuyc0wKt8nD9Dk+fFEUHVLQAAPgxgF/cvXf/9ZdffP6PIQ3y/YvLOwQ+APBJHi8T4EKMp+t0vavXJvToqf8xgOfXu6v/6pt3gg4cc2yq6jDmkEDmoHKv1+ZNX7PziJ7LRN8RTmSwbzki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",
    200, 36);

local e_UIFrameworkIconButton = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAYAAADhAJiYAAAB10lEQVRYw9WYMUvrUBiGnx6XuzlJYgYRBAW1dChX6nhxuuAPEOrm6NBRcHFSUFw6dLxj4f4ANynF6RYuZzicKgpODg3JJv4Bl69i01StNs3xGZOQPPnOSc73ngJjUiyV14AtoAKsAgvArJx+BB6AG6ADtKzR1+PcvzCGyB5QBX6N+Q5toGmN/jMRoWKpvAPUpCJfoQPUrdF/PyVULJUD4BDYZ7I0gBNrdC/t5MwImZ/AObDL5NkAVjw/uI+jsPeukMgcA7/JjmVg0fOD26TUTMownWcs02cJmPf84CqOwqf+QZW46BDYZnpsyzOHKyRf0ynTZ8Pzg7s4CrvJCtXIj9rAkMlPr5KjUEUcXipUJX+qAAVZm7q4wbqShdIVtlTOc2doLilpIVxhVUk/4woL6lVz5QKzCsdQ0na6wqOSHtgVHpQ05K5wo6TXdYWOAloOCbWU5Ka2AzJta/R1/7NvOiDUHIhBxVL5X47rWscavZnsGOs5Vqc+1FPHUdj1/GBOctM0aVijz0aljhPgYooyF/LM9FwWR+GT5wf3wKLkpiy5BI6s0XdvJtc4CnueH9wC85Iws6rMkTX6/4eyvUhdAT8ymFMN4CBZme+3HZMi5saGVYpYplt6z9UMkYYDW7gmAAAAAElFTkSuQmCC",
    36, 36);

local e_UIFrameworkIconButtonHovered = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAYAAADhAJiYAAAFcklEQVRYw62YP4tVVxTFf+uMRTqrzPNJEEEwoI6DDsqkFCvBDyCYzi4pLAM2qSIk2FhYphTyAeyCiFUGgsroKApWEtQZK7HOWSnO//tGo+IM97377j13n33WXnvtfa74xL9jqyePCp0F1oEjwAFgb7rrt0YvBE8MG4LbjzbvPf4U+/rYgSvH1y4BF5HPDI+5WbHTBaF8zYDuADcfbd77/Ys4tLK6dsH2ZUnrNghXP9LjblYMUrpuG2kYvQFc39q8/8dnOXTs+In9oCvAj7jONCIyGBlvWNXdcRJzA3F16+H9l7vNu7SrMysnTllcw3zfA0E3ycKqVIYI9yMWHzgNfLs8mz9/s/P65f86dHTlxCngF+NzfTSKUVdYBPbCfC7wlPiV0JWxyeBhwcHl2fzp1KmlMUwn9yOuGZ+rBtw5kX9LzTN36NggA3ILlZ1D6IpgdvIQaD7bN7+7s/36XbEfRnx8BXNeeRl2/SDa9XeMpv8nujptl7HGjkRMJOKYVmbHxkc4D1zZFaGV1bULmF8L7GV1sTCifLgLkdu3yU5MqKN+XA6jMhYSSDq9PJs/29l+tTUgZHwZuSVTnzQxTRZjJOYYxmiiY/12jNj5iK5HeSZW91STo9gXXB4QWllduyTzQ1WZSZZjEtQZvURcT9g+IhEnY5JYiiCqcSEkAfpmtm//Pzvbrx4UhC6OMahc7DSGvPoIjpkXMXMm5iPzxjHzJfFplKGpALrk5kUArayuHQW2XDzInClGo41jCk0KiXcXo0qccUqFQFBCoj+noCMIKiKmY3uAs1VWKjIJYnfGlfI5EfffSM7eIjW7KKUJCjUJgpIkWMrSUC3n54Xg7J5ctavRWpZsPJmtKI9FCh1gT+FKEyxJbVJR8hbZOKjQu64qr2F9D3CkiaoHbsqerN5DQscYW3G1a9kIIbScqtFoCy4IpevqkTgSgANVaVksoNIHKrHIqZ/TvzhIy/BCOYqCFy8Hw/X8QAD2ukWzGisct/tgFeRaKgqqBjXjHjSjqYGyhDjNpTKkjtgbSmjksVEQo3hVg6oFchEyuSqqOm5pgqoy9zQUb9da9pZMOveO9KvVWA/6/qdwJvFGqN5t1jxpRfqCXImSwvY2AC+wUlg7eN2TyWIqnMVi0BJSQCpODZKN5Oqiup6qhVV9rXwRgCclzVkgddaMiQoWXoWg4ZBECGEgqq0h4kNxZsoLPQngDeoqJkXcXiRA/gwhoJCRUToP+be01GIrL6rGQujrtY09oNtF7JrMdIJYRCS2UCijoK4Ka0EbihCOpb0SuWt5u/74dkj7Jt3pGVdoKDE4mpBRq00dfwpaCmrXFBr9aO2utQs74M6jzXuPS7W/OaR9t60aYQ3pyOEZOKTyHQZOaaKs0x5drd7fHABeOX7yL8O6c9tAbUP73qYTvSIJA4TpdylDqSh3dTI7TUG4VfyNrc373006Rl1fUEWVSq1MXlUSB4EIGZkwoER3DYTyvT5m6nstc32hp97ZfrW1PJt/rbRvymVDhJA7u1BWU9rQjkuM9+p5d6/1QK3tIAihG1sP7//2nl0HVw23SraHokWTyUKZiIaAaAi1MaHyqtzPCpxbG24BV9+7L9vZfvVueTZ/DhwUOlQmkiarDM3BkMdQpEChIaC2u4CQEFGpCvwJ+vnxowfPPrhzfbPz+uXybP6UoDnoMJ0j0Dk1Ra7rbcr1FOZ2PbT+81Z25u+P2tu/2Xn9cjbbf1fSV5JOD05pRExMUaS7V4RRddch6Yakn6bIfMbrGNZrIewlTS7ZXvvjWqTVirKsDcuf/zpm8fVMemElcaa1wl58GdP3ZokrX/aF1S6IHc07lfGVXvLoLfAidxAbfMYrvf8AbHwJzXT/Cl0AAAAASUVORK5CYII=",
    36, 36);

local e_UIFrameworkCheckboxOutline = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABoAAAAaCAYAAACpSkzOAAABQ0lEQVRIx+3Wzy5DQRTH8U//+J8Qgh0aKwtNFxUeQLyA17HwCryCd7Bg5QUaaaoriy4sLJD4E4Ti2ozk5sZttbgLcTaTuTNzvnPnnPmd4d/6tFy8U65UF7CGZQz16fMFTRw26rXLj4/FxKQNbKH0zR84C7730kCLAXKANgYxizuc47kLYACrmMNSfCAJKoR2Bpu4Rh4RXkPbySawg/mk72LKgiauG/XaTS/nVa5UcyHuheSm8ilrpr6w+7TkGv5sIP8LmRxlAcpjMgtQDqNZgF5xkQWogOksQFG46JmAHv5U1r3hqhfQaZD7fkCfZl2a1pUwW65Ub0Nwo1jtysX6USI+40G+uoLaMa3bDYtf8IixUCZGcB+cPsWUvR1Ufz12p1JBJ2hhJTFnsMcjbKHeCXSE7VC0BroJZYdSfoz9/5fSj9g7b5RD/3ztK0cAAAAASUVORK5CYII=",
    20, 20);

local e_UIFRameworkCheckboxActive = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABoAAAAaCAYAAACpSkzOAAABQ0lEQVRIx+3WvS8EURQF8N9OtvBRCIVEQ2mj0fsPFFQqDQnxUVAoCJV2C6Ve4h8QW0pUgkqBQuhEVqcTkU32aqbYyFp2dkTjNC+T3Jwz59137nv8IyMKjR8RMYBpjCLJyFnHHSqFQuGlaUVEzEdENTpHNSLmGrk///UohnLYqSGUWgklObYl+S3in6tmROAGZ6h9VVTMQegcW3jFKfrzdhS4SEVuMYvuThzF57ylWbnCRpqZbSyhK2uPnrCIw4b9r+Maq3hIHa2irxXRd47ecYmT1NkM7rGAR6xhHT2dnroR7KEXO9hvEFnG5k9Emo2gcpNxUouIo4gYS2v6ImI3It6+GUPldg9DEVNIIuIAE1hp1fhOcpRgEuMYbFek3cAWMfyXIyiTUD1H7noroTs85yBSTbm+7FElXUs5XOXH/y+lXPABswTNAouzEcUAAAAASUVORK5CYII=",
    20, 20);

local e_UIFrameworkSliderBase = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAAGQAAAAFCAYAAACzSkmrAAAAOUlEQVQ4y2NU19RZwcbGHs4wCgYc/Pr1cyWjrr7x/9GgGDyAaTQIRiNkFOCLkF+/fq4cDYbBU4cAACrRDefTDyIoAAAAAElFTkSuQmCC",
    100, 5);

local e_UIFrameworkSliderCircle = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAtUlEQVQ4y8VSOxbCMAyTGXqP7u1EOEsXDoU5Q5feBSa6s3KH9j0xYHh+bsJvqSa/yFYcRcDakHhAUgAkAHsAjR2PAHoAJxFhUY1kRfJIcuYSs3FVaVis4RPUtlwI7MLNN2tWq/0mKSegYbh2XB1EDk9u4zQaVw8icn05/agHx7c5gb/gBUZXd/EJADrHX3IeJJLTFyZOJRMlGPnbN7ogadjE36wxSKUoby3KrXtzD+D8Nsqr4A5LbD11206LMgAAAABJRU5ErkJggg==",
    16, 16);

local e_ragebotIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAACXBIWXMAAAsTAAALEwEAmpwYAAAB00lEQVR4nNWWTU4CQRCFOYVggrgQwmUM6kI4g8QgeB0CulRQ0CvgwngG8Qb+ABuJYD5TpiZ2Jt0zPTjR8JJJJlM/r7v6VU1nMusG4AG4/w/ib/wFUQ5oATfAmB/I+xBoAtk0CTeBM2BBPMSnI4v8Lek+MNOk78AFUAV2DLKifusBc/02BSqrkh4Dn5roEtgK2e+AUehbAehrjMTWk5IeaOASaKyw6KbGSo4936BNo7yJSY08LaPsOZ+A86C8q5Iaua41V9enZRYqkq0UiLc11yKy1YDTuN3KgoArPY6Z9nA5wj8QWzOK+FadDiNIXyz9++qqEFBTn2EU8ZM6lRx22akLPUdMSe1jm1F6Mow7i1+gdhumifNidxglJJ54Eo9sOw+Gf9FRNhGSC1ZB6kgVPNrsgZP8eQRVh72sQgrjGcjHiGsQN+qcQjGU3dOJNNU5nvdop0YUcdYYIIVMegPkA9iIc+7qCvspEA80V9vHOaclFJyk8JN4i92tEVQxfovNFUmX+uwmDa4bF4Gr8Jnbbpl6pkF5hfQo6aLNnU800VzVXDN6E32vqXrnRnmT7dSh9I7nZU/U2/Y+Ux9IMhGbljJ8vR2oLT1CFwLWzF8Dyy1zLfAFAI4+cX9/SCcAAAAASUVORK5CYII=",
    30, 30);
local e_antiAimIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAAfQAAAH0CAMAAAD8CC+4AAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAADlQTFRFAAAA////////////////////////////////////////////////////////////////////////Cjo1bwAAABN0Uk5TAA8fP/+fv2+vf89fT48v79/25UPIKJ0AAA5ASURBVHic7d3ZQuNIEkbhYl8LmHn/h53BQOFFyoyMXP5czndFd1tyEqdljLGlP38AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAF26uj64ur5SrwRN3NyeulMvCJXdblMvC/XsJP+/e/XSUMXDfnIe5ScVTv7pUb1ElBVPzo/22diaU30m1uZUn8aTvTnVJ/Gc0pzqc0hrTvX+Xb88RG6R2vz2ucnC4fF6dfSz+mb3ZsnNOdR79fcy1dvmDR3Nqd6lvafjl7d0Nb+N/cRAaynHaNIva/u7gdZ7JNfpmyKczXd+VEAi8Sj1NudQ70dyMH/0D913iSOv5mI/W/ib87t6H1KSOTbZ2QWE7h3JYs/5gl7F3zB8L5/nNOdQl3MleyP6wDyvsPzJPdBvn9Tf9tJcyR6zo3OoC+W2I/p4ZM2pLiNsTnQRZXOqa2ibE11B3JzoAurmRG8v8eV2os9AnZzo7amL3xK9OXXwW5o3pw5+S/P21MVvid6cOvgtZx5qTh38k3oGq1H3PlAPYTH29zpXxHug21L3PlAPYTHq3Acc6E2pc39RT2EtL+rcX9RjWIu69hf1FNairv1FPYW1bJxKRkE9hrWoa39RT2Et6tpfOAN4S+raX97VY1iLOvcBzZtS5/6insJa1LW/qKewFt1va8cX9FFPYTGy5p93/vBBcgFZc667KSNrztEtc0f05Sg/tqb+3pclbE50EWVzomtImxNdQtuc6Ari5kQXUDcnenvq5ERvr4M3PKtHsJzMs3MXoZ7B/O4+Hu6vf/9RHfyTbhhLeD2fs7L1P8qJzO9i0LLOJ7RDmdz5pG9Ekc+p5zKzs1E/SwJvUQ9mYuq0+9STmZe6bIB6NNNShw1Rz2ZW6q5B6uHMSt01SD2cSamzBnHN7CrUWcPU05nTozprmHo8U7pWV41Qz2dK6qgx6vnMqIN3SYSpBzQjddMo9YBmpG4apR7QhHp4P1SYekITUieNU09oQuqkceoJzUdd1EA9oul0cqbXIM4+Upg6qAV/cClMHdREPaTJqHPaqKc0GXVOG/WU5qKuaaQe01zUNY3UY5qLuqaRekxT+VDXNFLPaSrqmFbqOU1FHdNKPaepqGNaqec0FXVMK/WcpqKOaaWe00zULc3Ug5qJuqWZelAzUbc0Uw9qJuqWZupBzUTd0kw9qJmoW5qpBzUTdUsz9aCmMsK7Ij+p5zSdh/jM5dQzmtCTummUekIzUjeNUg9oQr2cAXafekITUieNU09oQuqkceoJzWeAN8qpRzQfdVED9Yim0/v5xA7eDkvl06ulqHumuY5/Q4jq5/INNup5TUEdMZV6XjN4jY+5L+qBzUDdMNmzemITUDdMdq+e2PjUCdP9VY9sfOqE6W7UIxufOmE69cTGpy74z3/+a72lemTjq9mxEvXIxqcu6KAe2fDUAT3UMxueOqCHembDUwf0UM9sdEP8Jf3Mu3poo1MH9OAFuUzqgB536qGNTh3Q40k9tNHdqws6vKqHNjx1QQeO9Fzqgg78kS2XuqADD++5mqUqd18c6bkKhYj6vrv3cruCW4kKKaUK7gpuBSqkhCrwUUnhsGaRHyEtVMl9wSk/gsH97v09py9DMqa5lGxr6vT7b+986+BXtmzlC1+yXCjV/kfet+ozmV7F1v+YFnJn3RtHeraasb89lF1J3XksoWbtb9Z3PRh3V3Uca6iaOy2TcW+cgSRX1dj/2NZifS5XdyLTMz95ymVbjnFnxucI2FS186my63msPJiJVWx8ofCCKk9mYvUSOzOV3Rs2NPuBbu5UdGfYUq+vN1TJfWFTvbzeUCX3hU318rpLFdwVNlXM601l3A8nknOr2ndT9FUV0174JT1D5cJbiiypxWymVTmwJ1iJfSCkct9NkTN8mvbRZjqTkly4JfzxFNMuGo1nUpX7epLl7wFhtfu6msUv+NtkNtNqUNjRLPpWihajmdZji8SOaLnbI6BFYE+1yNa87T1Hk8BbIq+iRrbmfZE5mgTelLUuzkmQo/GbKI6E1xW5elSb4UyrTeH0cFkbI6xJX0e4nG0R0SSvI1zOtohoktdRLrIpz+RyNKm7I2NdL63mM6Umdff418WnmnK0Op3Ypv1lPUS25EjP0qTuHveqONKztGi7y70qLueRp0XcXe5FtZzQhBqkTW/n3hAWsadMde2tyr0hLLTR9+JFt+OZXI4GYUO8q7KcixB7nLGuS/3f4lwVH2XL4W714tzyYkeuVXGk5/Cn8m25uSvHqpoOaTYZpXybmurFH0Zazmg2kfclhSfu2vbc9ea6rEuAg6vTz0cQy3wSzreudiOaT16mIlfh9i2s0XymlFvJs72tn2sjWOQ3ust+kN9eWWS31SczsTKJfLHD/YheTaFEvtrBXYav8M1llTOUCZRZfXOPz4ENPiKnMEFI8mupu0dYRvPtE4SdR+eTqqUk99nd001O9a0dnkXnrZDFpNYJ/Bk7J/rWZX3OolcbwXpS65TcV2S/RK8lsU3w00ShZ14xG48gRK8lsU3RnUX2TPRa0srE3m2eEf3ypzrRa0krE9tb+PWUxH0TvZLEStH9EX0AhZsXrU70SopHzzhx0fmuiF5J8egFD3WiV1K8eU71sx0RvZKuop/dAdErSUli/XgB0TvnT1Jop4F7eA/9R7glPdc279Ud/S20m9Lf+7JSiiRcCc1dPbSXwt/6utxBCu6X6I3Viu7/KOyv8zfDFv3GV9Zb9Lv9PXCdzVISeqSdw8v757b9lZX+1hfmyFF8z1v3cvk/Tdnve2n1ovv+8rK/rrLf99LqRfcd6s+7G5f9vpdWMXrOh6CviF5Rzeg5n4ImekXmGK7PCxK9S6kxau2e6A1Vjm65PvLmHV2e1qTUd4zUFg3uau/m2QvAt4bRrfe1d+v8BeDA/uH0AndmvGj3962JXou5eZGRE70H9ldKi9yd7XHl+8ZEr6Rtc+Nf3vbWVmYNy2vc3Pjb297iCi1idY2bG89Z8HXbyxffS61ibdaXTYrdYcrP9IrLWFrr5kkP70SvwnigF7zHlCdyRK/C1rzkrFN+phO9hvbNOdLlBNET7nHj2gElV7IoY/OibzZP+d+M6OUZm5edNNG1+m1+Gv3v72ZF17IiRXNX9D+/r82VXcx6JM090T+/ujn59/AyDT/ts2tx1qv7HC/x86uXk38Pp5ThF2N9k87z8RqPNyy8ntUomvveF/n5FQ/vJUia+6O/ET2fprk/Og/vBYwW/e/pf4BD0uib3y8/02tQNfdHfyB6rt6jv5/c/POrV6Jneuo9Os/ey5M1t0a/O7n551cc6ZmML4XWuGtj9JObH77iV7ZMiZMX3vXvP/DsPY9x8H1F5+E9T//R709ufvjq57lnjUUtwHwp1Bp3brvnx5ObH77i9/Qs1uZ9RefhPcsA0Tce3omeRRrd9kmH15O1Hr7iV7Ys0ui2s16crvXwFdGzSKO/x+92O3rNRS1AGj3x7/hEL4To67G+B7nSeImuYG1O9ImIo5seaP5drenzH95Pll1nVbPTNrf9zvb3eLEfJ8uutKy5SV95/2M8NezPJVx4eC/D2vwtviuXtFdniF6ENXqt+yd6e9bmH7UW8BC/b6KXZW1ecbYpd/9K9AI6iG56Jvl9W6IX0EHzpCP9iujZ7JdMqrgI0zO579s+ET2buflNxUWY/rh6suCTtVdc2ZzM0eWrOLnpyVZVlzYhc/OaBzrR2zJHr7sMywuxx0t+Pll83bVNx3z1tbv4vnIYPjL7ey7al58viO5ibV59rq4VEN2F6AvqpXl8Jc/72zzUX91MzK/M1F+KZwXNFjcV67snruovheit2D5Q1GSsnhUQ3cP22ZImY428/L65DdE9jA/vTdaSvgTOSeCSdrH6ypKXcNd0edOwRX+J76iE5Oh8PN0l5cKH1SWvgfMBu2xc2G6g6PxM9+kpevD5e2iDRuubhuWHeqMf6eEXDbY24OHdKd5860XvKpKjc6Q7xaM3WwoP76300zz8o2ZrAx7enfppHv6T39YGj+3XOId+moffMrW1AUe6UzfJI68UbW3wLlnmBPppnr4W1TpHF/qQcN13um8gehuht0A3XwzR2+ipOdEbIfp6Aq98XrdfDdGb6OpAD0bfelZJdJdxovMBl2KIvp6+moejP+3fvv1KR9ZX9MhnrC6fWRLdY3/C1c4TGBD7YN3u8gVrHVfg8y2K5USaXy6K6A4pR5V2OdurIrpDX9Hjzc+XRXSH/eFWPsNM4mr2qhM93c3+bJv/VfXn7J8xJ2/HJnq6wGz/xrduuJpjzxubtF/suAKjFZzFxRj9+FgnerrAZDde/hKu5tTlJu0XO6zAj/Ren7yfLY7oyUJvjxMsxx799nwTwWpHZTqYuljNha/nmf/eJ99+taMK/orUfjlJ0Q/Zfz8F1X61o3oNjLT9GI0nv+lktcMKXt+0+WrsFxXpYbXD6muM1hPa9bHaYfU1xpzmRLcKX726+XKI3kJfY7Seo3Zbg9MVz6Gv6LYr7Haz3FGFp9j64y1Zz+OobpT8ztO6Mps3O+vZ2Do7dDIf3jnUTTobYt4TOaLbxIbY+PE9/Ask0cvobYpEb6C7KRK9vg6nSPTaolNsdhrgEzfH+YJ//CV6uugU39UrPLgyvmwjeJ/+gAY6diyXHFGvcQxjzfEx8sYa9foGMVb0LQMttRvDRz/6FtQLGUaseR9P5IJ+lnqvXsg45jnS1esYyFu4+aN6fXFE9xj7QOcc/wU8DVX8D0f6koi+IKIviOgLIvqCiL4goi/ohugL+mrOJ9kWc0VxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwOd/wKG3ncGK1bYAAAAASUVORK5CYII=",
    30, 30);
local e_visualsIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABmJLR0QA/wD/AP+gvaeTAAACwklEQVRoge2YO28TQRRGvzF0KOkgxC4xEkGiQ2l4KJRIgGh5FAhET+jS5ReYEuUFVUSLSH4FJVIAJa5AedNBgZXAodixMt74MbO7EwfFR7K0O75z73dnZ2b3jjRgwMnGxHIMlCQ9tLeLxhhixYoC8JgDHsWKU4rlWFLVub4YK0jMBI6Ek5MAMAyMxRRj41wGhn3tvRKwDlckfQZm7Q7Ti0aH604xSsCsjbMCDPlo88KOistCrySAKrAGrAIXPMQvpGIU+7TtyAcl4em3nfjZIjT7BKoV4PdVnoEJehNbx3OSntqmTWNMOWUzIumupHFJo7Z5Q9JHSUvGmJ2U/ZakEXv7RtJzY8zfEF1B2CdRAzaAF057BZgH9unMnp2KZaffpPVVK2JKZk3qGrDdRXiaH8CtvohNA0wAjQDxTRrAjX6Lr9jRzMoOMNo7UrwE5nOIbzKTR0PmeoBkt1mXdCqPAEn7kirp3cmXPKv+nvKLl6TTku7k6dwCB5VUJfXXH0nvjTF1e381a9A2jCt5BwioSrqvw4OzLp/KjtZKKs2qY7dUwPxv8sHxW+9id6iyO471QFDtfGgKSVq0Tq6k2n9Jeufcb4Tp6orr67akB5LOpGw+peLnA3hW4BR6klVHnm30nJKF1e4phrAvqWyM2c3SOfMasPv226z9Heayis8NUAZ2c0ydbeB8X8Q7Sdwk28fcb+B6X8U3Ifmc3goQvwtM9EtsiaQM3AQmnfZRYIakaOnEHvAaZ9oAL62vTAVNjJLyrA5KyuZ/60pKyuX0guWoSkriFfW1lM9CTjvaBfp/j1XIfrBVt79qD9u4B1sk56LfreMZn5EHphwxUx72Jecpf6PIo0UbYAi4FGA/7SQwHdBvLES893eMMeanpK++9lkxxnwJsT+O9UAQgwS6UHeu12IFyfst341mZYeKrKQGDBjQwj9xiyOIITS/uQAAAABJRU5ErkJggg==",
    30, 30);
local e_settingsIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABmJLR0QA/wD/AP+gvaeTAAACWUlEQVRoge2ZsW4TQRCG/40tmqAgemInUtIAEu4Cb0CchgYkBK/jBwgIUVNESDS8gBtsKQ+AEJWxA/gBQoGUUPBReJGs47y3c751hHyfdM16duafvbvZ9ZxUU1NTU7MELoVTYF/SI0kbfui3pPfOuVGKeJUCOGDCv4yBJAtWKUArR/xftquOt1FskiuyAbQXrOidwNS7Ob6c99Uoo8UMsAUM/Ip+ANp+vAkcAf3AHeh7m6af0/Y+8D63ViH+NCPqHOgBXwLCs4z8nPPM+GmyJPxjMzSILMsAiH60o6sCsCtpXCp7OzvOua8xhpaX+EzSoJweE4NY8ZJxIwNuSfoo6aZVVSQ/JHWcc2exE0xl1Dk3lfTaqsrAK4t4M8xKZVG1uQCOgQNg018HwAv/W4gRvsSmSuCoQMAUuBeY3/E2IbophLeAh4Q3qYuQ+EwSoTvR97FaVQjfJ/9glsexwe/LSJ9jYC/kq+glfixpJ1LXSaSdxXZX0pOQQVEC1yIDSdJng+0ng21QQ6nTaAVUFrfI0S+Dr9uJbIMaihJ4J2kSGeh5pJ0kPYu0m3gNywFsE1dGOxG+OsBlwE91ZTQneLeg7E1DSXBVG9mcgCaz7T7EJbM6fx+47q8Hfiy08pD6KOGT6BWIWIaeVc/6HKeZdSBOlE68JN2Q9AZD/2it/lJ+kzQsp8fEUNL3JJ4Jt1WKqtM8q2+rZJJY1NjqUtzY6nJVja25JBos2CmBw0AChwvmtDD0gpLCipu7lcOsWTvOEZ+kvZ7qA8eepKeSNv3QT0lv/4sPHDU1NTXrxR8yaoA8EZCxiwAAAABJRU5ErkJggg==",
    30, 30);
local e_searchIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAABZklEQVQ4y9WUv0scURRGz9s1RvzNNrYKNgurIcKmElIJgdQipJDttbUTBBsr/4JAGmMTAkmhErASqyStlhtWbbKQaKci6LF5hY4zgzvYeOHBzPvmHr6575uBZ1tqUCfUTfUsrs9qTQ1FgBPqkQ+rpdaKADfNro0iwLMc4GlWX8gBXgOlDPkmhFBOE0o5Jo9ztFaWkAf8BJhmPmodz7Ci7qTMb1utdDzDCC0D88D7uLUFfAHGgQpwATRDCP+Khn1A/aqeRrfn6m/1zWOay2r/nfuXEXaizqm96qS6G/dGskDd6qz6Q/2lNqKzSfW/+iHx/Kj6R11N+3br6n7KQbxT38brgURfSd1Tt5KxqQLfgemMeF3GQxhLaENx/U0Ce4C+jJFOAU3gEFiPrxnUYaARzXy8Fxv1BfAKGEyJVjuEcKDWgW/AFXASnVWBLmAFWAsFojMCLACvgXZ0NgMsActP9TMuq4vqz1sTNm6yEWvGSgAAAABJRU5ErkJggg==",
    20, 20);
local e_saveIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAA9ElEQVQ4y9WUTU4CQRCFv2IggYUL9Bqa4Cw4AF5J3erGY4FeAOLCYyAbVvj3uXAmtmZ6iMQYfKvqflWvu6q6C/YdURtqFzgBhgARMUsd1SFQRsRUPQUGwDwiNo3K6khdWqGBP6v31Vv1Sb3+7tdJ7EPgqCWb9JA3oAdcqTdqv0lwV1wC5VZBdfCl2BGziKhrXiRUF+inixzu1HXauESszAW1CY53yb/z2+8wd8M1cA88Z/geMAIOaGnCxE+cq0WLb6FeJP6TbSkvIuI1+70+uPmf1HD/BdMur4DH6j9PG+ZDDssqtnF8HVdD4idYAQ8R8cK/wDvcAXjWWQqzcQAAAABJRU5ErkJggg==",
    20, 20);
local e_copyIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAA1klEQVQ4y+2TMWpCQRBA3w/fQtIldcgVtNFa7+AJYqqAoHiUgKfwBgHFzkJI7xUsFEQLoy/Nfgjydb9oI+TBwjIDb2eHGbgxyamE2gLaQHqcAoZJkgwuekldms86nJ5aukR4ion6oW7U/jlBqlbVakT4FfIddav2cytVK+pCHUWEU7WsltRuqLSeef42/Al4Bg6RbtSAzVHsMbs83Hps/oV3Isxiq4KOPbDLm8OMF/UVeAPegdi+zoDvvE1phk3Yq2O1ctXf1YbF2RXp4TyUH+MH+ORu+QUFlQwCd0jpHAAAAABJRU5ErkJggg==",
    20, 20);
local e_resetIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAACXBIWXMAAAsTAAALEwEAmpwYAAABBklEQVR4nNXUS0qDUQyG4Vaow+7BaavOHbkMES1W3IF78DKwWpXOXIFbUFfhbRleZyqPhEYo2Pa00okfBALJ/54/ycmpVP6tsIgu7vCeFv4pGgN59RJoHj18JWAPbWxhHw8ZC/AqLkqwGzxhDdUhOVVs4llfl+OAvYQ1C1Ws4GUsUL9nn/FnBVg9ygxQ2u6oxJ8B/CrzT8J9DGAmsBBesV2ZUljA0SyBOzGgmZWMA9wOC5wkdOKhYA6P6AwLNvParE8BbOU3jVEJ57kBSxPAlvNyd0urd53QjTGr10rYFWqlkwN6lqXEQ3CYj0M7/ejZRy5CrVTJIDh6ehwTxFta+J2RPfsX+ga6rou8xBvhrQAAAABJRU5ErkJggg==",
    20, 20);
local e_pasteIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAiUlEQVR4nO2UsQmAMBBFs4WupL2VE1noIBY6g26iriE8OTwLk2gINhZ58CF8fn5xJGdMAKAENlVhvsJZNKjW2Ms5MAM7d6RstLxds/lbYQcsQA1UKpvLrzXbvhX2IstrLl/OobyJClikQpc0wyDp2bjIR/cshydJZg0thwyYPOvLh2Qkmz0W/pIDIcWoNV0X5tIAAAAASUVORK5CYII=",
    20, 20);
local e_keybindIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABHklEQVQ4y72TTyvEURSGn6tBLGSjiNIMi5EFH0DDdhZTbC18Btn5EMr3kGi+ggVmY2E/akIiMsnfWTwW7ujnZ2ZMlLdunft27nvec8+98EeE5EbNATPAE3AUQnjuWkldU1/VU/VaPVfHuj08pTbUC7VXzfqBfTWvPqj1xLpXFwAyUSMf42FgHliNfDGEsKzOpmqWgZGkwCMgMAhUEom3ACGEWsrxWzNuChwDNWAyVWlLLQDrKX762xTUUaAKDERqG9gASkAufW3ATgjhsudTKYQroJFIOgAKLQ5/QaYNXwUOgWIUSWMptryXHmc9jq+s9ncYe0Vd6eRgERhXX9rk9P3Uwi5wBpwA2VYmgJtW1jbji7xTJ371u9Q5dYj/wjukjaUMz/zXlgAAAABJRU5ErkJggg==",
    16, 16);
local e_colorDropperIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABCklEQVQ4y7WTsU4DQQxEx+FOoiA1KQ4KeopU/MEh8Q/QwG9QBPFX/AMSogZdgYQIEkWKSDngHgUDLLAJRIipvF57rBnvSn9E5JJAKWlb0rpTd5IuI+JxIRsQQA2MgQ64Aq4dPwB7QCxqPgEmwJRXrAF9x1PfjbIkwK4LtoAKmAH7wIHjyncToP6mGbj3lArYAFo+0DpXuWYMFCnB0DrxtLQ5JZk57oChJPXMMZDUSOpLOpJUZmwqJR26pnHPO8Eya38zcHWehN+gBXZyJqZ4Ai6AW5+PXVcAK7k11sBzQjDy29j0OefLJw/OJJ1K6ubo73506MtTbhMJDdBb5jMV/kwDr+88Im70H3gBIGCTNqyE0rIAAAAASUVORK5CYII=",
    16, 16);
local e_colorCircleIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAm0lEQVQ4y8WSzQ2DMBSDvxQp08Cp6TYslc7AOOVUtgmSe3mVIkLawAUf34/j2A+uhtsWJDkgACPQW3kBJuDlnFOVTZKX9JS0qsRqPV9bdjbwD9FUFgSPyst7SsJ375ZxjEDX4FtnswVBf8D8YY/gFHKC5cDee8/EICk1mJhyE7cxxtMxZocUK0qS9XzLKd8tqiH78wTMP0/5EnwAzUoRODa2XCwAAAAASUVORK5CYII=",
    16, 16);
local e_colorpickerWindow = e_UIIcon:init(
    "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",
    130, 180);
local e_selectorExpandIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAdElEQVR4nK3RMQ6CUBCEYaQnaui5hWex8BBeyZoDEELHNfASUFp9hkjxQpT3TJh6/tnZ3SzbU7iiwSlmLPDw0YDjlvmymGbVP9OR444XRtxiNdoltUeVsmD7L3AIKk3RSgGYtvQKCs/6xDl12vy4DmUS8E1vE0ibEcroNksAAAAASUVORK5CYII=",
    12, 12);
local e_selectorCloseIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAp0lEQVR4nKWPrxIBURjFl7GFTYoZUaR5AyPKsuQ9RM8gCgpd0cx4AkGXFPXud85njjFzo7V3xsnnd/5k2b+SlJvZKBkwsyVJkdxI6qQ0FAB2EbqZ2Tipyd3nAJ4ASHIlqVkLhRAGJC+fNgAnSf2UiS2S5wjt68xdAIf451qW5bDSTHIC4B6Tt5LaVak5yTWAF4AHydnPGe6+iKlHSb2UkwXJqaTGN8MbgeeiNLcMbnIAAAAASUVORK5CYII=",
    12, 12);

local e_infoNotificationIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA70lEQVR4nIWTTQ4BQRCFWRJhxbgJDmHlZ2PnDHa2roBIxFZwDAuGuYEbWEmwE59UtJhpVeMlnUzyXr2qrnmdyRgAAqDhTmDpEgCyQBeISOIJHIGOaKziPLDhP1ZATuu8UcR3YAycFJPvJLzH1jB1fFPh2nGDyDA4AwNgp3CHT3HVLcmHmE5SzKUmEIO6Ql6AGVAAikYDQc0yEDyAkssDaQZVo8PeXbGXcoXKZw8SEh8jxy0MgzD+FzqKYOi4PrBV+JYfpJUnuAFzYA1cPW75E2mJp2KiQYqTUfYmaUtIvMXKdyhjm49JMSvHnnPZEr4ASsXerwt2cEYAAAAASUVORK5CYII=",
    16, 16);

local e_successNotificationIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsTAAALEwEAmpwYAAABAklEQVR4nJWSMYoCQRBFzQw0GdDME4ip4iV0T6Cx61zAyNDACywiKGjmKTbTWM02V1TEVNjVtxTUSNNW4/hh6Jqq/38XXZXJGAA+gG89H7HFfQDIAXWgCVx4xkVrwslZBn3So28ZLN4wWLjCIjAFbi9EVycW7gQoiEEnxY1bIA+MvHxHDEovbv8Fqtrt3OuiJMmaZ3AChsCf/g9U3PCMRVOTwsordFXQAtZAFoiAndHdUogxcHeSR6CS7IaeM0MsmjiZhP84B6AcaD3ByB3l2CDsgc9A64Kxa9AGfgJEC8JtW9vYSyHuPQkdA3ntsy7OxhFJLDmpRUEDz0zG96VfNkT8B4KB7F75rpRnAAAAAElFTkSuQmCC",
    16, 16);

local e_errorNotificationIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsTAAALEwEAmpwYAAAApklEQVR4nJ3TMQrCMBSH8S4ewENoQSdXT+IBvIro4FUcPUt1t+DqLvykVCnUvjT6QSAk+X/wXpKiCECJKy7NPDo3COaoddyx+DecLxGHxyXamvvhI3a9tfqrJ4bDDVNM8Awl4nDDGqtgr5Vorylii01ivxoTnHEaE5SJEh7vMURWHxZYJsMfAskeh9Fw0UlmuCVqznqNkeSn/9CX5Id7PWmuuEp95xdRJ4lABlEd5gAAAABJRU5ErkJggg==",
    16, 16);

local e_notificationCircleIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAYAAADhAJiYAAAEKklEQVRYw+2Xz28bRRTH3+6bH7veHzY5E6h6j1A4BaEoxSauSgWnoJ6oxF8WiZvT9NImxcjeXKBwohxyya2V0nsS49kfMztrDs0uY8cJ65AKDnnSaCTLO/OZ73sz8x2A27iN/0H0ej2v19vxbmIsa9EP+v0+C8NwlVL2iFLywPO8u4QQBgAgpZRjIV4rKV9IKXtJkv5x/35Xvheg6OAAKSHrrutu+76/7LouUkoBEcGyLJhMJlAUBSilIE1TiONYCyGOs0x+XxTFz5ubX+obA4qiyGeM7YRh2A2CAF3XhRLGtu3qf0VRQJ7nkOc5pGkKQggYjUZaCBEh4la73f7zXwMNh8OPGo3GXqvVWgnDEBzHAcZYpYxlvRtiMplUKuV5DkopyLIMhBBwenoKo9HoEBEfdjqd42sDDaPIb7jur0tLSyvNZhNMZUyYMkqgWajxeAwnJydwdnZ2SAj9rNNpi8vmtK+qGc7YTqvVqmAYY0AIqVI1ryEiICJQSoExBpxzaDQa0Gw2wff9FaXk7mA4wIWBKCHrYRh2wzCcgrFtGyzLqnqzzYOjlALnHFzXhSAIwHGc7qSA9YWA+v0+cxuN7SAI0HGcSpXLQK4CQ0QghFRQnufZiPb2cHjAagOFYbjqe97yPGUA4ELtTBXlFVCMMXBdFzjnywCT1dpAlLJHs+eMOVndMNNrptBxHKSUbC0ARB7M7qZFQEwVZxUjhAClFGzEb2oD+b5/t9xJi4LUVYwz9nEtoCdPnnqIyG4SxDw4S9UQkT9/vt/4R6CSo/y47K8DMAtjtqIoYN6a58pwdHSUhmHIZ3dZ3RSaJ3Z54UopIU1TSJIE4jiGJEnk2toar1VDQojXSinI87wa1Fxd3dSYYFpr0FqbV8qb2kWtlPoxTdPq5jZXO0/+y1JSgpTjKKUqtfJcP6sNJKXsxXGs0zSFWaVMqHlpKvtSEVOV0islSaK1zp/Om5vM+zFN01eWZR1TSu+YpzQiVjC2bV+AmgUyQQwYSNPsred5v9dWqNvtKqXUd+fmCrIsO5c5n1q1qYLWem6KpJSQZVlVzOPxWFuW9fjevQ1VWyEAAK2L34SIf7Jt+6ty9UVRTNkPc8fNGjTTDyVJUrpH0FoPHYe+vJZBi6LI11r/EobhJ6Un4pxPHQOz58xsqkwYIcRhs9la63Ta8bUtbBRFy0qp/SAIVoIgqLyRadJMdbTWUzUTxzGMRiNIkuSw1frgYbv9xfUt7N9QB55Satdx+KbneZXJJ4RMeWrTupYFPB6PtdZ64HneVqfTETf2DBoMBjiZwOeI9g+c8w/fWQha1ZL5DJJSQpIkOsuyt5ZlPUbEl91u9+aeQdOvkANqWZNPCSHf2ohfc8buICI7T5fMsuxNnutnWue7nPNXGxvzd9N7jb29vcb+/sWb+zZu47+IvwAAQyB7lIOdmwAAAABJRU5ErkJggg==",
    36, 36);

local e_notificationLeftBackgroundIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAACQAAAAoCAYAAACWwljjAAAEmElEQVRYw81YPY4WRxSsml2JaBMgsDa0hbwZ4gLEHIPYV/AFfAyfwiLxCRz5EkQYRIBEVgTT3a/q9SBki8Cj1X7fNzP9+v3Wq9eEXT89e3gA+RrCKxLP6wnnX90h1zMSkADSVxAiQGE8EEhCGN/BU976dwqgKfMLgF9B3JeQ+nRlYuH8Fh90O77yW8uYkn6qO5X5DeQdpVo5X57WT7kyd03ZS/i8l14lCLdzV3K89eOznx8I/gngPq0fWmh5fGnF04XDxn2zabXcs+QZvqWBh2goL+AA8BrAPdx1Ms+YwHVpvlM34rHaWn/TPbTkCJAgAAfBV+UQgRBE+VY9g1CG1jPJHoyN5aGQ/1ZEVhbCQ9Bzc8jKEbUAqx5GEp6bM507LC4NZEbUek1xlk/H1H65T1G7FhKFz7W+q7RlZhaa9VlhWuJMIg43mK45AEqgtiwo4VTXe23I4WkHiHJahfoMZSX47bn+vCGrdu3gM5TgcgpH+Wl6mU3xVuK8yPK1bCh7rDeHYhq7seJyoqoS/Lpwef5chKs8pPAyGWCGY2WevE1EkxgunbvK0kyp5BbYRIe1+egpKmxeRhxSX1buK7MY+u4GXEETm5Ia97I46OCgmUMO3rJ92YrNq4WlMGfpu44rz1ygol2o7S0CB1ukRIUX2ANgVR7g6Tmswh2pAqoeUnnenT9ufT8hqQBAzJBW41SU8oUbqwe2EJdXRqFYhc/rkHVuTl/DN1dwH/fAwkO2tBK2vKJh7oIWFbYuhcheEYwmKxCaIZg+HiA2cei0vnnOU2cUO1H9T1QwnNU65DYMjywM4fASM0jyLs2OQc4wBkOkNWDLF12wgYMeZJ3UQcqi6IsnWVNArdMKjSIZBsqT6AIuVBV+4H92tZANq9h6WSP4M2QN9a2cWN5ei9m8qSVjFQW3kDExZdCRSuoMmbPKIPMzSitkytZxMcVY2Sdfj2Id/IaN+1bZeyMlQm1m5RYLGh1stCO1XD1o3FJQErThMam1ylX2ySaDbSgbrqwtyWaGTltukV40xNjJeynp4Ko9P1RTiY9QaqHVwrTK48PRVRozl3Iw6NndlQzs8lFqdYUkGt6g2TxyoNEPMZtf8vXKglKaZ6fXTl8iiZXChZ5AA4fIjatmBXAieONBV+UbMtQ40iRlDJ6jTj/2bt35xehRKs5Jocd0I2jETgJW66CMwGU7OGIc4JgSSAPGs5y9KzvcuwIx5mxcalJ3JsC0/nN4ydByZvRVUI1eBcipWPeG2IM7X45BaYiMIB5puXKUG6PRLsIHRTS+XSUvKsCS3MFX02tztse0jkU3ttEBPA8Q+nA4UY3Jn5xiMAdsH0NtULTZnuDfbHOdVlXJwdlwIUuNFgs6QWcbMkPhpLSrdQh6UzRm8D4xQa9FvoTb0MecLKgcgcR9elG8twZF/A7gbYAUkw3m8QeuQCcfs61NeErWz/IoAdx8eP/Pu8dPnn4G8BLkozrSY5EV8eTPE+H9uM7D8h2O9G4A4MP7d389fvL0I4AXIO6Idj7Hbx168jscep73bqbYodQfID8BvCPxw785FsbFsTD+w7HwF2gKdrf4Fb/UAAAAAElFTkSuQmCC",
    36, 40);

local e_notificationMiddleBackgroundIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAAoCAYAAAA/tpB3AAAAFElEQVQI12OQkpH7z8TAwMAwtAkAI38Bogqi6zwAAAAASUVORK5CYII=",
    1, 40);

local e_notificationRightBackgroundIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAn0lEQVRYw+3ZoQ3DMBRF0esoMBNEUVhxZygv6gQhHSesLLA8qFsUWQorsywv0AFSZJYBntR34UdHtj6xQz+MOxptwAPoSk5zHQYhYG0FviWnCaBBrxtw6YdxUT3BWgSeDbqdgY8yEOCqfMWoLomBBhpooIEGGmiggQYaaKCBBhpo4J8AF3XgSxkYgZMqMAHvktPcCuLqI/odQAl4+A3xA+tvI82G1JYOAAAAAElFTkSuQmCC",
    40, 40);

local e_endpointLogoIcon = e_UIIcon:init(
    "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAFM0lEQVRYw+2Wa4hdVxXHf/txzrnnvmZupuOY1JS8TGNMmsTWQqNYLAZBqJEWUooWqiKC1gQf9JMjUuujolJthYJQfDQILaKWUI0WycNXkEmTUBIzSUwynTuZmc7j3rkz5967zzl7+WFSv5hGpw9EyP/TYsNe67cee7Pgmq7pfyz1ei7392+LwIcaE4vSzuf5/NT0C9mbCrD95q+We0vbPyr4u73Pt0ZR3K+UwShxxhaOh1r2u+7hx595/sGJNxzg9lt/dk+aJo913Ew/SlDGYHSAxqJQKG2xukytsmo2DrMH9h/5ws9nZ1+QNwTg5pu+9WiaNvd4ybA6QpkYo0OMjtEqAKVRCsQ7RDyV0jqqceGBX/z+/T983QDbNg4OdruTD4kOsLaEUTFRuIJaeQVhGGC0xRPSXJjBuUm8TxFSqsUN3VpFf/Dp3+44+JoBtm768tZue+wogsKWsabCstJaPGPMLhxDEMTniChWvfXDeFlGc/4lPBlehIGezaeGTn3ppvHJY1ccTvOfAGq973g8z5ONSoUYU6CnuJLE/Q3RycVC1PNEHNX2Bqb4fCmuzcTB6s3Oa1zaQPB4n+Iy6d+05mNnTp578sSV/NurBb9x/b3lLF/YqQClILJ9ZHKWUqnvK1NzJ7958uS+rLdnc7xrxzP3TbeaH5hsnCdzE5fdekQyAiPMtv7xXuCpJQMUguu3znfPW60jEIWxKVFUGDz010ce7uvbZu678+gdiUsfO10/tTFNZ0E8oNDKEpkKnbzFxUtP4XGvGuOqAHna2vCKLUAQ2LHz9aEf3H3Hc29PqT5cnxrZlXQn0FqDLHYzjq+nFBrqk/sYbwyJNfHelQP3NnrLvcGLf382XRKANRUD05dnVdCq8rsNN+wZfLnV/GzbDcdaKxQhYAiCCn2VARqtIxw782uMjYZWDHzogKa6M3Nz6wqF5V8HlgYQFSJaif4XQKeT3p8kxxENRheAAK0jrquswfs6L577Bl5ktBjXHhzov/Pj3W73i6mbw2rNdHNYL7kFgckzo4sIOQK4rIHRFggARTleRTES6i/vpdW91NE2esKnnYdWr7xrXbOV7BC/mHDuO3TaebYkgFu3fH9gIZn4iDUV0rwJAmk6SxC/DaOr9FVvYK49xNj0CayJ9mnM4Pjk8HFjQ+tSviO5LFZOQZa322Pjhxb+a4B1a+6xC8mFc2k2U7KmjEKADLB00llq1QojUz8ltKXTxcKy3ecu/vkgkN62bfcy8dc92mxNvQ8UgkdrQyu5+JclvYLe0vYtrfnjJblcPmur5FkTfIb3bZqtUUrhu9CmeKBUrq5+95Ydq5xL3pO01U6XNnoUBk8OkpJlMyTtsV8uCcDnnQ255CglBKZGsVij3UnJUgeS4sXRdQna5J9OGx2MDtEqQusQpQyCA8lQOmdi5mDdUnjy1QCuOJni/VqFpRKvJ45DcjlDEHrCqAyymBm4RVu98qNrwAM5Wgkic4yO7xOjw0++dOlgsiSAMOxdXy2vQNQwxjbGinHf/eVi74+UaRAWQgIbAw4Rh/cOTxehi1agVJvm/FFGLv3Ka60/NVo/vP+qf80VD6MTyyX1nWL0lm8ryR85dOS7CfCT7bfsPt12c1/rdOpxYAdA5Wjlyf0Cuc+YnRultXAWbcLhMKp+YmTkwJ9e00Z0+22f/4z36jeHj3zv/L+tZLfsWe6y5HNdN7cry7pr07yDz1O8iBORw9qYH7tu5+n62B/dm76Ubrrxrkhb+06Xduc7rnX2woU/+Gt7/jX93+mfbdZod22/HRYAAAAASUVORK5CYII=",
    32, 32);

--[[ Framework notifications ]]
--[[
    @ type - info / ...,
    @ content - string, content to be displayed in the notification
    @ duration - int, optional, defaulted to 5 seconds
]]
function e_UINotification:init(type, content, duration)
    local data = {
        icon = (type == NOTIFICATION_INFO) and e_infoNotificationIcon or
            (type == NOTIFICATION_SUCCESS) and e_successNotificationIcon or
            (type == NOTIFICATION_ERROR) and e_errorNotificationIcon or nil,
        content = content,
        duration = duration or 5,
        startTime = globals.realtime(),
        opacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
    };

    local public = {};

    public.getIcon = function()
        return data.icon;
    end

    public.getContent = function()
        return data.content;
    end

    public.getDuration = function()
        return data.duration;
    end

    public.getStartTime = function()
        return data.startTime;
    end

    public.getOpacity = function()
        return data.opacity:get();
    end

    public.setOpacity = function(val)
        data.opacity:update(globals.frametime(), val, nil);
    end

    public.isExpired = function()
        return globals.realtime() - public.getStartTime() > public.getDuration(),
            (globals.realtime() - public.getStartTime() > public.getDuration()) and public.getOpacity() < 0.01;
    end

    public.getHeight = function()
        return 45;
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

function e_UINotification:handle(posX, posY)
    local notificationExpired, notificationAnimatedOut = self.isExpired();

    -- [[ If notification has expired and it has been animated out, we don't do anything with it and the calling side should remove its reference ]]
    if (notificationAnimatedOut) then return; end

    -- [[ Handling animations ]]
    self.setOpacity(notificationExpired and 0 or 1);
end

function e_UINotification:render(posX, posY)
    local notificationExpired, notificationAnimatedOut = self.isExpired();

    -- [[ If notification has expired and it has been animated out, we don't do anything with it and the calling side should remove its reference ]]
    if (notificationAnimatedOut) then return; end

    -- [[ Slide in and out position change ]]
    posY = posY * self.getOpacity();

    local padding = 5;

    local icon = self.getIcon();
    local contentWidth, contentHeight = e_measureText("s", self.getContent());

    local spaceYCircle = e_notificationMiddleBackgroundIcon.getHeight() - e_notificationCircleIcon.getHeight();
    local spaceXIcon, spaceYIcon = e_notificationCircleIcon.getWidth() - icon.getWidth(),
        e_notificationCircleIcon.getHeight() - icon.getHeight();
    local spaceYContent = e_notificationMiddleBackgroundIcon.getHeight() - contentHeight;

    -- [[ Rendering left menu themed background block ]]
    e_renderRect(posX, posY,
        e_notificationLeftBackgroundIcon.getWidth(), e_notificationLeftBackgroundIcon.getHeight(), e_UIPrimaryLGrayColor,
        self.getOpacity() * 255);

    -- [[ Rendering main circular base ]]
    e_renderTexture(e_notificationCircleIcon.getTextureId(), posX, posY + spaceYCircle / 2,
        e_notificationCircleIcon.getWidth(),
        e_notificationCircleIcon.getHeight(), e_UIPrimaryBlueColor, self.getOpacity() * 255);

    -- [[ Rendering icon ]]
    e_renderTexture(icon.getTextureId(), posX + spaceXIcon / 2, posY + spaceYCircle / 2 + spaceYIcon / 2, icon.getWidth(),
        icon.getHeight(),
        e_UIBackgroundColor, self.getOpacity() * 255);

    -- [[ Rendering middle background block ]]
    e_renderRect(posX + e_notificationLeftBackgroundIcon.getWidth(),
        posY, contentWidth + 4 * padding,
        e_notificationMiddleBackgroundIcon.getHeight(), e_UIPrimaryGrayColor, self.getOpacity() * 255);

    -- [[ Rendering right menu themed background block ]]

    -- [[ Rendering seperator ]]
    e_renderRect(posX + e_notificationLeftBackgroundIcon.getWidth(), posY, 1,
        e_notificationLeftBackgroundIcon.getHeight(), e_UIPrimaryBlueColor, self.getOpacity() * 255);

    -- [[ Rendering text content ]]
    e_renderText(posX + e_UIFrameworkIconButton.getWidth() + 2 * padding, posY + spaceYContent / 2,
        e_UISecondaryWhiteColor, self.getOpacity() * 140, "s", false, self.getContent());
end

-- [[ Framework watermark ]]
function e_UIWatermark:init(version, username)
    local data = {
        version = version or "[concordia]",
        username = username or "scriptleaks"
    }

    local public = {};

    public.getIcon = function()
        return e_keybindIcon;
    end

    public.getVersion = function()
        return data.version;
    end

    public.getUsername = function()
        return data.username;
    end

    public.getDisplayText = function()
        return data.version .. " " .. data.username;
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

function e_UIWatermark:render()
    local screenWidth, screenHeight = client.screen_size();
    local icon = self.getIcon();
    local textWidth, textHeight = e_measureText("s", self.getDisplayText());

    local padding = 5;
    local textPosX, textPosY = screenWidth - textWidth - 2 * padding, padding + (icon.getHeight() - textHeight) / 2 - 1;
    local iconPosX, iconPosY = textPosX - icon.getWidth(), padding;

    -- [[ Rendering display text ]]
    e_renderText(textPosX, textPosY, e_UIPrimaryWhiteColor, 255, nil, false, self.getDisplayText());

    -- [[ Rendering tab icon ]]
    e_renderTexture(icon.getTextureId(), iconPosX, iconPosY,
        icon.getWidth(), icon.getHeight(), e_UIPrimaryBlueColor, 255);
end

--[[
    Framework main window.
    @ width - number, menu width
    @ height - number, menu height,
    @ tabs - array of e_UITab, menu tabs
]]
function e_UI:init(width, height, tabs, headerChildren)
    local screenWidth, screenHeight = client.screen_size();

    -- [[ TODO: This will be a large data structure, might have to implement more efficient way ]]
    -- [[ Populating tab lookup table initially once ]]
    local tabLookup = {};
    local elementLookup = {}; -- [[ Holds element name to element reference, used for loading config ]]

    -- [[ Maps each menu element to it's tab instance ]]
    local function traverse(children, tab)
        for i = 1, #children do
            local child = children[i];

            if (pcall(function()
                    child.getName()
                end)) then
                -- [[ Adding top level child mapping ]]
                tabLookup[child.getName()] = tab;
                elementLookup[child.getName()] = child;
            end

            -- [[ If children exist for this particular menu element, we recursively traverse them ]]
            if (pcall(function()
                    child.getChildren()
                end))
            then
                traverse((child.getType() == TYPE_DROPDOWN or child.getType() == TYPE_MULTIDROPDOWN) and
                    getValues(child.getChildren()) or child.getChildren(), tab);
            end
        end
    end

    -- [[ Going over each tab ]]
    for tabIndex = 1, #tabs do
        local currentTab = tabs[tabIndex];
        local currentTabChildren = currentTab.getChildren();

        traverse(currentTabChildren, currentTab);
    end

    local data = {
        watermark = nil,
        width = width,
        height = height,
        navbarHeight = 65,
        posX = (screenWidth / 2) - (width / 2),
        posY = (screenHeight / 2) - (height / 2),
        isOpen = true,
        isDragging = false,
        canDrag = true, -- [[ True if no child menu elements are hovered ]]
        opacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
        navbarOpacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
        appearOpacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
        mousePosition = { x = 0, y = 0 }, --[[ Holds the current mouse position, must be updated in draw ui ]]
        mouseDifference = { x = 0, y = 0 }, --[[ Used for dragging ]]
        children = tabs,
        headerChildren = headerChildren,                      -- [[ Shared children elements across all tabs, in header ]]
        boundKeys = {},                                       -- [[ Stores the list of bound keys in the Framework, typeof e_UIKey ]]
        previousKeys = {},                                    -- [[ Stores the previously pressed keys ]]
        currentKeys = {},                                     -- [[ Stores the currently pressed keys ]]
        updateInputKeys = false,                              -- [[ True, when an input field is active ]]
        callbacks = { [MENU_OPEN] = {}, [MENU_CLOSED] = {} }, -- [[ Stores all of the callbacks registered ]]
        notifications = {},                                   -- [[ Stores all of the non-expired notifications ]]
        tabLookup =
            tabLookup                                         -- [[ Hashmap that holds key value pairs of menu element name and it's originating tab ]]
    };

    --[[
        Initially setting the first children to be active
    ]]
    data.children[1].setIsActive(true);

    local public = {};

    public.attachWatermark = function(version, username)
        data.watermark = e_UIWatermark:init(version, username);
    end

    public.detachWatermark = function()
        data.watermark = nil;
    end

    public.getWatermark = function()
        return data.watermark;
    end

    public.getWidth = function()
        return data.width;
    end

    public.getHeight = function()
        return data.height;
    end

    public.getnavbarHeight = function()
        return data.navbarHeight;
    end

    public.setPosX = function(val)
        data.posX = val;
    end

    public.setPosY = function(val)
        data.posY = val;
    end

    public.getPosX = function()
        return data.posX;
    end

    public.getPosY = function()
        return data.posY;
    end

    public.getIsOpen = function()
        return data.isOpen;
    end

    public.setIsOpen = function(state)
        data.isOpen = state;
    end

    public.getTab = function(elementName)
        return data.tabLookup[elementName];
    end

    public.getIsDragging = function()
        return data.isDragging;
    end

    public.setIsDragging = function(state)
        data.isDragging = state;
    end

    public.getCanDrag = function()
        return data.canDrag;
    end

    public.getOpacity = function()
        return data.opacity:get();
    end

    public.setOpacity = function(val)
        data.opacity:update(globals.frametime(), val, nil);
    end

    public.getNavbarOpacity = function()
        return data.navbarOpacity:get();
    end

    public.setNavbarOpacity = function(val)
        data.navbarOpacity:update(globals.frametime(), val, nil);
    end

    public.getAppearOpacity = function()
        return data.appearOpacity:get();
    end

    public.setAppearOpacity = function(val)
        data.appearOpacity:update(globals.frametime(), val, nil);
    end

    public.getMousePosition = function()
        return data.mousePosition.x, data.mousePosition.y;
    end

    public.getMouseDifference = function()
        return data.mouseDifference.x, data.mouseDifference.y;
    end

    public.setMouseDifference = function(diffX, diffY)
        data.mouseDifference.x = diffX;
        data.mouseDifference.y = diffY;
    end

    public.getChildren = function()
        return data.children;
    end

    public.getHeaderChildren = function()
        return data.headerChildren;
    end

    public.isKeyHeld = function(key)
        return data.currentKeys[key] and data.previousKeys[key];
    end

    public.isKeyPressed = function(key)
        return data.currentKeys[key] and not data.previousKeys[key];
    end

    public.getBoundKey = function(keyName)
        assert(data.boundKeys[keyName] ~= nil, "Bound key not found!");

        return data.boundKeys[keyName];
    end

    public.createConfig = function()
        -- [[ Holds the raw configuration tree table struct ]]
        local rawConfig = {};

        local function prepareConfigValue(element)
            local switch = {
                [TYPE_CHECKBOX] = function()
                    return element.getIsActive();
                end,
                [TYPE_COLORPICKER] = function()
                    return { element.getColor().getHSV() };
                end,
                [TYPE_DROPDOWN] = function()
                    return element.getSelectedRaw();
                end,
                [TYPE_MULTIDROPDOWN] = function()
                    return element.getSelectedRaw();
                end,
                [TYPE_SLIDER] = function()
                    return element.getDragValue();
                end
            }

            -- [[ Some menu elements, like buttons or text input should not be saved ]]
            if (switch[element.getType()]) then
                return switch[element.getType()]();
            end
        end

        local function traverseCreateConfig(children)
            -- [[ Going over all children nodes ]]
            for childIndex = 1, #children do
                local child = children[childIndex];
                local childConfigParams = prepareConfigValue(child);

                -- [[ Saving current childrens data to the config, if applies ]]
                if (childConfigParams ~= nil) then
                    rawConfig[child.getName()] = childConfigParams;
                end

                -- [[ If children exist for this particular menu element, we recursively traverse them ]]
                if (pcall(function()
                        child.getChildren()
                    end)) then
                    traverseCreateConfig((child.getType() == TYPE_DROPDOWN or child.getType() == TYPE_MULTIDROPDOWN) and
                        getValues(child.getChildren()) or child.getChildren());
                end
            end
        end


        -- [[ Going over each tab ]]
        for tabIndex = 1, #tabs do
            local currentTab = tabs[tabIndex];

            -- [[ TODO: Call on children ]]
            traverseCreateConfig(currentTab.getChildren());
        end

        -- [[ Encoding the config ]]
        return base64.encode(json.stringify(rawConfig), "base64");
    end

    --[[
        @ config - base64 encoded config
    ]]
    public.loadConfig = function(config)
        -- [[ Attempting to decode the config, user can pass anything to this function so we must handle errors ]]
        local success, decodedConfig = pcall(function(...)
            return json.parse(base64.decode(config, "base64"));
        end);

        -- [[ Couldn't decode the config ]]
        if (not success) then return; end

        local function applyConfigValue(element, configValue)
            local switch = {
                [TYPE_CHECKBOX] = function()
                    element.setIsActive(configValue);
                end,
                [TYPE_COLORPICKER] = function()
                    local h, s, v = table.unpack(configValue);
                    element.getColor().setHSV(h, s, v);
                end,
                [TYPE_DROPDOWN] = function()
                    -- [[ Selectors store selected option indexes ]]
                    for i = 1, #configValue do
                        element.setSelected(configValue[i]);
                    end
                end,
                [TYPE_MULTIDROPDOWN] = function()
                    -- [[ Selectors store selected option indexes ]]
                    for i = 1, #configValue do
                        element.setSelected(configValue[i]);
                    end
                end,
                [TYPE_SLIDER] = function()
                    element.setDragValue(configValue);
                end
            }

            -- [[ Some menu elements, like buttons or text input should not be saved ]]
            if (switch[element.getType()]) then
                pcall(switch[element.getType()]());
            end
        end

        -- [[ Going over each config element ]]
        for elementName, elementConfigValue in pairs(decodedConfig) do
            pcall(function()
                applyConfigValue(elementLookup[elementName], elementConfigValue)
            end);
        end
    end

    public.createInfoNotification = function(content)
        table.insert(data.notifications, e_UINotification:init(NOTIFICATION_INFO, content));
    end

    public.createSuccessNotification = function(content)
        table.insert(data.notifications, e_UINotification:init(NOTIFICATION_SUCCESS, content));
    end

    public.createErrorNotification = function(content)
        table.insert(data.notifications, e_UINotification:init(NOTIFICATION_ERROR, content));
    end

    --[[
        @ key - typeof e_UIKey
    ]]
    public.setBoundKey = function(keyName, key)
        assert(type(keyName) == "string", "Key name must be a string!");
        assert(e_inputKeys.primaryKeys[key.getKeyCode()] ~= nil or e_inputKeys.genericKeys[key.getKeyCode()] ~= nil,
            "Unsupported key code provided!");
        assert(
            key.getKeyState() == UI_KEY_STATE["HOLD"] or key.getKeyState() == UI_KEY_STATE["TOGGLE"] or
            key.getKeyState() == UI_KEY_STATE["ALWAYS"],
            "Unsupported key mode provided!");

        data.boundKeys[keyName] = key;
    end

    --[[
        @ eventName - string, child component emitted event name
        @ eventData - data for that specific event (optional)
    ]]
    public.emitEvent = function(eventName, eventData)
        local switch = {
            [TAB_CHANGED] = function()
                -- [[ Child component indicates that a new tab has been selected, we disable other ones ]]
                for i = 1, #public.getChildren() do
                    local child = public.getChildren()[i];

                    -- [[ Disabling all other tabs ]]
                    if (child.getName() ~= eventData) then
                        child.setIsActive(false);
                    end

                    -- [[ You can't unselect already active tab, 1 tab must be active at all times ]]
                    if (child.getName() == eventData and not child.getIsActive()) then
                        child.setIsActive(true);
                    end
                end
            end,
            [ELEMENT_HOVERED] = function()
                data.canDrag = false;
            end,
            [INPUT_FIELD_FOCUS] = function()
                data.updateInputKeys = true;
            end,
            [INPUT_FIELD_BLUR] = function()
                data.updateInputKeys = false;
            end,
            --[[
                @ eventData - must be either the name of a specific element residing in a tab or tab instance itself
            ]]
            [RECALC_TAB_MAX_HEIGHT] = function()
                --[[ TODO: Re-think how to determine whether elements are hidden, because currently they become if opacityModifier is 0,
                    however, if an element is not being rendered or handled anymore, its state doesn't update..
                ]]
                client.delay_call(0.5, function()
                    -- [[ Getting reference to the tab ]]
                    local tab = type(eventData) == "string" and public.getTab(eventData) or eventData;
                    local tabMaxHeight = 0;

                    -- [[ TODO: Re-use the above traverse function ]]
                    local function calculateChildrenHeight(children)
                        -- [[ Going over each child element ]]
                        for i = 1, #children do
                            local child = children[i];

                            -- [[ If current child is visible, we take its height and add its children height, if applies ]]
                            if (not child.getIsHidden()) then
                                tabMaxHeight = tabMaxHeight + child.getHeight();

                                if (pcall(function()
                                        child.getChildren()
                                    end)) then
                                    local children = (child.getType() == TYPE_DROPDOWN or child.getType() == TYPE_MULTIDROPDOWN) and
                                        getValues(child.getChildren()) or child.getChildren();
                                    if (#children > 0) then
                                        calculateChildrenHeight(children);
                                    end
                                end
                            end
                        end
                    end

                    calculateChildrenHeight(tab.getChildren());

                    --client.log(tabMaxHeight);

                    -- [[ Updating tab max child height at this moment ]]
                    tab.setChildrenHeight(tabMaxHeight);
                end)
            end
        }

        switch[eventName]();
    end

    --[[
        @ callbackName - string, name of the callback
        @ cb - function to be executed
    ]]
    public.registerCallback = function(callbackName, cb)
        assert(data.callbacks[callbackName] ~= nil, callbackName .. " is not a supported callback!");

        table.insert(data.callbacks[callbackName], cb);
    end

    public.fireCallbacks = function(callbackName)
        assert(data.callbacks[callbackName] ~= nil, callbackName .. " is not a supported callback!");

        for i = 1, #data.callbacks[callbackName] do
            data.callbacks[callbackName][i]();
        end
    end

    public.getLastPressedKey = function()
        for key, value in pairs(e_inputKeys.mergedKeys) do
            if (public.isKeyPressed(key)) then
                return key, value;
            end
        end
    end

    --[[
        @ keyCode, int, windows key code
    ]]
    local updateKeyState = function(keyCode)
        -- [[ Updating previous state of our key, or setting it to false if it has not been defined yet  ]]
        data.previousKeys[keyCode] = data.currentKeys[keyCode] or false;
        -- [[ Updating current state of our key ]]
        data.currentKeys[keyCode] = client.key_state(keyCode);

        --client.log(tostring(keyCode)..", held: "..tostring(public.isKeyHeld(keyCode))..", pressed: "..tostring(public.isKeyPressed(keyCode)))
    end

    --[[ Registering neccessary events that update our key states and mouse position ]]
    client.set_event_callback("paint_ui", function()
        -- [[ Updating mouse position ]]
        local mousePosX, mousePosY = surface.get_mouse_pos();

        data.mousePosition.x = mousePosX;
        data.mousePosition.y = mousePosY;

        -- [[ Updating drag state ]]
        data.canDrag = true;

        -- [[ Handling notifications ]]
        for notificationIdx = #data.notifications, 1, -1 do
            local notification = data.notifications[notificationIdx];
            local notificationExpired, notificationAnimatedOut = notification.isExpired();

            -- [[ If the notification has expired, we remove it ]]
            if (notificationAnimatedOut) then
                table.remove(data.notifications, notificationIdx);
            else
                notification:render(10, (#data.notifications - notificationIdx) * notification.getHeight() + 10);
                notification:handle(10, (#data.notifications - notificationIdx) * notification.getHeight() + 10);
            end
        end

        -- [[ Input field is active, we must update all possible accepted keys ]]
        if (data.updateInputKeys) then
            for mKey, _ in pairs(e_inputKeys.mergedKeys) do
                updateKeyState(mKey);
            end

            -- [[ We return, because no point of updating a key state twice ]]
            return;
        end

        -- [[ Updating key states ]]
        if (public.getIsOpen()) then
            -- [[ Menu is open, we must update generic key states ]]
            for gKey, _ in pairs(e_inputKeys.genericKeys) do
                updateKeyState(gKey);
            end
        end

        -- [[ We always must update our bound keys ]]
        for _, boundKey in pairs(data.boundKeys) do
            -- [[ If the key is currently unbound, we skip it ]]
            if (boundKey.getKeyCode() == UI_KEY_NOT_BOUND) then
                goto continue;
            end

            do
                --[[ e_UIKey ]]
                local boundKeyIsActiveOld = boundKey.getIsActive();

                -- [[ The key has state always on ]]
                if (boundKey.getKeyState() == UI_KEY_STATE["ALWAYS"]) then
                    boundKey.setIsActive(true);
                end

                if (boundKey.getKeyState() == UI_KEY_STATE["HOLD"]) then
                    boundKey.setIsActive(public.isKeyHeld(boundKey.getKeyCode()));
                end

                if (boundKey.getKeyState() == UI_KEY_STATE["TOGGLE"]) then
                    if (public.isKeyPressed(boundKey.getKeyCode())) then
                        boundKey.setIsActive(not boundKey.getIsActive());
                    end
                end

                -- [[ Calling the optional callback attached to the key, if its state changes ]]
                if (boundKeyIsActiveOld ~= boundKey.getIsActive()) then
                    boundKey.fireCallback(boundKey.getIsActive());
                end

                -- [[ Updating key state ]]
                updateKeyState(boundKey.getKeyCode());
            end

            ::continue::
            ;
        end

        notify:handle()
    end);

    -- [[ Estimating initially how much space height wise would children elements take, required for tab sidebar ]]
    for tabIndex = 1, #tabs do
        public.emitEvent(RECALC_TAB_MAX_HEIGHT, tabs[tabIndex]);
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

notify.new(4, "Welcome back, <<user>>!")

function e_UI:drag()
    -- [[ Menu must be open ]]
    if (not self.getIsOpen()) then return end
    ;

    --[[
        Mouse 1 is held, cursor is in menu boundaries, or we are already dragging our menu
    ]]
    local isMouse1Held = self.isKeyHeld(1);
    local mousePosX, mousePosY = self.getMousePosition();
    local mouseDiffX, mouseDiffY = self.getMouseDifference();
    local inBounds = e_inBounds(self.getPosX(), self.getPosY(), mousePosX, mousePosY, self.getWidth(), self.getHeight());

    if (isMouse1Held and self.getCanDrag() and (inBounds or self.getIsDragging())) then
        self.setPosX(mousePosX - mouseDiffX);
        self.setPosY(mousePosY - mouseDiffY);
        self.setIsDragging(true);
    else
        self.setMouseDifference(mousePosX - self.getPosX(), mousePosY - self.getPosY());
        self.setIsDragging(false);
    end
end

function e_UI:handle()
    -- [[ Handling animations ]]
    if (not self.getIsOpen()) then
        -- [[ Fade icons, menu elements out first ]]
        self.setAppearOpacity(0);
        -- [[ Start fading out navbar when elements are about to have faded out ]]
        self.setNavbarOpacity((self.getAppearOpacity() <= UI_OPACITY_BORDERLINE) and 0 or 1);
        -- [[ Start fading out base menu when navbar is about to be closed and faded out ]]
        self.setOpacity((self.getNavbarOpacity() <= UI_OPACITY_BORDERLINE) and 0 or 1);
    else
        -- [[ Fade menu in first ]]
        self.setOpacity(1);
        -- [[ Start fading in navbar when the menu is almost faded in completely ]]
        self.setNavbarOpacity((self.getOpacity() >= 0.95) and 1 or 0);
        -- [[ Fade in icons, menu elements when navbar is about to be faded in ]]
        self.setAppearOpacity((self.getNavbarOpacity() >= 0.95) and 1 or 0);
    end

    mouseEnable:set_int(self.getIsOpen() and 0 or 1);
end

function e_UI:render()
    -- [[ Rendering watermark ]]
    if (self.getWatermark()) then
        self.getWatermark():render();
    end

    -- [[ Only render the framework and all the children if menu is visible ]]
    if (self.getOpacity() < 0.005) then return end
    ;

    -- [[ Main background block ]]

--local e_UILightest
--local e_UIMid = e_
--local e_UIDarkest 
--local e_UIBlack = 

    e_renderRect(self.getPosX() - 5, self.getPosY() - 5, self.getWidth() + 10, self.getHeight() + 10, e_UIBlack, self.getOpacity() * 255);
    e_renderRect(self.getPosX() - 5 + 1, self.getPosY() - 5 + 1, self.getWidth() + 10 - 2, self.getHeight() + 10 - 2, e_UILightest, self.getOpacity() * 255);
    e_renderRect(self.getPosX() - 5 + 2, self.getPosY() - 5 + 2, self.getWidth() + 10 - 4, self.getHeight() + 10 - 4, e_UIMid, self.getOpacity() * 255);
    e_renderRect(self.getPosX() - 5 + 3, self.getPosY() - 5 + 3, self.getWidth() + 10 - 6, self.getHeight() + 10 - 6, e_UILightest, self.getOpacity() * 255);
    e_renderRect(self.getPosX() - 5 + 4, self.getPosY() - 5 + 4, self.getWidth() + 10 - 8, self.getHeight() + 10 - 8, e_UIDarkest, self.getOpacity() * 255);

    --renderer.rectangle(x - w/2 - (padding/2), y - (h/2), w + padding, h, 25, 25, 25, self.color.a)
--
    --renderer.rectangle(x     - w/2 - (padding/2),  y- (h/2),       w     + (h/2),       h,  0,  0,  0, self.color.a)
    --renderer.rectangle(x + 1 - w/2 - (padding/2),  y- (h/2) + (1), w - 2 + (h/2),   (h-2), 57, 57, 57, self.color.a)
    --renderer.rectangle(x + 2 - w/2 - (padding/2),  y- (h/2) + (2), w - 4 + (h/2),   (h-4), 40, 40, 40, self.color.a)
    --renderer.rectangle(x + 3 - w/2 - (padding/2),  y- (h/2) + (3), w - 6 + (h/2),   (h-6), 57, 57, 57, self.color.a)
    --renderer.rectangle(x + 4 - w/2 - (padding/2),  y- (h/2) + (4), w - 8 + (h/2),   (h-8), 22, 22, 22, self.color.a)
    --renderer.rectangle(x - w/2 - (padding/2) + 4, y - (h/2) + 4, w + padding - 5, 1, accent[1], accent[2], accent[3], self.color.a)

    -- -- [[ Navigation sidebar ]]
    e_renderRect(self.getPosX(), self.getPosY(),
    self.getWidth(), self.getnavbarHeight() * self.getNavbarOpacity(), e_UIMid,
        self.getNavbarOpacity() * 255);

    -- -- [[ Navigation sidebar divider ]]
    e_renderRect(self.getPosX(), self.getPosY() + (self.getnavbarHeight() * self.getNavbarOpacity()), self.getWidth(), 1,
        e_UIPrimaryBlueColor, self.getNavbarOpacity() * 255);

    -- [[ Rendering each navigation bar children element ]]
    for i = 1, #self.getChildren() do
        local child = self.getChildren()[i];
        local childPosX = self.getPosX() + (((child.getRadius() + 5) * 2) * (i - 1));
        local childPosY = self.getPosY();

        -- [[ Updating child states ]]
        child:handle(childPosX, childPosY, self, 1);

        -- [[ Rendering child ]]
        child:render(childPosX, childPosY, self, self.getHeight());
    end

    -- [[ Rendering custom mouse icon ]]
    local mousePosX, mousePosY = self.getMousePosition();
    local mouseCursorColor = (not self.getCanDrag()) and e_UIPrimaryWhiteColor or e_UISecondaryWhiteColor;

    e_renderTexture(e_UIFrameworkMouse.getTextureId(), mousePosX - 7, mousePosY - 5, e_UIFrameworkMouse.getWidth(),
        e_UIFrameworkMouse.getHeight(), mouseCursorColor, self.getOpacity() * 255);
end

--[[ Framework keys ]]
--[[
    @ keyCode - number, windows key code, inital value
    @ keyState - number, initial key state (hold, toggle, always)
    @ cb - callback function to be called once key changes its state (optional)
]]
function e_UIKey:init(keyCode, keyState, cb)
    local data = {
        keyCode = keyCode or UI_KEY_NOT_BOUND, -- [[ -1 states that currently key is not bound and should not be updated ]]
        keyState = keyState or UI_KEY_STATE["HOLD"],
        isActive = false,
        cb = cb
    }

    local public = {};

    public.setKeyCode = function(val)
        data.keyCode = val;
    end

    public.getKeyCode = function()
        return data.keyCode;
    end

    public.getKeyName = function()
        return data.keyCode == UI_KEY_NOT_BOUND and "" or e_inputKeys.mergedKeys[data.keyCode];
    end

    public.getKeyState = function()
        if (data.keyCode == UI_KEY_NOT_BOUND) then
            return false;
        else
            return data.keyState;
        end
    end

    public.setKeyStateHold = function()
        data.keyState = UI_KEY_STATE["HOLD"];
    end

    public.setKeyStateToggle = function()
        data.keyState = UI_KEY_STATE["TOGGLE"];
    end

    public.setKeyStateAlways = function()
        data.keyState = UI_KEY_STATE["ALWAYS"];
    end

    public.getIsActive = function()
        return data.isActive;
    end

    public.setIsActive = function(state)
        data.isActive = state;
    end

    public.fireCallback = function(active)
        if (type(data.cb) == "function") then
            data.cb(active);
        end
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

-- [[ Framework tabs ]]
function e_UITab:init(name, icon, children)
    local data = {
        name = name,
        icon = icon,
        radius = 32,
        children = children,
        childrenHeight = 0,
        isDraggingSidebar = false,
        sidebarDrag = 0,
        isActive = false,
        isHovered = false,
        sidebarOpacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
        opacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
    }

    local public = {};

    public.getName = function()
        return data.name;
    end

    public.getIcon = function()
        return data.icon;
    end

    public.getChildren = function()
        return data.children;
    end

    public.getChildrenHeight = function()
        return data.childrenHeight;
    end

    public.setChildrenHeight = function(val)
        data.childrenHeight = val;
    end

    public.getSidebarDrag = function()
        return data.sidebarDrag;
    end

    public.setSidebarDrag = function(val)
        data.sidebarDrag = val;
    end

    public.getIsDraggingSidebar = function()
        return data.isDraggingSidebar;
    end

    public.setIsDraggingSidebar = function(state)
        data.isDraggingSidebar = state;
    end

    public.getRadius = function()
        return data.radius;
    end

    public.getIsActive = function()
        return data.isActive;
    end

    public.setIsActive = function(val)
        data.isActive = val;
    end

    public.getIsHovered = function()
        return data.isHovered;
    end

    public.setIsHovered = function(val)
        data.isHovered = val;
    end

    public.getOpacity = function()
        return data.opacity:get();
    end

    public.setOpacity = function(val)
        data.opacity:update(globals.frametime(), val, nil);
    end

    public.getSidebarOpacity = function()
        return data.sidebarOpacity:get();
    end

    public.setSidebarOpacity = function(val)
        data.sidebarOpacity:update(globals.frametime() * 2, val, nil);
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

--[[
    @ UI - main framework base instance
]]
function e_UITab:handle(posX, posY, UI)
    -- [[ Handling hover && active state ]]
    local mousePosX, mousePosY = UI.getMousePosition();
    local inBounds = e_inBoundsCircle(posX + self.getRadius(), posY + self.getRadius(), mousePosX, mousePosY,
        self.getRadius());
    local isMouse1Held = UI.isKeyHeld(1);
    local isMouse1Pressed = UI.isKeyPressed(1);

    if (inBounds and isMouse1Pressed) then
        self.setIsActive(not self.getIsActive());
        self.setOpacity(DYN_EASING_RESET);
        UI.emitEvent(TAB_CHANGED, self.getName());
    end

    self.setIsHovered(inBounds);

    -- [[ Handling sidebar ]]
    local padding = 10;
    local stackedChildMaxHeight = UI.getHeight() - (40 + padding); -- [[ Max child window at any moment ]]
    local stackedChildStartPosY = UI.getPosY() + 40 + padding;

    if (self.getChildrenHeight() > stackedChildMaxHeight) then
        local heightDifference = self.getChildrenHeight() - stackedChildMaxHeight;
        local sidebarHeight = stackedChildMaxHeight - heightDifference;
        local sidebarPosX, sidebarPosY = UI.getPosX() + UI.getWidth() - 6,
            stackedChildStartPosY + (heightDifference * self.getSidebarDrag());

        local inBoundsSidebar = e_inBounds(sidebarPosX, sidebarPosY, mousePosX, mousePosY, 4, sidebarHeight);

        if (isMouse1Held and (inBoundsSidebar or self.getIsDraggingSidebar())) then
            self.setSidebarDrag(e_clamp((mousePosY - sidebarPosY) / sidebarHeight, 0, 1));
            self.setIsDraggingSidebar(true);
        else
            self.setIsDraggingSidebar(false);
        end
    end

    -- [[ Emitting events ]]
    if (inBounds or self.getIsDraggingSidebar()) then
        -- [[ Emitting no drag indication ]]
        UI.emitEvent(ELEMENT_HOVERED);
    end

    -- [[ Handling icon color ]]
    local targetColor = (self.getIsActive() or self.getIsHovered()) and e_UINavbarColor or e_UIPrimaryWhiteColor;
    local lerpedH, lerpedS, lerpedV = e_lerpHSV(self.getIcon().getColor(), targetColor, globals.frametime() * 12);

    self.getIcon().getColor().setHSV(lerpedH, lerpedS, lerpedV);

    -- [[ Handling animations ]]
    self.setOpacity((self.getIsHovered() or self.getIsActive()) and 1 or 0);
    self.setSidebarOpacity((self.getIsDraggingSidebar() or e_inBounds(UI.getPosX(), UI.getPosY(), mousePosX, mousePosY, UI.getWidth(), UI.getHeight())) and
        1 or 0);
end

--[[
    @ UI - main framework base instance
]]
function e_UITab:render(posX, posY, UI)
    local icon = self.getIcon();
    local iconAlpha = icon.getColor().getAlpha();

    -- [[ Rendering background circle ]]
    local tabCircleOpacity = math.min(UI.getAppearOpacity(), self.getOpacity());

    e_renderTexture(e_tabBackground.getTextureId(), posX, posY, e_tabBackground.getWidth(), e_tabBackground.getHeight(),
        e_UIPrimaryBlueColor, tabCircleOpacity * 255);

    e_renderRect(posX + e_tabBackground.getWidth() + 5, posY + 7.5, 1, e_tabBackground.getHeight() - 15,
    e_UILightest, UI.getAppearOpacity() * iconAlpha);

    -- [[ Rendering tab icon ]]
    e_renderTexture(icon.getTextureId(), posX + ((UI.getnavbarHeight() - icon.getWidth()) / 2), posY + 17,
        icon.getWidth(), icon.getHeight(), icon.getColor(), UI.getAppearOpacity() * iconAlpha);

    -- [[ Current tab is selected, render header and children ]]
    if (self.getIsActive()) then
        local basePosX = UI.getPosX();
        local basePosY = UI.getPosY() + UI.getnavbarHeight();
        local padding = 10;

        -- [[ Icon ]]
        e_renderTexture(icon.getTextureId(), basePosX + padding, basePosY + padding,
            icon.getWidth(), icon.getHeight(), e_UIPrimaryWhiteColor, UI.getAppearOpacity() * 255);

        -- [[ Title ]]
        e_renderText(basePosX + (2 * padding) + icon.getWidth(), basePosY + padding, e_UIPrimaryWhiteColor,
            UI.getAppearOpacity() * 255, "+", true, self.getName());

        -- [[ Header children, that are shared across all tabs ]]
        local stackedHeaderChildWidth = 0;

        for i = 1, #UI.getHeaderChildren() do
            local headerChild = UI.getHeaderChildren()[i];

            headerChild:handle(UI.getPosX() + (UI.getWidth() - stackedHeaderChildWidth - headerChild.getWidth()),
                basePosY, UI, 1);
            headerChild:render(UI.getPosX() + (UI.getWidth() - stackedHeaderChildWidth - headerChild.getWidth()),
                basePosY, UI, 1000);

            stackedHeaderChildWidth = stackedHeaderChildWidth + headerChild.getWidth();
        end

        -- [[ Children ]]
        local stackedChildStartPosY = basePosY + 40 + padding;

        local stackedChildHeight = 0;
        local stackedChildMaxHeight = UI.getHeight() - (40 + padding); -- [[ Max child window at any moment ]]

        local heightDifference = self.getChildrenHeight() - stackedChildMaxHeight;
        local sidebarHeight = stackedChildMaxHeight - heightDifference - 65;
        local sidebarOffset = sidebarHeight * self.getSidebarDrag();

        for j = 1, #self.getChildren() do
            local child = self.getChildren()[j];
            local childPosX, childPosY = basePosX + (2 * padding) + icon.getWidth(),
                stackedChildStartPosY + stackedChildHeight - sidebarOffset;

            -- [[ Check if current children should be rendered, based on sidebar position ]]
            if (
                    e_isBetween(childPosY + child.getHeight(), stackedChildStartPosY + child.getHeight(), stackedChildStartPosY + stackedChildMaxHeight - child.getHeight())
                ) then
                local remainingSpace = (stackedChildStartPosY + stackedChildMaxHeight - child.getHeight()) -
                    (childPosY + child.getHeight()) - 65;

                child:handle(childPosX, childPosY, UI, 1);
                child:render(childPosX, childPosY, UI, remainingSpace);
            else
                --e_hideChildren(child);
            end

            stackedChildHeight = stackedChildHeight + child.getHeight() + child.getChildrenHeight();
        end

        -- [[ Render sidebar if applicable ]]
        if (self.getChildrenHeight() > stackedChildMaxHeight) then
            local sidebarPosX, sidebarPosY = UI.getPosX() + UI.getWidth() - 6,
                stackedChildStartPosY + (heightDifference * self.getSidebarDrag());

            e_renderRect(sidebarPosX, sidebarPosY, 4, sidebarHeight,
                e_UISecondaryWhiteColor, UI.getAppearOpacity() * self.getSidebarOpacity() * 140);
        end
    end
end

-- [[ Input fields ]]
--[[
    @ width - int allocated element 'DOM' block size width
    @ height - int allocated element 'DOM' block size height
    @ limit - int, maximum input character length
]]
function e_UIInput:init(placeholder, icon, width, height, limit)
    local data = {
        _type = TYPE_UI_INPUT,
        placeholder = placeholder,
        input = "",
        icon = icon,
        width = width,
        height = height,
        isActive = false,
        isHidden = false,
        childrenHeight = 0,
        activeOpacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
        blinkOpacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
        limit = limit or 50
    }

    local public = {};

    public.getType = function()
        return data._type;
    end

    public.getPlaceholder = function()
        return data.placeholder;
    end

    public.getInput = function()
        return data.input;
    end

    public.addInput = function(val)
        data.input = data.input .. tostring(val);
    end

    public.deleteInput = function(count)
        data.input = data.input:sub(0, #data.input - count);
    end

    public.getIcon = function()
        return data.icon;
    end

    public.getWidth = function()
        return data.width;
    end

    public.getHeight = function()
        return data.height;
    end

    public.getIsActive = function()
        return data.isActive;
    end

    public.setIsActive = function(state)
        data.isActive = state;
    end

    public.getIsHidden = function()
        return data.isHidden;
    end

    public.setIsHidden = function(state)
        data.isHidden = state;
    end

    public.getChildrenHeight = function()
        return data.childrenHeight;
    end

    public.setChildrenHeight = function(val)
        data.childrenHeight = val;
    end

    public.getActiveOpacity = function()
        return data.activeOpacity:get();
    end

    public.setActiveOpacity = function(val)
        data.activeOpacity:update(globals.frametime(), val, nil);
    end

    public.getBlinkOpacity = function()
        return data.blinkOpacity:get();
    end

    public.setBlinkOpacity = function(val)
        data.blinkOpacity:update(globals.frametime(), val, nil);
    end

    public.getLimit = function()
        return data.limit;
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

function e_UIInput:handle(posX, posY, UI)
    local spaceX = self.getWidth() - e_UIFrameworkInput.getWidth();
    local spaceY = self.getHeight() - e_UIFrameworkInput.getHeight();

    -- [[ Handling hover && active state ]]
    local mousePosX, mousePosY = UI.getMousePosition();
    local inBounds = e_inBounds(posX + spaceX / 2, posY + spaceY / 2, mousePosX, mousePosY,
        e_UIFrameworkInput.getWidth(), e_UIFrameworkInput.getHeight());

    local isMouse1Pressed = UI.isKeyPressed(1);

    if (inBounds) then
        -- [[ Emitting no drag indication ]]
        UI.emitEvent(ELEMENT_HOVERED);

        if (isMouse1Pressed) then
            self.setIsActive(not self.getIsActive());
            self.setActiveOpacity(DYN_EASING_RESET);
            UI.emitEvent(self.getIsActive() and INPUT_FIELD_FOCUS or INPUT_FIELD_BLUR);
        end
    else
        -- [[ Mouse was clicked one a different element ]]
        if (isMouse1Pressed and self.getIsActive()) then
            self.setIsActive(false);
            UI.emitEvent(INPUT_FIELD_BLUR);
        end
    end

    -- [[ Handling typing state ]]
    if (self.getIsActive()) then
        local lastPressedKeyCode, lastPressedKeyValue = UI.getLastPressedKey();

        -- [[ A key was recently pressed ]]
        if (lastPressedKeyCode ~= nil) then
            -- [[ Check for 'special' input field keys ]]
            local specialKey = e_inputKeys.genericKeys[lastPressedKeyCode];
            local shouldDelete = lastPressedKeyValue == "backspace";

            if (shouldDelete) then
                self.deleteInput(1);
                return;
            end

            -- [[ Input limit exceeded ]]
            if (#self.getInput() == self.getLimit()) then
                return;
            end

            -- [[ TODO: Add extensions ]]
            if (specialKey) then
                return;
            end

            self.addInput(lastPressedKeyValue);
        end
    end

    -- [[ Handling animations ]]
    self.setBlinkOpacity(self.getIsActive() and ((globals.realtime() % 2) / 2) or 0);
    self.setActiveOpacity((self.getIsActive() or inBounds) and 1 or 0);

    -- [[ Handling icon color ]]
    local targetColor = (self.getIsActive()) and e_UIPrimaryBlueColor or e_UISecondaryWhiteColor;
    local lerpedH, lerpedS, lerpedV = e_lerpHSV(self.getIcon().getColor(), targetColor, globals.frametime() * 2);

    self.getIcon().getColor().setHSV(lerpedH, lerpedS, lerpedV);
end

function e_UIInput:render(posX, posY, UI)
    local spaceX = self.getWidth() - e_UIFrameworkInput.getWidth();
    local spaceY = self.getHeight() - e_UIFrameworkInput.getHeight();

    -- [[ Base input field texture ]]
    e_renderRect(posX + spaceX / 2, posY + spaceY / 2,
        e_UIFrameworkInput.getWidth(), e_UIFrameworkInput.getHeight(), e_UIPrimaryLGrayColor, UI.getAppearOpacity() * 255);

    --if (self.getActiveOpacity() > 0) then
    --    e_renderRect(posX + spaceX / 2, posY + spaceY / 2,
    --        e_UIFrameworkInput.getWidth(), e_UIFrameworkInput.getHeight(), e_UIPrimaryLGrayColor,
    --        UI.getOpacity() * self.getActiveOpacity() * 255);
    --end

    -- [[ Icon ]]
    local icon = self.getIcon();

    e_renderTexture(icon.getTextureId(), posX + spaceX / 2 + 10,
        posY + spaceY / 2 + (e_UIFrameworkInput.getHeight() - icon.getHeight()) / 2, icon.getWidth(), icon.getHeight(),
        icon.getColor(), UI.getAppearOpacity() * 120);

    -- [[ Display text ]]
    local displayText = (#self.getInput() > 0) and self.getInput() or self.getPlaceholder();
    local displayTextWidth, displayTextHeight = e_measureText("s", displayText);

    e_renderText(posX + spaceX / 2 + 20 + icon.getWidth(),
        posY + spaceY / 2 + (e_UIFrameworkInput.getHeight() - displayTextHeight) / 2,
        e_UISecondaryWhiteColor, UI.getAppearOpacity() * 100, "s", false, displayText);

    -- [[ Blinking indent rectangle ]]
    e_renderRect(posX + spaceX / 2 + 20 + icon.getWidth() + displayTextWidth + 2,
        posY + spaceY / 2 + (e_UIFrameworkInput.getHeight() - displayTextHeight) / 2, 1, displayTextHeight,
        e_UISecondaryWhiteColor, UI.getAppearOpacity() * self.getBlinkOpacity() * 100);
end

-- [[ Icon buttons ]]
--[[
    @ width - int allocated element 'DOM' block size width
    @ height - int allocated element 'DOM' block size height
    @cb - function to be executed on click
]]
function e_UIIconButton:init(icon, witdh, height, cb)
    assert(type(cb) == "function", "Callback must be provided!");

    local data = {
        _type = TYPE_ICON_BTN,
        icon = icon,
        width = witdh,
        height = height,
        cb = cb,
        childrenHeight = 0,
        isHidden = false,
        hoverOpacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
    };

    local public = {};

    public.getType = function()
        return data._type;
    end

    public.getIcon = function()
        return data.icon;
    end

    public.getWidth = function()
        return data.width;
    end

    public.getHeight = function()
        return data.height;
    end

    public.fireCallback = function()
        data.cb();
    end

    public.getChildrenHeight = function()
        return data.childrenHeight;
    end

    public.setChildrenHeight = function(val)
        data.childrenHeight = val;
    end

    public.getHoverOpacity = function()
        return data.hoverOpacity:get();
    end

    public.getIsHidden = function()
        return data.isHidden;
    end

    public.setIsHidden = function(state)
        data.isHidden = state;
    end

    public.setHoverOpacity = function(val)
        data.hoverOpacity:update(globals.frametime(), val, nil);
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

function e_UIIconButton:handle(posX, posY, UI, opacityModifier)
    -- [[ Handling visibility ]]
    self.setIsHidden(opacityModifier < UI_OPACITY_BORDERLINE);

    -- [[ If current menu element is hidden, there's no point of handling any other logic ]]
    if (self.getIsHidden()) then return; end

    -- [[ Handling hover && active state ]]
    local mousePosX, mousePosY = UI.getMousePosition();
    local spaceX = self.getWidth() - e_UIFrameworkIconButton.getWidth();
    local spaceY = self.getHeight() - e_UIFrameworkIconButton.getHeight();

    local inBounds = e_inBoundsCircle(posX + spaceX / 2 + e_UIFrameworkIconButton.getWidth() / 2,
        posY + spaceY / 2 + e_UIFrameworkIconButton.getWidth() / 2, mousePosX, mousePosY,
        e_UIFrameworkIconButton.getWidth() / 2);

    local isMouse1Pressed = UI.isKeyPressed(1);

    -- [[ Handling on click ]]
    if (inBounds) then
        -- [[ Emitting no drag indication ]]
        UI.emitEvent(ELEMENT_HOVERED);

        if (isMouse1Pressed) then
            self.fireCallback();
            self.setHoverOpacity(DYN_EASING_RESET);
        end
    end

    -- [[ Handling animations ]]
    self.setHoverOpacity(inBounds and 1 or (UI.getAppearOpacity() * 0.5));

    -- [[ Handling icon color ]]
    local targetColor = (inBounds) and e_UIPrimaryBlueColor or e_UISecondaryWhiteColor;
    local lerpedH, lerpedS, lerpedV = e_lerpHSV(self.getIcon().getColor(), targetColor, globals.frametime() * 2);

    self.getIcon().getColor().setHSV(lerpedH, lerpedS, lerpedV);
end

--[[
    @ opacityModifier - optional opacity modifier that can be passed
]]
function e_UIIconButton:render(posX, posY, UI, remainingSpace)
    if (self.getIsHidden()) then return; end

    local spaceX = self.getWidth() - e_UIFrameworkIconButton.getWidth();
    local spaceY = self.getHeight() - e_UIFrameworkIconButton.getHeight();

    -- [[ Rendering main base ]]
    --e_renderRect(posX + spaceX / 2, posY + spaceY / 2,
    --    e_UIFrameworkIconButton.getWidth(),
    --    e_UIFrameworkIconButton.getHeight(), e_UIMid, UI.getAppearOpacity() * 255);

    if (self.getHoverOpacity() > 0) then
        e_renderRect(posX + spaceX / 2, posY + spaceY / 2,
            e_UIFrameworkIconButton.getWidth(),
            e_UIFrameworkIconButton.getHeight(), e_UIMid,
            UI.getAppearOpacity() * self.getHoverOpacity() * 255);
    end

    -- [[ Icon ]]
    local icon = self.getIcon();

    e_renderTexture(icon.getTextureId(), posX + spaceX / 2 + (e_UIFrameworkIconButton.getWidth() - icon.getWidth()) / 2,
        posY + spaceY / 2 + (e_UIFrameworkIconButton.getHeight() - icon.getHeight()) / 2, icon.getWidth(),
        icon.getHeight(),
        icon.getColor(), self.getHoverOpacity() * 255);
end

-- [[ Checkboxes ]]
--[[
    @ children - optional, list of children that should be displayed when active
]]
function e_UICheckbox:init(name, children, width, height)
    -- [[ Hiding all children by default ]]
    --e_hideChildren(children);

    local data = {
        _type = TYPE_CHECKBOX,
        name = name,
        width = width,
        height = height,
        children = children or {},
        isActive = false,
        isHidden = false,
        childrenHeight = 0,
        activeOpacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
        hoverOpacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
    }

    local public = {};

    public.getType = function()
        return data._type;
    end

    public.getName = function()
        return data.name;
    end

    public.getWidth = function()
        return data.width;
    end

    public.getHeight = function()
        return data.height;
    end

    public.getChildren = function()
        return data.children;
    end

    public.getIsActive = function()
        return data.isActive;
    end

    public.setIsActive = function(state)
        data.isActive = state;
    end

    public.getIsHidden = function()
        return data.isHidden;
    end

    public.setIsHidden = function(state)
        data.isHidden = state;
    end

    public.getChildrenHeight = function()
        return data.childrenHeight;
    end

    public.setChildrenHeight = function(val)
        data.childrenHeight = val;
    end

    public.getActiveOpacity = function()
        return data.activeOpacity:get();
    end

    public.setActiveOpacity = function(val)
        data.activeOpacity:update(globals.frametime() * 2, val, nil);
    end

    public.getHoverOpacity = function()
        return data.hoverOpacity:get();
    end

    public.setHoverOpacity = function(val)
        data.hoverOpacity:update(globals.frametime() * 2, val, nil);
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

function e_UICheckbox:handle(posX, posY, UI, opacityModifier)
    -- [[ Handling visibility ]]
    self.setIsHidden(opacityModifier < UI_OPACITY_BORDERLINE);

    -- [[ If current menu element is hidden, there's no point of handling any other logic ]]
    if (self.getIsHidden()) then return; end

    -- [[ Handling hover && active state ]]
    local mousePosX, mousePosY = UI.getMousePosition();

    local inBounds = e_inBounds(posX - e_UIFrameworkCheckboxOutline.getWidth() - 15,
        posY + (self.getHeight() - e_UIFrameworkCheckboxOutline.getHeight()) / 2, mousePosX, mousePosY,
        e_UIFrameworkCheckboxOutline.getWidth(),
        e_UIFrameworkCheckboxOutline.getHeight());

    local isMouse1Pressed = UI.isKeyPressed(1);

    -- [[ Handling on click ]]
    if (inBounds and UI.getCanDrag()) then
        -- [[ Emitting no drag indication ]]
        UI.emitEvent(ELEMENT_HOVERED);

        if (isMouse1Pressed) then
            self.setIsActive(not self.getIsActive());
            self.setActiveOpacity(DYN_EASING_RESET);

            -- [[ If the state becomes inactive, we update the visiblity of children elements ]]
            if (not self.getIsActive() and self.getChildren()) then
                e_hideChildren(self.getChildren());
            end

            -- [[ Current state changed, if we have any children, we emit event to re-calculate max child height in the tab ]]
            UI.emitEvent(RECALC_TAB_MAX_HEIGHT, self.getName());
        end
    end

    -- [[ Handling animations ]]
    self.setActiveOpacity(self.getIsActive() and 1 or 0);
    self.setHoverOpacity(inBounds and 1 or 0);
end

function e_UICheckbox:render(posX, posY, UI, remainingSpace)
    if (self.getIsHidden()) then return; end

    local nameWidth, nameHeight = e_measureText("s", self.getName());
    local spaceX = self.getWidth() - nameWidth;
    local spaceY = self.getHeight() - nameHeight;

    -- [[ Rendering checkbox outline ]]
    if (self.getHoverOpacity() < UI_OPACITY_BORDERLINE) then
        e_renderTexture(e_UIFrameworkCheckboxOutline.getTextureId(), posX - e_UIFrameworkCheckboxOutline.getWidth() - 15,
            posY + (self.getHeight() - e_UIFrameworkCheckboxOutline.getHeight()) / 2,
            e_UIFrameworkCheckboxOutline.getWidth(),
            e_UIFrameworkCheckboxOutline.getHeight(), e_UIPrimaryWhiteColor,
            UI.getAppearOpacity() * 200);
    end

    -- [[ Rendering checkbox active state ]]
    local activeOpacity = math.max(self.getHoverOpacity(), self.getActiveOpacity());

    if (activeOpacity > UI_OPACITY_BORDERLINE) then
        e_renderTexture(e_UIFRameworkCheckboxActive.getTextureId(), posX - e_UIFrameworkCheckboxOutline.getWidth() - 15,
            posY + (self.getHeight() - e_UIFrameworkCheckboxOutline.getHeight()) / 2,
            e_UIFrameworkCheckboxOutline.getWidth(),
            e_UIFrameworkCheckboxOutline.getHeight(), e_UIPrimaryBlueColor,
            UI.getAppearOpacity() * activeOpacity * 200);
    end

    -- [[ Rendering checkbox name ]]
    e_renderText(posX, posY + spaceY / 2, e_UISecondaryWhiteColor, UI.getAppearOpacity() * 140, "s",
        false,
        self.getName());

    -- [[ Rendering seperator ]]
    e_renderRect(posX, posY + self.getHeight(), self.getWidth(), 1, e_UISecondaryWhiteColor,
        UI.getAppearOpacity() * 30);

    -- [[ Rendering children, if applicable ]]
    local stackedChildHeight = 0;

    if (self.getActiveOpacity() > UI_OPACITY_BORDERLINE) then
        for i = 1, #self.getChildren() do
            local child = self.getChildren()[i];
            local childPosX, childPosY = posX, posY + (child.getHeight() + stackedChildHeight) * self.getActiveOpacity();
            local updatedRemainingSpace = remainingSpace - stackedChildHeight;
            local childFits = updatedRemainingSpace >= 0;

            if (childFits) then
                child:handle(childPosX, childPosY, UI, self.getActiveOpacity());
                child:render(childPosX, childPosY, UI, updatedRemainingSpace);
            end

            stackedChildHeight = stackedChildHeight + child.getHeight() + child.getChildrenHeight();
        end
    end

    -- [[ Updating child height metric ]]
    self.setChildrenHeight(stackedChildHeight);
end

-- [[ Sliders ]]
--[[
    @ unit - string, unit of measurement added to the rendered value (optional)
]]
function e_UISlider:init(name, unit, minValue, maxValue, isFloat, width, height)
    local negativeSliderType = minValue < 0;

    local data = {
        _type = TYPE_SLIDER,
        name = name,
        unit = unit or "",
        minValue = minValue,
        maxValue = maxValue,
        isFloat = isFloat,
        dragValue = negativeSliderType and 0.5 or minValue, -- [[ Holds the drag fraction from 0 to 1, which ultimately decides the current value ]]
        value = negativeSliderType and 0 or minValue,
        width = width,
        height = height,
        isDragging = false,
        isHidden = false,
        childrenHeight = 0
    };

    local public = {};

    public.getType = function()
        return data._type;
    end

    public.getName = function()
        return data.name;
    end

    public.getUnit = function()
        return data.unit;
    end

    public.getWidth = function()
        return data.width;
    end

    public.getHeight = function()
        return data.height;
    end

    public.getMinValue = function()
        return data.minValue;
    end

    public.getMaxValue = function()
        return data.maxValue;
    end

    public.getDragValue = function()
        return data.dragValue;
    end

    public.setDragValue = function(val)
        -- [[ Handling float sliders ]]
        local floatMult = data.isFloat and 10 or 1;

        if (negativeSliderType) then
            if (val < 0.5) then
                data.value = e_clamp(math.floor((0.5 - val) * data.minValue * floatMult) / floatMult, data.minValue,
                    data.maxValue);
            elseif (val > 0.5) then
                data.value = e_clamp(math.floor((val - 0.5) * data.maxValue * floatMult) / floatMult, data.minValue,
                    data.maxValue);
            else
                data.value = 0;
            end
        else
            data.value = e_clamp(math.floor(val * data.maxValue * floatMult) / floatMult, 0, data.maxValue);
        end

        data.dragValue = val;
    end

    public.getValue = function(toDisplay)
        return toDisplay and (data.value .. " " .. data.unit) or data.value;
    end

    public.getIsDragging = function()
        return data.isDragging;
    end

    public.setIsDragging = function(state)
        data.isDragging = state;
    end

    public.getChildrenHeight = function()
        return data.childrenHeight;
    end

    public.getIsHidden = function()
        return data.isHidden;
    end

    public.setIsHidden = function(state)
        data.isHidden = state;
    end

    public.setChildrenHeight = function(val)
        data.childrenHeight = val;
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

function e_UISlider:handle(posX, posY, UI, opacityModifier)
    -- [[ Handling visibility ]]
    self.setIsHidden(opacityModifier < UI_OPACITY_BORDERLINE);

    -- [[ If current menu element is hidden, there's no point of handling any other logic ]]
    if (self.getIsHidden()) then return; end

    -- [[ Handling hover && drag state ]]
    local mousePosX, mousePosY = UI.getMousePosition();

    local sliderStripPosX = posX + self.getWidth() - e_UIFrameworkSliderBase.getWidth() - 5;
    local sliderStripPosY = posY + (self.getHeight() - e_UIFrameworkSliderBase.getHeight()) / 2 + 1;

    local inBounds = e_inBounds(sliderStripPosX - (e_UIFrameworkSliderCircle.getWidth() / 2) +
        (e_UIFrameworkSliderBase.getWidth() * self.getDragValue()), sliderStripPosY - 6, mousePosX, mousePosY,
        e_UIFrameworkSliderCircle.getWidth(), e_UIFrameworkSliderCircle.getHeight());

    local isMouse1Held = UI.isKeyHeld(1);

    -- [[ Handling slider drag ]]
    if (isMouse1Held and (inBounds or self.getIsDragging())) then
        self.setDragValue(e_clamp((mousePosX - sliderStripPosX) / e_UIFrameworkSliderBase.getWidth(), 0, 1));
        self.setIsDragging(true);
    else
        self.setIsDragging(false);
    end

    if (inBounds or self.getIsDragging()) then
        -- [[ Emitting no drag indication ]]
        UI.emitEvent(ELEMENT_HOVERED);
    end
end

function e_UISlider:render(posX, posY, UI, remainingSpace)
    if (self.getIsHidden()) then return; end

    local nameWidth, nameHeight = e_measureText("s", self.getName());
    local valueWidth, valueHeight = e_measureText("s", self.getValue(true));

    local spaceX = self.getWidth() - nameWidth;
    local spaceY = self.getHeight() - nameHeight;

    local sliderStripPosX = posX + self.getWidth() - e_UIFrameworkSliderBase.getWidth() - 5;
    local sliderStripPosY = posY + (self.getHeight() - e_UIFrameworkSliderBase.getHeight()) / 2 + 1;

    local padding = 10;

    -- [[ Rendering slider name ]]
    e_renderText(posX, posY + spaceY / 2, e_UISecondaryWhiteColor, UI.getAppearOpacity() * 140, "s", false,
        self.getName());

    -- [[ Rendering slider value ]]
    e_renderText(sliderStripPosX - valueWidth - padding, posY + spaceY / 2, e_UISecondaryWhiteColor,
        UI.getAppearOpacity() * 140, "s", false,
        self.getValue(true));

    -- [[ Rendering slider base strip ]]
    e_renderTexture(e_UIFrameworkSliderBase.getTextureId(), sliderStripPosX, sliderStripPosY,
        e_UIFrameworkSliderBase.getWidth(),
        e_UIFrameworkSliderBase.getHeight(), e_UIPrimaryWhiteColor, UI.getAppearOpacity() * 255);

    -- [[ Rendering slider current drag position circle ]]
    local sliderCircleAlpha = self.getIsDragging() and 255 or 200;

    e_renderTexture(e_UIFrameworkSliderCircle.getTextureId(),
        sliderStripPosX - (e_UIFrameworkSliderCircle.getWidth() / 2) +
        (e_UIFrameworkSliderBase.getWidth() * self.getDragValue()), sliderStripPosY - 6,
        e_UIFrameworkSliderCircle.getWidth(), e_UIFrameworkSliderCircle.getHeight(), e_UIPrimaryBlueColor,
        UI.getAppearOpacity() * sliderCircleAlpha);

    -- [[ Rendering seperator ]]
    e_renderRect(posX, posY + self.getHeight(), self.getWidth(), 1, e_UISecondaryWhiteColor, UI.getAppearOpacity() * 30);
end

-- [[ Keybinds ]]
--[[
    @ UI - main framework base instance, required for inital key binding to ui active bound keys
]]
function e_UIKeybind:init(UI, key, name, width, height)
    local h, s, v = e_UISecondaryWhiteColor.getHSV();

    local data = {
        _type = TYPE_KEYBIND,
        key = key, -- [[ e_UIKey ]]
        name = name,
        width = width,
        height = height,
        color = e_UIColor:init(h, s, v, 255),
        awaiting = false, -- [[ Denotes whether the keybind is waiting for user input ]]
        childrenHeight = 0,
        isHidden = false
    };

    -- [[ Binding key to framework ]]
    -- TODO: Re-implement
    -- client.delay_call(5, function()
    --     UI.setBoundKey(name, key);
    -- end);

    local public = {};

    public.getType = function()
        return data._type;
    end

    public.getAttachedKey = function()
        return data.key;
    end

    public.getName = function()
        return data.name;
    end

    public.getWidth = function()
        return data.width;
    end

    public.getHeight = function()
        return data.height;
    end

    public.getColor = function()
        return data.color;
    end

    public.getIsAwaiting = function()
        return data.awaiting;
    end

    public.setIsAwaiting = function(state)
        data.awaiting = state;
    end

    public.getChildrenHeight = function()
        return data.childrenHeight;
    end

    public.setChildrenHeight = function(val)
        data.childrenHeight = val;
    end

    public.getIsHidden = function()
        return data.isHidden;
    end

    public.setIsHidden = function(state)
        data.isHidden = state;
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

function e_UIKeybind:handle(posX, posY, UI)
    -- [[ Handling hover && awaiting state ]]
    local mousePosX, mousePosY = UI.getMousePosition();

    local attachedKey = self.getAttachedKey();
    local keyNameWidth, keyNameHeight = e_measureText("s", attachedKey.getKeyName());
    local keyBindIconPosX = posX + self.getWidth() - keyNameWidth - e_keybindIcon.getWidth() - 3;
    local spaceY = self.getHeight() - keyNameHeight;

    local inBounds = e_inBounds(keyBindIconPosX, posY + spaceY / 2, mousePosX, mousePosY, e_keybindIcon.getWidth(),
        e_keybindIcon.getHeight());

    local isMouse1Pressed = UI.isKeyPressed(1);

    if (inBounds) then
        -- [[ Emitting no drag indication ]]
        UI.emitEvent(ELEMENT_HOVERED);

        if (isMouse1Pressed) then
            self.setIsAwaiting(not self.getIsAwaiting());
            UI.emitEvent(self.getIsAwaiting() and INPUT_FIELD_FOCUS or INPUT_FIELD_BLUR);
        end
    else
        -- [[ Mouse was clicked one a different element ]]
        if (isMouse1Pressed and self.getIsAwaiting()) then
            self.setIsAwaiting(false);
            UI.emitEvent(INPUT_FIELD_BLUR);
            self.getAttachedKey().setKeyCode(UI_KEY_NOT_BOUND); -- [[ Unbinding key ]]
        end
    end

    -- [[ Handling awaiting state ]]
    if (self.getIsAwaiting()) then
        local lastPressedKeyCode, lastPressedKeyValue = UI.getLastPressedKey();
        local invalidKey = lastPressedKeyValue == "mouse1" or lastPressedKeyValue == "mouse2";

        -- [[ A key was recently pressed ]]
        if (lastPressedKeyCode ~= nil and not invalidKey) then
            self.getAttachedKey().setKeyCode(lastPressedKeyCode);
            self.setIsAwaiting(false);

            UI.emitEvent(INPUT_FIELD_BLUR);
        end
    end

    -- [[ Handling icon color ]]
    local targetColor = (self.getIsAwaiting() or inBounds) and e_UIPrimaryBlueColor or e_UISecondaryWhiteColor;
    local lerpedH, lerpedS, lerpedV = e_lerpHSV(self.getColor(), targetColor, globals.frametime());

    self.getColor().setHSV(lerpedH, lerpedS, lerpedV);
end

function e_UIKeybind:render(posX, posY, UI)
    local attachedKey = self.getAttachedKey();

    local nameWidth, nameHeight = e_measureText("s", self.getName());
    local keyNameWidth, keyNameHeight = e_measureText("s", attachedKey.getKeyName());
    local spaceX = self.getWidth() - nameWidth;
    local spaceY = self.getHeight() - nameHeight;

    local padding = 5;

    local keybindIconPosX = posX + self.getWidth() - keyNameWidth - e_keybindIcon.getWidth() - padding -
        (attachedKey.getKeyName() ~= "" and padding or 0);
    local keybindNamePosX = posX + self.getWidth() - keyNameWidth - padding;

    -- [[ Rendering keybind name ]]
    e_renderText(posX, posY + spaceY / 2, e_UISecondaryWhiteColor, UI.getAppearOpacity() * 140, "s", false,
        self.getName());

    -- [[ Rendering keybind icon ]]
    e_renderTexture(e_keybindIcon.getTextureId(), keybindIconPosX, posY + spaceY / 2, e_keybindIcon.getWidth(),
        e_keybindIcon.getHeight(), self.getColor(), UI.getAppearOpacity() * 200);

    -- [[ Rendering bound key name ]]
    e_renderText(keybindNamePosX, posY + spaceY / 2, e_UISecondaryWhiteColor, UI.getAppearOpacity() * 140, "s", false,
        attachedKey.getKeyName());

    -- [[ Rendering seperator ]]
    e_renderRect(posX, posY + self.getHeight(), self.getWidth(), 1, e_UISecondaryWhiteColor, UI.getAppearOpacity() * 30);
end

-- [[ Colorpickers ]]
--[[
    @ defaultColor - e_UIColor instance (optional)
]]
function e_UIColorpicker:init(name, defaultColor, children, width, height)
    local data = {
        _type = TYPE_COLORPICKER,
        name = name,
        color = defaultColor or e_UIPrimaryBlueColor,
        children = children or {},
        width = width,
        height = height,
        isActive = false,
        isDraggingAlpha = false,
        childrenHeight = 0,
        isHidden = false,
        activeOpacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
        hoverOpacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
    }

    local public = {};

    public.getType = function()
        return data._type;
    end

    public.getName = function()
        return data.name;
    end

    public.getColor = function()
        return data.color;
    end

    public.getChildren = function()
        return data.children;
    end

    public.getWidth = function()
        return data.width;
    end

    public.getHeight = function()
        return data.height;
    end

    public.getIsActive = function()
        return data.isActive;
    end

    public.setIsActive = function(state)
        data.isActive = state;
    end

    public.getIsDraggingAlpha = function()
        return data.isDraggingAlpha;
    end

    public.setIsDraggingAlpha = function(state)
        data.isDraggingAlpha = state;
    end

    public.getChildrenHeight = function()
        return data.childrenHeight;
    end

    public.setChildrenHeight = function(val)
        data.childrenHeight = val;
    end

    public.getIsHidden = function()
        return data.isHidden;
    end

    public.setIsHidden = function(state)
        data.isHidden = state;
    end

    public.getActiveOpacity = function()
        return data.activeOpacity:get();
    end

    public.setActiveOpacity = function(val)
        data.activeOpacity:update(globals.frametime(), val, nil);
    end

    public.getHoverOpacity = function()
        return data.hoverOpacity:get();
    end

    public.setHoverOpacity = function(val)
        data.hoverOpacity:update(globals.frametime(), val, nil);
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

function e_UIColorpicker:handle(posX, posY, UI)
    --[[ Handling color picker dragging && opening state && alpha state ]]
    local mousePosX, mousePosY                         = UI.getMousePosition();

    local color                                        = self.getColor();
    local colorAlpha                                   = math.floor((color.getAlpha() / 255) * 100);
    local colorAlphaText                               = colorAlpha .. "%";
    local alphaWidth, alphaHeight                      = e_measureText("s", colorAlphaText);

    local spaceY                                       = self.getHeight() - alphaHeight;
    local padding                                      = 5;

    local colorAlphaTextPosX, colorAlphaTextPosY       = posX + self.getWidth() - alphaWidth - padding, posY + spaceY / 2;
    local colorDropperIconPosX, e_colorDropperIconPosY = colorAlphaTextPosX - e_colorDropperIcon.getWidth() - padding,
        posY + ((self.getHeight() - e_colorDropperIcon.getHeight()) / 2);

    local inBounds                                     = e_inBounds(colorDropperIconPosX, e_colorDropperIconPosY,
        mousePosX, mousePosY,
        e_colorDropperIcon.getWidth(), e_colorDropperIcon.getHeight());
    local inBoundsAlpha                                = e_inBounds(colorAlphaTextPosX, colorAlphaTextPosY, mousePosX,
        mousePosY, alphaWidth, alphaHeight);

    local isMouse1Pressed                              = UI.isKeyPressed(1);
    local isMouse1Held                                 = UI.isKeyHeld(1);

    -- [[ Handling opening state ]]
    if (inBounds and isMouse1Pressed) then
        self.setHoverOpacity(DYN_EASING_RESET);
        self.setIsActive(not self.getIsActive());
    end

    -- [[ If the window is open and we click outside the main window, we must close it ]]
    if (self.getIsActive() and not inBounds and not inBoundsAlpha and not self.getIsDraggingAlpha() and isMouse1Pressed) then
        local colorpickerWindowPosX, colorpickerWindowPosY = posX + self.getWidth() + 15,
            UI.getPosY() + ((UI.getHeight() - e_colorpickerWindow.getHeight()) / 2);

        if (not e_inBounds(colorpickerWindowPosX, colorpickerWindowPosY, mousePosX, mousePosY,
                e_colorpickerWindow.getWidth(), e_colorpickerWindow.getHeight())) then
            self.setIsActive(false);
        end
    end

    -- [[ Handling alpha 'slider' ]]
    if (isMouse1Held and UI.getCanDrag() and (inBoundsAlpha or self.getIsDraggingAlpha())) then
        -- [[ Emitting no drag indication ]]
        UI.emitEvent(ELEMENT_HOVERED);

        -- [[ Alpha slider logic ]]
        -- [[ If mouse is above the alpha slider text and is being dragged upwards, we increase the alpha, otherwise we decrease it ]]
        local currentAlpha = self.getColor().getAlpha();

        -- [[ Positive indicates that mouse is above the alpha text ]]
        local alphaDeltaY = colorAlphaTextPosY - mousePosY;
        local alphaDeltaYAbsolute = math.abs(alphaDeltaY);

        -- [[ Increase / decrease scales based on distance, the further is dragged, the quicker ]]
        local alphaScaleAbsolute = e_isBetween(alphaDeltaYAbsolute, 50, 9999) and 2 or
            (e_isBetween(alphaDeltaYAbsolute, 30, 49) and 1) or
            (e_isBetween(alphaDeltaYAbsolute, 10, 29) and 0.25 or 0.1);
        local alphaScale = alphaDeltaY > 0 and alphaScaleAbsolute or -alphaScaleAbsolute;

        self.getColor().setAlpha(currentAlpha + alphaScale);
        self.setIsDraggingAlpha(true);
    else
        self.setIsDraggingAlpha(false);
    end

    -- [[ Handling color picker palet dragging ]]
    if (self.getIsActive() and self.getActiveOpacity() > 0) then
        local colorpickerCircleRadius = 55;

        local colorpickerWindowPosX, colorpickerWindowPosY = posX + self.getWidth() + 15,
            UI.getPosY() + ((UI.getHeight() - e_colorpickerWindow.getHeight()) / 2);
        local colorpickerCircleCenterX, colorpickerCircleCenterY = colorpickerWindowPosX + 10 + colorpickerCircleRadius,
            colorpickerWindowPosY + 10 + colorpickerCircleRadius;

        local inBoundsCircle = e_inBoundsCircle(colorpickerCircleCenterX, colorpickerCircleCenterY, mousePosX, mousePosY,
            colorpickerCircleRadius);

        -- [[ Cursor is in color picker wheel region, performing hsv color calculation ]]
        if (inBoundsCircle and isMouse1Held) then
            -- [[ Emitting no drag indication ]]
            UI.emitEvent(ELEMENT_HOVERED);

            local deltaCenter = math.sqrt(((colorpickerCircleCenterX - mousePosX) ^ 2) +
                ((colorpickerCircleCenterY - mousePosY) ^ 2));

            local deltaX, deltaY = colorpickerCircleCenterX - mousePosX, colorpickerCircleCenterY - mousePosY;
            local angle = 180 - math.atan2(deltaY, deltaX) * (180 / math.pi); -- [[ Hue angle ]]

            local _, __, v = color.getHSV();

            self.getColor().setHSV(angle, deltaCenter / colorpickerCircleRadius, v);
        end
    end

    -- [[ Emitting events ]]
    if (inBounds or inBoundsAlpha) then
        -- [[ Emitting no drag indication ]]
        UI.emitEvent(ELEMENT_HOVERED);
    end

    -- [[ Handling animations ]]
    self.setHoverOpacity((inBounds or self.getIsActive()) and 1 or 0);
    self.setActiveOpacity(self.getIsActive() and 1 or 0);
end

function e_UIColorpicker:render(posX, posY, UI)
    local color = self.getColor();
    local colorAlpha = math.floor((color.getAlpha() / 255) * 100);
    local colorAlphaText = colorAlpha .. "%";

    local nameWidth, nameHeight = e_measureText("s", self.getName());
    local alphaWidth, alphaHeight = e_measureText("s", colorAlphaText);
    local spaceX = self.getWidth() - nameWidth;
    local spaceY = self.getHeight() - nameHeight;

    local padding = 5;

    local colorAlphaTextPosX = posX + self.getWidth() - alphaWidth - padding;
    local colorDropperIconPosX, e_colorDropperIconPosY = colorAlphaTextPosX - e_colorDropperIcon.getWidth() - padding,
        posY + ((self.getHeight() - e_colorDropperIcon.getHeight()) / 2);
    local colorCircleIconPosX, e_colorCircleIconPosY = colorDropperIconPosX - e_colorCircleIcon.getWidth() - padding,
        posY + ((self.getHeight() - e_colorCircleIcon.getHeight()) / 2);

    -- [[ Rendering colorpicker name ]]
    e_renderText(posX, posY + spaceY / 2, e_UISecondaryWhiteColor, UI.getAppearOpacity() * 140, "s", false,
        self.getName());

    -- [[ Rendering color circle icon ]]
    e_renderTexture(e_colorCircleIcon.getTextureId(), colorCircleIconPosX, e_colorCircleIconPosY,
        e_colorCircleIcon.getWidth(), e_colorCircleIcon.getHeight(), color,
        UI.getAppearOpacity() * 200);

    -- [[ Rendering color dropper icon ]]
    e_renderTexture(e_colorDropperIcon.getTextureId(), colorDropperIconPosX, e_colorDropperIconPosY,
        e_colorDropperIcon.getWidth(), e_colorDropperIcon.getHeight(), e_UISecondaryWhiteColor,
        UI.getAppearOpacity() * 200 + (UI.getAppearOpacity() * self.getHoverOpacity() * 25));

    -- [[ Rendering color alpha indicator ]]
    e_renderText(colorAlphaTextPosX, posY + spaceY / 2,
        self.getIsDraggingAlpha() and e_UIPrimaryWhiteColor or e_UISecondaryWhiteColor, UI.getAppearOpacity() * 140, "s",
        false,
        colorAlphaText);

    -- [[ Rendering open colorpicker window ]]
    if (self.getActiveOpacity() > 0) then
        local h, s, v = color.getHSV();

        local colorpickerCircleRadius = 55;

        local circleCursorX, circleCursorY = (s * colorpickerCircleRadius * math.cos(math.rad(h))),
            (s * colorpickerCircleRadius * -math.sin(math.rad(h)));

        local colorpickerWindowPosX, colorpickerWindowPosY = posX + self.getWidth() + 15,
            UI.getPosY() + ((UI.getHeight() - e_colorpickerWindow.getHeight()) / 2);
        local colorpickerCircleCenterX, colorpickerCircleCenterY = colorpickerWindowPosX + 10 + colorpickerCircleRadius,
            colorpickerWindowPosY + 10 + colorpickerCircleRadius;
        local colorDragCursorPosX, colorDragCursorPosY =
            colorpickerCircleCenterX + circleCursorX - e_UIFrameworkSliderCircle.getWidth() / 2,
            colorpickerCircleCenterY + circleCursorY - e_UIFrameworkSliderCircle.getHeight() / 2;

        -- [[ Colorpicker window ]]
        e_renderTexture(e_colorpickerWindow.getTextureId(), colorpickerWindowPosX, colorpickerWindowPosY,
            e_colorpickerWindow.getWidth(), e_colorpickerWindow.getHeight(), e_UIPrimaryWhiteColor,
            UI.getAppearOpacity() * self.getActiveOpacity() * 255);

        -- [[ Color drag cursor ]]
        e_renderTexture(e_UIFrameworkSliderCircle.getTextureId(), colorDragCursorPosX, colorDragCursorPosY,
            e_UIFrameworkSliderCircle.getWidth(), e_UIFrameworkSliderCircle.getHeight(), e_UIBackgroundColor,
            UI.getAppearOpacity() * self.getActiveOpacity() * 255);

        -- [[ Render child elements in a row (buttons) ]]
        local stackedChildrenWidth = padding;

        for i = 1, #self.getChildren() do
            local child = self.getChildren()[i];

            child:handle(colorpickerWindowPosX + stackedChildrenWidth,
                colorpickerCircleCenterY + colorpickerCircleRadius + padding, UI, self.getActiveOpacity());
            child:render(colorpickerWindowPosX + stackedChildrenWidth,
                colorpickerCircleCenterY + colorpickerCircleRadius + padding, UI, UI.getHeight());

            stackedChildrenWidth = stackedChildrenWidth + child.getWidth();
        end
    end

    -- [[ Rendering seperator ]]
    e_renderRect(posX, posY + self.getHeight(), self.getWidth(), 1, e_UISecondaryWhiteColor, UI.getAppearOpacity() * 30);
end

-- [[ Selectors (Dropdowns / Multi-dropdowns) ]]
--[[
    @ options - table of elements to display to be possibly selected
    @ isMulti - states whether multiple selections can be made at the same time (multidropdown)
]]
function e_UISelector:init(name, options, children, isMulti, width, height)
    assert(type(options) == "table", "Options must be a table!");
    assert(type(isMulti) == "boolean",
        "isMulti must be a boolean and indicates whether multiple selections can be made at the same time!");

    local data = {
        _type = isMulti and TYPE_MULTIDROPDOWN or TYPE_DROPDOWN,
        name = name,
        options = options,
        selected = {}, -- [[ Holds key value indexes of selected options ]]
        isMulti = isMulti,
        children = children or {},
        width = width,
        height = height,
        isActive = false,
        isHidden = false,
        childrenHeight = 0,
        color = e_UIColor:init(235, 5.8 / 100, 81.6 / 100, 255),
        activeOpacity = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0)
    };

    local public = {};

    public.getType = function()
        return data._type;
    end

    public.getName = function()
        return data.name;
    end

    public.getOptions = function()
        return data.options;
    end

    public.getSelectedRaw = function()
        return getKeys(data.selected);
    end

    -- [[ TODO: Possibly cache the selection list after changes in setSelected, will be more performant ]]
    --[[
        @ everything - boolean, states whether it should return all elements, including not selected
    ]]
    public.getSelected = function(maxWidth, everything)
        local result = {};

        if (everything) then
            for i = 1, #data.options do
                table.insert(result, data.options[i]);
            end
        else
            for index, _ in pairs(data.selected) do
                table.insert(result, options[index]);
            end
        end

        local resultStr = table.concat(result, ", ");
        local w, h = e_measureText("s", resultStr);

        -- [[ Selected text name width exceeds the limit, truncate ]]
        if (w > maxWidth) then
            local avgLenPerChar = w / #resultStr;
            local resultingCharCount = math.floor(e_clamp(maxWidth / avgLenPerChar - 3, 0, #resultStr)); -- [[ 3 left for dots ]]

            resultStr = resultStr:sub(0, resultingCharCount) .. "...";
            w, h = e_measureText("s", resultStr);
        end

        return w, h, resultStr, result;
    end

    public.isSelected = function(index)
        return data.selected[index] ~= nil;
    end

    public.getSelectedColor = function(index)
        return data.selected[index];
    end

    --[[
        @ index - index of options list
    ]]
    public.setSelected = function(index)
        -- [[ Handling logic for multi-dropdowns ]]
        if (data.isMulti) then
            -- [[ If selected index was already active, we de-select it, otherwise select it ]]
            if (data.selected[index] ~= nil) then
                table.remove(data.selected, index);
            else
                data.selected[index] = e_UIColor:init(235, 5.8 / 100, 81.6 / 100, 255);
            end
        else
            -- [[ Handling dropdown logic ]]
            -- [[ If current key was selected, we remove it ]]
            if (data.selected[index] ~= nil) then
                table.remove(data.selected, index);
            else
                -- [[ Otherwise, different key was previously selected, we initialize a new list with it ]]
                data.selected = {};
                data.selected[index] = e_UIColor:init(235, 5.8 / 100, 81.6 / 100, 255);
            end
        end
    end

    public.getIsMulti = function()
        return data.isMulti;
    end

    public.getChildren = function()
        return data.children;
    end

    public.getWidth = function()
        return data.width;
    end

    public.getHeight = function()
        return data.height;
    end

    public.getIsActive = function()
        return data.isActive;
    end

    public.setIsActive = function(state)
        data.isActive = state;
    end

    public.getColor = function()
        return data.color;
    end

    public.getChildrenHeight = function()
        return data.childrenHeight;
    end

    public.setChildrenHeight = function(val)
        data.childrenHeight = val;
    end

    public.getIsHidden = function()
        return data.isHidden;
    end

    public.setIsHidden = function(state)
        data.isHidden = state;
    end

    public.getActiveOpacity = function()
        return data.activeOpacity:get();
    end

    public.setActiveOpacity = function(val)
        data.activeOpacity:update(globals.frametime() * 2, val, nil);
    end

    setmetatable(public, self);
    self.__index = self;

    return public;
end

function e_UISelector:handle(posX, posY, UI, opacityModifier)
    -- [[ Handling visibility ]]
    self.setIsHidden(opacityModifier < UI_OPACITY_BORDERLINE);

    -- [[ If current menu element is hidden, there's no point of handling any other logic ]]
    if (self.getIsHidden()) then return; end

    -- [[ Handling active state ]]
    local mousePosX, mousePosY                                = UI.getMousePosition();
    local selectedMaxWidth                                    = 130 + ((self.getWidth() - 130) * self.getActiveOpacity());
    local selectedNameWidth, selectedNameHeight, selectedName = self.getSelected(selectedMaxWidth,
        self.getActiveOpacity() > 0.1);

    local padding                                             = 5;

    local selectedPosX                                        = posX + self.getWidth() - selectedNameWidth - padding;
    local expandIconPosX, expandIconPosY                      = selectedPosX - e_selectorExpandIcon.getWidth() - padding,
        posY + ((self.getHeight() - e_selectorExpandIcon.getHeight()) / 2);

    local inBoundsExpand                                      = e_inBounds(expandIconPosX, expandIconPosY, mousePosX,
        mousePosY, e_selectorExpandIcon.getWidth(), e_selectorExpandIcon.getHeight());
    local isMouse1Pressed                                     = UI.isKeyPressed(1);

    -- [[ Opening / closing of selection ]]
    if (inBoundsExpand) then
        -- [[ Emitting no drag indication ]]
        UI.emitEvent(ELEMENT_HOVERED);

        if (isMouse1Pressed) then
            self.setIsActive(not self.getIsActive());
        end
    end

    -- [[ Handling icon color ]]
    local targetColor = (self.getIsActive() or inBoundsExpand) and e_UIPrimaryBlueColor or e_UISecondaryWhiteColor;
    local lerpedH, lerpedS, lerpedV = e_lerpHSV(self.getColor(), targetColor, globals.frametime());

    self.getColor().setHSV(lerpedH, lerpedS, lerpedV);

    -- [[ Handling animations ]]
    self.setActiveOpacity(self.getIsActive() and 1 or 0);
end

function e_UISelector:render(posX, posY, UI, remainingSpace)
    if (self.getIsHidden()) then return; end

    local selectedMaxWidth = 130 + ((self.getWidth() - 130) * self.getActiveOpacity());
    local selectedNameWidth, selectedNameHeight, selectedName, selectedNameTable = self.getSelected(selectedMaxWidth,
        self.getActiveOpacity() > UI_OPACITY_BORDERLINE);
    local nameWidth, nameHeight = e_measureText("s", self.getName());

    local spaceX = self.getWidth() - nameWidth;
    local spaceY = self.getHeight() - nameHeight;

    local padding = 5;

    -- [[ Rendering selector name ]]
    e_renderText(posX, posY + spaceY / 2, e_UISecondaryWhiteColor, UI.getAppearOpacity() * 140, "s", false,
        self.getName());

    -- [[ Rendering selected text ]]
    local selectedPosX = posX + self.getWidth() - selectedNameWidth - padding;

    -- [[ Selector is open ]]
    if (self.getActiveOpacity() > 0.1) then
        local stackedSelectionWidth = 0;
        local mousePosX, mousePosY = UI.getMousePosition();
        local isMouse1Pressed = UI.isKeyPressed(1);

        -- [[ Going over each selector element backwards ]]
        for i = #selectedNameTable, 1, -1 do
            local name = selectedNameTable[i];
            local appendix = i == #selectedNameTable and "" or ", ";
            local resultingName = name .. appendix;
            local w, h = e_measureText("s", resultingName);

            -- [[ Updating indentation ]]
            stackedSelectionWidth = stackedSelectionWidth + w;

            local namePosX = posX + self.getWidth() - padding - stackedSelectionWidth;
            local nameColor = self.getSelectedColor(i) or e_UISecondaryWhiteColor;

            -- [[ This should have been done in handle method, but to reduce the unneccessary loops, leaving it here atm ]]
            local isSelected = self.isSelected(i);
            local inBoundsName = e_inBounds(namePosX, posY + spaceY / 2, mousePosX, mousePosY, w, h);

            if (isSelected) then
                local lerpedH, lerpedS, lerpedV = e_lerpHSV(nameColor, e_UIPrimaryBlueColor, globals.frametime());
                nameColor.setHSV(lerpedH, lerpedS, lerpedV);
            end

            if (inBoundsName) then
                -- [[ Emitting no drag indication ]]
                UI.emitEvent(ELEMENT_HOVERED);

                if (isMouse1Pressed) then
                    self.setSelected(i);
                end
            end

            e_renderText(namePosX, posY + spaceY / 2, nameColor, UI.getAppearOpacity() * 140, "s", false,
                resultingName);
        end
    else
        e_renderText(selectedPosX, posY + spaceY / 2, e_UISecondaryWhiteColor, UI.getAppearOpacity() * 140, "s", false,
            selectedName);
    end

    -- [[ Rendering expand / close icon ]]
    local controlIcon = self.getActiveOpacity() < 0.5 and e_selectorExpandIcon or e_selectorCloseIcon;

    local expandIconPosX, expandIconPosY = selectedPosX - controlIcon.getWidth() - padding,
        posY + ((self.getHeight() - controlIcon.getHeight()) / 2);

    e_renderTexture(controlIcon.getTextureId(), expandIconPosX, expandIconPosY, controlIcon.getWidth(),
        controlIcon.getHeight(), self.getColor(), UI.getAppearOpacity() * 200);

    -- [[ Rendering seperator ]]
    e_renderRect(posX, posY + self.getHeight(), self.getWidth(), 1, e_UISecondaryWhiteColor, UI.getAppearOpacity() * 30);

    -- [[ Rendering children, if applicable ]]
    local stackedChildHeight = 0;

    for childIndex, child in pairs(self.getChildren()) do
        -- [[ If specific selection is selected, only then render the children ]]
        -- [[ TODO: Implement animation ]]
        if (self.isSelected(childIndex)) then
            local childPosX, childPosY = posX, posY + (child.getHeight() + stackedChildHeight);
            local updatedRemainingSpace = remainingSpace - child.getHeight();
            local childFits = updatedRemainingSpace >= 0;

            if (childFits) then
                child:handle(childPosX, childPosY, UI, 1);
                child:render(childPosX, childPosY, UI, updatedRemainingSpace);

                stackedChildHeight = stackedChildHeight + child.getHeight() + child.getChildrenHeight();
            else
                --e_hideChildren(child);
            end
        end
    end

    -- [[ Updating child height metric ]]
    self.setChildrenHeight(stackedChildHeight);
end

-- [[ Gamesense db storage wrapper ]]
local storageSetValue, storageGetValue = (function()
    local function setValue(key, value)
        database.write(key, value);
    end

    local function getValue(key)
        return database.read(key)
    end

    return setValue, getValue;
end)();

--[[
    Framework object initialization
]]
local ui_window;

-- [[ Shared menu elements ]]
local ui_iconButtonTest = e_UIIconButton:init(e_saveIcon, 50, 50, function()
    storageSetValue("ENDPOINT_SHARED", ui_window.createConfig());
    ui_window.createInfoNotification("Config successfully saved!");
end);

-- [[ Pre-emptively creating references for script logic, so that they can be modified by menu element cb's ]]
local ragebot;

-- [[ Menu elements ]]
-- [[ RageTab ]]
local ui_manualRollResolverKey = e_UIKey:init(86, UI_KEY_STATE["TOGGLE"], function(active)
    ragebot.rollResolverCycleStage = (ragebot.rollResolverCycleStage + 1) % 3;
end);
local ui_manualRollResolverKeybind = e_UIKeybind:init(ui_window, ui_manualRollResolverKey, "Manual roll resolver",
    UI_CHILD_BLOCK_WIDTH, UI_CHILD_BLOCK_HEIGHT);

local ui_enableDynamicHC = e_UICheckbox:init("Dynamic hitchance", nil, UI_CHILD_BLOCK_WIDTH, UI_CHILD_BLOCK_HEIGHT);

local ui_dynamicFOVMin = e_UISlider:init("Minimum FOV", "°", 0, 180, false, UI_CHILD_BLOCK_WIDTH, UI_CHILD_BLOCK_HEIGHT);
local ui_dynamicFOVMax = e_UISlider:init("Maximum FOV", "°", 0, 180, false, UI_CHILD_BLOCK_WIDTH, UI_CHILD_BLOCK_HEIGHT);
local ui_enableDynamicFOV = e_UICheckbox:init("Dynamic FOV", { ui_dynamicFOVMin, ui_dynamicFOVMax }, UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);

local ui_legitAWScanHitboxes = e_UISelector:init("Scan hitboxes",
    { "Upper arms", "Forearms", "Lower legs", "Feet", "Pelvis" }, nil, true,
    UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);
local ui_legitAWMinVisibleHitboxes = e_UISlider:init("Minimum visible hitboxes", "", 0, 11, false, UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);
local ui_legitAWMinVisibilityTime = e_UISlider:init("Minimum visibility time", "ms", 0, 500, false, UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);

local ui_ragebotSafety = e_UISelector:init("Safety measures", { "Smoke check", "Flash check" }, nil, true,
    UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);

local ui_enemyLethal = e_UISelector:init("Enemy lethal", { "Prioritize", "Prefer body aim", "Safepoint" }, nil, true,
    UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);

-- [[ AATab ]]
local ui_aaPresetsDucking = e_UISelector:init("Preset ducking", { "Dynamic", "Autodirection", "Jitter", "Jiggle" }, nil, false,
    UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);
local ui_aaPresetsAir = e_UISelector:init("Preset air", { "Dynamic", "Autodirection", "Jitter", "Jiggle" }, nil, false,
    UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);
local ui_aaPresetsRunning = e_UISelector:init("Preset running", { "Dynamic", "Autodirection", "Jitter", "Jiggle" }, nil, false,
    UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);
local ui_aaPresetsSlowwalking = e_UISelector:init("Preset slowwalking", { "Dynamic", "Autodirection", "Jitter", "Jiggle" }, nil,
    false,
    UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);
local ui_aaPresetsStanding = e_UISelector:init("Preset standing", { "Dynamic", "Autodirection", "Jitter", "Jiggle" }, nil, false,
    UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);
local ui_aaPresets = e_UISelector:init("Presets", { "Ducking", "In air", "Running", "Slowwalking", "Standing" },
    {
        [1] = ui_aaPresetsDucking,
        [2] = ui_aaPresetsAir,
        [3] = ui_aaPresetsRunning,
        [4] = ui_aaPresetsSlowwalking,
        [5] = ui_aaPresetsStanding
    }, false,
    UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);

local ui_enablePeekReal = e_UICheckbox:init("Prefer real peek", nil, UI_CHILD_BLOCK_WIDTH, UI_CHILD_BLOCK_HEIGHT);

local ui_rollValue = e_UISlider:init("Roll amount", "°", 0, 50, false, UI_CHILD_BLOCK_WIDTH, UI_CHILD_BLOCK_HEIGHT);
local ui_exploitsOptions = e_UISelector:init("Exploit options", { "LBY breaker", "Roll" }, { [2] = ui_rollValue }, true,
    UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);

local ui_enableAntibruteforce = e_UICheckbox:init("Anti-bruteforce", nil, UI_CHILD_BLOCK_WIDTH, UI_CHILD_BLOCK_HEIGHT);
local ui_enableHurtInvertion = e_UICheckbox:init("Hurt invertion", nil, UI_CHILD_BLOCK_WIDTH, UI_CHILD_BLOCK_HEIGHT);

-- [[ visuals tab ]]
local ui_indicatorsColor = e_UIColorpicker:init("Indicators color", e_UIColor:init(209, 61.6 / 100, 98 / 100, 255), nil,
    UI_CHILD_BLOCK_WIDTH,
    UI_CHILD_BLOCK_HEIGHT);

local ui_enableIndicators = e_UICheckbox:init("Enable indicators", { ui_indicatorsColor }, UI_CHILD_BLOCK_WIDTH, UI_CHILD_BLOCK_HEIGHT);

-- [[ misc tab ]]
local ui_openKey = e_UIKey:init(80, UI_KEY_STATE["TOGGLE"], function(active)
    -- Updating menu open state
    ui_window.setIsOpen(active);

    -- Firing UI state callbacks
    ui_window.fireCallbacks(active and MENU_OPEN or MENU_CLOSED);
end);
local ui_openKeybind = e_UIKeybind:init(ui_window, ui_openKey, "Menu open", UI_CHILD_BLOCK_WIDTH, UI_CHILD_BLOCK_HEIGHT);

local ui_menuColor = e_UIColorpicker:init("Menu color", e_UIColor:init(209, 61.6 / 100, 98 / 100, 255), nil,
UI_CHILD_BLOCK_WIDTH,
UI_CHILD_BLOCK_HEIGHT);

-- [[ Tabs ]]
local ui_rageTab = e_UITab:init("Rage", e_ragebotIcon,
    { ui_manualRollResolverKeybind, ui_enableDynamicHC,
        ui_enemyLethal });
local ui_aaTab = e_UITab:init("AA", e_antiAimIcon,
    { ui_aaPresets, ui_enablePeekReal, ui_exploitsOptions, ui_enableAntibruteforce, ui_enableHurtInvertion });
local ui_visualsTab = e_UITab:init("Visuals", e_visualsIcon, { ui_enableIndicators });
local ui_miscTab = e_UITab:init("Misc", e_settingsIcon, { ui_openKeybind, ui_menuColor });

-- [[ Main framework window ]]
ui_window = e_UI:init(UI_WIDTH, UI_HEIGHT, { ui_rageTab, ui_aaTab, ui_visualsTab, ui_miscTab },
    { ui_iconButtonTest });

ui_window.setBoundKey("menu-open-control", ui_openKey);
ui_window.setBoundKey("manual-roll-resolver", ui_manualRollResolverKey);

ui_window.registerCallback(MENU_OPEN, function()
    -- Resetting input states
    resetInputState(inputSystem);
    enableInput(inputSystem, false);
end);

ui_window.registerCallback(MENU_CLOSED, function()
    enableInput(inputSystem, true);
end);

client.set_event_callback("paint_ui", function()
    ui_window:handle();
    ui_window:render();
    ui_window:drag();

    e_UIPrimaryBlueColor = ui_menuColor.getColor();
end);

client.set_event_callback("shutdown", function()
    enableInput(inputSystem, true);
end);

-- [[ Firing initial callbacks ]]
if (ui_window.getIsOpen()) then ui_window.fireCallbacks(MENU_OPEN); end

-- [[ For now, loading default config on start ]]
ui_window.loadConfig(storageGetValue("ENDPOINT_SHARED"));

-- [[ Attach watermark ]]
ui_window.attachWatermark(_G.ep_build, _G.ep_username);

-- [[ Welcome message ]]
--ui_window.createErrorNotification("Fatal error has occured!");
--ui_window.createInfoNotification("Developer build, up to date!");

------------------------------------------- [[ SCRIPT PART ]] ---------------------------------------------------
-- [[ FFI definitions ]]
ffi.cdef [[
    typedef void*(__thiscall* GetClientEntity)(void*, int);
    typedef float(__thiscall* getInnaccuracy)(void*);
]]

local entityListPointer = ffi.cast("void***", client.create_interface("client.dll", "VClientEntityList003")) or
    error("entityListPointer");
local entityList = ffi.cast(ffi.typeof("void***"), entityListPointer) or error("entityList");
local getClientEntity = ffi.cast("GetClientEntity", entityList[0][3]) or error("getClientEntity");

local clientDLL = client.find_signature("client.dll", "\x55\x8B\xEC\x83\xEC\x08\x8B\x15\xCC\xCC\xCC\xCC\x0F\x57") or
    error("client.dll");
local lineGoesThroughSmoke = ffi.cast(ffi.typeof("bool(__thiscall*)(float, float, float, float, float, float, short)"),
    clientDLL) or error("lineGoesThroughSmoke");

local gameRules = ffi.cast("intptr_t**",
        ffi.cast("intptr_t", client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")) + 2)[0] or
    error("gameRules");

-- [[ Skeet references ]]
local skeet = {
    FOV = ui.reference("RAGE", "Other", "Maximum FOV"),
    minimumHC = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
    minimumDMG = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    aimbot = ui.reference("RAGE", "Aimbot", "Enabled"),
    bodyYaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
    bodyPitch = { ui.reference("AA", "Anti-aimbot angles", "Pitch") },
    yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    yaw_jitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
    slowwalk = { ui.reference("AA", "Other", "Slow motion") },
    autowall = ui.reference("RAGE", "Other", "Automatic penetration"),
    dt_enabled = ui.reference("RAGE", "Aimbot", "Double Tap")
}

function vecSubtract(vec1, vec2)
    return { vec1[1] - vec2[1], vec1[2] - vec2[2], vec1[3] - vec2[3] };
end

function vecAdd(vec1, vec2)
    return { vec1[1] + vec2[1], vec1[2] + vec2[2], vec1[3] + vec2[3] };
end

function vecDivideBy(vec1, number)
    return { vec1[1] / number, vec1[2] / number, vec1[3] / number };
end

function vecMultiplyBy(vec1, number)
    return { vec1[1] * number, vec1[2] * number, vec1[3] * number };
end

function vecDotProduct(vec1, vec2)
    return (vec1[1] * vec2[1]) + (vec1[2] * vec2[2]) + (vec1[3] * vec2[3]);
end

function normalizeYaw(angle)
    while (angle < -180) do angle = angle + 360; end
    while (angle > 180) do angle = angle - 360; end
    return angle;
end

function subtractPercentage(number, percentage)
    return (number - ((percentage / 100) * number));
end

function isGrenade(weaponId)
    return ({
        [43] = true,
        [44] = true,
        [45] = true,
        [46] = true,
        [47] = true,
        [48] = true,
        [68] = true
    })[weaponId] or false;
end

function getMoveType(entityIdx)
    return entity.get_prop(entityIdx, "m_MoveType");
end

function angleToVec(position, radius, angles, offset)
    local result = {};
    local rad = (((angles + offset) * math.pi) / 180);

    result[1] = position[1] + math.cos(rad) * radius;
    result[2] = position[2] + math.sin(rad) * radius;
    result[3] = position[3];

    return result;
end

function rotatePoint(origin, point, angle)
    angle = math.rad(angle);

    local qx = origin[1] + math.cos(angle) * (point[1] - origin[1]) - math.sin(angle) * (point[2] - origin[2]);
    local qy = origin[2] + math.sin(angle) * (point[1] - origin[1]) + math.cos(angle) * (point[2] - origin[2]);

    return { qx, qy, origin.z };
end

function getDistanceFromDelta(delta)
    return math.sqrt((math.pow(delta[1], 2) + math.pow(delta[2], 2)) + math.pow(delta[3], 2));
end

function getDistance(vPosOirigin, vPosTarget)
    return getDistanceFromDelta(vecSubtract(vPosOirigin, vPosTarget));
end

function getPerfectAngle(delta)
    return {
        math.deg(-math.atan(delta[3] / math.sqrt(math.pow(delta[1], 2) + math.pow(delta[2], 2)))),
        math.deg(math.atan2(delta[2], delta[1])),
        0
    };
end

function distanceToPoint(vec1, vec2, vec3)
    local d = vecDivideBy(vecSubtract(vec3, vec2), getDistanceFromDelta(vecSubtract(vec3, vec2)));
    local v = vecSubtract(vec1, vec2);
    local t = vecDotProduct(v, d);
    local P = vecAdd(vec2, vecMultiplyBy(d, t));
    return getDistanceFromDelta(vecSubtract(P, vec1));
end

function getVelocity(ent)
    local velocityX, velocityY = entity.get_prop(ent, "m_vecVelocity");
    return math.sqrt(math.pow(velocityX, 2) + math.pow(velocityY, 2));
end

function extrapolate(ent, parameter, ticks)
    local velocity = { entity.get_prop(ent, "m_vecVelocity[0]"), entity.get_prop(ent, "m_vecVelocity[1]"),
        entity.get_prop(ent, "m_vecVelocity[2]") };
    local tickinterval = globals.tickinterval();
    return { parameter[1] + (velocity[1] * tickinterval * ticks), parameter[2] + (velocity[2] * tickinterval * ticks),
        parameter[3] + (velocity[3] * tickinterval * ticks) };
end

function isPeeking(observingEntity, peekingEntity, ticks)
    -- [[ Peeking entity must not be stand-still ]]
    if (getVelocity(peekingEntity) < 5) then
        return false;
    end

    local observingEntityPosition = { entity.get_origin(observingEntity) };
    local peekingEntityPosition = { entity.get_origin(peekingEntity) };

    local startDistance = math.abs(getDistance(observingEntityPosition, peekingEntityPosition));
    local smallestDistance = math.huge;

    -- [[ 'Predicting' distance changes in future ]]
    for tick = 1, ticks do
        local extrapolatedPosition = extrapolate(peekingEntity, peekingEntityPosition, tick);
        local distance = math.abs(getDistance(observingEntityPosition, extrapolatedPosition));

        if (distance < smallestDistance) then
            smallestDistance = distance;
        end

        -- [[ Distance between observing and target entity has decreased ]]
        if (smallestDistance < startDistance) then
            return true;
        end
    end

    return smallestDistance < startDistance;
end

function getEyePosition(ent)
    local m_vecViewOffset = entity.get_prop(ent, "m_vecViewOffset[2]");
    local origin = { entity.get_origin(ent) };

    if (origin[1] == nil or origin[2] == nil or origin[3] == nil or m_vecViewOffset == nil) then
        return { 0, 0, 0 };
    end

    return { origin[1], origin[2], origin[3] + m_vecViewOffset };
end

-- [[ Ragebot storage ]];
local ROLL_OVERRIDE_DISABLED = 0;
local ROLL_OVERRIDE_LEFT = 1;
local ROLL_OVERRIDE_RIGHT = 2;

local LEGIT_AW_MIN_FRACTION = 0.98;

local DYNAMIC_FOV_UPDATE_FREQ = 4;
local DYNAMIC_HC_LOWER_BOUND = 180; -- [[ Weapon accuracy must exceed this number in order to trigger dynamic hc ]]
local DYNAMIC_HC_APPLY = 0;

local FLASH_CHECK_NOT_STORED = -1;
local FLASH_CHECK_FADE_REDUCTION = 50;

local MOVE_TYPE_LADDER = 9;

ragebot = {
    enemies = {}, -- [[ List of alive, non-dormant? enemies ]]
    target = nil, -- [[ Closest target to crosshair ]]
    previousTarget = nil,
    localplayer = entity.get_local_player(),
    rollResolverCycleStage = ROLL_OVERRIDE_DISABLED,
    legitAutowall = {                                -- [[ In order of "Upper arms", "Forearms", "Lower legs", "Feet", "Pelvis" ]]
        { hitboxes = { 15, 17 }, ticks = { 0, 0 } }, -- [[ list of hitboxes for that particular limb group and time in ticks visible ]]
        { hitboxes = { 16, 18 }, ticks = { 0, 0 } },
        { hitboxes = { 9, 10 },  ticks = { 0, 0 } },
        { hitboxes = { 11, 12 }, ticks = { 0, 0 } },
        { hitboxes = { 2 },      ticks = { 0 } },
    },
    legitAutowallTriggered = false,
    currentFOV = 0,
    dynamicHitchanceTriggered = false,
    dynamicHitchanceApplied = false,
    cachedHC = ui.get(skeet.minimumHC),
    previousWeaponIdx = 0,                     -- [[ Used for dynamic hc, to distinguish weapon change ]]
    flashedTimestamp = FLASH_CHECK_NOT_STORED, -- [[ Used for storing the timestamp when we get flashed ]]
    flashCheckTriggered = false,
    smokeGrenades = {},                        -- [[ Table of list of smoke grenade positions {x, y, z} ]]
    enemiesBehindSmoke = {},
    cachedAutowallState = ui.get(skeet.autowall),
    enemiesLethal = {},
    weaponDamage = {
        -- [[ Holds the base damage for each particular weapon for each particular hitgroup, body damage is dependant on kevlar ]]
        [4] = { baseDamage = { body = { 37, 17 }, arms = 14, legs = 22, feet = 22 }, rangeModifier = 0.85 },       -- glock
        [61] = { baseDamage = { body = { 43, 21 }, arms = 17, legs = 26, feet = 26 }, rangeModifier = 0.91 },      -- usps
        [32] = { baseDamage = { body = { 43, 21 }, arms = 17, legs = 26, feet = 26 }, rangeModifier = 0.91 },      -- p2000
        [1] = { baseDamage = { body = { 65, 61 }, arms = 52, legs = 46, feet = 46 }, rangeModifier = 0.82 },       -- deagle
        [64] = { baseDamage = { body = { 107, 99 }, arms = 80, legs = 64, feet = 64 }, rangeModifier = 0.94 },     -- r8
        [63] = { baseDamage = { body = { 38, 29 }, arms = 24, legs = 23, feet = 23 }, rangeModifier = 0.86 },      -- cz-75
        [36] = { baseDamage = { body = { 47, 30 }, arms = 24, legs = 28, feet = 28 }, rangeModifier = 0.9 },       -- p250
        [30] = { baseDamage = { body = { 40, 36 }, arms = 29, legs = 24, feet = 24 }, rangeModifier = 0.79 },      -- tec9
        [3] = { baseDamage = { body = { 39, 36 }, arms = 29, legs = 23, feet = 23 }, rangeModifier = 0.81 },       -- five seven
        [2] = { baseDamage = { body = { 46, 26 }, arms = 21, legs = 28, feet = 28 }, rangeModifier = 0.79 },       -- barrets
        [9] = { baseDamage = { body = { 143, 140 }, arms = 112, legs = 86, feet = 86 }, rangeModifier = 0.99 },    -- awp	
        [13] = { baseDamage = { body = { 37, 29 }, arms = 23, legs = 22, feet = 22 }, rangeModifier = 0.98 },      -- galil			
        [16] = { baseDamage = { body = { 41, 28 }, arms = 24, legs = 24, feet = 23 }, rangeModifier = 0.97 },      -- m4a4
        [60] = { baseDamage = { body = { 47, 28 }, arms = 23, legs = 24, feet = 24 }, rangeModifier = 0.99 },      -- m4a4-s			
        [10] = { baseDamage = { body = { 37, 26 }, arms = 20, legs = 22, feet = 22 }, rangeModifier = 0.96 },      -- famas			
        [39] = { baseDamage = { body = { 37, 37 }, arms = 29, legs = 22, feet = 22 }, rangeModifier = 0.98 },      -- sg 553
        [8] = { baseDamage = { body = { 34, 31 }, arms = 25, legs = 20, feet = 20 }, rangeModifier = 0.98 },       -- aug		
        [40] = { baseDamage = { body = { 109, 93 }, arms = 74, legs = 65, feet = 65 }, rangeModifier = 0.98 },     -- ssg 08		
        [38] = { baseDamage = { body = { 99, 82 }, arms = 65, legs = 59, feet = 59 }, rangeModifier = 0.98 },      -- scar
        [11] = { baseDamage = { body = { 99, 82 }, arms = 65, legs = 59, feet = 59 }, rangeModifier = 0.98 },      -- g3s1	
        [7] = { baseDamage = { body = { 44, 34 }, arms = 27, legs = 26, feet = 26 }, rangeModifier = 0.98 },       -- ak47			
        [24] = { baseDamage = { body = { 42, 27 }, arms = 22, legs = 25, feet = 25 }, rangeModifier = 0.75 },      -- ump			
        [33] = { baseDamage = { body = { 35, 22 }, arms = 18, legs = 21, feet = 21 }, rangeModifier = 0.85 },      -- mp7			
        [17] = { baseDamage = { body = { 35, 20 }, arms = 16, legs = 21, feet = 21 }, rangeModifier = 0.8 },       -- mac 10			
        [34] = { baseDamage = { body = { 32, 19 }, arms = 15, legs = 19, feet = 19 }, rangeModifier = 0.87 },      -- mp9		
        [19] = { baseDamage = { body = { 32, 21 }, arms = 17, legs = 19, feet = 19 }, rangeModifier = 0.86 },      -- p90		
        [26] = { baseDamage = { body = { 33, 21 }, arms = 16, legs = 19, feet = 19 }, rangeModifier = 0.8 },       -- bizon		
        [25] = { baseDamage = { body = { 24, 15 }, arms = 15, legs = 14, feet = 14 }, rangeModifier = 0.7 },       -- Xm1014		
        [29] = { baseDamage = { body = { 37, 28 }, arms = 23, legs = 23, feet = 23 }, rangeModifier = 0.45 },      -- sawed off			
        [27] = { baseDamage = { body = { 35, 26 }, arms = 21, legs = 21, feet = 21 }, rangeModifier = 0.45 },      -- mag7		
        [35] = { baseDamage = { body = { 31, 15 }, arms = 12, legs = 19, feet = 19 }, rangeModifier = 0.7 },       -- nova	
        [14] = { baseDamage = { body = { 39, 31 }, arms = 25, legs = 23, feet = 23 }, rangeModifier = 0.97 },      -- m249	
        [28] = { baseDamage = { body = { 43, 31 }, arms = 24, legs = 26, feet = 26 }, rangeModifier = 0.97 },      -- negev
        [23] = { baseDamage = { body = { 33, 16 }, arms = 16, legs = 20, feet = 19 }, rangeModifier = 0.85 },      -- mp5 s,
        [31] = { baseDamage = { body = { 500, 500 }, arms = 500, legs = 500, feet = 500 }, rangeModifier = 0.55 }, -- zeus
    }
};

--[[
    @ vPosOrigin - position of origin entity
    @ vPosTarget - position of target entity
    @ returns - number (FOV), true / false (indicating whether the FOV is in bounds of ragebot configured FOV)
]]
function ragebot:getFOV(vPosOirigin, vPosTarget)
    -- [[ Subtracting targets position from ours ]]
    local delta = vecSubtract(vPosTarget, vPosOirigin);

    -- [[ Calculating what would be the ideal angle ]]
    local perfectAngle = getPerfectAngle(delta);

    -- [[ Calculating the difference between ideal angle and our current viewangles ]]
    local viewangles = { client.camera_angles() };
    local deltaAngles = {
        math.abs(viewangles[1] - perfectAngle[1]),
        normalizeYaw(math.abs(viewangles[2] - perfectAngle[2])),
        0
    };

    return math.sqrt(math.pow(deltaAngles[1], 2) + math.pow(deltaAngles[2], 2)), true;
end

--[[
    @ accountableConfiguredFOV - boolean, states that closest target must be within the configured ragebot aimbot fov bounds
]]
function ragebot:getTarget(accountConfifuredFOV)
    -- [[ Updating previous target ]]
    if (self.target ~= nil) then
        self.previousTarget = self.target;

        -- [[ Resetting priority for the previous target ]]
        plist.set(self.previousTarget, "High priority", false);
    end

    local closestFOV = math.huge;
    local closestTarget = nil;
    local localplayerPosition = { client.eye_position(self.localplayer) };

    -- [[ Going over all targets ]]
    for i = 1, #self.enemies do
        local enemyIdx = self.enemies[i];

        -- [[ Accounting only for alive & non-dormant enemies ]]
        if (entity.is_alive(enemyIdx) and not entity.is_dormant(enemyIdx)) then
            local enemyPosition = { entity.hitbox_position(enemyIdx, 0) };
            local calculatedFOV = self:getFOV(localplayerPosition, enemyPosition);

            -- [[ We have a potential candidate ]]
            if (closestFOV > calculatedFOV) then
                closestTarget = enemyIdx;
                closestFOV = calculatedFOV;
            end
        end
    end

    if (accountConfifuredFOV) then
        return (self.currentFOV > closestFOV) and closestTarget or nil;
    else
        return closestTarget;
    end
end

--[[
    @ returns - boolean, states whether a new target has been acquired
]]
function ragebot:isNewTarget()
    return self.previousTarget ~= self.target and self.target ~= nil;
end

--[[
    Roll resolver has 3 cycle stages,
    0 - disabled,
    1 - override left,
    2 - override right
]]
function ragebot:handleRollResolver()
    -- [[ We must have a valid target ]]
    if (self.target == nil) then
        return;
    end

    -- [[ Roll resolver is disabled ]]
    if (self.rollResolverCycleStage == ROLL_OVERRIDE_DISABLED) then
        return;
    end

    -- [[ If our target changes, we disable roll resolver ]]
    if (self:isNewTarget()) then
        self.rollResolverCycleStage = ROLL_OVERRIDE_DISABLED;
        return;
    end

    local rollOverrideAmount = self.rollResolverCycleStage == ROLL_OVERRIDE_LEFT and -50 or 50;
    local _, yaw = entity.get_prop(self.target, "m_angRotation");
    local pitch = 89 * ((2 * entity.get_prop(self.target, "m_flPoseParameter", 12)) - 1);

    entity.set_prop(self.target, "m_angEyeAngles", pitch, yaw, rollOverrideAmount);
end

--[[
    @ limbGroups - table of indexes corresponding to that table in ragebot.legitAutowall storage
    @ minVisibibleCount - number, amount of minimum hitboxes before legit autowall should activate
    @ minVisibilityTime - number, minimum amount of visibility time in ms for a hitbox to be added to the list of hitboxes for legit autowall activation
]]
function ragebot:handleLegitAW(limbGroups, minVisibibleCount, minVisibilityTime)
    -- [[ If we don't have a target to scan for, we don't run it ]]
    if (self.target == nil) then
        return false;
    end

    local localPosX, localPosY, localPosZ = client.eye_position(self.localplayer);

    -- [[ Holds the amount of hitboxes that have been visible atleast for the minimum provided time ]]
    local triggeringHitboxCount = 0;
    local tickInterval = globals.tickinterval() * 1000;

    -- [[ Going over all hitboxes for each particular limb group ]]
    for i = 1, #limbGroups do
        local limbGroupIdx = limbGroups[i];
        local storageData = self.legitAutowall[limbGroupIdx];

        for j = 1, #storageData.hitboxes do
            local hitboxToTradeIdx = storageData.hitboxes[j];
            local posX, posY, posZ = entity.hitbox_position(self.target, hitboxToTradeIdx);
            local traceFraction, traceIdx = client.trace_line(self.localplayer, localPosX, localPosY, localPosZ, posX,
                posY, posZ);

            -- [[ If trace fraction is above minimum accepted value or target is hit by trace, its visible to us]]
            if (traceFraction >= LEGIT_AW_MIN_FRACTION or traceIdx == self.target) then
                storageData.ticks[j] = storageData.ticks[j] + 1;
            else
                storageData.ticks[j] = 0;
            end

            -- [[ Checking if hitboxes visible time exceeds minimum requirement in ms ]]
            if (tickInterval * storageData.ticks[j] >= minVisibilityTime) then
                triggeringHitboxCount = triggeringHitboxCount + 1;
            end
        end
    end

    return triggeringHitboxCount >= minVisibibleCount;
end

--[[
    @ minFOV - number, from 0 to 180
    @ maxFOV - number, from minFOV to 180
]]
function ragebot:handleDynamicFOV(minFOV, maxFOV)
    -- [[ If we don't have a target to scan for, we don't run it ]]
    if (self.target == nil) then
        return minFOV;
    end

    -- [[ We don't really need to update it every tick ]]
    if (globals.tickcount() % DYNAMIC_FOV_UPDATE_FREQ ~= 0) then
        return self.currentFOV;
    end

    local localplayerPosition = { client.eye_position(self.localplayer) };
    local targetPosition = { entity.hitbox_position(self.target, 0) };
    local distance = getDistance(localplayerPosition, targetPosition);

    return e_clamp(math.floor((3800 / distance) * (200 * 0.01)), minFOV, maxFOV);
end

--[[
    @ returns - true / false, whether the dynamic hitchance is triggered
]]
function ragebot:handleDynamicHC()
    local weaponIdx = entity.get_player_weapon(self.localplayer);

    -- [[ User changed weapons, we should not run it, but let the configured hc to be cached ]]
    if (self.previousWeaponIdx ~= weaponIdx) then
        self.previousWeaponIdx = weaponIdx;
        return false;
    end

    local rawEntity = getClientEntity(entityList, entity.get_player_weapon(self.localplayer));
    local entity = ffi.cast(ffi.typeof("void***"), rawEntity);
    local weaponInnaccuracy = ffi.cast("getInnaccuracy", entity[0][483]);
    local approximation = 1 / weaponInnaccuracy(entity);

    -- [[ For knifes, grenades it returns inf ]]
    return approximation < math.huge and approximation >= DYNAMIC_HC_LOWER_BOUND;
end

--[[
    @ returns - true / false, whether flash check is triggered
]]
function ragebot:handleFlashCheck()
    local flashDuration = entity.get_prop(self.localplayer, "m_flFlashDuration");

    -- [[ We are not flashed at the moment ]]
    if (flashDuration == 0) then
        self.flashedTimestamp = FLASH_CHECK_NOT_STORED;
        return false;
    end

    -- [[ We are flashed and haven't cached the timestamp ]]
    if (flashDuration ~= 0 and self.flashedTimestamp == FLASH_CHECK_NOT_STORED) then
        self.flashedTimestamp = globals.realtime();
    end

    local timePassedFlashed = globals.realtime() - self.flashedTimestamp;
    local minimumFlashDuration = subtractPercentage(flashDuration, FLASH_CHECK_FADE_REDUCTION); -- [[ Due to testing, we can shoot earlier and the 'flashed' icon will not appear in kill feed ]]

    return minimumFlashDuration > timePassedFlashed;
end

--[[
    @ returns - table of key value pairs of enemies that are behind smoke
]]
function ragebot:handleSmokeCheck()
    -- [[ If certain people were previously behind smoke, we reset them beforehand ]]
    for i = 1, #self.enemiesBehindSmoke do
        plist.set(self.enemiesBehindSmoke[i], "Add to whitelist", false);
    end

    -- [[ Resetting the list of enemies previously behind smoke ]]
    self.enemiesBehindSmoke = {};

    -- [[ If we don't a target, no need of running the function, because all enemies are dormant / dead / out of fov ]]
    if (self.target == nil) then
        return {};
    end

    -- [[ If there are no smokes deployed, don't run it ]]
    if (#ragebot.smokeGrenades == 0) then
        return {};
    end

    local localplayerPosition = { client.eye_position(self.localplayer) };
    local enemiesBehindSmoke = {};

    -- [[ Going over all enemies for each smoke position ]]
    for i = 1, #self.enemies do
        local enemyIdx = self.enemies[i];

        -- [[ Accounting only for alive enemies ]]
        if (entity.is_alive(enemyIdx)) then
            local enemyPosition = { entity.hitbox_position(enemyIdx, 1) };
            local throughSmoke = lineGoesThroughSmoke(localplayerPosition[1], localplayerPosition[2],
                localplayerPosition[3], enemyPosition[1], enemyPosition[2], enemyPosition[3], 1);

            if (throughSmoke) then
                plist.set(enemyIdx, "Add to whitelist", true);
                table.insert(enemiesBehindSmoke, enemyIdx);
            end
        end
    end

    return enemiesBehindSmoke;
end

-- [[ Calculates maximum scaled damage to an enemy ]]
function ragebot:calculateDamage(distance, weaponID, hasArmor, hitgroups)
    -- [[ Holds list of base damage values that can be dealed to an enemy ]]
    local baseDamages = {};
    local baseDamageReference = self.weaponDamage[weaponID];

    -- [[ Not supported weapon ]]
    if (baseDamageReference == nil) then
        return -1;
    end

    -- [[ Going over to calculate provided hitgroups ]]
    for i = 1, #hitgroups do
        local hitgroup = hitgroups[i];
        local hitgroupValue = baseDamageReference.baseDamage[hitgroup];

        -- [[ Need to differentiate between hitgroups that are affected by kevlar ]]
        if (type(hitgroupValue) == "table") then
            hitgroupValue = hitgroupValue[hasArmor and 2 or 1];
        end

        table.insert(baseDamages, hitgroupValue);
    end

    return math.max(unpack(baseDamages)) * (baseDamageReference.rangeModifier ^ (distance / 500));
end

--[[
    @ prioritize - boolean, states whether lethal enemies should be prioritized
    @ preferBaim - boolean, states whether prefer baim should be applied to lethal enemies
    @ preferSafepoint - boolean, states whether safepoint should be applied to lethal enemies
]]
function ragebot:handleLethalCheck(prioritize, preferBaim, preferSafepoint)
    -- [[ If certain people were previously behind smoke, we reset them beforehand ]]
    for enemyIdx, _ in pairs(self.enemiesLethal) do
        plist.set(enemyIdx, "High priority", false);
        plist.set(enemyIdx, "Override prefer body aim", "Off");
        plist.set(enemyIdx, "Override safe point", "Off");
    end

    -- [[ Resetting the list of enemies previously being marked as lethal ]]
    self.enemiesLethal = {};

    local localplayerPosition = { entity.get_origin(self.localplayer) };
    local weaponId = entity.get_prop(entity.get_player_weapon(ragebot.localplayer), "m_iItemDefinitionIndex");

    -- [[ TODO: Calculate active hitgroups based on configured skeet settings ]]
    local activeHitgroups = { "body" };
    local enemiesLethal = {};

    -- [[ Going over all enemies ]]
    for i = 1, #self.enemies do
        local enemyIdx = self.enemies[i];

        -- [[ Not accounting for dead / dormant enemies ]]
        if (entity.is_alive(enemyIdx) and not entity.is_dormant(enemyIdx)) then
            local enemyPosition = { entity.get_origin(enemyIdx) };
            local distance = getDistance(localplayerPosition, enemyPosition);
            local enemyHP = entity.get_prop(enemyIdx, "m_iHealth");
            local enemyArmorValue = entity.get_prop(enemyIdx, "m_ArmorValue");
            local calculatedDamage = self:calculateDamage(distance, weaponId, enemyArmorValue, activeHitgroups);

            -- [[ Enemy is lethal ]]
            if (calculatedDamage > enemyHP) then
                plist.set(enemyIdx, "High priority", prioritize);
                plist.set(enemyIdx, "Override prefer body aim", (preferBaim and "On") or "Off");
                plist.set(enemyIdx, "Override safe point", (preferSafepoint and "On") or "Off");

                enemiesLethal[enemyIdx] = true;
            end
        end
    end

    return enemiesLethal;
end

function ragebot:update()
    -- [[ Updating list of enemies ]]
    self.enemies = entity.get_players(true);

    -- [[ Updating localplayer ]]
    self.localplayer = entity.get_local_player();

    -- [[ Updating target ]]
    self.target = self:getTarget(false);

    -- [[ Updating fov ]]
    self.currentFOV = ui_enableDynamicFOV.getIsActive() and
        self:handleDynamicFOV(ui_dynamicFOVMin.getValue(), ui_dynamicFOVMax.getValue()) or ui.get(skeet.FOV);

    -- [[ Updating legit autowall state ]]
    
    -- [[ Updating dynamic hc ]]
    self.dynamicHitchanceTriggered = ui_enableDynamicHC.getIsActive() and self:handleDynamicHC() or false;

    -- [[ Updating safety checks ]]
    self.enemiesBehindSmoke = ui_ragebotSafety.isSelected(1) and self:handleSmokeCheck() or {};
    self.flashCheckTriggered = ui_ragebotSafety.isSelected(2) and self:handleFlashCheck() or false;

    -- [[ Updating ragebot lethal checks ]]
    local shouldPrioritize = ui_enemyLethal.isSelected(1);
    local shouldPreferBaim = ui_enemyLethal.isSelected(2);
    local shouldSafepoint = ui_enemyLethal.isSelected(3);

    self.enemiesLethal = (shouldPrioritize or shouldPreferBaim or shouldSafepoint) and
        self:handleLethalCheck(shouldPrioritize, shouldPreferBaim, shouldSafepoint) or {};
end

function ragebot:apply()
    -- [[ Prioritizing the closest target ]]
    if (self:isNewTarget()) then
        plist.set(self.target, "High priority", true);
    end

    -- [[ Updating fov only when the menu is closed, so user still can configure it if he chooses not to use dynamic fov ]]
    if (not ui.is_menu_open()) then
        ui.set(skeet.FOV, self.currentFOV);
    end

    -- [[ Updating hc, if dynamic hc option is triggered ]]
    if (self.dynamicHitchanceTriggered) then
        ui.set(skeet.minimumHC, DYNAMIC_HC_APPLY);
        self.dynamicHitchanceApplied = true;
    end

    -- [[ If dynamic hc was applied and currently it's not triggered, we revert changes ]]
    if (self.dynamicHitchanceApplied and not self.dynamicHitchanceTriggered) then
        ui.set(skeet.minimumHC, self.cachedHC);
        self.dynamicHitchanceApplied = false;
    end

    -- [[ Updating aimbot state with regards to safety checks ]]
    ui.set(skeet.aimbot, not self.flashCheckTriggered);
end

-- [[ Anti aim storage ]]
local FREESTANDING_DMG_UNCERTAIN_DIFF = 5; -- [[ If damage based freestanding between both sides is in bounds of this, its interpreted as uncertain ]]
local FREESTANDING_ENV_RADIUS_SKIP = 30;   -- [[ Distance in degrees between each trace ]]
local FREESTANDING_ENV_TRACE_DISTANCE = 256;
local DYNAMIC_DIRECTION_EXTRAPOLATION_TICKS = 17;
local ANTIBRUTE_FORCE_MIN_DELTA = 35;
local ANTIBRUTE_FORCE_UNCERTAIN_DIFF = 5;
local ANTIBRUTE_FORCE_MINIMUM_TIME_DELTA = 0.15;
local STATE_PRESET_NOT_UPDATED = 2;

local AA_STATE_AIR = 1;
local AA_STATE_CROUCH = 2;
local AA_STATE_SLOW = 3;
local AA_STATE_MOVE = 4;
local AA_STATE_FREE = 5;

local antiAim = {
    damageFreestandingValues = { { 30, 90 }, { 30, -90 } }, -- [[ Extension point radius and side from local player position ]]
    freestandingSide = 1,
    dynamicSide = 1,
    side = 1,                   -- [[ Current anti aim invertion state ]]
    isReversed = ui_enablePeekReal.getIsActive(),
    antiBruteForceStorage = {}, -- [[ Stores anti bruteforce entries ]]
    hurtStorage = {},
    lbyBreakerTriggered = false,
    state = AA_STATE_FREE,
    stateToName = {
        [AA_STATE_AIR] = "   AIR",
        [AA_STATE_CROUCH] = "DUCK",
        [AA_STATE_MOVE] = "MOVE",
        [AA_STATE_SLOW] = "SLOW",
        [AA_STATE_FREE] = "FREE",
    },
    stateReferences = {
        [AA_STATE_AIR] = ui_aaPresetsAir,
        [AA_STATE_CROUCH] = ui_aaPresetsDucking,
        [AA_STATE_MOVE] = ui_aaPresetsRunning,
        [AA_STATE_SLOW] = ui_aaPresetsSlowwalking,
        [AA_STATE_FREE] = ui_aaPresetsStanding,
    }
}

--[[ Wrapper method to easily retrieve configured state preset in the menu ]]
function antiAim:getCurrentStateSelection(index)
    return self.stateReferences[self.state].isSelected(index);
end

function antiAim:getBruteForceStorage(entIdx)
    if (entIdx == nil or self.antiBruteForceStorage[entIdx] == nil) then
        return nil;
    end

    return self.antiBruteForceStorage[entIdx];
end

function antiAim:handleLBYBreaker(cmd)
    local weaponId = entity.get_prop(entity.get_player_weapon(ragebot.localplayer), "m_iItemDefinitionIndex");
    local desyncAmount = AAFuncs.get_desync(2);

    -- [[ Disable on nade usage ]]
    if (isGrenade(weaponId)) then
        if cmd.in_attack == 1 or cmd.in_attack2 == 1 then
            return false;
        end
    end

    -- [[ Disable on ladder ]]
    if (getMoveType(ragebot.localplayer) == MOVE_TYPE_LADDER) then return false; end

    -- [[ ]]
    if (math.abs(desyncAmount) < 15 or cmd.chokedcommands == 0) then
        return false;
    end

    cmd.in_forward = 1;
    return true;
end

function antiAim:handleRoll(cmd, value)
    cmd.roll = value;
end

--[[
    @ isReversed - boolean, states whether the freestanding is reverse, e.g. peek real
    @ returns - number, -1 or 1 indicating the calculated side
]]
function antiAim:handleFreestanding(isReversed)
    -- [[ Holds the freestanding data, EL - environment left, ER - environment right, DL - damage left, DR - damage right ]]
    local data = { EL = 0, ER = 0, DL = 0, DR = 0 };
    local localplayerPosition = { client.eye_position(ragebot.localplayer) };
    local viewangles = { client.camera_angles() };
    local sideModifier = isReversed and -1 or 1;

    -- [[ We can't run damage based logic, if we don't have a target ]]
    if (ragebot.target) then
        local targetPosition = { entity.hitbox_position(ragebot.target, 2) };

        -- [[ Going over extension point values ]]
        for i = 1, #self.damageFreestandingValues do
            local currentExtensionValues = self.damageFreestandingValues[i];
            local extendedEyePosition = angleToVec(localplayerPosition, currentExtensionValues[1], viewangles[2],
                currentExtensionValues[2]);
            local _, traceDamage = client.trace_bullet(ragebot.localplayer, extendedEyePosition[1],
                extendedEyePosition[2], extendedEyePosition[3], targetPosition[1], targetPosition[2], targetPosition[3],
                true);

            -- [[ Storing the traced damage ]]
            data[(i == 1) and "DL" or "DR"] = traceDamage;
        end
    end

    -- [[ Check if damage based trace results are not uncertain, in such case, we can already return result ]]
    if (ragebot.target and not e_isBetween(math.abs(data.DL - data.DR), 0, FREESTANDING_DMG_UNCERTAIN_DIFF)) then
        return (data.DL > data.DR) and 1 * sideModifier or -1 * sideModifier;
    end

    -- [[ Otherwise we continue with environment based freestanding ]]
    for i = viewangles[2] - 90, viewangles[2] + 91, FREESTANDING_ENV_RADIUS_SKIP do
        -- [[ Don't trace directly in front of you ]]
        if (i ~= viewangles[2]) then
            local radians = math.rad(i);
            local positionX, positionY, positionZ =
                localplayerPosition[1] + math.cos(radians) * FREESTANDING_ENV_TRACE_DISTANCE,
                localplayerPosition[2] + math.sin(radians) * FREESTANDING_ENV_TRACE_DISTANCE, localplayerPosition[3];

            local traceFraction, _ = client.trace_line(ragebot.localplayer, localplayerPosition[1],
                localplayerPosition[2], localplayerPosition[3], positionX, positionY, positionZ);
            local traceSide = (viewangles[2] > i) and "EL" or "ER";

            -- [[ Appending trace trace fraction ]]
            data[traceSide] = data[traceSide] + traceFraction;
        end
    end

    return (data.ER > data.EL) and 1 * sideModifier or -1 * sideModifier;
end

--[[
    @ isReversed - boolean, states whether the freestanding is reverse, e.g. peek real
    @ returns - number, -1 or 1 indicating the calculated side
]]
function antiAim:handleDynamic(isReversed)
    -- [[ Closest enemy to cursor that is peeking us ]]
    local closestPeekingTarget = nil;
    local closestPeekingFOV = math.huge;
    local localplayerPosition = { client.eye_position(self.localplayer) };

    local sideModifier = isReversed and -1 or 1;

    -- [[ Going over all enemies ]]
    for i = 1, #ragebot.enemies do
        local enemyIdx = ragebot.enemies[i];

        -- [[ Not accounting for dead / dormant enemies ]]
        if (entity.is_alive(enemyIdx) and not entity.is_dormant(enemyIdx)) then
            -- [[ Make sure enemy is peeking us or we are the one peeking ]]
            if (isPeeking(ragebot.localplayer, enemyIdx, DYNAMIC_DIRECTION_EXTRAPOLATION_TICKS) or isPeeking(enemyIdx, ragebot.localplayer, DYNAMIC_DIRECTION_EXTRAPOLATION_TICKS)) then
                local enemyPosition = { entity.hitbox_position(enemyIdx, 0) };
                local calculatedFOV = ragebot:getFOV(localplayerPosition, enemyPosition);

                -- [[ We have a potential candidate ]]
                if (closestPeekingFOV > calculatedFOV) then
                    closestPeekingTarget = enemyIdx;
                    closestPeekingFOV = calculatedFOV;
                end
            end
        end
    end

    -- [[ If we have found closest peeking target, it means either we were peeking him, or he was peeking us ]]
    return (closestPeekingTarget ~= nil) and 1 * sideModifier or -1 * sideModifier;
end

function antiAim:getState(cmd)
    local IN_JUMP = cmd.in_jump == 1;
    local IN_DUCK = cmd.in_duck == 1;
    local IN_LEFT = cmd.in_moveleft == 1;
    local IN_RIGHT = cmd.in_moveright == 1;
    local IN_BACK = cmd.in_back == 1;
    local IN_FORWARD = cmd.in_forward == 1;
    local forwardmove = cmd.forwardmove;
    local sidemove = cmd.sidemove;

    local switch = {
        [AA_STATE_AIR] = function() -- In air
            return IN_JUMP;
        end,
        [AA_STATE_CROUCH] = function() -- Crouching
            return (IN_DUCK) and (forwardmove == 0 and sidemove == 0);
        end,
        [AA_STATE_SLOW] = function() -- Slowwalking
            return (IN_LEFT or IN_RIGHT or IN_BACK or IN_FORWARD) and
                (ui.get(skeet.slowwalk[1]) and ui.get(skeet.slowwalk[2]));
        end,
        [AA_STATE_MOVE] = function() -- Moving
            return (IN_LEFT or IN_RIGHT or IN_BACK or IN_FORWARD) and (getVelocity(ragebot.localplayer) > 5);
        end
    };

    for state = AA_STATE_AIR, AA_STATE_MOVE do
        if (switch[state]()) then
            return state;
        end
    end

    -- [[ If no other state conditions match, return the bare default one ]]
    return AA_STATE_FREE;
end

--[[
    Creates an anti bruteforce entry in the storage
    @ entIdx - number, index of the enemy to create the storage entry for
    @ adjustedSide - number, side to be applied
]]
function antiAim:createABFEntry(entIdx, adjustedSide)
    local time = globals.realtime();

    -- [[ If there is currently an entry for entity, check if enough of time delta has passed for it to be updated ]]
    if (self.antiBruteForceStorage[entIdx] ~= nil
            and e_isBetween(self.antiBruteForceStorage[entIdx].timestamp, time, time + ANTIBRUTE_FORCE_MINIMUM_TIME_DELTA)
        ) then
        return;
    end

    -- [[ Initializing brute force entry, however it's not yet certain that we were not hit instead ]]
    self.antiBruteForceStorage[entIdx] = { side = adjustedSide, timestamp = time };

    client.delay_call(ANTIBRUTE_FORCE_MINIMUM_TIME_DELTA, function()
        -- [[ If withing the brute force time delta, the storage still has this entry, we clear any potentially cached hurt data ]]
        if (self.antiBruteForceStorage[entIdx] ~= nil and self.antiBruteForceStorage[entIdx].timestamp == time) then
            -- [[ Check if the target even has cached hurt data ]]
            if (self.hurtStorage[entIdx] ~= nil and self.hurtStorage[entIdx].cache) then
                self.hurtStorage[entIdx].cache = false;
                self.hurtStorage[entIdx].logic = nil;
            end
        end
    end);

    ui_window.createInfoNotification("Attempting to dodge brute-force from " .. entity.get_player_name(entIdx));
end

--[[
    Must be called on bullet impact event
    @ e - bullet impact event data
]]
function antiAim:handleAntiBruteForce(e)
    local attackerIdx = client.userid_to_entindex(e.userid);
    local impact = { e.x, e.y, e.z };

    -- [[ Don't account for dormant enemies / us not being alive / attacker not being enemy ]]
    if (entity.is_dormant(attackerIdx) or not entity.is_alive(ragebot.localplayer) or not getContains(ragebot.enemies, attackerIdx)) then
        return;
    end

    local localplayerEyePosition = { client.eye_position(ragebot.localplayer) };
    local localplayerHeadPositon = { entity.hitbox_position(ragebot.localplayer, 0) };
    local localplayerPosition = { entity.get_origin(ragebot.localplayer) };
    local viewangles = { client.camera_angles() };

    local attackerPosition = getEyePosition(attackerIdx);

    -- [[ Performing anti brute force evaluation by checking if enemy missed real side or attempted to shoot fake ]]
    local AAExtension = math.abs(AAFuncs.get_desync(1));
    local rotationPoint = angleToVec(localplayerEyePosition, 10, viewangles[2], 0);

    -- [[ Rotating two points around origin that replicate our real head position and fake head position ]]
    local realHeadPostion = rotatePoint(rotationPoint, localplayerPosition, AAExtension * self.side);
    local fakeHeadPosition = rotatePoint(rotationPoint, localplayerPosition, AAExtension * self.side * -1);

    -- [[ Raising rotated points to the same height our real head hitbox position resides ]]
    realHeadPostion[3] = localplayerHeadPositon[3];
    fakeHeadPosition[3] = localplayerHeadPositon[3];

    -- [[ Calculating distance to real / fake rotated point ]]
    local deltaReal = distanceToPoint(realHeadPostion, attackerPosition, impact);
    local deltaFake = distanceToPoint(fakeHeadPosition, attackerPosition, impact);

    -- [[ The bullet most likely was intended for us ]]
    if (deltaReal < ANTIBRUTE_FORCE_MIN_DELTA or deltaFake < ANTIBRUTE_FORCE_MIN_DELTA) then
        -- [[ If the calculation is uncertain whether attacker missed real or shot fake, we lean to the side that fake side was shot ]]
        if (e_isBetween(math.abs(deltaReal - deltaFake), 0, ANTIBRUTE_FORCE_UNCERTAIN_DIFF)) then
            self:createABFEntry(attackerIdx, self.side * -1);
        else
            -- [[ We are certain that fake or real side was shot at ]]
            self:createABFEntry(attackerIdx, (deltaFake > deltaReal) and self.side or self.side * -1);
        end
    end
end

--[[
    Creates hurt entry in the storage
    @ entIdx - number, index of the enemy to create the storage entry for
    @ adjustedSide - number, side to be applied
    @ yawTowardsAttacker - boolean, states whether we were most likely facing the enemy when hurt or likely we were safepointed
]]
function antiAim:createHurtEntry(entIdx, adjustedSide, yawTowardsAttacker, remainingHP, hitInHead)
    local time = globals.realtime();

    -- [[ bullet_impact event occurs between player_hurt ]]
    -- [[ Check if we were actually hurt instead of dodging a bullet ]]
    if (self.antiBruteForceStorage[entIdx] ~= nil
            and e_isBetween(self.antiBruteForceStorage[entIdx].timestamp, time, time + ANTIBRUTE_FORCE_MINIMUM_TIME_DELTA)
        ) then
        -- [[ We were hurt instead, we delete this anti bruteforce entry ]]
        self.antiBruteForceStorage[entIdx] = nil;
        ui_window.createInfoNotification("Brute-force cancelled, hurt instead by " .. entity.get_player_name(entIdx));
    end

    -- [[ If remaining hp is 0 and we were tapped in head, we need to cache and we might have removed incorrect anti bruteforce entry ]]
    if (remainingHP == 0 and hitInHead and not e_isBetween(AAFuncs.get_overlap(), 0.8, 1) and yawTowardsAttacker) then
        self.hurtStorage[entIdx] = { side = adjustedSide, timestamp = time, cache = true, logic = not self.isReversed };
        ui_window.createErrorNotification("Tapped by " .. entity.get_player_name(entIdx) .. ", caching data");

        return;
    end

    -- [[ However, if remaining hp is 0 and we were not hit in head, we clear cached data ]]
    if (remainingHP == 0 and not hitInHead and self.hurtStorage[entIdx] ~= nil and self.hurtStorage[entIdx].cached) then
        self.hurtStorage[entIdx] = nil;
        return;
    end

    -- [[ If we were most likely safepointed, don't cache ]]
    self.hurtStorage[entIdx] = { side = adjustedSide, timestamp = time, cache = false, logic = nil };
    ui_window.createInfoNotification("Attempting to invert side, due to hurt by " .. entity.get_player_name(entIdx));
end

--[[
    Must be called on player hurt event
    @ e - player hurt event data
]]
function antiAim:handlePlayerHurt(e)
    local attackerIdx = client.userid_to_entindex(e.attacker);
    local hurtIdx = client.userid_to_entindex(e.userid);
    local remainingHP = e.health;

    -- [[ Don't account for dormant enemies / us not being alive / attacker not being enemy / us not being hurt ]]
    if (entity.is_dormant(attackerIdx) or not entity.is_enemy(attackerIdx) or hurtIdx ~= ragebot.localplayer) then
        return;
    end

    -- [[ Calculating whether we were most likely facing the enemy or safepointed ]]
    local localplayerPosition = { client.eye_position() };
    local enemyPosition = getEyePosition(attackerIdx);
    local perfectAngle = getPerfectAngle(vecSubtract(enemyPosition, localplayerPosition));
    local ourYaw = ({ client.camera_angles() })[2];

    local yawDifference = math.abs(normalizeYaw(perfectAngle[2] - ourYaw));
    local yawTowardsAttacker = e_isBetween(yawDifference, 0, 30) or e_isBetween(yawDifference, 165, 180);

    self:createHurtEntry(attackerIdx, self.side * -1, yawTowardsAttacker, remainingHP, e.hitgroup == 1);
end

--[[
    Empties stored brute force or hurt data for specific entity
    @ entIdx - number, index of the enemy to empty storage for
    @ emptyBruteForce - boolean, states whether to clear brute force storage
    @ emptyHurt - boolean, states whether to clear hurt storage
]]
function antiAim:emptyEventStorage(entIdx, emptyBruteForce, emptyHurt)
    if (entIdx == nil or (self.antiBruteForceStorage[entIdx] == nil and self.hurtStorage[entIdx] == nil)) then
        return;
    end

    if (self.antiBruteForceStorage[entIdx] ~= nil and emptyBruteForce) then
        self.antiBruteForceStorage[entIdx] = nil;
        ui_window.createInfoNotification("Cleared anti brute-force data for " .. entity.get_player_name(entIdx));
    end

    -- [[ If the data stored is to be cached, we empty only the stored side so that we can perform different initial autodirection logic ]]
    if (self.hurtStorage[entIdx] ~= nil and emptyHurt) then
        if (self.hurtStorage[entIdx].cache) then
            self.hurtStorage[entIdx].side = nil;
        else
            self.hurtStorage[entIdx] = nil;
        end

        ui_window.createInfoNotification("Cleared hurt data for " .. entity.get_player_name(entIdx));
    end
end

function antiAim:getStoredData(entIdx)
    local antiBruteForceData = self.antiBruteForceStorage[entIdx];
    local hurtData = self.hurtStorage[entIdx];

    -- [[ We don't have any data stored for the particular entity ]]
    if (antiBruteForceData == nil and hurtData == nil) then
        return nil;
    end

    if (hurtData == nil and antiBruteForceData ~= nil) then
        return antiBruteForceData.side, nil;
    end

    if (antiBruteForceData == nil and hurtData ~= nil) then
        return hurtData.side, hurtData.logic;
    end

    -- [[ If we have both kinds of data, determine the most recent one ]]
    return (hurtData.timestamp > antiBruteForceData.timestamp) and hurtData.side,
        hurtData.logic or antiBruteForceData.side, nil;
end

--[[
    Performs some shananigans,
    shouldn't probably be called every tick
]]
function antiAim:handleValveServerRollSupport()
    local isValveDs = ffi.cast("bool*", gameRules[0] + 124);

    if isValveDs ~= nil then
        isValveDs[0] = 0;
    end
end

function antiAim:update(cmd)
    local storedDataSide, storedDataLogic = self:getStoredData(ragebot.target);
    local reversedLogic = ui_enablePeekReal.getIsActive();

    -- [[ On target change, clear cached data ]]
    if (ragebot:isNewTarget()) then
        self:emptyEventStorage(ragebot.previousTarget, true, true);

        -- [[ Notification ]]
        if (storedDataLogic ~= nil and storedDataLogic ~= reversedLogic) then
            ui_window.createInfoNotification("Applying inverted logic for " .. entity.get_player_name(ragebot.target));
        end
    end

    -- [[ Updating stored prefered peek logic ]]
    self.isReversed = (storedDataLogic ~= nil) and storedDataLogic or reversedLogic;

    -- [[ Updating freestanding logic ]]
    self.freestandingSide = (self:getCurrentStateSelection(2) and storedDataSide == nil) and
        self:handleFreestanding(self.isReversed) or STATE_PRESET_NOT_UPDATED;
    self.dynamicSide = (self:getCurrentStateSelection(1) and storedDataSide == nil) and
        self:handleDynamic(self.isReversed) or
        STATE_PRESET_NOT_UPDATED;

    -- [[ Updating aa state ]]
    self.state = self:getState(cmd);
end

function antiAim:apply(cmd)
    local tankAA = self:getCurrentStateSelection(4);
    local jitterPresetActive = self:getCurrentStateSelection(3);
    local storedDataSide, storedDataLogic = self:getStoredData(ragebot.target);

    self.side = (storedDataSide ~= nil) and storedDataSide or
        (self.freestandingSide ~= STATE_PRESET_NOT_UPDATED) and self.freestandingSide or
        (self.dynamicSide ~= STATE_PRESET_NOT_UPDATED) and self.dynamicSide or self.side;

    -- [[ Presets ]]
    ui.set(skeet.bodyYaw[2], jitterPresetActive and 4 or (self.side * 180));
    ui.set(skeet.bodyYaw[1], jitterPresetActive and "Jitter" or "Static");

    ui.set(skeet.yaw[2], tankAA and 2 or -12);
    ui.set(skeet.yaw[1], tankAA and "180" or "180");

    ui.set(skeet.yaw_jitter[2], tankAA and 33 or (self.side * 23));
    ui.set(skeet.yaw_jitter[1], tankAA and "Skitter" or "Center");
    
    ui.set(skeet.bodyPitch[2], tankAA and 79 or 0);
    ui.set(skeet.bodyPitch[1], tankAA and "Custom" or "Down");

    ui.set(skeet.bodyYaw[2], tankAA and 34 or (self.side * 127));
    ui.set(skeet.bodyYaw[1], tankAA and "Jitter" or "Static");

    -- [[ Running the lby breaker if applies ]]
    self.lbyBreakerTriggered = (ui_exploitsOptions.isSelected(1)) and self:handleLBYBreaker(cmd) or false;

    -- [[ Applying roll ]]
    if (ui_exploitsOptions.isSelected(2)) then
        self:handleRoll(cmd, ui_rollValue.getValue() * self.side);
    end
end

-- [[ Visuals part ]]
function gradientText(color1, color2, text)
    local r1, g1, b1 = color1.getRGB()
    local r2, g2, b2 = color2.getRGB();

    local a1, a2 = color1.getAlpha(), color2.getAlpha();
    local output = "";

    local len = #text - 1

    local rinc = (r2 - r1) / len;
    local ginc = (g2 - g1) / len;
    local binc = (b2 - b1) / len;
    local ainc = (a2 - a1) / len;

    for i = 1, len + 1 do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i));

        r1 = r1 + rinc;

        g1 = g1 + ginc;
        b1 = b1 + binc;
        a1 = a1 + ainc;
    end

    return output;
end

-- [[ Visuals storage ]]
local indicators = {
    AAExtensionLerp = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
    AASideLerp = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
    LBYLeanLerp = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
    previousAAState = "STAND",
    AAStateLerp = dynamicEasing.new(1 / DYN_EASING_FREQ, DYN_EASING_DAMP, DYN_EASING_REACT, 0),
    TrademarkLeftColor = e_UIColor:init(210, 1.6 / 100, 95.7 / 100, 255),
    TrademarkRightColor = e_UIColor:init(210, 1.6 / 100, 95.7 / 100, 255)
}

function indicators:handle()
    local screenWidth, screenHeight = client.screen_size();
    local centerX, centerY = screenWidth / 2, screenHeight / 2;
    local accentColor = ui_indicatorsColor.getColor();
    local genericColor = e_UIPrimaryWhiteColor;

    -- [[ Rendering above extension bar aa state and lean state ]]
    local aaState = antiAim.stateToName[antiAim.state];

    e_renderText(centerX - 10, centerY + 37 ,accentColor, 255 * self.AAStateLerp:get(), "-", false, aaState);
    e_renderText(centerX - 10, centerY + 15, accentColor, 255 * self.LBYLeanLerp:get(), "-", nil, "LEAN");

    -- [[ Rendering aa extension bar ]]
    local isJitter = antiAim:getCurrentStateSelection(3);
    local extensionRectangleWidth, extensionRectangleHeight = 64, 4;

    -- [[ Extension bar background ]]
    e_renderRect(centerX - extensionRectangleWidth / 2, centerY + 33, extensionRectangleWidth, extensionRectangleHeight,
        e_UIBackgroundColor, 255);

    -- [[ Extension bar ]]
    if (not isJitter) then
        e_renderRect(centerX, centerY + 33 + 1,
            (extensionRectangleWidth - 2) / 2 * self.AAExtensionLerp:get() * self.AASideLerp:get(),
            extensionRectangleHeight - 2, accentColor, 255);
    else
        e_renderRect(centerX, centerY + 33 + 1, (extensionRectangleWidth - 2) / 2 * self.AAExtensionLerp:get(),
            extensionRectangleHeight - 2, accentColor, 255);
        e_renderRect(centerX, centerY + 33 + 1, -((extensionRectangleWidth - 2) / 2 * self.AAExtensionLerp:get()),
            extensionRectangleHeight - 2, accentColor, 255);
    end

    -- [[ Rendering middle screen 'endpoint' trademark ]]
    local trademarkGradient = gradientText(self.TrademarkLeftColor, self.TrademarkRightColor, "concordia");

    e_renderText(centerX, centerY + 27, e_UIPrimaryWhiteColor, 255, "cb", false, trademarkGradient);

    -- [[ Handling animations ]]
    local frametime = globals.frametime();

    self.AAExtensionLerp:update(frametime, e_clamp(math.abs(AAFuncs.get_desync(1)) / 58, 0, 1));
    self.AASideLerp:update(frametime, isJitter and 0 or antiAim.side);
    self.LBYLeanLerp:update(frametime,
        (antiAim.lbyBreakerTriggered or (100 - 100 * AAFuncs.get_overlap()) > 80) and 1 or 0);
    self.AAStateLerp:update(frametime, (aaState ~= indicators.previousAAState) and -10 or 1);

    local lerpedHTL, lerpedSTL, lerpedVTL = e_lerpHSV(self.TrademarkLeftColor, (antiAim.side == -1 or (isJitter and AAFuncs.get_desync(1) < 0)) and accentColor or genericColor, frametime);
    local lerpedHTR, lerpedSTR, lerpedVTR = e_lerpHSV(self.TrademarkRightColor, (antiAim.side == -1 or (isJitter and AAFuncs.get_desync(1) < 0)) and genericColor or accentColor, frametime);

    self.TrademarkLeftColor.setHSV(lerpedHTL, lerpedSTL, lerpedVTL);
    self.TrademarkRightColor.setHSV(lerpedHTR, lerpedSTR, lerpedVTR);

    -- [[ Updating state ]]
    indicators.previousAAState = aaState;
end

function indicators:apply()
    if (ui_enableIndicators.getIsActive()) then
        self:handle();
    end
end

client.set_event_callback("run_command", function()
    ragebot:update();
    ragebot:apply();
end);

client.set_event_callback("net_update_start", function()
    -- [[ Applying roll resolver ]]
    ragebot:handleRollResolver();
end);

client.set_event_callback("setup_command", function(cmd)
    antiAim:update(cmd);
    antiAim:apply(cmd);
end)

client.set_event_callback("paint", function()
    indicators:apply();
end)

-- [[ Handling anti bruteforce ]]
client.set_event_callback("bullet_impact", function(e)
    -- [[ Running anti bruteforce if applies ]]
    if (ui_enableAntibruteforce.getIsActive() and not antiAim:getCurrentStateSelection(3)) then
        antiAim:handleAntiBruteForce(e);
    end
end);

-- [[ Handling hurt ]]
client.set_event_callback("player_hurt", function(e)
    -- [[ Running hurt handler if applies ]]
    if (ui_enableHurtInvertion.getIsActive() and not antiAim:getCurrentStateSelection(3)) then
        antiAim:handlePlayerHurt(e);
    end
end)

-- [[ Handling roll support for valve servers ]]
client.set_event_callback("player_connect_full", function(e)
    client.delay_call(5, function()
        -- [[ We have connected to a server ]]
        if (client.userid_to_entindex(e.userid) == entity.get_local_player()) then
            antiAim:handleValveServerRollSupport();
        end
    end);
end);

-- [[ Handling updation of cached hc ]]
ui.set_callback(skeet.minimumHC, function()
    if (not ragebot.dynamicHitchanceTriggered) then
        ragebot.cachedHC = ui.get(skeet.minimumHC);
    end
end);

-- ui.set_callback(skeet.autowall, function()
--     client.log(ui.is_menu_open())
-- end);

-- [[ Updating list of smoke grenade positions, needed for smoke check ]]
client.set_event_callback("smokegrenade_detonate", function(e)
    if (ui_ragebotSafety.isSelected(1)) then
        local position = { e.x, e.y, e.z };
        table.insert(ragebot.smokeGrenades, position);
    end
end);

-- [[ Removing expired smokes ]]
client.set_event_callback("smokegrenade_expired", function(e)
    for i = 1, #ragebot.smokeGrenades do
        local smokeGrenade = ragebot.smokeGrenades[i];

        if (smokeGrenade[1] == e.x and smokeGrenade[2] == e.y and smokeGrenade[3] == e.z) then
            table.remove(ragebot.smokeGrenades, i);
            break;
        end
    end
end);

-- [[ Lethal flag ]]
client.register_esp_flag("LETHAL", 237, 41, 57, function(entIdx)
    return ragebot.enemiesLethal[entIdx] ~= nil;
end)

-- [[ Roll resolver flag ]]
client.register_esp_flag("-50°", 255, 253, 208, function(entIdx)
    return ragebot.rollResolverCycleStage == ROLL_OVERRIDE_LEFT and entIdx == ragebot.target;
end);

client.register_esp_flag("50°", 255, 253, 208, function(entIdx)
    return ragebot.rollResolverCycleStage == ROLL_OVERRIDE_RIGHT and entIdx == ragebot.target;
end);

-- [[ Legit Autowall triggered flag ]]
client.register_esp_flag("LAW", 255, 253, 208, function(entIdx)
    return ragebot.legitAutowallTriggered and entIdx == ragebot.target;
end)