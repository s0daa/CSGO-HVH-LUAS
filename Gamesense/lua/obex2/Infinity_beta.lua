-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local uitbl = ui
local entitytbl = entity
local clienttbl = client
local globalstbl = globals
local plisttbl = plist
local tabletbl = table
local renderertbl = renderer
local mathtbl = math
local label = const9
local hotkey = const10
local multi = const11
local slider = const12
local button = const13
local visible = const14
local combo = const15
local checkbox = const16
local get = const17
local set = const18
local enemy = const19
local alive = const20
local player = const21
local getprop = const22
local setprop = const23
local getclassname = const24
local weapon = const25
local entindex = const26
local screensize = const27
local unixtime = const28
local exec = const29
local esp = const30
local callback = const31
local clantag = const32
local curtime = const33
local frametime = const34
local tickcount = const35
local realtime = const36
local insert = const37
local text = const38
local measuretext = const39
local line = const40
local circleoutline = const41
local random = const42

local getname = function()
    return ambaniusername == nil and "Admin" or ambaniusername
end
local getbuild = function()
    return ambaniversion == nil and "Debug" or ambaniversion
end
local images = require "gamesense/images"
local image = images.load(readfile("17xx.png"))
local base64={}local a=_G.bit32 and _G.bit32.extract;if _G.bit then local b,c,d=_G.bit.lshift,_G.bit.rshift,_G.bit.band;a=function(e,f,g)return d(c(e,f),b(1,g)-1)end end;local h=function(i,j,k)local l={}for m,n in pairs{[0]="A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9",i or"+",j or"/",k or"="}do l[m]=string.byte(n)end;return l end;local o=function(i,j,k)local p={}for m,q in pairs(h(i,j,k))do p[q]=m end;return p end;local r=h()local s=o()local n,t=string.char,table.concat;base64.encode=function(u,l,v)l=l or r;local w,x,y={},1,#u;local z=y%3;local A={}for B=1,y-z,3 do local C,D,E=string.byte(u,B,B+2)local e=C*0x10000+D*0x100+E;local F;if v then F=A[e]if not F then F=n(l[a(e,18,6)],l[a(e,12,6)],l[a(e,6,6)],l[a(e,0,6)])A[e]=F end else F=n(l[a(e,18,6)],l[a(e,12,6)],l[a(e,6,6)],l[a(e,0,6)])end;w[x]=F;x=x+1 end;if z==2 then local C,D=string.byte(u,y-1,y)local e=C*0x10000+D*0x100;w[x]=n(l[a(e,18,6)],l[a(e,12,6)],l[a(e,6,6)],l[64])elseif z==1 then local e=string.byte(u,y)*0x10000;w[x]=n(l[a(e,18,6)],l[a(e,12,6)],l[64],l[64])end;return t(w)end;base64.decode=function(G,p,v)p=p or s;local H="[^%w%+%/%=]"if p then local i,j;for q,m in pairs(p)do if m==62 then i=q elseif m==63 then j=q end end;H=("[^%%w%%%s%%%s%%=]"):format(n(i),n(j))end;G=string.gsub(G,H,"")local A=v and{}local w,x={},1;local y=#G;local I=string.sub(G,-2)=="=="and 2 or string.sub(G,-1)=="="and 1 or 0;for B=1,I>0 and y-4 or y,4 do local C,D,E,J=string.byte(G,B,B+3)local F;if v then local K=C*0x1000000+D*0x10000+E*0x100+J;F=A[K]if not F then local e=p[C]*0x40000+p[D]*0x1000+p[E]*0x40+p[J]F=n(a(e,16,8),a(e,8,8),a(e,0,8))A[K]=F end else local e=p[C]*0x40000+p[D]*0x1000+p[E]*0x40+p[J]F=n(a(e,16,8),a(e,8,8),a(e,0,8))end;w[x]=F;x=x+1 end;if I==1 then local C,D,E=string.byte(G,y-3,y-1)local e=p[C]*0x40000+p[D]*0x1000+p[E]*0x40;w[x]=n(a(e,16,8),a(e,8,8))elseif I==2 then local C,D=string.byte(G,y-3,y-2)local e=p[C]*0x40000+p[D]*0x1000;w[x]=string.char(a(e,16,8))end;return t(w)end
local decrypt = function(x, key)
    if key == nil then
        key = 11
    end
    local ran_check = false
    local junkcheck, returnget = pcall(function()
        ran_check = true
        x = base64.decode(x)
        local output = ""
        local t = {}
        for str in string.gmatch(x, "([^\\]+)") do
            t[#t+1] = str
        end
        local fix = #t + key
        for i = 1, #t do
            fix = fix + 1 + key
            output = output .. string.char(t[i]-fix)
        end
        return output
    end)
    if junkcheck and ran_check then
        return returnget
    else
        return ""
    end
end
local errorcheck = function()
    ui.reference("Visuals", "Other ESP", "Helper")
    return ui.reference("Visuals", "Other ESP", "Helper")
end
local function encrypt(x, key)
    if key == nil then
        key = 11
    end
    local output = ""
    local algorithm = #x + key
    for i = 1, #x do
        local z = string.sub(x, i,i)
        algorithm = algorithm + 1 + key
        output = output .. "\\" .. (string.byte(z) + algorithm)
    end
    return base64.encode(output)
end
local ffistring = function(...)
    local ffi = require("ffi")
    return ffi.string(...)
end
local tbl = {
    ref = {
        refui = function(a,b,c)
            return { ui.reference(a,b,c) }
        end,
        newlabel = ui.new_label,
        newcombo = ui.new_combobox,
        newkey = ui.new_hotkey,
        newlist = ui.new_multiselect,
        newslider = ui.new_slider,
        newbutton = ui.new_button,
        visibleui = ui.set_visible,
        checkbox = ui.new_checkbox,
        getui = ui.get,
        setui = ui.set,
        useridtoent = client.userid_to_entindex,
        isenemy = entity.is_enemy,
        curtime = globals.curtime,
        screensize = client.screen_size,
        entityalive = entity.is_alive,
        getplayers = entity.get_players,
        frametime = globals.frametime,
        colorpicker = ui.new_color_picker,
        textrender = renderer.text,
        tickcount = globals.tickcount,
        random = math.random,
        plistset = plist.set,
        plistget = plist.get,
        openui = ui.is_menu_open,
        getprop = entity.get_prop,
        setprop = entity.set_prop,
        getlocal = entity.get_local_player,
        unix = client.unix_time,
        clientexec = client.exec,
        registerflag = client.register_esp_flag,
        measuretext = renderer.measure_text,
        clientcallback = client.set_event_callback,
        realtime = globals.realtime,
        setclantag = client.set_clan_tag,
        getclassname = entity.get_classname,
        playerweapon = entity.get_player_weapon,
        line = renderer.line,
        circle = renderer.circle_outline,
        curtime = globals.curtime,
        tableinsert = table.insert
    },
    lib = {
        ffi = require("ffi"),
        vector = require("vector"),
        entity = require("gamesense/entity"),
        csgo_weapons = require("gamesense/csgo_weapons")
    },
    var = {
        manual = {
            angle = 0,
            last_press = 0,
        },
        rgb = {
            invert = false,
            switch = 0,
            r = 25,
            g = 25,
            b = 25
        },
        states = {
            "Global",
            "Air",
            "Air duck",
            "Stand",
            "Slow",
            "Move",
            "Duck",
            "Duck move",
            "Fake duck"
        },
        text = {
            rgb = {
                invert = false,
                switch = 0,
            },
            blue = 255,
            red = 55,
            green = 155,
            draw = 0,
            title = 0
        },
        cache = {
            nade = 0,
            counter = 0,
            counter2 = 0,
            counter3 = 5,
            counter4 = 0,
            defensive = 0,
            checker = 0,
            smooth = 0,
            ladder = false,
            prevtarget = 0,
            jitter = 0,
            prevstate = "",
            data = {},
            switch = false,
            switch2 = false,
            limit = 0
        },
        jitterstorage = {
            jitter = {},
            yaw_delta = {},
            old_yaw_delta = {},
            side = {},
            bruteangles = {},
            brutemisses = {},
            weightstate = {}
        },
        abstorage = {
            bruted_last_time = 0,
            stage = {},
            should_swap = {},
            time = {},
            misses = {},
            jitter = 0,
            jitteramount = 0,
            hurt = false,
            jitteralgo = 0,
            limitalgo = 0
        },
        indicators = {
            active_fraction = 0,
            inactive_fraction = 0, --tbl.var.indicators
            hide_fraction = 0,
            scoped_fraction = 0,
            fraction = 0,
            fb_fraction = 0,
            lerped4 = 0,
            lerped5 = 0,
            state = "stand",
            state_fraction = 0,
        },
        killtable = {
            killquotes = { 
            "ɢᴏᴏᴅ ʟᴜᴄᴋ ʏᴏᴜ ᴊᴜꜱᴛ ɢᴏᴛ ꜰᴜᴄᴋᴇᴅ ɪɴ ᴛʜᴇ ᴀꜱꜱ",
            "(っ◔◡◔)っ ♥ i just had ambani thats why you lost. :hearts:",
            "Go rub your cock against a cheese grater you titcrapping twigfucker.",
            "Which one of your 2 dads taught you how to play HVH?",
            "Imagine your potential if you didn't have parkinsons",
            "we are going to execute ever single CIA heavenly saint.",
            "Die CIA niggers!",
            "If a person commits extortion, they go to hell. If you confess God blesses you. They go to hell",
            "Pope is an atheist. He should resign when God talks.",
            "Raging Bull? Yer no fun. It was a CIA heavenly saint, though. I killed a CIA heavenly saint.",
            "It's legal to run over a CIA heavenly saint as long as they are space aliens. Ba ha. I have a feather in my cap.",
            "𝙽𝙸𝙲𝙴 𝙰𝙽𝚃𝙸𝙰𝙸𝙼, 𝙸𝚂 𝚃𝙷𝙰𝚃 𝚇𝙾-𝙿𝙰𝚂𝚃𝙴",
            "Is this casual? I have 16k..",
            "PIE-EATING BUTT PIRATE",
            "C0MMUN1ST C0CK CANOE",
            "JACKALOPE B0N3R TOOLBAG",
            "Fuck you asshole until the caramels come out your ass",
            "DUCKN0SE NUT BISCUIT",
            "UGLY SPHINCTER HAMMER",
            "I thought I put bots on hard, why are they on easy?",
            "Встань на колени, ты, чертова собака",
            "Тебя уничтожил кентавр. сексуальная ты ебаная шлюха",
            "Это xo-yaw или почему ты сразу умер?",
            "ешки матрешки вот это вантапчик",
            'каадык мне в зад вот это я тебе ебло снес красиво',
            'oh my god валера, ты сириусли надеялся меня убить? АХАХ',
            '-> заползла обратно моча <- тебе в будку',
            'сейчас в попу, потом в ротик',
            'лям сюда лям туда, бэктрекед ту africa моча',
            'где мозги потерял шаболда',
            'бегите сука, папочка идет...',
            'братец тут уже нихуя не поможет',
            'передавило ослинской',
            'залил очко спермой',
            'где мозги потерял шаболда',
            'анально наказан',
            'где носопырку потерял',
            'орять шляпа слетела, анти-попадайки не помогли',
            'бектрекед to africa дегенерат)',
            }
        }
    }
}
local round = function(value, multiplier) local multiplier = 10 ^ (multiplier or 0); return math.floor(value * multiplier + 0.5) / multiplier end
local logs = {}
ambani_insert_log = function(text, text2, text3, text4, text5, time)
    table.insert(logs, {
        ["text"] = text, 
        ["text2"] = text2 or "", 
        ["text3"] = text3 or "", 
        ["text4"] = text4 or "", 
        ["text5"] = text5 or "", 
        ["time"] = time or 6,
        ["anim_time"] = globals.curtime(),
        ["anim_mod"] = 0,
        ["w"] = 0,
        ["str_a"] = 0,
        ["color"] = 0,
        ["color2"] = 0,
        ["color3"] = 0,
        ["color4"] = 0,
        ["width"] = 0,
        ["circle"] = 0,
        ["timer"] = 0,
        ["height"] = 0,
        ["height2"] = 0,
    })
end
local rgba_to_hex = function( r, g, b, a )
    return string.format('%02x%02x%02x%02x', r, g, b, a )
end
ambani_insert_log("   Successfully loaded - user: $"..getname().."$".. " - build: $"..getbuild().."$  " ,6)

math_clamp = function(val, min, max)
    return math.min(max, math.max(min, val))
end

return (function(script)
    script.func = {
        hex = function(arg)
            local result = "\a"
            for key, value in next, arg do
                local output = ""
                while value > 0 do
                    local index = math.fmod(value, 16) + 1
                    value = script.math.floor(value / 16)
                    output = string.sub("0123456789ABCDEF", index, index) .. output 
                end
                if script.math.len(output) == 0 then 
                    output = "00" 
                elseif script.math.len(output) == 1 then 
                    output = "0" .. output 
                end 
                result = result .. output
            end 
            return result .. "FF"
        end,
        animate_text = function(self, time, string, r, g, b, a)
			local t_out, t_out_iter = { }, 1

			local l = string:len( ) - 1
	
			local r_add = (255 - r)
			local g_add = (255 - g)
			local b_add = (255 - b)
			local a_add = (155 - a)
	
			for i = 1, #string do
				local iter = (i - 1)/(#string - 1) + time
				t_out[t_out_iter] = "\a" .. rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )
	
				t_out[t_out_iter + 1] = string:sub( i, i )
	
				t_out_iter = t_out_iter + 2
			end
	
			return t_out
		end,
        rgba_to_hex = function(self, r, g, b, a)
            return bit.tohex(
              (math.floor(r + 0.5) * 16777216) + 
              (math.floor(g + 0.5) * 65536) + 
              (math.floor(b + 0.5) * 256) + 
              (math.floor(a + 0.5))
            )
        end,
        invertrgb = function()
            script.var.rgb.invert = not script.var.rgb.invert
        end,
        textinvertrgb = function()
            script.var.text.rgb.invert = not script.var.text.rgb.invert
        end,
        gradienttext = function(text_to_draw, speed, color1, color2)
            local base_r, base_g, base_b,base_a = unpack(color1)
            local r, g, b, a = unpack(color2)
            local highlight_fraction =  (globals.realtime() / 2 % 1.2 * speed) - 1.2
            local output = ""
            for idx = 1, #text_to_draw do
                local character = text_to_draw:sub(idx, idx)
                local character_fraction = idx / #text_to_draw
        
                local r, g, b, a = base_r, base_g, base_b, base_a
                local highlight_delta = (character_fraction - highlight_fraction)
                if highlight_delta >= 0 and highlight_delta <= 1.4 then
                    if highlight_delta > 0.7 then
                        highlight_delta = 1.4 - highlight_delta
                    end
                    local r_fraction, g_fraction, b_fraction, a_fraction = r2 - r, g2 - g, b2 - b
                    r = r + r_fraction * highlight_delta / 0.8
                    g = g + g_fraction * highlight_delta / 0.8
                    b = b + b_fraction * highlight_delta / 0.8
                end
                output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, a2, text_to_draw:sub(idx, idx))
            end
            return output
        end,
        getstate = function(arg, air, slow, duck, velocity, team, height, fd)
            local result = ""
            if fd and script.ref.getui(arg["builder"]["Fake duck ".. team]["toggle"]) == "Enabled" then
                result = "Fake duck ".. team
            elseif air and not slow and not duck and script.ref.getui(arg["builder"]["Air ".. team]["toggle"]) == "Enabled" then
                result = "Air ".. team
            elseif air and not slow and duck and script.ref.getui(arg["builder"]["Air duck ".. team]["toggle"]) == "Enabled" then
                result = "Air duck ".. team
            elseif slow and not air and not duck and not script.ref.getui(script.menu.ref.rage.other.fd[1]) and script.ref.getui(arg["builder"]["Slow ".. team]["toggle"]) == "Enabled" then
                result = "Slow ".. team
            elseif (duck and not air and velocity < 1.2 or script.ref.getui(script.menu.ref.rage.other.fd[1])) and script.ref.getui(arg["builder"]["Duck ".. team]["toggle"]) == "Enabled" then
                result = "Duck ".. team
            elseif velocity < 1.2 and not air and not script.ref.getui(script.menu.ref.rage.other.fd[1]) and script.ref.getui(arg["builder"]["Stand ".. team]["toggle"]) == "Enabled" then
                result = "Stand ".. team
            elseif velocity > 1.2 and not air and not duck and not slow and script.ref.getui(arg["builder"]["Move ".. team]["toggle"]) == "Enabled" then
                result = "Move ".. team
            elseif velocity > 1.2 and not air and duck and not slow and script.ref.getui(arg["builder"]["Duck move ".. team]["toggle"]) == "Enabled" then
                result = "Duck move ".. team
            else
                result = "Global ".. team
            end
            return result
        end,
        timeget = function(func)
            local unixtime = script.ref.unix()
            local hours, minutes, seconds = func(unixtime / 3600 % 24), func(unixtime / 60 % 60), func(unixtime % 60)
            return script.func.hex({155,155,155}) .. hours .. script.func.hex({255,255,255}) .. " hours " .. script.func.hex({155,155,155}) .. minutes .. script.func.hex({255,255,255}) .. " minutes " .. script.func.hex({155,155,155}) .. seconds .. script.func.hex({255,255,255}) .. " seconds"
        end,
        importcfg = function(value, item)
            local errorcheck, returnget = pcall(function()
                script.ref.setui(item, value)
            end)
        end,
        clipboard = {
            ffi = script.lib.ffi.cdef([[
                typedef int(__thiscall* get_clipboard_text_count)(void*);
                typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
                typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
            ]]),
            export = function(arg)
                local pointer = script.lib.ffi.cast(script.lib.ffi.typeof('void***'), client.create_interface('vgui2.dll', 'VGUI_System010'))
                local func = script.lib.ffi.cast('set_clipboard_text', pointer[0][9])
                func(pointer, arg, #arg)
            end,
            import = function()
                local pointer = script.lib.ffi.cast(script.lib.ffi.typeof('void***'), client.create_interface('vgui2.dll', 'VGUI_System010'))
                local func = script.lib.ffi.cast('get_clipboard_text_count', pointer[0][7])
                local sizelen = func(pointer)
                local output = ""
                if sizelen > 0 then
                    local buffer = script.lib.ffi.new("char[?]", sizelen)
                    local sizefix = sizelen * script.lib.ffi.sizeof("char[?]", sizelen)
                    local extrafunc = script.lib.ffi.cast('get_clipboard_text', pointer[0][11])
                    extrafunc(pointer, 0, buffer, sizefix)
                    output = ffistring(buffer, sizelen-1)
                end
                return output
            end
        }
    }
    script.math = {
        len = function(arg)
            return #arg
        end,
        vector3_distance = function(x1, y1, z1, x2, y2, z2)
            return math.sqrt((x1 - x2)^2 + (y1 - y2)^2 + (z1 - z2)^2)
        end,
        closest_point_on_ray = function(tx, ty, tz, startx, starty, startz, endx, endy, endz)
            local tox, toy, toz = tx - startx, ty - starty, tz - startz
            local dirx, diry, dirz = endx - startx, endy - starty, endz - startz
            local length = math.sqrt(dirx^2 + diry^2 + dirz^2)
            dirx, diry, dirz = dirx / length, diry / length, dirz / length
            local range_along = dirx * tox + diry * toy + dirz * toz
            if range_along < 0 then
                return startx, starty, startz
            end
            if range_along > length then
                return endx, endy, endz
            end	
            return startx + dirx * range_along, starty + diry * range_along, startz + dirz * range_along
        end,
        utility_lerp = function(a, b, t)
            return a + (b - a) * t
        end,
        floor = function(arg)
            local result = 1
            result = arg - ( arg % 1)
            return result
        end,
		split = function(inputstr, sep)
			if sep == nil then
				sep = "%s"
			end
			local t = {}
			for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
				table.insert(t, str)
			end
			return t
		end,
        color_text = function(string, r, g, b, a)
			local accent = "\a" .. rgba_to_hex(r, g, b, a)
			local white = "\a" .. rgba_to_hex(255, 255, 255, a)
			local str = ""
			for i, s in ipairs(script.math.split(string, "$")) do
				str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
			end
			return str
		end,
        contains = function(tbl, arg)
            for index, value in next, tbl do 
                if value == arg then 
                    return true end 
                end 
            return false
        end,
        easeInOut = function(self, t)
			return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
		end,
        rec = function(x, y, w, h, radius, color)
			radius = math.min(x/2, y/2, radius)
			local r, g, b, a = unpack(color)
			renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
			renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
			renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
			renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
			renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
			renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
			renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
		end,
        rec_outline = function(x, y, w, h, radius, thickness, color)
			radius = math.min(w/2, h/2, radius)
			local r, g, b, a = unpack(color)
			if radius == 1 then
				renderer.rectangle(x, y, w, thickness, r, g, b, a)
				renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
			else
				renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
				renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
				renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
				renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
				renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
				renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
				renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
				renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
			end
		end,
        render_rectangle = function(x, y, w, h, r, g, b, a, roundness)
            local adder = 0
            local radius = 4
            local glow = 15
            if a == 0 then return end
            renderer.rectangle(x + roundness + adder, y + roundness + adder, w - roundness * 2 - adder * 2, h - roundness * 2 - adder * 2, r, g, b, a) --background
            renderer.circle(x + w - roundness - adder, y + roundness + adder, r, g, b, a, roundness, 90, 0.25) -- right top corner
            renderer.circle(x + w - roundness - adder, y + h - roundness - adder, r, g, b, a, roundness, 360, 0.25) --right bottom corner
            renderer.circle(x + roundness + adder, y + h - roundness - adder, r, g, b, a, roundness, 270, 0.25) -- left bottom corner
            renderer.circle(x + roundness + adder, y + roundness + adder, r, g, b, a, roundness, 180, 0.25) -- left top corner
            renderer.rectangle(x + roundness + adder, y + adder, w - roundness * 2 - adder * 2, roundness, r, g, b, a)
            renderer.rectangle(x + w - roundness - adder, y + roundness + adder, roundness, h - roundness * 2 - adder * 2, r, g, b, a)
            renderer.rectangle(x + roundness + adder, y + h - roundness - adder, w - roundness * 2 - adder * 2, roundness, r, g, b, a)
            renderer.rectangle(x + adder, y + roundness + adder, roundness, h - roundness * 2 - adder * 2, r, g, b, a)
        end,
        glow_module = function(x, y, w, h, width, rounding, accent, accent_inner)
			local thickness = 1
			local offset = 1
			local r, g, b, a = unpack(accent)
			if accent_inner then
				script.math.rec(x, y, w, h + 1, 50, accent_inner)
			end
			for k = 0, width do
				if a * (k/width)^(1) > 5 then
					local accent = {r, g, b, a * (k/width)^(2)}
					script.math.rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
				end
			end
		end,
        time_to_ticks = function(t)
            return math.floor(0.5 + (t / globals.tickinterval()))
        end,
        duck = function(arg)
            return script.ref.getprop(arg, "m_flDuckAmount") > 0.1
        end,
        velocity = function(arg)
            local x, y, z = script.ref.getprop(arg, "m_vecVelocity")
            return math.sqrt(x*x + y*y + z*z)
        end,
        normalize = function(arg)
            while arg > 180 do 
                arg = arg - 360 
            end
            while arg < -180 do 
                arg = arg + 360 
            end
            return arg
        end,
        getfraction = function(delta, frac, rgb)
            local list = {}
            for index, value in next, frac do
                list[index] = rgb[index] + frac[index] * delta / 0.8
            end
            return list
        end,
        getdt = function(arg)
            if not script.ref.getui(script.menu.ref.rage.other.dt[1]) or not script.ref.getui(script.menu.ref.rage.other.dt[2]) or script.ref.getui(script.menu.ref.rage.other.fd[1]) then 
                return false 
            end
            if arg == nil or not script.ref.entityalive(arg) then
                 return false
            end
            local weapon = script.ref.getprop(arg, "m_hActiveWeapon")
            if weapon == nil then 
                return false 
            end
            local nextattack = script.ref.getprop(arg, "m_flNextAttack") + 0.25
            local nextprimaryattack = script.ref.getprop(weapon, "m_flNextPrimaryAttack") + 0.5
            if nextattack == nil or nextprimaryattack == nil then 
                return false 
            end
            return nextattack - script.ref.curtime() < 0 and nextprimaryattack - script.ref.curtime() < 0 
        end,
        getside = function(arg)
            local desyncbodyyaw = script.ref.getprop(arg, "m_flPoseParameter", 11) * 120 - 60
            return desyncbodyyaw > 0 and 1 or -1
        end,
        exportcfg = function(arg, func)
            local errorcheck, returnget = pcall(function()
                local result = arg(func)
                return type(result) ~= "string" and result or ""
            end)
            return errorcheck and returnget or ""
        end,
        importcfg = function(arg)
            local errorcheck, returnget = pcall(function() 
                return decrypt(arg)
            end)
            return errorcheck and returnget or ""
        end
    }
    script.colors = {
        prefix = script.func.hex({208, 184, 255}) .. "A" .. script.func.hex({255,255,255}) .. " - " .. script.func.hex({155,155,155}),
        color = script.func.hex({155,155,155}),
        get = function(arg)
            return script.func.hex({208, 184, 255}) .. "A" .. script.func.hex({255,255,255}) .. "  [ " .. script.func.hex({155,155,155}) .. arg .. script.func.hex({255,255,255}) .. " ]  " .. script.func.hex({155,155,155})
        end
    }
    script.math_value = {
        pixel = "-c",
        normal = "c",
        bold = "bc"
    }
    script.menu = {
        items = {
            top = script.ref.newlabel("aa", "anti-aimbot angles", "\t"),
            suffix = script.ref.newlabel("aa", "anti-aimbot angles", script.func.hex({55,155,255}) .. "A" .. script.colors.color .. "MBANI"),
            blank = script.ref.newlabel("aa", "anti-aimbot angles", "\t"),
            menu = script.ref.newcombo("aa", "anti-aimbot angles", script.colors.prefix .. "Selector", "Welcome", "AntiAim", "Visuals", "Misc", "Config"),
            Welcome = {
                spacercenter = script.ref.newlabel("aa", "anti-aimbot angles", "\t"),
                welcome = script.ref.newlabel("aa", "anti-aimbot angles", script.colors.color .. "Welcome, " .. script.func.hex({255,255,255}) .. getname() .. script.colors.color .. " to the script!"),
                button = script.ref.newlabel("aa", "anti-aimbot angles", script.colors.color .. "Click the " .. script.func.hex({255,255,255}) .. "button" .. script.colors.color .. " below to join our " .. script.func.hex({255,255,255}) .. "discord" .. script.colors.color .. "..."),
                discord = script.ref.newbutton("aa", "anti-aimbot angles", "discord.gg" , function()
                    panorama.loadstring("SteamOverlayAPI.OpenExternalBrowserURL('https://discord.gg/ambani');")()
                end),
                spacerbottom = script.ref.newlabel("aa", "anti-aimbot angles", "\t"),
            },
            AntiAim = {
                settings = script.ref.newlist("aa", "anti-aimbot angles", script.colors.prefix .. "Keybinds", {"Edge", "Freestand", "Manual"}),
                left = script.ref.newkey("aa", "anti-aimbot angles", script.colors.prefix .. "Left"),
                right = script.ref.newkey("aa", "anti-aimbot angles", script.colors.prefix .. "Right"),
                forward = script.ref.newkey("aa", "anti-aimbot angles", script.colors.prefix .. "Forward"),
                edge = script.ref.newkey("aa", "anti-aimbot angles", script.colors.prefix .. "Edge"),
                fs = script.ref.newkey("aa", "anti-aimbot angles", script.colors.prefix .. "Freestand"),
                addons = script.ref.newlist("aa", "anti-aimbot angles", script.colors.prefix .. "Addons", {"Legit aa","Airtick switcher" ,"Static knife in air", "Extrapolate Omnia", "Antibrute"}),
                label = script.ref.newlabel("aa", "anti-aimbot angles", script.colors.prefix .. "State: nil"),
                state = script.ref.newcombo("aa", "anti-aimbot angles", "\nState: nil", script.var.states),
                team = script.ref.newcombo("aa", "anti-aimbot angles", "\nState: nil", {"CT", "T"}),
                builder = {}
            },
            Visuals = {
                indicators = script.ref.newlist("aa", "anti-aimbot angles", script.colors.prefix .. "Indicators", {"Arrows", "Notifications", "Defensive"}),
                indicator_style = script.ref.newcombo("aa", "anti-aimbot angles", script.colors.prefix .."Crosshair style", {"-", "modern", "new"}),
                indicator_options = script.ref.newcombo("aa", "anti-aimbot angles", script.colors.prefix .."Crosshair font", {"pixel", "normal", "bold"}),
                overall_color = script.ref.colorpicker("aa", "anti-aimbot angles", "\n", 255, 255, 255, 255),
                notifylabel = script.ref.newlabel("aa", "anti-aimbot angles", script.colors.prefix .. "Notification Color"),
                notifypicker = script.ref.colorpicker("aa", "anti-aimbot angles", script.colors.prefix .. "Notify", 172, 147, 210, 255),
                glow = script.ref.checkbox("aa", "anti-aimbot angles", script.colors.prefix .. "Enable glow"),
            },
            Misc = {
                anims = script.ref.newlist("aa", "anti-aimbot angles", script.colors.prefix .. "Animations", {"Leg Fucker", "Static Legs"}),
                killsay = script.ref.checkbox("aa", "anti-aimbot angles", script.colors.prefix .. "Killsay"),
                clantag = script.ref.checkbox("aa", "anti-aimbot angles", script.colors.prefix .. "Clantag"),
            },
            Config = {
                export = script.ref.newbutton("aa", "anti-aimbot angles", "Export" , function()
                    local settings = {}
                    for key, value in next, script.menu.items.AntiAim.builder do
                        if value then
                            settings[key] = {}
                            if type(value) == "table" then
                                for k, v in pairs(value) do
                                    settings[key][k] = {}
                                    if type(v) == "table" then
                                        for kk, vv in next, v do
                                            if kk ~= "button" then
                                                settings[key][k][kk] = ui.get(vv)
                                            end
                                        end
                                    else
                                        settings[key][k] = ui.get(v)
                                    end
                                end
                            end
                        end
                    end
                    script.func.clipboard.export(encrypt(json.stringify(settings)))
                end),
                import = script.ref.newbutton("aa", "anti-aimbot angles", "Import" , function()
                    local cfg = script.math.importcfg(script.func.clipboard.import())
                    if script.math.len(cfg) > 1 then
                        local errorcheck, returnget = pcall(function()
                            return json.parse(cfg)
                        end)
                        if errorcheck then
                            for i, v in next, json.parse(cfg) do
                                if type(v) == "table" then
                                    for ii, vv in next, v do
                                        if ii ~= "button" then
                                            if type(vv) == "table" then
                                                for iii, vvv in next, vv do
                                                    ui.set(script.menu.items.AntiAim["builder"][i][ii][iii], vvv)
                                                end
                                            else
                                                ui.set(script.menu.items.AntiAim["builder"][i][ii], vv)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            }
        },
        ref = {
            aa = {
                AntiAimbot = {
                    toggle = script.ref.refui("aa", "anti-aimbot angles", "enabled"),
                    yaw = script.ref.refui("aa", "anti-aimbot angles", "yaw"),
                    pitch = script.ref.refui("aa", "anti-aimbot angles", "pitch"),
                    base = script.ref.refui("aa", "anti-aimbot angles", "yaw base"),
                    jitter = script.ref.refui("aa", "anti-aimbot angles", "yaw jitter"),
                    body = script.ref.refui("aa", "anti-aimbot angles", "body yaw"),
                    fsbody = script.ref.refui("aa", "anti-aimbot angles", "freestanding body yaw"),
                    fsyaw = script.ref.refui("aa", "anti-aimbot angles", "freestanding"),
                    edge = script.ref.refui("aa", "anti-aimbot angles", "edge yaw"),
                    roll = script.ref.refui("aa", "anti-aimbot angles", "roll")
                },
                fakelag = {
                    amount = script.ref.refui("aa", "fake lag", "amount"), 
                    limit = script.ref.refui("aa", "fake lag", "limit"),
                    variance = script.ref.refui("aa", "fake lag", "variance")
                },
                other = {
                    slow = script.ref.refui("aa", "other", "slow motion"),
                    hs = script.ref.refui("aa", "other", "on shot anti-aim") --script.menu.ref.aa.AntiAimbot.fsyaw
                }
            },
            rage = {
                aimbot = {
                    sp = script.ref.refui("rage", "aimbot", "force safe point"),
                    dmg = script.ref.refui("rage", "aimbot", "minimum damage"),
                },
                other = {
                    dt = script.ref.refui("rage", "aimbot", "double tap"), --script.menu.ref.rage.other.dt
                    fb = script.ref.refui("rage", "aimbot", "force body aim"), --- ref here
                    fd = script.ref.refui("rage", "other", "duck peek assist"),
                }
            },
            misc = {
                ping = script.ref.refui("misc", "miscellaneous", "ping spike")
            },
        }
    }
    movecfg = function(arg)
        local x = string.find(ui.name(arg), "CT") and "CT" or "T"
        local xxx = string.find(ui.name(arg), "CT") and "T" or "CT"
        local tbl = script.menu.items.AntiAim["builder"][script.ref.getui(script.menu.items["AntiAim"]["state"]) .. " " .. xxx]
        for i, v in next, script.menu.items.AntiAim["builder"][script.ref.getui(script.menu.items["AntiAim"]["state"]) .. " " .. x] do
            if type(v) == "table" then
                for ii, vv in next, v do
                    if ii ~= "button" then
                        ui.set(vv, ui.get(tbl[i][ii]))
                    end
                end
            end
        end
    end
    script.menu.items.cache = {}
    for i, v in next, script.var.states do
        script.menu.items.cache[#script.menu.items.cache+1] = v .. " CT"
        script.menu.items.cache[#script.menu.items.cache+1] = v .. " T"
    end
    for index, value in next, script.menu.items.cache do
        script.menu.items.AntiAim.builder[value] = {
            toggle = script.ref.newcombo("aa", "anti-aimbot angles", script.colors.get(value) .. "\nToggle", {"Enabled", "Disabled"}),
            Default = {
                jittermethod = script.ref.newcombo("aa", "anti-aimbot angles", script.colors.get(value) .. "Jitter option", "Normal", "Stomp", "Generation"),
                jitter = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Jitter", -180, 180, 0),
                limit = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Limit", 0, 60, 60),
                option = script.ref.newcombo("aa", "anti-aimbot angles", script.colors.get(value) .. "Options", "Off", "Left & Right", "Yaw manipulation", "3way", "Hold yaw", "Slow yaw"),
                yaw = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Yaw", -180, 180, 0),
                left = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Left", -100, 100, -50),
                right = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Right", -100, 100, 50),
                left3 = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Left\n2", -100, 100, -50),
                right3 = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Right\n2", -100, 100, 50),
                left4 = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Left\n3", -100, 100, -50),
                right4 = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Right\n3", -100, 100, 50),
                left2 = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Yaw left", -100, 100, -50),
                right2 = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Yaw right", -100, 100, 50),
                way5 = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Yaw 1", -100, 100, 0),
                way6 = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Yaw 2", -100, 100, 0),
                way7 = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Yaw 3", -100, 100, 0),
                speed = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "Speed", 1, 14, 6, 0),
                exploits = script.ref.newcombo("aa", "anti-aimbot angles", script.colors.get(value) .. "Exploits", "Off", "Pitch flick", "Synchronized Jitter"),
                pitch_norm = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "\aFFFFFFFFPitch return", -89, 89, 0),
                pitch_def = script.ref.newslider("aa", "anti-aimbot angles", script.colors.get(value) .. "\aFFFFFFFFPitch flick", -89, 89, 0),
                button = script.ref.newbutton("aa", "anti-aimbot angles", "Send to " .. (string.find(value, "CT") and "T" or "CT"), movecfg)
            }
        }
    end
    script.menu.items.bottom = script.ref.newlabel("aa", "anti-aimbot angles", "\t")
    script.builder = {
        Default = function(myself, event, menutbl, tbl)
        end,
        Automatic = function(myself, event, menutbl, tbl)
        end
    }
    script.handler = {
        menuitems = function()
            if script.ref.openui() then
                script.var.text.draw = script.var.text.draw + 1
                if script.var.text.draw > 123 then
                    script.var.text.draw = 0
                    script.var.text.title = script.var.text.title + 1
                    script.var.text.title = script.var.text.title % 35
                end
                if script.var.text.rgb.switch == 0 then
                    if not script.var.text.rgb.invert then
                        script.var.text.blue = script.var.text.blue + 15
                        script.var.text.green = script.var.text.green + 15
                        script.var.text.red = script.var.text.red + 15
                        if script.var.text.blue > 250 or script.var.text.green > 250 or script.var.text.red > 250 then
                            script.func.textinvertrgb()
                        end
                    else
                        script.var.text.blue = script.var.text.blue - 15
                        script.var.text.red = script.var.text.red - 15
                        script.var.text.green = script.var.text.green - 15
                        if script.var.text.blue < 5 or script.var.text.red < 5 or script.var.text.green < 5 then
                            script.func.textinvertrgb()
                        end
                    end
                end
                script.var.text.rgb.switch = script.var.text.rgb.switch + 1
                if script.var.text.rgb.switch > 55 then
                    script.var.text.rgb.switch = 0
                end
                local txt = ""
                local textcolor = script.func.hex({208, 184, 255})
                if script.var.text.title == 1 then
                    txt = script.colors.color .. "A" .. textcolor .. "M" .. script.colors.color .. "BANI"
                elseif script.var.text.title == 2 then
                    txt = script.colors.color .. "AM" .. textcolor .. "B" .. script.colors.color .. "ANI"
                elseif script.var.text.title == 3 then
                    txt = script.colors.color .. "AMB" .. textcolor .. "A" .. script.colors.color .. "NI"
                elseif script.var.text.title == 4 then
                    txt = script.colors.color .. "AMBA" .. textcolor .. "N" .. script.colors.color .. "I"
                elseif script.var.text.title == 5 then
                    txt = script.colors.color .. "AMBAN" .. textcolor .. "I"
                elseif script.var.text.title == 6 then
                    txt = script.colors.color .. "AMBAN" .. textcolor .. "I"
                elseif script.var.text.title == 7 then
                    txt = script.colors.color .. "AMBAN" .. textcolor .. "I"
                elseif script.var.text.title == 8 then
                    txt = script.colors.color .. "AMBA" .. textcolor .. "N" .. script.colors.color .. "I"
                elseif script.var.text.title == 9 then
                    txt = script.colors.color .. "AMB" .. textcolor .. "A" .. script.colors.color .. "NI"
                elseif script.var.text.title == 10 then
                    txt = script.colors.color .. "AM" .. textcolor .. "B" .. script.colors.color .. "ANI"
                elseif script.var.text.title == 11 then
                    txt = script.colors.color .. "A" .. textcolor .. "M" .. script.colors.color .. "BANI"
                else
                    txt = textcolor .. "A" .. script.colors.color .. "MBANI"
                end
                script.ref.setui(script.menu.items.suffix, txt)
                for index, value in next, script.menu.ref.aa.AntiAimbot do
                    for i, v in next, value do
                        script.ref.visibleui(v, false)
                    end
                end
                local selected = script.ref.getui(script.menu.items.menu)
                local toggled = true
                for index, value in next, script.menu.items do
                    toggled = true
                    if type(value) == "table" then
                        for i, v in next, value do
                            toggled = true
                            if type(v) == "table" then
                                for ii, vv in next, v do
                                    toggled = true
                                    if type(vv) == "table" then
                                        for iii, vvv in next, vv do
                                            if type(vvv) == "table" then
                                                for iiii, vvvv in next, vvv do
                                                    toggled = true
                                                    if selected == "AntiAim" then
                                                        if (iiii == "left" or iiii == "right") and iii == "Default" then
                                                            toggled = script.ref.getui(script.menu.items[selected][i][ii][iii]["option"]) == "Left & Right"
                                                        end
                                                        if (iiii == "left2" or iiii == "right2") then
                                                            toggled = script.ref.getui(script.menu.items[selected][i][ii][iii]["option"]) == "Yaw manipulation"
                                                        end
                                                        if(iiii == "left3" or iiii == "right3") then
                                                            toggled = script.ref.getui(script.menu.items[selected][i][ii][iii]["option"]) == "Hold yaw"
                                                        end
                                                        if(iiii == "left4" or iiii == "right4" or iiii == "speed") then
                                                            toggled = script.ref.getui(script.menu.items[selected][i][ii][iii]["option"]) == "Slow yaw"
                                                        end
                                                        if (iiii == "yaw") and iii == "Default" then
                                                            toggled = script.ref.getui(script.menu.items[selected][i][ii][iii]["option"]) == "Off"
                                                        end
                                                        if(iiii == "way5" or iiii == "way6" or iiii == "way7") then
                                                            toggled = script.ref.getui(script.menu.items[selected][i][ii][iii]["option"]) == "3way"
                                                        end
                                                        if (iiii == "jitter") then
                                                            toggled = script.ref.getui(script.menu.items[selected][i][ii][iii]["jittermethod"]) == "Normal" or script.ref.getui(script.menu.items[selected][i][ii][iii]["jittermethod"]) == "Stomp"
                                                        end
                                                        if (iiii == "pitch_norm" or iiii == "pitch_def") then
                                                            toggled = script.ref.getui(script.menu.items[selected][i][ii][iii]["exploits"]) == "Pitch flick"
                                                        end
                                                        toggled = script.ref.getui(script.menu.items[selected]["state"]) .. " " .. script.ref.getui(script.menu.items[selected]["team"]) == ii and toggled
                                                    end
                                                    script.ref.visibleui(vvvv, selected == index and toggled)
                                                end
                                            else
                                                if selected == "AntiAim" then
                                                    toggled = script.ref.getui(script.menu.items[selected]["state"]) .. " " .. script.ref.getui(script.menu.items[selected]["team"]) == ii
                                                    if iii == "toggle" and i == "Global" then
                                                        toggled = false
                                                        script.ref.setui(vvv, "Enabled")
                                                    end
                                                end
                                                script.ref.visibleui(vvv, selected == "AntiAim" and toggled)
                                            end
                                        end
                                    end
                                end
                            else
                                if selected == "Visuals" then
                                    if i == "notifylabel" or i == "notifypicker" or i == "glow" then
                                        toggled = script.math.contains(script.ref.getui(script.menu.items[selected]["indicators"]), "Notifications")
                                    end
                                end
                                if selected == "AntiAim" then
                                    if i == "left" or i == "right" or i == "forward" then
                                        toggled = script.math.contains(script.ref.getui(script.menu.items[selected]["settings"]), "Manual")
                                    end
                                    if i == "fs" then
                                        toggled = script.math.contains(script.ref.getui(script.menu.items[selected]["settings"]), "Freestand")
                                    end
                                    if i == "edge" then
                                        toggled = script.math.contains(script.ref.getui(script.menu.items[selected]["settings"]), "Edge")
                                    end
                                    if i == "label" then
                                        if script.var.rgb.switch == 0 then
                                            if not script.var.rgb.invert then
                                                script.var.rgb.r = script.var.rgb.r + 1
                                                script.var.rgb.g = script.var.rgb.g + 1
                                                script.var.rgb.b = script.var.rgb.b + 1
                                                if script.var.rgb.r > 155 or script.var.rgb.g > 155 or script.var.rgb.b > 155 then
                                                    script.func.invertrgb()
                                                end
                                            else
                                                script.var.rgb.r = script.var.rgb.r - 1
                                                script.var.rgb.g = script.var.rgb.g - 1
                                                script.var.rgb.b = script.var.rgb.b - 1
                                                if script.var.rgb.r < 55 or script.var.rgb.g < 55 or script.var.rgb.b < 55 then
                                                    script.func.invertrgb()
                                                end
                                            end
                                        end
                                        script.var.rgb.switch = script.var.rgb.switch + 1
                                        if script.var.rgb.switch > 5 then
                                            script.var.rgb.switch = 0
                                        end
                                        script.ref.setui(v, script.colors.prefix .. "State: " .. script.func.hex({script.var.rgb.r,script.var.rgb.g,script.var.rgb.b}) .. script.ref.getui(script.menu.items[selected]["state"]) .. " " .. script.ref.getui(script.menu.items[selected]["team"]))
                                    end
                                end
                                if type(v) ~= "string" then
                                    script.ref.visibleui(v, selected == index and toggled)
                                end
                            end
                        end
                    end
                end
            end
        end,
        tickbase = function()
            if not entity.is_alive(entity.get_local_player()) then
                return
            end
            local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
            script.var.cache.defensive = math.min(tickbase - script.var.cache.checker) * -1
            script.var.cache.checker = math.max(tickbase, script.var.cache.checker or 0)
        end,
        runmanual =  function()
            script.ref.setui(script.menu.items.AntiAim.left, "on hotkey")
            script.ref.setui(script.menu.items.AntiAim.right, "on hotkey")
            script.ref.setui(script.menu.items.AntiAim.forward, "on hotkey")
            if script.ref.getui(script.menu.items.AntiAim.right) and script.var.manual.last_press + 0.2 < script.ref.curtime() then
                script.var.manual.angle = script.var.manual.angle == 90 and 0 or 90
                script.var.manual.last_press = script.ref.curtime()
            elseif script.ref.getui(script.menu.items.AntiAim.left) and script.var.manual.last_press + 0.2 < script.ref.curtime() then
                script.var.manual.angle = script.var.manual.angle == -90 and 0 or -90
                script.var.manual.last_press = script.ref.curtime()
            elseif script.ref.getui(script.menu.items.AntiAim.forward) and script.var.manual.last_press + 0.2 < script.ref.curtime() then
                script.var.manual.angle = script.var.manual.angle == 180 and 0 or 180
                script.var.manual.last_press = script.ref.curtime()
            elseif script.var.manual.last_press > script.ref.curtime() then
                script.var.manual.last_press = script.ref.curtime()
            end
        end,
        run_fakelag = function(cmd)
            local dt = script.ref.getui(script.menu.ref.rage.other.dt[1]) and script.ref.getui(script.menu.ref.rage.other.dt[2])
            local os = script.ref.getui(script.menu.ref.aa.other.hs[1]) and script.ref.getui(script.menu.ref.aa.other.hs[1])
            local fd = script.ref.getui(script.menu.ref.rage.other.fd[1])
            local limit = 13
            if fd then
                limit = 13
            elseif dt then
                limit = 1
            elseif os then
                limit = 1
            end
            local send_packet = true
            if cmd.chokedcommands < limit then
                send_packet = false
            end
            local command_dif = cmd.command_number - cmd.chokedcommands - globals.lastoutgoingcommand()
            send_packet = send_packet or cmd.no_choke or not cmd.allow_send_packet or command_dif ~= 1
            cmd.allow_send_packet = send_packet
            return send_packet
        end,
        defensivestatus = function(e)
            local player = entity.get_local_player()
            if not entity.is_alive(player) then
                return
            end
            local simtime = entity.get_prop(player, "m_flSimulationTime")
            local sim_time = script.math.time_to_ticks(simtime)
            local origin = script.lib.vector(entity.get_prop(entity.get_local_player(), "m_vecOrigin"))
            local player_data = script.var.cache.data[player]
            if player_data == nil then
                script.var.cache.data[player] = {
                    last_sim_time = sim_time,
                    defensive_active_until = 0,
                    origin = origin
                }
            else
                local delta = sim_time - player_data.last_sim_time
                if delta < 0 then
                    player_data.defensive_active_until = globals.tickcount() + math.abs(delta)
                elseif delta > 0 then
                    player_data.breaking_lc = (player_data.origin - origin):length2dsqr() > 4096
                    player_data.origin = origin
                end
                player_data.last_sim_time = sim_time    
            end
            if player_data ~= nil then
                return player_data.last_sim_time - globals.tickcount()
            end
        end,
        can_desync = function(cmd)
            local me = entity.get_local_player()
            local weapon_ent = script.ref.playerweapon(me)
            if cmd.in_attack == 1 then
                local weapon = script.ref.getclassname(weapon_ent)
                if weapon:find("Grenade") then
                    script.var.cache.nade = globals.tickcount()
                else
                    if math.max(entity.get_prop(weapon_ent, "m_flNextPrimaryAttack"), entity.get_prop(me, "m_flNextAttack")) - globals.tickinterval() - globals.curtime() < 0 then
                        return false
                    end
                end
            end
            local throw = entity.get_prop(weapon_ent, "m_fThrowTime")
            if script.var.cache.nade + 15 == globals.tickcount() or (throw ~= nil and throw ~= 0) then 
                cmd.force_defensive = false
                return false
            end
            if cmd.in_use == 1 then
                return false
            end
            if entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1 then
                return false
            end
            if entity.get_prop(me, "m_MoveType") == 9 or script.var.cache.ladder == true then
                return false
            end
            if entity.get_prop(me, "m_MoveType") == 10 then
                return false
            end
            return true
        end,
        get_yaw = function(at_targets)
            local threat = client.current_threat()
            local _, yaw = client.camera_angles()
            if at_targets and threat then
                local pos =  script.lib.vector(entity.get_origin(entity.get_local_player()))
                local epos = script.lib.vector(entity.get_origin(threat))
                _, yaw = pos:to(epos):angles()
            end
            return yaw
        end,
        checkladders = function(e)
            local me = entity.get_local_player()
            if not entity.is_alive(me) then
                script.var.cache.ladder = false
                return
            end
            local ladder = entity.get_prop(me, "m_MoveType") == 9
            script.var.cache.ladder = ladder
            return
        end,
        desync = function(cmd, side, at_targets, yaw_add, jitter_add, limit, velocity, state, entity)
            local send_packet = script.handler.run_fakelag(cmd)
            jitter_add = switch and jitter_add/2 or -jitter_add/2
            local can_desync = script.handler.can_desync(cmd)
            local menutbl = script.menu.ref.aa.AntiAimbot
            if not can_desync then
                return
            end
            if send_packet then
                local yaw = script.handler.get_yaw(at_targets)
                cmd.yaw = yaw + 180 + yaw_add + jitter_add
                cmd.pitch = 89
                cmd.roll = 0
                if send_packet then
                    switch = not switch
                end
            else
                local yaw = script.handler.get_yaw(at_targets)
                if side == 2 then
                    yaw_add = yaw_add + (limit*2) * (switch and -1 or 1)
                elseif side == 3 then
                    yaw_add = yaw_add + (limit*2) * (globals.tickcount() % 4 < 2 and -1 or 1)
                else
                    yaw_add = yaw_add + (limit*2) * (side == 1 and -1 or 1)
                end
                cmd.yaw = yaw + 180 + yaw_add + jitter_add
                cmd.pitch = 90
                cmd.roll = 0
            end
            script.ref.setui(menutbl.body[1], "off")
            script.ref.setui(menutbl.yaw[2], 0)
            if ui.get(script.menu.items.AntiAim["builder"][state]["Default"].exploits) == "Pitch flick" and cmd.chokedcommands < 1 then
                cmd.force_defensive = true
                if script.var.cache.defensive >= 0 and script.var.cache.defensive < 3 then
                    cmd.pitch = ui.get(script.menu.items.AntiAim["builder"][state]["Default"].pitch_norm)
                else
                    cmd.pitch = ui.get(script.menu.items.AntiAim["builder"][state]["Default"].pitch_def)
                end
            else
                script.ref.setui(menutbl.pitch[1], "Minimal")
            end
            local helper = ({errorcheck()})[2]
            if tostring(ui.get(helper)) ~= "false" then
                return
            end
                script.var.indicators.state = state
            if script.math.contains(script.ref.getui(script.menu.items.AntiAim.addons), "Airtick switcher") and send_packet and string.find(state, "Air") then
                cmd.force_defensive = true
                cmd.allow_shift_tickbase = globals.tickcount() % math.random(6, 7.5) == 0 and false or true
            end

            if not (cmd.in_forward == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_back == 1 or cmd.in_jump == 1) and velocity < 1.2 then
                cmd.sidemove = switch and -1.01 or 1.01
            end
        end,
        antiaim = function(event)
            local myself = script.ref.getlocal()
            local team = script.ref.getprop(myself, "m_iTeamNum")
            local stateteam = "CT"
            if team == 2 then
                stateteam = "T"
            else
                stateteam = "CT"
            end
            local flags = entity.get_prop(myself, "m_fFlags")
            local state = script.func.getstate(script.menu.items.AntiAim, event.in_jump == 1 or bit.band(flags, 1) ~= 1, (script.ref.getui(script.menu.ref.aa.other.slow[1]) and script.ref.getui(script.menu.ref.aa.other.slow[2])), script.math.duck(myself), script.math.velocity(myself), stateteam, height, script.ref.getui(script.menu.ref.rage.other.fd[1]))
            local menutbl = script.menu.ref.aa.AntiAimbot
            script.ref.setui(menutbl.roll[1], 0)
            script.ref.setui(menutbl.edge[1], script.math.contains(script.ref.getui(script.menu.items.AntiAim.settings), "Edge") and script.ref.getui(script.menu.items.AntiAim.edge))
            script.builder["Default"](myself, event, menutbl, script.menu.items.AntiAim["builder"][state]["Default"])
            script.handler.runmanual()
            if script.var.manual.angle ~= 0 then
                script.ref.setui(menutbl.fsyaw[2], "On hotkey")
                script.ref.setui(menutbl.fsyaw[1], false)
            else
                script.ref.setui(menutbl.fsyaw[1], script.ref.getui(script.menu.items.AntiAim.fs))
                script.ref.setui(menutbl.fsyaw[2], script.ref.getui(script.menu.items.AntiAim.fs) and "Always on" or "On hotkey")
            end
            local tbl = script.menu.items.AntiAim["builder"][state]["Default"]
            local yaw = 0
            local sidemethod = 2
            if event.chokedcommands == 0 then
                script.var.cache.counter = script.var.cache.counter + 1
                script.var.cache.counter2 = script.var.cache.counter2 + 1
                script.var.cache.counter3 = script.var.cache.counter3 + 1
                script.var.cache.counter4 = script.var.cache.counter4 + 1
            end
            if script.var.cache.counter >= 5 then
                script.var.cache.counter = 0
            end
            if script.var.cache.counter2 >= 8 then
                script.var.cache.counter2 = 0
            end
            if script.var.cache.counter3 >= 8 then
                script.var.cache.counter3 = 5
            end
            if globals.tickcount() % ui.get(script.menu.items.AntiAim["builder"][state]["Default"].speed) == 1 then
                script.var.cache.switch = not script.var.cache.switch
            end
            if not script.ref.getui(script.menu.items.AntiAim.fs) and script.var.manual.angle == 0 then
                if script.ref.getui(tbl.option) == "Left & Right" then
                    local desyncbodyyaw = script.ref.getprop(myself, "m_flPoseParameter", 11) * 120 - 60
                    local side = desyncbodyyaw > 0 and 1 or -1
                    yaw = side == 1 and script.ref.getui(tbl.left) or script.ref.getui(tbl.right)
                    if script.math.contains(script.ref.getui(script.menu.items.AntiAim.addons), "Airtick switcher") and string.find(state, "Air") then
                        sidemethod = 3
                    else
                        sidemethod = 2
                    end
                elseif script.ref.getui(tbl.option) == "Yaw manipulation" then
                    yaw = globals.tickcount() % 3 == 0 and script.ref.getui(tbl.left2) or script.ref.getui(tbl.right2)
                    sidemethod = 0
                elseif script.ref.getui(tbl.option) == "3way" then
                    yaw = script.ref.getui(tbl["way"..tostring(script.var.cache.counter3)])
                    sidemethod = 2
                elseif script.ref.getui(tbl.option) == "Hold yaw" then
                    if script.var.cache.counter2 == 0 then
                        --right
                        yaw = script.ref.getui(tbl.right3)
                    elseif script.var.cache.counter2 == 1 then
                        --left
                        yaw = script.ref.getui(tbl.left3)
                    elseif script.var.cache.counter2 == 2 then
                        --left
                        yaw = script.ref.getui(tbl.left3)
                    elseif script.var.cache.counter2 == 3 then
                        --left
                        yaw = script.ref.getui(tbl.left3)
                    elseif script.var.cache.counter2 == 4 then
                        --right
                        yaw = script.ref.getui(tbl.right3)
                    elseif script.var.cache.counter2 == 5 then
                        --left
                        yaw = script.ref.getui(tbl.left3)
                    elseif script.var.cache.counter2 == 6 then
                        --right
                        yaw = script.ref.getui(tbl.right3)
                    elseif script.var.cache.counter2 == 7 then
                        --right
                        yaw = script.ref.getui(tbl.right3)
                    end
                elseif script.ref.getui(tbl.option) == "Slow yaw" then
                    yaw = script.var.cache.switch and script.ref.getui(tbl.left4) or script.ref.getui(tbl.right4)
                    sidemethod = 0
                    else
                    yaw = script.ref.getui(tbl.yaw)
                    sidemethod = 2
                end
                if script.math.contains(script.ref.getui(script.menu.items.AntiAim.addons), "Antibrute") and globals.curtime() - script.var.abstorage.bruted_last_time < 1 then
                    script.var.cache.limit = script.ref.getui(tbl.limit) + script.var.abstorage.limitalgo
                    script.var.cache.jitter = script.ref.getui(tbl.jitter) + script.var.abstorage.jitteralgo
                elseif ui.get(tbl.jittermethod) == "Normal" then
                    script.var.cache.jitter = script.ref.getui(tbl.jitter)
                elseif ui.get(tbl.jittermethod) == "Stomp" then
                    script.var.cache.jitter = script.ref.getui(tbl.jitter) + math.random(0,5) * 1.1
                elseif ui.get(tbl.jittermethod) == "Generation" then
                    local threat = client.current_threat()
                    if threat ~= nil then
                        if threat ~= script.var.cache.prevtarget or state ~= script.var.cache.prevstate then
                            script.var.cache.jitter = math.random(43, 72)
                        end
                        script.var.cache.prevtarget = threat
                        script.var.cache.prevstate = state
                    else
                        if state ~= script.var.cache.prevstate then
                            script.var.cache.jitter = math.random(43, 72)
                        end
                        script.var.cache.prevstate = state
                    end
                end
                script.ref.setui(menutbl.base[1], "at targets")
                local weapon_ent = script.ref.playerweapon(myself)
                local weapon = script.ref.getclassname(weapon_ent)
                if script.math.contains(script.ref.getui(script.menu.items.AntiAim.addons), "Static knife in air") and weapon:find("Knife") and string.find(state,"Air") then
                    script.handler.desync(event, sidemethod, true, math.random(-3,8), 7, 0, script.math.velocity(myself), state, myself)
                    return
                end
                if script.var.manual.angle ~= 0 then
                    script.handler.desync(event, sidemethod, true, script.var.manual.angle, script.var.cache.jitter, script.ref.getui(tbl.limit), script.math.velocity(myself), state, myself)
                else
                    if script.math.contains(script.ref.getui(script.menu.items.AntiAim.addons), "Airtick switcher") and string.find(state, "Air") then
                        script.handler.desync(event, sidemethod, true, yaw, script.var.cache.jitter, script.ref.getui(tbl.limit), script.math.velocity(myself), state, myself)
                    else
                        script.handler.desync(event, sidemethod, true, yaw, script.var.cache.jitter, script.ref.getui(tbl.limit), script.math.velocity(myself), state, myself)
                    end 
                end
            else
                ui.set(script.menu.ref.aa.AntiAimbot.yaw[2], script.var.manual.angle)
                ui.set(script.menu.ref.aa.AntiAimbot.jitter[2], 0)
                script.ref.setui(menutbl.body[1], "jitter")
                script.ref.setui(menutbl.base[1], "local view")
            end
        end,
        movementjitter = function(e)
            local me = script.ref.getlocal()
            local weapon_ent = entity.get_player_weapon(me)
            if not weapon_ent then
                return
            end
            local weapon = script.lib.csgo_weapons(weapon_ent)
            if not weapon then
                return
            end
            local velocity = script.math.velocity(me)
            local max_player_speed = (entity.get_prop(me, "m_bIsScoped") == 1) and weapon.max_player_speed_alt or weapon.max_player_speed
            local max_achieved = false
            local speed = max_achieved and max_player_speed or max_player_speed * 0.95
            if max_achieved then
                if velocity >= max_player_speed * 0.99 then
                    max_achieved = false
                end
            elseif velocity <= max_player_speed * 0.95 then
                max_achieved = true
            end
            local helper = ({errorcheck()})[2]
            if tostring(ui.get(helper)) ~= "false" then
                return
            end
            cvar.cl_sidespeed:set_int(speed)
            cvar.cl_forwardspeed:set_int(speed)
            cvar.cl_backspeed:set_int(speed)
        end,

        indicators = function()
            local font = script.math_value[script.ref.getui(script.menu.items.Visuals.indicator_options)]
            local w,h = script.ref.screensize()
            local myself = script.ref.getlocal()
            local build = getbuild()
            local yr, yg, yb = script.ref.getui(script.menu.items.Visuals.overall_color)

            if myself == nil or not script.ref.entityalive(myself) then
                return
            end

            if entity.get_prop(myself, "m_bIsScoped") == 1 then
				tbl.var.indicators.scoped_fraction = math_clamp(tbl.var.indicators.scoped_fraction + globals.frametime() / 0.3, 0, 1)
		    else
				tbl.var.indicators.scoped_fraction = math_clamp(tbl.var.indicators.scoped_fraction - globals.frametime() / 0.3, 0, 1)
			end

			local next_attack = script.ref.getprop(myself, "m_flNextAttack") or 0
			local next_primary_attack = script.ref.getprop(script.ref.playerweapon(myself), "m_flNextPrimaryAttack") or 0
            local dt_toggled = script.ref.getui(script.menu.ref.rage.other.dt[1]) and script.ref.getui(script.menu.ref.rage.other.dt[2])
			local dt_active = not(math.max(next_primary_attack, next_attack) > globals.curtime())

			if script.ref.getui(script.menu.ref.rage.other.fb[1]) then
				tbl.var.indicators.fb_fraction = math_clamp(tbl.var.indicators.fb_fraction + globals.frametime()/0.15, 0, 1.9)
					else
				tbl.var.indicators.fb_fraction = math_clamp(tbl.var.indicators.fb_fraction - globals.frametime()/0.15, 0, 1.9)
			end

			if dt_toggled and dt_active then
				tbl.var.indicators.active_fraction = math_clamp(tbl.var.indicators.active_fraction + globals.frametime()/0.175, 0, 2)
					else
				tbl.var.indicators.active_fraction = math_clamp(tbl.var.indicators.active_fraction - globals.frametime()/0.175, 0, 2)
		    end

			if dt_toggled and not dt_active then
			    tbl.var.indicators.inactive_fraction = math_clamp(tbl.var.indicators.inactive_fraction + globals.frametime()/0.15, 0, 2)
					else
		 	    tbl.var.indicators.inactive_fraction = math_clamp(tbl.var.indicators.inactive_fraction - globals.frametime()/0.15, 0, 2)
			end

			if script.ref.getui(script.menu.ref.aa.other.hs[2]) and script.ref.getui(script.menu.ref.aa.other.hs[2]) and not dt_toggled then
				tbl.var.indicators.hide_fraction = math_clamp(tbl.var.indicators.hide_fraction + globals.frametime()/0.2, 0, 2)
					else
				tbl.var.indicators.hide_fraction = math_clamp(tbl.var.indicators.hide_fraction - globals.frametime()/0.2, 0, 2)
			end

			if math.max(tbl.var.indicators.hide_fraction, tbl.var.indicators.inactive_fraction, tbl.var.indicators.active_fraction) > 0 then
				tbl.var.indicators.fraction = math_clamp(tbl.var.indicators.fraction + globals.frametime()/0.2, 0, 1)
					else
				tbl.var.indicators.fraction = math_clamp(tbl.var.indicators.fraction - globals.frametime()/0.2, 0, 1)
			end


			if font == "-c" then
                style_f = string.upper
            else 
                style_f = string.lower
            end

            if script.ref.getui(script.menu.items.Visuals.indicator_style) == "modern" then

                local ambani_w = renderer.measure_text(font, style_f("ambani "))
                local ambani_ver = renderer.measure_text(font, style_f(build))
                local anim_text = script.func:animate_text(globals.curtime() * 0.5, style_f(build), yr, yg, yb, 255)
                    renderer.text(w/2 + ((ambani_w + ambani_ver)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 20, 255, 255, 255, 255, font, 0, style_f("ambani "), unpack(anim_text))

                local dt_size = renderer.measure_text(font, style_f("dt"))
                local ready_size = renderer.measure_text(font, style_f("active"))
                    renderer.text(w/2 + ((dt_size + ready_size + 2)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 40, 255, 255, 255, tbl.var.indicators.active_fraction * 255, font, dt_size + tbl.var.indicators.active_fraction * ready_size, style_f("dt"), "\a" ..script.func:rgba_to_hex(0, 128, 0, 255 * tbl.var.indicators.active_fraction) .. style_f(" active"))

                local charging_size = renderer.measure_text(font, style_f("waiting"))
                local ret = script.func:animate_text(globals.curtime() * 2, style_f("waiting"), 245, 0, 0 ,255) --245, 0, 0 ,255
                    renderer.text(w/2 + ((dt_size + charging_size + 2)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 40, 255, 255, 255, tbl.var.indicators.inactive_fraction * 255, font, dt_size + tbl.var.indicators.inactive_fraction * charging_size, style_f("dt"), unpack(ret))

                local hide_size = renderer.measure_text(font, style_f("hide"))
                local active_size = renderer.measure_text(font, style_f("active"))
                    renderer.text(w/2 + ((hide_size + active_size + 2)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 40, 255, 255, 255, tbl.var.indicators.hide_fraction * 255, font, hide_size + tbl.var.indicators.hide_fraction * active_size, style_f("hide"), "\a" .. script.func:rgba_to_hex(0, 128, 0, 255 * tbl.var.indicators.hide_fraction) .. style_f(" active"))

                local baim_size = renderer.measure_text(font, style_f("baim"))
                    renderer.text(w/2 + ((baim_size)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 40 + 10 * script.math:easeInOut(tbl.var.indicators.fraction), 255, 255, 255, tbl.var.indicators.fb_fraction * 255, font, tbl.var.indicators.fb_fraction * baim_size, style_f("baim"))


                --local state_math_clamp = math_clamp(state_math_clamp, script.var.indicators.state, globals.frametime() / 0.2, 0, 1.9)
                local state_size = renderer.measure_text(font, style_f("- "..script.var.indicators.state.." -"))
                    renderer.text(w/2 + ((state_size)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 30, 255, 255, 255, 255, font, 0, style_f("- "..script.var.indicators.state.." -"))
            
            elseif script.ref.getui(script.menu.items.Visuals.indicator_style) == "new" then --indicators new style

                local ambani_unpack = script.func:animate_text(globals.curtime() * 0.75, style_f("A M B A N I"), yr, yg, yb ,245) --245, 0, 0 ,255
                local ambani_w = renderer.measure_text(font, unpack(ambani_unpack))
                    renderer.text(w/2 + ((ambani_w + 2)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 30, 255, 255, 255, 255, font, 0, unpack(ambani_unpack)) --main text
                local ambani_ver = renderer.measure_text(font, style_f(build))
                    renderer.text(w/2 + ((ambani_ver + 2)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 20, 255, 255, 255, 255, font, 0, style_f(build)) -- version text

                local state_size = renderer.measure_text(font, style_f("- "..script.var.indicators.state.." -"))
                    renderer.text(w/2 + ((state_size + 2)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 40, 255, 255, 255, 255, font, 0, style_f("- "..script.var.indicators.state.." -"))

                local dt_size = renderer.measure_text(font, style_f(" dt"))
                local ready_size = renderer.measure_text(font, style_f("ready"))
                    renderer.text(w/2 + ((dt_size + ready_size + 2)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 50, 255, 255, 255, tbl.var.indicators.active_fraction * 255, font, dt_size + tbl.var.indicators.active_fraction * ready_size, style_f("dt "), "\a" ..script.func:rgba_to_hex(0, 128, 0, 255 * tbl.var.indicators.active_fraction) .. style_f("ready"))

                local hide_size = renderer.measure_text(font, style_f(" hide"))
                local active_size = renderer.measure_text(font, style_f("ready"))
                    renderer.text(w/2 + ((hide_size + active_size + 2)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 50, 255, 255, 255, tbl.var.indicators.hide_fraction * 255, font, hide_size + tbl.var.indicators.hide_fraction * active_size, style_f("hide "), "\a" .. script.func:rgba_to_hex(0, 128, 0, 255 * tbl.var.indicators.hide_fraction) .. style_f("ready"))
                local baim_size = renderer.measure_text(font, style_f("baim"))
                    renderer.text(w/2 + ((baim_size + 2)/2 + 2) * script.math:easeInOut(tbl.var.indicators.scoped_fraction), h/2 + 50 + 10 * script.math:easeInOut(tbl.var.indicators.fraction), 255, 255, 255, tbl.var.indicators.fb_fraction * 255, font, tbl.var.indicators.fb_fraction * baim_size, style_f("baim"))
            end
            if script.ref.entityalive(myself) then
                if script.math.contains(script.ref.getui(script.menu.items.Visuals.indicators), "Arrows") then
                    if script.var.manual.angle == -90 then
                        script.ref.textrender(w / 2 - 50, h / 2, yr, yg, yb, 255, "cb", 0, "❰")
                    end
                    if script.var.manual.angle == 90 then
                        script.ref.textrender(w / 2 + 50, h / 2, yr, yg, yb, 255, "cb", 0, "❱")
                    end
                end
            end
        end,
        defensive_indication = function ()
            local myself = script.ref.getlocal()
            local w, h = script.ref.screensize()
            local r,g,b = script.ref.getui(script.menu.items.Visuals.overall_color)

            if script.math.contains(script.ref.getui(script.menu.items.Visuals.indicators), "Defensive") then
                local charge = script.var.cache.defensive
                if myself == nil or not script.ref.entityalive(myself) then
                    return
                end
                script.var.indicators.lerped5 = math_clamp(script.var.indicators.lerped5 + (globals.tickcount() <= script.var.cache.data[myself].defensive_active_until and 1 * globals.frametime() or -1 * globals.frametime()), 0, 1)
                if script.handler.defensivestatus() ~= nil then
                    script.var.indicators.lerped4 = script.math.utility_lerp(script.var.indicators.lerped4, script.handler.defensivestatus()*-1, 4 * globals.frametime())
                end
                local tx, ty = renderer.measure_text("", "Defensive status ->")
                if globals.tickcount() <= script.var.cache.data[myself].defensive_active_until then
                    renderer.text(w/2, h/2 - 400, 255, 255, 255, 255*script.var.indicators.lerped5, "c", 0, "Defensive status ->")
                    script.math.glow_module(w / 2 - 55, h / 2 - 400 + ty, 110, 4, 6, 2, {255,255,255,155}, {r,g,b, 0})
                    script.math.render_rectangle(w / 2 - 1, h / 2 - 400 + ty, math.floor(script.var.indicators.lerped4* 4), 5, 255,255,255, 250, 0)
                    script.math.render_rectangle(w / 2 + 2, h / 2 - 400 + ty, (math.floor(script.var.indicators.lerped4* 4))*-1, 5, 255,255,255, 250, 1, 0)
                end
            end
        end,

        ambani_render_logs = function()
            local curtime = globals.curtime()
            local frames = 1.5 * globals.frametime()
            local log_offset = 8
            local screen = {client.screen_size()}
            local r,g,b,a = script.ref.getui(script.menu.items.Visuals.notifypicker)
            local r2,g2,b2,a2 = 255,255,255,255
            for key, log in pairs(logs) do
                log.time = log.time - globals.frametime()
                if key > 4 then
                    table.remove(logs, 1)
                end
                if log.time <= 0 then
                    table.remove(logs, key)
                end
                local animation = (log.anim_time - curtime) * -0.7 
                local string = script.math.color_text(log.text, r, g, b, a * log.color2)
                local t_size = math.floor(renderer.measure_text("cb", "[Ambani] ".. string) - 123)
                t_size = math.floor(renderer.measure_text("cb", "[Ambani] ".. string) - 123)
                local x, y = screen[1] / 2, screen[2] / 2 + 192
                local h, w = 18, t_size + 5
                if log.time > 4.9 then
                    log.color = script.math.utility_lerp(log.color, a, 2 * globals.frametime())
                    log.color2 = math_clamp(log.color2 + (globals.frametime() * 1.5), 0, 1)
                    log.width = script.math.utility_lerp(log.width, 155, frames)
                    log.circle = math_clamp(log.circle + (globals.frametime() * -2), 0, 1)
                    log.anim_mod = script.math.utility_lerp(log.anim_mod, log.time, frames)
                    log.str_a = math_clamp(log.str_a + (globals.frametime() * 0.5), 0, 1)
                    log.height = math_clamp(log.height + (globals.frametime() * 4), 0, 1)
                    log.height2 = math_clamp(log.height2 + (log.height > 0.75 and globals.frametime() * 7 or globals.frametime() * -7), 0, 1)
                    log.w = script.math.utility_lerp(log.w, t_size + 8, log.anim_mod)
                end
                if log.time < 0.5 then
                    log.color = script.math.utility_lerp(log.color, -a, 1 * globals.frametime())
                    log.color2 = math_clamp(log.color2 + (globals.frametime() * -20), 0, 1)
                    log.anim_mod = script.math.utility_lerp(log.anim_mod, -log.time - 5, frames)
                    log.width = script.math.utility_lerp(log.width, -155, frames)
                    --log.circle = script.math.utility_lerp(log.circle, -0.62, frames)
                    log.height = math_clamp(log.height + (globals.frametime() * -20), 0, 1)
                    log.str_a = math_clamp(log.str_a + (globals.frametime() * -0.5), 0, 1)
                    local reversed = log.anim_mod * -1 + 1
                    log.w = script.math.utility_lerp(log.w, 5, reversed)
                end 
                if log.time > 4 and log.anim_mod <= 0 then
                    table.remove(logs, key)
                end
                local text_left = "Ambani "
                log_offset = log_offset + 30, log.anim_mod
                x = x - w / 2
                y = y / 10 * 13.4 - log_offset
                log.timer = script.math.utility_lerp(log.timer, animation * t_size / 2, 10 * globals.frametime())
                if script.ref.getui(script.menu.items.Visuals.glow) then 
                    script.math.glow_module(x - 50, y + 122 - 100 * log.height - 20 * log.height2, t_size + 100, 19, 10, 10, {r, g, b, 80 * log.color2}, {255,255,255,0})
                end
                script.math.render_rectangle(x - 50, y + 122 - 100 * log.height - 20 * log.height2, t_size + 100, 20, 10, 10, 10, 250 * log.color2, 6)
                local hex = rgba_to_hex(r, g, b, a * log.color2)
                local hex2 = rgba_to_hex(255, 255, 255, a * log.color2)
                --renderer.text(x + renderer.measure_text("c",text_left) / 2 - 40, y + 132 - 100 * log.height - 20 * log.height2, r, g, b, a * log.color2, 'cb', nil, "AMBANI")
                if image ~= nil then
                    image:draw(x + t_size - t_size - 44, y + 124 - 100 * log.height - 20 * log.height2, 17, 17, 0, 0, 0, 255 * log.color2, false)
                    image:draw(x + t_size - t_size - 43, y + 123 - 100 * log.height - 20 * log.height2, 17, 17, r, g, b, a * log.color2, false)
                end
                renderer.text(x + t_size / 2 + renderer.measure_text("c",text_left) / 2 - 11, y + 132 - 100 * log.height - 20 * log.height2, 255, 255, 255, a * log.color2, 'c', nil, string)
            end
        end,
        oldanimations = function()
            local myself = script.ref.getlocal()
            if myself == nil then
                return
            end
            if script.math.contains(script.ref.getui(script.menu.items.Misc.anims), "Leg Fucker") then
                script.ref.setprop(myself, "m_flPoseParameter", 1, 7)
            end

            if script.math.contains(script.ref.getui(script.menu.items.Misc.anims), "Static Legs") then
                script.ref.setprop(myself, "m_flPoseParameter", 1, 6)
            end      
        end,
        killsay = function(arg)
            if script.ref.getui(script.menu.items.Misc.killsay) then 
                local myself = script.ref.getlocal()
                if myself == nil then
                    return
                end
                local victim = arg.userid
                local attacker = arg.attacker
                if victim == nil or attacker == nil then
                    return
                end
                if script.ref.useridtoent(attacker) == myself and script.ref.isenemy(script.ref.useridtoent(victim)) then
                    client.delay_call(3, function()
                    script.ref.clientexec('say ' .. script.var.killtable.killquotes[script.ref.random(script.math.len(script.var.killtable.killquotes))])
                    end)
                end
            end
        end,
        clantag = function()
            if script.ref.getui(script.menu.items.Misc.clantag) then
                script.ref.setclantag("ambani")
            end
        end,
        legitaa = function(arg)
            local myself = script.ref.getlocal()
            if myself == nil then
                return
            end
            if script.math.contains(script.ref.getui(script.menu.items.AntiAim.addons), "Legit aa") and arg.in_use == 1 then
                if script.ref.getclassname(script.ref.playerweapon(myself)) == "CC4" then
                    return
                end
                if arg.in_attack == 1 then
                    arg.in_use = 1
                end
                if arg.chokedcommands == 0 then
                    arg.in_use = 0
                end
            end
        end,
        antibrute = function(e)
            local me = entity.get_local_player()
            if entity.is_alive(me) then
                if math.abs(script.var.abstorage.bruted_last_time - globals.curtime()) > 0.250 then
                    local ent = client.userid_to_entindex(e.userid)
                    if not entity.is_dormant(ent) and entity.is_enemy(ent) then
                        local headx, heady, headz = entity.hitbox_position(me, 0)
                        local eyex, eyey, eyez = entity.get_origin(ent)
                        eyez = eyez + 64
                        local x, y, z = script.math.closest_point_on_ray(headx, heady, headz, eyex, eyey, eyez, e.x, e.y, e.z)
                        if script.math.vector3_distance(x, y, z, headx, heady, headz) < 88 then
                            script.var.abstorage.bruted_last_time = globals.curtime() 
                            script.var.abstorage.time[ent] = globals.curtime() + 1
                            script.var.abstorage.should_swap[ent] = true
                            script.var.abstorage.jitteralgo = math.random(-2,5)
                            script.var.abstorage.limitalgo = math.random(3,13)
                            print("Jitter value: "..script.var.abstorage.jitteralgo)
                            print("Limit value: "..script.var.abstorage.limitalgo)
                            if script.math.contains(script.ref.getui(script.menu.items.Visuals.indicators), "Notifications") then
                                ambani_insert_log("Changed [$'jitter'$] due to $bullet$ from $"..entity.get_player_name(ent).."$",6)
                            end
                        end
                    end
                end
            end
        end,
    }
    script.callbacks = {
        paint_ui = {
            script.handler.menuitems,
            script.handler.indicators,
            script.handler.clantag,
            script.handler.ambani_render_logs,
            script.handler.tickbase,
            script.handler.defensive_indication
        },
        setup_command = {
            script.handler.antiaim,
            script.handler.legitaa,
            script.handler.movementjitter,
        },
        pre_render = {
            script.handler.oldanimations,
        },
        player_death = {
            script.handler.killsay
        },
        run_command = {
            script.handler.checkladders
        },
        net_update_end = {
            script.handler.defensivestatus,
        },
        bullet_impact = {
            script.handler.antibrute
        }
    }
    script.callback = function(event, func)
        script.ref.clientcallback(event, func)
    end
    for index, value in next, script.callbacks do
        for i, v in next, value do
            loadstring("({...})[1](({...})[2],({...})[3])")(script.callback, index, v)
        end
    end
end)(tbl)
