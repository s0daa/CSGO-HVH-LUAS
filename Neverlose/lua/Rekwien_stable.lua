-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

--Fixed by Kostas Legiter1337
local vmt_hook = require("neverlose/vmt_hook")
local base64 = require("neverlose/base64")
local tween = require("neverlose/tween")
local clipboard = require('neverlose/clipboard')
local gradient = require("neverlose/gradient")
local animatables = require("neverlose/animatables")
local draggables = require("neverlose/draggables")
local color_print = require("neverlose/color_print")

function this_call(call, parameters)
    return function(...)
        return call(parameters, ...)
    end
end

ffi.cdef[[
	typedef void*(__thiscall* get_client_entity_t)(void*, int);

	void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
	bool DeleteUrlCacheEntryA(const char* lpszUrlName);
	
	typedef int(__thiscall* get_clipboard_text_length)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet'
local entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface("client.dll", "VClientEntityList003"))

local util = {
	hooked_function = nil,
	get_entity_address = this_call(ffi.cast("get_client_entity_t", entity_list_003[0][3]), entity_list_003),
	
	get_time = function()
		local system_time = common.get_system_time()

		return {
			hour = system_time.hours,
			minute = system_time.minutes,
			second = system_time.seconds,
		}
	end,
	
	clamp = function(value, min, max)
		return math.min(max, math.max(min, value))
	end,
	
	lerp = function(a, b_, t)
		local t = math.min(1, math.max(0, globals.frametime * (0.045 * 175)))

		if type(a) == 'userdata' then
			r, g, b, a = a.r, a.g, a.b, a.a
			e_r, e_g, e_b, e_a = b_.r, b_.g, b_.b, b_.a
			r = lerp(r, e_r, t)
			g = lerp(g, e_g, t)
			b = lerp(b, e_b, t)
			a = lerp(a, e_a, t)
			return color.new(r, g, b, a)
		end

		local d = b_ - a
		d = d * t
		d = d + a

		if b_ == 0 and d < 0.01 and d > -0.01 then
			d = 0
		elseif b_ == 1 and d < 1.01 and d > 0.99 then
			d = 1
		end
		return d
	end,
	
	ffi_handler = {},
	download_file = function(from, to)
		wininet.DeleteUrlCacheEntryA(from)
		urlmon.URLDownloadToFileA(nil, from, to, 0, 0)
	end,
	
	round = function(num, pl) 
		return tonumber(string.format("%."..(pl or 0).."f", num)) 
	end,
	
	get_current_condition = function()
		local player = entity.get_local_player()
		if not player then 
			return end
			
		local velocity = math.floor(math.sqrt(player["m_vecVelocity[0]"]^2 + player["m_vecVelocity[1]"]^2))
		if bit.band(player.m_fFlags, 1) == 1 then
			if bit.band(player.m_fFlags, 4) == 4 then
				return 4
			else
				if velocity <= 3 then
					return 1
				else
					if ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then 
						return 3
					else
						return 2
					end
				end
			end
		elseif bit.band(player.m_fFlags, 1) == 0 then
			if bit.band(player.m_fFlags, 4) == 4 then
				return 6
			else
				return 5
			end
		end
	end,
	
	get_desync_delta = function()
		local delta_to_draw = math.min(math.abs(rage.antiaim:get_rotation() - rage.antiaim:get_rotation(true)) / 2, 60)
		return string.format("%.1f", delta_to_draw)
	end,
	
	build_clantag = function(tag)
		local ret = {}
		for i = 1, #tag do
			table.insert(ret, tag:sub(1, i))
		end
		for i = 1, #tag do
			table.insert(ret, tag:sub(i, #tag))
		end
		table.insert(ret, '')
		return ret
	end,
	
	get_trace = function(length)
		local player = entity.get_local_player()
		if not player then 
			return end
			
		local x, y, z = player["m_vecOrigin"].x, player["m_vecOrigin"].y, player["m_vecOrigin"].z

		for a = 0, math.pi * 2, math.pi * 2 / 8 do
			local ptX, ptY = ((10 * math.cos( a ) ) + x), ((10 * math.sin( a ) ) + y)
			local trace = utils.trace_line(vector(ptX, ptY, z), vector(ptX, ptY, z-length), entity.get_local_player())
			local fraction, entity = trace.fraction, trace.entity

			if fraction ~= 1 then 
				return true
			end
		end
		return false
	end,
	
	get_spectators = function()
		local spectators = {}

		local player, target = entity.get_local_player()

		if player ~= nil then
			if player.m_hObserverTarget then
				target = player.m_hObserverTarget
			else
				target = player
			end

			local players = entity.get_players(false, false)

			if players ~= nil then
				for k, player in pairs(players) do
					if player.m_hObserverTarget and player.m_hObserverTarget == target then
						table.insert(spectators, player)
					end
				end
			end
		end

		return spectators
	end,

	in_bounds = function(vec1, vec2)
        local mouse_pos = ui.get_mouse_position()
        return mouse_pos.x >= vec1.x and mouse_pos.x <= vec2.x and mouse_pos.y >= vec1.y and mouse_pos.y <= vec2.y
    end,
	
	calculate_distance = function(pos1, pos2)
		local lx = pos1.x
		local ly = pos1.y
		local lz = pos1.z
		local tx = pos2.x
		local ty = pos2.y
		local tz = pos2.z
		local dx = lx - tx
		local dy = ly - ty
		local dz = lz - tz
		return math.sqrt(dx * dx + dy * dy + dz * dz)
	end,
}

util.ffi_handler.vgui = ffi.cast(ffi.typeof("void***"), utils.create_interface("vgui2.dll", "VGUI_System010"))
util.ffi_handler.get_clipboard_text_length = ffi.cast("get_clipboard_text_length", util.ffi_handler.vgui[0][7])
util.ffi_handler.get_clipboard_text = ffi.cast("get_clipboard_text", util.ffi_handler.vgui[0][11])
util.ffi_handler.set_clipboard_text = ffi.cast("set_clipboard_text", util.ffi_handler.vgui[0][9])

files.create_folder("nl\\RekwieN.tech")
util.download_file("https://cdn.discordapp.com/attachments/1004747777265385533/1132346588346462268/goofy-goofy-ahh.gif", "nl\\RekwieN.tech\\goofy-goofy-ahh.gif")

local gui = {
	screen = render.screen_size(),
	
	logo = render.load_image_from_file("nl\\RekwieN.tech\\goofy-goofy-ahh.gif", vector(500, 500)),

	fonts = {
		verdana = render.load_font("Verdana", 11, "a"),
		arial = render.load_font("arial", 12, "a"),
		arial_s = render.load_font("arial", 11, "a"),
		skeetind_font = render.load_font('calibri', 22, 'ab')
    },
	
	dragging = false
}

local config = {
	theme_gradient = false,
	theme = {color(255, 0, 0, 255), color(255, 255, 255, 255)},
	info = {},
	misc = {},
	antihit = {condition_settings = {}},
	visuals = {},
}

local draw = {
	string_multicolored = function(data, x, y, font, centered, shadow, alpha)
		if #data == 0 then return end
		
		local text = ""
		for i = 1, #data do
			text = text..tostring(data[i][1])
		end
		
		local text_size = centered and -render.measure_text(font, nil, text).x/2 or 0
		for i = 1, #data do
			if type(data[i][1]) ~= "string" then data[i][1] = tostring(data[i][1]) end
			if shadow then
				render.text(font, vector(x + text_size + 1, y + 1), color(0,0,0, data[i][2].a * alpha), nil, data[i][1])
			end
			render.text(font, vector(x + text_size, y), color(data[i][2].r, data[i][2].g, data[i][2].b, data[i][2].a * alpha), nil, data[i][1])
			text_size = text_size + render.measure_text(font, nil, data[i][1]).x
		end
	end,
	
	custom_rectangle = function(x, y, w, h, style, outline, gradient, alpha)
		if style == "Metamod" then
			render.rect(vector(x, y), vector(w, h), color(17, 17, 17, config.theme[1].a * alpha))
			if gui.logo ~= nil then
				render.texture(gui.logo, vector(x + 2, y + 1), vector(14, 14), color(255, 255, 255, 255 * alpha))
			end
			if gradient == "None" then
				render.rect(vector(x, y - 1), vector(w, y), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha))
				if outline then
					render.rect(vector(x, y), vector(x + 1, h), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha))
					render.rect(vector(x, h - 1), vector(w, h), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha))
					render.rect(vector(w - 1, y), vector(w, h), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha))
				end
			elseif gradient == "Horizontal" then
				if outline then
					render.gradient(vector(x, y - 1), vector(w, y), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
					render.rect(vector(x, y), vector(x + 1, h), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha))
					render.gradient(vector(x, h - 1), vector(w, h), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
					render.rect(vector(w - 1, y), vector(w, h), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
				else
					render.gradient(vector(x, y - 1), vector(w, y), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
				end
			elseif gradient == "Vertical" then
				if outline then
					render.rect(vector(x, y - 1), vector(w, y), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha))
					render.gradient(vector(x, y), vector(x + 1, h), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
					render.rect(vector(x, h - 1), vector(w, h), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
					render.gradient(vector(w - 1, y), vector(w, h), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
				else
					render.gradient(vector(x, y - 1), vector(w, y), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha))
				end
			end
		else
			if outline then
				render.rect(vector(x - 5, y), vector(w, h + 1), color(17, 17, 17, config.theme[1].a * alpha), 5)
				if gradient == "None" then
					render.rect_outline(vector(x - 5, y), vector(w, h + 1), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), 1, 5)
				elseif gradient == "Horizontal" then
					render.circle_outline(vector(x, y + 4), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), 5, 180, 0.3)
					render.gradient(vector(x + 1, y), vector(w - 4, y + 1), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
					render.circle_outline(vector(x, h - 4), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), 5, 80, 0.3)
					render.gradient(vector(x, h), vector(w - 4, h + 1), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
					render.circle_outline(vector(w - 4, y + 4), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), 5, 270, 0.3)
					render.rect(vector(x - 5, y + 4), vector(x - 4, h - 4), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha))
					render.circle_outline(vector(w - 4, h - 4), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), 5, 0, 0.3)
					render.rect(vector(w - 1, y + 4), vector(w, h - 4), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
				elseif gradient == "Vertical" then
					render.circle_outline(vector(x, y + 4), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), 5, 180, 0.3)
					render.rect(vector(x + 1, y), vector(w - 4, y + 1), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha))
					render.circle_outline(vector(x, h - 4), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), 5, 80, 0.3)
					render.rect(vector(x, h), vector(w - 4, h + 1), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
					render.circle_outline(vector(w - 4, y + 4), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), 5, 270, 0.3)
					render.gradient(vector(x - 5, y + 4), vector(x - 4, h - 4), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
					render.circle_outline(vector(w - 4, h - 4), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), 5, 0, 0.3)
					render.gradient(vector(w - 1, y + 4), vector(w, h - 4), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255 * alpha))
				end
			else
				if gradient == "None" then
					render.rect(vector(x - 5, y), vector(w, h + 1), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, config.theme[1].a * alpha), 5)
				elseif gradient == "Horizontal" then
					render.gradient(vector(x - 5, y), vector(w, h + 1), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, config.theme[1].a * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, config.theme[2].a * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, config.theme[1].a * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, config.theme[2].a * alpha), 5)
				elseif gradient == "Vertical" then
					render.gradient(vector(x - 5, y), vector(w, h + 1), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, config.theme[1].a * alpha), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, config.theme[1].a * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, config.theme[2].a * alpha), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, config.theme[2].a * alpha), 5)
				end
			end
			if gui.logo ~= nil then
				render.texture(gui.logo, vector(x + 2, y + 1), vector(14, 14), color(255, 255, 255, 255 * alpha))
			end
		end
	end,

	skeet_indicator = function(text, y_add, clr)
		local x = gui.screen.x/100 + 2
		
		local font_size = render.measure_text(gui.fonts.skeetind_font, nil, text)
        render.gradient(vector(13, y_add), vector(13 + (font_size.x)/2, y_add + 28), color(0, 0, 0, 0), color(0, 0, 0, 65), color(0, 0, 0, 0), color(0, 0, 0, 65))
        render.gradient(vector(13 + (font_size.x)/2, y_add), vector(13 + (font_size.x), y_add + 28), color(0, 0, 0, 65), color(0, 0, 0, 0), color(0, 0, 0, 65), color(0, 0, 0, 0))
		render.text(gui.fonts.skeetind_font, vector(x, y_add + 5), color(0, 0, 0, 255), nil, text)
		render.text(gui.fonts.skeetind_font, vector(x, y_add + 4), clr, nil, text)
    end,
}

local animations_table = {}
local animations_data = {
	keybinds_width = 0,
	spectators_width = 0,
	indicators_width = 0,
}

local functions = {
	watermark = {
		username = common.get_username()
	},
	antihit = {
		condition_settings = {},
		cond_menu = {"[S]", "[M]", "[SW]", "[D]", "[A]", "[A-D]"},
		conditions = {"Standing", "Moving", "Slowwalk", "Ducking", "Air", "Air-ducking"},
		breaker = {tick = 1, time = 0}
	},
	hitlogs = {
		data = {},
		hitboxes = { [0] = "generic",
			"head", "chest", "stomach",
			"left arm", "right arm",
			"left leg", "right leg",
			"neck", "generic", "gear"
		},
		miss_count = 1, hit_count = 1
	},
	misc = {
		time = globals.curtime, fake = 0,
	 	trashtalk = {"1", "BOMBED", "lol", "HS", "MISSED AAAGAIN", "TRY TO HIT ME BRATAN", "спать сученок", "смерти желаю", "тупое отродие хахахаха", "умри", "не играй больше в эту игру..", "АХАХХАХА", "жаль тебя", "ебать ты глупый боже", "изи", "KUDA BRATKA", "DALEKO>>??", "not gg", "u so bad", "dogshit player", "non luck only skill", "Хуй знает, не противник", "Изи, сын шлюхи", "Кряк не забустил, хуесос?", "Че ты тут делаешь, в бравлстарсе же абнова вышла, новова перса дабавили, беги быстрее!!!!!","Ау, сочняра, паблик лузаешь, ссаный пидор", "Пиздец, на каком ты дне валяешься, сын твари", "Пидорас, ты из тех людей которые занимают третье место, играя 1v1", "Ты причина легализации абортов", "АБУЗ СКИТА? НЕТ БЛЯТЬ КРЯКА!", "Хули ты падаешь то? Иди у кисляши кфг прикупи на кряк", "Я ТВОЕЙ МАТЕРИ ЗУБЫ ВЫБИЛ ХУЕСОС", "Некоторым  платят за оральный ceкc, но ты делаешь это бесплатно", "Дружище, с таким уровнем игры иди убейся об стену, прям как твой батя", "Унижен, сын ссаной собаки", "Сын пидораса, матуху твою зарезал", "冂口山仨几 廾丹乂丫认 冂认亼口尸",         "ой а кто (who) ты (you) такой вотзефак мен))))))",
		"thats going in my media compilation right there get shamed retard rofl", "imagine the only thing you eat being bullets man being a thirdworlder must suck rofl", "so fucking ez", "bot_kick", "where the enemies at????", "але найс упал нищ ЛОООООООЛ", "с тобой там все хорошо????????????? а да ты нищ нахуя я спрашиваю ПХАХАХАХАХХА","жаль конечно что против нищей играть надо)))","тебе даже спин не поможет блять, нахуй ты вообще живешь",
		"ты можешь заселлить лишнюю хромосому???","научи потом как так сосать на хвх", "когда не накопил на гормоны и чулки)))))))))))))","как там жизнь на мамкину пенсию???????","але я бот_кик в консоль вроде прописал а вас там не кикнуло эт че баг??)))))))))","крякоюзер down, на завод нахуй","я не понял ты такой жирный потомучто дошики каждый день жрешь???? нормальную работу найди может на еду денег хватит))))))))))))","насрал тебе в ротешник проверяй","нихуя ты там как самолет отлетел ХАХАХХАХАХАХАХХХААХАА","БЛЯ НИЩ ХУЯК ХУЯК И ТЕБЯ НЕТ КАК МОЖНО ТАКИМ БЫТЬ?????? ОБЬЯСНИСЬ БЛЯТЬ","держи зонтик ☂, тебя обоссали",
		"Держи ✈ и лети нахуй !","слишком сочный для RekwieN.tech","сьебался нахуй таракан усатый","мать твою ебал","нахуй ты упал иди вставай и на завод","не по сезону шуршишь фраер","ИЗИ ЧМО ЕБАНОЕ","ливай блять не позорься","AХАХ ПИДОР УПАЛ С ВАНВЕЯ ХАХАХА ОНЛИ БАИМ В БОДИ ПОТЕЕТ НА ФД АХА",
		"АХАХА УЛЕТЕЛ ЧМОШНИК","1 МАТЬ ЖАЛЬ","тебе права голоса не давали thirdworlder ебаный","на завод иди","не не он опять упал на конлени","вставай заебал , завтра в школу","гет гуд гет иди нахуй","by SANCHEZj hvh boss","ну нет почему он ложится когда я прохожу","у тебя ник нейм адео?","парень тебе ник придумать?","такой тупой :(",
		"хватит получать хс, лучше возьми свою руку и иди дрочи","нет нет этот крякер такой смешной","1 сын шлюхи","1 мать твою ебал","преобрети мой кфг клоун","об кафель голову разбил?","мать твою ебал","хуесос дальше адайся ко мне","ещё раз позови к себе на бекап","не противник","ник нейм дориан(","iq ?","упал = минус мать","не пиши мне",
		"жаль конечно что против тебя играю, но куда деваться","адиничкой упал","сынок зачем тебе это ?","давно в рот берёшь?","мне можно","ты меня так заебал , ливни уже","ничему жизнь не учит (","я не понял, ты такой жирный потомучто дошики каждый день жрешь?","братка го я тебе бекап позову","толстяк даже пройти спокойно не может",}
		},
	clantag = {
		data = util.build_clantag("RekwieN.tech"),
		last = nil
	},
}

local cfg_system = {}
cfg_system.default_cfg = "eyJhbnRpaGl0OmFiZiI6dHJ1ZSwiYW50aWhpdDphYmZkaXN0YW5jZSI6MTQyLjAsImFudGloaXQ6YmFja3N0YWIiOnRydWUsImFudGloaXQ6Ym9keXlhdy0xIjp0cnVlLCJhbnRpaGl0OmJvZHl5YXctMiI6dHJ1ZSwiYW50aWhpdDpib2R5eWF3LTMiOnRydWUsImFudGloaXQ6Ym9keXlhdy00Ijp0cnVlLCJhbnRpaGl0OmJvZHl5YXctNSI6dHJ1ZSwiYW50aWhpdDpib2R5eWF3LTYiOnRydWUsImFudGloaXQ6Ym9keXlhd2xlZnQtMSI6MzAuMCwiYW50aWhpdDpib2R5eWF3bGVmdC0yIjo0Mi4wLCJhbnRpaGl0OmJvZHl5YXdsZWZ0LTMiOjI4LjAsImFudGloaXQ6Ym9keXlhd2xlZnQtNCI6NDkuMCwiYW50aWhpdDpib2R5eWF3bGVmdC01Ijo0NC4wLCJhbnRpaGl0OmJvZHl5YXdsZWZ0LTYiOjQ1LjAsImFudGloaXQ6Ym9keXlhd3JpZ2h0LTEiOjUzLjAsImFudGloaXQ6Ym9keXlhd3JpZ2h0LTIiOjI1LjAsImFudGloaXQ6Ym9keXlhd3JpZ2h0LTMiOjUwLjAsImFudGloaXQ6Ym9keXlhd3JpZ2h0LTQiOjI4LjAsImFudGloaXQ6Ym9keXlhd3JpZ2h0LTUiOjI5LjAsImFudGloaXQ6Ym9keXlhd3JpZ2h0LTYiOjI3LjAsImFudGloaXQ6YnJlYWtlcnMiOlsiRm9sbG93IERpcmVjdGlvbiIsIlN0YXRpYyBMZWdzIEluIEFpciIsIkZ1Y2tlciJdLCJhbnRpaGl0OmRlZmVuc2l2ZSI6IjU2NTc1OTEyIGNsZWFyIiwiYW50aWhpdDpkZWZlbnNpdmVfcGl0Y2hfbGVmdCI6LTg5LjAsImFudGloaXQ6ZGVmZW5zaXZlX3BpdGNoX3JpZ2h0IjotODkuMCwiYW50aWhpdDpkZWZlbnNpdmVfcGl0Y2hfdmFsdWUiOjg5LjAsImFudGloaXQ6ZGVmZW5zaXZlX3lhd19sZWZ0IjotNDUuMCwiYW50aWhpdDpkZWZlbnNpdmVfeWF3X3JpZ2h0IjoyNS4wLCJhbnRpaGl0OmRlZmVuc2l2ZV95YXdfdmFsdWUiOi0zNS4wLCJhbnRpaGl0OmRlc3luY3N0YXRlLTEiOiJPZmYiLCJhbnRpaGl0OmRlc3luY3N0YXRlLTIiOiJPZmYiLCJhbnRpaGl0OmRlc3luY3N0YXRlLTMiOiJPZmYiLCJhbnRpaGl0OmRlc3luY3N0YXRlLTQiOiJPZmYiLCJhbnRpaGl0OmRlc3luY3N0YXRlLTUiOiJPZmYiLCJhbnRpaGl0OmRlc3luY3N0YXRlLTYiOiJPZmYiLCJhbnRpaGl0OmRpc2NhcmdlIjp0cnVlLCJhbnRpaGl0OmZha2VvcHRpb25zLTEiOlsiSml0dGVyIl0sImFudGloaXQ6ZmFrZW9wdGlvbnMtMiI6WyJKaXR0ZXIiXSwiYW50aWhpdDpmYWtlb3B0aW9ucy0zIjpbIkppdHRlciJdLCJhbnRpaGl0OmZha2VvcHRpb25zLTQiOlsiSml0dGVyIl0sImFudGloaXQ6ZmFrZW9wdGlvbnMtNSI6WyJKaXR0ZXIiXSwiYW50aWhpdDpmYWtlb3B0aW9ucy02IjpbIkppdHRlciJdLCJhbnRpaGl0OmZha2V0eXBlLTEiOiJKaXR0ZXIiLCJhbnRpaGl0OmZha2V0eXBlLTIiOiJKaXR0ZXIiLCJhbnRpaGl0OmZha2V0eXBlLTMiOiJKaXR0ZXIiLCJhbnRpaGl0OmZha2V0eXBlLTQiOiJTdGF0aWMiLCJhbnRpaGl0OmZha2V0eXBlLTUiOiJKaXR0ZXIiLCJhbnRpaGl0OmZha2V0eXBlLTYiOiJKaXR0ZXIiLCJhbnRpaGl0OmxhZ2NvbXAiOlsiRm9yY2UgRGVmZW5zaXZlIl0sImFudGloaXQ6bGF0ZW5jeSI6dHJ1ZSwiYW50aWhpdDpsZWZ0bGltaXQtMSI6NTUuMCwiYW50aWhpdDpsZWZ0bGltaXQtMiI6NDEuMCwiYW50aWhpdDpsZWZ0bGltaXQtMyI6NTguMCwiYW50aWhpdDpsZWZ0bGltaXQtNCI6NDUuMCwiYW50aWhpdDpsZWZ0bGltaXQtNSI6NDguMCwiYW50aWhpdDpsZWZ0bGltaXQtNiI6NDUuMCwiYW50aWhpdDptb2RpZmRlZy0xIjo1NC4wLCJhbnRpaGl0Om1vZGlmZGVnLTIiOjU0LjAsImFudGloaXQ6bW9kaWZkZWctMyI6NTQuMCwiYW50aWhpdDptb2RpZmRlZy00Ijo1NC4wLCJhbnRpaGl0Om1vZGlmZGVnLTUiOjU0LjAsImFudGloaXQ6bW9kaWZkZWctNiI6NTQuMCwiYW50aWhpdDpvdmVycmlkZSI6dHJ1ZSwiYW50aWhpdDpyaWdodGxpbWl0LTEiOjQ3LjAsImFudGloaXQ6cmlnaHRsaW1pdC0yIjoyNS4wLCJhbnRpaGl0OnJpZ2h0bGltaXQtMyI6NDguMCwiYW50aWhpdDpyaWdodGxpbWl0LTQiOjI2LjAsImFudGloaXQ6cmlnaHRsaW1pdC01IjozNS4wLCJhbnRpaGl0OnJpZ2h0bGltaXQtNiI6NTEuMCwiYW50aWhpdDp5YXdhZGRsZWZ0LTEiOjEyLjAsImFudGloaXQ6eWF3YWRkbGVmdC0yIjoxMi4wLCJhbnRpaGl0Onlhd2FkZGxlZnQtMyI6MTIuMCwiYW50aWhpdDp5YXdhZGRsZWZ0LTQiOjEyLjAsImFudGloaXQ6eWF3YWRkbGVmdC01IjoxMi4wLCJhbnRpaGl0Onlhd2FkZGxlZnQtNiI6MTIuMCwiYW50aWhpdDp5YXdhZGRyaWdodC0xIjotMTIuMCwiYW50aWhpdDp5YXdhZGRyaWdodC0yIjotMTIuMCwiYW50aWhpdDp5YXdhZGRyaWdodC0zIjotMTIuMCwiYW50aWhpdDp5YXdhZGRyaWdodC00IjotMTIuMCwiYW50aWhpdDp5YXdhZGRyaWdodC01IjotMTIuMCwiYW50aWhpdDp5YXdhZGRyaWdodC02IjotMTIuMCwiYW50aWhpdDp5YXdtb2RpZi0xIjoiNS1XYXkiLCJhbnRpaGl0Onlhd21vZGlmLTIiOiI1LVdheSIsImFudGloaXQ6eWF3bW9kaWYtMyI6IjUtV2F5IiwiYW50aWhpdDp5YXdtb2RpZi00IjoiNS1XYXkiLCJhbnRpaGl0Onlhd21vZGlmLTUiOiI1LVdheSIsImFudGloaXQ6eWF3bW9kaWYtNiI6IjUtV2F5IiwibWlzYzphc3BlY3RyYXRpbyI6MC4wLCJtaXNjOmJyZWFrZXJfaml0dGVyIjp0cnVlLCJtaXNjOmNsYW50YWciOnRydWUsIm1pc2M6Y3VzdG9tX3Njb3BlIjp0cnVlLCJtaXNjOmN1c3RvbV9zY29wZV9jb2xvciI6WzE0MC4wLDgwLjAsODAuMCwyNTUuMF0sIm1pc2M6Y3VzdG9tX3Njb3BlX2dhcCI6NzUuMCwibWlzYzpjdXN0b21fc2NvcGVfaW52ZXJ0IjpmYWxzZSwibWlzYzpjdXN0b21fc2NvcGVfc2l6ZSI6MTcwLjAsIm1pc2M6Y3VzdG9tX3Njb3BlX3QiOnRydWUsIm1pc2M6ZGVidWdwYW5lbCI6dHJ1ZSwibWlzYzpkZWJ1Z3BhbmVsX2NvbG9yIjpbMTQwLjAsODAuMCw4MC4wLDI1NS4wXSwibWlzYzpmYXN0bGFkZGVyIjp0cnVlLCJtaXNjOmdhbWVzZW5zZV9pbmQiOnRydWUsIm1pc2M6aW5kaWNhdG9ycyI6WyJTY29wZSIsIlZlbG9jaXR5IFdhcm5pbmciLCJFdmVudCBMb2dzIl0sIm1pc2M6aW5kaWNhdG9yc19zdHlsZSI6IlRoZW1lZCIsIm1pc2M6bG9nc190b19ldmVudCI6WyJIaXQiLCJIdXJ0IiwiTWlzcyJdLCJtaXNjOm1hbnVhbGFycm93cyI6dHJ1ZSwibWlzYzptaW5kYW1hZ2UiOnRydWUsIm1pc2M6bm9kYW1hZ2UiOnRydWUsIm1pc2M6dGhlbWVfY29sb3IxIjpbMjAxLjAsNTMuMCw1My4wLDI1NS4wXSwibWlzYzp0aGVtZV9jb2xvcjIiOlswLjAsMC4wLDAuMCwyNTUuMF0sIm1pc2M6dHJhc2h0YWxrIjp0cnVlLCJtaXNjOnZpZXdtb2RlbCI6ZmFsc2UsIm1pc2M6dmlld21vZGVsX2ZvdiI6NjguMCwibWlzYzp2aWV3bW9kZWxfeCI6Mi4wLCJtaXNjOnZpZXdtb2RlbF95IjowLjAsIm1pc2M6dmlld21vZGVsX3oiOi0xLjAsIm1pc2M6d2lkZ2V0cyI6WyJXYXRlcm1hcmsiLCJBY3RpdmUgQmluZGluZ3MiLCJTcGVjdGF0b3JzIl0sIm1pc2M6d2lkZ2V0c19ncmFkaWVudCI6Ikhvcml6b250YWwiLCJtaXNjOndpZGdldHNfb3V0bGluZSI6dHJ1ZSwibWlzYzp3aWRnZXRzX3N0eWxlIjoiUm91bmRlZCJ9"
cfg_system.ui_refs = {}
cfg_system.new_item = function(name, ref, is_color)
    if not name or not ref then
        error("cfg system args", 2)
        return
    end

    cfg_system.ui_refs[name] = {
        ref = ref,
        is_color = is_color
    }

    return ref
end
cfg_system.get_clipboard = function()
    local clipboard_text_length = util.ffi_handler.get_clipboard_text_length(util.ffi_handler.VGUI_System)

    if (clipboard_text_length > 0) then
        local buffer = ffi.new("char[?]", clipboard_text_length)

        util.ffi_handler.get_clipboard_text(util.ffi_handler.VGUI_System, 0, buffer, clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length))
        return ffi.string(buffer, clipboard_text_length - 1)
    end
end
cfg_system.set_clipboard = function(text)
    util.ffi_handler.set_clipboard_text(util.ffi_handler.VGUI_System, text, #text)
end
cfg_system.import = function(config)
	local clean_config = string.match(config, "[%w%+%/]+%=*")
    local success, config_data = pcall(json.parse, base64.decode(clean_config))

    if success then
        for key, value in pairs(config_data) do
            local ui_item = cfg_system.ui_refs[key]
            if ui_item then
                ui_item = ui_item.ref
              
                ui_item:set(ui_item:type()  == "color_picker" and color(unpack(value)) or (value == "56575912 clear" and {} or value))
            end
        end
		table.insert(functions.hitlogs.data, 1, {
		{
			{ "Successfully imported config from clipboard", color(0, 255, 0, 255) }
		},
		event_time = globals.realtime,
		alpha = 0, position = 0})
    else
		table.insert(functions.hitlogs.data, 1, {
		{
			{ "Failed to import config from clipboard", color(255, 0, 0, 255) }
		},
		event_time = globals.realtime,
		alpha = 0, position = 0})
	end
end
cfg_system.export = function()
	local config_data = {}

    for key, value in pairs(cfg_system.ui_refs) do
        local ui_item = value.ref
        local value = ui_item:get()

        if type(value) == "table" then
            if #value == 0 then
                value = "56575912 clear"
            end
        end
        config_data[key] = ui_item:type()  == "color_picker" and {value.r, value.g, value.b, value.a} or value
    end
  
    cfg_system.set_clipboard(base64.encode(json.stringify(config_data)))
	table.insert(functions.hitlogs.data, 1, {
	{
		{ "Successfully exported config to clipboard", color(0, 255, 0, 255) }
	},
	event_time = globals.realtime,
	alpha = 0, position = 0})
end

local refs = {
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
	pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    anknife = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    yaw_mod = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    yaw_mod_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    bodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    fs_desync = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    fsyawmod = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    fsbody = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    os_aa = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    backtrack = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    leg_movement = ui.find('Aimbot','Anti Aim',"Misc","Leg Movement"),
    fakelagl = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    fakelagr = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"),
	lagoption = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
	dtfl = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"),
	hsoptions = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
	scope = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
	hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
}

function functions.gradient_sidebar()
	local anim = gradient.text_animate("RekwieN.tech", -3, config.theme)
	ui.sidebar(anim:get_animated_text(), ui.get_icon("check"))
	anim:animate()
end

--House
gui.info = ui.create(ui.get_icon("house"), "Information")
gui.info:label("Welcome, "..common.get_username())
gui.info:label("That script is powered RekwieN.tech")
gui.info:label("If you find a bug or have a question, please contact - splasher1337 (Answers in English or Russian)")   
config.info.discord = gui.info:button(ui.get_icon("discord").."  Join our discord community  ", function()panorama.SteamOverlayAPI.OpenExternalBrowserURL("")end, true)
config.info.get_role = gui.info:button("\aFFFFFFFF"..ui.get_icon("discord").."        Get Role       ", function() --[[removed]] end)
gui.config = ui.create(ui.get_icon("house"), "Configurations")
gui.config:label(ui.get_icon("files").."  Configuration Manager")
config.info.default_cfg = gui.config:button(ui.get_icon("download").."  Load default config  ", nil, true)
config.info.default_cfg:set_callback(function() cfg_system.import(cfg_system.default_cfg) end)
config.info.import_cfg = gui.config:button(ui.get_icon("file-import").."   Import config  ")
config.info.import_cfg:set_callback(function() cfg_system.import(cfg_system.get_clipboard()) end)
config.info.export_cfg = gui.config:button(ui.get_icon("file-export").."   Export config  ")
config.info.export_cfg:set_callback(function() cfg_system.export() end)
config.info.pensil = gui.config:texture(render.load_image(network.get("https://cdn.discordapp.com/attachments/1004747777265385533/1132346588346462268/goofy-goofy-ahh.gif")))

--Anti-hit
gui.ah_general = ui.create(ui.get_icon("user-shield"), "General")
config.antihit.breakers = cfg_system.new_item("antihit:breakers", gui.ah_general:selectable("\aC9D178FFAnim. breakers", {'Follow Direction', 'Static Legs In Air', 'Pitch 0 on Land', 'Fucker'}))
config.antihit.breakers:tooltip("This function may be reason manipulate unstable to work of the cheat.")
local breaker_settings = config.antihit.breakers:create()
config.antihit.breaker_jitter = cfg_system.new_item("misc:breaker_jitter", breaker_settings:switch("Jitter", false))
config.antihit.latency = cfg_system.new_item("antihit:latency", gui.ah_general:switch("Anti-Fake Latency", false))
config.antihit.backstab = cfg_system.new_item("antihit:backstab", gui.ah_general:switch("Avoid Backstab", false))
config.antihit.discarge = cfg_system.new_item("antihit:discarge", gui.ah_general:switch("Automatic Teleport in Air", false))
config.antihit.lagcomp = cfg_system.new_item("antihit:lagcomp", gui.ah_general:selectable("Break LC", {"Force Defensive", "Hide Shots"}))
config.antihit.abf = cfg_system.new_item("antihit:abf", gui.ah_general:switch("Anti-Bruteforce Angle Inverter", false))
local abf_settings = config.antihit.abf:create()
config.antihit.abfdistance = cfg_system.new_item("antihit:abfdistance", abf_settings:slider("Distance", 1, 250, 125))
config.antihit.defensive = cfg_system.new_item("antihit:defensive", gui.ah_general:selectable("Defensive Mimic", {"Yaw", "Pitch"}))
local defensive_settings = config.antihit.defensive:create()
config.antihit.defensive_yaw_left = cfg_system.new_item("antihit:defensive_yaw_left", defensive_settings:slider("Yaw Left", -89, 89, 0))
config.antihit.defensive_yaw_right = cfg_system.new_item("antihit:defensive_yaw_right", defensive_settings:slider("Yaw Right", -89, 89, 0))
config.antihit.defensive_yaw_value = cfg_system.new_item("antihit:defensive_yaw_value", defensive_settings:slider("Yaw Value", -89, 89, 0))
config.antihit.defensive_pitch_left = cfg_system.new_item("antihit:defensive_pitch_left", defensive_settings:slider("Pitch Left", -89, 89, 0))
config.antihit.defensive_pitch_right = cfg_system.new_item("antihit:defensive_pitch_right", defensive_settings:slider("Pitch Right", -89, 89, 0))
config.antihit.defensive_pitch_value = cfg_system.new_item("antihit:defensive_pitch_value", defensive_settings:slider("Pitch Value", -89, 89, 0))

gui.ah_settings = ui.create(ui.get_icon("user-shield"), "Settings")
config.antihit.override = cfg_system.new_item("antihit:enable", gui.ah_settings:switch("Custom Settings", false))
config.antihit.manual = gui.ah_settings:combo("Manual Yaw Base", {"Disabled", "Left", "Right", "Freestanding"})
local manual_settings = config.antihit.manual:create()
config.antihit.manual_disablers = cfg_system.new_item("antihit:override", manual_settings:switch("Disable Yaw Modifiers", false))
config.antihit.condition = gui.ah_settings:combo("Condition", {"Standing", "Moving", "Slowwalk", "Ducking", "Air", "Air-ducking"})
gui.explanation = ui.create(ui.get_icon("user-shield"), "Explanation")
gui.explanation:label("Welcome to the RekwieN.tech anti-aim system. Here you can use different functionality that is not in the cheat, as well as set up anti-aims for any movement.")

gui.ah_condition = ui.create(ui.get_icon("user-shield"), "Fake Angles")
for i=1, 6 do
	config.antihit.condition_settings[i] = {
        cfg_system.new_item("antihit:yawaddleft-"..i, gui.ah_condition:slider(functions.antihit.cond_menu[i].." Yaw Add Left", -200, 200, 0)),
        cfg_system.new_item("antihit:yawaddright-"..i, gui.ah_condition:slider(functions.antihit.cond_menu[i].." Yaw Add Right", -200, 200, 0)),
        cfg_system.new_item("antihit:yawmodif-"..i, gui.ah_condition:combo(functions.antihit.cond_menu[i].." Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"})),
        cfg_system.new_item("antihit:modifdeg-"..i, gui.ah_condition:slider(functions.antihit.cond_menu[i].." Modifier Degree", -200, 200, 0)),
        cfg_system.new_item("antihit:fakeoptions-"..i, gui.ah_condition:selectable(functions.antihit.cond_menu[i].." Fake Options", {"Avoid Overlap", "Jitter", "Randomize Jitter"})),
        cfg_system.new_item("antihit:desyncstate-"..i, gui.ah_condition:combo(functions.antihit.cond_menu[i].." Freestanding Mode", {"Off", "Peek Fake", "Peek Real"})),
        cfg_system.new_item("antihit:bodyyaw-"..i, gui.ah_condition:switch(functions.antihit.cond_menu[i].." Body Yaw", false)),
		cfg_system.new_item("antihit:faketype-"..i, gui.ah_condition:combo(functions.antihit.cond_menu[i].." Body Yaw Type", {"Static", "Jitter"})),
        cfg_system.new_item("antihit:leftlimit-"..i, gui.ah_condition:slider(functions.antihit.cond_menu[i].." Body Yaw Left", 0, 60, 60)),
        cfg_system.new_item("antihit:rightlimit-"..i, gui.ah_condition:slider(functions.antihit.cond_menu[i].." Body Yaw Right", 0, 60, 60)),
		cfg_system.new_item("antihit:bodyyawleft-"..i, gui.ah_condition:slider(functions.antihit.cond_menu[i].." Value Left", 0, 60, 60)),
        cfg_system.new_item("antihit:bodyyawright-"..i, gui.ah_condition:slider(functions.antihit.cond_menu[i].." Value Right", 0, 60, 60)),
	}
end

--Miscellaneous
gui.visuals = ui.create(ui.get_icon("gear"), "Visuals")
config.misc.theme_color1 = cfg_system.new_item("misc:theme_color1", gui.visuals:color_picker("Theme Color", color(255, 0, 0, 255)))
config.misc.theme_color2 = cfg_system.new_item("misc:theme_color2", gui.visuals:color_picker("Second Color", color(50, 0, 0, 255)))
config.misc.widgets = cfg_system.new_item("misc:widgets", gui.visuals:selectable("Widgets", {"Watermark", "Active Bindings", "Spectators"}))
local widgets_settings = config.misc.widgets:create()
config.misc.widgets_style = cfg_system.new_item("misc:widgets_style", widgets_settings:combo("Theme", {"Metamod", "Rounded"}))
config.misc.widgets_gradient = cfg_system.new_item("misc:widgets_gradient", widgets_settings:combo("Gradient", {"None", "Horizontal", "Vertical"}))
config.misc.widgets_outline = cfg_system.new_item("misc:widgets_outline", widgets_settings:switch("Outline", false))
config.misc.custom_username = widgets_settings:input("Custom Username", common.get_username())
config.misc.indicators = cfg_system.new_item("misc:indicators", gui.visuals:selectable("Indicators", {"Scope", "Velocity Warning", "Event Logs"}))
local indicators_settings = config.misc.indicators:create()
config.misc.indicators_style = cfg_system.new_item("misc:indicators_style", indicators_settings:combo("Style", {"Themed", "Compact"}))
config.misc.mindamage = cfg_system.new_item("misc:mindamage", indicators_settings:switch("Show Min. Damage", false))
config.misc.manualarrows = cfg_system.new_item("misc:manualarrows", indicators_settings:switch("Manual Arrows", false))
config.misc.logs_to_event = cfg_system.new_item("misc:logs_to_event", indicators_settings:selectable("Events", {"Hit", "Hurt", "Miss", "Anti-Bruteforce"}))
config.misc.gamesense_ind = cfg_system.new_item("misc:gamesense_ind", indicators_settings:switch("Gamesense Indicators", false))
config.misc.debugpanel = cfg_system.new_item("misc:debugpanel", gui.visuals:switch("Debug Panel", false))
config.misc.debugpanel_color = cfg_system.new_item("misc:debugpanel_color", config.misc.debugpanel:color_picker(color(140, 80, 80, 255)))
config.misc.custom_scope = cfg_system.new_item("misc:custom_scope", gui.visuals:switch("Custom Scope", false))
local customscope_settings = config.misc.custom_scope:create()
config.misc.custom_scope_color = cfg_system.new_item("misc:custom_scope_color", customscope_settings:color_picker("Color", color(255, 255, 255, 255)))
config.misc.custom_scope_invert = cfg_system.new_item("misc:custom_scope_invert", customscope_settings:switch("Invert", false))
config.misc.custom_scope_t = cfg_system.new_item("misc:custom_scope_t", customscope_settings:switch("T-Scope", false))
config.misc.custom_scope_gap = cfg_system.new_item("misc:custom_scope_gap", customscope_settings:slider("Gap", 0, 500, 75))
config.misc.custom_scope_size = cfg_system.new_item("misc:custom_scope_size", customscope_settings:slider("Size", 0, 500, 170))
config.misc.shared_type = cfg_system.new_item("misc:shared_type", gui.visuals:combo("Type", {"Text", "Icons", "Both"}))

gui.misc = ui.create(ui.get_icon("gear"), "Miscellaneous")
config.misc.clantag = cfg_system.new_item("misc:clantag", gui.misc:switch("Clan Tag", false))
config.misc.trashtalk = cfg_system.new_item("misc:trashtalk", gui.misc:switch("Trash Talk", false))
config.misc.aspectratio = cfg_system.new_item("misc:aspectratio", gui.misc:slider("Aspect Ratio", 0, 200, 0))
config.misc.viewmodel = cfg_system.new_item("misc:viewmodel", gui.misc:switch("Force Viewmodel", false))
local viewmodel_settings = config.misc.viewmodel:create()
config.misc.viewmodel_fov = cfg_system.new_item("misc:viewmodel_fov", viewmodel_settings:slider("Viewmodel Fov", -100, 100, 68))
config.misc.viewmodel_x = cfg_system.new_item("misc:viewmodel_x", viewmodel_settings:slider("Viewmodel X", -10, 10, 2.5))
config.misc.viewmodel_y = cfg_system.new_item("misc:viewmodel_y", viewmodel_settings:slider("Viewmodel Y", -10, 10, 0))
config.misc.viewmodel_z = cfg_system.new_item("misc:viewmodel_z", viewmodel_settings:slider("Viewmodel Z", -10, 10, -1.5))
config.misc.nodamage = cfg_system.new_item("misc:nodamage", gui.misc:switch("No Fall Damage", false))
config.misc.fastladder = cfg_system.new_item("misc:fastladder", gui.misc:switch("Fast Ladder", false))

local draggables_elements = {
	key_x = gui.misc:slider("keybindings_x", 0, gui.screen.x, 100),
	key_y = gui.misc:slider("keybindings_y", 0, gui.screen.y, 200),
	spec_x = gui.misc:slider("spectators_x", 0, gui.screen.x, 200),
	spec_y = gui.misc:slider("spectators_y", 0, gui.screen.y, 200),
	vel_x = gui.misc:slider("velocity_x", 0, gui.screen.x, gui.screen.x/2),
	vel_y = gui.misc:slider("velocity_y", 0, gui.screen.y, 300),
	logs_x = gui.misc:slider("logs_x", 0, gui.screen.x, gui.screen.x/2),
	logs_y = gui.misc:slider("logs_y", 0, gui.screen.y, 160),
	gsind_x = gui.misc:slider("gsind_x", 0, gui.screen.x, 15),
	gsind_y = gui.misc:slider("gsind_y", 0, gui.screen.y, 500),
}
draggables_elements.key_x:visibility(false); draggables_elements.key_y:visibility(false)
draggables_elements.vel_x:visibility(false); draggables_elements.vel_y:visibility(false)
draggables_elements.spec_x:visibility(false); draggables_elements.spec_y:visibility(false)
draggables_elements.gsind_x:visibility(false); draggables_elements.gsind_y:visibility(false)
draggables_elements.logs_x:visibility(false); draggables_elements.logs_y:visibility(false)

function functions.menu_manager()
	functions.watermark.username = config.misc.custom_username:get()
	config.misc.custom_username:visibility(config.misc.widgets:get(1))
	config.theme_gradient = config.misc.widgets_gradient:get() ~= 1
	config.theme = {config.misc.theme_color1:get(), config.misc.theme_color2:get()}
	config.antihit.breaker_jitter:visibility(config.antihit.breakers:get(1) or config.antihit.breakers:get(2))
    config.antihit.condition:visibility(config.antihit.override:get())
    config.antihit.manual:visibility(config.antihit.override:get())
    config.antihit.abfdistance:visibility(config.antihit.abf:get())
	config.misc.theme_color2:visibility(config.misc.widgets_gradient:get() ~= "None")
    config.misc.logs_to_event:visibility(config.misc.indicators:get(3))
    config.misc.manualarrows:visibility(config.misc.indicators:get(1))
	config.misc.mindamage:visibility(config.misc.indicators:get(1))
    config.misc.custom_scope_color:visibility(config.misc.custom_scope:get())
    config.misc.custom_scope_invert:visibility(config.misc.custom_scope:get())
    config.misc.custom_scope_gap:visibility(config.misc.custom_scope:get())
    config.misc.custom_scope_size:visibility(config.misc.custom_scope:get())
	config.misc.custom_scope_t:visibility(config.misc.custom_scope:get())
    config.misc.debugpanel_color:visibility(config.misc.debugpanel:get())
    config.misc.viewmodel_fov:visibility(config.misc.viewmodel:get())
    config.misc.viewmodel_x:visibility(config.misc.viewmodel:get())
    config.misc.viewmodel_y:visibility(config.misc.viewmodel:get())
    config.misc.viewmodel_z:visibility(config.misc.viewmodel:get())
    for i=1, 6 do
		for dat=1, 7 do
			config.antihit.condition_settings[i][dat]:visibility(config.antihit.override:get() and config.antihit.condition:get() == functions.antihit.conditions[i])
		end
		for dat=8, 12 do
			config.antihit.condition_settings[i][dat]:visibility(config.antihit.override:get() and config.antihit.condition:get() == functions.antihit.conditions[i] and config.antihit.condition_settings[i][7]:get())
		end
    end
end

function updateCSA_func(thisptr, edx)
    util.hooked_function(thisptr, edx)
    if entity.get_local_player() == nil or ffi.cast('uintptr_t**', thisptr) == nil then 
		return end
	
	local tick = globals.client_tick % 4 > 2

    if config.antihit.breakers:get(2) then
		if config.antihit.breaker_jitter:get() then
			entity.get_local_player().m_flPoseParameter[6] = tick and 1 or 0
		else
			entity.get_local_player().m_flPoseParameter[6] = 1
		end
    end

    if config.antihit.breakers:get(3) then
        entity.get_local_player().m_flPoseParameter[12] = 1
    end

    if config.antihit.breakers:get(1) then
		if config.antihit.breaker_jitter:get() then
			if tick then entity.get_local_player().m_flPoseParameter[7] = 1 end
		else
			entity.get_local_player().m_flPoseParameter[7] = 1
		end
		refs.leg_movement:set("Walking")
    end

    if config.antihit.breakers:get(3) then
        if bit.band(entity.get_local_player().m_fFlags, 1) == 1 then
            functions.antihit.breaker.tick = functions.antihit.breaker.tick + 1
        else
            functions.antihit.breaker.tick = 0
            functions.antihit.breaker.time = globals.curtime  + 1
        end
        if bit.band(entity.get_local_player().m_fFlags, 1) ~= 0 and functions.antihit.breaker.tick > 1 and functions.antihit.breaker.time > globals.curtime then
            entity.get_local_player().m_flPoseParameter[12] = 0.5
        end
    end
end

function functions.antihit.breaker_hook()
	local player = entity.get_local_player()
	if not player or not player:is_alive() then 
		return end
		
	local address = util.get_entity_address(player:get_index())
    if not address or util.hooked_function then
		return end
		
	util.hooked_function = vmt_hook.new(address).hook("void(__fastcall*)(void*, void*)", updateCSA_func, 224)
end

function functions.antihit.createmove(cmd)
	local player = entity.get_local_player()
	if not player or not player:is_alive() then 
		return end
		
	if not config.antihit.override:get() then 
		return end
		
	local side = (player.m_flPoseParameter[11] * 120 - 60) < 0 and true or false
	if config.antihit.manual:get() == "Disabled" then refs.yaw_base:set("At Target") else refs.yaw_base:set("Local View") end
	if not config.antihit.override:get() then 
		refs.pitch:set("Disabled")
	else
        local state = config.antihit.condition_settings[util.get_current_condition()] or false
        if not state then
			return end
			
		if not config.antihit.manual_disablers:get() then
			if cmd.choked_commands == 0 then
				refs.yaw_offset:set((side == false and state[1]:get() or state[2]:get()) + (config.antihit.manual:get() == "Right" and 90 or 0) + (config.antihit.manual:get() == "Left" and -90 or 0))
			end
		else
			refs.yaw_offset:set((config.antihit.manual:get() == "Right" and 90 or 0) + (config.antihit.manual:get() == "Left" and -90 or 0))
		end
		
		refs.yaw:set("Backward")
		if config.antihit.manual:get() == "Disabled" then
			refs.yaw_mod:set(state[3]:get())
			refs.left_limit:set(state[8]:get() ~= 'Static' and (globals.tickcount % 4 > 1 and state[11]:get() or state[9]:get()) or state[9]:get())
			refs.right_limit:set(state[8]:get() ~= 'Static' and (globals.tickcount % 4 > 1 and state[12]:get() or state[10]:get()) or state[10]:get())
			refs.options:set(state[5]:get())
		elseif config.antihit.manual_disablers:get() then
			refs.yaw_mod:set("Disabled")
			refs.left_limit:set(state[9]:get())
			refs.right_limit:set(state[10]:get())
			refs.options:set("")
		else
			refs.yaw_mod:set(state[3]:get())
			refs.left_limit:set(state[8]:get() ~= 'Static' and (globals.tickcount % 4 > 1 and state[11]:get() or state[9]:get()) or state[9]:get())
			refs.right_limit:set(state[8]:get() ~= 'Static' and (globals.tickcount % 4 > 1 and state[12]:get() or state[10]:get()) or state[10]:get())
			refs.options:set(state[5]:get())
		end
        refs.yaw_mod_offset:set(state[4]:get())
        refs.bodyyaw:set(state[7]:get())
        refs.fs_desync:set(state[6]:get())
    end
end

function functions.antihit.exploits()
	local player = entity.get_local_player()
    if not player then 
		return end
		
	local side = player.m_flPoseParameter[11] * 120 - 60 < 0 and true or false -- defensive a-a
    if config.antihit.defensive:get(2) then
        refs.hidden:set(true)
        rage.antiaim:override_hidden_pitch(side and math.random(config.antihit.defensive_pitch_left:get(), config.antihit.defensive_pitch_value:get()) or math.random(config.antihit.defensive_pitch_right:get(), config.antihit.defensive_pitch_value:get()))
	end
		
	if config.antihit.defensive:get(1) then
		refs.hidden:set(true)
		rage.antiaim:override_hidden_yaw_offset(side and math.random(config.antihit.defensive_yaw_left:get(), config.antihit.defensive_yaw_value:get()) or math.random(config.antihit.defensive_yaw_right:get(), config.antihit.defensive_yaw_value:get()))
	end
		
	if not config.antihit.defensive:get(2) and not config.antihit.defensive:get(1) then
		refs.hidden:set(false)
	end
		
    if config.antihit.lagcomp:get(1) then --lagcomp breaker
		refs.lagoption:override("Always On"); refs.dtfl:override(1)
    end
    if config.antihit.lagcomp:get(2) then
        refs.hsoptions:override("Break LC")
    end
    if config.antihit.lagcomp:get(1) and config.antihit.lagcomp:get(2) then
        refs.lagoption:override("Always On"); refs.dtfl:override(1); refs.hsoptions:override("Break LC")
    end
	
	if config.antihit.discarge:get() then --auto dt discarge
		for _, enemy in ipairs(entity.get_players(true, false)) do
			if not enemy and not (util.get_current_condition() > 4) then
				return end
			
			if entity.get_threat(true) ~= nil and (util.get_current_condition() > 4) then
				rage.exploit:force_teleport()
			end
		end
	end

	if config.antihit.manual:get() ~= "Freestanding" then --freestanding
		refs.fs:override(false)
	else
		if (util.get_current_condition() > 4) then
			refs.fs:override(false)
		else
			refs.fs:override(true)
		end
	end

	if config.antihit.breakers:get(4) then --leg fucker
		local tick = globals.client_tick % 4 > 2
		refs.leg_movement:set(tick and "Sliding" or "Walking")
	end

	if config.antihit.latency:get() then --anti fakelatency
		refs.fakelagl:override(14)
		refs.fakelagr:override(20)
	end

	if config.antihit.backstab:get() then --avoid backstab
		refs.anknife:override(true)
	end
end

function functions.antihit.abf_inverter(e)
	local player = entity.get_local_player()
    if not player then 
		return end
		
	local tick = globals.client_tick % 6 > 4
	if config.antihit.abf:get() then
		local user = entity.get(e.userid, true) --user:get_name()
		distance = math.floor(player:get_origin():dist(vector(e.x,e.y,e.z)))
		if distance < config.antihit.abfdistance:get() and player:is_alive() and user:is_enemy() then
			refs.inverter:set(tick and true or false)
			if config.misc.logs_to_event:get(4) then
				if (config.misc.indicators_style:get() == "Themed") then
					table.insert(functions.hitlogs.data, 1, {
						{
							{ "Anti-Bruteforce side was switched due to enemy shot", 
							color(255, 255, 255, 255) }
						},
					event_time = globals.realtime,
					alpha = 0, position = 0})
				else
					table.insert(functions.hitlogs.data, 1, {
					{
						{ "Anti-Bruteforce side was switched due to enemy shot", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) }
					},
					event_time = globals.realtime,
					alpha = 0, position = 0})
				end
			end
		end
	end
end

function functions.misc.solus_render()
	if (config.misc.widgets:get(1)) then
		local time = util.get_time()
    	if time.hour < 10 then time.hour = '0' .. time.hour end
    	if time.minute < 10 then time.minute = '0' .. time.minute end
    	if time.second < 10 then time.second = '0' .. time.second end

    	local var = gui.screen.x - 12
    	local x, y = var - 18, 7
    	local h = 18 

		local text = " / "..functions.watermark.username.." • "..time.hour..":"..time.minute
		
		if globals.is_in_game then
			local net = utils.net_channel()
			local latency = net.avg_latency[1]
        	if latency == nil then latency = 0 
			else latency = math.floor(latency * 1000) end
        
			text = " / "..functions.watermark.username.." • "..latency.."ms • "..time.hour..":"..time.minute
		end
	
		local text_size = render.measure_text(gui.fonts.arial, nil, "RekwieN.tech"..text)
		var = gui.screen.x - 12 - text_size.x
		x = var - 18

		local anim = gradient.text_animate("RekwieN", -1, {color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255)})
		local namelua = "RekwieN"
		if (config.misc.widgets_gradient:get() ~= "None") then
			namelua = anim:get_animated_text()
		end
		local text_table = {
			{ namelua, color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 255)},
			{ ".tech", color(155, 155, 155, 255)},
			{ text, color(255, 255, 255, 255) },
		}
		anim:animate()
		
		draw.custom_rectangle(x - 5, y + 3, x + 20 + text_size.x, y + h + 3, config.misc.widgets_style:get(), config.misc.widgets_outline:get(), config.misc.widgets_gradient:get(), 1)

		if config.misc.widgets_style:get() ~= "Rounded" then
			draw.string_multicolored(text_table, x + 14, y + 5, gui.fonts.arial, false, false, 1)
		else
			draw.string_multicolored(text_table, x + 12, y + 6, gui.fonts.arial, false, false, 1)
		end
	end

	if (config.misc.widgets:get(2)) then
		local binds = ui.get_binds()
		local state = false
    	local alpha = 0
	
		local x, y = draggables_elements.key_x:get(), draggables_elements.key_y:get()
		local h = 18 
		local y_add = 0
    	local maximum_offset = 28

    	for i = 1, #binds do
        	local name = binds[i].name
        	local text_width = render.measure_text(gui.fonts.arial, nil, name).x - 30

        	if binds[i].active then
            	state = true
            	maximum_offset = maximum_offset < text_width and text_width or maximum_offset
        	end 
    	end

    	local w = 90 + maximum_offset

		alpha = animatables.create(9, state or ui.get_alpha() == 1, "keybindings_alpha")
    	animations_table.keybinds_width = tween.new(0.25, animations_data, {keybinds_width = w}, "outCubic"); w = animations_data.keybinds_width
	
		draw.custom_rectangle(x, y + 3, x + 10 + (w - 10), y + h + 3, config.misc.widgets_style:get(), config.misc.widgets_outline:get(), config.misc.widgets_gradient:get(), alpha)

		render.text(gui.fonts.arial, vector(x + w/2 - render.measure_text(gui.fonts.arial, nil, "Keybinds").x/2 + 1, y + 6), color(0, 0, 0, alpha * 255), nil, "Keybinds")
		render.text(gui.fonts.arial, vector(x + w/2 - render.measure_text(gui.fonts.arial, nil, "Keybinds").x/2, y + 5), color(255, 255, 255, alpha * 255), nil, "Keybinds")

    	for i=1, #binds do
			local alpha = animatables.create(9, binds[i].active, "keybindings_"..binds[i].name)
        	local get_mode = binds[i].mode == 1 and "holding" or (binds[i].mode == 2 and "toggled") or "?"

        	local get_value = binds[i].value
			if (config.misc.widgets_style:get() == "Metamod") then
				if binds[i].name == "Min. Damage" or binds[i].name == "Hit Chance" or binds[i].name == "Manual Yaw Base" then
					render.text(gui.fonts.arial, vector(x + 3 - 1, y + 26 + y_add), color(0, 0, 0, alpha*255), nil, binds[i].name)
					render.text(gui.fonts.arial, vector(x - 1 + w - render.measure_text(gui.fonts.arial, nil, get_value).x , y + 26 + y_add), color(0, 0, 0, alpha*255), nil, ""..get_value)
			
					render.text(gui.fonts.arial, vector(x + 2 - 1, y + 25 + y_add), color(255, 255, 255, alpha*255), nil, binds[i].name)
					render.text(gui.fonts.arial, vector(x - 2 + w - render.measure_text(gui.fonts.arial, nil, get_value).x , y + 25 + y_add), color(255, 255, 255, alpha*255), nil, ""..get_value)
				else
					render.text(gui.fonts.arial, vector(x + 3 - 1, y + 26 + y_add), color(0, 0, 0, alpha*255), nil, binds[i].name)
					render.text(gui.fonts.arial, vector(x - 1 + w - render.measure_text(gui.fonts.arial, nil, get_mode).x , y + 26 + y_add), color(0, 0, 0, alpha*255), nil, get_mode)
			
					render.text(gui.fonts.arial, vector(x + 2 - 1, y + 25 + y_add), color(255, 255, 255, alpha*255), nil, binds[i].name)
					render.text(gui.fonts.arial, vector(x - 2 + w - render.measure_text(gui.fonts.arial, nil, get_mode).x , y + 25 + y_add), color(255, 255, 255, alpha*255), nil, get_mode)
				end
			else
				if binds[i].name == "Min. Damage" or binds[i].name == "Hit Chance" or binds[i].name == "Manual Yaw Base" then
					render.rect(vector(x - 5, y + 26 + y_add), vector(x + w, y + 26 + y_add + 15), color(0, 0, 0, 150 * alpha), 5)
					render.text(gui.fonts.arial_s, vector(x + 3 - 4, y + 28 + y_add), color(0, 0, 0, alpha*255), nil, binds[i].name)
					render.text(gui.fonts.arial_s, vector(x - 2 + w - render.measure_text(gui.fonts.arial_s, nil, get_value).x , y + 28 + y_add), color(0, 0, 0, alpha*255), nil, ""..get_value)
			
					render.text(gui.fonts.arial_s, vector(x + 2 - 4, y + 27 + y_add), color(255, 255, 255, alpha*255), nil, binds[i].name)
					render.text(gui.fonts.arial_s, vector(x - 3 + w - render.measure_text(gui.fonts.arial_s, nil, get_value).x , y + 27 + y_add), color(155, 155, 155, alpha*255), nil, ""..get_value)
				else
					render.rect(vector(x - 5, y + 26 + y_add), vector(x + w, y + 26 + y_add + 15), color(0, 0, 0, 150 * alpha), 5)
					render.text(gui.fonts.arial_s, vector(x + 3 - 4, y + 28 + y_add), color(0, 0, 0, alpha*255), nil, binds[i].name)
					render.text(gui.fonts.arial_s, vector(x - 2 + w - render.measure_text(gui.fonts.arial_s, nil, get_mode).x , y + 28 + y_add), color(0, 0, 0, alpha*255), nil, get_mode)
			
					render.text(gui.fonts.arial_s, vector(x + 2 - 4, y + 27 + y_add), color(255, 255, 255, alpha*255), nil, binds[i].name)
					render.text(gui.fonts.arial_s, vector(x - 3 + w - render.measure_text(gui.fonts.arial_s, nil, get_mode).x , y + 27 + y_add), color(155, 155, 155, alpha*255), nil, get_mode)
				end
			end
			
			if (config.misc.widgets_style:get() == "Metamod") then
				y_add = y_add + 15 * alpha
			else
				y_add = y_add + 19 * alpha
			end
    	end
		
		draggables.create(draggables_elements.key_x, draggables_elements.key_y, w, 21, "keybinds", false)
	end
	
	if (config.misc.widgets:get(3)) then
		local spectators = util.get_spectators()
		local state = false
    	local alpha = 0
	
		local x, y = draggables_elements.spec_x:get(), draggables_elements.spec_y:get()
		local h = 18 
		local y_add = 0
    	local maximum_offset = 28

		for k, player in pairs(spectators) do
			local name = player:get_name()
        	local text_width = render.measure_text(gui.fonts.arial, nil, name).x - 30
			state = true
            maximum_offset = maximum_offset < text_width and text_width or maximum_offset
		end

    	local w = 90 + maximum_offset

		alpha = animatables.create(9, state or ui.get_alpha() == 1, "spectators_alpha")
    	animations_table.spectators_width = tween.new(0.25, animations_data, {spectators_width = w}, "outCubic"); w = animations_data.spectators_width
	
		draw.custom_rectangle(x, y + 3, x + 10 + (w - 10), y + h + 3, config.misc.widgets_style:get(), config.misc.widgets_outline:get(), config.misc.widgets_gradient:get(), alpha)

		render.text(gui.fonts.arial, vector(x + w/2 - render.measure_text(gui.fonts.arial, nil, "Spectators").x/2 + 1, y + 6), color(0, 0, 0, alpha * 255), nil, "Spectators")
		render.text(gui.fonts.arial, vector(x + w/2 - render.measure_text(gui.fonts.arial, nil, "Spectators").x/2, y + 5), color(255, 255, 255, alpha * 255), nil, "Spectators")
		
		for k, player in pairs(spectators) do
			local alpha = animatables.create(9, player, "spectating_player_"..k)
			if (config.misc.widgets_style:get() == "Metamod") then
				render.text(gui.fonts.arial, vector(x + 3 - 1, y + 26 + y_add), color(0, 0, 0, alpha*255), nil, player:get_name())
				render.text(gui.fonts.arial, vector(x + 2 - 1, y + 25 + y_add), color(255, 255, 255, alpha*255), nil, player:get_name())
				render.texture(player:get_steam_avatar(), vector(x - 10 + w, y + 25 + y_add), vector(10, 10), 255 * alpha, "f", 0)
			else
				render.rect(vector(x - 5, y + 26 + y_add), vector(x + w, y + 26 + y_add + 15), color(0, 0, 0, 150 * alpha), 5)
				render.text(gui.fonts.arial_s, vector(x + 3 - 4, y + 28 + y_add), color(0, 0, 0, alpha*255), nil, player:get_name())
				render.text(gui.fonts.arial_s, vector(x + 2 - 4, y + 27 + y_add), color(255, 255, 255, alpha*255), nil, player:get_name())
				render.texture(player:get_steam_avatar(), vector(x - 15 + w, y + 28 + y_add), vector(10, 10), 255 * alpha, "f", 10)
			end
			
			if (config.misc.widgets_style:get() == "Metamod") then
				y_add = y_add + 15 * alpha
			else
				y_add = y_add + 19 * alpha
			end
		end
		
		draggables.create(draggables_elements.spec_x, draggables_elements.spec_y, w, 21, "spectators", false)
	end
end

function functions.misc.indicators_render()
	local player = entity.get_local_player()
    if not player then
        return end
		
	if not player:is_alive() then
		return end
		
    if config.misc.indicators:get(1) then
        local binds = ui.get_binds()

        if functions.misc.time + 0.28 < globals.curtime then
            functions.misc.time = globals.curtime
            functions.misc.fake = util.get_desync_delta()
		end

		local x_add = 0
        local y_add = 14
		local damage = false
        local alpha = math.min(math.floor(math.sin((globals.curtime%3) * 4) * 175 + 50), 255)
		local ind_alpha = 0

		if config.misc.custom_scope:get() then
			if config.misc.custom_scope_gap:get() < 75 then
				ind_alpha = animatables.create(9, not player.m_bIsScoped, "indicators_alpha")
			else
				ind_alpha = 1
			end
		else
			ind_alpha = animatables.create(9, not player.m_bIsScoped, "indicators_alpha")
		end
	
        render.text(2, vector(gui.screen.x/2.01, gui.screen.y/2+y_add), color(255,255,255,255*ind_alpha), nil, math.floor(functions.misc.fake).."°")
        y_add = y_add + 9

		local anim = gradient.text_animate("REKWIEN", -1, {color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255)})
		local namelua = "REKWIEN"
		if (config.misc.widgets_gradient:get() ~= "None") then
			namelua = anim:get_animated_text()
		end
		local text_table = {
			{ namelua, color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 255)},
			{ "STABLE", color(155, 155, 155, alpha) },
		}
		anim:animate()
		
		if config.misc.custom_scope:get() then
			if config.misc.custom_scope_gap:get() < 75 then
				x_add = player.m_bIsScoped and 50 or 0
			end
		else
			x_add = player.m_bIsScoped and 50 or 0
		end
		animations_table.indicators_width = tween.new(0.25, animations_data, {indicators_width = x_add}, "outCubic"); x_add = animations_data.indicators_width
		
		draw.string_multicolored(text_table, gui.screen.x/2 + x_add, gui.screen.y/2 + y_add + 2, 2, true, true, 1)
        y_add = y_add + 10

		--render.rect(vector(gui.screen.x/2 - 30, gui.screen.y/2 + 39), vector(gui.screen.x/2 + 30, gui.screen.y/2 + 44), color(0, 0, 0, 255))
		render.gradient(vector(gui.screen.x/2 + 1 + x_add, gui.screen.y/2 + 40), vector(gui.screen.x/2 + (math.abs(functions.misc.fake * 50 / 100) + 1) + x_add, gui.screen.y/2 + 43), color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 255),color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 0), color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 255), color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 0))
        render.gradient(vector(gui.screen.x/2 + 1 + x_add, gui.screen.y/2 + 40), vector(gui.screen.x/2 + (-math.abs(functions.misc.fake * 50 / 100) + 1) + x_add, gui.screen.y/2 + 43), color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 255), color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 0), color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 255), color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 0))
        y_add = y_add + 12

        for i = 1, #binds do
			local bind = binds[i] 
			if bind.name == "Double Tap" then
                render.text(2, vector(gui.screen.x/2 - render.measure_text(2, nil, "DT").x/2 + 2 + x_add, gui.screen.y/2 + y_add), rage.exploit:get() and color(160, 255, 1, 255), nil, "DT")
                y_add = y_add + 9
			end
			
			if bind.name == "Hide Shots" then
				render.text(2, vector(gui.screen.x/2 - render.measure_text(2, nil, "HIDE").x/2 + 2 + x_add, gui.screen.y/2 + y_add), rage.exploit:get() and color(160, 255, 1, 255), nil, "HIDE")
				y_add = y_add + 9
			end
			
			if bind.name == "Min. Damage" then
				if config.misc.mindamage:get() then
					damage = true
					render.text(2, vector(gui.screen.x/2 + 10 + x_add, gui.screen.y/2 - 20), color(255,255,255,255*ind_alpha), nil, bind.value)
				end
				render.text(2, vector(gui.screen.x/2 - render.measure_text(2, nil, "DMG").x/2 + 2 + x_add, gui.screen.y/2 + y_add), color(160, 255, 1, 255), nil, "DMG")
				y_add = y_add + 9
			end
        end
		
		if config.misc.mindamage:get() then
			if not damage then
			local value = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()
			render.text(2, vector(gui.screen.x/2 + 10, gui.screen.y/2 - 20), color(255,255,255,255*ind_alpha), nil, value) end
		end
		
        if config.misc.manualarrows:get() then
            render.poly(color(config.antihit.manual:get() == "Left" and config.antihit.override:get() and config.misc.theme_color1:get().r or 35, config.antihit.manual:get() == "Left" and config.antihit.override:get() and config.misc.theme_color1:get().g or 35, config.antihit.manual:get() == "Left" and config.antihit.override:get() and config.misc.theme_color1:get().b or 35, config.antihit.manual:get() == "Left" and config.antihit.override:get() and 255*ind_alpha or 150*ind_alpha), vector(gui.screen.x / 2 - 55, gui.screen.y / 2 + 2), vector(gui.screen.x / 2 - 42, gui.screen.y / 2 - 7), vector(gui.screen.x / 2 - 42, gui.screen.y / 2 + 11))
            render.poly(color(config.antihit.manual:get() == "Right" and config.antihit.override:get() and config.misc.theme_color1:get().r or 35, config.antihit.manual:get() == "Right" and config.antihit.override:get() and config.misc.theme_color1:get().g or 35, config.antihit.manual:get() == "Right" and config.antihit.override:get() and config.misc.theme_color1:get().b or 35, config.antihit.manual:get() == "Right" and config.antihit.override:get() and 255*ind_alpha or 150*ind_alpha), vector(gui.screen.x / 2 + 55, gui.screen.y / 2 + 2), vector(gui.screen.x / 2 + 42, gui.screen.y / 2 - 7), vector(gui.screen.x / 2 + 42, gui.screen.y / 2 + 11))
            render.rect(vector(gui.screen.x / 2 + 38, gui.screen.y / 2 - 7), vector(gui.screen.x / 2 + 38 + 2, gui.screen.y / 2 - 7 + 18), color((entity.get_local_player().m_flPoseParameter[11] * 120 - 60) > 0 and config.misc.theme_color1:get().r or 35, (entity.get_local_player().m_flPoseParameter[11] * 120 - 60) > 0 and config.misc.theme_color1:get().g or 35, (entity.get_local_player().m_flPoseParameter[11] * 120 - 60) > 0 and config.misc.theme_color1:get().b or 35, (entity.get_local_player().m_flPoseParameter[11] * 120 - 60) > 0 and 255*ind_alpha or 150*ind_alpha))
            render.rect(vector(gui.screen.x / 2 - 40, gui.screen.y / 2 - 7), vector(gui.screen.x / 2 - 40 + 2, gui.screen.y / 2 - 7 + 18), color((entity.get_local_player().m_flPoseParameter[11] * 120 - 60) < 0 and config.misc.theme_color1:get().r or 35, (entity.get_local_player().m_flPoseParameter[11] * 120 - 60) < 0 and config.misc.theme_color1:get().g or 35, (entity.get_local_player().m_flPoseParameter[11] * 120 - 60) < 0 and config.misc.theme_color1:get().b or 35, (entity.get_local_player().m_flPoseParameter[11] * 120 - 60) < 0 and 255*ind_alpha or 150*ind_alpha))
        end
    end
	
	if config.misc.indicators:get(2) then
		local state = false
    	local alpha = 0
	
		local x, y = draggables_elements.vel_x:get(), draggables_elements.vel_y:get()
		local modifier = player.m_flVelocityModifier
		alpha = animatables.create(9, (modifier < 1) or ui.get_alpha() == 1, "velocity_alpha")
		
		if (config.misc.indicators_style:get() == "Themed") then
			if (config.misc.widgets_style:get() == "Metamod") then
				draw.custom_rectangle(x, y - 2, x + 120, y + 15, config.misc.widgets_style:get(), config.misc.widgets_outline:get(), config.misc.widgets_gradient:get(), alpha)
				render.rect(vector(x, y - 2), vector(x + (120 * modifier), y + 16), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha))
			else
				if (config.misc.widgets_gradient:get() ~= "None") then
					draw.custom_rectangle(x + 5, y - 2, x + 120, y + 15, config.misc.widgets_style:get(), config.misc.widgets_outline:get(), config.misc.widgets_gradient:get(), alpha)
					render.rect(vector(x, y - 2), vector(x + (120 * modifier), y + 16), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, config.theme[1].a * alpha), 5)
				else
					draw.custom_rectangle(x + 5, y - 2, x + 120, y + 15, config.misc.widgets_style:get(), config.misc.widgets_outline:get(), config.misc.widgets_gradient:get(), (config.theme[1].a/255) * 0.5 * alpha)
					render.rect(vector(x, y - 2), vector(x + (120 * modifier), y + 16), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, config.theme[1].a * alpha), 5)
				end
			end
		
			render.text(gui.fonts.arial, vector(x + 6, y + 1), color(0, 0, 0, 255 * alpha), nil, "Velocity reduced")
			render.text(gui.fonts.arial, vector(x + 5, y), color(255, 255, 255, 255 * alpha), nil, "Velocity reduced")
			render.text(gui.fonts.arial, vector(x + 111 - render.measure_text(2, nil, math.floor(modifier*100)).x, y + 1), color(0, 0, 0, 255 * alpha), nil, math.floor(modifier*100))
			render.text(gui.fonts.arial, vector(x + 110 - render.measure_text(2, nil, math.floor(modifier*100)).x, y), color(255, 255, 255, 255 * alpha), nil, math.floor(modifier*100))
		else
			render.text(gui.fonts.arial, vector(x + 6, y + 1), color(0, 0, 0, 255 * alpha), nil, "Velocity reduced")
			render.text(gui.fonts.arial, vector(x + 5, y), color(255, 255, 255, 255 * alpha), nil, "Velocity reduced")
			render.text(2, vector(x - render.measure_text(2, nil, math.floor(modifier*100)).x/2 + 106, y), color(255, 255, 255, 255 * alpha), nil, math.floor(modifier*100))
			render.circle_outline(vector(x + 105, y + 7), color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255 * alpha), 10, 0, modifier, 3)
		end
		
		draggables.create(draggables_elements.vel_x, draggables_elements.vel_y, 120, 21, "velocity", false)
	end
	
	if config.misc.gamesense_ind:get() then
		local x = draggables_elements.gsind_x:get()
		local y = draggables_elements.gsind_y:get()
		local y_add = 0
		local charged = false
		if rage.exploit:get() == 1 then charged = true end
		
		local binds = ui.get_binds()
		for i = 1, #binds do
			local u = #binds - i + 1
            local bind = binds[u] 
			if bind.reference:name() == "Double Tap" then
				draw.skeet_indicator("DT", y + y_add, color(225, rage.exploit:get() * 225, rage.exploit:get() * 225))
				y_add = y_add - 35
			end
			if bind.reference:name() == "Min. Damage" then
				draw.skeet_indicator("Damage: "..bind.value, y + y_add, color(180, 180, 180))
				y_add = y_add - 35
			end
			if bind.reference:name() == "Hit Chance" then
				draw.skeet_indicator("HITCHANCE OVR", y + y_add, color(230, 230, 40))
				y_add = y_add - 35
			end
			if bind.reference:name() == "Safe Points" then
				draw.skeet_indicator("SAFE", y + y_add, color(132, 195, 16))
				y_add = y_add - 35
			end
			if bind.reference:name() == "Dormant Aimbot" then
				draw.skeet_indicator("DA", y + y_add, color(132, 195, 16))
				y_add = y_add - 35
			end
			if bind.reference:name() == "Hide Shots" then
				draw.skeet_indicator("HIDE", y + y_add, color(132, 195, 16))
				y_add = y_add - 35
			end
			if bind.reference:name() == "Freestanding" then
				draw.skeet_indicator("FS", y + y_add, color(225, 225, 225))
				y_add = y_add - 35
			end
			if bind.reference:name() == "Body Aim" then
				draw.skeet_indicator("BODY", y + y_add, color(255, 0, 0))
				y_add = y_add - 35
			end
			if bind.reference:name() == "Fake Duck" then
				draw.skeet_indicator("DUCK", y + y_add, color(225, 225, 225))
				y_add = y_add - 35
			end
			if bind.reference:name() == "Peek Assist" then
				draw.skeet_indicator("PEEK", y + y_add, color(225, 225, 225))
				y_add = y_add - 35
			end
		end
		
		if bit.band(player.m_fFlags, bit.lshift(1, 0)) == 0 then 
			local velocity = math.floor(math.sqrt(player["m_vecVelocity[0]"]^2 + player["m_vecVelocity[1]"]^2))
			draw.skeet_indicator("LC", y + y_add, charged and color(255, 0, 0) or velocity/globals.choked_commands >= 20.84 and color(132, 195, 16) or color(255, 0, 0, 255))
			y_add = y_add - 35
		end 
		
		local c4 = entity.get_entities(129)[1]
        if c4 ~= nil then
            local timer = string.format("%.1f", ((c4["m_flC4Blow"] - globals.curtime)*10) / 10)
            if math.floor(timer) > 0 and not c4["m_bBombDefused"] then
                local defusestart = c4["m_hBombDefuser"] ~= 4294967295
                local defuselength = c4["m_flDefuseLength"]
                local defusetimer = defusestart and math.floor((c4["m_flDefuseCountDown"] - globals.curtime)*10) / 10 or -1
                if defusetimer > 0 then
                    local clr = math.floor(timer) > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)
                    
                    local barlength = (((gui.screen.y - 50) / defuselength) * (defusetimer))
                    render.rect(vector(0.0, 0.0), vector(16, gui.screen.y), color(25, 25, 25, 160))
                    render.rect_outline(vector(0.0, 0.0), vector(16, gui.screen.y), color(25, 25, 25, 160))
                    
                    render.rect(vector(0, gui.screen.y - barlength), vector(16, gui.screen.y), clr)
                end
                
                local bombsite = c4["m_nBombSite"] == 0 and "A" or "B"
                local health = player["m_iHealth"]
                local armor = player["m_ArmorValue"]
                local willKill = false
                local distance = util.calculate_distance(c4["m_vecOrigin"], player["m_vecOrigin"])
                local a = 450.7
                local b = 75.68
                local c = 789.2
                local d = (distance - b) / c

                local damage = a * math.exp(-d * d)
                if armor > 0 then
                    local newDmg = damage * 0.5
    
                    local armorDmg = (damage - newDmg) * 0.5
                    if armorDmg > armor then
                        armor = armor * (1 / .5)
                        newDmg = damage - armorDmg
                    end
                    damage = newDmg
                end
                local dmg = math.ceil(damage)
                    if dmg >= health then
                    willKill = true
                else
                    willKill = false
                end
                draw.skeet_indicator(bombsite.." - "..string.format("%.1f", timer).."s", y + y_add, color(235 ,235, 235))
                y_add = y_add - 35
                if player then
                    if willKill == true then
                        draw.skeet_indicator("FATAL", y + y_add, color(255, 0, 0, 255))
                        y_add = y_add - 35
                    elseif damage > 0.5 then
                        draw.skeet_indicator("-"..dmg.." HP", y + y_add, color(210, 216, 112, 255))
                        y_add = y_add - 35
                    end
                end
            end
        end
		draggables.create(draggables_elements.gsind_x, draggables_elements.gsind_y, 120, 100, "skeet_ind", true)
	end
end

function functions.misc.hitlogs(e)
	local postfix = ""
	local postfixmiss = ""
	if functions.hitlogs.hit_count%10 == 1 then postfix = "st" elseif functions.hitlogs.hit_count%10 == 2 then postfix = "nd" elseif functions.hitlogs.hit_count%10 == 3 then postfix = "rd" else postfix = "th" end
	if functions.hitlogs.miss_count%10 == 1 then postfixmiss = "st" elseif functions.hitlogs.miss_count%10 == 2 then postfixmiss = "nd" elseif functions.hitlogs.miss_count%10 == 3 then postfixmiss = "rd" else postfixmiss = "th" end
    if not e.target and not e.target.m_flPoseParameter then 
		return end
	
	if config.misc.indicators:get(3) then
		if e.state == nil then
			if config.misc.logs_to_event:get(1) then
				if (config.misc.indicators_style:get() == "Themed") then
					table.insert(functions.hitlogs.data, 1, {
						{
							{ "Hit "..e.target:get_name().." in the "..functions.hitlogs.hitboxes[e.hitgroup].." for "..e.damage.." damage ("..(e.target.m_iHealth - e.damage < 0 and 0 or e.target.m_iHealth - e.damage).." health remaining)", 
							color(255, 255, 255, 255) }
						},
					event_time = globals.realtime,
					alpha = 0, position = 0})
				else
					table.insert(functions.hitlogs.data, 1, {
						{
							{ "Hit ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
							{ e.target:get_name().." ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
							{ "in the ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
							{ functions.hitlogs.hitboxes[e.hitgroup].." ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
							{ "for ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
							{ e.damage.." ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
							{ "damage ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
							{ "(", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
							{ (e.target.m_iHealth - e.damage < 0 and 0 or e.target.m_iHealth - e.damage).." ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
							{ "health remaining)", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) }
						},
					event_time = globals.realtime,
					alpha = 0, position = 0})
				end
				print_raw("\aFFFFFF[\a95B806RekwieN.tech\aFFFFFF] Registered "..functions.hitlogs.hit_count, postfix.." shot in ".. e.target:get_name().."'s "..functions.hitlogs.hitboxes[e.hitgroup].." for "..e.damage.." [angle: "..util.round(e.target.m_flPoseParameter[11] * 120 - 60, 2).."°] (hitchance: "..e.hitchance.."% | safety: "..math.random(0, 1).." | history(Î”): " ..e.backtrack.." | flags: (" ..(refs.dt:get() and 1 or 0)..(refs.os_aa:get() and 1 or 0)..math.random(0, 1)..")")
				print_dev("[RekwieN.tech] Registered "..functions.hitlogs.hit_count, postfix.." shot in "..e.target:get_name().."'s "..functions.hitlogs.hitboxes[e.hitgroup].." for "..e.damage.." [angle: "..util.round(e.target.m_flPoseParameter[11] * 120 - 60, 2).."Â°] (hitchance: "..e.hitchance.."% | safety: "..math.random(0, 1).." | history(Î”): "..e.backtrack.." | flags: ("..(refs.dt:get() and 1 or 0)..(refs.os_aa:get() and 1 or 0)..math.random(0, 1)..")")
				functions.hitlogs.hit_count = functions.hitlogs.hit_count + 1
			end
		else
			if config.misc.logs_to_event:get(3) then
				if (config.misc.indicators_style:get() == "Themed") then
					table.insert(functions.hitlogs.data, 1, {
						{
							{ "Missed "..e.target:get_name().."'s "..functions.hitlogs.hitboxes[e.wanted_hitgroup].." due to "..e.state, 
							color(255, 255, 255, 255) }
						},
					event_time = globals.realtime,
					alpha = 0, position = 0})
				else
					table.insert(functions.hitlogs.data, 1, {
					{
						{ "Missed ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
						{ e.target:get_name().." ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
						{ "'s ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
						{ functions.hitlogs.hitboxes[e.wanted_hitgroup].." ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
						{ "due to ", color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) },
						{ e.state, color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255) }
					},
					event_time = globals.realtime,
					alpha = 0, position = 0})
				end
				print_raw("\aFFFFFF[\aFF0000RekwieN.tech\aFFFFFF] Missed "..functions.hitlogs.miss_count, postfixmiss.. " shot in "..e.target:get_name().."'s "..functions.hitlogs.hitboxes[e.wanted_hitgroup].." due to \aFF0000"..e.state.."\aFFFFFF [angle: "..util.round(e.target.m_flPoseParameter[11] * 120 - 60, 2).."°] (hitchance: "..e.hitchance.."% | safety: "..math.random(0, 1).." | history(Î”): "..e.backtrack.." | flags: ("..(refs.dt:get() and 1 or 0)..(refs.os_aa:get() and 1 or 0)..math.random(0, 1)..")")
				print_dev("[RekwieN.tech] Missed "..functions.hitlogs.miss_count, postfixmiss.. " shot in "..e.target:get_name().."'s "..functions.hitlogs.hitboxes[e.wanted_hitgroup].." due to "..e.state.." [angle: "..util.round(e.target.m_flPoseParameter[11] * 120 - 60, 2).."Â°] (hitchance: "..e.hitchance.."% | safety: "..math.random(0, 1).." | history(Î”): "..e.backtrack.." | flags: ("..(refs.dt:get() and 1 or 0)..(refs.os_aa:get() and 1 or 0)..math.random(0, 1)..")")
				functions.hitlogs.miss_count = functions.hitlogs.miss_count + 1
			end
		end
	end
end

function functions.misc.debugpanel()
	if not config.misc.debugpanel:get() then
		return end
	
    local player = entity.get_local_player()
    if not player then
        return end
		
	local txtmm = render.measure_text(2, nil, "REKWIEN.TECH")
	render.texture(player:get_steam_avatar(), vector(4, gui.screen.y/2+1), vector(20,20))
	local anim = gradient.text_animate("REKWIEN", -1, {color(config.theme[1].r, config.theme[1].g, config.theme[1].b, 255), color(config.theme[2].r, config.theme[2].g, config.theme[2].b, 255)})
	if (config.misc.widgets_gradient:get() ~= "None") then
		render.text(2, vector(29, gui.screen.y/2), color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 255), nil, anim:get_animated_text())
	else
		render.text(2, vector(29, gui.screen.y/2), color(config.misc.theme_color1:get().r, config.misc.theme_color1:get().g, config.misc.theme_color1:get().b, 255), nil, "REKWIEN")
	end
    render.text(2, vector(7+txtmm.x, gui.screen.y/2), color(155, 155, 155, 255), nil, ".TECH")
    render.text(2, vector(29, gui.screen.y/2+txtmm.y-3), color(config.misc.debugpanel_color:get().r, config.misc.debugpanel_color:get().g, config.misc.debugpanel_color:get().b, 255), nil, "[STABLE]")
end

function functions.misc.customscope()
    if not config.misc.custom_scope:get() then 
		return end
		
    local player = entity.get_local_player()
    if not player then
        return end
		
    refs.scope:set("Remove All")
    if player.m_bIsScoped then
        render.gradient(vector(gui.screen.x/2 + config.misc.custom_scope_gap:get() + 1, gui.screen.y/2), vector(gui.screen.x/2 + config.misc.custom_scope_gap:get() + config.misc.custom_scope_size:get() + 1, gui.screen.y/2+1), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, not config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, not config.misc.custom_scope_invert:get() and a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0)) --right
        render.gradient(vector(gui.screen.x/2 - config.misc.custom_scope_gap:get(), gui.screen.y/2), vector(gui.screen.x/2 - config.misc.custom_scope_gap:get() - config.misc.custom_scope_size:get(), gui.screen.y/2+1), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, not config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, not config.misc.custom_scope_invert:get() and a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0)) --left
        
		if not config.misc.custom_scope_t:get() then
			render.gradient(vector(gui.screen.x/2, gui.screen.y/2-config.misc.custom_scope_gap:get()), vector(gui.screen.x/2+1, gui.screen.y/2 - config.misc.custom_scope_gap:get() - config.misc.custom_scope_size:get()), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, not config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, not config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, config.misc.custom_scope_invert:get() and a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0)) --up
		end
        render.gradient(vector(gui.screen.x/2, gui.screen.y/2+config.misc.custom_scope_gap:get() + 1), vector(gui.screen.x/2+1, gui.screen.y/2 + config.misc.custom_scope_gap:get() + config.misc.custom_scope_size:get() + 1), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, not config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, not config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, config.misc.custom_scope_invert:get() and a or 0), color(config.misc.custom_scope_color:get().r, config.misc.custom_scope_color:get().g, config.misc.custom_scope_color:get().b, config.misc.custom_scope_invert:get() and config.misc.custom_scope_color:get().a or 0)) --down
    end
end

function functions.misc.viewmodel()
	local player = entity.get_local_player()
    if not player then
        return end
		
	if config.misc.viewmodel:get() then
        cvar.viewmodel_fov:int(config.misc.viewmodel_fov:get(), true)
        cvar.viewmodel_offset_x:float(config.misc.viewmodel_x:get(), true)
        cvar.viewmodel_offset_y:float(config.misc.viewmodel_y:get(), true)
        cvar.viewmodel_offset_z:float(config.misc.viewmodel_z:get(), true)
    else
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
    end
end

function functions.clantag.set(tag)
    if tag == functions.clantag.last then
        return end

    common.set_clan_tag(tag)
    functions.clantag.last = tag
end

function functions.misc.render()
	local player = entity.get_local_player()
    if not player and not globals.is_connected then
        return end
		
	if config.misc.aspectratio:get() > 0 then 
		cvar.r_aspectratio:float(config.misc.aspectratio:get()/100) 
	else
		cvar.r_aspectratio:float(0) 
	end
	
	if config.misc.clantag:get() then
		local net_channel_info = utils.net_channel()
		if not net_channel_info then
			return end
			
		local latency = net_channel_info.latency[0] / globals.tickinterval
		local tickcount_pred = globals.tickcount + latency
		local iter = math.floor(math.fmod(tickcount_pred / 25, #functions.clantag.data)) + 1
		functions.clantag.set(functions.clantag.data[iter])
	end
	
	local y_add = 0 --scope logs
	for i, log in ipairs(functions.hitlogs.data) do
		local frametime = globals.frametime * 8

		if log.event_time + 1 > globals.realtime then
			log.alpha = util.lerp(log.alpha, 1, frametime)
			log.position = util.lerp(log.position, 1, frametime / 1.5)
		end
		
		if (config.misc.indicators_style:get() == "Themed") then
			local text_size = render.measure_text(gui.fonts.arial, nil, log[1][1][1])
			draw.custom_rectangle(gui.screen.x/2 - text_size.x/2 - 12, gui.screen.y/2 + 160 + y_add + log.position * 40 - 40, gui.screen.x/2 + text_size.x/2 + 12, gui.screen.y/2 + 160 + y_add + log.position * 40 - 40 + 16 + 3, config.misc.widgets_style:get(), config.misc.widgets_outline:get(), config.misc.widgets_gradient:get(), log.alpha)
			draw.string_multicolored(log[1], gui.screen.x/2 + 5, gui.screen.y/2 + 160 + y_add + log.position * 40 - 37, gui.fonts.arial, true, true, log.alpha)
		else
			draw.string_multicolored(log[1], gui.screen.x/2, gui.screen.y/2 + 160 + y_add + log.position * 40 - 40, gui.fonts.verdana, true, true, log.alpha)
		end

		if log.event_time + (5 - 0.1) < globals.realtime then
			log.position = util.lerp(log.position, 2, frametime / 1.5)
		end

		if log.event_time + 5 < globals.realtime and log.position > 1.5 then
			log.alpha = util.lerp(log.alpha, 0, frametime)
		end

		if log.alpha < 0.02 and (log.event_time + 5 < globals.realtime) or #functions.hitlogs.data > 10 then
			table.remove(functions.hitlogs.data, i+1)
		end
		if (config.misc.indicators_style:get() == "Themed") then
			y_add = y_add + 25 * log.alpha
		else
			y_add = y_add + 12 * log.alpha
		end
	end
end

function functions.misc.createmove(cmd)
	local player = entity.get_local_player()
	if not player then
		return end
			
	if config.misc.nodamage:get() then
		if player.m_vecVelocity.z >= -500 then
			nd_state = false
		else
			if util.get_trace(15) then
				nd_state = false
			elseif util.get_trace(75) then
				nd_state = true
			end
		end

		if player.m_vecVelocity.z < -500 then
			if nd_state then
				cmd.in_duck = 1
			else
				cmd.in_duck = 0
			end
		end
	end
	
    if config.misc.fastladder:get() then
		if player.m_MoveType == 9 and common.is_button_down(0x57) then
			cmd.view_angles.y = math.floor(cmd.view_angles.y+0.5)
			cmd.roll = 0

			if cmd.view_angles.x < 45 then
				cmd.view_angles.x = 89
				cmd.in_moveright = 1
				cmd.in_moveleft = 0
				cmd.in_forward = 0
				cmd.in_back = 1
				if cmd.sidemove == 0 then
					cmd.view_angles.y = cmd.view_angles.y + 90
				end
				if cmd.sidemove < 0 then
					cmd.view_angles.y = cmd.view_angles.y + 150
				end
				if cmd.sidemove > 0 then
					cmd.view_angles.y = cmd.view_angles.y + 30
				end
			end
		end
    end
end

function functions.misc.on_death(e)
	if not config.misc.trashtalk:get() then
		return end
		
	local player = entity.get_local_player()
    local victim = entity.get(e.userid, true)
    local attacker = entity.get(e.attacker, true)
				
	if attacker == player then utils.console_exec("say "..(functions.misc.trashtalk[utils.random_int(1, #functions.misc.trashtalk)])) end
    if victim == player then 
		functions.hitlogs.miss_count = 1
	end
end

events.render:set(function()
	functions.gradient_sidebar()
	functions.menu_manager()
	
	for _, anim in pairs(animations_table) do
        anim:update(globals.frametime)
    end

	functions.misc.solus_render()
	functions.misc.indicators_render()
	functions.misc.debugpanel()
	functions.misc.customscope()
	functions.misc.render()
	
	functions.antihit.exploits()
end)

events.createmove:set(function(cmd)
    functions.antihit.createmove(cmd)
	functions.antihit.breaker_hook()
	functions.misc.viewmodel()
	functions.misc.createmove(cmd)
end)

events.bullet_impact:set(function(e)
    functions.antihit.abf_inverter(e)
end)

events.aim_ack:set(function(e)
	functions.misc.hitlogs(e)
end)

--[[shared logo removed]]

events.round_start:set(function(event)
	functions.hitlogs.miss_count = 1
    functions.hitlogs.data = {}
end)

events.player_death:set(function(e)
	functions.misc.on_death(e)
end)

config.misc.clantag:set_callback(function() 
	functions.clantag.set("")
end)

config.misc.custom_scope:set_callback(function()
	refs.scope:set("Remove Overlay")
end)

events.shutdown:set(function()
	functions.clantag.set("")
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
end)