local surface = require("gamesense/surface") or error("Failed to load surface | https://gamesense.pub/forums/viewtopic.php?id=18793")
local anti_aim = require 'gamesense/antiaim_funcs' or error("Failed to load antiaim_funcs | https://gamesense.pub/forums/viewtopic.php?id=29665")
local bit = require("bit")
local bitband = bit.band
local ffi = require 'ffi'
local images = require("gamesense/images") or error("Failed to load images | https://gamesense.pub/forums/viewtopic.php?id=22917")

local csgo_weapons = require 'gamesense/csgo_weapons'


local lua_name = "Tonka"
local apple = surface.create_font("Verdana", 12, 500, {0x200})
local tab,place = "LUA","B"

local menu_reference =
{
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
    roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
    yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    fakeyawlimit = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    dtholdaim = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
    forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
    player_list = ui.reference("PLAYERS", "Players", "Player list"),
    reset_all = ui.reference("PLAYERS", "Players", "Reset all"),
    apply_all = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
    load_cfg = ui.reference("Config", "Presets", "Load"),
    fl_limit = ui.reference("AA", "Fake lag", "Limit"),
    dt_limit = ui.reference("RAGE", "Other", "Double tap fake lag limit"),
    quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
    yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    slow = {ui.reference("AA", "Other", "Slow motion")},
    dt = {ui.reference("RAGE", "Other", "Double tap")},
    ps = {ui.reference("RAGE", "Other", "Double tap")},
    fakelag = {ui.reference("AA", "Fake lag", "Limit")},
    leg_movement = ui.reference("AA", "Other", "Leg movement"),
}

local new_menu = {
	box_esp = ui.new_combobox(tab,place,'Box ESP',{'Off','Outline','Outline Filled','Fill'}),
	fil = ui.new_label(tab,place,'Fill color'),
	filled_color = ui.new_color_picker(tab,place, 'Filled color', 50, 50, 50, 170,false),
	out = ui.new_label(tab,place,'Outline color'),
	outline = ui.new_color_picker(tab,place, 'Outline color', 255, 255, 255, 255,false),

	health_esp = ui.new_checkbox(tab,place,'Health bar'),
	healt_bar = ui.new_combobox(tab,place,'Health bar v2',{'Normal','Degrade'}),
	default_health = ui.new_label(tab,place,'Default health color'),
	default_color = ui.new_color_picker(tab,place, 'Default HP Bar', 0, 255, 0, 255,false),
	degrade_health = ui.new_label(tab,place,'Degrade health color'),
	degrade_color = ui.new_color_picker(tab,place, 'Degrade HP Bar', 255, 0, 0, 255,false),

	ammo_esp = ui.new_checkbox(tab,place,'Ammo bar'),
	ammo_bar = ui.new_combobox(tab,place,'Ammo bar v2',{'Normal','Degrade'}),
	default_ammo = ui.new_label(tab,place,'Default ammo color'),
	default_color_ammo = ui.new_color_picker(tab,place, 'Default ammo Bar', 0, 140, 255, 255,false),
	degrade_ammo = ui.new_label(tab,place,'Degrade ammo color'),
	degrade_color_ammo = ui.new_color_picker(tab,place, 'Degrade ammo Bar', 255, 255, 255, 255,false),

	weapon_esp = ui.new_checkbox(tab,place,'Weapon esp'),
	weapon_esp_type = ui.new_multiselect(tab,place,'Weapon type',{'Text','Icon'}),
	text_text = ui.new_label(tab,place,'Text color'),
	text_color = ui.new_color_picker(tab,place, 'Text color', 255, 255, 255, 255,false),
	icon_color_text = ui.new_label(tab,place,'Icon color'),
	icon_color = ui.new_color_picker(tab,place, 'Icon color', 255, 255, 255, 255,false),
}


local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

local indicators_spacing = 0

function box_esp()
    local player = entity.get_players(true)
    local sus = {ui.get(new_menu.filled_color)}
    local baka = {ui.get(new_menu.outline)}

	--indicators_spacing = 0

    if ui.get(new_menu.box_esp) == "Outline Filled" then

    	for i = 1, #player do
    	  players = player[i]
    	  local bounding_box = {entity.get_bounding_box(players)}

    	  if bounding_box[1] == nil and bounding_box[2] == nil and bounding_box[3] == nil and bounding_box[4] == nil then
    	  	return 
    	  end

    	   
    	  surface.draw_filled_outlined_rect(bounding_box[1],bounding_box[2],bounding_box[3] - bounding_box[1],bounding_box[4] - bounding_box[2],sus[1],sus[2],sus[3],sus[4],baka[1],baka[2],baka[3],baka[4])
    	  surface.draw_outlined_rect(bounding_box[1] - 1,bounding_box[2] - 1,bounding_box[3] - bounding_box[1] + 2,bounding_box[4] - bounding_box[2] + 2,0,0,0,255) -- outter
    	  surface.draw_outlined_rect(bounding_box[1] + 1,bounding_box[2] + 1,bounding_box[3] - bounding_box[1] - 2,bounding_box[4] - bounding_box[2] - 2,0,0,0,255) -- inner
    	end

    elseif ui.get(new_menu.box_esp) == "Fill" then
    	for i = 1, #player do
    	  players = player[i]
    	  local bounding_box = {entity.get_bounding_box(players)}

    	  if bounding_box[1] == nil and bounding_box[2] == nil and bounding_box[3] == nil and bounding_box[4] == nil then
    	  	return 
    	  end

    	  surface.draw_filled_rect(bounding_box[1],bounding_box[2],bounding_box[3] - bounding_box[1],bounding_box[4] - bounding_box[2],sus[1],sus[2],sus[3],sus[4])
    	end
    elseif ui.get(new_menu.box_esp) == "Outline" then
    	for i = 1, #player do
    	  players = player[i]
    	  local bounding_box = {entity.get_bounding_box(players)}

    	  if bounding_box[1] == nil and bounding_box[2] == nil and bounding_box[3] == nil and bounding_box[4] == nil then
    	  	return 
    	  end

    	  surface.draw_outlined_rect(bounding_box[1],bounding_box[2],bounding_box[3] - bounding_box[1],bounding_box[4] - bounding_box[2],baka[1],baka[2],baka[3],baka[4]) -- middle
    	  surface.draw_outlined_rect(bounding_box[1] - 1,bounding_box[2] - 1,bounding_box[3] - bounding_box[1] + 2,bounding_box[4] - bounding_box[2] + 2,0,0,0,255) -- outter
    	  surface.draw_outlined_rect(bounding_box[1] + 1,bounding_box[2] + 1,bounding_box[3] - bounding_box[1] - 2,bounding_box[4] - bounding_box[2] - 2,0,0,0,255) -- inner
    	end
    end
end


function health_esp()

	local default = {ui.get(new_menu.default_color)}
	local degrade = {ui.get(new_menu.degrade_color)}

	if ui.get(new_menu.health_esp) then

		--indicators_spacing = 0

		local player = entity.get_players(true)

		for i = 1, #player do
    	  players = player[i]

    	  local bounding_box = {entity.get_bounding_box(players)}    	  
    	  if bounding_box[1] ~= nil and bounding_box[2] ~= nil and bounding_box[3] ~= nil and bounding_box[4] ~= nil then

          get_player_health = entity.get_prop(players,"m_iHealth")

          old_health = nil

          if old_health == nil then old_health = 0 end
          
          new_altura = math.abs(bounding_box[2] - bounding_box[4])

          if old_health > get_player_health then
          	old_health = old_health - 50 * globals.absoluteframetime()
          else
          	old_health = get_player_health 
          end

         -- old_health = get_player_health
         

          player_health_bar = (new_altura * old_health) / 100


          if get_player_health < 93 then
          	renderer.text(bounding_box[1] - 10,bounding_box[4] - player_health_bar - 3,255,255,255,255,"-",0,get_player_health)
          end


          --old_bar = player_health_bar

          if ui.get(new_menu.healt_bar) == "Degrade" then

          	surface.draw_filled_rect(bounding_box[1] - 6,bounding_box[2] - 1,bounding_box[1] - bounding_box[1] + 4,bounding_box[4] - bounding_box[2] + 2,30,30,30,200)

          	 surface.draw_filled_gradient_rect(bounding_box[1] - 5,bounding_box[4] - player_health_bar, 3,player_health_bar,default[1],default[2],default[3],default[4],degrade[1],degrade[2],degrade[3],degrade[4],false) -- middle
          	 surface.draw_outlined_rect(bounding_box[1] - 6,bounding_box[2] - 1,bounding_box[1] - bounding_box[1] + 4,bounding_box[4] - bounding_box[2] + 2,0,0,0,255) -- outter
          elseif ui.get(new_menu.healt_bar) == "Normal" then
          	surface.draw_filled_rect(bounding_box[1] - 6,bounding_box[2] - 1,bounding_box[1] - bounding_box[1] + 4,bounding_box[4] - bounding_box[2] + 2,30,30,30,200)
          	 surface.draw_filled_rect(bounding_box[1] - 5,bounding_box[4] - player_health_bar, 3,player_health_bar,default[1],default[2],default[3],default[4]) -- middle
          	 surface.draw_outlined_rect(bounding_box[1] - 6,bounding_box[2] - 1,bounding_box[1] - bounding_box[1] + 4,bounding_box[4] - bounding_box[2] + 2,0,0,0,255) -- outter
          end

          --print(entity.get_player_name(players) .. " / " .. get_player_health .. " / " .. player_health_bar)

    	end
    end
	end
end

function weapon_ammo_bar()

	local default = {ui.get(new_menu.default_color_ammo)}
	local degrade = {ui.get(new_menu.degrade_color_ammo)}

	if ui.get(new_menu.ammo_esp) then

		--indicators_spacing = 0

		local player = entity.get_players(true)

		for i = 1, #player do
    	  players = player[i]

    	   bounding_box = {entity.get_bounding_box(players)}

    	   if bounding_box[1] ~= nil and bounding_box[2] ~= nil and bounding_box[3] ~= nil and bounding_box[4] ~= nil then

    	   old_ammo = 0
		   


    	  local weapon_ent = entity.get_player_weapon(players)
	      if weapon_ent == nil then return end

	      local weapon = csgo_weapons(weapon_ent)
	      if weapon == nil then return end


	      max_clip_size =  weapon.primary_clip_size
	      get_player_ammo = entity.get_prop(weapon_ent,"m_iClip1")

		  if get_player_ammo < 0 then return end


	      if old_ammo > get_player_ammo then
          	old_ammo = old_ammo - 10 * globals.absoluteframetime()
          else
          	old_ammo = get_player_ammo
          end

          --old_ammo = get_player_ammo
	       
          altura = math.abs(bounding_box[1] - bounding_box[3])
          player_ammo = (altura * old_ammo) / max_clip_size

          if get_player_ammo < max_clip_size * 0.9 then
          	renderer.text(bounding_box[1] + player_ammo - 5,bounding_box[4] + 1,255,255,255,255,"-",0,get_player_ammo)
          	
          end


          if ui.get(new_menu.ammo_bar) == "Degrade" then
          	  surface.draw_filled_rect(bounding_box[1] - 1,bounding_box[4] + 2,bounding_box[3] - bounding_box[1] + 2,4,10,10,10,200)
          	  surface.draw_filled_gradient_rect(bounding_box[1], bounding_box[4] + 2,player_ammo,3,default[1],default[2],default[3],default[4],degrade[1],degrade[2],degrade[3],degrade[4],true) -- middle
          	  surface.draw_outlined_rect(bounding_box[1] - 1,bounding_box[4] + 2,bounding_box[3] - bounding_box[1] + 2,4,0,0,0,255) -- outter
          elseif ui.get(new_menu.ammo_bar) == "Normal" then
          	surface.draw_filled_rect(bounding_box[1] - 1,bounding_box[4] + 2,bounding_box[3] - bounding_box[1] + 2,4,10,10,10,200)
          	 surface.draw_filled_rect(bounding_box[1], bounding_box[4] + 2,player_ammo,3,default[1],default[2],default[3],default[4]) -- middle
          	 surface.draw_outlined_rect(bounding_box[1] - 1,bounding_box[4] + 2,bounding_box[3] - bounding_box[1] + 2,4,0,0,0,255) -- outter
          end

          indicators_spacing = indicators_spacing + 6
      end

    	end
	end
end

function weapon_esp()

	local text_color = {ui.get(new_menu.text_color)}
	local icon_color = {ui.get(new_menu.icon_color)}

	if ui.get(new_menu.weapon_esp) then
		local player = entity.get_players(true)

		--indicators_spacing = 0

		for i = 1, #player do
			indicators_spacing = 7
    	players = player[i]

		

    	local bounding_box = {entity.get_bounding_box(players)}

    	 if bounding_box[1] ~= nil and bounding_box[2] ~= nil and bounding_box[3] ~= nil and bounding_box[4] ~= nil then

    	  local weapon_ent = entity.get_player_weapon(players)
    	  if weapon_ent == nil then return end

    	  local weapon = csgo_weapons(weapon_ent)
    	  if weapon == nil then return end

    	  local weapon = csgo_weapons[entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")]
    	  local weapon_icon = images.get_weapon_icon(weapon)

		  local meme = {renderer.measure_text("-",string.upper(weapon.name))}

    	  if table_contains(ui.get(new_menu.weapon_esp_type),"Text") then
    	  	renderer.text((bounding_box[1] + bounding_box[3]) / 2 - meme[1] / 2,bounding_box[4] + indicators_spacing,text_color[1],text_color[2],text_color[3],text_color[4],"-",0,string.upper(weapon.name))
    	  	indicators_spacing = indicators_spacing + 12
    	  end

		  local mes_x,mes_y = weapon_icon:measure(nil,13)

    	   if table_contains(ui.get(new_menu.weapon_esp_type),"Icon") then
    	  	weapon_icon:draw((bounding_box[1] + bounding_box[3]) / 2 - mes_x / 2,bounding_box[4] + indicators_spacing,nil,13,0,0,0,nil,true,nil)
    	  	weapon_icon:draw((bounding_box[1] + bounding_box[3]) / 2 - mes_x / 2 + 1,bounding_box[4] + indicators_spacing,nil,13,icon_color[1],icon_color[2],icon_color[3],icon_color[4],true,nil)
    	  	--print(indicators_spacing)
    	  end
    	end
    	
    	end
	end
end

--indicators_spacing = 0

color_dt = {120,120,120,120} 
color_hs = {120,120,120,120} 
old_dt = {0,0,0,255}
old_hs = {0,0,0,255}

function test()

	X,Y = client.screen_size()

	  
	  if old_dt[1] > color_dt[1] then
	  	old_dt[1] = old_dt[1] - 150 * globals.absoluteframetime()
	  else
	  	old_dt[1] = old_dt[1] + 150 * globals.absoluteframetime()
	  end

	  if old_dt[2] > color_dt[2] then
	  	old_dt[2] = old_dt[2] - 150 * globals.absoluteframetime()
	  else
	  	old_dt[2] = old_dt[2] + 150 * globals.absoluteframetime()
	  end


	  if old_dt[3] > color_dt[3] then
	  old_dt[3] = old_dt[3] - 150 * globals.absoluteframetime()
	  else
	  	old_dt[3] = old_dt[3] + 150 * globals.absoluteframetime()
	  end


	  if old_dt[4] > color_dt[4] then
	  old_dt[4] = old_dt[4] - 150 * globals.absoluteframetime()
	  else
	  	old_dt[4] = old_dt[4] + 150 * globals.absoluteframetime()
	  end

	  if old_hs[1] > color_hs[1] then
	  	old_hs[1] = old_hs[1] - 150 * globals.absoluteframetime()
	  else
	  	old_hs[1] = old_hs[1] + 150 * globals.absoluteframetime()
	  end

	  if old_hs[2] > color_hs[2] then
	  	old_hs[2] = old_hs[2] - 150 * globals.absoluteframetime()
	  else
	  	old_hs[2] = old_hs[2] + 150 * globals.absoluteframetime()
	  end


	  if old_hs[3] > color_hs[3] then
	  old_hs[3] = old_hs[3] - 150 * globals.absoluteframetime()
	  else
	  	old_hs[3] = old_hs[3] + 150 * globals.absoluteframetime()
	  end


	  if old_hs[4] > color_hs[4] then
	  old_hs[4] = old_hs[4] - 150 * globals.absoluteframetime()
	  else
	  	old_hs[4] = old_hs[4] + 150 * globals.absoluteframetime()
	  end

	  --print(old_dt[1])


      
       --indicators_spacing = 0
       surface.draw_outlined_rect(X / 2 - 36, Y / 2 + 19,72,52,255,255,255,255)
       renderer.rectangle(X / 2 - 35, Y / 2 + 20,70,50,30,30,30,150)
       renderer.text(X / 2, Y / 2 + 26, 255, 255, 255, 255,"c",0,lua_name)
       renderer.circle(X / 2 - 18,Y / 2 + 50,old_dt[1],old_dt[2],old_dt[3],old_dt[4],12,360,1.0)
       renderer.circle(X / 2 + 18,Y / 2 + 50,old_hs[1],old_hs[2],old_hs[3],old_hs[4],12,360,1.0)

       --old_dt = color_hs


        if ui.get(menu_reference.dt[1]) and ui.get(menu_reference.dt[2]) and anti_aim.get_double_tap() then
           renderer.text(X / 2 - 25, Y / 2 + 43, 0, 0, 0, 255,"",0,"DT")
           color_dt = {255,255,255,255}
            --indicators_spacing = indicators_spacing + 8
        elseif ui.get(menu_reference.dt[1]) and ui.get(menu_reference.dt[2]) and not anti_aim.get_double_tap() then
        	 renderer.text(X / 2 - 25, Y / 2 + 43, 255, 255, 255, 255,"",0,"DT")
        	color_dt = {120,120,120,120} 
        elseif ui.get(menu_reference.dt[1]) and not ui.get(menu_reference.dt[2]) and not anti_aim.get_double_tap() then
            renderer.text(X / 2 - 25, Y / 2 + 43, 255, 255, 255, 255,"",0,"DT")
            color_dt = {120,120,120,120} 
            --indicators_spacing = indicators_spacing + 8
        end
    
        if ui.get(menu_reference.dt[1]) and ui.get(menu_reference.dt[2]) and ui.get(menu_reference.os[2]) and ui.get(menu_reference.os[1]) then
           renderer.text(X / 2 + 12, Y / 2 + 43, 255, 255, 255, 255,"",0,"HS")

            color_hs = {255,0,0,255}
            --indicators_spacing = indicators_spacing + 8
        elseif ui.get(menu_reference.dt[1]) and not ui.get(menu_reference.dt[2]) and ui.get(menu_reference.os[1]) and ui.get(menu_reference.os[2]) and ui.get(menu_reference.os[1]) then
           renderer.text(X / 2 + 12, Y / 2 + 43, 0, 0, 0, 255,"",0,"HS")
           color_hs = {255,255,255,255}
            --indicators_spacing = indicators_spacing + 8
        elseif not ui.get(menu_reference.os[2]) then
        	renderer.text(X / 2 + 12, Y / 2 + 43, 255, 255, 255, 255,"",0,"HS")
        	color_hs = {120,120,120,120} 
        end


















        if ui.get(menu_reference.quickpeek[2]) then
           -- renderer.text(X / 2 + 20, Y / 2 + 20 + indicators_spacing , 255, 255, 255, 255,"-c",0,"QP")
        else
           -- renderer.text(X / 2 + 20, Y / 2 + 20 + indicators_spacing , 100, 100, 100, 255,"-c",0,"QP")
        end
        if ui.get(menu_reference.safepoint) then
            --renderer.text(X / 2 - 20, Y / 2 + 20 + indicators_spacing , 255, 255, 255, 255,"-c",0,"SP")
        else
           -- renderer.text(X / 2 - 20, Y / 2 + 20 + indicators_spacing , 100, 100, 100, 255,"-c",0,"SP")
        end

        if ui.get(menu_reference.forcebaim) then
            --renderer.text(X / 2 , Y / 2 + 20 + indicators_spacing , 255, 255, 255, 255,"-c",0,"BAIM")

        else
           -- renderer.text(X / 2, Y / 2 + 20 + indicators_spacing , 100, 100, 100, 255,"-c",0,"BAIM")
        end
    
end

client.set_event_callback("paint",function()
	indicators_spacing = 0
	--test()
	box_esp()
	health_esp()
	weapon_ammo_bar()
	weapon_esp()
end)