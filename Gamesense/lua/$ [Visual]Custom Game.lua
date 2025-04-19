local ui_processig = ui.reference('VISUALS', 'Effects', 'Disable post processing')

local list = { 'Global', 'Vignette', 'Bloom', 'Shadows', 'Blood' }
local master_switch = ui.new_multiselect('Visuals', 'Effects', 'Disable post processing \n csm', list)

local cvar_postprocess = cvar.mat_postprocess_enable
local cvar_vignette = cvar.mat_vignette_enable
local cvar_bloom_scale = cvar.mat_bloom_scalefactor_scalar
local cvar_shadows = cvar.cl_csm_shadows
local cvar_blood1 = cvar.violence_ablood
local cvar_blood2 = cvar.violence_hblood

local function conts(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

client.set_event_callback('paint_ui', function()
    local switch = ui.get(master_switch)

    if #switch > 0 then
        ui.set(ui_processig, false)
    end

    cvar_postprocess:set_int(conts(switch, list[1]) and 0 or 1)
    cvar_vignette:set_int(conts(switch, list[2]) and 0 or 1)
    cvar_bloom_scale:set_int(conts(switch, list[3]) and 0 or 1)
    cvar_shadows:set_int(conts(switch, list[4]) and 0 or 1)

    cvar_blood1:set_int(conts(switch, list[5]) and 0 or 1)
    cvar_blood2:set_int(conts(switch, list[5]) and 0 or 1)
end)
