local gui = {
    groups = {
        ["local"] = {
            model = {
                occluded = {},
                visible = {}
            },
            attachments = {
                visible = {}
            },
            arms = {
                visible = {}
            },
            weapon = {
                visible = {}
            }
        },
        enemy = {
            model = {
                occluded = {},
                visible = {}
            },
            weapon = {
                visible = {}
            }
        },
        friendly = {
            model = {
                occluded = {},
                visible = {}
            },
            weapon = {
                visible = {}
            }
        }
    }
}

gui.enabled = menu.add_checkbox("skybox chams", "enable", false)
gui.group = menu.add_selection("skybox chams", "group", {"local", "enemy", "friendly"})
gui.disable_attachments = menu.add_checkbox("skybox chams", "hide attachments")

menu.set_group_column("skybox chams", 2)

gui.groups["local"].model.occluded.select = menu.add_selection("model", "occluded", {})
gui.groups["local"].model.occluded.color = gui.groups["local"].model.occluded.select:add_color_picker("occluded",
    color_t(28, 0, 152, 44))
gui.groups["local"].model.visible.select = menu.add_selection("model", "visible", {})
gui.groups["local"].model.visible.color = gui.groups["local"].model.visible.select:add_color_picker("visible", color_t(
    28, 0, 152, 44))

gui.groups.enemy.model.occluded.select = menu.add_selection("model", "occluded", {})
gui.groups.enemy.model.occluded.color = gui.groups.enemy.model.occluded.select:add_color_picker("occluded",
    color_t(28, 0, 152, 44))
gui.groups.enemy.model.visible.select = menu.add_selection("model", "visible", {})
gui.groups.enemy.model.visible.color = gui.groups.enemy.model.visible.select:add_color_picker("visible",
    color_t(28, 0, 152, 44))

gui.groups.friendly.model.occluded.select = menu.add_selection("model", "occluded", {})
gui.groups.friendly.model.occluded.color = gui.groups.friendly.model.occluded.select:add_color_picker("occluded",
    color_t(28, 0, 152, 44))
gui.groups.friendly.model.visible.select = menu.add_selection("model", "visible", {})
gui.groups.friendly.model.visible.color = gui.groups.friendly.model.visible.select:add_color_picker("visible", color_t(
    28, 0, 152, 44))

menu.set_group_column("model", 1)

gui.groups["local"].attachments.visible.select = menu.add_selection("attachments", "visible", {})
gui.groups["local"].attachments.visible.color = gui.groups["local"].attachments.visible.select:add_color_picker(
    "visible", color_t(28, 0, 152, 44))

menu.set_group_column("attachments", 1)

gui.groups["local"].arms.visible.select = menu.add_selection("arms", "visible", {})
gui.groups["local"].arms.visible.color = gui.groups["local"].arms.visible.select:add_color_picker("visible", color_t(28,
    0, 152, 44))

menu.set_group_column("arms", 1)

gui.groups["local"].weapon.visible.select = menu.add_selection("weapon", "visible", {})
gui.groups["local"].weapon.visible.color = gui.groups["local"].weapon.visible.select:add_color_picker("visible",
    color_t(28, 0, 152, 44))

gui.groups.enemy.weapon.visible.select = menu.add_selection("weapon", "visible", {})
gui.groups.enemy.weapon.visible.color = gui.groups.enemy.weapon.visible.select:add_color_picker("visible",
    color_t(28, 0, 152, 44))

gui.groups.friendly.weapon.visible.select = menu.add_selection("weapon", "visible", {})
gui.groups.friendly.weapon.visible.color = gui.groups.friendly.weapon.visible.select:add_color_picker("visible",
    color_t(28, 0, 152, 44))

menu.set_group_column("weapon", 1)

local function vmt_bind(typedef, instance, index)
    local vfunc = ffi.cast(ffi.typeof(typedef), ffi.cast("void***", instance)[0][index])
    return function(...)
        return vfunc(instance, ...)
    end
end

local file_system_manager = {}

function file_system_manager:initialize()
    self.file_system = ffi.cast("void***", memory.create_interface("filesystem_stdio.dll", "VFileSystem017"))
    assert(self.file_system, "could not find VFileSystem")

    self._find_first = vmt_bind("const char* (__thiscall*)(void*, const char*, int*)", self.file_system, 32)
    self._find_next = vmt_bind("const char* (__thiscall*)(void*, int)", self.file_system, 33)
    self._close = vmt_bind("void (__thiscall*)(void*, int)", self.file_system, 35)
end

function file_system_manager:find_first(path)
    local handle_retaddr = ffi.new("int[1]")
    local file = self._find_first(path, ffi.cast("int*", handle_retaddr))
    self.handle = ffi.cast("int*", handle_retaddr)[0]

    if file == ffi.NULL then
        return nil
    end

    return ffi.string(file)
end

function file_system_manager:find_next()
    local file = self._find_next(self.handle)

    if file == ffi.NULL then
        return nil
    end

    return ffi.string(file)
end

function file_system_manager:close()
    if self.handle then
        self._close(self.handle)
        self.handle = nil
    end
end

function file_system_manager:get_files_in_directory(path)
    local files = {}

    local file = self:find_first(path .. "/*")

    while file do
        if string.sub(file, 1, 1) ~= "." then
            files[#files + 1] = file
        end

        file = self:find_next()
    end

    return files
end

local gui_manager = {
    previous_state = {}
}

function gui_manager:iter_over_groups(callback)
    for group_name, group in pairs(gui.groups) do
        for subgroup_name, group in pairs(group) do
            for visibility_name, visibility in pairs(group) do
                callback(visibility.select, visibility.color, group_name, subgroup_name, visibility_name)
            end
        end
    end
end

function gui_manager:update_material_list()
    local files = file_system_manager:get_files_in_directory("materials/skybox_chams")
    local materials = {"off"}

    for _, file in pairs(files) do
        if string.sub(file, -4) == ".vtf" then
            materials[#materials + 1] = string.sub(file, 1, -5)
        end
    end

    self:iter_over_groups(function(selection)
        selection:set_items(materials)
    end)
end

function gui_manager:update_visible()
    local groups = {"local", "enemy", "friendly"}
    local selected_group = groups[gui.group:get()]

    self:iter_over_groups(function(selection, _, group)
        selection:set_visible(group == selected_group)
    end)
end

function gui_manager:get_state()
    local state = {}

    self:iter_over_groups(function(selection, color)
        state[#state + 1] = selection:get()
        state[#state + 1] = color:get()
    end)

    return state
end

function gui_manager:did_change()
    local state = self:get_state()

    for i, v in pairs(state) do
        if self.previous_state[i] ~= v then
            self.previous_state = state
            return true
        end
    end

    self.previous_state = state
    return false
end

function gui_manager:initialize()
    self:update_visible()
    self:update_material_list()
    self.previous_state = self:get_state()
end

local material_manager = {
    materials = {
        ["local"] = {
            model = {
                visible = {},
                occluded = {}
            },
            attachments = {
                visible = {},
                occluded = {}
            },
            arms = {
                visible = {},
                occluded = {}
            },
            weapon = {
                visible = {},
                occluded = {}
            }
        },
        enemy = {
            model = {
                visible = {},
                occluded = {}
            },
            weapon = {
                visible = {},
                occluded = {}
            }
        },
        friendly = {
            model = {
                visible = {},
                occluded = {}
            },
            weapon = {
                visible = {},
                occluded = {}
            }
        }
    }
}

function material_manager:get_player_group(entity)
    assert(entity:is_player())

    if entity:get_index() == entity_list.get_local_player():get_index() then
        return "local"
    elseif entity:is_enemy() then
        return "enemy"
    else
        return "friendly"
    end
end

function material_manager:get_group_and_subgroup(ctx)
    local model_name = ctx.model_name
    local entity = ctx.entity
    local class = entity:is_valid() and entity:get_class_name() or ""

    -- is player model
    local is_player = entity:is_valid() and entity:is_player() or false
    local is_thirdperson_gloves = model_name:find("arms") and class == "CEconWearable"

    if is_thirdperson_gloves then
        return "local", "model"
    elseif is_player then
        return self:get_player_group(entity), "model"
    end

    -- is attachment
    local is_weapon_on_back = model_name:find("dropped") and not entity:is_valid()
    local is_defuser = model_name:find("defuser")

    if is_weapon_on_back or is_defuser then
        if gui.disable_attachments:get() then
            ctx.override_original = true
            return nil, nil
        end

        return "local", "attachments"
    end

    -- is arms
    local is_arms = model_name:find("arms") and not entity:is_valid()

    if is_arms then
        if self:should_scope_fix() then
            return nil, nil
        end

        return "local", "arms"
    end

    -- is weapon
    local is_viewmodel_weapon = class == "CPredictedViewModel"

    if is_viewmodel_weapon then
        if self:should_scope_fix() then
            return nil, nil
        end

        return "local", "weapon"
    end

    local is_weapon_in_hand = model_name:find("weapons/w") and class == "CBaseWeaponWorldModel" and not is_arms

    if is_weapon_in_hand then
        local combat_weapon_parent = entity_list.get_entity(entity:get_prop("m_hCombatWeaponParent"))
        local owner = entity_list.get_entity(combat_weapon_parent:get_prop("m_hOwnerEntity"))
        return self:get_player_group(owner), "weapon"
    end
end

function material_manager:should_scope_fix()
    local local_player = entity_list.get_local_player()
    local weapon = entity_list.get_entity(local_player:get_prop("m_hActiveWeapon"))

    if not weapon then
        return
    end

    local weapon_class = weapon:get_class_name()

    local is_scoped = local_player:get_prop("m_bIsScoped")

    return (weapon_class == "CWeaponAug" or weapon_class == "CWeaponSG556") and is_scoped
end

function material_manager:create_materials(group, subgroup, visibility)
    local material_selection = gui.groups[group][subgroup][visibility].select

    if material_selection:get() == 1 then
        self.materials[group][subgroup][visibility] = {
            main = nil,
            overlay = nil
        }
        return
    end

    local material_name = material_selection:get_item_name(material_selection:get())
    local material_color = gui.groups[group][subgroup][visibility].color:get()

    local main_material = materials.create(string.format("skychams_%s_%s_%s", group, subgroup, visibility), [[
        UnlitTwoTexture
        {
            "$moondome" "1"
            "$basetexture" "vgui/white"
            "$cubeparallax" "0.00005"
            "$texture2" "skybox_chams/]] .. material_name .. [["
            "$nofog" "1"
            "$ignorez" "]] .. (visibility == "visible" and "0" or "1") .. [["
        }
    ]])

    local overlay_material = materials.create(string.format("skychams_%s_%s_%s_overlay", group, subgroup, visibility),
        [[
        VertexLitGeneric
        {
            "$additive" "1"
            "$envmap" "models/effects/cube_white"
            "$envmaptint" "[]] .. material_color.r / 255 .. [[ ]] .. material_color.g / 255 .. [[ ]] .. material_color.b /
            255 .. [[]"
            "$envmapfresnel" "1"
            "$envmapfresnelminmaxexp" "[0 1 2]"
            "$alpha" "]] .. material_color.a / 255 .. [["
        }
    ]])

    self.materials[group][subgroup][visibility] = {
        main = main_material,
        overlay = overlay_material
    }
end

function material_manager:update_materials()
    gui_manager:iter_over_groups(function(selection, color, group, subgroup, visibility)
        self:create_materials(group, subgroup, visibility)
    end)
end

function material_manager:draw_model(ctx, group, subgroup)
    local visible_material = self.materials[group][subgroup].visible
    local occluded_material = self.materials[group][subgroup].occluded

    if occluded_material.main then
        ctx.override_original = true
        ctx:draw_material(occluded_material.main)
    end

    if visible_material.main then
        ctx.override_original = true
        ctx:draw_material(visible_material.main)

        if visible_material.overlay then
            ctx:draw_material(visible_material.overlay)
        end
    end
end

function material_manager:on_draw_model(ctx)
    local entity = ctx.entity

    if not entity then
        return
    end

    local group, subgroup = self:get_group_and_subgroup(ctx)

    if group and subgroup then
        self:draw_model(ctx, group, subgroup)
    end
end

local function main()
    file_system_manager:initialize()
    gui_manager:initialize()

    callbacks.add(e_callbacks.PAINT, function()
        gui_manager:update_visible()

        if gui_manager:did_change() then
            material_manager:update_materials()
        end
    end)

    callbacks.add(e_callbacks.DRAW_MODEL, function(ctx)
        if gui.enabled:get() then
            material_manager:on_draw_model(ctx)
        end
    end)
end

main()