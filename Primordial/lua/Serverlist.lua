local servers_community = {
    ['InfinityHVH 16k'] = '74.91.113.70:27015',
}

local servers_2v2 = {
    ['InfinityHVH xvx'] = '74.91.112.187:27015',
}

local servercomm_names = {}

local server2v2_names = {}

for k, v in pairs(servers_community) do
    table.insert(servercomm_names, k)
end

for k, v in pairs(servers_2v2) do
    table.insert(server2v2_names, k)
end

local ref = {
    master = menu.add_checkbox('picker', 'enable', false),
    items = {
        selection = menu.add_selection('picker', 'type', { 'community', '1v1/2v2' }),
        picker = menu.add_list('picker', 'servers', servercomm_names),
    }
}

local function connect(name, ip)
    client.log_screen('Connecting to ' .. name .. ' [' .. ip .. '] ')
    engine.execute_cmd('connect ' .. ip)
end

local function SetVisibility(table, condition)
    for k, v in pairs(table) do
        if (type(v) == 'table') then
            for j, i in pairs(v) do
                i:set_visible(condition)
            end
        else 
            v:set_visible(condition)
        end
    end
end

local function on_button()
    local selection = ref.items.selection:get()

    local name = ref.items.picker:get_item_name(ref.items.picker:get())
    connect(name, selection == 1 and servers_community[name] or servers_2v2[name])
end

local button = menu.add_button('picker', 'connect', on_button)

callbacks.add(e_callbacks.PAINT, function()
    local toggle = ref.master:get()
    local selection = ref.items.selection:get()

    SetVisibility(ref.items, toggle)
    button:set_visible(toggle)

    ref.items.picker:set_items(selection == 1 and servercomm_names or server2v2_names)
end)