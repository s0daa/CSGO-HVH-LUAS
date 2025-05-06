local combobox = ui.new_combobox('LUA', 'B', 'Choose menu', 'Nothing', 'Double Inject', 'gamesense 2018', 'Aimware V5', 'Neverlose', 'Onetapv2', 'OTC3', 'OTV4', 'LuckyCharms', 'DevCore', 'Fanta', 'Fatality Crack', 'Lethality', 'Nanohook', 'Nanosense', 'Nemesis', 'Pandora', 'Pandora2', 'Weave')
local hotkey = ui.new_hotkey('LUA', 'B', 'Open Menu')
local mousecheckbox = ui.new_checkbox('LUA', 'B', 'Move with left mouse')

local gamesensemenu   = renderer.load_png(readfile("menu/gamesense.png"),1,1)
local aimwaremenu     = renderer.load_png(readfile("menu/aimwar`e.png"),1,1)
local otc3menu        = renderer.load_png(readfile("menu/otc3.png"),1,1)
local onetapv4menu    = renderer.load_png(readfile("menu/onetapv4.png"),1,1)
local luckycharmsmenu = renderer.load_png(readfile("menu/luckycharms.png"),1,1)
local devcoremenu     = renderer.load_png(readfile("menu/devcore.png"),1,1)
local fantamenu       = renderer.load_png(readfile("menu/fanta.png"),1,1)
local fatalitymenu    = renderer.load_png(readfile("menu/fatality.png"),1,1)
local lethalitymenu   = renderer.load_png(readfile("menu/lethality.png"),1,1)
local nanohookmenu    = renderer.load_png(readfile("menu/nanohook.png"),1,1)
local nanosensemenu   = renderer.load_png(readfile("menu/nanosense.png"),1,1)
local nemisismenu     = renderer.load_png(readfile("menu/nemisis.png"),1,1)
local onetapv2menu    = renderer.load_png(readfile("menu/onetapv2.png"),1,1)
local pandoramenu     = renderer.load_png(readfile("menu/pandora.png"),1,1)
local pandoramenu2    = renderer.load_png(readfile("menu/pandora2.png"),1,1)
local neverlosemenu   = renderer.load_png(readfile("menu/Neverlose.png"),1,1)
local skeet2018menu   = renderer.load_png(readfile("menu/gamesense2018.png"),1,1)
local weavemenu       = renderer.load_png(readfile("menu/weave.png"),1,1)

function DrawImage()
  local value = ui.get(combobox)

  local leftclick = client.key_state(0x01)
  if (leftclick and ui.get(mousecheckbox)) then
    x, y = ui.mouse_position()
  else
    if (ui.get(mousecheckbox)) then
    else
      x = 500
      y = 500
    end
  end

  if (ui.get(hotkey) == true) then
    if value == "gamesense 2018"       then renderer.texture(skeet2018menu, x - 20, y - 20, 660, 560, 255, 255, 255, 255, "f")
      elseif value == "Double Inject"  then renderer.texture(gamesensemenu, x - 20, y - 20, 825, 781, 255, 255, 255, 255, "f") 
      elseif value == "Aimware V5"     then renderer.texture(aimwaremenu, x - 20, y - 20, 1000, 750, 255, 255, 255, 255, "f")
      elseif value == "OTC3"           then renderer.texture(otc3menu, x - 20, y - 20, 575, 576, 255, 255, 255, 255, "f")
      elseif value == "OTV4"           then renderer.texture(onetapv4menu, x - 20, y - 20, 810, 705, 255, 255, 255, 255, "f")
      elseif value == "LuckyCharms"    then renderer.texture(luckycharmsmenu, x - 20, y - 20, 832, 539, 255, 255, 255, 255, "f")
      elseif value == "DevCore"        then renderer.texture(devcoremenu, x - 20, y - 20, 780, 550, 255, 255, 255, 255, "f")
      elseif value == "Fanta"          then renderer.texture(fantamenu, x - 20, y - 20, 801, 601, 255, 255, 255, 255, "f")
      elseif value == "Fatality Crack" then renderer.texture(fatalitymenu, x - 20, y - 20, 802, 652, 255, 255, 255, 255, "f")
      elseif value == "Lethality"      then renderer.texture(lethalitymenu, x - 20, y - 20, 721, 541, 255, 255, 255, 255, "f")
      elseif value == "Nanosense"      then renderer.texture(nanosensemenu, x - 20, y - 20, 660, 640, 255, 255, 255, 255, "f")
      elseif value == "Nanohook"       then renderer.texture(nanohookmenu, x - 20, y - 20, 547, 434, 255, 255, 255, 255, "f")
      elseif value == "Nemesis"        then renderer.texture(nemisismenu, x - 20, y - 20, 800, 600, 255, 255, 255, 255, "f")
      elseif value == "Onetapv2"       then renderer.texture(onetapv2menu, x - 20, y - 20, 620, 628, 255, 255, 255, 255, "f")
      elseif value == "Pandora"        then renderer.texture(pandoramenu, x - 20, y - 20, 581, 421, 255, 255, 255, 255, "f")
      elseif value == "Pandora2"       then renderer.texture(pandoramenu2, x - 20, y - 20, 616, 473, 255, 255, 255, 255, "f")
      elseif value == "Neverlose"      then renderer.texture(neverlosemenu, x - 20, y - 20, 900, 675, 255, 255, 255, 255, "f")
      elseif value == "Weave"          then renderer.texture(weavemenu, x - 20, y - 20, 804, 484, 255, 255, 255, 255, "f")
    end
  end
end
client.set_event_callback("paint_ui", DrawImage)