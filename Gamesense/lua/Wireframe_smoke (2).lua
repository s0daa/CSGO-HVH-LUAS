local function setup_materials(list)
    local models = { }

    for i=1, #list do
        models[i] = {
            name = list[i],
            data = materialsystem.find_material(list[i])
        }
    end

    return models
end

local function set_flags(material, flags, enabled)
    material:set_material_var_flag(flags, enabled)
end

local function ticks_time(tick)
    return (globals.tickinterval() * tick)
end

local function setup_var(data, in_call)
    if not in_call then
        ui.set(data.reference, data.on_call)
        client.delay_call(ticks_time(data.time), setup_var, data, true)
    else
        ui.set(data.reference, data.end_call)
    end
end

local function setup_smokeinfo()
    local data, me = 0, entity.get_local_player()
    local CSmokeGrenadeProjectile = entity.get_all("CSmokeGrenadeProjectile")

    if me == nil or CSmokeGrenadeProjectile == nil then
        return
    end

    for i=1, #CSmokeGrenadeProjectile do
        local smoke = CSmokeGrenadeProjectile[i]

        if entity.get_prop(smoke, "m_bDidSmokeEffect") == 1 then
            data = data + 1
        end
    end

    return data
end

local function find_across(tab, in_a, key)
    for i=1, #tab do
        local pr = tab[i][in_a]
        if pr ~= nil and pr == key then
            return tab[i]
        end
    end
end

local models = {
    "particle/vistasmokev1/vistasmokev1",
    "particle/vistasmokev1/vistasmokev1_smokegrenade",
    "particle/vistasmokev1/vistasmokev1_emods",
    "particle/vistasmokev1/vistasmokev1_emods_impactdust",
    "particle/vistasmokev1/vistasmokev1_fire"
}

local smokes = 0
local combolist = { "Off", "Removal", "Wireframe" }

local ref = ui.reference("VISUALS", "Effects", "Remove smoke grenades")
local grenade_effect = ui.new_combobox("VISUALS", "Effects", "Smoke grenade effect", combolist)

ui.set_visible(ref, false)

client.set_event_callback("net_update_end", function()
    local selection = ui.get(grenade_effect)

    local materials = setup_materials(models)
    local smoke_fire = find_across(materials, "name", "particle/vistasmokev1/vistasmokev1_fire")

    local is_removal, is_wireframe = 
        selection == combolist[2],
        selection == combolist[3]

    if selection ~= combolist[3] then
        ui.set(ref, is_removal and true or false)
    else
        local smoke_count = setup_smokeinfo()

        if smoke_count ~= smokes then
            smokes = smoke_count
            setup_var({
                reference = ref,
                time = 7,

                on_call = true,
                end_call = false
            })
        end
    end

    local is_both = is_removal or is_wireframe

    for i=1, #materials do
        set_flags(materials[i].data, 28, is_wireframe)
        set_flags(materials[i].data, 3, is_both)
    end

    set_flags(smoke_fire.data, 2, is_both)
end)

client.set_event_callback("shutdown", function()
    ui.set_visible(ref, true)
end)
