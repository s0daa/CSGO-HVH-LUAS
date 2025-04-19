local configure_combobox = ui.new_combobox( "Rage", "Other", "ZEUS SWAP",
"Auto",
"Primary",
"Secondary",
"Knife")

local function owo()
    local ouo = ui.get(configure_combobox)
    if ouo == "Auto" then return "slot2;slot1" end
    if ouo == "Primary" then return "slot1" end
    if ouo == "Secondary" then return "slot2" end
    if ouo == "Knife" then return "slot3" end
end

client.set_event_callback('aim_fire', function()
    --Check if you are holding zeus
    local local_player = entity.get_local_player()
    local weapon = entity.get_player_weapon(local_player)
    local itemindex = bit.band(entity.get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)
    if itemindex ~= 31 then return end
    --Swap weapon after zeus fire
    client.exec(owo())
end)