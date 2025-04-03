---@diagnostic disable: undefined-global, undefined-field
-- Data to fetch
local obex_data = obex_fetch and obex_fetch() or {username = 'FiveQe', build = 'PRIV'}

-- Globals
local global = {
    build = obex_data.build,
    username = obex_data.username,
    version = 2.0,
    developerMode = true
}

-- Configuration
local configuration = {
    menuTabs = {"anti-aim settings", "miscellaneous", "visuals", "settings"},
    indicatorTypes = {"none", "modern", "old"},
    watermarkTypes = {"none", "newest", "modern", "gradient", "old"},
    trashtalkTypes = {"disabled", "polish", "english", "russian", "czech"},
    freestandingOptions = {"static", "jitter"},
    bfPhases = {1,2,3,4,5},
    trashtalkPolish = {"stare powiedzenie mowi, ze trening czyni mistrza. Ty grasz 20h dziennie i dalej jestes chvjowy.", "bym cie kurwa zabil, przysiegam", "zostales stapowany bo nie masz mercury.lua", "wez ty kurw0 kup mercury, hs", "bez problemu tapik ez", "juz boty na mirage sa lepszym przeciwnikiem, hs 1", "wiesz, ze nic nie wiesz i dostajesz hs", "mozesz mi wylizac stopy", "jestes takim gownem ze ja pierd00le", "MICHAEL BAGIETKA CIE ROOOCHA W DUPE"},
    trashtalkAll = {"to si zabil brooo XDDDDDDd", "На нахуй тапнут долбаеб", "Нихуево туалет помыла шлюха", 'изи долбаеб', 'ахаха ебать ты хуевый', 'скажи что повезло', 'хуево играешь', 'научиться играть', "Ой бля пошел нахуй не игрок ебаный", "Ой сорри не увидел клопа", "нихуя ты тупой ебать я тя хснул", "ОЙ ГЛИСТА ТЫ КУДА АХАХАХАХА", 'изи долбаеб', 'ахаха ебать ты хуевый', 'скажи что повезло', 'хуево играешь', 'научиться играть', 'for u? this hs. for me? this ones.', "Good luck today! I know you’ll do great.", "Опа пидарас вантап нахуй", "Бля я как мортис ебанул тебя как диномайка", "bym cie kurwa zabil, przysiegam", "𝖎𝖋 𝖞𝖔𝖚 𝖜𝖆𝖓𝖙 𝖚𝖓𝖍𝖎𝖙𝖙𝖆𝖇𝖑𝖊 𝖆𝖆 𝖏𝖚𝖘𝖙 𝖑𝖎𝖐𝖊 𝖒𝖊 𝖌𝖔 𝖇𝖚𝖞 𝖒𝖊𝖗𝖈𝖚𝖗𝖞.𝖑𝖚𝖆" ,'ｗｅａｋ ｂｏｔ ｒａｐｅｄ', '𝑻𝑨𝑲𝑬 𝑻𝑯𝑰𝑺 "1" 𝑨𝑵𝑫 𝑩𝑨𝑵 𝑭𝑹𝑶𝑴 𝑯𝑬𝑨𝑽𝑬𝑵' ,"Sending major good vibes your way.", "I know this won’t be easy, but I also know you’ve got what it takes to get through it.", "This is tough, but you’re tougher.", '𝓶𝓮𝓻𝓬𝓾𝓻𝔂 𝓪𝓷𝓽𝓲 𝓪𝓲𝓶 𝓼𝓸𝓯𝓽𝔀𝓪𝓻𝓮𝓼 𝓭𝓸𝓶𝓲𝓷𝓪𝓽𝓮 𝓪𝓵𝓵', 'stay calm and enjoy the ✖ 1 ❤' ,"Sending you good thoughts—and hoping you believe in yourself just as much as I believe in you.", "Hope you’re doing awesome!","zostales stapowany bo nie masz mercury.lua", "ja > ty lol", "Žil si stejně jako tvůj otec, krátce" ,"wez ty kurw0 kup mercury, hs", "bez problemu tapik ez", "I believe in you! And unicorns. But mostly you!", "juz boty na mirage sa lepszym przeciwnikiem, hs 1", "ez baimik randomie ft. mercury.lua", 'ｂｏｔ ｎｅｅｄ ｈｖｈ ｌｅｓｓｏｎｓ', '𝕀𝔽 𝕀 𝕆ℙ𝔼ℕ 𝕊ℙ𝕀ℕ𝔹𝕆𝕋 𝔸𝕃𝕃 𝔻𝕆𝔾𝕊 𝔻𝕀𝔼', "Snad sis nemyslel že mě zabiješ lol", '𝐲𝐨𝐮 𝐚𝐫𝐞 𝐚 𝐰𝐞𝐚𝐤 𝐝𝐨𝐠 𝐚𝐧𝐝 𝐲𝐨𝐮𝐫 𝐟𝐫𝐢𝐞𝐧𝐝𝐬 𝐰𝐢𝐥𝐥 𝐛𝐞 𝐤𝐢𝐥𝐥𝐞𝐝 𝐢𝐧 𝐭𝐡𝐢𝐬 𝐯𝐢𝐝𝐞𝐨' ,'Jetzt bin ich - Stewie2k (◣◢)' , "nie masz podjazdu nn", "ez baim kill so ez"},
    trashtalkCzech = {"a máš to ty zkurvysyne", "Žíl si stejně jako tvůj otec, krátce", "Za 1 ty kokote", "Snad si nemyslel že mě zabiješ lol", "umrels lolooll", "owned by top1 czech", "Chípls mrdko", "Snad sis nemyslel že mě zabiješ lol :DDDD", "ježíší ty si tak pomalej xddd", "$$ ZEMREL SI VELICE RYCHLE $$", "ja > ty lol", "chcípl si tak rychle jak tvůj fotr mrdko", "to si zabil broo XDDDDddd", "hs blbecku"},
    trashtalkEnglish = {'for u? this hs. for me? this ones.', "Good luck today! I know you’ll do great.", '𝕟𝕠 𝕕𝕒𝕥𝕒𝕓𝕒𝕤𝕖 𝕨𝕚𝕝𝕝 𝕤𝕒𝕧𝕖 𝕪𝕠𝕦 𝕗𝕣𝕠𝕞 𝕥𝕙𝕖𝕤𝕖 𝕙𝕤', '𝖒𝖞 𝖗𝖊𝖘𝖔𝖑𝖛𝖊𝖗 𝖑𝖔𝖛𝖊𝖘 𝖙𝖆𝖕𝖕𝖎𝖓𝖌 𝖓𝖔 𝖓𝖆𝖒𝖊𝖘', '𝕞𝕒𝕪 𝕘𝕠𝕕 𝕗𝕠𝕣𝕘𝕚𝕧𝕖 𝕪𝕠𝕦 𝕓𝕦𝕥 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕨𝕠𝕟𝕥', '𝔱𝔥𝔦𝔰 𝔡𝔬𝔤𝔰 𝔡𝔢𝔠𝔦𝔡𝔢 𝔱𝔬 𝔠𝔬𝔪𝔢 𝔪𝔶 𝔭𝔦𝔫𝔤 𝔞𝔫𝔡 𝔡𝔦𝔢 𝔭𝔞𝔦𝔫𝔣𝔲𝔩', '𝕀𝔽 𝕀 𝕆ℙ𝔼ℕ 𝕊ℙ𝕀ℕ𝔹𝕆𝕋 𝔸𝕃𝕃 𝔻𝕆𝔾𝕊 𝔻𝕀𝔼', '𝔗𝔬 𝔞𝔩𝔩 𝔡𝔬𝔤𝔰 𝔠𝔬𝔭𝔶𝔦𝔫𝔤 𝔪𝔢 𝔰𝔱𝔬𝔭 𝔠𝔬𝔭𝔶𝔦𝔫𝔤 𝔪𝔢', '𝒴𝑜𝓊𝓇 𝑔𝒶𝓃𝑔 𝒾𝓈 𝒶𝓁𝓁 𝓀𝒾𝓁𝓁𝑒𝒹 𝒷𝓎 𝒥𝒮 𝑅𝐸𝒮𝒪𝐿𝒱𝐸𝑅', '𝕨𝕒𝕧𝕖𝕤, 𝕪𝕠𝕦 𝕨𝕚𝕝𝕝 𝕟𝕠𝕥 𝕝𝕚𝕧𝕖 𝕗𝕠𝕣 𝕪𝕠𝕦𝕣 𝟙𝟜𝕥𝕙 𝕓𝕚𝕣𝕥𝕙𝕕𝕒𝕪', '𝕦 𝕞𝕠𝕥𝕙𝕖𝕣 𝕙𝕒𝕤 𝕦𝕚𝕕 𝕀𝕤𝕤𝕦𝕖 𝕕𝕠𝕘, 𝔾𝕠 𝟙 𝕧𝕤 𝟙 𝕄𝕪 𝕤𝕥𝕒𝕔𝕜 ?','ℕ𝕆ℝ𝕋ℍ 𝔸𝕄𝔼ℝ𝕀ℂ𝔸 𝕊𝕃𝔸𝕍𝔼 𝕊𝔼ℕ𝕋 𝔹𝔸ℂ𝕂 𝕋𝕆 ℕ𝔸 𝔹𝕐 𝔼𝕌 𝕆𝕍𝔼ℝ𝕃𝕆ℝ𝔻 ℝℚ', '𝔻𝕠𝕟’𝕥 𝕡𝕝𝕒𝕪 𝕓𝕒𝕟𝕜 𝕧𝕤 𝕞𝕖, 𝕚𝕞 𝕝𝕚𝕧𝕖 𝕥𝕙𝕖𝕣𝕖.',"Talent wins games, but teamwork and intelligence win championships.", "Teamwork begins by building trust. And the only way to do that is to overcome our need for invulnerability.", "It is literally true that you can succeed best and quickest by helping others to succeed.", "If everyone is moving forward together, then success takes care of itself.", "It is literally true that you can succeed best and quickest by helping others to succeed.", "The whole is other than the sum of the parts.", "The ratio of We’s to I’s is the best indicator of the development of a team.", "Individually, we are one drop. Together, we are an ocean.", "Dirty secrets.","𝖎𝖋 𝖞𝖔𝖚 𝖜𝖆𝖓𝖙 𝖚𝖓𝖍𝖎𝖙𝖙𝖆𝖇𝖑𝖊 𝖆𝖆 𝖏𝖚𝖘𝖙 𝖑𝖎𝖐𝖊 𝖒𝖊 𝖌𝖔 𝖇𝖚𝖞 𝖒𝖊𝖗𝖈𝖚𝖗𝖞.𝖑𝖚𝖆" ,'ｗｅａｋ ｂｏｔ ｒａｐｅｄ', '𝑻𝑨𝑲𝑬 𝑻𝑯𝑰𝑺 "1" 𝑨𝑵𝑫 𝑩𝑨𝑵 𝑭𝑹𝑶𝑴 𝑯𝑬𝑨𝑽𝑬𝑵' ,"Sending major good vibes your way.", "I know this won’t be easy, but I also know you’ve got what it takes to get through it.", "This is tough, but you’re tougher.", '𝓶𝓮𝓻𝓬𝓾𝓻𝔂 𝓪𝓷𝓽𝓲 𝓪𝓲𝓶 𝓼𝓸𝓯𝓽𝔀𝓪𝓻𝓮𝓼 𝓭𝓸𝓶𝓲𝓷𝓪𝓽𝓮 𝓪𝓵𝓵', 'stay calm and enjoy the ✖ 1 ❤' ,"Sending you good thoughts—and hoping you believe in yourself just as much as I believe in you.", "Hope you’re doing awesome!"},
    trashtalkRussian = {"На нахуй тапнут долбаеб", "Нихуево туалет помыла шлюха", "Опа пидарас вантап нахуй", "Бля я как мортис ебанул тебя как диномайка", "Ой бля пошел нахуй не игрок ебаный", "Ой сорри не увидел клопа", "нихуя ты тупой ебать я тя хснул", "ОЙ ГЛИСТА ТЫ КУДА АХАХАХАХА", 'изи долбаеб', 'ахаха ебать ты хуевый', 'скажи что повезло', 'хуево играешь', 'научиться играть'},
}

-- Table of menu elements
local menuElements = {
    labels = {},
    navigators = { selectedMenuTab = nil },
    aa = {},
    antibf = {},
    misc = {},
    visuals = {},
    config = {}
}

local indicatorState = {
    scoped_fraction = 0,
    active_fraction = 0,
    inactive_fraction = 0,
    hide_fraction = 0
}

-- State(Data) of player
local playerStates = {
    states_name = {"stand", "run", "slowwalk", "air", "crouch", "air-crouch", "crouch-move"},
    int_to_state = {[1] = "stand", [2] = "run", [3] = "slowwalk", [4] = "air", [5] = "crouch", [6] = "air-crouch", [7] = "crouch-move"},
    state_to_int = {["stand"] = 1, ["run"] = 2, ["slowwalk"] = 3, ["air"] = 4, ["crouch"] = 5, ["air-crouch"] = 6, ["crouch-move"] = 7},
    state = 1,
    manual = 0,
    last_manual = 0,
    pitch_exploit = false,
    is_defensive = false
}

local uiState = {
    antibfcfg_toggled = false
}

local uiCache = {
    lastSelectedMenuItem = nil,
    lastSelectedCondition = nil,
    lastAntiBfToggled = nil,
    lastSelectedBfPhase = nil
}

local antibruteforce = {
    brutestate = 0, -- 0 by default (0-5 [0 = normal settings, 1-5 = antibf settings)
    lastBruteChange = 0 
}

local miscState = {
    clantag = "",
    clantag_emptied = false
}

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end

local rgba_to_hex=function(b,c,d,e)return string.format('%02x%02x%02x%02x',b,c,d,e)end
local hex_to_rgba=function(g)g=g:gsub('#','')return tonumber('0x'..g:sub(1,2)),tonumber('0x'..g:sub(3,4)),tonumber('0x'..g:sub(5,6)),tonumber('0x'..g:sub(7,8))or 255 end
local hsva_to_rgba=function(i,j,k,e)local b,c,d;local l=math.floor(i*6)local m=i*6-l;local n,o,p=k*(1-j),k*(1-m*j),k*(1-(1-m)*j)l=l%6;local q={{k,p,n},{o,k,n},{n,k,p},{n,o,k},{p,n,k},{k,n,o}}b,c,d=unpack(q[l+1])return b*255,c*255,d*255,e*255 end
local rgba_to_hsva=function(b,c,d,e)b,c,d,e=b/255,c/255,d/255,e/255;local s,t=math.max(b,c,d),math.min(b,c,d)local i,j,k=0,0,s;local u=s-t;j=s==0 and 0 or u/s;if s==t then i=0 else if s==b then i=(c-d)/u;if c<d then i=i+6 end elseif s==c then i=(d-b)/u+2 elseif s==d then i=(b-c)/u+4 end;i=i/6 end;return i,j,k,e end


local prev_simulation_time = 0
local diff_sim = 0

local easeInOut = function(t)
    return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3
end

local rect = function(x, y, w, h, radius, color)
    radius = math.min(x/2, y/2, radius)
    local r, g, b, a = unpack(color)
    renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
    renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
    renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
    renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
    renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
    renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
    renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
end

local rect_outline = function(x, y, w, h, radius, thickness, color)
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
end

local glow_module = function(x, y, w, h, width, rounding, accent, accent_inner)
    local thickness = 1
    local offset = 1
    local r, g, b, a = unpack(accent)
    if accent_inner then
        rect(x , y, w, h + 1, rounding, accent_inner)
    end
    for k = 0, width do
        if a * (k/width)^(1) > 5 then
            local accent = {r, g, b, a * (k/width)^(2)}
            rect_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
        end
    end
end

local clamp = function(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

-- teamskeet arrows aa
local function tsarrow_render(cx, cy, r, g, b, a, bodyyaw)
    renderer.triangle(cx + 55, cy + 2, cx + 42, cy - 7, cx + 42, cy + 11, 
    playerStates.manual == 2 and r or 35, 
    playerStates.manual == 2 and g or 35, 
    playerStates.manual == 2 and b or 35, 
    playerStates.manual == 2 and a or 150)

    renderer.triangle(cx - 55, cy + 2, cx - 42, cy - 7, cx - 42, cy + 11, 
    playerStates.manual == 1 and r or 35, 
    playerStates.manual == 1 and g or 35, 
    playerStates.manual == 1 and b or 35, 
    playerStates.manual == 1 and a or 150)
    
    
    if playerStates.manual == 3 then
        renderer.triangle(cx, cy - 40, cx + 10, cy - 26, cx - 10, cy - 26, r, g, b, a)
    end

    renderer.rectangle(cx + 38, cy - 7, 2, 18, 
    bodyyaw < -10 and r or 35,
    bodyyaw < -10 and g or 35,
    bodyyaw < -10 and b or 35,
    bodyyaw < -10 and a or 150)
    renderer.rectangle(cx - 40, cy - 7, 2, 18,			
    bodyyaw > 10 and r or 35,
    bodyyaw > 10 and g or 35,
    bodyyaw > 10 and b or 35,
    bodyyaw > 10 and a or 150)
end

_G.mercury_push=(function()
	_G.mercury_notify_cache={}
	local a={callback_registered=false,maximum_count=4}
	local b=ui.reference("Misc","Settings","Menu color")
	function a:register_callback()
		if self.callback_registered then return end;
		client.set_event_callback("paint_ui",function()
			local c={client.screen_size()}
			local d={0,0,0}
			local e=1;
			local f=_G.mercury_notify_cache;
			for g=#f,1,-1 do
				_G.mercury_notify_cache[g].time=_G.mercury_notify_cache[g].time-globals.frametime()
				local h,i=255,0;
				local i2 = 0;
				local lerpy = 150;
				local lerp_circ = 0.5;
				local j=f[g]
				if j.time<0 then
					table.remove(_G.mercury_notify_cache,g)
				else
					local k=j.def_time-j.time;
					local k=k>1 and 1 or k;
				if j.time<1 or k<1 then
					i=(k<1 and k or j.time)/1;
					i2=(k<1 and k or j.time)/1;
					h=i*255;
					lerpy=i*150;
					lerp_circ=i*0.5
				if i<0.2 then
					e=e+8*(1.0-i/0.2)
				end
			end;

			local l={ui.get(b)}
			local m={math.floor(renderer.measure_text(nil,"[Mercury]  "..j.draw)*1.03)}
			local n={renderer.measure_text(nil,"[Mercury]  ")}
			local o={renderer.measure_text(nil,j.draw)}
			local p={c[1]/2-m[1]/2+3,c[2]-c[2]/100*13.4+e}
            local c1,c2,c3,c4 = ui.get(menuElements.visuals["notifications_col1"])
			local x, y = client.screen_size()
			--renderer.rectangle(p[1]-1,p[2]-20,m[1]+2,22,6, 6, 6,h>255 and 255 or h)
			renderer.rectangle(p[1]-1,p[2]-20,m[1]+2,22,6, 6, 6,20)
			renderer.circle(p[1]-1,p[2]-8, 6, 6, 6,20, 12, 180, 0.5)
			renderer.circle(p[1]+m[1]+1,p[2]-8, 6, 6, 6,20, 12, 0, 0.5)
			renderer.circle_outline(p[1]-1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, 90, lerp_circ, 2)
			renderer.circle_outline(p[1]+m[1]+1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, -90, lerp_circ, 2)
			renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
			renderer.text(p[1]+m[1]/2-o[1]/2,p[2] - 9,c1,c2,c3,h,"c",nil,"[Mercury]  ")
			renderer.text(p[1]+m[1]/2+n[1]/2,p[2] - 9,255,255,255,h,"c",nil,j.draw)e=e-33
		end
	end;
	self.callback_registered=true end)
end;

function a:paint(q,r)
	local s=tonumber(q)+1;
	for g=self.maximum_count,2,-1 do
		_G.mercury_notify_cache[g]=_G.mercury_notify_cache[g-1]
	end;
	_G.mercury_notify_cache[1]={time=s,def_time=s,draw=r}
self:register_callback()end;return a end)()

mercury_push:paint(4, "Welcome - " .. global.username ..  " to Mercury.lua 2.0 Recode - build: " .. global.build)

function sim_diff()
    local current_simulation_time = time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

local function table_contains(tbl, value)
    for i=1,#tbl do
        if tbl[i] == value then
            return true
        end
    end
    return false
end

-- Screen size
local screen = {client.screen_size()}

-- Dependencies
local dependencies = {
    antiaim_funcs = "gamesense/antiaim_funcs",
    ffi = "ffi",
    base64 = "gamesense/base64",
    clipboard = "gamesense/clipboard",
    bit = "bit",
    images = "gamesense/images"
}

local dependencyError = false

local function loadDependencies()
    for i,v in pairs(dependencies) do
        if not pcall(require, v) then
            client.error_log("The " .. v .. " library is needed for the Mercury.LUA to work. Make sure to subscribe it on Gamesense Workshop!")
            dependencyError = true
        else
            dependencies[i] = require(v)
            if global.developerMode then print("Dependency " .. i .. " succesfully loaded!") end
        end
    end
end

local screen = {client.screen_size()}

-- Global functions
local function isEnabled(element) return ui.get(element) end

-- Setter for player conditions
local function setCondition(id)
    playerStates.state = id
end

local function printColor(text)
    if text == nil then
        return
    end

    for str in string.gmatch(text, "([^".."\a".."]+)") do
        local from, to = string.find(text, str, 1, true)
        local colorHex = string.sub(text, from, from + 5)
        local textToPrint = string.sub(text, from + 6, to)
        local r,g,b = tonumber("0x"..colorHex:sub(1,2)), tonumber("0x"..colorHex:sub(3,4)), tonumber("0x"..colorHex:sub(5,6))
        if r == nil then
            r,g,b = 255,255,255
        end
        client.color_log(r, g, b, textToPrint .. "\0")
    end
    client.color_log(255,255,255, " ")
end


-- both listed below print functions support multiple color printing in one line.
-- it supports only \a00ff00 format (so hex without alpha)

local function print_debug(text)
    if global.developerMode then
        printColor("\a0a99f2[mercury | debug system] \a00ff00" .. text)
    end
end

local function prefix_print(text)
    printColor("\a0a99f2[mercury] \affffff" .. text)
end

-- Normalizing globals to Mercury slang
local function normalizeGlobals()
    local build = global.build
    if build == "Debug" then
        global.build = "DEV"
    elseif build == "Beta" then
        global.build = "BETA"
    elseif build == "Live" then
        global.build = "LIVE"
    elseif build == "Private" then
        global.build = "PRIV"
    end
end

local function welcomeUser()
    normalizeGlobals()
    if not global.developerMode then client.exec("clear") end
    printColor("\a0a99f2  __  __                                  _     _    _               ")
    printColor("\a0a99f2 |  \\/  |                                | |   | |  | |  /\\      ")
    printColor("\a0a99f2 | \\  / | ___ _ __ ___ _   _ _ __ _   _  | |   | |  | | /  \\     ")
    printColor("\a0a99f2 | |\\/| |/ _ \\ '__/ __| | | | '__| | | | | |   | |  | |/ /\\ \\    ")
    printColor("\a0a99f2 | |  | |  __/ | | (__| |_| | |  | |_| |_| |___| |__| / ____ \\   ")
    printColor("\a0a99f2 |_|  |_|\\___|_|  \\___|\\__,_|_|   \\__, (_)______\\____/_/    \\_\\  ")
    printColor("\a0a99f2                                   __/ |                         ")
    printColor("\a0a99f2  ______ ______ ______ ______ ____|___/____ ______ ______ ______ ")
    printColor("\a0a99f2 |______|______|______|______|______|______|______|______|______|")
    printColor("\a0a99f2                  \\ \\    / / |__ \\  / _ \\                        ")
    printColor("\a0a99f2                   \\ \\  / /     ) || | | |                       ")
    printColor("\a0a99f2                    \\ \\/ /     / / | | | |                       ")
    printColor("\a0a99f2                     \\  /     / /_ | |_| |                       ")
    printColor("\a0a99f2                      \\/     |____(_)___/                        ")
    printColor(" ")
    printColor("\acc7e18                         Hello \aFFFFFF" .. global.username .. "\acc7e18!")
    printColor("\affffffIts freaking good to see u using the new \a0a99f2Mercury.LUA \acc7e18[" .. global.build .. "]\affffff Recode 2.0 :D")
    printColor("\affffffWe have spent \acc7e18a lot of time \affffffto make it as good as it is, so we hope you will like it!")
    printColor(" ")
    printColor("\acc7e18Our discord server: \affffffhttps://discord.gg/5K3rsGEnR5")
    printColor(" ")
    printColor("\affffffWe hope you will have a great day,")
    printColor("\a0a99f2Mercury STAFF <3")
end

-- Welcoming user
welcomeUser()

-- Loading dependencies
loadDependencies()

-- Original Menu References
local refAA = {
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
    roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
    yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")}
}

local ref = {
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    fakelag = {ui.reference("AA", "Fake lag", "Limit")},
    fbaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
    freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
    slow = {ui.reference("AA", "Other", "Slow motion")},
}


local function setOriginalMenu(visibility)
    for i, v in pairs(refAA) do
        if type(v) == "table" then
            for index, value in ipairs(v) do
                ui.set_visible(value, visibility)
            end
        else
            ui.set_visible(v, visibility)
        end
    end
end

-- Generate name for conditional aa builder
local function genName(name, conditionId)
    return name .. "\n" .. conditionId
end

-- Gradient text animation
local function gradient_text_anim(rr, gg, bb, aa, rrr, ggg, bbb, aaa, text, speed)
    local r1, g1, b1, a1 = rr, gg, bb, aa
    local r2, g2, b2, a2 = rrr, ggg, bbb, aaa
    local highlight_fraction =  (globals.realtime() / 2 % 1.2 * speed) - 1.2
    local output = ""
    for idx = 1, #text do
        local character = text:sub(idx, idx)
        local character_fraction = idx / #text

        local r, g, b, a = r1, g1, b1, a1
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
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, 255, text:sub(idx, idx))
    end
    return output
end

local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)  
    return math.floor(num * mult + 1) / mult
end

-- Calculate measurement for visuals thingies
local function calcMeas(text)
    local textMeas = renderer.measure_text("-", text)
    return textMeas
end

-- Navigate antibf
local function navigateAntiBf()
    uiState.antibfcfg_toggled = not uiState.antibfcfg_toggled
end

local function incrementBfPhase()
    if antibruteforce.brutestate < 5 then
        antibruteforce.brutestate = antibruteforce.brutestate + 1
    else
        antibruteforce.brutestate = 0
    end
end

local function exportConfig()
    local base64 = dependencies['base64']
    local clipboard = dependencies['clipboard']
    local settings = {}
    settings['conditional'] = {}
    settings['antibf'] = {}
    for key, value in pairs(playerStates.int_to_state) do
        settings['conditional'][key] = {}
        settings['antibf'][key] = {}
        local conditional = menuElements.aa["conditional"][key]
        local antibf = menuElements.antibf["phasesList"][key]
        for k, v in pairs(conditional) do
            settings['conditional'][key][k] = ui.get(v)
        end
        for phase, val in pairs(antibf) do
            settings['antibf'][key][phase] = {}
            for elementName, elementVal in pairs(antibf[phase]) do
                settings['antibf'][key][phase][elementName] = ui.get(elementVal)
            end
        end
    end
    clipboard.set(json.stringify(settings))
end

local function importConfig(default)
    local settings = nil
    if default == nil then
        local clipboard = dependencies['clipboard']
        local base64 = dependencies['base64']
        local clipboardGet = clipboard.get()
        settings = json.parse(clipboardGet)
    else
        local defaultSetts = '{"conditional":[{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":10,"bodyyaw":"jitter","yawjitter_val":64,"bodyval":0,"yawjitter":"center","roll":0,"yawadd_left":7,"fakeyawlimit":60,"antibftoggle":true,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":22,"bodyyaw":"jitter","yawjitter_val":46,"bodyval":0,"yawjitter":"center","roll":0,"yawadd_left":-12,"fakeyawlimit":60,"antibftoggle":true,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":10,"bodyyaw":"jitter","yawjitter_val":77,"bodyval":0,"yawjitter":"center","roll":0,"yawadd_left":7,"fakeyawlimit":60,"antibftoggle":true,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":15,"force_defensive":true,"bodyyaw":"jitter","yawjitter_val":61,"bodyval":0,"yawjitter":"center","fakeyawlimit":60,"yawadd_left":-5,"roll":0,"antibftoggle":false,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":0,"bodyyaw":"jitter","yawjitter_val":55,"bodyval":0,"yawjitter":"center","roll":0,"yawadd_left":0,"fakeyawlimit":60,"antibftoggle":false,"yawjitter_val_right":0},{"yawjitter_val_left":-5,"pitch":"down","aa_exploits":{},"yawadd_right":15,"force_defensive":true,"bodyyaw":"jitter","yawjitter_val":66,"bodyval":0,"yawjitter":"center","fakeyawlimit":60,"yawadd_left":18,"roll":0,"antibftoggle":true,"yawjitter_val_right":18},{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":0,"bodyyaw":"jitter","yawjitter_val":54,"bodyval":0,"yawjitter":"center","roll":0,"yawadd_left":0,"fakeyawlimit":60,"antibftoggle":false,"yawjitter_val_right":0}],"antibf":[[{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":10,"roll":0,"yawjitter_val":64,"phase_switch":true,"yawjitter":"center","bodyyaw":"jitter","yawadd_left":7,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":10,"roll":0,"yawjitter_val":61,"phase_switch":true,"yawjitter":"center","bodyyaw":"jitter","yawadd_left":7,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":10,"roll":0,"yawjitter_val":59,"phase_switch":true,"yawjitter":"center","bodyyaw":"jitter","yawadd_left":7,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0}],[{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":75,"phase_switch":true,"yawjitter":"center","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":57,"phase_switch":true,"yawjitter":"center","bodyyaw":"jitter","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":66,"phase_switch":true,"yawjitter":"center","bodyyaw":"jitter","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0}],[{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":70,"phase_switch":true,"yawjitter":"center","bodyyaw":"jitter","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":10,"roll":0,"yawjitter_val":75,"phase_switch":true,"yawjitter":"center","bodyyaw":"jitter","yawadd_left":7,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":80,"phase_switch":true,"yawjitter":"center","bodyyaw":"jitter","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0}],[{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"force_defensive":true,"bodyyaw":"off","yawjitter_val":0,"phase_switch":false,"roll":0,"bodyval":0,"yawadd_left":0,"fakeyawlimit":60,"yawjitter":"off","yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"force_defensive":false,"bodyyaw":"off","yawjitter_val":0,"phase_switch":false,"roll":0,"bodyval":0,"yawadd_left":0,"fakeyawlimit":60,"yawjitter":"off","yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"force_defensive":false,"bodyyaw":"off","yawjitter_val":0,"phase_switch":false,"roll":0,"bodyval":0,"yawadd_left":0,"fakeyawlimit":60,"yawjitter":"off","yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"force_defensive":false,"bodyyaw":"off","yawjitter_val":0,"phase_switch":false,"roll":0,"bodyval":0,"yawadd_left":0,"fakeyawlimit":60,"yawjitter":"off","yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"force_defensive":false,"bodyyaw":"off","yawjitter_val":0,"phase_switch":false,"roll":0,"bodyval":0,"yawadd_left":0,"fakeyawlimit":60,"yawjitter":"off","yawjitter_val_right":0}],[{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0}],[{"yawjitter_val_left":0,"pitch":"down","aa_exploits":{},"yawadd_right":0,"force_defensive":true,"bodyyaw":"jitter","yawjitter_val":70,"phase_switch":true,"roll":0,"bodyval":0,"yawadd_left":0,"fakeyawlimit":60,"yawjitter":"center","yawjitter_val_right":0},{"yawjitter_val_left":-27,"pitch":"down","aa_exploits":{},"yawadd_right":37,"force_defensive":false,"bodyyaw":"jitter","yawjitter_val":27,"phase_switch":true,"roll":0,"bodyval":-70,"yawadd_left":-15,"fakeyawlimit":60,"yawjitter":"left&right center","yawjitter_val_right":37},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"force_defensive":false,"bodyyaw":"off","yawjitter_val":0,"phase_switch":false,"roll":0,"bodyval":0,"yawadd_left":0,"fakeyawlimit":60,"yawjitter":"off","yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"force_defensive":false,"bodyyaw":"off","yawjitter_val":0,"phase_switch":false,"roll":0,"bodyval":0,"yawadd_left":0,"fakeyawlimit":60,"yawjitter":"off","yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"force_defensive":false,"bodyyaw":"off","yawjitter_val":0,"phase_switch":false,"roll":0,"bodyval":0,"yawadd_left":0,"fakeyawlimit":60,"yawjitter":"off","yawjitter_val_right":0}],[{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0},{"yawjitter_val_left":0,"pitch":"off","aa_exploits":{},"yawadd_right":0,"roll":0,"yawjitter_val":0,"phase_switch":false,"yawjitter":"off","bodyyaw":"off","yawadd_left":0,"bodyval":0,"fakeyawlimit":60,"yawjitter_val_right":0}]]}'
        settings = json.parse(defaultSetts)
    end

    for key, value in pairs(playerStates.int_to_state) do
        for k, v in pairs(menuElements.aa['conditional'][key]) do
            ui.set(v, settings['conditional'][key][k])
        end
        for k, v in pairs(menuElements.antibf['phasesList'][key]) do
            for name, value in pairs(menuElements.antibf['phasesList'][key][k]) do
                ui.set(value, settings['antibf'][key][k][name])
            end
        end
    end

    ui.set(menuElements.aa["global_switch"], true)

end

local function gamesense_anim(text, indices)
	local text_anim = "               " .. text .. "                      " 
	local tickinterval = globals.tickinterval()
	local tickcount = globals.tickcount() + time_to_ticks(client.latency())
	local i = tickcount / time_to_ticks(0.3)
	i = math.floor(i % #indices)
	i = indices[i+1]+1

	return string.sub(text_anim, i, i+15)
end

local function run_tag_animation()
    local clan_tag = gamesense_anim("MERCURY",
    { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15 })
    if clan_tag ~= miscState.clantag then
        client.set_clan_tag(clan_tag)
    end
    miscState.clantag = clan_tag
end

local function renderMenu()
    -- Menu elements, alignment
    menuElements.labels["script_name"] = ui.new_label("AA", "Anti-aimbot angles", "\a0A99F2FFmercury [\acc7e18ff"
            .. string.lower(global.build) .. "\a0A99F2FF] | "
            .. string.lower(global.username))
    menuElements.labels["navigator_separator_top"] = ui.new_label("AA", "Anti-aimbot angles", " ")
    menuElements.navigators.selectedMenuTab = ui.new_combobox("AA", "Anti-aimbot angles", "selected tab:", configuration.menuTabs)
    menuElements.labels["navigator_separator_bottom"] = ui.new_label("AA", "Anti-aimbot angles", " ")

    -- Anti-aim
    menuElements.aa["antibf_label"] = ui.new_label("AA", "Anti-aimbot angles", "\a0A99F2FFanti-bruteforce configuration")
    menuElements.aa["global_switch"] = ui.new_checkbox("AA", "Anti-aimbot angles", "enable anti-aim")
    menuElements.aa["spacing_1"] = ui.new_label("AA", "Fake lag", " ")
    menuElements.aa["text"] = ui.new_label("AA", "Fake lag", "\a0A99F2FF--- [ mercury | \acc7e18ff other \a0A99F2FF] ---")
    menuElements.aa["spacing_2"] = ui.new_label("AA", "Fake lag", " ")
    menuElements.aa["freestanding"] = ui.new_hotkey("AA", "Fake lag", "freestanding [default]")
    menuElements.aa["freestandingdisablers"] = ui.new_multiselect("AA", "Fake lag", "freestanding disablers", "stand", "run", "slowwalk", "air", "crouch", "air-crouch", "crouch-move", "manual aa")
    menuElements.aa["freestandingoption"] = ui.new_combobox("AA", "Fake lag", "freestanding type", configuration.freestandingOptions)
    menuElements.aa["manualaa_left"] = ui.new_hotkey("AA", "Fake lag", "manual aa [left]")
    menuElements.aa["manualaa_right"] = ui.new_hotkey("AA", "Fake lag", "manual aa [right]")
    menuElements.aa["manualaa_forward"] = ui.new_hotkey("AA", "Fake lag", "manual aa [forward]")
    menuElements.aa["manualaa_reset"] = ui.new_hotkey("AA", "Fake lag", "manual aa [backwards]")
    menuElements.aa["conditions"] = ui.new_combobox("AA", "Anti-aimbot angles", "condition:", playerStates.states_name)
    menuElements.aa["conditional"] = {}
    menuElements.antibf["phasesList"] = {}
    for i, v in pairs(playerStates.int_to_state) do
        -- for conditional aa
        menuElements.aa["conditional"][i] = {}
        menuElements.aa["conditional"][i]["pitch"] = ui.new_combobox("AA", "Anti-aimbot angles",
                genName("pitch", i), { "off", "down", "minimal", "default"})
        menuElements.aa["conditional"][i]["aa_exploits"] = ui.new_multiselect("AA", "Anti-aimbot angles",
                genName("aa exploits", i), {"pitch exploit"})
        menuElements.aa["conditional"][i]["yawadd_left"] = ui.new_slider("AA", "Anti-aimbot angles",
                genName("yaw add left", i), -180, 180, 0)
        menuElements.aa["conditional"][i]["yawadd_right"] = ui.new_slider("AA", "Anti-aimbot angles",
                genName("yaw add right", i), -180, 180, 0)
        menuElements.aa["conditional"][i]["yawjitter"] = ui.new_combobox("AA", "Anti-aimbot angles",
                genName("yaw jitter", i), { "off", "offset", "center", "skitter", "random", "left&right center"})
        menuElements.aa["conditional"][i]["yawjitter_val"] = ui.new_slider("AA", "Anti-aimbot angles",
                genName("yaw jitter value", i), -180, 180, 0)
        menuElements.aa["conditional"][i]["yawjitter_val_left"] = ui.new_slider("AA", "Anti-aimbot angles",
                genName("yaw jitter [left] value", i), -180, 180, 0)
        menuElements.aa["conditional"][i]["yawjitter_val_right"] = ui.new_slider("AA", "Anti-aimbot angles",
                genName("yaw jitter [right] value", i), -180, 180, 0)
        menuElements.aa["conditional"][i]["bodyyaw"] =  ui.new_combobox("AA", "Anti-aimbot angles",
                genName("body options", i), { "off", "opposite", "jitter", "static"})
        menuElements.aa["conditional"][i]["bodyval"] = ui.new_slider("AA", "Anti-aimbot angles",
                genName("body value", i), -180, 180, 0)
        menuElements.aa["conditional"][i]["roll"] = ui.new_slider("AA", "Anti-aimbot angles",
                genName("roll value", i), -60, 60, 0, true, "°", 1, {[0] = 'disabled'})
        if i == 4 or i == 6 then
            menuElements.aa["conditional"][i]["force_defensive"] = ui.new_checkbox("AA", "Anti-aimbot angles",
                genName("force defensive", i))
        end
        menuElements.aa["conditional"][i]["antibftoggle"] = ui.new_checkbox("AA", "Anti-aimbot angles",
                genName("\a0A99F2FFenable anti-bruteforce \acc7e18ff[jitter]", i))
    end

    menuElements.antibf["phases"] = ui.new_combobox("AA", "Anti-aimbot angles", "bruteforce phase:", configuration.bfPhases)

    for i, v in pairs(playerStates.int_to_state) do
        menuElements.antibf["phasesList"][i] = {}
        for phase, value in pairs(configuration.bfPhases) do
            local uniqueName = i .. phase
            menuElements.antibf["phasesList"][i][phase] = {}
            menuElements.antibf["phasesList"][i][phase]["phase_switch"] = ui.new_checkbox("AA", "Anti-aimbot angles", "enable phase \acc7e18ff[" .. phase .. " | " .. v .. "]")
            menuElements.antibf["phasesList"][i][phase]["pitch"] = ui.new_combobox("AA", "Anti-aimbot angles",
                    genName("pitch", uniqueName), { "off", "down", "minimal", "default"})
            menuElements.antibf["phasesList"][i][phase]["aa_exploits"] = ui.new_multiselect("AA", "Anti-aimbot angles",
                    genName("aa exploits", uniqueName), {"pitch exploit"})
            menuElements.antibf["phasesList"][i][phase]["yawadd_left"] = ui.new_slider("AA", "Anti-aimbot angles",
                    genName("yaw add left", uniqueName), -180, 180, 0)
            menuElements.antibf["phasesList"][i][phase]["yawadd_right"] = ui.new_slider("AA", "Anti-aimbot angles",
                    genName("yaw add right", uniqueName), -180, 180, 0)
            menuElements.antibf["phasesList"][i][phase]["yawjitter"] = ui.new_combobox("AA", "Anti-aimbot angles",
                    genName("yaw jitter", uniqueName), { "off", "offset", "center", "skitter", "random", "left&right center"})
            menuElements.antibf["phasesList"][i][phase]["yawjitter_val"] = ui.new_slider("AA", "Anti-aimbot angles",
                    genName("yaw jitter value", uniqueName), -180, 180, 0)
            menuElements.antibf["phasesList"][i][phase]["yawjitter_val_left"] = ui.new_slider("AA", "Anti-aimbot angles",
                    genName("yaw jitter [left] value", uniqueName), -180, 180, 0)
            menuElements.antibf["phasesList"][i][phase]["yawjitter_val_right"] = ui.new_slider("AA", "Anti-aimbot angles",
                    genName("yaw jitter [right] value", uniqueName), -180, 180, 0)
            menuElements.antibf["phasesList"][i][phase]["bodyyaw"] =  ui.new_combobox("AA", "Anti-aimbot angles",
                    genName("body options", uniqueName), { "off", "opposite", "jitter", "static"})
            menuElements.antibf["phasesList"][i][phase]["bodyval"] = ui.new_slider("AA", "Anti-aimbot angles",
                    genName("body value", uniqueName), -180, 180, 0)
            menuElements.antibf["phasesList"][i][phase]["roll"] = ui.new_slider("AA", "Anti-aimbot angles",
                    genName("roll value", uniqueName), -60, 60, 0, true, "°", 1, {[0] = 'disabled'})
            if i == 4 or i == 6 then
                menuElements.antibf["phasesList"][i][phase]["force_defensive"] = ui.new_checkbox("AA", "Anti-aimbot angles",
                    genName("force defensive", uniqueName))
            end
        end
    end


    menuElements.antibf["button_goto"] = ui.new_button("AA", "Anti-aimbot angles", "go to anti-bruteforce settings", navigateAntiBf)
    menuElements.antibf["button_exit"] = ui.new_button("AA", "Anti-aimbot angles", "go back to aa settings", navigateAntiBf)

    -- Miscellaneous
    -- @TODO
    menuElements.misc["resolver"] = ui.new_checkbox("AA", "Anti-aimbot angles", "\a0A99F2FFcustom resolver \acc7e18ff[debug only]")
    menuElements.misc["clantag"] = ui.new_checkbox("AA", "Anti-aimbot angles", "mercury clantag")
    menuElements.misc["oganims"] = ui.new_multiselect("AA", "Anti-aimbot angles", "og anims:", "static legs in air", "leg fucker")
    menuElements.misc["trashtalk"] = ui.new_combobox("AA", "Anti-aimbot angles", "trashtalk:", configuration.trashtalkTypes)

    -- Visuals
    -- @TODO
    menuElements.visuals["indicators"] = ui.new_combobox("AA", "Anti-aimbot angles", "crosshair indicator:", configuration.indicatorTypes)
    menuElements.visuals["indicators_col1_lab"] = ui.new_label("AA", "Anti-aimbot angles", "color #1 [indicators]")
    menuElements.visuals["indicators_col1"] = ui.new_color_picker("AA", "Anti-aimbot angles", "color #1ind", 176, 189, 255, 255)
    menuElements.visuals["indicators_col2_lab"] = ui.new_label("AA", "Anti-aimbot angles", "color #2 [indicators]")
    menuElements.visuals["indicators_col2"] = ui.new_color_picker("AA", "Anti-aimbot angles", "color #2ind", 152, 255, 255, 255)
    menuElements.visuals["indicators_col3_lab"] = ui.new_label("AA", "Anti-aimbot angles", "color [glow] [indicators]")
    menuElements.visuals["indicators_col3"] = ui.new_color_picker("AA", "Anti-aimbot angles", "color glowind", 152, 255, 255, 255)
    menuElements.visuals["indicators_sp1"] = ui.new_slider("AA", "Anti-aimbot angles", "mer speed [indicators]", 0, 5, 0, true, nil, 1)
    menuElements.visuals["indicators_sp2"] = ui.new_slider("AA", "Anti-aimbot angles", "cury speed [indicators]", 0, 5, 0, true, nil, 1)
    menuElements.visuals["indicators_sp3"] = ui.new_slider("AA", "Anti-aimbot angles", "glow speed [indicators]", 0, 5, 0, true, nil, 1)
    menuElements.visuals["spacing"] = ui.new_label("AA", "Anti-aimbot angles", " ")
    menuElements.visuals["watermarks"] = ui.new_combobox("AA", "Anti-aimbot angles", "watermark:", configuration.watermarkTypes)
    menuElements.visuals["watermarkcolor1_label"] = ui.new_label("AA", "Anti-aimbot angles", "color #1 [watermark]")
    menuElements.visuals["watermarkcolor1"] = ui.new_color_picker("AA", "Anti-aimbot angles", "color #1wt", 93, 114, 232, 0)
    menuElements.visuals["watermarkcolor2_label"] = ui.new_label("AA", "Anti-aimbot angles", "color #2 [watermark]")
    menuElements.visuals["watermarkcolor2"] = ui.new_color_picker("AA", "Anti-aimbot angles", "color #2wt", 90, 114, 232, 125)
    menuElements.visuals["watermarkcolor3_label"] = ui.new_label("AA", "Anti-aimbot angles", "color #3 [watermark]")
    menuElements.visuals["watermarkcolor3"] = ui.new_color_picker("AA", "Anti-aimbot angles", "color #3wt", 90, 114, 232, 125)
    menuElements.visuals["watermark_round_slider"] = ui.new_slider("AA", "Anti-aimbot angles", "rounding amount [watermark]", 0, 10, 5, true, "px", 1)
    menuElements.visuals["spacing2"] = ui.new_label("AA", "Anti-aimbot angles", " ")
    menuElements.visuals["notifications_col1_lab"] = ui.new_label("AA", "Anti-aimbot angles", "color [notifications]")
    menuElements.visuals["notifications_col1"] = ui.new_color_picker("AA", "Anti-aimbot angles", "color #1not", 176, 189, 255, 255)
    menuElements.visuals["debugpanel_col_lab"] = ui.new_label("AA", "Anti-aimbot angles", "color [debug panel]")
    menuElements.visuals["debugpanel_col"] = ui.new_color_picker("AA", "Anti-aimbot angles", "color #1not", 176, 189, 255, 255)
    menuElements.visuals["spacing3"] = ui.new_label("AA", "Anti-aimbot angles", " ")
    menuElements.visuals["custom_visuals"] = ui.new_multiselect("AA", "Anti-aimbot angles", "other visuals", "teamskeet aa arrows", "debug panel")


    -- Configuration
    -- @TODO
    menuElements.config["import"] = ui.new_button("AA", "Anti-aimbot angles", "import config from clipboard", function()
        if not pcall(importConfig) then 
            prefix_print("\aff0000failed to import config. you probably copied it wrong or it's broken.") 
        else
            prefix_print("\a00ff00config succesfully imported from your clipboard") 
        end 
    end)
    menuElements.config["export"] = ui.new_button("AA", "Anti-aimbot angles", "export config to clipboard", function()
        if not pcall(exportConfig) then 
            prefix_print("\aff0000failed to export config. make ticket on mercury discord to help in fixing it.") 
        else
            prefix_print("\a00ff00config succesfully exported to your clipboard") 
        end 
    end)
    menuElements.config["default"] = ui.new_button("AA", "Anti-aimbot angles", "load default settings (experimental)", function()
            if not pcall(importConfig, true) then
                prefix_print("\aff0000failed to import default config. make ticket on mercury discord to help in fixing it.") 
            else
                prefix_print("\a00ff00default config succesfully imported!") 
            end
    end)
end

renderMenu()

local function setTabs()

    if not ui.is_menu_open() then
        return
    end

    local selectedTab = ui.get(menuElements.navigators.selectedMenuTab)
    local selectedCondition = playerStates.state_to_int[ui.get(menuElements.aa.conditions)]
    local selectedBfPhase = tonumber(ui.get(menuElements.antibf["phases"]))
    local bfJitter = ui.get(menuElements.antibf["phasesList"][selectedCondition][selectedBfPhase]["yawjitter"])
    local bfBodyyaw = ui.get(menuElements.antibf["phasesList"][selectedCondition][selectedBfPhase]["bodyyaw"])
    local jitterType = ui.get(menuElements.aa["conditional"][selectedCondition]["yawjitter"])
    local bodyyawType = ui.get(menuElements.aa["conditional"][selectedCondition]["bodyyaw"])
    local shouldRenderForBf = selectedTab == "anti-aim settings" and uiState.antibfcfg_toggled

    ui.set_visible(menuElements.aa["antibf_label"], shouldRenderForBf)
    ui.set_visible(menuElements.antibf["phases"], shouldRenderForBf)
    ui.set_visible(menuElements.aa["global_switch"], selectedTab == "anti-aim settings" and not uiState.antibfcfg_toggled)
    ui.set_visible(menuElements.antibf["button_goto"],
            selectedTab == "anti-aim settings" and isEnabled(menuElements.aa["conditional"][selectedCondition]["antibftoggle"]) and not uiState.antibfcfg_toggled)
    ui.set_visible(menuElements.antibf["button_exit"], selectedTab == "anti-aim settings" and uiState.antibfcfg_toggled)

    local selectedMenuItemDiff = selectedTab ~= uiCache.lastSelectedMenuItem

    local shouldRecache = selectedMenuItemDiff or uiCache.lastAntiBfToggled ~= uiState.antibfcfg_toggled

    local antiBfPhasesList = menuElements.antibf["phasesList"]

    if selectedBfPhase ~= uiCache.lastSelectedBfPhase or shouldRecache then
        uiCache.lastSelectedBfPhase = selectedBfPhase
        for conditionId, listOfPhases in pairs(antiBfPhasesList) do
            for phaseId, phaseAAElements in pairs(antiBfPhasesList[conditionId]) do
                for name, menuElement in pairs(antiBfPhasesList[conditionId][phaseId]) do
                    local shouldBeVisible = phaseId == selectedBfPhase and conditionId == selectedCondition and uiState.antibfcfg_toggled and selectedTab == "anti-aim settings"
                    if name == "yawjitter_val_left" or name == "yawjitter_val_right" then
                        ui.set_visible(menuElement, bfJitter == "left&right center" and shouldBeVisible)
                    elseif name == "yawjitter_val" then
                        ui.set_visible(menuElement, (bfJitter == "center" or bfJitter == "offset" or bfJitter == "skitter" or bfJitter == "random") and shouldBeVisible)
                    elseif name == "bodyval" then
                        ui.set_visible(menuElement, bfBodyyaw ~= "off" and shouldBeVisible)
                    else
                        ui.set_visible(menuElement, shouldBeVisible)
                    end
                end
            end
        end
    end
    if selectedCondition ~= uiCache.lastSelectedCondition or shouldRecache then
        uiCache.lastSelectedCondition = selectedCondition
        uiCache.lastSelectedMenuItem = selectedTab
        for conditionId, listOfElements in pairs(menuElements.aa["conditional"]) do
            local shouldBeVisible = selectedCondition == conditionId and selectedTab == "anti-aim settings" and not uiState.antibfcfg_toggled
            for name, menuElement in pairs(listOfElements) do
                if name == "yawjitter_val_left" or name == "yawjitter_val_right" then
                    ui.set_visible(menuElement, jitterType == "left&right center" and shouldBeVisible)
                elseif name == "yawjitter_val" then
                    ui.set_visible(menuElement, (jitterType == "center" or jitterType == "offset" or  jitterType == "skitter" or jitterType == "random") and shouldBeVisible)
                elseif name == "bodyval" then
                    ui.set_visible(menuElement, bodyyawType ~= "off" and bodyyawType ~= "opposite" and shouldBeVisible)
                else
                    ui.set_visible(menuElement, shouldBeVisible)
                end
            end
        end
    end

    for i,v in pairs(menuElements.visuals) do
        if i == "indicators_sp1" or i == "indicators_sp2" or i == "indicators_sp3" or i == "indicators_col3_lab" or i == "indicators_col3" then
            ui.set_visible(v, selectedTab == "visuals" and ui.get(menuElements.visuals["indicators"]) == "modern")
        elseif i == "watermarkcolor3_label" or i == "watermarkcolor3" or i == "watermark_round_slider" then
            ui.set_visible(v, selectedTab == "visuals" and ui.get(menuElements.visuals["watermarks"]) == "newest")
        else
            ui.set_visible(v, selectedTab == "visuals")
        end
    end

    if not selectedMenuItemDiff then
        return
    end

    uiCache.lastSelectedMenuItem = selectedTab

    for i,v in pairs(menuElements.aa) do
        if type(v) ~= "table" then
            ui.set_visible(v, selectedTab == "anti-aim settings")
        end
    end

    for i,v in pairs(menuElements.misc) do
        ui.set_visible(v, selectedTab == "miscellaneous")
    end

    for i,v in pairs(menuElements.config) do
        ui.set_visible(v, selectedTab == "settings")
    end

end

local function unload()
    setOriginalMenu(true)
end

local function mainRenderUI()
    setOriginalMenu(false)
    setTabs()
end

local function getVelocityVectorLength(player)
    local vx, vy, vz = entity.get_prop(player, "m_vecVelocity")
    return math.sqrt(vx^2, vy^2, vz^2)
end

local last_command_number = 0
local pitch_cameback = true

local function setupCommand(c)
    local localPlayer = entity.get_local_player()

    local velocity = getVelocityVectorLength(localPlayer)
    local vx, vy, vz = entity.get_prop(localPlayer, "m_vecVelocity")
    local lp_still = math.sqrt(vx ^2 + vy ^ 2 ) < 5
    local p_onground = bit.band(entity.get_prop(localPlayer, "m_fFlags"), 1) == 1 and c.in_jump == 0
    local p_slowwalk = isEnabled(ref.slow[1] and ref.slow[2])
    local isOs = isEnabled(ref.os[1] and ref.os[2])
    local isFd = isEnabled(ref.fakeduck)
    local isDt = isEnabled(ref.dt[1] and ref.dt[2])
    local in_duck = c.in_duck == 1

    if in_duck and p_onground and not lp_still then
        setCondition(7)
    elseif in_duck and not p_onground then
        setCondition(6)
    elseif in_duck and p_onground and lp_still then
        setCondition(5)
    elseif not p_onground then
        setCondition(4)
    elseif p_slowwalk then
        setCondition(3)
    elseif not lp_still then
        setCondition(2)
    elseif lp_still then
        setCondition(1)
    end

    local condition = playerStates.state

    if not ui.get(menuElements.aa["global_switch"]) then
        ui.set(refAA.pitch, "Off")
        ui.set(refAA.bodyyaw[1], "static")
        ui.set(refAA.bodyyaw[2], 0)
        ui.set(refAA.yawbase, "local view")
        ui.set(refAA.yaw[1], "Off")
        ui.set(refAA.yaw[2], 0)
        ui.set(refAA.yawjitter[1], "Off")
        ui.set(refAA.yawjitter[2], 0)
        return
    end

    -- manual aa
    local fs = ui.get(menuElements.aa["freestanding"])
    local fs_disablers = ui.get(menuElements.aa["freestandingdisablers"])
    local fs_should_jitter = ui.get(menuElements.aa["freestandingoption"]) == "jitter"
    local fs_should_be_disabled = false

    if table_contains(fs_disablers, playerStates.int_to_state[condition]) or (table_contains(fs_disablers, "manual aa") and playerStates.manual ~= 0) then
        fs_should_be_disabled = true
    end
    
    local manual = {
        ["left"] = menuElements.aa["manualaa_left"],
        ["right"] = menuElements.aa["manualaa_right"],
        ["forward"] = menuElements.aa["manualaa_forward"],
        ["backward"] = menuElements.aa["manualaa_reset"]
    }
    
    if ui.get(manual["left"]) and playerStates.last_manual + 0.22 < globals.realtime() then
        if playerStates.manual ~= 1 then
            playerStates.manual = 1
        else
            playerStates.manual = 0
        end
        playerStates.last_manual = globals.realtime()
    elseif ui.get(manual["right"]) and playerStates.last_manual + 0.22 < globals.realtime() then
        if playerStates.manual ~= 2 then
            playerStates.manual = 2
        else
            playerStates.manual = 0
        end
        playerStates.last_manual = globals.realtime()
    elseif ui.get(manual["forward"]) and playerStates.last_manual + 0.22 < globals.realtime() then
        if playerStates.manual ~= 3 then
            playerStates.manual = 3
        else
            playerStates.manual = 0
        end
        playerStates.last_manual = globals.realtime()
    elseif ui.get(manual["backward"]) and playerStates.last_manual + 0.22 < globals.realtime() then
        playerStates.manual = 0
        playerStates.last_manual = globals.realtime()
    end

	ui.set(manual["left"], "On hotkey")
	ui.set(manual["right"], "On hotkey")
	ui.set(manual["forward"], "On hotkey")
    ui.set(manual["backward"], "On hotkey")

    if playerStates.manual == 1 then
        ui.set(refAA.bodyyaw[1], "static")
        ui.set(refAA.bodyyaw[2], -180)
        ui.set(refAA.yawbase, "local view")
        ui.set(refAA.yaw[1], "180")
        ui.set(refAA.yaw[2], -90)
    elseif playerStates.manual == 2 then
        ui.set(refAA.bodyyaw[1], "static")
        ui.set(refAA.bodyyaw[2], -180)
        ui.set(refAA.yawbase, "local view")
        ui.set(refAA.yaw[1], "180")
        ui.set(refAA.yaw[2], 90)
    elseif playerStates.manual == 3 then
        ui.set(refAA.bodyyaw[1], "static")
        ui.set(refAA.bodyyaw[2], -180)
        ui.set(refAA.yawbase, "local view")
        ui.set(refAA.yaw[1], "180")
        ui.set(refAA.yaw[2], 180)
    else 
        ui.set(refAA.yawbase, "At targets")
        ui.set(refAA.yaw[1], "180")
    end

    if ui.get(menuElements.aa["freestanding"]) and not fs_should_be_disabled then
        ui.set(ref.freestand[1], true)
		ui.set(ref.freestand[2], "Always on")
	else
        ui.set(ref.freestand[1], false)
        ui.set(ref.freestand[2], "On hotkey")
	end

    local phases = menuElements.antibf["phasesList"][condition][antibruteforce.brutestate]
    local conditional = menuElements.aa["conditional"][condition]


    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and 1 or -1


    local is_defensive = sim_diff() <= -1

    local pitch_exploit = table_contains(ui.get(conditional["aa_exploits"]), "pitch exploit")

    if phases ~= nil and ui.get(phases["phase_switch"]) and ui.get(conditional["antibftoggle"]) then
        pitch_exploit = table_contains(ui.get(phases["aa_exploits"]), "pitch exploit")
        if (phases["force_defensive"] ~= nil and ui.get(phases["force_defensive"])) or pitch_exploit then
            c.force_defensive = true
            playerStates.is_defensive = true
        else 
            playerStates.is_defensive = false
        end
        if pitch_exploit then
            if is_defensive and pitch_cameback then
                last_command_number = c.command_number
                ui.set(refAA.pitch, "Up")
                pitch_cameback = false
            elseif c.command_number > last_command_number + 6 then
                ui.set(refAA.pitch, "Down")
                pitch_cameback = true
            end
            playerStates.pitch_exploit = true
        else
            ui.set(refAA.pitch, ui.get(conditional["pitch"]))
            playerStates.pitch_exploit = false
        end
        if c.chokedcommands == 0 then
            ui.set(refAA.yaw[2], (side == 1 and ui.get(phases["yawadd_left"]) or ui.get(phases["yawadd_right"])))
        end
        local lr_center = ui.get(phases["yawjitter"]) ~= "left&right center"
        if (lr_center and not fs) or (fs and lr_center and fs_should_jitter) then
            ui.set(refAA.yawjitter[1], ui.get(phases["yawjitter"]))
            ui.set(refAA.yawjitter[2], ui.get(phases["yawjitter_val"]))
        elseif not fs_should_jitter and fs then
            ui.set(refAA.yawjitter[1], "Off")
            ui.set(refAA.yawjitter[2], 0)
        else
            ui.set(refAA.yawjitter[1], "Center")
            ui.set(refAA.yawjitter[2], (side == 1 and ui.get(phases["yawjitter_val_left"]) or ui.get(phases["yawjitter_val_right"])))
        end
        ui.set(refAA.bodyyaw[1], ui.get(phases["bodyyaw"]))
        ui.set(refAA.bodyyaw[2], ui.get(phases["bodyval"]))
        c.roll = ui.get(phases["roll"])
    else
        antibruteforce.brutestate = 0
        if (conditional["force_defensive"] ~= nil and ui.get(conditional["force_defensive"]) or pitch_exploit) then
            playerStates.is_defensive = true
            c.force_defensive = true
        else
            playerStates.is_defensive = false
        end
        if pitch_exploit then
            if is_defensive and pitch_cameback then
                last_command_number = c.command_number
                ui.set(refAA.pitch, "Up")
                pitch_cameback = false
            elseif c.command_number > last_command_number + 6 then
                ui.set(refAA.pitch, "Down")
                pitch_cameback = true
            end
            playerStates.pitch_exploit = true
        else
            ui.set(refAA.pitch, ui.get(conditional["pitch"]))
            playerStates.pitch_exploit = false
        end
        -- TODO: aa exploits
        if c.chokedcommands == 0 then
            ui.set(refAA.yaw[2], (side == 1 and ui.get(conditional["yawadd_left"]) or ui.get(conditional["yawadd_right"])))
        end
        local lr_center = ui.get(conditional["yawjitter"]) ~= "left&right center"
        if (lr_center and not fs) or (fs and lr_center and fs_should_jitter) then
            ui.set(refAA.yawjitter[1], ui.get(conditional["yawjitter"]))
            ui.set(refAA.yawjitter[2], ui.get(conditional["yawjitter_val"]))
        elseif not fs_should_jitter and fs then
            ui.set(refAA.yawjitter[1], "Off")
            ui.set(refAA.yawjitter[2], 0)
        else
            ui.set(refAA.yawjitter[1], "Center")
            ui.set(refAA.yawjitter[2], (side == 1 and ui.get(conditional["yawjitter_val_left"]) or ui.get(conditional["yawjitter_val_right"])))
        end
        ui.set(refAA.bodyyaw[1], ui.get(conditional["bodyyaw"]))
        ui.set(refAA.bodyyaw[2], ui.get(conditional["bodyval"]))
        c.roll = ui.get(conditional["roll"])
    end
end



local function onDraw()
    local state = playerStates.int_to_state[playerStates.state]
    local localPlayer = entity.get_local_player()

    if ui.get(menuElements.misc["clantag"]) then
        miscState.clantag_emptied = false
        run_tag_animation()
    elseif not miscState.clantag_emptied and not ui.get(menuElements.misc["clantag"]) then
        miscState.clantag_emptied = true
        client.set_clan_tag("")
    end

    local bodyyaw = entity.get_prop(localPlayer, "m_flPoseParameter", 11) * 120 - 60
    local isOs = isEnabled(ref.os[1] and ref.os[2])
    local isFd = isEnabled(ref.fakeduck)
    local isDt = isEnabled(ref.dt[1] and ref.dt[2])
    local measurement = renderer.measure_text("-", string.upper(global.username))
    local avatar = dependencies['images'].get_steam_avatar(entity.get_steam64(localPlayer))
    local current_rainbow = math.floor((globals.realtime() * 50) % 100)
    local current_rainbow2 = math.floor(((globals.realtime() + 1.5) * 50) % 100)
    local color_r, color_g, color_b, color_a = hsva_to_rgba(current_rainbow * 0.01, 1, 1, 1)
    local color2_r, color2_g, color2_b, color2_a = hsva_to_rgba(current_rainbow2 * 0.01, 1, 1, 1)
    local mr, mg, mb, ma = ui.get(menuElements.visuals["indicators_col1"])
    local mr2, mg2, mb2, ma2 = ui.get(menuElements.visuals["indicators_col2"])
    local mercury_w, mercury_h = renderer.measure_text("-", "MERCURY")
    local scoped = entity.get_prop(localPlayer, "m_bIsScoped") == 1
    local antiaim_funcs = dependencies['antiaim_funcs']


    local watermarkType = ui.get(menuElements.visuals["watermarks"])
    local indicatorType = ui.get(menuElements.visuals["indicators"])
    local custom_visuals = ui.get(menuElements.visuals["custom_visuals"])
    local p1_col_r, p1_col_g, p1_col_b, p1_col_a = ui.get(menuElements.visuals["watermarkcolor1"])
    local p2_col_r, p2_col_g, p2_col_b, p2_col_a = ui.get(menuElements.visuals["watermarkcolor2"])
    local p3_col_r, p3_col_g, p3_col_b, p3_col_a = ui.get(menuElements.visuals["watermarkcolor3"])

    if watermarkType  == "gradient" then
        renderer.gradient(screen[1] - 100 - measurement / 5, 18, 91 + measurement /4, 34, color_r, color_g, color_b, color_a, color2_r, color2_g, color2_b, color2_a, true)
        avatar:draw(screen[1] - 94 - measurement / 4, 23, 25, 25, nil, nil, nil, nil, 20)
        renderer.text(screen[1] - 62 - measurement / 4, 25, 255, 255, 255, 255, "b", nil, "MERCURY")
        renderer.text(screen[1] - 62 - measurement / 4, 35, 255, 255, 255, 255, "-", nil, string.upper(global.username))
        renderer.text(screen[1] - 62 - measurement / 4 + measurement + 2, 35, 255, 255, 255, 255, "-", nil, "[" .. string.upper(global.build) .. "]")
    elseif watermarkType == "old" then
        renderer.gradient(screen[1] - 100 - measurement / 4, 15, 91 + measurement / 4, 3, 83, 114, 242, 0, 80, 114, 232, 255, true)
        renderer.gradient(screen[1] - 100 - measurement / 4, 52, 94 + measurement / 4, 3, 83, 114, 242, 0, 80, 114, 232, 255, true)
        renderer.gradient(screen[1] - 10, 15, 3, 37, 83, 114, 242, 255, 80, 114, 232, 255, false)
        renderer.gradient(screen[1] - 100 - measurement / 2, 17, 90 + measurement / 2 +1, 35, 93, 114, 232, 0, 90, 114, 232, 125, true)
        renderer.text(screen[1] - 62 - measurement / 3,25, 255, 255, 255, 255, "", 0,'MERCURY')
        renderer.text(screen[1] - 63 - measurement / 3,35, 255, 255, 255, 255, "-", 0,string.upper(global.username))
        renderer.text(screen[1] - 63 - measurement / 3 + measurement + 2,35, 255, 255, 255, 255, "-", 0,"[" .. global.build .. "]")
        avatar:draw(screen[1] - 92 - measurement / 3, 25, 23, 23)
    elseif watermarkType == "modern" then
        renderer.gradient(screen[1] - 100 - measurement / 5, 18, 91 + measurement /4, 34, p1_col_r, p1_col_g, p1_col_b, p1_col_a, p2_col_r, p2_col_g, p2_col_b, p2_col_a, true)
        avatar:draw(screen[1] - 94 - measurement / 4, 23, 25, 25, nil, nil, nil, nil, 20)
        renderer.text(screen[1] - 62 - measurement / 4, 25, 255, 255, 255, 255, "b", nil, "MERCURY")
        renderer.text(screen[1] - 62 - measurement / 4, 35, 255, 255, 255, 255, "-", nil, string.upper(global.username))
        renderer.text(screen[1] - 62 - measurement / 4 + measurement + 2, 35, 255, 255, 255, 255, "-", nil, "[" .. string.upper(global.build) .. "]")
    elseif watermarkType == "newest" then
        local user_m = renderer.measure_text("-", string.upper(global.username))
        local round_get = ui.get(menuElements.visuals["watermark_round_slider"])

        rect(screen[1] - 200, 20, 90 + user_m, 39, round_get, {p1_col_r, p1_col_g, p1_col_b, p1_col_a})
        rect_outline(screen[1] - 200, 20, 90 + user_m, 39, round_get, 2,{p2_col_r, p2_col_g, p2_col_b, p2_col_a})
        glow_module(screen[1] - 199, 20, 88 + user_m, 38, 10, round_get,{p3_col_r, p3_col_g, p3_col_b, p3_col_a})
        avatar:draw(screen[1] - 190, 27, 25, 25, nil, nil, nil, nil, 20)
        renderer.text(screen[1] - 160, 27, 255, 255, 255, 255, "b", nil, "mercury")
        renderer.text(screen[1] - 161, 38, 255, 255, 255, 255, "-", nil, string.upper(global.username), " [" .. string.upper(global.build) .. "]")
    end

    if not entity.is_alive(localPlayer) then
        return
    end

    if table_contains(custom_visuals, "teamskeet aa arrows") then
        tsarrow_render(screen[1]/2, screen[2]/2, mr, mg, mb, ma, bodyyaw)
    end

    if table_contains(custom_visuals, "debug panel") then
        local sr, sg, sb, sa = ui.get(menuElements.visuals["debugpanel_col"])
        local desyncvalue = round(math.min(math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60)))
        local target = entity.get_player_name(client.current_threat())
        local desync = string.format("desync amount: %i%%", desyncvalue / 58 * 100)
        local buildString = ">/ mercury anti-aim technologies - "..global.username:lower().." - "..global.build:lower().." \\<"
        local meas = renderer.measure_text("c", buildString)
        renderer.text(meas / 2 + 4, screen[2] / 2, 255, 255, 255, 255, "c", 0, gradient_text_anim(sr, sg, sb, sa, 255, 255, 255, 160, buildString, 1.5))
        renderer.text(4, screen[2] / 2+8, 255, 255, 255, 255, "", 0, gradient_text_anim(sr, sg, sb, sa, 255, 255, 255, 160, "target: " .. target, 1.5))
        renderer.text(4, screen[2] / 2+20, 255, 255, 255, 255, "", 0, gradient_text_anim(sr, sg, sb, sa, 255, 255, 255, 160, desync, 1.5))
        renderer.text(4, screen[2] / 2+32, 255, 255, 255, 255, "", 0, gradient_text_anim(sr, sg, sb, sa, 255, 255, 255, 160, "bruteforce state: " .. antibruteforce.brutestate, 1.5))
    end

    if indicatorType == "old" then
        local ticks = antiaim_funcs.get_tickbase_shifting()
        local ticksForCircle = 0
        if ticks > 12 then
            ticksForCircle = 12
        else
            ticksForCircle = ticks / 12
        end
        local measurement2 = calcMeas("MERCURY")
        local stateMeas = calcMeas(string.upper(state))
        local buildMeas = calcMeas(global.build)
        renderer.text((screen[1] / 2) - stateMeas / 2, (screen[2] / 2) + 35, 255, 255, 255, 255, "-", 0, string.upper(state))
        local alpha = math.sin(math.abs(-3.14 + (globals.curtime() * (1 / .50)) % (3.14 * 2))) * 255
        renderer.text((screen[1] / 2) - measurement2 / 2 - buildMeas + 5, (screen[2] / 2) + 27, mr,mg,mb, 255, "-", 0,'MERCURY')
        renderer.text((screen[1] / 2) + 10, (screen[2] / 2) + 27, mr2,mg2,mb2, alpha, "-", nil, string.upper(global.build))
        if isDt then
            if antiaim_funcs.get_double_tap() or playerStates.pitch_exploit or playerStates.is_defensive then
                renderer.text((screen[1] / 2) - calcMeas("DT") / 2 - 2, (screen[2] / 2) + 44, 255, 255, 255, 255, "-", 0, " DT")
            else
                renderer.text((screen[1] / 2) - calcMeas("DT") / 2 - 2, (screen[2] / 2) + 44, 255, 0, 0, 240, "-", 0, " DT")
            end
        elseif isOs then
            renderer.text((screen[1] / 2) - calcMeas("HS") / 2 - 2, (screen[2] / 2) + 44, 255, 255, 255, 255, "-", 0, "HS")
        else
            renderer.text((screen[1] / 2) - calcMeas("DT") / 2 - 2, (screen[2] / 2) + 44, 150, 150, 150, 240, "-", 0, " DT")
        end
        if ui.get(ref.fbaim) then
            renderer.text((screen[1] / 2) - calcMeas("BAIM") - calcMeas("HS") / 2 - 4, (screen[2] / 2) + 44, 255, 255, 255, 255, "-", 0, "BAIM")
        else
            renderer.text((screen[1] / 2) - calcMeas("BAIM") - calcMeas("HS") / 2 - 4, (screen[2] / 2) + 44, 150, 150, 150, 240, "-", 0, "BAIM")
        end
        if ui.get(ref.freestand[2]) then
            renderer.text((screen[1] / 2) + calcMeas("HS") / 2 , (screen[2] / 2) + 44, 255, 255, 255, 255, "-", 0, "FS")
        else
            renderer.text((screen[1] / 2) + calcMeas("HS") / 2 , (screen[2] / 2) + 44, 150, 150, 150, 240, "-", 0, "FS")
        end
        if ui.get(ref.quickpeek[2]) then
            renderer.text((screen[1] / 2) + calcMeas("HS") / 2 + calcMeas("FS") + 2, (screen[2] / 2) + 44, 255, 255, 255, 255, "-", 0, "QP")
        else
            renderer.text((screen[1] / 2) + calcMeas("HS") / 2 + calcMeas("FS") + 2, (screen[2] / 2) + 44, 150, 150, 150, 240, "-", 0, "QP")
        end
    elseif indicatorType == "modern" then
        local r1, g1, b1 = ui.get(menuElements.visuals["indicators_col1"])
        local r2, g2, b2 = ui.get(menuElements.visuals["indicators_col2"])
        local r3, g3, b3 = ui.get(menuElements.visuals["indicators_col3"])
        local merspeed = ui.get(menuElements.visuals["indicators_sp1"])
        local curyspeed = ui.get(menuElements.visuals["indicators_sp2"])
        local glowspeed = ui.get(menuElements.visuals["indicators_sp3"])
        local x = screen[1]
        local y = screen[2]
        -- change text position based on scope
        if scoped then
            indicatorState.scoped_fraction = clamp(indicatorState.scoped_fraction + globals.frametime() / 0.5, 0, 1)
        else
            indicatorState.scoped_fraction = clamp(indicatorState.scoped_fraction - globals.frametime() / 0.5, 0, 1)
        end

        -- animation for when u scope
        local scoped_fraction = easeInOut(indicatorState.scoped_fraction)

        -- Glow behind mercury and mercury text
        glow_module(x / 2 + ((mercury_w + 2) / 2) * scoped_fraction - mercury_w / 2 + 4, y / 2 + 30,
            mercury_w - 3, 0, 10, 0, { r3, g3, b3, 100 * math.abs(math.cos(globals.curtime() * glowspeed)) },
            { r3, g3, b3, 100 * math.abs(math.cos(globals.curtime() * glowspeed)) })
        renderer.text(x / 2 + ((mercury_w + 2) / 2) * scoped_fraction, y / 2 + 30, 255, 255, 255, 255,
            "-c", 0, "\a" .. rgba_to_hex(r1, g1, b1, 255 * math.abs(math.cos(globals.curtime() * merspeed))) .. "MER",
            "\a" .. rgba_to_hex(r2, g2, b2, 255 * math.abs(math.cos(globals.curtime() * curyspeed))) .. "CURY")

        local dt_active = antiaim_funcs.get_double_tap() or playerStates.pitch_exploit or playerStates.is_defensive

        -- animation for dt when it's on
        if isDt and dt_active then
            indicatorState.active_fraction = clamp(indicatorState.active_fraction + globals.frametime() / 0.15, 0, 1)
        else
            indicatorState.active_fraction = clamp(indicatorState.active_fraction - globals.frametime() / 0.15, 0, 1)
        end

        -- animation for dt when it's off
        if isDt and not dt_active then
            indicatorState.inactive_fraction = clamp(indicatorState.inactive_fraction + globals.frametime() / 0.15, 0, 1)
        else
            indicatorState.inactive_fraction = clamp(indicatorState.inactive_fraction - globals.frametime() / 0.15, 0, 1)
        end

        -- animation for hs
        if isOs and not isDt then
            indicatorState.hide_fraction = clamp(indicatorState.hide_fraction + globals.frametime() / 0.15, 0, 1)
        else
            indicatorState.hide_fraction = clamp(indicatorState.hide_fraction - globals.frametime() / 0.15, 0, 1)
        end

        local dt_size = renderer.measure_text("-", "DT ")
        local ready_size = renderer.measure_text("-", "READY")
        renderer.text(x / 2 + ((dt_size + ready_size + 2) / 2) * scoped_fraction, y / 2 + 40, 255, 255,
            255, indicatorState.active_fraction * 255, "-c", dt_size + indicatorState.active_fraction * ready_size + 1,
            "DT ", "\a" .. rgba_to_hex(155, 255, 155, 255 * indicatorState.active_fraction) .. "READY")

        local charging_size = renderer.measure_text("-", "CHARGING")
        renderer.text(x / 2 + ((dt_size + charging_size + 2) / 2) * scoped_fraction, y / 2 + 40, 255, 255,
            255, indicatorState.inactive_fraction * 255, "-c",
            dt_size + indicatorState.inactive_fraction * charging_size + 1, "DT ",
            "\a" .. rgba_to_hex(255, 100, 100, 255) .. "CHARGING")

        local hide_size = renderer.measure_text("-", "HIDE ")
        local active_size = renderer.measure_text("-", "ACTIVE")
        renderer.text(x / 2 + ((hide_size + active_size + 2) / 2) * scoped_fraction, y / 2 + 40, 255, 255,
            255, indicatorState.hide_fraction * 255, "-c", hide_size + indicatorState.hide_fraction * active_size + 1,
            "HIDE ", "\a" .. rgba_to_hex(155, 255, 155, 255 * indicatorState.hide_fraction) .. "ACTIVE")

        local state_size = renderer.measure_text("-", '- ' .. string.upper(state) .. ' -')
        renderer.text(x / 2 + ((state_size + 2) / 2) * scoped_fraction, y / 2 + 20, 200, 200, 200, 200,
            "-c", 0, '- ' .. string.upper(state) .. ' -')
    end
end


local function mercuryResolverIndicator(player)
    if not ui.get(menuElements.misc.resolver) or entity.is_dormant(player) then
        return false
    else
        return true
    end
end

local function mercuryResolverEvent()
    local localPlayer = entity.get_local_player()
    local enemiesList = entity.get_players(true)

    for i, enemyObj in ipairs(enemiesList) do
        if ui.get(menuElements.misc.resolver) and entity.is_alive(localPlayer) and not entity.is_dormant(enemyObj) then
            plist.set(enemyObj, "Force body yaw", true)
            local properBodyYaw = math.floor(entity.get_prop(enemyObj, "m_flPoseParameter", 11) * 120 - 60)
            plist.set(enemyObj, "Force body yaw value",  properBodyYaw)
        else
            plist.set(enemyObj, "Force body yaw", false)
            plist.set(enemyObj, "Force body yaw value", 0)
        end
    end
end

local function brute_impact(e)

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local shooter_id = e.userid
	local shooter = client.userid_to_entindex(shooter_id)

	if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then return end

	local lx, ly, lz = entity.hitbox_position(me, "head_0")
	
	local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")
	local ex, ey, ez = entity.get_prop(shooter, "m_vecOrigin")

	local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)
	
	if math.abs(dist) <= 35 and globals.realtime() - antibruteforce.lastBruteChange > 0.015 then
		if ui.get(menuElements.aa["conditional"][playerStates.state]["antibftoggle"]) then
			mercury_push:paint(5,"Switched anti-brute due to enemy shot at you")
            incrementBfPhase()
		end
	end
    antibruteforce.lastBruteChange = globals.realtime()
end

-- Registering all needed events
client.set_event_callback('paint', onDraw)
client.set_event_callback('shutdown', unload)
client.set_event_callback('setup_command', setupCommand)
client.set_event_callback('paint_ui', mainRenderUI)
client.set_event_callback("net_update_end", mercuryResolverEvent)
client.register_esp_flag('mercury', 224, 29, 29, mercuryResolverIndicator)
client.set_event_callback("bullet_impact", function(e)
    brute_impact(e)
end)
client.set_event_callback("pre_render", function ()

	if not entity.is_alive(entity.get_local_player()) then return end

    local get_active_anims = ui.get(menuElements.misc["oganims"])

	if table_contains(get_active_anims,"static legs in air") then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
	end

	local legs_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}

	if table_contains(get_active_anims,"leg fucker") then
		ui.set(ui.reference("AA", "Other", "Leg movement"), legs_types[math.random(1, 3)])
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
	end

end)

client.set_event_callback("player_death", function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        mercury_push:paint(5, "Anti-bruteforce data got reset due to player death.")
        antibruteforce.brutestate = 0
    end
    local trashtalk = ui.get(menuElements.misc["trashtalk"])
    if trashtalk ~= "disabled" and e.attacker ~= nil and entity.get_local_player() == client.userid_to_entindex(e.attacker) then
        client.exec("say " .. (trashtalk == "english" and configuration.trashtalkEnglish[math.random(1, #configuration.trashtalkEnglish)] or trashtalk == "polish" and configuration.trashtalkPolish[math.random(1, #configuration.trashtalkPolish)] or trashtalk == "all" and configuration.trashtalkAll[math.random(1, #configuration.trashtalkAll)] or trashtalk == "czech" and configuration.trashtalkCzech[math.random(1, #configuration.trashtalkCzech)] or trashtalk == "russian" and configuration.trashtalkRussian[math.random(1, #configuration.trashtalkRussian)]))
    end
end)

client.set_event_callback("round_start", function()
    antibruteforce.brutestate = 0
    local me = entity.get_local_player()
    if not entity.is_alive(me) then return end
    mercury_push:paint(5, "Anti-bruteforce data got reset due to new round.")
end)