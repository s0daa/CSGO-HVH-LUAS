local md = menu.find("aimbot", "scout", "target overrides", "force min. damage")[2]
local autostop = menu.find("aimbot", "scout", "accuracy", "autostop options")
local md2 = menu.find("aimbot", "awp", "target overrides", "force min. damage")[2]
local autostop2 = menu.find("aimbot", "awp", "accuracy", "autostop options")

local function main(cmd)
	 if md:get() then autostop[4]:set(3, true) else autostop[4]:set(3, false) end
	 if md2:get() then autostop2[4]:set(3, true) else autostop2[4]:set(3, false) end
end

callbacks.add(e_callbacks.SETUP_COMMAND, main)