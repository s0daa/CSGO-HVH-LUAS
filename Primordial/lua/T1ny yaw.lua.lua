local configs = {
    "Home",
    "AimBot",
    "AntiAim",
    "Visual",
    "Misc",
}
local killsay1 = {
    '你已被阳光大男孩使用的cz7破解nl顶级参数击杀加qq购买3542251544',
    -- add as many as you want
}
local killsay2 = {
    'T1ny the best prim lua if u want to get it contact qq1910162989',
    'T1ny killed u guys contact qq1910162989',
    'T1ny buy or die contact qq1910162989',
    'T1ny it can save u anytime contact qq1910162989',
    -- add as many as you want
}
local killsay3 = {
    "我觉你你还是那个需要我扶一下才能进去的男孩",
	"想做一杯奶茶，被哥哥又插又吸",
                "哥哥生病了，只有你能治疗，口服注射我都行",
                "你和你妈妈说今晚去同学家睡 我要操你滴批",
                "我的双马尾可以成为哥哥的缰绳吗",
                "用腿给哥哥量腰围",
                "想在哥哥腹肌上练习深蹲",
                "哥哥是千我是北 然后我们一起边乖了",
                "湖在月下面，月在湖里面，我在你下面，你在我里面。",
	"不想喊你哥哥想含你弟弟",
	"外面的鸟看腻了，想看看你的鸟",
	"我想和你翻山越岭，翻上面的山，越下面的明明对哥哥的想念不带一丝水分可为什么想哥哥的时候，总是湿的",
	"哥哥我水最多， 来我这里游泳吗",
	"一晚上被干醒好几次看来是要买个加湿器了",
	"小时候被打屁话会哭现在被打屁股会湿或许这就是成长吧",
	"妹妹比较喜欢出暴击加攻速的男孩子",
	"我们这里雨很大，不知道哥哥那里大不大。",
	"太阳射不进的地方，哥哥可以",
	"喜欢一个人是藏不住的即使捂住嘴巴水也会从下面流出来",
	"要想在潮湿的环境里发热，就得在狭窄的空间里不断摩擦。",
	"小时候喜欢玩水气球因为它会喷水长大了发现自己也可以",
	"我和蜘蛛侠同样的手势即使看上去又脏又黑还有毛，但照样有人吃",
	"不敢顶撞哥哥，但想被哥哥顶撞。",
	"答应我，懆妹妹的时候要比妹妹的男朋友更用力。",
	"哪怕只有手指能动，也不能阻止对黑洞的探索",
	"哥哥奶茶多吗?吸管长不长?噎着的时候会不会按着头不松开?喝不下的时候会不会强行喂",
	"中国有十六亿人口，我却没有人口",
	"今天就是大禹来了也治不了我的水",
	"只要哥哥技术好，背上抓痕不会少",
	"我耐cao，屁股翘，哥哥一顶我就叫",
	"最适宜草莓生长的环境，是哥哥37度的胸膛",
	"没跟我睡过就别说别的女人活儿好",
	"什么b?我没有b，我的双腿间是哥哥的饮水机",
	"你向往的地方，每天早晚都沾满了白露",
	"你心驰神往的林荫小道，其实是车水马龙的高速公路",
	"妹妹已经水漫金山，弟弟却还在垂头丧气",
	"如果前门进不去，那就从后门进",
	"哥哥，长得吓人跟长的吓人可不是一回事。",
	"能把哥哥的手指放在我的水里转一 转吗?那样水就会变甜哦。",
	"哥哥帮我买口红,我帮哥哥口到红",
	"喜欢你是藏不住得即使捂住嘴也会从下面流出来",
	"哥哥会射箭吗，我想看哥哥击靶",
	"我好笨，想你的时候又弄得满手都是",
	"哥哥把月亮塞进我下体，然后喷出今晚的银河",
	"今晚要做小泡芙 被哥哥注满奶油",
                 "只要哥哥不喊停 厨房客厅我都行",
                 "在吗哥哥，交一下水费 最近的水都是为你流的",
                 "想做夏天的西瓜 不仅甜还水多",
                 "下雪了,你摸了摸雪 都是水 我也是",
	"小时候喜欢踩牛奶盒因为只有牛奶盒才能喷出 牛奶后来遇见了你发现你也可以",
}

print("Wecome to T1ny.lua")
print("====Fixed 0830====")
print("Change logss:")
print("Rage bot:")
print("1.Fix Jump Scout")
print("2.Fix AutoTP")
print("3.Fix DoubleTap Knife")
print("4.Fix DoubleTap and Ideal Ticks")
print("Anti Aim:")
print("1.Add BetterTankAA")
print("Visual:")
print("1.Add T1ny Mark")
print("2.Add HUD")
print("3.Fix Hit log")
print("Misc:")
print("1.Add LegFucker and 0 pitch statuc leg air")
print("2.Add Killsay [3Modes]")
print("3.Fix Scripts locks")

local logs = {}
local fonts = nil
local key_name, key_bind = unpack(menu.find("antiaim","main","manual","invert desync"))
local ref_hide_shot, ref_onshot_key = unpack(menu.find("aimbot", "general", "exploits", "hideshots", "enable"))
local ref_auto_peek, ref_peek_key = unpack(menu.find("aimbot","general","misc","autopeek"))
local ref_freestand, ref_frees_key = unpack(menu.find("antiaim","main","auto direction","enable"))
local side_stand = menu.find("antiaim","main", "desync","side#stand")
local llimit_stand = menu.find("antiaim","main", "desync","left amount#stand")
local rlimit_stand = menu.find("antiaim","main", "desync","right amount#stand")
local side_move = menu.find("antiaim","main", "desync","side#move")
local llimit_move = menu.find("antiaim","main", "desync","left amount#move")
local rlimit_move = menu.find("antiaim","main", "desync","right amount#move")
local side_slowm = menu.find("antiaim","main", "desync","side#slow walk")
local llimit_slowm = menu.find("antiaim","main", "desync","left amount#slow walk")
local rlimit_slowm = menu.find("antiaim","main", "desync","right amount#slow walk")
local backup_cache = {
    side_stand = side_stand:get(),
    side_move = side_move:get(),
    side_slowm = side_slowm:get(),

    llimit_stand = llimit_stand:get(),
    rlimit_stand = rlimit_stand:get(),

    llimit_move = llimit_move:get(),
    rlimit_move = rlimit_move:get(),

    llimit_slowm = llimit_slowm:get(),
    rlimit_slowm = rlimit_slowm:get()
}
local vars = {
    yaw_base = 0,
    _jitter = 0,
    _yaw_add = 0,
    l_limit = 0,
    r_limit = 0,
    val_n = 0,
    desync_val = 0,
    yaw_offset = 0,
    temp_vars = 0,
    revs = 1,
    last_time = 0
}

local killsays = {}
local usernameList = {"xiaoc","xiaoc1",}
local username = user.name
local useruid = user.uid
local local_player = entity_list.get_local_player()
local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local enable = menu.add_checkbox("Config", "load T1ny.lua", true)
local mode_list = menu.add_selection("Config", "Mode List", configs)
local home = {}
home.Changelogs = menu.add_text("Change logs", "Hi~ \n Wecome " .. username .. "." .. useruid)
home.Changelogs1 = menu.add_text("Change logs", "===== Change logs =====\n " )

local aimbot = {}
aimbot.jumpscoutfix = menu.add_checkbox("AimBot","Enable Jump Scout Fix", false)
aimbot.tpknife = menu.add_checkbox("AimBot","Enable Teleport Knife", false)
aimbot.autotp = menu.add_checkbox("AimBot","Enable AutoTP      Plz set bind----> ", false)
aimbot.autotpkey = aimbot.autotp:add_keybind("Teleport keybind")
aimbot.dtfix = menu.add_checkbox("AimBot","Enable Double Tap Ticks Fix", false)
aimbot.dt_speed = menu.add_slider("AimBot", "Set Double Tap Speed",0,21)
aimbot.fixdtspeed = menu.add_slider("AimBot", "Set Double Tap Fix Int",0,8)
aimbot.fixdttext = menu.add_text("AimBot", "if u unknow fix int set it = 2")

local visual = {}
local indicators = menu.add_multi_selection("HUD", "indicators", {"DoubleTap", "Safe Point", "Baim", "Lethal","Min DMG", "Hide Shots", "FakeDuck", "Fake-Lag", "Fake"})
local amgis = menu.add_checkbox("T1ny mark", "Enable Mark")
local shoppyinput = menu.add_text_input("T1ny mark", "Mark User Name")
local screen_size = render.get_screen_size()
visual.mindmg = menu.add_checkbox("HUD", "Show Min DMG", false)
local wantTimer = menu.add_checkbox("T1ny mark", "Enable Hit Logs", true)
local fontSelection = menu.add_selection("T1ny mark", "Chose Fonts", {"Regular", "Bold"})

local misc = {}
misc.killsay = menu.add_selection("Misc", "Killsay", {"NONE","[AD] Sun boy","[AD] T1ny.lua","Shitsays"})
misc.legfucks = menu.add_checkbox("misc","Leg Fucker")
misc.zero = menu.add_checkbox("misc","0 Pitch on land and Static Legs in air")
misc.configlockint = menu.add_slider("scripts config lock", "set your key INT", 0 , 10000)
misc.configlockkey = menu.add_checkbox("scripts config lock","i am ok! set the key!",false)
misc.configunlockint = menu.add_slider("scripts config locked", "input your key INT", 0 , 10000)
misc.configunlockkey = menu.add_checkbox("scripts config locked","i am ok! input the key!",false)

local aa = {}
aa.aamode = menu.add_selection("AntiAim","AA mode",{"O F F","Mode AA"})
--aa.modetankmode = menu.add_selection("Mode Tank", "Custom Mode",{"Auto","Stand","slow-walk","running","air","crouch"})

local yaw_base = menu.add_selection("auto Mode Tank", "Yaw Base", {"viewangle", "at target(crosshair)", "at target(distance)"})
local jitter_offset = menu.add_slider("auto Mode Tank", "Tank Angle", -180, 180)
local lfake_limit = menu.add_slider("auto Mode Tank", "Left Limit", 1, 60)
local rfake_limit = menu.add_slider("auto Mode Tank", "Right Limit", 1, 60)
local l_yaw_add = menu.add_slider("auto Mode Tank", "When Left Yaw", -50, 50)
local r_yaw_add = menu.add_slider("auto Mode Tank", "When Right Yaw", -50, 50)
local jitter_speed = menu.add_slider("auto Mode Tank", "Tank Speed", 1, 4)
local disabler = menu.add_multi_selection("auto Tank Disable","Tank disabler in...",{"on peek","on manual sideways","on manual backward","on hideshots", "on Freestanding"})

local key_name, key_bind = unpack(menu.find("antiaim","main","manual","invert desync"))
local ref_hide_shot, ref_onshot_key = unpack(menu.find("aimbot", "general", "exploits", "hideshots", "enable"))

local ref_auto_peek, ref_peek_key = unpack(menu.find("aimbot","general","misc","autopeek"))

local ref_freestand, ref_frees_key = unpack(menu.find("antiaim","main","auto direction","enable"))


local side_stand = menu.find("antiaim","main", "desync","side#stand")
local llimit_stand = menu.find("antiaim","main", "desync","left amount#stand")
local rlimit_stand = menu.find("antiaim","main", "desync","right amount#stand")
local side_move = menu.find("antiaim","main", "desync","side#move")
local llimit_move = menu.find("antiaim","main", "desync","left amount#move")
local rlimit_move = menu.find("antiaim","main", "desync","right amount#move")
local side_slowm = menu.find("antiaim","main", "desync","side#slow walk")
local llimit_slowm = menu.find("antiaim","main", "desync","left amount#slow walk")
local rlimit_slowm = menu.find("antiaim","main", "desync","right amount#slow walk")

local backup_cache = {
    side_stand = side_stand:get(),
    side_move = side_move:get(),
    side_slowm = side_slowm:get(),

    llimit_stand = llimit_stand:get(),
    rlimit_stand = rlimit_stand:get(),

    llimit_move = llimit_move:get(),
    rlimit_move = rlimit_move:get(),

    llimit_slowm = llimit_slowm:get(),
    rlimit_slowm = rlimit_slowm:get()
}

local vars = {
    yaw_base = 0,
    _jitter = 0,
    _yaw_add = 0,
    l_limit = 0,
    r_limit = 0,
    val_n = 0,
    desync_val = 0,
    yaw_offset = 0,
    temp_vars = 0,
    revs = 1,
    last_time = 0
}

local handle_yaw = 0

local font = render.create_font("Calibri Bold", 27, 670, e_font_flags.ANTIALIAS)
local color2 = color_t(255, 255, 255, 255)
local color3 = color_t(255, 0, 0, 255)
local col_1 = color_t(0, 0, 0, 150)
local col_2 = color_t(0, 0, 0, 0)
local fontsigma = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS)

local groups = {
    auto = {0},
    scout = {1},
    awp = {2},
    heavypistols = {3},
    pistols = {4},
    other = {5}
}
local math_funcs = {

    get_min_dmg = function(wpn_type)
        local menu_ref = menu.find("aimbot", wpn_type, "target overrides", "force min. damage")
        local force_lethal = menu.find("aimbot", wpn_type, "target overrides", "force lethal shot")
        local hitbox_ovr = menu.find("aimbot", wpn_type, "target overrides", "force hitbox")
        local force_sp = menu.find("aimbot", wpn_type, "target overrides", "force safepoint")
        local force_hc = menu.find("aimbot", wpn_type, "target overrides", "force hitchance")
        return {menu_ref[1]:get(), menu_ref[2]:get(), force_lethal[2]:get(), hitbox_ovr[2]:get(), force_sp[2]:get(),
                force_hc[2]:get()}
    end,
    vars = {
        angle = 0
    }
}
local enabled = true

local screen_size = render.get_screen_size()
local x = screen_size.x / 1.98
local y = screen_size.y / 2.01

local main_font = render.create_font("Verdana", 12, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local AutoO = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local ScoutO = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local DeagleO = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local RevolverO = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local PistolO = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local AwpO = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local Auto = menu.find("aimbot", "auto", "targeting","min. damage")
local Scout = menu.find("aimbot", "scout", "targeting","min. damage")
local Deagle = menu.find("aimbot", "deagle", "targeting","min. damage")
local Revolver = menu.find("aimbot", "revolver", "targeting","min. damage")
local Pistol = menu.find("aimbot", "pistols", "targeting","min. damage")
local Awp = menu.find("aimbot", "awp", "targeting","min. damage")

local AutoFO = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local ScoutFO = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local DeagleFO = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
local RevolverFO = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local PistolFO = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))
local AwpFO = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))

function menu_hidden()
    --print(mode_list:get())
    if mode_list:get() == 3 then
        aa.aamode:set_visible(true)
        if aa.aamode:get() == 2 then
            --aa.modetankmode:set_visible(true)
                jitter_offset:set_visible(true)
                jitter_speed:set_visible(true)
                lfake_limit:set_visible(true)
                rfake_limit:set_visible(true)
                l_yaw_add:set_visible(true)
                r_yaw_add:set_visible(true)
                yaw_base:set_visible(true)
                disabler:set_visible(true)
            
        else
            jitter_offset:set_visible(false)
            jitter_speed:set_visible(false)
            lfake_limit:set_visible(false)
            rfake_limit:set_visible(false)
            l_yaw_add:set_visible(false)
            r_yaw_add:set_visible(false)
            yaw_base:set_visible(false)
            disabler:set_visible(false)
            
        end
    else
        jitter_offset:set_visible(false)
        jitter_speed:set_visible(false)
        lfake_limit:set_visible(false)
        rfake_limit:set_visible(false)
        l_yaw_add:set_visible(false)
        r_yaw_add:set_visible(false)
        yaw_base:set_visible(false)
        disabler:set_visible(false)
        
        aa.aamode:set_visible(false)
    end
    if mode_list:get() == 1 then
        home.Changelogs:set_visible(true)
        home.Changelogs1:set_visible(true)
    else
        home.Changelogs:set_visible(false)
        home.Changelogs1:set_visible(false)
    end
    if mode_list:get() == 2 then
        aimbot.tpknife:set_visible(true)
        aimbot.autotp:set_visible(true)
        aimbot.dtfix:set_visible(true)
        aimbot.jumpscoutfix:set_visible(true)
        if aimbot.autotp:get() then
            aimbot.autotpkey:set_visible(true)
        else 
            aimbot.autotpkey:set_visible(false)
        end
        if aimbot.dtfix:get() then
            aimbot.dt_speed:set_visible(true)
            aimbot.fixdtspeed:set_visible(true)
            aimbot.fixdttext:set_visible(true)
        else 
            aimbot.dt_speed:set_visible(false)
            aimbot.fixdtspeed:set_visible(false)
            aimbot.fixdttext:set_visible(false)
        end
    else
        aimbot.tpknife:set_visible(false)
        aimbot.autotp:set_visible(false)
        aimbot.dtfix:set_visible(false)
        aimbot.autotpkey:set_visible(false)
        aimbot.dt_speed:set_visible(false)
        aimbot.fixdtspeed:set_visible(false)
        aimbot.fixdttext:set_visible(false)
        aimbot.jumpscoutfix:set_visible(false)
    end
    if mode_list:get() == 4 then
        indicators:set_visible(true)
        amgis:set_visible(true)
        wantTimer:set_visible(true)
        fontSelection:set_visible(true)
        visual.mindmg:set_visible(true)
        if amgis:get() == true then
            shoppyinput:set_visible(true)
        end
    else
        indicators:set_visible(false)
        amgis:set_visible(false)
        shoppyinput:set_visible(false)
        visual.mindmg:set_visible(false)
        wantTimer:set_visible(false)
        fontSelection:set_visible(false)
    end
    if mode_list:get() == 5 then
        misc.killsay:set_visible(true)
        misc.legfucks:set_visible(true)
        misc.zero:set_visible(true)
        misc.configlockint:set_visible(true)
        misc.configlockkey:set_visible(true)

    else
        misc.killsay:set_visible(false)
        misc.legfucks:set_visible(false)
        misc.zero:set_visible(false)
        misc.configlockint:set_visible(false)
        misc.configlockkey:set_visible(false)
    end
    if misc.configlockkey:get() == true then
        misc.killsay:set_visible(false)
        misc.legfucks:set_visible(false)
        misc.zero:set_visible(false)
        misc.configlockint:set_visible(false)
        misc.configlockkey:set_visible(false)
        aimbot.tpknife:set_visible(false)
        aimbot.autotp:set_visible(false)
        aimbot.dtfix:set_visible(false)
        aimbot.autotpkey:set_visible(false)
        aimbot.dt_speed:set_visible(false)
        aimbot.fixdtspeed:set_visible(false)
        aimbot.fixdttext:set_visible(false)
        home.Changelogs:set_visible(false)
        home.Changelogs1:set_visible(false)
        jitter_offset:set_visible(false)
        jitter_speed:set_visible(false)
        lfake_limit:set_visible(false)
        rfake_limit:set_visible(false)
        l_yaw_add:set_visible(false)
        r_yaw_add:set_visible(false)
        yaw_base:set_visible(false)
        disabler:set_visible(false)
        aa.aamode:set_visible(false)
        aimbot.jumpscoutfix:set_visible(false)
        misc.configunlockint:set_visible(true)
        misc.configunlockkey:set_visible(true)
    else
        misc.configunlockint:set_visible(false)
        misc.configunlockkey:set_visible(false)
    end
end


local function onPaint()
    if(fonts == nil) then
        fonts =
        {
            regular = render.create_font("Verdana", 20, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW);
            bold = render.create_font("Verdana Bold", 20, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW);
        }
    end

    if (engine.is_connected() ~= true) then
        return
    end

    local time = global_vars.frame_time()

    local screenSize = render.get_screen_size()
    local screenWidth = screenSize.x
    local screenHeight = screenSize.y

    for i = 1, #logs do
        local log = logs[i]
        if log == nil then goto continue
        end
        local x = screenWidth / 2
        local y = screenHeight / 1.25 + (i * 15)
        local alpha = 0

        if (log.state == 'appearing') then
            -- Fade in.
            local progress = log.currentTime / log.lifeTime.fadeIn
            x = x - Lerp(log.offset, 0, Ease(progress))
            alpha = Lerp(0, 255, Ease(progress))

            log.currentTime = log.currentTime + time
            if (log.currentTime >= log.lifeTime.fadeIn) then
                log.state = 'visible'

                -- Reset time.
                log.currentTime = 0
            end


        elseif(log.state == 'visible') then
        -- Fully opaque.
        alpha = 255

        log.currentTime = log.currentTime + time
        if (log.currentTime >= log.lifeTime.visible) then
            log.state = 'disappearing'

            -- Reset Time.
            log.currentTime = 0
        end

        elseif(log.state == 'disappearing') then
            -- Fade out.
            local progress = log.currentTime / log.lifeTime.fadeOut
            x = x + Lerp(0, log.offset, Ease(progress))
            alpha = Lerp(255, 0, Ease(progress))

            log.currentTime = log.currentTime + time
            if(log.currentTime >= log.lifeTime.fadeOut) then
                table.remove(logs, i)
                goto continue
            end
        end

        -- Increase the total time.
        log.totalTime = log.totalTime + time

        alpha = math.floor(alpha)
        local white = color_t(236, 236, 236, alpha)
        local accent_color_text, accent_color_color = unpack(menu.find("misc", "main", "config", "accent color"))
        local detail = accent_color_color:get()
        detail.a = alpha

        local message = {}

        -- Add header and body to message
        local combined = {}

        for a = 1, #log.header do
            local t = log.header[a]
            table.insert(combined, t)
        end

        for a = 1, #log.body do
            local t = log.body[a]
            table.insert(combined, t)
        end

        for j = 1, #combined do
            local data = combined[j]

            local text = tostring(data[1])
            local color = data[2]

            -- Push the data to the message.
            table.insert(message,{text, color and detail or white})
        end

        -- Add the total lifetime to the message.
        if wantTimer:get() then
            table.insert(message,{' - ', white})
            local temp = (log.lifeTime.fadeIn + log.lifeTime.visible + log.lifeTime.fadeOut) - log.totalTime
            table.insert(message, {string.format("%.1fs", temp), detail})
        elseif not wantTimer:get() then
            
        end
        -- Draw log.
        local render_font = nil
        if render_font == nil then
        local stringFont = fontSelection:get()
        if stringFont == 1 then render_font = fonts.regular
            else render_font = fonts.bold
            end
        end

        render.string(x, y, message, 'c', render_font)
        ::continue::
    end
end

local hitgroupMap = {
    [0] = 'generic',
    [1] = 'head',
    [2] = 'chest',
    [3] = 'stomach',
    [4] = 'left arm',
    [5] = 'right arm',
    [6] = 'left leg',
    [7] = 'right leg',
    [8] = 'neck',
    [9] = 'gear'
  }

function on_aimbot_hit(hit)
    local name = hit.player:get_name()
    local hitbox = hitgroupMap[hit.hitgroup]
    local damage = hit.damage
    local health = hit.player:get_prop('m_iHealth')

    AddLog('PlayerHitEvent', {
        {'Hit ', false};
        {name .. ' ', true};
        {'in the ', false};
        {hitbox .. ' ', true};
        {'for ', false};
        {damage .. ' ', true};
        {'damage (remaining: ', false};
        {health, true};
        {')', false};
    })
end

function on_aimbot_miss(miss)
    local name = miss.player:get_name()
    local hitbox = hitgroupMap[miss.aim_hitgroup]
    local damage = miss.aim_damage
    local health = miss.player:get_prop('m_iHealth')
    local reason = miss.reason_string

    AddLog('PlayerHitEvent', {
        {'Missed ', false};
        {name .. ' ', true};
        {'in the ', false};
        {hitbox .. ' ', true};
        {'due to ', false};
        {reason .. ' ', true};
    })
end

function AddLog(type, body)
    local log = {
        type = type,
        state = 'appearing',
        offset = 250,
        currentTime = 0,
        totalTime = 0,
        lifeTime = {
            fadeIn = 0.75,
            visible = 3,
            fadeOut = 0.75
        },
        header = {
            {'[', false},
            {'T1ny-Yaw.lua', true},
            {'] ', false},
        },
        body = body
    }
    table.insert(logs, log)
end

function Lerp(from, to, progress) 
    return from + (to - from) * progress
end

function Ease(progress)
    return progress < 0.5 and 15 * progress * progress * progress * progress * progress or 1 - math.pow(-2 * progress + 2, 5) / 2
end

render.string = function(x, y, data, alignment, font)
    -- Get total length for all the data.
    local length = 0
    for i = 1, #data do
        local text = data[i][1]
        
        local size = render.get_text_size(font, text)
        length = length + size.x
    end

    local offset = x
    for i = 1, #data do
        local text = data[i][1]
        local color = data[i][2]

        local sX = offset
        local sY = y

        -- Adjust position based on alignment
        if(alignment) == 'l' then
            sX = offset - length
        elseif(alignment) == 'c' then
            sX = offset - (length / 2)
        elseif(alignment) == 'r' then
            sX = offset
        end



        -- Draw the text.

        render.text(font, text, vec2_t(sX + 1, sY + 1), color_t(16, 16, 16, color.a))
        render.text(font, text, vec2_t(sX, sY), color)

        -- Add the length of the text to the offset.
        local size = render.get_text_size(font, text)
        offset = offset + size.x
    end
end



local function configlock()
    if misc.configlockkey:get() == true then
        if misc.configlockint:get() == misc.configunlockint:get() and misc.configlockkey:get() == misc.configunlockkey:get() then
            misc.configlockkey:set(false)
            misc.configunlockint:set(0)
        elseif misc.configlockint:get() ~= misc.configunlockint:get() and misc.configlockkey:get() == misc.configunlockkey:get() then
            misc.configunlockkey:set(false)
            misc.configunlockint:set(0)
        end
    end
end


local function getweapon() --dt knife
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    local weapon_name = nil
    if local_player:get_prop("m_iHealth") > 0 then
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end
        weapon_name = active_weapon:get_name()
    else return end
    return weapon_name
end
local function tpd(event)
    knife_damage = false
    if event.name == "player_hurt" then
    if event.weapon == "knife" then
        exploits.block_recharge()
        knife_damage = true
        end
    end
end
local function dt_knife()
    local key_pressed = input.is_key_pressed(e_keys.MOUSE_LEFT)
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    if local_player:get_prop("m_iHealth") > 0 and getweapon()=="knife" then

        if dt_ref[2]:get() and key_pressed == true and not menu.is_open() then
            exploits.force_uncharge()
        end
        if dt_ref[2]:get() and knife_damage == true then

            exploits.force_uncharge()
            
        end
        exploits.allow_recharge()
    end
end

local function are_have_weapon(ent) --autotp
    if not ent:is_alive() or not ent:get_active_weapon() then return end
    local t_cur_wep = ent:get_active_weapon():get_class_name()
    return t_cur_wep ~= "CKnife" and t_cur_wep ~= "CC4" and t_cur_wep ~= "CMolotovGrenade" and t_cur_wep ~= "CSmokeGrenade" and t_cur_wep ~= "CHEGrenade" and t_cur_wep ~= "CWeaponTaser"
end
local function are_them_visibles(ent)
    local local_p = entity_list:get_local_player()
    local generic_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    local left_arm_pos = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local right_arm_pos = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if local_p:is_point_visible(generic_pos) or local_p:is_point_visible(left_arm_pos) or local_p:is_point_visible(right_arm_pos) then return true else return false end
end
local function strangerdranger(cmd)
    if not aimbot.autotpkey:get() then return end
    if ragebot.get_autopeek_pos() then return end
    local enemies = entity_list.get_players(true)
    for i,v in ipairs(enemies) do
        if are_them_visibles(v) and are_have_weapon(v) then
            exploits.force_uncharge()
            exploits.block_recharge()
        else
            exploits.allow_recharge()
        end
    end
end

local function setdtspeed()-- dtspeed
    if dt_ref[2]:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(aimbot.dt_speed:get() + aimbot.fixdtspeed:get())
        cvars.cl_clock_correction:set_int(0)
        cvars.cl_clock_correction_adjustment_max_amount:set_int(450)
    else
        cvars.sv_maxusrcmdprocessticks:set_int(16)
        cvars.cl_clock_correction:set_int(1)
    end
end

local function mindmg()
    if getweapon() == "ssg08" then
        if ScoutO[2]:get() then
            render.text(main_font, tostring(ScoutFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        else visual.mindmg:get()
            render.text(main_font, tostring(Scout:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        end
    elseif getweapon() == "deagle" then
        if DeagleO[2]:get() then
            render.text(main_font, tostring(DeagleFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        else visual.mindmg:get() 
            render.text(main_font, tostring(Deagle:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        end
    elseif getweapon() == "revolver" then
        if RevolverO[2]:get() then
            render.text(main_font, tostring(RevolverFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        else visual.mindmg:get() 
            render.text(main_font, tostring(Revolver:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        end
    elseif getweapon() == "awp" then
        if AwpO[2]:get() then
            render.text(main_font, tostring(AwpFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        else visual.mindmg:get() 
            render.text(main_font, tostring(Awp:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        end
    elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
        if AutoO[2]:get() then
            render.text(main_font, tostring(AutoFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        else visual.mindmg:get() 
            render.text(main_font, tostring(Auto:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        end
    elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
        if PistolO[2]:get() then
            render.text(main_font, tostring(PistolFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        else visual.mindmg:get() 
            render.text(main_font, tostring(Pistol:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
        end
    end
end

--killsay
local function table_lengh(data) --grabbing how many killsay quotes are in our table
    if type(data) ~= 'table' then
        return 0													
    end
    local count = 0
    for _ in pairs(data) do
        count = count + 1
    end
    return count
end

local function killsay(event)
    local lp = entity_list.get_local_player() --grabbing out local player
    local kill_cmd = 'say ' .. killsays[math.random(table_lengh(killsays))] --randomly selecting a killsay
    if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end --checking if the killer is us
    engine.execute_cmd(kill_cmd) --executing the killsay command
end



local function calcs()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end
    if not local_player:is_alive() then
        math_funcs.vars.angle = 0

    else
        math_funcs.vars.angle = antiaim.get_max_desync_range()
    end
end

callbacks.add(e_callbacks.ANTIAIM, calcs)

local groups = {
    ['auto'] = 0,
    ['scout'] = 1,
    ['awp'] = 2,
    ['heavy pistols'] = 3,
    ['pistols'] = 4,
    ['other'] = 5
}
local current_min = nil
local key_active = nil
local force_lethal = nil
local hitbox_ovr = nil
local force_sp = nil
local force_hc = nil

local function get_weapon_group() -- // Classy also did a func like this, might be better not sure.
    for key, value in pairs(groups) do
        if value == ragebot.get_active_cfg() then
            current_min = math_funcs.get_min_dmg(key)[1];
            key_active = math_funcs.get_min_dmg(key)[2];
            force_lethal = math_funcs.get_min_dmg(key)[3];
            hitbox_ovr = math_funcs.get_min_dmg(key)[4];
            force_sp = math_funcs.get_min_dmg(key)[5];
            force_hc = math_funcs.get_min_dmg(key)[6];
        end
    end

    return {tostring(current_min), key_active, force_lethal, hitbox_ovr, force_sp, force_hc};
end
local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")

local function gradient(x, y, w, h, col1, col2)
    render.rect_fade(vec2_t(x, y - 4), vec2_t(w / 4, h), col2, col1, true)
    render.rect_fade(vec2_t(x + (w / 4), y - 4), vec2_t(w / 4, h), col1, col2, true)
end

local function dnn()
    local maxdes = math_funcs.vars.angle
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end
    if not local_player:is_alive() then
        return
    end
    
    local pos = vec2_t(0, 0)
    local addpos = vec2_t(0, 32)
    local startpos = vec2_t(screen_size.x * 0.00741666666, screen_size.y * 0.67777777777)
    local function default(str, color)
        local text_size = render.get_text_size(font, str)
        gradient(9, pos.y + 4, 70, 28, col_1, col_2)
        render.text(font, str, pos, color)
        pos = pos - addpos
    end

    local function circle(str, color, percent)
        local text_size = render.get_text_size(font, str)
        gradient(9, pos.y + 4, 70, 28, col_1, col_2)
        render.text(font, str, pos, color)
        render.progress_circle(pos + vec2_t(text_size.x * 1.3, text_size.y / 1.9), 5, color_t(0, 0, 0, 155), 3, 1)
        render.progress_circle(pos + vec2_t(text_size.x * 1.3, text_size.y / 1.9), 5, color, 3, percent)
        pos = pos - addpos

    end

    if amgis:get() then
        
        local text_sizenigma = render.get_text_size(fontsigma, "@" .. shoppyinput:get())
        local text_sizeligma = render.get_text_size(fontsigma, "T1ny-Yaw.lua/")
        render.text(fontsigma, "T1ny-Yaw.lua/", vec2_t(screen_size.x - text_sizenigma.x - text_sizeligma.x, 0), color_t(255, 255, 255, 255))
        render.text(fontsigma, " " .. shoppyinput:get(), vec2_t(screen_size.x - text_sizenigma.x, 0), color_t(50, 255, 50, 255))
    end

    pos = startpos
    if indicators:get('Fake') then
        circle("FAKE", color_t(math.floor(255 - maxdes * 1.6), math.floor(maxdes * 4), 50, 255), maxdes / 58)
    end
    if indicators:get('Fake-Lag') then
        circle("FL ", color_t(math.floor(255 - engine.get_choked_commands() * 360 / 14 * 0.25), math.floor(engine.get_choked_commands() * 360 / 14 * 0.5), 50, 255), engine.get_choked_commands() / 14)
    end

    if indicators:get('Min DMG') and get_weapon_group()[2] then
        default("DMG: " .. get_weapon_group()[1], color2)
    end

    if indicators:get("Lethal") and get_weapon_group()[3] then
        default("LETHAL", color2)
    end

    if indicators:get('Baim') and get_weapon_group()[4] then
        default("BAIM", color2)
    end

    if indicators:get('Safe Point') and get_weapon_group()[5] then
        default("SAFE", color2)
    end

    if indicators:get('FakeDuck') and antiaim.is_fakeducking() then
        default("DUCK", color2)
    end

    if hideshots[2]:get() then
        default("ONSHOT", color_t(150, 200, 60, 255))
    end

    if dt_ref[2]:get() then
        if exploits.get_charge() == 14 and indicators:get('DoubleTap') then
            default("DT", color2)
        elseif exploits.get_charge() ~= 14 and indicators:get('DoubleTap') then
            default("DT", color3)
        end
    end

end

--[[callbacks.add(e_callbacks.PAINT, function () --ui main
    if rankked ~= "Beta" then print("You do not have this lua") return end
    if not enable:get() then return end
    --print("1")
    menu_hidden()
    if aimbot.dtfix:get() then
        setdtspeed()
    end
end)--]]


local function on_event(event) -- event main
    tpd(event)
end
local function eventdie(event) -- player die main
    if misc.killsay:get() == 1 then
        return
    elseif misc.killsay:get() == 2 then
        killsays = killsay1
        killsay(event)
    elseif misc.killsay:get() == 3 then
        killsays = killsay2
        killsay(event)
    elseif misc.killsay:get() == 4 then
        killsays = killsay3
        killsay(event)
    end
end

local function run_command()--command main
    if aimbot.autotp:get() then
        strangerdranger(cmd)
    end
    if aimbot.tpknife:get() then
        dt_knife()
    end
    
end

function ent_speed_2d(entity) --scortfix
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    local velocity_x = entity:get_prop("m_vecVelocity[0]")
    local velocity_y = entity:get_prop("m_vecVelocity[1]")
    return math.sqrt((velocity_x * velocity_x) + (velocity_y * velocity_y))
end
local function Local_GetProp(prop_name, ...)
    local player = entity_list.get_local_player()
    return player:get_prop(prop_name, ...)
end
local autostrafe = menu.find("misc","main","movement","autostrafer")
local function scortfix()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    if ent_speed_2d(entity_list.get_local_player()) > 10 and (Local_GetProp("m_fFlags") == 256 or Local_GetProp("m_fFlags") == 262) then
        autostrafe:set(true)
        autostrafe:set(true)
    else
        autostrafe:set(false)
        autostrafe:set(false)
    end
end

local function on_shutdown() --禁用函数
    side_stand:set(backup_cache.side_stand)
    side_move:set(backup_cache.side_move)
    side_slowm:set(backup_cache.side_slowm)

    llimit_stand:set(backup_cache.llimit_stand)
    rlimit_stand:set(backup_cache.rlimit_stand)

    llimit_move:set(backup_cache.llimit_move)
    rlimit_move:set(backup_cache.rlimit_move)

    llimit_slowm:set(backup_cache.llimit_slowm)
    rlimit_slowm:set(backup_cache.rlimit_slowm)
end

local normalize_yaw = function(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end

    return yaw
end

local function calc_shit(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then
        return 0
    end
    
    return math.deg(math.atan2(ydelta, xdelta))
end

local function calc_angle(src, dst)
    local vecdelta = vec3_t(dst.x - src.x, dst.y - src.y, dst.z - src.z)
    local angles = angle_t(math.atan2(-vecdelta.z, math.sqrt(vecdelta.x^2 + vecdelta.y^2)) * 180.0 / math.pi, (math.atan2(vecdelta.y, vecdelta.x) * 180.0 / math.pi), 0.0)
    return angles
end

local function calc_distance(src, dst)
    return math.sqrt(math.pow(src.x - dst.x, 2) + math.pow(src.y - dst.y, 2) + math.pow(src.z - dst.z, 2) )
end

local function get_distance_closest_enemy()
    local enemies_only = entity_list.get_players(true) 
    if enemies_only == nil then return end
    local local_player = entity_list.get_local_player()
    local local_origin = local_player:get_render_origin()
    local bestenemy = nil
    local dis = 10000
    for _, enemy in pairs(enemies_only) do 
        local enemy_origin = enemy:get_render_origin()
        local cur_distance = calc_distance(enemy_origin, local_origin)
        if cur_distance < dis then
            dis = cur_distance
            bestenemy = enemy
        end
    end
    return bestenemy
end

local function get_crosshair_closet_enemy()
    local enemies_only = entity_list.get_players(true) 
    if enemies_only == nil then return end
    local local_player = entity_list.get_local_player()
    local local_eyepos = local_player:get_eye_position()
    local local_angles = engine.get_view_angles()
    local bestenemy = nil
    local fov = 180
    for _, enemy in pairs(enemies_only) do 
        local enemy_origin = enemy:get_render_origin()
        local cur_fov = math.abs(normalize_yaw(calc_shit(local_eyepos.x - enemy_origin.x, local_eyepos.y - enemy_origin.y) - local_angles.y + 180))
        if cur_fov < fov then
            fov = cur_fov
            bestenemy = enemy
        end
    end

    return bestenemy
end

function on_paint()
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    local local_eyepos = local_player:get_eye_position()
    local view_angle = engine.get_view_angles()
    if yaw_base:get() == 1 then
        vars.yaw_base = view_angle.y
    elseif yaw_base:get() == 2 then
        vars.yaw_base = get_crosshair_closet_enemy() == nil and view_angle.y or calc_angle(local_eyepos, get_crosshair_closet_enemy():get_render_origin()).y
    elseif yaw_base:get() == 3 then  
        vars.yaw_base = get_distance_closest_enemy() == nil and view_angle.y or calc_angle(local_eyepos, get_distance_closest_enemy():get_render_origin()).y
    end
end

function on_antiaim(ctx)
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    if disabler:get(1) then 
        if ref_peek_key:get() == true then 
            on_shutdown()
            return
        end
    end
    if disabler:get(2) then
        if antiaim.get_manual_override() == 1 or antiaim.get_manual_override() == 3 then 
            on_shutdown()
            return
        end
    end
    if disabler:get(3) then 
        if antiaim.get_manual_override() == 2 then 
            on_shutdown()
            return
        end
    end
    if disabler:get(4) then
        if ref_onshot_key:get() then 
            on_shutdown()
            return
        end
    end
    if disabler:get(5) then
        if ref_frees_key:get() then
            on_shutdown()
            return
        end
    end

    local speed = 5 - jitter_speed:get()

    if math.abs(global_vars.tick_count() - vars.temp_vars) > speed then
       vars.revs = vars.revs == 1 and 0 or 1
       vars.temp_vars = global_vars.tick_count()
    end

    local is_invert = vars.revs == 1 and key_bind:get() and false or true

    vars._jitter = jitter_offset:get()
    vars.l_limit = lfake_limit:get()
    vars.r_limit = rfake_limit:get()
    
    _l_yaw_add = l_yaw_add:get()
    _r_yaw_add = r_yaw_add:get()

    vars.val_n = vars.revs == 1 and vars._jitter or -(vars._jitter)
    vars.desync_val = vars.val_n > 0 and -(vars.l_limit/60) or vars.r_limit/60
    vars._yaw_add = vars.val_n > 0 and _l_yaw_add or _r_yaw_add

    handle_yaw = normalize_yaw(vars.val_n + vars._yaw_add + vars.yaw_base + 180)

    ctx:set_invert_desync(is_invert)
    ctx:set_desync(vars.desync_val)
    ctx:set_yaw(handle_yaw)
    
    side_stand:set(vars.val_n > 0 and 1 or 2)
    side_move:set(vars.val_n > 0 and 1 or 2)
    side_slowm:set(vars.val_n > 0 and 1 or 2)

    llimit_stand:set(vars.l_limit * 10/6)
    rlimit_stand:set(vars.r_limit * 10/6)

    llimit_move:set(vars.l_limit * 10/6)
    rlimit_move:set(vars.r_limit * 10/6)

    llimit_slowm:set(vars.l_limit * 10/6)
    rlimit_slowm:set(vars.r_limit * 10/6)
end


callbacks.add(e_callbacks.PAINT, function () --ui main
    local local_player = entity_list.get_local_player()
    if not enable:get() then return end
    menu_hidden()
    configlock()
    if (aimbot.jumpscoutfix:get() == true) then
        scortfix()
    end
    if aimbot.dtfix:get() then
        setdtspeed()
    end
    if visual.mindmg:get() then
        mindmg()
    end
    dnn()
end)
local function on_shutdown()
    print("期待下次使用")
end

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.RUN_COMMAND, run_command)
callbacks.add(e_callbacks.EVENT, on_event)
callbacks.add(e_callbacks.EVENT, eventdie,"player_death")
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
callbacks.add(e_callbacks.EVENT, ent_speed_2d, "entity")
callbacks.add(e_callbacks.PAINT,onPaint)
callbacks.add(e_callbacks.AIMBOT_MISS,on_aimbot_miss)
callbacks.add(e_callbacks.AIMBOT_HIT,on_aimbot_hit)