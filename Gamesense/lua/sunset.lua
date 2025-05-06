local Settings = {
    MasterSwitch = ui.new_checkbox("Visuals", "Effects", "Cascade lighting override"),
    Enable = ui.new_checkbox("Visuals", "Effects", "    Enable"),
    Direction_X = ui.new_slider("Visuals", "Effects", "    X axis", -180, 180, 50, true, "°"),
    Direction_Y = ui.new_slider("Visuals", "Effects", "    Y axis", -180, 180, 43, true, "°"),
    -- Direction_Z = ui.new_slider("Visuals", "Effects", "    Z axis", -180, 180, 0, true, "°"),
}

local MapConfig = {
    ["de_mirage"] = {false, 12, 27}
}

local cl_csm_rot_override = cvar["cl_csm_rot_override"]
local cl_csm_rot_x = cvar["cl_csm_rot_x"]
local cl_csm_rot_y = cvar["cl_csm_rot_y"]
-- local cl_csm_rot_z = cvar["cl_csm_rot_z"]

ui.set_visible(Settings.Enable, false)
ui.set_visible(Settings.Direction_X, false)
ui.set_visible(Settings.Direction_Y, false)
--ui.set_visible(Settings.Direction_Z, false)

ui.set_callback(Settings.MasterSwitch, function(self)
    cl_csm_rot_override:set_raw_int(ui.get(self) and ui.get(Settings.Enable) and 1 or 0)
    ui.set_visible(Settings.Enable, ui.get(self))
    ui.set_visible(Settings.Direction_X, ui.get(self))
    ui.set_visible(Settings.Direction_Y, ui.get(self))
    -- ui.set_visible(Settings.Direction_Z, ui.get(self))
end)

local function SaveMapConfig()
    local mapname = globals.mapname()
    if mapname == nil then return end

    MapConfig[mapname] = {ui.get(Settings.Enable), ui.get(Settings.Direction_X), ui.get(Settings.Direction_Y)}
    database.write("cascade_lighting_configs", MapConfig)
end

local function LoadMapConfig()
    local mapname = globals.mapname()
    if mapname == nil then
        ui.set(Settings.Enable, false)
        ui.set(Settings.Direction_X, 50)
        ui.set(Settings.Direction_Y, 43)   
    end

    local config = database.read("cascade_lighting_configs") or MapConfig
    config = config[mapname]
    
    if config ~= nil then
        ui.set(Settings.Enable, ui.get(Settings.MasterSwitch) and config[1] and true or false)
        ui.set(Settings.Direction_X, config[2])
        ui.set(Settings.Direction_Y, config[3])
    end
end

LoadMapConfig()

ui.set_callback(Settings.Enable, function(self)
    cl_csm_rot_override:set_raw_int(ui.get(self) and 1 or 0)
    SaveMapConfig()
end)

ui.set_callback(Settings.Direction_X, function(self)
    cl_csm_rot_x:set_int(ui.get(self))
    SaveMapConfig()
end)

ui.set_callback(Settings.Direction_Y, function(self)
    cl_csm_rot_y:set_int(ui.get(self))
    SaveMapConfig()
end)

client.set_event_callback("client_disconnect", SaveMapConfig)
client.set_event_callback("shutdown", SaveMapConfig)
client.set_event_callback("level_init", LoadMapConfig)
client.set_event_callback("player_connect_full", function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        LoadMapConfig()
    end
end)