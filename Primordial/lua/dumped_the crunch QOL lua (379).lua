menu.add_text("General", "crunch.lua welcome user:" .. user.name .. " [" .. user.uid .. "]")
local master = menu.add_checkbox("Master", "Master Switch", false)
local zeropitch = menu.add_checkbox("features", "Zero pitch on land", false)
local staticlegs = menu.add_checkbox("features", "Static legs in air", false)
local accent_color_text, accent_color_color = unpack(menu.find("misc", "main", "config", "accent color"))
local menutheme = menu.add_checkbox("theme", "rainbow", false)
   
local ground_tick = 1
local end_time = 0
local default_font = render.get_default_font()
local screen_size = render.get_screen_size()
local customfont = render.create_font("Comic Sans MS Bold Italic", 15, 50000, e_font_flags.ADDITIVE)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------- logs
local enableSwag = menu.add_checkbox("hit logs", "enable", false)
local printtoConsole = menu.add_checkbox("hit logs", "print logs to console", false)

local amountonscreen = menu.add_slider("hit logs modifiers", "amount of logs on screen at one time", 1, 10)
local timelogs = menu.add_slider("hit logs modifiers", "time before logs fade", 0, 10)
local fontstyle = menu.add_selection("hit logs modifiers", "font style", {"normal", "bold"})

local logs = {}
local logrender = {}
local logtime = {}
local boollog = {true,true,true,true,true}
local curTime = {}
local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}


local fonts = {
    normal = render.create_font("Tahoma", 12, 100, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE),
    bold = render.create_font("Tahoma Bold", 13, 500, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)
}

function drawLog()
    if not enableSwag:get() then return end
    local screen_size = render.get_screen_size()
    for i = 1, #logs do
        if logrender[i] then
            if not logtime[i] or not logs[i] then return end
            render.text(fontstyle:get() == 1 and fonts.normal or fonts.bold, logs[i], vec2_t(screen_size.x/2, screen_size.y/(1.25+i/45)), color_t(255, 255, 255, logtime[i]), true)
        end
    end
end

function onHit(e)
    local hitString = string.format("Hit %s in the %s [%s] for %s [%s] (hc: %s bt: %s)", e.player:get_name(), hitgroup_names[e.hitgroup + 1] or '?', hitgroup_names[e.aim_hitgroup + 1], e.damage, e.aim_damage, math.floor(e.aim_hitchance).."%", e.backtrack_ticks)
    table.insert(logs, hitString); table.insert(logrender, true)
    if #logs > amountonscreen:get() then
        table.remove(logs, 1); table.remove(logrender, 1); table.remove(logtime, 1); table.remove(boollog, 1); table.remove(curTime, 1)
    end
    if printtoConsole:get() then
        client.log(hitString)
    end
    boollog[#logs] = true
end

function onMiss(e)
    local missString = string.format("Missed %s %s due to %s [%s] (hc: %s bt: %s)", e.player:get_name().."'s", hitgroup_names[e.aim_hitgroup + 1] or '?', e.reason_string, e.aim_damage, math.floor(e.aim_hitchance).."%", e.backtrack_ticks)
    table.insert(logs, missString)
    table.insert(logrender, true)
    if #logs > amountonscreen:get() then
        table.remove(logs, 1); table.remove(logrender, 1); table.remove(logtime, 1); table.remove(boollog, 1); table.remove(curTime, 1)
    end
    if printtoConsole:get() then
        client.log(missString)
    end
    boollog[#logs] = true
end

function handleVisibility()
    for i = 1, #logs do
        if boollog[i] then
            curTime[i] = client.get_unix_time() + timelogs:get()
            boollog[i] = false
            logtime[i] = 255
        end
        if not curTime[i] then goto endrendering end
        if curTime[i] < client.get_unix_time() then
            logtime[i] = logtime[i] - 1
        end
        if logtime[i] == 10 then
            table.remove(logs, i);table.remove(logrender, i);table.remove(logtime, i);table.remove(boollog, i);table.remove(curTime, i)
        end
        ::endrendering::
    end 
end

callbacks.add(e_callbacks.AIMBOT_MISS, onMiss)
callbacks.add(e_callbacks.AIMBOT_HIT, onHit)

callbacks.add(e_callbacks.PAINT, function()
    drawLog(); handleVisibility()
end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------- watermark

local function on_draw_watermark()
    local fps = client.get_fps()
    local tickrate = client.get_tickrate()
    return "primordial.dev | "..user.name.." ["..user.uid.."] | "..fps.." fps | "..tickrate.." tick"
end

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------- logs

exploits.get_charge()
local function clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------- zeropitch
callbacks.add(e_callbacks.ANTIAIM, function(ctx)
if not master:get() then return end
	local lp = entity_list.get_local_player()
	local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
	local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0	
	local curtime = global_vars.cur_time() 

	if on_land == true then
		ground_tick = ground_tick + 1
	else
		ground_tick = 0
		end_time = curtime + 1
	end
	if ground_tick > 1 and end_time > curtime and zeropitch:get() then
		ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
	end
	if in_air and staticlegs:get() then
		ctx:set_render_pose(e_poses.JUMP_FALL, 1)
	end
	
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------- rainbow menu

local State = 0
local R = 255
local G = 0
local B = 0
local Rainbow = color_t(255, 255, 255, 255)

 callbacks.add(e_callbacks.PAINT, function()
		if State == 0 then
			G = G + 1
			if G == 255 then
				State = 1
			end
		end   
		if State == 1 then
			R = R - 1
			if R == 0 then
				State = 2
			end
		end
		if State == 2 then
			B = B + 1
			if B == 255 then
				State = 3
			end
		end
		if State == 3 then
			G = G - 1
			if G == 0 then
				State = 4
			end
		end
		if State == 4 then
			R = R + 1
			if R == 255 then
				State = 5
			end
		end
		if State == 5 then
			B = B -1
			if B == 0 then
				State = 0
			end
		end
	
		Rainbow = color_t(R, G, B , 255)

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------- master switch

 menu.set_group_visibility("features",master:get())
 menu.set_group_visibility("theme",master:get())
 menu.set_group_visibility("Indicators",master:get())
 menu.set_group_visibility("hit logs",master:get())
 menu.set_group_visibility("hit logs modifiers",master:get())
 menu.set_group_visibility("Visuals",master:get())
 menu.set_group_visibility("hitmarker",master:get())
 menu.set_group_visibility("auto peek",master:get())
 if not master:get() then return end
 if menutheme:get() then accent_color_color:set(Rainbow) end

end)

local colors = {
    white = color_t(255, 255, 255),
    red   = color_t(255, 0, 0),
    gray  = color_t(100, 100, 100)
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------- indicators
local ref = {
	aimbot = {
		dt_ref = menu.find("aimbot","general","exploits","doubletap","enable"),
		hs_ref = menu.find("aimbot","general","exploits","hideshots","enable"),
		hitbox_override = menu.find("aimbot", "auto", "target overrides", "force hitbox"),
        safepoint_ovride = menu.find("aimbot", "auto", "target overrides", "force safepoint")
	},
}

local globals = {
    crouching          = false,
    standing           = false,
    jumping            = false,
    running            = false,
    pressing_move_keys = false
}

local screen_size    = render.get_screen_size()

local indicator = menu.add_checkbox("Indicators", "Indicators")
local ind_col = indicator:add_color_picker("Indicators Color")

local function indicators()
    if not engine.is_in_game() then return end
    local local_player = entity_list.get_local_player()
    if not local_player:is_alive() then return end
    if not indicator:get() then return end

    local lethal         = local_player:get_prop("m_iHealth") <= 92
	local font_inds      = render.create_font("Arial Bold", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font
	local x, y           = screen_size.x / 2, screen_size.y / 2
    local indi_color     = ind_col:get()
    local text_size      = render.get_text_size(font_inds, "")
    local text_size2     = render.get_text_size(font_inds, "lethal")
    local cur_weap       = local_player:get_prop("m_hActiveWeapon")
    local current_state  = ""
    local ind_offset     = 0

    -- LETHAL --
    if lethal then
        render.text(font_inds, "lethal", vec2_t(x + 2, y + 23), indi_color, true)
    end

    render.text(font_inds, current_state, vec2_t(x + 1, y + 33), indi_color, true)

    -- DT --
    if ref.aimbot.dt_ref[2]:get() then
        if exploits.get_charge() < 1 then
            render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.red, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "  DT")[0] + 5
        else
            render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.white, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "  DT")[0] + 5
        end
    else
        render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "  DT")[0] + 5
    end

    -- HS --
    if ref.aimbot.hs_ref[2]:get() then
        render.text(font_inds, "HS", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
    else
        render.text(font_inds, "HS", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
    end

    -- SP --
    if ref.aimbot.safepoint_ovride[2]:get() then
        render.text(font_inds, "SP", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 5
    else
        render.text(font_inds, "SP", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 5
    end
end

callbacks.add(e_callbacks.PAINT, function()
    ind_col:set_visible(indicator:get())

    indicators()
end)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------- chams

local cham_materials = {
	"Regular",
	"Flat",
	"Mettalic",
	"Glow",
	"Wireframe",
	"Animated",
	"Signal",
}

local cham_materials2 = {
	"Regular",
	"Flat",
	"Mettalic",
}

local c_cfg = {} c_cfg.__index = c_cfg
c_cfg.table = {

    c_visuals = {
        remove_sleeves = menu.add_checkbox("Visuals", "Remove sleeves"),

        enemy_enable = menu.add_checkbox("Visuals", "Enemy chams"),
        enemy_material = menu.add_selection("Visuals","Enemy material",cham_materials),
        enemy_material_2 = menu.add_selection("Visuals","Enemy material ",cham_materials2),
        enemy_original = menu.add_checkbox("Visuals", "Enemy original"),

        team_enable = menu.add_checkbox("Visuals", "Team chams"),
        team_material = menu.add_selection("Visuals","Team material",cham_materials),
        team_material_2 = menu.add_selection("Visuals","Team material ",cham_materials2),
        team_original = menu.add_checkbox("Visuals", "Team original"),

        local_enable = menu.add_checkbox("Visuals", "Local chams"),
        local_material = menu.add_selection("Visuals","Local material",cham_materials),
        local_material_2 = menu.add_selection("Visuals","Local material ",cham_materials2),
        local_original = menu.add_checkbox("Visuals", "Local original"),

        arms_enable = menu.add_checkbox("Visuals", "Arm chams"),
        arms_material = menu.add_selection("Visuals","Arms material",cham_materials),
        arms_material_2 = menu.add_selection("Visuals","Arms material ",cham_materials2),
        arms_original = menu.add_checkbox("Visuals", "Arms original"),

        weapon_enable = menu.add_checkbox("Visuals", "Weapon chams"),
        weapon_material = menu.add_selection("Visuals","Weapon material",cham_materials),
        weapon_material_2 = menu.add_selection("Visuals","Weapon material ",cham_materials2),
        weapon_original = menu.add_checkbox("Visuals", "Weapon original"),
    },
}

c_cfg.table.c_visuals.colors = {
    enemy_color = c_cfg.table.c_visuals.enemy_enable:add_color_picker("enemy_base_chams_color", color_t(0, 0, 0, 255)),
    enemy_overlay_color = c_cfg.table.c_visuals.enemy_material:add_color_picker("enemy_glow_overlay_chams_color", color_t(13, 30, 47, 255)),

    team_color = c_cfg.table.c_visuals.team_enable:add_color_picker("team_base_chams_color", color_t(0, 0, 0, 255)),
    team_overlay_color = c_cfg.table.c_visuals.team_material:add_color_picker("team_glow_overlay_chams_color", color_t(13, 30, 47, 255)),

    local_color = c_cfg.table.c_visuals.local_enable:add_color_picker("local_base_chams_color", color_t(0, 0, 0, 255)),
    local_overlay_color = c_cfg.table.c_visuals.local_material:add_color_picker("local_glow_overlay_chams_color", color_t(13, 30, 47, 255)),

    arms_color = c_cfg.table.c_visuals.arms_enable:add_color_picker("arms_base_chams_color", color_t(0, 0, 0, 255)),
    arms_overlay_color = c_cfg.table.c_visuals.arms_material:add_color_picker("arms_glow_overlay_chams_color", color_t(13, 30, 47, 255)),

    weapon_color = c_cfg.table.c_visuals.weapon_enable:add_color_picker("weapon_base_chams_color", color_t(0, 0, 0, 255)),
    weapon_overlay_color = c_cfg.table.c_visuals.weapon_material:add_color_picker("weapon_glow_overlay_chams_color", color_t(13, 30, 47, 255)),
}

local create_material = function(mat, name, count)
   local t = {}
   
   for i=1, count do
       table.insert(t, materials.create( ("t_%s_%i"):format(name, i), mat ) )
   end
   
   return t
end

local default_material = create_material([[
      "VertexLitGeneric" {
         "$basetexture" "vgui/white"
         "$envmap"       "debug/debugambientcube"
         "$envmaptint"   "[1 1 1]"
         "$nofog"        "1"
         "$model"        "1"
      }
]], "nulify_textured_material", 2)

local flat_material = create_material([[
      "UnlitGeneric" {
         "$basetexture" "vgui/white"
		 "$ignorez"		"0"
         "$envmap"      " "
         "$nofog"       "1"
		 "$model"		"1"
		 "$nocull"		"0"
		 "$selfillum"	"1"
		 "$halflambert"	"1"
		 "$znearer"		"0"
		 "$flat"	    "1"
		 "$wireframe"	"0"
      }
]], "nulify_flat_material", 2)

local metallic_material = create_material([[
      "VertexLitGeneric" {
        "$addative" "1"
        "$wireframe" "0"
		"$ignorez" "0"
        "$bumpmap" "de_nuke/hr_nuke/pool_water_normals_002"
		"$envmap" "env_cubemap"
        "$envmaptint" "[0.02 0.02 0.02]"
        "$envmapfresnel" "0"
        "$envmapfresnelminmaxexp" "[1.0 1.0 1.0]"
        "$phong" "1"
        "phongexponent" "0"
        "phongboost" "8.0"
        "phongfresnelranges" "[1.0 1.0 0.0]"
	}
]], "nulify_metallic_material", 2)

local glow_material = create_material([[
   "VertexLitGeneric" { 
	"$additive"					"1" 
	"$envmap"					"models/effects/cube_white" 
	"$envmaptint"				"[1 1 1]" 
	"$envmapfresnel"			"1" 
	"$envmapfresnelminmaxexp" 	"[0 1 2]" 
	"$alpha" 					"0.8" 
	
}
]], "nulify_glow_material", 2)

local animated_material = create_material([[
   "VertexLitGeneric" {
	"$basetexture"				"dev/zone_warning"
	"$additive"					"1"
	"$envmap"					"editor/cube_vertigo"
	"$envmaptint"				"[0 0.5 0.55]"
	"$envmapfresnel"			"1"
	"$envmapfresnelminmaxexp"   "[0.00005 0.6 6]"
	"$alpha"					"1"

	Proxies
	{
		TextureScroll
		{
			"texturescrollvar"			"$baseTextureTransform"
			"texturescrollrate"			"0.25"
			"texturescrollangle"		"270"
		}
		Sine
		{
			"sineperiod"				"2"
			"sinemin"					"0.1"
			"resultVar"					"$envmapfresnelminmaxexp[1]"
		}
	}
}
]], "nulify_animated_material", 2)

local wireframe_material = create_material([[
   "VertexLitGeneric"  {
	"$basetexture" "sprites/light_glow04"
	"$wireframe" "1"
	"$alpha" "1"
	"$additive" "1"
	"proxies"
	 {
		"texturescroll"
		{
			"texturescrollvar" "$basetexturetransform"
			"texturescrollrate" "0.8"
			"texturescrollangle" "0"
		}
	}
}
]], "nulify_wireframe_material", 2)

local signal_material = create_material([[
   "VertexLitGeneric"  {
	"$basetexture" "sprites/light_glow04"
	"$wireframe" "0"
	"$alpha" "1"
	"$additive" "1"
	"$envmap" "env_cubemap"
    "$envmaptint" "[0.1 0.1 0.1]"
	"proxies"
	 {
		"texturescroll"
		{
			"texturescrollvar" "$basetexturetransform"
			"texturescrollrate" "0.8"
			"texturescrollangle" "0"
		}
	}
}
]], "nulify_signal_material", 2)

function get_material(id)
	if id == 1 then
		return default_material
	elseif id == 2 then
		return flat_material
	elseif id == 3 then
		return metallic_material
	elseif id == 4 then
		return glow_material
	elseif id == 5 then
		return wireframe_material
	elseif id == 6 then
		return animated_material
	elseif id == 7 then
		return signal_material
	end

	return default_material
end

--Fucking going to kms over this code.
callbacks.add(e_callbacks.DRAW_MODEL, function(ctx)
    local model = ctx.model_name:lower()
    local local_player = entity_list.get_local_player()
    if local_player:has_player_flag(e_player_flags.FROZEN) then return end
    --ctx.entity:is_enemy()

    if c_cfg.table.c_visuals.enemy_enable:get() and ctx.entity:is_valid() and ctx.entity:is_player() and ctx.entity:is_enemy() then
        local col = c_cfg.table.c_visuals.colors.enemy_color:get()
        if not c_cfg.table.c_visuals.enemy_original:get() then
            ctx.override_original = true
    
            get_material(c_cfg.table.c_visuals.enemy_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.enemy_material:get())[2]:alpha_modulate(col.a / 255)
    
            get_material(c_cfg.table.c_visuals.enemy_material:get())[2]:set_flag(e_material_flags.IGNOREZ, true)
            ctx:draw_material(get_material(c_cfg.table.c_visuals.enemy_material:get())[2])
        end

	    if c_cfg.table.c_visuals.enemy_material:get() == 4 or c_cfg.table.c_visuals.enemy_material:get() == 5 or c_cfg.table.c_visuals.enemy_material:get() == 6 or c_cfg.table.c_visuals.enemy_material:get() == 7 then
			ctx.override_original = true

	        get_material(c_cfg.table.c_visuals.enemy_material_2:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
	        get_material(c_cfg.table.c_visuals.enemy_material_2:get())[2]:alpha_modulate(c_cfg.table.c_visuals.enemy_original:get() and 0 or col.a / 255)

	        ctx:draw_material(get_material(c_cfg.table.c_visuals.enemy_material_2:get())[2])

			local col = c_cfg.table.c_visuals.colors.enemy_overlay_color:get()
			glow_material[2]:set_shader_param("$envmaptint", vec3_t(col.r / 255, col.g / 255, col.b / 255))
		    get_material(c_cfg.table.c_visuals.enemy_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.enemy_material:get())[2]:alpha_modulate(col.a / 255)
  
            get_material(c_cfg.table.c_visuals.enemy_material:get())[2]:set_flag(e_material_flags.IGNOREZ, true)
	        ctx:draw_material(get_material(c_cfg.table.c_visuals.enemy_material:get())[2])
	    end

        if c_cfg.table.c_visuals.enemy_original:get() then
            ctx.override_original = false
        end
    end

    if c_cfg.table.c_visuals.team_enable:get() and model:find("models/player") and ctx.entity:is_valid() and ctx.entity:is_player() and not ctx.entity:is_enemy() and ctx.entity:get_name() ~= local_player:get_name() then
        local col = c_cfg.table.c_visuals.colors.team_color:get()

        if not c_cfg.table.c_visuals.team_original:get() then
            ctx.override_original = true

            get_material(c_cfg.table.c_visuals.team_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.team_material:get())[2]:alpha_modulate(col.a / 255)
    
            get_material(c_cfg.table.c_visuals.team_material:get())[2]:set_flag(e_material_flags.IGNOREZ, true)
            ctx:draw_material(get_material(c_cfg.table.c_visuals.team_material:get())[2])
        end

	    if c_cfg.table.c_visuals.team_material:get() == 4 or c_cfg.table.c_visuals.team_material:get() == 5 or c_cfg.table.c_visuals.team_material:get() == 6 or c_cfg.table.c_visuals.team_material:get() == 7 then
			ctx.override_original = true

	        get_material(c_cfg.table.c_visuals.team_material_2:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
	        get_material(c_cfg.table.c_visuals.team_material_2:get())[2]:alpha_modulate(c_cfg.table.c_visuals.team_original:get() and 0 or col.a / 255)

	        ctx:draw_material(get_material(c_cfg.table.c_visuals.team_material_2:get())[2])

			local col = c_cfg.table.c_visuals.colors.team_overlay_color:get()
			glow_material[2]:set_shader_param("$envmaptint", vec3_t(col.r / 255, col.g / 255, col.b / 255))
		    get_material(c_cfg.table.c_visuals.team_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.team_material:get())[2]:alpha_modulate(col.a / 255)
  
            get_material(c_cfg.table.c_visuals.team_material:get())[2]:set_flag(e_material_flags.IGNOREZ, true)
	        ctx:draw_material(get_material(c_cfg.table.c_visuals.team_material:get())[2])
	    end

        if c_cfg.table.c_visuals.team_original:get() then
            ctx.override_original = false
        end
    end

    if c_cfg.table.c_visuals.local_enable:get() and model:find("models/player") and ctx.entity:is_valid() and ctx.entity:is_player() and ctx.entity:get_name() == local_player:get_name() then
        local col = c_cfg.table.c_visuals.colors.local_color:get()

        if not c_cfg.table.c_visuals.local_original:get() then
            ctx.override_original = true

            get_material(c_cfg.table.c_visuals.local_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.local_material:get())[2]:alpha_modulate(col.a / 255)
    
            get_material(c_cfg.table.c_visuals.local_material:get())[2]:set_flag(e_material_flags.IGNOREZ, false)
            ctx:draw_material(get_material(c_cfg.table.c_visuals.local_material:get())[2])
        end

	    if c_cfg.table.c_visuals.local_material:get() == 4 or c_cfg.table.c_visuals.local_material:get() == 5 or c_cfg.table.c_visuals.local_material:get() == 6 or c_cfg.table.c_visuals.local_material:get() == 7 then
			ctx.override_original = true

	        get_material(c_cfg.table.c_visuals.local_material_2:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
	        get_material(c_cfg.table.c_visuals.local_material_2:get())[2]:alpha_modulate(c_cfg.table.c_visuals.local_original:get() and 0 or col.a / 255)

	        ctx:draw_material(get_material(c_cfg.table.c_visuals.local_material_2:get())[2])

			local col = c_cfg.table.c_visuals.colors.local_overlay_color:get()
			glow_material[2]:set_shader_param("$envmaptint", vec3_t(col.r / 255, col.g / 255, col.b / 255))
		    get_material(c_cfg.table.c_visuals.local_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.local_material:get())[2]:alpha_modulate(col.a / 255)
  
            get_material(c_cfg.table.c_visuals.local_material:get())[2]:set_flag(e_material_flags.IGNOREZ, false)
	        ctx:draw_material(get_material(c_cfg.table.c_visuals.local_material:get())[2])
	    end

        if c_cfg.table.c_visuals.local_original:get() then
            ctx.override_original = false
        end
    end

    if not c_cfg.table.c_visuals.remove_sleeves:get() and (c_cfg.table.c_visuals.arms_enable:get() and not model:find("w_models") and (model:find("arms") or model:find("sleeve"))) then
        local col = c_cfg.table.c_visuals.colors.arms_color:get()

        if not c_cfg.table.c_visuals.arms_original:get() then
            ctx.override_original = true

            get_material(c_cfg.table.c_visuals.arms_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.arms_material:get())[2]:alpha_modulate(col.a / 255)
    
            get_material(c_cfg.table.c_visuals.arms_material:get())[2]:set_flag(e_material_flags.IGNOREZ, false)
            ctx:draw_material(get_material(c_cfg.table.c_visuals.arms_material:get())[2])
        end

	    if c_cfg.table.c_visuals.arms_material:get() == 4 or c_cfg.table.c_visuals.arms_material:get() == 5 or c_cfg.table.c_visuals.arms_material:get() == 6 or c_cfg.table.c_visuals.arms_material:get() == 7 then
		    ctx.override_original = true

	        get_material(c_cfg.table.c_visuals.arms_material_2:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
	        get_material(c_cfg.table.c_visuals.arms_material_2:get())[2]:alpha_modulate(c_cfg.table.c_visuals.arms_original:get() and 0 or col.a / 255)
    
	        ctx:draw_material(get_material(c_cfg.table.c_visuals.arms_material_2:get())[2])

			local col = c_cfg.table.c_visuals.colors.arms_overlay_color:get()
			glow_material[2]:set_shader_param("$envmaptint", vec3_t(col.r / 255, col.g / 255, col.b / 255))
		    get_material(c_cfg.table.c_visuals.arms_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.arms_material:get())[2]:alpha_modulate(col.a / 255)
  
            get_material(c_cfg.table.c_visuals.arms_material:get())[2]:set_flag(e_material_flags.IGNOREZ, false)
	        ctx:draw_material(get_material(c_cfg.table.c_visuals.arms_material:get())[2])
	    end

        if c_cfg.table.c_visuals.arms_original:get() then
            ctx.override_original = false
        end
    elseif c_cfg.table.c_visuals.remove_sleeves:get() and c_cfg.table.c_visuals.arms_enable:get() and not model:find("w_models") and (model:find("arms") and not model:find("sleeve")) then
        local col = c_cfg.table.c_visuals.colors.arms_color:get()

        if not c_cfg.table.c_visuals.arms_original:get() then
            ctx.override_original = true

            get_material(c_cfg.table.c_visuals.arms_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.arms_material:get())[2]:alpha_modulate(col.a / 255)
    
            get_material(c_cfg.table.c_visuals.arms_material:get())[2]:set_flag(e_material_flags.IGNOREZ, false)
            ctx:draw_material(get_material(c_cfg.table.c_visuals.arms_material:get())[2])
        end

	    if c_cfg.table.c_visuals.arms_material:get() == 4 or c_cfg.table.c_visuals.arms_material:get() == 5 or c_cfg.table.c_visuals.arms_material:get() == 6 or c_cfg.table.c_visuals.arms_material:get() == 7 then
		    ctx.override_original = true

	        get_material(c_cfg.table.c_visuals.arms_material_2:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
	        get_material(c_cfg.table.c_visuals.arms_material_2:get())[2]:alpha_modulate(c_cfg.table.c_visuals.arms_original:get() and 0 or col.a / 255)
    
	        ctx:draw_material(get_material(c_cfg.table.c_visuals.arms_material_2:get())[2])

			local col = c_cfg.table.c_visuals.colors.arms_overlay_color:get()
			glow_material[2]:set_shader_param("$envmaptint", vec3_t(col.r / 255, col.g / 255, col.b / 255))
		    get_material(c_cfg.table.c_visuals.arms_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.arms_material:get())[2]:alpha_modulate(col.a / 255)
  
            get_material(c_cfg.table.c_visuals.arms_material:get())[2]:set_flag(e_material_flags.IGNOREZ, false)
	        ctx:draw_material(get_material(c_cfg.table.c_visuals.arms_material:get())[2])
	    end

        if c_cfg.table.c_visuals.arms_original:get() then
            ctx.override_original = false
        end
    end

    if c_cfg.table.c_visuals.remove_sleeves:get() and not model:find("w_models") and model:find("sleeve") then
        local col = c_cfg.table.c_visuals.colors.arms_color:get()

	    ctx.override_original = true

	    get_material(c_cfg.table.c_visuals.arms_material:get())[2]:color_modulate(255,255,255)
        get_material(c_cfg.table.c_visuals.arms_material:get())[2]:alpha_modulate(0)
    end

    if c_cfg.table.c_visuals.weapon_enable:get() and model:find("weapons/v_") and not model:find("arms") then
        local col = c_cfg.table.c_visuals.colors.weapon_color:get()

        if not c_cfg.table.c_visuals.weapon_original:get() then
            ctx.override_original = true

            get_material(c_cfg.table.c_visuals.weapon_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.weapon_material:get())[2]:alpha_modulate(col.a / 255)
    
            get_material(c_cfg.table.c_visuals.weapon_material:get())[2]:set_flag(e_material_flags.IGNOREZ, false)
            ctx:draw_material(get_material(c_cfg.table.c_visuals.weapon_material:get())[2])
        end

	    if c_cfg.table.c_visuals.weapon_material:get() == 4 or c_cfg.table.c_visuals.weapon_material:get() == 5 or c_cfg.table.c_visuals.weapon_material:get() == 6 or c_cfg.table.c_visuals.weapon_material:get() == 7 then
			ctx.override_original = true

	        get_material(c_cfg.table.c_visuals.weapon_material_2:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
	        get_material(c_cfg.table.c_visuals.weapon_material_2:get())[2]:alpha_modulate(c_cfg.table.c_visuals.weapon_original:get() and 0 or col.a / 255)

            get_material(c_cfg.table.c_visuals.weapon_material_2:get())[2]:set_flag(e_material_flags.IGNOREZ, false)
	        ctx:draw_material(get_material(c_cfg.table.c_visuals.weapon_material_2:get())[2])

			local col = c_cfg.table.c_visuals.colors.weapon_overlay_color:get()
			glow_material[2]:set_shader_param("$envmaptint", vec3_t(col.r / 255, col.g / 255, col.b / 255))
		    get_material(c_cfg.table.c_visuals.weapon_material:get())[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
            get_material(c_cfg.table.c_visuals.weapon_material:get())[2]:alpha_modulate(col.a / 255)
  
            get_material(c_cfg.table.c_visuals.weapon_material:get())[2]:set_flag(e_material_flags.IGNOREZ, false)
	        ctx:draw_material(get_material(c_cfg.table.c_visuals.weapon_material:get())[2])
	    end

        if c_cfg.table.c_visuals.weapon_original:get() then
            ctx.override_original = false
        end
    end
end)


---------------------------------------------------------------------------------------------------------------------------------------- hitmarker

local pixel = render.create_font("Smallest Pixel-7", 14, 25, e_font_flags.DROPSHADOW)

-- hitmarker variables
local enableHitmarker = menu.add_checkbox("hitmarker", "world hitmarker", true)
local hitmarkerColor = enableHitmarker:add_color_picker("hitmarker color")

-- damage hitmarker variables
local damageHitmarker = menu.add_checkbox("hitmarker", "show damage", true)
local damageColor = damageHitmarker:add_color_picker("damage color")

-- hitmarker height / width
local hitmarkerHeight = menu.add_slider("hitmarker", "hitmarker width", 1, 4)
local hitmarkerWidth = menu.add_slider("hitmarker", "hitmarker height", 1, 20, 2)


-- called whenever primordial would call a world hitmarker
local function on_world_hitmarker(screen_pos, world_pos, alpha_factor, damage, is_lethal, is_headshot)

    -- checks if the checkbox is ticked
    if enableHitmarker:get() then

        -- draws the vertical line
        render.rect_filled(vec2_t(screen_pos.x-hitmarkerHeight:get()/2, screen_pos.y-hitmarkerWidth:get()/2), vec2_t(hitmarkerHeight:get(), hitmarkerWidth:get()), hitmarkerColor:get())
        
        -- draws the horizontal line
        render.rect_filled(vec2_t(screen_pos.x-hitmarkerWidth:get()/2, screen_pos.y-hitmarkerHeight:get()/2), vec2_t(hitmarkerWidth:get(), hitmarkerHeight:get()), hitmarkerColor:get())
        
        -- checks if the second checkbox is ticked
        if damageHitmarker:get() then

            -- converts the damage variable called by the function from integer to string as render.text requires the second parameter to be a string
            local damageString = tostring(damage)
            
            -- render damage text
            render.text(pixel, damageString, vec2_t(screen_pos.x-hitmarkerWidth:get()/2, screen_pos.y-25), damageColor(damageColor.x, damageColor.y, damageColor.z, damageColor.alpha))
        end
    end
    return true
end

callbacks.add(e_callbacks.WORLD_HITMARKER, on_world_hitmarker)

----------------------------------------------------------------------------------------------------------------------------------------------------- autopeek


local enable = menu.add_checkbox("auto peek", "enable autopeek circle", false)
local colour = enable:add_color_picker("color")

function world_circle(origin, radius, color)
	local previous_screen_pos, screen

    for i = 0, radius*2 do
		local pos = vec3_t(radius * math.cos(i/3) + origin.x, radius * math.sin(i/3) + origin.y, origin.z);

        local screen = render.world_to_screen(pos)
        if not screen then return end
		if screen.x ~= nil and previous_screen_pos then
            render.line(previous_screen_pos, screen, color)
			previous_screen_pos = screen
        elseif screen.x ~= nil then
            previous_screen_pos = screen
		end
	end
end

function draw()
    if ragebot.get_autopeek_pos() and enable:get() then
        world_circle(ragebot.get_autopeek_pos(), 15, colour:get())
    end
end

callbacks.add(e_callbacks.PAINT, draw)



------------------------------------------------------------------------------------------------------ aa