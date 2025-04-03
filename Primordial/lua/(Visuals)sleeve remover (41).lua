--| Create the remover checkbox
local sleeve_remover = menu.add_checkbox("Main", "Sleeve remover")

--| Store a cached value
local sleeve_cache = sleeve_remover:get()

--| Keep a material cache
local sleeve_material_cache = {}

--| The paint callback
local function on_paint()
    -- Cache the materials if checkbox changes
    if sleeve_cache ~= sleeve_remover:get() then
        materials.for_each(function(material)
            if material:get_name():find("sleeve") then
                table.insert(sleeve_material_cache, material)
            end
        end)
    end
    sleeve_cache = sleeve_remover:get()

    -- Update the NO_DRAW flag
    for k, v in next, sleeve_material_cache do
        v:set_flag(e_material_flags.NO_DRAW, sleeve_remover:get())
    end
end

--| Register the paint callback
callbacks.add(e_callbacks.PAINT, on_paint)