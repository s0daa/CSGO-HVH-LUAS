local tick = 0
local switch = false
local invert = false
local vector = require("vector")
local logs_txt = {}
local ffi = require("ffi")
local images = require "gamesense/images"
local js = panorama.open()
local player = entity.get_local_player()
local steamid3 = entity.get_steam64(player)
local avatar = images.get_steam_avatar(steamid3)
local charbuffer = ffi.typeof("char[?]")
local uintbuffer = ffi.typeof("unsigned int[?]")
local teamnum = entity.get_prop(lp, 'm_iTeamNum')
local ct      = teamnum == 3
local t       = teamnum == 2
local username = _G.obex_name == nil and 'Jordan' or _G.obex_name
local build_get = _G.obex_build == nil and 'User' or _G.obex_build 
local build = build_get:gsub('User', 'Live')
local version = "Update: 16/08"
local VGUI_System010 =  client.create_interface('vgui2.dll', 'VGUI_System010')
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010)

local keys = {
    doubletap = { ui.reference( 'RAGE', 'Other', 'Double tap' ) },
    fakeduck = ui.reference( 'RAGE', 'Other', 'Duck peek assist' ),
    safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
	forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
	quickpeek = { ui.reference("RAGE", "Other", "Quick peek assist")},
	onshotaa = { ui.reference("AA", "Other", "On shot anti-aim") },
	ping_spike = { ui.reference('MISC', 'Miscellaneous', 'Ping spike') },
	freestand = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
	min = ui.reference("RAGE", "Aimbot", "Minimum damage"),
}

ffi.cdef([[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]])
local get_clipboard_text_count = ffi.cast('get_clipboard_text_count', VGUI_System[0][7])
local set_clipboard_text = ffi.cast('set_clipboard_text', VGUI_System[0][9])
local get_clipboard_text = ffi.cast('get_clipboard_text', VGUI_System[0][11])
local clipboard_import = function()
    local clipboard_text_length = get_clipboard_text_count(VGUI_System)
    local clipboard_data = ''
    if clipboard_text_length > 0 then
        buffer = ffi.new('char[?]', clipboard_text_length)
        size = clipboard_text_length * ffi.sizeof('char[?]', clipboard_text_length)
        get_clipboard_text( VGUI_System, 0, buffer, size )
        clipboard_data = ffi.string(buffer, clipboard_text_length-1)
    end
    return clipboard_data
end
local clipboard_export = function(arg)
    set_clipboard_text(VGUI_System, arg, #arg)
end
local js = panorama.open()
local steamid64 = js.MyPersonaAPI.GetXuid()
local avatar = images.get_steam_avatar(steamid64)
local mypic = renderer.load_rgba(avatar.contents, avatar.width, avatar.height)
local screenx, screeny = client.screen_size()
local center = {screenx / 2, screeny / 2}
local cache = {
	nade = 0,
	enemy = 0,
	state = "Global",
	jitter = false,
	bf = false,
	dormant = false,
	dynamic = {
		center = 20,
		left = 20,
		right = -40,
	}
}

local function duck(x) return entity.get_prop(x, "m_flDuckAmount") > 0.1 end
local function air(x) return bit.band(entity.get_prop(x, "m_fFlags"), 1) == 0 end
local function call(x) return { ui.reference("aa", "anti-aimbot angles", x) } end
local function desync(z, x, count, vec)
	local selected = entity.get_player_weapon(z)
	if x.in_attack == 1 then
		local weapon = entity.get_classname(selected)
		if weapon:find("Grenade") then
			cache["nade"] = count
		else
			if entity.get_prop(selected, "m_flNextPrimaryAttack") - 0.1 < globals.curtime() - globals.tickinterval() then
				return false
			end
		end
	end
	local throw = entity.get_prop(selected, "m_fThrowTime")
	if cache["nade"] + 8 == count or (throw ~= nil and throw ~= 0) then return false end
	if entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1 then return false end
	if entity.get_prop(z, "m_MoveType") == 9 and vec ~= 0 then return false end
	if x.in_use == 1 then return false end
	return true
end
local function movement(z, x, myspeed)
	if myspeed ~= 0 and x.chokedcommands == 0 then
		if (myspeed > 1.010 and myspeed < 5) or myspeed < 1.008 then return false end
		if myspeed < 50 and air(z) then return false end
	end
	return true
end
local function velocity(player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	return math.sqrt(x*x + y*y + z*z)
end
local prefix = "\a323232FF{\aFFFFFFB2C\a323232FF} \aA688C863"
local luaenable = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "C A P Z I")
local fsenable = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "Freestanding Enable")
ui.set_visible(fsenable, false)
ui.set(luaenable, true)
ui.set_visible(luaenable, false)
local states = {"Global", "Standing", "Air", "Air Duck", "Move", "Ducking", "Slow Motion"}
local menu = {
	selection = ui.new_combobox("aa", "anti-aimbot angles", prefix .. "C A P Z I", {"Keys", "Visuals", "Miscellaneous", "Config"}),
	hotkeys = {
		roll = ui.new_hotkey("aa", "anti-aimbot angles", prefix .. "Roll Key"),
		left = ui.new_hotkey("aa", "anti-aimbot angles", prefix .. "Left Key"),
		right = ui.new_hotkey("aa", "anti-aimbot angles", prefix .. "Right Key"),
		back = ui.new_hotkey("aa", "anti-aimbot angles", prefix .. "Back Key"),
		teleport = ui.new_hotkey("aa", "anti-aimbot angles", prefix .. "Teleport"),
		freestanding = ui.new_hotkey("aa", "anti-aimbot angles", prefix .. "Freestanding Key"),
	},
	visual = {
		screen = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "Crosshair Indicators"),
		color = ui.new_color_picker("aa", "anti-aimbot angles", "Color\n", 55, 155, 155, 255),
		min = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "Min DMG Indicator"),
		info = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "Information Panel"),
		arrows = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "Manual Arrows"),
		notify = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "Notify Logs"),
		mode = ui.new_combobox("aa", "anti-aimbot angles", prefix .. "Indication Mode", "Gradient", "Modern"),
		position = ui.new_combobox("aa", "anti-aimbot angles", prefix .. "Watermark Position", "Default", "Above Radar", "Middle Left"),
		label = ui.new_label("aa", "anti-aimbot angles", " "),
	},
	misc = {
		animator = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "Local Player Animations"),
		dt = ui.new_combobox("aa", "anti-aimbot angles", prefix .. "Force Defensive", "Dynamic", "Always"),
		dt_recharge = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "Recharge Fix"),
		recharge_slider = ui.new_slider("aa", "anti-aimbot angles", prefix .. " Recharge Tick Delay", 1, 15, 4),
		os_fix = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "Onshot Fix"),
		os_slider = ui.new_slider("aa", "anti-aimbot angles", prefix .. " Onshot Fakelag", 1, 15, 3),
	},
	toggle = {},
	options = {},
	left = {},
	right = {},
	bfleft = {},
	bfright = {},
	yaw = {},
	jitter = {},
	lby = {},
	refs = {
		enable = call("enabled"),
		pitch = call("pitch"),
		base = call("yaw base"),
		yaw = call("yaw"),
		jitter = call("yaw jitter"),
		body = call("body yaw"),
		fs = call("freestanding body yaw"),
		limit = call("fake yaw limit"),
		edge = call("edge yaw"),
		freestand = call("freestanding"),
		roll = call("roll")
	}
}
local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
	local output = ''
	local len = #text-1
	local rinc = (r2 - r1) / len
	local ginc = (g2 - g1) / len
	local binc = (b2 - b1) / len
	local ainc = (a2 - a1) / len
	for i=1, len+1 do
		output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))

		r1 = r1 + rinc
		g1 = g1 + ginc
		b1 = b1 + binc
		a1 = a1 + ainc
	end
	return output
end
local notify = {}
local function pushnotify(txt)
	notify[#notify+1] = {
		text = txt,
		alpha = 0,
		cache = 0
	}
end
client.set_event_callback("paint_ui", function()
	if ui.get(menu.visual.notify) then
		local r, g, b = ui.get(menu.visual.color)
		local currentsize = 0
		for index, value in next, notify do
			currentsize = currentsize + 1
		end
		local reachedlimit = 9
		local currentlimit = 0
		for x = 0, currentsize do
			if notify[x] ~= nil then
				currentlimit = currentlimit + 1
				if currentlimit < reachedlimit then
					if notify[x]["cache"] ~= globals.tickcount() then
						notify[x]["cache"] = globals.tickcount()
						if notify[x]["alpha"] < 255 then
							if notify[x]["alpha"] < 15 then
								notify[x]["tick"] = globals.tickcount()
							end
							notify[x]["alpha"] = notify[x]["alpha"] + 2.5
						else
							notify[x] = nil
						end
					end
					if notify[x] ~= nil and ui.get(menu.visual.mode) == "Gradient" then
						renderer.gradient(center[1] - 100, center[2] - (globals.tickcount() - notify[x]["tick"]) + (currentlimit * 25) + center[2]/2, 200, 10, 255, 255, 255, 255-notify[x]["alpha"], r, g, b, 255-notify[x]["alpha"], true)
						renderer.circle(center[1] - 100, center[2] - (globals.tickcount() - notify[x]["tick"]) + (currentlimit * 25) + center[2]/2 + 5, 255,255,255,255-notify[x]["alpha"], 5, 180, 0.5)
						renderer.circle(center[1] + 100, center[2] - (globals.tickcount() - notify[x]["tick"]) + (currentlimit * 25) + center[2]/2 + 5, r,g,b,255-notify[x]["alpha"], 5, 0, 0.5)
						renderer.text(center[1], center[2] - (globals.tickcount() - notify[x]["tick"]) + (currentlimit * 25) + center[2]/2 + 5, 255, 255, 255, 255-notify[x]["alpha"], "-c", 0, gradient_text(255, 255, 255, 255-notify[x]["alpha"], r, g, b, 255-notify[x]["alpha"],notify[x]["text"]:upper()))
					elseif notify[x] ~= nil and ui.get(menu.visual.mode) == "Modern" then
						renderer.rectangle(center[1] - 100, center[2] - (globals.tickcount() - notify[x]["tick"]) + (currentlimit * 25) + center[2]/2, 200, 10, 26,26,39, 255-notify[x]["alpha"])
						renderer.rectangle(center[1] - 100, center[2] - (globals.tickcount() - notify[x]["tick"]) + (currentlimit * 25) + center[2]/2, 2, 10, r,g,b, 255-notify[x]["alpha"])
						renderer.text(center[1], center[2] - (globals.tickcount() - notify[x]["tick"]) + (currentlimit * 25) + center[2]/2 + 5, 255, 255, 255, 255-notify[x]["alpha"], "-c", 0, gradient_text(255, 255, 255, 255-notify[x]["alpha"], r, g, b, 255-notify[x]["alpha"],notify[x]["text"]:upper()))
					end
				end
			end
		end
	end
end)


client.set_event_callback("aim_miss", function(event)
	pushnotify("Skeet Missed shot due " .. event.reason)
end)
local base64={}local extract=_G.bit32 and _G.bit32.extract if not extract then if _G.bit then local shl,shr,band=_G.bit.lshift,_G.bit.rshift,_G.bit.band extract=function(v,from,width)return band(shr(v,from),shl(1,width)-1)end elseif _G._VERSION=="Lua 5.1"then extract=function(v,from,width)local w=0 local flag=2^from for i=0,width-1 do local flag2=flag+flag if v%flag2>=flag then w=w+2^i end flag=flag2 end return w end else extract=load[[return function( v, from, width )
	return ( v >> from ) & ((1 << width) - 1)
end]]()end end function base64.makeencoder(s62,s63,spad)local encoder={}for b64code,char in pairs{[0]='A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9',s62 or'+',s63 or'/',spad or'='}do encoder[b64code]=char:byte()end return encoder end function base64.makedecoder(s62,s63,spad)local decoder={}for b64code,charcode in pairs(base64.makeencoder(s62,s63,spad))do decoder[charcode]=b64code end return decoder end local DEFAULT_ENCODER=base64.makeencoder()local DEFAULT_DECODER=base64.makedecoder()local char,concat=string.char,table.concat function base64.encode(str,encoder,usecaching)encoder=encoder or DEFAULT_ENCODER local t,k,n={},1,#str local lastn=n%3 local cache={}for i=1,n-lastn,3 do local a,b,c=str:byte(i,i+2)local v=a*0x10000+b*0x100+c local s if usecaching then s=cache[v]if not s then s=char(encoder[extract(v,18,6)],encoder[extract(v,12,6)],encoder[extract(v,6,6)],encoder[extract(v,0,6)])cache[v]=s end else s=char(encoder[extract(v,18,6)],encoder[extract(v,12,6)],encoder[extract(v,6,6)],encoder[extract(v,0,6)])end t[k]=s k=k+1 end if lastn==2 then local a,b=str:byte(n-1,n)local v=a*0x10000+b*0x100 t[k]=char(encoder[extract(v,18,6)],encoder[extract(v,12,6)],encoder[extract(v,6,6)],encoder[64])elseif lastn==1 then local v=str:byte(n)*0x10000 t[k]=char(encoder[extract(v,18,6)],encoder[extract(v,12,6)],encoder[64],encoder[64])end return concat(t)end function base64.decode(b64,decoder,usecaching)decoder=decoder or DEFAULT_DECODER local pattern='[^%w%+%/%=]'if decoder then local s62,s63 for charcode,b64code in pairs(decoder)do if b64code==62 then s62=charcode elseif b64code==63 then s63=charcode end end pattern=('[^%%w%%%s%%%s%%=]'):format(char(s62),char(s63))end b64=b64:gsub(pattern,'')local cache=usecaching and{}local t,k={},1 local n=#b64 local padding=b64:sub(-2)=='=='and 2 or b64:sub(-1)=='='and 1 or 0 for i=1,padding>0 and n-4 or n,4 do local a,b,c,d=b64:byte(i,i+3)local s if usecaching then local v0=a*0x1000000+b*0x10000+c*0x100+d s=cache[v0]if not s then local v=decoder[a]*0x40000+decoder[b]*0x1000+decoder[c]*0x40+decoder[d]s=char(extract(v,16,8),extract(v,8,8),extract(v,0,8))cache[v0]=s end else local v=decoder[a]*0x40000+decoder[b]*0x1000+decoder[c]*0x40+decoder[d]s=char(extract(v,16,8),extract(v,8,8),extract(v,0,8))end t[k]=s k=k+1 end if padding==1 then local a,b,c=b64:byte(n-3,n-1)local v=decoder[a]*0x40000+decoder[b]*0x1000+decoder[c]*0x40 t[k]=char(extract(v,16,8),extract(v,8,8))elseif padding==2 then local a,b=b64:byte(n-3,n-2)local v=decoder[a]*0x40000+decoder[b]*0x1000 t[k]=char(extract(v,16,8))end return concat(t)end local function ascii_base(s)return s:lower()==s and('a'):byte()or('A'):byte()end local function caesar_cipher(str,key)return(str:gsub('%a',function(s)local base=ascii_base(s)return string.char(((s:byte()-base+key)%26)+base)end))end local function cipher(str,array)return caesar_cipher(str,array)end local function decipher(str,array)return caesar_cipher(str,-array)end local function split(text,chunkSize)local s={}for i=1,#text,chunkSize do s[#s+1]=text:sub(i,i+chunkSize-1)end return s end local function encrypt(inp,offset)a=base64.encode(inp)chunks=split(a,offset)for _,line in ipairs(chunks)do num=math.random(1,9)chunks[_]=cipher(line,num)..num end return table.concat(chunks)end local function decrypt(inp,offset)chunks=split(inp,offset+1)for _,line in ipairs(chunks)do a=string.sub(line,-1)b=line:sub(1,string.len(line)-1)c=decipher(b,a)chunks[_]=c end d=table.concat(chunks)e=base64.decode(d)return(e)end
local export = ui.new_button("aa", "anti-aimbot angles", prefix .. "Export CFG", function()
	local output = {}
	for index, value in next, menu do
		if type(value) == "number" then
			output[index] = ui.get(value)
		else
			for i, v in next, value do
				if output[index] == nil then
					output[index] = {}
				end
				if type(v) == "number" then
					if i == "color" then
						output[index][i] = {ui.get(v)}
					else
						output[index][i] = ui.get(v)
					end
				else
					for iii, vvv in next, v do
						if output[index][iii] == nil then
							output[index][iii] = {}
						end
						output[index][iii] = ui.get(vvv)
					end
				end
			end
		end
	end
	clipboard_export(encrypt(json.stringify(output), 9))
end)
local import = ui.new_button("aa", "anti-aimbot angles", prefix .. "Import CFG", function()
	local errorcheck = pcall(function()
		local input = json.parse(decrypt(clipboard_import(), 9))
		for index, value in next, input do
			if type(value) == "table" then
				for i, v in next, value do
					pcall(function()
						if i == "color" then
							ui.set(menu[index][i], unpack(input[index][i])) 
						else
							ui.set(menu[index][i], input[index][i]) 
						end
					end)
				end
			else
				ui.set(menu[index], input[index])
			end
		end
	end)
	if not errorcheck then
		pushnotify("failed to import config, try again!")
	else
		pushnotify("loaded config, enjoy!")
	end
end)
menu.state = ui.new_combobox("aa", "anti-aimbot angles", prefix .. "Anti Aimbot", states)
for index, value in next, states do
	local suffix = prefix .. "" .. value .. " $"
	if value == "Global" then
		menu.toggle[value .. ""] = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "Custom Settings")
	else
		menu.toggle[value .. ""] = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "AA: " .. value)
	end
	--menu.preset[value .. ""] = ui.new_checkbox("aa", "anti-aimbot angles", prefix .. "Enable Preset")
	menu.options[value .. ""] = ui.new_multiselect("aa", "anti-aimbot angles", suffix .. " Features", "Center", "Jitter", "Anti-Brute", "Lower Body Yaw", "Automatic Desync", "Invert Automatic")
	menu.left[value .. ""] = ui.new_slider("aa", "anti-aimbot angles", suffix .. " Yaw Left", -90, 90, -10)
	menu.right[value .. ""] = ui.new_slider("aa", "anti-aimbot angles", suffix .. " Yaw Right", -90, 90, 10)
	menu.bfleft[value .. ""] = ui.new_slider("aa", "anti-aimbot angles", suffix .. " Anti-Brute Yaw Left", -90, 90, -10)
	menu.bfright[value .. ""] = ui.new_slider("aa", "anti-aimbot angles", suffix .. " Anti-Brute Yaw Right", -90, 90, 10)
	menu.yaw[value .. ""] = ui.new_slider("aa", "anti-aimbot angles", suffix .. " Yaw Center", -180, 180, 0)
	menu.lby[value .. ""] = ui.new_slider("aa", "anti-aimbot angles", suffix .. " Lower Body Yaw", -180, 180, 180)
end
menu.dynamic = ui.new_multiselect("aa", "anti-aimbot angles", prefix .. "Force New AA", "New Enemy", "Dormant", "Shot", "Death")
menu.method = ui.new_combobox("aa", "anti-aimbot angles", prefix .. "AA Generator", "-", "Aggressive", "Defensive", "Dynamic")
local function toggle(bool)
	for x, z in next, menu.refs do
		ui.set_visible(z[1], bool)
		if z[2] ~= nil then
			ui.set_visible(z[2], bool)
		end
	end
end
local slow_check, slow_key = ui.reference("aa", "other", "slow motion")
local function state(myself, velocity, air)
	local state = "Global"
	local ground = bit.band(entity.get_prop(myself, "m_fFlags"), bit.lshift(1, 0)) == 1 and not air
	local duck = duck(myself)
	local slow = ui.get(slow_check) and ui.get(slow_key)

	if ui.get(menu.toggle["Standing"]) and ground and velocity < 30 then
		state = "Standing"
	end
	if ui.get(menu.toggle["Ducking"]) and ground and duck and velocity < 20 then
		state = "Ducking"
	end
	if ui.get(menu.toggle["Slow Motion"]) and slow and ground and not duck and velocity > 30 then
		state = "Slow Motion"
	end
	if ui.get(menu.toggle["Move"]) and ground and not duck and velocity > 30 and not slow then
		state = "Move"
	end
	if ui.get(menu.toggle["Air"]) and air and not duck then
		state = "Air"
	end
	if ui.get(menu.toggle["Air Duck"]) and air and duck then
		state = "Air Duck"
	end
	return state
end
local fl = ui.reference("aa", "fake lag", "enabled")
local limit = ui.reference("aa", "fake lag", "limit")
local variance = ui.reference("aa", "fake lag", "variance")
client.set_event_callback("shutdown", function(arg)
	toggle(true)
end)

local function automatic()
	
	local method = ui.get(menu.method)
	if ui.get(luaenable) then
	if method == "Dynamic" then
		method = client.random_int(1,3)
		if method == 1 then
			cache["dynamic"] = {
				center = client.random_int(15,25),
				left = client.random_int(-15,-10),
				right = -client.random_int(10,25)
			}
		end
		if method == 2 then
			cache["dynamic"] = {
				center = client.random_int(0,5),
				left = -client.random_int(-25,-22),
				right = client.random_int(25,30)
			}
		end
		if method == 3 then
			cache["dynamic"] = {
				center = client.random_int(15,20),
				left = -client.random_int(40,35),
				right = client.random_int(10,15)
			}
		end
	else
		if method == "Aggressive" then
			cache["dynamic"] = {
				center = client.random_int(15,25),
				left = client.random_int(15,25),
				right = -client.random_int(35,45)
			}
		end
		if method == "Defensive" then
			cache["dynamic"] = {
				center = client.random_int(0,5),
				left = -client.random_int(25,30),
				right = client.random_int(25,30)
			}
		end
	end
end
end


local function tablecontains(tbl, element) 
	for _, value in pairs(tbl) do 
		if value == element then 
			return true 
		end 
	end 
	return false 
end
local function get_camera_pos(entindex)
	local e_x, e_y, e_z = entity.get_prop(entindex, "m_vecOrigin")
	if e_x == nil then return end
	local _, _, ofs = entity.get_prop(entindex, "m_vecViewOffset")
	e_z = e_z + (ofs - (entity.get_prop(entindex, "m_flDuckAmount") * 16))
	return e_x, e_y, e_z
end
local function fired_at(target, shooter, shot)
	local shooter_cam = { get_camera_pos(shooter) }
	if shooter_cam[1] == nil then return end
	local player_head = { entity.hitbox_position(target, 0) }
	local shooter_cam_to_head = { 
		player_head[1] - shooter_cam[1],
		player_head[2] - shooter_cam[2],
		player_head[3] - shooter_cam[3] 
	}
	local shooter_cam_to_shot = { 
		shot[1] - shooter_cam[1], 
		shot[2] - shooter_cam[2],
		shot[3] - shooter_cam[3]
	}
	local tt = (
		(shooter_cam_to_head[1]*shooter_cam_to_shot[1]) + 
		(shooter_cam_to_head[2]*shooter_cam_to_shot[2]) + 
		(shooter_cam_to_head[3]*shooter_cam_to_shot[3])
	) / (
		math.pow(shooter_cam_to_shot[1], 2) + 
		math.pow(shooter_cam_to_shot[2], 2) + 
		math.pow(shooter_cam_to_shot[3], 2)
	)
	local closest = { shooter_cam[1] + shooter_cam_to_shot[1]*tt, shooter_cam[2] + shooter_cam_to_shot[2]*tt, shooter_cam[3] + shooter_cam_to_shot[3]*tt}
	local length = math.abs(
		math.sqrt(
			math.pow((player_head[1]-closest[1]), 2) + 
			math.pow((player_head[2]-closest[2]), 2) + 
			math.pow((player_head[3]-closest[3]), 2)
		)
	)
	local frac_shot = client.trace_line(shooter, shot[1], shot[2], shot[3], player_head[1], player_head[2], player_head[3])
	local frac_final = client.trace_line(target, closest[1], closest[2], closest[3], player_head[1], player_head[2], player_head[3])
	return (length < 66) and (frac_shot > 0.99 or frac_final > 0.99)
end
local bf_tick_log = -1337
client.set_event_callback("bullet_impact", function(event)
	if entity.get_local_player() == nil then return end
	local entindex = client.userid_to_entindex(event.userid)
	local lp = entity.get_local_player()
	if entindex == entity.get_local_player() or not entity.is_enemy(entindex) then return end
	if fired_at(lp, entindex, {event.x, event.y, event.z}) then
		if bf_tick_log ~= globals.tickcount() then
			bf_tick_log = globals.tickcount()
			local state = cache["state"]
			local dynamic = not ui.get(menu["toggle"][state])
			if tablecontains(ui.get(menu.options[state]), "Anti-Brute") and not dynamic then
				cache["bf"] = true
				pushnotify("Anti-brute shot by ", string.lower(entity.get_player_name(entindex)))
			end
			if tablecontains(ui.get(menu.dynamic), "Shot") and dynamic then
				automatic()
				pushnotify("New preset - shot by", string.lower(entity.get_player_name(entindex)))
			end
		end
	end
end)
local death_tick = 0
client.set_event_callback("player_death", function(event)
	if death_tick ~= globals.tickcount() then
		death_tick = globals.tickcount()
		local state = cache["state"]
		local dynamic = not ui.get(menu["toggle"][state])
		if tablecontains(ui.get(menu.options[state]), "Anti-Brute") and not dynamic then
			if (client.userid_to_entindex(event.userid) == entity.get_local_player()) then
				cache["bf"] = false
				pushnotify("Capzi:   Disabled Anti-brute due to death")
			end
		end
		if tablecontains(ui.get(menu.dynamic), "Death") and dynamic then
			if (client.userid_to_entindex(event.userid) == entity.get_local_player()) then
				automatic()
				pushnotify("Capzi:  Saet new AA due to death")
			end
		end
	end
end)
client.set_event_callback("round_prestart", function()
	local state = cache["state"]
	if tablecontains(ui.get(menu.options[state]), "Anti-Brute") and ui.get(menu["toggle"][state]) then
		cache["bf"] = false
		pushnotify("Capzi:  Disabled Anti-brute due to new round")
	end
end)
local manual = 0
local fired_shot_tick = 0
client.set_event_callback("aim_fire", function()
	fired_shot_tick = globals.tickcount()
end)
local animated = {
	scope = 0,
	bar = 0,
	height = 0
}
client.set_event_callback("paint_ui", function(arg)
	ui.set(fl, true)
	local hideshot = ui.get(keys.onshotaa[1]) and ui.get(keys.onshotaa[2])
	local doubletap = ui.get(keys.doubletap[1]) and ui.get(keys.doubletap[2])

	if ui.get(menu.hotkeys.teleport) then
		ui.set(keys.doubletap[2], "On Hotkey")
	else
		ui.set(keys.doubletap[2], "Toggle")
	end

	if ui.get(menu.misc.os_fix) and (hideshot) then
		ui.set(limit, ui.get(menu.misc.os_slider))
	end

	if ui.get(menu.misc.dt_recharge) and fired_shot_tick + menu.misc.recharge_slider > globals.tickcount() then
		ui.set(limit, 1)
	else
		if ui.get(menu.misc.dt_recharge) and (doubletap or hideshot) and not ui.get(keys.fakeduck) then
			ui.set(limit, 14)
		else
			ui.set(limit, 13)
		end
	end
	ui.set(menu.hotkeys.left, "on hotkey")
	ui.set(menu.hotkeys.right, "on hotkey")
	if ui.is_menu_open() then
		toggle(false)
		for index, value in next, menu.toggle do ui.set_visible(value, false) end
		for index, value in next, menu.left do ui.set_visible(value, false) end
		for index, value in next, menu.right do ui.set_visible(value, false) end
		for index, value in next, menu.bfleft do ui.set_visible(value, false) end
		for index, value in next, menu.bfright do ui.set_visible(value, false) end
		for index, value in next, menu.yaw do ui.set_visible(value, false) end
		for index, value in next, menu.options do ui.set_visible(value, false) end
		for index, value in next, menu.jitter do ui.set_visible(value, false) end
		for index, value in next, menu.lby do ui.set_visible(value, false) end
		if ui.get(menu.state) == "Global" then
			ui.set_visible(menu.toggle[ui.get(menu.state)], true)
			ui.set_visible(menu.left[ui.get(menu.state)], ui.get(menu.toggle[ui.get(menu.state)]))
			ui.set_visible(menu.right[ui.get(menu.state)], ui.get(menu.toggle[ui.get(menu.state)]))
			ui.set_visible(menu.bfleft[ui.get(menu.state)], tablecontains(ui.get(menu.options[ui.get(menu.state)]), "Anti-Brute") and ui.get(menu.toggle[ui.get(menu.state)]))
			ui.set_visible(menu.bfright[ui.get(menu.state)], tablecontains(ui.get(menu.options[ui.get(menu.state)]), "Anti-Brute") and ui.get(menu.toggle[ui.get(menu.state)]))
			ui.set_visible(menu.yaw[ui.get(menu.state)], tablecontains(ui.get(menu.options[ui.get(menu.state)]), "Center") and ui.get(menu.toggle[ui.get(menu.state)]))
			ui.set_visible(menu.lby[ui.get(menu.state)], tablecontains(ui.get(menu.options[ui.get(menu.state)]), "Lower Body Yaw") and ui.get(menu.toggle[ui.get(menu.state)]))
			ui.set_visible(menu.options[ui.get(menu.state)], ui.get(menu.toggle[ui.get(menu.state)]))
			ui.set_visible(menu.dynamic, not ui.get(menu.toggle[ui.get(menu.state)]))
			ui.set_visible(menu.method, not ui.get(menu.toggle[ui.get(menu.state)]))
		else
			ui.set_visible(menu.toggle[ui.get(menu.state)], true)
			ui.set_visible(menu.left[ui.get(menu.state)], ui.get(menu.toggle[ui.get(menu.state)]))
			ui.set_visible(menu.right[ui.get(menu.state)], ui.get(menu.toggle[ui.get(menu.state)]))
			ui.set_visible(menu.bfleft[ui.get(menu.state)], ui.get(menu.toggle[ui.get(menu.state)]) and tablecontains(ui.get(menu.options[ui.get(menu.state)]), "Anti-Brute"))
			ui.set_visible(menu.bfright[ui.get(menu.state)], ui.get(menu.toggle[ui.get(menu.state)]) and tablecontains(ui.get(menu.options[ui.get(menu.state)]), "Anti-Brute"))
			ui.set_visible(menu.yaw[ui.get(menu.state)], ui.get(menu.toggle[ui.get(menu.state)]) and tablecontains(ui.get(menu.options[ui.get(menu.state)]), "Center"))
			ui.set_visible(menu.lby[ui.get(menu.state)], ui.get(menu.toggle[ui.get(menu.state)]) and tablecontains(ui.get(menu.options[ui.get(menu.state)]), "Lower Body Yaw"))
			ui.set_visible(menu.options[ui.get(menu.state)], ui.get(menu.toggle[ui.get(menu.state)]))
			ui.set_visible(menu.dynamic, false)
			ui.set_visible(menu.method, false)
		end
		for index, value in next, menu.hotkeys do ui.set_visible(value, ui.get(menu.selection) == "Keys") end
		for index, value in next, menu.visual do ui.set_visible(value, ui.get(menu.selection) == "Visuals") end
		for index, value in next, menu.misc do ui.set_visible(value, ui.get(menu.selection) == "Miscellaneous") end
		ui.set_visible(export, ui.get(menu.selection) == "Config") 
		ui.set_visible(import, ui.get(menu.selection) == "Config") 	
	else toggle(true) end
	local lp = entity.get_local_player()
	if lp ~= nil then
		local r, g, b = ui.get(menu.visual.color)
		local alpha_pulse = math.min(math.floor(math.sin((globals.realtime() % 4) * 4) * 75 + 150), 255)
		if entity.is_alive(lp) then
			if ui.get(menu.visual.arrows) then
				if manual == -90 then
					renderer.text(center[1] - 40, center[2] + 3, r, g, b, 255, "", 0, "<")
				end
				if manual == 90 then
					renderer.text(center[1] + 40, center[2] + 3, r, g, b, 255, "", 0, ">")
				end
			end


			if ui.get(menu.visual.screen) and ui.get(menu.visual.mode) == "Gradient" then
				local pose = math.max(-60, math.min(60, math.floor((entity.get_prop(lp,"m_flPoseParameter",11) or 0)*120-60+0.5)))
				local scpd = entity.get_prop(lp, "m_bIsScoped")
				if scpd ~= 0 then
					if animated.scope < 20 then
						animated.scope = animated.scope + 1
					end
				else
					if animated.scope > 0 then
						animated.scope = animated.scope - 1
					end
				end
				renderer.text(center[1] - 15 + animated.scope, center[2] + 4, 26,26,39, 255, "-", 0, gradient_text(255,255,255,255,r,g,b,alpha_pulse,"CAPZI  " .. build:upper() .. ""))
				if ui.get(menu.visual.min) then
					renderer.text(center[1] - 23 + animated.scope + 8, center[2] - 10, 255, 255, 255, 255, "-", 0, "" .. ui.get(keys.min) .. "")
				end
				local dynamic = not ui.get(menu["toggle"][cache["state"]])
				if dynamic then
					renderer.text(center[1] - 22 + animated.scope + 8, center[2] + 15 + animated.height, 255, 255, 255, 255, "-", 0, ui.get(menu.method):upper())
				else
					renderer.text(center[1] - 22 + animated.scope + 8, center[2] + 15 + animated.height, 255, 255, 255, 255, "-", 0, cache["state"]:upper())
				end
				local str_pose = "+"
				if pose < 10 then
					pose = pose*-1
					str_pose = "-"
				end
				if animated.bar < pose then
					animated.bar = animated.bar + 1
				else
					animated.bar = animated.bar - 1
				end
				if animated.bar < 1 then
					animated.bar = 0
					animated.height = 0
				else
					renderer.text(center[1] - 21 + animated.scope + 8 + animated.bar , center[2] + 16, r, g, b, 255, "c-", 0, str_pose .. pose)
				end
				if animated.height < 6 then
					animated.height = animated.height + 1
				end
				renderer.gradient(center[1] - 21 + animated.scope + 8, center[2] + 16, animated.bar, 3.5, 255, 255, 255, 255, r, g, b, 255, true)
				local list_keys = {}
				if doubletap then
					list_keys[#list_keys+1] = "DT"
				end
				if hideshot then
					list_keys[#list_keys+1] = "OS"
				end
				if ui.get(keys.forcebaim) then
					list_keys[#list_keys+1] = "FB"
				end
				if ui.get(keys.safepoint) then
					list_keys[#list_keys+1] = "SP"
				end
				if ui.get(keys.ping_spike[1]) and ui.get(keys.ping_spike[2]) then
					list_keys[#list_keys+1] = "PS"
				end
				if ui.get(keys.fakeduck) then
					list_keys[#list_keys+1] = "FD"
				end
				if ui.get(keys.quickpeek[1]) and ui.get(keys.quickpeek[2]) then
					list_keys[#list_keys+1] = "QP"
				end
				if ui.get(menu.refs.freestand[2]) then
					list_keys[#list_keys+1] = "FS"
				end
				local str_result = ""
				for index, value in next, list_keys do
					str_result = str_result .. "   " .. value
				end
				renderer.text(center[1] - 25 + animated.scope + 8, center[2] + 25 + animated.height, 255, 255, 255, 255, "-", 0, str_result)
			elseif ui.get(menu.visual.screen) and ui.get(menu.visual.mode) == "Modern" then
				local scpd = entity.get_prop(lp, "m_bIsScoped")
				local pose = math.max(-60, math.min(60, math.floor((entity.get_prop(lp,"m_flPoseParameter",11) or 0)*120-60+0.5)))
				if scpd ~= 0 then
					if animated.scope < 20 then
						animated.scope = animated.scope + 1
					end
				else
					if animated.scope > 0 then
						animated.scope = animated.scope - 1
					end
				end
				renderer.text(center[1] - 15 + animated.scope, center[2] + 4, 26,26,39, 255, "-", 0, gradient_text(255,255,255,255,r,g,b,alpha_pulse,"CAPZI  " .. build:upper() .. ""))
				if ui.get(menu.visual.min) then
					renderer.text(center[1] - 23 + animated.scope + 8, center[2] - 10, 255, 255, 255, 255, "-", 0, "" .. ui.get(keys.min) .. "")
				end
				local dynamic = not ui.get(menu["toggle"][cache["state"]])
				if dynamic then
					renderer.text(center[1] - 22 + animated.scope + 8, center[2] + 15 + animated.height, 255, 255, 255, 255, "-", 0, ui.get(menu.method):upper())
				else
					renderer.text(center[1] - 22 + animated.scope + 8, center[2] + 15 + animated.height, 255, 255, 255, 255, "-", 0, cache["state"]:upper())
				end
				local str_pose = "+"
				if pose < 10 then
					pose = pose*-1
					str_pose = "-"
				end
				if animated.bar < pose then
					animated.bar = animated.bar + 1
				else
					animated.bar = animated.bar - 1
				end
				if animated.bar < 1 then
					animated.bar = 0
					animated.height = 0
				else
					renderer.text(center[1] - 21 + animated.scope + 8 + animated.bar , center[2] + 15, r, g, b, 255, "c-", 0, str_pose .. pose)
				end
				if animated.height < 3 then
					animated.height = animated.height + 1
				end
				renderer.gradient(center[1] - 21 + animated.scope + 8, center[2] + 15, animated.bar, 3.5, 255, 255, 255, 255, r, g, b, 255, true)
				local list_keys = {}
				if doubletap then
					list_keys[#list_keys+1] = "DT"
				end
				if hideshot then
					list_keys[#list_keys+1] = "OS"
				end
				if ui.get(keys.forcebaim) then
					list_keys[#list_keys+1] = "FB"
				end
				if ui.get(keys.safepoint) then
					list_keys[#list_keys+1] = "SP"
				end
				if ui.get(keys.ping_spike[1]) and ui.get(keys.ping_spike[2]) then
					list_keys[#list_keys+1] = "PS"
				end
				if ui.get(keys.fakeduck) then
					list_keys[#list_keys+1] = "FD"
				end
				if ui.get(keys.quickpeek[1]) and ui.get(keys.quickpeek[2]) then
					list_keys[#list_keys+1] = "QP"
				end
				if ui.get(menu.refs.freestand[2]) then
					list_keys[#list_keys+1] = "FS"
				end
				local str_result = ""
				for index, value in next, list_keys do
					str_result = str_result .. "   " .. value
				end
				renderer.text(center[1] - 25 + animated.scope + 8, center[2] + 25 + animated.height, 255, 255, 255, 255, "-", 0, str_result)
			end
		end
		if ui.get(menu.visual.position) == "Default" and ui.get(menu.visual.mode) == "Gradient" then
		renderer.gradient((center[1]*2)-130, -40, 160, 78, r, g, b, 5, 255, 255, 255, 255, true)
		avatar:draw((center[1]*2)-38, 0, nil, 38, force_same_res)
		renderer.text((center[1]*2)-125, 5, 255, 255, 255, 255, "-", 0, gradient_text(255,255,255,255,r,g,b,255,"CAPZI  " .. build:upper() .. ""))
		renderer.text((center[1]*2)-100, 20, 255, 255, 255, 255, "c-", 0, gradient_text(255,255,255,255,r,g,b,255, "" .. version:upper() .. ""))
		renderer.text((center[1]*2)-125, 25, 255, 255, 255, 255, "-", 0, gradient_text(255,255,255,255,r,g,b,255, "" .. username:upper() .. ""))
		elseif ui.get(menu.visual.position) == "Above Radar" and ui.get(menu.visual.mode) == "Gradient" then
			renderer.gradient((center[1]/6)-130, -40, 160, 78, r, g, b, 255, 255, 255, 255, 5, true)
			avatar:draw((center[1]/26)-38, 0, nil, 38, force_same_res)
			renderer.text((center[1]/6)-122, 5, 255, 255, 255, 255, "-", 0, gradient_text(r, g, b, 255, 255, 255, 255, 255,"CAPZI  " .. build:upper() .. ""))
			renderer.text((center[1]/6)-122, 15, 255, 255, 255, 255, "-", 0, gradient_text(r,g,b,255,255,255,255,255, "" .. version:upper() .. ""))
			renderer.text((center[1]/6)-122, 25, 255, 255, 255, 255, "-", 0, gradient_text(r,g,b,255,255, 255, 255,255, "" .. username:upper() .. ""))
		elseif ui.get(menu.visual.position) == "Middle Left" and ui.get(menu.visual.mode) == "Gradient" then
			renderer.gradient((center[1]/6)-200, 600, 160, 38, r, g, b, 255, 255, 255, 255, 5, true)
			avatar:draw((center[1]/26)-38, 600, nil, 38, force_same_res)
			renderer.text((center[1]/6)-122, 605, 255, 255, 255, 255, "-", 0, gradient_text(r, g, b, 255, 255, 255, 255, 255,"CAPZI  " .. build:upper() .. ""))
			renderer.text((center[1]/6)-122, 615, 255, 255, 255, 255, "-", 0, gradient_text(r,g,b,255,255,255,255,255, "" .. version:upper() .. ""))
			renderer.text((center[1]/6)-122, 625, 255, 255, 255, 255, "-", 0, gradient_text(r,g,b,255,255, 255, 255,255, "" .. username:upper() .. ""))
		end

		if ui.get(menu.visual.info) then
			renderer.text((center[1]/6)-122, 615, r,g,b, 255, "-", 0, "> CAPZI .ANIMATIONS")
			renderer.text((center[1]/6)-122, 625, 255, 255, 255, 255, "-", 0, "> USER:")
			renderer.text((center[1]/6)-122, center[2] + 94, 255, 255, 255, 255, "-", 0, "> BUILD:")
			renderer.text((center[1]/6)-93, center[2] + 94, r,g,b, alpha_pulse, "-", 0, "" .. build:upper() .. "")
			renderer.text((center[1]/6)-95, 625, 255, 255, 255, 255, "-", 0, "" .. username:upper() .. "")			
		end

		if ui.get(menu.visual.position) == "Default" and ui.get(menu.visual.mode) == "Modern" then
			renderer.rectangle((center[1]*2)-130, -40, 160, 78, 26,26,39, 255)
			renderer.line((center[1]*2)-130, 0, (center[1]*2)-130, 37, r, g, b, 255)
			avatar:draw((center[1]*2)-38, 0, nil, 38, force_same_res)
			renderer.text((center[1]*2)-127, 5, 255, 255, 255, 255, "-", 0, gradient_text(255,255,255,255,r,g,b,255,"CAPZI  " .. build:upper() .. ""))
			renderer.text((center[1]*2)-102, 20, 255, 255, 255, 255, "c-", 0, gradient_text(255,255,255,255,r,g,b,255, "" .. version:upper() .. ""))
			renderer.text((center[1]*2)-127, 25, 255, 255, 255, 255, "-", 0, gradient_text(255,255,255,255,r,g,b,255, "" .. username:upper() .. ""))
			elseif ui.get(menu.visual.position) == "Above Radar" and ui.get(menu.visual.mode) == "Modern" then
				renderer.rectangle((center[1]/6)-168, 0, 130, 38, 26,26,39, 230)
				renderer.line((center[1]/6)-38, 0, (center[1]/6)-38, 38, r, g, b, 255)
				avatar:draw((center[1]/26)-38, 0, nil, 38, force_same_res)
				renderer.text((center[1]/6)-122, 5, 255, 255, 255, 255, "-", 0, gradient_text(r, g, b, 255, 255, 255, 255, 255,"CAPZI  " .. build:upper() .. ""))
				renderer.text((center[1]/6)-122, 15, 255, 255, 255, 255, "-", 0, gradient_text(r,g,b,255,255,255,255,255, "" .. version:upper() .. ""))
				renderer.text((center[1]/6)-122, 25, 255, 255, 255, 255, "-", 0, gradient_text(r,g,b,255,255, 255, 255,255, "" .. username:upper() .. ""))
			elseif ui.get(menu.visual.position) == "Middle Left" and ui.get(menu.visual.mode) == "Modern" then
				renderer.rectangle((center[1]/6)-170, 600, 130, 38, 26,26,39, 255)
				renderer.line((center[1]/6)-38, 600, (center[1]/6)-38, 638, r, g, b, 255)
				avatar:draw((center[1]/26)-38, 600, nil, 38, force_same_res)
				renderer.text((center[1]/6)-122, 605, 255, 255, 255, 255, "-", 0, gradient_text(r, g, b, 255, 255, 255, 255, 255,"CAPZI  " .. build:upper() .. ""))
				renderer.text((center[1]/6)-97, 620, 255, 255, 255, 255, "c-", 0, gradient_text(r,g,b,255,255,255,255,255, "" .. version:upper() .. ""))
				renderer.text((center[1]/6)-122, 625, 255, 255, 255, 255, "-", 0, gradient_text(r,g,b,255,255,255,255,255, "" .. username:upper() .. ""))
			end
		end
end)

client.set_event_callback('pre_render', function()
	if entity.get_local_player() ~= nil and ui.get(menu.misc.animator) then
		if air(entity.get_local_player()) then
			entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
		else
			entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
		end
	end
end)
local switch_mode = false
local jitter_mode = false
local cache_jitter = false
local last_enemy = 0
local last_dormant = 0
local last_manual = 0
--local dbg_slider = ui.new_slider("lua", "b", "dbg", -500, 500, 0)
client.set_event_callback("setup_command", function(arg)

	if ui.get(menu.hotkeys.freestanding) == true then
		ui.set(fsenable, true)
		ui.set(menu.refs.freestand[1], "Default")
		ui.set(menu.refs.freestand[2], "Always on")
		ui.set(menu.refs.base[1], "at targets")
		ui.set(menu.refs.enable[1], true)
		ui.set(menu.refs.pitch[1], "default")
		ui.set(menu.refs.yaw[1], "180")
		ui.set(menu.refs.roll[1], 0)
		ui.set(menu.refs.edge[1], false)
		ui.set(menu.refs.yaw[2], 0)
		ui.set(menu.refs.jitter[1], "Center")
		ui.set(menu.refs.jitter[2], 39)
		ui.set(menu.refs.body[1], "jitter")
		ui.set(menu.refs.body[2], 0)
		ui.set(menu.refs.limit[1], 60)
	else
		ui.set(fsenable, false)
		ui.set(menu.refs.freestand[2], "On Hotkey")
	end


	if ui.get(luaenable) and not ui.get(fsenable) then
	if ui.get(menu.misc.dt) == "Always" then
		arg.force_defensive = -1
	else
		arg.force_defensive = arg.weaponselect ~= 0 or arg.quick_stop
	end
	arg.allow_send_packet = false
	local ent = entity.get_local_player()
	local enemy = client.current_threat()
	local count = globals.tickcount()
	if tick ~= count then
		tick = count
		if arg.command_number % 2 == 0 then
			switch = not switch
		end
	end
	local angle = ({client.camera_angles()})[2]
	local junk = 0
	if ui.get(menu.hotkeys.left) and last_manual+11 < count then
		last_manual = count
		if manual == -90 then
			manual = 0
		else
			manual = -90
		end
	end
	if ui.get(menu.hotkeys.right) and last_manual+11 < count then
		last_manual = count
		if manual == 90 then
			manual = 0
		else
			manual = 90
		end
	end
	if ui.get(menu.hotkeys.back) and last_manual+11 < count then
		last_manual = count
		if manual == 0 then
			manual = 0
		else
			manual = 0
		end
	end
	if enemy ~= nil and manual == 0 then
		local eyepos = vector(client.eye_position())
		local origin = vector(entity.get_origin(enemy))
		local target = origin + vector(0, 0, 40)
		junk, angle = eyepos:to(target):angles()
	end
	angle = angle + 180
	local speed = velocity(ent)
	if desync(ent, arg, tick, speed) and movement(ent, arg, speed) then
		local state = state(ent, speed, arg.in_jump == 1)
		cache["state"] = state
		local leftadd = ui.get(menu["left"][state])
		local rightadd = ui.get(menu["right"][state])
		local yawadd = ui.get(menu["yaw"][state])
		local dynamic = not ui.get(menu["toggle"][state])
		if cache["bf"] and tablecontains(ui.get(menu.options[state]), "Anti-Brute") and not dynamic then
			if bf_tick_log+750 < count then
				cache["bf"] = false
				pushnotify("Capzi:  disabled Anti-brute yaw")
			end
			leftadd = ui.get(menu["bfleft"][state])
			rightadd = ui.get(menu["bfright"][state])
		end
		if dynamic then
			if tablecontains(ui.get(menu.dynamic), "New Enemy") and enemy ~= cache["enemy"] and enemy ~= nil and last_enemy+123 < count then
				last_enemy = count
				pushnotify("Capzi:  found a new enemy ", string.lower(entity.get_player_name(enemy)))
				cache["enemy"] = enemy
				automatic()
			end
			local dormant = #entity.get_players(true) == 0
			if tablecontains(ui.get(menu.dynamic), "Dormant") and cache["dormant"] == false and dormant and last_dormant+123 < count then
				last_dormant = count
				pushnotify("Capzi:  reset due to dormant detection")
				cache["dormant"] = true
				automatic()
			end
			if not dormant then
				cache["dormant"] = false
			end
			leftadd = cache["dynamic"]["left"]
			rightadd = cache["dynamic"]["right"]
			yawadd = cache["dynamic"]["center"]
		end
		if not tablecontains(ui.get(menu.options[state]), "Center") and not dynamic then
			yawadd = 0
		end
		if tablecontains(ui.get(menu.options[state]), "Jitter") and cache["jitter"] and not dynamic then
			local find_jitter = 0
			if rightadd > leftadd then
				find_jitter = rightadd*2
			else
				find_jitter = leftadd*2
			end
			if leftadd > 0 then
				find_jitter = leftadd
			end
			if rightadd > 0 then
				find_jitter = rightadd
			end
			yawadd = yawadd + find_jitter
		end
		if ui.get(menu.hotkeys.roll) then
			arg.roll = 45
			yawadd = -15
			leftadd = 30
			rightadd = 25
		end
		if manual ~= 0 then
			yawadd = -15+manual
			leftadd = 25
			rightadd = 30
			if ui.get(menu.hotkeys.roll) then
				arg.roll = -45
			end
		end
		local choke = arg.chokedcommands % 2 == 0
		if switch == false and cache_jitter == false then
			jitter_mode = choke
		end
		cache_jitter = switch
		switch_mode = switch
		if not jitter_mode then
			switch_mode = not switch
		end
		if switch_mode then
			arg.yaw = angle + rightadd + yawadd
		else
			arg.yaw = angle + leftadd + yawadd
		end
		if choke then
			if manual ~= 0 then
				arg.yaw = angle + 0
			else
				if ui.get(menu.hotkeys.roll) then
					arg.yaw = angle + -123
				else
					if tablecontains(ui.get(menu.options[state]), "Lower Body Yaw") and not dynamic then
						arg.yaw = angle + ui.get(menu.lby[state])
					else
						if tablecontains(ui.get(menu.options[state]), "Automatic Desync") and not dynamic then
							if tablecontains(ui.get(menu.options[state]), "Invert Automatic") and not dynamic then
								if switch_mode then
									arg.yaw = angle - rightadd*2
								else
									arg.yaw = angle + leftadd*2
								end
							else
								if switch_mode then
									arg.yaw = angle - rightadd*2
								else
									arg.yaw = angle + leftadd*2
								end
							end
						else
							if switch_mode then
								if switch then
									arg.yaw = angle - rightadd*2
								else
									arg.yaw = angle - leftadd*2
								end
							else
								arg.yaw = angle + yawadd
							end
						end
					end
				end
			end
		else
			if arg.command_number % 3 == 1 then
				cache["jitter"] = not cache["jitter"]
			end
		end
		if bit.band(entity.get_prop(ent, "m_fFlags"), bit.lshift(1, 0)) == 1 and speed < 45 then
			if not (arg.in_forward == 1 or arg.in_moveleft == 1 or arg.in_moveright == 1 or arg.in_back == 1 or arg.in_jump == 1) then
				if choke then
					invert = not invert
					arg.sidemove = invert and 1.1 or -1.1
				end
			end
		end
		--ui.set(dbg_slider, arg.yaw)
		arg.pitch = 89
	else end end end)