--------------------------------------------------------------------------------
-- Caching common functions
--------------------------------------------------------------------------------
local client_eye_position, client_set_event_callback, client_userid_to_entindex, entity_get_local_player, globals_curtime, globals_tickcount, renderer_line, renderer_world_to_screen, pairs, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_slider, ui_set_callback, ui_set_visible = client.eye_position, client.set_event_callback, client.userid_to_entindex, entity.get_local_player, globals.curtime, globals.tickcount, renderer.line, renderer.world_to_screen, pairs, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_slider, ui.set_callback, ui.set_visible

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local shot_data = {}

--------------------------------------------------------------------------------
-- Menu handling
--------------------------------------------------------------------------------
local bullet_tracer     = ui_new_checkbox("LUA", "A", "Local bullet tracers")
local tracer_color      = ui_new_color_picker("LUA", "A", "Tracer color", 255, 255, 255, 255)
local plus_color      = ui_new_color_picker("LUA", "A", "Plus color", 255, 255, 255, 255)
local tracer_duration   = ui_new_slider("LUA", "A", "\n", 1, 10000, 3000, true, "s", 0.001)

local function handle_menu()
    local state = ui_get(bullet_tracer)
    ui_set_visible(tracer_duration, state)
end

handle_menu()
ui_set_callback(bullet_tracer, handle_menu)

--------------------------------------------------------------------------------
-- Game event handling
--------------------------------------------------------------------------------
local function paint()
    if not ui_get(bullet_tracer) then
        return
    end
    local r, g, b = ui_get(tracer_color)
    local r1,g1,b1 = ui_get(plus_color)
    for tick, data in pairs(shot_data) do
        -- Screen positions
        local sx1, sy1  = renderer_world_to_screen(data.x, data.y, data.z)
        local sx2,sy2 = nil
        if not sx1 then
            sx1 = data.last_impact_x
            sy2 = data.last_impact_y
        end
        local sx2, sy2  = renderer_world_to_screen(data.lx, data.ly, data.lz)
        if not sx2 then
            sx2 = data.last_origin_x
            sy2 = data.last_origin_y
        end
        -- Visibility check
        local visible   = sx1 ~= nil and sx2 ~= nil and sy1 ~= nil and sy2 ~= nil
        -- Save shot locations
        data.last_impact_x = sx1
        data.last_impact_y = sy1
        data.last_origin_x = sx2
        data.last_origin_y = sy2
        -- Drawing
        if data.draw and visible then
            if globals_curtime() >= data.duration then
                data.alpha = data.alpha - 1
            end
            if data.alpha <= 0 then
                data.draw = false
            end

            if (data.hit) then
              renderer_line(sx1 - 5, sy1, sx1 + 5, sy1, r1, g1, b1, data.alpha)
              renderer_line(sx1  , sy1 - 5, sx1, sy1 + 5, r1, g1, b1, data.alpha)
            end
        end
    end
end

local function bullet_impact(e)
    if not ui_get(bullet_tracer) then
        return
    end

    if client_userid_to_entindex(e.userid) ~= entity_get_local_player() then
        return
    end

    local weapon_entindext = entity.get_player_weapon(entity_get_local_player())
    if weapon_entindext == nil then
      return
    end
    local weapon_entindex = bit.band(65535, entity.get_prop(weapon_entindext, "m_iItemDefinitionIndex"))
    if(weapon_entindex > 40 and weapon_entindex <= 59) then
      return
    end
    local lx, ly, lz = client_eye_position()
    shot_data[globals_tickcount()] = {
        x           = e.x,
        y           = e.y,
        z           = e.z,
        lx          = lx,
        ly          = ly,
        lz          = lz,
        draw        = true,
        alpha       = 255,
        hit         = false,
        duration    = globals_curtime() + ui_get(tracer_duration) * 0.001
    }
end

local function player_hit(e)
  if not ui_get(bullet_tracer) then
      return
  end

  if client_userid_to_entindex(e.attacker) ~= entity_get_local_player() then
      return
  end

  shot_data[globals_tickcount()].hit = true


end

local function round_start()
    if not ui_get(bullet_tracer) then
        return
    end
    shot_data = {}
end

client_set_event_callback("player_hurt", player_hit)
client_set_event_callback("paint", paint)
client_set_event_callback("round_start", round_start)
client_set_event_callback("bullet_impact", bullet_impact)
