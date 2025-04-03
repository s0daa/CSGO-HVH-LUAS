local servers_community = {
    ['NeonHvH | Mirage Only'] = '188.212.101.13:27015',
    ['10fps | Mirage/Office Only'] = '89.40.104.214:27015',
    ['GalaxyHvh | Mirage Only'] = '89.40.104.225:27015',
    ['AccuracyHvh  | Snow Maps'] = '45.153.88.95:27015',
    ['Bratva | HvH'] = '93.114.82.136:27015',
    ['InframeHvH | MM HvH'] = '89.40.104.203:27015',
    ['Dynamite | Multiple Maps'] = '89.40.104.208:27015',
    ['VoidHvH | MM HvH'] = '89.40.104.204:27015',
    ['Neptun | Multiple Maps'] = '89.40.104.202:27015',
    ['1Tap | MM HvH'] = '45.153.88.108:27015',
    ['Zwix | MM HvH'] = '188.212.100.206:27015',
}

local servers_2v2 = {
    ['Aztecs #1| 2v2'] = '=94.250.219.121:27015;password aztecs2v2',
    ['Aztecs #2 | 2v2'] = '=94.250.219.168:27015;password aztecs2v2',
    ['Aztecs #3 | 2v2'] = '=54.37.94.51:27015;password aztecs2v2',
    ['Aztecs #4'] = '54.38.216.187:27015;password aztecs2v2',
    ['Neon | 2v2'] = '188.212.100.183:27015; password neon1v1',
    ['Reformed | 2v2'] = '94.250.213.91:27015; password reformed2v2',
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