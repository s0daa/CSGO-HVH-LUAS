-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local function fix()
	client.set_cvar("cl_showerror", 0)
end	
client.set_event_callback('paint', fix)