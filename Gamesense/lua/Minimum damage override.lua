--------------------------------------------------------------------------------
-- Cache common functions
--------------------------------------------------------------------------------
local uix = require 'gamesense/uix'
local renderer_indicator, ui_get, ui_new_hotkey, ui_new_slider, ui_reference, ui_set, ui_set_visible = renderer.indicator, ui.get, ui.new_hotkey, ui.new_slider, ui.reference, ui.set, ui.set_visible

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local enable_ref
local indicator_ref
local restore_dmamage_ref
local override_damage_ref
local override_hk_ref

local min_damage_ref
local damage_overrides = {}

--------------------------------------------------------------------------------
-- Callback functions
--------------------------------------------------------------------------------
local function on_paint()
	if ui_get(override_hk_ref) == true then
		local r, g, b, a = ui_get(indicator_ref)
		renderer_indicator(r, g, b, a, "Damage: ", ui_get(min_damage_ref))
	end
end

local function on_run_command()
	local damage = ui_get(override_hk_ref) and ui_get(override_damage_ref) or ui_get(restore_dmamage_ref)
	ui_set(min_damage_ref, damage)
end

local function on_override_damage_toggle(ref, value)
	ui_set_visible(override_damage_ref, value)
	ui_set_visible(restore_dmamage_ref, value)
	ui_set_visible(override_hk_ref, value)
end

--------------------------------------------------------------------------------
-- Initialization code
--------------------------------------------------------------------------------
local function init()
	damage_overrides[0] = "Auto"
	for i=1, 26 do
		damage_overrides[100+i] = "HP + "..i
	end

	enable_ref		= uix.new_checkbox("RAGE", "Other", "Minimum damage override")
	indicator_ref	  = ui.new_color_picker("RAGE", "Other", "Indicator color", 255, 255, 255, 255)
	restore_dmamage_ref = ui_new_slider("RAGE", "Other", "Restore damage", 0, 126, 10, true, nil, 1, damage_overrides)
	override_damage_ref = ui_new_slider("RAGE", "Other", "Override damage", 0, 126, 101, true, nil, 1, damage_overrides)
	override_hk_ref  = ui_new_hotkey("RAGE", "Other", "Damage override hotkey", true)
	min_damage_ref	= ui_reference("RAGE", "Aimbot", "Minimum damage")

	enable_ref:on("change", on_override_damage_toggle)
	enable_ref:on("run_command", on_run_command)
	enable_ref:on("paint", on_paint)
end

init()