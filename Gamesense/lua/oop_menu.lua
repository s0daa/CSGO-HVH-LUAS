local function CreateMT()
    local MT = {}
    MT.__index = MT
    return MT
end


local CallbackItems = {}

local BaseMT = CreateMT()
function BaseMT.new(name, path, _type, cfg_value)
    local Base = {
        name = name, 
        path = path,
        full_path = name and string.format("%s>%s", path, name) or nil,
        cfg_value = cfg_value,
        type = _type,
    }

    function Base:set_visible(state)
        gui.set_visible(self.full_path or self.path, state)

        if self.call_callbacks_on_set_visible then
            for Callback, _ in pairs(CallbackItems[self.full_path or self.path]) do
                Callback(self:get())
            end
        end
    end

    function Base:add_callback(func, call, on_set_vis)
        if not CallbackItems[self.full_path or self.path] then
            CallbackItems[self.full_path or self.path] = {}
        end
        CallbackItems[self.full_path or self.path][func] = {Item = self, OldValue = self:get()}

        if call then
            func(self:get())
        end
        self.call_callbacks_on_set_visible = on_set_vis
        return func
    end

    function Base:get()
        return self.cfg_value:get_int()
    end

    function Base:set(val)
       self.cfg_value:set_int(tonumber(val))
    end

    function Base:has_updated(Old)
        return self:get() ~= Old
    end
    
    function Base:update_callback_value()
        return self:get()
    end

    function Base:bind_to(other)
        if other.type == self.type then
            other:add_callback(function (value)
                self:set(value)
            end)
        else
            utils.error_print("menu lib. base:bind_to other type differed from self type")
        end
    end

    return setmetatable(Base, BaseMT)
end


local ReferenceMT = CreateMT()
function ReferenceMT.new(path)
    local Base = BaseMT.new(nil, path, "reference")

    Base.Items = {gui.get_config_item(path)}

    function Base:get()        
        if not self.Items[2] then
            return self.Items[1]:get_int()
        else
            local Ret = {}
            for _, Item in pairs(self.Items) do
                table.insert(Ret, Item:get_int())
            end
            return Ret
        end
    end

    function Base:get_combo_items()
        return gui.get_combo_items(self.full_path or self.path)
    end
    function Base:set_combo_items(items)
        return gui.set_combo_items(self.full_path or self.path, items)
    end

    function Base:get_listbox_items()
        return gui.get_listbox_items(self.full_path or self.path)
    end

    function Base:set_listbox_items(items)
        return gui.set_listbox_items(self.full_path or self.path, items)
    end

    function Base:set(value)
        local ValueType = type(value)
        if not self.Items[2] then
            if ValueType == "table" then
                error("menu lib. reference:set value type differed from reference type")
            end
            -- need to do this or api freaks out
            local IntValue = ValueType == "boolean" and (value == true and 1 or 0) or tonumber(value)

            self.Items[1]:set_int(IntValue)
        else
            if ValueType ~= "table" then
                error("menu lib. reference:set value type differed from reference type")
            end
            for i, v in pairs(value) do
                if not self.Items[i] then
                    error("menu lib. reference:set reference index does not exist: %s", i)
                end
                -- need to do this or api freaks out
                local IntValue = type(v) == "boolean" and (v == true and 1 or 0) or tonumber(v)

                self.Items[i]:set_int(IntValue)
            end
        end
    end

    function Base:has_updated(Old)     
        if not self.Items[2] then
            return self:get() ~= Old
        else
            for i, Item in pairs(self.Items) do
                if Item:get_int() ~= Old[i] then
                    return true, i
                end
            end
            return false
        end
    end
    
    function Base:update_callback_value()
        return self:get()
    end

    return setmetatable(Base, ReferenceMT)
end

local CheckboxMT = CreateMT()
function CheckboxMT.new(name, path)
    local Base = BaseMT.new(name, path, "checkbox", gui.add_checkbox(name, path))

    function Base:get()
        return self.cfg_value:get_bool()
    end

    function Base:set(val)
        if type(val) ~= "boolean" then
            error("menu lib. checkbox:set value must be a boolean")
        end
        self.cfg_value:set_bool(val)
     end

    return setmetatable(Base, CheckboxMT)
end

local SliderMT = CreateMT()
function SliderMT.new(name, path, min, max, step)
    local Base = BaseMT.new(name, path, "slider", gui.add_slider(name, path, min, max, step))
    return setmetatable(Base, SliderMT)
end

local ComboMT = CreateMT()
function ComboMT.new(name, path, items)
    local Base = BaseMT.new(name, path, "combo", gui.add_combo(name, path, items))

    Base.items = items

    function Base:get_items()
        self.items = gui.get_combo_items(self.full_path)
        return self.items
    end

    function Base:set_items(items)
        Base.items = items
        gui.set_combo_items(self.full_path, self.items)
    end

    return setmetatable(Base, ComboMT)
end

local MultiComboMT = CreateMT()
function MultiComboMT.new(name, path, items)
    local Base = BaseMT.new(name, path, "multi-combo")

    Base.cfg_values = {gui.add_multi_combo(name, path, items)}
    Base.items      = items

    function Base:get()
        local Ret = {}
        for _, CfgValue in pairs(self.cfg_values) do
            table.insert(Ret, CfgValue:get_bool())
        end
        return Ret
    end

    function Base:set(values)
        if type(values) ~= "table" then
            error("menu lib. multi_combo:set value type must be a table")
        end

        for i, val in pairs(values) do
            if not self.cfg_values[i] then
                error("menu lib. multi_combo:set index does not exist: %s", i)
            end
            if type(val) ~= "boolean" then
                error("menu lib. multi_combo:set value must be a boolean")
            end
            self.cfg_values[i]:set_bool(val)
        end
    end

    function Base:has_updated(Old)
        for i, CfgItem in pairs(self.cfg_values) do
            if Old[i] == nil then
                return true, i
            end

            if CfgItem:get_bool() ~= Old[i] then
                return true, i
            end
        end
        return false
    end


    function Base:at(idx)
        if type(idx) == "string" then
            for ItemIndex, ItemName in pairs(Base.items) do
                if ItemName == idx then
                    idx = ItemIndex
                    break
                end
            end
        end

        if not self.cfg_values[idx] then
            return nil
        end
        return self.cfg_values[idx]:get_bool()
    end


    return setmetatable(Base, MultiComboMT)
end

local ButtonMT = CreateMT()
function ButtonMT.new(name, path, callback, confirm)
    local Base = BaseMT.new(name, path, "button")
    
    Base.is_confirm = confirm ~= nil
    Base.get = nil
    Base.set = nil
    Base.add_callback = nil
    Base.has_updated = nil
    Base.update_callback_value = nil

    if Base.is_confirm then
        if info.fatality.allow_insecure then
            -- try a nuch of times to make a spaced name (this is so we can have multiple confirm ones in one spot)
            for i = 1, 50 do
                local rep = (" "):rep(i)
                local ConfirmName = string.format("%s%s%s", rep, "Confirm", rep)
                local CancelName = string.format("%s%s%s", rep, "Cancel", rep)

                local ConfirmPath   = string.format("%s>%s", path, ConfirmName)
                local CancelPath    = string.format("%s>%s", path, CancelName)

                -- pcall this until it doesnt error (the error will be "control id is already in use")
                local s, res = pcall(gui.add_button, ConfirmName, path, function ()
                    callback()
                    gui.set_visible(ConfirmPath, false)
                    gui.set_visible(CancelPath, false)
                    gui.set_visible(Base.full_path, true)
                end)
                if s then
                    gui.add_button(CancelName, path, function ()
                        gui.set_visible(ConfirmPath, false)
                        gui.set_visible(CancelPath, false)
                        gui.set_visible(Base.full_path, true)
                    end)

                    Base.confirm_path   = path .. ConfirmName
                    Base.cancel_path    = path .. CancelName
                    gui.set_visible(ConfirmPath, false)
                    gui.set_visible(CancelPath, false)
                    
                    gui.add_button(name, path, function ()
                        gui.set_visible(ConfirmPath, true)
                        gui.set_visible(CancelPath, true)
                        gui.set_visible(Base.full_path, false)
                    end)

                    Base.set_visible = function(self, state)
                        gui.set_visible(ConfirmPath, false)
                        gui.set_visible(CancelPath, false)
                        gui.set_visible(Base.full_path, state)
                    end
                    break
                end
            end
        else
            utils.error_print("Cannot create confirmable button without \"Allow unsafe scripts\" on")
        end
    else
        gui.add_button(name, path, callback)
    end


    return setmetatable(Base, ButtonMT)
end

local TextboxMT = CreateMT()
function TextboxMT.new(name, path)
    local Base = BaseMT.new(name, path, "textbox", gui.add_textbox(name, path))
    
    function Base:get()
        return self.cfg_value:get_string()
    end

    function Base:set(str)
        self.cfg_value:set_string(tostring(str))
    end

    return setmetatable(Base, TextboxMT)
end

local ListboxMT = CreateMT()
function ListboxMT.new(name, path, items_to_show, search_bar, items)
    local Base = BaseMT.new(name, path, "listbox", gui.add_listbox(name, path, items_to_show, search_bar, items))
    
    Base.items = items

    function Base:get_items()
        self.items = gui.get_listbox_items(self.full_path)
        return self.items
    end

    function Base:set_items(items)
        self.items = items 
        gui.set_listbox_items(self.full_path, self.items)
    end

    return setmetatable(Base, ListboxMT)
end

local KeybindMT = CreateMT()
function KeybindMT.new(item)
    local path = type(item) == "table" and (item.full_path or item.path or "") or item
    local Base = BaseMT.new(nil, path, "keybind", gui.add_keybind(path))

    Base.get = nil
    Base.set = nil
    Base.add_callback = nil
    Base.has_updated = nil
    Base.update_callback_value = nil

    function Base:get_info()
        return gui.get_keybind(self.path)
    end

    return setmetatable(Base, KeybindMT)
end

local ColorpickerMT = CreateMT()
function ColorpickerMT.new(item, alpha_bar, default_color)
    local path = type(item) == "table" and (item.full_path or item.path or "") or item
    local Base = BaseMT.new(nil, path, "color picker", gui.add_colorpicker(path, alpha_bar == nil and true or alpha_bar, default_color or render.color("#FFFFFF")))

    function Base:get()
        return self.cfg_value:get_color()
    end

    function Base:set(color)
        self.cfg_value:set_color(color)
    end

    function Base:has_updated(Old)
        local self_color = self:get()
        return self_color.r ~= Old.r or self_color.g ~= Old.g or self_color.b ~= Old.b or self_color.a ~= Old.a
    end

    return setmetatable(Base, ColorpickerMT)
end

utils.new_timer(0.3, function()
    for FullPath, Callbacks in pairs(CallbackItems) do
        for Callback, Inst in pairs(Callbacks) do
            local HasUpdated, Other = Inst.Item:has_updated(Inst.OldValue)
            if HasUpdated then
                Inst.OldValue = Inst.Item:update_callback_value()
                Callback(Inst.OldValue, Other)
            end
        end
    end
end):start()

return 
{
    add_checkbox    = CheckboxMT.new,
    add_slider      = SliderMT.new,
    add_combo       = ComboMT.new,
    add_multi_combo = MultiComboMT.new,
    add_button      = ButtonMT.new,
    add_textbox     = TextboxMT.new,
    add_listbox     = ListboxMT.new,
    add_keybind     = KeybindMT.new,
    add_colorpicker = ColorpickerMT.new,
    get_reference   = ReferenceMT.new,
}