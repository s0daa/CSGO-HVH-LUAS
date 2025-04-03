------Welcome message-----

local text1 = menu.add_text("Welcome", "Thanks for using my lua!")
local text2 = menu.add_text("Welcome", "Made by pyr8#0001 or uid 2431 on forum")
local text2 = menu.add_text("Welcome", "Last update: 04/06/2022")

-------Menu elements------

local multi_selection = menu.add_multi_selection("Extra", "animlayer mods", {"reversed legs", "Static when slow walk", "static legs in air", "Lean when running"})
local find_slow_walk_name, find_slow_walk_key = unpack(menu.find("misc","main","movement","slow walk"))
local custom_font_enable = menu.add_checkbox("Extra", "Custom ESP font")
local font1 = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local font2 = render.create_font("Small Fonts", 8, 550, e_font_flags.DROPSHADOW)

--------Animations--------

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    local lp = entity_list.get_local_player()
	local sexgod = lp:get_prop("m_vecVelocity[1]") ~= 0	
	if multi_selection:get(1) then
		ctx:set_render_pose(e_poses.RUN, 0)
	end

    if find_slow_walk_key:get() and multi_selection:get(2) then
		ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0)
	end

    if multi_selection:get(4) then
        if sexgod then
            ctx:set_render_animlayer(e_animlayers.LEAN, 1)
        end
    end

    if find_slow_walk_key:get() then
        ctx:set_render_animlayer(e_animlayers.LEAN, 0)
    end

    if multi_selection:get(3) then
        ctx:set_render_pose(e_poses.JUMP_FALL, 1)
    end
end)

--------CustomFont--------

local function on_player_esp(sex)
    if custom_font_enable:get() then
        sex:set_font(font1)
        sex:set_small_font(font2)
    end
end
callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)