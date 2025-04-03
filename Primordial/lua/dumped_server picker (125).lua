local servers_community = {
    ['Heretic | East'] = '74.91.125.35:27015',
    ['Heretic | West'] = '64.94.101.122:27015',
    ['Big Steppa | DM'] = '74.91.124.24:27015',
    ['No Hyper | Scout'] = '192.223.24.31:27015',
    ['No Hyper | AWP'] = '74.91.123.177:27015',
    ['Noble | Mirage Only'] = '135.148.136.239:27015',
    ['Luckys'] = '192.223.26.36:27015',
    ['Doc HVH'] = '74.91.124.40:27015',
    ['Rampage HVH'] = '104.192.227.26:27022',
    ['Profits'] = '135.148.53.7:27015',
    ['Jinx HVH'] = '162.248.93.4:27015',
    ['Cobras HVH'] = '107.175.92.50:27015',
}

local servers_2v2 = {
    ['Solar | 2v2'] = '135.148.53.7:27030; password solar',
    ['Profits | 2v2'] = '135.148.53.7:27018; password profits2v2',
    ['Ace | 2v2'] = '135.148.53.7:27019; password ace2v2',
    ['Arctic | 2v2'] = '135.148.53.7:27017; password arctic2v2',
    ['OG | 2v2'] = 'og2v2.game.nfoservers.com; password OG2v2',
    ['Profits | 5v5'] = '135.148.53.7:27016; password profits5v5',
    ['Gamesense'] = '135.148.53.7:27031; password gamesense',
    ['Gamesense #2'] = '135.148.53.7:27032; password gamesense',
    ['Profits 2v2 | Central'] = 'profits2v2.game.nfoservers.com:27015; password profits2v2',
    ['blackpeople2v2'] = 'csgo.blackpeople.wtf; password blackpeople2v2', -- don't ddos plz. :<
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
        selection = menu.add_selection('picker', 'type', { 'community', '2v2' }),
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