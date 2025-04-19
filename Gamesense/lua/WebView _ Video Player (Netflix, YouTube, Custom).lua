-- Clipboard VGUI System
local a = require("ffi")
local b = client.create_interface("vgui2.dll", "VGUI_System010") or error("Error finding VGUI_System010")
local c = a['cast'](a['typeof']("void***"), b)
local d = {}
local e = { 'typedef unsigned char wchar_t;', 'typedef bool (__thiscall *IsButtonDown_t)(void*, int);', 'typedef int (__thiscall *VirtualKeyToButtonCode)(void*, int);', 'struct inputevent_t { int m_nType, m_nTick, m_nData, m_nData2, m_nData3; };', 'typedef int(__thiscall* getClipboardTextCount)(void*);', 'typedef void(__thiscall* setClipboardText)(void*, const char*, int);', 'typedef void(__thiscall* getClipboardText)(void*, int, const char*, int);' }
local f = { { 'getClipboardTextCount', c[0][7] }, { 'getClipboardText', c[0][11] }, { 'setClipboardText', c[0][9] } }
for g = 1, #e do
    a['cdef'](e[g])
end ;
for g = 1, #f do
    local h = f[g]
    local i = a['cast'](h[1], h[2]) or error(string.format('Could not find %s in VTable', h[1]))
    d[h[1]] = h[3] and a['string'](i(h[4])) or i
end ;
local function getClipboardText()
    local k = d['getClipboardTextCount'](c)
    if k > 0 then
        local l = a['new']("char[?]", k)
        d['getClipboardText'](c, 0, l, k * a['sizeof']("char[?]", k))
        return a['string'](l, k - 1)
    end ;
    return ''
end

local draggable = (function()
    local watermark = {};
    watermark.__index = watermark;
    function watermark.new(name, x, y, w, h)
        local key = 'sam_video_player_' .. name;
        local default = database.read(key) or { x = x, y = y, w = w, h = h };
        local ret = setmetatable(default, watermark);
        client.set_event_callback('shutdown', function()
            database.write(key, { x = ret.x, y = ret.y, w = ret.w, h = ret.h })
        end);
        return ret;
    end

    function watermark.get(self)
        return self.x, self.y, self.w, self.h;
    end

    function watermark.drag(self, listener)
        self.is_menu_open = ui.is_menu_open()
        self.drag_x, self.drag_y = self.mouse_x, self.mouse_y;
        self.mouse_x, self.mouse_y = ui.mouse_position()
        self.was_pressed = self.is_pressed;
        self.is_pressed = client.key_state(0x01);
        self.screenW, self.screenH = client.screen_size();

        if (ui.is_menu_open()) then
            if (not self.was_pressed or self.is_dragging) and
                    self.is_pressed and
                    (self.drag_x and self.drag_x > self.x and self.drag_y > self.y and self.drag_x < (self.x + self.w - 25) and
                            self.drag_y < self.y + self.h - 25) then

                self.is_dragging, self.x, self.y = true,
                math.max(0, math.min(self.screenW - self.w, self.x + self.mouse_x - self.drag_x)),
                math.max(0, math.min(self.screenH - self.h, self.y + self.mouse_y - self.drag_y));
            elseif (not self.is_pressed) then
                self.is_dragging = false;
            end
        end
    end

    function watermark.resize(self)
        if (ui.is_menu_open()) then
            if (not self.was_pressed or self.is_resizing) and
                    self.is_pressed and
                    (self.drag_x and self.drag_x > self.x + self.w - 5 and
                            self.drag_y > self.y + self.h - 5 and
                            self.drag_x < self.x + self.w + 25 and
                            self.drag_y < self.y + self.h + 25) then


                self.is_resizing, self.w, self.h = true,
                math.max(50, math.min(self.screenW, self.w + self.mouse_x - self.drag_x)),
                math.max(50, math.min(self.screenH, self.h + self.mouse_y - self.drag_y));
            elseif (not self.is_pressed) then
                self.is_resizing = false;
            end
        end
    end

    setmetatable(watermark, {
        __call = function(_, ...)
            return watermark.new(...)
        end
    });
    return watermark;
end)();

---@region panorama API Definition
local o_panorama = panorama;
local panorama = o_panorama.open();
local CompetitiveMatchAPI, GameStateAPI, MyPersonaAPI, FriendsListAPI, PartyBrowserAPI, LobbyAPI, PartyListAPI = panorama.CompetitiveMatchAPI, panorama.GameStateAPI, panorama.MyPersonaAPI, panorama.FriendsListAPI, panorama.PartyBrowserAPI, panorama.LobbyAPI, panorama.PartyListAPI
---@regionend panorama API Definition

local view_player = draggable("video_player", 0, 0, 600, 370);

local uix = require 'gamesense/uix';
local menuItems = {
    enable = uix.new_checkbox("LUA", "A", "Video Player Beta");
}

local service = ui.new_combobox("LUA", "A", "Service", "YouTube", "Netflix", "Custom URL");
local link = database.read("youtube_pip") or "dQw4w9WgXcQ";

local function getJS(panel, root)
    return string.format([[
let ytPanel, oUrl = null;

function update(x, y, w, h, url) {
    ytPanel.style.marginLeft = `${x}px`;
    ytPanel.style.marginTop = `${y}px`;
    ytPanel.style.width = `${w}px`;
    ytPanel.style.height = `${h}px`;
    const html = ytPanel.FindChildTraverse("frame");

    if(oUrl != url) {
        html.SetURL(url);
        oUrl = url;
    }
}

return {

    create: function (layout, x, y, w, h) {
        ytPanel = $.CreatePanel("Panel", $.GetContextPanel().FindChildTraverse("%s"), "YouTubePIP");
        if (ytPanel && ytPanel.BLoadLayoutFromString(layout, false, false)) {
            update(x, y, w, h, 'about:blank');
        }
    },

    setVisible: function (unused, visible) {
        if (ytPanel) {
            ytPanel.visible = visible;
        }
    },

    update: update,

    getPanel: function () {
        return ytPanel == null ? 1 : 0;
    },

    destroy: function () {
        if (ytPanel) {
            ytPanel.RemoveAndDeleteChildren();
            ytPanel.DeleteAsync(0);
            ytPanel = null;
        }
    }
};
]], panel), root
end

---@region Video Player Panel
local panels = {
    o_panorama.loadstring(getJS("MainMenuInput", "CSGOMainMenu"))(),
    o_panorama.loadstring(getJS("HudInWorld", "CSGOHud"))(),
}

local VideoPlayer, panelOptions = {}, { 'create', 'destroy', 'update', 'setVisible', 'setURL', 'getPanel' };
for i = 1, #panelOptions do
    local panelOption = panelOptions[i];
    VideoPlayer[panelOption] = function(...)
        local args, ret = { ... }, {};
        for n = 1, #panels, 1 do
            ret[n] = panels[n][panelOption](unpack(args));
        end
        return unpack(ret);
    end
end
---@endregion Video Player Panel

---@region Create Panel
local function getLayout()
    return [[
<root>
    <styles>
        <include src="file://{resources}/styles/csgostyles.css"/>
    </styles>
    <Panel style="height: 100%; width: 100%; background-color: #000;">
        <HTML style="height: 100%; width: 100%;" url="about:blank" id="frame" acceptsinput="true" acceptsfocus="true"
              focusonhover="true" mousetracking="true" allow="autoplay"></HTML>
    </Panel>
</root>
]]
end

VideoPlayer.create(getLayout(), view_player:get());
menuItems.enable:on("change", VideoPlayer.setVisible);
---@endregion Create Panel

local embedLink = "https://www.youtube.com/embed/";

local function getURL()
    if (ui.get(service) == "YouTube") then
        return embedLink .. link;
    elseif (ui.get(service) == "Netflix") then
        return "https://netflix.com/"
    end
    return link;
end

local paste = ui.new_button("LUA", "A", "Paste from clipboard", function()
    link = getClipboardText();
end);

ui.set_callback(service, function()
    ui.set_visible(paste, ui.get(service) ~= "Netflix")
end)

---@region render shit
function renderer.outline(x, y, w, h, r, g, b, a)
    renderer.line(x, y, x + w, y, r, g, b, a);
    renderer.line(x + w, y, x + w, y + h, r, g, b, a);
    renderer.line(x + w, y + h, x, y + h, r, g, b, a);
    renderer.line(x, y + h, x, y, r, g, b, a);
end

local function drawContainer(x, y, w, h)
    if ((CompetitiveMatchAPI.GetCooldownSecondsRemaining() ~= 0 or MyPersonaAPI.IsVacBanned() ~= 0) and not GameStateAPI.IsConnectedOrConnectingToServer()) then
        y = y + 32;
    end

    for i = 0, 6, 1 do
        local c = { 22, 60, 40, 40, 40, 60, 20 }
        renderer.outline(x - i, y - i, w + i * 2, h + i * 2, c[i + 1], c[i + 1], c[i + 1], 255);
    end
    renderer.gradient(x + 1, y, (w / 2) - 2, 2, 59, 175, 222, 255, 202, 70, 205, 255, true);
    renderer.gradient(x + (w / 2) - 1, y, (w / 2) + 1, 2, 202, 70, 205, 255, 221, 227, 78, 255, true);
end

menuItems.enable:on("paint_ui", function()
    if (VideoPlayer.getPanel() == 1) then
        return
    end

    -- Render Skeet Borders
   -- drawContainer(view_player:get());

    -- Update Dragging and Resizing Values
    view_player:drag();
    view_player:resize();

    -- Update Panel
    local x, y, w, h = view_player:get();
    VideoPlayer.update(x, y, w, h, getURL());
end)
---@endregion render shit

client.set_event_callback('shutdown', function()
    VideoPlayer.destroy();
    database.write('youtube_pip', link);
end)