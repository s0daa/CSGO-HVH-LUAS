local ui_back = _G['ui'];
local ui = {};
ui.__index = ui;

function ui:add_callback(func)
    if (type(func) == 'function') then
        self.callbacks[#self.callbacks + 1] = func;
        self:process_callbacks();
    end
    return self;
end

function ui:add_children(children, value)
    if (getmetatable(children) == ui) then
        children = { children };
    end

    for i, child in pairs(children) do
        self.children[#self.children + 1] = {
            obj = child,
            value = value or true
        };
    end
    table.sort(self.children, function(a, b)
        return a.obj:ref() > b.obj:ref();
    end);
    self:process_callbacks();
end

function ui:process_callbacks(visible)
    local callback = function()
        local selfValue = self:get();
        for i = 1, #self.children do
            local child = self.children[i];
            local child_visible = type(child.value) == 'function' and child.value(self) or selfValue == child.value;
            child.obj:set_visible(child_visible);
            if (visible ~= nil) then
                child.obj:set_visible(visible and child_visible);
            end
            if (visible ~= nil) then
                child.obj:process_callbacks(visible and child_visible);
            else
                child.obj:process_callbacks(child_visible);
            end
        end

        for i = 1, #self.callbacks do
            local callback = self.callbacks[i];
            callback();
        end

        for i = 1, #self.events do
            local event = self.events[i];
            local registerValue = type(event.value) == 'function' and event.value(self) or selfValue == event.value;
            if (event.registered ~= registerValue) then
                client[(registerValue and '' or 'un') .. 'set_event_callback'](event.name, event.func);
                event.registered = registerValue;
            end
        end
    end
    local status, err = pcall(function()
        ui_back.get(self:ref());
    end)
    if(not err) then
        self:set_callback(callback);
        callback();
    end
end

function ui:get(i)
    if (self == nil) then
        return
    end
    if (i) then
        return ui_back.get(self.objs[i] or self);
    end

    local ret = {};
    for i = 1, #self.objs do
        local toRet = {};
        pcall(function()
            toRet = { ui_back.get(self.objs[i] or self) };
        end)
        for n = 1, #toRet do
            ret[#ret + 1] = toRet[n];
        end
    end
    return unpack(ret);
end

function ui:register(name, func, value)
    local index = #self.events + 1;
    self.events[index] = { registered = false, name = name, func = func, value = value or true }
    return index;
end

function ui:unregister(index)
    table.remove(self.events, index);
    return self;
end

function ui:compare(val, ignoreCase)
    local selfVal = self:get();
    return (ignoreCase and selfVal:lower() or selfVal) == val;
end

function ui:lower()
    return self:get():lower();
end

function ui:set(...)
    if (not self) then
        return
    end
    local item = type(self) ~= 'number' and self.objs[1] or self;
    if (item) then
        ui_back.set(item, ...);
    end
    return self;
end

function ui:set_index(i, ...)
    if (not self) then
        return
    end
    local item = type(self) ~= 'number' and self.objs[i] or self;
    if (item) then
        ui_back.set(item, ...);
    end
    return self;
end

function ui:update(...)
    local ret = {};
    for i = 1, #self.objs do
        local varargs = { ... };
        if (varargs[i] ~= nil) then
            ret[#ret + 1] = ui_back.update(self.objs[i] or self, varargs[i]);
        end
    end
    return self;
end

function ui:ref(i)
    return i and self.objs[i] or unpack(self.objs);
end

function ui:set_callback(...)
    local ret = {};
    for i = 1, #self.objs do
        local varargs = { ... };
        if (varargs[i] ~= nil) then
            ret[#ret + 1] = ui_back.set_callback(self.objs[i] or self, varargs[i]);
        end
    end
    return self;
end

function ui:set_visible(...)
    local ret = {};
    for i = 1, #self.objs do
        local varargs = { ... };
        if (varargs[i] ~= nil) then
            ret[#ret + 1] = ui_back.set_visible(self.objs[i] or self, varargs[i]);
        end
    end
    return self;
end

function ui:name(i)
    if (i) then
        return ui_back.name(self.objs[i] or self);
    end
    local ret = {};
    if (type(self) == 'number') then
        return ui_back.name(self);
    end
    for i = 1, #self.objs do
        ret[#ret + 1] = ui_back.name(self.objs[i] or self);
    end
    return unpack(ret);
end

-- Inits
local components = {
    'new_button',
    'new_checkbox',
    'new_color_picker',
    'new_combobox',
    'new_hotkey',
    'new_label',
    'new_listbox',
    'new_multiselect',
    'new_slider',
    'new_string',
    'new_textbox',
    'reference'
}

--- Init
---
function ui.new(...)
    return setmetatable({
        objs = { ... },
        children = {},
        callbacks = {},
        events = {}
    }, ui)
end

for i = 1, #components do
    local comp = components[i];
    ui[comp] = function(...)
        local args = { ... };
        local parent = args[1];
        if (getmetatable(parent) == ui) then
            table.remove(args, 1);
        else
            parent = nil;
        end

        --Handle adding of label before color pickers
        local generatedUIs = {};
        if (comp == components[3]) then
            local drawLabel = args[8];
            if (drawLabel) then
                generatedUIs[#generatedUIs + 1] = ui.new(ui_back['new_label'](unpack(args)));
            end
        end

        -- Create our UI Object
        local idx = #generatedUIs + 1;
        generatedUIs[idx] = ui.new(ui_back[comp](unpack(args)));

        if (parent) then
            parent:add_children(generatedUIs);
        end
        return generatedUIs[idx];
    end
end

--- Defaults
local defaults = {
    'is_menu_open',
    'menu_position',
    'menu_size',
    'mouse_position'
}
for i = 1, #defaults do
    local default = defaults[i];
    ui[default] = function(...)
        return ui_back[default](...);
    end
end

setmetatable(ui, { __call = function(_, ...)
    return ui.new(...)
end })

return ui;