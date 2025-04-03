local ui_get = ui.get
local ui_set = ui.set
local client_exec = client.exec
local ui_new_checkbox = ui.new_checkbox
local ui_new_slider = ui.new_slider
local ui_set_callback = ui.set_callback

local tpdistanceslider = ui_new_slider("VISUALS", "EFFECTS", "Thirdperson Distance", 30, 200, 150)

local function tpdistance()
	client_exec("cam_idealdist ", ui_get(tpdistanceslider))
end
ui_set_callback(tpdistanceslider, tpdistance)