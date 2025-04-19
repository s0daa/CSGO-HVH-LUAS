--region enumerations
local e_script = {
  NAME = 'necron',
  VERSION = '1.0.0',
  TYPE = 'stable',
	USER_NAME = 'unnamed'
}

local e_list = {
	WEAPONS = {"shared", "asniper", "hpistol", "knife", "lmg", "pistol", "rifle", "scout", "shotgun", "smg", "sniper", "zeus"}
}
--endregion

--region math
--- Returns the clamped value.
-- @param num number
-- @param min number
-- @param max number
-- @return number
function math.clamp( num, min, max )
  return math.floor( math.min( math.max( num, min ), max ) )
end
--endregion

--region window
local window = {}

window.xml = gui.XML( [[
	<Window var = 'necron' name = 'Necron' width='570' height='530'>
		<Tab var = 'main' name = 'Main'></Tab>
		<Tab var = 'anti_aim' name = 'Anti-Aim'></Tab>
		<Tab var = 'ragebot' name = 'Ragebot'></Tab>
	</Window>
]] )

window.main = window.xml:Reference( 'main' )
window.anti_aim = window.xml:Reference( 'anti_aim' )
window.ragebot = window.xml:Reference( 'ragebot' )
--endregion

--region tabs
-- @tab main
local main_info = gui.Groupbox( window.main, 'Info', 10, 10, 270 )

-- @tab anti_aim
local anti_aim_main = gui.Groupbox( window.anti_aim, 'Main', 10, 10, 270 )
local anti_aim_angles = gui.Groupbox( window.anti_aim, 'Angles', 290, 10, 270 )

-- @tab ragebot
local ragebot_main = gui.Groupbox( window.ragebot, 'Main', 10, 10, 270 )
local ragebot_exploits = gui.Groupbox( window.ragebot, 'Exploits', 290, 10, 270 )
--endregion

--region gui
-- @tab main
-- @group info
local info_text = string.format( [[
Welcome back, %s.

Current version: %s.

Current type: %s.
]], e_script.USER_NAME, e_script.VERSION, e_script.TYPE )

gui.Text( main_info, info_text )
gui.Button( main_info, 'Join discord server', function( ) 
	panorama.RunScript( 'SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/gVhbtecHRz")' )
end )

-- @tab anti_aim
-- @group main
local gui_amain = {}

gui_amain.switch = gui.Checkbox( anti_aim_main, 'necron_anti_aim', 'Enabled', false )

gui_amain.left_manual = gui.Keybox( anti_aim_main, 'necron_left_manual', 'Left manual', 0 )
gui_amain.right_manual = gui.Keybox( anti_aim_main, 'necron_right_manual', 'Right manual', 0 )
gui_amain.backward_manual = gui.Keybox( anti_aim_main, 'necron_backward_manual', 'Backward manual', 0 )

gui_amain.options = gui.Multibox( anti_aim_main, 'Options' )
gui_amain.static_manuals = gui.Checkbox( gui_amain.options, 'necron_static_manuals', 'Static manuals', false )

-- @group angles
-- @note ЭТА ЧО ПРИВАТНОЕ ПО NEVERLOSE.CC???!?!?
local gui_angles = {}

gui_angles.yaw_offset = gui.Slider( anti_aim_angles, 'necron_yaw_offset', 'Yaw offset', 0, -180, 180 )
gui_angles.yaw_modifier = gui.Combobox( anti_aim_angles, 'necron_yaw_modifier', 'Yaw modifier', 'Disabled', 'Offset', 'Center', 'Random' )
gui_angles.modifier_degree = gui.Slider( anti_aim_angles, 'necron_modifier_degree', 'Modifier degree', 0, -180, 180 )

gui_angles.body_yaw = gui.Checkbox( anti_aim_angles, 'necron_body_yaw', 'Body yaw', false )
gui_angles.invertor = gui.Checkbox( anti_aim_angles, 'necron_body_yaw_invertor', 'Inverter', false )

gui_angles.left_limit = gui.Slider( anti_aim_angles, 'necron_body_yaw_left', 'Left limit', 0, 0, 58 )
gui_angles.right_limit = gui.Slider( anti_aim_angles, 'necron_body_yaw_right', 'Right limit', 0, 0, 58 )

gui_angles.body_yaw_options = gui.Multibox( anti_aim_angles, 'Options' )
gui_angles.body_yaw_jitter = gui.Checkbox( gui_angles.body_yaw_options, 'necron_body_yaw_jiiter', 'Jitter', false )

-- @tab ragebot
-- @group main
local gui_rmain = {}

gui_rmain.switch = gui.Checkbox( ragebot_main, 'necron_ragebot', 'Enabled', false )

-- @group exploits
local gui_exploits = {}

gui_exploits.double_tap = gui.Checkbox( ragebot_exploits, 'necron_double_tap', 'Double tap', false )
gui_exploits.double_tap_group = gui.Groupbox( ragebot_exploits, 'Double tap settings' )
gui_exploits.double_tap_type = gui.Combobox( gui_exploits.double_tap_group, 'necron_double_tap_type', 'Type', 'Defensive Fire', 'Defensive Warp Fire' )

gui_exploits.hide_shots = gui.Checkbox( ragebot_exploits, 'necron_hide_shots', 'Hide shots', false )
--endregion

--region visible
-- @note Потом это убрать, потому что хуйня идея
local function update_visible( )
	gui_angles.modifier_degree:SetInvisible( gui_angles.yaw_modifier:GetValue( ) == 0 )

	gui_angles.invertor:SetInvisible( not gui_angles.body_yaw:GetValue( ) )
	gui_angles.left_limit:SetInvisible(not gui_angles.body_yaw:GetValue( ) )
	gui_angles.right_limit:SetInvisible( not gui_angles.body_yaw:GetValue( ) )
	gui_angles.body_yaw_options:SetInvisible( not gui_angles.body_yaw:GetValue( ) )

	local items_table = {
		[gui_amain.switch] = {gui_angles, gui_amain},
		[gui_rmain.switch] = gui_exploits
	}

	for switch, items in pairs( items_table ) do
		for item_name, item in pairs( items ) do
			if type( item ) == 'table' then
				for tbl_idx, tbl in pairs( item ) do
					if tbl_idx ~= 'switch' then
						tbl:SetDisabled( not switch:GetValue( ) )
					end
				end
			elseif type( item ) == 'userdata' then
				if item_name ~= 'switch' then
					item:SetDisabled( not switch:GetValue( ) )
				end
			end
		end
 	end
end
--endregion

--region anti_aim
local anti_aim = {}

anti_aim.jitter_switch = false
anti_aim.desync_switch = false

anti_aim.left_acitve = false
anti_aim.right_active = false
anti_aim.backward_active = false

function anti_aim.manual_handle( )
	if not gui_amain.switch:GetValue( ) then
		return
	end

	-- @note Это тоже потом надо переделать
	if gui_amain.left_manual:GetValue( ) ~= 0 then
		if input.IsButtonPressed( gui_amain.left_manual:GetValue( ) ) then
			anti_aim.left_acitve = not anti_aim.left_acitve
		end
	end
	if gui_amain.right_manual:GetValue( ) ~= 0 then
		if input.IsButtonPressed( gui_amain.right_manual:GetValue( ) ) then
			anti_aim.right_active = not anti_aim.right_active
		end
	end
	if gui_amain.backward_manual:GetValue( ) ~= 0 then
		if input.IsButtonPressed( gui_amain.backward_manual:GetValue( ) ) then
			anti_aim.backward_active = not anti_aim.backward_active
		end
	end
end

function anti_aim.handle( cmd )
	if not gui_amain.switch:GetValue( ) then
		return
	end

	local player = entities.GetLocalPlayer()

	if player == nil then
		return
	end

	local desync_value = gui_angles.body_yaw:GetValue( ) and 'Desync' or 'Backward'
	local rotation_value = gui_angles.invertor:GetValue( ) and gui_angles.left_limit:GetValue( ) or -gui_angles.right_limit:GetValue( )

	local manual_active = anti_aim.left_acitve or anti_aim.right_active or anti_aim.backward_active

	if gui_angles.body_yaw_jitter:GetValue( ) and not (gui_amain.static_manuals:GetValue( ) and manual_active) then
		if cmd.command_number % 3 == 0 then
			rotation_value = anti_aim.desync_switch and -rotation_value or rotation_value

			gui.SetValue( 'rbot.antiaim.base.rotation', rotation_value )

			anti_aim.desync_switch = not anti_aim.desync_switch
		end
	else
		gui.SetValue( 'rbot.antiaim.base.rotation', rotation_value )
	end

	local yaw = gui_angles.yaw_offset:GetValue( )

	if manual_active then
		local active_manual = 0

		if anti_aim.backward_active then
			active_manual = 0
		end

		if anti_aim.left_acitve then
			active_manual = -90
		end

		if anti_aim.right_active then
			active_manual = 90
		end

		yaw = active_manual
	end

	if gui_angles.yaw_modifier:GetValue( ) == 0 then
			local new_yaw = yaw < 0 and yaw + 180 or yaw - 180
			local var_value = string.format( '%d %s', new_yaw, desync_value )

			gui.SetValue( 'rbot.antiaim.base', var_value )
	else
		if gui_amain.static_manuals:GetValue( ) and manual_active then
			-- @note Опять насрал
			local new_yaw = yaw < 0 and yaw + 180 or yaw - 180
			local var_value = string.format( '%d %s', new_yaw, desync_value )

			gui.SetValue( 'rbot.antiaim.base', var_value )
		else
			if cmd.command_number % 3 == 0 then
				local modifier_value = 0

				if gui_angles.yaw_modifier:GetValue( ) == 1 then
					modifier_value = anti_aim.jitter_switch and yaw or math.clamp( 0, 180, yaw + gui_angles.modifier_degree:GetValue( ) )
				elseif gui_angles.yaw_modifier:GetValue( ) == 2 then
					modifier_value = anti_aim.jitter_switch and math.clamp( -180, 180, yaw - ( gui_angles.modifier_degree:GetValue( ) / 2 ) ) or math.clamp( -180, 180, yaw + ( gui_angles.modifier_degree:GetValue( ) / 2 ) )
				elseif gui_angles.yaw_modifier:GetValue( ) == 3 then
					modifier_value = math.random( gui_angles.modifier_degree:GetValue( ) / -2, gui_angles.modifier_degree:GetValue( ) / 2 )
				end

				local new_modifier_value = modifier_value < 0 and modifier_value + 180 or modifier_value - 180
				local var_value = string.format( '%d %s', new_modifier_value, desync_value )

				gui.SetValue( 'rbot.antiaim.base', var_value )

				anti_aim.jitter_switch = not anti_aim.jitter_switch
			end
		end
	end
end
--endregion

--region ragebot
-- @item exploits
local exploits = {}

function exploits.handle( )
	if not gui_rmain.switch:GetValue( ) then
		return
	end

	local fire_mode = 'Off'

	if gui_exploits.double_tap:GetValue( ) then
		fire_mode = gui_exploits.double_tap_type:GetString( )
	elseif gui_exploits.hide_shots:GetValue( ) then
		fire_mode = 'Shift Fire'
	end

	for _, value in ipairs( e_list.WEAPONS ) do
		gui.SetValue( string.format( 'rbot.accuracy.attack.%s.fire', value ), fire_mode )
	end
end
--endregion

--region events
-- @event createmove
callbacks.Register( 'CreateMove', 'anti_aim', anti_aim.handle )

-- @event draw
callbacks.Register( 'Draw', 'manual_update', anti_aim.manual_handle )
callbacks.Register( 'Draw', 'update_visible', update_visible )
callbacks.Register( 'Draw', 'exploits', exploits.handle )
callbacks.Register( 'Draw', 'window_visible', function( )
	window.xml:SetInvisible( not gui.Reference("Menu"):IsActive() )
end )
--endregion
