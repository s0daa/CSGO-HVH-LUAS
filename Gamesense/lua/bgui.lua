local KF = require("gamesense/nyx_lua_framework")
local ffi = require("ffi")

-- imports
local function vmt_entry(instance, index, type)
	return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

-- instance is bound to the callback as an upvalue
local function vmt_bind(module, interface, index, typestring)
	local instance = client.create_interface(module, interface) or error("invalid interface")
	local success, typeof = pcall(ffi.typeof, typestring)
	if not success then
		error(typeof, 2)
	end
	local fnptr = vmt_entry(instance, index, typeof) or error("invalid vtable")
	return function(...)
		return fnptr(instance, ...)
	end
end

local get_event_data = vmt_bind("inputsystem.dll", "InputSystemVersion001", 21, "const struct {int m_nType, m_nTick, m_nData, m_nData2, m_nData3;}*(__thiscall*)(void*)")
local button_code_to_string = vmt_bind("inputsystem.dll", "InputSystemVersion001", 40, "const char*(__thiscall*)(void*, int)")

local key_state = {}

local event_types = {
	[0] = "IE_ButtonPressed",
	[1] = "IE_ButtonReleased",
	[2] = "IE_ButtonDoubleClicked",
	[3] = "IE_AnalogValueChanged",
	[100] = "IE_FirstSystemEvent",
	[101] = "IE_ControllerInserted",
	[102] = "IE_ControllerUnplugged",
	[103] = "IE_Close",
	[104] = "IE_WindowSizeChanged",
	[105] = "IE_PS_CameraUnplugged",
	[106] = "IE_PS_Move_OutOfView",
	[200] = "IE_FirstUIEvent",
	[201] = "IE_SetCursor",
	[202] = "IE_KeyTyped",
	[203] = "IE_KeyCodeTyped",
	[204] = "IE_InputLanguageChanged",
	[205] = "IE_IMESetWindow",
	[206] = "IE_IMEStartComposition",
	[207] = "IE_IMEComposition",
	[208] = "IE_IMEEndComposition",
	[209] = "IE_IMEShowCandidates",
	[210] = "IE_IMEChangeCandidates",
	[211] = "IE_IMECloseCandidates",
	[212] = "IE_IMERecomputeModes",
	[213] = "IE_OverlayEvent",
	[1000] = "IE_FirstVguiEvent",
	[2000] = "IE_FirstAppEvent",
	[2001] = "IE_EnteredLeftMainWindow" -- if m_nData is 0 it left, if its 1 it entered
}

local reservedTable = {
	'and', 'break', 'do', 'else', 'elseif', 'end',
	'for', 'function', 'goto', 'if', 'in', 'local', 'not', 'or', 'repeat',
	'return', 'then', 'until', 'while', 'continue'
}

local reservedTable2 = {
	'true', 'false', 'nil'
}

local function contains (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

local stringbyte = string.byte
local stringchar = string.char
local stringsub = string.sub

local function chars(str)
	local strc = {}
	for i = 1, #str do
		table.insert(strc, string.sub(str, i, i))
	end
	return strc
end

local function construct_text(charstr)
	local wordlist = {}
	local temp = ""
	for i=1, #charstr do
		--print(charstr[i])
		local curchar = charstr[i]
		if curchar ~= " " then
			temp = temp..curchar
			--print("CURCHAR: "..curchar)
		else
			table.insert(wordlist, temp.." ")
			--print("INSERTING: "..temp)
			temp = ""
		end
	end

	if temp:len() > 0 then
		table.insert(wordlist, temp)
	end
	return wordlist
end

local function magiclines( str )
	local pos = 1;
	return function()
		if not pos then return nil end
		local  p1, p2 = string.find( str, "\r?\n", pos )
		local line
		if p1 then
			line = str:sub( pos, p1 - 1 )
			pos = p2 + 1
		else
			line = str:sub( pos )
			pos = nil
		end
		return line
	end
end

local last_tick = 0
local last_button = -1
local continues_button = -1

local function get_mousewheel()
	local event_data = get_event_data()
	local state = -1
	if event_data.m_nType == 0 and last_tick ~= event_data.m_nTick then
		state = event_data.m_nData == 112 and 1 or event_data.m_nData == 113 and 0 or -1
		last_tick = event_data.m_nTick
	end
	return state
end

--- @class KeyInput
local KeyInput = {}
local lKeyInputs = {}

--- @return KeyInput
function KeyInput:new()
	local chartable = {}
	return KF.new(self, {chartable = chartable})
end

--- @return void
function KeyInput:__init()
	table.insert(lKeyInputs, self)
end

--- @return void
function KeyInput:capture()
	local event_data = get_event_data()
	local etype = event_types[event_data.m_nType]
	local pressed_key_char = nil
	local pressed_key_int = nil

	if etype == "IE_ButtonPressed" or etype == "IE_ButtonDoubleClicked" then
		pressed_key_char = ffi.string(button_code_to_string(event_data.m_nData))
		pressed_key_int = event_data.m_nData
		if last_tick ~= event_data.m_nTick then
			if pressed_key_int <= 36 and continues_button ~= 83 and continues_button ~= 84 then
				table.insert(self.chartable, pressed_key_char)
			end
			if pressed_key_char == "BACKSPACE" then
				table.remove(self.chartable, #self.chartable)
			end
			last_button = pressed_key_int
		end
		last_tick = event_data.m_nTick
	elseif etype == "IE_ButtonReleased" then
		pressed_key_char = ""
		pressed_key_int = event_data.m_nData
	elseif etype == "IE_KeyCodeTyped" then
		pressed_key_char = ffi.string(button_code_to_string(event_data.m_nData))
		pressed_key_int = event_data.m_nData
		if last_tick ~= event_data.m_nTick then
			if pressed_key_int <= 36 then
				table.insert(self.chartable, pressed_key_char)
			end
			if pressed_key_char == "BACKSPACE" then
				table.remove(self.chartable, #self.chartable)
			end
			continues_button = pressed_key_int
		end
	end

	return etype, pressed_key_char, pressed_key_int
end

KF.class('bob/keyinput', KeyInput)

--- @class Container
local Container = {}
local lContainers = {}

--- @param x number
--- @param y number
--- @param w number
--- @param h number
--- @param outline boolean
--- @param draggable boolean
--- @param resizable boolean
--- @return Container
function Container:new(x, y, w, h, outline, draggable, resizable)
	return KF.new(self, {x=x,y=y,w=w,h=h,outline=outline,draggable=draggable,resizable=resizable,cockblock=false,img=nil})
end

function Container:__init()
	table.insert(lContainers, self)
end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function Container:color(r, g, b, a)
	self.r = r
	self.g = g
	self.b = b
	self.a = a
end

--- @return boolean
function Container:is_inside()
	local mx, my = ui.mouse_position()
	local w, h = (self.x + self.w), (self.y + self.h)

	if mx >= self.x and mx <= w and my >= self.y and my <= h then
		return true
	end
	return false
end

--- @return boolean
function Container:is_inside_resize_element()
	local x, y, w, h = self.x, self.y, self.w, self.h
	if self:is_inside() then
		local btrlx, btrly = x+w-20, y+h-20
		local btrx, btry = x+w, y+h
		local mx, my = ui.mouse_position()

		if mx >= btrlx and mx <= btrx and my >= btrly and my <= btry then
			return true
		end
		return false
	end
	return false
end

--- @return void
function Container:drag()
	local tX, tY = self.x, self.y

	if not ui.is_menu_open() or self.cockblock then
		return tX, tY
	end

	local mouse_down = client.key_state(0x01)
	if mouse_down then
		local X, Y = ui.mouse_position()
		if not self._d then
			if self:is_inside() then
				self.oX, self.oY, self._d = X - self.x, Y - self.y, true
			end
		else
			tX, tY = X - self.oX, Y - self.oY
		end
	else
		self._d = false
	end

	self.x = tX
	self.y = tY
end

--- @param state boolean
--- @return void
function Container:blockResizeAndDrag(state)
	self.cockblock = state or true
end

--- @return void
function Container:resize()
	local mouse_down = client.key_state(0x01)
	if (self:is_inside_resize_element() or self.dragging) and mouse_down and not self.cockblock then
		local x, y, w, h = self.x, self.y, self.w, self.h
		local ax, ay = x+w-10, y+h-10

		local mx, my = ui.mouse_position()
		local addx, addy = mx - ax, my - ay

		--print(ax.. "-"..mx.."="..addx)

		self.w = w + addx
		self.h = h + addy

		self.dragging = self:is_inside_resize_element() and mouse_down
		return
	end
	self.dragging = false
end

--- @param identifier string
--- @return void
function Container:save(identifier)
	local paramTable = {}
	paramTable.x = self.x
	paramTable.y = self.y
	paramTable.w = self.w
	paramTable.h = self.h

	database.write(identifier, paramTable)
end

--- @param identifier string
--- @return void
function Container:load(identifier)
	local paramTable = database.read(identifier) or {}
	self.x = paramTable.x or self.x
	self.y = paramTable.y or self.y
	self.w = paramTable.w or self.w
	self.h = paramTable.h or self.h
end

--- @param type string
--- @param image_path string
--- @param imgw number
--- @param imgh number
--- @return void
function Container:image(type, image_path, imgw, imgh)
	if type == "png" then
		self.img = renderer.load_png(readfile(image_path), imgw, imgh)
	elseif type == "jpg" then
		self.img = renderer.load_jpg(readfile(image_path), imgw, imgh)
	elseif type == "svg" then
		self.img = renderer.load_svg(readfile(image_path), imgw, imgh)
	end
end

--- @param ored number
--- @param ogreen number
--- @param oblue number
--- @param oalpha number
--- @return void
function Container:render(ored, ogreen, oblue, oalpha)
	local x, y, w, h, r, g, b, a = self.x, self.y, self.w, self.h, self.r or 255, self.g or 255, self.b or 255, self.a or 255
	renderer.rectangle(x, y, w, h, r, g, b, a)

	if self.outline then
		renderer.line(x, y, x+w, y, ored, ogreen, oblue, oalpha) -- top
		renderer.line(x, y+h, x+w, y+h, ored, ogreen, oblue, oalpha) -- bot
		renderer.line(x, y, x, y+h, ored, ogreen, oblue, oalpha) --left
		renderer.line(x+w, y, x+w, y+h, ored, ogreen, oblue, oalpha) -- right
	end

	if self.img ~= nil then
		renderer.texture(self.img, x, y, w, h, 255, 255, 255, 255, "r")
	end

	if self.resizable then
		local btrax, btray = x+w-1, y+h-11
		local btrx, btry = x+w-1, y+h-1
		local btrlx, btrly = x+w-11, y+h-1
		renderer.triangle(btrax, btray, btrx, btry, btrlx, btrly, 10, 10, 10, 120)
	end
end

--- @return void
function Container:background()
	if self.resizable then
		self:resize()
	end
	if self.draggable and not self.dragging then
		self:drag()
	end
end

KF.class('bob/container', Container)

--- @class SubContainer
local SubContainer = {}
local lSubContainers = {}

--- @param x number
--- @param y number
--- @param w number
--- @param h number
--- @param outline boolean
--- @param draggable boolean
--- @param resizable boolean
--- @return SubContainer
function SubContainer:new(parent, w, h, outline, draggable, resizable)
	return KF.new(self, {parent=parent,w=w,h=h,outline=outline,draggable=draggable,resizable=resizable,cockblock=false,img=nil})
end

--- @return void
function SubContainer:__init()
	table.insert(lContainers, self)
end

--- @param x number
--- @param y number
--- @return void
function SubContainer:offset(x, y)
	self.ox = x
	self.oy = y
end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function SubContainer:color(r, g, b, a)
	self.r = r
	self.g = g
	self.b = b
	self.a = a
end

--- @return boolean
function SubContainer:is_inside()
	local mx, my = ui.mouse_position()
	local w, h = (self.x + self.w), (self.y + self.h)

	if mx >= self.x and mx <= w and my >= self.y and my <= h then
		return true
	end
	return false
end

--- @return boolean
function SubContainer:is_inside_resize_element()
	local x, y, w, h = self.x, self.y, self.w, self.h
	if self:is_inside() then
		local btrlx, btrly = x+w-20, y+h-20
		local btrx, btry = x+w, y+h
		local mx, my = ui.mouse_position()

		if mx >= btrlx and mx <= btrx and my >= btrly and my <= btry then
			return true
		end
		return false
	end
	return false
end

--- @return void
function SubContainer:drag()
	local tX, tY = self.x, self.y

	if not ui.is_menu_open() or self.cockblock then
		return tX, tY
	end

	local mouse_down = client.key_state(0x01)
	if mouse_down then
		local X, Y = ui.mouse_position()
		if not self._d then
			if self:is_inside() then
				self.oX, self.oY, self._d = X - self.x, Y - self.y, true
			end
		else
			tX, tY = X - self.oX, Y - self.oY
		end
	else
		self._d = false
	end

	self.x = tX
	self.y = tY
end

--- @param state boolean
--- @return void
function SubContainer:blockResizeAndDrag(state)
	self.cockblock = state or true
end

--- @return void
function SubContainer:resize()
	local mouse_down = client.key_state(0x01)
	if (self:is_inside_resize_element() or self.dragging) and mouse_down and not self.cockblock then
		local x, y, w, h = self.x, self.y, self.w, self.h
		local ax, ay = x+w-10, y+h-10

		local mx, my = ui.mouse_position()
		local addx, addy = mx - ax, my - ay

		self.w = w + addx
		self.h = h + addy

		self.dragging = self:is_inside_resize_element() and mouse_down
		return
	end
	self.dragging = false
end

--- @param identifier string
--- @return void
function SubContainer:save(identifier)
	local paramTable = {}
	paramTable.x = self.x
	paramTable.y = self.y
	paramTable.w = self.w
	paramTable.h = self.h

	database.write(identifier, paramTable)
end

--- @param identifier string
--- @return void
function SubContainer:load(identifier)
	local paramTable = database.read(identifier) or {}
	self.x = paramTable.x or self.x
	self.y = paramTable.y or self.y
	self.w = paramTable.w or self.w
	self.h = paramTable.h or self.h
end

--- @param type string
--- @param image_path string
--- @param imgw number
--- @param imgh number
--- @return void
function SubContainer:image(type, image_path, imgw, imgh)
	if type == "png" then
		self.img = renderer.load_png(readfile(image_path), imgw, imgh)
	elseif type == "jpg" then
		self.img = renderer.load_jpg(readfile(image_path), imgw, imgh)
	elseif type == "svg" then
		self.img = renderer.load_svg(readfile(image_path), imgw, imgh)
	end
end

--- @return void
function SubContainer:background()
	if self.resizable then
		self:resize()
	end
	if self.draggable and not self.dragging then
		self:drag()
	end
end

--- @return void
function SubContainer:update()
	self.x = self.parent.x + self.ox
	self.y = self.parent.y + self.oy
end

--- @return void
function SubContainer:normalize()
	if self.parent.h < (self.oy/#lSubContainers) * #lSubContainers-1 then
		self.parent.h = (self.oy/#lSubContainers) * #lSubContainers-1
	end

	if self.parent.w <= self.w + 5 then
		self.parent.w = self.w + 15
	end

	if self.w > self.parent.w then
		self.w = self.parent.w
	end

	if self.h > self.parent.h then
		self.h = self.parent.h
	end
end

--- @param ored number
--- @param ogreen number
--- @param oblue number
--- @param oalpha number
--- @return void
function SubContainer:render(ored, ogreen, oblue, oalpha)
	self:normalize()
	self:update()
	local x, y, w, h, r, g, b, a = self.x, self.y, self.w, self.h, self.r or 255, self.g or 255, self.b or 255, self.a or 255
	renderer.rectangle(x, y, w, h, r, g, b, a)

	if self.outline then
		renderer.line(x, y, x+w, y, ored, ogreen, oblue, oalpha) -- top
		renderer.line(x, y+h, x+w, y+h, ored, ogreen, oblue, oalpha) -- bot
		renderer.line(x, y, x, y+h, ored, ogreen, oblue, oalpha) --left
		renderer.line(x+w, y, x+w, y+h, ored, ogreen, oblue, oalpha) -- right
	end

	if self.img ~= nil then
		renderer.texture(self.img, x, y, w, h, 255, 255, 255, 255, "r")
	end

	if self.resizable then
		local btrax, btray = x+w-1, y+h-11
		local btrx, btry = x+w-1, y+h-1
		local btrlx, btrly = x+w-11, y+h-1
		renderer.triangle(btrax, btray, btrx, btry, btrlx, btrly, 10, 10, 10, 120)
	end
end

KF.class('bob/subcontainer', SubContainer)

--- @class Slider : container
local Slider = {}
local lSliders = {}

--- @param parent Container|SubContainer
--- @param w number
--- @param h number
--- @param header string
--- @param percentage number
--- @param slider_text string
--- @param minPadding number
--- @param center_text boolean
--- @return Slider
function Slider:new(parent, w, h, header, percentage, slider_text, minPadding, absolute, center_text)
	local center_text = center_text or false
	return KF.new(self, {parent = parent, w = w, h = h, header = header, percentage = percentage, slider_text = slider_text, minPadding = minPadding, x = parent.x, y = parent.y, absolute = absolute, center_text=center_text, ox=0, oy=0})
end

function Slider:__init()
	table.insert(lSliders, self)
end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
function Slider:color(r, g, b, a)
	self.r = r
	self.g = g
	self.b = b
	self.a = a
end

--- @param x number
--- @param y number
function Slider:offset(x, y)
	self.ox = x
	self.oy = y
end

--- @return void
function Slider:update()
	self.x = self.parent.x + self.ox
	self.y = self.parent.y + self.oy + self.minPadding

	if self.absolute == false then
		self.w = self.parent.w - self.ox*2
	end
end

--- @return void
function Slider:normalize()
	local header_length, height = renderer.measure_text("c", self.header)

	if self.parent.h < (self.oy/#lSliders) + self.minPadding * #lSliders-1 then
		self.parent.h = (self.oy/#lSliders) + (self.minPadding) * #lSliders-1
	end

	if self.parent.w <= header_length + 5 then
		self.parent.w = header_length + 15
	end

	if self.w > self.parent.w then
		self.w = self.parent.w
	end

	if self.h > self.parent.h then
		self.h = self.parent.h
	end
end

--- @param percentage number
--- @param slider_text string
--- @return void
function Slider:override_percentage(percentage, slider_text)
	self.percentage = percentage
	self.slider_text = slider_text
end

--- @param identifier string
--- @return void
function Slider:save(identifier)
	local paramTable = {}
	paramTable.x = self.x
	paramTable.y = self.y
	paramTable.w = self.w
	paramTable.h = self.h

	database.write(identifier, paramTable)
end

--- @param identifier string
--- @return void
function Slider:load(identifier)
	local paramTable = database.read(identifier) or {}
	self.x = paramTable.x or self.x
	self.y = paramTable.y or self.y
	self.w = paramTable.w or self.w
	self.h = paramTable.h or self.h
end

--- @return void
function Slider:render()
	self:update()
	self:normalize()
	if self.center_text then
		renderer.text(self.x + (self.w/2), self.y - 10, 255, 255, 255, 255, "c", 0, self.header)
	else
		renderer.text(self.x, self.y - 15, 255, 255, 255, 255, "", 0, self.header)
	end
	renderer.rectangle(self.x - 2, self.y - 2, self.w + 2, self.h + 4, 10, 10, 10, 110)
	renderer.rectangle(self.x, self.y, (self.w / 100 * self.percentage - 2), self.h, self.r, self.g, self.b, self.a)
	renderer.text(self.x + self.w / 2 + 2, self.y + 4, 255, 255, 255, 110, "c", 0, string.format("%s", self.slider_text))
end

KF.class('bob/slider', Slider)

--- @class InputBox
local InputBox = {}
local lInputBoxes = {}

--- @param parent Container|SubContainer
--- @param w number
--- @param h number
--- @param minPadding number
--- @param header string
--- @param adaptive boolean
--- @return InputBox
function InputBox:new(parent, w, h, minPadding, header, adaptive)
	return KF.new(self, {parent=parent, w=w, h=h, minPadding=minPadding,header=header,adaptive=adaptive, ox=0, oy=0, inputHandler=KeyInput:new(), isActive=false})
end

--- @return void
function InputBox:__init()
	table.insert(lInputBoxes, self)
end

--- @param x number
--- @param y number
--- @return void
function InputBox:offset(x, y)
	self.ox = x
	self.oy = y
end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
function InputBox:color(r,g,b,a)
	self.r = r
	self.g = g
	self.b = b
	self.a = a
end

--- @return void
function InputBox:normalize()
	if self.parent.h < (self.oy/#lInputBoxes) + self.minPadding * #lInputBoxes-1 then
		self.parent.h = (self.oy/#lInputBoxes) + self.minPadding * #lInputBoxes-1
	end

	if self.parent.w <= self.w + 5 then
		self.parent.w = self.w + 15
	end

	if self.w > self.parent.w then
		self.w = self.parent.w
	end

	if self.h > self.parent.h then
		self.h = self.parent.h
	end
end

--- @return boolean
function InputBox:is_inside()
	local mx, my = ui.mouse_position()
	local w, h = (self.x + self.w), (self.y + self.h)

	if mx >= self.x and mx <= w and my >= self.y and my <= h then
		return true
	end
	return false
end

--- @return void
function InputBox:update()
	self.x = self.parent.x + self.ox
	self.y = self.parent.y + self.oy + self.minPadding
	self:shouldType()
	if self.isActive then
		self.inputHandler:capture()
	end
	self.content = self.inputHandler.chartable
end

--- @return boolean
function InputBox:shouldType()
	if not ui.is_menu_open() then
		self.isActive = false
		return
	end

	local mouse_down = client.key_state(0x01)
	if mouse_down then
		if self:is_inside() then
			self.isActive = true
		else
			self.isActive = false
		end
	end
end

--- @param identifier string
--- @return void
function InputBox:save(identifier)
	local paramTable = {}
	paramTable.x = self.x
	paramTable.y = self.y
	paramTable.w = self.w
	paramTable.h = self.h

	database.write(identifier, paramTable)
end

--- @param identifier string
--- @return void
function InputBox:load(identifier)
	local paramTable = database.read(identifier) or {}
	self.x = paramTable.x or self.x
	self.y = paramTable.y or self.y
	self.w = paramTable.w or self.w
	self.h = paramTable.h or self.h
end

--- @return void
function InputBox:render()
	self:update()
	self:normalize()

	local content = table.concat(self.content, "")

	renderer.text(self.x, self.y - 15, 255, 255, 255, 255, "", 0, self.header)
	renderer.rectangle(self.x - 2, self.y - 2, self.w + 4, self.h + 4, 10, 10, 10, 110)
	renderer.rectangle(self.x, self.y, self.w, self.h, self.r, self.g, self.b, self.a)
	renderer.text(self.x + 2, self.y + 4, 255, 255, 255, 255, "", self.w, content)
end

KF.class('bob/inputbox', InputBox)

--- @class Button
local Button = {}
local lButtons = {}

--- @param parent Container|SubContainer
--- @param w number
--- @param h number
--- @param minPadding number
--- @param text string
--- @param callback function
--- @param togglable boolean
--- @return Button
function Button:new(parent, w, h, minPadding, text, callback, togglable)
	return KF.new(self, {parent=parent,w=w,h=h,minPadding=minPadding,text=text, callback=callback, ran=false,toggled=false, togglable=togglable})
end

--- @return void
function Button:__init()
	table.insert(lButtons, self)
end

--- @param x number
--- @param y number
--- @return void
function Button:offset(x, y)
	self.ox = x
	self.oy = y
end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
function Button:color(r,g,b,a)
	self.r = r
	self.g = g
	self.b = b
	self.a = a
end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
function Button:click_color(r,g,b,a)
	self.cr = r
	self.cg = g
	self.cb = b
	self.ca = a
end

function Button:active_color(r,g,b,a)
	self.tr = r
	self.tg = g
	self.tb = b
	self.ta = a
end

--- @return void
function Button:normalize()
	if self.parent.h < (self.oy) + self.minPadding * #lButtons-1 then
		self.parent.h = (self.oy) + self.minPadding * #lButtons-1
	end

	if self.parent.w <= self.w + self.ox + 5 then
		self.parent.w = self.w + self.ox + 10
	end

	if self.w > self.parent.w then
		self.w = self.parent.w
	end

	if self.h > self.parent.h then
		self.h = self.parent.h
	end
end

--- @return boolean
function Button:is_inside()
	local mx, my = ui.mouse_position()
	local w, h = (self.x + self.w), (self.y + self.h)

	if mx >= self.x and mx <= w and my >= self.y and my <= h then
		return true
	end
	return false
end

--- @return void
function Button:on_press()
	if not self.ran then
		self.ran = true
		self.toggled = not self.toggled
		self.callback()
	end
end

--- @return void
function Button:handle_clicks()
	local mouse_down = client.key_state(0x01)

	if not mouse_down then
		self.ran = false
	end

	self.clicking = mouse_down
	if self:is_inside() and mouse_down then
		self:on_press()
	else
		self.clicking = false
	end
end

--- @return void
function Button:update()
	self.x = self.parent.x + self.ox
	self.y = self.parent.y + self.oy + self.minPadding

	self:handle_clicks()


	if self.clicking then
		self.ar = self.cr or self.r
		self.ag = self.cg or self.g
		self.ab = self.cb or self.b
		self.aa = self.ca or self.a
	else
		self.ar = self.toggled and self.tr or self.r
		self.ag = self.toggled and self.tg or self.g
		self.ab = self.toggled and self.tb or self.b
		self.aa = self.toggled and self.ta or self.a
	end
end

--- @param identifier string
--- @return void
function Button:save(identifier)
	local paramTable = {}
	paramTable.x = self.x
	paramTable.y = self.y
	paramTable.w = self.w
	paramTable.h = self.h

	database.write(identifier, paramTable)
end

--- @param identifier string
--- @return void
function Button:load(identifier)
	local paramTable = database.read(identifier) or {}
	self.x = paramTable.x or self.x
	self.y = paramTable.y or self.y
	self.w = paramTable.w or self.w
	self.h = paramTable.h or self.h
end

--- @return void
function Button:render()
	self:update()
	self:normalize()

	renderer.rectangle(self.x - 2, self.y - 2, self.w + 4, self.h + 4, 10, 10, 10, 110)
	renderer.rectangle(self.x, self.y, self.w, self.h, self.ar, self.ag, self.ab, self.aa)
	renderer.text(self.x + (self.w / 2), self.y + (self.h / 2), 255, 255, 255, 255, "c", self.w, self.text)
end

KF.class('bob/button', Button)

--- @class Label
local Label = {}
local lLabels = {}

--- @param parent Container|SubContainer
--- @param flags string
--- @param maxwidth number
--- @param text string
--- @param minPadding number
--- @return Label
function Label:new(parent, flags, maxwidth, text, minPadding)
	return KF.new(self, {parent=parent, flags=flags, maxwidth=maxwidth, text=text, minPadding=minPadding})
end

--- @return void
function Label:__init()
	table.insert(self, lLabels)
end

--- @param x number
--- @param y number
--- @return void
function Label:offset(x, y)
	self.ox = x
	self.oy = y
end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function Label:color(r, g, b, a)
	self.r = r
	self.g = g
	self.b = b
	self.a = a
end

function Label:update()
	self.x = self.parent.x + self.ox
	self.y = self.parent.y + self.oy
end

--- @return void
function Label:normalize()
	local text_width, text_height = renderer.measure_text(self.flags, self.text)
	if self.parent.h < (self.oy/#lLabels) + self.minPadding * #lLabels-1 then
		self.parent.h = (self.oy/#lLabels) + self.minPadding * #lLabels-1
	elseif self.parent.h < text_height then
		self.parent.h = text_height + 5
	end

	if self.parent.w <= text_width + 5 then
		self.parent.w = text_width + 15
	end
end

--- @return void
function Label:render()
	self:update()
	--self:normalize()
	renderer.text(self.x, self.y, self.r, self.g, self.b, self.a, self.flags, self.maxwidth, self.text)
end

KF.class('bob/label', Label)


--- @class Image
local Image = {}
local lImages = {}

--- @param parent Container|SubContainer
--- @param w number
--- @param h number
--- @param minPadding number
--- @param text string
--- @param callback function
--- @return Button
function Image:new(parent, w, h, minPadding, type, imgpath)
	return KF.new(self, {parent=parent,w=w,h=h,minPadding=minPadding,type=type,image_path=imgpath, img=nil})
end

--- @return void
function Image:__init()
	if self.type == "png" then
		self.img = renderer.load_png(readfile(self.image_path), self.w, self.h)
	elseif self.type == "jpg" then
		self.img = renderer.load_jpg(readfile(self.image_path), self.w, self.h)
	elseif self.type == "svg" then
		self.img = renderer.load_svg(readfile(self.image_path), self.w, self.h)
	end
	table.insert(lImages, self)
end

--- @param x number
--- @param y number
--- @return void
function Image:offset(x, y)
	self.ox = x
	self.oy = y
end

function Image:update()
	self.x = self.parent.x + self.ox
	self.y = self.parent.y + self.oy
end

--- @return void
function Image:normalize()
	if self.parent.h < (self.oy/#lImages) + self.minPadding * #lImages-1 then
		self.parent.h = (self.oy/#lImages) + self.minPadding * #lImages-1
	end

	if self.parent.w <= self.w + 5 then
		self.parent.w = self.w + 15
	end

	if self.w > self.parent.w then
		self.w = self.parent.w
	end

	if self.h > self.parent.h then
		self.h = self.parent.h
	end
end

--- @return void
function Image:render()
	self:update()
	self:normalize()
	renderer.texture(self.img, self.x, self.y, self.w, self.h, 255, 255, 255, 255, "f")
end

KF.class('bob/image', Image)

--- @class Editor
local Editor = {}
local lEditors = {}

--- @field parent Container
--- @field compact boolean
--- @field showlines boolean
--- @field cursor boolean
--- @field context_menu boolean
--- @field executable boolean
--- @field syntax_highlight boolean
--- @return Editor
function Editor:new(parent, compact, showlines, cursor, context_menu, executable, syntax_highlight)
	return KF.new(self, {parent=parent, compact=compact, showlines=showlines, cursor=cursor, context_menu=context_menu, executable=executable, syntax_highlight=syntax_highlight, content={}})
end

--- @return void
function Editor:__init()
	table.insert(lEditors, self)
end

--- @return void
function Editor:loadfile(file_name)
	for line in magiclines(readfile(file_name)) do
		table.insert(self.content, line)
	end
end

--- @return void
function Editor:render()
	local x, y, w, h = self.parent.x, self.parent.y, self.parent.w, self.parent.h

	local char_length, char_height = renderer.measure_text("", "A")
	local space_length = renderer.measure_text("", " ")
	local lines_total = h / char_height - 1


	renderer.line(x + 30, y + 1, x + 30, y+h - 1, 60, 60, 60, 120)
	for i=1, lines_total do
		i = i-1
		renderer.text(x + 2, y + char_height*i + 1, 60, 60, 60, 120, "", 0, i+1)

		local pad = 0
		local text = self.content[i+1] or ""
		local iterator = 1

		local noob = chars(text)
		local constrtext = construct_text(noob)

		for a=1, #constrtext do
			local word = constrtext[a]
			--print(word)
			local r,g,b = 255, 255, 255
			local cleanword = string.match(word, "%w+")
			local text_length = renderer.measure_text("", word)

			if contains(reservedTable, word) or contains(reservedTable, cleanword) then
				r, g, b = 244, 161, 255
				renderer.text(x + 34 + pad, y + char_height*i + 2, r, g, b, 255, "", 0, word)
			elseif contains(reservedTable2, word) or contains(reservedTable2, cleanword) then
				r, g, b = 3, 202, 252
				renderer.text(x + 34 + pad, y + char_height*i + 2, r, g, b, 255, "", 0, word)
			end

			renderer.text(x + 34 + pad, y + char_height*i + 2, r, g, b, 255, "", 0, word)
			pad = pad + text_length + space_length
			iterator = iterator + 1
		end
	end
end

KF.class('bob/editor', Editor)

--[[
local uffja = Container:new(400, 400, 200, 200, true, true, true)
uffja:color(10, 10, 10, 110)

local gayslider = Slider:new(uffja, 100, 10, "GAY", 80, "yeah", 35, false)
gaySlider:color(255, 0, 0, 255)
gaySlider:offset(5, 0)
client.set_event_callback("paint", function ()
	uffja:background()
	uffja:render(255, 0, 0, 255)
	gaySlider:render()
end)
]]--

return {
	Container = Container,
	SubContainer = SubContainer,
	Slider = Slider,
	Editor = Editor,
	KeyInput = KeyInput,
	InputBox = InputBox,
	Button = Button,
	Label = Label,
	Image = Image,

	lContainers = lContainers,
	lSubContainers = lSubContainers,
	lSliders = lSliders,
	lEditors = lEditors,
	lKeyInput = lKeyInputs,
	lInputBoxes = lInputBoxes,
	lButtons = lButtons,
	lLabels = lLabels,
	lImages = lImages,
}