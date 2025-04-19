local client_size = client.screen_size
local client_draw = client.draw_text

local ui_get = ui.get
local ui_set = ui.set
local ui_reference = ui.reference
local ui_new_hotkey = ui.new_hotkey
local ui_new_slider = ui.new_slider

local entity_get_local_player = entity.get_local_player
local entity_get_prop = entity.get_prop

local mindmg = ui_reference("rage", "aimbot", "minimum damage")
local change = ui_new_hotkey("rage", "other", "min dmg")
local dmg = ui_new_slider('rage', 'other', 'min dmg value on key', 0, 126, 0, true)

local last_value = 0
local should = false

local function on_paint(c)

	if last_value ~= ui_get(mindmg) and not should then
		last_value = ui_get(mindmg)
	end
	
	if entity_get_prop(entity_get_local_player(), "m_lifeState") ~= 0 then
		should = false
		ui_set(mindmg,  last_value)
        return
    end
	

	
	local sw, sh = client_size()
	local x, y = sw / 2, sh - 200

	if ui_get(change) then
		should = true
		ui_set(mindmg, ui_get(dmg))
	else
		should = false
		ui_set(mindmg, last_value)
	end
	
	client_draw(c, 35, y + 35, 255, 255, 255, 255, "c+", 0, ui_get(mindmg))

end

client.set_event_callback('paint', on_paint)