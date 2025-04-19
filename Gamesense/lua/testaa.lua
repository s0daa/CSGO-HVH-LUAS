--Needed
local ui_get, ui_set, ui_ref = ui.get, ui.set, ui.reference
local ui_reference = ui.reference
local globals_curtime = globals.curtime
local client_log = client.log
local client_draw_text = client.draw_text
local client_indicator = renderer.indicator
local client_screensize = client.screen_size
local client_set_event_callback = client.set_event_callback

--Set UI
local ui_manualaa = ui.new_checkbox("AA", "Anti-aimbot angles", "tankAA")
local ui_dangerous = ui.new_checkbox("AA", "Anti-aimbot angles", "Dangerous")
local ui_indicator_color_picker = ui.new_color_picker("AA", "Anti-aimbot angles", "Indicator colour", "255", "20", "147", "255")
local ui_switchsides = ui.new_hotkey("AA", "Anti-aimbot angles", "Anti-Aim switch")
local ui_dangerous_aa = ui.new_hotkey("AA", "Anti-aimbot angles", "Dangerous aa")
local reference_yaw, reference_yaw_slider = ui_reference("AA", "Anti-aimbot angles", "Yaw")
local reference_body, reference_body_slider = ui_reference("AA", "Anti-aimbot angles", "Body yaw")
local reference_jitter, reference_jitter_slider = ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")


local function setRight()
    ui_set(reference_yaw_slider, 0)
    ui_set(reference_jitter, "Offset")
    ui_set(reference_jitter_slider, 0)
    ui_set(reference_body, "Static")
    ui_set(reference_body_slider, -90)
end


local function setLeft()
    ui_set(reference_yaw_slider, 0)
    ui_set(reference_jitter, "Offset")
    ui_set(reference_jitter_slider, 0)
    ui_set(reference_body, "Static")
    ui_set(reference_body_slider, 90)
end


local function setBack()
	ui_set(reference_yaw_slider, 10)
	ui_set(reference_jitter, "Offset")
	ui_set(reference_jitter_slider, 0)
	ui_set(reference_body, "Static")
	ui_set(reference_body_slider, 30)
end


local function on_paint(c)
    if not ui_get(ui_manualaa) then
    return
    end
    
    local scrsize_x, scrsize_y = client_screensize()
    local center_x, center_y = scrsize_x / 2, scrsize_y / 2
    

    local indicator_r, indicator_g, indicator_b, indicator_a = ui_get(ui_indicator_color_picker)


    if ui_get(ui_switchsides) then
		setLeft()
		renderer.text(center_x - 42, center_y, indicator_r, indicator_g, indicator_b, indicator_a, "c+", 0, "<")
		renderer.text(center_x + 42, center_y, 255, 255, 255, indicator_a, "c+", 0, ">")
        renderer.text(center_x, center_y + 42, 255, 255, 255, indicator_a, "c+", 0, "v")
	else
		setRight()
		renderer.text(center_x + 42, center_y, indicator_r, indicator_g, indicator_b, indicator_a, "c+", 0, ">")
		renderer.text(center_x - 42, center_y, 255, 255, 255, indicator_a, "c+", 0, "<")
        renderer.text(center_x, center_y + 42, 255, 255, 255, indicator_a, "c+", 0, "v")
	end 

	local scrsize_x, scrsize_y = client_screensize()
    local center_x, center_y = scrsize_x / 2, scrsize_y / 2
    

    local indicator_r, indicator_g, indicator_b, indicator_a = ui_get(ui_indicator_color_picker)

    if ui_get(ui_dangerous_aa) then
    	setBack()
        renderer.text(center_x + 42, center_y, 255, 255, 255, indicator_a, "c+", 0, ">")
        renderer.text(center_x - 42, center_y, 255, 255, 255, indicator_a, "c+", 0, "<")
    	renderer.text(center_x, center_y + 42, indicator_r, indicator_g, indicator_b, indicator_a, "c+", 0, "v")
    end	

end
client_set_event_callback("paint", on_paint)