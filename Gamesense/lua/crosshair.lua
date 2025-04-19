local client_screen_size, client_set_event_callback, entity_get_local_player, globals_realtime, math_atan, math_cos, math_floor, math_sin, renderer_line, table_insert, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_slider = client.screen_size, client.set_event_callback, entity.get_local_player, globals.realtime, math.atan, math.cos, math.floor, math.sin, renderer.line, table.insert, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_slider

local vector = require 'vector'

local screenWidth, screenHeight = client_screen_size()

local screen = vector(screenWidth, screenHeight, nil)

local Middle = vector(screen.x * 0.5, screen.y * 0.5, nil)

local rotation = 0

local crosshairEnable = ui_new_checkbox("Lua", "A", "Nazi crosshair")

local crosshairColor = ui_new_color_picker("Lua", "A", "Nazi crosshair color", 200, 200, 200, 255)

local crosshairRainbow = ui_new_checkbox("Lua", "A", "Nazi crosshair rainbow")

local crosshiarSize = ui_new_slider("Lua", "A", "Nazi crosshair size", 1, 100, 10)

local function BOG_TO_GRD(BOG)
  return (180 / math.pi) * BOG
end

local function GRD_TO_BOG(GRD)
  return (math.pi / 180) * GRD
end

local function SwastikaCrosshair()
  local pLocal = entity_get_local_player()

  if not pLocal then
    return
  end

  if ui_get(crosshairEnable) then
    local crosshairColorRed, crosshairColorGreen, crosshairColorBlue = ui_get(crosshairColor)

    if rotation < 90 then
      rotation = rotation + 1
    end

    if rotation > 89 then
      rotation = 0
    end

    local crosshairSize = ui_get(crosshiarSize)

    local a = math_floor(screen.y / 2 / 30) * crosshairSize -- corrected line

    local gamma = math_atan(a / a)

    for i = 0, 3 do
      local p = {}

      table_insert(p, a * math_sin(GRD_TO_BOG(rotation + (i * 90))))
      table_insert(p, a * math_cos(GRD_TO_BOG(rotation + (i * 90))))
      table_insert(p, (a / math_cos(gamma)) * math_sin(GRD_TO_BOG(rotation + (i * 90) + BOG_TO_GRD(gamma))))
      table_insert(p, (a / math_cos(gamma)) * math_cos(GRD_TO_BOG(rotation + (i * 90) + BOG_TO_GRD(gamma))))

      if not ui_get(crosshairRainbow) then
        renderer_line(Middle.x, Middle.y, Middle.x + p[1], Middle.y - p[2], crosshairColorRed, crosshairColorGreen, crosshairColorBlue, 255)
        renderer_line(Middle.x + p[1], Middle.y - p[2], Middle.x + p[3], Middle.y - p[4], crosshairColorRed, crosshairColorGreen, crosshairColorBlue, 255)
      else
        local r = math_floor(math_sin(globals_realtime() * 2) * 127 + 128)
        local g = math_floor(math_sin(globals_realtime() * 2 + 2) * 127 + 128)
        local b = math_floor(math_sin(globals_realtime() * 2 + 4) * 127 + 128)

        renderer_line(Middle.x, Middle.y, Middle.x + p[1], Middle.y - p[2], r, g, b, 255)
        renderer_line(Middle.x + p[1], Middle.y - p[2], Middle.x + p[3], Middle.y - p[4], r, g, b, 255)
      end
    end
  end
end

client_set_event_callback("paint", SwastikaCrosshair)
