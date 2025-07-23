-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- fixed by l0ny#8533

_DEBUG = true

local username = common.get_username()
local configname = common.get_config_name()
local screen_size = render.screen_size()
local screen_size_centre = render.screen_size() / 2

print("ARS [LOADED successfully]")
print("ARS [lua], Quick and Easy Ragebot/Config improvement!")
print_dev("Welcome to ARS [lua], " .. username)
local find_menu = {
   Mdmg = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Min. Damage"),
   DTindicator = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
   HSindicator = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
   baim = ui.find("Aimbot", "Ragebot", "Safety", "Global", "Body Aim"),
   SP = ui.find("Aimbot", "Ragebot", "Safety", "Global", "Safe Points"),
   findenableAA = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
   findhitchance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
   findmindmg = ui.find("Aimbot", "Ragebot", "Selection", "Global", "Min. Damage"),
   findMPH = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Head Scale"),
   findMPB = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Body Scale"),
   findpitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
   AAYawBase = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
   AAYawAdd = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
   AAdmodtype = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
   AAdegree = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
   findfakeangles = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
   inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
   Rightlimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
   Leftlimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
   fakeoptions = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
   freestandD = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
   freestandD2 = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
   freestandD3 = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
   EnableFakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
   fakelaglimit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
   findautopeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
   findedgejump = ui.find("Miscellaneous", "Main", "Movement", "Edge Jump"),
   findslowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
   findlegs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
   FDindicator = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
   findhitsound = ui.find("Visuals", "World", "Other", "Hit Marker Sound"),
   findclantag = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag")
}

-- MENU
local ARS_home = ui.create("Advanced Ragebot System (ARS)")
local ARS_settab = ui.create("ARS [Settings]")
local ARS_info = ui.create("ARS [Information]")
local ARS_misc = ui.create("ARS [Misc]")
local ARS_AA = ui.create("ARS [AntiAim]")
local ui = {
    -- Home
    homepage1 = ARS_home:label("ARS [NEVERLOSE 3.3]"),
    homepage2 = ARS_home:label("Last updated : ------"),
    ARSswitch = ARS_home:switch("ARS [Enable]", false),
    homepage3 = ARS_home:label("READ BEFORE USING !!!"),
    homepage4 = ARS_home:label("Preferably, keep your close range and long range distance the SAME! This avoids distance GAPS. For example: IF close range is less than 400 BUT If long range is 1000 and above, the distance between 400 and 1000 which is 600, will NOT change anything in your Ragebot settings!"),
    ARS_home:button("SHOWCASE LUA", function(link)
        panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://youtu.be/Ir1h5kLePB8")
    end),

    ARSsettingsmode = ARS_settab:combo("Ragebot Adjustment", "[Crosshair]", "[Distance]"),


    ARSsettings = ARS_settab:combo("ARS [Range]", "[Short]", "[Long]"),
    ARScloserange = ARS_settab:slider("ARS [Range LESS than]", 1, 1500, 400),
    ARSH1scale = ARS_settab:slider("[1] [Head Scale]", 1, 100, 60),
    ARSB1scale = ARS_settab:slider("[1] [Body Scale]", 1, 100, 60),
    ARSHC1 = ARS_settab:slider("[1] [Hit Chance]", 1, 100, 80),
    ARSMD1 = ARS_settab:slider("[1] [Minimum Damage]", 1, 130, 101),

    ARSlongrange = ARS_settab:slider("ARS [Range MORE than]", 1, 1500, 400),
    ARSH2scale = ARS_settab:slider("[2] [Head Scale]", 1, 100, 96),
    ARSB2scale = ARS_settab:slider("[2] [Body Scale]", 1, 100, 60),
    ARSHC2 = ARS_settab:slider("[2] [Hit Chance]", 1, 100, 70),
    ARSMD2 = ARS_settab:slider("[2] [Minimum Damage]", 1, 130, 100),

  --  ARStextE = ARS_info:input("ARS [text example]", "Enter Text"),
    ARSswitchinfo = ARS_info:switch("ARS [Information]", false),
    ARSswitchinfo_size = ARS_info:combo("ARS [Text Size]", "[Small]", "[Medium]", "[Large]"),
    ARSswitchinfo_x = ARS_info:slider("ARS [Horizontal pos]", 0, screen_size.x, screen_size.x/2),
    ARSswitchinfo_y = ARS_info:slider("ARS [Vertical pos]", 0, screen_size.y, screen_size.y/2),
    ARSswitchinfo_color = ARS_info:color_picker("ARS [Info color]", color(255)),

    safewarning = ARS_misc:label("SET THIS TO YOUR OVERRIDE MINIMUM DAMAGE KEY!"),
    ARSswitchmindmgsafe = ARS_misc:switch("Include Override Min Damage", false),
    ARStpswitch = ARS_misc:switch("ARS [Teleport in air]", false),
    ARSaamain = ARS_AA:switch("ARS [Yaw based AA]", false),
    ARSyawjitterval = ARS_AA:slider("ARS [Yaw Jitter Random]", -100, 100, 0)

 }
text_size = 0
local says = {
  "Advanced Ragebot System IS THE NEXT BEST NEVERLOSE RAGEBOT LUA.",
  "HAHAHAHAH. CHEAT LAUGH. ON YOU ? YES. YOU DON'T USE ARS [lua] ? Advanced Ragebot System ???? BAD BOY!",
  "ARS [lua] - Advanced Ragebot System, NO MORE CONFIG ISSUES.",
  "ARS [lua] - Developing since October 5th 2022, 11:50 PM.",
}


-- player states
local function get_velocity(player)
    if(player == nil) then return end
    local vec = player.m_vecVelocity
    local velocity = vec:length()
    return velocity
end

local function is_crouching(player)
    local flags = player.m_fFlags

    if bit.band(flags, 4) == 4 then
        return true
    end

    return false
end

local function is_in_air(player)
    local flags = player.m_fFlags

    if bit.band(flags, 1) == 0 then
        return true
    end

    return false
end

function showshit()
  if ui.ARSswitch:get() then
    ui.ARSsettings:visibility(true)
    ui.safewarning:visibility(true)
    ui.ARSswitchmindmgsafe:visibility(true)
    ui.ARStpswitch:visibility(true)
    ui.ARSaamain:visibility(true)
    ui.ARSsettingsmode:visibility(true)

    if ui.ARSsettingsmode:get() == "[Crosshair]" then
      ui.ARSsettings:visibility(false)
      ui.ARScloserange:visibility(false)
      ui.ARSlongrange:visibility(false)
    elseif ui.ARSsettingsmode:get() == "[Distance]" then
      ui.ARSsettings:visibility(true)
      ui.ARScloserange:visibility(true)
      ui.ARSlongrange:visibility(true)
    end
    if ui.ARSsettings:get() == "[Short]" then
      ui.ARScloserange:visibility(true)
      ui.ARSH1scale:visibility(true)
      ui.ARSB1scale:visibility(true)
      ui.ARSHC1:visibility(true)
      ui.ARSMD1:visibility(true)
      ui.ARSlongrange:visibility(false)
      ui.ARSH2scale:visibility(false)
      ui.ARSB2scale:visibility(false)
      ui.ARSHC2:visibility(false)
      ui.ARSMD2:visibility(false)
    elseif ui.ARSsettings:get() == "[Long]" then
      ui.ARSlongrange:visibility(true)
      ui.ARSH2scale:visibility(true)
      ui.ARSB2scale:visibility(true)
      ui.ARSHC2:visibility(true)
      ui.ARSMD2:visibility(true)
      ui.ARScloserange:visibility(false)
      ui.ARSH1scale:visibility(false)
      ui.ARSB1scale:visibility(false)
      ui.ARSHC1:visibility(false)
      ui.ARSMD1:visibility(false)
    end
    ui.ARSswitchinfo:visibility(true)
    if ui.ARSswitchinfo:get() then
      ui.ARSswitchinfo_size:visibility(true)
      ui.ARSswitchinfo_x:visibility(true)
      ui.ARSswitchinfo_y:visibility(true)
      ui.ARSswitchinfo_color:visibility(true)
    else
      ui.ARSswitchinfo_size:visibility(false)
      ui.ARSswitchinfo_x:visibility(false)
      ui.ARSswitchinfo_y:visibility(false)
      ui.ARSswitchinfo_color:visibility(false)
    end
  else
    ui.ARSswitchmindmgsafe:visibility(false)
    ui.safewarning:visibility(false)
    ui.ARSsettings:visibility(false)
    ui.ARScloserange:visibility(false)
    ui.ARSH1scale:visibility(false)
    ui.ARSB1scale:visibility(false)
    ui.ARSHC1:visibility(false)
    ui.ARSMD1:visibility(false)
    ui.ARSlongrange:visibility(false)
    ui.ARSH2scale:visibility(false)
    ui.ARSB2scale:visibility(false)
    ui.ARSHC2:visibility(false)
    ui.ARSMD2:visibility(false)
    ui.ARSswitchinfo:visibility(false)
    ui.ARSswitchinfo_size:visibility(false)
    ui.ARSswitchinfo_color:visibility(false)
    ui.ARSswitchinfo_x:visibility(false)
    ui.ARSswitchinfo_y:visibility(false)
    ui.ARStpswitch:visibility(false)
    ui.ARSaamain:visibility(false)
    ui.ARSsettingsmode:visibility(false)
  end
    if ui.ARSswitchinfo_size:get() == "[Small]" then
      text_size = 2
    elseif ui.ARSswitchinfo_size:get() == "[Medium]" then
      text_size = 1
    elseif ui.ARSswitchinfo_size:get() == "[Large]" then
      text_size = 3
    end
    if ui.ARSaamain:get() then
      ui.ARSyawjitterval:visibility(true)
    else
      ui.ARSyawjitterval:visibility(false)
    end

end


events.aim_ack:set(function()
end)


events.render:set(function()
  if not globals.is_connected then return end
  if not globals.is_in_game then return end
  local local_player = entity.get_local_player()
  showshit()
	if not local_player or not local_player:is_alive() then
		return
	end
if not ui.ARSswitch:get() then return end
	local camera_position = render.camera_position()
	local camera_angle = render.camera_angles()
	local direction = vector():angles(camera_angle)

	local closest_distance, closest_enemy = math.huge
	for _, enemy in ipairs(entity.get_players(true)) do
		local head_position = enemy:get_hitbox_position(1)

    if ui.ARSsettingsmode:get() == "[Crosshair]" then
      distance = head_position:dist_to_ray(camera_position, direction)
    elseif ui.ARSsettingsmode:get() == "[Distance]" then
      distance = camera_position:dist(head_position)
    end

		if distance < closest_distance then
			closest_distance = distance
			closest_enemy = enemy
		end
	end

	if not closest_enemy then
		return
	end

  if ui.ARSswitchinfo:get() then
    render.text(3, vector(ui.ARSswitchinfo_x:get() + 500, ui.ARSswitchinfo_y:get() - 15), ui.ARSswitchinfo_color:get(), "c", "ARS [INFO]")

    render.text(text_size, vector(screen_size.x/2, screen_size.y/2 + 10), ui.ARSswitchinfo_color:get(), "c", "[A R S]")

    render.text(1, vector(ui.ARSswitchinfo_x:get() + 500, ui.ARSswitchinfo_y:get()), ui.ARSswitchinfo_color:get(), "c", "Target [" .. closest_enemy:get_name() .. "] at " .. math.floor(closest_distance) .. " units")
  end
    if ui.ARSswitchinfo:get() then
      render.text(1, vector(ui.ARSswitchinfo_x:get() + 500, ui.ARSswitchinfo_y:get() + 12), ui.ARSswitchinfo_color:get(), "c", "Head scale " .. find_menu.findMPH:get())
      render.text(1, vector(ui.ARSswitchinfo_x:get() + 500, ui.ARSswitchinfo_y:get() + 24), ui.ARSswitchinfo_color:get(), "c", "Body scale " .. find_menu.findMPB:get())
      render.text(1, vector(ui.ARSswitchinfo_x:get() + 500, ui.ARSswitchinfo_y:get() + 36), ui.ARSswitchinfo_color:get(), "c", "Hit Chance " .. find_menu.findhitchance:get())
      render.text(1, vector(ui.ARSswitchinfo_x:get() + 500, ui.ARSswitchinfo_y:get() + 48), ui.ARSswitchinfo_color:get(), "c", "Minimum Damage " .. find_menu.findmindmg:get())
    end
	if closest_enemy:is_alive() and closest_distance <= ui.ARScloserange:get() then -- near
    find_menu.findMPH:set(ui.ARSH1scale:get())
    find_menu.findMPB:set(ui.ARSB1scale:get())
    find_menu.findhitchance:set(ui.ARSHC1:get())
    if not ui.ARSswitchmindmgsafe:get() then
    find_menu.findmindmg:set(ui.ARSMD1:get())
    end
    if ui.ARSswitchinfo:get() then
    render.text(text_size, vector(screen_size.x/2, screen_size.y/2 + 22), color(255, 107, 107), "c", "[" .. closest_enemy:get_name() .. "] | CLOSE")
    end

  elseif closest_enemy:is_alive() and closest_distance >= ui.ARSlongrange:get() then -- far
    find_menu.findMPH:set(ui.ARSH2scale:get())
    find_menu.findMPB:set(ui.ARSB2scale:get())
    find_menu.findhitchance:set(ui.ARSHC2:get())
    if not ui.ARSswitchmindmgsafe:get() then
    find_menu.findmindmg:set(ui.ARSMD2:get())
    end
    if ui.ARSswitchinfo:get() then
    render.text(text_size, vector(screen_size.x/2, screen_size.y/2 + 22), color(255), "c", "[" .. closest_enemy:get_name() .. "] | AWAY")
    end
  elseif not closest_enemy then
    render.text(text_size, vector(screen_size.x/2, screen_size.y/2 + 22), color(255, 0, 0), "c", "Offline")
		end

    local chargeval = rage.exploit:get()
    if ui.ARSswitchinfo:get() and find_menu.DTindicator:get() and not find_menu.HSindicator:get() and chargeval == 1 then
        render.text(text_size, vector(screen_size.x/2, screen_size.y/2 + 34), ui.ARSswitchinfo_color:get(), "c", "Double Tap")
    elseif ui.ARSswitchinfo:get() and find_menu.DTindicator:get() and not find_menu.HSindicator:get() and chargeval == 0 then
        render.text(text_size, vector(screen_size.x/2, screen_size.y/2 + 34), color(255, 107, 107), "c", "Waiting...")
    elseif ui.ARSswitchinfo:get() and find_menu.HSindicator:get() and not find_menu.DTindicator:get() then
        render.text(text_size, vector(screen_size.x/2, screen_size.y/2 + 34), ui.ARSswitchinfo_color:get(), "c", "Anti OS")
    elseif ui.ARSswitchinfo:get() and find_menu.HSindicator:get() and find_menu.DTindicator:get() and chargeval == 1 then
        render.text(text_size, vector(screen_size.x/2, screen_size.y/2 + 34), ui.ARSswitchinfo_color:get(), "c", "Double Tap")
    elseif ui.ARSswitchinfo:get() and find_menu.DTindicator:get() and find_menu.HSindicator:get() and chargeval == 0 then
        render.text(text_size, vector(screen_size.x/2, screen_size.y/2 + 34), color(255, 107, 107), "c", "Waiting...")
    end

end)

function tpair()
  if not globals.is_connected then return end
  local local_player = entity.get_local_player()
  if not local_player:is_alive()  or not local_player then return end
    for _, enemy in ipairs(entity.get_players(true, false)) do
    if not enemy then
      return
    end
    if not ui.ARStpswitch:get() then return end
    if not enemy:is_alive() or not enemy:is_visible() then return end
     if enemy:is_alive() and enemy:is_visible() and is_in_air(local_player) then
       rage.exploit:force_teleport()
     end
   end
end
local table = {8, 64}

function yawjitter(cmd)
  local local_player = entity.get_local_player()
  if not local_player then return end
  find_menu.AAYawAdd:set(0)
  if is_in_air(local_player) then -- in air
    find_menu.AAdegree:set(-65)
    --print_dev("air")
  elseif not is_in_air(local_player) and not is_crouching(local_player) and not find_menu.findslowwalk:get() and get_velocity(local_player) < 3 then -- stand
    --print_dev("standing")
    find_menu.AAdegree:set(-76)
  elseif not is_in_air(local_player) and find_menu.findslowwalk:get() then -- walk
    --print_dev("walking")
    find_menu.AAdegree:set(-66)
  elseif not is_in_air(local_player) and not find_menu.findslowwalk:get() and get_velocity(local_player) > 3 then -- walk
    --print_dev("running")
    find_menu.AAdegree:set(-70)
  elseif not is_in_air(local_player) and is_crouching(local_player) then -- crouch
    --print_dev("crouching")
    find_menu.AAdegree:set(-70)
  end
end



events.createmove:set(function(cmd) -- Killsay
tpair()
yawjitter(cmd)
end)


events.bullet_fire:set(function(e) -- Killsay
  if not globals.is_connected then return end
  local local_player = entity.get_local_player()
  if not local_player then return end
  for _, enemy in ipairs(entity.get_players(true)) do
  end
end)

events.shutdown:set(function()
  cvar.sv_maxusrcmdprocessticks = 16
  print_dev("ARS [UNLOADED]")
  print("ARS [UNLOADED]. Console confirmation")
end)
