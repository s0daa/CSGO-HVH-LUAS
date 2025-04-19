local math_max = math.max
local math_min = math.min
local math_ceil = math.ceil
local renderer_rectangle = renderer.rectangle
local renderer_world_to_screen = renderer.world_to_screen
local renderer_text = renderer.text
local globals_curtime = globals.curtime
local ui_get = ui.get
local ui_set_callback = ui.set_callback
local entity_get_local_player = entity.get_local_player
local entity_get_all = entity.get_all
local entity_get_origin = entity.get_origin
local entity_get_player_name = entity.get_player_name
local entity_get_prop = entity.get_prop
local entity_is_enemy = entity.is_enemy

local grenades_ref
local enabled_ref

local inferno = {}

local function map(n, start, stop, new_start, new_stop)
    local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start

    if new_start < new_stop then
        return math_max(math_min(value, new_stop), new_start)
    else
        return math_max(math_min(value, new_start), new_stop)
    end
end

local function draw_bar(x, y, w, r, g, b, a, percentage)
    local h = 4

    local percentage = math_max(0, math_min(1, percentage))

    local x_inner, y_inner = x + 1, y + 1
    local w_inner, h_inner = w - 2, h - 2
    local x_inner_add, y_inner_add = 0, 0

    local w_inner_prev = w_inner
    w_inner, h_inner = math_ceil(w_inner * percentage), h_inner

    renderer_rectangle(x, y, w, h, 0, 0, 0, a)
    renderer_rectangle(x_inner + x_inner_add, y_inner + y_inner_add, w_inner, h_inner, r, g, b, math_min(255, a + 25))
end

local function on_round_start()
    inferno = {}
end

local function on_inferno_startburn(event)
    inferno[event.entityid] = globals_curtime()
end

local function on_inferno_expire(event)
    inferno[event.entityid] = nil
end

local function on_paint()
    local current_time = globals_curtime()

    local local_player = entity_get_local_player()

    local grenade_esp = ui_get(grenades_ref)

    local molotov_projectiles = entity_get_all("CMolotovProjectile")

    for _, entityid in pairs(molotov_projectiles) do
        local x, y, z = entity_get_origin(entityid)
        local x1, y1 = renderer_world_to_screen(x, y, z)

        local owner = entity_get_prop(entityid, "m_hOwnerEntity")
        local owner_name = entity_get_player_name(owner):upper()

        local griefable = not entity_is_enemy(owner) and owner ~= local_player

        local r, g, b = 255, 75, 50

        if griefable then
            r, g, b = 167, 255, 86
        end

        if x1 then
            renderer_text(x1, y1 + 2, r, g, b, 200, "c-", 50, owner_name)

            if not grenade_esp then
                renderer_text(x1, y1 + 12, 255, 255, 255, 200, "c-", 0, "MOLLY")
            end
        end
    end

    local infernoes = entity_get_all("CInferno")

    for _, entityid in pairs(infernoes) do
        local x, y, z = entity_get_origin(entityid)
        local x1, y1 = renderer_world_to_screen(x, y, z)

        local owner = entity_get_prop(entityid, "m_hOwnerEntity")
        local owner_name = entity_get_player_name(owner):upper()

        local griefable = not entity_is_enemy(owner) and owner ~= local_player

        local r, g, b = 255, 75, 50

        if griefable then
            r, g, b = 167, 255, 86
        end

        if x1 then
            local start_time = inferno[entityid]
            if start_time then
                local elapsed_time = current_time - start_time

                local percentage = math_max(0, math_min(7, 7 - elapsed_time))

                local alpha = map(percentage, 0, 7, 75, 255)
                local bar_percentage = map(percentage, 0, 7, 0, 1)

                renderer_text(x1, y1 + 2, r, g, b, alpha, "c-", 50, owner_name)

                if not grenade_esp then
                    renderer_text(x1, y1 + 12, 255, 255, 255, alpha, "c-", 0, "MOLLY")
                end

                draw_bar(x1 - 11, y1 + 18, 26, 255, 255, 255, alpha, bar_percentage)
            end
        end
    end
end

local function on_enabled_ref(ref)
    inferno = {}
    local state = ui_get(ref)

    local update_callback = state and client.set_event_callback or client.unset_event_callback
    update_callback("round_start", on_round_start)
    update_callback("inferno_startburn", on_inferno_startburn)
    update_callback("inferno_expire", on_inferno_expire)
    update_callback("paint", on_paint)
end

local function init()
    grenades_ref = ui.reference("visuals", "other esp", "grenades")
    enabled_ref = ui.new_checkbox("visuals", "other esp", "Molotov/Incendiary team damage helper")

    on_enabled_ref(enabled_ref)
	ui_set_callback(enabled_ref, on_enabled_ref)
end

init()