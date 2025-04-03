---@diagnostic disable: undefined-global
local ctx = {
    clipboard = require('neverlose/clipboard'),
    base64 = require('neverlose/base64'),

    tabs = {
        ['Ragebot'] = ui.find("Aimbot", "Ragebot"),
        ['Anti Aim'] = ui.find("Aimbot", "Anti Aim"),
        ['Legitbot'] = ui.find("Aimbot", "Legitbot"),
        ['Players'] = ui.find("Visuals", "Players"),
        ['World'] = ui.find("Visuals", "World"),
        ['Inventory'] = ui.find("Visuals", "Inventory"),
        ['Main'] = ui.find("Miscellaneous", "Main")
    },

    all_tabs = {},
    create_menu = function(self)
        for k, _ in pairs(self.tabs) do
            table.insert(self.all_tabs, k)
        end
        table.sort(self.all_tabs)

        local group = ui.create('OG LEAKS')
        self.list = group:listable('Tabs', self.all_tabs)

        group:button('Export', function() return self:export_data() end)
        group:button('Import', function() return self:import_data() end)
    end,

    export_data = function(self)
        local data = {}

        for i = 1, #self.all_tabs do
            local selected_tabs = self.all_tabs[self.list:get()[i]]
            if selected_tabs then
                data[selected_tabs] = self.tabs[selected_tabs]:export()
            end
        end

        self.clipboard.set(self.base64.encode(json.stringify(data)))
    end,

    import_data = function(self)
        local success, converted_data = pcall(function()
            local data = self.clipboard.get()
            local from_json = json.parse(self.base64.decode(data))
            return from_json
        end)

        if not success then
            print_error('Your config is broken! Try to copy config again!')
            print_dev('Your config is broken! Try to copy config again!')
            return
        end

        for k, v in pairs(converted_data) do
            local elements = self.tabs[k]
            for i = 1, #self.all_tabs do
                if self.all_tabs[self.list:get()[i]] == k then
                    print(self.all_tabs[self.list:get()[i]], k)
                    elements:import(v)
                end
            end
        end
    end
}

ctx:create_menu()