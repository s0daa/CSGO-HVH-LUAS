local wp_to_cfg = 'Global'
local cfg_to_name = string.format('[%s]', wp_to_cfg)
local ovr_hc, ovr_dmg = 0, 0

local g_ui = {
	enabled = { ui.reference('rage', 'aimbot', 'enabled') },
	target_selection = { ui.reference('rage', 'aimbot', 'target selection') },
	target_hitbox = { ui.reference('rage', 'aimbot', 'target hitbox') },
	multi_point = { ui.reference('rage', 'aimbot', 'multi-point') },
	avoid_unsafe_hitboxes  = { ui.reference('rage', 'aimbot', 'avoid unsafe hitboxes') },

	automatic_fire = { ui.reference('rage', 'other', 'automatic fire') },
	automatic_penetration = { ui.reference('rage', 'other', 'automatic penetration') },
	silent_aim = { ui.reference('rage', 'other', 'silent aim') },

	automatic_scope = { ui.reference('rage', 'aimbot', 'automatic scope') },
	reduce_aim_step = { ui.reference('rage', 'other', 'reduce aim step') },
	maximum_fov = { ui.reference('rage', 'other', 'maximum fov') },

	multi_point_scale = { ui.reference('rage', 'aimbot', 'multi-point scale') },
	minimum_hit_chance = { ui.reference('rage', 'aimbot', 'minimum hit chance') },
	minimum_damage = { ui.reference('rage', 'aimbot', 'minimum damage') },
	prefer_safe_point = { ui.reference('rage', 'aimbot', 'prefer safe point') },

	delay_shot = { ui.reference('rage', 'other', 'delay shot') },
	accuracy_boost = { ui.reference('rage', 'other', 'accuracy boost') },
	remove_recoil = { ui.reference('rage', 'other', 'remove recoil') },
	anti_aim_correction = { ui.reference('rage', 'other', 'anti-aim correction') },

	quick_stop = { ui.reference('rage', 'aimbot', 'quick stop') },

	prefer_body_aim = { ui.reference('rage', 'aimbot', 'prefer body aim') },
	prefer_body_aim_disablers  = { ui.reference('rage', 'aimbot', 'prefer body aim disablers') },

}

local g_new_ui = {
	--full_switch
	global_text_1 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> Adaptive selection <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	full_switch =  ui.new_checkbox('rage', 'aimbot', 'Enabled'),
	state = ui.new_combobox('rage', 'aimbot', 'Weapon type', 'Global', 'Scout', 'Awp', 'Auto Sniper', 'Heavy pistol', 'Pistol', 'Shotgun', 'Taser'),

	indicator_switch = ui.new_checkbox('rage', 'aimbot', 'Enable indicator'),
	indicator_color = ui.new_color_picker('rage', 'aimbot', 'Indicator color', 150, 150, 150, 255),
	
		--global
		global_text_1 = {
			ui.new_label('rage', 'aimbot', '\n'),
			ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Global] Main <'),
			ui.new_label('rage', 'aimbot', '\n')
		},

		global_enable = ui.new_checkbox('rage', 'aimbot', '[Global] Preset'),
		global_target_selection =  ui.new_combobox('rage', 'aimbot', '[Global] Target selection', 'Highest damage', 'Cycle', 'Cycle (2x)', 'Near crosshair', 'Best hit chance'),
		global_accuracy_boost =  ui.new_combobox('rage', 'aimbot', '[Global] Accuracy boost', 'Low', 'Medium', 'High', 'Maximum'),
		global_target_hitbox =  ui.new_multiselect('rage', 'aimbot', '[Global] Target hitbox', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
		global_multi_point =  ui.new_multiselect('rage', 'aimbot', '[Global] Multi point', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
		global_avoid_unsafe_hitboxes =  ui.new_multiselect('rage', 'aimbot', '[Global] Avoid unsafe hitboxes', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
		global_quick_stop_options =  ui.new_multiselect('rage', 'aimbot', '[Global] Quick stop options', 'Early', 'Slow motion', 'Duck', 'Fake duck', 'Move between shots', 'Ignore molotov', 'Taser'),

		global_prefer_body_aim_disablers =  ui.new_multiselect('rage', 'aimbot', '[Global] Prefer body aim disablers', 'Low inaccuracy', 'Target shot fired', 'Target resolved', 'Safe point headshot'),
	

		global_text_2 = {
			ui.new_label('rage', 'aimbot', '\n'),
			ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Global] Aimbot <'),
			ui.new_label('rage', 'aimbot', '\n')
		},

		global_automatic_fire =  ui.new_checkbox('rage', 'aimbot', '[Global] Automatic fire'),
		global_automatic_penetration =  ui.new_checkbox('rage', 'aimbot', '[Global] Automatic penetration'),
		global_silent_aim =  ui.new_checkbox('rage', 'aimbot', '[Global] Silent aim'),
		global_quick_stop =  ui.new_checkbox('rage', 'aimbot', '[Global] Quick stop'),
		global_automatic_scope = ui.new_checkbox('rage', 'aimbot', '[Global] Automatic scope'),
		global_reduce_aim_step = ui.new_checkbox('rage', 'aimbot', '[Global] Reduce aim step'),
		global_maximum_fov = ui.new_slider('rage', 'aimbot', '[Global] Maximum FOV', 1, 180, 180, true, '°'),

		global_text_3 = {
			ui.new_label('rage', 'aimbot', '\n'),
			ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Global] Other <'),
			ui.new_label('rage', 'aimbot', '\n')
		},
		
		global_remove_recoil =  ui.new_checkbox('rage', 'aimbot', '[Global] Remove recoil'),
		global_anti_aim_correction =  ui.new_checkbox('rage', 'aimbot', '[Global] Anti-aim correction'),

		global_delay_shot =  ui.new_checkbox('rage', 'aimbot', '[Global] Delay shot'),
		global_prefer_safe_point =  ui.new_checkbox('rage', 'aimbot', '[Global] Prefer safe point'),
		global_prefer_body_aim =  ui.new_checkbox('rage', 'aimbot', '[Global] Prefer body aim'),

		global_multi_point_scale =  ui.new_slider('rage', 'aimbot', '[Global] Multi-point scale', 24, 100, 90, true, '%', 1, { [24] = 'Auto' } ),
		global_minimum_hit_chance =  ui.new_slider('rage', 'aimbot', '[Global] Minimum hitchance', 0, 100, 50, true, '%', 1, { [0] = 'Off' } ),
		global_extra_minimum_hit_chance =  { ui.new_slider('rage', 'aimbot', '[Global] Override Minimum hitchance', 0, 100, 60, true, '%', 1, { [0] = 'Off' } ), ui.new_hotkey('rage', 'aimbot', '[Global] Override Minimum hitchance', true) },	--extra_hitchance
		global_minimum_damage =  ui.new_slider('rage', 'aimbot', '[Global] Minimum damage', 0, 126, 10, true, '', 1, { [0] = 'Auto' } ),
		global_extra_minimum_damage =  { ui.new_slider('rage', 'aimbot', '[Global] Override Minimum damage',0, 126, 20, true, '', 1, { [0] = 'Auto' } ), ui.new_hotkey('rage', 'aimbot', '[Global] Override Minimum damage', true) },	--extra_damage
	
	--ssg08
	ssg08_text_1 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Scout] Main <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	ssg08_enable = ui.new_checkbox('rage', 'aimbot', '[Scout] Preset'),
	ssg08_target_selection =  ui.new_combobox('rage', 'aimbot', '[Scout] Target selection', 'Highest damage', 'Cycle', 'Cycle (2x)', 'Near crosshair', 'Best hit chance'),
	ssg08_accuracy_boost =  ui.new_combobox('rage', 'aimbot', '[Scout] Accuracy boost', 'Low', 'Medium', 'High', 'Maximum'),
	ssg08_target_hitbox =  ui.new_multiselect('rage', 'aimbot', '[Scout] Target hitbox', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	ssg08_multi_point =  ui.new_multiselect('rage', 'aimbot', '[Scout] Multi point', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	ssg08_avoid_unsafe_hitboxes =  ui.new_multiselect('rage', 'aimbot', '[Scout] Avoid unsafe hitboxes', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	ssg08_quick_stop_options =  ui.new_multiselect('rage', 'aimbot', '[Scout] Quick stop options', 'Early', 'Slow motion', 'Duck', 'Fake duck', 'Move between shots', 'Ignore molotov', 'Taser'),

	ssg08_prefer_body_aim_disablers =  ui.new_multiselect('rage', 'aimbot', '[Scout] Prefer body aim disablers', 'Low inaccuracy', 'Target shot fired', 'Target resolved', 'Safe point headshot'),


	ssg08_text_2 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Scout] Aimbot <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	ssg08_automatic_fire =  ui.new_checkbox('rage', 'aimbot', '[Scout] Automatic fire'),
	ssg08_automatic_penetration =  ui.new_checkbox('rage', 'aimbot', '[Scout] Automatic penetration'),
	ssg08_silent_aim =  ui.new_checkbox('rage', 'aimbot', '[Scout] Silent aim'),
	ssg08_quick_stop =  ui.new_checkbox('rage', 'aimbot', '[Scout] Quick stop'),
	ssg08_automatic_scope = ui.new_checkbox('rage', 'aimbot', '[Scout] Automatic scope'),
	ssg08_reduce_aim_step = ui.new_checkbox('rage', 'aimbot', '[Scout] Reduce aim step'),
	ssg08_maximum_fov = ui.new_slider('rage', 'aimbot', '[Scout] Maximum FOV', 1, 180, 180, true, '°'),

	ssg08_text_3 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Scout] Other <'),
		ui.new_label('rage', 'aimbot', '\n')
	},
	
	ssg08_remove_recoil =  ui.new_checkbox('rage', 'aimbot', '[Scout] Remove recoil'),
	ssg08_anti_aim_correction =  ui.new_checkbox('rage', 'aimbot', '[Scout] Anti-aim correction'),

	ssg08_delay_shot =  ui.new_checkbox('rage', 'aimbot', '[Scout] Delay shot'),
	ssg08_prefer_safe_point =  ui.new_checkbox('rage', 'aimbot', '[Scout] Prefer safe point'),
	ssg08_prefer_body_aim =  ui.new_checkbox('rage', 'aimbot', '[Scout] Prefer body aim'),

	ssg08_multi_point_scale =  ui.new_slider('rage', 'aimbot', '[Scout] Multi-point scale', 24, 100, 90, true, '%', 1, { [24] = 'Auto' } ),
	ssg08_minimum_hit_chance =  ui.new_slider('rage', 'aimbot', '[Scout] Minimum hitchance', 0, 100, 50, true, '%', 1, { [0] = 'Off' } ),
	ssg08_extra_minimum_hit_chance =  { ui.new_slider('rage', 'aimbot', '[Scout] Override Minimum hitchance', 0, 100, 60, true, '%', 1, { [0] = 'Off' } ), ui.new_hotkey('rage', 'aimbot', '[Scout] Override Minimum hitchance', true) },	--extra_hitchance
	ssg08_minimum_damage =  ui.new_slider('rage', 'aimbot', '[Scout] Minimum damage', 0, 126, 10, true, '', 1, { [0] = 'Auto' } ),
	ssg08_extra_minimum_damage =  { ui.new_slider('rage', 'aimbot', '[Scout] Override Minimum damage',0, 126, 20, true, '', 1, { [0] = 'Auto' } ), ui.new_hotkey('rage', 'aimbot', '[Scout] Override Minimum damage', true) },	--extra_damage


	--awp
	awp_text_1 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Awp] Main <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	awp_enable = ui.new_checkbox('rage', 'aimbot', '[Awp] Preset'),
	awp_target_selection =  ui.new_combobox('rage', 'aimbot', '[Awp] Target selection', 'Highest damage', 'Cycle', 'Cycle (2x)', 'Near crosshair', 'Best hit chance'),
	awp_accuracy_boost =  ui.new_combobox('rage', 'aimbot', '[Awp] Accuracy boost', 'Low', 'Medium', 'High', 'Maximum'),
	awp_target_hitbox =  ui.new_multiselect('rage', 'aimbot', '[Awp] Target hitbox', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	awp_multi_point =  ui.new_multiselect('rage', 'aimbot', '[Awp] Multi point', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	awp_avoid_unsafe_hitboxes =  ui.new_multiselect('rage', 'aimbot', '[Awp] Avoid unsafe hitboxes', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	awp_quick_stop_options =  ui.new_multiselect('rage', 'aimbot', '[Awp] Quick stop options', 'Early', 'Slow motion', 'Duck', 'Fake duck', 'Move between shots', 'Ignore molotov', 'Taser'),

	awp_prefer_body_aim_disablers =  ui.new_multiselect('rage', 'aimbot', '[Awp] Prefer body aim disablers', 'Low inaccuracy', 'Target shot fired', 'Target resolved', 'Safe point headshot'),


	awp_text_2 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Awp] Aimbot <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	awp_automatic_fire =  ui.new_checkbox('rage', 'aimbot', '[Awp] Automatic fire'),
	awp_automatic_penetration =  ui.new_checkbox('rage', 'aimbot', '[Awp] Automatic penetration'),
	awp_silent_aim =  ui.new_checkbox('rage', 'aimbot', '[Awp] Silent aim'),
	awp_quick_stop =  ui.new_checkbox('rage', 'aimbot', '[Awp] Quick stop'),
	awp_automatic_scope = ui.new_checkbox('rage', 'aimbot', '[Awp] Automatic scope'),
	awp_reduce_aim_step = ui.new_checkbox('rage', 'aimbot', '[Awp] Reduce aim step'),
	awp_maximum_fov = ui.new_slider('rage', 'aimbot', '[Awp] Maximum FOV', 1, 180, 180, true, '°'),

	awp_text_3 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Awp] Other <'),
		ui.new_label('rage', 'aimbot', '\n')
	},
	
	awp_remove_recoil =  ui.new_checkbox('rage', 'aimbot', '[Awp] Remove recoil'),
	awp_anti_aim_correction =  ui.new_checkbox('rage', 'aimbot', '[Awp] Anti-aim correction'),

	awp_delay_shot =  ui.new_checkbox('rage', 'aimbot', '[Awp] Delay shot'),
	awp_prefer_safe_point =  ui.new_checkbox('rage', 'aimbot', '[Awp] Prefer safe point'),
	awp_prefer_body_aim =  ui.new_checkbox('rage', 'aimbot', '[Awp] Prefer body aim'),

	awp_multi_point_scale =  ui.new_slider('rage', 'aimbot', '[Awp] Multi-point scale', 24, 100, 90, true, '%', 1, { [24] = 'Auto' } ),
	awp_minimum_hit_chance =  ui.new_slider('rage', 'aimbot', '[Awp] Minimum hitchance', 0, 100, 50, true, '%', 1, { [0] = 'Off' } ),
	awp_extra_minimum_hit_chance =  { ui.new_slider('rage', 'aimbot', '[Awp] Override Minimum hitchance', 0, 100, 60, true, '%', 1, { [0] = 'Off' } ), ui.new_hotkey('rage', 'aimbot', '[Awp] Override Minimum hitchance', true) },	--extra_hitchance
	awp_minimum_damage =  ui.new_slider('rage', 'aimbot', '[Awp] Minimum damage', 0, 126, 10, true, '', 1, { [0] = 'Auto' } ),
	awp_extra_minimum_damage =  { ui.new_slider('rage', 'aimbot', '[Awp] Override Minimum damage',0, 126, 20, true, '', 1, { [0] = 'Auto' } ), ui.new_hotkey('rage', 'aimbot', '[Awp] Override Minimum damage', true) },	--extra_damage

	--auto
	auto_text_1 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Auto Sniper] Main <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	auto_enable = ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Preset'),
	auto_target_selection =  ui.new_combobox('rage', 'aimbot', '[Auto Sniper] Target selection', 'Highest damage', 'Cycle', 'Cycle (2x)', 'Near crosshair', 'Best hit chance'),
	auto_accuracy_boost =  ui.new_combobox('rage', 'aimbot', '[Auto Sniper] Accuracy boost', 'Low', 'Medium', 'High', 'Maximum'),
	auto_target_hitbox =  ui.new_multiselect('rage', 'aimbot', '[Auto Sniper] Target hitbox', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	auto_multi_point =  ui.new_multiselect('rage', 'aimbot', '[Auto Sniper] Multi point', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	auto_avoid_unsafe_hitboxes =  ui.new_multiselect('rage', 'aimbot', '[Auto Sniper] Avoid unsafe hitboxes', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	auto_quick_stop_options =  ui.new_multiselect('rage', 'aimbot', '[Auto Sniper] Quick stop options', 'Early', 'Slow motion', 'Duck', 'Fake duck', 'Move between shots', 'Ignore molotov', 'Taser'),

	auto_prefer_body_aim_disablers =  ui.new_multiselect('rage', 'aimbot', '[Auto Sniper] Prefer body aim disablers', 'Low inaccuracy', 'Target shot fired', 'Target resolved', 'Safe point headshot'),


	auto_text_2 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Auto Sniper] Aimbot <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	auto_automatic_fire =  ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Automatic fire'),
	auto_automatic_penetration =  ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Automatic penetration'),
	auto_silent_aim =  ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Silent aim'),
	auto_quick_stop =  ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Quick stop'),
	auto_automatic_scope = ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Automatic scope'),
	auto_reduce_aim_step = ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Reduce aim step'),
	auto_maximum_fov = ui.new_slider('rage', 'aimbot', '[Auto Sniper] Maximum FOV', 1, 180, 180, true, '°'),

	auto_text_3 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Auto Sniper] Other <'),
		ui.new_label('rage', 'aimbot', '\n')
	},
	
	auto_remove_recoil =  ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Remove recoil'),
	auto_anti_aim_correction =  ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Anti-aim correction'),

	auto_delay_shot =  ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Delay shot'),
	auto_prefer_safe_point =  ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Prefer safe point'),
	auto_prefer_body_aim =  ui.new_checkbox('rage', 'aimbot', '[Auto Sniper] Prefer body aim'),

	auto_multi_point_scale =  ui.new_slider('rage', 'aimbot', '[Auto Sniper] Multi-point scale', 24, 100, 90, true, '%', 1, { [24] = 'Auto' } ),
	auto_minimum_hit_chance =  ui.new_slider('rage', 'aimbot', '[Auto Sniper] Minimum hitchance', 0, 100, 50, true, '%', 1, { [0] = 'Off' } ),
	auto_extra_minimum_hit_chance =  { ui.new_slider('rage', 'aimbot', '[Auto Sniper] Override Minimum hitchance', 0, 100, 60, true, '%', 1, { [0] = 'Off' } ), ui.new_hotkey('rage', 'aimbot', '[Auto Sniper] Override Minimum hitchance', true) },	--extra_hitchance
	auto_minimum_damage =  ui.new_slider('rage', 'aimbot', '[Auto Sniper] Minimum damage', 0, 126, 10, true, '', 1, { [0] = 'Auto' } ),
	auto_extra_minimum_damage =  { ui.new_slider('rage', 'aimbot', '[Auto Sniper] Override Minimum damage',0, 126, 20, true, '', 1, { [0] = 'Auto' } ), ui.new_hotkey('rage', 'aimbot', '[Auto Sniper] Override Minimum damage', true) },	--extra_damage

	--heavy_pistol
	heavy_pistol_text_1 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Heavy pistol] Main <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	heavy_pistol_enable = ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Preset'),
	heavy_pistol_target_selection =  ui.new_combobox('rage', 'aimbot', '[Heavy pistol] Target selection', 'Highest damage', 'Cycle', 'Cycle (2x)', 'Near crosshair', 'Best hit chance'),
	heavy_pistol_accuracy_boost =  ui.new_combobox('rage', 'aimbot', '[Heavy pistol] Accuracy boost', 'Low', 'Medium', 'High', 'Maximum'),
	heavy_pistol_target_hitbox =  ui.new_multiselect('rage', 'aimbot', '[Heavy pistol] Target hitbox', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	heavy_pistol_multi_point =  ui.new_multiselect('rage', 'aimbot', '[Heavy pistol] Multi point', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	heavy_pistol_avoid_unsafe_hitboxes =  ui.new_multiselect('rage', 'aimbot', '[Heavy pistol] Avoid unsafe hitboxes', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	heavy_pistol_quick_stop_options =  ui.new_multiselect('rage', 'aimbot', '[Heavy pistol] Quick stop options', 'Early', 'Slow motion', 'Duck', 'Fake duck', 'Move between shots', 'Ignore molotov', 'Taser'),

	heavy_pistol_prefer_body_aim_disablers =  ui.new_multiselect('rage', 'aimbot', '[Heavy pistol] Prefer body aim disablers', 'Low inaccuracy', 'Target shot fired', 'Target resolved', 'Safe point headshot'),

	heavy_pistol_text_2 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Heavy pistol] Aimbot <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	heavy_pistol_automatic_fire =  ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Automatic fire'),
	heavy_pistol_automatic_penetration =  ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Automatic penetration'),
	heavy_pistol_silent_aim =  ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Silent aim'),
	heavy_pistol_quick_stop =  ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Quick stop'),
	heavy_pistol_automatic_scope = ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Automatic scope'),
	heavy_pistol_reduce_aim_step = ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Reduce aim step'),
	heavy_pistol_maximum_fov = ui.new_slider('rage', 'aimbot', '[Heavy pistol] Maximum FOV', 1, 180, 180, true, '°'),

	heavy_pistol_text_3 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Heavy pistol] Other <'),
		ui.new_label('rage', 'aimbot', '\n')
	},
	
	heavy_pistol_remove_recoil =  ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Remove recoil'),
	heavy_pistol_anti_aim_correction =  ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Anti-aim correction'),

	heavy_pistol_delay_shot =  ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Delay shot'),
	heavy_pistol_prefer_safe_point =  ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Prefer safe point'),
	heavy_pistol_prefer_body_aim =  ui.new_checkbox('rage', 'aimbot', '[Heavy pistol] Prefer body aim'),

	heavy_pistol_multi_point_scale =  ui.new_slider('rage', 'aimbot', '[Heavy pistol] Multi-point scale', 24, 100, 90, true, '%', 1, { [24] = 'Auto' } ),
	heavy_pistol_minimum_hit_chance =  ui.new_slider('rage', 'aimbot', '[Heavy pistol] Minimum hitchance', 0, 100, 50, true, '%', 1, { [0] = 'Off' } ),
	heavy_pistol_extra_minimum_hit_chance =  { ui.new_slider('rage', 'aimbot', '[Heavy pistol] Override Minimum hitchance', 0, 100, 60, true, '%', 1, { [0] = 'Off' } ), ui.new_hotkey('rage', 'aimbot', '[Heavy pistol] Override Minimum hitchance', true) },	--extra_hitchance
	heavy_pistol_minimum_damage =  ui.new_slider('rage', 'aimbot', '[Heavy pistol] Minimum damage', 0, 126, 10, true, '', 1, { [0] = 'Auto' } ),
	heavy_pistol_extra_minimum_damage =  { ui.new_slider('rage', 'aimbot', '[Heavy pistol] Override Minimum damage',0, 126, 20, true, '', 1, { [0] = 'Auto' } ), ui.new_hotkey('rage', 'aimbot', '[Heavy pistol] Override Minimum damage', true) },	--extra_damage

	--pistol
	pistol_text_1 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Pistol] Main <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	pistol_enable = ui.new_checkbox('rage', 'aimbot', '[Pistol] Preset'),
	pistol_target_selection =  ui.new_combobox('rage', 'aimbot', '[Pistol] Target selection', 'Highest damage', 'Cycle', 'Cycle (2x)', 'Near crosshair', 'Best hit chance'),
	pistol_accuracy_boost =  ui.new_combobox('rage', 'aimbot', '[Pistol] Accuracy boost', 'Low', 'Medium', 'High', 'Maximum'),
	pistol_target_hitbox =  ui.new_multiselect('rage', 'aimbot', '[Pistol] Target hitbox', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	pistol_multi_point =  ui.new_multiselect('rage', 'aimbot', '[Pistol] Multi point', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	pistol_avoid_unsafe_hitboxes =  ui.new_multiselect('rage', 'aimbot', '[Pistol] Avoid unsafe hitboxes', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	pistol_quick_stop_options =  ui.new_multiselect('rage', 'aimbot', '[Pistol] Quick stop options', 'Early', 'Slow motion', 'Duck', 'Fake duck', 'Move between shots', 'Ignore molotov', 'Taser'),

	pistol_prefer_body_aim_disablers =  ui.new_multiselect('rage', 'aimbot', '[Pistol] Prefer body aim disablers', 'Low inaccuracy', 'Target shot fired', 'Target resolved', 'Safe point headshot'),


	pistol_text_2 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Pistol] Aimbot <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	pistol_automatic_fire =  ui.new_checkbox('rage', 'aimbot', '[Pistol] Automatic fire'),
	pistol_automatic_penetration =  ui.new_checkbox('rage', 'aimbot', '[Pistol] Automatic penetration'),
	pistol_silent_aim =  ui.new_checkbox('rage', 'aimbot', '[Pistol] Silent aim'),
	pistol_quick_stop =  ui.new_checkbox('rage', 'aimbot', '[Pistol] Quick stop'),
	pistol_automatic_scope = ui.new_checkbox('rage', 'aimbot', '[Pistol] Automatic scope'),
	pistol_reduce_aim_step = ui.new_checkbox('rage', 'aimbot', '[Pistol] Reduce aim step'),
	pistol_maximum_fov = ui.new_slider('rage', 'aimbot', '[Pistol] Maximum FOV', 1, 180, 180, true, '°'),

	pistol_text_3 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Pistol] Other <'),
		ui.new_label('rage', 'aimbot', '\n')
	},
	
	pistol_remove_recoil =  ui.new_checkbox('rage', 'aimbot', '[Pistol] Remove recoil'),
	pistol_anti_aim_correction =  ui.new_checkbox('rage', 'aimbot', '[Pistol] Anti-aim correction'),

	pistol_delay_shot =  ui.new_checkbox('rage', 'aimbot', '[Pistol] Delay shot'),
	pistol_prefer_safe_point =  ui.new_checkbox('rage', 'aimbot', '[Pistol] Prefer safe point'),
	pistol_prefer_body_aim =  ui.new_checkbox('rage', 'aimbot', '[Pistol] Prefer body aim'),

	pistol_multi_point_scale =  ui.new_slider('rage', 'aimbot', '[Pistol] Multi-point scale', 24, 100, 90, true, '%', 1, { [24] = 'Auto' } ),
	pistol_minimum_hit_chance =  ui.new_slider('rage', 'aimbot', '[Pistol] Minimum hitchance', 0, 100, 50, true, '%', 1, { [0] = 'Off' } ),
	pistol_extra_minimum_hit_chance =  { ui.new_slider('rage', 'aimbot', '[Pistol] Override Minimum hitchance', 0, 100, 60, true, '%', 1, { [0] = 'Off' } ), ui.new_hotkey('rage', 'aimbot', '[Pistol] Override Minimum hitchance', true) },	--extra_hitchance
	pistol_minimum_damage =  ui.new_slider('rage', 'aimbot', '[Pistol] Minimum damage', 0, 126, 10, true, '', 1, { [0] = 'Auto' } ),
	pistol_extra_minimum_damage =  { ui.new_slider('rage', 'aimbot', '[Pistol] Override Minimum damage',0, 126, 20, true, '', 1, { [0] = 'Auto' } ), ui.new_hotkey('rage', 'aimbot', '[Pistol] Override Minimum damage', true) },	--extra_damage

	--shotgun
	shotgun_text_1 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Shotgun] Main <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	shotgun_enable = ui.new_checkbox('rage', 'aimbot', '[Shotgun] Preset'),
	shotgun_target_selection =  ui.new_combobox('rage', 'aimbot', '[Shotgun] Target selection', 'Highest damage', 'Cycle', 'Cycle (2x)', 'Near crosshair', 'Best hit chance'),
	shotgun_accuracy_boost =  ui.new_combobox('rage', 'aimbot', '[Shotgun] Accuracy boost', 'Low', 'Medium', 'High', 'Maximum'),
	shotgun_target_hitbox =  ui.new_multiselect('rage', 'aimbot', '[Shotgun] Target hitbox', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	shotgun_multi_point =  ui.new_multiselect('rage', 'aimbot', '[Shotgun] Multi point', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	shotgun_avoid_unsafe_hitboxes =  ui.new_multiselect('rage', 'aimbot', '[Shotgun] Avoid unsafe hitboxes', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	shotgun_quick_stop_options =  ui.new_multiselect('rage', 'aimbot', '[Shotgun] Quick stop options', 'Early', 'Slow motion', 'Duck', 'Fake duck', 'Move between shots', 'Ignore molotov', 'Taser'),

	shotgun_prefer_body_aim_disablers =  ui.new_multiselect('rage', 'aimbot', '[Shotgun] Prefer body aim disablers', 'Low inaccuracy', 'Target shot fired', 'Target resolved', 'Safe point headshot'),

	shotgun_text_2 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Shotgun] Aimbot <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	shotgun_automatic_fire =  ui.new_checkbox('rage', 'aimbot', '[Shotgun] Automatic fire'),
	shotgun_automatic_penetration =  ui.new_checkbox('rage', 'aimbot', '[Shotgun] Automatic penetration'),
	shotgun_silent_aim =  ui.new_checkbox('rage', 'aimbot', '[Shotgun] Silent aim'),
	shotgun_quick_stop =  ui.new_checkbox('rage', 'aimbot', '[Shotgun] Quick stop'),
	shotgun_automatic_scope = ui.new_checkbox('rage', 'aimbot', '[Shotgun] Automatic scope'),
	shotgun_reduce_aim_step = ui.new_checkbox('rage', 'aimbot', '[Shotgun] Reduce aim step'),
	shotgun_maximum_fov = ui.new_slider('rage', 'aimbot', '[Shotgun] Maximum FOV', 1, 180, 180, true, '°'),

	shotgun_text_3 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Shotgun] Other <'),
		ui.new_label('rage', 'aimbot', '\n')
	},
	
	shotgun_remove_recoil =  ui.new_checkbox('rage', 'aimbot', '[Shotgun] Remove recoil'),
	shotgun_anti_aim_correction =  ui.new_checkbox('rage', 'aimbot', '[Shotgun] Anti-aim correction'),

	shotgun_delay_shot =  ui.new_checkbox('rage', 'aimbot', '[Shotgun] Delay shot'),
	shotgun_prefer_safe_point =  ui.new_checkbox('rage', 'aimbot', '[Shotgun] Prefer safe point'),
	shotgun_prefer_body_aim =  ui.new_checkbox('rage', 'aimbot', '[Shotgun] Prefer body aim'),

	shotgun_multi_point_scale =  ui.new_slider('rage', 'aimbot', '[Shotgun] Multi-point scale', 24, 100, 90, true, '%', 1, { [24] = 'Auto' } ),
	shotgun_minimum_hit_chance =  ui.new_slider('rage', 'aimbot', '[Shotgun] Minimum hitchance', 0, 100, 50, true, '%', 1, { [0] = 'Off' } ),
	shotgun_extra_minimum_hit_chance =  { ui.new_slider('rage', 'aimbot', '[Shotgun] Override Minimum hitchance', 0, 100, 60, true, '%', 1, { [0] = 'Off' } ), ui.new_hotkey('rage', 'aimbot', '[Shotgun] Override Minimum hitchance', true) },	--extra_hitchance
	shotgun_minimum_damage =  ui.new_slider('rage', 'aimbot', '[Shotgun] Minimum damage', 0, 126, 10, true, '', 1, { [0] = 'Auto' } ),
	shotgun_extra_minimum_damage =  { ui.new_slider('rage', 'aimbot', '[Shotgun] Override Minimum damage',0, 126, 20, true, '', 1, { [0] = 'Auto' } ), ui.new_hotkey('rage', 'aimbot', '[Shotgun] Override Minimum damage', true) },	--extra_damage

	--zeus
	zeus_text_1 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Taser]  Main <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	zeus_enable = ui.new_checkbox('rage', 'aimbot', '[Taser] Preset'),
	zeus_target_selection =  ui.new_combobox('rage', 'aimbot', '[Taser] Target selection', 'Highest damage', 'Cycle', 'Cycle (2x)', 'Near crosshair', 'Best hit chance'),
	zeus_accuracy_boost =  ui.new_combobox('rage', 'aimbot', '[Taser] Accuracy boost', 'Low', 'Medium', 'High', 'Maximum'),
	zeus_target_hitbox =  ui.new_multiselect('rage', 'aimbot', '[Taser] Target hitbox', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	zeus_multi_point =  ui.new_multiselect('rage', 'aimbot', '[Taser] Multi point', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	zeus_avoid_unsafe_hitboxes =  ui.new_multiselect('rage', 'aimbot', '[Taser] Avoid unsafe hitboxes', 'Head', 'Chest', 'Stomach', 'Arms', 'Legs',  'Feet'),
	zeus_quick_stop_options =  ui.new_multiselect('rage', 'aimbot', '[Taser] Quick stop options', 'Early', 'Slow motion', 'Duck', 'Fake duck', 'Move between shots', 'Ignore molotov', 'Taser'),
	zeus_prefer_body_aim_disablers =  ui.new_multiselect('rage', 'aimbot', '[Taser] Prefer body aim disablers', 'Low inaccuracy', 'Target shot fired', 'Target resolved', 'Safe point headshot'),


	zeus_text_2 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Taser] Aimbot <'),
		ui.new_label('rage', 'aimbot', '\n')
	},

	zeus_automatic_fire =  ui.new_checkbox('rage', 'aimbot', '[Taser] Automatic fire'),
	zeus_automatic_penetration =  ui.new_checkbox('rage', 'aimbot', '[Taser] Automatic penetration'),
	zeus_silent_aim =  ui.new_checkbox('rage', 'aimbot', '[Taser] Silent aim'),
	zeus_quick_stop =  ui.new_checkbox('rage', 'aimbot', '[Taser] Quick stop'),
	zeus_automatic_scope = ui.new_checkbox('rage', 'aimbot', '[Taser] Automatic scope'),
	zeus_reduce_aim_step = ui.new_checkbox('rage', 'aimbot', '[Taser] Reduce aim step'),
	zeus_maximum_fov = ui.new_slider('rage', 'aimbot', '[Taser] Maximum FOV', 1, 180, 180, true, '°'),

	zeus_text_3 = {
		ui.new_label('rage', 'aimbot', '\n'),
		ui.new_label('rage', 'aimbot', '\aFFC0CBFF> [Taser] Other <'),
		ui.new_label('rage', 'aimbot', '\n')
	},
	
	zeus_remove_recoil =  ui.new_checkbox('rage', 'aimbot', '[Taser] Remove recoil'),
	zeus_anti_aim_correction =  ui.new_checkbox('rage', 'aimbot', '[Taser] Anti-aim correction'),

	zeus_delay_shot =  ui.new_checkbox('rage', 'aimbot', '[Taser] Delay shot'),
	zeus_prefer_safe_point =  ui.new_checkbox('rage', 'aimbot', '[Taser] Prefer safe point'),
	zeus_prefer_body_aim =  ui.new_checkbox('rage', 'aimbot', '[Taser] Prefer body aim'),

	zeus_multi_point_scale =  ui.new_slider('rage', 'aimbot', '[Taser] Multi-point scale', 24, 100, 90, true, '%', 1, { [24] = 'Auto' } ),
	zeus_minimum_hit_chance =  ui.new_slider('rage', 'aimbot', '[Taser] Minimum hitchance', 0, 100, 50, true, '%', 1, { [0] = 'Off' } ),
	zeus_extra_minimum_hit_chance =  { ui.new_slider('rage', 'aimbot', '[Taser] Override Minimum hitchance', 0, 100, 60, true, '%', 1, { [0] = 'Off' } ), ui.new_hotkey('rage', 'aimbot', '[Shotgun] Override Minimum hitchance', true) },	--extra_hitchance
	zeus_minimum_damage =  ui.new_slider('rage', 'aimbot', '[Taser] Minimum damage', 0, 126, 10, true, '', 1, { [0] = 'Auto' } ),
	zeus_extra_minimum_damage =  { ui.new_slider('rage', 'aimbot', '[Taser] Override Minimum damage',0, 126, 20, true, '', 1, { [0] = 'Auto' } ), ui.new_hotkey('rage', 'aimbot', '[Shotgun] Override Minimum damage', true) },	--extra_damage
}

local contains = function(t, value)
    for i = 1, #t do
        if t[i] == value then return true end
    end
    return false
end

    ui.set_visible(g_ui.enabled[1], false)
	ui.set_visible(g_ui.enabled[2], false)
	ui.set_visible(g_ui.target_selection[1], false)
	ui.set_visible(g_ui.automatic_fire[1], false)
	ui.set_visible(g_ui.automatic_penetration[1], false)
	ui.set_visible(g_ui.silent_aim[1], false)
	ui.set_visible(g_ui.automatic_scope[1], false)
	ui.set_visible(g_ui.reduce_aim_step[1], false)
	ui.set_visible(g_ui.maximum_fov[1], false)
	ui.set_visible(g_ui.multi_point_scale[1], false)
	ui.set_visible(g_ui.minimum_hit_chance[1], false)
	ui.set_visible(g_ui.minimum_damage[1], false)
	ui.set_visible(g_ui.prefer_safe_point[1], false)
	ui.set_visible(g_ui.delay_shot[1], false)
	ui.set_visible(g_ui.accuracy_boost[1], false)
	ui.set_visible(g_ui.remove_recoil[1], false)
	ui.set_visible(g_ui.anti_aim_correction[1], false)
	ui.set_visible(g_ui.multi_point_scale[1], false)
	ui.set_visible(g_ui.minimum_hit_chance[1], false)

	ui.set_visible(g_ui.target_hitbox[1], false)
	ui.set_visible(g_ui.multi_point[1], false)
	ui.set_visible(g_ui.multi_point[2], false)
	ui.set_visible(g_ui.avoid_unsafe_hitboxes[1], false)

	ui.set_visible(g_ui.quick_stop[1], false)
	ui.set_visible(g_ui.quick_stop[2], false)
	ui.set_visible(g_ui.prefer_body_aim[1], false)
	ui.set_visible(g_ui.prefer_body_aim_disablers[1], false)

local function handle_menu()

	ui.set_visible(g_new_ui.global_text_1[1], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_text_2[1], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_text_3[1], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_text_1[2], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_text_2[2], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_text_3[2], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_text_1[3], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_text_2[3], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_text_3[3], ui.get(g_new_ui.state) == 'Global')

	ui.set_visible(g_new_ui.global_enable, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_target_selection, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_automatic_fire, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_automatic_penetration, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_silent_aim, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_automatic_scope, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_reduce_aim_step, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_maximum_fov, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_remove_recoil, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_anti_aim_correction, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_prefer_safe_point, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_delay_shot, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_accuracy_boost, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_multi_point_scale, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_minimum_hit_chance, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_extra_minimum_hit_chance[1], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_extra_minimum_hit_chance[2], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_minimum_damage, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_extra_minimum_damage[1], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_extra_minimum_damage[2], ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_target_hitbox, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_multi_point, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_avoid_unsafe_hitboxes, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_quick_stop_options, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_quick_stop, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_prefer_body_aim, ui.get(g_new_ui.state) == 'Global')
	ui.set_visible(g_new_ui.global_prefer_body_aim_disablers, ui.get(g_new_ui.state) == 'Global')



	ui.set_visible(g_new_ui.ssg08_text_1[1], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_text_2[1], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_text_3[1], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_text_1[2], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_text_2[2], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_text_3[2], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_text_1[3], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_text_2[3], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_text_3[3], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_enable, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_target_selection, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_automatic_fire, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_automatic_penetration, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_silent_aim, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_automatic_scope, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_reduce_aim_step, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_maximum_fov, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_remove_recoil, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_anti_aim_correction, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_prefer_safe_point, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_delay_shot, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_accuracy_boost, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_multi_point_scale, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_minimum_hit_chance, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_extra_minimum_hit_chance[1], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_extra_minimum_hit_chance[2], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_minimum_damage, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_extra_minimum_damage[1], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_extra_minimum_damage[2], ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_target_hitbox, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_multi_point, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_avoid_unsafe_hitboxes, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_quick_stop_options, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_quick_stop, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_prefer_body_aim, ui.get(g_new_ui.state) == 'Scout')
	ui.set_visible(g_new_ui.ssg08_prefer_body_aim_disablers, ui.get(g_new_ui.state) == 'Scout')

	ui.set_visible(g_new_ui.awp_text_1[1], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_text_2[1], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_text_3[1], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_text_1[2], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_text_2[2], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_text_3[2], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_text_1[3], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_text_2[3], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_text_3[3], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_enable, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_target_selection, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_automatic_fire, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_automatic_penetration, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_silent_aim, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_automatic_scope, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_reduce_aim_step, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_maximum_fov, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_remove_recoil, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_anti_aim_correction, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_prefer_safe_point, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_delay_shot, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_accuracy_boost, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_multi_point_scale, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_minimum_hit_chance, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_extra_minimum_hit_chance[1], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_extra_minimum_hit_chance[2], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_minimum_damage, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_extra_minimum_damage[1], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_extra_minimum_damage[2], ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_target_hitbox, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_multi_point, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_avoid_unsafe_hitboxes, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_quick_stop_options, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_quick_stop, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_prefer_body_aim, ui.get(g_new_ui.state) == 'Awp')
	ui.set_visible(g_new_ui.awp_prefer_body_aim_disablers, ui.get(g_new_ui.state) == 'Awp')

	ui.set_visible(g_new_ui.auto_text_1[1], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_text_2[1], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_text_3[1], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_text_1[2], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_text_2[2], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_text_3[2], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_text_1[3], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_text_2[3], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_text_3[3], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_enable, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_target_selection, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_automatic_fire, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_automatic_penetration, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_silent_aim, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_automatic_scope, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_reduce_aim_step, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_maximum_fov, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_remove_recoil, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_anti_aim_correction, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_prefer_safe_point, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_delay_shot, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_accuracy_boost, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_multi_point_scale, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_minimum_hit_chance, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_extra_minimum_hit_chance[1], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_extra_minimum_hit_chance[2], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_minimum_damage, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_extra_minimum_damage[1], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_extra_minimum_damage[2], ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_target_hitbox, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_multi_point, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_avoid_unsafe_hitboxes, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_quick_stop_options, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_quick_stop, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_prefer_body_aim, ui.get(g_new_ui.state) == 'Auto Sniper')
	ui.set_visible(g_new_ui.auto_prefer_body_aim_disablers, ui.get(g_new_ui.state) == 'Auto Sniper')

	ui.set_visible(g_new_ui.zeus_text_1[1], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_text_2[1], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_text_3[1], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_text_1[2], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_text_2[2], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_text_3[2], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_text_1[3], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_text_2[3], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_text_3[3], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_enable, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_target_selection, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_automatic_fire, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_automatic_penetration, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_silent_aim, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_automatic_scope, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_reduce_aim_step, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_maximum_fov, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_remove_recoil, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_anti_aim_correction, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_prefer_safe_point, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_delay_shot, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_accuracy_boost, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_multi_point_scale, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_minimum_hit_chance, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_extra_minimum_hit_chance[1], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_extra_minimum_hit_chance[2], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_minimum_damage, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_extra_minimum_damage[1], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_extra_minimum_damage[2], ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_target_hitbox, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_multi_point, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_avoid_unsafe_hitboxes, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_quick_stop_options, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_quick_stop, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_prefer_body_aim, ui.get(g_new_ui.state) == 'Taser')
	ui.set_visible(g_new_ui.zeus_prefer_body_aim_disablers, ui.get(g_new_ui.state) == 'Taser')

	ui.set_visible(g_new_ui.heavy_pistol_text_1[1], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_text_2[1], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_text_3[1], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_text_1[2], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_text_2[2], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_text_3[2], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_text_1[3], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_text_2[3], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_text_3[3], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_enable, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_target_selection, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_automatic_fire, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_automatic_penetration, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_silent_aim, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_automatic_scope, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_reduce_aim_step, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_maximum_fov, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_remove_recoil, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_anti_aim_correction, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_prefer_safe_point, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_delay_shot, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_accuracy_boost, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_multi_point_scale, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_minimum_hit_chance, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_extra_minimum_hit_chance[1], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_extra_minimum_hit_chance[2], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_minimum_damage, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_extra_minimum_damage[1], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_extra_minimum_damage[2], ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_target_hitbox, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_multi_point, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_avoid_unsafe_hitboxes, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_quick_stop_options, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_quick_stop, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_prefer_body_aim, ui.get(g_new_ui.state) == 'Heavy pistol')
	ui.set_visible(g_new_ui.heavy_pistol_prefer_body_aim_disablers, ui.get(g_new_ui.state) == 'Heavy pistol')

	ui.set_visible(g_new_ui.pistol_text_1[1], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_text_2[1], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_text_3[1], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_text_1[2], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_text_2[2], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_text_3[2], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_text_1[3], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_text_2[3], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_text_3[3], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_enable, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_target_selection, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_automatic_fire, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_automatic_penetration, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_silent_aim, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_automatic_scope, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_reduce_aim_step, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_maximum_fov, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_remove_recoil, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_anti_aim_correction, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_prefer_safe_point, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_delay_shot, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_accuracy_boost, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_multi_point_scale, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_minimum_hit_chance, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_extra_minimum_hit_chance[1], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_extra_minimum_hit_chance[2], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_minimum_damage, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_extra_minimum_damage[1], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_extra_minimum_damage[2], ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_target_hitbox, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_multi_point, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_avoid_unsafe_hitboxes, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_quick_stop_options, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_quick_stop, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_prefer_body_aim, ui.get(g_new_ui.state) == 'Pistol')
	ui.set_visible(g_new_ui.pistol_prefer_body_aim_disablers, ui.get(g_new_ui.state) == 'Pistol')

	ui.set_visible(g_new_ui.shotgun_text_1[1], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_text_2[1], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_text_3[1], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_text_1[2], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_text_2[2], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_text_3[2], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_text_1[3], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_text_2[3], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_text_3[3], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_enable, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_target_selection, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_automatic_fire, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_automatic_penetration, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_silent_aim, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_automatic_scope, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_reduce_aim_step, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_maximum_fov, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_remove_recoil, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_anti_aim_correction, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_prefer_safe_point, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_delay_shot, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_accuracy_boost, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_multi_point_scale, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_minimum_hit_chance, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_extra_minimum_hit_chance[1], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_extra_minimum_hit_chance[2], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_minimum_damage, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_extra_minimum_damage[1], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_extra_minimum_damage[2], ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_target_hitbox, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_multi_point, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_avoid_unsafe_hitboxes, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_quick_stop_options, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_quick_stop, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_prefer_body_aim, ui.get(g_new_ui.state) == 'Shotgun')
	ui.set_visible(g_new_ui.shotgun_prefer_body_aim_disablers, ui.get(g_new_ui.state) == 'Shotgun')
end
handle_menu()
ui.set_callback(g_new_ui.state, function()
    handle_menu()
end)

ui.set_callback(g_new_ui.full_switch, function()
	ui.set(g_ui.enabled[1], ui.get(g_new_ui.full_switch))
end)

local function setup_configs()

	ui.set(g_ui.target_hitbox[1], #ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' target hitbox')) == 0 and 'Head' or ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' target hitbox')))
	ui.set(g_ui.multi_point[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' multi point')))
	ui.set(g_ui.avoid_unsafe_hitboxes[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' avoid unsafe hitboxes')))
	ui.set(g_ui.quick_stop[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' quick stop')))
	ui.set(g_ui.prefer_body_aim_disablers[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' prefer body aim disablers')))

    ui.set(g_ui.multi_point_scale[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' multi-point scale')))
	ui.set(g_ui.minimum_hit_chance[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' minimum hitchance')))
	ui.set(g_ui.minimum_damage[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' minimum damage')))
	ui.set(g_ui.prefer_safe_point[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' prefer safe point')))
	ui.set(g_ui.prefer_body_aim[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' prefer body aim')))

	ui.set(g_ui.delay_shot[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' delay shot')))
	ui.set(g_ui.accuracy_boost[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' accuracy boost')))
	ui.set(g_ui.remove_recoil[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' remove recoil')))
	ui.set(g_ui.anti_aim_correction[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' anti-aim correction')))

	ui.set(g_ui.target_selection[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' Target selection')))
	ui.set(g_ui.automatic_fire[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' Automatic fire')))
	ui.set(g_ui.automatic_penetration[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' Automatic penetration')))
	ui.set(g_ui.silent_aim[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' Silent aim')))

	ui.set(g_ui.automatic_scope[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' Automatic scope')))
	ui.set(g_ui.reduce_aim_step[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' Reduce aim step')))
	ui.set(g_ui.maximum_fov[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' Maximum FOV')))

end

local function setup_dmg_ovr()

    ui.set(g_ui.minimum_damage[1], ui.get(ovr_dmg[2]))

end

local function setup_hc_ovr()

	ui.set(g_ui.minimum_hit_chance[1], ui.get(ovr_hc[2]))

end

local function unset_dmg_ovr()

	ui.set(g_ui.minimum_damage[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' minimum damage')))

end

local function unset_hc_ovr()

	ui.set(g_ui.minimum_hit_chance[1], ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' minimum hitchance')))

end

local function setup_ui()

    if ui.is_menu_open() ~= true then

	    ui.set(g_new_ui.state, wp_to_cfg)

    end
end

client.set_event_callback('setup_command', function()
	if entity.is_alive(entity.get_local_player()) then
	local weapon_name = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))

	if weapon_name == 'CWeaponSSG08' and ui.get(g_new_ui.ssg08_enable) then
		wp_to_cfg = 'Scout'

		ovr_hc = {g_new_ui.ssg08_extra_minimum_hit_chance[2], g_new_ui.ssg08_extra_minimum_hit_chance[1]}
		ovr_dmg = {g_new_ui.ssg08_extra_minimum_damage[2], g_new_ui.ssg08_extra_minimum_damage[1]}

	elseif weapon_name == 'CWeaponAWP' and ui.get(g_new_ui.awp_enable) then
		wp_to_cfg = 'Awp'

		ovr_hc = {g_new_ui.awp_extra_minimum_hit_chance[2], g_new_ui.awp_extra_minimum_hit_chance[1]}
		ovr_dmg = {g_new_ui.awp_extra_minimum_damage[2], g_new_ui.awp_extra_minimum_damage[1]}

    elseif weapon_name == 'CWeaponG3SG1' or weapon_name == 'CWeaponSCAR20' and ui.get(g_new_ui.auto_enable) then
		wp_to_cfg = 'Auto Sniper'

		ovr_hc = {g_new_ui.auto_extra_minimum_hit_chance[2], g_new_ui.auto_extra_minimum_hit_chance[1]}
		ovr_dmg = {g_new_ui.auto_extra_minimum_damage[2], g_new_ui.auto_extra_minimum_damage[1]}

    elseif weapon_name == 'CDEagle' and ui.get(g_new_ui.heavy_pistol_enable) then
		wp_to_cfg = 'Heavy pistol'

		ovr_hc = {g_new_ui.heavy_pistol_extra_minimum_hit_chance[2], g_new_ui.heavy_pistol_extra_minimum_hit_chance[1]}
		ovr_dmg = {g_new_ui.heavy_pistol_extra_minimum_damage[2], g_new_ui.heavy_pistol_extra_minimum_damage[1]}

    elseif weapon_name == 'CWeaponHKP2000' or weapon_name == 'CWeaponGlock' or weapon_name == 'CWeaponElite' or weapon_name == 'CWeaponP250' or weapon_name == 'CWeaponFiveSeven' or weapon_name == 'CWeaponTec9' and ui.get(g_new_ui.pistol_enable) then
		wp_to_cfg = 'Pistol'

		ovr_hc = {g_new_ui.pistol_extra_minimum_hit_chance[2], g_new_ui.pistol_extra_minimum_hit_chance[1]}
		ovr_dmg = {g_new_ui.pistol_extra_minimum_damage[2], g_new_ui.pistol_extra_minimum_damage[1]}

	elseif weapon_name == 'CWeaponNOVA' or weapon_name == 'CWeaponXM1014' or weapon_name == 'CWeaponSawedoff' or weapon_name == 'CWeaponMag7' and ui.get(g_new_ui.shotgun_enable) then
		wp_to_cfg = 'Shotgun'

		ovr_hc = {g_new_ui.shotgun_extra_minimum_hit_chance[2], g_new_ui.shotgun_extra_minimum_hit_chance[1]}
		ovr_dmg = {g_new_ui.shotgun_extra_minimum_damage[2], g_new_ui.shotgun_extra_minimum_damage[1]}

	elseif weapon_name == 'CWeaponTaser' and ui.get(g_new_ui.zeus_enable) then
		wp_to_cfg = 'Taser'

		ovr_hc = {g_new_ui.zeus_extra_minimum_hit_chance[2], g_new_ui.zeus_extra_minimum_hit_chance[1]}
		ovr_dmg = {g_new_ui.zeus_extra_minimum_damage[2], g_new_ui.zeus_extra_minimum_damage[1]}

	else
		wp_to_cfg = 'Global'

		ovr_hc = {g_new_ui.global_extra_minimum_hit_chance[2], g_new_ui.global_extra_minimum_hit_chance[1]}
		ovr_dmg = {g_new_ui.global_extra_minimum_damage[2], g_new_ui.global_extra_minimum_damage[1]}

end

cfg_to_name = string.format('[%s]', wp_to_cfg)

	if ui.get(g_new_ui.full_switch) and ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' preset')) then

		if string.lower(ui.get(g_new_ui.state)) ~= string.lower(wp_to_cfg) then
	
	setup_configs()

	setup_ui()

	end
	
	if ui.get(ovr_dmg[1]) then

	    setup_dmg_ovr()

	end

	if ui.get(ovr_hc[1]) then

	    setup_hc_ovr()

	end

	if ui.get(ovr_dmg[1]) ~= true and ui.get(g_ui.minimum_damage[1]) ~= ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' minimum damage')) then

		unset_dmg_ovr()

	end

	if ui.get(ovr_hc[1]) ~= true and ui.get(g_ui.minimum_hit_chance[1]) ~= ui.get(ui.reference('rage', 'aimbot', cfg_to_name..' minimum hitchance')) then

		unset_hc_ovr()

	    end

    end

	ui.set_visible(g_ui.enabled[1], false)
	ui.set_visible(g_ui.enabled[2], false)
	ui.set_visible(g_ui.target_selection[1], false)
	ui.set_visible(g_ui.automatic_fire[1], false)
	ui.set_visible(g_ui.automatic_penetration[1], false)
	ui.set_visible(g_ui.silent_aim[1], false)
	ui.set_visible(g_ui.automatic_scope[1], false)
	ui.set_visible(g_ui.reduce_aim_step[1], false)
	ui.set_visible(g_ui.maximum_fov[1], false)
	ui.set_visible(g_ui.multi_point_scale[1], false)
	ui.set_visible(g_ui.minimum_hit_chance[1], false)
	ui.set_visible(g_ui.minimum_damage[1], false)
	ui.set_visible(g_ui.prefer_safe_point[1], false)
	ui.set_visible(g_ui.delay_shot[1], false)
	ui.set_visible(g_ui.accuracy_boost[1], false)
	ui.set_visible(g_ui.remove_recoil[1], false)
	ui.set_visible(g_ui.anti_aim_correction[1], false)
	ui.set_visible(g_ui.multi_point_scale[1], false)
	ui.set_visible(g_ui.minimum_hit_chance[1], false)

	ui.set_visible(g_ui.target_hitbox[1], false)
	ui.set_visible(g_ui.multi_point[1], false)
	ui.set_visible(g_ui.multi_point[2], false)
	ui.set_visible(g_ui.avoid_unsafe_hitboxes[1], false)

	ui.set_visible(g_ui.quick_stop[1], false)
	ui.set_visible(g_ui.quick_stop[2], false)	
	ui.set_visible(g_ui.prefer_body_aim[1], false)
	ui.set_visible(g_ui.prefer_body_aim_disablers[1], false)

    end
end)

local function on_paint()

	if entity.is_alive(entity.get_local_player()) then
	local r, g, b, a = ui.get(g_new_ui.indicator_color)

	    renderer.indicator(r, g, b, a, 'HC: ' .. ui.get(g_ui.minimum_hit_chance[1]) .. ' | DMG: ' .. ui.get(g_ui.minimum_damage[1]))

	end
end

ui.set_callback(g_new_ui.indicator_switch, function()
    local update_callback = ui.get(g_new_ui.indicator_switch) and client.set_event_callback or client.unset_event_callback
	update_callback('paint', on_paint)
end)

local function on_shut_down()

	ui.set_visible(g_ui.enabled[1], true)
	ui.set_visible(g_ui.enabled[2], true)
	ui.set_visible(g_ui.target_selection[1], true)
	ui.set_visible(g_ui.automatic_fire[1], true)
	ui.set_visible(g_ui.automatic_penetration[1], true)
	ui.set_visible(g_ui.silent_aim[1], true)
	ui.set_visible(g_ui.automatic_scope[1], true)
	ui.set_visible(g_ui.reduce_aim_step[1], true)
	ui.set_visible(g_ui.maximum_fov[1], true)
	ui.set_visible(g_ui.multi_point_scale[1], true)
	ui.set_visible(g_ui.minimum_hit_chance[1], true)
	ui.set_visible(g_ui.minimum_damage[1], true)
	ui.set_visible(g_ui.prefer_safe_point[1], true)
	ui.set_visible(g_ui.delay_shot[1], true)
	ui.set_visible(g_ui.accuracy_boost[1], true)
	ui.set_visible(g_ui.remove_recoil[1], true)
	ui.set_visible(g_ui.anti_aim_correction[1], true)
	ui.set_visible(g_ui.target_hitbox[1], true)
	ui.set_visible(g_ui.multi_point[1], true)
	ui.set_visible(g_ui.multi_point[2], true)
	ui.set_visible(g_ui.avoid_unsafe_hitboxes[1], true)
	ui.set_visible(g_ui.quick_stop[1], true)
	ui.set_visible(g_ui.quick_stop[2], true)
    ui.set_visible(g_ui.prefer_body_aim[1], true)
	ui.set_visible(g_ui.prefer_body_aim_disablers[1], true)


end
client.set_event_callback('shutdown', on_shut_down)